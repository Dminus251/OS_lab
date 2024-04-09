6250 //
6251 // File-system system calls.
6252 // Mostly argument checking, since we don't trust
6253 // user code, and calls into file.c and fs.c.
6254 //
6255 
6256 #include "types.h"
6257 #include "defs.h"
6258 #include "param.h"
6259 #include "stat.h"
6260 #include "mmu.h"
6261 #include "proc.h"
6262 #include "fs.h"
6263 #include "spinlock.h"
6264 #include "sleeplock.h"
6265 #include "file.h"
6266 #include "fcntl.h"
6267 
6268 // Fetch the nth word-sized system call argument as a file descriptor
6269 // and return both the descriptor and the corresponding struct file.
6270 static int
6271 argfd(int n, int *pfd, struct file **pf)
6272 {
6273   int fd;
6274   struct file *f;
6275 
6276   if(argint(n, &fd) < 0)
6277     return -1;
6278   if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
6279     return -1;
6280   if(pfd)
6281     *pfd = fd;
6282   if(pf)
6283     *pf = f;
6284   return 0;
6285 }
6286 
6287 
6288 
6289 
6290 
6291 
6292 
6293 
6294 
6295 
6296 
6297 
6298 
6299 
6300 // Allocate a file descriptor for the given file.
6301 // Takes over file reference from caller on success.
6302 static int
6303 fdalloc(struct file *f)
6304 {
6305   int fd;
6306   struct proc *curproc = myproc();
6307 
6308   for(fd = 0; fd < NOFILE; fd++){
6309     if(curproc->ofile[fd] == 0){
6310       curproc->ofile[fd] = f;
6311       return fd;
6312     }
6313   }
6314   return -1;
6315 }
6316 
6317 int
6318 sys_dup(void)
6319 {
6320   struct file *f;
6321   int fd;
6322 
6323   if(argfd(0, 0, &f) < 0)
6324     return -1;
6325   if((fd=fdalloc(f)) < 0)
6326     return -1;
6327   filedup(f);
6328   return fd;
6329 }
6330 
6331 int
6332 sys_read(void)
6333 {
6334   struct file *f;
6335   int n;
6336   char *p;
6337 
6338   if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
6339     return -1;
6340   return fileread(f, p, n);
6341 }
6342 
6343 
6344 
6345 
6346 
6347 
6348 
6349 
6350 int
6351 sys_write(void)
6352 {
6353   struct file *f;
6354   int n;
6355   char *p;
6356 
6357   if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
6358     return -1;
6359   return filewrite(f, p, n);
6360 }
6361 
6362 int
6363 sys_close(void)
6364 {
6365   int fd;
6366   struct file *f;
6367 
6368   if(argfd(0, &fd, &f) < 0)
6369     return -1;
6370   myproc()->ofile[fd] = 0;
6371   fileclose(f);
6372   return 0;
6373 }
6374 
6375 int
6376 sys_fstat(void)
6377 {
6378   struct file *f;
6379   struct stat *st;
6380 
6381   if(argfd(0, 0, &f) < 0 || argptr(1, (void*)&st, sizeof(*st)) < 0)
6382     return -1;
6383   return filestat(f, st);
6384 }
6385 
6386 
6387 
6388 
6389 
6390 
6391 
6392 
6393 
6394 
6395 
6396 
6397 
6398 
6399 
6400 // Create the path new as a link to the same inode as old.
6401 int
6402 sys_link(void)
6403 {
6404   char name[DIRSIZ], *new, *old;
6405   struct inode *dp, *ip;
6406 
6407   if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
6408     return -1;
6409 
6410   begin_op();
6411   if((ip = namei(old)) == 0){
6412     end_op();
6413     return -1;
6414   }
6415 
6416   ilock(ip);
6417   if(ip->type == T_DIR){
6418     iunlockput(ip);
6419     end_op();
6420     return -1;
6421   }
6422 
6423   ip->nlink++;
6424   iupdate(ip);
6425   iunlock(ip);
6426 
6427   if((dp = nameiparent(new, name)) == 0)
6428     goto bad;
6429   ilock(dp);
6430   if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
6431     iunlockput(dp);
6432     goto bad;
6433   }
6434   iunlockput(dp);
6435   iput(ip);
6436 
6437   end_op();
6438 
6439   return 0;
6440 
6441 bad:
6442   ilock(ip);
6443   ip->nlink--;
6444   iupdate(ip);
6445   iunlockput(ip);
6446   end_op();
6447   return -1;
6448 }
6449 
6450 // Is the directory dp empty except for "." and ".." ?
6451 static int
6452 isdirempty(struct inode *dp)
6453 {
6454   int off;
6455   struct dirent de;
6456 
6457   for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
6458     if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
6459       panic("isdirempty: readi");
6460     if(de.inum != 0)
6461       return 0;
6462   }
6463   return 1;
6464 }
6465 
6466 
6467 
6468 
6469 
6470 
6471 
6472 
6473 
6474 
6475 
6476 
6477 
6478 
6479 
6480 
6481 
6482 
6483 
6484 
6485 
6486 
6487 
6488 
6489 
6490 
6491 
6492 
6493 
6494 
6495 
6496 
6497 
6498 
6499 
6500 int
6501 sys_unlink(void)
6502 {
6503   struct inode *ip, *dp;
6504   struct dirent de;
6505   char name[DIRSIZ], *path;
6506   uint off;
6507 
6508   if(argstr(0, &path) < 0)
6509     return -1;
6510 
6511   begin_op();
6512   if((dp = nameiparent(path, name)) == 0){
6513     end_op();
6514     return -1;
6515   }
6516 
6517   ilock(dp);
6518 
6519   // Cannot unlink "." or "..".
6520   if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
6521     goto bad;
6522 
6523   if((ip = dirlookup(dp, name, &off)) == 0)
6524     goto bad;
6525   ilock(ip);
6526 
6527   if(ip->nlink < 1)
6528     panic("unlink: nlink < 1");
6529   if(ip->type == T_DIR && !isdirempty(ip)){
6530     iunlockput(ip);
6531     goto bad;
6532   }
6533 
6534   memset(&de, 0, sizeof(de));
6535   if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
6536     panic("unlink: writei");
6537   if(ip->type == T_DIR){
6538     dp->nlink--;
6539     iupdate(dp);
6540   }
6541   iunlockput(dp);
6542 
6543   ip->nlink--;
6544   iupdate(ip);
6545   iunlockput(ip);
6546 
6547   end_op();
6548 
6549   return 0;
6550 bad:
6551   iunlockput(dp);
6552   end_op();
6553   return -1;
6554 }
6555 
6556 static struct inode*
6557 create(char *path, short type, short major, short minor)
6558 {
6559   uint off;
6560   struct inode *ip, *dp;
6561   char name[DIRSIZ];
6562 
6563   if((dp = nameiparent(path, name)) == 0)
6564     return 0;
6565   ilock(dp);
6566 
6567   if((ip = dirlookup(dp, name, &off)) != 0){
6568     iunlockput(dp);
6569     ilock(ip);
6570     if(type == T_FILE && ip->type == T_FILE)
6571       return ip;
6572     iunlockput(ip);
6573     return 0;
6574   }
6575 
6576   if((ip = ialloc(dp->dev, type)) == 0)
6577     panic("create: ialloc");
6578 
6579   ilock(ip);
6580   ip->major = major;
6581   ip->minor = minor;
6582   ip->nlink = 1;
6583   iupdate(ip);
6584 
6585   if(type == T_DIR){  // Create . and .. entries.
6586     dp->nlink++;  // for ".."
6587     iupdate(dp);
6588     // No ip->nlink++ for ".": avoid cyclic ref count.
6589     if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
6590       panic("create dots");
6591   }
6592 
6593   if(dirlink(dp, name, ip->inum) < 0)
6594     panic("create: dirlink");
6595 
6596   iunlockput(dp);
6597 
6598   return ip;
6599 }
6600 int
6601 sys_open(void)
6602 {
6603   char *path;
6604   int fd, omode;
6605   struct file *f;
6606   struct inode *ip;
6607 
6608   if(argstr(0, &path) < 0 || argint(1, &omode) < 0)
6609     return -1;
6610 
6611   begin_op();
6612 
6613   if(omode & O_CREATE){
6614     ip = create(path, T_FILE, 0, 0);
6615     if(ip == 0){
6616       end_op();
6617       return -1;
6618     }
6619   } else {
6620     if((ip = namei(path)) == 0){
6621       end_op();
6622       return -1;
6623     }
6624     ilock(ip);
6625     if(ip->type == T_DIR && omode != O_RDONLY){
6626       iunlockput(ip);
6627       end_op();
6628       return -1;
6629     }
6630   }
6631 
6632   if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
6633     if(f)
6634       fileclose(f);
6635     iunlockput(ip);
6636     end_op();
6637     return -1;
6638   }
6639   iunlock(ip);
6640   end_op();
6641 
6642   f->type = FD_INODE;
6643   f->ip = ip;
6644   f->off = 0;
6645   f->readable = !(omode & O_WRONLY);
6646   f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
6647   return fd;
6648 }
6649 
6650 int
6651 sys_mkdir(void)
6652 {
6653   char *path;
6654   struct inode *ip;
6655 
6656   begin_op();
6657   if(argstr(0, &path) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
6658     end_op();
6659     return -1;
6660   }
6661   iunlockput(ip);
6662   end_op();
6663   return 0;
6664 }
6665 
6666 int
6667 sys_mknod(void)
6668 {
6669   struct inode *ip;
6670   char *path;
6671   int major, minor;
6672 
6673   begin_op();
6674   if((argstr(0, &path)) < 0 ||
6675      argint(1, &major) < 0 ||
6676      argint(2, &minor) < 0 ||
6677      (ip = create(path, T_DEV, major, minor)) == 0){
6678     end_op();
6679     return -1;
6680   }
6681   iunlockput(ip);
6682   end_op();
6683   return 0;
6684 }
6685 
6686 
6687 
6688 
6689 
6690 
6691 
6692 
6693 
6694 
6695 
6696 
6697 
6698 
6699 
6700 int
6701 sys_chdir(void)
6702 {
6703   char *path;
6704   struct inode *ip;
6705   struct proc *curproc = myproc();
6706 
6707   begin_op();
6708   if(argstr(0, &path) < 0 || (ip = namei(path)) == 0){
6709     end_op();
6710     return -1;
6711   }
6712   ilock(ip);
6713   if(ip->type != T_DIR){
6714     iunlockput(ip);
6715     end_op();
6716     return -1;
6717   }
6718   iunlock(ip);
6719   iput(curproc->cwd);
6720   end_op();
6721   curproc->cwd = ip;
6722   return 0;
6723 }
6724 
6725 int
6726 sys_exec(void)
6727 {
6728   char *path, *argv[MAXARG];
6729   int i;
6730   uint uargv, uarg;
6731 
6732   if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
6733     return -1;
6734   }
6735   memset(argv, 0, sizeof(argv));
6736   for(i=0;; i++){
6737     if(i >= NELEM(argv))
6738       return -1;
6739     if(fetchint(uargv+4*i, (int*)&uarg) < 0)
6740       return -1;
6741     if(uarg == 0){
6742       argv[i] = 0;
6743       break;
6744     }
6745     if(fetchstr(uarg, &argv[i]) < 0)
6746       return -1;
6747   }
6748   return exec(path, argv);
6749 }
6750 int
6751 sys_pipe(void)
6752 {
6753   int *fd;
6754   struct file *rf, *wf;
6755   int fd0, fd1;
6756 
6757   if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
6758     return -1;
6759   if(pipealloc(&rf, &wf) < 0)
6760     return -1;
6761   fd0 = -1;
6762   if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
6763     if(fd0 >= 0)
6764       myproc()->ofile[fd0] = 0;
6765     fileclose(rf);
6766     fileclose(wf);
6767     return -1;
6768   }
6769   fd[0] = fd0;
6770   fd[1] = fd1;
6771   return 0;
6772 }
6773 
6774 
6775 
6776 
6777 
6778 
6779 
6780 
6781 
6782 
6783 
6784 
6785 
6786 
6787 
6788 
6789 
6790 
6791 
6792 
6793 
6794 
6795 
6796 
6797 
6798 
6799 
