4350 struct file {
4351   enum { FD_NONE, FD_PIPE, FD_INODE } type;
4352   int ref; // reference count
4353   char readable;
4354   char writable;
4355   struct pipe *pipe;
4356   struct inode *ip;
4357   uint off;
4358 };
4359 
4360 
4361 // in-memory copy of an inode
4362 struct inode {
4363   uint dev;           // Device number
4364   uint inum;          // Inode number
4365   int ref;            // Reference count
4366   struct sleeplock lock; // protects everything below here
4367   int valid;          // inode has been read from disk?
4368 
4369   short type;         // copy of disk inode
4370   short major;
4371   short minor;
4372   short nlink;
4373   uint size;
4374   uint addrs[NDIRECT+1];
4375 };
4376 
4377 // table mapping major device number to
4378 // device functions
4379 struct devsw {
4380   int (*read)(struct inode*, char*, int);
4381   int (*write)(struct inode*, char*, int);
4382 };
4383 
4384 extern struct devsw devsw[];
4385 
4386 #define CONSOLE 1
4387 
4388 
4389 
4390 
4391 
4392 
4393 
4394 
4395 
4396 
4397 
4398 
4399 
