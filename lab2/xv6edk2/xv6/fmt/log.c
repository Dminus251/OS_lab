4900 #include "types.h"
4901 #include "defs.h"
4902 #include "param.h"
4903 #include "spinlock.h"
4904 #include "sleeplock.h"
4905 #include "fs.h"
4906 #include "buf.h"
4907 
4908 // Simple logging that allows concurrent FS system calls.
4909 //
4910 // A log transaction contains the updates of multiple FS system
4911 // calls. The logging system only commits when there are
4912 // no FS system calls active. Thus there is never
4913 // any reasoning required about whether a commit might
4914 // write an uncommitted system call's updates to disk.
4915 //
4916 // A system call should call begin_op()/end_op() to mark
4917 // its start and end. Usually begin_op() just increments
4918 // the count of in-progress FS system calls and returns.
4919 // But if it thinks the log is close to running out, it
4920 // sleeps until the last outstanding end_op() commits.
4921 //
4922 // The log is a physical re-do log containing disk blocks.
4923 // The on-disk log format:
4924 //   header block, containing block #s for block A, B, C, ...
4925 //   block A
4926 //   block B
4927 //   block C
4928 //   ...
4929 // Log appends are synchronous.
4930 
4931 // Contents of the header block, used for both the on-disk header block
4932 // and to keep track in memory of logged block# before commit.
4933 struct logheader {
4934   int n;
4935   int block[LOGSIZE];
4936 };
4937 
4938 struct log {
4939   struct spinlock lock;
4940   int start;
4941   int size;
4942   int outstanding; // how many FS sys calls are executing.
4943   int committing;  // in commit(), please wait.
4944   int dev;
4945   struct logheader lh;
4946 };
4947 
4948 
4949 
4950 struct log log;
4951 
4952 static void recover_from_log(void);
4953 static void commit();
4954 
4955 void
4956 initlog(int dev)
4957 {
4958   if (sizeof(struct logheader) >= BSIZE)
4959     panic("initlog: too big logheader");
4960 
4961   struct superblock sb;
4962   initlock(&log.lock, "log");
4963   readsb(dev, &sb);
4964   log.start = sb.logstart;
4965   log.size = sb.nlog;
4966   log.dev = dev;
4967   recover_from_log();
4968 }
4969 
4970 // Copy committed blocks from log to their home location
4971 static void
4972 install_trans(void)
4973 {
4974   int tail;
4975 
4976   for (tail = 0; tail < log.lh.n; tail++) {
4977     struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
4978     struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
4979     memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
4980     bwrite(dbuf);  // write dst to disk
4981     brelse(lbuf);
4982     brelse(dbuf);
4983   }
4984 }
4985 
4986 // Read the log header from disk into the in-memory log header
4987 static void
4988 read_head(void)
4989 {
4990   struct buf *buf = bread(log.dev, log.start);
4991   struct logheader *lh = (struct logheader *) (buf->data);
4992   int i;
4993   log.lh.n = lh->n;
4994   for (i = 0; i < log.lh.n; i++) {
4995     log.lh.block[i] = lh->block[i];
4996   }
4997   brelse(buf);
4998 }
4999 
5000 // Write in-memory log header to disk.
5001 // This is the true point at which the
5002 // current transaction commits.
5003 static void
5004 write_head(void)
5005 {
5006   struct buf *buf = bread(log.dev, log.start);
5007   struct logheader *hb = (struct logheader *) (buf->data);
5008   int i;
5009   hb->n = log.lh.n;
5010   for (i = 0; i < log.lh.n; i++) {
5011     hb->block[i] = log.lh.block[i];
5012   }
5013   bwrite(buf);
5014   brelse(buf);
5015 }
5016 
5017 static void
5018 recover_from_log(void)
5019 {
5020   read_head();
5021   install_trans(); // if committed, copy from log to disk
5022   log.lh.n = 0;
5023   write_head(); // clear the log
5024 }
5025 
5026 // called at the start of each FS system call.
5027 void
5028 begin_op(void)
5029 {
5030   acquire(&log.lock);
5031   while(1){
5032     if(log.committing){
5033       sleep(&log, &log.lock);
5034     } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
5035       // this op might exhaust log space; wait for commit.
5036       sleep(&log, &log.lock);
5037     } else {
5038       log.outstanding += 1;
5039       release(&log.lock);
5040       break;
5041     }
5042   }
5043 }
5044 
5045 
5046 
5047 
5048 
5049 
5050 // called at the end of each FS system call.
5051 // commits if this was the last outstanding operation.
5052 void
5053 end_op(void)
5054 {
5055   int do_commit = 0;
5056 
5057   acquire(&log.lock);
5058   log.outstanding -= 1;
5059   if(log.committing)
5060     panic("log.committing");
5061   if(log.outstanding == 0){
5062     do_commit = 1;
5063     log.committing = 1;
5064   } else {
5065     // begin_op() may be waiting for log space,
5066     // and decrementing log.outstanding has decreased
5067     // the amount of reserved space.
5068     wakeup(&log);
5069   }
5070   release(&log.lock);
5071 
5072   if(do_commit){
5073     // call commit w/o holding locks, since not allowed
5074     // to sleep with locks.
5075     commit();
5076     acquire(&log.lock);
5077     log.committing = 0;
5078     wakeup(&log);
5079     release(&log.lock);
5080   }
5081 }
5082 
5083 // Copy modified blocks from cache to log.
5084 static void
5085 write_log(void)
5086 {
5087   int tail;
5088 
5089   for (tail = 0; tail < log.lh.n; tail++) {
5090     struct buf *to = bread(log.dev, log.start+tail+1); // log block
5091     struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
5092     memmove(to->data, from->data, BSIZE);
5093     bwrite(to);  // write the log
5094     brelse(from);
5095     brelse(to);
5096   }
5097 }
5098 
5099 
5100 static void
5101 commit()
5102 {
5103   if (log.lh.n > 0) {
5104     write_log();     // Write modified blocks from cache to log
5105     write_head();    // Write header to disk -- the real commit
5106     install_trans(); // Now install writes to home locations
5107     log.lh.n = 0;
5108     write_head();    // Erase the transaction from the log
5109   }
5110 }
5111 
5112 // Caller has modified b->data and is done with the buffer.
5113 // Record the block number and pin in the cache with B_DIRTY.
5114 // commit()/write_log() will do the disk write.
5115 //
5116 // log_write() replaces bwrite(); a typical use is:
5117 //   bp = bread(...)
5118 //   modify bp->data[]
5119 //   log_write(bp)
5120 //   brelse(bp)
5121 void
5122 log_write(struct buf *b)
5123 {
5124   int i;
5125 
5126   if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
5127     panic("too big a transaction");
5128   if (log.outstanding < 1)
5129     panic("log_write outside of trans");
5130 
5131   acquire(&log.lock);
5132   for (i = 0; i < log.lh.n; i++) {
5133     if (log.lh.block[i] == b->blockno)   // log absorbtion
5134       break;
5135   }
5136   log.lh.block[i] = b->blockno;
5137   if (i == log.lh.n)
5138     log.lh.n++;
5139   b->flags |= B_DIRTY; // prevent eviction
5140   release(&log.lock);
5141 }
5142 
5143 
5144 
5145 
5146 
5147 
5148 
5149 
