
kernelmemfs:     file format elf32-i386


Disassembly of section .text:

80100000 <multiboot_header>:
80100000:	02 b0 ad 1b 00 00    	add    0x1bad(%eax),%dh
80100006:	00 00                	add    %al,(%eax)
80100008:	fe 4f 52             	decb   0x52(%edi)
8010000b:	e4                   	.byte 0xe4

8010000c <wait_main>:
8010000c:	00 00                	add    %al,(%eax)
	...

80100010 <entry>:
80100010:	66 b8 10 00          	mov    $0x10,%ax
80100014:	8e d8                	mov    %eax,%ds
80100016:	8e c0                	mov    %eax,%es
80100018:	8e d0                	mov    %eax,%ss
8010001a:	66 b8 00 00          	mov    $0x0,%ax
8010001e:	8e e0                	mov    %eax,%fs
80100020:	8e e8                	mov    %eax,%gs
80100022:	0f 20 c0             	mov    %cr0,%eax
80100025:	25 ff ff ff 7f       	and    $0x7fffffff,%eax
8010002a:	0f 22 c0             	mov    %eax,%cr0
8010002d:	b8 00 e0 10 00       	mov    $0x10e000,%eax
80100032:	0f 22 d8             	mov    %eax,%cr3
80100035:	b9 80 00 00 c0       	mov    $0xc0000080,%ecx
8010003a:	0f 32                	rdmsr  
8010003c:	25 ff fe ff ff       	and    $0xfffffeff,%eax
80100041:	0f 30                	wrmsr  
80100043:	0f 20 e0             	mov    %cr4,%eax
80100046:	83 c8 10             	or     $0x10,%eax
80100049:	83 e0 df             	and    $0xffffffdf,%eax
8010004c:	0f 22 e0             	mov    %eax,%cr4
8010004f:	0f 20 c0             	mov    %cr0,%eax
80100052:	0d 01 00 01 80       	or     $0x80010001,%eax
80100057:	0f 22 c0             	mov    %eax,%cr0
8010005a:	bc 80 81 19 80       	mov    $0x80198180,%esp
8010005f:	ba 65 33 10 80       	mov    $0x80103365,%edx
80100064:	ff e2                	jmp    *%edx

80100066 <binit>:
  struct buf head;
} bcache;

void
binit(void)
{
80100066:	55                   	push   %ebp
80100067:	89 e5                	mov    %esp,%ebp
80100069:	83 ec 18             	sub    $0x18,%esp
  struct buf *b;

  initlock(&bcache.lock, "bcache");
8010006c:	83 ec 08             	sub    $0x8,%esp
8010006f:	68 80 a2 10 80       	push   $0x8010a280
80100074:	68 00 d0 18 80       	push   $0x8018d000
80100079:	e8 ed 48 00 00       	call   8010496b <initlock>
8010007e:	83 c4 10             	add    $0x10,%esp

//PAGEBREAK!
  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
80100081:	c7 05 4c 17 19 80 fc 	movl   $0x801916fc,0x8019174c
80100088:	16 19 80 
  bcache.head.next = &bcache.head;
8010008b:	c7 05 50 17 19 80 fc 	movl   $0x801916fc,0x80191750
80100092:	16 19 80 
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
80100095:	c7 45 f4 34 d0 18 80 	movl   $0x8018d034,-0xc(%ebp)
8010009c:	eb 47                	jmp    801000e5 <binit+0x7f>
    b->next = bcache.head.next;
8010009e:	8b 15 50 17 19 80    	mov    0x80191750,%edx
801000a4:	8b 45 f4             	mov    -0xc(%ebp),%eax
801000a7:	89 50 54             	mov    %edx,0x54(%eax)
    b->prev = &bcache.head;
801000aa:	8b 45 f4             	mov    -0xc(%ebp),%eax
801000ad:	c7 40 50 fc 16 19 80 	movl   $0x801916fc,0x50(%eax)
    initsleeplock(&b->lock, "buffer");
801000b4:	8b 45 f4             	mov    -0xc(%ebp),%eax
801000b7:	83 c0 0c             	add    $0xc,%eax
801000ba:	83 ec 08             	sub    $0x8,%esp
801000bd:	68 87 a2 10 80       	push   $0x8010a287
801000c2:	50                   	push   %eax
801000c3:	e8 46 47 00 00       	call   8010480e <initsleeplock>
801000c8:	83 c4 10             	add    $0x10,%esp
    bcache.head.next->prev = b;
801000cb:	a1 50 17 19 80       	mov    0x80191750,%eax
801000d0:	8b 55 f4             	mov    -0xc(%ebp),%edx
801000d3:	89 50 50             	mov    %edx,0x50(%eax)
    bcache.head.next = b;
801000d6:	8b 45 f4             	mov    -0xc(%ebp),%eax
801000d9:	a3 50 17 19 80       	mov    %eax,0x80191750
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
801000de:	81 45 f4 5c 02 00 00 	addl   $0x25c,-0xc(%ebp)
801000e5:	b8 fc 16 19 80       	mov    $0x801916fc,%eax
801000ea:	39 45 f4             	cmp    %eax,-0xc(%ebp)
801000ed:	72 af                	jb     8010009e <binit+0x38>
  }
}
801000ef:	90                   	nop
801000f0:	90                   	nop
801000f1:	c9                   	leave  
801000f2:	c3                   	ret    

801000f3 <bget>:
// Look through buffer cache for block on device dev.
// If not found, allocate a buffer.
// In either case, return locked buffer.
static struct buf*
bget(uint dev, uint blockno)
{
801000f3:	55                   	push   %ebp
801000f4:	89 e5                	mov    %esp,%ebp
801000f6:	83 ec 18             	sub    $0x18,%esp
  struct buf *b;

  acquire(&bcache.lock);
801000f9:	83 ec 0c             	sub    $0xc,%esp
801000fc:	68 00 d0 18 80       	push   $0x8018d000
80100101:	e8 87 48 00 00       	call   8010498d <acquire>
80100106:	83 c4 10             	add    $0x10,%esp

  // Is the block already cached?
  for(b = bcache.head.next; b != &bcache.head; b = b->next){
80100109:	a1 50 17 19 80       	mov    0x80191750,%eax
8010010e:	89 45 f4             	mov    %eax,-0xc(%ebp)
80100111:	eb 58                	jmp    8010016b <bget+0x78>
    if(b->dev == dev && b->blockno == blockno){
80100113:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100116:	8b 40 04             	mov    0x4(%eax),%eax
80100119:	39 45 08             	cmp    %eax,0x8(%ebp)
8010011c:	75 44                	jne    80100162 <bget+0x6f>
8010011e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100121:	8b 40 08             	mov    0x8(%eax),%eax
80100124:	39 45 0c             	cmp    %eax,0xc(%ebp)
80100127:	75 39                	jne    80100162 <bget+0x6f>
      b->refcnt++;
80100129:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010012c:	8b 40 4c             	mov    0x4c(%eax),%eax
8010012f:	8d 50 01             	lea    0x1(%eax),%edx
80100132:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100135:	89 50 4c             	mov    %edx,0x4c(%eax)
      release(&bcache.lock);
80100138:	83 ec 0c             	sub    $0xc,%esp
8010013b:	68 00 d0 18 80       	push   $0x8018d000
80100140:	e8 b6 48 00 00       	call   801049fb <release>
80100145:	83 c4 10             	add    $0x10,%esp
      acquiresleep(&b->lock);
80100148:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010014b:	83 c0 0c             	add    $0xc,%eax
8010014e:	83 ec 0c             	sub    $0xc,%esp
80100151:	50                   	push   %eax
80100152:	e8 f3 46 00 00       	call   8010484a <acquiresleep>
80100157:	83 c4 10             	add    $0x10,%esp
      return b;
8010015a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010015d:	e9 9d 00 00 00       	jmp    801001ff <bget+0x10c>
  for(b = bcache.head.next; b != &bcache.head; b = b->next){
80100162:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100165:	8b 40 54             	mov    0x54(%eax),%eax
80100168:	89 45 f4             	mov    %eax,-0xc(%ebp)
8010016b:	81 7d f4 fc 16 19 80 	cmpl   $0x801916fc,-0xc(%ebp)
80100172:	75 9f                	jne    80100113 <bget+0x20>
  }

  // Not cached; recycle an unused buffer.
  // Even if refcnt==0, B_DIRTY indicates a buffer is in use
  // because log.c has modified it but not yet committed it.
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
80100174:	a1 4c 17 19 80       	mov    0x8019174c,%eax
80100179:	89 45 f4             	mov    %eax,-0xc(%ebp)
8010017c:	eb 6b                	jmp    801001e9 <bget+0xf6>
    if(b->refcnt == 0 && (b->flags & B_DIRTY) == 0) {
8010017e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100181:	8b 40 4c             	mov    0x4c(%eax),%eax
80100184:	85 c0                	test   %eax,%eax
80100186:	75 58                	jne    801001e0 <bget+0xed>
80100188:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010018b:	8b 00                	mov    (%eax),%eax
8010018d:	83 e0 04             	and    $0x4,%eax
80100190:	85 c0                	test   %eax,%eax
80100192:	75 4c                	jne    801001e0 <bget+0xed>
      b->dev = dev;
80100194:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100197:	8b 55 08             	mov    0x8(%ebp),%edx
8010019a:	89 50 04             	mov    %edx,0x4(%eax)
      b->blockno = blockno;
8010019d:	8b 45 f4             	mov    -0xc(%ebp),%eax
801001a0:	8b 55 0c             	mov    0xc(%ebp),%edx
801001a3:	89 50 08             	mov    %edx,0x8(%eax)
      b->flags = 0;
801001a6:	8b 45 f4             	mov    -0xc(%ebp),%eax
801001a9:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
      b->refcnt = 1;
801001af:	8b 45 f4             	mov    -0xc(%ebp),%eax
801001b2:	c7 40 4c 01 00 00 00 	movl   $0x1,0x4c(%eax)
      release(&bcache.lock);
801001b9:	83 ec 0c             	sub    $0xc,%esp
801001bc:	68 00 d0 18 80       	push   $0x8018d000
801001c1:	e8 35 48 00 00       	call   801049fb <release>
801001c6:	83 c4 10             	add    $0x10,%esp
      acquiresleep(&b->lock);
801001c9:	8b 45 f4             	mov    -0xc(%ebp),%eax
801001cc:	83 c0 0c             	add    $0xc,%eax
801001cf:	83 ec 0c             	sub    $0xc,%esp
801001d2:	50                   	push   %eax
801001d3:	e8 72 46 00 00       	call   8010484a <acquiresleep>
801001d8:	83 c4 10             	add    $0x10,%esp
      return b;
801001db:	8b 45 f4             	mov    -0xc(%ebp),%eax
801001de:	eb 1f                	jmp    801001ff <bget+0x10c>
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
801001e0:	8b 45 f4             	mov    -0xc(%ebp),%eax
801001e3:	8b 40 50             	mov    0x50(%eax),%eax
801001e6:	89 45 f4             	mov    %eax,-0xc(%ebp)
801001e9:	81 7d f4 fc 16 19 80 	cmpl   $0x801916fc,-0xc(%ebp)
801001f0:	75 8c                	jne    8010017e <bget+0x8b>
    }
  }
  panic("bget: no buffers");
801001f2:	83 ec 0c             	sub    $0xc,%esp
801001f5:	68 8e a2 10 80       	push   $0x8010a28e
801001fa:	e8 aa 03 00 00       	call   801005a9 <panic>
}
801001ff:	c9                   	leave  
80100200:	c3                   	ret    

80100201 <bread>:

// Return a locked buf with the contents of the indicated block.
struct buf*
bread(uint dev, uint blockno)
{
80100201:	55                   	push   %ebp
80100202:	89 e5                	mov    %esp,%ebp
80100204:	83 ec 18             	sub    $0x18,%esp
  struct buf *b;

  b = bget(dev, blockno);
80100207:	83 ec 08             	sub    $0x8,%esp
8010020a:	ff 75 0c             	push   0xc(%ebp)
8010020d:	ff 75 08             	push   0x8(%ebp)
80100210:	e8 de fe ff ff       	call   801000f3 <bget>
80100215:	83 c4 10             	add    $0x10,%esp
80100218:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if((b->flags & B_VALID) == 0) {
8010021b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010021e:	8b 00                	mov    (%eax),%eax
80100220:	83 e0 02             	and    $0x2,%eax
80100223:	85 c0                	test   %eax,%eax
80100225:	75 0e                	jne    80100235 <bread+0x34>
    iderw(b);
80100227:	83 ec 0c             	sub    $0xc,%esp
8010022a:	ff 75 f4             	push   -0xc(%ebp)
8010022d:	e8 5d 9f 00 00       	call   8010a18f <iderw>
80100232:	83 c4 10             	add    $0x10,%esp
  }
  return b;
80100235:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
80100238:	c9                   	leave  
80100239:	c3                   	ret    

8010023a <bwrite>:

// Write b's contents to disk.  Must be locked.
void
bwrite(struct buf *b)
{
8010023a:	55                   	push   %ebp
8010023b:	89 e5                	mov    %esp,%ebp
8010023d:	83 ec 08             	sub    $0x8,%esp
  if(!holdingsleep(&b->lock))
80100240:	8b 45 08             	mov    0x8(%ebp),%eax
80100243:	83 c0 0c             	add    $0xc,%eax
80100246:	83 ec 0c             	sub    $0xc,%esp
80100249:	50                   	push   %eax
8010024a:	e8 ad 46 00 00       	call   801048fc <holdingsleep>
8010024f:	83 c4 10             	add    $0x10,%esp
80100252:	85 c0                	test   %eax,%eax
80100254:	75 0d                	jne    80100263 <bwrite+0x29>
    panic("bwrite");
80100256:	83 ec 0c             	sub    $0xc,%esp
80100259:	68 9f a2 10 80       	push   $0x8010a29f
8010025e:	e8 46 03 00 00       	call   801005a9 <panic>
  b->flags |= B_DIRTY;
80100263:	8b 45 08             	mov    0x8(%ebp),%eax
80100266:	8b 00                	mov    (%eax),%eax
80100268:	83 c8 04             	or     $0x4,%eax
8010026b:	89 c2                	mov    %eax,%edx
8010026d:	8b 45 08             	mov    0x8(%ebp),%eax
80100270:	89 10                	mov    %edx,(%eax)
  iderw(b);
80100272:	83 ec 0c             	sub    $0xc,%esp
80100275:	ff 75 08             	push   0x8(%ebp)
80100278:	e8 12 9f 00 00       	call   8010a18f <iderw>
8010027d:	83 c4 10             	add    $0x10,%esp
}
80100280:	90                   	nop
80100281:	c9                   	leave  
80100282:	c3                   	ret    

80100283 <brelse>:

// Release a locked buffer.
// Move to the head of the MRU list.
void
brelse(struct buf *b)
{
80100283:	55                   	push   %ebp
80100284:	89 e5                	mov    %esp,%ebp
80100286:	83 ec 08             	sub    $0x8,%esp
  if(!holdingsleep(&b->lock))
80100289:	8b 45 08             	mov    0x8(%ebp),%eax
8010028c:	83 c0 0c             	add    $0xc,%eax
8010028f:	83 ec 0c             	sub    $0xc,%esp
80100292:	50                   	push   %eax
80100293:	e8 64 46 00 00       	call   801048fc <holdingsleep>
80100298:	83 c4 10             	add    $0x10,%esp
8010029b:	85 c0                	test   %eax,%eax
8010029d:	75 0d                	jne    801002ac <brelse+0x29>
    panic("brelse");
8010029f:	83 ec 0c             	sub    $0xc,%esp
801002a2:	68 a6 a2 10 80       	push   $0x8010a2a6
801002a7:	e8 fd 02 00 00       	call   801005a9 <panic>

  releasesleep(&b->lock);
801002ac:	8b 45 08             	mov    0x8(%ebp),%eax
801002af:	83 c0 0c             	add    $0xc,%eax
801002b2:	83 ec 0c             	sub    $0xc,%esp
801002b5:	50                   	push   %eax
801002b6:	e8 f3 45 00 00       	call   801048ae <releasesleep>
801002bb:	83 c4 10             	add    $0x10,%esp

  acquire(&bcache.lock);
801002be:	83 ec 0c             	sub    $0xc,%esp
801002c1:	68 00 d0 18 80       	push   $0x8018d000
801002c6:	e8 c2 46 00 00       	call   8010498d <acquire>
801002cb:	83 c4 10             	add    $0x10,%esp
  b->refcnt--;
801002ce:	8b 45 08             	mov    0x8(%ebp),%eax
801002d1:	8b 40 4c             	mov    0x4c(%eax),%eax
801002d4:	8d 50 ff             	lea    -0x1(%eax),%edx
801002d7:	8b 45 08             	mov    0x8(%ebp),%eax
801002da:	89 50 4c             	mov    %edx,0x4c(%eax)
  if (b->refcnt == 0) {
801002dd:	8b 45 08             	mov    0x8(%ebp),%eax
801002e0:	8b 40 4c             	mov    0x4c(%eax),%eax
801002e3:	85 c0                	test   %eax,%eax
801002e5:	75 47                	jne    8010032e <brelse+0xab>
    // no one is waiting for it.
    b->next->prev = b->prev;
801002e7:	8b 45 08             	mov    0x8(%ebp),%eax
801002ea:	8b 40 54             	mov    0x54(%eax),%eax
801002ed:	8b 55 08             	mov    0x8(%ebp),%edx
801002f0:	8b 52 50             	mov    0x50(%edx),%edx
801002f3:	89 50 50             	mov    %edx,0x50(%eax)
    b->prev->next = b->next;
801002f6:	8b 45 08             	mov    0x8(%ebp),%eax
801002f9:	8b 40 50             	mov    0x50(%eax),%eax
801002fc:	8b 55 08             	mov    0x8(%ebp),%edx
801002ff:	8b 52 54             	mov    0x54(%edx),%edx
80100302:	89 50 54             	mov    %edx,0x54(%eax)
    b->next = bcache.head.next;
80100305:	8b 15 50 17 19 80    	mov    0x80191750,%edx
8010030b:	8b 45 08             	mov    0x8(%ebp),%eax
8010030e:	89 50 54             	mov    %edx,0x54(%eax)
    b->prev = &bcache.head;
80100311:	8b 45 08             	mov    0x8(%ebp),%eax
80100314:	c7 40 50 fc 16 19 80 	movl   $0x801916fc,0x50(%eax)
    bcache.head.next->prev = b;
8010031b:	a1 50 17 19 80       	mov    0x80191750,%eax
80100320:	8b 55 08             	mov    0x8(%ebp),%edx
80100323:	89 50 50             	mov    %edx,0x50(%eax)
    bcache.head.next = b;
80100326:	8b 45 08             	mov    0x8(%ebp),%eax
80100329:	a3 50 17 19 80       	mov    %eax,0x80191750
  }
  
  release(&bcache.lock);
8010032e:	83 ec 0c             	sub    $0xc,%esp
80100331:	68 00 d0 18 80       	push   $0x8018d000
80100336:	e8 c0 46 00 00       	call   801049fb <release>
8010033b:	83 c4 10             	add    $0x10,%esp
}
8010033e:	90                   	nop
8010033f:	c9                   	leave  
80100340:	c3                   	ret    

80100341 <cli>:
  asm volatile("movw %0, %%gs" : : "r" (v));
}

static inline void
cli(void)
{
80100341:	55                   	push   %ebp
80100342:	89 e5                	mov    %esp,%ebp
  asm volatile("cli");
80100344:	fa                   	cli    
}
80100345:	90                   	nop
80100346:	5d                   	pop    %ebp
80100347:	c3                   	ret    

80100348 <printint>:
  int locking;
} cons;

static void
printint(int xx, int base, int sign)
{
80100348:	55                   	push   %ebp
80100349:	89 e5                	mov    %esp,%ebp
8010034b:	83 ec 28             	sub    $0x28,%esp
  static char digits[] = "0123456789abcdef";
  char buf[16];
  int i;
  uint x;

  if(sign && (sign = xx < 0))
8010034e:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
80100352:	74 1c                	je     80100370 <printint+0x28>
80100354:	8b 45 08             	mov    0x8(%ebp),%eax
80100357:	c1 e8 1f             	shr    $0x1f,%eax
8010035a:	0f b6 c0             	movzbl %al,%eax
8010035d:	89 45 10             	mov    %eax,0x10(%ebp)
80100360:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
80100364:	74 0a                	je     80100370 <printint+0x28>
    x = -xx;
80100366:	8b 45 08             	mov    0x8(%ebp),%eax
80100369:	f7 d8                	neg    %eax
8010036b:	89 45 f0             	mov    %eax,-0x10(%ebp)
8010036e:	eb 06                	jmp    80100376 <printint+0x2e>
  else
    x = xx;
80100370:	8b 45 08             	mov    0x8(%ebp),%eax
80100373:	89 45 f0             	mov    %eax,-0x10(%ebp)

  i = 0;
80100376:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
8010037d:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80100380:	8b 45 f0             	mov    -0x10(%ebp),%eax
80100383:	ba 00 00 00 00       	mov    $0x0,%edx
80100388:	f7 f1                	div    %ecx
8010038a:	89 d1                	mov    %edx,%ecx
8010038c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010038f:	8d 50 01             	lea    0x1(%eax),%edx
80100392:	89 55 f4             	mov    %edx,-0xc(%ebp)
80100395:	0f b6 91 04 d0 10 80 	movzbl -0x7fef2ffc(%ecx),%edx
8010039c:	88 54 05 e0          	mov    %dl,-0x20(%ebp,%eax,1)
  }while((x /= base) != 0);
801003a0:	8b 4d 0c             	mov    0xc(%ebp),%ecx
801003a3:	8b 45 f0             	mov    -0x10(%ebp),%eax
801003a6:	ba 00 00 00 00       	mov    $0x0,%edx
801003ab:	f7 f1                	div    %ecx
801003ad:	89 45 f0             	mov    %eax,-0x10(%ebp)
801003b0:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
801003b4:	75 c7                	jne    8010037d <printint+0x35>

  if(sign)
801003b6:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
801003ba:	74 2a                	je     801003e6 <printint+0x9e>
    buf[i++] = '-';
801003bc:	8b 45 f4             	mov    -0xc(%ebp),%eax
801003bf:	8d 50 01             	lea    0x1(%eax),%edx
801003c2:	89 55 f4             	mov    %edx,-0xc(%ebp)
801003c5:	c6 44 05 e0 2d       	movb   $0x2d,-0x20(%ebp,%eax,1)

  while(--i >= 0)
801003ca:	eb 1a                	jmp    801003e6 <printint+0x9e>
    consputc(buf[i]);
801003cc:	8d 55 e0             	lea    -0x20(%ebp),%edx
801003cf:	8b 45 f4             	mov    -0xc(%ebp),%eax
801003d2:	01 d0                	add    %edx,%eax
801003d4:	0f b6 00             	movzbl (%eax),%eax
801003d7:	0f be c0             	movsbl %al,%eax
801003da:	83 ec 0c             	sub    $0xc,%esp
801003dd:	50                   	push   %eax
801003de:	e8 8c 03 00 00       	call   8010076f <consputc>
801003e3:	83 c4 10             	add    $0x10,%esp
  while(--i >= 0)
801003e6:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
801003ea:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801003ee:	79 dc                	jns    801003cc <printint+0x84>
}
801003f0:	90                   	nop
801003f1:	90                   	nop
801003f2:	c9                   	leave  
801003f3:	c3                   	ret    

801003f4 <cprintf>:
//PAGEBREAK: 50

// Print to the console. only understands %d, %x, %p, %s.
void
cprintf(char *fmt, ...)
{
801003f4:	55                   	push   %ebp
801003f5:	89 e5                	mov    %esp,%ebp
801003f7:	83 ec 28             	sub    $0x28,%esp
  int i, c, locking;
  uint *argp;
  char *s;

  locking = cons.locking;
801003fa:	a1 34 1a 19 80       	mov    0x80191a34,%eax
801003ff:	89 45 e8             	mov    %eax,-0x18(%ebp)
  if(locking)
80100402:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
80100406:	74 10                	je     80100418 <cprintf+0x24>
    acquire(&cons.lock);
80100408:	83 ec 0c             	sub    $0xc,%esp
8010040b:	68 00 1a 19 80       	push   $0x80191a00
80100410:	e8 78 45 00 00       	call   8010498d <acquire>
80100415:	83 c4 10             	add    $0x10,%esp

  if (fmt == 0)
80100418:	8b 45 08             	mov    0x8(%ebp),%eax
8010041b:	85 c0                	test   %eax,%eax
8010041d:	75 0d                	jne    8010042c <cprintf+0x38>
    panic("null fmt");
8010041f:	83 ec 0c             	sub    $0xc,%esp
80100422:	68 ad a2 10 80       	push   $0x8010a2ad
80100427:	e8 7d 01 00 00       	call   801005a9 <panic>


  argp = (uint*)(void*)(&fmt + 1);
8010042c:	8d 45 0c             	lea    0xc(%ebp),%eax
8010042f:	89 45 f0             	mov    %eax,-0x10(%ebp)
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
80100432:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80100439:	e9 2f 01 00 00       	jmp    8010056d <cprintf+0x179>
    if(c != '%'){
8010043e:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
80100442:	74 13                	je     80100457 <cprintf+0x63>
      consputc(c);
80100444:	83 ec 0c             	sub    $0xc,%esp
80100447:	ff 75 e4             	push   -0x1c(%ebp)
8010044a:	e8 20 03 00 00       	call   8010076f <consputc>
8010044f:	83 c4 10             	add    $0x10,%esp
      continue;
80100452:	e9 12 01 00 00       	jmp    80100569 <cprintf+0x175>
    }
    c = fmt[++i] & 0xff;
80100457:	8b 55 08             	mov    0x8(%ebp),%edx
8010045a:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
8010045e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100461:	01 d0                	add    %edx,%eax
80100463:	0f b6 00             	movzbl (%eax),%eax
80100466:	0f be c0             	movsbl %al,%eax
80100469:	25 ff 00 00 00       	and    $0xff,%eax
8010046e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(c == 0)
80100471:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
80100475:	0f 84 14 01 00 00    	je     8010058f <cprintf+0x19b>
      break;
    switch(c){
8010047b:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
8010047f:	74 5e                	je     801004df <cprintf+0xeb>
80100481:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
80100485:	0f 8f c2 00 00 00    	jg     8010054d <cprintf+0x159>
8010048b:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
8010048f:	74 6b                	je     801004fc <cprintf+0x108>
80100491:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
80100495:	0f 8f b2 00 00 00    	jg     8010054d <cprintf+0x159>
8010049b:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
8010049f:	74 3e                	je     801004df <cprintf+0xeb>
801004a1:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
801004a5:	0f 8f a2 00 00 00    	jg     8010054d <cprintf+0x159>
801004ab:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
801004af:	0f 84 89 00 00 00    	je     8010053e <cprintf+0x14a>
801004b5:	83 7d e4 64          	cmpl   $0x64,-0x1c(%ebp)
801004b9:	0f 85 8e 00 00 00    	jne    8010054d <cprintf+0x159>
    case 'd':
      printint(*argp++, 10, 1);
801004bf:	8b 45 f0             	mov    -0x10(%ebp),%eax
801004c2:	8d 50 04             	lea    0x4(%eax),%edx
801004c5:	89 55 f0             	mov    %edx,-0x10(%ebp)
801004c8:	8b 00                	mov    (%eax),%eax
801004ca:	83 ec 04             	sub    $0x4,%esp
801004cd:	6a 01                	push   $0x1
801004cf:	6a 0a                	push   $0xa
801004d1:	50                   	push   %eax
801004d2:	e8 71 fe ff ff       	call   80100348 <printint>
801004d7:	83 c4 10             	add    $0x10,%esp
      break;
801004da:	e9 8a 00 00 00       	jmp    80100569 <cprintf+0x175>
    case 'x':
    case 'p':
      printint(*argp++, 16, 0);
801004df:	8b 45 f0             	mov    -0x10(%ebp),%eax
801004e2:	8d 50 04             	lea    0x4(%eax),%edx
801004e5:	89 55 f0             	mov    %edx,-0x10(%ebp)
801004e8:	8b 00                	mov    (%eax),%eax
801004ea:	83 ec 04             	sub    $0x4,%esp
801004ed:	6a 00                	push   $0x0
801004ef:	6a 10                	push   $0x10
801004f1:	50                   	push   %eax
801004f2:	e8 51 fe ff ff       	call   80100348 <printint>
801004f7:	83 c4 10             	add    $0x10,%esp
      break;
801004fa:	eb 6d                	jmp    80100569 <cprintf+0x175>
    case 's':
      if((s = (char*)*argp++) == 0)
801004fc:	8b 45 f0             	mov    -0x10(%ebp),%eax
801004ff:	8d 50 04             	lea    0x4(%eax),%edx
80100502:	89 55 f0             	mov    %edx,-0x10(%ebp)
80100505:	8b 00                	mov    (%eax),%eax
80100507:	89 45 ec             	mov    %eax,-0x14(%ebp)
8010050a:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
8010050e:	75 22                	jne    80100532 <cprintf+0x13e>
        s = "(null)";
80100510:	c7 45 ec b6 a2 10 80 	movl   $0x8010a2b6,-0x14(%ebp)
      for(; *s; s++)
80100517:	eb 19                	jmp    80100532 <cprintf+0x13e>
        consputc(*s);
80100519:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010051c:	0f b6 00             	movzbl (%eax),%eax
8010051f:	0f be c0             	movsbl %al,%eax
80100522:	83 ec 0c             	sub    $0xc,%esp
80100525:	50                   	push   %eax
80100526:	e8 44 02 00 00       	call   8010076f <consputc>
8010052b:	83 c4 10             	add    $0x10,%esp
      for(; *s; s++)
8010052e:	83 45 ec 01          	addl   $0x1,-0x14(%ebp)
80100532:	8b 45 ec             	mov    -0x14(%ebp),%eax
80100535:	0f b6 00             	movzbl (%eax),%eax
80100538:	84 c0                	test   %al,%al
8010053a:	75 dd                	jne    80100519 <cprintf+0x125>
      break;
8010053c:	eb 2b                	jmp    80100569 <cprintf+0x175>
    case '%':
      consputc('%');
8010053e:	83 ec 0c             	sub    $0xc,%esp
80100541:	6a 25                	push   $0x25
80100543:	e8 27 02 00 00       	call   8010076f <consputc>
80100548:	83 c4 10             	add    $0x10,%esp
      break;
8010054b:	eb 1c                	jmp    80100569 <cprintf+0x175>
    default:
      // Print unknown % sequence to draw attention.
      consputc('%');
8010054d:	83 ec 0c             	sub    $0xc,%esp
80100550:	6a 25                	push   $0x25
80100552:	e8 18 02 00 00       	call   8010076f <consputc>
80100557:	83 c4 10             	add    $0x10,%esp
      consputc(c);
8010055a:	83 ec 0c             	sub    $0xc,%esp
8010055d:	ff 75 e4             	push   -0x1c(%ebp)
80100560:	e8 0a 02 00 00       	call   8010076f <consputc>
80100565:	83 c4 10             	add    $0x10,%esp
      break;
80100568:	90                   	nop
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
80100569:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
8010056d:	8b 55 08             	mov    0x8(%ebp),%edx
80100570:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100573:	01 d0                	add    %edx,%eax
80100575:	0f b6 00             	movzbl (%eax),%eax
80100578:	0f be c0             	movsbl %al,%eax
8010057b:	25 ff 00 00 00       	and    $0xff,%eax
80100580:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80100583:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
80100587:	0f 85 b1 fe ff ff    	jne    8010043e <cprintf+0x4a>
8010058d:	eb 01                	jmp    80100590 <cprintf+0x19c>
      break;
8010058f:	90                   	nop
    }
  }

  if(locking)
80100590:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
80100594:	74 10                	je     801005a6 <cprintf+0x1b2>
    release(&cons.lock);
80100596:	83 ec 0c             	sub    $0xc,%esp
80100599:	68 00 1a 19 80       	push   $0x80191a00
8010059e:	e8 58 44 00 00       	call   801049fb <release>
801005a3:	83 c4 10             	add    $0x10,%esp
}
801005a6:	90                   	nop
801005a7:	c9                   	leave  
801005a8:	c3                   	ret    

801005a9 <panic>:

void
panic(char *s)
{
801005a9:	55                   	push   %ebp
801005aa:	89 e5                	mov    %esp,%ebp
801005ac:	83 ec 38             	sub    $0x38,%esp
  int i;
  uint pcs[10];

  cli();
801005af:	e8 8d fd ff ff       	call   80100341 <cli>
  cons.locking = 0;
801005b4:	c7 05 34 1a 19 80 00 	movl   $0x0,0x80191a34
801005bb:	00 00 00 
  // use lapiccpunum so that we can call panic from mycpu()
  cprintf("lapicid %d: panic: ", lapicid());
801005be:	e8 37 25 00 00       	call   80102afa <lapicid>
801005c3:	83 ec 08             	sub    $0x8,%esp
801005c6:	50                   	push   %eax
801005c7:	68 bd a2 10 80       	push   $0x8010a2bd
801005cc:	e8 23 fe ff ff       	call   801003f4 <cprintf>
801005d1:	83 c4 10             	add    $0x10,%esp
  cprintf(s);
801005d4:	8b 45 08             	mov    0x8(%ebp),%eax
801005d7:	83 ec 0c             	sub    $0xc,%esp
801005da:	50                   	push   %eax
801005db:	e8 14 fe ff ff       	call   801003f4 <cprintf>
801005e0:	83 c4 10             	add    $0x10,%esp
  cprintf("\n");
801005e3:	83 ec 0c             	sub    $0xc,%esp
801005e6:	68 d1 a2 10 80       	push   $0x8010a2d1
801005eb:	e8 04 fe ff ff       	call   801003f4 <cprintf>
801005f0:	83 c4 10             	add    $0x10,%esp
  getcallerpcs(&s, pcs);
801005f3:	83 ec 08             	sub    $0x8,%esp
801005f6:	8d 45 cc             	lea    -0x34(%ebp),%eax
801005f9:	50                   	push   %eax
801005fa:	8d 45 08             	lea    0x8(%ebp),%eax
801005fd:	50                   	push   %eax
801005fe:	e8 4a 44 00 00       	call   80104a4d <getcallerpcs>
80100603:	83 c4 10             	add    $0x10,%esp
  for(i=0; i<10; i++)
80100606:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
8010060d:	eb 1c                	jmp    8010062b <panic+0x82>
    cprintf(" %p", pcs[i]);
8010060f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100612:	8b 44 85 cc          	mov    -0x34(%ebp,%eax,4),%eax
80100616:	83 ec 08             	sub    $0x8,%esp
80100619:	50                   	push   %eax
8010061a:	68 d3 a2 10 80       	push   $0x8010a2d3
8010061f:	e8 d0 fd ff ff       	call   801003f4 <cprintf>
80100624:	83 c4 10             	add    $0x10,%esp
  for(i=0; i<10; i++)
80100627:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
8010062b:	83 7d f4 09          	cmpl   $0x9,-0xc(%ebp)
8010062f:	7e de                	jle    8010060f <panic+0x66>
  panicked = 1; // freeze other CPU
80100631:	c7 05 ec 19 19 80 01 	movl   $0x1,0x801919ec
80100638:	00 00 00 
  for(;;)
8010063b:	eb fe                	jmp    8010063b <panic+0x92>

8010063d <graphic_putc>:

#define CONSOLE_HORIZONTAL_MAX 53
#define CONSOLE_VERTICAL_MAX 20
int console_pos = CONSOLE_HORIZONTAL_MAX*(CONSOLE_VERTICAL_MAX);
//int console_pos = 0;
void graphic_putc(int c){
8010063d:	55                   	push   %ebp
8010063e:	89 e5                	mov    %esp,%ebp
80100640:	83 ec 18             	sub    $0x18,%esp
  if(c == '\n'){
80100643:	83 7d 08 0a          	cmpl   $0xa,0x8(%ebp)
80100647:	75 64                	jne    801006ad <graphic_putc+0x70>
    console_pos += CONSOLE_HORIZONTAL_MAX - console_pos%CONSOLE_HORIZONTAL_MAX;
80100649:	8b 0d 00 d0 10 80    	mov    0x8010d000,%ecx
8010064f:	ba ed 73 48 4d       	mov    $0x4d4873ed,%edx
80100654:	89 c8                	mov    %ecx,%eax
80100656:	f7 ea                	imul   %edx
80100658:	89 d0                	mov    %edx,%eax
8010065a:	c1 f8 04             	sar    $0x4,%eax
8010065d:	89 ca                	mov    %ecx,%edx
8010065f:	c1 fa 1f             	sar    $0x1f,%edx
80100662:	29 d0                	sub    %edx,%eax
80100664:	6b d0 35             	imul   $0x35,%eax,%edx
80100667:	89 c8                	mov    %ecx,%eax
80100669:	29 d0                	sub    %edx,%eax
8010066b:	ba 35 00 00 00       	mov    $0x35,%edx
80100670:	29 c2                	sub    %eax,%edx
80100672:	a1 00 d0 10 80       	mov    0x8010d000,%eax
80100677:	01 d0                	add    %edx,%eax
80100679:	a3 00 d0 10 80       	mov    %eax,0x8010d000
    if(console_pos >= CONSOLE_VERTICAL_MAX * CONSOLE_HORIZONTAL_MAX){
8010067e:	a1 00 d0 10 80       	mov    0x8010d000,%eax
80100683:	3d 23 04 00 00       	cmp    $0x423,%eax
80100688:	0f 8e de 00 00 00    	jle    8010076c <graphic_putc+0x12f>
      console_pos -= CONSOLE_HORIZONTAL_MAX;
8010068e:	a1 00 d0 10 80       	mov    0x8010d000,%eax
80100693:	83 e8 35             	sub    $0x35,%eax
80100696:	a3 00 d0 10 80       	mov    %eax,0x8010d000
      graphic_scroll_up(30);
8010069b:	83 ec 0c             	sub    $0xc,%esp
8010069e:	6a 1e                	push   $0x1e
801006a0:	e8 41 7a 00 00       	call   801080e6 <graphic_scroll_up>
801006a5:	83 c4 10             	add    $0x10,%esp
    int x = (console_pos%CONSOLE_HORIZONTAL_MAX)*FONT_WIDTH + 2;
    int y = (console_pos/CONSOLE_HORIZONTAL_MAX)*FONT_HEIGHT;
    font_render(x,y,c);
    console_pos++;
  }
}
801006a8:	e9 bf 00 00 00       	jmp    8010076c <graphic_putc+0x12f>
  }else if(c == BACKSPACE){
801006ad:	81 7d 08 00 01 00 00 	cmpl   $0x100,0x8(%ebp)
801006b4:	75 1f                	jne    801006d5 <graphic_putc+0x98>
    if(console_pos>0) --console_pos;
801006b6:	a1 00 d0 10 80       	mov    0x8010d000,%eax
801006bb:	85 c0                	test   %eax,%eax
801006bd:	0f 8e a9 00 00 00    	jle    8010076c <graphic_putc+0x12f>
801006c3:	a1 00 d0 10 80       	mov    0x8010d000,%eax
801006c8:	83 e8 01             	sub    $0x1,%eax
801006cb:	a3 00 d0 10 80       	mov    %eax,0x8010d000
}
801006d0:	e9 97 00 00 00       	jmp    8010076c <graphic_putc+0x12f>
    if(console_pos >= CONSOLE_VERTICAL_MAX * CONSOLE_HORIZONTAL_MAX){
801006d5:	a1 00 d0 10 80       	mov    0x8010d000,%eax
801006da:	3d 23 04 00 00       	cmp    $0x423,%eax
801006df:	7e 1a                	jle    801006fb <graphic_putc+0xbe>
      console_pos -= CONSOLE_HORIZONTAL_MAX;
801006e1:	a1 00 d0 10 80       	mov    0x8010d000,%eax
801006e6:	83 e8 35             	sub    $0x35,%eax
801006e9:	a3 00 d0 10 80       	mov    %eax,0x8010d000
      graphic_scroll_up(30);
801006ee:	83 ec 0c             	sub    $0xc,%esp
801006f1:	6a 1e                	push   $0x1e
801006f3:	e8 ee 79 00 00       	call   801080e6 <graphic_scroll_up>
801006f8:	83 c4 10             	add    $0x10,%esp
    int x = (console_pos%CONSOLE_HORIZONTAL_MAX)*FONT_WIDTH + 2;
801006fb:	8b 0d 00 d0 10 80    	mov    0x8010d000,%ecx
80100701:	ba ed 73 48 4d       	mov    $0x4d4873ed,%edx
80100706:	89 c8                	mov    %ecx,%eax
80100708:	f7 ea                	imul   %edx
8010070a:	89 d0                	mov    %edx,%eax
8010070c:	c1 f8 04             	sar    $0x4,%eax
8010070f:	89 ca                	mov    %ecx,%edx
80100711:	c1 fa 1f             	sar    $0x1f,%edx
80100714:	29 d0                	sub    %edx,%eax
80100716:	6b d0 35             	imul   $0x35,%eax,%edx
80100719:	89 c8                	mov    %ecx,%eax
8010071b:	29 d0                	sub    %edx,%eax
8010071d:	89 c2                	mov    %eax,%edx
8010071f:	c1 e2 04             	shl    $0x4,%edx
80100722:	29 c2                	sub    %eax,%edx
80100724:	8d 42 02             	lea    0x2(%edx),%eax
80100727:	89 45 f4             	mov    %eax,-0xc(%ebp)
    int y = (console_pos/CONSOLE_HORIZONTAL_MAX)*FONT_HEIGHT;
8010072a:	8b 0d 00 d0 10 80    	mov    0x8010d000,%ecx
80100730:	ba ed 73 48 4d       	mov    $0x4d4873ed,%edx
80100735:	89 c8                	mov    %ecx,%eax
80100737:	f7 ea                	imul   %edx
80100739:	89 d0                	mov    %edx,%eax
8010073b:	c1 f8 04             	sar    $0x4,%eax
8010073e:	c1 f9 1f             	sar    $0x1f,%ecx
80100741:	89 ca                	mov    %ecx,%edx
80100743:	29 d0                	sub    %edx,%eax
80100745:	6b c0 1e             	imul   $0x1e,%eax,%eax
80100748:	89 45 f0             	mov    %eax,-0x10(%ebp)
    font_render(x,y,c);
8010074b:	83 ec 04             	sub    $0x4,%esp
8010074e:	ff 75 08             	push   0x8(%ebp)
80100751:	ff 75 f0             	push   -0x10(%ebp)
80100754:	ff 75 f4             	push   -0xc(%ebp)
80100757:	e8 f5 79 00 00       	call   80108151 <font_render>
8010075c:	83 c4 10             	add    $0x10,%esp
    console_pos++;
8010075f:	a1 00 d0 10 80       	mov    0x8010d000,%eax
80100764:	83 c0 01             	add    $0x1,%eax
80100767:	a3 00 d0 10 80       	mov    %eax,0x8010d000
}
8010076c:	90                   	nop
8010076d:	c9                   	leave  
8010076e:	c3                   	ret    

8010076f <consputc>:


void
consputc(int c)
{
8010076f:	55                   	push   %ebp
80100770:	89 e5                	mov    %esp,%ebp
80100772:	83 ec 08             	sub    $0x8,%esp
  if(panicked){
80100775:	a1 ec 19 19 80       	mov    0x801919ec,%eax
8010077a:	85 c0                	test   %eax,%eax
8010077c:	74 07                	je     80100785 <consputc+0x16>
    cli();
8010077e:	e8 be fb ff ff       	call   80100341 <cli>
    for(;;)
80100783:	eb fe                	jmp    80100783 <consputc+0x14>
      ;
  }

  if(c == BACKSPACE){
80100785:	81 7d 08 00 01 00 00 	cmpl   $0x100,0x8(%ebp)
8010078c:	75 29                	jne    801007b7 <consputc+0x48>
    uartputc('\b'); uartputc(' '); uartputc('\b');
8010078e:	83 ec 0c             	sub    $0xc,%esp
80100791:	6a 08                	push   $0x8
80100793:	e8 c5 5d 00 00       	call   8010655d <uartputc>
80100798:	83 c4 10             	add    $0x10,%esp
8010079b:	83 ec 0c             	sub    $0xc,%esp
8010079e:	6a 20                	push   $0x20
801007a0:	e8 b8 5d 00 00       	call   8010655d <uartputc>
801007a5:	83 c4 10             	add    $0x10,%esp
801007a8:	83 ec 0c             	sub    $0xc,%esp
801007ab:	6a 08                	push   $0x8
801007ad:	e8 ab 5d 00 00       	call   8010655d <uartputc>
801007b2:	83 c4 10             	add    $0x10,%esp
801007b5:	eb 0e                	jmp    801007c5 <consputc+0x56>
  } else {
    uartputc(c);
801007b7:	83 ec 0c             	sub    $0xc,%esp
801007ba:	ff 75 08             	push   0x8(%ebp)
801007bd:	e8 9b 5d 00 00       	call   8010655d <uartputc>
801007c2:	83 c4 10             	add    $0x10,%esp
  }
  graphic_putc(c);
801007c5:	83 ec 0c             	sub    $0xc,%esp
801007c8:	ff 75 08             	push   0x8(%ebp)
801007cb:	e8 6d fe ff ff       	call   8010063d <graphic_putc>
801007d0:	83 c4 10             	add    $0x10,%esp
}
801007d3:	90                   	nop
801007d4:	c9                   	leave  
801007d5:	c3                   	ret    

801007d6 <consoleintr>:

#define C(x)  ((x)-'@')  // Control-x

void
consoleintr(int (*getc)(void))
{
801007d6:	55                   	push   %ebp
801007d7:	89 e5                	mov    %esp,%ebp
801007d9:	83 ec 18             	sub    $0x18,%esp
  int c, doprocdump = 0;
801007dc:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

  acquire(&cons.lock);
801007e3:	83 ec 0c             	sub    $0xc,%esp
801007e6:	68 00 1a 19 80       	push   $0x80191a00
801007eb:	e8 9d 41 00 00       	call   8010498d <acquire>
801007f0:	83 c4 10             	add    $0x10,%esp
  while((c = getc()) >= 0){
801007f3:	e9 50 01 00 00       	jmp    80100948 <consoleintr+0x172>
    switch(c){
801007f8:	83 7d f0 7f          	cmpl   $0x7f,-0x10(%ebp)
801007fc:	0f 84 81 00 00 00    	je     80100883 <consoleintr+0xad>
80100802:	83 7d f0 7f          	cmpl   $0x7f,-0x10(%ebp)
80100806:	0f 8f ac 00 00 00    	jg     801008b8 <consoleintr+0xe2>
8010080c:	83 7d f0 15          	cmpl   $0x15,-0x10(%ebp)
80100810:	74 43                	je     80100855 <consoleintr+0x7f>
80100812:	83 7d f0 15          	cmpl   $0x15,-0x10(%ebp)
80100816:	0f 8f 9c 00 00 00    	jg     801008b8 <consoleintr+0xe2>
8010081c:	83 7d f0 08          	cmpl   $0x8,-0x10(%ebp)
80100820:	74 61                	je     80100883 <consoleintr+0xad>
80100822:	83 7d f0 10          	cmpl   $0x10,-0x10(%ebp)
80100826:	0f 85 8c 00 00 00    	jne    801008b8 <consoleintr+0xe2>
    case C('P'):  // Process listing.
      // procdump() locks cons.lock indirectly; invoke later
      doprocdump = 1;
8010082c:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
      break;
80100833:	e9 10 01 00 00       	jmp    80100948 <consoleintr+0x172>
    case C('U'):  // Kill line.
      while(input.e != input.w &&
            input.buf[(input.e-1) % INPUT_BUF] != '\n'){
        input.e--;
80100838:	a1 e8 19 19 80       	mov    0x801919e8,%eax
8010083d:	83 e8 01             	sub    $0x1,%eax
80100840:	a3 e8 19 19 80       	mov    %eax,0x801919e8
        consputc(BACKSPACE);
80100845:	83 ec 0c             	sub    $0xc,%esp
80100848:	68 00 01 00 00       	push   $0x100
8010084d:	e8 1d ff ff ff       	call   8010076f <consputc>
80100852:	83 c4 10             	add    $0x10,%esp
      while(input.e != input.w &&
80100855:	8b 15 e8 19 19 80    	mov    0x801919e8,%edx
8010085b:	a1 e4 19 19 80       	mov    0x801919e4,%eax
80100860:	39 c2                	cmp    %eax,%edx
80100862:	0f 84 e0 00 00 00    	je     80100948 <consoleintr+0x172>
            input.buf[(input.e-1) % INPUT_BUF] != '\n'){
80100868:	a1 e8 19 19 80       	mov    0x801919e8,%eax
8010086d:	83 e8 01             	sub    $0x1,%eax
80100870:	83 e0 7f             	and    $0x7f,%eax
80100873:	0f b6 80 60 19 19 80 	movzbl -0x7fe6e6a0(%eax),%eax
      while(input.e != input.w &&
8010087a:	3c 0a                	cmp    $0xa,%al
8010087c:	75 ba                	jne    80100838 <consoleintr+0x62>
      }
      break;
8010087e:	e9 c5 00 00 00       	jmp    80100948 <consoleintr+0x172>
    case C('H'): case '\x7f':  // Backspace
      if(input.e != input.w){
80100883:	8b 15 e8 19 19 80    	mov    0x801919e8,%edx
80100889:	a1 e4 19 19 80       	mov    0x801919e4,%eax
8010088e:	39 c2                	cmp    %eax,%edx
80100890:	0f 84 b2 00 00 00    	je     80100948 <consoleintr+0x172>
        input.e--;
80100896:	a1 e8 19 19 80       	mov    0x801919e8,%eax
8010089b:	83 e8 01             	sub    $0x1,%eax
8010089e:	a3 e8 19 19 80       	mov    %eax,0x801919e8
        consputc(BACKSPACE);
801008a3:	83 ec 0c             	sub    $0xc,%esp
801008a6:	68 00 01 00 00       	push   $0x100
801008ab:	e8 bf fe ff ff       	call   8010076f <consputc>
801008b0:	83 c4 10             	add    $0x10,%esp
      }
      break;
801008b3:	e9 90 00 00 00       	jmp    80100948 <consoleintr+0x172>
    default:
      if(c != 0 && input.e-input.r < INPUT_BUF){
801008b8:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
801008bc:	0f 84 85 00 00 00    	je     80100947 <consoleintr+0x171>
801008c2:	a1 e8 19 19 80       	mov    0x801919e8,%eax
801008c7:	8b 15 e0 19 19 80    	mov    0x801919e0,%edx
801008cd:	29 d0                	sub    %edx,%eax
801008cf:	83 f8 7f             	cmp    $0x7f,%eax
801008d2:	77 73                	ja     80100947 <consoleintr+0x171>
        c = (c == '\r') ? '\n' : c;
801008d4:	83 7d f0 0d          	cmpl   $0xd,-0x10(%ebp)
801008d8:	74 05                	je     801008df <consoleintr+0x109>
801008da:	8b 45 f0             	mov    -0x10(%ebp),%eax
801008dd:	eb 05                	jmp    801008e4 <consoleintr+0x10e>
801008df:	b8 0a 00 00 00       	mov    $0xa,%eax
801008e4:	89 45 f0             	mov    %eax,-0x10(%ebp)
        input.buf[input.e++ % INPUT_BUF] = c;
801008e7:	a1 e8 19 19 80       	mov    0x801919e8,%eax
801008ec:	8d 50 01             	lea    0x1(%eax),%edx
801008ef:	89 15 e8 19 19 80    	mov    %edx,0x801919e8
801008f5:	83 e0 7f             	and    $0x7f,%eax
801008f8:	8b 55 f0             	mov    -0x10(%ebp),%edx
801008fb:	88 90 60 19 19 80    	mov    %dl,-0x7fe6e6a0(%eax)
        consputc(c);
80100901:	83 ec 0c             	sub    $0xc,%esp
80100904:	ff 75 f0             	push   -0x10(%ebp)
80100907:	e8 63 fe ff ff       	call   8010076f <consputc>
8010090c:	83 c4 10             	add    $0x10,%esp
        if(c == '\n' || c == C('D') || input.e == input.r+INPUT_BUF){
8010090f:	83 7d f0 0a          	cmpl   $0xa,-0x10(%ebp)
80100913:	74 18                	je     8010092d <consoleintr+0x157>
80100915:	83 7d f0 04          	cmpl   $0x4,-0x10(%ebp)
80100919:	74 12                	je     8010092d <consoleintr+0x157>
8010091b:	a1 e8 19 19 80       	mov    0x801919e8,%eax
80100920:	8b 15 e0 19 19 80    	mov    0x801919e0,%edx
80100926:	83 ea 80             	sub    $0xffffff80,%edx
80100929:	39 d0                	cmp    %edx,%eax
8010092b:	75 1a                	jne    80100947 <consoleintr+0x171>
          input.w = input.e;
8010092d:	a1 e8 19 19 80       	mov    0x801919e8,%eax
80100932:	a3 e4 19 19 80       	mov    %eax,0x801919e4
          wakeup(&input.r);
80100937:	83 ec 0c             	sub    $0xc,%esp
8010093a:	68 e0 19 19 80       	push   $0x801919e0
8010093f:	e8 0f 3d 00 00       	call   80104653 <wakeup>
80100944:	83 c4 10             	add    $0x10,%esp
        }
      }
      break;
80100947:	90                   	nop
  while((c = getc()) >= 0){
80100948:	8b 45 08             	mov    0x8(%ebp),%eax
8010094b:	ff d0                	call   *%eax
8010094d:	89 45 f0             	mov    %eax,-0x10(%ebp)
80100950:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80100954:	0f 89 9e fe ff ff    	jns    801007f8 <consoleintr+0x22>
    }
  }
  release(&cons.lock);
8010095a:	83 ec 0c             	sub    $0xc,%esp
8010095d:	68 00 1a 19 80       	push   $0x80191a00
80100962:	e8 94 40 00 00       	call   801049fb <release>
80100967:	83 c4 10             	add    $0x10,%esp
  if(doprocdump) {
8010096a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
8010096e:	74 05                	je     80100975 <consoleintr+0x19f>
    procdump();  // now call procdump() wo. cons.lock held
80100970:	e8 9c 3d 00 00       	call   80104711 <procdump>
  }
}
80100975:	90                   	nop
80100976:	c9                   	leave  
80100977:	c3                   	ret    

80100978 <consoleread>:

int
consoleread(struct inode *ip, char *dst, int n)
{
80100978:	55                   	push   %ebp
80100979:	89 e5                	mov    %esp,%ebp
8010097b:	83 ec 18             	sub    $0x18,%esp
  uint target;
  int c;

  iunlock(ip);
8010097e:	83 ec 0c             	sub    $0xc,%esp
80100981:	ff 75 08             	push   0x8(%ebp)
80100984:	e8 74 11 00 00       	call   80101afd <iunlock>
80100989:	83 c4 10             	add    $0x10,%esp
  target = n;
8010098c:	8b 45 10             	mov    0x10(%ebp),%eax
8010098f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  acquire(&cons.lock);
80100992:	83 ec 0c             	sub    $0xc,%esp
80100995:	68 00 1a 19 80       	push   $0x80191a00
8010099a:	e8 ee 3f 00 00       	call   8010498d <acquire>
8010099f:	83 c4 10             	add    $0x10,%esp
  while(n > 0){
801009a2:	e9 ab 00 00 00       	jmp    80100a52 <consoleread+0xda>
    while(input.r == input.w){
      if(myproc()->killed){
801009a7:	e8 84 30 00 00       	call   80103a30 <myproc>
801009ac:	8b 40 24             	mov    0x24(%eax),%eax
801009af:	85 c0                	test   %eax,%eax
801009b1:	74 28                	je     801009db <consoleread+0x63>
        release(&cons.lock);
801009b3:	83 ec 0c             	sub    $0xc,%esp
801009b6:	68 00 1a 19 80       	push   $0x80191a00
801009bb:	e8 3b 40 00 00       	call   801049fb <release>
801009c0:	83 c4 10             	add    $0x10,%esp
        ilock(ip);
801009c3:	83 ec 0c             	sub    $0xc,%esp
801009c6:	ff 75 08             	push   0x8(%ebp)
801009c9:	e8 1c 10 00 00       	call   801019ea <ilock>
801009ce:	83 c4 10             	add    $0x10,%esp
        return -1;
801009d1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801009d6:	e9 a9 00 00 00       	jmp    80100a84 <consoleread+0x10c>
      }
      sleep(&input.r, &cons.lock);
801009db:	83 ec 08             	sub    $0x8,%esp
801009de:	68 00 1a 19 80       	push   $0x80191a00
801009e3:	68 e0 19 19 80       	push   $0x801919e0
801009e8:	e8 7c 3b 00 00       	call   80104569 <sleep>
801009ed:	83 c4 10             	add    $0x10,%esp
    while(input.r == input.w){
801009f0:	8b 15 e0 19 19 80    	mov    0x801919e0,%edx
801009f6:	a1 e4 19 19 80       	mov    0x801919e4,%eax
801009fb:	39 c2                	cmp    %eax,%edx
801009fd:	74 a8                	je     801009a7 <consoleread+0x2f>
    }
    c = input.buf[input.r++ % INPUT_BUF];
801009ff:	a1 e0 19 19 80       	mov    0x801919e0,%eax
80100a04:	8d 50 01             	lea    0x1(%eax),%edx
80100a07:	89 15 e0 19 19 80    	mov    %edx,0x801919e0
80100a0d:	83 e0 7f             	and    $0x7f,%eax
80100a10:	0f b6 80 60 19 19 80 	movzbl -0x7fe6e6a0(%eax),%eax
80100a17:	0f be c0             	movsbl %al,%eax
80100a1a:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(c == C('D')){  // EOF
80100a1d:	83 7d f0 04          	cmpl   $0x4,-0x10(%ebp)
80100a21:	75 17                	jne    80100a3a <consoleread+0xc2>
      if(n < target){
80100a23:	8b 45 10             	mov    0x10(%ebp),%eax
80100a26:	39 45 f4             	cmp    %eax,-0xc(%ebp)
80100a29:	76 2f                	jbe    80100a5a <consoleread+0xe2>
        // Save ^D for next time, to make sure
        // caller gets a 0-byte result.
        input.r--;
80100a2b:	a1 e0 19 19 80       	mov    0x801919e0,%eax
80100a30:	83 e8 01             	sub    $0x1,%eax
80100a33:	a3 e0 19 19 80       	mov    %eax,0x801919e0
      }
      break;
80100a38:	eb 20                	jmp    80100a5a <consoleread+0xe2>
    }
    *dst++ = c;
80100a3a:	8b 45 0c             	mov    0xc(%ebp),%eax
80100a3d:	8d 50 01             	lea    0x1(%eax),%edx
80100a40:	89 55 0c             	mov    %edx,0xc(%ebp)
80100a43:	8b 55 f0             	mov    -0x10(%ebp),%edx
80100a46:	88 10                	mov    %dl,(%eax)
    --n;
80100a48:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
    if(c == '\n')
80100a4c:	83 7d f0 0a          	cmpl   $0xa,-0x10(%ebp)
80100a50:	74 0b                	je     80100a5d <consoleread+0xe5>
  while(n > 0){
80100a52:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
80100a56:	7f 98                	jg     801009f0 <consoleread+0x78>
80100a58:	eb 04                	jmp    80100a5e <consoleread+0xe6>
      break;
80100a5a:	90                   	nop
80100a5b:	eb 01                	jmp    80100a5e <consoleread+0xe6>
      break;
80100a5d:	90                   	nop
  }
  release(&cons.lock);
80100a5e:	83 ec 0c             	sub    $0xc,%esp
80100a61:	68 00 1a 19 80       	push   $0x80191a00
80100a66:	e8 90 3f 00 00       	call   801049fb <release>
80100a6b:	83 c4 10             	add    $0x10,%esp
  ilock(ip);
80100a6e:	83 ec 0c             	sub    $0xc,%esp
80100a71:	ff 75 08             	push   0x8(%ebp)
80100a74:	e8 71 0f 00 00       	call   801019ea <ilock>
80100a79:	83 c4 10             	add    $0x10,%esp

  return target - n;
80100a7c:	8b 55 10             	mov    0x10(%ebp),%edx
80100a7f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100a82:	29 d0                	sub    %edx,%eax
}
80100a84:	c9                   	leave  
80100a85:	c3                   	ret    

80100a86 <consolewrite>:

int
consolewrite(struct inode *ip, char *buf, int n)
{
80100a86:	55                   	push   %ebp
80100a87:	89 e5                	mov    %esp,%ebp
80100a89:	83 ec 18             	sub    $0x18,%esp
  int i;

  iunlock(ip);
80100a8c:	83 ec 0c             	sub    $0xc,%esp
80100a8f:	ff 75 08             	push   0x8(%ebp)
80100a92:	e8 66 10 00 00       	call   80101afd <iunlock>
80100a97:	83 c4 10             	add    $0x10,%esp
  acquire(&cons.lock);
80100a9a:	83 ec 0c             	sub    $0xc,%esp
80100a9d:	68 00 1a 19 80       	push   $0x80191a00
80100aa2:	e8 e6 3e 00 00       	call   8010498d <acquire>
80100aa7:	83 c4 10             	add    $0x10,%esp
  for(i = 0; i < n; i++)
80100aaa:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80100ab1:	eb 21                	jmp    80100ad4 <consolewrite+0x4e>
    consputc(buf[i] & 0xff);
80100ab3:	8b 55 f4             	mov    -0xc(%ebp),%edx
80100ab6:	8b 45 0c             	mov    0xc(%ebp),%eax
80100ab9:	01 d0                	add    %edx,%eax
80100abb:	0f b6 00             	movzbl (%eax),%eax
80100abe:	0f be c0             	movsbl %al,%eax
80100ac1:	0f b6 c0             	movzbl %al,%eax
80100ac4:	83 ec 0c             	sub    $0xc,%esp
80100ac7:	50                   	push   %eax
80100ac8:	e8 a2 fc ff ff       	call   8010076f <consputc>
80100acd:	83 c4 10             	add    $0x10,%esp
  for(i = 0; i < n; i++)
80100ad0:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80100ad4:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100ad7:	3b 45 10             	cmp    0x10(%ebp),%eax
80100ada:	7c d7                	jl     80100ab3 <consolewrite+0x2d>
  release(&cons.lock);
80100adc:	83 ec 0c             	sub    $0xc,%esp
80100adf:	68 00 1a 19 80       	push   $0x80191a00
80100ae4:	e8 12 3f 00 00       	call   801049fb <release>
80100ae9:	83 c4 10             	add    $0x10,%esp
  ilock(ip);
80100aec:	83 ec 0c             	sub    $0xc,%esp
80100aef:	ff 75 08             	push   0x8(%ebp)
80100af2:	e8 f3 0e 00 00       	call   801019ea <ilock>
80100af7:	83 c4 10             	add    $0x10,%esp

  return n;
80100afa:	8b 45 10             	mov    0x10(%ebp),%eax
}
80100afd:	c9                   	leave  
80100afe:	c3                   	ret    

80100aff <consoleinit>:

void
consoleinit(void)
{
80100aff:	55                   	push   %ebp
80100b00:	89 e5                	mov    %esp,%ebp
80100b02:	83 ec 18             	sub    $0x18,%esp
  panicked = 0;
80100b05:	c7 05 ec 19 19 80 00 	movl   $0x0,0x801919ec
80100b0c:	00 00 00 
  initlock(&cons.lock, "console");
80100b0f:	83 ec 08             	sub    $0x8,%esp
80100b12:	68 d7 a2 10 80       	push   $0x8010a2d7
80100b17:	68 00 1a 19 80       	push   $0x80191a00
80100b1c:	e8 4a 3e 00 00       	call   8010496b <initlock>
80100b21:	83 c4 10             	add    $0x10,%esp

  devsw[CONSOLE].write = consolewrite;
80100b24:	c7 05 4c 1a 19 80 86 	movl   $0x80100a86,0x80191a4c
80100b2b:	0a 10 80 
  devsw[CONSOLE].read = consoleread;
80100b2e:	c7 05 48 1a 19 80 78 	movl   $0x80100978,0x80191a48
80100b35:	09 10 80 
  
  char *p;
  for(p="Starting XV6_UEFI...\n"; *p; p++)
80100b38:	c7 45 f4 df a2 10 80 	movl   $0x8010a2df,-0xc(%ebp)
80100b3f:	eb 19                	jmp    80100b5a <consoleinit+0x5b>
    graphic_putc(*p);
80100b41:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100b44:	0f b6 00             	movzbl (%eax),%eax
80100b47:	0f be c0             	movsbl %al,%eax
80100b4a:	83 ec 0c             	sub    $0xc,%esp
80100b4d:	50                   	push   %eax
80100b4e:	e8 ea fa ff ff       	call   8010063d <graphic_putc>
80100b53:	83 c4 10             	add    $0x10,%esp
  for(p="Starting XV6_UEFI...\n"; *p; p++)
80100b56:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80100b5a:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100b5d:	0f b6 00             	movzbl (%eax),%eax
80100b60:	84 c0                	test   %al,%al
80100b62:	75 dd                	jne    80100b41 <consoleinit+0x42>
  
  cons.locking = 1;
80100b64:	c7 05 34 1a 19 80 01 	movl   $0x1,0x80191a34
80100b6b:	00 00 00 

  ioapicenable(IRQ_KBD, 0);
80100b6e:	83 ec 08             	sub    $0x8,%esp
80100b71:	6a 00                	push   $0x0
80100b73:	6a 01                	push   $0x1
80100b75:	e8 b4 1a 00 00       	call   8010262e <ioapicenable>
80100b7a:	83 c4 10             	add    $0x10,%esp
}
80100b7d:	90                   	nop
80100b7e:	c9                   	leave  
80100b7f:	c3                   	ret    

80100b80 <exec>:
#include "x86.h"
#include "elf.h"

int
exec(char *path, char **argv)
{
80100b80:	55                   	push   %ebp
80100b81:	89 e5                	mov    %esp,%ebp
80100b83:	81 ec 18 01 00 00    	sub    $0x118,%esp
  uint argc, sz, sp, ustack[3+MAXARG+1];
  struct elfhdr elf;
  struct inode *ip;
  struct proghdr ph;
  pde_t *pgdir, *oldpgdir;
  struct proc *curproc = myproc();
80100b89:	e8 a2 2e 00 00       	call   80103a30 <myproc>
80100b8e:	89 45 d0             	mov    %eax,-0x30(%ebp)

  begin_op();
80100b91:	e8 a6 24 00 00       	call   8010303c <begin_op>

  if((ip = namei(path)) == 0){
80100b96:	83 ec 0c             	sub    $0xc,%esp
80100b99:	ff 75 08             	push   0x8(%ebp)
80100b9c:	e8 7c 19 00 00       	call   8010251d <namei>
80100ba1:	83 c4 10             	add    $0x10,%esp
80100ba4:	89 45 d8             	mov    %eax,-0x28(%ebp)
80100ba7:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
80100bab:	75 1f                	jne    80100bcc <exec+0x4c>
    end_op();
80100bad:	e8 16 25 00 00       	call   801030c8 <end_op>
    cprintf("exec: fail\n");
80100bb2:	83 ec 0c             	sub    $0xc,%esp
80100bb5:	68 f5 a2 10 80       	push   $0x8010a2f5
80100bba:	e8 35 f8 ff ff       	call   801003f4 <cprintf>
80100bbf:	83 c4 10             	add    $0x10,%esp
    return -1;
80100bc2:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80100bc7:	e9 f1 03 00 00       	jmp    80100fbd <exec+0x43d>
  }
  ilock(ip);
80100bcc:	83 ec 0c             	sub    $0xc,%esp
80100bcf:	ff 75 d8             	push   -0x28(%ebp)
80100bd2:	e8 13 0e 00 00       	call   801019ea <ilock>
80100bd7:	83 c4 10             	add    $0x10,%esp
  pgdir = 0;
80100bda:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)

  // Check ELF header
  if(readi(ip, (char*)&elf, 0, sizeof(elf)) != sizeof(elf))
80100be1:	6a 34                	push   $0x34
80100be3:	6a 00                	push   $0x0
80100be5:	8d 85 08 ff ff ff    	lea    -0xf8(%ebp),%eax
80100beb:	50                   	push   %eax
80100bec:	ff 75 d8             	push   -0x28(%ebp)
80100bef:	e8 e2 12 00 00       	call   80101ed6 <readi>
80100bf4:	83 c4 10             	add    $0x10,%esp
80100bf7:	83 f8 34             	cmp    $0x34,%eax
80100bfa:	0f 85 66 03 00 00    	jne    80100f66 <exec+0x3e6>
    goto bad;
  if(elf.magic != ELF_MAGIC)
80100c00:	8b 85 08 ff ff ff    	mov    -0xf8(%ebp),%eax
80100c06:	3d 7f 45 4c 46       	cmp    $0x464c457f,%eax
80100c0b:	0f 85 58 03 00 00    	jne    80100f69 <exec+0x3e9>
    goto bad;

  if((pgdir = setupkvm()) == 0)
80100c11:	e8 43 69 00 00       	call   80107559 <setupkvm>
80100c16:	89 45 d4             	mov    %eax,-0x2c(%ebp)
80100c19:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
80100c1d:	0f 84 49 03 00 00    	je     80100f6c <exec+0x3ec>
    goto bad;

  // Load program into memory.
  sz = 0;
80100c23:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100c2a:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
80100c31:	8b 85 24 ff ff ff    	mov    -0xdc(%ebp),%eax
80100c37:	89 45 e8             	mov    %eax,-0x18(%ebp)
80100c3a:	e9 de 00 00 00       	jmp    80100d1d <exec+0x19d>
    if(readi(ip, (char*)&ph, off, sizeof(ph)) != sizeof(ph))
80100c3f:	8b 45 e8             	mov    -0x18(%ebp),%eax
80100c42:	6a 20                	push   $0x20
80100c44:	50                   	push   %eax
80100c45:	8d 85 e8 fe ff ff    	lea    -0x118(%ebp),%eax
80100c4b:	50                   	push   %eax
80100c4c:	ff 75 d8             	push   -0x28(%ebp)
80100c4f:	e8 82 12 00 00       	call   80101ed6 <readi>
80100c54:	83 c4 10             	add    $0x10,%esp
80100c57:	83 f8 20             	cmp    $0x20,%eax
80100c5a:	0f 85 0f 03 00 00    	jne    80100f6f <exec+0x3ef>
      goto bad;
    if(ph.type != ELF_PROG_LOAD)
80100c60:	8b 85 e8 fe ff ff    	mov    -0x118(%ebp),%eax
80100c66:	83 f8 01             	cmp    $0x1,%eax
80100c69:	0f 85 a0 00 00 00    	jne    80100d0f <exec+0x18f>
      continue;
    if(ph.memsz < ph.filesz)
80100c6f:	8b 95 fc fe ff ff    	mov    -0x104(%ebp),%edx
80100c75:	8b 85 f8 fe ff ff    	mov    -0x108(%ebp),%eax
80100c7b:	39 c2                	cmp    %eax,%edx
80100c7d:	0f 82 ef 02 00 00    	jb     80100f72 <exec+0x3f2>
      goto bad;
    if(ph.vaddr + ph.memsz < ph.vaddr)
80100c83:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
80100c89:	8b 85 fc fe ff ff    	mov    -0x104(%ebp),%eax
80100c8f:	01 c2                	add    %eax,%edx
80100c91:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
80100c97:	39 c2                	cmp    %eax,%edx
80100c99:	0f 82 d6 02 00 00    	jb     80100f75 <exec+0x3f5>
      goto bad;
    if((sz = allocuvm(pgdir, sz, ph.vaddr + ph.memsz)) == 0)
80100c9f:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
80100ca5:	8b 85 fc fe ff ff    	mov    -0x104(%ebp),%eax
80100cab:	01 d0                	add    %edx,%eax
80100cad:	83 ec 04             	sub    $0x4,%esp
80100cb0:	50                   	push   %eax
80100cb1:	ff 75 e0             	push   -0x20(%ebp)
80100cb4:	ff 75 d4             	push   -0x2c(%ebp)
80100cb7:	e8 96 6c 00 00       	call   80107952 <allocuvm>
80100cbc:	83 c4 10             	add    $0x10,%esp
80100cbf:	89 45 e0             	mov    %eax,-0x20(%ebp)
80100cc2:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
80100cc6:	0f 84 ac 02 00 00    	je     80100f78 <exec+0x3f8>
      goto bad;
    if(ph.vaddr % PGSIZE != 0)
80100ccc:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
80100cd2:	25 ff 0f 00 00       	and    $0xfff,%eax
80100cd7:	85 c0                	test   %eax,%eax
80100cd9:	0f 85 9c 02 00 00    	jne    80100f7b <exec+0x3fb>
      goto bad;
    if(loaduvm(pgdir, (char*)ph.vaddr, ip, ph.off, ph.filesz) < 0)
80100cdf:	8b 95 f8 fe ff ff    	mov    -0x108(%ebp),%edx
80100ce5:	8b 85 ec fe ff ff    	mov    -0x114(%ebp),%eax
80100ceb:	8b 8d f0 fe ff ff    	mov    -0x110(%ebp),%ecx
80100cf1:	83 ec 0c             	sub    $0xc,%esp
80100cf4:	52                   	push   %edx
80100cf5:	50                   	push   %eax
80100cf6:	ff 75 d8             	push   -0x28(%ebp)
80100cf9:	51                   	push   %ecx
80100cfa:	ff 75 d4             	push   -0x2c(%ebp)
80100cfd:	e8 83 6b 00 00       	call   80107885 <loaduvm>
80100d02:	83 c4 20             	add    $0x20,%esp
80100d05:	85 c0                	test   %eax,%eax
80100d07:	0f 88 71 02 00 00    	js     80100f7e <exec+0x3fe>
80100d0d:	eb 01                	jmp    80100d10 <exec+0x190>
      continue;
80100d0f:	90                   	nop
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100d10:	83 45 ec 01          	addl   $0x1,-0x14(%ebp)
80100d14:	8b 45 e8             	mov    -0x18(%ebp),%eax
80100d17:	83 c0 20             	add    $0x20,%eax
80100d1a:	89 45 e8             	mov    %eax,-0x18(%ebp)
80100d1d:	0f b7 85 34 ff ff ff 	movzwl -0xcc(%ebp),%eax
80100d24:	0f b7 c0             	movzwl %ax,%eax
80100d27:	39 45 ec             	cmp    %eax,-0x14(%ebp)
80100d2a:	0f 8c 0f ff ff ff    	jl     80100c3f <exec+0xbf>
      goto bad;
  }
  iunlockput(ip);
80100d30:	83 ec 0c             	sub    $0xc,%esp
80100d33:	ff 75 d8             	push   -0x28(%ebp)
80100d36:	e8 e0 0e 00 00       	call   80101c1b <iunlockput>
80100d3b:	83 c4 10             	add    $0x10,%esp
  end_op();
80100d3e:	e8 85 23 00 00       	call   801030c8 <end_op>
  ip = 0;
80100d43:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)

  // Allocate two pages at the next page boundary.
  // Make the first inaccessible.  Use the second as the user stack.
  sz = PGROUNDUP(sz);
80100d4a:	8b 45 e0             	mov    -0x20(%ebp),%eax
80100d4d:	05 ff 0f 00 00       	add    $0xfff,%eax
80100d52:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80100d57:	89 45 e0             	mov    %eax,-0x20(%ebp)
  if((sz = allocuvm(pgdir, sz, sz + 2*PGSIZE)) == 0)
80100d5a:	8b 45 e0             	mov    -0x20(%ebp),%eax
80100d5d:	05 00 20 00 00       	add    $0x2000,%eax
80100d62:	83 ec 04             	sub    $0x4,%esp
80100d65:	50                   	push   %eax
80100d66:	ff 75 e0             	push   -0x20(%ebp)
80100d69:	ff 75 d4             	push   -0x2c(%ebp)
80100d6c:	e8 e1 6b 00 00       	call   80107952 <allocuvm>
80100d71:	83 c4 10             	add    $0x10,%esp
80100d74:	89 45 e0             	mov    %eax,-0x20(%ebp)
80100d77:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
80100d7b:	0f 84 00 02 00 00    	je     80100f81 <exec+0x401>
    goto bad;
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
80100d81:	8b 45 e0             	mov    -0x20(%ebp),%eax
80100d84:	2d 00 20 00 00       	sub    $0x2000,%eax
80100d89:	83 ec 08             	sub    $0x8,%esp
80100d8c:	50                   	push   %eax
80100d8d:	ff 75 d4             	push   -0x2c(%ebp)
80100d90:	e8 1f 6e 00 00       	call   80107bb4 <clearpteu>
80100d95:	83 c4 10             	add    $0x10,%esp
  sp = sz;
80100d98:	8b 45 e0             	mov    -0x20(%ebp),%eax
80100d9b:	89 45 dc             	mov    %eax,-0x24(%ebp)

  // Push argument strings, prepare rest of stack in ustack.
  for(argc = 0; argv[argc]; argc++) {
80100d9e:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
80100da5:	e9 96 00 00 00       	jmp    80100e40 <exec+0x2c0>
    if(argc >= MAXARG)
80100daa:	83 7d e4 1f          	cmpl   $0x1f,-0x1c(%ebp)
80100dae:	0f 87 d0 01 00 00    	ja     80100f84 <exec+0x404>
      goto bad;
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
80100db4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100db7:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80100dbe:	8b 45 0c             	mov    0xc(%ebp),%eax
80100dc1:	01 d0                	add    %edx,%eax
80100dc3:	8b 00                	mov    (%eax),%eax
80100dc5:	83 ec 0c             	sub    $0xc,%esp
80100dc8:	50                   	push   %eax
80100dc9:	e8 83 40 00 00       	call   80104e51 <strlen>
80100dce:	83 c4 10             	add    $0x10,%esp
80100dd1:	89 c2                	mov    %eax,%edx
80100dd3:	8b 45 dc             	mov    -0x24(%ebp),%eax
80100dd6:	29 d0                	sub    %edx,%eax
80100dd8:	83 e8 01             	sub    $0x1,%eax
80100ddb:	83 e0 fc             	and    $0xfffffffc,%eax
80100dde:	89 45 dc             	mov    %eax,-0x24(%ebp)
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
80100de1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100de4:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80100deb:	8b 45 0c             	mov    0xc(%ebp),%eax
80100dee:	01 d0                	add    %edx,%eax
80100df0:	8b 00                	mov    (%eax),%eax
80100df2:	83 ec 0c             	sub    $0xc,%esp
80100df5:	50                   	push   %eax
80100df6:	e8 56 40 00 00       	call   80104e51 <strlen>
80100dfb:	83 c4 10             	add    $0x10,%esp
80100dfe:	83 c0 01             	add    $0x1,%eax
80100e01:	89 c2                	mov    %eax,%edx
80100e03:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100e06:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
80100e0d:	8b 45 0c             	mov    0xc(%ebp),%eax
80100e10:	01 c8                	add    %ecx,%eax
80100e12:	8b 00                	mov    (%eax),%eax
80100e14:	52                   	push   %edx
80100e15:	50                   	push   %eax
80100e16:	ff 75 dc             	push   -0x24(%ebp)
80100e19:	ff 75 d4             	push   -0x2c(%ebp)
80100e1c:	e8 32 6f 00 00       	call   80107d53 <copyout>
80100e21:	83 c4 10             	add    $0x10,%esp
80100e24:	85 c0                	test   %eax,%eax
80100e26:	0f 88 5b 01 00 00    	js     80100f87 <exec+0x407>
      goto bad;
    ustack[3+argc] = sp;
80100e2c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100e2f:	8d 50 03             	lea    0x3(%eax),%edx
80100e32:	8b 45 dc             	mov    -0x24(%ebp),%eax
80100e35:	89 84 95 3c ff ff ff 	mov    %eax,-0xc4(%ebp,%edx,4)
  for(argc = 0; argv[argc]; argc++) {
80100e3c:	83 45 e4 01          	addl   $0x1,-0x1c(%ebp)
80100e40:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100e43:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80100e4a:	8b 45 0c             	mov    0xc(%ebp),%eax
80100e4d:	01 d0                	add    %edx,%eax
80100e4f:	8b 00                	mov    (%eax),%eax
80100e51:	85 c0                	test   %eax,%eax
80100e53:	0f 85 51 ff ff ff    	jne    80100daa <exec+0x22a>
  }
  ustack[3+argc] = 0;
80100e59:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100e5c:	83 c0 03             	add    $0x3,%eax
80100e5f:	c7 84 85 3c ff ff ff 	movl   $0x0,-0xc4(%ebp,%eax,4)
80100e66:	00 00 00 00 

  ustack[0] = 0xffffffff;  // fake return PC
80100e6a:	c7 85 3c ff ff ff ff 	movl   $0xffffffff,-0xc4(%ebp)
80100e71:	ff ff ff 
  ustack[1] = argc;
80100e74:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100e77:	89 85 40 ff ff ff    	mov    %eax,-0xc0(%ebp)
  ustack[2] = sp - (argc+1)*4;  // argv pointer
80100e7d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100e80:	83 c0 01             	add    $0x1,%eax
80100e83:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80100e8a:	8b 45 dc             	mov    -0x24(%ebp),%eax
80100e8d:	29 d0                	sub    %edx,%eax
80100e8f:	89 85 44 ff ff ff    	mov    %eax,-0xbc(%ebp)

  sp -= (3+argc+1) * 4;
80100e95:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100e98:	83 c0 04             	add    $0x4,%eax
80100e9b:	c1 e0 02             	shl    $0x2,%eax
80100e9e:	29 45 dc             	sub    %eax,-0x24(%ebp)
  if(copyout(pgdir, sp, ustack, (3+argc+1)*4) < 0)
80100ea1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100ea4:	83 c0 04             	add    $0x4,%eax
80100ea7:	c1 e0 02             	shl    $0x2,%eax
80100eaa:	50                   	push   %eax
80100eab:	8d 85 3c ff ff ff    	lea    -0xc4(%ebp),%eax
80100eb1:	50                   	push   %eax
80100eb2:	ff 75 dc             	push   -0x24(%ebp)
80100eb5:	ff 75 d4             	push   -0x2c(%ebp)
80100eb8:	e8 96 6e 00 00       	call   80107d53 <copyout>
80100ebd:	83 c4 10             	add    $0x10,%esp
80100ec0:	85 c0                	test   %eax,%eax
80100ec2:	0f 88 c2 00 00 00    	js     80100f8a <exec+0x40a>
    goto bad;

  // Save program name for debugging.
  for(last=s=path; *s; s++)
80100ec8:	8b 45 08             	mov    0x8(%ebp),%eax
80100ecb:	89 45 f4             	mov    %eax,-0xc(%ebp)
80100ece:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100ed1:	89 45 f0             	mov    %eax,-0x10(%ebp)
80100ed4:	eb 17                	jmp    80100eed <exec+0x36d>
    if(*s == '/')
80100ed6:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100ed9:	0f b6 00             	movzbl (%eax),%eax
80100edc:	3c 2f                	cmp    $0x2f,%al
80100ede:	75 09                	jne    80100ee9 <exec+0x369>
      last = s+1;
80100ee0:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100ee3:	83 c0 01             	add    $0x1,%eax
80100ee6:	89 45 f0             	mov    %eax,-0x10(%ebp)
  for(last=s=path; *s; s++)
80100ee9:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80100eed:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100ef0:	0f b6 00             	movzbl (%eax),%eax
80100ef3:	84 c0                	test   %al,%al
80100ef5:	75 df                	jne    80100ed6 <exec+0x356>
  safestrcpy(curproc->name, last, sizeof(curproc->name));
80100ef7:	8b 45 d0             	mov    -0x30(%ebp),%eax
80100efa:	83 c0 6c             	add    $0x6c,%eax
80100efd:	83 ec 04             	sub    $0x4,%esp
80100f00:	6a 10                	push   $0x10
80100f02:	ff 75 f0             	push   -0x10(%ebp)
80100f05:	50                   	push   %eax
80100f06:	e8 fb 3e 00 00       	call   80104e06 <safestrcpy>
80100f0b:	83 c4 10             	add    $0x10,%esp

  // Commit to the user image.
  oldpgdir = curproc->pgdir;
80100f0e:	8b 45 d0             	mov    -0x30(%ebp),%eax
80100f11:	8b 40 04             	mov    0x4(%eax),%eax
80100f14:	89 45 cc             	mov    %eax,-0x34(%ebp)
  curproc->pgdir = pgdir;
80100f17:	8b 45 d0             	mov    -0x30(%ebp),%eax
80100f1a:	8b 55 d4             	mov    -0x2c(%ebp),%edx
80100f1d:	89 50 04             	mov    %edx,0x4(%eax)
  curproc->sz = sz;
80100f20:	8b 45 d0             	mov    -0x30(%ebp),%eax
80100f23:	8b 55 e0             	mov    -0x20(%ebp),%edx
80100f26:	89 10                	mov    %edx,(%eax)
  curproc->tf->eip = elf.entry;  // main
80100f28:	8b 45 d0             	mov    -0x30(%ebp),%eax
80100f2b:	8b 40 18             	mov    0x18(%eax),%eax
80100f2e:	8b 95 20 ff ff ff    	mov    -0xe0(%ebp),%edx
80100f34:	89 50 38             	mov    %edx,0x38(%eax)
  curproc->tf->esp = sp;
80100f37:	8b 45 d0             	mov    -0x30(%ebp),%eax
80100f3a:	8b 40 18             	mov    0x18(%eax),%eax
80100f3d:	8b 55 dc             	mov    -0x24(%ebp),%edx
80100f40:	89 50 44             	mov    %edx,0x44(%eax)
  switchuvm(curproc);
80100f43:	83 ec 0c             	sub    $0xc,%esp
80100f46:	ff 75 d0             	push   -0x30(%ebp)
80100f49:	e8 28 67 00 00       	call   80107676 <switchuvm>
80100f4e:	83 c4 10             	add    $0x10,%esp
  freevm(oldpgdir);
80100f51:	83 ec 0c             	sub    $0xc,%esp
80100f54:	ff 75 cc             	push   -0x34(%ebp)
80100f57:	e8 bf 6b 00 00       	call   80107b1b <freevm>
80100f5c:	83 c4 10             	add    $0x10,%esp
  return 0;
80100f5f:	b8 00 00 00 00       	mov    $0x0,%eax
80100f64:	eb 57                	jmp    80100fbd <exec+0x43d>
    goto bad;
80100f66:	90                   	nop
80100f67:	eb 22                	jmp    80100f8b <exec+0x40b>
    goto bad;
80100f69:	90                   	nop
80100f6a:	eb 1f                	jmp    80100f8b <exec+0x40b>
    goto bad;
80100f6c:	90                   	nop
80100f6d:	eb 1c                	jmp    80100f8b <exec+0x40b>
      goto bad;
80100f6f:	90                   	nop
80100f70:	eb 19                	jmp    80100f8b <exec+0x40b>
      goto bad;
80100f72:	90                   	nop
80100f73:	eb 16                	jmp    80100f8b <exec+0x40b>
      goto bad;
80100f75:	90                   	nop
80100f76:	eb 13                	jmp    80100f8b <exec+0x40b>
      goto bad;
80100f78:	90                   	nop
80100f79:	eb 10                	jmp    80100f8b <exec+0x40b>
      goto bad;
80100f7b:	90                   	nop
80100f7c:	eb 0d                	jmp    80100f8b <exec+0x40b>
      goto bad;
80100f7e:	90                   	nop
80100f7f:	eb 0a                	jmp    80100f8b <exec+0x40b>
    goto bad;
80100f81:	90                   	nop
80100f82:	eb 07                	jmp    80100f8b <exec+0x40b>
      goto bad;
80100f84:	90                   	nop
80100f85:	eb 04                	jmp    80100f8b <exec+0x40b>
      goto bad;
80100f87:	90                   	nop
80100f88:	eb 01                	jmp    80100f8b <exec+0x40b>
    goto bad;
80100f8a:	90                   	nop

 bad:
  if(pgdir)
80100f8b:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
80100f8f:	74 0e                	je     80100f9f <exec+0x41f>
    freevm(pgdir);
80100f91:	83 ec 0c             	sub    $0xc,%esp
80100f94:	ff 75 d4             	push   -0x2c(%ebp)
80100f97:	e8 7f 6b 00 00       	call   80107b1b <freevm>
80100f9c:	83 c4 10             	add    $0x10,%esp
  if(ip){
80100f9f:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
80100fa3:	74 13                	je     80100fb8 <exec+0x438>
    iunlockput(ip);
80100fa5:	83 ec 0c             	sub    $0xc,%esp
80100fa8:	ff 75 d8             	push   -0x28(%ebp)
80100fab:	e8 6b 0c 00 00       	call   80101c1b <iunlockput>
80100fb0:	83 c4 10             	add    $0x10,%esp
    end_op();
80100fb3:	e8 10 21 00 00       	call   801030c8 <end_op>
  }
  return -1;
80100fb8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80100fbd:	c9                   	leave  
80100fbe:	c3                   	ret    

80100fbf <fileinit>:
  struct file file[NFILE];
} ftable;

void
fileinit(void)
{
80100fbf:	55                   	push   %ebp
80100fc0:	89 e5                	mov    %esp,%ebp
80100fc2:	83 ec 08             	sub    $0x8,%esp
  initlock(&ftable.lock, "ftable");
80100fc5:	83 ec 08             	sub    $0x8,%esp
80100fc8:	68 01 a3 10 80       	push   $0x8010a301
80100fcd:	68 a0 1a 19 80       	push   $0x80191aa0
80100fd2:	e8 94 39 00 00       	call   8010496b <initlock>
80100fd7:	83 c4 10             	add    $0x10,%esp
}
80100fda:	90                   	nop
80100fdb:	c9                   	leave  
80100fdc:	c3                   	ret    

80100fdd <filealloc>:

// Allocate a file structure.
struct file*
filealloc(void)
{
80100fdd:	55                   	push   %ebp
80100fde:	89 e5                	mov    %esp,%ebp
80100fe0:	83 ec 18             	sub    $0x18,%esp
  struct file *f;

  acquire(&ftable.lock);
80100fe3:	83 ec 0c             	sub    $0xc,%esp
80100fe6:	68 a0 1a 19 80       	push   $0x80191aa0
80100feb:	e8 9d 39 00 00       	call   8010498d <acquire>
80100ff0:	83 c4 10             	add    $0x10,%esp
  for(f = ftable.file; f < ftable.file + NFILE; f++){
80100ff3:	c7 45 f4 d4 1a 19 80 	movl   $0x80191ad4,-0xc(%ebp)
80100ffa:	eb 2d                	jmp    80101029 <filealloc+0x4c>
    if(f->ref == 0){
80100ffc:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100fff:	8b 40 04             	mov    0x4(%eax),%eax
80101002:	85 c0                	test   %eax,%eax
80101004:	75 1f                	jne    80101025 <filealloc+0x48>
      f->ref = 1;
80101006:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101009:	c7 40 04 01 00 00 00 	movl   $0x1,0x4(%eax)
      release(&ftable.lock);
80101010:	83 ec 0c             	sub    $0xc,%esp
80101013:	68 a0 1a 19 80       	push   $0x80191aa0
80101018:	e8 de 39 00 00       	call   801049fb <release>
8010101d:	83 c4 10             	add    $0x10,%esp
      return f;
80101020:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101023:	eb 23                	jmp    80101048 <filealloc+0x6b>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
80101025:	83 45 f4 18          	addl   $0x18,-0xc(%ebp)
80101029:	b8 34 24 19 80       	mov    $0x80192434,%eax
8010102e:	39 45 f4             	cmp    %eax,-0xc(%ebp)
80101031:	72 c9                	jb     80100ffc <filealloc+0x1f>
    }
  }
  release(&ftable.lock);
80101033:	83 ec 0c             	sub    $0xc,%esp
80101036:	68 a0 1a 19 80       	push   $0x80191aa0
8010103b:	e8 bb 39 00 00       	call   801049fb <release>
80101040:	83 c4 10             	add    $0x10,%esp
  return 0;
80101043:	b8 00 00 00 00       	mov    $0x0,%eax
}
80101048:	c9                   	leave  
80101049:	c3                   	ret    

8010104a <filedup>:

// Increment ref count for file f.
struct file*
filedup(struct file *f)
{
8010104a:	55                   	push   %ebp
8010104b:	89 e5                	mov    %esp,%ebp
8010104d:	83 ec 08             	sub    $0x8,%esp
  acquire(&ftable.lock);
80101050:	83 ec 0c             	sub    $0xc,%esp
80101053:	68 a0 1a 19 80       	push   $0x80191aa0
80101058:	e8 30 39 00 00       	call   8010498d <acquire>
8010105d:	83 c4 10             	add    $0x10,%esp
  if(f->ref < 1)
80101060:	8b 45 08             	mov    0x8(%ebp),%eax
80101063:	8b 40 04             	mov    0x4(%eax),%eax
80101066:	85 c0                	test   %eax,%eax
80101068:	7f 0d                	jg     80101077 <filedup+0x2d>
    panic("filedup");
8010106a:	83 ec 0c             	sub    $0xc,%esp
8010106d:	68 08 a3 10 80       	push   $0x8010a308
80101072:	e8 32 f5 ff ff       	call   801005a9 <panic>
  f->ref++;
80101077:	8b 45 08             	mov    0x8(%ebp),%eax
8010107a:	8b 40 04             	mov    0x4(%eax),%eax
8010107d:	8d 50 01             	lea    0x1(%eax),%edx
80101080:	8b 45 08             	mov    0x8(%ebp),%eax
80101083:	89 50 04             	mov    %edx,0x4(%eax)
  release(&ftable.lock);
80101086:	83 ec 0c             	sub    $0xc,%esp
80101089:	68 a0 1a 19 80       	push   $0x80191aa0
8010108e:	e8 68 39 00 00       	call   801049fb <release>
80101093:	83 c4 10             	add    $0x10,%esp
  return f;
80101096:	8b 45 08             	mov    0x8(%ebp),%eax
}
80101099:	c9                   	leave  
8010109a:	c3                   	ret    

8010109b <fileclose>:

// Close file f.  (Decrement ref count, close when reaches 0.)
void
fileclose(struct file *f)
{
8010109b:	55                   	push   %ebp
8010109c:	89 e5                	mov    %esp,%ebp
8010109e:	83 ec 28             	sub    $0x28,%esp
  struct file ff;

  acquire(&ftable.lock);
801010a1:	83 ec 0c             	sub    $0xc,%esp
801010a4:	68 a0 1a 19 80       	push   $0x80191aa0
801010a9:	e8 df 38 00 00       	call   8010498d <acquire>
801010ae:	83 c4 10             	add    $0x10,%esp
  if(f->ref < 1)
801010b1:	8b 45 08             	mov    0x8(%ebp),%eax
801010b4:	8b 40 04             	mov    0x4(%eax),%eax
801010b7:	85 c0                	test   %eax,%eax
801010b9:	7f 0d                	jg     801010c8 <fileclose+0x2d>
    panic("fileclose");
801010bb:	83 ec 0c             	sub    $0xc,%esp
801010be:	68 10 a3 10 80       	push   $0x8010a310
801010c3:	e8 e1 f4 ff ff       	call   801005a9 <panic>
  if(--f->ref > 0){
801010c8:	8b 45 08             	mov    0x8(%ebp),%eax
801010cb:	8b 40 04             	mov    0x4(%eax),%eax
801010ce:	8d 50 ff             	lea    -0x1(%eax),%edx
801010d1:	8b 45 08             	mov    0x8(%ebp),%eax
801010d4:	89 50 04             	mov    %edx,0x4(%eax)
801010d7:	8b 45 08             	mov    0x8(%ebp),%eax
801010da:	8b 40 04             	mov    0x4(%eax),%eax
801010dd:	85 c0                	test   %eax,%eax
801010df:	7e 15                	jle    801010f6 <fileclose+0x5b>
    release(&ftable.lock);
801010e1:	83 ec 0c             	sub    $0xc,%esp
801010e4:	68 a0 1a 19 80       	push   $0x80191aa0
801010e9:	e8 0d 39 00 00       	call   801049fb <release>
801010ee:	83 c4 10             	add    $0x10,%esp
801010f1:	e9 8b 00 00 00       	jmp    80101181 <fileclose+0xe6>
    return;
  }
  ff = *f;
801010f6:	8b 45 08             	mov    0x8(%ebp),%eax
801010f9:	8b 10                	mov    (%eax),%edx
801010fb:	89 55 e0             	mov    %edx,-0x20(%ebp)
801010fe:	8b 50 04             	mov    0x4(%eax),%edx
80101101:	89 55 e4             	mov    %edx,-0x1c(%ebp)
80101104:	8b 50 08             	mov    0x8(%eax),%edx
80101107:	89 55 e8             	mov    %edx,-0x18(%ebp)
8010110a:	8b 50 0c             	mov    0xc(%eax),%edx
8010110d:	89 55 ec             	mov    %edx,-0x14(%ebp)
80101110:	8b 50 10             	mov    0x10(%eax),%edx
80101113:	89 55 f0             	mov    %edx,-0x10(%ebp)
80101116:	8b 40 14             	mov    0x14(%eax),%eax
80101119:	89 45 f4             	mov    %eax,-0xc(%ebp)
  f->ref = 0;
8010111c:	8b 45 08             	mov    0x8(%ebp),%eax
8010111f:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  f->type = FD_NONE;
80101126:	8b 45 08             	mov    0x8(%ebp),%eax
80101129:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  release(&ftable.lock);
8010112f:	83 ec 0c             	sub    $0xc,%esp
80101132:	68 a0 1a 19 80       	push   $0x80191aa0
80101137:	e8 bf 38 00 00       	call   801049fb <release>
8010113c:	83 c4 10             	add    $0x10,%esp

  if(ff.type == FD_PIPE)
8010113f:	8b 45 e0             	mov    -0x20(%ebp),%eax
80101142:	83 f8 01             	cmp    $0x1,%eax
80101145:	75 19                	jne    80101160 <fileclose+0xc5>
    pipeclose(ff.pipe, ff.writable);
80101147:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
8010114b:	0f be d0             	movsbl %al,%edx
8010114e:	8b 45 ec             	mov    -0x14(%ebp),%eax
80101151:	83 ec 08             	sub    $0x8,%esp
80101154:	52                   	push   %edx
80101155:	50                   	push   %eax
80101156:	e8 64 25 00 00       	call   801036bf <pipeclose>
8010115b:	83 c4 10             	add    $0x10,%esp
8010115e:	eb 21                	jmp    80101181 <fileclose+0xe6>
  else if(ff.type == FD_INODE){
80101160:	8b 45 e0             	mov    -0x20(%ebp),%eax
80101163:	83 f8 02             	cmp    $0x2,%eax
80101166:	75 19                	jne    80101181 <fileclose+0xe6>
    begin_op();
80101168:	e8 cf 1e 00 00       	call   8010303c <begin_op>
    iput(ff.ip);
8010116d:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101170:	83 ec 0c             	sub    $0xc,%esp
80101173:	50                   	push   %eax
80101174:	e8 d2 09 00 00       	call   80101b4b <iput>
80101179:	83 c4 10             	add    $0x10,%esp
    end_op();
8010117c:	e8 47 1f 00 00       	call   801030c8 <end_op>
  }
}
80101181:	c9                   	leave  
80101182:	c3                   	ret    

80101183 <filestat>:

// Get metadata about file f.
int
filestat(struct file *f, struct stat *st)
{
80101183:	55                   	push   %ebp
80101184:	89 e5                	mov    %esp,%ebp
80101186:	83 ec 08             	sub    $0x8,%esp
  if(f->type == FD_INODE){
80101189:	8b 45 08             	mov    0x8(%ebp),%eax
8010118c:	8b 00                	mov    (%eax),%eax
8010118e:	83 f8 02             	cmp    $0x2,%eax
80101191:	75 40                	jne    801011d3 <filestat+0x50>
    ilock(f->ip);
80101193:	8b 45 08             	mov    0x8(%ebp),%eax
80101196:	8b 40 10             	mov    0x10(%eax),%eax
80101199:	83 ec 0c             	sub    $0xc,%esp
8010119c:	50                   	push   %eax
8010119d:	e8 48 08 00 00       	call   801019ea <ilock>
801011a2:	83 c4 10             	add    $0x10,%esp
    stati(f->ip, st);
801011a5:	8b 45 08             	mov    0x8(%ebp),%eax
801011a8:	8b 40 10             	mov    0x10(%eax),%eax
801011ab:	83 ec 08             	sub    $0x8,%esp
801011ae:	ff 75 0c             	push   0xc(%ebp)
801011b1:	50                   	push   %eax
801011b2:	e8 d9 0c 00 00       	call   80101e90 <stati>
801011b7:	83 c4 10             	add    $0x10,%esp
    iunlock(f->ip);
801011ba:	8b 45 08             	mov    0x8(%ebp),%eax
801011bd:	8b 40 10             	mov    0x10(%eax),%eax
801011c0:	83 ec 0c             	sub    $0xc,%esp
801011c3:	50                   	push   %eax
801011c4:	e8 34 09 00 00       	call   80101afd <iunlock>
801011c9:	83 c4 10             	add    $0x10,%esp
    return 0;
801011cc:	b8 00 00 00 00       	mov    $0x0,%eax
801011d1:	eb 05                	jmp    801011d8 <filestat+0x55>
  }
  return -1;
801011d3:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801011d8:	c9                   	leave  
801011d9:	c3                   	ret    

801011da <fileread>:

// Read from file f.
int
fileread(struct file *f, char *addr, int n)
{
801011da:	55                   	push   %ebp
801011db:	89 e5                	mov    %esp,%ebp
801011dd:	83 ec 18             	sub    $0x18,%esp
  int r;

  if(f->readable == 0)
801011e0:	8b 45 08             	mov    0x8(%ebp),%eax
801011e3:	0f b6 40 08          	movzbl 0x8(%eax),%eax
801011e7:	84 c0                	test   %al,%al
801011e9:	75 0a                	jne    801011f5 <fileread+0x1b>
    return -1;
801011eb:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801011f0:	e9 9b 00 00 00       	jmp    80101290 <fileread+0xb6>
  if(f->type == FD_PIPE)
801011f5:	8b 45 08             	mov    0x8(%ebp),%eax
801011f8:	8b 00                	mov    (%eax),%eax
801011fa:	83 f8 01             	cmp    $0x1,%eax
801011fd:	75 1a                	jne    80101219 <fileread+0x3f>
    return piperead(f->pipe, addr, n);
801011ff:	8b 45 08             	mov    0x8(%ebp),%eax
80101202:	8b 40 0c             	mov    0xc(%eax),%eax
80101205:	83 ec 04             	sub    $0x4,%esp
80101208:	ff 75 10             	push   0x10(%ebp)
8010120b:	ff 75 0c             	push   0xc(%ebp)
8010120e:	50                   	push   %eax
8010120f:	e8 58 26 00 00       	call   8010386c <piperead>
80101214:	83 c4 10             	add    $0x10,%esp
80101217:	eb 77                	jmp    80101290 <fileread+0xb6>
  if(f->type == FD_INODE){
80101219:	8b 45 08             	mov    0x8(%ebp),%eax
8010121c:	8b 00                	mov    (%eax),%eax
8010121e:	83 f8 02             	cmp    $0x2,%eax
80101221:	75 60                	jne    80101283 <fileread+0xa9>
    ilock(f->ip);
80101223:	8b 45 08             	mov    0x8(%ebp),%eax
80101226:	8b 40 10             	mov    0x10(%eax),%eax
80101229:	83 ec 0c             	sub    $0xc,%esp
8010122c:	50                   	push   %eax
8010122d:	e8 b8 07 00 00       	call   801019ea <ilock>
80101232:	83 c4 10             	add    $0x10,%esp
    if((r = readi(f->ip, addr, f->off, n)) > 0)
80101235:	8b 4d 10             	mov    0x10(%ebp),%ecx
80101238:	8b 45 08             	mov    0x8(%ebp),%eax
8010123b:	8b 50 14             	mov    0x14(%eax),%edx
8010123e:	8b 45 08             	mov    0x8(%ebp),%eax
80101241:	8b 40 10             	mov    0x10(%eax),%eax
80101244:	51                   	push   %ecx
80101245:	52                   	push   %edx
80101246:	ff 75 0c             	push   0xc(%ebp)
80101249:	50                   	push   %eax
8010124a:	e8 87 0c 00 00       	call   80101ed6 <readi>
8010124f:	83 c4 10             	add    $0x10,%esp
80101252:	89 45 f4             	mov    %eax,-0xc(%ebp)
80101255:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80101259:	7e 11                	jle    8010126c <fileread+0x92>
      f->off += r;
8010125b:	8b 45 08             	mov    0x8(%ebp),%eax
8010125e:	8b 50 14             	mov    0x14(%eax),%edx
80101261:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101264:	01 c2                	add    %eax,%edx
80101266:	8b 45 08             	mov    0x8(%ebp),%eax
80101269:	89 50 14             	mov    %edx,0x14(%eax)
    iunlock(f->ip);
8010126c:	8b 45 08             	mov    0x8(%ebp),%eax
8010126f:	8b 40 10             	mov    0x10(%eax),%eax
80101272:	83 ec 0c             	sub    $0xc,%esp
80101275:	50                   	push   %eax
80101276:	e8 82 08 00 00       	call   80101afd <iunlock>
8010127b:	83 c4 10             	add    $0x10,%esp
    return r;
8010127e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101281:	eb 0d                	jmp    80101290 <fileread+0xb6>
  }
  panic("fileread");
80101283:	83 ec 0c             	sub    $0xc,%esp
80101286:	68 1a a3 10 80       	push   $0x8010a31a
8010128b:	e8 19 f3 ff ff       	call   801005a9 <panic>
}
80101290:	c9                   	leave  
80101291:	c3                   	ret    

80101292 <filewrite>:

//PAGEBREAK!
// Write to file f.
int
filewrite(struct file *f, char *addr, int n)
{
80101292:	55                   	push   %ebp
80101293:	89 e5                	mov    %esp,%ebp
80101295:	53                   	push   %ebx
80101296:	83 ec 14             	sub    $0x14,%esp
  int r;

  if(f->writable == 0)
80101299:	8b 45 08             	mov    0x8(%ebp),%eax
8010129c:	0f b6 40 09          	movzbl 0x9(%eax),%eax
801012a0:	84 c0                	test   %al,%al
801012a2:	75 0a                	jne    801012ae <filewrite+0x1c>
    return -1;
801012a4:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801012a9:	e9 1b 01 00 00       	jmp    801013c9 <filewrite+0x137>
  if(f->type == FD_PIPE)
801012ae:	8b 45 08             	mov    0x8(%ebp),%eax
801012b1:	8b 00                	mov    (%eax),%eax
801012b3:	83 f8 01             	cmp    $0x1,%eax
801012b6:	75 1d                	jne    801012d5 <filewrite+0x43>
    return pipewrite(f->pipe, addr, n);
801012b8:	8b 45 08             	mov    0x8(%ebp),%eax
801012bb:	8b 40 0c             	mov    0xc(%eax),%eax
801012be:	83 ec 04             	sub    $0x4,%esp
801012c1:	ff 75 10             	push   0x10(%ebp)
801012c4:	ff 75 0c             	push   0xc(%ebp)
801012c7:	50                   	push   %eax
801012c8:	e8 9d 24 00 00       	call   8010376a <pipewrite>
801012cd:	83 c4 10             	add    $0x10,%esp
801012d0:	e9 f4 00 00 00       	jmp    801013c9 <filewrite+0x137>
  if(f->type == FD_INODE){
801012d5:	8b 45 08             	mov    0x8(%ebp),%eax
801012d8:	8b 00                	mov    (%eax),%eax
801012da:	83 f8 02             	cmp    $0x2,%eax
801012dd:	0f 85 d9 00 00 00    	jne    801013bc <filewrite+0x12a>
    // the maximum log transaction size, including
    // i-node, indirect block, allocation blocks,
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((MAXOPBLOCKS-1-1-2) / 2) * 512;
801012e3:	c7 45 ec 00 06 00 00 	movl   $0x600,-0x14(%ebp)
    int i = 0;
801012ea:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    while(i < n){
801012f1:	e9 a3 00 00 00       	jmp    80101399 <filewrite+0x107>
      int n1 = n - i;
801012f6:	8b 45 10             	mov    0x10(%ebp),%eax
801012f9:	2b 45 f4             	sub    -0xc(%ebp),%eax
801012fc:	89 45 f0             	mov    %eax,-0x10(%ebp)
      if(n1 > max)
801012ff:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101302:	3b 45 ec             	cmp    -0x14(%ebp),%eax
80101305:	7e 06                	jle    8010130d <filewrite+0x7b>
        n1 = max;
80101307:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010130a:	89 45 f0             	mov    %eax,-0x10(%ebp)

      begin_op();
8010130d:	e8 2a 1d 00 00       	call   8010303c <begin_op>
      ilock(f->ip);
80101312:	8b 45 08             	mov    0x8(%ebp),%eax
80101315:	8b 40 10             	mov    0x10(%eax),%eax
80101318:	83 ec 0c             	sub    $0xc,%esp
8010131b:	50                   	push   %eax
8010131c:	e8 c9 06 00 00       	call   801019ea <ilock>
80101321:	83 c4 10             	add    $0x10,%esp
      if ((r = writei(f->ip, addr + i, f->off, n1)) > 0)
80101324:	8b 4d f0             	mov    -0x10(%ebp),%ecx
80101327:	8b 45 08             	mov    0x8(%ebp),%eax
8010132a:	8b 50 14             	mov    0x14(%eax),%edx
8010132d:	8b 5d f4             	mov    -0xc(%ebp),%ebx
80101330:	8b 45 0c             	mov    0xc(%ebp),%eax
80101333:	01 c3                	add    %eax,%ebx
80101335:	8b 45 08             	mov    0x8(%ebp),%eax
80101338:	8b 40 10             	mov    0x10(%eax),%eax
8010133b:	51                   	push   %ecx
8010133c:	52                   	push   %edx
8010133d:	53                   	push   %ebx
8010133e:	50                   	push   %eax
8010133f:	e8 e7 0c 00 00       	call   8010202b <writei>
80101344:	83 c4 10             	add    $0x10,%esp
80101347:	89 45 e8             	mov    %eax,-0x18(%ebp)
8010134a:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
8010134e:	7e 11                	jle    80101361 <filewrite+0xcf>
        f->off += r;
80101350:	8b 45 08             	mov    0x8(%ebp),%eax
80101353:	8b 50 14             	mov    0x14(%eax),%edx
80101356:	8b 45 e8             	mov    -0x18(%ebp),%eax
80101359:	01 c2                	add    %eax,%edx
8010135b:	8b 45 08             	mov    0x8(%ebp),%eax
8010135e:	89 50 14             	mov    %edx,0x14(%eax)
      iunlock(f->ip);
80101361:	8b 45 08             	mov    0x8(%ebp),%eax
80101364:	8b 40 10             	mov    0x10(%eax),%eax
80101367:	83 ec 0c             	sub    $0xc,%esp
8010136a:	50                   	push   %eax
8010136b:	e8 8d 07 00 00       	call   80101afd <iunlock>
80101370:	83 c4 10             	add    $0x10,%esp
      end_op();
80101373:	e8 50 1d 00 00       	call   801030c8 <end_op>

      if(r < 0)
80101378:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
8010137c:	78 29                	js     801013a7 <filewrite+0x115>
        break;
      if(r != n1)
8010137e:	8b 45 e8             	mov    -0x18(%ebp),%eax
80101381:	3b 45 f0             	cmp    -0x10(%ebp),%eax
80101384:	74 0d                	je     80101393 <filewrite+0x101>
        panic("short filewrite");
80101386:	83 ec 0c             	sub    $0xc,%esp
80101389:	68 23 a3 10 80       	push   $0x8010a323
8010138e:	e8 16 f2 ff ff       	call   801005a9 <panic>
      i += r;
80101393:	8b 45 e8             	mov    -0x18(%ebp),%eax
80101396:	01 45 f4             	add    %eax,-0xc(%ebp)
    while(i < n){
80101399:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010139c:	3b 45 10             	cmp    0x10(%ebp),%eax
8010139f:	0f 8c 51 ff ff ff    	jl     801012f6 <filewrite+0x64>
801013a5:	eb 01                	jmp    801013a8 <filewrite+0x116>
        break;
801013a7:	90                   	nop
    }
    return i == n ? n : -1;
801013a8:	8b 45 f4             	mov    -0xc(%ebp),%eax
801013ab:	3b 45 10             	cmp    0x10(%ebp),%eax
801013ae:	75 05                	jne    801013b5 <filewrite+0x123>
801013b0:	8b 45 10             	mov    0x10(%ebp),%eax
801013b3:	eb 14                	jmp    801013c9 <filewrite+0x137>
801013b5:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801013ba:	eb 0d                	jmp    801013c9 <filewrite+0x137>
  }
  panic("filewrite");
801013bc:	83 ec 0c             	sub    $0xc,%esp
801013bf:	68 33 a3 10 80       	push   $0x8010a333
801013c4:	e8 e0 f1 ff ff       	call   801005a9 <panic>
}
801013c9:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801013cc:	c9                   	leave  
801013cd:	c3                   	ret    

801013ce <readsb>:
struct superblock sb; 

// Read the super block.
void
readsb(int dev, struct superblock *sb)
{
801013ce:	55                   	push   %ebp
801013cf:	89 e5                	mov    %esp,%ebp
801013d1:	83 ec 18             	sub    $0x18,%esp
  struct buf *bp;

  bp = bread(dev, 1);
801013d4:	8b 45 08             	mov    0x8(%ebp),%eax
801013d7:	83 ec 08             	sub    $0x8,%esp
801013da:	6a 01                	push   $0x1
801013dc:	50                   	push   %eax
801013dd:	e8 1f ee ff ff       	call   80100201 <bread>
801013e2:	83 c4 10             	add    $0x10,%esp
801013e5:	89 45 f4             	mov    %eax,-0xc(%ebp)
  memmove(sb, bp->data, sizeof(*sb));
801013e8:	8b 45 f4             	mov    -0xc(%ebp),%eax
801013eb:	83 c0 5c             	add    $0x5c,%eax
801013ee:	83 ec 04             	sub    $0x4,%esp
801013f1:	6a 1c                	push   $0x1c
801013f3:	50                   	push   %eax
801013f4:	ff 75 0c             	push   0xc(%ebp)
801013f7:	e8 c6 38 00 00       	call   80104cc2 <memmove>
801013fc:	83 c4 10             	add    $0x10,%esp
  brelse(bp);
801013ff:	83 ec 0c             	sub    $0xc,%esp
80101402:	ff 75 f4             	push   -0xc(%ebp)
80101405:	e8 79 ee ff ff       	call   80100283 <brelse>
8010140a:	83 c4 10             	add    $0x10,%esp
}
8010140d:	90                   	nop
8010140e:	c9                   	leave  
8010140f:	c3                   	ret    

80101410 <bzero>:

// Zero a block.
static void
bzero(int dev, int bno)
{
80101410:	55                   	push   %ebp
80101411:	89 e5                	mov    %esp,%ebp
80101413:	83 ec 18             	sub    $0x18,%esp
  struct buf *bp;

  bp = bread(dev, bno);
80101416:	8b 55 0c             	mov    0xc(%ebp),%edx
80101419:	8b 45 08             	mov    0x8(%ebp),%eax
8010141c:	83 ec 08             	sub    $0x8,%esp
8010141f:	52                   	push   %edx
80101420:	50                   	push   %eax
80101421:	e8 db ed ff ff       	call   80100201 <bread>
80101426:	83 c4 10             	add    $0x10,%esp
80101429:	89 45 f4             	mov    %eax,-0xc(%ebp)
  memset(bp->data, 0, BSIZE);
8010142c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010142f:	83 c0 5c             	add    $0x5c,%eax
80101432:	83 ec 04             	sub    $0x4,%esp
80101435:	68 00 02 00 00       	push   $0x200
8010143a:	6a 00                	push   $0x0
8010143c:	50                   	push   %eax
8010143d:	e8 c1 37 00 00       	call   80104c03 <memset>
80101442:	83 c4 10             	add    $0x10,%esp
  log_write(bp);
80101445:	83 ec 0c             	sub    $0xc,%esp
80101448:	ff 75 f4             	push   -0xc(%ebp)
8010144b:	e8 25 1e 00 00       	call   80103275 <log_write>
80101450:	83 c4 10             	add    $0x10,%esp
  brelse(bp);
80101453:	83 ec 0c             	sub    $0xc,%esp
80101456:	ff 75 f4             	push   -0xc(%ebp)
80101459:	e8 25 ee ff ff       	call   80100283 <brelse>
8010145e:	83 c4 10             	add    $0x10,%esp
}
80101461:	90                   	nop
80101462:	c9                   	leave  
80101463:	c3                   	ret    

80101464 <balloc>:
// Blocks.

// Allocate a zeroed disk block.
static uint
balloc(uint dev)
{
80101464:	55                   	push   %ebp
80101465:	89 e5                	mov    %esp,%ebp
80101467:	83 ec 18             	sub    $0x18,%esp
  int b, bi, m;
  struct buf *bp;

  bp = 0;
8010146a:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  for(b = 0; b < sb.size; b += BPB){
80101471:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80101478:	e9 0b 01 00 00       	jmp    80101588 <balloc+0x124>
    bp = bread(dev, BBLOCK(b, sb));
8010147d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101480:	8d 90 ff 0f 00 00    	lea    0xfff(%eax),%edx
80101486:	85 c0                	test   %eax,%eax
80101488:	0f 48 c2             	cmovs  %edx,%eax
8010148b:	c1 f8 0c             	sar    $0xc,%eax
8010148e:	89 c2                	mov    %eax,%edx
80101490:	a1 58 24 19 80       	mov    0x80192458,%eax
80101495:	01 d0                	add    %edx,%eax
80101497:	83 ec 08             	sub    $0x8,%esp
8010149a:	50                   	push   %eax
8010149b:	ff 75 08             	push   0x8(%ebp)
8010149e:	e8 5e ed ff ff       	call   80100201 <bread>
801014a3:	83 c4 10             	add    $0x10,%esp
801014a6:	89 45 ec             	mov    %eax,-0x14(%ebp)
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
801014a9:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
801014b0:	e9 9e 00 00 00       	jmp    80101553 <balloc+0xef>
      m = 1 << (bi % 8);
801014b5:	8b 45 f0             	mov    -0x10(%ebp),%eax
801014b8:	83 e0 07             	and    $0x7,%eax
801014bb:	ba 01 00 00 00       	mov    $0x1,%edx
801014c0:	89 c1                	mov    %eax,%ecx
801014c2:	d3 e2                	shl    %cl,%edx
801014c4:	89 d0                	mov    %edx,%eax
801014c6:	89 45 e8             	mov    %eax,-0x18(%ebp)
      if((bp->data[bi/8] & m) == 0){  // Is block free?
801014c9:	8b 45 f0             	mov    -0x10(%ebp),%eax
801014cc:	8d 50 07             	lea    0x7(%eax),%edx
801014cf:	85 c0                	test   %eax,%eax
801014d1:	0f 48 c2             	cmovs  %edx,%eax
801014d4:	c1 f8 03             	sar    $0x3,%eax
801014d7:	89 c2                	mov    %eax,%edx
801014d9:	8b 45 ec             	mov    -0x14(%ebp),%eax
801014dc:	0f b6 44 10 5c       	movzbl 0x5c(%eax,%edx,1),%eax
801014e1:	0f b6 c0             	movzbl %al,%eax
801014e4:	23 45 e8             	and    -0x18(%ebp),%eax
801014e7:	85 c0                	test   %eax,%eax
801014e9:	75 64                	jne    8010154f <balloc+0xeb>
        bp->data[bi/8] |= m;  // Mark block in use.
801014eb:	8b 45 f0             	mov    -0x10(%ebp),%eax
801014ee:	8d 50 07             	lea    0x7(%eax),%edx
801014f1:	85 c0                	test   %eax,%eax
801014f3:	0f 48 c2             	cmovs  %edx,%eax
801014f6:	c1 f8 03             	sar    $0x3,%eax
801014f9:	8b 55 ec             	mov    -0x14(%ebp),%edx
801014fc:	0f b6 54 02 5c       	movzbl 0x5c(%edx,%eax,1),%edx
80101501:	89 d1                	mov    %edx,%ecx
80101503:	8b 55 e8             	mov    -0x18(%ebp),%edx
80101506:	09 ca                	or     %ecx,%edx
80101508:	89 d1                	mov    %edx,%ecx
8010150a:	8b 55 ec             	mov    -0x14(%ebp),%edx
8010150d:	88 4c 02 5c          	mov    %cl,0x5c(%edx,%eax,1)
        log_write(bp);
80101511:	83 ec 0c             	sub    $0xc,%esp
80101514:	ff 75 ec             	push   -0x14(%ebp)
80101517:	e8 59 1d 00 00       	call   80103275 <log_write>
8010151c:	83 c4 10             	add    $0x10,%esp
        brelse(bp);
8010151f:	83 ec 0c             	sub    $0xc,%esp
80101522:	ff 75 ec             	push   -0x14(%ebp)
80101525:	e8 59 ed ff ff       	call   80100283 <brelse>
8010152a:	83 c4 10             	add    $0x10,%esp
        bzero(dev, b + bi);
8010152d:	8b 55 f4             	mov    -0xc(%ebp),%edx
80101530:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101533:	01 c2                	add    %eax,%edx
80101535:	8b 45 08             	mov    0x8(%ebp),%eax
80101538:	83 ec 08             	sub    $0x8,%esp
8010153b:	52                   	push   %edx
8010153c:	50                   	push   %eax
8010153d:	e8 ce fe ff ff       	call   80101410 <bzero>
80101542:	83 c4 10             	add    $0x10,%esp
        return b + bi;
80101545:	8b 55 f4             	mov    -0xc(%ebp),%edx
80101548:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010154b:	01 d0                	add    %edx,%eax
8010154d:	eb 57                	jmp    801015a6 <balloc+0x142>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
8010154f:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
80101553:	81 7d f0 ff 0f 00 00 	cmpl   $0xfff,-0x10(%ebp)
8010155a:	7f 17                	jg     80101573 <balloc+0x10f>
8010155c:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010155f:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101562:	01 d0                	add    %edx,%eax
80101564:	89 c2                	mov    %eax,%edx
80101566:	a1 40 24 19 80       	mov    0x80192440,%eax
8010156b:	39 c2                	cmp    %eax,%edx
8010156d:	0f 82 42 ff ff ff    	jb     801014b5 <balloc+0x51>
      }
    }
    brelse(bp);
80101573:	83 ec 0c             	sub    $0xc,%esp
80101576:	ff 75 ec             	push   -0x14(%ebp)
80101579:	e8 05 ed ff ff       	call   80100283 <brelse>
8010157e:	83 c4 10             	add    $0x10,%esp
  for(b = 0; b < sb.size; b += BPB){
80101581:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
80101588:	8b 15 40 24 19 80    	mov    0x80192440,%edx
8010158e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101591:	39 c2                	cmp    %eax,%edx
80101593:	0f 87 e4 fe ff ff    	ja     8010147d <balloc+0x19>
  }
  panic("balloc: out of blocks");
80101599:	83 ec 0c             	sub    $0xc,%esp
8010159c:	68 40 a3 10 80       	push   $0x8010a340
801015a1:	e8 03 f0 ff ff       	call   801005a9 <panic>
}
801015a6:	c9                   	leave  
801015a7:	c3                   	ret    

801015a8 <bfree>:

// Free a disk block.
static void
bfree(int dev, uint b)
{
801015a8:	55                   	push   %ebp
801015a9:	89 e5                	mov    %esp,%ebp
801015ab:	83 ec 18             	sub    $0x18,%esp
  struct buf *bp;
  int bi, m;

  readsb(dev, &sb);
801015ae:	83 ec 08             	sub    $0x8,%esp
801015b1:	68 40 24 19 80       	push   $0x80192440
801015b6:	ff 75 08             	push   0x8(%ebp)
801015b9:	e8 10 fe ff ff       	call   801013ce <readsb>
801015be:	83 c4 10             	add    $0x10,%esp
  bp = bread(dev, BBLOCK(b, sb));
801015c1:	8b 45 0c             	mov    0xc(%ebp),%eax
801015c4:	c1 e8 0c             	shr    $0xc,%eax
801015c7:	89 c2                	mov    %eax,%edx
801015c9:	a1 58 24 19 80       	mov    0x80192458,%eax
801015ce:	01 c2                	add    %eax,%edx
801015d0:	8b 45 08             	mov    0x8(%ebp),%eax
801015d3:	83 ec 08             	sub    $0x8,%esp
801015d6:	52                   	push   %edx
801015d7:	50                   	push   %eax
801015d8:	e8 24 ec ff ff       	call   80100201 <bread>
801015dd:	83 c4 10             	add    $0x10,%esp
801015e0:	89 45 f4             	mov    %eax,-0xc(%ebp)
  bi = b % BPB;
801015e3:	8b 45 0c             	mov    0xc(%ebp),%eax
801015e6:	25 ff 0f 00 00       	and    $0xfff,%eax
801015eb:	89 45 f0             	mov    %eax,-0x10(%ebp)
  m = 1 << (bi % 8);
801015ee:	8b 45 f0             	mov    -0x10(%ebp),%eax
801015f1:	83 e0 07             	and    $0x7,%eax
801015f4:	ba 01 00 00 00       	mov    $0x1,%edx
801015f9:	89 c1                	mov    %eax,%ecx
801015fb:	d3 e2                	shl    %cl,%edx
801015fd:	89 d0                	mov    %edx,%eax
801015ff:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((bp->data[bi/8] & m) == 0)
80101602:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101605:	8d 50 07             	lea    0x7(%eax),%edx
80101608:	85 c0                	test   %eax,%eax
8010160a:	0f 48 c2             	cmovs  %edx,%eax
8010160d:	c1 f8 03             	sar    $0x3,%eax
80101610:	89 c2                	mov    %eax,%edx
80101612:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101615:	0f b6 44 10 5c       	movzbl 0x5c(%eax,%edx,1),%eax
8010161a:	0f b6 c0             	movzbl %al,%eax
8010161d:	23 45 ec             	and    -0x14(%ebp),%eax
80101620:	85 c0                	test   %eax,%eax
80101622:	75 0d                	jne    80101631 <bfree+0x89>
    panic("freeing free block");
80101624:	83 ec 0c             	sub    $0xc,%esp
80101627:	68 56 a3 10 80       	push   $0x8010a356
8010162c:	e8 78 ef ff ff       	call   801005a9 <panic>
  bp->data[bi/8] &= ~m;
80101631:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101634:	8d 50 07             	lea    0x7(%eax),%edx
80101637:	85 c0                	test   %eax,%eax
80101639:	0f 48 c2             	cmovs  %edx,%eax
8010163c:	c1 f8 03             	sar    $0x3,%eax
8010163f:	8b 55 f4             	mov    -0xc(%ebp),%edx
80101642:	0f b6 54 02 5c       	movzbl 0x5c(%edx,%eax,1),%edx
80101647:	89 d1                	mov    %edx,%ecx
80101649:	8b 55 ec             	mov    -0x14(%ebp),%edx
8010164c:	f7 d2                	not    %edx
8010164e:	21 ca                	and    %ecx,%edx
80101650:	89 d1                	mov    %edx,%ecx
80101652:	8b 55 f4             	mov    -0xc(%ebp),%edx
80101655:	88 4c 02 5c          	mov    %cl,0x5c(%edx,%eax,1)
  log_write(bp);
80101659:	83 ec 0c             	sub    $0xc,%esp
8010165c:	ff 75 f4             	push   -0xc(%ebp)
8010165f:	e8 11 1c 00 00       	call   80103275 <log_write>
80101664:	83 c4 10             	add    $0x10,%esp
  brelse(bp);
80101667:	83 ec 0c             	sub    $0xc,%esp
8010166a:	ff 75 f4             	push   -0xc(%ebp)
8010166d:	e8 11 ec ff ff       	call   80100283 <brelse>
80101672:	83 c4 10             	add    $0x10,%esp
}
80101675:	90                   	nop
80101676:	c9                   	leave  
80101677:	c3                   	ret    

80101678 <iinit>:
  struct inode inode[NINODE];
} icache;

void
iinit(int dev)
{
80101678:	55                   	push   %ebp
80101679:	89 e5                	mov    %esp,%ebp
8010167b:	57                   	push   %edi
8010167c:	56                   	push   %esi
8010167d:	53                   	push   %ebx
8010167e:	83 ec 2c             	sub    $0x2c,%esp
  int i = 0;
80101681:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  
  initlock(&icache.lock, "icache");
80101688:	83 ec 08             	sub    $0x8,%esp
8010168b:	68 69 a3 10 80       	push   $0x8010a369
80101690:	68 60 24 19 80       	push   $0x80192460
80101695:	e8 d1 32 00 00       	call   8010496b <initlock>
8010169a:	83 c4 10             	add    $0x10,%esp
  for(i = 0; i < NINODE; i++) {
8010169d:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
801016a4:	eb 2d                	jmp    801016d3 <iinit+0x5b>
    initsleeplock(&icache.inode[i].lock, "inode");
801016a6:	8b 55 e4             	mov    -0x1c(%ebp),%edx
801016a9:	89 d0                	mov    %edx,%eax
801016ab:	c1 e0 03             	shl    $0x3,%eax
801016ae:	01 d0                	add    %edx,%eax
801016b0:	c1 e0 04             	shl    $0x4,%eax
801016b3:	83 c0 30             	add    $0x30,%eax
801016b6:	05 60 24 19 80       	add    $0x80192460,%eax
801016bb:	83 c0 10             	add    $0x10,%eax
801016be:	83 ec 08             	sub    $0x8,%esp
801016c1:	68 70 a3 10 80       	push   $0x8010a370
801016c6:	50                   	push   %eax
801016c7:	e8 42 31 00 00       	call   8010480e <initsleeplock>
801016cc:	83 c4 10             	add    $0x10,%esp
  for(i = 0; i < NINODE; i++) {
801016cf:	83 45 e4 01          	addl   $0x1,-0x1c(%ebp)
801016d3:	83 7d e4 31          	cmpl   $0x31,-0x1c(%ebp)
801016d7:	7e cd                	jle    801016a6 <iinit+0x2e>
  }

  readsb(dev, &sb);
801016d9:	83 ec 08             	sub    $0x8,%esp
801016dc:	68 40 24 19 80       	push   $0x80192440
801016e1:	ff 75 08             	push   0x8(%ebp)
801016e4:	e8 e5 fc ff ff       	call   801013ce <readsb>
801016e9:	83 c4 10             	add    $0x10,%esp
  cprintf("sb: size %d nblocks %d ninodes %d nlog %d logstart %d\
801016ec:	a1 58 24 19 80       	mov    0x80192458,%eax
801016f1:	89 45 d4             	mov    %eax,-0x2c(%ebp)
801016f4:	8b 3d 54 24 19 80    	mov    0x80192454,%edi
801016fa:	8b 35 50 24 19 80    	mov    0x80192450,%esi
80101700:	8b 1d 4c 24 19 80    	mov    0x8019244c,%ebx
80101706:	8b 0d 48 24 19 80    	mov    0x80192448,%ecx
8010170c:	8b 15 44 24 19 80    	mov    0x80192444,%edx
80101712:	a1 40 24 19 80       	mov    0x80192440,%eax
80101717:	ff 75 d4             	push   -0x2c(%ebp)
8010171a:	57                   	push   %edi
8010171b:	56                   	push   %esi
8010171c:	53                   	push   %ebx
8010171d:	51                   	push   %ecx
8010171e:	52                   	push   %edx
8010171f:	50                   	push   %eax
80101720:	68 78 a3 10 80       	push   $0x8010a378
80101725:	e8 ca ec ff ff       	call   801003f4 <cprintf>
8010172a:	83 c4 20             	add    $0x20,%esp
 inodestart %d bmap start %d\n", sb.size, sb.nblocks,
          sb.ninodes, sb.nlog, sb.logstart, sb.inodestart,
          sb.bmapstart);
}
8010172d:	90                   	nop
8010172e:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101731:	5b                   	pop    %ebx
80101732:	5e                   	pop    %esi
80101733:	5f                   	pop    %edi
80101734:	5d                   	pop    %ebp
80101735:	c3                   	ret    

80101736 <ialloc>:
// Allocate an inode on device dev.
// Mark it as allocated by  giving it type type.
// Returns an unlocked but allocated and referenced inode.
struct inode*
ialloc(uint dev, short type)
{
80101736:	55                   	push   %ebp
80101737:	89 e5                	mov    %esp,%ebp
80101739:	83 ec 28             	sub    $0x28,%esp
8010173c:	8b 45 0c             	mov    0xc(%ebp),%eax
8010173f:	66 89 45 e4          	mov    %ax,-0x1c(%ebp)
  int inum;
  struct buf *bp;
  struct dinode *dip;

  for(inum = 1; inum < sb.ninodes; inum++){
80101743:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
8010174a:	e9 9e 00 00 00       	jmp    801017ed <ialloc+0xb7>
    bp = bread(dev, IBLOCK(inum, sb));
8010174f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101752:	c1 e8 03             	shr    $0x3,%eax
80101755:	89 c2                	mov    %eax,%edx
80101757:	a1 54 24 19 80       	mov    0x80192454,%eax
8010175c:	01 d0                	add    %edx,%eax
8010175e:	83 ec 08             	sub    $0x8,%esp
80101761:	50                   	push   %eax
80101762:	ff 75 08             	push   0x8(%ebp)
80101765:	e8 97 ea ff ff       	call   80100201 <bread>
8010176a:	83 c4 10             	add    $0x10,%esp
8010176d:	89 45 f0             	mov    %eax,-0x10(%ebp)
    dip = (struct dinode*)bp->data + inum%IPB;
80101770:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101773:	8d 50 5c             	lea    0x5c(%eax),%edx
80101776:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101779:	83 e0 07             	and    $0x7,%eax
8010177c:	c1 e0 06             	shl    $0x6,%eax
8010177f:	01 d0                	add    %edx,%eax
80101781:	89 45 ec             	mov    %eax,-0x14(%ebp)
    if(dip->type == 0){  // a free inode
80101784:	8b 45 ec             	mov    -0x14(%ebp),%eax
80101787:	0f b7 00             	movzwl (%eax),%eax
8010178a:	66 85 c0             	test   %ax,%ax
8010178d:	75 4c                	jne    801017db <ialloc+0xa5>
      memset(dip, 0, sizeof(*dip));
8010178f:	83 ec 04             	sub    $0x4,%esp
80101792:	6a 40                	push   $0x40
80101794:	6a 00                	push   $0x0
80101796:	ff 75 ec             	push   -0x14(%ebp)
80101799:	e8 65 34 00 00       	call   80104c03 <memset>
8010179e:	83 c4 10             	add    $0x10,%esp
      dip->type = type;
801017a1:	8b 45 ec             	mov    -0x14(%ebp),%eax
801017a4:	0f b7 55 e4          	movzwl -0x1c(%ebp),%edx
801017a8:	66 89 10             	mov    %dx,(%eax)
      log_write(bp);   // mark it allocated on the disk
801017ab:	83 ec 0c             	sub    $0xc,%esp
801017ae:	ff 75 f0             	push   -0x10(%ebp)
801017b1:	e8 bf 1a 00 00       	call   80103275 <log_write>
801017b6:	83 c4 10             	add    $0x10,%esp
      brelse(bp);
801017b9:	83 ec 0c             	sub    $0xc,%esp
801017bc:	ff 75 f0             	push   -0x10(%ebp)
801017bf:	e8 bf ea ff ff       	call   80100283 <brelse>
801017c4:	83 c4 10             	add    $0x10,%esp
      return iget(dev, inum);
801017c7:	8b 45 f4             	mov    -0xc(%ebp),%eax
801017ca:	83 ec 08             	sub    $0x8,%esp
801017cd:	50                   	push   %eax
801017ce:	ff 75 08             	push   0x8(%ebp)
801017d1:	e8 f8 00 00 00       	call   801018ce <iget>
801017d6:	83 c4 10             	add    $0x10,%esp
801017d9:	eb 30                	jmp    8010180b <ialloc+0xd5>
    }
    brelse(bp);
801017db:	83 ec 0c             	sub    $0xc,%esp
801017de:	ff 75 f0             	push   -0x10(%ebp)
801017e1:	e8 9d ea ff ff       	call   80100283 <brelse>
801017e6:	83 c4 10             	add    $0x10,%esp
  for(inum = 1; inum < sb.ninodes; inum++){
801017e9:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
801017ed:	8b 15 48 24 19 80    	mov    0x80192448,%edx
801017f3:	8b 45 f4             	mov    -0xc(%ebp),%eax
801017f6:	39 c2                	cmp    %eax,%edx
801017f8:	0f 87 51 ff ff ff    	ja     8010174f <ialloc+0x19>
  }
  panic("ialloc: no inodes");
801017fe:	83 ec 0c             	sub    $0xc,%esp
80101801:	68 cb a3 10 80       	push   $0x8010a3cb
80101806:	e8 9e ed ff ff       	call   801005a9 <panic>
}
8010180b:	c9                   	leave  
8010180c:	c3                   	ret    

8010180d <iupdate>:
// Must be called after every change to an ip->xxx field
// that lives on disk, since i-node cache is write-through.
// Caller must hold ip->lock.
void
iupdate(struct inode *ip)
{
8010180d:	55                   	push   %ebp
8010180e:	89 e5                	mov    %esp,%ebp
80101810:	83 ec 18             	sub    $0x18,%esp
  struct buf *bp;
  struct dinode *dip;

  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
80101813:	8b 45 08             	mov    0x8(%ebp),%eax
80101816:	8b 40 04             	mov    0x4(%eax),%eax
80101819:	c1 e8 03             	shr    $0x3,%eax
8010181c:	89 c2                	mov    %eax,%edx
8010181e:	a1 54 24 19 80       	mov    0x80192454,%eax
80101823:	01 c2                	add    %eax,%edx
80101825:	8b 45 08             	mov    0x8(%ebp),%eax
80101828:	8b 00                	mov    (%eax),%eax
8010182a:	83 ec 08             	sub    $0x8,%esp
8010182d:	52                   	push   %edx
8010182e:	50                   	push   %eax
8010182f:	e8 cd e9 ff ff       	call   80100201 <bread>
80101834:	83 c4 10             	add    $0x10,%esp
80101837:	89 45 f4             	mov    %eax,-0xc(%ebp)
  dip = (struct dinode*)bp->data + ip->inum%IPB;
8010183a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010183d:	8d 50 5c             	lea    0x5c(%eax),%edx
80101840:	8b 45 08             	mov    0x8(%ebp),%eax
80101843:	8b 40 04             	mov    0x4(%eax),%eax
80101846:	83 e0 07             	and    $0x7,%eax
80101849:	c1 e0 06             	shl    $0x6,%eax
8010184c:	01 d0                	add    %edx,%eax
8010184e:	89 45 f0             	mov    %eax,-0x10(%ebp)
  dip->type = ip->type;
80101851:	8b 45 08             	mov    0x8(%ebp),%eax
80101854:	0f b7 50 50          	movzwl 0x50(%eax),%edx
80101858:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010185b:	66 89 10             	mov    %dx,(%eax)
  dip->major = ip->major;
8010185e:	8b 45 08             	mov    0x8(%ebp),%eax
80101861:	0f b7 50 52          	movzwl 0x52(%eax),%edx
80101865:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101868:	66 89 50 02          	mov    %dx,0x2(%eax)
  dip->minor = ip->minor;
8010186c:	8b 45 08             	mov    0x8(%ebp),%eax
8010186f:	0f b7 50 54          	movzwl 0x54(%eax),%edx
80101873:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101876:	66 89 50 04          	mov    %dx,0x4(%eax)
  dip->nlink = ip->nlink;
8010187a:	8b 45 08             	mov    0x8(%ebp),%eax
8010187d:	0f b7 50 56          	movzwl 0x56(%eax),%edx
80101881:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101884:	66 89 50 06          	mov    %dx,0x6(%eax)
  dip->size = ip->size;
80101888:	8b 45 08             	mov    0x8(%ebp),%eax
8010188b:	8b 50 58             	mov    0x58(%eax),%edx
8010188e:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101891:	89 50 08             	mov    %edx,0x8(%eax)
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
80101894:	8b 45 08             	mov    0x8(%ebp),%eax
80101897:	8d 50 5c             	lea    0x5c(%eax),%edx
8010189a:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010189d:	83 c0 0c             	add    $0xc,%eax
801018a0:	83 ec 04             	sub    $0x4,%esp
801018a3:	6a 34                	push   $0x34
801018a5:	52                   	push   %edx
801018a6:	50                   	push   %eax
801018a7:	e8 16 34 00 00       	call   80104cc2 <memmove>
801018ac:	83 c4 10             	add    $0x10,%esp
  log_write(bp);
801018af:	83 ec 0c             	sub    $0xc,%esp
801018b2:	ff 75 f4             	push   -0xc(%ebp)
801018b5:	e8 bb 19 00 00       	call   80103275 <log_write>
801018ba:	83 c4 10             	add    $0x10,%esp
  brelse(bp);
801018bd:	83 ec 0c             	sub    $0xc,%esp
801018c0:	ff 75 f4             	push   -0xc(%ebp)
801018c3:	e8 bb e9 ff ff       	call   80100283 <brelse>
801018c8:	83 c4 10             	add    $0x10,%esp
}
801018cb:	90                   	nop
801018cc:	c9                   	leave  
801018cd:	c3                   	ret    

801018ce <iget>:
// Find the inode with number inum on device dev
// and return the in-memory copy. Does not lock
// the inode and does not read it from disk.
static struct inode*
iget(uint dev, uint inum)
{
801018ce:	55                   	push   %ebp
801018cf:	89 e5                	mov    %esp,%ebp
801018d1:	83 ec 18             	sub    $0x18,%esp
  struct inode *ip, *empty;

  acquire(&icache.lock);
801018d4:	83 ec 0c             	sub    $0xc,%esp
801018d7:	68 60 24 19 80       	push   $0x80192460
801018dc:	e8 ac 30 00 00       	call   8010498d <acquire>
801018e1:	83 c4 10             	add    $0x10,%esp

  // Is the inode already cached?
  empty = 0;
801018e4:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
801018eb:	c7 45 f4 94 24 19 80 	movl   $0x80192494,-0xc(%ebp)
801018f2:	eb 60                	jmp    80101954 <iget+0x86>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
801018f4:	8b 45 f4             	mov    -0xc(%ebp),%eax
801018f7:	8b 40 08             	mov    0x8(%eax),%eax
801018fa:	85 c0                	test   %eax,%eax
801018fc:	7e 39                	jle    80101937 <iget+0x69>
801018fe:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101901:	8b 00                	mov    (%eax),%eax
80101903:	39 45 08             	cmp    %eax,0x8(%ebp)
80101906:	75 2f                	jne    80101937 <iget+0x69>
80101908:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010190b:	8b 40 04             	mov    0x4(%eax),%eax
8010190e:	39 45 0c             	cmp    %eax,0xc(%ebp)
80101911:	75 24                	jne    80101937 <iget+0x69>
      ip->ref++;
80101913:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101916:	8b 40 08             	mov    0x8(%eax),%eax
80101919:	8d 50 01             	lea    0x1(%eax),%edx
8010191c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010191f:	89 50 08             	mov    %edx,0x8(%eax)
      release(&icache.lock);
80101922:	83 ec 0c             	sub    $0xc,%esp
80101925:	68 60 24 19 80       	push   $0x80192460
8010192a:	e8 cc 30 00 00       	call   801049fb <release>
8010192f:	83 c4 10             	add    $0x10,%esp
      return ip;
80101932:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101935:	eb 77                	jmp    801019ae <iget+0xe0>
    }
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
80101937:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
8010193b:	75 10                	jne    8010194d <iget+0x7f>
8010193d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101940:	8b 40 08             	mov    0x8(%eax),%eax
80101943:	85 c0                	test   %eax,%eax
80101945:	75 06                	jne    8010194d <iget+0x7f>
      empty = ip;
80101947:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010194a:	89 45 f0             	mov    %eax,-0x10(%ebp)
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
8010194d:	81 45 f4 90 00 00 00 	addl   $0x90,-0xc(%ebp)
80101954:	81 7d f4 b4 40 19 80 	cmpl   $0x801940b4,-0xc(%ebp)
8010195b:	72 97                	jb     801018f4 <iget+0x26>
  }

  // Recycle an inode cache entry.
  if(empty == 0)
8010195d:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80101961:	75 0d                	jne    80101970 <iget+0xa2>
    panic("iget: no inodes");
80101963:	83 ec 0c             	sub    $0xc,%esp
80101966:	68 dd a3 10 80       	push   $0x8010a3dd
8010196b:	e8 39 ec ff ff       	call   801005a9 <panic>

  ip = empty;
80101970:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101973:	89 45 f4             	mov    %eax,-0xc(%ebp)
  ip->dev = dev;
80101976:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101979:	8b 55 08             	mov    0x8(%ebp),%edx
8010197c:	89 10                	mov    %edx,(%eax)
  ip->inum = inum;
8010197e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101981:	8b 55 0c             	mov    0xc(%ebp),%edx
80101984:	89 50 04             	mov    %edx,0x4(%eax)
  ip->ref = 1;
80101987:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010198a:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)
  ip->valid = 0;
80101991:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101994:	c7 40 4c 00 00 00 00 	movl   $0x0,0x4c(%eax)
  release(&icache.lock);
8010199b:	83 ec 0c             	sub    $0xc,%esp
8010199e:	68 60 24 19 80       	push   $0x80192460
801019a3:	e8 53 30 00 00       	call   801049fb <release>
801019a8:	83 c4 10             	add    $0x10,%esp

  return ip;
801019ab:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
801019ae:	c9                   	leave  
801019af:	c3                   	ret    

801019b0 <idup>:

// Increment reference count for ip.
// Returns ip to enable ip = idup(ip1) idiom.
struct inode*
idup(struct inode *ip)
{
801019b0:	55                   	push   %ebp
801019b1:	89 e5                	mov    %esp,%ebp
801019b3:	83 ec 08             	sub    $0x8,%esp
  acquire(&icache.lock);
801019b6:	83 ec 0c             	sub    $0xc,%esp
801019b9:	68 60 24 19 80       	push   $0x80192460
801019be:	e8 ca 2f 00 00       	call   8010498d <acquire>
801019c3:	83 c4 10             	add    $0x10,%esp
  ip->ref++;
801019c6:	8b 45 08             	mov    0x8(%ebp),%eax
801019c9:	8b 40 08             	mov    0x8(%eax),%eax
801019cc:	8d 50 01             	lea    0x1(%eax),%edx
801019cf:	8b 45 08             	mov    0x8(%ebp),%eax
801019d2:	89 50 08             	mov    %edx,0x8(%eax)
  release(&icache.lock);
801019d5:	83 ec 0c             	sub    $0xc,%esp
801019d8:	68 60 24 19 80       	push   $0x80192460
801019dd:	e8 19 30 00 00       	call   801049fb <release>
801019e2:	83 c4 10             	add    $0x10,%esp
  return ip;
801019e5:	8b 45 08             	mov    0x8(%ebp),%eax
}
801019e8:	c9                   	leave  
801019e9:	c3                   	ret    

801019ea <ilock>:

// Lock the given inode.
// Reads the inode from disk if necessary.
void
ilock(struct inode *ip)
{
801019ea:	55                   	push   %ebp
801019eb:	89 e5                	mov    %esp,%ebp
801019ed:	83 ec 18             	sub    $0x18,%esp
  struct buf *bp;
  struct dinode *dip;

  if(ip == 0 || ip->ref < 1)
801019f0:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
801019f4:	74 0a                	je     80101a00 <ilock+0x16>
801019f6:	8b 45 08             	mov    0x8(%ebp),%eax
801019f9:	8b 40 08             	mov    0x8(%eax),%eax
801019fc:	85 c0                	test   %eax,%eax
801019fe:	7f 0d                	jg     80101a0d <ilock+0x23>
    panic("ilock");
80101a00:	83 ec 0c             	sub    $0xc,%esp
80101a03:	68 ed a3 10 80       	push   $0x8010a3ed
80101a08:	e8 9c eb ff ff       	call   801005a9 <panic>

  acquiresleep(&ip->lock);
80101a0d:	8b 45 08             	mov    0x8(%ebp),%eax
80101a10:	83 c0 0c             	add    $0xc,%eax
80101a13:	83 ec 0c             	sub    $0xc,%esp
80101a16:	50                   	push   %eax
80101a17:	e8 2e 2e 00 00       	call   8010484a <acquiresleep>
80101a1c:	83 c4 10             	add    $0x10,%esp

  if(ip->valid == 0){
80101a1f:	8b 45 08             	mov    0x8(%ebp),%eax
80101a22:	8b 40 4c             	mov    0x4c(%eax),%eax
80101a25:	85 c0                	test   %eax,%eax
80101a27:	0f 85 cd 00 00 00    	jne    80101afa <ilock+0x110>
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
80101a2d:	8b 45 08             	mov    0x8(%ebp),%eax
80101a30:	8b 40 04             	mov    0x4(%eax),%eax
80101a33:	c1 e8 03             	shr    $0x3,%eax
80101a36:	89 c2                	mov    %eax,%edx
80101a38:	a1 54 24 19 80       	mov    0x80192454,%eax
80101a3d:	01 c2                	add    %eax,%edx
80101a3f:	8b 45 08             	mov    0x8(%ebp),%eax
80101a42:	8b 00                	mov    (%eax),%eax
80101a44:	83 ec 08             	sub    $0x8,%esp
80101a47:	52                   	push   %edx
80101a48:	50                   	push   %eax
80101a49:	e8 b3 e7 ff ff       	call   80100201 <bread>
80101a4e:	83 c4 10             	add    $0x10,%esp
80101a51:	89 45 f4             	mov    %eax,-0xc(%ebp)
    dip = (struct dinode*)bp->data + ip->inum%IPB;
80101a54:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101a57:	8d 50 5c             	lea    0x5c(%eax),%edx
80101a5a:	8b 45 08             	mov    0x8(%ebp),%eax
80101a5d:	8b 40 04             	mov    0x4(%eax),%eax
80101a60:	83 e0 07             	and    $0x7,%eax
80101a63:	c1 e0 06             	shl    $0x6,%eax
80101a66:	01 d0                	add    %edx,%eax
80101a68:	89 45 f0             	mov    %eax,-0x10(%ebp)
    ip->type = dip->type;
80101a6b:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101a6e:	0f b7 10             	movzwl (%eax),%edx
80101a71:	8b 45 08             	mov    0x8(%ebp),%eax
80101a74:	66 89 50 50          	mov    %dx,0x50(%eax)
    ip->major = dip->major;
80101a78:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101a7b:	0f b7 50 02          	movzwl 0x2(%eax),%edx
80101a7f:	8b 45 08             	mov    0x8(%ebp),%eax
80101a82:	66 89 50 52          	mov    %dx,0x52(%eax)
    ip->minor = dip->minor;
80101a86:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101a89:	0f b7 50 04          	movzwl 0x4(%eax),%edx
80101a8d:	8b 45 08             	mov    0x8(%ebp),%eax
80101a90:	66 89 50 54          	mov    %dx,0x54(%eax)
    ip->nlink = dip->nlink;
80101a94:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101a97:	0f b7 50 06          	movzwl 0x6(%eax),%edx
80101a9b:	8b 45 08             	mov    0x8(%ebp),%eax
80101a9e:	66 89 50 56          	mov    %dx,0x56(%eax)
    ip->size = dip->size;
80101aa2:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101aa5:	8b 50 08             	mov    0x8(%eax),%edx
80101aa8:	8b 45 08             	mov    0x8(%ebp),%eax
80101aab:	89 50 58             	mov    %edx,0x58(%eax)
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
80101aae:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101ab1:	8d 50 0c             	lea    0xc(%eax),%edx
80101ab4:	8b 45 08             	mov    0x8(%ebp),%eax
80101ab7:	83 c0 5c             	add    $0x5c,%eax
80101aba:	83 ec 04             	sub    $0x4,%esp
80101abd:	6a 34                	push   $0x34
80101abf:	52                   	push   %edx
80101ac0:	50                   	push   %eax
80101ac1:	e8 fc 31 00 00       	call   80104cc2 <memmove>
80101ac6:	83 c4 10             	add    $0x10,%esp
    brelse(bp);
80101ac9:	83 ec 0c             	sub    $0xc,%esp
80101acc:	ff 75 f4             	push   -0xc(%ebp)
80101acf:	e8 af e7 ff ff       	call   80100283 <brelse>
80101ad4:	83 c4 10             	add    $0x10,%esp
    ip->valid = 1;
80101ad7:	8b 45 08             	mov    0x8(%ebp),%eax
80101ada:	c7 40 4c 01 00 00 00 	movl   $0x1,0x4c(%eax)
    if(ip->type == 0)
80101ae1:	8b 45 08             	mov    0x8(%ebp),%eax
80101ae4:	0f b7 40 50          	movzwl 0x50(%eax),%eax
80101ae8:	66 85 c0             	test   %ax,%ax
80101aeb:	75 0d                	jne    80101afa <ilock+0x110>
      panic("ilock: no type");
80101aed:	83 ec 0c             	sub    $0xc,%esp
80101af0:	68 f3 a3 10 80       	push   $0x8010a3f3
80101af5:	e8 af ea ff ff       	call   801005a9 <panic>
  }
}
80101afa:	90                   	nop
80101afb:	c9                   	leave  
80101afc:	c3                   	ret    

80101afd <iunlock>:

// Unlock the given inode.
void
iunlock(struct inode *ip)
{
80101afd:	55                   	push   %ebp
80101afe:	89 e5                	mov    %esp,%ebp
80101b00:	83 ec 08             	sub    $0x8,%esp
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
80101b03:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
80101b07:	74 20                	je     80101b29 <iunlock+0x2c>
80101b09:	8b 45 08             	mov    0x8(%ebp),%eax
80101b0c:	83 c0 0c             	add    $0xc,%eax
80101b0f:	83 ec 0c             	sub    $0xc,%esp
80101b12:	50                   	push   %eax
80101b13:	e8 e4 2d 00 00       	call   801048fc <holdingsleep>
80101b18:	83 c4 10             	add    $0x10,%esp
80101b1b:	85 c0                	test   %eax,%eax
80101b1d:	74 0a                	je     80101b29 <iunlock+0x2c>
80101b1f:	8b 45 08             	mov    0x8(%ebp),%eax
80101b22:	8b 40 08             	mov    0x8(%eax),%eax
80101b25:	85 c0                	test   %eax,%eax
80101b27:	7f 0d                	jg     80101b36 <iunlock+0x39>
    panic("iunlock");
80101b29:	83 ec 0c             	sub    $0xc,%esp
80101b2c:	68 02 a4 10 80       	push   $0x8010a402
80101b31:	e8 73 ea ff ff       	call   801005a9 <panic>

  releasesleep(&ip->lock);
80101b36:	8b 45 08             	mov    0x8(%ebp),%eax
80101b39:	83 c0 0c             	add    $0xc,%eax
80101b3c:	83 ec 0c             	sub    $0xc,%esp
80101b3f:	50                   	push   %eax
80101b40:	e8 69 2d 00 00       	call   801048ae <releasesleep>
80101b45:	83 c4 10             	add    $0x10,%esp
}
80101b48:	90                   	nop
80101b49:	c9                   	leave  
80101b4a:	c3                   	ret    

80101b4b <iput>:
// to it, free the inode (and its content) on disk.
// All calls to iput() must be inside a transaction in
// case it has to free the inode.
void
iput(struct inode *ip)
{
80101b4b:	55                   	push   %ebp
80101b4c:	89 e5                	mov    %esp,%ebp
80101b4e:	83 ec 18             	sub    $0x18,%esp
  acquiresleep(&ip->lock);
80101b51:	8b 45 08             	mov    0x8(%ebp),%eax
80101b54:	83 c0 0c             	add    $0xc,%eax
80101b57:	83 ec 0c             	sub    $0xc,%esp
80101b5a:	50                   	push   %eax
80101b5b:	e8 ea 2c 00 00       	call   8010484a <acquiresleep>
80101b60:	83 c4 10             	add    $0x10,%esp
  if(ip->valid && ip->nlink == 0){
80101b63:	8b 45 08             	mov    0x8(%ebp),%eax
80101b66:	8b 40 4c             	mov    0x4c(%eax),%eax
80101b69:	85 c0                	test   %eax,%eax
80101b6b:	74 6a                	je     80101bd7 <iput+0x8c>
80101b6d:	8b 45 08             	mov    0x8(%ebp),%eax
80101b70:	0f b7 40 56          	movzwl 0x56(%eax),%eax
80101b74:	66 85 c0             	test   %ax,%ax
80101b77:	75 5e                	jne    80101bd7 <iput+0x8c>
    acquire(&icache.lock);
80101b79:	83 ec 0c             	sub    $0xc,%esp
80101b7c:	68 60 24 19 80       	push   $0x80192460
80101b81:	e8 07 2e 00 00       	call   8010498d <acquire>
80101b86:	83 c4 10             	add    $0x10,%esp
    int r = ip->ref;
80101b89:	8b 45 08             	mov    0x8(%ebp),%eax
80101b8c:	8b 40 08             	mov    0x8(%eax),%eax
80101b8f:	89 45 f4             	mov    %eax,-0xc(%ebp)
    release(&icache.lock);
80101b92:	83 ec 0c             	sub    $0xc,%esp
80101b95:	68 60 24 19 80       	push   $0x80192460
80101b9a:	e8 5c 2e 00 00       	call   801049fb <release>
80101b9f:	83 c4 10             	add    $0x10,%esp
    if(r == 1){
80101ba2:	83 7d f4 01          	cmpl   $0x1,-0xc(%ebp)
80101ba6:	75 2f                	jne    80101bd7 <iput+0x8c>
      // inode has no links and no other references: truncate and free.
      itrunc(ip);
80101ba8:	83 ec 0c             	sub    $0xc,%esp
80101bab:	ff 75 08             	push   0x8(%ebp)
80101bae:	e8 ad 01 00 00       	call   80101d60 <itrunc>
80101bb3:	83 c4 10             	add    $0x10,%esp
      ip->type = 0;
80101bb6:	8b 45 08             	mov    0x8(%ebp),%eax
80101bb9:	66 c7 40 50 00 00    	movw   $0x0,0x50(%eax)
      iupdate(ip);
80101bbf:	83 ec 0c             	sub    $0xc,%esp
80101bc2:	ff 75 08             	push   0x8(%ebp)
80101bc5:	e8 43 fc ff ff       	call   8010180d <iupdate>
80101bca:	83 c4 10             	add    $0x10,%esp
      ip->valid = 0;
80101bcd:	8b 45 08             	mov    0x8(%ebp),%eax
80101bd0:	c7 40 4c 00 00 00 00 	movl   $0x0,0x4c(%eax)
    }
  }
  releasesleep(&ip->lock);
80101bd7:	8b 45 08             	mov    0x8(%ebp),%eax
80101bda:	83 c0 0c             	add    $0xc,%eax
80101bdd:	83 ec 0c             	sub    $0xc,%esp
80101be0:	50                   	push   %eax
80101be1:	e8 c8 2c 00 00       	call   801048ae <releasesleep>
80101be6:	83 c4 10             	add    $0x10,%esp

  acquire(&icache.lock);
80101be9:	83 ec 0c             	sub    $0xc,%esp
80101bec:	68 60 24 19 80       	push   $0x80192460
80101bf1:	e8 97 2d 00 00       	call   8010498d <acquire>
80101bf6:	83 c4 10             	add    $0x10,%esp
  ip->ref--;
80101bf9:	8b 45 08             	mov    0x8(%ebp),%eax
80101bfc:	8b 40 08             	mov    0x8(%eax),%eax
80101bff:	8d 50 ff             	lea    -0x1(%eax),%edx
80101c02:	8b 45 08             	mov    0x8(%ebp),%eax
80101c05:	89 50 08             	mov    %edx,0x8(%eax)
  release(&icache.lock);
80101c08:	83 ec 0c             	sub    $0xc,%esp
80101c0b:	68 60 24 19 80       	push   $0x80192460
80101c10:	e8 e6 2d 00 00       	call   801049fb <release>
80101c15:	83 c4 10             	add    $0x10,%esp
}
80101c18:	90                   	nop
80101c19:	c9                   	leave  
80101c1a:	c3                   	ret    

80101c1b <iunlockput>:

// Common idiom: unlock, then put.
void
iunlockput(struct inode *ip)
{
80101c1b:	55                   	push   %ebp
80101c1c:	89 e5                	mov    %esp,%ebp
80101c1e:	83 ec 08             	sub    $0x8,%esp
  iunlock(ip);
80101c21:	83 ec 0c             	sub    $0xc,%esp
80101c24:	ff 75 08             	push   0x8(%ebp)
80101c27:	e8 d1 fe ff ff       	call   80101afd <iunlock>
80101c2c:	83 c4 10             	add    $0x10,%esp
  iput(ip);
80101c2f:	83 ec 0c             	sub    $0xc,%esp
80101c32:	ff 75 08             	push   0x8(%ebp)
80101c35:	e8 11 ff ff ff       	call   80101b4b <iput>
80101c3a:	83 c4 10             	add    $0x10,%esp
}
80101c3d:	90                   	nop
80101c3e:	c9                   	leave  
80101c3f:	c3                   	ret    

80101c40 <bmap>:

// Return the disk block address of the nth block in inode ip.
// If there is no such block, bmap allocates one.
static uint
bmap(struct inode *ip, uint bn)
{
80101c40:	55                   	push   %ebp
80101c41:	89 e5                	mov    %esp,%ebp
80101c43:	83 ec 18             	sub    $0x18,%esp
  uint addr, *a;
  struct buf *bp;

  if(bn < NDIRECT){
80101c46:	83 7d 0c 0b          	cmpl   $0xb,0xc(%ebp)
80101c4a:	77 42                	ja     80101c8e <bmap+0x4e>
    if((addr = ip->addrs[bn]) == 0)
80101c4c:	8b 45 08             	mov    0x8(%ebp),%eax
80101c4f:	8b 55 0c             	mov    0xc(%ebp),%edx
80101c52:	83 c2 14             	add    $0x14,%edx
80101c55:	8b 44 90 0c          	mov    0xc(%eax,%edx,4),%eax
80101c59:	89 45 f4             	mov    %eax,-0xc(%ebp)
80101c5c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80101c60:	75 24                	jne    80101c86 <bmap+0x46>
      ip->addrs[bn] = addr = balloc(ip->dev);
80101c62:	8b 45 08             	mov    0x8(%ebp),%eax
80101c65:	8b 00                	mov    (%eax),%eax
80101c67:	83 ec 0c             	sub    $0xc,%esp
80101c6a:	50                   	push   %eax
80101c6b:	e8 f4 f7 ff ff       	call   80101464 <balloc>
80101c70:	83 c4 10             	add    $0x10,%esp
80101c73:	89 45 f4             	mov    %eax,-0xc(%ebp)
80101c76:	8b 45 08             	mov    0x8(%ebp),%eax
80101c79:	8b 55 0c             	mov    0xc(%ebp),%edx
80101c7c:	8d 4a 14             	lea    0x14(%edx),%ecx
80101c7f:	8b 55 f4             	mov    -0xc(%ebp),%edx
80101c82:	89 54 88 0c          	mov    %edx,0xc(%eax,%ecx,4)
    return addr;
80101c86:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101c89:	e9 d0 00 00 00       	jmp    80101d5e <bmap+0x11e>
  }
  bn -= NDIRECT;
80101c8e:	83 6d 0c 0c          	subl   $0xc,0xc(%ebp)

  if(bn < NINDIRECT){
80101c92:	83 7d 0c 7f          	cmpl   $0x7f,0xc(%ebp)
80101c96:	0f 87 b5 00 00 00    	ja     80101d51 <bmap+0x111>
    // Load indirect block, allocating if necessary.
    if((addr = ip->addrs[NDIRECT]) == 0)
80101c9c:	8b 45 08             	mov    0x8(%ebp),%eax
80101c9f:	8b 80 8c 00 00 00    	mov    0x8c(%eax),%eax
80101ca5:	89 45 f4             	mov    %eax,-0xc(%ebp)
80101ca8:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80101cac:	75 20                	jne    80101cce <bmap+0x8e>
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
80101cae:	8b 45 08             	mov    0x8(%ebp),%eax
80101cb1:	8b 00                	mov    (%eax),%eax
80101cb3:	83 ec 0c             	sub    $0xc,%esp
80101cb6:	50                   	push   %eax
80101cb7:	e8 a8 f7 ff ff       	call   80101464 <balloc>
80101cbc:	83 c4 10             	add    $0x10,%esp
80101cbf:	89 45 f4             	mov    %eax,-0xc(%ebp)
80101cc2:	8b 45 08             	mov    0x8(%ebp),%eax
80101cc5:	8b 55 f4             	mov    -0xc(%ebp),%edx
80101cc8:	89 90 8c 00 00 00    	mov    %edx,0x8c(%eax)
    bp = bread(ip->dev, addr);
80101cce:	8b 45 08             	mov    0x8(%ebp),%eax
80101cd1:	8b 00                	mov    (%eax),%eax
80101cd3:	83 ec 08             	sub    $0x8,%esp
80101cd6:	ff 75 f4             	push   -0xc(%ebp)
80101cd9:	50                   	push   %eax
80101cda:	e8 22 e5 ff ff       	call   80100201 <bread>
80101cdf:	83 c4 10             	add    $0x10,%esp
80101ce2:	89 45 f0             	mov    %eax,-0x10(%ebp)
    a = (uint*)bp->data;
80101ce5:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101ce8:	83 c0 5c             	add    $0x5c,%eax
80101ceb:	89 45 ec             	mov    %eax,-0x14(%ebp)
    if((addr = a[bn]) == 0){
80101cee:	8b 45 0c             	mov    0xc(%ebp),%eax
80101cf1:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80101cf8:	8b 45 ec             	mov    -0x14(%ebp),%eax
80101cfb:	01 d0                	add    %edx,%eax
80101cfd:	8b 00                	mov    (%eax),%eax
80101cff:	89 45 f4             	mov    %eax,-0xc(%ebp)
80101d02:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80101d06:	75 36                	jne    80101d3e <bmap+0xfe>
      a[bn] = addr = balloc(ip->dev);
80101d08:	8b 45 08             	mov    0x8(%ebp),%eax
80101d0b:	8b 00                	mov    (%eax),%eax
80101d0d:	83 ec 0c             	sub    $0xc,%esp
80101d10:	50                   	push   %eax
80101d11:	e8 4e f7 ff ff       	call   80101464 <balloc>
80101d16:	83 c4 10             	add    $0x10,%esp
80101d19:	89 45 f4             	mov    %eax,-0xc(%ebp)
80101d1c:	8b 45 0c             	mov    0xc(%ebp),%eax
80101d1f:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80101d26:	8b 45 ec             	mov    -0x14(%ebp),%eax
80101d29:	01 c2                	add    %eax,%edx
80101d2b:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101d2e:	89 02                	mov    %eax,(%edx)
      log_write(bp);
80101d30:	83 ec 0c             	sub    $0xc,%esp
80101d33:	ff 75 f0             	push   -0x10(%ebp)
80101d36:	e8 3a 15 00 00       	call   80103275 <log_write>
80101d3b:	83 c4 10             	add    $0x10,%esp
    }
    brelse(bp);
80101d3e:	83 ec 0c             	sub    $0xc,%esp
80101d41:	ff 75 f0             	push   -0x10(%ebp)
80101d44:	e8 3a e5 ff ff       	call   80100283 <brelse>
80101d49:	83 c4 10             	add    $0x10,%esp
    return addr;
80101d4c:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101d4f:	eb 0d                	jmp    80101d5e <bmap+0x11e>
  }

  panic("bmap: out of range");
80101d51:	83 ec 0c             	sub    $0xc,%esp
80101d54:	68 0a a4 10 80       	push   $0x8010a40a
80101d59:	e8 4b e8 ff ff       	call   801005a9 <panic>
}
80101d5e:	c9                   	leave  
80101d5f:	c3                   	ret    

80101d60 <itrunc>:
// to it (no directory entries referring to it)
// and has no in-memory reference to it (is
// not an open file or current directory).
static void
itrunc(struct inode *ip)
{
80101d60:	55                   	push   %ebp
80101d61:	89 e5                	mov    %esp,%ebp
80101d63:	83 ec 18             	sub    $0x18,%esp
  int i, j;
  struct buf *bp;
  uint *a;

  for(i = 0; i < NDIRECT; i++){
80101d66:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80101d6d:	eb 45                	jmp    80101db4 <itrunc+0x54>
    if(ip->addrs[i]){
80101d6f:	8b 45 08             	mov    0x8(%ebp),%eax
80101d72:	8b 55 f4             	mov    -0xc(%ebp),%edx
80101d75:	83 c2 14             	add    $0x14,%edx
80101d78:	8b 44 90 0c          	mov    0xc(%eax,%edx,4),%eax
80101d7c:	85 c0                	test   %eax,%eax
80101d7e:	74 30                	je     80101db0 <itrunc+0x50>
      bfree(ip->dev, ip->addrs[i]);
80101d80:	8b 45 08             	mov    0x8(%ebp),%eax
80101d83:	8b 55 f4             	mov    -0xc(%ebp),%edx
80101d86:	83 c2 14             	add    $0x14,%edx
80101d89:	8b 44 90 0c          	mov    0xc(%eax,%edx,4),%eax
80101d8d:	8b 55 08             	mov    0x8(%ebp),%edx
80101d90:	8b 12                	mov    (%edx),%edx
80101d92:	83 ec 08             	sub    $0x8,%esp
80101d95:	50                   	push   %eax
80101d96:	52                   	push   %edx
80101d97:	e8 0c f8 ff ff       	call   801015a8 <bfree>
80101d9c:	83 c4 10             	add    $0x10,%esp
      ip->addrs[i] = 0;
80101d9f:	8b 45 08             	mov    0x8(%ebp),%eax
80101da2:	8b 55 f4             	mov    -0xc(%ebp),%edx
80101da5:	83 c2 14             	add    $0x14,%edx
80101da8:	c7 44 90 0c 00 00 00 	movl   $0x0,0xc(%eax,%edx,4)
80101daf:	00 
  for(i = 0; i < NDIRECT; i++){
80101db0:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80101db4:	83 7d f4 0b          	cmpl   $0xb,-0xc(%ebp)
80101db8:	7e b5                	jle    80101d6f <itrunc+0xf>
    }
  }

  if(ip->addrs[NDIRECT]){
80101dba:	8b 45 08             	mov    0x8(%ebp),%eax
80101dbd:	8b 80 8c 00 00 00    	mov    0x8c(%eax),%eax
80101dc3:	85 c0                	test   %eax,%eax
80101dc5:	0f 84 aa 00 00 00    	je     80101e75 <itrunc+0x115>
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
80101dcb:	8b 45 08             	mov    0x8(%ebp),%eax
80101dce:	8b 90 8c 00 00 00    	mov    0x8c(%eax),%edx
80101dd4:	8b 45 08             	mov    0x8(%ebp),%eax
80101dd7:	8b 00                	mov    (%eax),%eax
80101dd9:	83 ec 08             	sub    $0x8,%esp
80101ddc:	52                   	push   %edx
80101ddd:	50                   	push   %eax
80101dde:	e8 1e e4 ff ff       	call   80100201 <bread>
80101de3:	83 c4 10             	add    $0x10,%esp
80101de6:	89 45 ec             	mov    %eax,-0x14(%ebp)
    a = (uint*)bp->data;
80101de9:	8b 45 ec             	mov    -0x14(%ebp),%eax
80101dec:	83 c0 5c             	add    $0x5c,%eax
80101def:	89 45 e8             	mov    %eax,-0x18(%ebp)
    for(j = 0; j < NINDIRECT; j++){
80101df2:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
80101df9:	eb 3c                	jmp    80101e37 <itrunc+0xd7>
      if(a[j])
80101dfb:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101dfe:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80101e05:	8b 45 e8             	mov    -0x18(%ebp),%eax
80101e08:	01 d0                	add    %edx,%eax
80101e0a:	8b 00                	mov    (%eax),%eax
80101e0c:	85 c0                	test   %eax,%eax
80101e0e:	74 23                	je     80101e33 <itrunc+0xd3>
        bfree(ip->dev, a[j]);
80101e10:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101e13:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80101e1a:	8b 45 e8             	mov    -0x18(%ebp),%eax
80101e1d:	01 d0                	add    %edx,%eax
80101e1f:	8b 00                	mov    (%eax),%eax
80101e21:	8b 55 08             	mov    0x8(%ebp),%edx
80101e24:	8b 12                	mov    (%edx),%edx
80101e26:	83 ec 08             	sub    $0x8,%esp
80101e29:	50                   	push   %eax
80101e2a:	52                   	push   %edx
80101e2b:	e8 78 f7 ff ff       	call   801015a8 <bfree>
80101e30:	83 c4 10             	add    $0x10,%esp
    for(j = 0; j < NINDIRECT; j++){
80101e33:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
80101e37:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101e3a:	83 f8 7f             	cmp    $0x7f,%eax
80101e3d:	76 bc                	jbe    80101dfb <itrunc+0x9b>
    }
    brelse(bp);
80101e3f:	83 ec 0c             	sub    $0xc,%esp
80101e42:	ff 75 ec             	push   -0x14(%ebp)
80101e45:	e8 39 e4 ff ff       	call   80100283 <brelse>
80101e4a:	83 c4 10             	add    $0x10,%esp
    bfree(ip->dev, ip->addrs[NDIRECT]);
80101e4d:	8b 45 08             	mov    0x8(%ebp),%eax
80101e50:	8b 80 8c 00 00 00    	mov    0x8c(%eax),%eax
80101e56:	8b 55 08             	mov    0x8(%ebp),%edx
80101e59:	8b 12                	mov    (%edx),%edx
80101e5b:	83 ec 08             	sub    $0x8,%esp
80101e5e:	50                   	push   %eax
80101e5f:	52                   	push   %edx
80101e60:	e8 43 f7 ff ff       	call   801015a8 <bfree>
80101e65:	83 c4 10             	add    $0x10,%esp
    ip->addrs[NDIRECT] = 0;
80101e68:	8b 45 08             	mov    0x8(%ebp),%eax
80101e6b:	c7 80 8c 00 00 00 00 	movl   $0x0,0x8c(%eax)
80101e72:	00 00 00 
  }

  ip->size = 0;
80101e75:	8b 45 08             	mov    0x8(%ebp),%eax
80101e78:	c7 40 58 00 00 00 00 	movl   $0x0,0x58(%eax)
  iupdate(ip);
80101e7f:	83 ec 0c             	sub    $0xc,%esp
80101e82:	ff 75 08             	push   0x8(%ebp)
80101e85:	e8 83 f9 ff ff       	call   8010180d <iupdate>
80101e8a:	83 c4 10             	add    $0x10,%esp
}
80101e8d:	90                   	nop
80101e8e:	c9                   	leave  
80101e8f:	c3                   	ret    

80101e90 <stati>:

// Copy stat information from inode.
// Caller must hold ip->lock.
void
stati(struct inode *ip, struct stat *st)
{
80101e90:	55                   	push   %ebp
80101e91:	89 e5                	mov    %esp,%ebp
  st->dev = ip->dev;
80101e93:	8b 45 08             	mov    0x8(%ebp),%eax
80101e96:	8b 00                	mov    (%eax),%eax
80101e98:	89 c2                	mov    %eax,%edx
80101e9a:	8b 45 0c             	mov    0xc(%ebp),%eax
80101e9d:	89 50 04             	mov    %edx,0x4(%eax)
  st->ino = ip->inum;
80101ea0:	8b 45 08             	mov    0x8(%ebp),%eax
80101ea3:	8b 50 04             	mov    0x4(%eax),%edx
80101ea6:	8b 45 0c             	mov    0xc(%ebp),%eax
80101ea9:	89 50 08             	mov    %edx,0x8(%eax)
  st->type = ip->type;
80101eac:	8b 45 08             	mov    0x8(%ebp),%eax
80101eaf:	0f b7 50 50          	movzwl 0x50(%eax),%edx
80101eb3:	8b 45 0c             	mov    0xc(%ebp),%eax
80101eb6:	66 89 10             	mov    %dx,(%eax)
  st->nlink = ip->nlink;
80101eb9:	8b 45 08             	mov    0x8(%ebp),%eax
80101ebc:	0f b7 50 56          	movzwl 0x56(%eax),%edx
80101ec0:	8b 45 0c             	mov    0xc(%ebp),%eax
80101ec3:	66 89 50 0c          	mov    %dx,0xc(%eax)
  st->size = ip->size;
80101ec7:	8b 45 08             	mov    0x8(%ebp),%eax
80101eca:	8b 50 58             	mov    0x58(%eax),%edx
80101ecd:	8b 45 0c             	mov    0xc(%ebp),%eax
80101ed0:	89 50 10             	mov    %edx,0x10(%eax)
}
80101ed3:	90                   	nop
80101ed4:	5d                   	pop    %ebp
80101ed5:	c3                   	ret    

80101ed6 <readi>:
//PAGEBREAK!
// Read data from inode.
// Caller must hold ip->lock.
int
readi(struct inode *ip, char *dst, uint off, uint n)
{
80101ed6:	55                   	push   %ebp
80101ed7:	89 e5                	mov    %esp,%ebp
80101ed9:	83 ec 18             	sub    $0x18,%esp
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
80101edc:	8b 45 08             	mov    0x8(%ebp),%eax
80101edf:	0f b7 40 50          	movzwl 0x50(%eax),%eax
80101ee3:	66 83 f8 03          	cmp    $0x3,%ax
80101ee7:	75 5c                	jne    80101f45 <readi+0x6f>
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].read)
80101ee9:	8b 45 08             	mov    0x8(%ebp),%eax
80101eec:	0f b7 40 52          	movzwl 0x52(%eax),%eax
80101ef0:	66 85 c0             	test   %ax,%ax
80101ef3:	78 20                	js     80101f15 <readi+0x3f>
80101ef5:	8b 45 08             	mov    0x8(%ebp),%eax
80101ef8:	0f b7 40 52          	movzwl 0x52(%eax),%eax
80101efc:	66 83 f8 09          	cmp    $0x9,%ax
80101f00:	7f 13                	jg     80101f15 <readi+0x3f>
80101f02:	8b 45 08             	mov    0x8(%ebp),%eax
80101f05:	0f b7 40 52          	movzwl 0x52(%eax),%eax
80101f09:	98                   	cwtl   
80101f0a:	8b 04 c5 40 1a 19 80 	mov    -0x7fe6e5c0(,%eax,8),%eax
80101f11:	85 c0                	test   %eax,%eax
80101f13:	75 0a                	jne    80101f1f <readi+0x49>
      return -1;
80101f15:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101f1a:	e9 0a 01 00 00       	jmp    80102029 <readi+0x153>
    return devsw[ip->major].read(ip, dst, n);
80101f1f:	8b 45 08             	mov    0x8(%ebp),%eax
80101f22:	0f b7 40 52          	movzwl 0x52(%eax),%eax
80101f26:	98                   	cwtl   
80101f27:	8b 04 c5 40 1a 19 80 	mov    -0x7fe6e5c0(,%eax,8),%eax
80101f2e:	8b 55 14             	mov    0x14(%ebp),%edx
80101f31:	83 ec 04             	sub    $0x4,%esp
80101f34:	52                   	push   %edx
80101f35:	ff 75 0c             	push   0xc(%ebp)
80101f38:	ff 75 08             	push   0x8(%ebp)
80101f3b:	ff d0                	call   *%eax
80101f3d:	83 c4 10             	add    $0x10,%esp
80101f40:	e9 e4 00 00 00       	jmp    80102029 <readi+0x153>
  }

  if(off > ip->size || off + n < off)
80101f45:	8b 45 08             	mov    0x8(%ebp),%eax
80101f48:	8b 40 58             	mov    0x58(%eax),%eax
80101f4b:	39 45 10             	cmp    %eax,0x10(%ebp)
80101f4e:	77 0d                	ja     80101f5d <readi+0x87>
80101f50:	8b 55 10             	mov    0x10(%ebp),%edx
80101f53:	8b 45 14             	mov    0x14(%ebp),%eax
80101f56:	01 d0                	add    %edx,%eax
80101f58:	39 45 10             	cmp    %eax,0x10(%ebp)
80101f5b:	76 0a                	jbe    80101f67 <readi+0x91>
    return -1;
80101f5d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101f62:	e9 c2 00 00 00       	jmp    80102029 <readi+0x153>
  if(off + n > ip->size)
80101f67:	8b 55 10             	mov    0x10(%ebp),%edx
80101f6a:	8b 45 14             	mov    0x14(%ebp),%eax
80101f6d:	01 c2                	add    %eax,%edx
80101f6f:	8b 45 08             	mov    0x8(%ebp),%eax
80101f72:	8b 40 58             	mov    0x58(%eax),%eax
80101f75:	39 c2                	cmp    %eax,%edx
80101f77:	76 0c                	jbe    80101f85 <readi+0xaf>
    n = ip->size - off;
80101f79:	8b 45 08             	mov    0x8(%ebp),%eax
80101f7c:	8b 40 58             	mov    0x58(%eax),%eax
80101f7f:	2b 45 10             	sub    0x10(%ebp),%eax
80101f82:	89 45 14             	mov    %eax,0x14(%ebp)

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101f85:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80101f8c:	e9 89 00 00 00       	jmp    8010201a <readi+0x144>
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101f91:	8b 45 10             	mov    0x10(%ebp),%eax
80101f94:	c1 e8 09             	shr    $0x9,%eax
80101f97:	83 ec 08             	sub    $0x8,%esp
80101f9a:	50                   	push   %eax
80101f9b:	ff 75 08             	push   0x8(%ebp)
80101f9e:	e8 9d fc ff ff       	call   80101c40 <bmap>
80101fa3:	83 c4 10             	add    $0x10,%esp
80101fa6:	8b 55 08             	mov    0x8(%ebp),%edx
80101fa9:	8b 12                	mov    (%edx),%edx
80101fab:	83 ec 08             	sub    $0x8,%esp
80101fae:	50                   	push   %eax
80101faf:	52                   	push   %edx
80101fb0:	e8 4c e2 ff ff       	call   80100201 <bread>
80101fb5:	83 c4 10             	add    $0x10,%esp
80101fb8:	89 45 f0             	mov    %eax,-0x10(%ebp)
    m = min(n - tot, BSIZE - off%BSIZE);
80101fbb:	8b 45 10             	mov    0x10(%ebp),%eax
80101fbe:	25 ff 01 00 00       	and    $0x1ff,%eax
80101fc3:	ba 00 02 00 00       	mov    $0x200,%edx
80101fc8:	29 c2                	sub    %eax,%edx
80101fca:	8b 45 14             	mov    0x14(%ebp),%eax
80101fcd:	2b 45 f4             	sub    -0xc(%ebp),%eax
80101fd0:	39 c2                	cmp    %eax,%edx
80101fd2:	0f 46 c2             	cmovbe %edx,%eax
80101fd5:	89 45 ec             	mov    %eax,-0x14(%ebp)
    memmove(dst, bp->data + off%BSIZE, m);
80101fd8:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101fdb:	8d 50 5c             	lea    0x5c(%eax),%edx
80101fde:	8b 45 10             	mov    0x10(%ebp),%eax
80101fe1:	25 ff 01 00 00       	and    $0x1ff,%eax
80101fe6:	01 d0                	add    %edx,%eax
80101fe8:	83 ec 04             	sub    $0x4,%esp
80101feb:	ff 75 ec             	push   -0x14(%ebp)
80101fee:	50                   	push   %eax
80101fef:	ff 75 0c             	push   0xc(%ebp)
80101ff2:	e8 cb 2c 00 00       	call   80104cc2 <memmove>
80101ff7:	83 c4 10             	add    $0x10,%esp
    brelse(bp);
80101ffa:	83 ec 0c             	sub    $0xc,%esp
80101ffd:	ff 75 f0             	push   -0x10(%ebp)
80102000:	e8 7e e2 ff ff       	call   80100283 <brelse>
80102005:	83 c4 10             	add    $0x10,%esp
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80102008:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010200b:	01 45 f4             	add    %eax,-0xc(%ebp)
8010200e:	8b 45 ec             	mov    -0x14(%ebp),%eax
80102011:	01 45 10             	add    %eax,0x10(%ebp)
80102014:	8b 45 ec             	mov    -0x14(%ebp),%eax
80102017:	01 45 0c             	add    %eax,0xc(%ebp)
8010201a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010201d:	3b 45 14             	cmp    0x14(%ebp),%eax
80102020:	0f 82 6b ff ff ff    	jb     80101f91 <readi+0xbb>
  }
  return n;
80102026:	8b 45 14             	mov    0x14(%ebp),%eax
}
80102029:	c9                   	leave  
8010202a:	c3                   	ret    

8010202b <writei>:
// PAGEBREAK!
// Write data to inode.
// Caller must hold ip->lock.
int
writei(struct inode *ip, char *src, uint off, uint n)
{
8010202b:	55                   	push   %ebp
8010202c:	89 e5                	mov    %esp,%ebp
8010202e:	83 ec 18             	sub    $0x18,%esp
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
80102031:	8b 45 08             	mov    0x8(%ebp),%eax
80102034:	0f b7 40 50          	movzwl 0x50(%eax),%eax
80102038:	66 83 f8 03          	cmp    $0x3,%ax
8010203c:	75 5c                	jne    8010209a <writei+0x6f>
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].write)
8010203e:	8b 45 08             	mov    0x8(%ebp),%eax
80102041:	0f b7 40 52          	movzwl 0x52(%eax),%eax
80102045:	66 85 c0             	test   %ax,%ax
80102048:	78 20                	js     8010206a <writei+0x3f>
8010204a:	8b 45 08             	mov    0x8(%ebp),%eax
8010204d:	0f b7 40 52          	movzwl 0x52(%eax),%eax
80102051:	66 83 f8 09          	cmp    $0x9,%ax
80102055:	7f 13                	jg     8010206a <writei+0x3f>
80102057:	8b 45 08             	mov    0x8(%ebp),%eax
8010205a:	0f b7 40 52          	movzwl 0x52(%eax),%eax
8010205e:	98                   	cwtl   
8010205f:	8b 04 c5 44 1a 19 80 	mov    -0x7fe6e5bc(,%eax,8),%eax
80102066:	85 c0                	test   %eax,%eax
80102068:	75 0a                	jne    80102074 <writei+0x49>
      return -1;
8010206a:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010206f:	e9 3b 01 00 00       	jmp    801021af <writei+0x184>
    return devsw[ip->major].write(ip, src, n);
80102074:	8b 45 08             	mov    0x8(%ebp),%eax
80102077:	0f b7 40 52          	movzwl 0x52(%eax),%eax
8010207b:	98                   	cwtl   
8010207c:	8b 04 c5 44 1a 19 80 	mov    -0x7fe6e5bc(,%eax,8),%eax
80102083:	8b 55 14             	mov    0x14(%ebp),%edx
80102086:	83 ec 04             	sub    $0x4,%esp
80102089:	52                   	push   %edx
8010208a:	ff 75 0c             	push   0xc(%ebp)
8010208d:	ff 75 08             	push   0x8(%ebp)
80102090:	ff d0                	call   *%eax
80102092:	83 c4 10             	add    $0x10,%esp
80102095:	e9 15 01 00 00       	jmp    801021af <writei+0x184>
  }

  if(off > ip->size || off + n < off)
8010209a:	8b 45 08             	mov    0x8(%ebp),%eax
8010209d:	8b 40 58             	mov    0x58(%eax),%eax
801020a0:	39 45 10             	cmp    %eax,0x10(%ebp)
801020a3:	77 0d                	ja     801020b2 <writei+0x87>
801020a5:	8b 55 10             	mov    0x10(%ebp),%edx
801020a8:	8b 45 14             	mov    0x14(%ebp),%eax
801020ab:	01 d0                	add    %edx,%eax
801020ad:	39 45 10             	cmp    %eax,0x10(%ebp)
801020b0:	76 0a                	jbe    801020bc <writei+0x91>
    return -1;
801020b2:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801020b7:	e9 f3 00 00 00       	jmp    801021af <writei+0x184>
  if(off + n > MAXFILE*BSIZE)
801020bc:	8b 55 10             	mov    0x10(%ebp),%edx
801020bf:	8b 45 14             	mov    0x14(%ebp),%eax
801020c2:	01 d0                	add    %edx,%eax
801020c4:	3d 00 18 01 00       	cmp    $0x11800,%eax
801020c9:	76 0a                	jbe    801020d5 <writei+0xaa>
    return -1;
801020cb:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801020d0:	e9 da 00 00 00       	jmp    801021af <writei+0x184>

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
801020d5:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
801020dc:	e9 97 00 00 00       	jmp    80102178 <writei+0x14d>
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
801020e1:	8b 45 10             	mov    0x10(%ebp),%eax
801020e4:	c1 e8 09             	shr    $0x9,%eax
801020e7:	83 ec 08             	sub    $0x8,%esp
801020ea:	50                   	push   %eax
801020eb:	ff 75 08             	push   0x8(%ebp)
801020ee:	e8 4d fb ff ff       	call   80101c40 <bmap>
801020f3:	83 c4 10             	add    $0x10,%esp
801020f6:	8b 55 08             	mov    0x8(%ebp),%edx
801020f9:	8b 12                	mov    (%edx),%edx
801020fb:	83 ec 08             	sub    $0x8,%esp
801020fe:	50                   	push   %eax
801020ff:	52                   	push   %edx
80102100:	e8 fc e0 ff ff       	call   80100201 <bread>
80102105:	83 c4 10             	add    $0x10,%esp
80102108:	89 45 f0             	mov    %eax,-0x10(%ebp)
    m = min(n - tot, BSIZE - off%BSIZE);
8010210b:	8b 45 10             	mov    0x10(%ebp),%eax
8010210e:	25 ff 01 00 00       	and    $0x1ff,%eax
80102113:	ba 00 02 00 00       	mov    $0x200,%edx
80102118:	29 c2                	sub    %eax,%edx
8010211a:	8b 45 14             	mov    0x14(%ebp),%eax
8010211d:	2b 45 f4             	sub    -0xc(%ebp),%eax
80102120:	39 c2                	cmp    %eax,%edx
80102122:	0f 46 c2             	cmovbe %edx,%eax
80102125:	89 45 ec             	mov    %eax,-0x14(%ebp)
    memmove(bp->data + off%BSIZE, src, m);
80102128:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010212b:	8d 50 5c             	lea    0x5c(%eax),%edx
8010212e:	8b 45 10             	mov    0x10(%ebp),%eax
80102131:	25 ff 01 00 00       	and    $0x1ff,%eax
80102136:	01 d0                	add    %edx,%eax
80102138:	83 ec 04             	sub    $0x4,%esp
8010213b:	ff 75 ec             	push   -0x14(%ebp)
8010213e:	ff 75 0c             	push   0xc(%ebp)
80102141:	50                   	push   %eax
80102142:	e8 7b 2b 00 00       	call   80104cc2 <memmove>
80102147:	83 c4 10             	add    $0x10,%esp
    log_write(bp);
8010214a:	83 ec 0c             	sub    $0xc,%esp
8010214d:	ff 75 f0             	push   -0x10(%ebp)
80102150:	e8 20 11 00 00       	call   80103275 <log_write>
80102155:	83 c4 10             	add    $0x10,%esp
    brelse(bp);
80102158:	83 ec 0c             	sub    $0xc,%esp
8010215b:	ff 75 f0             	push   -0x10(%ebp)
8010215e:	e8 20 e1 ff ff       	call   80100283 <brelse>
80102163:	83 c4 10             	add    $0x10,%esp
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80102166:	8b 45 ec             	mov    -0x14(%ebp),%eax
80102169:	01 45 f4             	add    %eax,-0xc(%ebp)
8010216c:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010216f:	01 45 10             	add    %eax,0x10(%ebp)
80102172:	8b 45 ec             	mov    -0x14(%ebp),%eax
80102175:	01 45 0c             	add    %eax,0xc(%ebp)
80102178:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010217b:	3b 45 14             	cmp    0x14(%ebp),%eax
8010217e:	0f 82 5d ff ff ff    	jb     801020e1 <writei+0xb6>
  }

  if(n > 0 && off > ip->size){
80102184:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
80102188:	74 22                	je     801021ac <writei+0x181>
8010218a:	8b 45 08             	mov    0x8(%ebp),%eax
8010218d:	8b 40 58             	mov    0x58(%eax),%eax
80102190:	39 45 10             	cmp    %eax,0x10(%ebp)
80102193:	76 17                	jbe    801021ac <writei+0x181>
    ip->size = off;
80102195:	8b 45 08             	mov    0x8(%ebp),%eax
80102198:	8b 55 10             	mov    0x10(%ebp),%edx
8010219b:	89 50 58             	mov    %edx,0x58(%eax)
    iupdate(ip);
8010219e:	83 ec 0c             	sub    $0xc,%esp
801021a1:	ff 75 08             	push   0x8(%ebp)
801021a4:	e8 64 f6 ff ff       	call   8010180d <iupdate>
801021a9:	83 c4 10             	add    $0x10,%esp
  }
  return n;
801021ac:	8b 45 14             	mov    0x14(%ebp),%eax
}
801021af:	c9                   	leave  
801021b0:	c3                   	ret    

801021b1 <namecmp>:
//PAGEBREAK!
// Directories

int
namecmp(const char *s, const char *t)
{
801021b1:	55                   	push   %ebp
801021b2:	89 e5                	mov    %esp,%ebp
801021b4:	83 ec 08             	sub    $0x8,%esp
  return strncmp(s, t, DIRSIZ);
801021b7:	83 ec 04             	sub    $0x4,%esp
801021ba:	6a 0e                	push   $0xe
801021bc:	ff 75 0c             	push   0xc(%ebp)
801021bf:	ff 75 08             	push   0x8(%ebp)
801021c2:	e8 91 2b 00 00       	call   80104d58 <strncmp>
801021c7:	83 c4 10             	add    $0x10,%esp
}
801021ca:	c9                   	leave  
801021cb:	c3                   	ret    

801021cc <dirlookup>:

// Look for a directory entry in a directory.
// If found, set *poff to byte offset of entry.
struct inode*
dirlookup(struct inode *dp, char *name, uint *poff)
{
801021cc:	55                   	push   %ebp
801021cd:	89 e5                	mov    %esp,%ebp
801021cf:	83 ec 28             	sub    $0x28,%esp
  uint off, inum;
  struct dirent de;

  if(dp->type != T_DIR)
801021d2:	8b 45 08             	mov    0x8(%ebp),%eax
801021d5:	0f b7 40 50          	movzwl 0x50(%eax),%eax
801021d9:	66 83 f8 01          	cmp    $0x1,%ax
801021dd:	74 0d                	je     801021ec <dirlookup+0x20>
    panic("dirlookup not DIR");
801021df:	83 ec 0c             	sub    $0xc,%esp
801021e2:	68 1d a4 10 80       	push   $0x8010a41d
801021e7:	e8 bd e3 ff ff       	call   801005a9 <panic>

  for(off = 0; off < dp->size; off += sizeof(de)){
801021ec:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
801021f3:	eb 7b                	jmp    80102270 <dirlookup+0xa4>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
801021f5:	6a 10                	push   $0x10
801021f7:	ff 75 f4             	push   -0xc(%ebp)
801021fa:	8d 45 e0             	lea    -0x20(%ebp),%eax
801021fd:	50                   	push   %eax
801021fe:	ff 75 08             	push   0x8(%ebp)
80102201:	e8 d0 fc ff ff       	call   80101ed6 <readi>
80102206:	83 c4 10             	add    $0x10,%esp
80102209:	83 f8 10             	cmp    $0x10,%eax
8010220c:	74 0d                	je     8010221b <dirlookup+0x4f>
      panic("dirlookup read");
8010220e:	83 ec 0c             	sub    $0xc,%esp
80102211:	68 2f a4 10 80       	push   $0x8010a42f
80102216:	e8 8e e3 ff ff       	call   801005a9 <panic>
    if(de.inum == 0)
8010221b:	0f b7 45 e0          	movzwl -0x20(%ebp),%eax
8010221f:	66 85 c0             	test   %ax,%ax
80102222:	74 47                	je     8010226b <dirlookup+0x9f>
      continue;
    if(namecmp(name, de.name) == 0){
80102224:	83 ec 08             	sub    $0x8,%esp
80102227:	8d 45 e0             	lea    -0x20(%ebp),%eax
8010222a:	83 c0 02             	add    $0x2,%eax
8010222d:	50                   	push   %eax
8010222e:	ff 75 0c             	push   0xc(%ebp)
80102231:	e8 7b ff ff ff       	call   801021b1 <namecmp>
80102236:	83 c4 10             	add    $0x10,%esp
80102239:	85 c0                	test   %eax,%eax
8010223b:	75 2f                	jne    8010226c <dirlookup+0xa0>
      // entry matches path element
      if(poff)
8010223d:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
80102241:	74 08                	je     8010224b <dirlookup+0x7f>
        *poff = off;
80102243:	8b 45 10             	mov    0x10(%ebp),%eax
80102246:	8b 55 f4             	mov    -0xc(%ebp),%edx
80102249:	89 10                	mov    %edx,(%eax)
      inum = de.inum;
8010224b:	0f b7 45 e0          	movzwl -0x20(%ebp),%eax
8010224f:	0f b7 c0             	movzwl %ax,%eax
80102252:	89 45 f0             	mov    %eax,-0x10(%ebp)
      return iget(dp->dev, inum);
80102255:	8b 45 08             	mov    0x8(%ebp),%eax
80102258:	8b 00                	mov    (%eax),%eax
8010225a:	83 ec 08             	sub    $0x8,%esp
8010225d:	ff 75 f0             	push   -0x10(%ebp)
80102260:	50                   	push   %eax
80102261:	e8 68 f6 ff ff       	call   801018ce <iget>
80102266:	83 c4 10             	add    $0x10,%esp
80102269:	eb 19                	jmp    80102284 <dirlookup+0xb8>
      continue;
8010226b:	90                   	nop
  for(off = 0; off < dp->size; off += sizeof(de)){
8010226c:	83 45 f4 10          	addl   $0x10,-0xc(%ebp)
80102270:	8b 45 08             	mov    0x8(%ebp),%eax
80102273:	8b 40 58             	mov    0x58(%eax),%eax
80102276:	39 45 f4             	cmp    %eax,-0xc(%ebp)
80102279:	0f 82 76 ff ff ff    	jb     801021f5 <dirlookup+0x29>
    }
  }

  return 0;
8010227f:	b8 00 00 00 00       	mov    $0x0,%eax
}
80102284:	c9                   	leave  
80102285:	c3                   	ret    

80102286 <dirlink>:

// Write a new directory entry (name, inum) into the directory dp.
int
dirlink(struct inode *dp, char *name, uint inum)
{
80102286:	55                   	push   %ebp
80102287:	89 e5                	mov    %esp,%ebp
80102289:	83 ec 28             	sub    $0x28,%esp
  int off;
  struct dirent de;
  struct inode *ip;

  // Check that name is not present.
  if((ip = dirlookup(dp, name, 0)) != 0){
8010228c:	83 ec 04             	sub    $0x4,%esp
8010228f:	6a 00                	push   $0x0
80102291:	ff 75 0c             	push   0xc(%ebp)
80102294:	ff 75 08             	push   0x8(%ebp)
80102297:	e8 30 ff ff ff       	call   801021cc <dirlookup>
8010229c:	83 c4 10             	add    $0x10,%esp
8010229f:	89 45 f0             	mov    %eax,-0x10(%ebp)
801022a2:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
801022a6:	74 18                	je     801022c0 <dirlink+0x3a>
    iput(ip);
801022a8:	83 ec 0c             	sub    $0xc,%esp
801022ab:	ff 75 f0             	push   -0x10(%ebp)
801022ae:	e8 98 f8 ff ff       	call   80101b4b <iput>
801022b3:	83 c4 10             	add    $0x10,%esp
    return -1;
801022b6:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801022bb:	e9 9c 00 00 00       	jmp    8010235c <dirlink+0xd6>
  }

  // Look for an empty dirent.
  for(off = 0; off < dp->size; off += sizeof(de)){
801022c0:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
801022c7:	eb 39                	jmp    80102302 <dirlink+0x7c>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
801022c9:	8b 45 f4             	mov    -0xc(%ebp),%eax
801022cc:	6a 10                	push   $0x10
801022ce:	50                   	push   %eax
801022cf:	8d 45 e0             	lea    -0x20(%ebp),%eax
801022d2:	50                   	push   %eax
801022d3:	ff 75 08             	push   0x8(%ebp)
801022d6:	e8 fb fb ff ff       	call   80101ed6 <readi>
801022db:	83 c4 10             	add    $0x10,%esp
801022de:	83 f8 10             	cmp    $0x10,%eax
801022e1:	74 0d                	je     801022f0 <dirlink+0x6a>
      panic("dirlink read");
801022e3:	83 ec 0c             	sub    $0xc,%esp
801022e6:	68 3e a4 10 80       	push   $0x8010a43e
801022eb:	e8 b9 e2 ff ff       	call   801005a9 <panic>
    if(de.inum == 0)
801022f0:	0f b7 45 e0          	movzwl -0x20(%ebp),%eax
801022f4:	66 85 c0             	test   %ax,%ax
801022f7:	74 18                	je     80102311 <dirlink+0x8b>
  for(off = 0; off < dp->size; off += sizeof(de)){
801022f9:	8b 45 f4             	mov    -0xc(%ebp),%eax
801022fc:	83 c0 10             	add    $0x10,%eax
801022ff:	89 45 f4             	mov    %eax,-0xc(%ebp)
80102302:	8b 45 08             	mov    0x8(%ebp),%eax
80102305:	8b 50 58             	mov    0x58(%eax),%edx
80102308:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010230b:	39 c2                	cmp    %eax,%edx
8010230d:	77 ba                	ja     801022c9 <dirlink+0x43>
8010230f:	eb 01                	jmp    80102312 <dirlink+0x8c>
      break;
80102311:	90                   	nop
  }

  strncpy(de.name, name, DIRSIZ);
80102312:	83 ec 04             	sub    $0x4,%esp
80102315:	6a 0e                	push   $0xe
80102317:	ff 75 0c             	push   0xc(%ebp)
8010231a:	8d 45 e0             	lea    -0x20(%ebp),%eax
8010231d:	83 c0 02             	add    $0x2,%eax
80102320:	50                   	push   %eax
80102321:	e8 88 2a 00 00       	call   80104dae <strncpy>
80102326:	83 c4 10             	add    $0x10,%esp
  de.inum = inum;
80102329:	8b 45 10             	mov    0x10(%ebp),%eax
8010232c:	66 89 45 e0          	mov    %ax,-0x20(%ebp)
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80102330:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102333:	6a 10                	push   $0x10
80102335:	50                   	push   %eax
80102336:	8d 45 e0             	lea    -0x20(%ebp),%eax
80102339:	50                   	push   %eax
8010233a:	ff 75 08             	push   0x8(%ebp)
8010233d:	e8 e9 fc ff ff       	call   8010202b <writei>
80102342:	83 c4 10             	add    $0x10,%esp
80102345:	83 f8 10             	cmp    $0x10,%eax
80102348:	74 0d                	je     80102357 <dirlink+0xd1>
    panic("dirlink");
8010234a:	83 ec 0c             	sub    $0xc,%esp
8010234d:	68 4b a4 10 80       	push   $0x8010a44b
80102352:	e8 52 e2 ff ff       	call   801005a9 <panic>

  return 0;
80102357:	b8 00 00 00 00       	mov    $0x0,%eax
}
8010235c:	c9                   	leave  
8010235d:	c3                   	ret    

8010235e <skipelem>:
//   skipelem("a", name) = "", setting name = "a"
//   skipelem("", name) = skipelem("////", name) = 0
//
static char*
skipelem(char *path, char *name)
{
8010235e:	55                   	push   %ebp
8010235f:	89 e5                	mov    %esp,%ebp
80102361:	83 ec 18             	sub    $0x18,%esp
  char *s;
  int len;

  while(*path == '/')
80102364:	eb 04                	jmp    8010236a <skipelem+0xc>
    path++;
80102366:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  while(*path == '/')
8010236a:	8b 45 08             	mov    0x8(%ebp),%eax
8010236d:	0f b6 00             	movzbl (%eax),%eax
80102370:	3c 2f                	cmp    $0x2f,%al
80102372:	74 f2                	je     80102366 <skipelem+0x8>
  if(*path == 0)
80102374:	8b 45 08             	mov    0x8(%ebp),%eax
80102377:	0f b6 00             	movzbl (%eax),%eax
8010237a:	84 c0                	test   %al,%al
8010237c:	75 07                	jne    80102385 <skipelem+0x27>
    return 0;
8010237e:	b8 00 00 00 00       	mov    $0x0,%eax
80102383:	eb 77                	jmp    801023fc <skipelem+0x9e>
  s = path;
80102385:	8b 45 08             	mov    0x8(%ebp),%eax
80102388:	89 45 f4             	mov    %eax,-0xc(%ebp)
  while(*path != '/' && *path != 0)
8010238b:	eb 04                	jmp    80102391 <skipelem+0x33>
    path++;
8010238d:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  while(*path != '/' && *path != 0)
80102391:	8b 45 08             	mov    0x8(%ebp),%eax
80102394:	0f b6 00             	movzbl (%eax),%eax
80102397:	3c 2f                	cmp    $0x2f,%al
80102399:	74 0a                	je     801023a5 <skipelem+0x47>
8010239b:	8b 45 08             	mov    0x8(%ebp),%eax
8010239e:	0f b6 00             	movzbl (%eax),%eax
801023a1:	84 c0                	test   %al,%al
801023a3:	75 e8                	jne    8010238d <skipelem+0x2f>
  len = path - s;
801023a5:	8b 45 08             	mov    0x8(%ebp),%eax
801023a8:	2b 45 f4             	sub    -0xc(%ebp),%eax
801023ab:	89 45 f0             	mov    %eax,-0x10(%ebp)
  if(len >= DIRSIZ)
801023ae:	83 7d f0 0d          	cmpl   $0xd,-0x10(%ebp)
801023b2:	7e 15                	jle    801023c9 <skipelem+0x6b>
    memmove(name, s, DIRSIZ);
801023b4:	83 ec 04             	sub    $0x4,%esp
801023b7:	6a 0e                	push   $0xe
801023b9:	ff 75 f4             	push   -0xc(%ebp)
801023bc:	ff 75 0c             	push   0xc(%ebp)
801023bf:	e8 fe 28 00 00       	call   80104cc2 <memmove>
801023c4:	83 c4 10             	add    $0x10,%esp
801023c7:	eb 26                	jmp    801023ef <skipelem+0x91>
  else {
    memmove(name, s, len);
801023c9:	8b 45 f0             	mov    -0x10(%ebp),%eax
801023cc:	83 ec 04             	sub    $0x4,%esp
801023cf:	50                   	push   %eax
801023d0:	ff 75 f4             	push   -0xc(%ebp)
801023d3:	ff 75 0c             	push   0xc(%ebp)
801023d6:	e8 e7 28 00 00       	call   80104cc2 <memmove>
801023db:	83 c4 10             	add    $0x10,%esp
    name[len] = 0;
801023de:	8b 55 f0             	mov    -0x10(%ebp),%edx
801023e1:	8b 45 0c             	mov    0xc(%ebp),%eax
801023e4:	01 d0                	add    %edx,%eax
801023e6:	c6 00 00             	movb   $0x0,(%eax)
  }
  while(*path == '/')
801023e9:	eb 04                	jmp    801023ef <skipelem+0x91>
    path++;
801023eb:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  while(*path == '/')
801023ef:	8b 45 08             	mov    0x8(%ebp),%eax
801023f2:	0f b6 00             	movzbl (%eax),%eax
801023f5:	3c 2f                	cmp    $0x2f,%al
801023f7:	74 f2                	je     801023eb <skipelem+0x8d>
  return path;
801023f9:	8b 45 08             	mov    0x8(%ebp),%eax
}
801023fc:	c9                   	leave  
801023fd:	c3                   	ret    

801023fe <namex>:
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
// Must be called inside a transaction since it calls iput().
static struct inode*
namex(char *path, int nameiparent, char *name)
{
801023fe:	55                   	push   %ebp
801023ff:	89 e5                	mov    %esp,%ebp
80102401:	83 ec 18             	sub    $0x18,%esp
  struct inode *ip, *next;

  if(*path == '/')
80102404:	8b 45 08             	mov    0x8(%ebp),%eax
80102407:	0f b6 00             	movzbl (%eax),%eax
8010240a:	3c 2f                	cmp    $0x2f,%al
8010240c:	75 17                	jne    80102425 <namex+0x27>
    ip = iget(ROOTDEV, ROOTINO);
8010240e:	83 ec 08             	sub    $0x8,%esp
80102411:	6a 01                	push   $0x1
80102413:	6a 01                	push   $0x1
80102415:	e8 b4 f4 ff ff       	call   801018ce <iget>
8010241a:	83 c4 10             	add    $0x10,%esp
8010241d:	89 45 f4             	mov    %eax,-0xc(%ebp)
80102420:	e9 ba 00 00 00       	jmp    801024df <namex+0xe1>
  else
    ip = idup(myproc()->cwd);
80102425:	e8 06 16 00 00       	call   80103a30 <myproc>
8010242a:	8b 40 68             	mov    0x68(%eax),%eax
8010242d:	83 ec 0c             	sub    $0xc,%esp
80102430:	50                   	push   %eax
80102431:	e8 7a f5 ff ff       	call   801019b0 <idup>
80102436:	83 c4 10             	add    $0x10,%esp
80102439:	89 45 f4             	mov    %eax,-0xc(%ebp)

  while((path = skipelem(path, name)) != 0){
8010243c:	e9 9e 00 00 00       	jmp    801024df <namex+0xe1>
    ilock(ip);
80102441:	83 ec 0c             	sub    $0xc,%esp
80102444:	ff 75 f4             	push   -0xc(%ebp)
80102447:	e8 9e f5 ff ff       	call   801019ea <ilock>
8010244c:	83 c4 10             	add    $0x10,%esp
    if(ip->type != T_DIR){
8010244f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102452:	0f b7 40 50          	movzwl 0x50(%eax),%eax
80102456:	66 83 f8 01          	cmp    $0x1,%ax
8010245a:	74 18                	je     80102474 <namex+0x76>
      iunlockput(ip);
8010245c:	83 ec 0c             	sub    $0xc,%esp
8010245f:	ff 75 f4             	push   -0xc(%ebp)
80102462:	e8 b4 f7 ff ff       	call   80101c1b <iunlockput>
80102467:	83 c4 10             	add    $0x10,%esp
      return 0;
8010246a:	b8 00 00 00 00       	mov    $0x0,%eax
8010246f:	e9 a7 00 00 00       	jmp    8010251b <namex+0x11d>
    }
    if(nameiparent && *path == '\0'){
80102474:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
80102478:	74 20                	je     8010249a <namex+0x9c>
8010247a:	8b 45 08             	mov    0x8(%ebp),%eax
8010247d:	0f b6 00             	movzbl (%eax),%eax
80102480:	84 c0                	test   %al,%al
80102482:	75 16                	jne    8010249a <namex+0x9c>
      // Stop one level early.
      iunlock(ip);
80102484:	83 ec 0c             	sub    $0xc,%esp
80102487:	ff 75 f4             	push   -0xc(%ebp)
8010248a:	e8 6e f6 ff ff       	call   80101afd <iunlock>
8010248f:	83 c4 10             	add    $0x10,%esp
      return ip;
80102492:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102495:	e9 81 00 00 00       	jmp    8010251b <namex+0x11d>
    }
    if((next = dirlookup(ip, name, 0)) == 0){
8010249a:	83 ec 04             	sub    $0x4,%esp
8010249d:	6a 00                	push   $0x0
8010249f:	ff 75 10             	push   0x10(%ebp)
801024a2:	ff 75 f4             	push   -0xc(%ebp)
801024a5:	e8 22 fd ff ff       	call   801021cc <dirlookup>
801024aa:	83 c4 10             	add    $0x10,%esp
801024ad:	89 45 f0             	mov    %eax,-0x10(%ebp)
801024b0:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
801024b4:	75 15                	jne    801024cb <namex+0xcd>
      iunlockput(ip);
801024b6:	83 ec 0c             	sub    $0xc,%esp
801024b9:	ff 75 f4             	push   -0xc(%ebp)
801024bc:	e8 5a f7 ff ff       	call   80101c1b <iunlockput>
801024c1:	83 c4 10             	add    $0x10,%esp
      return 0;
801024c4:	b8 00 00 00 00       	mov    $0x0,%eax
801024c9:	eb 50                	jmp    8010251b <namex+0x11d>
    }
    iunlockput(ip);
801024cb:	83 ec 0c             	sub    $0xc,%esp
801024ce:	ff 75 f4             	push   -0xc(%ebp)
801024d1:	e8 45 f7 ff ff       	call   80101c1b <iunlockput>
801024d6:	83 c4 10             	add    $0x10,%esp
    ip = next;
801024d9:	8b 45 f0             	mov    -0x10(%ebp),%eax
801024dc:	89 45 f4             	mov    %eax,-0xc(%ebp)
  while((path = skipelem(path, name)) != 0){
801024df:	83 ec 08             	sub    $0x8,%esp
801024e2:	ff 75 10             	push   0x10(%ebp)
801024e5:	ff 75 08             	push   0x8(%ebp)
801024e8:	e8 71 fe ff ff       	call   8010235e <skipelem>
801024ed:	83 c4 10             	add    $0x10,%esp
801024f0:	89 45 08             	mov    %eax,0x8(%ebp)
801024f3:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
801024f7:	0f 85 44 ff ff ff    	jne    80102441 <namex+0x43>
  }
  if(nameiparent){
801024fd:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
80102501:	74 15                	je     80102518 <namex+0x11a>
    iput(ip);
80102503:	83 ec 0c             	sub    $0xc,%esp
80102506:	ff 75 f4             	push   -0xc(%ebp)
80102509:	e8 3d f6 ff ff       	call   80101b4b <iput>
8010250e:	83 c4 10             	add    $0x10,%esp
    return 0;
80102511:	b8 00 00 00 00       	mov    $0x0,%eax
80102516:	eb 03                	jmp    8010251b <namex+0x11d>
  }
  return ip;
80102518:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
8010251b:	c9                   	leave  
8010251c:	c3                   	ret    

8010251d <namei>:

struct inode*
namei(char *path)
{
8010251d:	55                   	push   %ebp
8010251e:	89 e5                	mov    %esp,%ebp
80102520:	83 ec 18             	sub    $0x18,%esp
  char name[DIRSIZ];
  return namex(path, 0, name);
80102523:	83 ec 04             	sub    $0x4,%esp
80102526:	8d 45 ea             	lea    -0x16(%ebp),%eax
80102529:	50                   	push   %eax
8010252a:	6a 00                	push   $0x0
8010252c:	ff 75 08             	push   0x8(%ebp)
8010252f:	e8 ca fe ff ff       	call   801023fe <namex>
80102534:	83 c4 10             	add    $0x10,%esp
}
80102537:	c9                   	leave  
80102538:	c3                   	ret    

80102539 <nameiparent>:

struct inode*
nameiparent(char *path, char *name)
{
80102539:	55                   	push   %ebp
8010253a:	89 e5                	mov    %esp,%ebp
8010253c:	83 ec 08             	sub    $0x8,%esp
  return namex(path, 1, name);
8010253f:	83 ec 04             	sub    $0x4,%esp
80102542:	ff 75 0c             	push   0xc(%ebp)
80102545:	6a 01                	push   $0x1
80102547:	ff 75 08             	push   0x8(%ebp)
8010254a:	e8 af fe ff ff       	call   801023fe <namex>
8010254f:	83 c4 10             	add    $0x10,%esp
}
80102552:	c9                   	leave  
80102553:	c3                   	ret    

80102554 <ioapicread>:
  uint data;
};

static uint
ioapicread(int reg)
{
80102554:	55                   	push   %ebp
80102555:	89 e5                	mov    %esp,%ebp
  ioapic->reg = reg;
80102557:	a1 b4 40 19 80       	mov    0x801940b4,%eax
8010255c:	8b 55 08             	mov    0x8(%ebp),%edx
8010255f:	89 10                	mov    %edx,(%eax)
  return ioapic->data;
80102561:	a1 b4 40 19 80       	mov    0x801940b4,%eax
80102566:	8b 40 10             	mov    0x10(%eax),%eax
}
80102569:	5d                   	pop    %ebp
8010256a:	c3                   	ret    

8010256b <ioapicwrite>:

static void
ioapicwrite(int reg, uint data)
{
8010256b:	55                   	push   %ebp
8010256c:	89 e5                	mov    %esp,%ebp
  ioapic->reg = reg;
8010256e:	a1 b4 40 19 80       	mov    0x801940b4,%eax
80102573:	8b 55 08             	mov    0x8(%ebp),%edx
80102576:	89 10                	mov    %edx,(%eax)
  ioapic->data = data;
80102578:	a1 b4 40 19 80       	mov    0x801940b4,%eax
8010257d:	8b 55 0c             	mov    0xc(%ebp),%edx
80102580:	89 50 10             	mov    %edx,0x10(%eax)
}
80102583:	90                   	nop
80102584:	5d                   	pop    %ebp
80102585:	c3                   	ret    

80102586 <ioapicinit>:

void
ioapicinit(void)
{
80102586:	55                   	push   %ebp
80102587:	89 e5                	mov    %esp,%ebp
80102589:	83 ec 18             	sub    $0x18,%esp
  int i, id, maxintr;

  ioapic = (volatile struct ioapic*)IOAPIC;
8010258c:	c7 05 b4 40 19 80 00 	movl   $0xfec00000,0x801940b4
80102593:	00 c0 fe 
  maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
80102596:	6a 01                	push   $0x1
80102598:	e8 b7 ff ff ff       	call   80102554 <ioapicread>
8010259d:	83 c4 04             	add    $0x4,%esp
801025a0:	c1 e8 10             	shr    $0x10,%eax
801025a3:	25 ff 00 00 00       	and    $0xff,%eax
801025a8:	89 45 f0             	mov    %eax,-0x10(%ebp)
  id = ioapicread(REG_ID) >> 24;
801025ab:	6a 00                	push   $0x0
801025ad:	e8 a2 ff ff ff       	call   80102554 <ioapicread>
801025b2:	83 c4 04             	add    $0x4,%esp
801025b5:	c1 e8 18             	shr    $0x18,%eax
801025b8:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if(id != ioapicid)
801025bb:	0f b6 05 44 6e 19 80 	movzbl 0x80196e44,%eax
801025c2:	0f b6 c0             	movzbl %al,%eax
801025c5:	39 45 ec             	cmp    %eax,-0x14(%ebp)
801025c8:	74 10                	je     801025da <ioapicinit+0x54>
    cprintf("ioapicinit: id isn't equal to ioapicid; not a MP\n");
801025ca:	83 ec 0c             	sub    $0xc,%esp
801025cd:	68 54 a4 10 80       	push   $0x8010a454
801025d2:	e8 1d de ff ff       	call   801003f4 <cprintf>
801025d7:	83 c4 10             	add    $0x10,%esp

  // Mark all interrupts edge-triggered, active high, disabled,
  // and not routed to any CPUs.
  for(i = 0; i <= maxintr; i++){
801025da:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
801025e1:	eb 3f                	jmp    80102622 <ioapicinit+0x9c>
    ioapicwrite(REG_TABLE+2*i, INT_DISABLED | (T_IRQ0 + i));
801025e3:	8b 45 f4             	mov    -0xc(%ebp),%eax
801025e6:	83 c0 20             	add    $0x20,%eax
801025e9:	0d 00 00 01 00       	or     $0x10000,%eax
801025ee:	89 c2                	mov    %eax,%edx
801025f0:	8b 45 f4             	mov    -0xc(%ebp),%eax
801025f3:	83 c0 08             	add    $0x8,%eax
801025f6:	01 c0                	add    %eax,%eax
801025f8:	83 ec 08             	sub    $0x8,%esp
801025fb:	52                   	push   %edx
801025fc:	50                   	push   %eax
801025fd:	e8 69 ff ff ff       	call   8010256b <ioapicwrite>
80102602:	83 c4 10             	add    $0x10,%esp
    ioapicwrite(REG_TABLE+2*i+1, 0);
80102605:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102608:	83 c0 08             	add    $0x8,%eax
8010260b:	01 c0                	add    %eax,%eax
8010260d:	83 c0 01             	add    $0x1,%eax
80102610:	83 ec 08             	sub    $0x8,%esp
80102613:	6a 00                	push   $0x0
80102615:	50                   	push   %eax
80102616:	e8 50 ff ff ff       	call   8010256b <ioapicwrite>
8010261b:	83 c4 10             	add    $0x10,%esp
  for(i = 0; i <= maxintr; i++){
8010261e:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80102622:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102625:	3b 45 f0             	cmp    -0x10(%ebp),%eax
80102628:	7e b9                	jle    801025e3 <ioapicinit+0x5d>
  }
}
8010262a:	90                   	nop
8010262b:	90                   	nop
8010262c:	c9                   	leave  
8010262d:	c3                   	ret    

8010262e <ioapicenable>:

void
ioapicenable(int irq, int cpunum)
{
8010262e:	55                   	push   %ebp
8010262f:	89 e5                	mov    %esp,%ebp
  // Mark interrupt edge-triggered, active high,
  // enabled, and routed to the given cpunum,
  // which happens to be that cpu's APIC ID.
  ioapicwrite(REG_TABLE+2*irq, T_IRQ0 + irq);
80102631:	8b 45 08             	mov    0x8(%ebp),%eax
80102634:	83 c0 20             	add    $0x20,%eax
80102637:	89 c2                	mov    %eax,%edx
80102639:	8b 45 08             	mov    0x8(%ebp),%eax
8010263c:	83 c0 08             	add    $0x8,%eax
8010263f:	01 c0                	add    %eax,%eax
80102641:	52                   	push   %edx
80102642:	50                   	push   %eax
80102643:	e8 23 ff ff ff       	call   8010256b <ioapicwrite>
80102648:	83 c4 08             	add    $0x8,%esp
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
8010264b:	8b 45 0c             	mov    0xc(%ebp),%eax
8010264e:	c1 e0 18             	shl    $0x18,%eax
80102651:	89 c2                	mov    %eax,%edx
80102653:	8b 45 08             	mov    0x8(%ebp),%eax
80102656:	83 c0 08             	add    $0x8,%eax
80102659:	01 c0                	add    %eax,%eax
8010265b:	83 c0 01             	add    $0x1,%eax
8010265e:	52                   	push   %edx
8010265f:	50                   	push   %eax
80102660:	e8 06 ff ff ff       	call   8010256b <ioapicwrite>
80102665:	83 c4 08             	add    $0x8,%esp
}
80102668:	90                   	nop
80102669:	c9                   	leave  
8010266a:	c3                   	ret    

8010266b <kinit1>:
// the pages mapped by entrypgdir on free list.
// 2. main() calls kinit2() with the rest of the physical pages
// after installing a full page table that maps them on all cores.
void
kinit1(void *vstart, void *vend)
{
8010266b:	55                   	push   %ebp
8010266c:	89 e5                	mov    %esp,%ebp
8010266e:	83 ec 08             	sub    $0x8,%esp
  initlock(&kmem.lock, "kmem");
80102671:	83 ec 08             	sub    $0x8,%esp
80102674:	68 86 a4 10 80       	push   $0x8010a486
80102679:	68 c0 40 19 80       	push   $0x801940c0
8010267e:	e8 e8 22 00 00       	call   8010496b <initlock>
80102683:	83 c4 10             	add    $0x10,%esp
  kmem.use_lock = 0;
80102686:	c7 05 f4 40 19 80 00 	movl   $0x0,0x801940f4
8010268d:	00 00 00 
  freerange(vstart, vend);
80102690:	83 ec 08             	sub    $0x8,%esp
80102693:	ff 75 0c             	push   0xc(%ebp)
80102696:	ff 75 08             	push   0x8(%ebp)
80102699:	e8 2a 00 00 00       	call   801026c8 <freerange>
8010269e:	83 c4 10             	add    $0x10,%esp
}
801026a1:	90                   	nop
801026a2:	c9                   	leave  
801026a3:	c3                   	ret    

801026a4 <kinit2>:

void
kinit2(void *vstart, void *vend)
{
801026a4:	55                   	push   %ebp
801026a5:	89 e5                	mov    %esp,%ebp
801026a7:	83 ec 08             	sub    $0x8,%esp
  freerange(vstart, vend);
801026aa:	83 ec 08             	sub    $0x8,%esp
801026ad:	ff 75 0c             	push   0xc(%ebp)
801026b0:	ff 75 08             	push   0x8(%ebp)
801026b3:	e8 10 00 00 00       	call   801026c8 <freerange>
801026b8:	83 c4 10             	add    $0x10,%esp
  kmem.use_lock = 1;
801026bb:	c7 05 f4 40 19 80 01 	movl   $0x1,0x801940f4
801026c2:	00 00 00 
}
801026c5:	90                   	nop
801026c6:	c9                   	leave  
801026c7:	c3                   	ret    

801026c8 <freerange>:

void
freerange(void *vstart, void *vend)
{
801026c8:	55                   	push   %ebp
801026c9:	89 e5                	mov    %esp,%ebp
801026cb:	83 ec 18             	sub    $0x18,%esp
  char *p;
  p = (char*)PGROUNDUP((uint)vstart);
801026ce:	8b 45 08             	mov    0x8(%ebp),%eax
801026d1:	05 ff 0f 00 00       	add    $0xfff,%eax
801026d6:	25 00 f0 ff ff       	and    $0xfffff000,%eax
801026db:	89 45 f4             	mov    %eax,-0xc(%ebp)
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801026de:	eb 15                	jmp    801026f5 <freerange+0x2d>
    kfree(p);
801026e0:	83 ec 0c             	sub    $0xc,%esp
801026e3:	ff 75 f4             	push   -0xc(%ebp)
801026e6:	e8 1b 00 00 00       	call   80102706 <kfree>
801026eb:	83 c4 10             	add    $0x10,%esp
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801026ee:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
801026f5:	8b 45 f4             	mov    -0xc(%ebp),%eax
801026f8:	05 00 10 00 00       	add    $0x1000,%eax
801026fd:	39 45 0c             	cmp    %eax,0xc(%ebp)
80102700:	73 de                	jae    801026e0 <freerange+0x18>
}
80102702:	90                   	nop
80102703:	90                   	nop
80102704:	c9                   	leave  
80102705:	c3                   	ret    

80102706 <kfree>:
// which normally should have been returned by a
// call to kalloc().  (The exception is when
// initializing the allocator; see kinit above.)
void
kfree(char *v)
{
80102706:	55                   	push   %ebp
80102707:	89 e5                	mov    %esp,%ebp
80102709:	83 ec 18             	sub    $0x18,%esp
  struct run *r;

  if((uint)v % PGSIZE || v < end || V2P(v) >= PHYSTOP)
8010270c:	8b 45 08             	mov    0x8(%ebp),%eax
8010270f:	25 ff 0f 00 00       	and    $0xfff,%eax
80102714:	85 c0                	test   %eax,%eax
80102716:	75 18                	jne    80102730 <kfree+0x2a>
80102718:	81 7d 08 00 90 19 80 	cmpl   $0x80199000,0x8(%ebp)
8010271f:	72 0f                	jb     80102730 <kfree+0x2a>
80102721:	8b 45 08             	mov    0x8(%ebp),%eax
80102724:	05 00 00 00 80       	add    $0x80000000,%eax
80102729:	3d ff ff ff 1f       	cmp    $0x1fffffff,%eax
8010272e:	76 0d                	jbe    8010273d <kfree+0x37>
    panic("kfree");
80102730:	83 ec 0c             	sub    $0xc,%esp
80102733:	68 8b a4 10 80       	push   $0x8010a48b
80102738:	e8 6c de ff ff       	call   801005a9 <panic>

  // Fill with junk to catch dangling refs.
  memset(v, 1, PGSIZE);
8010273d:	83 ec 04             	sub    $0x4,%esp
80102740:	68 00 10 00 00       	push   $0x1000
80102745:	6a 01                	push   $0x1
80102747:	ff 75 08             	push   0x8(%ebp)
8010274a:	e8 b4 24 00 00       	call   80104c03 <memset>
8010274f:	83 c4 10             	add    $0x10,%esp

  if(kmem.use_lock)
80102752:	a1 f4 40 19 80       	mov    0x801940f4,%eax
80102757:	85 c0                	test   %eax,%eax
80102759:	74 10                	je     8010276b <kfree+0x65>
    acquire(&kmem.lock);
8010275b:	83 ec 0c             	sub    $0xc,%esp
8010275e:	68 c0 40 19 80       	push   $0x801940c0
80102763:	e8 25 22 00 00       	call   8010498d <acquire>
80102768:	83 c4 10             	add    $0x10,%esp
  r = (struct run*)v;
8010276b:	8b 45 08             	mov    0x8(%ebp),%eax
8010276e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  r->next = kmem.freelist;
80102771:	8b 15 f8 40 19 80    	mov    0x801940f8,%edx
80102777:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010277a:	89 10                	mov    %edx,(%eax)
  kmem.freelist = r;
8010277c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010277f:	a3 f8 40 19 80       	mov    %eax,0x801940f8
  if(kmem.use_lock)
80102784:	a1 f4 40 19 80       	mov    0x801940f4,%eax
80102789:	85 c0                	test   %eax,%eax
8010278b:	74 10                	je     8010279d <kfree+0x97>
    release(&kmem.lock);
8010278d:	83 ec 0c             	sub    $0xc,%esp
80102790:	68 c0 40 19 80       	push   $0x801940c0
80102795:	e8 61 22 00 00       	call   801049fb <release>
8010279a:	83 c4 10             	add    $0x10,%esp
}
8010279d:	90                   	nop
8010279e:	c9                   	leave  
8010279f:	c3                   	ret    

801027a0 <kalloc>:
// Allocate one 4096-byte page of physical memory.
// Returns a pointer that the kernel can use.
// Returns 0 if the memory cannot be allocated.
char*
kalloc(void)
{
801027a0:	55                   	push   %ebp
801027a1:	89 e5                	mov    %esp,%ebp
801027a3:	83 ec 18             	sub    $0x18,%esp
  struct run *r;

  if(kmem.use_lock)
801027a6:	a1 f4 40 19 80       	mov    0x801940f4,%eax
801027ab:	85 c0                	test   %eax,%eax
801027ad:	74 10                	je     801027bf <kalloc+0x1f>
    acquire(&kmem.lock);
801027af:	83 ec 0c             	sub    $0xc,%esp
801027b2:	68 c0 40 19 80       	push   $0x801940c0
801027b7:	e8 d1 21 00 00       	call   8010498d <acquire>
801027bc:	83 c4 10             	add    $0x10,%esp
  r = kmem.freelist;
801027bf:	a1 f8 40 19 80       	mov    0x801940f8,%eax
801027c4:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(r)
801027c7:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801027cb:	74 0a                	je     801027d7 <kalloc+0x37>
    kmem.freelist = r->next;
801027cd:	8b 45 f4             	mov    -0xc(%ebp),%eax
801027d0:	8b 00                	mov    (%eax),%eax
801027d2:	a3 f8 40 19 80       	mov    %eax,0x801940f8
  if(kmem.use_lock)
801027d7:	a1 f4 40 19 80       	mov    0x801940f4,%eax
801027dc:	85 c0                	test   %eax,%eax
801027de:	74 10                	je     801027f0 <kalloc+0x50>
    release(&kmem.lock);
801027e0:	83 ec 0c             	sub    $0xc,%esp
801027e3:	68 c0 40 19 80       	push   $0x801940c0
801027e8:	e8 0e 22 00 00       	call   801049fb <release>
801027ed:	83 c4 10             	add    $0x10,%esp
  return (char*)r;
801027f0:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
801027f3:	c9                   	leave  
801027f4:	c3                   	ret    

801027f5 <inb>:
{
801027f5:	55                   	push   %ebp
801027f6:	89 e5                	mov    %esp,%ebp
801027f8:	83 ec 14             	sub    $0x14,%esp
801027fb:	8b 45 08             	mov    0x8(%ebp),%eax
801027fe:	66 89 45 ec          	mov    %ax,-0x14(%ebp)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102802:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
80102806:	89 c2                	mov    %eax,%edx
80102808:	ec                   	in     (%dx),%al
80102809:	88 45 ff             	mov    %al,-0x1(%ebp)
  return data;
8010280c:	0f b6 45 ff          	movzbl -0x1(%ebp),%eax
}
80102810:	c9                   	leave  
80102811:	c3                   	ret    

80102812 <kbdgetc>:
#include "defs.h"
#include "kbd.h"

int
kbdgetc(void)
{
80102812:	55                   	push   %ebp
80102813:	89 e5                	mov    %esp,%ebp
80102815:	83 ec 10             	sub    $0x10,%esp
  static uchar *charcode[4] = {
    normalmap, shiftmap, ctlmap, ctlmap
  };
  uint st, data, c;

  st = inb(KBSTATP);
80102818:	6a 64                	push   $0x64
8010281a:	e8 d6 ff ff ff       	call   801027f5 <inb>
8010281f:	83 c4 04             	add    $0x4,%esp
80102822:	0f b6 c0             	movzbl %al,%eax
80102825:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if((st & KBS_DIB) == 0)
80102828:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010282b:	83 e0 01             	and    $0x1,%eax
8010282e:	85 c0                	test   %eax,%eax
80102830:	75 0a                	jne    8010283c <kbdgetc+0x2a>
    return -1;
80102832:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80102837:	e9 23 01 00 00       	jmp    8010295f <kbdgetc+0x14d>
  data = inb(KBDATAP);
8010283c:	6a 60                	push   $0x60
8010283e:	e8 b2 ff ff ff       	call   801027f5 <inb>
80102843:	83 c4 04             	add    $0x4,%esp
80102846:	0f b6 c0             	movzbl %al,%eax
80102849:	89 45 fc             	mov    %eax,-0x4(%ebp)

  if(data == 0xE0){
8010284c:	81 7d fc e0 00 00 00 	cmpl   $0xe0,-0x4(%ebp)
80102853:	75 17                	jne    8010286c <kbdgetc+0x5a>
    shift |= E0ESC;
80102855:	a1 fc 40 19 80       	mov    0x801940fc,%eax
8010285a:	83 c8 40             	or     $0x40,%eax
8010285d:	a3 fc 40 19 80       	mov    %eax,0x801940fc
    return 0;
80102862:	b8 00 00 00 00       	mov    $0x0,%eax
80102867:	e9 f3 00 00 00       	jmp    8010295f <kbdgetc+0x14d>
  } else if(data & 0x80){
8010286c:	8b 45 fc             	mov    -0x4(%ebp),%eax
8010286f:	25 80 00 00 00       	and    $0x80,%eax
80102874:	85 c0                	test   %eax,%eax
80102876:	74 45                	je     801028bd <kbdgetc+0xab>
    // Key released
    data = (shift & E0ESC ? data : data & 0x7F);
80102878:	a1 fc 40 19 80       	mov    0x801940fc,%eax
8010287d:	83 e0 40             	and    $0x40,%eax
80102880:	85 c0                	test   %eax,%eax
80102882:	75 08                	jne    8010288c <kbdgetc+0x7a>
80102884:	8b 45 fc             	mov    -0x4(%ebp),%eax
80102887:	83 e0 7f             	and    $0x7f,%eax
8010288a:	eb 03                	jmp    8010288f <kbdgetc+0x7d>
8010288c:	8b 45 fc             	mov    -0x4(%ebp),%eax
8010288f:	89 45 fc             	mov    %eax,-0x4(%ebp)
    shift &= ~(shiftcode[data] | E0ESC);
80102892:	8b 45 fc             	mov    -0x4(%ebp),%eax
80102895:	05 20 d0 10 80       	add    $0x8010d020,%eax
8010289a:	0f b6 00             	movzbl (%eax),%eax
8010289d:	83 c8 40             	or     $0x40,%eax
801028a0:	0f b6 c0             	movzbl %al,%eax
801028a3:	f7 d0                	not    %eax
801028a5:	89 c2                	mov    %eax,%edx
801028a7:	a1 fc 40 19 80       	mov    0x801940fc,%eax
801028ac:	21 d0                	and    %edx,%eax
801028ae:	a3 fc 40 19 80       	mov    %eax,0x801940fc
    return 0;
801028b3:	b8 00 00 00 00       	mov    $0x0,%eax
801028b8:	e9 a2 00 00 00       	jmp    8010295f <kbdgetc+0x14d>
  } else if(shift & E0ESC){
801028bd:	a1 fc 40 19 80       	mov    0x801940fc,%eax
801028c2:	83 e0 40             	and    $0x40,%eax
801028c5:	85 c0                	test   %eax,%eax
801028c7:	74 14                	je     801028dd <kbdgetc+0xcb>
    // Last character was an E0 escape; or with 0x80
    data |= 0x80;
801028c9:	81 4d fc 80 00 00 00 	orl    $0x80,-0x4(%ebp)
    shift &= ~E0ESC;
801028d0:	a1 fc 40 19 80       	mov    0x801940fc,%eax
801028d5:	83 e0 bf             	and    $0xffffffbf,%eax
801028d8:	a3 fc 40 19 80       	mov    %eax,0x801940fc
  }

  shift |= shiftcode[data];
801028dd:	8b 45 fc             	mov    -0x4(%ebp),%eax
801028e0:	05 20 d0 10 80       	add    $0x8010d020,%eax
801028e5:	0f b6 00             	movzbl (%eax),%eax
801028e8:	0f b6 d0             	movzbl %al,%edx
801028eb:	a1 fc 40 19 80       	mov    0x801940fc,%eax
801028f0:	09 d0                	or     %edx,%eax
801028f2:	a3 fc 40 19 80       	mov    %eax,0x801940fc
  shift ^= togglecode[data];
801028f7:	8b 45 fc             	mov    -0x4(%ebp),%eax
801028fa:	05 20 d1 10 80       	add    $0x8010d120,%eax
801028ff:	0f b6 00             	movzbl (%eax),%eax
80102902:	0f b6 d0             	movzbl %al,%edx
80102905:	a1 fc 40 19 80       	mov    0x801940fc,%eax
8010290a:	31 d0                	xor    %edx,%eax
8010290c:	a3 fc 40 19 80       	mov    %eax,0x801940fc
  c = charcode[shift & (CTL | SHIFT)][data];
80102911:	a1 fc 40 19 80       	mov    0x801940fc,%eax
80102916:	83 e0 03             	and    $0x3,%eax
80102919:	8b 14 85 20 d5 10 80 	mov    -0x7fef2ae0(,%eax,4),%edx
80102920:	8b 45 fc             	mov    -0x4(%ebp),%eax
80102923:	01 d0                	add    %edx,%eax
80102925:	0f b6 00             	movzbl (%eax),%eax
80102928:	0f b6 c0             	movzbl %al,%eax
8010292b:	89 45 f8             	mov    %eax,-0x8(%ebp)
  if(shift & CAPSLOCK){
8010292e:	a1 fc 40 19 80       	mov    0x801940fc,%eax
80102933:	83 e0 08             	and    $0x8,%eax
80102936:	85 c0                	test   %eax,%eax
80102938:	74 22                	je     8010295c <kbdgetc+0x14a>
    if('a' <= c && c <= 'z')
8010293a:	83 7d f8 60          	cmpl   $0x60,-0x8(%ebp)
8010293e:	76 0c                	jbe    8010294c <kbdgetc+0x13a>
80102940:	83 7d f8 7a          	cmpl   $0x7a,-0x8(%ebp)
80102944:	77 06                	ja     8010294c <kbdgetc+0x13a>
      c += 'A' - 'a';
80102946:	83 6d f8 20          	subl   $0x20,-0x8(%ebp)
8010294a:	eb 10                	jmp    8010295c <kbdgetc+0x14a>
    else if('A' <= c && c <= 'Z')
8010294c:	83 7d f8 40          	cmpl   $0x40,-0x8(%ebp)
80102950:	76 0a                	jbe    8010295c <kbdgetc+0x14a>
80102952:	83 7d f8 5a          	cmpl   $0x5a,-0x8(%ebp)
80102956:	77 04                	ja     8010295c <kbdgetc+0x14a>
      c += 'a' - 'A';
80102958:	83 45 f8 20          	addl   $0x20,-0x8(%ebp)
  }
  return c;
8010295c:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
8010295f:	c9                   	leave  
80102960:	c3                   	ret    

80102961 <kbdintr>:

void
kbdintr(void)
{
80102961:	55                   	push   %ebp
80102962:	89 e5                	mov    %esp,%ebp
80102964:	83 ec 08             	sub    $0x8,%esp
  consoleintr(kbdgetc);
80102967:	83 ec 0c             	sub    $0xc,%esp
8010296a:	68 12 28 10 80       	push   $0x80102812
8010296f:	e8 62 de ff ff       	call   801007d6 <consoleintr>
80102974:	83 c4 10             	add    $0x10,%esp
}
80102977:	90                   	nop
80102978:	c9                   	leave  
80102979:	c3                   	ret    

8010297a <inb>:
{
8010297a:	55                   	push   %ebp
8010297b:	89 e5                	mov    %esp,%ebp
8010297d:	83 ec 14             	sub    $0x14,%esp
80102980:	8b 45 08             	mov    0x8(%ebp),%eax
80102983:	66 89 45 ec          	mov    %ax,-0x14(%ebp)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102987:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
8010298b:	89 c2                	mov    %eax,%edx
8010298d:	ec                   	in     (%dx),%al
8010298e:	88 45 ff             	mov    %al,-0x1(%ebp)
  return data;
80102991:	0f b6 45 ff          	movzbl -0x1(%ebp),%eax
}
80102995:	c9                   	leave  
80102996:	c3                   	ret    

80102997 <outb>:
{
80102997:	55                   	push   %ebp
80102998:	89 e5                	mov    %esp,%ebp
8010299a:	83 ec 08             	sub    $0x8,%esp
8010299d:	8b 45 08             	mov    0x8(%ebp),%eax
801029a0:	8b 55 0c             	mov    0xc(%ebp),%edx
801029a3:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
801029a7:	89 d0                	mov    %edx,%eax
801029a9:	88 45 f8             	mov    %al,-0x8(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801029ac:	0f b6 45 f8          	movzbl -0x8(%ebp),%eax
801029b0:	0f b7 55 fc          	movzwl -0x4(%ebp),%edx
801029b4:	ee                   	out    %al,(%dx)
}
801029b5:	90                   	nop
801029b6:	c9                   	leave  
801029b7:	c3                   	ret    

801029b8 <lapicw>:
volatile uint *lapic;  // Initialized in mp.c

//PAGEBREAK!
static void
lapicw(int index, int value)
{
801029b8:	55                   	push   %ebp
801029b9:	89 e5                	mov    %esp,%ebp
  lapic[index] = value;
801029bb:	8b 15 00 41 19 80    	mov    0x80194100,%edx
801029c1:	8b 45 08             	mov    0x8(%ebp),%eax
801029c4:	c1 e0 02             	shl    $0x2,%eax
801029c7:	01 c2                	add    %eax,%edx
801029c9:	8b 45 0c             	mov    0xc(%ebp),%eax
801029cc:	89 02                	mov    %eax,(%edx)
  lapic[ID];  // wait for write to finish, by reading
801029ce:	a1 00 41 19 80       	mov    0x80194100,%eax
801029d3:	83 c0 20             	add    $0x20,%eax
801029d6:	8b 00                	mov    (%eax),%eax
}
801029d8:	90                   	nop
801029d9:	5d                   	pop    %ebp
801029da:	c3                   	ret    

801029db <lapicinit>:

void
lapicinit(void)
{
801029db:	55                   	push   %ebp
801029dc:	89 e5                	mov    %esp,%ebp
  if(!lapic)
801029de:	a1 00 41 19 80       	mov    0x80194100,%eax
801029e3:	85 c0                	test   %eax,%eax
801029e5:	0f 84 0c 01 00 00    	je     80102af7 <lapicinit+0x11c>
    return;

  // Enable local APIC; set spurious interrupt vector.
  lapicw(SVR, ENABLE | (T_IRQ0 + IRQ_SPURIOUS));
801029eb:	68 3f 01 00 00       	push   $0x13f
801029f0:	6a 3c                	push   $0x3c
801029f2:	e8 c1 ff ff ff       	call   801029b8 <lapicw>
801029f7:	83 c4 08             	add    $0x8,%esp

  // The timer repeatedly counts down at bus frequency
  // from lapic[TICR] and then issues an interrupt.
  // If xv6 cared more about precise timekeeping,
  // TICR would be calibrated using an external time source.
  lapicw(TDCR, X1);
801029fa:	6a 0b                	push   $0xb
801029fc:	68 f8 00 00 00       	push   $0xf8
80102a01:	e8 b2 ff ff ff       	call   801029b8 <lapicw>
80102a06:	83 c4 08             	add    $0x8,%esp
  lapicw(TIMER, PERIODIC | (T_IRQ0 + IRQ_TIMER));
80102a09:	68 20 00 02 00       	push   $0x20020
80102a0e:	68 c8 00 00 00       	push   $0xc8
80102a13:	e8 a0 ff ff ff       	call   801029b8 <lapicw>
80102a18:	83 c4 08             	add    $0x8,%esp
  lapicw(TICR, 10000000);
80102a1b:	68 80 96 98 00       	push   $0x989680
80102a20:	68 e0 00 00 00       	push   $0xe0
80102a25:	e8 8e ff ff ff       	call   801029b8 <lapicw>
80102a2a:	83 c4 08             	add    $0x8,%esp

  // Disable logical interrupt lines.
  lapicw(LINT0, MASKED);
80102a2d:	68 00 00 01 00       	push   $0x10000
80102a32:	68 d4 00 00 00       	push   $0xd4
80102a37:	e8 7c ff ff ff       	call   801029b8 <lapicw>
80102a3c:	83 c4 08             	add    $0x8,%esp
  lapicw(LINT1, MASKED);
80102a3f:	68 00 00 01 00       	push   $0x10000
80102a44:	68 d8 00 00 00       	push   $0xd8
80102a49:	e8 6a ff ff ff       	call   801029b8 <lapicw>
80102a4e:	83 c4 08             	add    $0x8,%esp

  // Disable performance counter overflow interrupts
  // on machines that provide that interrupt entry.
  if(((lapic[VER]>>16) & 0xFF) >= 4)
80102a51:	a1 00 41 19 80       	mov    0x80194100,%eax
80102a56:	83 c0 30             	add    $0x30,%eax
80102a59:	8b 00                	mov    (%eax),%eax
80102a5b:	c1 e8 10             	shr    $0x10,%eax
80102a5e:	25 fc 00 00 00       	and    $0xfc,%eax
80102a63:	85 c0                	test   %eax,%eax
80102a65:	74 12                	je     80102a79 <lapicinit+0x9e>
    lapicw(PCINT, MASKED);
80102a67:	68 00 00 01 00       	push   $0x10000
80102a6c:	68 d0 00 00 00       	push   $0xd0
80102a71:	e8 42 ff ff ff       	call   801029b8 <lapicw>
80102a76:	83 c4 08             	add    $0x8,%esp

  // Map error interrupt to IRQ_ERROR.
  lapicw(ERROR, T_IRQ0 + IRQ_ERROR);
80102a79:	6a 33                	push   $0x33
80102a7b:	68 dc 00 00 00       	push   $0xdc
80102a80:	e8 33 ff ff ff       	call   801029b8 <lapicw>
80102a85:	83 c4 08             	add    $0x8,%esp

  // Clear error status register (requires back-to-back writes).
  lapicw(ESR, 0);
80102a88:	6a 00                	push   $0x0
80102a8a:	68 a0 00 00 00       	push   $0xa0
80102a8f:	e8 24 ff ff ff       	call   801029b8 <lapicw>
80102a94:	83 c4 08             	add    $0x8,%esp
  lapicw(ESR, 0);
80102a97:	6a 00                	push   $0x0
80102a99:	68 a0 00 00 00       	push   $0xa0
80102a9e:	e8 15 ff ff ff       	call   801029b8 <lapicw>
80102aa3:	83 c4 08             	add    $0x8,%esp

  // Ack any outstanding interrupts.
  lapicw(EOI, 0);
80102aa6:	6a 00                	push   $0x0
80102aa8:	6a 2c                	push   $0x2c
80102aaa:	e8 09 ff ff ff       	call   801029b8 <lapicw>
80102aaf:	83 c4 08             	add    $0x8,%esp

  // Send an Init Level De-Assert to synchronise arbitration ID's.
  lapicw(ICRHI, 0);
80102ab2:	6a 00                	push   $0x0
80102ab4:	68 c4 00 00 00       	push   $0xc4
80102ab9:	e8 fa fe ff ff       	call   801029b8 <lapicw>
80102abe:	83 c4 08             	add    $0x8,%esp
  lapicw(ICRLO, BCAST | INIT | LEVEL);
80102ac1:	68 00 85 08 00       	push   $0x88500
80102ac6:	68 c0 00 00 00       	push   $0xc0
80102acb:	e8 e8 fe ff ff       	call   801029b8 <lapicw>
80102ad0:	83 c4 08             	add    $0x8,%esp
  while(lapic[ICRLO] & DELIVS)
80102ad3:	90                   	nop
80102ad4:	a1 00 41 19 80       	mov    0x80194100,%eax
80102ad9:	05 00 03 00 00       	add    $0x300,%eax
80102ade:	8b 00                	mov    (%eax),%eax
80102ae0:	25 00 10 00 00       	and    $0x1000,%eax
80102ae5:	85 c0                	test   %eax,%eax
80102ae7:	75 eb                	jne    80102ad4 <lapicinit+0xf9>
    ;

  // Enable interrupts on the APIC (but not on the processor).
  lapicw(TPR, 0);
80102ae9:	6a 00                	push   $0x0
80102aeb:	6a 20                	push   $0x20
80102aed:	e8 c6 fe ff ff       	call   801029b8 <lapicw>
80102af2:	83 c4 08             	add    $0x8,%esp
80102af5:	eb 01                	jmp    80102af8 <lapicinit+0x11d>
    return;
80102af7:	90                   	nop
}
80102af8:	c9                   	leave  
80102af9:	c3                   	ret    

80102afa <lapicid>:

int
lapicid(void)
{
80102afa:	55                   	push   %ebp
80102afb:	89 e5                	mov    %esp,%ebp

  if (!lapic){
80102afd:	a1 00 41 19 80       	mov    0x80194100,%eax
80102b02:	85 c0                	test   %eax,%eax
80102b04:	75 07                	jne    80102b0d <lapicid+0x13>
    return 0;
80102b06:	b8 00 00 00 00       	mov    $0x0,%eax
80102b0b:	eb 0d                	jmp    80102b1a <lapicid+0x20>
  }
  return lapic[ID] >> 24;
80102b0d:	a1 00 41 19 80       	mov    0x80194100,%eax
80102b12:	83 c0 20             	add    $0x20,%eax
80102b15:	8b 00                	mov    (%eax),%eax
80102b17:	c1 e8 18             	shr    $0x18,%eax
}
80102b1a:	5d                   	pop    %ebp
80102b1b:	c3                   	ret    

80102b1c <lapiceoi>:

// Acknowledge interrupt.
void
lapiceoi(void)
{
80102b1c:	55                   	push   %ebp
80102b1d:	89 e5                	mov    %esp,%ebp
  if(lapic)
80102b1f:	a1 00 41 19 80       	mov    0x80194100,%eax
80102b24:	85 c0                	test   %eax,%eax
80102b26:	74 0c                	je     80102b34 <lapiceoi+0x18>
    lapicw(EOI, 0);
80102b28:	6a 00                	push   $0x0
80102b2a:	6a 2c                	push   $0x2c
80102b2c:	e8 87 fe ff ff       	call   801029b8 <lapicw>
80102b31:	83 c4 08             	add    $0x8,%esp
}
80102b34:	90                   	nop
80102b35:	c9                   	leave  
80102b36:	c3                   	ret    

80102b37 <microdelay>:

// Spin for a given number of microseconds.
// On real hardware would want to tune this dynamically.
void
microdelay(int us)
{
80102b37:	55                   	push   %ebp
80102b38:	89 e5                	mov    %esp,%ebp
}
80102b3a:	90                   	nop
80102b3b:	5d                   	pop    %ebp
80102b3c:	c3                   	ret    

80102b3d <lapicstartap>:

// Start additional processor running entry code at addr.
// See Appendix B of MultiProcessor Specification.
void
lapicstartap(uchar apicid, uint addr)
{
80102b3d:	55                   	push   %ebp
80102b3e:	89 e5                	mov    %esp,%ebp
80102b40:	83 ec 14             	sub    $0x14,%esp
80102b43:	8b 45 08             	mov    0x8(%ebp),%eax
80102b46:	88 45 ec             	mov    %al,-0x14(%ebp)
  ushort *wrv;

  // "The BSP must initialize CMOS shutdown code to 0AH
  // and the warm reset vector (DWORD based at 40:67) to point at
  // the AP startup code prior to the [universal startup algorithm]."
  outb(CMOS_PORT, 0xF);  // offset 0xF is shutdown code
80102b49:	6a 0f                	push   $0xf
80102b4b:	6a 70                	push   $0x70
80102b4d:	e8 45 fe ff ff       	call   80102997 <outb>
80102b52:	83 c4 08             	add    $0x8,%esp
  outb(CMOS_PORT+1, 0x0A);
80102b55:	6a 0a                	push   $0xa
80102b57:	6a 71                	push   $0x71
80102b59:	e8 39 fe ff ff       	call   80102997 <outb>
80102b5e:	83 c4 08             	add    $0x8,%esp
  wrv = (ushort*)P2V((0x40<<4 | 0x67));  // Warm reset vector
80102b61:	c7 45 f8 67 04 00 80 	movl   $0x80000467,-0x8(%ebp)
  wrv[0] = 0;
80102b68:	8b 45 f8             	mov    -0x8(%ebp),%eax
80102b6b:	66 c7 00 00 00       	movw   $0x0,(%eax)
  wrv[1] = addr >> 4;
80102b70:	8b 45 0c             	mov    0xc(%ebp),%eax
80102b73:	c1 e8 04             	shr    $0x4,%eax
80102b76:	89 c2                	mov    %eax,%edx
80102b78:	8b 45 f8             	mov    -0x8(%ebp),%eax
80102b7b:	83 c0 02             	add    $0x2,%eax
80102b7e:	66 89 10             	mov    %dx,(%eax)

  // "Universal startup algorithm."
  // Send INIT (level-triggered) interrupt to reset other CPU.
  lapicw(ICRHI, apicid<<24);
80102b81:	0f b6 45 ec          	movzbl -0x14(%ebp),%eax
80102b85:	c1 e0 18             	shl    $0x18,%eax
80102b88:	50                   	push   %eax
80102b89:	68 c4 00 00 00       	push   $0xc4
80102b8e:	e8 25 fe ff ff       	call   801029b8 <lapicw>
80102b93:	83 c4 08             	add    $0x8,%esp
  lapicw(ICRLO, INIT | LEVEL | ASSERT);
80102b96:	68 00 c5 00 00       	push   $0xc500
80102b9b:	68 c0 00 00 00       	push   $0xc0
80102ba0:	e8 13 fe ff ff       	call   801029b8 <lapicw>
80102ba5:	83 c4 08             	add    $0x8,%esp
  microdelay(200);
80102ba8:	68 c8 00 00 00       	push   $0xc8
80102bad:	e8 85 ff ff ff       	call   80102b37 <microdelay>
80102bb2:	83 c4 04             	add    $0x4,%esp
  lapicw(ICRLO, INIT | LEVEL);
80102bb5:	68 00 85 00 00       	push   $0x8500
80102bba:	68 c0 00 00 00       	push   $0xc0
80102bbf:	e8 f4 fd ff ff       	call   801029b8 <lapicw>
80102bc4:	83 c4 08             	add    $0x8,%esp
  microdelay(100);    // should be 10ms, but too slow in Bochs!
80102bc7:	6a 64                	push   $0x64
80102bc9:	e8 69 ff ff ff       	call   80102b37 <microdelay>
80102bce:	83 c4 04             	add    $0x4,%esp
  // Send startup IPI (twice!) to enter code.
  // Regular hardware is supposed to only accept a STARTUP
  // when it is in the halted state due to an INIT.  So the second
  // should be ignored, but it is part of the official Intel algorithm.
  // Bochs complains about the second one.  Too bad for Bochs.
  for(i = 0; i < 2; i++){
80102bd1:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
80102bd8:	eb 3d                	jmp    80102c17 <lapicstartap+0xda>
    lapicw(ICRHI, apicid<<24);
80102bda:	0f b6 45 ec          	movzbl -0x14(%ebp),%eax
80102bde:	c1 e0 18             	shl    $0x18,%eax
80102be1:	50                   	push   %eax
80102be2:	68 c4 00 00 00       	push   $0xc4
80102be7:	e8 cc fd ff ff       	call   801029b8 <lapicw>
80102bec:	83 c4 08             	add    $0x8,%esp
    lapicw(ICRLO, STARTUP | (addr>>12));
80102bef:	8b 45 0c             	mov    0xc(%ebp),%eax
80102bf2:	c1 e8 0c             	shr    $0xc,%eax
80102bf5:	80 cc 06             	or     $0x6,%ah
80102bf8:	50                   	push   %eax
80102bf9:	68 c0 00 00 00       	push   $0xc0
80102bfe:	e8 b5 fd ff ff       	call   801029b8 <lapicw>
80102c03:	83 c4 08             	add    $0x8,%esp
    microdelay(200);
80102c06:	68 c8 00 00 00       	push   $0xc8
80102c0b:	e8 27 ff ff ff       	call   80102b37 <microdelay>
80102c10:	83 c4 04             	add    $0x4,%esp
  for(i = 0; i < 2; i++){
80102c13:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
80102c17:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
80102c1b:	7e bd                	jle    80102bda <lapicstartap+0x9d>
  }
}
80102c1d:	90                   	nop
80102c1e:	90                   	nop
80102c1f:	c9                   	leave  
80102c20:	c3                   	ret    

80102c21 <cmos_read>:
#define DAY     0x07
#define MONTH   0x08
#define YEAR    0x09

static uint cmos_read(uint reg)
{
80102c21:	55                   	push   %ebp
80102c22:	89 e5                	mov    %esp,%ebp
  outb(CMOS_PORT,  reg);
80102c24:	8b 45 08             	mov    0x8(%ebp),%eax
80102c27:	0f b6 c0             	movzbl %al,%eax
80102c2a:	50                   	push   %eax
80102c2b:	6a 70                	push   $0x70
80102c2d:	e8 65 fd ff ff       	call   80102997 <outb>
80102c32:	83 c4 08             	add    $0x8,%esp
  microdelay(200);
80102c35:	68 c8 00 00 00       	push   $0xc8
80102c3a:	e8 f8 fe ff ff       	call   80102b37 <microdelay>
80102c3f:	83 c4 04             	add    $0x4,%esp

  return inb(CMOS_RETURN);
80102c42:	6a 71                	push   $0x71
80102c44:	e8 31 fd ff ff       	call   8010297a <inb>
80102c49:	83 c4 04             	add    $0x4,%esp
80102c4c:	0f b6 c0             	movzbl %al,%eax
}
80102c4f:	c9                   	leave  
80102c50:	c3                   	ret    

80102c51 <fill_rtcdate>:

static void fill_rtcdate(struct rtcdate *r)
{
80102c51:	55                   	push   %ebp
80102c52:	89 e5                	mov    %esp,%ebp
  r->second = cmos_read(SECS);
80102c54:	6a 00                	push   $0x0
80102c56:	e8 c6 ff ff ff       	call   80102c21 <cmos_read>
80102c5b:	83 c4 04             	add    $0x4,%esp
80102c5e:	8b 55 08             	mov    0x8(%ebp),%edx
80102c61:	89 02                	mov    %eax,(%edx)
  r->minute = cmos_read(MINS);
80102c63:	6a 02                	push   $0x2
80102c65:	e8 b7 ff ff ff       	call   80102c21 <cmos_read>
80102c6a:	83 c4 04             	add    $0x4,%esp
80102c6d:	8b 55 08             	mov    0x8(%ebp),%edx
80102c70:	89 42 04             	mov    %eax,0x4(%edx)
  r->hour   = cmos_read(HOURS);
80102c73:	6a 04                	push   $0x4
80102c75:	e8 a7 ff ff ff       	call   80102c21 <cmos_read>
80102c7a:	83 c4 04             	add    $0x4,%esp
80102c7d:	8b 55 08             	mov    0x8(%ebp),%edx
80102c80:	89 42 08             	mov    %eax,0x8(%edx)
  r->day    = cmos_read(DAY);
80102c83:	6a 07                	push   $0x7
80102c85:	e8 97 ff ff ff       	call   80102c21 <cmos_read>
80102c8a:	83 c4 04             	add    $0x4,%esp
80102c8d:	8b 55 08             	mov    0x8(%ebp),%edx
80102c90:	89 42 0c             	mov    %eax,0xc(%edx)
  r->month  = cmos_read(MONTH);
80102c93:	6a 08                	push   $0x8
80102c95:	e8 87 ff ff ff       	call   80102c21 <cmos_read>
80102c9a:	83 c4 04             	add    $0x4,%esp
80102c9d:	8b 55 08             	mov    0x8(%ebp),%edx
80102ca0:	89 42 10             	mov    %eax,0x10(%edx)
  r->year   = cmos_read(YEAR);
80102ca3:	6a 09                	push   $0x9
80102ca5:	e8 77 ff ff ff       	call   80102c21 <cmos_read>
80102caa:	83 c4 04             	add    $0x4,%esp
80102cad:	8b 55 08             	mov    0x8(%ebp),%edx
80102cb0:	89 42 14             	mov    %eax,0x14(%edx)
}
80102cb3:	90                   	nop
80102cb4:	c9                   	leave  
80102cb5:	c3                   	ret    

80102cb6 <cmostime>:

// qemu seems to use 24-hour GWT and the values are BCD encoded
void cmostime(struct rtcdate *r)
{
80102cb6:	55                   	push   %ebp
80102cb7:	89 e5                	mov    %esp,%ebp
80102cb9:	83 ec 48             	sub    $0x48,%esp
  struct rtcdate t1, t2;
  int sb, bcd;

  sb = cmos_read(CMOS_STATB);
80102cbc:	6a 0b                	push   $0xb
80102cbe:	e8 5e ff ff ff       	call   80102c21 <cmos_read>
80102cc3:	83 c4 04             	add    $0x4,%esp
80102cc6:	89 45 f4             	mov    %eax,-0xc(%ebp)

  bcd = (sb & (1 << 2)) == 0;
80102cc9:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102ccc:	83 e0 04             	and    $0x4,%eax
80102ccf:	85 c0                	test   %eax,%eax
80102cd1:	0f 94 c0             	sete   %al
80102cd4:	0f b6 c0             	movzbl %al,%eax
80102cd7:	89 45 f0             	mov    %eax,-0x10(%ebp)

  // make sure CMOS doesn't modify time while we read it
  for(;;) {
    fill_rtcdate(&t1);
80102cda:	8d 45 d8             	lea    -0x28(%ebp),%eax
80102cdd:	50                   	push   %eax
80102cde:	e8 6e ff ff ff       	call   80102c51 <fill_rtcdate>
80102ce3:	83 c4 04             	add    $0x4,%esp
    if(cmos_read(CMOS_STATA) & CMOS_UIP)
80102ce6:	6a 0a                	push   $0xa
80102ce8:	e8 34 ff ff ff       	call   80102c21 <cmos_read>
80102ced:	83 c4 04             	add    $0x4,%esp
80102cf0:	25 80 00 00 00       	and    $0x80,%eax
80102cf5:	85 c0                	test   %eax,%eax
80102cf7:	75 27                	jne    80102d20 <cmostime+0x6a>
        continue;
    fill_rtcdate(&t2);
80102cf9:	8d 45 c0             	lea    -0x40(%ebp),%eax
80102cfc:	50                   	push   %eax
80102cfd:	e8 4f ff ff ff       	call   80102c51 <fill_rtcdate>
80102d02:	83 c4 04             	add    $0x4,%esp
    if(memcmp(&t1, &t2, sizeof(t1)) == 0)
80102d05:	83 ec 04             	sub    $0x4,%esp
80102d08:	6a 18                	push   $0x18
80102d0a:	8d 45 c0             	lea    -0x40(%ebp),%eax
80102d0d:	50                   	push   %eax
80102d0e:	8d 45 d8             	lea    -0x28(%ebp),%eax
80102d11:	50                   	push   %eax
80102d12:	e8 53 1f 00 00       	call   80104c6a <memcmp>
80102d17:	83 c4 10             	add    $0x10,%esp
80102d1a:	85 c0                	test   %eax,%eax
80102d1c:	74 05                	je     80102d23 <cmostime+0x6d>
80102d1e:	eb ba                	jmp    80102cda <cmostime+0x24>
        continue;
80102d20:	90                   	nop
    fill_rtcdate(&t1);
80102d21:	eb b7                	jmp    80102cda <cmostime+0x24>
      break;
80102d23:	90                   	nop
  }

  // convert
  if(bcd) {
80102d24:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80102d28:	0f 84 b4 00 00 00    	je     80102de2 <cmostime+0x12c>
#define    CONV(x)     (t1.x = ((t1.x >> 4) * 10) + (t1.x & 0xf))
    CONV(second);
80102d2e:	8b 45 d8             	mov    -0x28(%ebp),%eax
80102d31:	c1 e8 04             	shr    $0x4,%eax
80102d34:	89 c2                	mov    %eax,%edx
80102d36:	89 d0                	mov    %edx,%eax
80102d38:	c1 e0 02             	shl    $0x2,%eax
80102d3b:	01 d0                	add    %edx,%eax
80102d3d:	01 c0                	add    %eax,%eax
80102d3f:	89 c2                	mov    %eax,%edx
80102d41:	8b 45 d8             	mov    -0x28(%ebp),%eax
80102d44:	83 e0 0f             	and    $0xf,%eax
80102d47:	01 d0                	add    %edx,%eax
80102d49:	89 45 d8             	mov    %eax,-0x28(%ebp)
    CONV(minute);
80102d4c:	8b 45 dc             	mov    -0x24(%ebp),%eax
80102d4f:	c1 e8 04             	shr    $0x4,%eax
80102d52:	89 c2                	mov    %eax,%edx
80102d54:	89 d0                	mov    %edx,%eax
80102d56:	c1 e0 02             	shl    $0x2,%eax
80102d59:	01 d0                	add    %edx,%eax
80102d5b:	01 c0                	add    %eax,%eax
80102d5d:	89 c2                	mov    %eax,%edx
80102d5f:	8b 45 dc             	mov    -0x24(%ebp),%eax
80102d62:	83 e0 0f             	and    $0xf,%eax
80102d65:	01 d0                	add    %edx,%eax
80102d67:	89 45 dc             	mov    %eax,-0x24(%ebp)
    CONV(hour  );
80102d6a:	8b 45 e0             	mov    -0x20(%ebp),%eax
80102d6d:	c1 e8 04             	shr    $0x4,%eax
80102d70:	89 c2                	mov    %eax,%edx
80102d72:	89 d0                	mov    %edx,%eax
80102d74:	c1 e0 02             	shl    $0x2,%eax
80102d77:	01 d0                	add    %edx,%eax
80102d79:	01 c0                	add    %eax,%eax
80102d7b:	89 c2                	mov    %eax,%edx
80102d7d:	8b 45 e0             	mov    -0x20(%ebp),%eax
80102d80:	83 e0 0f             	and    $0xf,%eax
80102d83:	01 d0                	add    %edx,%eax
80102d85:	89 45 e0             	mov    %eax,-0x20(%ebp)
    CONV(day   );
80102d88:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80102d8b:	c1 e8 04             	shr    $0x4,%eax
80102d8e:	89 c2                	mov    %eax,%edx
80102d90:	89 d0                	mov    %edx,%eax
80102d92:	c1 e0 02             	shl    $0x2,%eax
80102d95:	01 d0                	add    %edx,%eax
80102d97:	01 c0                	add    %eax,%eax
80102d99:	89 c2                	mov    %eax,%edx
80102d9b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80102d9e:	83 e0 0f             	and    $0xf,%eax
80102da1:	01 d0                	add    %edx,%eax
80102da3:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    CONV(month );
80102da6:	8b 45 e8             	mov    -0x18(%ebp),%eax
80102da9:	c1 e8 04             	shr    $0x4,%eax
80102dac:	89 c2                	mov    %eax,%edx
80102dae:	89 d0                	mov    %edx,%eax
80102db0:	c1 e0 02             	shl    $0x2,%eax
80102db3:	01 d0                	add    %edx,%eax
80102db5:	01 c0                	add    %eax,%eax
80102db7:	89 c2                	mov    %eax,%edx
80102db9:	8b 45 e8             	mov    -0x18(%ebp),%eax
80102dbc:	83 e0 0f             	and    $0xf,%eax
80102dbf:	01 d0                	add    %edx,%eax
80102dc1:	89 45 e8             	mov    %eax,-0x18(%ebp)
    CONV(year  );
80102dc4:	8b 45 ec             	mov    -0x14(%ebp),%eax
80102dc7:	c1 e8 04             	shr    $0x4,%eax
80102dca:	89 c2                	mov    %eax,%edx
80102dcc:	89 d0                	mov    %edx,%eax
80102dce:	c1 e0 02             	shl    $0x2,%eax
80102dd1:	01 d0                	add    %edx,%eax
80102dd3:	01 c0                	add    %eax,%eax
80102dd5:	89 c2                	mov    %eax,%edx
80102dd7:	8b 45 ec             	mov    -0x14(%ebp),%eax
80102dda:	83 e0 0f             	and    $0xf,%eax
80102ddd:	01 d0                	add    %edx,%eax
80102ddf:	89 45 ec             	mov    %eax,-0x14(%ebp)
#undef     CONV
  }

  *r = t1;
80102de2:	8b 45 08             	mov    0x8(%ebp),%eax
80102de5:	8b 55 d8             	mov    -0x28(%ebp),%edx
80102de8:	89 10                	mov    %edx,(%eax)
80102dea:	8b 55 dc             	mov    -0x24(%ebp),%edx
80102ded:	89 50 04             	mov    %edx,0x4(%eax)
80102df0:	8b 55 e0             	mov    -0x20(%ebp),%edx
80102df3:	89 50 08             	mov    %edx,0x8(%eax)
80102df6:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80102df9:	89 50 0c             	mov    %edx,0xc(%eax)
80102dfc:	8b 55 e8             	mov    -0x18(%ebp),%edx
80102dff:	89 50 10             	mov    %edx,0x10(%eax)
80102e02:	8b 55 ec             	mov    -0x14(%ebp),%edx
80102e05:	89 50 14             	mov    %edx,0x14(%eax)
  r->year += 2000;
80102e08:	8b 45 08             	mov    0x8(%ebp),%eax
80102e0b:	8b 40 14             	mov    0x14(%eax),%eax
80102e0e:	8d 90 d0 07 00 00    	lea    0x7d0(%eax),%edx
80102e14:	8b 45 08             	mov    0x8(%ebp),%eax
80102e17:	89 50 14             	mov    %edx,0x14(%eax)
}
80102e1a:	90                   	nop
80102e1b:	c9                   	leave  
80102e1c:	c3                   	ret    

80102e1d <initlog>:
static void recover_from_log(void);
static void commit();

void
initlog(int dev)
{
80102e1d:	55                   	push   %ebp
80102e1e:	89 e5                	mov    %esp,%ebp
80102e20:	83 ec 28             	sub    $0x28,%esp
  if (sizeof(struct logheader) >= BSIZE)
    panic("initlog: too big logheader");

  struct superblock sb;
  initlock(&log.lock, "log");
80102e23:	83 ec 08             	sub    $0x8,%esp
80102e26:	68 91 a4 10 80       	push   $0x8010a491
80102e2b:	68 20 41 19 80       	push   $0x80194120
80102e30:	e8 36 1b 00 00       	call   8010496b <initlock>
80102e35:	83 c4 10             	add    $0x10,%esp
  readsb(dev, &sb);
80102e38:	83 ec 08             	sub    $0x8,%esp
80102e3b:	8d 45 dc             	lea    -0x24(%ebp),%eax
80102e3e:	50                   	push   %eax
80102e3f:	ff 75 08             	push   0x8(%ebp)
80102e42:	e8 87 e5 ff ff       	call   801013ce <readsb>
80102e47:	83 c4 10             	add    $0x10,%esp
  log.start = sb.logstart;
80102e4a:	8b 45 ec             	mov    -0x14(%ebp),%eax
80102e4d:	a3 54 41 19 80       	mov    %eax,0x80194154
  log.size = sb.nlog;
80102e52:	8b 45 e8             	mov    -0x18(%ebp),%eax
80102e55:	a3 58 41 19 80       	mov    %eax,0x80194158
  log.dev = dev;
80102e5a:	8b 45 08             	mov    0x8(%ebp),%eax
80102e5d:	a3 64 41 19 80       	mov    %eax,0x80194164
  recover_from_log();
80102e62:	e8 b3 01 00 00       	call   8010301a <recover_from_log>
}
80102e67:	90                   	nop
80102e68:	c9                   	leave  
80102e69:	c3                   	ret    

80102e6a <install_trans>:

// Copy committed blocks from log to their home location
static void
install_trans(void)
{
80102e6a:	55                   	push   %ebp
80102e6b:	89 e5                	mov    %esp,%ebp
80102e6d:	83 ec 18             	sub    $0x18,%esp
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
80102e70:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80102e77:	e9 95 00 00 00       	jmp    80102f11 <install_trans+0xa7>
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
80102e7c:	8b 15 54 41 19 80    	mov    0x80194154,%edx
80102e82:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102e85:	01 d0                	add    %edx,%eax
80102e87:	83 c0 01             	add    $0x1,%eax
80102e8a:	89 c2                	mov    %eax,%edx
80102e8c:	a1 64 41 19 80       	mov    0x80194164,%eax
80102e91:	83 ec 08             	sub    $0x8,%esp
80102e94:	52                   	push   %edx
80102e95:	50                   	push   %eax
80102e96:	e8 66 d3 ff ff       	call   80100201 <bread>
80102e9b:	83 c4 10             	add    $0x10,%esp
80102e9e:	89 45 f0             	mov    %eax,-0x10(%ebp)
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
80102ea1:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102ea4:	83 c0 10             	add    $0x10,%eax
80102ea7:	8b 04 85 2c 41 19 80 	mov    -0x7fe6bed4(,%eax,4),%eax
80102eae:	89 c2                	mov    %eax,%edx
80102eb0:	a1 64 41 19 80       	mov    0x80194164,%eax
80102eb5:	83 ec 08             	sub    $0x8,%esp
80102eb8:	52                   	push   %edx
80102eb9:	50                   	push   %eax
80102eba:	e8 42 d3 ff ff       	call   80100201 <bread>
80102ebf:	83 c4 10             	add    $0x10,%esp
80102ec2:	89 45 ec             	mov    %eax,-0x14(%ebp)
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
80102ec5:	8b 45 f0             	mov    -0x10(%ebp),%eax
80102ec8:	8d 50 5c             	lea    0x5c(%eax),%edx
80102ecb:	8b 45 ec             	mov    -0x14(%ebp),%eax
80102ece:	83 c0 5c             	add    $0x5c,%eax
80102ed1:	83 ec 04             	sub    $0x4,%esp
80102ed4:	68 00 02 00 00       	push   $0x200
80102ed9:	52                   	push   %edx
80102eda:	50                   	push   %eax
80102edb:	e8 e2 1d 00 00       	call   80104cc2 <memmove>
80102ee0:	83 c4 10             	add    $0x10,%esp
    bwrite(dbuf);  // write dst to disk
80102ee3:	83 ec 0c             	sub    $0xc,%esp
80102ee6:	ff 75 ec             	push   -0x14(%ebp)
80102ee9:	e8 4c d3 ff ff       	call   8010023a <bwrite>
80102eee:	83 c4 10             	add    $0x10,%esp
    brelse(lbuf);
80102ef1:	83 ec 0c             	sub    $0xc,%esp
80102ef4:	ff 75 f0             	push   -0x10(%ebp)
80102ef7:	e8 87 d3 ff ff       	call   80100283 <brelse>
80102efc:	83 c4 10             	add    $0x10,%esp
    brelse(dbuf);
80102eff:	83 ec 0c             	sub    $0xc,%esp
80102f02:	ff 75 ec             	push   -0x14(%ebp)
80102f05:	e8 79 d3 ff ff       	call   80100283 <brelse>
80102f0a:	83 c4 10             	add    $0x10,%esp
  for (tail = 0; tail < log.lh.n; tail++) {
80102f0d:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80102f11:	a1 68 41 19 80       	mov    0x80194168,%eax
80102f16:	39 45 f4             	cmp    %eax,-0xc(%ebp)
80102f19:	0f 8c 5d ff ff ff    	jl     80102e7c <install_trans+0x12>
  }
}
80102f1f:	90                   	nop
80102f20:	90                   	nop
80102f21:	c9                   	leave  
80102f22:	c3                   	ret    

80102f23 <read_head>:

// Read the log header from disk into the in-memory log header
static void
read_head(void)
{
80102f23:	55                   	push   %ebp
80102f24:	89 e5                	mov    %esp,%ebp
80102f26:	83 ec 18             	sub    $0x18,%esp
  struct buf *buf = bread(log.dev, log.start);
80102f29:	a1 54 41 19 80       	mov    0x80194154,%eax
80102f2e:	89 c2                	mov    %eax,%edx
80102f30:	a1 64 41 19 80       	mov    0x80194164,%eax
80102f35:	83 ec 08             	sub    $0x8,%esp
80102f38:	52                   	push   %edx
80102f39:	50                   	push   %eax
80102f3a:	e8 c2 d2 ff ff       	call   80100201 <bread>
80102f3f:	83 c4 10             	add    $0x10,%esp
80102f42:	89 45 f0             	mov    %eax,-0x10(%ebp)
  struct logheader *lh = (struct logheader *) (buf->data);
80102f45:	8b 45 f0             	mov    -0x10(%ebp),%eax
80102f48:	83 c0 5c             	add    $0x5c,%eax
80102f4b:	89 45 ec             	mov    %eax,-0x14(%ebp)
  int i;
  log.lh.n = lh->n;
80102f4e:	8b 45 ec             	mov    -0x14(%ebp),%eax
80102f51:	8b 00                	mov    (%eax),%eax
80102f53:	a3 68 41 19 80       	mov    %eax,0x80194168
  for (i = 0; i < log.lh.n; i++) {
80102f58:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80102f5f:	eb 1b                	jmp    80102f7c <read_head+0x59>
    log.lh.block[i] = lh->block[i];
80102f61:	8b 45 ec             	mov    -0x14(%ebp),%eax
80102f64:	8b 55 f4             	mov    -0xc(%ebp),%edx
80102f67:	8b 44 90 04          	mov    0x4(%eax,%edx,4),%eax
80102f6b:	8b 55 f4             	mov    -0xc(%ebp),%edx
80102f6e:	83 c2 10             	add    $0x10,%edx
80102f71:	89 04 95 2c 41 19 80 	mov    %eax,-0x7fe6bed4(,%edx,4)
  for (i = 0; i < log.lh.n; i++) {
80102f78:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80102f7c:	a1 68 41 19 80       	mov    0x80194168,%eax
80102f81:	39 45 f4             	cmp    %eax,-0xc(%ebp)
80102f84:	7c db                	jl     80102f61 <read_head+0x3e>
  }
  brelse(buf);
80102f86:	83 ec 0c             	sub    $0xc,%esp
80102f89:	ff 75 f0             	push   -0x10(%ebp)
80102f8c:	e8 f2 d2 ff ff       	call   80100283 <brelse>
80102f91:	83 c4 10             	add    $0x10,%esp
}
80102f94:	90                   	nop
80102f95:	c9                   	leave  
80102f96:	c3                   	ret    

80102f97 <write_head>:
// Write in-memory log header to disk.
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
80102f97:	55                   	push   %ebp
80102f98:	89 e5                	mov    %esp,%ebp
80102f9a:	83 ec 18             	sub    $0x18,%esp
  struct buf *buf = bread(log.dev, log.start);
80102f9d:	a1 54 41 19 80       	mov    0x80194154,%eax
80102fa2:	89 c2                	mov    %eax,%edx
80102fa4:	a1 64 41 19 80       	mov    0x80194164,%eax
80102fa9:	83 ec 08             	sub    $0x8,%esp
80102fac:	52                   	push   %edx
80102fad:	50                   	push   %eax
80102fae:	e8 4e d2 ff ff       	call   80100201 <bread>
80102fb3:	83 c4 10             	add    $0x10,%esp
80102fb6:	89 45 f0             	mov    %eax,-0x10(%ebp)
  struct logheader *hb = (struct logheader *) (buf->data);
80102fb9:	8b 45 f0             	mov    -0x10(%ebp),%eax
80102fbc:	83 c0 5c             	add    $0x5c,%eax
80102fbf:	89 45 ec             	mov    %eax,-0x14(%ebp)
  int i;
  hb->n = log.lh.n;
80102fc2:	8b 15 68 41 19 80    	mov    0x80194168,%edx
80102fc8:	8b 45 ec             	mov    -0x14(%ebp),%eax
80102fcb:	89 10                	mov    %edx,(%eax)
  for (i = 0; i < log.lh.n; i++) {
80102fcd:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80102fd4:	eb 1b                	jmp    80102ff1 <write_head+0x5a>
    hb->block[i] = log.lh.block[i];
80102fd6:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102fd9:	83 c0 10             	add    $0x10,%eax
80102fdc:	8b 0c 85 2c 41 19 80 	mov    -0x7fe6bed4(,%eax,4),%ecx
80102fe3:	8b 45 ec             	mov    -0x14(%ebp),%eax
80102fe6:	8b 55 f4             	mov    -0xc(%ebp),%edx
80102fe9:	89 4c 90 04          	mov    %ecx,0x4(%eax,%edx,4)
  for (i = 0; i < log.lh.n; i++) {
80102fed:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80102ff1:	a1 68 41 19 80       	mov    0x80194168,%eax
80102ff6:	39 45 f4             	cmp    %eax,-0xc(%ebp)
80102ff9:	7c db                	jl     80102fd6 <write_head+0x3f>
  }
  bwrite(buf);
80102ffb:	83 ec 0c             	sub    $0xc,%esp
80102ffe:	ff 75 f0             	push   -0x10(%ebp)
80103001:	e8 34 d2 ff ff       	call   8010023a <bwrite>
80103006:	83 c4 10             	add    $0x10,%esp
  brelse(buf);
80103009:	83 ec 0c             	sub    $0xc,%esp
8010300c:	ff 75 f0             	push   -0x10(%ebp)
8010300f:	e8 6f d2 ff ff       	call   80100283 <brelse>
80103014:	83 c4 10             	add    $0x10,%esp
}
80103017:	90                   	nop
80103018:	c9                   	leave  
80103019:	c3                   	ret    

8010301a <recover_from_log>:

static void
recover_from_log(void)
{
8010301a:	55                   	push   %ebp
8010301b:	89 e5                	mov    %esp,%ebp
8010301d:	83 ec 08             	sub    $0x8,%esp
  read_head();
80103020:	e8 fe fe ff ff       	call   80102f23 <read_head>
  install_trans(); // if committed, copy from log to disk
80103025:	e8 40 fe ff ff       	call   80102e6a <install_trans>
  log.lh.n = 0;
8010302a:	c7 05 68 41 19 80 00 	movl   $0x0,0x80194168
80103031:	00 00 00 
  write_head(); // clear the log
80103034:	e8 5e ff ff ff       	call   80102f97 <write_head>
}
80103039:	90                   	nop
8010303a:	c9                   	leave  
8010303b:	c3                   	ret    

8010303c <begin_op>:

// called at the start of each FS system call.
void
begin_op(void)
{
8010303c:	55                   	push   %ebp
8010303d:	89 e5                	mov    %esp,%ebp
8010303f:	83 ec 08             	sub    $0x8,%esp
  acquire(&log.lock);
80103042:	83 ec 0c             	sub    $0xc,%esp
80103045:	68 20 41 19 80       	push   $0x80194120
8010304a:	e8 3e 19 00 00       	call   8010498d <acquire>
8010304f:	83 c4 10             	add    $0x10,%esp
  while(1){
    if(log.committing){
80103052:	a1 60 41 19 80       	mov    0x80194160,%eax
80103057:	85 c0                	test   %eax,%eax
80103059:	74 17                	je     80103072 <begin_op+0x36>
      sleep(&log, &log.lock);
8010305b:	83 ec 08             	sub    $0x8,%esp
8010305e:	68 20 41 19 80       	push   $0x80194120
80103063:	68 20 41 19 80       	push   $0x80194120
80103068:	e8 fc 14 00 00       	call   80104569 <sleep>
8010306d:	83 c4 10             	add    $0x10,%esp
80103070:	eb e0                	jmp    80103052 <begin_op+0x16>
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
80103072:	8b 0d 68 41 19 80    	mov    0x80194168,%ecx
80103078:	a1 5c 41 19 80       	mov    0x8019415c,%eax
8010307d:	8d 50 01             	lea    0x1(%eax),%edx
80103080:	89 d0                	mov    %edx,%eax
80103082:	c1 e0 02             	shl    $0x2,%eax
80103085:	01 d0                	add    %edx,%eax
80103087:	01 c0                	add    %eax,%eax
80103089:	01 c8                	add    %ecx,%eax
8010308b:	83 f8 1e             	cmp    $0x1e,%eax
8010308e:	7e 17                	jle    801030a7 <begin_op+0x6b>
      // this op might exhaust log space; wait for commit.
      sleep(&log, &log.lock);
80103090:	83 ec 08             	sub    $0x8,%esp
80103093:	68 20 41 19 80       	push   $0x80194120
80103098:	68 20 41 19 80       	push   $0x80194120
8010309d:	e8 c7 14 00 00       	call   80104569 <sleep>
801030a2:	83 c4 10             	add    $0x10,%esp
801030a5:	eb ab                	jmp    80103052 <begin_op+0x16>
    } else {
      log.outstanding += 1;
801030a7:	a1 5c 41 19 80       	mov    0x8019415c,%eax
801030ac:	83 c0 01             	add    $0x1,%eax
801030af:	a3 5c 41 19 80       	mov    %eax,0x8019415c
      release(&log.lock);
801030b4:	83 ec 0c             	sub    $0xc,%esp
801030b7:	68 20 41 19 80       	push   $0x80194120
801030bc:	e8 3a 19 00 00       	call   801049fb <release>
801030c1:	83 c4 10             	add    $0x10,%esp
      break;
801030c4:	90                   	nop
    }
  }
}
801030c5:	90                   	nop
801030c6:	c9                   	leave  
801030c7:	c3                   	ret    

801030c8 <end_op>:

// called at the end of each FS system call.
// commits if this was the last outstanding operation.
void
end_op(void)
{
801030c8:	55                   	push   %ebp
801030c9:	89 e5                	mov    %esp,%ebp
801030cb:	83 ec 18             	sub    $0x18,%esp
  int do_commit = 0;
801030ce:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

  acquire(&log.lock);
801030d5:	83 ec 0c             	sub    $0xc,%esp
801030d8:	68 20 41 19 80       	push   $0x80194120
801030dd:	e8 ab 18 00 00       	call   8010498d <acquire>
801030e2:	83 c4 10             	add    $0x10,%esp
  log.outstanding -= 1;
801030e5:	a1 5c 41 19 80       	mov    0x8019415c,%eax
801030ea:	83 e8 01             	sub    $0x1,%eax
801030ed:	a3 5c 41 19 80       	mov    %eax,0x8019415c
  if(log.committing)
801030f2:	a1 60 41 19 80       	mov    0x80194160,%eax
801030f7:	85 c0                	test   %eax,%eax
801030f9:	74 0d                	je     80103108 <end_op+0x40>
    panic("log.committing");
801030fb:	83 ec 0c             	sub    $0xc,%esp
801030fe:	68 95 a4 10 80       	push   $0x8010a495
80103103:	e8 a1 d4 ff ff       	call   801005a9 <panic>
  if(log.outstanding == 0){
80103108:	a1 5c 41 19 80       	mov    0x8019415c,%eax
8010310d:	85 c0                	test   %eax,%eax
8010310f:	75 13                	jne    80103124 <end_op+0x5c>
    do_commit = 1;
80103111:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
    log.committing = 1;
80103118:	c7 05 60 41 19 80 01 	movl   $0x1,0x80194160
8010311f:	00 00 00 
80103122:	eb 10                	jmp    80103134 <end_op+0x6c>
  } else {
    // begin_op() may be waiting for log space,
    // and decrementing log.outstanding has decreased
    // the amount of reserved space.
    wakeup(&log);
80103124:	83 ec 0c             	sub    $0xc,%esp
80103127:	68 20 41 19 80       	push   $0x80194120
8010312c:	e8 22 15 00 00       	call   80104653 <wakeup>
80103131:	83 c4 10             	add    $0x10,%esp
  }
  release(&log.lock);
80103134:	83 ec 0c             	sub    $0xc,%esp
80103137:	68 20 41 19 80       	push   $0x80194120
8010313c:	e8 ba 18 00 00       	call   801049fb <release>
80103141:	83 c4 10             	add    $0x10,%esp

  if(do_commit){
80103144:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80103148:	74 3f                	je     80103189 <end_op+0xc1>
    // call commit w/o holding locks, since not allowed
    // to sleep with locks.
    commit();
8010314a:	e8 f6 00 00 00       	call   80103245 <commit>
    acquire(&log.lock);
8010314f:	83 ec 0c             	sub    $0xc,%esp
80103152:	68 20 41 19 80       	push   $0x80194120
80103157:	e8 31 18 00 00       	call   8010498d <acquire>
8010315c:	83 c4 10             	add    $0x10,%esp
    log.committing = 0;
8010315f:	c7 05 60 41 19 80 00 	movl   $0x0,0x80194160
80103166:	00 00 00 
    wakeup(&log);
80103169:	83 ec 0c             	sub    $0xc,%esp
8010316c:	68 20 41 19 80       	push   $0x80194120
80103171:	e8 dd 14 00 00       	call   80104653 <wakeup>
80103176:	83 c4 10             	add    $0x10,%esp
    release(&log.lock);
80103179:	83 ec 0c             	sub    $0xc,%esp
8010317c:	68 20 41 19 80       	push   $0x80194120
80103181:	e8 75 18 00 00       	call   801049fb <release>
80103186:	83 c4 10             	add    $0x10,%esp
  }
}
80103189:	90                   	nop
8010318a:	c9                   	leave  
8010318b:	c3                   	ret    

8010318c <write_log>:

// Copy modified blocks from cache to log.
static void
write_log(void)
{
8010318c:	55                   	push   %ebp
8010318d:	89 e5                	mov    %esp,%ebp
8010318f:	83 ec 18             	sub    $0x18,%esp
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
80103192:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80103199:	e9 95 00 00 00       	jmp    80103233 <write_log+0xa7>
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
8010319e:	8b 15 54 41 19 80    	mov    0x80194154,%edx
801031a4:	8b 45 f4             	mov    -0xc(%ebp),%eax
801031a7:	01 d0                	add    %edx,%eax
801031a9:	83 c0 01             	add    $0x1,%eax
801031ac:	89 c2                	mov    %eax,%edx
801031ae:	a1 64 41 19 80       	mov    0x80194164,%eax
801031b3:	83 ec 08             	sub    $0x8,%esp
801031b6:	52                   	push   %edx
801031b7:	50                   	push   %eax
801031b8:	e8 44 d0 ff ff       	call   80100201 <bread>
801031bd:	83 c4 10             	add    $0x10,%esp
801031c0:	89 45 f0             	mov    %eax,-0x10(%ebp)
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
801031c3:	8b 45 f4             	mov    -0xc(%ebp),%eax
801031c6:	83 c0 10             	add    $0x10,%eax
801031c9:	8b 04 85 2c 41 19 80 	mov    -0x7fe6bed4(,%eax,4),%eax
801031d0:	89 c2                	mov    %eax,%edx
801031d2:	a1 64 41 19 80       	mov    0x80194164,%eax
801031d7:	83 ec 08             	sub    $0x8,%esp
801031da:	52                   	push   %edx
801031db:	50                   	push   %eax
801031dc:	e8 20 d0 ff ff       	call   80100201 <bread>
801031e1:	83 c4 10             	add    $0x10,%esp
801031e4:	89 45 ec             	mov    %eax,-0x14(%ebp)
    memmove(to->data, from->data, BSIZE);
801031e7:	8b 45 ec             	mov    -0x14(%ebp),%eax
801031ea:	8d 50 5c             	lea    0x5c(%eax),%edx
801031ed:	8b 45 f0             	mov    -0x10(%ebp),%eax
801031f0:	83 c0 5c             	add    $0x5c,%eax
801031f3:	83 ec 04             	sub    $0x4,%esp
801031f6:	68 00 02 00 00       	push   $0x200
801031fb:	52                   	push   %edx
801031fc:	50                   	push   %eax
801031fd:	e8 c0 1a 00 00       	call   80104cc2 <memmove>
80103202:	83 c4 10             	add    $0x10,%esp
    bwrite(to);  // write the log
80103205:	83 ec 0c             	sub    $0xc,%esp
80103208:	ff 75 f0             	push   -0x10(%ebp)
8010320b:	e8 2a d0 ff ff       	call   8010023a <bwrite>
80103210:	83 c4 10             	add    $0x10,%esp
    brelse(from);
80103213:	83 ec 0c             	sub    $0xc,%esp
80103216:	ff 75 ec             	push   -0x14(%ebp)
80103219:	e8 65 d0 ff ff       	call   80100283 <brelse>
8010321e:	83 c4 10             	add    $0x10,%esp
    brelse(to);
80103221:	83 ec 0c             	sub    $0xc,%esp
80103224:	ff 75 f0             	push   -0x10(%ebp)
80103227:	e8 57 d0 ff ff       	call   80100283 <brelse>
8010322c:	83 c4 10             	add    $0x10,%esp
  for (tail = 0; tail < log.lh.n; tail++) {
8010322f:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80103233:	a1 68 41 19 80       	mov    0x80194168,%eax
80103238:	39 45 f4             	cmp    %eax,-0xc(%ebp)
8010323b:	0f 8c 5d ff ff ff    	jl     8010319e <write_log+0x12>
  }
}
80103241:	90                   	nop
80103242:	90                   	nop
80103243:	c9                   	leave  
80103244:	c3                   	ret    

80103245 <commit>:

static void
commit()
{
80103245:	55                   	push   %ebp
80103246:	89 e5                	mov    %esp,%ebp
80103248:	83 ec 08             	sub    $0x8,%esp
  if (log.lh.n > 0) {
8010324b:	a1 68 41 19 80       	mov    0x80194168,%eax
80103250:	85 c0                	test   %eax,%eax
80103252:	7e 1e                	jle    80103272 <commit+0x2d>
    write_log();     // Write modified blocks from cache to log
80103254:	e8 33 ff ff ff       	call   8010318c <write_log>
    write_head();    // Write header to disk -- the real commit
80103259:	e8 39 fd ff ff       	call   80102f97 <write_head>
    install_trans(); // Now install writes to home locations
8010325e:	e8 07 fc ff ff       	call   80102e6a <install_trans>
    log.lh.n = 0;
80103263:	c7 05 68 41 19 80 00 	movl   $0x0,0x80194168
8010326a:	00 00 00 
    write_head();    // Erase the transaction from the log
8010326d:	e8 25 fd ff ff       	call   80102f97 <write_head>
  }
}
80103272:	90                   	nop
80103273:	c9                   	leave  
80103274:	c3                   	ret    

80103275 <log_write>:
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
80103275:	55                   	push   %ebp
80103276:	89 e5                	mov    %esp,%ebp
80103278:	83 ec 18             	sub    $0x18,%esp
  int i;

  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
8010327b:	a1 68 41 19 80       	mov    0x80194168,%eax
80103280:	83 f8 1d             	cmp    $0x1d,%eax
80103283:	7f 12                	jg     80103297 <log_write+0x22>
80103285:	a1 68 41 19 80       	mov    0x80194168,%eax
8010328a:	8b 15 58 41 19 80    	mov    0x80194158,%edx
80103290:	83 ea 01             	sub    $0x1,%edx
80103293:	39 d0                	cmp    %edx,%eax
80103295:	7c 0d                	jl     801032a4 <log_write+0x2f>
    panic("too big a transaction");
80103297:	83 ec 0c             	sub    $0xc,%esp
8010329a:	68 a4 a4 10 80       	push   $0x8010a4a4
8010329f:	e8 05 d3 ff ff       	call   801005a9 <panic>
  if (log.outstanding < 1)
801032a4:	a1 5c 41 19 80       	mov    0x8019415c,%eax
801032a9:	85 c0                	test   %eax,%eax
801032ab:	7f 0d                	jg     801032ba <log_write+0x45>
    panic("log_write outside of trans");
801032ad:	83 ec 0c             	sub    $0xc,%esp
801032b0:	68 ba a4 10 80       	push   $0x8010a4ba
801032b5:	e8 ef d2 ff ff       	call   801005a9 <panic>

  acquire(&log.lock);
801032ba:	83 ec 0c             	sub    $0xc,%esp
801032bd:	68 20 41 19 80       	push   $0x80194120
801032c2:	e8 c6 16 00 00       	call   8010498d <acquire>
801032c7:	83 c4 10             	add    $0x10,%esp
  for (i = 0; i < log.lh.n; i++) {
801032ca:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
801032d1:	eb 1d                	jmp    801032f0 <log_write+0x7b>
    if (log.lh.block[i] == b->blockno)   // log absorbtion
801032d3:	8b 45 f4             	mov    -0xc(%ebp),%eax
801032d6:	83 c0 10             	add    $0x10,%eax
801032d9:	8b 04 85 2c 41 19 80 	mov    -0x7fe6bed4(,%eax,4),%eax
801032e0:	89 c2                	mov    %eax,%edx
801032e2:	8b 45 08             	mov    0x8(%ebp),%eax
801032e5:	8b 40 08             	mov    0x8(%eax),%eax
801032e8:	39 c2                	cmp    %eax,%edx
801032ea:	74 10                	je     801032fc <log_write+0x87>
  for (i = 0; i < log.lh.n; i++) {
801032ec:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
801032f0:	a1 68 41 19 80       	mov    0x80194168,%eax
801032f5:	39 45 f4             	cmp    %eax,-0xc(%ebp)
801032f8:	7c d9                	jl     801032d3 <log_write+0x5e>
801032fa:	eb 01                	jmp    801032fd <log_write+0x88>
      break;
801032fc:	90                   	nop
  }
  log.lh.block[i] = b->blockno;
801032fd:	8b 45 08             	mov    0x8(%ebp),%eax
80103300:	8b 40 08             	mov    0x8(%eax),%eax
80103303:	89 c2                	mov    %eax,%edx
80103305:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103308:	83 c0 10             	add    $0x10,%eax
8010330b:	89 14 85 2c 41 19 80 	mov    %edx,-0x7fe6bed4(,%eax,4)
  if (i == log.lh.n)
80103312:	a1 68 41 19 80       	mov    0x80194168,%eax
80103317:	39 45 f4             	cmp    %eax,-0xc(%ebp)
8010331a:	75 0d                	jne    80103329 <log_write+0xb4>
    log.lh.n++;
8010331c:	a1 68 41 19 80       	mov    0x80194168,%eax
80103321:	83 c0 01             	add    $0x1,%eax
80103324:	a3 68 41 19 80       	mov    %eax,0x80194168
  b->flags |= B_DIRTY; // prevent eviction
80103329:	8b 45 08             	mov    0x8(%ebp),%eax
8010332c:	8b 00                	mov    (%eax),%eax
8010332e:	83 c8 04             	or     $0x4,%eax
80103331:	89 c2                	mov    %eax,%edx
80103333:	8b 45 08             	mov    0x8(%ebp),%eax
80103336:	89 10                	mov    %edx,(%eax)
  release(&log.lock);
80103338:	83 ec 0c             	sub    $0xc,%esp
8010333b:	68 20 41 19 80       	push   $0x80194120
80103340:	e8 b6 16 00 00       	call   801049fb <release>
80103345:	83 c4 10             	add    $0x10,%esp
}
80103348:	90                   	nop
80103349:	c9                   	leave  
8010334a:	c3                   	ret    

8010334b <xchg>:
  asm volatile("sti");
}

static inline uint
xchg(volatile uint *addr, uint newval)
{
8010334b:	55                   	push   %ebp
8010334c:	89 e5                	mov    %esp,%ebp
8010334e:	83 ec 10             	sub    $0x10,%esp
  uint result;

  // The + in "+m" denotes a read-modify-write operand.
  asm volatile("lock; xchgl %0, %1" :
80103351:	8b 55 08             	mov    0x8(%ebp),%edx
80103354:	8b 45 0c             	mov    0xc(%ebp),%eax
80103357:	8b 4d 08             	mov    0x8(%ebp),%ecx
8010335a:	f0 87 02             	lock xchg %eax,(%edx)
8010335d:	89 45 fc             	mov    %eax,-0x4(%ebp)
               "+m" (*addr), "=a" (result) :
               "1" (newval) :
               "cc");
  return result;
80103360:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
80103363:	c9                   	leave  
80103364:	c3                   	ret    

80103365 <main>:
// Bootstrap processor starts running C code here.
// Allocate a real stack and switch to it, first
// doing some setup required for memory allocator to work.
int
main(void)
{
80103365:	8d 4c 24 04          	lea    0x4(%esp),%ecx
80103369:	83 e4 f0             	and    $0xfffffff0,%esp
8010336c:	ff 71 fc             	push   -0x4(%ecx)
8010336f:	55                   	push   %ebp
80103370:	89 e5                	mov    %esp,%ebp
80103372:	51                   	push   %ecx
80103373:	83 ec 04             	sub    $0x4,%esp
  graphic_init();
80103376:	e8 b0 4c 00 00       	call   8010802b <graphic_init>
  kinit1(end, P2V(4*1024*1024)); // phys page allocator
8010337b:	83 ec 08             	sub    $0x8,%esp
8010337e:	68 00 00 40 80       	push   $0x80400000
80103383:	68 00 90 19 80       	push   $0x80199000
80103388:	e8 de f2 ff ff       	call   8010266b <kinit1>
8010338d:	83 c4 10             	add    $0x10,%esp
  kvmalloc();      // kernel page table
80103390:	e8 b0 42 00 00       	call   80107645 <kvmalloc>
  mpinit_uefi();
80103395:	e8 57 4a 00 00       	call   80107df1 <mpinit_uefi>
  lapicinit();     // interrupt controller
8010339a:	e8 3c f6 ff ff       	call   801029db <lapicinit>
  seginit();       // segment descriptors
8010339f:	e8 39 3d 00 00       	call   801070dd <seginit>
  picinit();    // disable pic
801033a4:	e8 9d 01 00 00       	call   80103546 <picinit>
  ioapicinit();    // another interrupt controller
801033a9:	e8 d8 f1 ff ff       	call   80102586 <ioapicinit>
  consoleinit();   // console hardware
801033ae:	e8 4c d7 ff ff       	call   80100aff <consoleinit>
  uartinit();      // serial port
801033b3:	e8 be 30 00 00       	call   80106476 <uartinit>
  pinit();         // process table
801033b8:	e8 c2 05 00 00       	call   8010397f <pinit>
  tvinit();        // trap vectors
801033bd:	e8 85 2c 00 00       	call   80106047 <tvinit>
  binit();         // buffer cache
801033c2:	e8 9f cc ff ff       	call   80100066 <binit>
  fileinit();      // file table
801033c7:	e8 f3 db ff ff       	call   80100fbf <fileinit>
  ideinit();       // disk 
801033cc:	e8 9b 6d 00 00       	call   8010a16c <ideinit>
  startothers();   // start other processors
801033d1:	e8 8a 00 00 00       	call   80103460 <startothers>
  kinit2(P2V(4*1024*1024), P2V(PHYSTOP)); // must come after startothers()
801033d6:	83 ec 08             	sub    $0x8,%esp
801033d9:	68 00 00 00 a0       	push   $0xa0000000
801033de:	68 00 00 40 80       	push   $0x80400000
801033e3:	e8 bc f2 ff ff       	call   801026a4 <kinit2>
801033e8:	83 c4 10             	add    $0x10,%esp
  pci_init();
801033eb:	e8 94 4e 00 00       	call   80108284 <pci_init>
  arp_scan();
801033f0:	e8 cb 5b 00 00       	call   80108fc0 <arp_scan>
  //i8254_recv();
  userinit();      // first user process
801033f5:	e8 66 07 00 00       	call   80103b60 <userinit>

  mpmain();        // finish this processor's setup
801033fa:	e8 1a 00 00 00       	call   80103419 <mpmain>

801033ff <mpenter>:
}

// Other CPUs jump here from entryother.S.
static void
mpenter(void)
{
801033ff:	55                   	push   %ebp
80103400:	89 e5                	mov    %esp,%ebp
80103402:	83 ec 08             	sub    $0x8,%esp
  switchkvm();
80103405:	e8 53 42 00 00       	call   8010765d <switchkvm>
  seginit();
8010340a:	e8 ce 3c 00 00       	call   801070dd <seginit>
  lapicinit();
8010340f:	e8 c7 f5 ff ff       	call   801029db <lapicinit>
  mpmain();
80103414:	e8 00 00 00 00       	call   80103419 <mpmain>

80103419 <mpmain>:
}

// Common CPU setup code.
static void
mpmain(void)
{
80103419:	55                   	push   %ebp
8010341a:	89 e5                	mov    %esp,%ebp
8010341c:	53                   	push   %ebx
8010341d:	83 ec 04             	sub    $0x4,%esp
  cprintf("cpu%d: starting %d\n", cpuid(), cpuid());
80103420:	e8 78 05 00 00       	call   8010399d <cpuid>
80103425:	89 c3                	mov    %eax,%ebx
80103427:	e8 71 05 00 00       	call   8010399d <cpuid>
8010342c:	83 ec 04             	sub    $0x4,%esp
8010342f:	53                   	push   %ebx
80103430:	50                   	push   %eax
80103431:	68 d5 a4 10 80       	push   $0x8010a4d5
80103436:	e8 b9 cf ff ff       	call   801003f4 <cprintf>
8010343b:	83 c4 10             	add    $0x10,%esp
  idtinit();       // load idt register
8010343e:	e8 7a 2d 00 00       	call   801061bd <idtinit>
  xchg(&(mycpu()->started), 1); // tell startothers() we're up
80103443:	e8 70 05 00 00       	call   801039b8 <mycpu>
80103448:	05 a0 00 00 00       	add    $0xa0,%eax
8010344d:	83 ec 08             	sub    $0x8,%esp
80103450:	6a 01                	push   $0x1
80103452:	50                   	push   %eax
80103453:	e8 f3 fe ff ff       	call   8010334b <xchg>
80103458:	83 c4 10             	add    $0x10,%esp
  scheduler();     // start running processes
8010345b:	e8 15 0f 00 00       	call   80104375 <scheduler>

80103460 <startothers>:
pde_t entrypgdir[];  // For entry.S

// Start the non-boot (AP) processors.
static void
startothers(void)
{
80103460:	55                   	push   %ebp
80103461:	89 e5                	mov    %esp,%ebp
80103463:	83 ec 18             	sub    $0x18,%esp
  char *stack;

  // Write entry code to unused memory at 0x7000.
  // The linker has placed the image of entryother.S in
  // _binary_entryother_start.
  code = P2V(0x7000);
80103466:	c7 45 f0 00 70 00 80 	movl   $0x80007000,-0x10(%ebp)
  memmove(code, _binary_entryother_start, (uint)_binary_entryother_size);
8010346d:	b8 8a 00 00 00       	mov    $0x8a,%eax
80103472:	83 ec 04             	sub    $0x4,%esp
80103475:	50                   	push   %eax
80103476:	68 38 f5 10 80       	push   $0x8010f538
8010347b:	ff 75 f0             	push   -0x10(%ebp)
8010347e:	e8 3f 18 00 00       	call   80104cc2 <memmove>
80103483:	83 c4 10             	add    $0x10,%esp

  for(c = cpus; c < cpus+ncpu; c++){
80103486:	c7 45 f4 80 6b 19 80 	movl   $0x80196b80,-0xc(%ebp)
8010348d:	eb 79                	jmp    80103508 <startothers+0xa8>
    if(c == mycpu()){  // We've started already.
8010348f:	e8 24 05 00 00       	call   801039b8 <mycpu>
80103494:	39 45 f4             	cmp    %eax,-0xc(%ebp)
80103497:	74 67                	je     80103500 <startothers+0xa0>
      continue;
    }
    // Tell entryother.S what stack to use, where to enter, and what
    // pgdir to use. We cannot use kpgdir yet, because the AP processor
    // is running in low  memory, so we use entrypgdir for the APs too.
    stack = kalloc();
80103499:	e8 02 f3 ff ff       	call   801027a0 <kalloc>
8010349e:	89 45 ec             	mov    %eax,-0x14(%ebp)
    *(void**)(code-4) = stack + KSTACKSIZE;
801034a1:	8b 45 f0             	mov    -0x10(%ebp),%eax
801034a4:	83 e8 04             	sub    $0x4,%eax
801034a7:	8b 55 ec             	mov    -0x14(%ebp),%edx
801034aa:	81 c2 00 10 00 00    	add    $0x1000,%edx
801034b0:	89 10                	mov    %edx,(%eax)
    *(void**)(code-8) = mpenter;
801034b2:	8b 45 f0             	mov    -0x10(%ebp),%eax
801034b5:	83 e8 08             	sub    $0x8,%eax
801034b8:	c7 00 ff 33 10 80    	movl   $0x801033ff,(%eax)
    *(int**)(code-12) = (void *) V2P(entrypgdir);
801034be:	b8 00 e0 10 80       	mov    $0x8010e000,%eax
801034c3:	8d 90 00 00 00 80    	lea    -0x80000000(%eax),%edx
801034c9:	8b 45 f0             	mov    -0x10(%ebp),%eax
801034cc:	83 e8 0c             	sub    $0xc,%eax
801034cf:	89 10                	mov    %edx,(%eax)

    lapicstartap(c->apicid, V2P(code));
801034d1:	8b 45 f0             	mov    -0x10(%ebp),%eax
801034d4:	8d 90 00 00 00 80    	lea    -0x80000000(%eax),%edx
801034da:	8b 45 f4             	mov    -0xc(%ebp),%eax
801034dd:	0f b6 00             	movzbl (%eax),%eax
801034e0:	0f b6 c0             	movzbl %al,%eax
801034e3:	83 ec 08             	sub    $0x8,%esp
801034e6:	52                   	push   %edx
801034e7:	50                   	push   %eax
801034e8:	e8 50 f6 ff ff       	call   80102b3d <lapicstartap>
801034ed:	83 c4 10             	add    $0x10,%esp

    // wait for cpu to finish mpmain()
    while(c->started == 0)
801034f0:	90                   	nop
801034f1:	8b 45 f4             	mov    -0xc(%ebp),%eax
801034f4:	8b 80 a0 00 00 00    	mov    0xa0(%eax),%eax
801034fa:	85 c0                	test   %eax,%eax
801034fc:	74 f3                	je     801034f1 <startothers+0x91>
801034fe:	eb 01                	jmp    80103501 <startothers+0xa1>
      continue;
80103500:	90                   	nop
  for(c = cpus; c < cpus+ncpu; c++){
80103501:	81 45 f4 b0 00 00 00 	addl   $0xb0,-0xc(%ebp)
80103508:	a1 40 6e 19 80       	mov    0x80196e40,%eax
8010350d:	69 c0 b0 00 00 00    	imul   $0xb0,%eax,%eax
80103513:	05 80 6b 19 80       	add    $0x80196b80,%eax
80103518:	39 45 f4             	cmp    %eax,-0xc(%ebp)
8010351b:	0f 82 6e ff ff ff    	jb     8010348f <startothers+0x2f>
      ;
  }
}
80103521:	90                   	nop
80103522:	90                   	nop
80103523:	c9                   	leave  
80103524:	c3                   	ret    

80103525 <outb>:
80103525:	55                   	push   %ebp
80103526:	89 e5                	mov    %esp,%ebp
80103528:	83 ec 08             	sub    $0x8,%esp
8010352b:	8b 45 08             	mov    0x8(%ebp),%eax
8010352e:	8b 55 0c             	mov    0xc(%ebp),%edx
80103531:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
80103535:	89 d0                	mov    %edx,%eax
80103537:	88 45 f8             	mov    %al,-0x8(%ebp)
8010353a:	0f b6 45 f8          	movzbl -0x8(%ebp),%eax
8010353e:	0f b7 55 fc          	movzwl -0x4(%ebp),%edx
80103542:	ee                   	out    %al,(%dx)
80103543:	90                   	nop
80103544:	c9                   	leave  
80103545:	c3                   	ret    

80103546 <picinit>:
80103546:	55                   	push   %ebp
80103547:	89 e5                	mov    %esp,%ebp
80103549:	68 ff 00 00 00       	push   $0xff
8010354e:	6a 21                	push   $0x21
80103550:	e8 d0 ff ff ff       	call   80103525 <outb>
80103555:	83 c4 08             	add    $0x8,%esp
80103558:	68 ff 00 00 00       	push   $0xff
8010355d:	68 a1 00 00 00       	push   $0xa1
80103562:	e8 be ff ff ff       	call   80103525 <outb>
80103567:	83 c4 08             	add    $0x8,%esp
8010356a:	90                   	nop
8010356b:	c9                   	leave  
8010356c:	c3                   	ret    

8010356d <pipealloc>:
  int writeopen;  // write fd is still open
};

int
pipealloc(struct file **f0, struct file **f1)
{
8010356d:	55                   	push   %ebp
8010356e:	89 e5                	mov    %esp,%ebp
80103570:	83 ec 18             	sub    $0x18,%esp
  struct pipe *p;

  p = 0;
80103573:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  *f0 = *f1 = 0;
8010357a:	8b 45 0c             	mov    0xc(%ebp),%eax
8010357d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
80103583:	8b 45 0c             	mov    0xc(%ebp),%eax
80103586:	8b 10                	mov    (%eax),%edx
80103588:	8b 45 08             	mov    0x8(%ebp),%eax
8010358b:	89 10                	mov    %edx,(%eax)
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
8010358d:	e8 4b da ff ff       	call   80100fdd <filealloc>
80103592:	8b 55 08             	mov    0x8(%ebp),%edx
80103595:	89 02                	mov    %eax,(%edx)
80103597:	8b 45 08             	mov    0x8(%ebp),%eax
8010359a:	8b 00                	mov    (%eax),%eax
8010359c:	85 c0                	test   %eax,%eax
8010359e:	0f 84 c8 00 00 00    	je     8010366c <pipealloc+0xff>
801035a4:	e8 34 da ff ff       	call   80100fdd <filealloc>
801035a9:	8b 55 0c             	mov    0xc(%ebp),%edx
801035ac:	89 02                	mov    %eax,(%edx)
801035ae:	8b 45 0c             	mov    0xc(%ebp),%eax
801035b1:	8b 00                	mov    (%eax),%eax
801035b3:	85 c0                	test   %eax,%eax
801035b5:	0f 84 b1 00 00 00    	je     8010366c <pipealloc+0xff>
    goto bad;
  if((p = (struct pipe*)kalloc()) == 0)
801035bb:	e8 e0 f1 ff ff       	call   801027a0 <kalloc>
801035c0:	89 45 f4             	mov    %eax,-0xc(%ebp)
801035c3:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801035c7:	0f 84 a2 00 00 00    	je     8010366f <pipealloc+0x102>
    goto bad;
  p->readopen = 1;
801035cd:	8b 45 f4             	mov    -0xc(%ebp),%eax
801035d0:	c7 80 3c 02 00 00 01 	movl   $0x1,0x23c(%eax)
801035d7:	00 00 00 
  p->writeopen = 1;
801035da:	8b 45 f4             	mov    -0xc(%ebp),%eax
801035dd:	c7 80 40 02 00 00 01 	movl   $0x1,0x240(%eax)
801035e4:	00 00 00 
  p->nwrite = 0;
801035e7:	8b 45 f4             	mov    -0xc(%ebp),%eax
801035ea:	c7 80 38 02 00 00 00 	movl   $0x0,0x238(%eax)
801035f1:	00 00 00 
  p->nread = 0;
801035f4:	8b 45 f4             	mov    -0xc(%ebp),%eax
801035f7:	c7 80 34 02 00 00 00 	movl   $0x0,0x234(%eax)
801035fe:	00 00 00 
  initlock(&p->lock, "pipe");
80103601:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103604:	83 ec 08             	sub    $0x8,%esp
80103607:	68 e9 a4 10 80       	push   $0x8010a4e9
8010360c:	50                   	push   %eax
8010360d:	e8 59 13 00 00       	call   8010496b <initlock>
80103612:	83 c4 10             	add    $0x10,%esp
  (*f0)->type = FD_PIPE;
80103615:	8b 45 08             	mov    0x8(%ebp),%eax
80103618:	8b 00                	mov    (%eax),%eax
8010361a:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  (*f0)->readable = 1;
80103620:	8b 45 08             	mov    0x8(%ebp),%eax
80103623:	8b 00                	mov    (%eax),%eax
80103625:	c6 40 08 01          	movb   $0x1,0x8(%eax)
  (*f0)->writable = 0;
80103629:	8b 45 08             	mov    0x8(%ebp),%eax
8010362c:	8b 00                	mov    (%eax),%eax
8010362e:	c6 40 09 00          	movb   $0x0,0x9(%eax)
  (*f0)->pipe = p;
80103632:	8b 45 08             	mov    0x8(%ebp),%eax
80103635:	8b 00                	mov    (%eax),%eax
80103637:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010363a:	89 50 0c             	mov    %edx,0xc(%eax)
  (*f1)->type = FD_PIPE;
8010363d:	8b 45 0c             	mov    0xc(%ebp),%eax
80103640:	8b 00                	mov    (%eax),%eax
80103642:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  (*f1)->readable = 0;
80103648:	8b 45 0c             	mov    0xc(%ebp),%eax
8010364b:	8b 00                	mov    (%eax),%eax
8010364d:	c6 40 08 00          	movb   $0x0,0x8(%eax)
  (*f1)->writable = 1;
80103651:	8b 45 0c             	mov    0xc(%ebp),%eax
80103654:	8b 00                	mov    (%eax),%eax
80103656:	c6 40 09 01          	movb   $0x1,0x9(%eax)
  (*f1)->pipe = p;
8010365a:	8b 45 0c             	mov    0xc(%ebp),%eax
8010365d:	8b 00                	mov    (%eax),%eax
8010365f:	8b 55 f4             	mov    -0xc(%ebp),%edx
80103662:	89 50 0c             	mov    %edx,0xc(%eax)
  return 0;
80103665:	b8 00 00 00 00       	mov    $0x0,%eax
8010366a:	eb 51                	jmp    801036bd <pipealloc+0x150>
    goto bad;
8010366c:	90                   	nop
8010366d:	eb 01                	jmp    80103670 <pipealloc+0x103>
    goto bad;
8010366f:	90                   	nop

//PAGEBREAK: 20
 bad:
  if(p)
80103670:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80103674:	74 0e                	je     80103684 <pipealloc+0x117>
    kfree((char*)p);
80103676:	83 ec 0c             	sub    $0xc,%esp
80103679:	ff 75 f4             	push   -0xc(%ebp)
8010367c:	e8 85 f0 ff ff       	call   80102706 <kfree>
80103681:	83 c4 10             	add    $0x10,%esp
  if(*f0)
80103684:	8b 45 08             	mov    0x8(%ebp),%eax
80103687:	8b 00                	mov    (%eax),%eax
80103689:	85 c0                	test   %eax,%eax
8010368b:	74 11                	je     8010369e <pipealloc+0x131>
    fileclose(*f0);
8010368d:	8b 45 08             	mov    0x8(%ebp),%eax
80103690:	8b 00                	mov    (%eax),%eax
80103692:	83 ec 0c             	sub    $0xc,%esp
80103695:	50                   	push   %eax
80103696:	e8 00 da ff ff       	call   8010109b <fileclose>
8010369b:	83 c4 10             	add    $0x10,%esp
  if(*f1)
8010369e:	8b 45 0c             	mov    0xc(%ebp),%eax
801036a1:	8b 00                	mov    (%eax),%eax
801036a3:	85 c0                	test   %eax,%eax
801036a5:	74 11                	je     801036b8 <pipealloc+0x14b>
    fileclose(*f1);
801036a7:	8b 45 0c             	mov    0xc(%ebp),%eax
801036aa:	8b 00                	mov    (%eax),%eax
801036ac:	83 ec 0c             	sub    $0xc,%esp
801036af:	50                   	push   %eax
801036b0:	e8 e6 d9 ff ff       	call   8010109b <fileclose>
801036b5:	83 c4 10             	add    $0x10,%esp
  return -1;
801036b8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801036bd:	c9                   	leave  
801036be:	c3                   	ret    

801036bf <pipeclose>:

void
pipeclose(struct pipe *p, int writable)
{
801036bf:	55                   	push   %ebp
801036c0:	89 e5                	mov    %esp,%ebp
801036c2:	83 ec 08             	sub    $0x8,%esp
  acquire(&p->lock);
801036c5:	8b 45 08             	mov    0x8(%ebp),%eax
801036c8:	83 ec 0c             	sub    $0xc,%esp
801036cb:	50                   	push   %eax
801036cc:	e8 bc 12 00 00       	call   8010498d <acquire>
801036d1:	83 c4 10             	add    $0x10,%esp
  if(writable){
801036d4:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
801036d8:	74 23                	je     801036fd <pipeclose+0x3e>
    p->writeopen = 0;
801036da:	8b 45 08             	mov    0x8(%ebp),%eax
801036dd:	c7 80 40 02 00 00 00 	movl   $0x0,0x240(%eax)
801036e4:	00 00 00 
    wakeup(&p->nread);
801036e7:	8b 45 08             	mov    0x8(%ebp),%eax
801036ea:	05 34 02 00 00       	add    $0x234,%eax
801036ef:	83 ec 0c             	sub    $0xc,%esp
801036f2:	50                   	push   %eax
801036f3:	e8 5b 0f 00 00       	call   80104653 <wakeup>
801036f8:	83 c4 10             	add    $0x10,%esp
801036fb:	eb 21                	jmp    8010371e <pipeclose+0x5f>
  } else {
    p->readopen = 0;
801036fd:	8b 45 08             	mov    0x8(%ebp),%eax
80103700:	c7 80 3c 02 00 00 00 	movl   $0x0,0x23c(%eax)
80103707:	00 00 00 
    wakeup(&p->nwrite);
8010370a:	8b 45 08             	mov    0x8(%ebp),%eax
8010370d:	05 38 02 00 00       	add    $0x238,%eax
80103712:	83 ec 0c             	sub    $0xc,%esp
80103715:	50                   	push   %eax
80103716:	e8 38 0f 00 00       	call   80104653 <wakeup>
8010371b:	83 c4 10             	add    $0x10,%esp
  }
  if(p->readopen == 0 && p->writeopen == 0){
8010371e:	8b 45 08             	mov    0x8(%ebp),%eax
80103721:	8b 80 3c 02 00 00    	mov    0x23c(%eax),%eax
80103727:	85 c0                	test   %eax,%eax
80103729:	75 2c                	jne    80103757 <pipeclose+0x98>
8010372b:	8b 45 08             	mov    0x8(%ebp),%eax
8010372e:	8b 80 40 02 00 00    	mov    0x240(%eax),%eax
80103734:	85 c0                	test   %eax,%eax
80103736:	75 1f                	jne    80103757 <pipeclose+0x98>
    release(&p->lock);
80103738:	8b 45 08             	mov    0x8(%ebp),%eax
8010373b:	83 ec 0c             	sub    $0xc,%esp
8010373e:	50                   	push   %eax
8010373f:	e8 b7 12 00 00       	call   801049fb <release>
80103744:	83 c4 10             	add    $0x10,%esp
    kfree((char*)p);
80103747:	83 ec 0c             	sub    $0xc,%esp
8010374a:	ff 75 08             	push   0x8(%ebp)
8010374d:	e8 b4 ef ff ff       	call   80102706 <kfree>
80103752:	83 c4 10             	add    $0x10,%esp
80103755:	eb 10                	jmp    80103767 <pipeclose+0xa8>
  } else
    release(&p->lock);
80103757:	8b 45 08             	mov    0x8(%ebp),%eax
8010375a:	83 ec 0c             	sub    $0xc,%esp
8010375d:	50                   	push   %eax
8010375e:	e8 98 12 00 00       	call   801049fb <release>
80103763:	83 c4 10             	add    $0x10,%esp
}
80103766:	90                   	nop
80103767:	90                   	nop
80103768:	c9                   	leave  
80103769:	c3                   	ret    

8010376a <pipewrite>:

//PAGEBREAK: 40
int
pipewrite(struct pipe *p, char *addr, int n)
{
8010376a:	55                   	push   %ebp
8010376b:	89 e5                	mov    %esp,%ebp
8010376d:	53                   	push   %ebx
8010376e:	83 ec 14             	sub    $0x14,%esp
  int i;

  acquire(&p->lock);
80103771:	8b 45 08             	mov    0x8(%ebp),%eax
80103774:	83 ec 0c             	sub    $0xc,%esp
80103777:	50                   	push   %eax
80103778:	e8 10 12 00 00       	call   8010498d <acquire>
8010377d:	83 c4 10             	add    $0x10,%esp
  for(i = 0; i < n; i++){
80103780:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80103787:	e9 ad 00 00 00       	jmp    80103839 <pipewrite+0xcf>
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
      if(p->readopen == 0 || myproc()->killed){
8010378c:	8b 45 08             	mov    0x8(%ebp),%eax
8010378f:	8b 80 3c 02 00 00    	mov    0x23c(%eax),%eax
80103795:	85 c0                	test   %eax,%eax
80103797:	74 0c                	je     801037a5 <pipewrite+0x3b>
80103799:	e8 92 02 00 00       	call   80103a30 <myproc>
8010379e:	8b 40 24             	mov    0x24(%eax),%eax
801037a1:	85 c0                	test   %eax,%eax
801037a3:	74 19                	je     801037be <pipewrite+0x54>
        release(&p->lock);
801037a5:	8b 45 08             	mov    0x8(%ebp),%eax
801037a8:	83 ec 0c             	sub    $0xc,%esp
801037ab:	50                   	push   %eax
801037ac:	e8 4a 12 00 00       	call   801049fb <release>
801037b1:	83 c4 10             	add    $0x10,%esp
        return -1;
801037b4:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801037b9:	e9 a9 00 00 00       	jmp    80103867 <pipewrite+0xfd>
      }
      wakeup(&p->nread);
801037be:	8b 45 08             	mov    0x8(%ebp),%eax
801037c1:	05 34 02 00 00       	add    $0x234,%eax
801037c6:	83 ec 0c             	sub    $0xc,%esp
801037c9:	50                   	push   %eax
801037ca:	e8 84 0e 00 00       	call   80104653 <wakeup>
801037cf:	83 c4 10             	add    $0x10,%esp
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
801037d2:	8b 45 08             	mov    0x8(%ebp),%eax
801037d5:	8b 55 08             	mov    0x8(%ebp),%edx
801037d8:	81 c2 38 02 00 00    	add    $0x238,%edx
801037de:	83 ec 08             	sub    $0x8,%esp
801037e1:	50                   	push   %eax
801037e2:	52                   	push   %edx
801037e3:	e8 81 0d 00 00       	call   80104569 <sleep>
801037e8:	83 c4 10             	add    $0x10,%esp
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
801037eb:	8b 45 08             	mov    0x8(%ebp),%eax
801037ee:	8b 90 38 02 00 00    	mov    0x238(%eax),%edx
801037f4:	8b 45 08             	mov    0x8(%ebp),%eax
801037f7:	8b 80 34 02 00 00    	mov    0x234(%eax),%eax
801037fd:	05 00 02 00 00       	add    $0x200,%eax
80103802:	39 c2                	cmp    %eax,%edx
80103804:	74 86                	je     8010378c <pipewrite+0x22>
    }
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
80103806:	8b 55 f4             	mov    -0xc(%ebp),%edx
80103809:	8b 45 0c             	mov    0xc(%ebp),%eax
8010380c:	8d 1c 02             	lea    (%edx,%eax,1),%ebx
8010380f:	8b 45 08             	mov    0x8(%ebp),%eax
80103812:	8b 80 38 02 00 00    	mov    0x238(%eax),%eax
80103818:	8d 48 01             	lea    0x1(%eax),%ecx
8010381b:	8b 55 08             	mov    0x8(%ebp),%edx
8010381e:	89 8a 38 02 00 00    	mov    %ecx,0x238(%edx)
80103824:	25 ff 01 00 00       	and    $0x1ff,%eax
80103829:	89 c1                	mov    %eax,%ecx
8010382b:	0f b6 13             	movzbl (%ebx),%edx
8010382e:	8b 45 08             	mov    0x8(%ebp),%eax
80103831:	88 54 08 34          	mov    %dl,0x34(%eax,%ecx,1)
  for(i = 0; i < n; i++){
80103835:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80103839:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010383c:	3b 45 10             	cmp    0x10(%ebp),%eax
8010383f:	7c aa                	jl     801037eb <pipewrite+0x81>
  }
  wakeup(&p->nread);  //DOC: pipewrite-wakeup1
80103841:	8b 45 08             	mov    0x8(%ebp),%eax
80103844:	05 34 02 00 00       	add    $0x234,%eax
80103849:	83 ec 0c             	sub    $0xc,%esp
8010384c:	50                   	push   %eax
8010384d:	e8 01 0e 00 00       	call   80104653 <wakeup>
80103852:	83 c4 10             	add    $0x10,%esp
  release(&p->lock);
80103855:	8b 45 08             	mov    0x8(%ebp),%eax
80103858:	83 ec 0c             	sub    $0xc,%esp
8010385b:	50                   	push   %eax
8010385c:	e8 9a 11 00 00       	call   801049fb <release>
80103861:	83 c4 10             	add    $0x10,%esp
  return n;
80103864:	8b 45 10             	mov    0x10(%ebp),%eax
}
80103867:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010386a:	c9                   	leave  
8010386b:	c3                   	ret    

8010386c <piperead>:

int
piperead(struct pipe *p, char *addr, int n)
{
8010386c:	55                   	push   %ebp
8010386d:	89 e5                	mov    %esp,%ebp
8010386f:	83 ec 18             	sub    $0x18,%esp
  int i;

  acquire(&p->lock);
80103872:	8b 45 08             	mov    0x8(%ebp),%eax
80103875:	83 ec 0c             	sub    $0xc,%esp
80103878:	50                   	push   %eax
80103879:	e8 0f 11 00 00       	call   8010498d <acquire>
8010387e:	83 c4 10             	add    $0x10,%esp
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
80103881:	eb 3e                	jmp    801038c1 <piperead+0x55>
    if(myproc()->killed){
80103883:	e8 a8 01 00 00       	call   80103a30 <myproc>
80103888:	8b 40 24             	mov    0x24(%eax),%eax
8010388b:	85 c0                	test   %eax,%eax
8010388d:	74 19                	je     801038a8 <piperead+0x3c>
      release(&p->lock);
8010388f:	8b 45 08             	mov    0x8(%ebp),%eax
80103892:	83 ec 0c             	sub    $0xc,%esp
80103895:	50                   	push   %eax
80103896:	e8 60 11 00 00       	call   801049fb <release>
8010389b:	83 c4 10             	add    $0x10,%esp
      return -1;
8010389e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801038a3:	e9 be 00 00 00       	jmp    80103966 <piperead+0xfa>
    }
    sleep(&p->nread, &p->lock); //DOC: piperead-sleep
801038a8:	8b 45 08             	mov    0x8(%ebp),%eax
801038ab:	8b 55 08             	mov    0x8(%ebp),%edx
801038ae:	81 c2 34 02 00 00    	add    $0x234,%edx
801038b4:	83 ec 08             	sub    $0x8,%esp
801038b7:	50                   	push   %eax
801038b8:	52                   	push   %edx
801038b9:	e8 ab 0c 00 00       	call   80104569 <sleep>
801038be:	83 c4 10             	add    $0x10,%esp
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
801038c1:	8b 45 08             	mov    0x8(%ebp),%eax
801038c4:	8b 90 34 02 00 00    	mov    0x234(%eax),%edx
801038ca:	8b 45 08             	mov    0x8(%ebp),%eax
801038cd:	8b 80 38 02 00 00    	mov    0x238(%eax),%eax
801038d3:	39 c2                	cmp    %eax,%edx
801038d5:	75 0d                	jne    801038e4 <piperead+0x78>
801038d7:	8b 45 08             	mov    0x8(%ebp),%eax
801038da:	8b 80 40 02 00 00    	mov    0x240(%eax),%eax
801038e0:	85 c0                	test   %eax,%eax
801038e2:	75 9f                	jne    80103883 <piperead+0x17>
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
801038e4:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
801038eb:	eb 48                	jmp    80103935 <piperead+0xc9>
    if(p->nread == p->nwrite)
801038ed:	8b 45 08             	mov    0x8(%ebp),%eax
801038f0:	8b 90 34 02 00 00    	mov    0x234(%eax),%edx
801038f6:	8b 45 08             	mov    0x8(%ebp),%eax
801038f9:	8b 80 38 02 00 00    	mov    0x238(%eax),%eax
801038ff:	39 c2                	cmp    %eax,%edx
80103901:	74 3c                	je     8010393f <piperead+0xd3>
      break;
    addr[i] = p->data[p->nread++ % PIPESIZE];
80103903:	8b 45 08             	mov    0x8(%ebp),%eax
80103906:	8b 80 34 02 00 00    	mov    0x234(%eax),%eax
8010390c:	8d 48 01             	lea    0x1(%eax),%ecx
8010390f:	8b 55 08             	mov    0x8(%ebp),%edx
80103912:	89 8a 34 02 00 00    	mov    %ecx,0x234(%edx)
80103918:	25 ff 01 00 00       	and    $0x1ff,%eax
8010391d:	89 c1                	mov    %eax,%ecx
8010391f:	8b 55 f4             	mov    -0xc(%ebp),%edx
80103922:	8b 45 0c             	mov    0xc(%ebp),%eax
80103925:	01 c2                	add    %eax,%edx
80103927:	8b 45 08             	mov    0x8(%ebp),%eax
8010392a:	0f b6 44 08 34       	movzbl 0x34(%eax,%ecx,1),%eax
8010392f:	88 02                	mov    %al,(%edx)
  for(i = 0; i < n; i++){  //DOC: piperead-copy
80103931:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80103935:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103938:	3b 45 10             	cmp    0x10(%ebp),%eax
8010393b:	7c b0                	jl     801038ed <piperead+0x81>
8010393d:	eb 01                	jmp    80103940 <piperead+0xd4>
      break;
8010393f:	90                   	nop
  }
  wakeup(&p->nwrite);  //DOC: piperead-wakeup
80103940:	8b 45 08             	mov    0x8(%ebp),%eax
80103943:	05 38 02 00 00       	add    $0x238,%eax
80103948:	83 ec 0c             	sub    $0xc,%esp
8010394b:	50                   	push   %eax
8010394c:	e8 02 0d 00 00       	call   80104653 <wakeup>
80103951:	83 c4 10             	add    $0x10,%esp
  release(&p->lock);
80103954:	8b 45 08             	mov    0x8(%ebp),%eax
80103957:	83 ec 0c             	sub    $0xc,%esp
8010395a:	50                   	push   %eax
8010395b:	e8 9b 10 00 00       	call   801049fb <release>
80103960:	83 c4 10             	add    $0x10,%esp
  return i;
80103963:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
80103966:	c9                   	leave  
80103967:	c3                   	ret    

80103968 <readeflags>:
{
80103968:	55                   	push   %ebp
80103969:	89 e5                	mov    %esp,%ebp
8010396b:	83 ec 10             	sub    $0x10,%esp
  asm volatile("pushfl; popl %0" : "=r" (eflags));
8010396e:	9c                   	pushf  
8010396f:	58                   	pop    %eax
80103970:	89 45 fc             	mov    %eax,-0x4(%ebp)
  return eflags;
80103973:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
80103976:	c9                   	leave  
80103977:	c3                   	ret    

80103978 <sti>:
{
80103978:	55                   	push   %ebp
80103979:	89 e5                	mov    %esp,%ebp
  asm volatile("sti");
8010397b:	fb                   	sti    
}
8010397c:	90                   	nop
8010397d:	5d                   	pop    %ebp
8010397e:	c3                   	ret    

8010397f <pinit>:

static void wakeup1(void *chan);

void
pinit(void)
{
8010397f:	55                   	push   %ebp
80103980:	89 e5                	mov    %esp,%ebp
80103982:	83 ec 08             	sub    $0x8,%esp
  initlock(&ptable.lock, "ptable");
80103985:	83 ec 08             	sub    $0x8,%esp
80103988:	68 f0 a4 10 80       	push   $0x8010a4f0
8010398d:	68 00 42 19 80       	push   $0x80194200
80103992:	e8 d4 0f 00 00       	call   8010496b <initlock>
80103997:	83 c4 10             	add    $0x10,%esp
}
8010399a:	90                   	nop
8010399b:	c9                   	leave  
8010399c:	c3                   	ret    

8010399d <cpuid>:

// Must be called with interrupts disabled
int
cpuid() {
8010399d:	55                   	push   %ebp
8010399e:	89 e5                	mov    %esp,%ebp
801039a0:	83 ec 08             	sub    $0x8,%esp
  return mycpu()-cpus;
801039a3:	e8 10 00 00 00       	call   801039b8 <mycpu>
801039a8:	2d 80 6b 19 80       	sub    $0x80196b80,%eax
801039ad:	c1 f8 04             	sar    $0x4,%eax
801039b0:	69 c0 a3 8b 2e ba    	imul   $0xba2e8ba3,%eax,%eax
}
801039b6:	c9                   	leave  
801039b7:	c3                   	ret    

801039b8 <mycpu>:

// Must be called with interrupts disabled to avoid the caller being
// rescheduled between reading lapicid and running through the loop.
struct cpu*
mycpu(void)
{
801039b8:	55                   	push   %ebp
801039b9:	89 e5                	mov    %esp,%ebp
801039bb:	83 ec 18             	sub    $0x18,%esp
  int apicid, i;
  
  if(readeflags()&FL_IF){
801039be:	e8 a5 ff ff ff       	call   80103968 <readeflags>
801039c3:	25 00 02 00 00       	and    $0x200,%eax
801039c8:	85 c0                	test   %eax,%eax
801039ca:	74 0d                	je     801039d9 <mycpu+0x21>
    panic("mycpu called with interrupts enabled\n");
801039cc:	83 ec 0c             	sub    $0xc,%esp
801039cf:	68 f8 a4 10 80       	push   $0x8010a4f8
801039d4:	e8 d0 cb ff ff       	call   801005a9 <panic>
  }

  apicid = lapicid();
801039d9:	e8 1c f1 ff ff       	call   80102afa <lapicid>
801039de:	89 45 f0             	mov    %eax,-0x10(%ebp)
  // APIC IDs are not guaranteed to be contiguous. Maybe we should have
  // a reverse map, or reserve a register to store &cpus[i].
  for (i = 0; i < ncpu; ++i) {
801039e1:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
801039e8:	eb 2d                	jmp    80103a17 <mycpu+0x5f>
    if (cpus[i].apicid == apicid){
801039ea:	8b 45 f4             	mov    -0xc(%ebp),%eax
801039ed:	69 c0 b0 00 00 00    	imul   $0xb0,%eax,%eax
801039f3:	05 80 6b 19 80       	add    $0x80196b80,%eax
801039f8:	0f b6 00             	movzbl (%eax),%eax
801039fb:	0f b6 c0             	movzbl %al,%eax
801039fe:	39 45 f0             	cmp    %eax,-0x10(%ebp)
80103a01:	75 10                	jne    80103a13 <mycpu+0x5b>
      return &cpus[i];
80103a03:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103a06:	69 c0 b0 00 00 00    	imul   $0xb0,%eax,%eax
80103a0c:	05 80 6b 19 80       	add    $0x80196b80,%eax
80103a11:	eb 1b                	jmp    80103a2e <mycpu+0x76>
  for (i = 0; i < ncpu; ++i) {
80103a13:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80103a17:	a1 40 6e 19 80       	mov    0x80196e40,%eax
80103a1c:	39 45 f4             	cmp    %eax,-0xc(%ebp)
80103a1f:	7c c9                	jl     801039ea <mycpu+0x32>
    }
  }
  panic("unknown apicid\n");
80103a21:	83 ec 0c             	sub    $0xc,%esp
80103a24:	68 1e a5 10 80       	push   $0x8010a51e
80103a29:	e8 7b cb ff ff       	call   801005a9 <panic>
}
80103a2e:	c9                   	leave  
80103a2f:	c3                   	ret    

80103a30 <myproc>:

// Disable interrupts so that we are not rescheduled
// while reading proc from the cpu structure
struct proc*
myproc(void) {
80103a30:	55                   	push   %ebp
80103a31:	89 e5                	mov    %esp,%ebp
80103a33:	83 ec 18             	sub    $0x18,%esp
  struct cpu *c;
  struct proc *p;
  pushcli();
80103a36:	e8 bd 10 00 00       	call   80104af8 <pushcli>
  c = mycpu();
80103a3b:	e8 78 ff ff ff       	call   801039b8 <mycpu>
80103a40:	89 45 f4             	mov    %eax,-0xc(%ebp)
  p = c->proc;
80103a43:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103a46:	8b 80 ac 00 00 00    	mov    0xac(%eax),%eax
80103a4c:	89 45 f0             	mov    %eax,-0x10(%ebp)
  popcli();
80103a4f:	e8 f1 10 00 00       	call   80104b45 <popcli>
  return p;
80103a54:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
80103a57:	c9                   	leave  
80103a58:	c3                   	ret    

80103a59 <allocproc>:
// If found, change state to EMBRYO and initialize
// state required to run in the kernel.
// Otherwise return 0.
static struct proc*
allocproc(void)
{
80103a59:	55                   	push   %ebp
80103a5a:	89 e5                	mov    %esp,%ebp
80103a5c:	83 ec 18             	sub    $0x18,%esp
  struct proc *p;
  char *sp;

  acquire(&ptable.lock);
80103a5f:	83 ec 0c             	sub    $0xc,%esp
80103a62:	68 00 42 19 80       	push   $0x80194200
80103a67:	e8 21 0f 00 00       	call   8010498d <acquire>
80103a6c:	83 c4 10             	add    $0x10,%esp

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103a6f:	c7 45 f4 34 42 19 80 	movl   $0x80194234,-0xc(%ebp)
80103a76:	eb 11                	jmp    80103a89 <allocproc+0x30>
    if(p->state == UNUSED){
80103a78:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103a7b:	8b 40 0c             	mov    0xc(%eax),%eax
80103a7e:	85 c0                	test   %eax,%eax
80103a80:	74 2a                	je     80103aac <allocproc+0x53>
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103a82:	81 45 f4 84 00 00 00 	addl   $0x84,-0xc(%ebp)
80103a89:	81 7d f4 34 63 19 80 	cmpl   $0x80196334,-0xc(%ebp)
80103a90:	72 e6                	jb     80103a78 <allocproc+0x1f>
      goto found;
    }

  release(&ptable.lock);
80103a92:	83 ec 0c             	sub    $0xc,%esp
80103a95:	68 00 42 19 80       	push   $0x80194200
80103a9a:	e8 5c 0f 00 00       	call   801049fb <release>
80103a9f:	83 c4 10             	add    $0x10,%esp
  return 0;
80103aa2:	b8 00 00 00 00       	mov    $0x0,%eax
80103aa7:	e9 b2 00 00 00       	jmp    80103b5e <allocproc+0x105>
      goto found;
80103aac:	90                   	nop

found:
  p->state = EMBRYO;
80103aad:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103ab0:	c7 40 0c 01 00 00 00 	movl   $0x1,0xc(%eax)
  p->pid = nextpid++;
80103ab7:	a1 00 f0 10 80       	mov    0x8010f000,%eax
80103abc:	8d 50 01             	lea    0x1(%eax),%edx
80103abf:	89 15 00 f0 10 80    	mov    %edx,0x8010f000
80103ac5:	8b 55 f4             	mov    -0xc(%ebp),%edx
80103ac8:	89 42 10             	mov    %eax,0x10(%edx)

  release(&ptable.lock);
80103acb:	83 ec 0c             	sub    $0xc,%esp
80103ace:	68 00 42 19 80       	push   $0x80194200
80103ad3:	e8 23 0f 00 00       	call   801049fb <release>
80103ad8:	83 c4 10             	add    $0x10,%esp


  // Allocate kernel stack.
  if((p->kstack = kalloc()) == 0){
80103adb:	e8 c0 ec ff ff       	call   801027a0 <kalloc>
80103ae0:	8b 55 f4             	mov    -0xc(%ebp),%edx
80103ae3:	89 42 08             	mov    %eax,0x8(%edx)
80103ae6:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103ae9:	8b 40 08             	mov    0x8(%eax),%eax
80103aec:	85 c0                	test   %eax,%eax
80103aee:	75 11                	jne    80103b01 <allocproc+0xa8>
    p->state = UNUSED;
80103af0:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103af3:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
    return 0;
80103afa:	b8 00 00 00 00       	mov    $0x0,%eax
80103aff:	eb 5d                	jmp    80103b5e <allocproc+0x105>
  }
  sp = p->kstack + KSTACKSIZE;
80103b01:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103b04:	8b 40 08             	mov    0x8(%eax),%eax
80103b07:	05 00 10 00 00       	add    $0x1000,%eax
80103b0c:	89 45 f0             	mov    %eax,-0x10(%ebp)

  // Leave room for trap frame.
  sp -= sizeof *p->tf;
80103b0f:	83 6d f0 4c          	subl   $0x4c,-0x10(%ebp)
  p->tf = (struct trapframe*)sp;
80103b13:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103b16:	8b 55 f0             	mov    -0x10(%ebp),%edx
80103b19:	89 50 18             	mov    %edx,0x18(%eax)

  // Set up new context to start executing at forkret,
  // which returns to trapret.
  sp -= 4;
80103b1c:	83 6d f0 04          	subl   $0x4,-0x10(%ebp)
  *(uint*)sp = (uint)trapret;
80103b20:	ba 01 60 10 80       	mov    $0x80106001,%edx
80103b25:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103b28:	89 10                	mov    %edx,(%eax)

  sp -= sizeof *p->context;
80103b2a:	83 6d f0 14          	subl   $0x14,-0x10(%ebp)
  p->context = (struct context*)sp;
80103b2e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103b31:	8b 55 f0             	mov    -0x10(%ebp),%edx
80103b34:	89 50 1c             	mov    %edx,0x1c(%eax)
  memset(p->context, 0, sizeof *p->context);
80103b37:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103b3a:	8b 40 1c             	mov    0x1c(%eax),%eax
80103b3d:	83 ec 04             	sub    $0x4,%esp
80103b40:	6a 14                	push   $0x14
80103b42:	6a 00                	push   $0x0
80103b44:	50                   	push   %eax
80103b45:	e8 b9 10 00 00       	call   80104c03 <memset>
80103b4a:	83 c4 10             	add    $0x10,%esp
  p->context->eip = (uint)forkret;
80103b4d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103b50:	8b 40 1c             	mov    0x1c(%eax),%eax
80103b53:	ba 23 45 10 80       	mov    $0x80104523,%edx
80103b58:	89 50 10             	mov    %edx,0x10(%eax)

  return p;
80103b5b:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
80103b5e:	c9                   	leave  
80103b5f:	c3                   	ret    

80103b60 <userinit>:

//PAGEBREAK: 32
// Set up first user process.
void
userinit(void)
{
80103b60:	55                   	push   %ebp
80103b61:	89 e5                	mov    %esp,%ebp
80103b63:	83 ec 18             	sub    $0x18,%esp
  struct proc *p;
  extern char _binary_initcode_start[], _binary_initcode_size[];

  p = allocproc();
80103b66:	e8 ee fe ff ff       	call   80103a59 <allocproc>
80103b6b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  
  initproc = p;
80103b6e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103b71:	a3 34 63 19 80       	mov    %eax,0x80196334
  if((p->pgdir = setupkvm()) == 0){
80103b76:	e8 de 39 00 00       	call   80107559 <setupkvm>
80103b7b:	8b 55 f4             	mov    -0xc(%ebp),%edx
80103b7e:	89 42 04             	mov    %eax,0x4(%edx)
80103b81:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103b84:	8b 40 04             	mov    0x4(%eax),%eax
80103b87:	85 c0                	test   %eax,%eax
80103b89:	75 0d                	jne    80103b98 <userinit+0x38>
    panic("userinit: out of memory?");
80103b8b:	83 ec 0c             	sub    $0xc,%esp
80103b8e:	68 2e a5 10 80       	push   $0x8010a52e
80103b93:	e8 11 ca ff ff       	call   801005a9 <panic>
  }
  inituvm(p->pgdir, _binary_initcode_start, (int)_binary_initcode_size);
80103b98:	ba 2c 00 00 00       	mov    $0x2c,%edx
80103b9d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103ba0:	8b 40 04             	mov    0x4(%eax),%eax
80103ba3:	83 ec 04             	sub    $0x4,%esp
80103ba6:	52                   	push   %edx
80103ba7:	68 0c f5 10 80       	push   $0x8010f50c
80103bac:	50                   	push   %eax
80103bad:	e8 63 3c 00 00       	call   80107815 <inituvm>
80103bb2:	83 c4 10             	add    $0x10,%esp
  p->sz = PGSIZE;
80103bb5:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103bb8:	c7 00 00 10 00 00    	movl   $0x1000,(%eax)
  memset(p->tf, 0, sizeof(*p->tf));
80103bbe:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103bc1:	8b 40 18             	mov    0x18(%eax),%eax
80103bc4:	83 ec 04             	sub    $0x4,%esp
80103bc7:	6a 4c                	push   $0x4c
80103bc9:	6a 00                	push   $0x0
80103bcb:	50                   	push   %eax
80103bcc:	e8 32 10 00 00       	call   80104c03 <memset>
80103bd1:	83 c4 10             	add    $0x10,%esp
  p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
80103bd4:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103bd7:	8b 40 18             	mov    0x18(%eax),%eax
80103bda:	66 c7 40 3c 1b 00    	movw   $0x1b,0x3c(%eax)
  p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
80103be0:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103be3:	8b 40 18             	mov    0x18(%eax),%eax
80103be6:	66 c7 40 2c 23 00    	movw   $0x23,0x2c(%eax)
  p->tf->es = p->tf->ds;
80103bec:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103bef:	8b 50 18             	mov    0x18(%eax),%edx
80103bf2:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103bf5:	8b 40 18             	mov    0x18(%eax),%eax
80103bf8:	0f b7 52 2c          	movzwl 0x2c(%edx),%edx
80103bfc:	66 89 50 28          	mov    %dx,0x28(%eax)
  p->tf->ss = p->tf->ds;
80103c00:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103c03:	8b 50 18             	mov    0x18(%eax),%edx
80103c06:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103c09:	8b 40 18             	mov    0x18(%eax),%eax
80103c0c:	0f b7 52 2c          	movzwl 0x2c(%edx),%edx
80103c10:	66 89 50 48          	mov    %dx,0x48(%eax)
  p->tf->eflags = FL_IF;
80103c14:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103c17:	8b 40 18             	mov    0x18(%eax),%eax
80103c1a:	c7 40 40 00 02 00 00 	movl   $0x200,0x40(%eax)
  p->tf->esp = PGSIZE;
80103c21:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103c24:	8b 40 18             	mov    0x18(%eax),%eax
80103c27:	c7 40 44 00 10 00 00 	movl   $0x1000,0x44(%eax)
  p->tf->eip = 0;  // beginning of initcode.S
80103c2e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103c31:	8b 40 18             	mov    0x18(%eax),%eax
80103c34:	c7 40 38 00 00 00 00 	movl   $0x0,0x38(%eax)

  safestrcpy(p->name, "initcode", sizeof(p->name));
80103c3b:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103c3e:	83 c0 6c             	add    $0x6c,%eax
80103c41:	83 ec 04             	sub    $0x4,%esp
80103c44:	6a 10                	push   $0x10
80103c46:	68 47 a5 10 80       	push   $0x8010a547
80103c4b:	50                   	push   %eax
80103c4c:	e8 b5 11 00 00       	call   80104e06 <safestrcpy>
80103c51:	83 c4 10             	add    $0x10,%esp
  p->cwd = namei("/");
80103c54:	83 ec 0c             	sub    $0xc,%esp
80103c57:	68 50 a5 10 80       	push   $0x8010a550
80103c5c:	e8 bc e8 ff ff       	call   8010251d <namei>
80103c61:	83 c4 10             	add    $0x10,%esp
80103c64:	8b 55 f4             	mov    -0xc(%ebp),%edx
80103c67:	89 42 68             	mov    %eax,0x68(%edx)

  // this assignment to p->state lets other cores
  // run this process. the acquire forces the above
  // writes to be visible, and the lock is also needed
  // because the assignment might not be atomic.
  acquire(&ptable.lock);
80103c6a:	83 ec 0c             	sub    $0xc,%esp
80103c6d:	68 00 42 19 80       	push   $0x80194200
80103c72:	e8 16 0d 00 00       	call   8010498d <acquire>
80103c77:	83 c4 10             	add    $0x10,%esp

  p->state = RUNNABLE;
80103c7a:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103c7d:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)

  release(&ptable.lock);
80103c84:	83 ec 0c             	sub    $0xc,%esp
80103c87:	68 00 42 19 80       	push   $0x80194200
80103c8c:	e8 6a 0d 00 00       	call   801049fb <release>
80103c91:	83 c4 10             	add    $0x10,%esp
}
80103c94:	90                   	nop
80103c95:	c9                   	leave  
80103c96:	c3                   	ret    

80103c97 <growproc>:

// Grow current process's memory by n bytes.
// Return 0 on success, -1 on failure.
int
growproc(int n)
{
80103c97:	55                   	push   %ebp
80103c98:	89 e5                	mov    %esp,%ebp
80103c9a:	83 ec 18             	sub    $0x18,%esp
  uint sz;
  struct proc *curproc = myproc();
80103c9d:	e8 8e fd ff ff       	call   80103a30 <myproc>
80103ca2:	89 45 f0             	mov    %eax,-0x10(%ebp)

  sz = curproc->sz;
80103ca5:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103ca8:	8b 00                	mov    (%eax),%eax
80103caa:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(n > 0){
80103cad:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
80103cb1:	7e 2e                	jle    80103ce1 <growproc+0x4a>
    if((sz = allocuvm(curproc->pgdir, sz, sz + n)) == 0)
80103cb3:	8b 55 08             	mov    0x8(%ebp),%edx
80103cb6:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103cb9:	01 c2                	add    %eax,%edx
80103cbb:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103cbe:	8b 40 04             	mov    0x4(%eax),%eax
80103cc1:	83 ec 04             	sub    $0x4,%esp
80103cc4:	52                   	push   %edx
80103cc5:	ff 75 f4             	push   -0xc(%ebp)
80103cc8:	50                   	push   %eax
80103cc9:	e8 84 3c 00 00       	call   80107952 <allocuvm>
80103cce:	83 c4 10             	add    $0x10,%esp
80103cd1:	89 45 f4             	mov    %eax,-0xc(%ebp)
80103cd4:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80103cd8:	75 3b                	jne    80103d15 <growproc+0x7e>
      return -1;
80103cda:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80103cdf:	eb 4f                	jmp    80103d30 <growproc+0x99>
  } else if(n < 0){
80103ce1:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
80103ce5:	79 2e                	jns    80103d15 <growproc+0x7e>
    if((sz = deallocuvm(curproc->pgdir, sz, sz + n)) == 0)
80103ce7:	8b 55 08             	mov    0x8(%ebp),%edx
80103cea:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103ced:	01 c2                	add    %eax,%edx
80103cef:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103cf2:	8b 40 04             	mov    0x4(%eax),%eax
80103cf5:	83 ec 04             	sub    $0x4,%esp
80103cf8:	52                   	push   %edx
80103cf9:	ff 75 f4             	push   -0xc(%ebp)
80103cfc:	50                   	push   %eax
80103cfd:	e8 55 3d 00 00       	call   80107a57 <deallocuvm>
80103d02:	83 c4 10             	add    $0x10,%esp
80103d05:	89 45 f4             	mov    %eax,-0xc(%ebp)
80103d08:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80103d0c:	75 07                	jne    80103d15 <growproc+0x7e>
      return -1;
80103d0e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80103d13:	eb 1b                	jmp    80103d30 <growproc+0x99>
  }
  curproc->sz = sz;
80103d15:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103d18:	8b 55 f4             	mov    -0xc(%ebp),%edx
80103d1b:	89 10                	mov    %edx,(%eax)
  switchuvm(curproc);
80103d1d:	83 ec 0c             	sub    $0xc,%esp
80103d20:	ff 75 f0             	push   -0x10(%ebp)
80103d23:	e8 4e 39 00 00       	call   80107676 <switchuvm>
80103d28:	83 c4 10             	add    $0x10,%esp
  return 0;
80103d2b:	b8 00 00 00 00       	mov    $0x0,%eax
}
80103d30:	c9                   	leave  
80103d31:	c3                   	ret    

80103d32 <fork>:
// Create a new process copying p as the parent.
// Sets up stack to return as if from system call.
// Caller must set state of returned proc to RUNNABLE.
int
fork(void)
{
80103d32:	55                   	push   %ebp
80103d33:	89 e5                	mov    %esp,%ebp
80103d35:	57                   	push   %edi
80103d36:	56                   	push   %esi
80103d37:	53                   	push   %ebx
80103d38:	83 ec 1c             	sub    $0x1c,%esp
  int i, pid;
  struct proc *np;
  struct proc *curproc = myproc();
80103d3b:	e8 f0 fc ff ff       	call   80103a30 <myproc>
80103d40:	89 45 e0             	mov    %eax,-0x20(%ebp)

  // Allocate process.
  if((np = allocproc()) == 0){
80103d43:	e8 11 fd ff ff       	call   80103a59 <allocproc>
80103d48:	89 45 dc             	mov    %eax,-0x24(%ebp)
80103d4b:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
80103d4f:	75 0a                	jne    80103d5b <fork+0x29>
    return -1;
80103d51:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80103d56:	e9 48 01 00 00       	jmp    80103ea3 <fork+0x171>
  }

  // Copy process state from proc.
  if((np->pgdir = copyuvm(curproc->pgdir, curproc->sz)) == 0){
80103d5b:	8b 45 e0             	mov    -0x20(%ebp),%eax
80103d5e:	8b 10                	mov    (%eax),%edx
80103d60:	8b 45 e0             	mov    -0x20(%ebp),%eax
80103d63:	8b 40 04             	mov    0x4(%eax),%eax
80103d66:	83 ec 08             	sub    $0x8,%esp
80103d69:	52                   	push   %edx
80103d6a:	50                   	push   %eax
80103d6b:	e8 85 3e 00 00       	call   80107bf5 <copyuvm>
80103d70:	83 c4 10             	add    $0x10,%esp
80103d73:	8b 55 dc             	mov    -0x24(%ebp),%edx
80103d76:	89 42 04             	mov    %eax,0x4(%edx)
80103d79:	8b 45 dc             	mov    -0x24(%ebp),%eax
80103d7c:	8b 40 04             	mov    0x4(%eax),%eax
80103d7f:	85 c0                	test   %eax,%eax
80103d81:	75 30                	jne    80103db3 <fork+0x81>
    kfree(np->kstack);
80103d83:	8b 45 dc             	mov    -0x24(%ebp),%eax
80103d86:	8b 40 08             	mov    0x8(%eax),%eax
80103d89:	83 ec 0c             	sub    $0xc,%esp
80103d8c:	50                   	push   %eax
80103d8d:	e8 74 e9 ff ff       	call   80102706 <kfree>
80103d92:	83 c4 10             	add    $0x10,%esp
    np->kstack = 0;
80103d95:	8b 45 dc             	mov    -0x24(%ebp),%eax
80103d98:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
    np->state = UNUSED;
80103d9f:	8b 45 dc             	mov    -0x24(%ebp),%eax
80103da2:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
    return -1;
80103da9:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80103dae:	e9 f0 00 00 00       	jmp    80103ea3 <fork+0x171>
  }
  np->sz = curproc->sz;
80103db3:	8b 45 e0             	mov    -0x20(%ebp),%eax
80103db6:	8b 10                	mov    (%eax),%edx
80103db8:	8b 45 dc             	mov    -0x24(%ebp),%eax
80103dbb:	89 10                	mov    %edx,(%eax)
  np->parent = curproc;
80103dbd:	8b 45 dc             	mov    -0x24(%ebp),%eax
80103dc0:	8b 55 e0             	mov    -0x20(%ebp),%edx
80103dc3:	89 50 14             	mov    %edx,0x14(%eax)
  *np->tf = *curproc->tf;
80103dc6:	8b 45 e0             	mov    -0x20(%ebp),%eax
80103dc9:	8b 48 18             	mov    0x18(%eax),%ecx
80103dcc:	8b 45 dc             	mov    -0x24(%ebp),%eax
80103dcf:	8b 40 18             	mov    0x18(%eax),%eax
80103dd2:	89 c2                	mov    %eax,%edx
80103dd4:	89 cb                	mov    %ecx,%ebx
80103dd6:	b8 13 00 00 00       	mov    $0x13,%eax
80103ddb:	89 d7                	mov    %edx,%edi
80103ddd:	89 de                	mov    %ebx,%esi
80103ddf:	89 c1                	mov    %eax,%ecx
80103de1:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)

  // Clear %eax so that fork returns 0 in the child.
  np->tf->eax = 0;
80103de3:	8b 45 dc             	mov    -0x24(%ebp),%eax
80103de6:	8b 40 18             	mov    0x18(%eax),%eax
80103de9:	c7 40 1c 00 00 00 00 	movl   $0x0,0x1c(%eax)

  for(i = 0; i < NOFILE; i++)
80103df0:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
80103df7:	eb 3b                	jmp    80103e34 <fork+0x102>
    if(curproc->ofile[i])
80103df9:	8b 45 e0             	mov    -0x20(%ebp),%eax
80103dfc:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80103dff:	83 c2 08             	add    $0x8,%edx
80103e02:	8b 44 90 08          	mov    0x8(%eax,%edx,4),%eax
80103e06:	85 c0                	test   %eax,%eax
80103e08:	74 26                	je     80103e30 <fork+0xfe>
      np->ofile[i] = filedup(curproc->ofile[i]);
80103e0a:	8b 45 e0             	mov    -0x20(%ebp),%eax
80103e0d:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80103e10:	83 c2 08             	add    $0x8,%edx
80103e13:	8b 44 90 08          	mov    0x8(%eax,%edx,4),%eax
80103e17:	83 ec 0c             	sub    $0xc,%esp
80103e1a:	50                   	push   %eax
80103e1b:	e8 2a d2 ff ff       	call   8010104a <filedup>
80103e20:	83 c4 10             	add    $0x10,%esp
80103e23:	8b 55 dc             	mov    -0x24(%ebp),%edx
80103e26:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80103e29:	83 c1 08             	add    $0x8,%ecx
80103e2c:	89 44 8a 08          	mov    %eax,0x8(%edx,%ecx,4)
  for(i = 0; i < NOFILE; i++)
80103e30:	83 45 e4 01          	addl   $0x1,-0x1c(%ebp)
80103e34:	83 7d e4 0f          	cmpl   $0xf,-0x1c(%ebp)
80103e38:	7e bf                	jle    80103df9 <fork+0xc7>
  np->cwd = idup(curproc->cwd);
80103e3a:	8b 45 e0             	mov    -0x20(%ebp),%eax
80103e3d:	8b 40 68             	mov    0x68(%eax),%eax
80103e40:	83 ec 0c             	sub    $0xc,%esp
80103e43:	50                   	push   %eax
80103e44:	e8 67 db ff ff       	call   801019b0 <idup>
80103e49:	83 c4 10             	add    $0x10,%esp
80103e4c:	8b 55 dc             	mov    -0x24(%ebp),%edx
80103e4f:	89 42 68             	mov    %eax,0x68(%edx)

  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
80103e52:	8b 45 e0             	mov    -0x20(%ebp),%eax
80103e55:	8d 50 6c             	lea    0x6c(%eax),%edx
80103e58:	8b 45 dc             	mov    -0x24(%ebp),%eax
80103e5b:	83 c0 6c             	add    $0x6c,%eax
80103e5e:	83 ec 04             	sub    $0x4,%esp
80103e61:	6a 10                	push   $0x10
80103e63:	52                   	push   %edx
80103e64:	50                   	push   %eax
80103e65:	e8 9c 0f 00 00       	call   80104e06 <safestrcpy>
80103e6a:	83 c4 10             	add    $0x10,%esp

  pid = np->pid;
80103e6d:	8b 45 dc             	mov    -0x24(%ebp),%eax
80103e70:	8b 40 10             	mov    0x10(%eax),%eax
80103e73:	89 45 d8             	mov    %eax,-0x28(%ebp)

  acquire(&ptable.lock);
80103e76:	83 ec 0c             	sub    $0xc,%esp
80103e79:	68 00 42 19 80       	push   $0x80194200
80103e7e:	e8 0a 0b 00 00       	call   8010498d <acquire>
80103e83:	83 c4 10             	add    $0x10,%esp

  np->state = RUNNABLE;
80103e86:	8b 45 dc             	mov    -0x24(%ebp),%eax
80103e89:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)

  release(&ptable.lock);
80103e90:	83 ec 0c             	sub    $0xc,%esp
80103e93:	68 00 42 19 80       	push   $0x80194200
80103e98:	e8 5e 0b 00 00       	call   801049fb <release>
80103e9d:	83 c4 10             	add    $0x10,%esp

  return pid;
80103ea0:	8b 45 d8             	mov    -0x28(%ebp),%eax
}
80103ea3:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103ea6:	5b                   	pop    %ebx
80103ea7:	5e                   	pop    %esi
80103ea8:	5f                   	pop    %edi
80103ea9:	5d                   	pop    %ebp
80103eaa:	c3                   	ret    

80103eab <exit>:
// Exit the current process.  Does not return.
// An exited process remains in the zombie state
// until its parent calls wait() to find out it exited.
void
exit(void)
{
80103eab:	55                   	push   %ebp
80103eac:	89 e5                	mov    %esp,%ebp
80103eae:	83 ec 18             	sub    $0x18,%esp
  struct proc *curproc = myproc();
80103eb1:	e8 7a fb ff ff       	call   80103a30 <myproc>
80103eb6:	89 45 ec             	mov    %eax,-0x14(%ebp)
  struct proc *p;
  int fd;

  if(curproc == initproc)
80103eb9:	a1 34 63 19 80       	mov    0x80196334,%eax
80103ebe:	39 45 ec             	cmp    %eax,-0x14(%ebp)
80103ec1:	75 0d                	jne    80103ed0 <exit+0x25>
    panic("init exiting");
80103ec3:	83 ec 0c             	sub    $0xc,%esp
80103ec6:	68 52 a5 10 80       	push   $0x8010a552
80103ecb:	e8 d9 c6 ff ff       	call   801005a9 <panic>

  // Close all open files.
  for(fd = 0; fd < NOFILE; fd++){
80103ed0:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
80103ed7:	eb 3f                	jmp    80103f18 <exit+0x6d>
    if(curproc->ofile[fd]){
80103ed9:	8b 45 ec             	mov    -0x14(%ebp),%eax
80103edc:	8b 55 f0             	mov    -0x10(%ebp),%edx
80103edf:	83 c2 08             	add    $0x8,%edx
80103ee2:	8b 44 90 08          	mov    0x8(%eax,%edx,4),%eax
80103ee6:	85 c0                	test   %eax,%eax
80103ee8:	74 2a                	je     80103f14 <exit+0x69>
      fileclose(curproc->ofile[fd]);
80103eea:	8b 45 ec             	mov    -0x14(%ebp),%eax
80103eed:	8b 55 f0             	mov    -0x10(%ebp),%edx
80103ef0:	83 c2 08             	add    $0x8,%edx
80103ef3:	8b 44 90 08          	mov    0x8(%eax,%edx,4),%eax
80103ef7:	83 ec 0c             	sub    $0xc,%esp
80103efa:	50                   	push   %eax
80103efb:	e8 9b d1 ff ff       	call   8010109b <fileclose>
80103f00:	83 c4 10             	add    $0x10,%esp
      curproc->ofile[fd] = 0;
80103f03:	8b 45 ec             	mov    -0x14(%ebp),%eax
80103f06:	8b 55 f0             	mov    -0x10(%ebp),%edx
80103f09:	83 c2 08             	add    $0x8,%edx
80103f0c:	c7 44 90 08 00 00 00 	movl   $0x0,0x8(%eax,%edx,4)
80103f13:	00 
  for(fd = 0; fd < NOFILE; fd++){
80103f14:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
80103f18:	83 7d f0 0f          	cmpl   $0xf,-0x10(%ebp)
80103f1c:	7e bb                	jle    80103ed9 <exit+0x2e>
    }
  }

  begin_op();
80103f1e:	e8 19 f1 ff ff       	call   8010303c <begin_op>
  iput(curproc->cwd);
80103f23:	8b 45 ec             	mov    -0x14(%ebp),%eax
80103f26:	8b 40 68             	mov    0x68(%eax),%eax
80103f29:	83 ec 0c             	sub    $0xc,%esp
80103f2c:	50                   	push   %eax
80103f2d:	e8 19 dc ff ff       	call   80101b4b <iput>
80103f32:	83 c4 10             	add    $0x10,%esp
  end_op();
80103f35:	e8 8e f1 ff ff       	call   801030c8 <end_op>
  curproc->cwd = 0;
80103f3a:	8b 45 ec             	mov    -0x14(%ebp),%eax
80103f3d:	c7 40 68 00 00 00 00 	movl   $0x0,0x68(%eax)

  acquire(&ptable.lock);
80103f44:	83 ec 0c             	sub    $0xc,%esp
80103f47:	68 00 42 19 80       	push   $0x80194200
80103f4c:	e8 3c 0a 00 00       	call   8010498d <acquire>
80103f51:	83 c4 10             	add    $0x10,%esp

  // Parent might be sleeping in wait().
  wakeup1(curproc->parent);
80103f54:	8b 45 ec             	mov    -0x14(%ebp),%eax
80103f57:	8b 40 14             	mov    0x14(%eax),%eax
80103f5a:	83 ec 0c             	sub    $0xc,%esp
80103f5d:	50                   	push   %eax
80103f5e:	e8 ad 06 00 00       	call   80104610 <wakeup1>
80103f63:	83 c4 10             	add    $0x10,%esp

  // Pass abandoned children to init.
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103f66:	c7 45 f4 34 42 19 80 	movl   $0x80194234,-0xc(%ebp)
80103f6d:	eb 3a                	jmp    80103fa9 <exit+0xfe>
    if(p->parent == curproc){
80103f6f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103f72:	8b 40 14             	mov    0x14(%eax),%eax
80103f75:	39 45 ec             	cmp    %eax,-0x14(%ebp)
80103f78:	75 28                	jne    80103fa2 <exit+0xf7>
      p->parent = initproc;
80103f7a:	8b 15 34 63 19 80    	mov    0x80196334,%edx
80103f80:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103f83:	89 50 14             	mov    %edx,0x14(%eax)
      if(p->state == ZOMBIE)
80103f86:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103f89:	8b 40 0c             	mov    0xc(%eax),%eax
80103f8c:	83 f8 05             	cmp    $0x5,%eax
80103f8f:	75 11                	jne    80103fa2 <exit+0xf7>
        wakeup1(initproc);
80103f91:	a1 34 63 19 80       	mov    0x80196334,%eax
80103f96:	83 ec 0c             	sub    $0xc,%esp
80103f99:	50                   	push   %eax
80103f9a:	e8 71 06 00 00       	call   80104610 <wakeup1>
80103f9f:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103fa2:	81 45 f4 84 00 00 00 	addl   $0x84,-0xc(%ebp)
80103fa9:	81 7d f4 34 63 19 80 	cmpl   $0x80196334,-0xc(%ebp)
80103fb0:	72 bd                	jb     80103f6f <exit+0xc4>
    }
  }

  // Jump into the scheduler, never to return.
  curproc->state = ZOMBIE;
80103fb2:	8b 45 ec             	mov    -0x14(%ebp),%eax
80103fb5:	c7 40 0c 05 00 00 00 	movl   $0x5,0xc(%eax)
  sched();
80103fbc:	e8 6f 04 00 00       	call   80104430 <sched>
  panic("zombie exit");
80103fc1:	83 ec 0c             	sub    $0xc,%esp
80103fc4:	68 5f a5 10 80       	push   $0x8010a55f
80103fc9:	e8 db c5 ff ff       	call   801005a9 <panic>

80103fce <uthread_init>:
}

int
uthread_init(int address){
80103fce:	55                   	push   %ebp
80103fcf:	89 e5                	mov    %esp,%ebp
	//require to implement
	return 0;
80103fd1:	b8 00 00 00 00       	mov    $0x0,%eax
}
80103fd6:	5d                   	pop    %ebp
80103fd7:	c3                   	ret    

80103fd8 <exit2>:
//******************************************
//************   new  **********************
//************ eixt2() *********************
//******************************************
void
exit2(int status){
80103fd8:	55                   	push   %ebp
80103fd9:	89 e5                	mov    %esp,%ebp
80103fdb:	83 ec 18             	sub    $0x18,%esp
  struct proc *curproc = myproc();
80103fde:	e8 4d fa ff ff       	call   80103a30 <myproc>
80103fe3:	89 45 ec             	mov    %eax,-0x14(%ebp)
  struct proc *p;
  int fd;
 
  //***********새로 추가된 부분. Copy status to xstate**********
  curproc->parent->xstate = status;
80103fe6:	8b 45 ec             	mov    -0x14(%ebp),%eax
80103fe9:	8b 40 14             	mov    0x14(%eax),%eax
80103fec:	8b 55 08             	mov    0x8(%ebp),%edx
80103fef:	89 50 7c             	mov    %edx,0x7c(%eax)
  //************************************************************

  if(curproc == initproc)
80103ff2:	a1 34 63 19 80       	mov    0x80196334,%eax
80103ff7:	39 45 ec             	cmp    %eax,-0x14(%ebp)
80103ffa:	75 0d                	jne    80104009 <exit2+0x31>
    panic("init exiting");
80103ffc:	83 ec 0c             	sub    $0xc,%esp
80103fff:	68 52 a5 10 80       	push   $0x8010a552
80104004:	e8 a0 c5 ff ff       	call   801005a9 <panic>

  // Close all open files.
  for(fd = 0; fd < NOFILE; fd++){
80104009:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
80104010:	eb 3f                	jmp    80104051 <exit2+0x79>
    if(curproc->ofile[fd]){
80104012:	8b 45 ec             	mov    -0x14(%ebp),%eax
80104015:	8b 55 f0             	mov    -0x10(%ebp),%edx
80104018:	83 c2 08             	add    $0x8,%edx
8010401b:	8b 44 90 08          	mov    0x8(%eax,%edx,4),%eax
8010401f:	85 c0                	test   %eax,%eax
80104021:	74 2a                	je     8010404d <exit2+0x75>
      fileclose(curproc->ofile[fd]);
80104023:	8b 45 ec             	mov    -0x14(%ebp),%eax
80104026:	8b 55 f0             	mov    -0x10(%ebp),%edx
80104029:	83 c2 08             	add    $0x8,%edx
8010402c:	8b 44 90 08          	mov    0x8(%eax,%edx,4),%eax
80104030:	83 ec 0c             	sub    $0xc,%esp
80104033:	50                   	push   %eax
80104034:	e8 62 d0 ff ff       	call   8010109b <fileclose>
80104039:	83 c4 10             	add    $0x10,%esp
      curproc->ofile[fd] = 0;
8010403c:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010403f:	8b 55 f0             	mov    -0x10(%ebp),%edx
80104042:	83 c2 08             	add    $0x8,%edx
80104045:	c7 44 90 08 00 00 00 	movl   $0x0,0x8(%eax,%edx,4)
8010404c:	00 
  for(fd = 0; fd < NOFILE; fd++){
8010404d:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
80104051:	83 7d f0 0f          	cmpl   $0xf,-0x10(%ebp)
80104055:	7e bb                	jle    80104012 <exit2+0x3a>
    }
  }

  begin_op();
80104057:	e8 e0 ef ff ff       	call   8010303c <begin_op>
  iput(curproc->cwd);
8010405c:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010405f:	8b 40 68             	mov    0x68(%eax),%eax
80104062:	83 ec 0c             	sub    $0xc,%esp
80104065:	50                   	push   %eax
80104066:	e8 e0 da ff ff       	call   80101b4b <iput>
8010406b:	83 c4 10             	add    $0x10,%esp
  end_op();
8010406e:	e8 55 f0 ff ff       	call   801030c8 <end_op>
  curproc->cwd = 0;
80104073:	8b 45 ec             	mov    -0x14(%ebp),%eax
80104076:	c7 40 68 00 00 00 00 	movl   $0x0,0x68(%eax)

  acquire(&ptable.lock);
8010407d:	83 ec 0c             	sub    $0xc,%esp
80104080:	68 00 42 19 80       	push   $0x80194200
80104085:	e8 03 09 00 00       	call   8010498d <acquire>
8010408a:	83 c4 10             	add    $0x10,%esp

  // Parent might be sleeping in wait().
  wakeup1(curproc->parent);
8010408d:	8b 45 ec             	mov    -0x14(%ebp),%eax
80104090:	8b 40 14             	mov    0x14(%eax),%eax
80104093:	83 ec 0c             	sub    $0xc,%esp
80104096:	50                   	push   %eax
80104097:	e8 74 05 00 00       	call   80104610 <wakeup1>
8010409c:	83 c4 10             	add    $0x10,%esp

  // Pass abandoned children to init.
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
8010409f:	c7 45 f4 34 42 19 80 	movl   $0x80194234,-0xc(%ebp)
801040a6:	eb 3a                	jmp    801040e2 <exit2+0x10a>
    if(p->parent == curproc){
801040a8:	8b 45 f4             	mov    -0xc(%ebp),%eax
801040ab:	8b 40 14             	mov    0x14(%eax),%eax
801040ae:	39 45 ec             	cmp    %eax,-0x14(%ebp)
801040b1:	75 28                	jne    801040db <exit2+0x103>
      p->parent = initproc;
801040b3:	8b 15 34 63 19 80    	mov    0x80196334,%edx
801040b9:	8b 45 f4             	mov    -0xc(%ebp),%eax
801040bc:	89 50 14             	mov    %edx,0x14(%eax)
      if(p->state == ZOMBIE)
801040bf:	8b 45 f4             	mov    -0xc(%ebp),%eax
801040c2:	8b 40 0c             	mov    0xc(%eax),%eax
801040c5:	83 f8 05             	cmp    $0x5,%eax
801040c8:	75 11                	jne    801040db <exit2+0x103>
        wakeup1(initproc);
801040ca:	a1 34 63 19 80       	mov    0x80196334,%eax
801040cf:	83 ec 0c             	sub    $0xc,%esp
801040d2:	50                   	push   %eax
801040d3:	e8 38 05 00 00       	call   80104610 <wakeup1>
801040d8:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801040db:	81 45 f4 84 00 00 00 	addl   $0x84,-0xc(%ebp)
801040e2:	81 7d f4 34 63 19 80 	cmpl   $0x80196334,-0xc(%ebp)
801040e9:	72 bd                	jb     801040a8 <exit2+0xd0>
    }
  }

  // Jump into the scheduler, never to return.
  curproc->state = ZOMBIE;
801040eb:	8b 45 ec             	mov    -0x14(%ebp),%eax
801040ee:	c7 40 0c 05 00 00 00 	movl   $0x5,0xc(%eax)
  sched();
801040f5:	e8 36 03 00 00       	call   80104430 <sched>
  panic("zombie exit");
801040fa:	83 ec 0c             	sub    $0xc,%esp
801040fd:	68 5f a5 10 80       	push   $0x8010a55f
80104102:	e8 a2 c4 ff ff       	call   801005a9 <panic>

80104107 <wait>:

// Wait for a child process to exit and return its pid.
// Return -1 if this process has no children.
int
wait(void)
{
80104107:	55                   	push   %ebp
80104108:	89 e5                	mov    %esp,%ebp
8010410a:	83 ec 18             	sub    $0x18,%esp
  struct proc *p;
  int havekids, pid;
  struct proc *curproc = myproc();
8010410d:	e8 1e f9 ff ff       	call   80103a30 <myproc>
80104112:	89 45 ec             	mov    %eax,-0x14(%ebp)
  
  acquire(&ptable.lock);
80104115:	83 ec 0c             	sub    $0xc,%esp
80104118:	68 00 42 19 80       	push   $0x80194200
8010411d:	e8 6b 08 00 00       	call   8010498d <acquire>
80104122:	83 c4 10             	add    $0x10,%esp
  for(;;){
    // Scan through table looking for exited children.
    havekids = 0;
80104125:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
8010412c:	c7 45 f4 34 42 19 80 	movl   $0x80194234,-0xc(%ebp)
80104133:	e9 a4 00 00 00       	jmp    801041dc <wait+0xd5>
      if(p->parent != curproc)
80104138:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010413b:	8b 40 14             	mov    0x14(%eax),%eax
8010413e:	39 45 ec             	cmp    %eax,-0x14(%ebp)
80104141:	0f 85 8d 00 00 00    	jne    801041d4 <wait+0xcd>
        continue;
      havekids = 1;
80104147:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
      if(p->state == ZOMBIE){
8010414e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104151:	8b 40 0c             	mov    0xc(%eax),%eax
80104154:	83 f8 05             	cmp    $0x5,%eax
80104157:	75 7c                	jne    801041d5 <wait+0xce>
        // Found one.
        pid = p->pid;
80104159:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010415c:	8b 40 10             	mov    0x10(%eax),%eax
8010415f:	89 45 e8             	mov    %eax,-0x18(%ebp)
        kfree(p->kstack);
80104162:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104165:	8b 40 08             	mov    0x8(%eax),%eax
80104168:	83 ec 0c             	sub    $0xc,%esp
8010416b:	50                   	push   %eax
8010416c:	e8 95 e5 ff ff       	call   80102706 <kfree>
80104171:	83 c4 10             	add    $0x10,%esp
        p->kstack = 0;
80104174:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104177:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
        freevm(p->pgdir);
8010417e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104181:	8b 40 04             	mov    0x4(%eax),%eax
80104184:	83 ec 0c             	sub    $0xc,%esp
80104187:	50                   	push   %eax
80104188:	e8 8e 39 00 00       	call   80107b1b <freevm>
8010418d:	83 c4 10             	add    $0x10,%esp
        p->pid = 0;
80104190:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104193:	c7 40 10 00 00 00 00 	movl   $0x0,0x10(%eax)
        p->parent = 0;
8010419a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010419d:	c7 40 14 00 00 00 00 	movl   $0x0,0x14(%eax)
        p->name[0] = 0;
801041a4:	8b 45 f4             	mov    -0xc(%ebp),%eax
801041a7:	c6 40 6c 00          	movb   $0x0,0x6c(%eax)
        p->killed = 0;
801041ab:	8b 45 f4             	mov    -0xc(%ebp),%eax
801041ae:	c7 40 24 00 00 00 00 	movl   $0x0,0x24(%eax)
        p->state = UNUSED;
801041b5:	8b 45 f4             	mov    -0xc(%ebp),%eax
801041b8:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
        release(&ptable.lock);
801041bf:	83 ec 0c             	sub    $0xc,%esp
801041c2:	68 00 42 19 80       	push   $0x80194200
801041c7:	e8 2f 08 00 00       	call   801049fb <release>
801041cc:	83 c4 10             	add    $0x10,%esp
        return pid;
801041cf:	8b 45 e8             	mov    -0x18(%ebp),%eax
801041d2:	eb 54                	jmp    80104228 <wait+0x121>
        continue;
801041d4:	90                   	nop
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801041d5:	81 45 f4 84 00 00 00 	addl   $0x84,-0xc(%ebp)
801041dc:	81 7d f4 34 63 19 80 	cmpl   $0x80196334,-0xc(%ebp)
801041e3:	0f 82 4f ff ff ff    	jb     80104138 <wait+0x31>
      }
    }

    // No point waiting if we don't have any children.
    if(!havekids || curproc->killed){
801041e9:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
801041ed:	74 0a                	je     801041f9 <wait+0xf2>
801041ef:	8b 45 ec             	mov    -0x14(%ebp),%eax
801041f2:	8b 40 24             	mov    0x24(%eax),%eax
801041f5:	85 c0                	test   %eax,%eax
801041f7:	74 17                	je     80104210 <wait+0x109>
      release(&ptable.lock);
801041f9:	83 ec 0c             	sub    $0xc,%esp
801041fc:	68 00 42 19 80       	push   $0x80194200
80104201:	e8 f5 07 00 00       	call   801049fb <release>
80104206:	83 c4 10             	add    $0x10,%esp
      return -1;
80104209:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010420e:	eb 18                	jmp    80104228 <wait+0x121>
    }

    // Wait for children to exit.  (See wakeup1 call in proc_exit.)
    sleep(curproc, &ptable.lock);  //DOC: wait-sleep
80104210:	83 ec 08             	sub    $0x8,%esp
80104213:	68 00 42 19 80       	push   $0x80194200
80104218:	ff 75 ec             	push   -0x14(%ebp)
8010421b:	e8 49 03 00 00       	call   80104569 <sleep>
80104220:	83 c4 10             	add    $0x10,%esp
    havekids = 0;
80104223:	e9 fd fe ff ff       	jmp    80104125 <wait+0x1e>
  }
}
80104228:	c9                   	leave  
80104229:	c3                   	ret    

8010422a <wait2>:
//******************************************
//************   new  **********************
//************ wait2() *********************
//******************************************
int
wait2(int *status){
8010422a:	55                   	push   %ebp
8010422b:	89 e5                	mov    %esp,%ebp
8010422d:	83 ec 18             	sub    $0x18,%esp

  struct proc *p;
  int havekids, pid;
  struct proc *curproc = myproc();
80104230:	e8 fb f7 ff ff       	call   80103a30 <myproc>
80104235:	89 45 ec             	mov    %eax,-0x14(%ebp)
 
  
  acquire(&ptable.lock);
80104238:	83 ec 0c             	sub    $0xc,%esp
8010423b:	68 00 42 19 80       	push   $0x80194200
80104240:	e8 48 07 00 00       	call   8010498d <acquire>
80104245:	83 c4 10             	add    $0x10,%esp
  for(;;){
    // Scan through table looking for exited children.
    havekids = 0;
80104248:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
8010424f:	c7 45 f4 34 42 19 80 	movl   $0x80194234,-0xc(%ebp)
80104256:	e9 a4 00 00 00       	jmp    801042ff <wait2+0xd5>
      if(p->parent != curproc)
8010425b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010425e:	8b 40 14             	mov    0x14(%eax),%eax
80104261:	39 45 ec             	cmp    %eax,-0x14(%ebp)
80104264:	0f 85 8d 00 00 00    	jne    801042f7 <wait2+0xcd>
        continue;
      havekids = 1;
8010426a:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
      if(p->state == ZOMBIE){
80104271:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104274:	8b 40 0c             	mov    0xc(%eax),%eax
80104277:	83 f8 05             	cmp    $0x5,%eax
8010427a:	75 7c                	jne    801042f8 <wait2+0xce>
        // Found one.
        pid = p->pid;
8010427c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010427f:	8b 40 10             	mov    0x10(%eax),%eax
80104282:	89 45 e8             	mov    %eax,-0x18(%ebp)
        kfree(p->kstack);
80104285:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104288:	8b 40 08             	mov    0x8(%eax),%eax
8010428b:	83 ec 0c             	sub    $0xc,%esp
8010428e:	50                   	push   %eax
8010428f:	e8 72 e4 ff ff       	call   80102706 <kfree>
80104294:	83 c4 10             	add    $0x10,%esp
        p->kstack = 0;
80104297:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010429a:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
        freevm(p->pgdir);
801042a1:	8b 45 f4             	mov    -0xc(%ebp),%eax
801042a4:	8b 40 04             	mov    0x4(%eax),%eax
801042a7:	83 ec 0c             	sub    $0xc,%esp
801042aa:	50                   	push   %eax
801042ab:	e8 6b 38 00 00       	call   80107b1b <freevm>
801042b0:	83 c4 10             	add    $0x10,%esp
        p->pid = 0;
801042b3:	8b 45 f4             	mov    -0xc(%ebp),%eax
801042b6:	c7 40 10 00 00 00 00 	movl   $0x0,0x10(%eax)
        p->parent = 0;
801042bd:	8b 45 f4             	mov    -0xc(%ebp),%eax
801042c0:	c7 40 14 00 00 00 00 	movl   $0x0,0x14(%eax)
        p->name[0] = 0;
801042c7:	8b 45 f4             	mov    -0xc(%ebp),%eax
801042ca:	c6 40 6c 00          	movb   $0x0,0x6c(%eax)
        p->killed = 0;
801042ce:	8b 45 f4             	mov    -0xc(%ebp),%eax
801042d1:	c7 40 24 00 00 00 00 	movl   $0x0,0x24(%eax)
        p->state = UNUSED;
801042d8:	8b 45 f4             	mov    -0xc(%ebp),%eax
801042db:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
        release(&ptable.lock);
801042e2:	83 ec 0c             	sub    $0xc,%esp
801042e5:	68 00 42 19 80       	push   $0x80194200
801042ea:	e8 0c 07 00 00       	call   801049fb <release>
801042ef:	83 c4 10             	add    $0x10,%esp
        return pid;
801042f2:	8b 45 e8             	mov    -0x18(%ebp),%eax
801042f5:	eb 7c                	jmp    80104373 <wait2+0x149>
        continue;
801042f7:	90                   	nop
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801042f8:	81 45 f4 84 00 00 00 	addl   $0x84,-0xc(%ebp)
801042ff:	81 7d f4 34 63 19 80 	cmpl   $0x80196334,-0xc(%ebp)
80104306:	0f 82 4f ff ff ff    	jb     8010425b <wait2+0x31>
      }
    }

    // No point waiting if we don't have any children.
    if(!havekids || curproc->killed){
8010430c:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80104310:	74 0a                	je     8010431c <wait2+0xf2>
80104312:	8b 45 ec             	mov    -0x14(%ebp),%eax
80104315:	8b 40 24             	mov    0x24(%eax),%eax
80104318:	85 c0                	test   %eax,%eax
8010431a:	74 17                	je     80104333 <wait2+0x109>
      release(&ptable.lock);
8010431c:	83 ec 0c             	sub    $0xc,%esp
8010431f:	68 00 42 19 80       	push   $0x80194200
80104324:	e8 d2 06 00 00       	call   801049fb <release>
80104329:	83 c4 10             	add    $0x10,%esp
      return -1;
8010432c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104331:	eb 40                	jmp    80104373 <wait2+0x149>
    }

    sleep(curproc, &ptable.lock);  //DOC: wait-sleep
80104333:	83 ec 08             	sub    $0x8,%esp
80104336:	68 00 42 19 80       	push   $0x80194200
8010433b:	ff 75 ec             	push   -0x14(%ebp)
8010433e:	e8 26 02 00 00       	call   80104569 <sleep>
80104343:	83 c4 10             	add    $0x10,%esp
  // copyout(pde_t *pgdir, uint va, void *p, uint len)와 같이 정의됨
  // p 주소의 len 길이만큼을 복사해서 pgdir의 va에 넣는다.
  // 만약 올바른 값이 아니라면 -1을 리턴
  // Wait for children to exit.  (See wakeup1 call in proc_exit.)
  // wakeup되면 마저 실행하는 코드
    if (copyout(curproc->pgdir, *status, &(curproc->xstate), sizeof(int)) < 0)
80104346:	8b 45 ec             	mov    -0x14(%ebp),%eax
80104349:	8d 50 7c             	lea    0x7c(%eax),%edx
8010434c:	8b 45 08             	mov    0x8(%ebp),%eax
8010434f:	8b 00                	mov    (%eax),%eax
80104351:	89 c1                	mov    %eax,%ecx
80104353:	8b 45 ec             	mov    -0x14(%ebp),%eax
80104356:	8b 40 04             	mov    0x4(%eax),%eax
80104359:	6a 04                	push   $0x4
8010435b:	52                   	push   %edx
8010435c:	51                   	push   %ecx
8010435d:	50                   	push   %eax
8010435e:	e8 f0 39 00 00       	call   80107d53 <copyout>
80104363:	83 c4 10             	add    $0x10,%esp
80104366:	85 c0                	test   %eax,%eax
80104368:	0f 89 da fe ff ff    	jns    80104248 <wait2+0x1e>
	    return -1;
8010436e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
				     
  }
}
80104373:	c9                   	leave  
80104374:	c3                   	ret    

80104375 <scheduler>:
//  - swtch to start running that process
//  - eventually that process transfers control
//      via swtch back to the scheduler.
void
scheduler(void)
{
80104375:	55                   	push   %ebp
80104376:	89 e5                	mov    %esp,%ebp
80104378:	83 ec 18             	sub    $0x18,%esp
  struct proc *p;
  struct cpu *c = mycpu();
8010437b:	e8 38 f6 ff ff       	call   801039b8 <mycpu>
80104380:	89 45 f0             	mov    %eax,-0x10(%ebp)
  c->proc = 0;
80104383:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104386:	c7 80 ac 00 00 00 00 	movl   $0x0,0xac(%eax)
8010438d:	00 00 00 
  
  for(;;){
    // Enable interrupts on this processor.
    sti();
80104390:	e8 e3 f5 ff ff       	call   80103978 <sti>

    // Loop over process table looking for process to run.
    acquire(&ptable.lock);
80104395:	83 ec 0c             	sub    $0xc,%esp
80104398:	68 00 42 19 80       	push   $0x80194200
8010439d:	e8 eb 05 00 00       	call   8010498d <acquire>
801043a2:	83 c4 10             	add    $0x10,%esp
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801043a5:	c7 45 f4 34 42 19 80 	movl   $0x80194234,-0xc(%ebp)
801043ac:	eb 64                	jmp    80104412 <scheduler+0x9d>
      if(p->state != RUNNABLE)
801043ae:	8b 45 f4             	mov    -0xc(%ebp),%eax
801043b1:	8b 40 0c             	mov    0xc(%eax),%eax
801043b4:	83 f8 03             	cmp    $0x3,%eax
801043b7:	75 51                	jne    8010440a <scheduler+0x95>
        continue;

      // Switch to chosen process.  It is the process's job
      // to release ptable.lock and then reacquire it
      // before jumping back to us.
      c->proc = p;
801043b9:	8b 45 f0             	mov    -0x10(%ebp),%eax
801043bc:	8b 55 f4             	mov    -0xc(%ebp),%edx
801043bf:	89 90 ac 00 00 00    	mov    %edx,0xac(%eax)
      switchuvm(p);
801043c5:	83 ec 0c             	sub    $0xc,%esp
801043c8:	ff 75 f4             	push   -0xc(%ebp)
801043cb:	e8 a6 32 00 00       	call   80107676 <switchuvm>
801043d0:	83 c4 10             	add    $0x10,%esp
      p->state = RUNNING;
801043d3:	8b 45 f4             	mov    -0xc(%ebp),%eax
801043d6:	c7 40 0c 04 00 00 00 	movl   $0x4,0xc(%eax)

      swtch(&(c->scheduler), p->context);
801043dd:	8b 45 f4             	mov    -0xc(%ebp),%eax
801043e0:	8b 40 1c             	mov    0x1c(%eax),%eax
801043e3:	8b 55 f0             	mov    -0x10(%ebp),%edx
801043e6:	83 c2 04             	add    $0x4,%edx
801043e9:	83 ec 08             	sub    $0x8,%esp
801043ec:	50                   	push   %eax
801043ed:	52                   	push   %edx
801043ee:	e8 85 0a 00 00       	call   80104e78 <swtch>
801043f3:	83 c4 10             	add    $0x10,%esp
      switchkvm();
801043f6:	e8 62 32 00 00       	call   8010765d <switchkvm>

      // Process is done running for now.
      // It should have changed its p->state before coming back.
      c->proc = 0;
801043fb:	8b 45 f0             	mov    -0x10(%ebp),%eax
801043fe:	c7 80 ac 00 00 00 00 	movl   $0x0,0xac(%eax)
80104405:	00 00 00 
80104408:	eb 01                	jmp    8010440b <scheduler+0x96>
        continue;
8010440a:	90                   	nop
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
8010440b:	81 45 f4 84 00 00 00 	addl   $0x84,-0xc(%ebp)
80104412:	81 7d f4 34 63 19 80 	cmpl   $0x80196334,-0xc(%ebp)
80104419:	72 93                	jb     801043ae <scheduler+0x39>
    }
    release(&ptable.lock);
8010441b:	83 ec 0c             	sub    $0xc,%esp
8010441e:	68 00 42 19 80       	push   $0x80194200
80104423:	e8 d3 05 00 00       	call   801049fb <release>
80104428:	83 c4 10             	add    $0x10,%esp
    sti();
8010442b:	e9 60 ff ff ff       	jmp    80104390 <scheduler+0x1b>

80104430 <sched>:
// be proc->intena and proc->ncli, but that would
// break in the few places where a lock is held but
// there's no process.
void
sched(void)
{
80104430:	55                   	push   %ebp
80104431:	89 e5                	mov    %esp,%ebp
80104433:	83 ec 18             	sub    $0x18,%esp
  int intena;
  struct proc *p = myproc();
80104436:	e8 f5 f5 ff ff       	call   80103a30 <myproc>
8010443b:	89 45 f4             	mov    %eax,-0xc(%ebp)

  if(!holding(&ptable.lock))
8010443e:	83 ec 0c             	sub    $0xc,%esp
80104441:	68 00 42 19 80       	push   $0x80194200
80104446:	e8 7d 06 00 00       	call   80104ac8 <holding>
8010444b:	83 c4 10             	add    $0x10,%esp
8010444e:	85 c0                	test   %eax,%eax
80104450:	75 0d                	jne    8010445f <sched+0x2f>
    panic("sched ptable.lock");
80104452:	83 ec 0c             	sub    $0xc,%esp
80104455:	68 6b a5 10 80       	push   $0x8010a56b
8010445a:	e8 4a c1 ff ff       	call   801005a9 <panic>
  if(mycpu()->ncli != 1)
8010445f:	e8 54 f5 ff ff       	call   801039b8 <mycpu>
80104464:	8b 80 a4 00 00 00    	mov    0xa4(%eax),%eax
8010446a:	83 f8 01             	cmp    $0x1,%eax
8010446d:	74 0d                	je     8010447c <sched+0x4c>
    panic("sched locks");
8010446f:	83 ec 0c             	sub    $0xc,%esp
80104472:	68 7d a5 10 80       	push   $0x8010a57d
80104477:	e8 2d c1 ff ff       	call   801005a9 <panic>
  if(p->state == RUNNING)
8010447c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010447f:	8b 40 0c             	mov    0xc(%eax),%eax
80104482:	83 f8 04             	cmp    $0x4,%eax
80104485:	75 0d                	jne    80104494 <sched+0x64>
    panic("sched running");
80104487:	83 ec 0c             	sub    $0xc,%esp
8010448a:	68 89 a5 10 80       	push   $0x8010a589
8010448f:	e8 15 c1 ff ff       	call   801005a9 <panic>
  if(readeflags()&FL_IF)
80104494:	e8 cf f4 ff ff       	call   80103968 <readeflags>
80104499:	25 00 02 00 00       	and    $0x200,%eax
8010449e:	85 c0                	test   %eax,%eax
801044a0:	74 0d                	je     801044af <sched+0x7f>
    panic("sched interruptible");
801044a2:	83 ec 0c             	sub    $0xc,%esp
801044a5:	68 97 a5 10 80       	push   $0x8010a597
801044aa:	e8 fa c0 ff ff       	call   801005a9 <panic>
  intena = mycpu()->intena;
801044af:	e8 04 f5 ff ff       	call   801039b8 <mycpu>
801044b4:	8b 80 a8 00 00 00    	mov    0xa8(%eax),%eax
801044ba:	89 45 f0             	mov    %eax,-0x10(%ebp)
  swtch(&p->context, mycpu()->scheduler);
801044bd:	e8 f6 f4 ff ff       	call   801039b8 <mycpu>
801044c2:	8b 40 04             	mov    0x4(%eax),%eax
801044c5:	8b 55 f4             	mov    -0xc(%ebp),%edx
801044c8:	83 c2 1c             	add    $0x1c,%edx
801044cb:	83 ec 08             	sub    $0x8,%esp
801044ce:	50                   	push   %eax
801044cf:	52                   	push   %edx
801044d0:	e8 a3 09 00 00       	call   80104e78 <swtch>
801044d5:	83 c4 10             	add    $0x10,%esp
  mycpu()->intena = intena;
801044d8:	e8 db f4 ff ff       	call   801039b8 <mycpu>
801044dd:	8b 55 f0             	mov    -0x10(%ebp),%edx
801044e0:	89 90 a8 00 00 00    	mov    %edx,0xa8(%eax)
}
801044e6:	90                   	nop
801044e7:	c9                   	leave  
801044e8:	c3                   	ret    

801044e9 <yield>:

// Give up the CPU for one scheduling round.
void
yield(void)
{
801044e9:	55                   	push   %ebp
801044ea:	89 e5                	mov    %esp,%ebp
801044ec:	83 ec 08             	sub    $0x8,%esp
  acquire(&ptable.lock);  //DOC: yieldlock
801044ef:	83 ec 0c             	sub    $0xc,%esp
801044f2:	68 00 42 19 80       	push   $0x80194200
801044f7:	e8 91 04 00 00       	call   8010498d <acquire>
801044fc:	83 c4 10             	add    $0x10,%esp
  myproc()->state = RUNNABLE;
801044ff:	e8 2c f5 ff ff       	call   80103a30 <myproc>
80104504:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
  sched();
8010450b:	e8 20 ff ff ff       	call   80104430 <sched>
  release(&ptable.lock);
80104510:	83 ec 0c             	sub    $0xc,%esp
80104513:	68 00 42 19 80       	push   $0x80194200
80104518:	e8 de 04 00 00       	call   801049fb <release>
8010451d:	83 c4 10             	add    $0x10,%esp
}
80104520:	90                   	nop
80104521:	c9                   	leave  
80104522:	c3                   	ret    

80104523 <forkret>:

// A fork child's very first scheduling by scheduler()
// will swtch here.  "Return" to user space.
void
forkret(void)
{
80104523:	55                   	push   %ebp
80104524:	89 e5                	mov    %esp,%ebp
80104526:	83 ec 08             	sub    $0x8,%esp
  static int first = 1;
  // Still holding ptable.lock from scheduler.
  release(&ptable.lock);
80104529:	83 ec 0c             	sub    $0xc,%esp
8010452c:	68 00 42 19 80       	push   $0x80194200
80104531:	e8 c5 04 00 00       	call   801049fb <release>
80104536:	83 c4 10             	add    $0x10,%esp

  if (first) {
80104539:	a1 04 f0 10 80       	mov    0x8010f004,%eax
8010453e:	85 c0                	test   %eax,%eax
80104540:	74 24                	je     80104566 <forkret+0x43>
    // Some initialization functions must be run in the context
    // of a regular process (e.g., they call sleep), and thus cannot
    // be run from main().
    first = 0;
80104542:	c7 05 04 f0 10 80 00 	movl   $0x0,0x8010f004
80104549:	00 00 00 
    iinit(ROOTDEV);
8010454c:	83 ec 0c             	sub    $0xc,%esp
8010454f:	6a 01                	push   $0x1
80104551:	e8 22 d1 ff ff       	call   80101678 <iinit>
80104556:	83 c4 10             	add    $0x10,%esp
    initlog(ROOTDEV);
80104559:	83 ec 0c             	sub    $0xc,%esp
8010455c:	6a 01                	push   $0x1
8010455e:	e8 ba e8 ff ff       	call   80102e1d <initlog>
80104563:	83 c4 10             	add    $0x10,%esp
  }

  // Return to "caller", actually trapret (see allocproc).
}
80104566:	90                   	nop
80104567:	c9                   	leave  
80104568:	c3                   	ret    

80104569 <sleep>:

// Atomically release lock and sleep on chan.
// Reacquires lock when awakened.
void
sleep(void *chan, struct spinlock *lk)
{
80104569:	55                   	push   %ebp
8010456a:	89 e5                	mov    %esp,%ebp
8010456c:	83 ec 18             	sub    $0x18,%esp
  struct proc *p = myproc();
8010456f:	e8 bc f4 ff ff       	call   80103a30 <myproc>
80104574:	89 45 f4             	mov    %eax,-0xc(%ebp)
  
  if(p == 0)
80104577:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
8010457b:	75 0d                	jne    8010458a <sleep+0x21>
    panic("sleep");
8010457d:	83 ec 0c             	sub    $0xc,%esp
80104580:	68 ab a5 10 80       	push   $0x8010a5ab
80104585:	e8 1f c0 ff ff       	call   801005a9 <panic>

  if(lk == 0)
8010458a:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
8010458e:	75 0d                	jne    8010459d <sleep+0x34>
    panic("sleep without lk");
80104590:	83 ec 0c             	sub    $0xc,%esp
80104593:	68 b1 a5 10 80       	push   $0x8010a5b1
80104598:	e8 0c c0 ff ff       	call   801005a9 <panic>
  // change p->state and then call sched.
  // Once we hold ptable.lock, we can be
  // guaranteed that we won't miss any wakeup
  // (wakeup runs with ptable.lock locked),
  // so it's okay to release lk.
  if(lk != &ptable.lock){  //DOC: sleeplock0
8010459d:	81 7d 0c 00 42 19 80 	cmpl   $0x80194200,0xc(%ebp)
801045a4:	74 1e                	je     801045c4 <sleep+0x5b>
    acquire(&ptable.lock);  //DOC: sleeplock1
801045a6:	83 ec 0c             	sub    $0xc,%esp
801045a9:	68 00 42 19 80       	push   $0x80194200
801045ae:	e8 da 03 00 00       	call   8010498d <acquire>
801045b3:	83 c4 10             	add    $0x10,%esp
    release(lk);
801045b6:	83 ec 0c             	sub    $0xc,%esp
801045b9:	ff 75 0c             	push   0xc(%ebp)
801045bc:	e8 3a 04 00 00       	call   801049fb <release>
801045c1:	83 c4 10             	add    $0x10,%esp
  }
  // Go to sleep.
  p->chan = chan;
801045c4:	8b 45 f4             	mov    -0xc(%ebp),%eax
801045c7:	8b 55 08             	mov    0x8(%ebp),%edx
801045ca:	89 50 20             	mov    %edx,0x20(%eax)
  p->state = SLEEPING;
801045cd:	8b 45 f4             	mov    -0xc(%ebp),%eax
801045d0:	c7 40 0c 02 00 00 00 	movl   $0x2,0xc(%eax)

  sched();
801045d7:	e8 54 fe ff ff       	call   80104430 <sched>

  // Tidy up.
  p->chan = 0;
801045dc:	8b 45 f4             	mov    -0xc(%ebp),%eax
801045df:	c7 40 20 00 00 00 00 	movl   $0x0,0x20(%eax)

  // Reacquire original lock.
  if(lk != &ptable.lock){  //DOC: sleeplock2
801045e6:	81 7d 0c 00 42 19 80 	cmpl   $0x80194200,0xc(%ebp)
801045ed:	74 1e                	je     8010460d <sleep+0xa4>
    release(&ptable.lock);
801045ef:	83 ec 0c             	sub    $0xc,%esp
801045f2:	68 00 42 19 80       	push   $0x80194200
801045f7:	e8 ff 03 00 00       	call   801049fb <release>
801045fc:	83 c4 10             	add    $0x10,%esp
    acquire(lk);
801045ff:	83 ec 0c             	sub    $0xc,%esp
80104602:	ff 75 0c             	push   0xc(%ebp)
80104605:	e8 83 03 00 00       	call   8010498d <acquire>
8010460a:	83 c4 10             	add    $0x10,%esp
  }
}
8010460d:	90                   	nop
8010460e:	c9                   	leave  
8010460f:	c3                   	ret    

80104610 <wakeup1>:
//PAGEBREAK!
// Wake up all processes sleeping on chan.
// The ptable lock must be held.
static void
wakeup1(void *chan)
{
80104610:	55                   	push   %ebp
80104611:	89 e5                	mov    %esp,%ebp
80104613:	83 ec 10             	sub    $0x10,%esp
  struct proc *p;

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104616:	c7 45 fc 34 42 19 80 	movl   $0x80194234,-0x4(%ebp)
8010461d:	eb 27                	jmp    80104646 <wakeup1+0x36>
    if(p->state == SLEEPING && p->chan == chan)
8010461f:	8b 45 fc             	mov    -0x4(%ebp),%eax
80104622:	8b 40 0c             	mov    0xc(%eax),%eax
80104625:	83 f8 02             	cmp    $0x2,%eax
80104628:	75 15                	jne    8010463f <wakeup1+0x2f>
8010462a:	8b 45 fc             	mov    -0x4(%ebp),%eax
8010462d:	8b 40 20             	mov    0x20(%eax),%eax
80104630:	39 45 08             	cmp    %eax,0x8(%ebp)
80104633:	75 0a                	jne    8010463f <wakeup1+0x2f>
      p->state = RUNNABLE;
80104635:	8b 45 fc             	mov    -0x4(%ebp),%eax
80104638:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
8010463f:	81 45 fc 84 00 00 00 	addl   $0x84,-0x4(%ebp)
80104646:	81 7d fc 34 63 19 80 	cmpl   $0x80196334,-0x4(%ebp)
8010464d:	72 d0                	jb     8010461f <wakeup1+0xf>
}
8010464f:	90                   	nop
80104650:	90                   	nop
80104651:	c9                   	leave  
80104652:	c3                   	ret    

80104653 <wakeup>:

// Wake up all processes sleeping on chan.
void
wakeup(void *chan)
{
80104653:	55                   	push   %ebp
80104654:	89 e5                	mov    %esp,%ebp
80104656:	83 ec 08             	sub    $0x8,%esp
  acquire(&ptable.lock);
80104659:	83 ec 0c             	sub    $0xc,%esp
8010465c:	68 00 42 19 80       	push   $0x80194200
80104661:	e8 27 03 00 00       	call   8010498d <acquire>
80104666:	83 c4 10             	add    $0x10,%esp
  wakeup1(chan);
80104669:	83 ec 0c             	sub    $0xc,%esp
8010466c:	ff 75 08             	push   0x8(%ebp)
8010466f:	e8 9c ff ff ff       	call   80104610 <wakeup1>
80104674:	83 c4 10             	add    $0x10,%esp
  release(&ptable.lock);
80104677:	83 ec 0c             	sub    $0xc,%esp
8010467a:	68 00 42 19 80       	push   $0x80194200
8010467f:	e8 77 03 00 00       	call   801049fb <release>
80104684:	83 c4 10             	add    $0x10,%esp
}
80104687:	90                   	nop
80104688:	c9                   	leave  
80104689:	c3                   	ret    

8010468a <kill>:
// Kill the process with the given pid.
// Process won't exit until it returns
// to user space (see trap in trap.c).
int
kill(int pid)
{
8010468a:	55                   	push   %ebp
8010468b:	89 e5                	mov    %esp,%ebp
8010468d:	83 ec 18             	sub    $0x18,%esp
  struct proc *p;

  acquire(&ptable.lock);
80104690:	83 ec 0c             	sub    $0xc,%esp
80104693:	68 00 42 19 80       	push   $0x80194200
80104698:	e8 f0 02 00 00       	call   8010498d <acquire>
8010469d:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801046a0:	c7 45 f4 34 42 19 80 	movl   $0x80194234,-0xc(%ebp)
801046a7:	eb 48                	jmp    801046f1 <kill+0x67>
    if(p->pid == pid){
801046a9:	8b 45 f4             	mov    -0xc(%ebp),%eax
801046ac:	8b 40 10             	mov    0x10(%eax),%eax
801046af:	39 45 08             	cmp    %eax,0x8(%ebp)
801046b2:	75 36                	jne    801046ea <kill+0x60>
      p->killed = 1;
801046b4:	8b 45 f4             	mov    -0xc(%ebp),%eax
801046b7:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
      // Wake process from sleep if necessary.
      if(p->state == SLEEPING)
801046be:	8b 45 f4             	mov    -0xc(%ebp),%eax
801046c1:	8b 40 0c             	mov    0xc(%eax),%eax
801046c4:	83 f8 02             	cmp    $0x2,%eax
801046c7:	75 0a                	jne    801046d3 <kill+0x49>
        p->state = RUNNABLE;
801046c9:	8b 45 f4             	mov    -0xc(%ebp),%eax
801046cc:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
      release(&ptable.lock);
801046d3:	83 ec 0c             	sub    $0xc,%esp
801046d6:	68 00 42 19 80       	push   $0x80194200
801046db:	e8 1b 03 00 00       	call   801049fb <release>
801046e0:	83 c4 10             	add    $0x10,%esp
      return 0;
801046e3:	b8 00 00 00 00       	mov    $0x0,%eax
801046e8:	eb 25                	jmp    8010470f <kill+0x85>
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801046ea:	81 45 f4 84 00 00 00 	addl   $0x84,-0xc(%ebp)
801046f1:	81 7d f4 34 63 19 80 	cmpl   $0x80196334,-0xc(%ebp)
801046f8:	72 af                	jb     801046a9 <kill+0x1f>
    }
  }
  release(&ptable.lock);
801046fa:	83 ec 0c             	sub    $0xc,%esp
801046fd:	68 00 42 19 80       	push   $0x80194200
80104702:	e8 f4 02 00 00       	call   801049fb <release>
80104707:	83 c4 10             	add    $0x10,%esp
  return -1;
8010470a:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
8010470f:	c9                   	leave  
80104710:	c3                   	ret    

80104711 <procdump>:
// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void
procdump(void)
{
80104711:	55                   	push   %ebp
80104712:	89 e5                	mov    %esp,%ebp
80104714:	83 ec 48             	sub    $0x48,%esp
  int i;
  struct proc *p;
  char *state;
  uint pc[10];

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104717:	c7 45 f0 34 42 19 80 	movl   $0x80194234,-0x10(%ebp)
8010471e:	e9 da 00 00 00       	jmp    801047fd <procdump+0xec>
    if(p->state == UNUSED)
80104723:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104726:	8b 40 0c             	mov    0xc(%eax),%eax
80104729:	85 c0                	test   %eax,%eax
8010472b:	0f 84 c4 00 00 00    	je     801047f5 <procdump+0xe4>
      continue;
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
80104731:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104734:	8b 40 0c             	mov    0xc(%eax),%eax
80104737:	83 f8 05             	cmp    $0x5,%eax
8010473a:	77 23                	ja     8010475f <procdump+0x4e>
8010473c:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010473f:	8b 40 0c             	mov    0xc(%eax),%eax
80104742:	8b 04 85 08 f0 10 80 	mov    -0x7fef0ff8(,%eax,4),%eax
80104749:	85 c0                	test   %eax,%eax
8010474b:	74 12                	je     8010475f <procdump+0x4e>
      state = states[p->state];
8010474d:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104750:	8b 40 0c             	mov    0xc(%eax),%eax
80104753:	8b 04 85 08 f0 10 80 	mov    -0x7fef0ff8(,%eax,4),%eax
8010475a:	89 45 ec             	mov    %eax,-0x14(%ebp)
8010475d:	eb 07                	jmp    80104766 <procdump+0x55>
    else
      state = "???";
8010475f:	c7 45 ec c2 a5 10 80 	movl   $0x8010a5c2,-0x14(%ebp)
    cprintf("%d %s %s", p->pid, state, p->name);
80104766:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104769:	8d 50 6c             	lea    0x6c(%eax),%edx
8010476c:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010476f:	8b 40 10             	mov    0x10(%eax),%eax
80104772:	52                   	push   %edx
80104773:	ff 75 ec             	push   -0x14(%ebp)
80104776:	50                   	push   %eax
80104777:	68 c6 a5 10 80       	push   $0x8010a5c6
8010477c:	e8 73 bc ff ff       	call   801003f4 <cprintf>
80104781:	83 c4 10             	add    $0x10,%esp
    if(p->state == SLEEPING){
80104784:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104787:	8b 40 0c             	mov    0xc(%eax),%eax
8010478a:	83 f8 02             	cmp    $0x2,%eax
8010478d:	75 54                	jne    801047e3 <procdump+0xd2>
      getcallerpcs((uint*)p->context->ebp+2, pc);
8010478f:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104792:	8b 40 1c             	mov    0x1c(%eax),%eax
80104795:	8b 40 0c             	mov    0xc(%eax),%eax
80104798:	83 c0 08             	add    $0x8,%eax
8010479b:	89 c2                	mov    %eax,%edx
8010479d:	83 ec 08             	sub    $0x8,%esp
801047a0:	8d 45 c4             	lea    -0x3c(%ebp),%eax
801047a3:	50                   	push   %eax
801047a4:	52                   	push   %edx
801047a5:	e8 a3 02 00 00       	call   80104a4d <getcallerpcs>
801047aa:	83 c4 10             	add    $0x10,%esp
      for(i=0; i<10 && pc[i] != 0; i++)
801047ad:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
801047b4:	eb 1c                	jmp    801047d2 <procdump+0xc1>
        cprintf(" %p", pc[i]);
801047b6:	8b 45 f4             	mov    -0xc(%ebp),%eax
801047b9:	8b 44 85 c4          	mov    -0x3c(%ebp,%eax,4),%eax
801047bd:	83 ec 08             	sub    $0x8,%esp
801047c0:	50                   	push   %eax
801047c1:	68 cf a5 10 80       	push   $0x8010a5cf
801047c6:	e8 29 bc ff ff       	call   801003f4 <cprintf>
801047cb:	83 c4 10             	add    $0x10,%esp
      for(i=0; i<10 && pc[i] != 0; i++)
801047ce:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
801047d2:	83 7d f4 09          	cmpl   $0x9,-0xc(%ebp)
801047d6:	7f 0b                	jg     801047e3 <procdump+0xd2>
801047d8:	8b 45 f4             	mov    -0xc(%ebp),%eax
801047db:	8b 44 85 c4          	mov    -0x3c(%ebp,%eax,4),%eax
801047df:	85 c0                	test   %eax,%eax
801047e1:	75 d3                	jne    801047b6 <procdump+0xa5>
    }
    cprintf("\n");
801047e3:	83 ec 0c             	sub    $0xc,%esp
801047e6:	68 d3 a5 10 80       	push   $0x8010a5d3
801047eb:	e8 04 bc ff ff       	call   801003f4 <cprintf>
801047f0:	83 c4 10             	add    $0x10,%esp
801047f3:	eb 01                	jmp    801047f6 <procdump+0xe5>
      continue;
801047f5:	90                   	nop
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801047f6:	81 45 f0 84 00 00 00 	addl   $0x84,-0x10(%ebp)
801047fd:	81 7d f0 34 63 19 80 	cmpl   $0x80196334,-0x10(%ebp)
80104804:	0f 82 19 ff ff ff    	jb     80104723 <procdump+0x12>
  }
}
8010480a:	90                   	nop
8010480b:	90                   	nop
8010480c:	c9                   	leave  
8010480d:	c3                   	ret    

8010480e <initsleeplock>:
#include "spinlock.h"
#include "sleeplock.h"

void
initsleeplock(struct sleeplock *lk, char *name)
{
8010480e:	55                   	push   %ebp
8010480f:	89 e5                	mov    %esp,%ebp
80104811:	83 ec 08             	sub    $0x8,%esp
  initlock(&lk->lk, "sleep lock");
80104814:	8b 45 08             	mov    0x8(%ebp),%eax
80104817:	83 c0 04             	add    $0x4,%eax
8010481a:	83 ec 08             	sub    $0x8,%esp
8010481d:	68 ff a5 10 80       	push   $0x8010a5ff
80104822:	50                   	push   %eax
80104823:	e8 43 01 00 00       	call   8010496b <initlock>
80104828:	83 c4 10             	add    $0x10,%esp
  lk->name = name;
8010482b:	8b 45 08             	mov    0x8(%ebp),%eax
8010482e:	8b 55 0c             	mov    0xc(%ebp),%edx
80104831:	89 50 38             	mov    %edx,0x38(%eax)
  lk->locked = 0;
80104834:	8b 45 08             	mov    0x8(%ebp),%eax
80104837:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  lk->pid = 0;
8010483d:	8b 45 08             	mov    0x8(%ebp),%eax
80104840:	c7 40 3c 00 00 00 00 	movl   $0x0,0x3c(%eax)
}
80104847:	90                   	nop
80104848:	c9                   	leave  
80104849:	c3                   	ret    

8010484a <acquiresleep>:

void
acquiresleep(struct sleeplock *lk)
{
8010484a:	55                   	push   %ebp
8010484b:	89 e5                	mov    %esp,%ebp
8010484d:	83 ec 08             	sub    $0x8,%esp
  acquire(&lk->lk);
80104850:	8b 45 08             	mov    0x8(%ebp),%eax
80104853:	83 c0 04             	add    $0x4,%eax
80104856:	83 ec 0c             	sub    $0xc,%esp
80104859:	50                   	push   %eax
8010485a:	e8 2e 01 00 00       	call   8010498d <acquire>
8010485f:	83 c4 10             	add    $0x10,%esp
  while (lk->locked) {
80104862:	eb 15                	jmp    80104879 <acquiresleep+0x2f>
    sleep(lk, &lk->lk);
80104864:	8b 45 08             	mov    0x8(%ebp),%eax
80104867:	83 c0 04             	add    $0x4,%eax
8010486a:	83 ec 08             	sub    $0x8,%esp
8010486d:	50                   	push   %eax
8010486e:	ff 75 08             	push   0x8(%ebp)
80104871:	e8 f3 fc ff ff       	call   80104569 <sleep>
80104876:	83 c4 10             	add    $0x10,%esp
  while (lk->locked) {
80104879:	8b 45 08             	mov    0x8(%ebp),%eax
8010487c:	8b 00                	mov    (%eax),%eax
8010487e:	85 c0                	test   %eax,%eax
80104880:	75 e2                	jne    80104864 <acquiresleep+0x1a>
  }
  lk->locked = 1;
80104882:	8b 45 08             	mov    0x8(%ebp),%eax
80104885:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  lk->pid = myproc()->pid;
8010488b:	e8 a0 f1 ff ff       	call   80103a30 <myproc>
80104890:	8b 50 10             	mov    0x10(%eax),%edx
80104893:	8b 45 08             	mov    0x8(%ebp),%eax
80104896:	89 50 3c             	mov    %edx,0x3c(%eax)
  release(&lk->lk);
80104899:	8b 45 08             	mov    0x8(%ebp),%eax
8010489c:	83 c0 04             	add    $0x4,%eax
8010489f:	83 ec 0c             	sub    $0xc,%esp
801048a2:	50                   	push   %eax
801048a3:	e8 53 01 00 00       	call   801049fb <release>
801048a8:	83 c4 10             	add    $0x10,%esp
}
801048ab:	90                   	nop
801048ac:	c9                   	leave  
801048ad:	c3                   	ret    

801048ae <releasesleep>:

void
releasesleep(struct sleeplock *lk)
{
801048ae:	55                   	push   %ebp
801048af:	89 e5                	mov    %esp,%ebp
801048b1:	83 ec 08             	sub    $0x8,%esp
  acquire(&lk->lk);
801048b4:	8b 45 08             	mov    0x8(%ebp),%eax
801048b7:	83 c0 04             	add    $0x4,%eax
801048ba:	83 ec 0c             	sub    $0xc,%esp
801048bd:	50                   	push   %eax
801048be:	e8 ca 00 00 00       	call   8010498d <acquire>
801048c3:	83 c4 10             	add    $0x10,%esp
  lk->locked = 0;
801048c6:	8b 45 08             	mov    0x8(%ebp),%eax
801048c9:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  lk->pid = 0;
801048cf:	8b 45 08             	mov    0x8(%ebp),%eax
801048d2:	c7 40 3c 00 00 00 00 	movl   $0x0,0x3c(%eax)
  wakeup(lk);
801048d9:	83 ec 0c             	sub    $0xc,%esp
801048dc:	ff 75 08             	push   0x8(%ebp)
801048df:	e8 6f fd ff ff       	call   80104653 <wakeup>
801048e4:	83 c4 10             	add    $0x10,%esp
  release(&lk->lk);
801048e7:	8b 45 08             	mov    0x8(%ebp),%eax
801048ea:	83 c0 04             	add    $0x4,%eax
801048ed:	83 ec 0c             	sub    $0xc,%esp
801048f0:	50                   	push   %eax
801048f1:	e8 05 01 00 00       	call   801049fb <release>
801048f6:	83 c4 10             	add    $0x10,%esp
}
801048f9:	90                   	nop
801048fa:	c9                   	leave  
801048fb:	c3                   	ret    

801048fc <holdingsleep>:

int
holdingsleep(struct sleeplock *lk)
{
801048fc:	55                   	push   %ebp
801048fd:	89 e5                	mov    %esp,%ebp
801048ff:	83 ec 18             	sub    $0x18,%esp
  int r;
  
  acquire(&lk->lk);
80104902:	8b 45 08             	mov    0x8(%ebp),%eax
80104905:	83 c0 04             	add    $0x4,%eax
80104908:	83 ec 0c             	sub    $0xc,%esp
8010490b:	50                   	push   %eax
8010490c:	e8 7c 00 00 00       	call   8010498d <acquire>
80104911:	83 c4 10             	add    $0x10,%esp
  r = lk->locked;
80104914:	8b 45 08             	mov    0x8(%ebp),%eax
80104917:	8b 00                	mov    (%eax),%eax
80104919:	89 45 f4             	mov    %eax,-0xc(%ebp)
  release(&lk->lk);
8010491c:	8b 45 08             	mov    0x8(%ebp),%eax
8010491f:	83 c0 04             	add    $0x4,%eax
80104922:	83 ec 0c             	sub    $0xc,%esp
80104925:	50                   	push   %eax
80104926:	e8 d0 00 00 00       	call   801049fb <release>
8010492b:	83 c4 10             	add    $0x10,%esp
  return r;
8010492e:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
80104931:	c9                   	leave  
80104932:	c3                   	ret    

80104933 <readeflags>:
{
80104933:	55                   	push   %ebp
80104934:	89 e5                	mov    %esp,%ebp
80104936:	83 ec 10             	sub    $0x10,%esp
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80104939:	9c                   	pushf  
8010493a:	58                   	pop    %eax
8010493b:	89 45 fc             	mov    %eax,-0x4(%ebp)
  return eflags;
8010493e:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
80104941:	c9                   	leave  
80104942:	c3                   	ret    

80104943 <cli>:
{
80104943:	55                   	push   %ebp
80104944:	89 e5                	mov    %esp,%ebp
  asm volatile("cli");
80104946:	fa                   	cli    
}
80104947:	90                   	nop
80104948:	5d                   	pop    %ebp
80104949:	c3                   	ret    

8010494a <sti>:
{
8010494a:	55                   	push   %ebp
8010494b:	89 e5                	mov    %esp,%ebp
  asm volatile("sti");
8010494d:	fb                   	sti    
}
8010494e:	90                   	nop
8010494f:	5d                   	pop    %ebp
80104950:	c3                   	ret    

80104951 <xchg>:
{
80104951:	55                   	push   %ebp
80104952:	89 e5                	mov    %esp,%ebp
80104954:	83 ec 10             	sub    $0x10,%esp
  asm volatile("lock; xchgl %0, %1" :
80104957:	8b 55 08             	mov    0x8(%ebp),%edx
8010495a:	8b 45 0c             	mov    0xc(%ebp),%eax
8010495d:	8b 4d 08             	mov    0x8(%ebp),%ecx
80104960:	f0 87 02             	lock xchg %eax,(%edx)
80104963:	89 45 fc             	mov    %eax,-0x4(%ebp)
  return result;
80104966:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
80104969:	c9                   	leave  
8010496a:	c3                   	ret    

8010496b <initlock>:
#include "proc.h"
#include "spinlock.h"

void
initlock(struct spinlock *lk, char *name)
{
8010496b:	55                   	push   %ebp
8010496c:	89 e5                	mov    %esp,%ebp
  lk->name = name;
8010496e:	8b 45 08             	mov    0x8(%ebp),%eax
80104971:	8b 55 0c             	mov    0xc(%ebp),%edx
80104974:	89 50 04             	mov    %edx,0x4(%eax)
  lk->locked = 0;
80104977:	8b 45 08             	mov    0x8(%ebp),%eax
8010497a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  lk->cpu = 0;
80104980:	8b 45 08             	mov    0x8(%ebp),%eax
80104983:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
}
8010498a:	90                   	nop
8010498b:	5d                   	pop    %ebp
8010498c:	c3                   	ret    

8010498d <acquire>:
// Loops (spins) until the lock is acquired.
// Holding a lock for a long time may cause
// other CPUs to waste time spinning to acquire it.
void
acquire(struct spinlock *lk)
{
8010498d:	55                   	push   %ebp
8010498e:	89 e5                	mov    %esp,%ebp
80104990:	53                   	push   %ebx
80104991:	83 ec 04             	sub    $0x4,%esp
  pushcli(); // disable interrupts to avoid deadlock.
80104994:	e8 5f 01 00 00       	call   80104af8 <pushcli>
  if(holding(lk)){
80104999:	8b 45 08             	mov    0x8(%ebp),%eax
8010499c:	83 ec 0c             	sub    $0xc,%esp
8010499f:	50                   	push   %eax
801049a0:	e8 23 01 00 00       	call   80104ac8 <holding>
801049a5:	83 c4 10             	add    $0x10,%esp
801049a8:	85 c0                	test   %eax,%eax
801049aa:	74 0d                	je     801049b9 <acquire+0x2c>
    panic("acquire");
801049ac:	83 ec 0c             	sub    $0xc,%esp
801049af:	68 0a a6 10 80       	push   $0x8010a60a
801049b4:	e8 f0 bb ff ff       	call   801005a9 <panic>
  }

  // The xchg is atomic.
  while(xchg(&lk->locked, 1) != 0)
801049b9:	90                   	nop
801049ba:	8b 45 08             	mov    0x8(%ebp),%eax
801049bd:	83 ec 08             	sub    $0x8,%esp
801049c0:	6a 01                	push   $0x1
801049c2:	50                   	push   %eax
801049c3:	e8 89 ff ff ff       	call   80104951 <xchg>
801049c8:	83 c4 10             	add    $0x10,%esp
801049cb:	85 c0                	test   %eax,%eax
801049cd:	75 eb                	jne    801049ba <acquire+0x2d>
    ;

  // Tell the C compiler and the processor to not move loads or stores
  // past this point, to ensure that the critical section's memory
  // references happen after the lock is acquired.
  __sync_synchronize();
801049cf:	f0 83 0c 24 00       	lock orl $0x0,(%esp)

  // Record info about lock acquisition for debugging.
  lk->cpu = mycpu();
801049d4:	8b 5d 08             	mov    0x8(%ebp),%ebx
801049d7:	e8 dc ef ff ff       	call   801039b8 <mycpu>
801049dc:	89 43 08             	mov    %eax,0x8(%ebx)
  getcallerpcs(&lk, lk->pcs);
801049df:	8b 45 08             	mov    0x8(%ebp),%eax
801049e2:	83 c0 0c             	add    $0xc,%eax
801049e5:	83 ec 08             	sub    $0x8,%esp
801049e8:	50                   	push   %eax
801049e9:	8d 45 08             	lea    0x8(%ebp),%eax
801049ec:	50                   	push   %eax
801049ed:	e8 5b 00 00 00       	call   80104a4d <getcallerpcs>
801049f2:	83 c4 10             	add    $0x10,%esp
}
801049f5:	90                   	nop
801049f6:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801049f9:	c9                   	leave  
801049fa:	c3                   	ret    

801049fb <release>:

// Release the lock.
void
release(struct spinlock *lk)
{
801049fb:	55                   	push   %ebp
801049fc:	89 e5                	mov    %esp,%ebp
801049fe:	83 ec 08             	sub    $0x8,%esp
  if(!holding(lk))
80104a01:	83 ec 0c             	sub    $0xc,%esp
80104a04:	ff 75 08             	push   0x8(%ebp)
80104a07:	e8 bc 00 00 00       	call   80104ac8 <holding>
80104a0c:	83 c4 10             	add    $0x10,%esp
80104a0f:	85 c0                	test   %eax,%eax
80104a11:	75 0d                	jne    80104a20 <release+0x25>
    panic("release");
80104a13:	83 ec 0c             	sub    $0xc,%esp
80104a16:	68 12 a6 10 80       	push   $0x8010a612
80104a1b:	e8 89 bb ff ff       	call   801005a9 <panic>

  lk->pcs[0] = 0;
80104a20:	8b 45 08             	mov    0x8(%ebp),%eax
80104a23:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
  lk->cpu = 0;
80104a2a:	8b 45 08             	mov    0x8(%ebp),%eax
80104a2d:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  // Tell the C compiler and the processor to not move loads or stores
  // past this point, to ensure that all the stores in the critical
  // section are visible to other cores before the lock is released.
  // Both the C compiler and the hardware may re-order loads and
  // stores; __sync_synchronize() tells them both not to.
  __sync_synchronize();
80104a34:	f0 83 0c 24 00       	lock orl $0x0,(%esp)

  // Release the lock, equivalent to lk->locked = 0.
  // This code can't use a C assignment, since it might
  // not be atomic. A real OS would use C atomics here.
  asm volatile("movl $0, %0" : "+m" (lk->locked) : );
80104a39:	8b 45 08             	mov    0x8(%ebp),%eax
80104a3c:	8b 55 08             	mov    0x8(%ebp),%edx
80104a3f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

  popcli();
80104a45:	e8 fb 00 00 00       	call   80104b45 <popcli>
}
80104a4a:	90                   	nop
80104a4b:	c9                   	leave  
80104a4c:	c3                   	ret    

80104a4d <getcallerpcs>:

// Record the current call stack in pcs[] by following the %ebp chain.
void
getcallerpcs(void *v, uint pcs[])
{
80104a4d:	55                   	push   %ebp
80104a4e:	89 e5                	mov    %esp,%ebp
80104a50:	83 ec 10             	sub    $0x10,%esp
  uint *ebp;
  int i;

  ebp = (uint*)v - 2;
80104a53:	8b 45 08             	mov    0x8(%ebp),%eax
80104a56:	83 e8 08             	sub    $0x8,%eax
80104a59:	89 45 fc             	mov    %eax,-0x4(%ebp)
  for(i = 0; i < 10; i++){
80104a5c:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
80104a63:	eb 38                	jmp    80104a9d <getcallerpcs+0x50>
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
80104a65:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
80104a69:	74 53                	je     80104abe <getcallerpcs+0x71>
80104a6b:	81 7d fc ff ff ff 7f 	cmpl   $0x7fffffff,-0x4(%ebp)
80104a72:	76 4a                	jbe    80104abe <getcallerpcs+0x71>
80104a74:	83 7d fc ff          	cmpl   $0xffffffff,-0x4(%ebp)
80104a78:	74 44                	je     80104abe <getcallerpcs+0x71>
      break;
    pcs[i] = ebp[1];     // saved %eip
80104a7a:	8b 45 f8             	mov    -0x8(%ebp),%eax
80104a7d:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80104a84:	8b 45 0c             	mov    0xc(%ebp),%eax
80104a87:	01 c2                	add    %eax,%edx
80104a89:	8b 45 fc             	mov    -0x4(%ebp),%eax
80104a8c:	8b 40 04             	mov    0x4(%eax),%eax
80104a8f:	89 02                	mov    %eax,(%edx)
    ebp = (uint*)ebp[0]; // saved %ebp
80104a91:	8b 45 fc             	mov    -0x4(%ebp),%eax
80104a94:	8b 00                	mov    (%eax),%eax
80104a96:	89 45 fc             	mov    %eax,-0x4(%ebp)
  for(i = 0; i < 10; i++){
80104a99:	83 45 f8 01          	addl   $0x1,-0x8(%ebp)
80104a9d:	83 7d f8 09          	cmpl   $0x9,-0x8(%ebp)
80104aa1:	7e c2                	jle    80104a65 <getcallerpcs+0x18>
  }
  for(; i < 10; i++)
80104aa3:	eb 19                	jmp    80104abe <getcallerpcs+0x71>
    pcs[i] = 0;
80104aa5:	8b 45 f8             	mov    -0x8(%ebp),%eax
80104aa8:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80104aaf:	8b 45 0c             	mov    0xc(%ebp),%eax
80104ab2:	01 d0                	add    %edx,%eax
80104ab4:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  for(; i < 10; i++)
80104aba:	83 45 f8 01          	addl   $0x1,-0x8(%ebp)
80104abe:	83 7d f8 09          	cmpl   $0x9,-0x8(%ebp)
80104ac2:	7e e1                	jle    80104aa5 <getcallerpcs+0x58>
}
80104ac4:	90                   	nop
80104ac5:	90                   	nop
80104ac6:	c9                   	leave  
80104ac7:	c3                   	ret    

80104ac8 <holding>:

// Check whether this cpu is holding the lock.
int
holding(struct spinlock *lock)
{
80104ac8:	55                   	push   %ebp
80104ac9:	89 e5                	mov    %esp,%ebp
80104acb:	53                   	push   %ebx
80104acc:	83 ec 04             	sub    $0x4,%esp
  return lock->locked && lock->cpu == mycpu();
80104acf:	8b 45 08             	mov    0x8(%ebp),%eax
80104ad2:	8b 00                	mov    (%eax),%eax
80104ad4:	85 c0                	test   %eax,%eax
80104ad6:	74 16                	je     80104aee <holding+0x26>
80104ad8:	8b 45 08             	mov    0x8(%ebp),%eax
80104adb:	8b 58 08             	mov    0x8(%eax),%ebx
80104ade:	e8 d5 ee ff ff       	call   801039b8 <mycpu>
80104ae3:	39 c3                	cmp    %eax,%ebx
80104ae5:	75 07                	jne    80104aee <holding+0x26>
80104ae7:	b8 01 00 00 00       	mov    $0x1,%eax
80104aec:	eb 05                	jmp    80104af3 <holding+0x2b>
80104aee:	b8 00 00 00 00       	mov    $0x0,%eax
}
80104af3:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104af6:	c9                   	leave  
80104af7:	c3                   	ret    

80104af8 <pushcli>:
// it takes two popcli to undo two pushcli.  Also, if interrupts
// are off, then pushcli, popcli leaves them off.

void
pushcli(void)
{
80104af8:	55                   	push   %ebp
80104af9:	89 e5                	mov    %esp,%ebp
80104afb:	83 ec 18             	sub    $0x18,%esp
  int eflags;

  eflags = readeflags();
80104afe:	e8 30 fe ff ff       	call   80104933 <readeflags>
80104b03:	89 45 f4             	mov    %eax,-0xc(%ebp)
  cli();
80104b06:	e8 38 fe ff ff       	call   80104943 <cli>
  if(mycpu()->ncli == 0)
80104b0b:	e8 a8 ee ff ff       	call   801039b8 <mycpu>
80104b10:	8b 80 a4 00 00 00    	mov    0xa4(%eax),%eax
80104b16:	85 c0                	test   %eax,%eax
80104b18:	75 14                	jne    80104b2e <pushcli+0x36>
    mycpu()->intena = eflags & FL_IF;
80104b1a:	e8 99 ee ff ff       	call   801039b8 <mycpu>
80104b1f:	8b 55 f4             	mov    -0xc(%ebp),%edx
80104b22:	81 e2 00 02 00 00    	and    $0x200,%edx
80104b28:	89 90 a8 00 00 00    	mov    %edx,0xa8(%eax)
  mycpu()->ncli += 1;
80104b2e:	e8 85 ee ff ff       	call   801039b8 <mycpu>
80104b33:	8b 90 a4 00 00 00    	mov    0xa4(%eax),%edx
80104b39:	83 c2 01             	add    $0x1,%edx
80104b3c:	89 90 a4 00 00 00    	mov    %edx,0xa4(%eax)
}
80104b42:	90                   	nop
80104b43:	c9                   	leave  
80104b44:	c3                   	ret    

80104b45 <popcli>:

void
popcli(void)
{
80104b45:	55                   	push   %ebp
80104b46:	89 e5                	mov    %esp,%ebp
80104b48:	83 ec 08             	sub    $0x8,%esp
  if(readeflags()&FL_IF)
80104b4b:	e8 e3 fd ff ff       	call   80104933 <readeflags>
80104b50:	25 00 02 00 00       	and    $0x200,%eax
80104b55:	85 c0                	test   %eax,%eax
80104b57:	74 0d                	je     80104b66 <popcli+0x21>
    panic("popcli - interruptible");
80104b59:	83 ec 0c             	sub    $0xc,%esp
80104b5c:	68 1a a6 10 80       	push   $0x8010a61a
80104b61:	e8 43 ba ff ff       	call   801005a9 <panic>
  if(--mycpu()->ncli < 0)
80104b66:	e8 4d ee ff ff       	call   801039b8 <mycpu>
80104b6b:	8b 90 a4 00 00 00    	mov    0xa4(%eax),%edx
80104b71:	83 ea 01             	sub    $0x1,%edx
80104b74:	89 90 a4 00 00 00    	mov    %edx,0xa4(%eax)
80104b7a:	8b 80 a4 00 00 00    	mov    0xa4(%eax),%eax
80104b80:	85 c0                	test   %eax,%eax
80104b82:	79 0d                	jns    80104b91 <popcli+0x4c>
    panic("popcli");
80104b84:	83 ec 0c             	sub    $0xc,%esp
80104b87:	68 31 a6 10 80       	push   $0x8010a631
80104b8c:	e8 18 ba ff ff       	call   801005a9 <panic>
  if(mycpu()->ncli == 0 && mycpu()->intena)
80104b91:	e8 22 ee ff ff       	call   801039b8 <mycpu>
80104b96:	8b 80 a4 00 00 00    	mov    0xa4(%eax),%eax
80104b9c:	85 c0                	test   %eax,%eax
80104b9e:	75 14                	jne    80104bb4 <popcli+0x6f>
80104ba0:	e8 13 ee ff ff       	call   801039b8 <mycpu>
80104ba5:	8b 80 a8 00 00 00    	mov    0xa8(%eax),%eax
80104bab:	85 c0                	test   %eax,%eax
80104bad:	74 05                	je     80104bb4 <popcli+0x6f>
    sti();
80104baf:	e8 96 fd ff ff       	call   8010494a <sti>
}
80104bb4:	90                   	nop
80104bb5:	c9                   	leave  
80104bb6:	c3                   	ret    

80104bb7 <stosb>:
80104bb7:	55                   	push   %ebp
80104bb8:	89 e5                	mov    %esp,%ebp
80104bba:	57                   	push   %edi
80104bbb:	53                   	push   %ebx
80104bbc:	8b 4d 08             	mov    0x8(%ebp),%ecx
80104bbf:	8b 55 10             	mov    0x10(%ebp),%edx
80104bc2:	8b 45 0c             	mov    0xc(%ebp),%eax
80104bc5:	89 cb                	mov    %ecx,%ebx
80104bc7:	89 df                	mov    %ebx,%edi
80104bc9:	89 d1                	mov    %edx,%ecx
80104bcb:	fc                   	cld    
80104bcc:	f3 aa                	rep stos %al,%es:(%edi)
80104bce:	89 ca                	mov    %ecx,%edx
80104bd0:	89 fb                	mov    %edi,%ebx
80104bd2:	89 5d 08             	mov    %ebx,0x8(%ebp)
80104bd5:	89 55 10             	mov    %edx,0x10(%ebp)
80104bd8:	90                   	nop
80104bd9:	5b                   	pop    %ebx
80104bda:	5f                   	pop    %edi
80104bdb:	5d                   	pop    %ebp
80104bdc:	c3                   	ret    

80104bdd <stosl>:
80104bdd:	55                   	push   %ebp
80104bde:	89 e5                	mov    %esp,%ebp
80104be0:	57                   	push   %edi
80104be1:	53                   	push   %ebx
80104be2:	8b 4d 08             	mov    0x8(%ebp),%ecx
80104be5:	8b 55 10             	mov    0x10(%ebp),%edx
80104be8:	8b 45 0c             	mov    0xc(%ebp),%eax
80104beb:	89 cb                	mov    %ecx,%ebx
80104bed:	89 df                	mov    %ebx,%edi
80104bef:	89 d1                	mov    %edx,%ecx
80104bf1:	fc                   	cld    
80104bf2:	f3 ab                	rep stos %eax,%es:(%edi)
80104bf4:	89 ca                	mov    %ecx,%edx
80104bf6:	89 fb                	mov    %edi,%ebx
80104bf8:	89 5d 08             	mov    %ebx,0x8(%ebp)
80104bfb:	89 55 10             	mov    %edx,0x10(%ebp)
80104bfe:	90                   	nop
80104bff:	5b                   	pop    %ebx
80104c00:	5f                   	pop    %edi
80104c01:	5d                   	pop    %ebp
80104c02:	c3                   	ret    

80104c03 <memset>:
80104c03:	55                   	push   %ebp
80104c04:	89 e5                	mov    %esp,%ebp
80104c06:	8b 45 08             	mov    0x8(%ebp),%eax
80104c09:	83 e0 03             	and    $0x3,%eax
80104c0c:	85 c0                	test   %eax,%eax
80104c0e:	75 43                	jne    80104c53 <memset+0x50>
80104c10:	8b 45 10             	mov    0x10(%ebp),%eax
80104c13:	83 e0 03             	and    $0x3,%eax
80104c16:	85 c0                	test   %eax,%eax
80104c18:	75 39                	jne    80104c53 <memset+0x50>
80104c1a:	81 65 0c ff 00 00 00 	andl   $0xff,0xc(%ebp)
80104c21:	8b 45 10             	mov    0x10(%ebp),%eax
80104c24:	c1 e8 02             	shr    $0x2,%eax
80104c27:	89 c2                	mov    %eax,%edx
80104c29:	8b 45 0c             	mov    0xc(%ebp),%eax
80104c2c:	c1 e0 18             	shl    $0x18,%eax
80104c2f:	89 c1                	mov    %eax,%ecx
80104c31:	8b 45 0c             	mov    0xc(%ebp),%eax
80104c34:	c1 e0 10             	shl    $0x10,%eax
80104c37:	09 c1                	or     %eax,%ecx
80104c39:	8b 45 0c             	mov    0xc(%ebp),%eax
80104c3c:	c1 e0 08             	shl    $0x8,%eax
80104c3f:	09 c8                	or     %ecx,%eax
80104c41:	0b 45 0c             	or     0xc(%ebp),%eax
80104c44:	52                   	push   %edx
80104c45:	50                   	push   %eax
80104c46:	ff 75 08             	push   0x8(%ebp)
80104c49:	e8 8f ff ff ff       	call   80104bdd <stosl>
80104c4e:	83 c4 0c             	add    $0xc,%esp
80104c51:	eb 12                	jmp    80104c65 <memset+0x62>
80104c53:	8b 45 10             	mov    0x10(%ebp),%eax
80104c56:	50                   	push   %eax
80104c57:	ff 75 0c             	push   0xc(%ebp)
80104c5a:	ff 75 08             	push   0x8(%ebp)
80104c5d:	e8 55 ff ff ff       	call   80104bb7 <stosb>
80104c62:	83 c4 0c             	add    $0xc,%esp
80104c65:	8b 45 08             	mov    0x8(%ebp),%eax
80104c68:	c9                   	leave  
80104c69:	c3                   	ret    

80104c6a <memcmp>:
80104c6a:	55                   	push   %ebp
80104c6b:	89 e5                	mov    %esp,%ebp
80104c6d:	83 ec 10             	sub    $0x10,%esp
80104c70:	8b 45 08             	mov    0x8(%ebp),%eax
80104c73:	89 45 fc             	mov    %eax,-0x4(%ebp)
80104c76:	8b 45 0c             	mov    0xc(%ebp),%eax
80104c79:	89 45 f8             	mov    %eax,-0x8(%ebp)
80104c7c:	eb 30                	jmp    80104cae <memcmp+0x44>
80104c7e:	8b 45 fc             	mov    -0x4(%ebp),%eax
80104c81:	0f b6 10             	movzbl (%eax),%edx
80104c84:	8b 45 f8             	mov    -0x8(%ebp),%eax
80104c87:	0f b6 00             	movzbl (%eax),%eax
80104c8a:	38 c2                	cmp    %al,%dl
80104c8c:	74 18                	je     80104ca6 <memcmp+0x3c>
80104c8e:	8b 45 fc             	mov    -0x4(%ebp),%eax
80104c91:	0f b6 00             	movzbl (%eax),%eax
80104c94:	0f b6 d0             	movzbl %al,%edx
80104c97:	8b 45 f8             	mov    -0x8(%ebp),%eax
80104c9a:	0f b6 00             	movzbl (%eax),%eax
80104c9d:	0f b6 c8             	movzbl %al,%ecx
80104ca0:	89 d0                	mov    %edx,%eax
80104ca2:	29 c8                	sub    %ecx,%eax
80104ca4:	eb 1a                	jmp    80104cc0 <memcmp+0x56>
80104ca6:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
80104caa:	83 45 f8 01          	addl   $0x1,-0x8(%ebp)
80104cae:	8b 45 10             	mov    0x10(%ebp),%eax
80104cb1:	8d 50 ff             	lea    -0x1(%eax),%edx
80104cb4:	89 55 10             	mov    %edx,0x10(%ebp)
80104cb7:	85 c0                	test   %eax,%eax
80104cb9:	75 c3                	jne    80104c7e <memcmp+0x14>
80104cbb:	b8 00 00 00 00       	mov    $0x0,%eax
80104cc0:	c9                   	leave  
80104cc1:	c3                   	ret    

80104cc2 <memmove>:
80104cc2:	55                   	push   %ebp
80104cc3:	89 e5                	mov    %esp,%ebp
80104cc5:	83 ec 10             	sub    $0x10,%esp
80104cc8:	8b 45 0c             	mov    0xc(%ebp),%eax
80104ccb:	89 45 fc             	mov    %eax,-0x4(%ebp)
80104cce:	8b 45 08             	mov    0x8(%ebp),%eax
80104cd1:	89 45 f8             	mov    %eax,-0x8(%ebp)
80104cd4:	8b 45 fc             	mov    -0x4(%ebp),%eax
80104cd7:	3b 45 f8             	cmp    -0x8(%ebp),%eax
80104cda:	73 54                	jae    80104d30 <memmove+0x6e>
80104cdc:	8b 55 fc             	mov    -0x4(%ebp),%edx
80104cdf:	8b 45 10             	mov    0x10(%ebp),%eax
80104ce2:	01 d0                	add    %edx,%eax
80104ce4:	39 45 f8             	cmp    %eax,-0x8(%ebp)
80104ce7:	73 47                	jae    80104d30 <memmove+0x6e>
80104ce9:	8b 45 10             	mov    0x10(%ebp),%eax
80104cec:	01 45 fc             	add    %eax,-0x4(%ebp)
80104cef:	8b 45 10             	mov    0x10(%ebp),%eax
80104cf2:	01 45 f8             	add    %eax,-0x8(%ebp)
80104cf5:	eb 13                	jmp    80104d0a <memmove+0x48>
80104cf7:	83 6d fc 01          	subl   $0x1,-0x4(%ebp)
80104cfb:	83 6d f8 01          	subl   $0x1,-0x8(%ebp)
80104cff:	8b 45 fc             	mov    -0x4(%ebp),%eax
80104d02:	0f b6 10             	movzbl (%eax),%edx
80104d05:	8b 45 f8             	mov    -0x8(%ebp),%eax
80104d08:	88 10                	mov    %dl,(%eax)
80104d0a:	8b 45 10             	mov    0x10(%ebp),%eax
80104d0d:	8d 50 ff             	lea    -0x1(%eax),%edx
80104d10:	89 55 10             	mov    %edx,0x10(%ebp)
80104d13:	85 c0                	test   %eax,%eax
80104d15:	75 e0                	jne    80104cf7 <memmove+0x35>
80104d17:	eb 24                	jmp    80104d3d <memmove+0x7b>
80104d19:	8b 55 fc             	mov    -0x4(%ebp),%edx
80104d1c:	8d 42 01             	lea    0x1(%edx),%eax
80104d1f:	89 45 fc             	mov    %eax,-0x4(%ebp)
80104d22:	8b 45 f8             	mov    -0x8(%ebp),%eax
80104d25:	8d 48 01             	lea    0x1(%eax),%ecx
80104d28:	89 4d f8             	mov    %ecx,-0x8(%ebp)
80104d2b:	0f b6 12             	movzbl (%edx),%edx
80104d2e:	88 10                	mov    %dl,(%eax)
80104d30:	8b 45 10             	mov    0x10(%ebp),%eax
80104d33:	8d 50 ff             	lea    -0x1(%eax),%edx
80104d36:	89 55 10             	mov    %edx,0x10(%ebp)
80104d39:	85 c0                	test   %eax,%eax
80104d3b:	75 dc                	jne    80104d19 <memmove+0x57>
80104d3d:	8b 45 08             	mov    0x8(%ebp),%eax
80104d40:	c9                   	leave  
80104d41:	c3                   	ret    

80104d42 <memcpy>:
80104d42:	55                   	push   %ebp
80104d43:	89 e5                	mov    %esp,%ebp
80104d45:	ff 75 10             	push   0x10(%ebp)
80104d48:	ff 75 0c             	push   0xc(%ebp)
80104d4b:	ff 75 08             	push   0x8(%ebp)
80104d4e:	e8 6f ff ff ff       	call   80104cc2 <memmove>
80104d53:	83 c4 0c             	add    $0xc,%esp
80104d56:	c9                   	leave  
80104d57:	c3                   	ret    

80104d58 <strncmp>:
80104d58:	55                   	push   %ebp
80104d59:	89 e5                	mov    %esp,%ebp
80104d5b:	eb 0c                	jmp    80104d69 <strncmp+0x11>
80104d5d:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
80104d61:	83 45 08 01          	addl   $0x1,0x8(%ebp)
80104d65:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
80104d69:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
80104d6d:	74 1a                	je     80104d89 <strncmp+0x31>
80104d6f:	8b 45 08             	mov    0x8(%ebp),%eax
80104d72:	0f b6 00             	movzbl (%eax),%eax
80104d75:	84 c0                	test   %al,%al
80104d77:	74 10                	je     80104d89 <strncmp+0x31>
80104d79:	8b 45 08             	mov    0x8(%ebp),%eax
80104d7c:	0f b6 10             	movzbl (%eax),%edx
80104d7f:	8b 45 0c             	mov    0xc(%ebp),%eax
80104d82:	0f b6 00             	movzbl (%eax),%eax
80104d85:	38 c2                	cmp    %al,%dl
80104d87:	74 d4                	je     80104d5d <strncmp+0x5>
80104d89:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
80104d8d:	75 07                	jne    80104d96 <strncmp+0x3e>
80104d8f:	b8 00 00 00 00       	mov    $0x0,%eax
80104d94:	eb 16                	jmp    80104dac <strncmp+0x54>
80104d96:	8b 45 08             	mov    0x8(%ebp),%eax
80104d99:	0f b6 00             	movzbl (%eax),%eax
80104d9c:	0f b6 d0             	movzbl %al,%edx
80104d9f:	8b 45 0c             	mov    0xc(%ebp),%eax
80104da2:	0f b6 00             	movzbl (%eax),%eax
80104da5:	0f b6 c8             	movzbl %al,%ecx
80104da8:	89 d0                	mov    %edx,%eax
80104daa:	29 c8                	sub    %ecx,%eax
80104dac:	5d                   	pop    %ebp
80104dad:	c3                   	ret    

80104dae <strncpy>:
80104dae:	55                   	push   %ebp
80104daf:	89 e5                	mov    %esp,%ebp
80104db1:	83 ec 10             	sub    $0x10,%esp
80104db4:	8b 45 08             	mov    0x8(%ebp),%eax
80104db7:	89 45 fc             	mov    %eax,-0x4(%ebp)
80104dba:	90                   	nop
80104dbb:	8b 45 10             	mov    0x10(%ebp),%eax
80104dbe:	8d 50 ff             	lea    -0x1(%eax),%edx
80104dc1:	89 55 10             	mov    %edx,0x10(%ebp)
80104dc4:	85 c0                	test   %eax,%eax
80104dc6:	7e 2c                	jle    80104df4 <strncpy+0x46>
80104dc8:	8b 55 0c             	mov    0xc(%ebp),%edx
80104dcb:	8d 42 01             	lea    0x1(%edx),%eax
80104dce:	89 45 0c             	mov    %eax,0xc(%ebp)
80104dd1:	8b 45 08             	mov    0x8(%ebp),%eax
80104dd4:	8d 48 01             	lea    0x1(%eax),%ecx
80104dd7:	89 4d 08             	mov    %ecx,0x8(%ebp)
80104dda:	0f b6 12             	movzbl (%edx),%edx
80104ddd:	88 10                	mov    %dl,(%eax)
80104ddf:	0f b6 00             	movzbl (%eax),%eax
80104de2:	84 c0                	test   %al,%al
80104de4:	75 d5                	jne    80104dbb <strncpy+0xd>
80104de6:	eb 0c                	jmp    80104df4 <strncpy+0x46>
80104de8:	8b 45 08             	mov    0x8(%ebp),%eax
80104deb:	8d 50 01             	lea    0x1(%eax),%edx
80104dee:	89 55 08             	mov    %edx,0x8(%ebp)
80104df1:	c6 00 00             	movb   $0x0,(%eax)
80104df4:	8b 45 10             	mov    0x10(%ebp),%eax
80104df7:	8d 50 ff             	lea    -0x1(%eax),%edx
80104dfa:	89 55 10             	mov    %edx,0x10(%ebp)
80104dfd:	85 c0                	test   %eax,%eax
80104dff:	7f e7                	jg     80104de8 <strncpy+0x3a>
80104e01:	8b 45 fc             	mov    -0x4(%ebp),%eax
80104e04:	c9                   	leave  
80104e05:	c3                   	ret    

80104e06 <safestrcpy>:
80104e06:	55                   	push   %ebp
80104e07:	89 e5                	mov    %esp,%ebp
80104e09:	83 ec 10             	sub    $0x10,%esp
80104e0c:	8b 45 08             	mov    0x8(%ebp),%eax
80104e0f:	89 45 fc             	mov    %eax,-0x4(%ebp)
80104e12:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
80104e16:	7f 05                	jg     80104e1d <safestrcpy+0x17>
80104e18:	8b 45 fc             	mov    -0x4(%ebp),%eax
80104e1b:	eb 32                	jmp    80104e4f <safestrcpy+0x49>
80104e1d:	90                   	nop
80104e1e:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
80104e22:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
80104e26:	7e 1e                	jle    80104e46 <safestrcpy+0x40>
80104e28:	8b 55 0c             	mov    0xc(%ebp),%edx
80104e2b:	8d 42 01             	lea    0x1(%edx),%eax
80104e2e:	89 45 0c             	mov    %eax,0xc(%ebp)
80104e31:	8b 45 08             	mov    0x8(%ebp),%eax
80104e34:	8d 48 01             	lea    0x1(%eax),%ecx
80104e37:	89 4d 08             	mov    %ecx,0x8(%ebp)
80104e3a:	0f b6 12             	movzbl (%edx),%edx
80104e3d:	88 10                	mov    %dl,(%eax)
80104e3f:	0f b6 00             	movzbl (%eax),%eax
80104e42:	84 c0                	test   %al,%al
80104e44:	75 d8                	jne    80104e1e <safestrcpy+0x18>
80104e46:	8b 45 08             	mov    0x8(%ebp),%eax
80104e49:	c6 00 00             	movb   $0x0,(%eax)
80104e4c:	8b 45 fc             	mov    -0x4(%ebp),%eax
80104e4f:	c9                   	leave  
80104e50:	c3                   	ret    

80104e51 <strlen>:
80104e51:	55                   	push   %ebp
80104e52:	89 e5                	mov    %esp,%ebp
80104e54:	83 ec 10             	sub    $0x10,%esp
80104e57:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
80104e5e:	eb 04                	jmp    80104e64 <strlen+0x13>
80104e60:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
80104e64:	8b 55 fc             	mov    -0x4(%ebp),%edx
80104e67:	8b 45 08             	mov    0x8(%ebp),%eax
80104e6a:	01 d0                	add    %edx,%eax
80104e6c:	0f b6 00             	movzbl (%eax),%eax
80104e6f:	84 c0                	test   %al,%al
80104e71:	75 ed                	jne    80104e60 <strlen+0xf>
80104e73:	8b 45 fc             	mov    -0x4(%ebp),%eax
80104e76:	c9                   	leave  
80104e77:	c3                   	ret    

80104e78 <swtch>:
80104e78:	8b 44 24 04          	mov    0x4(%esp),%eax
80104e7c:	8b 54 24 08          	mov    0x8(%esp),%edx
80104e80:	55                   	push   %ebp
80104e81:	53                   	push   %ebx
80104e82:	56                   	push   %esi
80104e83:	57                   	push   %edi
80104e84:	89 20                	mov    %esp,(%eax)
80104e86:	89 d4                	mov    %edx,%esp
80104e88:	5f                   	pop    %edi
80104e89:	5e                   	pop    %esi
80104e8a:	5b                   	pop    %ebx
80104e8b:	5d                   	pop    %ebp
80104e8c:	c3                   	ret    

80104e8d <fetchint>:
// to a saved program counter, and then the first argument.

// Fetch the int at addr from the current process.
int
fetchint(uint addr, int *ip)
{
80104e8d:	55                   	push   %ebp
80104e8e:	89 e5                	mov    %esp,%ebp
80104e90:	83 ec 18             	sub    $0x18,%esp
  struct proc *curproc = myproc();
80104e93:	e8 98 eb ff ff       	call   80103a30 <myproc>
80104e98:	89 45 f4             	mov    %eax,-0xc(%ebp)

  if(addr >= curproc->sz || addr+4 > curproc->sz)
80104e9b:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104e9e:	8b 00                	mov    (%eax),%eax
80104ea0:	39 45 08             	cmp    %eax,0x8(%ebp)
80104ea3:	73 0f                	jae    80104eb4 <fetchint+0x27>
80104ea5:	8b 45 08             	mov    0x8(%ebp),%eax
80104ea8:	8d 50 04             	lea    0x4(%eax),%edx
80104eab:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104eae:	8b 00                	mov    (%eax),%eax
80104eb0:	39 c2                	cmp    %eax,%edx
80104eb2:	76 07                	jbe    80104ebb <fetchint+0x2e>
    return -1;
80104eb4:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104eb9:	eb 0f                	jmp    80104eca <fetchint+0x3d>
  *ip = *(int*)(addr);
80104ebb:	8b 45 08             	mov    0x8(%ebp),%eax
80104ebe:	8b 10                	mov    (%eax),%edx
80104ec0:	8b 45 0c             	mov    0xc(%ebp),%eax
80104ec3:	89 10                	mov    %edx,(%eax)
  return 0;
80104ec5:	b8 00 00 00 00       	mov    $0x0,%eax
}
80104eca:	c9                   	leave  
80104ecb:	c3                   	ret    

80104ecc <fetchstr>:
// Fetch the nul-terminated string at addr from the current process.
// Doesn't actually copy the string - just sets *pp to point at it.
// Returns length of string, not including nul.
int
fetchstr(uint addr, char **pp)
{
80104ecc:	55                   	push   %ebp
80104ecd:	89 e5                	mov    %esp,%ebp
80104ecf:	83 ec 18             	sub    $0x18,%esp
  char *s, *ep;
  struct proc *curproc = myproc();
80104ed2:	e8 59 eb ff ff       	call   80103a30 <myproc>
80104ed7:	89 45 f0             	mov    %eax,-0x10(%ebp)

  if(addr >= curproc->sz)
80104eda:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104edd:	8b 00                	mov    (%eax),%eax
80104edf:	39 45 08             	cmp    %eax,0x8(%ebp)
80104ee2:	72 07                	jb     80104eeb <fetchstr+0x1f>
    return -1;
80104ee4:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104ee9:	eb 41                	jmp    80104f2c <fetchstr+0x60>
  *pp = (char*)addr;
80104eeb:	8b 55 08             	mov    0x8(%ebp),%edx
80104eee:	8b 45 0c             	mov    0xc(%ebp),%eax
80104ef1:	89 10                	mov    %edx,(%eax)
  ep = (char*)curproc->sz;
80104ef3:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104ef6:	8b 00                	mov    (%eax),%eax
80104ef8:	89 45 ec             	mov    %eax,-0x14(%ebp)
  for(s = *pp; s < ep; s++){
80104efb:	8b 45 0c             	mov    0xc(%ebp),%eax
80104efe:	8b 00                	mov    (%eax),%eax
80104f00:	89 45 f4             	mov    %eax,-0xc(%ebp)
80104f03:	eb 1a                	jmp    80104f1f <fetchstr+0x53>
    if(*s == 0)
80104f05:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104f08:	0f b6 00             	movzbl (%eax),%eax
80104f0b:	84 c0                	test   %al,%al
80104f0d:	75 0c                	jne    80104f1b <fetchstr+0x4f>
      return s - *pp;
80104f0f:	8b 45 0c             	mov    0xc(%ebp),%eax
80104f12:	8b 10                	mov    (%eax),%edx
80104f14:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104f17:	29 d0                	sub    %edx,%eax
80104f19:	eb 11                	jmp    80104f2c <fetchstr+0x60>
  for(s = *pp; s < ep; s++){
80104f1b:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80104f1f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104f22:	3b 45 ec             	cmp    -0x14(%ebp),%eax
80104f25:	72 de                	jb     80104f05 <fetchstr+0x39>
  }
  return -1;
80104f27:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104f2c:	c9                   	leave  
80104f2d:	c3                   	ret    

80104f2e <argint>:

// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
80104f2e:	55                   	push   %ebp
80104f2f:	89 e5                	mov    %esp,%ebp
80104f31:	83 ec 08             	sub    $0x8,%esp
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80104f34:	e8 f7 ea ff ff       	call   80103a30 <myproc>
80104f39:	8b 40 18             	mov    0x18(%eax),%eax
80104f3c:	8b 50 44             	mov    0x44(%eax),%edx
80104f3f:	8b 45 08             	mov    0x8(%ebp),%eax
80104f42:	c1 e0 02             	shl    $0x2,%eax
80104f45:	01 d0                	add    %edx,%eax
80104f47:	83 c0 04             	add    $0x4,%eax
80104f4a:	83 ec 08             	sub    $0x8,%esp
80104f4d:	ff 75 0c             	push   0xc(%ebp)
80104f50:	50                   	push   %eax
80104f51:	e8 37 ff ff ff       	call   80104e8d <fetchint>
80104f56:	83 c4 10             	add    $0x10,%esp
}
80104f59:	c9                   	leave  
80104f5a:	c3                   	ret    

80104f5b <argptr>:
// Fetch the nth word-sized system call argument as a pointer
// to a block of memory of size bytes.  Check that the pointer
// lies within the process address space.
int
argptr(int n, char **pp, int size)
{
80104f5b:	55                   	push   %ebp
80104f5c:	89 e5                	mov    %esp,%ebp
80104f5e:	83 ec 18             	sub    $0x18,%esp
  int i;
  struct proc *curproc = myproc();
80104f61:	e8 ca ea ff ff       	call   80103a30 <myproc>
80104f66:	89 45 f4             	mov    %eax,-0xc(%ebp)
 
  if(argint(n, &i) < 0)
80104f69:	83 ec 08             	sub    $0x8,%esp
80104f6c:	8d 45 f0             	lea    -0x10(%ebp),%eax
80104f6f:	50                   	push   %eax
80104f70:	ff 75 08             	push   0x8(%ebp)
80104f73:	e8 b6 ff ff ff       	call   80104f2e <argint>
80104f78:	83 c4 10             	add    $0x10,%esp
80104f7b:	85 c0                	test   %eax,%eax
80104f7d:	79 07                	jns    80104f86 <argptr+0x2b>
    return -1;
80104f7f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104f84:	eb 3b                	jmp    80104fc1 <argptr+0x66>
  if(size < 0 || (uint)i >= curproc->sz || (uint)i+size > curproc->sz)
80104f86:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
80104f8a:	78 1f                	js     80104fab <argptr+0x50>
80104f8c:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104f8f:	8b 00                	mov    (%eax),%eax
80104f91:	8b 55 f0             	mov    -0x10(%ebp),%edx
80104f94:	39 d0                	cmp    %edx,%eax
80104f96:	76 13                	jbe    80104fab <argptr+0x50>
80104f98:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104f9b:	89 c2                	mov    %eax,%edx
80104f9d:	8b 45 10             	mov    0x10(%ebp),%eax
80104fa0:	01 c2                	add    %eax,%edx
80104fa2:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104fa5:	8b 00                	mov    (%eax),%eax
80104fa7:	39 c2                	cmp    %eax,%edx
80104fa9:	76 07                	jbe    80104fb2 <argptr+0x57>
    return -1;
80104fab:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104fb0:	eb 0f                	jmp    80104fc1 <argptr+0x66>
  *pp = (char*)i;
80104fb2:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104fb5:	89 c2                	mov    %eax,%edx
80104fb7:	8b 45 0c             	mov    0xc(%ebp),%eax
80104fba:	89 10                	mov    %edx,(%eax)
  return 0;
80104fbc:	b8 00 00 00 00       	mov    $0x0,%eax
}
80104fc1:	c9                   	leave  
80104fc2:	c3                   	ret    

80104fc3 <argstr>:
// Check that the pointer is valid and the string is nul-terminated.
// (There is no shared writable memory, so the string can't change
// between this check and being used by the kernel.)
int
argstr(int n, char **pp)
{
80104fc3:	55                   	push   %ebp
80104fc4:	89 e5                	mov    %esp,%ebp
80104fc6:	83 ec 18             	sub    $0x18,%esp
  int addr;
  if(argint(n, &addr) < 0)
80104fc9:	83 ec 08             	sub    $0x8,%esp
80104fcc:	8d 45 f4             	lea    -0xc(%ebp),%eax
80104fcf:	50                   	push   %eax
80104fd0:	ff 75 08             	push   0x8(%ebp)
80104fd3:	e8 56 ff ff ff       	call   80104f2e <argint>
80104fd8:	83 c4 10             	add    $0x10,%esp
80104fdb:	85 c0                	test   %eax,%eax
80104fdd:	79 07                	jns    80104fe6 <argstr+0x23>
    return -1;
80104fdf:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104fe4:	eb 12                	jmp    80104ff8 <argstr+0x35>
  return fetchstr(addr, pp);
80104fe6:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104fe9:	83 ec 08             	sub    $0x8,%esp
80104fec:	ff 75 0c             	push   0xc(%ebp)
80104fef:	50                   	push   %eax
80104ff0:	e8 d7 fe ff ff       	call   80104ecc <fetchstr>
80104ff5:	83 c4 10             	add    $0x10,%esp
}
80104ff8:	c9                   	leave  
80104ff9:	c3                   	ret    

80104ffa <syscall>:
[SYS_uthread_init]   sys_uthread_init,
};

void
syscall(void)
{
80104ffa:	55                   	push   %ebp
80104ffb:	89 e5                	mov    %esp,%ebp
80104ffd:	83 ec 18             	sub    $0x18,%esp
  int num;
  struct proc *curproc = myproc();
80105000:	e8 2b ea ff ff       	call   80103a30 <myproc>
80105005:	89 45 f4             	mov    %eax,-0xc(%ebp)

  num = curproc->tf->eax;
80105008:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010500b:	8b 40 18             	mov    0x18(%eax),%eax
8010500e:	8b 40 1c             	mov    0x1c(%eax),%eax
80105011:	89 45 f0             	mov    %eax,-0x10(%ebp)
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
80105014:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80105018:	7e 2f                	jle    80105049 <syscall+0x4f>
8010501a:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010501d:	83 f8 18             	cmp    $0x18,%eax
80105020:	77 27                	ja     80105049 <syscall+0x4f>
80105022:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105025:	8b 04 85 20 f0 10 80 	mov    -0x7fef0fe0(,%eax,4),%eax
8010502c:	85 c0                	test   %eax,%eax
8010502e:	74 19                	je     80105049 <syscall+0x4f>
    curproc->tf->eax = syscalls[num]();
80105030:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105033:	8b 04 85 20 f0 10 80 	mov    -0x7fef0fe0(,%eax,4),%eax
8010503a:	ff d0                	call   *%eax
8010503c:	89 c2                	mov    %eax,%edx
8010503e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105041:	8b 40 18             	mov    0x18(%eax),%eax
80105044:	89 50 1c             	mov    %edx,0x1c(%eax)
80105047:	eb 2c                	jmp    80105075 <syscall+0x7b>
  } else {
    cprintf("%d %s: unknown sys call %d\n",
            curproc->pid, curproc->name, num);
80105049:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010504c:	8d 50 6c             	lea    0x6c(%eax),%edx
    cprintf("%d %s: unknown sys call %d\n",
8010504f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105052:	8b 40 10             	mov    0x10(%eax),%eax
80105055:	ff 75 f0             	push   -0x10(%ebp)
80105058:	52                   	push   %edx
80105059:	50                   	push   %eax
8010505a:	68 38 a6 10 80       	push   $0x8010a638
8010505f:	e8 90 b3 ff ff       	call   801003f4 <cprintf>
80105064:	83 c4 10             	add    $0x10,%esp
    curproc->tf->eax = -1;
80105067:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010506a:	8b 40 18             	mov    0x18(%eax),%eax
8010506d:	c7 40 1c ff ff ff ff 	movl   $0xffffffff,0x1c(%eax)
  }
}
80105074:	90                   	nop
80105075:	90                   	nop
80105076:	c9                   	leave  
80105077:	c3                   	ret    

80105078 <argfd>:

// Fetch the nth word-sized system call argument as a file descriptor
// and return both the descriptor and the corresponding struct file.
static int
argfd(int n, int *pfd, struct file **pf)
{
80105078:	55                   	push   %ebp
80105079:	89 e5                	mov    %esp,%ebp
8010507b:	83 ec 18             	sub    $0x18,%esp
  int fd;
  struct file *f;

  if(argint(n, &fd) < 0)
8010507e:	83 ec 08             	sub    $0x8,%esp
80105081:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105084:	50                   	push   %eax
80105085:	ff 75 08             	push   0x8(%ebp)
80105088:	e8 a1 fe ff ff       	call   80104f2e <argint>
8010508d:	83 c4 10             	add    $0x10,%esp
80105090:	85 c0                	test   %eax,%eax
80105092:	79 07                	jns    8010509b <argfd+0x23>
    return -1;
80105094:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105099:	eb 4f                	jmp    801050ea <argfd+0x72>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
8010509b:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010509e:	85 c0                	test   %eax,%eax
801050a0:	78 20                	js     801050c2 <argfd+0x4a>
801050a2:	8b 45 f0             	mov    -0x10(%ebp),%eax
801050a5:	83 f8 0f             	cmp    $0xf,%eax
801050a8:	7f 18                	jg     801050c2 <argfd+0x4a>
801050aa:	e8 81 e9 ff ff       	call   80103a30 <myproc>
801050af:	8b 55 f0             	mov    -0x10(%ebp),%edx
801050b2:	83 c2 08             	add    $0x8,%edx
801050b5:	8b 44 90 08          	mov    0x8(%eax,%edx,4),%eax
801050b9:	89 45 f4             	mov    %eax,-0xc(%ebp)
801050bc:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801050c0:	75 07                	jne    801050c9 <argfd+0x51>
    return -1;
801050c2:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801050c7:	eb 21                	jmp    801050ea <argfd+0x72>
  if(pfd)
801050c9:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
801050cd:	74 08                	je     801050d7 <argfd+0x5f>
    *pfd = fd;
801050cf:	8b 55 f0             	mov    -0x10(%ebp),%edx
801050d2:	8b 45 0c             	mov    0xc(%ebp),%eax
801050d5:	89 10                	mov    %edx,(%eax)
  if(pf)
801050d7:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
801050db:	74 08                	je     801050e5 <argfd+0x6d>
    *pf = f;
801050dd:	8b 45 10             	mov    0x10(%ebp),%eax
801050e0:	8b 55 f4             	mov    -0xc(%ebp),%edx
801050e3:	89 10                	mov    %edx,(%eax)
  return 0;
801050e5:	b8 00 00 00 00       	mov    $0x0,%eax
}
801050ea:	c9                   	leave  
801050eb:	c3                   	ret    

801050ec <fdalloc>:

// Allocate a file descriptor for the given file.
// Takes over file reference from caller on success.
static int
fdalloc(struct file *f)
{
801050ec:	55                   	push   %ebp
801050ed:	89 e5                	mov    %esp,%ebp
801050ef:	83 ec 18             	sub    $0x18,%esp
  int fd;
  struct proc *curproc = myproc();
801050f2:	e8 39 e9 ff ff       	call   80103a30 <myproc>
801050f7:	89 45 f0             	mov    %eax,-0x10(%ebp)

  for(fd = 0; fd < NOFILE; fd++){
801050fa:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80105101:	eb 2a                	jmp    8010512d <fdalloc+0x41>
    if(curproc->ofile[fd] == 0){
80105103:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105106:	8b 55 f4             	mov    -0xc(%ebp),%edx
80105109:	83 c2 08             	add    $0x8,%edx
8010510c:	8b 44 90 08          	mov    0x8(%eax,%edx,4),%eax
80105110:	85 c0                	test   %eax,%eax
80105112:	75 15                	jne    80105129 <fdalloc+0x3d>
      curproc->ofile[fd] = f;
80105114:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105117:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010511a:	8d 4a 08             	lea    0x8(%edx),%ecx
8010511d:	8b 55 08             	mov    0x8(%ebp),%edx
80105120:	89 54 88 08          	mov    %edx,0x8(%eax,%ecx,4)
      return fd;
80105124:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105127:	eb 0f                	jmp    80105138 <fdalloc+0x4c>
  for(fd = 0; fd < NOFILE; fd++){
80105129:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
8010512d:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
80105131:	7e d0                	jle    80105103 <fdalloc+0x17>
    }
  }
  return -1;
80105133:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105138:	c9                   	leave  
80105139:	c3                   	ret    

8010513a <sys_dup>:

int
sys_dup(void)
{
8010513a:	55                   	push   %ebp
8010513b:	89 e5                	mov    %esp,%ebp
8010513d:	83 ec 18             	sub    $0x18,%esp
  struct file *f;
  int fd;

  if(argfd(0, 0, &f) < 0)
80105140:	83 ec 04             	sub    $0x4,%esp
80105143:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105146:	50                   	push   %eax
80105147:	6a 00                	push   $0x0
80105149:	6a 00                	push   $0x0
8010514b:	e8 28 ff ff ff       	call   80105078 <argfd>
80105150:	83 c4 10             	add    $0x10,%esp
80105153:	85 c0                	test   %eax,%eax
80105155:	79 07                	jns    8010515e <sys_dup+0x24>
    return -1;
80105157:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010515c:	eb 31                	jmp    8010518f <sys_dup+0x55>
  if((fd=fdalloc(f)) < 0)
8010515e:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105161:	83 ec 0c             	sub    $0xc,%esp
80105164:	50                   	push   %eax
80105165:	e8 82 ff ff ff       	call   801050ec <fdalloc>
8010516a:	83 c4 10             	add    $0x10,%esp
8010516d:	89 45 f4             	mov    %eax,-0xc(%ebp)
80105170:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80105174:	79 07                	jns    8010517d <sys_dup+0x43>
    return -1;
80105176:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010517b:	eb 12                	jmp    8010518f <sys_dup+0x55>
  filedup(f);
8010517d:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105180:	83 ec 0c             	sub    $0xc,%esp
80105183:	50                   	push   %eax
80105184:	e8 c1 be ff ff       	call   8010104a <filedup>
80105189:	83 c4 10             	add    $0x10,%esp
  return fd;
8010518c:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
8010518f:	c9                   	leave  
80105190:	c3                   	ret    

80105191 <sys_read>:

int
sys_read(void)
{
80105191:	55                   	push   %ebp
80105192:	89 e5                	mov    %esp,%ebp
80105194:	83 ec 18             	sub    $0x18,%esp
  struct file *f;
  int n;
  char *p;

  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80105197:	83 ec 04             	sub    $0x4,%esp
8010519a:	8d 45 f4             	lea    -0xc(%ebp),%eax
8010519d:	50                   	push   %eax
8010519e:	6a 00                	push   $0x0
801051a0:	6a 00                	push   $0x0
801051a2:	e8 d1 fe ff ff       	call   80105078 <argfd>
801051a7:	83 c4 10             	add    $0x10,%esp
801051aa:	85 c0                	test   %eax,%eax
801051ac:	78 2e                	js     801051dc <sys_read+0x4b>
801051ae:	83 ec 08             	sub    $0x8,%esp
801051b1:	8d 45 f0             	lea    -0x10(%ebp),%eax
801051b4:	50                   	push   %eax
801051b5:	6a 02                	push   $0x2
801051b7:	e8 72 fd ff ff       	call   80104f2e <argint>
801051bc:	83 c4 10             	add    $0x10,%esp
801051bf:	85 c0                	test   %eax,%eax
801051c1:	78 19                	js     801051dc <sys_read+0x4b>
801051c3:	8b 45 f0             	mov    -0x10(%ebp),%eax
801051c6:	83 ec 04             	sub    $0x4,%esp
801051c9:	50                   	push   %eax
801051ca:	8d 45 ec             	lea    -0x14(%ebp),%eax
801051cd:	50                   	push   %eax
801051ce:	6a 01                	push   $0x1
801051d0:	e8 86 fd ff ff       	call   80104f5b <argptr>
801051d5:	83 c4 10             	add    $0x10,%esp
801051d8:	85 c0                	test   %eax,%eax
801051da:	79 07                	jns    801051e3 <sys_read+0x52>
    return -1;
801051dc:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801051e1:	eb 17                	jmp    801051fa <sys_read+0x69>
  return fileread(f, p, n);
801051e3:	8b 4d f0             	mov    -0x10(%ebp),%ecx
801051e6:	8b 55 ec             	mov    -0x14(%ebp),%edx
801051e9:	8b 45 f4             	mov    -0xc(%ebp),%eax
801051ec:	83 ec 04             	sub    $0x4,%esp
801051ef:	51                   	push   %ecx
801051f0:	52                   	push   %edx
801051f1:	50                   	push   %eax
801051f2:	e8 e3 bf ff ff       	call   801011da <fileread>
801051f7:	83 c4 10             	add    $0x10,%esp
}
801051fa:	c9                   	leave  
801051fb:	c3                   	ret    

801051fc <sys_write>:

int
sys_write(void)
{
801051fc:	55                   	push   %ebp
801051fd:	89 e5                	mov    %esp,%ebp
801051ff:	83 ec 18             	sub    $0x18,%esp
  struct file *f;
  int n;
  char *p;

  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80105202:	83 ec 04             	sub    $0x4,%esp
80105205:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105208:	50                   	push   %eax
80105209:	6a 00                	push   $0x0
8010520b:	6a 00                	push   $0x0
8010520d:	e8 66 fe ff ff       	call   80105078 <argfd>
80105212:	83 c4 10             	add    $0x10,%esp
80105215:	85 c0                	test   %eax,%eax
80105217:	78 2e                	js     80105247 <sys_write+0x4b>
80105219:	83 ec 08             	sub    $0x8,%esp
8010521c:	8d 45 f0             	lea    -0x10(%ebp),%eax
8010521f:	50                   	push   %eax
80105220:	6a 02                	push   $0x2
80105222:	e8 07 fd ff ff       	call   80104f2e <argint>
80105227:	83 c4 10             	add    $0x10,%esp
8010522a:	85 c0                	test   %eax,%eax
8010522c:	78 19                	js     80105247 <sys_write+0x4b>
8010522e:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105231:	83 ec 04             	sub    $0x4,%esp
80105234:	50                   	push   %eax
80105235:	8d 45 ec             	lea    -0x14(%ebp),%eax
80105238:	50                   	push   %eax
80105239:	6a 01                	push   $0x1
8010523b:	e8 1b fd ff ff       	call   80104f5b <argptr>
80105240:	83 c4 10             	add    $0x10,%esp
80105243:	85 c0                	test   %eax,%eax
80105245:	79 07                	jns    8010524e <sys_write+0x52>
    return -1;
80105247:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010524c:	eb 17                	jmp    80105265 <sys_write+0x69>
  return filewrite(f, p, n);
8010524e:	8b 4d f0             	mov    -0x10(%ebp),%ecx
80105251:	8b 55 ec             	mov    -0x14(%ebp),%edx
80105254:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105257:	83 ec 04             	sub    $0x4,%esp
8010525a:	51                   	push   %ecx
8010525b:	52                   	push   %edx
8010525c:	50                   	push   %eax
8010525d:	e8 30 c0 ff ff       	call   80101292 <filewrite>
80105262:	83 c4 10             	add    $0x10,%esp
}
80105265:	c9                   	leave  
80105266:	c3                   	ret    

80105267 <sys_close>:

int
sys_close(void)
{
80105267:	55                   	push   %ebp
80105268:	89 e5                	mov    %esp,%ebp
8010526a:	83 ec 18             	sub    $0x18,%esp
  int fd;
  struct file *f;

  if(argfd(0, &fd, &f) < 0)
8010526d:	83 ec 04             	sub    $0x4,%esp
80105270:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105273:	50                   	push   %eax
80105274:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105277:	50                   	push   %eax
80105278:	6a 00                	push   $0x0
8010527a:	e8 f9 fd ff ff       	call   80105078 <argfd>
8010527f:	83 c4 10             	add    $0x10,%esp
80105282:	85 c0                	test   %eax,%eax
80105284:	79 07                	jns    8010528d <sys_close+0x26>
    return -1;
80105286:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010528b:	eb 27                	jmp    801052b4 <sys_close+0x4d>
  myproc()->ofile[fd] = 0;
8010528d:	e8 9e e7 ff ff       	call   80103a30 <myproc>
80105292:	8b 55 f4             	mov    -0xc(%ebp),%edx
80105295:	83 c2 08             	add    $0x8,%edx
80105298:	c7 44 90 08 00 00 00 	movl   $0x0,0x8(%eax,%edx,4)
8010529f:	00 
  fileclose(f);
801052a0:	8b 45 f0             	mov    -0x10(%ebp),%eax
801052a3:	83 ec 0c             	sub    $0xc,%esp
801052a6:	50                   	push   %eax
801052a7:	e8 ef bd ff ff       	call   8010109b <fileclose>
801052ac:	83 c4 10             	add    $0x10,%esp
  return 0;
801052af:	b8 00 00 00 00       	mov    $0x0,%eax
}
801052b4:	c9                   	leave  
801052b5:	c3                   	ret    

801052b6 <sys_fstat>:

int
sys_fstat(void)
{
801052b6:	55                   	push   %ebp
801052b7:	89 e5                	mov    %esp,%ebp
801052b9:	83 ec 18             	sub    $0x18,%esp
  struct file *f;
  struct stat *st;

  if(argfd(0, 0, &f) < 0 || argptr(1, (void*)&st, sizeof(*st)) < 0)
801052bc:	83 ec 04             	sub    $0x4,%esp
801052bf:	8d 45 f4             	lea    -0xc(%ebp),%eax
801052c2:	50                   	push   %eax
801052c3:	6a 00                	push   $0x0
801052c5:	6a 00                	push   $0x0
801052c7:	e8 ac fd ff ff       	call   80105078 <argfd>
801052cc:	83 c4 10             	add    $0x10,%esp
801052cf:	85 c0                	test   %eax,%eax
801052d1:	78 17                	js     801052ea <sys_fstat+0x34>
801052d3:	83 ec 04             	sub    $0x4,%esp
801052d6:	6a 14                	push   $0x14
801052d8:	8d 45 f0             	lea    -0x10(%ebp),%eax
801052db:	50                   	push   %eax
801052dc:	6a 01                	push   $0x1
801052de:	e8 78 fc ff ff       	call   80104f5b <argptr>
801052e3:	83 c4 10             	add    $0x10,%esp
801052e6:	85 c0                	test   %eax,%eax
801052e8:	79 07                	jns    801052f1 <sys_fstat+0x3b>
    return -1;
801052ea:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801052ef:	eb 13                	jmp    80105304 <sys_fstat+0x4e>
  return filestat(f, st);
801052f1:	8b 55 f0             	mov    -0x10(%ebp),%edx
801052f4:	8b 45 f4             	mov    -0xc(%ebp),%eax
801052f7:	83 ec 08             	sub    $0x8,%esp
801052fa:	52                   	push   %edx
801052fb:	50                   	push   %eax
801052fc:	e8 82 be ff ff       	call   80101183 <filestat>
80105301:	83 c4 10             	add    $0x10,%esp
}
80105304:	c9                   	leave  
80105305:	c3                   	ret    

80105306 <sys_link>:

// Create the path new as a link to the same inode as old.
int
sys_link(void)
{
80105306:	55                   	push   %ebp
80105307:	89 e5                	mov    %esp,%ebp
80105309:	83 ec 28             	sub    $0x28,%esp
  char name[DIRSIZ], *new, *old;
  struct inode *dp, *ip;

  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
8010530c:	83 ec 08             	sub    $0x8,%esp
8010530f:	8d 45 d8             	lea    -0x28(%ebp),%eax
80105312:	50                   	push   %eax
80105313:	6a 00                	push   $0x0
80105315:	e8 a9 fc ff ff       	call   80104fc3 <argstr>
8010531a:	83 c4 10             	add    $0x10,%esp
8010531d:	85 c0                	test   %eax,%eax
8010531f:	78 15                	js     80105336 <sys_link+0x30>
80105321:	83 ec 08             	sub    $0x8,%esp
80105324:	8d 45 dc             	lea    -0x24(%ebp),%eax
80105327:	50                   	push   %eax
80105328:	6a 01                	push   $0x1
8010532a:	e8 94 fc ff ff       	call   80104fc3 <argstr>
8010532f:	83 c4 10             	add    $0x10,%esp
80105332:	85 c0                	test   %eax,%eax
80105334:	79 0a                	jns    80105340 <sys_link+0x3a>
    return -1;
80105336:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010533b:	e9 68 01 00 00       	jmp    801054a8 <sys_link+0x1a2>

  begin_op();
80105340:	e8 f7 dc ff ff       	call   8010303c <begin_op>
  if((ip = namei(old)) == 0){
80105345:	8b 45 d8             	mov    -0x28(%ebp),%eax
80105348:	83 ec 0c             	sub    $0xc,%esp
8010534b:	50                   	push   %eax
8010534c:	e8 cc d1 ff ff       	call   8010251d <namei>
80105351:	83 c4 10             	add    $0x10,%esp
80105354:	89 45 f4             	mov    %eax,-0xc(%ebp)
80105357:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
8010535b:	75 0f                	jne    8010536c <sys_link+0x66>
    end_op();
8010535d:	e8 66 dd ff ff       	call   801030c8 <end_op>
    return -1;
80105362:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105367:	e9 3c 01 00 00       	jmp    801054a8 <sys_link+0x1a2>
  }

  ilock(ip);
8010536c:	83 ec 0c             	sub    $0xc,%esp
8010536f:	ff 75 f4             	push   -0xc(%ebp)
80105372:	e8 73 c6 ff ff       	call   801019ea <ilock>
80105377:	83 c4 10             	add    $0x10,%esp
  if(ip->type == T_DIR){
8010537a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010537d:	0f b7 40 50          	movzwl 0x50(%eax),%eax
80105381:	66 83 f8 01          	cmp    $0x1,%ax
80105385:	75 1d                	jne    801053a4 <sys_link+0x9e>
    iunlockput(ip);
80105387:	83 ec 0c             	sub    $0xc,%esp
8010538a:	ff 75 f4             	push   -0xc(%ebp)
8010538d:	e8 89 c8 ff ff       	call   80101c1b <iunlockput>
80105392:	83 c4 10             	add    $0x10,%esp
    end_op();
80105395:	e8 2e dd ff ff       	call   801030c8 <end_op>
    return -1;
8010539a:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010539f:	e9 04 01 00 00       	jmp    801054a8 <sys_link+0x1a2>
  }

  ip->nlink++;
801053a4:	8b 45 f4             	mov    -0xc(%ebp),%eax
801053a7:	0f b7 40 56          	movzwl 0x56(%eax),%eax
801053ab:	83 c0 01             	add    $0x1,%eax
801053ae:	89 c2                	mov    %eax,%edx
801053b0:	8b 45 f4             	mov    -0xc(%ebp),%eax
801053b3:	66 89 50 56          	mov    %dx,0x56(%eax)
  iupdate(ip);
801053b7:	83 ec 0c             	sub    $0xc,%esp
801053ba:	ff 75 f4             	push   -0xc(%ebp)
801053bd:	e8 4b c4 ff ff       	call   8010180d <iupdate>
801053c2:	83 c4 10             	add    $0x10,%esp
  iunlock(ip);
801053c5:	83 ec 0c             	sub    $0xc,%esp
801053c8:	ff 75 f4             	push   -0xc(%ebp)
801053cb:	e8 2d c7 ff ff       	call   80101afd <iunlock>
801053d0:	83 c4 10             	add    $0x10,%esp

  if((dp = nameiparent(new, name)) == 0)
801053d3:	8b 45 dc             	mov    -0x24(%ebp),%eax
801053d6:	83 ec 08             	sub    $0x8,%esp
801053d9:	8d 55 e2             	lea    -0x1e(%ebp),%edx
801053dc:	52                   	push   %edx
801053dd:	50                   	push   %eax
801053de:	e8 56 d1 ff ff       	call   80102539 <nameiparent>
801053e3:	83 c4 10             	add    $0x10,%esp
801053e6:	89 45 f0             	mov    %eax,-0x10(%ebp)
801053e9:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
801053ed:	74 71                	je     80105460 <sys_link+0x15a>
    goto bad;
  ilock(dp);
801053ef:	83 ec 0c             	sub    $0xc,%esp
801053f2:	ff 75 f0             	push   -0x10(%ebp)
801053f5:	e8 f0 c5 ff ff       	call   801019ea <ilock>
801053fa:	83 c4 10             	add    $0x10,%esp
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
801053fd:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105400:	8b 10                	mov    (%eax),%edx
80105402:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105405:	8b 00                	mov    (%eax),%eax
80105407:	39 c2                	cmp    %eax,%edx
80105409:	75 1d                	jne    80105428 <sys_link+0x122>
8010540b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010540e:	8b 40 04             	mov    0x4(%eax),%eax
80105411:	83 ec 04             	sub    $0x4,%esp
80105414:	50                   	push   %eax
80105415:	8d 45 e2             	lea    -0x1e(%ebp),%eax
80105418:	50                   	push   %eax
80105419:	ff 75 f0             	push   -0x10(%ebp)
8010541c:	e8 65 ce ff ff       	call   80102286 <dirlink>
80105421:	83 c4 10             	add    $0x10,%esp
80105424:	85 c0                	test   %eax,%eax
80105426:	79 10                	jns    80105438 <sys_link+0x132>
    iunlockput(dp);
80105428:	83 ec 0c             	sub    $0xc,%esp
8010542b:	ff 75 f0             	push   -0x10(%ebp)
8010542e:	e8 e8 c7 ff ff       	call   80101c1b <iunlockput>
80105433:	83 c4 10             	add    $0x10,%esp
    goto bad;
80105436:	eb 29                	jmp    80105461 <sys_link+0x15b>
  }
  iunlockput(dp);
80105438:	83 ec 0c             	sub    $0xc,%esp
8010543b:	ff 75 f0             	push   -0x10(%ebp)
8010543e:	e8 d8 c7 ff ff       	call   80101c1b <iunlockput>
80105443:	83 c4 10             	add    $0x10,%esp
  iput(ip);
80105446:	83 ec 0c             	sub    $0xc,%esp
80105449:	ff 75 f4             	push   -0xc(%ebp)
8010544c:	e8 fa c6 ff ff       	call   80101b4b <iput>
80105451:	83 c4 10             	add    $0x10,%esp

  end_op();
80105454:	e8 6f dc ff ff       	call   801030c8 <end_op>

  return 0;
80105459:	b8 00 00 00 00       	mov    $0x0,%eax
8010545e:	eb 48                	jmp    801054a8 <sys_link+0x1a2>
    goto bad;
80105460:	90                   	nop

bad:
  ilock(ip);
80105461:	83 ec 0c             	sub    $0xc,%esp
80105464:	ff 75 f4             	push   -0xc(%ebp)
80105467:	e8 7e c5 ff ff       	call   801019ea <ilock>
8010546c:	83 c4 10             	add    $0x10,%esp
  ip->nlink--;
8010546f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105472:	0f b7 40 56          	movzwl 0x56(%eax),%eax
80105476:	83 e8 01             	sub    $0x1,%eax
80105479:	89 c2                	mov    %eax,%edx
8010547b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010547e:	66 89 50 56          	mov    %dx,0x56(%eax)
  iupdate(ip);
80105482:	83 ec 0c             	sub    $0xc,%esp
80105485:	ff 75 f4             	push   -0xc(%ebp)
80105488:	e8 80 c3 ff ff       	call   8010180d <iupdate>
8010548d:	83 c4 10             	add    $0x10,%esp
  iunlockput(ip);
80105490:	83 ec 0c             	sub    $0xc,%esp
80105493:	ff 75 f4             	push   -0xc(%ebp)
80105496:	e8 80 c7 ff ff       	call   80101c1b <iunlockput>
8010549b:	83 c4 10             	add    $0x10,%esp
  end_op();
8010549e:	e8 25 dc ff ff       	call   801030c8 <end_op>
  return -1;
801054a3:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801054a8:	c9                   	leave  
801054a9:	c3                   	ret    

801054aa <isdirempty>:

// Is the directory dp empty except for "." and ".." ?
static int
isdirempty(struct inode *dp)
{
801054aa:	55                   	push   %ebp
801054ab:	89 e5                	mov    %esp,%ebp
801054ad:	83 ec 28             	sub    $0x28,%esp
  int off;
  struct dirent de;

  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
801054b0:	c7 45 f4 20 00 00 00 	movl   $0x20,-0xc(%ebp)
801054b7:	eb 40                	jmp    801054f9 <isdirempty+0x4f>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
801054b9:	8b 45 f4             	mov    -0xc(%ebp),%eax
801054bc:	6a 10                	push   $0x10
801054be:	50                   	push   %eax
801054bf:	8d 45 e4             	lea    -0x1c(%ebp),%eax
801054c2:	50                   	push   %eax
801054c3:	ff 75 08             	push   0x8(%ebp)
801054c6:	e8 0b ca ff ff       	call   80101ed6 <readi>
801054cb:	83 c4 10             	add    $0x10,%esp
801054ce:	83 f8 10             	cmp    $0x10,%eax
801054d1:	74 0d                	je     801054e0 <isdirempty+0x36>
      panic("isdirempty: readi");
801054d3:	83 ec 0c             	sub    $0xc,%esp
801054d6:	68 54 a6 10 80       	push   $0x8010a654
801054db:	e8 c9 b0 ff ff       	call   801005a9 <panic>
    if(de.inum != 0)
801054e0:	0f b7 45 e4          	movzwl -0x1c(%ebp),%eax
801054e4:	66 85 c0             	test   %ax,%ax
801054e7:	74 07                	je     801054f0 <isdirempty+0x46>
      return 0;
801054e9:	b8 00 00 00 00       	mov    $0x0,%eax
801054ee:	eb 1b                	jmp    8010550b <isdirempty+0x61>
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
801054f0:	8b 45 f4             	mov    -0xc(%ebp),%eax
801054f3:	83 c0 10             	add    $0x10,%eax
801054f6:	89 45 f4             	mov    %eax,-0xc(%ebp)
801054f9:	8b 45 08             	mov    0x8(%ebp),%eax
801054fc:	8b 50 58             	mov    0x58(%eax),%edx
801054ff:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105502:	39 c2                	cmp    %eax,%edx
80105504:	77 b3                	ja     801054b9 <isdirempty+0xf>
  }
  return 1;
80105506:	b8 01 00 00 00       	mov    $0x1,%eax
}
8010550b:	c9                   	leave  
8010550c:	c3                   	ret    

8010550d <sys_unlink>:

//PAGEBREAK!
int
sys_unlink(void)
{
8010550d:	55                   	push   %ebp
8010550e:	89 e5                	mov    %esp,%ebp
80105510:	83 ec 38             	sub    $0x38,%esp
  struct inode *ip, *dp;
  struct dirent de;
  char name[DIRSIZ], *path;
  uint off;

  if(argstr(0, &path) < 0)
80105513:	83 ec 08             	sub    $0x8,%esp
80105516:	8d 45 cc             	lea    -0x34(%ebp),%eax
80105519:	50                   	push   %eax
8010551a:	6a 00                	push   $0x0
8010551c:	e8 a2 fa ff ff       	call   80104fc3 <argstr>
80105521:	83 c4 10             	add    $0x10,%esp
80105524:	85 c0                	test   %eax,%eax
80105526:	79 0a                	jns    80105532 <sys_unlink+0x25>
    return -1;
80105528:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010552d:	e9 bf 01 00 00       	jmp    801056f1 <sys_unlink+0x1e4>

  begin_op();
80105532:	e8 05 db ff ff       	call   8010303c <begin_op>
  if((dp = nameiparent(path, name)) == 0){
80105537:	8b 45 cc             	mov    -0x34(%ebp),%eax
8010553a:	83 ec 08             	sub    $0x8,%esp
8010553d:	8d 55 d2             	lea    -0x2e(%ebp),%edx
80105540:	52                   	push   %edx
80105541:	50                   	push   %eax
80105542:	e8 f2 cf ff ff       	call   80102539 <nameiparent>
80105547:	83 c4 10             	add    $0x10,%esp
8010554a:	89 45 f4             	mov    %eax,-0xc(%ebp)
8010554d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80105551:	75 0f                	jne    80105562 <sys_unlink+0x55>
    end_op();
80105553:	e8 70 db ff ff       	call   801030c8 <end_op>
    return -1;
80105558:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010555d:	e9 8f 01 00 00       	jmp    801056f1 <sys_unlink+0x1e4>
  }

  ilock(dp);
80105562:	83 ec 0c             	sub    $0xc,%esp
80105565:	ff 75 f4             	push   -0xc(%ebp)
80105568:	e8 7d c4 ff ff       	call   801019ea <ilock>
8010556d:	83 c4 10             	add    $0x10,%esp

  // Cannot unlink "." or "..".
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
80105570:	83 ec 08             	sub    $0x8,%esp
80105573:	68 66 a6 10 80       	push   $0x8010a666
80105578:	8d 45 d2             	lea    -0x2e(%ebp),%eax
8010557b:	50                   	push   %eax
8010557c:	e8 30 cc ff ff       	call   801021b1 <namecmp>
80105581:	83 c4 10             	add    $0x10,%esp
80105584:	85 c0                	test   %eax,%eax
80105586:	0f 84 49 01 00 00    	je     801056d5 <sys_unlink+0x1c8>
8010558c:	83 ec 08             	sub    $0x8,%esp
8010558f:	68 68 a6 10 80       	push   $0x8010a668
80105594:	8d 45 d2             	lea    -0x2e(%ebp),%eax
80105597:	50                   	push   %eax
80105598:	e8 14 cc ff ff       	call   801021b1 <namecmp>
8010559d:	83 c4 10             	add    $0x10,%esp
801055a0:	85 c0                	test   %eax,%eax
801055a2:	0f 84 2d 01 00 00    	je     801056d5 <sys_unlink+0x1c8>
    goto bad;

  if((ip = dirlookup(dp, name, &off)) == 0)
801055a8:	83 ec 04             	sub    $0x4,%esp
801055ab:	8d 45 c8             	lea    -0x38(%ebp),%eax
801055ae:	50                   	push   %eax
801055af:	8d 45 d2             	lea    -0x2e(%ebp),%eax
801055b2:	50                   	push   %eax
801055b3:	ff 75 f4             	push   -0xc(%ebp)
801055b6:	e8 11 cc ff ff       	call   801021cc <dirlookup>
801055bb:	83 c4 10             	add    $0x10,%esp
801055be:	89 45 f0             	mov    %eax,-0x10(%ebp)
801055c1:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
801055c5:	0f 84 0d 01 00 00    	je     801056d8 <sys_unlink+0x1cb>
    goto bad;
  ilock(ip);
801055cb:	83 ec 0c             	sub    $0xc,%esp
801055ce:	ff 75 f0             	push   -0x10(%ebp)
801055d1:	e8 14 c4 ff ff       	call   801019ea <ilock>
801055d6:	83 c4 10             	add    $0x10,%esp

  if(ip->nlink < 1)
801055d9:	8b 45 f0             	mov    -0x10(%ebp),%eax
801055dc:	0f b7 40 56          	movzwl 0x56(%eax),%eax
801055e0:	66 85 c0             	test   %ax,%ax
801055e3:	7f 0d                	jg     801055f2 <sys_unlink+0xe5>
    panic("unlink: nlink < 1");
801055e5:	83 ec 0c             	sub    $0xc,%esp
801055e8:	68 6b a6 10 80       	push   $0x8010a66b
801055ed:	e8 b7 af ff ff       	call   801005a9 <panic>
  if(ip->type == T_DIR && !isdirempty(ip)){
801055f2:	8b 45 f0             	mov    -0x10(%ebp),%eax
801055f5:	0f b7 40 50          	movzwl 0x50(%eax),%eax
801055f9:	66 83 f8 01          	cmp    $0x1,%ax
801055fd:	75 25                	jne    80105624 <sys_unlink+0x117>
801055ff:	83 ec 0c             	sub    $0xc,%esp
80105602:	ff 75 f0             	push   -0x10(%ebp)
80105605:	e8 a0 fe ff ff       	call   801054aa <isdirempty>
8010560a:	83 c4 10             	add    $0x10,%esp
8010560d:	85 c0                	test   %eax,%eax
8010560f:	75 13                	jne    80105624 <sys_unlink+0x117>
    iunlockput(ip);
80105611:	83 ec 0c             	sub    $0xc,%esp
80105614:	ff 75 f0             	push   -0x10(%ebp)
80105617:	e8 ff c5 ff ff       	call   80101c1b <iunlockput>
8010561c:	83 c4 10             	add    $0x10,%esp
    goto bad;
8010561f:	e9 b5 00 00 00       	jmp    801056d9 <sys_unlink+0x1cc>
  }

  memset(&de, 0, sizeof(de));
80105624:	83 ec 04             	sub    $0x4,%esp
80105627:	6a 10                	push   $0x10
80105629:	6a 00                	push   $0x0
8010562b:	8d 45 e0             	lea    -0x20(%ebp),%eax
8010562e:	50                   	push   %eax
8010562f:	e8 cf f5 ff ff       	call   80104c03 <memset>
80105634:	83 c4 10             	add    $0x10,%esp
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80105637:	8b 45 c8             	mov    -0x38(%ebp),%eax
8010563a:	6a 10                	push   $0x10
8010563c:	50                   	push   %eax
8010563d:	8d 45 e0             	lea    -0x20(%ebp),%eax
80105640:	50                   	push   %eax
80105641:	ff 75 f4             	push   -0xc(%ebp)
80105644:	e8 e2 c9 ff ff       	call   8010202b <writei>
80105649:	83 c4 10             	add    $0x10,%esp
8010564c:	83 f8 10             	cmp    $0x10,%eax
8010564f:	74 0d                	je     8010565e <sys_unlink+0x151>
    panic("unlink: writei");
80105651:	83 ec 0c             	sub    $0xc,%esp
80105654:	68 7d a6 10 80       	push   $0x8010a67d
80105659:	e8 4b af ff ff       	call   801005a9 <panic>
  if(ip->type == T_DIR){
8010565e:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105661:	0f b7 40 50          	movzwl 0x50(%eax),%eax
80105665:	66 83 f8 01          	cmp    $0x1,%ax
80105669:	75 21                	jne    8010568c <sys_unlink+0x17f>
    dp->nlink--;
8010566b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010566e:	0f b7 40 56          	movzwl 0x56(%eax),%eax
80105672:	83 e8 01             	sub    $0x1,%eax
80105675:	89 c2                	mov    %eax,%edx
80105677:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010567a:	66 89 50 56          	mov    %dx,0x56(%eax)
    iupdate(dp);
8010567e:	83 ec 0c             	sub    $0xc,%esp
80105681:	ff 75 f4             	push   -0xc(%ebp)
80105684:	e8 84 c1 ff ff       	call   8010180d <iupdate>
80105689:	83 c4 10             	add    $0x10,%esp
  }
  iunlockput(dp);
8010568c:	83 ec 0c             	sub    $0xc,%esp
8010568f:	ff 75 f4             	push   -0xc(%ebp)
80105692:	e8 84 c5 ff ff       	call   80101c1b <iunlockput>
80105697:	83 c4 10             	add    $0x10,%esp

  ip->nlink--;
8010569a:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010569d:	0f b7 40 56          	movzwl 0x56(%eax),%eax
801056a1:	83 e8 01             	sub    $0x1,%eax
801056a4:	89 c2                	mov    %eax,%edx
801056a6:	8b 45 f0             	mov    -0x10(%ebp),%eax
801056a9:	66 89 50 56          	mov    %dx,0x56(%eax)
  iupdate(ip);
801056ad:	83 ec 0c             	sub    $0xc,%esp
801056b0:	ff 75 f0             	push   -0x10(%ebp)
801056b3:	e8 55 c1 ff ff       	call   8010180d <iupdate>
801056b8:	83 c4 10             	add    $0x10,%esp
  iunlockput(ip);
801056bb:	83 ec 0c             	sub    $0xc,%esp
801056be:	ff 75 f0             	push   -0x10(%ebp)
801056c1:	e8 55 c5 ff ff       	call   80101c1b <iunlockput>
801056c6:	83 c4 10             	add    $0x10,%esp

  end_op();
801056c9:	e8 fa d9 ff ff       	call   801030c8 <end_op>

  return 0;
801056ce:	b8 00 00 00 00       	mov    $0x0,%eax
801056d3:	eb 1c                	jmp    801056f1 <sys_unlink+0x1e4>
    goto bad;
801056d5:	90                   	nop
801056d6:	eb 01                	jmp    801056d9 <sys_unlink+0x1cc>
    goto bad;
801056d8:	90                   	nop

bad:
  iunlockput(dp);
801056d9:	83 ec 0c             	sub    $0xc,%esp
801056dc:	ff 75 f4             	push   -0xc(%ebp)
801056df:	e8 37 c5 ff ff       	call   80101c1b <iunlockput>
801056e4:	83 c4 10             	add    $0x10,%esp
  end_op();
801056e7:	e8 dc d9 ff ff       	call   801030c8 <end_op>
  return -1;
801056ec:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801056f1:	c9                   	leave  
801056f2:	c3                   	ret    

801056f3 <create>:

static struct inode*
create(char *path, short type, short major, short minor)
{
801056f3:	55                   	push   %ebp
801056f4:	89 e5                	mov    %esp,%ebp
801056f6:	83 ec 38             	sub    $0x38,%esp
801056f9:	8b 4d 0c             	mov    0xc(%ebp),%ecx
801056fc:	8b 55 10             	mov    0x10(%ebp),%edx
801056ff:	8b 45 14             	mov    0x14(%ebp),%eax
80105702:	66 89 4d d4          	mov    %cx,-0x2c(%ebp)
80105706:	66 89 55 d0          	mov    %dx,-0x30(%ebp)
8010570a:	66 89 45 cc          	mov    %ax,-0x34(%ebp)
  uint off;
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
8010570e:	83 ec 08             	sub    $0x8,%esp
80105711:	8d 45 de             	lea    -0x22(%ebp),%eax
80105714:	50                   	push   %eax
80105715:	ff 75 08             	push   0x8(%ebp)
80105718:	e8 1c ce ff ff       	call   80102539 <nameiparent>
8010571d:	83 c4 10             	add    $0x10,%esp
80105720:	89 45 f4             	mov    %eax,-0xc(%ebp)
80105723:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80105727:	75 0a                	jne    80105733 <create+0x40>
    return 0;
80105729:	b8 00 00 00 00       	mov    $0x0,%eax
8010572e:	e9 90 01 00 00       	jmp    801058c3 <create+0x1d0>
  ilock(dp);
80105733:	83 ec 0c             	sub    $0xc,%esp
80105736:	ff 75 f4             	push   -0xc(%ebp)
80105739:	e8 ac c2 ff ff       	call   801019ea <ilock>
8010573e:	83 c4 10             	add    $0x10,%esp

  if((ip = dirlookup(dp, name, &off)) != 0){
80105741:	83 ec 04             	sub    $0x4,%esp
80105744:	8d 45 ec             	lea    -0x14(%ebp),%eax
80105747:	50                   	push   %eax
80105748:	8d 45 de             	lea    -0x22(%ebp),%eax
8010574b:	50                   	push   %eax
8010574c:	ff 75 f4             	push   -0xc(%ebp)
8010574f:	e8 78 ca ff ff       	call   801021cc <dirlookup>
80105754:	83 c4 10             	add    $0x10,%esp
80105757:	89 45 f0             	mov    %eax,-0x10(%ebp)
8010575a:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
8010575e:	74 50                	je     801057b0 <create+0xbd>
    iunlockput(dp);
80105760:	83 ec 0c             	sub    $0xc,%esp
80105763:	ff 75 f4             	push   -0xc(%ebp)
80105766:	e8 b0 c4 ff ff       	call   80101c1b <iunlockput>
8010576b:	83 c4 10             	add    $0x10,%esp
    ilock(ip);
8010576e:	83 ec 0c             	sub    $0xc,%esp
80105771:	ff 75 f0             	push   -0x10(%ebp)
80105774:	e8 71 c2 ff ff       	call   801019ea <ilock>
80105779:	83 c4 10             	add    $0x10,%esp
    if(type == T_FILE && ip->type == T_FILE)
8010577c:	66 83 7d d4 02       	cmpw   $0x2,-0x2c(%ebp)
80105781:	75 15                	jne    80105798 <create+0xa5>
80105783:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105786:	0f b7 40 50          	movzwl 0x50(%eax),%eax
8010578a:	66 83 f8 02          	cmp    $0x2,%ax
8010578e:	75 08                	jne    80105798 <create+0xa5>
      return ip;
80105790:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105793:	e9 2b 01 00 00       	jmp    801058c3 <create+0x1d0>
    iunlockput(ip);
80105798:	83 ec 0c             	sub    $0xc,%esp
8010579b:	ff 75 f0             	push   -0x10(%ebp)
8010579e:	e8 78 c4 ff ff       	call   80101c1b <iunlockput>
801057a3:	83 c4 10             	add    $0x10,%esp
    return 0;
801057a6:	b8 00 00 00 00       	mov    $0x0,%eax
801057ab:	e9 13 01 00 00       	jmp    801058c3 <create+0x1d0>
  }

  if((ip = ialloc(dp->dev, type)) == 0)
801057b0:	0f bf 55 d4          	movswl -0x2c(%ebp),%edx
801057b4:	8b 45 f4             	mov    -0xc(%ebp),%eax
801057b7:	8b 00                	mov    (%eax),%eax
801057b9:	83 ec 08             	sub    $0x8,%esp
801057bc:	52                   	push   %edx
801057bd:	50                   	push   %eax
801057be:	e8 73 bf ff ff       	call   80101736 <ialloc>
801057c3:	83 c4 10             	add    $0x10,%esp
801057c6:	89 45 f0             	mov    %eax,-0x10(%ebp)
801057c9:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
801057cd:	75 0d                	jne    801057dc <create+0xe9>
    panic("create: ialloc");
801057cf:	83 ec 0c             	sub    $0xc,%esp
801057d2:	68 8c a6 10 80       	push   $0x8010a68c
801057d7:	e8 cd ad ff ff       	call   801005a9 <panic>

  ilock(ip);
801057dc:	83 ec 0c             	sub    $0xc,%esp
801057df:	ff 75 f0             	push   -0x10(%ebp)
801057e2:	e8 03 c2 ff ff       	call   801019ea <ilock>
801057e7:	83 c4 10             	add    $0x10,%esp
  ip->major = major;
801057ea:	8b 45 f0             	mov    -0x10(%ebp),%eax
801057ed:	0f b7 55 d0          	movzwl -0x30(%ebp),%edx
801057f1:	66 89 50 52          	mov    %dx,0x52(%eax)
  ip->minor = minor;
801057f5:	8b 45 f0             	mov    -0x10(%ebp),%eax
801057f8:	0f b7 55 cc          	movzwl -0x34(%ebp),%edx
801057fc:	66 89 50 54          	mov    %dx,0x54(%eax)
  ip->nlink = 1;
80105800:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105803:	66 c7 40 56 01 00    	movw   $0x1,0x56(%eax)
  iupdate(ip);
80105809:	83 ec 0c             	sub    $0xc,%esp
8010580c:	ff 75 f0             	push   -0x10(%ebp)
8010580f:	e8 f9 bf ff ff       	call   8010180d <iupdate>
80105814:	83 c4 10             	add    $0x10,%esp

  if(type == T_DIR){  // Create . and .. entries.
80105817:	66 83 7d d4 01       	cmpw   $0x1,-0x2c(%ebp)
8010581c:	75 6a                	jne    80105888 <create+0x195>
    dp->nlink++;  // for ".."
8010581e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105821:	0f b7 40 56          	movzwl 0x56(%eax),%eax
80105825:	83 c0 01             	add    $0x1,%eax
80105828:	89 c2                	mov    %eax,%edx
8010582a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010582d:	66 89 50 56          	mov    %dx,0x56(%eax)
    iupdate(dp);
80105831:	83 ec 0c             	sub    $0xc,%esp
80105834:	ff 75 f4             	push   -0xc(%ebp)
80105837:	e8 d1 bf ff ff       	call   8010180d <iupdate>
8010583c:	83 c4 10             	add    $0x10,%esp
    // No ip->nlink++ for ".": avoid cyclic ref count.
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
8010583f:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105842:	8b 40 04             	mov    0x4(%eax),%eax
80105845:	83 ec 04             	sub    $0x4,%esp
80105848:	50                   	push   %eax
80105849:	68 66 a6 10 80       	push   $0x8010a666
8010584e:	ff 75 f0             	push   -0x10(%ebp)
80105851:	e8 30 ca ff ff       	call   80102286 <dirlink>
80105856:	83 c4 10             	add    $0x10,%esp
80105859:	85 c0                	test   %eax,%eax
8010585b:	78 1e                	js     8010587b <create+0x188>
8010585d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105860:	8b 40 04             	mov    0x4(%eax),%eax
80105863:	83 ec 04             	sub    $0x4,%esp
80105866:	50                   	push   %eax
80105867:	68 68 a6 10 80       	push   $0x8010a668
8010586c:	ff 75 f0             	push   -0x10(%ebp)
8010586f:	e8 12 ca ff ff       	call   80102286 <dirlink>
80105874:	83 c4 10             	add    $0x10,%esp
80105877:	85 c0                	test   %eax,%eax
80105879:	79 0d                	jns    80105888 <create+0x195>
      panic("create dots");
8010587b:	83 ec 0c             	sub    $0xc,%esp
8010587e:	68 9b a6 10 80       	push   $0x8010a69b
80105883:	e8 21 ad ff ff       	call   801005a9 <panic>
  }

  if(dirlink(dp, name, ip->inum) < 0)
80105888:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010588b:	8b 40 04             	mov    0x4(%eax),%eax
8010588e:	83 ec 04             	sub    $0x4,%esp
80105891:	50                   	push   %eax
80105892:	8d 45 de             	lea    -0x22(%ebp),%eax
80105895:	50                   	push   %eax
80105896:	ff 75 f4             	push   -0xc(%ebp)
80105899:	e8 e8 c9 ff ff       	call   80102286 <dirlink>
8010589e:	83 c4 10             	add    $0x10,%esp
801058a1:	85 c0                	test   %eax,%eax
801058a3:	79 0d                	jns    801058b2 <create+0x1bf>
    panic("create: dirlink");
801058a5:	83 ec 0c             	sub    $0xc,%esp
801058a8:	68 a7 a6 10 80       	push   $0x8010a6a7
801058ad:	e8 f7 ac ff ff       	call   801005a9 <panic>

  iunlockput(dp);
801058b2:	83 ec 0c             	sub    $0xc,%esp
801058b5:	ff 75 f4             	push   -0xc(%ebp)
801058b8:	e8 5e c3 ff ff       	call   80101c1b <iunlockput>
801058bd:	83 c4 10             	add    $0x10,%esp

  return ip;
801058c0:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
801058c3:	c9                   	leave  
801058c4:	c3                   	ret    

801058c5 <sys_open>:

int
sys_open(void)
{
801058c5:	55                   	push   %ebp
801058c6:	89 e5                	mov    %esp,%ebp
801058c8:	83 ec 28             	sub    $0x28,%esp
  char *path;
  int fd, omode;
  struct file *f;
  struct inode *ip;

  if(argstr(0, &path) < 0 || argint(1, &omode) < 0)
801058cb:	83 ec 08             	sub    $0x8,%esp
801058ce:	8d 45 e8             	lea    -0x18(%ebp),%eax
801058d1:	50                   	push   %eax
801058d2:	6a 00                	push   $0x0
801058d4:	e8 ea f6 ff ff       	call   80104fc3 <argstr>
801058d9:	83 c4 10             	add    $0x10,%esp
801058dc:	85 c0                	test   %eax,%eax
801058de:	78 15                	js     801058f5 <sys_open+0x30>
801058e0:	83 ec 08             	sub    $0x8,%esp
801058e3:	8d 45 e4             	lea    -0x1c(%ebp),%eax
801058e6:	50                   	push   %eax
801058e7:	6a 01                	push   $0x1
801058e9:	e8 40 f6 ff ff       	call   80104f2e <argint>
801058ee:	83 c4 10             	add    $0x10,%esp
801058f1:	85 c0                	test   %eax,%eax
801058f3:	79 0a                	jns    801058ff <sys_open+0x3a>
    return -1;
801058f5:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801058fa:	e9 61 01 00 00       	jmp    80105a60 <sys_open+0x19b>

  begin_op();
801058ff:	e8 38 d7 ff ff       	call   8010303c <begin_op>

  if(omode & O_CREATE){
80105904:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80105907:	25 00 02 00 00       	and    $0x200,%eax
8010590c:	85 c0                	test   %eax,%eax
8010590e:	74 2a                	je     8010593a <sys_open+0x75>
    ip = create(path, T_FILE, 0, 0);
80105910:	8b 45 e8             	mov    -0x18(%ebp),%eax
80105913:	6a 00                	push   $0x0
80105915:	6a 00                	push   $0x0
80105917:	6a 02                	push   $0x2
80105919:	50                   	push   %eax
8010591a:	e8 d4 fd ff ff       	call   801056f3 <create>
8010591f:	83 c4 10             	add    $0x10,%esp
80105922:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(ip == 0){
80105925:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80105929:	75 75                	jne    801059a0 <sys_open+0xdb>
      end_op();
8010592b:	e8 98 d7 ff ff       	call   801030c8 <end_op>
      return -1;
80105930:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105935:	e9 26 01 00 00       	jmp    80105a60 <sys_open+0x19b>
    }
  } else {
    if((ip = namei(path)) == 0){
8010593a:	8b 45 e8             	mov    -0x18(%ebp),%eax
8010593d:	83 ec 0c             	sub    $0xc,%esp
80105940:	50                   	push   %eax
80105941:	e8 d7 cb ff ff       	call   8010251d <namei>
80105946:	83 c4 10             	add    $0x10,%esp
80105949:	89 45 f4             	mov    %eax,-0xc(%ebp)
8010594c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80105950:	75 0f                	jne    80105961 <sys_open+0x9c>
      end_op();
80105952:	e8 71 d7 ff ff       	call   801030c8 <end_op>
      return -1;
80105957:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010595c:	e9 ff 00 00 00       	jmp    80105a60 <sys_open+0x19b>
    }
    ilock(ip);
80105961:	83 ec 0c             	sub    $0xc,%esp
80105964:	ff 75 f4             	push   -0xc(%ebp)
80105967:	e8 7e c0 ff ff       	call   801019ea <ilock>
8010596c:	83 c4 10             	add    $0x10,%esp
    if(ip->type == T_DIR && omode != O_RDONLY){
8010596f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105972:	0f b7 40 50          	movzwl 0x50(%eax),%eax
80105976:	66 83 f8 01          	cmp    $0x1,%ax
8010597a:	75 24                	jne    801059a0 <sys_open+0xdb>
8010597c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010597f:	85 c0                	test   %eax,%eax
80105981:	74 1d                	je     801059a0 <sys_open+0xdb>
      iunlockput(ip);
80105983:	83 ec 0c             	sub    $0xc,%esp
80105986:	ff 75 f4             	push   -0xc(%ebp)
80105989:	e8 8d c2 ff ff       	call   80101c1b <iunlockput>
8010598e:	83 c4 10             	add    $0x10,%esp
      end_op();
80105991:	e8 32 d7 ff ff       	call   801030c8 <end_op>
      return -1;
80105996:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010599b:	e9 c0 00 00 00       	jmp    80105a60 <sys_open+0x19b>
    }
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
801059a0:	e8 38 b6 ff ff       	call   80100fdd <filealloc>
801059a5:	89 45 f0             	mov    %eax,-0x10(%ebp)
801059a8:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
801059ac:	74 17                	je     801059c5 <sys_open+0x100>
801059ae:	83 ec 0c             	sub    $0xc,%esp
801059b1:	ff 75 f0             	push   -0x10(%ebp)
801059b4:	e8 33 f7 ff ff       	call   801050ec <fdalloc>
801059b9:	83 c4 10             	add    $0x10,%esp
801059bc:	89 45 ec             	mov    %eax,-0x14(%ebp)
801059bf:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
801059c3:	79 2e                	jns    801059f3 <sys_open+0x12e>
    if(f)
801059c5:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
801059c9:	74 0e                	je     801059d9 <sys_open+0x114>
      fileclose(f);
801059cb:	83 ec 0c             	sub    $0xc,%esp
801059ce:	ff 75 f0             	push   -0x10(%ebp)
801059d1:	e8 c5 b6 ff ff       	call   8010109b <fileclose>
801059d6:	83 c4 10             	add    $0x10,%esp
    iunlockput(ip);
801059d9:	83 ec 0c             	sub    $0xc,%esp
801059dc:	ff 75 f4             	push   -0xc(%ebp)
801059df:	e8 37 c2 ff ff       	call   80101c1b <iunlockput>
801059e4:	83 c4 10             	add    $0x10,%esp
    end_op();
801059e7:	e8 dc d6 ff ff       	call   801030c8 <end_op>
    return -1;
801059ec:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801059f1:	eb 6d                	jmp    80105a60 <sys_open+0x19b>
  }
  iunlock(ip);
801059f3:	83 ec 0c             	sub    $0xc,%esp
801059f6:	ff 75 f4             	push   -0xc(%ebp)
801059f9:	e8 ff c0 ff ff       	call   80101afd <iunlock>
801059fe:	83 c4 10             	add    $0x10,%esp
  end_op();
80105a01:	e8 c2 d6 ff ff       	call   801030c8 <end_op>

  f->type = FD_INODE;
80105a06:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105a09:	c7 00 02 00 00 00    	movl   $0x2,(%eax)
  f->ip = ip;
80105a0f:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105a12:	8b 55 f4             	mov    -0xc(%ebp),%edx
80105a15:	89 50 10             	mov    %edx,0x10(%eax)
  f->off = 0;
80105a18:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105a1b:	c7 40 14 00 00 00 00 	movl   $0x0,0x14(%eax)
  f->readable = !(omode & O_WRONLY);
80105a22:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80105a25:	83 e0 01             	and    $0x1,%eax
80105a28:	85 c0                	test   %eax,%eax
80105a2a:	0f 94 c0             	sete   %al
80105a2d:	89 c2                	mov    %eax,%edx
80105a2f:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105a32:	88 50 08             	mov    %dl,0x8(%eax)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
80105a35:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80105a38:	83 e0 01             	and    $0x1,%eax
80105a3b:	85 c0                	test   %eax,%eax
80105a3d:	75 0a                	jne    80105a49 <sys_open+0x184>
80105a3f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80105a42:	83 e0 02             	and    $0x2,%eax
80105a45:	85 c0                	test   %eax,%eax
80105a47:	74 07                	je     80105a50 <sys_open+0x18b>
80105a49:	b8 01 00 00 00       	mov    $0x1,%eax
80105a4e:	eb 05                	jmp    80105a55 <sys_open+0x190>
80105a50:	b8 00 00 00 00       	mov    $0x0,%eax
80105a55:	89 c2                	mov    %eax,%edx
80105a57:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105a5a:	88 50 09             	mov    %dl,0x9(%eax)
  return fd;
80105a5d:	8b 45 ec             	mov    -0x14(%ebp),%eax
}
80105a60:	c9                   	leave  
80105a61:	c3                   	ret    

80105a62 <sys_mkdir>:

int
sys_mkdir(void)
{
80105a62:	55                   	push   %ebp
80105a63:	89 e5                	mov    %esp,%ebp
80105a65:	83 ec 18             	sub    $0x18,%esp
  char *path;
  struct inode *ip;

  begin_op();
80105a68:	e8 cf d5 ff ff       	call   8010303c <begin_op>
  if(argstr(0, &path) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
80105a6d:	83 ec 08             	sub    $0x8,%esp
80105a70:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105a73:	50                   	push   %eax
80105a74:	6a 00                	push   $0x0
80105a76:	e8 48 f5 ff ff       	call   80104fc3 <argstr>
80105a7b:	83 c4 10             	add    $0x10,%esp
80105a7e:	85 c0                	test   %eax,%eax
80105a80:	78 1b                	js     80105a9d <sys_mkdir+0x3b>
80105a82:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105a85:	6a 00                	push   $0x0
80105a87:	6a 00                	push   $0x0
80105a89:	6a 01                	push   $0x1
80105a8b:	50                   	push   %eax
80105a8c:	e8 62 fc ff ff       	call   801056f3 <create>
80105a91:	83 c4 10             	add    $0x10,%esp
80105a94:	89 45 f4             	mov    %eax,-0xc(%ebp)
80105a97:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80105a9b:	75 0c                	jne    80105aa9 <sys_mkdir+0x47>
    end_op();
80105a9d:	e8 26 d6 ff ff       	call   801030c8 <end_op>
    return -1;
80105aa2:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105aa7:	eb 18                	jmp    80105ac1 <sys_mkdir+0x5f>
  }
  iunlockput(ip);
80105aa9:	83 ec 0c             	sub    $0xc,%esp
80105aac:	ff 75 f4             	push   -0xc(%ebp)
80105aaf:	e8 67 c1 ff ff       	call   80101c1b <iunlockput>
80105ab4:	83 c4 10             	add    $0x10,%esp
  end_op();
80105ab7:	e8 0c d6 ff ff       	call   801030c8 <end_op>
  return 0;
80105abc:	b8 00 00 00 00       	mov    $0x0,%eax
}
80105ac1:	c9                   	leave  
80105ac2:	c3                   	ret    

80105ac3 <sys_mknod>:

int
sys_mknod(void)
{
80105ac3:	55                   	push   %ebp
80105ac4:	89 e5                	mov    %esp,%ebp
80105ac6:	83 ec 18             	sub    $0x18,%esp
  struct inode *ip;
  char *path;
  int major, minor;

  begin_op();
80105ac9:	e8 6e d5 ff ff       	call   8010303c <begin_op>
  if((argstr(0, &path)) < 0 ||
80105ace:	83 ec 08             	sub    $0x8,%esp
80105ad1:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105ad4:	50                   	push   %eax
80105ad5:	6a 00                	push   $0x0
80105ad7:	e8 e7 f4 ff ff       	call   80104fc3 <argstr>
80105adc:	83 c4 10             	add    $0x10,%esp
80105adf:	85 c0                	test   %eax,%eax
80105ae1:	78 4f                	js     80105b32 <sys_mknod+0x6f>
     argint(1, &major) < 0 ||
80105ae3:	83 ec 08             	sub    $0x8,%esp
80105ae6:	8d 45 ec             	lea    -0x14(%ebp),%eax
80105ae9:	50                   	push   %eax
80105aea:	6a 01                	push   $0x1
80105aec:	e8 3d f4 ff ff       	call   80104f2e <argint>
80105af1:	83 c4 10             	add    $0x10,%esp
  if((argstr(0, &path)) < 0 ||
80105af4:	85 c0                	test   %eax,%eax
80105af6:	78 3a                	js     80105b32 <sys_mknod+0x6f>
     argint(2, &minor) < 0 ||
80105af8:	83 ec 08             	sub    $0x8,%esp
80105afb:	8d 45 e8             	lea    -0x18(%ebp),%eax
80105afe:	50                   	push   %eax
80105aff:	6a 02                	push   $0x2
80105b01:	e8 28 f4 ff ff       	call   80104f2e <argint>
80105b06:	83 c4 10             	add    $0x10,%esp
     argint(1, &major) < 0 ||
80105b09:	85 c0                	test   %eax,%eax
80105b0b:	78 25                	js     80105b32 <sys_mknod+0x6f>
     (ip = create(path, T_DEV, major, minor)) == 0){
80105b0d:	8b 45 e8             	mov    -0x18(%ebp),%eax
80105b10:	0f bf c8             	movswl %ax,%ecx
80105b13:	8b 45 ec             	mov    -0x14(%ebp),%eax
80105b16:	0f bf d0             	movswl %ax,%edx
80105b19:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105b1c:	51                   	push   %ecx
80105b1d:	52                   	push   %edx
80105b1e:	6a 03                	push   $0x3
80105b20:	50                   	push   %eax
80105b21:	e8 cd fb ff ff       	call   801056f3 <create>
80105b26:	83 c4 10             	add    $0x10,%esp
80105b29:	89 45 f4             	mov    %eax,-0xc(%ebp)
     argint(2, &minor) < 0 ||
80105b2c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80105b30:	75 0c                	jne    80105b3e <sys_mknod+0x7b>
    end_op();
80105b32:	e8 91 d5 ff ff       	call   801030c8 <end_op>
    return -1;
80105b37:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105b3c:	eb 18                	jmp    80105b56 <sys_mknod+0x93>
  }
  iunlockput(ip);
80105b3e:	83 ec 0c             	sub    $0xc,%esp
80105b41:	ff 75 f4             	push   -0xc(%ebp)
80105b44:	e8 d2 c0 ff ff       	call   80101c1b <iunlockput>
80105b49:	83 c4 10             	add    $0x10,%esp
  end_op();
80105b4c:	e8 77 d5 ff ff       	call   801030c8 <end_op>
  return 0;
80105b51:	b8 00 00 00 00       	mov    $0x0,%eax
}
80105b56:	c9                   	leave  
80105b57:	c3                   	ret    

80105b58 <sys_chdir>:

int
sys_chdir(void)
{
80105b58:	55                   	push   %ebp
80105b59:	89 e5                	mov    %esp,%ebp
80105b5b:	83 ec 18             	sub    $0x18,%esp
  char *path;
  struct inode *ip;
  struct proc *curproc = myproc();
80105b5e:	e8 cd de ff ff       	call   80103a30 <myproc>
80105b63:	89 45 f4             	mov    %eax,-0xc(%ebp)
  
  begin_op();
80105b66:	e8 d1 d4 ff ff       	call   8010303c <begin_op>
  if(argstr(0, &path) < 0 || (ip = namei(path)) == 0){
80105b6b:	83 ec 08             	sub    $0x8,%esp
80105b6e:	8d 45 ec             	lea    -0x14(%ebp),%eax
80105b71:	50                   	push   %eax
80105b72:	6a 00                	push   $0x0
80105b74:	e8 4a f4 ff ff       	call   80104fc3 <argstr>
80105b79:	83 c4 10             	add    $0x10,%esp
80105b7c:	85 c0                	test   %eax,%eax
80105b7e:	78 18                	js     80105b98 <sys_chdir+0x40>
80105b80:	8b 45 ec             	mov    -0x14(%ebp),%eax
80105b83:	83 ec 0c             	sub    $0xc,%esp
80105b86:	50                   	push   %eax
80105b87:	e8 91 c9 ff ff       	call   8010251d <namei>
80105b8c:	83 c4 10             	add    $0x10,%esp
80105b8f:	89 45 f0             	mov    %eax,-0x10(%ebp)
80105b92:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80105b96:	75 0c                	jne    80105ba4 <sys_chdir+0x4c>
    end_op();
80105b98:	e8 2b d5 ff ff       	call   801030c8 <end_op>
    return -1;
80105b9d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105ba2:	eb 68                	jmp    80105c0c <sys_chdir+0xb4>
  }
  ilock(ip);
80105ba4:	83 ec 0c             	sub    $0xc,%esp
80105ba7:	ff 75 f0             	push   -0x10(%ebp)
80105baa:	e8 3b be ff ff       	call   801019ea <ilock>
80105baf:	83 c4 10             	add    $0x10,%esp
  if(ip->type != T_DIR){
80105bb2:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105bb5:	0f b7 40 50          	movzwl 0x50(%eax),%eax
80105bb9:	66 83 f8 01          	cmp    $0x1,%ax
80105bbd:	74 1a                	je     80105bd9 <sys_chdir+0x81>
    iunlockput(ip);
80105bbf:	83 ec 0c             	sub    $0xc,%esp
80105bc2:	ff 75 f0             	push   -0x10(%ebp)
80105bc5:	e8 51 c0 ff ff       	call   80101c1b <iunlockput>
80105bca:	83 c4 10             	add    $0x10,%esp
    end_op();
80105bcd:	e8 f6 d4 ff ff       	call   801030c8 <end_op>
    return -1;
80105bd2:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105bd7:	eb 33                	jmp    80105c0c <sys_chdir+0xb4>
  }
  iunlock(ip);
80105bd9:	83 ec 0c             	sub    $0xc,%esp
80105bdc:	ff 75 f0             	push   -0x10(%ebp)
80105bdf:	e8 19 bf ff ff       	call   80101afd <iunlock>
80105be4:	83 c4 10             	add    $0x10,%esp
  iput(curproc->cwd);
80105be7:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105bea:	8b 40 68             	mov    0x68(%eax),%eax
80105bed:	83 ec 0c             	sub    $0xc,%esp
80105bf0:	50                   	push   %eax
80105bf1:	e8 55 bf ff ff       	call   80101b4b <iput>
80105bf6:	83 c4 10             	add    $0x10,%esp
  end_op();
80105bf9:	e8 ca d4 ff ff       	call   801030c8 <end_op>
  curproc->cwd = ip;
80105bfe:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105c01:	8b 55 f0             	mov    -0x10(%ebp),%edx
80105c04:	89 50 68             	mov    %edx,0x68(%eax)
  return 0;
80105c07:	b8 00 00 00 00       	mov    $0x0,%eax
}
80105c0c:	c9                   	leave  
80105c0d:	c3                   	ret    

80105c0e <sys_exec>:

int
sys_exec(void)
{
80105c0e:	55                   	push   %ebp
80105c0f:	89 e5                	mov    %esp,%ebp
80105c11:	81 ec 98 00 00 00    	sub    $0x98,%esp
  char *path, *argv[MAXARG];
  int i;
  uint uargv, uarg;

  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
80105c17:	83 ec 08             	sub    $0x8,%esp
80105c1a:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105c1d:	50                   	push   %eax
80105c1e:	6a 00                	push   $0x0
80105c20:	e8 9e f3 ff ff       	call   80104fc3 <argstr>
80105c25:	83 c4 10             	add    $0x10,%esp
80105c28:	85 c0                	test   %eax,%eax
80105c2a:	78 18                	js     80105c44 <sys_exec+0x36>
80105c2c:	83 ec 08             	sub    $0x8,%esp
80105c2f:	8d 85 6c ff ff ff    	lea    -0x94(%ebp),%eax
80105c35:	50                   	push   %eax
80105c36:	6a 01                	push   $0x1
80105c38:	e8 f1 f2 ff ff       	call   80104f2e <argint>
80105c3d:	83 c4 10             	add    $0x10,%esp
80105c40:	85 c0                	test   %eax,%eax
80105c42:	79 0a                	jns    80105c4e <sys_exec+0x40>
    return -1;
80105c44:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105c49:	e9 c6 00 00 00       	jmp    80105d14 <sys_exec+0x106>
  }
  memset(argv, 0, sizeof(argv));
80105c4e:	83 ec 04             	sub    $0x4,%esp
80105c51:	68 80 00 00 00       	push   $0x80
80105c56:	6a 00                	push   $0x0
80105c58:	8d 85 70 ff ff ff    	lea    -0x90(%ebp),%eax
80105c5e:	50                   	push   %eax
80105c5f:	e8 9f ef ff ff       	call   80104c03 <memset>
80105c64:	83 c4 10             	add    $0x10,%esp
  for(i=0;; i++){
80105c67:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    if(i >= NELEM(argv))
80105c6e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105c71:	83 f8 1f             	cmp    $0x1f,%eax
80105c74:	76 0a                	jbe    80105c80 <sys_exec+0x72>
      return -1;
80105c76:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105c7b:	e9 94 00 00 00       	jmp    80105d14 <sys_exec+0x106>
    if(fetchint(uargv+4*i, (int*)&uarg) < 0)
80105c80:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105c83:	c1 e0 02             	shl    $0x2,%eax
80105c86:	89 c2                	mov    %eax,%edx
80105c88:	8b 85 6c ff ff ff    	mov    -0x94(%ebp),%eax
80105c8e:	01 c2                	add    %eax,%edx
80105c90:	83 ec 08             	sub    $0x8,%esp
80105c93:	8d 85 68 ff ff ff    	lea    -0x98(%ebp),%eax
80105c99:	50                   	push   %eax
80105c9a:	52                   	push   %edx
80105c9b:	e8 ed f1 ff ff       	call   80104e8d <fetchint>
80105ca0:	83 c4 10             	add    $0x10,%esp
80105ca3:	85 c0                	test   %eax,%eax
80105ca5:	79 07                	jns    80105cae <sys_exec+0xa0>
      return -1;
80105ca7:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105cac:	eb 66                	jmp    80105d14 <sys_exec+0x106>
    if(uarg == 0){
80105cae:	8b 85 68 ff ff ff    	mov    -0x98(%ebp),%eax
80105cb4:	85 c0                	test   %eax,%eax
80105cb6:	75 27                	jne    80105cdf <sys_exec+0xd1>
      argv[i] = 0;
80105cb8:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105cbb:	c7 84 85 70 ff ff ff 	movl   $0x0,-0x90(%ebp,%eax,4)
80105cc2:	00 00 00 00 
      break;
80105cc6:	90                   	nop
    }
    if(fetchstr(uarg, &argv[i]) < 0)
      return -1;
  }
  return exec(path, argv);
80105cc7:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105cca:	83 ec 08             	sub    $0x8,%esp
80105ccd:	8d 95 70 ff ff ff    	lea    -0x90(%ebp),%edx
80105cd3:	52                   	push   %edx
80105cd4:	50                   	push   %eax
80105cd5:	e8 a6 ae ff ff       	call   80100b80 <exec>
80105cda:	83 c4 10             	add    $0x10,%esp
80105cdd:	eb 35                	jmp    80105d14 <sys_exec+0x106>
    if(fetchstr(uarg, &argv[i]) < 0)
80105cdf:	8d 95 70 ff ff ff    	lea    -0x90(%ebp),%edx
80105ce5:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105ce8:	c1 e0 02             	shl    $0x2,%eax
80105ceb:	01 c2                	add    %eax,%edx
80105ced:	8b 85 68 ff ff ff    	mov    -0x98(%ebp),%eax
80105cf3:	83 ec 08             	sub    $0x8,%esp
80105cf6:	52                   	push   %edx
80105cf7:	50                   	push   %eax
80105cf8:	e8 cf f1 ff ff       	call   80104ecc <fetchstr>
80105cfd:	83 c4 10             	add    $0x10,%esp
80105d00:	85 c0                	test   %eax,%eax
80105d02:	79 07                	jns    80105d0b <sys_exec+0xfd>
      return -1;
80105d04:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105d09:	eb 09                	jmp    80105d14 <sys_exec+0x106>
  for(i=0;; i++){
80105d0b:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
    if(i >= NELEM(argv))
80105d0f:	e9 5a ff ff ff       	jmp    80105c6e <sys_exec+0x60>
}
80105d14:	c9                   	leave  
80105d15:	c3                   	ret    

80105d16 <sys_pipe>:

int
sys_pipe(void)
{
80105d16:	55                   	push   %ebp
80105d17:	89 e5                	mov    %esp,%ebp
80105d19:	83 ec 28             	sub    $0x28,%esp
  int *fd;
  struct file *rf, *wf;
  int fd0, fd1;

  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
80105d1c:	83 ec 04             	sub    $0x4,%esp
80105d1f:	6a 08                	push   $0x8
80105d21:	8d 45 ec             	lea    -0x14(%ebp),%eax
80105d24:	50                   	push   %eax
80105d25:	6a 00                	push   $0x0
80105d27:	e8 2f f2 ff ff       	call   80104f5b <argptr>
80105d2c:	83 c4 10             	add    $0x10,%esp
80105d2f:	85 c0                	test   %eax,%eax
80105d31:	79 0a                	jns    80105d3d <sys_pipe+0x27>
    return -1;
80105d33:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105d38:	e9 ae 00 00 00       	jmp    80105deb <sys_pipe+0xd5>
  if(pipealloc(&rf, &wf) < 0)
80105d3d:	83 ec 08             	sub    $0x8,%esp
80105d40:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80105d43:	50                   	push   %eax
80105d44:	8d 45 e8             	lea    -0x18(%ebp),%eax
80105d47:	50                   	push   %eax
80105d48:	e8 20 d8 ff ff       	call   8010356d <pipealloc>
80105d4d:	83 c4 10             	add    $0x10,%esp
80105d50:	85 c0                	test   %eax,%eax
80105d52:	79 0a                	jns    80105d5e <sys_pipe+0x48>
    return -1;
80105d54:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105d59:	e9 8d 00 00 00       	jmp    80105deb <sys_pipe+0xd5>
  fd0 = -1;
80105d5e:	c7 45 f4 ff ff ff ff 	movl   $0xffffffff,-0xc(%ebp)
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
80105d65:	8b 45 e8             	mov    -0x18(%ebp),%eax
80105d68:	83 ec 0c             	sub    $0xc,%esp
80105d6b:	50                   	push   %eax
80105d6c:	e8 7b f3 ff ff       	call   801050ec <fdalloc>
80105d71:	83 c4 10             	add    $0x10,%esp
80105d74:	89 45 f4             	mov    %eax,-0xc(%ebp)
80105d77:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80105d7b:	78 18                	js     80105d95 <sys_pipe+0x7f>
80105d7d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80105d80:	83 ec 0c             	sub    $0xc,%esp
80105d83:	50                   	push   %eax
80105d84:	e8 63 f3 ff ff       	call   801050ec <fdalloc>
80105d89:	83 c4 10             	add    $0x10,%esp
80105d8c:	89 45 f0             	mov    %eax,-0x10(%ebp)
80105d8f:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80105d93:	79 3e                	jns    80105dd3 <sys_pipe+0xbd>
    if(fd0 >= 0)
80105d95:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80105d99:	78 13                	js     80105dae <sys_pipe+0x98>
      myproc()->ofile[fd0] = 0;
80105d9b:	e8 90 dc ff ff       	call   80103a30 <myproc>
80105da0:	8b 55 f4             	mov    -0xc(%ebp),%edx
80105da3:	83 c2 08             	add    $0x8,%edx
80105da6:	c7 44 90 08 00 00 00 	movl   $0x0,0x8(%eax,%edx,4)
80105dad:	00 
    fileclose(rf);
80105dae:	8b 45 e8             	mov    -0x18(%ebp),%eax
80105db1:	83 ec 0c             	sub    $0xc,%esp
80105db4:	50                   	push   %eax
80105db5:	e8 e1 b2 ff ff       	call   8010109b <fileclose>
80105dba:	83 c4 10             	add    $0x10,%esp
    fileclose(wf);
80105dbd:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80105dc0:	83 ec 0c             	sub    $0xc,%esp
80105dc3:	50                   	push   %eax
80105dc4:	e8 d2 b2 ff ff       	call   8010109b <fileclose>
80105dc9:	83 c4 10             	add    $0x10,%esp
    return -1;
80105dcc:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105dd1:	eb 18                	jmp    80105deb <sys_pipe+0xd5>
  }
  fd[0] = fd0;
80105dd3:	8b 45 ec             	mov    -0x14(%ebp),%eax
80105dd6:	8b 55 f4             	mov    -0xc(%ebp),%edx
80105dd9:	89 10                	mov    %edx,(%eax)
  fd[1] = fd1;
80105ddb:	8b 45 ec             	mov    -0x14(%ebp),%eax
80105dde:	8d 50 04             	lea    0x4(%eax),%edx
80105de1:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105de4:	89 02                	mov    %eax,(%edx)
  return 0;
80105de6:	b8 00 00 00 00       	mov    $0x0,%eax
}
80105deb:	c9                   	leave  
80105dec:	c3                   	ret    

80105ded <sys_fork>:
#include "spinlock.h"
#include "debug.h"

int
sys_fork(void)
{
80105ded:	55                   	push   %ebp
80105dee:	89 e5                	mov    %esp,%ebp
80105df0:	83 ec 08             	sub    $0x8,%esp
  return fork();
80105df3:	e8 3a df ff ff       	call   80103d32 <fork>
}
80105df8:	c9                   	leave  
80105df9:	c3                   	ret    

80105dfa <sys_exit>:

int
sys_exit(void)
{
80105dfa:	55                   	push   %ebp
80105dfb:	89 e5                	mov    %esp,%ebp
80105dfd:	83 ec 08             	sub    $0x8,%esp
  exit();
80105e00:	e8 a6 e0 ff ff       	call   80103eab <exit>
  return 0;  // not reached
80105e05:	b8 00 00 00 00       	mov    $0x0,%eax
}
80105e0a:	c9                   	leave  
80105e0b:	c3                   	ret    

80105e0c <sys_uthread_init>:

int sys_uthread_init(void)
{
80105e0c:	55                   	push   %ebp
80105e0d:	89 e5                	mov    %esp,%ebp
	//require to implement
	return 0;
80105e0f:	b8 00 00 00 00       	mov    $0x0,%eax
}
80105e14:	5d                   	pop    %ebp
80105e15:	c3                   	ret    

80105e16 <sys_exit2>:

int
sys_exit2(void) 
{
80105e16:	55                   	push   %ebp
80105e17:	89 e5                	mov    %esp,%ebp
80105e19:	83 ec 18             	sub    $0x18,%esp
  int status;

  //첫번쨰 파라미터로 준 값을 &status에 입력한다.
  //유효값 아니라면 리턴 -1
  if (argint(0, &status) < 0)
80105e1c:	83 ec 08             	sub    $0x8,%esp
80105e1f:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105e22:	50                   	push   %eax
80105e23:	6a 00                	push   $0x0
80105e25:	e8 04 f1 ff ff       	call   80104f2e <argint>
80105e2a:	83 c4 10             	add    $0x10,%esp
80105e2d:	85 c0                	test   %eax,%eax
80105e2f:	79 07                	jns    80105e38 <sys_exit2+0x22>
	  return -1;
80105e31:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105e36:	eb 12                	jmp    80105e4a <sys_exit2+0x34>
   
  exit2(status); 
80105e38:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105e3b:	83 ec 0c             	sub    $0xc,%esp
80105e3e:	50                   	push   %eax
80105e3f:	e8 94 e1 ff ff       	call   80103fd8 <exit2>
80105e44:	83 c4 10             	add    $0x10,%esp
  //return 0; //eax에 리턴해야하니까
  return status; //eax에 리턴해야하니까
80105e47:	8b 45 f4             	mov    -0xc(%ebp),%eax
}  
80105e4a:	c9                   	leave  
80105e4b:	c3                   	ret    

80105e4c <sys_wait>:

int
sys_wait(void)
{
80105e4c:	55                   	push   %ebp
80105e4d:	89 e5                	mov    %esp,%ebp
80105e4f:	83 ec 08             	sub    $0x8,%esp
  return wait();
80105e52:	e8 b0 e2 ff ff       	call   80104107 <wait>
}
80105e57:	c9                   	leave  
80105e58:	c3                   	ret    

80105e59 <sys_wait2>:
//*********new sys_waiat**********
//********************************

int
sys_wait2(void)
{
80105e59:	55                   	push   %ebp
80105e5a:	89 e5                	mov    %esp,%ebp
80105e5c:	83 ec 18             	sub    $0x18,%esp

  int status;
  //포인터 값 복사, 유효값 아니라면 리턴 -1
  if(argptr(0, (char **)&status, sizeof(int)) < 0)
80105e5f:	83 ec 04             	sub    $0x4,%esp
80105e62:	6a 04                	push   $0x4
80105e64:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105e67:	50                   	push   %eax
80105e68:	6a 00                	push   $0x0
80105e6a:	e8 ec f0 ff ff       	call   80104f5b <argptr>
80105e6f:	83 c4 10             	add    $0x10,%esp
80105e72:	85 c0                	test   %eax,%eax
80105e74:	79 07                	jns    80105e7d <sys_wait2+0x24>
    return -1;
80105e76:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105e7b:	eb 0f                	jmp    80105e8c <sys_wait2+0x33>

  //유효값이면 wait2 실행
  return wait2(&status);
80105e7d:	83 ec 0c             	sub    $0xc,%esp
80105e80:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105e83:	50                   	push   %eax
80105e84:	e8 a1 e3 ff ff       	call   8010422a <wait2>
80105e89:	83 c4 10             	add    $0x10,%esp

}
80105e8c:	c9                   	leave  
80105e8d:	c3                   	ret    

80105e8e <sys_kill>:
//********************************


int
sys_kill(void)
{
80105e8e:	55                   	push   %ebp
80105e8f:	89 e5                	mov    %esp,%ebp
80105e91:	83 ec 18             	sub    $0x18,%esp
  int pid;

  if(argint(0, &pid) < 0)
80105e94:	83 ec 08             	sub    $0x8,%esp
80105e97:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105e9a:	50                   	push   %eax
80105e9b:	6a 00                	push   $0x0
80105e9d:	e8 8c f0 ff ff       	call   80104f2e <argint>
80105ea2:	83 c4 10             	add    $0x10,%esp
80105ea5:	85 c0                	test   %eax,%eax
80105ea7:	79 07                	jns    80105eb0 <sys_kill+0x22>
    return -1;
80105ea9:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105eae:	eb 0f                	jmp    80105ebf <sys_kill+0x31>
  return kill(pid);
80105eb0:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105eb3:	83 ec 0c             	sub    $0xc,%esp
80105eb6:	50                   	push   %eax
80105eb7:	e8 ce e7 ff ff       	call   8010468a <kill>
80105ebc:	83 c4 10             	add    $0x10,%esp
}
80105ebf:	c9                   	leave  
80105ec0:	c3                   	ret    

80105ec1 <sys_getpid>:

int
sys_getpid(void)
{
80105ec1:	55                   	push   %ebp
80105ec2:	89 e5                	mov    %esp,%ebp
80105ec4:	83 ec 08             	sub    $0x8,%esp
  return myproc()->pid;
80105ec7:	e8 64 db ff ff       	call   80103a30 <myproc>
80105ecc:	8b 40 10             	mov    0x10(%eax),%eax
}
80105ecf:	c9                   	leave  
80105ed0:	c3                   	ret    

80105ed1 <sys_sbrk>:

int
sys_sbrk(void)
{
80105ed1:	55                   	push   %ebp
80105ed2:	89 e5                	mov    %esp,%ebp
80105ed4:	83 ec 18             	sub    $0x18,%esp
  int addr;
  int n;

  if(argint(0, &n) < 0)
80105ed7:	83 ec 08             	sub    $0x8,%esp
80105eda:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105edd:	50                   	push   %eax
80105ede:	6a 00                	push   $0x0
80105ee0:	e8 49 f0 ff ff       	call   80104f2e <argint>
80105ee5:	83 c4 10             	add    $0x10,%esp
80105ee8:	85 c0                	test   %eax,%eax
80105eea:	79 07                	jns    80105ef3 <sys_sbrk+0x22>
    return -1;
80105eec:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105ef1:	eb 27                	jmp    80105f1a <sys_sbrk+0x49>
  addr = myproc()->sz;
80105ef3:	e8 38 db ff ff       	call   80103a30 <myproc>
80105ef8:	8b 00                	mov    (%eax),%eax
80105efa:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(growproc(n) < 0)
80105efd:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105f00:	83 ec 0c             	sub    $0xc,%esp
80105f03:	50                   	push   %eax
80105f04:	e8 8e dd ff ff       	call   80103c97 <growproc>
80105f09:	83 c4 10             	add    $0x10,%esp
80105f0c:	85 c0                	test   %eax,%eax
80105f0e:	79 07                	jns    80105f17 <sys_sbrk+0x46>
    return -1;
80105f10:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105f15:	eb 03                	jmp    80105f1a <sys_sbrk+0x49>
  return addr;
80105f17:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
80105f1a:	c9                   	leave  
80105f1b:	c3                   	ret    

80105f1c <sys_sleep>:

int
sys_sleep(void)
{
80105f1c:	55                   	push   %ebp
80105f1d:	89 e5                	mov    %esp,%ebp
80105f1f:	83 ec 18             	sub    $0x18,%esp
  int n;
  uint ticks0;

  if(argint(0, &n) < 0)
80105f22:	83 ec 08             	sub    $0x8,%esp
80105f25:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105f28:	50                   	push   %eax
80105f29:	6a 00                	push   $0x0
80105f2b:	e8 fe ef ff ff       	call   80104f2e <argint>
80105f30:	83 c4 10             	add    $0x10,%esp
80105f33:	85 c0                	test   %eax,%eax
80105f35:	79 07                	jns    80105f3e <sys_sleep+0x22>
    return -1;
80105f37:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105f3c:	eb 76                	jmp    80105fb4 <sys_sleep+0x98>
  acquire(&tickslock);
80105f3e:	83 ec 0c             	sub    $0xc,%esp
80105f41:	68 40 6b 19 80       	push   $0x80196b40
80105f46:	e8 42 ea ff ff       	call   8010498d <acquire>
80105f4b:	83 c4 10             	add    $0x10,%esp
  ticks0 = ticks;
80105f4e:	a1 74 6b 19 80       	mov    0x80196b74,%eax
80105f53:	89 45 f4             	mov    %eax,-0xc(%ebp)
  while(ticks - ticks0 < n){
80105f56:	eb 38                	jmp    80105f90 <sys_sleep+0x74>
    if(myproc()->killed){
80105f58:	e8 d3 da ff ff       	call   80103a30 <myproc>
80105f5d:	8b 40 24             	mov    0x24(%eax),%eax
80105f60:	85 c0                	test   %eax,%eax
80105f62:	74 17                	je     80105f7b <sys_sleep+0x5f>
      release(&tickslock);
80105f64:	83 ec 0c             	sub    $0xc,%esp
80105f67:	68 40 6b 19 80       	push   $0x80196b40
80105f6c:	e8 8a ea ff ff       	call   801049fb <release>
80105f71:	83 c4 10             	add    $0x10,%esp
      return -1;
80105f74:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105f79:	eb 39                	jmp    80105fb4 <sys_sleep+0x98>
    }
    sleep(&ticks, &tickslock);
80105f7b:	83 ec 08             	sub    $0x8,%esp
80105f7e:	68 40 6b 19 80       	push   $0x80196b40
80105f83:	68 74 6b 19 80       	push   $0x80196b74
80105f88:	e8 dc e5 ff ff       	call   80104569 <sleep>
80105f8d:	83 c4 10             	add    $0x10,%esp
  while(ticks - ticks0 < n){
80105f90:	a1 74 6b 19 80       	mov    0x80196b74,%eax
80105f95:	2b 45 f4             	sub    -0xc(%ebp),%eax
80105f98:	8b 55 f0             	mov    -0x10(%ebp),%edx
80105f9b:	39 d0                	cmp    %edx,%eax
80105f9d:	72 b9                	jb     80105f58 <sys_sleep+0x3c>
  }
  release(&tickslock);
80105f9f:	83 ec 0c             	sub    $0xc,%esp
80105fa2:	68 40 6b 19 80       	push   $0x80196b40
80105fa7:	e8 4f ea ff ff       	call   801049fb <release>
80105fac:	83 c4 10             	add    $0x10,%esp
  return 0;
80105faf:	b8 00 00 00 00       	mov    $0x0,%eax
}
80105fb4:	c9                   	leave  
80105fb5:	c3                   	ret    

80105fb6 <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
int
sys_uptime(void)
{
80105fb6:	55                   	push   %ebp
80105fb7:	89 e5                	mov    %esp,%ebp
80105fb9:	83 ec 18             	sub    $0x18,%esp
  uint xticks;

  acquire(&tickslock);
80105fbc:	83 ec 0c             	sub    $0xc,%esp
80105fbf:	68 40 6b 19 80       	push   $0x80196b40
80105fc4:	e8 c4 e9 ff ff       	call   8010498d <acquire>
80105fc9:	83 c4 10             	add    $0x10,%esp
  xticks = ticks;
80105fcc:	a1 74 6b 19 80       	mov    0x80196b74,%eax
80105fd1:	89 45 f4             	mov    %eax,-0xc(%ebp)
  release(&tickslock);
80105fd4:	83 ec 0c             	sub    $0xc,%esp
80105fd7:	68 40 6b 19 80       	push   $0x80196b40
80105fdc:	e8 1a ea ff ff       	call   801049fb <release>
80105fe1:	83 c4 10             	add    $0x10,%esp
  return xticks;
80105fe4:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
80105fe7:	c9                   	leave  
80105fe8:	c3                   	ret    

80105fe9 <alltraps>:
80105fe9:	1e                   	push   %ds
80105fea:	06                   	push   %es
80105feb:	0f a0                	push   %fs
80105fed:	0f a8                	push   %gs
80105fef:	60                   	pusha  
80105ff0:	66 b8 10 00          	mov    $0x10,%ax
80105ff4:	8e d8                	mov    %eax,%ds
80105ff6:	8e c0                	mov    %eax,%es
80105ff8:	54                   	push   %esp
80105ff9:	e8 d7 01 00 00       	call   801061d5 <trap>
80105ffe:	83 c4 04             	add    $0x4,%esp

80106001 <trapret>:
80106001:	61                   	popa   
80106002:	0f a9                	pop    %gs
80106004:	0f a1                	pop    %fs
80106006:	07                   	pop    %es
80106007:	1f                   	pop    %ds
80106008:	83 c4 08             	add    $0x8,%esp
8010600b:	cf                   	iret   

8010600c <lidt>:
{
8010600c:	55                   	push   %ebp
8010600d:	89 e5                	mov    %esp,%ebp
8010600f:	83 ec 10             	sub    $0x10,%esp
  pd[0] = size-1;
80106012:	8b 45 0c             	mov    0xc(%ebp),%eax
80106015:	83 e8 01             	sub    $0x1,%eax
80106018:	66 89 45 fa          	mov    %ax,-0x6(%ebp)
  pd[1] = (uint)p;
8010601c:	8b 45 08             	mov    0x8(%ebp),%eax
8010601f:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  pd[2] = (uint)p >> 16;
80106023:	8b 45 08             	mov    0x8(%ebp),%eax
80106026:	c1 e8 10             	shr    $0x10,%eax
80106029:	66 89 45 fe          	mov    %ax,-0x2(%ebp)
  asm volatile("lidt (%0)" : : "r" (pd));
8010602d:	8d 45 fa             	lea    -0x6(%ebp),%eax
80106030:	0f 01 18             	lidtl  (%eax)
}
80106033:	90                   	nop
80106034:	c9                   	leave  
80106035:	c3                   	ret    

80106036 <rcr2>:

static inline uint
rcr2(void)
{
80106036:	55                   	push   %ebp
80106037:	89 e5                	mov    %esp,%ebp
80106039:	83 ec 10             	sub    $0x10,%esp
  uint val;
  asm volatile("movl %%cr2,%0" : "=r" (val));
8010603c:	0f 20 d0             	mov    %cr2,%eax
8010603f:	89 45 fc             	mov    %eax,-0x4(%ebp)
  return val;
80106042:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
80106045:	c9                   	leave  
80106046:	c3                   	ret    

80106047 <tvinit>:
struct spinlock tickslock;
uint ticks;

void
tvinit(void)
{
80106047:	55                   	push   %ebp
80106048:	89 e5                	mov    %esp,%ebp
8010604a:	83 ec 18             	sub    $0x18,%esp
  int i;

  for(i = 0; i < 256; i++)
8010604d:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80106054:	e9 c3 00 00 00       	jmp    8010611c <tvinit+0xd5>
    SETGATE(idt[i], 0, SEG_KCODE<<3, vectors[i], 0);
80106059:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010605c:	8b 04 85 84 f0 10 80 	mov    -0x7fef0f7c(,%eax,4),%eax
80106063:	89 c2                	mov    %eax,%edx
80106065:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106068:	66 89 14 c5 40 63 19 	mov    %dx,-0x7fe69cc0(,%eax,8)
8010606f:	80 
80106070:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106073:	66 c7 04 c5 42 63 19 	movw   $0x8,-0x7fe69cbe(,%eax,8)
8010607a:	80 08 00 
8010607d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106080:	0f b6 14 c5 44 63 19 	movzbl -0x7fe69cbc(,%eax,8),%edx
80106087:	80 
80106088:	83 e2 e0             	and    $0xffffffe0,%edx
8010608b:	88 14 c5 44 63 19 80 	mov    %dl,-0x7fe69cbc(,%eax,8)
80106092:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106095:	0f b6 14 c5 44 63 19 	movzbl -0x7fe69cbc(,%eax,8),%edx
8010609c:	80 
8010609d:	83 e2 1f             	and    $0x1f,%edx
801060a0:	88 14 c5 44 63 19 80 	mov    %dl,-0x7fe69cbc(,%eax,8)
801060a7:	8b 45 f4             	mov    -0xc(%ebp),%eax
801060aa:	0f b6 14 c5 45 63 19 	movzbl -0x7fe69cbb(,%eax,8),%edx
801060b1:	80 
801060b2:	83 e2 f0             	and    $0xfffffff0,%edx
801060b5:	83 ca 0e             	or     $0xe,%edx
801060b8:	88 14 c5 45 63 19 80 	mov    %dl,-0x7fe69cbb(,%eax,8)
801060bf:	8b 45 f4             	mov    -0xc(%ebp),%eax
801060c2:	0f b6 14 c5 45 63 19 	movzbl -0x7fe69cbb(,%eax,8),%edx
801060c9:	80 
801060ca:	83 e2 ef             	and    $0xffffffef,%edx
801060cd:	88 14 c5 45 63 19 80 	mov    %dl,-0x7fe69cbb(,%eax,8)
801060d4:	8b 45 f4             	mov    -0xc(%ebp),%eax
801060d7:	0f b6 14 c5 45 63 19 	movzbl -0x7fe69cbb(,%eax,8),%edx
801060de:	80 
801060df:	83 e2 9f             	and    $0xffffff9f,%edx
801060e2:	88 14 c5 45 63 19 80 	mov    %dl,-0x7fe69cbb(,%eax,8)
801060e9:	8b 45 f4             	mov    -0xc(%ebp),%eax
801060ec:	0f b6 14 c5 45 63 19 	movzbl -0x7fe69cbb(,%eax,8),%edx
801060f3:	80 
801060f4:	83 ca 80             	or     $0xffffff80,%edx
801060f7:	88 14 c5 45 63 19 80 	mov    %dl,-0x7fe69cbb(,%eax,8)
801060fe:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106101:	8b 04 85 84 f0 10 80 	mov    -0x7fef0f7c(,%eax,4),%eax
80106108:	c1 e8 10             	shr    $0x10,%eax
8010610b:	89 c2                	mov    %eax,%edx
8010610d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106110:	66 89 14 c5 46 63 19 	mov    %dx,-0x7fe69cba(,%eax,8)
80106117:	80 
  for(i = 0; i < 256; i++)
80106118:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
8010611c:	81 7d f4 ff 00 00 00 	cmpl   $0xff,-0xc(%ebp)
80106123:	0f 8e 30 ff ff ff    	jle    80106059 <tvinit+0x12>
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
80106129:	a1 84 f1 10 80       	mov    0x8010f184,%eax
8010612e:	66 a3 40 65 19 80    	mov    %ax,0x80196540
80106134:	66 c7 05 42 65 19 80 	movw   $0x8,0x80196542
8010613b:	08 00 
8010613d:	0f b6 05 44 65 19 80 	movzbl 0x80196544,%eax
80106144:	83 e0 e0             	and    $0xffffffe0,%eax
80106147:	a2 44 65 19 80       	mov    %al,0x80196544
8010614c:	0f b6 05 44 65 19 80 	movzbl 0x80196544,%eax
80106153:	83 e0 1f             	and    $0x1f,%eax
80106156:	a2 44 65 19 80       	mov    %al,0x80196544
8010615b:	0f b6 05 45 65 19 80 	movzbl 0x80196545,%eax
80106162:	83 c8 0f             	or     $0xf,%eax
80106165:	a2 45 65 19 80       	mov    %al,0x80196545
8010616a:	0f b6 05 45 65 19 80 	movzbl 0x80196545,%eax
80106171:	83 e0 ef             	and    $0xffffffef,%eax
80106174:	a2 45 65 19 80       	mov    %al,0x80196545
80106179:	0f b6 05 45 65 19 80 	movzbl 0x80196545,%eax
80106180:	83 c8 60             	or     $0x60,%eax
80106183:	a2 45 65 19 80       	mov    %al,0x80196545
80106188:	0f b6 05 45 65 19 80 	movzbl 0x80196545,%eax
8010618f:	83 c8 80             	or     $0xffffff80,%eax
80106192:	a2 45 65 19 80       	mov    %al,0x80196545
80106197:	a1 84 f1 10 80       	mov    0x8010f184,%eax
8010619c:	c1 e8 10             	shr    $0x10,%eax
8010619f:	66 a3 46 65 19 80    	mov    %ax,0x80196546

  initlock(&tickslock, "time");
801061a5:	83 ec 08             	sub    $0x8,%esp
801061a8:	68 b8 a6 10 80       	push   $0x8010a6b8
801061ad:	68 40 6b 19 80       	push   $0x80196b40
801061b2:	e8 b4 e7 ff ff       	call   8010496b <initlock>
801061b7:	83 c4 10             	add    $0x10,%esp
}
801061ba:	90                   	nop
801061bb:	c9                   	leave  
801061bc:	c3                   	ret    

801061bd <idtinit>:

void
idtinit(void)
{
801061bd:	55                   	push   %ebp
801061be:	89 e5                	mov    %esp,%ebp
  lidt(idt, sizeof(idt));
801061c0:	68 00 08 00 00       	push   $0x800
801061c5:	68 40 63 19 80       	push   $0x80196340
801061ca:	e8 3d fe ff ff       	call   8010600c <lidt>
801061cf:	83 c4 08             	add    $0x8,%esp
}
801061d2:	90                   	nop
801061d3:	c9                   	leave  
801061d4:	c3                   	ret    

801061d5 <trap>:

//PAGEBREAK: 41
void
trap(struct trapframe *tf)
{
801061d5:	55                   	push   %ebp
801061d6:	89 e5                	mov    %esp,%ebp
801061d8:	57                   	push   %edi
801061d9:	56                   	push   %esi
801061da:	53                   	push   %ebx
801061db:	83 ec 1c             	sub    $0x1c,%esp
  if(tf->trapno == T_SYSCALL){
801061de:	8b 45 08             	mov    0x8(%ebp),%eax
801061e1:	8b 40 30             	mov    0x30(%eax),%eax
801061e4:	83 f8 40             	cmp    $0x40,%eax
801061e7:	75 3b                	jne    80106224 <trap+0x4f>
    if(myproc()->killed)
801061e9:	e8 42 d8 ff ff       	call   80103a30 <myproc>
801061ee:	8b 40 24             	mov    0x24(%eax),%eax
801061f1:	85 c0                	test   %eax,%eax
801061f3:	74 05                	je     801061fa <trap+0x25>
      exit();
801061f5:	e8 b1 dc ff ff       	call   80103eab <exit>
    myproc()->tf = tf;
801061fa:	e8 31 d8 ff ff       	call   80103a30 <myproc>
801061ff:	8b 55 08             	mov    0x8(%ebp),%edx
80106202:	89 50 18             	mov    %edx,0x18(%eax)
    syscall();
80106205:	e8 f0 ed ff ff       	call   80104ffa <syscall>
    if(myproc()->killed)
8010620a:	e8 21 d8 ff ff       	call   80103a30 <myproc>
8010620f:	8b 40 24             	mov    0x24(%eax),%eax
80106212:	85 c0                	test   %eax,%eax
80106214:	0f 84 15 02 00 00    	je     8010642f <trap+0x25a>
      exit();
8010621a:	e8 8c dc ff ff       	call   80103eab <exit>
    return;
8010621f:	e9 0b 02 00 00       	jmp    8010642f <trap+0x25a>
  }

  switch(tf->trapno){
80106224:	8b 45 08             	mov    0x8(%ebp),%eax
80106227:	8b 40 30             	mov    0x30(%eax),%eax
8010622a:	83 e8 20             	sub    $0x20,%eax
8010622d:	83 f8 1f             	cmp    $0x1f,%eax
80106230:	0f 87 c4 00 00 00    	ja     801062fa <trap+0x125>
80106236:	8b 04 85 60 a7 10 80 	mov    -0x7fef58a0(,%eax,4),%eax
8010623d:	ff e0                	jmp    *%eax
  case T_IRQ0 + IRQ_TIMER: //*************timer interrupt
    if(cpuid() == 0){
8010623f:	e8 59 d7 ff ff       	call   8010399d <cpuid>
80106244:	85 c0                	test   %eax,%eax
80106246:	75 3d                	jne    80106285 <trap+0xb0>
      acquire(&tickslock);
80106248:	83 ec 0c             	sub    $0xc,%esp
8010624b:	68 40 6b 19 80       	push   $0x80196b40
80106250:	e8 38 e7 ff ff       	call   8010498d <acquire>
80106255:	83 c4 10             	add    $0x10,%esp
      ticks++;
80106258:	a1 74 6b 19 80       	mov    0x80196b74,%eax
8010625d:	83 c0 01             	add    $0x1,%eax
80106260:	a3 74 6b 19 80       	mov    %eax,0x80196b74
      wakeup(&ticks);
80106265:	83 ec 0c             	sub    $0xc,%esp
80106268:	68 74 6b 19 80       	push   $0x80196b74
8010626d:	e8 e1 e3 ff ff       	call   80104653 <wakeup>
80106272:	83 c4 10             	add    $0x10,%esp
      release(&tickslock);
80106275:	83 ec 0c             	sub    $0xc,%esp
80106278:	68 40 6b 19 80       	push   $0x80196b40
8010627d:	e8 79 e7 ff ff       	call   801049fb <release>
80106282:	83 c4 10             	add    $0x10,%esp
    }
    lapiceoi();
80106285:	e8 92 c8 ff ff       	call   80102b1c <lapiceoi>

//******************   new code   ****************



    break;
8010628a:	e9 20 01 00 00       	jmp    801063af <trap+0x1da>
  case T_IRQ0 + IRQ_IDE:
    ideintr();
8010628f:	e8 f5 3e 00 00       	call   8010a189 <ideintr>
    lapiceoi();
80106294:	e8 83 c8 ff ff       	call   80102b1c <lapiceoi>
    break;
80106299:	e9 11 01 00 00       	jmp    801063af <trap+0x1da>
  case T_IRQ0 + IRQ_IDE+1:
    // Bochs generates spurious IDE1 interrupts.
    break;
  case T_IRQ0 + IRQ_KBD:
    kbdintr();
8010629e:	e8 be c6 ff ff       	call   80102961 <kbdintr>
    lapiceoi();
801062a3:	e8 74 c8 ff ff       	call   80102b1c <lapiceoi>
    break;
801062a8:	e9 02 01 00 00       	jmp    801063af <trap+0x1da>
  case T_IRQ0 + IRQ_COM1:
    uartintr();
801062ad:	e8 53 03 00 00       	call   80106605 <uartintr>
    lapiceoi();
801062b2:	e8 65 c8 ff ff       	call   80102b1c <lapiceoi>
    break;
801062b7:	e9 f3 00 00 00       	jmp    801063af <trap+0x1da>
  case T_IRQ0 + 0xB:
    i8254_intr();
801062bc:	e8 7b 2b 00 00       	call   80108e3c <i8254_intr>
    lapiceoi();
801062c1:	e8 56 c8 ff ff       	call   80102b1c <lapiceoi>
    break;
801062c6:	e9 e4 00 00 00       	jmp    801063af <trap+0x1da>
  case T_IRQ0 + IRQ_SPURIOUS:
    cprintf("cpu%d: spurious interrupt at %x:%x\n",
801062cb:	8b 45 08             	mov    0x8(%ebp),%eax
801062ce:	8b 70 38             	mov    0x38(%eax),%esi
            cpuid(), tf->cs, tf->eip);
801062d1:	8b 45 08             	mov    0x8(%ebp),%eax
801062d4:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
    cprintf("cpu%d: spurious interrupt at %x:%x\n",
801062d8:	0f b7 d8             	movzwl %ax,%ebx
801062db:	e8 bd d6 ff ff       	call   8010399d <cpuid>
801062e0:	56                   	push   %esi
801062e1:	53                   	push   %ebx
801062e2:	50                   	push   %eax
801062e3:	68 c0 a6 10 80       	push   $0x8010a6c0
801062e8:	e8 07 a1 ff ff       	call   801003f4 <cprintf>
801062ed:	83 c4 10             	add    $0x10,%esp
    lapiceoi();
801062f0:	e8 27 c8 ff ff       	call   80102b1c <lapiceoi>
    break;
801062f5:	e9 b5 00 00 00       	jmp    801063af <trap+0x1da>

  //PAGEBREAK: 13
  default:
    if(myproc() == 0 || (tf->cs&3) == 0){
801062fa:	e8 31 d7 ff ff       	call   80103a30 <myproc>
801062ff:	85 c0                	test   %eax,%eax
80106301:	74 11                	je     80106314 <trap+0x13f>
80106303:	8b 45 08             	mov    0x8(%ebp),%eax
80106306:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
8010630a:	0f b7 c0             	movzwl %ax,%eax
8010630d:	83 e0 03             	and    $0x3,%eax
80106310:	85 c0                	test   %eax,%eax
80106312:	75 39                	jne    8010634d <trap+0x178>
      // In kernel, it must be our mistake.
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
80106314:	e8 1d fd ff ff       	call   80106036 <rcr2>
80106319:	89 c3                	mov    %eax,%ebx
8010631b:	8b 45 08             	mov    0x8(%ebp),%eax
8010631e:	8b 70 38             	mov    0x38(%eax),%esi
80106321:	e8 77 d6 ff ff       	call   8010399d <cpuid>
80106326:	8b 55 08             	mov    0x8(%ebp),%edx
80106329:	8b 52 30             	mov    0x30(%edx),%edx
8010632c:	83 ec 0c             	sub    $0xc,%esp
8010632f:	53                   	push   %ebx
80106330:	56                   	push   %esi
80106331:	50                   	push   %eax
80106332:	52                   	push   %edx
80106333:	68 e4 a6 10 80       	push   $0x8010a6e4
80106338:	e8 b7 a0 ff ff       	call   801003f4 <cprintf>
8010633d:	83 c4 20             	add    $0x20,%esp
              tf->trapno, cpuid(), tf->eip, rcr2());
      panic("trap");
80106340:	83 ec 0c             	sub    $0xc,%esp
80106343:	68 16 a7 10 80       	push   $0x8010a716
80106348:	e8 5c a2 ff ff       	call   801005a9 <panic>
    }
    // In user space, assume process misbehaved.
    cprintf("pid %d %s: trap %d err %d on cpu %d "
8010634d:	e8 e4 fc ff ff       	call   80106036 <rcr2>
80106352:	89 c6                	mov    %eax,%esi
80106354:	8b 45 08             	mov    0x8(%ebp),%eax
80106357:	8b 40 38             	mov    0x38(%eax),%eax
8010635a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
8010635d:	e8 3b d6 ff ff       	call   8010399d <cpuid>
80106362:	89 c3                	mov    %eax,%ebx
80106364:	8b 45 08             	mov    0x8(%ebp),%eax
80106367:	8b 48 34             	mov    0x34(%eax),%ecx
8010636a:	89 4d e0             	mov    %ecx,-0x20(%ebp)
8010636d:	8b 45 08             	mov    0x8(%ebp),%eax
80106370:	8b 78 30             	mov    0x30(%eax),%edi
            "eip 0x%x addr 0x%x--kill proc\n",
            myproc()->pid, myproc()->name, tf->trapno,
80106373:	e8 b8 d6 ff ff       	call   80103a30 <myproc>
80106378:	8d 50 6c             	lea    0x6c(%eax),%edx
8010637b:	89 55 dc             	mov    %edx,-0x24(%ebp)
8010637e:	e8 ad d6 ff ff       	call   80103a30 <myproc>
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80106383:	8b 40 10             	mov    0x10(%eax),%eax
80106386:	56                   	push   %esi
80106387:	ff 75 e4             	push   -0x1c(%ebp)
8010638a:	53                   	push   %ebx
8010638b:	ff 75 e0             	push   -0x20(%ebp)
8010638e:	57                   	push   %edi
8010638f:	ff 75 dc             	push   -0x24(%ebp)
80106392:	50                   	push   %eax
80106393:	68 1c a7 10 80       	push   $0x8010a71c
80106398:	e8 57 a0 ff ff       	call   801003f4 <cprintf>
8010639d:	83 c4 20             	add    $0x20,%esp
            tf->err, cpuid(), tf->eip, rcr2());
    myproc()->killed = 1;
801063a0:	e8 8b d6 ff ff       	call   80103a30 <myproc>
801063a5:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
801063ac:	eb 01                	jmp    801063af <trap+0x1da>
    break;
801063ae:	90                   	nop
  }

  // Force process exit if it has been killed and is in user space.
  // (If it is still executing in the kernel, let it keep running
  // until it gets to the regular system call return.)
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
801063af:	e8 7c d6 ff ff       	call   80103a30 <myproc>
801063b4:	85 c0                	test   %eax,%eax
801063b6:	74 23                	je     801063db <trap+0x206>
801063b8:	e8 73 d6 ff ff       	call   80103a30 <myproc>
801063bd:	8b 40 24             	mov    0x24(%eax),%eax
801063c0:	85 c0                	test   %eax,%eax
801063c2:	74 17                	je     801063db <trap+0x206>
801063c4:	8b 45 08             	mov    0x8(%ebp),%eax
801063c7:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
801063cb:	0f b7 c0             	movzwl %ax,%eax
801063ce:	83 e0 03             	and    $0x3,%eax
801063d1:	83 f8 03             	cmp    $0x3,%eax
801063d4:	75 05                	jne    801063db <trap+0x206>
    exit();
801063d6:	e8 d0 da ff ff       	call   80103eab <exit>

  // Force process to give up CPU on clock tick.
  // If interrupts were on while locks held, would need to check nlock.
  if(myproc() && myproc()->state == RUNNING &&
801063db:	e8 50 d6 ff ff       	call   80103a30 <myproc>
801063e0:	85 c0                	test   %eax,%eax
801063e2:	74 1d                	je     80106401 <trap+0x22c>
801063e4:	e8 47 d6 ff ff       	call   80103a30 <myproc>
801063e9:	8b 40 0c             	mov    0xc(%eax),%eax
801063ec:	83 f8 04             	cmp    $0x4,%eax
801063ef:	75 10                	jne    80106401 <trap+0x22c>
     tf->trapno == T_IRQ0+IRQ_TIMER)
801063f1:	8b 45 08             	mov    0x8(%ebp),%eax
801063f4:	8b 40 30             	mov    0x30(%eax),%eax
  if(myproc() && myproc()->state == RUNNING &&
801063f7:	83 f8 20             	cmp    $0x20,%eax
801063fa:	75 05                	jne    80106401 <trap+0x22c>
    yield();
801063fc:	e8 e8 e0 ff ff       	call   801044e9 <yield>

  // Check if the process has been killed since we yielded
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80106401:	e8 2a d6 ff ff       	call   80103a30 <myproc>
80106406:	85 c0                	test   %eax,%eax
80106408:	74 26                	je     80106430 <trap+0x25b>
8010640a:	e8 21 d6 ff ff       	call   80103a30 <myproc>
8010640f:	8b 40 24             	mov    0x24(%eax),%eax
80106412:	85 c0                	test   %eax,%eax
80106414:	74 1a                	je     80106430 <trap+0x25b>
80106416:	8b 45 08             	mov    0x8(%ebp),%eax
80106419:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
8010641d:	0f b7 c0             	movzwl %ax,%eax
80106420:	83 e0 03             	and    $0x3,%eax
80106423:	83 f8 03             	cmp    $0x3,%eax
80106426:	75 08                	jne    80106430 <trap+0x25b>
    exit();
80106428:	e8 7e da ff ff       	call   80103eab <exit>
8010642d:	eb 01                	jmp    80106430 <trap+0x25b>
    return;
8010642f:	90                   	nop
}
80106430:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106433:	5b                   	pop    %ebx
80106434:	5e                   	pop    %esi
80106435:	5f                   	pop    %edi
80106436:	5d                   	pop    %ebp
80106437:	c3                   	ret    

80106438 <inb>:
{
80106438:	55                   	push   %ebp
80106439:	89 e5                	mov    %esp,%ebp
8010643b:	83 ec 14             	sub    $0x14,%esp
8010643e:	8b 45 08             	mov    0x8(%ebp),%eax
80106441:	66 89 45 ec          	mov    %ax,-0x14(%ebp)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80106445:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
80106449:	89 c2                	mov    %eax,%edx
8010644b:	ec                   	in     (%dx),%al
8010644c:	88 45 ff             	mov    %al,-0x1(%ebp)
  return data;
8010644f:	0f b6 45 ff          	movzbl -0x1(%ebp),%eax
}
80106453:	c9                   	leave  
80106454:	c3                   	ret    

80106455 <outb>:
{
80106455:	55                   	push   %ebp
80106456:	89 e5                	mov    %esp,%ebp
80106458:	83 ec 08             	sub    $0x8,%esp
8010645b:	8b 45 08             	mov    0x8(%ebp),%eax
8010645e:	8b 55 0c             	mov    0xc(%ebp),%edx
80106461:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
80106465:	89 d0                	mov    %edx,%eax
80106467:	88 45 f8             	mov    %al,-0x8(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010646a:	0f b6 45 f8          	movzbl -0x8(%ebp),%eax
8010646e:	0f b7 55 fc          	movzwl -0x4(%ebp),%edx
80106472:	ee                   	out    %al,(%dx)
}
80106473:	90                   	nop
80106474:	c9                   	leave  
80106475:	c3                   	ret    

80106476 <uartinit>:

static int uart;    // is there a uart?

void
uartinit(void)
{
80106476:	55                   	push   %ebp
80106477:	89 e5                	mov    %esp,%ebp
80106479:	83 ec 18             	sub    $0x18,%esp
  char *p;

  // Turn off the FIFO
  outb(COM1+2, 0);
8010647c:	6a 00                	push   $0x0
8010647e:	68 fa 03 00 00       	push   $0x3fa
80106483:	e8 cd ff ff ff       	call   80106455 <outb>
80106488:	83 c4 08             	add    $0x8,%esp

  // 9600 baud, 8 data bits, 1 stop bit, parity off.
  outb(COM1+3, 0x80);    // Unlock divisor
8010648b:	68 80 00 00 00       	push   $0x80
80106490:	68 fb 03 00 00       	push   $0x3fb
80106495:	e8 bb ff ff ff       	call   80106455 <outb>
8010649a:	83 c4 08             	add    $0x8,%esp
  outb(COM1+0, 115200/9600);
8010649d:	6a 0c                	push   $0xc
8010649f:	68 f8 03 00 00       	push   $0x3f8
801064a4:	e8 ac ff ff ff       	call   80106455 <outb>
801064a9:	83 c4 08             	add    $0x8,%esp
  outb(COM1+1, 0);
801064ac:	6a 00                	push   $0x0
801064ae:	68 f9 03 00 00       	push   $0x3f9
801064b3:	e8 9d ff ff ff       	call   80106455 <outb>
801064b8:	83 c4 08             	add    $0x8,%esp
  outb(COM1+3, 0x03);    // Lock divisor, 8 data bits.
801064bb:	6a 03                	push   $0x3
801064bd:	68 fb 03 00 00       	push   $0x3fb
801064c2:	e8 8e ff ff ff       	call   80106455 <outb>
801064c7:	83 c4 08             	add    $0x8,%esp
  outb(COM1+4, 0);
801064ca:	6a 00                	push   $0x0
801064cc:	68 fc 03 00 00       	push   $0x3fc
801064d1:	e8 7f ff ff ff       	call   80106455 <outb>
801064d6:	83 c4 08             	add    $0x8,%esp
  outb(COM1+1, 0x01);    // Enable receive interrupts.
801064d9:	6a 01                	push   $0x1
801064db:	68 f9 03 00 00       	push   $0x3f9
801064e0:	e8 70 ff ff ff       	call   80106455 <outb>
801064e5:	83 c4 08             	add    $0x8,%esp

  // If status is 0xFF, no serial port.
  if(inb(COM1+5) == 0xFF)
801064e8:	68 fd 03 00 00       	push   $0x3fd
801064ed:	e8 46 ff ff ff       	call   80106438 <inb>
801064f2:	83 c4 04             	add    $0x4,%esp
801064f5:	3c ff                	cmp    $0xff,%al
801064f7:	74 61                	je     8010655a <uartinit+0xe4>
    return;
  uart = 1;
801064f9:	c7 05 78 6b 19 80 01 	movl   $0x1,0x80196b78
80106500:	00 00 00 

  // Acknowledge pre-existing interrupt conditions;
  // enable interrupts.
  inb(COM1+2);
80106503:	68 fa 03 00 00       	push   $0x3fa
80106508:	e8 2b ff ff ff       	call   80106438 <inb>
8010650d:	83 c4 04             	add    $0x4,%esp
  inb(COM1+0);
80106510:	68 f8 03 00 00       	push   $0x3f8
80106515:	e8 1e ff ff ff       	call   80106438 <inb>
8010651a:	83 c4 04             	add    $0x4,%esp
  ioapicenable(IRQ_COM1, 0);
8010651d:	83 ec 08             	sub    $0x8,%esp
80106520:	6a 00                	push   $0x0
80106522:	6a 04                	push   $0x4
80106524:	e8 05 c1 ff ff       	call   8010262e <ioapicenable>
80106529:	83 c4 10             	add    $0x10,%esp

  // Announce that we're here.
  for(p="xv6...\n"; *p; p++)
8010652c:	c7 45 f4 e0 a7 10 80 	movl   $0x8010a7e0,-0xc(%ebp)
80106533:	eb 19                	jmp    8010654e <uartinit+0xd8>
    uartputc(*p);
80106535:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106538:	0f b6 00             	movzbl (%eax),%eax
8010653b:	0f be c0             	movsbl %al,%eax
8010653e:	83 ec 0c             	sub    $0xc,%esp
80106541:	50                   	push   %eax
80106542:	e8 16 00 00 00       	call   8010655d <uartputc>
80106547:	83 c4 10             	add    $0x10,%esp
  for(p="xv6...\n"; *p; p++)
8010654a:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
8010654e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106551:	0f b6 00             	movzbl (%eax),%eax
80106554:	84 c0                	test   %al,%al
80106556:	75 dd                	jne    80106535 <uartinit+0xbf>
80106558:	eb 01                	jmp    8010655b <uartinit+0xe5>
    return;
8010655a:	90                   	nop
}
8010655b:	c9                   	leave  
8010655c:	c3                   	ret    

8010655d <uartputc>:

void
uartputc(int c)
{
8010655d:	55                   	push   %ebp
8010655e:	89 e5                	mov    %esp,%ebp
80106560:	83 ec 18             	sub    $0x18,%esp
  int i;

  if(!uart)
80106563:	a1 78 6b 19 80       	mov    0x80196b78,%eax
80106568:	85 c0                	test   %eax,%eax
8010656a:	74 53                	je     801065bf <uartputc+0x62>
    return;
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
8010656c:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80106573:	eb 11                	jmp    80106586 <uartputc+0x29>
    microdelay(10);
80106575:	83 ec 0c             	sub    $0xc,%esp
80106578:	6a 0a                	push   $0xa
8010657a:	e8 b8 c5 ff ff       	call   80102b37 <microdelay>
8010657f:	83 c4 10             	add    $0x10,%esp
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
80106582:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80106586:	83 7d f4 7f          	cmpl   $0x7f,-0xc(%ebp)
8010658a:	7f 1a                	jg     801065a6 <uartputc+0x49>
8010658c:	83 ec 0c             	sub    $0xc,%esp
8010658f:	68 fd 03 00 00       	push   $0x3fd
80106594:	e8 9f fe ff ff       	call   80106438 <inb>
80106599:	83 c4 10             	add    $0x10,%esp
8010659c:	0f b6 c0             	movzbl %al,%eax
8010659f:	83 e0 20             	and    $0x20,%eax
801065a2:	85 c0                	test   %eax,%eax
801065a4:	74 cf                	je     80106575 <uartputc+0x18>
  outb(COM1+0, c);
801065a6:	8b 45 08             	mov    0x8(%ebp),%eax
801065a9:	0f b6 c0             	movzbl %al,%eax
801065ac:	83 ec 08             	sub    $0x8,%esp
801065af:	50                   	push   %eax
801065b0:	68 f8 03 00 00       	push   $0x3f8
801065b5:	e8 9b fe ff ff       	call   80106455 <outb>
801065ba:	83 c4 10             	add    $0x10,%esp
801065bd:	eb 01                	jmp    801065c0 <uartputc+0x63>
    return;
801065bf:	90                   	nop
}
801065c0:	c9                   	leave  
801065c1:	c3                   	ret    

801065c2 <uartgetc>:

static int
uartgetc(void)
{
801065c2:	55                   	push   %ebp
801065c3:	89 e5                	mov    %esp,%ebp
  if(!uart)
801065c5:	a1 78 6b 19 80       	mov    0x80196b78,%eax
801065ca:	85 c0                	test   %eax,%eax
801065cc:	75 07                	jne    801065d5 <uartgetc+0x13>
    return -1;
801065ce:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801065d3:	eb 2e                	jmp    80106603 <uartgetc+0x41>
  if(!(inb(COM1+5) & 0x01))
801065d5:	68 fd 03 00 00       	push   $0x3fd
801065da:	e8 59 fe ff ff       	call   80106438 <inb>
801065df:	83 c4 04             	add    $0x4,%esp
801065e2:	0f b6 c0             	movzbl %al,%eax
801065e5:	83 e0 01             	and    $0x1,%eax
801065e8:	85 c0                	test   %eax,%eax
801065ea:	75 07                	jne    801065f3 <uartgetc+0x31>
    return -1;
801065ec:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801065f1:	eb 10                	jmp    80106603 <uartgetc+0x41>
  return inb(COM1+0);
801065f3:	68 f8 03 00 00       	push   $0x3f8
801065f8:	e8 3b fe ff ff       	call   80106438 <inb>
801065fd:	83 c4 04             	add    $0x4,%esp
80106600:	0f b6 c0             	movzbl %al,%eax
}
80106603:	c9                   	leave  
80106604:	c3                   	ret    

80106605 <uartintr>:

void
uartintr(void)
{
80106605:	55                   	push   %ebp
80106606:	89 e5                	mov    %esp,%ebp
80106608:	83 ec 08             	sub    $0x8,%esp
  consoleintr(uartgetc);
8010660b:	83 ec 0c             	sub    $0xc,%esp
8010660e:	68 c2 65 10 80       	push   $0x801065c2
80106613:	e8 be a1 ff ff       	call   801007d6 <consoleintr>
80106618:	83 c4 10             	add    $0x10,%esp
}
8010661b:	90                   	nop
8010661c:	c9                   	leave  
8010661d:	c3                   	ret    

8010661e <vector0>:
8010661e:	6a 00                	push   $0x0
80106620:	6a 00                	push   $0x0
80106622:	e9 c2 f9 ff ff       	jmp    80105fe9 <alltraps>

80106627 <vector1>:
80106627:	6a 00                	push   $0x0
80106629:	6a 01                	push   $0x1
8010662b:	e9 b9 f9 ff ff       	jmp    80105fe9 <alltraps>

80106630 <vector2>:
80106630:	6a 00                	push   $0x0
80106632:	6a 02                	push   $0x2
80106634:	e9 b0 f9 ff ff       	jmp    80105fe9 <alltraps>

80106639 <vector3>:
80106639:	6a 00                	push   $0x0
8010663b:	6a 03                	push   $0x3
8010663d:	e9 a7 f9 ff ff       	jmp    80105fe9 <alltraps>

80106642 <vector4>:
80106642:	6a 00                	push   $0x0
80106644:	6a 04                	push   $0x4
80106646:	e9 9e f9 ff ff       	jmp    80105fe9 <alltraps>

8010664b <vector5>:
8010664b:	6a 00                	push   $0x0
8010664d:	6a 05                	push   $0x5
8010664f:	e9 95 f9 ff ff       	jmp    80105fe9 <alltraps>

80106654 <vector6>:
80106654:	6a 00                	push   $0x0
80106656:	6a 06                	push   $0x6
80106658:	e9 8c f9 ff ff       	jmp    80105fe9 <alltraps>

8010665d <vector7>:
8010665d:	6a 00                	push   $0x0
8010665f:	6a 07                	push   $0x7
80106661:	e9 83 f9 ff ff       	jmp    80105fe9 <alltraps>

80106666 <vector8>:
80106666:	6a 08                	push   $0x8
80106668:	e9 7c f9 ff ff       	jmp    80105fe9 <alltraps>

8010666d <vector9>:
8010666d:	6a 00                	push   $0x0
8010666f:	6a 09                	push   $0x9
80106671:	e9 73 f9 ff ff       	jmp    80105fe9 <alltraps>

80106676 <vector10>:
80106676:	6a 0a                	push   $0xa
80106678:	e9 6c f9 ff ff       	jmp    80105fe9 <alltraps>

8010667d <vector11>:
8010667d:	6a 0b                	push   $0xb
8010667f:	e9 65 f9 ff ff       	jmp    80105fe9 <alltraps>

80106684 <vector12>:
80106684:	6a 0c                	push   $0xc
80106686:	e9 5e f9 ff ff       	jmp    80105fe9 <alltraps>

8010668b <vector13>:
8010668b:	6a 0d                	push   $0xd
8010668d:	e9 57 f9 ff ff       	jmp    80105fe9 <alltraps>

80106692 <vector14>:
80106692:	6a 0e                	push   $0xe
80106694:	e9 50 f9 ff ff       	jmp    80105fe9 <alltraps>

80106699 <vector15>:
80106699:	6a 00                	push   $0x0
8010669b:	6a 0f                	push   $0xf
8010669d:	e9 47 f9 ff ff       	jmp    80105fe9 <alltraps>

801066a2 <vector16>:
801066a2:	6a 00                	push   $0x0
801066a4:	6a 10                	push   $0x10
801066a6:	e9 3e f9 ff ff       	jmp    80105fe9 <alltraps>

801066ab <vector17>:
801066ab:	6a 11                	push   $0x11
801066ad:	e9 37 f9 ff ff       	jmp    80105fe9 <alltraps>

801066b2 <vector18>:
801066b2:	6a 00                	push   $0x0
801066b4:	6a 12                	push   $0x12
801066b6:	e9 2e f9 ff ff       	jmp    80105fe9 <alltraps>

801066bb <vector19>:
801066bb:	6a 00                	push   $0x0
801066bd:	6a 13                	push   $0x13
801066bf:	e9 25 f9 ff ff       	jmp    80105fe9 <alltraps>

801066c4 <vector20>:
801066c4:	6a 00                	push   $0x0
801066c6:	6a 14                	push   $0x14
801066c8:	e9 1c f9 ff ff       	jmp    80105fe9 <alltraps>

801066cd <vector21>:
801066cd:	6a 00                	push   $0x0
801066cf:	6a 15                	push   $0x15
801066d1:	e9 13 f9 ff ff       	jmp    80105fe9 <alltraps>

801066d6 <vector22>:
801066d6:	6a 00                	push   $0x0
801066d8:	6a 16                	push   $0x16
801066da:	e9 0a f9 ff ff       	jmp    80105fe9 <alltraps>

801066df <vector23>:
801066df:	6a 00                	push   $0x0
801066e1:	6a 17                	push   $0x17
801066e3:	e9 01 f9 ff ff       	jmp    80105fe9 <alltraps>

801066e8 <vector24>:
801066e8:	6a 00                	push   $0x0
801066ea:	6a 18                	push   $0x18
801066ec:	e9 f8 f8 ff ff       	jmp    80105fe9 <alltraps>

801066f1 <vector25>:
801066f1:	6a 00                	push   $0x0
801066f3:	6a 19                	push   $0x19
801066f5:	e9 ef f8 ff ff       	jmp    80105fe9 <alltraps>

801066fa <vector26>:
801066fa:	6a 00                	push   $0x0
801066fc:	6a 1a                	push   $0x1a
801066fe:	e9 e6 f8 ff ff       	jmp    80105fe9 <alltraps>

80106703 <vector27>:
80106703:	6a 00                	push   $0x0
80106705:	6a 1b                	push   $0x1b
80106707:	e9 dd f8 ff ff       	jmp    80105fe9 <alltraps>

8010670c <vector28>:
8010670c:	6a 00                	push   $0x0
8010670e:	6a 1c                	push   $0x1c
80106710:	e9 d4 f8 ff ff       	jmp    80105fe9 <alltraps>

80106715 <vector29>:
80106715:	6a 00                	push   $0x0
80106717:	6a 1d                	push   $0x1d
80106719:	e9 cb f8 ff ff       	jmp    80105fe9 <alltraps>

8010671e <vector30>:
8010671e:	6a 00                	push   $0x0
80106720:	6a 1e                	push   $0x1e
80106722:	e9 c2 f8 ff ff       	jmp    80105fe9 <alltraps>

80106727 <vector31>:
80106727:	6a 00                	push   $0x0
80106729:	6a 1f                	push   $0x1f
8010672b:	e9 b9 f8 ff ff       	jmp    80105fe9 <alltraps>

80106730 <vector32>:
80106730:	6a 00                	push   $0x0
80106732:	6a 20                	push   $0x20
80106734:	e9 b0 f8 ff ff       	jmp    80105fe9 <alltraps>

80106739 <vector33>:
80106739:	6a 00                	push   $0x0
8010673b:	6a 21                	push   $0x21
8010673d:	e9 a7 f8 ff ff       	jmp    80105fe9 <alltraps>

80106742 <vector34>:
80106742:	6a 00                	push   $0x0
80106744:	6a 22                	push   $0x22
80106746:	e9 9e f8 ff ff       	jmp    80105fe9 <alltraps>

8010674b <vector35>:
8010674b:	6a 00                	push   $0x0
8010674d:	6a 23                	push   $0x23
8010674f:	e9 95 f8 ff ff       	jmp    80105fe9 <alltraps>

80106754 <vector36>:
80106754:	6a 00                	push   $0x0
80106756:	6a 24                	push   $0x24
80106758:	e9 8c f8 ff ff       	jmp    80105fe9 <alltraps>

8010675d <vector37>:
8010675d:	6a 00                	push   $0x0
8010675f:	6a 25                	push   $0x25
80106761:	e9 83 f8 ff ff       	jmp    80105fe9 <alltraps>

80106766 <vector38>:
80106766:	6a 00                	push   $0x0
80106768:	6a 26                	push   $0x26
8010676a:	e9 7a f8 ff ff       	jmp    80105fe9 <alltraps>

8010676f <vector39>:
8010676f:	6a 00                	push   $0x0
80106771:	6a 27                	push   $0x27
80106773:	e9 71 f8 ff ff       	jmp    80105fe9 <alltraps>

80106778 <vector40>:
80106778:	6a 00                	push   $0x0
8010677a:	6a 28                	push   $0x28
8010677c:	e9 68 f8 ff ff       	jmp    80105fe9 <alltraps>

80106781 <vector41>:
80106781:	6a 00                	push   $0x0
80106783:	6a 29                	push   $0x29
80106785:	e9 5f f8 ff ff       	jmp    80105fe9 <alltraps>

8010678a <vector42>:
8010678a:	6a 00                	push   $0x0
8010678c:	6a 2a                	push   $0x2a
8010678e:	e9 56 f8 ff ff       	jmp    80105fe9 <alltraps>

80106793 <vector43>:
80106793:	6a 00                	push   $0x0
80106795:	6a 2b                	push   $0x2b
80106797:	e9 4d f8 ff ff       	jmp    80105fe9 <alltraps>

8010679c <vector44>:
8010679c:	6a 00                	push   $0x0
8010679e:	6a 2c                	push   $0x2c
801067a0:	e9 44 f8 ff ff       	jmp    80105fe9 <alltraps>

801067a5 <vector45>:
801067a5:	6a 00                	push   $0x0
801067a7:	6a 2d                	push   $0x2d
801067a9:	e9 3b f8 ff ff       	jmp    80105fe9 <alltraps>

801067ae <vector46>:
801067ae:	6a 00                	push   $0x0
801067b0:	6a 2e                	push   $0x2e
801067b2:	e9 32 f8 ff ff       	jmp    80105fe9 <alltraps>

801067b7 <vector47>:
801067b7:	6a 00                	push   $0x0
801067b9:	6a 2f                	push   $0x2f
801067bb:	e9 29 f8 ff ff       	jmp    80105fe9 <alltraps>

801067c0 <vector48>:
801067c0:	6a 00                	push   $0x0
801067c2:	6a 30                	push   $0x30
801067c4:	e9 20 f8 ff ff       	jmp    80105fe9 <alltraps>

801067c9 <vector49>:
801067c9:	6a 00                	push   $0x0
801067cb:	6a 31                	push   $0x31
801067cd:	e9 17 f8 ff ff       	jmp    80105fe9 <alltraps>

801067d2 <vector50>:
801067d2:	6a 00                	push   $0x0
801067d4:	6a 32                	push   $0x32
801067d6:	e9 0e f8 ff ff       	jmp    80105fe9 <alltraps>

801067db <vector51>:
801067db:	6a 00                	push   $0x0
801067dd:	6a 33                	push   $0x33
801067df:	e9 05 f8 ff ff       	jmp    80105fe9 <alltraps>

801067e4 <vector52>:
801067e4:	6a 00                	push   $0x0
801067e6:	6a 34                	push   $0x34
801067e8:	e9 fc f7 ff ff       	jmp    80105fe9 <alltraps>

801067ed <vector53>:
801067ed:	6a 00                	push   $0x0
801067ef:	6a 35                	push   $0x35
801067f1:	e9 f3 f7 ff ff       	jmp    80105fe9 <alltraps>

801067f6 <vector54>:
801067f6:	6a 00                	push   $0x0
801067f8:	6a 36                	push   $0x36
801067fa:	e9 ea f7 ff ff       	jmp    80105fe9 <alltraps>

801067ff <vector55>:
801067ff:	6a 00                	push   $0x0
80106801:	6a 37                	push   $0x37
80106803:	e9 e1 f7 ff ff       	jmp    80105fe9 <alltraps>

80106808 <vector56>:
80106808:	6a 00                	push   $0x0
8010680a:	6a 38                	push   $0x38
8010680c:	e9 d8 f7 ff ff       	jmp    80105fe9 <alltraps>

80106811 <vector57>:
80106811:	6a 00                	push   $0x0
80106813:	6a 39                	push   $0x39
80106815:	e9 cf f7 ff ff       	jmp    80105fe9 <alltraps>

8010681a <vector58>:
8010681a:	6a 00                	push   $0x0
8010681c:	6a 3a                	push   $0x3a
8010681e:	e9 c6 f7 ff ff       	jmp    80105fe9 <alltraps>

80106823 <vector59>:
80106823:	6a 00                	push   $0x0
80106825:	6a 3b                	push   $0x3b
80106827:	e9 bd f7 ff ff       	jmp    80105fe9 <alltraps>

8010682c <vector60>:
8010682c:	6a 00                	push   $0x0
8010682e:	6a 3c                	push   $0x3c
80106830:	e9 b4 f7 ff ff       	jmp    80105fe9 <alltraps>

80106835 <vector61>:
80106835:	6a 00                	push   $0x0
80106837:	6a 3d                	push   $0x3d
80106839:	e9 ab f7 ff ff       	jmp    80105fe9 <alltraps>

8010683e <vector62>:
8010683e:	6a 00                	push   $0x0
80106840:	6a 3e                	push   $0x3e
80106842:	e9 a2 f7 ff ff       	jmp    80105fe9 <alltraps>

80106847 <vector63>:
80106847:	6a 00                	push   $0x0
80106849:	6a 3f                	push   $0x3f
8010684b:	e9 99 f7 ff ff       	jmp    80105fe9 <alltraps>

80106850 <vector64>:
80106850:	6a 00                	push   $0x0
80106852:	6a 40                	push   $0x40
80106854:	e9 90 f7 ff ff       	jmp    80105fe9 <alltraps>

80106859 <vector65>:
80106859:	6a 00                	push   $0x0
8010685b:	6a 41                	push   $0x41
8010685d:	e9 87 f7 ff ff       	jmp    80105fe9 <alltraps>

80106862 <vector66>:
80106862:	6a 00                	push   $0x0
80106864:	6a 42                	push   $0x42
80106866:	e9 7e f7 ff ff       	jmp    80105fe9 <alltraps>

8010686b <vector67>:
8010686b:	6a 00                	push   $0x0
8010686d:	6a 43                	push   $0x43
8010686f:	e9 75 f7 ff ff       	jmp    80105fe9 <alltraps>

80106874 <vector68>:
80106874:	6a 00                	push   $0x0
80106876:	6a 44                	push   $0x44
80106878:	e9 6c f7 ff ff       	jmp    80105fe9 <alltraps>

8010687d <vector69>:
8010687d:	6a 00                	push   $0x0
8010687f:	6a 45                	push   $0x45
80106881:	e9 63 f7 ff ff       	jmp    80105fe9 <alltraps>

80106886 <vector70>:
80106886:	6a 00                	push   $0x0
80106888:	6a 46                	push   $0x46
8010688a:	e9 5a f7 ff ff       	jmp    80105fe9 <alltraps>

8010688f <vector71>:
8010688f:	6a 00                	push   $0x0
80106891:	6a 47                	push   $0x47
80106893:	e9 51 f7 ff ff       	jmp    80105fe9 <alltraps>

80106898 <vector72>:
80106898:	6a 00                	push   $0x0
8010689a:	6a 48                	push   $0x48
8010689c:	e9 48 f7 ff ff       	jmp    80105fe9 <alltraps>

801068a1 <vector73>:
801068a1:	6a 00                	push   $0x0
801068a3:	6a 49                	push   $0x49
801068a5:	e9 3f f7 ff ff       	jmp    80105fe9 <alltraps>

801068aa <vector74>:
801068aa:	6a 00                	push   $0x0
801068ac:	6a 4a                	push   $0x4a
801068ae:	e9 36 f7 ff ff       	jmp    80105fe9 <alltraps>

801068b3 <vector75>:
801068b3:	6a 00                	push   $0x0
801068b5:	6a 4b                	push   $0x4b
801068b7:	e9 2d f7 ff ff       	jmp    80105fe9 <alltraps>

801068bc <vector76>:
801068bc:	6a 00                	push   $0x0
801068be:	6a 4c                	push   $0x4c
801068c0:	e9 24 f7 ff ff       	jmp    80105fe9 <alltraps>

801068c5 <vector77>:
801068c5:	6a 00                	push   $0x0
801068c7:	6a 4d                	push   $0x4d
801068c9:	e9 1b f7 ff ff       	jmp    80105fe9 <alltraps>

801068ce <vector78>:
801068ce:	6a 00                	push   $0x0
801068d0:	6a 4e                	push   $0x4e
801068d2:	e9 12 f7 ff ff       	jmp    80105fe9 <alltraps>

801068d7 <vector79>:
801068d7:	6a 00                	push   $0x0
801068d9:	6a 4f                	push   $0x4f
801068db:	e9 09 f7 ff ff       	jmp    80105fe9 <alltraps>

801068e0 <vector80>:
801068e0:	6a 00                	push   $0x0
801068e2:	6a 50                	push   $0x50
801068e4:	e9 00 f7 ff ff       	jmp    80105fe9 <alltraps>

801068e9 <vector81>:
801068e9:	6a 00                	push   $0x0
801068eb:	6a 51                	push   $0x51
801068ed:	e9 f7 f6 ff ff       	jmp    80105fe9 <alltraps>

801068f2 <vector82>:
801068f2:	6a 00                	push   $0x0
801068f4:	6a 52                	push   $0x52
801068f6:	e9 ee f6 ff ff       	jmp    80105fe9 <alltraps>

801068fb <vector83>:
801068fb:	6a 00                	push   $0x0
801068fd:	6a 53                	push   $0x53
801068ff:	e9 e5 f6 ff ff       	jmp    80105fe9 <alltraps>

80106904 <vector84>:
80106904:	6a 00                	push   $0x0
80106906:	6a 54                	push   $0x54
80106908:	e9 dc f6 ff ff       	jmp    80105fe9 <alltraps>

8010690d <vector85>:
8010690d:	6a 00                	push   $0x0
8010690f:	6a 55                	push   $0x55
80106911:	e9 d3 f6 ff ff       	jmp    80105fe9 <alltraps>

80106916 <vector86>:
80106916:	6a 00                	push   $0x0
80106918:	6a 56                	push   $0x56
8010691a:	e9 ca f6 ff ff       	jmp    80105fe9 <alltraps>

8010691f <vector87>:
8010691f:	6a 00                	push   $0x0
80106921:	6a 57                	push   $0x57
80106923:	e9 c1 f6 ff ff       	jmp    80105fe9 <alltraps>

80106928 <vector88>:
80106928:	6a 00                	push   $0x0
8010692a:	6a 58                	push   $0x58
8010692c:	e9 b8 f6 ff ff       	jmp    80105fe9 <alltraps>

80106931 <vector89>:
80106931:	6a 00                	push   $0x0
80106933:	6a 59                	push   $0x59
80106935:	e9 af f6 ff ff       	jmp    80105fe9 <alltraps>

8010693a <vector90>:
8010693a:	6a 00                	push   $0x0
8010693c:	6a 5a                	push   $0x5a
8010693e:	e9 a6 f6 ff ff       	jmp    80105fe9 <alltraps>

80106943 <vector91>:
80106943:	6a 00                	push   $0x0
80106945:	6a 5b                	push   $0x5b
80106947:	e9 9d f6 ff ff       	jmp    80105fe9 <alltraps>

8010694c <vector92>:
8010694c:	6a 00                	push   $0x0
8010694e:	6a 5c                	push   $0x5c
80106950:	e9 94 f6 ff ff       	jmp    80105fe9 <alltraps>

80106955 <vector93>:
80106955:	6a 00                	push   $0x0
80106957:	6a 5d                	push   $0x5d
80106959:	e9 8b f6 ff ff       	jmp    80105fe9 <alltraps>

8010695e <vector94>:
8010695e:	6a 00                	push   $0x0
80106960:	6a 5e                	push   $0x5e
80106962:	e9 82 f6 ff ff       	jmp    80105fe9 <alltraps>

80106967 <vector95>:
80106967:	6a 00                	push   $0x0
80106969:	6a 5f                	push   $0x5f
8010696b:	e9 79 f6 ff ff       	jmp    80105fe9 <alltraps>

80106970 <vector96>:
80106970:	6a 00                	push   $0x0
80106972:	6a 60                	push   $0x60
80106974:	e9 70 f6 ff ff       	jmp    80105fe9 <alltraps>

80106979 <vector97>:
80106979:	6a 00                	push   $0x0
8010697b:	6a 61                	push   $0x61
8010697d:	e9 67 f6 ff ff       	jmp    80105fe9 <alltraps>

80106982 <vector98>:
80106982:	6a 00                	push   $0x0
80106984:	6a 62                	push   $0x62
80106986:	e9 5e f6 ff ff       	jmp    80105fe9 <alltraps>

8010698b <vector99>:
8010698b:	6a 00                	push   $0x0
8010698d:	6a 63                	push   $0x63
8010698f:	e9 55 f6 ff ff       	jmp    80105fe9 <alltraps>

80106994 <vector100>:
80106994:	6a 00                	push   $0x0
80106996:	6a 64                	push   $0x64
80106998:	e9 4c f6 ff ff       	jmp    80105fe9 <alltraps>

8010699d <vector101>:
8010699d:	6a 00                	push   $0x0
8010699f:	6a 65                	push   $0x65
801069a1:	e9 43 f6 ff ff       	jmp    80105fe9 <alltraps>

801069a6 <vector102>:
801069a6:	6a 00                	push   $0x0
801069a8:	6a 66                	push   $0x66
801069aa:	e9 3a f6 ff ff       	jmp    80105fe9 <alltraps>

801069af <vector103>:
801069af:	6a 00                	push   $0x0
801069b1:	6a 67                	push   $0x67
801069b3:	e9 31 f6 ff ff       	jmp    80105fe9 <alltraps>

801069b8 <vector104>:
801069b8:	6a 00                	push   $0x0
801069ba:	6a 68                	push   $0x68
801069bc:	e9 28 f6 ff ff       	jmp    80105fe9 <alltraps>

801069c1 <vector105>:
801069c1:	6a 00                	push   $0x0
801069c3:	6a 69                	push   $0x69
801069c5:	e9 1f f6 ff ff       	jmp    80105fe9 <alltraps>

801069ca <vector106>:
801069ca:	6a 00                	push   $0x0
801069cc:	6a 6a                	push   $0x6a
801069ce:	e9 16 f6 ff ff       	jmp    80105fe9 <alltraps>

801069d3 <vector107>:
801069d3:	6a 00                	push   $0x0
801069d5:	6a 6b                	push   $0x6b
801069d7:	e9 0d f6 ff ff       	jmp    80105fe9 <alltraps>

801069dc <vector108>:
801069dc:	6a 00                	push   $0x0
801069de:	6a 6c                	push   $0x6c
801069e0:	e9 04 f6 ff ff       	jmp    80105fe9 <alltraps>

801069e5 <vector109>:
801069e5:	6a 00                	push   $0x0
801069e7:	6a 6d                	push   $0x6d
801069e9:	e9 fb f5 ff ff       	jmp    80105fe9 <alltraps>

801069ee <vector110>:
801069ee:	6a 00                	push   $0x0
801069f0:	6a 6e                	push   $0x6e
801069f2:	e9 f2 f5 ff ff       	jmp    80105fe9 <alltraps>

801069f7 <vector111>:
801069f7:	6a 00                	push   $0x0
801069f9:	6a 6f                	push   $0x6f
801069fb:	e9 e9 f5 ff ff       	jmp    80105fe9 <alltraps>

80106a00 <vector112>:
80106a00:	6a 00                	push   $0x0
80106a02:	6a 70                	push   $0x70
80106a04:	e9 e0 f5 ff ff       	jmp    80105fe9 <alltraps>

80106a09 <vector113>:
80106a09:	6a 00                	push   $0x0
80106a0b:	6a 71                	push   $0x71
80106a0d:	e9 d7 f5 ff ff       	jmp    80105fe9 <alltraps>

80106a12 <vector114>:
80106a12:	6a 00                	push   $0x0
80106a14:	6a 72                	push   $0x72
80106a16:	e9 ce f5 ff ff       	jmp    80105fe9 <alltraps>

80106a1b <vector115>:
80106a1b:	6a 00                	push   $0x0
80106a1d:	6a 73                	push   $0x73
80106a1f:	e9 c5 f5 ff ff       	jmp    80105fe9 <alltraps>

80106a24 <vector116>:
80106a24:	6a 00                	push   $0x0
80106a26:	6a 74                	push   $0x74
80106a28:	e9 bc f5 ff ff       	jmp    80105fe9 <alltraps>

80106a2d <vector117>:
80106a2d:	6a 00                	push   $0x0
80106a2f:	6a 75                	push   $0x75
80106a31:	e9 b3 f5 ff ff       	jmp    80105fe9 <alltraps>

80106a36 <vector118>:
80106a36:	6a 00                	push   $0x0
80106a38:	6a 76                	push   $0x76
80106a3a:	e9 aa f5 ff ff       	jmp    80105fe9 <alltraps>

80106a3f <vector119>:
80106a3f:	6a 00                	push   $0x0
80106a41:	6a 77                	push   $0x77
80106a43:	e9 a1 f5 ff ff       	jmp    80105fe9 <alltraps>

80106a48 <vector120>:
80106a48:	6a 00                	push   $0x0
80106a4a:	6a 78                	push   $0x78
80106a4c:	e9 98 f5 ff ff       	jmp    80105fe9 <alltraps>

80106a51 <vector121>:
80106a51:	6a 00                	push   $0x0
80106a53:	6a 79                	push   $0x79
80106a55:	e9 8f f5 ff ff       	jmp    80105fe9 <alltraps>

80106a5a <vector122>:
80106a5a:	6a 00                	push   $0x0
80106a5c:	6a 7a                	push   $0x7a
80106a5e:	e9 86 f5 ff ff       	jmp    80105fe9 <alltraps>

80106a63 <vector123>:
80106a63:	6a 00                	push   $0x0
80106a65:	6a 7b                	push   $0x7b
80106a67:	e9 7d f5 ff ff       	jmp    80105fe9 <alltraps>

80106a6c <vector124>:
80106a6c:	6a 00                	push   $0x0
80106a6e:	6a 7c                	push   $0x7c
80106a70:	e9 74 f5 ff ff       	jmp    80105fe9 <alltraps>

80106a75 <vector125>:
80106a75:	6a 00                	push   $0x0
80106a77:	6a 7d                	push   $0x7d
80106a79:	e9 6b f5 ff ff       	jmp    80105fe9 <alltraps>

80106a7e <vector126>:
80106a7e:	6a 00                	push   $0x0
80106a80:	6a 7e                	push   $0x7e
80106a82:	e9 62 f5 ff ff       	jmp    80105fe9 <alltraps>

80106a87 <vector127>:
80106a87:	6a 00                	push   $0x0
80106a89:	6a 7f                	push   $0x7f
80106a8b:	e9 59 f5 ff ff       	jmp    80105fe9 <alltraps>

80106a90 <vector128>:
80106a90:	6a 00                	push   $0x0
80106a92:	68 80 00 00 00       	push   $0x80
80106a97:	e9 4d f5 ff ff       	jmp    80105fe9 <alltraps>

80106a9c <vector129>:
80106a9c:	6a 00                	push   $0x0
80106a9e:	68 81 00 00 00       	push   $0x81
80106aa3:	e9 41 f5 ff ff       	jmp    80105fe9 <alltraps>

80106aa8 <vector130>:
80106aa8:	6a 00                	push   $0x0
80106aaa:	68 82 00 00 00       	push   $0x82
80106aaf:	e9 35 f5 ff ff       	jmp    80105fe9 <alltraps>

80106ab4 <vector131>:
80106ab4:	6a 00                	push   $0x0
80106ab6:	68 83 00 00 00       	push   $0x83
80106abb:	e9 29 f5 ff ff       	jmp    80105fe9 <alltraps>

80106ac0 <vector132>:
80106ac0:	6a 00                	push   $0x0
80106ac2:	68 84 00 00 00       	push   $0x84
80106ac7:	e9 1d f5 ff ff       	jmp    80105fe9 <alltraps>

80106acc <vector133>:
80106acc:	6a 00                	push   $0x0
80106ace:	68 85 00 00 00       	push   $0x85
80106ad3:	e9 11 f5 ff ff       	jmp    80105fe9 <alltraps>

80106ad8 <vector134>:
80106ad8:	6a 00                	push   $0x0
80106ada:	68 86 00 00 00       	push   $0x86
80106adf:	e9 05 f5 ff ff       	jmp    80105fe9 <alltraps>

80106ae4 <vector135>:
80106ae4:	6a 00                	push   $0x0
80106ae6:	68 87 00 00 00       	push   $0x87
80106aeb:	e9 f9 f4 ff ff       	jmp    80105fe9 <alltraps>

80106af0 <vector136>:
80106af0:	6a 00                	push   $0x0
80106af2:	68 88 00 00 00       	push   $0x88
80106af7:	e9 ed f4 ff ff       	jmp    80105fe9 <alltraps>

80106afc <vector137>:
80106afc:	6a 00                	push   $0x0
80106afe:	68 89 00 00 00       	push   $0x89
80106b03:	e9 e1 f4 ff ff       	jmp    80105fe9 <alltraps>

80106b08 <vector138>:
80106b08:	6a 00                	push   $0x0
80106b0a:	68 8a 00 00 00       	push   $0x8a
80106b0f:	e9 d5 f4 ff ff       	jmp    80105fe9 <alltraps>

80106b14 <vector139>:
80106b14:	6a 00                	push   $0x0
80106b16:	68 8b 00 00 00       	push   $0x8b
80106b1b:	e9 c9 f4 ff ff       	jmp    80105fe9 <alltraps>

80106b20 <vector140>:
80106b20:	6a 00                	push   $0x0
80106b22:	68 8c 00 00 00       	push   $0x8c
80106b27:	e9 bd f4 ff ff       	jmp    80105fe9 <alltraps>

80106b2c <vector141>:
80106b2c:	6a 00                	push   $0x0
80106b2e:	68 8d 00 00 00       	push   $0x8d
80106b33:	e9 b1 f4 ff ff       	jmp    80105fe9 <alltraps>

80106b38 <vector142>:
80106b38:	6a 00                	push   $0x0
80106b3a:	68 8e 00 00 00       	push   $0x8e
80106b3f:	e9 a5 f4 ff ff       	jmp    80105fe9 <alltraps>

80106b44 <vector143>:
80106b44:	6a 00                	push   $0x0
80106b46:	68 8f 00 00 00       	push   $0x8f
80106b4b:	e9 99 f4 ff ff       	jmp    80105fe9 <alltraps>

80106b50 <vector144>:
80106b50:	6a 00                	push   $0x0
80106b52:	68 90 00 00 00       	push   $0x90
80106b57:	e9 8d f4 ff ff       	jmp    80105fe9 <alltraps>

80106b5c <vector145>:
80106b5c:	6a 00                	push   $0x0
80106b5e:	68 91 00 00 00       	push   $0x91
80106b63:	e9 81 f4 ff ff       	jmp    80105fe9 <alltraps>

80106b68 <vector146>:
80106b68:	6a 00                	push   $0x0
80106b6a:	68 92 00 00 00       	push   $0x92
80106b6f:	e9 75 f4 ff ff       	jmp    80105fe9 <alltraps>

80106b74 <vector147>:
80106b74:	6a 00                	push   $0x0
80106b76:	68 93 00 00 00       	push   $0x93
80106b7b:	e9 69 f4 ff ff       	jmp    80105fe9 <alltraps>

80106b80 <vector148>:
80106b80:	6a 00                	push   $0x0
80106b82:	68 94 00 00 00       	push   $0x94
80106b87:	e9 5d f4 ff ff       	jmp    80105fe9 <alltraps>

80106b8c <vector149>:
80106b8c:	6a 00                	push   $0x0
80106b8e:	68 95 00 00 00       	push   $0x95
80106b93:	e9 51 f4 ff ff       	jmp    80105fe9 <alltraps>

80106b98 <vector150>:
80106b98:	6a 00                	push   $0x0
80106b9a:	68 96 00 00 00       	push   $0x96
80106b9f:	e9 45 f4 ff ff       	jmp    80105fe9 <alltraps>

80106ba4 <vector151>:
80106ba4:	6a 00                	push   $0x0
80106ba6:	68 97 00 00 00       	push   $0x97
80106bab:	e9 39 f4 ff ff       	jmp    80105fe9 <alltraps>

80106bb0 <vector152>:
80106bb0:	6a 00                	push   $0x0
80106bb2:	68 98 00 00 00       	push   $0x98
80106bb7:	e9 2d f4 ff ff       	jmp    80105fe9 <alltraps>

80106bbc <vector153>:
80106bbc:	6a 00                	push   $0x0
80106bbe:	68 99 00 00 00       	push   $0x99
80106bc3:	e9 21 f4 ff ff       	jmp    80105fe9 <alltraps>

80106bc8 <vector154>:
80106bc8:	6a 00                	push   $0x0
80106bca:	68 9a 00 00 00       	push   $0x9a
80106bcf:	e9 15 f4 ff ff       	jmp    80105fe9 <alltraps>

80106bd4 <vector155>:
80106bd4:	6a 00                	push   $0x0
80106bd6:	68 9b 00 00 00       	push   $0x9b
80106bdb:	e9 09 f4 ff ff       	jmp    80105fe9 <alltraps>

80106be0 <vector156>:
80106be0:	6a 00                	push   $0x0
80106be2:	68 9c 00 00 00       	push   $0x9c
80106be7:	e9 fd f3 ff ff       	jmp    80105fe9 <alltraps>

80106bec <vector157>:
80106bec:	6a 00                	push   $0x0
80106bee:	68 9d 00 00 00       	push   $0x9d
80106bf3:	e9 f1 f3 ff ff       	jmp    80105fe9 <alltraps>

80106bf8 <vector158>:
80106bf8:	6a 00                	push   $0x0
80106bfa:	68 9e 00 00 00       	push   $0x9e
80106bff:	e9 e5 f3 ff ff       	jmp    80105fe9 <alltraps>

80106c04 <vector159>:
80106c04:	6a 00                	push   $0x0
80106c06:	68 9f 00 00 00       	push   $0x9f
80106c0b:	e9 d9 f3 ff ff       	jmp    80105fe9 <alltraps>

80106c10 <vector160>:
80106c10:	6a 00                	push   $0x0
80106c12:	68 a0 00 00 00       	push   $0xa0
80106c17:	e9 cd f3 ff ff       	jmp    80105fe9 <alltraps>

80106c1c <vector161>:
80106c1c:	6a 00                	push   $0x0
80106c1e:	68 a1 00 00 00       	push   $0xa1
80106c23:	e9 c1 f3 ff ff       	jmp    80105fe9 <alltraps>

80106c28 <vector162>:
80106c28:	6a 00                	push   $0x0
80106c2a:	68 a2 00 00 00       	push   $0xa2
80106c2f:	e9 b5 f3 ff ff       	jmp    80105fe9 <alltraps>

80106c34 <vector163>:
80106c34:	6a 00                	push   $0x0
80106c36:	68 a3 00 00 00       	push   $0xa3
80106c3b:	e9 a9 f3 ff ff       	jmp    80105fe9 <alltraps>

80106c40 <vector164>:
80106c40:	6a 00                	push   $0x0
80106c42:	68 a4 00 00 00       	push   $0xa4
80106c47:	e9 9d f3 ff ff       	jmp    80105fe9 <alltraps>

80106c4c <vector165>:
80106c4c:	6a 00                	push   $0x0
80106c4e:	68 a5 00 00 00       	push   $0xa5
80106c53:	e9 91 f3 ff ff       	jmp    80105fe9 <alltraps>

80106c58 <vector166>:
80106c58:	6a 00                	push   $0x0
80106c5a:	68 a6 00 00 00       	push   $0xa6
80106c5f:	e9 85 f3 ff ff       	jmp    80105fe9 <alltraps>

80106c64 <vector167>:
80106c64:	6a 00                	push   $0x0
80106c66:	68 a7 00 00 00       	push   $0xa7
80106c6b:	e9 79 f3 ff ff       	jmp    80105fe9 <alltraps>

80106c70 <vector168>:
80106c70:	6a 00                	push   $0x0
80106c72:	68 a8 00 00 00       	push   $0xa8
80106c77:	e9 6d f3 ff ff       	jmp    80105fe9 <alltraps>

80106c7c <vector169>:
80106c7c:	6a 00                	push   $0x0
80106c7e:	68 a9 00 00 00       	push   $0xa9
80106c83:	e9 61 f3 ff ff       	jmp    80105fe9 <alltraps>

80106c88 <vector170>:
80106c88:	6a 00                	push   $0x0
80106c8a:	68 aa 00 00 00       	push   $0xaa
80106c8f:	e9 55 f3 ff ff       	jmp    80105fe9 <alltraps>

80106c94 <vector171>:
80106c94:	6a 00                	push   $0x0
80106c96:	68 ab 00 00 00       	push   $0xab
80106c9b:	e9 49 f3 ff ff       	jmp    80105fe9 <alltraps>

80106ca0 <vector172>:
80106ca0:	6a 00                	push   $0x0
80106ca2:	68 ac 00 00 00       	push   $0xac
80106ca7:	e9 3d f3 ff ff       	jmp    80105fe9 <alltraps>

80106cac <vector173>:
80106cac:	6a 00                	push   $0x0
80106cae:	68 ad 00 00 00       	push   $0xad
80106cb3:	e9 31 f3 ff ff       	jmp    80105fe9 <alltraps>

80106cb8 <vector174>:
80106cb8:	6a 00                	push   $0x0
80106cba:	68 ae 00 00 00       	push   $0xae
80106cbf:	e9 25 f3 ff ff       	jmp    80105fe9 <alltraps>

80106cc4 <vector175>:
80106cc4:	6a 00                	push   $0x0
80106cc6:	68 af 00 00 00       	push   $0xaf
80106ccb:	e9 19 f3 ff ff       	jmp    80105fe9 <alltraps>

80106cd0 <vector176>:
80106cd0:	6a 00                	push   $0x0
80106cd2:	68 b0 00 00 00       	push   $0xb0
80106cd7:	e9 0d f3 ff ff       	jmp    80105fe9 <alltraps>

80106cdc <vector177>:
80106cdc:	6a 00                	push   $0x0
80106cde:	68 b1 00 00 00       	push   $0xb1
80106ce3:	e9 01 f3 ff ff       	jmp    80105fe9 <alltraps>

80106ce8 <vector178>:
80106ce8:	6a 00                	push   $0x0
80106cea:	68 b2 00 00 00       	push   $0xb2
80106cef:	e9 f5 f2 ff ff       	jmp    80105fe9 <alltraps>

80106cf4 <vector179>:
80106cf4:	6a 00                	push   $0x0
80106cf6:	68 b3 00 00 00       	push   $0xb3
80106cfb:	e9 e9 f2 ff ff       	jmp    80105fe9 <alltraps>

80106d00 <vector180>:
80106d00:	6a 00                	push   $0x0
80106d02:	68 b4 00 00 00       	push   $0xb4
80106d07:	e9 dd f2 ff ff       	jmp    80105fe9 <alltraps>

80106d0c <vector181>:
80106d0c:	6a 00                	push   $0x0
80106d0e:	68 b5 00 00 00       	push   $0xb5
80106d13:	e9 d1 f2 ff ff       	jmp    80105fe9 <alltraps>

80106d18 <vector182>:
80106d18:	6a 00                	push   $0x0
80106d1a:	68 b6 00 00 00       	push   $0xb6
80106d1f:	e9 c5 f2 ff ff       	jmp    80105fe9 <alltraps>

80106d24 <vector183>:
80106d24:	6a 00                	push   $0x0
80106d26:	68 b7 00 00 00       	push   $0xb7
80106d2b:	e9 b9 f2 ff ff       	jmp    80105fe9 <alltraps>

80106d30 <vector184>:
80106d30:	6a 00                	push   $0x0
80106d32:	68 b8 00 00 00       	push   $0xb8
80106d37:	e9 ad f2 ff ff       	jmp    80105fe9 <alltraps>

80106d3c <vector185>:
80106d3c:	6a 00                	push   $0x0
80106d3e:	68 b9 00 00 00       	push   $0xb9
80106d43:	e9 a1 f2 ff ff       	jmp    80105fe9 <alltraps>

80106d48 <vector186>:
80106d48:	6a 00                	push   $0x0
80106d4a:	68 ba 00 00 00       	push   $0xba
80106d4f:	e9 95 f2 ff ff       	jmp    80105fe9 <alltraps>

80106d54 <vector187>:
80106d54:	6a 00                	push   $0x0
80106d56:	68 bb 00 00 00       	push   $0xbb
80106d5b:	e9 89 f2 ff ff       	jmp    80105fe9 <alltraps>

80106d60 <vector188>:
80106d60:	6a 00                	push   $0x0
80106d62:	68 bc 00 00 00       	push   $0xbc
80106d67:	e9 7d f2 ff ff       	jmp    80105fe9 <alltraps>

80106d6c <vector189>:
80106d6c:	6a 00                	push   $0x0
80106d6e:	68 bd 00 00 00       	push   $0xbd
80106d73:	e9 71 f2 ff ff       	jmp    80105fe9 <alltraps>

80106d78 <vector190>:
80106d78:	6a 00                	push   $0x0
80106d7a:	68 be 00 00 00       	push   $0xbe
80106d7f:	e9 65 f2 ff ff       	jmp    80105fe9 <alltraps>

80106d84 <vector191>:
80106d84:	6a 00                	push   $0x0
80106d86:	68 bf 00 00 00       	push   $0xbf
80106d8b:	e9 59 f2 ff ff       	jmp    80105fe9 <alltraps>

80106d90 <vector192>:
80106d90:	6a 00                	push   $0x0
80106d92:	68 c0 00 00 00       	push   $0xc0
80106d97:	e9 4d f2 ff ff       	jmp    80105fe9 <alltraps>

80106d9c <vector193>:
80106d9c:	6a 00                	push   $0x0
80106d9e:	68 c1 00 00 00       	push   $0xc1
80106da3:	e9 41 f2 ff ff       	jmp    80105fe9 <alltraps>

80106da8 <vector194>:
80106da8:	6a 00                	push   $0x0
80106daa:	68 c2 00 00 00       	push   $0xc2
80106daf:	e9 35 f2 ff ff       	jmp    80105fe9 <alltraps>

80106db4 <vector195>:
80106db4:	6a 00                	push   $0x0
80106db6:	68 c3 00 00 00       	push   $0xc3
80106dbb:	e9 29 f2 ff ff       	jmp    80105fe9 <alltraps>

80106dc0 <vector196>:
80106dc0:	6a 00                	push   $0x0
80106dc2:	68 c4 00 00 00       	push   $0xc4
80106dc7:	e9 1d f2 ff ff       	jmp    80105fe9 <alltraps>

80106dcc <vector197>:
80106dcc:	6a 00                	push   $0x0
80106dce:	68 c5 00 00 00       	push   $0xc5
80106dd3:	e9 11 f2 ff ff       	jmp    80105fe9 <alltraps>

80106dd8 <vector198>:
80106dd8:	6a 00                	push   $0x0
80106dda:	68 c6 00 00 00       	push   $0xc6
80106ddf:	e9 05 f2 ff ff       	jmp    80105fe9 <alltraps>

80106de4 <vector199>:
80106de4:	6a 00                	push   $0x0
80106de6:	68 c7 00 00 00       	push   $0xc7
80106deb:	e9 f9 f1 ff ff       	jmp    80105fe9 <alltraps>

80106df0 <vector200>:
80106df0:	6a 00                	push   $0x0
80106df2:	68 c8 00 00 00       	push   $0xc8
80106df7:	e9 ed f1 ff ff       	jmp    80105fe9 <alltraps>

80106dfc <vector201>:
80106dfc:	6a 00                	push   $0x0
80106dfe:	68 c9 00 00 00       	push   $0xc9
80106e03:	e9 e1 f1 ff ff       	jmp    80105fe9 <alltraps>

80106e08 <vector202>:
80106e08:	6a 00                	push   $0x0
80106e0a:	68 ca 00 00 00       	push   $0xca
80106e0f:	e9 d5 f1 ff ff       	jmp    80105fe9 <alltraps>

80106e14 <vector203>:
80106e14:	6a 00                	push   $0x0
80106e16:	68 cb 00 00 00       	push   $0xcb
80106e1b:	e9 c9 f1 ff ff       	jmp    80105fe9 <alltraps>

80106e20 <vector204>:
80106e20:	6a 00                	push   $0x0
80106e22:	68 cc 00 00 00       	push   $0xcc
80106e27:	e9 bd f1 ff ff       	jmp    80105fe9 <alltraps>

80106e2c <vector205>:
80106e2c:	6a 00                	push   $0x0
80106e2e:	68 cd 00 00 00       	push   $0xcd
80106e33:	e9 b1 f1 ff ff       	jmp    80105fe9 <alltraps>

80106e38 <vector206>:
80106e38:	6a 00                	push   $0x0
80106e3a:	68 ce 00 00 00       	push   $0xce
80106e3f:	e9 a5 f1 ff ff       	jmp    80105fe9 <alltraps>

80106e44 <vector207>:
80106e44:	6a 00                	push   $0x0
80106e46:	68 cf 00 00 00       	push   $0xcf
80106e4b:	e9 99 f1 ff ff       	jmp    80105fe9 <alltraps>

80106e50 <vector208>:
80106e50:	6a 00                	push   $0x0
80106e52:	68 d0 00 00 00       	push   $0xd0
80106e57:	e9 8d f1 ff ff       	jmp    80105fe9 <alltraps>

80106e5c <vector209>:
80106e5c:	6a 00                	push   $0x0
80106e5e:	68 d1 00 00 00       	push   $0xd1
80106e63:	e9 81 f1 ff ff       	jmp    80105fe9 <alltraps>

80106e68 <vector210>:
80106e68:	6a 00                	push   $0x0
80106e6a:	68 d2 00 00 00       	push   $0xd2
80106e6f:	e9 75 f1 ff ff       	jmp    80105fe9 <alltraps>

80106e74 <vector211>:
80106e74:	6a 00                	push   $0x0
80106e76:	68 d3 00 00 00       	push   $0xd3
80106e7b:	e9 69 f1 ff ff       	jmp    80105fe9 <alltraps>

80106e80 <vector212>:
80106e80:	6a 00                	push   $0x0
80106e82:	68 d4 00 00 00       	push   $0xd4
80106e87:	e9 5d f1 ff ff       	jmp    80105fe9 <alltraps>

80106e8c <vector213>:
80106e8c:	6a 00                	push   $0x0
80106e8e:	68 d5 00 00 00       	push   $0xd5
80106e93:	e9 51 f1 ff ff       	jmp    80105fe9 <alltraps>

80106e98 <vector214>:
80106e98:	6a 00                	push   $0x0
80106e9a:	68 d6 00 00 00       	push   $0xd6
80106e9f:	e9 45 f1 ff ff       	jmp    80105fe9 <alltraps>

80106ea4 <vector215>:
80106ea4:	6a 00                	push   $0x0
80106ea6:	68 d7 00 00 00       	push   $0xd7
80106eab:	e9 39 f1 ff ff       	jmp    80105fe9 <alltraps>

80106eb0 <vector216>:
80106eb0:	6a 00                	push   $0x0
80106eb2:	68 d8 00 00 00       	push   $0xd8
80106eb7:	e9 2d f1 ff ff       	jmp    80105fe9 <alltraps>

80106ebc <vector217>:
80106ebc:	6a 00                	push   $0x0
80106ebe:	68 d9 00 00 00       	push   $0xd9
80106ec3:	e9 21 f1 ff ff       	jmp    80105fe9 <alltraps>

80106ec8 <vector218>:
80106ec8:	6a 00                	push   $0x0
80106eca:	68 da 00 00 00       	push   $0xda
80106ecf:	e9 15 f1 ff ff       	jmp    80105fe9 <alltraps>

80106ed4 <vector219>:
80106ed4:	6a 00                	push   $0x0
80106ed6:	68 db 00 00 00       	push   $0xdb
80106edb:	e9 09 f1 ff ff       	jmp    80105fe9 <alltraps>

80106ee0 <vector220>:
80106ee0:	6a 00                	push   $0x0
80106ee2:	68 dc 00 00 00       	push   $0xdc
80106ee7:	e9 fd f0 ff ff       	jmp    80105fe9 <alltraps>

80106eec <vector221>:
80106eec:	6a 00                	push   $0x0
80106eee:	68 dd 00 00 00       	push   $0xdd
80106ef3:	e9 f1 f0 ff ff       	jmp    80105fe9 <alltraps>

80106ef8 <vector222>:
80106ef8:	6a 00                	push   $0x0
80106efa:	68 de 00 00 00       	push   $0xde
80106eff:	e9 e5 f0 ff ff       	jmp    80105fe9 <alltraps>

80106f04 <vector223>:
80106f04:	6a 00                	push   $0x0
80106f06:	68 df 00 00 00       	push   $0xdf
80106f0b:	e9 d9 f0 ff ff       	jmp    80105fe9 <alltraps>

80106f10 <vector224>:
80106f10:	6a 00                	push   $0x0
80106f12:	68 e0 00 00 00       	push   $0xe0
80106f17:	e9 cd f0 ff ff       	jmp    80105fe9 <alltraps>

80106f1c <vector225>:
80106f1c:	6a 00                	push   $0x0
80106f1e:	68 e1 00 00 00       	push   $0xe1
80106f23:	e9 c1 f0 ff ff       	jmp    80105fe9 <alltraps>

80106f28 <vector226>:
80106f28:	6a 00                	push   $0x0
80106f2a:	68 e2 00 00 00       	push   $0xe2
80106f2f:	e9 b5 f0 ff ff       	jmp    80105fe9 <alltraps>

80106f34 <vector227>:
80106f34:	6a 00                	push   $0x0
80106f36:	68 e3 00 00 00       	push   $0xe3
80106f3b:	e9 a9 f0 ff ff       	jmp    80105fe9 <alltraps>

80106f40 <vector228>:
80106f40:	6a 00                	push   $0x0
80106f42:	68 e4 00 00 00       	push   $0xe4
80106f47:	e9 9d f0 ff ff       	jmp    80105fe9 <alltraps>

80106f4c <vector229>:
80106f4c:	6a 00                	push   $0x0
80106f4e:	68 e5 00 00 00       	push   $0xe5
80106f53:	e9 91 f0 ff ff       	jmp    80105fe9 <alltraps>

80106f58 <vector230>:
80106f58:	6a 00                	push   $0x0
80106f5a:	68 e6 00 00 00       	push   $0xe6
80106f5f:	e9 85 f0 ff ff       	jmp    80105fe9 <alltraps>

80106f64 <vector231>:
80106f64:	6a 00                	push   $0x0
80106f66:	68 e7 00 00 00       	push   $0xe7
80106f6b:	e9 79 f0 ff ff       	jmp    80105fe9 <alltraps>

80106f70 <vector232>:
80106f70:	6a 00                	push   $0x0
80106f72:	68 e8 00 00 00       	push   $0xe8
80106f77:	e9 6d f0 ff ff       	jmp    80105fe9 <alltraps>

80106f7c <vector233>:
80106f7c:	6a 00                	push   $0x0
80106f7e:	68 e9 00 00 00       	push   $0xe9
80106f83:	e9 61 f0 ff ff       	jmp    80105fe9 <alltraps>

80106f88 <vector234>:
80106f88:	6a 00                	push   $0x0
80106f8a:	68 ea 00 00 00       	push   $0xea
80106f8f:	e9 55 f0 ff ff       	jmp    80105fe9 <alltraps>

80106f94 <vector235>:
80106f94:	6a 00                	push   $0x0
80106f96:	68 eb 00 00 00       	push   $0xeb
80106f9b:	e9 49 f0 ff ff       	jmp    80105fe9 <alltraps>

80106fa0 <vector236>:
80106fa0:	6a 00                	push   $0x0
80106fa2:	68 ec 00 00 00       	push   $0xec
80106fa7:	e9 3d f0 ff ff       	jmp    80105fe9 <alltraps>

80106fac <vector237>:
80106fac:	6a 00                	push   $0x0
80106fae:	68 ed 00 00 00       	push   $0xed
80106fb3:	e9 31 f0 ff ff       	jmp    80105fe9 <alltraps>

80106fb8 <vector238>:
80106fb8:	6a 00                	push   $0x0
80106fba:	68 ee 00 00 00       	push   $0xee
80106fbf:	e9 25 f0 ff ff       	jmp    80105fe9 <alltraps>

80106fc4 <vector239>:
80106fc4:	6a 00                	push   $0x0
80106fc6:	68 ef 00 00 00       	push   $0xef
80106fcb:	e9 19 f0 ff ff       	jmp    80105fe9 <alltraps>

80106fd0 <vector240>:
80106fd0:	6a 00                	push   $0x0
80106fd2:	68 f0 00 00 00       	push   $0xf0
80106fd7:	e9 0d f0 ff ff       	jmp    80105fe9 <alltraps>

80106fdc <vector241>:
80106fdc:	6a 00                	push   $0x0
80106fde:	68 f1 00 00 00       	push   $0xf1
80106fe3:	e9 01 f0 ff ff       	jmp    80105fe9 <alltraps>

80106fe8 <vector242>:
80106fe8:	6a 00                	push   $0x0
80106fea:	68 f2 00 00 00       	push   $0xf2
80106fef:	e9 f5 ef ff ff       	jmp    80105fe9 <alltraps>

80106ff4 <vector243>:
80106ff4:	6a 00                	push   $0x0
80106ff6:	68 f3 00 00 00       	push   $0xf3
80106ffb:	e9 e9 ef ff ff       	jmp    80105fe9 <alltraps>

80107000 <vector244>:
80107000:	6a 00                	push   $0x0
80107002:	68 f4 00 00 00       	push   $0xf4
80107007:	e9 dd ef ff ff       	jmp    80105fe9 <alltraps>

8010700c <vector245>:
8010700c:	6a 00                	push   $0x0
8010700e:	68 f5 00 00 00       	push   $0xf5
80107013:	e9 d1 ef ff ff       	jmp    80105fe9 <alltraps>

80107018 <vector246>:
80107018:	6a 00                	push   $0x0
8010701a:	68 f6 00 00 00       	push   $0xf6
8010701f:	e9 c5 ef ff ff       	jmp    80105fe9 <alltraps>

80107024 <vector247>:
80107024:	6a 00                	push   $0x0
80107026:	68 f7 00 00 00       	push   $0xf7
8010702b:	e9 b9 ef ff ff       	jmp    80105fe9 <alltraps>

80107030 <vector248>:
80107030:	6a 00                	push   $0x0
80107032:	68 f8 00 00 00       	push   $0xf8
80107037:	e9 ad ef ff ff       	jmp    80105fe9 <alltraps>

8010703c <vector249>:
8010703c:	6a 00                	push   $0x0
8010703e:	68 f9 00 00 00       	push   $0xf9
80107043:	e9 a1 ef ff ff       	jmp    80105fe9 <alltraps>

80107048 <vector250>:
80107048:	6a 00                	push   $0x0
8010704a:	68 fa 00 00 00       	push   $0xfa
8010704f:	e9 95 ef ff ff       	jmp    80105fe9 <alltraps>

80107054 <vector251>:
80107054:	6a 00                	push   $0x0
80107056:	68 fb 00 00 00       	push   $0xfb
8010705b:	e9 89 ef ff ff       	jmp    80105fe9 <alltraps>

80107060 <vector252>:
80107060:	6a 00                	push   $0x0
80107062:	68 fc 00 00 00       	push   $0xfc
80107067:	e9 7d ef ff ff       	jmp    80105fe9 <alltraps>

8010706c <vector253>:
8010706c:	6a 00                	push   $0x0
8010706e:	68 fd 00 00 00       	push   $0xfd
80107073:	e9 71 ef ff ff       	jmp    80105fe9 <alltraps>

80107078 <vector254>:
80107078:	6a 00                	push   $0x0
8010707a:	68 fe 00 00 00       	push   $0xfe
8010707f:	e9 65 ef ff ff       	jmp    80105fe9 <alltraps>

80107084 <vector255>:
80107084:	6a 00                	push   $0x0
80107086:	68 ff 00 00 00       	push   $0xff
8010708b:	e9 59 ef ff ff       	jmp    80105fe9 <alltraps>

80107090 <lgdt>:
{
80107090:	55                   	push   %ebp
80107091:	89 e5                	mov    %esp,%ebp
80107093:	83 ec 10             	sub    $0x10,%esp
  pd[0] = size-1;
80107096:	8b 45 0c             	mov    0xc(%ebp),%eax
80107099:	83 e8 01             	sub    $0x1,%eax
8010709c:	66 89 45 fa          	mov    %ax,-0x6(%ebp)
  pd[1] = (uint)p;
801070a0:	8b 45 08             	mov    0x8(%ebp),%eax
801070a3:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  pd[2] = (uint)p >> 16;
801070a7:	8b 45 08             	mov    0x8(%ebp),%eax
801070aa:	c1 e8 10             	shr    $0x10,%eax
801070ad:	66 89 45 fe          	mov    %ax,-0x2(%ebp)
  asm volatile("lgdt (%0)" : : "r" (pd));
801070b1:	8d 45 fa             	lea    -0x6(%ebp),%eax
801070b4:	0f 01 10             	lgdtl  (%eax)
}
801070b7:	90                   	nop
801070b8:	c9                   	leave  
801070b9:	c3                   	ret    

801070ba <ltr>:
{
801070ba:	55                   	push   %ebp
801070bb:	89 e5                	mov    %esp,%ebp
801070bd:	83 ec 04             	sub    $0x4,%esp
801070c0:	8b 45 08             	mov    0x8(%ebp),%eax
801070c3:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  asm volatile("ltr %0" : : "r" (sel));
801070c7:	0f b7 45 fc          	movzwl -0x4(%ebp),%eax
801070cb:	0f 00 d8             	ltr    %ax
}
801070ce:	90                   	nop
801070cf:	c9                   	leave  
801070d0:	c3                   	ret    

801070d1 <lcr3>:

static inline void
lcr3(uint val)
{
801070d1:	55                   	push   %ebp
801070d2:	89 e5                	mov    %esp,%ebp
  asm volatile("movl %0,%%cr3" : : "r" (val));
801070d4:	8b 45 08             	mov    0x8(%ebp),%eax
801070d7:	0f 22 d8             	mov    %eax,%cr3
}
801070da:	90                   	nop
801070db:	5d                   	pop    %ebp
801070dc:	c3                   	ret    

801070dd <seginit>:
extern struct gpu gpu;
// Set up CPU's kernel segment descriptors.
// Run once on entry on each CPU.
void
seginit(void)
{
801070dd:	55                   	push   %ebp
801070de:	89 e5                	mov    %esp,%ebp
801070e0:	83 ec 18             	sub    $0x18,%esp

  // Map "logical" addresses to virtual addresses using identity map.
  // Cannot share a CODE descriptor for both kernel and user
  // because it would have to have DPL_USR, but the CPU forbids
  // an interrupt from CPL=0 to DPL=3.
  c = &cpus[cpuid()];
801070e3:	e8 b5 c8 ff ff       	call   8010399d <cpuid>
801070e8:	69 c0 b0 00 00 00    	imul   $0xb0,%eax,%eax
801070ee:	05 80 6b 19 80       	add    $0x80196b80,%eax
801070f3:	89 45 f4             	mov    %eax,-0xc(%ebp)

  c->gdt[SEG_KCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, 0);
801070f6:	8b 45 f4             	mov    -0xc(%ebp),%eax
801070f9:	66 c7 40 78 ff ff    	movw   $0xffff,0x78(%eax)
801070ff:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107102:	66 c7 40 7a 00 00    	movw   $0x0,0x7a(%eax)
80107108:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010710b:	c6 40 7c 00          	movb   $0x0,0x7c(%eax)
8010710f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107112:	0f b6 50 7d          	movzbl 0x7d(%eax),%edx
80107116:	83 e2 f0             	and    $0xfffffff0,%edx
80107119:	83 ca 0a             	or     $0xa,%edx
8010711c:	88 50 7d             	mov    %dl,0x7d(%eax)
8010711f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107122:	0f b6 50 7d          	movzbl 0x7d(%eax),%edx
80107126:	83 ca 10             	or     $0x10,%edx
80107129:	88 50 7d             	mov    %dl,0x7d(%eax)
8010712c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010712f:	0f b6 50 7d          	movzbl 0x7d(%eax),%edx
80107133:	83 e2 9f             	and    $0xffffff9f,%edx
80107136:	88 50 7d             	mov    %dl,0x7d(%eax)
80107139:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010713c:	0f b6 50 7d          	movzbl 0x7d(%eax),%edx
80107140:	83 ca 80             	or     $0xffffff80,%edx
80107143:	88 50 7d             	mov    %dl,0x7d(%eax)
80107146:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107149:	0f b6 50 7e          	movzbl 0x7e(%eax),%edx
8010714d:	83 ca 0f             	or     $0xf,%edx
80107150:	88 50 7e             	mov    %dl,0x7e(%eax)
80107153:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107156:	0f b6 50 7e          	movzbl 0x7e(%eax),%edx
8010715a:	83 e2 ef             	and    $0xffffffef,%edx
8010715d:	88 50 7e             	mov    %dl,0x7e(%eax)
80107160:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107163:	0f b6 50 7e          	movzbl 0x7e(%eax),%edx
80107167:	83 e2 df             	and    $0xffffffdf,%edx
8010716a:	88 50 7e             	mov    %dl,0x7e(%eax)
8010716d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107170:	0f b6 50 7e          	movzbl 0x7e(%eax),%edx
80107174:	83 ca 40             	or     $0x40,%edx
80107177:	88 50 7e             	mov    %dl,0x7e(%eax)
8010717a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010717d:	0f b6 50 7e          	movzbl 0x7e(%eax),%edx
80107181:	83 ca 80             	or     $0xffffff80,%edx
80107184:	88 50 7e             	mov    %dl,0x7e(%eax)
80107187:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010718a:	c6 40 7f 00          	movb   $0x0,0x7f(%eax)
  c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
8010718e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107191:	66 c7 80 80 00 00 00 	movw   $0xffff,0x80(%eax)
80107198:	ff ff 
8010719a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010719d:	66 c7 80 82 00 00 00 	movw   $0x0,0x82(%eax)
801071a4:	00 00 
801071a6:	8b 45 f4             	mov    -0xc(%ebp),%eax
801071a9:	c6 80 84 00 00 00 00 	movb   $0x0,0x84(%eax)
801071b0:	8b 45 f4             	mov    -0xc(%ebp),%eax
801071b3:	0f b6 90 85 00 00 00 	movzbl 0x85(%eax),%edx
801071ba:	83 e2 f0             	and    $0xfffffff0,%edx
801071bd:	83 ca 02             	or     $0x2,%edx
801071c0:	88 90 85 00 00 00    	mov    %dl,0x85(%eax)
801071c6:	8b 45 f4             	mov    -0xc(%ebp),%eax
801071c9:	0f b6 90 85 00 00 00 	movzbl 0x85(%eax),%edx
801071d0:	83 ca 10             	or     $0x10,%edx
801071d3:	88 90 85 00 00 00    	mov    %dl,0x85(%eax)
801071d9:	8b 45 f4             	mov    -0xc(%ebp),%eax
801071dc:	0f b6 90 85 00 00 00 	movzbl 0x85(%eax),%edx
801071e3:	83 e2 9f             	and    $0xffffff9f,%edx
801071e6:	88 90 85 00 00 00    	mov    %dl,0x85(%eax)
801071ec:	8b 45 f4             	mov    -0xc(%ebp),%eax
801071ef:	0f b6 90 85 00 00 00 	movzbl 0x85(%eax),%edx
801071f6:	83 ca 80             	or     $0xffffff80,%edx
801071f9:	88 90 85 00 00 00    	mov    %dl,0x85(%eax)
801071ff:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107202:	0f b6 90 86 00 00 00 	movzbl 0x86(%eax),%edx
80107209:	83 ca 0f             	or     $0xf,%edx
8010720c:	88 90 86 00 00 00    	mov    %dl,0x86(%eax)
80107212:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107215:	0f b6 90 86 00 00 00 	movzbl 0x86(%eax),%edx
8010721c:	83 e2 ef             	and    $0xffffffef,%edx
8010721f:	88 90 86 00 00 00    	mov    %dl,0x86(%eax)
80107225:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107228:	0f b6 90 86 00 00 00 	movzbl 0x86(%eax),%edx
8010722f:	83 e2 df             	and    $0xffffffdf,%edx
80107232:	88 90 86 00 00 00    	mov    %dl,0x86(%eax)
80107238:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010723b:	0f b6 90 86 00 00 00 	movzbl 0x86(%eax),%edx
80107242:	83 ca 40             	or     $0x40,%edx
80107245:	88 90 86 00 00 00    	mov    %dl,0x86(%eax)
8010724b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010724e:	0f b6 90 86 00 00 00 	movzbl 0x86(%eax),%edx
80107255:	83 ca 80             	or     $0xffffff80,%edx
80107258:	88 90 86 00 00 00    	mov    %dl,0x86(%eax)
8010725e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107261:	c6 80 87 00 00 00 00 	movb   $0x0,0x87(%eax)
  c->gdt[SEG_UCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, DPL_USER);
80107268:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010726b:	66 c7 80 88 00 00 00 	movw   $0xffff,0x88(%eax)
80107272:	ff ff 
80107274:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107277:	66 c7 80 8a 00 00 00 	movw   $0x0,0x8a(%eax)
8010727e:	00 00 
80107280:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107283:	c6 80 8c 00 00 00 00 	movb   $0x0,0x8c(%eax)
8010728a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010728d:	0f b6 90 8d 00 00 00 	movzbl 0x8d(%eax),%edx
80107294:	83 e2 f0             	and    $0xfffffff0,%edx
80107297:	83 ca 0a             	or     $0xa,%edx
8010729a:	88 90 8d 00 00 00    	mov    %dl,0x8d(%eax)
801072a0:	8b 45 f4             	mov    -0xc(%ebp),%eax
801072a3:	0f b6 90 8d 00 00 00 	movzbl 0x8d(%eax),%edx
801072aa:	83 ca 10             	or     $0x10,%edx
801072ad:	88 90 8d 00 00 00    	mov    %dl,0x8d(%eax)
801072b3:	8b 45 f4             	mov    -0xc(%ebp),%eax
801072b6:	0f b6 90 8d 00 00 00 	movzbl 0x8d(%eax),%edx
801072bd:	83 ca 60             	or     $0x60,%edx
801072c0:	88 90 8d 00 00 00    	mov    %dl,0x8d(%eax)
801072c6:	8b 45 f4             	mov    -0xc(%ebp),%eax
801072c9:	0f b6 90 8d 00 00 00 	movzbl 0x8d(%eax),%edx
801072d0:	83 ca 80             	or     $0xffffff80,%edx
801072d3:	88 90 8d 00 00 00    	mov    %dl,0x8d(%eax)
801072d9:	8b 45 f4             	mov    -0xc(%ebp),%eax
801072dc:	0f b6 90 8e 00 00 00 	movzbl 0x8e(%eax),%edx
801072e3:	83 ca 0f             	or     $0xf,%edx
801072e6:	88 90 8e 00 00 00    	mov    %dl,0x8e(%eax)
801072ec:	8b 45 f4             	mov    -0xc(%ebp),%eax
801072ef:	0f b6 90 8e 00 00 00 	movzbl 0x8e(%eax),%edx
801072f6:	83 e2 ef             	and    $0xffffffef,%edx
801072f9:	88 90 8e 00 00 00    	mov    %dl,0x8e(%eax)
801072ff:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107302:	0f b6 90 8e 00 00 00 	movzbl 0x8e(%eax),%edx
80107309:	83 e2 df             	and    $0xffffffdf,%edx
8010730c:	88 90 8e 00 00 00    	mov    %dl,0x8e(%eax)
80107312:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107315:	0f b6 90 8e 00 00 00 	movzbl 0x8e(%eax),%edx
8010731c:	83 ca 40             	or     $0x40,%edx
8010731f:	88 90 8e 00 00 00    	mov    %dl,0x8e(%eax)
80107325:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107328:	0f b6 90 8e 00 00 00 	movzbl 0x8e(%eax),%edx
8010732f:	83 ca 80             	or     $0xffffff80,%edx
80107332:	88 90 8e 00 00 00    	mov    %dl,0x8e(%eax)
80107338:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010733b:	c6 80 8f 00 00 00 00 	movb   $0x0,0x8f(%eax)
  c->gdt[SEG_UDATA] = SEG(STA_W, 0, 0xffffffff, DPL_USER);
80107342:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107345:	66 c7 80 90 00 00 00 	movw   $0xffff,0x90(%eax)
8010734c:	ff ff 
8010734e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107351:	66 c7 80 92 00 00 00 	movw   $0x0,0x92(%eax)
80107358:	00 00 
8010735a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010735d:	c6 80 94 00 00 00 00 	movb   $0x0,0x94(%eax)
80107364:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107367:	0f b6 90 95 00 00 00 	movzbl 0x95(%eax),%edx
8010736e:	83 e2 f0             	and    $0xfffffff0,%edx
80107371:	83 ca 02             	or     $0x2,%edx
80107374:	88 90 95 00 00 00    	mov    %dl,0x95(%eax)
8010737a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010737d:	0f b6 90 95 00 00 00 	movzbl 0x95(%eax),%edx
80107384:	83 ca 10             	or     $0x10,%edx
80107387:	88 90 95 00 00 00    	mov    %dl,0x95(%eax)
8010738d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107390:	0f b6 90 95 00 00 00 	movzbl 0x95(%eax),%edx
80107397:	83 ca 60             	or     $0x60,%edx
8010739a:	88 90 95 00 00 00    	mov    %dl,0x95(%eax)
801073a0:	8b 45 f4             	mov    -0xc(%ebp),%eax
801073a3:	0f b6 90 95 00 00 00 	movzbl 0x95(%eax),%edx
801073aa:	83 ca 80             	or     $0xffffff80,%edx
801073ad:	88 90 95 00 00 00    	mov    %dl,0x95(%eax)
801073b3:	8b 45 f4             	mov    -0xc(%ebp),%eax
801073b6:	0f b6 90 96 00 00 00 	movzbl 0x96(%eax),%edx
801073bd:	83 ca 0f             	or     $0xf,%edx
801073c0:	88 90 96 00 00 00    	mov    %dl,0x96(%eax)
801073c6:	8b 45 f4             	mov    -0xc(%ebp),%eax
801073c9:	0f b6 90 96 00 00 00 	movzbl 0x96(%eax),%edx
801073d0:	83 e2 ef             	and    $0xffffffef,%edx
801073d3:	88 90 96 00 00 00    	mov    %dl,0x96(%eax)
801073d9:	8b 45 f4             	mov    -0xc(%ebp),%eax
801073dc:	0f b6 90 96 00 00 00 	movzbl 0x96(%eax),%edx
801073e3:	83 e2 df             	and    $0xffffffdf,%edx
801073e6:	88 90 96 00 00 00    	mov    %dl,0x96(%eax)
801073ec:	8b 45 f4             	mov    -0xc(%ebp),%eax
801073ef:	0f b6 90 96 00 00 00 	movzbl 0x96(%eax),%edx
801073f6:	83 ca 40             	or     $0x40,%edx
801073f9:	88 90 96 00 00 00    	mov    %dl,0x96(%eax)
801073ff:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107402:	0f b6 90 96 00 00 00 	movzbl 0x96(%eax),%edx
80107409:	83 ca 80             	or     $0xffffff80,%edx
8010740c:	88 90 96 00 00 00    	mov    %dl,0x96(%eax)
80107412:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107415:	c6 80 97 00 00 00 00 	movb   $0x0,0x97(%eax)
  lgdt(c->gdt, sizeof(c->gdt));
8010741c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010741f:	83 c0 70             	add    $0x70,%eax
80107422:	83 ec 08             	sub    $0x8,%esp
80107425:	6a 30                	push   $0x30
80107427:	50                   	push   %eax
80107428:	e8 63 fc ff ff       	call   80107090 <lgdt>
8010742d:	83 c4 10             	add    $0x10,%esp
}
80107430:	90                   	nop
80107431:	c9                   	leave  
80107432:	c3                   	ret    

80107433 <walkpgdir>:
// Return the address of the PTE in page table pgdir
// that corresponds to virtual address va.  If alloc!=0,
// create any required page table pages.
static pte_t *
walkpgdir(pde_t *pgdir, const void *va, int alloc)
{
80107433:	55                   	push   %ebp
80107434:	89 e5                	mov    %esp,%ebp
80107436:	83 ec 18             	sub    $0x18,%esp
  pde_t *pde;
  pte_t *pgtab;

  pde = &pgdir[PDX(va)];
80107439:	8b 45 0c             	mov    0xc(%ebp),%eax
8010743c:	c1 e8 16             	shr    $0x16,%eax
8010743f:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80107446:	8b 45 08             	mov    0x8(%ebp),%eax
80107449:	01 d0                	add    %edx,%eax
8010744b:	89 45 f0             	mov    %eax,-0x10(%ebp)
  if(*pde & PTE_P){
8010744e:	8b 45 f0             	mov    -0x10(%ebp),%eax
80107451:	8b 00                	mov    (%eax),%eax
80107453:	83 e0 01             	and    $0x1,%eax
80107456:	85 c0                	test   %eax,%eax
80107458:	74 14                	je     8010746e <walkpgdir+0x3b>
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
8010745a:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010745d:	8b 00                	mov    (%eax),%eax
8010745f:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80107464:	05 00 00 00 80       	add    $0x80000000,%eax
80107469:	89 45 f4             	mov    %eax,-0xc(%ebp)
8010746c:	eb 42                	jmp    801074b0 <walkpgdir+0x7d>
  } else {
    if(!alloc || (pgtab = (pte_t*)kalloc()) == 0)
8010746e:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
80107472:	74 0e                	je     80107482 <walkpgdir+0x4f>
80107474:	e8 27 b3 ff ff       	call   801027a0 <kalloc>
80107479:	89 45 f4             	mov    %eax,-0xc(%ebp)
8010747c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80107480:	75 07                	jne    80107489 <walkpgdir+0x56>
      return 0;
80107482:	b8 00 00 00 00       	mov    $0x0,%eax
80107487:	eb 3e                	jmp    801074c7 <walkpgdir+0x94>
    // Make sure all those PTE_P bits are zero.
    memset(pgtab, 0, PGSIZE);
80107489:	83 ec 04             	sub    $0x4,%esp
8010748c:	68 00 10 00 00       	push   $0x1000
80107491:	6a 00                	push   $0x0
80107493:	ff 75 f4             	push   -0xc(%ebp)
80107496:	e8 68 d7 ff ff       	call   80104c03 <memset>
8010749b:	83 c4 10             	add    $0x10,%esp
    // The permissions here are overly generous, but they can
    // be further restricted by the permissions in the page table
    // entries, if necessary.
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
8010749e:	8b 45 f4             	mov    -0xc(%ebp),%eax
801074a1:	05 00 00 00 80       	add    $0x80000000,%eax
801074a6:	83 c8 07             	or     $0x7,%eax
801074a9:	89 c2                	mov    %eax,%edx
801074ab:	8b 45 f0             	mov    -0x10(%ebp),%eax
801074ae:	89 10                	mov    %edx,(%eax)
  }
  return &pgtab[PTX(va)];
801074b0:	8b 45 0c             	mov    0xc(%ebp),%eax
801074b3:	c1 e8 0c             	shr    $0xc,%eax
801074b6:	25 ff 03 00 00       	and    $0x3ff,%eax
801074bb:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
801074c2:	8b 45 f4             	mov    -0xc(%ebp),%eax
801074c5:	01 d0                	add    %edx,%eax
}
801074c7:	c9                   	leave  
801074c8:	c3                   	ret    

801074c9 <mappages>:
// Create PTEs for virtual addresses starting at va that refer to
// physical addresses starting at pa. va and size might not
// be page-aligned.
static int
mappages(pde_t *pgdir, void *va, uint size, uint pa, int perm)
{
801074c9:	55                   	push   %ebp
801074ca:	89 e5                	mov    %esp,%ebp
801074cc:	83 ec 18             	sub    $0x18,%esp
  char *a, *last;
  pte_t *pte;

  a = (char*)PGROUNDDOWN((uint)va);
801074cf:	8b 45 0c             	mov    0xc(%ebp),%eax
801074d2:	25 00 f0 ff ff       	and    $0xfffff000,%eax
801074d7:	89 45 f4             	mov    %eax,-0xc(%ebp)
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
801074da:	8b 55 0c             	mov    0xc(%ebp),%edx
801074dd:	8b 45 10             	mov    0x10(%ebp),%eax
801074e0:	01 d0                	add    %edx,%eax
801074e2:	83 e8 01             	sub    $0x1,%eax
801074e5:	25 00 f0 ff ff       	and    $0xfffff000,%eax
801074ea:	89 45 f0             	mov    %eax,-0x10(%ebp)
  for(;;){
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
801074ed:	83 ec 04             	sub    $0x4,%esp
801074f0:	6a 01                	push   $0x1
801074f2:	ff 75 f4             	push   -0xc(%ebp)
801074f5:	ff 75 08             	push   0x8(%ebp)
801074f8:	e8 36 ff ff ff       	call   80107433 <walkpgdir>
801074fd:	83 c4 10             	add    $0x10,%esp
80107500:	89 45 ec             	mov    %eax,-0x14(%ebp)
80107503:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
80107507:	75 07                	jne    80107510 <mappages+0x47>
      return -1;
80107509:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010750e:	eb 47                	jmp    80107557 <mappages+0x8e>
    if(*pte & PTE_P)
80107510:	8b 45 ec             	mov    -0x14(%ebp),%eax
80107513:	8b 00                	mov    (%eax),%eax
80107515:	83 e0 01             	and    $0x1,%eax
80107518:	85 c0                	test   %eax,%eax
8010751a:	74 0d                	je     80107529 <mappages+0x60>
      panic("remap");
8010751c:	83 ec 0c             	sub    $0xc,%esp
8010751f:	68 e8 a7 10 80       	push   $0x8010a7e8
80107524:	e8 80 90 ff ff       	call   801005a9 <panic>
    *pte = pa | perm | PTE_P;
80107529:	8b 45 18             	mov    0x18(%ebp),%eax
8010752c:	0b 45 14             	or     0x14(%ebp),%eax
8010752f:	83 c8 01             	or     $0x1,%eax
80107532:	89 c2                	mov    %eax,%edx
80107534:	8b 45 ec             	mov    -0x14(%ebp),%eax
80107537:	89 10                	mov    %edx,(%eax)
    if(a == last)
80107539:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010753c:	3b 45 f0             	cmp    -0x10(%ebp),%eax
8010753f:	74 10                	je     80107551 <mappages+0x88>
      break;
    a += PGSIZE;
80107541:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
    pa += PGSIZE;
80107548:	81 45 14 00 10 00 00 	addl   $0x1000,0x14(%ebp)
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
8010754f:	eb 9c                	jmp    801074ed <mappages+0x24>
      break;
80107551:	90                   	nop
  }
  return 0;
80107552:	b8 00 00 00 00       	mov    $0x0,%eax
}
80107557:	c9                   	leave  
80107558:	c3                   	ret    

80107559 <setupkvm>:
};

// Set up kernel part of a page table.
pde_t*
setupkvm(void)
{
80107559:	55                   	push   %ebp
8010755a:	89 e5                	mov    %esp,%ebp
8010755c:	53                   	push   %ebx
8010755d:	83 ec 24             	sub    $0x24,%esp
  pde_t *pgdir;
  struct kmap *k;
  k = kmap;
80107560:	c7 45 f4 a0 f4 10 80 	movl   $0x8010f4a0,-0xc(%ebp)
  struct kmap vram = { (void*)(DEVSPACE - gpu.vram_size),gpu.pvram_addr,gpu.pvram_addr+gpu.vram_size, PTE_W};
80107567:	8b 15 50 6e 19 80    	mov    0x80196e50,%edx
8010756d:	b8 00 00 00 fe       	mov    $0xfe000000,%eax
80107572:	29 d0                	sub    %edx,%eax
80107574:	89 45 e0             	mov    %eax,-0x20(%ebp)
80107577:	a1 48 6e 19 80       	mov    0x80196e48,%eax
8010757c:	89 45 e4             	mov    %eax,-0x1c(%ebp)
8010757f:	8b 15 48 6e 19 80    	mov    0x80196e48,%edx
80107585:	a1 50 6e 19 80       	mov    0x80196e50,%eax
8010758a:	01 d0                	add    %edx,%eax
8010758c:	89 45 e8             	mov    %eax,-0x18(%ebp)
8010758f:	c7 45 ec 02 00 00 00 	movl   $0x2,-0x14(%ebp)
  k[3] = vram;
80107596:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107599:	83 c0 30             	add    $0x30,%eax
8010759c:	8b 55 e0             	mov    -0x20(%ebp),%edx
8010759f:	89 10                	mov    %edx,(%eax)
801075a1:	8b 55 e4             	mov    -0x1c(%ebp),%edx
801075a4:	89 50 04             	mov    %edx,0x4(%eax)
801075a7:	8b 55 e8             	mov    -0x18(%ebp),%edx
801075aa:	89 50 08             	mov    %edx,0x8(%eax)
801075ad:	8b 55 ec             	mov    -0x14(%ebp),%edx
801075b0:	89 50 0c             	mov    %edx,0xc(%eax)
  if((pgdir = (pde_t*)kalloc()) == 0){
801075b3:	e8 e8 b1 ff ff       	call   801027a0 <kalloc>
801075b8:	89 45 f0             	mov    %eax,-0x10(%ebp)
801075bb:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
801075bf:	75 07                	jne    801075c8 <setupkvm+0x6f>
    return 0;
801075c1:	b8 00 00 00 00       	mov    $0x0,%eax
801075c6:	eb 78                	jmp    80107640 <setupkvm+0xe7>
  }
  memset(pgdir, 0, PGSIZE);
801075c8:	83 ec 04             	sub    $0x4,%esp
801075cb:	68 00 10 00 00       	push   $0x1000
801075d0:	6a 00                	push   $0x0
801075d2:	ff 75 f0             	push   -0x10(%ebp)
801075d5:	e8 29 d6 ff ff       	call   80104c03 <memset>
801075da:	83 c4 10             	add    $0x10,%esp
  if (P2V(PHYSTOP) > (void*)DEVSPACE)
    panic("PHYSTOP too high");
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
801075dd:	c7 45 f4 a0 f4 10 80 	movl   $0x8010f4a0,-0xc(%ebp)
801075e4:	eb 4e                	jmp    80107634 <setupkvm+0xdb>
    if(mappages(pgdir, k->virt, k->phys_end - k->phys_start,
801075e6:	8b 45 f4             	mov    -0xc(%ebp),%eax
801075e9:	8b 48 0c             	mov    0xc(%eax),%ecx
                (uint)k->phys_start, k->perm) < 0) {
801075ec:	8b 45 f4             	mov    -0xc(%ebp),%eax
801075ef:	8b 50 04             	mov    0x4(%eax),%edx
    if(mappages(pgdir, k->virt, k->phys_end - k->phys_start,
801075f2:	8b 45 f4             	mov    -0xc(%ebp),%eax
801075f5:	8b 58 08             	mov    0x8(%eax),%ebx
801075f8:	8b 45 f4             	mov    -0xc(%ebp),%eax
801075fb:	8b 40 04             	mov    0x4(%eax),%eax
801075fe:	29 c3                	sub    %eax,%ebx
80107600:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107603:	8b 00                	mov    (%eax),%eax
80107605:	83 ec 0c             	sub    $0xc,%esp
80107608:	51                   	push   %ecx
80107609:	52                   	push   %edx
8010760a:	53                   	push   %ebx
8010760b:	50                   	push   %eax
8010760c:	ff 75 f0             	push   -0x10(%ebp)
8010760f:	e8 b5 fe ff ff       	call   801074c9 <mappages>
80107614:	83 c4 20             	add    $0x20,%esp
80107617:	85 c0                	test   %eax,%eax
80107619:	79 15                	jns    80107630 <setupkvm+0xd7>
      freevm(pgdir);
8010761b:	83 ec 0c             	sub    $0xc,%esp
8010761e:	ff 75 f0             	push   -0x10(%ebp)
80107621:	e8 f5 04 00 00       	call   80107b1b <freevm>
80107626:	83 c4 10             	add    $0x10,%esp
      return 0;
80107629:	b8 00 00 00 00       	mov    $0x0,%eax
8010762e:	eb 10                	jmp    80107640 <setupkvm+0xe7>
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
80107630:	83 45 f4 10          	addl   $0x10,-0xc(%ebp)
80107634:	81 7d f4 00 f5 10 80 	cmpl   $0x8010f500,-0xc(%ebp)
8010763b:	72 a9                	jb     801075e6 <setupkvm+0x8d>
    }
  return pgdir;
8010763d:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
80107640:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80107643:	c9                   	leave  
80107644:	c3                   	ret    

80107645 <kvmalloc>:

// Allocate one page table for the machine for the kernel address
// space for scheduler processes.
void
kvmalloc(void)
{
80107645:	55                   	push   %ebp
80107646:	89 e5                	mov    %esp,%ebp
80107648:	83 ec 08             	sub    $0x8,%esp
  kpgdir = setupkvm();
8010764b:	e8 09 ff ff ff       	call   80107559 <setupkvm>
80107650:	a3 7c 6b 19 80       	mov    %eax,0x80196b7c
  switchkvm();
80107655:	e8 03 00 00 00       	call   8010765d <switchkvm>
}
8010765a:	90                   	nop
8010765b:	c9                   	leave  
8010765c:	c3                   	ret    

8010765d <switchkvm>:

// Switch h/w page table register to the kernel-only page table,
// for when no process is running.
void
switchkvm(void)
{
8010765d:	55                   	push   %ebp
8010765e:	89 e5                	mov    %esp,%ebp
  lcr3(V2P(kpgdir));   // switch to the kernel page table
80107660:	a1 7c 6b 19 80       	mov    0x80196b7c,%eax
80107665:	05 00 00 00 80       	add    $0x80000000,%eax
8010766a:	50                   	push   %eax
8010766b:	e8 61 fa ff ff       	call   801070d1 <lcr3>
80107670:	83 c4 04             	add    $0x4,%esp
}
80107673:	90                   	nop
80107674:	c9                   	leave  
80107675:	c3                   	ret    

80107676 <switchuvm>:

// Switch TSS and h/w page table to correspond to process p.
void
switchuvm(struct proc *p)
{
80107676:	55                   	push   %ebp
80107677:	89 e5                	mov    %esp,%ebp
80107679:	56                   	push   %esi
8010767a:	53                   	push   %ebx
8010767b:	83 ec 10             	sub    $0x10,%esp
  if(p == 0)
8010767e:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
80107682:	75 0d                	jne    80107691 <switchuvm+0x1b>
    panic("switchuvm: no process");
80107684:	83 ec 0c             	sub    $0xc,%esp
80107687:	68 ee a7 10 80       	push   $0x8010a7ee
8010768c:	e8 18 8f ff ff       	call   801005a9 <panic>
  if(p->kstack == 0)
80107691:	8b 45 08             	mov    0x8(%ebp),%eax
80107694:	8b 40 08             	mov    0x8(%eax),%eax
80107697:	85 c0                	test   %eax,%eax
80107699:	75 0d                	jne    801076a8 <switchuvm+0x32>
    panic("switchuvm: no kstack");
8010769b:	83 ec 0c             	sub    $0xc,%esp
8010769e:	68 04 a8 10 80       	push   $0x8010a804
801076a3:	e8 01 8f ff ff       	call   801005a9 <panic>
  if(p->pgdir == 0)
801076a8:	8b 45 08             	mov    0x8(%ebp),%eax
801076ab:	8b 40 04             	mov    0x4(%eax),%eax
801076ae:	85 c0                	test   %eax,%eax
801076b0:	75 0d                	jne    801076bf <switchuvm+0x49>
    panic("switchuvm: no pgdir");
801076b2:	83 ec 0c             	sub    $0xc,%esp
801076b5:	68 19 a8 10 80       	push   $0x8010a819
801076ba:	e8 ea 8e ff ff       	call   801005a9 <panic>

  pushcli();
801076bf:	e8 34 d4 ff ff       	call   80104af8 <pushcli>
  mycpu()->gdt[SEG_TSS] = SEG16(STS_T32A, &mycpu()->ts,
801076c4:	e8 ef c2 ff ff       	call   801039b8 <mycpu>
801076c9:	89 c3                	mov    %eax,%ebx
801076cb:	e8 e8 c2 ff ff       	call   801039b8 <mycpu>
801076d0:	83 c0 08             	add    $0x8,%eax
801076d3:	89 c6                	mov    %eax,%esi
801076d5:	e8 de c2 ff ff       	call   801039b8 <mycpu>
801076da:	83 c0 08             	add    $0x8,%eax
801076dd:	c1 e8 10             	shr    $0x10,%eax
801076e0:	88 45 f7             	mov    %al,-0x9(%ebp)
801076e3:	e8 d0 c2 ff ff       	call   801039b8 <mycpu>
801076e8:	83 c0 08             	add    $0x8,%eax
801076eb:	c1 e8 18             	shr    $0x18,%eax
801076ee:	89 c2                	mov    %eax,%edx
801076f0:	66 c7 83 98 00 00 00 	movw   $0x67,0x98(%ebx)
801076f7:	67 00 
801076f9:	66 89 b3 9a 00 00 00 	mov    %si,0x9a(%ebx)
80107700:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
80107704:	88 83 9c 00 00 00    	mov    %al,0x9c(%ebx)
8010770a:	0f b6 83 9d 00 00 00 	movzbl 0x9d(%ebx),%eax
80107711:	83 e0 f0             	and    $0xfffffff0,%eax
80107714:	83 c8 09             	or     $0x9,%eax
80107717:	88 83 9d 00 00 00    	mov    %al,0x9d(%ebx)
8010771d:	0f b6 83 9d 00 00 00 	movzbl 0x9d(%ebx),%eax
80107724:	83 c8 10             	or     $0x10,%eax
80107727:	88 83 9d 00 00 00    	mov    %al,0x9d(%ebx)
8010772d:	0f b6 83 9d 00 00 00 	movzbl 0x9d(%ebx),%eax
80107734:	83 e0 9f             	and    $0xffffff9f,%eax
80107737:	88 83 9d 00 00 00    	mov    %al,0x9d(%ebx)
8010773d:	0f b6 83 9d 00 00 00 	movzbl 0x9d(%ebx),%eax
80107744:	83 c8 80             	or     $0xffffff80,%eax
80107747:	88 83 9d 00 00 00    	mov    %al,0x9d(%ebx)
8010774d:	0f b6 83 9e 00 00 00 	movzbl 0x9e(%ebx),%eax
80107754:	83 e0 f0             	and    $0xfffffff0,%eax
80107757:	88 83 9e 00 00 00    	mov    %al,0x9e(%ebx)
8010775d:	0f b6 83 9e 00 00 00 	movzbl 0x9e(%ebx),%eax
80107764:	83 e0 ef             	and    $0xffffffef,%eax
80107767:	88 83 9e 00 00 00    	mov    %al,0x9e(%ebx)
8010776d:	0f b6 83 9e 00 00 00 	movzbl 0x9e(%ebx),%eax
80107774:	83 e0 df             	and    $0xffffffdf,%eax
80107777:	88 83 9e 00 00 00    	mov    %al,0x9e(%ebx)
8010777d:	0f b6 83 9e 00 00 00 	movzbl 0x9e(%ebx),%eax
80107784:	83 c8 40             	or     $0x40,%eax
80107787:	88 83 9e 00 00 00    	mov    %al,0x9e(%ebx)
8010778d:	0f b6 83 9e 00 00 00 	movzbl 0x9e(%ebx),%eax
80107794:	83 e0 7f             	and    $0x7f,%eax
80107797:	88 83 9e 00 00 00    	mov    %al,0x9e(%ebx)
8010779d:	88 93 9f 00 00 00    	mov    %dl,0x9f(%ebx)
                                sizeof(mycpu()->ts)-1, 0);
  mycpu()->gdt[SEG_TSS].s = 0;
801077a3:	e8 10 c2 ff ff       	call   801039b8 <mycpu>
801077a8:	0f b6 90 9d 00 00 00 	movzbl 0x9d(%eax),%edx
801077af:	83 e2 ef             	and    $0xffffffef,%edx
801077b2:	88 90 9d 00 00 00    	mov    %dl,0x9d(%eax)
  mycpu()->ts.ss0 = SEG_KDATA << 3;
801077b8:	e8 fb c1 ff ff       	call   801039b8 <mycpu>
801077bd:	66 c7 40 10 10 00    	movw   $0x10,0x10(%eax)
  mycpu()->ts.esp0 = (uint)p->kstack + KSTACKSIZE;
801077c3:	8b 45 08             	mov    0x8(%ebp),%eax
801077c6:	8b 40 08             	mov    0x8(%eax),%eax
801077c9:	89 c3                	mov    %eax,%ebx
801077cb:	e8 e8 c1 ff ff       	call   801039b8 <mycpu>
801077d0:	8d 93 00 10 00 00    	lea    0x1000(%ebx),%edx
801077d6:	89 50 0c             	mov    %edx,0xc(%eax)
  // setting IOPL=0 in eflags *and* iomb beyond the tss segment limit
  // forbids I/O instructions (e.g., inb and outb) from user space
  mycpu()->ts.iomb = (ushort) 0xFFFF;
801077d9:	e8 da c1 ff ff       	call   801039b8 <mycpu>
801077de:	66 c7 40 6e ff ff    	movw   $0xffff,0x6e(%eax)
  ltr(SEG_TSS << 3);
801077e4:	83 ec 0c             	sub    $0xc,%esp
801077e7:	6a 28                	push   $0x28
801077e9:	e8 cc f8 ff ff       	call   801070ba <ltr>
801077ee:	83 c4 10             	add    $0x10,%esp
  lcr3(V2P(p->pgdir));  // switch to process's address space
801077f1:	8b 45 08             	mov    0x8(%ebp),%eax
801077f4:	8b 40 04             	mov    0x4(%eax),%eax
801077f7:	05 00 00 00 80       	add    $0x80000000,%eax
801077fc:	83 ec 0c             	sub    $0xc,%esp
801077ff:	50                   	push   %eax
80107800:	e8 cc f8 ff ff       	call   801070d1 <lcr3>
80107805:	83 c4 10             	add    $0x10,%esp
  popcli();
80107808:	e8 38 d3 ff ff       	call   80104b45 <popcli>
}
8010780d:	90                   	nop
8010780e:	8d 65 f8             	lea    -0x8(%ebp),%esp
80107811:	5b                   	pop    %ebx
80107812:	5e                   	pop    %esi
80107813:	5d                   	pop    %ebp
80107814:	c3                   	ret    

80107815 <inituvm>:

// Load the initcode into address 0 of pgdir.
// sz must be less than a page.
void
inituvm(pde_t *pgdir, char *init, uint sz)
{
80107815:	55                   	push   %ebp
80107816:	89 e5                	mov    %esp,%ebp
80107818:	83 ec 18             	sub    $0x18,%esp
  char *mem;

  if(sz >= PGSIZE)
8010781b:	81 7d 10 ff 0f 00 00 	cmpl   $0xfff,0x10(%ebp)
80107822:	76 0d                	jbe    80107831 <inituvm+0x1c>
    panic("inituvm: more than a page");
80107824:	83 ec 0c             	sub    $0xc,%esp
80107827:	68 2d a8 10 80       	push   $0x8010a82d
8010782c:	e8 78 8d ff ff       	call   801005a9 <panic>
  mem = kalloc();
80107831:	e8 6a af ff ff       	call   801027a0 <kalloc>
80107836:	89 45 f4             	mov    %eax,-0xc(%ebp)
  memset(mem, 0, PGSIZE);
80107839:	83 ec 04             	sub    $0x4,%esp
8010783c:	68 00 10 00 00       	push   $0x1000
80107841:	6a 00                	push   $0x0
80107843:	ff 75 f4             	push   -0xc(%ebp)
80107846:	e8 b8 d3 ff ff       	call   80104c03 <memset>
8010784b:	83 c4 10             	add    $0x10,%esp
  mappages(pgdir, 0, PGSIZE, V2P(mem), PTE_W|PTE_U);
8010784e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107851:	05 00 00 00 80       	add    $0x80000000,%eax
80107856:	83 ec 0c             	sub    $0xc,%esp
80107859:	6a 06                	push   $0x6
8010785b:	50                   	push   %eax
8010785c:	68 00 10 00 00       	push   $0x1000
80107861:	6a 00                	push   $0x0
80107863:	ff 75 08             	push   0x8(%ebp)
80107866:	e8 5e fc ff ff       	call   801074c9 <mappages>
8010786b:	83 c4 20             	add    $0x20,%esp
  memmove(mem, init, sz);
8010786e:	83 ec 04             	sub    $0x4,%esp
80107871:	ff 75 10             	push   0x10(%ebp)
80107874:	ff 75 0c             	push   0xc(%ebp)
80107877:	ff 75 f4             	push   -0xc(%ebp)
8010787a:	e8 43 d4 ff ff       	call   80104cc2 <memmove>
8010787f:	83 c4 10             	add    $0x10,%esp
}
80107882:	90                   	nop
80107883:	c9                   	leave  
80107884:	c3                   	ret    

80107885 <loaduvm>:

// Load a program segment into pgdir.  addr must be page-aligned
// and the pages from addr to addr+sz must already be mapped.
int
loaduvm(pde_t *pgdir, char *addr, struct inode *ip, uint offset, uint sz)
{
80107885:	55                   	push   %ebp
80107886:	89 e5                	mov    %esp,%ebp
80107888:	83 ec 18             	sub    $0x18,%esp
  uint i, pa, n;
  pte_t *pte;

  if((uint) addr % PGSIZE != 0)
8010788b:	8b 45 0c             	mov    0xc(%ebp),%eax
8010788e:	25 ff 0f 00 00       	and    $0xfff,%eax
80107893:	85 c0                	test   %eax,%eax
80107895:	74 0d                	je     801078a4 <loaduvm+0x1f>
    panic("loaduvm: addr must be page aligned");
80107897:	83 ec 0c             	sub    $0xc,%esp
8010789a:	68 48 a8 10 80       	push   $0x8010a848
8010789f:	e8 05 8d ff ff       	call   801005a9 <panic>
  for(i = 0; i < sz; i += PGSIZE){
801078a4:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
801078ab:	e9 8f 00 00 00       	jmp    8010793f <loaduvm+0xba>
    if((pte = walkpgdir(pgdir, addr+i, 0)) == 0)
801078b0:	8b 55 0c             	mov    0xc(%ebp),%edx
801078b3:	8b 45 f4             	mov    -0xc(%ebp),%eax
801078b6:	01 d0                	add    %edx,%eax
801078b8:	83 ec 04             	sub    $0x4,%esp
801078bb:	6a 00                	push   $0x0
801078bd:	50                   	push   %eax
801078be:	ff 75 08             	push   0x8(%ebp)
801078c1:	e8 6d fb ff ff       	call   80107433 <walkpgdir>
801078c6:	83 c4 10             	add    $0x10,%esp
801078c9:	89 45 ec             	mov    %eax,-0x14(%ebp)
801078cc:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
801078d0:	75 0d                	jne    801078df <loaduvm+0x5a>
      panic("loaduvm: address should exist");
801078d2:	83 ec 0c             	sub    $0xc,%esp
801078d5:	68 6b a8 10 80       	push   $0x8010a86b
801078da:	e8 ca 8c ff ff       	call   801005a9 <panic>
    pa = PTE_ADDR(*pte);
801078df:	8b 45 ec             	mov    -0x14(%ebp),%eax
801078e2:	8b 00                	mov    (%eax),%eax
801078e4:	25 00 f0 ff ff       	and    $0xfffff000,%eax
801078e9:	89 45 e8             	mov    %eax,-0x18(%ebp)
    if(sz - i < PGSIZE)
801078ec:	8b 45 18             	mov    0x18(%ebp),%eax
801078ef:	2b 45 f4             	sub    -0xc(%ebp),%eax
801078f2:	3d ff 0f 00 00       	cmp    $0xfff,%eax
801078f7:	77 0b                	ja     80107904 <loaduvm+0x7f>
      n = sz - i;
801078f9:	8b 45 18             	mov    0x18(%ebp),%eax
801078fc:	2b 45 f4             	sub    -0xc(%ebp),%eax
801078ff:	89 45 f0             	mov    %eax,-0x10(%ebp)
80107902:	eb 07                	jmp    8010790b <loaduvm+0x86>
    else
      n = PGSIZE;
80107904:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
    if(readi(ip, P2V(pa), offset+i, n) != n)
8010790b:	8b 55 14             	mov    0x14(%ebp),%edx
8010790e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107911:	01 d0                	add    %edx,%eax
80107913:	8b 55 e8             	mov    -0x18(%ebp),%edx
80107916:	81 c2 00 00 00 80    	add    $0x80000000,%edx
8010791c:	ff 75 f0             	push   -0x10(%ebp)
8010791f:	50                   	push   %eax
80107920:	52                   	push   %edx
80107921:	ff 75 10             	push   0x10(%ebp)
80107924:	e8 ad a5 ff ff       	call   80101ed6 <readi>
80107929:	83 c4 10             	add    $0x10,%esp
8010792c:	39 45 f0             	cmp    %eax,-0x10(%ebp)
8010792f:	74 07                	je     80107938 <loaduvm+0xb3>
      return -1;
80107931:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80107936:	eb 18                	jmp    80107950 <loaduvm+0xcb>
  for(i = 0; i < sz; i += PGSIZE){
80107938:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
8010793f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107942:	3b 45 18             	cmp    0x18(%ebp),%eax
80107945:	0f 82 65 ff ff ff    	jb     801078b0 <loaduvm+0x2b>
  }
  return 0;
8010794b:	b8 00 00 00 00       	mov    $0x0,%eax
}
80107950:	c9                   	leave  
80107951:	c3                   	ret    

80107952 <allocuvm>:

// Allocate page tables and physical memory to grow process from oldsz to
// newsz, which need not be page aligned.  Returns new size or 0 on error.
int
allocuvm(pde_t *pgdir, uint oldsz, uint newsz)
{
80107952:	55                   	push   %ebp
80107953:	89 e5                	mov    %esp,%ebp
80107955:	83 ec 18             	sub    $0x18,%esp
  char *mem;
  uint a;

  if(newsz >= KERNBASE)
80107958:	8b 45 10             	mov    0x10(%ebp),%eax
8010795b:	85 c0                	test   %eax,%eax
8010795d:	79 0a                	jns    80107969 <allocuvm+0x17>
    return 0;
8010795f:	b8 00 00 00 00       	mov    $0x0,%eax
80107964:	e9 ec 00 00 00       	jmp    80107a55 <allocuvm+0x103>
  if(newsz < oldsz)
80107969:	8b 45 10             	mov    0x10(%ebp),%eax
8010796c:	3b 45 0c             	cmp    0xc(%ebp),%eax
8010796f:	73 08                	jae    80107979 <allocuvm+0x27>
    return oldsz;
80107971:	8b 45 0c             	mov    0xc(%ebp),%eax
80107974:	e9 dc 00 00 00       	jmp    80107a55 <allocuvm+0x103>

  a = PGROUNDUP(oldsz);
80107979:	8b 45 0c             	mov    0xc(%ebp),%eax
8010797c:	05 ff 0f 00 00       	add    $0xfff,%eax
80107981:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80107986:	89 45 f4             	mov    %eax,-0xc(%ebp)
  for(; a < newsz; a += PGSIZE){
80107989:	e9 b8 00 00 00       	jmp    80107a46 <allocuvm+0xf4>
    mem = kalloc();
8010798e:	e8 0d ae ff ff       	call   801027a0 <kalloc>
80107993:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(mem == 0){
80107996:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
8010799a:	75 2e                	jne    801079ca <allocuvm+0x78>
      cprintf("allocuvm out of memory\n");
8010799c:	83 ec 0c             	sub    $0xc,%esp
8010799f:	68 89 a8 10 80       	push   $0x8010a889
801079a4:	e8 4b 8a ff ff       	call   801003f4 <cprintf>
801079a9:	83 c4 10             	add    $0x10,%esp
      deallocuvm(pgdir, newsz, oldsz);
801079ac:	83 ec 04             	sub    $0x4,%esp
801079af:	ff 75 0c             	push   0xc(%ebp)
801079b2:	ff 75 10             	push   0x10(%ebp)
801079b5:	ff 75 08             	push   0x8(%ebp)
801079b8:	e8 9a 00 00 00       	call   80107a57 <deallocuvm>
801079bd:	83 c4 10             	add    $0x10,%esp
      return 0;
801079c0:	b8 00 00 00 00       	mov    $0x0,%eax
801079c5:	e9 8b 00 00 00       	jmp    80107a55 <allocuvm+0x103>
    }
    memset(mem, 0, PGSIZE);
801079ca:	83 ec 04             	sub    $0x4,%esp
801079cd:	68 00 10 00 00       	push   $0x1000
801079d2:	6a 00                	push   $0x0
801079d4:	ff 75 f0             	push   -0x10(%ebp)
801079d7:	e8 27 d2 ff ff       	call   80104c03 <memset>
801079dc:	83 c4 10             	add    $0x10,%esp
    if(mappages(pgdir, (char*)a, PGSIZE, V2P(mem), PTE_W|PTE_U) < 0){
801079df:	8b 45 f0             	mov    -0x10(%ebp),%eax
801079e2:	8d 90 00 00 00 80    	lea    -0x80000000(%eax),%edx
801079e8:	8b 45 f4             	mov    -0xc(%ebp),%eax
801079eb:	83 ec 0c             	sub    $0xc,%esp
801079ee:	6a 06                	push   $0x6
801079f0:	52                   	push   %edx
801079f1:	68 00 10 00 00       	push   $0x1000
801079f6:	50                   	push   %eax
801079f7:	ff 75 08             	push   0x8(%ebp)
801079fa:	e8 ca fa ff ff       	call   801074c9 <mappages>
801079ff:	83 c4 20             	add    $0x20,%esp
80107a02:	85 c0                	test   %eax,%eax
80107a04:	79 39                	jns    80107a3f <allocuvm+0xed>
      cprintf("allocuvm out of memory (2)\n");
80107a06:	83 ec 0c             	sub    $0xc,%esp
80107a09:	68 a1 a8 10 80       	push   $0x8010a8a1
80107a0e:	e8 e1 89 ff ff       	call   801003f4 <cprintf>
80107a13:	83 c4 10             	add    $0x10,%esp
      deallocuvm(pgdir, newsz, oldsz);
80107a16:	83 ec 04             	sub    $0x4,%esp
80107a19:	ff 75 0c             	push   0xc(%ebp)
80107a1c:	ff 75 10             	push   0x10(%ebp)
80107a1f:	ff 75 08             	push   0x8(%ebp)
80107a22:	e8 30 00 00 00       	call   80107a57 <deallocuvm>
80107a27:	83 c4 10             	add    $0x10,%esp
      kfree(mem);
80107a2a:	83 ec 0c             	sub    $0xc,%esp
80107a2d:	ff 75 f0             	push   -0x10(%ebp)
80107a30:	e8 d1 ac ff ff       	call   80102706 <kfree>
80107a35:	83 c4 10             	add    $0x10,%esp
      return 0;
80107a38:	b8 00 00 00 00       	mov    $0x0,%eax
80107a3d:	eb 16                	jmp    80107a55 <allocuvm+0x103>
  for(; a < newsz; a += PGSIZE){
80107a3f:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
80107a46:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107a49:	3b 45 10             	cmp    0x10(%ebp),%eax
80107a4c:	0f 82 3c ff ff ff    	jb     8010798e <allocuvm+0x3c>
    }
  }
  return newsz;
80107a52:	8b 45 10             	mov    0x10(%ebp),%eax
}
80107a55:	c9                   	leave  
80107a56:	c3                   	ret    

80107a57 <deallocuvm>:
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
int
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
{
80107a57:	55                   	push   %ebp
80107a58:	89 e5                	mov    %esp,%ebp
80107a5a:	83 ec 18             	sub    $0x18,%esp
  pte_t *pte;
  uint a, pa;

  if(newsz >= oldsz)
80107a5d:	8b 45 10             	mov    0x10(%ebp),%eax
80107a60:	3b 45 0c             	cmp    0xc(%ebp),%eax
80107a63:	72 08                	jb     80107a6d <deallocuvm+0x16>
    return oldsz;
80107a65:	8b 45 0c             	mov    0xc(%ebp),%eax
80107a68:	e9 ac 00 00 00       	jmp    80107b19 <deallocuvm+0xc2>

  a = PGROUNDUP(newsz);
80107a6d:	8b 45 10             	mov    0x10(%ebp),%eax
80107a70:	05 ff 0f 00 00       	add    $0xfff,%eax
80107a75:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80107a7a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  for(; a  < oldsz; a += PGSIZE){
80107a7d:	e9 88 00 00 00       	jmp    80107b0a <deallocuvm+0xb3>
    pte = walkpgdir(pgdir, (char*)a, 0);
80107a82:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107a85:	83 ec 04             	sub    $0x4,%esp
80107a88:	6a 00                	push   $0x0
80107a8a:	50                   	push   %eax
80107a8b:	ff 75 08             	push   0x8(%ebp)
80107a8e:	e8 a0 f9 ff ff       	call   80107433 <walkpgdir>
80107a93:	83 c4 10             	add    $0x10,%esp
80107a96:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(!pte)
80107a99:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80107a9d:	75 16                	jne    80107ab5 <deallocuvm+0x5e>
      a = PGADDR(PDX(a) + 1, 0, 0) - PGSIZE;
80107a9f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107aa2:	c1 e8 16             	shr    $0x16,%eax
80107aa5:	83 c0 01             	add    $0x1,%eax
80107aa8:	c1 e0 16             	shl    $0x16,%eax
80107aab:	2d 00 10 00 00       	sub    $0x1000,%eax
80107ab0:	89 45 f4             	mov    %eax,-0xc(%ebp)
80107ab3:	eb 4e                	jmp    80107b03 <deallocuvm+0xac>
    else if((*pte & PTE_P) != 0){
80107ab5:	8b 45 f0             	mov    -0x10(%ebp),%eax
80107ab8:	8b 00                	mov    (%eax),%eax
80107aba:	83 e0 01             	and    $0x1,%eax
80107abd:	85 c0                	test   %eax,%eax
80107abf:	74 42                	je     80107b03 <deallocuvm+0xac>
      pa = PTE_ADDR(*pte);
80107ac1:	8b 45 f0             	mov    -0x10(%ebp),%eax
80107ac4:	8b 00                	mov    (%eax),%eax
80107ac6:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80107acb:	89 45 ec             	mov    %eax,-0x14(%ebp)
      if(pa == 0)
80107ace:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
80107ad2:	75 0d                	jne    80107ae1 <deallocuvm+0x8a>
        panic("kfree");
80107ad4:	83 ec 0c             	sub    $0xc,%esp
80107ad7:	68 bd a8 10 80       	push   $0x8010a8bd
80107adc:	e8 c8 8a ff ff       	call   801005a9 <panic>
      char *v = P2V(pa);
80107ae1:	8b 45 ec             	mov    -0x14(%ebp),%eax
80107ae4:	05 00 00 00 80       	add    $0x80000000,%eax
80107ae9:	89 45 e8             	mov    %eax,-0x18(%ebp)
      kfree(v);
80107aec:	83 ec 0c             	sub    $0xc,%esp
80107aef:	ff 75 e8             	push   -0x18(%ebp)
80107af2:	e8 0f ac ff ff       	call   80102706 <kfree>
80107af7:	83 c4 10             	add    $0x10,%esp
      *pte = 0;
80107afa:	8b 45 f0             	mov    -0x10(%ebp),%eax
80107afd:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  for(; a  < oldsz; a += PGSIZE){
80107b03:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
80107b0a:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107b0d:	3b 45 0c             	cmp    0xc(%ebp),%eax
80107b10:	0f 82 6c ff ff ff    	jb     80107a82 <deallocuvm+0x2b>
    }
  }
  return newsz;
80107b16:	8b 45 10             	mov    0x10(%ebp),%eax
}
80107b19:	c9                   	leave  
80107b1a:	c3                   	ret    

80107b1b <freevm>:

// Free a page table and all the physical memory pages
// in the user part.
void
freevm(pde_t *pgdir)
{
80107b1b:	55                   	push   %ebp
80107b1c:	89 e5                	mov    %esp,%ebp
80107b1e:	83 ec 18             	sub    $0x18,%esp
  uint i;

  if(pgdir == 0)
80107b21:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
80107b25:	75 0d                	jne    80107b34 <freevm+0x19>
    panic("freevm: no pgdir");
80107b27:	83 ec 0c             	sub    $0xc,%esp
80107b2a:	68 c3 a8 10 80       	push   $0x8010a8c3
80107b2f:	e8 75 8a ff ff       	call   801005a9 <panic>
  deallocuvm(pgdir, KERNBASE, 0);
80107b34:	83 ec 04             	sub    $0x4,%esp
80107b37:	6a 00                	push   $0x0
80107b39:	68 00 00 00 80       	push   $0x80000000
80107b3e:	ff 75 08             	push   0x8(%ebp)
80107b41:	e8 11 ff ff ff       	call   80107a57 <deallocuvm>
80107b46:	83 c4 10             	add    $0x10,%esp
  for(i = 0; i < NPDENTRIES; i++){
80107b49:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80107b50:	eb 48                	jmp    80107b9a <freevm+0x7f>
    if(pgdir[i] & PTE_P){
80107b52:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107b55:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80107b5c:	8b 45 08             	mov    0x8(%ebp),%eax
80107b5f:	01 d0                	add    %edx,%eax
80107b61:	8b 00                	mov    (%eax),%eax
80107b63:	83 e0 01             	and    $0x1,%eax
80107b66:	85 c0                	test   %eax,%eax
80107b68:	74 2c                	je     80107b96 <freevm+0x7b>
      char * v = P2V(PTE_ADDR(pgdir[i]));
80107b6a:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107b6d:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80107b74:	8b 45 08             	mov    0x8(%ebp),%eax
80107b77:	01 d0                	add    %edx,%eax
80107b79:	8b 00                	mov    (%eax),%eax
80107b7b:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80107b80:	05 00 00 00 80       	add    $0x80000000,%eax
80107b85:	89 45 f0             	mov    %eax,-0x10(%ebp)
      kfree(v);
80107b88:	83 ec 0c             	sub    $0xc,%esp
80107b8b:	ff 75 f0             	push   -0x10(%ebp)
80107b8e:	e8 73 ab ff ff       	call   80102706 <kfree>
80107b93:	83 c4 10             	add    $0x10,%esp
  for(i = 0; i < NPDENTRIES; i++){
80107b96:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80107b9a:	81 7d f4 ff 03 00 00 	cmpl   $0x3ff,-0xc(%ebp)
80107ba1:	76 af                	jbe    80107b52 <freevm+0x37>
    }
  }
  kfree((char*)pgdir);
80107ba3:	83 ec 0c             	sub    $0xc,%esp
80107ba6:	ff 75 08             	push   0x8(%ebp)
80107ba9:	e8 58 ab ff ff       	call   80102706 <kfree>
80107bae:	83 c4 10             	add    $0x10,%esp
}
80107bb1:	90                   	nop
80107bb2:	c9                   	leave  
80107bb3:	c3                   	ret    

80107bb4 <clearpteu>:

// Clear PTE_U on a page. Used to create an inaccessible
// page beneath the user stack.
void
clearpteu(pde_t *pgdir, char *uva)
{
80107bb4:	55                   	push   %ebp
80107bb5:	89 e5                	mov    %esp,%ebp
80107bb7:	83 ec 18             	sub    $0x18,%esp
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
80107bba:	83 ec 04             	sub    $0x4,%esp
80107bbd:	6a 00                	push   $0x0
80107bbf:	ff 75 0c             	push   0xc(%ebp)
80107bc2:	ff 75 08             	push   0x8(%ebp)
80107bc5:	e8 69 f8 ff ff       	call   80107433 <walkpgdir>
80107bca:	83 c4 10             	add    $0x10,%esp
80107bcd:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(pte == 0)
80107bd0:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80107bd4:	75 0d                	jne    80107be3 <clearpteu+0x2f>
    panic("clearpteu");
80107bd6:	83 ec 0c             	sub    $0xc,%esp
80107bd9:	68 d4 a8 10 80       	push   $0x8010a8d4
80107bde:	e8 c6 89 ff ff       	call   801005a9 <panic>
  *pte &= ~PTE_U;
80107be3:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107be6:	8b 00                	mov    (%eax),%eax
80107be8:	83 e0 fb             	and    $0xfffffffb,%eax
80107beb:	89 c2                	mov    %eax,%edx
80107bed:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107bf0:	89 10                	mov    %edx,(%eax)
}
80107bf2:	90                   	nop
80107bf3:	c9                   	leave  
80107bf4:	c3                   	ret    

80107bf5 <copyuvm>:

// Given a parent process's page table, create a copy
// of it for a child.
pde_t*
copyuvm(pde_t *pgdir, uint sz)
{
80107bf5:	55                   	push   %ebp
80107bf6:	89 e5                	mov    %esp,%ebp
80107bf8:	83 ec 28             	sub    $0x28,%esp
  pde_t *d;
  pte_t *pte;
  uint pa, i, flags;
  char *mem;

  if((d = setupkvm()) == 0)
80107bfb:	e8 59 f9 ff ff       	call   80107559 <setupkvm>
80107c00:	89 45 f0             	mov    %eax,-0x10(%ebp)
80107c03:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80107c07:	75 0a                	jne    80107c13 <copyuvm+0x1e>
    return 0;
80107c09:	b8 00 00 00 00       	mov    $0x0,%eax
80107c0e:	e9 eb 00 00 00       	jmp    80107cfe <copyuvm+0x109>
  for(i = 0; i < sz; i += PGSIZE){
80107c13:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80107c1a:	e9 b7 00 00 00       	jmp    80107cd6 <copyuvm+0xe1>
    if((pte = walkpgdir(pgdir, (void *) i, 0)) == 0)
80107c1f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107c22:	83 ec 04             	sub    $0x4,%esp
80107c25:	6a 00                	push   $0x0
80107c27:	50                   	push   %eax
80107c28:	ff 75 08             	push   0x8(%ebp)
80107c2b:	e8 03 f8 ff ff       	call   80107433 <walkpgdir>
80107c30:	83 c4 10             	add    $0x10,%esp
80107c33:	89 45 ec             	mov    %eax,-0x14(%ebp)
80107c36:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
80107c3a:	75 0d                	jne    80107c49 <copyuvm+0x54>
      panic("copyuvm: pte should exist");
80107c3c:	83 ec 0c             	sub    $0xc,%esp
80107c3f:	68 de a8 10 80       	push   $0x8010a8de
80107c44:	e8 60 89 ff ff       	call   801005a9 <panic>
    if(!(*pte & PTE_P))
80107c49:	8b 45 ec             	mov    -0x14(%ebp),%eax
80107c4c:	8b 00                	mov    (%eax),%eax
80107c4e:	83 e0 01             	and    $0x1,%eax
80107c51:	85 c0                	test   %eax,%eax
80107c53:	75 0d                	jne    80107c62 <copyuvm+0x6d>
      panic("copyuvm: page not present");
80107c55:	83 ec 0c             	sub    $0xc,%esp
80107c58:	68 f8 a8 10 80       	push   $0x8010a8f8
80107c5d:	e8 47 89 ff ff       	call   801005a9 <panic>
    pa = PTE_ADDR(*pte);
80107c62:	8b 45 ec             	mov    -0x14(%ebp),%eax
80107c65:	8b 00                	mov    (%eax),%eax
80107c67:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80107c6c:	89 45 e8             	mov    %eax,-0x18(%ebp)
    flags = PTE_FLAGS(*pte);
80107c6f:	8b 45 ec             	mov    -0x14(%ebp),%eax
80107c72:	8b 00                	mov    (%eax),%eax
80107c74:	25 ff 0f 00 00       	and    $0xfff,%eax
80107c79:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if((mem = kalloc()) == 0)
80107c7c:	e8 1f ab ff ff       	call   801027a0 <kalloc>
80107c81:	89 45 e0             	mov    %eax,-0x20(%ebp)
80107c84:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
80107c88:	74 5d                	je     80107ce7 <copyuvm+0xf2>
      goto bad;
    memmove(mem, (char*)P2V(pa), PGSIZE);
80107c8a:	8b 45 e8             	mov    -0x18(%ebp),%eax
80107c8d:	05 00 00 00 80       	add    $0x80000000,%eax
80107c92:	83 ec 04             	sub    $0x4,%esp
80107c95:	68 00 10 00 00       	push   $0x1000
80107c9a:	50                   	push   %eax
80107c9b:	ff 75 e0             	push   -0x20(%ebp)
80107c9e:	e8 1f d0 ff ff       	call   80104cc2 <memmove>
80107ca3:	83 c4 10             	add    $0x10,%esp
    if(mappages(d, (void*)i, PGSIZE, V2P(mem), flags) < 0)
80107ca6:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80107ca9:	8b 45 e0             	mov    -0x20(%ebp),%eax
80107cac:	8d 88 00 00 00 80    	lea    -0x80000000(%eax),%ecx
80107cb2:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107cb5:	83 ec 0c             	sub    $0xc,%esp
80107cb8:	52                   	push   %edx
80107cb9:	51                   	push   %ecx
80107cba:	68 00 10 00 00       	push   $0x1000
80107cbf:	50                   	push   %eax
80107cc0:	ff 75 f0             	push   -0x10(%ebp)
80107cc3:	e8 01 f8 ff ff       	call   801074c9 <mappages>
80107cc8:	83 c4 20             	add    $0x20,%esp
80107ccb:	85 c0                	test   %eax,%eax
80107ccd:	78 1b                	js     80107cea <copyuvm+0xf5>
  for(i = 0; i < sz; i += PGSIZE){
80107ccf:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
80107cd6:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107cd9:	3b 45 0c             	cmp    0xc(%ebp),%eax
80107cdc:	0f 82 3d ff ff ff    	jb     80107c1f <copyuvm+0x2a>
      goto bad;
  }
  return d;
80107ce2:	8b 45 f0             	mov    -0x10(%ebp),%eax
80107ce5:	eb 17                	jmp    80107cfe <copyuvm+0x109>
      goto bad;
80107ce7:	90                   	nop
80107ce8:	eb 01                	jmp    80107ceb <copyuvm+0xf6>
      goto bad;
80107cea:	90                   	nop

bad:
  freevm(d);
80107ceb:	83 ec 0c             	sub    $0xc,%esp
80107cee:	ff 75 f0             	push   -0x10(%ebp)
80107cf1:	e8 25 fe ff ff       	call   80107b1b <freevm>
80107cf6:	83 c4 10             	add    $0x10,%esp
  return 0;
80107cf9:	b8 00 00 00 00       	mov    $0x0,%eax
}
80107cfe:	c9                   	leave  
80107cff:	c3                   	ret    

80107d00 <uva2ka>:

//PAGEBREAK!
// Map user virtual address to kernel address.
char*
uva2ka(pde_t *pgdir, char *uva)
{
80107d00:	55                   	push   %ebp
80107d01:	89 e5                	mov    %esp,%ebp
80107d03:	83 ec 18             	sub    $0x18,%esp
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
80107d06:	83 ec 04             	sub    $0x4,%esp
80107d09:	6a 00                	push   $0x0
80107d0b:	ff 75 0c             	push   0xc(%ebp)
80107d0e:	ff 75 08             	push   0x8(%ebp)
80107d11:	e8 1d f7 ff ff       	call   80107433 <walkpgdir>
80107d16:	83 c4 10             	add    $0x10,%esp
80107d19:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if((*pte & PTE_P) == 0)
80107d1c:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107d1f:	8b 00                	mov    (%eax),%eax
80107d21:	83 e0 01             	and    $0x1,%eax
80107d24:	85 c0                	test   %eax,%eax
80107d26:	75 07                	jne    80107d2f <uva2ka+0x2f>
    return 0;
80107d28:	b8 00 00 00 00       	mov    $0x0,%eax
80107d2d:	eb 22                	jmp    80107d51 <uva2ka+0x51>
  if((*pte & PTE_U) == 0)
80107d2f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107d32:	8b 00                	mov    (%eax),%eax
80107d34:	83 e0 04             	and    $0x4,%eax
80107d37:	85 c0                	test   %eax,%eax
80107d39:	75 07                	jne    80107d42 <uva2ka+0x42>
    return 0;
80107d3b:	b8 00 00 00 00       	mov    $0x0,%eax
80107d40:	eb 0f                	jmp    80107d51 <uva2ka+0x51>
  return (char*)P2V(PTE_ADDR(*pte));
80107d42:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107d45:	8b 00                	mov    (%eax),%eax
80107d47:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80107d4c:	05 00 00 00 80       	add    $0x80000000,%eax
}
80107d51:	c9                   	leave  
80107d52:	c3                   	ret    

80107d53 <copyout>:
// Copy len bytes from p to user address va in page table pgdir.
// Most useful when pgdir is not the current page table.
// uva2ka ensures this only works for PTE_U pages.
int
copyout(pde_t *pgdir, uint va, void *p, uint len)
{
80107d53:	55                   	push   %ebp
80107d54:	89 e5                	mov    %esp,%ebp
80107d56:	83 ec 18             	sub    $0x18,%esp
  char *buf, *pa0;
  uint n, va0;

  buf = (char*)p;
80107d59:	8b 45 10             	mov    0x10(%ebp),%eax
80107d5c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  while(len > 0){
80107d5f:	eb 7f                	jmp    80107de0 <copyout+0x8d>
    va0 = (uint)PGROUNDDOWN(va);
80107d61:	8b 45 0c             	mov    0xc(%ebp),%eax
80107d64:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80107d69:	89 45 ec             	mov    %eax,-0x14(%ebp)
    pa0 = uva2ka(pgdir, (char*)va0);
80107d6c:	8b 45 ec             	mov    -0x14(%ebp),%eax
80107d6f:	83 ec 08             	sub    $0x8,%esp
80107d72:	50                   	push   %eax
80107d73:	ff 75 08             	push   0x8(%ebp)
80107d76:	e8 85 ff ff ff       	call   80107d00 <uva2ka>
80107d7b:	83 c4 10             	add    $0x10,%esp
80107d7e:	89 45 e8             	mov    %eax,-0x18(%ebp)
    if(pa0 == 0)
80107d81:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
80107d85:	75 07                	jne    80107d8e <copyout+0x3b>
      return -1;
80107d87:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80107d8c:	eb 61                	jmp    80107def <copyout+0x9c>
    n = PGSIZE - (va - va0);
80107d8e:	8b 45 ec             	mov    -0x14(%ebp),%eax
80107d91:	2b 45 0c             	sub    0xc(%ebp),%eax
80107d94:	05 00 10 00 00       	add    $0x1000,%eax
80107d99:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(n > len)
80107d9c:	8b 45 f0             	mov    -0x10(%ebp),%eax
80107d9f:	3b 45 14             	cmp    0x14(%ebp),%eax
80107da2:	76 06                	jbe    80107daa <copyout+0x57>
      n = len;
80107da4:	8b 45 14             	mov    0x14(%ebp),%eax
80107da7:	89 45 f0             	mov    %eax,-0x10(%ebp)
    memmove(pa0 + (va - va0), buf, n);
80107daa:	8b 45 0c             	mov    0xc(%ebp),%eax
80107dad:	2b 45 ec             	sub    -0x14(%ebp),%eax
80107db0:	89 c2                	mov    %eax,%edx
80107db2:	8b 45 e8             	mov    -0x18(%ebp),%eax
80107db5:	01 d0                	add    %edx,%eax
80107db7:	83 ec 04             	sub    $0x4,%esp
80107dba:	ff 75 f0             	push   -0x10(%ebp)
80107dbd:	ff 75 f4             	push   -0xc(%ebp)
80107dc0:	50                   	push   %eax
80107dc1:	e8 fc ce ff ff       	call   80104cc2 <memmove>
80107dc6:	83 c4 10             	add    $0x10,%esp
    len -= n;
80107dc9:	8b 45 f0             	mov    -0x10(%ebp),%eax
80107dcc:	29 45 14             	sub    %eax,0x14(%ebp)
    buf += n;
80107dcf:	8b 45 f0             	mov    -0x10(%ebp),%eax
80107dd2:	01 45 f4             	add    %eax,-0xc(%ebp)
    va = va0 + PGSIZE;
80107dd5:	8b 45 ec             	mov    -0x14(%ebp),%eax
80107dd8:	05 00 10 00 00       	add    $0x1000,%eax
80107ddd:	89 45 0c             	mov    %eax,0xc(%ebp)
  while(len > 0){
80107de0:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
80107de4:	0f 85 77 ff ff ff    	jne    80107d61 <copyout+0xe>
  }
  return 0;
80107dea:	b8 00 00 00 00       	mov    $0x0,%eax
}
80107def:	c9                   	leave  
80107df0:	c3                   	ret    

80107df1 <mpinit_uefi>:

struct cpu cpus[NCPU];
int ncpu;
uchar ioapicid;
void mpinit_uefi(void)
{
80107df1:	55                   	push   %ebp
80107df2:	89 e5                	mov    %esp,%ebp
80107df4:	83 ec 20             	sub    $0x20,%esp
  struct boot_param *boot_param = (struct boot_param *)P2V_WO(BOOTPARAM);
80107df7:	c7 45 f8 00 00 05 80 	movl   $0x80050000,-0x8(%ebp)
  struct uefi_madt *madt = (struct uefi_madt*)(P2V_WO(boot_param->madt_addr));
80107dfe:	8b 45 f8             	mov    -0x8(%ebp),%eax
80107e01:	8b 40 08             	mov    0x8(%eax),%eax
80107e04:	05 00 00 00 80       	add    $0x80000000,%eax
80107e09:	89 45 f4             	mov    %eax,-0xc(%ebp)

  uint i=sizeof(struct uefi_madt);
80107e0c:	c7 45 fc 2c 00 00 00 	movl   $0x2c,-0x4(%ebp)
  struct uefi_lapic *lapic_entry;
  struct uefi_ioapic *ioapic;
  struct uefi_iso *iso;
  struct uefi_non_maskable_intr *non_mask_intr; 
  
  lapic = (uint *)(madt->lapic_addr);
80107e13:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107e16:	8b 40 24             	mov    0x24(%eax),%eax
80107e19:	a3 00 41 19 80       	mov    %eax,0x80194100
  ncpu = 0;
80107e1e:	c7 05 40 6e 19 80 00 	movl   $0x0,0x80196e40
80107e25:	00 00 00 

  while(i<madt->len){
80107e28:	90                   	nop
80107e29:	e9 bd 00 00 00       	jmp    80107eeb <mpinit_uefi+0xfa>
    uchar *entry_type = ((uchar *)madt)+i;
80107e2e:	8b 55 f4             	mov    -0xc(%ebp),%edx
80107e31:	8b 45 fc             	mov    -0x4(%ebp),%eax
80107e34:	01 d0                	add    %edx,%eax
80107e36:	89 45 f0             	mov    %eax,-0x10(%ebp)
    switch(*entry_type){
80107e39:	8b 45 f0             	mov    -0x10(%ebp),%eax
80107e3c:	0f b6 00             	movzbl (%eax),%eax
80107e3f:	0f b6 c0             	movzbl %al,%eax
80107e42:	83 f8 05             	cmp    $0x5,%eax
80107e45:	0f 87 a0 00 00 00    	ja     80107eeb <mpinit_uefi+0xfa>
80107e4b:	8b 04 85 14 a9 10 80 	mov    -0x7fef56ec(,%eax,4),%eax
80107e52:	ff e0                	jmp    *%eax
      case 0:
        lapic_entry = (struct uefi_lapic *)entry_type;
80107e54:	8b 45 f0             	mov    -0x10(%ebp),%eax
80107e57:	89 45 e0             	mov    %eax,-0x20(%ebp)
        if(ncpu < NCPU) {
80107e5a:	a1 40 6e 19 80       	mov    0x80196e40,%eax
80107e5f:	83 f8 03             	cmp    $0x3,%eax
80107e62:	7f 28                	jg     80107e8c <mpinit_uefi+0x9b>
          cpus[ncpu].apicid = lapic_entry->lapic_id;
80107e64:	8b 15 40 6e 19 80    	mov    0x80196e40,%edx
80107e6a:	8b 45 e0             	mov    -0x20(%ebp),%eax
80107e6d:	0f b6 40 03          	movzbl 0x3(%eax),%eax
80107e71:	69 d2 b0 00 00 00    	imul   $0xb0,%edx,%edx
80107e77:	81 c2 80 6b 19 80    	add    $0x80196b80,%edx
80107e7d:	88 02                	mov    %al,(%edx)
          ncpu++;
80107e7f:	a1 40 6e 19 80       	mov    0x80196e40,%eax
80107e84:	83 c0 01             	add    $0x1,%eax
80107e87:	a3 40 6e 19 80       	mov    %eax,0x80196e40
        }
        i += lapic_entry->record_len;
80107e8c:	8b 45 e0             	mov    -0x20(%ebp),%eax
80107e8f:	0f b6 40 01          	movzbl 0x1(%eax),%eax
80107e93:	0f b6 c0             	movzbl %al,%eax
80107e96:	01 45 fc             	add    %eax,-0x4(%ebp)
        break;
80107e99:	eb 50                	jmp    80107eeb <mpinit_uefi+0xfa>

      case 1:
        ioapic = (struct uefi_ioapic *)entry_type;
80107e9b:	8b 45 f0             	mov    -0x10(%ebp),%eax
80107e9e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        ioapicid = ioapic->ioapic_id;
80107ea1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80107ea4:	0f b6 40 02          	movzbl 0x2(%eax),%eax
80107ea8:	a2 44 6e 19 80       	mov    %al,0x80196e44
        i += ioapic->record_len;
80107ead:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80107eb0:	0f b6 40 01          	movzbl 0x1(%eax),%eax
80107eb4:	0f b6 c0             	movzbl %al,%eax
80107eb7:	01 45 fc             	add    %eax,-0x4(%ebp)
        break;
80107eba:	eb 2f                	jmp    80107eeb <mpinit_uefi+0xfa>

      case 2:
        iso = (struct uefi_iso *)entry_type;
80107ebc:	8b 45 f0             	mov    -0x10(%ebp),%eax
80107ebf:	89 45 e8             	mov    %eax,-0x18(%ebp)
        i += iso->record_len;
80107ec2:	8b 45 e8             	mov    -0x18(%ebp),%eax
80107ec5:	0f b6 40 01          	movzbl 0x1(%eax),%eax
80107ec9:	0f b6 c0             	movzbl %al,%eax
80107ecc:	01 45 fc             	add    %eax,-0x4(%ebp)
        break;
80107ecf:	eb 1a                	jmp    80107eeb <mpinit_uefi+0xfa>

      case 4:
        non_mask_intr = (struct uefi_non_maskable_intr *)entry_type;
80107ed1:	8b 45 f0             	mov    -0x10(%ebp),%eax
80107ed4:	89 45 ec             	mov    %eax,-0x14(%ebp)
        i += non_mask_intr->record_len;
80107ed7:	8b 45 ec             	mov    -0x14(%ebp),%eax
80107eda:	0f b6 40 01          	movzbl 0x1(%eax),%eax
80107ede:	0f b6 c0             	movzbl %al,%eax
80107ee1:	01 45 fc             	add    %eax,-0x4(%ebp)
        break;
80107ee4:	eb 05                	jmp    80107eeb <mpinit_uefi+0xfa>

      case 5:
        i = i + 0xC;
80107ee6:	83 45 fc 0c          	addl   $0xc,-0x4(%ebp)
        break;
80107eea:	90                   	nop
  while(i<madt->len){
80107eeb:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107eee:	8b 40 04             	mov    0x4(%eax),%eax
80107ef1:	39 45 fc             	cmp    %eax,-0x4(%ebp)
80107ef4:	0f 82 34 ff ff ff    	jb     80107e2e <mpinit_uefi+0x3d>
    }
  }

}
80107efa:	90                   	nop
80107efb:	90                   	nop
80107efc:	c9                   	leave  
80107efd:	c3                   	ret    

80107efe <inb>:
{
80107efe:	55                   	push   %ebp
80107eff:	89 e5                	mov    %esp,%ebp
80107f01:	83 ec 14             	sub    $0x14,%esp
80107f04:	8b 45 08             	mov    0x8(%ebp),%eax
80107f07:	66 89 45 ec          	mov    %ax,-0x14(%ebp)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80107f0b:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
80107f0f:	89 c2                	mov    %eax,%edx
80107f11:	ec                   	in     (%dx),%al
80107f12:	88 45 ff             	mov    %al,-0x1(%ebp)
  return data;
80107f15:	0f b6 45 ff          	movzbl -0x1(%ebp),%eax
}
80107f19:	c9                   	leave  
80107f1a:	c3                   	ret    

80107f1b <outb>:
{
80107f1b:	55                   	push   %ebp
80107f1c:	89 e5                	mov    %esp,%ebp
80107f1e:	83 ec 08             	sub    $0x8,%esp
80107f21:	8b 45 08             	mov    0x8(%ebp),%eax
80107f24:	8b 55 0c             	mov    0xc(%ebp),%edx
80107f27:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
80107f2b:	89 d0                	mov    %edx,%eax
80107f2d:	88 45 f8             	mov    %al,-0x8(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80107f30:	0f b6 45 f8          	movzbl -0x8(%ebp),%eax
80107f34:	0f b7 55 fc          	movzwl -0x4(%ebp),%edx
80107f38:	ee                   	out    %al,(%dx)
}
80107f39:	90                   	nop
80107f3a:	c9                   	leave  
80107f3b:	c3                   	ret    

80107f3c <uart_debug>:
#include "proc.h"
#include "x86.h"

#define COM1    0x3f8

void uart_debug(char p){
80107f3c:	55                   	push   %ebp
80107f3d:	89 e5                	mov    %esp,%ebp
80107f3f:	83 ec 28             	sub    $0x28,%esp
80107f42:	8b 45 08             	mov    0x8(%ebp),%eax
80107f45:	88 45 e4             	mov    %al,-0x1c(%ebp)
    // Turn off the FIFO
  outb(COM1+2, 0);
80107f48:	6a 00                	push   $0x0
80107f4a:	68 fa 03 00 00       	push   $0x3fa
80107f4f:	e8 c7 ff ff ff       	call   80107f1b <outb>
80107f54:	83 c4 08             	add    $0x8,%esp

  // 9600 baud, 8 data bits, 1 stop bit, parity off.
  outb(COM1+3, 0x80);    // Unlock divisor
80107f57:	68 80 00 00 00       	push   $0x80
80107f5c:	68 fb 03 00 00       	push   $0x3fb
80107f61:	e8 b5 ff ff ff       	call   80107f1b <outb>
80107f66:	83 c4 08             	add    $0x8,%esp
  outb(COM1+0, 115200/9600);
80107f69:	6a 0c                	push   $0xc
80107f6b:	68 f8 03 00 00       	push   $0x3f8
80107f70:	e8 a6 ff ff ff       	call   80107f1b <outb>
80107f75:	83 c4 08             	add    $0x8,%esp
  outb(COM1+1, 0);
80107f78:	6a 00                	push   $0x0
80107f7a:	68 f9 03 00 00       	push   $0x3f9
80107f7f:	e8 97 ff ff ff       	call   80107f1b <outb>
80107f84:	83 c4 08             	add    $0x8,%esp
  outb(COM1+3, 0x03);    // Lock divisor, 8 data bits.
80107f87:	6a 03                	push   $0x3
80107f89:	68 fb 03 00 00       	push   $0x3fb
80107f8e:	e8 88 ff ff ff       	call   80107f1b <outb>
80107f93:	83 c4 08             	add    $0x8,%esp
  outb(COM1+4, 0);
80107f96:	6a 00                	push   $0x0
80107f98:	68 fc 03 00 00       	push   $0x3fc
80107f9d:	e8 79 ff ff ff       	call   80107f1b <outb>
80107fa2:	83 c4 08             	add    $0x8,%esp

  for(int i=0;i<128 && !(inb(COM1+5) & 0x20); i++) microdelay(10);
80107fa5:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80107fac:	eb 11                	jmp    80107fbf <uart_debug+0x83>
80107fae:	83 ec 0c             	sub    $0xc,%esp
80107fb1:	6a 0a                	push   $0xa
80107fb3:	e8 7f ab ff ff       	call   80102b37 <microdelay>
80107fb8:	83 c4 10             	add    $0x10,%esp
80107fbb:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80107fbf:	83 7d f4 7f          	cmpl   $0x7f,-0xc(%ebp)
80107fc3:	7f 1a                	jg     80107fdf <uart_debug+0xa3>
80107fc5:	83 ec 0c             	sub    $0xc,%esp
80107fc8:	68 fd 03 00 00       	push   $0x3fd
80107fcd:	e8 2c ff ff ff       	call   80107efe <inb>
80107fd2:	83 c4 10             	add    $0x10,%esp
80107fd5:	0f b6 c0             	movzbl %al,%eax
80107fd8:	83 e0 20             	and    $0x20,%eax
80107fdb:	85 c0                	test   %eax,%eax
80107fdd:	74 cf                	je     80107fae <uart_debug+0x72>
  outb(COM1+0, p);
80107fdf:	0f b6 45 e4          	movzbl -0x1c(%ebp),%eax
80107fe3:	0f b6 c0             	movzbl %al,%eax
80107fe6:	83 ec 08             	sub    $0x8,%esp
80107fe9:	50                   	push   %eax
80107fea:	68 f8 03 00 00       	push   $0x3f8
80107fef:	e8 27 ff ff ff       	call   80107f1b <outb>
80107ff4:	83 c4 10             	add    $0x10,%esp
}
80107ff7:	90                   	nop
80107ff8:	c9                   	leave  
80107ff9:	c3                   	ret    

80107ffa <uart_debugs>:

void uart_debugs(char *p){
80107ffa:	55                   	push   %ebp
80107ffb:	89 e5                	mov    %esp,%ebp
80107ffd:	83 ec 08             	sub    $0x8,%esp
  while(*p){
80108000:	eb 1b                	jmp    8010801d <uart_debugs+0x23>
    uart_debug(*p++);
80108002:	8b 45 08             	mov    0x8(%ebp),%eax
80108005:	8d 50 01             	lea    0x1(%eax),%edx
80108008:	89 55 08             	mov    %edx,0x8(%ebp)
8010800b:	0f b6 00             	movzbl (%eax),%eax
8010800e:	0f be c0             	movsbl %al,%eax
80108011:	83 ec 0c             	sub    $0xc,%esp
80108014:	50                   	push   %eax
80108015:	e8 22 ff ff ff       	call   80107f3c <uart_debug>
8010801a:	83 c4 10             	add    $0x10,%esp
  while(*p){
8010801d:	8b 45 08             	mov    0x8(%ebp),%eax
80108020:	0f b6 00             	movzbl (%eax),%eax
80108023:	84 c0                	test   %al,%al
80108025:	75 db                	jne    80108002 <uart_debugs+0x8>
  }
}
80108027:	90                   	nop
80108028:	90                   	nop
80108029:	c9                   	leave  
8010802a:	c3                   	ret    

8010802b <graphic_init>:
 * i%4 = 2 : red
 * i%4 = 3 : black
 */

struct gpu gpu;
void graphic_init(){
8010802b:	55                   	push   %ebp
8010802c:	89 e5                	mov    %esp,%ebp
8010802e:	83 ec 10             	sub    $0x10,%esp
  struct boot_param *boot_param = (struct boot_param *)P2V_WO(BOOTPARAM);
80108031:	c7 45 fc 00 00 05 80 	movl   $0x80050000,-0x4(%ebp)
  gpu.pvram_addr = boot_param->graphic_config.frame_base;
80108038:	8b 45 fc             	mov    -0x4(%ebp),%eax
8010803b:	8b 50 14             	mov    0x14(%eax),%edx
8010803e:	8b 40 10             	mov    0x10(%eax),%eax
80108041:	a3 48 6e 19 80       	mov    %eax,0x80196e48
  gpu.vram_size = boot_param->graphic_config.frame_size;
80108046:	8b 45 fc             	mov    -0x4(%ebp),%eax
80108049:	8b 50 1c             	mov    0x1c(%eax),%edx
8010804c:	8b 40 18             	mov    0x18(%eax),%eax
8010804f:	a3 50 6e 19 80       	mov    %eax,0x80196e50
  gpu.vvram_addr = DEVSPACE - gpu.vram_size;
80108054:	8b 15 50 6e 19 80    	mov    0x80196e50,%edx
8010805a:	b8 00 00 00 fe       	mov    $0xfe000000,%eax
8010805f:	29 d0                	sub    %edx,%eax
80108061:	a3 4c 6e 19 80       	mov    %eax,0x80196e4c
  gpu.horizontal_resolution = (uint)(boot_param->graphic_config.horizontal_resolution & 0xFFFFFFFF);
80108066:	8b 45 fc             	mov    -0x4(%ebp),%eax
80108069:	8b 50 24             	mov    0x24(%eax),%edx
8010806c:	8b 40 20             	mov    0x20(%eax),%eax
8010806f:	a3 54 6e 19 80       	mov    %eax,0x80196e54
  gpu.vertical_resolution = (uint)(boot_param->graphic_config.vertical_resolution & 0xFFFFFFFF);
80108074:	8b 45 fc             	mov    -0x4(%ebp),%eax
80108077:	8b 50 2c             	mov    0x2c(%eax),%edx
8010807a:	8b 40 28             	mov    0x28(%eax),%eax
8010807d:	a3 58 6e 19 80       	mov    %eax,0x80196e58
  gpu.pixels_per_line = (uint)(boot_param->graphic_config.pixels_per_line & 0xFFFFFFFF);
80108082:	8b 45 fc             	mov    -0x4(%ebp),%eax
80108085:	8b 50 34             	mov    0x34(%eax),%edx
80108088:	8b 40 30             	mov    0x30(%eax),%eax
8010808b:	a3 5c 6e 19 80       	mov    %eax,0x80196e5c
}
80108090:	90                   	nop
80108091:	c9                   	leave  
80108092:	c3                   	ret    

80108093 <graphic_draw_pixel>:

void graphic_draw_pixel(int x,int y,struct graphic_pixel * buffer){
80108093:	55                   	push   %ebp
80108094:	89 e5                	mov    %esp,%ebp
80108096:	83 ec 10             	sub    $0x10,%esp
  int pixel_addr = (sizeof(struct graphic_pixel))*(y*gpu.pixels_per_line + x);
80108099:	8b 15 5c 6e 19 80    	mov    0x80196e5c,%edx
8010809f:	8b 45 0c             	mov    0xc(%ebp),%eax
801080a2:	0f af d0             	imul   %eax,%edx
801080a5:	8b 45 08             	mov    0x8(%ebp),%eax
801080a8:	01 d0                	add    %edx,%eax
801080aa:	c1 e0 02             	shl    $0x2,%eax
801080ad:	89 45 fc             	mov    %eax,-0x4(%ebp)
  struct graphic_pixel *pixel = (struct graphic_pixel *)(gpu.vvram_addr + pixel_addr);
801080b0:	8b 15 4c 6e 19 80    	mov    0x80196e4c,%edx
801080b6:	8b 45 fc             	mov    -0x4(%ebp),%eax
801080b9:	01 d0                	add    %edx,%eax
801080bb:	89 45 f8             	mov    %eax,-0x8(%ebp)
  pixel->blue = buffer->blue;
801080be:	8b 45 10             	mov    0x10(%ebp),%eax
801080c1:	0f b6 10             	movzbl (%eax),%edx
801080c4:	8b 45 f8             	mov    -0x8(%ebp),%eax
801080c7:	88 10                	mov    %dl,(%eax)
  pixel->green = buffer->green;
801080c9:	8b 45 10             	mov    0x10(%ebp),%eax
801080cc:	0f b6 50 01          	movzbl 0x1(%eax),%edx
801080d0:	8b 45 f8             	mov    -0x8(%ebp),%eax
801080d3:	88 50 01             	mov    %dl,0x1(%eax)
  pixel->red = buffer->red;
801080d6:	8b 45 10             	mov    0x10(%ebp),%eax
801080d9:	0f b6 50 02          	movzbl 0x2(%eax),%edx
801080dd:	8b 45 f8             	mov    -0x8(%ebp),%eax
801080e0:	88 50 02             	mov    %dl,0x2(%eax)
}
801080e3:	90                   	nop
801080e4:	c9                   	leave  
801080e5:	c3                   	ret    

801080e6 <graphic_scroll_up>:

void graphic_scroll_up(int height){
801080e6:	55                   	push   %ebp
801080e7:	89 e5                	mov    %esp,%ebp
801080e9:	83 ec 18             	sub    $0x18,%esp
  int addr_diff = (sizeof(struct graphic_pixel))*gpu.pixels_per_line*height;
801080ec:	8b 15 5c 6e 19 80    	mov    0x80196e5c,%edx
801080f2:	8b 45 08             	mov    0x8(%ebp),%eax
801080f5:	0f af c2             	imul   %edx,%eax
801080f8:	c1 e0 02             	shl    $0x2,%eax
801080fb:	89 45 f4             	mov    %eax,-0xc(%ebp)
  memmove((unsigned int *)gpu.vvram_addr,(unsigned int *)(gpu.vvram_addr + addr_diff),gpu.vram_size - addr_diff);
801080fe:	a1 50 6e 19 80       	mov    0x80196e50,%eax
80108103:	8b 55 f4             	mov    -0xc(%ebp),%edx
80108106:	29 d0                	sub    %edx,%eax
80108108:	8b 0d 4c 6e 19 80    	mov    0x80196e4c,%ecx
8010810e:	8b 55 f4             	mov    -0xc(%ebp),%edx
80108111:	01 ca                	add    %ecx,%edx
80108113:	89 d1                	mov    %edx,%ecx
80108115:	8b 15 4c 6e 19 80    	mov    0x80196e4c,%edx
8010811b:	83 ec 04             	sub    $0x4,%esp
8010811e:	50                   	push   %eax
8010811f:	51                   	push   %ecx
80108120:	52                   	push   %edx
80108121:	e8 9c cb ff ff       	call   80104cc2 <memmove>
80108126:	83 c4 10             	add    $0x10,%esp
  memset((unsigned int *)(gpu.vvram_addr + gpu.vram_size - addr_diff),0,addr_diff);
80108129:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010812c:	8b 0d 4c 6e 19 80    	mov    0x80196e4c,%ecx
80108132:	8b 15 50 6e 19 80    	mov    0x80196e50,%edx
80108138:	01 ca                	add    %ecx,%edx
8010813a:	8b 4d f4             	mov    -0xc(%ebp),%ecx
8010813d:	29 ca                	sub    %ecx,%edx
8010813f:	83 ec 04             	sub    $0x4,%esp
80108142:	50                   	push   %eax
80108143:	6a 00                	push   $0x0
80108145:	52                   	push   %edx
80108146:	e8 b8 ca ff ff       	call   80104c03 <memset>
8010814b:	83 c4 10             	add    $0x10,%esp
}
8010814e:	90                   	nop
8010814f:	c9                   	leave  
80108150:	c3                   	ret    

80108151 <font_render>:
80108151:	55                   	push   %ebp
80108152:	89 e5                	mov    %esp,%ebp
80108154:	53                   	push   %ebx
80108155:	83 ec 14             	sub    $0x14,%esp
80108158:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
8010815f:	e9 b1 00 00 00       	jmp    80108215 <font_render+0xc4>
80108164:	c7 45 f0 0e 00 00 00 	movl   $0xe,-0x10(%ebp)
8010816b:	e9 97 00 00 00       	jmp    80108207 <font_render+0xb6>
80108170:	8b 45 10             	mov    0x10(%ebp),%eax
80108173:	83 e8 20             	sub    $0x20,%eax
80108176:	6b d0 1e             	imul   $0x1e,%eax,%edx
80108179:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010817c:	01 d0                	add    %edx,%eax
8010817e:	0f b7 84 00 40 a9 10 	movzwl -0x7fef56c0(%eax,%eax,1),%eax
80108185:	80 
80108186:	0f b7 d0             	movzwl %ax,%edx
80108189:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010818c:	bb 01 00 00 00       	mov    $0x1,%ebx
80108191:	89 c1                	mov    %eax,%ecx
80108193:	d3 e3                	shl    %cl,%ebx
80108195:	89 d8                	mov    %ebx,%eax
80108197:	21 d0                	and    %edx,%eax
80108199:	89 45 ec             	mov    %eax,-0x14(%ebp)
8010819c:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010819f:	ba 01 00 00 00       	mov    $0x1,%edx
801081a4:	89 c1                	mov    %eax,%ecx
801081a6:	d3 e2                	shl    %cl,%edx
801081a8:	89 d0                	mov    %edx,%eax
801081aa:	39 45 ec             	cmp    %eax,-0x14(%ebp)
801081ad:	75 2b                	jne    801081da <font_render+0x89>
801081af:	8b 55 0c             	mov    0xc(%ebp),%edx
801081b2:	8b 45 f4             	mov    -0xc(%ebp),%eax
801081b5:	01 c2                	add    %eax,%edx
801081b7:	b8 0e 00 00 00       	mov    $0xe,%eax
801081bc:	2b 45 f0             	sub    -0x10(%ebp),%eax
801081bf:	89 c1                	mov    %eax,%ecx
801081c1:	8b 45 08             	mov    0x8(%ebp),%eax
801081c4:	01 c8                	add    %ecx,%eax
801081c6:	83 ec 04             	sub    $0x4,%esp
801081c9:	68 00 f5 10 80       	push   $0x8010f500
801081ce:	52                   	push   %edx
801081cf:	50                   	push   %eax
801081d0:	e8 be fe ff ff       	call   80108093 <graphic_draw_pixel>
801081d5:	83 c4 10             	add    $0x10,%esp
801081d8:	eb 29                	jmp    80108203 <font_render+0xb2>
801081da:	8b 55 0c             	mov    0xc(%ebp),%edx
801081dd:	8b 45 f4             	mov    -0xc(%ebp),%eax
801081e0:	01 c2                	add    %eax,%edx
801081e2:	b8 0e 00 00 00       	mov    $0xe,%eax
801081e7:	2b 45 f0             	sub    -0x10(%ebp),%eax
801081ea:	89 c1                	mov    %eax,%ecx
801081ec:	8b 45 08             	mov    0x8(%ebp),%eax
801081ef:	01 c8                	add    %ecx,%eax
801081f1:	83 ec 04             	sub    $0x4,%esp
801081f4:	68 60 6e 19 80       	push   $0x80196e60
801081f9:	52                   	push   %edx
801081fa:	50                   	push   %eax
801081fb:	e8 93 fe ff ff       	call   80108093 <graphic_draw_pixel>
80108200:	83 c4 10             	add    $0x10,%esp
80108203:	83 6d f0 01          	subl   $0x1,-0x10(%ebp)
80108207:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
8010820b:	0f 89 5f ff ff ff    	jns    80108170 <font_render+0x1f>
80108211:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80108215:	83 7d f4 1d          	cmpl   $0x1d,-0xc(%ebp)
80108219:	0f 8e 45 ff ff ff    	jle    80108164 <font_render+0x13>
8010821f:	90                   	nop
80108220:	90                   	nop
80108221:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80108224:	c9                   	leave  
80108225:	c3                   	ret    

80108226 <font_render_string>:
80108226:	55                   	push   %ebp
80108227:	89 e5                	mov    %esp,%ebp
80108229:	53                   	push   %ebx
8010822a:	83 ec 14             	sub    $0x14,%esp
8010822d:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80108234:	eb 33                	jmp    80108269 <font_render_string+0x43>
80108236:	8b 55 f4             	mov    -0xc(%ebp),%edx
80108239:	8b 45 08             	mov    0x8(%ebp),%eax
8010823c:	01 d0                	add    %edx,%eax
8010823e:	0f b6 00             	movzbl (%eax),%eax
80108241:	0f be c8             	movsbl %al,%ecx
80108244:	8b 45 0c             	mov    0xc(%ebp),%eax
80108247:	6b d0 1e             	imul   $0x1e,%eax,%edx
8010824a:	8b 5d f4             	mov    -0xc(%ebp),%ebx
8010824d:	89 d8                	mov    %ebx,%eax
8010824f:	c1 e0 04             	shl    $0x4,%eax
80108252:	29 d8                	sub    %ebx,%eax
80108254:	83 c0 02             	add    $0x2,%eax
80108257:	83 ec 04             	sub    $0x4,%esp
8010825a:	51                   	push   %ecx
8010825b:	52                   	push   %edx
8010825c:	50                   	push   %eax
8010825d:	e8 ef fe ff ff       	call   80108151 <font_render>
80108262:	83 c4 10             	add    $0x10,%esp
80108265:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80108269:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010826c:	8b 45 08             	mov    0x8(%ebp),%eax
8010826f:	01 d0                	add    %edx,%eax
80108271:	0f b6 00             	movzbl (%eax),%eax
80108274:	84 c0                	test   %al,%al
80108276:	74 06                	je     8010827e <font_render_string+0x58>
80108278:	83 7d f4 33          	cmpl   $0x33,-0xc(%ebp)
8010827c:	7e b8                	jle    80108236 <font_render_string+0x10>
8010827e:	90                   	nop
8010827f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80108282:	c9                   	leave  
80108283:	c3                   	ret    

80108284 <pci_init>:
#include "pci.h"
#include "defs.h"
#include "types.h"
#include "i8254.h"

void pci_init(){
80108284:	55                   	push   %ebp
80108285:	89 e5                	mov    %esp,%ebp
80108287:	53                   	push   %ebx
80108288:	83 ec 14             	sub    $0x14,%esp
  uint data;
  for(int i=0;i<256;i++){
8010828b:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80108292:	eb 6b                	jmp    801082ff <pci_init+0x7b>
    for(int j=0;j<32;j++){
80108294:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
8010829b:	eb 58                	jmp    801082f5 <pci_init+0x71>
      for(int k=0;k<8;k++){
8010829d:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
801082a4:	eb 45                	jmp    801082eb <pci_init+0x67>
      pci_access_config(i,j,k,0,&data);
801082a6:	8b 4d ec             	mov    -0x14(%ebp),%ecx
801082a9:	8b 55 f0             	mov    -0x10(%ebp),%edx
801082ac:	8b 45 f4             	mov    -0xc(%ebp),%eax
801082af:	83 ec 0c             	sub    $0xc,%esp
801082b2:	8d 5d e8             	lea    -0x18(%ebp),%ebx
801082b5:	53                   	push   %ebx
801082b6:	6a 00                	push   $0x0
801082b8:	51                   	push   %ecx
801082b9:	52                   	push   %edx
801082ba:	50                   	push   %eax
801082bb:	e8 b0 00 00 00       	call   80108370 <pci_access_config>
801082c0:	83 c4 20             	add    $0x20,%esp
      if((data&0xFFFF) != 0xFFFF){
801082c3:	8b 45 e8             	mov    -0x18(%ebp),%eax
801082c6:	0f b7 c0             	movzwl %ax,%eax
801082c9:	3d ff ff 00 00       	cmp    $0xffff,%eax
801082ce:	74 17                	je     801082e7 <pci_init+0x63>
        pci_init_device(i,j,k);
801082d0:	8b 4d ec             	mov    -0x14(%ebp),%ecx
801082d3:	8b 55 f0             	mov    -0x10(%ebp),%edx
801082d6:	8b 45 f4             	mov    -0xc(%ebp),%eax
801082d9:	83 ec 04             	sub    $0x4,%esp
801082dc:	51                   	push   %ecx
801082dd:	52                   	push   %edx
801082de:	50                   	push   %eax
801082df:	e8 37 01 00 00       	call   8010841b <pci_init_device>
801082e4:	83 c4 10             	add    $0x10,%esp
      for(int k=0;k<8;k++){
801082e7:	83 45 ec 01          	addl   $0x1,-0x14(%ebp)
801082eb:	83 7d ec 07          	cmpl   $0x7,-0x14(%ebp)
801082ef:	7e b5                	jle    801082a6 <pci_init+0x22>
    for(int j=0;j<32;j++){
801082f1:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
801082f5:	83 7d f0 1f          	cmpl   $0x1f,-0x10(%ebp)
801082f9:	7e a2                	jle    8010829d <pci_init+0x19>
  for(int i=0;i<256;i++){
801082fb:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
801082ff:	81 7d f4 ff 00 00 00 	cmpl   $0xff,-0xc(%ebp)
80108306:	7e 8c                	jle    80108294 <pci_init+0x10>
      }
      }
    }
  }
}
80108308:	90                   	nop
80108309:	90                   	nop
8010830a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010830d:	c9                   	leave  
8010830e:	c3                   	ret    

8010830f <pci_write_config>:

void pci_write_config(uint config){
8010830f:	55                   	push   %ebp
80108310:	89 e5                	mov    %esp,%ebp
  asm("mov $0xCF8,%%edx\n\t"
80108312:	8b 45 08             	mov    0x8(%ebp),%eax
80108315:	ba f8 0c 00 00       	mov    $0xcf8,%edx
8010831a:	89 c0                	mov    %eax,%eax
8010831c:	ef                   	out    %eax,(%dx)
      "mov %0,%%eax\n\t"
      "out %%eax,%%dx\n\t"
      : :"r"(config));
}
8010831d:	90                   	nop
8010831e:	5d                   	pop    %ebp
8010831f:	c3                   	ret    

80108320 <pci_write_data>:

void pci_write_data(uint config){
80108320:	55                   	push   %ebp
80108321:	89 e5                	mov    %esp,%ebp
  asm("mov $0xCFC,%%edx\n\t"
80108323:	8b 45 08             	mov    0x8(%ebp),%eax
80108326:	ba fc 0c 00 00       	mov    $0xcfc,%edx
8010832b:	89 c0                	mov    %eax,%eax
8010832d:	ef                   	out    %eax,(%dx)
      "mov %0,%%eax\n\t"
      "out %%eax,%%dx\n\t"
      : :"r"(config));
}
8010832e:	90                   	nop
8010832f:	5d                   	pop    %ebp
80108330:	c3                   	ret    

80108331 <pci_read_config>:
uint pci_read_config(){
80108331:	55                   	push   %ebp
80108332:	89 e5                	mov    %esp,%ebp
80108334:	83 ec 18             	sub    $0x18,%esp
  uint data;
  asm("mov $0xCFC,%%edx\n\t"
80108337:	ba fc 0c 00 00       	mov    $0xcfc,%edx
8010833c:	ed                   	in     (%dx),%eax
8010833d:	89 45 f4             	mov    %eax,-0xc(%ebp)
      "in %%dx,%%eax\n\t"
      "mov %%eax,%0"
      :"=m"(data):);
  microdelay(200);
80108340:	83 ec 0c             	sub    $0xc,%esp
80108343:	68 c8 00 00 00       	push   $0xc8
80108348:	e8 ea a7 ff ff       	call   80102b37 <microdelay>
8010834d:	83 c4 10             	add    $0x10,%esp
  return data;
80108350:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
80108353:	c9                   	leave  
80108354:	c3                   	ret    

80108355 <pci_test>:


void pci_test(){
80108355:	55                   	push   %ebp
80108356:	89 e5                	mov    %esp,%ebp
80108358:	83 ec 10             	sub    $0x10,%esp
  uint data = 0x80001804;
8010835b:	c7 45 fc 04 18 00 80 	movl   $0x80001804,-0x4(%ebp)
  pci_write_config(data);
80108362:	ff 75 fc             	push   -0x4(%ebp)
80108365:	e8 a5 ff ff ff       	call   8010830f <pci_write_config>
8010836a:	83 c4 04             	add    $0x4,%esp
}
8010836d:	90                   	nop
8010836e:	c9                   	leave  
8010836f:	c3                   	ret    

80108370 <pci_access_config>:

void pci_access_config(uint bus_num,uint device_num,uint function_num,uint reg_addr,uint *data){
80108370:	55                   	push   %ebp
80108371:	89 e5                	mov    %esp,%ebp
80108373:	83 ec 18             	sub    $0x18,%esp
  uint config_addr = ((bus_num & 0xFF)<<16) | ((device_num & 0x1F)<<11) | ((function_num & 0x7)<<8) |
80108376:	8b 45 08             	mov    0x8(%ebp),%eax
80108379:	c1 e0 10             	shl    $0x10,%eax
8010837c:	25 00 00 ff 00       	and    $0xff0000,%eax
80108381:	89 c2                	mov    %eax,%edx
80108383:	8b 45 0c             	mov    0xc(%ebp),%eax
80108386:	c1 e0 0b             	shl    $0xb,%eax
80108389:	0f b7 c0             	movzwl %ax,%eax
8010838c:	09 c2                	or     %eax,%edx
8010838e:	8b 45 10             	mov    0x10(%ebp),%eax
80108391:	c1 e0 08             	shl    $0x8,%eax
80108394:	25 00 07 00 00       	and    $0x700,%eax
80108399:	09 c2                	or     %eax,%edx
    (reg_addr & 0xFC) | 0x80000000;
8010839b:	8b 45 14             	mov    0x14(%ebp),%eax
8010839e:	25 fc 00 00 00       	and    $0xfc,%eax
  uint config_addr = ((bus_num & 0xFF)<<16) | ((device_num & 0x1F)<<11) | ((function_num & 0x7)<<8) |
801083a3:	09 d0                	or     %edx,%eax
801083a5:	0d 00 00 00 80       	or     $0x80000000,%eax
801083aa:	89 45 f4             	mov    %eax,-0xc(%ebp)
  pci_write_config(config_addr);
801083ad:	ff 75 f4             	push   -0xc(%ebp)
801083b0:	e8 5a ff ff ff       	call   8010830f <pci_write_config>
801083b5:	83 c4 04             	add    $0x4,%esp
  *data = pci_read_config();
801083b8:	e8 74 ff ff ff       	call   80108331 <pci_read_config>
801083bd:	8b 55 18             	mov    0x18(%ebp),%edx
801083c0:	89 02                	mov    %eax,(%edx)
}
801083c2:	90                   	nop
801083c3:	c9                   	leave  
801083c4:	c3                   	ret    

801083c5 <pci_write_config_register>:

void pci_write_config_register(uint bus_num,uint device_num,uint function_num,uint reg_addr,uint data){
801083c5:	55                   	push   %ebp
801083c6:	89 e5                	mov    %esp,%ebp
801083c8:	83 ec 10             	sub    $0x10,%esp
  uint config_addr = ((bus_num & 0xFF)<<16) | ((device_num & 0x1F)<<11) | ((function_num & 0x7)<<8) |
801083cb:	8b 45 08             	mov    0x8(%ebp),%eax
801083ce:	c1 e0 10             	shl    $0x10,%eax
801083d1:	25 00 00 ff 00       	and    $0xff0000,%eax
801083d6:	89 c2                	mov    %eax,%edx
801083d8:	8b 45 0c             	mov    0xc(%ebp),%eax
801083db:	c1 e0 0b             	shl    $0xb,%eax
801083de:	0f b7 c0             	movzwl %ax,%eax
801083e1:	09 c2                	or     %eax,%edx
801083e3:	8b 45 10             	mov    0x10(%ebp),%eax
801083e6:	c1 e0 08             	shl    $0x8,%eax
801083e9:	25 00 07 00 00       	and    $0x700,%eax
801083ee:	09 c2                	or     %eax,%edx
    (reg_addr & 0xFC) | 0x80000000;
801083f0:	8b 45 14             	mov    0x14(%ebp),%eax
801083f3:	25 fc 00 00 00       	and    $0xfc,%eax
  uint config_addr = ((bus_num & 0xFF)<<16) | ((device_num & 0x1F)<<11) | ((function_num & 0x7)<<8) |
801083f8:	09 d0                	or     %edx,%eax
801083fa:	0d 00 00 00 80       	or     $0x80000000,%eax
801083ff:	89 45 fc             	mov    %eax,-0x4(%ebp)
  pci_write_config(config_addr);
80108402:	ff 75 fc             	push   -0x4(%ebp)
80108405:	e8 05 ff ff ff       	call   8010830f <pci_write_config>
8010840a:	83 c4 04             	add    $0x4,%esp
  pci_write_data(data);
8010840d:	ff 75 18             	push   0x18(%ebp)
80108410:	e8 0b ff ff ff       	call   80108320 <pci_write_data>
80108415:	83 c4 04             	add    $0x4,%esp
}
80108418:	90                   	nop
80108419:	c9                   	leave  
8010841a:	c3                   	ret    

8010841b <pci_init_device>:

struct pci_dev dev;
void pci_init_device(uint bus_num,uint device_num,uint function_num){
8010841b:	55                   	push   %ebp
8010841c:	89 e5                	mov    %esp,%ebp
8010841e:	53                   	push   %ebx
8010841f:	83 ec 14             	sub    $0x14,%esp
  uint data;
  dev.bus_num = bus_num;
80108422:	8b 45 08             	mov    0x8(%ebp),%eax
80108425:	a2 64 6e 19 80       	mov    %al,0x80196e64
  dev.device_num = device_num;
8010842a:	8b 45 0c             	mov    0xc(%ebp),%eax
8010842d:	a2 65 6e 19 80       	mov    %al,0x80196e65
  dev.function_num = function_num;
80108432:	8b 45 10             	mov    0x10(%ebp),%eax
80108435:	a2 66 6e 19 80       	mov    %al,0x80196e66
  cprintf("PCI Device Found Bus:0x%x Device:0x%x Function:%x\n",bus_num,device_num,function_num);
8010843a:	ff 75 10             	push   0x10(%ebp)
8010843d:	ff 75 0c             	push   0xc(%ebp)
80108440:	ff 75 08             	push   0x8(%ebp)
80108443:	68 84 bf 10 80       	push   $0x8010bf84
80108448:	e8 a7 7f ff ff       	call   801003f4 <cprintf>
8010844d:	83 c4 10             	add    $0x10,%esp
  
  pci_access_config(bus_num,device_num,function_num,0,&data);
80108450:	83 ec 0c             	sub    $0xc,%esp
80108453:	8d 45 ec             	lea    -0x14(%ebp),%eax
80108456:	50                   	push   %eax
80108457:	6a 00                	push   $0x0
80108459:	ff 75 10             	push   0x10(%ebp)
8010845c:	ff 75 0c             	push   0xc(%ebp)
8010845f:	ff 75 08             	push   0x8(%ebp)
80108462:	e8 09 ff ff ff       	call   80108370 <pci_access_config>
80108467:	83 c4 20             	add    $0x20,%esp
  uint device_id = data>>16;
8010846a:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010846d:	c1 e8 10             	shr    $0x10,%eax
80108470:	89 45 f4             	mov    %eax,-0xc(%ebp)
  uint vendor_id = data&0xFFFF;
80108473:	8b 45 ec             	mov    -0x14(%ebp),%eax
80108476:	25 ff ff 00 00       	and    $0xffff,%eax
8010847b:	89 45 f0             	mov    %eax,-0x10(%ebp)
  dev.device_id = device_id;
8010847e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108481:	a3 68 6e 19 80       	mov    %eax,0x80196e68
  dev.vendor_id = vendor_id;
80108486:	8b 45 f0             	mov    -0x10(%ebp),%eax
80108489:	a3 6c 6e 19 80       	mov    %eax,0x80196e6c
  cprintf("  Device ID:0x%x  Vendor ID:0x%x\n",device_id,vendor_id);
8010848e:	83 ec 04             	sub    $0x4,%esp
80108491:	ff 75 f0             	push   -0x10(%ebp)
80108494:	ff 75 f4             	push   -0xc(%ebp)
80108497:	68 b8 bf 10 80       	push   $0x8010bfb8
8010849c:	e8 53 7f ff ff       	call   801003f4 <cprintf>
801084a1:	83 c4 10             	add    $0x10,%esp
  
  pci_access_config(bus_num,device_num,function_num,0x8,&data);
801084a4:	83 ec 0c             	sub    $0xc,%esp
801084a7:	8d 45 ec             	lea    -0x14(%ebp),%eax
801084aa:	50                   	push   %eax
801084ab:	6a 08                	push   $0x8
801084ad:	ff 75 10             	push   0x10(%ebp)
801084b0:	ff 75 0c             	push   0xc(%ebp)
801084b3:	ff 75 08             	push   0x8(%ebp)
801084b6:	e8 b5 fe ff ff       	call   80108370 <pci_access_config>
801084bb:	83 c4 20             	add    $0x20,%esp
  cprintf("  Base Class:0x%x  Sub Class:0x%x  Interface:0x%x  Revision ID:0x%x\n",
801084be:	8b 45 ec             	mov    -0x14(%ebp),%eax
801084c1:	0f b6 c8             	movzbl %al,%ecx
      data>>24,(data>>16)&0xFF,(data>>8)&0xFF,data&0xFF);
801084c4:	8b 45 ec             	mov    -0x14(%ebp),%eax
801084c7:	c1 e8 08             	shr    $0x8,%eax
  cprintf("  Base Class:0x%x  Sub Class:0x%x  Interface:0x%x  Revision ID:0x%x\n",
801084ca:	0f b6 d0             	movzbl %al,%edx
      data>>24,(data>>16)&0xFF,(data>>8)&0xFF,data&0xFF);
801084cd:	8b 45 ec             	mov    -0x14(%ebp),%eax
801084d0:	c1 e8 10             	shr    $0x10,%eax
  cprintf("  Base Class:0x%x  Sub Class:0x%x  Interface:0x%x  Revision ID:0x%x\n",
801084d3:	0f b6 c0             	movzbl %al,%eax
801084d6:	8b 5d ec             	mov    -0x14(%ebp),%ebx
801084d9:	c1 eb 18             	shr    $0x18,%ebx
801084dc:	83 ec 0c             	sub    $0xc,%esp
801084df:	51                   	push   %ecx
801084e0:	52                   	push   %edx
801084e1:	50                   	push   %eax
801084e2:	53                   	push   %ebx
801084e3:	68 dc bf 10 80       	push   $0x8010bfdc
801084e8:	e8 07 7f ff ff       	call   801003f4 <cprintf>
801084ed:	83 c4 20             	add    $0x20,%esp
  dev.base_class = data>>24;
801084f0:	8b 45 ec             	mov    -0x14(%ebp),%eax
801084f3:	c1 e8 18             	shr    $0x18,%eax
801084f6:	a2 70 6e 19 80       	mov    %al,0x80196e70
  dev.sub_class = (data>>16)&0xFF;
801084fb:	8b 45 ec             	mov    -0x14(%ebp),%eax
801084fe:	c1 e8 10             	shr    $0x10,%eax
80108501:	a2 71 6e 19 80       	mov    %al,0x80196e71
  dev.interface = (data>>8)&0xFF;
80108506:	8b 45 ec             	mov    -0x14(%ebp),%eax
80108509:	c1 e8 08             	shr    $0x8,%eax
8010850c:	a2 72 6e 19 80       	mov    %al,0x80196e72
  dev.revision_id = data&0xFF;
80108511:	8b 45 ec             	mov    -0x14(%ebp),%eax
80108514:	a2 73 6e 19 80       	mov    %al,0x80196e73
  
  pci_access_config(bus_num,device_num,function_num,0x10,&data);
80108519:	83 ec 0c             	sub    $0xc,%esp
8010851c:	8d 45 ec             	lea    -0x14(%ebp),%eax
8010851f:	50                   	push   %eax
80108520:	6a 10                	push   $0x10
80108522:	ff 75 10             	push   0x10(%ebp)
80108525:	ff 75 0c             	push   0xc(%ebp)
80108528:	ff 75 08             	push   0x8(%ebp)
8010852b:	e8 40 fe ff ff       	call   80108370 <pci_access_config>
80108530:	83 c4 20             	add    $0x20,%esp
  dev.bar0 = data;
80108533:	8b 45 ec             	mov    -0x14(%ebp),%eax
80108536:	a3 74 6e 19 80       	mov    %eax,0x80196e74
  pci_access_config(bus_num,device_num,function_num,0x14,&data);
8010853b:	83 ec 0c             	sub    $0xc,%esp
8010853e:	8d 45 ec             	lea    -0x14(%ebp),%eax
80108541:	50                   	push   %eax
80108542:	6a 14                	push   $0x14
80108544:	ff 75 10             	push   0x10(%ebp)
80108547:	ff 75 0c             	push   0xc(%ebp)
8010854a:	ff 75 08             	push   0x8(%ebp)
8010854d:	e8 1e fe ff ff       	call   80108370 <pci_access_config>
80108552:	83 c4 20             	add    $0x20,%esp
  dev.bar1 = data;
80108555:	8b 45 ec             	mov    -0x14(%ebp),%eax
80108558:	a3 78 6e 19 80       	mov    %eax,0x80196e78
  if(device_id == I8254_DEVICE_ID && vendor_id == I8254_VENDOR_ID){
8010855d:	81 7d f4 0e 10 00 00 	cmpl   $0x100e,-0xc(%ebp)
80108564:	75 5a                	jne    801085c0 <pci_init_device+0x1a5>
80108566:	81 7d f0 86 80 00 00 	cmpl   $0x8086,-0x10(%ebp)
8010856d:	75 51                	jne    801085c0 <pci_init_device+0x1a5>
    cprintf("E1000 Ethernet NIC Found\n");
8010856f:	83 ec 0c             	sub    $0xc,%esp
80108572:	68 21 c0 10 80       	push   $0x8010c021
80108577:	e8 78 7e ff ff       	call   801003f4 <cprintf>
8010857c:	83 c4 10             	add    $0x10,%esp
    pci_access_config(bus_num,device_num,function_num,0xF0,&data);
8010857f:	83 ec 0c             	sub    $0xc,%esp
80108582:	8d 45 ec             	lea    -0x14(%ebp),%eax
80108585:	50                   	push   %eax
80108586:	68 f0 00 00 00       	push   $0xf0
8010858b:	ff 75 10             	push   0x10(%ebp)
8010858e:	ff 75 0c             	push   0xc(%ebp)
80108591:	ff 75 08             	push   0x8(%ebp)
80108594:	e8 d7 fd ff ff       	call   80108370 <pci_access_config>
80108599:	83 c4 20             	add    $0x20,%esp
    cprintf("Message Control:%x\n",data);
8010859c:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010859f:	83 ec 08             	sub    $0x8,%esp
801085a2:	50                   	push   %eax
801085a3:	68 3b c0 10 80       	push   $0x8010c03b
801085a8:	e8 47 7e ff ff       	call   801003f4 <cprintf>
801085ad:	83 c4 10             	add    $0x10,%esp
    i8254_init(&dev);
801085b0:	83 ec 0c             	sub    $0xc,%esp
801085b3:	68 64 6e 19 80       	push   $0x80196e64
801085b8:	e8 09 00 00 00       	call   801085c6 <i8254_init>
801085bd:	83 c4 10             	add    $0x10,%esp
  }
}
801085c0:	90                   	nop
801085c1:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801085c4:	c9                   	leave  
801085c5:	c3                   	ret    

801085c6 <i8254_init>:

uint base_addr;
uchar mac_addr[6] = {0};
uchar my_ip[4] = {10,0,1,10}; 
uint *intr_addr;
void i8254_init(struct pci_dev *dev){
801085c6:	55                   	push   %ebp
801085c7:	89 e5                	mov    %esp,%ebp
801085c9:	53                   	push   %ebx
801085ca:	83 ec 14             	sub    $0x14,%esp
  uint cmd_reg;
  //Enable Bus Master
  pci_access_config(dev->bus_num,dev->device_num,dev->function_num,0x04,&cmd_reg);
801085cd:	8b 45 08             	mov    0x8(%ebp),%eax
801085d0:	0f b6 40 02          	movzbl 0x2(%eax),%eax
801085d4:	0f b6 c8             	movzbl %al,%ecx
801085d7:	8b 45 08             	mov    0x8(%ebp),%eax
801085da:	0f b6 40 01          	movzbl 0x1(%eax),%eax
801085de:	0f b6 d0             	movzbl %al,%edx
801085e1:	8b 45 08             	mov    0x8(%ebp),%eax
801085e4:	0f b6 00             	movzbl (%eax),%eax
801085e7:	0f b6 c0             	movzbl %al,%eax
801085ea:	83 ec 0c             	sub    $0xc,%esp
801085ed:	8d 5d ec             	lea    -0x14(%ebp),%ebx
801085f0:	53                   	push   %ebx
801085f1:	6a 04                	push   $0x4
801085f3:	51                   	push   %ecx
801085f4:	52                   	push   %edx
801085f5:	50                   	push   %eax
801085f6:	e8 75 fd ff ff       	call   80108370 <pci_access_config>
801085fb:	83 c4 20             	add    $0x20,%esp
  cmd_reg = cmd_reg | PCI_CMD_BUS_MASTER;
801085fe:	8b 45 ec             	mov    -0x14(%ebp),%eax
80108601:	83 c8 04             	or     $0x4,%eax
80108604:	89 45 ec             	mov    %eax,-0x14(%ebp)
  pci_write_config_register(dev->bus_num,dev->device_num,dev->function_num,0x04,cmd_reg);
80108607:	8b 5d ec             	mov    -0x14(%ebp),%ebx
8010860a:	8b 45 08             	mov    0x8(%ebp),%eax
8010860d:	0f b6 40 02          	movzbl 0x2(%eax),%eax
80108611:	0f b6 c8             	movzbl %al,%ecx
80108614:	8b 45 08             	mov    0x8(%ebp),%eax
80108617:	0f b6 40 01          	movzbl 0x1(%eax),%eax
8010861b:	0f b6 d0             	movzbl %al,%edx
8010861e:	8b 45 08             	mov    0x8(%ebp),%eax
80108621:	0f b6 00             	movzbl (%eax),%eax
80108624:	0f b6 c0             	movzbl %al,%eax
80108627:	83 ec 0c             	sub    $0xc,%esp
8010862a:	53                   	push   %ebx
8010862b:	6a 04                	push   $0x4
8010862d:	51                   	push   %ecx
8010862e:	52                   	push   %edx
8010862f:	50                   	push   %eax
80108630:	e8 90 fd ff ff       	call   801083c5 <pci_write_config_register>
80108635:	83 c4 20             	add    $0x20,%esp
  
  base_addr = PCI_P2V(dev->bar0);
80108638:	8b 45 08             	mov    0x8(%ebp),%eax
8010863b:	8b 40 10             	mov    0x10(%eax),%eax
8010863e:	05 00 00 00 40       	add    $0x40000000,%eax
80108643:	a3 7c 6e 19 80       	mov    %eax,0x80196e7c
  uint *ctrl = (uint *)base_addr;
80108648:	a1 7c 6e 19 80       	mov    0x80196e7c,%eax
8010864d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  //Disable Interrupts
  uint *imc = (uint *)(base_addr+0xD8);
80108650:	a1 7c 6e 19 80       	mov    0x80196e7c,%eax
80108655:	05 d8 00 00 00       	add    $0xd8,%eax
8010865a:	89 45 f0             	mov    %eax,-0x10(%ebp)
  *imc = 0xFFFFFFFF;
8010865d:	8b 45 f0             	mov    -0x10(%ebp),%eax
80108660:	c7 00 ff ff ff ff    	movl   $0xffffffff,(%eax)
  
  //Reset NIC
  *ctrl = *ctrl | I8254_CTRL_RST;
80108666:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108669:	8b 00                	mov    (%eax),%eax
8010866b:	0d 00 00 00 04       	or     $0x4000000,%eax
80108670:	89 c2                	mov    %eax,%edx
80108672:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108675:	89 10                	mov    %edx,(%eax)

  //Enable Interrupts
  *imc = 0xFFFFFFFF;
80108677:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010867a:	c7 00 ff ff ff ff    	movl   $0xffffffff,(%eax)

  //Enable Link
  *ctrl |= I8254_CTRL_SLU;
80108680:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108683:	8b 00                	mov    (%eax),%eax
80108685:	83 c8 40             	or     $0x40,%eax
80108688:	89 c2                	mov    %eax,%edx
8010868a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010868d:	89 10                	mov    %edx,(%eax)
  
  //General Configuration
  *ctrl &= (~I8254_CTRL_PHY_RST | ~I8254_CTRL_VME | ~I8254_CTRL_ILOS);
8010868f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108692:	8b 10                	mov    (%eax),%edx
80108694:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108697:	89 10                	mov    %edx,(%eax)
  cprintf("E1000 General Configuration Done\n");
80108699:	83 ec 0c             	sub    $0xc,%esp
8010869c:	68 50 c0 10 80       	push   $0x8010c050
801086a1:	e8 4e 7d ff ff       	call   801003f4 <cprintf>
801086a6:	83 c4 10             	add    $0x10,%esp
  intr_addr = (uint *)kalloc();
801086a9:	e8 f2 a0 ff ff       	call   801027a0 <kalloc>
801086ae:	a3 88 6e 19 80       	mov    %eax,0x80196e88
  *intr_addr = 0;
801086b3:	a1 88 6e 19 80       	mov    0x80196e88,%eax
801086b8:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  cprintf("INTR_ADDR:%x\n",intr_addr);
801086be:	a1 88 6e 19 80       	mov    0x80196e88,%eax
801086c3:	83 ec 08             	sub    $0x8,%esp
801086c6:	50                   	push   %eax
801086c7:	68 72 c0 10 80       	push   $0x8010c072
801086cc:	e8 23 7d ff ff       	call   801003f4 <cprintf>
801086d1:	83 c4 10             	add    $0x10,%esp
  i8254_init_recv();
801086d4:	e8 50 00 00 00       	call   80108729 <i8254_init_recv>
  i8254_init_send();
801086d9:	e8 69 03 00 00       	call   80108a47 <i8254_init_send>
  cprintf("IP Address %d.%d.%d.%d\n",
      my_ip[0],
      my_ip[1],
      my_ip[2],
      my_ip[3]);
801086de:	0f b6 05 07 f5 10 80 	movzbl 0x8010f507,%eax
  cprintf("IP Address %d.%d.%d.%d\n",
801086e5:	0f b6 d8             	movzbl %al,%ebx
      my_ip[2],
801086e8:	0f b6 05 06 f5 10 80 	movzbl 0x8010f506,%eax
  cprintf("IP Address %d.%d.%d.%d\n",
801086ef:	0f b6 c8             	movzbl %al,%ecx
      my_ip[1],
801086f2:	0f b6 05 05 f5 10 80 	movzbl 0x8010f505,%eax
  cprintf("IP Address %d.%d.%d.%d\n",
801086f9:	0f b6 d0             	movzbl %al,%edx
      my_ip[0],
801086fc:	0f b6 05 04 f5 10 80 	movzbl 0x8010f504,%eax
  cprintf("IP Address %d.%d.%d.%d\n",
80108703:	0f b6 c0             	movzbl %al,%eax
80108706:	83 ec 0c             	sub    $0xc,%esp
80108709:	53                   	push   %ebx
8010870a:	51                   	push   %ecx
8010870b:	52                   	push   %edx
8010870c:	50                   	push   %eax
8010870d:	68 80 c0 10 80       	push   $0x8010c080
80108712:	e8 dd 7c ff ff       	call   801003f4 <cprintf>
80108717:	83 c4 20             	add    $0x20,%esp
  *imc = 0x0;
8010871a:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010871d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
}
80108723:	90                   	nop
80108724:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80108727:	c9                   	leave  
80108728:	c3                   	ret    

80108729 <i8254_init_recv>:

void i8254_init_recv(){
80108729:	55                   	push   %ebp
8010872a:	89 e5                	mov    %esp,%ebp
8010872c:	57                   	push   %edi
8010872d:	56                   	push   %esi
8010872e:	53                   	push   %ebx
8010872f:	83 ec 6c             	sub    $0x6c,%esp
  
  uint data_l = i8254_read_eeprom(0x0);
80108732:	83 ec 0c             	sub    $0xc,%esp
80108735:	6a 00                	push   $0x0
80108737:	e8 e8 04 00 00       	call   80108c24 <i8254_read_eeprom>
8010873c:	83 c4 10             	add    $0x10,%esp
8010873f:	89 45 d8             	mov    %eax,-0x28(%ebp)
  mac_addr[0] = data_l&0xFF;
80108742:	8b 45 d8             	mov    -0x28(%ebp),%eax
80108745:	a2 80 6e 19 80       	mov    %al,0x80196e80
  mac_addr[1] = data_l>>8;
8010874a:	8b 45 d8             	mov    -0x28(%ebp),%eax
8010874d:	c1 e8 08             	shr    $0x8,%eax
80108750:	a2 81 6e 19 80       	mov    %al,0x80196e81
  uint data_m = i8254_read_eeprom(0x1);
80108755:	83 ec 0c             	sub    $0xc,%esp
80108758:	6a 01                	push   $0x1
8010875a:	e8 c5 04 00 00       	call   80108c24 <i8254_read_eeprom>
8010875f:	83 c4 10             	add    $0x10,%esp
80108762:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  mac_addr[2] = data_m&0xFF;
80108765:	8b 45 d4             	mov    -0x2c(%ebp),%eax
80108768:	a2 82 6e 19 80       	mov    %al,0x80196e82
  mac_addr[3] = data_m>>8;
8010876d:	8b 45 d4             	mov    -0x2c(%ebp),%eax
80108770:	c1 e8 08             	shr    $0x8,%eax
80108773:	a2 83 6e 19 80       	mov    %al,0x80196e83
  uint data_h = i8254_read_eeprom(0x2);
80108778:	83 ec 0c             	sub    $0xc,%esp
8010877b:	6a 02                	push   $0x2
8010877d:	e8 a2 04 00 00       	call   80108c24 <i8254_read_eeprom>
80108782:	83 c4 10             	add    $0x10,%esp
80108785:	89 45 d0             	mov    %eax,-0x30(%ebp)
  mac_addr[4] = data_h&0xFF;
80108788:	8b 45 d0             	mov    -0x30(%ebp),%eax
8010878b:	a2 84 6e 19 80       	mov    %al,0x80196e84
  mac_addr[5] = data_h>>8;
80108790:	8b 45 d0             	mov    -0x30(%ebp),%eax
80108793:	c1 e8 08             	shr    $0x8,%eax
80108796:	a2 85 6e 19 80       	mov    %al,0x80196e85
      mac_addr[0],
      mac_addr[1],
      mac_addr[2],
      mac_addr[3],
      mac_addr[4],
      mac_addr[5]);
8010879b:	0f b6 05 85 6e 19 80 	movzbl 0x80196e85,%eax
  cprintf("MAC Address %x:%x:%x:%x:%x:%x\n",
801087a2:	0f b6 f8             	movzbl %al,%edi
      mac_addr[4],
801087a5:	0f b6 05 84 6e 19 80 	movzbl 0x80196e84,%eax
  cprintf("MAC Address %x:%x:%x:%x:%x:%x\n",
801087ac:	0f b6 f0             	movzbl %al,%esi
      mac_addr[3],
801087af:	0f b6 05 83 6e 19 80 	movzbl 0x80196e83,%eax
  cprintf("MAC Address %x:%x:%x:%x:%x:%x\n",
801087b6:	0f b6 d8             	movzbl %al,%ebx
      mac_addr[2],
801087b9:	0f b6 05 82 6e 19 80 	movzbl 0x80196e82,%eax
  cprintf("MAC Address %x:%x:%x:%x:%x:%x\n",
801087c0:	0f b6 c8             	movzbl %al,%ecx
      mac_addr[1],
801087c3:	0f b6 05 81 6e 19 80 	movzbl 0x80196e81,%eax
  cprintf("MAC Address %x:%x:%x:%x:%x:%x\n",
801087ca:	0f b6 d0             	movzbl %al,%edx
      mac_addr[0],
801087cd:	0f b6 05 80 6e 19 80 	movzbl 0x80196e80,%eax
  cprintf("MAC Address %x:%x:%x:%x:%x:%x\n",
801087d4:	0f b6 c0             	movzbl %al,%eax
801087d7:	83 ec 04             	sub    $0x4,%esp
801087da:	57                   	push   %edi
801087db:	56                   	push   %esi
801087dc:	53                   	push   %ebx
801087dd:	51                   	push   %ecx
801087de:	52                   	push   %edx
801087df:	50                   	push   %eax
801087e0:	68 98 c0 10 80       	push   $0x8010c098
801087e5:	e8 0a 7c ff ff       	call   801003f4 <cprintf>
801087ea:	83 c4 20             	add    $0x20,%esp

  uint *ral = (uint *)(base_addr + 0x5400);
801087ed:	a1 7c 6e 19 80       	mov    0x80196e7c,%eax
801087f2:	05 00 54 00 00       	add    $0x5400,%eax
801087f7:	89 45 cc             	mov    %eax,-0x34(%ebp)
  uint *rah = (uint *)(base_addr + 0x5404);
801087fa:	a1 7c 6e 19 80       	mov    0x80196e7c,%eax
801087ff:	05 04 54 00 00       	add    $0x5404,%eax
80108804:	89 45 c8             	mov    %eax,-0x38(%ebp)

  *ral = (data_l | (data_m << 16));
80108807:	8b 45 d4             	mov    -0x2c(%ebp),%eax
8010880a:	c1 e0 10             	shl    $0x10,%eax
8010880d:	0b 45 d8             	or     -0x28(%ebp),%eax
80108810:	89 c2                	mov    %eax,%edx
80108812:	8b 45 cc             	mov    -0x34(%ebp),%eax
80108815:	89 10                	mov    %edx,(%eax)
  *rah = (data_h | I8254_RAH_AS_DEST | I8254_RAH_AV);
80108817:	8b 45 d0             	mov    -0x30(%ebp),%eax
8010881a:	0d 00 00 00 80       	or     $0x80000000,%eax
8010881f:	89 c2                	mov    %eax,%edx
80108821:	8b 45 c8             	mov    -0x38(%ebp),%eax
80108824:	89 10                	mov    %edx,(%eax)

  uint *mta = (uint *)(base_addr + 0x5200);
80108826:	a1 7c 6e 19 80       	mov    0x80196e7c,%eax
8010882b:	05 00 52 00 00       	add    $0x5200,%eax
80108830:	89 45 c4             	mov    %eax,-0x3c(%ebp)
  for(int i=0;i<128;i++){
80108833:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
8010883a:	eb 19                	jmp    80108855 <i8254_init_recv+0x12c>
    mta[i] = 0;
8010883c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010883f:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80108846:	8b 45 c4             	mov    -0x3c(%ebp),%eax
80108849:	01 d0                	add    %edx,%eax
8010884b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  for(int i=0;i<128;i++){
80108851:	83 45 e4 01          	addl   $0x1,-0x1c(%ebp)
80108855:	83 7d e4 7f          	cmpl   $0x7f,-0x1c(%ebp)
80108859:	7e e1                	jle    8010883c <i8254_init_recv+0x113>
  }

  uint *ims = (uint *)(base_addr + 0xD0);
8010885b:	a1 7c 6e 19 80       	mov    0x80196e7c,%eax
80108860:	05 d0 00 00 00       	add    $0xd0,%eax
80108865:	89 45 c0             	mov    %eax,-0x40(%ebp)
  *ims = (I8254_IMS_RXT0 | I8254_IMS_RXDMT0 | I8254_IMS_RXSEQ | I8254_IMS_LSC | I8254_IMS_RXO);
80108868:	8b 45 c0             	mov    -0x40(%ebp),%eax
8010886b:	c7 00 dc 00 00 00    	movl   $0xdc,(%eax)
  uint *ics = (uint *)(base_addr + 0xC8);
80108871:	a1 7c 6e 19 80       	mov    0x80196e7c,%eax
80108876:	05 c8 00 00 00       	add    $0xc8,%eax
8010887b:	89 45 bc             	mov    %eax,-0x44(%ebp)
  *ics = (I8254_IMS_RXT0 | I8254_IMS_RXDMT0 | I8254_IMS_RXSEQ | I8254_IMS_LSC | I8254_IMS_RXO);
8010887e:	8b 45 bc             	mov    -0x44(%ebp),%eax
80108881:	c7 00 dc 00 00 00    	movl   $0xdc,(%eax)



  uint *rxdctl = (uint *)(base_addr + 0x2828);
80108887:	a1 7c 6e 19 80       	mov    0x80196e7c,%eax
8010888c:	05 28 28 00 00       	add    $0x2828,%eax
80108891:	89 45 b8             	mov    %eax,-0x48(%ebp)
  *rxdctl = 0;
80108894:	8b 45 b8             	mov    -0x48(%ebp),%eax
80108897:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

  uint *rctl = (uint *)(base_addr + 0x100);
8010889d:	a1 7c 6e 19 80       	mov    0x80196e7c,%eax
801088a2:	05 00 01 00 00       	add    $0x100,%eax
801088a7:	89 45 b4             	mov    %eax,-0x4c(%ebp)
  *rctl = (I8254_RCTL_UPE | I8254_RCTL_MPE | I8254_RCTL_BAM | I8254_RCTL_BSIZE | I8254_RCTL_SECRC);
801088aa:	8b 45 b4             	mov    -0x4c(%ebp),%eax
801088ad:	c7 00 18 80 00 04    	movl   $0x4008018,(%eax)

  uint recv_desc_addr = (uint)kalloc();
801088b3:	e8 e8 9e ff ff       	call   801027a0 <kalloc>
801088b8:	89 45 b0             	mov    %eax,-0x50(%ebp)
  uint *rdbal = (uint *)(base_addr + 0x2800);
801088bb:	a1 7c 6e 19 80       	mov    0x80196e7c,%eax
801088c0:	05 00 28 00 00       	add    $0x2800,%eax
801088c5:	89 45 ac             	mov    %eax,-0x54(%ebp)
  uint *rdbah = (uint *)(base_addr + 0x2804);
801088c8:	a1 7c 6e 19 80       	mov    0x80196e7c,%eax
801088cd:	05 04 28 00 00       	add    $0x2804,%eax
801088d2:	89 45 a8             	mov    %eax,-0x58(%ebp)
  uint *rdlen = (uint *)(base_addr + 0x2808);
801088d5:	a1 7c 6e 19 80       	mov    0x80196e7c,%eax
801088da:	05 08 28 00 00       	add    $0x2808,%eax
801088df:	89 45 a4             	mov    %eax,-0x5c(%ebp)
  uint *rdh = (uint *)(base_addr + 0x2810);
801088e2:	a1 7c 6e 19 80       	mov    0x80196e7c,%eax
801088e7:	05 10 28 00 00       	add    $0x2810,%eax
801088ec:	89 45 a0             	mov    %eax,-0x60(%ebp)
  uint *rdt = (uint *)(base_addr + 0x2818);
801088ef:	a1 7c 6e 19 80       	mov    0x80196e7c,%eax
801088f4:	05 18 28 00 00       	add    $0x2818,%eax
801088f9:	89 45 9c             	mov    %eax,-0x64(%ebp)

  *rdbal = V2P(recv_desc_addr);
801088fc:	8b 45 b0             	mov    -0x50(%ebp),%eax
801088ff:	8d 90 00 00 00 80    	lea    -0x80000000(%eax),%edx
80108905:	8b 45 ac             	mov    -0x54(%ebp),%eax
80108908:	89 10                	mov    %edx,(%eax)
  *rdbah = 0;
8010890a:	8b 45 a8             	mov    -0x58(%ebp),%eax
8010890d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  *rdlen = sizeof(struct i8254_recv_desc)*I8254_RECV_DESC_NUM;
80108913:	8b 45 a4             	mov    -0x5c(%ebp),%eax
80108916:	c7 00 00 10 00 00    	movl   $0x1000,(%eax)
  *rdh = 0;
8010891c:	8b 45 a0             	mov    -0x60(%ebp),%eax
8010891f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  *rdt = I8254_RECV_DESC_NUM;
80108925:	8b 45 9c             	mov    -0x64(%ebp),%eax
80108928:	c7 00 00 01 00 00    	movl   $0x100,(%eax)

  struct i8254_recv_desc *recv_desc = (struct i8254_recv_desc *)recv_desc_addr;
8010892e:	8b 45 b0             	mov    -0x50(%ebp),%eax
80108931:	89 45 98             	mov    %eax,-0x68(%ebp)
  for(int i=0;i<I8254_RECV_DESC_NUM;i++){
80108934:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
8010893b:	eb 73                	jmp    801089b0 <i8254_init_recv+0x287>
    recv_desc[i].padding = 0;
8010893d:	8b 45 e0             	mov    -0x20(%ebp),%eax
80108940:	c1 e0 04             	shl    $0x4,%eax
80108943:	89 c2                	mov    %eax,%edx
80108945:	8b 45 98             	mov    -0x68(%ebp),%eax
80108948:	01 d0                	add    %edx,%eax
8010894a:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
    recv_desc[i].len = 0;
80108951:	8b 45 e0             	mov    -0x20(%ebp),%eax
80108954:	c1 e0 04             	shl    $0x4,%eax
80108957:	89 c2                	mov    %eax,%edx
80108959:	8b 45 98             	mov    -0x68(%ebp),%eax
8010895c:	01 d0                	add    %edx,%eax
8010895e:	66 c7 40 08 00 00    	movw   $0x0,0x8(%eax)
    recv_desc[i].chk_sum = 0;
80108964:	8b 45 e0             	mov    -0x20(%ebp),%eax
80108967:	c1 e0 04             	shl    $0x4,%eax
8010896a:	89 c2                	mov    %eax,%edx
8010896c:	8b 45 98             	mov    -0x68(%ebp),%eax
8010896f:	01 d0                	add    %edx,%eax
80108971:	66 c7 40 0a 00 00    	movw   $0x0,0xa(%eax)
    recv_desc[i].status = 0;
80108977:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010897a:	c1 e0 04             	shl    $0x4,%eax
8010897d:	89 c2                	mov    %eax,%edx
8010897f:	8b 45 98             	mov    -0x68(%ebp),%eax
80108982:	01 d0                	add    %edx,%eax
80108984:	c6 40 0c 00          	movb   $0x0,0xc(%eax)
    recv_desc[i].errors = 0;
80108988:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010898b:	c1 e0 04             	shl    $0x4,%eax
8010898e:	89 c2                	mov    %eax,%edx
80108990:	8b 45 98             	mov    -0x68(%ebp),%eax
80108993:	01 d0                	add    %edx,%eax
80108995:	c6 40 0d 00          	movb   $0x0,0xd(%eax)
    recv_desc[i].special = 0;
80108999:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010899c:	c1 e0 04             	shl    $0x4,%eax
8010899f:	89 c2                	mov    %eax,%edx
801089a1:	8b 45 98             	mov    -0x68(%ebp),%eax
801089a4:	01 d0                	add    %edx,%eax
801089a6:	66 c7 40 0e 00 00    	movw   $0x0,0xe(%eax)
  for(int i=0;i<I8254_RECV_DESC_NUM;i++){
801089ac:	83 45 e0 01          	addl   $0x1,-0x20(%ebp)
801089b0:	81 7d e0 ff 00 00 00 	cmpl   $0xff,-0x20(%ebp)
801089b7:	7e 84                	jle    8010893d <i8254_init_recv+0x214>
  }

  for(int i=0;i<(I8254_RECV_DESC_NUM)/2;i++){
801089b9:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
801089c0:	eb 57                	jmp    80108a19 <i8254_init_recv+0x2f0>
    uint buf_addr = (uint)kalloc();
801089c2:	e8 d9 9d ff ff       	call   801027a0 <kalloc>
801089c7:	89 45 94             	mov    %eax,-0x6c(%ebp)
    if(buf_addr == 0){
801089ca:	83 7d 94 00          	cmpl   $0x0,-0x6c(%ebp)
801089ce:	75 12                	jne    801089e2 <i8254_init_recv+0x2b9>
      cprintf("failed to allocate buffer area\n");
801089d0:	83 ec 0c             	sub    $0xc,%esp
801089d3:	68 b8 c0 10 80       	push   $0x8010c0b8
801089d8:	e8 17 7a ff ff       	call   801003f4 <cprintf>
801089dd:	83 c4 10             	add    $0x10,%esp
      break;
801089e0:	eb 3d                	jmp    80108a1f <i8254_init_recv+0x2f6>
    }
    recv_desc[i].buf_addr = V2P(buf_addr);
801089e2:	8b 45 dc             	mov    -0x24(%ebp),%eax
801089e5:	c1 e0 04             	shl    $0x4,%eax
801089e8:	89 c2                	mov    %eax,%edx
801089ea:	8b 45 98             	mov    -0x68(%ebp),%eax
801089ed:	01 d0                	add    %edx,%eax
801089ef:	8b 55 94             	mov    -0x6c(%ebp),%edx
801089f2:	81 c2 00 00 00 80    	add    $0x80000000,%edx
801089f8:	89 10                	mov    %edx,(%eax)
    recv_desc[i+1].buf_addr = V2P(buf_addr + 0x800);
801089fa:	8b 45 dc             	mov    -0x24(%ebp),%eax
801089fd:	83 c0 01             	add    $0x1,%eax
80108a00:	c1 e0 04             	shl    $0x4,%eax
80108a03:	89 c2                	mov    %eax,%edx
80108a05:	8b 45 98             	mov    -0x68(%ebp),%eax
80108a08:	01 d0                	add    %edx,%eax
80108a0a:	8b 55 94             	mov    -0x6c(%ebp),%edx
80108a0d:	81 ea 00 f8 ff 7f    	sub    $0x7ffff800,%edx
80108a13:	89 10                	mov    %edx,(%eax)
  for(int i=0;i<(I8254_RECV_DESC_NUM)/2;i++){
80108a15:	83 45 dc 01          	addl   $0x1,-0x24(%ebp)
80108a19:	83 7d dc 7f          	cmpl   $0x7f,-0x24(%ebp)
80108a1d:	7e a3                	jle    801089c2 <i8254_init_recv+0x299>
  }

  *rctl |= I8254_RCTL_EN;
80108a1f:	8b 45 b4             	mov    -0x4c(%ebp),%eax
80108a22:	8b 00                	mov    (%eax),%eax
80108a24:	83 c8 02             	or     $0x2,%eax
80108a27:	89 c2                	mov    %eax,%edx
80108a29:	8b 45 b4             	mov    -0x4c(%ebp),%eax
80108a2c:	89 10                	mov    %edx,(%eax)
  cprintf("E1000 Recieve Initialize Done\n");
80108a2e:	83 ec 0c             	sub    $0xc,%esp
80108a31:	68 d8 c0 10 80       	push   $0x8010c0d8
80108a36:	e8 b9 79 ff ff       	call   801003f4 <cprintf>
80108a3b:	83 c4 10             	add    $0x10,%esp
}
80108a3e:	90                   	nop
80108a3f:	8d 65 f4             	lea    -0xc(%ebp),%esp
80108a42:	5b                   	pop    %ebx
80108a43:	5e                   	pop    %esi
80108a44:	5f                   	pop    %edi
80108a45:	5d                   	pop    %ebp
80108a46:	c3                   	ret    

80108a47 <i8254_init_send>:

void i8254_init_send(){
80108a47:	55                   	push   %ebp
80108a48:	89 e5                	mov    %esp,%ebp
80108a4a:	83 ec 48             	sub    $0x48,%esp
  uint *txdctl = (uint *)(base_addr + 0x3828);
80108a4d:	a1 7c 6e 19 80       	mov    0x80196e7c,%eax
80108a52:	05 28 38 00 00       	add    $0x3828,%eax
80108a57:	89 45 ec             	mov    %eax,-0x14(%ebp)
  *txdctl = (I8254_TXDCTL_WTHRESH | I8254_TXDCTL_GRAN_DESC);
80108a5a:	8b 45 ec             	mov    -0x14(%ebp),%eax
80108a5d:	c7 00 00 00 01 01    	movl   $0x1010000,(%eax)

  uint tx_desc_addr = (uint)kalloc();
80108a63:	e8 38 9d ff ff       	call   801027a0 <kalloc>
80108a68:	89 45 e8             	mov    %eax,-0x18(%ebp)
  uint *tdbal = (uint *)(base_addr + 0x3800);
80108a6b:	a1 7c 6e 19 80       	mov    0x80196e7c,%eax
80108a70:	05 00 38 00 00       	add    $0x3800,%eax
80108a75:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  uint *tdbah = (uint *)(base_addr + 0x3804);
80108a78:	a1 7c 6e 19 80       	mov    0x80196e7c,%eax
80108a7d:	05 04 38 00 00       	add    $0x3804,%eax
80108a82:	89 45 e0             	mov    %eax,-0x20(%ebp)
  uint *tdlen = (uint *)(base_addr + 0x3808);
80108a85:	a1 7c 6e 19 80       	mov    0x80196e7c,%eax
80108a8a:	05 08 38 00 00       	add    $0x3808,%eax
80108a8f:	89 45 dc             	mov    %eax,-0x24(%ebp)

  *tdbal = V2P(tx_desc_addr);
80108a92:	8b 45 e8             	mov    -0x18(%ebp),%eax
80108a95:	8d 90 00 00 00 80    	lea    -0x80000000(%eax),%edx
80108a9b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80108a9e:	89 10                	mov    %edx,(%eax)
  *tdbah = 0;
80108aa0:	8b 45 e0             	mov    -0x20(%ebp),%eax
80108aa3:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  *tdlen = sizeof(struct i8254_send_desc)*I8254_SEND_DESC_NUM;
80108aa9:	8b 45 dc             	mov    -0x24(%ebp),%eax
80108aac:	c7 00 00 10 00 00    	movl   $0x1000,(%eax)
  uint *tdh = (uint *)(base_addr + 0x3810);
80108ab2:	a1 7c 6e 19 80       	mov    0x80196e7c,%eax
80108ab7:	05 10 38 00 00       	add    $0x3810,%eax
80108abc:	89 45 d8             	mov    %eax,-0x28(%ebp)
  uint *tdt = (uint *)(base_addr + 0x3818);
80108abf:	a1 7c 6e 19 80       	mov    0x80196e7c,%eax
80108ac4:	05 18 38 00 00       	add    $0x3818,%eax
80108ac9:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  
  *tdh = 0;
80108acc:	8b 45 d8             	mov    -0x28(%ebp),%eax
80108acf:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  *tdt = 0;
80108ad5:	8b 45 d4             	mov    -0x2c(%ebp),%eax
80108ad8:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

  struct i8254_send_desc *send_desc = (struct i8254_send_desc *)tx_desc_addr;
80108ade:	8b 45 e8             	mov    -0x18(%ebp),%eax
80108ae1:	89 45 d0             	mov    %eax,-0x30(%ebp)
  for(int i=0;i<I8254_SEND_DESC_NUM;i++){
80108ae4:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80108aeb:	e9 82 00 00 00       	jmp    80108b72 <i8254_init_send+0x12b>
    send_desc[i].padding = 0;
80108af0:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108af3:	c1 e0 04             	shl    $0x4,%eax
80108af6:	89 c2                	mov    %eax,%edx
80108af8:	8b 45 d0             	mov    -0x30(%ebp),%eax
80108afb:	01 d0                	add    %edx,%eax
80108afd:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
    send_desc[i].len = 0;
80108b04:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108b07:	c1 e0 04             	shl    $0x4,%eax
80108b0a:	89 c2                	mov    %eax,%edx
80108b0c:	8b 45 d0             	mov    -0x30(%ebp),%eax
80108b0f:	01 d0                	add    %edx,%eax
80108b11:	66 c7 40 08 00 00    	movw   $0x0,0x8(%eax)
    send_desc[i].cso = 0;
80108b17:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108b1a:	c1 e0 04             	shl    $0x4,%eax
80108b1d:	89 c2                	mov    %eax,%edx
80108b1f:	8b 45 d0             	mov    -0x30(%ebp),%eax
80108b22:	01 d0                	add    %edx,%eax
80108b24:	c6 40 0a 00          	movb   $0x0,0xa(%eax)
    send_desc[i].cmd = 0;
80108b28:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108b2b:	c1 e0 04             	shl    $0x4,%eax
80108b2e:	89 c2                	mov    %eax,%edx
80108b30:	8b 45 d0             	mov    -0x30(%ebp),%eax
80108b33:	01 d0                	add    %edx,%eax
80108b35:	c6 40 0b 00          	movb   $0x0,0xb(%eax)
    send_desc[i].sta = 0;
80108b39:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108b3c:	c1 e0 04             	shl    $0x4,%eax
80108b3f:	89 c2                	mov    %eax,%edx
80108b41:	8b 45 d0             	mov    -0x30(%ebp),%eax
80108b44:	01 d0                	add    %edx,%eax
80108b46:	c6 40 0c 00          	movb   $0x0,0xc(%eax)
    send_desc[i].css = 0;
80108b4a:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108b4d:	c1 e0 04             	shl    $0x4,%eax
80108b50:	89 c2                	mov    %eax,%edx
80108b52:	8b 45 d0             	mov    -0x30(%ebp),%eax
80108b55:	01 d0                	add    %edx,%eax
80108b57:	c6 40 0d 00          	movb   $0x0,0xd(%eax)
    send_desc[i].special = 0;
80108b5b:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108b5e:	c1 e0 04             	shl    $0x4,%eax
80108b61:	89 c2                	mov    %eax,%edx
80108b63:	8b 45 d0             	mov    -0x30(%ebp),%eax
80108b66:	01 d0                	add    %edx,%eax
80108b68:	66 c7 40 0e 00 00    	movw   $0x0,0xe(%eax)
  for(int i=0;i<I8254_SEND_DESC_NUM;i++){
80108b6e:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80108b72:	81 7d f4 ff 00 00 00 	cmpl   $0xff,-0xc(%ebp)
80108b79:	0f 8e 71 ff ff ff    	jle    80108af0 <i8254_init_send+0xa9>
  }

  for(int i=0;i<(I8254_SEND_DESC_NUM)/2;i++){
80108b7f:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
80108b86:	eb 57                	jmp    80108bdf <i8254_init_send+0x198>
    uint buf_addr = (uint)kalloc();
80108b88:	e8 13 9c ff ff       	call   801027a0 <kalloc>
80108b8d:	89 45 cc             	mov    %eax,-0x34(%ebp)
    if(buf_addr == 0){
80108b90:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
80108b94:	75 12                	jne    80108ba8 <i8254_init_send+0x161>
      cprintf("failed to allocate buffer area\n");
80108b96:	83 ec 0c             	sub    $0xc,%esp
80108b99:	68 b8 c0 10 80       	push   $0x8010c0b8
80108b9e:	e8 51 78 ff ff       	call   801003f4 <cprintf>
80108ba3:	83 c4 10             	add    $0x10,%esp
      break;
80108ba6:	eb 3d                	jmp    80108be5 <i8254_init_send+0x19e>
    }
    send_desc[i].buf_addr = V2P(buf_addr);
80108ba8:	8b 45 f0             	mov    -0x10(%ebp),%eax
80108bab:	c1 e0 04             	shl    $0x4,%eax
80108bae:	89 c2                	mov    %eax,%edx
80108bb0:	8b 45 d0             	mov    -0x30(%ebp),%eax
80108bb3:	01 d0                	add    %edx,%eax
80108bb5:	8b 55 cc             	mov    -0x34(%ebp),%edx
80108bb8:	81 c2 00 00 00 80    	add    $0x80000000,%edx
80108bbe:	89 10                	mov    %edx,(%eax)
    send_desc[i+1].buf_addr = V2P(buf_addr + 0x800);
80108bc0:	8b 45 f0             	mov    -0x10(%ebp),%eax
80108bc3:	83 c0 01             	add    $0x1,%eax
80108bc6:	c1 e0 04             	shl    $0x4,%eax
80108bc9:	89 c2                	mov    %eax,%edx
80108bcb:	8b 45 d0             	mov    -0x30(%ebp),%eax
80108bce:	01 d0                	add    %edx,%eax
80108bd0:	8b 55 cc             	mov    -0x34(%ebp),%edx
80108bd3:	81 ea 00 f8 ff 7f    	sub    $0x7ffff800,%edx
80108bd9:	89 10                	mov    %edx,(%eax)
  for(int i=0;i<(I8254_SEND_DESC_NUM)/2;i++){
80108bdb:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
80108bdf:	83 7d f0 7f          	cmpl   $0x7f,-0x10(%ebp)
80108be3:	7e a3                	jle    80108b88 <i8254_init_send+0x141>
  }

  uint *tctl = (uint *)(base_addr + 0x400);
80108be5:	a1 7c 6e 19 80       	mov    0x80196e7c,%eax
80108bea:	05 00 04 00 00       	add    $0x400,%eax
80108bef:	89 45 c8             	mov    %eax,-0x38(%ebp)
  *tctl = (I8254_TCTL_EN | I8254_TCTL_PSP | I8254_TCTL_COLD | I8254_TCTL_CT);
80108bf2:	8b 45 c8             	mov    -0x38(%ebp),%eax
80108bf5:	c7 00 fa 00 04 00    	movl   $0x400fa,(%eax)

  uint *tipg = (uint *)(base_addr + 0x410);
80108bfb:	a1 7c 6e 19 80       	mov    0x80196e7c,%eax
80108c00:	05 10 04 00 00       	add    $0x410,%eax
80108c05:	89 45 c4             	mov    %eax,-0x3c(%ebp)
  *tipg = (10 | (10<<10) | (10<<20));
80108c08:	8b 45 c4             	mov    -0x3c(%ebp),%eax
80108c0b:	c7 00 0a 28 a0 00    	movl   $0xa0280a,(%eax)
  cprintf("E1000 Transmit Initialize Done\n");
80108c11:	83 ec 0c             	sub    $0xc,%esp
80108c14:	68 f8 c0 10 80       	push   $0x8010c0f8
80108c19:	e8 d6 77 ff ff       	call   801003f4 <cprintf>
80108c1e:	83 c4 10             	add    $0x10,%esp

}
80108c21:	90                   	nop
80108c22:	c9                   	leave  
80108c23:	c3                   	ret    

80108c24 <i8254_read_eeprom>:
uint i8254_read_eeprom(uint addr){
80108c24:	55                   	push   %ebp
80108c25:	89 e5                	mov    %esp,%ebp
80108c27:	83 ec 18             	sub    $0x18,%esp
  uint *eerd = (uint *)(base_addr + 0x14);
80108c2a:	a1 7c 6e 19 80       	mov    0x80196e7c,%eax
80108c2f:	83 c0 14             	add    $0x14,%eax
80108c32:	89 45 f4             	mov    %eax,-0xc(%ebp)
  *eerd = (((addr & 0xFF) << 8) | 1);
80108c35:	8b 45 08             	mov    0x8(%ebp),%eax
80108c38:	c1 e0 08             	shl    $0x8,%eax
80108c3b:	0f b7 c0             	movzwl %ax,%eax
80108c3e:	83 c8 01             	or     $0x1,%eax
80108c41:	89 c2                	mov    %eax,%edx
80108c43:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108c46:	89 10                	mov    %edx,(%eax)
  while(1){
    cprintf("");
80108c48:	83 ec 0c             	sub    $0xc,%esp
80108c4b:	68 18 c1 10 80       	push   $0x8010c118
80108c50:	e8 9f 77 ff ff       	call   801003f4 <cprintf>
80108c55:	83 c4 10             	add    $0x10,%esp
    volatile uint data = *eerd;
80108c58:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108c5b:	8b 00                	mov    (%eax),%eax
80108c5d:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if((data & (1<<4)) != 0){
80108c60:	8b 45 f0             	mov    -0x10(%ebp),%eax
80108c63:	83 e0 10             	and    $0x10,%eax
80108c66:	85 c0                	test   %eax,%eax
80108c68:	75 02                	jne    80108c6c <i8254_read_eeprom+0x48>
  while(1){
80108c6a:	eb dc                	jmp    80108c48 <i8254_read_eeprom+0x24>
      break;
80108c6c:	90                   	nop
    }
  }

  return (*eerd >> 16) & 0xFFFF;
80108c6d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108c70:	8b 00                	mov    (%eax),%eax
80108c72:	c1 e8 10             	shr    $0x10,%eax
}
80108c75:	c9                   	leave  
80108c76:	c3                   	ret    

80108c77 <i8254_recv>:
void i8254_recv(){
80108c77:	55                   	push   %ebp
80108c78:	89 e5                	mov    %esp,%ebp
80108c7a:	83 ec 28             	sub    $0x28,%esp
  uint *rdh = (uint *)(base_addr + 0x2810);
80108c7d:	a1 7c 6e 19 80       	mov    0x80196e7c,%eax
80108c82:	05 10 28 00 00       	add    $0x2810,%eax
80108c87:	89 45 f4             	mov    %eax,-0xc(%ebp)
  uint *rdt = (uint *)(base_addr + 0x2818);
80108c8a:	a1 7c 6e 19 80       	mov    0x80196e7c,%eax
80108c8f:	05 18 28 00 00       	add    $0x2818,%eax
80108c94:	89 45 f0             	mov    %eax,-0x10(%ebp)
//  uint *torl = (uint *)(base_addr + 0x40C0);
//  uint *tpr = (uint *)(base_addr + 0x40D0);
//  uint *icr = (uint *)(base_addr + 0xC0);
  uint *rdbal = (uint *)(base_addr + 0x2800);
80108c97:	a1 7c 6e 19 80       	mov    0x80196e7c,%eax
80108c9c:	05 00 28 00 00       	add    $0x2800,%eax
80108ca1:	89 45 ec             	mov    %eax,-0x14(%ebp)
  struct i8254_recv_desc *recv_desc = (struct i8254_recv_desc *)(P2V(*rdbal));
80108ca4:	8b 45 ec             	mov    -0x14(%ebp),%eax
80108ca7:	8b 00                	mov    (%eax),%eax
80108ca9:	05 00 00 00 80       	add    $0x80000000,%eax
80108cae:	89 45 e8             	mov    %eax,-0x18(%ebp)
  while(1){
    int rx_available = (I8254_RECV_DESC_NUM - *rdt + *rdh)%I8254_RECV_DESC_NUM;
80108cb1:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108cb4:	8b 10                	mov    (%eax),%edx
80108cb6:	8b 45 f0             	mov    -0x10(%ebp),%eax
80108cb9:	8b 08                	mov    (%eax),%ecx
80108cbb:	89 d0                	mov    %edx,%eax
80108cbd:	29 c8                	sub    %ecx,%eax
80108cbf:	25 ff 00 00 00       	and    $0xff,%eax
80108cc4:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(rx_available > 0){
80108cc7:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
80108ccb:	7e 37                	jle    80108d04 <i8254_recv+0x8d>
      uint buffer_addr = P2V_WO(recv_desc[*rdt].buf_addr);
80108ccd:	8b 45 f0             	mov    -0x10(%ebp),%eax
80108cd0:	8b 00                	mov    (%eax),%eax
80108cd2:	c1 e0 04             	shl    $0x4,%eax
80108cd5:	89 c2                	mov    %eax,%edx
80108cd7:	8b 45 e8             	mov    -0x18(%ebp),%eax
80108cda:	01 d0                	add    %edx,%eax
80108cdc:	8b 00                	mov    (%eax),%eax
80108cde:	05 00 00 00 80       	add    $0x80000000,%eax
80108ce3:	89 45 e0             	mov    %eax,-0x20(%ebp)
      *rdt = (*rdt + 1)%I8254_RECV_DESC_NUM;
80108ce6:	8b 45 f0             	mov    -0x10(%ebp),%eax
80108ce9:	8b 00                	mov    (%eax),%eax
80108ceb:	83 c0 01             	add    $0x1,%eax
80108cee:	0f b6 d0             	movzbl %al,%edx
80108cf1:	8b 45 f0             	mov    -0x10(%ebp),%eax
80108cf4:	89 10                	mov    %edx,(%eax)
      eth_proc(buffer_addr);
80108cf6:	83 ec 0c             	sub    $0xc,%esp
80108cf9:	ff 75 e0             	push   -0x20(%ebp)
80108cfc:	e8 15 09 00 00       	call   80109616 <eth_proc>
80108d01:	83 c4 10             	add    $0x10,%esp
    }
    if(*rdt == *rdh) {
80108d04:	8b 45 f0             	mov    -0x10(%ebp),%eax
80108d07:	8b 10                	mov    (%eax),%edx
80108d09:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108d0c:	8b 00                	mov    (%eax),%eax
80108d0e:	39 c2                	cmp    %eax,%edx
80108d10:	75 9f                	jne    80108cb1 <i8254_recv+0x3a>
      (*rdt)--;
80108d12:	8b 45 f0             	mov    -0x10(%ebp),%eax
80108d15:	8b 00                	mov    (%eax),%eax
80108d17:	8d 50 ff             	lea    -0x1(%eax),%edx
80108d1a:	8b 45 f0             	mov    -0x10(%ebp),%eax
80108d1d:	89 10                	mov    %edx,(%eax)
  while(1){
80108d1f:	eb 90                	jmp    80108cb1 <i8254_recv+0x3a>

80108d21 <i8254_send>:
    }
  }
}

int i8254_send(const uint pkt_addr,uint len){
80108d21:	55                   	push   %ebp
80108d22:	89 e5                	mov    %esp,%ebp
80108d24:	83 ec 28             	sub    $0x28,%esp
  uint *tdh = (uint *)(base_addr + 0x3810);
80108d27:	a1 7c 6e 19 80       	mov    0x80196e7c,%eax
80108d2c:	05 10 38 00 00       	add    $0x3810,%eax
80108d31:	89 45 f4             	mov    %eax,-0xc(%ebp)
  uint *tdt = (uint *)(base_addr + 0x3818);
80108d34:	a1 7c 6e 19 80       	mov    0x80196e7c,%eax
80108d39:	05 18 38 00 00       	add    $0x3818,%eax
80108d3e:	89 45 f0             	mov    %eax,-0x10(%ebp)
  uint *tdbal = (uint *)(base_addr + 0x3800);
80108d41:	a1 7c 6e 19 80       	mov    0x80196e7c,%eax
80108d46:	05 00 38 00 00       	add    $0x3800,%eax
80108d4b:	89 45 ec             	mov    %eax,-0x14(%ebp)
  struct i8254_send_desc *txdesc = (struct i8254_send_desc *)P2V_WO(*tdbal);
80108d4e:	8b 45 ec             	mov    -0x14(%ebp),%eax
80108d51:	8b 00                	mov    (%eax),%eax
80108d53:	05 00 00 00 80       	add    $0x80000000,%eax
80108d58:	89 45 e8             	mov    %eax,-0x18(%ebp)
  int tx_available = I8254_SEND_DESC_NUM - ((I8254_SEND_DESC_NUM - *tdh + *tdt) % I8254_SEND_DESC_NUM);
80108d5b:	8b 45 f0             	mov    -0x10(%ebp),%eax
80108d5e:	8b 10                	mov    (%eax),%edx
80108d60:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108d63:	8b 08                	mov    (%eax),%ecx
80108d65:	89 d0                	mov    %edx,%eax
80108d67:	29 c8                	sub    %ecx,%eax
80108d69:	0f b6 d0             	movzbl %al,%edx
80108d6c:	b8 00 01 00 00       	mov    $0x100,%eax
80108d71:	29 d0                	sub    %edx,%eax
80108d73:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  uint index = *tdt%I8254_SEND_DESC_NUM;
80108d76:	8b 45 f0             	mov    -0x10(%ebp),%eax
80108d79:	8b 00                	mov    (%eax),%eax
80108d7b:	25 ff 00 00 00       	and    $0xff,%eax
80108d80:	89 45 e0             	mov    %eax,-0x20(%ebp)
  if(tx_available > 0) {
80108d83:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
80108d87:	0f 8e a8 00 00 00    	jle    80108e35 <i8254_send+0x114>
    memmove(P2V_WO((void *)txdesc[index].buf_addr),(void *)pkt_addr,len);
80108d8d:	8b 45 08             	mov    0x8(%ebp),%eax
80108d90:	8b 55 e0             	mov    -0x20(%ebp),%edx
80108d93:	89 d1                	mov    %edx,%ecx
80108d95:	c1 e1 04             	shl    $0x4,%ecx
80108d98:	8b 55 e8             	mov    -0x18(%ebp),%edx
80108d9b:	01 ca                	add    %ecx,%edx
80108d9d:	8b 12                	mov    (%edx),%edx
80108d9f:	81 c2 00 00 00 80    	add    $0x80000000,%edx
80108da5:	83 ec 04             	sub    $0x4,%esp
80108da8:	ff 75 0c             	push   0xc(%ebp)
80108dab:	50                   	push   %eax
80108dac:	52                   	push   %edx
80108dad:	e8 10 bf ff ff       	call   80104cc2 <memmove>
80108db2:	83 c4 10             	add    $0x10,%esp
    txdesc[index].len = len;
80108db5:	8b 45 e0             	mov    -0x20(%ebp),%eax
80108db8:	c1 e0 04             	shl    $0x4,%eax
80108dbb:	89 c2                	mov    %eax,%edx
80108dbd:	8b 45 e8             	mov    -0x18(%ebp),%eax
80108dc0:	01 d0                	add    %edx,%eax
80108dc2:	8b 55 0c             	mov    0xc(%ebp),%edx
80108dc5:	66 89 50 08          	mov    %dx,0x8(%eax)
    txdesc[index].sta = 0;
80108dc9:	8b 45 e0             	mov    -0x20(%ebp),%eax
80108dcc:	c1 e0 04             	shl    $0x4,%eax
80108dcf:	89 c2                	mov    %eax,%edx
80108dd1:	8b 45 e8             	mov    -0x18(%ebp),%eax
80108dd4:	01 d0                	add    %edx,%eax
80108dd6:	c6 40 0c 00          	movb   $0x0,0xc(%eax)
    txdesc[index].css = 0;
80108dda:	8b 45 e0             	mov    -0x20(%ebp),%eax
80108ddd:	c1 e0 04             	shl    $0x4,%eax
80108de0:	89 c2                	mov    %eax,%edx
80108de2:	8b 45 e8             	mov    -0x18(%ebp),%eax
80108de5:	01 d0                	add    %edx,%eax
80108de7:	c6 40 0d 00          	movb   $0x0,0xd(%eax)
    txdesc[index].cmd = 0xb;
80108deb:	8b 45 e0             	mov    -0x20(%ebp),%eax
80108dee:	c1 e0 04             	shl    $0x4,%eax
80108df1:	89 c2                	mov    %eax,%edx
80108df3:	8b 45 e8             	mov    -0x18(%ebp),%eax
80108df6:	01 d0                	add    %edx,%eax
80108df8:	c6 40 0b 0b          	movb   $0xb,0xb(%eax)
    txdesc[index].special = 0;
80108dfc:	8b 45 e0             	mov    -0x20(%ebp),%eax
80108dff:	c1 e0 04             	shl    $0x4,%eax
80108e02:	89 c2                	mov    %eax,%edx
80108e04:	8b 45 e8             	mov    -0x18(%ebp),%eax
80108e07:	01 d0                	add    %edx,%eax
80108e09:	66 c7 40 0e 00 00    	movw   $0x0,0xe(%eax)
    txdesc[index].cso = 0;
80108e0f:	8b 45 e0             	mov    -0x20(%ebp),%eax
80108e12:	c1 e0 04             	shl    $0x4,%eax
80108e15:	89 c2                	mov    %eax,%edx
80108e17:	8b 45 e8             	mov    -0x18(%ebp),%eax
80108e1a:	01 d0                	add    %edx,%eax
80108e1c:	c6 40 0a 00          	movb   $0x0,0xa(%eax)
    *tdt = (*tdt + 1)%I8254_SEND_DESC_NUM;
80108e20:	8b 45 f0             	mov    -0x10(%ebp),%eax
80108e23:	8b 00                	mov    (%eax),%eax
80108e25:	83 c0 01             	add    $0x1,%eax
80108e28:	0f b6 d0             	movzbl %al,%edx
80108e2b:	8b 45 f0             	mov    -0x10(%ebp),%eax
80108e2e:	89 10                	mov    %edx,(%eax)
    return len;
80108e30:	8b 45 0c             	mov    0xc(%ebp),%eax
80108e33:	eb 05                	jmp    80108e3a <i8254_send+0x119>
  }else{
    return -1;
80108e35:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  }
  return 0;
}
80108e3a:	c9                   	leave  
80108e3b:	c3                   	ret    

80108e3c <i8254_intr>:

void i8254_intr(){
80108e3c:	55                   	push   %ebp
80108e3d:	89 e5                	mov    %esp,%ebp
  *intr_addr = 0xEEEEEE;
80108e3f:	a1 88 6e 19 80       	mov    0x80196e88,%eax
80108e44:	c7 00 ee ee ee 00    	movl   $0xeeeeee,(%eax)
}
80108e4a:	90                   	nop
80108e4b:	5d                   	pop    %ebp
80108e4c:	c3                   	ret    

80108e4d <arp_proc>:
extern uchar mac_addr[6];
extern uchar my_ip[4];

struct arp_entry arp_table[ARP_TABLE_MAX] = {0};

int arp_proc(uint buffer_addr){
80108e4d:	55                   	push   %ebp
80108e4e:	89 e5                	mov    %esp,%ebp
80108e50:	83 ec 18             	sub    $0x18,%esp
  struct arp_pkt *arp_p = (struct arp_pkt *)(buffer_addr);
80108e53:	8b 45 08             	mov    0x8(%ebp),%eax
80108e56:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(arp_p->hrd_type != ARP_HARDWARE_TYPE) return -1;
80108e59:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108e5c:	0f b7 00             	movzwl (%eax),%eax
80108e5f:	66 3d 00 01          	cmp    $0x100,%ax
80108e63:	74 0a                	je     80108e6f <arp_proc+0x22>
80108e65:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80108e6a:	e9 4f 01 00 00       	jmp    80108fbe <arp_proc+0x171>
  if(arp_p->pro_type != ARP_PROTOCOL_TYPE) return -1;
80108e6f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108e72:	0f b7 40 02          	movzwl 0x2(%eax),%eax
80108e76:	66 83 f8 08          	cmp    $0x8,%ax
80108e7a:	74 0a                	je     80108e86 <arp_proc+0x39>
80108e7c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80108e81:	e9 38 01 00 00       	jmp    80108fbe <arp_proc+0x171>
  if(arp_p->hrd_len != 6) return -1;
80108e86:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108e89:	0f b6 40 04          	movzbl 0x4(%eax),%eax
80108e8d:	3c 06                	cmp    $0x6,%al
80108e8f:	74 0a                	je     80108e9b <arp_proc+0x4e>
80108e91:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80108e96:	e9 23 01 00 00       	jmp    80108fbe <arp_proc+0x171>
  if(arp_p->pro_len != 4) return -1;
80108e9b:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108e9e:	0f b6 40 05          	movzbl 0x5(%eax),%eax
80108ea2:	3c 04                	cmp    $0x4,%al
80108ea4:	74 0a                	je     80108eb0 <arp_proc+0x63>
80108ea6:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80108eab:	e9 0e 01 00 00       	jmp    80108fbe <arp_proc+0x171>
  if(memcmp(my_ip,arp_p->dst_ip,4) != 0 && memcmp(my_ip,arp_p->src_ip,4) != 0) return -1;
80108eb0:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108eb3:	83 c0 18             	add    $0x18,%eax
80108eb6:	83 ec 04             	sub    $0x4,%esp
80108eb9:	6a 04                	push   $0x4
80108ebb:	50                   	push   %eax
80108ebc:	68 04 f5 10 80       	push   $0x8010f504
80108ec1:	e8 a4 bd ff ff       	call   80104c6a <memcmp>
80108ec6:	83 c4 10             	add    $0x10,%esp
80108ec9:	85 c0                	test   %eax,%eax
80108ecb:	74 27                	je     80108ef4 <arp_proc+0xa7>
80108ecd:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108ed0:	83 c0 0e             	add    $0xe,%eax
80108ed3:	83 ec 04             	sub    $0x4,%esp
80108ed6:	6a 04                	push   $0x4
80108ed8:	50                   	push   %eax
80108ed9:	68 04 f5 10 80       	push   $0x8010f504
80108ede:	e8 87 bd ff ff       	call   80104c6a <memcmp>
80108ee3:	83 c4 10             	add    $0x10,%esp
80108ee6:	85 c0                	test   %eax,%eax
80108ee8:	74 0a                	je     80108ef4 <arp_proc+0xa7>
80108eea:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80108eef:	e9 ca 00 00 00       	jmp    80108fbe <arp_proc+0x171>
  if(arp_p->op == ARP_OPS_REQUEST && memcmp(my_ip,arp_p->dst_ip,4) == 0){
80108ef4:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108ef7:	0f b7 40 06          	movzwl 0x6(%eax),%eax
80108efb:	66 3d 00 01          	cmp    $0x100,%ax
80108eff:	75 69                	jne    80108f6a <arp_proc+0x11d>
80108f01:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108f04:	83 c0 18             	add    $0x18,%eax
80108f07:	83 ec 04             	sub    $0x4,%esp
80108f0a:	6a 04                	push   $0x4
80108f0c:	50                   	push   %eax
80108f0d:	68 04 f5 10 80       	push   $0x8010f504
80108f12:	e8 53 bd ff ff       	call   80104c6a <memcmp>
80108f17:	83 c4 10             	add    $0x10,%esp
80108f1a:	85 c0                	test   %eax,%eax
80108f1c:	75 4c                	jne    80108f6a <arp_proc+0x11d>
    uint send = (uint)kalloc();
80108f1e:	e8 7d 98 ff ff       	call   801027a0 <kalloc>
80108f23:	89 45 f0             	mov    %eax,-0x10(%ebp)
    uint send_size=0;
80108f26:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
    arp_reply_pkt_create(arp_p,send,&send_size);
80108f2d:	83 ec 04             	sub    $0x4,%esp
80108f30:	8d 45 ec             	lea    -0x14(%ebp),%eax
80108f33:	50                   	push   %eax
80108f34:	ff 75 f0             	push   -0x10(%ebp)
80108f37:	ff 75 f4             	push   -0xc(%ebp)
80108f3a:	e8 1f 04 00 00       	call   8010935e <arp_reply_pkt_create>
80108f3f:	83 c4 10             	add    $0x10,%esp
    i8254_send(send,send_size);
80108f42:	8b 45 ec             	mov    -0x14(%ebp),%eax
80108f45:	83 ec 08             	sub    $0x8,%esp
80108f48:	50                   	push   %eax
80108f49:	ff 75 f0             	push   -0x10(%ebp)
80108f4c:	e8 d0 fd ff ff       	call   80108d21 <i8254_send>
80108f51:	83 c4 10             	add    $0x10,%esp
    kfree((char *)send);
80108f54:	8b 45 f0             	mov    -0x10(%ebp),%eax
80108f57:	83 ec 0c             	sub    $0xc,%esp
80108f5a:	50                   	push   %eax
80108f5b:	e8 a6 97 ff ff       	call   80102706 <kfree>
80108f60:	83 c4 10             	add    $0x10,%esp
    return ARP_CREATED_REPLY;
80108f63:	b8 02 00 00 00       	mov    $0x2,%eax
80108f68:	eb 54                	jmp    80108fbe <arp_proc+0x171>
  }else if(arp_p->op == ARP_OPS_REPLY && memcmp(my_ip,arp_p->dst_ip,4) == 0){
80108f6a:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108f6d:	0f b7 40 06          	movzwl 0x6(%eax),%eax
80108f71:	66 3d 00 02          	cmp    $0x200,%ax
80108f75:	75 42                	jne    80108fb9 <arp_proc+0x16c>
80108f77:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108f7a:	83 c0 18             	add    $0x18,%eax
80108f7d:	83 ec 04             	sub    $0x4,%esp
80108f80:	6a 04                	push   $0x4
80108f82:	50                   	push   %eax
80108f83:	68 04 f5 10 80       	push   $0x8010f504
80108f88:	e8 dd bc ff ff       	call   80104c6a <memcmp>
80108f8d:	83 c4 10             	add    $0x10,%esp
80108f90:	85 c0                	test   %eax,%eax
80108f92:	75 25                	jne    80108fb9 <arp_proc+0x16c>
    cprintf("ARP TABLE UPDATED\n");
80108f94:	83 ec 0c             	sub    $0xc,%esp
80108f97:	68 1c c1 10 80       	push   $0x8010c11c
80108f9c:	e8 53 74 ff ff       	call   801003f4 <cprintf>
80108fa1:	83 c4 10             	add    $0x10,%esp
    arp_table_update(arp_p);
80108fa4:	83 ec 0c             	sub    $0xc,%esp
80108fa7:	ff 75 f4             	push   -0xc(%ebp)
80108faa:	e8 af 01 00 00       	call   8010915e <arp_table_update>
80108faf:	83 c4 10             	add    $0x10,%esp
    return ARP_UPDATED_TABLE;
80108fb2:	b8 01 00 00 00       	mov    $0x1,%eax
80108fb7:	eb 05                	jmp    80108fbe <arp_proc+0x171>
  }else{
    return -1;
80108fb9:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  }
}
80108fbe:	c9                   	leave  
80108fbf:	c3                   	ret    

80108fc0 <arp_scan>:

void arp_scan(){
80108fc0:	55                   	push   %ebp
80108fc1:	89 e5                	mov    %esp,%ebp
80108fc3:	83 ec 18             	sub    $0x18,%esp
  uint send_size;
  for(int i=0;i<256;i++){
80108fc6:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80108fcd:	eb 6f                	jmp    8010903e <arp_scan+0x7e>
    uint send = (uint)kalloc();
80108fcf:	e8 cc 97 ff ff       	call   801027a0 <kalloc>
80108fd4:	89 45 ec             	mov    %eax,-0x14(%ebp)
    arp_broadcast(send,&send_size,i);
80108fd7:	83 ec 04             	sub    $0x4,%esp
80108fda:	ff 75 f4             	push   -0xc(%ebp)
80108fdd:	8d 45 e8             	lea    -0x18(%ebp),%eax
80108fe0:	50                   	push   %eax
80108fe1:	ff 75 ec             	push   -0x14(%ebp)
80108fe4:	e8 62 00 00 00       	call   8010904b <arp_broadcast>
80108fe9:	83 c4 10             	add    $0x10,%esp
    uint res = i8254_send(send,send_size);
80108fec:	8b 45 e8             	mov    -0x18(%ebp),%eax
80108fef:	83 ec 08             	sub    $0x8,%esp
80108ff2:	50                   	push   %eax
80108ff3:	ff 75 ec             	push   -0x14(%ebp)
80108ff6:	e8 26 fd ff ff       	call   80108d21 <i8254_send>
80108ffb:	83 c4 10             	add    $0x10,%esp
80108ffe:	89 45 f0             	mov    %eax,-0x10(%ebp)
    while(res == -1){
80109001:	eb 22                	jmp    80109025 <arp_scan+0x65>
      microdelay(1);
80109003:	83 ec 0c             	sub    $0xc,%esp
80109006:	6a 01                	push   $0x1
80109008:	e8 2a 9b ff ff       	call   80102b37 <microdelay>
8010900d:	83 c4 10             	add    $0x10,%esp
      res = i8254_send(send,send_size);
80109010:	8b 45 e8             	mov    -0x18(%ebp),%eax
80109013:	83 ec 08             	sub    $0x8,%esp
80109016:	50                   	push   %eax
80109017:	ff 75 ec             	push   -0x14(%ebp)
8010901a:	e8 02 fd ff ff       	call   80108d21 <i8254_send>
8010901f:	83 c4 10             	add    $0x10,%esp
80109022:	89 45 f0             	mov    %eax,-0x10(%ebp)
    while(res == -1){
80109025:	83 7d f0 ff          	cmpl   $0xffffffff,-0x10(%ebp)
80109029:	74 d8                	je     80109003 <arp_scan+0x43>
    }
    kfree((char *)send);
8010902b:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010902e:	83 ec 0c             	sub    $0xc,%esp
80109031:	50                   	push   %eax
80109032:	e8 cf 96 ff ff       	call   80102706 <kfree>
80109037:	83 c4 10             	add    $0x10,%esp
  for(int i=0;i<256;i++){
8010903a:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
8010903e:	81 7d f4 ff 00 00 00 	cmpl   $0xff,-0xc(%ebp)
80109045:	7e 88                	jle    80108fcf <arp_scan+0xf>
  }
}
80109047:	90                   	nop
80109048:	90                   	nop
80109049:	c9                   	leave  
8010904a:	c3                   	ret    

8010904b <arp_broadcast>:

void arp_broadcast(uint send,uint *send_size,uint ip){
8010904b:	55                   	push   %ebp
8010904c:	89 e5                	mov    %esp,%ebp
8010904e:	83 ec 28             	sub    $0x28,%esp
  uchar dst_ip[4] = {10,0,1,ip};
80109051:	c6 45 ec 0a          	movb   $0xa,-0x14(%ebp)
80109055:	c6 45 ed 00          	movb   $0x0,-0x13(%ebp)
80109059:	c6 45 ee 01          	movb   $0x1,-0x12(%ebp)
8010905d:	8b 45 10             	mov    0x10(%ebp),%eax
80109060:	88 45 ef             	mov    %al,-0x11(%ebp)
  uchar dst_mac_eth[6] = {0xff,0xff,0xff,0xff,0xff,0xff};
80109063:	c7 45 e6 ff ff ff ff 	movl   $0xffffffff,-0x1a(%ebp)
8010906a:	66 c7 45 ea ff ff    	movw   $0xffff,-0x16(%ebp)
  uchar dst_mac_arp[6] = {0,0,0,0,0,0};
80109070:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
80109077:	66 c7 45 e4 00 00    	movw   $0x0,-0x1c(%ebp)
  
  *send_size = sizeof(struct eth_pkt) + sizeof(struct arp_pkt);
8010907d:	8b 45 0c             	mov    0xc(%ebp),%eax
80109080:	c7 00 2c 00 00 00    	movl   $0x2c,(%eax)

  struct eth_pkt *reply_eth = (struct eth_pkt *)send;
80109086:	8b 45 08             	mov    0x8(%ebp),%eax
80109089:	89 45 f4             	mov    %eax,-0xc(%ebp)
  struct arp_pkt *reply_arp = (struct arp_pkt *)(send + sizeof(struct eth_pkt));
8010908c:	8b 45 08             	mov    0x8(%ebp),%eax
8010908f:	83 c0 0e             	add    $0xe,%eax
80109092:	89 45 f0             	mov    %eax,-0x10(%ebp)
  
  reply_eth->type[0] = 0x08;
80109095:	8b 45 f4             	mov    -0xc(%ebp),%eax
80109098:	c6 40 0c 08          	movb   $0x8,0xc(%eax)
  reply_eth->type[1] = 0x06;
8010909c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010909f:	c6 40 0d 06          	movb   $0x6,0xd(%eax)
  memmove(reply_eth->dst_mac,dst_mac_eth,6);
801090a3:	8b 45 f4             	mov    -0xc(%ebp),%eax
801090a6:	83 ec 04             	sub    $0x4,%esp
801090a9:	6a 06                	push   $0x6
801090ab:	8d 55 e6             	lea    -0x1a(%ebp),%edx
801090ae:	52                   	push   %edx
801090af:	50                   	push   %eax
801090b0:	e8 0d bc ff ff       	call   80104cc2 <memmove>
801090b5:	83 c4 10             	add    $0x10,%esp
  memmove(reply_eth->src_mac,mac_addr,6);
801090b8:	8b 45 f4             	mov    -0xc(%ebp),%eax
801090bb:	83 c0 06             	add    $0x6,%eax
801090be:	83 ec 04             	sub    $0x4,%esp
801090c1:	6a 06                	push   $0x6
801090c3:	68 80 6e 19 80       	push   $0x80196e80
801090c8:	50                   	push   %eax
801090c9:	e8 f4 bb ff ff       	call   80104cc2 <memmove>
801090ce:	83 c4 10             	add    $0x10,%esp

  reply_arp->hrd_type = ARP_HARDWARE_TYPE;
801090d1:	8b 45 f0             	mov    -0x10(%ebp),%eax
801090d4:	66 c7 00 00 01       	movw   $0x100,(%eax)
  reply_arp->pro_type = ARP_PROTOCOL_TYPE;
801090d9:	8b 45 f0             	mov    -0x10(%ebp),%eax
801090dc:	66 c7 40 02 08 00    	movw   $0x8,0x2(%eax)
  reply_arp->hrd_len = 6;
801090e2:	8b 45 f0             	mov    -0x10(%ebp),%eax
801090e5:	c6 40 04 06          	movb   $0x6,0x4(%eax)
  reply_arp->pro_len = 4;
801090e9:	8b 45 f0             	mov    -0x10(%ebp),%eax
801090ec:	c6 40 05 04          	movb   $0x4,0x5(%eax)
  reply_arp->op = ARP_OPS_REQUEST;
801090f0:	8b 45 f0             	mov    -0x10(%ebp),%eax
801090f3:	66 c7 40 06 00 01    	movw   $0x100,0x6(%eax)
  memmove(reply_arp->dst_mac,dst_mac_arp,6);
801090f9:	8b 45 f0             	mov    -0x10(%ebp),%eax
801090fc:	8d 50 12             	lea    0x12(%eax),%edx
801090ff:	83 ec 04             	sub    $0x4,%esp
80109102:	6a 06                	push   $0x6
80109104:	8d 45 e0             	lea    -0x20(%ebp),%eax
80109107:	50                   	push   %eax
80109108:	52                   	push   %edx
80109109:	e8 b4 bb ff ff       	call   80104cc2 <memmove>
8010910e:	83 c4 10             	add    $0x10,%esp
  memmove(reply_arp->dst_ip,dst_ip,4);
80109111:	8b 45 f0             	mov    -0x10(%ebp),%eax
80109114:	8d 50 18             	lea    0x18(%eax),%edx
80109117:	83 ec 04             	sub    $0x4,%esp
8010911a:	6a 04                	push   $0x4
8010911c:	8d 45 ec             	lea    -0x14(%ebp),%eax
8010911f:	50                   	push   %eax
80109120:	52                   	push   %edx
80109121:	e8 9c bb ff ff       	call   80104cc2 <memmove>
80109126:	83 c4 10             	add    $0x10,%esp
  memmove(reply_arp->src_mac,mac_addr,6);
80109129:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010912c:	83 c0 08             	add    $0x8,%eax
8010912f:	83 ec 04             	sub    $0x4,%esp
80109132:	6a 06                	push   $0x6
80109134:	68 80 6e 19 80       	push   $0x80196e80
80109139:	50                   	push   %eax
8010913a:	e8 83 bb ff ff       	call   80104cc2 <memmove>
8010913f:	83 c4 10             	add    $0x10,%esp
  memmove(reply_arp->src_ip,my_ip,4);
80109142:	8b 45 f0             	mov    -0x10(%ebp),%eax
80109145:	83 c0 0e             	add    $0xe,%eax
80109148:	83 ec 04             	sub    $0x4,%esp
8010914b:	6a 04                	push   $0x4
8010914d:	68 04 f5 10 80       	push   $0x8010f504
80109152:	50                   	push   %eax
80109153:	e8 6a bb ff ff       	call   80104cc2 <memmove>
80109158:	83 c4 10             	add    $0x10,%esp
}
8010915b:	90                   	nop
8010915c:	c9                   	leave  
8010915d:	c3                   	ret    

8010915e <arp_table_update>:

void arp_table_update(struct arp_pkt *recv_arp){
8010915e:	55                   	push   %ebp
8010915f:	89 e5                	mov    %esp,%ebp
80109161:	83 ec 18             	sub    $0x18,%esp
  int index = arp_table_search(recv_arp->src_ip);
80109164:	8b 45 08             	mov    0x8(%ebp),%eax
80109167:	83 c0 0e             	add    $0xe,%eax
8010916a:	83 ec 0c             	sub    $0xc,%esp
8010916d:	50                   	push   %eax
8010916e:	e8 bc 00 00 00       	call   8010922f <arp_table_search>
80109173:	83 c4 10             	add    $0x10,%esp
80109176:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(index > -1){
80109179:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
8010917d:	78 2d                	js     801091ac <arp_table_update+0x4e>
    memmove(arp_table[index].mac,recv_arp->src_mac,6);
8010917f:	8b 45 08             	mov    0x8(%ebp),%eax
80109182:	8d 48 08             	lea    0x8(%eax),%ecx
80109185:	8b 55 f4             	mov    -0xc(%ebp),%edx
80109188:	89 d0                	mov    %edx,%eax
8010918a:	c1 e0 02             	shl    $0x2,%eax
8010918d:	01 d0                	add    %edx,%eax
8010918f:	01 c0                	add    %eax,%eax
80109191:	01 d0                	add    %edx,%eax
80109193:	05 a0 6e 19 80       	add    $0x80196ea0,%eax
80109198:	83 c0 04             	add    $0x4,%eax
8010919b:	83 ec 04             	sub    $0x4,%esp
8010919e:	6a 06                	push   $0x6
801091a0:	51                   	push   %ecx
801091a1:	50                   	push   %eax
801091a2:	e8 1b bb ff ff       	call   80104cc2 <memmove>
801091a7:	83 c4 10             	add    $0x10,%esp
801091aa:	eb 70                	jmp    8010921c <arp_table_update+0xbe>
  }else{
    index += 1;
801091ac:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
    index = -index;
801091b0:	f7 5d f4             	negl   -0xc(%ebp)
    memmove(arp_table[index].mac,recv_arp->src_mac,6);
801091b3:	8b 45 08             	mov    0x8(%ebp),%eax
801091b6:	8d 48 08             	lea    0x8(%eax),%ecx
801091b9:	8b 55 f4             	mov    -0xc(%ebp),%edx
801091bc:	89 d0                	mov    %edx,%eax
801091be:	c1 e0 02             	shl    $0x2,%eax
801091c1:	01 d0                	add    %edx,%eax
801091c3:	01 c0                	add    %eax,%eax
801091c5:	01 d0                	add    %edx,%eax
801091c7:	05 a0 6e 19 80       	add    $0x80196ea0,%eax
801091cc:	83 c0 04             	add    $0x4,%eax
801091cf:	83 ec 04             	sub    $0x4,%esp
801091d2:	6a 06                	push   $0x6
801091d4:	51                   	push   %ecx
801091d5:	50                   	push   %eax
801091d6:	e8 e7 ba ff ff       	call   80104cc2 <memmove>
801091db:	83 c4 10             	add    $0x10,%esp
    memmove(arp_table[index].ip,recv_arp->src_ip,4);
801091de:	8b 45 08             	mov    0x8(%ebp),%eax
801091e1:	8d 48 0e             	lea    0xe(%eax),%ecx
801091e4:	8b 55 f4             	mov    -0xc(%ebp),%edx
801091e7:	89 d0                	mov    %edx,%eax
801091e9:	c1 e0 02             	shl    $0x2,%eax
801091ec:	01 d0                	add    %edx,%eax
801091ee:	01 c0                	add    %eax,%eax
801091f0:	01 d0                	add    %edx,%eax
801091f2:	05 a0 6e 19 80       	add    $0x80196ea0,%eax
801091f7:	83 ec 04             	sub    $0x4,%esp
801091fa:	6a 04                	push   $0x4
801091fc:	51                   	push   %ecx
801091fd:	50                   	push   %eax
801091fe:	e8 bf ba ff ff       	call   80104cc2 <memmove>
80109203:	83 c4 10             	add    $0x10,%esp
    arp_table[index].use = 1;
80109206:	8b 55 f4             	mov    -0xc(%ebp),%edx
80109209:	89 d0                	mov    %edx,%eax
8010920b:	c1 e0 02             	shl    $0x2,%eax
8010920e:	01 d0                	add    %edx,%eax
80109210:	01 c0                	add    %eax,%eax
80109212:	01 d0                	add    %edx,%eax
80109214:	05 aa 6e 19 80       	add    $0x80196eaa,%eax
80109219:	c6 00 01             	movb   $0x1,(%eax)
  }
  print_arp_table(arp_table);
8010921c:	83 ec 0c             	sub    $0xc,%esp
8010921f:	68 a0 6e 19 80       	push   $0x80196ea0
80109224:	e8 83 00 00 00       	call   801092ac <print_arp_table>
80109229:	83 c4 10             	add    $0x10,%esp
}
8010922c:	90                   	nop
8010922d:	c9                   	leave  
8010922e:	c3                   	ret    

8010922f <arp_table_search>:

int arp_table_search(uchar *ip){
8010922f:	55                   	push   %ebp
80109230:	89 e5                	mov    %esp,%ebp
80109232:	83 ec 18             	sub    $0x18,%esp
  int empty=1;
80109235:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
  for(int i=0;i<ARP_TABLE_MAX;i++){
8010923c:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
80109243:	eb 59                	jmp    8010929e <arp_table_search+0x6f>
    if(memcmp(arp_table[i].ip,ip,4) == 0){
80109245:	8b 55 f0             	mov    -0x10(%ebp),%edx
80109248:	89 d0                	mov    %edx,%eax
8010924a:	c1 e0 02             	shl    $0x2,%eax
8010924d:	01 d0                	add    %edx,%eax
8010924f:	01 c0                	add    %eax,%eax
80109251:	01 d0                	add    %edx,%eax
80109253:	05 a0 6e 19 80       	add    $0x80196ea0,%eax
80109258:	83 ec 04             	sub    $0x4,%esp
8010925b:	6a 04                	push   $0x4
8010925d:	ff 75 08             	push   0x8(%ebp)
80109260:	50                   	push   %eax
80109261:	e8 04 ba ff ff       	call   80104c6a <memcmp>
80109266:	83 c4 10             	add    $0x10,%esp
80109269:	85 c0                	test   %eax,%eax
8010926b:	75 05                	jne    80109272 <arp_table_search+0x43>
      return i;
8010926d:	8b 45 f0             	mov    -0x10(%ebp),%eax
80109270:	eb 38                	jmp    801092aa <arp_table_search+0x7b>
    }
    if(arp_table[i].use == 0 && empty == 1){
80109272:	8b 55 f0             	mov    -0x10(%ebp),%edx
80109275:	89 d0                	mov    %edx,%eax
80109277:	c1 e0 02             	shl    $0x2,%eax
8010927a:	01 d0                	add    %edx,%eax
8010927c:	01 c0                	add    %eax,%eax
8010927e:	01 d0                	add    %edx,%eax
80109280:	05 aa 6e 19 80       	add    $0x80196eaa,%eax
80109285:	0f b6 00             	movzbl (%eax),%eax
80109288:	84 c0                	test   %al,%al
8010928a:	75 0e                	jne    8010929a <arp_table_search+0x6b>
8010928c:	83 7d f4 01          	cmpl   $0x1,-0xc(%ebp)
80109290:	75 08                	jne    8010929a <arp_table_search+0x6b>
      empty = -i;
80109292:	8b 45 f0             	mov    -0x10(%ebp),%eax
80109295:	f7 d8                	neg    %eax
80109297:	89 45 f4             	mov    %eax,-0xc(%ebp)
  for(int i=0;i<ARP_TABLE_MAX;i++){
8010929a:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
8010929e:	83 7d f0 3f          	cmpl   $0x3f,-0x10(%ebp)
801092a2:	7e a1                	jle    80109245 <arp_table_search+0x16>
    }
  }
  return empty-1;
801092a4:	8b 45 f4             	mov    -0xc(%ebp),%eax
801092a7:	83 e8 01             	sub    $0x1,%eax
}
801092aa:	c9                   	leave  
801092ab:	c3                   	ret    

801092ac <print_arp_table>:

void print_arp_table(){
801092ac:	55                   	push   %ebp
801092ad:	89 e5                	mov    %esp,%ebp
801092af:	83 ec 18             	sub    $0x18,%esp
  for(int i=0;i < ARP_TABLE_MAX;i++){
801092b2:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
801092b9:	e9 92 00 00 00       	jmp    80109350 <print_arp_table+0xa4>
    if(arp_table[i].use != 0){
801092be:	8b 55 f4             	mov    -0xc(%ebp),%edx
801092c1:	89 d0                	mov    %edx,%eax
801092c3:	c1 e0 02             	shl    $0x2,%eax
801092c6:	01 d0                	add    %edx,%eax
801092c8:	01 c0                	add    %eax,%eax
801092ca:	01 d0                	add    %edx,%eax
801092cc:	05 aa 6e 19 80       	add    $0x80196eaa,%eax
801092d1:	0f b6 00             	movzbl (%eax),%eax
801092d4:	84 c0                	test   %al,%al
801092d6:	74 74                	je     8010934c <print_arp_table+0xa0>
      cprintf("Entry Num: %d ",i);
801092d8:	83 ec 08             	sub    $0x8,%esp
801092db:	ff 75 f4             	push   -0xc(%ebp)
801092de:	68 2f c1 10 80       	push   $0x8010c12f
801092e3:	e8 0c 71 ff ff       	call   801003f4 <cprintf>
801092e8:	83 c4 10             	add    $0x10,%esp
      print_ipv4(arp_table[i].ip);
801092eb:	8b 55 f4             	mov    -0xc(%ebp),%edx
801092ee:	89 d0                	mov    %edx,%eax
801092f0:	c1 e0 02             	shl    $0x2,%eax
801092f3:	01 d0                	add    %edx,%eax
801092f5:	01 c0                	add    %eax,%eax
801092f7:	01 d0                	add    %edx,%eax
801092f9:	05 a0 6e 19 80       	add    $0x80196ea0,%eax
801092fe:	83 ec 0c             	sub    $0xc,%esp
80109301:	50                   	push   %eax
80109302:	e8 54 02 00 00       	call   8010955b <print_ipv4>
80109307:	83 c4 10             	add    $0x10,%esp
      cprintf(" ");
8010930a:	83 ec 0c             	sub    $0xc,%esp
8010930d:	68 3e c1 10 80       	push   $0x8010c13e
80109312:	e8 dd 70 ff ff       	call   801003f4 <cprintf>
80109317:	83 c4 10             	add    $0x10,%esp
      print_mac(arp_table[i].mac);
8010931a:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010931d:	89 d0                	mov    %edx,%eax
8010931f:	c1 e0 02             	shl    $0x2,%eax
80109322:	01 d0                	add    %edx,%eax
80109324:	01 c0                	add    %eax,%eax
80109326:	01 d0                	add    %edx,%eax
80109328:	05 a0 6e 19 80       	add    $0x80196ea0,%eax
8010932d:	83 c0 04             	add    $0x4,%eax
80109330:	83 ec 0c             	sub    $0xc,%esp
80109333:	50                   	push   %eax
80109334:	e8 70 02 00 00       	call   801095a9 <print_mac>
80109339:	83 c4 10             	add    $0x10,%esp
      cprintf("\n");
8010933c:	83 ec 0c             	sub    $0xc,%esp
8010933f:	68 40 c1 10 80       	push   $0x8010c140
80109344:	e8 ab 70 ff ff       	call   801003f4 <cprintf>
80109349:	83 c4 10             	add    $0x10,%esp
  for(int i=0;i < ARP_TABLE_MAX;i++){
8010934c:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80109350:	83 7d f4 3f          	cmpl   $0x3f,-0xc(%ebp)
80109354:	0f 8e 64 ff ff ff    	jle    801092be <print_arp_table+0x12>
    }
  }
}
8010935a:	90                   	nop
8010935b:	90                   	nop
8010935c:	c9                   	leave  
8010935d:	c3                   	ret    

8010935e <arp_reply_pkt_create>:


void arp_reply_pkt_create(struct arp_pkt *arp_recv,uint send,uint *send_size){
8010935e:	55                   	push   %ebp
8010935f:	89 e5                	mov    %esp,%ebp
80109361:	83 ec 18             	sub    $0x18,%esp
  *send_size = sizeof(struct eth_pkt) + sizeof(struct arp_pkt);
80109364:	8b 45 10             	mov    0x10(%ebp),%eax
80109367:	c7 00 2c 00 00 00    	movl   $0x2c,(%eax)
  
  struct eth_pkt *reply_eth = (struct eth_pkt *)send;
8010936d:	8b 45 0c             	mov    0xc(%ebp),%eax
80109370:	89 45 f4             	mov    %eax,-0xc(%ebp)
  struct arp_pkt *reply_arp = (struct arp_pkt *)(send + sizeof(struct eth_pkt));
80109373:	8b 45 0c             	mov    0xc(%ebp),%eax
80109376:	83 c0 0e             	add    $0xe,%eax
80109379:	89 45 f0             	mov    %eax,-0x10(%ebp)

  reply_eth->type[0] = 0x08;
8010937c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010937f:	c6 40 0c 08          	movb   $0x8,0xc(%eax)
  reply_eth->type[1] = 0x06;
80109383:	8b 45 f4             	mov    -0xc(%ebp),%eax
80109386:	c6 40 0d 06          	movb   $0x6,0xd(%eax)
  memmove(reply_eth->dst_mac,arp_recv->src_mac,6);
8010938a:	8b 45 08             	mov    0x8(%ebp),%eax
8010938d:	8d 50 08             	lea    0x8(%eax),%edx
80109390:	8b 45 f4             	mov    -0xc(%ebp),%eax
80109393:	83 ec 04             	sub    $0x4,%esp
80109396:	6a 06                	push   $0x6
80109398:	52                   	push   %edx
80109399:	50                   	push   %eax
8010939a:	e8 23 b9 ff ff       	call   80104cc2 <memmove>
8010939f:	83 c4 10             	add    $0x10,%esp
  memmove(reply_eth->src_mac,mac_addr,6);
801093a2:	8b 45 f4             	mov    -0xc(%ebp),%eax
801093a5:	83 c0 06             	add    $0x6,%eax
801093a8:	83 ec 04             	sub    $0x4,%esp
801093ab:	6a 06                	push   $0x6
801093ad:	68 80 6e 19 80       	push   $0x80196e80
801093b2:	50                   	push   %eax
801093b3:	e8 0a b9 ff ff       	call   80104cc2 <memmove>
801093b8:	83 c4 10             	add    $0x10,%esp

  reply_arp->hrd_type = ARP_HARDWARE_TYPE;
801093bb:	8b 45 f0             	mov    -0x10(%ebp),%eax
801093be:	66 c7 00 00 01       	movw   $0x100,(%eax)
  reply_arp->pro_type = ARP_PROTOCOL_TYPE;
801093c3:	8b 45 f0             	mov    -0x10(%ebp),%eax
801093c6:	66 c7 40 02 08 00    	movw   $0x8,0x2(%eax)
  reply_arp->hrd_len = 6;
801093cc:	8b 45 f0             	mov    -0x10(%ebp),%eax
801093cf:	c6 40 04 06          	movb   $0x6,0x4(%eax)
  reply_arp->pro_len = 4;
801093d3:	8b 45 f0             	mov    -0x10(%ebp),%eax
801093d6:	c6 40 05 04          	movb   $0x4,0x5(%eax)
  reply_arp->op = ARP_OPS_REPLY;
801093da:	8b 45 f0             	mov    -0x10(%ebp),%eax
801093dd:	66 c7 40 06 00 02    	movw   $0x200,0x6(%eax)
  memmove(reply_arp->dst_mac,arp_recv->src_mac,6);
801093e3:	8b 45 08             	mov    0x8(%ebp),%eax
801093e6:	8d 50 08             	lea    0x8(%eax),%edx
801093e9:	8b 45 f0             	mov    -0x10(%ebp),%eax
801093ec:	83 c0 12             	add    $0x12,%eax
801093ef:	83 ec 04             	sub    $0x4,%esp
801093f2:	6a 06                	push   $0x6
801093f4:	52                   	push   %edx
801093f5:	50                   	push   %eax
801093f6:	e8 c7 b8 ff ff       	call   80104cc2 <memmove>
801093fb:	83 c4 10             	add    $0x10,%esp
  memmove(reply_arp->dst_ip,arp_recv->src_ip,4);
801093fe:	8b 45 08             	mov    0x8(%ebp),%eax
80109401:	8d 50 0e             	lea    0xe(%eax),%edx
80109404:	8b 45 f0             	mov    -0x10(%ebp),%eax
80109407:	83 c0 18             	add    $0x18,%eax
8010940a:	83 ec 04             	sub    $0x4,%esp
8010940d:	6a 04                	push   $0x4
8010940f:	52                   	push   %edx
80109410:	50                   	push   %eax
80109411:	e8 ac b8 ff ff       	call   80104cc2 <memmove>
80109416:	83 c4 10             	add    $0x10,%esp
  memmove(reply_arp->src_mac,mac_addr,6);
80109419:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010941c:	83 c0 08             	add    $0x8,%eax
8010941f:	83 ec 04             	sub    $0x4,%esp
80109422:	6a 06                	push   $0x6
80109424:	68 80 6e 19 80       	push   $0x80196e80
80109429:	50                   	push   %eax
8010942a:	e8 93 b8 ff ff       	call   80104cc2 <memmove>
8010942f:	83 c4 10             	add    $0x10,%esp
  memmove(reply_arp->src_ip,my_ip,4);
80109432:	8b 45 f0             	mov    -0x10(%ebp),%eax
80109435:	83 c0 0e             	add    $0xe,%eax
80109438:	83 ec 04             	sub    $0x4,%esp
8010943b:	6a 04                	push   $0x4
8010943d:	68 04 f5 10 80       	push   $0x8010f504
80109442:	50                   	push   %eax
80109443:	e8 7a b8 ff ff       	call   80104cc2 <memmove>
80109448:	83 c4 10             	add    $0x10,%esp
}
8010944b:	90                   	nop
8010944c:	c9                   	leave  
8010944d:	c3                   	ret    

8010944e <print_arp_info>:

void print_arp_info(struct arp_pkt* arp_p){
8010944e:	55                   	push   %ebp
8010944f:	89 e5                	mov    %esp,%ebp
80109451:	83 ec 08             	sub    $0x8,%esp
  cprintf("--------Source-------\n");
80109454:	83 ec 0c             	sub    $0xc,%esp
80109457:	68 42 c1 10 80       	push   $0x8010c142
8010945c:	e8 93 6f ff ff       	call   801003f4 <cprintf>
80109461:	83 c4 10             	add    $0x10,%esp
  print_ipv4(arp_p->src_ip);
80109464:	8b 45 08             	mov    0x8(%ebp),%eax
80109467:	83 c0 0e             	add    $0xe,%eax
8010946a:	83 ec 0c             	sub    $0xc,%esp
8010946d:	50                   	push   %eax
8010946e:	e8 e8 00 00 00       	call   8010955b <print_ipv4>
80109473:	83 c4 10             	add    $0x10,%esp
  cprintf("\n");
80109476:	83 ec 0c             	sub    $0xc,%esp
80109479:	68 40 c1 10 80       	push   $0x8010c140
8010947e:	e8 71 6f ff ff       	call   801003f4 <cprintf>
80109483:	83 c4 10             	add    $0x10,%esp
  print_mac(arp_p->src_mac);
80109486:	8b 45 08             	mov    0x8(%ebp),%eax
80109489:	83 c0 08             	add    $0x8,%eax
8010948c:	83 ec 0c             	sub    $0xc,%esp
8010948f:	50                   	push   %eax
80109490:	e8 14 01 00 00       	call   801095a9 <print_mac>
80109495:	83 c4 10             	add    $0x10,%esp
  cprintf("\n");
80109498:	83 ec 0c             	sub    $0xc,%esp
8010949b:	68 40 c1 10 80       	push   $0x8010c140
801094a0:	e8 4f 6f ff ff       	call   801003f4 <cprintf>
801094a5:	83 c4 10             	add    $0x10,%esp
  cprintf("-----Destination-----\n");
801094a8:	83 ec 0c             	sub    $0xc,%esp
801094ab:	68 59 c1 10 80       	push   $0x8010c159
801094b0:	e8 3f 6f ff ff       	call   801003f4 <cprintf>
801094b5:	83 c4 10             	add    $0x10,%esp
  print_ipv4(arp_p->dst_ip);
801094b8:	8b 45 08             	mov    0x8(%ebp),%eax
801094bb:	83 c0 18             	add    $0x18,%eax
801094be:	83 ec 0c             	sub    $0xc,%esp
801094c1:	50                   	push   %eax
801094c2:	e8 94 00 00 00       	call   8010955b <print_ipv4>
801094c7:	83 c4 10             	add    $0x10,%esp
  cprintf("\n");
801094ca:	83 ec 0c             	sub    $0xc,%esp
801094cd:	68 40 c1 10 80       	push   $0x8010c140
801094d2:	e8 1d 6f ff ff       	call   801003f4 <cprintf>
801094d7:	83 c4 10             	add    $0x10,%esp
  print_mac(arp_p->dst_mac);
801094da:	8b 45 08             	mov    0x8(%ebp),%eax
801094dd:	83 c0 12             	add    $0x12,%eax
801094e0:	83 ec 0c             	sub    $0xc,%esp
801094e3:	50                   	push   %eax
801094e4:	e8 c0 00 00 00       	call   801095a9 <print_mac>
801094e9:	83 c4 10             	add    $0x10,%esp
  cprintf("\n");
801094ec:	83 ec 0c             	sub    $0xc,%esp
801094ef:	68 40 c1 10 80       	push   $0x8010c140
801094f4:	e8 fb 6e ff ff       	call   801003f4 <cprintf>
801094f9:	83 c4 10             	add    $0x10,%esp
  cprintf("Operation: ");
801094fc:	83 ec 0c             	sub    $0xc,%esp
801094ff:	68 70 c1 10 80       	push   $0x8010c170
80109504:	e8 eb 6e ff ff       	call   801003f4 <cprintf>
80109509:	83 c4 10             	add    $0x10,%esp
  if(arp_p->op == ARP_OPS_REQUEST) cprintf("Request\n");
8010950c:	8b 45 08             	mov    0x8(%ebp),%eax
8010950f:	0f b7 40 06          	movzwl 0x6(%eax),%eax
80109513:	66 3d 00 01          	cmp    $0x100,%ax
80109517:	75 12                	jne    8010952b <print_arp_info+0xdd>
80109519:	83 ec 0c             	sub    $0xc,%esp
8010951c:	68 7c c1 10 80       	push   $0x8010c17c
80109521:	e8 ce 6e ff ff       	call   801003f4 <cprintf>
80109526:	83 c4 10             	add    $0x10,%esp
80109529:	eb 1d                	jmp    80109548 <print_arp_info+0xfa>
  else if(arp_p->op == ARP_OPS_REPLY) {
8010952b:	8b 45 08             	mov    0x8(%ebp),%eax
8010952e:	0f b7 40 06          	movzwl 0x6(%eax),%eax
80109532:	66 3d 00 02          	cmp    $0x200,%ax
80109536:	75 10                	jne    80109548 <print_arp_info+0xfa>
    cprintf("Reply\n");
80109538:	83 ec 0c             	sub    $0xc,%esp
8010953b:	68 85 c1 10 80       	push   $0x8010c185
80109540:	e8 af 6e ff ff       	call   801003f4 <cprintf>
80109545:	83 c4 10             	add    $0x10,%esp
  }
  cprintf("\n");
80109548:	83 ec 0c             	sub    $0xc,%esp
8010954b:	68 40 c1 10 80       	push   $0x8010c140
80109550:	e8 9f 6e ff ff       	call   801003f4 <cprintf>
80109555:	83 c4 10             	add    $0x10,%esp
}
80109558:	90                   	nop
80109559:	c9                   	leave  
8010955a:	c3                   	ret    

8010955b <print_ipv4>:

void print_ipv4(uchar *ip){
8010955b:	55                   	push   %ebp
8010955c:	89 e5                	mov    %esp,%ebp
8010955e:	53                   	push   %ebx
8010955f:	83 ec 04             	sub    $0x4,%esp
  cprintf("IP address: %d.%d.%d.%d",ip[0],ip[1],ip[2],ip[3]);
80109562:	8b 45 08             	mov    0x8(%ebp),%eax
80109565:	83 c0 03             	add    $0x3,%eax
80109568:	0f b6 00             	movzbl (%eax),%eax
8010956b:	0f b6 d8             	movzbl %al,%ebx
8010956e:	8b 45 08             	mov    0x8(%ebp),%eax
80109571:	83 c0 02             	add    $0x2,%eax
80109574:	0f b6 00             	movzbl (%eax),%eax
80109577:	0f b6 c8             	movzbl %al,%ecx
8010957a:	8b 45 08             	mov    0x8(%ebp),%eax
8010957d:	83 c0 01             	add    $0x1,%eax
80109580:	0f b6 00             	movzbl (%eax),%eax
80109583:	0f b6 d0             	movzbl %al,%edx
80109586:	8b 45 08             	mov    0x8(%ebp),%eax
80109589:	0f b6 00             	movzbl (%eax),%eax
8010958c:	0f b6 c0             	movzbl %al,%eax
8010958f:	83 ec 0c             	sub    $0xc,%esp
80109592:	53                   	push   %ebx
80109593:	51                   	push   %ecx
80109594:	52                   	push   %edx
80109595:	50                   	push   %eax
80109596:	68 8c c1 10 80       	push   $0x8010c18c
8010959b:	e8 54 6e ff ff       	call   801003f4 <cprintf>
801095a0:	83 c4 20             	add    $0x20,%esp
}
801095a3:	90                   	nop
801095a4:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801095a7:	c9                   	leave  
801095a8:	c3                   	ret    

801095a9 <print_mac>:

void print_mac(uchar *mac){
801095a9:	55                   	push   %ebp
801095aa:	89 e5                	mov    %esp,%ebp
801095ac:	57                   	push   %edi
801095ad:	56                   	push   %esi
801095ae:	53                   	push   %ebx
801095af:	83 ec 0c             	sub    $0xc,%esp
  cprintf("MAC address: %x:%x:%x:%x:%x:%x",mac[0],mac[1],mac[2],mac[3],mac[4],mac[5]);
801095b2:	8b 45 08             	mov    0x8(%ebp),%eax
801095b5:	83 c0 05             	add    $0x5,%eax
801095b8:	0f b6 00             	movzbl (%eax),%eax
801095bb:	0f b6 f8             	movzbl %al,%edi
801095be:	8b 45 08             	mov    0x8(%ebp),%eax
801095c1:	83 c0 04             	add    $0x4,%eax
801095c4:	0f b6 00             	movzbl (%eax),%eax
801095c7:	0f b6 f0             	movzbl %al,%esi
801095ca:	8b 45 08             	mov    0x8(%ebp),%eax
801095cd:	83 c0 03             	add    $0x3,%eax
801095d0:	0f b6 00             	movzbl (%eax),%eax
801095d3:	0f b6 d8             	movzbl %al,%ebx
801095d6:	8b 45 08             	mov    0x8(%ebp),%eax
801095d9:	83 c0 02             	add    $0x2,%eax
801095dc:	0f b6 00             	movzbl (%eax),%eax
801095df:	0f b6 c8             	movzbl %al,%ecx
801095e2:	8b 45 08             	mov    0x8(%ebp),%eax
801095e5:	83 c0 01             	add    $0x1,%eax
801095e8:	0f b6 00             	movzbl (%eax),%eax
801095eb:	0f b6 d0             	movzbl %al,%edx
801095ee:	8b 45 08             	mov    0x8(%ebp),%eax
801095f1:	0f b6 00             	movzbl (%eax),%eax
801095f4:	0f b6 c0             	movzbl %al,%eax
801095f7:	83 ec 04             	sub    $0x4,%esp
801095fa:	57                   	push   %edi
801095fb:	56                   	push   %esi
801095fc:	53                   	push   %ebx
801095fd:	51                   	push   %ecx
801095fe:	52                   	push   %edx
801095ff:	50                   	push   %eax
80109600:	68 a4 c1 10 80       	push   $0x8010c1a4
80109605:	e8 ea 6d ff ff       	call   801003f4 <cprintf>
8010960a:	83 c4 20             	add    $0x20,%esp
}
8010960d:	90                   	nop
8010960e:	8d 65 f4             	lea    -0xc(%ebp),%esp
80109611:	5b                   	pop    %ebx
80109612:	5e                   	pop    %esi
80109613:	5f                   	pop    %edi
80109614:	5d                   	pop    %ebp
80109615:	c3                   	ret    

80109616 <eth_proc>:
#include "arp.h"
#include "types.h"
#include "eth.h"
#include "defs.h"
#include "ipv4.h"
void eth_proc(uint buffer_addr){
80109616:	55                   	push   %ebp
80109617:	89 e5                	mov    %esp,%ebp
80109619:	83 ec 18             	sub    $0x18,%esp
  struct eth_pkt *eth_pkt = (struct eth_pkt *)buffer_addr;
8010961c:	8b 45 08             	mov    0x8(%ebp),%eax
8010961f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  uint pkt_addr = buffer_addr+sizeof(struct eth_pkt);
80109622:	8b 45 08             	mov    0x8(%ebp),%eax
80109625:	83 c0 0e             	add    $0xe,%eax
80109628:	89 45 f0             	mov    %eax,-0x10(%ebp)
  if(eth_pkt->type[0] == 0x08 && eth_pkt->type[1] == 0x06){
8010962b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010962e:	0f b6 40 0c          	movzbl 0xc(%eax),%eax
80109632:	3c 08                	cmp    $0x8,%al
80109634:	75 1b                	jne    80109651 <eth_proc+0x3b>
80109636:	8b 45 f4             	mov    -0xc(%ebp),%eax
80109639:	0f b6 40 0d          	movzbl 0xd(%eax),%eax
8010963d:	3c 06                	cmp    $0x6,%al
8010963f:	75 10                	jne    80109651 <eth_proc+0x3b>
    arp_proc(pkt_addr);
80109641:	83 ec 0c             	sub    $0xc,%esp
80109644:	ff 75 f0             	push   -0x10(%ebp)
80109647:	e8 01 f8 ff ff       	call   80108e4d <arp_proc>
8010964c:	83 c4 10             	add    $0x10,%esp
  }else if(eth_pkt->type[0] == 0x08 && eth_pkt->type[1] == 0x00){
    ipv4_proc(buffer_addr);
  }else{
  }
}
8010964f:	eb 24                	jmp    80109675 <eth_proc+0x5f>
  }else if(eth_pkt->type[0] == 0x08 && eth_pkt->type[1] == 0x00){
80109651:	8b 45 f4             	mov    -0xc(%ebp),%eax
80109654:	0f b6 40 0c          	movzbl 0xc(%eax),%eax
80109658:	3c 08                	cmp    $0x8,%al
8010965a:	75 19                	jne    80109675 <eth_proc+0x5f>
8010965c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010965f:	0f b6 40 0d          	movzbl 0xd(%eax),%eax
80109663:	84 c0                	test   %al,%al
80109665:	75 0e                	jne    80109675 <eth_proc+0x5f>
    ipv4_proc(buffer_addr);
80109667:	83 ec 0c             	sub    $0xc,%esp
8010966a:	ff 75 08             	push   0x8(%ebp)
8010966d:	e8 a3 00 00 00       	call   80109715 <ipv4_proc>
80109672:	83 c4 10             	add    $0x10,%esp
}
80109675:	90                   	nop
80109676:	c9                   	leave  
80109677:	c3                   	ret    

80109678 <N2H_ushort>:

ushort N2H_ushort(ushort value){
80109678:	55                   	push   %ebp
80109679:	89 e5                	mov    %esp,%ebp
8010967b:	83 ec 04             	sub    $0x4,%esp
8010967e:	8b 45 08             	mov    0x8(%ebp),%eax
80109681:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  return (((value)&0xFF)<<8)+(value>>8);
80109685:	0f b7 45 fc          	movzwl -0x4(%ebp),%eax
80109689:	c1 e0 08             	shl    $0x8,%eax
8010968c:	89 c2                	mov    %eax,%edx
8010968e:	0f b7 45 fc          	movzwl -0x4(%ebp),%eax
80109692:	66 c1 e8 08          	shr    $0x8,%ax
80109696:	01 d0                	add    %edx,%eax
}
80109698:	c9                   	leave  
80109699:	c3                   	ret    

8010969a <H2N_ushort>:

ushort H2N_ushort(ushort value){
8010969a:	55                   	push   %ebp
8010969b:	89 e5                	mov    %esp,%ebp
8010969d:	83 ec 04             	sub    $0x4,%esp
801096a0:	8b 45 08             	mov    0x8(%ebp),%eax
801096a3:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  return (((value)&0xFF)<<8)+(value>>8);
801096a7:	0f b7 45 fc          	movzwl -0x4(%ebp),%eax
801096ab:	c1 e0 08             	shl    $0x8,%eax
801096ae:	89 c2                	mov    %eax,%edx
801096b0:	0f b7 45 fc          	movzwl -0x4(%ebp),%eax
801096b4:	66 c1 e8 08          	shr    $0x8,%ax
801096b8:	01 d0                	add    %edx,%eax
}
801096ba:	c9                   	leave  
801096bb:	c3                   	ret    

801096bc <H2N_uint>:

uint H2N_uint(uint value){
801096bc:	55                   	push   %ebp
801096bd:	89 e5                	mov    %esp,%ebp
  return ((value&0xF)<<24)+((value&0xF0)<<8)+((value&0xF00)>>8)+((value&0xF000)>>24);
801096bf:	8b 45 08             	mov    0x8(%ebp),%eax
801096c2:	c1 e0 18             	shl    $0x18,%eax
801096c5:	25 00 00 00 0f       	and    $0xf000000,%eax
801096ca:	89 c2                	mov    %eax,%edx
801096cc:	8b 45 08             	mov    0x8(%ebp),%eax
801096cf:	c1 e0 08             	shl    $0x8,%eax
801096d2:	25 00 f0 00 00       	and    $0xf000,%eax
801096d7:	09 c2                	or     %eax,%edx
801096d9:	8b 45 08             	mov    0x8(%ebp),%eax
801096dc:	c1 e8 08             	shr    $0x8,%eax
801096df:	83 e0 0f             	and    $0xf,%eax
801096e2:	01 d0                	add    %edx,%eax
}
801096e4:	5d                   	pop    %ebp
801096e5:	c3                   	ret    

801096e6 <N2H_uint>:

uint N2H_uint(uint value){
801096e6:	55                   	push   %ebp
801096e7:	89 e5                	mov    %esp,%ebp
  return ((value&0xFF)<<24)+((value&0xFF00)<<8)+((value&0xFF0000)>>8)+((value&0xFF000000)>>24);
801096e9:	8b 45 08             	mov    0x8(%ebp),%eax
801096ec:	c1 e0 18             	shl    $0x18,%eax
801096ef:	89 c2                	mov    %eax,%edx
801096f1:	8b 45 08             	mov    0x8(%ebp),%eax
801096f4:	c1 e0 08             	shl    $0x8,%eax
801096f7:	25 00 00 ff 00       	and    $0xff0000,%eax
801096fc:	01 c2                	add    %eax,%edx
801096fe:	8b 45 08             	mov    0x8(%ebp),%eax
80109701:	c1 e8 08             	shr    $0x8,%eax
80109704:	25 00 ff 00 00       	and    $0xff00,%eax
80109709:	01 c2                	add    %eax,%edx
8010970b:	8b 45 08             	mov    0x8(%ebp),%eax
8010970e:	c1 e8 18             	shr    $0x18,%eax
80109711:	01 d0                	add    %edx,%eax
}
80109713:	5d                   	pop    %ebp
80109714:	c3                   	ret    

80109715 <ipv4_proc>:
extern uchar mac_addr[6];
extern uchar my_ip[4];

int ip_id = -1;
ushort send_id = 0;
void ipv4_proc(uint buffer_addr){
80109715:	55                   	push   %ebp
80109716:	89 e5                	mov    %esp,%ebp
80109718:	83 ec 18             	sub    $0x18,%esp
  struct ipv4_pkt *ipv4_p = (struct ipv4_pkt *)(buffer_addr+14);
8010971b:	8b 45 08             	mov    0x8(%ebp),%eax
8010971e:	83 c0 0e             	add    $0xe,%eax
80109721:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(ip_id != ipv4_p->id && memcmp(my_ip,ipv4_p->src_ip,4) != 0){
80109724:	8b 45 f4             	mov    -0xc(%ebp),%eax
80109727:	0f b7 40 04          	movzwl 0x4(%eax),%eax
8010972b:	0f b7 d0             	movzwl %ax,%edx
8010972e:	a1 08 f5 10 80       	mov    0x8010f508,%eax
80109733:	39 c2                	cmp    %eax,%edx
80109735:	74 60                	je     80109797 <ipv4_proc+0x82>
80109737:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010973a:	83 c0 0c             	add    $0xc,%eax
8010973d:	83 ec 04             	sub    $0x4,%esp
80109740:	6a 04                	push   $0x4
80109742:	50                   	push   %eax
80109743:	68 04 f5 10 80       	push   $0x8010f504
80109748:	e8 1d b5 ff ff       	call   80104c6a <memcmp>
8010974d:	83 c4 10             	add    $0x10,%esp
80109750:	85 c0                	test   %eax,%eax
80109752:	74 43                	je     80109797 <ipv4_proc+0x82>
    ip_id = ipv4_p->id;
80109754:	8b 45 f4             	mov    -0xc(%ebp),%eax
80109757:	0f b7 40 04          	movzwl 0x4(%eax),%eax
8010975b:	0f b7 c0             	movzwl %ax,%eax
8010975e:	a3 08 f5 10 80       	mov    %eax,0x8010f508
      if(ipv4_p->protocol == IPV4_TYPE_ICMP){
80109763:	8b 45 f4             	mov    -0xc(%ebp),%eax
80109766:	0f b6 40 09          	movzbl 0x9(%eax),%eax
8010976a:	3c 01                	cmp    $0x1,%al
8010976c:	75 10                	jne    8010977e <ipv4_proc+0x69>
        icmp_proc(buffer_addr);
8010976e:	83 ec 0c             	sub    $0xc,%esp
80109771:	ff 75 08             	push   0x8(%ebp)
80109774:	e8 a3 00 00 00       	call   8010981c <icmp_proc>
80109779:	83 c4 10             	add    $0x10,%esp
      }else if(ipv4_p->protocol == IPV4_TYPE_TCP){
        tcp_proc(buffer_addr);
      }
  }
}
8010977c:	eb 19                	jmp    80109797 <ipv4_proc+0x82>
      }else if(ipv4_p->protocol == IPV4_TYPE_TCP){
8010977e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80109781:	0f b6 40 09          	movzbl 0x9(%eax),%eax
80109785:	3c 06                	cmp    $0x6,%al
80109787:	75 0e                	jne    80109797 <ipv4_proc+0x82>
        tcp_proc(buffer_addr);
80109789:	83 ec 0c             	sub    $0xc,%esp
8010978c:	ff 75 08             	push   0x8(%ebp)
8010978f:	e8 b3 03 00 00       	call   80109b47 <tcp_proc>
80109794:	83 c4 10             	add    $0x10,%esp
}
80109797:	90                   	nop
80109798:	c9                   	leave  
80109799:	c3                   	ret    

8010979a <ipv4_chksum>:

ushort ipv4_chksum(uint ipv4_addr){
8010979a:	55                   	push   %ebp
8010979b:	89 e5                	mov    %esp,%ebp
8010979d:	83 ec 10             	sub    $0x10,%esp
  uchar* bin = (uchar *)ipv4_addr;
801097a0:	8b 45 08             	mov    0x8(%ebp),%eax
801097a3:	89 45 f4             	mov    %eax,-0xc(%ebp)
  uchar len = (bin[0]&0xF)*2;
801097a6:	8b 45 f4             	mov    -0xc(%ebp),%eax
801097a9:	0f b6 00             	movzbl (%eax),%eax
801097ac:	83 e0 0f             	and    $0xf,%eax
801097af:	01 c0                	add    %eax,%eax
801097b1:	88 45 f3             	mov    %al,-0xd(%ebp)
  uint chk_sum = 0;
801097b4:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  for(int i=0;i<len;i++){
801097bb:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
801097c2:	eb 48                	jmp    8010980c <ipv4_chksum+0x72>
    chk_sum += (bin[i*2]<<8)+bin[i*2+1];
801097c4:	8b 45 f8             	mov    -0x8(%ebp),%eax
801097c7:	01 c0                	add    %eax,%eax
801097c9:	89 c2                	mov    %eax,%edx
801097cb:	8b 45 f4             	mov    -0xc(%ebp),%eax
801097ce:	01 d0                	add    %edx,%eax
801097d0:	0f b6 00             	movzbl (%eax),%eax
801097d3:	0f b6 c0             	movzbl %al,%eax
801097d6:	c1 e0 08             	shl    $0x8,%eax
801097d9:	89 c2                	mov    %eax,%edx
801097db:	8b 45 f8             	mov    -0x8(%ebp),%eax
801097de:	01 c0                	add    %eax,%eax
801097e0:	8d 48 01             	lea    0x1(%eax),%ecx
801097e3:	8b 45 f4             	mov    -0xc(%ebp),%eax
801097e6:	01 c8                	add    %ecx,%eax
801097e8:	0f b6 00             	movzbl (%eax),%eax
801097eb:	0f b6 c0             	movzbl %al,%eax
801097ee:	01 d0                	add    %edx,%eax
801097f0:	01 45 fc             	add    %eax,-0x4(%ebp)
    if(chk_sum > 0xFFFF){
801097f3:	81 7d fc ff ff 00 00 	cmpl   $0xffff,-0x4(%ebp)
801097fa:	76 0c                	jbe    80109808 <ipv4_chksum+0x6e>
      chk_sum = (chk_sum&0xFFFF)+1;
801097fc:	8b 45 fc             	mov    -0x4(%ebp),%eax
801097ff:	0f b7 c0             	movzwl %ax,%eax
80109802:	83 c0 01             	add    $0x1,%eax
80109805:	89 45 fc             	mov    %eax,-0x4(%ebp)
  for(int i=0;i<len;i++){
80109808:	83 45 f8 01          	addl   $0x1,-0x8(%ebp)
8010980c:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
80109810:	39 45 f8             	cmp    %eax,-0x8(%ebp)
80109813:	7c af                	jl     801097c4 <ipv4_chksum+0x2a>
    }
  }
  return ~(chk_sum);
80109815:	8b 45 fc             	mov    -0x4(%ebp),%eax
80109818:	f7 d0                	not    %eax
}
8010981a:	c9                   	leave  
8010981b:	c3                   	ret    

8010981c <icmp_proc>:
#include "eth.h"

extern uchar mac_addr[6];
extern uchar my_ip[4];
extern ushort send_id;
void icmp_proc(uint buffer_addr){
8010981c:	55                   	push   %ebp
8010981d:	89 e5                	mov    %esp,%ebp
8010981f:	83 ec 18             	sub    $0x18,%esp
  struct ipv4_pkt *ipv4_p = (struct ipv4_pkt *)(buffer_addr+sizeof(struct eth_pkt));
80109822:	8b 45 08             	mov    0x8(%ebp),%eax
80109825:	83 c0 0e             	add    $0xe,%eax
80109828:	89 45 f4             	mov    %eax,-0xc(%ebp)
  struct icmp_echo_pkt *icmp_p = (struct icmp_echo_pkt *)((uint)ipv4_p + (ipv4_p->ver&0xF)*4);
8010982b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010982e:	0f b6 00             	movzbl (%eax),%eax
80109831:	0f b6 c0             	movzbl %al,%eax
80109834:	83 e0 0f             	and    $0xf,%eax
80109837:	c1 e0 02             	shl    $0x2,%eax
8010983a:	89 c2                	mov    %eax,%edx
8010983c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010983f:	01 d0                	add    %edx,%eax
80109841:	89 45 f0             	mov    %eax,-0x10(%ebp)
  if(icmp_p->code == 0){
80109844:	8b 45 f0             	mov    -0x10(%ebp),%eax
80109847:	0f b6 40 01          	movzbl 0x1(%eax),%eax
8010984b:	84 c0                	test   %al,%al
8010984d:	75 4f                	jne    8010989e <icmp_proc+0x82>
    if(icmp_p->type == ICMP_TYPE_ECHO_REQUEST){
8010984f:	8b 45 f0             	mov    -0x10(%ebp),%eax
80109852:	0f b6 00             	movzbl (%eax),%eax
80109855:	3c 08                	cmp    $0x8,%al
80109857:	75 45                	jne    8010989e <icmp_proc+0x82>
      uint send_addr = (uint)kalloc();
80109859:	e8 42 8f ff ff       	call   801027a0 <kalloc>
8010985e:	89 45 ec             	mov    %eax,-0x14(%ebp)
      uint send_size = 0;
80109861:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
      icmp_reply_pkt_create(buffer_addr,send_addr,&send_size);
80109868:	83 ec 04             	sub    $0x4,%esp
8010986b:	8d 45 e8             	lea    -0x18(%ebp),%eax
8010986e:	50                   	push   %eax
8010986f:	ff 75 ec             	push   -0x14(%ebp)
80109872:	ff 75 08             	push   0x8(%ebp)
80109875:	e8 78 00 00 00       	call   801098f2 <icmp_reply_pkt_create>
8010987a:	83 c4 10             	add    $0x10,%esp
      i8254_send(send_addr,send_size);
8010987d:	8b 45 e8             	mov    -0x18(%ebp),%eax
80109880:	83 ec 08             	sub    $0x8,%esp
80109883:	50                   	push   %eax
80109884:	ff 75 ec             	push   -0x14(%ebp)
80109887:	e8 95 f4 ff ff       	call   80108d21 <i8254_send>
8010988c:	83 c4 10             	add    $0x10,%esp
      kfree((char *)send_addr);
8010988f:	8b 45 ec             	mov    -0x14(%ebp),%eax
80109892:	83 ec 0c             	sub    $0xc,%esp
80109895:	50                   	push   %eax
80109896:	e8 6b 8e ff ff       	call   80102706 <kfree>
8010989b:	83 c4 10             	add    $0x10,%esp
    }
  }
}
8010989e:	90                   	nop
8010989f:	c9                   	leave  
801098a0:	c3                   	ret    

801098a1 <icmp_proc_req>:

void icmp_proc_req(struct icmp_echo_pkt * icmp_p){
801098a1:	55                   	push   %ebp
801098a2:	89 e5                	mov    %esp,%ebp
801098a4:	53                   	push   %ebx
801098a5:	83 ec 04             	sub    $0x4,%esp
  cprintf("ICMP ID:0x%x SEQ NUM:0x%x\n",N2H_ushort(icmp_p->id),N2H_ushort(icmp_p->seq_num));
801098a8:	8b 45 08             	mov    0x8(%ebp),%eax
801098ab:	0f b7 40 06          	movzwl 0x6(%eax),%eax
801098af:	0f b7 c0             	movzwl %ax,%eax
801098b2:	83 ec 0c             	sub    $0xc,%esp
801098b5:	50                   	push   %eax
801098b6:	e8 bd fd ff ff       	call   80109678 <N2H_ushort>
801098bb:	83 c4 10             	add    $0x10,%esp
801098be:	0f b7 d8             	movzwl %ax,%ebx
801098c1:	8b 45 08             	mov    0x8(%ebp),%eax
801098c4:	0f b7 40 04          	movzwl 0x4(%eax),%eax
801098c8:	0f b7 c0             	movzwl %ax,%eax
801098cb:	83 ec 0c             	sub    $0xc,%esp
801098ce:	50                   	push   %eax
801098cf:	e8 a4 fd ff ff       	call   80109678 <N2H_ushort>
801098d4:	83 c4 10             	add    $0x10,%esp
801098d7:	0f b7 c0             	movzwl %ax,%eax
801098da:	83 ec 04             	sub    $0x4,%esp
801098dd:	53                   	push   %ebx
801098de:	50                   	push   %eax
801098df:	68 c3 c1 10 80       	push   $0x8010c1c3
801098e4:	e8 0b 6b ff ff       	call   801003f4 <cprintf>
801098e9:	83 c4 10             	add    $0x10,%esp
}
801098ec:	90                   	nop
801098ed:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801098f0:	c9                   	leave  
801098f1:	c3                   	ret    

801098f2 <icmp_reply_pkt_create>:

void icmp_reply_pkt_create(uint recv_addr,uint send_addr,uint *send_size){
801098f2:	55                   	push   %ebp
801098f3:	89 e5                	mov    %esp,%ebp
801098f5:	83 ec 28             	sub    $0x28,%esp
  struct eth_pkt *eth_recv = (struct eth_pkt *)(recv_addr);
801098f8:	8b 45 08             	mov    0x8(%ebp),%eax
801098fb:	89 45 f4             	mov    %eax,-0xc(%ebp)
  struct ipv4_pkt *ipv4_recv = (struct ipv4_pkt *)(recv_addr+sizeof(struct eth_pkt));
801098fe:	8b 45 08             	mov    0x8(%ebp),%eax
80109901:	83 c0 0e             	add    $0xe,%eax
80109904:	89 45 f0             	mov    %eax,-0x10(%ebp)
  struct icmp_echo_pkt *icmp_recv = (struct icmp_echo_pkt *)((uint)ipv4_recv+(ipv4_recv->ver&0xF)*4);
80109907:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010990a:	0f b6 00             	movzbl (%eax),%eax
8010990d:	0f b6 c0             	movzbl %al,%eax
80109910:	83 e0 0f             	and    $0xf,%eax
80109913:	c1 e0 02             	shl    $0x2,%eax
80109916:	89 c2                	mov    %eax,%edx
80109918:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010991b:	01 d0                	add    %edx,%eax
8010991d:	89 45 ec             	mov    %eax,-0x14(%ebp)
  struct eth_pkt *eth_send = (struct eth_pkt *)(send_addr);
80109920:	8b 45 0c             	mov    0xc(%ebp),%eax
80109923:	89 45 e8             	mov    %eax,-0x18(%ebp)
  struct ipv4_pkt *ipv4_send = (struct ipv4_pkt *)(send_addr+sizeof(struct eth_pkt));
80109926:	8b 45 0c             	mov    0xc(%ebp),%eax
80109929:	83 c0 0e             	add    $0xe,%eax
8010992c:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  struct icmp_echo_pkt *icmp_send = (struct icmp_echo_pkt *)((uint)ipv4_send+sizeof(struct ipv4_pkt));
8010992f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80109932:	83 c0 14             	add    $0x14,%eax
80109935:	89 45 e0             	mov    %eax,-0x20(%ebp)
  
  *send_size = sizeof(struct eth_pkt) + sizeof(struct ipv4_pkt) + sizeof(struct icmp_echo_pkt);
80109938:	8b 45 10             	mov    0x10(%ebp),%eax
8010993b:	c7 00 62 00 00 00    	movl   $0x62,(%eax)
  memmove(eth_send->dst_mac,eth_recv->src_mac,6);
80109941:	8b 45 f4             	mov    -0xc(%ebp),%eax
80109944:	8d 50 06             	lea    0x6(%eax),%edx
80109947:	8b 45 e8             	mov    -0x18(%ebp),%eax
8010994a:	83 ec 04             	sub    $0x4,%esp
8010994d:	6a 06                	push   $0x6
8010994f:	52                   	push   %edx
80109950:	50                   	push   %eax
80109951:	e8 6c b3 ff ff       	call   80104cc2 <memmove>
80109956:	83 c4 10             	add    $0x10,%esp
  memmove(eth_send->src_mac,mac_addr,6);
80109959:	8b 45 e8             	mov    -0x18(%ebp),%eax
8010995c:	83 c0 06             	add    $0x6,%eax
8010995f:	83 ec 04             	sub    $0x4,%esp
80109962:	6a 06                	push   $0x6
80109964:	68 80 6e 19 80       	push   $0x80196e80
80109969:	50                   	push   %eax
8010996a:	e8 53 b3 ff ff       	call   80104cc2 <memmove>
8010996f:	83 c4 10             	add    $0x10,%esp
  eth_send->type[0] = 0x08;
80109972:	8b 45 e8             	mov    -0x18(%ebp),%eax
80109975:	c6 40 0c 08          	movb   $0x8,0xc(%eax)
  eth_send->type[1] = 0x00;
80109979:	8b 45 e8             	mov    -0x18(%ebp),%eax
8010997c:	c6 40 0d 00          	movb   $0x0,0xd(%eax)

  ipv4_send->ver = ((0x4)<<4)+((sizeof(struct ipv4_pkt)/4)&0xF);
80109980:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80109983:	c6 00 45             	movb   $0x45,(%eax)
  ipv4_send->srv_type = 0;
80109986:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80109989:	c6 40 01 00          	movb   $0x0,0x1(%eax)
  ipv4_send->total_len = H2N_ushort(sizeof(struct ipv4_pkt) + sizeof(struct icmp_echo_pkt));
8010998d:	83 ec 0c             	sub    $0xc,%esp
80109990:	6a 54                	push   $0x54
80109992:	e8 03 fd ff ff       	call   8010969a <H2N_ushort>
80109997:	83 c4 10             	add    $0x10,%esp
8010999a:	8b 55 e4             	mov    -0x1c(%ebp),%edx
8010999d:	66 89 42 02          	mov    %ax,0x2(%edx)
  ipv4_send->id = send_id;
801099a1:	0f b7 15 60 71 19 80 	movzwl 0x80197160,%edx
801099a8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801099ab:	66 89 50 04          	mov    %dx,0x4(%eax)
  send_id++;
801099af:	0f b7 05 60 71 19 80 	movzwl 0x80197160,%eax
801099b6:	83 c0 01             	add    $0x1,%eax
801099b9:	66 a3 60 71 19 80    	mov    %ax,0x80197160
  ipv4_send->fragment = H2N_ushort(0x4000);
801099bf:	83 ec 0c             	sub    $0xc,%esp
801099c2:	68 00 40 00 00       	push   $0x4000
801099c7:	e8 ce fc ff ff       	call   8010969a <H2N_ushort>
801099cc:	83 c4 10             	add    $0x10,%esp
801099cf:	8b 55 e4             	mov    -0x1c(%ebp),%edx
801099d2:	66 89 42 06          	mov    %ax,0x6(%edx)
  ipv4_send->ttl = 255;
801099d6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801099d9:	c6 40 08 ff          	movb   $0xff,0x8(%eax)
  ipv4_send->protocol = 0x1;
801099dd:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801099e0:	c6 40 09 01          	movb   $0x1,0x9(%eax)
  memmove(ipv4_send->src_ip,my_ip,4);
801099e4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801099e7:	83 c0 0c             	add    $0xc,%eax
801099ea:	83 ec 04             	sub    $0x4,%esp
801099ed:	6a 04                	push   $0x4
801099ef:	68 04 f5 10 80       	push   $0x8010f504
801099f4:	50                   	push   %eax
801099f5:	e8 c8 b2 ff ff       	call   80104cc2 <memmove>
801099fa:	83 c4 10             	add    $0x10,%esp
  memmove(ipv4_send->dst_ip,ipv4_recv->src_ip,4);
801099fd:	8b 45 f0             	mov    -0x10(%ebp),%eax
80109a00:	8d 50 0c             	lea    0xc(%eax),%edx
80109a03:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80109a06:	83 c0 10             	add    $0x10,%eax
80109a09:	83 ec 04             	sub    $0x4,%esp
80109a0c:	6a 04                	push   $0x4
80109a0e:	52                   	push   %edx
80109a0f:	50                   	push   %eax
80109a10:	e8 ad b2 ff ff       	call   80104cc2 <memmove>
80109a15:	83 c4 10             	add    $0x10,%esp
  ipv4_send->chk_sum = 0;
80109a18:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80109a1b:	66 c7 40 0a 00 00    	movw   $0x0,0xa(%eax)
  ipv4_send->chk_sum = H2N_ushort(ipv4_chksum((uint)ipv4_send));
80109a21:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80109a24:	83 ec 0c             	sub    $0xc,%esp
80109a27:	50                   	push   %eax
80109a28:	e8 6d fd ff ff       	call   8010979a <ipv4_chksum>
80109a2d:	83 c4 10             	add    $0x10,%esp
80109a30:	0f b7 c0             	movzwl %ax,%eax
80109a33:	83 ec 0c             	sub    $0xc,%esp
80109a36:	50                   	push   %eax
80109a37:	e8 5e fc ff ff       	call   8010969a <H2N_ushort>
80109a3c:	83 c4 10             	add    $0x10,%esp
80109a3f:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80109a42:	66 89 42 0a          	mov    %ax,0xa(%edx)

  icmp_send->type = ICMP_TYPE_ECHO_REPLY;
80109a46:	8b 45 e0             	mov    -0x20(%ebp),%eax
80109a49:	c6 00 00             	movb   $0x0,(%eax)
  icmp_send->code = 0;
80109a4c:	8b 45 e0             	mov    -0x20(%ebp),%eax
80109a4f:	c6 40 01 00          	movb   $0x0,0x1(%eax)
  icmp_send->id = icmp_recv->id;
80109a53:	8b 45 ec             	mov    -0x14(%ebp),%eax
80109a56:	0f b7 50 04          	movzwl 0x4(%eax),%edx
80109a5a:	8b 45 e0             	mov    -0x20(%ebp),%eax
80109a5d:	66 89 50 04          	mov    %dx,0x4(%eax)
  icmp_send->seq_num = icmp_recv->seq_num;
80109a61:	8b 45 ec             	mov    -0x14(%ebp),%eax
80109a64:	0f b7 50 06          	movzwl 0x6(%eax),%edx
80109a68:	8b 45 e0             	mov    -0x20(%ebp),%eax
80109a6b:	66 89 50 06          	mov    %dx,0x6(%eax)
  memmove(icmp_send->time_stamp,icmp_recv->time_stamp,8);
80109a6f:	8b 45 ec             	mov    -0x14(%ebp),%eax
80109a72:	8d 50 08             	lea    0x8(%eax),%edx
80109a75:	8b 45 e0             	mov    -0x20(%ebp),%eax
80109a78:	83 c0 08             	add    $0x8,%eax
80109a7b:	83 ec 04             	sub    $0x4,%esp
80109a7e:	6a 08                	push   $0x8
80109a80:	52                   	push   %edx
80109a81:	50                   	push   %eax
80109a82:	e8 3b b2 ff ff       	call   80104cc2 <memmove>
80109a87:	83 c4 10             	add    $0x10,%esp
  memmove(icmp_send->data,icmp_recv->data,48);
80109a8a:	8b 45 ec             	mov    -0x14(%ebp),%eax
80109a8d:	8d 50 10             	lea    0x10(%eax),%edx
80109a90:	8b 45 e0             	mov    -0x20(%ebp),%eax
80109a93:	83 c0 10             	add    $0x10,%eax
80109a96:	83 ec 04             	sub    $0x4,%esp
80109a99:	6a 30                	push   $0x30
80109a9b:	52                   	push   %edx
80109a9c:	50                   	push   %eax
80109a9d:	e8 20 b2 ff ff       	call   80104cc2 <memmove>
80109aa2:	83 c4 10             	add    $0x10,%esp
  icmp_send->chk_sum = 0;
80109aa5:	8b 45 e0             	mov    -0x20(%ebp),%eax
80109aa8:	66 c7 40 02 00 00    	movw   $0x0,0x2(%eax)
  icmp_send->chk_sum = H2N_ushort(icmp_chksum((uint)icmp_send));
80109aae:	8b 45 e0             	mov    -0x20(%ebp),%eax
80109ab1:	83 ec 0c             	sub    $0xc,%esp
80109ab4:	50                   	push   %eax
80109ab5:	e8 1c 00 00 00       	call   80109ad6 <icmp_chksum>
80109aba:	83 c4 10             	add    $0x10,%esp
80109abd:	0f b7 c0             	movzwl %ax,%eax
80109ac0:	83 ec 0c             	sub    $0xc,%esp
80109ac3:	50                   	push   %eax
80109ac4:	e8 d1 fb ff ff       	call   8010969a <H2N_ushort>
80109ac9:	83 c4 10             	add    $0x10,%esp
80109acc:	8b 55 e0             	mov    -0x20(%ebp),%edx
80109acf:	66 89 42 02          	mov    %ax,0x2(%edx)
}
80109ad3:	90                   	nop
80109ad4:	c9                   	leave  
80109ad5:	c3                   	ret    

80109ad6 <icmp_chksum>:

ushort icmp_chksum(uint icmp_addr){
80109ad6:	55                   	push   %ebp
80109ad7:	89 e5                	mov    %esp,%ebp
80109ad9:	83 ec 10             	sub    $0x10,%esp
  uchar* bin = (uchar *)icmp_addr;
80109adc:	8b 45 08             	mov    0x8(%ebp),%eax
80109adf:	89 45 f4             	mov    %eax,-0xc(%ebp)
  uint chk_sum = 0;
80109ae2:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  for(int i=0;i<32;i++){
80109ae9:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
80109af0:	eb 48                	jmp    80109b3a <icmp_chksum+0x64>
    chk_sum += (bin[i*2]<<8)+bin[i*2+1];
80109af2:	8b 45 f8             	mov    -0x8(%ebp),%eax
80109af5:	01 c0                	add    %eax,%eax
80109af7:	89 c2                	mov    %eax,%edx
80109af9:	8b 45 f4             	mov    -0xc(%ebp),%eax
80109afc:	01 d0                	add    %edx,%eax
80109afe:	0f b6 00             	movzbl (%eax),%eax
80109b01:	0f b6 c0             	movzbl %al,%eax
80109b04:	c1 e0 08             	shl    $0x8,%eax
80109b07:	89 c2                	mov    %eax,%edx
80109b09:	8b 45 f8             	mov    -0x8(%ebp),%eax
80109b0c:	01 c0                	add    %eax,%eax
80109b0e:	8d 48 01             	lea    0x1(%eax),%ecx
80109b11:	8b 45 f4             	mov    -0xc(%ebp),%eax
80109b14:	01 c8                	add    %ecx,%eax
80109b16:	0f b6 00             	movzbl (%eax),%eax
80109b19:	0f b6 c0             	movzbl %al,%eax
80109b1c:	01 d0                	add    %edx,%eax
80109b1e:	01 45 fc             	add    %eax,-0x4(%ebp)
    if(chk_sum > 0xFFFF){
80109b21:	81 7d fc ff ff 00 00 	cmpl   $0xffff,-0x4(%ebp)
80109b28:	76 0c                	jbe    80109b36 <icmp_chksum+0x60>
      chk_sum = (chk_sum&0xFFFF)+1;
80109b2a:	8b 45 fc             	mov    -0x4(%ebp),%eax
80109b2d:	0f b7 c0             	movzwl %ax,%eax
80109b30:	83 c0 01             	add    $0x1,%eax
80109b33:	89 45 fc             	mov    %eax,-0x4(%ebp)
  for(int i=0;i<32;i++){
80109b36:	83 45 f8 01          	addl   $0x1,-0x8(%ebp)
80109b3a:	83 7d f8 1f          	cmpl   $0x1f,-0x8(%ebp)
80109b3e:	7e b2                	jle    80109af2 <icmp_chksum+0x1c>
    }
  }
  return ~(chk_sum);
80109b40:	8b 45 fc             	mov    -0x4(%ebp),%eax
80109b43:	f7 d0                	not    %eax
}
80109b45:	c9                   	leave  
80109b46:	c3                   	ret    

80109b47 <tcp_proc>:
extern ushort send_id;
extern uchar mac_addr[6];
extern uchar my_ip[4];
int fin_flag = 0;

void tcp_proc(uint buffer_addr){
80109b47:	55                   	push   %ebp
80109b48:	89 e5                	mov    %esp,%ebp
80109b4a:	83 ec 38             	sub    $0x38,%esp
  struct ipv4_pkt *ipv4_p = (struct ipv4_pkt *)(buffer_addr + sizeof(struct eth_pkt));
80109b4d:	8b 45 08             	mov    0x8(%ebp),%eax
80109b50:	83 c0 0e             	add    $0xe,%eax
80109b53:	89 45 f4             	mov    %eax,-0xc(%ebp)
  struct tcp_pkt *tcp_p = (struct tcp_pkt *)((uint)ipv4_p + (ipv4_p->ver&0xF)*4);
80109b56:	8b 45 f4             	mov    -0xc(%ebp),%eax
80109b59:	0f b6 00             	movzbl (%eax),%eax
80109b5c:	0f b6 c0             	movzbl %al,%eax
80109b5f:	83 e0 0f             	and    $0xf,%eax
80109b62:	c1 e0 02             	shl    $0x2,%eax
80109b65:	89 c2                	mov    %eax,%edx
80109b67:	8b 45 f4             	mov    -0xc(%ebp),%eax
80109b6a:	01 d0                	add    %edx,%eax
80109b6c:	89 45 f0             	mov    %eax,-0x10(%ebp)
  char *payload = (char *)((uint)tcp_p + 20);
80109b6f:	8b 45 f0             	mov    -0x10(%ebp),%eax
80109b72:	83 c0 14             	add    $0x14,%eax
80109b75:	89 45 ec             	mov    %eax,-0x14(%ebp)
  uint send_addr = (uint)kalloc();
80109b78:	e8 23 8c ff ff       	call   801027a0 <kalloc>
80109b7d:	89 45 e8             	mov    %eax,-0x18(%ebp)
  uint send_size = 0;
80109b80:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
  if(tcp_p->code_bits[1]&TCP_CODEBITS_SYN){
80109b87:	8b 45 f0             	mov    -0x10(%ebp),%eax
80109b8a:	0f b6 40 0d          	movzbl 0xd(%eax),%eax
80109b8e:	0f b6 c0             	movzbl %al,%eax
80109b91:	83 e0 02             	and    $0x2,%eax
80109b94:	85 c0                	test   %eax,%eax
80109b96:	74 3d                	je     80109bd5 <tcp_proc+0x8e>
    tcp_pkt_create(buffer_addr,send_addr,&send_size,TCP_CODEBITS_ACK | TCP_CODEBITS_SYN,0);
80109b98:	83 ec 0c             	sub    $0xc,%esp
80109b9b:	6a 00                	push   $0x0
80109b9d:	6a 12                	push   $0x12
80109b9f:	8d 45 dc             	lea    -0x24(%ebp),%eax
80109ba2:	50                   	push   %eax
80109ba3:	ff 75 e8             	push   -0x18(%ebp)
80109ba6:	ff 75 08             	push   0x8(%ebp)
80109ba9:	e8 a2 01 00 00       	call   80109d50 <tcp_pkt_create>
80109bae:	83 c4 20             	add    $0x20,%esp
    i8254_send(send_addr,send_size);
80109bb1:	8b 45 dc             	mov    -0x24(%ebp),%eax
80109bb4:	83 ec 08             	sub    $0x8,%esp
80109bb7:	50                   	push   %eax
80109bb8:	ff 75 e8             	push   -0x18(%ebp)
80109bbb:	e8 61 f1 ff ff       	call   80108d21 <i8254_send>
80109bc0:	83 c4 10             	add    $0x10,%esp
    seq_num++;
80109bc3:	a1 64 71 19 80       	mov    0x80197164,%eax
80109bc8:	83 c0 01             	add    $0x1,%eax
80109bcb:	a3 64 71 19 80       	mov    %eax,0x80197164
80109bd0:	e9 69 01 00 00       	jmp    80109d3e <tcp_proc+0x1f7>
  }else if(tcp_p->code_bits[1] == (TCP_CODEBITS_PSH | TCP_CODEBITS_ACK)){
80109bd5:	8b 45 f0             	mov    -0x10(%ebp),%eax
80109bd8:	0f b6 40 0d          	movzbl 0xd(%eax),%eax
80109bdc:	3c 18                	cmp    $0x18,%al
80109bde:	0f 85 10 01 00 00    	jne    80109cf4 <tcp_proc+0x1ad>
    if(memcmp(payload,"GET",3)){
80109be4:	83 ec 04             	sub    $0x4,%esp
80109be7:	6a 03                	push   $0x3
80109be9:	68 de c1 10 80       	push   $0x8010c1de
80109bee:	ff 75 ec             	push   -0x14(%ebp)
80109bf1:	e8 74 b0 ff ff       	call   80104c6a <memcmp>
80109bf6:	83 c4 10             	add    $0x10,%esp
80109bf9:	85 c0                	test   %eax,%eax
80109bfb:	74 74                	je     80109c71 <tcp_proc+0x12a>
      cprintf("ACK PSH\n");
80109bfd:	83 ec 0c             	sub    $0xc,%esp
80109c00:	68 e2 c1 10 80       	push   $0x8010c1e2
80109c05:	e8 ea 67 ff ff       	call   801003f4 <cprintf>
80109c0a:	83 c4 10             	add    $0x10,%esp
      tcp_pkt_create(buffer_addr,send_addr,&send_size,TCP_CODEBITS_ACK,0);
80109c0d:	83 ec 0c             	sub    $0xc,%esp
80109c10:	6a 00                	push   $0x0
80109c12:	6a 10                	push   $0x10
80109c14:	8d 45 dc             	lea    -0x24(%ebp),%eax
80109c17:	50                   	push   %eax
80109c18:	ff 75 e8             	push   -0x18(%ebp)
80109c1b:	ff 75 08             	push   0x8(%ebp)
80109c1e:	e8 2d 01 00 00       	call   80109d50 <tcp_pkt_create>
80109c23:	83 c4 20             	add    $0x20,%esp
      i8254_send(send_addr,send_size);
80109c26:	8b 45 dc             	mov    -0x24(%ebp),%eax
80109c29:	83 ec 08             	sub    $0x8,%esp
80109c2c:	50                   	push   %eax
80109c2d:	ff 75 e8             	push   -0x18(%ebp)
80109c30:	e8 ec f0 ff ff       	call   80108d21 <i8254_send>
80109c35:	83 c4 10             	add    $0x10,%esp
      uint send_payload = (send_addr + sizeof(struct eth_pkt) + sizeof(struct ipv4_pkt) + sizeof(struct tcp_pkt));
80109c38:	8b 45 e8             	mov    -0x18(%ebp),%eax
80109c3b:	83 c0 36             	add    $0x36,%eax
80109c3e:	89 45 e0             	mov    %eax,-0x20(%ebp)
      uint payload_size;
      http_proc(0,0,send_payload,&payload_size);
80109c41:	8d 45 d8             	lea    -0x28(%ebp),%eax
80109c44:	50                   	push   %eax
80109c45:	ff 75 e0             	push   -0x20(%ebp)
80109c48:	6a 00                	push   $0x0
80109c4a:	6a 00                	push   $0x0
80109c4c:	e8 5a 04 00 00       	call   8010a0ab <http_proc>
80109c51:	83 c4 10             	add    $0x10,%esp
      tcp_pkt_create(buffer_addr,send_addr,&send_size,(TCP_CODEBITS_ACK|TCP_CODEBITS_PSH),payload_size);
80109c54:	8b 45 d8             	mov    -0x28(%ebp),%eax
80109c57:	83 ec 0c             	sub    $0xc,%esp
80109c5a:	50                   	push   %eax
80109c5b:	6a 18                	push   $0x18
80109c5d:	8d 45 dc             	lea    -0x24(%ebp),%eax
80109c60:	50                   	push   %eax
80109c61:	ff 75 e8             	push   -0x18(%ebp)
80109c64:	ff 75 08             	push   0x8(%ebp)
80109c67:	e8 e4 00 00 00       	call   80109d50 <tcp_pkt_create>
80109c6c:	83 c4 20             	add    $0x20,%esp
80109c6f:	eb 62                	jmp    80109cd3 <tcp_proc+0x18c>
    }else{
     tcp_pkt_create(buffer_addr,send_addr,&send_size,TCP_CODEBITS_ACK,0);
80109c71:	83 ec 0c             	sub    $0xc,%esp
80109c74:	6a 00                	push   $0x0
80109c76:	6a 10                	push   $0x10
80109c78:	8d 45 dc             	lea    -0x24(%ebp),%eax
80109c7b:	50                   	push   %eax
80109c7c:	ff 75 e8             	push   -0x18(%ebp)
80109c7f:	ff 75 08             	push   0x8(%ebp)
80109c82:	e8 c9 00 00 00       	call   80109d50 <tcp_pkt_create>
80109c87:	83 c4 20             	add    $0x20,%esp
     i8254_send(send_addr,send_size);
80109c8a:	8b 45 dc             	mov    -0x24(%ebp),%eax
80109c8d:	83 ec 08             	sub    $0x8,%esp
80109c90:	50                   	push   %eax
80109c91:	ff 75 e8             	push   -0x18(%ebp)
80109c94:	e8 88 f0 ff ff       	call   80108d21 <i8254_send>
80109c99:	83 c4 10             	add    $0x10,%esp
      uint send_payload = (send_addr + sizeof(struct eth_pkt) + sizeof(struct ipv4_pkt) + sizeof(struct tcp_pkt));
80109c9c:	8b 45 e8             	mov    -0x18(%ebp),%eax
80109c9f:	83 c0 36             	add    $0x36,%eax
80109ca2:	89 45 e4             	mov    %eax,-0x1c(%ebp)
      uint payload_size;
      http_proc(0,0,send_payload,&payload_size);
80109ca5:	8d 45 d4             	lea    -0x2c(%ebp),%eax
80109ca8:	50                   	push   %eax
80109ca9:	ff 75 e4             	push   -0x1c(%ebp)
80109cac:	6a 00                	push   $0x0
80109cae:	6a 00                	push   $0x0
80109cb0:	e8 f6 03 00 00       	call   8010a0ab <http_proc>
80109cb5:	83 c4 10             	add    $0x10,%esp
      tcp_pkt_create(buffer_addr,send_addr,&send_size,(TCP_CODEBITS_ACK|TCP_CODEBITS_PSH),payload_size);
80109cb8:	8b 45 d4             	mov    -0x2c(%ebp),%eax
80109cbb:	83 ec 0c             	sub    $0xc,%esp
80109cbe:	50                   	push   %eax
80109cbf:	6a 18                	push   $0x18
80109cc1:	8d 45 dc             	lea    -0x24(%ebp),%eax
80109cc4:	50                   	push   %eax
80109cc5:	ff 75 e8             	push   -0x18(%ebp)
80109cc8:	ff 75 08             	push   0x8(%ebp)
80109ccb:	e8 80 00 00 00       	call   80109d50 <tcp_pkt_create>
80109cd0:	83 c4 20             	add    $0x20,%esp
    }
    i8254_send(send_addr,send_size);
80109cd3:	8b 45 dc             	mov    -0x24(%ebp),%eax
80109cd6:	83 ec 08             	sub    $0x8,%esp
80109cd9:	50                   	push   %eax
80109cda:	ff 75 e8             	push   -0x18(%ebp)
80109cdd:	e8 3f f0 ff ff       	call   80108d21 <i8254_send>
80109ce2:	83 c4 10             	add    $0x10,%esp
    seq_num++;
80109ce5:	a1 64 71 19 80       	mov    0x80197164,%eax
80109cea:	83 c0 01             	add    $0x1,%eax
80109ced:	a3 64 71 19 80       	mov    %eax,0x80197164
80109cf2:	eb 4a                	jmp    80109d3e <tcp_proc+0x1f7>
  }else if(tcp_p->code_bits[1] == TCP_CODEBITS_ACK){
80109cf4:	8b 45 f0             	mov    -0x10(%ebp),%eax
80109cf7:	0f b6 40 0d          	movzbl 0xd(%eax),%eax
80109cfb:	3c 10                	cmp    $0x10,%al
80109cfd:	75 3f                	jne    80109d3e <tcp_proc+0x1f7>
    if(fin_flag == 1){
80109cff:	a1 68 71 19 80       	mov    0x80197168,%eax
80109d04:	83 f8 01             	cmp    $0x1,%eax
80109d07:	75 35                	jne    80109d3e <tcp_proc+0x1f7>
      tcp_pkt_create(buffer_addr,send_addr,&send_size,TCP_CODEBITS_FIN,0);
80109d09:	83 ec 0c             	sub    $0xc,%esp
80109d0c:	6a 00                	push   $0x0
80109d0e:	6a 01                	push   $0x1
80109d10:	8d 45 dc             	lea    -0x24(%ebp),%eax
80109d13:	50                   	push   %eax
80109d14:	ff 75 e8             	push   -0x18(%ebp)
80109d17:	ff 75 08             	push   0x8(%ebp)
80109d1a:	e8 31 00 00 00       	call   80109d50 <tcp_pkt_create>
80109d1f:	83 c4 20             	add    $0x20,%esp
      i8254_send(send_addr,send_size);
80109d22:	8b 45 dc             	mov    -0x24(%ebp),%eax
80109d25:	83 ec 08             	sub    $0x8,%esp
80109d28:	50                   	push   %eax
80109d29:	ff 75 e8             	push   -0x18(%ebp)
80109d2c:	e8 f0 ef ff ff       	call   80108d21 <i8254_send>
80109d31:	83 c4 10             	add    $0x10,%esp
      fin_flag = 0;
80109d34:	c7 05 68 71 19 80 00 	movl   $0x0,0x80197168
80109d3b:	00 00 00 
    }
  }
  kfree((char *)send_addr);
80109d3e:	8b 45 e8             	mov    -0x18(%ebp),%eax
80109d41:	83 ec 0c             	sub    $0xc,%esp
80109d44:	50                   	push   %eax
80109d45:	e8 bc 89 ff ff       	call   80102706 <kfree>
80109d4a:	83 c4 10             	add    $0x10,%esp
}
80109d4d:	90                   	nop
80109d4e:	c9                   	leave  
80109d4f:	c3                   	ret    

80109d50 <tcp_pkt_create>:

void tcp_pkt_create(uint recv_addr,uint send_addr,uint *send_size,uint pkt_type,uint payload_size){
80109d50:	55                   	push   %ebp
80109d51:	89 e5                	mov    %esp,%ebp
80109d53:	83 ec 28             	sub    $0x28,%esp
  struct eth_pkt *eth_recv = (struct eth_pkt *)(recv_addr);
80109d56:	8b 45 08             	mov    0x8(%ebp),%eax
80109d59:	89 45 f4             	mov    %eax,-0xc(%ebp)
  struct ipv4_pkt *ipv4_recv = (struct ipv4_pkt *)(recv_addr+sizeof(struct eth_pkt));
80109d5c:	8b 45 08             	mov    0x8(%ebp),%eax
80109d5f:	83 c0 0e             	add    $0xe,%eax
80109d62:	89 45 f0             	mov    %eax,-0x10(%ebp)
  struct tcp_pkt *tcp_recv = (struct tcp_pkt *)((uint)ipv4_recv + (ipv4_recv->ver&0xF)*4);
80109d65:	8b 45 f0             	mov    -0x10(%ebp),%eax
80109d68:	0f b6 00             	movzbl (%eax),%eax
80109d6b:	0f b6 c0             	movzbl %al,%eax
80109d6e:	83 e0 0f             	and    $0xf,%eax
80109d71:	c1 e0 02             	shl    $0x2,%eax
80109d74:	89 c2                	mov    %eax,%edx
80109d76:	8b 45 f0             	mov    -0x10(%ebp),%eax
80109d79:	01 d0                	add    %edx,%eax
80109d7b:	89 45 ec             	mov    %eax,-0x14(%ebp)

  struct eth_pkt *eth_send = (struct eth_pkt *)(send_addr);
80109d7e:	8b 45 0c             	mov    0xc(%ebp),%eax
80109d81:	89 45 e8             	mov    %eax,-0x18(%ebp)
  struct ipv4_pkt *ipv4_send = (struct ipv4_pkt *)(send_addr + sizeof(struct eth_pkt));
80109d84:	8b 45 0c             	mov    0xc(%ebp),%eax
80109d87:	83 c0 0e             	add    $0xe,%eax
80109d8a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  struct tcp_pkt *tcp_send = (struct tcp_pkt *)((uint)ipv4_send + sizeof(struct ipv4_pkt));
80109d8d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80109d90:	83 c0 14             	add    $0x14,%eax
80109d93:	89 45 e0             	mov    %eax,-0x20(%ebp)

  *send_size = sizeof(struct eth_pkt) + sizeof(struct ipv4_pkt) + sizeof(struct tcp_pkt) + payload_size;
80109d96:	8b 45 18             	mov    0x18(%ebp),%eax
80109d99:	8d 50 36             	lea    0x36(%eax),%edx
80109d9c:	8b 45 10             	mov    0x10(%ebp),%eax
80109d9f:	89 10                	mov    %edx,(%eax)

  memmove(eth_send->dst_mac,eth_recv->src_mac,6);
80109da1:	8b 45 f4             	mov    -0xc(%ebp),%eax
80109da4:	8d 50 06             	lea    0x6(%eax),%edx
80109da7:	8b 45 e8             	mov    -0x18(%ebp),%eax
80109daa:	83 ec 04             	sub    $0x4,%esp
80109dad:	6a 06                	push   $0x6
80109daf:	52                   	push   %edx
80109db0:	50                   	push   %eax
80109db1:	e8 0c af ff ff       	call   80104cc2 <memmove>
80109db6:	83 c4 10             	add    $0x10,%esp
  memmove(eth_send->src_mac,mac_addr,6);
80109db9:	8b 45 e8             	mov    -0x18(%ebp),%eax
80109dbc:	83 c0 06             	add    $0x6,%eax
80109dbf:	83 ec 04             	sub    $0x4,%esp
80109dc2:	6a 06                	push   $0x6
80109dc4:	68 80 6e 19 80       	push   $0x80196e80
80109dc9:	50                   	push   %eax
80109dca:	e8 f3 ae ff ff       	call   80104cc2 <memmove>
80109dcf:	83 c4 10             	add    $0x10,%esp
  eth_send->type[0] = 0x08;
80109dd2:	8b 45 e8             	mov    -0x18(%ebp),%eax
80109dd5:	c6 40 0c 08          	movb   $0x8,0xc(%eax)
  eth_send->type[1] = 0x00;
80109dd9:	8b 45 e8             	mov    -0x18(%ebp),%eax
80109ddc:	c6 40 0d 00          	movb   $0x0,0xd(%eax)

  ipv4_send->ver = ((0x4)<<4)+((sizeof(struct ipv4_pkt)/4)&0xF);
80109de0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80109de3:	c6 00 45             	movb   $0x45,(%eax)
  ipv4_send->srv_type = 0;
80109de6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80109de9:	c6 40 01 00          	movb   $0x0,0x1(%eax)
  ipv4_send->total_len = H2N_ushort(sizeof(struct ipv4_pkt) + sizeof(struct tcp_pkt) + payload_size);
80109ded:	8b 45 18             	mov    0x18(%ebp),%eax
80109df0:	83 c0 28             	add    $0x28,%eax
80109df3:	0f b7 c0             	movzwl %ax,%eax
80109df6:	83 ec 0c             	sub    $0xc,%esp
80109df9:	50                   	push   %eax
80109dfa:	e8 9b f8 ff ff       	call   8010969a <H2N_ushort>
80109dff:	83 c4 10             	add    $0x10,%esp
80109e02:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80109e05:	66 89 42 02          	mov    %ax,0x2(%edx)
  ipv4_send->id = send_id;
80109e09:	0f b7 15 60 71 19 80 	movzwl 0x80197160,%edx
80109e10:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80109e13:	66 89 50 04          	mov    %dx,0x4(%eax)
  send_id++;
80109e17:	0f b7 05 60 71 19 80 	movzwl 0x80197160,%eax
80109e1e:	83 c0 01             	add    $0x1,%eax
80109e21:	66 a3 60 71 19 80    	mov    %ax,0x80197160
  ipv4_send->fragment = H2N_ushort(0x0000);
80109e27:	83 ec 0c             	sub    $0xc,%esp
80109e2a:	6a 00                	push   $0x0
80109e2c:	e8 69 f8 ff ff       	call   8010969a <H2N_ushort>
80109e31:	83 c4 10             	add    $0x10,%esp
80109e34:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80109e37:	66 89 42 06          	mov    %ax,0x6(%edx)
  ipv4_send->ttl = 255;
80109e3b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80109e3e:	c6 40 08 ff          	movb   $0xff,0x8(%eax)
  ipv4_send->protocol = IPV4_TYPE_TCP;
80109e42:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80109e45:	c6 40 09 06          	movb   $0x6,0x9(%eax)
  memmove(ipv4_send->src_ip,my_ip,4);
80109e49:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80109e4c:	83 c0 0c             	add    $0xc,%eax
80109e4f:	83 ec 04             	sub    $0x4,%esp
80109e52:	6a 04                	push   $0x4
80109e54:	68 04 f5 10 80       	push   $0x8010f504
80109e59:	50                   	push   %eax
80109e5a:	e8 63 ae ff ff       	call   80104cc2 <memmove>
80109e5f:	83 c4 10             	add    $0x10,%esp
  memmove(ipv4_send->dst_ip,ipv4_recv->src_ip,4);
80109e62:	8b 45 f0             	mov    -0x10(%ebp),%eax
80109e65:	8d 50 0c             	lea    0xc(%eax),%edx
80109e68:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80109e6b:	83 c0 10             	add    $0x10,%eax
80109e6e:	83 ec 04             	sub    $0x4,%esp
80109e71:	6a 04                	push   $0x4
80109e73:	52                   	push   %edx
80109e74:	50                   	push   %eax
80109e75:	e8 48 ae ff ff       	call   80104cc2 <memmove>
80109e7a:	83 c4 10             	add    $0x10,%esp
  ipv4_send->chk_sum = 0;
80109e7d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80109e80:	66 c7 40 0a 00 00    	movw   $0x0,0xa(%eax)
  ipv4_send->chk_sum = H2N_ushort(ipv4_chksum((uint)ipv4_send));
80109e86:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80109e89:	83 ec 0c             	sub    $0xc,%esp
80109e8c:	50                   	push   %eax
80109e8d:	e8 08 f9 ff ff       	call   8010979a <ipv4_chksum>
80109e92:	83 c4 10             	add    $0x10,%esp
80109e95:	0f b7 c0             	movzwl %ax,%eax
80109e98:	83 ec 0c             	sub    $0xc,%esp
80109e9b:	50                   	push   %eax
80109e9c:	e8 f9 f7 ff ff       	call   8010969a <H2N_ushort>
80109ea1:	83 c4 10             	add    $0x10,%esp
80109ea4:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80109ea7:	66 89 42 0a          	mov    %ax,0xa(%edx)
  

  tcp_send->src_port = tcp_recv->dst_port;
80109eab:	8b 45 ec             	mov    -0x14(%ebp),%eax
80109eae:	0f b7 50 02          	movzwl 0x2(%eax),%edx
80109eb2:	8b 45 e0             	mov    -0x20(%ebp),%eax
80109eb5:	66 89 10             	mov    %dx,(%eax)
  tcp_send->dst_port = tcp_recv->src_port;
80109eb8:	8b 45 ec             	mov    -0x14(%ebp),%eax
80109ebb:	0f b7 10             	movzwl (%eax),%edx
80109ebe:	8b 45 e0             	mov    -0x20(%ebp),%eax
80109ec1:	66 89 50 02          	mov    %dx,0x2(%eax)
  tcp_send->seq_num = H2N_uint(seq_num);
80109ec5:	a1 64 71 19 80       	mov    0x80197164,%eax
80109eca:	83 ec 0c             	sub    $0xc,%esp
80109ecd:	50                   	push   %eax
80109ece:	e8 e9 f7 ff ff       	call   801096bc <H2N_uint>
80109ed3:	83 c4 10             	add    $0x10,%esp
80109ed6:	8b 55 e0             	mov    -0x20(%ebp),%edx
80109ed9:	89 42 04             	mov    %eax,0x4(%edx)
  tcp_send->ack_num = tcp_recv->seq_num + (1<<(8*3));
80109edc:	8b 45 ec             	mov    -0x14(%ebp),%eax
80109edf:	8b 40 04             	mov    0x4(%eax),%eax
80109ee2:	8d 90 00 00 00 01    	lea    0x1000000(%eax),%edx
80109ee8:	8b 45 e0             	mov    -0x20(%ebp),%eax
80109eeb:	89 50 08             	mov    %edx,0x8(%eax)

  tcp_send->code_bits[0] = 0;
80109eee:	8b 45 e0             	mov    -0x20(%ebp),%eax
80109ef1:	c6 40 0c 00          	movb   $0x0,0xc(%eax)
  tcp_send->code_bits[1] = 0;
80109ef5:	8b 45 e0             	mov    -0x20(%ebp),%eax
80109ef8:	c6 40 0d 00          	movb   $0x0,0xd(%eax)
  tcp_send->code_bits[0] = 5<<4;
80109efc:	8b 45 e0             	mov    -0x20(%ebp),%eax
80109eff:	c6 40 0c 50          	movb   $0x50,0xc(%eax)
  tcp_send->code_bits[1] = pkt_type;
80109f03:	8b 45 14             	mov    0x14(%ebp),%eax
80109f06:	89 c2                	mov    %eax,%edx
80109f08:	8b 45 e0             	mov    -0x20(%ebp),%eax
80109f0b:	88 50 0d             	mov    %dl,0xd(%eax)

  tcp_send->window = H2N_ushort(14480);
80109f0e:	83 ec 0c             	sub    $0xc,%esp
80109f11:	68 90 38 00 00       	push   $0x3890
80109f16:	e8 7f f7 ff ff       	call   8010969a <H2N_ushort>
80109f1b:	83 c4 10             	add    $0x10,%esp
80109f1e:	8b 55 e0             	mov    -0x20(%ebp),%edx
80109f21:	66 89 42 0e          	mov    %ax,0xe(%edx)
  tcp_send->urgent_ptr = 0;
80109f25:	8b 45 e0             	mov    -0x20(%ebp),%eax
80109f28:	66 c7 40 12 00 00    	movw   $0x0,0x12(%eax)
  tcp_send->chk_sum = 0;
80109f2e:	8b 45 e0             	mov    -0x20(%ebp),%eax
80109f31:	66 c7 40 10 00 00    	movw   $0x0,0x10(%eax)

  tcp_send->chk_sum = H2N_ushort(tcp_chksum((uint)(ipv4_send))+8);
80109f37:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80109f3a:	83 ec 0c             	sub    $0xc,%esp
80109f3d:	50                   	push   %eax
80109f3e:	e8 1f 00 00 00       	call   80109f62 <tcp_chksum>
80109f43:	83 c4 10             	add    $0x10,%esp
80109f46:	83 c0 08             	add    $0x8,%eax
80109f49:	0f b7 c0             	movzwl %ax,%eax
80109f4c:	83 ec 0c             	sub    $0xc,%esp
80109f4f:	50                   	push   %eax
80109f50:	e8 45 f7 ff ff       	call   8010969a <H2N_ushort>
80109f55:	83 c4 10             	add    $0x10,%esp
80109f58:	8b 55 e0             	mov    -0x20(%ebp),%edx
80109f5b:	66 89 42 10          	mov    %ax,0x10(%edx)


}
80109f5f:	90                   	nop
80109f60:	c9                   	leave  
80109f61:	c3                   	ret    

80109f62 <tcp_chksum>:

ushort tcp_chksum(uint tcp_addr){
80109f62:	55                   	push   %ebp
80109f63:	89 e5                	mov    %esp,%ebp
80109f65:	83 ec 38             	sub    $0x38,%esp
  struct ipv4_pkt *ipv4_p = (struct ipv4_pkt *)(tcp_addr);
80109f68:	8b 45 08             	mov    0x8(%ebp),%eax
80109f6b:	89 45 e8             	mov    %eax,-0x18(%ebp)
  struct tcp_pkt *tcp_p = (struct tcp_pkt *)((uint)ipv4_p + sizeof(struct ipv4_pkt));
80109f6e:	8b 45 e8             	mov    -0x18(%ebp),%eax
80109f71:	83 c0 14             	add    $0x14,%eax
80109f74:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  struct tcp_dummy tcp_dummy;
  
  memmove(tcp_dummy.src_ip,my_ip,4);
80109f77:	83 ec 04             	sub    $0x4,%esp
80109f7a:	6a 04                	push   $0x4
80109f7c:	68 04 f5 10 80       	push   $0x8010f504
80109f81:	8d 45 d4             	lea    -0x2c(%ebp),%eax
80109f84:	50                   	push   %eax
80109f85:	e8 38 ad ff ff       	call   80104cc2 <memmove>
80109f8a:	83 c4 10             	add    $0x10,%esp
  memmove(tcp_dummy.dst_ip,ipv4_p->src_ip,4);
80109f8d:	8b 45 e8             	mov    -0x18(%ebp),%eax
80109f90:	83 c0 0c             	add    $0xc,%eax
80109f93:	83 ec 04             	sub    $0x4,%esp
80109f96:	6a 04                	push   $0x4
80109f98:	50                   	push   %eax
80109f99:	8d 45 d4             	lea    -0x2c(%ebp),%eax
80109f9c:	83 c0 04             	add    $0x4,%eax
80109f9f:	50                   	push   %eax
80109fa0:	e8 1d ad ff ff       	call   80104cc2 <memmove>
80109fa5:	83 c4 10             	add    $0x10,%esp
  tcp_dummy.padding = 0;
80109fa8:	c6 45 dc 00          	movb   $0x0,-0x24(%ebp)
  tcp_dummy.protocol = IPV4_TYPE_TCP;
80109fac:	c6 45 dd 06          	movb   $0x6,-0x23(%ebp)
  tcp_dummy.tcp_len = H2N_ushort(N2H_ushort(ipv4_p->total_len) - sizeof(struct ipv4_pkt));
80109fb0:	8b 45 e8             	mov    -0x18(%ebp),%eax
80109fb3:	0f b7 40 02          	movzwl 0x2(%eax),%eax
80109fb7:	0f b7 c0             	movzwl %ax,%eax
80109fba:	83 ec 0c             	sub    $0xc,%esp
80109fbd:	50                   	push   %eax
80109fbe:	e8 b5 f6 ff ff       	call   80109678 <N2H_ushort>
80109fc3:	83 c4 10             	add    $0x10,%esp
80109fc6:	83 e8 14             	sub    $0x14,%eax
80109fc9:	0f b7 c0             	movzwl %ax,%eax
80109fcc:	83 ec 0c             	sub    $0xc,%esp
80109fcf:	50                   	push   %eax
80109fd0:	e8 c5 f6 ff ff       	call   8010969a <H2N_ushort>
80109fd5:	83 c4 10             	add    $0x10,%esp
80109fd8:	66 89 45 de          	mov    %ax,-0x22(%ebp)
  uint chk_sum = 0;
80109fdc:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  uchar *bin = (uchar *)(&tcp_dummy);
80109fe3:	8d 45 d4             	lea    -0x2c(%ebp),%eax
80109fe6:	89 45 e0             	mov    %eax,-0x20(%ebp)
  for(int i=0;i<6;i++){
80109fe9:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
80109ff0:	eb 33                	jmp    8010a025 <tcp_chksum+0xc3>
    chk_sum += (bin[i*2]<<8)+bin[i*2+1];
80109ff2:	8b 45 f0             	mov    -0x10(%ebp),%eax
80109ff5:	01 c0                	add    %eax,%eax
80109ff7:	89 c2                	mov    %eax,%edx
80109ff9:	8b 45 e0             	mov    -0x20(%ebp),%eax
80109ffc:	01 d0                	add    %edx,%eax
80109ffe:	0f b6 00             	movzbl (%eax),%eax
8010a001:	0f b6 c0             	movzbl %al,%eax
8010a004:	c1 e0 08             	shl    $0x8,%eax
8010a007:	89 c2                	mov    %eax,%edx
8010a009:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010a00c:	01 c0                	add    %eax,%eax
8010a00e:	8d 48 01             	lea    0x1(%eax),%ecx
8010a011:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010a014:	01 c8                	add    %ecx,%eax
8010a016:	0f b6 00             	movzbl (%eax),%eax
8010a019:	0f b6 c0             	movzbl %al,%eax
8010a01c:	01 d0                	add    %edx,%eax
8010a01e:	01 45 f4             	add    %eax,-0xc(%ebp)
  for(int i=0;i<6;i++){
8010a021:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
8010a025:	83 7d f0 05          	cmpl   $0x5,-0x10(%ebp)
8010a029:	7e c7                	jle    80109ff2 <tcp_chksum+0x90>
  }

  bin = (uchar *)(tcp_p);
8010a02b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010a02e:	89 45 e0             	mov    %eax,-0x20(%ebp)
  for(int i=0;i<(N2H_ushort(tcp_dummy.tcp_len)/2);i++){
8010a031:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
8010a038:	eb 33                	jmp    8010a06d <tcp_chksum+0x10b>
    chk_sum += (bin[i*2]<<8)+bin[i*2+1];
8010a03a:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010a03d:	01 c0                	add    %eax,%eax
8010a03f:	89 c2                	mov    %eax,%edx
8010a041:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010a044:	01 d0                	add    %edx,%eax
8010a046:	0f b6 00             	movzbl (%eax),%eax
8010a049:	0f b6 c0             	movzbl %al,%eax
8010a04c:	c1 e0 08             	shl    $0x8,%eax
8010a04f:	89 c2                	mov    %eax,%edx
8010a051:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010a054:	01 c0                	add    %eax,%eax
8010a056:	8d 48 01             	lea    0x1(%eax),%ecx
8010a059:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010a05c:	01 c8                	add    %ecx,%eax
8010a05e:	0f b6 00             	movzbl (%eax),%eax
8010a061:	0f b6 c0             	movzbl %al,%eax
8010a064:	01 d0                	add    %edx,%eax
8010a066:	01 45 f4             	add    %eax,-0xc(%ebp)
  for(int i=0;i<(N2H_ushort(tcp_dummy.tcp_len)/2);i++){
8010a069:	83 45 ec 01          	addl   $0x1,-0x14(%ebp)
8010a06d:	0f b7 45 de          	movzwl -0x22(%ebp),%eax
8010a071:	0f b7 c0             	movzwl %ax,%eax
8010a074:	83 ec 0c             	sub    $0xc,%esp
8010a077:	50                   	push   %eax
8010a078:	e8 fb f5 ff ff       	call   80109678 <N2H_ushort>
8010a07d:	83 c4 10             	add    $0x10,%esp
8010a080:	66 d1 e8             	shr    %ax
8010a083:	0f b7 c0             	movzwl %ax,%eax
8010a086:	39 45 ec             	cmp    %eax,-0x14(%ebp)
8010a089:	7c af                	jl     8010a03a <tcp_chksum+0xd8>
  }
  chk_sum += (chk_sum>>8*2);
8010a08b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010a08e:	c1 e8 10             	shr    $0x10,%eax
8010a091:	01 45 f4             	add    %eax,-0xc(%ebp)
  return ~(chk_sum);
8010a094:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010a097:	f7 d0                	not    %eax
}
8010a099:	c9                   	leave  
8010a09a:	c3                   	ret    

8010a09b <tcp_fin>:

void tcp_fin(){
8010a09b:	55                   	push   %ebp
8010a09c:	89 e5                	mov    %esp,%ebp
  fin_flag =1;
8010a09e:	c7 05 68 71 19 80 01 	movl   $0x1,0x80197168
8010a0a5:	00 00 00 
}
8010a0a8:	90                   	nop
8010a0a9:	5d                   	pop    %ebp
8010a0aa:	c3                   	ret    

8010a0ab <http_proc>:
#include "defs.h"
#include "types.h"
#include "tcp.h"


void http_proc(uint recv, uint recv_size, uint send, uint *send_size){
8010a0ab:	55                   	push   %ebp
8010a0ac:	89 e5                	mov    %esp,%ebp
8010a0ae:	83 ec 18             	sub    $0x18,%esp
  int len;
  len = http_strcpy((char *)send,"HTTP/1.0 200 OK \r\n",0);
8010a0b1:	8b 45 10             	mov    0x10(%ebp),%eax
8010a0b4:	83 ec 04             	sub    $0x4,%esp
8010a0b7:	6a 00                	push   $0x0
8010a0b9:	68 eb c1 10 80       	push   $0x8010c1eb
8010a0be:	50                   	push   %eax
8010a0bf:	e8 65 00 00 00       	call   8010a129 <http_strcpy>
8010a0c4:	83 c4 10             	add    $0x10,%esp
8010a0c7:	89 45 f4             	mov    %eax,-0xc(%ebp)
  len += http_strcpy((char *)send,"Content-Type: text/html \r\n",len);
8010a0ca:	8b 45 10             	mov    0x10(%ebp),%eax
8010a0cd:	83 ec 04             	sub    $0x4,%esp
8010a0d0:	ff 75 f4             	push   -0xc(%ebp)
8010a0d3:	68 fe c1 10 80       	push   $0x8010c1fe
8010a0d8:	50                   	push   %eax
8010a0d9:	e8 4b 00 00 00       	call   8010a129 <http_strcpy>
8010a0de:	83 c4 10             	add    $0x10,%esp
8010a0e1:	01 45 f4             	add    %eax,-0xc(%ebp)
  len += http_strcpy((char *)send,"\r\nHello World!\r\n",len);
8010a0e4:	8b 45 10             	mov    0x10(%ebp),%eax
8010a0e7:	83 ec 04             	sub    $0x4,%esp
8010a0ea:	ff 75 f4             	push   -0xc(%ebp)
8010a0ed:	68 19 c2 10 80       	push   $0x8010c219
8010a0f2:	50                   	push   %eax
8010a0f3:	e8 31 00 00 00       	call   8010a129 <http_strcpy>
8010a0f8:	83 c4 10             	add    $0x10,%esp
8010a0fb:	01 45 f4             	add    %eax,-0xc(%ebp)
  if(len%2 != 0){
8010a0fe:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010a101:	83 e0 01             	and    $0x1,%eax
8010a104:	85 c0                	test   %eax,%eax
8010a106:	74 11                	je     8010a119 <http_proc+0x6e>
    char *payload = (char *)send;
8010a108:	8b 45 10             	mov    0x10(%ebp),%eax
8010a10b:	89 45 f0             	mov    %eax,-0x10(%ebp)
    payload[len] = 0;
8010a10e:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010a111:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010a114:	01 d0                	add    %edx,%eax
8010a116:	c6 00 00             	movb   $0x0,(%eax)
  }
  *send_size = len;
8010a119:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010a11c:	8b 45 14             	mov    0x14(%ebp),%eax
8010a11f:	89 10                	mov    %edx,(%eax)
  tcp_fin();
8010a121:	e8 75 ff ff ff       	call   8010a09b <tcp_fin>
}
8010a126:	90                   	nop
8010a127:	c9                   	leave  
8010a128:	c3                   	ret    

8010a129 <http_strcpy>:

int http_strcpy(char *dst,const char *src,int start_index){
8010a129:	55                   	push   %ebp
8010a12a:	89 e5                	mov    %esp,%ebp
8010a12c:	83 ec 10             	sub    $0x10,%esp
  int i = 0;
8010a12f:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while(src[i]){
8010a136:	eb 20                	jmp    8010a158 <http_strcpy+0x2f>
    dst[start_index+i] = src[i];
8010a138:	8b 55 fc             	mov    -0x4(%ebp),%edx
8010a13b:	8b 45 0c             	mov    0xc(%ebp),%eax
8010a13e:	01 d0                	add    %edx,%eax
8010a140:	8b 4d 10             	mov    0x10(%ebp),%ecx
8010a143:	8b 55 fc             	mov    -0x4(%ebp),%edx
8010a146:	01 ca                	add    %ecx,%edx
8010a148:	89 d1                	mov    %edx,%ecx
8010a14a:	8b 55 08             	mov    0x8(%ebp),%edx
8010a14d:	01 ca                	add    %ecx,%edx
8010a14f:	0f b6 00             	movzbl (%eax),%eax
8010a152:	88 02                	mov    %al,(%edx)
    i++;
8010a154:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
  while(src[i]){
8010a158:	8b 55 fc             	mov    -0x4(%ebp),%edx
8010a15b:	8b 45 0c             	mov    0xc(%ebp),%eax
8010a15e:	01 d0                	add    %edx,%eax
8010a160:	0f b6 00             	movzbl (%eax),%eax
8010a163:	84 c0                	test   %al,%al
8010a165:	75 d1                	jne    8010a138 <http_strcpy+0xf>
  }
  return i;
8010a167:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
8010a16a:	c9                   	leave  
8010a16b:	c3                   	ret    

8010a16c <ideinit>:
static int disksize;
static uchar *memdisk;

void
ideinit(void)
{
8010a16c:	55                   	push   %ebp
8010a16d:	89 e5                	mov    %esp,%ebp
  memdisk = _binary_fs_img_start;
8010a16f:	c7 05 70 71 19 80 c2 	movl   $0x8010f5c2,0x80197170
8010a176:	f5 10 80 
  disksize = (uint)_binary_fs_img_size/BSIZE;
8010a179:	b8 00 d0 07 00       	mov    $0x7d000,%eax
8010a17e:	c1 e8 09             	shr    $0x9,%eax
8010a181:	a3 6c 71 19 80       	mov    %eax,0x8019716c
}
8010a186:	90                   	nop
8010a187:	5d                   	pop    %ebp
8010a188:	c3                   	ret    

8010a189 <ideintr>:

// Interrupt handler.
void
ideintr(void)
{
8010a189:	55                   	push   %ebp
8010a18a:	89 e5                	mov    %esp,%ebp
  // no-op
}
8010a18c:	90                   	nop
8010a18d:	5d                   	pop    %ebp
8010a18e:	c3                   	ret    

8010a18f <iderw>:
// Sync buf with disk.
// If B_DIRTY is set, write buf to disk, clear B_DIRTY, set B_VALID.
// Else if B_VALID is not set, read buf from disk, set B_VALID.
void
iderw(struct buf *b)
{
8010a18f:	55                   	push   %ebp
8010a190:	89 e5                	mov    %esp,%ebp
8010a192:	83 ec 18             	sub    $0x18,%esp
  uchar *p;

  if(!holdingsleep(&b->lock))
8010a195:	8b 45 08             	mov    0x8(%ebp),%eax
8010a198:	83 c0 0c             	add    $0xc,%eax
8010a19b:	83 ec 0c             	sub    $0xc,%esp
8010a19e:	50                   	push   %eax
8010a19f:	e8 58 a7 ff ff       	call   801048fc <holdingsleep>
8010a1a4:	83 c4 10             	add    $0x10,%esp
8010a1a7:	85 c0                	test   %eax,%eax
8010a1a9:	75 0d                	jne    8010a1b8 <iderw+0x29>
    panic("iderw: buf not locked");
8010a1ab:	83 ec 0c             	sub    $0xc,%esp
8010a1ae:	68 2a c2 10 80       	push   $0x8010c22a
8010a1b3:	e8 f1 63 ff ff       	call   801005a9 <panic>
  if((b->flags & (B_VALID|B_DIRTY)) == B_VALID)
8010a1b8:	8b 45 08             	mov    0x8(%ebp),%eax
8010a1bb:	8b 00                	mov    (%eax),%eax
8010a1bd:	83 e0 06             	and    $0x6,%eax
8010a1c0:	83 f8 02             	cmp    $0x2,%eax
8010a1c3:	75 0d                	jne    8010a1d2 <iderw+0x43>
    panic("iderw: nothing to do");
8010a1c5:	83 ec 0c             	sub    $0xc,%esp
8010a1c8:	68 40 c2 10 80       	push   $0x8010c240
8010a1cd:	e8 d7 63 ff ff       	call   801005a9 <panic>
  if(b->dev != 1)
8010a1d2:	8b 45 08             	mov    0x8(%ebp),%eax
8010a1d5:	8b 40 04             	mov    0x4(%eax),%eax
8010a1d8:	83 f8 01             	cmp    $0x1,%eax
8010a1db:	74 0d                	je     8010a1ea <iderw+0x5b>
    panic("iderw: request not for disk 1");
8010a1dd:	83 ec 0c             	sub    $0xc,%esp
8010a1e0:	68 55 c2 10 80       	push   $0x8010c255
8010a1e5:	e8 bf 63 ff ff       	call   801005a9 <panic>
  if(b->blockno >= disksize)
8010a1ea:	8b 45 08             	mov    0x8(%ebp),%eax
8010a1ed:	8b 40 08             	mov    0x8(%eax),%eax
8010a1f0:	8b 15 6c 71 19 80    	mov    0x8019716c,%edx
8010a1f6:	39 d0                	cmp    %edx,%eax
8010a1f8:	72 0d                	jb     8010a207 <iderw+0x78>
    panic("iderw: block out of range");
8010a1fa:	83 ec 0c             	sub    $0xc,%esp
8010a1fd:	68 73 c2 10 80       	push   $0x8010c273
8010a202:	e8 a2 63 ff ff       	call   801005a9 <panic>

  p = memdisk + b->blockno*BSIZE;
8010a207:	8b 15 70 71 19 80    	mov    0x80197170,%edx
8010a20d:	8b 45 08             	mov    0x8(%ebp),%eax
8010a210:	8b 40 08             	mov    0x8(%eax),%eax
8010a213:	c1 e0 09             	shl    $0x9,%eax
8010a216:	01 d0                	add    %edx,%eax
8010a218:	89 45 f4             	mov    %eax,-0xc(%ebp)

  if(b->flags & B_DIRTY){
8010a21b:	8b 45 08             	mov    0x8(%ebp),%eax
8010a21e:	8b 00                	mov    (%eax),%eax
8010a220:	83 e0 04             	and    $0x4,%eax
8010a223:	85 c0                	test   %eax,%eax
8010a225:	74 2b                	je     8010a252 <iderw+0xc3>
    b->flags &= ~B_DIRTY;
8010a227:	8b 45 08             	mov    0x8(%ebp),%eax
8010a22a:	8b 00                	mov    (%eax),%eax
8010a22c:	83 e0 fb             	and    $0xfffffffb,%eax
8010a22f:	89 c2                	mov    %eax,%edx
8010a231:	8b 45 08             	mov    0x8(%ebp),%eax
8010a234:	89 10                	mov    %edx,(%eax)
    memmove(p, b->data, BSIZE);
8010a236:	8b 45 08             	mov    0x8(%ebp),%eax
8010a239:	83 c0 5c             	add    $0x5c,%eax
8010a23c:	83 ec 04             	sub    $0x4,%esp
8010a23f:	68 00 02 00 00       	push   $0x200
8010a244:	50                   	push   %eax
8010a245:	ff 75 f4             	push   -0xc(%ebp)
8010a248:	e8 75 aa ff ff       	call   80104cc2 <memmove>
8010a24d:	83 c4 10             	add    $0x10,%esp
8010a250:	eb 1a                	jmp    8010a26c <iderw+0xdd>
  } else
    memmove(b->data, p, BSIZE);
8010a252:	8b 45 08             	mov    0x8(%ebp),%eax
8010a255:	83 c0 5c             	add    $0x5c,%eax
8010a258:	83 ec 04             	sub    $0x4,%esp
8010a25b:	68 00 02 00 00       	push   $0x200
8010a260:	ff 75 f4             	push   -0xc(%ebp)
8010a263:	50                   	push   %eax
8010a264:	e8 59 aa ff ff       	call   80104cc2 <memmove>
8010a269:	83 c4 10             	add    $0x10,%esp
  b->flags |= B_VALID;
8010a26c:	8b 45 08             	mov    0x8(%ebp),%eax
8010a26f:	8b 00                	mov    (%eax),%eax
8010a271:	83 c8 02             	or     $0x2,%eax
8010a274:	89 c2                	mov    %eax,%edx
8010a276:	8b 45 08             	mov    0x8(%ebp),%eax
8010a279:	89 10                	mov    %edx,(%eax)
}
8010a27b:	90                   	nop
8010a27c:	c9                   	leave  
8010a27d:	c3                   	ret    
