4400 // Simple PIO-based (non-DMA) IDE driver code.
4401 
4402 #include "types.h"
4403 #include "defs.h"
4404 #include "param.h"
4405 #include "memlayout.h"
4406 #include "mmu.h"
4407 #include "proc.h"
4408 #include "x86.h"
4409 #include "traps.h"
4410 #include "spinlock.h"
4411 #include "sleeplock.h"
4412 #include "fs.h"
4413 #include "buf.h"
4414 
4415 #define SECTOR_SIZE   512
4416 #define IDE_BSY       0x80
4417 #define IDE_DRDY      0x40
4418 #define IDE_DF        0x20
4419 #define IDE_ERR       0x01
4420 
4421 #define IDE_CMD_READ  0x20
4422 #define IDE_CMD_WRITE 0x30
4423 #define IDE_CMD_RDMUL 0xc4
4424 #define IDE_CMD_WRMUL 0xc5
4425 
4426 #define IDE_DEBUG     1
4427 
4428 // idequeue points to the buf now being read/written to the disk.
4429 // idequeue->qnext points to the next buf to be processed.
4430 // You must hold idelock while manipulating queue.
4431 
4432 static struct spinlock idelock;
4433 static struct buf *idequeue;
4434 
4435 static int havedisk1;
4436 static void idestart(struct buf*);
4437 
4438 // Wait for IDE disk to become ready.
4439 static int
4440 idewait(int checkerr)
4441 {
4442   int r;
4443 
4444   while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
4445     ;
4446   if(checkerr && (r & (IDE_DF|IDE_ERR)) != 0)
4447     return -1;
4448   return 0;
4449 }
4450 void
4451 ideinit(void)
4452 {
4453   int i;
4454 
4455   initlock(&idelock, "ide");
4456   ioapicenable(IRQ_IDE, ncpu - 1);
4457   idewait(0);
4458 
4459   // Check if disk 1 is present
4460   outb(0x1f6, 0xe0 | (1<<4));
4461   for(i=0; i<1000; i++){
4462     if(inb(0x1f7) != 0){
4463       havedisk1 = 1;
4464       break;
4465     }
4466   }
4467 
4468   // Switch back to disk 0.
4469   outb(0x1f6, 0xe0 | (0<<4));
4470 }
4471 
4472 // Start the request for b.  Caller must hold idelock.
4473 static void
4474 idestart(struct buf *b)
4475 {
4476   if(b == 0)
4477     panic("idestart");
4478   if(b->blockno >= FSSIZE)
4479     panic("incorrect blockno");
4480   int sector_per_block =  BSIZE/SECTOR_SIZE;
4481   int sector = b->blockno * sector_per_block;
4482   int read_cmd = (sector_per_block == 1) ? IDE_CMD_READ :  IDE_CMD_RDMUL;
4483   int write_cmd = (sector_per_block == 1) ? IDE_CMD_WRITE : IDE_CMD_WRMUL;
4484 
4485   if (sector_per_block > 7) panic("idestart");
4486 
4487   idewait(0);
4488   outb(0x3f6, 0);  // generate interrupt
4489   outb(0x1f2, sector_per_block);  // number of sectors
4490   outb(0x1f3, sector & 0xff);
4491   outb(0x1f4, (sector >> 8) & 0xff);
4492   outb(0x1f5, (sector >> 16) & 0xff);
4493   outb(0x1f6, 0xe0 | ((b->dev&1)<<4) | ((sector>>24)&0x0f));
4494   if(b->flags & B_DIRTY){
4495     outb(0x1f7, write_cmd);
4496     outsl(0x1f0, b->data, BSIZE/4);
4497   } else {
4498     outb(0x1f7, read_cmd);
4499   }
4500 }
4501 
4502 // Interrupt handler.
4503 void
4504 ideintr(void)
4505 {
4506   struct buf *b;
4507 
4508   // First queued buffer is the active request.
4509   acquire(&idelock);
4510 
4511   if((b = idequeue) == 0){
4512     release(&idelock);
4513     return;
4514   }
4515   idequeue = b->qnext;
4516 
4517   // Read data if needed.
4518   if(!(b->flags & B_DIRTY) && idewait(1) >= 0)
4519     insl(0x1f0, b->data, BSIZE/4);
4520 
4521   // Wake process waiting for this buf.
4522   b->flags |= B_VALID;
4523   b->flags &= ~B_DIRTY;
4524   wakeup(b);
4525 
4526   // Start disk on next buf in queue.
4527   if(idequeue != 0)
4528     idestart(idequeue);
4529 
4530   release(&idelock);
4531 }
4532 
4533 
4534 
4535 
4536 
4537 
4538 
4539 
4540 
4541 
4542 
4543 
4544 
4545 
4546 
4547 
4548 
4549 
4550 // Sync buf with disk.
4551 // If B_DIRTY is set, write buf to disk, clear B_DIRTY, set B_VALID.
4552 // Else if B_VALID is not set, read buf from disk, set B_VALID.
4553 void
4554 iderw(struct buf *b)
4555 {
4556   struct buf **pp;
4557 #if IDE_DEBUG
4558   cprintf("b->dev: %x havedisk1: %x\n",b->dev,havedisk1);
4559 #endif
4560   if(!holdingsleep(&b->lock))
4561     panic("iderw: buf not locked");
4562   if((b->flags & (B_VALID|B_DIRTY)) == B_VALID)
4563     panic("iderw: nothing to do");
4564   if(b->dev != 0 && !havedisk1)
4565     panic("iderw: ide disk 1 not present");
4566 
4567   acquire(&idelock);  //DOC:acquire-lock
4568 
4569   // Append b to idequeue.
4570   b->qnext = 0;
4571   for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
4572     ;
4573   *pp = b;
4574 
4575   // Start disk if necessary.
4576   if(idequeue == b)
4577     idestart(b);
4578 
4579   // Wait for request to finish.
4580   while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
4581     sleep(b, &idelock);
4582   }
4583 
4584 
4585   release(&idelock);
4586 }
4587 
4588 
4589 
4590 
4591 
4592 
4593 
4594 
4595 
4596 
4597 
4598 
4599 
