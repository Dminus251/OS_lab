
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
8010005a:	bc 80 7f 19 80       	mov    $0x80197f80,%esp
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
8010006f:	68 00 a1 10 80       	push   $0x8010a100
80100074:	68 00 d0 18 80       	push   $0x8018d000
80100079:	e8 a7 47 00 00       	call   80104825 <initlock>
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
801000bd:	68 07 a1 10 80       	push   $0x8010a107
801000c2:	50                   	push   %eax
801000c3:	e8 00 46 00 00       	call   801046c8 <initsleeplock>
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
80100101:	e8 41 47 00 00       	call   80104847 <acquire>
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
80100140:	e8 70 47 00 00       	call   801048b5 <release>
80100145:	83 c4 10             	add    $0x10,%esp
      acquiresleep(&b->lock);
80100148:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010014b:	83 c0 0c             	add    $0xc,%eax
8010014e:	83 ec 0c             	sub    $0xc,%esp
80100151:	50                   	push   %eax
80100152:	e8 ad 45 00 00       	call   80104704 <acquiresleep>
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
801001c1:	e8 ef 46 00 00       	call   801048b5 <release>
801001c6:	83 c4 10             	add    $0x10,%esp
      acquiresleep(&b->lock);
801001c9:	8b 45 f4             	mov    -0xc(%ebp),%eax
801001cc:	83 c0 0c             	add    $0xc,%eax
801001cf:	83 ec 0c             	sub    $0xc,%esp
801001d2:	50                   	push   %eax
801001d3:	e8 2c 45 00 00       	call   80104704 <acquiresleep>
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
801001f5:	68 0e a1 10 80       	push   $0x8010a10e
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
8010022d:	e8 c3 9d 00 00       	call   80109ff5 <iderw>
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
8010024a:	e8 67 45 00 00       	call   801047b6 <holdingsleep>
8010024f:	83 c4 10             	add    $0x10,%esp
80100252:	85 c0                	test   %eax,%eax
80100254:	75 0d                	jne    80100263 <bwrite+0x29>
    panic("bwrite");
80100256:	83 ec 0c             	sub    $0xc,%esp
80100259:	68 1f a1 10 80       	push   $0x8010a11f
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
80100278:	e8 78 9d 00 00       	call   80109ff5 <iderw>
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
80100293:	e8 1e 45 00 00       	call   801047b6 <holdingsleep>
80100298:	83 c4 10             	add    $0x10,%esp
8010029b:	85 c0                	test   %eax,%eax
8010029d:	75 0d                	jne    801002ac <brelse+0x29>
    panic("brelse");
8010029f:	83 ec 0c             	sub    $0xc,%esp
801002a2:	68 26 a1 10 80       	push   $0x8010a126
801002a7:	e8 fd 02 00 00       	call   801005a9 <panic>

  releasesleep(&b->lock);
801002ac:	8b 45 08             	mov    0x8(%ebp),%eax
801002af:	83 c0 0c             	add    $0xc,%eax
801002b2:	83 ec 0c             	sub    $0xc,%esp
801002b5:	50                   	push   %eax
801002b6:	e8 ad 44 00 00       	call   80104768 <releasesleep>
801002bb:	83 c4 10             	add    $0x10,%esp

  acquire(&bcache.lock);
801002be:	83 ec 0c             	sub    $0xc,%esp
801002c1:	68 00 d0 18 80       	push   $0x8018d000
801002c6:	e8 7c 45 00 00       	call   80104847 <acquire>
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
80100336:	e8 7a 45 00 00       	call   801048b5 <release>
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
80100410:	e8 32 44 00 00       	call   80104847 <acquire>
80100415:	83 c4 10             	add    $0x10,%esp

  if (fmt == 0)
80100418:	8b 45 08             	mov    0x8(%ebp),%eax
8010041b:	85 c0                	test   %eax,%eax
8010041d:	75 0d                	jne    8010042c <cprintf+0x38>
    panic("null fmt");
8010041f:	83 ec 0c             	sub    $0xc,%esp
80100422:	68 2d a1 10 80       	push   $0x8010a12d
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
80100510:	c7 45 ec 36 a1 10 80 	movl   $0x8010a136,-0x14(%ebp)
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
8010059e:	e8 12 43 00 00       	call   801048b5 <release>
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
801005c7:	68 3d a1 10 80       	push   $0x8010a13d
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
801005e6:	68 51 a1 10 80       	push   $0x8010a151
801005eb:	e8 04 fe ff ff       	call   801003f4 <cprintf>
801005f0:	83 c4 10             	add    $0x10,%esp
  getcallerpcs(&s, pcs);
801005f3:	83 ec 08             	sub    $0x8,%esp
801005f6:	8d 45 cc             	lea    -0x34(%ebp),%eax
801005f9:	50                   	push   %eax
801005fa:	8d 45 08             	lea    0x8(%ebp),%eax
801005fd:	50                   	push   %eax
801005fe:	e8 04 43 00 00       	call   80104907 <getcallerpcs>
80100603:	83 c4 10             	add    $0x10,%esp
  for(i=0; i<10; i++)
80100606:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
8010060d:	eb 1c                	jmp    8010062b <panic+0x82>
    cprintf(" %p", pcs[i]);
8010060f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100612:	8b 44 85 cc          	mov    -0x34(%ebp,%eax,4),%eax
80100616:	83 ec 08             	sub    $0x8,%esp
80100619:	50                   	push   %eax
8010061a:	68 53 a1 10 80       	push   $0x8010a153
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
801006a0:	e8 a7 78 00 00       	call   80107f4c <graphic_scroll_up>
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
801006f3:	e8 54 78 00 00       	call   80107f4c <graphic_scroll_up>
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
80100757:	e8 5b 78 00 00       	call   80107fb7 <font_render>
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
80100793:	e8 2b 5c 00 00       	call   801063c3 <uartputc>
80100798:	83 c4 10             	add    $0x10,%esp
8010079b:	83 ec 0c             	sub    $0xc,%esp
8010079e:	6a 20                	push   $0x20
801007a0:	e8 1e 5c 00 00       	call   801063c3 <uartputc>
801007a5:	83 c4 10             	add    $0x10,%esp
801007a8:	83 ec 0c             	sub    $0xc,%esp
801007ab:	6a 08                	push   $0x8
801007ad:	e8 11 5c 00 00       	call   801063c3 <uartputc>
801007b2:	83 c4 10             	add    $0x10,%esp
801007b5:	eb 0e                	jmp    801007c5 <consputc+0x56>
  } else {
    uartputc(c);
801007b7:	83 ec 0c             	sub    $0xc,%esp
801007ba:	ff 75 08             	push   0x8(%ebp)
801007bd:	e8 01 5c 00 00       	call   801063c3 <uartputc>
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
801007eb:	e8 57 40 00 00       	call   80104847 <acquire>
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
8010093f:	e8 cf 3b 00 00       	call   80104513 <wakeup>
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
80100962:	e8 4e 3f 00 00       	call   801048b5 <release>
80100967:	83 c4 10             	add    $0x10,%esp
  if(doprocdump) {
8010096a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
8010096e:	74 05                	je     80100975 <consoleintr+0x19f>
    procdump();  // now call procdump() wo. cons.lock held
80100970:	e8 59 3c 00 00       	call   801045ce <procdump>
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
8010099a:	e8 a8 3e 00 00       	call   80104847 <acquire>
8010099f:	83 c4 10             	add    $0x10,%esp
  while(n > 0){
801009a2:	e9 ab 00 00 00       	jmp    80100a52 <consoleread+0xda>
    while(input.r == input.w){
      if(myproc()->killed){
801009a7:	e8 d7 31 00 00       	call   80103b83 <myproc>
801009ac:	8b 40 24             	mov    0x24(%eax),%eax
801009af:	85 c0                	test   %eax,%eax
801009b1:	74 28                	je     801009db <consoleread+0x63>
        release(&cons.lock);
801009b3:	83 ec 0c             	sub    $0xc,%esp
801009b6:	68 00 1a 19 80       	push   $0x80191a00
801009bb:	e8 f5 3e 00 00       	call   801048b5 <release>
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
801009e8:	e8 3f 3a 00 00       	call   8010442c <sleep>
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
80100a66:	e8 4a 3e 00 00       	call   801048b5 <release>
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
80100aa2:	e8 a0 3d 00 00       	call   80104847 <acquire>
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
80100ae4:	e8 cc 3d 00 00       	call   801048b5 <release>
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
80100b12:	68 57 a1 10 80       	push   $0x8010a157
80100b17:	68 00 1a 19 80       	push   $0x80191a00
80100b1c:	e8 04 3d 00 00       	call   80104825 <initlock>
80100b21:	83 c4 10             	add    $0x10,%esp

  devsw[CONSOLE].write = consolewrite;
80100b24:	c7 05 4c 1a 19 80 86 	movl   $0x80100a86,0x80191a4c
80100b2b:	0a 10 80 
  devsw[CONSOLE].read = consoleread;
80100b2e:	c7 05 48 1a 19 80 78 	movl   $0x80100978,0x80191a48
80100b35:	09 10 80 
  
  char *p;
  for(p="Starting XV6_UEFI...\n"; *p; p++)
80100b38:	c7 45 f4 5f a1 10 80 	movl   $0x8010a15f,-0xc(%ebp)
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
80100b89:	e8 f5 2f 00 00       	call   80103b83 <myproc>
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
80100bb5:	68 75 a1 10 80       	push   $0x8010a175
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
80100c11:	e8 a9 67 00 00       	call   801073bf <setupkvm>
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
80100cb7:	e8 fc 6a 00 00       	call   801077b8 <allocuvm>
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
80100cfd:	e8 e9 69 00 00       	call   801076eb <loaduvm>
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
80100d6c:	e8 47 6a 00 00       	call   801077b8 <allocuvm>
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
80100d90:	e8 85 6c 00 00       	call   80107a1a <clearpteu>
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
80100dc9:	e8 3d 3f 00 00       	call   80104d0b <strlen>
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
80100df6:	e8 10 3f 00 00       	call   80104d0b <strlen>
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
80100e1c:	e8 98 6d 00 00       	call   80107bb9 <copyout>
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
80100eb8:	e8 fc 6c 00 00       	call   80107bb9 <copyout>
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
80100f06:	e8 b5 3d 00 00       	call   80104cc0 <safestrcpy>
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
80100f49:	e8 8e 65 00 00       	call   801074dc <switchuvm>
80100f4e:	83 c4 10             	add    $0x10,%esp
  freevm(oldpgdir);
80100f51:	83 ec 0c             	sub    $0xc,%esp
80100f54:	ff 75 cc             	push   -0x34(%ebp)
80100f57:	e8 25 6a 00 00       	call   80107981 <freevm>
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
80100f97:	e8 e5 69 00 00       	call   80107981 <freevm>
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
80100fc8:	68 81 a1 10 80       	push   $0x8010a181
80100fcd:	68 a0 1a 19 80       	push   $0x80191aa0
80100fd2:	e8 4e 38 00 00       	call   80104825 <initlock>
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
80100feb:	e8 57 38 00 00       	call   80104847 <acquire>
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
80101018:	e8 98 38 00 00       	call   801048b5 <release>
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
8010103b:	e8 75 38 00 00       	call   801048b5 <release>
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
80101058:	e8 ea 37 00 00       	call   80104847 <acquire>
8010105d:	83 c4 10             	add    $0x10,%esp
  if(f->ref < 1)
80101060:	8b 45 08             	mov    0x8(%ebp),%eax
80101063:	8b 40 04             	mov    0x4(%eax),%eax
80101066:	85 c0                	test   %eax,%eax
80101068:	7f 0d                	jg     80101077 <filedup+0x2d>
    panic("filedup");
8010106a:	83 ec 0c             	sub    $0xc,%esp
8010106d:	68 88 a1 10 80       	push   $0x8010a188
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
8010108e:	e8 22 38 00 00       	call   801048b5 <release>
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
801010a9:	e8 99 37 00 00       	call   80104847 <acquire>
801010ae:	83 c4 10             	add    $0x10,%esp
  if(f->ref < 1)
801010b1:	8b 45 08             	mov    0x8(%ebp),%eax
801010b4:	8b 40 04             	mov    0x4(%eax),%eax
801010b7:	85 c0                	test   %eax,%eax
801010b9:	7f 0d                	jg     801010c8 <fileclose+0x2d>
    panic("fileclose");
801010bb:	83 ec 0c             	sub    $0xc,%esp
801010be:	68 90 a1 10 80       	push   $0x8010a190
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
801010e9:	e8 c7 37 00 00       	call   801048b5 <release>
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
80101137:	e8 79 37 00 00       	call   801048b5 <release>
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
80101286:	68 9a a1 10 80       	push   $0x8010a19a
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
80101389:	68 a3 a1 10 80       	push   $0x8010a1a3
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
801013bf:	68 b3 a1 10 80       	push   $0x8010a1b3
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
801013f7:	e8 80 37 00 00       	call   80104b7c <memmove>
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
8010143d:	e8 7b 36 00 00       	call   80104abd <memset>
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
8010159c:	68 c0 a1 10 80       	push   $0x8010a1c0
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
80101627:	68 d6 a1 10 80       	push   $0x8010a1d6
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
8010168b:	68 e9 a1 10 80       	push   $0x8010a1e9
80101690:	68 60 24 19 80       	push   $0x80192460
80101695:	e8 8b 31 00 00       	call   80104825 <initlock>
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
801016c1:	68 f0 a1 10 80       	push   $0x8010a1f0
801016c6:	50                   	push   %eax
801016c7:	e8 fc 2f 00 00       	call   801046c8 <initsleeplock>
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
80101720:	68 f8 a1 10 80       	push   $0x8010a1f8
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
80101799:	e8 1f 33 00 00       	call   80104abd <memset>
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
80101801:	68 4b a2 10 80       	push   $0x8010a24b
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
801018a7:	e8 d0 32 00 00       	call   80104b7c <memmove>
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
801018dc:	e8 66 2f 00 00       	call   80104847 <acquire>
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
8010192a:	e8 86 2f 00 00       	call   801048b5 <release>
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
80101966:	68 5d a2 10 80       	push   $0x8010a25d
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
801019a3:	e8 0d 2f 00 00       	call   801048b5 <release>
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
801019be:	e8 84 2e 00 00       	call   80104847 <acquire>
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
801019dd:	e8 d3 2e 00 00       	call   801048b5 <release>
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
80101a03:	68 6d a2 10 80       	push   $0x8010a26d
80101a08:	e8 9c eb ff ff       	call   801005a9 <panic>

  acquiresleep(&ip->lock);
80101a0d:	8b 45 08             	mov    0x8(%ebp),%eax
80101a10:	83 c0 0c             	add    $0xc,%eax
80101a13:	83 ec 0c             	sub    $0xc,%esp
80101a16:	50                   	push   %eax
80101a17:	e8 e8 2c 00 00       	call   80104704 <acquiresleep>
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
80101ac1:	e8 b6 30 00 00       	call   80104b7c <memmove>
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
80101af0:	68 73 a2 10 80       	push   $0x8010a273
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
80101b13:	e8 9e 2c 00 00       	call   801047b6 <holdingsleep>
80101b18:	83 c4 10             	add    $0x10,%esp
80101b1b:	85 c0                	test   %eax,%eax
80101b1d:	74 0a                	je     80101b29 <iunlock+0x2c>
80101b1f:	8b 45 08             	mov    0x8(%ebp),%eax
80101b22:	8b 40 08             	mov    0x8(%eax),%eax
80101b25:	85 c0                	test   %eax,%eax
80101b27:	7f 0d                	jg     80101b36 <iunlock+0x39>
    panic("iunlock");
80101b29:	83 ec 0c             	sub    $0xc,%esp
80101b2c:	68 82 a2 10 80       	push   $0x8010a282
80101b31:	e8 73 ea ff ff       	call   801005a9 <panic>

  releasesleep(&ip->lock);
80101b36:	8b 45 08             	mov    0x8(%ebp),%eax
80101b39:	83 c0 0c             	add    $0xc,%eax
80101b3c:	83 ec 0c             	sub    $0xc,%esp
80101b3f:	50                   	push   %eax
80101b40:	e8 23 2c 00 00       	call   80104768 <releasesleep>
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
80101b5b:	e8 a4 2b 00 00       	call   80104704 <acquiresleep>
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
80101b81:	e8 c1 2c 00 00       	call   80104847 <acquire>
80101b86:	83 c4 10             	add    $0x10,%esp
    int r = ip->ref;
80101b89:	8b 45 08             	mov    0x8(%ebp),%eax
80101b8c:	8b 40 08             	mov    0x8(%eax),%eax
80101b8f:	89 45 f4             	mov    %eax,-0xc(%ebp)
    release(&icache.lock);
80101b92:	83 ec 0c             	sub    $0xc,%esp
80101b95:	68 60 24 19 80       	push   $0x80192460
80101b9a:	e8 16 2d 00 00       	call   801048b5 <release>
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
80101be1:	e8 82 2b 00 00       	call   80104768 <releasesleep>
80101be6:	83 c4 10             	add    $0x10,%esp

  acquire(&icache.lock);
80101be9:	83 ec 0c             	sub    $0xc,%esp
80101bec:	68 60 24 19 80       	push   $0x80192460
80101bf1:	e8 51 2c 00 00       	call   80104847 <acquire>
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
80101c10:	e8 a0 2c 00 00       	call   801048b5 <release>
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
80101d54:	68 8a a2 10 80       	push   $0x8010a28a
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
80101ff2:	e8 85 2b 00 00       	call   80104b7c <memmove>
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
80102142:	e8 35 2a 00 00       	call   80104b7c <memmove>
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
801021c2:	e8 4b 2a 00 00       	call   80104c12 <strncmp>
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
801021e2:	68 9d a2 10 80       	push   $0x8010a29d
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
80102211:	68 af a2 10 80       	push   $0x8010a2af
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
801022e6:	68 be a2 10 80       	push   $0x8010a2be
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
80102321:	e8 42 29 00 00       	call   80104c68 <strncpy>
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
8010234d:	68 cb a2 10 80       	push   $0x8010a2cb
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
801023bf:	e8 b8 27 00 00       	call   80104b7c <memmove>
801023c4:	83 c4 10             	add    $0x10,%esp
801023c7:	eb 26                	jmp    801023ef <skipelem+0x91>
  else {
    memmove(name, s, len);
801023c9:	8b 45 f0             	mov    -0x10(%ebp),%eax
801023cc:	83 ec 04             	sub    $0x4,%esp
801023cf:	50                   	push   %eax
801023d0:	ff 75 f4             	push   -0xc(%ebp)
801023d3:	ff 75 0c             	push   0xc(%ebp)
801023d6:	e8 a1 27 00 00       	call   80104b7c <memmove>
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
80102425:	e8 59 17 00 00       	call   80103b83 <myproc>
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
801025bb:	0f b6 05 44 6c 19 80 	movzbl 0x80196c44,%eax
801025c2:	0f b6 c0             	movzbl %al,%eax
801025c5:	39 45 ec             	cmp    %eax,-0x14(%ebp)
801025c8:	74 10                	je     801025da <ioapicinit+0x54>
    cprintf("ioapicinit: id isn't equal to ioapicid; not a MP\n");
801025ca:	83 ec 0c             	sub    $0xc,%esp
801025cd:	68 d4 a2 10 80       	push   $0x8010a2d4
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
80102674:	68 06 a3 10 80       	push   $0x8010a306
80102679:	68 c0 40 19 80       	push   $0x801940c0
8010267e:	e8 a2 21 00 00       	call   80104825 <initlock>
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
80102718:	81 7d 08 00 80 19 80 	cmpl   $0x80198000,0x8(%ebp)
8010271f:	72 0f                	jb     80102730 <kfree+0x2a>
80102721:	8b 45 08             	mov    0x8(%ebp),%eax
80102724:	05 00 00 00 80       	add    $0x80000000,%eax
80102729:	3d ff ff ff 1f       	cmp    $0x1fffffff,%eax
8010272e:	76 0d                	jbe    8010273d <kfree+0x37>
    panic("kfree");
80102730:	83 ec 0c             	sub    $0xc,%esp
80102733:	68 0b a3 10 80       	push   $0x8010a30b
80102738:	e8 6c de ff ff       	call   801005a9 <panic>

  // Fill with junk to catch dangling refs.
  memset(v, 1, PGSIZE);
8010273d:	83 ec 04             	sub    $0x4,%esp
80102740:	68 00 10 00 00       	push   $0x1000
80102745:	6a 01                	push   $0x1
80102747:	ff 75 08             	push   0x8(%ebp)
8010274a:	e8 6e 23 00 00       	call   80104abd <memset>
8010274f:	83 c4 10             	add    $0x10,%esp

  if(kmem.use_lock)
80102752:	a1 f4 40 19 80       	mov    0x801940f4,%eax
80102757:	85 c0                	test   %eax,%eax
80102759:	74 10                	je     8010276b <kfree+0x65>
    acquire(&kmem.lock);
8010275b:	83 ec 0c             	sub    $0xc,%esp
8010275e:	68 c0 40 19 80       	push   $0x801940c0
80102763:	e8 df 20 00 00       	call   80104847 <acquire>
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
80102795:	e8 1b 21 00 00       	call   801048b5 <release>
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
801027b7:	e8 8b 20 00 00       	call   80104847 <acquire>
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
801027e8:	e8 c8 20 00 00       	call   801048b5 <release>
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
80102d12:	e8 0d 1e 00 00       	call   80104b24 <memcmp>
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
80102e26:	68 11 a3 10 80       	push   $0x8010a311
80102e2b:	68 20 41 19 80       	push   $0x80194120
80102e30:	e8 f0 19 00 00       	call   80104825 <initlock>
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
80102edb:	e8 9c 1c 00 00       	call   80104b7c <memmove>
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
8010304a:	e8 f8 17 00 00       	call   80104847 <acquire>
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
80103068:	e8 bf 13 00 00       	call   8010442c <sleep>
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
8010309d:	e8 8a 13 00 00       	call   8010442c <sleep>
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
801030bc:	e8 f4 17 00 00       	call   801048b5 <release>
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
801030dd:	e8 65 17 00 00       	call   80104847 <acquire>
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
801030fe:	68 15 a3 10 80       	push   $0x8010a315
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
8010312c:	e8 e2 13 00 00       	call   80104513 <wakeup>
80103131:	83 c4 10             	add    $0x10,%esp
  }
  release(&log.lock);
80103134:	83 ec 0c             	sub    $0xc,%esp
80103137:	68 20 41 19 80       	push   $0x80194120
8010313c:	e8 74 17 00 00       	call   801048b5 <release>
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
80103157:	e8 eb 16 00 00       	call   80104847 <acquire>
8010315c:	83 c4 10             	add    $0x10,%esp
    log.committing = 0;
8010315f:	c7 05 60 41 19 80 00 	movl   $0x0,0x80194160
80103166:	00 00 00 
    wakeup(&log);
80103169:	83 ec 0c             	sub    $0xc,%esp
8010316c:	68 20 41 19 80       	push   $0x80194120
80103171:	e8 9d 13 00 00       	call   80104513 <wakeup>
80103176:	83 c4 10             	add    $0x10,%esp
    release(&log.lock);
80103179:	83 ec 0c             	sub    $0xc,%esp
8010317c:	68 20 41 19 80       	push   $0x80194120
80103181:	e8 2f 17 00 00       	call   801048b5 <release>
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
801031fd:	e8 7a 19 00 00       	call   80104b7c <memmove>
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
8010329a:	68 24 a3 10 80       	push   $0x8010a324
8010329f:	e8 05 d3 ff ff       	call   801005a9 <panic>
  if (log.outstanding < 1)
801032a4:	a1 5c 41 19 80       	mov    0x8019415c,%eax
801032a9:	85 c0                	test   %eax,%eax
801032ab:	7f 0d                	jg     801032ba <log_write+0x45>
    panic("log_write outside of trans");
801032ad:	83 ec 0c             	sub    $0xc,%esp
801032b0:	68 3a a3 10 80       	push   $0x8010a33a
801032b5:	e8 ef d2 ff ff       	call   801005a9 <panic>

  acquire(&log.lock);
801032ba:	83 ec 0c             	sub    $0xc,%esp
801032bd:	68 20 41 19 80       	push   $0x80194120
801032c2:	e8 80 15 00 00       	call   80104847 <acquire>
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
80103340:	e8 70 15 00 00       	call   801048b5 <release>
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
80103376:	e8 16 4b 00 00       	call   80107e91 <graphic_init>
  kinit1(end, P2V(4*1024*1024)); // phys page allocator
8010337b:	83 ec 08             	sub    $0x8,%esp
8010337e:	68 00 00 40 80       	push   $0x80400000
80103383:	68 00 80 19 80       	push   $0x80198000
80103388:	e8 de f2 ff ff       	call   8010266b <kinit1>
8010338d:	83 c4 10             	add    $0x10,%esp
  kvmalloc();      // kernel page table
80103390:	e8 16 41 00 00       	call   801074ab <kvmalloc>
  mpinit_uefi();
80103395:	e8 bd 48 00 00       	call   80107c57 <mpinit_uefi>
  lapicinit();     // interrupt controller
8010339a:	e8 3c f6 ff ff       	call   801029db <lapicinit>
  seginit();       // segment descriptors
8010339f:	e8 9f 3b 00 00       	call   80106f43 <seginit>
  picinit();    // disable pic
801033a4:	e8 9d 01 00 00       	call   80103546 <picinit>
  ioapicinit();    // another interrupt controller
801033a9:	e8 d8 f1 ff ff       	call   80102586 <ioapicinit>
  consoleinit();   // console hardware
801033ae:	e8 4c d7 ff ff       	call   80100aff <consoleinit>
  uartinit();      // serial port
801033b3:	e8 24 2f 00 00       	call   801062dc <uartinit>
  pinit();         // process table
801033b8:	e8 15 07 00 00       	call   80103ad2 <pinit>
  tvinit();        // trap vectors
801033bd:	e8 eb 2a 00 00       	call   80105ead <tvinit>
  binit();         // buffer cache
801033c2:	e8 9f cc ff ff       	call   80100066 <binit>
  fileinit();      // file table
801033c7:	e8 f3 db ff ff       	call   80100fbf <fileinit>
  ideinit();       // disk 
801033cc:	e8 01 6c 00 00       	call   80109fd2 <ideinit>
  startothers();   // start other processors
801033d1:	e8 8a 00 00 00       	call   80103460 <startothers>
  kinit2(P2V(4*1024*1024), P2V(PHYSTOP)); // must come after startothers()
801033d6:	83 ec 08             	sub    $0x8,%esp
801033d9:	68 00 00 00 a0       	push   $0xa0000000
801033de:	68 00 00 40 80       	push   $0x80400000
801033e3:	e8 bc f2 ff ff       	call   801026a4 <kinit2>
801033e8:	83 c4 10             	add    $0x10,%esp
  pci_init();
801033eb:	e8 fa 4c 00 00       	call   801080ea <pci_init>
  arp_scan();
801033f0:	e8 31 5a 00 00       	call   80108e26 <arp_scan>
  //i8254_recv();
  userinit();      // first user process
801033f5:	e8 b6 08 00 00       	call   80103cb0 <userinit>

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
80103405:	e8 b9 40 00 00       	call   801074c3 <switchkvm>
  seginit();
8010340a:	e8 34 3b 00 00       	call   80106f43 <seginit>
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
80103420:	e8 cb 06 00 00       	call   80103af0 <cpuid>
80103425:	89 c3                	mov    %eax,%ebx
80103427:	e8 c4 06 00 00       	call   80103af0 <cpuid>
8010342c:	83 ec 04             	sub    $0x4,%esp
8010342f:	53                   	push   %ebx
80103430:	50                   	push   %eax
80103431:	68 55 a3 10 80       	push   $0x8010a355
80103436:	e8 b9 cf ff ff       	call   801003f4 <cprintf>
8010343b:	83 c4 10             	add    $0x10,%esp
  idtinit();       // load idt register
8010343e:	e8 e0 2b 00 00       	call   80106023 <idtinit>
  xchg(&(mycpu()->started), 1); // tell startothers() we're up
80103443:	e8 c3 06 00 00       	call   80103b0b <mycpu>
80103448:	05 a0 00 00 00       	add    $0xa0,%eax
8010344d:	83 ec 08             	sub    $0x8,%esp
80103450:	6a 01                	push   $0x1
80103452:	50                   	push   %eax
80103453:	e8 f3 fe ff ff       	call   8010334b <xchg>
80103458:	83 c4 10             	add    $0x10,%esp
  scheduler();     // start running processes
8010345b:	e8 db 0d 00 00       	call   8010423b <scheduler>

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
80103476:	68 18 f5 10 80       	push   $0x8010f518
8010347b:	ff 75 f0             	push   -0x10(%ebp)
8010347e:	e8 f9 16 00 00       	call   80104b7c <memmove>
80103483:	83 c4 10             	add    $0x10,%esp

  for(c = cpus; c < cpus+ncpu; c++){
80103486:	c7 45 f4 80 69 19 80 	movl   $0x80196980,-0xc(%ebp)
8010348d:	eb 79                	jmp    80103508 <startothers+0xa8>
    if(c == mycpu()){  // We've started already.
8010348f:	e8 77 06 00 00       	call   80103b0b <mycpu>
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
80103508:	a1 40 6c 19 80       	mov    0x80196c40,%eax
8010350d:	69 c0 b0 00 00 00    	imul   $0xb0,%eax,%eax
80103513:	05 80 69 19 80       	add    $0x80196980,%eax
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
80103607:	68 69 a3 10 80       	push   $0x8010a369
8010360c:	50                   	push   %eax
8010360d:	e8 13 12 00 00       	call   80104825 <initlock>
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
801036cc:	e8 76 11 00 00       	call   80104847 <acquire>
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
801036f3:	e8 1b 0e 00 00       	call   80104513 <wakeup>
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
80103716:	e8 f8 0d 00 00       	call   80104513 <wakeup>
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
8010373f:	e8 71 11 00 00       	call   801048b5 <release>
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
8010375e:	e8 52 11 00 00       	call   801048b5 <release>
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
80103778:	e8 ca 10 00 00       	call   80104847 <acquire>
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
80103799:	e8 e5 03 00 00       	call   80103b83 <myproc>
8010379e:	8b 40 24             	mov    0x24(%eax),%eax
801037a1:	85 c0                	test   %eax,%eax
801037a3:	74 19                	je     801037be <pipewrite+0x54>
        release(&p->lock);
801037a5:	8b 45 08             	mov    0x8(%ebp),%eax
801037a8:	83 ec 0c             	sub    $0xc,%esp
801037ab:	50                   	push   %eax
801037ac:	e8 04 11 00 00       	call   801048b5 <release>
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
801037ca:	e8 44 0d 00 00       	call   80104513 <wakeup>
801037cf:	83 c4 10             	add    $0x10,%esp
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
801037d2:	8b 45 08             	mov    0x8(%ebp),%eax
801037d5:	8b 55 08             	mov    0x8(%ebp),%edx
801037d8:	81 c2 38 02 00 00    	add    $0x238,%edx
801037de:	83 ec 08             	sub    $0x8,%esp
801037e1:	50                   	push   %eax
801037e2:	52                   	push   %edx
801037e3:	e8 44 0c 00 00       	call   8010442c <sleep>
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
8010384d:	e8 c1 0c 00 00       	call   80104513 <wakeup>
80103852:	83 c4 10             	add    $0x10,%esp
  release(&p->lock);
80103855:	8b 45 08             	mov    0x8(%ebp),%eax
80103858:	83 ec 0c             	sub    $0xc,%esp
8010385b:	50                   	push   %eax
8010385c:	e8 54 10 00 00       	call   801048b5 <release>
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
80103879:	e8 c9 0f 00 00       	call   80104847 <acquire>
8010387e:	83 c4 10             	add    $0x10,%esp
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
80103881:	eb 3e                	jmp    801038c1 <piperead+0x55>
    if(myproc()->killed){
80103883:	e8 fb 02 00 00       	call   80103b83 <myproc>
80103888:	8b 40 24             	mov    0x24(%eax),%eax
8010388b:	85 c0                	test   %eax,%eax
8010388d:	74 19                	je     801038a8 <piperead+0x3c>
      release(&p->lock);
8010388f:	8b 45 08             	mov    0x8(%ebp),%eax
80103892:	83 ec 0c             	sub    $0xc,%esp
80103895:	50                   	push   %eax
80103896:	e8 1a 10 00 00       	call   801048b5 <release>
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
801038b9:	e8 6e 0b 00 00       	call   8010442c <sleep>
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
8010394c:	e8 c2 0b 00 00       	call   80104513 <wakeup>
80103951:	83 c4 10             	add    $0x10,%esp
  release(&p->lock);
80103954:	8b 45 08             	mov    0x8(%ebp),%eax
80103957:	83 ec 0c             	sub    $0xc,%esp
8010395a:	50                   	push   %eax
8010395b:	e8 55 0f 00 00       	call   801048b5 <release>
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

8010397f <printpt>:
extern void trapret(void);

static void wakeup1(void *chan);

//****************************printpt
int printpt(int pid) {
8010397f:	55                   	push   %ebp
80103980:	89 e5                	mov    %esp,%ebp
80103982:	53                   	push   %ebx
80103983:	83 ec 24             	sub    $0x24,%esp
    struct proc *p = myproc();  // 주어진 PID의 프로세스를 찾습니다.
80103986:	e8 f8 01 00 00       	call   80103b83 <myproc>
8010398b:	89 45 ec             	mov    %eax,-0x14(%ebp)
    if (p == 0) return -1;
8010398e:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
80103992:	75 0a                	jne    8010399e <printpt+0x1f>
80103994:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80103999:	e9 2f 01 00 00       	jmp    80103acd <printpt+0x14e>

    pde_t *pgdir = p->pgdir;
8010399e:	8b 45 ec             	mov    -0x14(%ebp),%eax
801039a1:	8b 40 04             	mov    0x4(%eax),%eax
801039a4:	89 45 e8             	mov    %eax,-0x18(%ebp)
    cprintf("START PAGE TABLE (pid %d)\n", pid);
801039a7:	83 ec 08             	sub    $0x8,%esp
801039aa:	ff 75 08             	push   0x8(%ebp)
801039ad:	68 70 a3 10 80       	push   $0x8010a370
801039b2:	e8 3d ca ff ff       	call   801003f4 <cprintf>
801039b7:	83 c4 10             	add    $0x10,%esp

    for (int i = 0; i < NPDENTRIES; i++) {
801039ba:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
801039c1:	e9 e5 00 00 00       	jmp    80103aab <printpt+0x12c>
        if (pgdir[i] & PTE_P) {
801039c6:	8b 45 f4             	mov    -0xc(%ebp),%eax
801039c9:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
801039d0:	8b 45 e8             	mov    -0x18(%ebp),%eax
801039d3:	01 d0                	add    %edx,%eax
801039d5:	8b 00                	mov    (%eax),%eax
801039d7:	83 e0 01             	and    $0x1,%eax
801039da:	85 c0                	test   %eax,%eax
801039dc:	0f 84 c5 00 00 00    	je     80103aa7 <printpt+0x128>
            pte_t *pt = (pte_t *)P2V(PTE_ADDR(pgdir[i]));
801039e2:	8b 45 f4             	mov    -0xc(%ebp),%eax
801039e5:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
801039ec:	8b 45 e8             	mov    -0x18(%ebp),%eax
801039ef:	01 d0                	add    %edx,%eax
801039f1:	8b 00                	mov    (%eax),%eax
801039f3:	25 00 f0 ff ff       	and    $0xfffff000,%eax
801039f8:	05 00 00 00 80       	add    $0x80000000,%eax
801039fd:	89 45 e4             	mov    %eax,-0x1c(%ebp)
            for (int j = 0; j < NPTENTRIES; j++) {
80103a00:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
80103a07:	e9 8e 00 00 00       	jmp    80103a9a <printpt+0x11b>
                if (pt[j] & PTE_P) {
80103a0c:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103a0f:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80103a16:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80103a19:	01 d0                	add    %edx,%eax
80103a1b:	8b 00                	mov    (%eax),%eax
80103a1d:	83 e0 01             	and    $0x1,%eax
80103a20:	85 c0                	test   %eax,%eax
80103a22:	74 72                	je     80103a96 <printpt+0x117>
                    cprintf("%d P %c %c %x\n", j,
                            (pt[j] & PTE_U) ? 'U' : 'K',
                            (pt[j] & PTE_W) ? 'W' : '-',
                            PTE_ADDR(pt[j]) >> 12);
80103a24:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103a27:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80103a2e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80103a31:	01 d0                	add    %edx,%eax
80103a33:	8b 00                	mov    (%eax),%eax
                    cprintf("%d P %c %c %x\n", j,
80103a35:	c1 e8 0c             	shr    $0xc,%eax
                            (pt[j] & PTE_W) ? 'W' : '-',
80103a38:	8b 55 f0             	mov    -0x10(%ebp),%edx
80103a3b:	8d 0c 95 00 00 00 00 	lea    0x0(,%edx,4),%ecx
80103a42:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80103a45:	01 ca                	add    %ecx,%edx
80103a47:	8b 12                	mov    (%edx),%edx
80103a49:	83 e2 02             	and    $0x2,%edx
                    cprintf("%d P %c %c %x\n", j,
80103a4c:	85 d2                	test   %edx,%edx
80103a4e:	74 07                	je     80103a57 <printpt+0xd8>
80103a50:	b9 57 00 00 00       	mov    $0x57,%ecx
80103a55:	eb 05                	jmp    80103a5c <printpt+0xdd>
80103a57:	b9 2d 00 00 00       	mov    $0x2d,%ecx
                            (pt[j] & PTE_U) ? 'U' : 'K',
80103a5c:	8b 55 f0             	mov    -0x10(%ebp),%edx
80103a5f:	8d 1c 95 00 00 00 00 	lea    0x0(,%edx,4),%ebx
80103a66:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80103a69:	01 da                	add    %ebx,%edx
80103a6b:	8b 12                	mov    (%edx),%edx
80103a6d:	83 e2 04             	and    $0x4,%edx
                    cprintf("%d P %c %c %x\n", j,
80103a70:	85 d2                	test   %edx,%edx
80103a72:	74 07                	je     80103a7b <printpt+0xfc>
80103a74:	ba 55 00 00 00       	mov    $0x55,%edx
80103a79:	eb 05                	jmp    80103a80 <printpt+0x101>
80103a7b:	ba 4b 00 00 00       	mov    $0x4b,%edx
80103a80:	83 ec 0c             	sub    $0xc,%esp
80103a83:	50                   	push   %eax
80103a84:	51                   	push   %ecx
80103a85:	52                   	push   %edx
80103a86:	ff 75 f0             	push   -0x10(%ebp)
80103a89:	68 8b a3 10 80       	push   $0x8010a38b
80103a8e:	e8 61 c9 ff ff       	call   801003f4 <cprintf>
80103a93:	83 c4 20             	add    $0x20,%esp
            for (int j = 0; j < NPTENTRIES; j++) {
80103a96:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
80103a9a:	81 7d f0 ff 03 00 00 	cmpl   $0x3ff,-0x10(%ebp)
80103aa1:	0f 8e 65 ff ff ff    	jle    80103a0c <printpt+0x8d>
    for (int i = 0; i < NPDENTRIES; i++) {
80103aa7:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80103aab:	81 7d f4 ff 03 00 00 	cmpl   $0x3ff,-0xc(%ebp)
80103ab2:	0f 8e 0e ff ff ff    	jle    801039c6 <printpt+0x47>
                }
            }
        }
    }
    cprintf("END PAGE TABLE\n");
80103ab8:	83 ec 0c             	sub    $0xc,%esp
80103abb:	68 9a a3 10 80       	push   $0x8010a39a
80103ac0:	e8 2f c9 ff ff       	call   801003f4 <cprintf>
80103ac5:	83 c4 10             	add    $0x10,%esp
    return 0;
80103ac8:	b8 00 00 00 00       	mov    $0x0,%eax
}
80103acd:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103ad0:	c9                   	leave  
80103ad1:	c3                   	ret    

80103ad2 <pinit>:

void
pinit(void)
{
80103ad2:	55                   	push   %ebp
80103ad3:	89 e5                	mov    %esp,%ebp
80103ad5:	83 ec 08             	sub    $0x8,%esp
  initlock(&ptable.lock, "ptable");
80103ad8:	83 ec 08             	sub    $0x8,%esp
80103adb:	68 aa a3 10 80       	push   $0x8010a3aa
80103ae0:	68 00 42 19 80       	push   $0x80194200
80103ae5:	e8 3b 0d 00 00       	call   80104825 <initlock>
80103aea:	83 c4 10             	add    $0x10,%esp
}
80103aed:	90                   	nop
80103aee:	c9                   	leave  
80103aef:	c3                   	ret    

80103af0 <cpuid>:

// Must be called with interrupts disabled
int
cpuid() {
80103af0:	55                   	push   %ebp
80103af1:	89 e5                	mov    %esp,%ebp
80103af3:	83 ec 08             	sub    $0x8,%esp
  return mycpu()-cpus;
80103af6:	e8 10 00 00 00       	call   80103b0b <mycpu>
80103afb:	2d 80 69 19 80       	sub    $0x80196980,%eax
80103b00:	c1 f8 04             	sar    $0x4,%eax
80103b03:	69 c0 a3 8b 2e ba    	imul   $0xba2e8ba3,%eax,%eax
}
80103b09:	c9                   	leave  
80103b0a:	c3                   	ret    

80103b0b <mycpu>:

// Must be called with interrupts disabled to avoid the caller being
// rescheduled between reading lapicid and running through the loop.
struct cpu*
mycpu(void)
{
80103b0b:	55                   	push   %ebp
80103b0c:	89 e5                	mov    %esp,%ebp
80103b0e:	83 ec 18             	sub    $0x18,%esp
  int apicid, i;
  
  if(readeflags()&FL_IF){
80103b11:	e8 52 fe ff ff       	call   80103968 <readeflags>
80103b16:	25 00 02 00 00       	and    $0x200,%eax
80103b1b:	85 c0                	test   %eax,%eax
80103b1d:	74 0d                	je     80103b2c <mycpu+0x21>
    panic("mycpu called with interrupts enabled\n");
80103b1f:	83 ec 0c             	sub    $0xc,%esp
80103b22:	68 b4 a3 10 80       	push   $0x8010a3b4
80103b27:	e8 7d ca ff ff       	call   801005a9 <panic>
  }

  apicid = lapicid();
80103b2c:	e8 c9 ef ff ff       	call   80102afa <lapicid>
80103b31:	89 45 f0             	mov    %eax,-0x10(%ebp)
  // APIC IDs are not guaranteed to be contiguous. Maybe we should have
  // a reverse map, or reserve a register to store &cpus[i].
  for (i = 0; i < ncpu; ++i) {
80103b34:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80103b3b:	eb 2d                	jmp    80103b6a <mycpu+0x5f>
    if (cpus[i].apicid == apicid){
80103b3d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103b40:	69 c0 b0 00 00 00    	imul   $0xb0,%eax,%eax
80103b46:	05 80 69 19 80       	add    $0x80196980,%eax
80103b4b:	0f b6 00             	movzbl (%eax),%eax
80103b4e:	0f b6 c0             	movzbl %al,%eax
80103b51:	39 45 f0             	cmp    %eax,-0x10(%ebp)
80103b54:	75 10                	jne    80103b66 <mycpu+0x5b>
      return &cpus[i];
80103b56:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103b59:	69 c0 b0 00 00 00    	imul   $0xb0,%eax,%eax
80103b5f:	05 80 69 19 80       	add    $0x80196980,%eax
80103b64:	eb 1b                	jmp    80103b81 <mycpu+0x76>
  for (i = 0; i < ncpu; ++i) {
80103b66:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80103b6a:	a1 40 6c 19 80       	mov    0x80196c40,%eax
80103b6f:	39 45 f4             	cmp    %eax,-0xc(%ebp)
80103b72:	7c c9                	jl     80103b3d <mycpu+0x32>
    }
  }
  panic("unknown apicid\n");
80103b74:	83 ec 0c             	sub    $0xc,%esp
80103b77:	68 da a3 10 80       	push   $0x8010a3da
80103b7c:	e8 28 ca ff ff       	call   801005a9 <panic>
}
80103b81:	c9                   	leave  
80103b82:	c3                   	ret    

80103b83 <myproc>:

// Disable interrupts so that we are not rescheduled
// while reading proc from the cpu structure
struct proc*
myproc(void) {
80103b83:	55                   	push   %ebp
80103b84:	89 e5                	mov    %esp,%ebp
80103b86:	83 ec 18             	sub    $0x18,%esp
  struct cpu *c;
  struct proc *p;
  pushcli();
80103b89:	e8 24 0e 00 00       	call   801049b2 <pushcli>
  c = mycpu();
80103b8e:	e8 78 ff ff ff       	call   80103b0b <mycpu>
80103b93:	89 45 f4             	mov    %eax,-0xc(%ebp)
  p = c->proc;
80103b96:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103b99:	8b 80 ac 00 00 00    	mov    0xac(%eax),%eax
80103b9f:	89 45 f0             	mov    %eax,-0x10(%ebp)
  popcli();
80103ba2:	e8 58 0e 00 00       	call   801049ff <popcli>
  return p;
80103ba7:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
80103baa:	c9                   	leave  
80103bab:	c3                   	ret    

80103bac <allocproc>:
// If found, change state to EMBRYO and initialize
// state required to run in the kernel.
// Otherwise return 0.
static struct proc*
allocproc(void)
{
80103bac:	55                   	push   %ebp
80103bad:	89 e5                	mov    %esp,%ebp
80103baf:	83 ec 18             	sub    $0x18,%esp
  struct proc *p;
  char *sp;

  acquire(&ptable.lock);
80103bb2:	83 ec 0c             	sub    $0xc,%esp
80103bb5:	68 00 42 19 80       	push   $0x80194200
80103bba:	e8 88 0c 00 00       	call   80104847 <acquire>
80103bbf:	83 c4 10             	add    $0x10,%esp

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103bc2:	c7 45 f4 34 42 19 80 	movl   $0x80194234,-0xc(%ebp)
80103bc9:	eb 0e                	jmp    80103bd9 <allocproc+0x2d>
    if(p->state == UNUSED){
80103bcb:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103bce:	8b 40 0c             	mov    0xc(%eax),%eax
80103bd1:	85 c0                	test   %eax,%eax
80103bd3:	74 27                	je     80103bfc <allocproc+0x50>
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103bd5:	83 45 f4 7c          	addl   $0x7c,-0xc(%ebp)
80103bd9:	81 7d f4 34 61 19 80 	cmpl   $0x80196134,-0xc(%ebp)
80103be0:	72 e9                	jb     80103bcb <allocproc+0x1f>
      goto found;
    }

  release(&ptable.lock);
80103be2:	83 ec 0c             	sub    $0xc,%esp
80103be5:	68 00 42 19 80       	push   $0x80194200
80103bea:	e8 c6 0c 00 00       	call   801048b5 <release>
80103bef:	83 c4 10             	add    $0x10,%esp
  return 0;
80103bf2:	b8 00 00 00 00       	mov    $0x0,%eax
80103bf7:	e9 b2 00 00 00       	jmp    80103cae <allocproc+0x102>
      goto found;
80103bfc:	90                   	nop

found:
  p->state = EMBRYO;
80103bfd:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103c00:	c7 40 0c 01 00 00 00 	movl   $0x1,0xc(%eax)
  p->pid = nextpid++;
80103c07:	a1 00 f0 10 80       	mov    0x8010f000,%eax
80103c0c:	8d 50 01             	lea    0x1(%eax),%edx
80103c0f:	89 15 00 f0 10 80    	mov    %edx,0x8010f000
80103c15:	8b 55 f4             	mov    -0xc(%ebp),%edx
80103c18:	89 42 10             	mov    %eax,0x10(%edx)

  release(&ptable.lock);
80103c1b:	83 ec 0c             	sub    $0xc,%esp
80103c1e:	68 00 42 19 80       	push   $0x80194200
80103c23:	e8 8d 0c 00 00       	call   801048b5 <release>
80103c28:	83 c4 10             	add    $0x10,%esp


  // Allocate kernel stack.
  if((p->kstack = kalloc()) == 0){
80103c2b:	e8 70 eb ff ff       	call   801027a0 <kalloc>
80103c30:	8b 55 f4             	mov    -0xc(%ebp),%edx
80103c33:	89 42 08             	mov    %eax,0x8(%edx)
80103c36:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103c39:	8b 40 08             	mov    0x8(%eax),%eax
80103c3c:	85 c0                	test   %eax,%eax
80103c3e:	75 11                	jne    80103c51 <allocproc+0xa5>
    p->state = UNUSED;
80103c40:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103c43:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
    return 0;
80103c4a:	b8 00 00 00 00       	mov    $0x0,%eax
80103c4f:	eb 5d                	jmp    80103cae <allocproc+0x102>
  }
  sp = p->kstack + KSTACKSIZE;
80103c51:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103c54:	8b 40 08             	mov    0x8(%eax),%eax
80103c57:	05 00 10 00 00       	add    $0x1000,%eax
80103c5c:	89 45 f0             	mov    %eax,-0x10(%ebp)

  // Leave room for trap frame.
  sp -= sizeof *p->tf;
80103c5f:	83 6d f0 4c          	subl   $0x4c,-0x10(%ebp)
  p->tf = (struct trapframe*)sp;
80103c63:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103c66:	8b 55 f0             	mov    -0x10(%ebp),%edx
80103c69:	89 50 18             	mov    %edx,0x18(%eax)

  // Set up new context to start executing at forkret,
  // which returns to trapret.
  sp -= 4;
80103c6c:	83 6d f0 04          	subl   $0x4,-0x10(%ebp)
  *(uint*)sp = (uint)trapret;
80103c70:	ba 67 5e 10 80       	mov    $0x80105e67,%edx
80103c75:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103c78:	89 10                	mov    %edx,(%eax)

  sp -= sizeof *p->context;
80103c7a:	83 6d f0 14          	subl   $0x14,-0x10(%ebp)
  p->context = (struct context*)sp;
80103c7e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103c81:	8b 55 f0             	mov    -0x10(%ebp),%edx
80103c84:	89 50 1c             	mov    %edx,0x1c(%eax)
  memset(p->context, 0, sizeof *p->context);
80103c87:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103c8a:	8b 40 1c             	mov    0x1c(%eax),%eax
80103c8d:	83 ec 04             	sub    $0x4,%esp
80103c90:	6a 14                	push   $0x14
80103c92:	6a 00                	push   $0x0
80103c94:	50                   	push   %eax
80103c95:	e8 23 0e 00 00       	call   80104abd <memset>
80103c9a:	83 c4 10             	add    $0x10,%esp
  p->context->eip = (uint)forkret;
80103c9d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103ca0:	8b 40 1c             	mov    0x1c(%eax),%eax
80103ca3:	ba e6 43 10 80       	mov    $0x801043e6,%edx
80103ca8:	89 50 10             	mov    %edx,0x10(%eax)

  return p;
80103cab:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
80103cae:	c9                   	leave  
80103caf:	c3                   	ret    

80103cb0 <userinit>:

//PAGEBREAK: 32
// Set up first user process.
void
userinit(void)
{
80103cb0:	55                   	push   %ebp
80103cb1:	89 e5                	mov    %esp,%ebp
80103cb3:	83 ec 18             	sub    $0x18,%esp
  struct proc *p;
  extern char _binary_initcode_start[], _binary_initcode_size[];

  p = allocproc();
80103cb6:	e8 f1 fe ff ff       	call   80103bac <allocproc>
80103cbb:	89 45 f4             	mov    %eax,-0xc(%ebp)
  
  initproc = p;
80103cbe:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103cc1:	a3 34 61 19 80       	mov    %eax,0x80196134
  if((p->pgdir = setupkvm()) == 0){
80103cc6:	e8 f4 36 00 00       	call   801073bf <setupkvm>
80103ccb:	8b 55 f4             	mov    -0xc(%ebp),%edx
80103cce:	89 42 04             	mov    %eax,0x4(%edx)
80103cd1:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103cd4:	8b 40 04             	mov    0x4(%eax),%eax
80103cd7:	85 c0                	test   %eax,%eax
80103cd9:	75 0d                	jne    80103ce8 <userinit+0x38>
    panic("userinit: out of memory?");
80103cdb:	83 ec 0c             	sub    $0xc,%esp
80103cde:	68 ea a3 10 80       	push   $0x8010a3ea
80103ce3:	e8 c1 c8 ff ff       	call   801005a9 <panic>
  }
  inituvm(p->pgdir, _binary_initcode_start, (int)_binary_initcode_size);
80103ce8:	ba 2c 00 00 00       	mov    $0x2c,%edx
80103ced:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103cf0:	8b 40 04             	mov    0x4(%eax),%eax
80103cf3:	83 ec 04             	sub    $0x4,%esp
80103cf6:	52                   	push   %edx
80103cf7:	68 ec f4 10 80       	push   $0x8010f4ec
80103cfc:	50                   	push   %eax
80103cfd:	e8 79 39 00 00       	call   8010767b <inituvm>
80103d02:	83 c4 10             	add    $0x10,%esp
  p->sz = PGSIZE;
80103d05:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103d08:	c7 00 00 10 00 00    	movl   $0x1000,(%eax)
  memset(p->tf, 0, sizeof(*p->tf));
80103d0e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103d11:	8b 40 18             	mov    0x18(%eax),%eax
80103d14:	83 ec 04             	sub    $0x4,%esp
80103d17:	6a 4c                	push   $0x4c
80103d19:	6a 00                	push   $0x0
80103d1b:	50                   	push   %eax
80103d1c:	e8 9c 0d 00 00       	call   80104abd <memset>
80103d21:	83 c4 10             	add    $0x10,%esp
  p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
80103d24:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103d27:	8b 40 18             	mov    0x18(%eax),%eax
80103d2a:	66 c7 40 3c 1b 00    	movw   $0x1b,0x3c(%eax)
  p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
80103d30:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103d33:	8b 40 18             	mov    0x18(%eax),%eax
80103d36:	66 c7 40 2c 23 00    	movw   $0x23,0x2c(%eax)
  p->tf->es = p->tf->ds;
80103d3c:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103d3f:	8b 50 18             	mov    0x18(%eax),%edx
80103d42:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103d45:	8b 40 18             	mov    0x18(%eax),%eax
80103d48:	0f b7 52 2c          	movzwl 0x2c(%edx),%edx
80103d4c:	66 89 50 28          	mov    %dx,0x28(%eax)
  p->tf->ss = p->tf->ds;
80103d50:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103d53:	8b 50 18             	mov    0x18(%eax),%edx
80103d56:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103d59:	8b 40 18             	mov    0x18(%eax),%eax
80103d5c:	0f b7 52 2c          	movzwl 0x2c(%edx),%edx
80103d60:	66 89 50 48          	mov    %dx,0x48(%eax)
  p->tf->eflags = FL_IF;
80103d64:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103d67:	8b 40 18             	mov    0x18(%eax),%eax
80103d6a:	c7 40 40 00 02 00 00 	movl   $0x200,0x40(%eax)
  p->tf->esp = PGSIZE;
80103d71:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103d74:	8b 40 18             	mov    0x18(%eax),%eax
80103d77:	c7 40 44 00 10 00 00 	movl   $0x1000,0x44(%eax)
  p->tf->eip = 0;  // beginning of initcode.S
80103d7e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103d81:	8b 40 18             	mov    0x18(%eax),%eax
80103d84:	c7 40 38 00 00 00 00 	movl   $0x0,0x38(%eax)

  safestrcpy(p->name, "initcode", sizeof(p->name));
80103d8b:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103d8e:	83 c0 6c             	add    $0x6c,%eax
80103d91:	83 ec 04             	sub    $0x4,%esp
80103d94:	6a 10                	push   $0x10
80103d96:	68 03 a4 10 80       	push   $0x8010a403
80103d9b:	50                   	push   %eax
80103d9c:	e8 1f 0f 00 00       	call   80104cc0 <safestrcpy>
80103da1:	83 c4 10             	add    $0x10,%esp
  p->cwd = namei("/");
80103da4:	83 ec 0c             	sub    $0xc,%esp
80103da7:	68 0c a4 10 80       	push   $0x8010a40c
80103dac:	e8 6c e7 ff ff       	call   8010251d <namei>
80103db1:	83 c4 10             	add    $0x10,%esp
80103db4:	8b 55 f4             	mov    -0xc(%ebp),%edx
80103db7:	89 42 68             	mov    %eax,0x68(%edx)

  // this assignment to p->state lets other cores
  // run this process. the acquire forces the above
  // writes to be visible, and the lock is also needed
  // because the assignment might not be atomic.
  acquire(&ptable.lock);
80103dba:	83 ec 0c             	sub    $0xc,%esp
80103dbd:	68 00 42 19 80       	push   $0x80194200
80103dc2:	e8 80 0a 00 00       	call   80104847 <acquire>
80103dc7:	83 c4 10             	add    $0x10,%esp

  p->state = RUNNABLE;
80103dca:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103dcd:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)

  release(&ptable.lock);
80103dd4:	83 ec 0c             	sub    $0xc,%esp
80103dd7:	68 00 42 19 80       	push   $0x80194200
80103ddc:	e8 d4 0a 00 00       	call   801048b5 <release>
80103de1:	83 c4 10             	add    $0x10,%esp
}
80103de4:	90                   	nop
80103de5:	c9                   	leave  
80103de6:	c3                   	ret    

80103de7 <growproc>:

// Grow current process's memory by n bytes.
// Return 0 on success, -1 on failure.
int
growproc(int n)
{
80103de7:	55                   	push   %ebp
80103de8:	89 e5                	mov    %esp,%ebp
80103dea:	83 ec 18             	sub    $0x18,%esp
  uint sz;
  struct proc *curproc = myproc();
80103ded:	e8 91 fd ff ff       	call   80103b83 <myproc>
80103df2:	89 45 f0             	mov    %eax,-0x10(%ebp)

  sz = curproc->sz;
80103df5:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103df8:	8b 00                	mov    (%eax),%eax
80103dfa:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(n > 0){
80103dfd:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
80103e01:	7e 2e                	jle    80103e31 <growproc+0x4a>
    if((sz = allocuvm(curproc->pgdir, sz, sz + n)) == 0)
80103e03:	8b 55 08             	mov    0x8(%ebp),%edx
80103e06:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103e09:	01 c2                	add    %eax,%edx
80103e0b:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103e0e:	8b 40 04             	mov    0x4(%eax),%eax
80103e11:	83 ec 04             	sub    $0x4,%esp
80103e14:	52                   	push   %edx
80103e15:	ff 75 f4             	push   -0xc(%ebp)
80103e18:	50                   	push   %eax
80103e19:	e8 9a 39 00 00       	call   801077b8 <allocuvm>
80103e1e:	83 c4 10             	add    $0x10,%esp
80103e21:	89 45 f4             	mov    %eax,-0xc(%ebp)
80103e24:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80103e28:	75 3b                	jne    80103e65 <growproc+0x7e>
      return -1;
80103e2a:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80103e2f:	eb 4f                	jmp    80103e80 <growproc+0x99>
  } else if(n < 0){
80103e31:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
80103e35:	79 2e                	jns    80103e65 <growproc+0x7e>
    if((sz = deallocuvm(curproc->pgdir, sz, sz + n)) == 0)
80103e37:	8b 55 08             	mov    0x8(%ebp),%edx
80103e3a:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103e3d:	01 c2                	add    %eax,%edx
80103e3f:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103e42:	8b 40 04             	mov    0x4(%eax),%eax
80103e45:	83 ec 04             	sub    $0x4,%esp
80103e48:	52                   	push   %edx
80103e49:	ff 75 f4             	push   -0xc(%ebp)
80103e4c:	50                   	push   %eax
80103e4d:	e8 6b 3a 00 00       	call   801078bd <deallocuvm>
80103e52:	83 c4 10             	add    $0x10,%esp
80103e55:	89 45 f4             	mov    %eax,-0xc(%ebp)
80103e58:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80103e5c:	75 07                	jne    80103e65 <growproc+0x7e>
      return -1;
80103e5e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80103e63:	eb 1b                	jmp    80103e80 <growproc+0x99>
  }
  curproc->sz = sz;
80103e65:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103e68:	8b 55 f4             	mov    -0xc(%ebp),%edx
80103e6b:	89 10                	mov    %edx,(%eax)
  switchuvm(curproc);
80103e6d:	83 ec 0c             	sub    $0xc,%esp
80103e70:	ff 75 f0             	push   -0x10(%ebp)
80103e73:	e8 64 36 00 00       	call   801074dc <switchuvm>
80103e78:	83 c4 10             	add    $0x10,%esp
  return 0;
80103e7b:	b8 00 00 00 00       	mov    $0x0,%eax
}
80103e80:	c9                   	leave  
80103e81:	c3                   	ret    

80103e82 <fork>:
// Create a new process copying p as the parent.
// Sets up stack to return as if from system call.
// Caller must set state of returned proc to RUNNABLE.
int
fork(void)
{
80103e82:	55                   	push   %ebp
80103e83:	89 e5                	mov    %esp,%ebp
80103e85:	57                   	push   %edi
80103e86:	56                   	push   %esi
80103e87:	53                   	push   %ebx
80103e88:	83 ec 1c             	sub    $0x1c,%esp
  int i, pid;
  struct proc *np;
  struct proc *curproc = myproc();
80103e8b:	e8 f3 fc ff ff       	call   80103b83 <myproc>
80103e90:	89 45 e0             	mov    %eax,-0x20(%ebp)

  // Allocate process.
  if((np = allocproc()) == 0){
80103e93:	e8 14 fd ff ff       	call   80103bac <allocproc>
80103e98:	89 45 dc             	mov    %eax,-0x24(%ebp)
80103e9b:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
80103e9f:	75 0a                	jne    80103eab <fork+0x29>
    return -1;
80103ea1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80103ea6:	e9 48 01 00 00       	jmp    80103ff3 <fork+0x171>
  }

  // Copy process state from proc.
  if((np->pgdir = copyuvm(curproc->pgdir, curproc->sz)) == 0){
80103eab:	8b 45 e0             	mov    -0x20(%ebp),%eax
80103eae:	8b 10                	mov    (%eax),%edx
80103eb0:	8b 45 e0             	mov    -0x20(%ebp),%eax
80103eb3:	8b 40 04             	mov    0x4(%eax),%eax
80103eb6:	83 ec 08             	sub    $0x8,%esp
80103eb9:	52                   	push   %edx
80103eba:	50                   	push   %eax
80103ebb:	e8 9b 3b 00 00       	call   80107a5b <copyuvm>
80103ec0:	83 c4 10             	add    $0x10,%esp
80103ec3:	8b 55 dc             	mov    -0x24(%ebp),%edx
80103ec6:	89 42 04             	mov    %eax,0x4(%edx)
80103ec9:	8b 45 dc             	mov    -0x24(%ebp),%eax
80103ecc:	8b 40 04             	mov    0x4(%eax),%eax
80103ecf:	85 c0                	test   %eax,%eax
80103ed1:	75 30                	jne    80103f03 <fork+0x81>
    kfree(np->kstack);
80103ed3:	8b 45 dc             	mov    -0x24(%ebp),%eax
80103ed6:	8b 40 08             	mov    0x8(%eax),%eax
80103ed9:	83 ec 0c             	sub    $0xc,%esp
80103edc:	50                   	push   %eax
80103edd:	e8 24 e8 ff ff       	call   80102706 <kfree>
80103ee2:	83 c4 10             	add    $0x10,%esp
    np->kstack = 0;
80103ee5:	8b 45 dc             	mov    -0x24(%ebp),%eax
80103ee8:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
    np->state = UNUSED;
80103eef:	8b 45 dc             	mov    -0x24(%ebp),%eax
80103ef2:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
    return -1;
80103ef9:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80103efe:	e9 f0 00 00 00       	jmp    80103ff3 <fork+0x171>
  }
  np->sz = curproc->sz;
80103f03:	8b 45 e0             	mov    -0x20(%ebp),%eax
80103f06:	8b 10                	mov    (%eax),%edx
80103f08:	8b 45 dc             	mov    -0x24(%ebp),%eax
80103f0b:	89 10                	mov    %edx,(%eax)
  np->parent = curproc;
80103f0d:	8b 45 dc             	mov    -0x24(%ebp),%eax
80103f10:	8b 55 e0             	mov    -0x20(%ebp),%edx
80103f13:	89 50 14             	mov    %edx,0x14(%eax)
  *np->tf = *curproc->tf;
80103f16:	8b 45 e0             	mov    -0x20(%ebp),%eax
80103f19:	8b 48 18             	mov    0x18(%eax),%ecx
80103f1c:	8b 45 dc             	mov    -0x24(%ebp),%eax
80103f1f:	8b 40 18             	mov    0x18(%eax),%eax
80103f22:	89 c2                	mov    %eax,%edx
80103f24:	89 cb                	mov    %ecx,%ebx
80103f26:	b8 13 00 00 00       	mov    $0x13,%eax
80103f2b:	89 d7                	mov    %edx,%edi
80103f2d:	89 de                	mov    %ebx,%esi
80103f2f:	89 c1                	mov    %eax,%ecx
80103f31:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)

  // Clear %eax so that fork returns 0 in the child.
  np->tf->eax = 0;
80103f33:	8b 45 dc             	mov    -0x24(%ebp),%eax
80103f36:	8b 40 18             	mov    0x18(%eax),%eax
80103f39:	c7 40 1c 00 00 00 00 	movl   $0x0,0x1c(%eax)

  for(i = 0; i < NOFILE; i++)
80103f40:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
80103f47:	eb 3b                	jmp    80103f84 <fork+0x102>
    if(curproc->ofile[i])
80103f49:	8b 45 e0             	mov    -0x20(%ebp),%eax
80103f4c:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80103f4f:	83 c2 08             	add    $0x8,%edx
80103f52:	8b 44 90 08          	mov    0x8(%eax,%edx,4),%eax
80103f56:	85 c0                	test   %eax,%eax
80103f58:	74 26                	je     80103f80 <fork+0xfe>
      np->ofile[i] = filedup(curproc->ofile[i]);
80103f5a:	8b 45 e0             	mov    -0x20(%ebp),%eax
80103f5d:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80103f60:	83 c2 08             	add    $0x8,%edx
80103f63:	8b 44 90 08          	mov    0x8(%eax,%edx,4),%eax
80103f67:	83 ec 0c             	sub    $0xc,%esp
80103f6a:	50                   	push   %eax
80103f6b:	e8 da d0 ff ff       	call   8010104a <filedup>
80103f70:	83 c4 10             	add    $0x10,%esp
80103f73:	8b 55 dc             	mov    -0x24(%ebp),%edx
80103f76:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80103f79:	83 c1 08             	add    $0x8,%ecx
80103f7c:	89 44 8a 08          	mov    %eax,0x8(%edx,%ecx,4)
  for(i = 0; i < NOFILE; i++)
80103f80:	83 45 e4 01          	addl   $0x1,-0x1c(%ebp)
80103f84:	83 7d e4 0f          	cmpl   $0xf,-0x1c(%ebp)
80103f88:	7e bf                	jle    80103f49 <fork+0xc7>
  np->cwd = idup(curproc->cwd);
80103f8a:	8b 45 e0             	mov    -0x20(%ebp),%eax
80103f8d:	8b 40 68             	mov    0x68(%eax),%eax
80103f90:	83 ec 0c             	sub    $0xc,%esp
80103f93:	50                   	push   %eax
80103f94:	e8 17 da ff ff       	call   801019b0 <idup>
80103f99:	83 c4 10             	add    $0x10,%esp
80103f9c:	8b 55 dc             	mov    -0x24(%ebp),%edx
80103f9f:	89 42 68             	mov    %eax,0x68(%edx)

  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
80103fa2:	8b 45 e0             	mov    -0x20(%ebp),%eax
80103fa5:	8d 50 6c             	lea    0x6c(%eax),%edx
80103fa8:	8b 45 dc             	mov    -0x24(%ebp),%eax
80103fab:	83 c0 6c             	add    $0x6c,%eax
80103fae:	83 ec 04             	sub    $0x4,%esp
80103fb1:	6a 10                	push   $0x10
80103fb3:	52                   	push   %edx
80103fb4:	50                   	push   %eax
80103fb5:	e8 06 0d 00 00       	call   80104cc0 <safestrcpy>
80103fba:	83 c4 10             	add    $0x10,%esp

  pid = np->pid;
80103fbd:	8b 45 dc             	mov    -0x24(%ebp),%eax
80103fc0:	8b 40 10             	mov    0x10(%eax),%eax
80103fc3:	89 45 d8             	mov    %eax,-0x28(%ebp)

  acquire(&ptable.lock);
80103fc6:	83 ec 0c             	sub    $0xc,%esp
80103fc9:	68 00 42 19 80       	push   $0x80194200
80103fce:	e8 74 08 00 00       	call   80104847 <acquire>
80103fd3:	83 c4 10             	add    $0x10,%esp

  np->state = RUNNABLE;
80103fd6:	8b 45 dc             	mov    -0x24(%ebp),%eax
80103fd9:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)

  release(&ptable.lock);
80103fe0:	83 ec 0c             	sub    $0xc,%esp
80103fe3:	68 00 42 19 80       	push   $0x80194200
80103fe8:	e8 c8 08 00 00       	call   801048b5 <release>
80103fed:	83 c4 10             	add    $0x10,%esp

  return pid;
80103ff0:	8b 45 d8             	mov    -0x28(%ebp),%eax
}
80103ff3:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103ff6:	5b                   	pop    %ebx
80103ff7:	5e                   	pop    %esi
80103ff8:	5f                   	pop    %edi
80103ff9:	5d                   	pop    %ebp
80103ffa:	c3                   	ret    

80103ffb <exit>:
// Exit the current process.  Does not return.
// An exited process remains in the zombie state
// until its parent calls wait() to find out it exited.
void
exit(void)
{
80103ffb:	55                   	push   %ebp
80103ffc:	89 e5                	mov    %esp,%ebp
80103ffe:	83 ec 18             	sub    $0x18,%esp
  struct proc *curproc = myproc();
80104001:	e8 7d fb ff ff       	call   80103b83 <myproc>
80104006:	89 45 ec             	mov    %eax,-0x14(%ebp)
  struct proc *p;
  int fd;

  if(curproc == initproc)
80104009:	a1 34 61 19 80       	mov    0x80196134,%eax
8010400e:	39 45 ec             	cmp    %eax,-0x14(%ebp)
80104011:	75 0d                	jne    80104020 <exit+0x25>
    panic("init exiting");
80104013:	83 ec 0c             	sub    $0xc,%esp
80104016:	68 0e a4 10 80       	push   $0x8010a40e
8010401b:	e8 89 c5 ff ff       	call   801005a9 <panic>

  // Close all open files.
  for(fd = 0; fd < NOFILE; fd++){
80104020:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
80104027:	eb 3f                	jmp    80104068 <exit+0x6d>
    if(curproc->ofile[fd]){
80104029:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010402c:	8b 55 f0             	mov    -0x10(%ebp),%edx
8010402f:	83 c2 08             	add    $0x8,%edx
80104032:	8b 44 90 08          	mov    0x8(%eax,%edx,4),%eax
80104036:	85 c0                	test   %eax,%eax
80104038:	74 2a                	je     80104064 <exit+0x69>
      fileclose(curproc->ofile[fd]);
8010403a:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010403d:	8b 55 f0             	mov    -0x10(%ebp),%edx
80104040:	83 c2 08             	add    $0x8,%edx
80104043:	8b 44 90 08          	mov    0x8(%eax,%edx,4),%eax
80104047:	83 ec 0c             	sub    $0xc,%esp
8010404a:	50                   	push   %eax
8010404b:	e8 4b d0 ff ff       	call   8010109b <fileclose>
80104050:	83 c4 10             	add    $0x10,%esp
      curproc->ofile[fd] = 0;
80104053:	8b 45 ec             	mov    -0x14(%ebp),%eax
80104056:	8b 55 f0             	mov    -0x10(%ebp),%edx
80104059:	83 c2 08             	add    $0x8,%edx
8010405c:	c7 44 90 08 00 00 00 	movl   $0x0,0x8(%eax,%edx,4)
80104063:	00 
  for(fd = 0; fd < NOFILE; fd++){
80104064:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
80104068:	83 7d f0 0f          	cmpl   $0xf,-0x10(%ebp)
8010406c:	7e bb                	jle    80104029 <exit+0x2e>
    }
  }

  begin_op();
8010406e:	e8 c9 ef ff ff       	call   8010303c <begin_op>
  iput(curproc->cwd);
80104073:	8b 45 ec             	mov    -0x14(%ebp),%eax
80104076:	8b 40 68             	mov    0x68(%eax),%eax
80104079:	83 ec 0c             	sub    $0xc,%esp
8010407c:	50                   	push   %eax
8010407d:	e8 c9 da ff ff       	call   80101b4b <iput>
80104082:	83 c4 10             	add    $0x10,%esp
  end_op();
80104085:	e8 3e f0 ff ff       	call   801030c8 <end_op>
  curproc->cwd = 0;
8010408a:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010408d:	c7 40 68 00 00 00 00 	movl   $0x0,0x68(%eax)

  acquire(&ptable.lock);
80104094:	83 ec 0c             	sub    $0xc,%esp
80104097:	68 00 42 19 80       	push   $0x80194200
8010409c:	e8 a6 07 00 00       	call   80104847 <acquire>
801040a1:	83 c4 10             	add    $0x10,%esp

  // Parent might be sleeping in wait().
  wakeup1(curproc->parent);
801040a4:	8b 45 ec             	mov    -0x14(%ebp),%eax
801040a7:	8b 40 14             	mov    0x14(%eax),%eax
801040aa:	83 ec 0c             	sub    $0xc,%esp
801040ad:	50                   	push   %eax
801040ae:	e8 20 04 00 00       	call   801044d3 <wakeup1>
801040b3:	83 c4 10             	add    $0x10,%esp

  // Pass abandoned children to init.
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801040b6:	c7 45 f4 34 42 19 80 	movl   $0x80194234,-0xc(%ebp)
801040bd:	eb 37                	jmp    801040f6 <exit+0xfb>
    if(p->parent == curproc){
801040bf:	8b 45 f4             	mov    -0xc(%ebp),%eax
801040c2:	8b 40 14             	mov    0x14(%eax),%eax
801040c5:	39 45 ec             	cmp    %eax,-0x14(%ebp)
801040c8:	75 28                	jne    801040f2 <exit+0xf7>
      p->parent = initproc;
801040ca:	8b 15 34 61 19 80    	mov    0x80196134,%edx
801040d0:	8b 45 f4             	mov    -0xc(%ebp),%eax
801040d3:	89 50 14             	mov    %edx,0x14(%eax)
      if(p->state == ZOMBIE)
801040d6:	8b 45 f4             	mov    -0xc(%ebp),%eax
801040d9:	8b 40 0c             	mov    0xc(%eax),%eax
801040dc:	83 f8 05             	cmp    $0x5,%eax
801040df:	75 11                	jne    801040f2 <exit+0xf7>
        wakeup1(initproc);
801040e1:	a1 34 61 19 80       	mov    0x80196134,%eax
801040e6:	83 ec 0c             	sub    $0xc,%esp
801040e9:	50                   	push   %eax
801040ea:	e8 e4 03 00 00       	call   801044d3 <wakeup1>
801040ef:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801040f2:	83 45 f4 7c          	addl   $0x7c,-0xc(%ebp)
801040f6:	81 7d f4 34 61 19 80 	cmpl   $0x80196134,-0xc(%ebp)
801040fd:	72 c0                	jb     801040bf <exit+0xc4>
    }
  }

  // Jump into the scheduler, never to return.
  curproc->state = ZOMBIE;
801040ff:	8b 45 ec             	mov    -0x14(%ebp),%eax
80104102:	c7 40 0c 05 00 00 00 	movl   $0x5,0xc(%eax)
  sched();
80104109:	e8 e5 01 00 00       	call   801042f3 <sched>
  panic("zombie exit");
8010410e:	83 ec 0c             	sub    $0xc,%esp
80104111:	68 1b a4 10 80       	push   $0x8010a41b
80104116:	e8 8e c4 ff ff       	call   801005a9 <panic>

8010411b <wait>:

// Wait for a child process to exit and return its pid.
// Return -1 if this process has no children.
int
wait(void)
{
8010411b:	55                   	push   %ebp
8010411c:	89 e5                	mov    %esp,%ebp
8010411e:	83 ec 18             	sub    $0x18,%esp
  struct proc *p;
  int havekids, pid;
  struct proc *curproc = myproc();
80104121:	e8 5d fa ff ff       	call   80103b83 <myproc>
80104126:	89 45 ec             	mov    %eax,-0x14(%ebp)
  
  acquire(&ptable.lock);
80104129:	83 ec 0c             	sub    $0xc,%esp
8010412c:	68 00 42 19 80       	push   $0x80194200
80104131:	e8 11 07 00 00       	call   80104847 <acquire>
80104136:	83 c4 10             	add    $0x10,%esp
  for(;;){
    // Scan through table looking for exited children.
    havekids = 0;
80104139:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104140:	c7 45 f4 34 42 19 80 	movl   $0x80194234,-0xc(%ebp)
80104147:	e9 a1 00 00 00       	jmp    801041ed <wait+0xd2>
      if(p->parent != curproc)
8010414c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010414f:	8b 40 14             	mov    0x14(%eax),%eax
80104152:	39 45 ec             	cmp    %eax,-0x14(%ebp)
80104155:	0f 85 8d 00 00 00    	jne    801041e8 <wait+0xcd>
        continue;
      havekids = 1;
8010415b:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
      if(p->state == ZOMBIE){
80104162:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104165:	8b 40 0c             	mov    0xc(%eax),%eax
80104168:	83 f8 05             	cmp    $0x5,%eax
8010416b:	75 7c                	jne    801041e9 <wait+0xce>
        // Found one.
        pid = p->pid;
8010416d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104170:	8b 40 10             	mov    0x10(%eax),%eax
80104173:	89 45 e8             	mov    %eax,-0x18(%ebp)
        kfree(p->kstack);
80104176:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104179:	8b 40 08             	mov    0x8(%eax),%eax
8010417c:	83 ec 0c             	sub    $0xc,%esp
8010417f:	50                   	push   %eax
80104180:	e8 81 e5 ff ff       	call   80102706 <kfree>
80104185:	83 c4 10             	add    $0x10,%esp
        p->kstack = 0;
80104188:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010418b:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
        freevm(p->pgdir);
80104192:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104195:	8b 40 04             	mov    0x4(%eax),%eax
80104198:	83 ec 0c             	sub    $0xc,%esp
8010419b:	50                   	push   %eax
8010419c:	e8 e0 37 00 00       	call   80107981 <freevm>
801041a1:	83 c4 10             	add    $0x10,%esp
        p->pid = 0;
801041a4:	8b 45 f4             	mov    -0xc(%ebp),%eax
801041a7:	c7 40 10 00 00 00 00 	movl   $0x0,0x10(%eax)
        p->parent = 0;
801041ae:	8b 45 f4             	mov    -0xc(%ebp),%eax
801041b1:	c7 40 14 00 00 00 00 	movl   $0x0,0x14(%eax)
        p->name[0] = 0;
801041b8:	8b 45 f4             	mov    -0xc(%ebp),%eax
801041bb:	c6 40 6c 00          	movb   $0x0,0x6c(%eax)
        p->killed = 0;
801041bf:	8b 45 f4             	mov    -0xc(%ebp),%eax
801041c2:	c7 40 24 00 00 00 00 	movl   $0x0,0x24(%eax)
        p->state = UNUSED;
801041c9:	8b 45 f4             	mov    -0xc(%ebp),%eax
801041cc:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
        release(&ptable.lock);
801041d3:	83 ec 0c             	sub    $0xc,%esp
801041d6:	68 00 42 19 80       	push   $0x80194200
801041db:	e8 d5 06 00 00       	call   801048b5 <release>
801041e0:	83 c4 10             	add    $0x10,%esp
        return pid;
801041e3:	8b 45 e8             	mov    -0x18(%ebp),%eax
801041e6:	eb 51                	jmp    80104239 <wait+0x11e>
        continue;
801041e8:	90                   	nop
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801041e9:	83 45 f4 7c          	addl   $0x7c,-0xc(%ebp)
801041ed:	81 7d f4 34 61 19 80 	cmpl   $0x80196134,-0xc(%ebp)
801041f4:	0f 82 52 ff ff ff    	jb     8010414c <wait+0x31>
      }
    }

    // No point waiting if we don't have any children.
    if(!havekids || curproc->killed){
801041fa:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
801041fe:	74 0a                	je     8010420a <wait+0xef>
80104200:	8b 45 ec             	mov    -0x14(%ebp),%eax
80104203:	8b 40 24             	mov    0x24(%eax),%eax
80104206:	85 c0                	test   %eax,%eax
80104208:	74 17                	je     80104221 <wait+0x106>
      release(&ptable.lock);
8010420a:	83 ec 0c             	sub    $0xc,%esp
8010420d:	68 00 42 19 80       	push   $0x80194200
80104212:	e8 9e 06 00 00       	call   801048b5 <release>
80104217:	83 c4 10             	add    $0x10,%esp
      return -1;
8010421a:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010421f:	eb 18                	jmp    80104239 <wait+0x11e>
    }

    // Wait for children to exit.  (See wakeup1 call in proc_exit.)
    sleep(curproc, &ptable.lock);  //DOC: wait-sleep
80104221:	83 ec 08             	sub    $0x8,%esp
80104224:	68 00 42 19 80       	push   $0x80194200
80104229:	ff 75 ec             	push   -0x14(%ebp)
8010422c:	e8 fb 01 00 00       	call   8010442c <sleep>
80104231:	83 c4 10             	add    $0x10,%esp
    havekids = 0;
80104234:	e9 00 ff ff ff       	jmp    80104139 <wait+0x1e>
  }
}
80104239:	c9                   	leave  
8010423a:	c3                   	ret    

8010423b <scheduler>:
//  - swtch to start running that process
//  - eventually that process transfers control
//      via swtch back to the scheduler.
void
scheduler(void)
{
8010423b:	55                   	push   %ebp
8010423c:	89 e5                	mov    %esp,%ebp
8010423e:	83 ec 18             	sub    $0x18,%esp
  struct proc *p;
  struct cpu *c = mycpu();
80104241:	e8 c5 f8 ff ff       	call   80103b0b <mycpu>
80104246:	89 45 f0             	mov    %eax,-0x10(%ebp)
  c->proc = 0;
80104249:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010424c:	c7 80 ac 00 00 00 00 	movl   $0x0,0xac(%eax)
80104253:	00 00 00 
  
  for(;;){
    // Enable interrupts on this processor.
    sti();
80104256:	e8 1d f7 ff ff       	call   80103978 <sti>

    // Loop over process table looking for process to run.
    acquire(&ptable.lock);
8010425b:	83 ec 0c             	sub    $0xc,%esp
8010425e:	68 00 42 19 80       	push   $0x80194200
80104263:	e8 df 05 00 00       	call   80104847 <acquire>
80104268:	83 c4 10             	add    $0x10,%esp
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
8010426b:	c7 45 f4 34 42 19 80 	movl   $0x80194234,-0xc(%ebp)
80104272:	eb 61                	jmp    801042d5 <scheduler+0x9a>
      if(p->state != RUNNABLE)
80104274:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104277:	8b 40 0c             	mov    0xc(%eax),%eax
8010427a:	83 f8 03             	cmp    $0x3,%eax
8010427d:	75 51                	jne    801042d0 <scheduler+0x95>
        continue;

      // Switch to chosen process.  It is the process's job
      // to release ptable.lock and then reacquire it
      // before jumping back to us.
      c->proc = p;
8010427f:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104282:	8b 55 f4             	mov    -0xc(%ebp),%edx
80104285:	89 90 ac 00 00 00    	mov    %edx,0xac(%eax)
      switchuvm(p);
8010428b:	83 ec 0c             	sub    $0xc,%esp
8010428e:	ff 75 f4             	push   -0xc(%ebp)
80104291:	e8 46 32 00 00       	call   801074dc <switchuvm>
80104296:	83 c4 10             	add    $0x10,%esp
      p->state = RUNNING;
80104299:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010429c:	c7 40 0c 04 00 00 00 	movl   $0x4,0xc(%eax)

      swtch(&(c->scheduler), p->context);
801042a3:	8b 45 f4             	mov    -0xc(%ebp),%eax
801042a6:	8b 40 1c             	mov    0x1c(%eax),%eax
801042a9:	8b 55 f0             	mov    -0x10(%ebp),%edx
801042ac:	83 c2 04             	add    $0x4,%edx
801042af:	83 ec 08             	sub    $0x8,%esp
801042b2:	50                   	push   %eax
801042b3:	52                   	push   %edx
801042b4:	e8 79 0a 00 00       	call   80104d32 <swtch>
801042b9:	83 c4 10             	add    $0x10,%esp
      switchkvm();
801042bc:	e8 02 32 00 00       	call   801074c3 <switchkvm>

      // Process is done running for now.
      // It should have changed its p->state before coming back.
      c->proc = 0;
801042c1:	8b 45 f0             	mov    -0x10(%ebp),%eax
801042c4:	c7 80 ac 00 00 00 00 	movl   $0x0,0xac(%eax)
801042cb:	00 00 00 
801042ce:	eb 01                	jmp    801042d1 <scheduler+0x96>
        continue;
801042d0:	90                   	nop
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801042d1:	83 45 f4 7c          	addl   $0x7c,-0xc(%ebp)
801042d5:	81 7d f4 34 61 19 80 	cmpl   $0x80196134,-0xc(%ebp)
801042dc:	72 96                	jb     80104274 <scheduler+0x39>
    }
    release(&ptable.lock);
801042de:	83 ec 0c             	sub    $0xc,%esp
801042e1:	68 00 42 19 80       	push   $0x80194200
801042e6:	e8 ca 05 00 00       	call   801048b5 <release>
801042eb:	83 c4 10             	add    $0x10,%esp
    sti();
801042ee:	e9 63 ff ff ff       	jmp    80104256 <scheduler+0x1b>

801042f3 <sched>:
// be proc->intena and proc->ncli, but that would
// break in the few places where a lock is held but
// there's no process.
void
sched(void)
{
801042f3:	55                   	push   %ebp
801042f4:	89 e5                	mov    %esp,%ebp
801042f6:	83 ec 18             	sub    $0x18,%esp
  int intena;
  struct proc *p = myproc();
801042f9:	e8 85 f8 ff ff       	call   80103b83 <myproc>
801042fe:	89 45 f4             	mov    %eax,-0xc(%ebp)

  if(!holding(&ptable.lock))
80104301:	83 ec 0c             	sub    $0xc,%esp
80104304:	68 00 42 19 80       	push   $0x80194200
80104309:	e8 74 06 00 00       	call   80104982 <holding>
8010430e:	83 c4 10             	add    $0x10,%esp
80104311:	85 c0                	test   %eax,%eax
80104313:	75 0d                	jne    80104322 <sched+0x2f>
    panic("sched ptable.lock");
80104315:	83 ec 0c             	sub    $0xc,%esp
80104318:	68 27 a4 10 80       	push   $0x8010a427
8010431d:	e8 87 c2 ff ff       	call   801005a9 <panic>
  if(mycpu()->ncli != 1)
80104322:	e8 e4 f7 ff ff       	call   80103b0b <mycpu>
80104327:	8b 80 a4 00 00 00    	mov    0xa4(%eax),%eax
8010432d:	83 f8 01             	cmp    $0x1,%eax
80104330:	74 0d                	je     8010433f <sched+0x4c>
    panic("sched locks");
80104332:	83 ec 0c             	sub    $0xc,%esp
80104335:	68 39 a4 10 80       	push   $0x8010a439
8010433a:	e8 6a c2 ff ff       	call   801005a9 <panic>
  if(p->state == RUNNING)
8010433f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104342:	8b 40 0c             	mov    0xc(%eax),%eax
80104345:	83 f8 04             	cmp    $0x4,%eax
80104348:	75 0d                	jne    80104357 <sched+0x64>
    panic("sched running");
8010434a:	83 ec 0c             	sub    $0xc,%esp
8010434d:	68 45 a4 10 80       	push   $0x8010a445
80104352:	e8 52 c2 ff ff       	call   801005a9 <panic>
  if(readeflags()&FL_IF)
80104357:	e8 0c f6 ff ff       	call   80103968 <readeflags>
8010435c:	25 00 02 00 00       	and    $0x200,%eax
80104361:	85 c0                	test   %eax,%eax
80104363:	74 0d                	je     80104372 <sched+0x7f>
    panic("sched interruptible");
80104365:	83 ec 0c             	sub    $0xc,%esp
80104368:	68 53 a4 10 80       	push   $0x8010a453
8010436d:	e8 37 c2 ff ff       	call   801005a9 <panic>
  intena = mycpu()->intena;
80104372:	e8 94 f7 ff ff       	call   80103b0b <mycpu>
80104377:	8b 80 a8 00 00 00    	mov    0xa8(%eax),%eax
8010437d:	89 45 f0             	mov    %eax,-0x10(%ebp)
  swtch(&p->context, mycpu()->scheduler);
80104380:	e8 86 f7 ff ff       	call   80103b0b <mycpu>
80104385:	8b 40 04             	mov    0x4(%eax),%eax
80104388:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010438b:	83 c2 1c             	add    $0x1c,%edx
8010438e:	83 ec 08             	sub    $0x8,%esp
80104391:	50                   	push   %eax
80104392:	52                   	push   %edx
80104393:	e8 9a 09 00 00       	call   80104d32 <swtch>
80104398:	83 c4 10             	add    $0x10,%esp
  mycpu()->intena = intena;
8010439b:	e8 6b f7 ff ff       	call   80103b0b <mycpu>
801043a0:	8b 55 f0             	mov    -0x10(%ebp),%edx
801043a3:	89 90 a8 00 00 00    	mov    %edx,0xa8(%eax)
}
801043a9:	90                   	nop
801043aa:	c9                   	leave  
801043ab:	c3                   	ret    

801043ac <yield>:

// Give up the CPU for one scheduling round.
void
yield(void)
{
801043ac:	55                   	push   %ebp
801043ad:	89 e5                	mov    %esp,%ebp
801043af:	83 ec 08             	sub    $0x8,%esp
  acquire(&ptable.lock);  //DOC: yieldlock
801043b2:	83 ec 0c             	sub    $0xc,%esp
801043b5:	68 00 42 19 80       	push   $0x80194200
801043ba:	e8 88 04 00 00       	call   80104847 <acquire>
801043bf:	83 c4 10             	add    $0x10,%esp
  myproc()->state = RUNNABLE;
801043c2:	e8 bc f7 ff ff       	call   80103b83 <myproc>
801043c7:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
  sched();
801043ce:	e8 20 ff ff ff       	call   801042f3 <sched>
  release(&ptable.lock);
801043d3:	83 ec 0c             	sub    $0xc,%esp
801043d6:	68 00 42 19 80       	push   $0x80194200
801043db:	e8 d5 04 00 00       	call   801048b5 <release>
801043e0:	83 c4 10             	add    $0x10,%esp
}
801043e3:	90                   	nop
801043e4:	c9                   	leave  
801043e5:	c3                   	ret    

801043e6 <forkret>:

// A fork child's very first scheduling by scheduler()
// will swtch here.  "Return" to user space.
void
forkret(void)
{
801043e6:	55                   	push   %ebp
801043e7:	89 e5                	mov    %esp,%ebp
801043e9:	83 ec 08             	sub    $0x8,%esp
  static int first = 1;
  // Still holding ptable.lock from scheduler.
  release(&ptable.lock);
801043ec:	83 ec 0c             	sub    $0xc,%esp
801043ef:	68 00 42 19 80       	push   $0x80194200
801043f4:	e8 bc 04 00 00       	call   801048b5 <release>
801043f9:	83 c4 10             	add    $0x10,%esp

  if (first) {
801043fc:	a1 04 f0 10 80       	mov    0x8010f004,%eax
80104401:	85 c0                	test   %eax,%eax
80104403:	74 24                	je     80104429 <forkret+0x43>
    // Some initialization functions must be run in the context
    // of a regular process (e.g., they call sleep), and thus cannot
    // be run from main().
    first = 0;
80104405:	c7 05 04 f0 10 80 00 	movl   $0x0,0x8010f004
8010440c:	00 00 00 
    iinit(ROOTDEV);
8010440f:	83 ec 0c             	sub    $0xc,%esp
80104412:	6a 01                	push   $0x1
80104414:	e8 5f d2 ff ff       	call   80101678 <iinit>
80104419:	83 c4 10             	add    $0x10,%esp
    initlog(ROOTDEV);
8010441c:	83 ec 0c             	sub    $0xc,%esp
8010441f:	6a 01                	push   $0x1
80104421:	e8 f7 e9 ff ff       	call   80102e1d <initlog>
80104426:	83 c4 10             	add    $0x10,%esp
  }

  // Return to "caller", actually trapret (see allocproc).
}
80104429:	90                   	nop
8010442a:	c9                   	leave  
8010442b:	c3                   	ret    

8010442c <sleep>:

// Atomically release lock and sleep on chan.
// Reacquires lock when awakened.
void
sleep(void *chan, struct spinlock *lk)
{
8010442c:	55                   	push   %ebp
8010442d:	89 e5                	mov    %esp,%ebp
8010442f:	83 ec 18             	sub    $0x18,%esp
  struct proc *p = myproc();
80104432:	e8 4c f7 ff ff       	call   80103b83 <myproc>
80104437:	89 45 f4             	mov    %eax,-0xc(%ebp)
  
  if(p == 0)
8010443a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
8010443e:	75 0d                	jne    8010444d <sleep+0x21>
    panic("sleep");
80104440:	83 ec 0c             	sub    $0xc,%esp
80104443:	68 67 a4 10 80       	push   $0x8010a467
80104448:	e8 5c c1 ff ff       	call   801005a9 <panic>

  if(lk == 0)
8010444d:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
80104451:	75 0d                	jne    80104460 <sleep+0x34>
    panic("sleep without lk");
80104453:	83 ec 0c             	sub    $0xc,%esp
80104456:	68 6d a4 10 80       	push   $0x8010a46d
8010445b:	e8 49 c1 ff ff       	call   801005a9 <panic>
  // change p->state and then call sched.
  // Once we hold ptable.lock, we can be
  // guaranteed that we won't miss any wakeup
  // (wakeup runs with ptable.lock locked),
  // so it's okay to release lk.
  if(lk != &ptable.lock){  //DOC: sleeplock0
80104460:	81 7d 0c 00 42 19 80 	cmpl   $0x80194200,0xc(%ebp)
80104467:	74 1e                	je     80104487 <sleep+0x5b>
    acquire(&ptable.lock);  //DOC: sleeplock1
80104469:	83 ec 0c             	sub    $0xc,%esp
8010446c:	68 00 42 19 80       	push   $0x80194200
80104471:	e8 d1 03 00 00       	call   80104847 <acquire>
80104476:	83 c4 10             	add    $0x10,%esp
    release(lk);
80104479:	83 ec 0c             	sub    $0xc,%esp
8010447c:	ff 75 0c             	push   0xc(%ebp)
8010447f:	e8 31 04 00 00       	call   801048b5 <release>
80104484:	83 c4 10             	add    $0x10,%esp
  }
  // Go to sleep.
  p->chan = chan;
80104487:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010448a:	8b 55 08             	mov    0x8(%ebp),%edx
8010448d:	89 50 20             	mov    %edx,0x20(%eax)
  p->state = SLEEPING;
80104490:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104493:	c7 40 0c 02 00 00 00 	movl   $0x2,0xc(%eax)

  sched();
8010449a:	e8 54 fe ff ff       	call   801042f3 <sched>

  // Tidy up.
  p->chan = 0;
8010449f:	8b 45 f4             	mov    -0xc(%ebp),%eax
801044a2:	c7 40 20 00 00 00 00 	movl   $0x0,0x20(%eax)

  // Reacquire original lock.
  if(lk != &ptable.lock){  //DOC: sleeplock2
801044a9:	81 7d 0c 00 42 19 80 	cmpl   $0x80194200,0xc(%ebp)
801044b0:	74 1e                	je     801044d0 <sleep+0xa4>
    release(&ptable.lock);
801044b2:	83 ec 0c             	sub    $0xc,%esp
801044b5:	68 00 42 19 80       	push   $0x80194200
801044ba:	e8 f6 03 00 00       	call   801048b5 <release>
801044bf:	83 c4 10             	add    $0x10,%esp
    acquire(lk);
801044c2:	83 ec 0c             	sub    $0xc,%esp
801044c5:	ff 75 0c             	push   0xc(%ebp)
801044c8:	e8 7a 03 00 00       	call   80104847 <acquire>
801044cd:	83 c4 10             	add    $0x10,%esp
  }
}
801044d0:	90                   	nop
801044d1:	c9                   	leave  
801044d2:	c3                   	ret    

801044d3 <wakeup1>:
//PAGEBREAK!
// Wake up all processes sleeping on chan.
// The ptable lock must be held.
static void
wakeup1(void *chan)
{
801044d3:	55                   	push   %ebp
801044d4:	89 e5                	mov    %esp,%ebp
801044d6:	83 ec 10             	sub    $0x10,%esp
  struct proc *p;

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
801044d9:	c7 45 fc 34 42 19 80 	movl   $0x80194234,-0x4(%ebp)
801044e0:	eb 24                	jmp    80104506 <wakeup1+0x33>
    if(p->state == SLEEPING && p->chan == chan)
801044e2:	8b 45 fc             	mov    -0x4(%ebp),%eax
801044e5:	8b 40 0c             	mov    0xc(%eax),%eax
801044e8:	83 f8 02             	cmp    $0x2,%eax
801044eb:	75 15                	jne    80104502 <wakeup1+0x2f>
801044ed:	8b 45 fc             	mov    -0x4(%ebp),%eax
801044f0:	8b 40 20             	mov    0x20(%eax),%eax
801044f3:	39 45 08             	cmp    %eax,0x8(%ebp)
801044f6:	75 0a                	jne    80104502 <wakeup1+0x2f>
      p->state = RUNNABLE;
801044f8:	8b 45 fc             	mov    -0x4(%ebp),%eax
801044fb:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104502:	83 45 fc 7c          	addl   $0x7c,-0x4(%ebp)
80104506:	81 7d fc 34 61 19 80 	cmpl   $0x80196134,-0x4(%ebp)
8010450d:	72 d3                	jb     801044e2 <wakeup1+0xf>
}
8010450f:	90                   	nop
80104510:	90                   	nop
80104511:	c9                   	leave  
80104512:	c3                   	ret    

80104513 <wakeup>:

// Wake up all processes sleeping on chan.
void
wakeup(void *chan)
{
80104513:	55                   	push   %ebp
80104514:	89 e5                	mov    %esp,%ebp
80104516:	83 ec 08             	sub    $0x8,%esp
  acquire(&ptable.lock);
80104519:	83 ec 0c             	sub    $0xc,%esp
8010451c:	68 00 42 19 80       	push   $0x80194200
80104521:	e8 21 03 00 00       	call   80104847 <acquire>
80104526:	83 c4 10             	add    $0x10,%esp
  wakeup1(chan);
80104529:	83 ec 0c             	sub    $0xc,%esp
8010452c:	ff 75 08             	push   0x8(%ebp)
8010452f:	e8 9f ff ff ff       	call   801044d3 <wakeup1>
80104534:	83 c4 10             	add    $0x10,%esp
  release(&ptable.lock);
80104537:	83 ec 0c             	sub    $0xc,%esp
8010453a:	68 00 42 19 80       	push   $0x80194200
8010453f:	e8 71 03 00 00       	call   801048b5 <release>
80104544:	83 c4 10             	add    $0x10,%esp
}
80104547:	90                   	nop
80104548:	c9                   	leave  
80104549:	c3                   	ret    

8010454a <kill>:
// Kill the process with the given pid.
// Process won't exit until it returns
// to user space (see trap in trap.c).
int
kill(int pid)
{
8010454a:	55                   	push   %ebp
8010454b:	89 e5                	mov    %esp,%ebp
8010454d:	83 ec 18             	sub    $0x18,%esp
  struct proc *p;

  acquire(&ptable.lock);
80104550:	83 ec 0c             	sub    $0xc,%esp
80104553:	68 00 42 19 80       	push   $0x80194200
80104558:	e8 ea 02 00 00       	call   80104847 <acquire>
8010455d:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104560:	c7 45 f4 34 42 19 80 	movl   $0x80194234,-0xc(%ebp)
80104567:	eb 45                	jmp    801045ae <kill+0x64>
    if(p->pid == pid){
80104569:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010456c:	8b 40 10             	mov    0x10(%eax),%eax
8010456f:	39 45 08             	cmp    %eax,0x8(%ebp)
80104572:	75 36                	jne    801045aa <kill+0x60>
      p->killed = 1;
80104574:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104577:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
      // Wake process from sleep if necessary.
      if(p->state == SLEEPING)
8010457e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104581:	8b 40 0c             	mov    0xc(%eax),%eax
80104584:	83 f8 02             	cmp    $0x2,%eax
80104587:	75 0a                	jne    80104593 <kill+0x49>
        p->state = RUNNABLE;
80104589:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010458c:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
      release(&ptable.lock);
80104593:	83 ec 0c             	sub    $0xc,%esp
80104596:	68 00 42 19 80       	push   $0x80194200
8010459b:	e8 15 03 00 00       	call   801048b5 <release>
801045a0:	83 c4 10             	add    $0x10,%esp
      return 0;
801045a3:	b8 00 00 00 00       	mov    $0x0,%eax
801045a8:	eb 22                	jmp    801045cc <kill+0x82>
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801045aa:	83 45 f4 7c          	addl   $0x7c,-0xc(%ebp)
801045ae:	81 7d f4 34 61 19 80 	cmpl   $0x80196134,-0xc(%ebp)
801045b5:	72 b2                	jb     80104569 <kill+0x1f>
    }
  }
  release(&ptable.lock);
801045b7:	83 ec 0c             	sub    $0xc,%esp
801045ba:	68 00 42 19 80       	push   $0x80194200
801045bf:	e8 f1 02 00 00       	call   801048b5 <release>
801045c4:	83 c4 10             	add    $0x10,%esp
  return -1;
801045c7:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801045cc:	c9                   	leave  
801045cd:	c3                   	ret    

801045ce <procdump>:
// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void
procdump(void)
{
801045ce:	55                   	push   %ebp
801045cf:	89 e5                	mov    %esp,%ebp
801045d1:	83 ec 48             	sub    $0x48,%esp
  int i;
  struct proc *p;
  char *state;
  uint pc[10];

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801045d4:	c7 45 f0 34 42 19 80 	movl   $0x80194234,-0x10(%ebp)
801045db:	e9 d7 00 00 00       	jmp    801046b7 <procdump+0xe9>
    if(p->state == UNUSED)
801045e0:	8b 45 f0             	mov    -0x10(%ebp),%eax
801045e3:	8b 40 0c             	mov    0xc(%eax),%eax
801045e6:	85 c0                	test   %eax,%eax
801045e8:	0f 84 c4 00 00 00    	je     801046b2 <procdump+0xe4>
      continue;
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
801045ee:	8b 45 f0             	mov    -0x10(%ebp),%eax
801045f1:	8b 40 0c             	mov    0xc(%eax),%eax
801045f4:	83 f8 05             	cmp    $0x5,%eax
801045f7:	77 23                	ja     8010461c <procdump+0x4e>
801045f9:	8b 45 f0             	mov    -0x10(%ebp),%eax
801045fc:	8b 40 0c             	mov    0xc(%eax),%eax
801045ff:	8b 04 85 08 f0 10 80 	mov    -0x7fef0ff8(,%eax,4),%eax
80104606:	85 c0                	test   %eax,%eax
80104608:	74 12                	je     8010461c <procdump+0x4e>
      state = states[p->state];
8010460a:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010460d:	8b 40 0c             	mov    0xc(%eax),%eax
80104610:	8b 04 85 08 f0 10 80 	mov    -0x7fef0ff8(,%eax,4),%eax
80104617:	89 45 ec             	mov    %eax,-0x14(%ebp)
8010461a:	eb 07                	jmp    80104623 <procdump+0x55>
    else
      state = "???";
8010461c:	c7 45 ec 7e a4 10 80 	movl   $0x8010a47e,-0x14(%ebp)
    cprintf("%d %s %s", p->pid, state, p->name);
80104623:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104626:	8d 50 6c             	lea    0x6c(%eax),%edx
80104629:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010462c:	8b 40 10             	mov    0x10(%eax),%eax
8010462f:	52                   	push   %edx
80104630:	ff 75 ec             	push   -0x14(%ebp)
80104633:	50                   	push   %eax
80104634:	68 82 a4 10 80       	push   $0x8010a482
80104639:	e8 b6 bd ff ff       	call   801003f4 <cprintf>
8010463e:	83 c4 10             	add    $0x10,%esp
    if(p->state == SLEEPING){
80104641:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104644:	8b 40 0c             	mov    0xc(%eax),%eax
80104647:	83 f8 02             	cmp    $0x2,%eax
8010464a:	75 54                	jne    801046a0 <procdump+0xd2>
      getcallerpcs((uint*)p->context->ebp+2, pc);
8010464c:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010464f:	8b 40 1c             	mov    0x1c(%eax),%eax
80104652:	8b 40 0c             	mov    0xc(%eax),%eax
80104655:	83 c0 08             	add    $0x8,%eax
80104658:	89 c2                	mov    %eax,%edx
8010465a:	83 ec 08             	sub    $0x8,%esp
8010465d:	8d 45 c4             	lea    -0x3c(%ebp),%eax
80104660:	50                   	push   %eax
80104661:	52                   	push   %edx
80104662:	e8 a0 02 00 00       	call   80104907 <getcallerpcs>
80104667:	83 c4 10             	add    $0x10,%esp
      for(i=0; i<10 && pc[i] != 0; i++)
8010466a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80104671:	eb 1c                	jmp    8010468f <procdump+0xc1>
        cprintf(" %p", pc[i]);
80104673:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104676:	8b 44 85 c4          	mov    -0x3c(%ebp,%eax,4),%eax
8010467a:	83 ec 08             	sub    $0x8,%esp
8010467d:	50                   	push   %eax
8010467e:	68 8b a4 10 80       	push   $0x8010a48b
80104683:	e8 6c bd ff ff       	call   801003f4 <cprintf>
80104688:	83 c4 10             	add    $0x10,%esp
      for(i=0; i<10 && pc[i] != 0; i++)
8010468b:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
8010468f:	83 7d f4 09          	cmpl   $0x9,-0xc(%ebp)
80104693:	7f 0b                	jg     801046a0 <procdump+0xd2>
80104695:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104698:	8b 44 85 c4          	mov    -0x3c(%ebp,%eax,4),%eax
8010469c:	85 c0                	test   %eax,%eax
8010469e:	75 d3                	jne    80104673 <procdump+0xa5>
    }
    cprintf("\n");
801046a0:	83 ec 0c             	sub    $0xc,%esp
801046a3:	68 8f a4 10 80       	push   $0x8010a48f
801046a8:	e8 47 bd ff ff       	call   801003f4 <cprintf>
801046ad:	83 c4 10             	add    $0x10,%esp
801046b0:	eb 01                	jmp    801046b3 <procdump+0xe5>
      continue;
801046b2:	90                   	nop
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801046b3:	83 45 f0 7c          	addl   $0x7c,-0x10(%ebp)
801046b7:	81 7d f0 34 61 19 80 	cmpl   $0x80196134,-0x10(%ebp)
801046be:	0f 82 1c ff ff ff    	jb     801045e0 <procdump+0x12>
  }
}
801046c4:	90                   	nop
801046c5:	90                   	nop
801046c6:	c9                   	leave  
801046c7:	c3                   	ret    

801046c8 <initsleeplock>:
#include "spinlock.h"
#include "sleeplock.h"

void
initsleeplock(struct sleeplock *lk, char *name)
{
801046c8:	55                   	push   %ebp
801046c9:	89 e5                	mov    %esp,%ebp
801046cb:	83 ec 08             	sub    $0x8,%esp
  initlock(&lk->lk, "sleep lock");
801046ce:	8b 45 08             	mov    0x8(%ebp),%eax
801046d1:	83 c0 04             	add    $0x4,%eax
801046d4:	83 ec 08             	sub    $0x8,%esp
801046d7:	68 bb a4 10 80       	push   $0x8010a4bb
801046dc:	50                   	push   %eax
801046dd:	e8 43 01 00 00       	call   80104825 <initlock>
801046e2:	83 c4 10             	add    $0x10,%esp
  lk->name = name;
801046e5:	8b 45 08             	mov    0x8(%ebp),%eax
801046e8:	8b 55 0c             	mov    0xc(%ebp),%edx
801046eb:	89 50 38             	mov    %edx,0x38(%eax)
  lk->locked = 0;
801046ee:	8b 45 08             	mov    0x8(%ebp),%eax
801046f1:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  lk->pid = 0;
801046f7:	8b 45 08             	mov    0x8(%ebp),%eax
801046fa:	c7 40 3c 00 00 00 00 	movl   $0x0,0x3c(%eax)
}
80104701:	90                   	nop
80104702:	c9                   	leave  
80104703:	c3                   	ret    

80104704 <acquiresleep>:

void
acquiresleep(struct sleeplock *lk)
{
80104704:	55                   	push   %ebp
80104705:	89 e5                	mov    %esp,%ebp
80104707:	83 ec 08             	sub    $0x8,%esp
  acquire(&lk->lk);
8010470a:	8b 45 08             	mov    0x8(%ebp),%eax
8010470d:	83 c0 04             	add    $0x4,%eax
80104710:	83 ec 0c             	sub    $0xc,%esp
80104713:	50                   	push   %eax
80104714:	e8 2e 01 00 00       	call   80104847 <acquire>
80104719:	83 c4 10             	add    $0x10,%esp
  while (lk->locked) {
8010471c:	eb 15                	jmp    80104733 <acquiresleep+0x2f>
    sleep(lk, &lk->lk);
8010471e:	8b 45 08             	mov    0x8(%ebp),%eax
80104721:	83 c0 04             	add    $0x4,%eax
80104724:	83 ec 08             	sub    $0x8,%esp
80104727:	50                   	push   %eax
80104728:	ff 75 08             	push   0x8(%ebp)
8010472b:	e8 fc fc ff ff       	call   8010442c <sleep>
80104730:	83 c4 10             	add    $0x10,%esp
  while (lk->locked) {
80104733:	8b 45 08             	mov    0x8(%ebp),%eax
80104736:	8b 00                	mov    (%eax),%eax
80104738:	85 c0                	test   %eax,%eax
8010473a:	75 e2                	jne    8010471e <acquiresleep+0x1a>
  }
  lk->locked = 1;
8010473c:	8b 45 08             	mov    0x8(%ebp),%eax
8010473f:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  lk->pid = myproc()->pid;
80104745:	e8 39 f4 ff ff       	call   80103b83 <myproc>
8010474a:	8b 50 10             	mov    0x10(%eax),%edx
8010474d:	8b 45 08             	mov    0x8(%ebp),%eax
80104750:	89 50 3c             	mov    %edx,0x3c(%eax)
  release(&lk->lk);
80104753:	8b 45 08             	mov    0x8(%ebp),%eax
80104756:	83 c0 04             	add    $0x4,%eax
80104759:	83 ec 0c             	sub    $0xc,%esp
8010475c:	50                   	push   %eax
8010475d:	e8 53 01 00 00       	call   801048b5 <release>
80104762:	83 c4 10             	add    $0x10,%esp
}
80104765:	90                   	nop
80104766:	c9                   	leave  
80104767:	c3                   	ret    

80104768 <releasesleep>:

void
releasesleep(struct sleeplock *lk)
{
80104768:	55                   	push   %ebp
80104769:	89 e5                	mov    %esp,%ebp
8010476b:	83 ec 08             	sub    $0x8,%esp
  acquire(&lk->lk);
8010476e:	8b 45 08             	mov    0x8(%ebp),%eax
80104771:	83 c0 04             	add    $0x4,%eax
80104774:	83 ec 0c             	sub    $0xc,%esp
80104777:	50                   	push   %eax
80104778:	e8 ca 00 00 00       	call   80104847 <acquire>
8010477d:	83 c4 10             	add    $0x10,%esp
  lk->locked = 0;
80104780:	8b 45 08             	mov    0x8(%ebp),%eax
80104783:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  lk->pid = 0;
80104789:	8b 45 08             	mov    0x8(%ebp),%eax
8010478c:	c7 40 3c 00 00 00 00 	movl   $0x0,0x3c(%eax)
  wakeup(lk);
80104793:	83 ec 0c             	sub    $0xc,%esp
80104796:	ff 75 08             	push   0x8(%ebp)
80104799:	e8 75 fd ff ff       	call   80104513 <wakeup>
8010479e:	83 c4 10             	add    $0x10,%esp
  release(&lk->lk);
801047a1:	8b 45 08             	mov    0x8(%ebp),%eax
801047a4:	83 c0 04             	add    $0x4,%eax
801047a7:	83 ec 0c             	sub    $0xc,%esp
801047aa:	50                   	push   %eax
801047ab:	e8 05 01 00 00       	call   801048b5 <release>
801047b0:	83 c4 10             	add    $0x10,%esp
}
801047b3:	90                   	nop
801047b4:	c9                   	leave  
801047b5:	c3                   	ret    

801047b6 <holdingsleep>:

int
holdingsleep(struct sleeplock *lk)
{
801047b6:	55                   	push   %ebp
801047b7:	89 e5                	mov    %esp,%ebp
801047b9:	83 ec 18             	sub    $0x18,%esp
  int r;
  
  acquire(&lk->lk);
801047bc:	8b 45 08             	mov    0x8(%ebp),%eax
801047bf:	83 c0 04             	add    $0x4,%eax
801047c2:	83 ec 0c             	sub    $0xc,%esp
801047c5:	50                   	push   %eax
801047c6:	e8 7c 00 00 00       	call   80104847 <acquire>
801047cb:	83 c4 10             	add    $0x10,%esp
  r = lk->locked;
801047ce:	8b 45 08             	mov    0x8(%ebp),%eax
801047d1:	8b 00                	mov    (%eax),%eax
801047d3:	89 45 f4             	mov    %eax,-0xc(%ebp)
  release(&lk->lk);
801047d6:	8b 45 08             	mov    0x8(%ebp),%eax
801047d9:	83 c0 04             	add    $0x4,%eax
801047dc:	83 ec 0c             	sub    $0xc,%esp
801047df:	50                   	push   %eax
801047e0:	e8 d0 00 00 00       	call   801048b5 <release>
801047e5:	83 c4 10             	add    $0x10,%esp
  return r;
801047e8:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
801047eb:	c9                   	leave  
801047ec:	c3                   	ret    

801047ed <readeflags>:
{
801047ed:	55                   	push   %ebp
801047ee:	89 e5                	mov    %esp,%ebp
801047f0:	83 ec 10             	sub    $0x10,%esp
  asm volatile("pushfl; popl %0" : "=r" (eflags));
801047f3:	9c                   	pushf  
801047f4:	58                   	pop    %eax
801047f5:	89 45 fc             	mov    %eax,-0x4(%ebp)
  return eflags;
801047f8:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
801047fb:	c9                   	leave  
801047fc:	c3                   	ret    

801047fd <cli>:
{
801047fd:	55                   	push   %ebp
801047fe:	89 e5                	mov    %esp,%ebp
  asm volatile("cli");
80104800:	fa                   	cli    
}
80104801:	90                   	nop
80104802:	5d                   	pop    %ebp
80104803:	c3                   	ret    

80104804 <sti>:
{
80104804:	55                   	push   %ebp
80104805:	89 e5                	mov    %esp,%ebp
  asm volatile("sti");
80104807:	fb                   	sti    
}
80104808:	90                   	nop
80104809:	5d                   	pop    %ebp
8010480a:	c3                   	ret    

8010480b <xchg>:
{
8010480b:	55                   	push   %ebp
8010480c:	89 e5                	mov    %esp,%ebp
8010480e:	83 ec 10             	sub    $0x10,%esp
  asm volatile("lock; xchgl %0, %1" :
80104811:	8b 55 08             	mov    0x8(%ebp),%edx
80104814:	8b 45 0c             	mov    0xc(%ebp),%eax
80104817:	8b 4d 08             	mov    0x8(%ebp),%ecx
8010481a:	f0 87 02             	lock xchg %eax,(%edx)
8010481d:	89 45 fc             	mov    %eax,-0x4(%ebp)
  return result;
80104820:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
80104823:	c9                   	leave  
80104824:	c3                   	ret    

80104825 <initlock>:
#include "proc.h"
#include "spinlock.h"

void
initlock(struct spinlock *lk, char *name)
{
80104825:	55                   	push   %ebp
80104826:	89 e5                	mov    %esp,%ebp
  lk->name = name;
80104828:	8b 45 08             	mov    0x8(%ebp),%eax
8010482b:	8b 55 0c             	mov    0xc(%ebp),%edx
8010482e:	89 50 04             	mov    %edx,0x4(%eax)
  lk->locked = 0;
80104831:	8b 45 08             	mov    0x8(%ebp),%eax
80104834:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  lk->cpu = 0;
8010483a:	8b 45 08             	mov    0x8(%ebp),%eax
8010483d:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
}
80104844:	90                   	nop
80104845:	5d                   	pop    %ebp
80104846:	c3                   	ret    

80104847 <acquire>:
// Loops (spins) until the lock is acquired.
// Holding a lock for a long time may cause
// other CPUs to waste time spinning to acquire it.
void
acquire(struct spinlock *lk)
{
80104847:	55                   	push   %ebp
80104848:	89 e5                	mov    %esp,%ebp
8010484a:	53                   	push   %ebx
8010484b:	83 ec 04             	sub    $0x4,%esp
  pushcli(); // disable interrupts to avoid deadlock.
8010484e:	e8 5f 01 00 00       	call   801049b2 <pushcli>
  if(holding(lk)){
80104853:	8b 45 08             	mov    0x8(%ebp),%eax
80104856:	83 ec 0c             	sub    $0xc,%esp
80104859:	50                   	push   %eax
8010485a:	e8 23 01 00 00       	call   80104982 <holding>
8010485f:	83 c4 10             	add    $0x10,%esp
80104862:	85 c0                	test   %eax,%eax
80104864:	74 0d                	je     80104873 <acquire+0x2c>
    panic("acquire");
80104866:	83 ec 0c             	sub    $0xc,%esp
80104869:	68 c6 a4 10 80       	push   $0x8010a4c6
8010486e:	e8 36 bd ff ff       	call   801005a9 <panic>
  }

  // The xchg is atomic.
  while(xchg(&lk->locked, 1) != 0)
80104873:	90                   	nop
80104874:	8b 45 08             	mov    0x8(%ebp),%eax
80104877:	83 ec 08             	sub    $0x8,%esp
8010487a:	6a 01                	push   $0x1
8010487c:	50                   	push   %eax
8010487d:	e8 89 ff ff ff       	call   8010480b <xchg>
80104882:	83 c4 10             	add    $0x10,%esp
80104885:	85 c0                	test   %eax,%eax
80104887:	75 eb                	jne    80104874 <acquire+0x2d>
    ;

  // Tell the C compiler and the processor to not move loads or stores
  // past this point, to ensure that the critical section's memory
  // references happen after the lock is acquired.
  __sync_synchronize();
80104889:	f0 83 0c 24 00       	lock orl $0x0,(%esp)

  // Record info about lock acquisition for debugging.
  lk->cpu = mycpu();
8010488e:	8b 5d 08             	mov    0x8(%ebp),%ebx
80104891:	e8 75 f2 ff ff       	call   80103b0b <mycpu>
80104896:	89 43 08             	mov    %eax,0x8(%ebx)
  getcallerpcs(&lk, lk->pcs);
80104899:	8b 45 08             	mov    0x8(%ebp),%eax
8010489c:	83 c0 0c             	add    $0xc,%eax
8010489f:	83 ec 08             	sub    $0x8,%esp
801048a2:	50                   	push   %eax
801048a3:	8d 45 08             	lea    0x8(%ebp),%eax
801048a6:	50                   	push   %eax
801048a7:	e8 5b 00 00 00       	call   80104907 <getcallerpcs>
801048ac:	83 c4 10             	add    $0x10,%esp
}
801048af:	90                   	nop
801048b0:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801048b3:	c9                   	leave  
801048b4:	c3                   	ret    

801048b5 <release>:

// Release the lock.
void
release(struct spinlock *lk)
{
801048b5:	55                   	push   %ebp
801048b6:	89 e5                	mov    %esp,%ebp
801048b8:	83 ec 08             	sub    $0x8,%esp
  if(!holding(lk))
801048bb:	83 ec 0c             	sub    $0xc,%esp
801048be:	ff 75 08             	push   0x8(%ebp)
801048c1:	e8 bc 00 00 00       	call   80104982 <holding>
801048c6:	83 c4 10             	add    $0x10,%esp
801048c9:	85 c0                	test   %eax,%eax
801048cb:	75 0d                	jne    801048da <release+0x25>
    panic("release");
801048cd:	83 ec 0c             	sub    $0xc,%esp
801048d0:	68 ce a4 10 80       	push   $0x8010a4ce
801048d5:	e8 cf bc ff ff       	call   801005a9 <panic>

  lk->pcs[0] = 0;
801048da:	8b 45 08             	mov    0x8(%ebp),%eax
801048dd:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
  lk->cpu = 0;
801048e4:	8b 45 08             	mov    0x8(%ebp),%eax
801048e7:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  // Tell the C compiler and the processor to not move loads or stores
  // past this point, to ensure that all the stores in the critical
  // section are visible to other cores before the lock is released.
  // Both the C compiler and the hardware may re-order loads and
  // stores; __sync_synchronize() tells them both not to.
  __sync_synchronize();
801048ee:	f0 83 0c 24 00       	lock orl $0x0,(%esp)

  // Release the lock, equivalent to lk->locked = 0.
  // This code can't use a C assignment, since it might
  // not be atomic. A real OS would use C atomics here.
  asm volatile("movl $0, %0" : "+m" (lk->locked) : );
801048f3:	8b 45 08             	mov    0x8(%ebp),%eax
801048f6:	8b 55 08             	mov    0x8(%ebp),%edx
801048f9:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

  popcli();
801048ff:	e8 fb 00 00 00       	call   801049ff <popcli>
}
80104904:	90                   	nop
80104905:	c9                   	leave  
80104906:	c3                   	ret    

80104907 <getcallerpcs>:

// Record the current call stack in pcs[] by following the %ebp chain.
void
getcallerpcs(void *v, uint pcs[])
{
80104907:	55                   	push   %ebp
80104908:	89 e5                	mov    %esp,%ebp
8010490a:	83 ec 10             	sub    $0x10,%esp
  uint *ebp;
  int i;

  ebp = (uint*)v - 2;
8010490d:	8b 45 08             	mov    0x8(%ebp),%eax
80104910:	83 e8 08             	sub    $0x8,%eax
80104913:	89 45 fc             	mov    %eax,-0x4(%ebp)
  for(i = 0; i < 10; i++){
80104916:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
8010491d:	eb 38                	jmp    80104957 <getcallerpcs+0x50>
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
8010491f:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
80104923:	74 53                	je     80104978 <getcallerpcs+0x71>
80104925:	81 7d fc ff ff ff 7f 	cmpl   $0x7fffffff,-0x4(%ebp)
8010492c:	76 4a                	jbe    80104978 <getcallerpcs+0x71>
8010492e:	83 7d fc ff          	cmpl   $0xffffffff,-0x4(%ebp)
80104932:	74 44                	je     80104978 <getcallerpcs+0x71>
      break;
    pcs[i] = ebp[1];     // saved %eip
80104934:	8b 45 f8             	mov    -0x8(%ebp),%eax
80104937:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
8010493e:	8b 45 0c             	mov    0xc(%ebp),%eax
80104941:	01 c2                	add    %eax,%edx
80104943:	8b 45 fc             	mov    -0x4(%ebp),%eax
80104946:	8b 40 04             	mov    0x4(%eax),%eax
80104949:	89 02                	mov    %eax,(%edx)
    ebp = (uint*)ebp[0]; // saved %ebp
8010494b:	8b 45 fc             	mov    -0x4(%ebp),%eax
8010494e:	8b 00                	mov    (%eax),%eax
80104950:	89 45 fc             	mov    %eax,-0x4(%ebp)
  for(i = 0; i < 10; i++){
80104953:	83 45 f8 01          	addl   $0x1,-0x8(%ebp)
80104957:	83 7d f8 09          	cmpl   $0x9,-0x8(%ebp)
8010495b:	7e c2                	jle    8010491f <getcallerpcs+0x18>
  }
  for(; i < 10; i++)
8010495d:	eb 19                	jmp    80104978 <getcallerpcs+0x71>
    pcs[i] = 0;
8010495f:	8b 45 f8             	mov    -0x8(%ebp),%eax
80104962:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80104969:	8b 45 0c             	mov    0xc(%ebp),%eax
8010496c:	01 d0                	add    %edx,%eax
8010496e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  for(; i < 10; i++)
80104974:	83 45 f8 01          	addl   $0x1,-0x8(%ebp)
80104978:	83 7d f8 09          	cmpl   $0x9,-0x8(%ebp)
8010497c:	7e e1                	jle    8010495f <getcallerpcs+0x58>
}
8010497e:	90                   	nop
8010497f:	90                   	nop
80104980:	c9                   	leave  
80104981:	c3                   	ret    

80104982 <holding>:

// Check whether this cpu is holding the lock.
int
holding(struct spinlock *lock)
{
80104982:	55                   	push   %ebp
80104983:	89 e5                	mov    %esp,%ebp
80104985:	53                   	push   %ebx
80104986:	83 ec 04             	sub    $0x4,%esp
  return lock->locked && lock->cpu == mycpu();
80104989:	8b 45 08             	mov    0x8(%ebp),%eax
8010498c:	8b 00                	mov    (%eax),%eax
8010498e:	85 c0                	test   %eax,%eax
80104990:	74 16                	je     801049a8 <holding+0x26>
80104992:	8b 45 08             	mov    0x8(%ebp),%eax
80104995:	8b 58 08             	mov    0x8(%eax),%ebx
80104998:	e8 6e f1 ff ff       	call   80103b0b <mycpu>
8010499d:	39 c3                	cmp    %eax,%ebx
8010499f:	75 07                	jne    801049a8 <holding+0x26>
801049a1:	b8 01 00 00 00       	mov    $0x1,%eax
801049a6:	eb 05                	jmp    801049ad <holding+0x2b>
801049a8:	b8 00 00 00 00       	mov    $0x0,%eax
}
801049ad:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801049b0:	c9                   	leave  
801049b1:	c3                   	ret    

801049b2 <pushcli>:
// it takes two popcli to undo two pushcli.  Also, if interrupts
// are off, then pushcli, popcli leaves them off.

void
pushcli(void)
{
801049b2:	55                   	push   %ebp
801049b3:	89 e5                	mov    %esp,%ebp
801049b5:	83 ec 18             	sub    $0x18,%esp
  int eflags;

  eflags = readeflags();
801049b8:	e8 30 fe ff ff       	call   801047ed <readeflags>
801049bd:	89 45 f4             	mov    %eax,-0xc(%ebp)
  cli();
801049c0:	e8 38 fe ff ff       	call   801047fd <cli>
  if(mycpu()->ncli == 0)
801049c5:	e8 41 f1 ff ff       	call   80103b0b <mycpu>
801049ca:	8b 80 a4 00 00 00    	mov    0xa4(%eax),%eax
801049d0:	85 c0                	test   %eax,%eax
801049d2:	75 14                	jne    801049e8 <pushcli+0x36>
    mycpu()->intena = eflags & FL_IF;
801049d4:	e8 32 f1 ff ff       	call   80103b0b <mycpu>
801049d9:	8b 55 f4             	mov    -0xc(%ebp),%edx
801049dc:	81 e2 00 02 00 00    	and    $0x200,%edx
801049e2:	89 90 a8 00 00 00    	mov    %edx,0xa8(%eax)
  mycpu()->ncli += 1;
801049e8:	e8 1e f1 ff ff       	call   80103b0b <mycpu>
801049ed:	8b 90 a4 00 00 00    	mov    0xa4(%eax),%edx
801049f3:	83 c2 01             	add    $0x1,%edx
801049f6:	89 90 a4 00 00 00    	mov    %edx,0xa4(%eax)
}
801049fc:	90                   	nop
801049fd:	c9                   	leave  
801049fe:	c3                   	ret    

801049ff <popcli>:

void
popcli(void)
{
801049ff:	55                   	push   %ebp
80104a00:	89 e5                	mov    %esp,%ebp
80104a02:	83 ec 08             	sub    $0x8,%esp
  if(readeflags()&FL_IF)
80104a05:	e8 e3 fd ff ff       	call   801047ed <readeflags>
80104a0a:	25 00 02 00 00       	and    $0x200,%eax
80104a0f:	85 c0                	test   %eax,%eax
80104a11:	74 0d                	je     80104a20 <popcli+0x21>
    panic("popcli - interruptible");
80104a13:	83 ec 0c             	sub    $0xc,%esp
80104a16:	68 d6 a4 10 80       	push   $0x8010a4d6
80104a1b:	e8 89 bb ff ff       	call   801005a9 <panic>
  if(--mycpu()->ncli < 0)
80104a20:	e8 e6 f0 ff ff       	call   80103b0b <mycpu>
80104a25:	8b 90 a4 00 00 00    	mov    0xa4(%eax),%edx
80104a2b:	83 ea 01             	sub    $0x1,%edx
80104a2e:	89 90 a4 00 00 00    	mov    %edx,0xa4(%eax)
80104a34:	8b 80 a4 00 00 00    	mov    0xa4(%eax),%eax
80104a3a:	85 c0                	test   %eax,%eax
80104a3c:	79 0d                	jns    80104a4b <popcli+0x4c>
    panic("popcli");
80104a3e:	83 ec 0c             	sub    $0xc,%esp
80104a41:	68 ed a4 10 80       	push   $0x8010a4ed
80104a46:	e8 5e bb ff ff       	call   801005a9 <panic>
  if(mycpu()->ncli == 0 && mycpu()->intena)
80104a4b:	e8 bb f0 ff ff       	call   80103b0b <mycpu>
80104a50:	8b 80 a4 00 00 00    	mov    0xa4(%eax),%eax
80104a56:	85 c0                	test   %eax,%eax
80104a58:	75 14                	jne    80104a6e <popcli+0x6f>
80104a5a:	e8 ac f0 ff ff       	call   80103b0b <mycpu>
80104a5f:	8b 80 a8 00 00 00    	mov    0xa8(%eax),%eax
80104a65:	85 c0                	test   %eax,%eax
80104a67:	74 05                	je     80104a6e <popcli+0x6f>
    sti();
80104a69:	e8 96 fd ff ff       	call   80104804 <sti>
}
80104a6e:	90                   	nop
80104a6f:	c9                   	leave  
80104a70:	c3                   	ret    

80104a71 <stosb>:
80104a71:	55                   	push   %ebp
80104a72:	89 e5                	mov    %esp,%ebp
80104a74:	57                   	push   %edi
80104a75:	53                   	push   %ebx
80104a76:	8b 4d 08             	mov    0x8(%ebp),%ecx
80104a79:	8b 55 10             	mov    0x10(%ebp),%edx
80104a7c:	8b 45 0c             	mov    0xc(%ebp),%eax
80104a7f:	89 cb                	mov    %ecx,%ebx
80104a81:	89 df                	mov    %ebx,%edi
80104a83:	89 d1                	mov    %edx,%ecx
80104a85:	fc                   	cld    
80104a86:	f3 aa                	rep stos %al,%es:(%edi)
80104a88:	89 ca                	mov    %ecx,%edx
80104a8a:	89 fb                	mov    %edi,%ebx
80104a8c:	89 5d 08             	mov    %ebx,0x8(%ebp)
80104a8f:	89 55 10             	mov    %edx,0x10(%ebp)
80104a92:	90                   	nop
80104a93:	5b                   	pop    %ebx
80104a94:	5f                   	pop    %edi
80104a95:	5d                   	pop    %ebp
80104a96:	c3                   	ret    

80104a97 <stosl>:
80104a97:	55                   	push   %ebp
80104a98:	89 e5                	mov    %esp,%ebp
80104a9a:	57                   	push   %edi
80104a9b:	53                   	push   %ebx
80104a9c:	8b 4d 08             	mov    0x8(%ebp),%ecx
80104a9f:	8b 55 10             	mov    0x10(%ebp),%edx
80104aa2:	8b 45 0c             	mov    0xc(%ebp),%eax
80104aa5:	89 cb                	mov    %ecx,%ebx
80104aa7:	89 df                	mov    %ebx,%edi
80104aa9:	89 d1                	mov    %edx,%ecx
80104aab:	fc                   	cld    
80104aac:	f3 ab                	rep stos %eax,%es:(%edi)
80104aae:	89 ca                	mov    %ecx,%edx
80104ab0:	89 fb                	mov    %edi,%ebx
80104ab2:	89 5d 08             	mov    %ebx,0x8(%ebp)
80104ab5:	89 55 10             	mov    %edx,0x10(%ebp)
80104ab8:	90                   	nop
80104ab9:	5b                   	pop    %ebx
80104aba:	5f                   	pop    %edi
80104abb:	5d                   	pop    %ebp
80104abc:	c3                   	ret    

80104abd <memset>:
80104abd:	55                   	push   %ebp
80104abe:	89 e5                	mov    %esp,%ebp
80104ac0:	8b 45 08             	mov    0x8(%ebp),%eax
80104ac3:	83 e0 03             	and    $0x3,%eax
80104ac6:	85 c0                	test   %eax,%eax
80104ac8:	75 43                	jne    80104b0d <memset+0x50>
80104aca:	8b 45 10             	mov    0x10(%ebp),%eax
80104acd:	83 e0 03             	and    $0x3,%eax
80104ad0:	85 c0                	test   %eax,%eax
80104ad2:	75 39                	jne    80104b0d <memset+0x50>
80104ad4:	81 65 0c ff 00 00 00 	andl   $0xff,0xc(%ebp)
80104adb:	8b 45 10             	mov    0x10(%ebp),%eax
80104ade:	c1 e8 02             	shr    $0x2,%eax
80104ae1:	89 c2                	mov    %eax,%edx
80104ae3:	8b 45 0c             	mov    0xc(%ebp),%eax
80104ae6:	c1 e0 18             	shl    $0x18,%eax
80104ae9:	89 c1                	mov    %eax,%ecx
80104aeb:	8b 45 0c             	mov    0xc(%ebp),%eax
80104aee:	c1 e0 10             	shl    $0x10,%eax
80104af1:	09 c1                	or     %eax,%ecx
80104af3:	8b 45 0c             	mov    0xc(%ebp),%eax
80104af6:	c1 e0 08             	shl    $0x8,%eax
80104af9:	09 c8                	or     %ecx,%eax
80104afb:	0b 45 0c             	or     0xc(%ebp),%eax
80104afe:	52                   	push   %edx
80104aff:	50                   	push   %eax
80104b00:	ff 75 08             	push   0x8(%ebp)
80104b03:	e8 8f ff ff ff       	call   80104a97 <stosl>
80104b08:	83 c4 0c             	add    $0xc,%esp
80104b0b:	eb 12                	jmp    80104b1f <memset+0x62>
80104b0d:	8b 45 10             	mov    0x10(%ebp),%eax
80104b10:	50                   	push   %eax
80104b11:	ff 75 0c             	push   0xc(%ebp)
80104b14:	ff 75 08             	push   0x8(%ebp)
80104b17:	e8 55 ff ff ff       	call   80104a71 <stosb>
80104b1c:	83 c4 0c             	add    $0xc,%esp
80104b1f:	8b 45 08             	mov    0x8(%ebp),%eax
80104b22:	c9                   	leave  
80104b23:	c3                   	ret    

80104b24 <memcmp>:
80104b24:	55                   	push   %ebp
80104b25:	89 e5                	mov    %esp,%ebp
80104b27:	83 ec 10             	sub    $0x10,%esp
80104b2a:	8b 45 08             	mov    0x8(%ebp),%eax
80104b2d:	89 45 fc             	mov    %eax,-0x4(%ebp)
80104b30:	8b 45 0c             	mov    0xc(%ebp),%eax
80104b33:	89 45 f8             	mov    %eax,-0x8(%ebp)
80104b36:	eb 30                	jmp    80104b68 <memcmp+0x44>
80104b38:	8b 45 fc             	mov    -0x4(%ebp),%eax
80104b3b:	0f b6 10             	movzbl (%eax),%edx
80104b3e:	8b 45 f8             	mov    -0x8(%ebp),%eax
80104b41:	0f b6 00             	movzbl (%eax),%eax
80104b44:	38 c2                	cmp    %al,%dl
80104b46:	74 18                	je     80104b60 <memcmp+0x3c>
80104b48:	8b 45 fc             	mov    -0x4(%ebp),%eax
80104b4b:	0f b6 00             	movzbl (%eax),%eax
80104b4e:	0f b6 d0             	movzbl %al,%edx
80104b51:	8b 45 f8             	mov    -0x8(%ebp),%eax
80104b54:	0f b6 00             	movzbl (%eax),%eax
80104b57:	0f b6 c8             	movzbl %al,%ecx
80104b5a:	89 d0                	mov    %edx,%eax
80104b5c:	29 c8                	sub    %ecx,%eax
80104b5e:	eb 1a                	jmp    80104b7a <memcmp+0x56>
80104b60:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
80104b64:	83 45 f8 01          	addl   $0x1,-0x8(%ebp)
80104b68:	8b 45 10             	mov    0x10(%ebp),%eax
80104b6b:	8d 50 ff             	lea    -0x1(%eax),%edx
80104b6e:	89 55 10             	mov    %edx,0x10(%ebp)
80104b71:	85 c0                	test   %eax,%eax
80104b73:	75 c3                	jne    80104b38 <memcmp+0x14>
80104b75:	b8 00 00 00 00       	mov    $0x0,%eax
80104b7a:	c9                   	leave  
80104b7b:	c3                   	ret    

80104b7c <memmove>:
80104b7c:	55                   	push   %ebp
80104b7d:	89 e5                	mov    %esp,%ebp
80104b7f:	83 ec 10             	sub    $0x10,%esp
80104b82:	8b 45 0c             	mov    0xc(%ebp),%eax
80104b85:	89 45 fc             	mov    %eax,-0x4(%ebp)
80104b88:	8b 45 08             	mov    0x8(%ebp),%eax
80104b8b:	89 45 f8             	mov    %eax,-0x8(%ebp)
80104b8e:	8b 45 fc             	mov    -0x4(%ebp),%eax
80104b91:	3b 45 f8             	cmp    -0x8(%ebp),%eax
80104b94:	73 54                	jae    80104bea <memmove+0x6e>
80104b96:	8b 55 fc             	mov    -0x4(%ebp),%edx
80104b99:	8b 45 10             	mov    0x10(%ebp),%eax
80104b9c:	01 d0                	add    %edx,%eax
80104b9e:	39 45 f8             	cmp    %eax,-0x8(%ebp)
80104ba1:	73 47                	jae    80104bea <memmove+0x6e>
80104ba3:	8b 45 10             	mov    0x10(%ebp),%eax
80104ba6:	01 45 fc             	add    %eax,-0x4(%ebp)
80104ba9:	8b 45 10             	mov    0x10(%ebp),%eax
80104bac:	01 45 f8             	add    %eax,-0x8(%ebp)
80104baf:	eb 13                	jmp    80104bc4 <memmove+0x48>
80104bb1:	83 6d fc 01          	subl   $0x1,-0x4(%ebp)
80104bb5:	83 6d f8 01          	subl   $0x1,-0x8(%ebp)
80104bb9:	8b 45 fc             	mov    -0x4(%ebp),%eax
80104bbc:	0f b6 10             	movzbl (%eax),%edx
80104bbf:	8b 45 f8             	mov    -0x8(%ebp),%eax
80104bc2:	88 10                	mov    %dl,(%eax)
80104bc4:	8b 45 10             	mov    0x10(%ebp),%eax
80104bc7:	8d 50 ff             	lea    -0x1(%eax),%edx
80104bca:	89 55 10             	mov    %edx,0x10(%ebp)
80104bcd:	85 c0                	test   %eax,%eax
80104bcf:	75 e0                	jne    80104bb1 <memmove+0x35>
80104bd1:	eb 24                	jmp    80104bf7 <memmove+0x7b>
80104bd3:	8b 55 fc             	mov    -0x4(%ebp),%edx
80104bd6:	8d 42 01             	lea    0x1(%edx),%eax
80104bd9:	89 45 fc             	mov    %eax,-0x4(%ebp)
80104bdc:	8b 45 f8             	mov    -0x8(%ebp),%eax
80104bdf:	8d 48 01             	lea    0x1(%eax),%ecx
80104be2:	89 4d f8             	mov    %ecx,-0x8(%ebp)
80104be5:	0f b6 12             	movzbl (%edx),%edx
80104be8:	88 10                	mov    %dl,(%eax)
80104bea:	8b 45 10             	mov    0x10(%ebp),%eax
80104bed:	8d 50 ff             	lea    -0x1(%eax),%edx
80104bf0:	89 55 10             	mov    %edx,0x10(%ebp)
80104bf3:	85 c0                	test   %eax,%eax
80104bf5:	75 dc                	jne    80104bd3 <memmove+0x57>
80104bf7:	8b 45 08             	mov    0x8(%ebp),%eax
80104bfa:	c9                   	leave  
80104bfb:	c3                   	ret    

80104bfc <memcpy>:
80104bfc:	55                   	push   %ebp
80104bfd:	89 e5                	mov    %esp,%ebp
80104bff:	ff 75 10             	push   0x10(%ebp)
80104c02:	ff 75 0c             	push   0xc(%ebp)
80104c05:	ff 75 08             	push   0x8(%ebp)
80104c08:	e8 6f ff ff ff       	call   80104b7c <memmove>
80104c0d:	83 c4 0c             	add    $0xc,%esp
80104c10:	c9                   	leave  
80104c11:	c3                   	ret    

80104c12 <strncmp>:
80104c12:	55                   	push   %ebp
80104c13:	89 e5                	mov    %esp,%ebp
80104c15:	eb 0c                	jmp    80104c23 <strncmp+0x11>
80104c17:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
80104c1b:	83 45 08 01          	addl   $0x1,0x8(%ebp)
80104c1f:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
80104c23:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
80104c27:	74 1a                	je     80104c43 <strncmp+0x31>
80104c29:	8b 45 08             	mov    0x8(%ebp),%eax
80104c2c:	0f b6 00             	movzbl (%eax),%eax
80104c2f:	84 c0                	test   %al,%al
80104c31:	74 10                	je     80104c43 <strncmp+0x31>
80104c33:	8b 45 08             	mov    0x8(%ebp),%eax
80104c36:	0f b6 10             	movzbl (%eax),%edx
80104c39:	8b 45 0c             	mov    0xc(%ebp),%eax
80104c3c:	0f b6 00             	movzbl (%eax),%eax
80104c3f:	38 c2                	cmp    %al,%dl
80104c41:	74 d4                	je     80104c17 <strncmp+0x5>
80104c43:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
80104c47:	75 07                	jne    80104c50 <strncmp+0x3e>
80104c49:	b8 00 00 00 00       	mov    $0x0,%eax
80104c4e:	eb 16                	jmp    80104c66 <strncmp+0x54>
80104c50:	8b 45 08             	mov    0x8(%ebp),%eax
80104c53:	0f b6 00             	movzbl (%eax),%eax
80104c56:	0f b6 d0             	movzbl %al,%edx
80104c59:	8b 45 0c             	mov    0xc(%ebp),%eax
80104c5c:	0f b6 00             	movzbl (%eax),%eax
80104c5f:	0f b6 c8             	movzbl %al,%ecx
80104c62:	89 d0                	mov    %edx,%eax
80104c64:	29 c8                	sub    %ecx,%eax
80104c66:	5d                   	pop    %ebp
80104c67:	c3                   	ret    

80104c68 <strncpy>:
80104c68:	55                   	push   %ebp
80104c69:	89 e5                	mov    %esp,%ebp
80104c6b:	83 ec 10             	sub    $0x10,%esp
80104c6e:	8b 45 08             	mov    0x8(%ebp),%eax
80104c71:	89 45 fc             	mov    %eax,-0x4(%ebp)
80104c74:	90                   	nop
80104c75:	8b 45 10             	mov    0x10(%ebp),%eax
80104c78:	8d 50 ff             	lea    -0x1(%eax),%edx
80104c7b:	89 55 10             	mov    %edx,0x10(%ebp)
80104c7e:	85 c0                	test   %eax,%eax
80104c80:	7e 2c                	jle    80104cae <strncpy+0x46>
80104c82:	8b 55 0c             	mov    0xc(%ebp),%edx
80104c85:	8d 42 01             	lea    0x1(%edx),%eax
80104c88:	89 45 0c             	mov    %eax,0xc(%ebp)
80104c8b:	8b 45 08             	mov    0x8(%ebp),%eax
80104c8e:	8d 48 01             	lea    0x1(%eax),%ecx
80104c91:	89 4d 08             	mov    %ecx,0x8(%ebp)
80104c94:	0f b6 12             	movzbl (%edx),%edx
80104c97:	88 10                	mov    %dl,(%eax)
80104c99:	0f b6 00             	movzbl (%eax),%eax
80104c9c:	84 c0                	test   %al,%al
80104c9e:	75 d5                	jne    80104c75 <strncpy+0xd>
80104ca0:	eb 0c                	jmp    80104cae <strncpy+0x46>
80104ca2:	8b 45 08             	mov    0x8(%ebp),%eax
80104ca5:	8d 50 01             	lea    0x1(%eax),%edx
80104ca8:	89 55 08             	mov    %edx,0x8(%ebp)
80104cab:	c6 00 00             	movb   $0x0,(%eax)
80104cae:	8b 45 10             	mov    0x10(%ebp),%eax
80104cb1:	8d 50 ff             	lea    -0x1(%eax),%edx
80104cb4:	89 55 10             	mov    %edx,0x10(%ebp)
80104cb7:	85 c0                	test   %eax,%eax
80104cb9:	7f e7                	jg     80104ca2 <strncpy+0x3a>
80104cbb:	8b 45 fc             	mov    -0x4(%ebp),%eax
80104cbe:	c9                   	leave  
80104cbf:	c3                   	ret    

80104cc0 <safestrcpy>:
80104cc0:	55                   	push   %ebp
80104cc1:	89 e5                	mov    %esp,%ebp
80104cc3:	83 ec 10             	sub    $0x10,%esp
80104cc6:	8b 45 08             	mov    0x8(%ebp),%eax
80104cc9:	89 45 fc             	mov    %eax,-0x4(%ebp)
80104ccc:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
80104cd0:	7f 05                	jg     80104cd7 <safestrcpy+0x17>
80104cd2:	8b 45 fc             	mov    -0x4(%ebp),%eax
80104cd5:	eb 32                	jmp    80104d09 <safestrcpy+0x49>
80104cd7:	90                   	nop
80104cd8:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
80104cdc:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
80104ce0:	7e 1e                	jle    80104d00 <safestrcpy+0x40>
80104ce2:	8b 55 0c             	mov    0xc(%ebp),%edx
80104ce5:	8d 42 01             	lea    0x1(%edx),%eax
80104ce8:	89 45 0c             	mov    %eax,0xc(%ebp)
80104ceb:	8b 45 08             	mov    0x8(%ebp),%eax
80104cee:	8d 48 01             	lea    0x1(%eax),%ecx
80104cf1:	89 4d 08             	mov    %ecx,0x8(%ebp)
80104cf4:	0f b6 12             	movzbl (%edx),%edx
80104cf7:	88 10                	mov    %dl,(%eax)
80104cf9:	0f b6 00             	movzbl (%eax),%eax
80104cfc:	84 c0                	test   %al,%al
80104cfe:	75 d8                	jne    80104cd8 <safestrcpy+0x18>
80104d00:	8b 45 08             	mov    0x8(%ebp),%eax
80104d03:	c6 00 00             	movb   $0x0,(%eax)
80104d06:	8b 45 fc             	mov    -0x4(%ebp),%eax
80104d09:	c9                   	leave  
80104d0a:	c3                   	ret    

80104d0b <strlen>:
80104d0b:	55                   	push   %ebp
80104d0c:	89 e5                	mov    %esp,%ebp
80104d0e:	83 ec 10             	sub    $0x10,%esp
80104d11:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
80104d18:	eb 04                	jmp    80104d1e <strlen+0x13>
80104d1a:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
80104d1e:	8b 55 fc             	mov    -0x4(%ebp),%edx
80104d21:	8b 45 08             	mov    0x8(%ebp),%eax
80104d24:	01 d0                	add    %edx,%eax
80104d26:	0f b6 00             	movzbl (%eax),%eax
80104d29:	84 c0                	test   %al,%al
80104d2b:	75 ed                	jne    80104d1a <strlen+0xf>
80104d2d:	8b 45 fc             	mov    -0x4(%ebp),%eax
80104d30:	c9                   	leave  
80104d31:	c3                   	ret    

80104d32 <swtch>:
80104d32:	8b 44 24 04          	mov    0x4(%esp),%eax
80104d36:	8b 54 24 08          	mov    0x8(%esp),%edx
80104d3a:	55                   	push   %ebp
80104d3b:	53                   	push   %ebx
80104d3c:	56                   	push   %esi
80104d3d:	57                   	push   %edi
80104d3e:	89 20                	mov    %esp,(%eax)
80104d40:	89 d4                	mov    %edx,%esp
80104d42:	5f                   	pop    %edi
80104d43:	5e                   	pop    %esi
80104d44:	5b                   	pop    %ebx
80104d45:	5d                   	pop    %ebp
80104d46:	c3                   	ret    

80104d47 <fetchint>:


// Fetch the int at addr from the current process.
int
fetchint(uint addr, int *ip)
{
80104d47:	55                   	push   %ebp
80104d48:	89 e5                	mov    %esp,%ebp
80104d4a:	83 ec 18             	sub    $0x18,%esp
  struct proc *curproc = myproc();
80104d4d:	e8 31 ee ff ff       	call   80103b83 <myproc>
80104d52:	89 45 f4             	mov    %eax,-0xc(%ebp)

  if(addr >= curproc->sz || addr+4 > curproc->sz)
80104d55:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104d58:	8b 00                	mov    (%eax),%eax
80104d5a:	39 45 08             	cmp    %eax,0x8(%ebp)
80104d5d:	73 0f                	jae    80104d6e <fetchint+0x27>
80104d5f:	8b 45 08             	mov    0x8(%ebp),%eax
80104d62:	8d 50 04             	lea    0x4(%eax),%edx
80104d65:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104d68:	8b 00                	mov    (%eax),%eax
80104d6a:	39 c2                	cmp    %eax,%edx
80104d6c:	76 07                	jbe    80104d75 <fetchint+0x2e>
    return -1;
80104d6e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104d73:	eb 0f                	jmp    80104d84 <fetchint+0x3d>
  *ip = *(int*)(addr);
80104d75:	8b 45 08             	mov    0x8(%ebp),%eax
80104d78:	8b 10                	mov    (%eax),%edx
80104d7a:	8b 45 0c             	mov    0xc(%ebp),%eax
80104d7d:	89 10                	mov    %edx,(%eax)
  return 0;
80104d7f:	b8 00 00 00 00       	mov    $0x0,%eax
}
80104d84:	c9                   	leave  
80104d85:	c3                   	ret    

80104d86 <fetchstr>:
// Fetch the nul-terminated string at addr from the current process.
// Doesn't actually copy the string - just sets *pp to point at it.
// Returns length of string, not including nul.
int
fetchstr(uint addr, char **pp)
{
80104d86:	55                   	push   %ebp
80104d87:	89 e5                	mov    %esp,%ebp
80104d89:	83 ec 18             	sub    $0x18,%esp
  char *s, *ep;
  struct proc *curproc = myproc();
80104d8c:	e8 f2 ed ff ff       	call   80103b83 <myproc>
80104d91:	89 45 f0             	mov    %eax,-0x10(%ebp)

  if(addr >= curproc->sz)
80104d94:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104d97:	8b 00                	mov    (%eax),%eax
80104d99:	39 45 08             	cmp    %eax,0x8(%ebp)
80104d9c:	72 07                	jb     80104da5 <fetchstr+0x1f>
    return -1;
80104d9e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104da3:	eb 41                	jmp    80104de6 <fetchstr+0x60>
  *pp = (char*)addr;
80104da5:	8b 55 08             	mov    0x8(%ebp),%edx
80104da8:	8b 45 0c             	mov    0xc(%ebp),%eax
80104dab:	89 10                	mov    %edx,(%eax)
  ep = (char*)curproc->sz;
80104dad:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104db0:	8b 00                	mov    (%eax),%eax
80104db2:	89 45 ec             	mov    %eax,-0x14(%ebp)
  for(s = *pp; s < ep; s++){
80104db5:	8b 45 0c             	mov    0xc(%ebp),%eax
80104db8:	8b 00                	mov    (%eax),%eax
80104dba:	89 45 f4             	mov    %eax,-0xc(%ebp)
80104dbd:	eb 1a                	jmp    80104dd9 <fetchstr+0x53>
    if(*s == 0)
80104dbf:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104dc2:	0f b6 00             	movzbl (%eax),%eax
80104dc5:	84 c0                	test   %al,%al
80104dc7:	75 0c                	jne    80104dd5 <fetchstr+0x4f>
      return s - *pp;
80104dc9:	8b 45 0c             	mov    0xc(%ebp),%eax
80104dcc:	8b 10                	mov    (%eax),%edx
80104dce:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104dd1:	29 d0                	sub    %edx,%eax
80104dd3:	eb 11                	jmp    80104de6 <fetchstr+0x60>
  for(s = *pp; s < ep; s++){
80104dd5:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80104dd9:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104ddc:	3b 45 ec             	cmp    -0x14(%ebp),%eax
80104ddf:	72 de                	jb     80104dbf <fetchstr+0x39>
  }
  return -1;
80104de1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104de6:	c9                   	leave  
80104de7:	c3                   	ret    

80104de8 <argint>:

// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
80104de8:	55                   	push   %ebp
80104de9:	89 e5                	mov    %esp,%ebp
80104deb:	83 ec 08             	sub    $0x8,%esp
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80104dee:	e8 90 ed ff ff       	call   80103b83 <myproc>
80104df3:	8b 40 18             	mov    0x18(%eax),%eax
80104df6:	8b 50 44             	mov    0x44(%eax),%edx
80104df9:	8b 45 08             	mov    0x8(%ebp),%eax
80104dfc:	c1 e0 02             	shl    $0x2,%eax
80104dff:	01 d0                	add    %edx,%eax
80104e01:	83 c0 04             	add    $0x4,%eax
80104e04:	83 ec 08             	sub    $0x8,%esp
80104e07:	ff 75 0c             	push   0xc(%ebp)
80104e0a:	50                   	push   %eax
80104e0b:	e8 37 ff ff ff       	call   80104d47 <fetchint>
80104e10:	83 c4 10             	add    $0x10,%esp
}
80104e13:	c9                   	leave  
80104e14:	c3                   	ret    

80104e15 <argptr>:
// Fetch the nth word-sized system call argument as a pointer
// to a block of memory of size bytes.  Check that the pointer
// lies within the process address space.
int
argptr(int n, char **pp, int size)
{
80104e15:	55                   	push   %ebp
80104e16:	89 e5                	mov    %esp,%ebp
80104e18:	83 ec 18             	sub    $0x18,%esp
  int i;
  struct proc *curproc = myproc();
80104e1b:	e8 63 ed ff ff       	call   80103b83 <myproc>
80104e20:	89 45 f4             	mov    %eax,-0xc(%ebp)
 
  if(argint(n, &i) < 0)
80104e23:	83 ec 08             	sub    $0x8,%esp
80104e26:	8d 45 f0             	lea    -0x10(%ebp),%eax
80104e29:	50                   	push   %eax
80104e2a:	ff 75 08             	push   0x8(%ebp)
80104e2d:	e8 b6 ff ff ff       	call   80104de8 <argint>
80104e32:	83 c4 10             	add    $0x10,%esp
80104e35:	85 c0                	test   %eax,%eax
80104e37:	79 07                	jns    80104e40 <argptr+0x2b>
    return -1;
80104e39:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104e3e:	eb 3b                	jmp    80104e7b <argptr+0x66>
  if(size < 0 || (uint)i >= curproc->sz || (uint)i+size > curproc->sz)
80104e40:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
80104e44:	78 1f                	js     80104e65 <argptr+0x50>
80104e46:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104e49:	8b 00                	mov    (%eax),%eax
80104e4b:	8b 55 f0             	mov    -0x10(%ebp),%edx
80104e4e:	39 d0                	cmp    %edx,%eax
80104e50:	76 13                	jbe    80104e65 <argptr+0x50>
80104e52:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104e55:	89 c2                	mov    %eax,%edx
80104e57:	8b 45 10             	mov    0x10(%ebp),%eax
80104e5a:	01 c2                	add    %eax,%edx
80104e5c:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104e5f:	8b 00                	mov    (%eax),%eax
80104e61:	39 c2                	cmp    %eax,%edx
80104e63:	76 07                	jbe    80104e6c <argptr+0x57>
    return -1;
80104e65:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104e6a:	eb 0f                	jmp    80104e7b <argptr+0x66>
  *pp = (char*)i;
80104e6c:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104e6f:	89 c2                	mov    %eax,%edx
80104e71:	8b 45 0c             	mov    0xc(%ebp),%eax
80104e74:	89 10                	mov    %edx,(%eax)
  return 0;
80104e76:	b8 00 00 00 00       	mov    $0x0,%eax
}
80104e7b:	c9                   	leave  
80104e7c:	c3                   	ret    

80104e7d <argstr>:
// Check that the pointer is valid and the string is nul-terminated.
// (There is no shared writable memory, so the string can't change
// between this check and being used by the kernel.)
int
argstr(int n, char **pp)
{
80104e7d:	55                   	push   %ebp
80104e7e:	89 e5                	mov    %esp,%ebp
80104e80:	83 ec 18             	sub    $0x18,%esp
  int addr;
  if(argint(n, &addr) < 0)
80104e83:	83 ec 08             	sub    $0x8,%esp
80104e86:	8d 45 f4             	lea    -0xc(%ebp),%eax
80104e89:	50                   	push   %eax
80104e8a:	ff 75 08             	push   0x8(%ebp)
80104e8d:	e8 56 ff ff ff       	call   80104de8 <argint>
80104e92:	83 c4 10             	add    $0x10,%esp
80104e95:	85 c0                	test   %eax,%eax
80104e97:	79 07                	jns    80104ea0 <argstr+0x23>
    return -1;
80104e99:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104e9e:	eb 12                	jmp    80104eb2 <argstr+0x35>
  return fetchstr(addr, pp);
80104ea0:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104ea3:	83 ec 08             	sub    $0x8,%esp
80104ea6:	ff 75 0c             	push   0xc(%ebp)
80104ea9:	50                   	push   %eax
80104eaa:	e8 d7 fe ff ff       	call   80104d86 <fetchstr>
80104eaf:	83 c4 10             	add    $0x10,%esp
}
80104eb2:	c9                   	leave  
80104eb3:	c3                   	ret    

80104eb4 <syscall>:
[SYS_printpt]  sys_printpt
};

void
syscall(void)
{
80104eb4:	55                   	push   %ebp
80104eb5:	89 e5                	mov    %esp,%ebp
80104eb7:	83 ec 18             	sub    $0x18,%esp
  int num;
  struct proc *curproc = myproc();
80104eba:	e8 c4 ec ff ff       	call   80103b83 <myproc>
80104ebf:	89 45 f4             	mov    %eax,-0xc(%ebp)

  num = curproc->tf->eax;
80104ec2:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104ec5:	8b 40 18             	mov    0x18(%eax),%eax
80104ec8:	8b 40 1c             	mov    0x1c(%eax),%eax
80104ecb:	89 45 f0             	mov    %eax,-0x10(%ebp)
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
80104ece:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80104ed2:	7e 2f                	jle    80104f03 <syscall+0x4f>
80104ed4:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104ed7:	83 f8 16             	cmp    $0x16,%eax
80104eda:	77 27                	ja     80104f03 <syscall+0x4f>
80104edc:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104edf:	8b 04 85 20 f0 10 80 	mov    -0x7fef0fe0(,%eax,4),%eax
80104ee6:	85 c0                	test   %eax,%eax
80104ee8:	74 19                	je     80104f03 <syscall+0x4f>
    curproc->tf->eax = syscalls[num]();
80104eea:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104eed:	8b 04 85 20 f0 10 80 	mov    -0x7fef0fe0(,%eax,4),%eax
80104ef4:	ff d0                	call   *%eax
80104ef6:	89 c2                	mov    %eax,%edx
80104ef8:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104efb:	8b 40 18             	mov    0x18(%eax),%eax
80104efe:	89 50 1c             	mov    %edx,0x1c(%eax)
80104f01:	eb 2c                	jmp    80104f2f <syscall+0x7b>
  } else {
    cprintf("%d %s: unknown sys call %d\n",
            curproc->pid, curproc->name, num);
80104f03:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104f06:	8d 50 6c             	lea    0x6c(%eax),%edx
    cprintf("%d %s: unknown sys call %d\n",
80104f09:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104f0c:	8b 40 10             	mov    0x10(%eax),%eax
80104f0f:	ff 75 f0             	push   -0x10(%ebp)
80104f12:	52                   	push   %edx
80104f13:	50                   	push   %eax
80104f14:	68 f4 a4 10 80       	push   $0x8010a4f4
80104f19:	e8 d6 b4 ff ff       	call   801003f4 <cprintf>
80104f1e:	83 c4 10             	add    $0x10,%esp
    curproc->tf->eax = -1;
80104f21:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104f24:	8b 40 18             	mov    0x18(%eax),%eax
80104f27:	c7 40 1c ff ff ff ff 	movl   $0xffffffff,0x1c(%eax)
  }
}
80104f2e:	90                   	nop
80104f2f:	90                   	nop
80104f30:	c9                   	leave  
80104f31:	c3                   	ret    

80104f32 <argfd>:

// Fetch the nth word-sized system call argument as a file descriptor
// and return both the descriptor and the corresponding struct file.
static int
argfd(int n, int *pfd, struct file **pf)
{
80104f32:	55                   	push   %ebp
80104f33:	89 e5                	mov    %esp,%ebp
80104f35:	83 ec 18             	sub    $0x18,%esp
  int fd;
  struct file *f;

  if(argint(n, &fd) < 0)
80104f38:	83 ec 08             	sub    $0x8,%esp
80104f3b:	8d 45 f0             	lea    -0x10(%ebp),%eax
80104f3e:	50                   	push   %eax
80104f3f:	ff 75 08             	push   0x8(%ebp)
80104f42:	e8 a1 fe ff ff       	call   80104de8 <argint>
80104f47:	83 c4 10             	add    $0x10,%esp
80104f4a:	85 c0                	test   %eax,%eax
80104f4c:	79 07                	jns    80104f55 <argfd+0x23>
    return -1;
80104f4e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104f53:	eb 4f                	jmp    80104fa4 <argfd+0x72>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
80104f55:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104f58:	85 c0                	test   %eax,%eax
80104f5a:	78 20                	js     80104f7c <argfd+0x4a>
80104f5c:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104f5f:	83 f8 0f             	cmp    $0xf,%eax
80104f62:	7f 18                	jg     80104f7c <argfd+0x4a>
80104f64:	e8 1a ec ff ff       	call   80103b83 <myproc>
80104f69:	8b 55 f0             	mov    -0x10(%ebp),%edx
80104f6c:	83 c2 08             	add    $0x8,%edx
80104f6f:	8b 44 90 08          	mov    0x8(%eax,%edx,4),%eax
80104f73:	89 45 f4             	mov    %eax,-0xc(%ebp)
80104f76:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80104f7a:	75 07                	jne    80104f83 <argfd+0x51>
    return -1;
80104f7c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104f81:	eb 21                	jmp    80104fa4 <argfd+0x72>
  if(pfd)
80104f83:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
80104f87:	74 08                	je     80104f91 <argfd+0x5f>
    *pfd = fd;
80104f89:	8b 55 f0             	mov    -0x10(%ebp),%edx
80104f8c:	8b 45 0c             	mov    0xc(%ebp),%eax
80104f8f:	89 10                	mov    %edx,(%eax)
  if(pf)
80104f91:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
80104f95:	74 08                	je     80104f9f <argfd+0x6d>
    *pf = f;
80104f97:	8b 45 10             	mov    0x10(%ebp),%eax
80104f9a:	8b 55 f4             	mov    -0xc(%ebp),%edx
80104f9d:	89 10                	mov    %edx,(%eax)
  return 0;
80104f9f:	b8 00 00 00 00       	mov    $0x0,%eax
}
80104fa4:	c9                   	leave  
80104fa5:	c3                   	ret    

80104fa6 <fdalloc>:

// Allocate a file descriptor for the given file.
// Takes over file reference from caller on success.
static int
fdalloc(struct file *f)
{
80104fa6:	55                   	push   %ebp
80104fa7:	89 e5                	mov    %esp,%ebp
80104fa9:	83 ec 18             	sub    $0x18,%esp
  int fd;
  struct proc *curproc = myproc();
80104fac:	e8 d2 eb ff ff       	call   80103b83 <myproc>
80104fb1:	89 45 f0             	mov    %eax,-0x10(%ebp)

  for(fd = 0; fd < NOFILE; fd++){
80104fb4:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80104fbb:	eb 2a                	jmp    80104fe7 <fdalloc+0x41>
    if(curproc->ofile[fd] == 0){
80104fbd:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104fc0:	8b 55 f4             	mov    -0xc(%ebp),%edx
80104fc3:	83 c2 08             	add    $0x8,%edx
80104fc6:	8b 44 90 08          	mov    0x8(%eax,%edx,4),%eax
80104fca:	85 c0                	test   %eax,%eax
80104fcc:	75 15                	jne    80104fe3 <fdalloc+0x3d>
      curproc->ofile[fd] = f;
80104fce:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104fd1:	8b 55 f4             	mov    -0xc(%ebp),%edx
80104fd4:	8d 4a 08             	lea    0x8(%edx),%ecx
80104fd7:	8b 55 08             	mov    0x8(%ebp),%edx
80104fda:	89 54 88 08          	mov    %edx,0x8(%eax,%ecx,4)
      return fd;
80104fde:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104fe1:	eb 0f                	jmp    80104ff2 <fdalloc+0x4c>
  for(fd = 0; fd < NOFILE; fd++){
80104fe3:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80104fe7:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
80104feb:	7e d0                	jle    80104fbd <fdalloc+0x17>
    }
  }
  return -1;
80104fed:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104ff2:	c9                   	leave  
80104ff3:	c3                   	ret    

80104ff4 <sys_dup>:

int
sys_dup(void)
{
80104ff4:	55                   	push   %ebp
80104ff5:	89 e5                	mov    %esp,%ebp
80104ff7:	83 ec 18             	sub    $0x18,%esp
  struct file *f;
  int fd;

  if(argfd(0, 0, &f) < 0)
80104ffa:	83 ec 04             	sub    $0x4,%esp
80104ffd:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105000:	50                   	push   %eax
80105001:	6a 00                	push   $0x0
80105003:	6a 00                	push   $0x0
80105005:	e8 28 ff ff ff       	call   80104f32 <argfd>
8010500a:	83 c4 10             	add    $0x10,%esp
8010500d:	85 c0                	test   %eax,%eax
8010500f:	79 07                	jns    80105018 <sys_dup+0x24>
    return -1;
80105011:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105016:	eb 31                	jmp    80105049 <sys_dup+0x55>
  if((fd=fdalloc(f)) < 0)
80105018:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010501b:	83 ec 0c             	sub    $0xc,%esp
8010501e:	50                   	push   %eax
8010501f:	e8 82 ff ff ff       	call   80104fa6 <fdalloc>
80105024:	83 c4 10             	add    $0x10,%esp
80105027:	89 45 f4             	mov    %eax,-0xc(%ebp)
8010502a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
8010502e:	79 07                	jns    80105037 <sys_dup+0x43>
    return -1;
80105030:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105035:	eb 12                	jmp    80105049 <sys_dup+0x55>
  filedup(f);
80105037:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010503a:	83 ec 0c             	sub    $0xc,%esp
8010503d:	50                   	push   %eax
8010503e:	e8 07 c0 ff ff       	call   8010104a <filedup>
80105043:	83 c4 10             	add    $0x10,%esp
  return fd;
80105046:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
80105049:	c9                   	leave  
8010504a:	c3                   	ret    

8010504b <sys_read>:

int
sys_read(void)
{
8010504b:	55                   	push   %ebp
8010504c:	89 e5                	mov    %esp,%ebp
8010504e:	83 ec 18             	sub    $0x18,%esp
  struct file *f;
  int n;
  char *p;

  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80105051:	83 ec 04             	sub    $0x4,%esp
80105054:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105057:	50                   	push   %eax
80105058:	6a 00                	push   $0x0
8010505a:	6a 00                	push   $0x0
8010505c:	e8 d1 fe ff ff       	call   80104f32 <argfd>
80105061:	83 c4 10             	add    $0x10,%esp
80105064:	85 c0                	test   %eax,%eax
80105066:	78 2e                	js     80105096 <sys_read+0x4b>
80105068:	83 ec 08             	sub    $0x8,%esp
8010506b:	8d 45 f0             	lea    -0x10(%ebp),%eax
8010506e:	50                   	push   %eax
8010506f:	6a 02                	push   $0x2
80105071:	e8 72 fd ff ff       	call   80104de8 <argint>
80105076:	83 c4 10             	add    $0x10,%esp
80105079:	85 c0                	test   %eax,%eax
8010507b:	78 19                	js     80105096 <sys_read+0x4b>
8010507d:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105080:	83 ec 04             	sub    $0x4,%esp
80105083:	50                   	push   %eax
80105084:	8d 45 ec             	lea    -0x14(%ebp),%eax
80105087:	50                   	push   %eax
80105088:	6a 01                	push   $0x1
8010508a:	e8 86 fd ff ff       	call   80104e15 <argptr>
8010508f:	83 c4 10             	add    $0x10,%esp
80105092:	85 c0                	test   %eax,%eax
80105094:	79 07                	jns    8010509d <sys_read+0x52>
    return -1;
80105096:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010509b:	eb 17                	jmp    801050b4 <sys_read+0x69>
  return fileread(f, p, n);
8010509d:	8b 4d f0             	mov    -0x10(%ebp),%ecx
801050a0:	8b 55 ec             	mov    -0x14(%ebp),%edx
801050a3:	8b 45 f4             	mov    -0xc(%ebp),%eax
801050a6:	83 ec 04             	sub    $0x4,%esp
801050a9:	51                   	push   %ecx
801050aa:	52                   	push   %edx
801050ab:	50                   	push   %eax
801050ac:	e8 29 c1 ff ff       	call   801011da <fileread>
801050b1:	83 c4 10             	add    $0x10,%esp
}
801050b4:	c9                   	leave  
801050b5:	c3                   	ret    

801050b6 <sys_write>:

int
sys_write(void)
{
801050b6:	55                   	push   %ebp
801050b7:	89 e5                	mov    %esp,%ebp
801050b9:	83 ec 18             	sub    $0x18,%esp
  struct file *f;
  int n;
  char *p;

  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
801050bc:	83 ec 04             	sub    $0x4,%esp
801050bf:	8d 45 f4             	lea    -0xc(%ebp),%eax
801050c2:	50                   	push   %eax
801050c3:	6a 00                	push   $0x0
801050c5:	6a 00                	push   $0x0
801050c7:	e8 66 fe ff ff       	call   80104f32 <argfd>
801050cc:	83 c4 10             	add    $0x10,%esp
801050cf:	85 c0                	test   %eax,%eax
801050d1:	78 2e                	js     80105101 <sys_write+0x4b>
801050d3:	83 ec 08             	sub    $0x8,%esp
801050d6:	8d 45 f0             	lea    -0x10(%ebp),%eax
801050d9:	50                   	push   %eax
801050da:	6a 02                	push   $0x2
801050dc:	e8 07 fd ff ff       	call   80104de8 <argint>
801050e1:	83 c4 10             	add    $0x10,%esp
801050e4:	85 c0                	test   %eax,%eax
801050e6:	78 19                	js     80105101 <sys_write+0x4b>
801050e8:	8b 45 f0             	mov    -0x10(%ebp),%eax
801050eb:	83 ec 04             	sub    $0x4,%esp
801050ee:	50                   	push   %eax
801050ef:	8d 45 ec             	lea    -0x14(%ebp),%eax
801050f2:	50                   	push   %eax
801050f3:	6a 01                	push   $0x1
801050f5:	e8 1b fd ff ff       	call   80104e15 <argptr>
801050fa:	83 c4 10             	add    $0x10,%esp
801050fd:	85 c0                	test   %eax,%eax
801050ff:	79 07                	jns    80105108 <sys_write+0x52>
    return -1;
80105101:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105106:	eb 17                	jmp    8010511f <sys_write+0x69>
  return filewrite(f, p, n);
80105108:	8b 4d f0             	mov    -0x10(%ebp),%ecx
8010510b:	8b 55 ec             	mov    -0x14(%ebp),%edx
8010510e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105111:	83 ec 04             	sub    $0x4,%esp
80105114:	51                   	push   %ecx
80105115:	52                   	push   %edx
80105116:	50                   	push   %eax
80105117:	e8 76 c1 ff ff       	call   80101292 <filewrite>
8010511c:	83 c4 10             	add    $0x10,%esp
}
8010511f:	c9                   	leave  
80105120:	c3                   	ret    

80105121 <sys_close>:

int
sys_close(void)
{
80105121:	55                   	push   %ebp
80105122:	89 e5                	mov    %esp,%ebp
80105124:	83 ec 18             	sub    $0x18,%esp
  int fd;
  struct file *f;

  if(argfd(0, &fd, &f) < 0)
80105127:	83 ec 04             	sub    $0x4,%esp
8010512a:	8d 45 f0             	lea    -0x10(%ebp),%eax
8010512d:	50                   	push   %eax
8010512e:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105131:	50                   	push   %eax
80105132:	6a 00                	push   $0x0
80105134:	e8 f9 fd ff ff       	call   80104f32 <argfd>
80105139:	83 c4 10             	add    $0x10,%esp
8010513c:	85 c0                	test   %eax,%eax
8010513e:	79 07                	jns    80105147 <sys_close+0x26>
    return -1;
80105140:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105145:	eb 27                	jmp    8010516e <sys_close+0x4d>
  myproc()->ofile[fd] = 0;
80105147:	e8 37 ea ff ff       	call   80103b83 <myproc>
8010514c:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010514f:	83 c2 08             	add    $0x8,%edx
80105152:	c7 44 90 08 00 00 00 	movl   $0x0,0x8(%eax,%edx,4)
80105159:	00 
  fileclose(f);
8010515a:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010515d:	83 ec 0c             	sub    $0xc,%esp
80105160:	50                   	push   %eax
80105161:	e8 35 bf ff ff       	call   8010109b <fileclose>
80105166:	83 c4 10             	add    $0x10,%esp
  return 0;
80105169:	b8 00 00 00 00       	mov    $0x0,%eax
}
8010516e:	c9                   	leave  
8010516f:	c3                   	ret    

80105170 <sys_fstat>:

int
sys_fstat(void)
{
80105170:	55                   	push   %ebp
80105171:	89 e5                	mov    %esp,%ebp
80105173:	83 ec 18             	sub    $0x18,%esp
  struct file *f;
  struct stat *st;

  if(argfd(0, 0, &f) < 0 || argptr(1, (void*)&st, sizeof(*st)) < 0)
80105176:	83 ec 04             	sub    $0x4,%esp
80105179:	8d 45 f4             	lea    -0xc(%ebp),%eax
8010517c:	50                   	push   %eax
8010517d:	6a 00                	push   $0x0
8010517f:	6a 00                	push   $0x0
80105181:	e8 ac fd ff ff       	call   80104f32 <argfd>
80105186:	83 c4 10             	add    $0x10,%esp
80105189:	85 c0                	test   %eax,%eax
8010518b:	78 17                	js     801051a4 <sys_fstat+0x34>
8010518d:	83 ec 04             	sub    $0x4,%esp
80105190:	6a 14                	push   $0x14
80105192:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105195:	50                   	push   %eax
80105196:	6a 01                	push   $0x1
80105198:	e8 78 fc ff ff       	call   80104e15 <argptr>
8010519d:	83 c4 10             	add    $0x10,%esp
801051a0:	85 c0                	test   %eax,%eax
801051a2:	79 07                	jns    801051ab <sys_fstat+0x3b>
    return -1;
801051a4:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801051a9:	eb 13                	jmp    801051be <sys_fstat+0x4e>
  return filestat(f, st);
801051ab:	8b 55 f0             	mov    -0x10(%ebp),%edx
801051ae:	8b 45 f4             	mov    -0xc(%ebp),%eax
801051b1:	83 ec 08             	sub    $0x8,%esp
801051b4:	52                   	push   %edx
801051b5:	50                   	push   %eax
801051b6:	e8 c8 bf ff ff       	call   80101183 <filestat>
801051bb:	83 c4 10             	add    $0x10,%esp
}
801051be:	c9                   	leave  
801051bf:	c3                   	ret    

801051c0 <sys_link>:

// Create the path new as a link to the same inode as old.
int
sys_link(void)
{
801051c0:	55                   	push   %ebp
801051c1:	89 e5                	mov    %esp,%ebp
801051c3:	83 ec 28             	sub    $0x28,%esp
  char name[DIRSIZ], *new, *old;
  struct inode *dp, *ip;

  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
801051c6:	83 ec 08             	sub    $0x8,%esp
801051c9:	8d 45 d8             	lea    -0x28(%ebp),%eax
801051cc:	50                   	push   %eax
801051cd:	6a 00                	push   $0x0
801051cf:	e8 a9 fc ff ff       	call   80104e7d <argstr>
801051d4:	83 c4 10             	add    $0x10,%esp
801051d7:	85 c0                	test   %eax,%eax
801051d9:	78 15                	js     801051f0 <sys_link+0x30>
801051db:	83 ec 08             	sub    $0x8,%esp
801051de:	8d 45 dc             	lea    -0x24(%ebp),%eax
801051e1:	50                   	push   %eax
801051e2:	6a 01                	push   $0x1
801051e4:	e8 94 fc ff ff       	call   80104e7d <argstr>
801051e9:	83 c4 10             	add    $0x10,%esp
801051ec:	85 c0                	test   %eax,%eax
801051ee:	79 0a                	jns    801051fa <sys_link+0x3a>
    return -1;
801051f0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801051f5:	e9 68 01 00 00       	jmp    80105362 <sys_link+0x1a2>

  begin_op();
801051fa:	e8 3d de ff ff       	call   8010303c <begin_op>
  if((ip = namei(old)) == 0){
801051ff:	8b 45 d8             	mov    -0x28(%ebp),%eax
80105202:	83 ec 0c             	sub    $0xc,%esp
80105205:	50                   	push   %eax
80105206:	e8 12 d3 ff ff       	call   8010251d <namei>
8010520b:	83 c4 10             	add    $0x10,%esp
8010520e:	89 45 f4             	mov    %eax,-0xc(%ebp)
80105211:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80105215:	75 0f                	jne    80105226 <sys_link+0x66>
    end_op();
80105217:	e8 ac de ff ff       	call   801030c8 <end_op>
    return -1;
8010521c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105221:	e9 3c 01 00 00       	jmp    80105362 <sys_link+0x1a2>
  }

  ilock(ip);
80105226:	83 ec 0c             	sub    $0xc,%esp
80105229:	ff 75 f4             	push   -0xc(%ebp)
8010522c:	e8 b9 c7 ff ff       	call   801019ea <ilock>
80105231:	83 c4 10             	add    $0x10,%esp
  if(ip->type == T_DIR){
80105234:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105237:	0f b7 40 50          	movzwl 0x50(%eax),%eax
8010523b:	66 83 f8 01          	cmp    $0x1,%ax
8010523f:	75 1d                	jne    8010525e <sys_link+0x9e>
    iunlockput(ip);
80105241:	83 ec 0c             	sub    $0xc,%esp
80105244:	ff 75 f4             	push   -0xc(%ebp)
80105247:	e8 cf c9 ff ff       	call   80101c1b <iunlockput>
8010524c:	83 c4 10             	add    $0x10,%esp
    end_op();
8010524f:	e8 74 de ff ff       	call   801030c8 <end_op>
    return -1;
80105254:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105259:	e9 04 01 00 00       	jmp    80105362 <sys_link+0x1a2>
  }

  ip->nlink++;
8010525e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105261:	0f b7 40 56          	movzwl 0x56(%eax),%eax
80105265:	83 c0 01             	add    $0x1,%eax
80105268:	89 c2                	mov    %eax,%edx
8010526a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010526d:	66 89 50 56          	mov    %dx,0x56(%eax)
  iupdate(ip);
80105271:	83 ec 0c             	sub    $0xc,%esp
80105274:	ff 75 f4             	push   -0xc(%ebp)
80105277:	e8 91 c5 ff ff       	call   8010180d <iupdate>
8010527c:	83 c4 10             	add    $0x10,%esp
  iunlock(ip);
8010527f:	83 ec 0c             	sub    $0xc,%esp
80105282:	ff 75 f4             	push   -0xc(%ebp)
80105285:	e8 73 c8 ff ff       	call   80101afd <iunlock>
8010528a:	83 c4 10             	add    $0x10,%esp

  if((dp = nameiparent(new, name)) == 0)
8010528d:	8b 45 dc             	mov    -0x24(%ebp),%eax
80105290:	83 ec 08             	sub    $0x8,%esp
80105293:	8d 55 e2             	lea    -0x1e(%ebp),%edx
80105296:	52                   	push   %edx
80105297:	50                   	push   %eax
80105298:	e8 9c d2 ff ff       	call   80102539 <nameiparent>
8010529d:	83 c4 10             	add    $0x10,%esp
801052a0:	89 45 f0             	mov    %eax,-0x10(%ebp)
801052a3:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
801052a7:	74 71                	je     8010531a <sys_link+0x15a>
    goto bad;
  ilock(dp);
801052a9:	83 ec 0c             	sub    $0xc,%esp
801052ac:	ff 75 f0             	push   -0x10(%ebp)
801052af:	e8 36 c7 ff ff       	call   801019ea <ilock>
801052b4:	83 c4 10             	add    $0x10,%esp
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
801052b7:	8b 45 f0             	mov    -0x10(%ebp),%eax
801052ba:	8b 10                	mov    (%eax),%edx
801052bc:	8b 45 f4             	mov    -0xc(%ebp),%eax
801052bf:	8b 00                	mov    (%eax),%eax
801052c1:	39 c2                	cmp    %eax,%edx
801052c3:	75 1d                	jne    801052e2 <sys_link+0x122>
801052c5:	8b 45 f4             	mov    -0xc(%ebp),%eax
801052c8:	8b 40 04             	mov    0x4(%eax),%eax
801052cb:	83 ec 04             	sub    $0x4,%esp
801052ce:	50                   	push   %eax
801052cf:	8d 45 e2             	lea    -0x1e(%ebp),%eax
801052d2:	50                   	push   %eax
801052d3:	ff 75 f0             	push   -0x10(%ebp)
801052d6:	e8 ab cf ff ff       	call   80102286 <dirlink>
801052db:	83 c4 10             	add    $0x10,%esp
801052de:	85 c0                	test   %eax,%eax
801052e0:	79 10                	jns    801052f2 <sys_link+0x132>
    iunlockput(dp);
801052e2:	83 ec 0c             	sub    $0xc,%esp
801052e5:	ff 75 f0             	push   -0x10(%ebp)
801052e8:	e8 2e c9 ff ff       	call   80101c1b <iunlockput>
801052ed:	83 c4 10             	add    $0x10,%esp
    goto bad;
801052f0:	eb 29                	jmp    8010531b <sys_link+0x15b>
  }
  iunlockput(dp);
801052f2:	83 ec 0c             	sub    $0xc,%esp
801052f5:	ff 75 f0             	push   -0x10(%ebp)
801052f8:	e8 1e c9 ff ff       	call   80101c1b <iunlockput>
801052fd:	83 c4 10             	add    $0x10,%esp
  iput(ip);
80105300:	83 ec 0c             	sub    $0xc,%esp
80105303:	ff 75 f4             	push   -0xc(%ebp)
80105306:	e8 40 c8 ff ff       	call   80101b4b <iput>
8010530b:	83 c4 10             	add    $0x10,%esp

  end_op();
8010530e:	e8 b5 dd ff ff       	call   801030c8 <end_op>

  return 0;
80105313:	b8 00 00 00 00       	mov    $0x0,%eax
80105318:	eb 48                	jmp    80105362 <sys_link+0x1a2>
    goto bad;
8010531a:	90                   	nop

bad:
  ilock(ip);
8010531b:	83 ec 0c             	sub    $0xc,%esp
8010531e:	ff 75 f4             	push   -0xc(%ebp)
80105321:	e8 c4 c6 ff ff       	call   801019ea <ilock>
80105326:	83 c4 10             	add    $0x10,%esp
  ip->nlink--;
80105329:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010532c:	0f b7 40 56          	movzwl 0x56(%eax),%eax
80105330:	83 e8 01             	sub    $0x1,%eax
80105333:	89 c2                	mov    %eax,%edx
80105335:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105338:	66 89 50 56          	mov    %dx,0x56(%eax)
  iupdate(ip);
8010533c:	83 ec 0c             	sub    $0xc,%esp
8010533f:	ff 75 f4             	push   -0xc(%ebp)
80105342:	e8 c6 c4 ff ff       	call   8010180d <iupdate>
80105347:	83 c4 10             	add    $0x10,%esp
  iunlockput(ip);
8010534a:	83 ec 0c             	sub    $0xc,%esp
8010534d:	ff 75 f4             	push   -0xc(%ebp)
80105350:	e8 c6 c8 ff ff       	call   80101c1b <iunlockput>
80105355:	83 c4 10             	add    $0x10,%esp
  end_op();
80105358:	e8 6b dd ff ff       	call   801030c8 <end_op>
  return -1;
8010535d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105362:	c9                   	leave  
80105363:	c3                   	ret    

80105364 <isdirempty>:

// Is the directory dp empty except for "." and ".." ?
static int
isdirempty(struct inode *dp)
{
80105364:	55                   	push   %ebp
80105365:	89 e5                	mov    %esp,%ebp
80105367:	83 ec 28             	sub    $0x28,%esp
  int off;
  struct dirent de;

  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
8010536a:	c7 45 f4 20 00 00 00 	movl   $0x20,-0xc(%ebp)
80105371:	eb 40                	jmp    801053b3 <isdirempty+0x4f>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80105373:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105376:	6a 10                	push   $0x10
80105378:	50                   	push   %eax
80105379:	8d 45 e4             	lea    -0x1c(%ebp),%eax
8010537c:	50                   	push   %eax
8010537d:	ff 75 08             	push   0x8(%ebp)
80105380:	e8 51 cb ff ff       	call   80101ed6 <readi>
80105385:	83 c4 10             	add    $0x10,%esp
80105388:	83 f8 10             	cmp    $0x10,%eax
8010538b:	74 0d                	je     8010539a <isdirempty+0x36>
      panic("isdirempty: readi");
8010538d:	83 ec 0c             	sub    $0xc,%esp
80105390:	68 10 a5 10 80       	push   $0x8010a510
80105395:	e8 0f b2 ff ff       	call   801005a9 <panic>
    if(de.inum != 0)
8010539a:	0f b7 45 e4          	movzwl -0x1c(%ebp),%eax
8010539e:	66 85 c0             	test   %ax,%ax
801053a1:	74 07                	je     801053aa <isdirempty+0x46>
      return 0;
801053a3:	b8 00 00 00 00       	mov    $0x0,%eax
801053a8:	eb 1b                	jmp    801053c5 <isdirempty+0x61>
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
801053aa:	8b 45 f4             	mov    -0xc(%ebp),%eax
801053ad:	83 c0 10             	add    $0x10,%eax
801053b0:	89 45 f4             	mov    %eax,-0xc(%ebp)
801053b3:	8b 45 08             	mov    0x8(%ebp),%eax
801053b6:	8b 50 58             	mov    0x58(%eax),%edx
801053b9:	8b 45 f4             	mov    -0xc(%ebp),%eax
801053bc:	39 c2                	cmp    %eax,%edx
801053be:	77 b3                	ja     80105373 <isdirempty+0xf>
  }
  return 1;
801053c0:	b8 01 00 00 00       	mov    $0x1,%eax
}
801053c5:	c9                   	leave  
801053c6:	c3                   	ret    

801053c7 <sys_unlink>:

//PAGEBREAK!
int
sys_unlink(void)
{
801053c7:	55                   	push   %ebp
801053c8:	89 e5                	mov    %esp,%ebp
801053ca:	83 ec 38             	sub    $0x38,%esp
  struct inode *ip, *dp;
  struct dirent de;
  char name[DIRSIZ], *path;
  uint off;

  if(argstr(0, &path) < 0)
801053cd:	83 ec 08             	sub    $0x8,%esp
801053d0:	8d 45 cc             	lea    -0x34(%ebp),%eax
801053d3:	50                   	push   %eax
801053d4:	6a 00                	push   $0x0
801053d6:	e8 a2 fa ff ff       	call   80104e7d <argstr>
801053db:	83 c4 10             	add    $0x10,%esp
801053de:	85 c0                	test   %eax,%eax
801053e0:	79 0a                	jns    801053ec <sys_unlink+0x25>
    return -1;
801053e2:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801053e7:	e9 bf 01 00 00       	jmp    801055ab <sys_unlink+0x1e4>

  begin_op();
801053ec:	e8 4b dc ff ff       	call   8010303c <begin_op>
  if((dp = nameiparent(path, name)) == 0){
801053f1:	8b 45 cc             	mov    -0x34(%ebp),%eax
801053f4:	83 ec 08             	sub    $0x8,%esp
801053f7:	8d 55 d2             	lea    -0x2e(%ebp),%edx
801053fa:	52                   	push   %edx
801053fb:	50                   	push   %eax
801053fc:	e8 38 d1 ff ff       	call   80102539 <nameiparent>
80105401:	83 c4 10             	add    $0x10,%esp
80105404:	89 45 f4             	mov    %eax,-0xc(%ebp)
80105407:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
8010540b:	75 0f                	jne    8010541c <sys_unlink+0x55>
    end_op();
8010540d:	e8 b6 dc ff ff       	call   801030c8 <end_op>
    return -1;
80105412:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105417:	e9 8f 01 00 00       	jmp    801055ab <sys_unlink+0x1e4>
  }

  ilock(dp);
8010541c:	83 ec 0c             	sub    $0xc,%esp
8010541f:	ff 75 f4             	push   -0xc(%ebp)
80105422:	e8 c3 c5 ff ff       	call   801019ea <ilock>
80105427:	83 c4 10             	add    $0x10,%esp

  // Cannot unlink "." or "..".
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
8010542a:	83 ec 08             	sub    $0x8,%esp
8010542d:	68 22 a5 10 80       	push   $0x8010a522
80105432:	8d 45 d2             	lea    -0x2e(%ebp),%eax
80105435:	50                   	push   %eax
80105436:	e8 76 cd ff ff       	call   801021b1 <namecmp>
8010543b:	83 c4 10             	add    $0x10,%esp
8010543e:	85 c0                	test   %eax,%eax
80105440:	0f 84 49 01 00 00    	je     8010558f <sys_unlink+0x1c8>
80105446:	83 ec 08             	sub    $0x8,%esp
80105449:	68 24 a5 10 80       	push   $0x8010a524
8010544e:	8d 45 d2             	lea    -0x2e(%ebp),%eax
80105451:	50                   	push   %eax
80105452:	e8 5a cd ff ff       	call   801021b1 <namecmp>
80105457:	83 c4 10             	add    $0x10,%esp
8010545a:	85 c0                	test   %eax,%eax
8010545c:	0f 84 2d 01 00 00    	je     8010558f <sys_unlink+0x1c8>
    goto bad;

  if((ip = dirlookup(dp, name, &off)) == 0)
80105462:	83 ec 04             	sub    $0x4,%esp
80105465:	8d 45 c8             	lea    -0x38(%ebp),%eax
80105468:	50                   	push   %eax
80105469:	8d 45 d2             	lea    -0x2e(%ebp),%eax
8010546c:	50                   	push   %eax
8010546d:	ff 75 f4             	push   -0xc(%ebp)
80105470:	e8 57 cd ff ff       	call   801021cc <dirlookup>
80105475:	83 c4 10             	add    $0x10,%esp
80105478:	89 45 f0             	mov    %eax,-0x10(%ebp)
8010547b:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
8010547f:	0f 84 0d 01 00 00    	je     80105592 <sys_unlink+0x1cb>
    goto bad;
  ilock(ip);
80105485:	83 ec 0c             	sub    $0xc,%esp
80105488:	ff 75 f0             	push   -0x10(%ebp)
8010548b:	e8 5a c5 ff ff       	call   801019ea <ilock>
80105490:	83 c4 10             	add    $0x10,%esp

  if(ip->nlink < 1)
80105493:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105496:	0f b7 40 56          	movzwl 0x56(%eax),%eax
8010549a:	66 85 c0             	test   %ax,%ax
8010549d:	7f 0d                	jg     801054ac <sys_unlink+0xe5>
    panic("unlink: nlink < 1");
8010549f:	83 ec 0c             	sub    $0xc,%esp
801054a2:	68 27 a5 10 80       	push   $0x8010a527
801054a7:	e8 fd b0 ff ff       	call   801005a9 <panic>
  if(ip->type == T_DIR && !isdirempty(ip)){
801054ac:	8b 45 f0             	mov    -0x10(%ebp),%eax
801054af:	0f b7 40 50          	movzwl 0x50(%eax),%eax
801054b3:	66 83 f8 01          	cmp    $0x1,%ax
801054b7:	75 25                	jne    801054de <sys_unlink+0x117>
801054b9:	83 ec 0c             	sub    $0xc,%esp
801054bc:	ff 75 f0             	push   -0x10(%ebp)
801054bf:	e8 a0 fe ff ff       	call   80105364 <isdirempty>
801054c4:	83 c4 10             	add    $0x10,%esp
801054c7:	85 c0                	test   %eax,%eax
801054c9:	75 13                	jne    801054de <sys_unlink+0x117>
    iunlockput(ip);
801054cb:	83 ec 0c             	sub    $0xc,%esp
801054ce:	ff 75 f0             	push   -0x10(%ebp)
801054d1:	e8 45 c7 ff ff       	call   80101c1b <iunlockput>
801054d6:	83 c4 10             	add    $0x10,%esp
    goto bad;
801054d9:	e9 b5 00 00 00       	jmp    80105593 <sys_unlink+0x1cc>
  }

  memset(&de, 0, sizeof(de));
801054de:	83 ec 04             	sub    $0x4,%esp
801054e1:	6a 10                	push   $0x10
801054e3:	6a 00                	push   $0x0
801054e5:	8d 45 e0             	lea    -0x20(%ebp),%eax
801054e8:	50                   	push   %eax
801054e9:	e8 cf f5 ff ff       	call   80104abd <memset>
801054ee:	83 c4 10             	add    $0x10,%esp
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
801054f1:	8b 45 c8             	mov    -0x38(%ebp),%eax
801054f4:	6a 10                	push   $0x10
801054f6:	50                   	push   %eax
801054f7:	8d 45 e0             	lea    -0x20(%ebp),%eax
801054fa:	50                   	push   %eax
801054fb:	ff 75 f4             	push   -0xc(%ebp)
801054fe:	e8 28 cb ff ff       	call   8010202b <writei>
80105503:	83 c4 10             	add    $0x10,%esp
80105506:	83 f8 10             	cmp    $0x10,%eax
80105509:	74 0d                	je     80105518 <sys_unlink+0x151>
    panic("unlink: writei");
8010550b:	83 ec 0c             	sub    $0xc,%esp
8010550e:	68 39 a5 10 80       	push   $0x8010a539
80105513:	e8 91 b0 ff ff       	call   801005a9 <panic>
  if(ip->type == T_DIR){
80105518:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010551b:	0f b7 40 50          	movzwl 0x50(%eax),%eax
8010551f:	66 83 f8 01          	cmp    $0x1,%ax
80105523:	75 21                	jne    80105546 <sys_unlink+0x17f>
    dp->nlink--;
80105525:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105528:	0f b7 40 56          	movzwl 0x56(%eax),%eax
8010552c:	83 e8 01             	sub    $0x1,%eax
8010552f:	89 c2                	mov    %eax,%edx
80105531:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105534:	66 89 50 56          	mov    %dx,0x56(%eax)
    iupdate(dp);
80105538:	83 ec 0c             	sub    $0xc,%esp
8010553b:	ff 75 f4             	push   -0xc(%ebp)
8010553e:	e8 ca c2 ff ff       	call   8010180d <iupdate>
80105543:	83 c4 10             	add    $0x10,%esp
  }
  iunlockput(dp);
80105546:	83 ec 0c             	sub    $0xc,%esp
80105549:	ff 75 f4             	push   -0xc(%ebp)
8010554c:	e8 ca c6 ff ff       	call   80101c1b <iunlockput>
80105551:	83 c4 10             	add    $0x10,%esp

  ip->nlink--;
80105554:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105557:	0f b7 40 56          	movzwl 0x56(%eax),%eax
8010555b:	83 e8 01             	sub    $0x1,%eax
8010555e:	89 c2                	mov    %eax,%edx
80105560:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105563:	66 89 50 56          	mov    %dx,0x56(%eax)
  iupdate(ip);
80105567:	83 ec 0c             	sub    $0xc,%esp
8010556a:	ff 75 f0             	push   -0x10(%ebp)
8010556d:	e8 9b c2 ff ff       	call   8010180d <iupdate>
80105572:	83 c4 10             	add    $0x10,%esp
  iunlockput(ip);
80105575:	83 ec 0c             	sub    $0xc,%esp
80105578:	ff 75 f0             	push   -0x10(%ebp)
8010557b:	e8 9b c6 ff ff       	call   80101c1b <iunlockput>
80105580:	83 c4 10             	add    $0x10,%esp

  end_op();
80105583:	e8 40 db ff ff       	call   801030c8 <end_op>

  return 0;
80105588:	b8 00 00 00 00       	mov    $0x0,%eax
8010558d:	eb 1c                	jmp    801055ab <sys_unlink+0x1e4>
    goto bad;
8010558f:	90                   	nop
80105590:	eb 01                	jmp    80105593 <sys_unlink+0x1cc>
    goto bad;
80105592:	90                   	nop

bad:
  iunlockput(dp);
80105593:	83 ec 0c             	sub    $0xc,%esp
80105596:	ff 75 f4             	push   -0xc(%ebp)
80105599:	e8 7d c6 ff ff       	call   80101c1b <iunlockput>
8010559e:	83 c4 10             	add    $0x10,%esp
  end_op();
801055a1:	e8 22 db ff ff       	call   801030c8 <end_op>
  return -1;
801055a6:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801055ab:	c9                   	leave  
801055ac:	c3                   	ret    

801055ad <create>:

static struct inode*
create(char *path, short type, short major, short minor)
{
801055ad:	55                   	push   %ebp
801055ae:	89 e5                	mov    %esp,%ebp
801055b0:	83 ec 38             	sub    $0x38,%esp
801055b3:	8b 4d 0c             	mov    0xc(%ebp),%ecx
801055b6:	8b 55 10             	mov    0x10(%ebp),%edx
801055b9:	8b 45 14             	mov    0x14(%ebp),%eax
801055bc:	66 89 4d d4          	mov    %cx,-0x2c(%ebp)
801055c0:	66 89 55 d0          	mov    %dx,-0x30(%ebp)
801055c4:	66 89 45 cc          	mov    %ax,-0x34(%ebp)
  uint off;
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
801055c8:	83 ec 08             	sub    $0x8,%esp
801055cb:	8d 45 de             	lea    -0x22(%ebp),%eax
801055ce:	50                   	push   %eax
801055cf:	ff 75 08             	push   0x8(%ebp)
801055d2:	e8 62 cf ff ff       	call   80102539 <nameiparent>
801055d7:	83 c4 10             	add    $0x10,%esp
801055da:	89 45 f4             	mov    %eax,-0xc(%ebp)
801055dd:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801055e1:	75 0a                	jne    801055ed <create+0x40>
    return 0;
801055e3:	b8 00 00 00 00       	mov    $0x0,%eax
801055e8:	e9 90 01 00 00       	jmp    8010577d <create+0x1d0>
  ilock(dp);
801055ed:	83 ec 0c             	sub    $0xc,%esp
801055f0:	ff 75 f4             	push   -0xc(%ebp)
801055f3:	e8 f2 c3 ff ff       	call   801019ea <ilock>
801055f8:	83 c4 10             	add    $0x10,%esp

  if((ip = dirlookup(dp, name, &off)) != 0){
801055fb:	83 ec 04             	sub    $0x4,%esp
801055fe:	8d 45 ec             	lea    -0x14(%ebp),%eax
80105601:	50                   	push   %eax
80105602:	8d 45 de             	lea    -0x22(%ebp),%eax
80105605:	50                   	push   %eax
80105606:	ff 75 f4             	push   -0xc(%ebp)
80105609:	e8 be cb ff ff       	call   801021cc <dirlookup>
8010560e:	83 c4 10             	add    $0x10,%esp
80105611:	89 45 f0             	mov    %eax,-0x10(%ebp)
80105614:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80105618:	74 50                	je     8010566a <create+0xbd>
    iunlockput(dp);
8010561a:	83 ec 0c             	sub    $0xc,%esp
8010561d:	ff 75 f4             	push   -0xc(%ebp)
80105620:	e8 f6 c5 ff ff       	call   80101c1b <iunlockput>
80105625:	83 c4 10             	add    $0x10,%esp
    ilock(ip);
80105628:	83 ec 0c             	sub    $0xc,%esp
8010562b:	ff 75 f0             	push   -0x10(%ebp)
8010562e:	e8 b7 c3 ff ff       	call   801019ea <ilock>
80105633:	83 c4 10             	add    $0x10,%esp
    if(type == T_FILE && ip->type == T_FILE)
80105636:	66 83 7d d4 02       	cmpw   $0x2,-0x2c(%ebp)
8010563b:	75 15                	jne    80105652 <create+0xa5>
8010563d:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105640:	0f b7 40 50          	movzwl 0x50(%eax),%eax
80105644:	66 83 f8 02          	cmp    $0x2,%ax
80105648:	75 08                	jne    80105652 <create+0xa5>
      return ip;
8010564a:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010564d:	e9 2b 01 00 00       	jmp    8010577d <create+0x1d0>
    iunlockput(ip);
80105652:	83 ec 0c             	sub    $0xc,%esp
80105655:	ff 75 f0             	push   -0x10(%ebp)
80105658:	e8 be c5 ff ff       	call   80101c1b <iunlockput>
8010565d:	83 c4 10             	add    $0x10,%esp
    return 0;
80105660:	b8 00 00 00 00       	mov    $0x0,%eax
80105665:	e9 13 01 00 00       	jmp    8010577d <create+0x1d0>
  }

  if((ip = ialloc(dp->dev, type)) == 0)
8010566a:	0f bf 55 d4          	movswl -0x2c(%ebp),%edx
8010566e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105671:	8b 00                	mov    (%eax),%eax
80105673:	83 ec 08             	sub    $0x8,%esp
80105676:	52                   	push   %edx
80105677:	50                   	push   %eax
80105678:	e8 b9 c0 ff ff       	call   80101736 <ialloc>
8010567d:	83 c4 10             	add    $0x10,%esp
80105680:	89 45 f0             	mov    %eax,-0x10(%ebp)
80105683:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80105687:	75 0d                	jne    80105696 <create+0xe9>
    panic("create: ialloc");
80105689:	83 ec 0c             	sub    $0xc,%esp
8010568c:	68 48 a5 10 80       	push   $0x8010a548
80105691:	e8 13 af ff ff       	call   801005a9 <panic>

  ilock(ip);
80105696:	83 ec 0c             	sub    $0xc,%esp
80105699:	ff 75 f0             	push   -0x10(%ebp)
8010569c:	e8 49 c3 ff ff       	call   801019ea <ilock>
801056a1:	83 c4 10             	add    $0x10,%esp
  ip->major = major;
801056a4:	8b 45 f0             	mov    -0x10(%ebp),%eax
801056a7:	0f b7 55 d0          	movzwl -0x30(%ebp),%edx
801056ab:	66 89 50 52          	mov    %dx,0x52(%eax)
  ip->minor = minor;
801056af:	8b 45 f0             	mov    -0x10(%ebp),%eax
801056b2:	0f b7 55 cc          	movzwl -0x34(%ebp),%edx
801056b6:	66 89 50 54          	mov    %dx,0x54(%eax)
  ip->nlink = 1;
801056ba:	8b 45 f0             	mov    -0x10(%ebp),%eax
801056bd:	66 c7 40 56 01 00    	movw   $0x1,0x56(%eax)
  iupdate(ip);
801056c3:	83 ec 0c             	sub    $0xc,%esp
801056c6:	ff 75 f0             	push   -0x10(%ebp)
801056c9:	e8 3f c1 ff ff       	call   8010180d <iupdate>
801056ce:	83 c4 10             	add    $0x10,%esp

  if(type == T_DIR){  // Create . and .. entries.
801056d1:	66 83 7d d4 01       	cmpw   $0x1,-0x2c(%ebp)
801056d6:	75 6a                	jne    80105742 <create+0x195>
    dp->nlink++;  // for ".."
801056d8:	8b 45 f4             	mov    -0xc(%ebp),%eax
801056db:	0f b7 40 56          	movzwl 0x56(%eax),%eax
801056df:	83 c0 01             	add    $0x1,%eax
801056e2:	89 c2                	mov    %eax,%edx
801056e4:	8b 45 f4             	mov    -0xc(%ebp),%eax
801056e7:	66 89 50 56          	mov    %dx,0x56(%eax)
    iupdate(dp);
801056eb:	83 ec 0c             	sub    $0xc,%esp
801056ee:	ff 75 f4             	push   -0xc(%ebp)
801056f1:	e8 17 c1 ff ff       	call   8010180d <iupdate>
801056f6:	83 c4 10             	add    $0x10,%esp
    // No ip->nlink++ for ".": avoid cyclic ref count.
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
801056f9:	8b 45 f0             	mov    -0x10(%ebp),%eax
801056fc:	8b 40 04             	mov    0x4(%eax),%eax
801056ff:	83 ec 04             	sub    $0x4,%esp
80105702:	50                   	push   %eax
80105703:	68 22 a5 10 80       	push   $0x8010a522
80105708:	ff 75 f0             	push   -0x10(%ebp)
8010570b:	e8 76 cb ff ff       	call   80102286 <dirlink>
80105710:	83 c4 10             	add    $0x10,%esp
80105713:	85 c0                	test   %eax,%eax
80105715:	78 1e                	js     80105735 <create+0x188>
80105717:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010571a:	8b 40 04             	mov    0x4(%eax),%eax
8010571d:	83 ec 04             	sub    $0x4,%esp
80105720:	50                   	push   %eax
80105721:	68 24 a5 10 80       	push   $0x8010a524
80105726:	ff 75 f0             	push   -0x10(%ebp)
80105729:	e8 58 cb ff ff       	call   80102286 <dirlink>
8010572e:	83 c4 10             	add    $0x10,%esp
80105731:	85 c0                	test   %eax,%eax
80105733:	79 0d                	jns    80105742 <create+0x195>
      panic("create dots");
80105735:	83 ec 0c             	sub    $0xc,%esp
80105738:	68 57 a5 10 80       	push   $0x8010a557
8010573d:	e8 67 ae ff ff       	call   801005a9 <panic>
  }

  if(dirlink(dp, name, ip->inum) < 0)
80105742:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105745:	8b 40 04             	mov    0x4(%eax),%eax
80105748:	83 ec 04             	sub    $0x4,%esp
8010574b:	50                   	push   %eax
8010574c:	8d 45 de             	lea    -0x22(%ebp),%eax
8010574f:	50                   	push   %eax
80105750:	ff 75 f4             	push   -0xc(%ebp)
80105753:	e8 2e cb ff ff       	call   80102286 <dirlink>
80105758:	83 c4 10             	add    $0x10,%esp
8010575b:	85 c0                	test   %eax,%eax
8010575d:	79 0d                	jns    8010576c <create+0x1bf>
    panic("create: dirlink");
8010575f:	83 ec 0c             	sub    $0xc,%esp
80105762:	68 63 a5 10 80       	push   $0x8010a563
80105767:	e8 3d ae ff ff       	call   801005a9 <panic>

  iunlockput(dp);
8010576c:	83 ec 0c             	sub    $0xc,%esp
8010576f:	ff 75 f4             	push   -0xc(%ebp)
80105772:	e8 a4 c4 ff ff       	call   80101c1b <iunlockput>
80105777:	83 c4 10             	add    $0x10,%esp

  return ip;
8010577a:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
8010577d:	c9                   	leave  
8010577e:	c3                   	ret    

8010577f <sys_open>:

int
sys_open(void)
{
8010577f:	55                   	push   %ebp
80105780:	89 e5                	mov    %esp,%ebp
80105782:	83 ec 28             	sub    $0x28,%esp
  char *path;
  int fd, omode;
  struct file *f;
  struct inode *ip;

  if(argstr(0, &path) < 0 || argint(1, &omode) < 0)
80105785:	83 ec 08             	sub    $0x8,%esp
80105788:	8d 45 e8             	lea    -0x18(%ebp),%eax
8010578b:	50                   	push   %eax
8010578c:	6a 00                	push   $0x0
8010578e:	e8 ea f6 ff ff       	call   80104e7d <argstr>
80105793:	83 c4 10             	add    $0x10,%esp
80105796:	85 c0                	test   %eax,%eax
80105798:	78 15                	js     801057af <sys_open+0x30>
8010579a:	83 ec 08             	sub    $0x8,%esp
8010579d:	8d 45 e4             	lea    -0x1c(%ebp),%eax
801057a0:	50                   	push   %eax
801057a1:	6a 01                	push   $0x1
801057a3:	e8 40 f6 ff ff       	call   80104de8 <argint>
801057a8:	83 c4 10             	add    $0x10,%esp
801057ab:	85 c0                	test   %eax,%eax
801057ad:	79 0a                	jns    801057b9 <sys_open+0x3a>
    return -1;
801057af:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801057b4:	e9 61 01 00 00       	jmp    8010591a <sys_open+0x19b>

  begin_op();
801057b9:	e8 7e d8 ff ff       	call   8010303c <begin_op>

  if(omode & O_CREATE){
801057be:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801057c1:	25 00 02 00 00       	and    $0x200,%eax
801057c6:	85 c0                	test   %eax,%eax
801057c8:	74 2a                	je     801057f4 <sys_open+0x75>
    ip = create(path, T_FILE, 0, 0);
801057ca:	8b 45 e8             	mov    -0x18(%ebp),%eax
801057cd:	6a 00                	push   $0x0
801057cf:	6a 00                	push   $0x0
801057d1:	6a 02                	push   $0x2
801057d3:	50                   	push   %eax
801057d4:	e8 d4 fd ff ff       	call   801055ad <create>
801057d9:	83 c4 10             	add    $0x10,%esp
801057dc:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(ip == 0){
801057df:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801057e3:	75 75                	jne    8010585a <sys_open+0xdb>
      end_op();
801057e5:	e8 de d8 ff ff       	call   801030c8 <end_op>
      return -1;
801057ea:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801057ef:	e9 26 01 00 00       	jmp    8010591a <sys_open+0x19b>
    }
  } else {
    if((ip = namei(path)) == 0){
801057f4:	8b 45 e8             	mov    -0x18(%ebp),%eax
801057f7:	83 ec 0c             	sub    $0xc,%esp
801057fa:	50                   	push   %eax
801057fb:	e8 1d cd ff ff       	call   8010251d <namei>
80105800:	83 c4 10             	add    $0x10,%esp
80105803:	89 45 f4             	mov    %eax,-0xc(%ebp)
80105806:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
8010580a:	75 0f                	jne    8010581b <sys_open+0x9c>
      end_op();
8010580c:	e8 b7 d8 ff ff       	call   801030c8 <end_op>
      return -1;
80105811:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105816:	e9 ff 00 00 00       	jmp    8010591a <sys_open+0x19b>
    }
    ilock(ip);
8010581b:	83 ec 0c             	sub    $0xc,%esp
8010581e:	ff 75 f4             	push   -0xc(%ebp)
80105821:	e8 c4 c1 ff ff       	call   801019ea <ilock>
80105826:	83 c4 10             	add    $0x10,%esp
    if(ip->type == T_DIR && omode != O_RDONLY){
80105829:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010582c:	0f b7 40 50          	movzwl 0x50(%eax),%eax
80105830:	66 83 f8 01          	cmp    $0x1,%ax
80105834:	75 24                	jne    8010585a <sys_open+0xdb>
80105836:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80105839:	85 c0                	test   %eax,%eax
8010583b:	74 1d                	je     8010585a <sys_open+0xdb>
      iunlockput(ip);
8010583d:	83 ec 0c             	sub    $0xc,%esp
80105840:	ff 75 f4             	push   -0xc(%ebp)
80105843:	e8 d3 c3 ff ff       	call   80101c1b <iunlockput>
80105848:	83 c4 10             	add    $0x10,%esp
      end_op();
8010584b:	e8 78 d8 ff ff       	call   801030c8 <end_op>
      return -1;
80105850:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105855:	e9 c0 00 00 00       	jmp    8010591a <sys_open+0x19b>
    }
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
8010585a:	e8 7e b7 ff ff       	call   80100fdd <filealloc>
8010585f:	89 45 f0             	mov    %eax,-0x10(%ebp)
80105862:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80105866:	74 17                	je     8010587f <sys_open+0x100>
80105868:	83 ec 0c             	sub    $0xc,%esp
8010586b:	ff 75 f0             	push   -0x10(%ebp)
8010586e:	e8 33 f7 ff ff       	call   80104fa6 <fdalloc>
80105873:	83 c4 10             	add    $0x10,%esp
80105876:	89 45 ec             	mov    %eax,-0x14(%ebp)
80105879:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
8010587d:	79 2e                	jns    801058ad <sys_open+0x12e>
    if(f)
8010587f:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80105883:	74 0e                	je     80105893 <sys_open+0x114>
      fileclose(f);
80105885:	83 ec 0c             	sub    $0xc,%esp
80105888:	ff 75 f0             	push   -0x10(%ebp)
8010588b:	e8 0b b8 ff ff       	call   8010109b <fileclose>
80105890:	83 c4 10             	add    $0x10,%esp
    iunlockput(ip);
80105893:	83 ec 0c             	sub    $0xc,%esp
80105896:	ff 75 f4             	push   -0xc(%ebp)
80105899:	e8 7d c3 ff ff       	call   80101c1b <iunlockput>
8010589e:	83 c4 10             	add    $0x10,%esp
    end_op();
801058a1:	e8 22 d8 ff ff       	call   801030c8 <end_op>
    return -1;
801058a6:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801058ab:	eb 6d                	jmp    8010591a <sys_open+0x19b>
  }
  iunlock(ip);
801058ad:	83 ec 0c             	sub    $0xc,%esp
801058b0:	ff 75 f4             	push   -0xc(%ebp)
801058b3:	e8 45 c2 ff ff       	call   80101afd <iunlock>
801058b8:	83 c4 10             	add    $0x10,%esp
  end_op();
801058bb:	e8 08 d8 ff ff       	call   801030c8 <end_op>

  f->type = FD_INODE;
801058c0:	8b 45 f0             	mov    -0x10(%ebp),%eax
801058c3:	c7 00 02 00 00 00    	movl   $0x2,(%eax)
  f->ip = ip;
801058c9:	8b 45 f0             	mov    -0x10(%ebp),%eax
801058cc:	8b 55 f4             	mov    -0xc(%ebp),%edx
801058cf:	89 50 10             	mov    %edx,0x10(%eax)
  f->off = 0;
801058d2:	8b 45 f0             	mov    -0x10(%ebp),%eax
801058d5:	c7 40 14 00 00 00 00 	movl   $0x0,0x14(%eax)
  f->readable = !(omode & O_WRONLY);
801058dc:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801058df:	83 e0 01             	and    $0x1,%eax
801058e2:	85 c0                	test   %eax,%eax
801058e4:	0f 94 c0             	sete   %al
801058e7:	89 c2                	mov    %eax,%edx
801058e9:	8b 45 f0             	mov    -0x10(%ebp),%eax
801058ec:	88 50 08             	mov    %dl,0x8(%eax)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
801058ef:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801058f2:	83 e0 01             	and    $0x1,%eax
801058f5:	85 c0                	test   %eax,%eax
801058f7:	75 0a                	jne    80105903 <sys_open+0x184>
801058f9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801058fc:	83 e0 02             	and    $0x2,%eax
801058ff:	85 c0                	test   %eax,%eax
80105901:	74 07                	je     8010590a <sys_open+0x18b>
80105903:	b8 01 00 00 00       	mov    $0x1,%eax
80105908:	eb 05                	jmp    8010590f <sys_open+0x190>
8010590a:	b8 00 00 00 00       	mov    $0x0,%eax
8010590f:	89 c2                	mov    %eax,%edx
80105911:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105914:	88 50 09             	mov    %dl,0x9(%eax)
  return fd;
80105917:	8b 45 ec             	mov    -0x14(%ebp),%eax
}
8010591a:	c9                   	leave  
8010591b:	c3                   	ret    

8010591c <sys_mkdir>:

int
sys_mkdir(void)
{
8010591c:	55                   	push   %ebp
8010591d:	89 e5                	mov    %esp,%ebp
8010591f:	83 ec 18             	sub    $0x18,%esp
  char *path;
  struct inode *ip;

  begin_op();
80105922:	e8 15 d7 ff ff       	call   8010303c <begin_op>
  if(argstr(0, &path) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
80105927:	83 ec 08             	sub    $0x8,%esp
8010592a:	8d 45 f0             	lea    -0x10(%ebp),%eax
8010592d:	50                   	push   %eax
8010592e:	6a 00                	push   $0x0
80105930:	e8 48 f5 ff ff       	call   80104e7d <argstr>
80105935:	83 c4 10             	add    $0x10,%esp
80105938:	85 c0                	test   %eax,%eax
8010593a:	78 1b                	js     80105957 <sys_mkdir+0x3b>
8010593c:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010593f:	6a 00                	push   $0x0
80105941:	6a 00                	push   $0x0
80105943:	6a 01                	push   $0x1
80105945:	50                   	push   %eax
80105946:	e8 62 fc ff ff       	call   801055ad <create>
8010594b:	83 c4 10             	add    $0x10,%esp
8010594e:	89 45 f4             	mov    %eax,-0xc(%ebp)
80105951:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80105955:	75 0c                	jne    80105963 <sys_mkdir+0x47>
    end_op();
80105957:	e8 6c d7 ff ff       	call   801030c8 <end_op>
    return -1;
8010595c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105961:	eb 18                	jmp    8010597b <sys_mkdir+0x5f>
  }
  iunlockput(ip);
80105963:	83 ec 0c             	sub    $0xc,%esp
80105966:	ff 75 f4             	push   -0xc(%ebp)
80105969:	e8 ad c2 ff ff       	call   80101c1b <iunlockput>
8010596e:	83 c4 10             	add    $0x10,%esp
  end_op();
80105971:	e8 52 d7 ff ff       	call   801030c8 <end_op>
  return 0;
80105976:	b8 00 00 00 00       	mov    $0x0,%eax
}
8010597b:	c9                   	leave  
8010597c:	c3                   	ret    

8010597d <sys_mknod>:

int
sys_mknod(void)
{
8010597d:	55                   	push   %ebp
8010597e:	89 e5                	mov    %esp,%ebp
80105980:	83 ec 18             	sub    $0x18,%esp
  struct inode *ip;
  char *path;
  int major, minor;

  begin_op();
80105983:	e8 b4 d6 ff ff       	call   8010303c <begin_op>
  if((argstr(0, &path)) < 0 ||
80105988:	83 ec 08             	sub    $0x8,%esp
8010598b:	8d 45 f0             	lea    -0x10(%ebp),%eax
8010598e:	50                   	push   %eax
8010598f:	6a 00                	push   $0x0
80105991:	e8 e7 f4 ff ff       	call   80104e7d <argstr>
80105996:	83 c4 10             	add    $0x10,%esp
80105999:	85 c0                	test   %eax,%eax
8010599b:	78 4f                	js     801059ec <sys_mknod+0x6f>
     argint(1, &major) < 0 ||
8010599d:	83 ec 08             	sub    $0x8,%esp
801059a0:	8d 45 ec             	lea    -0x14(%ebp),%eax
801059a3:	50                   	push   %eax
801059a4:	6a 01                	push   $0x1
801059a6:	e8 3d f4 ff ff       	call   80104de8 <argint>
801059ab:	83 c4 10             	add    $0x10,%esp
  if((argstr(0, &path)) < 0 ||
801059ae:	85 c0                	test   %eax,%eax
801059b0:	78 3a                	js     801059ec <sys_mknod+0x6f>
     argint(2, &minor) < 0 ||
801059b2:	83 ec 08             	sub    $0x8,%esp
801059b5:	8d 45 e8             	lea    -0x18(%ebp),%eax
801059b8:	50                   	push   %eax
801059b9:	6a 02                	push   $0x2
801059bb:	e8 28 f4 ff ff       	call   80104de8 <argint>
801059c0:	83 c4 10             	add    $0x10,%esp
     argint(1, &major) < 0 ||
801059c3:	85 c0                	test   %eax,%eax
801059c5:	78 25                	js     801059ec <sys_mknod+0x6f>
     (ip = create(path, T_DEV, major, minor)) == 0){
801059c7:	8b 45 e8             	mov    -0x18(%ebp),%eax
801059ca:	0f bf c8             	movswl %ax,%ecx
801059cd:	8b 45 ec             	mov    -0x14(%ebp),%eax
801059d0:	0f bf d0             	movswl %ax,%edx
801059d3:	8b 45 f0             	mov    -0x10(%ebp),%eax
801059d6:	51                   	push   %ecx
801059d7:	52                   	push   %edx
801059d8:	6a 03                	push   $0x3
801059da:	50                   	push   %eax
801059db:	e8 cd fb ff ff       	call   801055ad <create>
801059e0:	83 c4 10             	add    $0x10,%esp
801059e3:	89 45 f4             	mov    %eax,-0xc(%ebp)
     argint(2, &minor) < 0 ||
801059e6:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801059ea:	75 0c                	jne    801059f8 <sys_mknod+0x7b>
    end_op();
801059ec:	e8 d7 d6 ff ff       	call   801030c8 <end_op>
    return -1;
801059f1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801059f6:	eb 18                	jmp    80105a10 <sys_mknod+0x93>
  }
  iunlockput(ip);
801059f8:	83 ec 0c             	sub    $0xc,%esp
801059fb:	ff 75 f4             	push   -0xc(%ebp)
801059fe:	e8 18 c2 ff ff       	call   80101c1b <iunlockput>
80105a03:	83 c4 10             	add    $0x10,%esp
  end_op();
80105a06:	e8 bd d6 ff ff       	call   801030c8 <end_op>
  return 0;
80105a0b:	b8 00 00 00 00       	mov    $0x0,%eax
}
80105a10:	c9                   	leave  
80105a11:	c3                   	ret    

80105a12 <sys_chdir>:

int
sys_chdir(void)
{
80105a12:	55                   	push   %ebp
80105a13:	89 e5                	mov    %esp,%ebp
80105a15:	83 ec 18             	sub    $0x18,%esp
  char *path;
  struct inode *ip;
  struct proc *curproc = myproc();
80105a18:	e8 66 e1 ff ff       	call   80103b83 <myproc>
80105a1d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  
  begin_op();
80105a20:	e8 17 d6 ff ff       	call   8010303c <begin_op>
  if(argstr(0, &path) < 0 || (ip = namei(path)) == 0){
80105a25:	83 ec 08             	sub    $0x8,%esp
80105a28:	8d 45 ec             	lea    -0x14(%ebp),%eax
80105a2b:	50                   	push   %eax
80105a2c:	6a 00                	push   $0x0
80105a2e:	e8 4a f4 ff ff       	call   80104e7d <argstr>
80105a33:	83 c4 10             	add    $0x10,%esp
80105a36:	85 c0                	test   %eax,%eax
80105a38:	78 18                	js     80105a52 <sys_chdir+0x40>
80105a3a:	8b 45 ec             	mov    -0x14(%ebp),%eax
80105a3d:	83 ec 0c             	sub    $0xc,%esp
80105a40:	50                   	push   %eax
80105a41:	e8 d7 ca ff ff       	call   8010251d <namei>
80105a46:	83 c4 10             	add    $0x10,%esp
80105a49:	89 45 f0             	mov    %eax,-0x10(%ebp)
80105a4c:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80105a50:	75 0c                	jne    80105a5e <sys_chdir+0x4c>
    end_op();
80105a52:	e8 71 d6 ff ff       	call   801030c8 <end_op>
    return -1;
80105a57:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105a5c:	eb 68                	jmp    80105ac6 <sys_chdir+0xb4>
  }
  ilock(ip);
80105a5e:	83 ec 0c             	sub    $0xc,%esp
80105a61:	ff 75 f0             	push   -0x10(%ebp)
80105a64:	e8 81 bf ff ff       	call   801019ea <ilock>
80105a69:	83 c4 10             	add    $0x10,%esp
  if(ip->type != T_DIR){
80105a6c:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105a6f:	0f b7 40 50          	movzwl 0x50(%eax),%eax
80105a73:	66 83 f8 01          	cmp    $0x1,%ax
80105a77:	74 1a                	je     80105a93 <sys_chdir+0x81>
    iunlockput(ip);
80105a79:	83 ec 0c             	sub    $0xc,%esp
80105a7c:	ff 75 f0             	push   -0x10(%ebp)
80105a7f:	e8 97 c1 ff ff       	call   80101c1b <iunlockput>
80105a84:	83 c4 10             	add    $0x10,%esp
    end_op();
80105a87:	e8 3c d6 ff ff       	call   801030c8 <end_op>
    return -1;
80105a8c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105a91:	eb 33                	jmp    80105ac6 <sys_chdir+0xb4>
  }
  iunlock(ip);
80105a93:	83 ec 0c             	sub    $0xc,%esp
80105a96:	ff 75 f0             	push   -0x10(%ebp)
80105a99:	e8 5f c0 ff ff       	call   80101afd <iunlock>
80105a9e:	83 c4 10             	add    $0x10,%esp
  iput(curproc->cwd);
80105aa1:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105aa4:	8b 40 68             	mov    0x68(%eax),%eax
80105aa7:	83 ec 0c             	sub    $0xc,%esp
80105aaa:	50                   	push   %eax
80105aab:	e8 9b c0 ff ff       	call   80101b4b <iput>
80105ab0:	83 c4 10             	add    $0x10,%esp
  end_op();
80105ab3:	e8 10 d6 ff ff       	call   801030c8 <end_op>
  curproc->cwd = ip;
80105ab8:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105abb:	8b 55 f0             	mov    -0x10(%ebp),%edx
80105abe:	89 50 68             	mov    %edx,0x68(%eax)
  return 0;
80105ac1:	b8 00 00 00 00       	mov    $0x0,%eax
}
80105ac6:	c9                   	leave  
80105ac7:	c3                   	ret    

80105ac8 <sys_exec>:

int
sys_exec(void)
{
80105ac8:	55                   	push   %ebp
80105ac9:	89 e5                	mov    %esp,%ebp
80105acb:	81 ec 98 00 00 00    	sub    $0x98,%esp
  char *path, *argv[MAXARG];
  int i;
  uint uargv, uarg;

  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
80105ad1:	83 ec 08             	sub    $0x8,%esp
80105ad4:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105ad7:	50                   	push   %eax
80105ad8:	6a 00                	push   $0x0
80105ada:	e8 9e f3 ff ff       	call   80104e7d <argstr>
80105adf:	83 c4 10             	add    $0x10,%esp
80105ae2:	85 c0                	test   %eax,%eax
80105ae4:	78 18                	js     80105afe <sys_exec+0x36>
80105ae6:	83 ec 08             	sub    $0x8,%esp
80105ae9:	8d 85 6c ff ff ff    	lea    -0x94(%ebp),%eax
80105aef:	50                   	push   %eax
80105af0:	6a 01                	push   $0x1
80105af2:	e8 f1 f2 ff ff       	call   80104de8 <argint>
80105af7:	83 c4 10             	add    $0x10,%esp
80105afa:	85 c0                	test   %eax,%eax
80105afc:	79 0a                	jns    80105b08 <sys_exec+0x40>
    return -1;
80105afe:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105b03:	e9 c6 00 00 00       	jmp    80105bce <sys_exec+0x106>
  }
  memset(argv, 0, sizeof(argv));
80105b08:	83 ec 04             	sub    $0x4,%esp
80105b0b:	68 80 00 00 00       	push   $0x80
80105b10:	6a 00                	push   $0x0
80105b12:	8d 85 70 ff ff ff    	lea    -0x90(%ebp),%eax
80105b18:	50                   	push   %eax
80105b19:	e8 9f ef ff ff       	call   80104abd <memset>
80105b1e:	83 c4 10             	add    $0x10,%esp
  for(i=0;; i++){
80105b21:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    if(i >= NELEM(argv))
80105b28:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105b2b:	83 f8 1f             	cmp    $0x1f,%eax
80105b2e:	76 0a                	jbe    80105b3a <sys_exec+0x72>
      return -1;
80105b30:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105b35:	e9 94 00 00 00       	jmp    80105bce <sys_exec+0x106>
    if(fetchint(uargv+4*i, (int*)&uarg) < 0)
80105b3a:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105b3d:	c1 e0 02             	shl    $0x2,%eax
80105b40:	89 c2                	mov    %eax,%edx
80105b42:	8b 85 6c ff ff ff    	mov    -0x94(%ebp),%eax
80105b48:	01 c2                	add    %eax,%edx
80105b4a:	83 ec 08             	sub    $0x8,%esp
80105b4d:	8d 85 68 ff ff ff    	lea    -0x98(%ebp),%eax
80105b53:	50                   	push   %eax
80105b54:	52                   	push   %edx
80105b55:	e8 ed f1 ff ff       	call   80104d47 <fetchint>
80105b5a:	83 c4 10             	add    $0x10,%esp
80105b5d:	85 c0                	test   %eax,%eax
80105b5f:	79 07                	jns    80105b68 <sys_exec+0xa0>
      return -1;
80105b61:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105b66:	eb 66                	jmp    80105bce <sys_exec+0x106>
    if(uarg == 0){
80105b68:	8b 85 68 ff ff ff    	mov    -0x98(%ebp),%eax
80105b6e:	85 c0                	test   %eax,%eax
80105b70:	75 27                	jne    80105b99 <sys_exec+0xd1>
      argv[i] = 0;
80105b72:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105b75:	c7 84 85 70 ff ff ff 	movl   $0x0,-0x90(%ebp,%eax,4)
80105b7c:	00 00 00 00 
      break;
80105b80:	90                   	nop
    }
    if(fetchstr(uarg, &argv[i]) < 0)
      return -1;
  }
  return exec(path, argv);
80105b81:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105b84:	83 ec 08             	sub    $0x8,%esp
80105b87:	8d 95 70 ff ff ff    	lea    -0x90(%ebp),%edx
80105b8d:	52                   	push   %edx
80105b8e:	50                   	push   %eax
80105b8f:	e8 ec af ff ff       	call   80100b80 <exec>
80105b94:	83 c4 10             	add    $0x10,%esp
80105b97:	eb 35                	jmp    80105bce <sys_exec+0x106>
    if(fetchstr(uarg, &argv[i]) < 0)
80105b99:	8d 95 70 ff ff ff    	lea    -0x90(%ebp),%edx
80105b9f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105ba2:	c1 e0 02             	shl    $0x2,%eax
80105ba5:	01 c2                	add    %eax,%edx
80105ba7:	8b 85 68 ff ff ff    	mov    -0x98(%ebp),%eax
80105bad:	83 ec 08             	sub    $0x8,%esp
80105bb0:	52                   	push   %edx
80105bb1:	50                   	push   %eax
80105bb2:	e8 cf f1 ff ff       	call   80104d86 <fetchstr>
80105bb7:	83 c4 10             	add    $0x10,%esp
80105bba:	85 c0                	test   %eax,%eax
80105bbc:	79 07                	jns    80105bc5 <sys_exec+0xfd>
      return -1;
80105bbe:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105bc3:	eb 09                	jmp    80105bce <sys_exec+0x106>
  for(i=0;; i++){
80105bc5:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
    if(i >= NELEM(argv))
80105bc9:	e9 5a ff ff ff       	jmp    80105b28 <sys_exec+0x60>
}
80105bce:	c9                   	leave  
80105bcf:	c3                   	ret    

80105bd0 <sys_pipe>:

int
sys_pipe(void)
{
80105bd0:	55                   	push   %ebp
80105bd1:	89 e5                	mov    %esp,%ebp
80105bd3:	83 ec 28             	sub    $0x28,%esp
  int *fd;
  struct file *rf, *wf;
  int fd0, fd1;

  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
80105bd6:	83 ec 04             	sub    $0x4,%esp
80105bd9:	6a 08                	push   $0x8
80105bdb:	8d 45 ec             	lea    -0x14(%ebp),%eax
80105bde:	50                   	push   %eax
80105bdf:	6a 00                	push   $0x0
80105be1:	e8 2f f2 ff ff       	call   80104e15 <argptr>
80105be6:	83 c4 10             	add    $0x10,%esp
80105be9:	85 c0                	test   %eax,%eax
80105beb:	79 0a                	jns    80105bf7 <sys_pipe+0x27>
    return -1;
80105bed:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105bf2:	e9 ae 00 00 00       	jmp    80105ca5 <sys_pipe+0xd5>
  if(pipealloc(&rf, &wf) < 0)
80105bf7:	83 ec 08             	sub    $0x8,%esp
80105bfa:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80105bfd:	50                   	push   %eax
80105bfe:	8d 45 e8             	lea    -0x18(%ebp),%eax
80105c01:	50                   	push   %eax
80105c02:	e8 66 d9 ff ff       	call   8010356d <pipealloc>
80105c07:	83 c4 10             	add    $0x10,%esp
80105c0a:	85 c0                	test   %eax,%eax
80105c0c:	79 0a                	jns    80105c18 <sys_pipe+0x48>
    return -1;
80105c0e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105c13:	e9 8d 00 00 00       	jmp    80105ca5 <sys_pipe+0xd5>
  fd0 = -1;
80105c18:	c7 45 f4 ff ff ff ff 	movl   $0xffffffff,-0xc(%ebp)
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
80105c1f:	8b 45 e8             	mov    -0x18(%ebp),%eax
80105c22:	83 ec 0c             	sub    $0xc,%esp
80105c25:	50                   	push   %eax
80105c26:	e8 7b f3 ff ff       	call   80104fa6 <fdalloc>
80105c2b:	83 c4 10             	add    $0x10,%esp
80105c2e:	89 45 f4             	mov    %eax,-0xc(%ebp)
80105c31:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80105c35:	78 18                	js     80105c4f <sys_pipe+0x7f>
80105c37:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80105c3a:	83 ec 0c             	sub    $0xc,%esp
80105c3d:	50                   	push   %eax
80105c3e:	e8 63 f3 ff ff       	call   80104fa6 <fdalloc>
80105c43:	83 c4 10             	add    $0x10,%esp
80105c46:	89 45 f0             	mov    %eax,-0x10(%ebp)
80105c49:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80105c4d:	79 3e                	jns    80105c8d <sys_pipe+0xbd>
    if(fd0 >= 0)
80105c4f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80105c53:	78 13                	js     80105c68 <sys_pipe+0x98>
      myproc()->ofile[fd0] = 0;
80105c55:	e8 29 df ff ff       	call   80103b83 <myproc>
80105c5a:	8b 55 f4             	mov    -0xc(%ebp),%edx
80105c5d:	83 c2 08             	add    $0x8,%edx
80105c60:	c7 44 90 08 00 00 00 	movl   $0x0,0x8(%eax,%edx,4)
80105c67:	00 
    fileclose(rf);
80105c68:	8b 45 e8             	mov    -0x18(%ebp),%eax
80105c6b:	83 ec 0c             	sub    $0xc,%esp
80105c6e:	50                   	push   %eax
80105c6f:	e8 27 b4 ff ff       	call   8010109b <fileclose>
80105c74:	83 c4 10             	add    $0x10,%esp
    fileclose(wf);
80105c77:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80105c7a:	83 ec 0c             	sub    $0xc,%esp
80105c7d:	50                   	push   %eax
80105c7e:	e8 18 b4 ff ff       	call   8010109b <fileclose>
80105c83:	83 c4 10             	add    $0x10,%esp
    return -1;
80105c86:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105c8b:	eb 18                	jmp    80105ca5 <sys_pipe+0xd5>
  }
  fd[0] = fd0;
80105c8d:	8b 45 ec             	mov    -0x14(%ebp),%eax
80105c90:	8b 55 f4             	mov    -0xc(%ebp),%edx
80105c93:	89 10                	mov    %edx,(%eax)
  fd[1] = fd1;
80105c95:	8b 45 ec             	mov    -0x14(%ebp),%eax
80105c98:	8d 50 04             	lea    0x4(%eax),%edx
80105c9b:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105c9e:	89 02                	mov    %eax,(%edx)
  return 0;
80105ca0:	b8 00 00 00 00       	mov    $0x0,%eax
}
80105ca5:	c9                   	leave  
80105ca6:	c3                   	ret    

80105ca7 <sys_printpt>:
#include "param.h"
#include "memlayout.h"
#include "mmu.h"
#include "proc.h"
int
sys_printpt(void){
80105ca7:	55                   	push   %ebp
80105ca8:	89 e5                	mov    %esp,%ebp
80105caa:	83 ec 08             	sub    $0x8,%esp
  printpt(myproc()->pid);
80105cad:	e8 d1 de ff ff       	call   80103b83 <myproc>
80105cb2:	8b 40 10             	mov    0x10(%eax),%eax
80105cb5:	83 ec 0c             	sub    $0xc,%esp
80105cb8:	50                   	push   %eax
80105cb9:	e8 c1 dc ff ff       	call   8010397f <printpt>
80105cbe:	83 c4 10             	add    $0x10,%esp
  return 0;
80105cc1:	b8 00 00 00 00       	mov    $0x0,%eax
}
80105cc6:	c9                   	leave  
80105cc7:	c3                   	ret    

80105cc8 <sys_fork>:

int
sys_fork(void)
{
80105cc8:	55                   	push   %ebp
80105cc9:	89 e5                	mov    %esp,%ebp
80105ccb:	83 ec 08             	sub    $0x8,%esp
  return fork();
80105cce:	e8 af e1 ff ff       	call   80103e82 <fork>
}
80105cd3:	c9                   	leave  
80105cd4:	c3                   	ret    

80105cd5 <sys_exit>:

int
sys_exit(void)
{
80105cd5:	55                   	push   %ebp
80105cd6:	89 e5                	mov    %esp,%ebp
80105cd8:	83 ec 08             	sub    $0x8,%esp
  exit();
80105cdb:	e8 1b e3 ff ff       	call   80103ffb <exit>
  return 0;  // not reached
80105ce0:	b8 00 00 00 00       	mov    $0x0,%eax
}
80105ce5:	c9                   	leave  
80105ce6:	c3                   	ret    

80105ce7 <sys_wait>:

int
sys_wait(void)
{
80105ce7:	55                   	push   %ebp
80105ce8:	89 e5                	mov    %esp,%ebp
80105cea:	83 ec 08             	sub    $0x8,%esp
  return wait();
80105ced:	e8 29 e4 ff ff       	call   8010411b <wait>
}
80105cf2:	c9                   	leave  
80105cf3:	c3                   	ret    

80105cf4 <sys_kill>:

int
sys_kill(void)
{
80105cf4:	55                   	push   %ebp
80105cf5:	89 e5                	mov    %esp,%ebp
80105cf7:	83 ec 18             	sub    $0x18,%esp
  int pid;

  if(argint(0, &pid) < 0)
80105cfa:	83 ec 08             	sub    $0x8,%esp
80105cfd:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105d00:	50                   	push   %eax
80105d01:	6a 00                	push   $0x0
80105d03:	e8 e0 f0 ff ff       	call   80104de8 <argint>
80105d08:	83 c4 10             	add    $0x10,%esp
80105d0b:	85 c0                	test   %eax,%eax
80105d0d:	79 07                	jns    80105d16 <sys_kill+0x22>
    return -1;
80105d0f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105d14:	eb 0f                	jmp    80105d25 <sys_kill+0x31>
  return kill(pid);
80105d16:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105d19:	83 ec 0c             	sub    $0xc,%esp
80105d1c:	50                   	push   %eax
80105d1d:	e8 28 e8 ff ff       	call   8010454a <kill>
80105d22:	83 c4 10             	add    $0x10,%esp
}
80105d25:	c9                   	leave  
80105d26:	c3                   	ret    

80105d27 <sys_getpid>:

int
sys_getpid(void)
{
80105d27:	55                   	push   %ebp
80105d28:	89 e5                	mov    %esp,%ebp
80105d2a:	83 ec 08             	sub    $0x8,%esp
  return myproc()->pid;
80105d2d:	e8 51 de ff ff       	call   80103b83 <myproc>
80105d32:	8b 40 10             	mov    0x10(%eax),%eax
}
80105d35:	c9                   	leave  
80105d36:	c3                   	ret    

80105d37 <sys_sbrk>:

int
sys_sbrk(void)
{
80105d37:	55                   	push   %ebp
80105d38:	89 e5                	mov    %esp,%ebp
80105d3a:	83 ec 18             	sub    $0x18,%esp
  int addr;
  int n;

  if(argint(0, &n) < 0)
80105d3d:	83 ec 08             	sub    $0x8,%esp
80105d40:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105d43:	50                   	push   %eax
80105d44:	6a 00                	push   $0x0
80105d46:	e8 9d f0 ff ff       	call   80104de8 <argint>
80105d4b:	83 c4 10             	add    $0x10,%esp
80105d4e:	85 c0                	test   %eax,%eax
80105d50:	79 07                	jns    80105d59 <sys_sbrk+0x22>
    return -1;
80105d52:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105d57:	eb 27                	jmp    80105d80 <sys_sbrk+0x49>
  addr = myproc()->sz;
80105d59:	e8 25 de ff ff       	call   80103b83 <myproc>
80105d5e:	8b 00                	mov    (%eax),%eax
80105d60:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(growproc(n) < 0)
80105d63:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105d66:	83 ec 0c             	sub    $0xc,%esp
80105d69:	50                   	push   %eax
80105d6a:	e8 78 e0 ff ff       	call   80103de7 <growproc>
80105d6f:	83 c4 10             	add    $0x10,%esp
80105d72:	85 c0                	test   %eax,%eax
80105d74:	79 07                	jns    80105d7d <sys_sbrk+0x46>
    return -1;
80105d76:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105d7b:	eb 03                	jmp    80105d80 <sys_sbrk+0x49>
  return addr;
80105d7d:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
80105d80:	c9                   	leave  
80105d81:	c3                   	ret    

80105d82 <sys_sleep>:

int
sys_sleep(void)
{
80105d82:	55                   	push   %ebp
80105d83:	89 e5                	mov    %esp,%ebp
80105d85:	83 ec 18             	sub    $0x18,%esp
  int n;
  uint ticks0;

  if(argint(0, &n) < 0)
80105d88:	83 ec 08             	sub    $0x8,%esp
80105d8b:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105d8e:	50                   	push   %eax
80105d8f:	6a 00                	push   $0x0
80105d91:	e8 52 f0 ff ff       	call   80104de8 <argint>
80105d96:	83 c4 10             	add    $0x10,%esp
80105d99:	85 c0                	test   %eax,%eax
80105d9b:	79 07                	jns    80105da4 <sys_sleep+0x22>
    return -1;
80105d9d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105da2:	eb 76                	jmp    80105e1a <sys_sleep+0x98>
  acquire(&tickslock);
80105da4:	83 ec 0c             	sub    $0xc,%esp
80105da7:	68 40 69 19 80       	push   $0x80196940
80105dac:	e8 96 ea ff ff       	call   80104847 <acquire>
80105db1:	83 c4 10             	add    $0x10,%esp
  ticks0 = ticks;
80105db4:	a1 74 69 19 80       	mov    0x80196974,%eax
80105db9:	89 45 f4             	mov    %eax,-0xc(%ebp)
  while(ticks - ticks0 < n){
80105dbc:	eb 38                	jmp    80105df6 <sys_sleep+0x74>
    if(myproc()->killed){
80105dbe:	e8 c0 dd ff ff       	call   80103b83 <myproc>
80105dc3:	8b 40 24             	mov    0x24(%eax),%eax
80105dc6:	85 c0                	test   %eax,%eax
80105dc8:	74 17                	je     80105de1 <sys_sleep+0x5f>
      release(&tickslock);
80105dca:	83 ec 0c             	sub    $0xc,%esp
80105dcd:	68 40 69 19 80       	push   $0x80196940
80105dd2:	e8 de ea ff ff       	call   801048b5 <release>
80105dd7:	83 c4 10             	add    $0x10,%esp
      return -1;
80105dda:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105ddf:	eb 39                	jmp    80105e1a <sys_sleep+0x98>
    }
    sleep(&ticks, &tickslock);
80105de1:	83 ec 08             	sub    $0x8,%esp
80105de4:	68 40 69 19 80       	push   $0x80196940
80105de9:	68 74 69 19 80       	push   $0x80196974
80105dee:	e8 39 e6 ff ff       	call   8010442c <sleep>
80105df3:	83 c4 10             	add    $0x10,%esp
  while(ticks - ticks0 < n){
80105df6:	a1 74 69 19 80       	mov    0x80196974,%eax
80105dfb:	2b 45 f4             	sub    -0xc(%ebp),%eax
80105dfe:	8b 55 f0             	mov    -0x10(%ebp),%edx
80105e01:	39 d0                	cmp    %edx,%eax
80105e03:	72 b9                	jb     80105dbe <sys_sleep+0x3c>
  }
  release(&tickslock);
80105e05:	83 ec 0c             	sub    $0xc,%esp
80105e08:	68 40 69 19 80       	push   $0x80196940
80105e0d:	e8 a3 ea ff ff       	call   801048b5 <release>
80105e12:	83 c4 10             	add    $0x10,%esp
  return 0;
80105e15:	b8 00 00 00 00       	mov    $0x0,%eax
}
80105e1a:	c9                   	leave  
80105e1b:	c3                   	ret    

80105e1c <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
int
sys_uptime(void)
{
80105e1c:	55                   	push   %ebp
80105e1d:	89 e5                	mov    %esp,%ebp
80105e1f:	83 ec 18             	sub    $0x18,%esp
  uint xticks;

  acquire(&tickslock);
80105e22:	83 ec 0c             	sub    $0xc,%esp
80105e25:	68 40 69 19 80       	push   $0x80196940
80105e2a:	e8 18 ea ff ff       	call   80104847 <acquire>
80105e2f:	83 c4 10             	add    $0x10,%esp
  xticks = ticks;
80105e32:	a1 74 69 19 80       	mov    0x80196974,%eax
80105e37:	89 45 f4             	mov    %eax,-0xc(%ebp)
  release(&tickslock);
80105e3a:	83 ec 0c             	sub    $0xc,%esp
80105e3d:	68 40 69 19 80       	push   $0x80196940
80105e42:	e8 6e ea ff ff       	call   801048b5 <release>
80105e47:	83 c4 10             	add    $0x10,%esp
  return xticks;
80105e4a:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
80105e4d:	c9                   	leave  
80105e4e:	c3                   	ret    

80105e4f <alltraps>:
80105e4f:	1e                   	push   %ds
80105e50:	06                   	push   %es
80105e51:	0f a0                	push   %fs
80105e53:	0f a8                	push   %gs
80105e55:	60                   	pusha  
80105e56:	66 b8 10 00          	mov    $0x10,%ax
80105e5a:	8e d8                	mov    %eax,%ds
80105e5c:	8e c0                	mov    %eax,%es
80105e5e:	54                   	push   %esp
80105e5f:	e8 d7 01 00 00       	call   8010603b <trap>
80105e64:	83 c4 04             	add    $0x4,%esp

80105e67 <trapret>:
80105e67:	61                   	popa   
80105e68:	0f a9                	pop    %gs
80105e6a:	0f a1                	pop    %fs
80105e6c:	07                   	pop    %es
80105e6d:	1f                   	pop    %ds
80105e6e:	83 c4 08             	add    $0x8,%esp
80105e71:	cf                   	iret   

80105e72 <lidt>:
{
80105e72:	55                   	push   %ebp
80105e73:	89 e5                	mov    %esp,%ebp
80105e75:	83 ec 10             	sub    $0x10,%esp
  pd[0] = size-1;
80105e78:	8b 45 0c             	mov    0xc(%ebp),%eax
80105e7b:	83 e8 01             	sub    $0x1,%eax
80105e7e:	66 89 45 fa          	mov    %ax,-0x6(%ebp)
  pd[1] = (uint)p;
80105e82:	8b 45 08             	mov    0x8(%ebp),%eax
80105e85:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  pd[2] = (uint)p >> 16;
80105e89:	8b 45 08             	mov    0x8(%ebp),%eax
80105e8c:	c1 e8 10             	shr    $0x10,%eax
80105e8f:	66 89 45 fe          	mov    %ax,-0x2(%ebp)
  asm volatile("lidt (%0)" : : "r" (pd));
80105e93:	8d 45 fa             	lea    -0x6(%ebp),%eax
80105e96:	0f 01 18             	lidtl  (%eax)
}
80105e99:	90                   	nop
80105e9a:	c9                   	leave  
80105e9b:	c3                   	ret    

80105e9c <rcr2>:

static inline uint
rcr2(void)
{
80105e9c:	55                   	push   %ebp
80105e9d:	89 e5                	mov    %esp,%ebp
80105e9f:	83 ec 10             	sub    $0x10,%esp
  uint val;
  asm volatile("movl %%cr2,%0" : "=r" (val));
80105ea2:	0f 20 d0             	mov    %cr2,%eax
80105ea5:	89 45 fc             	mov    %eax,-0x4(%ebp)
  return val;
80105ea8:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
80105eab:	c9                   	leave  
80105eac:	c3                   	ret    

80105ead <tvinit>:
struct spinlock tickslock;
uint ticks;

void
tvinit(void)
{
80105ead:	55                   	push   %ebp
80105eae:	89 e5                	mov    %esp,%ebp
80105eb0:	83 ec 18             	sub    $0x18,%esp
  int i;

  for(i = 0; i < 256; i++)
80105eb3:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80105eba:	e9 c3 00 00 00       	jmp    80105f82 <tvinit+0xd5>
    SETGATE(idt[i], 0, SEG_KCODE<<3, vectors[i], 0);
80105ebf:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105ec2:	8b 04 85 7c f0 10 80 	mov    -0x7fef0f84(,%eax,4),%eax
80105ec9:	89 c2                	mov    %eax,%edx
80105ecb:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105ece:	66 89 14 c5 40 61 19 	mov    %dx,-0x7fe69ec0(,%eax,8)
80105ed5:	80 
80105ed6:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105ed9:	66 c7 04 c5 42 61 19 	movw   $0x8,-0x7fe69ebe(,%eax,8)
80105ee0:	80 08 00 
80105ee3:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105ee6:	0f b6 14 c5 44 61 19 	movzbl -0x7fe69ebc(,%eax,8),%edx
80105eed:	80 
80105eee:	83 e2 e0             	and    $0xffffffe0,%edx
80105ef1:	88 14 c5 44 61 19 80 	mov    %dl,-0x7fe69ebc(,%eax,8)
80105ef8:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105efb:	0f b6 14 c5 44 61 19 	movzbl -0x7fe69ebc(,%eax,8),%edx
80105f02:	80 
80105f03:	83 e2 1f             	and    $0x1f,%edx
80105f06:	88 14 c5 44 61 19 80 	mov    %dl,-0x7fe69ebc(,%eax,8)
80105f0d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105f10:	0f b6 14 c5 45 61 19 	movzbl -0x7fe69ebb(,%eax,8),%edx
80105f17:	80 
80105f18:	83 e2 f0             	and    $0xfffffff0,%edx
80105f1b:	83 ca 0e             	or     $0xe,%edx
80105f1e:	88 14 c5 45 61 19 80 	mov    %dl,-0x7fe69ebb(,%eax,8)
80105f25:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105f28:	0f b6 14 c5 45 61 19 	movzbl -0x7fe69ebb(,%eax,8),%edx
80105f2f:	80 
80105f30:	83 e2 ef             	and    $0xffffffef,%edx
80105f33:	88 14 c5 45 61 19 80 	mov    %dl,-0x7fe69ebb(,%eax,8)
80105f3a:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105f3d:	0f b6 14 c5 45 61 19 	movzbl -0x7fe69ebb(,%eax,8),%edx
80105f44:	80 
80105f45:	83 e2 9f             	and    $0xffffff9f,%edx
80105f48:	88 14 c5 45 61 19 80 	mov    %dl,-0x7fe69ebb(,%eax,8)
80105f4f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105f52:	0f b6 14 c5 45 61 19 	movzbl -0x7fe69ebb(,%eax,8),%edx
80105f59:	80 
80105f5a:	83 ca 80             	or     $0xffffff80,%edx
80105f5d:	88 14 c5 45 61 19 80 	mov    %dl,-0x7fe69ebb(,%eax,8)
80105f64:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105f67:	8b 04 85 7c f0 10 80 	mov    -0x7fef0f84(,%eax,4),%eax
80105f6e:	c1 e8 10             	shr    $0x10,%eax
80105f71:	89 c2                	mov    %eax,%edx
80105f73:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105f76:	66 89 14 c5 46 61 19 	mov    %dx,-0x7fe69eba(,%eax,8)
80105f7d:	80 
  for(i = 0; i < 256; i++)
80105f7e:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80105f82:	81 7d f4 ff 00 00 00 	cmpl   $0xff,-0xc(%ebp)
80105f89:	0f 8e 30 ff ff ff    	jle    80105ebf <tvinit+0x12>
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
80105f8f:	a1 7c f1 10 80       	mov    0x8010f17c,%eax
80105f94:	66 a3 40 63 19 80    	mov    %ax,0x80196340
80105f9a:	66 c7 05 42 63 19 80 	movw   $0x8,0x80196342
80105fa1:	08 00 
80105fa3:	0f b6 05 44 63 19 80 	movzbl 0x80196344,%eax
80105faa:	83 e0 e0             	and    $0xffffffe0,%eax
80105fad:	a2 44 63 19 80       	mov    %al,0x80196344
80105fb2:	0f b6 05 44 63 19 80 	movzbl 0x80196344,%eax
80105fb9:	83 e0 1f             	and    $0x1f,%eax
80105fbc:	a2 44 63 19 80       	mov    %al,0x80196344
80105fc1:	0f b6 05 45 63 19 80 	movzbl 0x80196345,%eax
80105fc8:	83 c8 0f             	or     $0xf,%eax
80105fcb:	a2 45 63 19 80       	mov    %al,0x80196345
80105fd0:	0f b6 05 45 63 19 80 	movzbl 0x80196345,%eax
80105fd7:	83 e0 ef             	and    $0xffffffef,%eax
80105fda:	a2 45 63 19 80       	mov    %al,0x80196345
80105fdf:	0f b6 05 45 63 19 80 	movzbl 0x80196345,%eax
80105fe6:	83 c8 60             	or     $0x60,%eax
80105fe9:	a2 45 63 19 80       	mov    %al,0x80196345
80105fee:	0f b6 05 45 63 19 80 	movzbl 0x80196345,%eax
80105ff5:	83 c8 80             	or     $0xffffff80,%eax
80105ff8:	a2 45 63 19 80       	mov    %al,0x80196345
80105ffd:	a1 7c f1 10 80       	mov    0x8010f17c,%eax
80106002:	c1 e8 10             	shr    $0x10,%eax
80106005:	66 a3 46 63 19 80    	mov    %ax,0x80196346

  initlock(&tickslock, "time");
8010600b:	83 ec 08             	sub    $0x8,%esp
8010600e:	68 74 a5 10 80       	push   $0x8010a574
80106013:	68 40 69 19 80       	push   $0x80196940
80106018:	e8 08 e8 ff ff       	call   80104825 <initlock>
8010601d:	83 c4 10             	add    $0x10,%esp
}
80106020:	90                   	nop
80106021:	c9                   	leave  
80106022:	c3                   	ret    

80106023 <idtinit>:

void
idtinit(void)
{
80106023:	55                   	push   %ebp
80106024:	89 e5                	mov    %esp,%ebp
  lidt(idt, sizeof(idt));
80106026:	68 00 08 00 00       	push   $0x800
8010602b:	68 40 61 19 80       	push   $0x80196140
80106030:	e8 3d fe ff ff       	call   80105e72 <lidt>
80106035:	83 c4 08             	add    $0x8,%esp
}
80106038:	90                   	nop
80106039:	c9                   	leave  
8010603a:	c3                   	ret    

8010603b <trap>:

//PAGEBREAK: 41
void
trap(struct trapframe *tf)
{
8010603b:	55                   	push   %ebp
8010603c:	89 e5                	mov    %esp,%ebp
8010603e:	57                   	push   %edi
8010603f:	56                   	push   %esi
80106040:	53                   	push   %ebx
80106041:	83 ec 1c             	sub    $0x1c,%esp
  if(tf->trapno == T_SYSCALL){
80106044:	8b 45 08             	mov    0x8(%ebp),%eax
80106047:	8b 40 30             	mov    0x30(%eax),%eax
8010604a:	83 f8 40             	cmp    $0x40,%eax
8010604d:	75 3b                	jne    8010608a <trap+0x4f>
    if(myproc()->killed)
8010604f:	e8 2f db ff ff       	call   80103b83 <myproc>
80106054:	8b 40 24             	mov    0x24(%eax),%eax
80106057:	85 c0                	test   %eax,%eax
80106059:	74 05                	je     80106060 <trap+0x25>
      exit();
8010605b:	e8 9b df ff ff       	call   80103ffb <exit>
    myproc()->tf = tf;
80106060:	e8 1e db ff ff       	call   80103b83 <myproc>
80106065:	8b 55 08             	mov    0x8(%ebp),%edx
80106068:	89 50 18             	mov    %edx,0x18(%eax)
    syscall();
8010606b:	e8 44 ee ff ff       	call   80104eb4 <syscall>
    if(myproc()->killed)
80106070:	e8 0e db ff ff       	call   80103b83 <myproc>
80106075:	8b 40 24             	mov    0x24(%eax),%eax
80106078:	85 c0                	test   %eax,%eax
8010607a:	0f 84 15 02 00 00    	je     80106295 <trap+0x25a>
      exit();
80106080:	e8 76 df ff ff       	call   80103ffb <exit>
    return;
80106085:	e9 0b 02 00 00       	jmp    80106295 <trap+0x25a>
  }

  switch(tf->trapno){
8010608a:	8b 45 08             	mov    0x8(%ebp),%eax
8010608d:	8b 40 30             	mov    0x30(%eax),%eax
80106090:	83 e8 20             	sub    $0x20,%eax
80106093:	83 f8 1f             	cmp    $0x1f,%eax
80106096:	0f 87 c4 00 00 00    	ja     80106160 <trap+0x125>
8010609c:	8b 04 85 1c a6 10 80 	mov    -0x7fef59e4(,%eax,4),%eax
801060a3:	ff e0                	jmp    *%eax
  case T_IRQ0 + IRQ_TIMER:
    if(cpuid() == 0){
801060a5:	e8 46 da ff ff       	call   80103af0 <cpuid>
801060aa:	85 c0                	test   %eax,%eax
801060ac:	75 3d                	jne    801060eb <trap+0xb0>
      acquire(&tickslock);
801060ae:	83 ec 0c             	sub    $0xc,%esp
801060b1:	68 40 69 19 80       	push   $0x80196940
801060b6:	e8 8c e7 ff ff       	call   80104847 <acquire>
801060bb:	83 c4 10             	add    $0x10,%esp
      ticks++;
801060be:	a1 74 69 19 80       	mov    0x80196974,%eax
801060c3:	83 c0 01             	add    $0x1,%eax
801060c6:	a3 74 69 19 80       	mov    %eax,0x80196974
      wakeup(&ticks);
801060cb:	83 ec 0c             	sub    $0xc,%esp
801060ce:	68 74 69 19 80       	push   $0x80196974
801060d3:	e8 3b e4 ff ff       	call   80104513 <wakeup>
801060d8:	83 c4 10             	add    $0x10,%esp
      release(&tickslock);
801060db:	83 ec 0c             	sub    $0xc,%esp
801060de:	68 40 69 19 80       	push   $0x80196940
801060e3:	e8 cd e7 ff ff       	call   801048b5 <release>
801060e8:	83 c4 10             	add    $0x10,%esp
    }
    lapiceoi();
801060eb:	e8 2c ca ff ff       	call   80102b1c <lapiceoi>
    break;
801060f0:	e9 20 01 00 00       	jmp    80106215 <trap+0x1da>
  case T_IRQ0 + IRQ_IDE:
    ideintr();
801060f5:	e8 f5 3e 00 00       	call   80109fef <ideintr>
    lapiceoi();
801060fa:	e8 1d ca ff ff       	call   80102b1c <lapiceoi>
    break;
801060ff:	e9 11 01 00 00       	jmp    80106215 <trap+0x1da>
  case T_IRQ0 + IRQ_IDE+1:
    // Bochs generates spurious IDE1 interrupts.
    break;
  case T_IRQ0 + IRQ_KBD:
    kbdintr();
80106104:	e8 58 c8 ff ff       	call   80102961 <kbdintr>
    lapiceoi();
80106109:	e8 0e ca ff ff       	call   80102b1c <lapiceoi>
    break;
8010610e:	e9 02 01 00 00       	jmp    80106215 <trap+0x1da>
  case T_IRQ0 + IRQ_COM1:
    uartintr();
80106113:	e8 53 03 00 00       	call   8010646b <uartintr>
    lapiceoi();
80106118:	e8 ff c9 ff ff       	call   80102b1c <lapiceoi>
    break;
8010611d:	e9 f3 00 00 00       	jmp    80106215 <trap+0x1da>
  case T_IRQ0 + 0xB:
    i8254_intr();
80106122:	e8 7b 2b 00 00       	call   80108ca2 <i8254_intr>
    lapiceoi();
80106127:	e8 f0 c9 ff ff       	call   80102b1c <lapiceoi>
    break;
8010612c:	e9 e4 00 00 00       	jmp    80106215 <trap+0x1da>
  case T_IRQ0 + IRQ_SPURIOUS:
    cprintf("cpu%d: spurious interrupt at %x:%x\n",
80106131:	8b 45 08             	mov    0x8(%ebp),%eax
80106134:	8b 70 38             	mov    0x38(%eax),%esi
            cpuid(), tf->cs, tf->eip);
80106137:	8b 45 08             	mov    0x8(%ebp),%eax
8010613a:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
    cprintf("cpu%d: spurious interrupt at %x:%x\n",
8010613e:	0f b7 d8             	movzwl %ax,%ebx
80106141:	e8 aa d9 ff ff       	call   80103af0 <cpuid>
80106146:	56                   	push   %esi
80106147:	53                   	push   %ebx
80106148:	50                   	push   %eax
80106149:	68 7c a5 10 80       	push   $0x8010a57c
8010614e:	e8 a1 a2 ff ff       	call   801003f4 <cprintf>
80106153:	83 c4 10             	add    $0x10,%esp
    lapiceoi();
80106156:	e8 c1 c9 ff ff       	call   80102b1c <lapiceoi>
    break;
8010615b:	e9 b5 00 00 00       	jmp    80106215 <trap+0x1da>

  //PAGEBREAK: 13
  default:
    if(myproc() == 0 || (tf->cs&3) == 0){
80106160:	e8 1e da ff ff       	call   80103b83 <myproc>
80106165:	85 c0                	test   %eax,%eax
80106167:	74 11                	je     8010617a <trap+0x13f>
80106169:	8b 45 08             	mov    0x8(%ebp),%eax
8010616c:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
80106170:	0f b7 c0             	movzwl %ax,%eax
80106173:	83 e0 03             	and    $0x3,%eax
80106176:	85 c0                	test   %eax,%eax
80106178:	75 39                	jne    801061b3 <trap+0x178>
      // In kernel, it must be our mistake.
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
8010617a:	e8 1d fd ff ff       	call   80105e9c <rcr2>
8010617f:	89 c3                	mov    %eax,%ebx
80106181:	8b 45 08             	mov    0x8(%ebp),%eax
80106184:	8b 70 38             	mov    0x38(%eax),%esi
80106187:	e8 64 d9 ff ff       	call   80103af0 <cpuid>
8010618c:	8b 55 08             	mov    0x8(%ebp),%edx
8010618f:	8b 52 30             	mov    0x30(%edx),%edx
80106192:	83 ec 0c             	sub    $0xc,%esp
80106195:	53                   	push   %ebx
80106196:	56                   	push   %esi
80106197:	50                   	push   %eax
80106198:	52                   	push   %edx
80106199:	68 a0 a5 10 80       	push   $0x8010a5a0
8010619e:	e8 51 a2 ff ff       	call   801003f4 <cprintf>
801061a3:	83 c4 20             	add    $0x20,%esp
              tf->trapno, cpuid(), tf->eip, rcr2());
      panic("trap");
801061a6:	83 ec 0c             	sub    $0xc,%esp
801061a9:	68 d2 a5 10 80       	push   $0x8010a5d2
801061ae:	e8 f6 a3 ff ff       	call   801005a9 <panic>
    }
    // In user space, assume process misbehaved.
    cprintf("pid %d %s: trap %d err %d on cpu %d "
801061b3:	e8 e4 fc ff ff       	call   80105e9c <rcr2>
801061b8:	89 c6                	mov    %eax,%esi
801061ba:	8b 45 08             	mov    0x8(%ebp),%eax
801061bd:	8b 40 38             	mov    0x38(%eax),%eax
801061c0:	89 45 e4             	mov    %eax,-0x1c(%ebp)
801061c3:	e8 28 d9 ff ff       	call   80103af0 <cpuid>
801061c8:	89 c3                	mov    %eax,%ebx
801061ca:	8b 45 08             	mov    0x8(%ebp),%eax
801061cd:	8b 48 34             	mov    0x34(%eax),%ecx
801061d0:	89 4d e0             	mov    %ecx,-0x20(%ebp)
801061d3:	8b 45 08             	mov    0x8(%ebp),%eax
801061d6:	8b 78 30             	mov    0x30(%eax),%edi
            "eip 0x%x addr 0x%x--kill proc\n",
            myproc()->pid, myproc()->name, tf->trapno,
801061d9:	e8 a5 d9 ff ff       	call   80103b83 <myproc>
801061de:	8d 50 6c             	lea    0x6c(%eax),%edx
801061e1:	89 55 dc             	mov    %edx,-0x24(%ebp)
801061e4:	e8 9a d9 ff ff       	call   80103b83 <myproc>
    cprintf("pid %d %s: trap %d err %d on cpu %d "
801061e9:	8b 40 10             	mov    0x10(%eax),%eax
801061ec:	56                   	push   %esi
801061ed:	ff 75 e4             	push   -0x1c(%ebp)
801061f0:	53                   	push   %ebx
801061f1:	ff 75 e0             	push   -0x20(%ebp)
801061f4:	57                   	push   %edi
801061f5:	ff 75 dc             	push   -0x24(%ebp)
801061f8:	50                   	push   %eax
801061f9:	68 d8 a5 10 80       	push   $0x8010a5d8
801061fe:	e8 f1 a1 ff ff       	call   801003f4 <cprintf>
80106203:	83 c4 20             	add    $0x20,%esp
            tf->err, cpuid(), tf->eip, rcr2());
    myproc()->killed = 1;
80106206:	e8 78 d9 ff ff       	call   80103b83 <myproc>
8010620b:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
80106212:	eb 01                	jmp    80106215 <trap+0x1da>
    break;
80106214:	90                   	nop
  }

  // Force process exit if it has been killed and is in user space.
  // (If it is still executing in the kernel, let it keep running
  // until it gets to the regular system call return.)
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80106215:	e8 69 d9 ff ff       	call   80103b83 <myproc>
8010621a:	85 c0                	test   %eax,%eax
8010621c:	74 23                	je     80106241 <trap+0x206>
8010621e:	e8 60 d9 ff ff       	call   80103b83 <myproc>
80106223:	8b 40 24             	mov    0x24(%eax),%eax
80106226:	85 c0                	test   %eax,%eax
80106228:	74 17                	je     80106241 <trap+0x206>
8010622a:	8b 45 08             	mov    0x8(%ebp),%eax
8010622d:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
80106231:	0f b7 c0             	movzwl %ax,%eax
80106234:	83 e0 03             	and    $0x3,%eax
80106237:	83 f8 03             	cmp    $0x3,%eax
8010623a:	75 05                	jne    80106241 <trap+0x206>
    exit();
8010623c:	e8 ba dd ff ff       	call   80103ffb <exit>

  // Force process to give up CPU on clock tick.
  // If interrupts were on while locks held, would need to check nlock.
  if(myproc() && myproc()->state == RUNNING &&
80106241:	e8 3d d9 ff ff       	call   80103b83 <myproc>
80106246:	85 c0                	test   %eax,%eax
80106248:	74 1d                	je     80106267 <trap+0x22c>
8010624a:	e8 34 d9 ff ff       	call   80103b83 <myproc>
8010624f:	8b 40 0c             	mov    0xc(%eax),%eax
80106252:	83 f8 04             	cmp    $0x4,%eax
80106255:	75 10                	jne    80106267 <trap+0x22c>
     tf->trapno == T_IRQ0+IRQ_TIMER)
80106257:	8b 45 08             	mov    0x8(%ebp),%eax
8010625a:	8b 40 30             	mov    0x30(%eax),%eax
  if(myproc() && myproc()->state == RUNNING &&
8010625d:	83 f8 20             	cmp    $0x20,%eax
80106260:	75 05                	jne    80106267 <trap+0x22c>
    yield();
80106262:	e8 45 e1 ff ff       	call   801043ac <yield>

  // Check if the process has been killed since we yielded
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80106267:	e8 17 d9 ff ff       	call   80103b83 <myproc>
8010626c:	85 c0                	test   %eax,%eax
8010626e:	74 26                	je     80106296 <trap+0x25b>
80106270:	e8 0e d9 ff ff       	call   80103b83 <myproc>
80106275:	8b 40 24             	mov    0x24(%eax),%eax
80106278:	85 c0                	test   %eax,%eax
8010627a:	74 1a                	je     80106296 <trap+0x25b>
8010627c:	8b 45 08             	mov    0x8(%ebp),%eax
8010627f:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
80106283:	0f b7 c0             	movzwl %ax,%eax
80106286:	83 e0 03             	and    $0x3,%eax
80106289:	83 f8 03             	cmp    $0x3,%eax
8010628c:	75 08                	jne    80106296 <trap+0x25b>
    exit();
8010628e:	e8 68 dd ff ff       	call   80103ffb <exit>
80106293:	eb 01                	jmp    80106296 <trap+0x25b>
    return;
80106295:	90                   	nop
}
80106296:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106299:	5b                   	pop    %ebx
8010629a:	5e                   	pop    %esi
8010629b:	5f                   	pop    %edi
8010629c:	5d                   	pop    %ebp
8010629d:	c3                   	ret    

8010629e <inb>:
{
8010629e:	55                   	push   %ebp
8010629f:	89 e5                	mov    %esp,%ebp
801062a1:	83 ec 14             	sub    $0x14,%esp
801062a4:	8b 45 08             	mov    0x8(%ebp),%eax
801062a7:	66 89 45 ec          	mov    %ax,-0x14(%ebp)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801062ab:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
801062af:	89 c2                	mov    %eax,%edx
801062b1:	ec                   	in     (%dx),%al
801062b2:	88 45 ff             	mov    %al,-0x1(%ebp)
  return data;
801062b5:	0f b6 45 ff          	movzbl -0x1(%ebp),%eax
}
801062b9:	c9                   	leave  
801062ba:	c3                   	ret    

801062bb <outb>:
{
801062bb:	55                   	push   %ebp
801062bc:	89 e5                	mov    %esp,%ebp
801062be:	83 ec 08             	sub    $0x8,%esp
801062c1:	8b 45 08             	mov    0x8(%ebp),%eax
801062c4:	8b 55 0c             	mov    0xc(%ebp),%edx
801062c7:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
801062cb:	89 d0                	mov    %edx,%eax
801062cd:	88 45 f8             	mov    %al,-0x8(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801062d0:	0f b6 45 f8          	movzbl -0x8(%ebp),%eax
801062d4:	0f b7 55 fc          	movzwl -0x4(%ebp),%edx
801062d8:	ee                   	out    %al,(%dx)
}
801062d9:	90                   	nop
801062da:	c9                   	leave  
801062db:	c3                   	ret    

801062dc <uartinit>:

static int uart;    // is there a uart?

void
uartinit(void)
{
801062dc:	55                   	push   %ebp
801062dd:	89 e5                	mov    %esp,%ebp
801062df:	83 ec 18             	sub    $0x18,%esp
  char *p;

  // Turn off the FIFO
  outb(COM1+2, 0);
801062e2:	6a 00                	push   $0x0
801062e4:	68 fa 03 00 00       	push   $0x3fa
801062e9:	e8 cd ff ff ff       	call   801062bb <outb>
801062ee:	83 c4 08             	add    $0x8,%esp

  // 9600 baud, 8 data bits, 1 stop bit, parity off.
  outb(COM1+3, 0x80);    // Unlock divisor
801062f1:	68 80 00 00 00       	push   $0x80
801062f6:	68 fb 03 00 00       	push   $0x3fb
801062fb:	e8 bb ff ff ff       	call   801062bb <outb>
80106300:	83 c4 08             	add    $0x8,%esp
  outb(COM1+0, 115200/9600);
80106303:	6a 0c                	push   $0xc
80106305:	68 f8 03 00 00       	push   $0x3f8
8010630a:	e8 ac ff ff ff       	call   801062bb <outb>
8010630f:	83 c4 08             	add    $0x8,%esp
  outb(COM1+1, 0);
80106312:	6a 00                	push   $0x0
80106314:	68 f9 03 00 00       	push   $0x3f9
80106319:	e8 9d ff ff ff       	call   801062bb <outb>
8010631e:	83 c4 08             	add    $0x8,%esp
  outb(COM1+3, 0x03);    // Lock divisor, 8 data bits.
80106321:	6a 03                	push   $0x3
80106323:	68 fb 03 00 00       	push   $0x3fb
80106328:	e8 8e ff ff ff       	call   801062bb <outb>
8010632d:	83 c4 08             	add    $0x8,%esp
  outb(COM1+4, 0);
80106330:	6a 00                	push   $0x0
80106332:	68 fc 03 00 00       	push   $0x3fc
80106337:	e8 7f ff ff ff       	call   801062bb <outb>
8010633c:	83 c4 08             	add    $0x8,%esp
  outb(COM1+1, 0x01);    // Enable receive interrupts.
8010633f:	6a 01                	push   $0x1
80106341:	68 f9 03 00 00       	push   $0x3f9
80106346:	e8 70 ff ff ff       	call   801062bb <outb>
8010634b:	83 c4 08             	add    $0x8,%esp

  // If status is 0xFF, no serial port.
  if(inb(COM1+5) == 0xFF)
8010634e:	68 fd 03 00 00       	push   $0x3fd
80106353:	e8 46 ff ff ff       	call   8010629e <inb>
80106358:	83 c4 04             	add    $0x4,%esp
8010635b:	3c ff                	cmp    $0xff,%al
8010635d:	74 61                	je     801063c0 <uartinit+0xe4>
    return;
  uart = 1;
8010635f:	c7 05 78 69 19 80 01 	movl   $0x1,0x80196978
80106366:	00 00 00 

  // Acknowledge pre-existing interrupt conditions;
  // enable interrupts.
  inb(COM1+2);
80106369:	68 fa 03 00 00       	push   $0x3fa
8010636e:	e8 2b ff ff ff       	call   8010629e <inb>
80106373:	83 c4 04             	add    $0x4,%esp
  inb(COM1+0);
80106376:	68 f8 03 00 00       	push   $0x3f8
8010637b:	e8 1e ff ff ff       	call   8010629e <inb>
80106380:	83 c4 04             	add    $0x4,%esp
  ioapicenable(IRQ_COM1, 0);
80106383:	83 ec 08             	sub    $0x8,%esp
80106386:	6a 00                	push   $0x0
80106388:	6a 04                	push   $0x4
8010638a:	e8 9f c2 ff ff       	call   8010262e <ioapicenable>
8010638f:	83 c4 10             	add    $0x10,%esp

  // Announce that we're here.
  for(p="xv6...\n"; *p; p++)
80106392:	c7 45 f4 9c a6 10 80 	movl   $0x8010a69c,-0xc(%ebp)
80106399:	eb 19                	jmp    801063b4 <uartinit+0xd8>
    uartputc(*p);
8010639b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010639e:	0f b6 00             	movzbl (%eax),%eax
801063a1:	0f be c0             	movsbl %al,%eax
801063a4:	83 ec 0c             	sub    $0xc,%esp
801063a7:	50                   	push   %eax
801063a8:	e8 16 00 00 00       	call   801063c3 <uartputc>
801063ad:	83 c4 10             	add    $0x10,%esp
  for(p="xv6...\n"; *p; p++)
801063b0:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
801063b4:	8b 45 f4             	mov    -0xc(%ebp),%eax
801063b7:	0f b6 00             	movzbl (%eax),%eax
801063ba:	84 c0                	test   %al,%al
801063bc:	75 dd                	jne    8010639b <uartinit+0xbf>
801063be:	eb 01                	jmp    801063c1 <uartinit+0xe5>
    return;
801063c0:	90                   	nop
}
801063c1:	c9                   	leave  
801063c2:	c3                   	ret    

801063c3 <uartputc>:

void
uartputc(int c)
{
801063c3:	55                   	push   %ebp
801063c4:	89 e5                	mov    %esp,%ebp
801063c6:	83 ec 18             	sub    $0x18,%esp
  int i;

  if(!uart)
801063c9:	a1 78 69 19 80       	mov    0x80196978,%eax
801063ce:	85 c0                	test   %eax,%eax
801063d0:	74 53                	je     80106425 <uartputc+0x62>
    return;
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
801063d2:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
801063d9:	eb 11                	jmp    801063ec <uartputc+0x29>
    microdelay(10);
801063db:	83 ec 0c             	sub    $0xc,%esp
801063de:	6a 0a                	push   $0xa
801063e0:	e8 52 c7 ff ff       	call   80102b37 <microdelay>
801063e5:	83 c4 10             	add    $0x10,%esp
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
801063e8:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
801063ec:	83 7d f4 7f          	cmpl   $0x7f,-0xc(%ebp)
801063f0:	7f 1a                	jg     8010640c <uartputc+0x49>
801063f2:	83 ec 0c             	sub    $0xc,%esp
801063f5:	68 fd 03 00 00       	push   $0x3fd
801063fa:	e8 9f fe ff ff       	call   8010629e <inb>
801063ff:	83 c4 10             	add    $0x10,%esp
80106402:	0f b6 c0             	movzbl %al,%eax
80106405:	83 e0 20             	and    $0x20,%eax
80106408:	85 c0                	test   %eax,%eax
8010640a:	74 cf                	je     801063db <uartputc+0x18>
  outb(COM1+0, c);
8010640c:	8b 45 08             	mov    0x8(%ebp),%eax
8010640f:	0f b6 c0             	movzbl %al,%eax
80106412:	83 ec 08             	sub    $0x8,%esp
80106415:	50                   	push   %eax
80106416:	68 f8 03 00 00       	push   $0x3f8
8010641b:	e8 9b fe ff ff       	call   801062bb <outb>
80106420:	83 c4 10             	add    $0x10,%esp
80106423:	eb 01                	jmp    80106426 <uartputc+0x63>
    return;
80106425:	90                   	nop
}
80106426:	c9                   	leave  
80106427:	c3                   	ret    

80106428 <uartgetc>:

static int
uartgetc(void)
{
80106428:	55                   	push   %ebp
80106429:	89 e5                	mov    %esp,%ebp
  if(!uart)
8010642b:	a1 78 69 19 80       	mov    0x80196978,%eax
80106430:	85 c0                	test   %eax,%eax
80106432:	75 07                	jne    8010643b <uartgetc+0x13>
    return -1;
80106434:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106439:	eb 2e                	jmp    80106469 <uartgetc+0x41>
  if(!(inb(COM1+5) & 0x01))
8010643b:	68 fd 03 00 00       	push   $0x3fd
80106440:	e8 59 fe ff ff       	call   8010629e <inb>
80106445:	83 c4 04             	add    $0x4,%esp
80106448:	0f b6 c0             	movzbl %al,%eax
8010644b:	83 e0 01             	and    $0x1,%eax
8010644e:	85 c0                	test   %eax,%eax
80106450:	75 07                	jne    80106459 <uartgetc+0x31>
    return -1;
80106452:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106457:	eb 10                	jmp    80106469 <uartgetc+0x41>
  return inb(COM1+0);
80106459:	68 f8 03 00 00       	push   $0x3f8
8010645e:	e8 3b fe ff ff       	call   8010629e <inb>
80106463:	83 c4 04             	add    $0x4,%esp
80106466:	0f b6 c0             	movzbl %al,%eax
}
80106469:	c9                   	leave  
8010646a:	c3                   	ret    

8010646b <uartintr>:

void
uartintr(void)
{
8010646b:	55                   	push   %ebp
8010646c:	89 e5                	mov    %esp,%ebp
8010646e:	83 ec 08             	sub    $0x8,%esp
  consoleintr(uartgetc);
80106471:	83 ec 0c             	sub    $0xc,%esp
80106474:	68 28 64 10 80       	push   $0x80106428
80106479:	e8 58 a3 ff ff       	call   801007d6 <consoleintr>
8010647e:	83 c4 10             	add    $0x10,%esp
}
80106481:	90                   	nop
80106482:	c9                   	leave  
80106483:	c3                   	ret    

80106484 <vector0>:
80106484:	6a 00                	push   $0x0
80106486:	6a 00                	push   $0x0
80106488:	e9 c2 f9 ff ff       	jmp    80105e4f <alltraps>

8010648d <vector1>:
8010648d:	6a 00                	push   $0x0
8010648f:	6a 01                	push   $0x1
80106491:	e9 b9 f9 ff ff       	jmp    80105e4f <alltraps>

80106496 <vector2>:
80106496:	6a 00                	push   $0x0
80106498:	6a 02                	push   $0x2
8010649a:	e9 b0 f9 ff ff       	jmp    80105e4f <alltraps>

8010649f <vector3>:
8010649f:	6a 00                	push   $0x0
801064a1:	6a 03                	push   $0x3
801064a3:	e9 a7 f9 ff ff       	jmp    80105e4f <alltraps>

801064a8 <vector4>:
801064a8:	6a 00                	push   $0x0
801064aa:	6a 04                	push   $0x4
801064ac:	e9 9e f9 ff ff       	jmp    80105e4f <alltraps>

801064b1 <vector5>:
801064b1:	6a 00                	push   $0x0
801064b3:	6a 05                	push   $0x5
801064b5:	e9 95 f9 ff ff       	jmp    80105e4f <alltraps>

801064ba <vector6>:
801064ba:	6a 00                	push   $0x0
801064bc:	6a 06                	push   $0x6
801064be:	e9 8c f9 ff ff       	jmp    80105e4f <alltraps>

801064c3 <vector7>:
801064c3:	6a 00                	push   $0x0
801064c5:	6a 07                	push   $0x7
801064c7:	e9 83 f9 ff ff       	jmp    80105e4f <alltraps>

801064cc <vector8>:
801064cc:	6a 08                	push   $0x8
801064ce:	e9 7c f9 ff ff       	jmp    80105e4f <alltraps>

801064d3 <vector9>:
801064d3:	6a 00                	push   $0x0
801064d5:	6a 09                	push   $0x9
801064d7:	e9 73 f9 ff ff       	jmp    80105e4f <alltraps>

801064dc <vector10>:
801064dc:	6a 0a                	push   $0xa
801064de:	e9 6c f9 ff ff       	jmp    80105e4f <alltraps>

801064e3 <vector11>:
801064e3:	6a 0b                	push   $0xb
801064e5:	e9 65 f9 ff ff       	jmp    80105e4f <alltraps>

801064ea <vector12>:
801064ea:	6a 0c                	push   $0xc
801064ec:	e9 5e f9 ff ff       	jmp    80105e4f <alltraps>

801064f1 <vector13>:
801064f1:	6a 0d                	push   $0xd
801064f3:	e9 57 f9 ff ff       	jmp    80105e4f <alltraps>

801064f8 <vector14>:
801064f8:	6a 0e                	push   $0xe
801064fa:	e9 50 f9 ff ff       	jmp    80105e4f <alltraps>

801064ff <vector15>:
801064ff:	6a 00                	push   $0x0
80106501:	6a 0f                	push   $0xf
80106503:	e9 47 f9 ff ff       	jmp    80105e4f <alltraps>

80106508 <vector16>:
80106508:	6a 00                	push   $0x0
8010650a:	6a 10                	push   $0x10
8010650c:	e9 3e f9 ff ff       	jmp    80105e4f <alltraps>

80106511 <vector17>:
80106511:	6a 11                	push   $0x11
80106513:	e9 37 f9 ff ff       	jmp    80105e4f <alltraps>

80106518 <vector18>:
80106518:	6a 00                	push   $0x0
8010651a:	6a 12                	push   $0x12
8010651c:	e9 2e f9 ff ff       	jmp    80105e4f <alltraps>

80106521 <vector19>:
80106521:	6a 00                	push   $0x0
80106523:	6a 13                	push   $0x13
80106525:	e9 25 f9 ff ff       	jmp    80105e4f <alltraps>

8010652a <vector20>:
8010652a:	6a 00                	push   $0x0
8010652c:	6a 14                	push   $0x14
8010652e:	e9 1c f9 ff ff       	jmp    80105e4f <alltraps>

80106533 <vector21>:
80106533:	6a 00                	push   $0x0
80106535:	6a 15                	push   $0x15
80106537:	e9 13 f9 ff ff       	jmp    80105e4f <alltraps>

8010653c <vector22>:
8010653c:	6a 00                	push   $0x0
8010653e:	6a 16                	push   $0x16
80106540:	e9 0a f9 ff ff       	jmp    80105e4f <alltraps>

80106545 <vector23>:
80106545:	6a 00                	push   $0x0
80106547:	6a 17                	push   $0x17
80106549:	e9 01 f9 ff ff       	jmp    80105e4f <alltraps>

8010654e <vector24>:
8010654e:	6a 00                	push   $0x0
80106550:	6a 18                	push   $0x18
80106552:	e9 f8 f8 ff ff       	jmp    80105e4f <alltraps>

80106557 <vector25>:
80106557:	6a 00                	push   $0x0
80106559:	6a 19                	push   $0x19
8010655b:	e9 ef f8 ff ff       	jmp    80105e4f <alltraps>

80106560 <vector26>:
80106560:	6a 00                	push   $0x0
80106562:	6a 1a                	push   $0x1a
80106564:	e9 e6 f8 ff ff       	jmp    80105e4f <alltraps>

80106569 <vector27>:
80106569:	6a 00                	push   $0x0
8010656b:	6a 1b                	push   $0x1b
8010656d:	e9 dd f8 ff ff       	jmp    80105e4f <alltraps>

80106572 <vector28>:
80106572:	6a 00                	push   $0x0
80106574:	6a 1c                	push   $0x1c
80106576:	e9 d4 f8 ff ff       	jmp    80105e4f <alltraps>

8010657b <vector29>:
8010657b:	6a 00                	push   $0x0
8010657d:	6a 1d                	push   $0x1d
8010657f:	e9 cb f8 ff ff       	jmp    80105e4f <alltraps>

80106584 <vector30>:
80106584:	6a 00                	push   $0x0
80106586:	6a 1e                	push   $0x1e
80106588:	e9 c2 f8 ff ff       	jmp    80105e4f <alltraps>

8010658d <vector31>:
8010658d:	6a 00                	push   $0x0
8010658f:	6a 1f                	push   $0x1f
80106591:	e9 b9 f8 ff ff       	jmp    80105e4f <alltraps>

80106596 <vector32>:
80106596:	6a 00                	push   $0x0
80106598:	6a 20                	push   $0x20
8010659a:	e9 b0 f8 ff ff       	jmp    80105e4f <alltraps>

8010659f <vector33>:
8010659f:	6a 00                	push   $0x0
801065a1:	6a 21                	push   $0x21
801065a3:	e9 a7 f8 ff ff       	jmp    80105e4f <alltraps>

801065a8 <vector34>:
801065a8:	6a 00                	push   $0x0
801065aa:	6a 22                	push   $0x22
801065ac:	e9 9e f8 ff ff       	jmp    80105e4f <alltraps>

801065b1 <vector35>:
801065b1:	6a 00                	push   $0x0
801065b3:	6a 23                	push   $0x23
801065b5:	e9 95 f8 ff ff       	jmp    80105e4f <alltraps>

801065ba <vector36>:
801065ba:	6a 00                	push   $0x0
801065bc:	6a 24                	push   $0x24
801065be:	e9 8c f8 ff ff       	jmp    80105e4f <alltraps>

801065c3 <vector37>:
801065c3:	6a 00                	push   $0x0
801065c5:	6a 25                	push   $0x25
801065c7:	e9 83 f8 ff ff       	jmp    80105e4f <alltraps>

801065cc <vector38>:
801065cc:	6a 00                	push   $0x0
801065ce:	6a 26                	push   $0x26
801065d0:	e9 7a f8 ff ff       	jmp    80105e4f <alltraps>

801065d5 <vector39>:
801065d5:	6a 00                	push   $0x0
801065d7:	6a 27                	push   $0x27
801065d9:	e9 71 f8 ff ff       	jmp    80105e4f <alltraps>

801065de <vector40>:
801065de:	6a 00                	push   $0x0
801065e0:	6a 28                	push   $0x28
801065e2:	e9 68 f8 ff ff       	jmp    80105e4f <alltraps>

801065e7 <vector41>:
801065e7:	6a 00                	push   $0x0
801065e9:	6a 29                	push   $0x29
801065eb:	e9 5f f8 ff ff       	jmp    80105e4f <alltraps>

801065f0 <vector42>:
801065f0:	6a 00                	push   $0x0
801065f2:	6a 2a                	push   $0x2a
801065f4:	e9 56 f8 ff ff       	jmp    80105e4f <alltraps>

801065f9 <vector43>:
801065f9:	6a 00                	push   $0x0
801065fb:	6a 2b                	push   $0x2b
801065fd:	e9 4d f8 ff ff       	jmp    80105e4f <alltraps>

80106602 <vector44>:
80106602:	6a 00                	push   $0x0
80106604:	6a 2c                	push   $0x2c
80106606:	e9 44 f8 ff ff       	jmp    80105e4f <alltraps>

8010660b <vector45>:
8010660b:	6a 00                	push   $0x0
8010660d:	6a 2d                	push   $0x2d
8010660f:	e9 3b f8 ff ff       	jmp    80105e4f <alltraps>

80106614 <vector46>:
80106614:	6a 00                	push   $0x0
80106616:	6a 2e                	push   $0x2e
80106618:	e9 32 f8 ff ff       	jmp    80105e4f <alltraps>

8010661d <vector47>:
8010661d:	6a 00                	push   $0x0
8010661f:	6a 2f                	push   $0x2f
80106621:	e9 29 f8 ff ff       	jmp    80105e4f <alltraps>

80106626 <vector48>:
80106626:	6a 00                	push   $0x0
80106628:	6a 30                	push   $0x30
8010662a:	e9 20 f8 ff ff       	jmp    80105e4f <alltraps>

8010662f <vector49>:
8010662f:	6a 00                	push   $0x0
80106631:	6a 31                	push   $0x31
80106633:	e9 17 f8 ff ff       	jmp    80105e4f <alltraps>

80106638 <vector50>:
80106638:	6a 00                	push   $0x0
8010663a:	6a 32                	push   $0x32
8010663c:	e9 0e f8 ff ff       	jmp    80105e4f <alltraps>

80106641 <vector51>:
80106641:	6a 00                	push   $0x0
80106643:	6a 33                	push   $0x33
80106645:	e9 05 f8 ff ff       	jmp    80105e4f <alltraps>

8010664a <vector52>:
8010664a:	6a 00                	push   $0x0
8010664c:	6a 34                	push   $0x34
8010664e:	e9 fc f7 ff ff       	jmp    80105e4f <alltraps>

80106653 <vector53>:
80106653:	6a 00                	push   $0x0
80106655:	6a 35                	push   $0x35
80106657:	e9 f3 f7 ff ff       	jmp    80105e4f <alltraps>

8010665c <vector54>:
8010665c:	6a 00                	push   $0x0
8010665e:	6a 36                	push   $0x36
80106660:	e9 ea f7 ff ff       	jmp    80105e4f <alltraps>

80106665 <vector55>:
80106665:	6a 00                	push   $0x0
80106667:	6a 37                	push   $0x37
80106669:	e9 e1 f7 ff ff       	jmp    80105e4f <alltraps>

8010666e <vector56>:
8010666e:	6a 00                	push   $0x0
80106670:	6a 38                	push   $0x38
80106672:	e9 d8 f7 ff ff       	jmp    80105e4f <alltraps>

80106677 <vector57>:
80106677:	6a 00                	push   $0x0
80106679:	6a 39                	push   $0x39
8010667b:	e9 cf f7 ff ff       	jmp    80105e4f <alltraps>

80106680 <vector58>:
80106680:	6a 00                	push   $0x0
80106682:	6a 3a                	push   $0x3a
80106684:	e9 c6 f7 ff ff       	jmp    80105e4f <alltraps>

80106689 <vector59>:
80106689:	6a 00                	push   $0x0
8010668b:	6a 3b                	push   $0x3b
8010668d:	e9 bd f7 ff ff       	jmp    80105e4f <alltraps>

80106692 <vector60>:
80106692:	6a 00                	push   $0x0
80106694:	6a 3c                	push   $0x3c
80106696:	e9 b4 f7 ff ff       	jmp    80105e4f <alltraps>

8010669b <vector61>:
8010669b:	6a 00                	push   $0x0
8010669d:	6a 3d                	push   $0x3d
8010669f:	e9 ab f7 ff ff       	jmp    80105e4f <alltraps>

801066a4 <vector62>:
801066a4:	6a 00                	push   $0x0
801066a6:	6a 3e                	push   $0x3e
801066a8:	e9 a2 f7 ff ff       	jmp    80105e4f <alltraps>

801066ad <vector63>:
801066ad:	6a 00                	push   $0x0
801066af:	6a 3f                	push   $0x3f
801066b1:	e9 99 f7 ff ff       	jmp    80105e4f <alltraps>

801066b6 <vector64>:
801066b6:	6a 00                	push   $0x0
801066b8:	6a 40                	push   $0x40
801066ba:	e9 90 f7 ff ff       	jmp    80105e4f <alltraps>

801066bf <vector65>:
801066bf:	6a 00                	push   $0x0
801066c1:	6a 41                	push   $0x41
801066c3:	e9 87 f7 ff ff       	jmp    80105e4f <alltraps>

801066c8 <vector66>:
801066c8:	6a 00                	push   $0x0
801066ca:	6a 42                	push   $0x42
801066cc:	e9 7e f7 ff ff       	jmp    80105e4f <alltraps>

801066d1 <vector67>:
801066d1:	6a 00                	push   $0x0
801066d3:	6a 43                	push   $0x43
801066d5:	e9 75 f7 ff ff       	jmp    80105e4f <alltraps>

801066da <vector68>:
801066da:	6a 00                	push   $0x0
801066dc:	6a 44                	push   $0x44
801066de:	e9 6c f7 ff ff       	jmp    80105e4f <alltraps>

801066e3 <vector69>:
801066e3:	6a 00                	push   $0x0
801066e5:	6a 45                	push   $0x45
801066e7:	e9 63 f7 ff ff       	jmp    80105e4f <alltraps>

801066ec <vector70>:
801066ec:	6a 00                	push   $0x0
801066ee:	6a 46                	push   $0x46
801066f0:	e9 5a f7 ff ff       	jmp    80105e4f <alltraps>

801066f5 <vector71>:
801066f5:	6a 00                	push   $0x0
801066f7:	6a 47                	push   $0x47
801066f9:	e9 51 f7 ff ff       	jmp    80105e4f <alltraps>

801066fe <vector72>:
801066fe:	6a 00                	push   $0x0
80106700:	6a 48                	push   $0x48
80106702:	e9 48 f7 ff ff       	jmp    80105e4f <alltraps>

80106707 <vector73>:
80106707:	6a 00                	push   $0x0
80106709:	6a 49                	push   $0x49
8010670b:	e9 3f f7 ff ff       	jmp    80105e4f <alltraps>

80106710 <vector74>:
80106710:	6a 00                	push   $0x0
80106712:	6a 4a                	push   $0x4a
80106714:	e9 36 f7 ff ff       	jmp    80105e4f <alltraps>

80106719 <vector75>:
80106719:	6a 00                	push   $0x0
8010671b:	6a 4b                	push   $0x4b
8010671d:	e9 2d f7 ff ff       	jmp    80105e4f <alltraps>

80106722 <vector76>:
80106722:	6a 00                	push   $0x0
80106724:	6a 4c                	push   $0x4c
80106726:	e9 24 f7 ff ff       	jmp    80105e4f <alltraps>

8010672b <vector77>:
8010672b:	6a 00                	push   $0x0
8010672d:	6a 4d                	push   $0x4d
8010672f:	e9 1b f7 ff ff       	jmp    80105e4f <alltraps>

80106734 <vector78>:
80106734:	6a 00                	push   $0x0
80106736:	6a 4e                	push   $0x4e
80106738:	e9 12 f7 ff ff       	jmp    80105e4f <alltraps>

8010673d <vector79>:
8010673d:	6a 00                	push   $0x0
8010673f:	6a 4f                	push   $0x4f
80106741:	e9 09 f7 ff ff       	jmp    80105e4f <alltraps>

80106746 <vector80>:
80106746:	6a 00                	push   $0x0
80106748:	6a 50                	push   $0x50
8010674a:	e9 00 f7 ff ff       	jmp    80105e4f <alltraps>

8010674f <vector81>:
8010674f:	6a 00                	push   $0x0
80106751:	6a 51                	push   $0x51
80106753:	e9 f7 f6 ff ff       	jmp    80105e4f <alltraps>

80106758 <vector82>:
80106758:	6a 00                	push   $0x0
8010675a:	6a 52                	push   $0x52
8010675c:	e9 ee f6 ff ff       	jmp    80105e4f <alltraps>

80106761 <vector83>:
80106761:	6a 00                	push   $0x0
80106763:	6a 53                	push   $0x53
80106765:	e9 e5 f6 ff ff       	jmp    80105e4f <alltraps>

8010676a <vector84>:
8010676a:	6a 00                	push   $0x0
8010676c:	6a 54                	push   $0x54
8010676e:	e9 dc f6 ff ff       	jmp    80105e4f <alltraps>

80106773 <vector85>:
80106773:	6a 00                	push   $0x0
80106775:	6a 55                	push   $0x55
80106777:	e9 d3 f6 ff ff       	jmp    80105e4f <alltraps>

8010677c <vector86>:
8010677c:	6a 00                	push   $0x0
8010677e:	6a 56                	push   $0x56
80106780:	e9 ca f6 ff ff       	jmp    80105e4f <alltraps>

80106785 <vector87>:
80106785:	6a 00                	push   $0x0
80106787:	6a 57                	push   $0x57
80106789:	e9 c1 f6 ff ff       	jmp    80105e4f <alltraps>

8010678e <vector88>:
8010678e:	6a 00                	push   $0x0
80106790:	6a 58                	push   $0x58
80106792:	e9 b8 f6 ff ff       	jmp    80105e4f <alltraps>

80106797 <vector89>:
80106797:	6a 00                	push   $0x0
80106799:	6a 59                	push   $0x59
8010679b:	e9 af f6 ff ff       	jmp    80105e4f <alltraps>

801067a0 <vector90>:
801067a0:	6a 00                	push   $0x0
801067a2:	6a 5a                	push   $0x5a
801067a4:	e9 a6 f6 ff ff       	jmp    80105e4f <alltraps>

801067a9 <vector91>:
801067a9:	6a 00                	push   $0x0
801067ab:	6a 5b                	push   $0x5b
801067ad:	e9 9d f6 ff ff       	jmp    80105e4f <alltraps>

801067b2 <vector92>:
801067b2:	6a 00                	push   $0x0
801067b4:	6a 5c                	push   $0x5c
801067b6:	e9 94 f6 ff ff       	jmp    80105e4f <alltraps>

801067bb <vector93>:
801067bb:	6a 00                	push   $0x0
801067bd:	6a 5d                	push   $0x5d
801067bf:	e9 8b f6 ff ff       	jmp    80105e4f <alltraps>

801067c4 <vector94>:
801067c4:	6a 00                	push   $0x0
801067c6:	6a 5e                	push   $0x5e
801067c8:	e9 82 f6 ff ff       	jmp    80105e4f <alltraps>

801067cd <vector95>:
801067cd:	6a 00                	push   $0x0
801067cf:	6a 5f                	push   $0x5f
801067d1:	e9 79 f6 ff ff       	jmp    80105e4f <alltraps>

801067d6 <vector96>:
801067d6:	6a 00                	push   $0x0
801067d8:	6a 60                	push   $0x60
801067da:	e9 70 f6 ff ff       	jmp    80105e4f <alltraps>

801067df <vector97>:
801067df:	6a 00                	push   $0x0
801067e1:	6a 61                	push   $0x61
801067e3:	e9 67 f6 ff ff       	jmp    80105e4f <alltraps>

801067e8 <vector98>:
801067e8:	6a 00                	push   $0x0
801067ea:	6a 62                	push   $0x62
801067ec:	e9 5e f6 ff ff       	jmp    80105e4f <alltraps>

801067f1 <vector99>:
801067f1:	6a 00                	push   $0x0
801067f3:	6a 63                	push   $0x63
801067f5:	e9 55 f6 ff ff       	jmp    80105e4f <alltraps>

801067fa <vector100>:
801067fa:	6a 00                	push   $0x0
801067fc:	6a 64                	push   $0x64
801067fe:	e9 4c f6 ff ff       	jmp    80105e4f <alltraps>

80106803 <vector101>:
80106803:	6a 00                	push   $0x0
80106805:	6a 65                	push   $0x65
80106807:	e9 43 f6 ff ff       	jmp    80105e4f <alltraps>

8010680c <vector102>:
8010680c:	6a 00                	push   $0x0
8010680e:	6a 66                	push   $0x66
80106810:	e9 3a f6 ff ff       	jmp    80105e4f <alltraps>

80106815 <vector103>:
80106815:	6a 00                	push   $0x0
80106817:	6a 67                	push   $0x67
80106819:	e9 31 f6 ff ff       	jmp    80105e4f <alltraps>

8010681e <vector104>:
8010681e:	6a 00                	push   $0x0
80106820:	6a 68                	push   $0x68
80106822:	e9 28 f6 ff ff       	jmp    80105e4f <alltraps>

80106827 <vector105>:
80106827:	6a 00                	push   $0x0
80106829:	6a 69                	push   $0x69
8010682b:	e9 1f f6 ff ff       	jmp    80105e4f <alltraps>

80106830 <vector106>:
80106830:	6a 00                	push   $0x0
80106832:	6a 6a                	push   $0x6a
80106834:	e9 16 f6 ff ff       	jmp    80105e4f <alltraps>

80106839 <vector107>:
80106839:	6a 00                	push   $0x0
8010683b:	6a 6b                	push   $0x6b
8010683d:	e9 0d f6 ff ff       	jmp    80105e4f <alltraps>

80106842 <vector108>:
80106842:	6a 00                	push   $0x0
80106844:	6a 6c                	push   $0x6c
80106846:	e9 04 f6 ff ff       	jmp    80105e4f <alltraps>

8010684b <vector109>:
8010684b:	6a 00                	push   $0x0
8010684d:	6a 6d                	push   $0x6d
8010684f:	e9 fb f5 ff ff       	jmp    80105e4f <alltraps>

80106854 <vector110>:
80106854:	6a 00                	push   $0x0
80106856:	6a 6e                	push   $0x6e
80106858:	e9 f2 f5 ff ff       	jmp    80105e4f <alltraps>

8010685d <vector111>:
8010685d:	6a 00                	push   $0x0
8010685f:	6a 6f                	push   $0x6f
80106861:	e9 e9 f5 ff ff       	jmp    80105e4f <alltraps>

80106866 <vector112>:
80106866:	6a 00                	push   $0x0
80106868:	6a 70                	push   $0x70
8010686a:	e9 e0 f5 ff ff       	jmp    80105e4f <alltraps>

8010686f <vector113>:
8010686f:	6a 00                	push   $0x0
80106871:	6a 71                	push   $0x71
80106873:	e9 d7 f5 ff ff       	jmp    80105e4f <alltraps>

80106878 <vector114>:
80106878:	6a 00                	push   $0x0
8010687a:	6a 72                	push   $0x72
8010687c:	e9 ce f5 ff ff       	jmp    80105e4f <alltraps>

80106881 <vector115>:
80106881:	6a 00                	push   $0x0
80106883:	6a 73                	push   $0x73
80106885:	e9 c5 f5 ff ff       	jmp    80105e4f <alltraps>

8010688a <vector116>:
8010688a:	6a 00                	push   $0x0
8010688c:	6a 74                	push   $0x74
8010688e:	e9 bc f5 ff ff       	jmp    80105e4f <alltraps>

80106893 <vector117>:
80106893:	6a 00                	push   $0x0
80106895:	6a 75                	push   $0x75
80106897:	e9 b3 f5 ff ff       	jmp    80105e4f <alltraps>

8010689c <vector118>:
8010689c:	6a 00                	push   $0x0
8010689e:	6a 76                	push   $0x76
801068a0:	e9 aa f5 ff ff       	jmp    80105e4f <alltraps>

801068a5 <vector119>:
801068a5:	6a 00                	push   $0x0
801068a7:	6a 77                	push   $0x77
801068a9:	e9 a1 f5 ff ff       	jmp    80105e4f <alltraps>

801068ae <vector120>:
801068ae:	6a 00                	push   $0x0
801068b0:	6a 78                	push   $0x78
801068b2:	e9 98 f5 ff ff       	jmp    80105e4f <alltraps>

801068b7 <vector121>:
801068b7:	6a 00                	push   $0x0
801068b9:	6a 79                	push   $0x79
801068bb:	e9 8f f5 ff ff       	jmp    80105e4f <alltraps>

801068c0 <vector122>:
801068c0:	6a 00                	push   $0x0
801068c2:	6a 7a                	push   $0x7a
801068c4:	e9 86 f5 ff ff       	jmp    80105e4f <alltraps>

801068c9 <vector123>:
801068c9:	6a 00                	push   $0x0
801068cb:	6a 7b                	push   $0x7b
801068cd:	e9 7d f5 ff ff       	jmp    80105e4f <alltraps>

801068d2 <vector124>:
801068d2:	6a 00                	push   $0x0
801068d4:	6a 7c                	push   $0x7c
801068d6:	e9 74 f5 ff ff       	jmp    80105e4f <alltraps>

801068db <vector125>:
801068db:	6a 00                	push   $0x0
801068dd:	6a 7d                	push   $0x7d
801068df:	e9 6b f5 ff ff       	jmp    80105e4f <alltraps>

801068e4 <vector126>:
801068e4:	6a 00                	push   $0x0
801068e6:	6a 7e                	push   $0x7e
801068e8:	e9 62 f5 ff ff       	jmp    80105e4f <alltraps>

801068ed <vector127>:
801068ed:	6a 00                	push   $0x0
801068ef:	6a 7f                	push   $0x7f
801068f1:	e9 59 f5 ff ff       	jmp    80105e4f <alltraps>

801068f6 <vector128>:
801068f6:	6a 00                	push   $0x0
801068f8:	68 80 00 00 00       	push   $0x80
801068fd:	e9 4d f5 ff ff       	jmp    80105e4f <alltraps>

80106902 <vector129>:
80106902:	6a 00                	push   $0x0
80106904:	68 81 00 00 00       	push   $0x81
80106909:	e9 41 f5 ff ff       	jmp    80105e4f <alltraps>

8010690e <vector130>:
8010690e:	6a 00                	push   $0x0
80106910:	68 82 00 00 00       	push   $0x82
80106915:	e9 35 f5 ff ff       	jmp    80105e4f <alltraps>

8010691a <vector131>:
8010691a:	6a 00                	push   $0x0
8010691c:	68 83 00 00 00       	push   $0x83
80106921:	e9 29 f5 ff ff       	jmp    80105e4f <alltraps>

80106926 <vector132>:
80106926:	6a 00                	push   $0x0
80106928:	68 84 00 00 00       	push   $0x84
8010692d:	e9 1d f5 ff ff       	jmp    80105e4f <alltraps>

80106932 <vector133>:
80106932:	6a 00                	push   $0x0
80106934:	68 85 00 00 00       	push   $0x85
80106939:	e9 11 f5 ff ff       	jmp    80105e4f <alltraps>

8010693e <vector134>:
8010693e:	6a 00                	push   $0x0
80106940:	68 86 00 00 00       	push   $0x86
80106945:	e9 05 f5 ff ff       	jmp    80105e4f <alltraps>

8010694a <vector135>:
8010694a:	6a 00                	push   $0x0
8010694c:	68 87 00 00 00       	push   $0x87
80106951:	e9 f9 f4 ff ff       	jmp    80105e4f <alltraps>

80106956 <vector136>:
80106956:	6a 00                	push   $0x0
80106958:	68 88 00 00 00       	push   $0x88
8010695d:	e9 ed f4 ff ff       	jmp    80105e4f <alltraps>

80106962 <vector137>:
80106962:	6a 00                	push   $0x0
80106964:	68 89 00 00 00       	push   $0x89
80106969:	e9 e1 f4 ff ff       	jmp    80105e4f <alltraps>

8010696e <vector138>:
8010696e:	6a 00                	push   $0x0
80106970:	68 8a 00 00 00       	push   $0x8a
80106975:	e9 d5 f4 ff ff       	jmp    80105e4f <alltraps>

8010697a <vector139>:
8010697a:	6a 00                	push   $0x0
8010697c:	68 8b 00 00 00       	push   $0x8b
80106981:	e9 c9 f4 ff ff       	jmp    80105e4f <alltraps>

80106986 <vector140>:
80106986:	6a 00                	push   $0x0
80106988:	68 8c 00 00 00       	push   $0x8c
8010698d:	e9 bd f4 ff ff       	jmp    80105e4f <alltraps>

80106992 <vector141>:
80106992:	6a 00                	push   $0x0
80106994:	68 8d 00 00 00       	push   $0x8d
80106999:	e9 b1 f4 ff ff       	jmp    80105e4f <alltraps>

8010699e <vector142>:
8010699e:	6a 00                	push   $0x0
801069a0:	68 8e 00 00 00       	push   $0x8e
801069a5:	e9 a5 f4 ff ff       	jmp    80105e4f <alltraps>

801069aa <vector143>:
801069aa:	6a 00                	push   $0x0
801069ac:	68 8f 00 00 00       	push   $0x8f
801069b1:	e9 99 f4 ff ff       	jmp    80105e4f <alltraps>

801069b6 <vector144>:
801069b6:	6a 00                	push   $0x0
801069b8:	68 90 00 00 00       	push   $0x90
801069bd:	e9 8d f4 ff ff       	jmp    80105e4f <alltraps>

801069c2 <vector145>:
801069c2:	6a 00                	push   $0x0
801069c4:	68 91 00 00 00       	push   $0x91
801069c9:	e9 81 f4 ff ff       	jmp    80105e4f <alltraps>

801069ce <vector146>:
801069ce:	6a 00                	push   $0x0
801069d0:	68 92 00 00 00       	push   $0x92
801069d5:	e9 75 f4 ff ff       	jmp    80105e4f <alltraps>

801069da <vector147>:
801069da:	6a 00                	push   $0x0
801069dc:	68 93 00 00 00       	push   $0x93
801069e1:	e9 69 f4 ff ff       	jmp    80105e4f <alltraps>

801069e6 <vector148>:
801069e6:	6a 00                	push   $0x0
801069e8:	68 94 00 00 00       	push   $0x94
801069ed:	e9 5d f4 ff ff       	jmp    80105e4f <alltraps>

801069f2 <vector149>:
801069f2:	6a 00                	push   $0x0
801069f4:	68 95 00 00 00       	push   $0x95
801069f9:	e9 51 f4 ff ff       	jmp    80105e4f <alltraps>

801069fe <vector150>:
801069fe:	6a 00                	push   $0x0
80106a00:	68 96 00 00 00       	push   $0x96
80106a05:	e9 45 f4 ff ff       	jmp    80105e4f <alltraps>

80106a0a <vector151>:
80106a0a:	6a 00                	push   $0x0
80106a0c:	68 97 00 00 00       	push   $0x97
80106a11:	e9 39 f4 ff ff       	jmp    80105e4f <alltraps>

80106a16 <vector152>:
80106a16:	6a 00                	push   $0x0
80106a18:	68 98 00 00 00       	push   $0x98
80106a1d:	e9 2d f4 ff ff       	jmp    80105e4f <alltraps>

80106a22 <vector153>:
80106a22:	6a 00                	push   $0x0
80106a24:	68 99 00 00 00       	push   $0x99
80106a29:	e9 21 f4 ff ff       	jmp    80105e4f <alltraps>

80106a2e <vector154>:
80106a2e:	6a 00                	push   $0x0
80106a30:	68 9a 00 00 00       	push   $0x9a
80106a35:	e9 15 f4 ff ff       	jmp    80105e4f <alltraps>

80106a3a <vector155>:
80106a3a:	6a 00                	push   $0x0
80106a3c:	68 9b 00 00 00       	push   $0x9b
80106a41:	e9 09 f4 ff ff       	jmp    80105e4f <alltraps>

80106a46 <vector156>:
80106a46:	6a 00                	push   $0x0
80106a48:	68 9c 00 00 00       	push   $0x9c
80106a4d:	e9 fd f3 ff ff       	jmp    80105e4f <alltraps>

80106a52 <vector157>:
80106a52:	6a 00                	push   $0x0
80106a54:	68 9d 00 00 00       	push   $0x9d
80106a59:	e9 f1 f3 ff ff       	jmp    80105e4f <alltraps>

80106a5e <vector158>:
80106a5e:	6a 00                	push   $0x0
80106a60:	68 9e 00 00 00       	push   $0x9e
80106a65:	e9 e5 f3 ff ff       	jmp    80105e4f <alltraps>

80106a6a <vector159>:
80106a6a:	6a 00                	push   $0x0
80106a6c:	68 9f 00 00 00       	push   $0x9f
80106a71:	e9 d9 f3 ff ff       	jmp    80105e4f <alltraps>

80106a76 <vector160>:
80106a76:	6a 00                	push   $0x0
80106a78:	68 a0 00 00 00       	push   $0xa0
80106a7d:	e9 cd f3 ff ff       	jmp    80105e4f <alltraps>

80106a82 <vector161>:
80106a82:	6a 00                	push   $0x0
80106a84:	68 a1 00 00 00       	push   $0xa1
80106a89:	e9 c1 f3 ff ff       	jmp    80105e4f <alltraps>

80106a8e <vector162>:
80106a8e:	6a 00                	push   $0x0
80106a90:	68 a2 00 00 00       	push   $0xa2
80106a95:	e9 b5 f3 ff ff       	jmp    80105e4f <alltraps>

80106a9a <vector163>:
80106a9a:	6a 00                	push   $0x0
80106a9c:	68 a3 00 00 00       	push   $0xa3
80106aa1:	e9 a9 f3 ff ff       	jmp    80105e4f <alltraps>

80106aa6 <vector164>:
80106aa6:	6a 00                	push   $0x0
80106aa8:	68 a4 00 00 00       	push   $0xa4
80106aad:	e9 9d f3 ff ff       	jmp    80105e4f <alltraps>

80106ab2 <vector165>:
80106ab2:	6a 00                	push   $0x0
80106ab4:	68 a5 00 00 00       	push   $0xa5
80106ab9:	e9 91 f3 ff ff       	jmp    80105e4f <alltraps>

80106abe <vector166>:
80106abe:	6a 00                	push   $0x0
80106ac0:	68 a6 00 00 00       	push   $0xa6
80106ac5:	e9 85 f3 ff ff       	jmp    80105e4f <alltraps>

80106aca <vector167>:
80106aca:	6a 00                	push   $0x0
80106acc:	68 a7 00 00 00       	push   $0xa7
80106ad1:	e9 79 f3 ff ff       	jmp    80105e4f <alltraps>

80106ad6 <vector168>:
80106ad6:	6a 00                	push   $0x0
80106ad8:	68 a8 00 00 00       	push   $0xa8
80106add:	e9 6d f3 ff ff       	jmp    80105e4f <alltraps>

80106ae2 <vector169>:
80106ae2:	6a 00                	push   $0x0
80106ae4:	68 a9 00 00 00       	push   $0xa9
80106ae9:	e9 61 f3 ff ff       	jmp    80105e4f <alltraps>

80106aee <vector170>:
80106aee:	6a 00                	push   $0x0
80106af0:	68 aa 00 00 00       	push   $0xaa
80106af5:	e9 55 f3 ff ff       	jmp    80105e4f <alltraps>

80106afa <vector171>:
80106afa:	6a 00                	push   $0x0
80106afc:	68 ab 00 00 00       	push   $0xab
80106b01:	e9 49 f3 ff ff       	jmp    80105e4f <alltraps>

80106b06 <vector172>:
80106b06:	6a 00                	push   $0x0
80106b08:	68 ac 00 00 00       	push   $0xac
80106b0d:	e9 3d f3 ff ff       	jmp    80105e4f <alltraps>

80106b12 <vector173>:
80106b12:	6a 00                	push   $0x0
80106b14:	68 ad 00 00 00       	push   $0xad
80106b19:	e9 31 f3 ff ff       	jmp    80105e4f <alltraps>

80106b1e <vector174>:
80106b1e:	6a 00                	push   $0x0
80106b20:	68 ae 00 00 00       	push   $0xae
80106b25:	e9 25 f3 ff ff       	jmp    80105e4f <alltraps>

80106b2a <vector175>:
80106b2a:	6a 00                	push   $0x0
80106b2c:	68 af 00 00 00       	push   $0xaf
80106b31:	e9 19 f3 ff ff       	jmp    80105e4f <alltraps>

80106b36 <vector176>:
80106b36:	6a 00                	push   $0x0
80106b38:	68 b0 00 00 00       	push   $0xb0
80106b3d:	e9 0d f3 ff ff       	jmp    80105e4f <alltraps>

80106b42 <vector177>:
80106b42:	6a 00                	push   $0x0
80106b44:	68 b1 00 00 00       	push   $0xb1
80106b49:	e9 01 f3 ff ff       	jmp    80105e4f <alltraps>

80106b4e <vector178>:
80106b4e:	6a 00                	push   $0x0
80106b50:	68 b2 00 00 00       	push   $0xb2
80106b55:	e9 f5 f2 ff ff       	jmp    80105e4f <alltraps>

80106b5a <vector179>:
80106b5a:	6a 00                	push   $0x0
80106b5c:	68 b3 00 00 00       	push   $0xb3
80106b61:	e9 e9 f2 ff ff       	jmp    80105e4f <alltraps>

80106b66 <vector180>:
80106b66:	6a 00                	push   $0x0
80106b68:	68 b4 00 00 00       	push   $0xb4
80106b6d:	e9 dd f2 ff ff       	jmp    80105e4f <alltraps>

80106b72 <vector181>:
80106b72:	6a 00                	push   $0x0
80106b74:	68 b5 00 00 00       	push   $0xb5
80106b79:	e9 d1 f2 ff ff       	jmp    80105e4f <alltraps>

80106b7e <vector182>:
80106b7e:	6a 00                	push   $0x0
80106b80:	68 b6 00 00 00       	push   $0xb6
80106b85:	e9 c5 f2 ff ff       	jmp    80105e4f <alltraps>

80106b8a <vector183>:
80106b8a:	6a 00                	push   $0x0
80106b8c:	68 b7 00 00 00       	push   $0xb7
80106b91:	e9 b9 f2 ff ff       	jmp    80105e4f <alltraps>

80106b96 <vector184>:
80106b96:	6a 00                	push   $0x0
80106b98:	68 b8 00 00 00       	push   $0xb8
80106b9d:	e9 ad f2 ff ff       	jmp    80105e4f <alltraps>

80106ba2 <vector185>:
80106ba2:	6a 00                	push   $0x0
80106ba4:	68 b9 00 00 00       	push   $0xb9
80106ba9:	e9 a1 f2 ff ff       	jmp    80105e4f <alltraps>

80106bae <vector186>:
80106bae:	6a 00                	push   $0x0
80106bb0:	68 ba 00 00 00       	push   $0xba
80106bb5:	e9 95 f2 ff ff       	jmp    80105e4f <alltraps>

80106bba <vector187>:
80106bba:	6a 00                	push   $0x0
80106bbc:	68 bb 00 00 00       	push   $0xbb
80106bc1:	e9 89 f2 ff ff       	jmp    80105e4f <alltraps>

80106bc6 <vector188>:
80106bc6:	6a 00                	push   $0x0
80106bc8:	68 bc 00 00 00       	push   $0xbc
80106bcd:	e9 7d f2 ff ff       	jmp    80105e4f <alltraps>

80106bd2 <vector189>:
80106bd2:	6a 00                	push   $0x0
80106bd4:	68 bd 00 00 00       	push   $0xbd
80106bd9:	e9 71 f2 ff ff       	jmp    80105e4f <alltraps>

80106bde <vector190>:
80106bde:	6a 00                	push   $0x0
80106be0:	68 be 00 00 00       	push   $0xbe
80106be5:	e9 65 f2 ff ff       	jmp    80105e4f <alltraps>

80106bea <vector191>:
80106bea:	6a 00                	push   $0x0
80106bec:	68 bf 00 00 00       	push   $0xbf
80106bf1:	e9 59 f2 ff ff       	jmp    80105e4f <alltraps>

80106bf6 <vector192>:
80106bf6:	6a 00                	push   $0x0
80106bf8:	68 c0 00 00 00       	push   $0xc0
80106bfd:	e9 4d f2 ff ff       	jmp    80105e4f <alltraps>

80106c02 <vector193>:
80106c02:	6a 00                	push   $0x0
80106c04:	68 c1 00 00 00       	push   $0xc1
80106c09:	e9 41 f2 ff ff       	jmp    80105e4f <alltraps>

80106c0e <vector194>:
80106c0e:	6a 00                	push   $0x0
80106c10:	68 c2 00 00 00       	push   $0xc2
80106c15:	e9 35 f2 ff ff       	jmp    80105e4f <alltraps>

80106c1a <vector195>:
80106c1a:	6a 00                	push   $0x0
80106c1c:	68 c3 00 00 00       	push   $0xc3
80106c21:	e9 29 f2 ff ff       	jmp    80105e4f <alltraps>

80106c26 <vector196>:
80106c26:	6a 00                	push   $0x0
80106c28:	68 c4 00 00 00       	push   $0xc4
80106c2d:	e9 1d f2 ff ff       	jmp    80105e4f <alltraps>

80106c32 <vector197>:
80106c32:	6a 00                	push   $0x0
80106c34:	68 c5 00 00 00       	push   $0xc5
80106c39:	e9 11 f2 ff ff       	jmp    80105e4f <alltraps>

80106c3e <vector198>:
80106c3e:	6a 00                	push   $0x0
80106c40:	68 c6 00 00 00       	push   $0xc6
80106c45:	e9 05 f2 ff ff       	jmp    80105e4f <alltraps>

80106c4a <vector199>:
80106c4a:	6a 00                	push   $0x0
80106c4c:	68 c7 00 00 00       	push   $0xc7
80106c51:	e9 f9 f1 ff ff       	jmp    80105e4f <alltraps>

80106c56 <vector200>:
80106c56:	6a 00                	push   $0x0
80106c58:	68 c8 00 00 00       	push   $0xc8
80106c5d:	e9 ed f1 ff ff       	jmp    80105e4f <alltraps>

80106c62 <vector201>:
80106c62:	6a 00                	push   $0x0
80106c64:	68 c9 00 00 00       	push   $0xc9
80106c69:	e9 e1 f1 ff ff       	jmp    80105e4f <alltraps>

80106c6e <vector202>:
80106c6e:	6a 00                	push   $0x0
80106c70:	68 ca 00 00 00       	push   $0xca
80106c75:	e9 d5 f1 ff ff       	jmp    80105e4f <alltraps>

80106c7a <vector203>:
80106c7a:	6a 00                	push   $0x0
80106c7c:	68 cb 00 00 00       	push   $0xcb
80106c81:	e9 c9 f1 ff ff       	jmp    80105e4f <alltraps>

80106c86 <vector204>:
80106c86:	6a 00                	push   $0x0
80106c88:	68 cc 00 00 00       	push   $0xcc
80106c8d:	e9 bd f1 ff ff       	jmp    80105e4f <alltraps>

80106c92 <vector205>:
80106c92:	6a 00                	push   $0x0
80106c94:	68 cd 00 00 00       	push   $0xcd
80106c99:	e9 b1 f1 ff ff       	jmp    80105e4f <alltraps>

80106c9e <vector206>:
80106c9e:	6a 00                	push   $0x0
80106ca0:	68 ce 00 00 00       	push   $0xce
80106ca5:	e9 a5 f1 ff ff       	jmp    80105e4f <alltraps>

80106caa <vector207>:
80106caa:	6a 00                	push   $0x0
80106cac:	68 cf 00 00 00       	push   $0xcf
80106cb1:	e9 99 f1 ff ff       	jmp    80105e4f <alltraps>

80106cb6 <vector208>:
80106cb6:	6a 00                	push   $0x0
80106cb8:	68 d0 00 00 00       	push   $0xd0
80106cbd:	e9 8d f1 ff ff       	jmp    80105e4f <alltraps>

80106cc2 <vector209>:
80106cc2:	6a 00                	push   $0x0
80106cc4:	68 d1 00 00 00       	push   $0xd1
80106cc9:	e9 81 f1 ff ff       	jmp    80105e4f <alltraps>

80106cce <vector210>:
80106cce:	6a 00                	push   $0x0
80106cd0:	68 d2 00 00 00       	push   $0xd2
80106cd5:	e9 75 f1 ff ff       	jmp    80105e4f <alltraps>

80106cda <vector211>:
80106cda:	6a 00                	push   $0x0
80106cdc:	68 d3 00 00 00       	push   $0xd3
80106ce1:	e9 69 f1 ff ff       	jmp    80105e4f <alltraps>

80106ce6 <vector212>:
80106ce6:	6a 00                	push   $0x0
80106ce8:	68 d4 00 00 00       	push   $0xd4
80106ced:	e9 5d f1 ff ff       	jmp    80105e4f <alltraps>

80106cf2 <vector213>:
80106cf2:	6a 00                	push   $0x0
80106cf4:	68 d5 00 00 00       	push   $0xd5
80106cf9:	e9 51 f1 ff ff       	jmp    80105e4f <alltraps>

80106cfe <vector214>:
80106cfe:	6a 00                	push   $0x0
80106d00:	68 d6 00 00 00       	push   $0xd6
80106d05:	e9 45 f1 ff ff       	jmp    80105e4f <alltraps>

80106d0a <vector215>:
80106d0a:	6a 00                	push   $0x0
80106d0c:	68 d7 00 00 00       	push   $0xd7
80106d11:	e9 39 f1 ff ff       	jmp    80105e4f <alltraps>

80106d16 <vector216>:
80106d16:	6a 00                	push   $0x0
80106d18:	68 d8 00 00 00       	push   $0xd8
80106d1d:	e9 2d f1 ff ff       	jmp    80105e4f <alltraps>

80106d22 <vector217>:
80106d22:	6a 00                	push   $0x0
80106d24:	68 d9 00 00 00       	push   $0xd9
80106d29:	e9 21 f1 ff ff       	jmp    80105e4f <alltraps>

80106d2e <vector218>:
80106d2e:	6a 00                	push   $0x0
80106d30:	68 da 00 00 00       	push   $0xda
80106d35:	e9 15 f1 ff ff       	jmp    80105e4f <alltraps>

80106d3a <vector219>:
80106d3a:	6a 00                	push   $0x0
80106d3c:	68 db 00 00 00       	push   $0xdb
80106d41:	e9 09 f1 ff ff       	jmp    80105e4f <alltraps>

80106d46 <vector220>:
80106d46:	6a 00                	push   $0x0
80106d48:	68 dc 00 00 00       	push   $0xdc
80106d4d:	e9 fd f0 ff ff       	jmp    80105e4f <alltraps>

80106d52 <vector221>:
80106d52:	6a 00                	push   $0x0
80106d54:	68 dd 00 00 00       	push   $0xdd
80106d59:	e9 f1 f0 ff ff       	jmp    80105e4f <alltraps>

80106d5e <vector222>:
80106d5e:	6a 00                	push   $0x0
80106d60:	68 de 00 00 00       	push   $0xde
80106d65:	e9 e5 f0 ff ff       	jmp    80105e4f <alltraps>

80106d6a <vector223>:
80106d6a:	6a 00                	push   $0x0
80106d6c:	68 df 00 00 00       	push   $0xdf
80106d71:	e9 d9 f0 ff ff       	jmp    80105e4f <alltraps>

80106d76 <vector224>:
80106d76:	6a 00                	push   $0x0
80106d78:	68 e0 00 00 00       	push   $0xe0
80106d7d:	e9 cd f0 ff ff       	jmp    80105e4f <alltraps>

80106d82 <vector225>:
80106d82:	6a 00                	push   $0x0
80106d84:	68 e1 00 00 00       	push   $0xe1
80106d89:	e9 c1 f0 ff ff       	jmp    80105e4f <alltraps>

80106d8e <vector226>:
80106d8e:	6a 00                	push   $0x0
80106d90:	68 e2 00 00 00       	push   $0xe2
80106d95:	e9 b5 f0 ff ff       	jmp    80105e4f <alltraps>

80106d9a <vector227>:
80106d9a:	6a 00                	push   $0x0
80106d9c:	68 e3 00 00 00       	push   $0xe3
80106da1:	e9 a9 f0 ff ff       	jmp    80105e4f <alltraps>

80106da6 <vector228>:
80106da6:	6a 00                	push   $0x0
80106da8:	68 e4 00 00 00       	push   $0xe4
80106dad:	e9 9d f0 ff ff       	jmp    80105e4f <alltraps>

80106db2 <vector229>:
80106db2:	6a 00                	push   $0x0
80106db4:	68 e5 00 00 00       	push   $0xe5
80106db9:	e9 91 f0 ff ff       	jmp    80105e4f <alltraps>

80106dbe <vector230>:
80106dbe:	6a 00                	push   $0x0
80106dc0:	68 e6 00 00 00       	push   $0xe6
80106dc5:	e9 85 f0 ff ff       	jmp    80105e4f <alltraps>

80106dca <vector231>:
80106dca:	6a 00                	push   $0x0
80106dcc:	68 e7 00 00 00       	push   $0xe7
80106dd1:	e9 79 f0 ff ff       	jmp    80105e4f <alltraps>

80106dd6 <vector232>:
80106dd6:	6a 00                	push   $0x0
80106dd8:	68 e8 00 00 00       	push   $0xe8
80106ddd:	e9 6d f0 ff ff       	jmp    80105e4f <alltraps>

80106de2 <vector233>:
80106de2:	6a 00                	push   $0x0
80106de4:	68 e9 00 00 00       	push   $0xe9
80106de9:	e9 61 f0 ff ff       	jmp    80105e4f <alltraps>

80106dee <vector234>:
80106dee:	6a 00                	push   $0x0
80106df0:	68 ea 00 00 00       	push   $0xea
80106df5:	e9 55 f0 ff ff       	jmp    80105e4f <alltraps>

80106dfa <vector235>:
80106dfa:	6a 00                	push   $0x0
80106dfc:	68 eb 00 00 00       	push   $0xeb
80106e01:	e9 49 f0 ff ff       	jmp    80105e4f <alltraps>

80106e06 <vector236>:
80106e06:	6a 00                	push   $0x0
80106e08:	68 ec 00 00 00       	push   $0xec
80106e0d:	e9 3d f0 ff ff       	jmp    80105e4f <alltraps>

80106e12 <vector237>:
80106e12:	6a 00                	push   $0x0
80106e14:	68 ed 00 00 00       	push   $0xed
80106e19:	e9 31 f0 ff ff       	jmp    80105e4f <alltraps>

80106e1e <vector238>:
80106e1e:	6a 00                	push   $0x0
80106e20:	68 ee 00 00 00       	push   $0xee
80106e25:	e9 25 f0 ff ff       	jmp    80105e4f <alltraps>

80106e2a <vector239>:
80106e2a:	6a 00                	push   $0x0
80106e2c:	68 ef 00 00 00       	push   $0xef
80106e31:	e9 19 f0 ff ff       	jmp    80105e4f <alltraps>

80106e36 <vector240>:
80106e36:	6a 00                	push   $0x0
80106e38:	68 f0 00 00 00       	push   $0xf0
80106e3d:	e9 0d f0 ff ff       	jmp    80105e4f <alltraps>

80106e42 <vector241>:
80106e42:	6a 00                	push   $0x0
80106e44:	68 f1 00 00 00       	push   $0xf1
80106e49:	e9 01 f0 ff ff       	jmp    80105e4f <alltraps>

80106e4e <vector242>:
80106e4e:	6a 00                	push   $0x0
80106e50:	68 f2 00 00 00       	push   $0xf2
80106e55:	e9 f5 ef ff ff       	jmp    80105e4f <alltraps>

80106e5a <vector243>:
80106e5a:	6a 00                	push   $0x0
80106e5c:	68 f3 00 00 00       	push   $0xf3
80106e61:	e9 e9 ef ff ff       	jmp    80105e4f <alltraps>

80106e66 <vector244>:
80106e66:	6a 00                	push   $0x0
80106e68:	68 f4 00 00 00       	push   $0xf4
80106e6d:	e9 dd ef ff ff       	jmp    80105e4f <alltraps>

80106e72 <vector245>:
80106e72:	6a 00                	push   $0x0
80106e74:	68 f5 00 00 00       	push   $0xf5
80106e79:	e9 d1 ef ff ff       	jmp    80105e4f <alltraps>

80106e7e <vector246>:
80106e7e:	6a 00                	push   $0x0
80106e80:	68 f6 00 00 00       	push   $0xf6
80106e85:	e9 c5 ef ff ff       	jmp    80105e4f <alltraps>

80106e8a <vector247>:
80106e8a:	6a 00                	push   $0x0
80106e8c:	68 f7 00 00 00       	push   $0xf7
80106e91:	e9 b9 ef ff ff       	jmp    80105e4f <alltraps>

80106e96 <vector248>:
80106e96:	6a 00                	push   $0x0
80106e98:	68 f8 00 00 00       	push   $0xf8
80106e9d:	e9 ad ef ff ff       	jmp    80105e4f <alltraps>

80106ea2 <vector249>:
80106ea2:	6a 00                	push   $0x0
80106ea4:	68 f9 00 00 00       	push   $0xf9
80106ea9:	e9 a1 ef ff ff       	jmp    80105e4f <alltraps>

80106eae <vector250>:
80106eae:	6a 00                	push   $0x0
80106eb0:	68 fa 00 00 00       	push   $0xfa
80106eb5:	e9 95 ef ff ff       	jmp    80105e4f <alltraps>

80106eba <vector251>:
80106eba:	6a 00                	push   $0x0
80106ebc:	68 fb 00 00 00       	push   $0xfb
80106ec1:	e9 89 ef ff ff       	jmp    80105e4f <alltraps>

80106ec6 <vector252>:
80106ec6:	6a 00                	push   $0x0
80106ec8:	68 fc 00 00 00       	push   $0xfc
80106ecd:	e9 7d ef ff ff       	jmp    80105e4f <alltraps>

80106ed2 <vector253>:
80106ed2:	6a 00                	push   $0x0
80106ed4:	68 fd 00 00 00       	push   $0xfd
80106ed9:	e9 71 ef ff ff       	jmp    80105e4f <alltraps>

80106ede <vector254>:
80106ede:	6a 00                	push   $0x0
80106ee0:	68 fe 00 00 00       	push   $0xfe
80106ee5:	e9 65 ef ff ff       	jmp    80105e4f <alltraps>

80106eea <vector255>:
80106eea:	6a 00                	push   $0x0
80106eec:	68 ff 00 00 00       	push   $0xff
80106ef1:	e9 59 ef ff ff       	jmp    80105e4f <alltraps>

80106ef6 <lgdt>:
{
80106ef6:	55                   	push   %ebp
80106ef7:	89 e5                	mov    %esp,%ebp
80106ef9:	83 ec 10             	sub    $0x10,%esp
  pd[0] = size-1;
80106efc:	8b 45 0c             	mov    0xc(%ebp),%eax
80106eff:	83 e8 01             	sub    $0x1,%eax
80106f02:	66 89 45 fa          	mov    %ax,-0x6(%ebp)
  pd[1] = (uint)p;
80106f06:	8b 45 08             	mov    0x8(%ebp),%eax
80106f09:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  pd[2] = (uint)p >> 16;
80106f0d:	8b 45 08             	mov    0x8(%ebp),%eax
80106f10:	c1 e8 10             	shr    $0x10,%eax
80106f13:	66 89 45 fe          	mov    %ax,-0x2(%ebp)
  asm volatile("lgdt (%0)" : : "r" (pd));
80106f17:	8d 45 fa             	lea    -0x6(%ebp),%eax
80106f1a:	0f 01 10             	lgdtl  (%eax)
}
80106f1d:	90                   	nop
80106f1e:	c9                   	leave  
80106f1f:	c3                   	ret    

80106f20 <ltr>:
{
80106f20:	55                   	push   %ebp
80106f21:	89 e5                	mov    %esp,%ebp
80106f23:	83 ec 04             	sub    $0x4,%esp
80106f26:	8b 45 08             	mov    0x8(%ebp),%eax
80106f29:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  asm volatile("ltr %0" : : "r" (sel));
80106f2d:	0f b7 45 fc          	movzwl -0x4(%ebp),%eax
80106f31:	0f 00 d8             	ltr    %ax
}
80106f34:	90                   	nop
80106f35:	c9                   	leave  
80106f36:	c3                   	ret    

80106f37 <lcr3>:

static inline void
lcr3(uint val)
{
80106f37:	55                   	push   %ebp
80106f38:	89 e5                	mov    %esp,%ebp
  asm volatile("movl %0,%%cr3" : : "r" (val));
80106f3a:	8b 45 08             	mov    0x8(%ebp),%eax
80106f3d:	0f 22 d8             	mov    %eax,%cr3
}
80106f40:	90                   	nop
80106f41:	5d                   	pop    %ebp
80106f42:	c3                   	ret    

80106f43 <seginit>:
extern struct gpu gpu;
// Set up CPU's kernel segment descriptors.
// Run once on entry on each CPU.
void
seginit(void)
{
80106f43:	55                   	push   %ebp
80106f44:	89 e5                	mov    %esp,%ebp
80106f46:	83 ec 18             	sub    $0x18,%esp

  // Map "logical" addresses to virtual addresses using identity map.
  // Cannot share a CODE descriptor for both kernel and user
  // because it would have to have DPL_USR, but the CPU forbids
  // an interrupt from CPL=0 to DPL=3.
  c = &cpus[cpuid()];
80106f49:	e8 a2 cb ff ff       	call   80103af0 <cpuid>
80106f4e:	69 c0 b0 00 00 00    	imul   $0xb0,%eax,%eax
80106f54:	05 80 69 19 80       	add    $0x80196980,%eax
80106f59:	89 45 f4             	mov    %eax,-0xc(%ebp)

  c->gdt[SEG_KCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, 0);
80106f5c:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106f5f:	66 c7 40 78 ff ff    	movw   $0xffff,0x78(%eax)
80106f65:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106f68:	66 c7 40 7a 00 00    	movw   $0x0,0x7a(%eax)
80106f6e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106f71:	c6 40 7c 00          	movb   $0x0,0x7c(%eax)
80106f75:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106f78:	0f b6 50 7d          	movzbl 0x7d(%eax),%edx
80106f7c:	83 e2 f0             	and    $0xfffffff0,%edx
80106f7f:	83 ca 0a             	or     $0xa,%edx
80106f82:	88 50 7d             	mov    %dl,0x7d(%eax)
80106f85:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106f88:	0f b6 50 7d          	movzbl 0x7d(%eax),%edx
80106f8c:	83 ca 10             	or     $0x10,%edx
80106f8f:	88 50 7d             	mov    %dl,0x7d(%eax)
80106f92:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106f95:	0f b6 50 7d          	movzbl 0x7d(%eax),%edx
80106f99:	83 e2 9f             	and    $0xffffff9f,%edx
80106f9c:	88 50 7d             	mov    %dl,0x7d(%eax)
80106f9f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106fa2:	0f b6 50 7d          	movzbl 0x7d(%eax),%edx
80106fa6:	83 ca 80             	or     $0xffffff80,%edx
80106fa9:	88 50 7d             	mov    %dl,0x7d(%eax)
80106fac:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106faf:	0f b6 50 7e          	movzbl 0x7e(%eax),%edx
80106fb3:	83 ca 0f             	or     $0xf,%edx
80106fb6:	88 50 7e             	mov    %dl,0x7e(%eax)
80106fb9:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106fbc:	0f b6 50 7e          	movzbl 0x7e(%eax),%edx
80106fc0:	83 e2 ef             	and    $0xffffffef,%edx
80106fc3:	88 50 7e             	mov    %dl,0x7e(%eax)
80106fc6:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106fc9:	0f b6 50 7e          	movzbl 0x7e(%eax),%edx
80106fcd:	83 e2 df             	and    $0xffffffdf,%edx
80106fd0:	88 50 7e             	mov    %dl,0x7e(%eax)
80106fd3:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106fd6:	0f b6 50 7e          	movzbl 0x7e(%eax),%edx
80106fda:	83 ca 40             	or     $0x40,%edx
80106fdd:	88 50 7e             	mov    %dl,0x7e(%eax)
80106fe0:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106fe3:	0f b6 50 7e          	movzbl 0x7e(%eax),%edx
80106fe7:	83 ca 80             	or     $0xffffff80,%edx
80106fea:	88 50 7e             	mov    %dl,0x7e(%eax)
80106fed:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106ff0:	c6 40 7f 00          	movb   $0x0,0x7f(%eax)
  c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
80106ff4:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106ff7:	66 c7 80 80 00 00 00 	movw   $0xffff,0x80(%eax)
80106ffe:	ff ff 
80107000:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107003:	66 c7 80 82 00 00 00 	movw   $0x0,0x82(%eax)
8010700a:	00 00 
8010700c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010700f:	c6 80 84 00 00 00 00 	movb   $0x0,0x84(%eax)
80107016:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107019:	0f b6 90 85 00 00 00 	movzbl 0x85(%eax),%edx
80107020:	83 e2 f0             	and    $0xfffffff0,%edx
80107023:	83 ca 02             	or     $0x2,%edx
80107026:	88 90 85 00 00 00    	mov    %dl,0x85(%eax)
8010702c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010702f:	0f b6 90 85 00 00 00 	movzbl 0x85(%eax),%edx
80107036:	83 ca 10             	or     $0x10,%edx
80107039:	88 90 85 00 00 00    	mov    %dl,0x85(%eax)
8010703f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107042:	0f b6 90 85 00 00 00 	movzbl 0x85(%eax),%edx
80107049:	83 e2 9f             	and    $0xffffff9f,%edx
8010704c:	88 90 85 00 00 00    	mov    %dl,0x85(%eax)
80107052:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107055:	0f b6 90 85 00 00 00 	movzbl 0x85(%eax),%edx
8010705c:	83 ca 80             	or     $0xffffff80,%edx
8010705f:	88 90 85 00 00 00    	mov    %dl,0x85(%eax)
80107065:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107068:	0f b6 90 86 00 00 00 	movzbl 0x86(%eax),%edx
8010706f:	83 ca 0f             	or     $0xf,%edx
80107072:	88 90 86 00 00 00    	mov    %dl,0x86(%eax)
80107078:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010707b:	0f b6 90 86 00 00 00 	movzbl 0x86(%eax),%edx
80107082:	83 e2 ef             	and    $0xffffffef,%edx
80107085:	88 90 86 00 00 00    	mov    %dl,0x86(%eax)
8010708b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010708e:	0f b6 90 86 00 00 00 	movzbl 0x86(%eax),%edx
80107095:	83 e2 df             	and    $0xffffffdf,%edx
80107098:	88 90 86 00 00 00    	mov    %dl,0x86(%eax)
8010709e:	8b 45 f4             	mov    -0xc(%ebp),%eax
801070a1:	0f b6 90 86 00 00 00 	movzbl 0x86(%eax),%edx
801070a8:	83 ca 40             	or     $0x40,%edx
801070ab:	88 90 86 00 00 00    	mov    %dl,0x86(%eax)
801070b1:	8b 45 f4             	mov    -0xc(%ebp),%eax
801070b4:	0f b6 90 86 00 00 00 	movzbl 0x86(%eax),%edx
801070bb:	83 ca 80             	or     $0xffffff80,%edx
801070be:	88 90 86 00 00 00    	mov    %dl,0x86(%eax)
801070c4:	8b 45 f4             	mov    -0xc(%ebp),%eax
801070c7:	c6 80 87 00 00 00 00 	movb   $0x0,0x87(%eax)
  c->gdt[SEG_UCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, DPL_USER);
801070ce:	8b 45 f4             	mov    -0xc(%ebp),%eax
801070d1:	66 c7 80 88 00 00 00 	movw   $0xffff,0x88(%eax)
801070d8:	ff ff 
801070da:	8b 45 f4             	mov    -0xc(%ebp),%eax
801070dd:	66 c7 80 8a 00 00 00 	movw   $0x0,0x8a(%eax)
801070e4:	00 00 
801070e6:	8b 45 f4             	mov    -0xc(%ebp),%eax
801070e9:	c6 80 8c 00 00 00 00 	movb   $0x0,0x8c(%eax)
801070f0:	8b 45 f4             	mov    -0xc(%ebp),%eax
801070f3:	0f b6 90 8d 00 00 00 	movzbl 0x8d(%eax),%edx
801070fa:	83 e2 f0             	and    $0xfffffff0,%edx
801070fd:	83 ca 0a             	or     $0xa,%edx
80107100:	88 90 8d 00 00 00    	mov    %dl,0x8d(%eax)
80107106:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107109:	0f b6 90 8d 00 00 00 	movzbl 0x8d(%eax),%edx
80107110:	83 ca 10             	or     $0x10,%edx
80107113:	88 90 8d 00 00 00    	mov    %dl,0x8d(%eax)
80107119:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010711c:	0f b6 90 8d 00 00 00 	movzbl 0x8d(%eax),%edx
80107123:	83 ca 60             	or     $0x60,%edx
80107126:	88 90 8d 00 00 00    	mov    %dl,0x8d(%eax)
8010712c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010712f:	0f b6 90 8d 00 00 00 	movzbl 0x8d(%eax),%edx
80107136:	83 ca 80             	or     $0xffffff80,%edx
80107139:	88 90 8d 00 00 00    	mov    %dl,0x8d(%eax)
8010713f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107142:	0f b6 90 8e 00 00 00 	movzbl 0x8e(%eax),%edx
80107149:	83 ca 0f             	or     $0xf,%edx
8010714c:	88 90 8e 00 00 00    	mov    %dl,0x8e(%eax)
80107152:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107155:	0f b6 90 8e 00 00 00 	movzbl 0x8e(%eax),%edx
8010715c:	83 e2 ef             	and    $0xffffffef,%edx
8010715f:	88 90 8e 00 00 00    	mov    %dl,0x8e(%eax)
80107165:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107168:	0f b6 90 8e 00 00 00 	movzbl 0x8e(%eax),%edx
8010716f:	83 e2 df             	and    $0xffffffdf,%edx
80107172:	88 90 8e 00 00 00    	mov    %dl,0x8e(%eax)
80107178:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010717b:	0f b6 90 8e 00 00 00 	movzbl 0x8e(%eax),%edx
80107182:	83 ca 40             	or     $0x40,%edx
80107185:	88 90 8e 00 00 00    	mov    %dl,0x8e(%eax)
8010718b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010718e:	0f b6 90 8e 00 00 00 	movzbl 0x8e(%eax),%edx
80107195:	83 ca 80             	or     $0xffffff80,%edx
80107198:	88 90 8e 00 00 00    	mov    %dl,0x8e(%eax)
8010719e:	8b 45 f4             	mov    -0xc(%ebp),%eax
801071a1:	c6 80 8f 00 00 00 00 	movb   $0x0,0x8f(%eax)
  c->gdt[SEG_UDATA] = SEG(STA_W, 0, 0xffffffff, DPL_USER);
801071a8:	8b 45 f4             	mov    -0xc(%ebp),%eax
801071ab:	66 c7 80 90 00 00 00 	movw   $0xffff,0x90(%eax)
801071b2:	ff ff 
801071b4:	8b 45 f4             	mov    -0xc(%ebp),%eax
801071b7:	66 c7 80 92 00 00 00 	movw   $0x0,0x92(%eax)
801071be:	00 00 
801071c0:	8b 45 f4             	mov    -0xc(%ebp),%eax
801071c3:	c6 80 94 00 00 00 00 	movb   $0x0,0x94(%eax)
801071ca:	8b 45 f4             	mov    -0xc(%ebp),%eax
801071cd:	0f b6 90 95 00 00 00 	movzbl 0x95(%eax),%edx
801071d4:	83 e2 f0             	and    $0xfffffff0,%edx
801071d7:	83 ca 02             	or     $0x2,%edx
801071da:	88 90 95 00 00 00    	mov    %dl,0x95(%eax)
801071e0:	8b 45 f4             	mov    -0xc(%ebp),%eax
801071e3:	0f b6 90 95 00 00 00 	movzbl 0x95(%eax),%edx
801071ea:	83 ca 10             	or     $0x10,%edx
801071ed:	88 90 95 00 00 00    	mov    %dl,0x95(%eax)
801071f3:	8b 45 f4             	mov    -0xc(%ebp),%eax
801071f6:	0f b6 90 95 00 00 00 	movzbl 0x95(%eax),%edx
801071fd:	83 ca 60             	or     $0x60,%edx
80107200:	88 90 95 00 00 00    	mov    %dl,0x95(%eax)
80107206:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107209:	0f b6 90 95 00 00 00 	movzbl 0x95(%eax),%edx
80107210:	83 ca 80             	or     $0xffffff80,%edx
80107213:	88 90 95 00 00 00    	mov    %dl,0x95(%eax)
80107219:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010721c:	0f b6 90 96 00 00 00 	movzbl 0x96(%eax),%edx
80107223:	83 ca 0f             	or     $0xf,%edx
80107226:	88 90 96 00 00 00    	mov    %dl,0x96(%eax)
8010722c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010722f:	0f b6 90 96 00 00 00 	movzbl 0x96(%eax),%edx
80107236:	83 e2 ef             	and    $0xffffffef,%edx
80107239:	88 90 96 00 00 00    	mov    %dl,0x96(%eax)
8010723f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107242:	0f b6 90 96 00 00 00 	movzbl 0x96(%eax),%edx
80107249:	83 e2 df             	and    $0xffffffdf,%edx
8010724c:	88 90 96 00 00 00    	mov    %dl,0x96(%eax)
80107252:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107255:	0f b6 90 96 00 00 00 	movzbl 0x96(%eax),%edx
8010725c:	83 ca 40             	or     $0x40,%edx
8010725f:	88 90 96 00 00 00    	mov    %dl,0x96(%eax)
80107265:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107268:	0f b6 90 96 00 00 00 	movzbl 0x96(%eax),%edx
8010726f:	83 ca 80             	or     $0xffffff80,%edx
80107272:	88 90 96 00 00 00    	mov    %dl,0x96(%eax)
80107278:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010727b:	c6 80 97 00 00 00 00 	movb   $0x0,0x97(%eax)
  lgdt(c->gdt, sizeof(c->gdt));
80107282:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107285:	83 c0 70             	add    $0x70,%eax
80107288:	83 ec 08             	sub    $0x8,%esp
8010728b:	6a 30                	push   $0x30
8010728d:	50                   	push   %eax
8010728e:	e8 63 fc ff ff       	call   80106ef6 <lgdt>
80107293:	83 c4 10             	add    $0x10,%esp
}
80107296:	90                   	nop
80107297:	c9                   	leave  
80107298:	c3                   	ret    

80107299 <walkpgdir>:
// Return the address of the PTE in page table pgdir
// that corresponds to virtual address va.  If alloc!=0,
// create any required page table pages.
static pte_t *
walkpgdir(pde_t *pgdir, const void *va, int alloc)
{
80107299:	55                   	push   %ebp
8010729a:	89 e5                	mov    %esp,%ebp
8010729c:	83 ec 18             	sub    $0x18,%esp
  pde_t *pde;
  pte_t *pgtab;

  pde = &pgdir[PDX(va)];
8010729f:	8b 45 0c             	mov    0xc(%ebp),%eax
801072a2:	c1 e8 16             	shr    $0x16,%eax
801072a5:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
801072ac:	8b 45 08             	mov    0x8(%ebp),%eax
801072af:	01 d0                	add    %edx,%eax
801072b1:	89 45 f0             	mov    %eax,-0x10(%ebp)
  if(*pde & PTE_P){
801072b4:	8b 45 f0             	mov    -0x10(%ebp),%eax
801072b7:	8b 00                	mov    (%eax),%eax
801072b9:	83 e0 01             	and    $0x1,%eax
801072bc:	85 c0                	test   %eax,%eax
801072be:	74 14                	je     801072d4 <walkpgdir+0x3b>
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
801072c0:	8b 45 f0             	mov    -0x10(%ebp),%eax
801072c3:	8b 00                	mov    (%eax),%eax
801072c5:	25 00 f0 ff ff       	and    $0xfffff000,%eax
801072ca:	05 00 00 00 80       	add    $0x80000000,%eax
801072cf:	89 45 f4             	mov    %eax,-0xc(%ebp)
801072d2:	eb 42                	jmp    80107316 <walkpgdir+0x7d>
  } else {
    if(!alloc || (pgtab = (pte_t*)kalloc()) == 0)
801072d4:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
801072d8:	74 0e                	je     801072e8 <walkpgdir+0x4f>
801072da:	e8 c1 b4 ff ff       	call   801027a0 <kalloc>
801072df:	89 45 f4             	mov    %eax,-0xc(%ebp)
801072e2:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801072e6:	75 07                	jne    801072ef <walkpgdir+0x56>
      return 0;
801072e8:	b8 00 00 00 00       	mov    $0x0,%eax
801072ed:	eb 3e                	jmp    8010732d <walkpgdir+0x94>
    // Make sure all those PTE_P bits are zero.
    memset(pgtab, 0, PGSIZE);
801072ef:	83 ec 04             	sub    $0x4,%esp
801072f2:	68 00 10 00 00       	push   $0x1000
801072f7:	6a 00                	push   $0x0
801072f9:	ff 75 f4             	push   -0xc(%ebp)
801072fc:	e8 bc d7 ff ff       	call   80104abd <memset>
80107301:	83 c4 10             	add    $0x10,%esp
    // The permissions here are overly generous, but they can
    // be further restricted by the permissions in the page table
    // entries, if necessary.
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
80107304:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107307:	05 00 00 00 80       	add    $0x80000000,%eax
8010730c:	83 c8 07             	or     $0x7,%eax
8010730f:	89 c2                	mov    %eax,%edx
80107311:	8b 45 f0             	mov    -0x10(%ebp),%eax
80107314:	89 10                	mov    %edx,(%eax)
  }
  return &pgtab[PTX(va)];
80107316:	8b 45 0c             	mov    0xc(%ebp),%eax
80107319:	c1 e8 0c             	shr    $0xc,%eax
8010731c:	25 ff 03 00 00       	and    $0x3ff,%eax
80107321:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80107328:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010732b:	01 d0                	add    %edx,%eax
}
8010732d:	c9                   	leave  
8010732e:	c3                   	ret    

8010732f <mappages>:
// Create PTEs for virtual addresses starting at va that refer to
// physical addresses starting at pa. va and size might not
// be page-aligned.
static int
mappages(pde_t *pgdir, void *va, uint size, uint pa, int perm)
{
8010732f:	55                   	push   %ebp
80107330:	89 e5                	mov    %esp,%ebp
80107332:	83 ec 18             	sub    $0x18,%esp
  char *a, *last;
  pte_t *pte;

  a = (char*)PGROUNDDOWN((uint)va);
80107335:	8b 45 0c             	mov    0xc(%ebp),%eax
80107338:	25 00 f0 ff ff       	and    $0xfffff000,%eax
8010733d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
80107340:	8b 55 0c             	mov    0xc(%ebp),%edx
80107343:	8b 45 10             	mov    0x10(%ebp),%eax
80107346:	01 d0                	add    %edx,%eax
80107348:	83 e8 01             	sub    $0x1,%eax
8010734b:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80107350:	89 45 f0             	mov    %eax,-0x10(%ebp)
  for(;;){
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
80107353:	83 ec 04             	sub    $0x4,%esp
80107356:	6a 01                	push   $0x1
80107358:	ff 75 f4             	push   -0xc(%ebp)
8010735b:	ff 75 08             	push   0x8(%ebp)
8010735e:	e8 36 ff ff ff       	call   80107299 <walkpgdir>
80107363:	83 c4 10             	add    $0x10,%esp
80107366:	89 45 ec             	mov    %eax,-0x14(%ebp)
80107369:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
8010736d:	75 07                	jne    80107376 <mappages+0x47>
      return -1;
8010736f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80107374:	eb 47                	jmp    801073bd <mappages+0x8e>
    if(*pte & PTE_P)
80107376:	8b 45 ec             	mov    -0x14(%ebp),%eax
80107379:	8b 00                	mov    (%eax),%eax
8010737b:	83 e0 01             	and    $0x1,%eax
8010737e:	85 c0                	test   %eax,%eax
80107380:	74 0d                	je     8010738f <mappages+0x60>
      panic("remap");
80107382:	83 ec 0c             	sub    $0xc,%esp
80107385:	68 a4 a6 10 80       	push   $0x8010a6a4
8010738a:	e8 1a 92 ff ff       	call   801005a9 <panic>
    *pte = pa | perm | PTE_P;
8010738f:	8b 45 18             	mov    0x18(%ebp),%eax
80107392:	0b 45 14             	or     0x14(%ebp),%eax
80107395:	83 c8 01             	or     $0x1,%eax
80107398:	89 c2                	mov    %eax,%edx
8010739a:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010739d:	89 10                	mov    %edx,(%eax)
    if(a == last)
8010739f:	8b 45 f4             	mov    -0xc(%ebp),%eax
801073a2:	3b 45 f0             	cmp    -0x10(%ebp),%eax
801073a5:	74 10                	je     801073b7 <mappages+0x88>
      break;
    a += PGSIZE;
801073a7:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
    pa += PGSIZE;
801073ae:	81 45 14 00 10 00 00 	addl   $0x1000,0x14(%ebp)
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
801073b5:	eb 9c                	jmp    80107353 <mappages+0x24>
      break;
801073b7:	90                   	nop
  }
  return 0;
801073b8:	b8 00 00 00 00       	mov    $0x0,%eax
}
801073bd:	c9                   	leave  
801073be:	c3                   	ret    

801073bf <setupkvm>:
};

// Set up kernel part of a page table.
pde_t*
setupkvm(void)
{
801073bf:	55                   	push   %ebp
801073c0:	89 e5                	mov    %esp,%ebp
801073c2:	53                   	push   %ebx
801073c3:	83 ec 24             	sub    $0x24,%esp
  pde_t *pgdir;
  struct kmap *k;
  k = kmap;
801073c6:	c7 45 f4 80 f4 10 80 	movl   $0x8010f480,-0xc(%ebp)
  struct kmap vram = { (void*)(DEVSPACE - gpu.vram_size),gpu.pvram_addr,gpu.pvram_addr+gpu.vram_size, PTE_W};
801073cd:	8b 15 50 6c 19 80    	mov    0x80196c50,%edx
801073d3:	b8 00 00 00 fe       	mov    $0xfe000000,%eax
801073d8:	29 d0                	sub    %edx,%eax
801073da:	89 45 e0             	mov    %eax,-0x20(%ebp)
801073dd:	a1 48 6c 19 80       	mov    0x80196c48,%eax
801073e2:	89 45 e4             	mov    %eax,-0x1c(%ebp)
801073e5:	8b 15 48 6c 19 80    	mov    0x80196c48,%edx
801073eb:	a1 50 6c 19 80       	mov    0x80196c50,%eax
801073f0:	01 d0                	add    %edx,%eax
801073f2:	89 45 e8             	mov    %eax,-0x18(%ebp)
801073f5:	c7 45 ec 02 00 00 00 	movl   $0x2,-0x14(%ebp)
  k[3] = vram;
801073fc:	8b 45 f4             	mov    -0xc(%ebp),%eax
801073ff:	83 c0 30             	add    $0x30,%eax
80107402:	8b 55 e0             	mov    -0x20(%ebp),%edx
80107405:	89 10                	mov    %edx,(%eax)
80107407:	8b 55 e4             	mov    -0x1c(%ebp),%edx
8010740a:	89 50 04             	mov    %edx,0x4(%eax)
8010740d:	8b 55 e8             	mov    -0x18(%ebp),%edx
80107410:	89 50 08             	mov    %edx,0x8(%eax)
80107413:	8b 55 ec             	mov    -0x14(%ebp),%edx
80107416:	89 50 0c             	mov    %edx,0xc(%eax)
  if((pgdir = (pde_t*)kalloc()) == 0){
80107419:	e8 82 b3 ff ff       	call   801027a0 <kalloc>
8010741e:	89 45 f0             	mov    %eax,-0x10(%ebp)
80107421:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80107425:	75 07                	jne    8010742e <setupkvm+0x6f>
    return 0;
80107427:	b8 00 00 00 00       	mov    $0x0,%eax
8010742c:	eb 78                	jmp    801074a6 <setupkvm+0xe7>
  }
  memset(pgdir, 0, PGSIZE);
8010742e:	83 ec 04             	sub    $0x4,%esp
80107431:	68 00 10 00 00       	push   $0x1000
80107436:	6a 00                	push   $0x0
80107438:	ff 75 f0             	push   -0x10(%ebp)
8010743b:	e8 7d d6 ff ff       	call   80104abd <memset>
80107440:	83 c4 10             	add    $0x10,%esp
  if (P2V(PHYSTOP) > (void*)DEVSPACE)
    panic("PHYSTOP too high");
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
80107443:	c7 45 f4 80 f4 10 80 	movl   $0x8010f480,-0xc(%ebp)
8010744a:	eb 4e                	jmp    8010749a <setupkvm+0xdb>
    if(mappages(pgdir, k->virt, k->phys_end - k->phys_start,
8010744c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010744f:	8b 48 0c             	mov    0xc(%eax),%ecx
                (uint)k->phys_start, k->perm) < 0) {
80107452:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107455:	8b 50 04             	mov    0x4(%eax),%edx
    if(mappages(pgdir, k->virt, k->phys_end - k->phys_start,
80107458:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010745b:	8b 58 08             	mov    0x8(%eax),%ebx
8010745e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107461:	8b 40 04             	mov    0x4(%eax),%eax
80107464:	29 c3                	sub    %eax,%ebx
80107466:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107469:	8b 00                	mov    (%eax),%eax
8010746b:	83 ec 0c             	sub    $0xc,%esp
8010746e:	51                   	push   %ecx
8010746f:	52                   	push   %edx
80107470:	53                   	push   %ebx
80107471:	50                   	push   %eax
80107472:	ff 75 f0             	push   -0x10(%ebp)
80107475:	e8 b5 fe ff ff       	call   8010732f <mappages>
8010747a:	83 c4 20             	add    $0x20,%esp
8010747d:	85 c0                	test   %eax,%eax
8010747f:	79 15                	jns    80107496 <setupkvm+0xd7>
      freevm(pgdir);
80107481:	83 ec 0c             	sub    $0xc,%esp
80107484:	ff 75 f0             	push   -0x10(%ebp)
80107487:	e8 f5 04 00 00       	call   80107981 <freevm>
8010748c:	83 c4 10             	add    $0x10,%esp
      return 0;
8010748f:	b8 00 00 00 00       	mov    $0x0,%eax
80107494:	eb 10                	jmp    801074a6 <setupkvm+0xe7>
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
80107496:	83 45 f4 10          	addl   $0x10,-0xc(%ebp)
8010749a:	81 7d f4 e0 f4 10 80 	cmpl   $0x8010f4e0,-0xc(%ebp)
801074a1:	72 a9                	jb     8010744c <setupkvm+0x8d>
    }
  return pgdir;
801074a3:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
801074a6:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801074a9:	c9                   	leave  
801074aa:	c3                   	ret    

801074ab <kvmalloc>:

// Allocate one page table for the machine for the kernel address
// space for scheduler processes.
void
kvmalloc(void)
{
801074ab:	55                   	push   %ebp
801074ac:	89 e5                	mov    %esp,%ebp
801074ae:	83 ec 08             	sub    $0x8,%esp
  kpgdir = setupkvm();
801074b1:	e8 09 ff ff ff       	call   801073bf <setupkvm>
801074b6:	a3 7c 69 19 80       	mov    %eax,0x8019697c
  switchkvm();
801074bb:	e8 03 00 00 00       	call   801074c3 <switchkvm>
}
801074c0:	90                   	nop
801074c1:	c9                   	leave  
801074c2:	c3                   	ret    

801074c3 <switchkvm>:

// Switch h/w page table register to the kernel-only page table,
// for when no process is running.
void
switchkvm(void)
{
801074c3:	55                   	push   %ebp
801074c4:	89 e5                	mov    %esp,%ebp
  lcr3(V2P(kpgdir));   // switch to the kernel page table
801074c6:	a1 7c 69 19 80       	mov    0x8019697c,%eax
801074cb:	05 00 00 00 80       	add    $0x80000000,%eax
801074d0:	50                   	push   %eax
801074d1:	e8 61 fa ff ff       	call   80106f37 <lcr3>
801074d6:	83 c4 04             	add    $0x4,%esp
}
801074d9:	90                   	nop
801074da:	c9                   	leave  
801074db:	c3                   	ret    

801074dc <switchuvm>:

// Switch TSS and h/w page table to correspond to process p.
void
switchuvm(struct proc *p)
{
801074dc:	55                   	push   %ebp
801074dd:	89 e5                	mov    %esp,%ebp
801074df:	56                   	push   %esi
801074e0:	53                   	push   %ebx
801074e1:	83 ec 10             	sub    $0x10,%esp
  if(p == 0)
801074e4:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
801074e8:	75 0d                	jne    801074f7 <switchuvm+0x1b>
    panic("switchuvm: no process");
801074ea:	83 ec 0c             	sub    $0xc,%esp
801074ed:	68 aa a6 10 80       	push   $0x8010a6aa
801074f2:	e8 b2 90 ff ff       	call   801005a9 <panic>
  if(p->kstack == 0)
801074f7:	8b 45 08             	mov    0x8(%ebp),%eax
801074fa:	8b 40 08             	mov    0x8(%eax),%eax
801074fd:	85 c0                	test   %eax,%eax
801074ff:	75 0d                	jne    8010750e <switchuvm+0x32>
    panic("switchuvm: no kstack");
80107501:	83 ec 0c             	sub    $0xc,%esp
80107504:	68 c0 a6 10 80       	push   $0x8010a6c0
80107509:	e8 9b 90 ff ff       	call   801005a9 <panic>
  if(p->pgdir == 0)
8010750e:	8b 45 08             	mov    0x8(%ebp),%eax
80107511:	8b 40 04             	mov    0x4(%eax),%eax
80107514:	85 c0                	test   %eax,%eax
80107516:	75 0d                	jne    80107525 <switchuvm+0x49>
    panic("switchuvm: no pgdir");
80107518:	83 ec 0c             	sub    $0xc,%esp
8010751b:	68 d5 a6 10 80       	push   $0x8010a6d5
80107520:	e8 84 90 ff ff       	call   801005a9 <panic>

  pushcli();
80107525:	e8 88 d4 ff ff       	call   801049b2 <pushcli>
  mycpu()->gdt[SEG_TSS] = SEG16(STS_T32A, &mycpu()->ts,
8010752a:	e8 dc c5 ff ff       	call   80103b0b <mycpu>
8010752f:	89 c3                	mov    %eax,%ebx
80107531:	e8 d5 c5 ff ff       	call   80103b0b <mycpu>
80107536:	83 c0 08             	add    $0x8,%eax
80107539:	89 c6                	mov    %eax,%esi
8010753b:	e8 cb c5 ff ff       	call   80103b0b <mycpu>
80107540:	83 c0 08             	add    $0x8,%eax
80107543:	c1 e8 10             	shr    $0x10,%eax
80107546:	88 45 f7             	mov    %al,-0x9(%ebp)
80107549:	e8 bd c5 ff ff       	call   80103b0b <mycpu>
8010754e:	83 c0 08             	add    $0x8,%eax
80107551:	c1 e8 18             	shr    $0x18,%eax
80107554:	89 c2                	mov    %eax,%edx
80107556:	66 c7 83 98 00 00 00 	movw   $0x67,0x98(%ebx)
8010755d:	67 00 
8010755f:	66 89 b3 9a 00 00 00 	mov    %si,0x9a(%ebx)
80107566:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
8010756a:	88 83 9c 00 00 00    	mov    %al,0x9c(%ebx)
80107570:	0f b6 83 9d 00 00 00 	movzbl 0x9d(%ebx),%eax
80107577:	83 e0 f0             	and    $0xfffffff0,%eax
8010757a:	83 c8 09             	or     $0x9,%eax
8010757d:	88 83 9d 00 00 00    	mov    %al,0x9d(%ebx)
80107583:	0f b6 83 9d 00 00 00 	movzbl 0x9d(%ebx),%eax
8010758a:	83 c8 10             	or     $0x10,%eax
8010758d:	88 83 9d 00 00 00    	mov    %al,0x9d(%ebx)
80107593:	0f b6 83 9d 00 00 00 	movzbl 0x9d(%ebx),%eax
8010759a:	83 e0 9f             	and    $0xffffff9f,%eax
8010759d:	88 83 9d 00 00 00    	mov    %al,0x9d(%ebx)
801075a3:	0f b6 83 9d 00 00 00 	movzbl 0x9d(%ebx),%eax
801075aa:	83 c8 80             	or     $0xffffff80,%eax
801075ad:	88 83 9d 00 00 00    	mov    %al,0x9d(%ebx)
801075b3:	0f b6 83 9e 00 00 00 	movzbl 0x9e(%ebx),%eax
801075ba:	83 e0 f0             	and    $0xfffffff0,%eax
801075bd:	88 83 9e 00 00 00    	mov    %al,0x9e(%ebx)
801075c3:	0f b6 83 9e 00 00 00 	movzbl 0x9e(%ebx),%eax
801075ca:	83 e0 ef             	and    $0xffffffef,%eax
801075cd:	88 83 9e 00 00 00    	mov    %al,0x9e(%ebx)
801075d3:	0f b6 83 9e 00 00 00 	movzbl 0x9e(%ebx),%eax
801075da:	83 e0 df             	and    $0xffffffdf,%eax
801075dd:	88 83 9e 00 00 00    	mov    %al,0x9e(%ebx)
801075e3:	0f b6 83 9e 00 00 00 	movzbl 0x9e(%ebx),%eax
801075ea:	83 c8 40             	or     $0x40,%eax
801075ed:	88 83 9e 00 00 00    	mov    %al,0x9e(%ebx)
801075f3:	0f b6 83 9e 00 00 00 	movzbl 0x9e(%ebx),%eax
801075fa:	83 e0 7f             	and    $0x7f,%eax
801075fd:	88 83 9e 00 00 00    	mov    %al,0x9e(%ebx)
80107603:	88 93 9f 00 00 00    	mov    %dl,0x9f(%ebx)
                                sizeof(mycpu()->ts)-1, 0);
  mycpu()->gdt[SEG_TSS].s = 0;
80107609:	e8 fd c4 ff ff       	call   80103b0b <mycpu>
8010760e:	0f b6 90 9d 00 00 00 	movzbl 0x9d(%eax),%edx
80107615:	83 e2 ef             	and    $0xffffffef,%edx
80107618:	88 90 9d 00 00 00    	mov    %dl,0x9d(%eax)
  mycpu()->ts.ss0 = SEG_KDATA << 3;
8010761e:	e8 e8 c4 ff ff       	call   80103b0b <mycpu>
80107623:	66 c7 40 10 10 00    	movw   $0x10,0x10(%eax)
  mycpu()->ts.esp0 = (uint)p->kstack + KSTACKSIZE;
80107629:	8b 45 08             	mov    0x8(%ebp),%eax
8010762c:	8b 40 08             	mov    0x8(%eax),%eax
8010762f:	89 c3                	mov    %eax,%ebx
80107631:	e8 d5 c4 ff ff       	call   80103b0b <mycpu>
80107636:	8d 93 00 10 00 00    	lea    0x1000(%ebx),%edx
8010763c:	89 50 0c             	mov    %edx,0xc(%eax)
  // setting IOPL=0 in eflags *and* iomb beyond the tss segment limit
  // forbids I/O instructions (e.g., inb and outb) from user space
  mycpu()->ts.iomb = (ushort) 0xFFFF;
8010763f:	e8 c7 c4 ff ff       	call   80103b0b <mycpu>
80107644:	66 c7 40 6e ff ff    	movw   $0xffff,0x6e(%eax)
  ltr(SEG_TSS << 3);
8010764a:	83 ec 0c             	sub    $0xc,%esp
8010764d:	6a 28                	push   $0x28
8010764f:	e8 cc f8 ff ff       	call   80106f20 <ltr>
80107654:	83 c4 10             	add    $0x10,%esp
  lcr3(V2P(p->pgdir));  // switch to process's address space
80107657:	8b 45 08             	mov    0x8(%ebp),%eax
8010765a:	8b 40 04             	mov    0x4(%eax),%eax
8010765d:	05 00 00 00 80       	add    $0x80000000,%eax
80107662:	83 ec 0c             	sub    $0xc,%esp
80107665:	50                   	push   %eax
80107666:	e8 cc f8 ff ff       	call   80106f37 <lcr3>
8010766b:	83 c4 10             	add    $0x10,%esp
  popcli();
8010766e:	e8 8c d3 ff ff       	call   801049ff <popcli>
}
80107673:	90                   	nop
80107674:	8d 65 f8             	lea    -0x8(%ebp),%esp
80107677:	5b                   	pop    %ebx
80107678:	5e                   	pop    %esi
80107679:	5d                   	pop    %ebp
8010767a:	c3                   	ret    

8010767b <inituvm>:

// Load the initcode into address 0 of pgdir.
// sz must be less than a page.
void
inituvm(pde_t *pgdir, char *init, uint sz)
{
8010767b:	55                   	push   %ebp
8010767c:	89 e5                	mov    %esp,%ebp
8010767e:	83 ec 18             	sub    $0x18,%esp
  char *mem;

  if(sz >= PGSIZE)
80107681:	81 7d 10 ff 0f 00 00 	cmpl   $0xfff,0x10(%ebp)
80107688:	76 0d                	jbe    80107697 <inituvm+0x1c>
    panic("inituvm: more than a page");
8010768a:	83 ec 0c             	sub    $0xc,%esp
8010768d:	68 e9 a6 10 80       	push   $0x8010a6e9
80107692:	e8 12 8f ff ff       	call   801005a9 <panic>
  mem = kalloc();
80107697:	e8 04 b1 ff ff       	call   801027a0 <kalloc>
8010769c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  memset(mem, 0, PGSIZE);
8010769f:	83 ec 04             	sub    $0x4,%esp
801076a2:	68 00 10 00 00       	push   $0x1000
801076a7:	6a 00                	push   $0x0
801076a9:	ff 75 f4             	push   -0xc(%ebp)
801076ac:	e8 0c d4 ff ff       	call   80104abd <memset>
801076b1:	83 c4 10             	add    $0x10,%esp
  mappages(pgdir, 0, PGSIZE, V2P(mem), PTE_W|PTE_U);
801076b4:	8b 45 f4             	mov    -0xc(%ebp),%eax
801076b7:	05 00 00 00 80       	add    $0x80000000,%eax
801076bc:	83 ec 0c             	sub    $0xc,%esp
801076bf:	6a 06                	push   $0x6
801076c1:	50                   	push   %eax
801076c2:	68 00 10 00 00       	push   $0x1000
801076c7:	6a 00                	push   $0x0
801076c9:	ff 75 08             	push   0x8(%ebp)
801076cc:	e8 5e fc ff ff       	call   8010732f <mappages>
801076d1:	83 c4 20             	add    $0x20,%esp
  memmove(mem, init, sz);
801076d4:	83 ec 04             	sub    $0x4,%esp
801076d7:	ff 75 10             	push   0x10(%ebp)
801076da:	ff 75 0c             	push   0xc(%ebp)
801076dd:	ff 75 f4             	push   -0xc(%ebp)
801076e0:	e8 97 d4 ff ff       	call   80104b7c <memmove>
801076e5:	83 c4 10             	add    $0x10,%esp
}
801076e8:	90                   	nop
801076e9:	c9                   	leave  
801076ea:	c3                   	ret    

801076eb <loaduvm>:

// Load a program segment into pgdir.  addr must be page-aligned
// and the pages from addr to addr+sz must already be mapped.
int
loaduvm(pde_t *pgdir, char *addr, struct inode *ip, uint offset, uint sz)
{
801076eb:	55                   	push   %ebp
801076ec:	89 e5                	mov    %esp,%ebp
801076ee:	83 ec 18             	sub    $0x18,%esp
  uint i, pa, n;
  pte_t *pte;

  if((uint) addr % PGSIZE != 0)
801076f1:	8b 45 0c             	mov    0xc(%ebp),%eax
801076f4:	25 ff 0f 00 00       	and    $0xfff,%eax
801076f9:	85 c0                	test   %eax,%eax
801076fb:	74 0d                	je     8010770a <loaduvm+0x1f>
    panic("loaduvm: addr must be page aligned");
801076fd:	83 ec 0c             	sub    $0xc,%esp
80107700:	68 04 a7 10 80       	push   $0x8010a704
80107705:	e8 9f 8e ff ff       	call   801005a9 <panic>
  for(i = 0; i < sz; i += PGSIZE){
8010770a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80107711:	e9 8f 00 00 00       	jmp    801077a5 <loaduvm+0xba>
    if((pte = walkpgdir(pgdir, addr+i, 0)) == 0)
80107716:	8b 55 0c             	mov    0xc(%ebp),%edx
80107719:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010771c:	01 d0                	add    %edx,%eax
8010771e:	83 ec 04             	sub    $0x4,%esp
80107721:	6a 00                	push   $0x0
80107723:	50                   	push   %eax
80107724:	ff 75 08             	push   0x8(%ebp)
80107727:	e8 6d fb ff ff       	call   80107299 <walkpgdir>
8010772c:	83 c4 10             	add    $0x10,%esp
8010772f:	89 45 ec             	mov    %eax,-0x14(%ebp)
80107732:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
80107736:	75 0d                	jne    80107745 <loaduvm+0x5a>
      panic("loaduvm: address should exist");
80107738:	83 ec 0c             	sub    $0xc,%esp
8010773b:	68 27 a7 10 80       	push   $0x8010a727
80107740:	e8 64 8e ff ff       	call   801005a9 <panic>
    pa = PTE_ADDR(*pte);
80107745:	8b 45 ec             	mov    -0x14(%ebp),%eax
80107748:	8b 00                	mov    (%eax),%eax
8010774a:	25 00 f0 ff ff       	and    $0xfffff000,%eax
8010774f:	89 45 e8             	mov    %eax,-0x18(%ebp)
    if(sz - i < PGSIZE)
80107752:	8b 45 18             	mov    0x18(%ebp),%eax
80107755:	2b 45 f4             	sub    -0xc(%ebp),%eax
80107758:	3d ff 0f 00 00       	cmp    $0xfff,%eax
8010775d:	77 0b                	ja     8010776a <loaduvm+0x7f>
      n = sz - i;
8010775f:	8b 45 18             	mov    0x18(%ebp),%eax
80107762:	2b 45 f4             	sub    -0xc(%ebp),%eax
80107765:	89 45 f0             	mov    %eax,-0x10(%ebp)
80107768:	eb 07                	jmp    80107771 <loaduvm+0x86>
    else
      n = PGSIZE;
8010776a:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
    if(readi(ip, P2V(pa), offset+i, n) != n)
80107771:	8b 55 14             	mov    0x14(%ebp),%edx
80107774:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107777:	01 d0                	add    %edx,%eax
80107779:	8b 55 e8             	mov    -0x18(%ebp),%edx
8010777c:	81 c2 00 00 00 80    	add    $0x80000000,%edx
80107782:	ff 75 f0             	push   -0x10(%ebp)
80107785:	50                   	push   %eax
80107786:	52                   	push   %edx
80107787:	ff 75 10             	push   0x10(%ebp)
8010778a:	e8 47 a7 ff ff       	call   80101ed6 <readi>
8010778f:	83 c4 10             	add    $0x10,%esp
80107792:	39 45 f0             	cmp    %eax,-0x10(%ebp)
80107795:	74 07                	je     8010779e <loaduvm+0xb3>
      return -1;
80107797:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010779c:	eb 18                	jmp    801077b6 <loaduvm+0xcb>
  for(i = 0; i < sz; i += PGSIZE){
8010779e:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
801077a5:	8b 45 f4             	mov    -0xc(%ebp),%eax
801077a8:	3b 45 18             	cmp    0x18(%ebp),%eax
801077ab:	0f 82 65 ff ff ff    	jb     80107716 <loaduvm+0x2b>
  }
  return 0;
801077b1:	b8 00 00 00 00       	mov    $0x0,%eax
}
801077b6:	c9                   	leave  
801077b7:	c3                   	ret    

801077b8 <allocuvm>:

// Allocate page tables and physical memory to grow process from oldsz to
// newsz, which need not be page aligned.  Returns new size or 0 on error.
int
allocuvm(pde_t *pgdir, uint oldsz, uint newsz)
{
801077b8:	55                   	push   %ebp
801077b9:	89 e5                	mov    %esp,%ebp
801077bb:	83 ec 18             	sub    $0x18,%esp
  char *mem;
  uint a;

  if(newsz >= KERNBASE)
801077be:	8b 45 10             	mov    0x10(%ebp),%eax
801077c1:	85 c0                	test   %eax,%eax
801077c3:	79 0a                	jns    801077cf <allocuvm+0x17>
    return 0;
801077c5:	b8 00 00 00 00       	mov    $0x0,%eax
801077ca:	e9 ec 00 00 00       	jmp    801078bb <allocuvm+0x103>
  if(newsz < oldsz)
801077cf:	8b 45 10             	mov    0x10(%ebp),%eax
801077d2:	3b 45 0c             	cmp    0xc(%ebp),%eax
801077d5:	73 08                	jae    801077df <allocuvm+0x27>
    return oldsz;
801077d7:	8b 45 0c             	mov    0xc(%ebp),%eax
801077da:	e9 dc 00 00 00       	jmp    801078bb <allocuvm+0x103>

  a = PGROUNDUP(oldsz);
801077df:	8b 45 0c             	mov    0xc(%ebp),%eax
801077e2:	05 ff 0f 00 00       	add    $0xfff,%eax
801077e7:	25 00 f0 ff ff       	and    $0xfffff000,%eax
801077ec:	89 45 f4             	mov    %eax,-0xc(%ebp)
  for(; a < newsz; a += PGSIZE){
801077ef:	e9 b8 00 00 00       	jmp    801078ac <allocuvm+0xf4>
    mem = kalloc();
801077f4:	e8 a7 af ff ff       	call   801027a0 <kalloc>
801077f9:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(mem == 0){
801077fc:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80107800:	75 2e                	jne    80107830 <allocuvm+0x78>
      cprintf("allocuvm out of memory\n");
80107802:	83 ec 0c             	sub    $0xc,%esp
80107805:	68 45 a7 10 80       	push   $0x8010a745
8010780a:	e8 e5 8b ff ff       	call   801003f4 <cprintf>
8010780f:	83 c4 10             	add    $0x10,%esp
      deallocuvm(pgdir, newsz, oldsz);
80107812:	83 ec 04             	sub    $0x4,%esp
80107815:	ff 75 0c             	push   0xc(%ebp)
80107818:	ff 75 10             	push   0x10(%ebp)
8010781b:	ff 75 08             	push   0x8(%ebp)
8010781e:	e8 9a 00 00 00       	call   801078bd <deallocuvm>
80107823:	83 c4 10             	add    $0x10,%esp
      return 0;
80107826:	b8 00 00 00 00       	mov    $0x0,%eax
8010782b:	e9 8b 00 00 00       	jmp    801078bb <allocuvm+0x103>
    }
    memset(mem, 0, PGSIZE);
80107830:	83 ec 04             	sub    $0x4,%esp
80107833:	68 00 10 00 00       	push   $0x1000
80107838:	6a 00                	push   $0x0
8010783a:	ff 75 f0             	push   -0x10(%ebp)
8010783d:	e8 7b d2 ff ff       	call   80104abd <memset>
80107842:	83 c4 10             	add    $0x10,%esp
    if(mappages(pgdir, (char*)a, PGSIZE, V2P(mem), PTE_W|PTE_U) < 0){
80107845:	8b 45 f0             	mov    -0x10(%ebp),%eax
80107848:	8d 90 00 00 00 80    	lea    -0x80000000(%eax),%edx
8010784e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107851:	83 ec 0c             	sub    $0xc,%esp
80107854:	6a 06                	push   $0x6
80107856:	52                   	push   %edx
80107857:	68 00 10 00 00       	push   $0x1000
8010785c:	50                   	push   %eax
8010785d:	ff 75 08             	push   0x8(%ebp)
80107860:	e8 ca fa ff ff       	call   8010732f <mappages>
80107865:	83 c4 20             	add    $0x20,%esp
80107868:	85 c0                	test   %eax,%eax
8010786a:	79 39                	jns    801078a5 <allocuvm+0xed>
      cprintf("allocuvm out of memory (2)\n");
8010786c:	83 ec 0c             	sub    $0xc,%esp
8010786f:	68 5d a7 10 80       	push   $0x8010a75d
80107874:	e8 7b 8b ff ff       	call   801003f4 <cprintf>
80107879:	83 c4 10             	add    $0x10,%esp
      deallocuvm(pgdir, newsz, oldsz);
8010787c:	83 ec 04             	sub    $0x4,%esp
8010787f:	ff 75 0c             	push   0xc(%ebp)
80107882:	ff 75 10             	push   0x10(%ebp)
80107885:	ff 75 08             	push   0x8(%ebp)
80107888:	e8 30 00 00 00       	call   801078bd <deallocuvm>
8010788d:	83 c4 10             	add    $0x10,%esp
      kfree(mem);
80107890:	83 ec 0c             	sub    $0xc,%esp
80107893:	ff 75 f0             	push   -0x10(%ebp)
80107896:	e8 6b ae ff ff       	call   80102706 <kfree>
8010789b:	83 c4 10             	add    $0x10,%esp
      return 0;
8010789e:	b8 00 00 00 00       	mov    $0x0,%eax
801078a3:	eb 16                	jmp    801078bb <allocuvm+0x103>
  for(; a < newsz; a += PGSIZE){
801078a5:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
801078ac:	8b 45 f4             	mov    -0xc(%ebp),%eax
801078af:	3b 45 10             	cmp    0x10(%ebp),%eax
801078b2:	0f 82 3c ff ff ff    	jb     801077f4 <allocuvm+0x3c>
    }
  }
  return newsz;
801078b8:	8b 45 10             	mov    0x10(%ebp),%eax
}
801078bb:	c9                   	leave  
801078bc:	c3                   	ret    

801078bd <deallocuvm>:
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
int
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
{
801078bd:	55                   	push   %ebp
801078be:	89 e5                	mov    %esp,%ebp
801078c0:	83 ec 18             	sub    $0x18,%esp
  pte_t *pte;
  uint a, pa;

  if(newsz >= oldsz)
801078c3:	8b 45 10             	mov    0x10(%ebp),%eax
801078c6:	3b 45 0c             	cmp    0xc(%ebp),%eax
801078c9:	72 08                	jb     801078d3 <deallocuvm+0x16>
    return oldsz;
801078cb:	8b 45 0c             	mov    0xc(%ebp),%eax
801078ce:	e9 ac 00 00 00       	jmp    8010797f <deallocuvm+0xc2>

  a = PGROUNDUP(newsz);
801078d3:	8b 45 10             	mov    0x10(%ebp),%eax
801078d6:	05 ff 0f 00 00       	add    $0xfff,%eax
801078db:	25 00 f0 ff ff       	and    $0xfffff000,%eax
801078e0:	89 45 f4             	mov    %eax,-0xc(%ebp)
  for(; a  < oldsz; a += PGSIZE){
801078e3:	e9 88 00 00 00       	jmp    80107970 <deallocuvm+0xb3>
    pte = walkpgdir(pgdir, (char*)a, 0);
801078e8:	8b 45 f4             	mov    -0xc(%ebp),%eax
801078eb:	83 ec 04             	sub    $0x4,%esp
801078ee:	6a 00                	push   $0x0
801078f0:	50                   	push   %eax
801078f1:	ff 75 08             	push   0x8(%ebp)
801078f4:	e8 a0 f9 ff ff       	call   80107299 <walkpgdir>
801078f9:	83 c4 10             	add    $0x10,%esp
801078fc:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(!pte)
801078ff:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80107903:	75 16                	jne    8010791b <deallocuvm+0x5e>
      a = PGADDR(PDX(a) + 1, 0, 0) - PGSIZE;
80107905:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107908:	c1 e8 16             	shr    $0x16,%eax
8010790b:	83 c0 01             	add    $0x1,%eax
8010790e:	c1 e0 16             	shl    $0x16,%eax
80107911:	2d 00 10 00 00       	sub    $0x1000,%eax
80107916:	89 45 f4             	mov    %eax,-0xc(%ebp)
80107919:	eb 4e                	jmp    80107969 <deallocuvm+0xac>
    else if((*pte & PTE_P) != 0){
8010791b:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010791e:	8b 00                	mov    (%eax),%eax
80107920:	83 e0 01             	and    $0x1,%eax
80107923:	85 c0                	test   %eax,%eax
80107925:	74 42                	je     80107969 <deallocuvm+0xac>
      pa = PTE_ADDR(*pte);
80107927:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010792a:	8b 00                	mov    (%eax),%eax
8010792c:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80107931:	89 45 ec             	mov    %eax,-0x14(%ebp)
      if(pa == 0)
80107934:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
80107938:	75 0d                	jne    80107947 <deallocuvm+0x8a>
        panic("kfree");
8010793a:	83 ec 0c             	sub    $0xc,%esp
8010793d:	68 79 a7 10 80       	push   $0x8010a779
80107942:	e8 62 8c ff ff       	call   801005a9 <panic>
      char *v = P2V(pa);
80107947:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010794a:	05 00 00 00 80       	add    $0x80000000,%eax
8010794f:	89 45 e8             	mov    %eax,-0x18(%ebp)
      kfree(v);
80107952:	83 ec 0c             	sub    $0xc,%esp
80107955:	ff 75 e8             	push   -0x18(%ebp)
80107958:	e8 a9 ad ff ff       	call   80102706 <kfree>
8010795d:	83 c4 10             	add    $0x10,%esp
      *pte = 0;
80107960:	8b 45 f0             	mov    -0x10(%ebp),%eax
80107963:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  for(; a  < oldsz; a += PGSIZE){
80107969:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
80107970:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107973:	3b 45 0c             	cmp    0xc(%ebp),%eax
80107976:	0f 82 6c ff ff ff    	jb     801078e8 <deallocuvm+0x2b>
    }
  }
  return newsz;
8010797c:	8b 45 10             	mov    0x10(%ebp),%eax
}
8010797f:	c9                   	leave  
80107980:	c3                   	ret    

80107981 <freevm>:

// Free a page table and all the physical memory pages
// in the user part.
void
freevm(pde_t *pgdir)
{
80107981:	55                   	push   %ebp
80107982:	89 e5                	mov    %esp,%ebp
80107984:	83 ec 18             	sub    $0x18,%esp
  uint i;

  if(pgdir == 0)
80107987:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
8010798b:	75 0d                	jne    8010799a <freevm+0x19>
    panic("freevm: no pgdir");
8010798d:	83 ec 0c             	sub    $0xc,%esp
80107990:	68 7f a7 10 80       	push   $0x8010a77f
80107995:	e8 0f 8c ff ff       	call   801005a9 <panic>
  deallocuvm(pgdir, KERNBASE, 0);
8010799a:	83 ec 04             	sub    $0x4,%esp
8010799d:	6a 00                	push   $0x0
8010799f:	68 00 00 00 80       	push   $0x80000000
801079a4:	ff 75 08             	push   0x8(%ebp)
801079a7:	e8 11 ff ff ff       	call   801078bd <deallocuvm>
801079ac:	83 c4 10             	add    $0x10,%esp
  for(i = 0; i < NPDENTRIES; i++){
801079af:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
801079b6:	eb 48                	jmp    80107a00 <freevm+0x7f>
    if(pgdir[i] & PTE_P){
801079b8:	8b 45 f4             	mov    -0xc(%ebp),%eax
801079bb:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
801079c2:	8b 45 08             	mov    0x8(%ebp),%eax
801079c5:	01 d0                	add    %edx,%eax
801079c7:	8b 00                	mov    (%eax),%eax
801079c9:	83 e0 01             	and    $0x1,%eax
801079cc:	85 c0                	test   %eax,%eax
801079ce:	74 2c                	je     801079fc <freevm+0x7b>
      char * v = P2V(PTE_ADDR(pgdir[i]));
801079d0:	8b 45 f4             	mov    -0xc(%ebp),%eax
801079d3:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
801079da:	8b 45 08             	mov    0x8(%ebp),%eax
801079dd:	01 d0                	add    %edx,%eax
801079df:	8b 00                	mov    (%eax),%eax
801079e1:	25 00 f0 ff ff       	and    $0xfffff000,%eax
801079e6:	05 00 00 00 80       	add    $0x80000000,%eax
801079eb:	89 45 f0             	mov    %eax,-0x10(%ebp)
      kfree(v);
801079ee:	83 ec 0c             	sub    $0xc,%esp
801079f1:	ff 75 f0             	push   -0x10(%ebp)
801079f4:	e8 0d ad ff ff       	call   80102706 <kfree>
801079f9:	83 c4 10             	add    $0x10,%esp
  for(i = 0; i < NPDENTRIES; i++){
801079fc:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80107a00:	81 7d f4 ff 03 00 00 	cmpl   $0x3ff,-0xc(%ebp)
80107a07:	76 af                	jbe    801079b8 <freevm+0x37>
    }
  }
  kfree((char*)pgdir);
80107a09:	83 ec 0c             	sub    $0xc,%esp
80107a0c:	ff 75 08             	push   0x8(%ebp)
80107a0f:	e8 f2 ac ff ff       	call   80102706 <kfree>
80107a14:	83 c4 10             	add    $0x10,%esp
}
80107a17:	90                   	nop
80107a18:	c9                   	leave  
80107a19:	c3                   	ret    

80107a1a <clearpteu>:

// Clear PTE_U on a page. Used to create an inaccessible
// page beneath the user stack.
void
clearpteu(pde_t *pgdir, char *uva)
{
80107a1a:	55                   	push   %ebp
80107a1b:	89 e5                	mov    %esp,%ebp
80107a1d:	83 ec 18             	sub    $0x18,%esp
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
80107a20:	83 ec 04             	sub    $0x4,%esp
80107a23:	6a 00                	push   $0x0
80107a25:	ff 75 0c             	push   0xc(%ebp)
80107a28:	ff 75 08             	push   0x8(%ebp)
80107a2b:	e8 69 f8 ff ff       	call   80107299 <walkpgdir>
80107a30:	83 c4 10             	add    $0x10,%esp
80107a33:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(pte == 0)
80107a36:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80107a3a:	75 0d                	jne    80107a49 <clearpteu+0x2f>
    panic("clearpteu");
80107a3c:	83 ec 0c             	sub    $0xc,%esp
80107a3f:	68 90 a7 10 80       	push   $0x8010a790
80107a44:	e8 60 8b ff ff       	call   801005a9 <panic>
  *pte &= ~PTE_U;
80107a49:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107a4c:	8b 00                	mov    (%eax),%eax
80107a4e:	83 e0 fb             	and    $0xfffffffb,%eax
80107a51:	89 c2                	mov    %eax,%edx
80107a53:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107a56:	89 10                	mov    %edx,(%eax)
}
80107a58:	90                   	nop
80107a59:	c9                   	leave  
80107a5a:	c3                   	ret    

80107a5b <copyuvm>:

// Given a parent process's page table, create a copy
// of it for a child.
pde_t*
copyuvm(pde_t *pgdir, uint sz)
{
80107a5b:	55                   	push   %ebp
80107a5c:	89 e5                	mov    %esp,%ebp
80107a5e:	83 ec 28             	sub    $0x28,%esp
  pde_t *d;
  pte_t *pte;
  uint pa, i, flags;
  char *mem;

  if((d = setupkvm()) == 0)
80107a61:	e8 59 f9 ff ff       	call   801073bf <setupkvm>
80107a66:	89 45 f0             	mov    %eax,-0x10(%ebp)
80107a69:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80107a6d:	75 0a                	jne    80107a79 <copyuvm+0x1e>
    return 0;
80107a6f:	b8 00 00 00 00       	mov    $0x0,%eax
80107a74:	e9 eb 00 00 00       	jmp    80107b64 <copyuvm+0x109>
  for(i = 0; i < sz; i += PGSIZE){
80107a79:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80107a80:	e9 b7 00 00 00       	jmp    80107b3c <copyuvm+0xe1>
    if((pte = walkpgdir(pgdir, (void *) i, 0)) == 0)
80107a85:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107a88:	83 ec 04             	sub    $0x4,%esp
80107a8b:	6a 00                	push   $0x0
80107a8d:	50                   	push   %eax
80107a8e:	ff 75 08             	push   0x8(%ebp)
80107a91:	e8 03 f8 ff ff       	call   80107299 <walkpgdir>
80107a96:	83 c4 10             	add    $0x10,%esp
80107a99:	89 45 ec             	mov    %eax,-0x14(%ebp)
80107a9c:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
80107aa0:	75 0d                	jne    80107aaf <copyuvm+0x54>
      panic("copyuvm: pte should exist");
80107aa2:	83 ec 0c             	sub    $0xc,%esp
80107aa5:	68 9a a7 10 80       	push   $0x8010a79a
80107aaa:	e8 fa 8a ff ff       	call   801005a9 <panic>
    if(!(*pte & PTE_P))
80107aaf:	8b 45 ec             	mov    -0x14(%ebp),%eax
80107ab2:	8b 00                	mov    (%eax),%eax
80107ab4:	83 e0 01             	and    $0x1,%eax
80107ab7:	85 c0                	test   %eax,%eax
80107ab9:	75 0d                	jne    80107ac8 <copyuvm+0x6d>
      panic("copyuvm: page not present");
80107abb:	83 ec 0c             	sub    $0xc,%esp
80107abe:	68 b4 a7 10 80       	push   $0x8010a7b4
80107ac3:	e8 e1 8a ff ff       	call   801005a9 <panic>
    pa = PTE_ADDR(*pte);
80107ac8:	8b 45 ec             	mov    -0x14(%ebp),%eax
80107acb:	8b 00                	mov    (%eax),%eax
80107acd:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80107ad2:	89 45 e8             	mov    %eax,-0x18(%ebp)
    flags = PTE_FLAGS(*pte);
80107ad5:	8b 45 ec             	mov    -0x14(%ebp),%eax
80107ad8:	8b 00                	mov    (%eax),%eax
80107ada:	25 ff 0f 00 00       	and    $0xfff,%eax
80107adf:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if((mem = kalloc()) == 0)
80107ae2:	e8 b9 ac ff ff       	call   801027a0 <kalloc>
80107ae7:	89 45 e0             	mov    %eax,-0x20(%ebp)
80107aea:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
80107aee:	74 5d                	je     80107b4d <copyuvm+0xf2>
      goto bad;
    memmove(mem, (char*)P2V(pa), PGSIZE);
80107af0:	8b 45 e8             	mov    -0x18(%ebp),%eax
80107af3:	05 00 00 00 80       	add    $0x80000000,%eax
80107af8:	83 ec 04             	sub    $0x4,%esp
80107afb:	68 00 10 00 00       	push   $0x1000
80107b00:	50                   	push   %eax
80107b01:	ff 75 e0             	push   -0x20(%ebp)
80107b04:	e8 73 d0 ff ff       	call   80104b7c <memmove>
80107b09:	83 c4 10             	add    $0x10,%esp
    if(mappages(d, (void*)i, PGSIZE, V2P(mem), flags) < 0)
80107b0c:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80107b0f:	8b 45 e0             	mov    -0x20(%ebp),%eax
80107b12:	8d 88 00 00 00 80    	lea    -0x80000000(%eax),%ecx
80107b18:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107b1b:	83 ec 0c             	sub    $0xc,%esp
80107b1e:	52                   	push   %edx
80107b1f:	51                   	push   %ecx
80107b20:	68 00 10 00 00       	push   $0x1000
80107b25:	50                   	push   %eax
80107b26:	ff 75 f0             	push   -0x10(%ebp)
80107b29:	e8 01 f8 ff ff       	call   8010732f <mappages>
80107b2e:	83 c4 20             	add    $0x20,%esp
80107b31:	85 c0                	test   %eax,%eax
80107b33:	78 1b                	js     80107b50 <copyuvm+0xf5>
  for(i = 0; i < sz; i += PGSIZE){
80107b35:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
80107b3c:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107b3f:	3b 45 0c             	cmp    0xc(%ebp),%eax
80107b42:	0f 82 3d ff ff ff    	jb     80107a85 <copyuvm+0x2a>
      goto bad;
  }
  return d;
80107b48:	8b 45 f0             	mov    -0x10(%ebp),%eax
80107b4b:	eb 17                	jmp    80107b64 <copyuvm+0x109>
      goto bad;
80107b4d:	90                   	nop
80107b4e:	eb 01                	jmp    80107b51 <copyuvm+0xf6>
      goto bad;
80107b50:	90                   	nop

bad:
  freevm(d);
80107b51:	83 ec 0c             	sub    $0xc,%esp
80107b54:	ff 75 f0             	push   -0x10(%ebp)
80107b57:	e8 25 fe ff ff       	call   80107981 <freevm>
80107b5c:	83 c4 10             	add    $0x10,%esp
  return 0;
80107b5f:	b8 00 00 00 00       	mov    $0x0,%eax
}
80107b64:	c9                   	leave  
80107b65:	c3                   	ret    

80107b66 <uva2ka>:

//PAGEBREAK!
// Map user virtual address to kernel address.
char*
uva2ka(pde_t *pgdir, char *uva)
{
80107b66:	55                   	push   %ebp
80107b67:	89 e5                	mov    %esp,%ebp
80107b69:	83 ec 18             	sub    $0x18,%esp
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
80107b6c:	83 ec 04             	sub    $0x4,%esp
80107b6f:	6a 00                	push   $0x0
80107b71:	ff 75 0c             	push   0xc(%ebp)
80107b74:	ff 75 08             	push   0x8(%ebp)
80107b77:	e8 1d f7 ff ff       	call   80107299 <walkpgdir>
80107b7c:	83 c4 10             	add    $0x10,%esp
80107b7f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if((*pte & PTE_P) == 0)
80107b82:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107b85:	8b 00                	mov    (%eax),%eax
80107b87:	83 e0 01             	and    $0x1,%eax
80107b8a:	85 c0                	test   %eax,%eax
80107b8c:	75 07                	jne    80107b95 <uva2ka+0x2f>
    return 0;
80107b8e:	b8 00 00 00 00       	mov    $0x0,%eax
80107b93:	eb 22                	jmp    80107bb7 <uva2ka+0x51>
  if((*pte & PTE_U) == 0)
80107b95:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107b98:	8b 00                	mov    (%eax),%eax
80107b9a:	83 e0 04             	and    $0x4,%eax
80107b9d:	85 c0                	test   %eax,%eax
80107b9f:	75 07                	jne    80107ba8 <uva2ka+0x42>
    return 0;
80107ba1:	b8 00 00 00 00       	mov    $0x0,%eax
80107ba6:	eb 0f                	jmp    80107bb7 <uva2ka+0x51>
  return (char*)P2V(PTE_ADDR(*pte));
80107ba8:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107bab:	8b 00                	mov    (%eax),%eax
80107bad:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80107bb2:	05 00 00 00 80       	add    $0x80000000,%eax
}
80107bb7:	c9                   	leave  
80107bb8:	c3                   	ret    

80107bb9 <copyout>:
// Copy len bytes from p to user address va in page table pgdir.
// Most useful when pgdir is not the current page table.
// uva2ka ensures this only works for PTE_U pages.
int
copyout(pde_t *pgdir, uint va, void *p, uint len)
{
80107bb9:	55                   	push   %ebp
80107bba:	89 e5                	mov    %esp,%ebp
80107bbc:	83 ec 18             	sub    $0x18,%esp
  char *buf, *pa0;
  uint n, va0;

  buf = (char*)p;
80107bbf:	8b 45 10             	mov    0x10(%ebp),%eax
80107bc2:	89 45 f4             	mov    %eax,-0xc(%ebp)
  while(len > 0){
80107bc5:	eb 7f                	jmp    80107c46 <copyout+0x8d>
    va0 = (uint)PGROUNDDOWN(va);
80107bc7:	8b 45 0c             	mov    0xc(%ebp),%eax
80107bca:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80107bcf:	89 45 ec             	mov    %eax,-0x14(%ebp)
    pa0 = uva2ka(pgdir, (char*)va0);
80107bd2:	8b 45 ec             	mov    -0x14(%ebp),%eax
80107bd5:	83 ec 08             	sub    $0x8,%esp
80107bd8:	50                   	push   %eax
80107bd9:	ff 75 08             	push   0x8(%ebp)
80107bdc:	e8 85 ff ff ff       	call   80107b66 <uva2ka>
80107be1:	83 c4 10             	add    $0x10,%esp
80107be4:	89 45 e8             	mov    %eax,-0x18(%ebp)
    if(pa0 == 0)
80107be7:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
80107beb:	75 07                	jne    80107bf4 <copyout+0x3b>
      return -1;
80107bed:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80107bf2:	eb 61                	jmp    80107c55 <copyout+0x9c>
    n = PGSIZE - (va - va0);
80107bf4:	8b 45 ec             	mov    -0x14(%ebp),%eax
80107bf7:	2b 45 0c             	sub    0xc(%ebp),%eax
80107bfa:	05 00 10 00 00       	add    $0x1000,%eax
80107bff:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(n > len)
80107c02:	8b 45 f0             	mov    -0x10(%ebp),%eax
80107c05:	3b 45 14             	cmp    0x14(%ebp),%eax
80107c08:	76 06                	jbe    80107c10 <copyout+0x57>
      n = len;
80107c0a:	8b 45 14             	mov    0x14(%ebp),%eax
80107c0d:	89 45 f0             	mov    %eax,-0x10(%ebp)
    memmove(pa0 + (va - va0), buf, n);
80107c10:	8b 45 0c             	mov    0xc(%ebp),%eax
80107c13:	2b 45 ec             	sub    -0x14(%ebp),%eax
80107c16:	89 c2                	mov    %eax,%edx
80107c18:	8b 45 e8             	mov    -0x18(%ebp),%eax
80107c1b:	01 d0                	add    %edx,%eax
80107c1d:	83 ec 04             	sub    $0x4,%esp
80107c20:	ff 75 f0             	push   -0x10(%ebp)
80107c23:	ff 75 f4             	push   -0xc(%ebp)
80107c26:	50                   	push   %eax
80107c27:	e8 50 cf ff ff       	call   80104b7c <memmove>
80107c2c:	83 c4 10             	add    $0x10,%esp
    len -= n;
80107c2f:	8b 45 f0             	mov    -0x10(%ebp),%eax
80107c32:	29 45 14             	sub    %eax,0x14(%ebp)
    buf += n;
80107c35:	8b 45 f0             	mov    -0x10(%ebp),%eax
80107c38:	01 45 f4             	add    %eax,-0xc(%ebp)
    va = va0 + PGSIZE;
80107c3b:	8b 45 ec             	mov    -0x14(%ebp),%eax
80107c3e:	05 00 10 00 00       	add    $0x1000,%eax
80107c43:	89 45 0c             	mov    %eax,0xc(%ebp)
  while(len > 0){
80107c46:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
80107c4a:	0f 85 77 ff ff ff    	jne    80107bc7 <copyout+0xe>
  }
  return 0;
80107c50:	b8 00 00 00 00       	mov    $0x0,%eax
}
80107c55:	c9                   	leave  
80107c56:	c3                   	ret    

80107c57 <mpinit_uefi>:

struct cpu cpus[NCPU];
int ncpu;
uchar ioapicid;
void mpinit_uefi(void)
{
80107c57:	55                   	push   %ebp
80107c58:	89 e5                	mov    %esp,%ebp
80107c5a:	83 ec 20             	sub    $0x20,%esp
  struct boot_param *boot_param = (struct boot_param *)P2V_WO(BOOTPARAM);
80107c5d:	c7 45 f8 00 00 05 80 	movl   $0x80050000,-0x8(%ebp)
  struct uefi_madt *madt = (struct uefi_madt*)(P2V_WO(boot_param->madt_addr));
80107c64:	8b 45 f8             	mov    -0x8(%ebp),%eax
80107c67:	8b 40 08             	mov    0x8(%eax),%eax
80107c6a:	05 00 00 00 80       	add    $0x80000000,%eax
80107c6f:	89 45 f4             	mov    %eax,-0xc(%ebp)

  uint i=sizeof(struct uefi_madt);
80107c72:	c7 45 fc 2c 00 00 00 	movl   $0x2c,-0x4(%ebp)
  struct uefi_lapic *lapic_entry;
  struct uefi_ioapic *ioapic;
  struct uefi_iso *iso;
  struct uefi_non_maskable_intr *non_mask_intr; 
  
  lapic = (uint *)(madt->lapic_addr);
80107c79:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107c7c:	8b 40 24             	mov    0x24(%eax),%eax
80107c7f:	a3 00 41 19 80       	mov    %eax,0x80194100
  ncpu = 0;
80107c84:	c7 05 40 6c 19 80 00 	movl   $0x0,0x80196c40
80107c8b:	00 00 00 

  while(i<madt->len){
80107c8e:	90                   	nop
80107c8f:	e9 bd 00 00 00       	jmp    80107d51 <mpinit_uefi+0xfa>
    uchar *entry_type = ((uchar *)madt)+i;
80107c94:	8b 55 f4             	mov    -0xc(%ebp),%edx
80107c97:	8b 45 fc             	mov    -0x4(%ebp),%eax
80107c9a:	01 d0                	add    %edx,%eax
80107c9c:	89 45 f0             	mov    %eax,-0x10(%ebp)
    switch(*entry_type){
80107c9f:	8b 45 f0             	mov    -0x10(%ebp),%eax
80107ca2:	0f b6 00             	movzbl (%eax),%eax
80107ca5:	0f b6 c0             	movzbl %al,%eax
80107ca8:	83 f8 05             	cmp    $0x5,%eax
80107cab:	0f 87 a0 00 00 00    	ja     80107d51 <mpinit_uefi+0xfa>
80107cb1:	8b 04 85 d0 a7 10 80 	mov    -0x7fef5830(,%eax,4),%eax
80107cb8:	ff e0                	jmp    *%eax
      case 0:
        lapic_entry = (struct uefi_lapic *)entry_type;
80107cba:	8b 45 f0             	mov    -0x10(%ebp),%eax
80107cbd:	89 45 e0             	mov    %eax,-0x20(%ebp)
        if(ncpu < NCPU) {
80107cc0:	a1 40 6c 19 80       	mov    0x80196c40,%eax
80107cc5:	83 f8 03             	cmp    $0x3,%eax
80107cc8:	7f 28                	jg     80107cf2 <mpinit_uefi+0x9b>
          cpus[ncpu].apicid = lapic_entry->lapic_id;
80107cca:	8b 15 40 6c 19 80    	mov    0x80196c40,%edx
80107cd0:	8b 45 e0             	mov    -0x20(%ebp),%eax
80107cd3:	0f b6 40 03          	movzbl 0x3(%eax),%eax
80107cd7:	69 d2 b0 00 00 00    	imul   $0xb0,%edx,%edx
80107cdd:	81 c2 80 69 19 80    	add    $0x80196980,%edx
80107ce3:	88 02                	mov    %al,(%edx)
          ncpu++;
80107ce5:	a1 40 6c 19 80       	mov    0x80196c40,%eax
80107cea:	83 c0 01             	add    $0x1,%eax
80107ced:	a3 40 6c 19 80       	mov    %eax,0x80196c40
        }
        i += lapic_entry->record_len;
80107cf2:	8b 45 e0             	mov    -0x20(%ebp),%eax
80107cf5:	0f b6 40 01          	movzbl 0x1(%eax),%eax
80107cf9:	0f b6 c0             	movzbl %al,%eax
80107cfc:	01 45 fc             	add    %eax,-0x4(%ebp)
        break;
80107cff:	eb 50                	jmp    80107d51 <mpinit_uefi+0xfa>

      case 1:
        ioapic = (struct uefi_ioapic *)entry_type;
80107d01:	8b 45 f0             	mov    -0x10(%ebp),%eax
80107d04:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        ioapicid = ioapic->ioapic_id;
80107d07:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80107d0a:	0f b6 40 02          	movzbl 0x2(%eax),%eax
80107d0e:	a2 44 6c 19 80       	mov    %al,0x80196c44
        i += ioapic->record_len;
80107d13:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80107d16:	0f b6 40 01          	movzbl 0x1(%eax),%eax
80107d1a:	0f b6 c0             	movzbl %al,%eax
80107d1d:	01 45 fc             	add    %eax,-0x4(%ebp)
        break;
80107d20:	eb 2f                	jmp    80107d51 <mpinit_uefi+0xfa>

      case 2:
        iso = (struct uefi_iso *)entry_type;
80107d22:	8b 45 f0             	mov    -0x10(%ebp),%eax
80107d25:	89 45 e8             	mov    %eax,-0x18(%ebp)
        i += iso->record_len;
80107d28:	8b 45 e8             	mov    -0x18(%ebp),%eax
80107d2b:	0f b6 40 01          	movzbl 0x1(%eax),%eax
80107d2f:	0f b6 c0             	movzbl %al,%eax
80107d32:	01 45 fc             	add    %eax,-0x4(%ebp)
        break;
80107d35:	eb 1a                	jmp    80107d51 <mpinit_uefi+0xfa>

      case 4:
        non_mask_intr = (struct uefi_non_maskable_intr *)entry_type;
80107d37:	8b 45 f0             	mov    -0x10(%ebp),%eax
80107d3a:	89 45 ec             	mov    %eax,-0x14(%ebp)
        i += non_mask_intr->record_len;
80107d3d:	8b 45 ec             	mov    -0x14(%ebp),%eax
80107d40:	0f b6 40 01          	movzbl 0x1(%eax),%eax
80107d44:	0f b6 c0             	movzbl %al,%eax
80107d47:	01 45 fc             	add    %eax,-0x4(%ebp)
        break;
80107d4a:	eb 05                	jmp    80107d51 <mpinit_uefi+0xfa>

      case 5:
        i = i + 0xC;
80107d4c:	83 45 fc 0c          	addl   $0xc,-0x4(%ebp)
        break;
80107d50:	90                   	nop
  while(i<madt->len){
80107d51:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107d54:	8b 40 04             	mov    0x4(%eax),%eax
80107d57:	39 45 fc             	cmp    %eax,-0x4(%ebp)
80107d5a:	0f 82 34 ff ff ff    	jb     80107c94 <mpinit_uefi+0x3d>
    }
  }

}
80107d60:	90                   	nop
80107d61:	90                   	nop
80107d62:	c9                   	leave  
80107d63:	c3                   	ret    

80107d64 <inb>:
{
80107d64:	55                   	push   %ebp
80107d65:	89 e5                	mov    %esp,%ebp
80107d67:	83 ec 14             	sub    $0x14,%esp
80107d6a:	8b 45 08             	mov    0x8(%ebp),%eax
80107d6d:	66 89 45 ec          	mov    %ax,-0x14(%ebp)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80107d71:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
80107d75:	89 c2                	mov    %eax,%edx
80107d77:	ec                   	in     (%dx),%al
80107d78:	88 45 ff             	mov    %al,-0x1(%ebp)
  return data;
80107d7b:	0f b6 45 ff          	movzbl -0x1(%ebp),%eax
}
80107d7f:	c9                   	leave  
80107d80:	c3                   	ret    

80107d81 <outb>:
{
80107d81:	55                   	push   %ebp
80107d82:	89 e5                	mov    %esp,%ebp
80107d84:	83 ec 08             	sub    $0x8,%esp
80107d87:	8b 45 08             	mov    0x8(%ebp),%eax
80107d8a:	8b 55 0c             	mov    0xc(%ebp),%edx
80107d8d:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
80107d91:	89 d0                	mov    %edx,%eax
80107d93:	88 45 f8             	mov    %al,-0x8(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80107d96:	0f b6 45 f8          	movzbl -0x8(%ebp),%eax
80107d9a:	0f b7 55 fc          	movzwl -0x4(%ebp),%edx
80107d9e:	ee                   	out    %al,(%dx)
}
80107d9f:	90                   	nop
80107da0:	c9                   	leave  
80107da1:	c3                   	ret    

80107da2 <uart_debug>:
#include "proc.h"
#include "x86.h"

#define COM1    0x3f8

void uart_debug(char p){
80107da2:	55                   	push   %ebp
80107da3:	89 e5                	mov    %esp,%ebp
80107da5:	83 ec 28             	sub    $0x28,%esp
80107da8:	8b 45 08             	mov    0x8(%ebp),%eax
80107dab:	88 45 e4             	mov    %al,-0x1c(%ebp)
    // Turn off the FIFO
  outb(COM1+2, 0);
80107dae:	6a 00                	push   $0x0
80107db0:	68 fa 03 00 00       	push   $0x3fa
80107db5:	e8 c7 ff ff ff       	call   80107d81 <outb>
80107dba:	83 c4 08             	add    $0x8,%esp

  // 9600 baud, 8 data bits, 1 stop bit, parity off.
  outb(COM1+3, 0x80);    // Unlock divisor
80107dbd:	68 80 00 00 00       	push   $0x80
80107dc2:	68 fb 03 00 00       	push   $0x3fb
80107dc7:	e8 b5 ff ff ff       	call   80107d81 <outb>
80107dcc:	83 c4 08             	add    $0x8,%esp
  outb(COM1+0, 115200/9600);
80107dcf:	6a 0c                	push   $0xc
80107dd1:	68 f8 03 00 00       	push   $0x3f8
80107dd6:	e8 a6 ff ff ff       	call   80107d81 <outb>
80107ddb:	83 c4 08             	add    $0x8,%esp
  outb(COM1+1, 0);
80107dde:	6a 00                	push   $0x0
80107de0:	68 f9 03 00 00       	push   $0x3f9
80107de5:	e8 97 ff ff ff       	call   80107d81 <outb>
80107dea:	83 c4 08             	add    $0x8,%esp
  outb(COM1+3, 0x03);    // Lock divisor, 8 data bits.
80107ded:	6a 03                	push   $0x3
80107def:	68 fb 03 00 00       	push   $0x3fb
80107df4:	e8 88 ff ff ff       	call   80107d81 <outb>
80107df9:	83 c4 08             	add    $0x8,%esp
  outb(COM1+4, 0);
80107dfc:	6a 00                	push   $0x0
80107dfe:	68 fc 03 00 00       	push   $0x3fc
80107e03:	e8 79 ff ff ff       	call   80107d81 <outb>
80107e08:	83 c4 08             	add    $0x8,%esp

  for(int i=0;i<128 && !(inb(COM1+5) & 0x20); i++) microdelay(10);
80107e0b:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80107e12:	eb 11                	jmp    80107e25 <uart_debug+0x83>
80107e14:	83 ec 0c             	sub    $0xc,%esp
80107e17:	6a 0a                	push   $0xa
80107e19:	e8 19 ad ff ff       	call   80102b37 <microdelay>
80107e1e:	83 c4 10             	add    $0x10,%esp
80107e21:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80107e25:	83 7d f4 7f          	cmpl   $0x7f,-0xc(%ebp)
80107e29:	7f 1a                	jg     80107e45 <uart_debug+0xa3>
80107e2b:	83 ec 0c             	sub    $0xc,%esp
80107e2e:	68 fd 03 00 00       	push   $0x3fd
80107e33:	e8 2c ff ff ff       	call   80107d64 <inb>
80107e38:	83 c4 10             	add    $0x10,%esp
80107e3b:	0f b6 c0             	movzbl %al,%eax
80107e3e:	83 e0 20             	and    $0x20,%eax
80107e41:	85 c0                	test   %eax,%eax
80107e43:	74 cf                	je     80107e14 <uart_debug+0x72>
  outb(COM1+0, p);
80107e45:	0f b6 45 e4          	movzbl -0x1c(%ebp),%eax
80107e49:	0f b6 c0             	movzbl %al,%eax
80107e4c:	83 ec 08             	sub    $0x8,%esp
80107e4f:	50                   	push   %eax
80107e50:	68 f8 03 00 00       	push   $0x3f8
80107e55:	e8 27 ff ff ff       	call   80107d81 <outb>
80107e5a:	83 c4 10             	add    $0x10,%esp
}
80107e5d:	90                   	nop
80107e5e:	c9                   	leave  
80107e5f:	c3                   	ret    

80107e60 <uart_debugs>:

void uart_debugs(char *p){
80107e60:	55                   	push   %ebp
80107e61:	89 e5                	mov    %esp,%ebp
80107e63:	83 ec 08             	sub    $0x8,%esp
  while(*p){
80107e66:	eb 1b                	jmp    80107e83 <uart_debugs+0x23>
    uart_debug(*p++);
80107e68:	8b 45 08             	mov    0x8(%ebp),%eax
80107e6b:	8d 50 01             	lea    0x1(%eax),%edx
80107e6e:	89 55 08             	mov    %edx,0x8(%ebp)
80107e71:	0f b6 00             	movzbl (%eax),%eax
80107e74:	0f be c0             	movsbl %al,%eax
80107e77:	83 ec 0c             	sub    $0xc,%esp
80107e7a:	50                   	push   %eax
80107e7b:	e8 22 ff ff ff       	call   80107da2 <uart_debug>
80107e80:	83 c4 10             	add    $0x10,%esp
  while(*p){
80107e83:	8b 45 08             	mov    0x8(%ebp),%eax
80107e86:	0f b6 00             	movzbl (%eax),%eax
80107e89:	84 c0                	test   %al,%al
80107e8b:	75 db                	jne    80107e68 <uart_debugs+0x8>
  }
}
80107e8d:	90                   	nop
80107e8e:	90                   	nop
80107e8f:	c9                   	leave  
80107e90:	c3                   	ret    

80107e91 <graphic_init>:
 * i%4 = 2 : red
 * i%4 = 3 : black
 */

struct gpu gpu;
void graphic_init(){
80107e91:	55                   	push   %ebp
80107e92:	89 e5                	mov    %esp,%ebp
80107e94:	83 ec 10             	sub    $0x10,%esp
  struct boot_param *boot_param = (struct boot_param *)P2V_WO(BOOTPARAM);
80107e97:	c7 45 fc 00 00 05 80 	movl   $0x80050000,-0x4(%ebp)
  gpu.pvram_addr = boot_param->graphic_config.frame_base;
80107e9e:	8b 45 fc             	mov    -0x4(%ebp),%eax
80107ea1:	8b 50 14             	mov    0x14(%eax),%edx
80107ea4:	8b 40 10             	mov    0x10(%eax),%eax
80107ea7:	a3 48 6c 19 80       	mov    %eax,0x80196c48
  gpu.vram_size = boot_param->graphic_config.frame_size;
80107eac:	8b 45 fc             	mov    -0x4(%ebp),%eax
80107eaf:	8b 50 1c             	mov    0x1c(%eax),%edx
80107eb2:	8b 40 18             	mov    0x18(%eax),%eax
80107eb5:	a3 50 6c 19 80       	mov    %eax,0x80196c50
  gpu.vvram_addr = DEVSPACE - gpu.vram_size;
80107eba:	8b 15 50 6c 19 80    	mov    0x80196c50,%edx
80107ec0:	b8 00 00 00 fe       	mov    $0xfe000000,%eax
80107ec5:	29 d0                	sub    %edx,%eax
80107ec7:	a3 4c 6c 19 80       	mov    %eax,0x80196c4c
  gpu.horizontal_resolution = (uint)(boot_param->graphic_config.horizontal_resolution & 0xFFFFFFFF);
80107ecc:	8b 45 fc             	mov    -0x4(%ebp),%eax
80107ecf:	8b 50 24             	mov    0x24(%eax),%edx
80107ed2:	8b 40 20             	mov    0x20(%eax),%eax
80107ed5:	a3 54 6c 19 80       	mov    %eax,0x80196c54
  gpu.vertical_resolution = (uint)(boot_param->graphic_config.vertical_resolution & 0xFFFFFFFF);
80107eda:	8b 45 fc             	mov    -0x4(%ebp),%eax
80107edd:	8b 50 2c             	mov    0x2c(%eax),%edx
80107ee0:	8b 40 28             	mov    0x28(%eax),%eax
80107ee3:	a3 58 6c 19 80       	mov    %eax,0x80196c58
  gpu.pixels_per_line = (uint)(boot_param->graphic_config.pixels_per_line & 0xFFFFFFFF);
80107ee8:	8b 45 fc             	mov    -0x4(%ebp),%eax
80107eeb:	8b 50 34             	mov    0x34(%eax),%edx
80107eee:	8b 40 30             	mov    0x30(%eax),%eax
80107ef1:	a3 5c 6c 19 80       	mov    %eax,0x80196c5c
}
80107ef6:	90                   	nop
80107ef7:	c9                   	leave  
80107ef8:	c3                   	ret    

80107ef9 <graphic_draw_pixel>:

void graphic_draw_pixel(int x,int y,struct graphic_pixel * buffer){
80107ef9:	55                   	push   %ebp
80107efa:	89 e5                	mov    %esp,%ebp
80107efc:	83 ec 10             	sub    $0x10,%esp
  int pixel_addr = (sizeof(struct graphic_pixel))*(y*gpu.pixels_per_line + x);
80107eff:	8b 15 5c 6c 19 80    	mov    0x80196c5c,%edx
80107f05:	8b 45 0c             	mov    0xc(%ebp),%eax
80107f08:	0f af d0             	imul   %eax,%edx
80107f0b:	8b 45 08             	mov    0x8(%ebp),%eax
80107f0e:	01 d0                	add    %edx,%eax
80107f10:	c1 e0 02             	shl    $0x2,%eax
80107f13:	89 45 fc             	mov    %eax,-0x4(%ebp)
  struct graphic_pixel *pixel = (struct graphic_pixel *)(gpu.vvram_addr + pixel_addr);
80107f16:	8b 15 4c 6c 19 80    	mov    0x80196c4c,%edx
80107f1c:	8b 45 fc             	mov    -0x4(%ebp),%eax
80107f1f:	01 d0                	add    %edx,%eax
80107f21:	89 45 f8             	mov    %eax,-0x8(%ebp)
  pixel->blue = buffer->blue;
80107f24:	8b 45 10             	mov    0x10(%ebp),%eax
80107f27:	0f b6 10             	movzbl (%eax),%edx
80107f2a:	8b 45 f8             	mov    -0x8(%ebp),%eax
80107f2d:	88 10                	mov    %dl,(%eax)
  pixel->green = buffer->green;
80107f2f:	8b 45 10             	mov    0x10(%ebp),%eax
80107f32:	0f b6 50 01          	movzbl 0x1(%eax),%edx
80107f36:	8b 45 f8             	mov    -0x8(%ebp),%eax
80107f39:	88 50 01             	mov    %dl,0x1(%eax)
  pixel->red = buffer->red;
80107f3c:	8b 45 10             	mov    0x10(%ebp),%eax
80107f3f:	0f b6 50 02          	movzbl 0x2(%eax),%edx
80107f43:	8b 45 f8             	mov    -0x8(%ebp),%eax
80107f46:	88 50 02             	mov    %dl,0x2(%eax)
}
80107f49:	90                   	nop
80107f4a:	c9                   	leave  
80107f4b:	c3                   	ret    

80107f4c <graphic_scroll_up>:

void graphic_scroll_up(int height){
80107f4c:	55                   	push   %ebp
80107f4d:	89 e5                	mov    %esp,%ebp
80107f4f:	83 ec 18             	sub    $0x18,%esp
  int addr_diff = (sizeof(struct graphic_pixel))*gpu.pixels_per_line*height;
80107f52:	8b 15 5c 6c 19 80    	mov    0x80196c5c,%edx
80107f58:	8b 45 08             	mov    0x8(%ebp),%eax
80107f5b:	0f af c2             	imul   %edx,%eax
80107f5e:	c1 e0 02             	shl    $0x2,%eax
80107f61:	89 45 f4             	mov    %eax,-0xc(%ebp)
  memmove((unsigned int *)gpu.vvram_addr,(unsigned int *)(gpu.vvram_addr + addr_diff),gpu.vram_size - addr_diff);
80107f64:	a1 50 6c 19 80       	mov    0x80196c50,%eax
80107f69:	8b 55 f4             	mov    -0xc(%ebp),%edx
80107f6c:	29 d0                	sub    %edx,%eax
80107f6e:	8b 0d 4c 6c 19 80    	mov    0x80196c4c,%ecx
80107f74:	8b 55 f4             	mov    -0xc(%ebp),%edx
80107f77:	01 ca                	add    %ecx,%edx
80107f79:	89 d1                	mov    %edx,%ecx
80107f7b:	8b 15 4c 6c 19 80    	mov    0x80196c4c,%edx
80107f81:	83 ec 04             	sub    $0x4,%esp
80107f84:	50                   	push   %eax
80107f85:	51                   	push   %ecx
80107f86:	52                   	push   %edx
80107f87:	e8 f0 cb ff ff       	call   80104b7c <memmove>
80107f8c:	83 c4 10             	add    $0x10,%esp
  memset((unsigned int *)(gpu.vvram_addr + gpu.vram_size - addr_diff),0,addr_diff);
80107f8f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107f92:	8b 0d 4c 6c 19 80    	mov    0x80196c4c,%ecx
80107f98:	8b 15 50 6c 19 80    	mov    0x80196c50,%edx
80107f9e:	01 ca                	add    %ecx,%edx
80107fa0:	8b 4d f4             	mov    -0xc(%ebp),%ecx
80107fa3:	29 ca                	sub    %ecx,%edx
80107fa5:	83 ec 04             	sub    $0x4,%esp
80107fa8:	50                   	push   %eax
80107fa9:	6a 00                	push   $0x0
80107fab:	52                   	push   %edx
80107fac:	e8 0c cb ff ff       	call   80104abd <memset>
80107fb1:	83 c4 10             	add    $0x10,%esp
}
80107fb4:	90                   	nop
80107fb5:	c9                   	leave  
80107fb6:	c3                   	ret    

80107fb7 <font_render>:
80107fb7:	55                   	push   %ebp
80107fb8:	89 e5                	mov    %esp,%ebp
80107fba:	53                   	push   %ebx
80107fbb:	83 ec 14             	sub    $0x14,%esp
80107fbe:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80107fc5:	e9 b1 00 00 00       	jmp    8010807b <font_render+0xc4>
80107fca:	c7 45 f0 0e 00 00 00 	movl   $0xe,-0x10(%ebp)
80107fd1:	e9 97 00 00 00       	jmp    8010806d <font_render+0xb6>
80107fd6:	8b 45 10             	mov    0x10(%ebp),%eax
80107fd9:	83 e8 20             	sub    $0x20,%eax
80107fdc:	6b d0 1e             	imul   $0x1e,%eax,%edx
80107fdf:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107fe2:	01 d0                	add    %edx,%eax
80107fe4:	0f b7 84 00 00 a8 10 	movzwl -0x7fef5800(%eax,%eax,1),%eax
80107feb:	80 
80107fec:	0f b7 d0             	movzwl %ax,%edx
80107fef:	8b 45 f0             	mov    -0x10(%ebp),%eax
80107ff2:	bb 01 00 00 00       	mov    $0x1,%ebx
80107ff7:	89 c1                	mov    %eax,%ecx
80107ff9:	d3 e3                	shl    %cl,%ebx
80107ffb:	89 d8                	mov    %ebx,%eax
80107ffd:	21 d0                	and    %edx,%eax
80107fff:	89 45 ec             	mov    %eax,-0x14(%ebp)
80108002:	8b 45 f0             	mov    -0x10(%ebp),%eax
80108005:	ba 01 00 00 00       	mov    $0x1,%edx
8010800a:	89 c1                	mov    %eax,%ecx
8010800c:	d3 e2                	shl    %cl,%edx
8010800e:	89 d0                	mov    %edx,%eax
80108010:	39 45 ec             	cmp    %eax,-0x14(%ebp)
80108013:	75 2b                	jne    80108040 <font_render+0x89>
80108015:	8b 55 0c             	mov    0xc(%ebp),%edx
80108018:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010801b:	01 c2                	add    %eax,%edx
8010801d:	b8 0e 00 00 00       	mov    $0xe,%eax
80108022:	2b 45 f0             	sub    -0x10(%ebp),%eax
80108025:	89 c1                	mov    %eax,%ecx
80108027:	8b 45 08             	mov    0x8(%ebp),%eax
8010802a:	01 c8                	add    %ecx,%eax
8010802c:	83 ec 04             	sub    $0x4,%esp
8010802f:	68 e0 f4 10 80       	push   $0x8010f4e0
80108034:	52                   	push   %edx
80108035:	50                   	push   %eax
80108036:	e8 be fe ff ff       	call   80107ef9 <graphic_draw_pixel>
8010803b:	83 c4 10             	add    $0x10,%esp
8010803e:	eb 29                	jmp    80108069 <font_render+0xb2>
80108040:	8b 55 0c             	mov    0xc(%ebp),%edx
80108043:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108046:	01 c2                	add    %eax,%edx
80108048:	b8 0e 00 00 00       	mov    $0xe,%eax
8010804d:	2b 45 f0             	sub    -0x10(%ebp),%eax
80108050:	89 c1                	mov    %eax,%ecx
80108052:	8b 45 08             	mov    0x8(%ebp),%eax
80108055:	01 c8                	add    %ecx,%eax
80108057:	83 ec 04             	sub    $0x4,%esp
8010805a:	68 60 6c 19 80       	push   $0x80196c60
8010805f:	52                   	push   %edx
80108060:	50                   	push   %eax
80108061:	e8 93 fe ff ff       	call   80107ef9 <graphic_draw_pixel>
80108066:	83 c4 10             	add    $0x10,%esp
80108069:	83 6d f0 01          	subl   $0x1,-0x10(%ebp)
8010806d:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80108071:	0f 89 5f ff ff ff    	jns    80107fd6 <font_render+0x1f>
80108077:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
8010807b:	83 7d f4 1d          	cmpl   $0x1d,-0xc(%ebp)
8010807f:	0f 8e 45 ff ff ff    	jle    80107fca <font_render+0x13>
80108085:	90                   	nop
80108086:	90                   	nop
80108087:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010808a:	c9                   	leave  
8010808b:	c3                   	ret    

8010808c <font_render_string>:
8010808c:	55                   	push   %ebp
8010808d:	89 e5                	mov    %esp,%ebp
8010808f:	53                   	push   %ebx
80108090:	83 ec 14             	sub    $0x14,%esp
80108093:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
8010809a:	eb 33                	jmp    801080cf <font_render_string+0x43>
8010809c:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010809f:	8b 45 08             	mov    0x8(%ebp),%eax
801080a2:	01 d0                	add    %edx,%eax
801080a4:	0f b6 00             	movzbl (%eax),%eax
801080a7:	0f be c8             	movsbl %al,%ecx
801080aa:	8b 45 0c             	mov    0xc(%ebp),%eax
801080ad:	6b d0 1e             	imul   $0x1e,%eax,%edx
801080b0:	8b 5d f4             	mov    -0xc(%ebp),%ebx
801080b3:	89 d8                	mov    %ebx,%eax
801080b5:	c1 e0 04             	shl    $0x4,%eax
801080b8:	29 d8                	sub    %ebx,%eax
801080ba:	83 c0 02             	add    $0x2,%eax
801080bd:	83 ec 04             	sub    $0x4,%esp
801080c0:	51                   	push   %ecx
801080c1:	52                   	push   %edx
801080c2:	50                   	push   %eax
801080c3:	e8 ef fe ff ff       	call   80107fb7 <font_render>
801080c8:	83 c4 10             	add    $0x10,%esp
801080cb:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
801080cf:	8b 55 f4             	mov    -0xc(%ebp),%edx
801080d2:	8b 45 08             	mov    0x8(%ebp),%eax
801080d5:	01 d0                	add    %edx,%eax
801080d7:	0f b6 00             	movzbl (%eax),%eax
801080da:	84 c0                	test   %al,%al
801080dc:	74 06                	je     801080e4 <font_render_string+0x58>
801080de:	83 7d f4 33          	cmpl   $0x33,-0xc(%ebp)
801080e2:	7e b8                	jle    8010809c <font_render_string+0x10>
801080e4:	90                   	nop
801080e5:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801080e8:	c9                   	leave  
801080e9:	c3                   	ret    

801080ea <pci_init>:
#include "pci.h"
#include "defs.h"
#include "types.h"
#include "i8254.h"

void pci_init(){
801080ea:	55                   	push   %ebp
801080eb:	89 e5                	mov    %esp,%ebp
801080ed:	53                   	push   %ebx
801080ee:	83 ec 14             	sub    $0x14,%esp
  uint data;
  for(int i=0;i<256;i++){
801080f1:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
801080f8:	eb 6b                	jmp    80108165 <pci_init+0x7b>
    for(int j=0;j<32;j++){
801080fa:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
80108101:	eb 58                	jmp    8010815b <pci_init+0x71>
      for(int k=0;k<8;k++){
80108103:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
8010810a:	eb 45                	jmp    80108151 <pci_init+0x67>
      pci_access_config(i,j,k,0,&data);
8010810c:	8b 4d ec             	mov    -0x14(%ebp),%ecx
8010810f:	8b 55 f0             	mov    -0x10(%ebp),%edx
80108112:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108115:	83 ec 0c             	sub    $0xc,%esp
80108118:	8d 5d e8             	lea    -0x18(%ebp),%ebx
8010811b:	53                   	push   %ebx
8010811c:	6a 00                	push   $0x0
8010811e:	51                   	push   %ecx
8010811f:	52                   	push   %edx
80108120:	50                   	push   %eax
80108121:	e8 b0 00 00 00       	call   801081d6 <pci_access_config>
80108126:	83 c4 20             	add    $0x20,%esp
      if((data&0xFFFF) != 0xFFFF){
80108129:	8b 45 e8             	mov    -0x18(%ebp),%eax
8010812c:	0f b7 c0             	movzwl %ax,%eax
8010812f:	3d ff ff 00 00       	cmp    $0xffff,%eax
80108134:	74 17                	je     8010814d <pci_init+0x63>
        pci_init_device(i,j,k);
80108136:	8b 4d ec             	mov    -0x14(%ebp),%ecx
80108139:	8b 55 f0             	mov    -0x10(%ebp),%edx
8010813c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010813f:	83 ec 04             	sub    $0x4,%esp
80108142:	51                   	push   %ecx
80108143:	52                   	push   %edx
80108144:	50                   	push   %eax
80108145:	e8 37 01 00 00       	call   80108281 <pci_init_device>
8010814a:	83 c4 10             	add    $0x10,%esp
      for(int k=0;k<8;k++){
8010814d:	83 45 ec 01          	addl   $0x1,-0x14(%ebp)
80108151:	83 7d ec 07          	cmpl   $0x7,-0x14(%ebp)
80108155:	7e b5                	jle    8010810c <pci_init+0x22>
    for(int j=0;j<32;j++){
80108157:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
8010815b:	83 7d f0 1f          	cmpl   $0x1f,-0x10(%ebp)
8010815f:	7e a2                	jle    80108103 <pci_init+0x19>
  for(int i=0;i<256;i++){
80108161:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80108165:	81 7d f4 ff 00 00 00 	cmpl   $0xff,-0xc(%ebp)
8010816c:	7e 8c                	jle    801080fa <pci_init+0x10>
      }
      }
    }
  }
}
8010816e:	90                   	nop
8010816f:	90                   	nop
80108170:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80108173:	c9                   	leave  
80108174:	c3                   	ret    

80108175 <pci_write_config>:

void pci_write_config(uint config){
80108175:	55                   	push   %ebp
80108176:	89 e5                	mov    %esp,%ebp
  asm("mov $0xCF8,%%edx\n\t"
80108178:	8b 45 08             	mov    0x8(%ebp),%eax
8010817b:	ba f8 0c 00 00       	mov    $0xcf8,%edx
80108180:	89 c0                	mov    %eax,%eax
80108182:	ef                   	out    %eax,(%dx)
      "mov %0,%%eax\n\t"
      "out %%eax,%%dx\n\t"
      : :"r"(config));
}
80108183:	90                   	nop
80108184:	5d                   	pop    %ebp
80108185:	c3                   	ret    

80108186 <pci_write_data>:

void pci_write_data(uint config){
80108186:	55                   	push   %ebp
80108187:	89 e5                	mov    %esp,%ebp
  asm("mov $0xCFC,%%edx\n\t"
80108189:	8b 45 08             	mov    0x8(%ebp),%eax
8010818c:	ba fc 0c 00 00       	mov    $0xcfc,%edx
80108191:	89 c0                	mov    %eax,%eax
80108193:	ef                   	out    %eax,(%dx)
      "mov %0,%%eax\n\t"
      "out %%eax,%%dx\n\t"
      : :"r"(config));
}
80108194:	90                   	nop
80108195:	5d                   	pop    %ebp
80108196:	c3                   	ret    

80108197 <pci_read_config>:
uint pci_read_config(){
80108197:	55                   	push   %ebp
80108198:	89 e5                	mov    %esp,%ebp
8010819a:	83 ec 18             	sub    $0x18,%esp
  uint data;
  asm("mov $0xCFC,%%edx\n\t"
8010819d:	ba fc 0c 00 00       	mov    $0xcfc,%edx
801081a2:	ed                   	in     (%dx),%eax
801081a3:	89 45 f4             	mov    %eax,-0xc(%ebp)
      "in %%dx,%%eax\n\t"
      "mov %%eax,%0"
      :"=m"(data):);
  microdelay(200);
801081a6:	83 ec 0c             	sub    $0xc,%esp
801081a9:	68 c8 00 00 00       	push   $0xc8
801081ae:	e8 84 a9 ff ff       	call   80102b37 <microdelay>
801081b3:	83 c4 10             	add    $0x10,%esp
  return data;
801081b6:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
801081b9:	c9                   	leave  
801081ba:	c3                   	ret    

801081bb <pci_test>:


void pci_test(){
801081bb:	55                   	push   %ebp
801081bc:	89 e5                	mov    %esp,%ebp
801081be:	83 ec 10             	sub    $0x10,%esp
  uint data = 0x80001804;
801081c1:	c7 45 fc 04 18 00 80 	movl   $0x80001804,-0x4(%ebp)
  pci_write_config(data);
801081c8:	ff 75 fc             	push   -0x4(%ebp)
801081cb:	e8 a5 ff ff ff       	call   80108175 <pci_write_config>
801081d0:	83 c4 04             	add    $0x4,%esp
}
801081d3:	90                   	nop
801081d4:	c9                   	leave  
801081d5:	c3                   	ret    

801081d6 <pci_access_config>:

void pci_access_config(uint bus_num,uint device_num,uint function_num,uint reg_addr,uint *data){
801081d6:	55                   	push   %ebp
801081d7:	89 e5                	mov    %esp,%ebp
801081d9:	83 ec 18             	sub    $0x18,%esp
  uint config_addr = ((bus_num & 0xFF)<<16) | ((device_num & 0x1F)<<11) | ((function_num & 0x7)<<8) |
801081dc:	8b 45 08             	mov    0x8(%ebp),%eax
801081df:	c1 e0 10             	shl    $0x10,%eax
801081e2:	25 00 00 ff 00       	and    $0xff0000,%eax
801081e7:	89 c2                	mov    %eax,%edx
801081e9:	8b 45 0c             	mov    0xc(%ebp),%eax
801081ec:	c1 e0 0b             	shl    $0xb,%eax
801081ef:	0f b7 c0             	movzwl %ax,%eax
801081f2:	09 c2                	or     %eax,%edx
801081f4:	8b 45 10             	mov    0x10(%ebp),%eax
801081f7:	c1 e0 08             	shl    $0x8,%eax
801081fa:	25 00 07 00 00       	and    $0x700,%eax
801081ff:	09 c2                	or     %eax,%edx
    (reg_addr & 0xFC) | 0x80000000;
80108201:	8b 45 14             	mov    0x14(%ebp),%eax
80108204:	25 fc 00 00 00       	and    $0xfc,%eax
  uint config_addr = ((bus_num & 0xFF)<<16) | ((device_num & 0x1F)<<11) | ((function_num & 0x7)<<8) |
80108209:	09 d0                	or     %edx,%eax
8010820b:	0d 00 00 00 80       	or     $0x80000000,%eax
80108210:	89 45 f4             	mov    %eax,-0xc(%ebp)
  pci_write_config(config_addr);
80108213:	ff 75 f4             	push   -0xc(%ebp)
80108216:	e8 5a ff ff ff       	call   80108175 <pci_write_config>
8010821b:	83 c4 04             	add    $0x4,%esp
  *data = pci_read_config();
8010821e:	e8 74 ff ff ff       	call   80108197 <pci_read_config>
80108223:	8b 55 18             	mov    0x18(%ebp),%edx
80108226:	89 02                	mov    %eax,(%edx)
}
80108228:	90                   	nop
80108229:	c9                   	leave  
8010822a:	c3                   	ret    

8010822b <pci_write_config_register>:

void pci_write_config_register(uint bus_num,uint device_num,uint function_num,uint reg_addr,uint data){
8010822b:	55                   	push   %ebp
8010822c:	89 e5                	mov    %esp,%ebp
8010822e:	83 ec 10             	sub    $0x10,%esp
  uint config_addr = ((bus_num & 0xFF)<<16) | ((device_num & 0x1F)<<11) | ((function_num & 0x7)<<8) |
80108231:	8b 45 08             	mov    0x8(%ebp),%eax
80108234:	c1 e0 10             	shl    $0x10,%eax
80108237:	25 00 00 ff 00       	and    $0xff0000,%eax
8010823c:	89 c2                	mov    %eax,%edx
8010823e:	8b 45 0c             	mov    0xc(%ebp),%eax
80108241:	c1 e0 0b             	shl    $0xb,%eax
80108244:	0f b7 c0             	movzwl %ax,%eax
80108247:	09 c2                	or     %eax,%edx
80108249:	8b 45 10             	mov    0x10(%ebp),%eax
8010824c:	c1 e0 08             	shl    $0x8,%eax
8010824f:	25 00 07 00 00       	and    $0x700,%eax
80108254:	09 c2                	or     %eax,%edx
    (reg_addr & 0xFC) | 0x80000000;
80108256:	8b 45 14             	mov    0x14(%ebp),%eax
80108259:	25 fc 00 00 00       	and    $0xfc,%eax
  uint config_addr = ((bus_num & 0xFF)<<16) | ((device_num & 0x1F)<<11) | ((function_num & 0x7)<<8) |
8010825e:	09 d0                	or     %edx,%eax
80108260:	0d 00 00 00 80       	or     $0x80000000,%eax
80108265:	89 45 fc             	mov    %eax,-0x4(%ebp)
  pci_write_config(config_addr);
80108268:	ff 75 fc             	push   -0x4(%ebp)
8010826b:	e8 05 ff ff ff       	call   80108175 <pci_write_config>
80108270:	83 c4 04             	add    $0x4,%esp
  pci_write_data(data);
80108273:	ff 75 18             	push   0x18(%ebp)
80108276:	e8 0b ff ff ff       	call   80108186 <pci_write_data>
8010827b:	83 c4 04             	add    $0x4,%esp
}
8010827e:	90                   	nop
8010827f:	c9                   	leave  
80108280:	c3                   	ret    

80108281 <pci_init_device>:

struct pci_dev dev;
void pci_init_device(uint bus_num,uint device_num,uint function_num){
80108281:	55                   	push   %ebp
80108282:	89 e5                	mov    %esp,%ebp
80108284:	53                   	push   %ebx
80108285:	83 ec 14             	sub    $0x14,%esp
  uint data;
  dev.bus_num = bus_num;
80108288:	8b 45 08             	mov    0x8(%ebp),%eax
8010828b:	a2 64 6c 19 80       	mov    %al,0x80196c64
  dev.device_num = device_num;
80108290:	8b 45 0c             	mov    0xc(%ebp),%eax
80108293:	a2 65 6c 19 80       	mov    %al,0x80196c65
  dev.function_num = function_num;
80108298:	8b 45 10             	mov    0x10(%ebp),%eax
8010829b:	a2 66 6c 19 80       	mov    %al,0x80196c66
  cprintf("PCI Device Found Bus:0x%x Device:0x%x Function:%x\n",bus_num,device_num,function_num);
801082a0:	ff 75 10             	push   0x10(%ebp)
801082a3:	ff 75 0c             	push   0xc(%ebp)
801082a6:	ff 75 08             	push   0x8(%ebp)
801082a9:	68 44 be 10 80       	push   $0x8010be44
801082ae:	e8 41 81 ff ff       	call   801003f4 <cprintf>
801082b3:	83 c4 10             	add    $0x10,%esp
  
  pci_access_config(bus_num,device_num,function_num,0,&data);
801082b6:	83 ec 0c             	sub    $0xc,%esp
801082b9:	8d 45 ec             	lea    -0x14(%ebp),%eax
801082bc:	50                   	push   %eax
801082bd:	6a 00                	push   $0x0
801082bf:	ff 75 10             	push   0x10(%ebp)
801082c2:	ff 75 0c             	push   0xc(%ebp)
801082c5:	ff 75 08             	push   0x8(%ebp)
801082c8:	e8 09 ff ff ff       	call   801081d6 <pci_access_config>
801082cd:	83 c4 20             	add    $0x20,%esp
  uint device_id = data>>16;
801082d0:	8b 45 ec             	mov    -0x14(%ebp),%eax
801082d3:	c1 e8 10             	shr    $0x10,%eax
801082d6:	89 45 f4             	mov    %eax,-0xc(%ebp)
  uint vendor_id = data&0xFFFF;
801082d9:	8b 45 ec             	mov    -0x14(%ebp),%eax
801082dc:	25 ff ff 00 00       	and    $0xffff,%eax
801082e1:	89 45 f0             	mov    %eax,-0x10(%ebp)
  dev.device_id = device_id;
801082e4:	8b 45 f4             	mov    -0xc(%ebp),%eax
801082e7:	a3 68 6c 19 80       	mov    %eax,0x80196c68
  dev.vendor_id = vendor_id;
801082ec:	8b 45 f0             	mov    -0x10(%ebp),%eax
801082ef:	a3 6c 6c 19 80       	mov    %eax,0x80196c6c
  cprintf("  Device ID:0x%x  Vendor ID:0x%x\n",device_id,vendor_id);
801082f4:	83 ec 04             	sub    $0x4,%esp
801082f7:	ff 75 f0             	push   -0x10(%ebp)
801082fa:	ff 75 f4             	push   -0xc(%ebp)
801082fd:	68 78 be 10 80       	push   $0x8010be78
80108302:	e8 ed 80 ff ff       	call   801003f4 <cprintf>
80108307:	83 c4 10             	add    $0x10,%esp
  
  pci_access_config(bus_num,device_num,function_num,0x8,&data);
8010830a:	83 ec 0c             	sub    $0xc,%esp
8010830d:	8d 45 ec             	lea    -0x14(%ebp),%eax
80108310:	50                   	push   %eax
80108311:	6a 08                	push   $0x8
80108313:	ff 75 10             	push   0x10(%ebp)
80108316:	ff 75 0c             	push   0xc(%ebp)
80108319:	ff 75 08             	push   0x8(%ebp)
8010831c:	e8 b5 fe ff ff       	call   801081d6 <pci_access_config>
80108321:	83 c4 20             	add    $0x20,%esp
  cprintf("  Base Class:0x%x  Sub Class:0x%x  Interface:0x%x  Revision ID:0x%x\n",
80108324:	8b 45 ec             	mov    -0x14(%ebp),%eax
80108327:	0f b6 c8             	movzbl %al,%ecx
      data>>24,(data>>16)&0xFF,(data>>8)&0xFF,data&0xFF);
8010832a:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010832d:	c1 e8 08             	shr    $0x8,%eax
  cprintf("  Base Class:0x%x  Sub Class:0x%x  Interface:0x%x  Revision ID:0x%x\n",
80108330:	0f b6 d0             	movzbl %al,%edx
      data>>24,(data>>16)&0xFF,(data>>8)&0xFF,data&0xFF);
80108333:	8b 45 ec             	mov    -0x14(%ebp),%eax
80108336:	c1 e8 10             	shr    $0x10,%eax
  cprintf("  Base Class:0x%x  Sub Class:0x%x  Interface:0x%x  Revision ID:0x%x\n",
80108339:	0f b6 c0             	movzbl %al,%eax
8010833c:	8b 5d ec             	mov    -0x14(%ebp),%ebx
8010833f:	c1 eb 18             	shr    $0x18,%ebx
80108342:	83 ec 0c             	sub    $0xc,%esp
80108345:	51                   	push   %ecx
80108346:	52                   	push   %edx
80108347:	50                   	push   %eax
80108348:	53                   	push   %ebx
80108349:	68 9c be 10 80       	push   $0x8010be9c
8010834e:	e8 a1 80 ff ff       	call   801003f4 <cprintf>
80108353:	83 c4 20             	add    $0x20,%esp
  dev.base_class = data>>24;
80108356:	8b 45 ec             	mov    -0x14(%ebp),%eax
80108359:	c1 e8 18             	shr    $0x18,%eax
8010835c:	a2 70 6c 19 80       	mov    %al,0x80196c70
  dev.sub_class = (data>>16)&0xFF;
80108361:	8b 45 ec             	mov    -0x14(%ebp),%eax
80108364:	c1 e8 10             	shr    $0x10,%eax
80108367:	a2 71 6c 19 80       	mov    %al,0x80196c71
  dev.interface = (data>>8)&0xFF;
8010836c:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010836f:	c1 e8 08             	shr    $0x8,%eax
80108372:	a2 72 6c 19 80       	mov    %al,0x80196c72
  dev.revision_id = data&0xFF;
80108377:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010837a:	a2 73 6c 19 80       	mov    %al,0x80196c73
  
  pci_access_config(bus_num,device_num,function_num,0x10,&data);
8010837f:	83 ec 0c             	sub    $0xc,%esp
80108382:	8d 45 ec             	lea    -0x14(%ebp),%eax
80108385:	50                   	push   %eax
80108386:	6a 10                	push   $0x10
80108388:	ff 75 10             	push   0x10(%ebp)
8010838b:	ff 75 0c             	push   0xc(%ebp)
8010838e:	ff 75 08             	push   0x8(%ebp)
80108391:	e8 40 fe ff ff       	call   801081d6 <pci_access_config>
80108396:	83 c4 20             	add    $0x20,%esp
  dev.bar0 = data;
80108399:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010839c:	a3 74 6c 19 80       	mov    %eax,0x80196c74
  pci_access_config(bus_num,device_num,function_num,0x14,&data);
801083a1:	83 ec 0c             	sub    $0xc,%esp
801083a4:	8d 45 ec             	lea    -0x14(%ebp),%eax
801083a7:	50                   	push   %eax
801083a8:	6a 14                	push   $0x14
801083aa:	ff 75 10             	push   0x10(%ebp)
801083ad:	ff 75 0c             	push   0xc(%ebp)
801083b0:	ff 75 08             	push   0x8(%ebp)
801083b3:	e8 1e fe ff ff       	call   801081d6 <pci_access_config>
801083b8:	83 c4 20             	add    $0x20,%esp
  dev.bar1 = data;
801083bb:	8b 45 ec             	mov    -0x14(%ebp),%eax
801083be:	a3 78 6c 19 80       	mov    %eax,0x80196c78
  if(device_id == I8254_DEVICE_ID && vendor_id == I8254_VENDOR_ID){
801083c3:	81 7d f4 0e 10 00 00 	cmpl   $0x100e,-0xc(%ebp)
801083ca:	75 5a                	jne    80108426 <pci_init_device+0x1a5>
801083cc:	81 7d f0 86 80 00 00 	cmpl   $0x8086,-0x10(%ebp)
801083d3:	75 51                	jne    80108426 <pci_init_device+0x1a5>
    cprintf("E1000 Ethernet NIC Found\n");
801083d5:	83 ec 0c             	sub    $0xc,%esp
801083d8:	68 e1 be 10 80       	push   $0x8010bee1
801083dd:	e8 12 80 ff ff       	call   801003f4 <cprintf>
801083e2:	83 c4 10             	add    $0x10,%esp
    pci_access_config(bus_num,device_num,function_num,0xF0,&data);
801083e5:	83 ec 0c             	sub    $0xc,%esp
801083e8:	8d 45 ec             	lea    -0x14(%ebp),%eax
801083eb:	50                   	push   %eax
801083ec:	68 f0 00 00 00       	push   $0xf0
801083f1:	ff 75 10             	push   0x10(%ebp)
801083f4:	ff 75 0c             	push   0xc(%ebp)
801083f7:	ff 75 08             	push   0x8(%ebp)
801083fa:	e8 d7 fd ff ff       	call   801081d6 <pci_access_config>
801083ff:	83 c4 20             	add    $0x20,%esp
    cprintf("Message Control:%x\n",data);
80108402:	8b 45 ec             	mov    -0x14(%ebp),%eax
80108405:	83 ec 08             	sub    $0x8,%esp
80108408:	50                   	push   %eax
80108409:	68 fb be 10 80       	push   $0x8010befb
8010840e:	e8 e1 7f ff ff       	call   801003f4 <cprintf>
80108413:	83 c4 10             	add    $0x10,%esp
    i8254_init(&dev);
80108416:	83 ec 0c             	sub    $0xc,%esp
80108419:	68 64 6c 19 80       	push   $0x80196c64
8010841e:	e8 09 00 00 00       	call   8010842c <i8254_init>
80108423:	83 c4 10             	add    $0x10,%esp
  }
}
80108426:	90                   	nop
80108427:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010842a:	c9                   	leave  
8010842b:	c3                   	ret    

8010842c <i8254_init>:

uint base_addr;
uchar mac_addr[6] = {0};
uchar my_ip[4] = {10,0,1,10}; 
uint *intr_addr;
void i8254_init(struct pci_dev *dev){
8010842c:	55                   	push   %ebp
8010842d:	89 e5                	mov    %esp,%ebp
8010842f:	53                   	push   %ebx
80108430:	83 ec 14             	sub    $0x14,%esp
  uint cmd_reg;
  //Enable Bus Master
  pci_access_config(dev->bus_num,dev->device_num,dev->function_num,0x04,&cmd_reg);
80108433:	8b 45 08             	mov    0x8(%ebp),%eax
80108436:	0f b6 40 02          	movzbl 0x2(%eax),%eax
8010843a:	0f b6 c8             	movzbl %al,%ecx
8010843d:	8b 45 08             	mov    0x8(%ebp),%eax
80108440:	0f b6 40 01          	movzbl 0x1(%eax),%eax
80108444:	0f b6 d0             	movzbl %al,%edx
80108447:	8b 45 08             	mov    0x8(%ebp),%eax
8010844a:	0f b6 00             	movzbl (%eax),%eax
8010844d:	0f b6 c0             	movzbl %al,%eax
80108450:	83 ec 0c             	sub    $0xc,%esp
80108453:	8d 5d ec             	lea    -0x14(%ebp),%ebx
80108456:	53                   	push   %ebx
80108457:	6a 04                	push   $0x4
80108459:	51                   	push   %ecx
8010845a:	52                   	push   %edx
8010845b:	50                   	push   %eax
8010845c:	e8 75 fd ff ff       	call   801081d6 <pci_access_config>
80108461:	83 c4 20             	add    $0x20,%esp
  cmd_reg = cmd_reg | PCI_CMD_BUS_MASTER;
80108464:	8b 45 ec             	mov    -0x14(%ebp),%eax
80108467:	83 c8 04             	or     $0x4,%eax
8010846a:	89 45 ec             	mov    %eax,-0x14(%ebp)
  pci_write_config_register(dev->bus_num,dev->device_num,dev->function_num,0x04,cmd_reg);
8010846d:	8b 5d ec             	mov    -0x14(%ebp),%ebx
80108470:	8b 45 08             	mov    0x8(%ebp),%eax
80108473:	0f b6 40 02          	movzbl 0x2(%eax),%eax
80108477:	0f b6 c8             	movzbl %al,%ecx
8010847a:	8b 45 08             	mov    0x8(%ebp),%eax
8010847d:	0f b6 40 01          	movzbl 0x1(%eax),%eax
80108481:	0f b6 d0             	movzbl %al,%edx
80108484:	8b 45 08             	mov    0x8(%ebp),%eax
80108487:	0f b6 00             	movzbl (%eax),%eax
8010848a:	0f b6 c0             	movzbl %al,%eax
8010848d:	83 ec 0c             	sub    $0xc,%esp
80108490:	53                   	push   %ebx
80108491:	6a 04                	push   $0x4
80108493:	51                   	push   %ecx
80108494:	52                   	push   %edx
80108495:	50                   	push   %eax
80108496:	e8 90 fd ff ff       	call   8010822b <pci_write_config_register>
8010849b:	83 c4 20             	add    $0x20,%esp
  
  base_addr = PCI_P2V(dev->bar0);
8010849e:	8b 45 08             	mov    0x8(%ebp),%eax
801084a1:	8b 40 10             	mov    0x10(%eax),%eax
801084a4:	05 00 00 00 40       	add    $0x40000000,%eax
801084a9:	a3 7c 6c 19 80       	mov    %eax,0x80196c7c
  uint *ctrl = (uint *)base_addr;
801084ae:	a1 7c 6c 19 80       	mov    0x80196c7c,%eax
801084b3:	89 45 f4             	mov    %eax,-0xc(%ebp)
  //Disable Interrupts
  uint *imc = (uint *)(base_addr+0xD8);
801084b6:	a1 7c 6c 19 80       	mov    0x80196c7c,%eax
801084bb:	05 d8 00 00 00       	add    $0xd8,%eax
801084c0:	89 45 f0             	mov    %eax,-0x10(%ebp)
  *imc = 0xFFFFFFFF;
801084c3:	8b 45 f0             	mov    -0x10(%ebp),%eax
801084c6:	c7 00 ff ff ff ff    	movl   $0xffffffff,(%eax)
  
  //Reset NIC
  *ctrl = *ctrl | I8254_CTRL_RST;
801084cc:	8b 45 f4             	mov    -0xc(%ebp),%eax
801084cf:	8b 00                	mov    (%eax),%eax
801084d1:	0d 00 00 00 04       	or     $0x4000000,%eax
801084d6:	89 c2                	mov    %eax,%edx
801084d8:	8b 45 f4             	mov    -0xc(%ebp),%eax
801084db:	89 10                	mov    %edx,(%eax)

  //Enable Interrupts
  *imc = 0xFFFFFFFF;
801084dd:	8b 45 f0             	mov    -0x10(%ebp),%eax
801084e0:	c7 00 ff ff ff ff    	movl   $0xffffffff,(%eax)

  //Enable Link
  *ctrl |= I8254_CTRL_SLU;
801084e6:	8b 45 f4             	mov    -0xc(%ebp),%eax
801084e9:	8b 00                	mov    (%eax),%eax
801084eb:	83 c8 40             	or     $0x40,%eax
801084ee:	89 c2                	mov    %eax,%edx
801084f0:	8b 45 f4             	mov    -0xc(%ebp),%eax
801084f3:	89 10                	mov    %edx,(%eax)
  
  //General Configuration
  *ctrl &= (~I8254_CTRL_PHY_RST | ~I8254_CTRL_VME | ~I8254_CTRL_ILOS);
801084f5:	8b 45 f4             	mov    -0xc(%ebp),%eax
801084f8:	8b 10                	mov    (%eax),%edx
801084fa:	8b 45 f4             	mov    -0xc(%ebp),%eax
801084fd:	89 10                	mov    %edx,(%eax)
  cprintf("E1000 General Configuration Done\n");
801084ff:	83 ec 0c             	sub    $0xc,%esp
80108502:	68 10 bf 10 80       	push   $0x8010bf10
80108507:	e8 e8 7e ff ff       	call   801003f4 <cprintf>
8010850c:	83 c4 10             	add    $0x10,%esp
  intr_addr = (uint *)kalloc();
8010850f:	e8 8c a2 ff ff       	call   801027a0 <kalloc>
80108514:	a3 88 6c 19 80       	mov    %eax,0x80196c88
  *intr_addr = 0;
80108519:	a1 88 6c 19 80       	mov    0x80196c88,%eax
8010851e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  cprintf("INTR_ADDR:%x\n",intr_addr);
80108524:	a1 88 6c 19 80       	mov    0x80196c88,%eax
80108529:	83 ec 08             	sub    $0x8,%esp
8010852c:	50                   	push   %eax
8010852d:	68 32 bf 10 80       	push   $0x8010bf32
80108532:	e8 bd 7e ff ff       	call   801003f4 <cprintf>
80108537:	83 c4 10             	add    $0x10,%esp
  i8254_init_recv();
8010853a:	e8 50 00 00 00       	call   8010858f <i8254_init_recv>
  i8254_init_send();
8010853f:	e8 69 03 00 00       	call   801088ad <i8254_init_send>
  cprintf("IP Address %d.%d.%d.%d\n",
      my_ip[0],
      my_ip[1],
      my_ip[2],
      my_ip[3]);
80108544:	0f b6 05 e7 f4 10 80 	movzbl 0x8010f4e7,%eax
  cprintf("IP Address %d.%d.%d.%d\n",
8010854b:	0f b6 d8             	movzbl %al,%ebx
      my_ip[2],
8010854e:	0f b6 05 e6 f4 10 80 	movzbl 0x8010f4e6,%eax
  cprintf("IP Address %d.%d.%d.%d\n",
80108555:	0f b6 c8             	movzbl %al,%ecx
      my_ip[1],
80108558:	0f b6 05 e5 f4 10 80 	movzbl 0x8010f4e5,%eax
  cprintf("IP Address %d.%d.%d.%d\n",
8010855f:	0f b6 d0             	movzbl %al,%edx
      my_ip[0],
80108562:	0f b6 05 e4 f4 10 80 	movzbl 0x8010f4e4,%eax
  cprintf("IP Address %d.%d.%d.%d\n",
80108569:	0f b6 c0             	movzbl %al,%eax
8010856c:	83 ec 0c             	sub    $0xc,%esp
8010856f:	53                   	push   %ebx
80108570:	51                   	push   %ecx
80108571:	52                   	push   %edx
80108572:	50                   	push   %eax
80108573:	68 40 bf 10 80       	push   $0x8010bf40
80108578:	e8 77 7e ff ff       	call   801003f4 <cprintf>
8010857d:	83 c4 20             	add    $0x20,%esp
  *imc = 0x0;
80108580:	8b 45 f0             	mov    -0x10(%ebp),%eax
80108583:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
}
80108589:	90                   	nop
8010858a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010858d:	c9                   	leave  
8010858e:	c3                   	ret    

8010858f <i8254_init_recv>:

void i8254_init_recv(){
8010858f:	55                   	push   %ebp
80108590:	89 e5                	mov    %esp,%ebp
80108592:	57                   	push   %edi
80108593:	56                   	push   %esi
80108594:	53                   	push   %ebx
80108595:	83 ec 6c             	sub    $0x6c,%esp
  
  uint data_l = i8254_read_eeprom(0x0);
80108598:	83 ec 0c             	sub    $0xc,%esp
8010859b:	6a 00                	push   $0x0
8010859d:	e8 e8 04 00 00       	call   80108a8a <i8254_read_eeprom>
801085a2:	83 c4 10             	add    $0x10,%esp
801085a5:	89 45 d8             	mov    %eax,-0x28(%ebp)
  mac_addr[0] = data_l&0xFF;
801085a8:	8b 45 d8             	mov    -0x28(%ebp),%eax
801085ab:	a2 80 6c 19 80       	mov    %al,0x80196c80
  mac_addr[1] = data_l>>8;
801085b0:	8b 45 d8             	mov    -0x28(%ebp),%eax
801085b3:	c1 e8 08             	shr    $0x8,%eax
801085b6:	a2 81 6c 19 80       	mov    %al,0x80196c81
  uint data_m = i8254_read_eeprom(0x1);
801085bb:	83 ec 0c             	sub    $0xc,%esp
801085be:	6a 01                	push   $0x1
801085c0:	e8 c5 04 00 00       	call   80108a8a <i8254_read_eeprom>
801085c5:	83 c4 10             	add    $0x10,%esp
801085c8:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  mac_addr[2] = data_m&0xFF;
801085cb:	8b 45 d4             	mov    -0x2c(%ebp),%eax
801085ce:	a2 82 6c 19 80       	mov    %al,0x80196c82
  mac_addr[3] = data_m>>8;
801085d3:	8b 45 d4             	mov    -0x2c(%ebp),%eax
801085d6:	c1 e8 08             	shr    $0x8,%eax
801085d9:	a2 83 6c 19 80       	mov    %al,0x80196c83
  uint data_h = i8254_read_eeprom(0x2);
801085de:	83 ec 0c             	sub    $0xc,%esp
801085e1:	6a 02                	push   $0x2
801085e3:	e8 a2 04 00 00       	call   80108a8a <i8254_read_eeprom>
801085e8:	83 c4 10             	add    $0x10,%esp
801085eb:	89 45 d0             	mov    %eax,-0x30(%ebp)
  mac_addr[4] = data_h&0xFF;
801085ee:	8b 45 d0             	mov    -0x30(%ebp),%eax
801085f1:	a2 84 6c 19 80       	mov    %al,0x80196c84
  mac_addr[5] = data_h>>8;
801085f6:	8b 45 d0             	mov    -0x30(%ebp),%eax
801085f9:	c1 e8 08             	shr    $0x8,%eax
801085fc:	a2 85 6c 19 80       	mov    %al,0x80196c85
      mac_addr[0],
      mac_addr[1],
      mac_addr[2],
      mac_addr[3],
      mac_addr[4],
      mac_addr[5]);
80108601:	0f b6 05 85 6c 19 80 	movzbl 0x80196c85,%eax
  cprintf("MAC Address %x:%x:%x:%x:%x:%x\n",
80108608:	0f b6 f8             	movzbl %al,%edi
      mac_addr[4],
8010860b:	0f b6 05 84 6c 19 80 	movzbl 0x80196c84,%eax
  cprintf("MAC Address %x:%x:%x:%x:%x:%x\n",
80108612:	0f b6 f0             	movzbl %al,%esi
      mac_addr[3],
80108615:	0f b6 05 83 6c 19 80 	movzbl 0x80196c83,%eax
  cprintf("MAC Address %x:%x:%x:%x:%x:%x\n",
8010861c:	0f b6 d8             	movzbl %al,%ebx
      mac_addr[2],
8010861f:	0f b6 05 82 6c 19 80 	movzbl 0x80196c82,%eax
  cprintf("MAC Address %x:%x:%x:%x:%x:%x\n",
80108626:	0f b6 c8             	movzbl %al,%ecx
      mac_addr[1],
80108629:	0f b6 05 81 6c 19 80 	movzbl 0x80196c81,%eax
  cprintf("MAC Address %x:%x:%x:%x:%x:%x\n",
80108630:	0f b6 d0             	movzbl %al,%edx
      mac_addr[0],
80108633:	0f b6 05 80 6c 19 80 	movzbl 0x80196c80,%eax
  cprintf("MAC Address %x:%x:%x:%x:%x:%x\n",
8010863a:	0f b6 c0             	movzbl %al,%eax
8010863d:	83 ec 04             	sub    $0x4,%esp
80108640:	57                   	push   %edi
80108641:	56                   	push   %esi
80108642:	53                   	push   %ebx
80108643:	51                   	push   %ecx
80108644:	52                   	push   %edx
80108645:	50                   	push   %eax
80108646:	68 58 bf 10 80       	push   $0x8010bf58
8010864b:	e8 a4 7d ff ff       	call   801003f4 <cprintf>
80108650:	83 c4 20             	add    $0x20,%esp

  uint *ral = (uint *)(base_addr + 0x5400);
80108653:	a1 7c 6c 19 80       	mov    0x80196c7c,%eax
80108658:	05 00 54 00 00       	add    $0x5400,%eax
8010865d:	89 45 cc             	mov    %eax,-0x34(%ebp)
  uint *rah = (uint *)(base_addr + 0x5404);
80108660:	a1 7c 6c 19 80       	mov    0x80196c7c,%eax
80108665:	05 04 54 00 00       	add    $0x5404,%eax
8010866a:	89 45 c8             	mov    %eax,-0x38(%ebp)

  *ral = (data_l | (data_m << 16));
8010866d:	8b 45 d4             	mov    -0x2c(%ebp),%eax
80108670:	c1 e0 10             	shl    $0x10,%eax
80108673:	0b 45 d8             	or     -0x28(%ebp),%eax
80108676:	89 c2                	mov    %eax,%edx
80108678:	8b 45 cc             	mov    -0x34(%ebp),%eax
8010867b:	89 10                	mov    %edx,(%eax)
  *rah = (data_h | I8254_RAH_AS_DEST | I8254_RAH_AV);
8010867d:	8b 45 d0             	mov    -0x30(%ebp),%eax
80108680:	0d 00 00 00 80       	or     $0x80000000,%eax
80108685:	89 c2                	mov    %eax,%edx
80108687:	8b 45 c8             	mov    -0x38(%ebp),%eax
8010868a:	89 10                	mov    %edx,(%eax)

  uint *mta = (uint *)(base_addr + 0x5200);
8010868c:	a1 7c 6c 19 80       	mov    0x80196c7c,%eax
80108691:	05 00 52 00 00       	add    $0x5200,%eax
80108696:	89 45 c4             	mov    %eax,-0x3c(%ebp)
  for(int i=0;i<128;i++){
80108699:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
801086a0:	eb 19                	jmp    801086bb <i8254_init_recv+0x12c>
    mta[i] = 0;
801086a2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801086a5:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
801086ac:	8b 45 c4             	mov    -0x3c(%ebp),%eax
801086af:	01 d0                	add    %edx,%eax
801086b1:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  for(int i=0;i<128;i++){
801086b7:	83 45 e4 01          	addl   $0x1,-0x1c(%ebp)
801086bb:	83 7d e4 7f          	cmpl   $0x7f,-0x1c(%ebp)
801086bf:	7e e1                	jle    801086a2 <i8254_init_recv+0x113>
  }

  uint *ims = (uint *)(base_addr + 0xD0);
801086c1:	a1 7c 6c 19 80       	mov    0x80196c7c,%eax
801086c6:	05 d0 00 00 00       	add    $0xd0,%eax
801086cb:	89 45 c0             	mov    %eax,-0x40(%ebp)
  *ims = (I8254_IMS_RXT0 | I8254_IMS_RXDMT0 | I8254_IMS_RXSEQ | I8254_IMS_LSC | I8254_IMS_RXO);
801086ce:	8b 45 c0             	mov    -0x40(%ebp),%eax
801086d1:	c7 00 dc 00 00 00    	movl   $0xdc,(%eax)
  uint *ics = (uint *)(base_addr + 0xC8);
801086d7:	a1 7c 6c 19 80       	mov    0x80196c7c,%eax
801086dc:	05 c8 00 00 00       	add    $0xc8,%eax
801086e1:	89 45 bc             	mov    %eax,-0x44(%ebp)
  *ics = (I8254_IMS_RXT0 | I8254_IMS_RXDMT0 | I8254_IMS_RXSEQ | I8254_IMS_LSC | I8254_IMS_RXO);
801086e4:	8b 45 bc             	mov    -0x44(%ebp),%eax
801086e7:	c7 00 dc 00 00 00    	movl   $0xdc,(%eax)



  uint *rxdctl = (uint *)(base_addr + 0x2828);
801086ed:	a1 7c 6c 19 80       	mov    0x80196c7c,%eax
801086f2:	05 28 28 00 00       	add    $0x2828,%eax
801086f7:	89 45 b8             	mov    %eax,-0x48(%ebp)
  *rxdctl = 0;
801086fa:	8b 45 b8             	mov    -0x48(%ebp),%eax
801086fd:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

  uint *rctl = (uint *)(base_addr + 0x100);
80108703:	a1 7c 6c 19 80       	mov    0x80196c7c,%eax
80108708:	05 00 01 00 00       	add    $0x100,%eax
8010870d:	89 45 b4             	mov    %eax,-0x4c(%ebp)
  *rctl = (I8254_RCTL_UPE | I8254_RCTL_MPE | I8254_RCTL_BAM | I8254_RCTL_BSIZE | I8254_RCTL_SECRC);
80108710:	8b 45 b4             	mov    -0x4c(%ebp),%eax
80108713:	c7 00 18 80 00 04    	movl   $0x4008018,(%eax)

  uint recv_desc_addr = (uint)kalloc();
80108719:	e8 82 a0 ff ff       	call   801027a0 <kalloc>
8010871e:	89 45 b0             	mov    %eax,-0x50(%ebp)
  uint *rdbal = (uint *)(base_addr + 0x2800);
80108721:	a1 7c 6c 19 80       	mov    0x80196c7c,%eax
80108726:	05 00 28 00 00       	add    $0x2800,%eax
8010872b:	89 45 ac             	mov    %eax,-0x54(%ebp)
  uint *rdbah = (uint *)(base_addr + 0x2804);
8010872e:	a1 7c 6c 19 80       	mov    0x80196c7c,%eax
80108733:	05 04 28 00 00       	add    $0x2804,%eax
80108738:	89 45 a8             	mov    %eax,-0x58(%ebp)
  uint *rdlen = (uint *)(base_addr + 0x2808);
8010873b:	a1 7c 6c 19 80       	mov    0x80196c7c,%eax
80108740:	05 08 28 00 00       	add    $0x2808,%eax
80108745:	89 45 a4             	mov    %eax,-0x5c(%ebp)
  uint *rdh = (uint *)(base_addr + 0x2810);
80108748:	a1 7c 6c 19 80       	mov    0x80196c7c,%eax
8010874d:	05 10 28 00 00       	add    $0x2810,%eax
80108752:	89 45 a0             	mov    %eax,-0x60(%ebp)
  uint *rdt = (uint *)(base_addr + 0x2818);
80108755:	a1 7c 6c 19 80       	mov    0x80196c7c,%eax
8010875a:	05 18 28 00 00       	add    $0x2818,%eax
8010875f:	89 45 9c             	mov    %eax,-0x64(%ebp)

  *rdbal = V2P(recv_desc_addr);
80108762:	8b 45 b0             	mov    -0x50(%ebp),%eax
80108765:	8d 90 00 00 00 80    	lea    -0x80000000(%eax),%edx
8010876b:	8b 45 ac             	mov    -0x54(%ebp),%eax
8010876e:	89 10                	mov    %edx,(%eax)
  *rdbah = 0;
80108770:	8b 45 a8             	mov    -0x58(%ebp),%eax
80108773:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  *rdlen = sizeof(struct i8254_recv_desc)*I8254_RECV_DESC_NUM;
80108779:	8b 45 a4             	mov    -0x5c(%ebp),%eax
8010877c:	c7 00 00 10 00 00    	movl   $0x1000,(%eax)
  *rdh = 0;
80108782:	8b 45 a0             	mov    -0x60(%ebp),%eax
80108785:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  *rdt = I8254_RECV_DESC_NUM;
8010878b:	8b 45 9c             	mov    -0x64(%ebp),%eax
8010878e:	c7 00 00 01 00 00    	movl   $0x100,(%eax)

  struct i8254_recv_desc *recv_desc = (struct i8254_recv_desc *)recv_desc_addr;
80108794:	8b 45 b0             	mov    -0x50(%ebp),%eax
80108797:	89 45 98             	mov    %eax,-0x68(%ebp)
  for(int i=0;i<I8254_RECV_DESC_NUM;i++){
8010879a:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
801087a1:	eb 73                	jmp    80108816 <i8254_init_recv+0x287>
    recv_desc[i].padding = 0;
801087a3:	8b 45 e0             	mov    -0x20(%ebp),%eax
801087a6:	c1 e0 04             	shl    $0x4,%eax
801087a9:	89 c2                	mov    %eax,%edx
801087ab:	8b 45 98             	mov    -0x68(%ebp),%eax
801087ae:	01 d0                	add    %edx,%eax
801087b0:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
    recv_desc[i].len = 0;
801087b7:	8b 45 e0             	mov    -0x20(%ebp),%eax
801087ba:	c1 e0 04             	shl    $0x4,%eax
801087bd:	89 c2                	mov    %eax,%edx
801087bf:	8b 45 98             	mov    -0x68(%ebp),%eax
801087c2:	01 d0                	add    %edx,%eax
801087c4:	66 c7 40 08 00 00    	movw   $0x0,0x8(%eax)
    recv_desc[i].chk_sum = 0;
801087ca:	8b 45 e0             	mov    -0x20(%ebp),%eax
801087cd:	c1 e0 04             	shl    $0x4,%eax
801087d0:	89 c2                	mov    %eax,%edx
801087d2:	8b 45 98             	mov    -0x68(%ebp),%eax
801087d5:	01 d0                	add    %edx,%eax
801087d7:	66 c7 40 0a 00 00    	movw   $0x0,0xa(%eax)
    recv_desc[i].status = 0;
801087dd:	8b 45 e0             	mov    -0x20(%ebp),%eax
801087e0:	c1 e0 04             	shl    $0x4,%eax
801087e3:	89 c2                	mov    %eax,%edx
801087e5:	8b 45 98             	mov    -0x68(%ebp),%eax
801087e8:	01 d0                	add    %edx,%eax
801087ea:	c6 40 0c 00          	movb   $0x0,0xc(%eax)
    recv_desc[i].errors = 0;
801087ee:	8b 45 e0             	mov    -0x20(%ebp),%eax
801087f1:	c1 e0 04             	shl    $0x4,%eax
801087f4:	89 c2                	mov    %eax,%edx
801087f6:	8b 45 98             	mov    -0x68(%ebp),%eax
801087f9:	01 d0                	add    %edx,%eax
801087fb:	c6 40 0d 00          	movb   $0x0,0xd(%eax)
    recv_desc[i].special = 0;
801087ff:	8b 45 e0             	mov    -0x20(%ebp),%eax
80108802:	c1 e0 04             	shl    $0x4,%eax
80108805:	89 c2                	mov    %eax,%edx
80108807:	8b 45 98             	mov    -0x68(%ebp),%eax
8010880a:	01 d0                	add    %edx,%eax
8010880c:	66 c7 40 0e 00 00    	movw   $0x0,0xe(%eax)
  for(int i=0;i<I8254_RECV_DESC_NUM;i++){
80108812:	83 45 e0 01          	addl   $0x1,-0x20(%ebp)
80108816:	81 7d e0 ff 00 00 00 	cmpl   $0xff,-0x20(%ebp)
8010881d:	7e 84                	jle    801087a3 <i8254_init_recv+0x214>
  }

  for(int i=0;i<(I8254_RECV_DESC_NUM)/2;i++){
8010881f:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
80108826:	eb 57                	jmp    8010887f <i8254_init_recv+0x2f0>
    uint buf_addr = (uint)kalloc();
80108828:	e8 73 9f ff ff       	call   801027a0 <kalloc>
8010882d:	89 45 94             	mov    %eax,-0x6c(%ebp)
    if(buf_addr == 0){
80108830:	83 7d 94 00          	cmpl   $0x0,-0x6c(%ebp)
80108834:	75 12                	jne    80108848 <i8254_init_recv+0x2b9>
      cprintf("failed to allocate buffer area\n");
80108836:	83 ec 0c             	sub    $0xc,%esp
80108839:	68 78 bf 10 80       	push   $0x8010bf78
8010883e:	e8 b1 7b ff ff       	call   801003f4 <cprintf>
80108843:	83 c4 10             	add    $0x10,%esp
      break;
80108846:	eb 3d                	jmp    80108885 <i8254_init_recv+0x2f6>
    }
    recv_desc[i].buf_addr = V2P(buf_addr);
80108848:	8b 45 dc             	mov    -0x24(%ebp),%eax
8010884b:	c1 e0 04             	shl    $0x4,%eax
8010884e:	89 c2                	mov    %eax,%edx
80108850:	8b 45 98             	mov    -0x68(%ebp),%eax
80108853:	01 d0                	add    %edx,%eax
80108855:	8b 55 94             	mov    -0x6c(%ebp),%edx
80108858:	81 c2 00 00 00 80    	add    $0x80000000,%edx
8010885e:	89 10                	mov    %edx,(%eax)
    recv_desc[i+1].buf_addr = V2P(buf_addr + 0x800);
80108860:	8b 45 dc             	mov    -0x24(%ebp),%eax
80108863:	83 c0 01             	add    $0x1,%eax
80108866:	c1 e0 04             	shl    $0x4,%eax
80108869:	89 c2                	mov    %eax,%edx
8010886b:	8b 45 98             	mov    -0x68(%ebp),%eax
8010886e:	01 d0                	add    %edx,%eax
80108870:	8b 55 94             	mov    -0x6c(%ebp),%edx
80108873:	81 ea 00 f8 ff 7f    	sub    $0x7ffff800,%edx
80108879:	89 10                	mov    %edx,(%eax)
  for(int i=0;i<(I8254_RECV_DESC_NUM)/2;i++){
8010887b:	83 45 dc 01          	addl   $0x1,-0x24(%ebp)
8010887f:	83 7d dc 7f          	cmpl   $0x7f,-0x24(%ebp)
80108883:	7e a3                	jle    80108828 <i8254_init_recv+0x299>
  }

  *rctl |= I8254_RCTL_EN;
80108885:	8b 45 b4             	mov    -0x4c(%ebp),%eax
80108888:	8b 00                	mov    (%eax),%eax
8010888a:	83 c8 02             	or     $0x2,%eax
8010888d:	89 c2                	mov    %eax,%edx
8010888f:	8b 45 b4             	mov    -0x4c(%ebp),%eax
80108892:	89 10                	mov    %edx,(%eax)
  cprintf("E1000 Recieve Initialize Done\n");
80108894:	83 ec 0c             	sub    $0xc,%esp
80108897:	68 98 bf 10 80       	push   $0x8010bf98
8010889c:	e8 53 7b ff ff       	call   801003f4 <cprintf>
801088a1:	83 c4 10             	add    $0x10,%esp
}
801088a4:	90                   	nop
801088a5:	8d 65 f4             	lea    -0xc(%ebp),%esp
801088a8:	5b                   	pop    %ebx
801088a9:	5e                   	pop    %esi
801088aa:	5f                   	pop    %edi
801088ab:	5d                   	pop    %ebp
801088ac:	c3                   	ret    

801088ad <i8254_init_send>:

void i8254_init_send(){
801088ad:	55                   	push   %ebp
801088ae:	89 e5                	mov    %esp,%ebp
801088b0:	83 ec 48             	sub    $0x48,%esp
  uint *txdctl = (uint *)(base_addr + 0x3828);
801088b3:	a1 7c 6c 19 80       	mov    0x80196c7c,%eax
801088b8:	05 28 38 00 00       	add    $0x3828,%eax
801088bd:	89 45 ec             	mov    %eax,-0x14(%ebp)
  *txdctl = (I8254_TXDCTL_WTHRESH | I8254_TXDCTL_GRAN_DESC);
801088c0:	8b 45 ec             	mov    -0x14(%ebp),%eax
801088c3:	c7 00 00 00 01 01    	movl   $0x1010000,(%eax)

  uint tx_desc_addr = (uint)kalloc();
801088c9:	e8 d2 9e ff ff       	call   801027a0 <kalloc>
801088ce:	89 45 e8             	mov    %eax,-0x18(%ebp)
  uint *tdbal = (uint *)(base_addr + 0x3800);
801088d1:	a1 7c 6c 19 80       	mov    0x80196c7c,%eax
801088d6:	05 00 38 00 00       	add    $0x3800,%eax
801088db:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  uint *tdbah = (uint *)(base_addr + 0x3804);
801088de:	a1 7c 6c 19 80       	mov    0x80196c7c,%eax
801088e3:	05 04 38 00 00       	add    $0x3804,%eax
801088e8:	89 45 e0             	mov    %eax,-0x20(%ebp)
  uint *tdlen = (uint *)(base_addr + 0x3808);
801088eb:	a1 7c 6c 19 80       	mov    0x80196c7c,%eax
801088f0:	05 08 38 00 00       	add    $0x3808,%eax
801088f5:	89 45 dc             	mov    %eax,-0x24(%ebp)

  *tdbal = V2P(tx_desc_addr);
801088f8:	8b 45 e8             	mov    -0x18(%ebp),%eax
801088fb:	8d 90 00 00 00 80    	lea    -0x80000000(%eax),%edx
80108901:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80108904:	89 10                	mov    %edx,(%eax)
  *tdbah = 0;
80108906:	8b 45 e0             	mov    -0x20(%ebp),%eax
80108909:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  *tdlen = sizeof(struct i8254_send_desc)*I8254_SEND_DESC_NUM;
8010890f:	8b 45 dc             	mov    -0x24(%ebp),%eax
80108912:	c7 00 00 10 00 00    	movl   $0x1000,(%eax)
  uint *tdh = (uint *)(base_addr + 0x3810);
80108918:	a1 7c 6c 19 80       	mov    0x80196c7c,%eax
8010891d:	05 10 38 00 00       	add    $0x3810,%eax
80108922:	89 45 d8             	mov    %eax,-0x28(%ebp)
  uint *tdt = (uint *)(base_addr + 0x3818);
80108925:	a1 7c 6c 19 80       	mov    0x80196c7c,%eax
8010892a:	05 18 38 00 00       	add    $0x3818,%eax
8010892f:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  
  *tdh = 0;
80108932:	8b 45 d8             	mov    -0x28(%ebp),%eax
80108935:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  *tdt = 0;
8010893b:	8b 45 d4             	mov    -0x2c(%ebp),%eax
8010893e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

  struct i8254_send_desc *send_desc = (struct i8254_send_desc *)tx_desc_addr;
80108944:	8b 45 e8             	mov    -0x18(%ebp),%eax
80108947:	89 45 d0             	mov    %eax,-0x30(%ebp)
  for(int i=0;i<I8254_SEND_DESC_NUM;i++){
8010894a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80108951:	e9 82 00 00 00       	jmp    801089d8 <i8254_init_send+0x12b>
    send_desc[i].padding = 0;
80108956:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108959:	c1 e0 04             	shl    $0x4,%eax
8010895c:	89 c2                	mov    %eax,%edx
8010895e:	8b 45 d0             	mov    -0x30(%ebp),%eax
80108961:	01 d0                	add    %edx,%eax
80108963:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
    send_desc[i].len = 0;
8010896a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010896d:	c1 e0 04             	shl    $0x4,%eax
80108970:	89 c2                	mov    %eax,%edx
80108972:	8b 45 d0             	mov    -0x30(%ebp),%eax
80108975:	01 d0                	add    %edx,%eax
80108977:	66 c7 40 08 00 00    	movw   $0x0,0x8(%eax)
    send_desc[i].cso = 0;
8010897d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108980:	c1 e0 04             	shl    $0x4,%eax
80108983:	89 c2                	mov    %eax,%edx
80108985:	8b 45 d0             	mov    -0x30(%ebp),%eax
80108988:	01 d0                	add    %edx,%eax
8010898a:	c6 40 0a 00          	movb   $0x0,0xa(%eax)
    send_desc[i].cmd = 0;
8010898e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108991:	c1 e0 04             	shl    $0x4,%eax
80108994:	89 c2                	mov    %eax,%edx
80108996:	8b 45 d0             	mov    -0x30(%ebp),%eax
80108999:	01 d0                	add    %edx,%eax
8010899b:	c6 40 0b 00          	movb   $0x0,0xb(%eax)
    send_desc[i].sta = 0;
8010899f:	8b 45 f4             	mov    -0xc(%ebp),%eax
801089a2:	c1 e0 04             	shl    $0x4,%eax
801089a5:	89 c2                	mov    %eax,%edx
801089a7:	8b 45 d0             	mov    -0x30(%ebp),%eax
801089aa:	01 d0                	add    %edx,%eax
801089ac:	c6 40 0c 00          	movb   $0x0,0xc(%eax)
    send_desc[i].css = 0;
801089b0:	8b 45 f4             	mov    -0xc(%ebp),%eax
801089b3:	c1 e0 04             	shl    $0x4,%eax
801089b6:	89 c2                	mov    %eax,%edx
801089b8:	8b 45 d0             	mov    -0x30(%ebp),%eax
801089bb:	01 d0                	add    %edx,%eax
801089bd:	c6 40 0d 00          	movb   $0x0,0xd(%eax)
    send_desc[i].special = 0;
801089c1:	8b 45 f4             	mov    -0xc(%ebp),%eax
801089c4:	c1 e0 04             	shl    $0x4,%eax
801089c7:	89 c2                	mov    %eax,%edx
801089c9:	8b 45 d0             	mov    -0x30(%ebp),%eax
801089cc:	01 d0                	add    %edx,%eax
801089ce:	66 c7 40 0e 00 00    	movw   $0x0,0xe(%eax)
  for(int i=0;i<I8254_SEND_DESC_NUM;i++){
801089d4:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
801089d8:	81 7d f4 ff 00 00 00 	cmpl   $0xff,-0xc(%ebp)
801089df:	0f 8e 71 ff ff ff    	jle    80108956 <i8254_init_send+0xa9>
  }

  for(int i=0;i<(I8254_SEND_DESC_NUM)/2;i++){
801089e5:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
801089ec:	eb 57                	jmp    80108a45 <i8254_init_send+0x198>
    uint buf_addr = (uint)kalloc();
801089ee:	e8 ad 9d ff ff       	call   801027a0 <kalloc>
801089f3:	89 45 cc             	mov    %eax,-0x34(%ebp)
    if(buf_addr == 0){
801089f6:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
801089fa:	75 12                	jne    80108a0e <i8254_init_send+0x161>
      cprintf("failed to allocate buffer area\n");
801089fc:	83 ec 0c             	sub    $0xc,%esp
801089ff:	68 78 bf 10 80       	push   $0x8010bf78
80108a04:	e8 eb 79 ff ff       	call   801003f4 <cprintf>
80108a09:	83 c4 10             	add    $0x10,%esp
      break;
80108a0c:	eb 3d                	jmp    80108a4b <i8254_init_send+0x19e>
    }
    send_desc[i].buf_addr = V2P(buf_addr);
80108a0e:	8b 45 f0             	mov    -0x10(%ebp),%eax
80108a11:	c1 e0 04             	shl    $0x4,%eax
80108a14:	89 c2                	mov    %eax,%edx
80108a16:	8b 45 d0             	mov    -0x30(%ebp),%eax
80108a19:	01 d0                	add    %edx,%eax
80108a1b:	8b 55 cc             	mov    -0x34(%ebp),%edx
80108a1e:	81 c2 00 00 00 80    	add    $0x80000000,%edx
80108a24:	89 10                	mov    %edx,(%eax)
    send_desc[i+1].buf_addr = V2P(buf_addr + 0x800);
80108a26:	8b 45 f0             	mov    -0x10(%ebp),%eax
80108a29:	83 c0 01             	add    $0x1,%eax
80108a2c:	c1 e0 04             	shl    $0x4,%eax
80108a2f:	89 c2                	mov    %eax,%edx
80108a31:	8b 45 d0             	mov    -0x30(%ebp),%eax
80108a34:	01 d0                	add    %edx,%eax
80108a36:	8b 55 cc             	mov    -0x34(%ebp),%edx
80108a39:	81 ea 00 f8 ff 7f    	sub    $0x7ffff800,%edx
80108a3f:	89 10                	mov    %edx,(%eax)
  for(int i=0;i<(I8254_SEND_DESC_NUM)/2;i++){
80108a41:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
80108a45:	83 7d f0 7f          	cmpl   $0x7f,-0x10(%ebp)
80108a49:	7e a3                	jle    801089ee <i8254_init_send+0x141>
  }

  uint *tctl = (uint *)(base_addr + 0x400);
80108a4b:	a1 7c 6c 19 80       	mov    0x80196c7c,%eax
80108a50:	05 00 04 00 00       	add    $0x400,%eax
80108a55:	89 45 c8             	mov    %eax,-0x38(%ebp)
  *tctl = (I8254_TCTL_EN | I8254_TCTL_PSP | I8254_TCTL_COLD | I8254_TCTL_CT);
80108a58:	8b 45 c8             	mov    -0x38(%ebp),%eax
80108a5b:	c7 00 fa 00 04 00    	movl   $0x400fa,(%eax)

  uint *tipg = (uint *)(base_addr + 0x410);
80108a61:	a1 7c 6c 19 80       	mov    0x80196c7c,%eax
80108a66:	05 10 04 00 00       	add    $0x410,%eax
80108a6b:	89 45 c4             	mov    %eax,-0x3c(%ebp)
  *tipg = (10 | (10<<10) | (10<<20));
80108a6e:	8b 45 c4             	mov    -0x3c(%ebp),%eax
80108a71:	c7 00 0a 28 a0 00    	movl   $0xa0280a,(%eax)
  cprintf("E1000 Transmit Initialize Done\n");
80108a77:	83 ec 0c             	sub    $0xc,%esp
80108a7a:	68 b8 bf 10 80       	push   $0x8010bfb8
80108a7f:	e8 70 79 ff ff       	call   801003f4 <cprintf>
80108a84:	83 c4 10             	add    $0x10,%esp

}
80108a87:	90                   	nop
80108a88:	c9                   	leave  
80108a89:	c3                   	ret    

80108a8a <i8254_read_eeprom>:
uint i8254_read_eeprom(uint addr){
80108a8a:	55                   	push   %ebp
80108a8b:	89 e5                	mov    %esp,%ebp
80108a8d:	83 ec 18             	sub    $0x18,%esp
  uint *eerd = (uint *)(base_addr + 0x14);
80108a90:	a1 7c 6c 19 80       	mov    0x80196c7c,%eax
80108a95:	83 c0 14             	add    $0x14,%eax
80108a98:	89 45 f4             	mov    %eax,-0xc(%ebp)
  *eerd = (((addr & 0xFF) << 8) | 1);
80108a9b:	8b 45 08             	mov    0x8(%ebp),%eax
80108a9e:	c1 e0 08             	shl    $0x8,%eax
80108aa1:	0f b7 c0             	movzwl %ax,%eax
80108aa4:	83 c8 01             	or     $0x1,%eax
80108aa7:	89 c2                	mov    %eax,%edx
80108aa9:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108aac:	89 10                	mov    %edx,(%eax)
  while(1){
    cprintf("");
80108aae:	83 ec 0c             	sub    $0xc,%esp
80108ab1:	68 d8 bf 10 80       	push   $0x8010bfd8
80108ab6:	e8 39 79 ff ff       	call   801003f4 <cprintf>
80108abb:	83 c4 10             	add    $0x10,%esp
    volatile uint data = *eerd;
80108abe:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108ac1:	8b 00                	mov    (%eax),%eax
80108ac3:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if((data & (1<<4)) != 0){
80108ac6:	8b 45 f0             	mov    -0x10(%ebp),%eax
80108ac9:	83 e0 10             	and    $0x10,%eax
80108acc:	85 c0                	test   %eax,%eax
80108ace:	75 02                	jne    80108ad2 <i8254_read_eeprom+0x48>
  while(1){
80108ad0:	eb dc                	jmp    80108aae <i8254_read_eeprom+0x24>
      break;
80108ad2:	90                   	nop
    }
  }

  return (*eerd >> 16) & 0xFFFF;
80108ad3:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108ad6:	8b 00                	mov    (%eax),%eax
80108ad8:	c1 e8 10             	shr    $0x10,%eax
}
80108adb:	c9                   	leave  
80108adc:	c3                   	ret    

80108add <i8254_recv>:
void i8254_recv(){
80108add:	55                   	push   %ebp
80108ade:	89 e5                	mov    %esp,%ebp
80108ae0:	83 ec 28             	sub    $0x28,%esp
  uint *rdh = (uint *)(base_addr + 0x2810);
80108ae3:	a1 7c 6c 19 80       	mov    0x80196c7c,%eax
80108ae8:	05 10 28 00 00       	add    $0x2810,%eax
80108aed:	89 45 f4             	mov    %eax,-0xc(%ebp)
  uint *rdt = (uint *)(base_addr + 0x2818);
80108af0:	a1 7c 6c 19 80       	mov    0x80196c7c,%eax
80108af5:	05 18 28 00 00       	add    $0x2818,%eax
80108afa:	89 45 f0             	mov    %eax,-0x10(%ebp)
//  uint *torl = (uint *)(base_addr + 0x40C0);
//  uint *tpr = (uint *)(base_addr + 0x40D0);
//  uint *icr = (uint *)(base_addr + 0xC0);
  uint *rdbal = (uint *)(base_addr + 0x2800);
80108afd:	a1 7c 6c 19 80       	mov    0x80196c7c,%eax
80108b02:	05 00 28 00 00       	add    $0x2800,%eax
80108b07:	89 45 ec             	mov    %eax,-0x14(%ebp)
  struct i8254_recv_desc *recv_desc = (struct i8254_recv_desc *)(P2V(*rdbal));
80108b0a:	8b 45 ec             	mov    -0x14(%ebp),%eax
80108b0d:	8b 00                	mov    (%eax),%eax
80108b0f:	05 00 00 00 80       	add    $0x80000000,%eax
80108b14:	89 45 e8             	mov    %eax,-0x18(%ebp)
  while(1){
    int rx_available = (I8254_RECV_DESC_NUM - *rdt + *rdh)%I8254_RECV_DESC_NUM;
80108b17:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108b1a:	8b 10                	mov    (%eax),%edx
80108b1c:	8b 45 f0             	mov    -0x10(%ebp),%eax
80108b1f:	8b 08                	mov    (%eax),%ecx
80108b21:	89 d0                	mov    %edx,%eax
80108b23:	29 c8                	sub    %ecx,%eax
80108b25:	25 ff 00 00 00       	and    $0xff,%eax
80108b2a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(rx_available > 0){
80108b2d:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
80108b31:	7e 37                	jle    80108b6a <i8254_recv+0x8d>
      uint buffer_addr = P2V_WO(recv_desc[*rdt].buf_addr);
80108b33:	8b 45 f0             	mov    -0x10(%ebp),%eax
80108b36:	8b 00                	mov    (%eax),%eax
80108b38:	c1 e0 04             	shl    $0x4,%eax
80108b3b:	89 c2                	mov    %eax,%edx
80108b3d:	8b 45 e8             	mov    -0x18(%ebp),%eax
80108b40:	01 d0                	add    %edx,%eax
80108b42:	8b 00                	mov    (%eax),%eax
80108b44:	05 00 00 00 80       	add    $0x80000000,%eax
80108b49:	89 45 e0             	mov    %eax,-0x20(%ebp)
      *rdt = (*rdt + 1)%I8254_RECV_DESC_NUM;
80108b4c:	8b 45 f0             	mov    -0x10(%ebp),%eax
80108b4f:	8b 00                	mov    (%eax),%eax
80108b51:	83 c0 01             	add    $0x1,%eax
80108b54:	0f b6 d0             	movzbl %al,%edx
80108b57:	8b 45 f0             	mov    -0x10(%ebp),%eax
80108b5a:	89 10                	mov    %edx,(%eax)
      eth_proc(buffer_addr);
80108b5c:	83 ec 0c             	sub    $0xc,%esp
80108b5f:	ff 75 e0             	push   -0x20(%ebp)
80108b62:	e8 15 09 00 00       	call   8010947c <eth_proc>
80108b67:	83 c4 10             	add    $0x10,%esp
    }
    if(*rdt == *rdh) {
80108b6a:	8b 45 f0             	mov    -0x10(%ebp),%eax
80108b6d:	8b 10                	mov    (%eax),%edx
80108b6f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108b72:	8b 00                	mov    (%eax),%eax
80108b74:	39 c2                	cmp    %eax,%edx
80108b76:	75 9f                	jne    80108b17 <i8254_recv+0x3a>
      (*rdt)--;
80108b78:	8b 45 f0             	mov    -0x10(%ebp),%eax
80108b7b:	8b 00                	mov    (%eax),%eax
80108b7d:	8d 50 ff             	lea    -0x1(%eax),%edx
80108b80:	8b 45 f0             	mov    -0x10(%ebp),%eax
80108b83:	89 10                	mov    %edx,(%eax)
  while(1){
80108b85:	eb 90                	jmp    80108b17 <i8254_recv+0x3a>

80108b87 <i8254_send>:
    }
  }
}

int i8254_send(const uint pkt_addr,uint len){
80108b87:	55                   	push   %ebp
80108b88:	89 e5                	mov    %esp,%ebp
80108b8a:	83 ec 28             	sub    $0x28,%esp
  uint *tdh = (uint *)(base_addr + 0x3810);
80108b8d:	a1 7c 6c 19 80       	mov    0x80196c7c,%eax
80108b92:	05 10 38 00 00       	add    $0x3810,%eax
80108b97:	89 45 f4             	mov    %eax,-0xc(%ebp)
  uint *tdt = (uint *)(base_addr + 0x3818);
80108b9a:	a1 7c 6c 19 80       	mov    0x80196c7c,%eax
80108b9f:	05 18 38 00 00       	add    $0x3818,%eax
80108ba4:	89 45 f0             	mov    %eax,-0x10(%ebp)
  uint *tdbal = (uint *)(base_addr + 0x3800);
80108ba7:	a1 7c 6c 19 80       	mov    0x80196c7c,%eax
80108bac:	05 00 38 00 00       	add    $0x3800,%eax
80108bb1:	89 45 ec             	mov    %eax,-0x14(%ebp)
  struct i8254_send_desc *txdesc = (struct i8254_send_desc *)P2V_WO(*tdbal);
80108bb4:	8b 45 ec             	mov    -0x14(%ebp),%eax
80108bb7:	8b 00                	mov    (%eax),%eax
80108bb9:	05 00 00 00 80       	add    $0x80000000,%eax
80108bbe:	89 45 e8             	mov    %eax,-0x18(%ebp)
  int tx_available = I8254_SEND_DESC_NUM - ((I8254_SEND_DESC_NUM - *tdh + *tdt) % I8254_SEND_DESC_NUM);
80108bc1:	8b 45 f0             	mov    -0x10(%ebp),%eax
80108bc4:	8b 10                	mov    (%eax),%edx
80108bc6:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108bc9:	8b 08                	mov    (%eax),%ecx
80108bcb:	89 d0                	mov    %edx,%eax
80108bcd:	29 c8                	sub    %ecx,%eax
80108bcf:	0f b6 d0             	movzbl %al,%edx
80108bd2:	b8 00 01 00 00       	mov    $0x100,%eax
80108bd7:	29 d0                	sub    %edx,%eax
80108bd9:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  uint index = *tdt%I8254_SEND_DESC_NUM;
80108bdc:	8b 45 f0             	mov    -0x10(%ebp),%eax
80108bdf:	8b 00                	mov    (%eax),%eax
80108be1:	25 ff 00 00 00       	and    $0xff,%eax
80108be6:	89 45 e0             	mov    %eax,-0x20(%ebp)
  if(tx_available > 0) {
80108be9:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
80108bed:	0f 8e a8 00 00 00    	jle    80108c9b <i8254_send+0x114>
    memmove(P2V_WO((void *)txdesc[index].buf_addr),(void *)pkt_addr,len);
80108bf3:	8b 45 08             	mov    0x8(%ebp),%eax
80108bf6:	8b 55 e0             	mov    -0x20(%ebp),%edx
80108bf9:	89 d1                	mov    %edx,%ecx
80108bfb:	c1 e1 04             	shl    $0x4,%ecx
80108bfe:	8b 55 e8             	mov    -0x18(%ebp),%edx
80108c01:	01 ca                	add    %ecx,%edx
80108c03:	8b 12                	mov    (%edx),%edx
80108c05:	81 c2 00 00 00 80    	add    $0x80000000,%edx
80108c0b:	83 ec 04             	sub    $0x4,%esp
80108c0e:	ff 75 0c             	push   0xc(%ebp)
80108c11:	50                   	push   %eax
80108c12:	52                   	push   %edx
80108c13:	e8 64 bf ff ff       	call   80104b7c <memmove>
80108c18:	83 c4 10             	add    $0x10,%esp
    txdesc[index].len = len;
80108c1b:	8b 45 e0             	mov    -0x20(%ebp),%eax
80108c1e:	c1 e0 04             	shl    $0x4,%eax
80108c21:	89 c2                	mov    %eax,%edx
80108c23:	8b 45 e8             	mov    -0x18(%ebp),%eax
80108c26:	01 d0                	add    %edx,%eax
80108c28:	8b 55 0c             	mov    0xc(%ebp),%edx
80108c2b:	66 89 50 08          	mov    %dx,0x8(%eax)
    txdesc[index].sta = 0;
80108c2f:	8b 45 e0             	mov    -0x20(%ebp),%eax
80108c32:	c1 e0 04             	shl    $0x4,%eax
80108c35:	89 c2                	mov    %eax,%edx
80108c37:	8b 45 e8             	mov    -0x18(%ebp),%eax
80108c3a:	01 d0                	add    %edx,%eax
80108c3c:	c6 40 0c 00          	movb   $0x0,0xc(%eax)
    txdesc[index].css = 0;
80108c40:	8b 45 e0             	mov    -0x20(%ebp),%eax
80108c43:	c1 e0 04             	shl    $0x4,%eax
80108c46:	89 c2                	mov    %eax,%edx
80108c48:	8b 45 e8             	mov    -0x18(%ebp),%eax
80108c4b:	01 d0                	add    %edx,%eax
80108c4d:	c6 40 0d 00          	movb   $0x0,0xd(%eax)
    txdesc[index].cmd = 0xb;
80108c51:	8b 45 e0             	mov    -0x20(%ebp),%eax
80108c54:	c1 e0 04             	shl    $0x4,%eax
80108c57:	89 c2                	mov    %eax,%edx
80108c59:	8b 45 e8             	mov    -0x18(%ebp),%eax
80108c5c:	01 d0                	add    %edx,%eax
80108c5e:	c6 40 0b 0b          	movb   $0xb,0xb(%eax)
    txdesc[index].special = 0;
80108c62:	8b 45 e0             	mov    -0x20(%ebp),%eax
80108c65:	c1 e0 04             	shl    $0x4,%eax
80108c68:	89 c2                	mov    %eax,%edx
80108c6a:	8b 45 e8             	mov    -0x18(%ebp),%eax
80108c6d:	01 d0                	add    %edx,%eax
80108c6f:	66 c7 40 0e 00 00    	movw   $0x0,0xe(%eax)
    txdesc[index].cso = 0;
80108c75:	8b 45 e0             	mov    -0x20(%ebp),%eax
80108c78:	c1 e0 04             	shl    $0x4,%eax
80108c7b:	89 c2                	mov    %eax,%edx
80108c7d:	8b 45 e8             	mov    -0x18(%ebp),%eax
80108c80:	01 d0                	add    %edx,%eax
80108c82:	c6 40 0a 00          	movb   $0x0,0xa(%eax)
    *tdt = (*tdt + 1)%I8254_SEND_DESC_NUM;
80108c86:	8b 45 f0             	mov    -0x10(%ebp),%eax
80108c89:	8b 00                	mov    (%eax),%eax
80108c8b:	83 c0 01             	add    $0x1,%eax
80108c8e:	0f b6 d0             	movzbl %al,%edx
80108c91:	8b 45 f0             	mov    -0x10(%ebp),%eax
80108c94:	89 10                	mov    %edx,(%eax)
    return len;
80108c96:	8b 45 0c             	mov    0xc(%ebp),%eax
80108c99:	eb 05                	jmp    80108ca0 <i8254_send+0x119>
  }else{
    return -1;
80108c9b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  }
  return 0;
}
80108ca0:	c9                   	leave  
80108ca1:	c3                   	ret    

80108ca2 <i8254_intr>:

void i8254_intr(){
80108ca2:	55                   	push   %ebp
80108ca3:	89 e5                	mov    %esp,%ebp
  *intr_addr = 0xEEEEEE;
80108ca5:	a1 88 6c 19 80       	mov    0x80196c88,%eax
80108caa:	c7 00 ee ee ee 00    	movl   $0xeeeeee,(%eax)
}
80108cb0:	90                   	nop
80108cb1:	5d                   	pop    %ebp
80108cb2:	c3                   	ret    

80108cb3 <arp_proc>:
extern uchar mac_addr[6];
extern uchar my_ip[4];

struct arp_entry arp_table[ARP_TABLE_MAX] = {0};

int arp_proc(uint buffer_addr){
80108cb3:	55                   	push   %ebp
80108cb4:	89 e5                	mov    %esp,%ebp
80108cb6:	83 ec 18             	sub    $0x18,%esp
  struct arp_pkt *arp_p = (struct arp_pkt *)(buffer_addr);
80108cb9:	8b 45 08             	mov    0x8(%ebp),%eax
80108cbc:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(arp_p->hrd_type != ARP_HARDWARE_TYPE) return -1;
80108cbf:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108cc2:	0f b7 00             	movzwl (%eax),%eax
80108cc5:	66 3d 00 01          	cmp    $0x100,%ax
80108cc9:	74 0a                	je     80108cd5 <arp_proc+0x22>
80108ccb:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80108cd0:	e9 4f 01 00 00       	jmp    80108e24 <arp_proc+0x171>
  if(arp_p->pro_type != ARP_PROTOCOL_TYPE) return -1;
80108cd5:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108cd8:	0f b7 40 02          	movzwl 0x2(%eax),%eax
80108cdc:	66 83 f8 08          	cmp    $0x8,%ax
80108ce0:	74 0a                	je     80108cec <arp_proc+0x39>
80108ce2:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80108ce7:	e9 38 01 00 00       	jmp    80108e24 <arp_proc+0x171>
  if(arp_p->hrd_len != 6) return -1;
80108cec:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108cef:	0f b6 40 04          	movzbl 0x4(%eax),%eax
80108cf3:	3c 06                	cmp    $0x6,%al
80108cf5:	74 0a                	je     80108d01 <arp_proc+0x4e>
80108cf7:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80108cfc:	e9 23 01 00 00       	jmp    80108e24 <arp_proc+0x171>
  if(arp_p->pro_len != 4) return -1;
80108d01:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108d04:	0f b6 40 05          	movzbl 0x5(%eax),%eax
80108d08:	3c 04                	cmp    $0x4,%al
80108d0a:	74 0a                	je     80108d16 <arp_proc+0x63>
80108d0c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80108d11:	e9 0e 01 00 00       	jmp    80108e24 <arp_proc+0x171>
  if(memcmp(my_ip,arp_p->dst_ip,4) != 0 && memcmp(my_ip,arp_p->src_ip,4) != 0) return -1;
80108d16:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108d19:	83 c0 18             	add    $0x18,%eax
80108d1c:	83 ec 04             	sub    $0x4,%esp
80108d1f:	6a 04                	push   $0x4
80108d21:	50                   	push   %eax
80108d22:	68 e4 f4 10 80       	push   $0x8010f4e4
80108d27:	e8 f8 bd ff ff       	call   80104b24 <memcmp>
80108d2c:	83 c4 10             	add    $0x10,%esp
80108d2f:	85 c0                	test   %eax,%eax
80108d31:	74 27                	je     80108d5a <arp_proc+0xa7>
80108d33:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108d36:	83 c0 0e             	add    $0xe,%eax
80108d39:	83 ec 04             	sub    $0x4,%esp
80108d3c:	6a 04                	push   $0x4
80108d3e:	50                   	push   %eax
80108d3f:	68 e4 f4 10 80       	push   $0x8010f4e4
80108d44:	e8 db bd ff ff       	call   80104b24 <memcmp>
80108d49:	83 c4 10             	add    $0x10,%esp
80108d4c:	85 c0                	test   %eax,%eax
80108d4e:	74 0a                	je     80108d5a <arp_proc+0xa7>
80108d50:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80108d55:	e9 ca 00 00 00       	jmp    80108e24 <arp_proc+0x171>
  if(arp_p->op == ARP_OPS_REQUEST && memcmp(my_ip,arp_p->dst_ip,4) == 0){
80108d5a:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108d5d:	0f b7 40 06          	movzwl 0x6(%eax),%eax
80108d61:	66 3d 00 01          	cmp    $0x100,%ax
80108d65:	75 69                	jne    80108dd0 <arp_proc+0x11d>
80108d67:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108d6a:	83 c0 18             	add    $0x18,%eax
80108d6d:	83 ec 04             	sub    $0x4,%esp
80108d70:	6a 04                	push   $0x4
80108d72:	50                   	push   %eax
80108d73:	68 e4 f4 10 80       	push   $0x8010f4e4
80108d78:	e8 a7 bd ff ff       	call   80104b24 <memcmp>
80108d7d:	83 c4 10             	add    $0x10,%esp
80108d80:	85 c0                	test   %eax,%eax
80108d82:	75 4c                	jne    80108dd0 <arp_proc+0x11d>
    uint send = (uint)kalloc();
80108d84:	e8 17 9a ff ff       	call   801027a0 <kalloc>
80108d89:	89 45 f0             	mov    %eax,-0x10(%ebp)
    uint send_size=0;
80108d8c:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
    arp_reply_pkt_create(arp_p,send,&send_size);
80108d93:	83 ec 04             	sub    $0x4,%esp
80108d96:	8d 45 ec             	lea    -0x14(%ebp),%eax
80108d99:	50                   	push   %eax
80108d9a:	ff 75 f0             	push   -0x10(%ebp)
80108d9d:	ff 75 f4             	push   -0xc(%ebp)
80108da0:	e8 1f 04 00 00       	call   801091c4 <arp_reply_pkt_create>
80108da5:	83 c4 10             	add    $0x10,%esp
    i8254_send(send,send_size);
80108da8:	8b 45 ec             	mov    -0x14(%ebp),%eax
80108dab:	83 ec 08             	sub    $0x8,%esp
80108dae:	50                   	push   %eax
80108daf:	ff 75 f0             	push   -0x10(%ebp)
80108db2:	e8 d0 fd ff ff       	call   80108b87 <i8254_send>
80108db7:	83 c4 10             	add    $0x10,%esp
    kfree((char *)send);
80108dba:	8b 45 f0             	mov    -0x10(%ebp),%eax
80108dbd:	83 ec 0c             	sub    $0xc,%esp
80108dc0:	50                   	push   %eax
80108dc1:	e8 40 99 ff ff       	call   80102706 <kfree>
80108dc6:	83 c4 10             	add    $0x10,%esp
    return ARP_CREATED_REPLY;
80108dc9:	b8 02 00 00 00       	mov    $0x2,%eax
80108dce:	eb 54                	jmp    80108e24 <arp_proc+0x171>
  }else if(arp_p->op == ARP_OPS_REPLY && memcmp(my_ip,arp_p->dst_ip,4) == 0){
80108dd0:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108dd3:	0f b7 40 06          	movzwl 0x6(%eax),%eax
80108dd7:	66 3d 00 02          	cmp    $0x200,%ax
80108ddb:	75 42                	jne    80108e1f <arp_proc+0x16c>
80108ddd:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108de0:	83 c0 18             	add    $0x18,%eax
80108de3:	83 ec 04             	sub    $0x4,%esp
80108de6:	6a 04                	push   $0x4
80108de8:	50                   	push   %eax
80108de9:	68 e4 f4 10 80       	push   $0x8010f4e4
80108dee:	e8 31 bd ff ff       	call   80104b24 <memcmp>
80108df3:	83 c4 10             	add    $0x10,%esp
80108df6:	85 c0                	test   %eax,%eax
80108df8:	75 25                	jne    80108e1f <arp_proc+0x16c>
    cprintf("ARP TABLE UPDATED\n");
80108dfa:	83 ec 0c             	sub    $0xc,%esp
80108dfd:	68 dc bf 10 80       	push   $0x8010bfdc
80108e02:	e8 ed 75 ff ff       	call   801003f4 <cprintf>
80108e07:	83 c4 10             	add    $0x10,%esp
    arp_table_update(arp_p);
80108e0a:	83 ec 0c             	sub    $0xc,%esp
80108e0d:	ff 75 f4             	push   -0xc(%ebp)
80108e10:	e8 af 01 00 00       	call   80108fc4 <arp_table_update>
80108e15:	83 c4 10             	add    $0x10,%esp
    return ARP_UPDATED_TABLE;
80108e18:	b8 01 00 00 00       	mov    $0x1,%eax
80108e1d:	eb 05                	jmp    80108e24 <arp_proc+0x171>
  }else{
    return -1;
80108e1f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  }
}
80108e24:	c9                   	leave  
80108e25:	c3                   	ret    

80108e26 <arp_scan>:

void arp_scan(){
80108e26:	55                   	push   %ebp
80108e27:	89 e5                	mov    %esp,%ebp
80108e29:	83 ec 18             	sub    $0x18,%esp
  uint send_size;
  for(int i=0;i<256;i++){
80108e2c:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80108e33:	eb 6f                	jmp    80108ea4 <arp_scan+0x7e>
    uint send = (uint)kalloc();
80108e35:	e8 66 99 ff ff       	call   801027a0 <kalloc>
80108e3a:	89 45 ec             	mov    %eax,-0x14(%ebp)
    arp_broadcast(send,&send_size,i);
80108e3d:	83 ec 04             	sub    $0x4,%esp
80108e40:	ff 75 f4             	push   -0xc(%ebp)
80108e43:	8d 45 e8             	lea    -0x18(%ebp),%eax
80108e46:	50                   	push   %eax
80108e47:	ff 75 ec             	push   -0x14(%ebp)
80108e4a:	e8 62 00 00 00       	call   80108eb1 <arp_broadcast>
80108e4f:	83 c4 10             	add    $0x10,%esp
    uint res = i8254_send(send,send_size);
80108e52:	8b 45 e8             	mov    -0x18(%ebp),%eax
80108e55:	83 ec 08             	sub    $0x8,%esp
80108e58:	50                   	push   %eax
80108e59:	ff 75 ec             	push   -0x14(%ebp)
80108e5c:	e8 26 fd ff ff       	call   80108b87 <i8254_send>
80108e61:	83 c4 10             	add    $0x10,%esp
80108e64:	89 45 f0             	mov    %eax,-0x10(%ebp)
    while(res == -1){
80108e67:	eb 22                	jmp    80108e8b <arp_scan+0x65>
      microdelay(1);
80108e69:	83 ec 0c             	sub    $0xc,%esp
80108e6c:	6a 01                	push   $0x1
80108e6e:	e8 c4 9c ff ff       	call   80102b37 <microdelay>
80108e73:	83 c4 10             	add    $0x10,%esp
      res = i8254_send(send,send_size);
80108e76:	8b 45 e8             	mov    -0x18(%ebp),%eax
80108e79:	83 ec 08             	sub    $0x8,%esp
80108e7c:	50                   	push   %eax
80108e7d:	ff 75 ec             	push   -0x14(%ebp)
80108e80:	e8 02 fd ff ff       	call   80108b87 <i8254_send>
80108e85:	83 c4 10             	add    $0x10,%esp
80108e88:	89 45 f0             	mov    %eax,-0x10(%ebp)
    while(res == -1){
80108e8b:	83 7d f0 ff          	cmpl   $0xffffffff,-0x10(%ebp)
80108e8f:	74 d8                	je     80108e69 <arp_scan+0x43>
    }
    kfree((char *)send);
80108e91:	8b 45 ec             	mov    -0x14(%ebp),%eax
80108e94:	83 ec 0c             	sub    $0xc,%esp
80108e97:	50                   	push   %eax
80108e98:	e8 69 98 ff ff       	call   80102706 <kfree>
80108e9d:	83 c4 10             	add    $0x10,%esp
  for(int i=0;i<256;i++){
80108ea0:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80108ea4:	81 7d f4 ff 00 00 00 	cmpl   $0xff,-0xc(%ebp)
80108eab:	7e 88                	jle    80108e35 <arp_scan+0xf>
  }
}
80108ead:	90                   	nop
80108eae:	90                   	nop
80108eaf:	c9                   	leave  
80108eb0:	c3                   	ret    

80108eb1 <arp_broadcast>:

void arp_broadcast(uint send,uint *send_size,uint ip){
80108eb1:	55                   	push   %ebp
80108eb2:	89 e5                	mov    %esp,%ebp
80108eb4:	83 ec 28             	sub    $0x28,%esp
  uchar dst_ip[4] = {10,0,1,ip};
80108eb7:	c6 45 ec 0a          	movb   $0xa,-0x14(%ebp)
80108ebb:	c6 45 ed 00          	movb   $0x0,-0x13(%ebp)
80108ebf:	c6 45 ee 01          	movb   $0x1,-0x12(%ebp)
80108ec3:	8b 45 10             	mov    0x10(%ebp),%eax
80108ec6:	88 45 ef             	mov    %al,-0x11(%ebp)
  uchar dst_mac_eth[6] = {0xff,0xff,0xff,0xff,0xff,0xff};
80108ec9:	c7 45 e6 ff ff ff ff 	movl   $0xffffffff,-0x1a(%ebp)
80108ed0:	66 c7 45 ea ff ff    	movw   $0xffff,-0x16(%ebp)
  uchar dst_mac_arp[6] = {0,0,0,0,0,0};
80108ed6:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
80108edd:	66 c7 45 e4 00 00    	movw   $0x0,-0x1c(%ebp)
  
  *send_size = sizeof(struct eth_pkt) + sizeof(struct arp_pkt);
80108ee3:	8b 45 0c             	mov    0xc(%ebp),%eax
80108ee6:	c7 00 2c 00 00 00    	movl   $0x2c,(%eax)

  struct eth_pkt *reply_eth = (struct eth_pkt *)send;
80108eec:	8b 45 08             	mov    0x8(%ebp),%eax
80108eef:	89 45 f4             	mov    %eax,-0xc(%ebp)
  struct arp_pkt *reply_arp = (struct arp_pkt *)(send + sizeof(struct eth_pkt));
80108ef2:	8b 45 08             	mov    0x8(%ebp),%eax
80108ef5:	83 c0 0e             	add    $0xe,%eax
80108ef8:	89 45 f0             	mov    %eax,-0x10(%ebp)
  
  reply_eth->type[0] = 0x08;
80108efb:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108efe:	c6 40 0c 08          	movb   $0x8,0xc(%eax)
  reply_eth->type[1] = 0x06;
80108f02:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108f05:	c6 40 0d 06          	movb   $0x6,0xd(%eax)
  memmove(reply_eth->dst_mac,dst_mac_eth,6);
80108f09:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108f0c:	83 ec 04             	sub    $0x4,%esp
80108f0f:	6a 06                	push   $0x6
80108f11:	8d 55 e6             	lea    -0x1a(%ebp),%edx
80108f14:	52                   	push   %edx
80108f15:	50                   	push   %eax
80108f16:	e8 61 bc ff ff       	call   80104b7c <memmove>
80108f1b:	83 c4 10             	add    $0x10,%esp
  memmove(reply_eth->src_mac,mac_addr,6);
80108f1e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108f21:	83 c0 06             	add    $0x6,%eax
80108f24:	83 ec 04             	sub    $0x4,%esp
80108f27:	6a 06                	push   $0x6
80108f29:	68 80 6c 19 80       	push   $0x80196c80
80108f2e:	50                   	push   %eax
80108f2f:	e8 48 bc ff ff       	call   80104b7c <memmove>
80108f34:	83 c4 10             	add    $0x10,%esp

  reply_arp->hrd_type = ARP_HARDWARE_TYPE;
80108f37:	8b 45 f0             	mov    -0x10(%ebp),%eax
80108f3a:	66 c7 00 00 01       	movw   $0x100,(%eax)
  reply_arp->pro_type = ARP_PROTOCOL_TYPE;
80108f3f:	8b 45 f0             	mov    -0x10(%ebp),%eax
80108f42:	66 c7 40 02 08 00    	movw   $0x8,0x2(%eax)
  reply_arp->hrd_len = 6;
80108f48:	8b 45 f0             	mov    -0x10(%ebp),%eax
80108f4b:	c6 40 04 06          	movb   $0x6,0x4(%eax)
  reply_arp->pro_len = 4;
80108f4f:	8b 45 f0             	mov    -0x10(%ebp),%eax
80108f52:	c6 40 05 04          	movb   $0x4,0x5(%eax)
  reply_arp->op = ARP_OPS_REQUEST;
80108f56:	8b 45 f0             	mov    -0x10(%ebp),%eax
80108f59:	66 c7 40 06 00 01    	movw   $0x100,0x6(%eax)
  memmove(reply_arp->dst_mac,dst_mac_arp,6);
80108f5f:	8b 45 f0             	mov    -0x10(%ebp),%eax
80108f62:	8d 50 12             	lea    0x12(%eax),%edx
80108f65:	83 ec 04             	sub    $0x4,%esp
80108f68:	6a 06                	push   $0x6
80108f6a:	8d 45 e0             	lea    -0x20(%ebp),%eax
80108f6d:	50                   	push   %eax
80108f6e:	52                   	push   %edx
80108f6f:	e8 08 bc ff ff       	call   80104b7c <memmove>
80108f74:	83 c4 10             	add    $0x10,%esp
  memmove(reply_arp->dst_ip,dst_ip,4);
80108f77:	8b 45 f0             	mov    -0x10(%ebp),%eax
80108f7a:	8d 50 18             	lea    0x18(%eax),%edx
80108f7d:	83 ec 04             	sub    $0x4,%esp
80108f80:	6a 04                	push   $0x4
80108f82:	8d 45 ec             	lea    -0x14(%ebp),%eax
80108f85:	50                   	push   %eax
80108f86:	52                   	push   %edx
80108f87:	e8 f0 bb ff ff       	call   80104b7c <memmove>
80108f8c:	83 c4 10             	add    $0x10,%esp
  memmove(reply_arp->src_mac,mac_addr,6);
80108f8f:	8b 45 f0             	mov    -0x10(%ebp),%eax
80108f92:	83 c0 08             	add    $0x8,%eax
80108f95:	83 ec 04             	sub    $0x4,%esp
80108f98:	6a 06                	push   $0x6
80108f9a:	68 80 6c 19 80       	push   $0x80196c80
80108f9f:	50                   	push   %eax
80108fa0:	e8 d7 bb ff ff       	call   80104b7c <memmove>
80108fa5:	83 c4 10             	add    $0x10,%esp
  memmove(reply_arp->src_ip,my_ip,4);
80108fa8:	8b 45 f0             	mov    -0x10(%ebp),%eax
80108fab:	83 c0 0e             	add    $0xe,%eax
80108fae:	83 ec 04             	sub    $0x4,%esp
80108fb1:	6a 04                	push   $0x4
80108fb3:	68 e4 f4 10 80       	push   $0x8010f4e4
80108fb8:	50                   	push   %eax
80108fb9:	e8 be bb ff ff       	call   80104b7c <memmove>
80108fbe:	83 c4 10             	add    $0x10,%esp
}
80108fc1:	90                   	nop
80108fc2:	c9                   	leave  
80108fc3:	c3                   	ret    

80108fc4 <arp_table_update>:

void arp_table_update(struct arp_pkt *recv_arp){
80108fc4:	55                   	push   %ebp
80108fc5:	89 e5                	mov    %esp,%ebp
80108fc7:	83 ec 18             	sub    $0x18,%esp
  int index = arp_table_search(recv_arp->src_ip);
80108fca:	8b 45 08             	mov    0x8(%ebp),%eax
80108fcd:	83 c0 0e             	add    $0xe,%eax
80108fd0:	83 ec 0c             	sub    $0xc,%esp
80108fd3:	50                   	push   %eax
80108fd4:	e8 bc 00 00 00       	call   80109095 <arp_table_search>
80108fd9:	83 c4 10             	add    $0x10,%esp
80108fdc:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(index > -1){
80108fdf:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80108fe3:	78 2d                	js     80109012 <arp_table_update+0x4e>
    memmove(arp_table[index].mac,recv_arp->src_mac,6);
80108fe5:	8b 45 08             	mov    0x8(%ebp),%eax
80108fe8:	8d 48 08             	lea    0x8(%eax),%ecx
80108feb:	8b 55 f4             	mov    -0xc(%ebp),%edx
80108fee:	89 d0                	mov    %edx,%eax
80108ff0:	c1 e0 02             	shl    $0x2,%eax
80108ff3:	01 d0                	add    %edx,%eax
80108ff5:	01 c0                	add    %eax,%eax
80108ff7:	01 d0                	add    %edx,%eax
80108ff9:	05 a0 6c 19 80       	add    $0x80196ca0,%eax
80108ffe:	83 c0 04             	add    $0x4,%eax
80109001:	83 ec 04             	sub    $0x4,%esp
80109004:	6a 06                	push   $0x6
80109006:	51                   	push   %ecx
80109007:	50                   	push   %eax
80109008:	e8 6f bb ff ff       	call   80104b7c <memmove>
8010900d:	83 c4 10             	add    $0x10,%esp
80109010:	eb 70                	jmp    80109082 <arp_table_update+0xbe>
  }else{
    index += 1;
80109012:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
    index = -index;
80109016:	f7 5d f4             	negl   -0xc(%ebp)
    memmove(arp_table[index].mac,recv_arp->src_mac,6);
80109019:	8b 45 08             	mov    0x8(%ebp),%eax
8010901c:	8d 48 08             	lea    0x8(%eax),%ecx
8010901f:	8b 55 f4             	mov    -0xc(%ebp),%edx
80109022:	89 d0                	mov    %edx,%eax
80109024:	c1 e0 02             	shl    $0x2,%eax
80109027:	01 d0                	add    %edx,%eax
80109029:	01 c0                	add    %eax,%eax
8010902b:	01 d0                	add    %edx,%eax
8010902d:	05 a0 6c 19 80       	add    $0x80196ca0,%eax
80109032:	83 c0 04             	add    $0x4,%eax
80109035:	83 ec 04             	sub    $0x4,%esp
80109038:	6a 06                	push   $0x6
8010903a:	51                   	push   %ecx
8010903b:	50                   	push   %eax
8010903c:	e8 3b bb ff ff       	call   80104b7c <memmove>
80109041:	83 c4 10             	add    $0x10,%esp
    memmove(arp_table[index].ip,recv_arp->src_ip,4);
80109044:	8b 45 08             	mov    0x8(%ebp),%eax
80109047:	8d 48 0e             	lea    0xe(%eax),%ecx
8010904a:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010904d:	89 d0                	mov    %edx,%eax
8010904f:	c1 e0 02             	shl    $0x2,%eax
80109052:	01 d0                	add    %edx,%eax
80109054:	01 c0                	add    %eax,%eax
80109056:	01 d0                	add    %edx,%eax
80109058:	05 a0 6c 19 80       	add    $0x80196ca0,%eax
8010905d:	83 ec 04             	sub    $0x4,%esp
80109060:	6a 04                	push   $0x4
80109062:	51                   	push   %ecx
80109063:	50                   	push   %eax
80109064:	e8 13 bb ff ff       	call   80104b7c <memmove>
80109069:	83 c4 10             	add    $0x10,%esp
    arp_table[index].use = 1;
8010906c:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010906f:	89 d0                	mov    %edx,%eax
80109071:	c1 e0 02             	shl    $0x2,%eax
80109074:	01 d0                	add    %edx,%eax
80109076:	01 c0                	add    %eax,%eax
80109078:	01 d0                	add    %edx,%eax
8010907a:	05 aa 6c 19 80       	add    $0x80196caa,%eax
8010907f:	c6 00 01             	movb   $0x1,(%eax)
  }
  print_arp_table(arp_table);
80109082:	83 ec 0c             	sub    $0xc,%esp
80109085:	68 a0 6c 19 80       	push   $0x80196ca0
8010908a:	e8 83 00 00 00       	call   80109112 <print_arp_table>
8010908f:	83 c4 10             	add    $0x10,%esp
}
80109092:	90                   	nop
80109093:	c9                   	leave  
80109094:	c3                   	ret    

80109095 <arp_table_search>:

int arp_table_search(uchar *ip){
80109095:	55                   	push   %ebp
80109096:	89 e5                	mov    %esp,%ebp
80109098:	83 ec 18             	sub    $0x18,%esp
  int empty=1;
8010909b:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
  for(int i=0;i<ARP_TABLE_MAX;i++){
801090a2:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
801090a9:	eb 59                	jmp    80109104 <arp_table_search+0x6f>
    if(memcmp(arp_table[i].ip,ip,4) == 0){
801090ab:	8b 55 f0             	mov    -0x10(%ebp),%edx
801090ae:	89 d0                	mov    %edx,%eax
801090b0:	c1 e0 02             	shl    $0x2,%eax
801090b3:	01 d0                	add    %edx,%eax
801090b5:	01 c0                	add    %eax,%eax
801090b7:	01 d0                	add    %edx,%eax
801090b9:	05 a0 6c 19 80       	add    $0x80196ca0,%eax
801090be:	83 ec 04             	sub    $0x4,%esp
801090c1:	6a 04                	push   $0x4
801090c3:	ff 75 08             	push   0x8(%ebp)
801090c6:	50                   	push   %eax
801090c7:	e8 58 ba ff ff       	call   80104b24 <memcmp>
801090cc:	83 c4 10             	add    $0x10,%esp
801090cf:	85 c0                	test   %eax,%eax
801090d1:	75 05                	jne    801090d8 <arp_table_search+0x43>
      return i;
801090d3:	8b 45 f0             	mov    -0x10(%ebp),%eax
801090d6:	eb 38                	jmp    80109110 <arp_table_search+0x7b>
    }
    if(arp_table[i].use == 0 && empty == 1){
801090d8:	8b 55 f0             	mov    -0x10(%ebp),%edx
801090db:	89 d0                	mov    %edx,%eax
801090dd:	c1 e0 02             	shl    $0x2,%eax
801090e0:	01 d0                	add    %edx,%eax
801090e2:	01 c0                	add    %eax,%eax
801090e4:	01 d0                	add    %edx,%eax
801090e6:	05 aa 6c 19 80       	add    $0x80196caa,%eax
801090eb:	0f b6 00             	movzbl (%eax),%eax
801090ee:	84 c0                	test   %al,%al
801090f0:	75 0e                	jne    80109100 <arp_table_search+0x6b>
801090f2:	83 7d f4 01          	cmpl   $0x1,-0xc(%ebp)
801090f6:	75 08                	jne    80109100 <arp_table_search+0x6b>
      empty = -i;
801090f8:	8b 45 f0             	mov    -0x10(%ebp),%eax
801090fb:	f7 d8                	neg    %eax
801090fd:	89 45 f4             	mov    %eax,-0xc(%ebp)
  for(int i=0;i<ARP_TABLE_MAX;i++){
80109100:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
80109104:	83 7d f0 3f          	cmpl   $0x3f,-0x10(%ebp)
80109108:	7e a1                	jle    801090ab <arp_table_search+0x16>
    }
  }
  return empty-1;
8010910a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010910d:	83 e8 01             	sub    $0x1,%eax
}
80109110:	c9                   	leave  
80109111:	c3                   	ret    

80109112 <print_arp_table>:

void print_arp_table(){
80109112:	55                   	push   %ebp
80109113:	89 e5                	mov    %esp,%ebp
80109115:	83 ec 18             	sub    $0x18,%esp
  for(int i=0;i < ARP_TABLE_MAX;i++){
80109118:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
8010911f:	e9 92 00 00 00       	jmp    801091b6 <print_arp_table+0xa4>
    if(arp_table[i].use != 0){
80109124:	8b 55 f4             	mov    -0xc(%ebp),%edx
80109127:	89 d0                	mov    %edx,%eax
80109129:	c1 e0 02             	shl    $0x2,%eax
8010912c:	01 d0                	add    %edx,%eax
8010912e:	01 c0                	add    %eax,%eax
80109130:	01 d0                	add    %edx,%eax
80109132:	05 aa 6c 19 80       	add    $0x80196caa,%eax
80109137:	0f b6 00             	movzbl (%eax),%eax
8010913a:	84 c0                	test   %al,%al
8010913c:	74 74                	je     801091b2 <print_arp_table+0xa0>
      cprintf("Entry Num: %d ",i);
8010913e:	83 ec 08             	sub    $0x8,%esp
80109141:	ff 75 f4             	push   -0xc(%ebp)
80109144:	68 ef bf 10 80       	push   $0x8010bfef
80109149:	e8 a6 72 ff ff       	call   801003f4 <cprintf>
8010914e:	83 c4 10             	add    $0x10,%esp
      print_ipv4(arp_table[i].ip);
80109151:	8b 55 f4             	mov    -0xc(%ebp),%edx
80109154:	89 d0                	mov    %edx,%eax
80109156:	c1 e0 02             	shl    $0x2,%eax
80109159:	01 d0                	add    %edx,%eax
8010915b:	01 c0                	add    %eax,%eax
8010915d:	01 d0                	add    %edx,%eax
8010915f:	05 a0 6c 19 80       	add    $0x80196ca0,%eax
80109164:	83 ec 0c             	sub    $0xc,%esp
80109167:	50                   	push   %eax
80109168:	e8 54 02 00 00       	call   801093c1 <print_ipv4>
8010916d:	83 c4 10             	add    $0x10,%esp
      cprintf(" ");
80109170:	83 ec 0c             	sub    $0xc,%esp
80109173:	68 fe bf 10 80       	push   $0x8010bffe
80109178:	e8 77 72 ff ff       	call   801003f4 <cprintf>
8010917d:	83 c4 10             	add    $0x10,%esp
      print_mac(arp_table[i].mac);
80109180:	8b 55 f4             	mov    -0xc(%ebp),%edx
80109183:	89 d0                	mov    %edx,%eax
80109185:	c1 e0 02             	shl    $0x2,%eax
80109188:	01 d0                	add    %edx,%eax
8010918a:	01 c0                	add    %eax,%eax
8010918c:	01 d0                	add    %edx,%eax
8010918e:	05 a0 6c 19 80       	add    $0x80196ca0,%eax
80109193:	83 c0 04             	add    $0x4,%eax
80109196:	83 ec 0c             	sub    $0xc,%esp
80109199:	50                   	push   %eax
8010919a:	e8 70 02 00 00       	call   8010940f <print_mac>
8010919f:	83 c4 10             	add    $0x10,%esp
      cprintf("\n");
801091a2:	83 ec 0c             	sub    $0xc,%esp
801091a5:	68 00 c0 10 80       	push   $0x8010c000
801091aa:	e8 45 72 ff ff       	call   801003f4 <cprintf>
801091af:	83 c4 10             	add    $0x10,%esp
  for(int i=0;i < ARP_TABLE_MAX;i++){
801091b2:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
801091b6:	83 7d f4 3f          	cmpl   $0x3f,-0xc(%ebp)
801091ba:	0f 8e 64 ff ff ff    	jle    80109124 <print_arp_table+0x12>
    }
  }
}
801091c0:	90                   	nop
801091c1:	90                   	nop
801091c2:	c9                   	leave  
801091c3:	c3                   	ret    

801091c4 <arp_reply_pkt_create>:


void arp_reply_pkt_create(struct arp_pkt *arp_recv,uint send,uint *send_size){
801091c4:	55                   	push   %ebp
801091c5:	89 e5                	mov    %esp,%ebp
801091c7:	83 ec 18             	sub    $0x18,%esp
  *send_size = sizeof(struct eth_pkt) + sizeof(struct arp_pkt);
801091ca:	8b 45 10             	mov    0x10(%ebp),%eax
801091cd:	c7 00 2c 00 00 00    	movl   $0x2c,(%eax)
  
  struct eth_pkt *reply_eth = (struct eth_pkt *)send;
801091d3:	8b 45 0c             	mov    0xc(%ebp),%eax
801091d6:	89 45 f4             	mov    %eax,-0xc(%ebp)
  struct arp_pkt *reply_arp = (struct arp_pkt *)(send + sizeof(struct eth_pkt));
801091d9:	8b 45 0c             	mov    0xc(%ebp),%eax
801091dc:	83 c0 0e             	add    $0xe,%eax
801091df:	89 45 f0             	mov    %eax,-0x10(%ebp)

  reply_eth->type[0] = 0x08;
801091e2:	8b 45 f4             	mov    -0xc(%ebp),%eax
801091e5:	c6 40 0c 08          	movb   $0x8,0xc(%eax)
  reply_eth->type[1] = 0x06;
801091e9:	8b 45 f4             	mov    -0xc(%ebp),%eax
801091ec:	c6 40 0d 06          	movb   $0x6,0xd(%eax)
  memmove(reply_eth->dst_mac,arp_recv->src_mac,6);
801091f0:	8b 45 08             	mov    0x8(%ebp),%eax
801091f3:	8d 50 08             	lea    0x8(%eax),%edx
801091f6:	8b 45 f4             	mov    -0xc(%ebp),%eax
801091f9:	83 ec 04             	sub    $0x4,%esp
801091fc:	6a 06                	push   $0x6
801091fe:	52                   	push   %edx
801091ff:	50                   	push   %eax
80109200:	e8 77 b9 ff ff       	call   80104b7c <memmove>
80109205:	83 c4 10             	add    $0x10,%esp
  memmove(reply_eth->src_mac,mac_addr,6);
80109208:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010920b:	83 c0 06             	add    $0x6,%eax
8010920e:	83 ec 04             	sub    $0x4,%esp
80109211:	6a 06                	push   $0x6
80109213:	68 80 6c 19 80       	push   $0x80196c80
80109218:	50                   	push   %eax
80109219:	e8 5e b9 ff ff       	call   80104b7c <memmove>
8010921e:	83 c4 10             	add    $0x10,%esp

  reply_arp->hrd_type = ARP_HARDWARE_TYPE;
80109221:	8b 45 f0             	mov    -0x10(%ebp),%eax
80109224:	66 c7 00 00 01       	movw   $0x100,(%eax)
  reply_arp->pro_type = ARP_PROTOCOL_TYPE;
80109229:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010922c:	66 c7 40 02 08 00    	movw   $0x8,0x2(%eax)
  reply_arp->hrd_len = 6;
80109232:	8b 45 f0             	mov    -0x10(%ebp),%eax
80109235:	c6 40 04 06          	movb   $0x6,0x4(%eax)
  reply_arp->pro_len = 4;
80109239:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010923c:	c6 40 05 04          	movb   $0x4,0x5(%eax)
  reply_arp->op = ARP_OPS_REPLY;
80109240:	8b 45 f0             	mov    -0x10(%ebp),%eax
80109243:	66 c7 40 06 00 02    	movw   $0x200,0x6(%eax)
  memmove(reply_arp->dst_mac,arp_recv->src_mac,6);
80109249:	8b 45 08             	mov    0x8(%ebp),%eax
8010924c:	8d 50 08             	lea    0x8(%eax),%edx
8010924f:	8b 45 f0             	mov    -0x10(%ebp),%eax
80109252:	83 c0 12             	add    $0x12,%eax
80109255:	83 ec 04             	sub    $0x4,%esp
80109258:	6a 06                	push   $0x6
8010925a:	52                   	push   %edx
8010925b:	50                   	push   %eax
8010925c:	e8 1b b9 ff ff       	call   80104b7c <memmove>
80109261:	83 c4 10             	add    $0x10,%esp
  memmove(reply_arp->dst_ip,arp_recv->src_ip,4);
80109264:	8b 45 08             	mov    0x8(%ebp),%eax
80109267:	8d 50 0e             	lea    0xe(%eax),%edx
8010926a:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010926d:	83 c0 18             	add    $0x18,%eax
80109270:	83 ec 04             	sub    $0x4,%esp
80109273:	6a 04                	push   $0x4
80109275:	52                   	push   %edx
80109276:	50                   	push   %eax
80109277:	e8 00 b9 ff ff       	call   80104b7c <memmove>
8010927c:	83 c4 10             	add    $0x10,%esp
  memmove(reply_arp->src_mac,mac_addr,6);
8010927f:	8b 45 f0             	mov    -0x10(%ebp),%eax
80109282:	83 c0 08             	add    $0x8,%eax
80109285:	83 ec 04             	sub    $0x4,%esp
80109288:	6a 06                	push   $0x6
8010928a:	68 80 6c 19 80       	push   $0x80196c80
8010928f:	50                   	push   %eax
80109290:	e8 e7 b8 ff ff       	call   80104b7c <memmove>
80109295:	83 c4 10             	add    $0x10,%esp
  memmove(reply_arp->src_ip,my_ip,4);
80109298:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010929b:	83 c0 0e             	add    $0xe,%eax
8010929e:	83 ec 04             	sub    $0x4,%esp
801092a1:	6a 04                	push   $0x4
801092a3:	68 e4 f4 10 80       	push   $0x8010f4e4
801092a8:	50                   	push   %eax
801092a9:	e8 ce b8 ff ff       	call   80104b7c <memmove>
801092ae:	83 c4 10             	add    $0x10,%esp
}
801092b1:	90                   	nop
801092b2:	c9                   	leave  
801092b3:	c3                   	ret    

801092b4 <print_arp_info>:

void print_arp_info(struct arp_pkt* arp_p){
801092b4:	55                   	push   %ebp
801092b5:	89 e5                	mov    %esp,%ebp
801092b7:	83 ec 08             	sub    $0x8,%esp
  cprintf("--------Source-------\n");
801092ba:	83 ec 0c             	sub    $0xc,%esp
801092bd:	68 02 c0 10 80       	push   $0x8010c002
801092c2:	e8 2d 71 ff ff       	call   801003f4 <cprintf>
801092c7:	83 c4 10             	add    $0x10,%esp
  print_ipv4(arp_p->src_ip);
801092ca:	8b 45 08             	mov    0x8(%ebp),%eax
801092cd:	83 c0 0e             	add    $0xe,%eax
801092d0:	83 ec 0c             	sub    $0xc,%esp
801092d3:	50                   	push   %eax
801092d4:	e8 e8 00 00 00       	call   801093c1 <print_ipv4>
801092d9:	83 c4 10             	add    $0x10,%esp
  cprintf("\n");
801092dc:	83 ec 0c             	sub    $0xc,%esp
801092df:	68 00 c0 10 80       	push   $0x8010c000
801092e4:	e8 0b 71 ff ff       	call   801003f4 <cprintf>
801092e9:	83 c4 10             	add    $0x10,%esp
  print_mac(arp_p->src_mac);
801092ec:	8b 45 08             	mov    0x8(%ebp),%eax
801092ef:	83 c0 08             	add    $0x8,%eax
801092f2:	83 ec 0c             	sub    $0xc,%esp
801092f5:	50                   	push   %eax
801092f6:	e8 14 01 00 00       	call   8010940f <print_mac>
801092fb:	83 c4 10             	add    $0x10,%esp
  cprintf("\n");
801092fe:	83 ec 0c             	sub    $0xc,%esp
80109301:	68 00 c0 10 80       	push   $0x8010c000
80109306:	e8 e9 70 ff ff       	call   801003f4 <cprintf>
8010930b:	83 c4 10             	add    $0x10,%esp
  cprintf("-----Destination-----\n");
8010930e:	83 ec 0c             	sub    $0xc,%esp
80109311:	68 19 c0 10 80       	push   $0x8010c019
80109316:	e8 d9 70 ff ff       	call   801003f4 <cprintf>
8010931b:	83 c4 10             	add    $0x10,%esp
  print_ipv4(arp_p->dst_ip);
8010931e:	8b 45 08             	mov    0x8(%ebp),%eax
80109321:	83 c0 18             	add    $0x18,%eax
80109324:	83 ec 0c             	sub    $0xc,%esp
80109327:	50                   	push   %eax
80109328:	e8 94 00 00 00       	call   801093c1 <print_ipv4>
8010932d:	83 c4 10             	add    $0x10,%esp
  cprintf("\n");
80109330:	83 ec 0c             	sub    $0xc,%esp
80109333:	68 00 c0 10 80       	push   $0x8010c000
80109338:	e8 b7 70 ff ff       	call   801003f4 <cprintf>
8010933d:	83 c4 10             	add    $0x10,%esp
  print_mac(arp_p->dst_mac);
80109340:	8b 45 08             	mov    0x8(%ebp),%eax
80109343:	83 c0 12             	add    $0x12,%eax
80109346:	83 ec 0c             	sub    $0xc,%esp
80109349:	50                   	push   %eax
8010934a:	e8 c0 00 00 00       	call   8010940f <print_mac>
8010934f:	83 c4 10             	add    $0x10,%esp
  cprintf("\n");
80109352:	83 ec 0c             	sub    $0xc,%esp
80109355:	68 00 c0 10 80       	push   $0x8010c000
8010935a:	e8 95 70 ff ff       	call   801003f4 <cprintf>
8010935f:	83 c4 10             	add    $0x10,%esp
  cprintf("Operation: ");
80109362:	83 ec 0c             	sub    $0xc,%esp
80109365:	68 30 c0 10 80       	push   $0x8010c030
8010936a:	e8 85 70 ff ff       	call   801003f4 <cprintf>
8010936f:	83 c4 10             	add    $0x10,%esp
  if(arp_p->op == ARP_OPS_REQUEST) cprintf("Request\n");
80109372:	8b 45 08             	mov    0x8(%ebp),%eax
80109375:	0f b7 40 06          	movzwl 0x6(%eax),%eax
80109379:	66 3d 00 01          	cmp    $0x100,%ax
8010937d:	75 12                	jne    80109391 <print_arp_info+0xdd>
8010937f:	83 ec 0c             	sub    $0xc,%esp
80109382:	68 3c c0 10 80       	push   $0x8010c03c
80109387:	e8 68 70 ff ff       	call   801003f4 <cprintf>
8010938c:	83 c4 10             	add    $0x10,%esp
8010938f:	eb 1d                	jmp    801093ae <print_arp_info+0xfa>
  else if(arp_p->op == ARP_OPS_REPLY) {
80109391:	8b 45 08             	mov    0x8(%ebp),%eax
80109394:	0f b7 40 06          	movzwl 0x6(%eax),%eax
80109398:	66 3d 00 02          	cmp    $0x200,%ax
8010939c:	75 10                	jne    801093ae <print_arp_info+0xfa>
    cprintf("Reply\n");
8010939e:	83 ec 0c             	sub    $0xc,%esp
801093a1:	68 45 c0 10 80       	push   $0x8010c045
801093a6:	e8 49 70 ff ff       	call   801003f4 <cprintf>
801093ab:	83 c4 10             	add    $0x10,%esp
  }
  cprintf("\n");
801093ae:	83 ec 0c             	sub    $0xc,%esp
801093b1:	68 00 c0 10 80       	push   $0x8010c000
801093b6:	e8 39 70 ff ff       	call   801003f4 <cprintf>
801093bb:	83 c4 10             	add    $0x10,%esp
}
801093be:	90                   	nop
801093bf:	c9                   	leave  
801093c0:	c3                   	ret    

801093c1 <print_ipv4>:

void print_ipv4(uchar *ip){
801093c1:	55                   	push   %ebp
801093c2:	89 e5                	mov    %esp,%ebp
801093c4:	53                   	push   %ebx
801093c5:	83 ec 04             	sub    $0x4,%esp
  cprintf("IP address: %d.%d.%d.%d",ip[0],ip[1],ip[2],ip[3]);
801093c8:	8b 45 08             	mov    0x8(%ebp),%eax
801093cb:	83 c0 03             	add    $0x3,%eax
801093ce:	0f b6 00             	movzbl (%eax),%eax
801093d1:	0f b6 d8             	movzbl %al,%ebx
801093d4:	8b 45 08             	mov    0x8(%ebp),%eax
801093d7:	83 c0 02             	add    $0x2,%eax
801093da:	0f b6 00             	movzbl (%eax),%eax
801093dd:	0f b6 c8             	movzbl %al,%ecx
801093e0:	8b 45 08             	mov    0x8(%ebp),%eax
801093e3:	83 c0 01             	add    $0x1,%eax
801093e6:	0f b6 00             	movzbl (%eax),%eax
801093e9:	0f b6 d0             	movzbl %al,%edx
801093ec:	8b 45 08             	mov    0x8(%ebp),%eax
801093ef:	0f b6 00             	movzbl (%eax),%eax
801093f2:	0f b6 c0             	movzbl %al,%eax
801093f5:	83 ec 0c             	sub    $0xc,%esp
801093f8:	53                   	push   %ebx
801093f9:	51                   	push   %ecx
801093fa:	52                   	push   %edx
801093fb:	50                   	push   %eax
801093fc:	68 4c c0 10 80       	push   $0x8010c04c
80109401:	e8 ee 6f ff ff       	call   801003f4 <cprintf>
80109406:	83 c4 20             	add    $0x20,%esp
}
80109409:	90                   	nop
8010940a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010940d:	c9                   	leave  
8010940e:	c3                   	ret    

8010940f <print_mac>:

void print_mac(uchar *mac){
8010940f:	55                   	push   %ebp
80109410:	89 e5                	mov    %esp,%ebp
80109412:	57                   	push   %edi
80109413:	56                   	push   %esi
80109414:	53                   	push   %ebx
80109415:	83 ec 0c             	sub    $0xc,%esp
  cprintf("MAC address: %x:%x:%x:%x:%x:%x",mac[0],mac[1],mac[2],mac[3],mac[4],mac[5]);
80109418:	8b 45 08             	mov    0x8(%ebp),%eax
8010941b:	83 c0 05             	add    $0x5,%eax
8010941e:	0f b6 00             	movzbl (%eax),%eax
80109421:	0f b6 f8             	movzbl %al,%edi
80109424:	8b 45 08             	mov    0x8(%ebp),%eax
80109427:	83 c0 04             	add    $0x4,%eax
8010942a:	0f b6 00             	movzbl (%eax),%eax
8010942d:	0f b6 f0             	movzbl %al,%esi
80109430:	8b 45 08             	mov    0x8(%ebp),%eax
80109433:	83 c0 03             	add    $0x3,%eax
80109436:	0f b6 00             	movzbl (%eax),%eax
80109439:	0f b6 d8             	movzbl %al,%ebx
8010943c:	8b 45 08             	mov    0x8(%ebp),%eax
8010943f:	83 c0 02             	add    $0x2,%eax
80109442:	0f b6 00             	movzbl (%eax),%eax
80109445:	0f b6 c8             	movzbl %al,%ecx
80109448:	8b 45 08             	mov    0x8(%ebp),%eax
8010944b:	83 c0 01             	add    $0x1,%eax
8010944e:	0f b6 00             	movzbl (%eax),%eax
80109451:	0f b6 d0             	movzbl %al,%edx
80109454:	8b 45 08             	mov    0x8(%ebp),%eax
80109457:	0f b6 00             	movzbl (%eax),%eax
8010945a:	0f b6 c0             	movzbl %al,%eax
8010945d:	83 ec 04             	sub    $0x4,%esp
80109460:	57                   	push   %edi
80109461:	56                   	push   %esi
80109462:	53                   	push   %ebx
80109463:	51                   	push   %ecx
80109464:	52                   	push   %edx
80109465:	50                   	push   %eax
80109466:	68 64 c0 10 80       	push   $0x8010c064
8010946b:	e8 84 6f ff ff       	call   801003f4 <cprintf>
80109470:	83 c4 20             	add    $0x20,%esp
}
80109473:	90                   	nop
80109474:	8d 65 f4             	lea    -0xc(%ebp),%esp
80109477:	5b                   	pop    %ebx
80109478:	5e                   	pop    %esi
80109479:	5f                   	pop    %edi
8010947a:	5d                   	pop    %ebp
8010947b:	c3                   	ret    

8010947c <eth_proc>:
#include "arp.h"
#include "types.h"
#include "eth.h"
#include "defs.h"
#include "ipv4.h"
void eth_proc(uint buffer_addr){
8010947c:	55                   	push   %ebp
8010947d:	89 e5                	mov    %esp,%ebp
8010947f:	83 ec 18             	sub    $0x18,%esp
  struct eth_pkt *eth_pkt = (struct eth_pkt *)buffer_addr;
80109482:	8b 45 08             	mov    0x8(%ebp),%eax
80109485:	89 45 f4             	mov    %eax,-0xc(%ebp)
  uint pkt_addr = buffer_addr+sizeof(struct eth_pkt);
80109488:	8b 45 08             	mov    0x8(%ebp),%eax
8010948b:	83 c0 0e             	add    $0xe,%eax
8010948e:	89 45 f0             	mov    %eax,-0x10(%ebp)
  if(eth_pkt->type[0] == 0x08 && eth_pkt->type[1] == 0x06){
80109491:	8b 45 f4             	mov    -0xc(%ebp),%eax
80109494:	0f b6 40 0c          	movzbl 0xc(%eax),%eax
80109498:	3c 08                	cmp    $0x8,%al
8010949a:	75 1b                	jne    801094b7 <eth_proc+0x3b>
8010949c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010949f:	0f b6 40 0d          	movzbl 0xd(%eax),%eax
801094a3:	3c 06                	cmp    $0x6,%al
801094a5:	75 10                	jne    801094b7 <eth_proc+0x3b>
    arp_proc(pkt_addr);
801094a7:	83 ec 0c             	sub    $0xc,%esp
801094aa:	ff 75 f0             	push   -0x10(%ebp)
801094ad:	e8 01 f8 ff ff       	call   80108cb3 <arp_proc>
801094b2:	83 c4 10             	add    $0x10,%esp
  }else if(eth_pkt->type[0] == 0x08 && eth_pkt->type[1] == 0x00){
    ipv4_proc(buffer_addr);
  }else{
  }
}
801094b5:	eb 24                	jmp    801094db <eth_proc+0x5f>
  }else if(eth_pkt->type[0] == 0x08 && eth_pkt->type[1] == 0x00){
801094b7:	8b 45 f4             	mov    -0xc(%ebp),%eax
801094ba:	0f b6 40 0c          	movzbl 0xc(%eax),%eax
801094be:	3c 08                	cmp    $0x8,%al
801094c0:	75 19                	jne    801094db <eth_proc+0x5f>
801094c2:	8b 45 f4             	mov    -0xc(%ebp),%eax
801094c5:	0f b6 40 0d          	movzbl 0xd(%eax),%eax
801094c9:	84 c0                	test   %al,%al
801094cb:	75 0e                	jne    801094db <eth_proc+0x5f>
    ipv4_proc(buffer_addr);
801094cd:	83 ec 0c             	sub    $0xc,%esp
801094d0:	ff 75 08             	push   0x8(%ebp)
801094d3:	e8 a3 00 00 00       	call   8010957b <ipv4_proc>
801094d8:	83 c4 10             	add    $0x10,%esp
}
801094db:	90                   	nop
801094dc:	c9                   	leave  
801094dd:	c3                   	ret    

801094de <N2H_ushort>:

ushort N2H_ushort(ushort value){
801094de:	55                   	push   %ebp
801094df:	89 e5                	mov    %esp,%ebp
801094e1:	83 ec 04             	sub    $0x4,%esp
801094e4:	8b 45 08             	mov    0x8(%ebp),%eax
801094e7:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  return (((value)&0xFF)<<8)+(value>>8);
801094eb:	0f b7 45 fc          	movzwl -0x4(%ebp),%eax
801094ef:	c1 e0 08             	shl    $0x8,%eax
801094f2:	89 c2                	mov    %eax,%edx
801094f4:	0f b7 45 fc          	movzwl -0x4(%ebp),%eax
801094f8:	66 c1 e8 08          	shr    $0x8,%ax
801094fc:	01 d0                	add    %edx,%eax
}
801094fe:	c9                   	leave  
801094ff:	c3                   	ret    

80109500 <H2N_ushort>:

ushort H2N_ushort(ushort value){
80109500:	55                   	push   %ebp
80109501:	89 e5                	mov    %esp,%ebp
80109503:	83 ec 04             	sub    $0x4,%esp
80109506:	8b 45 08             	mov    0x8(%ebp),%eax
80109509:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  return (((value)&0xFF)<<8)+(value>>8);
8010950d:	0f b7 45 fc          	movzwl -0x4(%ebp),%eax
80109511:	c1 e0 08             	shl    $0x8,%eax
80109514:	89 c2                	mov    %eax,%edx
80109516:	0f b7 45 fc          	movzwl -0x4(%ebp),%eax
8010951a:	66 c1 e8 08          	shr    $0x8,%ax
8010951e:	01 d0                	add    %edx,%eax
}
80109520:	c9                   	leave  
80109521:	c3                   	ret    

80109522 <H2N_uint>:

uint H2N_uint(uint value){
80109522:	55                   	push   %ebp
80109523:	89 e5                	mov    %esp,%ebp
  return ((value&0xF)<<24)+((value&0xF0)<<8)+((value&0xF00)>>8)+((value&0xF000)>>24);
80109525:	8b 45 08             	mov    0x8(%ebp),%eax
80109528:	c1 e0 18             	shl    $0x18,%eax
8010952b:	25 00 00 00 0f       	and    $0xf000000,%eax
80109530:	89 c2                	mov    %eax,%edx
80109532:	8b 45 08             	mov    0x8(%ebp),%eax
80109535:	c1 e0 08             	shl    $0x8,%eax
80109538:	25 00 f0 00 00       	and    $0xf000,%eax
8010953d:	09 c2                	or     %eax,%edx
8010953f:	8b 45 08             	mov    0x8(%ebp),%eax
80109542:	c1 e8 08             	shr    $0x8,%eax
80109545:	83 e0 0f             	and    $0xf,%eax
80109548:	01 d0                	add    %edx,%eax
}
8010954a:	5d                   	pop    %ebp
8010954b:	c3                   	ret    

8010954c <N2H_uint>:

uint N2H_uint(uint value){
8010954c:	55                   	push   %ebp
8010954d:	89 e5                	mov    %esp,%ebp
  return ((value&0xFF)<<24)+((value&0xFF00)<<8)+((value&0xFF0000)>>8)+((value&0xFF000000)>>24);
8010954f:	8b 45 08             	mov    0x8(%ebp),%eax
80109552:	c1 e0 18             	shl    $0x18,%eax
80109555:	89 c2                	mov    %eax,%edx
80109557:	8b 45 08             	mov    0x8(%ebp),%eax
8010955a:	c1 e0 08             	shl    $0x8,%eax
8010955d:	25 00 00 ff 00       	and    $0xff0000,%eax
80109562:	01 c2                	add    %eax,%edx
80109564:	8b 45 08             	mov    0x8(%ebp),%eax
80109567:	c1 e8 08             	shr    $0x8,%eax
8010956a:	25 00 ff 00 00       	and    $0xff00,%eax
8010956f:	01 c2                	add    %eax,%edx
80109571:	8b 45 08             	mov    0x8(%ebp),%eax
80109574:	c1 e8 18             	shr    $0x18,%eax
80109577:	01 d0                	add    %edx,%eax
}
80109579:	5d                   	pop    %ebp
8010957a:	c3                   	ret    

8010957b <ipv4_proc>:
extern uchar mac_addr[6];
extern uchar my_ip[4];

int ip_id = -1;
ushort send_id = 0;
void ipv4_proc(uint buffer_addr){
8010957b:	55                   	push   %ebp
8010957c:	89 e5                	mov    %esp,%ebp
8010957e:	83 ec 18             	sub    $0x18,%esp
  struct ipv4_pkt *ipv4_p = (struct ipv4_pkt *)(buffer_addr+14);
80109581:	8b 45 08             	mov    0x8(%ebp),%eax
80109584:	83 c0 0e             	add    $0xe,%eax
80109587:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(ip_id != ipv4_p->id && memcmp(my_ip,ipv4_p->src_ip,4) != 0){
8010958a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010958d:	0f b7 40 04          	movzwl 0x4(%eax),%eax
80109591:	0f b7 d0             	movzwl %ax,%edx
80109594:	a1 e8 f4 10 80       	mov    0x8010f4e8,%eax
80109599:	39 c2                	cmp    %eax,%edx
8010959b:	74 60                	je     801095fd <ipv4_proc+0x82>
8010959d:	8b 45 f4             	mov    -0xc(%ebp),%eax
801095a0:	83 c0 0c             	add    $0xc,%eax
801095a3:	83 ec 04             	sub    $0x4,%esp
801095a6:	6a 04                	push   $0x4
801095a8:	50                   	push   %eax
801095a9:	68 e4 f4 10 80       	push   $0x8010f4e4
801095ae:	e8 71 b5 ff ff       	call   80104b24 <memcmp>
801095b3:	83 c4 10             	add    $0x10,%esp
801095b6:	85 c0                	test   %eax,%eax
801095b8:	74 43                	je     801095fd <ipv4_proc+0x82>
    ip_id = ipv4_p->id;
801095ba:	8b 45 f4             	mov    -0xc(%ebp),%eax
801095bd:	0f b7 40 04          	movzwl 0x4(%eax),%eax
801095c1:	0f b7 c0             	movzwl %ax,%eax
801095c4:	a3 e8 f4 10 80       	mov    %eax,0x8010f4e8
      if(ipv4_p->protocol == IPV4_TYPE_ICMP){
801095c9:	8b 45 f4             	mov    -0xc(%ebp),%eax
801095cc:	0f b6 40 09          	movzbl 0x9(%eax),%eax
801095d0:	3c 01                	cmp    $0x1,%al
801095d2:	75 10                	jne    801095e4 <ipv4_proc+0x69>
        icmp_proc(buffer_addr);
801095d4:	83 ec 0c             	sub    $0xc,%esp
801095d7:	ff 75 08             	push   0x8(%ebp)
801095da:	e8 a3 00 00 00       	call   80109682 <icmp_proc>
801095df:	83 c4 10             	add    $0x10,%esp
      }else if(ipv4_p->protocol == IPV4_TYPE_TCP){
        tcp_proc(buffer_addr);
      }
  }
}
801095e2:	eb 19                	jmp    801095fd <ipv4_proc+0x82>
      }else if(ipv4_p->protocol == IPV4_TYPE_TCP){
801095e4:	8b 45 f4             	mov    -0xc(%ebp),%eax
801095e7:	0f b6 40 09          	movzbl 0x9(%eax),%eax
801095eb:	3c 06                	cmp    $0x6,%al
801095ed:	75 0e                	jne    801095fd <ipv4_proc+0x82>
        tcp_proc(buffer_addr);
801095ef:	83 ec 0c             	sub    $0xc,%esp
801095f2:	ff 75 08             	push   0x8(%ebp)
801095f5:	e8 b3 03 00 00       	call   801099ad <tcp_proc>
801095fa:	83 c4 10             	add    $0x10,%esp
}
801095fd:	90                   	nop
801095fe:	c9                   	leave  
801095ff:	c3                   	ret    

80109600 <ipv4_chksum>:

ushort ipv4_chksum(uint ipv4_addr){
80109600:	55                   	push   %ebp
80109601:	89 e5                	mov    %esp,%ebp
80109603:	83 ec 10             	sub    $0x10,%esp
  uchar* bin = (uchar *)ipv4_addr;
80109606:	8b 45 08             	mov    0x8(%ebp),%eax
80109609:	89 45 f4             	mov    %eax,-0xc(%ebp)
  uchar len = (bin[0]&0xF)*2;
8010960c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010960f:	0f b6 00             	movzbl (%eax),%eax
80109612:	83 e0 0f             	and    $0xf,%eax
80109615:	01 c0                	add    %eax,%eax
80109617:	88 45 f3             	mov    %al,-0xd(%ebp)
  uint chk_sum = 0;
8010961a:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  for(int i=0;i<len;i++){
80109621:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
80109628:	eb 48                	jmp    80109672 <ipv4_chksum+0x72>
    chk_sum += (bin[i*2]<<8)+bin[i*2+1];
8010962a:	8b 45 f8             	mov    -0x8(%ebp),%eax
8010962d:	01 c0                	add    %eax,%eax
8010962f:	89 c2                	mov    %eax,%edx
80109631:	8b 45 f4             	mov    -0xc(%ebp),%eax
80109634:	01 d0                	add    %edx,%eax
80109636:	0f b6 00             	movzbl (%eax),%eax
80109639:	0f b6 c0             	movzbl %al,%eax
8010963c:	c1 e0 08             	shl    $0x8,%eax
8010963f:	89 c2                	mov    %eax,%edx
80109641:	8b 45 f8             	mov    -0x8(%ebp),%eax
80109644:	01 c0                	add    %eax,%eax
80109646:	8d 48 01             	lea    0x1(%eax),%ecx
80109649:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010964c:	01 c8                	add    %ecx,%eax
8010964e:	0f b6 00             	movzbl (%eax),%eax
80109651:	0f b6 c0             	movzbl %al,%eax
80109654:	01 d0                	add    %edx,%eax
80109656:	01 45 fc             	add    %eax,-0x4(%ebp)
    if(chk_sum > 0xFFFF){
80109659:	81 7d fc ff ff 00 00 	cmpl   $0xffff,-0x4(%ebp)
80109660:	76 0c                	jbe    8010966e <ipv4_chksum+0x6e>
      chk_sum = (chk_sum&0xFFFF)+1;
80109662:	8b 45 fc             	mov    -0x4(%ebp),%eax
80109665:	0f b7 c0             	movzwl %ax,%eax
80109668:	83 c0 01             	add    $0x1,%eax
8010966b:	89 45 fc             	mov    %eax,-0x4(%ebp)
  for(int i=0;i<len;i++){
8010966e:	83 45 f8 01          	addl   $0x1,-0x8(%ebp)
80109672:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
80109676:	39 45 f8             	cmp    %eax,-0x8(%ebp)
80109679:	7c af                	jl     8010962a <ipv4_chksum+0x2a>
    }
  }
  return ~(chk_sum);
8010967b:	8b 45 fc             	mov    -0x4(%ebp),%eax
8010967e:	f7 d0                	not    %eax
}
80109680:	c9                   	leave  
80109681:	c3                   	ret    

80109682 <icmp_proc>:
#include "eth.h"

extern uchar mac_addr[6];
extern uchar my_ip[4];
extern ushort send_id;
void icmp_proc(uint buffer_addr){
80109682:	55                   	push   %ebp
80109683:	89 e5                	mov    %esp,%ebp
80109685:	83 ec 18             	sub    $0x18,%esp
  struct ipv4_pkt *ipv4_p = (struct ipv4_pkt *)(buffer_addr+sizeof(struct eth_pkt));
80109688:	8b 45 08             	mov    0x8(%ebp),%eax
8010968b:	83 c0 0e             	add    $0xe,%eax
8010968e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  struct icmp_echo_pkt *icmp_p = (struct icmp_echo_pkt *)((uint)ipv4_p + (ipv4_p->ver&0xF)*4);
80109691:	8b 45 f4             	mov    -0xc(%ebp),%eax
80109694:	0f b6 00             	movzbl (%eax),%eax
80109697:	0f b6 c0             	movzbl %al,%eax
8010969a:	83 e0 0f             	and    $0xf,%eax
8010969d:	c1 e0 02             	shl    $0x2,%eax
801096a0:	89 c2                	mov    %eax,%edx
801096a2:	8b 45 f4             	mov    -0xc(%ebp),%eax
801096a5:	01 d0                	add    %edx,%eax
801096a7:	89 45 f0             	mov    %eax,-0x10(%ebp)
  if(icmp_p->code == 0){
801096aa:	8b 45 f0             	mov    -0x10(%ebp),%eax
801096ad:	0f b6 40 01          	movzbl 0x1(%eax),%eax
801096b1:	84 c0                	test   %al,%al
801096b3:	75 4f                	jne    80109704 <icmp_proc+0x82>
    if(icmp_p->type == ICMP_TYPE_ECHO_REQUEST){
801096b5:	8b 45 f0             	mov    -0x10(%ebp),%eax
801096b8:	0f b6 00             	movzbl (%eax),%eax
801096bb:	3c 08                	cmp    $0x8,%al
801096bd:	75 45                	jne    80109704 <icmp_proc+0x82>
      uint send_addr = (uint)kalloc();
801096bf:	e8 dc 90 ff ff       	call   801027a0 <kalloc>
801096c4:	89 45 ec             	mov    %eax,-0x14(%ebp)
      uint send_size = 0;
801096c7:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
      icmp_reply_pkt_create(buffer_addr,send_addr,&send_size);
801096ce:	83 ec 04             	sub    $0x4,%esp
801096d1:	8d 45 e8             	lea    -0x18(%ebp),%eax
801096d4:	50                   	push   %eax
801096d5:	ff 75 ec             	push   -0x14(%ebp)
801096d8:	ff 75 08             	push   0x8(%ebp)
801096db:	e8 78 00 00 00       	call   80109758 <icmp_reply_pkt_create>
801096e0:	83 c4 10             	add    $0x10,%esp
      i8254_send(send_addr,send_size);
801096e3:	8b 45 e8             	mov    -0x18(%ebp),%eax
801096e6:	83 ec 08             	sub    $0x8,%esp
801096e9:	50                   	push   %eax
801096ea:	ff 75 ec             	push   -0x14(%ebp)
801096ed:	e8 95 f4 ff ff       	call   80108b87 <i8254_send>
801096f2:	83 c4 10             	add    $0x10,%esp
      kfree((char *)send_addr);
801096f5:	8b 45 ec             	mov    -0x14(%ebp),%eax
801096f8:	83 ec 0c             	sub    $0xc,%esp
801096fb:	50                   	push   %eax
801096fc:	e8 05 90 ff ff       	call   80102706 <kfree>
80109701:	83 c4 10             	add    $0x10,%esp
    }
  }
}
80109704:	90                   	nop
80109705:	c9                   	leave  
80109706:	c3                   	ret    

80109707 <icmp_proc_req>:

void icmp_proc_req(struct icmp_echo_pkt * icmp_p){
80109707:	55                   	push   %ebp
80109708:	89 e5                	mov    %esp,%ebp
8010970a:	53                   	push   %ebx
8010970b:	83 ec 04             	sub    $0x4,%esp
  cprintf("ICMP ID:0x%x SEQ NUM:0x%x\n",N2H_ushort(icmp_p->id),N2H_ushort(icmp_p->seq_num));
8010970e:	8b 45 08             	mov    0x8(%ebp),%eax
80109711:	0f b7 40 06          	movzwl 0x6(%eax),%eax
80109715:	0f b7 c0             	movzwl %ax,%eax
80109718:	83 ec 0c             	sub    $0xc,%esp
8010971b:	50                   	push   %eax
8010971c:	e8 bd fd ff ff       	call   801094de <N2H_ushort>
80109721:	83 c4 10             	add    $0x10,%esp
80109724:	0f b7 d8             	movzwl %ax,%ebx
80109727:	8b 45 08             	mov    0x8(%ebp),%eax
8010972a:	0f b7 40 04          	movzwl 0x4(%eax),%eax
8010972e:	0f b7 c0             	movzwl %ax,%eax
80109731:	83 ec 0c             	sub    $0xc,%esp
80109734:	50                   	push   %eax
80109735:	e8 a4 fd ff ff       	call   801094de <N2H_ushort>
8010973a:	83 c4 10             	add    $0x10,%esp
8010973d:	0f b7 c0             	movzwl %ax,%eax
80109740:	83 ec 04             	sub    $0x4,%esp
80109743:	53                   	push   %ebx
80109744:	50                   	push   %eax
80109745:	68 83 c0 10 80       	push   $0x8010c083
8010974a:	e8 a5 6c ff ff       	call   801003f4 <cprintf>
8010974f:	83 c4 10             	add    $0x10,%esp
}
80109752:	90                   	nop
80109753:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80109756:	c9                   	leave  
80109757:	c3                   	ret    

80109758 <icmp_reply_pkt_create>:

void icmp_reply_pkt_create(uint recv_addr,uint send_addr,uint *send_size){
80109758:	55                   	push   %ebp
80109759:	89 e5                	mov    %esp,%ebp
8010975b:	83 ec 28             	sub    $0x28,%esp
  struct eth_pkt *eth_recv = (struct eth_pkt *)(recv_addr);
8010975e:	8b 45 08             	mov    0x8(%ebp),%eax
80109761:	89 45 f4             	mov    %eax,-0xc(%ebp)
  struct ipv4_pkt *ipv4_recv = (struct ipv4_pkt *)(recv_addr+sizeof(struct eth_pkt));
80109764:	8b 45 08             	mov    0x8(%ebp),%eax
80109767:	83 c0 0e             	add    $0xe,%eax
8010976a:	89 45 f0             	mov    %eax,-0x10(%ebp)
  struct icmp_echo_pkt *icmp_recv = (struct icmp_echo_pkt *)((uint)ipv4_recv+(ipv4_recv->ver&0xF)*4);
8010976d:	8b 45 f0             	mov    -0x10(%ebp),%eax
80109770:	0f b6 00             	movzbl (%eax),%eax
80109773:	0f b6 c0             	movzbl %al,%eax
80109776:	83 e0 0f             	and    $0xf,%eax
80109779:	c1 e0 02             	shl    $0x2,%eax
8010977c:	89 c2                	mov    %eax,%edx
8010977e:	8b 45 f0             	mov    -0x10(%ebp),%eax
80109781:	01 d0                	add    %edx,%eax
80109783:	89 45 ec             	mov    %eax,-0x14(%ebp)
  struct eth_pkt *eth_send = (struct eth_pkt *)(send_addr);
80109786:	8b 45 0c             	mov    0xc(%ebp),%eax
80109789:	89 45 e8             	mov    %eax,-0x18(%ebp)
  struct ipv4_pkt *ipv4_send = (struct ipv4_pkt *)(send_addr+sizeof(struct eth_pkt));
8010978c:	8b 45 0c             	mov    0xc(%ebp),%eax
8010978f:	83 c0 0e             	add    $0xe,%eax
80109792:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  struct icmp_echo_pkt *icmp_send = (struct icmp_echo_pkt *)((uint)ipv4_send+sizeof(struct ipv4_pkt));
80109795:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80109798:	83 c0 14             	add    $0x14,%eax
8010979b:	89 45 e0             	mov    %eax,-0x20(%ebp)
  
  *send_size = sizeof(struct eth_pkt) + sizeof(struct ipv4_pkt) + sizeof(struct icmp_echo_pkt);
8010979e:	8b 45 10             	mov    0x10(%ebp),%eax
801097a1:	c7 00 62 00 00 00    	movl   $0x62,(%eax)
  memmove(eth_send->dst_mac,eth_recv->src_mac,6);
801097a7:	8b 45 f4             	mov    -0xc(%ebp),%eax
801097aa:	8d 50 06             	lea    0x6(%eax),%edx
801097ad:	8b 45 e8             	mov    -0x18(%ebp),%eax
801097b0:	83 ec 04             	sub    $0x4,%esp
801097b3:	6a 06                	push   $0x6
801097b5:	52                   	push   %edx
801097b6:	50                   	push   %eax
801097b7:	e8 c0 b3 ff ff       	call   80104b7c <memmove>
801097bc:	83 c4 10             	add    $0x10,%esp
  memmove(eth_send->src_mac,mac_addr,6);
801097bf:	8b 45 e8             	mov    -0x18(%ebp),%eax
801097c2:	83 c0 06             	add    $0x6,%eax
801097c5:	83 ec 04             	sub    $0x4,%esp
801097c8:	6a 06                	push   $0x6
801097ca:	68 80 6c 19 80       	push   $0x80196c80
801097cf:	50                   	push   %eax
801097d0:	e8 a7 b3 ff ff       	call   80104b7c <memmove>
801097d5:	83 c4 10             	add    $0x10,%esp
  eth_send->type[0] = 0x08;
801097d8:	8b 45 e8             	mov    -0x18(%ebp),%eax
801097db:	c6 40 0c 08          	movb   $0x8,0xc(%eax)
  eth_send->type[1] = 0x00;
801097df:	8b 45 e8             	mov    -0x18(%ebp),%eax
801097e2:	c6 40 0d 00          	movb   $0x0,0xd(%eax)

  ipv4_send->ver = ((0x4)<<4)+((sizeof(struct ipv4_pkt)/4)&0xF);
801097e6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801097e9:	c6 00 45             	movb   $0x45,(%eax)
  ipv4_send->srv_type = 0;
801097ec:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801097ef:	c6 40 01 00          	movb   $0x0,0x1(%eax)
  ipv4_send->total_len = H2N_ushort(sizeof(struct ipv4_pkt) + sizeof(struct icmp_echo_pkt));
801097f3:	83 ec 0c             	sub    $0xc,%esp
801097f6:	6a 54                	push   $0x54
801097f8:	e8 03 fd ff ff       	call   80109500 <H2N_ushort>
801097fd:	83 c4 10             	add    $0x10,%esp
80109800:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80109803:	66 89 42 02          	mov    %ax,0x2(%edx)
  ipv4_send->id = send_id;
80109807:	0f b7 15 60 6f 19 80 	movzwl 0x80196f60,%edx
8010980e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80109811:	66 89 50 04          	mov    %dx,0x4(%eax)
  send_id++;
80109815:	0f b7 05 60 6f 19 80 	movzwl 0x80196f60,%eax
8010981c:	83 c0 01             	add    $0x1,%eax
8010981f:	66 a3 60 6f 19 80    	mov    %ax,0x80196f60
  ipv4_send->fragment = H2N_ushort(0x4000);
80109825:	83 ec 0c             	sub    $0xc,%esp
80109828:	68 00 40 00 00       	push   $0x4000
8010982d:	e8 ce fc ff ff       	call   80109500 <H2N_ushort>
80109832:	83 c4 10             	add    $0x10,%esp
80109835:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80109838:	66 89 42 06          	mov    %ax,0x6(%edx)
  ipv4_send->ttl = 255;
8010983c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010983f:	c6 40 08 ff          	movb   $0xff,0x8(%eax)
  ipv4_send->protocol = 0x1;
80109843:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80109846:	c6 40 09 01          	movb   $0x1,0x9(%eax)
  memmove(ipv4_send->src_ip,my_ip,4);
8010984a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010984d:	83 c0 0c             	add    $0xc,%eax
80109850:	83 ec 04             	sub    $0x4,%esp
80109853:	6a 04                	push   $0x4
80109855:	68 e4 f4 10 80       	push   $0x8010f4e4
8010985a:	50                   	push   %eax
8010985b:	e8 1c b3 ff ff       	call   80104b7c <memmove>
80109860:	83 c4 10             	add    $0x10,%esp
  memmove(ipv4_send->dst_ip,ipv4_recv->src_ip,4);
80109863:	8b 45 f0             	mov    -0x10(%ebp),%eax
80109866:	8d 50 0c             	lea    0xc(%eax),%edx
80109869:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010986c:	83 c0 10             	add    $0x10,%eax
8010986f:	83 ec 04             	sub    $0x4,%esp
80109872:	6a 04                	push   $0x4
80109874:	52                   	push   %edx
80109875:	50                   	push   %eax
80109876:	e8 01 b3 ff ff       	call   80104b7c <memmove>
8010987b:	83 c4 10             	add    $0x10,%esp
  ipv4_send->chk_sum = 0;
8010987e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80109881:	66 c7 40 0a 00 00    	movw   $0x0,0xa(%eax)
  ipv4_send->chk_sum = H2N_ushort(ipv4_chksum((uint)ipv4_send));
80109887:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010988a:	83 ec 0c             	sub    $0xc,%esp
8010988d:	50                   	push   %eax
8010988e:	e8 6d fd ff ff       	call   80109600 <ipv4_chksum>
80109893:	83 c4 10             	add    $0x10,%esp
80109896:	0f b7 c0             	movzwl %ax,%eax
80109899:	83 ec 0c             	sub    $0xc,%esp
8010989c:	50                   	push   %eax
8010989d:	e8 5e fc ff ff       	call   80109500 <H2N_ushort>
801098a2:	83 c4 10             	add    $0x10,%esp
801098a5:	8b 55 e4             	mov    -0x1c(%ebp),%edx
801098a8:	66 89 42 0a          	mov    %ax,0xa(%edx)

  icmp_send->type = ICMP_TYPE_ECHO_REPLY;
801098ac:	8b 45 e0             	mov    -0x20(%ebp),%eax
801098af:	c6 00 00             	movb   $0x0,(%eax)
  icmp_send->code = 0;
801098b2:	8b 45 e0             	mov    -0x20(%ebp),%eax
801098b5:	c6 40 01 00          	movb   $0x0,0x1(%eax)
  icmp_send->id = icmp_recv->id;
801098b9:	8b 45 ec             	mov    -0x14(%ebp),%eax
801098bc:	0f b7 50 04          	movzwl 0x4(%eax),%edx
801098c0:	8b 45 e0             	mov    -0x20(%ebp),%eax
801098c3:	66 89 50 04          	mov    %dx,0x4(%eax)
  icmp_send->seq_num = icmp_recv->seq_num;
801098c7:	8b 45 ec             	mov    -0x14(%ebp),%eax
801098ca:	0f b7 50 06          	movzwl 0x6(%eax),%edx
801098ce:	8b 45 e0             	mov    -0x20(%ebp),%eax
801098d1:	66 89 50 06          	mov    %dx,0x6(%eax)
  memmove(icmp_send->time_stamp,icmp_recv->time_stamp,8);
801098d5:	8b 45 ec             	mov    -0x14(%ebp),%eax
801098d8:	8d 50 08             	lea    0x8(%eax),%edx
801098db:	8b 45 e0             	mov    -0x20(%ebp),%eax
801098de:	83 c0 08             	add    $0x8,%eax
801098e1:	83 ec 04             	sub    $0x4,%esp
801098e4:	6a 08                	push   $0x8
801098e6:	52                   	push   %edx
801098e7:	50                   	push   %eax
801098e8:	e8 8f b2 ff ff       	call   80104b7c <memmove>
801098ed:	83 c4 10             	add    $0x10,%esp
  memmove(icmp_send->data,icmp_recv->data,48);
801098f0:	8b 45 ec             	mov    -0x14(%ebp),%eax
801098f3:	8d 50 10             	lea    0x10(%eax),%edx
801098f6:	8b 45 e0             	mov    -0x20(%ebp),%eax
801098f9:	83 c0 10             	add    $0x10,%eax
801098fc:	83 ec 04             	sub    $0x4,%esp
801098ff:	6a 30                	push   $0x30
80109901:	52                   	push   %edx
80109902:	50                   	push   %eax
80109903:	e8 74 b2 ff ff       	call   80104b7c <memmove>
80109908:	83 c4 10             	add    $0x10,%esp
  icmp_send->chk_sum = 0;
8010990b:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010990e:	66 c7 40 02 00 00    	movw   $0x0,0x2(%eax)
  icmp_send->chk_sum = H2N_ushort(icmp_chksum((uint)icmp_send));
80109914:	8b 45 e0             	mov    -0x20(%ebp),%eax
80109917:	83 ec 0c             	sub    $0xc,%esp
8010991a:	50                   	push   %eax
8010991b:	e8 1c 00 00 00       	call   8010993c <icmp_chksum>
80109920:	83 c4 10             	add    $0x10,%esp
80109923:	0f b7 c0             	movzwl %ax,%eax
80109926:	83 ec 0c             	sub    $0xc,%esp
80109929:	50                   	push   %eax
8010992a:	e8 d1 fb ff ff       	call   80109500 <H2N_ushort>
8010992f:	83 c4 10             	add    $0x10,%esp
80109932:	8b 55 e0             	mov    -0x20(%ebp),%edx
80109935:	66 89 42 02          	mov    %ax,0x2(%edx)
}
80109939:	90                   	nop
8010993a:	c9                   	leave  
8010993b:	c3                   	ret    

8010993c <icmp_chksum>:

ushort icmp_chksum(uint icmp_addr){
8010993c:	55                   	push   %ebp
8010993d:	89 e5                	mov    %esp,%ebp
8010993f:	83 ec 10             	sub    $0x10,%esp
  uchar* bin = (uchar *)icmp_addr;
80109942:	8b 45 08             	mov    0x8(%ebp),%eax
80109945:	89 45 f4             	mov    %eax,-0xc(%ebp)
  uint chk_sum = 0;
80109948:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  for(int i=0;i<32;i++){
8010994f:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
80109956:	eb 48                	jmp    801099a0 <icmp_chksum+0x64>
    chk_sum += (bin[i*2]<<8)+bin[i*2+1];
80109958:	8b 45 f8             	mov    -0x8(%ebp),%eax
8010995b:	01 c0                	add    %eax,%eax
8010995d:	89 c2                	mov    %eax,%edx
8010995f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80109962:	01 d0                	add    %edx,%eax
80109964:	0f b6 00             	movzbl (%eax),%eax
80109967:	0f b6 c0             	movzbl %al,%eax
8010996a:	c1 e0 08             	shl    $0x8,%eax
8010996d:	89 c2                	mov    %eax,%edx
8010996f:	8b 45 f8             	mov    -0x8(%ebp),%eax
80109972:	01 c0                	add    %eax,%eax
80109974:	8d 48 01             	lea    0x1(%eax),%ecx
80109977:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010997a:	01 c8                	add    %ecx,%eax
8010997c:	0f b6 00             	movzbl (%eax),%eax
8010997f:	0f b6 c0             	movzbl %al,%eax
80109982:	01 d0                	add    %edx,%eax
80109984:	01 45 fc             	add    %eax,-0x4(%ebp)
    if(chk_sum > 0xFFFF){
80109987:	81 7d fc ff ff 00 00 	cmpl   $0xffff,-0x4(%ebp)
8010998e:	76 0c                	jbe    8010999c <icmp_chksum+0x60>
      chk_sum = (chk_sum&0xFFFF)+1;
80109990:	8b 45 fc             	mov    -0x4(%ebp),%eax
80109993:	0f b7 c0             	movzwl %ax,%eax
80109996:	83 c0 01             	add    $0x1,%eax
80109999:	89 45 fc             	mov    %eax,-0x4(%ebp)
  for(int i=0;i<32;i++){
8010999c:	83 45 f8 01          	addl   $0x1,-0x8(%ebp)
801099a0:	83 7d f8 1f          	cmpl   $0x1f,-0x8(%ebp)
801099a4:	7e b2                	jle    80109958 <icmp_chksum+0x1c>
    }
  }
  return ~(chk_sum);
801099a6:	8b 45 fc             	mov    -0x4(%ebp),%eax
801099a9:	f7 d0                	not    %eax
}
801099ab:	c9                   	leave  
801099ac:	c3                   	ret    

801099ad <tcp_proc>:
extern ushort send_id;
extern uchar mac_addr[6];
extern uchar my_ip[4];
int fin_flag = 0;

void tcp_proc(uint buffer_addr){
801099ad:	55                   	push   %ebp
801099ae:	89 e5                	mov    %esp,%ebp
801099b0:	83 ec 38             	sub    $0x38,%esp
  struct ipv4_pkt *ipv4_p = (struct ipv4_pkt *)(buffer_addr + sizeof(struct eth_pkt));
801099b3:	8b 45 08             	mov    0x8(%ebp),%eax
801099b6:	83 c0 0e             	add    $0xe,%eax
801099b9:	89 45 f4             	mov    %eax,-0xc(%ebp)
  struct tcp_pkt *tcp_p = (struct tcp_pkt *)((uint)ipv4_p + (ipv4_p->ver&0xF)*4);
801099bc:	8b 45 f4             	mov    -0xc(%ebp),%eax
801099bf:	0f b6 00             	movzbl (%eax),%eax
801099c2:	0f b6 c0             	movzbl %al,%eax
801099c5:	83 e0 0f             	and    $0xf,%eax
801099c8:	c1 e0 02             	shl    $0x2,%eax
801099cb:	89 c2                	mov    %eax,%edx
801099cd:	8b 45 f4             	mov    -0xc(%ebp),%eax
801099d0:	01 d0                	add    %edx,%eax
801099d2:	89 45 f0             	mov    %eax,-0x10(%ebp)
  char *payload = (char *)((uint)tcp_p + 20);
801099d5:	8b 45 f0             	mov    -0x10(%ebp),%eax
801099d8:	83 c0 14             	add    $0x14,%eax
801099db:	89 45 ec             	mov    %eax,-0x14(%ebp)
  uint send_addr = (uint)kalloc();
801099de:	e8 bd 8d ff ff       	call   801027a0 <kalloc>
801099e3:	89 45 e8             	mov    %eax,-0x18(%ebp)
  uint send_size = 0;
801099e6:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
  if(tcp_p->code_bits[1]&TCP_CODEBITS_SYN){
801099ed:	8b 45 f0             	mov    -0x10(%ebp),%eax
801099f0:	0f b6 40 0d          	movzbl 0xd(%eax),%eax
801099f4:	0f b6 c0             	movzbl %al,%eax
801099f7:	83 e0 02             	and    $0x2,%eax
801099fa:	85 c0                	test   %eax,%eax
801099fc:	74 3d                	je     80109a3b <tcp_proc+0x8e>
    tcp_pkt_create(buffer_addr,send_addr,&send_size,TCP_CODEBITS_ACK | TCP_CODEBITS_SYN,0);
801099fe:	83 ec 0c             	sub    $0xc,%esp
80109a01:	6a 00                	push   $0x0
80109a03:	6a 12                	push   $0x12
80109a05:	8d 45 dc             	lea    -0x24(%ebp),%eax
80109a08:	50                   	push   %eax
80109a09:	ff 75 e8             	push   -0x18(%ebp)
80109a0c:	ff 75 08             	push   0x8(%ebp)
80109a0f:	e8 a2 01 00 00       	call   80109bb6 <tcp_pkt_create>
80109a14:	83 c4 20             	add    $0x20,%esp
    i8254_send(send_addr,send_size);
80109a17:	8b 45 dc             	mov    -0x24(%ebp),%eax
80109a1a:	83 ec 08             	sub    $0x8,%esp
80109a1d:	50                   	push   %eax
80109a1e:	ff 75 e8             	push   -0x18(%ebp)
80109a21:	e8 61 f1 ff ff       	call   80108b87 <i8254_send>
80109a26:	83 c4 10             	add    $0x10,%esp
    seq_num++;
80109a29:	a1 64 6f 19 80       	mov    0x80196f64,%eax
80109a2e:	83 c0 01             	add    $0x1,%eax
80109a31:	a3 64 6f 19 80       	mov    %eax,0x80196f64
80109a36:	e9 69 01 00 00       	jmp    80109ba4 <tcp_proc+0x1f7>
  }else if(tcp_p->code_bits[1] == (TCP_CODEBITS_PSH | TCP_CODEBITS_ACK)){
80109a3b:	8b 45 f0             	mov    -0x10(%ebp),%eax
80109a3e:	0f b6 40 0d          	movzbl 0xd(%eax),%eax
80109a42:	3c 18                	cmp    $0x18,%al
80109a44:	0f 85 10 01 00 00    	jne    80109b5a <tcp_proc+0x1ad>
    if(memcmp(payload,"GET",3)){
80109a4a:	83 ec 04             	sub    $0x4,%esp
80109a4d:	6a 03                	push   $0x3
80109a4f:	68 9e c0 10 80       	push   $0x8010c09e
80109a54:	ff 75 ec             	push   -0x14(%ebp)
80109a57:	e8 c8 b0 ff ff       	call   80104b24 <memcmp>
80109a5c:	83 c4 10             	add    $0x10,%esp
80109a5f:	85 c0                	test   %eax,%eax
80109a61:	74 74                	je     80109ad7 <tcp_proc+0x12a>
      cprintf("ACK PSH\n");
80109a63:	83 ec 0c             	sub    $0xc,%esp
80109a66:	68 a2 c0 10 80       	push   $0x8010c0a2
80109a6b:	e8 84 69 ff ff       	call   801003f4 <cprintf>
80109a70:	83 c4 10             	add    $0x10,%esp
      tcp_pkt_create(buffer_addr,send_addr,&send_size,TCP_CODEBITS_ACK,0);
80109a73:	83 ec 0c             	sub    $0xc,%esp
80109a76:	6a 00                	push   $0x0
80109a78:	6a 10                	push   $0x10
80109a7a:	8d 45 dc             	lea    -0x24(%ebp),%eax
80109a7d:	50                   	push   %eax
80109a7e:	ff 75 e8             	push   -0x18(%ebp)
80109a81:	ff 75 08             	push   0x8(%ebp)
80109a84:	e8 2d 01 00 00       	call   80109bb6 <tcp_pkt_create>
80109a89:	83 c4 20             	add    $0x20,%esp
      i8254_send(send_addr,send_size);
80109a8c:	8b 45 dc             	mov    -0x24(%ebp),%eax
80109a8f:	83 ec 08             	sub    $0x8,%esp
80109a92:	50                   	push   %eax
80109a93:	ff 75 e8             	push   -0x18(%ebp)
80109a96:	e8 ec f0 ff ff       	call   80108b87 <i8254_send>
80109a9b:	83 c4 10             	add    $0x10,%esp
      uint send_payload = (send_addr + sizeof(struct eth_pkt) + sizeof(struct ipv4_pkt) + sizeof(struct tcp_pkt));
80109a9e:	8b 45 e8             	mov    -0x18(%ebp),%eax
80109aa1:	83 c0 36             	add    $0x36,%eax
80109aa4:	89 45 e0             	mov    %eax,-0x20(%ebp)
      uint payload_size;
      http_proc(0,0,send_payload,&payload_size);
80109aa7:	8d 45 d8             	lea    -0x28(%ebp),%eax
80109aaa:	50                   	push   %eax
80109aab:	ff 75 e0             	push   -0x20(%ebp)
80109aae:	6a 00                	push   $0x0
80109ab0:	6a 00                	push   $0x0
80109ab2:	e8 5a 04 00 00       	call   80109f11 <http_proc>
80109ab7:	83 c4 10             	add    $0x10,%esp
      tcp_pkt_create(buffer_addr,send_addr,&send_size,(TCP_CODEBITS_ACK|TCP_CODEBITS_PSH),payload_size);
80109aba:	8b 45 d8             	mov    -0x28(%ebp),%eax
80109abd:	83 ec 0c             	sub    $0xc,%esp
80109ac0:	50                   	push   %eax
80109ac1:	6a 18                	push   $0x18
80109ac3:	8d 45 dc             	lea    -0x24(%ebp),%eax
80109ac6:	50                   	push   %eax
80109ac7:	ff 75 e8             	push   -0x18(%ebp)
80109aca:	ff 75 08             	push   0x8(%ebp)
80109acd:	e8 e4 00 00 00       	call   80109bb6 <tcp_pkt_create>
80109ad2:	83 c4 20             	add    $0x20,%esp
80109ad5:	eb 62                	jmp    80109b39 <tcp_proc+0x18c>
    }else{
     tcp_pkt_create(buffer_addr,send_addr,&send_size,TCP_CODEBITS_ACK,0);
80109ad7:	83 ec 0c             	sub    $0xc,%esp
80109ada:	6a 00                	push   $0x0
80109adc:	6a 10                	push   $0x10
80109ade:	8d 45 dc             	lea    -0x24(%ebp),%eax
80109ae1:	50                   	push   %eax
80109ae2:	ff 75 e8             	push   -0x18(%ebp)
80109ae5:	ff 75 08             	push   0x8(%ebp)
80109ae8:	e8 c9 00 00 00       	call   80109bb6 <tcp_pkt_create>
80109aed:	83 c4 20             	add    $0x20,%esp
     i8254_send(send_addr,send_size);
80109af0:	8b 45 dc             	mov    -0x24(%ebp),%eax
80109af3:	83 ec 08             	sub    $0x8,%esp
80109af6:	50                   	push   %eax
80109af7:	ff 75 e8             	push   -0x18(%ebp)
80109afa:	e8 88 f0 ff ff       	call   80108b87 <i8254_send>
80109aff:	83 c4 10             	add    $0x10,%esp
      uint send_payload = (send_addr + sizeof(struct eth_pkt) + sizeof(struct ipv4_pkt) + sizeof(struct tcp_pkt));
80109b02:	8b 45 e8             	mov    -0x18(%ebp),%eax
80109b05:	83 c0 36             	add    $0x36,%eax
80109b08:	89 45 e4             	mov    %eax,-0x1c(%ebp)
      uint payload_size;
      http_proc(0,0,send_payload,&payload_size);
80109b0b:	8d 45 d4             	lea    -0x2c(%ebp),%eax
80109b0e:	50                   	push   %eax
80109b0f:	ff 75 e4             	push   -0x1c(%ebp)
80109b12:	6a 00                	push   $0x0
80109b14:	6a 00                	push   $0x0
80109b16:	e8 f6 03 00 00       	call   80109f11 <http_proc>
80109b1b:	83 c4 10             	add    $0x10,%esp
      tcp_pkt_create(buffer_addr,send_addr,&send_size,(TCP_CODEBITS_ACK|TCP_CODEBITS_PSH),payload_size);
80109b1e:	8b 45 d4             	mov    -0x2c(%ebp),%eax
80109b21:	83 ec 0c             	sub    $0xc,%esp
80109b24:	50                   	push   %eax
80109b25:	6a 18                	push   $0x18
80109b27:	8d 45 dc             	lea    -0x24(%ebp),%eax
80109b2a:	50                   	push   %eax
80109b2b:	ff 75 e8             	push   -0x18(%ebp)
80109b2e:	ff 75 08             	push   0x8(%ebp)
80109b31:	e8 80 00 00 00       	call   80109bb6 <tcp_pkt_create>
80109b36:	83 c4 20             	add    $0x20,%esp
    }
    i8254_send(send_addr,send_size);
80109b39:	8b 45 dc             	mov    -0x24(%ebp),%eax
80109b3c:	83 ec 08             	sub    $0x8,%esp
80109b3f:	50                   	push   %eax
80109b40:	ff 75 e8             	push   -0x18(%ebp)
80109b43:	e8 3f f0 ff ff       	call   80108b87 <i8254_send>
80109b48:	83 c4 10             	add    $0x10,%esp
    seq_num++;
80109b4b:	a1 64 6f 19 80       	mov    0x80196f64,%eax
80109b50:	83 c0 01             	add    $0x1,%eax
80109b53:	a3 64 6f 19 80       	mov    %eax,0x80196f64
80109b58:	eb 4a                	jmp    80109ba4 <tcp_proc+0x1f7>
  }else if(tcp_p->code_bits[1] == TCP_CODEBITS_ACK){
80109b5a:	8b 45 f0             	mov    -0x10(%ebp),%eax
80109b5d:	0f b6 40 0d          	movzbl 0xd(%eax),%eax
80109b61:	3c 10                	cmp    $0x10,%al
80109b63:	75 3f                	jne    80109ba4 <tcp_proc+0x1f7>
    if(fin_flag == 1){
80109b65:	a1 68 6f 19 80       	mov    0x80196f68,%eax
80109b6a:	83 f8 01             	cmp    $0x1,%eax
80109b6d:	75 35                	jne    80109ba4 <tcp_proc+0x1f7>
      tcp_pkt_create(buffer_addr,send_addr,&send_size,TCP_CODEBITS_FIN,0);
80109b6f:	83 ec 0c             	sub    $0xc,%esp
80109b72:	6a 00                	push   $0x0
80109b74:	6a 01                	push   $0x1
80109b76:	8d 45 dc             	lea    -0x24(%ebp),%eax
80109b79:	50                   	push   %eax
80109b7a:	ff 75 e8             	push   -0x18(%ebp)
80109b7d:	ff 75 08             	push   0x8(%ebp)
80109b80:	e8 31 00 00 00       	call   80109bb6 <tcp_pkt_create>
80109b85:	83 c4 20             	add    $0x20,%esp
      i8254_send(send_addr,send_size);
80109b88:	8b 45 dc             	mov    -0x24(%ebp),%eax
80109b8b:	83 ec 08             	sub    $0x8,%esp
80109b8e:	50                   	push   %eax
80109b8f:	ff 75 e8             	push   -0x18(%ebp)
80109b92:	e8 f0 ef ff ff       	call   80108b87 <i8254_send>
80109b97:	83 c4 10             	add    $0x10,%esp
      fin_flag = 0;
80109b9a:	c7 05 68 6f 19 80 00 	movl   $0x0,0x80196f68
80109ba1:	00 00 00 
    }
  }
  kfree((char *)send_addr);
80109ba4:	8b 45 e8             	mov    -0x18(%ebp),%eax
80109ba7:	83 ec 0c             	sub    $0xc,%esp
80109baa:	50                   	push   %eax
80109bab:	e8 56 8b ff ff       	call   80102706 <kfree>
80109bb0:	83 c4 10             	add    $0x10,%esp
}
80109bb3:	90                   	nop
80109bb4:	c9                   	leave  
80109bb5:	c3                   	ret    

80109bb6 <tcp_pkt_create>:

void tcp_pkt_create(uint recv_addr,uint send_addr,uint *send_size,uint pkt_type,uint payload_size){
80109bb6:	55                   	push   %ebp
80109bb7:	89 e5                	mov    %esp,%ebp
80109bb9:	83 ec 28             	sub    $0x28,%esp
  struct eth_pkt *eth_recv = (struct eth_pkt *)(recv_addr);
80109bbc:	8b 45 08             	mov    0x8(%ebp),%eax
80109bbf:	89 45 f4             	mov    %eax,-0xc(%ebp)
  struct ipv4_pkt *ipv4_recv = (struct ipv4_pkt *)(recv_addr+sizeof(struct eth_pkt));
80109bc2:	8b 45 08             	mov    0x8(%ebp),%eax
80109bc5:	83 c0 0e             	add    $0xe,%eax
80109bc8:	89 45 f0             	mov    %eax,-0x10(%ebp)
  struct tcp_pkt *tcp_recv = (struct tcp_pkt *)((uint)ipv4_recv + (ipv4_recv->ver&0xF)*4);
80109bcb:	8b 45 f0             	mov    -0x10(%ebp),%eax
80109bce:	0f b6 00             	movzbl (%eax),%eax
80109bd1:	0f b6 c0             	movzbl %al,%eax
80109bd4:	83 e0 0f             	and    $0xf,%eax
80109bd7:	c1 e0 02             	shl    $0x2,%eax
80109bda:	89 c2                	mov    %eax,%edx
80109bdc:	8b 45 f0             	mov    -0x10(%ebp),%eax
80109bdf:	01 d0                	add    %edx,%eax
80109be1:	89 45 ec             	mov    %eax,-0x14(%ebp)

  struct eth_pkt *eth_send = (struct eth_pkt *)(send_addr);
80109be4:	8b 45 0c             	mov    0xc(%ebp),%eax
80109be7:	89 45 e8             	mov    %eax,-0x18(%ebp)
  struct ipv4_pkt *ipv4_send = (struct ipv4_pkt *)(send_addr + sizeof(struct eth_pkt));
80109bea:	8b 45 0c             	mov    0xc(%ebp),%eax
80109bed:	83 c0 0e             	add    $0xe,%eax
80109bf0:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  struct tcp_pkt *tcp_send = (struct tcp_pkt *)((uint)ipv4_send + sizeof(struct ipv4_pkt));
80109bf3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80109bf6:	83 c0 14             	add    $0x14,%eax
80109bf9:	89 45 e0             	mov    %eax,-0x20(%ebp)

  *send_size = sizeof(struct eth_pkt) + sizeof(struct ipv4_pkt) + sizeof(struct tcp_pkt) + payload_size;
80109bfc:	8b 45 18             	mov    0x18(%ebp),%eax
80109bff:	8d 50 36             	lea    0x36(%eax),%edx
80109c02:	8b 45 10             	mov    0x10(%ebp),%eax
80109c05:	89 10                	mov    %edx,(%eax)

  memmove(eth_send->dst_mac,eth_recv->src_mac,6);
80109c07:	8b 45 f4             	mov    -0xc(%ebp),%eax
80109c0a:	8d 50 06             	lea    0x6(%eax),%edx
80109c0d:	8b 45 e8             	mov    -0x18(%ebp),%eax
80109c10:	83 ec 04             	sub    $0x4,%esp
80109c13:	6a 06                	push   $0x6
80109c15:	52                   	push   %edx
80109c16:	50                   	push   %eax
80109c17:	e8 60 af ff ff       	call   80104b7c <memmove>
80109c1c:	83 c4 10             	add    $0x10,%esp
  memmove(eth_send->src_mac,mac_addr,6);
80109c1f:	8b 45 e8             	mov    -0x18(%ebp),%eax
80109c22:	83 c0 06             	add    $0x6,%eax
80109c25:	83 ec 04             	sub    $0x4,%esp
80109c28:	6a 06                	push   $0x6
80109c2a:	68 80 6c 19 80       	push   $0x80196c80
80109c2f:	50                   	push   %eax
80109c30:	e8 47 af ff ff       	call   80104b7c <memmove>
80109c35:	83 c4 10             	add    $0x10,%esp
  eth_send->type[0] = 0x08;
80109c38:	8b 45 e8             	mov    -0x18(%ebp),%eax
80109c3b:	c6 40 0c 08          	movb   $0x8,0xc(%eax)
  eth_send->type[1] = 0x00;
80109c3f:	8b 45 e8             	mov    -0x18(%ebp),%eax
80109c42:	c6 40 0d 00          	movb   $0x0,0xd(%eax)

  ipv4_send->ver = ((0x4)<<4)+((sizeof(struct ipv4_pkt)/4)&0xF);
80109c46:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80109c49:	c6 00 45             	movb   $0x45,(%eax)
  ipv4_send->srv_type = 0;
80109c4c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80109c4f:	c6 40 01 00          	movb   $0x0,0x1(%eax)
  ipv4_send->total_len = H2N_ushort(sizeof(struct ipv4_pkt) + sizeof(struct tcp_pkt) + payload_size);
80109c53:	8b 45 18             	mov    0x18(%ebp),%eax
80109c56:	83 c0 28             	add    $0x28,%eax
80109c59:	0f b7 c0             	movzwl %ax,%eax
80109c5c:	83 ec 0c             	sub    $0xc,%esp
80109c5f:	50                   	push   %eax
80109c60:	e8 9b f8 ff ff       	call   80109500 <H2N_ushort>
80109c65:	83 c4 10             	add    $0x10,%esp
80109c68:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80109c6b:	66 89 42 02          	mov    %ax,0x2(%edx)
  ipv4_send->id = send_id;
80109c6f:	0f b7 15 60 6f 19 80 	movzwl 0x80196f60,%edx
80109c76:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80109c79:	66 89 50 04          	mov    %dx,0x4(%eax)
  send_id++;
80109c7d:	0f b7 05 60 6f 19 80 	movzwl 0x80196f60,%eax
80109c84:	83 c0 01             	add    $0x1,%eax
80109c87:	66 a3 60 6f 19 80    	mov    %ax,0x80196f60
  ipv4_send->fragment = H2N_ushort(0x0000);
80109c8d:	83 ec 0c             	sub    $0xc,%esp
80109c90:	6a 00                	push   $0x0
80109c92:	e8 69 f8 ff ff       	call   80109500 <H2N_ushort>
80109c97:	83 c4 10             	add    $0x10,%esp
80109c9a:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80109c9d:	66 89 42 06          	mov    %ax,0x6(%edx)
  ipv4_send->ttl = 255;
80109ca1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80109ca4:	c6 40 08 ff          	movb   $0xff,0x8(%eax)
  ipv4_send->protocol = IPV4_TYPE_TCP;
80109ca8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80109cab:	c6 40 09 06          	movb   $0x6,0x9(%eax)
  memmove(ipv4_send->src_ip,my_ip,4);
80109caf:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80109cb2:	83 c0 0c             	add    $0xc,%eax
80109cb5:	83 ec 04             	sub    $0x4,%esp
80109cb8:	6a 04                	push   $0x4
80109cba:	68 e4 f4 10 80       	push   $0x8010f4e4
80109cbf:	50                   	push   %eax
80109cc0:	e8 b7 ae ff ff       	call   80104b7c <memmove>
80109cc5:	83 c4 10             	add    $0x10,%esp
  memmove(ipv4_send->dst_ip,ipv4_recv->src_ip,4);
80109cc8:	8b 45 f0             	mov    -0x10(%ebp),%eax
80109ccb:	8d 50 0c             	lea    0xc(%eax),%edx
80109cce:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80109cd1:	83 c0 10             	add    $0x10,%eax
80109cd4:	83 ec 04             	sub    $0x4,%esp
80109cd7:	6a 04                	push   $0x4
80109cd9:	52                   	push   %edx
80109cda:	50                   	push   %eax
80109cdb:	e8 9c ae ff ff       	call   80104b7c <memmove>
80109ce0:	83 c4 10             	add    $0x10,%esp
  ipv4_send->chk_sum = 0;
80109ce3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80109ce6:	66 c7 40 0a 00 00    	movw   $0x0,0xa(%eax)
  ipv4_send->chk_sum = H2N_ushort(ipv4_chksum((uint)ipv4_send));
80109cec:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80109cef:	83 ec 0c             	sub    $0xc,%esp
80109cf2:	50                   	push   %eax
80109cf3:	e8 08 f9 ff ff       	call   80109600 <ipv4_chksum>
80109cf8:	83 c4 10             	add    $0x10,%esp
80109cfb:	0f b7 c0             	movzwl %ax,%eax
80109cfe:	83 ec 0c             	sub    $0xc,%esp
80109d01:	50                   	push   %eax
80109d02:	e8 f9 f7 ff ff       	call   80109500 <H2N_ushort>
80109d07:	83 c4 10             	add    $0x10,%esp
80109d0a:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80109d0d:	66 89 42 0a          	mov    %ax,0xa(%edx)
  

  tcp_send->src_port = tcp_recv->dst_port;
80109d11:	8b 45 ec             	mov    -0x14(%ebp),%eax
80109d14:	0f b7 50 02          	movzwl 0x2(%eax),%edx
80109d18:	8b 45 e0             	mov    -0x20(%ebp),%eax
80109d1b:	66 89 10             	mov    %dx,(%eax)
  tcp_send->dst_port = tcp_recv->src_port;
80109d1e:	8b 45 ec             	mov    -0x14(%ebp),%eax
80109d21:	0f b7 10             	movzwl (%eax),%edx
80109d24:	8b 45 e0             	mov    -0x20(%ebp),%eax
80109d27:	66 89 50 02          	mov    %dx,0x2(%eax)
  tcp_send->seq_num = H2N_uint(seq_num);
80109d2b:	a1 64 6f 19 80       	mov    0x80196f64,%eax
80109d30:	83 ec 0c             	sub    $0xc,%esp
80109d33:	50                   	push   %eax
80109d34:	e8 e9 f7 ff ff       	call   80109522 <H2N_uint>
80109d39:	83 c4 10             	add    $0x10,%esp
80109d3c:	8b 55 e0             	mov    -0x20(%ebp),%edx
80109d3f:	89 42 04             	mov    %eax,0x4(%edx)
  tcp_send->ack_num = tcp_recv->seq_num + (1<<(8*3));
80109d42:	8b 45 ec             	mov    -0x14(%ebp),%eax
80109d45:	8b 40 04             	mov    0x4(%eax),%eax
80109d48:	8d 90 00 00 00 01    	lea    0x1000000(%eax),%edx
80109d4e:	8b 45 e0             	mov    -0x20(%ebp),%eax
80109d51:	89 50 08             	mov    %edx,0x8(%eax)

  tcp_send->code_bits[0] = 0;
80109d54:	8b 45 e0             	mov    -0x20(%ebp),%eax
80109d57:	c6 40 0c 00          	movb   $0x0,0xc(%eax)
  tcp_send->code_bits[1] = 0;
80109d5b:	8b 45 e0             	mov    -0x20(%ebp),%eax
80109d5e:	c6 40 0d 00          	movb   $0x0,0xd(%eax)
  tcp_send->code_bits[0] = 5<<4;
80109d62:	8b 45 e0             	mov    -0x20(%ebp),%eax
80109d65:	c6 40 0c 50          	movb   $0x50,0xc(%eax)
  tcp_send->code_bits[1] = pkt_type;
80109d69:	8b 45 14             	mov    0x14(%ebp),%eax
80109d6c:	89 c2                	mov    %eax,%edx
80109d6e:	8b 45 e0             	mov    -0x20(%ebp),%eax
80109d71:	88 50 0d             	mov    %dl,0xd(%eax)

  tcp_send->window = H2N_ushort(14480);
80109d74:	83 ec 0c             	sub    $0xc,%esp
80109d77:	68 90 38 00 00       	push   $0x3890
80109d7c:	e8 7f f7 ff ff       	call   80109500 <H2N_ushort>
80109d81:	83 c4 10             	add    $0x10,%esp
80109d84:	8b 55 e0             	mov    -0x20(%ebp),%edx
80109d87:	66 89 42 0e          	mov    %ax,0xe(%edx)
  tcp_send->urgent_ptr = 0;
80109d8b:	8b 45 e0             	mov    -0x20(%ebp),%eax
80109d8e:	66 c7 40 12 00 00    	movw   $0x0,0x12(%eax)
  tcp_send->chk_sum = 0;
80109d94:	8b 45 e0             	mov    -0x20(%ebp),%eax
80109d97:	66 c7 40 10 00 00    	movw   $0x0,0x10(%eax)

  tcp_send->chk_sum = H2N_ushort(tcp_chksum((uint)(ipv4_send))+8);
80109d9d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80109da0:	83 ec 0c             	sub    $0xc,%esp
80109da3:	50                   	push   %eax
80109da4:	e8 1f 00 00 00       	call   80109dc8 <tcp_chksum>
80109da9:	83 c4 10             	add    $0x10,%esp
80109dac:	83 c0 08             	add    $0x8,%eax
80109daf:	0f b7 c0             	movzwl %ax,%eax
80109db2:	83 ec 0c             	sub    $0xc,%esp
80109db5:	50                   	push   %eax
80109db6:	e8 45 f7 ff ff       	call   80109500 <H2N_ushort>
80109dbb:	83 c4 10             	add    $0x10,%esp
80109dbe:	8b 55 e0             	mov    -0x20(%ebp),%edx
80109dc1:	66 89 42 10          	mov    %ax,0x10(%edx)


}
80109dc5:	90                   	nop
80109dc6:	c9                   	leave  
80109dc7:	c3                   	ret    

80109dc8 <tcp_chksum>:

ushort tcp_chksum(uint tcp_addr){
80109dc8:	55                   	push   %ebp
80109dc9:	89 e5                	mov    %esp,%ebp
80109dcb:	83 ec 38             	sub    $0x38,%esp
  struct ipv4_pkt *ipv4_p = (struct ipv4_pkt *)(tcp_addr);
80109dce:	8b 45 08             	mov    0x8(%ebp),%eax
80109dd1:	89 45 e8             	mov    %eax,-0x18(%ebp)
  struct tcp_pkt *tcp_p = (struct tcp_pkt *)((uint)ipv4_p + sizeof(struct ipv4_pkt));
80109dd4:	8b 45 e8             	mov    -0x18(%ebp),%eax
80109dd7:	83 c0 14             	add    $0x14,%eax
80109dda:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  struct tcp_dummy tcp_dummy;
  
  memmove(tcp_dummy.src_ip,my_ip,4);
80109ddd:	83 ec 04             	sub    $0x4,%esp
80109de0:	6a 04                	push   $0x4
80109de2:	68 e4 f4 10 80       	push   $0x8010f4e4
80109de7:	8d 45 d4             	lea    -0x2c(%ebp),%eax
80109dea:	50                   	push   %eax
80109deb:	e8 8c ad ff ff       	call   80104b7c <memmove>
80109df0:	83 c4 10             	add    $0x10,%esp
  memmove(tcp_dummy.dst_ip,ipv4_p->src_ip,4);
80109df3:	8b 45 e8             	mov    -0x18(%ebp),%eax
80109df6:	83 c0 0c             	add    $0xc,%eax
80109df9:	83 ec 04             	sub    $0x4,%esp
80109dfc:	6a 04                	push   $0x4
80109dfe:	50                   	push   %eax
80109dff:	8d 45 d4             	lea    -0x2c(%ebp),%eax
80109e02:	83 c0 04             	add    $0x4,%eax
80109e05:	50                   	push   %eax
80109e06:	e8 71 ad ff ff       	call   80104b7c <memmove>
80109e0b:	83 c4 10             	add    $0x10,%esp
  tcp_dummy.padding = 0;
80109e0e:	c6 45 dc 00          	movb   $0x0,-0x24(%ebp)
  tcp_dummy.protocol = IPV4_TYPE_TCP;
80109e12:	c6 45 dd 06          	movb   $0x6,-0x23(%ebp)
  tcp_dummy.tcp_len = H2N_ushort(N2H_ushort(ipv4_p->total_len) - sizeof(struct ipv4_pkt));
80109e16:	8b 45 e8             	mov    -0x18(%ebp),%eax
80109e19:	0f b7 40 02          	movzwl 0x2(%eax),%eax
80109e1d:	0f b7 c0             	movzwl %ax,%eax
80109e20:	83 ec 0c             	sub    $0xc,%esp
80109e23:	50                   	push   %eax
80109e24:	e8 b5 f6 ff ff       	call   801094de <N2H_ushort>
80109e29:	83 c4 10             	add    $0x10,%esp
80109e2c:	83 e8 14             	sub    $0x14,%eax
80109e2f:	0f b7 c0             	movzwl %ax,%eax
80109e32:	83 ec 0c             	sub    $0xc,%esp
80109e35:	50                   	push   %eax
80109e36:	e8 c5 f6 ff ff       	call   80109500 <H2N_ushort>
80109e3b:	83 c4 10             	add    $0x10,%esp
80109e3e:	66 89 45 de          	mov    %ax,-0x22(%ebp)
  uint chk_sum = 0;
80109e42:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  uchar *bin = (uchar *)(&tcp_dummy);
80109e49:	8d 45 d4             	lea    -0x2c(%ebp),%eax
80109e4c:	89 45 e0             	mov    %eax,-0x20(%ebp)
  for(int i=0;i<6;i++){
80109e4f:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
80109e56:	eb 33                	jmp    80109e8b <tcp_chksum+0xc3>
    chk_sum += (bin[i*2]<<8)+bin[i*2+1];
80109e58:	8b 45 f0             	mov    -0x10(%ebp),%eax
80109e5b:	01 c0                	add    %eax,%eax
80109e5d:	89 c2                	mov    %eax,%edx
80109e5f:	8b 45 e0             	mov    -0x20(%ebp),%eax
80109e62:	01 d0                	add    %edx,%eax
80109e64:	0f b6 00             	movzbl (%eax),%eax
80109e67:	0f b6 c0             	movzbl %al,%eax
80109e6a:	c1 e0 08             	shl    $0x8,%eax
80109e6d:	89 c2                	mov    %eax,%edx
80109e6f:	8b 45 f0             	mov    -0x10(%ebp),%eax
80109e72:	01 c0                	add    %eax,%eax
80109e74:	8d 48 01             	lea    0x1(%eax),%ecx
80109e77:	8b 45 e0             	mov    -0x20(%ebp),%eax
80109e7a:	01 c8                	add    %ecx,%eax
80109e7c:	0f b6 00             	movzbl (%eax),%eax
80109e7f:	0f b6 c0             	movzbl %al,%eax
80109e82:	01 d0                	add    %edx,%eax
80109e84:	01 45 f4             	add    %eax,-0xc(%ebp)
  for(int i=0;i<6;i++){
80109e87:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
80109e8b:	83 7d f0 05          	cmpl   $0x5,-0x10(%ebp)
80109e8f:	7e c7                	jle    80109e58 <tcp_chksum+0x90>
  }

  bin = (uchar *)(tcp_p);
80109e91:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80109e94:	89 45 e0             	mov    %eax,-0x20(%ebp)
  for(int i=0;i<(N2H_ushort(tcp_dummy.tcp_len)/2);i++){
80109e97:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
80109e9e:	eb 33                	jmp    80109ed3 <tcp_chksum+0x10b>
    chk_sum += (bin[i*2]<<8)+bin[i*2+1];
80109ea0:	8b 45 ec             	mov    -0x14(%ebp),%eax
80109ea3:	01 c0                	add    %eax,%eax
80109ea5:	89 c2                	mov    %eax,%edx
80109ea7:	8b 45 e0             	mov    -0x20(%ebp),%eax
80109eaa:	01 d0                	add    %edx,%eax
80109eac:	0f b6 00             	movzbl (%eax),%eax
80109eaf:	0f b6 c0             	movzbl %al,%eax
80109eb2:	c1 e0 08             	shl    $0x8,%eax
80109eb5:	89 c2                	mov    %eax,%edx
80109eb7:	8b 45 ec             	mov    -0x14(%ebp),%eax
80109eba:	01 c0                	add    %eax,%eax
80109ebc:	8d 48 01             	lea    0x1(%eax),%ecx
80109ebf:	8b 45 e0             	mov    -0x20(%ebp),%eax
80109ec2:	01 c8                	add    %ecx,%eax
80109ec4:	0f b6 00             	movzbl (%eax),%eax
80109ec7:	0f b6 c0             	movzbl %al,%eax
80109eca:	01 d0                	add    %edx,%eax
80109ecc:	01 45 f4             	add    %eax,-0xc(%ebp)
  for(int i=0;i<(N2H_ushort(tcp_dummy.tcp_len)/2);i++){
80109ecf:	83 45 ec 01          	addl   $0x1,-0x14(%ebp)
80109ed3:	0f b7 45 de          	movzwl -0x22(%ebp),%eax
80109ed7:	0f b7 c0             	movzwl %ax,%eax
80109eda:	83 ec 0c             	sub    $0xc,%esp
80109edd:	50                   	push   %eax
80109ede:	e8 fb f5 ff ff       	call   801094de <N2H_ushort>
80109ee3:	83 c4 10             	add    $0x10,%esp
80109ee6:	66 d1 e8             	shr    %ax
80109ee9:	0f b7 c0             	movzwl %ax,%eax
80109eec:	39 45 ec             	cmp    %eax,-0x14(%ebp)
80109eef:	7c af                	jl     80109ea0 <tcp_chksum+0xd8>
  }
  chk_sum += (chk_sum>>8*2);
80109ef1:	8b 45 f4             	mov    -0xc(%ebp),%eax
80109ef4:	c1 e8 10             	shr    $0x10,%eax
80109ef7:	01 45 f4             	add    %eax,-0xc(%ebp)
  return ~(chk_sum);
80109efa:	8b 45 f4             	mov    -0xc(%ebp),%eax
80109efd:	f7 d0                	not    %eax
}
80109eff:	c9                   	leave  
80109f00:	c3                   	ret    

80109f01 <tcp_fin>:

void tcp_fin(){
80109f01:	55                   	push   %ebp
80109f02:	89 e5                	mov    %esp,%ebp
  fin_flag =1;
80109f04:	c7 05 68 6f 19 80 01 	movl   $0x1,0x80196f68
80109f0b:	00 00 00 
}
80109f0e:	90                   	nop
80109f0f:	5d                   	pop    %ebp
80109f10:	c3                   	ret    

80109f11 <http_proc>:
#include "defs.h"
#include "types.h"
#include "tcp.h"


void http_proc(uint recv, uint recv_size, uint send, uint *send_size){
80109f11:	55                   	push   %ebp
80109f12:	89 e5                	mov    %esp,%ebp
80109f14:	83 ec 18             	sub    $0x18,%esp
  int len;
  len = http_strcpy((char *)send,"HTTP/1.0 200 OK \r\n",0);
80109f17:	8b 45 10             	mov    0x10(%ebp),%eax
80109f1a:	83 ec 04             	sub    $0x4,%esp
80109f1d:	6a 00                	push   $0x0
80109f1f:	68 ab c0 10 80       	push   $0x8010c0ab
80109f24:	50                   	push   %eax
80109f25:	e8 65 00 00 00       	call   80109f8f <http_strcpy>
80109f2a:	83 c4 10             	add    $0x10,%esp
80109f2d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  len += http_strcpy((char *)send,"Content-Type: text/html \r\n",len);
80109f30:	8b 45 10             	mov    0x10(%ebp),%eax
80109f33:	83 ec 04             	sub    $0x4,%esp
80109f36:	ff 75 f4             	push   -0xc(%ebp)
80109f39:	68 be c0 10 80       	push   $0x8010c0be
80109f3e:	50                   	push   %eax
80109f3f:	e8 4b 00 00 00       	call   80109f8f <http_strcpy>
80109f44:	83 c4 10             	add    $0x10,%esp
80109f47:	01 45 f4             	add    %eax,-0xc(%ebp)
  len += http_strcpy((char *)send,"\r\nHello World!\r\n",len);
80109f4a:	8b 45 10             	mov    0x10(%ebp),%eax
80109f4d:	83 ec 04             	sub    $0x4,%esp
80109f50:	ff 75 f4             	push   -0xc(%ebp)
80109f53:	68 d9 c0 10 80       	push   $0x8010c0d9
80109f58:	50                   	push   %eax
80109f59:	e8 31 00 00 00       	call   80109f8f <http_strcpy>
80109f5e:	83 c4 10             	add    $0x10,%esp
80109f61:	01 45 f4             	add    %eax,-0xc(%ebp)
  if(len%2 != 0){
80109f64:	8b 45 f4             	mov    -0xc(%ebp),%eax
80109f67:	83 e0 01             	and    $0x1,%eax
80109f6a:	85 c0                	test   %eax,%eax
80109f6c:	74 11                	je     80109f7f <http_proc+0x6e>
    char *payload = (char *)send;
80109f6e:	8b 45 10             	mov    0x10(%ebp),%eax
80109f71:	89 45 f0             	mov    %eax,-0x10(%ebp)
    payload[len] = 0;
80109f74:	8b 55 f4             	mov    -0xc(%ebp),%edx
80109f77:	8b 45 f0             	mov    -0x10(%ebp),%eax
80109f7a:	01 d0                	add    %edx,%eax
80109f7c:	c6 00 00             	movb   $0x0,(%eax)
  }
  *send_size = len;
80109f7f:	8b 55 f4             	mov    -0xc(%ebp),%edx
80109f82:	8b 45 14             	mov    0x14(%ebp),%eax
80109f85:	89 10                	mov    %edx,(%eax)
  tcp_fin();
80109f87:	e8 75 ff ff ff       	call   80109f01 <tcp_fin>
}
80109f8c:	90                   	nop
80109f8d:	c9                   	leave  
80109f8e:	c3                   	ret    

80109f8f <http_strcpy>:

int http_strcpy(char *dst,const char *src,int start_index){
80109f8f:	55                   	push   %ebp
80109f90:	89 e5                	mov    %esp,%ebp
80109f92:	83 ec 10             	sub    $0x10,%esp
  int i = 0;
80109f95:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while(src[i]){
80109f9c:	eb 20                	jmp    80109fbe <http_strcpy+0x2f>
    dst[start_index+i] = src[i];
80109f9e:	8b 55 fc             	mov    -0x4(%ebp),%edx
80109fa1:	8b 45 0c             	mov    0xc(%ebp),%eax
80109fa4:	01 d0                	add    %edx,%eax
80109fa6:	8b 4d 10             	mov    0x10(%ebp),%ecx
80109fa9:	8b 55 fc             	mov    -0x4(%ebp),%edx
80109fac:	01 ca                	add    %ecx,%edx
80109fae:	89 d1                	mov    %edx,%ecx
80109fb0:	8b 55 08             	mov    0x8(%ebp),%edx
80109fb3:	01 ca                	add    %ecx,%edx
80109fb5:	0f b6 00             	movzbl (%eax),%eax
80109fb8:	88 02                	mov    %al,(%edx)
    i++;
80109fba:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
  while(src[i]){
80109fbe:	8b 55 fc             	mov    -0x4(%ebp),%edx
80109fc1:	8b 45 0c             	mov    0xc(%ebp),%eax
80109fc4:	01 d0                	add    %edx,%eax
80109fc6:	0f b6 00             	movzbl (%eax),%eax
80109fc9:	84 c0                	test   %al,%al
80109fcb:	75 d1                	jne    80109f9e <http_strcpy+0xf>
  }
  return i;
80109fcd:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
80109fd0:	c9                   	leave  
80109fd1:	c3                   	ret    

80109fd2 <ideinit>:
static int disksize;
static uchar *memdisk;

void
ideinit(void)
{
80109fd2:	55                   	push   %ebp
80109fd3:	89 e5                	mov    %esp,%ebp
  memdisk = _binary_fs_img_start;
80109fd5:	c7 05 70 6f 19 80 a2 	movl   $0x8010f5a2,0x80196f70
80109fdc:	f5 10 80 
  disksize = (uint)_binary_fs_img_size/BSIZE;
80109fdf:	b8 00 d0 07 00       	mov    $0x7d000,%eax
80109fe4:	c1 e8 09             	shr    $0x9,%eax
80109fe7:	a3 6c 6f 19 80       	mov    %eax,0x80196f6c
}
80109fec:	90                   	nop
80109fed:	5d                   	pop    %ebp
80109fee:	c3                   	ret    

80109fef <ideintr>:

// Interrupt handler.
void
ideintr(void)
{
80109fef:	55                   	push   %ebp
80109ff0:	89 e5                	mov    %esp,%ebp
  // no-op
}
80109ff2:	90                   	nop
80109ff3:	5d                   	pop    %ebp
80109ff4:	c3                   	ret    

80109ff5 <iderw>:
// Sync buf with disk.
// If B_DIRTY is set, write buf to disk, clear B_DIRTY, set B_VALID.
// Else if B_VALID is not set, read buf from disk, set B_VALID.
void
iderw(struct buf *b)
{
80109ff5:	55                   	push   %ebp
80109ff6:	89 e5                	mov    %esp,%ebp
80109ff8:	83 ec 18             	sub    $0x18,%esp
  uchar *p;

  if(!holdingsleep(&b->lock))
80109ffb:	8b 45 08             	mov    0x8(%ebp),%eax
80109ffe:	83 c0 0c             	add    $0xc,%eax
8010a001:	83 ec 0c             	sub    $0xc,%esp
8010a004:	50                   	push   %eax
8010a005:	e8 ac a7 ff ff       	call   801047b6 <holdingsleep>
8010a00a:	83 c4 10             	add    $0x10,%esp
8010a00d:	85 c0                	test   %eax,%eax
8010a00f:	75 0d                	jne    8010a01e <iderw+0x29>
    panic("iderw: buf not locked");
8010a011:	83 ec 0c             	sub    $0xc,%esp
8010a014:	68 ea c0 10 80       	push   $0x8010c0ea
8010a019:	e8 8b 65 ff ff       	call   801005a9 <panic>
  if((b->flags & (B_VALID|B_DIRTY)) == B_VALID)
8010a01e:	8b 45 08             	mov    0x8(%ebp),%eax
8010a021:	8b 00                	mov    (%eax),%eax
8010a023:	83 e0 06             	and    $0x6,%eax
8010a026:	83 f8 02             	cmp    $0x2,%eax
8010a029:	75 0d                	jne    8010a038 <iderw+0x43>
    panic("iderw: nothing to do");
8010a02b:	83 ec 0c             	sub    $0xc,%esp
8010a02e:	68 00 c1 10 80       	push   $0x8010c100
8010a033:	e8 71 65 ff ff       	call   801005a9 <panic>
  if(b->dev != 1)
8010a038:	8b 45 08             	mov    0x8(%ebp),%eax
8010a03b:	8b 40 04             	mov    0x4(%eax),%eax
8010a03e:	83 f8 01             	cmp    $0x1,%eax
8010a041:	74 0d                	je     8010a050 <iderw+0x5b>
    panic("iderw: request not for disk 1");
8010a043:	83 ec 0c             	sub    $0xc,%esp
8010a046:	68 15 c1 10 80       	push   $0x8010c115
8010a04b:	e8 59 65 ff ff       	call   801005a9 <panic>
  if(b->blockno >= disksize)
8010a050:	8b 45 08             	mov    0x8(%ebp),%eax
8010a053:	8b 40 08             	mov    0x8(%eax),%eax
8010a056:	8b 15 6c 6f 19 80    	mov    0x80196f6c,%edx
8010a05c:	39 d0                	cmp    %edx,%eax
8010a05e:	72 0d                	jb     8010a06d <iderw+0x78>
    panic("iderw: block out of range");
8010a060:	83 ec 0c             	sub    $0xc,%esp
8010a063:	68 33 c1 10 80       	push   $0x8010c133
8010a068:	e8 3c 65 ff ff       	call   801005a9 <panic>

  p = memdisk + b->blockno*BSIZE;
8010a06d:	8b 15 70 6f 19 80    	mov    0x80196f70,%edx
8010a073:	8b 45 08             	mov    0x8(%ebp),%eax
8010a076:	8b 40 08             	mov    0x8(%eax),%eax
8010a079:	c1 e0 09             	shl    $0x9,%eax
8010a07c:	01 d0                	add    %edx,%eax
8010a07e:	89 45 f4             	mov    %eax,-0xc(%ebp)

  if(b->flags & B_DIRTY){
8010a081:	8b 45 08             	mov    0x8(%ebp),%eax
8010a084:	8b 00                	mov    (%eax),%eax
8010a086:	83 e0 04             	and    $0x4,%eax
8010a089:	85 c0                	test   %eax,%eax
8010a08b:	74 2b                	je     8010a0b8 <iderw+0xc3>
    b->flags &= ~B_DIRTY;
8010a08d:	8b 45 08             	mov    0x8(%ebp),%eax
8010a090:	8b 00                	mov    (%eax),%eax
8010a092:	83 e0 fb             	and    $0xfffffffb,%eax
8010a095:	89 c2                	mov    %eax,%edx
8010a097:	8b 45 08             	mov    0x8(%ebp),%eax
8010a09a:	89 10                	mov    %edx,(%eax)
    memmove(p, b->data, BSIZE);
8010a09c:	8b 45 08             	mov    0x8(%ebp),%eax
8010a09f:	83 c0 5c             	add    $0x5c,%eax
8010a0a2:	83 ec 04             	sub    $0x4,%esp
8010a0a5:	68 00 02 00 00       	push   $0x200
8010a0aa:	50                   	push   %eax
8010a0ab:	ff 75 f4             	push   -0xc(%ebp)
8010a0ae:	e8 c9 aa ff ff       	call   80104b7c <memmove>
8010a0b3:	83 c4 10             	add    $0x10,%esp
8010a0b6:	eb 1a                	jmp    8010a0d2 <iderw+0xdd>
  } else
    memmove(b->data, p, BSIZE);
8010a0b8:	8b 45 08             	mov    0x8(%ebp),%eax
8010a0bb:	83 c0 5c             	add    $0x5c,%eax
8010a0be:	83 ec 04             	sub    $0x4,%esp
8010a0c1:	68 00 02 00 00       	push   $0x200
8010a0c6:	ff 75 f4             	push   -0xc(%ebp)
8010a0c9:	50                   	push   %eax
8010a0ca:	e8 ad aa ff ff       	call   80104b7c <memmove>
8010a0cf:	83 c4 10             	add    $0x10,%esp
  b->flags |= B_VALID;
8010a0d2:	8b 45 08             	mov    0x8(%ebp),%eax
8010a0d5:	8b 00                	mov    (%eax),%eax
8010a0d7:	83 c8 02             	or     $0x2,%eax
8010a0da:	89 c2                	mov    %eax,%edx
8010a0dc:	8b 45 08             	mov    0x8(%ebp),%eax
8010a0df:	89 10                	mov    %edx,(%eax)
}
8010a0e1:	90                   	nop
8010a0e2:	c9                   	leave  
8010a0e3:	c3                   	ret    
