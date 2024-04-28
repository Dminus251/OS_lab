4250 // On-disk file system format.
4251 // Both the kernel and user programs use this header file.
4252 
4253 
4254 #define ROOTINO 1  // root i-number
4255 #define BSIZE 512  // block size
4256 
4257 // Disk layout:
4258 // [ boot block | super block | log | inode blocks |
4259 //                                          free bit map | data blocks]
4260 //
4261 // mkfs computes the super block and builds an initial file system. The
4262 // super block describes the disk layout:
4263 struct superblock {
4264   uint size;         // Size of file system image (blocks)
4265   uint nblocks;      // Number of data blocks
4266   uint ninodes;      // Number of inodes.
4267   uint nlog;         // Number of log blocks
4268   uint logstart;     // Block number of first log block
4269   uint inodestart;   // Block number of first inode block
4270   uint bmapstart;    // Block number of first free map block
4271 };
4272 
4273 #define NDIRECT 12
4274 #define NINDIRECT (BSIZE / sizeof(uint))
4275 #define MAXFILE (NDIRECT + NINDIRECT)
4276 
4277 // On-disk inode structure
4278 struct dinode {
4279   short type;           // File type
4280   short major;          // Major device number (T_DEV only)
4281   short minor;          // Minor device number (T_DEV only)
4282   short nlink;          // Number of links to inode in file system
4283   uint size;            // Size of file (bytes)
4284   uint addrs[NDIRECT+1];   // Data block addresses
4285 };
4286 
4287 
4288 
4289 
4290 
4291 
4292 
4293 
4294 
4295 
4296 
4297 
4298 
4299 
4300 // Inodes per block.
4301 #define IPB           (BSIZE / sizeof(struct dinode))
4302 
4303 // Block containing inode i
4304 #define IBLOCK(i, sb)     ((i) / IPB + sb.inodestart)
4305 
4306 // Bitmap bits per block
4307 #define BPB           (BSIZE*8)
4308 
4309 // Block of free map containing bit for block b
4310 #define BBLOCK(b, sb) (b/BPB + sb.bmapstart)
4311 
4312 // Directory is a file containing a sequence of dirent structures.
4313 #define DIRSIZ 14
4314 
4315 struct dirent {
4316   ushort inum;
4317   char name[DIRSIZ];
4318 };
4319 
4320 
4321 
4322 
4323 
4324 
4325 
4326 
4327 
4328 
4329 
4330 
4331 
4332 
4333 
4334 
4335 
4336 
4337 
4338 
4339 
4340 
4341 
4342 
4343 
4344 
4345 
4346 
4347 
4348 
4349 
