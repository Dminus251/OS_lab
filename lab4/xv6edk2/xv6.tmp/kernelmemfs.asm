
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
8010006f:	68 a0 a1 10 80       	push   $0x8010a1a0
80100074:	68 00 d0 18 80       	push   $0x8018d000
80100079:	e8 3a 48 00 00       	call   801048b8 <initlock>
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
801000bd:	68 a7 a1 10 80       	push   $0x8010a1a7
801000c2:	50                   	push   %eax
801000c3:	e8 93 46 00 00       	call   8010475b <initsleeplock>
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
80100101:	e8 d4 47 00 00       	call   801048da <acquire>
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
80100140:	e8 03 48 00 00       	call   80104948 <release>
80100145:	83 c4 10             	add    $0x10,%esp
      acquiresleep(&b->lock);
80100148:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010014b:	83 c0 0c             	add    $0xc,%eax
8010014e:	83 ec 0c             	sub    $0xc,%esp
80100151:	50                   	push   %eax
80100152:	e8 40 46 00 00       	call   80104797 <acquiresleep>
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
801001c1:	e8 82 47 00 00       	call   80104948 <release>
801001c6:	83 c4 10             	add    $0x10,%esp
      acquiresleep(&b->lock);
801001c9:	8b 45 f4             	mov    -0xc(%ebp),%eax
801001cc:	83 c0 0c             	add    $0xc,%eax
801001cf:	83 ec 0c             	sub    $0xc,%esp
801001d2:	50                   	push   %eax
801001d3:	e8 bf 45 00 00       	call   80104797 <acquiresleep>
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
801001f5:	68 ae a1 10 80       	push   $0x8010a1ae
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
8010022d:	e8 68 9e 00 00       	call   8010a09a <iderw>
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
8010024a:	e8 fa 45 00 00       	call   80104849 <holdingsleep>
8010024f:	83 c4 10             	add    $0x10,%esp
80100252:	85 c0                	test   %eax,%eax
80100254:	75 0d                	jne    80100263 <bwrite+0x29>
    panic("bwrite");
80100256:	83 ec 0c             	sub    $0xc,%esp
80100259:	68 bf a1 10 80       	push   $0x8010a1bf
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
80100278:	e8 1d 9e 00 00       	call   8010a09a <iderw>
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
80100293:	e8 b1 45 00 00       	call   80104849 <holdingsleep>
80100298:	83 c4 10             	add    $0x10,%esp
8010029b:	85 c0                	test   %eax,%eax
8010029d:	75 0d                	jne    801002ac <brelse+0x29>
    panic("brelse");
8010029f:	83 ec 0c             	sub    $0xc,%esp
801002a2:	68 c6 a1 10 80       	push   $0x8010a1c6
801002a7:	e8 fd 02 00 00       	call   801005a9 <panic>

  releasesleep(&b->lock);
801002ac:	8b 45 08             	mov    0x8(%ebp),%eax
801002af:	83 c0 0c             	add    $0xc,%eax
801002b2:	83 ec 0c             	sub    $0xc,%esp
801002b5:	50                   	push   %eax
801002b6:	e8 40 45 00 00       	call   801047fb <releasesleep>
801002bb:	83 c4 10             	add    $0x10,%esp

  acquire(&bcache.lock);
801002be:	83 ec 0c             	sub    $0xc,%esp
801002c1:	68 00 d0 18 80       	push   $0x8018d000
801002c6:	e8 0f 46 00 00       	call   801048da <acquire>
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
80100336:	e8 0d 46 00 00       	call   80104948 <release>
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
80100410:	e8 c5 44 00 00       	call   801048da <acquire>
80100415:	83 c4 10             	add    $0x10,%esp

  if (fmt == 0)
80100418:	8b 45 08             	mov    0x8(%ebp),%eax
8010041b:	85 c0                	test   %eax,%eax
8010041d:	75 0d                	jne    8010042c <cprintf+0x38>
    panic("null fmt");
8010041f:	83 ec 0c             	sub    $0xc,%esp
80100422:	68 cd a1 10 80       	push   $0x8010a1cd
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
80100510:	c7 45 ec d6 a1 10 80 	movl   $0x8010a1d6,-0x14(%ebp)
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
8010059e:	e8 a5 43 00 00       	call   80104948 <release>
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
801005c7:	68 dd a1 10 80       	push   $0x8010a1dd
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
801005e6:	68 f1 a1 10 80       	push   $0x8010a1f1
801005eb:	e8 04 fe ff ff       	call   801003f4 <cprintf>
801005f0:	83 c4 10             	add    $0x10,%esp
  getcallerpcs(&s, pcs);
801005f3:	83 ec 08             	sub    $0x8,%esp
801005f6:	8d 45 cc             	lea    -0x34(%ebp),%eax
801005f9:	50                   	push   %eax
801005fa:	8d 45 08             	lea    0x8(%ebp),%eax
801005fd:	50                   	push   %eax
801005fe:	e8 97 43 00 00       	call   8010499a <getcallerpcs>
80100603:	83 c4 10             	add    $0x10,%esp
  for(i=0; i<10; i++)
80100606:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
8010060d:	eb 1c                	jmp    8010062b <panic+0x82>
    cprintf(" %p", pcs[i]);
8010060f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100612:	8b 44 85 cc          	mov    -0x34(%ebp,%eax,4),%eax
80100616:	83 ec 08             	sub    $0x8,%esp
80100619:	50                   	push   %eax
8010061a:	68 f3 a1 10 80       	push   $0x8010a1f3
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
801006a0:	e8 4c 79 00 00       	call   80107ff1 <graphic_scroll_up>
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
801006f3:	e8 f9 78 00 00       	call   80107ff1 <graphic_scroll_up>
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
80100757:	e8 00 79 00 00       	call   8010805c <font_render>
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
80100793:	e8 d0 5c 00 00       	call   80106468 <uartputc>
80100798:	83 c4 10             	add    $0x10,%esp
8010079b:	83 ec 0c             	sub    $0xc,%esp
8010079e:	6a 20                	push   $0x20
801007a0:	e8 c3 5c 00 00       	call   80106468 <uartputc>
801007a5:	83 c4 10             	add    $0x10,%esp
801007a8:	83 ec 0c             	sub    $0xc,%esp
801007ab:	6a 08                	push   $0x8
801007ad:	e8 b6 5c 00 00       	call   80106468 <uartputc>
801007b2:	83 c4 10             	add    $0x10,%esp
801007b5:	eb 0e                	jmp    801007c5 <consputc+0x56>
  } else {
    uartputc(c);
801007b7:	83 ec 0c             	sub    $0xc,%esp
801007ba:	ff 75 08             	push   0x8(%ebp)
801007bd:	e8 a6 5c 00 00       	call   80106468 <uartputc>
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
801007eb:	e8 ea 40 00 00       	call   801048da <acquire>
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
8010093f:	e8 62 3c 00 00       	call   801045a6 <wakeup>
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
80100962:	e8 e1 3f 00 00       	call   80104948 <release>
80100967:	83 c4 10             	add    $0x10,%esp
  if(doprocdump) {
8010096a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
8010096e:	74 05                	je     80100975 <consoleintr+0x19f>
    procdump();  // now call procdump() wo. cons.lock held
80100970:	e8 ec 3c 00 00       	call   80104661 <procdump>
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
8010099a:	e8 3b 3f 00 00       	call   801048da <acquire>
8010099f:	83 c4 10             	add    $0x10,%esp
  while(n > 0){
801009a2:	e9 ab 00 00 00       	jmp    80100a52 <consoleread+0xda>
    while(input.r == input.w){
      if(myproc()->killed){
801009a7:	e8 6a 32 00 00       	call   80103c16 <myproc>
801009ac:	8b 40 24             	mov    0x24(%eax),%eax
801009af:	85 c0                	test   %eax,%eax
801009b1:	74 28                	je     801009db <consoleread+0x63>
        release(&cons.lock);
801009b3:	83 ec 0c             	sub    $0xc,%esp
801009b6:	68 00 1a 19 80       	push   $0x80191a00
801009bb:	e8 88 3f 00 00       	call   80104948 <release>
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
801009e8:	e8 d2 3a 00 00       	call   801044bf <sleep>
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
80100a66:	e8 dd 3e 00 00       	call   80104948 <release>
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
80100aa2:	e8 33 3e 00 00       	call   801048da <acquire>
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
80100ae4:	e8 5f 3e 00 00       	call   80104948 <release>
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
80100b12:	68 f7 a1 10 80       	push   $0x8010a1f7
80100b17:	68 00 1a 19 80       	push   $0x80191a00
80100b1c:	e8 97 3d 00 00       	call   801048b8 <initlock>
80100b21:	83 c4 10             	add    $0x10,%esp

  devsw[CONSOLE].write = consolewrite;
80100b24:	c7 05 4c 1a 19 80 86 	movl   $0x80100a86,0x80191a4c
80100b2b:	0a 10 80 
  devsw[CONSOLE].read = consoleread;
80100b2e:	c7 05 48 1a 19 80 78 	movl   $0x80100978,0x80191a48
80100b35:	09 10 80 
  
  char *p;
  for(p="Starting XV6_UEFI...\n"; *p; p++)
80100b38:	c7 45 f4 ff a1 10 80 	movl   $0x8010a1ff,-0xc(%ebp)
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
80100b89:	e8 88 30 00 00       	call   80103c16 <myproc>
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
80100bb5:	68 15 a2 10 80       	push   $0x8010a215
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
80100c11:	e8 4e 68 00 00       	call   80107464 <setupkvm>
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
80100cb7:	e8 a1 6b 00 00       	call   8010785d <allocuvm>
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
80100cfd:	e8 8e 6a 00 00       	call   80107790 <loaduvm>
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
80100d6c:	e8 ec 6a 00 00       	call   8010785d <allocuvm>
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
80100d90:	e8 2a 6d 00 00       	call   80107abf <clearpteu>
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
80100dc9:	e8 d0 3f 00 00       	call   80104d9e <strlen>
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
80100df6:	e8 a3 3f 00 00       	call   80104d9e <strlen>
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
80100e1c:	e8 3d 6e 00 00       	call   80107c5e <copyout>
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
80100eb8:	e8 a1 6d 00 00       	call   80107c5e <copyout>
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
80100f06:	e8 48 3e 00 00       	call   80104d53 <safestrcpy>
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
80100f49:	e8 33 66 00 00       	call   80107581 <switchuvm>
80100f4e:	83 c4 10             	add    $0x10,%esp
  freevm(oldpgdir);
80100f51:	83 ec 0c             	sub    $0xc,%esp
80100f54:	ff 75 cc             	push   -0x34(%ebp)
80100f57:	e8 ca 6a 00 00       	call   80107a26 <freevm>
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
80100f97:	e8 8a 6a 00 00       	call   80107a26 <freevm>
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
80100fc8:	68 21 a2 10 80       	push   $0x8010a221
80100fcd:	68 a0 1a 19 80       	push   $0x80191aa0
80100fd2:	e8 e1 38 00 00       	call   801048b8 <initlock>
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
80100feb:	e8 ea 38 00 00       	call   801048da <acquire>
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
80101018:	e8 2b 39 00 00       	call   80104948 <release>
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
8010103b:	e8 08 39 00 00       	call   80104948 <release>
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
80101058:	e8 7d 38 00 00       	call   801048da <acquire>
8010105d:	83 c4 10             	add    $0x10,%esp
  if(f->ref < 1)
80101060:	8b 45 08             	mov    0x8(%ebp),%eax
80101063:	8b 40 04             	mov    0x4(%eax),%eax
80101066:	85 c0                	test   %eax,%eax
80101068:	7f 0d                	jg     80101077 <filedup+0x2d>
    panic("filedup");
8010106a:	83 ec 0c             	sub    $0xc,%esp
8010106d:	68 28 a2 10 80       	push   $0x8010a228
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
8010108e:	e8 b5 38 00 00       	call   80104948 <release>
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
801010a9:	e8 2c 38 00 00       	call   801048da <acquire>
801010ae:	83 c4 10             	add    $0x10,%esp
  if(f->ref < 1)
801010b1:	8b 45 08             	mov    0x8(%ebp),%eax
801010b4:	8b 40 04             	mov    0x4(%eax),%eax
801010b7:	85 c0                	test   %eax,%eax
801010b9:	7f 0d                	jg     801010c8 <fileclose+0x2d>
    panic("fileclose");
801010bb:	83 ec 0c             	sub    $0xc,%esp
801010be:	68 30 a2 10 80       	push   $0x8010a230
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
801010e9:	e8 5a 38 00 00       	call   80104948 <release>
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
80101137:	e8 0c 38 00 00       	call   80104948 <release>
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
80101286:	68 3a a2 10 80       	push   $0x8010a23a
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
80101389:	68 43 a2 10 80       	push   $0x8010a243
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
801013bf:	68 53 a2 10 80       	push   $0x8010a253
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
801013f7:	e8 13 38 00 00       	call   80104c0f <memmove>
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
8010143d:	e8 0e 37 00 00       	call   80104b50 <memset>
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
8010159c:	68 60 a2 10 80       	push   $0x8010a260
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
80101627:	68 76 a2 10 80       	push   $0x8010a276
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
8010168b:	68 89 a2 10 80       	push   $0x8010a289
80101690:	68 60 24 19 80       	push   $0x80192460
80101695:	e8 1e 32 00 00       	call   801048b8 <initlock>
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
801016c1:	68 90 a2 10 80       	push   $0x8010a290
801016c6:	50                   	push   %eax
801016c7:	e8 8f 30 00 00       	call   8010475b <initsleeplock>
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
80101720:	68 98 a2 10 80       	push   $0x8010a298
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
80101799:	e8 b2 33 00 00       	call   80104b50 <memset>
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
80101801:	68 eb a2 10 80       	push   $0x8010a2eb
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
801018a7:	e8 63 33 00 00       	call   80104c0f <memmove>
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
801018dc:	e8 f9 2f 00 00       	call   801048da <acquire>
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
8010192a:	e8 19 30 00 00       	call   80104948 <release>
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
80101966:	68 fd a2 10 80       	push   $0x8010a2fd
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
801019a3:	e8 a0 2f 00 00       	call   80104948 <release>
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
801019be:	e8 17 2f 00 00       	call   801048da <acquire>
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
801019dd:	e8 66 2f 00 00       	call   80104948 <release>
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
80101a03:	68 0d a3 10 80       	push   $0x8010a30d
80101a08:	e8 9c eb ff ff       	call   801005a9 <panic>

  acquiresleep(&ip->lock);
80101a0d:	8b 45 08             	mov    0x8(%ebp),%eax
80101a10:	83 c0 0c             	add    $0xc,%eax
80101a13:	83 ec 0c             	sub    $0xc,%esp
80101a16:	50                   	push   %eax
80101a17:	e8 7b 2d 00 00       	call   80104797 <acquiresleep>
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
80101ac1:	e8 49 31 00 00       	call   80104c0f <memmove>
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
80101af0:	68 13 a3 10 80       	push   $0x8010a313
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
80101b13:	e8 31 2d 00 00       	call   80104849 <holdingsleep>
80101b18:	83 c4 10             	add    $0x10,%esp
80101b1b:	85 c0                	test   %eax,%eax
80101b1d:	74 0a                	je     80101b29 <iunlock+0x2c>
80101b1f:	8b 45 08             	mov    0x8(%ebp),%eax
80101b22:	8b 40 08             	mov    0x8(%eax),%eax
80101b25:	85 c0                	test   %eax,%eax
80101b27:	7f 0d                	jg     80101b36 <iunlock+0x39>
    panic("iunlock");
80101b29:	83 ec 0c             	sub    $0xc,%esp
80101b2c:	68 22 a3 10 80       	push   $0x8010a322
80101b31:	e8 73 ea ff ff       	call   801005a9 <panic>

  releasesleep(&ip->lock);
80101b36:	8b 45 08             	mov    0x8(%ebp),%eax
80101b39:	83 c0 0c             	add    $0xc,%eax
80101b3c:	83 ec 0c             	sub    $0xc,%esp
80101b3f:	50                   	push   %eax
80101b40:	e8 b6 2c 00 00       	call   801047fb <releasesleep>
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
80101b5b:	e8 37 2c 00 00       	call   80104797 <acquiresleep>
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
80101b81:	e8 54 2d 00 00       	call   801048da <acquire>
80101b86:	83 c4 10             	add    $0x10,%esp
    int r = ip->ref;
80101b89:	8b 45 08             	mov    0x8(%ebp),%eax
80101b8c:	8b 40 08             	mov    0x8(%eax),%eax
80101b8f:	89 45 f4             	mov    %eax,-0xc(%ebp)
    release(&icache.lock);
80101b92:	83 ec 0c             	sub    $0xc,%esp
80101b95:	68 60 24 19 80       	push   $0x80192460
80101b9a:	e8 a9 2d 00 00       	call   80104948 <release>
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
80101be1:	e8 15 2c 00 00       	call   801047fb <releasesleep>
80101be6:	83 c4 10             	add    $0x10,%esp

  acquire(&icache.lock);
80101be9:	83 ec 0c             	sub    $0xc,%esp
80101bec:	68 60 24 19 80       	push   $0x80192460
80101bf1:	e8 e4 2c 00 00       	call   801048da <acquire>
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
80101c10:	e8 33 2d 00 00       	call   80104948 <release>
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
80101d54:	68 2a a3 10 80       	push   $0x8010a32a
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
80101ff2:	e8 18 2c 00 00       	call   80104c0f <memmove>
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
80102142:	e8 c8 2a 00 00       	call   80104c0f <memmove>
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
801021c2:	e8 de 2a 00 00       	call   80104ca5 <strncmp>
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
801021e2:	68 3d a3 10 80       	push   $0x8010a33d
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
80102211:	68 4f a3 10 80       	push   $0x8010a34f
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
801022e6:	68 5e a3 10 80       	push   $0x8010a35e
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
80102321:	e8 d5 29 00 00       	call   80104cfb <strncpy>
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
8010234d:	68 6b a3 10 80       	push   $0x8010a36b
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
801023bf:	e8 4b 28 00 00       	call   80104c0f <memmove>
801023c4:	83 c4 10             	add    $0x10,%esp
801023c7:	eb 26                	jmp    801023ef <skipelem+0x91>
  else {
    memmove(name, s, len);
801023c9:	8b 45 f0             	mov    -0x10(%ebp),%eax
801023cc:	83 ec 04             	sub    $0x4,%esp
801023cf:	50                   	push   %eax
801023d0:	ff 75 f4             	push   -0xc(%ebp)
801023d3:	ff 75 0c             	push   0xc(%ebp)
801023d6:	e8 34 28 00 00       	call   80104c0f <memmove>
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
80102425:	e8 ec 17 00 00       	call   80103c16 <myproc>
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
801025cd:	68 74 a3 10 80       	push   $0x8010a374
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
80102674:	68 a6 a3 10 80       	push   $0x8010a3a6
80102679:	68 c0 40 19 80       	push   $0x801940c0
8010267e:	e8 35 22 00 00       	call   801048b8 <initlock>
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
80102733:	68 ab a3 10 80       	push   $0x8010a3ab
80102738:	e8 6c de ff ff       	call   801005a9 <panic>

  // Fill with junk to catch dangling refs.
  memset(v, 1, PGSIZE);
8010273d:	83 ec 04             	sub    $0x4,%esp
80102740:	68 00 10 00 00       	push   $0x1000
80102745:	6a 01                	push   $0x1
80102747:	ff 75 08             	push   0x8(%ebp)
8010274a:	e8 01 24 00 00       	call   80104b50 <memset>
8010274f:	83 c4 10             	add    $0x10,%esp

  if(kmem.use_lock)
80102752:	a1 f4 40 19 80       	mov    0x801940f4,%eax
80102757:	85 c0                	test   %eax,%eax
80102759:	74 10                	je     8010276b <kfree+0x65>
    acquire(&kmem.lock);
8010275b:	83 ec 0c             	sub    $0xc,%esp
8010275e:	68 c0 40 19 80       	push   $0x801940c0
80102763:	e8 72 21 00 00       	call   801048da <acquire>
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
80102795:	e8 ae 21 00 00       	call   80104948 <release>
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
801027b7:	e8 1e 21 00 00       	call   801048da <acquire>
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
801027e8:	e8 5b 21 00 00       	call   80104948 <release>
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
80102d12:	e8 a0 1e 00 00       	call   80104bb7 <memcmp>
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
80102e26:	68 b1 a3 10 80       	push   $0x8010a3b1
80102e2b:	68 20 41 19 80       	push   $0x80194120
80102e30:	e8 83 1a 00 00       	call   801048b8 <initlock>
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
80102edb:	e8 2f 1d 00 00       	call   80104c0f <memmove>
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
8010304a:	e8 8b 18 00 00       	call   801048da <acquire>
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
80103068:	e8 52 14 00 00       	call   801044bf <sleep>
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
8010309d:	e8 1d 14 00 00       	call   801044bf <sleep>
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
801030bc:	e8 87 18 00 00       	call   80104948 <release>
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
801030dd:	e8 f8 17 00 00       	call   801048da <acquire>
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
801030fe:	68 b5 a3 10 80       	push   $0x8010a3b5
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
8010312c:	e8 75 14 00 00       	call   801045a6 <wakeup>
80103131:	83 c4 10             	add    $0x10,%esp
  }
  release(&log.lock);
80103134:	83 ec 0c             	sub    $0xc,%esp
80103137:	68 20 41 19 80       	push   $0x80194120
8010313c:	e8 07 18 00 00       	call   80104948 <release>
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
80103157:	e8 7e 17 00 00       	call   801048da <acquire>
8010315c:	83 c4 10             	add    $0x10,%esp
    log.committing = 0;
8010315f:	c7 05 60 41 19 80 00 	movl   $0x0,0x80194160
80103166:	00 00 00 
    wakeup(&log);
80103169:	83 ec 0c             	sub    $0xc,%esp
8010316c:	68 20 41 19 80       	push   $0x80194120
80103171:	e8 30 14 00 00       	call   801045a6 <wakeup>
80103176:	83 c4 10             	add    $0x10,%esp
    release(&log.lock);
80103179:	83 ec 0c             	sub    $0xc,%esp
8010317c:	68 20 41 19 80       	push   $0x80194120
80103181:	e8 c2 17 00 00       	call   80104948 <release>
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
801031fd:	e8 0d 1a 00 00       	call   80104c0f <memmove>
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
8010329a:	68 c4 a3 10 80       	push   $0x8010a3c4
8010329f:	e8 05 d3 ff ff       	call   801005a9 <panic>
  if (log.outstanding < 1)
801032a4:	a1 5c 41 19 80       	mov    0x8019415c,%eax
801032a9:	85 c0                	test   %eax,%eax
801032ab:	7f 0d                	jg     801032ba <log_write+0x45>
    panic("log_write outside of trans");
801032ad:	83 ec 0c             	sub    $0xc,%esp
801032b0:	68 da a3 10 80       	push   $0x8010a3da
801032b5:	e8 ef d2 ff ff       	call   801005a9 <panic>

  acquire(&log.lock);
801032ba:	83 ec 0c             	sub    $0xc,%esp
801032bd:	68 20 41 19 80       	push   $0x80194120
801032c2:	e8 13 16 00 00       	call   801048da <acquire>
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
80103340:	e8 03 16 00 00       	call   80104948 <release>
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
80103376:	e8 bb 4b 00 00       	call   80107f36 <graphic_init>
  kinit1(end, P2V(4*1024*1024)); // phys page allocator
8010337b:	83 ec 08             	sub    $0x8,%esp
8010337e:	68 00 00 40 80       	push   $0x80400000
80103383:	68 00 80 19 80       	push   $0x80198000
80103388:	e8 de f2 ff ff       	call   8010266b <kinit1>
8010338d:	83 c4 10             	add    $0x10,%esp
  kvmalloc();      // kernel page table
80103390:	e8 bb 41 00 00       	call   80107550 <kvmalloc>
  mpinit_uefi();
80103395:	e8 62 49 00 00       	call   80107cfc <mpinit_uefi>
  lapicinit();     // interrupt controller
8010339a:	e8 3c f6 ff ff       	call   801029db <lapicinit>
  seginit();       // segment descriptors
8010339f:	e8 44 3c 00 00       	call   80106fe8 <seginit>
  picinit();    // disable pic
801033a4:	e8 9d 01 00 00       	call   80103546 <picinit>
  ioapicinit();    // another interrupt controller
801033a9:	e8 d8 f1 ff ff       	call   80102586 <ioapicinit>
  consoleinit();   // console hardware
801033ae:	e8 4c d7 ff ff       	call   80100aff <consoleinit>
  uartinit();      // serial port
801033b3:	e8 c9 2f 00 00       	call   80106381 <uartinit>
  pinit();         // process table
801033b8:	e8 a8 07 00 00       	call   80103b65 <pinit>
  tvinit();        // trap vectors
801033bd:	e8 90 2b 00 00       	call   80105f52 <tvinit>
  binit();         // buffer cache
801033c2:	e8 9f cc ff ff       	call   80100066 <binit>
  fileinit();      // file table
801033c7:	e8 f3 db ff ff       	call   80100fbf <fileinit>
  ideinit();       // disk 
801033cc:	e8 a6 6c 00 00       	call   8010a077 <ideinit>
  startothers();   // start other processors
801033d1:	e8 8a 00 00 00       	call   80103460 <startothers>
  kinit2(P2V(4*1024*1024), P2V(PHYSTOP)); // must come after startothers()
801033d6:	83 ec 08             	sub    $0x8,%esp
801033d9:	68 00 00 00 a0       	push   $0xa0000000
801033de:	68 00 00 40 80       	push   $0x80400000
801033e3:	e8 bc f2 ff ff       	call   801026a4 <kinit2>
801033e8:	83 c4 10             	add    $0x10,%esp
  pci_init();
801033eb:	e8 9f 4d 00 00       	call   8010818f <pci_init>
  arp_scan();
801033f0:	e8 d6 5a 00 00       	call   80108ecb <arp_scan>
  //i8254_recv();
  userinit();      // first user process
801033f5:	e8 49 09 00 00       	call   80103d43 <userinit>

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
80103405:	e8 5e 41 00 00       	call   80107568 <switchkvm>
  seginit();
8010340a:	e8 d9 3b 00 00       	call   80106fe8 <seginit>
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
80103420:	e8 5e 07 00 00       	call   80103b83 <cpuid>
80103425:	89 c3                	mov    %eax,%ebx
80103427:	e8 57 07 00 00       	call   80103b83 <cpuid>
8010342c:	83 ec 04             	sub    $0x4,%esp
8010342f:	53                   	push   %ebx
80103430:	50                   	push   %eax
80103431:	68 f5 a3 10 80       	push   $0x8010a3f5
80103436:	e8 b9 cf ff ff       	call   801003f4 <cprintf>
8010343b:	83 c4 10             	add    $0x10,%esp
  idtinit();       // load idt register
8010343e:	e8 85 2c 00 00       	call   801060c8 <idtinit>
  xchg(&(mycpu()->started), 1); // tell startothers() we're up
80103443:	e8 56 07 00 00       	call   80103b9e <mycpu>
80103448:	05 a0 00 00 00       	add    $0xa0,%eax
8010344d:	83 ec 08             	sub    $0x8,%esp
80103450:	6a 01                	push   $0x1
80103452:	50                   	push   %eax
80103453:	e8 f3 fe ff ff       	call   8010334b <xchg>
80103458:	83 c4 10             	add    $0x10,%esp
  scheduler();     // start running processes
8010345b:	e8 6e 0e 00 00       	call   801042ce <scheduler>

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
8010347e:	e8 8c 17 00 00       	call   80104c0f <memmove>
80103483:	83 c4 10             	add    $0x10,%esp

  for(c = cpus; c < cpus+ncpu; c++){
80103486:	c7 45 f4 80 69 19 80 	movl   $0x80196980,-0xc(%ebp)
8010348d:	eb 79                	jmp    80103508 <startothers+0xa8>
    if(c == mycpu()){  // We've started already.
8010348f:	e8 0a 07 00 00       	call   80103b9e <mycpu>
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
80103607:	68 09 a4 10 80       	push   $0x8010a409
8010360c:	50                   	push   %eax
8010360d:	e8 a6 12 00 00       	call   801048b8 <initlock>
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
801036cc:	e8 09 12 00 00       	call   801048da <acquire>
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
801036f3:	e8 ae 0e 00 00       	call   801045a6 <wakeup>
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
80103716:	e8 8b 0e 00 00       	call   801045a6 <wakeup>
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
8010373f:	e8 04 12 00 00       	call   80104948 <release>
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
8010375e:	e8 e5 11 00 00       	call   80104948 <release>
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
80103778:	e8 5d 11 00 00       	call   801048da <acquire>
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
80103799:	e8 78 04 00 00       	call   80103c16 <myproc>
8010379e:	8b 40 24             	mov    0x24(%eax),%eax
801037a1:	85 c0                	test   %eax,%eax
801037a3:	74 19                	je     801037be <pipewrite+0x54>
        release(&p->lock);
801037a5:	8b 45 08             	mov    0x8(%ebp),%eax
801037a8:	83 ec 0c             	sub    $0xc,%esp
801037ab:	50                   	push   %eax
801037ac:	e8 97 11 00 00       	call   80104948 <release>
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
801037ca:	e8 d7 0d 00 00       	call   801045a6 <wakeup>
801037cf:	83 c4 10             	add    $0x10,%esp
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
801037d2:	8b 45 08             	mov    0x8(%ebp),%eax
801037d5:	8b 55 08             	mov    0x8(%ebp),%edx
801037d8:	81 c2 38 02 00 00    	add    $0x238,%edx
801037de:	83 ec 08             	sub    $0x8,%esp
801037e1:	50                   	push   %eax
801037e2:	52                   	push   %edx
801037e3:	e8 d7 0c 00 00       	call   801044bf <sleep>
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
8010384d:	e8 54 0d 00 00       	call   801045a6 <wakeup>
80103852:	83 c4 10             	add    $0x10,%esp
  release(&p->lock);
80103855:	8b 45 08             	mov    0x8(%ebp),%eax
80103858:	83 ec 0c             	sub    $0xc,%esp
8010385b:	50                   	push   %eax
8010385c:	e8 e7 10 00 00       	call   80104948 <release>
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
80103879:	e8 5c 10 00 00       	call   801048da <acquire>
8010387e:	83 c4 10             	add    $0x10,%esp
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
80103881:	eb 3e                	jmp    801038c1 <piperead+0x55>
    if(myproc()->killed){
80103883:	e8 8e 03 00 00       	call   80103c16 <myproc>
80103888:	8b 40 24             	mov    0x24(%eax),%eax
8010388b:	85 c0                	test   %eax,%eax
8010388d:	74 19                	je     801038a8 <piperead+0x3c>
      release(&p->lock);
8010388f:	8b 45 08             	mov    0x8(%ebp),%eax
80103892:	83 ec 0c             	sub    $0xc,%esp
80103895:	50                   	push   %eax
80103896:	e8 ad 10 00 00       	call   80104948 <release>
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
801038b9:	e8 01 0c 00 00       	call   801044bf <sleep>
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
8010394c:	e8 55 0c 00 00       	call   801045a6 <wakeup>
80103951:	83 c4 10             	add    $0x10,%esp
  release(&p->lock);
80103954:	8b 45 08             	mov    0x8(%ebp),%eax
80103957:	83 ec 0c             	sub    $0xc,%esp
8010395a:	50                   	push   %eax
8010395b:	e8 e8 0f 00 00       	call   80104948 <release>
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
extern void forkret(void);
extern void trapret(void);

static void wakeup1(void *chan);

int printpt(int pid) {
8010397f:	55                   	push   %ebp
80103980:	89 e5                	mov    %esp,%ebp
80103982:	83 ec 28             	sub    $0x28,%esp
    struct proc *p = 0; 
80103985:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    //page table에서 pid가 일치하는 프로세스 탐색
    //NPROC은 param.h에 정의됨. 최대 프로세스 수(64)를 뜻함
    for (p = ptable.proc; p < &ptable.proc[NPROC]; p++) {
8010398c:	c7 45 f4 34 42 19 80 	movl   $0x80194234,-0xc(%ebp)
80103993:	eb 0f                	jmp    801039a4 <printpt+0x25>
        if (p->pid == pid) break;
80103995:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103998:	8b 40 10             	mov    0x10(%eax),%eax
8010399b:	39 45 08             	cmp    %eax,0x8(%ebp)
8010399e:	74 0f                	je     801039af <printpt+0x30>
    for (p = ptable.proc; p < &ptable.proc[NPROC]; p++) {
801039a0:	83 45 f4 7c          	addl   $0x7c,-0xc(%ebp)
801039a4:	81 7d f4 34 61 19 80 	cmpl   $0x80196134,-0xc(%ebp)
801039ab:	72 e8                	jb     80103995 <printpt+0x16>
801039ad:	eb 01                	jmp    801039b0 <printpt+0x31>
        if (p->pid == pid) break;
801039af:	90                   	nop
    }
    if (p == 0 || p->pid != pid) return -1;
801039b0:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801039b4:	74 0b                	je     801039c1 <printpt+0x42>
801039b6:	8b 45 f4             	mov    -0xc(%ebp),%eax
801039b9:	8b 40 10             	mov    0x10(%eax),%eax
801039bc:	39 45 08             	cmp    %eax,0x8(%ebp)
801039bf:	74 0a                	je     801039cb <printpt+0x4c>
801039c1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801039c6:	e9 98 01 00 00       	jmp    80103b63 <printpt+0x1e4>

    pde_t *pgdir = p->pgdir;
801039cb:	8b 45 f4             	mov    -0xc(%ebp),%eax
801039ce:	8b 40 04             	mov    0x4(%eax),%eax
801039d1:	89 45 e8             	mov    %eax,-0x18(%ebp)
    cprintf("START PAGE TABLE (pid %d)\n", pid);
801039d4:	83 ec 08             	sub    $0x8,%esp
801039d7:	ff 75 08             	push   0x8(%ebp)
801039da:	68 10 a4 10 80       	push   $0x8010a410
801039df:	e8 10 ca ff ff       	call   801003f4 <cprintf>
801039e4:	83 c4 10             	add    $0x10,%esp

    //페이지 디렉토리 엔트리 순회
    //NPDENTRIES는 페이지 디렉토리 수(1024)의미. mmh.h에 정의됨.
    for (int i = NPDENTRIES; i >= 0 ; i--) {
801039e7:	c7 45 f0 00 04 00 00 	movl   $0x400,-0x10(%ebp)
801039ee:	e9 61 01 00 00       	jmp    80103b54 <printpt+0x1d5>
	//해당 엔트리가 유효한지 (=PTE_P가 있는지) 확인
	//PTE_P는 present bit를 의미. mmu.h에 정의됨
        if (pgdir[i] & PTE_P) {
801039f3:	8b 45 f0             	mov    -0x10(%ebp),%eax
801039f6:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
801039fd:	8b 45 e8             	mov    -0x18(%ebp),%eax
80103a00:	01 d0                	add    %edx,%eax
80103a02:	8b 00                	mov    (%eax),%eax
80103a04:	83 e0 01             	and    $0x1,%eax
80103a07:	85 c0                	test   %eax,%eax
80103a09:	0f 84 41 01 00 00    	je     80103b50 <printpt+0x1d1>

            //P2V는 물리 수로를 가상 주소로 변환. memlayout.h에 정의됨
	    //PTE_ADDR은 page table entry에서 물리 주소를 추출. 
	    //mmu.h에 정의됨
            pte_t *pgtab = (pte_t*)P2V(PTE_ADDR(pgdir[i]));
80103a0f:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103a12:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80103a19:	8b 45 e8             	mov    -0x18(%ebp),%eax
80103a1c:	01 d0                	add    %edx,%eax
80103a1e:	8b 00                	mov    (%eax),%eax
80103a20:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80103a25:	05 00 00 00 80       	add    $0x80000000,%eax
80103a2a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	    
	    //이번엔 page table 순회.
	    //last-level만 출력해야되니까 뒤에서부터 순회하고, 바로 리턴한다.
            for (int j = 0; j < NPTENTRIES; j++) {
80103a2d:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
80103a34:	e9 f3 00 00 00       	jmp    80103b2c <printpt+0x1ad>
                if (pgtab[j] & PTE_P) {
80103a39:	8b 45 ec             	mov    -0x14(%ebp),%eax
80103a3c:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80103a43:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80103a46:	01 d0                	add    %edx,%eax
80103a48:	8b 00                	mov    (%eax),%eax
80103a4a:	83 e0 01             	and    $0x1,%eax
80103a4d:	85 c0                	test   %eax,%eax
80103a4f:	0f 84 d3 00 00 00    	je     80103b28 <printpt+0x1a9>

	    	    //PDXSHIFT는 페이지 디렉토리 인덱스 시프트를 나타냄
                    uint va = (i << PDXSHIFT) | (j << PTXSHIFT);
80103a55:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103a58:	c1 e0 16             	shl    $0x16,%eax
80103a5b:	89 c2                	mov    %eax,%edx
80103a5d:	8b 45 ec             	mov    -0x14(%ebp),%eax
80103a60:	c1 e0 0c             	shl    $0xc,%eax
80103a63:	09 d0                	or     %edx,%eax
80103a65:	89 45 e0             	mov    %eax,-0x20(%ebp)

		    //KERNBASE는 커널 가상 주소 공간의 시작 주소
		    //memlayout.h에 정의됨
                    if (va >= KERNBASE) continue; // 유저 모드 메모리만 출력
80103a68:	8b 45 e0             	mov    -0x20(%ebp),%eax
80103a6b:	85 c0                	test   %eax,%eax
80103a6d:	0f 88 b4 00 00 00    	js     80103b27 <printpt+0x1a8>
                    cprintf("%x P ", va >> PTXSHIFT);
80103a73:	8b 45 e0             	mov    -0x20(%ebp),%eax
80103a76:	c1 e8 0c             	shr    $0xc,%eax
80103a79:	83 ec 08             	sub    $0x8,%esp
80103a7c:	50                   	push   %eax
80103a7d:	68 2b a4 10 80       	push   $0x8010a42b
80103a82:	e8 6d c9 ff ff       	call   801003f4 <cprintf>
80103a87:	83 c4 10             	add    $0x10,%esp
                    if (pgtab[j] & PTE_U) cprintf("U ");
80103a8a:	8b 45 ec             	mov    -0x14(%ebp),%eax
80103a8d:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80103a94:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80103a97:	01 d0                	add    %edx,%eax
80103a99:	8b 00                	mov    (%eax),%eax
80103a9b:	83 e0 04             	and    $0x4,%eax
80103a9e:	85 c0                	test   %eax,%eax
80103aa0:	74 12                	je     80103ab4 <printpt+0x135>
80103aa2:	83 ec 0c             	sub    $0xc,%esp
80103aa5:	68 31 a4 10 80       	push   $0x8010a431
80103aaa:	e8 45 c9 ff ff       	call   801003f4 <cprintf>
80103aaf:	83 c4 10             	add    $0x10,%esp
80103ab2:	eb 10                	jmp    80103ac4 <printpt+0x145>
                    else cprintf("K ");
80103ab4:	83 ec 0c             	sub    $0xc,%esp
80103ab7:	68 34 a4 10 80       	push   $0x8010a434
80103abc:	e8 33 c9 ff ff       	call   801003f4 <cprintf>
80103ac1:	83 c4 10             	add    $0x10,%esp
                    if (pgtab[j] & PTE_W) cprintf("W ");
80103ac4:	8b 45 ec             	mov    -0x14(%ebp),%eax
80103ac7:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80103ace:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80103ad1:	01 d0                	add    %edx,%eax
80103ad3:	8b 00                	mov    (%eax),%eax
80103ad5:	83 e0 02             	and    $0x2,%eax
80103ad8:	85 c0                	test   %eax,%eax
80103ada:	74 12                	je     80103aee <printpt+0x16f>
80103adc:	83 ec 0c             	sub    $0xc,%esp
80103adf:	68 37 a4 10 80       	push   $0x8010a437
80103ae4:	e8 0b c9 ff ff       	call   801003f4 <cprintf>
80103ae9:	83 c4 10             	add    $0x10,%esp
80103aec:	eb 10                	jmp    80103afe <printpt+0x17f>
                    else cprintf("- ");
80103aee:	83 ec 0c             	sub    $0xc,%esp
80103af1:	68 3a a4 10 80       	push   $0x8010a43a
80103af6:	e8 f9 c8 ff ff       	call   801003f4 <cprintf>
80103afb:	83 c4 10             	add    $0x10,%esp
                    cprintf("%x\n", PTE_ADDR(pgtab[j]));
80103afe:	8b 45 ec             	mov    -0x14(%ebp),%eax
80103b01:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80103b08:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80103b0b:	01 d0                	add    %edx,%eax
80103b0d:	8b 00                	mov    (%eax),%eax
80103b0f:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80103b14:	83 ec 08             	sub    $0x8,%esp
80103b17:	50                   	push   %eax
80103b18:	68 3d a4 10 80       	push   $0x8010a43d
80103b1d:	e8 d2 c8 ff ff       	call   801003f4 <cprintf>
80103b22:	83 c4 10             	add    $0x10,%esp
80103b25:	eb 01                	jmp    80103b28 <printpt+0x1a9>
                    if (va >= KERNBASE) continue; // 유저 모드 메모리만 출력
80103b27:	90                   	nop
            for (int j = 0; j < NPTENTRIES; j++) {
80103b28:	83 45 ec 01          	addl   $0x1,-0x14(%ebp)
80103b2c:	81 7d ec ff 03 00 00 	cmpl   $0x3ff,-0x14(%ebp)
80103b33:	0f 8e 00 ff ff ff    	jle    80103a39 <printpt+0xba>
                }
            }
    	    cprintf("END PAGE TABLE\n");
80103b39:	83 ec 0c             	sub    $0xc,%esp
80103b3c:	68 41 a4 10 80       	push   $0x8010a441
80103b41:	e8 ae c8 ff ff       	call   801003f4 <cprintf>
80103b46:	83 c4 10             	add    $0x10,%esp
	    return 0;
80103b49:	b8 00 00 00 00       	mov    $0x0,%eax
80103b4e:	eb 13                	jmp    80103b63 <printpt+0x1e4>
    for (int i = NPDENTRIES; i >= 0 ; i--) {
80103b50:	83 6d f0 01          	subl   $0x1,-0x10(%ebp)
80103b54:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80103b58:	0f 89 95 fe ff ff    	jns    801039f3 <printpt+0x74>
        }
    }
    return 0;
80103b5e:	b8 00 00 00 00       	mov    $0x0,%eax
}
80103b63:	c9                   	leave  
80103b64:	c3                   	ret    

80103b65 <pinit>:


void
pinit(void)
{
80103b65:	55                   	push   %ebp
80103b66:	89 e5                	mov    %esp,%ebp
80103b68:	83 ec 08             	sub    $0x8,%esp
  initlock(&ptable.lock, "ptable");
80103b6b:	83 ec 08             	sub    $0x8,%esp
80103b6e:	68 51 a4 10 80       	push   $0x8010a451
80103b73:	68 00 42 19 80       	push   $0x80194200
80103b78:	e8 3b 0d 00 00       	call   801048b8 <initlock>
80103b7d:	83 c4 10             	add    $0x10,%esp
}
80103b80:	90                   	nop
80103b81:	c9                   	leave  
80103b82:	c3                   	ret    

80103b83 <cpuid>:

// Must be called with interrupts disabled
int
cpuid() {
80103b83:	55                   	push   %ebp
80103b84:	89 e5                	mov    %esp,%ebp
80103b86:	83 ec 08             	sub    $0x8,%esp
  return mycpu()-cpus;
80103b89:	e8 10 00 00 00       	call   80103b9e <mycpu>
80103b8e:	2d 80 69 19 80       	sub    $0x80196980,%eax
80103b93:	c1 f8 04             	sar    $0x4,%eax
80103b96:	69 c0 a3 8b 2e ba    	imul   $0xba2e8ba3,%eax,%eax
}
80103b9c:	c9                   	leave  
80103b9d:	c3                   	ret    

80103b9e <mycpu>:

// Must be called with interrupts disabled to avoid the caller being
// rescheduled between reading lapicid and running through the loop.
struct cpu*
mycpu(void)
{
80103b9e:	55                   	push   %ebp
80103b9f:	89 e5                	mov    %esp,%ebp
80103ba1:	83 ec 18             	sub    $0x18,%esp
  int apicid, i;
  
  if(readeflags()&FL_IF){
80103ba4:	e8 bf fd ff ff       	call   80103968 <readeflags>
80103ba9:	25 00 02 00 00       	and    $0x200,%eax
80103bae:	85 c0                	test   %eax,%eax
80103bb0:	74 0d                	je     80103bbf <mycpu+0x21>
    panic("mycpu called with interrupts enabled\n");
80103bb2:	83 ec 0c             	sub    $0xc,%esp
80103bb5:	68 58 a4 10 80       	push   $0x8010a458
80103bba:	e8 ea c9 ff ff       	call   801005a9 <panic>
  }

  apicid = lapicid();
80103bbf:	e8 36 ef ff ff       	call   80102afa <lapicid>
80103bc4:	89 45 f0             	mov    %eax,-0x10(%ebp)
  // APIC IDs are not guaranteed to be contiguous. Maybe we should have
  // a reverse map, or reserve a register to store &cpus[i].
  for (i = 0; i < ncpu; ++i) {
80103bc7:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80103bce:	eb 2d                	jmp    80103bfd <mycpu+0x5f>
    if (cpus[i].apicid == apicid){
80103bd0:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103bd3:	69 c0 b0 00 00 00    	imul   $0xb0,%eax,%eax
80103bd9:	05 80 69 19 80       	add    $0x80196980,%eax
80103bde:	0f b6 00             	movzbl (%eax),%eax
80103be1:	0f b6 c0             	movzbl %al,%eax
80103be4:	39 45 f0             	cmp    %eax,-0x10(%ebp)
80103be7:	75 10                	jne    80103bf9 <mycpu+0x5b>
      return &cpus[i];
80103be9:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103bec:	69 c0 b0 00 00 00    	imul   $0xb0,%eax,%eax
80103bf2:	05 80 69 19 80       	add    $0x80196980,%eax
80103bf7:	eb 1b                	jmp    80103c14 <mycpu+0x76>
  for (i = 0; i < ncpu; ++i) {
80103bf9:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80103bfd:	a1 40 6c 19 80       	mov    0x80196c40,%eax
80103c02:	39 45 f4             	cmp    %eax,-0xc(%ebp)
80103c05:	7c c9                	jl     80103bd0 <mycpu+0x32>
    }
  }
  panic("unknown apicid\n");
80103c07:	83 ec 0c             	sub    $0xc,%esp
80103c0a:	68 7e a4 10 80       	push   $0x8010a47e
80103c0f:	e8 95 c9 ff ff       	call   801005a9 <panic>
}
80103c14:	c9                   	leave  
80103c15:	c3                   	ret    

80103c16 <myproc>:

// Disable interrupts so that we are not rescheduled
// while reading proc from the cpu structure
struct proc*
myproc(void) {
80103c16:	55                   	push   %ebp
80103c17:	89 e5                	mov    %esp,%ebp
80103c19:	83 ec 18             	sub    $0x18,%esp
  struct cpu *c;
  struct proc *p;
  pushcli();
80103c1c:	e8 24 0e 00 00       	call   80104a45 <pushcli>
  c = mycpu();
80103c21:	e8 78 ff ff ff       	call   80103b9e <mycpu>
80103c26:	89 45 f4             	mov    %eax,-0xc(%ebp)
  p = c->proc;
80103c29:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103c2c:	8b 80 ac 00 00 00    	mov    0xac(%eax),%eax
80103c32:	89 45 f0             	mov    %eax,-0x10(%ebp)
  popcli();
80103c35:	e8 58 0e 00 00       	call   80104a92 <popcli>
  return p;
80103c3a:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
80103c3d:	c9                   	leave  
80103c3e:	c3                   	ret    

80103c3f <allocproc>:
// If found, change state to EMBRYO and initialize
// state required to run in the kernel.
// Otherwise return 0.
static struct proc*
allocproc(void)
{
80103c3f:	55                   	push   %ebp
80103c40:	89 e5                	mov    %esp,%ebp
80103c42:	83 ec 18             	sub    $0x18,%esp
  struct proc *p;
  char *sp;

  acquire(&ptable.lock);
80103c45:	83 ec 0c             	sub    $0xc,%esp
80103c48:	68 00 42 19 80       	push   $0x80194200
80103c4d:	e8 88 0c 00 00       	call   801048da <acquire>
80103c52:	83 c4 10             	add    $0x10,%esp

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103c55:	c7 45 f4 34 42 19 80 	movl   $0x80194234,-0xc(%ebp)
80103c5c:	eb 0e                	jmp    80103c6c <allocproc+0x2d>
    if(p->state == UNUSED){
80103c5e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103c61:	8b 40 0c             	mov    0xc(%eax),%eax
80103c64:	85 c0                	test   %eax,%eax
80103c66:	74 27                	je     80103c8f <allocproc+0x50>
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103c68:	83 45 f4 7c          	addl   $0x7c,-0xc(%ebp)
80103c6c:	81 7d f4 34 61 19 80 	cmpl   $0x80196134,-0xc(%ebp)
80103c73:	72 e9                	jb     80103c5e <allocproc+0x1f>
      goto found;
    }

  release(&ptable.lock);
80103c75:	83 ec 0c             	sub    $0xc,%esp
80103c78:	68 00 42 19 80       	push   $0x80194200
80103c7d:	e8 c6 0c 00 00       	call   80104948 <release>
80103c82:	83 c4 10             	add    $0x10,%esp
  return 0;
80103c85:	b8 00 00 00 00       	mov    $0x0,%eax
80103c8a:	e9 b2 00 00 00       	jmp    80103d41 <allocproc+0x102>
      goto found;
80103c8f:	90                   	nop

found:
  p->state = EMBRYO;
80103c90:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103c93:	c7 40 0c 01 00 00 00 	movl   $0x1,0xc(%eax)
  p->pid = nextpid++;
80103c9a:	a1 00 f0 10 80       	mov    0x8010f000,%eax
80103c9f:	8d 50 01             	lea    0x1(%eax),%edx
80103ca2:	89 15 00 f0 10 80    	mov    %edx,0x8010f000
80103ca8:	8b 55 f4             	mov    -0xc(%ebp),%edx
80103cab:	89 42 10             	mov    %eax,0x10(%edx)

  release(&ptable.lock);
80103cae:	83 ec 0c             	sub    $0xc,%esp
80103cb1:	68 00 42 19 80       	push   $0x80194200
80103cb6:	e8 8d 0c 00 00       	call   80104948 <release>
80103cbb:	83 c4 10             	add    $0x10,%esp


  // Allocate kernel stack.
  if((p->kstack = kalloc()) == 0){
80103cbe:	e8 dd ea ff ff       	call   801027a0 <kalloc>
80103cc3:	8b 55 f4             	mov    -0xc(%ebp),%edx
80103cc6:	89 42 08             	mov    %eax,0x8(%edx)
80103cc9:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103ccc:	8b 40 08             	mov    0x8(%eax),%eax
80103ccf:	85 c0                	test   %eax,%eax
80103cd1:	75 11                	jne    80103ce4 <allocproc+0xa5>
    p->state = UNUSED;
80103cd3:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103cd6:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
    return 0;
80103cdd:	b8 00 00 00 00       	mov    $0x0,%eax
80103ce2:	eb 5d                	jmp    80103d41 <allocproc+0x102>
  }
  sp = p->kstack + KSTACKSIZE;
80103ce4:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103ce7:	8b 40 08             	mov    0x8(%eax),%eax
80103cea:	05 00 10 00 00       	add    $0x1000,%eax
80103cef:	89 45 f0             	mov    %eax,-0x10(%ebp)

  // Leave room for trap frame.
  sp -= sizeof *p->tf;
80103cf2:	83 6d f0 4c          	subl   $0x4c,-0x10(%ebp)
  p->tf = (struct trapframe*)sp;
80103cf6:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103cf9:	8b 55 f0             	mov    -0x10(%ebp),%edx
80103cfc:	89 50 18             	mov    %edx,0x18(%eax)

  // Set up new context to start executing at forkret,
  // which returns to trapret.
  sp -= 4;
80103cff:	83 6d f0 04          	subl   $0x4,-0x10(%ebp)
  *(uint*)sp = (uint)trapret;
80103d03:	ba 0c 5f 10 80       	mov    $0x80105f0c,%edx
80103d08:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103d0b:	89 10                	mov    %edx,(%eax)

  sp -= sizeof *p->context;
80103d0d:	83 6d f0 14          	subl   $0x14,-0x10(%ebp)
  p->context = (struct context*)sp;
80103d11:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103d14:	8b 55 f0             	mov    -0x10(%ebp),%edx
80103d17:	89 50 1c             	mov    %edx,0x1c(%eax)
  memset(p->context, 0, sizeof *p->context);
80103d1a:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103d1d:	8b 40 1c             	mov    0x1c(%eax),%eax
80103d20:	83 ec 04             	sub    $0x4,%esp
80103d23:	6a 14                	push   $0x14
80103d25:	6a 00                	push   $0x0
80103d27:	50                   	push   %eax
80103d28:	e8 23 0e 00 00       	call   80104b50 <memset>
80103d2d:	83 c4 10             	add    $0x10,%esp
  p->context->eip = (uint)forkret;
80103d30:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103d33:	8b 40 1c             	mov    0x1c(%eax),%eax
80103d36:	ba 79 44 10 80       	mov    $0x80104479,%edx
80103d3b:	89 50 10             	mov    %edx,0x10(%eax)

  return p;
80103d3e:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
80103d41:	c9                   	leave  
80103d42:	c3                   	ret    

80103d43 <userinit>:

//PAGEBREAK: 32
// Set up first user process.
void
userinit(void)
{
80103d43:	55                   	push   %ebp
80103d44:	89 e5                	mov    %esp,%ebp
80103d46:	83 ec 18             	sub    $0x18,%esp
  struct proc *p;
  extern char _binary_initcode_start[], _binary_initcode_size[];

  p = allocproc();
80103d49:	e8 f1 fe ff ff       	call   80103c3f <allocproc>
80103d4e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  
  initproc = p;
80103d51:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103d54:	a3 34 61 19 80       	mov    %eax,0x80196134
  if((p->pgdir = setupkvm()) == 0){
80103d59:	e8 06 37 00 00       	call   80107464 <setupkvm>
80103d5e:	8b 55 f4             	mov    -0xc(%ebp),%edx
80103d61:	89 42 04             	mov    %eax,0x4(%edx)
80103d64:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103d67:	8b 40 04             	mov    0x4(%eax),%eax
80103d6a:	85 c0                	test   %eax,%eax
80103d6c:	75 0d                	jne    80103d7b <userinit+0x38>
    panic("userinit: out of memory?");
80103d6e:	83 ec 0c             	sub    $0xc,%esp
80103d71:	68 8e a4 10 80       	push   $0x8010a48e
80103d76:	e8 2e c8 ff ff       	call   801005a9 <panic>
  }
  inituvm(p->pgdir, _binary_initcode_start, (int)_binary_initcode_size);
80103d7b:	ba 2c 00 00 00       	mov    $0x2c,%edx
80103d80:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103d83:	8b 40 04             	mov    0x4(%eax),%eax
80103d86:	83 ec 04             	sub    $0x4,%esp
80103d89:	52                   	push   %edx
80103d8a:	68 ec f4 10 80       	push   $0x8010f4ec
80103d8f:	50                   	push   %eax
80103d90:	e8 8b 39 00 00       	call   80107720 <inituvm>
80103d95:	83 c4 10             	add    $0x10,%esp
  p->sz = PGSIZE;
80103d98:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103d9b:	c7 00 00 10 00 00    	movl   $0x1000,(%eax)
  memset(p->tf, 0, sizeof(*p->tf));
80103da1:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103da4:	8b 40 18             	mov    0x18(%eax),%eax
80103da7:	83 ec 04             	sub    $0x4,%esp
80103daa:	6a 4c                	push   $0x4c
80103dac:	6a 00                	push   $0x0
80103dae:	50                   	push   %eax
80103daf:	e8 9c 0d 00 00       	call   80104b50 <memset>
80103db4:	83 c4 10             	add    $0x10,%esp
  p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
80103db7:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103dba:	8b 40 18             	mov    0x18(%eax),%eax
80103dbd:	66 c7 40 3c 1b 00    	movw   $0x1b,0x3c(%eax)
  p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
80103dc3:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103dc6:	8b 40 18             	mov    0x18(%eax),%eax
80103dc9:	66 c7 40 2c 23 00    	movw   $0x23,0x2c(%eax)
  p->tf->es = p->tf->ds;
80103dcf:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103dd2:	8b 50 18             	mov    0x18(%eax),%edx
80103dd5:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103dd8:	8b 40 18             	mov    0x18(%eax),%eax
80103ddb:	0f b7 52 2c          	movzwl 0x2c(%edx),%edx
80103ddf:	66 89 50 28          	mov    %dx,0x28(%eax)
  p->tf->ss = p->tf->ds;
80103de3:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103de6:	8b 50 18             	mov    0x18(%eax),%edx
80103de9:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103dec:	8b 40 18             	mov    0x18(%eax),%eax
80103def:	0f b7 52 2c          	movzwl 0x2c(%edx),%edx
80103df3:	66 89 50 48          	mov    %dx,0x48(%eax)
  p->tf->eflags = FL_IF;
80103df7:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103dfa:	8b 40 18             	mov    0x18(%eax),%eax
80103dfd:	c7 40 40 00 02 00 00 	movl   $0x200,0x40(%eax)
  p->tf->esp = PGSIZE;
80103e04:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103e07:	8b 40 18             	mov    0x18(%eax),%eax
80103e0a:	c7 40 44 00 10 00 00 	movl   $0x1000,0x44(%eax)
  p->tf->eip = 0;  // beginning of initcode.S
80103e11:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103e14:	8b 40 18             	mov    0x18(%eax),%eax
80103e17:	c7 40 38 00 00 00 00 	movl   $0x0,0x38(%eax)

  safestrcpy(p->name, "initcode", sizeof(p->name));
80103e1e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103e21:	83 c0 6c             	add    $0x6c,%eax
80103e24:	83 ec 04             	sub    $0x4,%esp
80103e27:	6a 10                	push   $0x10
80103e29:	68 a7 a4 10 80       	push   $0x8010a4a7
80103e2e:	50                   	push   %eax
80103e2f:	e8 1f 0f 00 00       	call   80104d53 <safestrcpy>
80103e34:	83 c4 10             	add    $0x10,%esp
  p->cwd = namei("/");
80103e37:	83 ec 0c             	sub    $0xc,%esp
80103e3a:	68 b0 a4 10 80       	push   $0x8010a4b0
80103e3f:	e8 d9 e6 ff ff       	call   8010251d <namei>
80103e44:	83 c4 10             	add    $0x10,%esp
80103e47:	8b 55 f4             	mov    -0xc(%ebp),%edx
80103e4a:	89 42 68             	mov    %eax,0x68(%edx)

  // this assignment to p->state lets other cores
  // run this process. the acquire forces the above
  // writes to be visible, and the lock is also needed
  // because the assignment might not be atomic.
  acquire(&ptable.lock);
80103e4d:	83 ec 0c             	sub    $0xc,%esp
80103e50:	68 00 42 19 80       	push   $0x80194200
80103e55:	e8 80 0a 00 00       	call   801048da <acquire>
80103e5a:	83 c4 10             	add    $0x10,%esp

  p->state = RUNNABLE;
80103e5d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103e60:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)

  release(&ptable.lock);
80103e67:	83 ec 0c             	sub    $0xc,%esp
80103e6a:	68 00 42 19 80       	push   $0x80194200
80103e6f:	e8 d4 0a 00 00       	call   80104948 <release>
80103e74:	83 c4 10             	add    $0x10,%esp
}
80103e77:	90                   	nop
80103e78:	c9                   	leave  
80103e79:	c3                   	ret    

80103e7a <growproc>:

// Grow current process's memory by n bytes.
// Return 0 on success, -1 on failure.
int
growproc(int n)
{
80103e7a:	55                   	push   %ebp
80103e7b:	89 e5                	mov    %esp,%ebp
80103e7d:	83 ec 18             	sub    $0x18,%esp
  uint sz;
  struct proc *curproc = myproc();
80103e80:	e8 91 fd ff ff       	call   80103c16 <myproc>
80103e85:	89 45 f0             	mov    %eax,-0x10(%ebp)

  sz = curproc->sz;
80103e88:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103e8b:	8b 00                	mov    (%eax),%eax
80103e8d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(n > 0){
80103e90:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
80103e94:	7e 2e                	jle    80103ec4 <growproc+0x4a>
    if((sz = allocuvm(curproc->pgdir, sz, sz + n)) == 0)
80103e96:	8b 55 08             	mov    0x8(%ebp),%edx
80103e99:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103e9c:	01 c2                	add    %eax,%edx
80103e9e:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103ea1:	8b 40 04             	mov    0x4(%eax),%eax
80103ea4:	83 ec 04             	sub    $0x4,%esp
80103ea7:	52                   	push   %edx
80103ea8:	ff 75 f4             	push   -0xc(%ebp)
80103eab:	50                   	push   %eax
80103eac:	e8 ac 39 00 00       	call   8010785d <allocuvm>
80103eb1:	83 c4 10             	add    $0x10,%esp
80103eb4:	89 45 f4             	mov    %eax,-0xc(%ebp)
80103eb7:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80103ebb:	75 3b                	jne    80103ef8 <growproc+0x7e>
      return -1;
80103ebd:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80103ec2:	eb 4f                	jmp    80103f13 <growproc+0x99>
  } else if(n < 0){
80103ec4:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
80103ec8:	79 2e                	jns    80103ef8 <growproc+0x7e>
    if((sz = deallocuvm(curproc->pgdir, sz, sz + n)) == 0)
80103eca:	8b 55 08             	mov    0x8(%ebp),%edx
80103ecd:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103ed0:	01 c2                	add    %eax,%edx
80103ed2:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103ed5:	8b 40 04             	mov    0x4(%eax),%eax
80103ed8:	83 ec 04             	sub    $0x4,%esp
80103edb:	52                   	push   %edx
80103edc:	ff 75 f4             	push   -0xc(%ebp)
80103edf:	50                   	push   %eax
80103ee0:	e8 7d 3a 00 00       	call   80107962 <deallocuvm>
80103ee5:	83 c4 10             	add    $0x10,%esp
80103ee8:	89 45 f4             	mov    %eax,-0xc(%ebp)
80103eeb:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80103eef:	75 07                	jne    80103ef8 <growproc+0x7e>
      return -1;
80103ef1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80103ef6:	eb 1b                	jmp    80103f13 <growproc+0x99>
  }
  curproc->sz = sz;
80103ef8:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103efb:	8b 55 f4             	mov    -0xc(%ebp),%edx
80103efe:	89 10                	mov    %edx,(%eax)
  switchuvm(curproc);
80103f00:	83 ec 0c             	sub    $0xc,%esp
80103f03:	ff 75 f0             	push   -0x10(%ebp)
80103f06:	e8 76 36 00 00       	call   80107581 <switchuvm>
80103f0b:	83 c4 10             	add    $0x10,%esp
  return 0;
80103f0e:	b8 00 00 00 00       	mov    $0x0,%eax
}
80103f13:	c9                   	leave  
80103f14:	c3                   	ret    

80103f15 <fork>:
// Create a new process copying p as the parent.
// Sets up stack to return as if from system call.
// Caller must set state of returned proc to RUNNABLE.
int
fork(void)
{
80103f15:	55                   	push   %ebp
80103f16:	89 e5                	mov    %esp,%ebp
80103f18:	57                   	push   %edi
80103f19:	56                   	push   %esi
80103f1a:	53                   	push   %ebx
80103f1b:	83 ec 1c             	sub    $0x1c,%esp
  int i, pid;
  struct proc *np;
  struct proc *curproc = myproc();
80103f1e:	e8 f3 fc ff ff       	call   80103c16 <myproc>
80103f23:	89 45 e0             	mov    %eax,-0x20(%ebp)

  // Allocate process.
  if((np = allocproc()) == 0){
80103f26:	e8 14 fd ff ff       	call   80103c3f <allocproc>
80103f2b:	89 45 dc             	mov    %eax,-0x24(%ebp)
80103f2e:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
80103f32:	75 0a                	jne    80103f3e <fork+0x29>
    return -1;
80103f34:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80103f39:	e9 48 01 00 00       	jmp    80104086 <fork+0x171>
  }

  // Copy process state from proc.
  if((np->pgdir = copyuvm(curproc->pgdir, curproc->sz)) == 0){
80103f3e:	8b 45 e0             	mov    -0x20(%ebp),%eax
80103f41:	8b 10                	mov    (%eax),%edx
80103f43:	8b 45 e0             	mov    -0x20(%ebp),%eax
80103f46:	8b 40 04             	mov    0x4(%eax),%eax
80103f49:	83 ec 08             	sub    $0x8,%esp
80103f4c:	52                   	push   %edx
80103f4d:	50                   	push   %eax
80103f4e:	e8 ad 3b 00 00       	call   80107b00 <copyuvm>
80103f53:	83 c4 10             	add    $0x10,%esp
80103f56:	8b 55 dc             	mov    -0x24(%ebp),%edx
80103f59:	89 42 04             	mov    %eax,0x4(%edx)
80103f5c:	8b 45 dc             	mov    -0x24(%ebp),%eax
80103f5f:	8b 40 04             	mov    0x4(%eax),%eax
80103f62:	85 c0                	test   %eax,%eax
80103f64:	75 30                	jne    80103f96 <fork+0x81>
    kfree(np->kstack);
80103f66:	8b 45 dc             	mov    -0x24(%ebp),%eax
80103f69:	8b 40 08             	mov    0x8(%eax),%eax
80103f6c:	83 ec 0c             	sub    $0xc,%esp
80103f6f:	50                   	push   %eax
80103f70:	e8 91 e7 ff ff       	call   80102706 <kfree>
80103f75:	83 c4 10             	add    $0x10,%esp
    np->kstack = 0;
80103f78:	8b 45 dc             	mov    -0x24(%ebp),%eax
80103f7b:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
    np->state = UNUSED;
80103f82:	8b 45 dc             	mov    -0x24(%ebp),%eax
80103f85:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
    return -1;
80103f8c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80103f91:	e9 f0 00 00 00       	jmp    80104086 <fork+0x171>
  }
  np->sz = curproc->sz;
80103f96:	8b 45 e0             	mov    -0x20(%ebp),%eax
80103f99:	8b 10                	mov    (%eax),%edx
80103f9b:	8b 45 dc             	mov    -0x24(%ebp),%eax
80103f9e:	89 10                	mov    %edx,(%eax)
  np->parent = curproc;
80103fa0:	8b 45 dc             	mov    -0x24(%ebp),%eax
80103fa3:	8b 55 e0             	mov    -0x20(%ebp),%edx
80103fa6:	89 50 14             	mov    %edx,0x14(%eax)
  *np->tf = *curproc->tf;
80103fa9:	8b 45 e0             	mov    -0x20(%ebp),%eax
80103fac:	8b 48 18             	mov    0x18(%eax),%ecx
80103faf:	8b 45 dc             	mov    -0x24(%ebp),%eax
80103fb2:	8b 40 18             	mov    0x18(%eax),%eax
80103fb5:	89 c2                	mov    %eax,%edx
80103fb7:	89 cb                	mov    %ecx,%ebx
80103fb9:	b8 13 00 00 00       	mov    $0x13,%eax
80103fbe:	89 d7                	mov    %edx,%edi
80103fc0:	89 de                	mov    %ebx,%esi
80103fc2:	89 c1                	mov    %eax,%ecx
80103fc4:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)

  // Clear %eax so that fork returns 0 in the child.
  np->tf->eax = 0;
80103fc6:	8b 45 dc             	mov    -0x24(%ebp),%eax
80103fc9:	8b 40 18             	mov    0x18(%eax),%eax
80103fcc:	c7 40 1c 00 00 00 00 	movl   $0x0,0x1c(%eax)

  for(i = 0; i < NOFILE; i++)
80103fd3:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
80103fda:	eb 3b                	jmp    80104017 <fork+0x102>
    if(curproc->ofile[i])
80103fdc:	8b 45 e0             	mov    -0x20(%ebp),%eax
80103fdf:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80103fe2:	83 c2 08             	add    $0x8,%edx
80103fe5:	8b 44 90 08          	mov    0x8(%eax,%edx,4),%eax
80103fe9:	85 c0                	test   %eax,%eax
80103feb:	74 26                	je     80104013 <fork+0xfe>
      np->ofile[i] = filedup(curproc->ofile[i]);
80103fed:	8b 45 e0             	mov    -0x20(%ebp),%eax
80103ff0:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80103ff3:	83 c2 08             	add    $0x8,%edx
80103ff6:	8b 44 90 08          	mov    0x8(%eax,%edx,4),%eax
80103ffa:	83 ec 0c             	sub    $0xc,%esp
80103ffd:	50                   	push   %eax
80103ffe:	e8 47 d0 ff ff       	call   8010104a <filedup>
80104003:	83 c4 10             	add    $0x10,%esp
80104006:	8b 55 dc             	mov    -0x24(%ebp),%edx
80104009:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
8010400c:	83 c1 08             	add    $0x8,%ecx
8010400f:	89 44 8a 08          	mov    %eax,0x8(%edx,%ecx,4)
  for(i = 0; i < NOFILE; i++)
80104013:	83 45 e4 01          	addl   $0x1,-0x1c(%ebp)
80104017:	83 7d e4 0f          	cmpl   $0xf,-0x1c(%ebp)
8010401b:	7e bf                	jle    80103fdc <fork+0xc7>
  np->cwd = idup(curproc->cwd);
8010401d:	8b 45 e0             	mov    -0x20(%ebp),%eax
80104020:	8b 40 68             	mov    0x68(%eax),%eax
80104023:	83 ec 0c             	sub    $0xc,%esp
80104026:	50                   	push   %eax
80104027:	e8 84 d9 ff ff       	call   801019b0 <idup>
8010402c:	83 c4 10             	add    $0x10,%esp
8010402f:	8b 55 dc             	mov    -0x24(%ebp),%edx
80104032:	89 42 68             	mov    %eax,0x68(%edx)

  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
80104035:	8b 45 e0             	mov    -0x20(%ebp),%eax
80104038:	8d 50 6c             	lea    0x6c(%eax),%edx
8010403b:	8b 45 dc             	mov    -0x24(%ebp),%eax
8010403e:	83 c0 6c             	add    $0x6c,%eax
80104041:	83 ec 04             	sub    $0x4,%esp
80104044:	6a 10                	push   $0x10
80104046:	52                   	push   %edx
80104047:	50                   	push   %eax
80104048:	e8 06 0d 00 00       	call   80104d53 <safestrcpy>
8010404d:	83 c4 10             	add    $0x10,%esp

  pid = np->pid;
80104050:	8b 45 dc             	mov    -0x24(%ebp),%eax
80104053:	8b 40 10             	mov    0x10(%eax),%eax
80104056:	89 45 d8             	mov    %eax,-0x28(%ebp)

  acquire(&ptable.lock);
80104059:	83 ec 0c             	sub    $0xc,%esp
8010405c:	68 00 42 19 80       	push   $0x80194200
80104061:	e8 74 08 00 00       	call   801048da <acquire>
80104066:	83 c4 10             	add    $0x10,%esp

  np->state = RUNNABLE;
80104069:	8b 45 dc             	mov    -0x24(%ebp),%eax
8010406c:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)

  release(&ptable.lock);
80104073:	83 ec 0c             	sub    $0xc,%esp
80104076:	68 00 42 19 80       	push   $0x80194200
8010407b:	e8 c8 08 00 00       	call   80104948 <release>
80104080:	83 c4 10             	add    $0x10,%esp

  return pid;
80104083:	8b 45 d8             	mov    -0x28(%ebp),%eax
}
80104086:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104089:	5b                   	pop    %ebx
8010408a:	5e                   	pop    %esi
8010408b:	5f                   	pop    %edi
8010408c:	5d                   	pop    %ebp
8010408d:	c3                   	ret    

8010408e <exit>:
// Exit the current process.  Does not return.
// An exited process remains in the zombie state
// until its parent calls wait() to find out it exited.
void
exit(void)
{
8010408e:	55                   	push   %ebp
8010408f:	89 e5                	mov    %esp,%ebp
80104091:	83 ec 18             	sub    $0x18,%esp
  struct proc *curproc = myproc();
80104094:	e8 7d fb ff ff       	call   80103c16 <myproc>
80104099:	89 45 ec             	mov    %eax,-0x14(%ebp)
  struct proc *p;
  int fd;

  if(curproc == initproc)
8010409c:	a1 34 61 19 80       	mov    0x80196134,%eax
801040a1:	39 45 ec             	cmp    %eax,-0x14(%ebp)
801040a4:	75 0d                	jne    801040b3 <exit+0x25>
    panic("init exiting");
801040a6:	83 ec 0c             	sub    $0xc,%esp
801040a9:	68 b2 a4 10 80       	push   $0x8010a4b2
801040ae:	e8 f6 c4 ff ff       	call   801005a9 <panic>

  // Close all open files.
  for(fd = 0; fd < NOFILE; fd++){
801040b3:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
801040ba:	eb 3f                	jmp    801040fb <exit+0x6d>
    if(curproc->ofile[fd]){
801040bc:	8b 45 ec             	mov    -0x14(%ebp),%eax
801040bf:	8b 55 f0             	mov    -0x10(%ebp),%edx
801040c2:	83 c2 08             	add    $0x8,%edx
801040c5:	8b 44 90 08          	mov    0x8(%eax,%edx,4),%eax
801040c9:	85 c0                	test   %eax,%eax
801040cb:	74 2a                	je     801040f7 <exit+0x69>
      fileclose(curproc->ofile[fd]);
801040cd:	8b 45 ec             	mov    -0x14(%ebp),%eax
801040d0:	8b 55 f0             	mov    -0x10(%ebp),%edx
801040d3:	83 c2 08             	add    $0x8,%edx
801040d6:	8b 44 90 08          	mov    0x8(%eax,%edx,4),%eax
801040da:	83 ec 0c             	sub    $0xc,%esp
801040dd:	50                   	push   %eax
801040de:	e8 b8 cf ff ff       	call   8010109b <fileclose>
801040e3:	83 c4 10             	add    $0x10,%esp
      curproc->ofile[fd] = 0;
801040e6:	8b 45 ec             	mov    -0x14(%ebp),%eax
801040e9:	8b 55 f0             	mov    -0x10(%ebp),%edx
801040ec:	83 c2 08             	add    $0x8,%edx
801040ef:	c7 44 90 08 00 00 00 	movl   $0x0,0x8(%eax,%edx,4)
801040f6:	00 
  for(fd = 0; fd < NOFILE; fd++){
801040f7:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
801040fb:	83 7d f0 0f          	cmpl   $0xf,-0x10(%ebp)
801040ff:	7e bb                	jle    801040bc <exit+0x2e>
    }
  }

  begin_op();
80104101:	e8 36 ef ff ff       	call   8010303c <begin_op>
  iput(curproc->cwd);
80104106:	8b 45 ec             	mov    -0x14(%ebp),%eax
80104109:	8b 40 68             	mov    0x68(%eax),%eax
8010410c:	83 ec 0c             	sub    $0xc,%esp
8010410f:	50                   	push   %eax
80104110:	e8 36 da ff ff       	call   80101b4b <iput>
80104115:	83 c4 10             	add    $0x10,%esp
  end_op();
80104118:	e8 ab ef ff ff       	call   801030c8 <end_op>
  curproc->cwd = 0;
8010411d:	8b 45 ec             	mov    -0x14(%ebp),%eax
80104120:	c7 40 68 00 00 00 00 	movl   $0x0,0x68(%eax)

  acquire(&ptable.lock);
80104127:	83 ec 0c             	sub    $0xc,%esp
8010412a:	68 00 42 19 80       	push   $0x80194200
8010412f:	e8 a6 07 00 00       	call   801048da <acquire>
80104134:	83 c4 10             	add    $0x10,%esp

  // Parent might be sleeping in wait().
  wakeup1(curproc->parent);
80104137:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010413a:	8b 40 14             	mov    0x14(%eax),%eax
8010413d:	83 ec 0c             	sub    $0xc,%esp
80104140:	50                   	push   %eax
80104141:	e8 20 04 00 00       	call   80104566 <wakeup1>
80104146:	83 c4 10             	add    $0x10,%esp

  // Pass abandoned children to init.
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104149:	c7 45 f4 34 42 19 80 	movl   $0x80194234,-0xc(%ebp)
80104150:	eb 37                	jmp    80104189 <exit+0xfb>
    if(p->parent == curproc){
80104152:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104155:	8b 40 14             	mov    0x14(%eax),%eax
80104158:	39 45 ec             	cmp    %eax,-0x14(%ebp)
8010415b:	75 28                	jne    80104185 <exit+0xf7>
      p->parent = initproc;
8010415d:	8b 15 34 61 19 80    	mov    0x80196134,%edx
80104163:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104166:	89 50 14             	mov    %edx,0x14(%eax)
      if(p->state == ZOMBIE)
80104169:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010416c:	8b 40 0c             	mov    0xc(%eax),%eax
8010416f:	83 f8 05             	cmp    $0x5,%eax
80104172:	75 11                	jne    80104185 <exit+0xf7>
        wakeup1(initproc);
80104174:	a1 34 61 19 80       	mov    0x80196134,%eax
80104179:	83 ec 0c             	sub    $0xc,%esp
8010417c:	50                   	push   %eax
8010417d:	e8 e4 03 00 00       	call   80104566 <wakeup1>
80104182:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104185:	83 45 f4 7c          	addl   $0x7c,-0xc(%ebp)
80104189:	81 7d f4 34 61 19 80 	cmpl   $0x80196134,-0xc(%ebp)
80104190:	72 c0                	jb     80104152 <exit+0xc4>
    }
  }

  // Jump into the scheduler, never to return.
  curproc->state = ZOMBIE;
80104192:	8b 45 ec             	mov    -0x14(%ebp),%eax
80104195:	c7 40 0c 05 00 00 00 	movl   $0x5,0xc(%eax)
  sched();
8010419c:	e8 e5 01 00 00       	call   80104386 <sched>
  panic("zombie exit");
801041a1:	83 ec 0c             	sub    $0xc,%esp
801041a4:	68 bf a4 10 80       	push   $0x8010a4bf
801041a9:	e8 fb c3 ff ff       	call   801005a9 <panic>

801041ae <wait>:

// Wait for a child process to exit and return its pid.
// Return -1 if this process has no children.
int
wait(void)
{
801041ae:	55                   	push   %ebp
801041af:	89 e5                	mov    %esp,%ebp
801041b1:	83 ec 18             	sub    $0x18,%esp
  struct proc *p;
  int havekids, pid;
  struct proc *curproc = myproc();
801041b4:	e8 5d fa ff ff       	call   80103c16 <myproc>
801041b9:	89 45 ec             	mov    %eax,-0x14(%ebp)
  
  acquire(&ptable.lock);
801041bc:	83 ec 0c             	sub    $0xc,%esp
801041bf:	68 00 42 19 80       	push   $0x80194200
801041c4:	e8 11 07 00 00       	call   801048da <acquire>
801041c9:	83 c4 10             	add    $0x10,%esp
  for(;;){
    // Scan through table looking for exited children.
    havekids = 0;
801041cc:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801041d3:	c7 45 f4 34 42 19 80 	movl   $0x80194234,-0xc(%ebp)
801041da:	e9 a1 00 00 00       	jmp    80104280 <wait+0xd2>
      if(p->parent != curproc)
801041df:	8b 45 f4             	mov    -0xc(%ebp),%eax
801041e2:	8b 40 14             	mov    0x14(%eax),%eax
801041e5:	39 45 ec             	cmp    %eax,-0x14(%ebp)
801041e8:	0f 85 8d 00 00 00    	jne    8010427b <wait+0xcd>
        continue;
      havekids = 1;
801041ee:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
      if(p->state == ZOMBIE){
801041f5:	8b 45 f4             	mov    -0xc(%ebp),%eax
801041f8:	8b 40 0c             	mov    0xc(%eax),%eax
801041fb:	83 f8 05             	cmp    $0x5,%eax
801041fe:	75 7c                	jne    8010427c <wait+0xce>
        // Found one.
        pid = p->pid;
80104200:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104203:	8b 40 10             	mov    0x10(%eax),%eax
80104206:	89 45 e8             	mov    %eax,-0x18(%ebp)
        kfree(p->kstack);
80104209:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010420c:	8b 40 08             	mov    0x8(%eax),%eax
8010420f:	83 ec 0c             	sub    $0xc,%esp
80104212:	50                   	push   %eax
80104213:	e8 ee e4 ff ff       	call   80102706 <kfree>
80104218:	83 c4 10             	add    $0x10,%esp
        p->kstack = 0;
8010421b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010421e:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
        freevm(p->pgdir);
80104225:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104228:	8b 40 04             	mov    0x4(%eax),%eax
8010422b:	83 ec 0c             	sub    $0xc,%esp
8010422e:	50                   	push   %eax
8010422f:	e8 f2 37 00 00       	call   80107a26 <freevm>
80104234:	83 c4 10             	add    $0x10,%esp
        p->pid = 0;
80104237:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010423a:	c7 40 10 00 00 00 00 	movl   $0x0,0x10(%eax)
        p->parent = 0;
80104241:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104244:	c7 40 14 00 00 00 00 	movl   $0x0,0x14(%eax)
        p->name[0] = 0;
8010424b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010424e:	c6 40 6c 00          	movb   $0x0,0x6c(%eax)
        p->killed = 0;
80104252:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104255:	c7 40 24 00 00 00 00 	movl   $0x0,0x24(%eax)
        p->state = UNUSED;
8010425c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010425f:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
        release(&ptable.lock);
80104266:	83 ec 0c             	sub    $0xc,%esp
80104269:	68 00 42 19 80       	push   $0x80194200
8010426e:	e8 d5 06 00 00       	call   80104948 <release>
80104273:	83 c4 10             	add    $0x10,%esp
        return pid;
80104276:	8b 45 e8             	mov    -0x18(%ebp),%eax
80104279:	eb 51                	jmp    801042cc <wait+0x11e>
        continue;
8010427b:	90                   	nop
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
8010427c:	83 45 f4 7c          	addl   $0x7c,-0xc(%ebp)
80104280:	81 7d f4 34 61 19 80 	cmpl   $0x80196134,-0xc(%ebp)
80104287:	0f 82 52 ff ff ff    	jb     801041df <wait+0x31>
      }
    }

    // No point waiting if we don't have any children.
    if(!havekids || curproc->killed){
8010428d:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80104291:	74 0a                	je     8010429d <wait+0xef>
80104293:	8b 45 ec             	mov    -0x14(%ebp),%eax
80104296:	8b 40 24             	mov    0x24(%eax),%eax
80104299:	85 c0                	test   %eax,%eax
8010429b:	74 17                	je     801042b4 <wait+0x106>
      release(&ptable.lock);
8010429d:	83 ec 0c             	sub    $0xc,%esp
801042a0:	68 00 42 19 80       	push   $0x80194200
801042a5:	e8 9e 06 00 00       	call   80104948 <release>
801042aa:	83 c4 10             	add    $0x10,%esp
      return -1;
801042ad:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801042b2:	eb 18                	jmp    801042cc <wait+0x11e>
    }

    // Wait for children to exit.  (See wakeup1 call in proc_exit.)
    sleep(curproc, &ptable.lock);  //DOC: wait-sleep
801042b4:	83 ec 08             	sub    $0x8,%esp
801042b7:	68 00 42 19 80       	push   $0x80194200
801042bc:	ff 75 ec             	push   -0x14(%ebp)
801042bf:	e8 fb 01 00 00       	call   801044bf <sleep>
801042c4:	83 c4 10             	add    $0x10,%esp
    havekids = 0;
801042c7:	e9 00 ff ff ff       	jmp    801041cc <wait+0x1e>
  }
}
801042cc:	c9                   	leave  
801042cd:	c3                   	ret    

801042ce <scheduler>:
//  - swtch to start running that process
//  - eventually that process transfers control
//      via swtch back to the scheduler.
void
scheduler(void)
{
801042ce:	55                   	push   %ebp
801042cf:	89 e5                	mov    %esp,%ebp
801042d1:	83 ec 18             	sub    $0x18,%esp
  struct proc *p;
  struct cpu *c = mycpu();
801042d4:	e8 c5 f8 ff ff       	call   80103b9e <mycpu>
801042d9:	89 45 f0             	mov    %eax,-0x10(%ebp)
  c->proc = 0;
801042dc:	8b 45 f0             	mov    -0x10(%ebp),%eax
801042df:	c7 80 ac 00 00 00 00 	movl   $0x0,0xac(%eax)
801042e6:	00 00 00 
  
  for(;;){
    // Enable interrupts on this processor.
    sti();
801042e9:	e8 8a f6 ff ff       	call   80103978 <sti>

    // Loop over process table looking for process to run.
    acquire(&ptable.lock);
801042ee:	83 ec 0c             	sub    $0xc,%esp
801042f1:	68 00 42 19 80       	push   $0x80194200
801042f6:	e8 df 05 00 00       	call   801048da <acquire>
801042fb:	83 c4 10             	add    $0x10,%esp
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801042fe:	c7 45 f4 34 42 19 80 	movl   $0x80194234,-0xc(%ebp)
80104305:	eb 61                	jmp    80104368 <scheduler+0x9a>
      if(p->state != RUNNABLE)
80104307:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010430a:	8b 40 0c             	mov    0xc(%eax),%eax
8010430d:	83 f8 03             	cmp    $0x3,%eax
80104310:	75 51                	jne    80104363 <scheduler+0x95>
        continue;

      // Switch to chosen process.  It is the process's job
      // to release ptable.lock and then reacquire it
      // before jumping back to us.
      c->proc = p;
80104312:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104315:	8b 55 f4             	mov    -0xc(%ebp),%edx
80104318:	89 90 ac 00 00 00    	mov    %edx,0xac(%eax)
      switchuvm(p);
8010431e:	83 ec 0c             	sub    $0xc,%esp
80104321:	ff 75 f4             	push   -0xc(%ebp)
80104324:	e8 58 32 00 00       	call   80107581 <switchuvm>
80104329:	83 c4 10             	add    $0x10,%esp
      p->state = RUNNING;
8010432c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010432f:	c7 40 0c 04 00 00 00 	movl   $0x4,0xc(%eax)

      swtch(&(c->scheduler), p->context);
80104336:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104339:	8b 40 1c             	mov    0x1c(%eax),%eax
8010433c:	8b 55 f0             	mov    -0x10(%ebp),%edx
8010433f:	83 c2 04             	add    $0x4,%edx
80104342:	83 ec 08             	sub    $0x8,%esp
80104345:	50                   	push   %eax
80104346:	52                   	push   %edx
80104347:	e8 79 0a 00 00       	call   80104dc5 <swtch>
8010434c:	83 c4 10             	add    $0x10,%esp
      switchkvm();
8010434f:	e8 14 32 00 00       	call   80107568 <switchkvm>

      // Process is done running for now.
      // It should have changed its p->state before coming back.
      c->proc = 0;
80104354:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104357:	c7 80 ac 00 00 00 00 	movl   $0x0,0xac(%eax)
8010435e:	00 00 00 
80104361:	eb 01                	jmp    80104364 <scheduler+0x96>
        continue;
80104363:	90                   	nop
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104364:	83 45 f4 7c          	addl   $0x7c,-0xc(%ebp)
80104368:	81 7d f4 34 61 19 80 	cmpl   $0x80196134,-0xc(%ebp)
8010436f:	72 96                	jb     80104307 <scheduler+0x39>
    }
    release(&ptable.lock);
80104371:	83 ec 0c             	sub    $0xc,%esp
80104374:	68 00 42 19 80       	push   $0x80194200
80104379:	e8 ca 05 00 00       	call   80104948 <release>
8010437e:	83 c4 10             	add    $0x10,%esp
    sti();
80104381:	e9 63 ff ff ff       	jmp    801042e9 <scheduler+0x1b>

80104386 <sched>:
// be proc->intena and proc->ncli, but that would
// break in the few places where a lock is held but
// there's no process.
void
sched(void)
{
80104386:	55                   	push   %ebp
80104387:	89 e5                	mov    %esp,%ebp
80104389:	83 ec 18             	sub    $0x18,%esp
  int intena;
  struct proc *p = myproc();
8010438c:	e8 85 f8 ff ff       	call   80103c16 <myproc>
80104391:	89 45 f4             	mov    %eax,-0xc(%ebp)

  if(!holding(&ptable.lock))
80104394:	83 ec 0c             	sub    $0xc,%esp
80104397:	68 00 42 19 80       	push   $0x80194200
8010439c:	e8 74 06 00 00       	call   80104a15 <holding>
801043a1:	83 c4 10             	add    $0x10,%esp
801043a4:	85 c0                	test   %eax,%eax
801043a6:	75 0d                	jne    801043b5 <sched+0x2f>
    panic("sched ptable.lock");
801043a8:	83 ec 0c             	sub    $0xc,%esp
801043ab:	68 cb a4 10 80       	push   $0x8010a4cb
801043b0:	e8 f4 c1 ff ff       	call   801005a9 <panic>
  if(mycpu()->ncli != 1)
801043b5:	e8 e4 f7 ff ff       	call   80103b9e <mycpu>
801043ba:	8b 80 a4 00 00 00    	mov    0xa4(%eax),%eax
801043c0:	83 f8 01             	cmp    $0x1,%eax
801043c3:	74 0d                	je     801043d2 <sched+0x4c>
    panic("sched locks");
801043c5:	83 ec 0c             	sub    $0xc,%esp
801043c8:	68 dd a4 10 80       	push   $0x8010a4dd
801043cd:	e8 d7 c1 ff ff       	call   801005a9 <panic>
  if(p->state == RUNNING)
801043d2:	8b 45 f4             	mov    -0xc(%ebp),%eax
801043d5:	8b 40 0c             	mov    0xc(%eax),%eax
801043d8:	83 f8 04             	cmp    $0x4,%eax
801043db:	75 0d                	jne    801043ea <sched+0x64>
    panic("sched running");
801043dd:	83 ec 0c             	sub    $0xc,%esp
801043e0:	68 e9 a4 10 80       	push   $0x8010a4e9
801043e5:	e8 bf c1 ff ff       	call   801005a9 <panic>
  if(readeflags()&FL_IF)
801043ea:	e8 79 f5 ff ff       	call   80103968 <readeflags>
801043ef:	25 00 02 00 00       	and    $0x200,%eax
801043f4:	85 c0                	test   %eax,%eax
801043f6:	74 0d                	je     80104405 <sched+0x7f>
    panic("sched interruptible");
801043f8:	83 ec 0c             	sub    $0xc,%esp
801043fb:	68 f7 a4 10 80       	push   $0x8010a4f7
80104400:	e8 a4 c1 ff ff       	call   801005a9 <panic>
  intena = mycpu()->intena;
80104405:	e8 94 f7 ff ff       	call   80103b9e <mycpu>
8010440a:	8b 80 a8 00 00 00    	mov    0xa8(%eax),%eax
80104410:	89 45 f0             	mov    %eax,-0x10(%ebp)
  swtch(&p->context, mycpu()->scheduler);
80104413:	e8 86 f7 ff ff       	call   80103b9e <mycpu>
80104418:	8b 40 04             	mov    0x4(%eax),%eax
8010441b:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010441e:	83 c2 1c             	add    $0x1c,%edx
80104421:	83 ec 08             	sub    $0x8,%esp
80104424:	50                   	push   %eax
80104425:	52                   	push   %edx
80104426:	e8 9a 09 00 00       	call   80104dc5 <swtch>
8010442b:	83 c4 10             	add    $0x10,%esp
  mycpu()->intena = intena;
8010442e:	e8 6b f7 ff ff       	call   80103b9e <mycpu>
80104433:	8b 55 f0             	mov    -0x10(%ebp),%edx
80104436:	89 90 a8 00 00 00    	mov    %edx,0xa8(%eax)
}
8010443c:	90                   	nop
8010443d:	c9                   	leave  
8010443e:	c3                   	ret    

8010443f <yield>:

// Give up the CPU for one scheduling round.
void
yield(void)
{
8010443f:	55                   	push   %ebp
80104440:	89 e5                	mov    %esp,%ebp
80104442:	83 ec 08             	sub    $0x8,%esp
  acquire(&ptable.lock);  //DOC: yieldlock
80104445:	83 ec 0c             	sub    $0xc,%esp
80104448:	68 00 42 19 80       	push   $0x80194200
8010444d:	e8 88 04 00 00       	call   801048da <acquire>
80104452:	83 c4 10             	add    $0x10,%esp
  myproc()->state = RUNNABLE;
80104455:	e8 bc f7 ff ff       	call   80103c16 <myproc>
8010445a:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
  sched();
80104461:	e8 20 ff ff ff       	call   80104386 <sched>
  release(&ptable.lock);
80104466:	83 ec 0c             	sub    $0xc,%esp
80104469:	68 00 42 19 80       	push   $0x80194200
8010446e:	e8 d5 04 00 00       	call   80104948 <release>
80104473:	83 c4 10             	add    $0x10,%esp
}
80104476:	90                   	nop
80104477:	c9                   	leave  
80104478:	c3                   	ret    

80104479 <forkret>:

// A fork child's very first scheduling by scheduler()
// will swtch here.  "Return" to user space.
void
forkret(void)
{
80104479:	55                   	push   %ebp
8010447a:	89 e5                	mov    %esp,%ebp
8010447c:	83 ec 08             	sub    $0x8,%esp
  static int first = 1;
  // Still holding ptable.lock from scheduler.
  release(&ptable.lock);
8010447f:	83 ec 0c             	sub    $0xc,%esp
80104482:	68 00 42 19 80       	push   $0x80194200
80104487:	e8 bc 04 00 00       	call   80104948 <release>
8010448c:	83 c4 10             	add    $0x10,%esp

  if (first) {
8010448f:	a1 04 f0 10 80       	mov    0x8010f004,%eax
80104494:	85 c0                	test   %eax,%eax
80104496:	74 24                	je     801044bc <forkret+0x43>
    // Some initialization functions must be run in the context
    // of a regular process (e.g., they call sleep), and thus cannot
    // be run from main().
    first = 0;
80104498:	c7 05 04 f0 10 80 00 	movl   $0x0,0x8010f004
8010449f:	00 00 00 
    iinit(ROOTDEV);
801044a2:	83 ec 0c             	sub    $0xc,%esp
801044a5:	6a 01                	push   $0x1
801044a7:	e8 cc d1 ff ff       	call   80101678 <iinit>
801044ac:	83 c4 10             	add    $0x10,%esp
    initlog(ROOTDEV);
801044af:	83 ec 0c             	sub    $0xc,%esp
801044b2:	6a 01                	push   $0x1
801044b4:	e8 64 e9 ff ff       	call   80102e1d <initlog>
801044b9:	83 c4 10             	add    $0x10,%esp
  }

  // Return to "caller", actually trapret (see allocproc).
}
801044bc:	90                   	nop
801044bd:	c9                   	leave  
801044be:	c3                   	ret    

801044bf <sleep>:

// Atomically release lock and sleep on chan.
// Reacquires lock when awakened.
void
sleep(void *chan, struct spinlock *lk)
{
801044bf:	55                   	push   %ebp
801044c0:	89 e5                	mov    %esp,%ebp
801044c2:	83 ec 18             	sub    $0x18,%esp
  struct proc *p = myproc();
801044c5:	e8 4c f7 ff ff       	call   80103c16 <myproc>
801044ca:	89 45 f4             	mov    %eax,-0xc(%ebp)
  
  if(p == 0)
801044cd:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801044d1:	75 0d                	jne    801044e0 <sleep+0x21>
    panic("sleep");
801044d3:	83 ec 0c             	sub    $0xc,%esp
801044d6:	68 0b a5 10 80       	push   $0x8010a50b
801044db:	e8 c9 c0 ff ff       	call   801005a9 <panic>

  if(lk == 0)
801044e0:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
801044e4:	75 0d                	jne    801044f3 <sleep+0x34>
    panic("sleep without lk");
801044e6:	83 ec 0c             	sub    $0xc,%esp
801044e9:	68 11 a5 10 80       	push   $0x8010a511
801044ee:	e8 b6 c0 ff ff       	call   801005a9 <panic>
  // change p->state and then call sched.
  // Once we hold ptable.lock, we can be
  // guaranteed that we won't miss any wakeup
  // (wakeup runs with ptable.lock locked),
  // so it's okay to release lk.
  if(lk != &ptable.lock){  //DOC: sleeplock0
801044f3:	81 7d 0c 00 42 19 80 	cmpl   $0x80194200,0xc(%ebp)
801044fa:	74 1e                	je     8010451a <sleep+0x5b>
    acquire(&ptable.lock);  //DOC: sleeplock1
801044fc:	83 ec 0c             	sub    $0xc,%esp
801044ff:	68 00 42 19 80       	push   $0x80194200
80104504:	e8 d1 03 00 00       	call   801048da <acquire>
80104509:	83 c4 10             	add    $0x10,%esp
    release(lk);
8010450c:	83 ec 0c             	sub    $0xc,%esp
8010450f:	ff 75 0c             	push   0xc(%ebp)
80104512:	e8 31 04 00 00       	call   80104948 <release>
80104517:	83 c4 10             	add    $0x10,%esp
  }
  // Go to sleep.
  p->chan = chan;
8010451a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010451d:	8b 55 08             	mov    0x8(%ebp),%edx
80104520:	89 50 20             	mov    %edx,0x20(%eax)
  p->state = SLEEPING;
80104523:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104526:	c7 40 0c 02 00 00 00 	movl   $0x2,0xc(%eax)

  sched();
8010452d:	e8 54 fe ff ff       	call   80104386 <sched>

  // Tidy up.
  p->chan = 0;
80104532:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104535:	c7 40 20 00 00 00 00 	movl   $0x0,0x20(%eax)

  // Reacquire original lock.
  if(lk != &ptable.lock){  //DOC: sleeplock2
8010453c:	81 7d 0c 00 42 19 80 	cmpl   $0x80194200,0xc(%ebp)
80104543:	74 1e                	je     80104563 <sleep+0xa4>
    release(&ptable.lock);
80104545:	83 ec 0c             	sub    $0xc,%esp
80104548:	68 00 42 19 80       	push   $0x80194200
8010454d:	e8 f6 03 00 00       	call   80104948 <release>
80104552:	83 c4 10             	add    $0x10,%esp
    acquire(lk);
80104555:	83 ec 0c             	sub    $0xc,%esp
80104558:	ff 75 0c             	push   0xc(%ebp)
8010455b:	e8 7a 03 00 00       	call   801048da <acquire>
80104560:	83 c4 10             	add    $0x10,%esp
  }
}
80104563:	90                   	nop
80104564:	c9                   	leave  
80104565:	c3                   	ret    

80104566 <wakeup1>:
//PAGEBREAK!
// Wake up all processes sleeping on chan.
// The ptable lock must be held.
static void
wakeup1(void *chan)
{
80104566:	55                   	push   %ebp
80104567:	89 e5                	mov    %esp,%ebp
80104569:	83 ec 10             	sub    $0x10,%esp
  struct proc *p;

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
8010456c:	c7 45 fc 34 42 19 80 	movl   $0x80194234,-0x4(%ebp)
80104573:	eb 24                	jmp    80104599 <wakeup1+0x33>
    if(p->state == SLEEPING && p->chan == chan)
80104575:	8b 45 fc             	mov    -0x4(%ebp),%eax
80104578:	8b 40 0c             	mov    0xc(%eax),%eax
8010457b:	83 f8 02             	cmp    $0x2,%eax
8010457e:	75 15                	jne    80104595 <wakeup1+0x2f>
80104580:	8b 45 fc             	mov    -0x4(%ebp),%eax
80104583:	8b 40 20             	mov    0x20(%eax),%eax
80104586:	39 45 08             	cmp    %eax,0x8(%ebp)
80104589:	75 0a                	jne    80104595 <wakeup1+0x2f>
      p->state = RUNNABLE;
8010458b:	8b 45 fc             	mov    -0x4(%ebp),%eax
8010458e:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104595:	83 45 fc 7c          	addl   $0x7c,-0x4(%ebp)
80104599:	81 7d fc 34 61 19 80 	cmpl   $0x80196134,-0x4(%ebp)
801045a0:	72 d3                	jb     80104575 <wakeup1+0xf>
}
801045a2:	90                   	nop
801045a3:	90                   	nop
801045a4:	c9                   	leave  
801045a5:	c3                   	ret    

801045a6 <wakeup>:

// Wake up all processes sleeping on chan.
void
wakeup(void *chan)
{
801045a6:	55                   	push   %ebp
801045a7:	89 e5                	mov    %esp,%ebp
801045a9:	83 ec 08             	sub    $0x8,%esp
  acquire(&ptable.lock);
801045ac:	83 ec 0c             	sub    $0xc,%esp
801045af:	68 00 42 19 80       	push   $0x80194200
801045b4:	e8 21 03 00 00       	call   801048da <acquire>
801045b9:	83 c4 10             	add    $0x10,%esp
  wakeup1(chan);
801045bc:	83 ec 0c             	sub    $0xc,%esp
801045bf:	ff 75 08             	push   0x8(%ebp)
801045c2:	e8 9f ff ff ff       	call   80104566 <wakeup1>
801045c7:	83 c4 10             	add    $0x10,%esp
  release(&ptable.lock);
801045ca:	83 ec 0c             	sub    $0xc,%esp
801045cd:	68 00 42 19 80       	push   $0x80194200
801045d2:	e8 71 03 00 00       	call   80104948 <release>
801045d7:	83 c4 10             	add    $0x10,%esp
}
801045da:	90                   	nop
801045db:	c9                   	leave  
801045dc:	c3                   	ret    

801045dd <kill>:
// Kill the process with the given pid.
// Process won't exit until it returns
// to user space (see trap in trap.c).
int
kill(int pid)
{
801045dd:	55                   	push   %ebp
801045de:	89 e5                	mov    %esp,%ebp
801045e0:	83 ec 18             	sub    $0x18,%esp
  struct proc *p;

  acquire(&ptable.lock);
801045e3:	83 ec 0c             	sub    $0xc,%esp
801045e6:	68 00 42 19 80       	push   $0x80194200
801045eb:	e8 ea 02 00 00       	call   801048da <acquire>
801045f0:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801045f3:	c7 45 f4 34 42 19 80 	movl   $0x80194234,-0xc(%ebp)
801045fa:	eb 45                	jmp    80104641 <kill+0x64>
    if(p->pid == pid){
801045fc:	8b 45 f4             	mov    -0xc(%ebp),%eax
801045ff:	8b 40 10             	mov    0x10(%eax),%eax
80104602:	39 45 08             	cmp    %eax,0x8(%ebp)
80104605:	75 36                	jne    8010463d <kill+0x60>
      p->killed = 1;
80104607:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010460a:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
      // Wake process from sleep if necessary.
      if(p->state == SLEEPING)
80104611:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104614:	8b 40 0c             	mov    0xc(%eax),%eax
80104617:	83 f8 02             	cmp    $0x2,%eax
8010461a:	75 0a                	jne    80104626 <kill+0x49>
        p->state = RUNNABLE;
8010461c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010461f:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
      release(&ptable.lock);
80104626:	83 ec 0c             	sub    $0xc,%esp
80104629:	68 00 42 19 80       	push   $0x80194200
8010462e:	e8 15 03 00 00       	call   80104948 <release>
80104633:	83 c4 10             	add    $0x10,%esp
      return 0;
80104636:	b8 00 00 00 00       	mov    $0x0,%eax
8010463b:	eb 22                	jmp    8010465f <kill+0x82>
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
8010463d:	83 45 f4 7c          	addl   $0x7c,-0xc(%ebp)
80104641:	81 7d f4 34 61 19 80 	cmpl   $0x80196134,-0xc(%ebp)
80104648:	72 b2                	jb     801045fc <kill+0x1f>
    }
  }
  release(&ptable.lock);
8010464a:	83 ec 0c             	sub    $0xc,%esp
8010464d:	68 00 42 19 80       	push   $0x80194200
80104652:	e8 f1 02 00 00       	call   80104948 <release>
80104657:	83 c4 10             	add    $0x10,%esp
  return -1;
8010465a:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
8010465f:	c9                   	leave  
80104660:	c3                   	ret    

80104661 <procdump>:
// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void
procdump(void)
{
80104661:	55                   	push   %ebp
80104662:	89 e5                	mov    %esp,%ebp
80104664:	83 ec 48             	sub    $0x48,%esp
  int i;
  struct proc *p;
  char *state;
  uint pc[10];

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104667:	c7 45 f0 34 42 19 80 	movl   $0x80194234,-0x10(%ebp)
8010466e:	e9 d7 00 00 00       	jmp    8010474a <procdump+0xe9>
    if(p->state == UNUSED)
80104673:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104676:	8b 40 0c             	mov    0xc(%eax),%eax
80104679:	85 c0                	test   %eax,%eax
8010467b:	0f 84 c4 00 00 00    	je     80104745 <procdump+0xe4>
      continue;
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
80104681:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104684:	8b 40 0c             	mov    0xc(%eax),%eax
80104687:	83 f8 05             	cmp    $0x5,%eax
8010468a:	77 23                	ja     801046af <procdump+0x4e>
8010468c:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010468f:	8b 40 0c             	mov    0xc(%eax),%eax
80104692:	8b 04 85 08 f0 10 80 	mov    -0x7fef0ff8(,%eax,4),%eax
80104699:	85 c0                	test   %eax,%eax
8010469b:	74 12                	je     801046af <procdump+0x4e>
      state = states[p->state];
8010469d:	8b 45 f0             	mov    -0x10(%ebp),%eax
801046a0:	8b 40 0c             	mov    0xc(%eax),%eax
801046a3:	8b 04 85 08 f0 10 80 	mov    -0x7fef0ff8(,%eax,4),%eax
801046aa:	89 45 ec             	mov    %eax,-0x14(%ebp)
801046ad:	eb 07                	jmp    801046b6 <procdump+0x55>
    else
      state = "???";
801046af:	c7 45 ec 22 a5 10 80 	movl   $0x8010a522,-0x14(%ebp)
    cprintf("%d %s %s", p->pid, state, p->name);
801046b6:	8b 45 f0             	mov    -0x10(%ebp),%eax
801046b9:	8d 50 6c             	lea    0x6c(%eax),%edx
801046bc:	8b 45 f0             	mov    -0x10(%ebp),%eax
801046bf:	8b 40 10             	mov    0x10(%eax),%eax
801046c2:	52                   	push   %edx
801046c3:	ff 75 ec             	push   -0x14(%ebp)
801046c6:	50                   	push   %eax
801046c7:	68 26 a5 10 80       	push   $0x8010a526
801046cc:	e8 23 bd ff ff       	call   801003f4 <cprintf>
801046d1:	83 c4 10             	add    $0x10,%esp
    if(p->state == SLEEPING){
801046d4:	8b 45 f0             	mov    -0x10(%ebp),%eax
801046d7:	8b 40 0c             	mov    0xc(%eax),%eax
801046da:	83 f8 02             	cmp    $0x2,%eax
801046dd:	75 54                	jne    80104733 <procdump+0xd2>
      getcallerpcs((uint*)p->context->ebp+2, pc);
801046df:	8b 45 f0             	mov    -0x10(%ebp),%eax
801046e2:	8b 40 1c             	mov    0x1c(%eax),%eax
801046e5:	8b 40 0c             	mov    0xc(%eax),%eax
801046e8:	83 c0 08             	add    $0x8,%eax
801046eb:	89 c2                	mov    %eax,%edx
801046ed:	83 ec 08             	sub    $0x8,%esp
801046f0:	8d 45 c4             	lea    -0x3c(%ebp),%eax
801046f3:	50                   	push   %eax
801046f4:	52                   	push   %edx
801046f5:	e8 a0 02 00 00       	call   8010499a <getcallerpcs>
801046fa:	83 c4 10             	add    $0x10,%esp
      for(i=0; i<10 && pc[i] != 0; i++)
801046fd:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80104704:	eb 1c                	jmp    80104722 <procdump+0xc1>
        cprintf(" %p", pc[i]);
80104706:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104709:	8b 44 85 c4          	mov    -0x3c(%ebp,%eax,4),%eax
8010470d:	83 ec 08             	sub    $0x8,%esp
80104710:	50                   	push   %eax
80104711:	68 2f a5 10 80       	push   $0x8010a52f
80104716:	e8 d9 bc ff ff       	call   801003f4 <cprintf>
8010471b:	83 c4 10             	add    $0x10,%esp
      for(i=0; i<10 && pc[i] != 0; i++)
8010471e:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80104722:	83 7d f4 09          	cmpl   $0x9,-0xc(%ebp)
80104726:	7f 0b                	jg     80104733 <procdump+0xd2>
80104728:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010472b:	8b 44 85 c4          	mov    -0x3c(%ebp,%eax,4),%eax
8010472f:	85 c0                	test   %eax,%eax
80104731:	75 d3                	jne    80104706 <procdump+0xa5>
    }
    cprintf("\n");
80104733:	83 ec 0c             	sub    $0xc,%esp
80104736:	68 33 a5 10 80       	push   $0x8010a533
8010473b:	e8 b4 bc ff ff       	call   801003f4 <cprintf>
80104740:	83 c4 10             	add    $0x10,%esp
80104743:	eb 01                	jmp    80104746 <procdump+0xe5>
      continue;
80104745:	90                   	nop
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104746:	83 45 f0 7c          	addl   $0x7c,-0x10(%ebp)
8010474a:	81 7d f0 34 61 19 80 	cmpl   $0x80196134,-0x10(%ebp)
80104751:	0f 82 1c ff ff ff    	jb     80104673 <procdump+0x12>
  }
}
80104757:	90                   	nop
80104758:	90                   	nop
80104759:	c9                   	leave  
8010475a:	c3                   	ret    

8010475b <initsleeplock>:
#include "spinlock.h"
#include "sleeplock.h"

void
initsleeplock(struct sleeplock *lk, char *name)
{
8010475b:	55                   	push   %ebp
8010475c:	89 e5                	mov    %esp,%ebp
8010475e:	83 ec 08             	sub    $0x8,%esp
  initlock(&lk->lk, "sleep lock");
80104761:	8b 45 08             	mov    0x8(%ebp),%eax
80104764:	83 c0 04             	add    $0x4,%eax
80104767:	83 ec 08             	sub    $0x8,%esp
8010476a:	68 5f a5 10 80       	push   $0x8010a55f
8010476f:	50                   	push   %eax
80104770:	e8 43 01 00 00       	call   801048b8 <initlock>
80104775:	83 c4 10             	add    $0x10,%esp
  lk->name = name;
80104778:	8b 45 08             	mov    0x8(%ebp),%eax
8010477b:	8b 55 0c             	mov    0xc(%ebp),%edx
8010477e:	89 50 38             	mov    %edx,0x38(%eax)
  lk->locked = 0;
80104781:	8b 45 08             	mov    0x8(%ebp),%eax
80104784:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  lk->pid = 0;
8010478a:	8b 45 08             	mov    0x8(%ebp),%eax
8010478d:	c7 40 3c 00 00 00 00 	movl   $0x0,0x3c(%eax)
}
80104794:	90                   	nop
80104795:	c9                   	leave  
80104796:	c3                   	ret    

80104797 <acquiresleep>:

void
acquiresleep(struct sleeplock *lk)
{
80104797:	55                   	push   %ebp
80104798:	89 e5                	mov    %esp,%ebp
8010479a:	83 ec 08             	sub    $0x8,%esp
  acquire(&lk->lk);
8010479d:	8b 45 08             	mov    0x8(%ebp),%eax
801047a0:	83 c0 04             	add    $0x4,%eax
801047a3:	83 ec 0c             	sub    $0xc,%esp
801047a6:	50                   	push   %eax
801047a7:	e8 2e 01 00 00       	call   801048da <acquire>
801047ac:	83 c4 10             	add    $0x10,%esp
  while (lk->locked) {
801047af:	eb 15                	jmp    801047c6 <acquiresleep+0x2f>
    sleep(lk, &lk->lk);
801047b1:	8b 45 08             	mov    0x8(%ebp),%eax
801047b4:	83 c0 04             	add    $0x4,%eax
801047b7:	83 ec 08             	sub    $0x8,%esp
801047ba:	50                   	push   %eax
801047bb:	ff 75 08             	push   0x8(%ebp)
801047be:	e8 fc fc ff ff       	call   801044bf <sleep>
801047c3:	83 c4 10             	add    $0x10,%esp
  while (lk->locked) {
801047c6:	8b 45 08             	mov    0x8(%ebp),%eax
801047c9:	8b 00                	mov    (%eax),%eax
801047cb:	85 c0                	test   %eax,%eax
801047cd:	75 e2                	jne    801047b1 <acquiresleep+0x1a>
  }
  lk->locked = 1;
801047cf:	8b 45 08             	mov    0x8(%ebp),%eax
801047d2:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  lk->pid = myproc()->pid;
801047d8:	e8 39 f4 ff ff       	call   80103c16 <myproc>
801047dd:	8b 50 10             	mov    0x10(%eax),%edx
801047e0:	8b 45 08             	mov    0x8(%ebp),%eax
801047e3:	89 50 3c             	mov    %edx,0x3c(%eax)
  release(&lk->lk);
801047e6:	8b 45 08             	mov    0x8(%ebp),%eax
801047e9:	83 c0 04             	add    $0x4,%eax
801047ec:	83 ec 0c             	sub    $0xc,%esp
801047ef:	50                   	push   %eax
801047f0:	e8 53 01 00 00       	call   80104948 <release>
801047f5:	83 c4 10             	add    $0x10,%esp
}
801047f8:	90                   	nop
801047f9:	c9                   	leave  
801047fa:	c3                   	ret    

801047fb <releasesleep>:

void
releasesleep(struct sleeplock *lk)
{
801047fb:	55                   	push   %ebp
801047fc:	89 e5                	mov    %esp,%ebp
801047fe:	83 ec 08             	sub    $0x8,%esp
  acquire(&lk->lk);
80104801:	8b 45 08             	mov    0x8(%ebp),%eax
80104804:	83 c0 04             	add    $0x4,%eax
80104807:	83 ec 0c             	sub    $0xc,%esp
8010480a:	50                   	push   %eax
8010480b:	e8 ca 00 00 00       	call   801048da <acquire>
80104810:	83 c4 10             	add    $0x10,%esp
  lk->locked = 0;
80104813:	8b 45 08             	mov    0x8(%ebp),%eax
80104816:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  lk->pid = 0;
8010481c:	8b 45 08             	mov    0x8(%ebp),%eax
8010481f:	c7 40 3c 00 00 00 00 	movl   $0x0,0x3c(%eax)
  wakeup(lk);
80104826:	83 ec 0c             	sub    $0xc,%esp
80104829:	ff 75 08             	push   0x8(%ebp)
8010482c:	e8 75 fd ff ff       	call   801045a6 <wakeup>
80104831:	83 c4 10             	add    $0x10,%esp
  release(&lk->lk);
80104834:	8b 45 08             	mov    0x8(%ebp),%eax
80104837:	83 c0 04             	add    $0x4,%eax
8010483a:	83 ec 0c             	sub    $0xc,%esp
8010483d:	50                   	push   %eax
8010483e:	e8 05 01 00 00       	call   80104948 <release>
80104843:	83 c4 10             	add    $0x10,%esp
}
80104846:	90                   	nop
80104847:	c9                   	leave  
80104848:	c3                   	ret    

80104849 <holdingsleep>:

int
holdingsleep(struct sleeplock *lk)
{
80104849:	55                   	push   %ebp
8010484a:	89 e5                	mov    %esp,%ebp
8010484c:	83 ec 18             	sub    $0x18,%esp
  int r;
  
  acquire(&lk->lk);
8010484f:	8b 45 08             	mov    0x8(%ebp),%eax
80104852:	83 c0 04             	add    $0x4,%eax
80104855:	83 ec 0c             	sub    $0xc,%esp
80104858:	50                   	push   %eax
80104859:	e8 7c 00 00 00       	call   801048da <acquire>
8010485e:	83 c4 10             	add    $0x10,%esp
  r = lk->locked;
80104861:	8b 45 08             	mov    0x8(%ebp),%eax
80104864:	8b 00                	mov    (%eax),%eax
80104866:	89 45 f4             	mov    %eax,-0xc(%ebp)
  release(&lk->lk);
80104869:	8b 45 08             	mov    0x8(%ebp),%eax
8010486c:	83 c0 04             	add    $0x4,%eax
8010486f:	83 ec 0c             	sub    $0xc,%esp
80104872:	50                   	push   %eax
80104873:	e8 d0 00 00 00       	call   80104948 <release>
80104878:	83 c4 10             	add    $0x10,%esp
  return r;
8010487b:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
8010487e:	c9                   	leave  
8010487f:	c3                   	ret    

80104880 <readeflags>:
{
80104880:	55                   	push   %ebp
80104881:	89 e5                	mov    %esp,%ebp
80104883:	83 ec 10             	sub    $0x10,%esp
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80104886:	9c                   	pushf  
80104887:	58                   	pop    %eax
80104888:	89 45 fc             	mov    %eax,-0x4(%ebp)
  return eflags;
8010488b:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
8010488e:	c9                   	leave  
8010488f:	c3                   	ret    

80104890 <cli>:
{
80104890:	55                   	push   %ebp
80104891:	89 e5                	mov    %esp,%ebp
  asm volatile("cli");
80104893:	fa                   	cli    
}
80104894:	90                   	nop
80104895:	5d                   	pop    %ebp
80104896:	c3                   	ret    

80104897 <sti>:
{
80104897:	55                   	push   %ebp
80104898:	89 e5                	mov    %esp,%ebp
  asm volatile("sti");
8010489a:	fb                   	sti    
}
8010489b:	90                   	nop
8010489c:	5d                   	pop    %ebp
8010489d:	c3                   	ret    

8010489e <xchg>:
{
8010489e:	55                   	push   %ebp
8010489f:	89 e5                	mov    %esp,%ebp
801048a1:	83 ec 10             	sub    $0x10,%esp
  asm volatile("lock; xchgl %0, %1" :
801048a4:	8b 55 08             	mov    0x8(%ebp),%edx
801048a7:	8b 45 0c             	mov    0xc(%ebp),%eax
801048aa:	8b 4d 08             	mov    0x8(%ebp),%ecx
801048ad:	f0 87 02             	lock xchg %eax,(%edx)
801048b0:	89 45 fc             	mov    %eax,-0x4(%ebp)
  return result;
801048b3:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
801048b6:	c9                   	leave  
801048b7:	c3                   	ret    

801048b8 <initlock>:
#include "proc.h"
#include "spinlock.h"

void
initlock(struct spinlock *lk, char *name)
{
801048b8:	55                   	push   %ebp
801048b9:	89 e5                	mov    %esp,%ebp
  lk->name = name;
801048bb:	8b 45 08             	mov    0x8(%ebp),%eax
801048be:	8b 55 0c             	mov    0xc(%ebp),%edx
801048c1:	89 50 04             	mov    %edx,0x4(%eax)
  lk->locked = 0;
801048c4:	8b 45 08             	mov    0x8(%ebp),%eax
801048c7:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  lk->cpu = 0;
801048cd:	8b 45 08             	mov    0x8(%ebp),%eax
801048d0:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
}
801048d7:	90                   	nop
801048d8:	5d                   	pop    %ebp
801048d9:	c3                   	ret    

801048da <acquire>:
// Loops (spins) until the lock is acquired.
// Holding a lock for a long time may cause
// other CPUs to waste time spinning to acquire it.
void
acquire(struct spinlock *lk)
{
801048da:	55                   	push   %ebp
801048db:	89 e5                	mov    %esp,%ebp
801048dd:	53                   	push   %ebx
801048de:	83 ec 04             	sub    $0x4,%esp
  pushcli(); // disable interrupts to avoid deadlock.
801048e1:	e8 5f 01 00 00       	call   80104a45 <pushcli>
  if(holding(lk)){
801048e6:	8b 45 08             	mov    0x8(%ebp),%eax
801048e9:	83 ec 0c             	sub    $0xc,%esp
801048ec:	50                   	push   %eax
801048ed:	e8 23 01 00 00       	call   80104a15 <holding>
801048f2:	83 c4 10             	add    $0x10,%esp
801048f5:	85 c0                	test   %eax,%eax
801048f7:	74 0d                	je     80104906 <acquire+0x2c>
    panic("acquire");
801048f9:	83 ec 0c             	sub    $0xc,%esp
801048fc:	68 6a a5 10 80       	push   $0x8010a56a
80104901:	e8 a3 bc ff ff       	call   801005a9 <panic>
  }

  // The xchg is atomic.
  while(xchg(&lk->locked, 1) != 0)
80104906:	90                   	nop
80104907:	8b 45 08             	mov    0x8(%ebp),%eax
8010490a:	83 ec 08             	sub    $0x8,%esp
8010490d:	6a 01                	push   $0x1
8010490f:	50                   	push   %eax
80104910:	e8 89 ff ff ff       	call   8010489e <xchg>
80104915:	83 c4 10             	add    $0x10,%esp
80104918:	85 c0                	test   %eax,%eax
8010491a:	75 eb                	jne    80104907 <acquire+0x2d>
    ;

  // Tell the C compiler and the processor to not move loads or stores
  // past this point, to ensure that the critical section's memory
  // references happen after the lock is acquired.
  __sync_synchronize();
8010491c:	f0 83 0c 24 00       	lock orl $0x0,(%esp)

  // Record info about lock acquisition for debugging.
  lk->cpu = mycpu();
80104921:	8b 5d 08             	mov    0x8(%ebp),%ebx
80104924:	e8 75 f2 ff ff       	call   80103b9e <mycpu>
80104929:	89 43 08             	mov    %eax,0x8(%ebx)
  getcallerpcs(&lk, lk->pcs);
8010492c:	8b 45 08             	mov    0x8(%ebp),%eax
8010492f:	83 c0 0c             	add    $0xc,%eax
80104932:	83 ec 08             	sub    $0x8,%esp
80104935:	50                   	push   %eax
80104936:	8d 45 08             	lea    0x8(%ebp),%eax
80104939:	50                   	push   %eax
8010493a:	e8 5b 00 00 00       	call   8010499a <getcallerpcs>
8010493f:	83 c4 10             	add    $0x10,%esp
}
80104942:	90                   	nop
80104943:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104946:	c9                   	leave  
80104947:	c3                   	ret    

80104948 <release>:

// Release the lock.
void
release(struct spinlock *lk)
{
80104948:	55                   	push   %ebp
80104949:	89 e5                	mov    %esp,%ebp
8010494b:	83 ec 08             	sub    $0x8,%esp
  if(!holding(lk))
8010494e:	83 ec 0c             	sub    $0xc,%esp
80104951:	ff 75 08             	push   0x8(%ebp)
80104954:	e8 bc 00 00 00       	call   80104a15 <holding>
80104959:	83 c4 10             	add    $0x10,%esp
8010495c:	85 c0                	test   %eax,%eax
8010495e:	75 0d                	jne    8010496d <release+0x25>
    panic("release");
80104960:	83 ec 0c             	sub    $0xc,%esp
80104963:	68 72 a5 10 80       	push   $0x8010a572
80104968:	e8 3c bc ff ff       	call   801005a9 <panic>

  lk->pcs[0] = 0;
8010496d:	8b 45 08             	mov    0x8(%ebp),%eax
80104970:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
  lk->cpu = 0;
80104977:	8b 45 08             	mov    0x8(%ebp),%eax
8010497a:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  // Tell the C compiler and the processor to not move loads or stores
  // past this point, to ensure that all the stores in the critical
  // section are visible to other cores before the lock is released.
  // Both the C compiler and the hardware may re-order loads and
  // stores; __sync_synchronize() tells them both not to.
  __sync_synchronize();
80104981:	f0 83 0c 24 00       	lock orl $0x0,(%esp)

  // Release the lock, equivalent to lk->locked = 0.
  // This code can't use a C assignment, since it might
  // not be atomic. A real OS would use C atomics here.
  asm volatile("movl $0, %0" : "+m" (lk->locked) : );
80104986:	8b 45 08             	mov    0x8(%ebp),%eax
80104989:	8b 55 08             	mov    0x8(%ebp),%edx
8010498c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

  popcli();
80104992:	e8 fb 00 00 00       	call   80104a92 <popcli>
}
80104997:	90                   	nop
80104998:	c9                   	leave  
80104999:	c3                   	ret    

8010499a <getcallerpcs>:

// Record the current call stack in pcs[] by following the %ebp chain.
void
getcallerpcs(void *v, uint pcs[])
{
8010499a:	55                   	push   %ebp
8010499b:	89 e5                	mov    %esp,%ebp
8010499d:	83 ec 10             	sub    $0x10,%esp
  uint *ebp;
  int i;

  ebp = (uint*)v - 2;
801049a0:	8b 45 08             	mov    0x8(%ebp),%eax
801049a3:	83 e8 08             	sub    $0x8,%eax
801049a6:	89 45 fc             	mov    %eax,-0x4(%ebp)
  for(i = 0; i < 10; i++){
801049a9:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
801049b0:	eb 38                	jmp    801049ea <getcallerpcs+0x50>
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
801049b2:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
801049b6:	74 53                	je     80104a0b <getcallerpcs+0x71>
801049b8:	81 7d fc ff ff ff 7f 	cmpl   $0x7fffffff,-0x4(%ebp)
801049bf:	76 4a                	jbe    80104a0b <getcallerpcs+0x71>
801049c1:	83 7d fc ff          	cmpl   $0xffffffff,-0x4(%ebp)
801049c5:	74 44                	je     80104a0b <getcallerpcs+0x71>
      break;
    pcs[i] = ebp[1];     // saved %eip
801049c7:	8b 45 f8             	mov    -0x8(%ebp),%eax
801049ca:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
801049d1:	8b 45 0c             	mov    0xc(%ebp),%eax
801049d4:	01 c2                	add    %eax,%edx
801049d6:	8b 45 fc             	mov    -0x4(%ebp),%eax
801049d9:	8b 40 04             	mov    0x4(%eax),%eax
801049dc:	89 02                	mov    %eax,(%edx)
    ebp = (uint*)ebp[0]; // saved %ebp
801049de:	8b 45 fc             	mov    -0x4(%ebp),%eax
801049e1:	8b 00                	mov    (%eax),%eax
801049e3:	89 45 fc             	mov    %eax,-0x4(%ebp)
  for(i = 0; i < 10; i++){
801049e6:	83 45 f8 01          	addl   $0x1,-0x8(%ebp)
801049ea:	83 7d f8 09          	cmpl   $0x9,-0x8(%ebp)
801049ee:	7e c2                	jle    801049b2 <getcallerpcs+0x18>
  }
  for(; i < 10; i++)
801049f0:	eb 19                	jmp    80104a0b <getcallerpcs+0x71>
    pcs[i] = 0;
801049f2:	8b 45 f8             	mov    -0x8(%ebp),%eax
801049f5:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
801049fc:	8b 45 0c             	mov    0xc(%ebp),%eax
801049ff:	01 d0                	add    %edx,%eax
80104a01:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  for(; i < 10; i++)
80104a07:	83 45 f8 01          	addl   $0x1,-0x8(%ebp)
80104a0b:	83 7d f8 09          	cmpl   $0x9,-0x8(%ebp)
80104a0f:	7e e1                	jle    801049f2 <getcallerpcs+0x58>
}
80104a11:	90                   	nop
80104a12:	90                   	nop
80104a13:	c9                   	leave  
80104a14:	c3                   	ret    

80104a15 <holding>:

// Check whether this cpu is holding the lock.
int
holding(struct spinlock *lock)
{
80104a15:	55                   	push   %ebp
80104a16:	89 e5                	mov    %esp,%ebp
80104a18:	53                   	push   %ebx
80104a19:	83 ec 04             	sub    $0x4,%esp
  return lock->locked && lock->cpu == mycpu();
80104a1c:	8b 45 08             	mov    0x8(%ebp),%eax
80104a1f:	8b 00                	mov    (%eax),%eax
80104a21:	85 c0                	test   %eax,%eax
80104a23:	74 16                	je     80104a3b <holding+0x26>
80104a25:	8b 45 08             	mov    0x8(%ebp),%eax
80104a28:	8b 58 08             	mov    0x8(%eax),%ebx
80104a2b:	e8 6e f1 ff ff       	call   80103b9e <mycpu>
80104a30:	39 c3                	cmp    %eax,%ebx
80104a32:	75 07                	jne    80104a3b <holding+0x26>
80104a34:	b8 01 00 00 00       	mov    $0x1,%eax
80104a39:	eb 05                	jmp    80104a40 <holding+0x2b>
80104a3b:	b8 00 00 00 00       	mov    $0x0,%eax
}
80104a40:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104a43:	c9                   	leave  
80104a44:	c3                   	ret    

80104a45 <pushcli>:
// it takes two popcli to undo two pushcli.  Also, if interrupts
// are off, then pushcli, popcli leaves them off.

void
pushcli(void)
{
80104a45:	55                   	push   %ebp
80104a46:	89 e5                	mov    %esp,%ebp
80104a48:	83 ec 18             	sub    $0x18,%esp
  int eflags;

  eflags = readeflags();
80104a4b:	e8 30 fe ff ff       	call   80104880 <readeflags>
80104a50:	89 45 f4             	mov    %eax,-0xc(%ebp)
  cli();
80104a53:	e8 38 fe ff ff       	call   80104890 <cli>
  if(mycpu()->ncli == 0)
80104a58:	e8 41 f1 ff ff       	call   80103b9e <mycpu>
80104a5d:	8b 80 a4 00 00 00    	mov    0xa4(%eax),%eax
80104a63:	85 c0                	test   %eax,%eax
80104a65:	75 14                	jne    80104a7b <pushcli+0x36>
    mycpu()->intena = eflags & FL_IF;
80104a67:	e8 32 f1 ff ff       	call   80103b9e <mycpu>
80104a6c:	8b 55 f4             	mov    -0xc(%ebp),%edx
80104a6f:	81 e2 00 02 00 00    	and    $0x200,%edx
80104a75:	89 90 a8 00 00 00    	mov    %edx,0xa8(%eax)
  mycpu()->ncli += 1;
80104a7b:	e8 1e f1 ff ff       	call   80103b9e <mycpu>
80104a80:	8b 90 a4 00 00 00    	mov    0xa4(%eax),%edx
80104a86:	83 c2 01             	add    $0x1,%edx
80104a89:	89 90 a4 00 00 00    	mov    %edx,0xa4(%eax)
}
80104a8f:	90                   	nop
80104a90:	c9                   	leave  
80104a91:	c3                   	ret    

80104a92 <popcli>:

void
popcli(void)
{
80104a92:	55                   	push   %ebp
80104a93:	89 e5                	mov    %esp,%ebp
80104a95:	83 ec 08             	sub    $0x8,%esp
  if(readeflags()&FL_IF)
80104a98:	e8 e3 fd ff ff       	call   80104880 <readeflags>
80104a9d:	25 00 02 00 00       	and    $0x200,%eax
80104aa2:	85 c0                	test   %eax,%eax
80104aa4:	74 0d                	je     80104ab3 <popcli+0x21>
    panic("popcli - interruptible");
80104aa6:	83 ec 0c             	sub    $0xc,%esp
80104aa9:	68 7a a5 10 80       	push   $0x8010a57a
80104aae:	e8 f6 ba ff ff       	call   801005a9 <panic>
  if(--mycpu()->ncli < 0)
80104ab3:	e8 e6 f0 ff ff       	call   80103b9e <mycpu>
80104ab8:	8b 90 a4 00 00 00    	mov    0xa4(%eax),%edx
80104abe:	83 ea 01             	sub    $0x1,%edx
80104ac1:	89 90 a4 00 00 00    	mov    %edx,0xa4(%eax)
80104ac7:	8b 80 a4 00 00 00    	mov    0xa4(%eax),%eax
80104acd:	85 c0                	test   %eax,%eax
80104acf:	79 0d                	jns    80104ade <popcli+0x4c>
    panic("popcli");
80104ad1:	83 ec 0c             	sub    $0xc,%esp
80104ad4:	68 91 a5 10 80       	push   $0x8010a591
80104ad9:	e8 cb ba ff ff       	call   801005a9 <panic>
  if(mycpu()->ncli == 0 && mycpu()->intena)
80104ade:	e8 bb f0 ff ff       	call   80103b9e <mycpu>
80104ae3:	8b 80 a4 00 00 00    	mov    0xa4(%eax),%eax
80104ae9:	85 c0                	test   %eax,%eax
80104aeb:	75 14                	jne    80104b01 <popcli+0x6f>
80104aed:	e8 ac f0 ff ff       	call   80103b9e <mycpu>
80104af2:	8b 80 a8 00 00 00    	mov    0xa8(%eax),%eax
80104af8:	85 c0                	test   %eax,%eax
80104afa:	74 05                	je     80104b01 <popcli+0x6f>
    sti();
80104afc:	e8 96 fd ff ff       	call   80104897 <sti>
}
80104b01:	90                   	nop
80104b02:	c9                   	leave  
80104b03:	c3                   	ret    

80104b04 <stosb>:
80104b04:	55                   	push   %ebp
80104b05:	89 e5                	mov    %esp,%ebp
80104b07:	57                   	push   %edi
80104b08:	53                   	push   %ebx
80104b09:	8b 4d 08             	mov    0x8(%ebp),%ecx
80104b0c:	8b 55 10             	mov    0x10(%ebp),%edx
80104b0f:	8b 45 0c             	mov    0xc(%ebp),%eax
80104b12:	89 cb                	mov    %ecx,%ebx
80104b14:	89 df                	mov    %ebx,%edi
80104b16:	89 d1                	mov    %edx,%ecx
80104b18:	fc                   	cld    
80104b19:	f3 aa                	rep stos %al,%es:(%edi)
80104b1b:	89 ca                	mov    %ecx,%edx
80104b1d:	89 fb                	mov    %edi,%ebx
80104b1f:	89 5d 08             	mov    %ebx,0x8(%ebp)
80104b22:	89 55 10             	mov    %edx,0x10(%ebp)
80104b25:	90                   	nop
80104b26:	5b                   	pop    %ebx
80104b27:	5f                   	pop    %edi
80104b28:	5d                   	pop    %ebp
80104b29:	c3                   	ret    

80104b2a <stosl>:
80104b2a:	55                   	push   %ebp
80104b2b:	89 e5                	mov    %esp,%ebp
80104b2d:	57                   	push   %edi
80104b2e:	53                   	push   %ebx
80104b2f:	8b 4d 08             	mov    0x8(%ebp),%ecx
80104b32:	8b 55 10             	mov    0x10(%ebp),%edx
80104b35:	8b 45 0c             	mov    0xc(%ebp),%eax
80104b38:	89 cb                	mov    %ecx,%ebx
80104b3a:	89 df                	mov    %ebx,%edi
80104b3c:	89 d1                	mov    %edx,%ecx
80104b3e:	fc                   	cld    
80104b3f:	f3 ab                	rep stos %eax,%es:(%edi)
80104b41:	89 ca                	mov    %ecx,%edx
80104b43:	89 fb                	mov    %edi,%ebx
80104b45:	89 5d 08             	mov    %ebx,0x8(%ebp)
80104b48:	89 55 10             	mov    %edx,0x10(%ebp)
80104b4b:	90                   	nop
80104b4c:	5b                   	pop    %ebx
80104b4d:	5f                   	pop    %edi
80104b4e:	5d                   	pop    %ebp
80104b4f:	c3                   	ret    

80104b50 <memset>:
80104b50:	55                   	push   %ebp
80104b51:	89 e5                	mov    %esp,%ebp
80104b53:	8b 45 08             	mov    0x8(%ebp),%eax
80104b56:	83 e0 03             	and    $0x3,%eax
80104b59:	85 c0                	test   %eax,%eax
80104b5b:	75 43                	jne    80104ba0 <memset+0x50>
80104b5d:	8b 45 10             	mov    0x10(%ebp),%eax
80104b60:	83 e0 03             	and    $0x3,%eax
80104b63:	85 c0                	test   %eax,%eax
80104b65:	75 39                	jne    80104ba0 <memset+0x50>
80104b67:	81 65 0c ff 00 00 00 	andl   $0xff,0xc(%ebp)
80104b6e:	8b 45 10             	mov    0x10(%ebp),%eax
80104b71:	c1 e8 02             	shr    $0x2,%eax
80104b74:	89 c2                	mov    %eax,%edx
80104b76:	8b 45 0c             	mov    0xc(%ebp),%eax
80104b79:	c1 e0 18             	shl    $0x18,%eax
80104b7c:	89 c1                	mov    %eax,%ecx
80104b7e:	8b 45 0c             	mov    0xc(%ebp),%eax
80104b81:	c1 e0 10             	shl    $0x10,%eax
80104b84:	09 c1                	or     %eax,%ecx
80104b86:	8b 45 0c             	mov    0xc(%ebp),%eax
80104b89:	c1 e0 08             	shl    $0x8,%eax
80104b8c:	09 c8                	or     %ecx,%eax
80104b8e:	0b 45 0c             	or     0xc(%ebp),%eax
80104b91:	52                   	push   %edx
80104b92:	50                   	push   %eax
80104b93:	ff 75 08             	push   0x8(%ebp)
80104b96:	e8 8f ff ff ff       	call   80104b2a <stosl>
80104b9b:	83 c4 0c             	add    $0xc,%esp
80104b9e:	eb 12                	jmp    80104bb2 <memset+0x62>
80104ba0:	8b 45 10             	mov    0x10(%ebp),%eax
80104ba3:	50                   	push   %eax
80104ba4:	ff 75 0c             	push   0xc(%ebp)
80104ba7:	ff 75 08             	push   0x8(%ebp)
80104baa:	e8 55 ff ff ff       	call   80104b04 <stosb>
80104baf:	83 c4 0c             	add    $0xc,%esp
80104bb2:	8b 45 08             	mov    0x8(%ebp),%eax
80104bb5:	c9                   	leave  
80104bb6:	c3                   	ret    

80104bb7 <memcmp>:
80104bb7:	55                   	push   %ebp
80104bb8:	89 e5                	mov    %esp,%ebp
80104bba:	83 ec 10             	sub    $0x10,%esp
80104bbd:	8b 45 08             	mov    0x8(%ebp),%eax
80104bc0:	89 45 fc             	mov    %eax,-0x4(%ebp)
80104bc3:	8b 45 0c             	mov    0xc(%ebp),%eax
80104bc6:	89 45 f8             	mov    %eax,-0x8(%ebp)
80104bc9:	eb 30                	jmp    80104bfb <memcmp+0x44>
80104bcb:	8b 45 fc             	mov    -0x4(%ebp),%eax
80104bce:	0f b6 10             	movzbl (%eax),%edx
80104bd1:	8b 45 f8             	mov    -0x8(%ebp),%eax
80104bd4:	0f b6 00             	movzbl (%eax),%eax
80104bd7:	38 c2                	cmp    %al,%dl
80104bd9:	74 18                	je     80104bf3 <memcmp+0x3c>
80104bdb:	8b 45 fc             	mov    -0x4(%ebp),%eax
80104bde:	0f b6 00             	movzbl (%eax),%eax
80104be1:	0f b6 d0             	movzbl %al,%edx
80104be4:	8b 45 f8             	mov    -0x8(%ebp),%eax
80104be7:	0f b6 00             	movzbl (%eax),%eax
80104bea:	0f b6 c8             	movzbl %al,%ecx
80104bed:	89 d0                	mov    %edx,%eax
80104bef:	29 c8                	sub    %ecx,%eax
80104bf1:	eb 1a                	jmp    80104c0d <memcmp+0x56>
80104bf3:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
80104bf7:	83 45 f8 01          	addl   $0x1,-0x8(%ebp)
80104bfb:	8b 45 10             	mov    0x10(%ebp),%eax
80104bfe:	8d 50 ff             	lea    -0x1(%eax),%edx
80104c01:	89 55 10             	mov    %edx,0x10(%ebp)
80104c04:	85 c0                	test   %eax,%eax
80104c06:	75 c3                	jne    80104bcb <memcmp+0x14>
80104c08:	b8 00 00 00 00       	mov    $0x0,%eax
80104c0d:	c9                   	leave  
80104c0e:	c3                   	ret    

80104c0f <memmove>:
80104c0f:	55                   	push   %ebp
80104c10:	89 e5                	mov    %esp,%ebp
80104c12:	83 ec 10             	sub    $0x10,%esp
80104c15:	8b 45 0c             	mov    0xc(%ebp),%eax
80104c18:	89 45 fc             	mov    %eax,-0x4(%ebp)
80104c1b:	8b 45 08             	mov    0x8(%ebp),%eax
80104c1e:	89 45 f8             	mov    %eax,-0x8(%ebp)
80104c21:	8b 45 fc             	mov    -0x4(%ebp),%eax
80104c24:	3b 45 f8             	cmp    -0x8(%ebp),%eax
80104c27:	73 54                	jae    80104c7d <memmove+0x6e>
80104c29:	8b 55 fc             	mov    -0x4(%ebp),%edx
80104c2c:	8b 45 10             	mov    0x10(%ebp),%eax
80104c2f:	01 d0                	add    %edx,%eax
80104c31:	39 45 f8             	cmp    %eax,-0x8(%ebp)
80104c34:	73 47                	jae    80104c7d <memmove+0x6e>
80104c36:	8b 45 10             	mov    0x10(%ebp),%eax
80104c39:	01 45 fc             	add    %eax,-0x4(%ebp)
80104c3c:	8b 45 10             	mov    0x10(%ebp),%eax
80104c3f:	01 45 f8             	add    %eax,-0x8(%ebp)
80104c42:	eb 13                	jmp    80104c57 <memmove+0x48>
80104c44:	83 6d fc 01          	subl   $0x1,-0x4(%ebp)
80104c48:	83 6d f8 01          	subl   $0x1,-0x8(%ebp)
80104c4c:	8b 45 fc             	mov    -0x4(%ebp),%eax
80104c4f:	0f b6 10             	movzbl (%eax),%edx
80104c52:	8b 45 f8             	mov    -0x8(%ebp),%eax
80104c55:	88 10                	mov    %dl,(%eax)
80104c57:	8b 45 10             	mov    0x10(%ebp),%eax
80104c5a:	8d 50 ff             	lea    -0x1(%eax),%edx
80104c5d:	89 55 10             	mov    %edx,0x10(%ebp)
80104c60:	85 c0                	test   %eax,%eax
80104c62:	75 e0                	jne    80104c44 <memmove+0x35>
80104c64:	eb 24                	jmp    80104c8a <memmove+0x7b>
80104c66:	8b 55 fc             	mov    -0x4(%ebp),%edx
80104c69:	8d 42 01             	lea    0x1(%edx),%eax
80104c6c:	89 45 fc             	mov    %eax,-0x4(%ebp)
80104c6f:	8b 45 f8             	mov    -0x8(%ebp),%eax
80104c72:	8d 48 01             	lea    0x1(%eax),%ecx
80104c75:	89 4d f8             	mov    %ecx,-0x8(%ebp)
80104c78:	0f b6 12             	movzbl (%edx),%edx
80104c7b:	88 10                	mov    %dl,(%eax)
80104c7d:	8b 45 10             	mov    0x10(%ebp),%eax
80104c80:	8d 50 ff             	lea    -0x1(%eax),%edx
80104c83:	89 55 10             	mov    %edx,0x10(%ebp)
80104c86:	85 c0                	test   %eax,%eax
80104c88:	75 dc                	jne    80104c66 <memmove+0x57>
80104c8a:	8b 45 08             	mov    0x8(%ebp),%eax
80104c8d:	c9                   	leave  
80104c8e:	c3                   	ret    

80104c8f <memcpy>:
80104c8f:	55                   	push   %ebp
80104c90:	89 e5                	mov    %esp,%ebp
80104c92:	ff 75 10             	push   0x10(%ebp)
80104c95:	ff 75 0c             	push   0xc(%ebp)
80104c98:	ff 75 08             	push   0x8(%ebp)
80104c9b:	e8 6f ff ff ff       	call   80104c0f <memmove>
80104ca0:	83 c4 0c             	add    $0xc,%esp
80104ca3:	c9                   	leave  
80104ca4:	c3                   	ret    

80104ca5 <strncmp>:
80104ca5:	55                   	push   %ebp
80104ca6:	89 e5                	mov    %esp,%ebp
80104ca8:	eb 0c                	jmp    80104cb6 <strncmp+0x11>
80104caa:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
80104cae:	83 45 08 01          	addl   $0x1,0x8(%ebp)
80104cb2:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
80104cb6:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
80104cba:	74 1a                	je     80104cd6 <strncmp+0x31>
80104cbc:	8b 45 08             	mov    0x8(%ebp),%eax
80104cbf:	0f b6 00             	movzbl (%eax),%eax
80104cc2:	84 c0                	test   %al,%al
80104cc4:	74 10                	je     80104cd6 <strncmp+0x31>
80104cc6:	8b 45 08             	mov    0x8(%ebp),%eax
80104cc9:	0f b6 10             	movzbl (%eax),%edx
80104ccc:	8b 45 0c             	mov    0xc(%ebp),%eax
80104ccf:	0f b6 00             	movzbl (%eax),%eax
80104cd2:	38 c2                	cmp    %al,%dl
80104cd4:	74 d4                	je     80104caa <strncmp+0x5>
80104cd6:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
80104cda:	75 07                	jne    80104ce3 <strncmp+0x3e>
80104cdc:	b8 00 00 00 00       	mov    $0x0,%eax
80104ce1:	eb 16                	jmp    80104cf9 <strncmp+0x54>
80104ce3:	8b 45 08             	mov    0x8(%ebp),%eax
80104ce6:	0f b6 00             	movzbl (%eax),%eax
80104ce9:	0f b6 d0             	movzbl %al,%edx
80104cec:	8b 45 0c             	mov    0xc(%ebp),%eax
80104cef:	0f b6 00             	movzbl (%eax),%eax
80104cf2:	0f b6 c8             	movzbl %al,%ecx
80104cf5:	89 d0                	mov    %edx,%eax
80104cf7:	29 c8                	sub    %ecx,%eax
80104cf9:	5d                   	pop    %ebp
80104cfa:	c3                   	ret    

80104cfb <strncpy>:
80104cfb:	55                   	push   %ebp
80104cfc:	89 e5                	mov    %esp,%ebp
80104cfe:	83 ec 10             	sub    $0x10,%esp
80104d01:	8b 45 08             	mov    0x8(%ebp),%eax
80104d04:	89 45 fc             	mov    %eax,-0x4(%ebp)
80104d07:	90                   	nop
80104d08:	8b 45 10             	mov    0x10(%ebp),%eax
80104d0b:	8d 50 ff             	lea    -0x1(%eax),%edx
80104d0e:	89 55 10             	mov    %edx,0x10(%ebp)
80104d11:	85 c0                	test   %eax,%eax
80104d13:	7e 2c                	jle    80104d41 <strncpy+0x46>
80104d15:	8b 55 0c             	mov    0xc(%ebp),%edx
80104d18:	8d 42 01             	lea    0x1(%edx),%eax
80104d1b:	89 45 0c             	mov    %eax,0xc(%ebp)
80104d1e:	8b 45 08             	mov    0x8(%ebp),%eax
80104d21:	8d 48 01             	lea    0x1(%eax),%ecx
80104d24:	89 4d 08             	mov    %ecx,0x8(%ebp)
80104d27:	0f b6 12             	movzbl (%edx),%edx
80104d2a:	88 10                	mov    %dl,(%eax)
80104d2c:	0f b6 00             	movzbl (%eax),%eax
80104d2f:	84 c0                	test   %al,%al
80104d31:	75 d5                	jne    80104d08 <strncpy+0xd>
80104d33:	eb 0c                	jmp    80104d41 <strncpy+0x46>
80104d35:	8b 45 08             	mov    0x8(%ebp),%eax
80104d38:	8d 50 01             	lea    0x1(%eax),%edx
80104d3b:	89 55 08             	mov    %edx,0x8(%ebp)
80104d3e:	c6 00 00             	movb   $0x0,(%eax)
80104d41:	8b 45 10             	mov    0x10(%ebp),%eax
80104d44:	8d 50 ff             	lea    -0x1(%eax),%edx
80104d47:	89 55 10             	mov    %edx,0x10(%ebp)
80104d4a:	85 c0                	test   %eax,%eax
80104d4c:	7f e7                	jg     80104d35 <strncpy+0x3a>
80104d4e:	8b 45 fc             	mov    -0x4(%ebp),%eax
80104d51:	c9                   	leave  
80104d52:	c3                   	ret    

80104d53 <safestrcpy>:
80104d53:	55                   	push   %ebp
80104d54:	89 e5                	mov    %esp,%ebp
80104d56:	83 ec 10             	sub    $0x10,%esp
80104d59:	8b 45 08             	mov    0x8(%ebp),%eax
80104d5c:	89 45 fc             	mov    %eax,-0x4(%ebp)
80104d5f:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
80104d63:	7f 05                	jg     80104d6a <safestrcpy+0x17>
80104d65:	8b 45 fc             	mov    -0x4(%ebp),%eax
80104d68:	eb 32                	jmp    80104d9c <safestrcpy+0x49>
80104d6a:	90                   	nop
80104d6b:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
80104d6f:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
80104d73:	7e 1e                	jle    80104d93 <safestrcpy+0x40>
80104d75:	8b 55 0c             	mov    0xc(%ebp),%edx
80104d78:	8d 42 01             	lea    0x1(%edx),%eax
80104d7b:	89 45 0c             	mov    %eax,0xc(%ebp)
80104d7e:	8b 45 08             	mov    0x8(%ebp),%eax
80104d81:	8d 48 01             	lea    0x1(%eax),%ecx
80104d84:	89 4d 08             	mov    %ecx,0x8(%ebp)
80104d87:	0f b6 12             	movzbl (%edx),%edx
80104d8a:	88 10                	mov    %dl,(%eax)
80104d8c:	0f b6 00             	movzbl (%eax),%eax
80104d8f:	84 c0                	test   %al,%al
80104d91:	75 d8                	jne    80104d6b <safestrcpy+0x18>
80104d93:	8b 45 08             	mov    0x8(%ebp),%eax
80104d96:	c6 00 00             	movb   $0x0,(%eax)
80104d99:	8b 45 fc             	mov    -0x4(%ebp),%eax
80104d9c:	c9                   	leave  
80104d9d:	c3                   	ret    

80104d9e <strlen>:
80104d9e:	55                   	push   %ebp
80104d9f:	89 e5                	mov    %esp,%ebp
80104da1:	83 ec 10             	sub    $0x10,%esp
80104da4:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
80104dab:	eb 04                	jmp    80104db1 <strlen+0x13>
80104dad:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
80104db1:	8b 55 fc             	mov    -0x4(%ebp),%edx
80104db4:	8b 45 08             	mov    0x8(%ebp),%eax
80104db7:	01 d0                	add    %edx,%eax
80104db9:	0f b6 00             	movzbl (%eax),%eax
80104dbc:	84 c0                	test   %al,%al
80104dbe:	75 ed                	jne    80104dad <strlen+0xf>
80104dc0:	8b 45 fc             	mov    -0x4(%ebp),%eax
80104dc3:	c9                   	leave  
80104dc4:	c3                   	ret    

80104dc5 <swtch>:
80104dc5:	8b 44 24 04          	mov    0x4(%esp),%eax
80104dc9:	8b 54 24 08          	mov    0x8(%esp),%edx
80104dcd:	55                   	push   %ebp
80104dce:	53                   	push   %ebx
80104dcf:	56                   	push   %esi
80104dd0:	57                   	push   %edi
80104dd1:	89 20                	mov    %esp,(%eax)
80104dd3:	89 d4                	mov    %edx,%esp
80104dd5:	5f                   	pop    %edi
80104dd6:	5e                   	pop    %esi
80104dd7:	5b                   	pop    %ebx
80104dd8:	5d                   	pop    %ebp
80104dd9:	c3                   	ret    

80104dda <fetchint>:


// Fetch the int at addr from the current process.
int
fetchint(uint addr, int *ip)
{
80104dda:	55                   	push   %ebp
80104ddb:	89 e5                	mov    %esp,%ebp
80104ddd:	83 ec 18             	sub    $0x18,%esp
  struct proc *curproc = myproc();
80104de0:	e8 31 ee ff ff       	call   80103c16 <myproc>
80104de5:	89 45 f4             	mov    %eax,-0xc(%ebp)

  if(addr >= curproc->sz || addr+4 > curproc->sz)
80104de8:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104deb:	8b 00                	mov    (%eax),%eax
80104ded:	39 45 08             	cmp    %eax,0x8(%ebp)
80104df0:	73 0f                	jae    80104e01 <fetchint+0x27>
80104df2:	8b 45 08             	mov    0x8(%ebp),%eax
80104df5:	8d 50 04             	lea    0x4(%eax),%edx
80104df8:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104dfb:	8b 00                	mov    (%eax),%eax
80104dfd:	39 c2                	cmp    %eax,%edx
80104dff:	76 07                	jbe    80104e08 <fetchint+0x2e>
    return -1;
80104e01:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104e06:	eb 0f                	jmp    80104e17 <fetchint+0x3d>
  *ip = *(int*)(addr);
80104e08:	8b 45 08             	mov    0x8(%ebp),%eax
80104e0b:	8b 10                	mov    (%eax),%edx
80104e0d:	8b 45 0c             	mov    0xc(%ebp),%eax
80104e10:	89 10                	mov    %edx,(%eax)
  return 0;
80104e12:	b8 00 00 00 00       	mov    $0x0,%eax
}
80104e17:	c9                   	leave  
80104e18:	c3                   	ret    

80104e19 <fetchstr>:
// Fetch the nul-terminated string at addr from the current process.
// Doesn't actually copy the string - just sets *pp to point at it.
// Returns length of string, not including nul.
int
fetchstr(uint addr, char **pp)
{
80104e19:	55                   	push   %ebp
80104e1a:	89 e5                	mov    %esp,%ebp
80104e1c:	83 ec 18             	sub    $0x18,%esp
  char *s, *ep;
  struct proc *curproc = myproc();
80104e1f:	e8 f2 ed ff ff       	call   80103c16 <myproc>
80104e24:	89 45 f0             	mov    %eax,-0x10(%ebp)

  if(addr >= curproc->sz)
80104e27:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104e2a:	8b 00                	mov    (%eax),%eax
80104e2c:	39 45 08             	cmp    %eax,0x8(%ebp)
80104e2f:	72 07                	jb     80104e38 <fetchstr+0x1f>
    return -1;
80104e31:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104e36:	eb 41                	jmp    80104e79 <fetchstr+0x60>
  *pp = (char*)addr;
80104e38:	8b 55 08             	mov    0x8(%ebp),%edx
80104e3b:	8b 45 0c             	mov    0xc(%ebp),%eax
80104e3e:	89 10                	mov    %edx,(%eax)
  ep = (char*)curproc->sz;
80104e40:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104e43:	8b 00                	mov    (%eax),%eax
80104e45:	89 45 ec             	mov    %eax,-0x14(%ebp)
  for(s = *pp; s < ep; s++){
80104e48:	8b 45 0c             	mov    0xc(%ebp),%eax
80104e4b:	8b 00                	mov    (%eax),%eax
80104e4d:	89 45 f4             	mov    %eax,-0xc(%ebp)
80104e50:	eb 1a                	jmp    80104e6c <fetchstr+0x53>
    if(*s == 0)
80104e52:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104e55:	0f b6 00             	movzbl (%eax),%eax
80104e58:	84 c0                	test   %al,%al
80104e5a:	75 0c                	jne    80104e68 <fetchstr+0x4f>
      return s - *pp;
80104e5c:	8b 45 0c             	mov    0xc(%ebp),%eax
80104e5f:	8b 10                	mov    (%eax),%edx
80104e61:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104e64:	29 d0                	sub    %edx,%eax
80104e66:	eb 11                	jmp    80104e79 <fetchstr+0x60>
  for(s = *pp; s < ep; s++){
80104e68:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80104e6c:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104e6f:	3b 45 ec             	cmp    -0x14(%ebp),%eax
80104e72:	72 de                	jb     80104e52 <fetchstr+0x39>
  }
  return -1;
80104e74:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104e79:	c9                   	leave  
80104e7a:	c3                   	ret    

80104e7b <argint>:

// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
80104e7b:	55                   	push   %ebp
80104e7c:	89 e5                	mov    %esp,%ebp
80104e7e:	83 ec 08             	sub    $0x8,%esp
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80104e81:	e8 90 ed ff ff       	call   80103c16 <myproc>
80104e86:	8b 40 18             	mov    0x18(%eax),%eax
80104e89:	8b 50 44             	mov    0x44(%eax),%edx
80104e8c:	8b 45 08             	mov    0x8(%ebp),%eax
80104e8f:	c1 e0 02             	shl    $0x2,%eax
80104e92:	01 d0                	add    %edx,%eax
80104e94:	83 c0 04             	add    $0x4,%eax
80104e97:	83 ec 08             	sub    $0x8,%esp
80104e9a:	ff 75 0c             	push   0xc(%ebp)
80104e9d:	50                   	push   %eax
80104e9e:	e8 37 ff ff ff       	call   80104dda <fetchint>
80104ea3:	83 c4 10             	add    $0x10,%esp
}
80104ea6:	c9                   	leave  
80104ea7:	c3                   	ret    

80104ea8 <argptr>:
// Fetch the nth word-sized system call argument as a pointer
// to a block of memory of size bytes.  Check that the pointer
// lies within the process address space.
int
argptr(int n, char **pp, int size)
{
80104ea8:	55                   	push   %ebp
80104ea9:	89 e5                	mov    %esp,%ebp
80104eab:	83 ec 18             	sub    $0x18,%esp
  int i;
  struct proc *curproc = myproc();
80104eae:	e8 63 ed ff ff       	call   80103c16 <myproc>
80104eb3:	89 45 f4             	mov    %eax,-0xc(%ebp)
 
  if(argint(n, &i) < 0)
80104eb6:	83 ec 08             	sub    $0x8,%esp
80104eb9:	8d 45 f0             	lea    -0x10(%ebp),%eax
80104ebc:	50                   	push   %eax
80104ebd:	ff 75 08             	push   0x8(%ebp)
80104ec0:	e8 b6 ff ff ff       	call   80104e7b <argint>
80104ec5:	83 c4 10             	add    $0x10,%esp
80104ec8:	85 c0                	test   %eax,%eax
80104eca:	79 07                	jns    80104ed3 <argptr+0x2b>
    return -1;
80104ecc:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104ed1:	eb 3b                	jmp    80104f0e <argptr+0x66>
  if(size < 0 || (uint)i >= curproc->sz || (uint)i+size > curproc->sz)
80104ed3:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
80104ed7:	78 1f                	js     80104ef8 <argptr+0x50>
80104ed9:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104edc:	8b 00                	mov    (%eax),%eax
80104ede:	8b 55 f0             	mov    -0x10(%ebp),%edx
80104ee1:	39 d0                	cmp    %edx,%eax
80104ee3:	76 13                	jbe    80104ef8 <argptr+0x50>
80104ee5:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104ee8:	89 c2                	mov    %eax,%edx
80104eea:	8b 45 10             	mov    0x10(%ebp),%eax
80104eed:	01 c2                	add    %eax,%edx
80104eef:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104ef2:	8b 00                	mov    (%eax),%eax
80104ef4:	39 c2                	cmp    %eax,%edx
80104ef6:	76 07                	jbe    80104eff <argptr+0x57>
    return -1;
80104ef8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104efd:	eb 0f                	jmp    80104f0e <argptr+0x66>
  *pp = (char*)i;
80104eff:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104f02:	89 c2                	mov    %eax,%edx
80104f04:	8b 45 0c             	mov    0xc(%ebp),%eax
80104f07:	89 10                	mov    %edx,(%eax)
  return 0;
80104f09:	b8 00 00 00 00       	mov    $0x0,%eax
}
80104f0e:	c9                   	leave  
80104f0f:	c3                   	ret    

80104f10 <argstr>:
// Check that the pointer is valid and the string is nul-terminated.
// (There is no shared writable memory, so the string can't change
// between this check and being used by the kernel.)
int
argstr(int n, char **pp)
{
80104f10:	55                   	push   %ebp
80104f11:	89 e5                	mov    %esp,%ebp
80104f13:	83 ec 18             	sub    $0x18,%esp
  int addr;
  if(argint(n, &addr) < 0)
80104f16:	83 ec 08             	sub    $0x8,%esp
80104f19:	8d 45 f4             	lea    -0xc(%ebp),%eax
80104f1c:	50                   	push   %eax
80104f1d:	ff 75 08             	push   0x8(%ebp)
80104f20:	e8 56 ff ff ff       	call   80104e7b <argint>
80104f25:	83 c4 10             	add    $0x10,%esp
80104f28:	85 c0                	test   %eax,%eax
80104f2a:	79 07                	jns    80104f33 <argstr+0x23>
    return -1;
80104f2c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104f31:	eb 12                	jmp    80104f45 <argstr+0x35>
  return fetchstr(addr, pp);
80104f33:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104f36:	83 ec 08             	sub    $0x8,%esp
80104f39:	ff 75 0c             	push   0xc(%ebp)
80104f3c:	50                   	push   %eax
80104f3d:	e8 d7 fe ff ff       	call   80104e19 <fetchstr>
80104f42:	83 c4 10             	add    $0x10,%esp
}
80104f45:	c9                   	leave  
80104f46:	c3                   	ret    

80104f47 <syscall>:
[SYS_printpt]  sys_printpt
};

void
syscall(void)
{
80104f47:	55                   	push   %ebp
80104f48:	89 e5                	mov    %esp,%ebp
80104f4a:	83 ec 18             	sub    $0x18,%esp
  int num;
  struct proc *curproc = myproc();
80104f4d:	e8 c4 ec ff ff       	call   80103c16 <myproc>
80104f52:	89 45 f4             	mov    %eax,-0xc(%ebp)

  num = curproc->tf->eax;
80104f55:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104f58:	8b 40 18             	mov    0x18(%eax),%eax
80104f5b:	8b 40 1c             	mov    0x1c(%eax),%eax
80104f5e:	89 45 f0             	mov    %eax,-0x10(%ebp)
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
80104f61:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80104f65:	7e 2f                	jle    80104f96 <syscall+0x4f>
80104f67:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104f6a:	83 f8 16             	cmp    $0x16,%eax
80104f6d:	77 27                	ja     80104f96 <syscall+0x4f>
80104f6f:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104f72:	8b 04 85 20 f0 10 80 	mov    -0x7fef0fe0(,%eax,4),%eax
80104f79:	85 c0                	test   %eax,%eax
80104f7b:	74 19                	je     80104f96 <syscall+0x4f>
    curproc->tf->eax = syscalls[num]();
80104f7d:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104f80:	8b 04 85 20 f0 10 80 	mov    -0x7fef0fe0(,%eax,4),%eax
80104f87:	ff d0                	call   *%eax
80104f89:	89 c2                	mov    %eax,%edx
80104f8b:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104f8e:	8b 40 18             	mov    0x18(%eax),%eax
80104f91:	89 50 1c             	mov    %edx,0x1c(%eax)
80104f94:	eb 2c                	jmp    80104fc2 <syscall+0x7b>
  } else {
    cprintf("%d %s: unknown sys call %d\n",
            curproc->pid, curproc->name, num);
80104f96:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104f99:	8d 50 6c             	lea    0x6c(%eax),%edx
    cprintf("%d %s: unknown sys call %d\n",
80104f9c:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104f9f:	8b 40 10             	mov    0x10(%eax),%eax
80104fa2:	ff 75 f0             	push   -0x10(%ebp)
80104fa5:	52                   	push   %edx
80104fa6:	50                   	push   %eax
80104fa7:	68 98 a5 10 80       	push   $0x8010a598
80104fac:	e8 43 b4 ff ff       	call   801003f4 <cprintf>
80104fb1:	83 c4 10             	add    $0x10,%esp
    curproc->tf->eax = -1;
80104fb4:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104fb7:	8b 40 18             	mov    0x18(%eax),%eax
80104fba:	c7 40 1c ff ff ff ff 	movl   $0xffffffff,0x1c(%eax)
  }
}
80104fc1:	90                   	nop
80104fc2:	90                   	nop
80104fc3:	c9                   	leave  
80104fc4:	c3                   	ret    

80104fc5 <argfd>:

// Fetch the nth word-sized system call argument as a file descriptor
// and return both the descriptor and the corresponding struct file.
static int
argfd(int n, int *pfd, struct file **pf)
{
80104fc5:	55                   	push   %ebp
80104fc6:	89 e5                	mov    %esp,%ebp
80104fc8:	83 ec 18             	sub    $0x18,%esp
  int fd;
  struct file *f;

  if(argint(n, &fd) < 0)
80104fcb:	83 ec 08             	sub    $0x8,%esp
80104fce:	8d 45 f0             	lea    -0x10(%ebp),%eax
80104fd1:	50                   	push   %eax
80104fd2:	ff 75 08             	push   0x8(%ebp)
80104fd5:	e8 a1 fe ff ff       	call   80104e7b <argint>
80104fda:	83 c4 10             	add    $0x10,%esp
80104fdd:	85 c0                	test   %eax,%eax
80104fdf:	79 07                	jns    80104fe8 <argfd+0x23>
    return -1;
80104fe1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104fe6:	eb 4f                	jmp    80105037 <argfd+0x72>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
80104fe8:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104feb:	85 c0                	test   %eax,%eax
80104fed:	78 20                	js     8010500f <argfd+0x4a>
80104fef:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104ff2:	83 f8 0f             	cmp    $0xf,%eax
80104ff5:	7f 18                	jg     8010500f <argfd+0x4a>
80104ff7:	e8 1a ec ff ff       	call   80103c16 <myproc>
80104ffc:	8b 55 f0             	mov    -0x10(%ebp),%edx
80104fff:	83 c2 08             	add    $0x8,%edx
80105002:	8b 44 90 08          	mov    0x8(%eax,%edx,4),%eax
80105006:	89 45 f4             	mov    %eax,-0xc(%ebp)
80105009:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
8010500d:	75 07                	jne    80105016 <argfd+0x51>
    return -1;
8010500f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105014:	eb 21                	jmp    80105037 <argfd+0x72>
  if(pfd)
80105016:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
8010501a:	74 08                	je     80105024 <argfd+0x5f>
    *pfd = fd;
8010501c:	8b 55 f0             	mov    -0x10(%ebp),%edx
8010501f:	8b 45 0c             	mov    0xc(%ebp),%eax
80105022:	89 10                	mov    %edx,(%eax)
  if(pf)
80105024:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
80105028:	74 08                	je     80105032 <argfd+0x6d>
    *pf = f;
8010502a:	8b 45 10             	mov    0x10(%ebp),%eax
8010502d:	8b 55 f4             	mov    -0xc(%ebp),%edx
80105030:	89 10                	mov    %edx,(%eax)
  return 0;
80105032:	b8 00 00 00 00       	mov    $0x0,%eax
}
80105037:	c9                   	leave  
80105038:	c3                   	ret    

80105039 <fdalloc>:

// Allocate a file descriptor for the given file.
// Takes over file reference from caller on success.
static int
fdalloc(struct file *f)
{
80105039:	55                   	push   %ebp
8010503a:	89 e5                	mov    %esp,%ebp
8010503c:	83 ec 18             	sub    $0x18,%esp
  int fd;
  struct proc *curproc = myproc();
8010503f:	e8 d2 eb ff ff       	call   80103c16 <myproc>
80105044:	89 45 f0             	mov    %eax,-0x10(%ebp)

  for(fd = 0; fd < NOFILE; fd++){
80105047:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
8010504e:	eb 2a                	jmp    8010507a <fdalloc+0x41>
    if(curproc->ofile[fd] == 0){
80105050:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105053:	8b 55 f4             	mov    -0xc(%ebp),%edx
80105056:	83 c2 08             	add    $0x8,%edx
80105059:	8b 44 90 08          	mov    0x8(%eax,%edx,4),%eax
8010505d:	85 c0                	test   %eax,%eax
8010505f:	75 15                	jne    80105076 <fdalloc+0x3d>
      curproc->ofile[fd] = f;
80105061:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105064:	8b 55 f4             	mov    -0xc(%ebp),%edx
80105067:	8d 4a 08             	lea    0x8(%edx),%ecx
8010506a:	8b 55 08             	mov    0x8(%ebp),%edx
8010506d:	89 54 88 08          	mov    %edx,0x8(%eax,%ecx,4)
      return fd;
80105071:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105074:	eb 0f                	jmp    80105085 <fdalloc+0x4c>
  for(fd = 0; fd < NOFILE; fd++){
80105076:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
8010507a:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
8010507e:	7e d0                	jle    80105050 <fdalloc+0x17>
    }
  }
  return -1;
80105080:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105085:	c9                   	leave  
80105086:	c3                   	ret    

80105087 <sys_dup>:

int
sys_dup(void)
{
80105087:	55                   	push   %ebp
80105088:	89 e5                	mov    %esp,%ebp
8010508a:	83 ec 18             	sub    $0x18,%esp
  struct file *f;
  int fd;

  if(argfd(0, 0, &f) < 0)
8010508d:	83 ec 04             	sub    $0x4,%esp
80105090:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105093:	50                   	push   %eax
80105094:	6a 00                	push   $0x0
80105096:	6a 00                	push   $0x0
80105098:	e8 28 ff ff ff       	call   80104fc5 <argfd>
8010509d:	83 c4 10             	add    $0x10,%esp
801050a0:	85 c0                	test   %eax,%eax
801050a2:	79 07                	jns    801050ab <sys_dup+0x24>
    return -1;
801050a4:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801050a9:	eb 31                	jmp    801050dc <sys_dup+0x55>
  if((fd=fdalloc(f)) < 0)
801050ab:	8b 45 f0             	mov    -0x10(%ebp),%eax
801050ae:	83 ec 0c             	sub    $0xc,%esp
801050b1:	50                   	push   %eax
801050b2:	e8 82 ff ff ff       	call   80105039 <fdalloc>
801050b7:	83 c4 10             	add    $0x10,%esp
801050ba:	89 45 f4             	mov    %eax,-0xc(%ebp)
801050bd:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801050c1:	79 07                	jns    801050ca <sys_dup+0x43>
    return -1;
801050c3:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801050c8:	eb 12                	jmp    801050dc <sys_dup+0x55>
  filedup(f);
801050ca:	8b 45 f0             	mov    -0x10(%ebp),%eax
801050cd:	83 ec 0c             	sub    $0xc,%esp
801050d0:	50                   	push   %eax
801050d1:	e8 74 bf ff ff       	call   8010104a <filedup>
801050d6:	83 c4 10             	add    $0x10,%esp
  return fd;
801050d9:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
801050dc:	c9                   	leave  
801050dd:	c3                   	ret    

801050de <sys_read>:

int
sys_read(void)
{
801050de:	55                   	push   %ebp
801050df:	89 e5                	mov    %esp,%ebp
801050e1:	83 ec 18             	sub    $0x18,%esp
  struct file *f;
  int n;
  char *p;

  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
801050e4:	83 ec 04             	sub    $0x4,%esp
801050e7:	8d 45 f4             	lea    -0xc(%ebp),%eax
801050ea:	50                   	push   %eax
801050eb:	6a 00                	push   $0x0
801050ed:	6a 00                	push   $0x0
801050ef:	e8 d1 fe ff ff       	call   80104fc5 <argfd>
801050f4:	83 c4 10             	add    $0x10,%esp
801050f7:	85 c0                	test   %eax,%eax
801050f9:	78 2e                	js     80105129 <sys_read+0x4b>
801050fb:	83 ec 08             	sub    $0x8,%esp
801050fe:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105101:	50                   	push   %eax
80105102:	6a 02                	push   $0x2
80105104:	e8 72 fd ff ff       	call   80104e7b <argint>
80105109:	83 c4 10             	add    $0x10,%esp
8010510c:	85 c0                	test   %eax,%eax
8010510e:	78 19                	js     80105129 <sys_read+0x4b>
80105110:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105113:	83 ec 04             	sub    $0x4,%esp
80105116:	50                   	push   %eax
80105117:	8d 45 ec             	lea    -0x14(%ebp),%eax
8010511a:	50                   	push   %eax
8010511b:	6a 01                	push   $0x1
8010511d:	e8 86 fd ff ff       	call   80104ea8 <argptr>
80105122:	83 c4 10             	add    $0x10,%esp
80105125:	85 c0                	test   %eax,%eax
80105127:	79 07                	jns    80105130 <sys_read+0x52>
    return -1;
80105129:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010512e:	eb 17                	jmp    80105147 <sys_read+0x69>
  return fileread(f, p, n);
80105130:	8b 4d f0             	mov    -0x10(%ebp),%ecx
80105133:	8b 55 ec             	mov    -0x14(%ebp),%edx
80105136:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105139:	83 ec 04             	sub    $0x4,%esp
8010513c:	51                   	push   %ecx
8010513d:	52                   	push   %edx
8010513e:	50                   	push   %eax
8010513f:	e8 96 c0 ff ff       	call   801011da <fileread>
80105144:	83 c4 10             	add    $0x10,%esp
}
80105147:	c9                   	leave  
80105148:	c3                   	ret    

80105149 <sys_write>:

int
sys_write(void)
{
80105149:	55                   	push   %ebp
8010514a:	89 e5                	mov    %esp,%ebp
8010514c:	83 ec 18             	sub    $0x18,%esp
  struct file *f;
  int n;
  char *p;

  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
8010514f:	83 ec 04             	sub    $0x4,%esp
80105152:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105155:	50                   	push   %eax
80105156:	6a 00                	push   $0x0
80105158:	6a 00                	push   $0x0
8010515a:	e8 66 fe ff ff       	call   80104fc5 <argfd>
8010515f:	83 c4 10             	add    $0x10,%esp
80105162:	85 c0                	test   %eax,%eax
80105164:	78 2e                	js     80105194 <sys_write+0x4b>
80105166:	83 ec 08             	sub    $0x8,%esp
80105169:	8d 45 f0             	lea    -0x10(%ebp),%eax
8010516c:	50                   	push   %eax
8010516d:	6a 02                	push   $0x2
8010516f:	e8 07 fd ff ff       	call   80104e7b <argint>
80105174:	83 c4 10             	add    $0x10,%esp
80105177:	85 c0                	test   %eax,%eax
80105179:	78 19                	js     80105194 <sys_write+0x4b>
8010517b:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010517e:	83 ec 04             	sub    $0x4,%esp
80105181:	50                   	push   %eax
80105182:	8d 45 ec             	lea    -0x14(%ebp),%eax
80105185:	50                   	push   %eax
80105186:	6a 01                	push   $0x1
80105188:	e8 1b fd ff ff       	call   80104ea8 <argptr>
8010518d:	83 c4 10             	add    $0x10,%esp
80105190:	85 c0                	test   %eax,%eax
80105192:	79 07                	jns    8010519b <sys_write+0x52>
    return -1;
80105194:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105199:	eb 17                	jmp    801051b2 <sys_write+0x69>
  return filewrite(f, p, n);
8010519b:	8b 4d f0             	mov    -0x10(%ebp),%ecx
8010519e:	8b 55 ec             	mov    -0x14(%ebp),%edx
801051a1:	8b 45 f4             	mov    -0xc(%ebp),%eax
801051a4:	83 ec 04             	sub    $0x4,%esp
801051a7:	51                   	push   %ecx
801051a8:	52                   	push   %edx
801051a9:	50                   	push   %eax
801051aa:	e8 e3 c0 ff ff       	call   80101292 <filewrite>
801051af:	83 c4 10             	add    $0x10,%esp
}
801051b2:	c9                   	leave  
801051b3:	c3                   	ret    

801051b4 <sys_close>:

int
sys_close(void)
{
801051b4:	55                   	push   %ebp
801051b5:	89 e5                	mov    %esp,%ebp
801051b7:	83 ec 18             	sub    $0x18,%esp
  int fd;
  struct file *f;

  if(argfd(0, &fd, &f) < 0)
801051ba:	83 ec 04             	sub    $0x4,%esp
801051bd:	8d 45 f0             	lea    -0x10(%ebp),%eax
801051c0:	50                   	push   %eax
801051c1:	8d 45 f4             	lea    -0xc(%ebp),%eax
801051c4:	50                   	push   %eax
801051c5:	6a 00                	push   $0x0
801051c7:	e8 f9 fd ff ff       	call   80104fc5 <argfd>
801051cc:	83 c4 10             	add    $0x10,%esp
801051cf:	85 c0                	test   %eax,%eax
801051d1:	79 07                	jns    801051da <sys_close+0x26>
    return -1;
801051d3:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801051d8:	eb 27                	jmp    80105201 <sys_close+0x4d>
  myproc()->ofile[fd] = 0;
801051da:	e8 37 ea ff ff       	call   80103c16 <myproc>
801051df:	8b 55 f4             	mov    -0xc(%ebp),%edx
801051e2:	83 c2 08             	add    $0x8,%edx
801051e5:	c7 44 90 08 00 00 00 	movl   $0x0,0x8(%eax,%edx,4)
801051ec:	00 
  fileclose(f);
801051ed:	8b 45 f0             	mov    -0x10(%ebp),%eax
801051f0:	83 ec 0c             	sub    $0xc,%esp
801051f3:	50                   	push   %eax
801051f4:	e8 a2 be ff ff       	call   8010109b <fileclose>
801051f9:	83 c4 10             	add    $0x10,%esp
  return 0;
801051fc:	b8 00 00 00 00       	mov    $0x0,%eax
}
80105201:	c9                   	leave  
80105202:	c3                   	ret    

80105203 <sys_fstat>:

int
sys_fstat(void)
{
80105203:	55                   	push   %ebp
80105204:	89 e5                	mov    %esp,%ebp
80105206:	83 ec 18             	sub    $0x18,%esp
  struct file *f;
  struct stat *st;

  if(argfd(0, 0, &f) < 0 || argptr(1, (void*)&st, sizeof(*st)) < 0)
80105209:	83 ec 04             	sub    $0x4,%esp
8010520c:	8d 45 f4             	lea    -0xc(%ebp),%eax
8010520f:	50                   	push   %eax
80105210:	6a 00                	push   $0x0
80105212:	6a 00                	push   $0x0
80105214:	e8 ac fd ff ff       	call   80104fc5 <argfd>
80105219:	83 c4 10             	add    $0x10,%esp
8010521c:	85 c0                	test   %eax,%eax
8010521e:	78 17                	js     80105237 <sys_fstat+0x34>
80105220:	83 ec 04             	sub    $0x4,%esp
80105223:	6a 14                	push   $0x14
80105225:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105228:	50                   	push   %eax
80105229:	6a 01                	push   $0x1
8010522b:	e8 78 fc ff ff       	call   80104ea8 <argptr>
80105230:	83 c4 10             	add    $0x10,%esp
80105233:	85 c0                	test   %eax,%eax
80105235:	79 07                	jns    8010523e <sys_fstat+0x3b>
    return -1;
80105237:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010523c:	eb 13                	jmp    80105251 <sys_fstat+0x4e>
  return filestat(f, st);
8010523e:	8b 55 f0             	mov    -0x10(%ebp),%edx
80105241:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105244:	83 ec 08             	sub    $0x8,%esp
80105247:	52                   	push   %edx
80105248:	50                   	push   %eax
80105249:	e8 35 bf ff ff       	call   80101183 <filestat>
8010524e:	83 c4 10             	add    $0x10,%esp
}
80105251:	c9                   	leave  
80105252:	c3                   	ret    

80105253 <sys_link>:

// Create the path new as a link to the same inode as old.
int
sys_link(void)
{
80105253:	55                   	push   %ebp
80105254:	89 e5                	mov    %esp,%ebp
80105256:	83 ec 28             	sub    $0x28,%esp
  char name[DIRSIZ], *new, *old;
  struct inode *dp, *ip;

  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
80105259:	83 ec 08             	sub    $0x8,%esp
8010525c:	8d 45 d8             	lea    -0x28(%ebp),%eax
8010525f:	50                   	push   %eax
80105260:	6a 00                	push   $0x0
80105262:	e8 a9 fc ff ff       	call   80104f10 <argstr>
80105267:	83 c4 10             	add    $0x10,%esp
8010526a:	85 c0                	test   %eax,%eax
8010526c:	78 15                	js     80105283 <sys_link+0x30>
8010526e:	83 ec 08             	sub    $0x8,%esp
80105271:	8d 45 dc             	lea    -0x24(%ebp),%eax
80105274:	50                   	push   %eax
80105275:	6a 01                	push   $0x1
80105277:	e8 94 fc ff ff       	call   80104f10 <argstr>
8010527c:	83 c4 10             	add    $0x10,%esp
8010527f:	85 c0                	test   %eax,%eax
80105281:	79 0a                	jns    8010528d <sys_link+0x3a>
    return -1;
80105283:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105288:	e9 68 01 00 00       	jmp    801053f5 <sys_link+0x1a2>

  begin_op();
8010528d:	e8 aa dd ff ff       	call   8010303c <begin_op>
  if((ip = namei(old)) == 0){
80105292:	8b 45 d8             	mov    -0x28(%ebp),%eax
80105295:	83 ec 0c             	sub    $0xc,%esp
80105298:	50                   	push   %eax
80105299:	e8 7f d2 ff ff       	call   8010251d <namei>
8010529e:	83 c4 10             	add    $0x10,%esp
801052a1:	89 45 f4             	mov    %eax,-0xc(%ebp)
801052a4:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801052a8:	75 0f                	jne    801052b9 <sys_link+0x66>
    end_op();
801052aa:	e8 19 de ff ff       	call   801030c8 <end_op>
    return -1;
801052af:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801052b4:	e9 3c 01 00 00       	jmp    801053f5 <sys_link+0x1a2>
  }

  ilock(ip);
801052b9:	83 ec 0c             	sub    $0xc,%esp
801052bc:	ff 75 f4             	push   -0xc(%ebp)
801052bf:	e8 26 c7 ff ff       	call   801019ea <ilock>
801052c4:	83 c4 10             	add    $0x10,%esp
  if(ip->type == T_DIR){
801052c7:	8b 45 f4             	mov    -0xc(%ebp),%eax
801052ca:	0f b7 40 50          	movzwl 0x50(%eax),%eax
801052ce:	66 83 f8 01          	cmp    $0x1,%ax
801052d2:	75 1d                	jne    801052f1 <sys_link+0x9e>
    iunlockput(ip);
801052d4:	83 ec 0c             	sub    $0xc,%esp
801052d7:	ff 75 f4             	push   -0xc(%ebp)
801052da:	e8 3c c9 ff ff       	call   80101c1b <iunlockput>
801052df:	83 c4 10             	add    $0x10,%esp
    end_op();
801052e2:	e8 e1 dd ff ff       	call   801030c8 <end_op>
    return -1;
801052e7:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801052ec:	e9 04 01 00 00       	jmp    801053f5 <sys_link+0x1a2>
  }

  ip->nlink++;
801052f1:	8b 45 f4             	mov    -0xc(%ebp),%eax
801052f4:	0f b7 40 56          	movzwl 0x56(%eax),%eax
801052f8:	83 c0 01             	add    $0x1,%eax
801052fb:	89 c2                	mov    %eax,%edx
801052fd:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105300:	66 89 50 56          	mov    %dx,0x56(%eax)
  iupdate(ip);
80105304:	83 ec 0c             	sub    $0xc,%esp
80105307:	ff 75 f4             	push   -0xc(%ebp)
8010530a:	e8 fe c4 ff ff       	call   8010180d <iupdate>
8010530f:	83 c4 10             	add    $0x10,%esp
  iunlock(ip);
80105312:	83 ec 0c             	sub    $0xc,%esp
80105315:	ff 75 f4             	push   -0xc(%ebp)
80105318:	e8 e0 c7 ff ff       	call   80101afd <iunlock>
8010531d:	83 c4 10             	add    $0x10,%esp

  if((dp = nameiparent(new, name)) == 0)
80105320:	8b 45 dc             	mov    -0x24(%ebp),%eax
80105323:	83 ec 08             	sub    $0x8,%esp
80105326:	8d 55 e2             	lea    -0x1e(%ebp),%edx
80105329:	52                   	push   %edx
8010532a:	50                   	push   %eax
8010532b:	e8 09 d2 ff ff       	call   80102539 <nameiparent>
80105330:	83 c4 10             	add    $0x10,%esp
80105333:	89 45 f0             	mov    %eax,-0x10(%ebp)
80105336:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
8010533a:	74 71                	je     801053ad <sys_link+0x15a>
    goto bad;
  ilock(dp);
8010533c:	83 ec 0c             	sub    $0xc,%esp
8010533f:	ff 75 f0             	push   -0x10(%ebp)
80105342:	e8 a3 c6 ff ff       	call   801019ea <ilock>
80105347:	83 c4 10             	add    $0x10,%esp
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
8010534a:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010534d:	8b 10                	mov    (%eax),%edx
8010534f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105352:	8b 00                	mov    (%eax),%eax
80105354:	39 c2                	cmp    %eax,%edx
80105356:	75 1d                	jne    80105375 <sys_link+0x122>
80105358:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010535b:	8b 40 04             	mov    0x4(%eax),%eax
8010535e:	83 ec 04             	sub    $0x4,%esp
80105361:	50                   	push   %eax
80105362:	8d 45 e2             	lea    -0x1e(%ebp),%eax
80105365:	50                   	push   %eax
80105366:	ff 75 f0             	push   -0x10(%ebp)
80105369:	e8 18 cf ff ff       	call   80102286 <dirlink>
8010536e:	83 c4 10             	add    $0x10,%esp
80105371:	85 c0                	test   %eax,%eax
80105373:	79 10                	jns    80105385 <sys_link+0x132>
    iunlockput(dp);
80105375:	83 ec 0c             	sub    $0xc,%esp
80105378:	ff 75 f0             	push   -0x10(%ebp)
8010537b:	e8 9b c8 ff ff       	call   80101c1b <iunlockput>
80105380:	83 c4 10             	add    $0x10,%esp
    goto bad;
80105383:	eb 29                	jmp    801053ae <sys_link+0x15b>
  }
  iunlockput(dp);
80105385:	83 ec 0c             	sub    $0xc,%esp
80105388:	ff 75 f0             	push   -0x10(%ebp)
8010538b:	e8 8b c8 ff ff       	call   80101c1b <iunlockput>
80105390:	83 c4 10             	add    $0x10,%esp
  iput(ip);
80105393:	83 ec 0c             	sub    $0xc,%esp
80105396:	ff 75 f4             	push   -0xc(%ebp)
80105399:	e8 ad c7 ff ff       	call   80101b4b <iput>
8010539e:	83 c4 10             	add    $0x10,%esp

  end_op();
801053a1:	e8 22 dd ff ff       	call   801030c8 <end_op>

  return 0;
801053a6:	b8 00 00 00 00       	mov    $0x0,%eax
801053ab:	eb 48                	jmp    801053f5 <sys_link+0x1a2>
    goto bad;
801053ad:	90                   	nop

bad:
  ilock(ip);
801053ae:	83 ec 0c             	sub    $0xc,%esp
801053b1:	ff 75 f4             	push   -0xc(%ebp)
801053b4:	e8 31 c6 ff ff       	call   801019ea <ilock>
801053b9:	83 c4 10             	add    $0x10,%esp
  ip->nlink--;
801053bc:	8b 45 f4             	mov    -0xc(%ebp),%eax
801053bf:	0f b7 40 56          	movzwl 0x56(%eax),%eax
801053c3:	83 e8 01             	sub    $0x1,%eax
801053c6:	89 c2                	mov    %eax,%edx
801053c8:	8b 45 f4             	mov    -0xc(%ebp),%eax
801053cb:	66 89 50 56          	mov    %dx,0x56(%eax)
  iupdate(ip);
801053cf:	83 ec 0c             	sub    $0xc,%esp
801053d2:	ff 75 f4             	push   -0xc(%ebp)
801053d5:	e8 33 c4 ff ff       	call   8010180d <iupdate>
801053da:	83 c4 10             	add    $0x10,%esp
  iunlockput(ip);
801053dd:	83 ec 0c             	sub    $0xc,%esp
801053e0:	ff 75 f4             	push   -0xc(%ebp)
801053e3:	e8 33 c8 ff ff       	call   80101c1b <iunlockput>
801053e8:	83 c4 10             	add    $0x10,%esp
  end_op();
801053eb:	e8 d8 dc ff ff       	call   801030c8 <end_op>
  return -1;
801053f0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801053f5:	c9                   	leave  
801053f6:	c3                   	ret    

801053f7 <isdirempty>:

// Is the directory dp empty except for "." and ".." ?
static int
isdirempty(struct inode *dp)
{
801053f7:	55                   	push   %ebp
801053f8:	89 e5                	mov    %esp,%ebp
801053fa:	83 ec 28             	sub    $0x28,%esp
  int off;
  struct dirent de;

  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
801053fd:	c7 45 f4 20 00 00 00 	movl   $0x20,-0xc(%ebp)
80105404:	eb 40                	jmp    80105446 <isdirempty+0x4f>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80105406:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105409:	6a 10                	push   $0x10
8010540b:	50                   	push   %eax
8010540c:	8d 45 e4             	lea    -0x1c(%ebp),%eax
8010540f:	50                   	push   %eax
80105410:	ff 75 08             	push   0x8(%ebp)
80105413:	e8 be ca ff ff       	call   80101ed6 <readi>
80105418:	83 c4 10             	add    $0x10,%esp
8010541b:	83 f8 10             	cmp    $0x10,%eax
8010541e:	74 0d                	je     8010542d <isdirempty+0x36>
      panic("isdirempty: readi");
80105420:	83 ec 0c             	sub    $0xc,%esp
80105423:	68 b4 a5 10 80       	push   $0x8010a5b4
80105428:	e8 7c b1 ff ff       	call   801005a9 <panic>
    if(de.inum != 0)
8010542d:	0f b7 45 e4          	movzwl -0x1c(%ebp),%eax
80105431:	66 85 c0             	test   %ax,%ax
80105434:	74 07                	je     8010543d <isdirempty+0x46>
      return 0;
80105436:	b8 00 00 00 00       	mov    $0x0,%eax
8010543b:	eb 1b                	jmp    80105458 <isdirempty+0x61>
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
8010543d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105440:	83 c0 10             	add    $0x10,%eax
80105443:	89 45 f4             	mov    %eax,-0xc(%ebp)
80105446:	8b 45 08             	mov    0x8(%ebp),%eax
80105449:	8b 50 58             	mov    0x58(%eax),%edx
8010544c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010544f:	39 c2                	cmp    %eax,%edx
80105451:	77 b3                	ja     80105406 <isdirempty+0xf>
  }
  return 1;
80105453:	b8 01 00 00 00       	mov    $0x1,%eax
}
80105458:	c9                   	leave  
80105459:	c3                   	ret    

8010545a <sys_unlink>:

//PAGEBREAK!
int
sys_unlink(void)
{
8010545a:	55                   	push   %ebp
8010545b:	89 e5                	mov    %esp,%ebp
8010545d:	83 ec 38             	sub    $0x38,%esp
  struct inode *ip, *dp;
  struct dirent de;
  char name[DIRSIZ], *path;
  uint off;

  if(argstr(0, &path) < 0)
80105460:	83 ec 08             	sub    $0x8,%esp
80105463:	8d 45 cc             	lea    -0x34(%ebp),%eax
80105466:	50                   	push   %eax
80105467:	6a 00                	push   $0x0
80105469:	e8 a2 fa ff ff       	call   80104f10 <argstr>
8010546e:	83 c4 10             	add    $0x10,%esp
80105471:	85 c0                	test   %eax,%eax
80105473:	79 0a                	jns    8010547f <sys_unlink+0x25>
    return -1;
80105475:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010547a:	e9 bf 01 00 00       	jmp    8010563e <sys_unlink+0x1e4>

  begin_op();
8010547f:	e8 b8 db ff ff       	call   8010303c <begin_op>
  if((dp = nameiparent(path, name)) == 0){
80105484:	8b 45 cc             	mov    -0x34(%ebp),%eax
80105487:	83 ec 08             	sub    $0x8,%esp
8010548a:	8d 55 d2             	lea    -0x2e(%ebp),%edx
8010548d:	52                   	push   %edx
8010548e:	50                   	push   %eax
8010548f:	e8 a5 d0 ff ff       	call   80102539 <nameiparent>
80105494:	83 c4 10             	add    $0x10,%esp
80105497:	89 45 f4             	mov    %eax,-0xc(%ebp)
8010549a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
8010549e:	75 0f                	jne    801054af <sys_unlink+0x55>
    end_op();
801054a0:	e8 23 dc ff ff       	call   801030c8 <end_op>
    return -1;
801054a5:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801054aa:	e9 8f 01 00 00       	jmp    8010563e <sys_unlink+0x1e4>
  }

  ilock(dp);
801054af:	83 ec 0c             	sub    $0xc,%esp
801054b2:	ff 75 f4             	push   -0xc(%ebp)
801054b5:	e8 30 c5 ff ff       	call   801019ea <ilock>
801054ba:	83 c4 10             	add    $0x10,%esp

  // Cannot unlink "." or "..".
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
801054bd:	83 ec 08             	sub    $0x8,%esp
801054c0:	68 c6 a5 10 80       	push   $0x8010a5c6
801054c5:	8d 45 d2             	lea    -0x2e(%ebp),%eax
801054c8:	50                   	push   %eax
801054c9:	e8 e3 cc ff ff       	call   801021b1 <namecmp>
801054ce:	83 c4 10             	add    $0x10,%esp
801054d1:	85 c0                	test   %eax,%eax
801054d3:	0f 84 49 01 00 00    	je     80105622 <sys_unlink+0x1c8>
801054d9:	83 ec 08             	sub    $0x8,%esp
801054dc:	68 c8 a5 10 80       	push   $0x8010a5c8
801054e1:	8d 45 d2             	lea    -0x2e(%ebp),%eax
801054e4:	50                   	push   %eax
801054e5:	e8 c7 cc ff ff       	call   801021b1 <namecmp>
801054ea:	83 c4 10             	add    $0x10,%esp
801054ed:	85 c0                	test   %eax,%eax
801054ef:	0f 84 2d 01 00 00    	je     80105622 <sys_unlink+0x1c8>
    goto bad;

  if((ip = dirlookup(dp, name, &off)) == 0)
801054f5:	83 ec 04             	sub    $0x4,%esp
801054f8:	8d 45 c8             	lea    -0x38(%ebp),%eax
801054fb:	50                   	push   %eax
801054fc:	8d 45 d2             	lea    -0x2e(%ebp),%eax
801054ff:	50                   	push   %eax
80105500:	ff 75 f4             	push   -0xc(%ebp)
80105503:	e8 c4 cc ff ff       	call   801021cc <dirlookup>
80105508:	83 c4 10             	add    $0x10,%esp
8010550b:	89 45 f0             	mov    %eax,-0x10(%ebp)
8010550e:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80105512:	0f 84 0d 01 00 00    	je     80105625 <sys_unlink+0x1cb>
    goto bad;
  ilock(ip);
80105518:	83 ec 0c             	sub    $0xc,%esp
8010551b:	ff 75 f0             	push   -0x10(%ebp)
8010551e:	e8 c7 c4 ff ff       	call   801019ea <ilock>
80105523:	83 c4 10             	add    $0x10,%esp

  if(ip->nlink < 1)
80105526:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105529:	0f b7 40 56          	movzwl 0x56(%eax),%eax
8010552d:	66 85 c0             	test   %ax,%ax
80105530:	7f 0d                	jg     8010553f <sys_unlink+0xe5>
    panic("unlink: nlink < 1");
80105532:	83 ec 0c             	sub    $0xc,%esp
80105535:	68 cb a5 10 80       	push   $0x8010a5cb
8010553a:	e8 6a b0 ff ff       	call   801005a9 <panic>
  if(ip->type == T_DIR && !isdirempty(ip)){
8010553f:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105542:	0f b7 40 50          	movzwl 0x50(%eax),%eax
80105546:	66 83 f8 01          	cmp    $0x1,%ax
8010554a:	75 25                	jne    80105571 <sys_unlink+0x117>
8010554c:	83 ec 0c             	sub    $0xc,%esp
8010554f:	ff 75 f0             	push   -0x10(%ebp)
80105552:	e8 a0 fe ff ff       	call   801053f7 <isdirempty>
80105557:	83 c4 10             	add    $0x10,%esp
8010555a:	85 c0                	test   %eax,%eax
8010555c:	75 13                	jne    80105571 <sys_unlink+0x117>
    iunlockput(ip);
8010555e:	83 ec 0c             	sub    $0xc,%esp
80105561:	ff 75 f0             	push   -0x10(%ebp)
80105564:	e8 b2 c6 ff ff       	call   80101c1b <iunlockput>
80105569:	83 c4 10             	add    $0x10,%esp
    goto bad;
8010556c:	e9 b5 00 00 00       	jmp    80105626 <sys_unlink+0x1cc>
  }

  memset(&de, 0, sizeof(de));
80105571:	83 ec 04             	sub    $0x4,%esp
80105574:	6a 10                	push   $0x10
80105576:	6a 00                	push   $0x0
80105578:	8d 45 e0             	lea    -0x20(%ebp),%eax
8010557b:	50                   	push   %eax
8010557c:	e8 cf f5 ff ff       	call   80104b50 <memset>
80105581:	83 c4 10             	add    $0x10,%esp
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80105584:	8b 45 c8             	mov    -0x38(%ebp),%eax
80105587:	6a 10                	push   $0x10
80105589:	50                   	push   %eax
8010558a:	8d 45 e0             	lea    -0x20(%ebp),%eax
8010558d:	50                   	push   %eax
8010558e:	ff 75 f4             	push   -0xc(%ebp)
80105591:	e8 95 ca ff ff       	call   8010202b <writei>
80105596:	83 c4 10             	add    $0x10,%esp
80105599:	83 f8 10             	cmp    $0x10,%eax
8010559c:	74 0d                	je     801055ab <sys_unlink+0x151>
    panic("unlink: writei");
8010559e:	83 ec 0c             	sub    $0xc,%esp
801055a1:	68 dd a5 10 80       	push   $0x8010a5dd
801055a6:	e8 fe af ff ff       	call   801005a9 <panic>
  if(ip->type == T_DIR){
801055ab:	8b 45 f0             	mov    -0x10(%ebp),%eax
801055ae:	0f b7 40 50          	movzwl 0x50(%eax),%eax
801055b2:	66 83 f8 01          	cmp    $0x1,%ax
801055b6:	75 21                	jne    801055d9 <sys_unlink+0x17f>
    dp->nlink--;
801055b8:	8b 45 f4             	mov    -0xc(%ebp),%eax
801055bb:	0f b7 40 56          	movzwl 0x56(%eax),%eax
801055bf:	83 e8 01             	sub    $0x1,%eax
801055c2:	89 c2                	mov    %eax,%edx
801055c4:	8b 45 f4             	mov    -0xc(%ebp),%eax
801055c7:	66 89 50 56          	mov    %dx,0x56(%eax)
    iupdate(dp);
801055cb:	83 ec 0c             	sub    $0xc,%esp
801055ce:	ff 75 f4             	push   -0xc(%ebp)
801055d1:	e8 37 c2 ff ff       	call   8010180d <iupdate>
801055d6:	83 c4 10             	add    $0x10,%esp
  }
  iunlockput(dp);
801055d9:	83 ec 0c             	sub    $0xc,%esp
801055dc:	ff 75 f4             	push   -0xc(%ebp)
801055df:	e8 37 c6 ff ff       	call   80101c1b <iunlockput>
801055e4:	83 c4 10             	add    $0x10,%esp

  ip->nlink--;
801055e7:	8b 45 f0             	mov    -0x10(%ebp),%eax
801055ea:	0f b7 40 56          	movzwl 0x56(%eax),%eax
801055ee:	83 e8 01             	sub    $0x1,%eax
801055f1:	89 c2                	mov    %eax,%edx
801055f3:	8b 45 f0             	mov    -0x10(%ebp),%eax
801055f6:	66 89 50 56          	mov    %dx,0x56(%eax)
  iupdate(ip);
801055fa:	83 ec 0c             	sub    $0xc,%esp
801055fd:	ff 75 f0             	push   -0x10(%ebp)
80105600:	e8 08 c2 ff ff       	call   8010180d <iupdate>
80105605:	83 c4 10             	add    $0x10,%esp
  iunlockput(ip);
80105608:	83 ec 0c             	sub    $0xc,%esp
8010560b:	ff 75 f0             	push   -0x10(%ebp)
8010560e:	e8 08 c6 ff ff       	call   80101c1b <iunlockput>
80105613:	83 c4 10             	add    $0x10,%esp

  end_op();
80105616:	e8 ad da ff ff       	call   801030c8 <end_op>

  return 0;
8010561b:	b8 00 00 00 00       	mov    $0x0,%eax
80105620:	eb 1c                	jmp    8010563e <sys_unlink+0x1e4>
    goto bad;
80105622:	90                   	nop
80105623:	eb 01                	jmp    80105626 <sys_unlink+0x1cc>
    goto bad;
80105625:	90                   	nop

bad:
  iunlockput(dp);
80105626:	83 ec 0c             	sub    $0xc,%esp
80105629:	ff 75 f4             	push   -0xc(%ebp)
8010562c:	e8 ea c5 ff ff       	call   80101c1b <iunlockput>
80105631:	83 c4 10             	add    $0x10,%esp
  end_op();
80105634:	e8 8f da ff ff       	call   801030c8 <end_op>
  return -1;
80105639:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
8010563e:	c9                   	leave  
8010563f:	c3                   	ret    

80105640 <create>:

static struct inode*
create(char *path, short type, short major, short minor)
{
80105640:	55                   	push   %ebp
80105641:	89 e5                	mov    %esp,%ebp
80105643:	83 ec 38             	sub    $0x38,%esp
80105646:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80105649:	8b 55 10             	mov    0x10(%ebp),%edx
8010564c:	8b 45 14             	mov    0x14(%ebp),%eax
8010564f:	66 89 4d d4          	mov    %cx,-0x2c(%ebp)
80105653:	66 89 55 d0          	mov    %dx,-0x30(%ebp)
80105657:	66 89 45 cc          	mov    %ax,-0x34(%ebp)
  uint off;
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
8010565b:	83 ec 08             	sub    $0x8,%esp
8010565e:	8d 45 de             	lea    -0x22(%ebp),%eax
80105661:	50                   	push   %eax
80105662:	ff 75 08             	push   0x8(%ebp)
80105665:	e8 cf ce ff ff       	call   80102539 <nameiparent>
8010566a:	83 c4 10             	add    $0x10,%esp
8010566d:	89 45 f4             	mov    %eax,-0xc(%ebp)
80105670:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80105674:	75 0a                	jne    80105680 <create+0x40>
    return 0;
80105676:	b8 00 00 00 00       	mov    $0x0,%eax
8010567b:	e9 90 01 00 00       	jmp    80105810 <create+0x1d0>
  ilock(dp);
80105680:	83 ec 0c             	sub    $0xc,%esp
80105683:	ff 75 f4             	push   -0xc(%ebp)
80105686:	e8 5f c3 ff ff       	call   801019ea <ilock>
8010568b:	83 c4 10             	add    $0x10,%esp

  if((ip = dirlookup(dp, name, &off)) != 0){
8010568e:	83 ec 04             	sub    $0x4,%esp
80105691:	8d 45 ec             	lea    -0x14(%ebp),%eax
80105694:	50                   	push   %eax
80105695:	8d 45 de             	lea    -0x22(%ebp),%eax
80105698:	50                   	push   %eax
80105699:	ff 75 f4             	push   -0xc(%ebp)
8010569c:	e8 2b cb ff ff       	call   801021cc <dirlookup>
801056a1:	83 c4 10             	add    $0x10,%esp
801056a4:	89 45 f0             	mov    %eax,-0x10(%ebp)
801056a7:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
801056ab:	74 50                	je     801056fd <create+0xbd>
    iunlockput(dp);
801056ad:	83 ec 0c             	sub    $0xc,%esp
801056b0:	ff 75 f4             	push   -0xc(%ebp)
801056b3:	e8 63 c5 ff ff       	call   80101c1b <iunlockput>
801056b8:	83 c4 10             	add    $0x10,%esp
    ilock(ip);
801056bb:	83 ec 0c             	sub    $0xc,%esp
801056be:	ff 75 f0             	push   -0x10(%ebp)
801056c1:	e8 24 c3 ff ff       	call   801019ea <ilock>
801056c6:	83 c4 10             	add    $0x10,%esp
    if(type == T_FILE && ip->type == T_FILE)
801056c9:	66 83 7d d4 02       	cmpw   $0x2,-0x2c(%ebp)
801056ce:	75 15                	jne    801056e5 <create+0xa5>
801056d0:	8b 45 f0             	mov    -0x10(%ebp),%eax
801056d3:	0f b7 40 50          	movzwl 0x50(%eax),%eax
801056d7:	66 83 f8 02          	cmp    $0x2,%ax
801056db:	75 08                	jne    801056e5 <create+0xa5>
      return ip;
801056dd:	8b 45 f0             	mov    -0x10(%ebp),%eax
801056e0:	e9 2b 01 00 00       	jmp    80105810 <create+0x1d0>
    iunlockput(ip);
801056e5:	83 ec 0c             	sub    $0xc,%esp
801056e8:	ff 75 f0             	push   -0x10(%ebp)
801056eb:	e8 2b c5 ff ff       	call   80101c1b <iunlockput>
801056f0:	83 c4 10             	add    $0x10,%esp
    return 0;
801056f3:	b8 00 00 00 00       	mov    $0x0,%eax
801056f8:	e9 13 01 00 00       	jmp    80105810 <create+0x1d0>
  }

  if((ip = ialloc(dp->dev, type)) == 0)
801056fd:	0f bf 55 d4          	movswl -0x2c(%ebp),%edx
80105701:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105704:	8b 00                	mov    (%eax),%eax
80105706:	83 ec 08             	sub    $0x8,%esp
80105709:	52                   	push   %edx
8010570a:	50                   	push   %eax
8010570b:	e8 26 c0 ff ff       	call   80101736 <ialloc>
80105710:	83 c4 10             	add    $0x10,%esp
80105713:	89 45 f0             	mov    %eax,-0x10(%ebp)
80105716:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
8010571a:	75 0d                	jne    80105729 <create+0xe9>
    panic("create: ialloc");
8010571c:	83 ec 0c             	sub    $0xc,%esp
8010571f:	68 ec a5 10 80       	push   $0x8010a5ec
80105724:	e8 80 ae ff ff       	call   801005a9 <panic>

  ilock(ip);
80105729:	83 ec 0c             	sub    $0xc,%esp
8010572c:	ff 75 f0             	push   -0x10(%ebp)
8010572f:	e8 b6 c2 ff ff       	call   801019ea <ilock>
80105734:	83 c4 10             	add    $0x10,%esp
  ip->major = major;
80105737:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010573a:	0f b7 55 d0          	movzwl -0x30(%ebp),%edx
8010573e:	66 89 50 52          	mov    %dx,0x52(%eax)
  ip->minor = minor;
80105742:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105745:	0f b7 55 cc          	movzwl -0x34(%ebp),%edx
80105749:	66 89 50 54          	mov    %dx,0x54(%eax)
  ip->nlink = 1;
8010574d:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105750:	66 c7 40 56 01 00    	movw   $0x1,0x56(%eax)
  iupdate(ip);
80105756:	83 ec 0c             	sub    $0xc,%esp
80105759:	ff 75 f0             	push   -0x10(%ebp)
8010575c:	e8 ac c0 ff ff       	call   8010180d <iupdate>
80105761:	83 c4 10             	add    $0x10,%esp

  if(type == T_DIR){  // Create . and .. entries.
80105764:	66 83 7d d4 01       	cmpw   $0x1,-0x2c(%ebp)
80105769:	75 6a                	jne    801057d5 <create+0x195>
    dp->nlink++;  // for ".."
8010576b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010576e:	0f b7 40 56          	movzwl 0x56(%eax),%eax
80105772:	83 c0 01             	add    $0x1,%eax
80105775:	89 c2                	mov    %eax,%edx
80105777:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010577a:	66 89 50 56          	mov    %dx,0x56(%eax)
    iupdate(dp);
8010577e:	83 ec 0c             	sub    $0xc,%esp
80105781:	ff 75 f4             	push   -0xc(%ebp)
80105784:	e8 84 c0 ff ff       	call   8010180d <iupdate>
80105789:	83 c4 10             	add    $0x10,%esp
    // No ip->nlink++ for ".": avoid cyclic ref count.
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
8010578c:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010578f:	8b 40 04             	mov    0x4(%eax),%eax
80105792:	83 ec 04             	sub    $0x4,%esp
80105795:	50                   	push   %eax
80105796:	68 c6 a5 10 80       	push   $0x8010a5c6
8010579b:	ff 75 f0             	push   -0x10(%ebp)
8010579e:	e8 e3 ca ff ff       	call   80102286 <dirlink>
801057a3:	83 c4 10             	add    $0x10,%esp
801057a6:	85 c0                	test   %eax,%eax
801057a8:	78 1e                	js     801057c8 <create+0x188>
801057aa:	8b 45 f4             	mov    -0xc(%ebp),%eax
801057ad:	8b 40 04             	mov    0x4(%eax),%eax
801057b0:	83 ec 04             	sub    $0x4,%esp
801057b3:	50                   	push   %eax
801057b4:	68 c8 a5 10 80       	push   $0x8010a5c8
801057b9:	ff 75 f0             	push   -0x10(%ebp)
801057bc:	e8 c5 ca ff ff       	call   80102286 <dirlink>
801057c1:	83 c4 10             	add    $0x10,%esp
801057c4:	85 c0                	test   %eax,%eax
801057c6:	79 0d                	jns    801057d5 <create+0x195>
      panic("create dots");
801057c8:	83 ec 0c             	sub    $0xc,%esp
801057cb:	68 fb a5 10 80       	push   $0x8010a5fb
801057d0:	e8 d4 ad ff ff       	call   801005a9 <panic>
  }

  if(dirlink(dp, name, ip->inum) < 0)
801057d5:	8b 45 f0             	mov    -0x10(%ebp),%eax
801057d8:	8b 40 04             	mov    0x4(%eax),%eax
801057db:	83 ec 04             	sub    $0x4,%esp
801057de:	50                   	push   %eax
801057df:	8d 45 de             	lea    -0x22(%ebp),%eax
801057e2:	50                   	push   %eax
801057e3:	ff 75 f4             	push   -0xc(%ebp)
801057e6:	e8 9b ca ff ff       	call   80102286 <dirlink>
801057eb:	83 c4 10             	add    $0x10,%esp
801057ee:	85 c0                	test   %eax,%eax
801057f0:	79 0d                	jns    801057ff <create+0x1bf>
    panic("create: dirlink");
801057f2:	83 ec 0c             	sub    $0xc,%esp
801057f5:	68 07 a6 10 80       	push   $0x8010a607
801057fa:	e8 aa ad ff ff       	call   801005a9 <panic>

  iunlockput(dp);
801057ff:	83 ec 0c             	sub    $0xc,%esp
80105802:	ff 75 f4             	push   -0xc(%ebp)
80105805:	e8 11 c4 ff ff       	call   80101c1b <iunlockput>
8010580a:	83 c4 10             	add    $0x10,%esp

  return ip;
8010580d:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
80105810:	c9                   	leave  
80105811:	c3                   	ret    

80105812 <sys_open>:

int
sys_open(void)
{
80105812:	55                   	push   %ebp
80105813:	89 e5                	mov    %esp,%ebp
80105815:	83 ec 28             	sub    $0x28,%esp
  char *path;
  int fd, omode;
  struct file *f;
  struct inode *ip;

  if(argstr(0, &path) < 0 || argint(1, &omode) < 0)
80105818:	83 ec 08             	sub    $0x8,%esp
8010581b:	8d 45 e8             	lea    -0x18(%ebp),%eax
8010581e:	50                   	push   %eax
8010581f:	6a 00                	push   $0x0
80105821:	e8 ea f6 ff ff       	call   80104f10 <argstr>
80105826:	83 c4 10             	add    $0x10,%esp
80105829:	85 c0                	test   %eax,%eax
8010582b:	78 15                	js     80105842 <sys_open+0x30>
8010582d:	83 ec 08             	sub    $0x8,%esp
80105830:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80105833:	50                   	push   %eax
80105834:	6a 01                	push   $0x1
80105836:	e8 40 f6 ff ff       	call   80104e7b <argint>
8010583b:	83 c4 10             	add    $0x10,%esp
8010583e:	85 c0                	test   %eax,%eax
80105840:	79 0a                	jns    8010584c <sys_open+0x3a>
    return -1;
80105842:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105847:	e9 61 01 00 00       	jmp    801059ad <sys_open+0x19b>

  begin_op();
8010584c:	e8 eb d7 ff ff       	call   8010303c <begin_op>

  if(omode & O_CREATE){
80105851:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80105854:	25 00 02 00 00       	and    $0x200,%eax
80105859:	85 c0                	test   %eax,%eax
8010585b:	74 2a                	je     80105887 <sys_open+0x75>
    ip = create(path, T_FILE, 0, 0);
8010585d:	8b 45 e8             	mov    -0x18(%ebp),%eax
80105860:	6a 00                	push   $0x0
80105862:	6a 00                	push   $0x0
80105864:	6a 02                	push   $0x2
80105866:	50                   	push   %eax
80105867:	e8 d4 fd ff ff       	call   80105640 <create>
8010586c:	83 c4 10             	add    $0x10,%esp
8010586f:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(ip == 0){
80105872:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80105876:	75 75                	jne    801058ed <sys_open+0xdb>
      end_op();
80105878:	e8 4b d8 ff ff       	call   801030c8 <end_op>
      return -1;
8010587d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105882:	e9 26 01 00 00       	jmp    801059ad <sys_open+0x19b>
    }
  } else {
    if((ip = namei(path)) == 0){
80105887:	8b 45 e8             	mov    -0x18(%ebp),%eax
8010588a:	83 ec 0c             	sub    $0xc,%esp
8010588d:	50                   	push   %eax
8010588e:	e8 8a cc ff ff       	call   8010251d <namei>
80105893:	83 c4 10             	add    $0x10,%esp
80105896:	89 45 f4             	mov    %eax,-0xc(%ebp)
80105899:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
8010589d:	75 0f                	jne    801058ae <sys_open+0x9c>
      end_op();
8010589f:	e8 24 d8 ff ff       	call   801030c8 <end_op>
      return -1;
801058a4:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801058a9:	e9 ff 00 00 00       	jmp    801059ad <sys_open+0x19b>
    }
    ilock(ip);
801058ae:	83 ec 0c             	sub    $0xc,%esp
801058b1:	ff 75 f4             	push   -0xc(%ebp)
801058b4:	e8 31 c1 ff ff       	call   801019ea <ilock>
801058b9:	83 c4 10             	add    $0x10,%esp
    if(ip->type == T_DIR && omode != O_RDONLY){
801058bc:	8b 45 f4             	mov    -0xc(%ebp),%eax
801058bf:	0f b7 40 50          	movzwl 0x50(%eax),%eax
801058c3:	66 83 f8 01          	cmp    $0x1,%ax
801058c7:	75 24                	jne    801058ed <sys_open+0xdb>
801058c9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801058cc:	85 c0                	test   %eax,%eax
801058ce:	74 1d                	je     801058ed <sys_open+0xdb>
      iunlockput(ip);
801058d0:	83 ec 0c             	sub    $0xc,%esp
801058d3:	ff 75 f4             	push   -0xc(%ebp)
801058d6:	e8 40 c3 ff ff       	call   80101c1b <iunlockput>
801058db:	83 c4 10             	add    $0x10,%esp
      end_op();
801058de:	e8 e5 d7 ff ff       	call   801030c8 <end_op>
      return -1;
801058e3:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801058e8:	e9 c0 00 00 00       	jmp    801059ad <sys_open+0x19b>
    }
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
801058ed:	e8 eb b6 ff ff       	call   80100fdd <filealloc>
801058f2:	89 45 f0             	mov    %eax,-0x10(%ebp)
801058f5:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
801058f9:	74 17                	je     80105912 <sys_open+0x100>
801058fb:	83 ec 0c             	sub    $0xc,%esp
801058fe:	ff 75 f0             	push   -0x10(%ebp)
80105901:	e8 33 f7 ff ff       	call   80105039 <fdalloc>
80105906:	83 c4 10             	add    $0x10,%esp
80105909:	89 45 ec             	mov    %eax,-0x14(%ebp)
8010590c:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
80105910:	79 2e                	jns    80105940 <sys_open+0x12e>
    if(f)
80105912:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80105916:	74 0e                	je     80105926 <sys_open+0x114>
      fileclose(f);
80105918:	83 ec 0c             	sub    $0xc,%esp
8010591b:	ff 75 f0             	push   -0x10(%ebp)
8010591e:	e8 78 b7 ff ff       	call   8010109b <fileclose>
80105923:	83 c4 10             	add    $0x10,%esp
    iunlockput(ip);
80105926:	83 ec 0c             	sub    $0xc,%esp
80105929:	ff 75 f4             	push   -0xc(%ebp)
8010592c:	e8 ea c2 ff ff       	call   80101c1b <iunlockput>
80105931:	83 c4 10             	add    $0x10,%esp
    end_op();
80105934:	e8 8f d7 ff ff       	call   801030c8 <end_op>
    return -1;
80105939:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010593e:	eb 6d                	jmp    801059ad <sys_open+0x19b>
  }
  iunlock(ip);
80105940:	83 ec 0c             	sub    $0xc,%esp
80105943:	ff 75 f4             	push   -0xc(%ebp)
80105946:	e8 b2 c1 ff ff       	call   80101afd <iunlock>
8010594b:	83 c4 10             	add    $0x10,%esp
  end_op();
8010594e:	e8 75 d7 ff ff       	call   801030c8 <end_op>

  f->type = FD_INODE;
80105953:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105956:	c7 00 02 00 00 00    	movl   $0x2,(%eax)
  f->ip = ip;
8010595c:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010595f:	8b 55 f4             	mov    -0xc(%ebp),%edx
80105962:	89 50 10             	mov    %edx,0x10(%eax)
  f->off = 0;
80105965:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105968:	c7 40 14 00 00 00 00 	movl   $0x0,0x14(%eax)
  f->readable = !(omode & O_WRONLY);
8010596f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80105972:	83 e0 01             	and    $0x1,%eax
80105975:	85 c0                	test   %eax,%eax
80105977:	0f 94 c0             	sete   %al
8010597a:	89 c2                	mov    %eax,%edx
8010597c:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010597f:	88 50 08             	mov    %dl,0x8(%eax)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
80105982:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80105985:	83 e0 01             	and    $0x1,%eax
80105988:	85 c0                	test   %eax,%eax
8010598a:	75 0a                	jne    80105996 <sys_open+0x184>
8010598c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010598f:	83 e0 02             	and    $0x2,%eax
80105992:	85 c0                	test   %eax,%eax
80105994:	74 07                	je     8010599d <sys_open+0x18b>
80105996:	b8 01 00 00 00       	mov    $0x1,%eax
8010599b:	eb 05                	jmp    801059a2 <sys_open+0x190>
8010599d:	b8 00 00 00 00       	mov    $0x0,%eax
801059a2:	89 c2                	mov    %eax,%edx
801059a4:	8b 45 f0             	mov    -0x10(%ebp),%eax
801059a7:	88 50 09             	mov    %dl,0x9(%eax)
  return fd;
801059aa:	8b 45 ec             	mov    -0x14(%ebp),%eax
}
801059ad:	c9                   	leave  
801059ae:	c3                   	ret    

801059af <sys_mkdir>:

int
sys_mkdir(void)
{
801059af:	55                   	push   %ebp
801059b0:	89 e5                	mov    %esp,%ebp
801059b2:	83 ec 18             	sub    $0x18,%esp
  char *path;
  struct inode *ip;

  begin_op();
801059b5:	e8 82 d6 ff ff       	call   8010303c <begin_op>
  if(argstr(0, &path) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
801059ba:	83 ec 08             	sub    $0x8,%esp
801059bd:	8d 45 f0             	lea    -0x10(%ebp),%eax
801059c0:	50                   	push   %eax
801059c1:	6a 00                	push   $0x0
801059c3:	e8 48 f5 ff ff       	call   80104f10 <argstr>
801059c8:	83 c4 10             	add    $0x10,%esp
801059cb:	85 c0                	test   %eax,%eax
801059cd:	78 1b                	js     801059ea <sys_mkdir+0x3b>
801059cf:	8b 45 f0             	mov    -0x10(%ebp),%eax
801059d2:	6a 00                	push   $0x0
801059d4:	6a 00                	push   $0x0
801059d6:	6a 01                	push   $0x1
801059d8:	50                   	push   %eax
801059d9:	e8 62 fc ff ff       	call   80105640 <create>
801059de:	83 c4 10             	add    $0x10,%esp
801059e1:	89 45 f4             	mov    %eax,-0xc(%ebp)
801059e4:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801059e8:	75 0c                	jne    801059f6 <sys_mkdir+0x47>
    end_op();
801059ea:	e8 d9 d6 ff ff       	call   801030c8 <end_op>
    return -1;
801059ef:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801059f4:	eb 18                	jmp    80105a0e <sys_mkdir+0x5f>
  }
  iunlockput(ip);
801059f6:	83 ec 0c             	sub    $0xc,%esp
801059f9:	ff 75 f4             	push   -0xc(%ebp)
801059fc:	e8 1a c2 ff ff       	call   80101c1b <iunlockput>
80105a01:	83 c4 10             	add    $0x10,%esp
  end_op();
80105a04:	e8 bf d6 ff ff       	call   801030c8 <end_op>
  return 0;
80105a09:	b8 00 00 00 00       	mov    $0x0,%eax
}
80105a0e:	c9                   	leave  
80105a0f:	c3                   	ret    

80105a10 <sys_mknod>:

int
sys_mknod(void)
{
80105a10:	55                   	push   %ebp
80105a11:	89 e5                	mov    %esp,%ebp
80105a13:	83 ec 18             	sub    $0x18,%esp
  struct inode *ip;
  char *path;
  int major, minor;

  begin_op();
80105a16:	e8 21 d6 ff ff       	call   8010303c <begin_op>
  if((argstr(0, &path)) < 0 ||
80105a1b:	83 ec 08             	sub    $0x8,%esp
80105a1e:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105a21:	50                   	push   %eax
80105a22:	6a 00                	push   $0x0
80105a24:	e8 e7 f4 ff ff       	call   80104f10 <argstr>
80105a29:	83 c4 10             	add    $0x10,%esp
80105a2c:	85 c0                	test   %eax,%eax
80105a2e:	78 4f                	js     80105a7f <sys_mknod+0x6f>
     argint(1, &major) < 0 ||
80105a30:	83 ec 08             	sub    $0x8,%esp
80105a33:	8d 45 ec             	lea    -0x14(%ebp),%eax
80105a36:	50                   	push   %eax
80105a37:	6a 01                	push   $0x1
80105a39:	e8 3d f4 ff ff       	call   80104e7b <argint>
80105a3e:	83 c4 10             	add    $0x10,%esp
  if((argstr(0, &path)) < 0 ||
80105a41:	85 c0                	test   %eax,%eax
80105a43:	78 3a                	js     80105a7f <sys_mknod+0x6f>
     argint(2, &minor) < 0 ||
80105a45:	83 ec 08             	sub    $0x8,%esp
80105a48:	8d 45 e8             	lea    -0x18(%ebp),%eax
80105a4b:	50                   	push   %eax
80105a4c:	6a 02                	push   $0x2
80105a4e:	e8 28 f4 ff ff       	call   80104e7b <argint>
80105a53:	83 c4 10             	add    $0x10,%esp
     argint(1, &major) < 0 ||
80105a56:	85 c0                	test   %eax,%eax
80105a58:	78 25                	js     80105a7f <sys_mknod+0x6f>
     (ip = create(path, T_DEV, major, minor)) == 0){
80105a5a:	8b 45 e8             	mov    -0x18(%ebp),%eax
80105a5d:	0f bf c8             	movswl %ax,%ecx
80105a60:	8b 45 ec             	mov    -0x14(%ebp),%eax
80105a63:	0f bf d0             	movswl %ax,%edx
80105a66:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105a69:	51                   	push   %ecx
80105a6a:	52                   	push   %edx
80105a6b:	6a 03                	push   $0x3
80105a6d:	50                   	push   %eax
80105a6e:	e8 cd fb ff ff       	call   80105640 <create>
80105a73:	83 c4 10             	add    $0x10,%esp
80105a76:	89 45 f4             	mov    %eax,-0xc(%ebp)
     argint(2, &minor) < 0 ||
80105a79:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80105a7d:	75 0c                	jne    80105a8b <sys_mknod+0x7b>
    end_op();
80105a7f:	e8 44 d6 ff ff       	call   801030c8 <end_op>
    return -1;
80105a84:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105a89:	eb 18                	jmp    80105aa3 <sys_mknod+0x93>
  }
  iunlockput(ip);
80105a8b:	83 ec 0c             	sub    $0xc,%esp
80105a8e:	ff 75 f4             	push   -0xc(%ebp)
80105a91:	e8 85 c1 ff ff       	call   80101c1b <iunlockput>
80105a96:	83 c4 10             	add    $0x10,%esp
  end_op();
80105a99:	e8 2a d6 ff ff       	call   801030c8 <end_op>
  return 0;
80105a9e:	b8 00 00 00 00       	mov    $0x0,%eax
}
80105aa3:	c9                   	leave  
80105aa4:	c3                   	ret    

80105aa5 <sys_chdir>:

int
sys_chdir(void)
{
80105aa5:	55                   	push   %ebp
80105aa6:	89 e5                	mov    %esp,%ebp
80105aa8:	83 ec 18             	sub    $0x18,%esp
  char *path;
  struct inode *ip;
  struct proc *curproc = myproc();
80105aab:	e8 66 e1 ff ff       	call   80103c16 <myproc>
80105ab0:	89 45 f4             	mov    %eax,-0xc(%ebp)
  
  begin_op();
80105ab3:	e8 84 d5 ff ff       	call   8010303c <begin_op>
  if(argstr(0, &path) < 0 || (ip = namei(path)) == 0){
80105ab8:	83 ec 08             	sub    $0x8,%esp
80105abb:	8d 45 ec             	lea    -0x14(%ebp),%eax
80105abe:	50                   	push   %eax
80105abf:	6a 00                	push   $0x0
80105ac1:	e8 4a f4 ff ff       	call   80104f10 <argstr>
80105ac6:	83 c4 10             	add    $0x10,%esp
80105ac9:	85 c0                	test   %eax,%eax
80105acb:	78 18                	js     80105ae5 <sys_chdir+0x40>
80105acd:	8b 45 ec             	mov    -0x14(%ebp),%eax
80105ad0:	83 ec 0c             	sub    $0xc,%esp
80105ad3:	50                   	push   %eax
80105ad4:	e8 44 ca ff ff       	call   8010251d <namei>
80105ad9:	83 c4 10             	add    $0x10,%esp
80105adc:	89 45 f0             	mov    %eax,-0x10(%ebp)
80105adf:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80105ae3:	75 0c                	jne    80105af1 <sys_chdir+0x4c>
    end_op();
80105ae5:	e8 de d5 ff ff       	call   801030c8 <end_op>
    return -1;
80105aea:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105aef:	eb 68                	jmp    80105b59 <sys_chdir+0xb4>
  }
  ilock(ip);
80105af1:	83 ec 0c             	sub    $0xc,%esp
80105af4:	ff 75 f0             	push   -0x10(%ebp)
80105af7:	e8 ee be ff ff       	call   801019ea <ilock>
80105afc:	83 c4 10             	add    $0x10,%esp
  if(ip->type != T_DIR){
80105aff:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105b02:	0f b7 40 50          	movzwl 0x50(%eax),%eax
80105b06:	66 83 f8 01          	cmp    $0x1,%ax
80105b0a:	74 1a                	je     80105b26 <sys_chdir+0x81>
    iunlockput(ip);
80105b0c:	83 ec 0c             	sub    $0xc,%esp
80105b0f:	ff 75 f0             	push   -0x10(%ebp)
80105b12:	e8 04 c1 ff ff       	call   80101c1b <iunlockput>
80105b17:	83 c4 10             	add    $0x10,%esp
    end_op();
80105b1a:	e8 a9 d5 ff ff       	call   801030c8 <end_op>
    return -1;
80105b1f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105b24:	eb 33                	jmp    80105b59 <sys_chdir+0xb4>
  }
  iunlock(ip);
80105b26:	83 ec 0c             	sub    $0xc,%esp
80105b29:	ff 75 f0             	push   -0x10(%ebp)
80105b2c:	e8 cc bf ff ff       	call   80101afd <iunlock>
80105b31:	83 c4 10             	add    $0x10,%esp
  iput(curproc->cwd);
80105b34:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105b37:	8b 40 68             	mov    0x68(%eax),%eax
80105b3a:	83 ec 0c             	sub    $0xc,%esp
80105b3d:	50                   	push   %eax
80105b3e:	e8 08 c0 ff ff       	call   80101b4b <iput>
80105b43:	83 c4 10             	add    $0x10,%esp
  end_op();
80105b46:	e8 7d d5 ff ff       	call   801030c8 <end_op>
  curproc->cwd = ip;
80105b4b:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105b4e:	8b 55 f0             	mov    -0x10(%ebp),%edx
80105b51:	89 50 68             	mov    %edx,0x68(%eax)
  return 0;
80105b54:	b8 00 00 00 00       	mov    $0x0,%eax
}
80105b59:	c9                   	leave  
80105b5a:	c3                   	ret    

80105b5b <sys_exec>:

int
sys_exec(void)
{
80105b5b:	55                   	push   %ebp
80105b5c:	89 e5                	mov    %esp,%ebp
80105b5e:	81 ec 98 00 00 00    	sub    $0x98,%esp
  char *path, *argv[MAXARG];
  int i;
  uint uargv, uarg;

  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
80105b64:	83 ec 08             	sub    $0x8,%esp
80105b67:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105b6a:	50                   	push   %eax
80105b6b:	6a 00                	push   $0x0
80105b6d:	e8 9e f3 ff ff       	call   80104f10 <argstr>
80105b72:	83 c4 10             	add    $0x10,%esp
80105b75:	85 c0                	test   %eax,%eax
80105b77:	78 18                	js     80105b91 <sys_exec+0x36>
80105b79:	83 ec 08             	sub    $0x8,%esp
80105b7c:	8d 85 6c ff ff ff    	lea    -0x94(%ebp),%eax
80105b82:	50                   	push   %eax
80105b83:	6a 01                	push   $0x1
80105b85:	e8 f1 f2 ff ff       	call   80104e7b <argint>
80105b8a:	83 c4 10             	add    $0x10,%esp
80105b8d:	85 c0                	test   %eax,%eax
80105b8f:	79 0a                	jns    80105b9b <sys_exec+0x40>
    return -1;
80105b91:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105b96:	e9 c6 00 00 00       	jmp    80105c61 <sys_exec+0x106>
  }
  memset(argv, 0, sizeof(argv));
80105b9b:	83 ec 04             	sub    $0x4,%esp
80105b9e:	68 80 00 00 00       	push   $0x80
80105ba3:	6a 00                	push   $0x0
80105ba5:	8d 85 70 ff ff ff    	lea    -0x90(%ebp),%eax
80105bab:	50                   	push   %eax
80105bac:	e8 9f ef ff ff       	call   80104b50 <memset>
80105bb1:	83 c4 10             	add    $0x10,%esp
  for(i=0;; i++){
80105bb4:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    if(i >= NELEM(argv))
80105bbb:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105bbe:	83 f8 1f             	cmp    $0x1f,%eax
80105bc1:	76 0a                	jbe    80105bcd <sys_exec+0x72>
      return -1;
80105bc3:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105bc8:	e9 94 00 00 00       	jmp    80105c61 <sys_exec+0x106>
    if(fetchint(uargv+4*i, (int*)&uarg) < 0)
80105bcd:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105bd0:	c1 e0 02             	shl    $0x2,%eax
80105bd3:	89 c2                	mov    %eax,%edx
80105bd5:	8b 85 6c ff ff ff    	mov    -0x94(%ebp),%eax
80105bdb:	01 c2                	add    %eax,%edx
80105bdd:	83 ec 08             	sub    $0x8,%esp
80105be0:	8d 85 68 ff ff ff    	lea    -0x98(%ebp),%eax
80105be6:	50                   	push   %eax
80105be7:	52                   	push   %edx
80105be8:	e8 ed f1 ff ff       	call   80104dda <fetchint>
80105bed:	83 c4 10             	add    $0x10,%esp
80105bf0:	85 c0                	test   %eax,%eax
80105bf2:	79 07                	jns    80105bfb <sys_exec+0xa0>
      return -1;
80105bf4:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105bf9:	eb 66                	jmp    80105c61 <sys_exec+0x106>
    if(uarg == 0){
80105bfb:	8b 85 68 ff ff ff    	mov    -0x98(%ebp),%eax
80105c01:	85 c0                	test   %eax,%eax
80105c03:	75 27                	jne    80105c2c <sys_exec+0xd1>
      argv[i] = 0;
80105c05:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105c08:	c7 84 85 70 ff ff ff 	movl   $0x0,-0x90(%ebp,%eax,4)
80105c0f:	00 00 00 00 
      break;
80105c13:	90                   	nop
    }
    if(fetchstr(uarg, &argv[i]) < 0)
      return -1;
  }
  return exec(path, argv);
80105c14:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105c17:	83 ec 08             	sub    $0x8,%esp
80105c1a:	8d 95 70 ff ff ff    	lea    -0x90(%ebp),%edx
80105c20:	52                   	push   %edx
80105c21:	50                   	push   %eax
80105c22:	e8 59 af ff ff       	call   80100b80 <exec>
80105c27:	83 c4 10             	add    $0x10,%esp
80105c2a:	eb 35                	jmp    80105c61 <sys_exec+0x106>
    if(fetchstr(uarg, &argv[i]) < 0)
80105c2c:	8d 95 70 ff ff ff    	lea    -0x90(%ebp),%edx
80105c32:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105c35:	c1 e0 02             	shl    $0x2,%eax
80105c38:	01 c2                	add    %eax,%edx
80105c3a:	8b 85 68 ff ff ff    	mov    -0x98(%ebp),%eax
80105c40:	83 ec 08             	sub    $0x8,%esp
80105c43:	52                   	push   %edx
80105c44:	50                   	push   %eax
80105c45:	e8 cf f1 ff ff       	call   80104e19 <fetchstr>
80105c4a:	83 c4 10             	add    $0x10,%esp
80105c4d:	85 c0                	test   %eax,%eax
80105c4f:	79 07                	jns    80105c58 <sys_exec+0xfd>
      return -1;
80105c51:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105c56:	eb 09                	jmp    80105c61 <sys_exec+0x106>
  for(i=0;; i++){
80105c58:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
    if(i >= NELEM(argv))
80105c5c:	e9 5a ff ff ff       	jmp    80105bbb <sys_exec+0x60>
}
80105c61:	c9                   	leave  
80105c62:	c3                   	ret    

80105c63 <sys_pipe>:

int
sys_pipe(void)
{
80105c63:	55                   	push   %ebp
80105c64:	89 e5                	mov    %esp,%ebp
80105c66:	83 ec 28             	sub    $0x28,%esp
  int *fd;
  struct file *rf, *wf;
  int fd0, fd1;

  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
80105c69:	83 ec 04             	sub    $0x4,%esp
80105c6c:	6a 08                	push   $0x8
80105c6e:	8d 45 ec             	lea    -0x14(%ebp),%eax
80105c71:	50                   	push   %eax
80105c72:	6a 00                	push   $0x0
80105c74:	e8 2f f2 ff ff       	call   80104ea8 <argptr>
80105c79:	83 c4 10             	add    $0x10,%esp
80105c7c:	85 c0                	test   %eax,%eax
80105c7e:	79 0a                	jns    80105c8a <sys_pipe+0x27>
    return -1;
80105c80:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105c85:	e9 ae 00 00 00       	jmp    80105d38 <sys_pipe+0xd5>
  if(pipealloc(&rf, &wf) < 0)
80105c8a:	83 ec 08             	sub    $0x8,%esp
80105c8d:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80105c90:	50                   	push   %eax
80105c91:	8d 45 e8             	lea    -0x18(%ebp),%eax
80105c94:	50                   	push   %eax
80105c95:	e8 d3 d8 ff ff       	call   8010356d <pipealloc>
80105c9a:	83 c4 10             	add    $0x10,%esp
80105c9d:	85 c0                	test   %eax,%eax
80105c9f:	79 0a                	jns    80105cab <sys_pipe+0x48>
    return -1;
80105ca1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105ca6:	e9 8d 00 00 00       	jmp    80105d38 <sys_pipe+0xd5>
  fd0 = -1;
80105cab:	c7 45 f4 ff ff ff ff 	movl   $0xffffffff,-0xc(%ebp)
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
80105cb2:	8b 45 e8             	mov    -0x18(%ebp),%eax
80105cb5:	83 ec 0c             	sub    $0xc,%esp
80105cb8:	50                   	push   %eax
80105cb9:	e8 7b f3 ff ff       	call   80105039 <fdalloc>
80105cbe:	83 c4 10             	add    $0x10,%esp
80105cc1:	89 45 f4             	mov    %eax,-0xc(%ebp)
80105cc4:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80105cc8:	78 18                	js     80105ce2 <sys_pipe+0x7f>
80105cca:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80105ccd:	83 ec 0c             	sub    $0xc,%esp
80105cd0:	50                   	push   %eax
80105cd1:	e8 63 f3 ff ff       	call   80105039 <fdalloc>
80105cd6:	83 c4 10             	add    $0x10,%esp
80105cd9:	89 45 f0             	mov    %eax,-0x10(%ebp)
80105cdc:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80105ce0:	79 3e                	jns    80105d20 <sys_pipe+0xbd>
    if(fd0 >= 0)
80105ce2:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80105ce6:	78 13                	js     80105cfb <sys_pipe+0x98>
      myproc()->ofile[fd0] = 0;
80105ce8:	e8 29 df ff ff       	call   80103c16 <myproc>
80105ced:	8b 55 f4             	mov    -0xc(%ebp),%edx
80105cf0:	83 c2 08             	add    $0x8,%edx
80105cf3:	c7 44 90 08 00 00 00 	movl   $0x0,0x8(%eax,%edx,4)
80105cfa:	00 
    fileclose(rf);
80105cfb:	8b 45 e8             	mov    -0x18(%ebp),%eax
80105cfe:	83 ec 0c             	sub    $0xc,%esp
80105d01:	50                   	push   %eax
80105d02:	e8 94 b3 ff ff       	call   8010109b <fileclose>
80105d07:	83 c4 10             	add    $0x10,%esp
    fileclose(wf);
80105d0a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80105d0d:	83 ec 0c             	sub    $0xc,%esp
80105d10:	50                   	push   %eax
80105d11:	e8 85 b3 ff ff       	call   8010109b <fileclose>
80105d16:	83 c4 10             	add    $0x10,%esp
    return -1;
80105d19:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105d1e:	eb 18                	jmp    80105d38 <sys_pipe+0xd5>
  }
  fd[0] = fd0;
80105d20:	8b 45 ec             	mov    -0x14(%ebp),%eax
80105d23:	8b 55 f4             	mov    -0xc(%ebp),%edx
80105d26:	89 10                	mov    %edx,(%eax)
  fd[1] = fd1;
80105d28:	8b 45 ec             	mov    -0x14(%ebp),%eax
80105d2b:	8d 50 04             	lea    0x4(%eax),%edx
80105d2e:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105d31:	89 02                	mov    %eax,(%edx)
  return 0;
80105d33:	b8 00 00 00 00       	mov    $0x0,%eax
}
80105d38:	c9                   	leave  
80105d39:	c3                   	ret    

80105d3a <sys_printpt>:
#include "param.h"
#include "memlayout.h"
#include "mmu.h"
#include "proc.h"
int 
sys_printpt(void) {
80105d3a:	55                   	push   %ebp
80105d3b:	89 e5                	mov    %esp,%ebp
80105d3d:	83 ec 18             	sub    $0x18,%esp
  int pid;
  if (argint(0, &pid) < 0)
80105d40:	83 ec 08             	sub    $0x8,%esp
80105d43:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105d46:	50                   	push   %eax
80105d47:	6a 00                	push   $0x0
80105d49:	e8 2d f1 ff ff       	call   80104e7b <argint>
80105d4e:	83 c4 10             	add    $0x10,%esp
80105d51:	85 c0                	test   %eax,%eax
80105d53:	79 07                	jns    80105d5c <sys_printpt+0x22>
      return -1;
80105d55:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105d5a:	eb 0f                	jmp    80105d6b <sys_printpt+0x31>
  return printpt(pid);
80105d5c:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105d5f:	83 ec 0c             	sub    $0xc,%esp
80105d62:	50                   	push   %eax
80105d63:	e8 17 dc ff ff       	call   8010397f <printpt>
80105d68:	83 c4 10             	add    $0x10,%esp
}
80105d6b:	c9                   	leave  
80105d6c:	c3                   	ret    

80105d6d <sys_fork>:
int
sys_fork(void)
{
80105d6d:	55                   	push   %ebp
80105d6e:	89 e5                	mov    %esp,%ebp
80105d70:	83 ec 08             	sub    $0x8,%esp
  return fork();
80105d73:	e8 9d e1 ff ff       	call   80103f15 <fork>
}
80105d78:	c9                   	leave  
80105d79:	c3                   	ret    

80105d7a <sys_exit>:

int
sys_exit(void)
{
80105d7a:	55                   	push   %ebp
80105d7b:	89 e5                	mov    %esp,%ebp
80105d7d:	83 ec 08             	sub    $0x8,%esp
  exit();
80105d80:	e8 09 e3 ff ff       	call   8010408e <exit>
  return 0;  // not reached
80105d85:	b8 00 00 00 00       	mov    $0x0,%eax
}
80105d8a:	c9                   	leave  
80105d8b:	c3                   	ret    

80105d8c <sys_wait>:

int
sys_wait(void)
{
80105d8c:	55                   	push   %ebp
80105d8d:	89 e5                	mov    %esp,%ebp
80105d8f:	83 ec 08             	sub    $0x8,%esp
  return wait();
80105d92:	e8 17 e4 ff ff       	call   801041ae <wait>
}
80105d97:	c9                   	leave  
80105d98:	c3                   	ret    

80105d99 <sys_kill>:

int
sys_kill(void)
{
80105d99:	55                   	push   %ebp
80105d9a:	89 e5                	mov    %esp,%ebp
80105d9c:	83 ec 18             	sub    $0x18,%esp
  int pid;

  if(argint(0, &pid) < 0)
80105d9f:	83 ec 08             	sub    $0x8,%esp
80105da2:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105da5:	50                   	push   %eax
80105da6:	6a 00                	push   $0x0
80105da8:	e8 ce f0 ff ff       	call   80104e7b <argint>
80105dad:	83 c4 10             	add    $0x10,%esp
80105db0:	85 c0                	test   %eax,%eax
80105db2:	79 07                	jns    80105dbb <sys_kill+0x22>
    return -1;
80105db4:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105db9:	eb 0f                	jmp    80105dca <sys_kill+0x31>
  return kill(pid);
80105dbb:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105dbe:	83 ec 0c             	sub    $0xc,%esp
80105dc1:	50                   	push   %eax
80105dc2:	e8 16 e8 ff ff       	call   801045dd <kill>
80105dc7:	83 c4 10             	add    $0x10,%esp
}
80105dca:	c9                   	leave  
80105dcb:	c3                   	ret    

80105dcc <sys_getpid>:

int
sys_getpid(void)
{
80105dcc:	55                   	push   %ebp
80105dcd:	89 e5                	mov    %esp,%ebp
80105dcf:	83 ec 08             	sub    $0x8,%esp
  return myproc()->pid;
80105dd2:	e8 3f de ff ff       	call   80103c16 <myproc>
80105dd7:	8b 40 10             	mov    0x10(%eax),%eax
}
80105dda:	c9                   	leave  
80105ddb:	c3                   	ret    

80105ddc <sys_sbrk>:

int
sys_sbrk(void)
{
80105ddc:	55                   	push   %ebp
80105ddd:	89 e5                	mov    %esp,%ebp
80105ddf:	83 ec 18             	sub    $0x18,%esp
  int addr;
  int n;

  if(argint(0, &n) < 0)
80105de2:	83 ec 08             	sub    $0x8,%esp
80105de5:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105de8:	50                   	push   %eax
80105de9:	6a 00                	push   $0x0
80105deb:	e8 8b f0 ff ff       	call   80104e7b <argint>
80105df0:	83 c4 10             	add    $0x10,%esp
80105df3:	85 c0                	test   %eax,%eax
80105df5:	79 07                	jns    80105dfe <sys_sbrk+0x22>
    return -1;
80105df7:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105dfc:	eb 27                	jmp    80105e25 <sys_sbrk+0x49>
  addr = myproc()->sz;
80105dfe:	e8 13 de ff ff       	call   80103c16 <myproc>
80105e03:	8b 00                	mov    (%eax),%eax
80105e05:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(growproc(n) < 0)
80105e08:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105e0b:	83 ec 0c             	sub    $0xc,%esp
80105e0e:	50                   	push   %eax
80105e0f:	e8 66 e0 ff ff       	call   80103e7a <growproc>
80105e14:	83 c4 10             	add    $0x10,%esp
80105e17:	85 c0                	test   %eax,%eax
80105e19:	79 07                	jns    80105e22 <sys_sbrk+0x46>
    return -1;
80105e1b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105e20:	eb 03                	jmp    80105e25 <sys_sbrk+0x49>
  return addr;
80105e22:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
80105e25:	c9                   	leave  
80105e26:	c3                   	ret    

80105e27 <sys_sleep>:

int
sys_sleep(void)
{
80105e27:	55                   	push   %ebp
80105e28:	89 e5                	mov    %esp,%ebp
80105e2a:	83 ec 18             	sub    $0x18,%esp
  int n;
  uint ticks0;

  if(argint(0, &n) < 0)
80105e2d:	83 ec 08             	sub    $0x8,%esp
80105e30:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105e33:	50                   	push   %eax
80105e34:	6a 00                	push   $0x0
80105e36:	e8 40 f0 ff ff       	call   80104e7b <argint>
80105e3b:	83 c4 10             	add    $0x10,%esp
80105e3e:	85 c0                	test   %eax,%eax
80105e40:	79 07                	jns    80105e49 <sys_sleep+0x22>
    return -1;
80105e42:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105e47:	eb 76                	jmp    80105ebf <sys_sleep+0x98>
  acquire(&tickslock);
80105e49:	83 ec 0c             	sub    $0xc,%esp
80105e4c:	68 40 69 19 80       	push   $0x80196940
80105e51:	e8 84 ea ff ff       	call   801048da <acquire>
80105e56:	83 c4 10             	add    $0x10,%esp
  ticks0 = ticks;
80105e59:	a1 74 69 19 80       	mov    0x80196974,%eax
80105e5e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  while(ticks - ticks0 < n){
80105e61:	eb 38                	jmp    80105e9b <sys_sleep+0x74>
    if(myproc()->killed){
80105e63:	e8 ae dd ff ff       	call   80103c16 <myproc>
80105e68:	8b 40 24             	mov    0x24(%eax),%eax
80105e6b:	85 c0                	test   %eax,%eax
80105e6d:	74 17                	je     80105e86 <sys_sleep+0x5f>
      release(&tickslock);
80105e6f:	83 ec 0c             	sub    $0xc,%esp
80105e72:	68 40 69 19 80       	push   $0x80196940
80105e77:	e8 cc ea ff ff       	call   80104948 <release>
80105e7c:	83 c4 10             	add    $0x10,%esp
      return -1;
80105e7f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105e84:	eb 39                	jmp    80105ebf <sys_sleep+0x98>
    }
    sleep(&ticks, &tickslock);
80105e86:	83 ec 08             	sub    $0x8,%esp
80105e89:	68 40 69 19 80       	push   $0x80196940
80105e8e:	68 74 69 19 80       	push   $0x80196974
80105e93:	e8 27 e6 ff ff       	call   801044bf <sleep>
80105e98:	83 c4 10             	add    $0x10,%esp
  while(ticks - ticks0 < n){
80105e9b:	a1 74 69 19 80       	mov    0x80196974,%eax
80105ea0:	2b 45 f4             	sub    -0xc(%ebp),%eax
80105ea3:	8b 55 f0             	mov    -0x10(%ebp),%edx
80105ea6:	39 d0                	cmp    %edx,%eax
80105ea8:	72 b9                	jb     80105e63 <sys_sleep+0x3c>
  }
  release(&tickslock);
80105eaa:	83 ec 0c             	sub    $0xc,%esp
80105ead:	68 40 69 19 80       	push   $0x80196940
80105eb2:	e8 91 ea ff ff       	call   80104948 <release>
80105eb7:	83 c4 10             	add    $0x10,%esp
  return 0;
80105eba:	b8 00 00 00 00       	mov    $0x0,%eax
}
80105ebf:	c9                   	leave  
80105ec0:	c3                   	ret    

80105ec1 <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
int
sys_uptime(void)
{
80105ec1:	55                   	push   %ebp
80105ec2:	89 e5                	mov    %esp,%ebp
80105ec4:	83 ec 18             	sub    $0x18,%esp
  uint xticks;

  acquire(&tickslock);
80105ec7:	83 ec 0c             	sub    $0xc,%esp
80105eca:	68 40 69 19 80       	push   $0x80196940
80105ecf:	e8 06 ea ff ff       	call   801048da <acquire>
80105ed4:	83 c4 10             	add    $0x10,%esp
  xticks = ticks;
80105ed7:	a1 74 69 19 80       	mov    0x80196974,%eax
80105edc:	89 45 f4             	mov    %eax,-0xc(%ebp)
  release(&tickslock);
80105edf:	83 ec 0c             	sub    $0xc,%esp
80105ee2:	68 40 69 19 80       	push   $0x80196940
80105ee7:	e8 5c ea ff ff       	call   80104948 <release>
80105eec:	83 c4 10             	add    $0x10,%esp
  return xticks;
80105eef:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
80105ef2:	c9                   	leave  
80105ef3:	c3                   	ret    

80105ef4 <alltraps>:
80105ef4:	1e                   	push   %ds
80105ef5:	06                   	push   %es
80105ef6:	0f a0                	push   %fs
80105ef8:	0f a8                	push   %gs
80105efa:	60                   	pusha  
80105efb:	66 b8 10 00          	mov    $0x10,%ax
80105eff:	8e d8                	mov    %eax,%ds
80105f01:	8e c0                	mov    %eax,%es
80105f03:	54                   	push   %esp
80105f04:	e8 d7 01 00 00       	call   801060e0 <trap>
80105f09:	83 c4 04             	add    $0x4,%esp

80105f0c <trapret>:
80105f0c:	61                   	popa   
80105f0d:	0f a9                	pop    %gs
80105f0f:	0f a1                	pop    %fs
80105f11:	07                   	pop    %es
80105f12:	1f                   	pop    %ds
80105f13:	83 c4 08             	add    $0x8,%esp
80105f16:	cf                   	iret   

80105f17 <lidt>:
{
80105f17:	55                   	push   %ebp
80105f18:	89 e5                	mov    %esp,%ebp
80105f1a:	83 ec 10             	sub    $0x10,%esp
  pd[0] = size-1;
80105f1d:	8b 45 0c             	mov    0xc(%ebp),%eax
80105f20:	83 e8 01             	sub    $0x1,%eax
80105f23:	66 89 45 fa          	mov    %ax,-0x6(%ebp)
  pd[1] = (uint)p;
80105f27:	8b 45 08             	mov    0x8(%ebp),%eax
80105f2a:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  pd[2] = (uint)p >> 16;
80105f2e:	8b 45 08             	mov    0x8(%ebp),%eax
80105f31:	c1 e8 10             	shr    $0x10,%eax
80105f34:	66 89 45 fe          	mov    %ax,-0x2(%ebp)
  asm volatile("lidt (%0)" : : "r" (pd));
80105f38:	8d 45 fa             	lea    -0x6(%ebp),%eax
80105f3b:	0f 01 18             	lidtl  (%eax)
}
80105f3e:	90                   	nop
80105f3f:	c9                   	leave  
80105f40:	c3                   	ret    

80105f41 <rcr2>:

static inline uint
rcr2(void)
{
80105f41:	55                   	push   %ebp
80105f42:	89 e5                	mov    %esp,%ebp
80105f44:	83 ec 10             	sub    $0x10,%esp
  uint val;
  asm volatile("movl %%cr2,%0" : "=r" (val));
80105f47:	0f 20 d0             	mov    %cr2,%eax
80105f4a:	89 45 fc             	mov    %eax,-0x4(%ebp)
  return val;
80105f4d:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
80105f50:	c9                   	leave  
80105f51:	c3                   	ret    

80105f52 <tvinit>:
struct spinlock tickslock;
uint ticks;

void
tvinit(void)
{
80105f52:	55                   	push   %ebp
80105f53:	89 e5                	mov    %esp,%ebp
80105f55:	83 ec 18             	sub    $0x18,%esp
  int i;

  for(i = 0; i < 256; i++)
80105f58:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80105f5f:	e9 c3 00 00 00       	jmp    80106027 <tvinit+0xd5>
    SETGATE(idt[i], 0, SEG_KCODE<<3, vectors[i], 0);
80105f64:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105f67:	8b 04 85 7c f0 10 80 	mov    -0x7fef0f84(,%eax,4),%eax
80105f6e:	89 c2                	mov    %eax,%edx
80105f70:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105f73:	66 89 14 c5 40 61 19 	mov    %dx,-0x7fe69ec0(,%eax,8)
80105f7a:	80 
80105f7b:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105f7e:	66 c7 04 c5 42 61 19 	movw   $0x8,-0x7fe69ebe(,%eax,8)
80105f85:	80 08 00 
80105f88:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105f8b:	0f b6 14 c5 44 61 19 	movzbl -0x7fe69ebc(,%eax,8),%edx
80105f92:	80 
80105f93:	83 e2 e0             	and    $0xffffffe0,%edx
80105f96:	88 14 c5 44 61 19 80 	mov    %dl,-0x7fe69ebc(,%eax,8)
80105f9d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105fa0:	0f b6 14 c5 44 61 19 	movzbl -0x7fe69ebc(,%eax,8),%edx
80105fa7:	80 
80105fa8:	83 e2 1f             	and    $0x1f,%edx
80105fab:	88 14 c5 44 61 19 80 	mov    %dl,-0x7fe69ebc(,%eax,8)
80105fb2:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105fb5:	0f b6 14 c5 45 61 19 	movzbl -0x7fe69ebb(,%eax,8),%edx
80105fbc:	80 
80105fbd:	83 e2 f0             	and    $0xfffffff0,%edx
80105fc0:	83 ca 0e             	or     $0xe,%edx
80105fc3:	88 14 c5 45 61 19 80 	mov    %dl,-0x7fe69ebb(,%eax,8)
80105fca:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105fcd:	0f b6 14 c5 45 61 19 	movzbl -0x7fe69ebb(,%eax,8),%edx
80105fd4:	80 
80105fd5:	83 e2 ef             	and    $0xffffffef,%edx
80105fd8:	88 14 c5 45 61 19 80 	mov    %dl,-0x7fe69ebb(,%eax,8)
80105fdf:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105fe2:	0f b6 14 c5 45 61 19 	movzbl -0x7fe69ebb(,%eax,8),%edx
80105fe9:	80 
80105fea:	83 e2 9f             	and    $0xffffff9f,%edx
80105fed:	88 14 c5 45 61 19 80 	mov    %dl,-0x7fe69ebb(,%eax,8)
80105ff4:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105ff7:	0f b6 14 c5 45 61 19 	movzbl -0x7fe69ebb(,%eax,8),%edx
80105ffe:	80 
80105fff:	83 ca 80             	or     $0xffffff80,%edx
80106002:	88 14 c5 45 61 19 80 	mov    %dl,-0x7fe69ebb(,%eax,8)
80106009:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010600c:	8b 04 85 7c f0 10 80 	mov    -0x7fef0f84(,%eax,4),%eax
80106013:	c1 e8 10             	shr    $0x10,%eax
80106016:	89 c2                	mov    %eax,%edx
80106018:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010601b:	66 89 14 c5 46 61 19 	mov    %dx,-0x7fe69eba(,%eax,8)
80106022:	80 
  for(i = 0; i < 256; i++)
80106023:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80106027:	81 7d f4 ff 00 00 00 	cmpl   $0xff,-0xc(%ebp)
8010602e:	0f 8e 30 ff ff ff    	jle    80105f64 <tvinit+0x12>
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
80106034:	a1 7c f1 10 80       	mov    0x8010f17c,%eax
80106039:	66 a3 40 63 19 80    	mov    %ax,0x80196340
8010603f:	66 c7 05 42 63 19 80 	movw   $0x8,0x80196342
80106046:	08 00 
80106048:	0f b6 05 44 63 19 80 	movzbl 0x80196344,%eax
8010604f:	83 e0 e0             	and    $0xffffffe0,%eax
80106052:	a2 44 63 19 80       	mov    %al,0x80196344
80106057:	0f b6 05 44 63 19 80 	movzbl 0x80196344,%eax
8010605e:	83 e0 1f             	and    $0x1f,%eax
80106061:	a2 44 63 19 80       	mov    %al,0x80196344
80106066:	0f b6 05 45 63 19 80 	movzbl 0x80196345,%eax
8010606d:	83 c8 0f             	or     $0xf,%eax
80106070:	a2 45 63 19 80       	mov    %al,0x80196345
80106075:	0f b6 05 45 63 19 80 	movzbl 0x80196345,%eax
8010607c:	83 e0 ef             	and    $0xffffffef,%eax
8010607f:	a2 45 63 19 80       	mov    %al,0x80196345
80106084:	0f b6 05 45 63 19 80 	movzbl 0x80196345,%eax
8010608b:	83 c8 60             	or     $0x60,%eax
8010608e:	a2 45 63 19 80       	mov    %al,0x80196345
80106093:	0f b6 05 45 63 19 80 	movzbl 0x80196345,%eax
8010609a:	83 c8 80             	or     $0xffffff80,%eax
8010609d:	a2 45 63 19 80       	mov    %al,0x80196345
801060a2:	a1 7c f1 10 80       	mov    0x8010f17c,%eax
801060a7:	c1 e8 10             	shr    $0x10,%eax
801060aa:	66 a3 46 63 19 80    	mov    %ax,0x80196346

  initlock(&tickslock, "time");
801060b0:	83 ec 08             	sub    $0x8,%esp
801060b3:	68 18 a6 10 80       	push   $0x8010a618
801060b8:	68 40 69 19 80       	push   $0x80196940
801060bd:	e8 f6 e7 ff ff       	call   801048b8 <initlock>
801060c2:	83 c4 10             	add    $0x10,%esp
}
801060c5:	90                   	nop
801060c6:	c9                   	leave  
801060c7:	c3                   	ret    

801060c8 <idtinit>:

void
idtinit(void)
{
801060c8:	55                   	push   %ebp
801060c9:	89 e5                	mov    %esp,%ebp
  lidt(idt, sizeof(idt));
801060cb:	68 00 08 00 00       	push   $0x800
801060d0:	68 40 61 19 80       	push   $0x80196140
801060d5:	e8 3d fe ff ff       	call   80105f17 <lidt>
801060da:	83 c4 08             	add    $0x8,%esp
}
801060dd:	90                   	nop
801060de:	c9                   	leave  
801060df:	c3                   	ret    

801060e0 <trap>:

//PAGEBREAK: 41
void
trap(struct trapframe *tf)
{
801060e0:	55                   	push   %ebp
801060e1:	89 e5                	mov    %esp,%ebp
801060e3:	57                   	push   %edi
801060e4:	56                   	push   %esi
801060e5:	53                   	push   %ebx
801060e6:	83 ec 1c             	sub    $0x1c,%esp
  if(tf->trapno == T_SYSCALL){
801060e9:	8b 45 08             	mov    0x8(%ebp),%eax
801060ec:	8b 40 30             	mov    0x30(%eax),%eax
801060ef:	83 f8 40             	cmp    $0x40,%eax
801060f2:	75 3b                	jne    8010612f <trap+0x4f>
    if(myproc()->killed)
801060f4:	e8 1d db ff ff       	call   80103c16 <myproc>
801060f9:	8b 40 24             	mov    0x24(%eax),%eax
801060fc:	85 c0                	test   %eax,%eax
801060fe:	74 05                	je     80106105 <trap+0x25>
      exit();
80106100:	e8 89 df ff ff       	call   8010408e <exit>
    myproc()->tf = tf;
80106105:	e8 0c db ff ff       	call   80103c16 <myproc>
8010610a:	8b 55 08             	mov    0x8(%ebp),%edx
8010610d:	89 50 18             	mov    %edx,0x18(%eax)
    syscall();
80106110:	e8 32 ee ff ff       	call   80104f47 <syscall>
    if(myproc()->killed)
80106115:	e8 fc da ff ff       	call   80103c16 <myproc>
8010611a:	8b 40 24             	mov    0x24(%eax),%eax
8010611d:	85 c0                	test   %eax,%eax
8010611f:	0f 84 15 02 00 00    	je     8010633a <trap+0x25a>
      exit();
80106125:	e8 64 df ff ff       	call   8010408e <exit>
    return;
8010612a:	e9 0b 02 00 00       	jmp    8010633a <trap+0x25a>
  }

  switch(tf->trapno){
8010612f:	8b 45 08             	mov    0x8(%ebp),%eax
80106132:	8b 40 30             	mov    0x30(%eax),%eax
80106135:	83 e8 20             	sub    $0x20,%eax
80106138:	83 f8 1f             	cmp    $0x1f,%eax
8010613b:	0f 87 c4 00 00 00    	ja     80106205 <trap+0x125>
80106141:	8b 04 85 c0 a6 10 80 	mov    -0x7fef5940(,%eax,4),%eax
80106148:	ff e0                	jmp    *%eax
  case T_IRQ0 + IRQ_TIMER:
    if(cpuid() == 0){
8010614a:	e8 34 da ff ff       	call   80103b83 <cpuid>
8010614f:	85 c0                	test   %eax,%eax
80106151:	75 3d                	jne    80106190 <trap+0xb0>
      acquire(&tickslock);
80106153:	83 ec 0c             	sub    $0xc,%esp
80106156:	68 40 69 19 80       	push   $0x80196940
8010615b:	e8 7a e7 ff ff       	call   801048da <acquire>
80106160:	83 c4 10             	add    $0x10,%esp
      ticks++;
80106163:	a1 74 69 19 80       	mov    0x80196974,%eax
80106168:	83 c0 01             	add    $0x1,%eax
8010616b:	a3 74 69 19 80       	mov    %eax,0x80196974
      wakeup(&ticks);
80106170:	83 ec 0c             	sub    $0xc,%esp
80106173:	68 74 69 19 80       	push   $0x80196974
80106178:	e8 29 e4 ff ff       	call   801045a6 <wakeup>
8010617d:	83 c4 10             	add    $0x10,%esp
      release(&tickslock);
80106180:	83 ec 0c             	sub    $0xc,%esp
80106183:	68 40 69 19 80       	push   $0x80196940
80106188:	e8 bb e7 ff ff       	call   80104948 <release>
8010618d:	83 c4 10             	add    $0x10,%esp
    }
    lapiceoi();
80106190:	e8 87 c9 ff ff       	call   80102b1c <lapiceoi>
    break;
80106195:	e9 20 01 00 00       	jmp    801062ba <trap+0x1da>
  case T_IRQ0 + IRQ_IDE:
    ideintr();
8010619a:	e8 f5 3e 00 00       	call   8010a094 <ideintr>
    lapiceoi();
8010619f:	e8 78 c9 ff ff       	call   80102b1c <lapiceoi>
    break;
801061a4:	e9 11 01 00 00       	jmp    801062ba <trap+0x1da>
  case T_IRQ0 + IRQ_IDE+1:
    // Bochs generates spurious IDE1 interrupts.
    break;
  case T_IRQ0 + IRQ_KBD:
    kbdintr();
801061a9:	e8 b3 c7 ff ff       	call   80102961 <kbdintr>
    lapiceoi();
801061ae:	e8 69 c9 ff ff       	call   80102b1c <lapiceoi>
    break;
801061b3:	e9 02 01 00 00       	jmp    801062ba <trap+0x1da>
  case T_IRQ0 + IRQ_COM1:
    uartintr();
801061b8:	e8 53 03 00 00       	call   80106510 <uartintr>
    lapiceoi();
801061bd:	e8 5a c9 ff ff       	call   80102b1c <lapiceoi>
    break;
801061c2:	e9 f3 00 00 00       	jmp    801062ba <trap+0x1da>
  case T_IRQ0 + 0xB:
    i8254_intr();
801061c7:	e8 7b 2b 00 00       	call   80108d47 <i8254_intr>
    lapiceoi();
801061cc:	e8 4b c9 ff ff       	call   80102b1c <lapiceoi>
    break;
801061d1:	e9 e4 00 00 00       	jmp    801062ba <trap+0x1da>
  case T_IRQ0 + IRQ_SPURIOUS:
    cprintf("cpu%d: spurious interrupt at %x:%x\n",
801061d6:	8b 45 08             	mov    0x8(%ebp),%eax
801061d9:	8b 70 38             	mov    0x38(%eax),%esi
            cpuid(), tf->cs, tf->eip);
801061dc:	8b 45 08             	mov    0x8(%ebp),%eax
801061df:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
    cprintf("cpu%d: spurious interrupt at %x:%x\n",
801061e3:	0f b7 d8             	movzwl %ax,%ebx
801061e6:	e8 98 d9 ff ff       	call   80103b83 <cpuid>
801061eb:	56                   	push   %esi
801061ec:	53                   	push   %ebx
801061ed:	50                   	push   %eax
801061ee:	68 20 a6 10 80       	push   $0x8010a620
801061f3:	e8 fc a1 ff ff       	call   801003f4 <cprintf>
801061f8:	83 c4 10             	add    $0x10,%esp
    lapiceoi();
801061fb:	e8 1c c9 ff ff       	call   80102b1c <lapiceoi>
    break;
80106200:	e9 b5 00 00 00       	jmp    801062ba <trap+0x1da>

  //PAGEBREAK: 13
  default:
    if(myproc() == 0 || (tf->cs&3) == 0){
80106205:	e8 0c da ff ff       	call   80103c16 <myproc>
8010620a:	85 c0                	test   %eax,%eax
8010620c:	74 11                	je     8010621f <trap+0x13f>
8010620e:	8b 45 08             	mov    0x8(%ebp),%eax
80106211:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
80106215:	0f b7 c0             	movzwl %ax,%eax
80106218:	83 e0 03             	and    $0x3,%eax
8010621b:	85 c0                	test   %eax,%eax
8010621d:	75 39                	jne    80106258 <trap+0x178>
      // In kernel, it must be our mistake.
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
8010621f:	e8 1d fd ff ff       	call   80105f41 <rcr2>
80106224:	89 c3                	mov    %eax,%ebx
80106226:	8b 45 08             	mov    0x8(%ebp),%eax
80106229:	8b 70 38             	mov    0x38(%eax),%esi
8010622c:	e8 52 d9 ff ff       	call   80103b83 <cpuid>
80106231:	8b 55 08             	mov    0x8(%ebp),%edx
80106234:	8b 52 30             	mov    0x30(%edx),%edx
80106237:	83 ec 0c             	sub    $0xc,%esp
8010623a:	53                   	push   %ebx
8010623b:	56                   	push   %esi
8010623c:	50                   	push   %eax
8010623d:	52                   	push   %edx
8010623e:	68 44 a6 10 80       	push   $0x8010a644
80106243:	e8 ac a1 ff ff       	call   801003f4 <cprintf>
80106248:	83 c4 20             	add    $0x20,%esp
              tf->trapno, cpuid(), tf->eip, rcr2());
      panic("trap");
8010624b:	83 ec 0c             	sub    $0xc,%esp
8010624e:	68 76 a6 10 80       	push   $0x8010a676
80106253:	e8 51 a3 ff ff       	call   801005a9 <panic>
    }
    // In user space, assume process misbehaved.
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80106258:	e8 e4 fc ff ff       	call   80105f41 <rcr2>
8010625d:	89 c6                	mov    %eax,%esi
8010625f:	8b 45 08             	mov    0x8(%ebp),%eax
80106262:	8b 40 38             	mov    0x38(%eax),%eax
80106265:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80106268:	e8 16 d9 ff ff       	call   80103b83 <cpuid>
8010626d:	89 c3                	mov    %eax,%ebx
8010626f:	8b 45 08             	mov    0x8(%ebp),%eax
80106272:	8b 48 34             	mov    0x34(%eax),%ecx
80106275:	89 4d e0             	mov    %ecx,-0x20(%ebp)
80106278:	8b 45 08             	mov    0x8(%ebp),%eax
8010627b:	8b 78 30             	mov    0x30(%eax),%edi
            "eip 0x%x addr 0x%x--kill proc\n",
            myproc()->pid, myproc()->name, tf->trapno,
8010627e:	e8 93 d9 ff ff       	call   80103c16 <myproc>
80106283:	8d 50 6c             	lea    0x6c(%eax),%edx
80106286:	89 55 dc             	mov    %edx,-0x24(%ebp)
80106289:	e8 88 d9 ff ff       	call   80103c16 <myproc>
    cprintf("pid %d %s: trap %d err %d on cpu %d "
8010628e:	8b 40 10             	mov    0x10(%eax),%eax
80106291:	56                   	push   %esi
80106292:	ff 75 e4             	push   -0x1c(%ebp)
80106295:	53                   	push   %ebx
80106296:	ff 75 e0             	push   -0x20(%ebp)
80106299:	57                   	push   %edi
8010629a:	ff 75 dc             	push   -0x24(%ebp)
8010629d:	50                   	push   %eax
8010629e:	68 7c a6 10 80       	push   $0x8010a67c
801062a3:	e8 4c a1 ff ff       	call   801003f4 <cprintf>
801062a8:	83 c4 20             	add    $0x20,%esp
            tf->err, cpuid(), tf->eip, rcr2());
    myproc()->killed = 1;
801062ab:	e8 66 d9 ff ff       	call   80103c16 <myproc>
801062b0:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
801062b7:	eb 01                	jmp    801062ba <trap+0x1da>
    break;
801062b9:	90                   	nop
  }

  // Force process exit if it has been killed and is in user space.
  // (If it is still executing in the kernel, let it keep running
  // until it gets to the regular system call return.)
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
801062ba:	e8 57 d9 ff ff       	call   80103c16 <myproc>
801062bf:	85 c0                	test   %eax,%eax
801062c1:	74 23                	je     801062e6 <trap+0x206>
801062c3:	e8 4e d9 ff ff       	call   80103c16 <myproc>
801062c8:	8b 40 24             	mov    0x24(%eax),%eax
801062cb:	85 c0                	test   %eax,%eax
801062cd:	74 17                	je     801062e6 <trap+0x206>
801062cf:	8b 45 08             	mov    0x8(%ebp),%eax
801062d2:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
801062d6:	0f b7 c0             	movzwl %ax,%eax
801062d9:	83 e0 03             	and    $0x3,%eax
801062dc:	83 f8 03             	cmp    $0x3,%eax
801062df:	75 05                	jne    801062e6 <trap+0x206>
    exit();
801062e1:	e8 a8 dd ff ff       	call   8010408e <exit>

  // Force process to give up CPU on clock tick.
  // If interrupts were on while locks held, would need to check nlock.
  if(myproc() && myproc()->state == RUNNING &&
801062e6:	e8 2b d9 ff ff       	call   80103c16 <myproc>
801062eb:	85 c0                	test   %eax,%eax
801062ed:	74 1d                	je     8010630c <trap+0x22c>
801062ef:	e8 22 d9 ff ff       	call   80103c16 <myproc>
801062f4:	8b 40 0c             	mov    0xc(%eax),%eax
801062f7:	83 f8 04             	cmp    $0x4,%eax
801062fa:	75 10                	jne    8010630c <trap+0x22c>
     tf->trapno == T_IRQ0+IRQ_TIMER)
801062fc:	8b 45 08             	mov    0x8(%ebp),%eax
801062ff:	8b 40 30             	mov    0x30(%eax),%eax
  if(myproc() && myproc()->state == RUNNING &&
80106302:	83 f8 20             	cmp    $0x20,%eax
80106305:	75 05                	jne    8010630c <trap+0x22c>
    yield();
80106307:	e8 33 e1 ff ff       	call   8010443f <yield>

  // Check if the process has been killed since we yielded
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
8010630c:	e8 05 d9 ff ff       	call   80103c16 <myproc>
80106311:	85 c0                	test   %eax,%eax
80106313:	74 26                	je     8010633b <trap+0x25b>
80106315:	e8 fc d8 ff ff       	call   80103c16 <myproc>
8010631a:	8b 40 24             	mov    0x24(%eax),%eax
8010631d:	85 c0                	test   %eax,%eax
8010631f:	74 1a                	je     8010633b <trap+0x25b>
80106321:	8b 45 08             	mov    0x8(%ebp),%eax
80106324:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
80106328:	0f b7 c0             	movzwl %ax,%eax
8010632b:	83 e0 03             	and    $0x3,%eax
8010632e:	83 f8 03             	cmp    $0x3,%eax
80106331:	75 08                	jne    8010633b <trap+0x25b>
    exit();
80106333:	e8 56 dd ff ff       	call   8010408e <exit>
80106338:	eb 01                	jmp    8010633b <trap+0x25b>
    return;
8010633a:	90                   	nop
}
8010633b:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010633e:	5b                   	pop    %ebx
8010633f:	5e                   	pop    %esi
80106340:	5f                   	pop    %edi
80106341:	5d                   	pop    %ebp
80106342:	c3                   	ret    

80106343 <inb>:
{
80106343:	55                   	push   %ebp
80106344:	89 e5                	mov    %esp,%ebp
80106346:	83 ec 14             	sub    $0x14,%esp
80106349:	8b 45 08             	mov    0x8(%ebp),%eax
8010634c:	66 89 45 ec          	mov    %ax,-0x14(%ebp)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80106350:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
80106354:	89 c2                	mov    %eax,%edx
80106356:	ec                   	in     (%dx),%al
80106357:	88 45 ff             	mov    %al,-0x1(%ebp)
  return data;
8010635a:	0f b6 45 ff          	movzbl -0x1(%ebp),%eax
}
8010635e:	c9                   	leave  
8010635f:	c3                   	ret    

80106360 <outb>:
{
80106360:	55                   	push   %ebp
80106361:	89 e5                	mov    %esp,%ebp
80106363:	83 ec 08             	sub    $0x8,%esp
80106366:	8b 45 08             	mov    0x8(%ebp),%eax
80106369:	8b 55 0c             	mov    0xc(%ebp),%edx
8010636c:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
80106370:	89 d0                	mov    %edx,%eax
80106372:	88 45 f8             	mov    %al,-0x8(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80106375:	0f b6 45 f8          	movzbl -0x8(%ebp),%eax
80106379:	0f b7 55 fc          	movzwl -0x4(%ebp),%edx
8010637d:	ee                   	out    %al,(%dx)
}
8010637e:	90                   	nop
8010637f:	c9                   	leave  
80106380:	c3                   	ret    

80106381 <uartinit>:

static int uart;    // is there a uart?

void
uartinit(void)
{
80106381:	55                   	push   %ebp
80106382:	89 e5                	mov    %esp,%ebp
80106384:	83 ec 18             	sub    $0x18,%esp
  char *p;

  // Turn off the FIFO
  outb(COM1+2, 0);
80106387:	6a 00                	push   $0x0
80106389:	68 fa 03 00 00       	push   $0x3fa
8010638e:	e8 cd ff ff ff       	call   80106360 <outb>
80106393:	83 c4 08             	add    $0x8,%esp

  // 9600 baud, 8 data bits, 1 stop bit, parity off.
  outb(COM1+3, 0x80);    // Unlock divisor
80106396:	68 80 00 00 00       	push   $0x80
8010639b:	68 fb 03 00 00       	push   $0x3fb
801063a0:	e8 bb ff ff ff       	call   80106360 <outb>
801063a5:	83 c4 08             	add    $0x8,%esp
  outb(COM1+0, 115200/9600);
801063a8:	6a 0c                	push   $0xc
801063aa:	68 f8 03 00 00       	push   $0x3f8
801063af:	e8 ac ff ff ff       	call   80106360 <outb>
801063b4:	83 c4 08             	add    $0x8,%esp
  outb(COM1+1, 0);
801063b7:	6a 00                	push   $0x0
801063b9:	68 f9 03 00 00       	push   $0x3f9
801063be:	e8 9d ff ff ff       	call   80106360 <outb>
801063c3:	83 c4 08             	add    $0x8,%esp
  outb(COM1+3, 0x03);    // Lock divisor, 8 data bits.
801063c6:	6a 03                	push   $0x3
801063c8:	68 fb 03 00 00       	push   $0x3fb
801063cd:	e8 8e ff ff ff       	call   80106360 <outb>
801063d2:	83 c4 08             	add    $0x8,%esp
  outb(COM1+4, 0);
801063d5:	6a 00                	push   $0x0
801063d7:	68 fc 03 00 00       	push   $0x3fc
801063dc:	e8 7f ff ff ff       	call   80106360 <outb>
801063e1:	83 c4 08             	add    $0x8,%esp
  outb(COM1+1, 0x01);    // Enable receive interrupts.
801063e4:	6a 01                	push   $0x1
801063e6:	68 f9 03 00 00       	push   $0x3f9
801063eb:	e8 70 ff ff ff       	call   80106360 <outb>
801063f0:	83 c4 08             	add    $0x8,%esp

  // If status is 0xFF, no serial port.
  if(inb(COM1+5) == 0xFF)
801063f3:	68 fd 03 00 00       	push   $0x3fd
801063f8:	e8 46 ff ff ff       	call   80106343 <inb>
801063fd:	83 c4 04             	add    $0x4,%esp
80106400:	3c ff                	cmp    $0xff,%al
80106402:	74 61                	je     80106465 <uartinit+0xe4>
    return;
  uart = 1;
80106404:	c7 05 78 69 19 80 01 	movl   $0x1,0x80196978
8010640b:	00 00 00 

  // Acknowledge pre-existing interrupt conditions;
  // enable interrupts.
  inb(COM1+2);
8010640e:	68 fa 03 00 00       	push   $0x3fa
80106413:	e8 2b ff ff ff       	call   80106343 <inb>
80106418:	83 c4 04             	add    $0x4,%esp
  inb(COM1+0);
8010641b:	68 f8 03 00 00       	push   $0x3f8
80106420:	e8 1e ff ff ff       	call   80106343 <inb>
80106425:	83 c4 04             	add    $0x4,%esp
  ioapicenable(IRQ_COM1, 0);
80106428:	83 ec 08             	sub    $0x8,%esp
8010642b:	6a 00                	push   $0x0
8010642d:	6a 04                	push   $0x4
8010642f:	e8 fa c1 ff ff       	call   8010262e <ioapicenable>
80106434:	83 c4 10             	add    $0x10,%esp

  // Announce that we're here.
  for(p="xv6...\n"; *p; p++)
80106437:	c7 45 f4 40 a7 10 80 	movl   $0x8010a740,-0xc(%ebp)
8010643e:	eb 19                	jmp    80106459 <uartinit+0xd8>
    uartputc(*p);
80106440:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106443:	0f b6 00             	movzbl (%eax),%eax
80106446:	0f be c0             	movsbl %al,%eax
80106449:	83 ec 0c             	sub    $0xc,%esp
8010644c:	50                   	push   %eax
8010644d:	e8 16 00 00 00       	call   80106468 <uartputc>
80106452:	83 c4 10             	add    $0x10,%esp
  for(p="xv6...\n"; *p; p++)
80106455:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80106459:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010645c:	0f b6 00             	movzbl (%eax),%eax
8010645f:	84 c0                	test   %al,%al
80106461:	75 dd                	jne    80106440 <uartinit+0xbf>
80106463:	eb 01                	jmp    80106466 <uartinit+0xe5>
    return;
80106465:	90                   	nop
}
80106466:	c9                   	leave  
80106467:	c3                   	ret    

80106468 <uartputc>:

void
uartputc(int c)
{
80106468:	55                   	push   %ebp
80106469:	89 e5                	mov    %esp,%ebp
8010646b:	83 ec 18             	sub    $0x18,%esp
  int i;

  if(!uart)
8010646e:	a1 78 69 19 80       	mov    0x80196978,%eax
80106473:	85 c0                	test   %eax,%eax
80106475:	74 53                	je     801064ca <uartputc+0x62>
    return;
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
80106477:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
8010647e:	eb 11                	jmp    80106491 <uartputc+0x29>
    microdelay(10);
80106480:	83 ec 0c             	sub    $0xc,%esp
80106483:	6a 0a                	push   $0xa
80106485:	e8 ad c6 ff ff       	call   80102b37 <microdelay>
8010648a:	83 c4 10             	add    $0x10,%esp
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
8010648d:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80106491:	83 7d f4 7f          	cmpl   $0x7f,-0xc(%ebp)
80106495:	7f 1a                	jg     801064b1 <uartputc+0x49>
80106497:	83 ec 0c             	sub    $0xc,%esp
8010649a:	68 fd 03 00 00       	push   $0x3fd
8010649f:	e8 9f fe ff ff       	call   80106343 <inb>
801064a4:	83 c4 10             	add    $0x10,%esp
801064a7:	0f b6 c0             	movzbl %al,%eax
801064aa:	83 e0 20             	and    $0x20,%eax
801064ad:	85 c0                	test   %eax,%eax
801064af:	74 cf                	je     80106480 <uartputc+0x18>
  outb(COM1+0, c);
801064b1:	8b 45 08             	mov    0x8(%ebp),%eax
801064b4:	0f b6 c0             	movzbl %al,%eax
801064b7:	83 ec 08             	sub    $0x8,%esp
801064ba:	50                   	push   %eax
801064bb:	68 f8 03 00 00       	push   $0x3f8
801064c0:	e8 9b fe ff ff       	call   80106360 <outb>
801064c5:	83 c4 10             	add    $0x10,%esp
801064c8:	eb 01                	jmp    801064cb <uartputc+0x63>
    return;
801064ca:	90                   	nop
}
801064cb:	c9                   	leave  
801064cc:	c3                   	ret    

801064cd <uartgetc>:

static int
uartgetc(void)
{
801064cd:	55                   	push   %ebp
801064ce:	89 e5                	mov    %esp,%ebp
  if(!uart)
801064d0:	a1 78 69 19 80       	mov    0x80196978,%eax
801064d5:	85 c0                	test   %eax,%eax
801064d7:	75 07                	jne    801064e0 <uartgetc+0x13>
    return -1;
801064d9:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801064de:	eb 2e                	jmp    8010650e <uartgetc+0x41>
  if(!(inb(COM1+5) & 0x01))
801064e0:	68 fd 03 00 00       	push   $0x3fd
801064e5:	e8 59 fe ff ff       	call   80106343 <inb>
801064ea:	83 c4 04             	add    $0x4,%esp
801064ed:	0f b6 c0             	movzbl %al,%eax
801064f0:	83 e0 01             	and    $0x1,%eax
801064f3:	85 c0                	test   %eax,%eax
801064f5:	75 07                	jne    801064fe <uartgetc+0x31>
    return -1;
801064f7:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801064fc:	eb 10                	jmp    8010650e <uartgetc+0x41>
  return inb(COM1+0);
801064fe:	68 f8 03 00 00       	push   $0x3f8
80106503:	e8 3b fe ff ff       	call   80106343 <inb>
80106508:	83 c4 04             	add    $0x4,%esp
8010650b:	0f b6 c0             	movzbl %al,%eax
}
8010650e:	c9                   	leave  
8010650f:	c3                   	ret    

80106510 <uartintr>:

void
uartintr(void)
{
80106510:	55                   	push   %ebp
80106511:	89 e5                	mov    %esp,%ebp
80106513:	83 ec 08             	sub    $0x8,%esp
  consoleintr(uartgetc);
80106516:	83 ec 0c             	sub    $0xc,%esp
80106519:	68 cd 64 10 80       	push   $0x801064cd
8010651e:	e8 b3 a2 ff ff       	call   801007d6 <consoleintr>
80106523:	83 c4 10             	add    $0x10,%esp
}
80106526:	90                   	nop
80106527:	c9                   	leave  
80106528:	c3                   	ret    

80106529 <vector0>:
80106529:	6a 00                	push   $0x0
8010652b:	6a 00                	push   $0x0
8010652d:	e9 c2 f9 ff ff       	jmp    80105ef4 <alltraps>

80106532 <vector1>:
80106532:	6a 00                	push   $0x0
80106534:	6a 01                	push   $0x1
80106536:	e9 b9 f9 ff ff       	jmp    80105ef4 <alltraps>

8010653b <vector2>:
8010653b:	6a 00                	push   $0x0
8010653d:	6a 02                	push   $0x2
8010653f:	e9 b0 f9 ff ff       	jmp    80105ef4 <alltraps>

80106544 <vector3>:
80106544:	6a 00                	push   $0x0
80106546:	6a 03                	push   $0x3
80106548:	e9 a7 f9 ff ff       	jmp    80105ef4 <alltraps>

8010654d <vector4>:
8010654d:	6a 00                	push   $0x0
8010654f:	6a 04                	push   $0x4
80106551:	e9 9e f9 ff ff       	jmp    80105ef4 <alltraps>

80106556 <vector5>:
80106556:	6a 00                	push   $0x0
80106558:	6a 05                	push   $0x5
8010655a:	e9 95 f9 ff ff       	jmp    80105ef4 <alltraps>

8010655f <vector6>:
8010655f:	6a 00                	push   $0x0
80106561:	6a 06                	push   $0x6
80106563:	e9 8c f9 ff ff       	jmp    80105ef4 <alltraps>

80106568 <vector7>:
80106568:	6a 00                	push   $0x0
8010656a:	6a 07                	push   $0x7
8010656c:	e9 83 f9 ff ff       	jmp    80105ef4 <alltraps>

80106571 <vector8>:
80106571:	6a 08                	push   $0x8
80106573:	e9 7c f9 ff ff       	jmp    80105ef4 <alltraps>

80106578 <vector9>:
80106578:	6a 00                	push   $0x0
8010657a:	6a 09                	push   $0x9
8010657c:	e9 73 f9 ff ff       	jmp    80105ef4 <alltraps>

80106581 <vector10>:
80106581:	6a 0a                	push   $0xa
80106583:	e9 6c f9 ff ff       	jmp    80105ef4 <alltraps>

80106588 <vector11>:
80106588:	6a 0b                	push   $0xb
8010658a:	e9 65 f9 ff ff       	jmp    80105ef4 <alltraps>

8010658f <vector12>:
8010658f:	6a 0c                	push   $0xc
80106591:	e9 5e f9 ff ff       	jmp    80105ef4 <alltraps>

80106596 <vector13>:
80106596:	6a 0d                	push   $0xd
80106598:	e9 57 f9 ff ff       	jmp    80105ef4 <alltraps>

8010659d <vector14>:
8010659d:	6a 0e                	push   $0xe
8010659f:	e9 50 f9 ff ff       	jmp    80105ef4 <alltraps>

801065a4 <vector15>:
801065a4:	6a 00                	push   $0x0
801065a6:	6a 0f                	push   $0xf
801065a8:	e9 47 f9 ff ff       	jmp    80105ef4 <alltraps>

801065ad <vector16>:
801065ad:	6a 00                	push   $0x0
801065af:	6a 10                	push   $0x10
801065b1:	e9 3e f9 ff ff       	jmp    80105ef4 <alltraps>

801065b6 <vector17>:
801065b6:	6a 11                	push   $0x11
801065b8:	e9 37 f9 ff ff       	jmp    80105ef4 <alltraps>

801065bd <vector18>:
801065bd:	6a 00                	push   $0x0
801065bf:	6a 12                	push   $0x12
801065c1:	e9 2e f9 ff ff       	jmp    80105ef4 <alltraps>

801065c6 <vector19>:
801065c6:	6a 00                	push   $0x0
801065c8:	6a 13                	push   $0x13
801065ca:	e9 25 f9 ff ff       	jmp    80105ef4 <alltraps>

801065cf <vector20>:
801065cf:	6a 00                	push   $0x0
801065d1:	6a 14                	push   $0x14
801065d3:	e9 1c f9 ff ff       	jmp    80105ef4 <alltraps>

801065d8 <vector21>:
801065d8:	6a 00                	push   $0x0
801065da:	6a 15                	push   $0x15
801065dc:	e9 13 f9 ff ff       	jmp    80105ef4 <alltraps>

801065e1 <vector22>:
801065e1:	6a 00                	push   $0x0
801065e3:	6a 16                	push   $0x16
801065e5:	e9 0a f9 ff ff       	jmp    80105ef4 <alltraps>

801065ea <vector23>:
801065ea:	6a 00                	push   $0x0
801065ec:	6a 17                	push   $0x17
801065ee:	e9 01 f9 ff ff       	jmp    80105ef4 <alltraps>

801065f3 <vector24>:
801065f3:	6a 00                	push   $0x0
801065f5:	6a 18                	push   $0x18
801065f7:	e9 f8 f8 ff ff       	jmp    80105ef4 <alltraps>

801065fc <vector25>:
801065fc:	6a 00                	push   $0x0
801065fe:	6a 19                	push   $0x19
80106600:	e9 ef f8 ff ff       	jmp    80105ef4 <alltraps>

80106605 <vector26>:
80106605:	6a 00                	push   $0x0
80106607:	6a 1a                	push   $0x1a
80106609:	e9 e6 f8 ff ff       	jmp    80105ef4 <alltraps>

8010660e <vector27>:
8010660e:	6a 00                	push   $0x0
80106610:	6a 1b                	push   $0x1b
80106612:	e9 dd f8 ff ff       	jmp    80105ef4 <alltraps>

80106617 <vector28>:
80106617:	6a 00                	push   $0x0
80106619:	6a 1c                	push   $0x1c
8010661b:	e9 d4 f8 ff ff       	jmp    80105ef4 <alltraps>

80106620 <vector29>:
80106620:	6a 00                	push   $0x0
80106622:	6a 1d                	push   $0x1d
80106624:	e9 cb f8 ff ff       	jmp    80105ef4 <alltraps>

80106629 <vector30>:
80106629:	6a 00                	push   $0x0
8010662b:	6a 1e                	push   $0x1e
8010662d:	e9 c2 f8 ff ff       	jmp    80105ef4 <alltraps>

80106632 <vector31>:
80106632:	6a 00                	push   $0x0
80106634:	6a 1f                	push   $0x1f
80106636:	e9 b9 f8 ff ff       	jmp    80105ef4 <alltraps>

8010663b <vector32>:
8010663b:	6a 00                	push   $0x0
8010663d:	6a 20                	push   $0x20
8010663f:	e9 b0 f8 ff ff       	jmp    80105ef4 <alltraps>

80106644 <vector33>:
80106644:	6a 00                	push   $0x0
80106646:	6a 21                	push   $0x21
80106648:	e9 a7 f8 ff ff       	jmp    80105ef4 <alltraps>

8010664d <vector34>:
8010664d:	6a 00                	push   $0x0
8010664f:	6a 22                	push   $0x22
80106651:	e9 9e f8 ff ff       	jmp    80105ef4 <alltraps>

80106656 <vector35>:
80106656:	6a 00                	push   $0x0
80106658:	6a 23                	push   $0x23
8010665a:	e9 95 f8 ff ff       	jmp    80105ef4 <alltraps>

8010665f <vector36>:
8010665f:	6a 00                	push   $0x0
80106661:	6a 24                	push   $0x24
80106663:	e9 8c f8 ff ff       	jmp    80105ef4 <alltraps>

80106668 <vector37>:
80106668:	6a 00                	push   $0x0
8010666a:	6a 25                	push   $0x25
8010666c:	e9 83 f8 ff ff       	jmp    80105ef4 <alltraps>

80106671 <vector38>:
80106671:	6a 00                	push   $0x0
80106673:	6a 26                	push   $0x26
80106675:	e9 7a f8 ff ff       	jmp    80105ef4 <alltraps>

8010667a <vector39>:
8010667a:	6a 00                	push   $0x0
8010667c:	6a 27                	push   $0x27
8010667e:	e9 71 f8 ff ff       	jmp    80105ef4 <alltraps>

80106683 <vector40>:
80106683:	6a 00                	push   $0x0
80106685:	6a 28                	push   $0x28
80106687:	e9 68 f8 ff ff       	jmp    80105ef4 <alltraps>

8010668c <vector41>:
8010668c:	6a 00                	push   $0x0
8010668e:	6a 29                	push   $0x29
80106690:	e9 5f f8 ff ff       	jmp    80105ef4 <alltraps>

80106695 <vector42>:
80106695:	6a 00                	push   $0x0
80106697:	6a 2a                	push   $0x2a
80106699:	e9 56 f8 ff ff       	jmp    80105ef4 <alltraps>

8010669e <vector43>:
8010669e:	6a 00                	push   $0x0
801066a0:	6a 2b                	push   $0x2b
801066a2:	e9 4d f8 ff ff       	jmp    80105ef4 <alltraps>

801066a7 <vector44>:
801066a7:	6a 00                	push   $0x0
801066a9:	6a 2c                	push   $0x2c
801066ab:	e9 44 f8 ff ff       	jmp    80105ef4 <alltraps>

801066b0 <vector45>:
801066b0:	6a 00                	push   $0x0
801066b2:	6a 2d                	push   $0x2d
801066b4:	e9 3b f8 ff ff       	jmp    80105ef4 <alltraps>

801066b9 <vector46>:
801066b9:	6a 00                	push   $0x0
801066bb:	6a 2e                	push   $0x2e
801066bd:	e9 32 f8 ff ff       	jmp    80105ef4 <alltraps>

801066c2 <vector47>:
801066c2:	6a 00                	push   $0x0
801066c4:	6a 2f                	push   $0x2f
801066c6:	e9 29 f8 ff ff       	jmp    80105ef4 <alltraps>

801066cb <vector48>:
801066cb:	6a 00                	push   $0x0
801066cd:	6a 30                	push   $0x30
801066cf:	e9 20 f8 ff ff       	jmp    80105ef4 <alltraps>

801066d4 <vector49>:
801066d4:	6a 00                	push   $0x0
801066d6:	6a 31                	push   $0x31
801066d8:	e9 17 f8 ff ff       	jmp    80105ef4 <alltraps>

801066dd <vector50>:
801066dd:	6a 00                	push   $0x0
801066df:	6a 32                	push   $0x32
801066e1:	e9 0e f8 ff ff       	jmp    80105ef4 <alltraps>

801066e6 <vector51>:
801066e6:	6a 00                	push   $0x0
801066e8:	6a 33                	push   $0x33
801066ea:	e9 05 f8 ff ff       	jmp    80105ef4 <alltraps>

801066ef <vector52>:
801066ef:	6a 00                	push   $0x0
801066f1:	6a 34                	push   $0x34
801066f3:	e9 fc f7 ff ff       	jmp    80105ef4 <alltraps>

801066f8 <vector53>:
801066f8:	6a 00                	push   $0x0
801066fa:	6a 35                	push   $0x35
801066fc:	e9 f3 f7 ff ff       	jmp    80105ef4 <alltraps>

80106701 <vector54>:
80106701:	6a 00                	push   $0x0
80106703:	6a 36                	push   $0x36
80106705:	e9 ea f7 ff ff       	jmp    80105ef4 <alltraps>

8010670a <vector55>:
8010670a:	6a 00                	push   $0x0
8010670c:	6a 37                	push   $0x37
8010670e:	e9 e1 f7 ff ff       	jmp    80105ef4 <alltraps>

80106713 <vector56>:
80106713:	6a 00                	push   $0x0
80106715:	6a 38                	push   $0x38
80106717:	e9 d8 f7 ff ff       	jmp    80105ef4 <alltraps>

8010671c <vector57>:
8010671c:	6a 00                	push   $0x0
8010671e:	6a 39                	push   $0x39
80106720:	e9 cf f7 ff ff       	jmp    80105ef4 <alltraps>

80106725 <vector58>:
80106725:	6a 00                	push   $0x0
80106727:	6a 3a                	push   $0x3a
80106729:	e9 c6 f7 ff ff       	jmp    80105ef4 <alltraps>

8010672e <vector59>:
8010672e:	6a 00                	push   $0x0
80106730:	6a 3b                	push   $0x3b
80106732:	e9 bd f7 ff ff       	jmp    80105ef4 <alltraps>

80106737 <vector60>:
80106737:	6a 00                	push   $0x0
80106739:	6a 3c                	push   $0x3c
8010673b:	e9 b4 f7 ff ff       	jmp    80105ef4 <alltraps>

80106740 <vector61>:
80106740:	6a 00                	push   $0x0
80106742:	6a 3d                	push   $0x3d
80106744:	e9 ab f7 ff ff       	jmp    80105ef4 <alltraps>

80106749 <vector62>:
80106749:	6a 00                	push   $0x0
8010674b:	6a 3e                	push   $0x3e
8010674d:	e9 a2 f7 ff ff       	jmp    80105ef4 <alltraps>

80106752 <vector63>:
80106752:	6a 00                	push   $0x0
80106754:	6a 3f                	push   $0x3f
80106756:	e9 99 f7 ff ff       	jmp    80105ef4 <alltraps>

8010675b <vector64>:
8010675b:	6a 00                	push   $0x0
8010675d:	6a 40                	push   $0x40
8010675f:	e9 90 f7 ff ff       	jmp    80105ef4 <alltraps>

80106764 <vector65>:
80106764:	6a 00                	push   $0x0
80106766:	6a 41                	push   $0x41
80106768:	e9 87 f7 ff ff       	jmp    80105ef4 <alltraps>

8010676d <vector66>:
8010676d:	6a 00                	push   $0x0
8010676f:	6a 42                	push   $0x42
80106771:	e9 7e f7 ff ff       	jmp    80105ef4 <alltraps>

80106776 <vector67>:
80106776:	6a 00                	push   $0x0
80106778:	6a 43                	push   $0x43
8010677a:	e9 75 f7 ff ff       	jmp    80105ef4 <alltraps>

8010677f <vector68>:
8010677f:	6a 00                	push   $0x0
80106781:	6a 44                	push   $0x44
80106783:	e9 6c f7 ff ff       	jmp    80105ef4 <alltraps>

80106788 <vector69>:
80106788:	6a 00                	push   $0x0
8010678a:	6a 45                	push   $0x45
8010678c:	e9 63 f7 ff ff       	jmp    80105ef4 <alltraps>

80106791 <vector70>:
80106791:	6a 00                	push   $0x0
80106793:	6a 46                	push   $0x46
80106795:	e9 5a f7 ff ff       	jmp    80105ef4 <alltraps>

8010679a <vector71>:
8010679a:	6a 00                	push   $0x0
8010679c:	6a 47                	push   $0x47
8010679e:	e9 51 f7 ff ff       	jmp    80105ef4 <alltraps>

801067a3 <vector72>:
801067a3:	6a 00                	push   $0x0
801067a5:	6a 48                	push   $0x48
801067a7:	e9 48 f7 ff ff       	jmp    80105ef4 <alltraps>

801067ac <vector73>:
801067ac:	6a 00                	push   $0x0
801067ae:	6a 49                	push   $0x49
801067b0:	e9 3f f7 ff ff       	jmp    80105ef4 <alltraps>

801067b5 <vector74>:
801067b5:	6a 00                	push   $0x0
801067b7:	6a 4a                	push   $0x4a
801067b9:	e9 36 f7 ff ff       	jmp    80105ef4 <alltraps>

801067be <vector75>:
801067be:	6a 00                	push   $0x0
801067c0:	6a 4b                	push   $0x4b
801067c2:	e9 2d f7 ff ff       	jmp    80105ef4 <alltraps>

801067c7 <vector76>:
801067c7:	6a 00                	push   $0x0
801067c9:	6a 4c                	push   $0x4c
801067cb:	e9 24 f7 ff ff       	jmp    80105ef4 <alltraps>

801067d0 <vector77>:
801067d0:	6a 00                	push   $0x0
801067d2:	6a 4d                	push   $0x4d
801067d4:	e9 1b f7 ff ff       	jmp    80105ef4 <alltraps>

801067d9 <vector78>:
801067d9:	6a 00                	push   $0x0
801067db:	6a 4e                	push   $0x4e
801067dd:	e9 12 f7 ff ff       	jmp    80105ef4 <alltraps>

801067e2 <vector79>:
801067e2:	6a 00                	push   $0x0
801067e4:	6a 4f                	push   $0x4f
801067e6:	e9 09 f7 ff ff       	jmp    80105ef4 <alltraps>

801067eb <vector80>:
801067eb:	6a 00                	push   $0x0
801067ed:	6a 50                	push   $0x50
801067ef:	e9 00 f7 ff ff       	jmp    80105ef4 <alltraps>

801067f4 <vector81>:
801067f4:	6a 00                	push   $0x0
801067f6:	6a 51                	push   $0x51
801067f8:	e9 f7 f6 ff ff       	jmp    80105ef4 <alltraps>

801067fd <vector82>:
801067fd:	6a 00                	push   $0x0
801067ff:	6a 52                	push   $0x52
80106801:	e9 ee f6 ff ff       	jmp    80105ef4 <alltraps>

80106806 <vector83>:
80106806:	6a 00                	push   $0x0
80106808:	6a 53                	push   $0x53
8010680a:	e9 e5 f6 ff ff       	jmp    80105ef4 <alltraps>

8010680f <vector84>:
8010680f:	6a 00                	push   $0x0
80106811:	6a 54                	push   $0x54
80106813:	e9 dc f6 ff ff       	jmp    80105ef4 <alltraps>

80106818 <vector85>:
80106818:	6a 00                	push   $0x0
8010681a:	6a 55                	push   $0x55
8010681c:	e9 d3 f6 ff ff       	jmp    80105ef4 <alltraps>

80106821 <vector86>:
80106821:	6a 00                	push   $0x0
80106823:	6a 56                	push   $0x56
80106825:	e9 ca f6 ff ff       	jmp    80105ef4 <alltraps>

8010682a <vector87>:
8010682a:	6a 00                	push   $0x0
8010682c:	6a 57                	push   $0x57
8010682e:	e9 c1 f6 ff ff       	jmp    80105ef4 <alltraps>

80106833 <vector88>:
80106833:	6a 00                	push   $0x0
80106835:	6a 58                	push   $0x58
80106837:	e9 b8 f6 ff ff       	jmp    80105ef4 <alltraps>

8010683c <vector89>:
8010683c:	6a 00                	push   $0x0
8010683e:	6a 59                	push   $0x59
80106840:	e9 af f6 ff ff       	jmp    80105ef4 <alltraps>

80106845 <vector90>:
80106845:	6a 00                	push   $0x0
80106847:	6a 5a                	push   $0x5a
80106849:	e9 a6 f6 ff ff       	jmp    80105ef4 <alltraps>

8010684e <vector91>:
8010684e:	6a 00                	push   $0x0
80106850:	6a 5b                	push   $0x5b
80106852:	e9 9d f6 ff ff       	jmp    80105ef4 <alltraps>

80106857 <vector92>:
80106857:	6a 00                	push   $0x0
80106859:	6a 5c                	push   $0x5c
8010685b:	e9 94 f6 ff ff       	jmp    80105ef4 <alltraps>

80106860 <vector93>:
80106860:	6a 00                	push   $0x0
80106862:	6a 5d                	push   $0x5d
80106864:	e9 8b f6 ff ff       	jmp    80105ef4 <alltraps>

80106869 <vector94>:
80106869:	6a 00                	push   $0x0
8010686b:	6a 5e                	push   $0x5e
8010686d:	e9 82 f6 ff ff       	jmp    80105ef4 <alltraps>

80106872 <vector95>:
80106872:	6a 00                	push   $0x0
80106874:	6a 5f                	push   $0x5f
80106876:	e9 79 f6 ff ff       	jmp    80105ef4 <alltraps>

8010687b <vector96>:
8010687b:	6a 00                	push   $0x0
8010687d:	6a 60                	push   $0x60
8010687f:	e9 70 f6 ff ff       	jmp    80105ef4 <alltraps>

80106884 <vector97>:
80106884:	6a 00                	push   $0x0
80106886:	6a 61                	push   $0x61
80106888:	e9 67 f6 ff ff       	jmp    80105ef4 <alltraps>

8010688d <vector98>:
8010688d:	6a 00                	push   $0x0
8010688f:	6a 62                	push   $0x62
80106891:	e9 5e f6 ff ff       	jmp    80105ef4 <alltraps>

80106896 <vector99>:
80106896:	6a 00                	push   $0x0
80106898:	6a 63                	push   $0x63
8010689a:	e9 55 f6 ff ff       	jmp    80105ef4 <alltraps>

8010689f <vector100>:
8010689f:	6a 00                	push   $0x0
801068a1:	6a 64                	push   $0x64
801068a3:	e9 4c f6 ff ff       	jmp    80105ef4 <alltraps>

801068a8 <vector101>:
801068a8:	6a 00                	push   $0x0
801068aa:	6a 65                	push   $0x65
801068ac:	e9 43 f6 ff ff       	jmp    80105ef4 <alltraps>

801068b1 <vector102>:
801068b1:	6a 00                	push   $0x0
801068b3:	6a 66                	push   $0x66
801068b5:	e9 3a f6 ff ff       	jmp    80105ef4 <alltraps>

801068ba <vector103>:
801068ba:	6a 00                	push   $0x0
801068bc:	6a 67                	push   $0x67
801068be:	e9 31 f6 ff ff       	jmp    80105ef4 <alltraps>

801068c3 <vector104>:
801068c3:	6a 00                	push   $0x0
801068c5:	6a 68                	push   $0x68
801068c7:	e9 28 f6 ff ff       	jmp    80105ef4 <alltraps>

801068cc <vector105>:
801068cc:	6a 00                	push   $0x0
801068ce:	6a 69                	push   $0x69
801068d0:	e9 1f f6 ff ff       	jmp    80105ef4 <alltraps>

801068d5 <vector106>:
801068d5:	6a 00                	push   $0x0
801068d7:	6a 6a                	push   $0x6a
801068d9:	e9 16 f6 ff ff       	jmp    80105ef4 <alltraps>

801068de <vector107>:
801068de:	6a 00                	push   $0x0
801068e0:	6a 6b                	push   $0x6b
801068e2:	e9 0d f6 ff ff       	jmp    80105ef4 <alltraps>

801068e7 <vector108>:
801068e7:	6a 00                	push   $0x0
801068e9:	6a 6c                	push   $0x6c
801068eb:	e9 04 f6 ff ff       	jmp    80105ef4 <alltraps>

801068f0 <vector109>:
801068f0:	6a 00                	push   $0x0
801068f2:	6a 6d                	push   $0x6d
801068f4:	e9 fb f5 ff ff       	jmp    80105ef4 <alltraps>

801068f9 <vector110>:
801068f9:	6a 00                	push   $0x0
801068fb:	6a 6e                	push   $0x6e
801068fd:	e9 f2 f5 ff ff       	jmp    80105ef4 <alltraps>

80106902 <vector111>:
80106902:	6a 00                	push   $0x0
80106904:	6a 6f                	push   $0x6f
80106906:	e9 e9 f5 ff ff       	jmp    80105ef4 <alltraps>

8010690b <vector112>:
8010690b:	6a 00                	push   $0x0
8010690d:	6a 70                	push   $0x70
8010690f:	e9 e0 f5 ff ff       	jmp    80105ef4 <alltraps>

80106914 <vector113>:
80106914:	6a 00                	push   $0x0
80106916:	6a 71                	push   $0x71
80106918:	e9 d7 f5 ff ff       	jmp    80105ef4 <alltraps>

8010691d <vector114>:
8010691d:	6a 00                	push   $0x0
8010691f:	6a 72                	push   $0x72
80106921:	e9 ce f5 ff ff       	jmp    80105ef4 <alltraps>

80106926 <vector115>:
80106926:	6a 00                	push   $0x0
80106928:	6a 73                	push   $0x73
8010692a:	e9 c5 f5 ff ff       	jmp    80105ef4 <alltraps>

8010692f <vector116>:
8010692f:	6a 00                	push   $0x0
80106931:	6a 74                	push   $0x74
80106933:	e9 bc f5 ff ff       	jmp    80105ef4 <alltraps>

80106938 <vector117>:
80106938:	6a 00                	push   $0x0
8010693a:	6a 75                	push   $0x75
8010693c:	e9 b3 f5 ff ff       	jmp    80105ef4 <alltraps>

80106941 <vector118>:
80106941:	6a 00                	push   $0x0
80106943:	6a 76                	push   $0x76
80106945:	e9 aa f5 ff ff       	jmp    80105ef4 <alltraps>

8010694a <vector119>:
8010694a:	6a 00                	push   $0x0
8010694c:	6a 77                	push   $0x77
8010694e:	e9 a1 f5 ff ff       	jmp    80105ef4 <alltraps>

80106953 <vector120>:
80106953:	6a 00                	push   $0x0
80106955:	6a 78                	push   $0x78
80106957:	e9 98 f5 ff ff       	jmp    80105ef4 <alltraps>

8010695c <vector121>:
8010695c:	6a 00                	push   $0x0
8010695e:	6a 79                	push   $0x79
80106960:	e9 8f f5 ff ff       	jmp    80105ef4 <alltraps>

80106965 <vector122>:
80106965:	6a 00                	push   $0x0
80106967:	6a 7a                	push   $0x7a
80106969:	e9 86 f5 ff ff       	jmp    80105ef4 <alltraps>

8010696e <vector123>:
8010696e:	6a 00                	push   $0x0
80106970:	6a 7b                	push   $0x7b
80106972:	e9 7d f5 ff ff       	jmp    80105ef4 <alltraps>

80106977 <vector124>:
80106977:	6a 00                	push   $0x0
80106979:	6a 7c                	push   $0x7c
8010697b:	e9 74 f5 ff ff       	jmp    80105ef4 <alltraps>

80106980 <vector125>:
80106980:	6a 00                	push   $0x0
80106982:	6a 7d                	push   $0x7d
80106984:	e9 6b f5 ff ff       	jmp    80105ef4 <alltraps>

80106989 <vector126>:
80106989:	6a 00                	push   $0x0
8010698b:	6a 7e                	push   $0x7e
8010698d:	e9 62 f5 ff ff       	jmp    80105ef4 <alltraps>

80106992 <vector127>:
80106992:	6a 00                	push   $0x0
80106994:	6a 7f                	push   $0x7f
80106996:	e9 59 f5 ff ff       	jmp    80105ef4 <alltraps>

8010699b <vector128>:
8010699b:	6a 00                	push   $0x0
8010699d:	68 80 00 00 00       	push   $0x80
801069a2:	e9 4d f5 ff ff       	jmp    80105ef4 <alltraps>

801069a7 <vector129>:
801069a7:	6a 00                	push   $0x0
801069a9:	68 81 00 00 00       	push   $0x81
801069ae:	e9 41 f5 ff ff       	jmp    80105ef4 <alltraps>

801069b3 <vector130>:
801069b3:	6a 00                	push   $0x0
801069b5:	68 82 00 00 00       	push   $0x82
801069ba:	e9 35 f5 ff ff       	jmp    80105ef4 <alltraps>

801069bf <vector131>:
801069bf:	6a 00                	push   $0x0
801069c1:	68 83 00 00 00       	push   $0x83
801069c6:	e9 29 f5 ff ff       	jmp    80105ef4 <alltraps>

801069cb <vector132>:
801069cb:	6a 00                	push   $0x0
801069cd:	68 84 00 00 00       	push   $0x84
801069d2:	e9 1d f5 ff ff       	jmp    80105ef4 <alltraps>

801069d7 <vector133>:
801069d7:	6a 00                	push   $0x0
801069d9:	68 85 00 00 00       	push   $0x85
801069de:	e9 11 f5 ff ff       	jmp    80105ef4 <alltraps>

801069e3 <vector134>:
801069e3:	6a 00                	push   $0x0
801069e5:	68 86 00 00 00       	push   $0x86
801069ea:	e9 05 f5 ff ff       	jmp    80105ef4 <alltraps>

801069ef <vector135>:
801069ef:	6a 00                	push   $0x0
801069f1:	68 87 00 00 00       	push   $0x87
801069f6:	e9 f9 f4 ff ff       	jmp    80105ef4 <alltraps>

801069fb <vector136>:
801069fb:	6a 00                	push   $0x0
801069fd:	68 88 00 00 00       	push   $0x88
80106a02:	e9 ed f4 ff ff       	jmp    80105ef4 <alltraps>

80106a07 <vector137>:
80106a07:	6a 00                	push   $0x0
80106a09:	68 89 00 00 00       	push   $0x89
80106a0e:	e9 e1 f4 ff ff       	jmp    80105ef4 <alltraps>

80106a13 <vector138>:
80106a13:	6a 00                	push   $0x0
80106a15:	68 8a 00 00 00       	push   $0x8a
80106a1a:	e9 d5 f4 ff ff       	jmp    80105ef4 <alltraps>

80106a1f <vector139>:
80106a1f:	6a 00                	push   $0x0
80106a21:	68 8b 00 00 00       	push   $0x8b
80106a26:	e9 c9 f4 ff ff       	jmp    80105ef4 <alltraps>

80106a2b <vector140>:
80106a2b:	6a 00                	push   $0x0
80106a2d:	68 8c 00 00 00       	push   $0x8c
80106a32:	e9 bd f4 ff ff       	jmp    80105ef4 <alltraps>

80106a37 <vector141>:
80106a37:	6a 00                	push   $0x0
80106a39:	68 8d 00 00 00       	push   $0x8d
80106a3e:	e9 b1 f4 ff ff       	jmp    80105ef4 <alltraps>

80106a43 <vector142>:
80106a43:	6a 00                	push   $0x0
80106a45:	68 8e 00 00 00       	push   $0x8e
80106a4a:	e9 a5 f4 ff ff       	jmp    80105ef4 <alltraps>

80106a4f <vector143>:
80106a4f:	6a 00                	push   $0x0
80106a51:	68 8f 00 00 00       	push   $0x8f
80106a56:	e9 99 f4 ff ff       	jmp    80105ef4 <alltraps>

80106a5b <vector144>:
80106a5b:	6a 00                	push   $0x0
80106a5d:	68 90 00 00 00       	push   $0x90
80106a62:	e9 8d f4 ff ff       	jmp    80105ef4 <alltraps>

80106a67 <vector145>:
80106a67:	6a 00                	push   $0x0
80106a69:	68 91 00 00 00       	push   $0x91
80106a6e:	e9 81 f4 ff ff       	jmp    80105ef4 <alltraps>

80106a73 <vector146>:
80106a73:	6a 00                	push   $0x0
80106a75:	68 92 00 00 00       	push   $0x92
80106a7a:	e9 75 f4 ff ff       	jmp    80105ef4 <alltraps>

80106a7f <vector147>:
80106a7f:	6a 00                	push   $0x0
80106a81:	68 93 00 00 00       	push   $0x93
80106a86:	e9 69 f4 ff ff       	jmp    80105ef4 <alltraps>

80106a8b <vector148>:
80106a8b:	6a 00                	push   $0x0
80106a8d:	68 94 00 00 00       	push   $0x94
80106a92:	e9 5d f4 ff ff       	jmp    80105ef4 <alltraps>

80106a97 <vector149>:
80106a97:	6a 00                	push   $0x0
80106a99:	68 95 00 00 00       	push   $0x95
80106a9e:	e9 51 f4 ff ff       	jmp    80105ef4 <alltraps>

80106aa3 <vector150>:
80106aa3:	6a 00                	push   $0x0
80106aa5:	68 96 00 00 00       	push   $0x96
80106aaa:	e9 45 f4 ff ff       	jmp    80105ef4 <alltraps>

80106aaf <vector151>:
80106aaf:	6a 00                	push   $0x0
80106ab1:	68 97 00 00 00       	push   $0x97
80106ab6:	e9 39 f4 ff ff       	jmp    80105ef4 <alltraps>

80106abb <vector152>:
80106abb:	6a 00                	push   $0x0
80106abd:	68 98 00 00 00       	push   $0x98
80106ac2:	e9 2d f4 ff ff       	jmp    80105ef4 <alltraps>

80106ac7 <vector153>:
80106ac7:	6a 00                	push   $0x0
80106ac9:	68 99 00 00 00       	push   $0x99
80106ace:	e9 21 f4 ff ff       	jmp    80105ef4 <alltraps>

80106ad3 <vector154>:
80106ad3:	6a 00                	push   $0x0
80106ad5:	68 9a 00 00 00       	push   $0x9a
80106ada:	e9 15 f4 ff ff       	jmp    80105ef4 <alltraps>

80106adf <vector155>:
80106adf:	6a 00                	push   $0x0
80106ae1:	68 9b 00 00 00       	push   $0x9b
80106ae6:	e9 09 f4 ff ff       	jmp    80105ef4 <alltraps>

80106aeb <vector156>:
80106aeb:	6a 00                	push   $0x0
80106aed:	68 9c 00 00 00       	push   $0x9c
80106af2:	e9 fd f3 ff ff       	jmp    80105ef4 <alltraps>

80106af7 <vector157>:
80106af7:	6a 00                	push   $0x0
80106af9:	68 9d 00 00 00       	push   $0x9d
80106afe:	e9 f1 f3 ff ff       	jmp    80105ef4 <alltraps>

80106b03 <vector158>:
80106b03:	6a 00                	push   $0x0
80106b05:	68 9e 00 00 00       	push   $0x9e
80106b0a:	e9 e5 f3 ff ff       	jmp    80105ef4 <alltraps>

80106b0f <vector159>:
80106b0f:	6a 00                	push   $0x0
80106b11:	68 9f 00 00 00       	push   $0x9f
80106b16:	e9 d9 f3 ff ff       	jmp    80105ef4 <alltraps>

80106b1b <vector160>:
80106b1b:	6a 00                	push   $0x0
80106b1d:	68 a0 00 00 00       	push   $0xa0
80106b22:	e9 cd f3 ff ff       	jmp    80105ef4 <alltraps>

80106b27 <vector161>:
80106b27:	6a 00                	push   $0x0
80106b29:	68 a1 00 00 00       	push   $0xa1
80106b2e:	e9 c1 f3 ff ff       	jmp    80105ef4 <alltraps>

80106b33 <vector162>:
80106b33:	6a 00                	push   $0x0
80106b35:	68 a2 00 00 00       	push   $0xa2
80106b3a:	e9 b5 f3 ff ff       	jmp    80105ef4 <alltraps>

80106b3f <vector163>:
80106b3f:	6a 00                	push   $0x0
80106b41:	68 a3 00 00 00       	push   $0xa3
80106b46:	e9 a9 f3 ff ff       	jmp    80105ef4 <alltraps>

80106b4b <vector164>:
80106b4b:	6a 00                	push   $0x0
80106b4d:	68 a4 00 00 00       	push   $0xa4
80106b52:	e9 9d f3 ff ff       	jmp    80105ef4 <alltraps>

80106b57 <vector165>:
80106b57:	6a 00                	push   $0x0
80106b59:	68 a5 00 00 00       	push   $0xa5
80106b5e:	e9 91 f3 ff ff       	jmp    80105ef4 <alltraps>

80106b63 <vector166>:
80106b63:	6a 00                	push   $0x0
80106b65:	68 a6 00 00 00       	push   $0xa6
80106b6a:	e9 85 f3 ff ff       	jmp    80105ef4 <alltraps>

80106b6f <vector167>:
80106b6f:	6a 00                	push   $0x0
80106b71:	68 a7 00 00 00       	push   $0xa7
80106b76:	e9 79 f3 ff ff       	jmp    80105ef4 <alltraps>

80106b7b <vector168>:
80106b7b:	6a 00                	push   $0x0
80106b7d:	68 a8 00 00 00       	push   $0xa8
80106b82:	e9 6d f3 ff ff       	jmp    80105ef4 <alltraps>

80106b87 <vector169>:
80106b87:	6a 00                	push   $0x0
80106b89:	68 a9 00 00 00       	push   $0xa9
80106b8e:	e9 61 f3 ff ff       	jmp    80105ef4 <alltraps>

80106b93 <vector170>:
80106b93:	6a 00                	push   $0x0
80106b95:	68 aa 00 00 00       	push   $0xaa
80106b9a:	e9 55 f3 ff ff       	jmp    80105ef4 <alltraps>

80106b9f <vector171>:
80106b9f:	6a 00                	push   $0x0
80106ba1:	68 ab 00 00 00       	push   $0xab
80106ba6:	e9 49 f3 ff ff       	jmp    80105ef4 <alltraps>

80106bab <vector172>:
80106bab:	6a 00                	push   $0x0
80106bad:	68 ac 00 00 00       	push   $0xac
80106bb2:	e9 3d f3 ff ff       	jmp    80105ef4 <alltraps>

80106bb7 <vector173>:
80106bb7:	6a 00                	push   $0x0
80106bb9:	68 ad 00 00 00       	push   $0xad
80106bbe:	e9 31 f3 ff ff       	jmp    80105ef4 <alltraps>

80106bc3 <vector174>:
80106bc3:	6a 00                	push   $0x0
80106bc5:	68 ae 00 00 00       	push   $0xae
80106bca:	e9 25 f3 ff ff       	jmp    80105ef4 <alltraps>

80106bcf <vector175>:
80106bcf:	6a 00                	push   $0x0
80106bd1:	68 af 00 00 00       	push   $0xaf
80106bd6:	e9 19 f3 ff ff       	jmp    80105ef4 <alltraps>

80106bdb <vector176>:
80106bdb:	6a 00                	push   $0x0
80106bdd:	68 b0 00 00 00       	push   $0xb0
80106be2:	e9 0d f3 ff ff       	jmp    80105ef4 <alltraps>

80106be7 <vector177>:
80106be7:	6a 00                	push   $0x0
80106be9:	68 b1 00 00 00       	push   $0xb1
80106bee:	e9 01 f3 ff ff       	jmp    80105ef4 <alltraps>

80106bf3 <vector178>:
80106bf3:	6a 00                	push   $0x0
80106bf5:	68 b2 00 00 00       	push   $0xb2
80106bfa:	e9 f5 f2 ff ff       	jmp    80105ef4 <alltraps>

80106bff <vector179>:
80106bff:	6a 00                	push   $0x0
80106c01:	68 b3 00 00 00       	push   $0xb3
80106c06:	e9 e9 f2 ff ff       	jmp    80105ef4 <alltraps>

80106c0b <vector180>:
80106c0b:	6a 00                	push   $0x0
80106c0d:	68 b4 00 00 00       	push   $0xb4
80106c12:	e9 dd f2 ff ff       	jmp    80105ef4 <alltraps>

80106c17 <vector181>:
80106c17:	6a 00                	push   $0x0
80106c19:	68 b5 00 00 00       	push   $0xb5
80106c1e:	e9 d1 f2 ff ff       	jmp    80105ef4 <alltraps>

80106c23 <vector182>:
80106c23:	6a 00                	push   $0x0
80106c25:	68 b6 00 00 00       	push   $0xb6
80106c2a:	e9 c5 f2 ff ff       	jmp    80105ef4 <alltraps>

80106c2f <vector183>:
80106c2f:	6a 00                	push   $0x0
80106c31:	68 b7 00 00 00       	push   $0xb7
80106c36:	e9 b9 f2 ff ff       	jmp    80105ef4 <alltraps>

80106c3b <vector184>:
80106c3b:	6a 00                	push   $0x0
80106c3d:	68 b8 00 00 00       	push   $0xb8
80106c42:	e9 ad f2 ff ff       	jmp    80105ef4 <alltraps>

80106c47 <vector185>:
80106c47:	6a 00                	push   $0x0
80106c49:	68 b9 00 00 00       	push   $0xb9
80106c4e:	e9 a1 f2 ff ff       	jmp    80105ef4 <alltraps>

80106c53 <vector186>:
80106c53:	6a 00                	push   $0x0
80106c55:	68 ba 00 00 00       	push   $0xba
80106c5a:	e9 95 f2 ff ff       	jmp    80105ef4 <alltraps>

80106c5f <vector187>:
80106c5f:	6a 00                	push   $0x0
80106c61:	68 bb 00 00 00       	push   $0xbb
80106c66:	e9 89 f2 ff ff       	jmp    80105ef4 <alltraps>

80106c6b <vector188>:
80106c6b:	6a 00                	push   $0x0
80106c6d:	68 bc 00 00 00       	push   $0xbc
80106c72:	e9 7d f2 ff ff       	jmp    80105ef4 <alltraps>

80106c77 <vector189>:
80106c77:	6a 00                	push   $0x0
80106c79:	68 bd 00 00 00       	push   $0xbd
80106c7e:	e9 71 f2 ff ff       	jmp    80105ef4 <alltraps>

80106c83 <vector190>:
80106c83:	6a 00                	push   $0x0
80106c85:	68 be 00 00 00       	push   $0xbe
80106c8a:	e9 65 f2 ff ff       	jmp    80105ef4 <alltraps>

80106c8f <vector191>:
80106c8f:	6a 00                	push   $0x0
80106c91:	68 bf 00 00 00       	push   $0xbf
80106c96:	e9 59 f2 ff ff       	jmp    80105ef4 <alltraps>

80106c9b <vector192>:
80106c9b:	6a 00                	push   $0x0
80106c9d:	68 c0 00 00 00       	push   $0xc0
80106ca2:	e9 4d f2 ff ff       	jmp    80105ef4 <alltraps>

80106ca7 <vector193>:
80106ca7:	6a 00                	push   $0x0
80106ca9:	68 c1 00 00 00       	push   $0xc1
80106cae:	e9 41 f2 ff ff       	jmp    80105ef4 <alltraps>

80106cb3 <vector194>:
80106cb3:	6a 00                	push   $0x0
80106cb5:	68 c2 00 00 00       	push   $0xc2
80106cba:	e9 35 f2 ff ff       	jmp    80105ef4 <alltraps>

80106cbf <vector195>:
80106cbf:	6a 00                	push   $0x0
80106cc1:	68 c3 00 00 00       	push   $0xc3
80106cc6:	e9 29 f2 ff ff       	jmp    80105ef4 <alltraps>

80106ccb <vector196>:
80106ccb:	6a 00                	push   $0x0
80106ccd:	68 c4 00 00 00       	push   $0xc4
80106cd2:	e9 1d f2 ff ff       	jmp    80105ef4 <alltraps>

80106cd7 <vector197>:
80106cd7:	6a 00                	push   $0x0
80106cd9:	68 c5 00 00 00       	push   $0xc5
80106cde:	e9 11 f2 ff ff       	jmp    80105ef4 <alltraps>

80106ce3 <vector198>:
80106ce3:	6a 00                	push   $0x0
80106ce5:	68 c6 00 00 00       	push   $0xc6
80106cea:	e9 05 f2 ff ff       	jmp    80105ef4 <alltraps>

80106cef <vector199>:
80106cef:	6a 00                	push   $0x0
80106cf1:	68 c7 00 00 00       	push   $0xc7
80106cf6:	e9 f9 f1 ff ff       	jmp    80105ef4 <alltraps>

80106cfb <vector200>:
80106cfb:	6a 00                	push   $0x0
80106cfd:	68 c8 00 00 00       	push   $0xc8
80106d02:	e9 ed f1 ff ff       	jmp    80105ef4 <alltraps>

80106d07 <vector201>:
80106d07:	6a 00                	push   $0x0
80106d09:	68 c9 00 00 00       	push   $0xc9
80106d0e:	e9 e1 f1 ff ff       	jmp    80105ef4 <alltraps>

80106d13 <vector202>:
80106d13:	6a 00                	push   $0x0
80106d15:	68 ca 00 00 00       	push   $0xca
80106d1a:	e9 d5 f1 ff ff       	jmp    80105ef4 <alltraps>

80106d1f <vector203>:
80106d1f:	6a 00                	push   $0x0
80106d21:	68 cb 00 00 00       	push   $0xcb
80106d26:	e9 c9 f1 ff ff       	jmp    80105ef4 <alltraps>

80106d2b <vector204>:
80106d2b:	6a 00                	push   $0x0
80106d2d:	68 cc 00 00 00       	push   $0xcc
80106d32:	e9 bd f1 ff ff       	jmp    80105ef4 <alltraps>

80106d37 <vector205>:
80106d37:	6a 00                	push   $0x0
80106d39:	68 cd 00 00 00       	push   $0xcd
80106d3e:	e9 b1 f1 ff ff       	jmp    80105ef4 <alltraps>

80106d43 <vector206>:
80106d43:	6a 00                	push   $0x0
80106d45:	68 ce 00 00 00       	push   $0xce
80106d4a:	e9 a5 f1 ff ff       	jmp    80105ef4 <alltraps>

80106d4f <vector207>:
80106d4f:	6a 00                	push   $0x0
80106d51:	68 cf 00 00 00       	push   $0xcf
80106d56:	e9 99 f1 ff ff       	jmp    80105ef4 <alltraps>

80106d5b <vector208>:
80106d5b:	6a 00                	push   $0x0
80106d5d:	68 d0 00 00 00       	push   $0xd0
80106d62:	e9 8d f1 ff ff       	jmp    80105ef4 <alltraps>

80106d67 <vector209>:
80106d67:	6a 00                	push   $0x0
80106d69:	68 d1 00 00 00       	push   $0xd1
80106d6e:	e9 81 f1 ff ff       	jmp    80105ef4 <alltraps>

80106d73 <vector210>:
80106d73:	6a 00                	push   $0x0
80106d75:	68 d2 00 00 00       	push   $0xd2
80106d7a:	e9 75 f1 ff ff       	jmp    80105ef4 <alltraps>

80106d7f <vector211>:
80106d7f:	6a 00                	push   $0x0
80106d81:	68 d3 00 00 00       	push   $0xd3
80106d86:	e9 69 f1 ff ff       	jmp    80105ef4 <alltraps>

80106d8b <vector212>:
80106d8b:	6a 00                	push   $0x0
80106d8d:	68 d4 00 00 00       	push   $0xd4
80106d92:	e9 5d f1 ff ff       	jmp    80105ef4 <alltraps>

80106d97 <vector213>:
80106d97:	6a 00                	push   $0x0
80106d99:	68 d5 00 00 00       	push   $0xd5
80106d9e:	e9 51 f1 ff ff       	jmp    80105ef4 <alltraps>

80106da3 <vector214>:
80106da3:	6a 00                	push   $0x0
80106da5:	68 d6 00 00 00       	push   $0xd6
80106daa:	e9 45 f1 ff ff       	jmp    80105ef4 <alltraps>

80106daf <vector215>:
80106daf:	6a 00                	push   $0x0
80106db1:	68 d7 00 00 00       	push   $0xd7
80106db6:	e9 39 f1 ff ff       	jmp    80105ef4 <alltraps>

80106dbb <vector216>:
80106dbb:	6a 00                	push   $0x0
80106dbd:	68 d8 00 00 00       	push   $0xd8
80106dc2:	e9 2d f1 ff ff       	jmp    80105ef4 <alltraps>

80106dc7 <vector217>:
80106dc7:	6a 00                	push   $0x0
80106dc9:	68 d9 00 00 00       	push   $0xd9
80106dce:	e9 21 f1 ff ff       	jmp    80105ef4 <alltraps>

80106dd3 <vector218>:
80106dd3:	6a 00                	push   $0x0
80106dd5:	68 da 00 00 00       	push   $0xda
80106dda:	e9 15 f1 ff ff       	jmp    80105ef4 <alltraps>

80106ddf <vector219>:
80106ddf:	6a 00                	push   $0x0
80106de1:	68 db 00 00 00       	push   $0xdb
80106de6:	e9 09 f1 ff ff       	jmp    80105ef4 <alltraps>

80106deb <vector220>:
80106deb:	6a 00                	push   $0x0
80106ded:	68 dc 00 00 00       	push   $0xdc
80106df2:	e9 fd f0 ff ff       	jmp    80105ef4 <alltraps>

80106df7 <vector221>:
80106df7:	6a 00                	push   $0x0
80106df9:	68 dd 00 00 00       	push   $0xdd
80106dfe:	e9 f1 f0 ff ff       	jmp    80105ef4 <alltraps>

80106e03 <vector222>:
80106e03:	6a 00                	push   $0x0
80106e05:	68 de 00 00 00       	push   $0xde
80106e0a:	e9 e5 f0 ff ff       	jmp    80105ef4 <alltraps>

80106e0f <vector223>:
80106e0f:	6a 00                	push   $0x0
80106e11:	68 df 00 00 00       	push   $0xdf
80106e16:	e9 d9 f0 ff ff       	jmp    80105ef4 <alltraps>

80106e1b <vector224>:
80106e1b:	6a 00                	push   $0x0
80106e1d:	68 e0 00 00 00       	push   $0xe0
80106e22:	e9 cd f0 ff ff       	jmp    80105ef4 <alltraps>

80106e27 <vector225>:
80106e27:	6a 00                	push   $0x0
80106e29:	68 e1 00 00 00       	push   $0xe1
80106e2e:	e9 c1 f0 ff ff       	jmp    80105ef4 <alltraps>

80106e33 <vector226>:
80106e33:	6a 00                	push   $0x0
80106e35:	68 e2 00 00 00       	push   $0xe2
80106e3a:	e9 b5 f0 ff ff       	jmp    80105ef4 <alltraps>

80106e3f <vector227>:
80106e3f:	6a 00                	push   $0x0
80106e41:	68 e3 00 00 00       	push   $0xe3
80106e46:	e9 a9 f0 ff ff       	jmp    80105ef4 <alltraps>

80106e4b <vector228>:
80106e4b:	6a 00                	push   $0x0
80106e4d:	68 e4 00 00 00       	push   $0xe4
80106e52:	e9 9d f0 ff ff       	jmp    80105ef4 <alltraps>

80106e57 <vector229>:
80106e57:	6a 00                	push   $0x0
80106e59:	68 e5 00 00 00       	push   $0xe5
80106e5e:	e9 91 f0 ff ff       	jmp    80105ef4 <alltraps>

80106e63 <vector230>:
80106e63:	6a 00                	push   $0x0
80106e65:	68 e6 00 00 00       	push   $0xe6
80106e6a:	e9 85 f0 ff ff       	jmp    80105ef4 <alltraps>

80106e6f <vector231>:
80106e6f:	6a 00                	push   $0x0
80106e71:	68 e7 00 00 00       	push   $0xe7
80106e76:	e9 79 f0 ff ff       	jmp    80105ef4 <alltraps>

80106e7b <vector232>:
80106e7b:	6a 00                	push   $0x0
80106e7d:	68 e8 00 00 00       	push   $0xe8
80106e82:	e9 6d f0 ff ff       	jmp    80105ef4 <alltraps>

80106e87 <vector233>:
80106e87:	6a 00                	push   $0x0
80106e89:	68 e9 00 00 00       	push   $0xe9
80106e8e:	e9 61 f0 ff ff       	jmp    80105ef4 <alltraps>

80106e93 <vector234>:
80106e93:	6a 00                	push   $0x0
80106e95:	68 ea 00 00 00       	push   $0xea
80106e9a:	e9 55 f0 ff ff       	jmp    80105ef4 <alltraps>

80106e9f <vector235>:
80106e9f:	6a 00                	push   $0x0
80106ea1:	68 eb 00 00 00       	push   $0xeb
80106ea6:	e9 49 f0 ff ff       	jmp    80105ef4 <alltraps>

80106eab <vector236>:
80106eab:	6a 00                	push   $0x0
80106ead:	68 ec 00 00 00       	push   $0xec
80106eb2:	e9 3d f0 ff ff       	jmp    80105ef4 <alltraps>

80106eb7 <vector237>:
80106eb7:	6a 00                	push   $0x0
80106eb9:	68 ed 00 00 00       	push   $0xed
80106ebe:	e9 31 f0 ff ff       	jmp    80105ef4 <alltraps>

80106ec3 <vector238>:
80106ec3:	6a 00                	push   $0x0
80106ec5:	68 ee 00 00 00       	push   $0xee
80106eca:	e9 25 f0 ff ff       	jmp    80105ef4 <alltraps>

80106ecf <vector239>:
80106ecf:	6a 00                	push   $0x0
80106ed1:	68 ef 00 00 00       	push   $0xef
80106ed6:	e9 19 f0 ff ff       	jmp    80105ef4 <alltraps>

80106edb <vector240>:
80106edb:	6a 00                	push   $0x0
80106edd:	68 f0 00 00 00       	push   $0xf0
80106ee2:	e9 0d f0 ff ff       	jmp    80105ef4 <alltraps>

80106ee7 <vector241>:
80106ee7:	6a 00                	push   $0x0
80106ee9:	68 f1 00 00 00       	push   $0xf1
80106eee:	e9 01 f0 ff ff       	jmp    80105ef4 <alltraps>

80106ef3 <vector242>:
80106ef3:	6a 00                	push   $0x0
80106ef5:	68 f2 00 00 00       	push   $0xf2
80106efa:	e9 f5 ef ff ff       	jmp    80105ef4 <alltraps>

80106eff <vector243>:
80106eff:	6a 00                	push   $0x0
80106f01:	68 f3 00 00 00       	push   $0xf3
80106f06:	e9 e9 ef ff ff       	jmp    80105ef4 <alltraps>

80106f0b <vector244>:
80106f0b:	6a 00                	push   $0x0
80106f0d:	68 f4 00 00 00       	push   $0xf4
80106f12:	e9 dd ef ff ff       	jmp    80105ef4 <alltraps>

80106f17 <vector245>:
80106f17:	6a 00                	push   $0x0
80106f19:	68 f5 00 00 00       	push   $0xf5
80106f1e:	e9 d1 ef ff ff       	jmp    80105ef4 <alltraps>

80106f23 <vector246>:
80106f23:	6a 00                	push   $0x0
80106f25:	68 f6 00 00 00       	push   $0xf6
80106f2a:	e9 c5 ef ff ff       	jmp    80105ef4 <alltraps>

80106f2f <vector247>:
80106f2f:	6a 00                	push   $0x0
80106f31:	68 f7 00 00 00       	push   $0xf7
80106f36:	e9 b9 ef ff ff       	jmp    80105ef4 <alltraps>

80106f3b <vector248>:
80106f3b:	6a 00                	push   $0x0
80106f3d:	68 f8 00 00 00       	push   $0xf8
80106f42:	e9 ad ef ff ff       	jmp    80105ef4 <alltraps>

80106f47 <vector249>:
80106f47:	6a 00                	push   $0x0
80106f49:	68 f9 00 00 00       	push   $0xf9
80106f4e:	e9 a1 ef ff ff       	jmp    80105ef4 <alltraps>

80106f53 <vector250>:
80106f53:	6a 00                	push   $0x0
80106f55:	68 fa 00 00 00       	push   $0xfa
80106f5a:	e9 95 ef ff ff       	jmp    80105ef4 <alltraps>

80106f5f <vector251>:
80106f5f:	6a 00                	push   $0x0
80106f61:	68 fb 00 00 00       	push   $0xfb
80106f66:	e9 89 ef ff ff       	jmp    80105ef4 <alltraps>

80106f6b <vector252>:
80106f6b:	6a 00                	push   $0x0
80106f6d:	68 fc 00 00 00       	push   $0xfc
80106f72:	e9 7d ef ff ff       	jmp    80105ef4 <alltraps>

80106f77 <vector253>:
80106f77:	6a 00                	push   $0x0
80106f79:	68 fd 00 00 00       	push   $0xfd
80106f7e:	e9 71 ef ff ff       	jmp    80105ef4 <alltraps>

80106f83 <vector254>:
80106f83:	6a 00                	push   $0x0
80106f85:	68 fe 00 00 00       	push   $0xfe
80106f8a:	e9 65 ef ff ff       	jmp    80105ef4 <alltraps>

80106f8f <vector255>:
80106f8f:	6a 00                	push   $0x0
80106f91:	68 ff 00 00 00       	push   $0xff
80106f96:	e9 59 ef ff ff       	jmp    80105ef4 <alltraps>

80106f9b <lgdt>:
{
80106f9b:	55                   	push   %ebp
80106f9c:	89 e5                	mov    %esp,%ebp
80106f9e:	83 ec 10             	sub    $0x10,%esp
  pd[0] = size-1;
80106fa1:	8b 45 0c             	mov    0xc(%ebp),%eax
80106fa4:	83 e8 01             	sub    $0x1,%eax
80106fa7:	66 89 45 fa          	mov    %ax,-0x6(%ebp)
  pd[1] = (uint)p;
80106fab:	8b 45 08             	mov    0x8(%ebp),%eax
80106fae:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  pd[2] = (uint)p >> 16;
80106fb2:	8b 45 08             	mov    0x8(%ebp),%eax
80106fb5:	c1 e8 10             	shr    $0x10,%eax
80106fb8:	66 89 45 fe          	mov    %ax,-0x2(%ebp)
  asm volatile("lgdt (%0)" : : "r" (pd));
80106fbc:	8d 45 fa             	lea    -0x6(%ebp),%eax
80106fbf:	0f 01 10             	lgdtl  (%eax)
}
80106fc2:	90                   	nop
80106fc3:	c9                   	leave  
80106fc4:	c3                   	ret    

80106fc5 <ltr>:
{
80106fc5:	55                   	push   %ebp
80106fc6:	89 e5                	mov    %esp,%ebp
80106fc8:	83 ec 04             	sub    $0x4,%esp
80106fcb:	8b 45 08             	mov    0x8(%ebp),%eax
80106fce:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  asm volatile("ltr %0" : : "r" (sel));
80106fd2:	0f b7 45 fc          	movzwl -0x4(%ebp),%eax
80106fd6:	0f 00 d8             	ltr    %ax
}
80106fd9:	90                   	nop
80106fda:	c9                   	leave  
80106fdb:	c3                   	ret    

80106fdc <lcr3>:

static inline void
lcr3(uint val)
{
80106fdc:	55                   	push   %ebp
80106fdd:	89 e5                	mov    %esp,%ebp
  asm volatile("movl %0,%%cr3" : : "r" (val));
80106fdf:	8b 45 08             	mov    0x8(%ebp),%eax
80106fe2:	0f 22 d8             	mov    %eax,%cr3
}
80106fe5:	90                   	nop
80106fe6:	5d                   	pop    %ebp
80106fe7:	c3                   	ret    

80106fe8 <seginit>:
extern struct gpu gpu;
// Set up CPU's kernel segment descriptors.
// Run once on entry on each CPU.
void
seginit(void)
{
80106fe8:	55                   	push   %ebp
80106fe9:	89 e5                	mov    %esp,%ebp
80106feb:	83 ec 18             	sub    $0x18,%esp

  // Map "logical" addresses to virtual addresses using identity map.
  // Cannot share a CODE descriptor for both kernel and user
  // because it would have to have DPL_USR, but the CPU forbids
  // an interrupt from CPL=0 to DPL=3.
  c = &cpus[cpuid()];
80106fee:	e8 90 cb ff ff       	call   80103b83 <cpuid>
80106ff3:	69 c0 b0 00 00 00    	imul   $0xb0,%eax,%eax
80106ff9:	05 80 69 19 80       	add    $0x80196980,%eax
80106ffe:	89 45 f4             	mov    %eax,-0xc(%ebp)

  c->gdt[SEG_KCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, 0);
80107001:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107004:	66 c7 40 78 ff ff    	movw   $0xffff,0x78(%eax)
8010700a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010700d:	66 c7 40 7a 00 00    	movw   $0x0,0x7a(%eax)
80107013:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107016:	c6 40 7c 00          	movb   $0x0,0x7c(%eax)
8010701a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010701d:	0f b6 50 7d          	movzbl 0x7d(%eax),%edx
80107021:	83 e2 f0             	and    $0xfffffff0,%edx
80107024:	83 ca 0a             	or     $0xa,%edx
80107027:	88 50 7d             	mov    %dl,0x7d(%eax)
8010702a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010702d:	0f b6 50 7d          	movzbl 0x7d(%eax),%edx
80107031:	83 ca 10             	or     $0x10,%edx
80107034:	88 50 7d             	mov    %dl,0x7d(%eax)
80107037:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010703a:	0f b6 50 7d          	movzbl 0x7d(%eax),%edx
8010703e:	83 e2 9f             	and    $0xffffff9f,%edx
80107041:	88 50 7d             	mov    %dl,0x7d(%eax)
80107044:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107047:	0f b6 50 7d          	movzbl 0x7d(%eax),%edx
8010704b:	83 ca 80             	or     $0xffffff80,%edx
8010704e:	88 50 7d             	mov    %dl,0x7d(%eax)
80107051:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107054:	0f b6 50 7e          	movzbl 0x7e(%eax),%edx
80107058:	83 ca 0f             	or     $0xf,%edx
8010705b:	88 50 7e             	mov    %dl,0x7e(%eax)
8010705e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107061:	0f b6 50 7e          	movzbl 0x7e(%eax),%edx
80107065:	83 e2 ef             	and    $0xffffffef,%edx
80107068:	88 50 7e             	mov    %dl,0x7e(%eax)
8010706b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010706e:	0f b6 50 7e          	movzbl 0x7e(%eax),%edx
80107072:	83 e2 df             	and    $0xffffffdf,%edx
80107075:	88 50 7e             	mov    %dl,0x7e(%eax)
80107078:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010707b:	0f b6 50 7e          	movzbl 0x7e(%eax),%edx
8010707f:	83 ca 40             	or     $0x40,%edx
80107082:	88 50 7e             	mov    %dl,0x7e(%eax)
80107085:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107088:	0f b6 50 7e          	movzbl 0x7e(%eax),%edx
8010708c:	83 ca 80             	or     $0xffffff80,%edx
8010708f:	88 50 7e             	mov    %dl,0x7e(%eax)
80107092:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107095:	c6 40 7f 00          	movb   $0x0,0x7f(%eax)
  c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
80107099:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010709c:	66 c7 80 80 00 00 00 	movw   $0xffff,0x80(%eax)
801070a3:	ff ff 
801070a5:	8b 45 f4             	mov    -0xc(%ebp),%eax
801070a8:	66 c7 80 82 00 00 00 	movw   $0x0,0x82(%eax)
801070af:	00 00 
801070b1:	8b 45 f4             	mov    -0xc(%ebp),%eax
801070b4:	c6 80 84 00 00 00 00 	movb   $0x0,0x84(%eax)
801070bb:	8b 45 f4             	mov    -0xc(%ebp),%eax
801070be:	0f b6 90 85 00 00 00 	movzbl 0x85(%eax),%edx
801070c5:	83 e2 f0             	and    $0xfffffff0,%edx
801070c8:	83 ca 02             	or     $0x2,%edx
801070cb:	88 90 85 00 00 00    	mov    %dl,0x85(%eax)
801070d1:	8b 45 f4             	mov    -0xc(%ebp),%eax
801070d4:	0f b6 90 85 00 00 00 	movzbl 0x85(%eax),%edx
801070db:	83 ca 10             	or     $0x10,%edx
801070de:	88 90 85 00 00 00    	mov    %dl,0x85(%eax)
801070e4:	8b 45 f4             	mov    -0xc(%ebp),%eax
801070e7:	0f b6 90 85 00 00 00 	movzbl 0x85(%eax),%edx
801070ee:	83 e2 9f             	and    $0xffffff9f,%edx
801070f1:	88 90 85 00 00 00    	mov    %dl,0x85(%eax)
801070f7:	8b 45 f4             	mov    -0xc(%ebp),%eax
801070fa:	0f b6 90 85 00 00 00 	movzbl 0x85(%eax),%edx
80107101:	83 ca 80             	or     $0xffffff80,%edx
80107104:	88 90 85 00 00 00    	mov    %dl,0x85(%eax)
8010710a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010710d:	0f b6 90 86 00 00 00 	movzbl 0x86(%eax),%edx
80107114:	83 ca 0f             	or     $0xf,%edx
80107117:	88 90 86 00 00 00    	mov    %dl,0x86(%eax)
8010711d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107120:	0f b6 90 86 00 00 00 	movzbl 0x86(%eax),%edx
80107127:	83 e2 ef             	and    $0xffffffef,%edx
8010712a:	88 90 86 00 00 00    	mov    %dl,0x86(%eax)
80107130:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107133:	0f b6 90 86 00 00 00 	movzbl 0x86(%eax),%edx
8010713a:	83 e2 df             	and    $0xffffffdf,%edx
8010713d:	88 90 86 00 00 00    	mov    %dl,0x86(%eax)
80107143:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107146:	0f b6 90 86 00 00 00 	movzbl 0x86(%eax),%edx
8010714d:	83 ca 40             	or     $0x40,%edx
80107150:	88 90 86 00 00 00    	mov    %dl,0x86(%eax)
80107156:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107159:	0f b6 90 86 00 00 00 	movzbl 0x86(%eax),%edx
80107160:	83 ca 80             	or     $0xffffff80,%edx
80107163:	88 90 86 00 00 00    	mov    %dl,0x86(%eax)
80107169:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010716c:	c6 80 87 00 00 00 00 	movb   $0x0,0x87(%eax)
  c->gdt[SEG_UCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, DPL_USER);
80107173:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107176:	66 c7 80 88 00 00 00 	movw   $0xffff,0x88(%eax)
8010717d:	ff ff 
8010717f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107182:	66 c7 80 8a 00 00 00 	movw   $0x0,0x8a(%eax)
80107189:	00 00 
8010718b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010718e:	c6 80 8c 00 00 00 00 	movb   $0x0,0x8c(%eax)
80107195:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107198:	0f b6 90 8d 00 00 00 	movzbl 0x8d(%eax),%edx
8010719f:	83 e2 f0             	and    $0xfffffff0,%edx
801071a2:	83 ca 0a             	or     $0xa,%edx
801071a5:	88 90 8d 00 00 00    	mov    %dl,0x8d(%eax)
801071ab:	8b 45 f4             	mov    -0xc(%ebp),%eax
801071ae:	0f b6 90 8d 00 00 00 	movzbl 0x8d(%eax),%edx
801071b5:	83 ca 10             	or     $0x10,%edx
801071b8:	88 90 8d 00 00 00    	mov    %dl,0x8d(%eax)
801071be:	8b 45 f4             	mov    -0xc(%ebp),%eax
801071c1:	0f b6 90 8d 00 00 00 	movzbl 0x8d(%eax),%edx
801071c8:	83 ca 60             	or     $0x60,%edx
801071cb:	88 90 8d 00 00 00    	mov    %dl,0x8d(%eax)
801071d1:	8b 45 f4             	mov    -0xc(%ebp),%eax
801071d4:	0f b6 90 8d 00 00 00 	movzbl 0x8d(%eax),%edx
801071db:	83 ca 80             	or     $0xffffff80,%edx
801071de:	88 90 8d 00 00 00    	mov    %dl,0x8d(%eax)
801071e4:	8b 45 f4             	mov    -0xc(%ebp),%eax
801071e7:	0f b6 90 8e 00 00 00 	movzbl 0x8e(%eax),%edx
801071ee:	83 ca 0f             	or     $0xf,%edx
801071f1:	88 90 8e 00 00 00    	mov    %dl,0x8e(%eax)
801071f7:	8b 45 f4             	mov    -0xc(%ebp),%eax
801071fa:	0f b6 90 8e 00 00 00 	movzbl 0x8e(%eax),%edx
80107201:	83 e2 ef             	and    $0xffffffef,%edx
80107204:	88 90 8e 00 00 00    	mov    %dl,0x8e(%eax)
8010720a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010720d:	0f b6 90 8e 00 00 00 	movzbl 0x8e(%eax),%edx
80107214:	83 e2 df             	and    $0xffffffdf,%edx
80107217:	88 90 8e 00 00 00    	mov    %dl,0x8e(%eax)
8010721d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107220:	0f b6 90 8e 00 00 00 	movzbl 0x8e(%eax),%edx
80107227:	83 ca 40             	or     $0x40,%edx
8010722a:	88 90 8e 00 00 00    	mov    %dl,0x8e(%eax)
80107230:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107233:	0f b6 90 8e 00 00 00 	movzbl 0x8e(%eax),%edx
8010723a:	83 ca 80             	or     $0xffffff80,%edx
8010723d:	88 90 8e 00 00 00    	mov    %dl,0x8e(%eax)
80107243:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107246:	c6 80 8f 00 00 00 00 	movb   $0x0,0x8f(%eax)
  c->gdt[SEG_UDATA] = SEG(STA_W, 0, 0xffffffff, DPL_USER);
8010724d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107250:	66 c7 80 90 00 00 00 	movw   $0xffff,0x90(%eax)
80107257:	ff ff 
80107259:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010725c:	66 c7 80 92 00 00 00 	movw   $0x0,0x92(%eax)
80107263:	00 00 
80107265:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107268:	c6 80 94 00 00 00 00 	movb   $0x0,0x94(%eax)
8010726f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107272:	0f b6 90 95 00 00 00 	movzbl 0x95(%eax),%edx
80107279:	83 e2 f0             	and    $0xfffffff0,%edx
8010727c:	83 ca 02             	or     $0x2,%edx
8010727f:	88 90 95 00 00 00    	mov    %dl,0x95(%eax)
80107285:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107288:	0f b6 90 95 00 00 00 	movzbl 0x95(%eax),%edx
8010728f:	83 ca 10             	or     $0x10,%edx
80107292:	88 90 95 00 00 00    	mov    %dl,0x95(%eax)
80107298:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010729b:	0f b6 90 95 00 00 00 	movzbl 0x95(%eax),%edx
801072a2:	83 ca 60             	or     $0x60,%edx
801072a5:	88 90 95 00 00 00    	mov    %dl,0x95(%eax)
801072ab:	8b 45 f4             	mov    -0xc(%ebp),%eax
801072ae:	0f b6 90 95 00 00 00 	movzbl 0x95(%eax),%edx
801072b5:	83 ca 80             	or     $0xffffff80,%edx
801072b8:	88 90 95 00 00 00    	mov    %dl,0x95(%eax)
801072be:	8b 45 f4             	mov    -0xc(%ebp),%eax
801072c1:	0f b6 90 96 00 00 00 	movzbl 0x96(%eax),%edx
801072c8:	83 ca 0f             	or     $0xf,%edx
801072cb:	88 90 96 00 00 00    	mov    %dl,0x96(%eax)
801072d1:	8b 45 f4             	mov    -0xc(%ebp),%eax
801072d4:	0f b6 90 96 00 00 00 	movzbl 0x96(%eax),%edx
801072db:	83 e2 ef             	and    $0xffffffef,%edx
801072de:	88 90 96 00 00 00    	mov    %dl,0x96(%eax)
801072e4:	8b 45 f4             	mov    -0xc(%ebp),%eax
801072e7:	0f b6 90 96 00 00 00 	movzbl 0x96(%eax),%edx
801072ee:	83 e2 df             	and    $0xffffffdf,%edx
801072f1:	88 90 96 00 00 00    	mov    %dl,0x96(%eax)
801072f7:	8b 45 f4             	mov    -0xc(%ebp),%eax
801072fa:	0f b6 90 96 00 00 00 	movzbl 0x96(%eax),%edx
80107301:	83 ca 40             	or     $0x40,%edx
80107304:	88 90 96 00 00 00    	mov    %dl,0x96(%eax)
8010730a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010730d:	0f b6 90 96 00 00 00 	movzbl 0x96(%eax),%edx
80107314:	83 ca 80             	or     $0xffffff80,%edx
80107317:	88 90 96 00 00 00    	mov    %dl,0x96(%eax)
8010731d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107320:	c6 80 97 00 00 00 00 	movb   $0x0,0x97(%eax)
  lgdt(c->gdt, sizeof(c->gdt));
80107327:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010732a:	83 c0 70             	add    $0x70,%eax
8010732d:	83 ec 08             	sub    $0x8,%esp
80107330:	6a 30                	push   $0x30
80107332:	50                   	push   %eax
80107333:	e8 63 fc ff ff       	call   80106f9b <lgdt>
80107338:	83 c4 10             	add    $0x10,%esp
}
8010733b:	90                   	nop
8010733c:	c9                   	leave  
8010733d:	c3                   	ret    

8010733e <walkpgdir>:
// Return the address of the PTE in page table pgdir
// that corresponds to virtual address va.  If alloc!=0,
// create any required page table pages.
static pte_t *
walkpgdir(pde_t *pgdir, const void *va, int alloc)
{
8010733e:	55                   	push   %ebp
8010733f:	89 e5                	mov    %esp,%ebp
80107341:	83 ec 18             	sub    $0x18,%esp
  pde_t *pde;
  pte_t *pgtab;

  pde = &pgdir[PDX(va)];
80107344:	8b 45 0c             	mov    0xc(%ebp),%eax
80107347:	c1 e8 16             	shr    $0x16,%eax
8010734a:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80107351:	8b 45 08             	mov    0x8(%ebp),%eax
80107354:	01 d0                	add    %edx,%eax
80107356:	89 45 f0             	mov    %eax,-0x10(%ebp)
  if(*pde & PTE_P){
80107359:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010735c:	8b 00                	mov    (%eax),%eax
8010735e:	83 e0 01             	and    $0x1,%eax
80107361:	85 c0                	test   %eax,%eax
80107363:	74 14                	je     80107379 <walkpgdir+0x3b>
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
80107365:	8b 45 f0             	mov    -0x10(%ebp),%eax
80107368:	8b 00                	mov    (%eax),%eax
8010736a:	25 00 f0 ff ff       	and    $0xfffff000,%eax
8010736f:	05 00 00 00 80       	add    $0x80000000,%eax
80107374:	89 45 f4             	mov    %eax,-0xc(%ebp)
80107377:	eb 42                	jmp    801073bb <walkpgdir+0x7d>
  } else {
    if(!alloc || (pgtab = (pte_t*)kalloc()) == 0)
80107379:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
8010737d:	74 0e                	je     8010738d <walkpgdir+0x4f>
8010737f:	e8 1c b4 ff ff       	call   801027a0 <kalloc>
80107384:	89 45 f4             	mov    %eax,-0xc(%ebp)
80107387:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
8010738b:	75 07                	jne    80107394 <walkpgdir+0x56>
      return 0;
8010738d:	b8 00 00 00 00       	mov    $0x0,%eax
80107392:	eb 3e                	jmp    801073d2 <walkpgdir+0x94>
    // Make sure all those PTE_P bits are zero.
    memset(pgtab, 0, PGSIZE);
80107394:	83 ec 04             	sub    $0x4,%esp
80107397:	68 00 10 00 00       	push   $0x1000
8010739c:	6a 00                	push   $0x0
8010739e:	ff 75 f4             	push   -0xc(%ebp)
801073a1:	e8 aa d7 ff ff       	call   80104b50 <memset>
801073a6:	83 c4 10             	add    $0x10,%esp
    // The permissions here are overly generous, but they can
    // be further restricted by the permissions in the page table
    // entries, if necessary.
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
801073a9:	8b 45 f4             	mov    -0xc(%ebp),%eax
801073ac:	05 00 00 00 80       	add    $0x80000000,%eax
801073b1:	83 c8 07             	or     $0x7,%eax
801073b4:	89 c2                	mov    %eax,%edx
801073b6:	8b 45 f0             	mov    -0x10(%ebp),%eax
801073b9:	89 10                	mov    %edx,(%eax)
  }
  return &pgtab[PTX(va)];
801073bb:	8b 45 0c             	mov    0xc(%ebp),%eax
801073be:	c1 e8 0c             	shr    $0xc,%eax
801073c1:	25 ff 03 00 00       	and    $0x3ff,%eax
801073c6:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
801073cd:	8b 45 f4             	mov    -0xc(%ebp),%eax
801073d0:	01 d0                	add    %edx,%eax
}
801073d2:	c9                   	leave  
801073d3:	c3                   	ret    

801073d4 <mappages>:
// Create PTEs for virtual addresses starting at va that refer to
// physical addresses starting at pa. va and size might not
// be page-aligned.
static int
mappages(pde_t *pgdir, void *va, uint size, uint pa, int perm)
{
801073d4:	55                   	push   %ebp
801073d5:	89 e5                	mov    %esp,%ebp
801073d7:	83 ec 18             	sub    $0x18,%esp
  char *a, *last;
  pte_t *pte;

  a = (char*)PGROUNDDOWN((uint)va);
801073da:	8b 45 0c             	mov    0xc(%ebp),%eax
801073dd:	25 00 f0 ff ff       	and    $0xfffff000,%eax
801073e2:	89 45 f4             	mov    %eax,-0xc(%ebp)
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
801073e5:	8b 55 0c             	mov    0xc(%ebp),%edx
801073e8:	8b 45 10             	mov    0x10(%ebp),%eax
801073eb:	01 d0                	add    %edx,%eax
801073ed:	83 e8 01             	sub    $0x1,%eax
801073f0:	25 00 f0 ff ff       	and    $0xfffff000,%eax
801073f5:	89 45 f0             	mov    %eax,-0x10(%ebp)
  for(;;){
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
801073f8:	83 ec 04             	sub    $0x4,%esp
801073fb:	6a 01                	push   $0x1
801073fd:	ff 75 f4             	push   -0xc(%ebp)
80107400:	ff 75 08             	push   0x8(%ebp)
80107403:	e8 36 ff ff ff       	call   8010733e <walkpgdir>
80107408:	83 c4 10             	add    $0x10,%esp
8010740b:	89 45 ec             	mov    %eax,-0x14(%ebp)
8010740e:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
80107412:	75 07                	jne    8010741b <mappages+0x47>
      return -1;
80107414:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80107419:	eb 47                	jmp    80107462 <mappages+0x8e>
    if(*pte & PTE_P)
8010741b:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010741e:	8b 00                	mov    (%eax),%eax
80107420:	83 e0 01             	and    $0x1,%eax
80107423:	85 c0                	test   %eax,%eax
80107425:	74 0d                	je     80107434 <mappages+0x60>
      panic("remap");
80107427:	83 ec 0c             	sub    $0xc,%esp
8010742a:	68 48 a7 10 80       	push   $0x8010a748
8010742f:	e8 75 91 ff ff       	call   801005a9 <panic>
    *pte = pa | perm | PTE_P;
80107434:	8b 45 18             	mov    0x18(%ebp),%eax
80107437:	0b 45 14             	or     0x14(%ebp),%eax
8010743a:	83 c8 01             	or     $0x1,%eax
8010743d:	89 c2                	mov    %eax,%edx
8010743f:	8b 45 ec             	mov    -0x14(%ebp),%eax
80107442:	89 10                	mov    %edx,(%eax)
    if(a == last)
80107444:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107447:	3b 45 f0             	cmp    -0x10(%ebp),%eax
8010744a:	74 10                	je     8010745c <mappages+0x88>
      break;
    a += PGSIZE;
8010744c:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
    pa += PGSIZE;
80107453:	81 45 14 00 10 00 00 	addl   $0x1000,0x14(%ebp)
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
8010745a:	eb 9c                	jmp    801073f8 <mappages+0x24>
      break;
8010745c:	90                   	nop
  }
  return 0;
8010745d:	b8 00 00 00 00       	mov    $0x0,%eax
}
80107462:	c9                   	leave  
80107463:	c3                   	ret    

80107464 <setupkvm>:
};

// Set up kernel part of a page table.
pde_t*
setupkvm(void)
{
80107464:	55                   	push   %ebp
80107465:	89 e5                	mov    %esp,%ebp
80107467:	53                   	push   %ebx
80107468:	83 ec 24             	sub    $0x24,%esp
  pde_t *pgdir;
  struct kmap *k;
  k = kmap;
8010746b:	c7 45 f4 80 f4 10 80 	movl   $0x8010f480,-0xc(%ebp)
  struct kmap vram = { (void*)(DEVSPACE - gpu.vram_size),gpu.pvram_addr,gpu.pvram_addr+gpu.vram_size, PTE_W};
80107472:	8b 15 50 6c 19 80    	mov    0x80196c50,%edx
80107478:	b8 00 00 00 fe       	mov    $0xfe000000,%eax
8010747d:	29 d0                	sub    %edx,%eax
8010747f:	89 45 e0             	mov    %eax,-0x20(%ebp)
80107482:	a1 48 6c 19 80       	mov    0x80196c48,%eax
80107487:	89 45 e4             	mov    %eax,-0x1c(%ebp)
8010748a:	8b 15 48 6c 19 80    	mov    0x80196c48,%edx
80107490:	a1 50 6c 19 80       	mov    0x80196c50,%eax
80107495:	01 d0                	add    %edx,%eax
80107497:	89 45 e8             	mov    %eax,-0x18(%ebp)
8010749a:	c7 45 ec 02 00 00 00 	movl   $0x2,-0x14(%ebp)
  k[3] = vram;
801074a1:	8b 45 f4             	mov    -0xc(%ebp),%eax
801074a4:	83 c0 30             	add    $0x30,%eax
801074a7:	8b 55 e0             	mov    -0x20(%ebp),%edx
801074aa:	89 10                	mov    %edx,(%eax)
801074ac:	8b 55 e4             	mov    -0x1c(%ebp),%edx
801074af:	89 50 04             	mov    %edx,0x4(%eax)
801074b2:	8b 55 e8             	mov    -0x18(%ebp),%edx
801074b5:	89 50 08             	mov    %edx,0x8(%eax)
801074b8:	8b 55 ec             	mov    -0x14(%ebp),%edx
801074bb:	89 50 0c             	mov    %edx,0xc(%eax)
  if((pgdir = (pde_t*)kalloc()) == 0){
801074be:	e8 dd b2 ff ff       	call   801027a0 <kalloc>
801074c3:	89 45 f0             	mov    %eax,-0x10(%ebp)
801074c6:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
801074ca:	75 07                	jne    801074d3 <setupkvm+0x6f>
    return 0;
801074cc:	b8 00 00 00 00       	mov    $0x0,%eax
801074d1:	eb 78                	jmp    8010754b <setupkvm+0xe7>
  }
  memset(pgdir, 0, PGSIZE);
801074d3:	83 ec 04             	sub    $0x4,%esp
801074d6:	68 00 10 00 00       	push   $0x1000
801074db:	6a 00                	push   $0x0
801074dd:	ff 75 f0             	push   -0x10(%ebp)
801074e0:	e8 6b d6 ff ff       	call   80104b50 <memset>
801074e5:	83 c4 10             	add    $0x10,%esp
  if (P2V(PHYSTOP) > (void*)DEVSPACE)
    panic("PHYSTOP too high");
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
801074e8:	c7 45 f4 80 f4 10 80 	movl   $0x8010f480,-0xc(%ebp)
801074ef:	eb 4e                	jmp    8010753f <setupkvm+0xdb>
    if(mappages(pgdir, k->virt, k->phys_end - k->phys_start,
801074f1:	8b 45 f4             	mov    -0xc(%ebp),%eax
801074f4:	8b 48 0c             	mov    0xc(%eax),%ecx
                (uint)k->phys_start, k->perm) < 0) {
801074f7:	8b 45 f4             	mov    -0xc(%ebp),%eax
801074fa:	8b 50 04             	mov    0x4(%eax),%edx
    if(mappages(pgdir, k->virt, k->phys_end - k->phys_start,
801074fd:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107500:	8b 58 08             	mov    0x8(%eax),%ebx
80107503:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107506:	8b 40 04             	mov    0x4(%eax),%eax
80107509:	29 c3                	sub    %eax,%ebx
8010750b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010750e:	8b 00                	mov    (%eax),%eax
80107510:	83 ec 0c             	sub    $0xc,%esp
80107513:	51                   	push   %ecx
80107514:	52                   	push   %edx
80107515:	53                   	push   %ebx
80107516:	50                   	push   %eax
80107517:	ff 75 f0             	push   -0x10(%ebp)
8010751a:	e8 b5 fe ff ff       	call   801073d4 <mappages>
8010751f:	83 c4 20             	add    $0x20,%esp
80107522:	85 c0                	test   %eax,%eax
80107524:	79 15                	jns    8010753b <setupkvm+0xd7>
      freevm(pgdir);
80107526:	83 ec 0c             	sub    $0xc,%esp
80107529:	ff 75 f0             	push   -0x10(%ebp)
8010752c:	e8 f5 04 00 00       	call   80107a26 <freevm>
80107531:	83 c4 10             	add    $0x10,%esp
      return 0;
80107534:	b8 00 00 00 00       	mov    $0x0,%eax
80107539:	eb 10                	jmp    8010754b <setupkvm+0xe7>
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
8010753b:	83 45 f4 10          	addl   $0x10,-0xc(%ebp)
8010753f:	81 7d f4 e0 f4 10 80 	cmpl   $0x8010f4e0,-0xc(%ebp)
80107546:	72 a9                	jb     801074f1 <setupkvm+0x8d>
    }
  return pgdir;
80107548:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
8010754b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010754e:	c9                   	leave  
8010754f:	c3                   	ret    

80107550 <kvmalloc>:

// Allocate one page table for the machine for the kernel address
// space for scheduler processes.
void
kvmalloc(void)
{
80107550:	55                   	push   %ebp
80107551:	89 e5                	mov    %esp,%ebp
80107553:	83 ec 08             	sub    $0x8,%esp
  kpgdir = setupkvm();
80107556:	e8 09 ff ff ff       	call   80107464 <setupkvm>
8010755b:	a3 7c 69 19 80       	mov    %eax,0x8019697c
  switchkvm();
80107560:	e8 03 00 00 00       	call   80107568 <switchkvm>
}
80107565:	90                   	nop
80107566:	c9                   	leave  
80107567:	c3                   	ret    

80107568 <switchkvm>:

// Switch h/w page table register to the kernel-only page table,
// for when no process is running.
void
switchkvm(void)
{
80107568:	55                   	push   %ebp
80107569:	89 e5                	mov    %esp,%ebp
  lcr3(V2P(kpgdir));   // switch to the kernel page table
8010756b:	a1 7c 69 19 80       	mov    0x8019697c,%eax
80107570:	05 00 00 00 80       	add    $0x80000000,%eax
80107575:	50                   	push   %eax
80107576:	e8 61 fa ff ff       	call   80106fdc <lcr3>
8010757b:	83 c4 04             	add    $0x4,%esp
}
8010757e:	90                   	nop
8010757f:	c9                   	leave  
80107580:	c3                   	ret    

80107581 <switchuvm>:

// Switch TSS and h/w page table to correspond to process p.
void
switchuvm(struct proc *p)
{
80107581:	55                   	push   %ebp
80107582:	89 e5                	mov    %esp,%ebp
80107584:	56                   	push   %esi
80107585:	53                   	push   %ebx
80107586:	83 ec 10             	sub    $0x10,%esp
  if(p == 0)
80107589:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
8010758d:	75 0d                	jne    8010759c <switchuvm+0x1b>
    panic("switchuvm: no process");
8010758f:	83 ec 0c             	sub    $0xc,%esp
80107592:	68 4e a7 10 80       	push   $0x8010a74e
80107597:	e8 0d 90 ff ff       	call   801005a9 <panic>
  if(p->kstack == 0)
8010759c:	8b 45 08             	mov    0x8(%ebp),%eax
8010759f:	8b 40 08             	mov    0x8(%eax),%eax
801075a2:	85 c0                	test   %eax,%eax
801075a4:	75 0d                	jne    801075b3 <switchuvm+0x32>
    panic("switchuvm: no kstack");
801075a6:	83 ec 0c             	sub    $0xc,%esp
801075a9:	68 64 a7 10 80       	push   $0x8010a764
801075ae:	e8 f6 8f ff ff       	call   801005a9 <panic>
  if(p->pgdir == 0)
801075b3:	8b 45 08             	mov    0x8(%ebp),%eax
801075b6:	8b 40 04             	mov    0x4(%eax),%eax
801075b9:	85 c0                	test   %eax,%eax
801075bb:	75 0d                	jne    801075ca <switchuvm+0x49>
    panic("switchuvm: no pgdir");
801075bd:	83 ec 0c             	sub    $0xc,%esp
801075c0:	68 79 a7 10 80       	push   $0x8010a779
801075c5:	e8 df 8f ff ff       	call   801005a9 <panic>

  pushcli();
801075ca:	e8 76 d4 ff ff       	call   80104a45 <pushcli>
  mycpu()->gdt[SEG_TSS] = SEG16(STS_T32A, &mycpu()->ts,
801075cf:	e8 ca c5 ff ff       	call   80103b9e <mycpu>
801075d4:	89 c3                	mov    %eax,%ebx
801075d6:	e8 c3 c5 ff ff       	call   80103b9e <mycpu>
801075db:	83 c0 08             	add    $0x8,%eax
801075de:	89 c6                	mov    %eax,%esi
801075e0:	e8 b9 c5 ff ff       	call   80103b9e <mycpu>
801075e5:	83 c0 08             	add    $0x8,%eax
801075e8:	c1 e8 10             	shr    $0x10,%eax
801075eb:	88 45 f7             	mov    %al,-0x9(%ebp)
801075ee:	e8 ab c5 ff ff       	call   80103b9e <mycpu>
801075f3:	83 c0 08             	add    $0x8,%eax
801075f6:	c1 e8 18             	shr    $0x18,%eax
801075f9:	89 c2                	mov    %eax,%edx
801075fb:	66 c7 83 98 00 00 00 	movw   $0x67,0x98(%ebx)
80107602:	67 00 
80107604:	66 89 b3 9a 00 00 00 	mov    %si,0x9a(%ebx)
8010760b:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
8010760f:	88 83 9c 00 00 00    	mov    %al,0x9c(%ebx)
80107615:	0f b6 83 9d 00 00 00 	movzbl 0x9d(%ebx),%eax
8010761c:	83 e0 f0             	and    $0xfffffff0,%eax
8010761f:	83 c8 09             	or     $0x9,%eax
80107622:	88 83 9d 00 00 00    	mov    %al,0x9d(%ebx)
80107628:	0f b6 83 9d 00 00 00 	movzbl 0x9d(%ebx),%eax
8010762f:	83 c8 10             	or     $0x10,%eax
80107632:	88 83 9d 00 00 00    	mov    %al,0x9d(%ebx)
80107638:	0f b6 83 9d 00 00 00 	movzbl 0x9d(%ebx),%eax
8010763f:	83 e0 9f             	and    $0xffffff9f,%eax
80107642:	88 83 9d 00 00 00    	mov    %al,0x9d(%ebx)
80107648:	0f b6 83 9d 00 00 00 	movzbl 0x9d(%ebx),%eax
8010764f:	83 c8 80             	or     $0xffffff80,%eax
80107652:	88 83 9d 00 00 00    	mov    %al,0x9d(%ebx)
80107658:	0f b6 83 9e 00 00 00 	movzbl 0x9e(%ebx),%eax
8010765f:	83 e0 f0             	and    $0xfffffff0,%eax
80107662:	88 83 9e 00 00 00    	mov    %al,0x9e(%ebx)
80107668:	0f b6 83 9e 00 00 00 	movzbl 0x9e(%ebx),%eax
8010766f:	83 e0 ef             	and    $0xffffffef,%eax
80107672:	88 83 9e 00 00 00    	mov    %al,0x9e(%ebx)
80107678:	0f b6 83 9e 00 00 00 	movzbl 0x9e(%ebx),%eax
8010767f:	83 e0 df             	and    $0xffffffdf,%eax
80107682:	88 83 9e 00 00 00    	mov    %al,0x9e(%ebx)
80107688:	0f b6 83 9e 00 00 00 	movzbl 0x9e(%ebx),%eax
8010768f:	83 c8 40             	or     $0x40,%eax
80107692:	88 83 9e 00 00 00    	mov    %al,0x9e(%ebx)
80107698:	0f b6 83 9e 00 00 00 	movzbl 0x9e(%ebx),%eax
8010769f:	83 e0 7f             	and    $0x7f,%eax
801076a2:	88 83 9e 00 00 00    	mov    %al,0x9e(%ebx)
801076a8:	88 93 9f 00 00 00    	mov    %dl,0x9f(%ebx)
                                sizeof(mycpu()->ts)-1, 0);
  mycpu()->gdt[SEG_TSS].s = 0;
801076ae:	e8 eb c4 ff ff       	call   80103b9e <mycpu>
801076b3:	0f b6 90 9d 00 00 00 	movzbl 0x9d(%eax),%edx
801076ba:	83 e2 ef             	and    $0xffffffef,%edx
801076bd:	88 90 9d 00 00 00    	mov    %dl,0x9d(%eax)
  mycpu()->ts.ss0 = SEG_KDATA << 3;
801076c3:	e8 d6 c4 ff ff       	call   80103b9e <mycpu>
801076c8:	66 c7 40 10 10 00    	movw   $0x10,0x10(%eax)
  mycpu()->ts.esp0 = (uint)p->kstack + KSTACKSIZE;
801076ce:	8b 45 08             	mov    0x8(%ebp),%eax
801076d1:	8b 40 08             	mov    0x8(%eax),%eax
801076d4:	89 c3                	mov    %eax,%ebx
801076d6:	e8 c3 c4 ff ff       	call   80103b9e <mycpu>
801076db:	8d 93 00 10 00 00    	lea    0x1000(%ebx),%edx
801076e1:	89 50 0c             	mov    %edx,0xc(%eax)
  // setting IOPL=0 in eflags *and* iomb beyond the tss segment limit
  // forbids I/O instructions (e.g., inb and outb) from user space
  mycpu()->ts.iomb = (ushort) 0xFFFF;
801076e4:	e8 b5 c4 ff ff       	call   80103b9e <mycpu>
801076e9:	66 c7 40 6e ff ff    	movw   $0xffff,0x6e(%eax)
  ltr(SEG_TSS << 3);
801076ef:	83 ec 0c             	sub    $0xc,%esp
801076f2:	6a 28                	push   $0x28
801076f4:	e8 cc f8 ff ff       	call   80106fc5 <ltr>
801076f9:	83 c4 10             	add    $0x10,%esp
  lcr3(V2P(p->pgdir));  // switch to process's address space
801076fc:	8b 45 08             	mov    0x8(%ebp),%eax
801076ff:	8b 40 04             	mov    0x4(%eax),%eax
80107702:	05 00 00 00 80       	add    $0x80000000,%eax
80107707:	83 ec 0c             	sub    $0xc,%esp
8010770a:	50                   	push   %eax
8010770b:	e8 cc f8 ff ff       	call   80106fdc <lcr3>
80107710:	83 c4 10             	add    $0x10,%esp
  popcli();
80107713:	e8 7a d3 ff ff       	call   80104a92 <popcli>
}
80107718:	90                   	nop
80107719:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010771c:	5b                   	pop    %ebx
8010771d:	5e                   	pop    %esi
8010771e:	5d                   	pop    %ebp
8010771f:	c3                   	ret    

80107720 <inituvm>:

// Load the initcode into address 0 of pgdir.
// sz must be less than a page.
void
inituvm(pde_t *pgdir, char *init, uint sz)
{
80107720:	55                   	push   %ebp
80107721:	89 e5                	mov    %esp,%ebp
80107723:	83 ec 18             	sub    $0x18,%esp
  char *mem;

  if(sz >= PGSIZE)
80107726:	81 7d 10 ff 0f 00 00 	cmpl   $0xfff,0x10(%ebp)
8010772d:	76 0d                	jbe    8010773c <inituvm+0x1c>
    panic("inituvm: more than a page");
8010772f:	83 ec 0c             	sub    $0xc,%esp
80107732:	68 8d a7 10 80       	push   $0x8010a78d
80107737:	e8 6d 8e ff ff       	call   801005a9 <panic>
  mem = kalloc();
8010773c:	e8 5f b0 ff ff       	call   801027a0 <kalloc>
80107741:	89 45 f4             	mov    %eax,-0xc(%ebp)
  memset(mem, 0, PGSIZE);
80107744:	83 ec 04             	sub    $0x4,%esp
80107747:	68 00 10 00 00       	push   $0x1000
8010774c:	6a 00                	push   $0x0
8010774e:	ff 75 f4             	push   -0xc(%ebp)
80107751:	e8 fa d3 ff ff       	call   80104b50 <memset>
80107756:	83 c4 10             	add    $0x10,%esp
  mappages(pgdir, 0, PGSIZE, V2P(mem), PTE_W|PTE_U);
80107759:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010775c:	05 00 00 00 80       	add    $0x80000000,%eax
80107761:	83 ec 0c             	sub    $0xc,%esp
80107764:	6a 06                	push   $0x6
80107766:	50                   	push   %eax
80107767:	68 00 10 00 00       	push   $0x1000
8010776c:	6a 00                	push   $0x0
8010776e:	ff 75 08             	push   0x8(%ebp)
80107771:	e8 5e fc ff ff       	call   801073d4 <mappages>
80107776:	83 c4 20             	add    $0x20,%esp
  memmove(mem, init, sz);
80107779:	83 ec 04             	sub    $0x4,%esp
8010777c:	ff 75 10             	push   0x10(%ebp)
8010777f:	ff 75 0c             	push   0xc(%ebp)
80107782:	ff 75 f4             	push   -0xc(%ebp)
80107785:	e8 85 d4 ff ff       	call   80104c0f <memmove>
8010778a:	83 c4 10             	add    $0x10,%esp
}
8010778d:	90                   	nop
8010778e:	c9                   	leave  
8010778f:	c3                   	ret    

80107790 <loaduvm>:

// Load a program segment into pgdir.  addr must be page-aligned
// and the pages from addr to addr+sz must already be mapped.
int
loaduvm(pde_t *pgdir, char *addr, struct inode *ip, uint offset, uint sz)
{
80107790:	55                   	push   %ebp
80107791:	89 e5                	mov    %esp,%ebp
80107793:	83 ec 18             	sub    $0x18,%esp
  uint i, pa, n;
  pte_t *pte;

  if((uint) addr % PGSIZE != 0)
80107796:	8b 45 0c             	mov    0xc(%ebp),%eax
80107799:	25 ff 0f 00 00       	and    $0xfff,%eax
8010779e:	85 c0                	test   %eax,%eax
801077a0:	74 0d                	je     801077af <loaduvm+0x1f>
    panic("loaduvm: addr must be page aligned");
801077a2:	83 ec 0c             	sub    $0xc,%esp
801077a5:	68 a8 a7 10 80       	push   $0x8010a7a8
801077aa:	e8 fa 8d ff ff       	call   801005a9 <panic>
  for(i = 0; i < sz; i += PGSIZE){
801077af:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
801077b6:	e9 8f 00 00 00       	jmp    8010784a <loaduvm+0xba>
    if((pte = walkpgdir(pgdir, addr+i, 0)) == 0)
801077bb:	8b 55 0c             	mov    0xc(%ebp),%edx
801077be:	8b 45 f4             	mov    -0xc(%ebp),%eax
801077c1:	01 d0                	add    %edx,%eax
801077c3:	83 ec 04             	sub    $0x4,%esp
801077c6:	6a 00                	push   $0x0
801077c8:	50                   	push   %eax
801077c9:	ff 75 08             	push   0x8(%ebp)
801077cc:	e8 6d fb ff ff       	call   8010733e <walkpgdir>
801077d1:	83 c4 10             	add    $0x10,%esp
801077d4:	89 45 ec             	mov    %eax,-0x14(%ebp)
801077d7:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
801077db:	75 0d                	jne    801077ea <loaduvm+0x5a>
      panic("loaduvm: address should exist");
801077dd:	83 ec 0c             	sub    $0xc,%esp
801077e0:	68 cb a7 10 80       	push   $0x8010a7cb
801077e5:	e8 bf 8d ff ff       	call   801005a9 <panic>
    pa = PTE_ADDR(*pte);
801077ea:	8b 45 ec             	mov    -0x14(%ebp),%eax
801077ed:	8b 00                	mov    (%eax),%eax
801077ef:	25 00 f0 ff ff       	and    $0xfffff000,%eax
801077f4:	89 45 e8             	mov    %eax,-0x18(%ebp)
    if(sz - i < PGSIZE)
801077f7:	8b 45 18             	mov    0x18(%ebp),%eax
801077fa:	2b 45 f4             	sub    -0xc(%ebp),%eax
801077fd:	3d ff 0f 00 00       	cmp    $0xfff,%eax
80107802:	77 0b                	ja     8010780f <loaduvm+0x7f>
      n = sz - i;
80107804:	8b 45 18             	mov    0x18(%ebp),%eax
80107807:	2b 45 f4             	sub    -0xc(%ebp),%eax
8010780a:	89 45 f0             	mov    %eax,-0x10(%ebp)
8010780d:	eb 07                	jmp    80107816 <loaduvm+0x86>
    else
      n = PGSIZE;
8010780f:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
    if(readi(ip, P2V(pa), offset+i, n) != n)
80107816:	8b 55 14             	mov    0x14(%ebp),%edx
80107819:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010781c:	01 d0                	add    %edx,%eax
8010781e:	8b 55 e8             	mov    -0x18(%ebp),%edx
80107821:	81 c2 00 00 00 80    	add    $0x80000000,%edx
80107827:	ff 75 f0             	push   -0x10(%ebp)
8010782a:	50                   	push   %eax
8010782b:	52                   	push   %edx
8010782c:	ff 75 10             	push   0x10(%ebp)
8010782f:	e8 a2 a6 ff ff       	call   80101ed6 <readi>
80107834:	83 c4 10             	add    $0x10,%esp
80107837:	39 45 f0             	cmp    %eax,-0x10(%ebp)
8010783a:	74 07                	je     80107843 <loaduvm+0xb3>
      return -1;
8010783c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80107841:	eb 18                	jmp    8010785b <loaduvm+0xcb>
  for(i = 0; i < sz; i += PGSIZE){
80107843:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
8010784a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010784d:	3b 45 18             	cmp    0x18(%ebp),%eax
80107850:	0f 82 65 ff ff ff    	jb     801077bb <loaduvm+0x2b>
  }
  return 0;
80107856:	b8 00 00 00 00       	mov    $0x0,%eax
}
8010785b:	c9                   	leave  
8010785c:	c3                   	ret    

8010785d <allocuvm>:

// Allocate page tables and physical memory to grow process from oldsz to
// newsz, which need not be page aligned.  Returns new size or 0 on error.
int
allocuvm(pde_t *pgdir, uint oldsz, uint newsz)
{
8010785d:	55                   	push   %ebp
8010785e:	89 e5                	mov    %esp,%ebp
80107860:	83 ec 18             	sub    $0x18,%esp
  char *mem;
  uint a;

  if(newsz >= KERNBASE)
80107863:	8b 45 10             	mov    0x10(%ebp),%eax
80107866:	85 c0                	test   %eax,%eax
80107868:	79 0a                	jns    80107874 <allocuvm+0x17>
    return 0;
8010786a:	b8 00 00 00 00       	mov    $0x0,%eax
8010786f:	e9 ec 00 00 00       	jmp    80107960 <allocuvm+0x103>
  if(newsz < oldsz)
80107874:	8b 45 10             	mov    0x10(%ebp),%eax
80107877:	3b 45 0c             	cmp    0xc(%ebp),%eax
8010787a:	73 08                	jae    80107884 <allocuvm+0x27>
    return oldsz;
8010787c:	8b 45 0c             	mov    0xc(%ebp),%eax
8010787f:	e9 dc 00 00 00       	jmp    80107960 <allocuvm+0x103>

  a = PGROUNDUP(oldsz);
80107884:	8b 45 0c             	mov    0xc(%ebp),%eax
80107887:	05 ff 0f 00 00       	add    $0xfff,%eax
8010788c:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80107891:	89 45 f4             	mov    %eax,-0xc(%ebp)
  for(; a < newsz; a += PGSIZE){
80107894:	e9 b8 00 00 00       	jmp    80107951 <allocuvm+0xf4>
    mem = kalloc();
80107899:	e8 02 af ff ff       	call   801027a0 <kalloc>
8010789e:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(mem == 0){
801078a1:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
801078a5:	75 2e                	jne    801078d5 <allocuvm+0x78>
      cprintf("allocuvm out of memory\n");
801078a7:	83 ec 0c             	sub    $0xc,%esp
801078aa:	68 e9 a7 10 80       	push   $0x8010a7e9
801078af:	e8 40 8b ff ff       	call   801003f4 <cprintf>
801078b4:	83 c4 10             	add    $0x10,%esp
      deallocuvm(pgdir, newsz, oldsz);
801078b7:	83 ec 04             	sub    $0x4,%esp
801078ba:	ff 75 0c             	push   0xc(%ebp)
801078bd:	ff 75 10             	push   0x10(%ebp)
801078c0:	ff 75 08             	push   0x8(%ebp)
801078c3:	e8 9a 00 00 00       	call   80107962 <deallocuvm>
801078c8:	83 c4 10             	add    $0x10,%esp
      return 0;
801078cb:	b8 00 00 00 00       	mov    $0x0,%eax
801078d0:	e9 8b 00 00 00       	jmp    80107960 <allocuvm+0x103>
    }
    memset(mem, 0, PGSIZE);
801078d5:	83 ec 04             	sub    $0x4,%esp
801078d8:	68 00 10 00 00       	push   $0x1000
801078dd:	6a 00                	push   $0x0
801078df:	ff 75 f0             	push   -0x10(%ebp)
801078e2:	e8 69 d2 ff ff       	call   80104b50 <memset>
801078e7:	83 c4 10             	add    $0x10,%esp
    if(mappages(pgdir, (char*)a, PGSIZE, V2P(mem), PTE_W|PTE_U) < 0){
801078ea:	8b 45 f0             	mov    -0x10(%ebp),%eax
801078ed:	8d 90 00 00 00 80    	lea    -0x80000000(%eax),%edx
801078f3:	8b 45 f4             	mov    -0xc(%ebp),%eax
801078f6:	83 ec 0c             	sub    $0xc,%esp
801078f9:	6a 06                	push   $0x6
801078fb:	52                   	push   %edx
801078fc:	68 00 10 00 00       	push   $0x1000
80107901:	50                   	push   %eax
80107902:	ff 75 08             	push   0x8(%ebp)
80107905:	e8 ca fa ff ff       	call   801073d4 <mappages>
8010790a:	83 c4 20             	add    $0x20,%esp
8010790d:	85 c0                	test   %eax,%eax
8010790f:	79 39                	jns    8010794a <allocuvm+0xed>
      cprintf("allocuvm out of memory (2)\n");
80107911:	83 ec 0c             	sub    $0xc,%esp
80107914:	68 01 a8 10 80       	push   $0x8010a801
80107919:	e8 d6 8a ff ff       	call   801003f4 <cprintf>
8010791e:	83 c4 10             	add    $0x10,%esp
      deallocuvm(pgdir, newsz, oldsz);
80107921:	83 ec 04             	sub    $0x4,%esp
80107924:	ff 75 0c             	push   0xc(%ebp)
80107927:	ff 75 10             	push   0x10(%ebp)
8010792a:	ff 75 08             	push   0x8(%ebp)
8010792d:	e8 30 00 00 00       	call   80107962 <deallocuvm>
80107932:	83 c4 10             	add    $0x10,%esp
      kfree(mem);
80107935:	83 ec 0c             	sub    $0xc,%esp
80107938:	ff 75 f0             	push   -0x10(%ebp)
8010793b:	e8 c6 ad ff ff       	call   80102706 <kfree>
80107940:	83 c4 10             	add    $0x10,%esp
      return 0;
80107943:	b8 00 00 00 00       	mov    $0x0,%eax
80107948:	eb 16                	jmp    80107960 <allocuvm+0x103>
  for(; a < newsz; a += PGSIZE){
8010794a:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
80107951:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107954:	3b 45 10             	cmp    0x10(%ebp),%eax
80107957:	0f 82 3c ff ff ff    	jb     80107899 <allocuvm+0x3c>
    }
  }
  return newsz;
8010795d:	8b 45 10             	mov    0x10(%ebp),%eax
}
80107960:	c9                   	leave  
80107961:	c3                   	ret    

80107962 <deallocuvm>:
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
int
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
{
80107962:	55                   	push   %ebp
80107963:	89 e5                	mov    %esp,%ebp
80107965:	83 ec 18             	sub    $0x18,%esp
  pte_t *pte;
  uint a, pa;

  if(newsz >= oldsz)
80107968:	8b 45 10             	mov    0x10(%ebp),%eax
8010796b:	3b 45 0c             	cmp    0xc(%ebp),%eax
8010796e:	72 08                	jb     80107978 <deallocuvm+0x16>
    return oldsz;
80107970:	8b 45 0c             	mov    0xc(%ebp),%eax
80107973:	e9 ac 00 00 00       	jmp    80107a24 <deallocuvm+0xc2>

  a = PGROUNDUP(newsz);
80107978:	8b 45 10             	mov    0x10(%ebp),%eax
8010797b:	05 ff 0f 00 00       	add    $0xfff,%eax
80107980:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80107985:	89 45 f4             	mov    %eax,-0xc(%ebp)
  for(; a  < oldsz; a += PGSIZE){
80107988:	e9 88 00 00 00       	jmp    80107a15 <deallocuvm+0xb3>
    pte = walkpgdir(pgdir, (char*)a, 0);
8010798d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107990:	83 ec 04             	sub    $0x4,%esp
80107993:	6a 00                	push   $0x0
80107995:	50                   	push   %eax
80107996:	ff 75 08             	push   0x8(%ebp)
80107999:	e8 a0 f9 ff ff       	call   8010733e <walkpgdir>
8010799e:	83 c4 10             	add    $0x10,%esp
801079a1:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(!pte)
801079a4:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
801079a8:	75 16                	jne    801079c0 <deallocuvm+0x5e>
      a = PGADDR(PDX(a) + 1, 0, 0) - PGSIZE;
801079aa:	8b 45 f4             	mov    -0xc(%ebp),%eax
801079ad:	c1 e8 16             	shr    $0x16,%eax
801079b0:	83 c0 01             	add    $0x1,%eax
801079b3:	c1 e0 16             	shl    $0x16,%eax
801079b6:	2d 00 10 00 00       	sub    $0x1000,%eax
801079bb:	89 45 f4             	mov    %eax,-0xc(%ebp)
801079be:	eb 4e                	jmp    80107a0e <deallocuvm+0xac>
    else if((*pte & PTE_P) != 0){
801079c0:	8b 45 f0             	mov    -0x10(%ebp),%eax
801079c3:	8b 00                	mov    (%eax),%eax
801079c5:	83 e0 01             	and    $0x1,%eax
801079c8:	85 c0                	test   %eax,%eax
801079ca:	74 42                	je     80107a0e <deallocuvm+0xac>
      pa = PTE_ADDR(*pte);
801079cc:	8b 45 f0             	mov    -0x10(%ebp),%eax
801079cf:	8b 00                	mov    (%eax),%eax
801079d1:	25 00 f0 ff ff       	and    $0xfffff000,%eax
801079d6:	89 45 ec             	mov    %eax,-0x14(%ebp)
      if(pa == 0)
801079d9:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
801079dd:	75 0d                	jne    801079ec <deallocuvm+0x8a>
        panic("kfree");
801079df:	83 ec 0c             	sub    $0xc,%esp
801079e2:	68 1d a8 10 80       	push   $0x8010a81d
801079e7:	e8 bd 8b ff ff       	call   801005a9 <panic>
      char *v = P2V(pa);
801079ec:	8b 45 ec             	mov    -0x14(%ebp),%eax
801079ef:	05 00 00 00 80       	add    $0x80000000,%eax
801079f4:	89 45 e8             	mov    %eax,-0x18(%ebp)
      kfree(v);
801079f7:	83 ec 0c             	sub    $0xc,%esp
801079fa:	ff 75 e8             	push   -0x18(%ebp)
801079fd:	e8 04 ad ff ff       	call   80102706 <kfree>
80107a02:	83 c4 10             	add    $0x10,%esp
      *pte = 0;
80107a05:	8b 45 f0             	mov    -0x10(%ebp),%eax
80107a08:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  for(; a  < oldsz; a += PGSIZE){
80107a0e:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
80107a15:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107a18:	3b 45 0c             	cmp    0xc(%ebp),%eax
80107a1b:	0f 82 6c ff ff ff    	jb     8010798d <deallocuvm+0x2b>
    }
  }
  return newsz;
80107a21:	8b 45 10             	mov    0x10(%ebp),%eax
}
80107a24:	c9                   	leave  
80107a25:	c3                   	ret    

80107a26 <freevm>:

// Free a page table and all the physical memory pages
// in the user part.
void
freevm(pde_t *pgdir)
{
80107a26:	55                   	push   %ebp
80107a27:	89 e5                	mov    %esp,%ebp
80107a29:	83 ec 18             	sub    $0x18,%esp
  uint i;

  if(pgdir == 0)
80107a2c:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
80107a30:	75 0d                	jne    80107a3f <freevm+0x19>
    panic("freevm: no pgdir");
80107a32:	83 ec 0c             	sub    $0xc,%esp
80107a35:	68 23 a8 10 80       	push   $0x8010a823
80107a3a:	e8 6a 8b ff ff       	call   801005a9 <panic>
  deallocuvm(pgdir, KERNBASE, 0);
80107a3f:	83 ec 04             	sub    $0x4,%esp
80107a42:	6a 00                	push   $0x0
80107a44:	68 00 00 00 80       	push   $0x80000000
80107a49:	ff 75 08             	push   0x8(%ebp)
80107a4c:	e8 11 ff ff ff       	call   80107962 <deallocuvm>
80107a51:	83 c4 10             	add    $0x10,%esp
  for(i = 0; i < NPDENTRIES; i++){
80107a54:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80107a5b:	eb 48                	jmp    80107aa5 <freevm+0x7f>
    if(pgdir[i] & PTE_P){
80107a5d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107a60:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80107a67:	8b 45 08             	mov    0x8(%ebp),%eax
80107a6a:	01 d0                	add    %edx,%eax
80107a6c:	8b 00                	mov    (%eax),%eax
80107a6e:	83 e0 01             	and    $0x1,%eax
80107a71:	85 c0                	test   %eax,%eax
80107a73:	74 2c                	je     80107aa1 <freevm+0x7b>
      char * v = P2V(PTE_ADDR(pgdir[i]));
80107a75:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107a78:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80107a7f:	8b 45 08             	mov    0x8(%ebp),%eax
80107a82:	01 d0                	add    %edx,%eax
80107a84:	8b 00                	mov    (%eax),%eax
80107a86:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80107a8b:	05 00 00 00 80       	add    $0x80000000,%eax
80107a90:	89 45 f0             	mov    %eax,-0x10(%ebp)
      kfree(v);
80107a93:	83 ec 0c             	sub    $0xc,%esp
80107a96:	ff 75 f0             	push   -0x10(%ebp)
80107a99:	e8 68 ac ff ff       	call   80102706 <kfree>
80107a9e:	83 c4 10             	add    $0x10,%esp
  for(i = 0; i < NPDENTRIES; i++){
80107aa1:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80107aa5:	81 7d f4 ff 03 00 00 	cmpl   $0x3ff,-0xc(%ebp)
80107aac:	76 af                	jbe    80107a5d <freevm+0x37>
    }
  }
  kfree((char*)pgdir);
80107aae:	83 ec 0c             	sub    $0xc,%esp
80107ab1:	ff 75 08             	push   0x8(%ebp)
80107ab4:	e8 4d ac ff ff       	call   80102706 <kfree>
80107ab9:	83 c4 10             	add    $0x10,%esp
}
80107abc:	90                   	nop
80107abd:	c9                   	leave  
80107abe:	c3                   	ret    

80107abf <clearpteu>:

// Clear PTE_U on a page. Used to create an inaccessible
// page beneath the user stack.
void
clearpteu(pde_t *pgdir, char *uva)
{
80107abf:	55                   	push   %ebp
80107ac0:	89 e5                	mov    %esp,%ebp
80107ac2:	83 ec 18             	sub    $0x18,%esp
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
80107ac5:	83 ec 04             	sub    $0x4,%esp
80107ac8:	6a 00                	push   $0x0
80107aca:	ff 75 0c             	push   0xc(%ebp)
80107acd:	ff 75 08             	push   0x8(%ebp)
80107ad0:	e8 69 f8 ff ff       	call   8010733e <walkpgdir>
80107ad5:	83 c4 10             	add    $0x10,%esp
80107ad8:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(pte == 0)
80107adb:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80107adf:	75 0d                	jne    80107aee <clearpteu+0x2f>
    panic("clearpteu");
80107ae1:	83 ec 0c             	sub    $0xc,%esp
80107ae4:	68 34 a8 10 80       	push   $0x8010a834
80107ae9:	e8 bb 8a ff ff       	call   801005a9 <panic>
  *pte &= ~PTE_U;
80107aee:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107af1:	8b 00                	mov    (%eax),%eax
80107af3:	83 e0 fb             	and    $0xfffffffb,%eax
80107af6:	89 c2                	mov    %eax,%edx
80107af8:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107afb:	89 10                	mov    %edx,(%eax)
}
80107afd:	90                   	nop
80107afe:	c9                   	leave  
80107aff:	c3                   	ret    

80107b00 <copyuvm>:

// Given a parent process's page table, create a copy
// of it for a child.
pde_t*
copyuvm(pde_t *pgdir, uint sz)
{
80107b00:	55                   	push   %ebp
80107b01:	89 e5                	mov    %esp,%ebp
80107b03:	83 ec 28             	sub    $0x28,%esp
  pde_t *d;
  pte_t *pte;
  uint pa, i, flags;
  char *mem;

  if((d = setupkvm()) == 0)
80107b06:	e8 59 f9 ff ff       	call   80107464 <setupkvm>
80107b0b:	89 45 f0             	mov    %eax,-0x10(%ebp)
80107b0e:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80107b12:	75 0a                	jne    80107b1e <copyuvm+0x1e>
    return 0;
80107b14:	b8 00 00 00 00       	mov    $0x0,%eax
80107b19:	e9 eb 00 00 00       	jmp    80107c09 <copyuvm+0x109>
  for(i = 0; i < sz; i += PGSIZE){
80107b1e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80107b25:	e9 b7 00 00 00       	jmp    80107be1 <copyuvm+0xe1>
    if((pte = walkpgdir(pgdir, (void *) i, 0)) == 0)
80107b2a:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107b2d:	83 ec 04             	sub    $0x4,%esp
80107b30:	6a 00                	push   $0x0
80107b32:	50                   	push   %eax
80107b33:	ff 75 08             	push   0x8(%ebp)
80107b36:	e8 03 f8 ff ff       	call   8010733e <walkpgdir>
80107b3b:	83 c4 10             	add    $0x10,%esp
80107b3e:	89 45 ec             	mov    %eax,-0x14(%ebp)
80107b41:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
80107b45:	75 0d                	jne    80107b54 <copyuvm+0x54>
      panic("copyuvm: pte should exist");
80107b47:	83 ec 0c             	sub    $0xc,%esp
80107b4a:	68 3e a8 10 80       	push   $0x8010a83e
80107b4f:	e8 55 8a ff ff       	call   801005a9 <panic>
    if(!(*pte & PTE_P))
80107b54:	8b 45 ec             	mov    -0x14(%ebp),%eax
80107b57:	8b 00                	mov    (%eax),%eax
80107b59:	83 e0 01             	and    $0x1,%eax
80107b5c:	85 c0                	test   %eax,%eax
80107b5e:	75 0d                	jne    80107b6d <copyuvm+0x6d>
      panic("copyuvm: page not present");
80107b60:	83 ec 0c             	sub    $0xc,%esp
80107b63:	68 58 a8 10 80       	push   $0x8010a858
80107b68:	e8 3c 8a ff ff       	call   801005a9 <panic>
    pa = PTE_ADDR(*pte);
80107b6d:	8b 45 ec             	mov    -0x14(%ebp),%eax
80107b70:	8b 00                	mov    (%eax),%eax
80107b72:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80107b77:	89 45 e8             	mov    %eax,-0x18(%ebp)
    flags = PTE_FLAGS(*pte);
80107b7a:	8b 45 ec             	mov    -0x14(%ebp),%eax
80107b7d:	8b 00                	mov    (%eax),%eax
80107b7f:	25 ff 0f 00 00       	and    $0xfff,%eax
80107b84:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if((mem = kalloc()) == 0)
80107b87:	e8 14 ac ff ff       	call   801027a0 <kalloc>
80107b8c:	89 45 e0             	mov    %eax,-0x20(%ebp)
80107b8f:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
80107b93:	74 5d                	je     80107bf2 <copyuvm+0xf2>
      goto bad;
    memmove(mem, (char*)P2V(pa), PGSIZE);
80107b95:	8b 45 e8             	mov    -0x18(%ebp),%eax
80107b98:	05 00 00 00 80       	add    $0x80000000,%eax
80107b9d:	83 ec 04             	sub    $0x4,%esp
80107ba0:	68 00 10 00 00       	push   $0x1000
80107ba5:	50                   	push   %eax
80107ba6:	ff 75 e0             	push   -0x20(%ebp)
80107ba9:	e8 61 d0 ff ff       	call   80104c0f <memmove>
80107bae:	83 c4 10             	add    $0x10,%esp
    if(mappages(d, (void*)i, PGSIZE, V2P(mem), flags) < 0)
80107bb1:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80107bb4:	8b 45 e0             	mov    -0x20(%ebp),%eax
80107bb7:	8d 88 00 00 00 80    	lea    -0x80000000(%eax),%ecx
80107bbd:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107bc0:	83 ec 0c             	sub    $0xc,%esp
80107bc3:	52                   	push   %edx
80107bc4:	51                   	push   %ecx
80107bc5:	68 00 10 00 00       	push   $0x1000
80107bca:	50                   	push   %eax
80107bcb:	ff 75 f0             	push   -0x10(%ebp)
80107bce:	e8 01 f8 ff ff       	call   801073d4 <mappages>
80107bd3:	83 c4 20             	add    $0x20,%esp
80107bd6:	85 c0                	test   %eax,%eax
80107bd8:	78 1b                	js     80107bf5 <copyuvm+0xf5>
  for(i = 0; i < sz; i += PGSIZE){
80107bda:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
80107be1:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107be4:	3b 45 0c             	cmp    0xc(%ebp),%eax
80107be7:	0f 82 3d ff ff ff    	jb     80107b2a <copyuvm+0x2a>
      goto bad;
  }
  return d;
80107bed:	8b 45 f0             	mov    -0x10(%ebp),%eax
80107bf0:	eb 17                	jmp    80107c09 <copyuvm+0x109>
      goto bad;
80107bf2:	90                   	nop
80107bf3:	eb 01                	jmp    80107bf6 <copyuvm+0xf6>
      goto bad;
80107bf5:	90                   	nop

bad:
  freevm(d);
80107bf6:	83 ec 0c             	sub    $0xc,%esp
80107bf9:	ff 75 f0             	push   -0x10(%ebp)
80107bfc:	e8 25 fe ff ff       	call   80107a26 <freevm>
80107c01:	83 c4 10             	add    $0x10,%esp
  return 0;
80107c04:	b8 00 00 00 00       	mov    $0x0,%eax
}
80107c09:	c9                   	leave  
80107c0a:	c3                   	ret    

80107c0b <uva2ka>:

//PAGEBREAK!
// Map user virtual address to kernel address.
char*
uva2ka(pde_t *pgdir, char *uva)
{
80107c0b:	55                   	push   %ebp
80107c0c:	89 e5                	mov    %esp,%ebp
80107c0e:	83 ec 18             	sub    $0x18,%esp
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
80107c11:	83 ec 04             	sub    $0x4,%esp
80107c14:	6a 00                	push   $0x0
80107c16:	ff 75 0c             	push   0xc(%ebp)
80107c19:	ff 75 08             	push   0x8(%ebp)
80107c1c:	e8 1d f7 ff ff       	call   8010733e <walkpgdir>
80107c21:	83 c4 10             	add    $0x10,%esp
80107c24:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if((*pte & PTE_P) == 0)
80107c27:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107c2a:	8b 00                	mov    (%eax),%eax
80107c2c:	83 e0 01             	and    $0x1,%eax
80107c2f:	85 c0                	test   %eax,%eax
80107c31:	75 07                	jne    80107c3a <uva2ka+0x2f>
    return 0;
80107c33:	b8 00 00 00 00       	mov    $0x0,%eax
80107c38:	eb 22                	jmp    80107c5c <uva2ka+0x51>
  if((*pte & PTE_U) == 0)
80107c3a:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107c3d:	8b 00                	mov    (%eax),%eax
80107c3f:	83 e0 04             	and    $0x4,%eax
80107c42:	85 c0                	test   %eax,%eax
80107c44:	75 07                	jne    80107c4d <uva2ka+0x42>
    return 0;
80107c46:	b8 00 00 00 00       	mov    $0x0,%eax
80107c4b:	eb 0f                	jmp    80107c5c <uva2ka+0x51>
  return (char*)P2V(PTE_ADDR(*pte));
80107c4d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107c50:	8b 00                	mov    (%eax),%eax
80107c52:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80107c57:	05 00 00 00 80       	add    $0x80000000,%eax
}
80107c5c:	c9                   	leave  
80107c5d:	c3                   	ret    

80107c5e <copyout>:
// Copy len bytes from p to user address va in page table pgdir.
// Most useful when pgdir is not the current page table.
// uva2ka ensures this only works for PTE_U pages.
int
copyout(pde_t *pgdir, uint va, void *p, uint len)
{
80107c5e:	55                   	push   %ebp
80107c5f:	89 e5                	mov    %esp,%ebp
80107c61:	83 ec 18             	sub    $0x18,%esp
  char *buf, *pa0;
  uint n, va0;

  buf = (char*)p;
80107c64:	8b 45 10             	mov    0x10(%ebp),%eax
80107c67:	89 45 f4             	mov    %eax,-0xc(%ebp)
  while(len > 0){
80107c6a:	eb 7f                	jmp    80107ceb <copyout+0x8d>
    va0 = (uint)PGROUNDDOWN(va);
80107c6c:	8b 45 0c             	mov    0xc(%ebp),%eax
80107c6f:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80107c74:	89 45 ec             	mov    %eax,-0x14(%ebp)
    pa0 = uva2ka(pgdir, (char*)va0);
80107c77:	8b 45 ec             	mov    -0x14(%ebp),%eax
80107c7a:	83 ec 08             	sub    $0x8,%esp
80107c7d:	50                   	push   %eax
80107c7e:	ff 75 08             	push   0x8(%ebp)
80107c81:	e8 85 ff ff ff       	call   80107c0b <uva2ka>
80107c86:	83 c4 10             	add    $0x10,%esp
80107c89:	89 45 e8             	mov    %eax,-0x18(%ebp)
    if(pa0 == 0)
80107c8c:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
80107c90:	75 07                	jne    80107c99 <copyout+0x3b>
      return -1;
80107c92:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80107c97:	eb 61                	jmp    80107cfa <copyout+0x9c>
    n = PGSIZE - (va - va0);
80107c99:	8b 45 ec             	mov    -0x14(%ebp),%eax
80107c9c:	2b 45 0c             	sub    0xc(%ebp),%eax
80107c9f:	05 00 10 00 00       	add    $0x1000,%eax
80107ca4:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(n > len)
80107ca7:	8b 45 f0             	mov    -0x10(%ebp),%eax
80107caa:	3b 45 14             	cmp    0x14(%ebp),%eax
80107cad:	76 06                	jbe    80107cb5 <copyout+0x57>
      n = len;
80107caf:	8b 45 14             	mov    0x14(%ebp),%eax
80107cb2:	89 45 f0             	mov    %eax,-0x10(%ebp)
    memmove(pa0 + (va - va0), buf, n);
80107cb5:	8b 45 0c             	mov    0xc(%ebp),%eax
80107cb8:	2b 45 ec             	sub    -0x14(%ebp),%eax
80107cbb:	89 c2                	mov    %eax,%edx
80107cbd:	8b 45 e8             	mov    -0x18(%ebp),%eax
80107cc0:	01 d0                	add    %edx,%eax
80107cc2:	83 ec 04             	sub    $0x4,%esp
80107cc5:	ff 75 f0             	push   -0x10(%ebp)
80107cc8:	ff 75 f4             	push   -0xc(%ebp)
80107ccb:	50                   	push   %eax
80107ccc:	e8 3e cf ff ff       	call   80104c0f <memmove>
80107cd1:	83 c4 10             	add    $0x10,%esp
    len -= n;
80107cd4:	8b 45 f0             	mov    -0x10(%ebp),%eax
80107cd7:	29 45 14             	sub    %eax,0x14(%ebp)
    buf += n;
80107cda:	8b 45 f0             	mov    -0x10(%ebp),%eax
80107cdd:	01 45 f4             	add    %eax,-0xc(%ebp)
    va = va0 + PGSIZE;
80107ce0:	8b 45 ec             	mov    -0x14(%ebp),%eax
80107ce3:	05 00 10 00 00       	add    $0x1000,%eax
80107ce8:	89 45 0c             	mov    %eax,0xc(%ebp)
  while(len > 0){
80107ceb:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
80107cef:	0f 85 77 ff ff ff    	jne    80107c6c <copyout+0xe>
  }
  return 0;
80107cf5:	b8 00 00 00 00       	mov    $0x0,%eax
}
80107cfa:	c9                   	leave  
80107cfb:	c3                   	ret    

80107cfc <mpinit_uefi>:

struct cpu cpus[NCPU];
int ncpu;
uchar ioapicid;
void mpinit_uefi(void)
{
80107cfc:	55                   	push   %ebp
80107cfd:	89 e5                	mov    %esp,%ebp
80107cff:	83 ec 20             	sub    $0x20,%esp
  struct boot_param *boot_param = (struct boot_param *)P2V_WO(BOOTPARAM);
80107d02:	c7 45 f8 00 00 05 80 	movl   $0x80050000,-0x8(%ebp)
  struct uefi_madt *madt = (struct uefi_madt*)(P2V_WO(boot_param->madt_addr));
80107d09:	8b 45 f8             	mov    -0x8(%ebp),%eax
80107d0c:	8b 40 08             	mov    0x8(%eax),%eax
80107d0f:	05 00 00 00 80       	add    $0x80000000,%eax
80107d14:	89 45 f4             	mov    %eax,-0xc(%ebp)

  uint i=sizeof(struct uefi_madt);
80107d17:	c7 45 fc 2c 00 00 00 	movl   $0x2c,-0x4(%ebp)
  struct uefi_lapic *lapic_entry;
  struct uefi_ioapic *ioapic;
  struct uefi_iso *iso;
  struct uefi_non_maskable_intr *non_mask_intr; 
  
  lapic = (uint *)(madt->lapic_addr);
80107d1e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107d21:	8b 40 24             	mov    0x24(%eax),%eax
80107d24:	a3 00 41 19 80       	mov    %eax,0x80194100
  ncpu = 0;
80107d29:	c7 05 40 6c 19 80 00 	movl   $0x0,0x80196c40
80107d30:	00 00 00 

  while(i<madt->len){
80107d33:	90                   	nop
80107d34:	e9 bd 00 00 00       	jmp    80107df6 <mpinit_uefi+0xfa>
    uchar *entry_type = ((uchar *)madt)+i;
80107d39:	8b 55 f4             	mov    -0xc(%ebp),%edx
80107d3c:	8b 45 fc             	mov    -0x4(%ebp),%eax
80107d3f:	01 d0                	add    %edx,%eax
80107d41:	89 45 f0             	mov    %eax,-0x10(%ebp)
    switch(*entry_type){
80107d44:	8b 45 f0             	mov    -0x10(%ebp),%eax
80107d47:	0f b6 00             	movzbl (%eax),%eax
80107d4a:	0f b6 c0             	movzbl %al,%eax
80107d4d:	83 f8 05             	cmp    $0x5,%eax
80107d50:	0f 87 a0 00 00 00    	ja     80107df6 <mpinit_uefi+0xfa>
80107d56:	8b 04 85 74 a8 10 80 	mov    -0x7fef578c(,%eax,4),%eax
80107d5d:	ff e0                	jmp    *%eax
      case 0:
        lapic_entry = (struct uefi_lapic *)entry_type;
80107d5f:	8b 45 f0             	mov    -0x10(%ebp),%eax
80107d62:	89 45 e0             	mov    %eax,-0x20(%ebp)
        if(ncpu < NCPU) {
80107d65:	a1 40 6c 19 80       	mov    0x80196c40,%eax
80107d6a:	83 f8 03             	cmp    $0x3,%eax
80107d6d:	7f 28                	jg     80107d97 <mpinit_uefi+0x9b>
          cpus[ncpu].apicid = lapic_entry->lapic_id;
80107d6f:	8b 15 40 6c 19 80    	mov    0x80196c40,%edx
80107d75:	8b 45 e0             	mov    -0x20(%ebp),%eax
80107d78:	0f b6 40 03          	movzbl 0x3(%eax),%eax
80107d7c:	69 d2 b0 00 00 00    	imul   $0xb0,%edx,%edx
80107d82:	81 c2 80 69 19 80    	add    $0x80196980,%edx
80107d88:	88 02                	mov    %al,(%edx)
          ncpu++;
80107d8a:	a1 40 6c 19 80       	mov    0x80196c40,%eax
80107d8f:	83 c0 01             	add    $0x1,%eax
80107d92:	a3 40 6c 19 80       	mov    %eax,0x80196c40
        }
        i += lapic_entry->record_len;
80107d97:	8b 45 e0             	mov    -0x20(%ebp),%eax
80107d9a:	0f b6 40 01          	movzbl 0x1(%eax),%eax
80107d9e:	0f b6 c0             	movzbl %al,%eax
80107da1:	01 45 fc             	add    %eax,-0x4(%ebp)
        break;
80107da4:	eb 50                	jmp    80107df6 <mpinit_uefi+0xfa>

      case 1:
        ioapic = (struct uefi_ioapic *)entry_type;
80107da6:	8b 45 f0             	mov    -0x10(%ebp),%eax
80107da9:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        ioapicid = ioapic->ioapic_id;
80107dac:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80107daf:	0f b6 40 02          	movzbl 0x2(%eax),%eax
80107db3:	a2 44 6c 19 80       	mov    %al,0x80196c44
        i += ioapic->record_len;
80107db8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80107dbb:	0f b6 40 01          	movzbl 0x1(%eax),%eax
80107dbf:	0f b6 c0             	movzbl %al,%eax
80107dc2:	01 45 fc             	add    %eax,-0x4(%ebp)
        break;
80107dc5:	eb 2f                	jmp    80107df6 <mpinit_uefi+0xfa>

      case 2:
        iso = (struct uefi_iso *)entry_type;
80107dc7:	8b 45 f0             	mov    -0x10(%ebp),%eax
80107dca:	89 45 e8             	mov    %eax,-0x18(%ebp)
        i += iso->record_len;
80107dcd:	8b 45 e8             	mov    -0x18(%ebp),%eax
80107dd0:	0f b6 40 01          	movzbl 0x1(%eax),%eax
80107dd4:	0f b6 c0             	movzbl %al,%eax
80107dd7:	01 45 fc             	add    %eax,-0x4(%ebp)
        break;
80107dda:	eb 1a                	jmp    80107df6 <mpinit_uefi+0xfa>

      case 4:
        non_mask_intr = (struct uefi_non_maskable_intr *)entry_type;
80107ddc:	8b 45 f0             	mov    -0x10(%ebp),%eax
80107ddf:	89 45 ec             	mov    %eax,-0x14(%ebp)
        i += non_mask_intr->record_len;
80107de2:	8b 45 ec             	mov    -0x14(%ebp),%eax
80107de5:	0f b6 40 01          	movzbl 0x1(%eax),%eax
80107de9:	0f b6 c0             	movzbl %al,%eax
80107dec:	01 45 fc             	add    %eax,-0x4(%ebp)
        break;
80107def:	eb 05                	jmp    80107df6 <mpinit_uefi+0xfa>

      case 5:
        i = i + 0xC;
80107df1:	83 45 fc 0c          	addl   $0xc,-0x4(%ebp)
        break;
80107df5:	90                   	nop
  while(i<madt->len){
80107df6:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107df9:	8b 40 04             	mov    0x4(%eax),%eax
80107dfc:	39 45 fc             	cmp    %eax,-0x4(%ebp)
80107dff:	0f 82 34 ff ff ff    	jb     80107d39 <mpinit_uefi+0x3d>
    }
  }

}
80107e05:	90                   	nop
80107e06:	90                   	nop
80107e07:	c9                   	leave  
80107e08:	c3                   	ret    

80107e09 <inb>:
{
80107e09:	55                   	push   %ebp
80107e0a:	89 e5                	mov    %esp,%ebp
80107e0c:	83 ec 14             	sub    $0x14,%esp
80107e0f:	8b 45 08             	mov    0x8(%ebp),%eax
80107e12:	66 89 45 ec          	mov    %ax,-0x14(%ebp)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80107e16:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
80107e1a:	89 c2                	mov    %eax,%edx
80107e1c:	ec                   	in     (%dx),%al
80107e1d:	88 45 ff             	mov    %al,-0x1(%ebp)
  return data;
80107e20:	0f b6 45 ff          	movzbl -0x1(%ebp),%eax
}
80107e24:	c9                   	leave  
80107e25:	c3                   	ret    

80107e26 <outb>:
{
80107e26:	55                   	push   %ebp
80107e27:	89 e5                	mov    %esp,%ebp
80107e29:	83 ec 08             	sub    $0x8,%esp
80107e2c:	8b 45 08             	mov    0x8(%ebp),%eax
80107e2f:	8b 55 0c             	mov    0xc(%ebp),%edx
80107e32:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
80107e36:	89 d0                	mov    %edx,%eax
80107e38:	88 45 f8             	mov    %al,-0x8(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80107e3b:	0f b6 45 f8          	movzbl -0x8(%ebp),%eax
80107e3f:	0f b7 55 fc          	movzwl -0x4(%ebp),%edx
80107e43:	ee                   	out    %al,(%dx)
}
80107e44:	90                   	nop
80107e45:	c9                   	leave  
80107e46:	c3                   	ret    

80107e47 <uart_debug>:
#include "proc.h"
#include "x86.h"

#define COM1    0x3f8

void uart_debug(char p){
80107e47:	55                   	push   %ebp
80107e48:	89 e5                	mov    %esp,%ebp
80107e4a:	83 ec 28             	sub    $0x28,%esp
80107e4d:	8b 45 08             	mov    0x8(%ebp),%eax
80107e50:	88 45 e4             	mov    %al,-0x1c(%ebp)
    // Turn off the FIFO
  outb(COM1+2, 0);
80107e53:	6a 00                	push   $0x0
80107e55:	68 fa 03 00 00       	push   $0x3fa
80107e5a:	e8 c7 ff ff ff       	call   80107e26 <outb>
80107e5f:	83 c4 08             	add    $0x8,%esp

  // 9600 baud, 8 data bits, 1 stop bit, parity off.
  outb(COM1+3, 0x80);    // Unlock divisor
80107e62:	68 80 00 00 00       	push   $0x80
80107e67:	68 fb 03 00 00       	push   $0x3fb
80107e6c:	e8 b5 ff ff ff       	call   80107e26 <outb>
80107e71:	83 c4 08             	add    $0x8,%esp
  outb(COM1+0, 115200/9600);
80107e74:	6a 0c                	push   $0xc
80107e76:	68 f8 03 00 00       	push   $0x3f8
80107e7b:	e8 a6 ff ff ff       	call   80107e26 <outb>
80107e80:	83 c4 08             	add    $0x8,%esp
  outb(COM1+1, 0);
80107e83:	6a 00                	push   $0x0
80107e85:	68 f9 03 00 00       	push   $0x3f9
80107e8a:	e8 97 ff ff ff       	call   80107e26 <outb>
80107e8f:	83 c4 08             	add    $0x8,%esp
  outb(COM1+3, 0x03);    // Lock divisor, 8 data bits.
80107e92:	6a 03                	push   $0x3
80107e94:	68 fb 03 00 00       	push   $0x3fb
80107e99:	e8 88 ff ff ff       	call   80107e26 <outb>
80107e9e:	83 c4 08             	add    $0x8,%esp
  outb(COM1+4, 0);
80107ea1:	6a 00                	push   $0x0
80107ea3:	68 fc 03 00 00       	push   $0x3fc
80107ea8:	e8 79 ff ff ff       	call   80107e26 <outb>
80107ead:	83 c4 08             	add    $0x8,%esp

  for(int i=0;i<128 && !(inb(COM1+5) & 0x20); i++) microdelay(10);
80107eb0:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80107eb7:	eb 11                	jmp    80107eca <uart_debug+0x83>
80107eb9:	83 ec 0c             	sub    $0xc,%esp
80107ebc:	6a 0a                	push   $0xa
80107ebe:	e8 74 ac ff ff       	call   80102b37 <microdelay>
80107ec3:	83 c4 10             	add    $0x10,%esp
80107ec6:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80107eca:	83 7d f4 7f          	cmpl   $0x7f,-0xc(%ebp)
80107ece:	7f 1a                	jg     80107eea <uart_debug+0xa3>
80107ed0:	83 ec 0c             	sub    $0xc,%esp
80107ed3:	68 fd 03 00 00       	push   $0x3fd
80107ed8:	e8 2c ff ff ff       	call   80107e09 <inb>
80107edd:	83 c4 10             	add    $0x10,%esp
80107ee0:	0f b6 c0             	movzbl %al,%eax
80107ee3:	83 e0 20             	and    $0x20,%eax
80107ee6:	85 c0                	test   %eax,%eax
80107ee8:	74 cf                	je     80107eb9 <uart_debug+0x72>
  outb(COM1+0, p);
80107eea:	0f b6 45 e4          	movzbl -0x1c(%ebp),%eax
80107eee:	0f b6 c0             	movzbl %al,%eax
80107ef1:	83 ec 08             	sub    $0x8,%esp
80107ef4:	50                   	push   %eax
80107ef5:	68 f8 03 00 00       	push   $0x3f8
80107efa:	e8 27 ff ff ff       	call   80107e26 <outb>
80107eff:	83 c4 10             	add    $0x10,%esp
}
80107f02:	90                   	nop
80107f03:	c9                   	leave  
80107f04:	c3                   	ret    

80107f05 <uart_debugs>:

void uart_debugs(char *p){
80107f05:	55                   	push   %ebp
80107f06:	89 e5                	mov    %esp,%ebp
80107f08:	83 ec 08             	sub    $0x8,%esp
  while(*p){
80107f0b:	eb 1b                	jmp    80107f28 <uart_debugs+0x23>
    uart_debug(*p++);
80107f0d:	8b 45 08             	mov    0x8(%ebp),%eax
80107f10:	8d 50 01             	lea    0x1(%eax),%edx
80107f13:	89 55 08             	mov    %edx,0x8(%ebp)
80107f16:	0f b6 00             	movzbl (%eax),%eax
80107f19:	0f be c0             	movsbl %al,%eax
80107f1c:	83 ec 0c             	sub    $0xc,%esp
80107f1f:	50                   	push   %eax
80107f20:	e8 22 ff ff ff       	call   80107e47 <uart_debug>
80107f25:	83 c4 10             	add    $0x10,%esp
  while(*p){
80107f28:	8b 45 08             	mov    0x8(%ebp),%eax
80107f2b:	0f b6 00             	movzbl (%eax),%eax
80107f2e:	84 c0                	test   %al,%al
80107f30:	75 db                	jne    80107f0d <uart_debugs+0x8>
  }
}
80107f32:	90                   	nop
80107f33:	90                   	nop
80107f34:	c9                   	leave  
80107f35:	c3                   	ret    

80107f36 <graphic_init>:
 * i%4 = 2 : red
 * i%4 = 3 : black
 */

struct gpu gpu;
void graphic_init(){
80107f36:	55                   	push   %ebp
80107f37:	89 e5                	mov    %esp,%ebp
80107f39:	83 ec 10             	sub    $0x10,%esp
  struct boot_param *boot_param = (struct boot_param *)P2V_WO(BOOTPARAM);
80107f3c:	c7 45 fc 00 00 05 80 	movl   $0x80050000,-0x4(%ebp)
  gpu.pvram_addr = boot_param->graphic_config.frame_base;
80107f43:	8b 45 fc             	mov    -0x4(%ebp),%eax
80107f46:	8b 50 14             	mov    0x14(%eax),%edx
80107f49:	8b 40 10             	mov    0x10(%eax),%eax
80107f4c:	a3 48 6c 19 80       	mov    %eax,0x80196c48
  gpu.vram_size = boot_param->graphic_config.frame_size;
80107f51:	8b 45 fc             	mov    -0x4(%ebp),%eax
80107f54:	8b 50 1c             	mov    0x1c(%eax),%edx
80107f57:	8b 40 18             	mov    0x18(%eax),%eax
80107f5a:	a3 50 6c 19 80       	mov    %eax,0x80196c50
  gpu.vvram_addr = DEVSPACE - gpu.vram_size;
80107f5f:	8b 15 50 6c 19 80    	mov    0x80196c50,%edx
80107f65:	b8 00 00 00 fe       	mov    $0xfe000000,%eax
80107f6a:	29 d0                	sub    %edx,%eax
80107f6c:	a3 4c 6c 19 80       	mov    %eax,0x80196c4c
  gpu.horizontal_resolution = (uint)(boot_param->graphic_config.horizontal_resolution & 0xFFFFFFFF);
80107f71:	8b 45 fc             	mov    -0x4(%ebp),%eax
80107f74:	8b 50 24             	mov    0x24(%eax),%edx
80107f77:	8b 40 20             	mov    0x20(%eax),%eax
80107f7a:	a3 54 6c 19 80       	mov    %eax,0x80196c54
  gpu.vertical_resolution = (uint)(boot_param->graphic_config.vertical_resolution & 0xFFFFFFFF);
80107f7f:	8b 45 fc             	mov    -0x4(%ebp),%eax
80107f82:	8b 50 2c             	mov    0x2c(%eax),%edx
80107f85:	8b 40 28             	mov    0x28(%eax),%eax
80107f88:	a3 58 6c 19 80       	mov    %eax,0x80196c58
  gpu.pixels_per_line = (uint)(boot_param->graphic_config.pixels_per_line & 0xFFFFFFFF);
80107f8d:	8b 45 fc             	mov    -0x4(%ebp),%eax
80107f90:	8b 50 34             	mov    0x34(%eax),%edx
80107f93:	8b 40 30             	mov    0x30(%eax),%eax
80107f96:	a3 5c 6c 19 80       	mov    %eax,0x80196c5c
}
80107f9b:	90                   	nop
80107f9c:	c9                   	leave  
80107f9d:	c3                   	ret    

80107f9e <graphic_draw_pixel>:

void graphic_draw_pixel(int x,int y,struct graphic_pixel * buffer){
80107f9e:	55                   	push   %ebp
80107f9f:	89 e5                	mov    %esp,%ebp
80107fa1:	83 ec 10             	sub    $0x10,%esp
  int pixel_addr = (sizeof(struct graphic_pixel))*(y*gpu.pixels_per_line + x);
80107fa4:	8b 15 5c 6c 19 80    	mov    0x80196c5c,%edx
80107faa:	8b 45 0c             	mov    0xc(%ebp),%eax
80107fad:	0f af d0             	imul   %eax,%edx
80107fb0:	8b 45 08             	mov    0x8(%ebp),%eax
80107fb3:	01 d0                	add    %edx,%eax
80107fb5:	c1 e0 02             	shl    $0x2,%eax
80107fb8:	89 45 fc             	mov    %eax,-0x4(%ebp)
  struct graphic_pixel *pixel = (struct graphic_pixel *)(gpu.vvram_addr + pixel_addr);
80107fbb:	8b 15 4c 6c 19 80    	mov    0x80196c4c,%edx
80107fc1:	8b 45 fc             	mov    -0x4(%ebp),%eax
80107fc4:	01 d0                	add    %edx,%eax
80107fc6:	89 45 f8             	mov    %eax,-0x8(%ebp)
  pixel->blue = buffer->blue;
80107fc9:	8b 45 10             	mov    0x10(%ebp),%eax
80107fcc:	0f b6 10             	movzbl (%eax),%edx
80107fcf:	8b 45 f8             	mov    -0x8(%ebp),%eax
80107fd2:	88 10                	mov    %dl,(%eax)
  pixel->green = buffer->green;
80107fd4:	8b 45 10             	mov    0x10(%ebp),%eax
80107fd7:	0f b6 50 01          	movzbl 0x1(%eax),%edx
80107fdb:	8b 45 f8             	mov    -0x8(%ebp),%eax
80107fde:	88 50 01             	mov    %dl,0x1(%eax)
  pixel->red = buffer->red;
80107fe1:	8b 45 10             	mov    0x10(%ebp),%eax
80107fe4:	0f b6 50 02          	movzbl 0x2(%eax),%edx
80107fe8:	8b 45 f8             	mov    -0x8(%ebp),%eax
80107feb:	88 50 02             	mov    %dl,0x2(%eax)
}
80107fee:	90                   	nop
80107fef:	c9                   	leave  
80107ff0:	c3                   	ret    

80107ff1 <graphic_scroll_up>:

void graphic_scroll_up(int height){
80107ff1:	55                   	push   %ebp
80107ff2:	89 e5                	mov    %esp,%ebp
80107ff4:	83 ec 18             	sub    $0x18,%esp
  int addr_diff = (sizeof(struct graphic_pixel))*gpu.pixels_per_line*height;
80107ff7:	8b 15 5c 6c 19 80    	mov    0x80196c5c,%edx
80107ffd:	8b 45 08             	mov    0x8(%ebp),%eax
80108000:	0f af c2             	imul   %edx,%eax
80108003:	c1 e0 02             	shl    $0x2,%eax
80108006:	89 45 f4             	mov    %eax,-0xc(%ebp)
  memmove((unsigned int *)gpu.vvram_addr,(unsigned int *)(gpu.vvram_addr + addr_diff),gpu.vram_size - addr_diff);
80108009:	a1 50 6c 19 80       	mov    0x80196c50,%eax
8010800e:	8b 55 f4             	mov    -0xc(%ebp),%edx
80108011:	29 d0                	sub    %edx,%eax
80108013:	8b 0d 4c 6c 19 80    	mov    0x80196c4c,%ecx
80108019:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010801c:	01 ca                	add    %ecx,%edx
8010801e:	89 d1                	mov    %edx,%ecx
80108020:	8b 15 4c 6c 19 80    	mov    0x80196c4c,%edx
80108026:	83 ec 04             	sub    $0x4,%esp
80108029:	50                   	push   %eax
8010802a:	51                   	push   %ecx
8010802b:	52                   	push   %edx
8010802c:	e8 de cb ff ff       	call   80104c0f <memmove>
80108031:	83 c4 10             	add    $0x10,%esp
  memset((unsigned int *)(gpu.vvram_addr + gpu.vram_size - addr_diff),0,addr_diff);
80108034:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108037:	8b 0d 4c 6c 19 80    	mov    0x80196c4c,%ecx
8010803d:	8b 15 50 6c 19 80    	mov    0x80196c50,%edx
80108043:	01 ca                	add    %ecx,%edx
80108045:	8b 4d f4             	mov    -0xc(%ebp),%ecx
80108048:	29 ca                	sub    %ecx,%edx
8010804a:	83 ec 04             	sub    $0x4,%esp
8010804d:	50                   	push   %eax
8010804e:	6a 00                	push   $0x0
80108050:	52                   	push   %edx
80108051:	e8 fa ca ff ff       	call   80104b50 <memset>
80108056:	83 c4 10             	add    $0x10,%esp
}
80108059:	90                   	nop
8010805a:	c9                   	leave  
8010805b:	c3                   	ret    

8010805c <font_render>:
8010805c:	55                   	push   %ebp
8010805d:	89 e5                	mov    %esp,%ebp
8010805f:	53                   	push   %ebx
80108060:	83 ec 14             	sub    $0x14,%esp
80108063:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
8010806a:	e9 b1 00 00 00       	jmp    80108120 <font_render+0xc4>
8010806f:	c7 45 f0 0e 00 00 00 	movl   $0xe,-0x10(%ebp)
80108076:	e9 97 00 00 00       	jmp    80108112 <font_render+0xb6>
8010807b:	8b 45 10             	mov    0x10(%ebp),%eax
8010807e:	83 e8 20             	sub    $0x20,%eax
80108081:	6b d0 1e             	imul   $0x1e,%eax,%edx
80108084:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108087:	01 d0                	add    %edx,%eax
80108089:	0f b7 84 00 a0 a8 10 	movzwl -0x7fef5760(%eax,%eax,1),%eax
80108090:	80 
80108091:	0f b7 d0             	movzwl %ax,%edx
80108094:	8b 45 f0             	mov    -0x10(%ebp),%eax
80108097:	bb 01 00 00 00       	mov    $0x1,%ebx
8010809c:	89 c1                	mov    %eax,%ecx
8010809e:	d3 e3                	shl    %cl,%ebx
801080a0:	89 d8                	mov    %ebx,%eax
801080a2:	21 d0                	and    %edx,%eax
801080a4:	89 45 ec             	mov    %eax,-0x14(%ebp)
801080a7:	8b 45 f0             	mov    -0x10(%ebp),%eax
801080aa:	ba 01 00 00 00       	mov    $0x1,%edx
801080af:	89 c1                	mov    %eax,%ecx
801080b1:	d3 e2                	shl    %cl,%edx
801080b3:	89 d0                	mov    %edx,%eax
801080b5:	39 45 ec             	cmp    %eax,-0x14(%ebp)
801080b8:	75 2b                	jne    801080e5 <font_render+0x89>
801080ba:	8b 55 0c             	mov    0xc(%ebp),%edx
801080bd:	8b 45 f4             	mov    -0xc(%ebp),%eax
801080c0:	01 c2                	add    %eax,%edx
801080c2:	b8 0e 00 00 00       	mov    $0xe,%eax
801080c7:	2b 45 f0             	sub    -0x10(%ebp),%eax
801080ca:	89 c1                	mov    %eax,%ecx
801080cc:	8b 45 08             	mov    0x8(%ebp),%eax
801080cf:	01 c8                	add    %ecx,%eax
801080d1:	83 ec 04             	sub    $0x4,%esp
801080d4:	68 e0 f4 10 80       	push   $0x8010f4e0
801080d9:	52                   	push   %edx
801080da:	50                   	push   %eax
801080db:	e8 be fe ff ff       	call   80107f9e <graphic_draw_pixel>
801080e0:	83 c4 10             	add    $0x10,%esp
801080e3:	eb 29                	jmp    8010810e <font_render+0xb2>
801080e5:	8b 55 0c             	mov    0xc(%ebp),%edx
801080e8:	8b 45 f4             	mov    -0xc(%ebp),%eax
801080eb:	01 c2                	add    %eax,%edx
801080ed:	b8 0e 00 00 00       	mov    $0xe,%eax
801080f2:	2b 45 f0             	sub    -0x10(%ebp),%eax
801080f5:	89 c1                	mov    %eax,%ecx
801080f7:	8b 45 08             	mov    0x8(%ebp),%eax
801080fa:	01 c8                	add    %ecx,%eax
801080fc:	83 ec 04             	sub    $0x4,%esp
801080ff:	68 60 6c 19 80       	push   $0x80196c60
80108104:	52                   	push   %edx
80108105:	50                   	push   %eax
80108106:	e8 93 fe ff ff       	call   80107f9e <graphic_draw_pixel>
8010810b:	83 c4 10             	add    $0x10,%esp
8010810e:	83 6d f0 01          	subl   $0x1,-0x10(%ebp)
80108112:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80108116:	0f 89 5f ff ff ff    	jns    8010807b <font_render+0x1f>
8010811c:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80108120:	83 7d f4 1d          	cmpl   $0x1d,-0xc(%ebp)
80108124:	0f 8e 45 ff ff ff    	jle    8010806f <font_render+0x13>
8010812a:	90                   	nop
8010812b:	90                   	nop
8010812c:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010812f:	c9                   	leave  
80108130:	c3                   	ret    

80108131 <font_render_string>:
80108131:	55                   	push   %ebp
80108132:	89 e5                	mov    %esp,%ebp
80108134:	53                   	push   %ebx
80108135:	83 ec 14             	sub    $0x14,%esp
80108138:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
8010813f:	eb 33                	jmp    80108174 <font_render_string+0x43>
80108141:	8b 55 f4             	mov    -0xc(%ebp),%edx
80108144:	8b 45 08             	mov    0x8(%ebp),%eax
80108147:	01 d0                	add    %edx,%eax
80108149:	0f b6 00             	movzbl (%eax),%eax
8010814c:	0f be c8             	movsbl %al,%ecx
8010814f:	8b 45 0c             	mov    0xc(%ebp),%eax
80108152:	6b d0 1e             	imul   $0x1e,%eax,%edx
80108155:	8b 5d f4             	mov    -0xc(%ebp),%ebx
80108158:	89 d8                	mov    %ebx,%eax
8010815a:	c1 e0 04             	shl    $0x4,%eax
8010815d:	29 d8                	sub    %ebx,%eax
8010815f:	83 c0 02             	add    $0x2,%eax
80108162:	83 ec 04             	sub    $0x4,%esp
80108165:	51                   	push   %ecx
80108166:	52                   	push   %edx
80108167:	50                   	push   %eax
80108168:	e8 ef fe ff ff       	call   8010805c <font_render>
8010816d:	83 c4 10             	add    $0x10,%esp
80108170:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80108174:	8b 55 f4             	mov    -0xc(%ebp),%edx
80108177:	8b 45 08             	mov    0x8(%ebp),%eax
8010817a:	01 d0                	add    %edx,%eax
8010817c:	0f b6 00             	movzbl (%eax),%eax
8010817f:	84 c0                	test   %al,%al
80108181:	74 06                	je     80108189 <font_render_string+0x58>
80108183:	83 7d f4 33          	cmpl   $0x33,-0xc(%ebp)
80108187:	7e b8                	jle    80108141 <font_render_string+0x10>
80108189:	90                   	nop
8010818a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010818d:	c9                   	leave  
8010818e:	c3                   	ret    

8010818f <pci_init>:
#include "pci.h"
#include "defs.h"
#include "types.h"
#include "i8254.h"

void pci_init(){
8010818f:	55                   	push   %ebp
80108190:	89 e5                	mov    %esp,%ebp
80108192:	53                   	push   %ebx
80108193:	83 ec 14             	sub    $0x14,%esp
  uint data;
  for(int i=0;i<256;i++){
80108196:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
8010819d:	eb 6b                	jmp    8010820a <pci_init+0x7b>
    for(int j=0;j<32;j++){
8010819f:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
801081a6:	eb 58                	jmp    80108200 <pci_init+0x71>
      for(int k=0;k<8;k++){
801081a8:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
801081af:	eb 45                	jmp    801081f6 <pci_init+0x67>
      pci_access_config(i,j,k,0,&data);
801081b1:	8b 4d ec             	mov    -0x14(%ebp),%ecx
801081b4:	8b 55 f0             	mov    -0x10(%ebp),%edx
801081b7:	8b 45 f4             	mov    -0xc(%ebp),%eax
801081ba:	83 ec 0c             	sub    $0xc,%esp
801081bd:	8d 5d e8             	lea    -0x18(%ebp),%ebx
801081c0:	53                   	push   %ebx
801081c1:	6a 00                	push   $0x0
801081c3:	51                   	push   %ecx
801081c4:	52                   	push   %edx
801081c5:	50                   	push   %eax
801081c6:	e8 b0 00 00 00       	call   8010827b <pci_access_config>
801081cb:	83 c4 20             	add    $0x20,%esp
      if((data&0xFFFF) != 0xFFFF){
801081ce:	8b 45 e8             	mov    -0x18(%ebp),%eax
801081d1:	0f b7 c0             	movzwl %ax,%eax
801081d4:	3d ff ff 00 00       	cmp    $0xffff,%eax
801081d9:	74 17                	je     801081f2 <pci_init+0x63>
        pci_init_device(i,j,k);
801081db:	8b 4d ec             	mov    -0x14(%ebp),%ecx
801081de:	8b 55 f0             	mov    -0x10(%ebp),%edx
801081e1:	8b 45 f4             	mov    -0xc(%ebp),%eax
801081e4:	83 ec 04             	sub    $0x4,%esp
801081e7:	51                   	push   %ecx
801081e8:	52                   	push   %edx
801081e9:	50                   	push   %eax
801081ea:	e8 37 01 00 00       	call   80108326 <pci_init_device>
801081ef:	83 c4 10             	add    $0x10,%esp
      for(int k=0;k<8;k++){
801081f2:	83 45 ec 01          	addl   $0x1,-0x14(%ebp)
801081f6:	83 7d ec 07          	cmpl   $0x7,-0x14(%ebp)
801081fa:	7e b5                	jle    801081b1 <pci_init+0x22>
    for(int j=0;j<32;j++){
801081fc:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
80108200:	83 7d f0 1f          	cmpl   $0x1f,-0x10(%ebp)
80108204:	7e a2                	jle    801081a8 <pci_init+0x19>
  for(int i=0;i<256;i++){
80108206:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
8010820a:	81 7d f4 ff 00 00 00 	cmpl   $0xff,-0xc(%ebp)
80108211:	7e 8c                	jle    8010819f <pci_init+0x10>
      }
      }
    }
  }
}
80108213:	90                   	nop
80108214:	90                   	nop
80108215:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80108218:	c9                   	leave  
80108219:	c3                   	ret    

8010821a <pci_write_config>:

void pci_write_config(uint config){
8010821a:	55                   	push   %ebp
8010821b:	89 e5                	mov    %esp,%ebp
  asm("mov $0xCF8,%%edx\n\t"
8010821d:	8b 45 08             	mov    0x8(%ebp),%eax
80108220:	ba f8 0c 00 00       	mov    $0xcf8,%edx
80108225:	89 c0                	mov    %eax,%eax
80108227:	ef                   	out    %eax,(%dx)
      "mov %0,%%eax\n\t"
      "out %%eax,%%dx\n\t"
      : :"r"(config));
}
80108228:	90                   	nop
80108229:	5d                   	pop    %ebp
8010822a:	c3                   	ret    

8010822b <pci_write_data>:

void pci_write_data(uint config){
8010822b:	55                   	push   %ebp
8010822c:	89 e5                	mov    %esp,%ebp
  asm("mov $0xCFC,%%edx\n\t"
8010822e:	8b 45 08             	mov    0x8(%ebp),%eax
80108231:	ba fc 0c 00 00       	mov    $0xcfc,%edx
80108236:	89 c0                	mov    %eax,%eax
80108238:	ef                   	out    %eax,(%dx)
      "mov %0,%%eax\n\t"
      "out %%eax,%%dx\n\t"
      : :"r"(config));
}
80108239:	90                   	nop
8010823a:	5d                   	pop    %ebp
8010823b:	c3                   	ret    

8010823c <pci_read_config>:
uint pci_read_config(){
8010823c:	55                   	push   %ebp
8010823d:	89 e5                	mov    %esp,%ebp
8010823f:	83 ec 18             	sub    $0x18,%esp
  uint data;
  asm("mov $0xCFC,%%edx\n\t"
80108242:	ba fc 0c 00 00       	mov    $0xcfc,%edx
80108247:	ed                   	in     (%dx),%eax
80108248:	89 45 f4             	mov    %eax,-0xc(%ebp)
      "in %%dx,%%eax\n\t"
      "mov %%eax,%0"
      :"=m"(data):);
  microdelay(200);
8010824b:	83 ec 0c             	sub    $0xc,%esp
8010824e:	68 c8 00 00 00       	push   $0xc8
80108253:	e8 df a8 ff ff       	call   80102b37 <microdelay>
80108258:	83 c4 10             	add    $0x10,%esp
  return data;
8010825b:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
8010825e:	c9                   	leave  
8010825f:	c3                   	ret    

80108260 <pci_test>:


void pci_test(){
80108260:	55                   	push   %ebp
80108261:	89 e5                	mov    %esp,%ebp
80108263:	83 ec 10             	sub    $0x10,%esp
  uint data = 0x80001804;
80108266:	c7 45 fc 04 18 00 80 	movl   $0x80001804,-0x4(%ebp)
  pci_write_config(data);
8010826d:	ff 75 fc             	push   -0x4(%ebp)
80108270:	e8 a5 ff ff ff       	call   8010821a <pci_write_config>
80108275:	83 c4 04             	add    $0x4,%esp
}
80108278:	90                   	nop
80108279:	c9                   	leave  
8010827a:	c3                   	ret    

8010827b <pci_access_config>:

void pci_access_config(uint bus_num,uint device_num,uint function_num,uint reg_addr,uint *data){
8010827b:	55                   	push   %ebp
8010827c:	89 e5                	mov    %esp,%ebp
8010827e:	83 ec 18             	sub    $0x18,%esp
  uint config_addr = ((bus_num & 0xFF)<<16) | ((device_num & 0x1F)<<11) | ((function_num & 0x7)<<8) |
80108281:	8b 45 08             	mov    0x8(%ebp),%eax
80108284:	c1 e0 10             	shl    $0x10,%eax
80108287:	25 00 00 ff 00       	and    $0xff0000,%eax
8010828c:	89 c2                	mov    %eax,%edx
8010828e:	8b 45 0c             	mov    0xc(%ebp),%eax
80108291:	c1 e0 0b             	shl    $0xb,%eax
80108294:	0f b7 c0             	movzwl %ax,%eax
80108297:	09 c2                	or     %eax,%edx
80108299:	8b 45 10             	mov    0x10(%ebp),%eax
8010829c:	c1 e0 08             	shl    $0x8,%eax
8010829f:	25 00 07 00 00       	and    $0x700,%eax
801082a4:	09 c2                	or     %eax,%edx
    (reg_addr & 0xFC) | 0x80000000;
801082a6:	8b 45 14             	mov    0x14(%ebp),%eax
801082a9:	25 fc 00 00 00       	and    $0xfc,%eax
  uint config_addr = ((bus_num & 0xFF)<<16) | ((device_num & 0x1F)<<11) | ((function_num & 0x7)<<8) |
801082ae:	09 d0                	or     %edx,%eax
801082b0:	0d 00 00 00 80       	or     $0x80000000,%eax
801082b5:	89 45 f4             	mov    %eax,-0xc(%ebp)
  pci_write_config(config_addr);
801082b8:	ff 75 f4             	push   -0xc(%ebp)
801082bb:	e8 5a ff ff ff       	call   8010821a <pci_write_config>
801082c0:	83 c4 04             	add    $0x4,%esp
  *data = pci_read_config();
801082c3:	e8 74 ff ff ff       	call   8010823c <pci_read_config>
801082c8:	8b 55 18             	mov    0x18(%ebp),%edx
801082cb:	89 02                	mov    %eax,(%edx)
}
801082cd:	90                   	nop
801082ce:	c9                   	leave  
801082cf:	c3                   	ret    

801082d0 <pci_write_config_register>:

void pci_write_config_register(uint bus_num,uint device_num,uint function_num,uint reg_addr,uint data){
801082d0:	55                   	push   %ebp
801082d1:	89 e5                	mov    %esp,%ebp
801082d3:	83 ec 10             	sub    $0x10,%esp
  uint config_addr = ((bus_num & 0xFF)<<16) | ((device_num & 0x1F)<<11) | ((function_num & 0x7)<<8) |
801082d6:	8b 45 08             	mov    0x8(%ebp),%eax
801082d9:	c1 e0 10             	shl    $0x10,%eax
801082dc:	25 00 00 ff 00       	and    $0xff0000,%eax
801082e1:	89 c2                	mov    %eax,%edx
801082e3:	8b 45 0c             	mov    0xc(%ebp),%eax
801082e6:	c1 e0 0b             	shl    $0xb,%eax
801082e9:	0f b7 c0             	movzwl %ax,%eax
801082ec:	09 c2                	or     %eax,%edx
801082ee:	8b 45 10             	mov    0x10(%ebp),%eax
801082f1:	c1 e0 08             	shl    $0x8,%eax
801082f4:	25 00 07 00 00       	and    $0x700,%eax
801082f9:	09 c2                	or     %eax,%edx
    (reg_addr & 0xFC) | 0x80000000;
801082fb:	8b 45 14             	mov    0x14(%ebp),%eax
801082fe:	25 fc 00 00 00       	and    $0xfc,%eax
  uint config_addr = ((bus_num & 0xFF)<<16) | ((device_num & 0x1F)<<11) | ((function_num & 0x7)<<8) |
80108303:	09 d0                	or     %edx,%eax
80108305:	0d 00 00 00 80       	or     $0x80000000,%eax
8010830a:	89 45 fc             	mov    %eax,-0x4(%ebp)
  pci_write_config(config_addr);
8010830d:	ff 75 fc             	push   -0x4(%ebp)
80108310:	e8 05 ff ff ff       	call   8010821a <pci_write_config>
80108315:	83 c4 04             	add    $0x4,%esp
  pci_write_data(data);
80108318:	ff 75 18             	push   0x18(%ebp)
8010831b:	e8 0b ff ff ff       	call   8010822b <pci_write_data>
80108320:	83 c4 04             	add    $0x4,%esp
}
80108323:	90                   	nop
80108324:	c9                   	leave  
80108325:	c3                   	ret    

80108326 <pci_init_device>:

struct pci_dev dev;
void pci_init_device(uint bus_num,uint device_num,uint function_num){
80108326:	55                   	push   %ebp
80108327:	89 e5                	mov    %esp,%ebp
80108329:	53                   	push   %ebx
8010832a:	83 ec 14             	sub    $0x14,%esp
  uint data;
  dev.bus_num = bus_num;
8010832d:	8b 45 08             	mov    0x8(%ebp),%eax
80108330:	a2 64 6c 19 80       	mov    %al,0x80196c64
  dev.device_num = device_num;
80108335:	8b 45 0c             	mov    0xc(%ebp),%eax
80108338:	a2 65 6c 19 80       	mov    %al,0x80196c65
  dev.function_num = function_num;
8010833d:	8b 45 10             	mov    0x10(%ebp),%eax
80108340:	a2 66 6c 19 80       	mov    %al,0x80196c66
  cprintf("PCI Device Found Bus:0x%x Device:0x%x Function:%x\n",bus_num,device_num,function_num);
80108345:	ff 75 10             	push   0x10(%ebp)
80108348:	ff 75 0c             	push   0xc(%ebp)
8010834b:	ff 75 08             	push   0x8(%ebp)
8010834e:	68 e4 be 10 80       	push   $0x8010bee4
80108353:	e8 9c 80 ff ff       	call   801003f4 <cprintf>
80108358:	83 c4 10             	add    $0x10,%esp
  
  pci_access_config(bus_num,device_num,function_num,0,&data);
8010835b:	83 ec 0c             	sub    $0xc,%esp
8010835e:	8d 45 ec             	lea    -0x14(%ebp),%eax
80108361:	50                   	push   %eax
80108362:	6a 00                	push   $0x0
80108364:	ff 75 10             	push   0x10(%ebp)
80108367:	ff 75 0c             	push   0xc(%ebp)
8010836a:	ff 75 08             	push   0x8(%ebp)
8010836d:	e8 09 ff ff ff       	call   8010827b <pci_access_config>
80108372:	83 c4 20             	add    $0x20,%esp
  uint device_id = data>>16;
80108375:	8b 45 ec             	mov    -0x14(%ebp),%eax
80108378:	c1 e8 10             	shr    $0x10,%eax
8010837b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  uint vendor_id = data&0xFFFF;
8010837e:	8b 45 ec             	mov    -0x14(%ebp),%eax
80108381:	25 ff ff 00 00       	and    $0xffff,%eax
80108386:	89 45 f0             	mov    %eax,-0x10(%ebp)
  dev.device_id = device_id;
80108389:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010838c:	a3 68 6c 19 80       	mov    %eax,0x80196c68
  dev.vendor_id = vendor_id;
80108391:	8b 45 f0             	mov    -0x10(%ebp),%eax
80108394:	a3 6c 6c 19 80       	mov    %eax,0x80196c6c
  cprintf("  Device ID:0x%x  Vendor ID:0x%x\n",device_id,vendor_id);
80108399:	83 ec 04             	sub    $0x4,%esp
8010839c:	ff 75 f0             	push   -0x10(%ebp)
8010839f:	ff 75 f4             	push   -0xc(%ebp)
801083a2:	68 18 bf 10 80       	push   $0x8010bf18
801083a7:	e8 48 80 ff ff       	call   801003f4 <cprintf>
801083ac:	83 c4 10             	add    $0x10,%esp
  
  pci_access_config(bus_num,device_num,function_num,0x8,&data);
801083af:	83 ec 0c             	sub    $0xc,%esp
801083b2:	8d 45 ec             	lea    -0x14(%ebp),%eax
801083b5:	50                   	push   %eax
801083b6:	6a 08                	push   $0x8
801083b8:	ff 75 10             	push   0x10(%ebp)
801083bb:	ff 75 0c             	push   0xc(%ebp)
801083be:	ff 75 08             	push   0x8(%ebp)
801083c1:	e8 b5 fe ff ff       	call   8010827b <pci_access_config>
801083c6:	83 c4 20             	add    $0x20,%esp
  cprintf("  Base Class:0x%x  Sub Class:0x%x  Interface:0x%x  Revision ID:0x%x\n",
801083c9:	8b 45 ec             	mov    -0x14(%ebp),%eax
801083cc:	0f b6 c8             	movzbl %al,%ecx
      data>>24,(data>>16)&0xFF,(data>>8)&0xFF,data&0xFF);
801083cf:	8b 45 ec             	mov    -0x14(%ebp),%eax
801083d2:	c1 e8 08             	shr    $0x8,%eax
  cprintf("  Base Class:0x%x  Sub Class:0x%x  Interface:0x%x  Revision ID:0x%x\n",
801083d5:	0f b6 d0             	movzbl %al,%edx
      data>>24,(data>>16)&0xFF,(data>>8)&0xFF,data&0xFF);
801083d8:	8b 45 ec             	mov    -0x14(%ebp),%eax
801083db:	c1 e8 10             	shr    $0x10,%eax
  cprintf("  Base Class:0x%x  Sub Class:0x%x  Interface:0x%x  Revision ID:0x%x\n",
801083de:	0f b6 c0             	movzbl %al,%eax
801083e1:	8b 5d ec             	mov    -0x14(%ebp),%ebx
801083e4:	c1 eb 18             	shr    $0x18,%ebx
801083e7:	83 ec 0c             	sub    $0xc,%esp
801083ea:	51                   	push   %ecx
801083eb:	52                   	push   %edx
801083ec:	50                   	push   %eax
801083ed:	53                   	push   %ebx
801083ee:	68 3c bf 10 80       	push   $0x8010bf3c
801083f3:	e8 fc 7f ff ff       	call   801003f4 <cprintf>
801083f8:	83 c4 20             	add    $0x20,%esp
  dev.base_class = data>>24;
801083fb:	8b 45 ec             	mov    -0x14(%ebp),%eax
801083fe:	c1 e8 18             	shr    $0x18,%eax
80108401:	a2 70 6c 19 80       	mov    %al,0x80196c70
  dev.sub_class = (data>>16)&0xFF;
80108406:	8b 45 ec             	mov    -0x14(%ebp),%eax
80108409:	c1 e8 10             	shr    $0x10,%eax
8010840c:	a2 71 6c 19 80       	mov    %al,0x80196c71
  dev.interface = (data>>8)&0xFF;
80108411:	8b 45 ec             	mov    -0x14(%ebp),%eax
80108414:	c1 e8 08             	shr    $0x8,%eax
80108417:	a2 72 6c 19 80       	mov    %al,0x80196c72
  dev.revision_id = data&0xFF;
8010841c:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010841f:	a2 73 6c 19 80       	mov    %al,0x80196c73
  
  pci_access_config(bus_num,device_num,function_num,0x10,&data);
80108424:	83 ec 0c             	sub    $0xc,%esp
80108427:	8d 45 ec             	lea    -0x14(%ebp),%eax
8010842a:	50                   	push   %eax
8010842b:	6a 10                	push   $0x10
8010842d:	ff 75 10             	push   0x10(%ebp)
80108430:	ff 75 0c             	push   0xc(%ebp)
80108433:	ff 75 08             	push   0x8(%ebp)
80108436:	e8 40 fe ff ff       	call   8010827b <pci_access_config>
8010843b:	83 c4 20             	add    $0x20,%esp
  dev.bar0 = data;
8010843e:	8b 45 ec             	mov    -0x14(%ebp),%eax
80108441:	a3 74 6c 19 80       	mov    %eax,0x80196c74
  pci_access_config(bus_num,device_num,function_num,0x14,&data);
80108446:	83 ec 0c             	sub    $0xc,%esp
80108449:	8d 45 ec             	lea    -0x14(%ebp),%eax
8010844c:	50                   	push   %eax
8010844d:	6a 14                	push   $0x14
8010844f:	ff 75 10             	push   0x10(%ebp)
80108452:	ff 75 0c             	push   0xc(%ebp)
80108455:	ff 75 08             	push   0x8(%ebp)
80108458:	e8 1e fe ff ff       	call   8010827b <pci_access_config>
8010845d:	83 c4 20             	add    $0x20,%esp
  dev.bar1 = data;
80108460:	8b 45 ec             	mov    -0x14(%ebp),%eax
80108463:	a3 78 6c 19 80       	mov    %eax,0x80196c78
  if(device_id == I8254_DEVICE_ID && vendor_id == I8254_VENDOR_ID){
80108468:	81 7d f4 0e 10 00 00 	cmpl   $0x100e,-0xc(%ebp)
8010846f:	75 5a                	jne    801084cb <pci_init_device+0x1a5>
80108471:	81 7d f0 86 80 00 00 	cmpl   $0x8086,-0x10(%ebp)
80108478:	75 51                	jne    801084cb <pci_init_device+0x1a5>
    cprintf("E1000 Ethernet NIC Found\n");
8010847a:	83 ec 0c             	sub    $0xc,%esp
8010847d:	68 81 bf 10 80       	push   $0x8010bf81
80108482:	e8 6d 7f ff ff       	call   801003f4 <cprintf>
80108487:	83 c4 10             	add    $0x10,%esp
    pci_access_config(bus_num,device_num,function_num,0xF0,&data);
8010848a:	83 ec 0c             	sub    $0xc,%esp
8010848d:	8d 45 ec             	lea    -0x14(%ebp),%eax
80108490:	50                   	push   %eax
80108491:	68 f0 00 00 00       	push   $0xf0
80108496:	ff 75 10             	push   0x10(%ebp)
80108499:	ff 75 0c             	push   0xc(%ebp)
8010849c:	ff 75 08             	push   0x8(%ebp)
8010849f:	e8 d7 fd ff ff       	call   8010827b <pci_access_config>
801084a4:	83 c4 20             	add    $0x20,%esp
    cprintf("Message Control:%x\n",data);
801084a7:	8b 45 ec             	mov    -0x14(%ebp),%eax
801084aa:	83 ec 08             	sub    $0x8,%esp
801084ad:	50                   	push   %eax
801084ae:	68 9b bf 10 80       	push   $0x8010bf9b
801084b3:	e8 3c 7f ff ff       	call   801003f4 <cprintf>
801084b8:	83 c4 10             	add    $0x10,%esp
    i8254_init(&dev);
801084bb:	83 ec 0c             	sub    $0xc,%esp
801084be:	68 64 6c 19 80       	push   $0x80196c64
801084c3:	e8 09 00 00 00       	call   801084d1 <i8254_init>
801084c8:	83 c4 10             	add    $0x10,%esp
  }
}
801084cb:	90                   	nop
801084cc:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801084cf:	c9                   	leave  
801084d0:	c3                   	ret    

801084d1 <i8254_init>:

uint base_addr;
uchar mac_addr[6] = {0};
uchar my_ip[4] = {10,0,1,10}; 
uint *intr_addr;
void i8254_init(struct pci_dev *dev){
801084d1:	55                   	push   %ebp
801084d2:	89 e5                	mov    %esp,%ebp
801084d4:	53                   	push   %ebx
801084d5:	83 ec 14             	sub    $0x14,%esp
  uint cmd_reg;
  //Enable Bus Master
  pci_access_config(dev->bus_num,dev->device_num,dev->function_num,0x04,&cmd_reg);
801084d8:	8b 45 08             	mov    0x8(%ebp),%eax
801084db:	0f b6 40 02          	movzbl 0x2(%eax),%eax
801084df:	0f b6 c8             	movzbl %al,%ecx
801084e2:	8b 45 08             	mov    0x8(%ebp),%eax
801084e5:	0f b6 40 01          	movzbl 0x1(%eax),%eax
801084e9:	0f b6 d0             	movzbl %al,%edx
801084ec:	8b 45 08             	mov    0x8(%ebp),%eax
801084ef:	0f b6 00             	movzbl (%eax),%eax
801084f2:	0f b6 c0             	movzbl %al,%eax
801084f5:	83 ec 0c             	sub    $0xc,%esp
801084f8:	8d 5d ec             	lea    -0x14(%ebp),%ebx
801084fb:	53                   	push   %ebx
801084fc:	6a 04                	push   $0x4
801084fe:	51                   	push   %ecx
801084ff:	52                   	push   %edx
80108500:	50                   	push   %eax
80108501:	e8 75 fd ff ff       	call   8010827b <pci_access_config>
80108506:	83 c4 20             	add    $0x20,%esp
  cmd_reg = cmd_reg | PCI_CMD_BUS_MASTER;
80108509:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010850c:	83 c8 04             	or     $0x4,%eax
8010850f:	89 45 ec             	mov    %eax,-0x14(%ebp)
  pci_write_config_register(dev->bus_num,dev->device_num,dev->function_num,0x04,cmd_reg);
80108512:	8b 5d ec             	mov    -0x14(%ebp),%ebx
80108515:	8b 45 08             	mov    0x8(%ebp),%eax
80108518:	0f b6 40 02          	movzbl 0x2(%eax),%eax
8010851c:	0f b6 c8             	movzbl %al,%ecx
8010851f:	8b 45 08             	mov    0x8(%ebp),%eax
80108522:	0f b6 40 01          	movzbl 0x1(%eax),%eax
80108526:	0f b6 d0             	movzbl %al,%edx
80108529:	8b 45 08             	mov    0x8(%ebp),%eax
8010852c:	0f b6 00             	movzbl (%eax),%eax
8010852f:	0f b6 c0             	movzbl %al,%eax
80108532:	83 ec 0c             	sub    $0xc,%esp
80108535:	53                   	push   %ebx
80108536:	6a 04                	push   $0x4
80108538:	51                   	push   %ecx
80108539:	52                   	push   %edx
8010853a:	50                   	push   %eax
8010853b:	e8 90 fd ff ff       	call   801082d0 <pci_write_config_register>
80108540:	83 c4 20             	add    $0x20,%esp
  
  base_addr = PCI_P2V(dev->bar0);
80108543:	8b 45 08             	mov    0x8(%ebp),%eax
80108546:	8b 40 10             	mov    0x10(%eax),%eax
80108549:	05 00 00 00 40       	add    $0x40000000,%eax
8010854e:	a3 7c 6c 19 80       	mov    %eax,0x80196c7c
  uint *ctrl = (uint *)base_addr;
80108553:	a1 7c 6c 19 80       	mov    0x80196c7c,%eax
80108558:	89 45 f4             	mov    %eax,-0xc(%ebp)
  //Disable Interrupts
  uint *imc = (uint *)(base_addr+0xD8);
8010855b:	a1 7c 6c 19 80       	mov    0x80196c7c,%eax
80108560:	05 d8 00 00 00       	add    $0xd8,%eax
80108565:	89 45 f0             	mov    %eax,-0x10(%ebp)
  *imc = 0xFFFFFFFF;
80108568:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010856b:	c7 00 ff ff ff ff    	movl   $0xffffffff,(%eax)
  
  //Reset NIC
  *ctrl = *ctrl | I8254_CTRL_RST;
80108571:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108574:	8b 00                	mov    (%eax),%eax
80108576:	0d 00 00 00 04       	or     $0x4000000,%eax
8010857b:	89 c2                	mov    %eax,%edx
8010857d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108580:	89 10                	mov    %edx,(%eax)

  //Enable Interrupts
  *imc = 0xFFFFFFFF;
80108582:	8b 45 f0             	mov    -0x10(%ebp),%eax
80108585:	c7 00 ff ff ff ff    	movl   $0xffffffff,(%eax)

  //Enable Link
  *ctrl |= I8254_CTRL_SLU;
8010858b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010858e:	8b 00                	mov    (%eax),%eax
80108590:	83 c8 40             	or     $0x40,%eax
80108593:	89 c2                	mov    %eax,%edx
80108595:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108598:	89 10                	mov    %edx,(%eax)
  
  //General Configuration
  *ctrl &= (~I8254_CTRL_PHY_RST | ~I8254_CTRL_VME | ~I8254_CTRL_ILOS);
8010859a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010859d:	8b 10                	mov    (%eax),%edx
8010859f:	8b 45 f4             	mov    -0xc(%ebp),%eax
801085a2:	89 10                	mov    %edx,(%eax)
  cprintf("E1000 General Configuration Done\n");
801085a4:	83 ec 0c             	sub    $0xc,%esp
801085a7:	68 b0 bf 10 80       	push   $0x8010bfb0
801085ac:	e8 43 7e ff ff       	call   801003f4 <cprintf>
801085b1:	83 c4 10             	add    $0x10,%esp
  intr_addr = (uint *)kalloc();
801085b4:	e8 e7 a1 ff ff       	call   801027a0 <kalloc>
801085b9:	a3 88 6c 19 80       	mov    %eax,0x80196c88
  *intr_addr = 0;
801085be:	a1 88 6c 19 80       	mov    0x80196c88,%eax
801085c3:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  cprintf("INTR_ADDR:%x\n",intr_addr);
801085c9:	a1 88 6c 19 80       	mov    0x80196c88,%eax
801085ce:	83 ec 08             	sub    $0x8,%esp
801085d1:	50                   	push   %eax
801085d2:	68 d2 bf 10 80       	push   $0x8010bfd2
801085d7:	e8 18 7e ff ff       	call   801003f4 <cprintf>
801085dc:	83 c4 10             	add    $0x10,%esp
  i8254_init_recv();
801085df:	e8 50 00 00 00       	call   80108634 <i8254_init_recv>
  i8254_init_send();
801085e4:	e8 69 03 00 00       	call   80108952 <i8254_init_send>
  cprintf("IP Address %d.%d.%d.%d\n",
      my_ip[0],
      my_ip[1],
      my_ip[2],
      my_ip[3]);
801085e9:	0f b6 05 e7 f4 10 80 	movzbl 0x8010f4e7,%eax
  cprintf("IP Address %d.%d.%d.%d\n",
801085f0:	0f b6 d8             	movzbl %al,%ebx
      my_ip[2],
801085f3:	0f b6 05 e6 f4 10 80 	movzbl 0x8010f4e6,%eax
  cprintf("IP Address %d.%d.%d.%d\n",
801085fa:	0f b6 c8             	movzbl %al,%ecx
      my_ip[1],
801085fd:	0f b6 05 e5 f4 10 80 	movzbl 0x8010f4e5,%eax
  cprintf("IP Address %d.%d.%d.%d\n",
80108604:	0f b6 d0             	movzbl %al,%edx
      my_ip[0],
80108607:	0f b6 05 e4 f4 10 80 	movzbl 0x8010f4e4,%eax
  cprintf("IP Address %d.%d.%d.%d\n",
8010860e:	0f b6 c0             	movzbl %al,%eax
80108611:	83 ec 0c             	sub    $0xc,%esp
80108614:	53                   	push   %ebx
80108615:	51                   	push   %ecx
80108616:	52                   	push   %edx
80108617:	50                   	push   %eax
80108618:	68 e0 bf 10 80       	push   $0x8010bfe0
8010861d:	e8 d2 7d ff ff       	call   801003f4 <cprintf>
80108622:	83 c4 20             	add    $0x20,%esp
  *imc = 0x0;
80108625:	8b 45 f0             	mov    -0x10(%ebp),%eax
80108628:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
}
8010862e:	90                   	nop
8010862f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80108632:	c9                   	leave  
80108633:	c3                   	ret    

80108634 <i8254_init_recv>:

void i8254_init_recv(){
80108634:	55                   	push   %ebp
80108635:	89 e5                	mov    %esp,%ebp
80108637:	57                   	push   %edi
80108638:	56                   	push   %esi
80108639:	53                   	push   %ebx
8010863a:	83 ec 6c             	sub    $0x6c,%esp
  
  uint data_l = i8254_read_eeprom(0x0);
8010863d:	83 ec 0c             	sub    $0xc,%esp
80108640:	6a 00                	push   $0x0
80108642:	e8 e8 04 00 00       	call   80108b2f <i8254_read_eeprom>
80108647:	83 c4 10             	add    $0x10,%esp
8010864a:	89 45 d8             	mov    %eax,-0x28(%ebp)
  mac_addr[0] = data_l&0xFF;
8010864d:	8b 45 d8             	mov    -0x28(%ebp),%eax
80108650:	a2 80 6c 19 80       	mov    %al,0x80196c80
  mac_addr[1] = data_l>>8;
80108655:	8b 45 d8             	mov    -0x28(%ebp),%eax
80108658:	c1 e8 08             	shr    $0x8,%eax
8010865b:	a2 81 6c 19 80       	mov    %al,0x80196c81
  uint data_m = i8254_read_eeprom(0x1);
80108660:	83 ec 0c             	sub    $0xc,%esp
80108663:	6a 01                	push   $0x1
80108665:	e8 c5 04 00 00       	call   80108b2f <i8254_read_eeprom>
8010866a:	83 c4 10             	add    $0x10,%esp
8010866d:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  mac_addr[2] = data_m&0xFF;
80108670:	8b 45 d4             	mov    -0x2c(%ebp),%eax
80108673:	a2 82 6c 19 80       	mov    %al,0x80196c82
  mac_addr[3] = data_m>>8;
80108678:	8b 45 d4             	mov    -0x2c(%ebp),%eax
8010867b:	c1 e8 08             	shr    $0x8,%eax
8010867e:	a2 83 6c 19 80       	mov    %al,0x80196c83
  uint data_h = i8254_read_eeprom(0x2);
80108683:	83 ec 0c             	sub    $0xc,%esp
80108686:	6a 02                	push   $0x2
80108688:	e8 a2 04 00 00       	call   80108b2f <i8254_read_eeprom>
8010868d:	83 c4 10             	add    $0x10,%esp
80108690:	89 45 d0             	mov    %eax,-0x30(%ebp)
  mac_addr[4] = data_h&0xFF;
80108693:	8b 45 d0             	mov    -0x30(%ebp),%eax
80108696:	a2 84 6c 19 80       	mov    %al,0x80196c84
  mac_addr[5] = data_h>>8;
8010869b:	8b 45 d0             	mov    -0x30(%ebp),%eax
8010869e:	c1 e8 08             	shr    $0x8,%eax
801086a1:	a2 85 6c 19 80       	mov    %al,0x80196c85
      mac_addr[0],
      mac_addr[1],
      mac_addr[2],
      mac_addr[3],
      mac_addr[4],
      mac_addr[5]);
801086a6:	0f b6 05 85 6c 19 80 	movzbl 0x80196c85,%eax
  cprintf("MAC Address %x:%x:%x:%x:%x:%x\n",
801086ad:	0f b6 f8             	movzbl %al,%edi
      mac_addr[4],
801086b0:	0f b6 05 84 6c 19 80 	movzbl 0x80196c84,%eax
  cprintf("MAC Address %x:%x:%x:%x:%x:%x\n",
801086b7:	0f b6 f0             	movzbl %al,%esi
      mac_addr[3],
801086ba:	0f b6 05 83 6c 19 80 	movzbl 0x80196c83,%eax
  cprintf("MAC Address %x:%x:%x:%x:%x:%x\n",
801086c1:	0f b6 d8             	movzbl %al,%ebx
      mac_addr[2],
801086c4:	0f b6 05 82 6c 19 80 	movzbl 0x80196c82,%eax
  cprintf("MAC Address %x:%x:%x:%x:%x:%x\n",
801086cb:	0f b6 c8             	movzbl %al,%ecx
      mac_addr[1],
801086ce:	0f b6 05 81 6c 19 80 	movzbl 0x80196c81,%eax
  cprintf("MAC Address %x:%x:%x:%x:%x:%x\n",
801086d5:	0f b6 d0             	movzbl %al,%edx
      mac_addr[0],
801086d8:	0f b6 05 80 6c 19 80 	movzbl 0x80196c80,%eax
  cprintf("MAC Address %x:%x:%x:%x:%x:%x\n",
801086df:	0f b6 c0             	movzbl %al,%eax
801086e2:	83 ec 04             	sub    $0x4,%esp
801086e5:	57                   	push   %edi
801086e6:	56                   	push   %esi
801086e7:	53                   	push   %ebx
801086e8:	51                   	push   %ecx
801086e9:	52                   	push   %edx
801086ea:	50                   	push   %eax
801086eb:	68 f8 bf 10 80       	push   $0x8010bff8
801086f0:	e8 ff 7c ff ff       	call   801003f4 <cprintf>
801086f5:	83 c4 20             	add    $0x20,%esp

  uint *ral = (uint *)(base_addr + 0x5400);
801086f8:	a1 7c 6c 19 80       	mov    0x80196c7c,%eax
801086fd:	05 00 54 00 00       	add    $0x5400,%eax
80108702:	89 45 cc             	mov    %eax,-0x34(%ebp)
  uint *rah = (uint *)(base_addr + 0x5404);
80108705:	a1 7c 6c 19 80       	mov    0x80196c7c,%eax
8010870a:	05 04 54 00 00       	add    $0x5404,%eax
8010870f:	89 45 c8             	mov    %eax,-0x38(%ebp)

  *ral = (data_l | (data_m << 16));
80108712:	8b 45 d4             	mov    -0x2c(%ebp),%eax
80108715:	c1 e0 10             	shl    $0x10,%eax
80108718:	0b 45 d8             	or     -0x28(%ebp),%eax
8010871b:	89 c2                	mov    %eax,%edx
8010871d:	8b 45 cc             	mov    -0x34(%ebp),%eax
80108720:	89 10                	mov    %edx,(%eax)
  *rah = (data_h | I8254_RAH_AS_DEST | I8254_RAH_AV);
80108722:	8b 45 d0             	mov    -0x30(%ebp),%eax
80108725:	0d 00 00 00 80       	or     $0x80000000,%eax
8010872a:	89 c2                	mov    %eax,%edx
8010872c:	8b 45 c8             	mov    -0x38(%ebp),%eax
8010872f:	89 10                	mov    %edx,(%eax)

  uint *mta = (uint *)(base_addr + 0x5200);
80108731:	a1 7c 6c 19 80       	mov    0x80196c7c,%eax
80108736:	05 00 52 00 00       	add    $0x5200,%eax
8010873b:	89 45 c4             	mov    %eax,-0x3c(%ebp)
  for(int i=0;i<128;i++){
8010873e:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
80108745:	eb 19                	jmp    80108760 <i8254_init_recv+0x12c>
    mta[i] = 0;
80108747:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010874a:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80108751:	8b 45 c4             	mov    -0x3c(%ebp),%eax
80108754:	01 d0                	add    %edx,%eax
80108756:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  for(int i=0;i<128;i++){
8010875c:	83 45 e4 01          	addl   $0x1,-0x1c(%ebp)
80108760:	83 7d e4 7f          	cmpl   $0x7f,-0x1c(%ebp)
80108764:	7e e1                	jle    80108747 <i8254_init_recv+0x113>
  }

  uint *ims = (uint *)(base_addr + 0xD0);
80108766:	a1 7c 6c 19 80       	mov    0x80196c7c,%eax
8010876b:	05 d0 00 00 00       	add    $0xd0,%eax
80108770:	89 45 c0             	mov    %eax,-0x40(%ebp)
  *ims = (I8254_IMS_RXT0 | I8254_IMS_RXDMT0 | I8254_IMS_RXSEQ | I8254_IMS_LSC | I8254_IMS_RXO);
80108773:	8b 45 c0             	mov    -0x40(%ebp),%eax
80108776:	c7 00 dc 00 00 00    	movl   $0xdc,(%eax)
  uint *ics = (uint *)(base_addr + 0xC8);
8010877c:	a1 7c 6c 19 80       	mov    0x80196c7c,%eax
80108781:	05 c8 00 00 00       	add    $0xc8,%eax
80108786:	89 45 bc             	mov    %eax,-0x44(%ebp)
  *ics = (I8254_IMS_RXT0 | I8254_IMS_RXDMT0 | I8254_IMS_RXSEQ | I8254_IMS_LSC | I8254_IMS_RXO);
80108789:	8b 45 bc             	mov    -0x44(%ebp),%eax
8010878c:	c7 00 dc 00 00 00    	movl   $0xdc,(%eax)



  uint *rxdctl = (uint *)(base_addr + 0x2828);
80108792:	a1 7c 6c 19 80       	mov    0x80196c7c,%eax
80108797:	05 28 28 00 00       	add    $0x2828,%eax
8010879c:	89 45 b8             	mov    %eax,-0x48(%ebp)
  *rxdctl = 0;
8010879f:	8b 45 b8             	mov    -0x48(%ebp),%eax
801087a2:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

  uint *rctl = (uint *)(base_addr + 0x100);
801087a8:	a1 7c 6c 19 80       	mov    0x80196c7c,%eax
801087ad:	05 00 01 00 00       	add    $0x100,%eax
801087b2:	89 45 b4             	mov    %eax,-0x4c(%ebp)
  *rctl = (I8254_RCTL_UPE | I8254_RCTL_MPE | I8254_RCTL_BAM | I8254_RCTL_BSIZE | I8254_RCTL_SECRC);
801087b5:	8b 45 b4             	mov    -0x4c(%ebp),%eax
801087b8:	c7 00 18 80 00 04    	movl   $0x4008018,(%eax)

  uint recv_desc_addr = (uint)kalloc();
801087be:	e8 dd 9f ff ff       	call   801027a0 <kalloc>
801087c3:	89 45 b0             	mov    %eax,-0x50(%ebp)
  uint *rdbal = (uint *)(base_addr + 0x2800);
801087c6:	a1 7c 6c 19 80       	mov    0x80196c7c,%eax
801087cb:	05 00 28 00 00       	add    $0x2800,%eax
801087d0:	89 45 ac             	mov    %eax,-0x54(%ebp)
  uint *rdbah = (uint *)(base_addr + 0x2804);
801087d3:	a1 7c 6c 19 80       	mov    0x80196c7c,%eax
801087d8:	05 04 28 00 00       	add    $0x2804,%eax
801087dd:	89 45 a8             	mov    %eax,-0x58(%ebp)
  uint *rdlen = (uint *)(base_addr + 0x2808);
801087e0:	a1 7c 6c 19 80       	mov    0x80196c7c,%eax
801087e5:	05 08 28 00 00       	add    $0x2808,%eax
801087ea:	89 45 a4             	mov    %eax,-0x5c(%ebp)
  uint *rdh = (uint *)(base_addr + 0x2810);
801087ed:	a1 7c 6c 19 80       	mov    0x80196c7c,%eax
801087f2:	05 10 28 00 00       	add    $0x2810,%eax
801087f7:	89 45 a0             	mov    %eax,-0x60(%ebp)
  uint *rdt = (uint *)(base_addr + 0x2818);
801087fa:	a1 7c 6c 19 80       	mov    0x80196c7c,%eax
801087ff:	05 18 28 00 00       	add    $0x2818,%eax
80108804:	89 45 9c             	mov    %eax,-0x64(%ebp)

  *rdbal = V2P(recv_desc_addr);
80108807:	8b 45 b0             	mov    -0x50(%ebp),%eax
8010880a:	8d 90 00 00 00 80    	lea    -0x80000000(%eax),%edx
80108810:	8b 45 ac             	mov    -0x54(%ebp),%eax
80108813:	89 10                	mov    %edx,(%eax)
  *rdbah = 0;
80108815:	8b 45 a8             	mov    -0x58(%ebp),%eax
80108818:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  *rdlen = sizeof(struct i8254_recv_desc)*I8254_RECV_DESC_NUM;
8010881e:	8b 45 a4             	mov    -0x5c(%ebp),%eax
80108821:	c7 00 00 10 00 00    	movl   $0x1000,(%eax)
  *rdh = 0;
80108827:	8b 45 a0             	mov    -0x60(%ebp),%eax
8010882a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  *rdt = I8254_RECV_DESC_NUM;
80108830:	8b 45 9c             	mov    -0x64(%ebp),%eax
80108833:	c7 00 00 01 00 00    	movl   $0x100,(%eax)

  struct i8254_recv_desc *recv_desc = (struct i8254_recv_desc *)recv_desc_addr;
80108839:	8b 45 b0             	mov    -0x50(%ebp),%eax
8010883c:	89 45 98             	mov    %eax,-0x68(%ebp)
  for(int i=0;i<I8254_RECV_DESC_NUM;i++){
8010883f:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
80108846:	eb 73                	jmp    801088bb <i8254_init_recv+0x287>
    recv_desc[i].padding = 0;
80108848:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010884b:	c1 e0 04             	shl    $0x4,%eax
8010884e:	89 c2                	mov    %eax,%edx
80108850:	8b 45 98             	mov    -0x68(%ebp),%eax
80108853:	01 d0                	add    %edx,%eax
80108855:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
    recv_desc[i].len = 0;
8010885c:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010885f:	c1 e0 04             	shl    $0x4,%eax
80108862:	89 c2                	mov    %eax,%edx
80108864:	8b 45 98             	mov    -0x68(%ebp),%eax
80108867:	01 d0                	add    %edx,%eax
80108869:	66 c7 40 08 00 00    	movw   $0x0,0x8(%eax)
    recv_desc[i].chk_sum = 0;
8010886f:	8b 45 e0             	mov    -0x20(%ebp),%eax
80108872:	c1 e0 04             	shl    $0x4,%eax
80108875:	89 c2                	mov    %eax,%edx
80108877:	8b 45 98             	mov    -0x68(%ebp),%eax
8010887a:	01 d0                	add    %edx,%eax
8010887c:	66 c7 40 0a 00 00    	movw   $0x0,0xa(%eax)
    recv_desc[i].status = 0;
80108882:	8b 45 e0             	mov    -0x20(%ebp),%eax
80108885:	c1 e0 04             	shl    $0x4,%eax
80108888:	89 c2                	mov    %eax,%edx
8010888a:	8b 45 98             	mov    -0x68(%ebp),%eax
8010888d:	01 d0                	add    %edx,%eax
8010888f:	c6 40 0c 00          	movb   $0x0,0xc(%eax)
    recv_desc[i].errors = 0;
80108893:	8b 45 e0             	mov    -0x20(%ebp),%eax
80108896:	c1 e0 04             	shl    $0x4,%eax
80108899:	89 c2                	mov    %eax,%edx
8010889b:	8b 45 98             	mov    -0x68(%ebp),%eax
8010889e:	01 d0                	add    %edx,%eax
801088a0:	c6 40 0d 00          	movb   $0x0,0xd(%eax)
    recv_desc[i].special = 0;
801088a4:	8b 45 e0             	mov    -0x20(%ebp),%eax
801088a7:	c1 e0 04             	shl    $0x4,%eax
801088aa:	89 c2                	mov    %eax,%edx
801088ac:	8b 45 98             	mov    -0x68(%ebp),%eax
801088af:	01 d0                	add    %edx,%eax
801088b1:	66 c7 40 0e 00 00    	movw   $0x0,0xe(%eax)
  for(int i=0;i<I8254_RECV_DESC_NUM;i++){
801088b7:	83 45 e0 01          	addl   $0x1,-0x20(%ebp)
801088bb:	81 7d e0 ff 00 00 00 	cmpl   $0xff,-0x20(%ebp)
801088c2:	7e 84                	jle    80108848 <i8254_init_recv+0x214>
  }

  for(int i=0;i<(I8254_RECV_DESC_NUM)/2;i++){
801088c4:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
801088cb:	eb 57                	jmp    80108924 <i8254_init_recv+0x2f0>
    uint buf_addr = (uint)kalloc();
801088cd:	e8 ce 9e ff ff       	call   801027a0 <kalloc>
801088d2:	89 45 94             	mov    %eax,-0x6c(%ebp)
    if(buf_addr == 0){
801088d5:	83 7d 94 00          	cmpl   $0x0,-0x6c(%ebp)
801088d9:	75 12                	jne    801088ed <i8254_init_recv+0x2b9>
      cprintf("failed to allocate buffer area\n");
801088db:	83 ec 0c             	sub    $0xc,%esp
801088de:	68 18 c0 10 80       	push   $0x8010c018
801088e3:	e8 0c 7b ff ff       	call   801003f4 <cprintf>
801088e8:	83 c4 10             	add    $0x10,%esp
      break;
801088eb:	eb 3d                	jmp    8010892a <i8254_init_recv+0x2f6>
    }
    recv_desc[i].buf_addr = V2P(buf_addr);
801088ed:	8b 45 dc             	mov    -0x24(%ebp),%eax
801088f0:	c1 e0 04             	shl    $0x4,%eax
801088f3:	89 c2                	mov    %eax,%edx
801088f5:	8b 45 98             	mov    -0x68(%ebp),%eax
801088f8:	01 d0                	add    %edx,%eax
801088fa:	8b 55 94             	mov    -0x6c(%ebp),%edx
801088fd:	81 c2 00 00 00 80    	add    $0x80000000,%edx
80108903:	89 10                	mov    %edx,(%eax)
    recv_desc[i+1].buf_addr = V2P(buf_addr + 0x800);
80108905:	8b 45 dc             	mov    -0x24(%ebp),%eax
80108908:	83 c0 01             	add    $0x1,%eax
8010890b:	c1 e0 04             	shl    $0x4,%eax
8010890e:	89 c2                	mov    %eax,%edx
80108910:	8b 45 98             	mov    -0x68(%ebp),%eax
80108913:	01 d0                	add    %edx,%eax
80108915:	8b 55 94             	mov    -0x6c(%ebp),%edx
80108918:	81 ea 00 f8 ff 7f    	sub    $0x7ffff800,%edx
8010891e:	89 10                	mov    %edx,(%eax)
  for(int i=0;i<(I8254_RECV_DESC_NUM)/2;i++){
80108920:	83 45 dc 01          	addl   $0x1,-0x24(%ebp)
80108924:	83 7d dc 7f          	cmpl   $0x7f,-0x24(%ebp)
80108928:	7e a3                	jle    801088cd <i8254_init_recv+0x299>
  }

  *rctl |= I8254_RCTL_EN;
8010892a:	8b 45 b4             	mov    -0x4c(%ebp),%eax
8010892d:	8b 00                	mov    (%eax),%eax
8010892f:	83 c8 02             	or     $0x2,%eax
80108932:	89 c2                	mov    %eax,%edx
80108934:	8b 45 b4             	mov    -0x4c(%ebp),%eax
80108937:	89 10                	mov    %edx,(%eax)
  cprintf("E1000 Recieve Initialize Done\n");
80108939:	83 ec 0c             	sub    $0xc,%esp
8010893c:	68 38 c0 10 80       	push   $0x8010c038
80108941:	e8 ae 7a ff ff       	call   801003f4 <cprintf>
80108946:	83 c4 10             	add    $0x10,%esp
}
80108949:	90                   	nop
8010894a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010894d:	5b                   	pop    %ebx
8010894e:	5e                   	pop    %esi
8010894f:	5f                   	pop    %edi
80108950:	5d                   	pop    %ebp
80108951:	c3                   	ret    

80108952 <i8254_init_send>:

void i8254_init_send(){
80108952:	55                   	push   %ebp
80108953:	89 e5                	mov    %esp,%ebp
80108955:	83 ec 48             	sub    $0x48,%esp
  uint *txdctl = (uint *)(base_addr + 0x3828);
80108958:	a1 7c 6c 19 80       	mov    0x80196c7c,%eax
8010895d:	05 28 38 00 00       	add    $0x3828,%eax
80108962:	89 45 ec             	mov    %eax,-0x14(%ebp)
  *txdctl = (I8254_TXDCTL_WTHRESH | I8254_TXDCTL_GRAN_DESC);
80108965:	8b 45 ec             	mov    -0x14(%ebp),%eax
80108968:	c7 00 00 00 01 01    	movl   $0x1010000,(%eax)

  uint tx_desc_addr = (uint)kalloc();
8010896e:	e8 2d 9e ff ff       	call   801027a0 <kalloc>
80108973:	89 45 e8             	mov    %eax,-0x18(%ebp)
  uint *tdbal = (uint *)(base_addr + 0x3800);
80108976:	a1 7c 6c 19 80       	mov    0x80196c7c,%eax
8010897b:	05 00 38 00 00       	add    $0x3800,%eax
80108980:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  uint *tdbah = (uint *)(base_addr + 0x3804);
80108983:	a1 7c 6c 19 80       	mov    0x80196c7c,%eax
80108988:	05 04 38 00 00       	add    $0x3804,%eax
8010898d:	89 45 e0             	mov    %eax,-0x20(%ebp)
  uint *tdlen = (uint *)(base_addr + 0x3808);
80108990:	a1 7c 6c 19 80       	mov    0x80196c7c,%eax
80108995:	05 08 38 00 00       	add    $0x3808,%eax
8010899a:	89 45 dc             	mov    %eax,-0x24(%ebp)

  *tdbal = V2P(tx_desc_addr);
8010899d:	8b 45 e8             	mov    -0x18(%ebp),%eax
801089a0:	8d 90 00 00 00 80    	lea    -0x80000000(%eax),%edx
801089a6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801089a9:	89 10                	mov    %edx,(%eax)
  *tdbah = 0;
801089ab:	8b 45 e0             	mov    -0x20(%ebp),%eax
801089ae:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  *tdlen = sizeof(struct i8254_send_desc)*I8254_SEND_DESC_NUM;
801089b4:	8b 45 dc             	mov    -0x24(%ebp),%eax
801089b7:	c7 00 00 10 00 00    	movl   $0x1000,(%eax)
  uint *tdh = (uint *)(base_addr + 0x3810);
801089bd:	a1 7c 6c 19 80       	mov    0x80196c7c,%eax
801089c2:	05 10 38 00 00       	add    $0x3810,%eax
801089c7:	89 45 d8             	mov    %eax,-0x28(%ebp)
  uint *tdt = (uint *)(base_addr + 0x3818);
801089ca:	a1 7c 6c 19 80       	mov    0x80196c7c,%eax
801089cf:	05 18 38 00 00       	add    $0x3818,%eax
801089d4:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  
  *tdh = 0;
801089d7:	8b 45 d8             	mov    -0x28(%ebp),%eax
801089da:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  *tdt = 0;
801089e0:	8b 45 d4             	mov    -0x2c(%ebp),%eax
801089e3:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

  struct i8254_send_desc *send_desc = (struct i8254_send_desc *)tx_desc_addr;
801089e9:	8b 45 e8             	mov    -0x18(%ebp),%eax
801089ec:	89 45 d0             	mov    %eax,-0x30(%ebp)
  for(int i=0;i<I8254_SEND_DESC_NUM;i++){
801089ef:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
801089f6:	e9 82 00 00 00       	jmp    80108a7d <i8254_init_send+0x12b>
    send_desc[i].padding = 0;
801089fb:	8b 45 f4             	mov    -0xc(%ebp),%eax
801089fe:	c1 e0 04             	shl    $0x4,%eax
80108a01:	89 c2                	mov    %eax,%edx
80108a03:	8b 45 d0             	mov    -0x30(%ebp),%eax
80108a06:	01 d0                	add    %edx,%eax
80108a08:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
    send_desc[i].len = 0;
80108a0f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108a12:	c1 e0 04             	shl    $0x4,%eax
80108a15:	89 c2                	mov    %eax,%edx
80108a17:	8b 45 d0             	mov    -0x30(%ebp),%eax
80108a1a:	01 d0                	add    %edx,%eax
80108a1c:	66 c7 40 08 00 00    	movw   $0x0,0x8(%eax)
    send_desc[i].cso = 0;
80108a22:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108a25:	c1 e0 04             	shl    $0x4,%eax
80108a28:	89 c2                	mov    %eax,%edx
80108a2a:	8b 45 d0             	mov    -0x30(%ebp),%eax
80108a2d:	01 d0                	add    %edx,%eax
80108a2f:	c6 40 0a 00          	movb   $0x0,0xa(%eax)
    send_desc[i].cmd = 0;
80108a33:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108a36:	c1 e0 04             	shl    $0x4,%eax
80108a39:	89 c2                	mov    %eax,%edx
80108a3b:	8b 45 d0             	mov    -0x30(%ebp),%eax
80108a3e:	01 d0                	add    %edx,%eax
80108a40:	c6 40 0b 00          	movb   $0x0,0xb(%eax)
    send_desc[i].sta = 0;
80108a44:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108a47:	c1 e0 04             	shl    $0x4,%eax
80108a4a:	89 c2                	mov    %eax,%edx
80108a4c:	8b 45 d0             	mov    -0x30(%ebp),%eax
80108a4f:	01 d0                	add    %edx,%eax
80108a51:	c6 40 0c 00          	movb   $0x0,0xc(%eax)
    send_desc[i].css = 0;
80108a55:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108a58:	c1 e0 04             	shl    $0x4,%eax
80108a5b:	89 c2                	mov    %eax,%edx
80108a5d:	8b 45 d0             	mov    -0x30(%ebp),%eax
80108a60:	01 d0                	add    %edx,%eax
80108a62:	c6 40 0d 00          	movb   $0x0,0xd(%eax)
    send_desc[i].special = 0;
80108a66:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108a69:	c1 e0 04             	shl    $0x4,%eax
80108a6c:	89 c2                	mov    %eax,%edx
80108a6e:	8b 45 d0             	mov    -0x30(%ebp),%eax
80108a71:	01 d0                	add    %edx,%eax
80108a73:	66 c7 40 0e 00 00    	movw   $0x0,0xe(%eax)
  for(int i=0;i<I8254_SEND_DESC_NUM;i++){
80108a79:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80108a7d:	81 7d f4 ff 00 00 00 	cmpl   $0xff,-0xc(%ebp)
80108a84:	0f 8e 71 ff ff ff    	jle    801089fb <i8254_init_send+0xa9>
  }

  for(int i=0;i<(I8254_SEND_DESC_NUM)/2;i++){
80108a8a:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
80108a91:	eb 57                	jmp    80108aea <i8254_init_send+0x198>
    uint buf_addr = (uint)kalloc();
80108a93:	e8 08 9d ff ff       	call   801027a0 <kalloc>
80108a98:	89 45 cc             	mov    %eax,-0x34(%ebp)
    if(buf_addr == 0){
80108a9b:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
80108a9f:	75 12                	jne    80108ab3 <i8254_init_send+0x161>
      cprintf("failed to allocate buffer area\n");
80108aa1:	83 ec 0c             	sub    $0xc,%esp
80108aa4:	68 18 c0 10 80       	push   $0x8010c018
80108aa9:	e8 46 79 ff ff       	call   801003f4 <cprintf>
80108aae:	83 c4 10             	add    $0x10,%esp
      break;
80108ab1:	eb 3d                	jmp    80108af0 <i8254_init_send+0x19e>
    }
    send_desc[i].buf_addr = V2P(buf_addr);
80108ab3:	8b 45 f0             	mov    -0x10(%ebp),%eax
80108ab6:	c1 e0 04             	shl    $0x4,%eax
80108ab9:	89 c2                	mov    %eax,%edx
80108abb:	8b 45 d0             	mov    -0x30(%ebp),%eax
80108abe:	01 d0                	add    %edx,%eax
80108ac0:	8b 55 cc             	mov    -0x34(%ebp),%edx
80108ac3:	81 c2 00 00 00 80    	add    $0x80000000,%edx
80108ac9:	89 10                	mov    %edx,(%eax)
    send_desc[i+1].buf_addr = V2P(buf_addr + 0x800);
80108acb:	8b 45 f0             	mov    -0x10(%ebp),%eax
80108ace:	83 c0 01             	add    $0x1,%eax
80108ad1:	c1 e0 04             	shl    $0x4,%eax
80108ad4:	89 c2                	mov    %eax,%edx
80108ad6:	8b 45 d0             	mov    -0x30(%ebp),%eax
80108ad9:	01 d0                	add    %edx,%eax
80108adb:	8b 55 cc             	mov    -0x34(%ebp),%edx
80108ade:	81 ea 00 f8 ff 7f    	sub    $0x7ffff800,%edx
80108ae4:	89 10                	mov    %edx,(%eax)
  for(int i=0;i<(I8254_SEND_DESC_NUM)/2;i++){
80108ae6:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
80108aea:	83 7d f0 7f          	cmpl   $0x7f,-0x10(%ebp)
80108aee:	7e a3                	jle    80108a93 <i8254_init_send+0x141>
  }

  uint *tctl = (uint *)(base_addr + 0x400);
80108af0:	a1 7c 6c 19 80       	mov    0x80196c7c,%eax
80108af5:	05 00 04 00 00       	add    $0x400,%eax
80108afa:	89 45 c8             	mov    %eax,-0x38(%ebp)
  *tctl = (I8254_TCTL_EN | I8254_TCTL_PSP | I8254_TCTL_COLD | I8254_TCTL_CT);
80108afd:	8b 45 c8             	mov    -0x38(%ebp),%eax
80108b00:	c7 00 fa 00 04 00    	movl   $0x400fa,(%eax)

  uint *tipg = (uint *)(base_addr + 0x410);
80108b06:	a1 7c 6c 19 80       	mov    0x80196c7c,%eax
80108b0b:	05 10 04 00 00       	add    $0x410,%eax
80108b10:	89 45 c4             	mov    %eax,-0x3c(%ebp)
  *tipg = (10 | (10<<10) | (10<<20));
80108b13:	8b 45 c4             	mov    -0x3c(%ebp),%eax
80108b16:	c7 00 0a 28 a0 00    	movl   $0xa0280a,(%eax)
  cprintf("E1000 Transmit Initialize Done\n");
80108b1c:	83 ec 0c             	sub    $0xc,%esp
80108b1f:	68 58 c0 10 80       	push   $0x8010c058
80108b24:	e8 cb 78 ff ff       	call   801003f4 <cprintf>
80108b29:	83 c4 10             	add    $0x10,%esp

}
80108b2c:	90                   	nop
80108b2d:	c9                   	leave  
80108b2e:	c3                   	ret    

80108b2f <i8254_read_eeprom>:
uint i8254_read_eeprom(uint addr){
80108b2f:	55                   	push   %ebp
80108b30:	89 e5                	mov    %esp,%ebp
80108b32:	83 ec 18             	sub    $0x18,%esp
  uint *eerd = (uint *)(base_addr + 0x14);
80108b35:	a1 7c 6c 19 80       	mov    0x80196c7c,%eax
80108b3a:	83 c0 14             	add    $0x14,%eax
80108b3d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  *eerd = (((addr & 0xFF) << 8) | 1);
80108b40:	8b 45 08             	mov    0x8(%ebp),%eax
80108b43:	c1 e0 08             	shl    $0x8,%eax
80108b46:	0f b7 c0             	movzwl %ax,%eax
80108b49:	83 c8 01             	or     $0x1,%eax
80108b4c:	89 c2                	mov    %eax,%edx
80108b4e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108b51:	89 10                	mov    %edx,(%eax)
  while(1){
    cprintf("");
80108b53:	83 ec 0c             	sub    $0xc,%esp
80108b56:	68 78 c0 10 80       	push   $0x8010c078
80108b5b:	e8 94 78 ff ff       	call   801003f4 <cprintf>
80108b60:	83 c4 10             	add    $0x10,%esp
    volatile uint data = *eerd;
80108b63:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108b66:	8b 00                	mov    (%eax),%eax
80108b68:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if((data & (1<<4)) != 0){
80108b6b:	8b 45 f0             	mov    -0x10(%ebp),%eax
80108b6e:	83 e0 10             	and    $0x10,%eax
80108b71:	85 c0                	test   %eax,%eax
80108b73:	75 02                	jne    80108b77 <i8254_read_eeprom+0x48>
  while(1){
80108b75:	eb dc                	jmp    80108b53 <i8254_read_eeprom+0x24>
      break;
80108b77:	90                   	nop
    }
  }

  return (*eerd >> 16) & 0xFFFF;
80108b78:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108b7b:	8b 00                	mov    (%eax),%eax
80108b7d:	c1 e8 10             	shr    $0x10,%eax
}
80108b80:	c9                   	leave  
80108b81:	c3                   	ret    

80108b82 <i8254_recv>:
void i8254_recv(){
80108b82:	55                   	push   %ebp
80108b83:	89 e5                	mov    %esp,%ebp
80108b85:	83 ec 28             	sub    $0x28,%esp
  uint *rdh = (uint *)(base_addr + 0x2810);
80108b88:	a1 7c 6c 19 80       	mov    0x80196c7c,%eax
80108b8d:	05 10 28 00 00       	add    $0x2810,%eax
80108b92:	89 45 f4             	mov    %eax,-0xc(%ebp)
  uint *rdt = (uint *)(base_addr + 0x2818);
80108b95:	a1 7c 6c 19 80       	mov    0x80196c7c,%eax
80108b9a:	05 18 28 00 00       	add    $0x2818,%eax
80108b9f:	89 45 f0             	mov    %eax,-0x10(%ebp)
//  uint *torl = (uint *)(base_addr + 0x40C0);
//  uint *tpr = (uint *)(base_addr + 0x40D0);
//  uint *icr = (uint *)(base_addr + 0xC0);
  uint *rdbal = (uint *)(base_addr + 0x2800);
80108ba2:	a1 7c 6c 19 80       	mov    0x80196c7c,%eax
80108ba7:	05 00 28 00 00       	add    $0x2800,%eax
80108bac:	89 45 ec             	mov    %eax,-0x14(%ebp)
  struct i8254_recv_desc *recv_desc = (struct i8254_recv_desc *)(P2V(*rdbal));
80108baf:	8b 45 ec             	mov    -0x14(%ebp),%eax
80108bb2:	8b 00                	mov    (%eax),%eax
80108bb4:	05 00 00 00 80       	add    $0x80000000,%eax
80108bb9:	89 45 e8             	mov    %eax,-0x18(%ebp)
  while(1){
    int rx_available = (I8254_RECV_DESC_NUM - *rdt + *rdh)%I8254_RECV_DESC_NUM;
80108bbc:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108bbf:	8b 10                	mov    (%eax),%edx
80108bc1:	8b 45 f0             	mov    -0x10(%ebp),%eax
80108bc4:	8b 08                	mov    (%eax),%ecx
80108bc6:	89 d0                	mov    %edx,%eax
80108bc8:	29 c8                	sub    %ecx,%eax
80108bca:	25 ff 00 00 00       	and    $0xff,%eax
80108bcf:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(rx_available > 0){
80108bd2:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
80108bd6:	7e 37                	jle    80108c0f <i8254_recv+0x8d>
      uint buffer_addr = P2V_WO(recv_desc[*rdt].buf_addr);
80108bd8:	8b 45 f0             	mov    -0x10(%ebp),%eax
80108bdb:	8b 00                	mov    (%eax),%eax
80108bdd:	c1 e0 04             	shl    $0x4,%eax
80108be0:	89 c2                	mov    %eax,%edx
80108be2:	8b 45 e8             	mov    -0x18(%ebp),%eax
80108be5:	01 d0                	add    %edx,%eax
80108be7:	8b 00                	mov    (%eax),%eax
80108be9:	05 00 00 00 80       	add    $0x80000000,%eax
80108bee:	89 45 e0             	mov    %eax,-0x20(%ebp)
      *rdt = (*rdt + 1)%I8254_RECV_DESC_NUM;
80108bf1:	8b 45 f0             	mov    -0x10(%ebp),%eax
80108bf4:	8b 00                	mov    (%eax),%eax
80108bf6:	83 c0 01             	add    $0x1,%eax
80108bf9:	0f b6 d0             	movzbl %al,%edx
80108bfc:	8b 45 f0             	mov    -0x10(%ebp),%eax
80108bff:	89 10                	mov    %edx,(%eax)
      eth_proc(buffer_addr);
80108c01:	83 ec 0c             	sub    $0xc,%esp
80108c04:	ff 75 e0             	push   -0x20(%ebp)
80108c07:	e8 15 09 00 00       	call   80109521 <eth_proc>
80108c0c:	83 c4 10             	add    $0x10,%esp
    }
    if(*rdt == *rdh) {
80108c0f:	8b 45 f0             	mov    -0x10(%ebp),%eax
80108c12:	8b 10                	mov    (%eax),%edx
80108c14:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108c17:	8b 00                	mov    (%eax),%eax
80108c19:	39 c2                	cmp    %eax,%edx
80108c1b:	75 9f                	jne    80108bbc <i8254_recv+0x3a>
      (*rdt)--;
80108c1d:	8b 45 f0             	mov    -0x10(%ebp),%eax
80108c20:	8b 00                	mov    (%eax),%eax
80108c22:	8d 50 ff             	lea    -0x1(%eax),%edx
80108c25:	8b 45 f0             	mov    -0x10(%ebp),%eax
80108c28:	89 10                	mov    %edx,(%eax)
  while(1){
80108c2a:	eb 90                	jmp    80108bbc <i8254_recv+0x3a>

80108c2c <i8254_send>:
    }
  }
}

int i8254_send(const uint pkt_addr,uint len){
80108c2c:	55                   	push   %ebp
80108c2d:	89 e5                	mov    %esp,%ebp
80108c2f:	83 ec 28             	sub    $0x28,%esp
  uint *tdh = (uint *)(base_addr + 0x3810);
80108c32:	a1 7c 6c 19 80       	mov    0x80196c7c,%eax
80108c37:	05 10 38 00 00       	add    $0x3810,%eax
80108c3c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  uint *tdt = (uint *)(base_addr + 0x3818);
80108c3f:	a1 7c 6c 19 80       	mov    0x80196c7c,%eax
80108c44:	05 18 38 00 00       	add    $0x3818,%eax
80108c49:	89 45 f0             	mov    %eax,-0x10(%ebp)
  uint *tdbal = (uint *)(base_addr + 0x3800);
80108c4c:	a1 7c 6c 19 80       	mov    0x80196c7c,%eax
80108c51:	05 00 38 00 00       	add    $0x3800,%eax
80108c56:	89 45 ec             	mov    %eax,-0x14(%ebp)
  struct i8254_send_desc *txdesc = (struct i8254_send_desc *)P2V_WO(*tdbal);
80108c59:	8b 45 ec             	mov    -0x14(%ebp),%eax
80108c5c:	8b 00                	mov    (%eax),%eax
80108c5e:	05 00 00 00 80       	add    $0x80000000,%eax
80108c63:	89 45 e8             	mov    %eax,-0x18(%ebp)
  int tx_available = I8254_SEND_DESC_NUM - ((I8254_SEND_DESC_NUM - *tdh + *tdt) % I8254_SEND_DESC_NUM);
80108c66:	8b 45 f0             	mov    -0x10(%ebp),%eax
80108c69:	8b 10                	mov    (%eax),%edx
80108c6b:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108c6e:	8b 08                	mov    (%eax),%ecx
80108c70:	89 d0                	mov    %edx,%eax
80108c72:	29 c8                	sub    %ecx,%eax
80108c74:	0f b6 d0             	movzbl %al,%edx
80108c77:	b8 00 01 00 00       	mov    $0x100,%eax
80108c7c:	29 d0                	sub    %edx,%eax
80108c7e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  uint index = *tdt%I8254_SEND_DESC_NUM;
80108c81:	8b 45 f0             	mov    -0x10(%ebp),%eax
80108c84:	8b 00                	mov    (%eax),%eax
80108c86:	25 ff 00 00 00       	and    $0xff,%eax
80108c8b:	89 45 e0             	mov    %eax,-0x20(%ebp)
  if(tx_available > 0) {
80108c8e:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
80108c92:	0f 8e a8 00 00 00    	jle    80108d40 <i8254_send+0x114>
    memmove(P2V_WO((void *)txdesc[index].buf_addr),(void *)pkt_addr,len);
80108c98:	8b 45 08             	mov    0x8(%ebp),%eax
80108c9b:	8b 55 e0             	mov    -0x20(%ebp),%edx
80108c9e:	89 d1                	mov    %edx,%ecx
80108ca0:	c1 e1 04             	shl    $0x4,%ecx
80108ca3:	8b 55 e8             	mov    -0x18(%ebp),%edx
80108ca6:	01 ca                	add    %ecx,%edx
80108ca8:	8b 12                	mov    (%edx),%edx
80108caa:	81 c2 00 00 00 80    	add    $0x80000000,%edx
80108cb0:	83 ec 04             	sub    $0x4,%esp
80108cb3:	ff 75 0c             	push   0xc(%ebp)
80108cb6:	50                   	push   %eax
80108cb7:	52                   	push   %edx
80108cb8:	e8 52 bf ff ff       	call   80104c0f <memmove>
80108cbd:	83 c4 10             	add    $0x10,%esp
    txdesc[index].len = len;
80108cc0:	8b 45 e0             	mov    -0x20(%ebp),%eax
80108cc3:	c1 e0 04             	shl    $0x4,%eax
80108cc6:	89 c2                	mov    %eax,%edx
80108cc8:	8b 45 e8             	mov    -0x18(%ebp),%eax
80108ccb:	01 d0                	add    %edx,%eax
80108ccd:	8b 55 0c             	mov    0xc(%ebp),%edx
80108cd0:	66 89 50 08          	mov    %dx,0x8(%eax)
    txdesc[index].sta = 0;
80108cd4:	8b 45 e0             	mov    -0x20(%ebp),%eax
80108cd7:	c1 e0 04             	shl    $0x4,%eax
80108cda:	89 c2                	mov    %eax,%edx
80108cdc:	8b 45 e8             	mov    -0x18(%ebp),%eax
80108cdf:	01 d0                	add    %edx,%eax
80108ce1:	c6 40 0c 00          	movb   $0x0,0xc(%eax)
    txdesc[index].css = 0;
80108ce5:	8b 45 e0             	mov    -0x20(%ebp),%eax
80108ce8:	c1 e0 04             	shl    $0x4,%eax
80108ceb:	89 c2                	mov    %eax,%edx
80108ced:	8b 45 e8             	mov    -0x18(%ebp),%eax
80108cf0:	01 d0                	add    %edx,%eax
80108cf2:	c6 40 0d 00          	movb   $0x0,0xd(%eax)
    txdesc[index].cmd = 0xb;
80108cf6:	8b 45 e0             	mov    -0x20(%ebp),%eax
80108cf9:	c1 e0 04             	shl    $0x4,%eax
80108cfc:	89 c2                	mov    %eax,%edx
80108cfe:	8b 45 e8             	mov    -0x18(%ebp),%eax
80108d01:	01 d0                	add    %edx,%eax
80108d03:	c6 40 0b 0b          	movb   $0xb,0xb(%eax)
    txdesc[index].special = 0;
80108d07:	8b 45 e0             	mov    -0x20(%ebp),%eax
80108d0a:	c1 e0 04             	shl    $0x4,%eax
80108d0d:	89 c2                	mov    %eax,%edx
80108d0f:	8b 45 e8             	mov    -0x18(%ebp),%eax
80108d12:	01 d0                	add    %edx,%eax
80108d14:	66 c7 40 0e 00 00    	movw   $0x0,0xe(%eax)
    txdesc[index].cso = 0;
80108d1a:	8b 45 e0             	mov    -0x20(%ebp),%eax
80108d1d:	c1 e0 04             	shl    $0x4,%eax
80108d20:	89 c2                	mov    %eax,%edx
80108d22:	8b 45 e8             	mov    -0x18(%ebp),%eax
80108d25:	01 d0                	add    %edx,%eax
80108d27:	c6 40 0a 00          	movb   $0x0,0xa(%eax)
    *tdt = (*tdt + 1)%I8254_SEND_DESC_NUM;
80108d2b:	8b 45 f0             	mov    -0x10(%ebp),%eax
80108d2e:	8b 00                	mov    (%eax),%eax
80108d30:	83 c0 01             	add    $0x1,%eax
80108d33:	0f b6 d0             	movzbl %al,%edx
80108d36:	8b 45 f0             	mov    -0x10(%ebp),%eax
80108d39:	89 10                	mov    %edx,(%eax)
    return len;
80108d3b:	8b 45 0c             	mov    0xc(%ebp),%eax
80108d3e:	eb 05                	jmp    80108d45 <i8254_send+0x119>
  }else{
    return -1;
80108d40:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  }
  return 0;
}
80108d45:	c9                   	leave  
80108d46:	c3                   	ret    

80108d47 <i8254_intr>:

void i8254_intr(){
80108d47:	55                   	push   %ebp
80108d48:	89 e5                	mov    %esp,%ebp
  *intr_addr = 0xEEEEEE;
80108d4a:	a1 88 6c 19 80       	mov    0x80196c88,%eax
80108d4f:	c7 00 ee ee ee 00    	movl   $0xeeeeee,(%eax)
}
80108d55:	90                   	nop
80108d56:	5d                   	pop    %ebp
80108d57:	c3                   	ret    

80108d58 <arp_proc>:
extern uchar mac_addr[6];
extern uchar my_ip[4];

struct arp_entry arp_table[ARP_TABLE_MAX] = {0};

int arp_proc(uint buffer_addr){
80108d58:	55                   	push   %ebp
80108d59:	89 e5                	mov    %esp,%ebp
80108d5b:	83 ec 18             	sub    $0x18,%esp
  struct arp_pkt *arp_p = (struct arp_pkt *)(buffer_addr);
80108d5e:	8b 45 08             	mov    0x8(%ebp),%eax
80108d61:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(arp_p->hrd_type != ARP_HARDWARE_TYPE) return -1;
80108d64:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108d67:	0f b7 00             	movzwl (%eax),%eax
80108d6a:	66 3d 00 01          	cmp    $0x100,%ax
80108d6e:	74 0a                	je     80108d7a <arp_proc+0x22>
80108d70:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80108d75:	e9 4f 01 00 00       	jmp    80108ec9 <arp_proc+0x171>
  if(arp_p->pro_type != ARP_PROTOCOL_TYPE) return -1;
80108d7a:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108d7d:	0f b7 40 02          	movzwl 0x2(%eax),%eax
80108d81:	66 83 f8 08          	cmp    $0x8,%ax
80108d85:	74 0a                	je     80108d91 <arp_proc+0x39>
80108d87:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80108d8c:	e9 38 01 00 00       	jmp    80108ec9 <arp_proc+0x171>
  if(arp_p->hrd_len != 6) return -1;
80108d91:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108d94:	0f b6 40 04          	movzbl 0x4(%eax),%eax
80108d98:	3c 06                	cmp    $0x6,%al
80108d9a:	74 0a                	je     80108da6 <arp_proc+0x4e>
80108d9c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80108da1:	e9 23 01 00 00       	jmp    80108ec9 <arp_proc+0x171>
  if(arp_p->pro_len != 4) return -1;
80108da6:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108da9:	0f b6 40 05          	movzbl 0x5(%eax),%eax
80108dad:	3c 04                	cmp    $0x4,%al
80108daf:	74 0a                	je     80108dbb <arp_proc+0x63>
80108db1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80108db6:	e9 0e 01 00 00       	jmp    80108ec9 <arp_proc+0x171>
  if(memcmp(my_ip,arp_p->dst_ip,4) != 0 && memcmp(my_ip,arp_p->src_ip,4) != 0) return -1;
80108dbb:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108dbe:	83 c0 18             	add    $0x18,%eax
80108dc1:	83 ec 04             	sub    $0x4,%esp
80108dc4:	6a 04                	push   $0x4
80108dc6:	50                   	push   %eax
80108dc7:	68 e4 f4 10 80       	push   $0x8010f4e4
80108dcc:	e8 e6 bd ff ff       	call   80104bb7 <memcmp>
80108dd1:	83 c4 10             	add    $0x10,%esp
80108dd4:	85 c0                	test   %eax,%eax
80108dd6:	74 27                	je     80108dff <arp_proc+0xa7>
80108dd8:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108ddb:	83 c0 0e             	add    $0xe,%eax
80108dde:	83 ec 04             	sub    $0x4,%esp
80108de1:	6a 04                	push   $0x4
80108de3:	50                   	push   %eax
80108de4:	68 e4 f4 10 80       	push   $0x8010f4e4
80108de9:	e8 c9 bd ff ff       	call   80104bb7 <memcmp>
80108dee:	83 c4 10             	add    $0x10,%esp
80108df1:	85 c0                	test   %eax,%eax
80108df3:	74 0a                	je     80108dff <arp_proc+0xa7>
80108df5:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80108dfa:	e9 ca 00 00 00       	jmp    80108ec9 <arp_proc+0x171>
  if(arp_p->op == ARP_OPS_REQUEST && memcmp(my_ip,arp_p->dst_ip,4) == 0){
80108dff:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108e02:	0f b7 40 06          	movzwl 0x6(%eax),%eax
80108e06:	66 3d 00 01          	cmp    $0x100,%ax
80108e0a:	75 69                	jne    80108e75 <arp_proc+0x11d>
80108e0c:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108e0f:	83 c0 18             	add    $0x18,%eax
80108e12:	83 ec 04             	sub    $0x4,%esp
80108e15:	6a 04                	push   $0x4
80108e17:	50                   	push   %eax
80108e18:	68 e4 f4 10 80       	push   $0x8010f4e4
80108e1d:	e8 95 bd ff ff       	call   80104bb7 <memcmp>
80108e22:	83 c4 10             	add    $0x10,%esp
80108e25:	85 c0                	test   %eax,%eax
80108e27:	75 4c                	jne    80108e75 <arp_proc+0x11d>
    uint send = (uint)kalloc();
80108e29:	e8 72 99 ff ff       	call   801027a0 <kalloc>
80108e2e:	89 45 f0             	mov    %eax,-0x10(%ebp)
    uint send_size=0;
80108e31:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
    arp_reply_pkt_create(arp_p,send,&send_size);
80108e38:	83 ec 04             	sub    $0x4,%esp
80108e3b:	8d 45 ec             	lea    -0x14(%ebp),%eax
80108e3e:	50                   	push   %eax
80108e3f:	ff 75 f0             	push   -0x10(%ebp)
80108e42:	ff 75 f4             	push   -0xc(%ebp)
80108e45:	e8 1f 04 00 00       	call   80109269 <arp_reply_pkt_create>
80108e4a:	83 c4 10             	add    $0x10,%esp
    i8254_send(send,send_size);
80108e4d:	8b 45 ec             	mov    -0x14(%ebp),%eax
80108e50:	83 ec 08             	sub    $0x8,%esp
80108e53:	50                   	push   %eax
80108e54:	ff 75 f0             	push   -0x10(%ebp)
80108e57:	e8 d0 fd ff ff       	call   80108c2c <i8254_send>
80108e5c:	83 c4 10             	add    $0x10,%esp
    kfree((char *)send);
80108e5f:	8b 45 f0             	mov    -0x10(%ebp),%eax
80108e62:	83 ec 0c             	sub    $0xc,%esp
80108e65:	50                   	push   %eax
80108e66:	e8 9b 98 ff ff       	call   80102706 <kfree>
80108e6b:	83 c4 10             	add    $0x10,%esp
    return ARP_CREATED_REPLY;
80108e6e:	b8 02 00 00 00       	mov    $0x2,%eax
80108e73:	eb 54                	jmp    80108ec9 <arp_proc+0x171>
  }else if(arp_p->op == ARP_OPS_REPLY && memcmp(my_ip,arp_p->dst_ip,4) == 0){
80108e75:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108e78:	0f b7 40 06          	movzwl 0x6(%eax),%eax
80108e7c:	66 3d 00 02          	cmp    $0x200,%ax
80108e80:	75 42                	jne    80108ec4 <arp_proc+0x16c>
80108e82:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108e85:	83 c0 18             	add    $0x18,%eax
80108e88:	83 ec 04             	sub    $0x4,%esp
80108e8b:	6a 04                	push   $0x4
80108e8d:	50                   	push   %eax
80108e8e:	68 e4 f4 10 80       	push   $0x8010f4e4
80108e93:	e8 1f bd ff ff       	call   80104bb7 <memcmp>
80108e98:	83 c4 10             	add    $0x10,%esp
80108e9b:	85 c0                	test   %eax,%eax
80108e9d:	75 25                	jne    80108ec4 <arp_proc+0x16c>
    cprintf("ARP TABLE UPDATED\n");
80108e9f:	83 ec 0c             	sub    $0xc,%esp
80108ea2:	68 7c c0 10 80       	push   $0x8010c07c
80108ea7:	e8 48 75 ff ff       	call   801003f4 <cprintf>
80108eac:	83 c4 10             	add    $0x10,%esp
    arp_table_update(arp_p);
80108eaf:	83 ec 0c             	sub    $0xc,%esp
80108eb2:	ff 75 f4             	push   -0xc(%ebp)
80108eb5:	e8 af 01 00 00       	call   80109069 <arp_table_update>
80108eba:	83 c4 10             	add    $0x10,%esp
    return ARP_UPDATED_TABLE;
80108ebd:	b8 01 00 00 00       	mov    $0x1,%eax
80108ec2:	eb 05                	jmp    80108ec9 <arp_proc+0x171>
  }else{
    return -1;
80108ec4:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  }
}
80108ec9:	c9                   	leave  
80108eca:	c3                   	ret    

80108ecb <arp_scan>:

void arp_scan(){
80108ecb:	55                   	push   %ebp
80108ecc:	89 e5                	mov    %esp,%ebp
80108ece:	83 ec 18             	sub    $0x18,%esp
  uint send_size;
  for(int i=0;i<256;i++){
80108ed1:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80108ed8:	eb 6f                	jmp    80108f49 <arp_scan+0x7e>
    uint send = (uint)kalloc();
80108eda:	e8 c1 98 ff ff       	call   801027a0 <kalloc>
80108edf:	89 45 ec             	mov    %eax,-0x14(%ebp)
    arp_broadcast(send,&send_size,i);
80108ee2:	83 ec 04             	sub    $0x4,%esp
80108ee5:	ff 75 f4             	push   -0xc(%ebp)
80108ee8:	8d 45 e8             	lea    -0x18(%ebp),%eax
80108eeb:	50                   	push   %eax
80108eec:	ff 75 ec             	push   -0x14(%ebp)
80108eef:	e8 62 00 00 00       	call   80108f56 <arp_broadcast>
80108ef4:	83 c4 10             	add    $0x10,%esp
    uint res = i8254_send(send,send_size);
80108ef7:	8b 45 e8             	mov    -0x18(%ebp),%eax
80108efa:	83 ec 08             	sub    $0x8,%esp
80108efd:	50                   	push   %eax
80108efe:	ff 75 ec             	push   -0x14(%ebp)
80108f01:	e8 26 fd ff ff       	call   80108c2c <i8254_send>
80108f06:	83 c4 10             	add    $0x10,%esp
80108f09:	89 45 f0             	mov    %eax,-0x10(%ebp)
    while(res == -1){
80108f0c:	eb 22                	jmp    80108f30 <arp_scan+0x65>
      microdelay(1);
80108f0e:	83 ec 0c             	sub    $0xc,%esp
80108f11:	6a 01                	push   $0x1
80108f13:	e8 1f 9c ff ff       	call   80102b37 <microdelay>
80108f18:	83 c4 10             	add    $0x10,%esp
      res = i8254_send(send,send_size);
80108f1b:	8b 45 e8             	mov    -0x18(%ebp),%eax
80108f1e:	83 ec 08             	sub    $0x8,%esp
80108f21:	50                   	push   %eax
80108f22:	ff 75 ec             	push   -0x14(%ebp)
80108f25:	e8 02 fd ff ff       	call   80108c2c <i8254_send>
80108f2a:	83 c4 10             	add    $0x10,%esp
80108f2d:	89 45 f0             	mov    %eax,-0x10(%ebp)
    while(res == -1){
80108f30:	83 7d f0 ff          	cmpl   $0xffffffff,-0x10(%ebp)
80108f34:	74 d8                	je     80108f0e <arp_scan+0x43>
    }
    kfree((char *)send);
80108f36:	8b 45 ec             	mov    -0x14(%ebp),%eax
80108f39:	83 ec 0c             	sub    $0xc,%esp
80108f3c:	50                   	push   %eax
80108f3d:	e8 c4 97 ff ff       	call   80102706 <kfree>
80108f42:	83 c4 10             	add    $0x10,%esp
  for(int i=0;i<256;i++){
80108f45:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80108f49:	81 7d f4 ff 00 00 00 	cmpl   $0xff,-0xc(%ebp)
80108f50:	7e 88                	jle    80108eda <arp_scan+0xf>
  }
}
80108f52:	90                   	nop
80108f53:	90                   	nop
80108f54:	c9                   	leave  
80108f55:	c3                   	ret    

80108f56 <arp_broadcast>:

void arp_broadcast(uint send,uint *send_size,uint ip){
80108f56:	55                   	push   %ebp
80108f57:	89 e5                	mov    %esp,%ebp
80108f59:	83 ec 28             	sub    $0x28,%esp
  uchar dst_ip[4] = {10,0,1,ip};
80108f5c:	c6 45 ec 0a          	movb   $0xa,-0x14(%ebp)
80108f60:	c6 45 ed 00          	movb   $0x0,-0x13(%ebp)
80108f64:	c6 45 ee 01          	movb   $0x1,-0x12(%ebp)
80108f68:	8b 45 10             	mov    0x10(%ebp),%eax
80108f6b:	88 45 ef             	mov    %al,-0x11(%ebp)
  uchar dst_mac_eth[6] = {0xff,0xff,0xff,0xff,0xff,0xff};
80108f6e:	c7 45 e6 ff ff ff ff 	movl   $0xffffffff,-0x1a(%ebp)
80108f75:	66 c7 45 ea ff ff    	movw   $0xffff,-0x16(%ebp)
  uchar dst_mac_arp[6] = {0,0,0,0,0,0};
80108f7b:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
80108f82:	66 c7 45 e4 00 00    	movw   $0x0,-0x1c(%ebp)
  
  *send_size = sizeof(struct eth_pkt) + sizeof(struct arp_pkt);
80108f88:	8b 45 0c             	mov    0xc(%ebp),%eax
80108f8b:	c7 00 2c 00 00 00    	movl   $0x2c,(%eax)

  struct eth_pkt *reply_eth = (struct eth_pkt *)send;
80108f91:	8b 45 08             	mov    0x8(%ebp),%eax
80108f94:	89 45 f4             	mov    %eax,-0xc(%ebp)
  struct arp_pkt *reply_arp = (struct arp_pkt *)(send + sizeof(struct eth_pkt));
80108f97:	8b 45 08             	mov    0x8(%ebp),%eax
80108f9a:	83 c0 0e             	add    $0xe,%eax
80108f9d:	89 45 f0             	mov    %eax,-0x10(%ebp)
  
  reply_eth->type[0] = 0x08;
80108fa0:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108fa3:	c6 40 0c 08          	movb   $0x8,0xc(%eax)
  reply_eth->type[1] = 0x06;
80108fa7:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108faa:	c6 40 0d 06          	movb   $0x6,0xd(%eax)
  memmove(reply_eth->dst_mac,dst_mac_eth,6);
80108fae:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108fb1:	83 ec 04             	sub    $0x4,%esp
80108fb4:	6a 06                	push   $0x6
80108fb6:	8d 55 e6             	lea    -0x1a(%ebp),%edx
80108fb9:	52                   	push   %edx
80108fba:	50                   	push   %eax
80108fbb:	e8 4f bc ff ff       	call   80104c0f <memmove>
80108fc0:	83 c4 10             	add    $0x10,%esp
  memmove(reply_eth->src_mac,mac_addr,6);
80108fc3:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108fc6:	83 c0 06             	add    $0x6,%eax
80108fc9:	83 ec 04             	sub    $0x4,%esp
80108fcc:	6a 06                	push   $0x6
80108fce:	68 80 6c 19 80       	push   $0x80196c80
80108fd3:	50                   	push   %eax
80108fd4:	e8 36 bc ff ff       	call   80104c0f <memmove>
80108fd9:	83 c4 10             	add    $0x10,%esp

  reply_arp->hrd_type = ARP_HARDWARE_TYPE;
80108fdc:	8b 45 f0             	mov    -0x10(%ebp),%eax
80108fdf:	66 c7 00 00 01       	movw   $0x100,(%eax)
  reply_arp->pro_type = ARP_PROTOCOL_TYPE;
80108fe4:	8b 45 f0             	mov    -0x10(%ebp),%eax
80108fe7:	66 c7 40 02 08 00    	movw   $0x8,0x2(%eax)
  reply_arp->hrd_len = 6;
80108fed:	8b 45 f0             	mov    -0x10(%ebp),%eax
80108ff0:	c6 40 04 06          	movb   $0x6,0x4(%eax)
  reply_arp->pro_len = 4;
80108ff4:	8b 45 f0             	mov    -0x10(%ebp),%eax
80108ff7:	c6 40 05 04          	movb   $0x4,0x5(%eax)
  reply_arp->op = ARP_OPS_REQUEST;
80108ffb:	8b 45 f0             	mov    -0x10(%ebp),%eax
80108ffe:	66 c7 40 06 00 01    	movw   $0x100,0x6(%eax)
  memmove(reply_arp->dst_mac,dst_mac_arp,6);
80109004:	8b 45 f0             	mov    -0x10(%ebp),%eax
80109007:	8d 50 12             	lea    0x12(%eax),%edx
8010900a:	83 ec 04             	sub    $0x4,%esp
8010900d:	6a 06                	push   $0x6
8010900f:	8d 45 e0             	lea    -0x20(%ebp),%eax
80109012:	50                   	push   %eax
80109013:	52                   	push   %edx
80109014:	e8 f6 bb ff ff       	call   80104c0f <memmove>
80109019:	83 c4 10             	add    $0x10,%esp
  memmove(reply_arp->dst_ip,dst_ip,4);
8010901c:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010901f:	8d 50 18             	lea    0x18(%eax),%edx
80109022:	83 ec 04             	sub    $0x4,%esp
80109025:	6a 04                	push   $0x4
80109027:	8d 45 ec             	lea    -0x14(%ebp),%eax
8010902a:	50                   	push   %eax
8010902b:	52                   	push   %edx
8010902c:	e8 de bb ff ff       	call   80104c0f <memmove>
80109031:	83 c4 10             	add    $0x10,%esp
  memmove(reply_arp->src_mac,mac_addr,6);
80109034:	8b 45 f0             	mov    -0x10(%ebp),%eax
80109037:	83 c0 08             	add    $0x8,%eax
8010903a:	83 ec 04             	sub    $0x4,%esp
8010903d:	6a 06                	push   $0x6
8010903f:	68 80 6c 19 80       	push   $0x80196c80
80109044:	50                   	push   %eax
80109045:	e8 c5 bb ff ff       	call   80104c0f <memmove>
8010904a:	83 c4 10             	add    $0x10,%esp
  memmove(reply_arp->src_ip,my_ip,4);
8010904d:	8b 45 f0             	mov    -0x10(%ebp),%eax
80109050:	83 c0 0e             	add    $0xe,%eax
80109053:	83 ec 04             	sub    $0x4,%esp
80109056:	6a 04                	push   $0x4
80109058:	68 e4 f4 10 80       	push   $0x8010f4e4
8010905d:	50                   	push   %eax
8010905e:	e8 ac bb ff ff       	call   80104c0f <memmove>
80109063:	83 c4 10             	add    $0x10,%esp
}
80109066:	90                   	nop
80109067:	c9                   	leave  
80109068:	c3                   	ret    

80109069 <arp_table_update>:

void arp_table_update(struct arp_pkt *recv_arp){
80109069:	55                   	push   %ebp
8010906a:	89 e5                	mov    %esp,%ebp
8010906c:	83 ec 18             	sub    $0x18,%esp
  int index = arp_table_search(recv_arp->src_ip);
8010906f:	8b 45 08             	mov    0x8(%ebp),%eax
80109072:	83 c0 0e             	add    $0xe,%eax
80109075:	83 ec 0c             	sub    $0xc,%esp
80109078:	50                   	push   %eax
80109079:	e8 bc 00 00 00       	call   8010913a <arp_table_search>
8010907e:	83 c4 10             	add    $0x10,%esp
80109081:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(index > -1){
80109084:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80109088:	78 2d                	js     801090b7 <arp_table_update+0x4e>
    memmove(arp_table[index].mac,recv_arp->src_mac,6);
8010908a:	8b 45 08             	mov    0x8(%ebp),%eax
8010908d:	8d 48 08             	lea    0x8(%eax),%ecx
80109090:	8b 55 f4             	mov    -0xc(%ebp),%edx
80109093:	89 d0                	mov    %edx,%eax
80109095:	c1 e0 02             	shl    $0x2,%eax
80109098:	01 d0                	add    %edx,%eax
8010909a:	01 c0                	add    %eax,%eax
8010909c:	01 d0                	add    %edx,%eax
8010909e:	05 a0 6c 19 80       	add    $0x80196ca0,%eax
801090a3:	83 c0 04             	add    $0x4,%eax
801090a6:	83 ec 04             	sub    $0x4,%esp
801090a9:	6a 06                	push   $0x6
801090ab:	51                   	push   %ecx
801090ac:	50                   	push   %eax
801090ad:	e8 5d bb ff ff       	call   80104c0f <memmove>
801090b2:	83 c4 10             	add    $0x10,%esp
801090b5:	eb 70                	jmp    80109127 <arp_table_update+0xbe>
  }else{
    index += 1;
801090b7:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
    index = -index;
801090bb:	f7 5d f4             	negl   -0xc(%ebp)
    memmove(arp_table[index].mac,recv_arp->src_mac,6);
801090be:	8b 45 08             	mov    0x8(%ebp),%eax
801090c1:	8d 48 08             	lea    0x8(%eax),%ecx
801090c4:	8b 55 f4             	mov    -0xc(%ebp),%edx
801090c7:	89 d0                	mov    %edx,%eax
801090c9:	c1 e0 02             	shl    $0x2,%eax
801090cc:	01 d0                	add    %edx,%eax
801090ce:	01 c0                	add    %eax,%eax
801090d0:	01 d0                	add    %edx,%eax
801090d2:	05 a0 6c 19 80       	add    $0x80196ca0,%eax
801090d7:	83 c0 04             	add    $0x4,%eax
801090da:	83 ec 04             	sub    $0x4,%esp
801090dd:	6a 06                	push   $0x6
801090df:	51                   	push   %ecx
801090e0:	50                   	push   %eax
801090e1:	e8 29 bb ff ff       	call   80104c0f <memmove>
801090e6:	83 c4 10             	add    $0x10,%esp
    memmove(arp_table[index].ip,recv_arp->src_ip,4);
801090e9:	8b 45 08             	mov    0x8(%ebp),%eax
801090ec:	8d 48 0e             	lea    0xe(%eax),%ecx
801090ef:	8b 55 f4             	mov    -0xc(%ebp),%edx
801090f2:	89 d0                	mov    %edx,%eax
801090f4:	c1 e0 02             	shl    $0x2,%eax
801090f7:	01 d0                	add    %edx,%eax
801090f9:	01 c0                	add    %eax,%eax
801090fb:	01 d0                	add    %edx,%eax
801090fd:	05 a0 6c 19 80       	add    $0x80196ca0,%eax
80109102:	83 ec 04             	sub    $0x4,%esp
80109105:	6a 04                	push   $0x4
80109107:	51                   	push   %ecx
80109108:	50                   	push   %eax
80109109:	e8 01 bb ff ff       	call   80104c0f <memmove>
8010910e:	83 c4 10             	add    $0x10,%esp
    arp_table[index].use = 1;
80109111:	8b 55 f4             	mov    -0xc(%ebp),%edx
80109114:	89 d0                	mov    %edx,%eax
80109116:	c1 e0 02             	shl    $0x2,%eax
80109119:	01 d0                	add    %edx,%eax
8010911b:	01 c0                	add    %eax,%eax
8010911d:	01 d0                	add    %edx,%eax
8010911f:	05 aa 6c 19 80       	add    $0x80196caa,%eax
80109124:	c6 00 01             	movb   $0x1,(%eax)
  }
  print_arp_table(arp_table);
80109127:	83 ec 0c             	sub    $0xc,%esp
8010912a:	68 a0 6c 19 80       	push   $0x80196ca0
8010912f:	e8 83 00 00 00       	call   801091b7 <print_arp_table>
80109134:	83 c4 10             	add    $0x10,%esp
}
80109137:	90                   	nop
80109138:	c9                   	leave  
80109139:	c3                   	ret    

8010913a <arp_table_search>:

int arp_table_search(uchar *ip){
8010913a:	55                   	push   %ebp
8010913b:	89 e5                	mov    %esp,%ebp
8010913d:	83 ec 18             	sub    $0x18,%esp
  int empty=1;
80109140:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
  for(int i=0;i<ARP_TABLE_MAX;i++){
80109147:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
8010914e:	eb 59                	jmp    801091a9 <arp_table_search+0x6f>
    if(memcmp(arp_table[i].ip,ip,4) == 0){
80109150:	8b 55 f0             	mov    -0x10(%ebp),%edx
80109153:	89 d0                	mov    %edx,%eax
80109155:	c1 e0 02             	shl    $0x2,%eax
80109158:	01 d0                	add    %edx,%eax
8010915a:	01 c0                	add    %eax,%eax
8010915c:	01 d0                	add    %edx,%eax
8010915e:	05 a0 6c 19 80       	add    $0x80196ca0,%eax
80109163:	83 ec 04             	sub    $0x4,%esp
80109166:	6a 04                	push   $0x4
80109168:	ff 75 08             	push   0x8(%ebp)
8010916b:	50                   	push   %eax
8010916c:	e8 46 ba ff ff       	call   80104bb7 <memcmp>
80109171:	83 c4 10             	add    $0x10,%esp
80109174:	85 c0                	test   %eax,%eax
80109176:	75 05                	jne    8010917d <arp_table_search+0x43>
      return i;
80109178:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010917b:	eb 38                	jmp    801091b5 <arp_table_search+0x7b>
    }
    if(arp_table[i].use == 0 && empty == 1){
8010917d:	8b 55 f0             	mov    -0x10(%ebp),%edx
80109180:	89 d0                	mov    %edx,%eax
80109182:	c1 e0 02             	shl    $0x2,%eax
80109185:	01 d0                	add    %edx,%eax
80109187:	01 c0                	add    %eax,%eax
80109189:	01 d0                	add    %edx,%eax
8010918b:	05 aa 6c 19 80       	add    $0x80196caa,%eax
80109190:	0f b6 00             	movzbl (%eax),%eax
80109193:	84 c0                	test   %al,%al
80109195:	75 0e                	jne    801091a5 <arp_table_search+0x6b>
80109197:	83 7d f4 01          	cmpl   $0x1,-0xc(%ebp)
8010919b:	75 08                	jne    801091a5 <arp_table_search+0x6b>
      empty = -i;
8010919d:	8b 45 f0             	mov    -0x10(%ebp),%eax
801091a0:	f7 d8                	neg    %eax
801091a2:	89 45 f4             	mov    %eax,-0xc(%ebp)
  for(int i=0;i<ARP_TABLE_MAX;i++){
801091a5:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
801091a9:	83 7d f0 3f          	cmpl   $0x3f,-0x10(%ebp)
801091ad:	7e a1                	jle    80109150 <arp_table_search+0x16>
    }
  }
  return empty-1;
801091af:	8b 45 f4             	mov    -0xc(%ebp),%eax
801091b2:	83 e8 01             	sub    $0x1,%eax
}
801091b5:	c9                   	leave  
801091b6:	c3                   	ret    

801091b7 <print_arp_table>:

void print_arp_table(){
801091b7:	55                   	push   %ebp
801091b8:	89 e5                	mov    %esp,%ebp
801091ba:	83 ec 18             	sub    $0x18,%esp
  for(int i=0;i < ARP_TABLE_MAX;i++){
801091bd:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
801091c4:	e9 92 00 00 00       	jmp    8010925b <print_arp_table+0xa4>
    if(arp_table[i].use != 0){
801091c9:	8b 55 f4             	mov    -0xc(%ebp),%edx
801091cc:	89 d0                	mov    %edx,%eax
801091ce:	c1 e0 02             	shl    $0x2,%eax
801091d1:	01 d0                	add    %edx,%eax
801091d3:	01 c0                	add    %eax,%eax
801091d5:	01 d0                	add    %edx,%eax
801091d7:	05 aa 6c 19 80       	add    $0x80196caa,%eax
801091dc:	0f b6 00             	movzbl (%eax),%eax
801091df:	84 c0                	test   %al,%al
801091e1:	74 74                	je     80109257 <print_arp_table+0xa0>
      cprintf("Entry Num: %d ",i);
801091e3:	83 ec 08             	sub    $0x8,%esp
801091e6:	ff 75 f4             	push   -0xc(%ebp)
801091e9:	68 8f c0 10 80       	push   $0x8010c08f
801091ee:	e8 01 72 ff ff       	call   801003f4 <cprintf>
801091f3:	83 c4 10             	add    $0x10,%esp
      print_ipv4(arp_table[i].ip);
801091f6:	8b 55 f4             	mov    -0xc(%ebp),%edx
801091f9:	89 d0                	mov    %edx,%eax
801091fb:	c1 e0 02             	shl    $0x2,%eax
801091fe:	01 d0                	add    %edx,%eax
80109200:	01 c0                	add    %eax,%eax
80109202:	01 d0                	add    %edx,%eax
80109204:	05 a0 6c 19 80       	add    $0x80196ca0,%eax
80109209:	83 ec 0c             	sub    $0xc,%esp
8010920c:	50                   	push   %eax
8010920d:	e8 54 02 00 00       	call   80109466 <print_ipv4>
80109212:	83 c4 10             	add    $0x10,%esp
      cprintf(" ");
80109215:	83 ec 0c             	sub    $0xc,%esp
80109218:	68 9e c0 10 80       	push   $0x8010c09e
8010921d:	e8 d2 71 ff ff       	call   801003f4 <cprintf>
80109222:	83 c4 10             	add    $0x10,%esp
      print_mac(arp_table[i].mac);
80109225:	8b 55 f4             	mov    -0xc(%ebp),%edx
80109228:	89 d0                	mov    %edx,%eax
8010922a:	c1 e0 02             	shl    $0x2,%eax
8010922d:	01 d0                	add    %edx,%eax
8010922f:	01 c0                	add    %eax,%eax
80109231:	01 d0                	add    %edx,%eax
80109233:	05 a0 6c 19 80       	add    $0x80196ca0,%eax
80109238:	83 c0 04             	add    $0x4,%eax
8010923b:	83 ec 0c             	sub    $0xc,%esp
8010923e:	50                   	push   %eax
8010923f:	e8 70 02 00 00       	call   801094b4 <print_mac>
80109244:	83 c4 10             	add    $0x10,%esp
      cprintf("\n");
80109247:	83 ec 0c             	sub    $0xc,%esp
8010924a:	68 a0 c0 10 80       	push   $0x8010c0a0
8010924f:	e8 a0 71 ff ff       	call   801003f4 <cprintf>
80109254:	83 c4 10             	add    $0x10,%esp
  for(int i=0;i < ARP_TABLE_MAX;i++){
80109257:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
8010925b:	83 7d f4 3f          	cmpl   $0x3f,-0xc(%ebp)
8010925f:	0f 8e 64 ff ff ff    	jle    801091c9 <print_arp_table+0x12>
    }
  }
}
80109265:	90                   	nop
80109266:	90                   	nop
80109267:	c9                   	leave  
80109268:	c3                   	ret    

80109269 <arp_reply_pkt_create>:


void arp_reply_pkt_create(struct arp_pkt *arp_recv,uint send,uint *send_size){
80109269:	55                   	push   %ebp
8010926a:	89 e5                	mov    %esp,%ebp
8010926c:	83 ec 18             	sub    $0x18,%esp
  *send_size = sizeof(struct eth_pkt) + sizeof(struct arp_pkt);
8010926f:	8b 45 10             	mov    0x10(%ebp),%eax
80109272:	c7 00 2c 00 00 00    	movl   $0x2c,(%eax)
  
  struct eth_pkt *reply_eth = (struct eth_pkt *)send;
80109278:	8b 45 0c             	mov    0xc(%ebp),%eax
8010927b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  struct arp_pkt *reply_arp = (struct arp_pkt *)(send + sizeof(struct eth_pkt));
8010927e:	8b 45 0c             	mov    0xc(%ebp),%eax
80109281:	83 c0 0e             	add    $0xe,%eax
80109284:	89 45 f0             	mov    %eax,-0x10(%ebp)

  reply_eth->type[0] = 0x08;
80109287:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010928a:	c6 40 0c 08          	movb   $0x8,0xc(%eax)
  reply_eth->type[1] = 0x06;
8010928e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80109291:	c6 40 0d 06          	movb   $0x6,0xd(%eax)
  memmove(reply_eth->dst_mac,arp_recv->src_mac,6);
80109295:	8b 45 08             	mov    0x8(%ebp),%eax
80109298:	8d 50 08             	lea    0x8(%eax),%edx
8010929b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010929e:	83 ec 04             	sub    $0x4,%esp
801092a1:	6a 06                	push   $0x6
801092a3:	52                   	push   %edx
801092a4:	50                   	push   %eax
801092a5:	e8 65 b9 ff ff       	call   80104c0f <memmove>
801092aa:	83 c4 10             	add    $0x10,%esp
  memmove(reply_eth->src_mac,mac_addr,6);
801092ad:	8b 45 f4             	mov    -0xc(%ebp),%eax
801092b0:	83 c0 06             	add    $0x6,%eax
801092b3:	83 ec 04             	sub    $0x4,%esp
801092b6:	6a 06                	push   $0x6
801092b8:	68 80 6c 19 80       	push   $0x80196c80
801092bd:	50                   	push   %eax
801092be:	e8 4c b9 ff ff       	call   80104c0f <memmove>
801092c3:	83 c4 10             	add    $0x10,%esp

  reply_arp->hrd_type = ARP_HARDWARE_TYPE;
801092c6:	8b 45 f0             	mov    -0x10(%ebp),%eax
801092c9:	66 c7 00 00 01       	movw   $0x100,(%eax)
  reply_arp->pro_type = ARP_PROTOCOL_TYPE;
801092ce:	8b 45 f0             	mov    -0x10(%ebp),%eax
801092d1:	66 c7 40 02 08 00    	movw   $0x8,0x2(%eax)
  reply_arp->hrd_len = 6;
801092d7:	8b 45 f0             	mov    -0x10(%ebp),%eax
801092da:	c6 40 04 06          	movb   $0x6,0x4(%eax)
  reply_arp->pro_len = 4;
801092de:	8b 45 f0             	mov    -0x10(%ebp),%eax
801092e1:	c6 40 05 04          	movb   $0x4,0x5(%eax)
  reply_arp->op = ARP_OPS_REPLY;
801092e5:	8b 45 f0             	mov    -0x10(%ebp),%eax
801092e8:	66 c7 40 06 00 02    	movw   $0x200,0x6(%eax)
  memmove(reply_arp->dst_mac,arp_recv->src_mac,6);
801092ee:	8b 45 08             	mov    0x8(%ebp),%eax
801092f1:	8d 50 08             	lea    0x8(%eax),%edx
801092f4:	8b 45 f0             	mov    -0x10(%ebp),%eax
801092f7:	83 c0 12             	add    $0x12,%eax
801092fa:	83 ec 04             	sub    $0x4,%esp
801092fd:	6a 06                	push   $0x6
801092ff:	52                   	push   %edx
80109300:	50                   	push   %eax
80109301:	e8 09 b9 ff ff       	call   80104c0f <memmove>
80109306:	83 c4 10             	add    $0x10,%esp
  memmove(reply_arp->dst_ip,arp_recv->src_ip,4);
80109309:	8b 45 08             	mov    0x8(%ebp),%eax
8010930c:	8d 50 0e             	lea    0xe(%eax),%edx
8010930f:	8b 45 f0             	mov    -0x10(%ebp),%eax
80109312:	83 c0 18             	add    $0x18,%eax
80109315:	83 ec 04             	sub    $0x4,%esp
80109318:	6a 04                	push   $0x4
8010931a:	52                   	push   %edx
8010931b:	50                   	push   %eax
8010931c:	e8 ee b8 ff ff       	call   80104c0f <memmove>
80109321:	83 c4 10             	add    $0x10,%esp
  memmove(reply_arp->src_mac,mac_addr,6);
80109324:	8b 45 f0             	mov    -0x10(%ebp),%eax
80109327:	83 c0 08             	add    $0x8,%eax
8010932a:	83 ec 04             	sub    $0x4,%esp
8010932d:	6a 06                	push   $0x6
8010932f:	68 80 6c 19 80       	push   $0x80196c80
80109334:	50                   	push   %eax
80109335:	e8 d5 b8 ff ff       	call   80104c0f <memmove>
8010933a:	83 c4 10             	add    $0x10,%esp
  memmove(reply_arp->src_ip,my_ip,4);
8010933d:	8b 45 f0             	mov    -0x10(%ebp),%eax
80109340:	83 c0 0e             	add    $0xe,%eax
80109343:	83 ec 04             	sub    $0x4,%esp
80109346:	6a 04                	push   $0x4
80109348:	68 e4 f4 10 80       	push   $0x8010f4e4
8010934d:	50                   	push   %eax
8010934e:	e8 bc b8 ff ff       	call   80104c0f <memmove>
80109353:	83 c4 10             	add    $0x10,%esp
}
80109356:	90                   	nop
80109357:	c9                   	leave  
80109358:	c3                   	ret    

80109359 <print_arp_info>:

void print_arp_info(struct arp_pkt* arp_p){
80109359:	55                   	push   %ebp
8010935a:	89 e5                	mov    %esp,%ebp
8010935c:	83 ec 08             	sub    $0x8,%esp
  cprintf("--------Source-------\n");
8010935f:	83 ec 0c             	sub    $0xc,%esp
80109362:	68 a2 c0 10 80       	push   $0x8010c0a2
80109367:	e8 88 70 ff ff       	call   801003f4 <cprintf>
8010936c:	83 c4 10             	add    $0x10,%esp
  print_ipv4(arp_p->src_ip);
8010936f:	8b 45 08             	mov    0x8(%ebp),%eax
80109372:	83 c0 0e             	add    $0xe,%eax
80109375:	83 ec 0c             	sub    $0xc,%esp
80109378:	50                   	push   %eax
80109379:	e8 e8 00 00 00       	call   80109466 <print_ipv4>
8010937e:	83 c4 10             	add    $0x10,%esp
  cprintf("\n");
80109381:	83 ec 0c             	sub    $0xc,%esp
80109384:	68 a0 c0 10 80       	push   $0x8010c0a0
80109389:	e8 66 70 ff ff       	call   801003f4 <cprintf>
8010938e:	83 c4 10             	add    $0x10,%esp
  print_mac(arp_p->src_mac);
80109391:	8b 45 08             	mov    0x8(%ebp),%eax
80109394:	83 c0 08             	add    $0x8,%eax
80109397:	83 ec 0c             	sub    $0xc,%esp
8010939a:	50                   	push   %eax
8010939b:	e8 14 01 00 00       	call   801094b4 <print_mac>
801093a0:	83 c4 10             	add    $0x10,%esp
  cprintf("\n");
801093a3:	83 ec 0c             	sub    $0xc,%esp
801093a6:	68 a0 c0 10 80       	push   $0x8010c0a0
801093ab:	e8 44 70 ff ff       	call   801003f4 <cprintf>
801093b0:	83 c4 10             	add    $0x10,%esp
  cprintf("-----Destination-----\n");
801093b3:	83 ec 0c             	sub    $0xc,%esp
801093b6:	68 b9 c0 10 80       	push   $0x8010c0b9
801093bb:	e8 34 70 ff ff       	call   801003f4 <cprintf>
801093c0:	83 c4 10             	add    $0x10,%esp
  print_ipv4(arp_p->dst_ip);
801093c3:	8b 45 08             	mov    0x8(%ebp),%eax
801093c6:	83 c0 18             	add    $0x18,%eax
801093c9:	83 ec 0c             	sub    $0xc,%esp
801093cc:	50                   	push   %eax
801093cd:	e8 94 00 00 00       	call   80109466 <print_ipv4>
801093d2:	83 c4 10             	add    $0x10,%esp
  cprintf("\n");
801093d5:	83 ec 0c             	sub    $0xc,%esp
801093d8:	68 a0 c0 10 80       	push   $0x8010c0a0
801093dd:	e8 12 70 ff ff       	call   801003f4 <cprintf>
801093e2:	83 c4 10             	add    $0x10,%esp
  print_mac(arp_p->dst_mac);
801093e5:	8b 45 08             	mov    0x8(%ebp),%eax
801093e8:	83 c0 12             	add    $0x12,%eax
801093eb:	83 ec 0c             	sub    $0xc,%esp
801093ee:	50                   	push   %eax
801093ef:	e8 c0 00 00 00       	call   801094b4 <print_mac>
801093f4:	83 c4 10             	add    $0x10,%esp
  cprintf("\n");
801093f7:	83 ec 0c             	sub    $0xc,%esp
801093fa:	68 a0 c0 10 80       	push   $0x8010c0a0
801093ff:	e8 f0 6f ff ff       	call   801003f4 <cprintf>
80109404:	83 c4 10             	add    $0x10,%esp
  cprintf("Operation: ");
80109407:	83 ec 0c             	sub    $0xc,%esp
8010940a:	68 d0 c0 10 80       	push   $0x8010c0d0
8010940f:	e8 e0 6f ff ff       	call   801003f4 <cprintf>
80109414:	83 c4 10             	add    $0x10,%esp
  if(arp_p->op == ARP_OPS_REQUEST) cprintf("Request\n");
80109417:	8b 45 08             	mov    0x8(%ebp),%eax
8010941a:	0f b7 40 06          	movzwl 0x6(%eax),%eax
8010941e:	66 3d 00 01          	cmp    $0x100,%ax
80109422:	75 12                	jne    80109436 <print_arp_info+0xdd>
80109424:	83 ec 0c             	sub    $0xc,%esp
80109427:	68 dc c0 10 80       	push   $0x8010c0dc
8010942c:	e8 c3 6f ff ff       	call   801003f4 <cprintf>
80109431:	83 c4 10             	add    $0x10,%esp
80109434:	eb 1d                	jmp    80109453 <print_arp_info+0xfa>
  else if(arp_p->op == ARP_OPS_REPLY) {
80109436:	8b 45 08             	mov    0x8(%ebp),%eax
80109439:	0f b7 40 06          	movzwl 0x6(%eax),%eax
8010943d:	66 3d 00 02          	cmp    $0x200,%ax
80109441:	75 10                	jne    80109453 <print_arp_info+0xfa>
    cprintf("Reply\n");
80109443:	83 ec 0c             	sub    $0xc,%esp
80109446:	68 e5 c0 10 80       	push   $0x8010c0e5
8010944b:	e8 a4 6f ff ff       	call   801003f4 <cprintf>
80109450:	83 c4 10             	add    $0x10,%esp
  }
  cprintf("\n");
80109453:	83 ec 0c             	sub    $0xc,%esp
80109456:	68 a0 c0 10 80       	push   $0x8010c0a0
8010945b:	e8 94 6f ff ff       	call   801003f4 <cprintf>
80109460:	83 c4 10             	add    $0x10,%esp
}
80109463:	90                   	nop
80109464:	c9                   	leave  
80109465:	c3                   	ret    

80109466 <print_ipv4>:

void print_ipv4(uchar *ip){
80109466:	55                   	push   %ebp
80109467:	89 e5                	mov    %esp,%ebp
80109469:	53                   	push   %ebx
8010946a:	83 ec 04             	sub    $0x4,%esp
  cprintf("IP address: %d.%d.%d.%d",ip[0],ip[1],ip[2],ip[3]);
8010946d:	8b 45 08             	mov    0x8(%ebp),%eax
80109470:	83 c0 03             	add    $0x3,%eax
80109473:	0f b6 00             	movzbl (%eax),%eax
80109476:	0f b6 d8             	movzbl %al,%ebx
80109479:	8b 45 08             	mov    0x8(%ebp),%eax
8010947c:	83 c0 02             	add    $0x2,%eax
8010947f:	0f b6 00             	movzbl (%eax),%eax
80109482:	0f b6 c8             	movzbl %al,%ecx
80109485:	8b 45 08             	mov    0x8(%ebp),%eax
80109488:	83 c0 01             	add    $0x1,%eax
8010948b:	0f b6 00             	movzbl (%eax),%eax
8010948e:	0f b6 d0             	movzbl %al,%edx
80109491:	8b 45 08             	mov    0x8(%ebp),%eax
80109494:	0f b6 00             	movzbl (%eax),%eax
80109497:	0f b6 c0             	movzbl %al,%eax
8010949a:	83 ec 0c             	sub    $0xc,%esp
8010949d:	53                   	push   %ebx
8010949e:	51                   	push   %ecx
8010949f:	52                   	push   %edx
801094a0:	50                   	push   %eax
801094a1:	68 ec c0 10 80       	push   $0x8010c0ec
801094a6:	e8 49 6f ff ff       	call   801003f4 <cprintf>
801094ab:	83 c4 20             	add    $0x20,%esp
}
801094ae:	90                   	nop
801094af:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801094b2:	c9                   	leave  
801094b3:	c3                   	ret    

801094b4 <print_mac>:

void print_mac(uchar *mac){
801094b4:	55                   	push   %ebp
801094b5:	89 e5                	mov    %esp,%ebp
801094b7:	57                   	push   %edi
801094b8:	56                   	push   %esi
801094b9:	53                   	push   %ebx
801094ba:	83 ec 0c             	sub    $0xc,%esp
  cprintf("MAC address: %x:%x:%x:%x:%x:%x",mac[0],mac[1],mac[2],mac[3],mac[4],mac[5]);
801094bd:	8b 45 08             	mov    0x8(%ebp),%eax
801094c0:	83 c0 05             	add    $0x5,%eax
801094c3:	0f b6 00             	movzbl (%eax),%eax
801094c6:	0f b6 f8             	movzbl %al,%edi
801094c9:	8b 45 08             	mov    0x8(%ebp),%eax
801094cc:	83 c0 04             	add    $0x4,%eax
801094cf:	0f b6 00             	movzbl (%eax),%eax
801094d2:	0f b6 f0             	movzbl %al,%esi
801094d5:	8b 45 08             	mov    0x8(%ebp),%eax
801094d8:	83 c0 03             	add    $0x3,%eax
801094db:	0f b6 00             	movzbl (%eax),%eax
801094de:	0f b6 d8             	movzbl %al,%ebx
801094e1:	8b 45 08             	mov    0x8(%ebp),%eax
801094e4:	83 c0 02             	add    $0x2,%eax
801094e7:	0f b6 00             	movzbl (%eax),%eax
801094ea:	0f b6 c8             	movzbl %al,%ecx
801094ed:	8b 45 08             	mov    0x8(%ebp),%eax
801094f0:	83 c0 01             	add    $0x1,%eax
801094f3:	0f b6 00             	movzbl (%eax),%eax
801094f6:	0f b6 d0             	movzbl %al,%edx
801094f9:	8b 45 08             	mov    0x8(%ebp),%eax
801094fc:	0f b6 00             	movzbl (%eax),%eax
801094ff:	0f b6 c0             	movzbl %al,%eax
80109502:	83 ec 04             	sub    $0x4,%esp
80109505:	57                   	push   %edi
80109506:	56                   	push   %esi
80109507:	53                   	push   %ebx
80109508:	51                   	push   %ecx
80109509:	52                   	push   %edx
8010950a:	50                   	push   %eax
8010950b:	68 04 c1 10 80       	push   $0x8010c104
80109510:	e8 df 6e ff ff       	call   801003f4 <cprintf>
80109515:	83 c4 20             	add    $0x20,%esp
}
80109518:	90                   	nop
80109519:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010951c:	5b                   	pop    %ebx
8010951d:	5e                   	pop    %esi
8010951e:	5f                   	pop    %edi
8010951f:	5d                   	pop    %ebp
80109520:	c3                   	ret    

80109521 <eth_proc>:
#include "arp.h"
#include "types.h"
#include "eth.h"
#include "defs.h"
#include "ipv4.h"
void eth_proc(uint buffer_addr){
80109521:	55                   	push   %ebp
80109522:	89 e5                	mov    %esp,%ebp
80109524:	83 ec 18             	sub    $0x18,%esp
  struct eth_pkt *eth_pkt = (struct eth_pkt *)buffer_addr;
80109527:	8b 45 08             	mov    0x8(%ebp),%eax
8010952a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  uint pkt_addr = buffer_addr+sizeof(struct eth_pkt);
8010952d:	8b 45 08             	mov    0x8(%ebp),%eax
80109530:	83 c0 0e             	add    $0xe,%eax
80109533:	89 45 f0             	mov    %eax,-0x10(%ebp)
  if(eth_pkt->type[0] == 0x08 && eth_pkt->type[1] == 0x06){
80109536:	8b 45 f4             	mov    -0xc(%ebp),%eax
80109539:	0f b6 40 0c          	movzbl 0xc(%eax),%eax
8010953d:	3c 08                	cmp    $0x8,%al
8010953f:	75 1b                	jne    8010955c <eth_proc+0x3b>
80109541:	8b 45 f4             	mov    -0xc(%ebp),%eax
80109544:	0f b6 40 0d          	movzbl 0xd(%eax),%eax
80109548:	3c 06                	cmp    $0x6,%al
8010954a:	75 10                	jne    8010955c <eth_proc+0x3b>
    arp_proc(pkt_addr);
8010954c:	83 ec 0c             	sub    $0xc,%esp
8010954f:	ff 75 f0             	push   -0x10(%ebp)
80109552:	e8 01 f8 ff ff       	call   80108d58 <arp_proc>
80109557:	83 c4 10             	add    $0x10,%esp
  }else if(eth_pkt->type[0] == 0x08 && eth_pkt->type[1] == 0x00){
    ipv4_proc(buffer_addr);
  }else{
  }
}
8010955a:	eb 24                	jmp    80109580 <eth_proc+0x5f>
  }else if(eth_pkt->type[0] == 0x08 && eth_pkt->type[1] == 0x00){
8010955c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010955f:	0f b6 40 0c          	movzbl 0xc(%eax),%eax
80109563:	3c 08                	cmp    $0x8,%al
80109565:	75 19                	jne    80109580 <eth_proc+0x5f>
80109567:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010956a:	0f b6 40 0d          	movzbl 0xd(%eax),%eax
8010956e:	84 c0                	test   %al,%al
80109570:	75 0e                	jne    80109580 <eth_proc+0x5f>
    ipv4_proc(buffer_addr);
80109572:	83 ec 0c             	sub    $0xc,%esp
80109575:	ff 75 08             	push   0x8(%ebp)
80109578:	e8 a3 00 00 00       	call   80109620 <ipv4_proc>
8010957d:	83 c4 10             	add    $0x10,%esp
}
80109580:	90                   	nop
80109581:	c9                   	leave  
80109582:	c3                   	ret    

80109583 <N2H_ushort>:

ushort N2H_ushort(ushort value){
80109583:	55                   	push   %ebp
80109584:	89 e5                	mov    %esp,%ebp
80109586:	83 ec 04             	sub    $0x4,%esp
80109589:	8b 45 08             	mov    0x8(%ebp),%eax
8010958c:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  return (((value)&0xFF)<<8)+(value>>8);
80109590:	0f b7 45 fc          	movzwl -0x4(%ebp),%eax
80109594:	c1 e0 08             	shl    $0x8,%eax
80109597:	89 c2                	mov    %eax,%edx
80109599:	0f b7 45 fc          	movzwl -0x4(%ebp),%eax
8010959d:	66 c1 e8 08          	shr    $0x8,%ax
801095a1:	01 d0                	add    %edx,%eax
}
801095a3:	c9                   	leave  
801095a4:	c3                   	ret    

801095a5 <H2N_ushort>:

ushort H2N_ushort(ushort value){
801095a5:	55                   	push   %ebp
801095a6:	89 e5                	mov    %esp,%ebp
801095a8:	83 ec 04             	sub    $0x4,%esp
801095ab:	8b 45 08             	mov    0x8(%ebp),%eax
801095ae:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  return (((value)&0xFF)<<8)+(value>>8);
801095b2:	0f b7 45 fc          	movzwl -0x4(%ebp),%eax
801095b6:	c1 e0 08             	shl    $0x8,%eax
801095b9:	89 c2                	mov    %eax,%edx
801095bb:	0f b7 45 fc          	movzwl -0x4(%ebp),%eax
801095bf:	66 c1 e8 08          	shr    $0x8,%ax
801095c3:	01 d0                	add    %edx,%eax
}
801095c5:	c9                   	leave  
801095c6:	c3                   	ret    

801095c7 <H2N_uint>:

uint H2N_uint(uint value){
801095c7:	55                   	push   %ebp
801095c8:	89 e5                	mov    %esp,%ebp
  return ((value&0xF)<<24)+((value&0xF0)<<8)+((value&0xF00)>>8)+((value&0xF000)>>24);
801095ca:	8b 45 08             	mov    0x8(%ebp),%eax
801095cd:	c1 e0 18             	shl    $0x18,%eax
801095d0:	25 00 00 00 0f       	and    $0xf000000,%eax
801095d5:	89 c2                	mov    %eax,%edx
801095d7:	8b 45 08             	mov    0x8(%ebp),%eax
801095da:	c1 e0 08             	shl    $0x8,%eax
801095dd:	25 00 f0 00 00       	and    $0xf000,%eax
801095e2:	09 c2                	or     %eax,%edx
801095e4:	8b 45 08             	mov    0x8(%ebp),%eax
801095e7:	c1 e8 08             	shr    $0x8,%eax
801095ea:	83 e0 0f             	and    $0xf,%eax
801095ed:	01 d0                	add    %edx,%eax
}
801095ef:	5d                   	pop    %ebp
801095f0:	c3                   	ret    

801095f1 <N2H_uint>:

uint N2H_uint(uint value){
801095f1:	55                   	push   %ebp
801095f2:	89 e5                	mov    %esp,%ebp
  return ((value&0xFF)<<24)+((value&0xFF00)<<8)+((value&0xFF0000)>>8)+((value&0xFF000000)>>24);
801095f4:	8b 45 08             	mov    0x8(%ebp),%eax
801095f7:	c1 e0 18             	shl    $0x18,%eax
801095fa:	89 c2                	mov    %eax,%edx
801095fc:	8b 45 08             	mov    0x8(%ebp),%eax
801095ff:	c1 e0 08             	shl    $0x8,%eax
80109602:	25 00 00 ff 00       	and    $0xff0000,%eax
80109607:	01 c2                	add    %eax,%edx
80109609:	8b 45 08             	mov    0x8(%ebp),%eax
8010960c:	c1 e8 08             	shr    $0x8,%eax
8010960f:	25 00 ff 00 00       	and    $0xff00,%eax
80109614:	01 c2                	add    %eax,%edx
80109616:	8b 45 08             	mov    0x8(%ebp),%eax
80109619:	c1 e8 18             	shr    $0x18,%eax
8010961c:	01 d0                	add    %edx,%eax
}
8010961e:	5d                   	pop    %ebp
8010961f:	c3                   	ret    

80109620 <ipv4_proc>:
extern uchar mac_addr[6];
extern uchar my_ip[4];

int ip_id = -1;
ushort send_id = 0;
void ipv4_proc(uint buffer_addr){
80109620:	55                   	push   %ebp
80109621:	89 e5                	mov    %esp,%ebp
80109623:	83 ec 18             	sub    $0x18,%esp
  struct ipv4_pkt *ipv4_p = (struct ipv4_pkt *)(buffer_addr+14);
80109626:	8b 45 08             	mov    0x8(%ebp),%eax
80109629:	83 c0 0e             	add    $0xe,%eax
8010962c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(ip_id != ipv4_p->id && memcmp(my_ip,ipv4_p->src_ip,4) != 0){
8010962f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80109632:	0f b7 40 04          	movzwl 0x4(%eax),%eax
80109636:	0f b7 d0             	movzwl %ax,%edx
80109639:	a1 e8 f4 10 80       	mov    0x8010f4e8,%eax
8010963e:	39 c2                	cmp    %eax,%edx
80109640:	74 60                	je     801096a2 <ipv4_proc+0x82>
80109642:	8b 45 f4             	mov    -0xc(%ebp),%eax
80109645:	83 c0 0c             	add    $0xc,%eax
80109648:	83 ec 04             	sub    $0x4,%esp
8010964b:	6a 04                	push   $0x4
8010964d:	50                   	push   %eax
8010964e:	68 e4 f4 10 80       	push   $0x8010f4e4
80109653:	e8 5f b5 ff ff       	call   80104bb7 <memcmp>
80109658:	83 c4 10             	add    $0x10,%esp
8010965b:	85 c0                	test   %eax,%eax
8010965d:	74 43                	je     801096a2 <ipv4_proc+0x82>
    ip_id = ipv4_p->id;
8010965f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80109662:	0f b7 40 04          	movzwl 0x4(%eax),%eax
80109666:	0f b7 c0             	movzwl %ax,%eax
80109669:	a3 e8 f4 10 80       	mov    %eax,0x8010f4e8
      if(ipv4_p->protocol == IPV4_TYPE_ICMP){
8010966e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80109671:	0f b6 40 09          	movzbl 0x9(%eax),%eax
80109675:	3c 01                	cmp    $0x1,%al
80109677:	75 10                	jne    80109689 <ipv4_proc+0x69>
        icmp_proc(buffer_addr);
80109679:	83 ec 0c             	sub    $0xc,%esp
8010967c:	ff 75 08             	push   0x8(%ebp)
8010967f:	e8 a3 00 00 00       	call   80109727 <icmp_proc>
80109684:	83 c4 10             	add    $0x10,%esp
      }else if(ipv4_p->protocol == IPV4_TYPE_TCP){
        tcp_proc(buffer_addr);
      }
  }
}
80109687:	eb 19                	jmp    801096a2 <ipv4_proc+0x82>
      }else if(ipv4_p->protocol == IPV4_TYPE_TCP){
80109689:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010968c:	0f b6 40 09          	movzbl 0x9(%eax),%eax
80109690:	3c 06                	cmp    $0x6,%al
80109692:	75 0e                	jne    801096a2 <ipv4_proc+0x82>
        tcp_proc(buffer_addr);
80109694:	83 ec 0c             	sub    $0xc,%esp
80109697:	ff 75 08             	push   0x8(%ebp)
8010969a:	e8 b3 03 00 00       	call   80109a52 <tcp_proc>
8010969f:	83 c4 10             	add    $0x10,%esp
}
801096a2:	90                   	nop
801096a3:	c9                   	leave  
801096a4:	c3                   	ret    

801096a5 <ipv4_chksum>:

ushort ipv4_chksum(uint ipv4_addr){
801096a5:	55                   	push   %ebp
801096a6:	89 e5                	mov    %esp,%ebp
801096a8:	83 ec 10             	sub    $0x10,%esp
  uchar* bin = (uchar *)ipv4_addr;
801096ab:	8b 45 08             	mov    0x8(%ebp),%eax
801096ae:	89 45 f4             	mov    %eax,-0xc(%ebp)
  uchar len = (bin[0]&0xF)*2;
801096b1:	8b 45 f4             	mov    -0xc(%ebp),%eax
801096b4:	0f b6 00             	movzbl (%eax),%eax
801096b7:	83 e0 0f             	and    $0xf,%eax
801096ba:	01 c0                	add    %eax,%eax
801096bc:	88 45 f3             	mov    %al,-0xd(%ebp)
  uint chk_sum = 0;
801096bf:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  for(int i=0;i<len;i++){
801096c6:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
801096cd:	eb 48                	jmp    80109717 <ipv4_chksum+0x72>
    chk_sum += (bin[i*2]<<8)+bin[i*2+1];
801096cf:	8b 45 f8             	mov    -0x8(%ebp),%eax
801096d2:	01 c0                	add    %eax,%eax
801096d4:	89 c2                	mov    %eax,%edx
801096d6:	8b 45 f4             	mov    -0xc(%ebp),%eax
801096d9:	01 d0                	add    %edx,%eax
801096db:	0f b6 00             	movzbl (%eax),%eax
801096de:	0f b6 c0             	movzbl %al,%eax
801096e1:	c1 e0 08             	shl    $0x8,%eax
801096e4:	89 c2                	mov    %eax,%edx
801096e6:	8b 45 f8             	mov    -0x8(%ebp),%eax
801096e9:	01 c0                	add    %eax,%eax
801096eb:	8d 48 01             	lea    0x1(%eax),%ecx
801096ee:	8b 45 f4             	mov    -0xc(%ebp),%eax
801096f1:	01 c8                	add    %ecx,%eax
801096f3:	0f b6 00             	movzbl (%eax),%eax
801096f6:	0f b6 c0             	movzbl %al,%eax
801096f9:	01 d0                	add    %edx,%eax
801096fb:	01 45 fc             	add    %eax,-0x4(%ebp)
    if(chk_sum > 0xFFFF){
801096fe:	81 7d fc ff ff 00 00 	cmpl   $0xffff,-0x4(%ebp)
80109705:	76 0c                	jbe    80109713 <ipv4_chksum+0x6e>
      chk_sum = (chk_sum&0xFFFF)+1;
80109707:	8b 45 fc             	mov    -0x4(%ebp),%eax
8010970a:	0f b7 c0             	movzwl %ax,%eax
8010970d:	83 c0 01             	add    $0x1,%eax
80109710:	89 45 fc             	mov    %eax,-0x4(%ebp)
  for(int i=0;i<len;i++){
80109713:	83 45 f8 01          	addl   $0x1,-0x8(%ebp)
80109717:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
8010971b:	39 45 f8             	cmp    %eax,-0x8(%ebp)
8010971e:	7c af                	jl     801096cf <ipv4_chksum+0x2a>
    }
  }
  return ~(chk_sum);
80109720:	8b 45 fc             	mov    -0x4(%ebp),%eax
80109723:	f7 d0                	not    %eax
}
80109725:	c9                   	leave  
80109726:	c3                   	ret    

80109727 <icmp_proc>:
#include "eth.h"

extern uchar mac_addr[6];
extern uchar my_ip[4];
extern ushort send_id;
void icmp_proc(uint buffer_addr){
80109727:	55                   	push   %ebp
80109728:	89 e5                	mov    %esp,%ebp
8010972a:	83 ec 18             	sub    $0x18,%esp
  struct ipv4_pkt *ipv4_p = (struct ipv4_pkt *)(buffer_addr+sizeof(struct eth_pkt));
8010972d:	8b 45 08             	mov    0x8(%ebp),%eax
80109730:	83 c0 0e             	add    $0xe,%eax
80109733:	89 45 f4             	mov    %eax,-0xc(%ebp)
  struct icmp_echo_pkt *icmp_p = (struct icmp_echo_pkt *)((uint)ipv4_p + (ipv4_p->ver&0xF)*4);
80109736:	8b 45 f4             	mov    -0xc(%ebp),%eax
80109739:	0f b6 00             	movzbl (%eax),%eax
8010973c:	0f b6 c0             	movzbl %al,%eax
8010973f:	83 e0 0f             	and    $0xf,%eax
80109742:	c1 e0 02             	shl    $0x2,%eax
80109745:	89 c2                	mov    %eax,%edx
80109747:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010974a:	01 d0                	add    %edx,%eax
8010974c:	89 45 f0             	mov    %eax,-0x10(%ebp)
  if(icmp_p->code == 0){
8010974f:	8b 45 f0             	mov    -0x10(%ebp),%eax
80109752:	0f b6 40 01          	movzbl 0x1(%eax),%eax
80109756:	84 c0                	test   %al,%al
80109758:	75 4f                	jne    801097a9 <icmp_proc+0x82>
    if(icmp_p->type == ICMP_TYPE_ECHO_REQUEST){
8010975a:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010975d:	0f b6 00             	movzbl (%eax),%eax
80109760:	3c 08                	cmp    $0x8,%al
80109762:	75 45                	jne    801097a9 <icmp_proc+0x82>
      uint send_addr = (uint)kalloc();
80109764:	e8 37 90 ff ff       	call   801027a0 <kalloc>
80109769:	89 45 ec             	mov    %eax,-0x14(%ebp)
      uint send_size = 0;
8010976c:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
      icmp_reply_pkt_create(buffer_addr,send_addr,&send_size);
80109773:	83 ec 04             	sub    $0x4,%esp
80109776:	8d 45 e8             	lea    -0x18(%ebp),%eax
80109779:	50                   	push   %eax
8010977a:	ff 75 ec             	push   -0x14(%ebp)
8010977d:	ff 75 08             	push   0x8(%ebp)
80109780:	e8 78 00 00 00       	call   801097fd <icmp_reply_pkt_create>
80109785:	83 c4 10             	add    $0x10,%esp
      i8254_send(send_addr,send_size);
80109788:	8b 45 e8             	mov    -0x18(%ebp),%eax
8010978b:	83 ec 08             	sub    $0x8,%esp
8010978e:	50                   	push   %eax
8010978f:	ff 75 ec             	push   -0x14(%ebp)
80109792:	e8 95 f4 ff ff       	call   80108c2c <i8254_send>
80109797:	83 c4 10             	add    $0x10,%esp
      kfree((char *)send_addr);
8010979a:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010979d:	83 ec 0c             	sub    $0xc,%esp
801097a0:	50                   	push   %eax
801097a1:	e8 60 8f ff ff       	call   80102706 <kfree>
801097a6:	83 c4 10             	add    $0x10,%esp
    }
  }
}
801097a9:	90                   	nop
801097aa:	c9                   	leave  
801097ab:	c3                   	ret    

801097ac <icmp_proc_req>:

void icmp_proc_req(struct icmp_echo_pkt * icmp_p){
801097ac:	55                   	push   %ebp
801097ad:	89 e5                	mov    %esp,%ebp
801097af:	53                   	push   %ebx
801097b0:	83 ec 04             	sub    $0x4,%esp
  cprintf("ICMP ID:0x%x SEQ NUM:0x%x\n",N2H_ushort(icmp_p->id),N2H_ushort(icmp_p->seq_num));
801097b3:	8b 45 08             	mov    0x8(%ebp),%eax
801097b6:	0f b7 40 06          	movzwl 0x6(%eax),%eax
801097ba:	0f b7 c0             	movzwl %ax,%eax
801097bd:	83 ec 0c             	sub    $0xc,%esp
801097c0:	50                   	push   %eax
801097c1:	e8 bd fd ff ff       	call   80109583 <N2H_ushort>
801097c6:	83 c4 10             	add    $0x10,%esp
801097c9:	0f b7 d8             	movzwl %ax,%ebx
801097cc:	8b 45 08             	mov    0x8(%ebp),%eax
801097cf:	0f b7 40 04          	movzwl 0x4(%eax),%eax
801097d3:	0f b7 c0             	movzwl %ax,%eax
801097d6:	83 ec 0c             	sub    $0xc,%esp
801097d9:	50                   	push   %eax
801097da:	e8 a4 fd ff ff       	call   80109583 <N2H_ushort>
801097df:	83 c4 10             	add    $0x10,%esp
801097e2:	0f b7 c0             	movzwl %ax,%eax
801097e5:	83 ec 04             	sub    $0x4,%esp
801097e8:	53                   	push   %ebx
801097e9:	50                   	push   %eax
801097ea:	68 23 c1 10 80       	push   $0x8010c123
801097ef:	e8 00 6c ff ff       	call   801003f4 <cprintf>
801097f4:	83 c4 10             	add    $0x10,%esp
}
801097f7:	90                   	nop
801097f8:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801097fb:	c9                   	leave  
801097fc:	c3                   	ret    

801097fd <icmp_reply_pkt_create>:

void icmp_reply_pkt_create(uint recv_addr,uint send_addr,uint *send_size){
801097fd:	55                   	push   %ebp
801097fe:	89 e5                	mov    %esp,%ebp
80109800:	83 ec 28             	sub    $0x28,%esp
  struct eth_pkt *eth_recv = (struct eth_pkt *)(recv_addr);
80109803:	8b 45 08             	mov    0x8(%ebp),%eax
80109806:	89 45 f4             	mov    %eax,-0xc(%ebp)
  struct ipv4_pkt *ipv4_recv = (struct ipv4_pkt *)(recv_addr+sizeof(struct eth_pkt));
80109809:	8b 45 08             	mov    0x8(%ebp),%eax
8010980c:	83 c0 0e             	add    $0xe,%eax
8010980f:	89 45 f0             	mov    %eax,-0x10(%ebp)
  struct icmp_echo_pkt *icmp_recv = (struct icmp_echo_pkt *)((uint)ipv4_recv+(ipv4_recv->ver&0xF)*4);
80109812:	8b 45 f0             	mov    -0x10(%ebp),%eax
80109815:	0f b6 00             	movzbl (%eax),%eax
80109818:	0f b6 c0             	movzbl %al,%eax
8010981b:	83 e0 0f             	and    $0xf,%eax
8010981e:	c1 e0 02             	shl    $0x2,%eax
80109821:	89 c2                	mov    %eax,%edx
80109823:	8b 45 f0             	mov    -0x10(%ebp),%eax
80109826:	01 d0                	add    %edx,%eax
80109828:	89 45 ec             	mov    %eax,-0x14(%ebp)
  struct eth_pkt *eth_send = (struct eth_pkt *)(send_addr);
8010982b:	8b 45 0c             	mov    0xc(%ebp),%eax
8010982e:	89 45 e8             	mov    %eax,-0x18(%ebp)
  struct ipv4_pkt *ipv4_send = (struct ipv4_pkt *)(send_addr+sizeof(struct eth_pkt));
80109831:	8b 45 0c             	mov    0xc(%ebp),%eax
80109834:	83 c0 0e             	add    $0xe,%eax
80109837:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  struct icmp_echo_pkt *icmp_send = (struct icmp_echo_pkt *)((uint)ipv4_send+sizeof(struct ipv4_pkt));
8010983a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010983d:	83 c0 14             	add    $0x14,%eax
80109840:	89 45 e0             	mov    %eax,-0x20(%ebp)
  
  *send_size = sizeof(struct eth_pkt) + sizeof(struct ipv4_pkt) + sizeof(struct icmp_echo_pkt);
80109843:	8b 45 10             	mov    0x10(%ebp),%eax
80109846:	c7 00 62 00 00 00    	movl   $0x62,(%eax)
  memmove(eth_send->dst_mac,eth_recv->src_mac,6);
8010984c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010984f:	8d 50 06             	lea    0x6(%eax),%edx
80109852:	8b 45 e8             	mov    -0x18(%ebp),%eax
80109855:	83 ec 04             	sub    $0x4,%esp
80109858:	6a 06                	push   $0x6
8010985a:	52                   	push   %edx
8010985b:	50                   	push   %eax
8010985c:	e8 ae b3 ff ff       	call   80104c0f <memmove>
80109861:	83 c4 10             	add    $0x10,%esp
  memmove(eth_send->src_mac,mac_addr,6);
80109864:	8b 45 e8             	mov    -0x18(%ebp),%eax
80109867:	83 c0 06             	add    $0x6,%eax
8010986a:	83 ec 04             	sub    $0x4,%esp
8010986d:	6a 06                	push   $0x6
8010986f:	68 80 6c 19 80       	push   $0x80196c80
80109874:	50                   	push   %eax
80109875:	e8 95 b3 ff ff       	call   80104c0f <memmove>
8010987a:	83 c4 10             	add    $0x10,%esp
  eth_send->type[0] = 0x08;
8010987d:	8b 45 e8             	mov    -0x18(%ebp),%eax
80109880:	c6 40 0c 08          	movb   $0x8,0xc(%eax)
  eth_send->type[1] = 0x00;
80109884:	8b 45 e8             	mov    -0x18(%ebp),%eax
80109887:	c6 40 0d 00          	movb   $0x0,0xd(%eax)

  ipv4_send->ver = ((0x4)<<4)+((sizeof(struct ipv4_pkt)/4)&0xF);
8010988b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010988e:	c6 00 45             	movb   $0x45,(%eax)
  ipv4_send->srv_type = 0;
80109891:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80109894:	c6 40 01 00          	movb   $0x0,0x1(%eax)
  ipv4_send->total_len = H2N_ushort(sizeof(struct ipv4_pkt) + sizeof(struct icmp_echo_pkt));
80109898:	83 ec 0c             	sub    $0xc,%esp
8010989b:	6a 54                	push   $0x54
8010989d:	e8 03 fd ff ff       	call   801095a5 <H2N_ushort>
801098a2:	83 c4 10             	add    $0x10,%esp
801098a5:	8b 55 e4             	mov    -0x1c(%ebp),%edx
801098a8:	66 89 42 02          	mov    %ax,0x2(%edx)
  ipv4_send->id = send_id;
801098ac:	0f b7 15 60 6f 19 80 	movzwl 0x80196f60,%edx
801098b3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801098b6:	66 89 50 04          	mov    %dx,0x4(%eax)
  send_id++;
801098ba:	0f b7 05 60 6f 19 80 	movzwl 0x80196f60,%eax
801098c1:	83 c0 01             	add    $0x1,%eax
801098c4:	66 a3 60 6f 19 80    	mov    %ax,0x80196f60
  ipv4_send->fragment = H2N_ushort(0x4000);
801098ca:	83 ec 0c             	sub    $0xc,%esp
801098cd:	68 00 40 00 00       	push   $0x4000
801098d2:	e8 ce fc ff ff       	call   801095a5 <H2N_ushort>
801098d7:	83 c4 10             	add    $0x10,%esp
801098da:	8b 55 e4             	mov    -0x1c(%ebp),%edx
801098dd:	66 89 42 06          	mov    %ax,0x6(%edx)
  ipv4_send->ttl = 255;
801098e1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801098e4:	c6 40 08 ff          	movb   $0xff,0x8(%eax)
  ipv4_send->protocol = 0x1;
801098e8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801098eb:	c6 40 09 01          	movb   $0x1,0x9(%eax)
  memmove(ipv4_send->src_ip,my_ip,4);
801098ef:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801098f2:	83 c0 0c             	add    $0xc,%eax
801098f5:	83 ec 04             	sub    $0x4,%esp
801098f8:	6a 04                	push   $0x4
801098fa:	68 e4 f4 10 80       	push   $0x8010f4e4
801098ff:	50                   	push   %eax
80109900:	e8 0a b3 ff ff       	call   80104c0f <memmove>
80109905:	83 c4 10             	add    $0x10,%esp
  memmove(ipv4_send->dst_ip,ipv4_recv->src_ip,4);
80109908:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010990b:	8d 50 0c             	lea    0xc(%eax),%edx
8010990e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80109911:	83 c0 10             	add    $0x10,%eax
80109914:	83 ec 04             	sub    $0x4,%esp
80109917:	6a 04                	push   $0x4
80109919:	52                   	push   %edx
8010991a:	50                   	push   %eax
8010991b:	e8 ef b2 ff ff       	call   80104c0f <memmove>
80109920:	83 c4 10             	add    $0x10,%esp
  ipv4_send->chk_sum = 0;
80109923:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80109926:	66 c7 40 0a 00 00    	movw   $0x0,0xa(%eax)
  ipv4_send->chk_sum = H2N_ushort(ipv4_chksum((uint)ipv4_send));
8010992c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010992f:	83 ec 0c             	sub    $0xc,%esp
80109932:	50                   	push   %eax
80109933:	e8 6d fd ff ff       	call   801096a5 <ipv4_chksum>
80109938:	83 c4 10             	add    $0x10,%esp
8010993b:	0f b7 c0             	movzwl %ax,%eax
8010993e:	83 ec 0c             	sub    $0xc,%esp
80109941:	50                   	push   %eax
80109942:	e8 5e fc ff ff       	call   801095a5 <H2N_ushort>
80109947:	83 c4 10             	add    $0x10,%esp
8010994a:	8b 55 e4             	mov    -0x1c(%ebp),%edx
8010994d:	66 89 42 0a          	mov    %ax,0xa(%edx)

  icmp_send->type = ICMP_TYPE_ECHO_REPLY;
80109951:	8b 45 e0             	mov    -0x20(%ebp),%eax
80109954:	c6 00 00             	movb   $0x0,(%eax)
  icmp_send->code = 0;
80109957:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010995a:	c6 40 01 00          	movb   $0x0,0x1(%eax)
  icmp_send->id = icmp_recv->id;
8010995e:	8b 45 ec             	mov    -0x14(%ebp),%eax
80109961:	0f b7 50 04          	movzwl 0x4(%eax),%edx
80109965:	8b 45 e0             	mov    -0x20(%ebp),%eax
80109968:	66 89 50 04          	mov    %dx,0x4(%eax)
  icmp_send->seq_num = icmp_recv->seq_num;
8010996c:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010996f:	0f b7 50 06          	movzwl 0x6(%eax),%edx
80109973:	8b 45 e0             	mov    -0x20(%ebp),%eax
80109976:	66 89 50 06          	mov    %dx,0x6(%eax)
  memmove(icmp_send->time_stamp,icmp_recv->time_stamp,8);
8010997a:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010997d:	8d 50 08             	lea    0x8(%eax),%edx
80109980:	8b 45 e0             	mov    -0x20(%ebp),%eax
80109983:	83 c0 08             	add    $0x8,%eax
80109986:	83 ec 04             	sub    $0x4,%esp
80109989:	6a 08                	push   $0x8
8010998b:	52                   	push   %edx
8010998c:	50                   	push   %eax
8010998d:	e8 7d b2 ff ff       	call   80104c0f <memmove>
80109992:	83 c4 10             	add    $0x10,%esp
  memmove(icmp_send->data,icmp_recv->data,48);
80109995:	8b 45 ec             	mov    -0x14(%ebp),%eax
80109998:	8d 50 10             	lea    0x10(%eax),%edx
8010999b:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010999e:	83 c0 10             	add    $0x10,%eax
801099a1:	83 ec 04             	sub    $0x4,%esp
801099a4:	6a 30                	push   $0x30
801099a6:	52                   	push   %edx
801099a7:	50                   	push   %eax
801099a8:	e8 62 b2 ff ff       	call   80104c0f <memmove>
801099ad:	83 c4 10             	add    $0x10,%esp
  icmp_send->chk_sum = 0;
801099b0:	8b 45 e0             	mov    -0x20(%ebp),%eax
801099b3:	66 c7 40 02 00 00    	movw   $0x0,0x2(%eax)
  icmp_send->chk_sum = H2N_ushort(icmp_chksum((uint)icmp_send));
801099b9:	8b 45 e0             	mov    -0x20(%ebp),%eax
801099bc:	83 ec 0c             	sub    $0xc,%esp
801099bf:	50                   	push   %eax
801099c0:	e8 1c 00 00 00       	call   801099e1 <icmp_chksum>
801099c5:	83 c4 10             	add    $0x10,%esp
801099c8:	0f b7 c0             	movzwl %ax,%eax
801099cb:	83 ec 0c             	sub    $0xc,%esp
801099ce:	50                   	push   %eax
801099cf:	e8 d1 fb ff ff       	call   801095a5 <H2N_ushort>
801099d4:	83 c4 10             	add    $0x10,%esp
801099d7:	8b 55 e0             	mov    -0x20(%ebp),%edx
801099da:	66 89 42 02          	mov    %ax,0x2(%edx)
}
801099de:	90                   	nop
801099df:	c9                   	leave  
801099e0:	c3                   	ret    

801099e1 <icmp_chksum>:

ushort icmp_chksum(uint icmp_addr){
801099e1:	55                   	push   %ebp
801099e2:	89 e5                	mov    %esp,%ebp
801099e4:	83 ec 10             	sub    $0x10,%esp
  uchar* bin = (uchar *)icmp_addr;
801099e7:	8b 45 08             	mov    0x8(%ebp),%eax
801099ea:	89 45 f4             	mov    %eax,-0xc(%ebp)
  uint chk_sum = 0;
801099ed:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  for(int i=0;i<32;i++){
801099f4:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
801099fb:	eb 48                	jmp    80109a45 <icmp_chksum+0x64>
    chk_sum += (bin[i*2]<<8)+bin[i*2+1];
801099fd:	8b 45 f8             	mov    -0x8(%ebp),%eax
80109a00:	01 c0                	add    %eax,%eax
80109a02:	89 c2                	mov    %eax,%edx
80109a04:	8b 45 f4             	mov    -0xc(%ebp),%eax
80109a07:	01 d0                	add    %edx,%eax
80109a09:	0f b6 00             	movzbl (%eax),%eax
80109a0c:	0f b6 c0             	movzbl %al,%eax
80109a0f:	c1 e0 08             	shl    $0x8,%eax
80109a12:	89 c2                	mov    %eax,%edx
80109a14:	8b 45 f8             	mov    -0x8(%ebp),%eax
80109a17:	01 c0                	add    %eax,%eax
80109a19:	8d 48 01             	lea    0x1(%eax),%ecx
80109a1c:	8b 45 f4             	mov    -0xc(%ebp),%eax
80109a1f:	01 c8                	add    %ecx,%eax
80109a21:	0f b6 00             	movzbl (%eax),%eax
80109a24:	0f b6 c0             	movzbl %al,%eax
80109a27:	01 d0                	add    %edx,%eax
80109a29:	01 45 fc             	add    %eax,-0x4(%ebp)
    if(chk_sum > 0xFFFF){
80109a2c:	81 7d fc ff ff 00 00 	cmpl   $0xffff,-0x4(%ebp)
80109a33:	76 0c                	jbe    80109a41 <icmp_chksum+0x60>
      chk_sum = (chk_sum&0xFFFF)+1;
80109a35:	8b 45 fc             	mov    -0x4(%ebp),%eax
80109a38:	0f b7 c0             	movzwl %ax,%eax
80109a3b:	83 c0 01             	add    $0x1,%eax
80109a3e:	89 45 fc             	mov    %eax,-0x4(%ebp)
  for(int i=0;i<32;i++){
80109a41:	83 45 f8 01          	addl   $0x1,-0x8(%ebp)
80109a45:	83 7d f8 1f          	cmpl   $0x1f,-0x8(%ebp)
80109a49:	7e b2                	jle    801099fd <icmp_chksum+0x1c>
    }
  }
  return ~(chk_sum);
80109a4b:	8b 45 fc             	mov    -0x4(%ebp),%eax
80109a4e:	f7 d0                	not    %eax
}
80109a50:	c9                   	leave  
80109a51:	c3                   	ret    

80109a52 <tcp_proc>:
extern ushort send_id;
extern uchar mac_addr[6];
extern uchar my_ip[4];
int fin_flag = 0;

void tcp_proc(uint buffer_addr){
80109a52:	55                   	push   %ebp
80109a53:	89 e5                	mov    %esp,%ebp
80109a55:	83 ec 38             	sub    $0x38,%esp
  struct ipv4_pkt *ipv4_p = (struct ipv4_pkt *)(buffer_addr + sizeof(struct eth_pkt));
80109a58:	8b 45 08             	mov    0x8(%ebp),%eax
80109a5b:	83 c0 0e             	add    $0xe,%eax
80109a5e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  struct tcp_pkt *tcp_p = (struct tcp_pkt *)((uint)ipv4_p + (ipv4_p->ver&0xF)*4);
80109a61:	8b 45 f4             	mov    -0xc(%ebp),%eax
80109a64:	0f b6 00             	movzbl (%eax),%eax
80109a67:	0f b6 c0             	movzbl %al,%eax
80109a6a:	83 e0 0f             	and    $0xf,%eax
80109a6d:	c1 e0 02             	shl    $0x2,%eax
80109a70:	89 c2                	mov    %eax,%edx
80109a72:	8b 45 f4             	mov    -0xc(%ebp),%eax
80109a75:	01 d0                	add    %edx,%eax
80109a77:	89 45 f0             	mov    %eax,-0x10(%ebp)
  char *payload = (char *)((uint)tcp_p + 20);
80109a7a:	8b 45 f0             	mov    -0x10(%ebp),%eax
80109a7d:	83 c0 14             	add    $0x14,%eax
80109a80:	89 45 ec             	mov    %eax,-0x14(%ebp)
  uint send_addr = (uint)kalloc();
80109a83:	e8 18 8d ff ff       	call   801027a0 <kalloc>
80109a88:	89 45 e8             	mov    %eax,-0x18(%ebp)
  uint send_size = 0;
80109a8b:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
  if(tcp_p->code_bits[1]&TCP_CODEBITS_SYN){
80109a92:	8b 45 f0             	mov    -0x10(%ebp),%eax
80109a95:	0f b6 40 0d          	movzbl 0xd(%eax),%eax
80109a99:	0f b6 c0             	movzbl %al,%eax
80109a9c:	83 e0 02             	and    $0x2,%eax
80109a9f:	85 c0                	test   %eax,%eax
80109aa1:	74 3d                	je     80109ae0 <tcp_proc+0x8e>
    tcp_pkt_create(buffer_addr,send_addr,&send_size,TCP_CODEBITS_ACK | TCP_CODEBITS_SYN,0);
80109aa3:	83 ec 0c             	sub    $0xc,%esp
80109aa6:	6a 00                	push   $0x0
80109aa8:	6a 12                	push   $0x12
80109aaa:	8d 45 dc             	lea    -0x24(%ebp),%eax
80109aad:	50                   	push   %eax
80109aae:	ff 75 e8             	push   -0x18(%ebp)
80109ab1:	ff 75 08             	push   0x8(%ebp)
80109ab4:	e8 a2 01 00 00       	call   80109c5b <tcp_pkt_create>
80109ab9:	83 c4 20             	add    $0x20,%esp
    i8254_send(send_addr,send_size);
80109abc:	8b 45 dc             	mov    -0x24(%ebp),%eax
80109abf:	83 ec 08             	sub    $0x8,%esp
80109ac2:	50                   	push   %eax
80109ac3:	ff 75 e8             	push   -0x18(%ebp)
80109ac6:	e8 61 f1 ff ff       	call   80108c2c <i8254_send>
80109acb:	83 c4 10             	add    $0x10,%esp
    seq_num++;
80109ace:	a1 64 6f 19 80       	mov    0x80196f64,%eax
80109ad3:	83 c0 01             	add    $0x1,%eax
80109ad6:	a3 64 6f 19 80       	mov    %eax,0x80196f64
80109adb:	e9 69 01 00 00       	jmp    80109c49 <tcp_proc+0x1f7>
  }else if(tcp_p->code_bits[1] == (TCP_CODEBITS_PSH | TCP_CODEBITS_ACK)){
80109ae0:	8b 45 f0             	mov    -0x10(%ebp),%eax
80109ae3:	0f b6 40 0d          	movzbl 0xd(%eax),%eax
80109ae7:	3c 18                	cmp    $0x18,%al
80109ae9:	0f 85 10 01 00 00    	jne    80109bff <tcp_proc+0x1ad>
    if(memcmp(payload,"GET",3)){
80109aef:	83 ec 04             	sub    $0x4,%esp
80109af2:	6a 03                	push   $0x3
80109af4:	68 3e c1 10 80       	push   $0x8010c13e
80109af9:	ff 75 ec             	push   -0x14(%ebp)
80109afc:	e8 b6 b0 ff ff       	call   80104bb7 <memcmp>
80109b01:	83 c4 10             	add    $0x10,%esp
80109b04:	85 c0                	test   %eax,%eax
80109b06:	74 74                	je     80109b7c <tcp_proc+0x12a>
      cprintf("ACK PSH\n");
80109b08:	83 ec 0c             	sub    $0xc,%esp
80109b0b:	68 42 c1 10 80       	push   $0x8010c142
80109b10:	e8 df 68 ff ff       	call   801003f4 <cprintf>
80109b15:	83 c4 10             	add    $0x10,%esp
      tcp_pkt_create(buffer_addr,send_addr,&send_size,TCP_CODEBITS_ACK,0);
80109b18:	83 ec 0c             	sub    $0xc,%esp
80109b1b:	6a 00                	push   $0x0
80109b1d:	6a 10                	push   $0x10
80109b1f:	8d 45 dc             	lea    -0x24(%ebp),%eax
80109b22:	50                   	push   %eax
80109b23:	ff 75 e8             	push   -0x18(%ebp)
80109b26:	ff 75 08             	push   0x8(%ebp)
80109b29:	e8 2d 01 00 00       	call   80109c5b <tcp_pkt_create>
80109b2e:	83 c4 20             	add    $0x20,%esp
      i8254_send(send_addr,send_size);
80109b31:	8b 45 dc             	mov    -0x24(%ebp),%eax
80109b34:	83 ec 08             	sub    $0x8,%esp
80109b37:	50                   	push   %eax
80109b38:	ff 75 e8             	push   -0x18(%ebp)
80109b3b:	e8 ec f0 ff ff       	call   80108c2c <i8254_send>
80109b40:	83 c4 10             	add    $0x10,%esp
      uint send_payload = (send_addr + sizeof(struct eth_pkt) + sizeof(struct ipv4_pkt) + sizeof(struct tcp_pkt));
80109b43:	8b 45 e8             	mov    -0x18(%ebp),%eax
80109b46:	83 c0 36             	add    $0x36,%eax
80109b49:	89 45 e0             	mov    %eax,-0x20(%ebp)
      uint payload_size;
      http_proc(0,0,send_payload,&payload_size);
80109b4c:	8d 45 d8             	lea    -0x28(%ebp),%eax
80109b4f:	50                   	push   %eax
80109b50:	ff 75 e0             	push   -0x20(%ebp)
80109b53:	6a 00                	push   $0x0
80109b55:	6a 00                	push   $0x0
80109b57:	e8 5a 04 00 00       	call   80109fb6 <http_proc>
80109b5c:	83 c4 10             	add    $0x10,%esp
      tcp_pkt_create(buffer_addr,send_addr,&send_size,(TCP_CODEBITS_ACK|TCP_CODEBITS_PSH),payload_size);
80109b5f:	8b 45 d8             	mov    -0x28(%ebp),%eax
80109b62:	83 ec 0c             	sub    $0xc,%esp
80109b65:	50                   	push   %eax
80109b66:	6a 18                	push   $0x18
80109b68:	8d 45 dc             	lea    -0x24(%ebp),%eax
80109b6b:	50                   	push   %eax
80109b6c:	ff 75 e8             	push   -0x18(%ebp)
80109b6f:	ff 75 08             	push   0x8(%ebp)
80109b72:	e8 e4 00 00 00       	call   80109c5b <tcp_pkt_create>
80109b77:	83 c4 20             	add    $0x20,%esp
80109b7a:	eb 62                	jmp    80109bde <tcp_proc+0x18c>
    }else{
     tcp_pkt_create(buffer_addr,send_addr,&send_size,TCP_CODEBITS_ACK,0);
80109b7c:	83 ec 0c             	sub    $0xc,%esp
80109b7f:	6a 00                	push   $0x0
80109b81:	6a 10                	push   $0x10
80109b83:	8d 45 dc             	lea    -0x24(%ebp),%eax
80109b86:	50                   	push   %eax
80109b87:	ff 75 e8             	push   -0x18(%ebp)
80109b8a:	ff 75 08             	push   0x8(%ebp)
80109b8d:	e8 c9 00 00 00       	call   80109c5b <tcp_pkt_create>
80109b92:	83 c4 20             	add    $0x20,%esp
     i8254_send(send_addr,send_size);
80109b95:	8b 45 dc             	mov    -0x24(%ebp),%eax
80109b98:	83 ec 08             	sub    $0x8,%esp
80109b9b:	50                   	push   %eax
80109b9c:	ff 75 e8             	push   -0x18(%ebp)
80109b9f:	e8 88 f0 ff ff       	call   80108c2c <i8254_send>
80109ba4:	83 c4 10             	add    $0x10,%esp
      uint send_payload = (send_addr + sizeof(struct eth_pkt) + sizeof(struct ipv4_pkt) + sizeof(struct tcp_pkt));
80109ba7:	8b 45 e8             	mov    -0x18(%ebp),%eax
80109baa:	83 c0 36             	add    $0x36,%eax
80109bad:	89 45 e4             	mov    %eax,-0x1c(%ebp)
      uint payload_size;
      http_proc(0,0,send_payload,&payload_size);
80109bb0:	8d 45 d4             	lea    -0x2c(%ebp),%eax
80109bb3:	50                   	push   %eax
80109bb4:	ff 75 e4             	push   -0x1c(%ebp)
80109bb7:	6a 00                	push   $0x0
80109bb9:	6a 00                	push   $0x0
80109bbb:	e8 f6 03 00 00       	call   80109fb6 <http_proc>
80109bc0:	83 c4 10             	add    $0x10,%esp
      tcp_pkt_create(buffer_addr,send_addr,&send_size,(TCP_CODEBITS_ACK|TCP_CODEBITS_PSH),payload_size);
80109bc3:	8b 45 d4             	mov    -0x2c(%ebp),%eax
80109bc6:	83 ec 0c             	sub    $0xc,%esp
80109bc9:	50                   	push   %eax
80109bca:	6a 18                	push   $0x18
80109bcc:	8d 45 dc             	lea    -0x24(%ebp),%eax
80109bcf:	50                   	push   %eax
80109bd0:	ff 75 e8             	push   -0x18(%ebp)
80109bd3:	ff 75 08             	push   0x8(%ebp)
80109bd6:	e8 80 00 00 00       	call   80109c5b <tcp_pkt_create>
80109bdb:	83 c4 20             	add    $0x20,%esp
    }
    i8254_send(send_addr,send_size);
80109bde:	8b 45 dc             	mov    -0x24(%ebp),%eax
80109be1:	83 ec 08             	sub    $0x8,%esp
80109be4:	50                   	push   %eax
80109be5:	ff 75 e8             	push   -0x18(%ebp)
80109be8:	e8 3f f0 ff ff       	call   80108c2c <i8254_send>
80109bed:	83 c4 10             	add    $0x10,%esp
    seq_num++;
80109bf0:	a1 64 6f 19 80       	mov    0x80196f64,%eax
80109bf5:	83 c0 01             	add    $0x1,%eax
80109bf8:	a3 64 6f 19 80       	mov    %eax,0x80196f64
80109bfd:	eb 4a                	jmp    80109c49 <tcp_proc+0x1f7>
  }else if(tcp_p->code_bits[1] == TCP_CODEBITS_ACK){
80109bff:	8b 45 f0             	mov    -0x10(%ebp),%eax
80109c02:	0f b6 40 0d          	movzbl 0xd(%eax),%eax
80109c06:	3c 10                	cmp    $0x10,%al
80109c08:	75 3f                	jne    80109c49 <tcp_proc+0x1f7>
    if(fin_flag == 1){
80109c0a:	a1 68 6f 19 80       	mov    0x80196f68,%eax
80109c0f:	83 f8 01             	cmp    $0x1,%eax
80109c12:	75 35                	jne    80109c49 <tcp_proc+0x1f7>
      tcp_pkt_create(buffer_addr,send_addr,&send_size,TCP_CODEBITS_FIN,0);
80109c14:	83 ec 0c             	sub    $0xc,%esp
80109c17:	6a 00                	push   $0x0
80109c19:	6a 01                	push   $0x1
80109c1b:	8d 45 dc             	lea    -0x24(%ebp),%eax
80109c1e:	50                   	push   %eax
80109c1f:	ff 75 e8             	push   -0x18(%ebp)
80109c22:	ff 75 08             	push   0x8(%ebp)
80109c25:	e8 31 00 00 00       	call   80109c5b <tcp_pkt_create>
80109c2a:	83 c4 20             	add    $0x20,%esp
      i8254_send(send_addr,send_size);
80109c2d:	8b 45 dc             	mov    -0x24(%ebp),%eax
80109c30:	83 ec 08             	sub    $0x8,%esp
80109c33:	50                   	push   %eax
80109c34:	ff 75 e8             	push   -0x18(%ebp)
80109c37:	e8 f0 ef ff ff       	call   80108c2c <i8254_send>
80109c3c:	83 c4 10             	add    $0x10,%esp
      fin_flag = 0;
80109c3f:	c7 05 68 6f 19 80 00 	movl   $0x0,0x80196f68
80109c46:	00 00 00 
    }
  }
  kfree((char *)send_addr);
80109c49:	8b 45 e8             	mov    -0x18(%ebp),%eax
80109c4c:	83 ec 0c             	sub    $0xc,%esp
80109c4f:	50                   	push   %eax
80109c50:	e8 b1 8a ff ff       	call   80102706 <kfree>
80109c55:	83 c4 10             	add    $0x10,%esp
}
80109c58:	90                   	nop
80109c59:	c9                   	leave  
80109c5a:	c3                   	ret    

80109c5b <tcp_pkt_create>:

void tcp_pkt_create(uint recv_addr,uint send_addr,uint *send_size,uint pkt_type,uint payload_size){
80109c5b:	55                   	push   %ebp
80109c5c:	89 e5                	mov    %esp,%ebp
80109c5e:	83 ec 28             	sub    $0x28,%esp
  struct eth_pkt *eth_recv = (struct eth_pkt *)(recv_addr);
80109c61:	8b 45 08             	mov    0x8(%ebp),%eax
80109c64:	89 45 f4             	mov    %eax,-0xc(%ebp)
  struct ipv4_pkt *ipv4_recv = (struct ipv4_pkt *)(recv_addr+sizeof(struct eth_pkt));
80109c67:	8b 45 08             	mov    0x8(%ebp),%eax
80109c6a:	83 c0 0e             	add    $0xe,%eax
80109c6d:	89 45 f0             	mov    %eax,-0x10(%ebp)
  struct tcp_pkt *tcp_recv = (struct tcp_pkt *)((uint)ipv4_recv + (ipv4_recv->ver&0xF)*4);
80109c70:	8b 45 f0             	mov    -0x10(%ebp),%eax
80109c73:	0f b6 00             	movzbl (%eax),%eax
80109c76:	0f b6 c0             	movzbl %al,%eax
80109c79:	83 e0 0f             	and    $0xf,%eax
80109c7c:	c1 e0 02             	shl    $0x2,%eax
80109c7f:	89 c2                	mov    %eax,%edx
80109c81:	8b 45 f0             	mov    -0x10(%ebp),%eax
80109c84:	01 d0                	add    %edx,%eax
80109c86:	89 45 ec             	mov    %eax,-0x14(%ebp)

  struct eth_pkt *eth_send = (struct eth_pkt *)(send_addr);
80109c89:	8b 45 0c             	mov    0xc(%ebp),%eax
80109c8c:	89 45 e8             	mov    %eax,-0x18(%ebp)
  struct ipv4_pkt *ipv4_send = (struct ipv4_pkt *)(send_addr + sizeof(struct eth_pkt));
80109c8f:	8b 45 0c             	mov    0xc(%ebp),%eax
80109c92:	83 c0 0e             	add    $0xe,%eax
80109c95:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  struct tcp_pkt *tcp_send = (struct tcp_pkt *)((uint)ipv4_send + sizeof(struct ipv4_pkt));
80109c98:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80109c9b:	83 c0 14             	add    $0x14,%eax
80109c9e:	89 45 e0             	mov    %eax,-0x20(%ebp)

  *send_size = sizeof(struct eth_pkt) + sizeof(struct ipv4_pkt) + sizeof(struct tcp_pkt) + payload_size;
80109ca1:	8b 45 18             	mov    0x18(%ebp),%eax
80109ca4:	8d 50 36             	lea    0x36(%eax),%edx
80109ca7:	8b 45 10             	mov    0x10(%ebp),%eax
80109caa:	89 10                	mov    %edx,(%eax)

  memmove(eth_send->dst_mac,eth_recv->src_mac,6);
80109cac:	8b 45 f4             	mov    -0xc(%ebp),%eax
80109caf:	8d 50 06             	lea    0x6(%eax),%edx
80109cb2:	8b 45 e8             	mov    -0x18(%ebp),%eax
80109cb5:	83 ec 04             	sub    $0x4,%esp
80109cb8:	6a 06                	push   $0x6
80109cba:	52                   	push   %edx
80109cbb:	50                   	push   %eax
80109cbc:	e8 4e af ff ff       	call   80104c0f <memmove>
80109cc1:	83 c4 10             	add    $0x10,%esp
  memmove(eth_send->src_mac,mac_addr,6);
80109cc4:	8b 45 e8             	mov    -0x18(%ebp),%eax
80109cc7:	83 c0 06             	add    $0x6,%eax
80109cca:	83 ec 04             	sub    $0x4,%esp
80109ccd:	6a 06                	push   $0x6
80109ccf:	68 80 6c 19 80       	push   $0x80196c80
80109cd4:	50                   	push   %eax
80109cd5:	e8 35 af ff ff       	call   80104c0f <memmove>
80109cda:	83 c4 10             	add    $0x10,%esp
  eth_send->type[0] = 0x08;
80109cdd:	8b 45 e8             	mov    -0x18(%ebp),%eax
80109ce0:	c6 40 0c 08          	movb   $0x8,0xc(%eax)
  eth_send->type[1] = 0x00;
80109ce4:	8b 45 e8             	mov    -0x18(%ebp),%eax
80109ce7:	c6 40 0d 00          	movb   $0x0,0xd(%eax)

  ipv4_send->ver = ((0x4)<<4)+((sizeof(struct ipv4_pkt)/4)&0xF);
80109ceb:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80109cee:	c6 00 45             	movb   $0x45,(%eax)
  ipv4_send->srv_type = 0;
80109cf1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80109cf4:	c6 40 01 00          	movb   $0x0,0x1(%eax)
  ipv4_send->total_len = H2N_ushort(sizeof(struct ipv4_pkt) + sizeof(struct tcp_pkt) + payload_size);
80109cf8:	8b 45 18             	mov    0x18(%ebp),%eax
80109cfb:	83 c0 28             	add    $0x28,%eax
80109cfe:	0f b7 c0             	movzwl %ax,%eax
80109d01:	83 ec 0c             	sub    $0xc,%esp
80109d04:	50                   	push   %eax
80109d05:	e8 9b f8 ff ff       	call   801095a5 <H2N_ushort>
80109d0a:	83 c4 10             	add    $0x10,%esp
80109d0d:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80109d10:	66 89 42 02          	mov    %ax,0x2(%edx)
  ipv4_send->id = send_id;
80109d14:	0f b7 15 60 6f 19 80 	movzwl 0x80196f60,%edx
80109d1b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80109d1e:	66 89 50 04          	mov    %dx,0x4(%eax)
  send_id++;
80109d22:	0f b7 05 60 6f 19 80 	movzwl 0x80196f60,%eax
80109d29:	83 c0 01             	add    $0x1,%eax
80109d2c:	66 a3 60 6f 19 80    	mov    %ax,0x80196f60
  ipv4_send->fragment = H2N_ushort(0x0000);
80109d32:	83 ec 0c             	sub    $0xc,%esp
80109d35:	6a 00                	push   $0x0
80109d37:	e8 69 f8 ff ff       	call   801095a5 <H2N_ushort>
80109d3c:	83 c4 10             	add    $0x10,%esp
80109d3f:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80109d42:	66 89 42 06          	mov    %ax,0x6(%edx)
  ipv4_send->ttl = 255;
80109d46:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80109d49:	c6 40 08 ff          	movb   $0xff,0x8(%eax)
  ipv4_send->protocol = IPV4_TYPE_TCP;
80109d4d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80109d50:	c6 40 09 06          	movb   $0x6,0x9(%eax)
  memmove(ipv4_send->src_ip,my_ip,4);
80109d54:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80109d57:	83 c0 0c             	add    $0xc,%eax
80109d5a:	83 ec 04             	sub    $0x4,%esp
80109d5d:	6a 04                	push   $0x4
80109d5f:	68 e4 f4 10 80       	push   $0x8010f4e4
80109d64:	50                   	push   %eax
80109d65:	e8 a5 ae ff ff       	call   80104c0f <memmove>
80109d6a:	83 c4 10             	add    $0x10,%esp
  memmove(ipv4_send->dst_ip,ipv4_recv->src_ip,4);
80109d6d:	8b 45 f0             	mov    -0x10(%ebp),%eax
80109d70:	8d 50 0c             	lea    0xc(%eax),%edx
80109d73:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80109d76:	83 c0 10             	add    $0x10,%eax
80109d79:	83 ec 04             	sub    $0x4,%esp
80109d7c:	6a 04                	push   $0x4
80109d7e:	52                   	push   %edx
80109d7f:	50                   	push   %eax
80109d80:	e8 8a ae ff ff       	call   80104c0f <memmove>
80109d85:	83 c4 10             	add    $0x10,%esp
  ipv4_send->chk_sum = 0;
80109d88:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80109d8b:	66 c7 40 0a 00 00    	movw   $0x0,0xa(%eax)
  ipv4_send->chk_sum = H2N_ushort(ipv4_chksum((uint)ipv4_send));
80109d91:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80109d94:	83 ec 0c             	sub    $0xc,%esp
80109d97:	50                   	push   %eax
80109d98:	e8 08 f9 ff ff       	call   801096a5 <ipv4_chksum>
80109d9d:	83 c4 10             	add    $0x10,%esp
80109da0:	0f b7 c0             	movzwl %ax,%eax
80109da3:	83 ec 0c             	sub    $0xc,%esp
80109da6:	50                   	push   %eax
80109da7:	e8 f9 f7 ff ff       	call   801095a5 <H2N_ushort>
80109dac:	83 c4 10             	add    $0x10,%esp
80109daf:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80109db2:	66 89 42 0a          	mov    %ax,0xa(%edx)
  

  tcp_send->src_port = tcp_recv->dst_port;
80109db6:	8b 45 ec             	mov    -0x14(%ebp),%eax
80109db9:	0f b7 50 02          	movzwl 0x2(%eax),%edx
80109dbd:	8b 45 e0             	mov    -0x20(%ebp),%eax
80109dc0:	66 89 10             	mov    %dx,(%eax)
  tcp_send->dst_port = tcp_recv->src_port;
80109dc3:	8b 45 ec             	mov    -0x14(%ebp),%eax
80109dc6:	0f b7 10             	movzwl (%eax),%edx
80109dc9:	8b 45 e0             	mov    -0x20(%ebp),%eax
80109dcc:	66 89 50 02          	mov    %dx,0x2(%eax)
  tcp_send->seq_num = H2N_uint(seq_num);
80109dd0:	a1 64 6f 19 80       	mov    0x80196f64,%eax
80109dd5:	83 ec 0c             	sub    $0xc,%esp
80109dd8:	50                   	push   %eax
80109dd9:	e8 e9 f7 ff ff       	call   801095c7 <H2N_uint>
80109dde:	83 c4 10             	add    $0x10,%esp
80109de1:	8b 55 e0             	mov    -0x20(%ebp),%edx
80109de4:	89 42 04             	mov    %eax,0x4(%edx)
  tcp_send->ack_num = tcp_recv->seq_num + (1<<(8*3));
80109de7:	8b 45 ec             	mov    -0x14(%ebp),%eax
80109dea:	8b 40 04             	mov    0x4(%eax),%eax
80109ded:	8d 90 00 00 00 01    	lea    0x1000000(%eax),%edx
80109df3:	8b 45 e0             	mov    -0x20(%ebp),%eax
80109df6:	89 50 08             	mov    %edx,0x8(%eax)

  tcp_send->code_bits[0] = 0;
80109df9:	8b 45 e0             	mov    -0x20(%ebp),%eax
80109dfc:	c6 40 0c 00          	movb   $0x0,0xc(%eax)
  tcp_send->code_bits[1] = 0;
80109e00:	8b 45 e0             	mov    -0x20(%ebp),%eax
80109e03:	c6 40 0d 00          	movb   $0x0,0xd(%eax)
  tcp_send->code_bits[0] = 5<<4;
80109e07:	8b 45 e0             	mov    -0x20(%ebp),%eax
80109e0a:	c6 40 0c 50          	movb   $0x50,0xc(%eax)
  tcp_send->code_bits[1] = pkt_type;
80109e0e:	8b 45 14             	mov    0x14(%ebp),%eax
80109e11:	89 c2                	mov    %eax,%edx
80109e13:	8b 45 e0             	mov    -0x20(%ebp),%eax
80109e16:	88 50 0d             	mov    %dl,0xd(%eax)

  tcp_send->window = H2N_ushort(14480);
80109e19:	83 ec 0c             	sub    $0xc,%esp
80109e1c:	68 90 38 00 00       	push   $0x3890
80109e21:	e8 7f f7 ff ff       	call   801095a5 <H2N_ushort>
80109e26:	83 c4 10             	add    $0x10,%esp
80109e29:	8b 55 e0             	mov    -0x20(%ebp),%edx
80109e2c:	66 89 42 0e          	mov    %ax,0xe(%edx)
  tcp_send->urgent_ptr = 0;
80109e30:	8b 45 e0             	mov    -0x20(%ebp),%eax
80109e33:	66 c7 40 12 00 00    	movw   $0x0,0x12(%eax)
  tcp_send->chk_sum = 0;
80109e39:	8b 45 e0             	mov    -0x20(%ebp),%eax
80109e3c:	66 c7 40 10 00 00    	movw   $0x0,0x10(%eax)

  tcp_send->chk_sum = H2N_ushort(tcp_chksum((uint)(ipv4_send))+8);
80109e42:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80109e45:	83 ec 0c             	sub    $0xc,%esp
80109e48:	50                   	push   %eax
80109e49:	e8 1f 00 00 00       	call   80109e6d <tcp_chksum>
80109e4e:	83 c4 10             	add    $0x10,%esp
80109e51:	83 c0 08             	add    $0x8,%eax
80109e54:	0f b7 c0             	movzwl %ax,%eax
80109e57:	83 ec 0c             	sub    $0xc,%esp
80109e5a:	50                   	push   %eax
80109e5b:	e8 45 f7 ff ff       	call   801095a5 <H2N_ushort>
80109e60:	83 c4 10             	add    $0x10,%esp
80109e63:	8b 55 e0             	mov    -0x20(%ebp),%edx
80109e66:	66 89 42 10          	mov    %ax,0x10(%edx)


}
80109e6a:	90                   	nop
80109e6b:	c9                   	leave  
80109e6c:	c3                   	ret    

80109e6d <tcp_chksum>:

ushort tcp_chksum(uint tcp_addr){
80109e6d:	55                   	push   %ebp
80109e6e:	89 e5                	mov    %esp,%ebp
80109e70:	83 ec 38             	sub    $0x38,%esp
  struct ipv4_pkt *ipv4_p = (struct ipv4_pkt *)(tcp_addr);
80109e73:	8b 45 08             	mov    0x8(%ebp),%eax
80109e76:	89 45 e8             	mov    %eax,-0x18(%ebp)
  struct tcp_pkt *tcp_p = (struct tcp_pkt *)((uint)ipv4_p + sizeof(struct ipv4_pkt));
80109e79:	8b 45 e8             	mov    -0x18(%ebp),%eax
80109e7c:	83 c0 14             	add    $0x14,%eax
80109e7f:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  struct tcp_dummy tcp_dummy;
  
  memmove(tcp_dummy.src_ip,my_ip,4);
80109e82:	83 ec 04             	sub    $0x4,%esp
80109e85:	6a 04                	push   $0x4
80109e87:	68 e4 f4 10 80       	push   $0x8010f4e4
80109e8c:	8d 45 d4             	lea    -0x2c(%ebp),%eax
80109e8f:	50                   	push   %eax
80109e90:	e8 7a ad ff ff       	call   80104c0f <memmove>
80109e95:	83 c4 10             	add    $0x10,%esp
  memmove(tcp_dummy.dst_ip,ipv4_p->src_ip,4);
80109e98:	8b 45 e8             	mov    -0x18(%ebp),%eax
80109e9b:	83 c0 0c             	add    $0xc,%eax
80109e9e:	83 ec 04             	sub    $0x4,%esp
80109ea1:	6a 04                	push   $0x4
80109ea3:	50                   	push   %eax
80109ea4:	8d 45 d4             	lea    -0x2c(%ebp),%eax
80109ea7:	83 c0 04             	add    $0x4,%eax
80109eaa:	50                   	push   %eax
80109eab:	e8 5f ad ff ff       	call   80104c0f <memmove>
80109eb0:	83 c4 10             	add    $0x10,%esp
  tcp_dummy.padding = 0;
80109eb3:	c6 45 dc 00          	movb   $0x0,-0x24(%ebp)
  tcp_dummy.protocol = IPV4_TYPE_TCP;
80109eb7:	c6 45 dd 06          	movb   $0x6,-0x23(%ebp)
  tcp_dummy.tcp_len = H2N_ushort(N2H_ushort(ipv4_p->total_len) - sizeof(struct ipv4_pkt));
80109ebb:	8b 45 e8             	mov    -0x18(%ebp),%eax
80109ebe:	0f b7 40 02          	movzwl 0x2(%eax),%eax
80109ec2:	0f b7 c0             	movzwl %ax,%eax
80109ec5:	83 ec 0c             	sub    $0xc,%esp
80109ec8:	50                   	push   %eax
80109ec9:	e8 b5 f6 ff ff       	call   80109583 <N2H_ushort>
80109ece:	83 c4 10             	add    $0x10,%esp
80109ed1:	83 e8 14             	sub    $0x14,%eax
80109ed4:	0f b7 c0             	movzwl %ax,%eax
80109ed7:	83 ec 0c             	sub    $0xc,%esp
80109eda:	50                   	push   %eax
80109edb:	e8 c5 f6 ff ff       	call   801095a5 <H2N_ushort>
80109ee0:	83 c4 10             	add    $0x10,%esp
80109ee3:	66 89 45 de          	mov    %ax,-0x22(%ebp)
  uint chk_sum = 0;
80109ee7:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  uchar *bin = (uchar *)(&tcp_dummy);
80109eee:	8d 45 d4             	lea    -0x2c(%ebp),%eax
80109ef1:	89 45 e0             	mov    %eax,-0x20(%ebp)
  for(int i=0;i<6;i++){
80109ef4:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
80109efb:	eb 33                	jmp    80109f30 <tcp_chksum+0xc3>
    chk_sum += (bin[i*2]<<8)+bin[i*2+1];
80109efd:	8b 45 f0             	mov    -0x10(%ebp),%eax
80109f00:	01 c0                	add    %eax,%eax
80109f02:	89 c2                	mov    %eax,%edx
80109f04:	8b 45 e0             	mov    -0x20(%ebp),%eax
80109f07:	01 d0                	add    %edx,%eax
80109f09:	0f b6 00             	movzbl (%eax),%eax
80109f0c:	0f b6 c0             	movzbl %al,%eax
80109f0f:	c1 e0 08             	shl    $0x8,%eax
80109f12:	89 c2                	mov    %eax,%edx
80109f14:	8b 45 f0             	mov    -0x10(%ebp),%eax
80109f17:	01 c0                	add    %eax,%eax
80109f19:	8d 48 01             	lea    0x1(%eax),%ecx
80109f1c:	8b 45 e0             	mov    -0x20(%ebp),%eax
80109f1f:	01 c8                	add    %ecx,%eax
80109f21:	0f b6 00             	movzbl (%eax),%eax
80109f24:	0f b6 c0             	movzbl %al,%eax
80109f27:	01 d0                	add    %edx,%eax
80109f29:	01 45 f4             	add    %eax,-0xc(%ebp)
  for(int i=0;i<6;i++){
80109f2c:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
80109f30:	83 7d f0 05          	cmpl   $0x5,-0x10(%ebp)
80109f34:	7e c7                	jle    80109efd <tcp_chksum+0x90>
  }

  bin = (uchar *)(tcp_p);
80109f36:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80109f39:	89 45 e0             	mov    %eax,-0x20(%ebp)
  for(int i=0;i<(N2H_ushort(tcp_dummy.tcp_len)/2);i++){
80109f3c:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
80109f43:	eb 33                	jmp    80109f78 <tcp_chksum+0x10b>
    chk_sum += (bin[i*2]<<8)+bin[i*2+1];
80109f45:	8b 45 ec             	mov    -0x14(%ebp),%eax
80109f48:	01 c0                	add    %eax,%eax
80109f4a:	89 c2                	mov    %eax,%edx
80109f4c:	8b 45 e0             	mov    -0x20(%ebp),%eax
80109f4f:	01 d0                	add    %edx,%eax
80109f51:	0f b6 00             	movzbl (%eax),%eax
80109f54:	0f b6 c0             	movzbl %al,%eax
80109f57:	c1 e0 08             	shl    $0x8,%eax
80109f5a:	89 c2                	mov    %eax,%edx
80109f5c:	8b 45 ec             	mov    -0x14(%ebp),%eax
80109f5f:	01 c0                	add    %eax,%eax
80109f61:	8d 48 01             	lea    0x1(%eax),%ecx
80109f64:	8b 45 e0             	mov    -0x20(%ebp),%eax
80109f67:	01 c8                	add    %ecx,%eax
80109f69:	0f b6 00             	movzbl (%eax),%eax
80109f6c:	0f b6 c0             	movzbl %al,%eax
80109f6f:	01 d0                	add    %edx,%eax
80109f71:	01 45 f4             	add    %eax,-0xc(%ebp)
  for(int i=0;i<(N2H_ushort(tcp_dummy.tcp_len)/2);i++){
80109f74:	83 45 ec 01          	addl   $0x1,-0x14(%ebp)
80109f78:	0f b7 45 de          	movzwl -0x22(%ebp),%eax
80109f7c:	0f b7 c0             	movzwl %ax,%eax
80109f7f:	83 ec 0c             	sub    $0xc,%esp
80109f82:	50                   	push   %eax
80109f83:	e8 fb f5 ff ff       	call   80109583 <N2H_ushort>
80109f88:	83 c4 10             	add    $0x10,%esp
80109f8b:	66 d1 e8             	shr    %ax
80109f8e:	0f b7 c0             	movzwl %ax,%eax
80109f91:	39 45 ec             	cmp    %eax,-0x14(%ebp)
80109f94:	7c af                	jl     80109f45 <tcp_chksum+0xd8>
  }
  chk_sum += (chk_sum>>8*2);
80109f96:	8b 45 f4             	mov    -0xc(%ebp),%eax
80109f99:	c1 e8 10             	shr    $0x10,%eax
80109f9c:	01 45 f4             	add    %eax,-0xc(%ebp)
  return ~(chk_sum);
80109f9f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80109fa2:	f7 d0                	not    %eax
}
80109fa4:	c9                   	leave  
80109fa5:	c3                   	ret    

80109fa6 <tcp_fin>:

void tcp_fin(){
80109fa6:	55                   	push   %ebp
80109fa7:	89 e5                	mov    %esp,%ebp
  fin_flag =1;
80109fa9:	c7 05 68 6f 19 80 01 	movl   $0x1,0x80196f68
80109fb0:	00 00 00 
}
80109fb3:	90                   	nop
80109fb4:	5d                   	pop    %ebp
80109fb5:	c3                   	ret    

80109fb6 <http_proc>:
#include "defs.h"
#include "types.h"
#include "tcp.h"


void http_proc(uint recv, uint recv_size, uint send, uint *send_size){
80109fb6:	55                   	push   %ebp
80109fb7:	89 e5                	mov    %esp,%ebp
80109fb9:	83 ec 18             	sub    $0x18,%esp
  int len;
  len = http_strcpy((char *)send,"HTTP/1.0 200 OK \r\n",0);
80109fbc:	8b 45 10             	mov    0x10(%ebp),%eax
80109fbf:	83 ec 04             	sub    $0x4,%esp
80109fc2:	6a 00                	push   $0x0
80109fc4:	68 4b c1 10 80       	push   $0x8010c14b
80109fc9:	50                   	push   %eax
80109fca:	e8 65 00 00 00       	call   8010a034 <http_strcpy>
80109fcf:	83 c4 10             	add    $0x10,%esp
80109fd2:	89 45 f4             	mov    %eax,-0xc(%ebp)
  len += http_strcpy((char *)send,"Content-Type: text/html \r\n",len);
80109fd5:	8b 45 10             	mov    0x10(%ebp),%eax
80109fd8:	83 ec 04             	sub    $0x4,%esp
80109fdb:	ff 75 f4             	push   -0xc(%ebp)
80109fde:	68 5e c1 10 80       	push   $0x8010c15e
80109fe3:	50                   	push   %eax
80109fe4:	e8 4b 00 00 00       	call   8010a034 <http_strcpy>
80109fe9:	83 c4 10             	add    $0x10,%esp
80109fec:	01 45 f4             	add    %eax,-0xc(%ebp)
  len += http_strcpy((char *)send,"\r\nHello World!\r\n",len);
80109fef:	8b 45 10             	mov    0x10(%ebp),%eax
80109ff2:	83 ec 04             	sub    $0x4,%esp
80109ff5:	ff 75 f4             	push   -0xc(%ebp)
80109ff8:	68 79 c1 10 80       	push   $0x8010c179
80109ffd:	50                   	push   %eax
80109ffe:	e8 31 00 00 00       	call   8010a034 <http_strcpy>
8010a003:	83 c4 10             	add    $0x10,%esp
8010a006:	01 45 f4             	add    %eax,-0xc(%ebp)
  if(len%2 != 0){
8010a009:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010a00c:	83 e0 01             	and    $0x1,%eax
8010a00f:	85 c0                	test   %eax,%eax
8010a011:	74 11                	je     8010a024 <http_proc+0x6e>
    char *payload = (char *)send;
8010a013:	8b 45 10             	mov    0x10(%ebp),%eax
8010a016:	89 45 f0             	mov    %eax,-0x10(%ebp)
    payload[len] = 0;
8010a019:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010a01c:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010a01f:	01 d0                	add    %edx,%eax
8010a021:	c6 00 00             	movb   $0x0,(%eax)
  }
  *send_size = len;
8010a024:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010a027:	8b 45 14             	mov    0x14(%ebp),%eax
8010a02a:	89 10                	mov    %edx,(%eax)
  tcp_fin();
8010a02c:	e8 75 ff ff ff       	call   80109fa6 <tcp_fin>
}
8010a031:	90                   	nop
8010a032:	c9                   	leave  
8010a033:	c3                   	ret    

8010a034 <http_strcpy>:

int http_strcpy(char *dst,const char *src,int start_index){
8010a034:	55                   	push   %ebp
8010a035:	89 e5                	mov    %esp,%ebp
8010a037:	83 ec 10             	sub    $0x10,%esp
  int i = 0;
8010a03a:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while(src[i]){
8010a041:	eb 20                	jmp    8010a063 <http_strcpy+0x2f>
    dst[start_index+i] = src[i];
8010a043:	8b 55 fc             	mov    -0x4(%ebp),%edx
8010a046:	8b 45 0c             	mov    0xc(%ebp),%eax
8010a049:	01 d0                	add    %edx,%eax
8010a04b:	8b 4d 10             	mov    0x10(%ebp),%ecx
8010a04e:	8b 55 fc             	mov    -0x4(%ebp),%edx
8010a051:	01 ca                	add    %ecx,%edx
8010a053:	89 d1                	mov    %edx,%ecx
8010a055:	8b 55 08             	mov    0x8(%ebp),%edx
8010a058:	01 ca                	add    %ecx,%edx
8010a05a:	0f b6 00             	movzbl (%eax),%eax
8010a05d:	88 02                	mov    %al,(%edx)
    i++;
8010a05f:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
  while(src[i]){
8010a063:	8b 55 fc             	mov    -0x4(%ebp),%edx
8010a066:	8b 45 0c             	mov    0xc(%ebp),%eax
8010a069:	01 d0                	add    %edx,%eax
8010a06b:	0f b6 00             	movzbl (%eax),%eax
8010a06e:	84 c0                	test   %al,%al
8010a070:	75 d1                	jne    8010a043 <http_strcpy+0xf>
  }
  return i;
8010a072:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
8010a075:	c9                   	leave  
8010a076:	c3                   	ret    

8010a077 <ideinit>:
static int disksize;
static uchar *memdisk;

void
ideinit(void)
{
8010a077:	55                   	push   %ebp
8010a078:	89 e5                	mov    %esp,%ebp
  memdisk = _binary_fs_img_start;
8010a07a:	c7 05 70 6f 19 80 a2 	movl   $0x8010f5a2,0x80196f70
8010a081:	f5 10 80 
  disksize = (uint)_binary_fs_img_size/BSIZE;
8010a084:	b8 00 d0 07 00       	mov    $0x7d000,%eax
8010a089:	c1 e8 09             	shr    $0x9,%eax
8010a08c:	a3 6c 6f 19 80       	mov    %eax,0x80196f6c
}
8010a091:	90                   	nop
8010a092:	5d                   	pop    %ebp
8010a093:	c3                   	ret    

8010a094 <ideintr>:

// Interrupt handler.
void
ideintr(void)
{
8010a094:	55                   	push   %ebp
8010a095:	89 e5                	mov    %esp,%ebp
  // no-op
}
8010a097:	90                   	nop
8010a098:	5d                   	pop    %ebp
8010a099:	c3                   	ret    

8010a09a <iderw>:
// Sync buf with disk.
// If B_DIRTY is set, write buf to disk, clear B_DIRTY, set B_VALID.
// Else if B_VALID is not set, read buf from disk, set B_VALID.
void
iderw(struct buf *b)
{
8010a09a:	55                   	push   %ebp
8010a09b:	89 e5                	mov    %esp,%ebp
8010a09d:	83 ec 18             	sub    $0x18,%esp
  uchar *p;

  if(!holdingsleep(&b->lock))
8010a0a0:	8b 45 08             	mov    0x8(%ebp),%eax
8010a0a3:	83 c0 0c             	add    $0xc,%eax
8010a0a6:	83 ec 0c             	sub    $0xc,%esp
8010a0a9:	50                   	push   %eax
8010a0aa:	e8 9a a7 ff ff       	call   80104849 <holdingsleep>
8010a0af:	83 c4 10             	add    $0x10,%esp
8010a0b2:	85 c0                	test   %eax,%eax
8010a0b4:	75 0d                	jne    8010a0c3 <iderw+0x29>
    panic("iderw: buf not locked");
8010a0b6:	83 ec 0c             	sub    $0xc,%esp
8010a0b9:	68 8a c1 10 80       	push   $0x8010c18a
8010a0be:	e8 e6 64 ff ff       	call   801005a9 <panic>
  if((b->flags & (B_VALID|B_DIRTY)) == B_VALID)
8010a0c3:	8b 45 08             	mov    0x8(%ebp),%eax
8010a0c6:	8b 00                	mov    (%eax),%eax
8010a0c8:	83 e0 06             	and    $0x6,%eax
8010a0cb:	83 f8 02             	cmp    $0x2,%eax
8010a0ce:	75 0d                	jne    8010a0dd <iderw+0x43>
    panic("iderw: nothing to do");
8010a0d0:	83 ec 0c             	sub    $0xc,%esp
8010a0d3:	68 a0 c1 10 80       	push   $0x8010c1a0
8010a0d8:	e8 cc 64 ff ff       	call   801005a9 <panic>
  if(b->dev != 1)
8010a0dd:	8b 45 08             	mov    0x8(%ebp),%eax
8010a0e0:	8b 40 04             	mov    0x4(%eax),%eax
8010a0e3:	83 f8 01             	cmp    $0x1,%eax
8010a0e6:	74 0d                	je     8010a0f5 <iderw+0x5b>
    panic("iderw: request not for disk 1");
8010a0e8:	83 ec 0c             	sub    $0xc,%esp
8010a0eb:	68 b5 c1 10 80       	push   $0x8010c1b5
8010a0f0:	e8 b4 64 ff ff       	call   801005a9 <panic>
  if(b->blockno >= disksize)
8010a0f5:	8b 45 08             	mov    0x8(%ebp),%eax
8010a0f8:	8b 40 08             	mov    0x8(%eax),%eax
8010a0fb:	8b 15 6c 6f 19 80    	mov    0x80196f6c,%edx
8010a101:	39 d0                	cmp    %edx,%eax
8010a103:	72 0d                	jb     8010a112 <iderw+0x78>
    panic("iderw: block out of range");
8010a105:	83 ec 0c             	sub    $0xc,%esp
8010a108:	68 d3 c1 10 80       	push   $0x8010c1d3
8010a10d:	e8 97 64 ff ff       	call   801005a9 <panic>

  p = memdisk + b->blockno*BSIZE;
8010a112:	8b 15 70 6f 19 80    	mov    0x80196f70,%edx
8010a118:	8b 45 08             	mov    0x8(%ebp),%eax
8010a11b:	8b 40 08             	mov    0x8(%eax),%eax
8010a11e:	c1 e0 09             	shl    $0x9,%eax
8010a121:	01 d0                	add    %edx,%eax
8010a123:	89 45 f4             	mov    %eax,-0xc(%ebp)

  if(b->flags & B_DIRTY){
8010a126:	8b 45 08             	mov    0x8(%ebp),%eax
8010a129:	8b 00                	mov    (%eax),%eax
8010a12b:	83 e0 04             	and    $0x4,%eax
8010a12e:	85 c0                	test   %eax,%eax
8010a130:	74 2b                	je     8010a15d <iderw+0xc3>
    b->flags &= ~B_DIRTY;
8010a132:	8b 45 08             	mov    0x8(%ebp),%eax
8010a135:	8b 00                	mov    (%eax),%eax
8010a137:	83 e0 fb             	and    $0xfffffffb,%eax
8010a13a:	89 c2                	mov    %eax,%edx
8010a13c:	8b 45 08             	mov    0x8(%ebp),%eax
8010a13f:	89 10                	mov    %edx,(%eax)
    memmove(p, b->data, BSIZE);
8010a141:	8b 45 08             	mov    0x8(%ebp),%eax
8010a144:	83 c0 5c             	add    $0x5c,%eax
8010a147:	83 ec 04             	sub    $0x4,%esp
8010a14a:	68 00 02 00 00       	push   $0x200
8010a14f:	50                   	push   %eax
8010a150:	ff 75 f4             	push   -0xc(%ebp)
8010a153:	e8 b7 aa ff ff       	call   80104c0f <memmove>
8010a158:	83 c4 10             	add    $0x10,%esp
8010a15b:	eb 1a                	jmp    8010a177 <iderw+0xdd>
  } else
    memmove(b->data, p, BSIZE);
8010a15d:	8b 45 08             	mov    0x8(%ebp),%eax
8010a160:	83 c0 5c             	add    $0x5c,%eax
8010a163:	83 ec 04             	sub    $0x4,%esp
8010a166:	68 00 02 00 00       	push   $0x200
8010a16b:	ff 75 f4             	push   -0xc(%ebp)
8010a16e:	50                   	push   %eax
8010a16f:	e8 9b aa ff ff       	call   80104c0f <memmove>
8010a174:	83 c4 10             	add    $0x10,%esp
  b->flags |= B_VALID;
8010a177:	8b 45 08             	mov    0x8(%ebp),%eax
8010a17a:	8b 00                	mov    (%eax),%eax
8010a17c:	83 c8 02             	or     $0x2,%eax
8010a17f:	89 c2                	mov    %eax,%edx
8010a181:	8b 45 08             	mov    0x8(%ebp),%eax
8010a184:	89 10                	mov    %edx,(%eax)
}
8010a186:	90                   	nop
8010a187:	c9                   	leave  
8010a188:	c3                   	ret    
