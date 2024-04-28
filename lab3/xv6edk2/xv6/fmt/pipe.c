6950 #include "types.h"
6951 #include "defs.h"
6952 #include "param.h"
6953 #include "mmu.h"
6954 #include "proc.h"
6955 #include "fs.h"
6956 #include "spinlock.h"
6957 #include "sleeplock.h"
6958 #include "file.h"
6959 
6960 #define PIPESIZE 512
6961 
6962 struct pipe {
6963   struct spinlock lock;
6964   char data[PIPESIZE];
6965   uint nread;     // number of bytes read
6966   uint nwrite;    // number of bytes written
6967   int readopen;   // read fd is still open
6968   int writeopen;  // write fd is still open
6969 };
6970 
6971 int
6972 pipealloc(struct file **f0, struct file **f1)
6973 {
6974   struct pipe *p;
6975 
6976   p = 0;
6977   *f0 = *f1 = 0;
6978   if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
6979     goto bad;
6980   if((p = (struct pipe*)kalloc()) == 0)
6981     goto bad;
6982   p->readopen = 1;
6983   p->writeopen = 1;
6984   p->nwrite = 0;
6985   p->nread = 0;
6986   initlock(&p->lock, "pipe");
6987   (*f0)->type = FD_PIPE;
6988   (*f0)->readable = 1;
6989   (*f0)->writable = 0;
6990   (*f0)->pipe = p;
6991   (*f1)->type = FD_PIPE;
6992   (*f1)->readable = 0;
6993   (*f1)->writable = 1;
6994   (*f1)->pipe = p;
6995   return 0;
6996 
6997 
6998 
6999 
7000  bad:
7001   if(p)
7002     kfree((char*)p);
7003   if(*f0)
7004     fileclose(*f0);
7005   if(*f1)
7006     fileclose(*f1);
7007   return -1;
7008 }
7009 
7010 void
7011 pipeclose(struct pipe *p, int writable)
7012 {
7013   acquire(&p->lock);
7014   if(writable){
7015     p->writeopen = 0;
7016     wakeup(&p->nread);
7017   } else {
7018     p->readopen = 0;
7019     wakeup(&p->nwrite);
7020   }
7021   if(p->readopen == 0 && p->writeopen == 0){
7022     release(&p->lock);
7023     kfree((char*)p);
7024   } else
7025     release(&p->lock);
7026 }
7027 
7028 
7029 int
7030 pipewrite(struct pipe *p, char *addr, int n)
7031 {
7032   int i;
7033 
7034   acquire(&p->lock);
7035   for(i = 0; i < n; i++){
7036     while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
7037       if(p->readopen == 0 || myproc()->killed){
7038         release(&p->lock);
7039         return -1;
7040       }
7041       wakeup(&p->nread);
7042       sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
7043     }
7044     p->data[p->nwrite++ % PIPESIZE] = addr[i];
7045   }
7046   wakeup(&p->nread);  //DOC: pipewrite-wakeup1
7047   release(&p->lock);
7048   return n;
7049 }
7050 int
7051 piperead(struct pipe *p, char *addr, int n)
7052 {
7053   int i;
7054 
7055   acquire(&p->lock);
7056   while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
7057     if(myproc()->killed){
7058       release(&p->lock);
7059       return -1;
7060     }
7061     sleep(&p->nread, &p->lock); //DOC: piperead-sleep
7062   }
7063   for(i = 0; i < n; i++){  //DOC: piperead-copy
7064     if(p->nread == p->nwrite)
7065       break;
7066     addr[i] = p->data[p->nread++ % PIPESIZE];
7067   }
7068   wakeup(&p->nwrite);  //DOC: piperead-wakeup
7069   release(&p->lock);
7070   return i;
7071 }
7072 
7073 
7074 
7075 
7076 
7077 
7078 
7079 
7080 
7081 
7082 
7083 
7084 
7085 
7086 
7087 
7088 
7089 
7090 
7091 
7092 
7093 
7094 
7095 
7096 
7097 
7098 
7099 
