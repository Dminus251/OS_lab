6050 //
6051 // File descriptors
6052 //
6053 
6054 #include "types.h"
6055 #include "defs.h"
6056 #include "param.h"
6057 #include "fs.h"
6058 #include "spinlock.h"
6059 #include "sleeplock.h"
6060 #include "file.h"
6061 
6062 struct devsw devsw[NDEV];
6063 struct {
6064   struct spinlock lock;
6065   struct file file[NFILE];
6066 } ftable;
6067 
6068 void
6069 fileinit(void)
6070 {
6071   initlock(&ftable.lock, "ftable");
6072 }
6073 
6074 // Allocate a file structure.
6075 struct file*
6076 filealloc(void)
6077 {
6078   struct file *f;
6079 
6080   acquire(&ftable.lock);
6081   for(f = ftable.file; f < ftable.file + NFILE; f++){
6082     if(f->ref == 0){
6083       f->ref = 1;
6084       release(&ftable.lock);
6085       return f;
6086     }
6087   }
6088   release(&ftable.lock);
6089   return 0;
6090 }
6091 
6092 
6093 
6094 
6095 
6096 
6097 
6098 
6099 
6100 // Increment ref count for file f.
6101 struct file*
6102 filedup(struct file *f)
6103 {
6104   acquire(&ftable.lock);
6105   if(f->ref < 1)
6106     panic("filedup");
6107   f->ref++;
6108   release(&ftable.lock);
6109   return f;
6110 }
6111 
6112 // Close file f.  (Decrement ref count, close when reaches 0.)
6113 void
6114 fileclose(struct file *f)
6115 {
6116   struct file ff;
6117 
6118   acquire(&ftable.lock);
6119   if(f->ref < 1)
6120     panic("fileclose");
6121   if(--f->ref > 0){
6122     release(&ftable.lock);
6123     return;
6124   }
6125   ff = *f;
6126   f->ref = 0;
6127   f->type = FD_NONE;
6128   release(&ftable.lock);
6129 
6130   if(ff.type == FD_PIPE)
6131     pipeclose(ff.pipe, ff.writable);
6132   else if(ff.type == FD_INODE){
6133     begin_op();
6134     iput(ff.ip);
6135     end_op();
6136   }
6137 }
6138 
6139 
6140 
6141 
6142 
6143 
6144 
6145 
6146 
6147 
6148 
6149 
6150 // Get metadata about file f.
6151 int
6152 filestat(struct file *f, struct stat *st)
6153 {
6154   if(f->type == FD_INODE){
6155     ilock(f->ip);
6156     stati(f->ip, st);
6157     iunlock(f->ip);
6158     return 0;
6159   }
6160   return -1;
6161 }
6162 
6163 // Read from file f.
6164 int
6165 fileread(struct file *f, char *addr, int n)
6166 {
6167   int r;
6168 
6169   if(f->readable == 0)
6170     return -1;
6171   if(f->type == FD_PIPE)
6172     return piperead(f->pipe, addr, n);
6173   if(f->type == FD_INODE){
6174     ilock(f->ip);
6175     if((r = readi(f->ip, addr, f->off, n)) > 0)
6176       f->off += r;
6177     iunlock(f->ip);
6178     return r;
6179   }
6180   panic("fileread");
6181 }
6182 
6183 
6184 
6185 
6186 
6187 
6188 
6189 
6190 
6191 
6192 
6193 
6194 
6195 
6196 
6197 
6198 
6199 
6200 // Write to file f.
6201 int
6202 filewrite(struct file *f, char *addr, int n)
6203 {
6204   int r;
6205 
6206   if(f->writable == 0)
6207     return -1;
6208   if(f->type == FD_PIPE)
6209     return pipewrite(f->pipe, addr, n);
6210   if(f->type == FD_INODE){
6211     // write a few blocks at a time to avoid exceeding
6212     // the maximum log transaction size, including
6213     // i-node, indirect block, allocation blocks,
6214     // and 2 blocks of slop for non-aligned writes.
6215     // this really belongs lower down, since writei()
6216     // might be writing a device like the console.
6217     int max = ((MAXOPBLOCKS-1-1-2) / 2) * 512;
6218     int i = 0;
6219     while(i < n){
6220       int n1 = n - i;
6221       if(n1 > max)
6222         n1 = max;
6223 
6224       begin_op();
6225       ilock(f->ip);
6226       if ((r = writei(f->ip, addr + i, f->off, n1)) > 0)
6227         f->off += r;
6228       iunlock(f->ip);
6229       end_op();
6230 
6231       if(r < 0)
6232         break;
6233       if(r != n1)
6234         panic("short filewrite");
6235       i += r;
6236     }
6237     return i == n ? n : -1;
6238   }
6239   panic("filewrite");
6240 }
6241 
6242 
6243 
6244 
6245 
6246 
6247 
6248 
6249 
