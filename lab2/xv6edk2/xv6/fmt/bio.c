4600 // Buffer cache.
4601 //
4602 // The buffer cache is a linked list of buf structures holding
4603 // cached copies of disk block contents.  Caching disk blocks
4604 // in memory reduces the number of disk reads and also provides
4605 // a synchronization point for disk blocks used by multiple processes.
4606 //
4607 // Interface:
4608 // * To get a buffer for a particular disk block, call bread.
4609 // * After changing buffer data, call bwrite to write it to disk.
4610 // * When done with the buffer, call brelse.
4611 // * Do not use the buffer after calling brelse.
4612 // * Only one process at a time can use a buffer,
4613 //     so do not keep them longer than necessary.
4614 //
4615 // The implementation uses two state flags internally:
4616 // * B_VALID: the buffer data has been read from the disk.
4617 // * B_DIRTY: the buffer data has been modified
4618 //     and needs to be written to disk.
4619 
4620 #include "types.h"
4621 #include "defs.h"
4622 #include "param.h"
4623 #include "spinlock.h"
4624 #include "sleeplock.h"
4625 #include "fs.h"
4626 #include "buf.h"
4627 
4628 struct {
4629   struct spinlock lock;
4630   struct buf buf[NBUF];
4631 
4632   // Linked list of all buffers, through prev/next.
4633   // head.next is most recently used.
4634   struct buf head;
4635 } bcache;
4636 
4637 void
4638 binit(void)
4639 {
4640   struct buf *b;
4641 
4642   initlock(&bcache.lock, "bcache");
4643 
4644 
4645 
4646 
4647 
4648 
4649 
4650   // Create linked list of buffers
4651   bcache.head.prev = &bcache.head;
4652   bcache.head.next = &bcache.head;
4653   for(b = bcache.buf; b < bcache.buf+NBUF; b++){
4654     b->next = bcache.head.next;
4655     b->prev = &bcache.head;
4656     initsleeplock(&b->lock, "buffer");
4657     bcache.head.next->prev = b;
4658     bcache.head.next = b;
4659   }
4660 }
4661 
4662 // Look through buffer cache for block on device dev.
4663 // If not found, allocate a buffer.
4664 // In either case, return locked buffer.
4665 static struct buf*
4666 bget(uint dev, uint blockno)
4667 {
4668   struct buf *b;
4669 
4670   acquire(&bcache.lock);
4671 
4672   // Is the block already cached?
4673   for(b = bcache.head.next; b != &bcache.head; b = b->next){
4674     if(b->dev == dev && b->blockno == blockno){
4675       b->refcnt++;
4676       release(&bcache.lock);
4677       acquiresleep(&b->lock);
4678       return b;
4679     }
4680   }
4681 
4682   // Not cached; recycle an unused buffer.
4683   // Even if refcnt==0, B_DIRTY indicates a buffer is in use
4684   // because log.c has modified it but not yet committed it.
4685   for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
4686     if(b->refcnt == 0 && (b->flags & B_DIRTY) == 0) {
4687       b->dev = dev;
4688       b->blockno = blockno;
4689       b->flags = 0;
4690       b->refcnt = 1;
4691       release(&bcache.lock);
4692       acquiresleep(&b->lock);
4693       return b;
4694     }
4695   }
4696   panic("bget: no buffers");
4697 }
4698 
4699 
4700 // Return a locked buf with the contents of the indicated block.
4701 struct buf*
4702 bread(uint dev, uint blockno)
4703 {
4704   struct buf *b;
4705 
4706   b = bget(dev, blockno);
4707   if((b->flags & B_VALID) == 0) {
4708     iderw(b);
4709   }
4710   return b;
4711 }
4712 
4713 // Write b's contents to disk.  Must be locked.
4714 void
4715 bwrite(struct buf *b)
4716 {
4717   if(!holdingsleep(&b->lock))
4718     panic("bwrite");
4719   b->flags |= B_DIRTY;
4720   iderw(b);
4721 }
4722 
4723 // Release a locked buffer.
4724 // Move to the head of the MRU list.
4725 void
4726 brelse(struct buf *b)
4727 {
4728   if(!holdingsleep(&b->lock))
4729     panic("brelse");
4730 
4731   releasesleep(&b->lock);
4732 
4733   acquire(&bcache.lock);
4734   b->refcnt--;
4735   if (b->refcnt == 0) {
4736     // no one is waiting for it.
4737     b->next->prev = b->prev;
4738     b->prev->next = b->next;
4739     b->next = bcache.head.next;
4740     b->prev = &bcache.head;
4741     bcache.head.next->prev = b;
4742     bcache.head.next = b;
4743   }
4744 
4745   release(&bcache.lock);
4746 }
4747 
4748 
4749 
4750 // Blank page.
4751 
4752 
4753 
4754 
4755 
4756 
4757 
4758 
4759 
4760 
4761 
4762 
4763 
4764 
4765 
4766 
4767 
4768 
4769 
4770 
4771 
4772 
4773 
4774 
4775 
4776 
4777 
4778 
4779 
4780 
4781 
4782 
4783 
4784 
4785 
4786 
4787 
4788 
4789 
4790 
4791 
4792 
4793 
4794 
4795 
4796 
4797 
4798 
4799 
