
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
8010006f:	68 e0 a2 10 80       	push   $0x8010a2e0
80100074:	68 00 d0 18 80       	push   $0x8018d000
80100079:	e8 19 49 00 00       	call   80104997 <initlock>
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
801000bd:	68 e7 a2 10 80       	push   $0x8010a2e7
801000c2:	50                   	push   %eax
801000c3:	e8 72 47 00 00       	call   8010483a <initsleeplock>
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
80100101:	e8 b3 48 00 00       	call   801049b9 <acquire>
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
80100140:	e8 e2 48 00 00       	call   80104a27 <release>
80100145:	83 c4 10             	add    $0x10,%esp
      acquiresleep(&b->lock);
80100148:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010014b:	83 c0 0c             	add    $0xc,%eax
8010014e:	83 ec 0c             	sub    $0xc,%esp
80100151:	50                   	push   %eax
80100152:	e8 1f 47 00 00       	call   80104876 <acquiresleep>
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
801001c1:	e8 61 48 00 00       	call   80104a27 <release>
801001c6:	83 c4 10             	add    $0x10,%esp
      acquiresleep(&b->lock);
801001c9:	8b 45 f4             	mov    -0xc(%ebp),%eax
801001cc:	83 c0 0c             	add    $0xc,%eax
801001cf:	83 ec 0c             	sub    $0xc,%esp
801001d2:	50                   	push   %eax
801001d3:	e8 9e 46 00 00       	call   80104876 <acquiresleep>
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
801001f5:	68 ee a2 10 80       	push   $0x8010a2ee
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
8010022d:	e8 b2 9f 00 00       	call   8010a1e4 <iderw>
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
8010024a:	e8 d9 46 00 00       	call   80104928 <holdingsleep>
8010024f:	83 c4 10             	add    $0x10,%esp
80100252:	85 c0                	test   %eax,%eax
80100254:	75 0d                	jne    80100263 <bwrite+0x29>
    panic("bwrite");
80100256:	83 ec 0c             	sub    $0xc,%esp
80100259:	68 ff a2 10 80       	push   $0x8010a2ff
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
80100278:	e8 67 9f 00 00       	call   8010a1e4 <iderw>
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
80100293:	e8 90 46 00 00       	call   80104928 <holdingsleep>
80100298:	83 c4 10             	add    $0x10,%esp
8010029b:	85 c0                	test   %eax,%eax
8010029d:	75 0d                	jne    801002ac <brelse+0x29>
    panic("brelse");
8010029f:	83 ec 0c             	sub    $0xc,%esp
801002a2:	68 06 a3 10 80       	push   $0x8010a306
801002a7:	e8 fd 02 00 00       	call   801005a9 <panic>

  releasesleep(&b->lock);
801002ac:	8b 45 08             	mov    0x8(%ebp),%eax
801002af:	83 c0 0c             	add    $0xc,%eax
801002b2:	83 ec 0c             	sub    $0xc,%esp
801002b5:	50                   	push   %eax
801002b6:	e8 1f 46 00 00       	call   801048da <releasesleep>
801002bb:	83 c4 10             	add    $0x10,%esp

  acquire(&bcache.lock);
801002be:	83 ec 0c             	sub    $0xc,%esp
801002c1:	68 00 d0 18 80       	push   $0x8018d000
801002c6:	e8 ee 46 00 00       	call   801049b9 <acquire>
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
80100336:	e8 ec 46 00 00       	call   80104a27 <release>
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
80100410:	e8 a4 45 00 00       	call   801049b9 <acquire>
80100415:	83 c4 10             	add    $0x10,%esp

  if (fmt == 0)
80100418:	8b 45 08             	mov    0x8(%ebp),%eax
8010041b:	85 c0                	test   %eax,%eax
8010041d:	75 0d                	jne    8010042c <cprintf+0x38>
    panic("null fmt");
8010041f:	83 ec 0c             	sub    $0xc,%esp
80100422:	68 0d a3 10 80       	push   $0x8010a30d
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
80100510:	c7 45 ec 16 a3 10 80 	movl   $0x8010a316,-0x14(%ebp)
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
8010059e:	e8 84 44 00 00       	call   80104a27 <release>
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
801005c7:	68 1d a3 10 80       	push   $0x8010a31d
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
801005e6:	68 31 a3 10 80       	push   $0x8010a331
801005eb:	e8 04 fe ff ff       	call   801003f4 <cprintf>
801005f0:	83 c4 10             	add    $0x10,%esp
  getcallerpcs(&s, pcs);
801005f3:	83 ec 08             	sub    $0x8,%esp
801005f6:	8d 45 cc             	lea    -0x34(%ebp),%eax
801005f9:	50                   	push   %eax
801005fa:	8d 45 08             	lea    0x8(%ebp),%eax
801005fd:	50                   	push   %eax
801005fe:	e8 76 44 00 00       	call   80104a79 <getcallerpcs>
80100603:	83 c4 10             	add    $0x10,%esp
  for(i=0; i<10; i++)
80100606:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
8010060d:	eb 1c                	jmp    8010062b <panic+0x82>
    cprintf(" %p", pcs[i]);
8010060f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100612:	8b 44 85 cc          	mov    -0x34(%ebp,%eax,4),%eax
80100616:	83 ec 08             	sub    $0x8,%esp
80100619:	50                   	push   %eax
8010061a:	68 33 a3 10 80       	push   $0x8010a333
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
801006a0:	e8 96 7a 00 00       	call   8010813b <graphic_scroll_up>
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
801006f3:	e8 43 7a 00 00       	call   8010813b <graphic_scroll_up>
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
80100757:	e8 4a 7a 00 00       	call   801081a6 <font_render>
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
80100793:	e8 1a 5e 00 00       	call   801065b2 <uartputc>
80100798:	83 c4 10             	add    $0x10,%esp
8010079b:	83 ec 0c             	sub    $0xc,%esp
8010079e:	6a 20                	push   $0x20
801007a0:	e8 0d 5e 00 00       	call   801065b2 <uartputc>
801007a5:	83 c4 10             	add    $0x10,%esp
801007a8:	83 ec 0c             	sub    $0xc,%esp
801007ab:	6a 08                	push   $0x8
801007ad:	e8 00 5e 00 00       	call   801065b2 <uartputc>
801007b2:	83 c4 10             	add    $0x10,%esp
801007b5:	eb 0e                	jmp    801007c5 <consputc+0x56>
  } else {
    uartputc(c);
801007b7:	83 ec 0c             	sub    $0xc,%esp
801007ba:	ff 75 08             	push   0x8(%ebp)
801007bd:	e8 f0 5d 00 00       	call   801065b2 <uartputc>
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
801007eb:	e8 c9 41 00 00       	call   801049b9 <acquire>
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
8010093f:	e8 3b 3d 00 00       	call   8010467f <wakeup>
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
80100962:	e8 c0 40 00 00       	call   80104a27 <release>
80100967:	83 c4 10             	add    $0x10,%esp
  if(doprocdump) {
8010096a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
8010096e:	74 05                	je     80100975 <consoleintr+0x19f>
    procdump();  // now call procdump() wo. cons.lock held
80100970:	e8 c8 3d 00 00       	call   8010473d <procdump>
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
8010099a:	e8 1a 40 00 00       	call   801049b9 <acquire>
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
801009bb:	e8 67 40 00 00       	call   80104a27 <release>
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
801009e8:	e8 a8 3b 00 00       	call   80104595 <sleep>
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
80100a66:	e8 bc 3f 00 00       	call   80104a27 <release>
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
80100aa2:	e8 12 3f 00 00       	call   801049b9 <acquire>
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
80100ae4:	e8 3e 3f 00 00       	call   80104a27 <release>
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
80100b12:	68 37 a3 10 80       	push   $0x8010a337
80100b17:	68 00 1a 19 80       	push   $0x80191a00
80100b1c:	e8 76 3e 00 00       	call   80104997 <initlock>
80100b21:	83 c4 10             	add    $0x10,%esp

  devsw[CONSOLE].write = consolewrite;
80100b24:	c7 05 4c 1a 19 80 86 	movl   $0x80100a86,0x80191a4c
80100b2b:	0a 10 80 
  devsw[CONSOLE].read = consoleread;
80100b2e:	c7 05 48 1a 19 80 78 	movl   $0x80100978,0x80191a48
80100b35:	09 10 80 
  
  char *p;
  for(p="Starting XV6_UEFI...\n"; *p; p++)
80100b38:	c7 45 f4 3f a3 10 80 	movl   $0x8010a33f,-0xc(%ebp)
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
80100bb5:	68 55 a3 10 80       	push   $0x8010a355
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
80100c11:	e8 98 69 00 00       	call   801075ae <setupkvm>
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
80100cb7:	e8 eb 6c 00 00       	call   801079a7 <allocuvm>
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
80100cfd:	e8 d8 6b 00 00       	call   801078da <loaduvm>
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
80100d6c:	e8 36 6c 00 00       	call   801079a7 <allocuvm>
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
80100d90:	e8 74 6e 00 00       	call   80107c09 <clearpteu>
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
80100dc9:	e8 af 40 00 00       	call   80104e7d <strlen>
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
80100df6:	e8 82 40 00 00       	call   80104e7d <strlen>
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
80100e1c:	e8 87 6f 00 00       	call   80107da8 <copyout>
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
80100eb8:	e8 eb 6e 00 00       	call   80107da8 <copyout>
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
80100f06:	e8 27 3f 00 00       	call   80104e32 <safestrcpy>
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
80100f49:	e8 7d 67 00 00       	call   801076cb <switchuvm>
80100f4e:	83 c4 10             	add    $0x10,%esp
  freevm(oldpgdir);
80100f51:	83 ec 0c             	sub    $0xc,%esp
80100f54:	ff 75 cc             	push   -0x34(%ebp)
80100f57:	e8 14 6c 00 00       	call   80107b70 <freevm>
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
80100f97:	e8 d4 6b 00 00       	call   80107b70 <freevm>
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
80100fc8:	68 61 a3 10 80       	push   $0x8010a361
80100fcd:	68 a0 1a 19 80       	push   $0x80191aa0
80100fd2:	e8 c0 39 00 00       	call   80104997 <initlock>
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
80100feb:	e8 c9 39 00 00       	call   801049b9 <acquire>
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
80101018:	e8 0a 3a 00 00       	call   80104a27 <release>
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
8010103b:	e8 e7 39 00 00       	call   80104a27 <release>
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
80101058:	e8 5c 39 00 00       	call   801049b9 <acquire>
8010105d:	83 c4 10             	add    $0x10,%esp
  if(f->ref < 1)
80101060:	8b 45 08             	mov    0x8(%ebp),%eax
80101063:	8b 40 04             	mov    0x4(%eax),%eax
80101066:	85 c0                	test   %eax,%eax
80101068:	7f 0d                	jg     80101077 <filedup+0x2d>
    panic("filedup");
8010106a:	83 ec 0c             	sub    $0xc,%esp
8010106d:	68 68 a3 10 80       	push   $0x8010a368
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
8010108e:	e8 94 39 00 00       	call   80104a27 <release>
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
801010a9:	e8 0b 39 00 00       	call   801049b9 <acquire>
801010ae:	83 c4 10             	add    $0x10,%esp
  if(f->ref < 1)
801010b1:	8b 45 08             	mov    0x8(%ebp),%eax
801010b4:	8b 40 04             	mov    0x4(%eax),%eax
801010b7:	85 c0                	test   %eax,%eax
801010b9:	7f 0d                	jg     801010c8 <fileclose+0x2d>
    panic("fileclose");
801010bb:	83 ec 0c             	sub    $0xc,%esp
801010be:	68 70 a3 10 80       	push   $0x8010a370
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
801010e9:	e8 39 39 00 00       	call   80104a27 <release>
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
80101137:	e8 eb 38 00 00       	call   80104a27 <release>
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
80101286:	68 7a a3 10 80       	push   $0x8010a37a
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
80101389:	68 83 a3 10 80       	push   $0x8010a383
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
801013bf:	68 93 a3 10 80       	push   $0x8010a393
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
801013f7:	e8 f2 38 00 00       	call   80104cee <memmove>
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
8010143d:	e8 ed 37 00 00       	call   80104c2f <memset>
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
8010159c:	68 a0 a3 10 80       	push   $0x8010a3a0
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
80101627:	68 b6 a3 10 80       	push   $0x8010a3b6
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
8010168b:	68 c9 a3 10 80       	push   $0x8010a3c9
80101690:	68 60 24 19 80       	push   $0x80192460
80101695:	e8 fd 32 00 00       	call   80104997 <initlock>
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
801016c1:	68 d0 a3 10 80       	push   $0x8010a3d0
801016c6:	50                   	push   %eax
801016c7:	e8 6e 31 00 00       	call   8010483a <initsleeplock>
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
80101720:	68 d8 a3 10 80       	push   $0x8010a3d8
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
80101799:	e8 91 34 00 00       	call   80104c2f <memset>
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
80101801:	68 2b a4 10 80       	push   $0x8010a42b
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
801018a7:	e8 42 34 00 00       	call   80104cee <memmove>
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
801018dc:	e8 d8 30 00 00       	call   801049b9 <acquire>
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
8010192a:	e8 f8 30 00 00       	call   80104a27 <release>
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
80101966:	68 3d a4 10 80       	push   $0x8010a43d
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
801019a3:	e8 7f 30 00 00       	call   80104a27 <release>
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
801019be:	e8 f6 2f 00 00       	call   801049b9 <acquire>
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
801019dd:	e8 45 30 00 00       	call   80104a27 <release>
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
80101a03:	68 4d a4 10 80       	push   $0x8010a44d
80101a08:	e8 9c eb ff ff       	call   801005a9 <panic>

  acquiresleep(&ip->lock);
80101a0d:	8b 45 08             	mov    0x8(%ebp),%eax
80101a10:	83 c0 0c             	add    $0xc,%eax
80101a13:	83 ec 0c             	sub    $0xc,%esp
80101a16:	50                   	push   %eax
80101a17:	e8 5a 2e 00 00       	call   80104876 <acquiresleep>
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
80101ac1:	e8 28 32 00 00       	call   80104cee <memmove>
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
80101af0:	68 53 a4 10 80       	push   $0x8010a453
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
80101b13:	e8 10 2e 00 00       	call   80104928 <holdingsleep>
80101b18:	83 c4 10             	add    $0x10,%esp
80101b1b:	85 c0                	test   %eax,%eax
80101b1d:	74 0a                	je     80101b29 <iunlock+0x2c>
80101b1f:	8b 45 08             	mov    0x8(%ebp),%eax
80101b22:	8b 40 08             	mov    0x8(%eax),%eax
80101b25:	85 c0                	test   %eax,%eax
80101b27:	7f 0d                	jg     80101b36 <iunlock+0x39>
    panic("iunlock");
80101b29:	83 ec 0c             	sub    $0xc,%esp
80101b2c:	68 62 a4 10 80       	push   $0x8010a462
80101b31:	e8 73 ea ff ff       	call   801005a9 <panic>

  releasesleep(&ip->lock);
80101b36:	8b 45 08             	mov    0x8(%ebp),%eax
80101b39:	83 c0 0c             	add    $0xc,%eax
80101b3c:	83 ec 0c             	sub    $0xc,%esp
80101b3f:	50                   	push   %eax
80101b40:	e8 95 2d 00 00       	call   801048da <releasesleep>
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
80101b5b:	e8 16 2d 00 00       	call   80104876 <acquiresleep>
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
80101b81:	e8 33 2e 00 00       	call   801049b9 <acquire>
80101b86:	83 c4 10             	add    $0x10,%esp
    int r = ip->ref;
80101b89:	8b 45 08             	mov    0x8(%ebp),%eax
80101b8c:	8b 40 08             	mov    0x8(%eax),%eax
80101b8f:	89 45 f4             	mov    %eax,-0xc(%ebp)
    release(&icache.lock);
80101b92:	83 ec 0c             	sub    $0xc,%esp
80101b95:	68 60 24 19 80       	push   $0x80192460
80101b9a:	e8 88 2e 00 00       	call   80104a27 <release>
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
80101be1:	e8 f4 2c 00 00       	call   801048da <releasesleep>
80101be6:	83 c4 10             	add    $0x10,%esp

  acquire(&icache.lock);
80101be9:	83 ec 0c             	sub    $0xc,%esp
80101bec:	68 60 24 19 80       	push   $0x80192460
80101bf1:	e8 c3 2d 00 00       	call   801049b9 <acquire>
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
80101c10:	e8 12 2e 00 00       	call   80104a27 <release>
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
80101d54:	68 6a a4 10 80       	push   $0x8010a46a
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
80101ff2:	e8 f7 2c 00 00       	call   80104cee <memmove>
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
80102142:	e8 a7 2b 00 00       	call   80104cee <memmove>
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
801021c2:	e8 bd 2b 00 00       	call   80104d84 <strncmp>
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
801021e2:	68 7d a4 10 80       	push   $0x8010a47d
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
80102211:	68 8f a4 10 80       	push   $0x8010a48f
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
801022e6:	68 9e a4 10 80       	push   $0x8010a49e
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
80102321:	e8 b4 2a 00 00       	call   80104dda <strncpy>
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
8010234d:	68 ab a4 10 80       	push   $0x8010a4ab
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
801023bf:	e8 2a 29 00 00       	call   80104cee <memmove>
801023c4:	83 c4 10             	add    $0x10,%esp
801023c7:	eb 26                	jmp    801023ef <skipelem+0x91>
  else {
    memmove(name, s, len);
801023c9:	8b 45 f0             	mov    -0x10(%ebp),%eax
801023cc:	83 ec 04             	sub    $0x4,%esp
801023cf:	50                   	push   %eax
801023d0:	ff 75 f4             	push   -0xc(%ebp)
801023d3:	ff 75 0c             	push   0xc(%ebp)
801023d6:	e8 13 29 00 00       	call   80104cee <memmove>
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
801025cd:	68 b4 a4 10 80       	push   $0x8010a4b4
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
80102674:	68 e6 a4 10 80       	push   $0x8010a4e6
80102679:	68 c0 40 19 80       	push   $0x801940c0
8010267e:	e8 14 23 00 00       	call   80104997 <initlock>
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
80102733:	68 eb a4 10 80       	push   $0x8010a4eb
80102738:	e8 6c de ff ff       	call   801005a9 <panic>

  // Fill with junk to catch dangling refs.
  memset(v, 1, PGSIZE);
8010273d:	83 ec 04             	sub    $0x4,%esp
80102740:	68 00 10 00 00       	push   $0x1000
80102745:	6a 01                	push   $0x1
80102747:	ff 75 08             	push   0x8(%ebp)
8010274a:	e8 e0 24 00 00       	call   80104c2f <memset>
8010274f:	83 c4 10             	add    $0x10,%esp

  if(kmem.use_lock)
80102752:	a1 f4 40 19 80       	mov    0x801940f4,%eax
80102757:	85 c0                	test   %eax,%eax
80102759:	74 10                	je     8010276b <kfree+0x65>
    acquire(&kmem.lock);
8010275b:	83 ec 0c             	sub    $0xc,%esp
8010275e:	68 c0 40 19 80       	push   $0x801940c0
80102763:	e8 51 22 00 00       	call   801049b9 <acquire>
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
80102795:	e8 8d 22 00 00       	call   80104a27 <release>
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
801027b7:	e8 fd 21 00 00       	call   801049b9 <acquire>
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
801027e8:	e8 3a 22 00 00       	call   80104a27 <release>
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
80102d12:	e8 7f 1f 00 00       	call   80104c96 <memcmp>
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
80102e26:	68 f1 a4 10 80       	push   $0x8010a4f1
80102e2b:	68 20 41 19 80       	push   $0x80194120
80102e30:	e8 62 1b 00 00       	call   80104997 <initlock>
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
80102edb:	e8 0e 1e 00 00       	call   80104cee <memmove>
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
8010304a:	e8 6a 19 00 00       	call   801049b9 <acquire>
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
80103068:	e8 28 15 00 00       	call   80104595 <sleep>
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
8010309d:	e8 f3 14 00 00       	call   80104595 <sleep>
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
801030bc:	e8 66 19 00 00       	call   80104a27 <release>
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
801030dd:	e8 d7 18 00 00       	call   801049b9 <acquire>
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
801030fe:	68 f5 a4 10 80       	push   $0x8010a4f5
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
8010312c:	e8 4e 15 00 00       	call   8010467f <wakeup>
80103131:	83 c4 10             	add    $0x10,%esp
  }
  release(&log.lock);
80103134:	83 ec 0c             	sub    $0xc,%esp
80103137:	68 20 41 19 80       	push   $0x80194120
8010313c:	e8 e6 18 00 00       	call   80104a27 <release>
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
80103157:	e8 5d 18 00 00       	call   801049b9 <acquire>
8010315c:	83 c4 10             	add    $0x10,%esp
    log.committing = 0;
8010315f:	c7 05 60 41 19 80 00 	movl   $0x0,0x80194160
80103166:	00 00 00 
    wakeup(&log);
80103169:	83 ec 0c             	sub    $0xc,%esp
8010316c:	68 20 41 19 80       	push   $0x80194120
80103171:	e8 09 15 00 00       	call   8010467f <wakeup>
80103176:	83 c4 10             	add    $0x10,%esp
    release(&log.lock);
80103179:	83 ec 0c             	sub    $0xc,%esp
8010317c:	68 20 41 19 80       	push   $0x80194120
80103181:	e8 a1 18 00 00       	call   80104a27 <release>
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
801031fd:	e8 ec 1a 00 00       	call   80104cee <memmove>
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
8010329a:	68 04 a5 10 80       	push   $0x8010a504
8010329f:	e8 05 d3 ff ff       	call   801005a9 <panic>
  if (log.outstanding < 1)
801032a4:	a1 5c 41 19 80       	mov    0x8019415c,%eax
801032a9:	85 c0                	test   %eax,%eax
801032ab:	7f 0d                	jg     801032ba <log_write+0x45>
    panic("log_write outside of trans");
801032ad:	83 ec 0c             	sub    $0xc,%esp
801032b0:	68 1a a5 10 80       	push   $0x8010a51a
801032b5:	e8 ef d2 ff ff       	call   801005a9 <panic>

  acquire(&log.lock);
801032ba:	83 ec 0c             	sub    $0xc,%esp
801032bd:	68 20 41 19 80       	push   $0x80194120
801032c2:	e8 f2 16 00 00       	call   801049b9 <acquire>
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
80103340:	e8 e2 16 00 00       	call   80104a27 <release>
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
80103376:	e8 05 4d 00 00       	call   80108080 <graphic_init>
  kinit1(end, P2V(4*1024*1024)); // phys page allocator
8010337b:	83 ec 08             	sub    $0x8,%esp
8010337e:	68 00 00 40 80       	push   $0x80400000
80103383:	68 00 90 19 80       	push   $0x80199000
80103388:	e8 de f2 ff ff       	call   8010266b <kinit1>
8010338d:	83 c4 10             	add    $0x10,%esp
  kvmalloc();      // kernel page table
80103390:	e8 05 43 00 00       	call   8010769a <kvmalloc>
  mpinit_uefi();
80103395:	e8 ac 4a 00 00       	call   80107e46 <mpinit_uefi>
  lapicinit();     // interrupt controller
8010339a:	e8 3c f6 ff ff       	call   801029db <lapicinit>
  seginit();       // segment descriptors
8010339f:	e8 8e 3d 00 00       	call   80107132 <seginit>
  picinit();    // disable pic
801033a4:	e8 9d 01 00 00       	call   80103546 <picinit>
  ioapicinit();    // another interrupt controller
801033a9:	e8 d8 f1 ff ff       	call   80102586 <ioapicinit>
  consoleinit();   // console hardware
801033ae:	e8 4c d7 ff ff       	call   80100aff <consoleinit>
  uartinit();      // serial port
801033b3:	e8 13 31 00 00       	call   801064cb <uartinit>
  pinit();         // process table
801033b8:	e8 c2 05 00 00       	call   8010397f <pinit>
  tvinit();        // trap vectors
801033bd:	e8 da 2c 00 00       	call   8010609c <tvinit>
  binit();         // buffer cache
801033c2:	e8 9f cc ff ff       	call   80100066 <binit>
  fileinit();      // file table
801033c7:	e8 f3 db ff ff       	call   80100fbf <fileinit>
  ideinit();       // disk 
801033cc:	e8 f0 6d 00 00       	call   8010a1c1 <ideinit>
  startothers();   // start other processors
801033d1:	e8 8a 00 00 00       	call   80103460 <startothers>
  kinit2(P2V(4*1024*1024), P2V(PHYSTOP)); // must come after startothers()
801033d6:	83 ec 08             	sub    $0x8,%esp
801033d9:	68 00 00 00 a0       	push   $0xa0000000
801033de:	68 00 00 40 80       	push   $0x80400000
801033e3:	e8 bc f2 ff ff       	call   801026a4 <kinit2>
801033e8:	83 c4 10             	add    $0x10,%esp
  pci_init();
801033eb:	e8 e9 4e 00 00       	call   801082d9 <pci_init>
  arp_scan();
801033f0:	e8 20 5c 00 00       	call   80109015 <arp_scan>
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
80103405:	e8 a8 42 00 00       	call   801076b2 <switchkvm>
  seginit();
8010340a:	e8 23 3d 00 00       	call   80107132 <seginit>
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
80103431:	68 35 a5 10 80       	push   $0x8010a535
80103436:	e8 b9 cf ff ff       	call   801003f4 <cprintf>
8010343b:	83 c4 10             	add    $0x10,%esp
  idtinit();       // load idt register
8010343e:	e8 cf 2d 00 00       	call   80106212 <idtinit>
  xchg(&(mycpu()->started), 1); // tell startothers() we're up
80103443:	e8 70 05 00 00       	call   801039b8 <mycpu>
80103448:	05 a0 00 00 00       	add    $0xa0,%eax
8010344d:	83 ec 08             	sub    $0x8,%esp
80103450:	6a 01                	push   $0x1
80103452:	50                   	push   %eax
80103453:	e8 f3 fe ff ff       	call   8010334b <xchg>
80103458:	83 c4 10             	add    $0x10,%esp
  scheduler();     // start running processes
8010345b:	e8 41 0f 00 00       	call   801043a1 <scheduler>

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
8010347e:	e8 6b 18 00 00       	call   80104cee <memmove>
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
80103607:	68 49 a5 10 80       	push   $0x8010a549
8010360c:	50                   	push   %eax
8010360d:	e8 85 13 00 00       	call   80104997 <initlock>
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
801036cc:	e8 e8 12 00 00       	call   801049b9 <acquire>
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
801036f3:	e8 87 0f 00 00       	call   8010467f <wakeup>
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
80103716:	e8 64 0f 00 00       	call   8010467f <wakeup>
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
8010373f:	e8 e3 12 00 00       	call   80104a27 <release>
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
8010375e:	e8 c4 12 00 00       	call   80104a27 <release>
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
80103778:	e8 3c 12 00 00       	call   801049b9 <acquire>
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
801037ac:	e8 76 12 00 00       	call   80104a27 <release>
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
801037ca:	e8 b0 0e 00 00       	call   8010467f <wakeup>
801037cf:	83 c4 10             	add    $0x10,%esp
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
801037d2:	8b 45 08             	mov    0x8(%ebp),%eax
801037d5:	8b 55 08             	mov    0x8(%ebp),%edx
801037d8:	81 c2 38 02 00 00    	add    $0x238,%edx
801037de:	83 ec 08             	sub    $0x8,%esp
801037e1:	50                   	push   %eax
801037e2:	52                   	push   %edx
801037e3:	e8 ad 0d 00 00       	call   80104595 <sleep>
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
8010384d:	e8 2d 0e 00 00       	call   8010467f <wakeup>
80103852:	83 c4 10             	add    $0x10,%esp
  release(&p->lock);
80103855:	8b 45 08             	mov    0x8(%ebp),%eax
80103858:	83 ec 0c             	sub    $0xc,%esp
8010385b:	50                   	push   %eax
8010385c:	e8 c6 11 00 00       	call   80104a27 <release>
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
80103879:	e8 3b 11 00 00       	call   801049b9 <acquire>
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
80103896:	e8 8c 11 00 00       	call   80104a27 <release>
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
801038b9:	e8 d7 0c 00 00       	call   80104595 <sleep>
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
8010394c:	e8 2e 0d 00 00       	call   8010467f <wakeup>
80103951:	83 c4 10             	add    $0x10,%esp
  release(&p->lock);
80103954:	8b 45 08             	mov    0x8(%ebp),%eax
80103957:	83 ec 0c             	sub    $0xc,%esp
8010395a:	50                   	push   %eax
8010395b:	e8 c7 10 00 00       	call   80104a27 <release>
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
80103988:	68 50 a5 10 80       	push   $0x8010a550
8010398d:	68 00 42 19 80       	push   $0x80194200
80103992:	e8 00 10 00 00       	call   80104997 <initlock>
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
801039cf:	68 58 a5 10 80       	push   $0x8010a558
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
80103a24:	68 7e a5 10 80       	push   $0x8010a57e
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
80103a36:	e8 e9 10 00 00       	call   80104b24 <pushcli>
  c = mycpu();
80103a3b:	e8 78 ff ff ff       	call   801039b8 <mycpu>
80103a40:	89 45 f4             	mov    %eax,-0xc(%ebp)
  p = c->proc;
80103a43:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103a46:	8b 80 ac 00 00 00    	mov    0xac(%eax),%eax
80103a4c:	89 45 f0             	mov    %eax,-0x10(%ebp)
  popcli();
80103a4f:	e8 1d 11 00 00       	call   80104b71 <popcli>
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
80103a67:	e8 4d 0f 00 00       	call   801049b9 <acquire>
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
80103a9a:	e8 88 0f 00 00       	call   80104a27 <release>
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
80103ad3:	e8 4f 0f 00 00       	call   80104a27 <release>
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
80103b20:	ba 56 60 10 80       	mov    $0x80106056,%edx
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
80103b45:	e8 e5 10 00 00       	call   80104c2f <memset>
80103b4a:	83 c4 10             	add    $0x10,%esp
  p->context->eip = (uint)forkret;
80103b4d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103b50:	8b 40 1c             	mov    0x1c(%eax),%eax
80103b53:	ba 4f 45 10 80       	mov    $0x8010454f,%edx
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
80103b76:	e8 33 3a 00 00       	call   801075ae <setupkvm>
80103b7b:	8b 55 f4             	mov    -0xc(%ebp),%edx
80103b7e:	89 42 04             	mov    %eax,0x4(%edx)
80103b81:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103b84:	8b 40 04             	mov    0x4(%eax),%eax
80103b87:	85 c0                	test   %eax,%eax
80103b89:	75 0d                	jne    80103b98 <userinit+0x38>
    panic("userinit: out of memory?");
80103b8b:	83 ec 0c             	sub    $0xc,%esp
80103b8e:	68 8e a5 10 80       	push   $0x8010a58e
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
80103bad:	e8 b8 3c 00 00       	call   8010786a <inituvm>
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
80103bcc:	e8 5e 10 00 00       	call   80104c2f <memset>
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
80103c46:	68 a7 a5 10 80       	push   $0x8010a5a7
80103c4b:	50                   	push   %eax
80103c4c:	e8 e1 11 00 00       	call   80104e32 <safestrcpy>
80103c51:	83 c4 10             	add    $0x10,%esp
  p->cwd = namei("/");
80103c54:	83 ec 0c             	sub    $0xc,%esp
80103c57:	68 b0 a5 10 80       	push   $0x8010a5b0
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
80103c72:	e8 42 0d 00 00       	call   801049b9 <acquire>
80103c77:	83 c4 10             	add    $0x10,%esp

  p->state = RUNNABLE;
80103c7a:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103c7d:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)

  release(&ptable.lock);
80103c84:	83 ec 0c             	sub    $0xc,%esp
80103c87:	68 00 42 19 80       	push   $0x80194200
80103c8c:	e8 96 0d 00 00       	call   80104a27 <release>
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
80103cc9:	e8 d9 3c 00 00       	call   801079a7 <allocuvm>
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
80103cfd:	e8 aa 3d 00 00       	call   80107aac <deallocuvm>
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
80103d23:	e8 a3 39 00 00       	call   801076cb <switchuvm>
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
80103d6b:	e8 da 3e 00 00       	call   80107c4a <copyuvm>
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
80103e65:	e8 c8 0f 00 00       	call   80104e32 <safestrcpy>
80103e6a:	83 c4 10             	add    $0x10,%esp

  pid = np->pid;
80103e6d:	8b 45 dc             	mov    -0x24(%ebp),%eax
80103e70:	8b 40 10             	mov    0x10(%eax),%eax
80103e73:	89 45 d8             	mov    %eax,-0x28(%ebp)

  acquire(&ptable.lock);
80103e76:	83 ec 0c             	sub    $0xc,%esp
80103e79:	68 00 42 19 80       	push   $0x80194200
80103e7e:	e8 36 0b 00 00       	call   801049b9 <acquire>
80103e83:	83 c4 10             	add    $0x10,%esp

  np->state = RUNNABLE;
80103e86:	8b 45 dc             	mov    -0x24(%ebp),%eax
80103e89:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)

  release(&ptable.lock);
80103e90:	83 ec 0c             	sub    $0xc,%esp
80103e93:	68 00 42 19 80       	push   $0x80194200
80103e98:	e8 8a 0b 00 00       	call   80104a27 <release>
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
80103ec6:	68 b2 a5 10 80       	push   $0x8010a5b2
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
80103f4c:	e8 68 0a 00 00       	call   801049b9 <acquire>
80103f51:	83 c4 10             	add    $0x10,%esp

  // Parent might be sleeping in wait().
  wakeup1(curproc->parent);
80103f54:	8b 45 ec             	mov    -0x14(%ebp),%eax
80103f57:	8b 40 14             	mov    0x14(%eax),%eax
80103f5a:	83 ec 0c             	sub    $0xc,%esp
80103f5d:	50                   	push   %eax
80103f5e:	e8 d9 06 00 00       	call   8010463c <wakeup1>
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
80103f9a:	e8 9d 06 00 00       	call   8010463c <wakeup1>
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
80103fbc:	e8 9b 04 00 00       	call   8010445c <sched>
  panic("zombie exit");
80103fc1:	83 ec 0c             	sub    $0xc,%esp
80103fc4:	68 bf a5 10 80       	push   $0x8010a5bf
80103fc9:	e8 db c5 ff ff       	call   801005a9 <panic>

80103fce <uthread_init>:
}

int
uthread_init(int address){
80103fce:	55                   	push   %ebp
80103fcf:	89 e5                	mov    %esp,%ebp
80103fd1:	83 ec 18             	sub    $0x18,%esp
	//require to implement
  struct proc *curproc = myproc();
80103fd4:	e8 57 fa ff ff       	call   80103a30 <myproc>
80103fd9:	89 45 f4             	mov    %eax,-0xc(%ebp)
    //if (copyout(curproc->pgdir, *(curproc->scheduler), &address, sizeof(uint)) < 0)
            //return -1;
    //if (copyout(curproc->pgdir, *status, &(curproc->xstate), sizeof(int)) < 0)
	    //return -1;
  //copyin 함수
  uint a = (unsigned int)&(curproc->scheduler);
80103fdc:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103fdf:	83 e8 80             	sub    $0xffffff80,%eax
80103fe2:	89 45 f0             	mov    %eax,-0x10(%ebp)
  copyout(curproc->pgdir, a, &address, sizeof(uint));
80103fe5:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103fe8:	8b 40 04             	mov    0x4(%eax),%eax
80103feb:	6a 04                	push   $0x4
80103fed:	8d 55 08             	lea    0x8(%ebp),%edx
80103ff0:	52                   	push   %edx
80103ff1:	ff 75 f0             	push   -0x10(%ebp)
80103ff4:	50                   	push   %eax
80103ff5:	e8 ae 3d 00 00       	call   80107da8 <copyout>
80103ffa:	83 c4 10             	add    $0x10,%esp
  return 0;
80103ffd:	b8 00 00 00 00       	mov    $0x0,%eax
}
80104002:	c9                   	leave  
80104003:	c3                   	ret    

80104004 <exit2>:
//******************************************
//************   new  **********************
//************ eixt2() *********************
//******************************************
void
exit2(int status){
80104004:	55                   	push   %ebp
80104005:	89 e5                	mov    %esp,%ebp
80104007:	83 ec 18             	sub    $0x18,%esp
  struct proc *curproc = myproc();
8010400a:	e8 21 fa ff ff       	call   80103a30 <myproc>
8010400f:	89 45 ec             	mov    %eax,-0x14(%ebp)
  struct proc *p;
  int fd;
 
  //***********새로 추가된 부분. Copy status to xstate**********
  curproc->parent->xstate = status;
80104012:	8b 45 ec             	mov    -0x14(%ebp),%eax
80104015:	8b 40 14             	mov    0x14(%eax),%eax
80104018:	8b 55 08             	mov    0x8(%ebp),%edx
8010401b:	89 50 7c             	mov    %edx,0x7c(%eax)
  //************************************************************

  if(curproc == initproc)
8010401e:	a1 34 63 19 80       	mov    0x80196334,%eax
80104023:	39 45 ec             	cmp    %eax,-0x14(%ebp)
80104026:	75 0d                	jne    80104035 <exit2+0x31>
    panic("init exiting");
80104028:	83 ec 0c             	sub    $0xc,%esp
8010402b:	68 b2 a5 10 80       	push   $0x8010a5b2
80104030:	e8 74 c5 ff ff       	call   801005a9 <panic>

  // Close all open files.
  for(fd = 0; fd < NOFILE; fd++){
80104035:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
8010403c:	eb 3f                	jmp    8010407d <exit2+0x79>
    if(curproc->ofile[fd]){
8010403e:	8b 45 ec             	mov    -0x14(%ebp),%eax
80104041:	8b 55 f0             	mov    -0x10(%ebp),%edx
80104044:	83 c2 08             	add    $0x8,%edx
80104047:	8b 44 90 08          	mov    0x8(%eax,%edx,4),%eax
8010404b:	85 c0                	test   %eax,%eax
8010404d:	74 2a                	je     80104079 <exit2+0x75>
      fileclose(curproc->ofile[fd]);
8010404f:	8b 45 ec             	mov    -0x14(%ebp),%eax
80104052:	8b 55 f0             	mov    -0x10(%ebp),%edx
80104055:	83 c2 08             	add    $0x8,%edx
80104058:	8b 44 90 08          	mov    0x8(%eax,%edx,4),%eax
8010405c:	83 ec 0c             	sub    $0xc,%esp
8010405f:	50                   	push   %eax
80104060:	e8 36 d0 ff ff       	call   8010109b <fileclose>
80104065:	83 c4 10             	add    $0x10,%esp
      curproc->ofile[fd] = 0;
80104068:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010406b:	8b 55 f0             	mov    -0x10(%ebp),%edx
8010406e:	83 c2 08             	add    $0x8,%edx
80104071:	c7 44 90 08 00 00 00 	movl   $0x0,0x8(%eax,%edx,4)
80104078:	00 
  for(fd = 0; fd < NOFILE; fd++){
80104079:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
8010407d:	83 7d f0 0f          	cmpl   $0xf,-0x10(%ebp)
80104081:	7e bb                	jle    8010403e <exit2+0x3a>
    }
  }

  begin_op();
80104083:	e8 b4 ef ff ff       	call   8010303c <begin_op>
  iput(curproc->cwd);
80104088:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010408b:	8b 40 68             	mov    0x68(%eax),%eax
8010408e:	83 ec 0c             	sub    $0xc,%esp
80104091:	50                   	push   %eax
80104092:	e8 b4 da ff ff       	call   80101b4b <iput>
80104097:	83 c4 10             	add    $0x10,%esp
  end_op();
8010409a:	e8 29 f0 ff ff       	call   801030c8 <end_op>
  curproc->cwd = 0;
8010409f:	8b 45 ec             	mov    -0x14(%ebp),%eax
801040a2:	c7 40 68 00 00 00 00 	movl   $0x0,0x68(%eax)

  acquire(&ptable.lock);
801040a9:	83 ec 0c             	sub    $0xc,%esp
801040ac:	68 00 42 19 80       	push   $0x80194200
801040b1:	e8 03 09 00 00       	call   801049b9 <acquire>
801040b6:	83 c4 10             	add    $0x10,%esp

  // Parent might be sleeping in wait().
  wakeup1(curproc->parent);
801040b9:	8b 45 ec             	mov    -0x14(%ebp),%eax
801040bc:	8b 40 14             	mov    0x14(%eax),%eax
801040bf:	83 ec 0c             	sub    $0xc,%esp
801040c2:	50                   	push   %eax
801040c3:	e8 74 05 00 00       	call   8010463c <wakeup1>
801040c8:	83 c4 10             	add    $0x10,%esp

  // Pass abandoned children to init.
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801040cb:	c7 45 f4 34 42 19 80 	movl   $0x80194234,-0xc(%ebp)
801040d2:	eb 3a                	jmp    8010410e <exit2+0x10a>
    if(p->parent == curproc){
801040d4:	8b 45 f4             	mov    -0xc(%ebp),%eax
801040d7:	8b 40 14             	mov    0x14(%eax),%eax
801040da:	39 45 ec             	cmp    %eax,-0x14(%ebp)
801040dd:	75 28                	jne    80104107 <exit2+0x103>
      p->parent = initproc;
801040df:	8b 15 34 63 19 80    	mov    0x80196334,%edx
801040e5:	8b 45 f4             	mov    -0xc(%ebp),%eax
801040e8:	89 50 14             	mov    %edx,0x14(%eax)
      if(p->state == ZOMBIE)
801040eb:	8b 45 f4             	mov    -0xc(%ebp),%eax
801040ee:	8b 40 0c             	mov    0xc(%eax),%eax
801040f1:	83 f8 05             	cmp    $0x5,%eax
801040f4:	75 11                	jne    80104107 <exit2+0x103>
        wakeup1(initproc);
801040f6:	a1 34 63 19 80       	mov    0x80196334,%eax
801040fb:	83 ec 0c             	sub    $0xc,%esp
801040fe:	50                   	push   %eax
801040ff:	e8 38 05 00 00       	call   8010463c <wakeup1>
80104104:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104107:	81 45 f4 84 00 00 00 	addl   $0x84,-0xc(%ebp)
8010410e:	81 7d f4 34 63 19 80 	cmpl   $0x80196334,-0xc(%ebp)
80104115:	72 bd                	jb     801040d4 <exit2+0xd0>
    }
  }

  // Jump into the scheduler, never to return.
  curproc->state = ZOMBIE;
80104117:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010411a:	c7 40 0c 05 00 00 00 	movl   $0x5,0xc(%eax)
  sched();
80104121:	e8 36 03 00 00       	call   8010445c <sched>
  panic("zombie exit");
80104126:	83 ec 0c             	sub    $0xc,%esp
80104129:	68 bf a5 10 80       	push   $0x8010a5bf
8010412e:	e8 76 c4 ff ff       	call   801005a9 <panic>

80104133 <wait>:

// Wait for a child process to exit and return its pid.
// Return -1 if this process has no children.
int
wait(void)
{
80104133:	55                   	push   %ebp
80104134:	89 e5                	mov    %esp,%ebp
80104136:	83 ec 18             	sub    $0x18,%esp
  struct proc *p;
  int havekids, pid;
  struct proc *curproc = myproc();
80104139:	e8 f2 f8 ff ff       	call   80103a30 <myproc>
8010413e:	89 45 ec             	mov    %eax,-0x14(%ebp)
  
  acquire(&ptable.lock);
80104141:	83 ec 0c             	sub    $0xc,%esp
80104144:	68 00 42 19 80       	push   $0x80194200
80104149:	e8 6b 08 00 00       	call   801049b9 <acquire>
8010414e:	83 c4 10             	add    $0x10,%esp
  for(;;){
    // Scan through table looking for exited children.
    havekids = 0;
80104151:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104158:	c7 45 f4 34 42 19 80 	movl   $0x80194234,-0xc(%ebp)
8010415f:	e9 a4 00 00 00       	jmp    80104208 <wait+0xd5>
      if(p->parent != curproc)
80104164:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104167:	8b 40 14             	mov    0x14(%eax),%eax
8010416a:	39 45 ec             	cmp    %eax,-0x14(%ebp)
8010416d:	0f 85 8d 00 00 00    	jne    80104200 <wait+0xcd>
        continue;
      havekids = 1;
80104173:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
      if(p->state == ZOMBIE){
8010417a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010417d:	8b 40 0c             	mov    0xc(%eax),%eax
80104180:	83 f8 05             	cmp    $0x5,%eax
80104183:	75 7c                	jne    80104201 <wait+0xce>
        // Found one.
        pid = p->pid;
80104185:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104188:	8b 40 10             	mov    0x10(%eax),%eax
8010418b:	89 45 e8             	mov    %eax,-0x18(%ebp)
        kfree(p->kstack);
8010418e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104191:	8b 40 08             	mov    0x8(%eax),%eax
80104194:	83 ec 0c             	sub    $0xc,%esp
80104197:	50                   	push   %eax
80104198:	e8 69 e5 ff ff       	call   80102706 <kfree>
8010419d:	83 c4 10             	add    $0x10,%esp
        p->kstack = 0;
801041a0:	8b 45 f4             	mov    -0xc(%ebp),%eax
801041a3:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
        freevm(p->pgdir);
801041aa:	8b 45 f4             	mov    -0xc(%ebp),%eax
801041ad:	8b 40 04             	mov    0x4(%eax),%eax
801041b0:	83 ec 0c             	sub    $0xc,%esp
801041b3:	50                   	push   %eax
801041b4:	e8 b7 39 00 00       	call   80107b70 <freevm>
801041b9:	83 c4 10             	add    $0x10,%esp
        p->pid = 0;
801041bc:	8b 45 f4             	mov    -0xc(%ebp),%eax
801041bf:	c7 40 10 00 00 00 00 	movl   $0x0,0x10(%eax)
        p->parent = 0;
801041c6:	8b 45 f4             	mov    -0xc(%ebp),%eax
801041c9:	c7 40 14 00 00 00 00 	movl   $0x0,0x14(%eax)
        p->name[0] = 0;
801041d0:	8b 45 f4             	mov    -0xc(%ebp),%eax
801041d3:	c6 40 6c 00          	movb   $0x0,0x6c(%eax)
        p->killed = 0;
801041d7:	8b 45 f4             	mov    -0xc(%ebp),%eax
801041da:	c7 40 24 00 00 00 00 	movl   $0x0,0x24(%eax)
        p->state = UNUSED;
801041e1:	8b 45 f4             	mov    -0xc(%ebp),%eax
801041e4:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
        release(&ptable.lock);
801041eb:	83 ec 0c             	sub    $0xc,%esp
801041ee:	68 00 42 19 80       	push   $0x80194200
801041f3:	e8 2f 08 00 00       	call   80104a27 <release>
801041f8:	83 c4 10             	add    $0x10,%esp
        return pid;
801041fb:	8b 45 e8             	mov    -0x18(%ebp),%eax
801041fe:	eb 54                	jmp    80104254 <wait+0x121>
        continue;
80104200:	90                   	nop
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104201:	81 45 f4 84 00 00 00 	addl   $0x84,-0xc(%ebp)
80104208:	81 7d f4 34 63 19 80 	cmpl   $0x80196334,-0xc(%ebp)
8010420f:	0f 82 4f ff ff ff    	jb     80104164 <wait+0x31>
      }
    }

    // No point waiting if we don't have any children.
    if(!havekids || curproc->killed){
80104215:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80104219:	74 0a                	je     80104225 <wait+0xf2>
8010421b:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010421e:	8b 40 24             	mov    0x24(%eax),%eax
80104221:	85 c0                	test   %eax,%eax
80104223:	74 17                	je     8010423c <wait+0x109>
      release(&ptable.lock);
80104225:	83 ec 0c             	sub    $0xc,%esp
80104228:	68 00 42 19 80       	push   $0x80194200
8010422d:	e8 f5 07 00 00       	call   80104a27 <release>
80104232:	83 c4 10             	add    $0x10,%esp
      return -1;
80104235:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010423a:	eb 18                	jmp    80104254 <wait+0x121>
    }

    // Wait for children to exit.  (See wakeup1 call in proc_exit.)
    sleep(curproc, &ptable.lock);  //DOC: wait-sleep
8010423c:	83 ec 08             	sub    $0x8,%esp
8010423f:	68 00 42 19 80       	push   $0x80194200
80104244:	ff 75 ec             	push   -0x14(%ebp)
80104247:	e8 49 03 00 00       	call   80104595 <sleep>
8010424c:	83 c4 10             	add    $0x10,%esp
    havekids = 0;
8010424f:	e9 fd fe ff ff       	jmp    80104151 <wait+0x1e>
  }
}
80104254:	c9                   	leave  
80104255:	c3                   	ret    

80104256 <wait2>:
//******************************************
//************   new  **********************
//************ wait2() *********************
//******************************************
int
wait2(int *status){
80104256:	55                   	push   %ebp
80104257:	89 e5                	mov    %esp,%ebp
80104259:	83 ec 18             	sub    $0x18,%esp

  struct proc *p;
  int havekids, pid;
  struct proc *curproc = myproc();
8010425c:	e8 cf f7 ff ff       	call   80103a30 <myproc>
80104261:	89 45 ec             	mov    %eax,-0x14(%ebp)
 
  
  acquire(&ptable.lock);
80104264:	83 ec 0c             	sub    $0xc,%esp
80104267:	68 00 42 19 80       	push   $0x80194200
8010426c:	e8 48 07 00 00       	call   801049b9 <acquire>
80104271:	83 c4 10             	add    $0x10,%esp
  for(;;){
    // Scan through table looking for exited children.
    havekids = 0;
80104274:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
8010427b:	c7 45 f4 34 42 19 80 	movl   $0x80194234,-0xc(%ebp)
80104282:	e9 a4 00 00 00       	jmp    8010432b <wait2+0xd5>
      if(p->parent != curproc)
80104287:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010428a:	8b 40 14             	mov    0x14(%eax),%eax
8010428d:	39 45 ec             	cmp    %eax,-0x14(%ebp)
80104290:	0f 85 8d 00 00 00    	jne    80104323 <wait2+0xcd>
        continue;
      havekids = 1;
80104296:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
      if(p->state == ZOMBIE){
8010429d:	8b 45 f4             	mov    -0xc(%ebp),%eax
801042a0:	8b 40 0c             	mov    0xc(%eax),%eax
801042a3:	83 f8 05             	cmp    $0x5,%eax
801042a6:	75 7c                	jne    80104324 <wait2+0xce>
        // Found one.
        pid = p->pid;
801042a8:	8b 45 f4             	mov    -0xc(%ebp),%eax
801042ab:	8b 40 10             	mov    0x10(%eax),%eax
801042ae:	89 45 e8             	mov    %eax,-0x18(%ebp)
        kfree(p->kstack);
801042b1:	8b 45 f4             	mov    -0xc(%ebp),%eax
801042b4:	8b 40 08             	mov    0x8(%eax),%eax
801042b7:	83 ec 0c             	sub    $0xc,%esp
801042ba:	50                   	push   %eax
801042bb:	e8 46 e4 ff ff       	call   80102706 <kfree>
801042c0:	83 c4 10             	add    $0x10,%esp
        p->kstack = 0;
801042c3:	8b 45 f4             	mov    -0xc(%ebp),%eax
801042c6:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
        freevm(p->pgdir);
801042cd:	8b 45 f4             	mov    -0xc(%ebp),%eax
801042d0:	8b 40 04             	mov    0x4(%eax),%eax
801042d3:	83 ec 0c             	sub    $0xc,%esp
801042d6:	50                   	push   %eax
801042d7:	e8 94 38 00 00       	call   80107b70 <freevm>
801042dc:	83 c4 10             	add    $0x10,%esp
        p->pid = 0;
801042df:	8b 45 f4             	mov    -0xc(%ebp),%eax
801042e2:	c7 40 10 00 00 00 00 	movl   $0x0,0x10(%eax)
        p->parent = 0;
801042e9:	8b 45 f4             	mov    -0xc(%ebp),%eax
801042ec:	c7 40 14 00 00 00 00 	movl   $0x0,0x14(%eax)
        p->name[0] = 0;
801042f3:	8b 45 f4             	mov    -0xc(%ebp),%eax
801042f6:	c6 40 6c 00          	movb   $0x0,0x6c(%eax)
        p->killed = 0;
801042fa:	8b 45 f4             	mov    -0xc(%ebp),%eax
801042fd:	c7 40 24 00 00 00 00 	movl   $0x0,0x24(%eax)
        p->state = UNUSED;
80104304:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104307:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
        release(&ptable.lock);
8010430e:	83 ec 0c             	sub    $0xc,%esp
80104311:	68 00 42 19 80       	push   $0x80194200
80104316:	e8 0c 07 00 00       	call   80104a27 <release>
8010431b:	83 c4 10             	add    $0x10,%esp
        return pid;
8010431e:	8b 45 e8             	mov    -0x18(%ebp),%eax
80104321:	eb 7c                	jmp    8010439f <wait2+0x149>
        continue;
80104323:	90                   	nop
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104324:	81 45 f4 84 00 00 00 	addl   $0x84,-0xc(%ebp)
8010432b:	81 7d f4 34 63 19 80 	cmpl   $0x80196334,-0xc(%ebp)
80104332:	0f 82 4f ff ff ff    	jb     80104287 <wait2+0x31>
      }
    }

    // No point waiting if we don't have any children.
    if(!havekids || curproc->killed){
80104338:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
8010433c:	74 0a                	je     80104348 <wait2+0xf2>
8010433e:	8b 45 ec             	mov    -0x14(%ebp),%eax
80104341:	8b 40 24             	mov    0x24(%eax),%eax
80104344:	85 c0                	test   %eax,%eax
80104346:	74 17                	je     8010435f <wait2+0x109>
      release(&ptable.lock);
80104348:	83 ec 0c             	sub    $0xc,%esp
8010434b:	68 00 42 19 80       	push   $0x80194200
80104350:	e8 d2 06 00 00       	call   80104a27 <release>
80104355:	83 c4 10             	add    $0x10,%esp
      return -1;
80104358:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010435d:	eb 40                	jmp    8010439f <wait2+0x149>
    }

    sleep(curproc, &ptable.lock);  //DOC: wait-sleep
8010435f:	83 ec 08             	sub    $0x8,%esp
80104362:	68 00 42 19 80       	push   $0x80194200
80104367:	ff 75 ec             	push   -0x14(%ebp)
8010436a:	e8 26 02 00 00       	call   80104595 <sleep>
8010436f:	83 c4 10             	add    $0x10,%esp
  // copyout(pde_t *pgdir, uint va, void *p, uint len)와 같이 정의됨
  // p 주소의 len 길이만큼을 복사해서 pgdir의 va에 넣는다.
  // 만약 올바른 값이 아니라면 -1을 리턴
  // Wait for children to exit.  (See wakeup1 call in proc_exit.)
  // wakeup되면 마저 실행하는 코드
    if (copyout(curproc->pgdir, *status, &(curproc->xstate), sizeof(int)) < 0)
80104372:	8b 45 ec             	mov    -0x14(%ebp),%eax
80104375:	8d 50 7c             	lea    0x7c(%eax),%edx
80104378:	8b 45 08             	mov    0x8(%ebp),%eax
8010437b:	8b 00                	mov    (%eax),%eax
8010437d:	89 c1                	mov    %eax,%ecx
8010437f:	8b 45 ec             	mov    -0x14(%ebp),%eax
80104382:	8b 40 04             	mov    0x4(%eax),%eax
80104385:	6a 04                	push   $0x4
80104387:	52                   	push   %edx
80104388:	51                   	push   %ecx
80104389:	50                   	push   %eax
8010438a:	e8 19 3a 00 00       	call   80107da8 <copyout>
8010438f:	83 c4 10             	add    $0x10,%esp
80104392:	85 c0                	test   %eax,%eax
80104394:	0f 89 da fe ff ff    	jns    80104274 <wait2+0x1e>
	    return -1;
8010439a:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
				     
  }
}
8010439f:	c9                   	leave  
801043a0:	c3                   	ret    

801043a1 <scheduler>:
//  - swtch to start running that process
//  - eventually that process transfers control
//      via swtch back to the scheduler.
void
scheduler(void)
{
801043a1:	55                   	push   %ebp
801043a2:	89 e5                	mov    %esp,%ebp
801043a4:	83 ec 18             	sub    $0x18,%esp
  struct proc *p;
  struct cpu *c = mycpu();
801043a7:	e8 0c f6 ff ff       	call   801039b8 <mycpu>
801043ac:	89 45 f0             	mov    %eax,-0x10(%ebp)
  c->proc = 0;
801043af:	8b 45 f0             	mov    -0x10(%ebp),%eax
801043b2:	c7 80 ac 00 00 00 00 	movl   $0x0,0xac(%eax)
801043b9:	00 00 00 
  
  for(;;){
    // Enable interrupts on this processor.
    sti();
801043bc:	e8 b7 f5 ff ff       	call   80103978 <sti>

    // Loop over process table looking for process to run.
    acquire(&ptable.lock);
801043c1:	83 ec 0c             	sub    $0xc,%esp
801043c4:	68 00 42 19 80       	push   $0x80194200
801043c9:	e8 eb 05 00 00       	call   801049b9 <acquire>
801043ce:	83 c4 10             	add    $0x10,%esp
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801043d1:	c7 45 f4 34 42 19 80 	movl   $0x80194234,-0xc(%ebp)
801043d8:	eb 64                	jmp    8010443e <scheduler+0x9d>
      if(p->state != RUNNABLE)
801043da:	8b 45 f4             	mov    -0xc(%ebp),%eax
801043dd:	8b 40 0c             	mov    0xc(%eax),%eax
801043e0:	83 f8 03             	cmp    $0x3,%eax
801043e3:	75 51                	jne    80104436 <scheduler+0x95>
        continue;

      // Switch to chosen process.  It is the process's job
      // to release ptable.lock and then reacquire it
      // before jumping back to us.
      c->proc = p;
801043e5:	8b 45 f0             	mov    -0x10(%ebp),%eax
801043e8:	8b 55 f4             	mov    -0xc(%ebp),%edx
801043eb:	89 90 ac 00 00 00    	mov    %edx,0xac(%eax)
      switchuvm(p);
801043f1:	83 ec 0c             	sub    $0xc,%esp
801043f4:	ff 75 f4             	push   -0xc(%ebp)
801043f7:	e8 cf 32 00 00       	call   801076cb <switchuvm>
801043fc:	83 c4 10             	add    $0x10,%esp
      p->state = RUNNING;
801043ff:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104402:	c7 40 0c 04 00 00 00 	movl   $0x4,0xc(%eax)

      swtch(&(c->scheduler), p->context);
80104409:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010440c:	8b 40 1c             	mov    0x1c(%eax),%eax
8010440f:	8b 55 f0             	mov    -0x10(%ebp),%edx
80104412:	83 c2 04             	add    $0x4,%edx
80104415:	83 ec 08             	sub    $0x8,%esp
80104418:	50                   	push   %eax
80104419:	52                   	push   %edx
8010441a:	e8 85 0a 00 00       	call   80104ea4 <swtch>
8010441f:	83 c4 10             	add    $0x10,%esp
      switchkvm();
80104422:	e8 8b 32 00 00       	call   801076b2 <switchkvm>

      // Process is done running for now.
      // It should have changed its p->state before coming back.
      c->proc = 0;
80104427:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010442a:	c7 80 ac 00 00 00 00 	movl   $0x0,0xac(%eax)
80104431:	00 00 00 
80104434:	eb 01                	jmp    80104437 <scheduler+0x96>
        continue;
80104436:	90                   	nop
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104437:	81 45 f4 84 00 00 00 	addl   $0x84,-0xc(%ebp)
8010443e:	81 7d f4 34 63 19 80 	cmpl   $0x80196334,-0xc(%ebp)
80104445:	72 93                	jb     801043da <scheduler+0x39>
    }
    release(&ptable.lock);
80104447:	83 ec 0c             	sub    $0xc,%esp
8010444a:	68 00 42 19 80       	push   $0x80194200
8010444f:	e8 d3 05 00 00       	call   80104a27 <release>
80104454:	83 c4 10             	add    $0x10,%esp
    sti();
80104457:	e9 60 ff ff ff       	jmp    801043bc <scheduler+0x1b>

8010445c <sched>:
// be proc->intena and proc->ncli, but that would
// break in the few places where a lock is held but
// there's no process.
void
sched(void)
{
8010445c:	55                   	push   %ebp
8010445d:	89 e5                	mov    %esp,%ebp
8010445f:	83 ec 18             	sub    $0x18,%esp
  int intena;
  struct proc *p = myproc();
80104462:	e8 c9 f5 ff ff       	call   80103a30 <myproc>
80104467:	89 45 f4             	mov    %eax,-0xc(%ebp)

  if(!holding(&ptable.lock))
8010446a:	83 ec 0c             	sub    $0xc,%esp
8010446d:	68 00 42 19 80       	push   $0x80194200
80104472:	e8 7d 06 00 00       	call   80104af4 <holding>
80104477:	83 c4 10             	add    $0x10,%esp
8010447a:	85 c0                	test   %eax,%eax
8010447c:	75 0d                	jne    8010448b <sched+0x2f>
    panic("sched ptable.lock");
8010447e:	83 ec 0c             	sub    $0xc,%esp
80104481:	68 cb a5 10 80       	push   $0x8010a5cb
80104486:	e8 1e c1 ff ff       	call   801005a9 <panic>
  if(mycpu()->ncli != 1)
8010448b:	e8 28 f5 ff ff       	call   801039b8 <mycpu>
80104490:	8b 80 a4 00 00 00    	mov    0xa4(%eax),%eax
80104496:	83 f8 01             	cmp    $0x1,%eax
80104499:	74 0d                	je     801044a8 <sched+0x4c>
    panic("sched locks");
8010449b:	83 ec 0c             	sub    $0xc,%esp
8010449e:	68 dd a5 10 80       	push   $0x8010a5dd
801044a3:	e8 01 c1 ff ff       	call   801005a9 <panic>
  if(p->state == RUNNING)
801044a8:	8b 45 f4             	mov    -0xc(%ebp),%eax
801044ab:	8b 40 0c             	mov    0xc(%eax),%eax
801044ae:	83 f8 04             	cmp    $0x4,%eax
801044b1:	75 0d                	jne    801044c0 <sched+0x64>
    panic("sched running");
801044b3:	83 ec 0c             	sub    $0xc,%esp
801044b6:	68 e9 a5 10 80       	push   $0x8010a5e9
801044bb:	e8 e9 c0 ff ff       	call   801005a9 <panic>
  if(readeflags()&FL_IF)
801044c0:	e8 a3 f4 ff ff       	call   80103968 <readeflags>
801044c5:	25 00 02 00 00       	and    $0x200,%eax
801044ca:	85 c0                	test   %eax,%eax
801044cc:	74 0d                	je     801044db <sched+0x7f>
    panic("sched interruptible");
801044ce:	83 ec 0c             	sub    $0xc,%esp
801044d1:	68 f7 a5 10 80       	push   $0x8010a5f7
801044d6:	e8 ce c0 ff ff       	call   801005a9 <panic>
  intena = mycpu()->intena;
801044db:	e8 d8 f4 ff ff       	call   801039b8 <mycpu>
801044e0:	8b 80 a8 00 00 00    	mov    0xa8(%eax),%eax
801044e6:	89 45 f0             	mov    %eax,-0x10(%ebp)
  swtch(&p->context, mycpu()->scheduler);
801044e9:	e8 ca f4 ff ff       	call   801039b8 <mycpu>
801044ee:	8b 40 04             	mov    0x4(%eax),%eax
801044f1:	8b 55 f4             	mov    -0xc(%ebp),%edx
801044f4:	83 c2 1c             	add    $0x1c,%edx
801044f7:	83 ec 08             	sub    $0x8,%esp
801044fa:	50                   	push   %eax
801044fb:	52                   	push   %edx
801044fc:	e8 a3 09 00 00       	call   80104ea4 <swtch>
80104501:	83 c4 10             	add    $0x10,%esp
  mycpu()->intena = intena;
80104504:	e8 af f4 ff ff       	call   801039b8 <mycpu>
80104509:	8b 55 f0             	mov    -0x10(%ebp),%edx
8010450c:	89 90 a8 00 00 00    	mov    %edx,0xa8(%eax)
}
80104512:	90                   	nop
80104513:	c9                   	leave  
80104514:	c3                   	ret    

80104515 <yield>:

// Give up the CPU for one scheduling round.
void
yield(void)
{
80104515:	55                   	push   %ebp
80104516:	89 e5                	mov    %esp,%ebp
80104518:	83 ec 08             	sub    $0x8,%esp
  acquire(&ptable.lock);  //DOC: yieldlock
8010451b:	83 ec 0c             	sub    $0xc,%esp
8010451e:	68 00 42 19 80       	push   $0x80194200
80104523:	e8 91 04 00 00       	call   801049b9 <acquire>
80104528:	83 c4 10             	add    $0x10,%esp
  myproc()->state = RUNNABLE;
8010452b:	e8 00 f5 ff ff       	call   80103a30 <myproc>
80104530:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
  sched();
80104537:	e8 20 ff ff ff       	call   8010445c <sched>
  release(&ptable.lock);
8010453c:	83 ec 0c             	sub    $0xc,%esp
8010453f:	68 00 42 19 80       	push   $0x80194200
80104544:	e8 de 04 00 00       	call   80104a27 <release>
80104549:	83 c4 10             	add    $0x10,%esp
}
8010454c:	90                   	nop
8010454d:	c9                   	leave  
8010454e:	c3                   	ret    

8010454f <forkret>:

// A fork child's very first scheduling by scheduler()
// will swtch here.  "Return" to user space.
void
forkret(void)
{
8010454f:	55                   	push   %ebp
80104550:	89 e5                	mov    %esp,%ebp
80104552:	83 ec 08             	sub    $0x8,%esp
  static int first = 1;
  // Still holding ptable.lock from scheduler.
  release(&ptable.lock);
80104555:	83 ec 0c             	sub    $0xc,%esp
80104558:	68 00 42 19 80       	push   $0x80194200
8010455d:	e8 c5 04 00 00       	call   80104a27 <release>
80104562:	83 c4 10             	add    $0x10,%esp

  if (first) {
80104565:	a1 04 f0 10 80       	mov    0x8010f004,%eax
8010456a:	85 c0                	test   %eax,%eax
8010456c:	74 24                	je     80104592 <forkret+0x43>
    // Some initialization functions must be run in the context
    // of a regular process (e.g., they call sleep), and thus cannot
    // be run from main().
    first = 0;
8010456e:	c7 05 04 f0 10 80 00 	movl   $0x0,0x8010f004
80104575:	00 00 00 
    iinit(ROOTDEV);
80104578:	83 ec 0c             	sub    $0xc,%esp
8010457b:	6a 01                	push   $0x1
8010457d:	e8 f6 d0 ff ff       	call   80101678 <iinit>
80104582:	83 c4 10             	add    $0x10,%esp
    initlog(ROOTDEV);
80104585:	83 ec 0c             	sub    $0xc,%esp
80104588:	6a 01                	push   $0x1
8010458a:	e8 8e e8 ff ff       	call   80102e1d <initlog>
8010458f:	83 c4 10             	add    $0x10,%esp
  }

  // Return to "caller", actually trapret (see allocproc).
}
80104592:	90                   	nop
80104593:	c9                   	leave  
80104594:	c3                   	ret    

80104595 <sleep>:

// Atomically release lock and sleep on chan.
// Reacquires lock when awakened.
void
sleep(void *chan, struct spinlock *lk)
{
80104595:	55                   	push   %ebp
80104596:	89 e5                	mov    %esp,%ebp
80104598:	83 ec 18             	sub    $0x18,%esp
  struct proc *p = myproc();
8010459b:	e8 90 f4 ff ff       	call   80103a30 <myproc>
801045a0:	89 45 f4             	mov    %eax,-0xc(%ebp)
  
  if(p == 0)
801045a3:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801045a7:	75 0d                	jne    801045b6 <sleep+0x21>
    panic("sleep");
801045a9:	83 ec 0c             	sub    $0xc,%esp
801045ac:	68 0b a6 10 80       	push   $0x8010a60b
801045b1:	e8 f3 bf ff ff       	call   801005a9 <panic>

  if(lk == 0)
801045b6:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
801045ba:	75 0d                	jne    801045c9 <sleep+0x34>
    panic("sleep without lk");
801045bc:	83 ec 0c             	sub    $0xc,%esp
801045bf:	68 11 a6 10 80       	push   $0x8010a611
801045c4:	e8 e0 bf ff ff       	call   801005a9 <panic>
  // change p->state and then call sched.
  // Once we hold ptable.lock, we can be
  // guaranteed that we won't miss any wakeup
  // (wakeup runs with ptable.lock locked),
  // so it's okay to release lk.
  if(lk != &ptable.lock){  //DOC: sleeplock0
801045c9:	81 7d 0c 00 42 19 80 	cmpl   $0x80194200,0xc(%ebp)
801045d0:	74 1e                	je     801045f0 <sleep+0x5b>
    acquire(&ptable.lock);  //DOC: sleeplock1
801045d2:	83 ec 0c             	sub    $0xc,%esp
801045d5:	68 00 42 19 80       	push   $0x80194200
801045da:	e8 da 03 00 00       	call   801049b9 <acquire>
801045df:	83 c4 10             	add    $0x10,%esp
    release(lk);
801045e2:	83 ec 0c             	sub    $0xc,%esp
801045e5:	ff 75 0c             	push   0xc(%ebp)
801045e8:	e8 3a 04 00 00       	call   80104a27 <release>
801045ed:	83 c4 10             	add    $0x10,%esp
  }
  // Go to sleep.
  p->chan = chan;
801045f0:	8b 45 f4             	mov    -0xc(%ebp),%eax
801045f3:	8b 55 08             	mov    0x8(%ebp),%edx
801045f6:	89 50 20             	mov    %edx,0x20(%eax)
  p->state = SLEEPING;
801045f9:	8b 45 f4             	mov    -0xc(%ebp),%eax
801045fc:	c7 40 0c 02 00 00 00 	movl   $0x2,0xc(%eax)

  sched();
80104603:	e8 54 fe ff ff       	call   8010445c <sched>

  // Tidy up.
  p->chan = 0;
80104608:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010460b:	c7 40 20 00 00 00 00 	movl   $0x0,0x20(%eax)

  // Reacquire original lock.
  if(lk != &ptable.lock){  //DOC: sleeplock2
80104612:	81 7d 0c 00 42 19 80 	cmpl   $0x80194200,0xc(%ebp)
80104619:	74 1e                	je     80104639 <sleep+0xa4>
    release(&ptable.lock);
8010461b:	83 ec 0c             	sub    $0xc,%esp
8010461e:	68 00 42 19 80       	push   $0x80194200
80104623:	e8 ff 03 00 00       	call   80104a27 <release>
80104628:	83 c4 10             	add    $0x10,%esp
    acquire(lk);
8010462b:	83 ec 0c             	sub    $0xc,%esp
8010462e:	ff 75 0c             	push   0xc(%ebp)
80104631:	e8 83 03 00 00       	call   801049b9 <acquire>
80104636:	83 c4 10             	add    $0x10,%esp
  }
}
80104639:	90                   	nop
8010463a:	c9                   	leave  
8010463b:	c3                   	ret    

8010463c <wakeup1>:
//PAGEBREAK!
// Wake up all processes sleeping on chan.
// The ptable lock must be held.
static void
wakeup1(void *chan)
{
8010463c:	55                   	push   %ebp
8010463d:	89 e5                	mov    %esp,%ebp
8010463f:	83 ec 10             	sub    $0x10,%esp
  struct proc *p;

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104642:	c7 45 fc 34 42 19 80 	movl   $0x80194234,-0x4(%ebp)
80104649:	eb 27                	jmp    80104672 <wakeup1+0x36>
    if(p->state == SLEEPING && p->chan == chan)
8010464b:	8b 45 fc             	mov    -0x4(%ebp),%eax
8010464e:	8b 40 0c             	mov    0xc(%eax),%eax
80104651:	83 f8 02             	cmp    $0x2,%eax
80104654:	75 15                	jne    8010466b <wakeup1+0x2f>
80104656:	8b 45 fc             	mov    -0x4(%ebp),%eax
80104659:	8b 40 20             	mov    0x20(%eax),%eax
8010465c:	39 45 08             	cmp    %eax,0x8(%ebp)
8010465f:	75 0a                	jne    8010466b <wakeup1+0x2f>
      p->state = RUNNABLE;
80104661:	8b 45 fc             	mov    -0x4(%ebp),%eax
80104664:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
8010466b:	81 45 fc 84 00 00 00 	addl   $0x84,-0x4(%ebp)
80104672:	81 7d fc 34 63 19 80 	cmpl   $0x80196334,-0x4(%ebp)
80104679:	72 d0                	jb     8010464b <wakeup1+0xf>
}
8010467b:	90                   	nop
8010467c:	90                   	nop
8010467d:	c9                   	leave  
8010467e:	c3                   	ret    

8010467f <wakeup>:

// Wake up all processes sleeping on chan.
void
wakeup(void *chan)
{
8010467f:	55                   	push   %ebp
80104680:	89 e5                	mov    %esp,%ebp
80104682:	83 ec 08             	sub    $0x8,%esp
  acquire(&ptable.lock);
80104685:	83 ec 0c             	sub    $0xc,%esp
80104688:	68 00 42 19 80       	push   $0x80194200
8010468d:	e8 27 03 00 00       	call   801049b9 <acquire>
80104692:	83 c4 10             	add    $0x10,%esp
  wakeup1(chan);
80104695:	83 ec 0c             	sub    $0xc,%esp
80104698:	ff 75 08             	push   0x8(%ebp)
8010469b:	e8 9c ff ff ff       	call   8010463c <wakeup1>
801046a0:	83 c4 10             	add    $0x10,%esp
  release(&ptable.lock);
801046a3:	83 ec 0c             	sub    $0xc,%esp
801046a6:	68 00 42 19 80       	push   $0x80194200
801046ab:	e8 77 03 00 00       	call   80104a27 <release>
801046b0:	83 c4 10             	add    $0x10,%esp
}
801046b3:	90                   	nop
801046b4:	c9                   	leave  
801046b5:	c3                   	ret    

801046b6 <kill>:
// Kill the process with the given pid.
// Process won't exit until it returns
// to user space (see trap in trap.c).
int
kill(int pid)
{
801046b6:	55                   	push   %ebp
801046b7:	89 e5                	mov    %esp,%ebp
801046b9:	83 ec 18             	sub    $0x18,%esp
  struct proc *p;

  acquire(&ptable.lock);
801046bc:	83 ec 0c             	sub    $0xc,%esp
801046bf:	68 00 42 19 80       	push   $0x80194200
801046c4:	e8 f0 02 00 00       	call   801049b9 <acquire>
801046c9:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801046cc:	c7 45 f4 34 42 19 80 	movl   $0x80194234,-0xc(%ebp)
801046d3:	eb 48                	jmp    8010471d <kill+0x67>
    if(p->pid == pid){
801046d5:	8b 45 f4             	mov    -0xc(%ebp),%eax
801046d8:	8b 40 10             	mov    0x10(%eax),%eax
801046db:	39 45 08             	cmp    %eax,0x8(%ebp)
801046de:	75 36                	jne    80104716 <kill+0x60>
      p->killed = 1;
801046e0:	8b 45 f4             	mov    -0xc(%ebp),%eax
801046e3:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
      // Wake process from sleep if necessary.
      if(p->state == SLEEPING)
801046ea:	8b 45 f4             	mov    -0xc(%ebp),%eax
801046ed:	8b 40 0c             	mov    0xc(%eax),%eax
801046f0:	83 f8 02             	cmp    $0x2,%eax
801046f3:	75 0a                	jne    801046ff <kill+0x49>
        p->state = RUNNABLE;
801046f5:	8b 45 f4             	mov    -0xc(%ebp),%eax
801046f8:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
      release(&ptable.lock);
801046ff:	83 ec 0c             	sub    $0xc,%esp
80104702:	68 00 42 19 80       	push   $0x80194200
80104707:	e8 1b 03 00 00       	call   80104a27 <release>
8010470c:	83 c4 10             	add    $0x10,%esp
      return 0;
8010470f:	b8 00 00 00 00       	mov    $0x0,%eax
80104714:	eb 25                	jmp    8010473b <kill+0x85>
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104716:	81 45 f4 84 00 00 00 	addl   $0x84,-0xc(%ebp)
8010471d:	81 7d f4 34 63 19 80 	cmpl   $0x80196334,-0xc(%ebp)
80104724:	72 af                	jb     801046d5 <kill+0x1f>
    }
  }
  release(&ptable.lock);
80104726:	83 ec 0c             	sub    $0xc,%esp
80104729:	68 00 42 19 80       	push   $0x80194200
8010472e:	e8 f4 02 00 00       	call   80104a27 <release>
80104733:	83 c4 10             	add    $0x10,%esp
  return -1;
80104736:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
8010473b:	c9                   	leave  
8010473c:	c3                   	ret    

8010473d <procdump>:
// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void
procdump(void)
{
8010473d:	55                   	push   %ebp
8010473e:	89 e5                	mov    %esp,%ebp
80104740:	83 ec 48             	sub    $0x48,%esp
  int i;
  struct proc *p;
  char *state;
  uint pc[10];

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104743:	c7 45 f0 34 42 19 80 	movl   $0x80194234,-0x10(%ebp)
8010474a:	e9 da 00 00 00       	jmp    80104829 <procdump+0xec>
    if(p->state == UNUSED)
8010474f:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104752:	8b 40 0c             	mov    0xc(%eax),%eax
80104755:	85 c0                	test   %eax,%eax
80104757:	0f 84 c4 00 00 00    	je     80104821 <procdump+0xe4>
      continue;
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
8010475d:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104760:	8b 40 0c             	mov    0xc(%eax),%eax
80104763:	83 f8 05             	cmp    $0x5,%eax
80104766:	77 23                	ja     8010478b <procdump+0x4e>
80104768:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010476b:	8b 40 0c             	mov    0xc(%eax),%eax
8010476e:	8b 04 85 08 f0 10 80 	mov    -0x7fef0ff8(,%eax,4),%eax
80104775:	85 c0                	test   %eax,%eax
80104777:	74 12                	je     8010478b <procdump+0x4e>
      state = states[p->state];
80104779:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010477c:	8b 40 0c             	mov    0xc(%eax),%eax
8010477f:	8b 04 85 08 f0 10 80 	mov    -0x7fef0ff8(,%eax,4),%eax
80104786:	89 45 ec             	mov    %eax,-0x14(%ebp)
80104789:	eb 07                	jmp    80104792 <procdump+0x55>
    else
      state = "???";
8010478b:	c7 45 ec 22 a6 10 80 	movl   $0x8010a622,-0x14(%ebp)
    cprintf("%d %s %s", p->pid, state, p->name);
80104792:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104795:	8d 50 6c             	lea    0x6c(%eax),%edx
80104798:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010479b:	8b 40 10             	mov    0x10(%eax),%eax
8010479e:	52                   	push   %edx
8010479f:	ff 75 ec             	push   -0x14(%ebp)
801047a2:	50                   	push   %eax
801047a3:	68 26 a6 10 80       	push   $0x8010a626
801047a8:	e8 47 bc ff ff       	call   801003f4 <cprintf>
801047ad:	83 c4 10             	add    $0x10,%esp
    if(p->state == SLEEPING){
801047b0:	8b 45 f0             	mov    -0x10(%ebp),%eax
801047b3:	8b 40 0c             	mov    0xc(%eax),%eax
801047b6:	83 f8 02             	cmp    $0x2,%eax
801047b9:	75 54                	jne    8010480f <procdump+0xd2>
      getcallerpcs((uint*)p->context->ebp+2, pc);
801047bb:	8b 45 f0             	mov    -0x10(%ebp),%eax
801047be:	8b 40 1c             	mov    0x1c(%eax),%eax
801047c1:	8b 40 0c             	mov    0xc(%eax),%eax
801047c4:	83 c0 08             	add    $0x8,%eax
801047c7:	89 c2                	mov    %eax,%edx
801047c9:	83 ec 08             	sub    $0x8,%esp
801047cc:	8d 45 c4             	lea    -0x3c(%ebp),%eax
801047cf:	50                   	push   %eax
801047d0:	52                   	push   %edx
801047d1:	e8 a3 02 00 00       	call   80104a79 <getcallerpcs>
801047d6:	83 c4 10             	add    $0x10,%esp
      for(i=0; i<10 && pc[i] != 0; i++)
801047d9:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
801047e0:	eb 1c                	jmp    801047fe <procdump+0xc1>
        cprintf(" %p", pc[i]);
801047e2:	8b 45 f4             	mov    -0xc(%ebp),%eax
801047e5:	8b 44 85 c4          	mov    -0x3c(%ebp,%eax,4),%eax
801047e9:	83 ec 08             	sub    $0x8,%esp
801047ec:	50                   	push   %eax
801047ed:	68 2f a6 10 80       	push   $0x8010a62f
801047f2:	e8 fd bb ff ff       	call   801003f4 <cprintf>
801047f7:	83 c4 10             	add    $0x10,%esp
      for(i=0; i<10 && pc[i] != 0; i++)
801047fa:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
801047fe:	83 7d f4 09          	cmpl   $0x9,-0xc(%ebp)
80104802:	7f 0b                	jg     8010480f <procdump+0xd2>
80104804:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104807:	8b 44 85 c4          	mov    -0x3c(%ebp,%eax,4),%eax
8010480b:	85 c0                	test   %eax,%eax
8010480d:	75 d3                	jne    801047e2 <procdump+0xa5>
    }
    cprintf("\n");
8010480f:	83 ec 0c             	sub    $0xc,%esp
80104812:	68 33 a6 10 80       	push   $0x8010a633
80104817:	e8 d8 bb ff ff       	call   801003f4 <cprintf>
8010481c:	83 c4 10             	add    $0x10,%esp
8010481f:	eb 01                	jmp    80104822 <procdump+0xe5>
      continue;
80104821:	90                   	nop
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104822:	81 45 f0 84 00 00 00 	addl   $0x84,-0x10(%ebp)
80104829:	81 7d f0 34 63 19 80 	cmpl   $0x80196334,-0x10(%ebp)
80104830:	0f 82 19 ff ff ff    	jb     8010474f <procdump+0x12>
  }
}
80104836:	90                   	nop
80104837:	90                   	nop
80104838:	c9                   	leave  
80104839:	c3                   	ret    

8010483a <initsleeplock>:
#include "spinlock.h"
#include "sleeplock.h"

void
initsleeplock(struct sleeplock *lk, char *name)
{
8010483a:	55                   	push   %ebp
8010483b:	89 e5                	mov    %esp,%ebp
8010483d:	83 ec 08             	sub    $0x8,%esp
  initlock(&lk->lk, "sleep lock");
80104840:	8b 45 08             	mov    0x8(%ebp),%eax
80104843:	83 c0 04             	add    $0x4,%eax
80104846:	83 ec 08             	sub    $0x8,%esp
80104849:	68 5f a6 10 80       	push   $0x8010a65f
8010484e:	50                   	push   %eax
8010484f:	e8 43 01 00 00       	call   80104997 <initlock>
80104854:	83 c4 10             	add    $0x10,%esp
  lk->name = name;
80104857:	8b 45 08             	mov    0x8(%ebp),%eax
8010485a:	8b 55 0c             	mov    0xc(%ebp),%edx
8010485d:	89 50 38             	mov    %edx,0x38(%eax)
  lk->locked = 0;
80104860:	8b 45 08             	mov    0x8(%ebp),%eax
80104863:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  lk->pid = 0;
80104869:	8b 45 08             	mov    0x8(%ebp),%eax
8010486c:	c7 40 3c 00 00 00 00 	movl   $0x0,0x3c(%eax)
}
80104873:	90                   	nop
80104874:	c9                   	leave  
80104875:	c3                   	ret    

80104876 <acquiresleep>:

void
acquiresleep(struct sleeplock *lk)
{
80104876:	55                   	push   %ebp
80104877:	89 e5                	mov    %esp,%ebp
80104879:	83 ec 08             	sub    $0x8,%esp
  acquire(&lk->lk);
8010487c:	8b 45 08             	mov    0x8(%ebp),%eax
8010487f:	83 c0 04             	add    $0x4,%eax
80104882:	83 ec 0c             	sub    $0xc,%esp
80104885:	50                   	push   %eax
80104886:	e8 2e 01 00 00       	call   801049b9 <acquire>
8010488b:	83 c4 10             	add    $0x10,%esp
  while (lk->locked) {
8010488e:	eb 15                	jmp    801048a5 <acquiresleep+0x2f>
    sleep(lk, &lk->lk);
80104890:	8b 45 08             	mov    0x8(%ebp),%eax
80104893:	83 c0 04             	add    $0x4,%eax
80104896:	83 ec 08             	sub    $0x8,%esp
80104899:	50                   	push   %eax
8010489a:	ff 75 08             	push   0x8(%ebp)
8010489d:	e8 f3 fc ff ff       	call   80104595 <sleep>
801048a2:	83 c4 10             	add    $0x10,%esp
  while (lk->locked) {
801048a5:	8b 45 08             	mov    0x8(%ebp),%eax
801048a8:	8b 00                	mov    (%eax),%eax
801048aa:	85 c0                	test   %eax,%eax
801048ac:	75 e2                	jne    80104890 <acquiresleep+0x1a>
  }
  lk->locked = 1;
801048ae:	8b 45 08             	mov    0x8(%ebp),%eax
801048b1:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  lk->pid = myproc()->pid;
801048b7:	e8 74 f1 ff ff       	call   80103a30 <myproc>
801048bc:	8b 50 10             	mov    0x10(%eax),%edx
801048bf:	8b 45 08             	mov    0x8(%ebp),%eax
801048c2:	89 50 3c             	mov    %edx,0x3c(%eax)
  release(&lk->lk);
801048c5:	8b 45 08             	mov    0x8(%ebp),%eax
801048c8:	83 c0 04             	add    $0x4,%eax
801048cb:	83 ec 0c             	sub    $0xc,%esp
801048ce:	50                   	push   %eax
801048cf:	e8 53 01 00 00       	call   80104a27 <release>
801048d4:	83 c4 10             	add    $0x10,%esp
}
801048d7:	90                   	nop
801048d8:	c9                   	leave  
801048d9:	c3                   	ret    

801048da <releasesleep>:

void
releasesleep(struct sleeplock *lk)
{
801048da:	55                   	push   %ebp
801048db:	89 e5                	mov    %esp,%ebp
801048dd:	83 ec 08             	sub    $0x8,%esp
  acquire(&lk->lk);
801048e0:	8b 45 08             	mov    0x8(%ebp),%eax
801048e3:	83 c0 04             	add    $0x4,%eax
801048e6:	83 ec 0c             	sub    $0xc,%esp
801048e9:	50                   	push   %eax
801048ea:	e8 ca 00 00 00       	call   801049b9 <acquire>
801048ef:	83 c4 10             	add    $0x10,%esp
  lk->locked = 0;
801048f2:	8b 45 08             	mov    0x8(%ebp),%eax
801048f5:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  lk->pid = 0;
801048fb:	8b 45 08             	mov    0x8(%ebp),%eax
801048fe:	c7 40 3c 00 00 00 00 	movl   $0x0,0x3c(%eax)
  wakeup(lk);
80104905:	83 ec 0c             	sub    $0xc,%esp
80104908:	ff 75 08             	push   0x8(%ebp)
8010490b:	e8 6f fd ff ff       	call   8010467f <wakeup>
80104910:	83 c4 10             	add    $0x10,%esp
  release(&lk->lk);
80104913:	8b 45 08             	mov    0x8(%ebp),%eax
80104916:	83 c0 04             	add    $0x4,%eax
80104919:	83 ec 0c             	sub    $0xc,%esp
8010491c:	50                   	push   %eax
8010491d:	e8 05 01 00 00       	call   80104a27 <release>
80104922:	83 c4 10             	add    $0x10,%esp
}
80104925:	90                   	nop
80104926:	c9                   	leave  
80104927:	c3                   	ret    

80104928 <holdingsleep>:

int
holdingsleep(struct sleeplock *lk)
{
80104928:	55                   	push   %ebp
80104929:	89 e5                	mov    %esp,%ebp
8010492b:	83 ec 18             	sub    $0x18,%esp
  int r;
  
  acquire(&lk->lk);
8010492e:	8b 45 08             	mov    0x8(%ebp),%eax
80104931:	83 c0 04             	add    $0x4,%eax
80104934:	83 ec 0c             	sub    $0xc,%esp
80104937:	50                   	push   %eax
80104938:	e8 7c 00 00 00       	call   801049b9 <acquire>
8010493d:	83 c4 10             	add    $0x10,%esp
  r = lk->locked;
80104940:	8b 45 08             	mov    0x8(%ebp),%eax
80104943:	8b 00                	mov    (%eax),%eax
80104945:	89 45 f4             	mov    %eax,-0xc(%ebp)
  release(&lk->lk);
80104948:	8b 45 08             	mov    0x8(%ebp),%eax
8010494b:	83 c0 04             	add    $0x4,%eax
8010494e:	83 ec 0c             	sub    $0xc,%esp
80104951:	50                   	push   %eax
80104952:	e8 d0 00 00 00       	call   80104a27 <release>
80104957:	83 c4 10             	add    $0x10,%esp
  return r;
8010495a:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
8010495d:	c9                   	leave  
8010495e:	c3                   	ret    

8010495f <readeflags>:
{
8010495f:	55                   	push   %ebp
80104960:	89 e5                	mov    %esp,%ebp
80104962:	83 ec 10             	sub    $0x10,%esp
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80104965:	9c                   	pushf  
80104966:	58                   	pop    %eax
80104967:	89 45 fc             	mov    %eax,-0x4(%ebp)
  return eflags;
8010496a:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
8010496d:	c9                   	leave  
8010496e:	c3                   	ret    

8010496f <cli>:
{
8010496f:	55                   	push   %ebp
80104970:	89 e5                	mov    %esp,%ebp
  asm volatile("cli");
80104972:	fa                   	cli    
}
80104973:	90                   	nop
80104974:	5d                   	pop    %ebp
80104975:	c3                   	ret    

80104976 <sti>:
{
80104976:	55                   	push   %ebp
80104977:	89 e5                	mov    %esp,%ebp
  asm volatile("sti");
80104979:	fb                   	sti    
}
8010497a:	90                   	nop
8010497b:	5d                   	pop    %ebp
8010497c:	c3                   	ret    

8010497d <xchg>:
{
8010497d:	55                   	push   %ebp
8010497e:	89 e5                	mov    %esp,%ebp
80104980:	83 ec 10             	sub    $0x10,%esp
  asm volatile("lock; xchgl %0, %1" :
80104983:	8b 55 08             	mov    0x8(%ebp),%edx
80104986:	8b 45 0c             	mov    0xc(%ebp),%eax
80104989:	8b 4d 08             	mov    0x8(%ebp),%ecx
8010498c:	f0 87 02             	lock xchg %eax,(%edx)
8010498f:	89 45 fc             	mov    %eax,-0x4(%ebp)
  return result;
80104992:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
80104995:	c9                   	leave  
80104996:	c3                   	ret    

80104997 <initlock>:
#include "proc.h"
#include "spinlock.h"

void
initlock(struct spinlock *lk, char *name)
{
80104997:	55                   	push   %ebp
80104998:	89 e5                	mov    %esp,%ebp
  lk->name = name;
8010499a:	8b 45 08             	mov    0x8(%ebp),%eax
8010499d:	8b 55 0c             	mov    0xc(%ebp),%edx
801049a0:	89 50 04             	mov    %edx,0x4(%eax)
  lk->locked = 0;
801049a3:	8b 45 08             	mov    0x8(%ebp),%eax
801049a6:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  lk->cpu = 0;
801049ac:	8b 45 08             	mov    0x8(%ebp),%eax
801049af:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
}
801049b6:	90                   	nop
801049b7:	5d                   	pop    %ebp
801049b8:	c3                   	ret    

801049b9 <acquire>:
// Loops (spins) until the lock is acquired.
// Holding a lock for a long time may cause
// other CPUs to waste time spinning to acquire it.
void
acquire(struct spinlock *lk)
{
801049b9:	55                   	push   %ebp
801049ba:	89 e5                	mov    %esp,%ebp
801049bc:	53                   	push   %ebx
801049bd:	83 ec 04             	sub    $0x4,%esp
  pushcli(); // disable interrupts to avoid deadlock.
801049c0:	e8 5f 01 00 00       	call   80104b24 <pushcli>
  if(holding(lk)){
801049c5:	8b 45 08             	mov    0x8(%ebp),%eax
801049c8:	83 ec 0c             	sub    $0xc,%esp
801049cb:	50                   	push   %eax
801049cc:	e8 23 01 00 00       	call   80104af4 <holding>
801049d1:	83 c4 10             	add    $0x10,%esp
801049d4:	85 c0                	test   %eax,%eax
801049d6:	74 0d                	je     801049e5 <acquire+0x2c>
    panic("acquire");
801049d8:	83 ec 0c             	sub    $0xc,%esp
801049db:	68 6a a6 10 80       	push   $0x8010a66a
801049e0:	e8 c4 bb ff ff       	call   801005a9 <panic>
  }

  // The xchg is atomic.
  while(xchg(&lk->locked, 1) != 0)
801049e5:	90                   	nop
801049e6:	8b 45 08             	mov    0x8(%ebp),%eax
801049e9:	83 ec 08             	sub    $0x8,%esp
801049ec:	6a 01                	push   $0x1
801049ee:	50                   	push   %eax
801049ef:	e8 89 ff ff ff       	call   8010497d <xchg>
801049f4:	83 c4 10             	add    $0x10,%esp
801049f7:	85 c0                	test   %eax,%eax
801049f9:	75 eb                	jne    801049e6 <acquire+0x2d>
    ;

  // Tell the C compiler and the processor to not move loads or stores
  // past this point, to ensure that the critical section's memory
  // references happen after the lock is acquired.
  __sync_synchronize();
801049fb:	f0 83 0c 24 00       	lock orl $0x0,(%esp)

  // Record info about lock acquisition for debugging.
  lk->cpu = mycpu();
80104a00:	8b 5d 08             	mov    0x8(%ebp),%ebx
80104a03:	e8 b0 ef ff ff       	call   801039b8 <mycpu>
80104a08:	89 43 08             	mov    %eax,0x8(%ebx)
  getcallerpcs(&lk, lk->pcs);
80104a0b:	8b 45 08             	mov    0x8(%ebp),%eax
80104a0e:	83 c0 0c             	add    $0xc,%eax
80104a11:	83 ec 08             	sub    $0x8,%esp
80104a14:	50                   	push   %eax
80104a15:	8d 45 08             	lea    0x8(%ebp),%eax
80104a18:	50                   	push   %eax
80104a19:	e8 5b 00 00 00       	call   80104a79 <getcallerpcs>
80104a1e:	83 c4 10             	add    $0x10,%esp
}
80104a21:	90                   	nop
80104a22:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104a25:	c9                   	leave  
80104a26:	c3                   	ret    

80104a27 <release>:

// Release the lock.
void
release(struct spinlock *lk)
{
80104a27:	55                   	push   %ebp
80104a28:	89 e5                	mov    %esp,%ebp
80104a2a:	83 ec 08             	sub    $0x8,%esp
  if(!holding(lk))
80104a2d:	83 ec 0c             	sub    $0xc,%esp
80104a30:	ff 75 08             	push   0x8(%ebp)
80104a33:	e8 bc 00 00 00       	call   80104af4 <holding>
80104a38:	83 c4 10             	add    $0x10,%esp
80104a3b:	85 c0                	test   %eax,%eax
80104a3d:	75 0d                	jne    80104a4c <release+0x25>
    panic("release");
80104a3f:	83 ec 0c             	sub    $0xc,%esp
80104a42:	68 72 a6 10 80       	push   $0x8010a672
80104a47:	e8 5d bb ff ff       	call   801005a9 <panic>

  lk->pcs[0] = 0;
80104a4c:	8b 45 08             	mov    0x8(%ebp),%eax
80104a4f:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
  lk->cpu = 0;
80104a56:	8b 45 08             	mov    0x8(%ebp),%eax
80104a59:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  // Tell the C compiler and the processor to not move loads or stores
  // past this point, to ensure that all the stores in the critical
  // section are visible to other cores before the lock is released.
  // Both the C compiler and the hardware may re-order loads and
  // stores; __sync_synchronize() tells them both not to.
  __sync_synchronize();
80104a60:	f0 83 0c 24 00       	lock orl $0x0,(%esp)

  // Release the lock, equivalent to lk->locked = 0.
  // This code can't use a C assignment, since it might
  // not be atomic. A real OS would use C atomics here.
  asm volatile("movl $0, %0" : "+m" (lk->locked) : );
80104a65:	8b 45 08             	mov    0x8(%ebp),%eax
80104a68:	8b 55 08             	mov    0x8(%ebp),%edx
80104a6b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

  popcli();
80104a71:	e8 fb 00 00 00       	call   80104b71 <popcli>
}
80104a76:	90                   	nop
80104a77:	c9                   	leave  
80104a78:	c3                   	ret    

80104a79 <getcallerpcs>:

// Record the current call stack in pcs[] by following the %ebp chain.
void
getcallerpcs(void *v, uint pcs[])
{
80104a79:	55                   	push   %ebp
80104a7a:	89 e5                	mov    %esp,%ebp
80104a7c:	83 ec 10             	sub    $0x10,%esp
  uint *ebp;
  int i;

  ebp = (uint*)v - 2;
80104a7f:	8b 45 08             	mov    0x8(%ebp),%eax
80104a82:	83 e8 08             	sub    $0x8,%eax
80104a85:	89 45 fc             	mov    %eax,-0x4(%ebp)
  for(i = 0; i < 10; i++){
80104a88:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
80104a8f:	eb 38                	jmp    80104ac9 <getcallerpcs+0x50>
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
80104a91:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
80104a95:	74 53                	je     80104aea <getcallerpcs+0x71>
80104a97:	81 7d fc ff ff ff 7f 	cmpl   $0x7fffffff,-0x4(%ebp)
80104a9e:	76 4a                	jbe    80104aea <getcallerpcs+0x71>
80104aa0:	83 7d fc ff          	cmpl   $0xffffffff,-0x4(%ebp)
80104aa4:	74 44                	je     80104aea <getcallerpcs+0x71>
      break;
    pcs[i] = ebp[1];     // saved %eip
80104aa6:	8b 45 f8             	mov    -0x8(%ebp),%eax
80104aa9:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80104ab0:	8b 45 0c             	mov    0xc(%ebp),%eax
80104ab3:	01 c2                	add    %eax,%edx
80104ab5:	8b 45 fc             	mov    -0x4(%ebp),%eax
80104ab8:	8b 40 04             	mov    0x4(%eax),%eax
80104abb:	89 02                	mov    %eax,(%edx)
    ebp = (uint*)ebp[0]; // saved %ebp
80104abd:	8b 45 fc             	mov    -0x4(%ebp),%eax
80104ac0:	8b 00                	mov    (%eax),%eax
80104ac2:	89 45 fc             	mov    %eax,-0x4(%ebp)
  for(i = 0; i < 10; i++){
80104ac5:	83 45 f8 01          	addl   $0x1,-0x8(%ebp)
80104ac9:	83 7d f8 09          	cmpl   $0x9,-0x8(%ebp)
80104acd:	7e c2                	jle    80104a91 <getcallerpcs+0x18>
  }
  for(; i < 10; i++)
80104acf:	eb 19                	jmp    80104aea <getcallerpcs+0x71>
    pcs[i] = 0;
80104ad1:	8b 45 f8             	mov    -0x8(%ebp),%eax
80104ad4:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80104adb:	8b 45 0c             	mov    0xc(%ebp),%eax
80104ade:	01 d0                	add    %edx,%eax
80104ae0:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  for(; i < 10; i++)
80104ae6:	83 45 f8 01          	addl   $0x1,-0x8(%ebp)
80104aea:	83 7d f8 09          	cmpl   $0x9,-0x8(%ebp)
80104aee:	7e e1                	jle    80104ad1 <getcallerpcs+0x58>
}
80104af0:	90                   	nop
80104af1:	90                   	nop
80104af2:	c9                   	leave  
80104af3:	c3                   	ret    

80104af4 <holding>:

// Check whether this cpu is holding the lock.
int
holding(struct spinlock *lock)
{
80104af4:	55                   	push   %ebp
80104af5:	89 e5                	mov    %esp,%ebp
80104af7:	53                   	push   %ebx
80104af8:	83 ec 04             	sub    $0x4,%esp
  return lock->locked && lock->cpu == mycpu();
80104afb:	8b 45 08             	mov    0x8(%ebp),%eax
80104afe:	8b 00                	mov    (%eax),%eax
80104b00:	85 c0                	test   %eax,%eax
80104b02:	74 16                	je     80104b1a <holding+0x26>
80104b04:	8b 45 08             	mov    0x8(%ebp),%eax
80104b07:	8b 58 08             	mov    0x8(%eax),%ebx
80104b0a:	e8 a9 ee ff ff       	call   801039b8 <mycpu>
80104b0f:	39 c3                	cmp    %eax,%ebx
80104b11:	75 07                	jne    80104b1a <holding+0x26>
80104b13:	b8 01 00 00 00       	mov    $0x1,%eax
80104b18:	eb 05                	jmp    80104b1f <holding+0x2b>
80104b1a:	b8 00 00 00 00       	mov    $0x0,%eax
}
80104b1f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104b22:	c9                   	leave  
80104b23:	c3                   	ret    

80104b24 <pushcli>:
// it takes two popcli to undo two pushcli.  Also, if interrupts
// are off, then pushcli, popcli leaves them off.

void
pushcli(void)
{
80104b24:	55                   	push   %ebp
80104b25:	89 e5                	mov    %esp,%ebp
80104b27:	83 ec 18             	sub    $0x18,%esp
  int eflags;

  eflags = readeflags();
80104b2a:	e8 30 fe ff ff       	call   8010495f <readeflags>
80104b2f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  cli();
80104b32:	e8 38 fe ff ff       	call   8010496f <cli>
  if(mycpu()->ncli == 0)
80104b37:	e8 7c ee ff ff       	call   801039b8 <mycpu>
80104b3c:	8b 80 a4 00 00 00    	mov    0xa4(%eax),%eax
80104b42:	85 c0                	test   %eax,%eax
80104b44:	75 14                	jne    80104b5a <pushcli+0x36>
    mycpu()->intena = eflags & FL_IF;
80104b46:	e8 6d ee ff ff       	call   801039b8 <mycpu>
80104b4b:	8b 55 f4             	mov    -0xc(%ebp),%edx
80104b4e:	81 e2 00 02 00 00    	and    $0x200,%edx
80104b54:	89 90 a8 00 00 00    	mov    %edx,0xa8(%eax)
  mycpu()->ncli += 1;
80104b5a:	e8 59 ee ff ff       	call   801039b8 <mycpu>
80104b5f:	8b 90 a4 00 00 00    	mov    0xa4(%eax),%edx
80104b65:	83 c2 01             	add    $0x1,%edx
80104b68:	89 90 a4 00 00 00    	mov    %edx,0xa4(%eax)
}
80104b6e:	90                   	nop
80104b6f:	c9                   	leave  
80104b70:	c3                   	ret    

80104b71 <popcli>:

void
popcli(void)
{
80104b71:	55                   	push   %ebp
80104b72:	89 e5                	mov    %esp,%ebp
80104b74:	83 ec 08             	sub    $0x8,%esp
  if(readeflags()&FL_IF)
80104b77:	e8 e3 fd ff ff       	call   8010495f <readeflags>
80104b7c:	25 00 02 00 00       	and    $0x200,%eax
80104b81:	85 c0                	test   %eax,%eax
80104b83:	74 0d                	je     80104b92 <popcli+0x21>
    panic("popcli - interruptible");
80104b85:	83 ec 0c             	sub    $0xc,%esp
80104b88:	68 7a a6 10 80       	push   $0x8010a67a
80104b8d:	e8 17 ba ff ff       	call   801005a9 <panic>
  if(--mycpu()->ncli < 0)
80104b92:	e8 21 ee ff ff       	call   801039b8 <mycpu>
80104b97:	8b 90 a4 00 00 00    	mov    0xa4(%eax),%edx
80104b9d:	83 ea 01             	sub    $0x1,%edx
80104ba0:	89 90 a4 00 00 00    	mov    %edx,0xa4(%eax)
80104ba6:	8b 80 a4 00 00 00    	mov    0xa4(%eax),%eax
80104bac:	85 c0                	test   %eax,%eax
80104bae:	79 0d                	jns    80104bbd <popcli+0x4c>
    panic("popcli");
80104bb0:	83 ec 0c             	sub    $0xc,%esp
80104bb3:	68 91 a6 10 80       	push   $0x8010a691
80104bb8:	e8 ec b9 ff ff       	call   801005a9 <panic>
  if(mycpu()->ncli == 0 && mycpu()->intena)
80104bbd:	e8 f6 ed ff ff       	call   801039b8 <mycpu>
80104bc2:	8b 80 a4 00 00 00    	mov    0xa4(%eax),%eax
80104bc8:	85 c0                	test   %eax,%eax
80104bca:	75 14                	jne    80104be0 <popcli+0x6f>
80104bcc:	e8 e7 ed ff ff       	call   801039b8 <mycpu>
80104bd1:	8b 80 a8 00 00 00    	mov    0xa8(%eax),%eax
80104bd7:	85 c0                	test   %eax,%eax
80104bd9:	74 05                	je     80104be0 <popcli+0x6f>
    sti();
80104bdb:	e8 96 fd ff ff       	call   80104976 <sti>
}
80104be0:	90                   	nop
80104be1:	c9                   	leave  
80104be2:	c3                   	ret    

80104be3 <stosb>:
80104be3:	55                   	push   %ebp
80104be4:	89 e5                	mov    %esp,%ebp
80104be6:	57                   	push   %edi
80104be7:	53                   	push   %ebx
80104be8:	8b 4d 08             	mov    0x8(%ebp),%ecx
80104beb:	8b 55 10             	mov    0x10(%ebp),%edx
80104bee:	8b 45 0c             	mov    0xc(%ebp),%eax
80104bf1:	89 cb                	mov    %ecx,%ebx
80104bf3:	89 df                	mov    %ebx,%edi
80104bf5:	89 d1                	mov    %edx,%ecx
80104bf7:	fc                   	cld    
80104bf8:	f3 aa                	rep stos %al,%es:(%edi)
80104bfa:	89 ca                	mov    %ecx,%edx
80104bfc:	89 fb                	mov    %edi,%ebx
80104bfe:	89 5d 08             	mov    %ebx,0x8(%ebp)
80104c01:	89 55 10             	mov    %edx,0x10(%ebp)
80104c04:	90                   	nop
80104c05:	5b                   	pop    %ebx
80104c06:	5f                   	pop    %edi
80104c07:	5d                   	pop    %ebp
80104c08:	c3                   	ret    

80104c09 <stosl>:
80104c09:	55                   	push   %ebp
80104c0a:	89 e5                	mov    %esp,%ebp
80104c0c:	57                   	push   %edi
80104c0d:	53                   	push   %ebx
80104c0e:	8b 4d 08             	mov    0x8(%ebp),%ecx
80104c11:	8b 55 10             	mov    0x10(%ebp),%edx
80104c14:	8b 45 0c             	mov    0xc(%ebp),%eax
80104c17:	89 cb                	mov    %ecx,%ebx
80104c19:	89 df                	mov    %ebx,%edi
80104c1b:	89 d1                	mov    %edx,%ecx
80104c1d:	fc                   	cld    
80104c1e:	f3 ab                	rep stos %eax,%es:(%edi)
80104c20:	89 ca                	mov    %ecx,%edx
80104c22:	89 fb                	mov    %edi,%ebx
80104c24:	89 5d 08             	mov    %ebx,0x8(%ebp)
80104c27:	89 55 10             	mov    %edx,0x10(%ebp)
80104c2a:	90                   	nop
80104c2b:	5b                   	pop    %ebx
80104c2c:	5f                   	pop    %edi
80104c2d:	5d                   	pop    %ebp
80104c2e:	c3                   	ret    

80104c2f <memset>:
80104c2f:	55                   	push   %ebp
80104c30:	89 e5                	mov    %esp,%ebp
80104c32:	8b 45 08             	mov    0x8(%ebp),%eax
80104c35:	83 e0 03             	and    $0x3,%eax
80104c38:	85 c0                	test   %eax,%eax
80104c3a:	75 43                	jne    80104c7f <memset+0x50>
80104c3c:	8b 45 10             	mov    0x10(%ebp),%eax
80104c3f:	83 e0 03             	and    $0x3,%eax
80104c42:	85 c0                	test   %eax,%eax
80104c44:	75 39                	jne    80104c7f <memset+0x50>
80104c46:	81 65 0c ff 00 00 00 	andl   $0xff,0xc(%ebp)
80104c4d:	8b 45 10             	mov    0x10(%ebp),%eax
80104c50:	c1 e8 02             	shr    $0x2,%eax
80104c53:	89 c2                	mov    %eax,%edx
80104c55:	8b 45 0c             	mov    0xc(%ebp),%eax
80104c58:	c1 e0 18             	shl    $0x18,%eax
80104c5b:	89 c1                	mov    %eax,%ecx
80104c5d:	8b 45 0c             	mov    0xc(%ebp),%eax
80104c60:	c1 e0 10             	shl    $0x10,%eax
80104c63:	09 c1                	or     %eax,%ecx
80104c65:	8b 45 0c             	mov    0xc(%ebp),%eax
80104c68:	c1 e0 08             	shl    $0x8,%eax
80104c6b:	09 c8                	or     %ecx,%eax
80104c6d:	0b 45 0c             	or     0xc(%ebp),%eax
80104c70:	52                   	push   %edx
80104c71:	50                   	push   %eax
80104c72:	ff 75 08             	push   0x8(%ebp)
80104c75:	e8 8f ff ff ff       	call   80104c09 <stosl>
80104c7a:	83 c4 0c             	add    $0xc,%esp
80104c7d:	eb 12                	jmp    80104c91 <memset+0x62>
80104c7f:	8b 45 10             	mov    0x10(%ebp),%eax
80104c82:	50                   	push   %eax
80104c83:	ff 75 0c             	push   0xc(%ebp)
80104c86:	ff 75 08             	push   0x8(%ebp)
80104c89:	e8 55 ff ff ff       	call   80104be3 <stosb>
80104c8e:	83 c4 0c             	add    $0xc,%esp
80104c91:	8b 45 08             	mov    0x8(%ebp),%eax
80104c94:	c9                   	leave  
80104c95:	c3                   	ret    

80104c96 <memcmp>:
80104c96:	55                   	push   %ebp
80104c97:	89 e5                	mov    %esp,%ebp
80104c99:	83 ec 10             	sub    $0x10,%esp
80104c9c:	8b 45 08             	mov    0x8(%ebp),%eax
80104c9f:	89 45 fc             	mov    %eax,-0x4(%ebp)
80104ca2:	8b 45 0c             	mov    0xc(%ebp),%eax
80104ca5:	89 45 f8             	mov    %eax,-0x8(%ebp)
80104ca8:	eb 30                	jmp    80104cda <memcmp+0x44>
80104caa:	8b 45 fc             	mov    -0x4(%ebp),%eax
80104cad:	0f b6 10             	movzbl (%eax),%edx
80104cb0:	8b 45 f8             	mov    -0x8(%ebp),%eax
80104cb3:	0f b6 00             	movzbl (%eax),%eax
80104cb6:	38 c2                	cmp    %al,%dl
80104cb8:	74 18                	je     80104cd2 <memcmp+0x3c>
80104cba:	8b 45 fc             	mov    -0x4(%ebp),%eax
80104cbd:	0f b6 00             	movzbl (%eax),%eax
80104cc0:	0f b6 d0             	movzbl %al,%edx
80104cc3:	8b 45 f8             	mov    -0x8(%ebp),%eax
80104cc6:	0f b6 00             	movzbl (%eax),%eax
80104cc9:	0f b6 c8             	movzbl %al,%ecx
80104ccc:	89 d0                	mov    %edx,%eax
80104cce:	29 c8                	sub    %ecx,%eax
80104cd0:	eb 1a                	jmp    80104cec <memcmp+0x56>
80104cd2:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
80104cd6:	83 45 f8 01          	addl   $0x1,-0x8(%ebp)
80104cda:	8b 45 10             	mov    0x10(%ebp),%eax
80104cdd:	8d 50 ff             	lea    -0x1(%eax),%edx
80104ce0:	89 55 10             	mov    %edx,0x10(%ebp)
80104ce3:	85 c0                	test   %eax,%eax
80104ce5:	75 c3                	jne    80104caa <memcmp+0x14>
80104ce7:	b8 00 00 00 00       	mov    $0x0,%eax
80104cec:	c9                   	leave  
80104ced:	c3                   	ret    

80104cee <memmove>:
80104cee:	55                   	push   %ebp
80104cef:	89 e5                	mov    %esp,%ebp
80104cf1:	83 ec 10             	sub    $0x10,%esp
80104cf4:	8b 45 0c             	mov    0xc(%ebp),%eax
80104cf7:	89 45 fc             	mov    %eax,-0x4(%ebp)
80104cfa:	8b 45 08             	mov    0x8(%ebp),%eax
80104cfd:	89 45 f8             	mov    %eax,-0x8(%ebp)
80104d00:	8b 45 fc             	mov    -0x4(%ebp),%eax
80104d03:	3b 45 f8             	cmp    -0x8(%ebp),%eax
80104d06:	73 54                	jae    80104d5c <memmove+0x6e>
80104d08:	8b 55 fc             	mov    -0x4(%ebp),%edx
80104d0b:	8b 45 10             	mov    0x10(%ebp),%eax
80104d0e:	01 d0                	add    %edx,%eax
80104d10:	39 45 f8             	cmp    %eax,-0x8(%ebp)
80104d13:	73 47                	jae    80104d5c <memmove+0x6e>
80104d15:	8b 45 10             	mov    0x10(%ebp),%eax
80104d18:	01 45 fc             	add    %eax,-0x4(%ebp)
80104d1b:	8b 45 10             	mov    0x10(%ebp),%eax
80104d1e:	01 45 f8             	add    %eax,-0x8(%ebp)
80104d21:	eb 13                	jmp    80104d36 <memmove+0x48>
80104d23:	83 6d fc 01          	subl   $0x1,-0x4(%ebp)
80104d27:	83 6d f8 01          	subl   $0x1,-0x8(%ebp)
80104d2b:	8b 45 fc             	mov    -0x4(%ebp),%eax
80104d2e:	0f b6 10             	movzbl (%eax),%edx
80104d31:	8b 45 f8             	mov    -0x8(%ebp),%eax
80104d34:	88 10                	mov    %dl,(%eax)
80104d36:	8b 45 10             	mov    0x10(%ebp),%eax
80104d39:	8d 50 ff             	lea    -0x1(%eax),%edx
80104d3c:	89 55 10             	mov    %edx,0x10(%ebp)
80104d3f:	85 c0                	test   %eax,%eax
80104d41:	75 e0                	jne    80104d23 <memmove+0x35>
80104d43:	eb 24                	jmp    80104d69 <memmove+0x7b>
80104d45:	8b 55 fc             	mov    -0x4(%ebp),%edx
80104d48:	8d 42 01             	lea    0x1(%edx),%eax
80104d4b:	89 45 fc             	mov    %eax,-0x4(%ebp)
80104d4e:	8b 45 f8             	mov    -0x8(%ebp),%eax
80104d51:	8d 48 01             	lea    0x1(%eax),%ecx
80104d54:	89 4d f8             	mov    %ecx,-0x8(%ebp)
80104d57:	0f b6 12             	movzbl (%edx),%edx
80104d5a:	88 10                	mov    %dl,(%eax)
80104d5c:	8b 45 10             	mov    0x10(%ebp),%eax
80104d5f:	8d 50 ff             	lea    -0x1(%eax),%edx
80104d62:	89 55 10             	mov    %edx,0x10(%ebp)
80104d65:	85 c0                	test   %eax,%eax
80104d67:	75 dc                	jne    80104d45 <memmove+0x57>
80104d69:	8b 45 08             	mov    0x8(%ebp),%eax
80104d6c:	c9                   	leave  
80104d6d:	c3                   	ret    

80104d6e <memcpy>:
80104d6e:	55                   	push   %ebp
80104d6f:	89 e5                	mov    %esp,%ebp
80104d71:	ff 75 10             	push   0x10(%ebp)
80104d74:	ff 75 0c             	push   0xc(%ebp)
80104d77:	ff 75 08             	push   0x8(%ebp)
80104d7a:	e8 6f ff ff ff       	call   80104cee <memmove>
80104d7f:	83 c4 0c             	add    $0xc,%esp
80104d82:	c9                   	leave  
80104d83:	c3                   	ret    

80104d84 <strncmp>:
80104d84:	55                   	push   %ebp
80104d85:	89 e5                	mov    %esp,%ebp
80104d87:	eb 0c                	jmp    80104d95 <strncmp+0x11>
80104d89:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
80104d8d:	83 45 08 01          	addl   $0x1,0x8(%ebp)
80104d91:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
80104d95:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
80104d99:	74 1a                	je     80104db5 <strncmp+0x31>
80104d9b:	8b 45 08             	mov    0x8(%ebp),%eax
80104d9e:	0f b6 00             	movzbl (%eax),%eax
80104da1:	84 c0                	test   %al,%al
80104da3:	74 10                	je     80104db5 <strncmp+0x31>
80104da5:	8b 45 08             	mov    0x8(%ebp),%eax
80104da8:	0f b6 10             	movzbl (%eax),%edx
80104dab:	8b 45 0c             	mov    0xc(%ebp),%eax
80104dae:	0f b6 00             	movzbl (%eax),%eax
80104db1:	38 c2                	cmp    %al,%dl
80104db3:	74 d4                	je     80104d89 <strncmp+0x5>
80104db5:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
80104db9:	75 07                	jne    80104dc2 <strncmp+0x3e>
80104dbb:	b8 00 00 00 00       	mov    $0x0,%eax
80104dc0:	eb 16                	jmp    80104dd8 <strncmp+0x54>
80104dc2:	8b 45 08             	mov    0x8(%ebp),%eax
80104dc5:	0f b6 00             	movzbl (%eax),%eax
80104dc8:	0f b6 d0             	movzbl %al,%edx
80104dcb:	8b 45 0c             	mov    0xc(%ebp),%eax
80104dce:	0f b6 00             	movzbl (%eax),%eax
80104dd1:	0f b6 c8             	movzbl %al,%ecx
80104dd4:	89 d0                	mov    %edx,%eax
80104dd6:	29 c8                	sub    %ecx,%eax
80104dd8:	5d                   	pop    %ebp
80104dd9:	c3                   	ret    

80104dda <strncpy>:
80104dda:	55                   	push   %ebp
80104ddb:	89 e5                	mov    %esp,%ebp
80104ddd:	83 ec 10             	sub    $0x10,%esp
80104de0:	8b 45 08             	mov    0x8(%ebp),%eax
80104de3:	89 45 fc             	mov    %eax,-0x4(%ebp)
80104de6:	90                   	nop
80104de7:	8b 45 10             	mov    0x10(%ebp),%eax
80104dea:	8d 50 ff             	lea    -0x1(%eax),%edx
80104ded:	89 55 10             	mov    %edx,0x10(%ebp)
80104df0:	85 c0                	test   %eax,%eax
80104df2:	7e 2c                	jle    80104e20 <strncpy+0x46>
80104df4:	8b 55 0c             	mov    0xc(%ebp),%edx
80104df7:	8d 42 01             	lea    0x1(%edx),%eax
80104dfa:	89 45 0c             	mov    %eax,0xc(%ebp)
80104dfd:	8b 45 08             	mov    0x8(%ebp),%eax
80104e00:	8d 48 01             	lea    0x1(%eax),%ecx
80104e03:	89 4d 08             	mov    %ecx,0x8(%ebp)
80104e06:	0f b6 12             	movzbl (%edx),%edx
80104e09:	88 10                	mov    %dl,(%eax)
80104e0b:	0f b6 00             	movzbl (%eax),%eax
80104e0e:	84 c0                	test   %al,%al
80104e10:	75 d5                	jne    80104de7 <strncpy+0xd>
80104e12:	eb 0c                	jmp    80104e20 <strncpy+0x46>
80104e14:	8b 45 08             	mov    0x8(%ebp),%eax
80104e17:	8d 50 01             	lea    0x1(%eax),%edx
80104e1a:	89 55 08             	mov    %edx,0x8(%ebp)
80104e1d:	c6 00 00             	movb   $0x0,(%eax)
80104e20:	8b 45 10             	mov    0x10(%ebp),%eax
80104e23:	8d 50 ff             	lea    -0x1(%eax),%edx
80104e26:	89 55 10             	mov    %edx,0x10(%ebp)
80104e29:	85 c0                	test   %eax,%eax
80104e2b:	7f e7                	jg     80104e14 <strncpy+0x3a>
80104e2d:	8b 45 fc             	mov    -0x4(%ebp),%eax
80104e30:	c9                   	leave  
80104e31:	c3                   	ret    

80104e32 <safestrcpy>:
80104e32:	55                   	push   %ebp
80104e33:	89 e5                	mov    %esp,%ebp
80104e35:	83 ec 10             	sub    $0x10,%esp
80104e38:	8b 45 08             	mov    0x8(%ebp),%eax
80104e3b:	89 45 fc             	mov    %eax,-0x4(%ebp)
80104e3e:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
80104e42:	7f 05                	jg     80104e49 <safestrcpy+0x17>
80104e44:	8b 45 fc             	mov    -0x4(%ebp),%eax
80104e47:	eb 32                	jmp    80104e7b <safestrcpy+0x49>
80104e49:	90                   	nop
80104e4a:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
80104e4e:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
80104e52:	7e 1e                	jle    80104e72 <safestrcpy+0x40>
80104e54:	8b 55 0c             	mov    0xc(%ebp),%edx
80104e57:	8d 42 01             	lea    0x1(%edx),%eax
80104e5a:	89 45 0c             	mov    %eax,0xc(%ebp)
80104e5d:	8b 45 08             	mov    0x8(%ebp),%eax
80104e60:	8d 48 01             	lea    0x1(%eax),%ecx
80104e63:	89 4d 08             	mov    %ecx,0x8(%ebp)
80104e66:	0f b6 12             	movzbl (%edx),%edx
80104e69:	88 10                	mov    %dl,(%eax)
80104e6b:	0f b6 00             	movzbl (%eax),%eax
80104e6e:	84 c0                	test   %al,%al
80104e70:	75 d8                	jne    80104e4a <safestrcpy+0x18>
80104e72:	8b 45 08             	mov    0x8(%ebp),%eax
80104e75:	c6 00 00             	movb   $0x0,(%eax)
80104e78:	8b 45 fc             	mov    -0x4(%ebp),%eax
80104e7b:	c9                   	leave  
80104e7c:	c3                   	ret    

80104e7d <strlen>:
80104e7d:	55                   	push   %ebp
80104e7e:	89 e5                	mov    %esp,%ebp
80104e80:	83 ec 10             	sub    $0x10,%esp
80104e83:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
80104e8a:	eb 04                	jmp    80104e90 <strlen+0x13>
80104e8c:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
80104e90:	8b 55 fc             	mov    -0x4(%ebp),%edx
80104e93:	8b 45 08             	mov    0x8(%ebp),%eax
80104e96:	01 d0                	add    %edx,%eax
80104e98:	0f b6 00             	movzbl (%eax),%eax
80104e9b:	84 c0                	test   %al,%al
80104e9d:	75 ed                	jne    80104e8c <strlen+0xf>
80104e9f:	8b 45 fc             	mov    -0x4(%ebp),%eax
80104ea2:	c9                   	leave  
80104ea3:	c3                   	ret    

80104ea4 <swtch>:
80104ea4:	8b 44 24 04          	mov    0x4(%esp),%eax
80104ea8:	8b 54 24 08          	mov    0x8(%esp),%edx
80104eac:	55                   	push   %ebp
80104ead:	53                   	push   %ebx
80104eae:	56                   	push   %esi
80104eaf:	57                   	push   %edi
80104eb0:	89 20                	mov    %esp,(%eax)
80104eb2:	89 d4                	mov    %edx,%esp
80104eb4:	5f                   	pop    %edi
80104eb5:	5e                   	pop    %esi
80104eb6:	5b                   	pop    %ebx
80104eb7:	5d                   	pop    %ebp
80104eb8:	c3                   	ret    

80104eb9 <fetchint>:
// to a saved program counter, and then the first argument.

// Fetch the int at addr from the current process.
int
fetchint(uint addr, int *ip)
{
80104eb9:	55                   	push   %ebp
80104eba:	89 e5                	mov    %esp,%ebp
80104ebc:	83 ec 18             	sub    $0x18,%esp
  struct proc *curproc = myproc();
80104ebf:	e8 6c eb ff ff       	call   80103a30 <myproc>
80104ec4:	89 45 f4             	mov    %eax,-0xc(%ebp)

  if(addr >= curproc->sz || addr+4 > curproc->sz)
80104ec7:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104eca:	8b 00                	mov    (%eax),%eax
80104ecc:	39 45 08             	cmp    %eax,0x8(%ebp)
80104ecf:	73 0f                	jae    80104ee0 <fetchint+0x27>
80104ed1:	8b 45 08             	mov    0x8(%ebp),%eax
80104ed4:	8d 50 04             	lea    0x4(%eax),%edx
80104ed7:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104eda:	8b 00                	mov    (%eax),%eax
80104edc:	39 c2                	cmp    %eax,%edx
80104ede:	76 07                	jbe    80104ee7 <fetchint+0x2e>
    return -1;
80104ee0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104ee5:	eb 0f                	jmp    80104ef6 <fetchint+0x3d>
  *ip = *(int*)(addr);
80104ee7:	8b 45 08             	mov    0x8(%ebp),%eax
80104eea:	8b 10                	mov    (%eax),%edx
80104eec:	8b 45 0c             	mov    0xc(%ebp),%eax
80104eef:	89 10                	mov    %edx,(%eax)
  return 0;
80104ef1:	b8 00 00 00 00       	mov    $0x0,%eax
}
80104ef6:	c9                   	leave  
80104ef7:	c3                   	ret    

80104ef8 <fetchstr>:
// Fetch the nul-terminated string at addr from the current process.
// Doesn't actually copy the string - just sets *pp to point at it.
// Returns length of string, not including nul.
int
fetchstr(uint addr, char **pp)
{
80104ef8:	55                   	push   %ebp
80104ef9:	89 e5                	mov    %esp,%ebp
80104efb:	83 ec 18             	sub    $0x18,%esp
  char *s, *ep;
  struct proc *curproc = myproc();
80104efe:	e8 2d eb ff ff       	call   80103a30 <myproc>
80104f03:	89 45 f0             	mov    %eax,-0x10(%ebp)

  if(addr >= curproc->sz)
80104f06:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104f09:	8b 00                	mov    (%eax),%eax
80104f0b:	39 45 08             	cmp    %eax,0x8(%ebp)
80104f0e:	72 07                	jb     80104f17 <fetchstr+0x1f>
    return -1;
80104f10:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104f15:	eb 41                	jmp    80104f58 <fetchstr+0x60>
  *pp = (char*)addr;
80104f17:	8b 55 08             	mov    0x8(%ebp),%edx
80104f1a:	8b 45 0c             	mov    0xc(%ebp),%eax
80104f1d:	89 10                	mov    %edx,(%eax)
  ep = (char*)curproc->sz;
80104f1f:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104f22:	8b 00                	mov    (%eax),%eax
80104f24:	89 45 ec             	mov    %eax,-0x14(%ebp)
  for(s = *pp; s < ep; s++){
80104f27:	8b 45 0c             	mov    0xc(%ebp),%eax
80104f2a:	8b 00                	mov    (%eax),%eax
80104f2c:	89 45 f4             	mov    %eax,-0xc(%ebp)
80104f2f:	eb 1a                	jmp    80104f4b <fetchstr+0x53>
    if(*s == 0)
80104f31:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104f34:	0f b6 00             	movzbl (%eax),%eax
80104f37:	84 c0                	test   %al,%al
80104f39:	75 0c                	jne    80104f47 <fetchstr+0x4f>
      return s - *pp;
80104f3b:	8b 45 0c             	mov    0xc(%ebp),%eax
80104f3e:	8b 10                	mov    (%eax),%edx
80104f40:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104f43:	29 d0                	sub    %edx,%eax
80104f45:	eb 11                	jmp    80104f58 <fetchstr+0x60>
  for(s = *pp; s < ep; s++){
80104f47:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80104f4b:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104f4e:	3b 45 ec             	cmp    -0x14(%ebp),%eax
80104f51:	72 de                	jb     80104f31 <fetchstr+0x39>
  }
  return -1;
80104f53:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104f58:	c9                   	leave  
80104f59:	c3                   	ret    

80104f5a <argint>:

// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
80104f5a:	55                   	push   %ebp
80104f5b:	89 e5                	mov    %esp,%ebp
80104f5d:	83 ec 08             	sub    $0x8,%esp
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80104f60:	e8 cb ea ff ff       	call   80103a30 <myproc>
80104f65:	8b 40 18             	mov    0x18(%eax),%eax
80104f68:	8b 50 44             	mov    0x44(%eax),%edx
80104f6b:	8b 45 08             	mov    0x8(%ebp),%eax
80104f6e:	c1 e0 02             	shl    $0x2,%eax
80104f71:	01 d0                	add    %edx,%eax
80104f73:	83 c0 04             	add    $0x4,%eax
80104f76:	83 ec 08             	sub    $0x8,%esp
80104f79:	ff 75 0c             	push   0xc(%ebp)
80104f7c:	50                   	push   %eax
80104f7d:	e8 37 ff ff ff       	call   80104eb9 <fetchint>
80104f82:	83 c4 10             	add    $0x10,%esp
}
80104f85:	c9                   	leave  
80104f86:	c3                   	ret    

80104f87 <argptr>:
// Fetch the nth word-sized system call argument as a pointer
// to a block of memory of size bytes.  Check that the pointer
// lies within the process address space.
int
argptr(int n, char **pp, int size)
{
80104f87:	55                   	push   %ebp
80104f88:	89 e5                	mov    %esp,%ebp
80104f8a:	83 ec 18             	sub    $0x18,%esp
  int i;
  struct proc *curproc = myproc();
80104f8d:	e8 9e ea ff ff       	call   80103a30 <myproc>
80104f92:	89 45 f4             	mov    %eax,-0xc(%ebp)
 
  if(argint(n, &i) < 0)
80104f95:	83 ec 08             	sub    $0x8,%esp
80104f98:	8d 45 f0             	lea    -0x10(%ebp),%eax
80104f9b:	50                   	push   %eax
80104f9c:	ff 75 08             	push   0x8(%ebp)
80104f9f:	e8 b6 ff ff ff       	call   80104f5a <argint>
80104fa4:	83 c4 10             	add    $0x10,%esp
80104fa7:	85 c0                	test   %eax,%eax
80104fa9:	79 07                	jns    80104fb2 <argptr+0x2b>
    return -1;
80104fab:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104fb0:	eb 3b                	jmp    80104fed <argptr+0x66>
  if(size < 0 || (uint)i >= curproc->sz || (uint)i+size > curproc->sz)
80104fb2:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
80104fb6:	78 1f                	js     80104fd7 <argptr+0x50>
80104fb8:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104fbb:	8b 00                	mov    (%eax),%eax
80104fbd:	8b 55 f0             	mov    -0x10(%ebp),%edx
80104fc0:	39 d0                	cmp    %edx,%eax
80104fc2:	76 13                	jbe    80104fd7 <argptr+0x50>
80104fc4:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104fc7:	89 c2                	mov    %eax,%edx
80104fc9:	8b 45 10             	mov    0x10(%ebp),%eax
80104fcc:	01 c2                	add    %eax,%edx
80104fce:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104fd1:	8b 00                	mov    (%eax),%eax
80104fd3:	39 c2                	cmp    %eax,%edx
80104fd5:	76 07                	jbe    80104fde <argptr+0x57>
    return -1;
80104fd7:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104fdc:	eb 0f                	jmp    80104fed <argptr+0x66>
  *pp = (char*)i;
80104fde:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104fe1:	89 c2                	mov    %eax,%edx
80104fe3:	8b 45 0c             	mov    0xc(%ebp),%eax
80104fe6:	89 10                	mov    %edx,(%eax)
  return 0;
80104fe8:	b8 00 00 00 00       	mov    $0x0,%eax
}
80104fed:	c9                   	leave  
80104fee:	c3                   	ret    

80104fef <argstr>:
// Check that the pointer is valid and the string is nul-terminated.
// (There is no shared writable memory, so the string can't change
// between this check and being used by the kernel.)
int
argstr(int n, char **pp)
{
80104fef:	55                   	push   %ebp
80104ff0:	89 e5                	mov    %esp,%ebp
80104ff2:	83 ec 18             	sub    $0x18,%esp
  int addr;
  if(argint(n, &addr) < 0)
80104ff5:	83 ec 08             	sub    $0x8,%esp
80104ff8:	8d 45 f4             	lea    -0xc(%ebp),%eax
80104ffb:	50                   	push   %eax
80104ffc:	ff 75 08             	push   0x8(%ebp)
80104fff:	e8 56 ff ff ff       	call   80104f5a <argint>
80105004:	83 c4 10             	add    $0x10,%esp
80105007:	85 c0                	test   %eax,%eax
80105009:	79 07                	jns    80105012 <argstr+0x23>
    return -1;
8010500b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105010:	eb 12                	jmp    80105024 <argstr+0x35>
  return fetchstr(addr, pp);
80105012:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105015:	83 ec 08             	sub    $0x8,%esp
80105018:	ff 75 0c             	push   0xc(%ebp)
8010501b:	50                   	push   %eax
8010501c:	e8 d7 fe ff ff       	call   80104ef8 <fetchstr>
80105021:	83 c4 10             	add    $0x10,%esp
}
80105024:	c9                   	leave  
80105025:	c3                   	ret    

80105026 <syscall>:
[SYS_uthread_init]   sys_uthread_init,
};

void
syscall(void)
{
80105026:	55                   	push   %ebp
80105027:	89 e5                	mov    %esp,%ebp
80105029:	83 ec 18             	sub    $0x18,%esp
  int num;
  struct proc *curproc = myproc();
8010502c:	e8 ff e9 ff ff       	call   80103a30 <myproc>
80105031:	89 45 f4             	mov    %eax,-0xc(%ebp)

  num = curproc->tf->eax;
80105034:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105037:	8b 40 18             	mov    0x18(%eax),%eax
8010503a:	8b 40 1c             	mov    0x1c(%eax),%eax
8010503d:	89 45 f0             	mov    %eax,-0x10(%ebp)
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
80105040:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80105044:	7e 2f                	jle    80105075 <syscall+0x4f>
80105046:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105049:	83 f8 18             	cmp    $0x18,%eax
8010504c:	77 27                	ja     80105075 <syscall+0x4f>
8010504e:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105051:	8b 04 85 20 f0 10 80 	mov    -0x7fef0fe0(,%eax,4),%eax
80105058:	85 c0                	test   %eax,%eax
8010505a:	74 19                	je     80105075 <syscall+0x4f>
    curproc->tf->eax = syscalls[num]();
8010505c:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010505f:	8b 04 85 20 f0 10 80 	mov    -0x7fef0fe0(,%eax,4),%eax
80105066:	ff d0                	call   *%eax
80105068:	89 c2                	mov    %eax,%edx
8010506a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010506d:	8b 40 18             	mov    0x18(%eax),%eax
80105070:	89 50 1c             	mov    %edx,0x1c(%eax)
80105073:	eb 2c                	jmp    801050a1 <syscall+0x7b>
  } else {
    cprintf("%d %s: unknown sys call %d\n",
            curproc->pid, curproc->name, num);
80105075:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105078:	8d 50 6c             	lea    0x6c(%eax),%edx
    cprintf("%d %s: unknown sys call %d\n",
8010507b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010507e:	8b 40 10             	mov    0x10(%eax),%eax
80105081:	ff 75 f0             	push   -0x10(%ebp)
80105084:	52                   	push   %edx
80105085:	50                   	push   %eax
80105086:	68 98 a6 10 80       	push   $0x8010a698
8010508b:	e8 64 b3 ff ff       	call   801003f4 <cprintf>
80105090:	83 c4 10             	add    $0x10,%esp
    curproc->tf->eax = -1;
80105093:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105096:	8b 40 18             	mov    0x18(%eax),%eax
80105099:	c7 40 1c ff ff ff ff 	movl   $0xffffffff,0x1c(%eax)
  }
}
801050a0:	90                   	nop
801050a1:	90                   	nop
801050a2:	c9                   	leave  
801050a3:	c3                   	ret    

801050a4 <argfd>:

// Fetch the nth word-sized system call argument as a file descriptor
// and return both the descriptor and the corresponding struct file.
static int
argfd(int n, int *pfd, struct file **pf)
{
801050a4:	55                   	push   %ebp
801050a5:	89 e5                	mov    %esp,%ebp
801050a7:	83 ec 18             	sub    $0x18,%esp
  int fd;
  struct file *f;

  if(argint(n, &fd) < 0)
801050aa:	83 ec 08             	sub    $0x8,%esp
801050ad:	8d 45 f0             	lea    -0x10(%ebp),%eax
801050b0:	50                   	push   %eax
801050b1:	ff 75 08             	push   0x8(%ebp)
801050b4:	e8 a1 fe ff ff       	call   80104f5a <argint>
801050b9:	83 c4 10             	add    $0x10,%esp
801050bc:	85 c0                	test   %eax,%eax
801050be:	79 07                	jns    801050c7 <argfd+0x23>
    return -1;
801050c0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801050c5:	eb 4f                	jmp    80105116 <argfd+0x72>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
801050c7:	8b 45 f0             	mov    -0x10(%ebp),%eax
801050ca:	85 c0                	test   %eax,%eax
801050cc:	78 20                	js     801050ee <argfd+0x4a>
801050ce:	8b 45 f0             	mov    -0x10(%ebp),%eax
801050d1:	83 f8 0f             	cmp    $0xf,%eax
801050d4:	7f 18                	jg     801050ee <argfd+0x4a>
801050d6:	e8 55 e9 ff ff       	call   80103a30 <myproc>
801050db:	8b 55 f0             	mov    -0x10(%ebp),%edx
801050de:	83 c2 08             	add    $0x8,%edx
801050e1:	8b 44 90 08          	mov    0x8(%eax,%edx,4),%eax
801050e5:	89 45 f4             	mov    %eax,-0xc(%ebp)
801050e8:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801050ec:	75 07                	jne    801050f5 <argfd+0x51>
    return -1;
801050ee:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801050f3:	eb 21                	jmp    80105116 <argfd+0x72>
  if(pfd)
801050f5:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
801050f9:	74 08                	je     80105103 <argfd+0x5f>
    *pfd = fd;
801050fb:	8b 55 f0             	mov    -0x10(%ebp),%edx
801050fe:	8b 45 0c             	mov    0xc(%ebp),%eax
80105101:	89 10                	mov    %edx,(%eax)
  if(pf)
80105103:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
80105107:	74 08                	je     80105111 <argfd+0x6d>
    *pf = f;
80105109:	8b 45 10             	mov    0x10(%ebp),%eax
8010510c:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010510f:	89 10                	mov    %edx,(%eax)
  return 0;
80105111:	b8 00 00 00 00       	mov    $0x0,%eax
}
80105116:	c9                   	leave  
80105117:	c3                   	ret    

80105118 <fdalloc>:

// Allocate a file descriptor for the given file.
// Takes over file reference from caller on success.
static int
fdalloc(struct file *f)
{
80105118:	55                   	push   %ebp
80105119:	89 e5                	mov    %esp,%ebp
8010511b:	83 ec 18             	sub    $0x18,%esp
  int fd;
  struct proc *curproc = myproc();
8010511e:	e8 0d e9 ff ff       	call   80103a30 <myproc>
80105123:	89 45 f0             	mov    %eax,-0x10(%ebp)

  for(fd = 0; fd < NOFILE; fd++){
80105126:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
8010512d:	eb 2a                	jmp    80105159 <fdalloc+0x41>
    if(curproc->ofile[fd] == 0){
8010512f:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105132:	8b 55 f4             	mov    -0xc(%ebp),%edx
80105135:	83 c2 08             	add    $0x8,%edx
80105138:	8b 44 90 08          	mov    0x8(%eax,%edx,4),%eax
8010513c:	85 c0                	test   %eax,%eax
8010513e:	75 15                	jne    80105155 <fdalloc+0x3d>
      curproc->ofile[fd] = f;
80105140:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105143:	8b 55 f4             	mov    -0xc(%ebp),%edx
80105146:	8d 4a 08             	lea    0x8(%edx),%ecx
80105149:	8b 55 08             	mov    0x8(%ebp),%edx
8010514c:	89 54 88 08          	mov    %edx,0x8(%eax,%ecx,4)
      return fd;
80105150:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105153:	eb 0f                	jmp    80105164 <fdalloc+0x4c>
  for(fd = 0; fd < NOFILE; fd++){
80105155:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80105159:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
8010515d:	7e d0                	jle    8010512f <fdalloc+0x17>
    }
  }
  return -1;
8010515f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105164:	c9                   	leave  
80105165:	c3                   	ret    

80105166 <sys_dup>:

int
sys_dup(void)
{
80105166:	55                   	push   %ebp
80105167:	89 e5                	mov    %esp,%ebp
80105169:	83 ec 18             	sub    $0x18,%esp
  struct file *f;
  int fd;

  if(argfd(0, 0, &f) < 0)
8010516c:	83 ec 04             	sub    $0x4,%esp
8010516f:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105172:	50                   	push   %eax
80105173:	6a 00                	push   $0x0
80105175:	6a 00                	push   $0x0
80105177:	e8 28 ff ff ff       	call   801050a4 <argfd>
8010517c:	83 c4 10             	add    $0x10,%esp
8010517f:	85 c0                	test   %eax,%eax
80105181:	79 07                	jns    8010518a <sys_dup+0x24>
    return -1;
80105183:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105188:	eb 31                	jmp    801051bb <sys_dup+0x55>
  if((fd=fdalloc(f)) < 0)
8010518a:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010518d:	83 ec 0c             	sub    $0xc,%esp
80105190:	50                   	push   %eax
80105191:	e8 82 ff ff ff       	call   80105118 <fdalloc>
80105196:	83 c4 10             	add    $0x10,%esp
80105199:	89 45 f4             	mov    %eax,-0xc(%ebp)
8010519c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801051a0:	79 07                	jns    801051a9 <sys_dup+0x43>
    return -1;
801051a2:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801051a7:	eb 12                	jmp    801051bb <sys_dup+0x55>
  filedup(f);
801051a9:	8b 45 f0             	mov    -0x10(%ebp),%eax
801051ac:	83 ec 0c             	sub    $0xc,%esp
801051af:	50                   	push   %eax
801051b0:	e8 95 be ff ff       	call   8010104a <filedup>
801051b5:	83 c4 10             	add    $0x10,%esp
  return fd;
801051b8:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
801051bb:	c9                   	leave  
801051bc:	c3                   	ret    

801051bd <sys_read>:

int
sys_read(void)
{
801051bd:	55                   	push   %ebp
801051be:	89 e5                	mov    %esp,%ebp
801051c0:	83 ec 18             	sub    $0x18,%esp
  struct file *f;
  int n;
  char *p;

  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
801051c3:	83 ec 04             	sub    $0x4,%esp
801051c6:	8d 45 f4             	lea    -0xc(%ebp),%eax
801051c9:	50                   	push   %eax
801051ca:	6a 00                	push   $0x0
801051cc:	6a 00                	push   $0x0
801051ce:	e8 d1 fe ff ff       	call   801050a4 <argfd>
801051d3:	83 c4 10             	add    $0x10,%esp
801051d6:	85 c0                	test   %eax,%eax
801051d8:	78 2e                	js     80105208 <sys_read+0x4b>
801051da:	83 ec 08             	sub    $0x8,%esp
801051dd:	8d 45 f0             	lea    -0x10(%ebp),%eax
801051e0:	50                   	push   %eax
801051e1:	6a 02                	push   $0x2
801051e3:	e8 72 fd ff ff       	call   80104f5a <argint>
801051e8:	83 c4 10             	add    $0x10,%esp
801051eb:	85 c0                	test   %eax,%eax
801051ed:	78 19                	js     80105208 <sys_read+0x4b>
801051ef:	8b 45 f0             	mov    -0x10(%ebp),%eax
801051f2:	83 ec 04             	sub    $0x4,%esp
801051f5:	50                   	push   %eax
801051f6:	8d 45 ec             	lea    -0x14(%ebp),%eax
801051f9:	50                   	push   %eax
801051fa:	6a 01                	push   $0x1
801051fc:	e8 86 fd ff ff       	call   80104f87 <argptr>
80105201:	83 c4 10             	add    $0x10,%esp
80105204:	85 c0                	test   %eax,%eax
80105206:	79 07                	jns    8010520f <sys_read+0x52>
    return -1;
80105208:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010520d:	eb 17                	jmp    80105226 <sys_read+0x69>
  return fileread(f, p, n);
8010520f:	8b 4d f0             	mov    -0x10(%ebp),%ecx
80105212:	8b 55 ec             	mov    -0x14(%ebp),%edx
80105215:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105218:	83 ec 04             	sub    $0x4,%esp
8010521b:	51                   	push   %ecx
8010521c:	52                   	push   %edx
8010521d:	50                   	push   %eax
8010521e:	e8 b7 bf ff ff       	call   801011da <fileread>
80105223:	83 c4 10             	add    $0x10,%esp
}
80105226:	c9                   	leave  
80105227:	c3                   	ret    

80105228 <sys_write>:

int
sys_write(void)
{
80105228:	55                   	push   %ebp
80105229:	89 e5                	mov    %esp,%ebp
8010522b:	83 ec 18             	sub    $0x18,%esp
  struct file *f;
  int n;
  char *p;

  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
8010522e:	83 ec 04             	sub    $0x4,%esp
80105231:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105234:	50                   	push   %eax
80105235:	6a 00                	push   $0x0
80105237:	6a 00                	push   $0x0
80105239:	e8 66 fe ff ff       	call   801050a4 <argfd>
8010523e:	83 c4 10             	add    $0x10,%esp
80105241:	85 c0                	test   %eax,%eax
80105243:	78 2e                	js     80105273 <sys_write+0x4b>
80105245:	83 ec 08             	sub    $0x8,%esp
80105248:	8d 45 f0             	lea    -0x10(%ebp),%eax
8010524b:	50                   	push   %eax
8010524c:	6a 02                	push   $0x2
8010524e:	e8 07 fd ff ff       	call   80104f5a <argint>
80105253:	83 c4 10             	add    $0x10,%esp
80105256:	85 c0                	test   %eax,%eax
80105258:	78 19                	js     80105273 <sys_write+0x4b>
8010525a:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010525d:	83 ec 04             	sub    $0x4,%esp
80105260:	50                   	push   %eax
80105261:	8d 45 ec             	lea    -0x14(%ebp),%eax
80105264:	50                   	push   %eax
80105265:	6a 01                	push   $0x1
80105267:	e8 1b fd ff ff       	call   80104f87 <argptr>
8010526c:	83 c4 10             	add    $0x10,%esp
8010526f:	85 c0                	test   %eax,%eax
80105271:	79 07                	jns    8010527a <sys_write+0x52>
    return -1;
80105273:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105278:	eb 17                	jmp    80105291 <sys_write+0x69>
  return filewrite(f, p, n);
8010527a:	8b 4d f0             	mov    -0x10(%ebp),%ecx
8010527d:	8b 55 ec             	mov    -0x14(%ebp),%edx
80105280:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105283:	83 ec 04             	sub    $0x4,%esp
80105286:	51                   	push   %ecx
80105287:	52                   	push   %edx
80105288:	50                   	push   %eax
80105289:	e8 04 c0 ff ff       	call   80101292 <filewrite>
8010528e:	83 c4 10             	add    $0x10,%esp
}
80105291:	c9                   	leave  
80105292:	c3                   	ret    

80105293 <sys_close>:

int
sys_close(void)
{
80105293:	55                   	push   %ebp
80105294:	89 e5                	mov    %esp,%ebp
80105296:	83 ec 18             	sub    $0x18,%esp
  int fd;
  struct file *f;

  if(argfd(0, &fd, &f) < 0)
80105299:	83 ec 04             	sub    $0x4,%esp
8010529c:	8d 45 f0             	lea    -0x10(%ebp),%eax
8010529f:	50                   	push   %eax
801052a0:	8d 45 f4             	lea    -0xc(%ebp),%eax
801052a3:	50                   	push   %eax
801052a4:	6a 00                	push   $0x0
801052a6:	e8 f9 fd ff ff       	call   801050a4 <argfd>
801052ab:	83 c4 10             	add    $0x10,%esp
801052ae:	85 c0                	test   %eax,%eax
801052b0:	79 07                	jns    801052b9 <sys_close+0x26>
    return -1;
801052b2:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801052b7:	eb 27                	jmp    801052e0 <sys_close+0x4d>
  myproc()->ofile[fd] = 0;
801052b9:	e8 72 e7 ff ff       	call   80103a30 <myproc>
801052be:	8b 55 f4             	mov    -0xc(%ebp),%edx
801052c1:	83 c2 08             	add    $0x8,%edx
801052c4:	c7 44 90 08 00 00 00 	movl   $0x0,0x8(%eax,%edx,4)
801052cb:	00 
  fileclose(f);
801052cc:	8b 45 f0             	mov    -0x10(%ebp),%eax
801052cf:	83 ec 0c             	sub    $0xc,%esp
801052d2:	50                   	push   %eax
801052d3:	e8 c3 bd ff ff       	call   8010109b <fileclose>
801052d8:	83 c4 10             	add    $0x10,%esp
  return 0;
801052db:	b8 00 00 00 00       	mov    $0x0,%eax
}
801052e0:	c9                   	leave  
801052e1:	c3                   	ret    

801052e2 <sys_fstat>:

int
sys_fstat(void)
{
801052e2:	55                   	push   %ebp
801052e3:	89 e5                	mov    %esp,%ebp
801052e5:	83 ec 18             	sub    $0x18,%esp
  struct file *f;
  struct stat *st;

  if(argfd(0, 0, &f) < 0 || argptr(1, (void*)&st, sizeof(*st)) < 0)
801052e8:	83 ec 04             	sub    $0x4,%esp
801052eb:	8d 45 f4             	lea    -0xc(%ebp),%eax
801052ee:	50                   	push   %eax
801052ef:	6a 00                	push   $0x0
801052f1:	6a 00                	push   $0x0
801052f3:	e8 ac fd ff ff       	call   801050a4 <argfd>
801052f8:	83 c4 10             	add    $0x10,%esp
801052fb:	85 c0                	test   %eax,%eax
801052fd:	78 17                	js     80105316 <sys_fstat+0x34>
801052ff:	83 ec 04             	sub    $0x4,%esp
80105302:	6a 14                	push   $0x14
80105304:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105307:	50                   	push   %eax
80105308:	6a 01                	push   $0x1
8010530a:	e8 78 fc ff ff       	call   80104f87 <argptr>
8010530f:	83 c4 10             	add    $0x10,%esp
80105312:	85 c0                	test   %eax,%eax
80105314:	79 07                	jns    8010531d <sys_fstat+0x3b>
    return -1;
80105316:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010531b:	eb 13                	jmp    80105330 <sys_fstat+0x4e>
  return filestat(f, st);
8010531d:	8b 55 f0             	mov    -0x10(%ebp),%edx
80105320:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105323:	83 ec 08             	sub    $0x8,%esp
80105326:	52                   	push   %edx
80105327:	50                   	push   %eax
80105328:	e8 56 be ff ff       	call   80101183 <filestat>
8010532d:	83 c4 10             	add    $0x10,%esp
}
80105330:	c9                   	leave  
80105331:	c3                   	ret    

80105332 <sys_link>:

// Create the path new as a link to the same inode as old.
int
sys_link(void)
{
80105332:	55                   	push   %ebp
80105333:	89 e5                	mov    %esp,%ebp
80105335:	83 ec 28             	sub    $0x28,%esp
  char name[DIRSIZ], *new, *old;
  struct inode *dp, *ip;

  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
80105338:	83 ec 08             	sub    $0x8,%esp
8010533b:	8d 45 d8             	lea    -0x28(%ebp),%eax
8010533e:	50                   	push   %eax
8010533f:	6a 00                	push   $0x0
80105341:	e8 a9 fc ff ff       	call   80104fef <argstr>
80105346:	83 c4 10             	add    $0x10,%esp
80105349:	85 c0                	test   %eax,%eax
8010534b:	78 15                	js     80105362 <sys_link+0x30>
8010534d:	83 ec 08             	sub    $0x8,%esp
80105350:	8d 45 dc             	lea    -0x24(%ebp),%eax
80105353:	50                   	push   %eax
80105354:	6a 01                	push   $0x1
80105356:	e8 94 fc ff ff       	call   80104fef <argstr>
8010535b:	83 c4 10             	add    $0x10,%esp
8010535e:	85 c0                	test   %eax,%eax
80105360:	79 0a                	jns    8010536c <sys_link+0x3a>
    return -1;
80105362:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105367:	e9 68 01 00 00       	jmp    801054d4 <sys_link+0x1a2>

  begin_op();
8010536c:	e8 cb dc ff ff       	call   8010303c <begin_op>
  if((ip = namei(old)) == 0){
80105371:	8b 45 d8             	mov    -0x28(%ebp),%eax
80105374:	83 ec 0c             	sub    $0xc,%esp
80105377:	50                   	push   %eax
80105378:	e8 a0 d1 ff ff       	call   8010251d <namei>
8010537d:	83 c4 10             	add    $0x10,%esp
80105380:	89 45 f4             	mov    %eax,-0xc(%ebp)
80105383:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80105387:	75 0f                	jne    80105398 <sys_link+0x66>
    end_op();
80105389:	e8 3a dd ff ff       	call   801030c8 <end_op>
    return -1;
8010538e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105393:	e9 3c 01 00 00       	jmp    801054d4 <sys_link+0x1a2>
  }

  ilock(ip);
80105398:	83 ec 0c             	sub    $0xc,%esp
8010539b:	ff 75 f4             	push   -0xc(%ebp)
8010539e:	e8 47 c6 ff ff       	call   801019ea <ilock>
801053a3:	83 c4 10             	add    $0x10,%esp
  if(ip->type == T_DIR){
801053a6:	8b 45 f4             	mov    -0xc(%ebp),%eax
801053a9:	0f b7 40 50          	movzwl 0x50(%eax),%eax
801053ad:	66 83 f8 01          	cmp    $0x1,%ax
801053b1:	75 1d                	jne    801053d0 <sys_link+0x9e>
    iunlockput(ip);
801053b3:	83 ec 0c             	sub    $0xc,%esp
801053b6:	ff 75 f4             	push   -0xc(%ebp)
801053b9:	e8 5d c8 ff ff       	call   80101c1b <iunlockput>
801053be:	83 c4 10             	add    $0x10,%esp
    end_op();
801053c1:	e8 02 dd ff ff       	call   801030c8 <end_op>
    return -1;
801053c6:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801053cb:	e9 04 01 00 00       	jmp    801054d4 <sys_link+0x1a2>
  }

  ip->nlink++;
801053d0:	8b 45 f4             	mov    -0xc(%ebp),%eax
801053d3:	0f b7 40 56          	movzwl 0x56(%eax),%eax
801053d7:	83 c0 01             	add    $0x1,%eax
801053da:	89 c2                	mov    %eax,%edx
801053dc:	8b 45 f4             	mov    -0xc(%ebp),%eax
801053df:	66 89 50 56          	mov    %dx,0x56(%eax)
  iupdate(ip);
801053e3:	83 ec 0c             	sub    $0xc,%esp
801053e6:	ff 75 f4             	push   -0xc(%ebp)
801053e9:	e8 1f c4 ff ff       	call   8010180d <iupdate>
801053ee:	83 c4 10             	add    $0x10,%esp
  iunlock(ip);
801053f1:	83 ec 0c             	sub    $0xc,%esp
801053f4:	ff 75 f4             	push   -0xc(%ebp)
801053f7:	e8 01 c7 ff ff       	call   80101afd <iunlock>
801053fc:	83 c4 10             	add    $0x10,%esp

  if((dp = nameiparent(new, name)) == 0)
801053ff:	8b 45 dc             	mov    -0x24(%ebp),%eax
80105402:	83 ec 08             	sub    $0x8,%esp
80105405:	8d 55 e2             	lea    -0x1e(%ebp),%edx
80105408:	52                   	push   %edx
80105409:	50                   	push   %eax
8010540a:	e8 2a d1 ff ff       	call   80102539 <nameiparent>
8010540f:	83 c4 10             	add    $0x10,%esp
80105412:	89 45 f0             	mov    %eax,-0x10(%ebp)
80105415:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80105419:	74 71                	je     8010548c <sys_link+0x15a>
    goto bad;
  ilock(dp);
8010541b:	83 ec 0c             	sub    $0xc,%esp
8010541e:	ff 75 f0             	push   -0x10(%ebp)
80105421:	e8 c4 c5 ff ff       	call   801019ea <ilock>
80105426:	83 c4 10             	add    $0x10,%esp
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
80105429:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010542c:	8b 10                	mov    (%eax),%edx
8010542e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105431:	8b 00                	mov    (%eax),%eax
80105433:	39 c2                	cmp    %eax,%edx
80105435:	75 1d                	jne    80105454 <sys_link+0x122>
80105437:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010543a:	8b 40 04             	mov    0x4(%eax),%eax
8010543d:	83 ec 04             	sub    $0x4,%esp
80105440:	50                   	push   %eax
80105441:	8d 45 e2             	lea    -0x1e(%ebp),%eax
80105444:	50                   	push   %eax
80105445:	ff 75 f0             	push   -0x10(%ebp)
80105448:	e8 39 ce ff ff       	call   80102286 <dirlink>
8010544d:	83 c4 10             	add    $0x10,%esp
80105450:	85 c0                	test   %eax,%eax
80105452:	79 10                	jns    80105464 <sys_link+0x132>
    iunlockput(dp);
80105454:	83 ec 0c             	sub    $0xc,%esp
80105457:	ff 75 f0             	push   -0x10(%ebp)
8010545a:	e8 bc c7 ff ff       	call   80101c1b <iunlockput>
8010545f:	83 c4 10             	add    $0x10,%esp
    goto bad;
80105462:	eb 29                	jmp    8010548d <sys_link+0x15b>
  }
  iunlockput(dp);
80105464:	83 ec 0c             	sub    $0xc,%esp
80105467:	ff 75 f0             	push   -0x10(%ebp)
8010546a:	e8 ac c7 ff ff       	call   80101c1b <iunlockput>
8010546f:	83 c4 10             	add    $0x10,%esp
  iput(ip);
80105472:	83 ec 0c             	sub    $0xc,%esp
80105475:	ff 75 f4             	push   -0xc(%ebp)
80105478:	e8 ce c6 ff ff       	call   80101b4b <iput>
8010547d:	83 c4 10             	add    $0x10,%esp

  end_op();
80105480:	e8 43 dc ff ff       	call   801030c8 <end_op>

  return 0;
80105485:	b8 00 00 00 00       	mov    $0x0,%eax
8010548a:	eb 48                	jmp    801054d4 <sys_link+0x1a2>
    goto bad;
8010548c:	90                   	nop

bad:
  ilock(ip);
8010548d:	83 ec 0c             	sub    $0xc,%esp
80105490:	ff 75 f4             	push   -0xc(%ebp)
80105493:	e8 52 c5 ff ff       	call   801019ea <ilock>
80105498:	83 c4 10             	add    $0x10,%esp
  ip->nlink--;
8010549b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010549e:	0f b7 40 56          	movzwl 0x56(%eax),%eax
801054a2:	83 e8 01             	sub    $0x1,%eax
801054a5:	89 c2                	mov    %eax,%edx
801054a7:	8b 45 f4             	mov    -0xc(%ebp),%eax
801054aa:	66 89 50 56          	mov    %dx,0x56(%eax)
  iupdate(ip);
801054ae:	83 ec 0c             	sub    $0xc,%esp
801054b1:	ff 75 f4             	push   -0xc(%ebp)
801054b4:	e8 54 c3 ff ff       	call   8010180d <iupdate>
801054b9:	83 c4 10             	add    $0x10,%esp
  iunlockput(ip);
801054bc:	83 ec 0c             	sub    $0xc,%esp
801054bf:	ff 75 f4             	push   -0xc(%ebp)
801054c2:	e8 54 c7 ff ff       	call   80101c1b <iunlockput>
801054c7:	83 c4 10             	add    $0x10,%esp
  end_op();
801054ca:	e8 f9 db ff ff       	call   801030c8 <end_op>
  return -1;
801054cf:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801054d4:	c9                   	leave  
801054d5:	c3                   	ret    

801054d6 <isdirempty>:

// Is the directory dp empty except for "." and ".." ?
static int
isdirempty(struct inode *dp)
{
801054d6:	55                   	push   %ebp
801054d7:	89 e5                	mov    %esp,%ebp
801054d9:	83 ec 28             	sub    $0x28,%esp
  int off;
  struct dirent de;

  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
801054dc:	c7 45 f4 20 00 00 00 	movl   $0x20,-0xc(%ebp)
801054e3:	eb 40                	jmp    80105525 <isdirempty+0x4f>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
801054e5:	8b 45 f4             	mov    -0xc(%ebp),%eax
801054e8:	6a 10                	push   $0x10
801054ea:	50                   	push   %eax
801054eb:	8d 45 e4             	lea    -0x1c(%ebp),%eax
801054ee:	50                   	push   %eax
801054ef:	ff 75 08             	push   0x8(%ebp)
801054f2:	e8 df c9 ff ff       	call   80101ed6 <readi>
801054f7:	83 c4 10             	add    $0x10,%esp
801054fa:	83 f8 10             	cmp    $0x10,%eax
801054fd:	74 0d                	je     8010550c <isdirempty+0x36>
      panic("isdirempty: readi");
801054ff:	83 ec 0c             	sub    $0xc,%esp
80105502:	68 b4 a6 10 80       	push   $0x8010a6b4
80105507:	e8 9d b0 ff ff       	call   801005a9 <panic>
    if(de.inum != 0)
8010550c:	0f b7 45 e4          	movzwl -0x1c(%ebp),%eax
80105510:	66 85 c0             	test   %ax,%ax
80105513:	74 07                	je     8010551c <isdirempty+0x46>
      return 0;
80105515:	b8 00 00 00 00       	mov    $0x0,%eax
8010551a:	eb 1b                	jmp    80105537 <isdirempty+0x61>
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
8010551c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010551f:	83 c0 10             	add    $0x10,%eax
80105522:	89 45 f4             	mov    %eax,-0xc(%ebp)
80105525:	8b 45 08             	mov    0x8(%ebp),%eax
80105528:	8b 50 58             	mov    0x58(%eax),%edx
8010552b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010552e:	39 c2                	cmp    %eax,%edx
80105530:	77 b3                	ja     801054e5 <isdirempty+0xf>
  }
  return 1;
80105532:	b8 01 00 00 00       	mov    $0x1,%eax
}
80105537:	c9                   	leave  
80105538:	c3                   	ret    

80105539 <sys_unlink>:

//PAGEBREAK!
int
sys_unlink(void)
{
80105539:	55                   	push   %ebp
8010553a:	89 e5                	mov    %esp,%ebp
8010553c:	83 ec 38             	sub    $0x38,%esp
  struct inode *ip, *dp;
  struct dirent de;
  char name[DIRSIZ], *path;
  uint off;

  if(argstr(0, &path) < 0)
8010553f:	83 ec 08             	sub    $0x8,%esp
80105542:	8d 45 cc             	lea    -0x34(%ebp),%eax
80105545:	50                   	push   %eax
80105546:	6a 00                	push   $0x0
80105548:	e8 a2 fa ff ff       	call   80104fef <argstr>
8010554d:	83 c4 10             	add    $0x10,%esp
80105550:	85 c0                	test   %eax,%eax
80105552:	79 0a                	jns    8010555e <sys_unlink+0x25>
    return -1;
80105554:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105559:	e9 bf 01 00 00       	jmp    8010571d <sys_unlink+0x1e4>

  begin_op();
8010555e:	e8 d9 da ff ff       	call   8010303c <begin_op>
  if((dp = nameiparent(path, name)) == 0){
80105563:	8b 45 cc             	mov    -0x34(%ebp),%eax
80105566:	83 ec 08             	sub    $0x8,%esp
80105569:	8d 55 d2             	lea    -0x2e(%ebp),%edx
8010556c:	52                   	push   %edx
8010556d:	50                   	push   %eax
8010556e:	e8 c6 cf ff ff       	call   80102539 <nameiparent>
80105573:	83 c4 10             	add    $0x10,%esp
80105576:	89 45 f4             	mov    %eax,-0xc(%ebp)
80105579:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
8010557d:	75 0f                	jne    8010558e <sys_unlink+0x55>
    end_op();
8010557f:	e8 44 db ff ff       	call   801030c8 <end_op>
    return -1;
80105584:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105589:	e9 8f 01 00 00       	jmp    8010571d <sys_unlink+0x1e4>
  }

  ilock(dp);
8010558e:	83 ec 0c             	sub    $0xc,%esp
80105591:	ff 75 f4             	push   -0xc(%ebp)
80105594:	e8 51 c4 ff ff       	call   801019ea <ilock>
80105599:	83 c4 10             	add    $0x10,%esp

  // Cannot unlink "." or "..".
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
8010559c:	83 ec 08             	sub    $0x8,%esp
8010559f:	68 c6 a6 10 80       	push   $0x8010a6c6
801055a4:	8d 45 d2             	lea    -0x2e(%ebp),%eax
801055a7:	50                   	push   %eax
801055a8:	e8 04 cc ff ff       	call   801021b1 <namecmp>
801055ad:	83 c4 10             	add    $0x10,%esp
801055b0:	85 c0                	test   %eax,%eax
801055b2:	0f 84 49 01 00 00    	je     80105701 <sys_unlink+0x1c8>
801055b8:	83 ec 08             	sub    $0x8,%esp
801055bb:	68 c8 a6 10 80       	push   $0x8010a6c8
801055c0:	8d 45 d2             	lea    -0x2e(%ebp),%eax
801055c3:	50                   	push   %eax
801055c4:	e8 e8 cb ff ff       	call   801021b1 <namecmp>
801055c9:	83 c4 10             	add    $0x10,%esp
801055cc:	85 c0                	test   %eax,%eax
801055ce:	0f 84 2d 01 00 00    	je     80105701 <sys_unlink+0x1c8>
    goto bad;

  if((ip = dirlookup(dp, name, &off)) == 0)
801055d4:	83 ec 04             	sub    $0x4,%esp
801055d7:	8d 45 c8             	lea    -0x38(%ebp),%eax
801055da:	50                   	push   %eax
801055db:	8d 45 d2             	lea    -0x2e(%ebp),%eax
801055de:	50                   	push   %eax
801055df:	ff 75 f4             	push   -0xc(%ebp)
801055e2:	e8 e5 cb ff ff       	call   801021cc <dirlookup>
801055e7:	83 c4 10             	add    $0x10,%esp
801055ea:	89 45 f0             	mov    %eax,-0x10(%ebp)
801055ed:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
801055f1:	0f 84 0d 01 00 00    	je     80105704 <sys_unlink+0x1cb>
    goto bad;
  ilock(ip);
801055f7:	83 ec 0c             	sub    $0xc,%esp
801055fa:	ff 75 f0             	push   -0x10(%ebp)
801055fd:	e8 e8 c3 ff ff       	call   801019ea <ilock>
80105602:	83 c4 10             	add    $0x10,%esp

  if(ip->nlink < 1)
80105605:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105608:	0f b7 40 56          	movzwl 0x56(%eax),%eax
8010560c:	66 85 c0             	test   %ax,%ax
8010560f:	7f 0d                	jg     8010561e <sys_unlink+0xe5>
    panic("unlink: nlink < 1");
80105611:	83 ec 0c             	sub    $0xc,%esp
80105614:	68 cb a6 10 80       	push   $0x8010a6cb
80105619:	e8 8b af ff ff       	call   801005a9 <panic>
  if(ip->type == T_DIR && !isdirempty(ip)){
8010561e:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105621:	0f b7 40 50          	movzwl 0x50(%eax),%eax
80105625:	66 83 f8 01          	cmp    $0x1,%ax
80105629:	75 25                	jne    80105650 <sys_unlink+0x117>
8010562b:	83 ec 0c             	sub    $0xc,%esp
8010562e:	ff 75 f0             	push   -0x10(%ebp)
80105631:	e8 a0 fe ff ff       	call   801054d6 <isdirempty>
80105636:	83 c4 10             	add    $0x10,%esp
80105639:	85 c0                	test   %eax,%eax
8010563b:	75 13                	jne    80105650 <sys_unlink+0x117>
    iunlockput(ip);
8010563d:	83 ec 0c             	sub    $0xc,%esp
80105640:	ff 75 f0             	push   -0x10(%ebp)
80105643:	e8 d3 c5 ff ff       	call   80101c1b <iunlockput>
80105648:	83 c4 10             	add    $0x10,%esp
    goto bad;
8010564b:	e9 b5 00 00 00       	jmp    80105705 <sys_unlink+0x1cc>
  }

  memset(&de, 0, sizeof(de));
80105650:	83 ec 04             	sub    $0x4,%esp
80105653:	6a 10                	push   $0x10
80105655:	6a 00                	push   $0x0
80105657:	8d 45 e0             	lea    -0x20(%ebp),%eax
8010565a:	50                   	push   %eax
8010565b:	e8 cf f5 ff ff       	call   80104c2f <memset>
80105660:	83 c4 10             	add    $0x10,%esp
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80105663:	8b 45 c8             	mov    -0x38(%ebp),%eax
80105666:	6a 10                	push   $0x10
80105668:	50                   	push   %eax
80105669:	8d 45 e0             	lea    -0x20(%ebp),%eax
8010566c:	50                   	push   %eax
8010566d:	ff 75 f4             	push   -0xc(%ebp)
80105670:	e8 b6 c9 ff ff       	call   8010202b <writei>
80105675:	83 c4 10             	add    $0x10,%esp
80105678:	83 f8 10             	cmp    $0x10,%eax
8010567b:	74 0d                	je     8010568a <sys_unlink+0x151>
    panic("unlink: writei");
8010567d:	83 ec 0c             	sub    $0xc,%esp
80105680:	68 dd a6 10 80       	push   $0x8010a6dd
80105685:	e8 1f af ff ff       	call   801005a9 <panic>
  if(ip->type == T_DIR){
8010568a:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010568d:	0f b7 40 50          	movzwl 0x50(%eax),%eax
80105691:	66 83 f8 01          	cmp    $0x1,%ax
80105695:	75 21                	jne    801056b8 <sys_unlink+0x17f>
    dp->nlink--;
80105697:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010569a:	0f b7 40 56          	movzwl 0x56(%eax),%eax
8010569e:	83 e8 01             	sub    $0x1,%eax
801056a1:	89 c2                	mov    %eax,%edx
801056a3:	8b 45 f4             	mov    -0xc(%ebp),%eax
801056a6:	66 89 50 56          	mov    %dx,0x56(%eax)
    iupdate(dp);
801056aa:	83 ec 0c             	sub    $0xc,%esp
801056ad:	ff 75 f4             	push   -0xc(%ebp)
801056b0:	e8 58 c1 ff ff       	call   8010180d <iupdate>
801056b5:	83 c4 10             	add    $0x10,%esp
  }
  iunlockput(dp);
801056b8:	83 ec 0c             	sub    $0xc,%esp
801056bb:	ff 75 f4             	push   -0xc(%ebp)
801056be:	e8 58 c5 ff ff       	call   80101c1b <iunlockput>
801056c3:	83 c4 10             	add    $0x10,%esp

  ip->nlink--;
801056c6:	8b 45 f0             	mov    -0x10(%ebp),%eax
801056c9:	0f b7 40 56          	movzwl 0x56(%eax),%eax
801056cd:	83 e8 01             	sub    $0x1,%eax
801056d0:	89 c2                	mov    %eax,%edx
801056d2:	8b 45 f0             	mov    -0x10(%ebp),%eax
801056d5:	66 89 50 56          	mov    %dx,0x56(%eax)
  iupdate(ip);
801056d9:	83 ec 0c             	sub    $0xc,%esp
801056dc:	ff 75 f0             	push   -0x10(%ebp)
801056df:	e8 29 c1 ff ff       	call   8010180d <iupdate>
801056e4:	83 c4 10             	add    $0x10,%esp
  iunlockput(ip);
801056e7:	83 ec 0c             	sub    $0xc,%esp
801056ea:	ff 75 f0             	push   -0x10(%ebp)
801056ed:	e8 29 c5 ff ff       	call   80101c1b <iunlockput>
801056f2:	83 c4 10             	add    $0x10,%esp

  end_op();
801056f5:	e8 ce d9 ff ff       	call   801030c8 <end_op>

  return 0;
801056fa:	b8 00 00 00 00       	mov    $0x0,%eax
801056ff:	eb 1c                	jmp    8010571d <sys_unlink+0x1e4>
    goto bad;
80105701:	90                   	nop
80105702:	eb 01                	jmp    80105705 <sys_unlink+0x1cc>
    goto bad;
80105704:	90                   	nop

bad:
  iunlockput(dp);
80105705:	83 ec 0c             	sub    $0xc,%esp
80105708:	ff 75 f4             	push   -0xc(%ebp)
8010570b:	e8 0b c5 ff ff       	call   80101c1b <iunlockput>
80105710:	83 c4 10             	add    $0x10,%esp
  end_op();
80105713:	e8 b0 d9 ff ff       	call   801030c8 <end_op>
  return -1;
80105718:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
8010571d:	c9                   	leave  
8010571e:	c3                   	ret    

8010571f <create>:

static struct inode*
create(char *path, short type, short major, short minor)
{
8010571f:	55                   	push   %ebp
80105720:	89 e5                	mov    %esp,%ebp
80105722:	83 ec 38             	sub    $0x38,%esp
80105725:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80105728:	8b 55 10             	mov    0x10(%ebp),%edx
8010572b:	8b 45 14             	mov    0x14(%ebp),%eax
8010572e:	66 89 4d d4          	mov    %cx,-0x2c(%ebp)
80105732:	66 89 55 d0          	mov    %dx,-0x30(%ebp)
80105736:	66 89 45 cc          	mov    %ax,-0x34(%ebp)
  uint off;
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
8010573a:	83 ec 08             	sub    $0x8,%esp
8010573d:	8d 45 de             	lea    -0x22(%ebp),%eax
80105740:	50                   	push   %eax
80105741:	ff 75 08             	push   0x8(%ebp)
80105744:	e8 f0 cd ff ff       	call   80102539 <nameiparent>
80105749:	83 c4 10             	add    $0x10,%esp
8010574c:	89 45 f4             	mov    %eax,-0xc(%ebp)
8010574f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80105753:	75 0a                	jne    8010575f <create+0x40>
    return 0;
80105755:	b8 00 00 00 00       	mov    $0x0,%eax
8010575a:	e9 90 01 00 00       	jmp    801058ef <create+0x1d0>
  ilock(dp);
8010575f:	83 ec 0c             	sub    $0xc,%esp
80105762:	ff 75 f4             	push   -0xc(%ebp)
80105765:	e8 80 c2 ff ff       	call   801019ea <ilock>
8010576a:	83 c4 10             	add    $0x10,%esp

  if((ip = dirlookup(dp, name, &off)) != 0){
8010576d:	83 ec 04             	sub    $0x4,%esp
80105770:	8d 45 ec             	lea    -0x14(%ebp),%eax
80105773:	50                   	push   %eax
80105774:	8d 45 de             	lea    -0x22(%ebp),%eax
80105777:	50                   	push   %eax
80105778:	ff 75 f4             	push   -0xc(%ebp)
8010577b:	e8 4c ca ff ff       	call   801021cc <dirlookup>
80105780:	83 c4 10             	add    $0x10,%esp
80105783:	89 45 f0             	mov    %eax,-0x10(%ebp)
80105786:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
8010578a:	74 50                	je     801057dc <create+0xbd>
    iunlockput(dp);
8010578c:	83 ec 0c             	sub    $0xc,%esp
8010578f:	ff 75 f4             	push   -0xc(%ebp)
80105792:	e8 84 c4 ff ff       	call   80101c1b <iunlockput>
80105797:	83 c4 10             	add    $0x10,%esp
    ilock(ip);
8010579a:	83 ec 0c             	sub    $0xc,%esp
8010579d:	ff 75 f0             	push   -0x10(%ebp)
801057a0:	e8 45 c2 ff ff       	call   801019ea <ilock>
801057a5:	83 c4 10             	add    $0x10,%esp
    if(type == T_FILE && ip->type == T_FILE)
801057a8:	66 83 7d d4 02       	cmpw   $0x2,-0x2c(%ebp)
801057ad:	75 15                	jne    801057c4 <create+0xa5>
801057af:	8b 45 f0             	mov    -0x10(%ebp),%eax
801057b2:	0f b7 40 50          	movzwl 0x50(%eax),%eax
801057b6:	66 83 f8 02          	cmp    $0x2,%ax
801057ba:	75 08                	jne    801057c4 <create+0xa5>
      return ip;
801057bc:	8b 45 f0             	mov    -0x10(%ebp),%eax
801057bf:	e9 2b 01 00 00       	jmp    801058ef <create+0x1d0>
    iunlockput(ip);
801057c4:	83 ec 0c             	sub    $0xc,%esp
801057c7:	ff 75 f0             	push   -0x10(%ebp)
801057ca:	e8 4c c4 ff ff       	call   80101c1b <iunlockput>
801057cf:	83 c4 10             	add    $0x10,%esp
    return 0;
801057d2:	b8 00 00 00 00       	mov    $0x0,%eax
801057d7:	e9 13 01 00 00       	jmp    801058ef <create+0x1d0>
  }

  if((ip = ialloc(dp->dev, type)) == 0)
801057dc:	0f bf 55 d4          	movswl -0x2c(%ebp),%edx
801057e0:	8b 45 f4             	mov    -0xc(%ebp),%eax
801057e3:	8b 00                	mov    (%eax),%eax
801057e5:	83 ec 08             	sub    $0x8,%esp
801057e8:	52                   	push   %edx
801057e9:	50                   	push   %eax
801057ea:	e8 47 bf ff ff       	call   80101736 <ialloc>
801057ef:	83 c4 10             	add    $0x10,%esp
801057f2:	89 45 f0             	mov    %eax,-0x10(%ebp)
801057f5:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
801057f9:	75 0d                	jne    80105808 <create+0xe9>
    panic("create: ialloc");
801057fb:	83 ec 0c             	sub    $0xc,%esp
801057fe:	68 ec a6 10 80       	push   $0x8010a6ec
80105803:	e8 a1 ad ff ff       	call   801005a9 <panic>

  ilock(ip);
80105808:	83 ec 0c             	sub    $0xc,%esp
8010580b:	ff 75 f0             	push   -0x10(%ebp)
8010580e:	e8 d7 c1 ff ff       	call   801019ea <ilock>
80105813:	83 c4 10             	add    $0x10,%esp
  ip->major = major;
80105816:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105819:	0f b7 55 d0          	movzwl -0x30(%ebp),%edx
8010581d:	66 89 50 52          	mov    %dx,0x52(%eax)
  ip->minor = minor;
80105821:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105824:	0f b7 55 cc          	movzwl -0x34(%ebp),%edx
80105828:	66 89 50 54          	mov    %dx,0x54(%eax)
  ip->nlink = 1;
8010582c:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010582f:	66 c7 40 56 01 00    	movw   $0x1,0x56(%eax)
  iupdate(ip);
80105835:	83 ec 0c             	sub    $0xc,%esp
80105838:	ff 75 f0             	push   -0x10(%ebp)
8010583b:	e8 cd bf ff ff       	call   8010180d <iupdate>
80105840:	83 c4 10             	add    $0x10,%esp

  if(type == T_DIR){  // Create . and .. entries.
80105843:	66 83 7d d4 01       	cmpw   $0x1,-0x2c(%ebp)
80105848:	75 6a                	jne    801058b4 <create+0x195>
    dp->nlink++;  // for ".."
8010584a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010584d:	0f b7 40 56          	movzwl 0x56(%eax),%eax
80105851:	83 c0 01             	add    $0x1,%eax
80105854:	89 c2                	mov    %eax,%edx
80105856:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105859:	66 89 50 56          	mov    %dx,0x56(%eax)
    iupdate(dp);
8010585d:	83 ec 0c             	sub    $0xc,%esp
80105860:	ff 75 f4             	push   -0xc(%ebp)
80105863:	e8 a5 bf ff ff       	call   8010180d <iupdate>
80105868:	83 c4 10             	add    $0x10,%esp
    // No ip->nlink++ for ".": avoid cyclic ref count.
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
8010586b:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010586e:	8b 40 04             	mov    0x4(%eax),%eax
80105871:	83 ec 04             	sub    $0x4,%esp
80105874:	50                   	push   %eax
80105875:	68 c6 a6 10 80       	push   $0x8010a6c6
8010587a:	ff 75 f0             	push   -0x10(%ebp)
8010587d:	e8 04 ca ff ff       	call   80102286 <dirlink>
80105882:	83 c4 10             	add    $0x10,%esp
80105885:	85 c0                	test   %eax,%eax
80105887:	78 1e                	js     801058a7 <create+0x188>
80105889:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010588c:	8b 40 04             	mov    0x4(%eax),%eax
8010588f:	83 ec 04             	sub    $0x4,%esp
80105892:	50                   	push   %eax
80105893:	68 c8 a6 10 80       	push   $0x8010a6c8
80105898:	ff 75 f0             	push   -0x10(%ebp)
8010589b:	e8 e6 c9 ff ff       	call   80102286 <dirlink>
801058a0:	83 c4 10             	add    $0x10,%esp
801058a3:	85 c0                	test   %eax,%eax
801058a5:	79 0d                	jns    801058b4 <create+0x195>
      panic("create dots");
801058a7:	83 ec 0c             	sub    $0xc,%esp
801058aa:	68 fb a6 10 80       	push   $0x8010a6fb
801058af:	e8 f5 ac ff ff       	call   801005a9 <panic>
  }

  if(dirlink(dp, name, ip->inum) < 0)
801058b4:	8b 45 f0             	mov    -0x10(%ebp),%eax
801058b7:	8b 40 04             	mov    0x4(%eax),%eax
801058ba:	83 ec 04             	sub    $0x4,%esp
801058bd:	50                   	push   %eax
801058be:	8d 45 de             	lea    -0x22(%ebp),%eax
801058c1:	50                   	push   %eax
801058c2:	ff 75 f4             	push   -0xc(%ebp)
801058c5:	e8 bc c9 ff ff       	call   80102286 <dirlink>
801058ca:	83 c4 10             	add    $0x10,%esp
801058cd:	85 c0                	test   %eax,%eax
801058cf:	79 0d                	jns    801058de <create+0x1bf>
    panic("create: dirlink");
801058d1:	83 ec 0c             	sub    $0xc,%esp
801058d4:	68 07 a7 10 80       	push   $0x8010a707
801058d9:	e8 cb ac ff ff       	call   801005a9 <panic>

  iunlockput(dp);
801058de:	83 ec 0c             	sub    $0xc,%esp
801058e1:	ff 75 f4             	push   -0xc(%ebp)
801058e4:	e8 32 c3 ff ff       	call   80101c1b <iunlockput>
801058e9:	83 c4 10             	add    $0x10,%esp

  return ip;
801058ec:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
801058ef:	c9                   	leave  
801058f0:	c3                   	ret    

801058f1 <sys_open>:

int
sys_open(void)
{
801058f1:	55                   	push   %ebp
801058f2:	89 e5                	mov    %esp,%ebp
801058f4:	83 ec 28             	sub    $0x28,%esp
  char *path;
  int fd, omode;
  struct file *f;
  struct inode *ip;

  if(argstr(0, &path) < 0 || argint(1, &omode) < 0)
801058f7:	83 ec 08             	sub    $0x8,%esp
801058fa:	8d 45 e8             	lea    -0x18(%ebp),%eax
801058fd:	50                   	push   %eax
801058fe:	6a 00                	push   $0x0
80105900:	e8 ea f6 ff ff       	call   80104fef <argstr>
80105905:	83 c4 10             	add    $0x10,%esp
80105908:	85 c0                	test   %eax,%eax
8010590a:	78 15                	js     80105921 <sys_open+0x30>
8010590c:	83 ec 08             	sub    $0x8,%esp
8010590f:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80105912:	50                   	push   %eax
80105913:	6a 01                	push   $0x1
80105915:	e8 40 f6 ff ff       	call   80104f5a <argint>
8010591a:	83 c4 10             	add    $0x10,%esp
8010591d:	85 c0                	test   %eax,%eax
8010591f:	79 0a                	jns    8010592b <sys_open+0x3a>
    return -1;
80105921:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105926:	e9 61 01 00 00       	jmp    80105a8c <sys_open+0x19b>

  begin_op();
8010592b:	e8 0c d7 ff ff       	call   8010303c <begin_op>

  if(omode & O_CREATE){
80105930:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80105933:	25 00 02 00 00       	and    $0x200,%eax
80105938:	85 c0                	test   %eax,%eax
8010593a:	74 2a                	je     80105966 <sys_open+0x75>
    ip = create(path, T_FILE, 0, 0);
8010593c:	8b 45 e8             	mov    -0x18(%ebp),%eax
8010593f:	6a 00                	push   $0x0
80105941:	6a 00                	push   $0x0
80105943:	6a 02                	push   $0x2
80105945:	50                   	push   %eax
80105946:	e8 d4 fd ff ff       	call   8010571f <create>
8010594b:	83 c4 10             	add    $0x10,%esp
8010594e:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(ip == 0){
80105951:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80105955:	75 75                	jne    801059cc <sys_open+0xdb>
      end_op();
80105957:	e8 6c d7 ff ff       	call   801030c8 <end_op>
      return -1;
8010595c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105961:	e9 26 01 00 00       	jmp    80105a8c <sys_open+0x19b>
    }
  } else {
    if((ip = namei(path)) == 0){
80105966:	8b 45 e8             	mov    -0x18(%ebp),%eax
80105969:	83 ec 0c             	sub    $0xc,%esp
8010596c:	50                   	push   %eax
8010596d:	e8 ab cb ff ff       	call   8010251d <namei>
80105972:	83 c4 10             	add    $0x10,%esp
80105975:	89 45 f4             	mov    %eax,-0xc(%ebp)
80105978:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
8010597c:	75 0f                	jne    8010598d <sys_open+0x9c>
      end_op();
8010597e:	e8 45 d7 ff ff       	call   801030c8 <end_op>
      return -1;
80105983:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105988:	e9 ff 00 00 00       	jmp    80105a8c <sys_open+0x19b>
    }
    ilock(ip);
8010598d:	83 ec 0c             	sub    $0xc,%esp
80105990:	ff 75 f4             	push   -0xc(%ebp)
80105993:	e8 52 c0 ff ff       	call   801019ea <ilock>
80105998:	83 c4 10             	add    $0x10,%esp
    if(ip->type == T_DIR && omode != O_RDONLY){
8010599b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010599e:	0f b7 40 50          	movzwl 0x50(%eax),%eax
801059a2:	66 83 f8 01          	cmp    $0x1,%ax
801059a6:	75 24                	jne    801059cc <sys_open+0xdb>
801059a8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801059ab:	85 c0                	test   %eax,%eax
801059ad:	74 1d                	je     801059cc <sys_open+0xdb>
      iunlockput(ip);
801059af:	83 ec 0c             	sub    $0xc,%esp
801059b2:	ff 75 f4             	push   -0xc(%ebp)
801059b5:	e8 61 c2 ff ff       	call   80101c1b <iunlockput>
801059ba:	83 c4 10             	add    $0x10,%esp
      end_op();
801059bd:	e8 06 d7 ff ff       	call   801030c8 <end_op>
      return -1;
801059c2:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801059c7:	e9 c0 00 00 00       	jmp    80105a8c <sys_open+0x19b>
    }
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
801059cc:	e8 0c b6 ff ff       	call   80100fdd <filealloc>
801059d1:	89 45 f0             	mov    %eax,-0x10(%ebp)
801059d4:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
801059d8:	74 17                	je     801059f1 <sys_open+0x100>
801059da:	83 ec 0c             	sub    $0xc,%esp
801059dd:	ff 75 f0             	push   -0x10(%ebp)
801059e0:	e8 33 f7 ff ff       	call   80105118 <fdalloc>
801059e5:	83 c4 10             	add    $0x10,%esp
801059e8:	89 45 ec             	mov    %eax,-0x14(%ebp)
801059eb:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
801059ef:	79 2e                	jns    80105a1f <sys_open+0x12e>
    if(f)
801059f1:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
801059f5:	74 0e                	je     80105a05 <sys_open+0x114>
      fileclose(f);
801059f7:	83 ec 0c             	sub    $0xc,%esp
801059fa:	ff 75 f0             	push   -0x10(%ebp)
801059fd:	e8 99 b6 ff ff       	call   8010109b <fileclose>
80105a02:	83 c4 10             	add    $0x10,%esp
    iunlockput(ip);
80105a05:	83 ec 0c             	sub    $0xc,%esp
80105a08:	ff 75 f4             	push   -0xc(%ebp)
80105a0b:	e8 0b c2 ff ff       	call   80101c1b <iunlockput>
80105a10:	83 c4 10             	add    $0x10,%esp
    end_op();
80105a13:	e8 b0 d6 ff ff       	call   801030c8 <end_op>
    return -1;
80105a18:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105a1d:	eb 6d                	jmp    80105a8c <sys_open+0x19b>
  }
  iunlock(ip);
80105a1f:	83 ec 0c             	sub    $0xc,%esp
80105a22:	ff 75 f4             	push   -0xc(%ebp)
80105a25:	e8 d3 c0 ff ff       	call   80101afd <iunlock>
80105a2a:	83 c4 10             	add    $0x10,%esp
  end_op();
80105a2d:	e8 96 d6 ff ff       	call   801030c8 <end_op>

  f->type = FD_INODE;
80105a32:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105a35:	c7 00 02 00 00 00    	movl   $0x2,(%eax)
  f->ip = ip;
80105a3b:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105a3e:	8b 55 f4             	mov    -0xc(%ebp),%edx
80105a41:	89 50 10             	mov    %edx,0x10(%eax)
  f->off = 0;
80105a44:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105a47:	c7 40 14 00 00 00 00 	movl   $0x0,0x14(%eax)
  f->readable = !(omode & O_WRONLY);
80105a4e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80105a51:	83 e0 01             	and    $0x1,%eax
80105a54:	85 c0                	test   %eax,%eax
80105a56:	0f 94 c0             	sete   %al
80105a59:	89 c2                	mov    %eax,%edx
80105a5b:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105a5e:	88 50 08             	mov    %dl,0x8(%eax)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
80105a61:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80105a64:	83 e0 01             	and    $0x1,%eax
80105a67:	85 c0                	test   %eax,%eax
80105a69:	75 0a                	jne    80105a75 <sys_open+0x184>
80105a6b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80105a6e:	83 e0 02             	and    $0x2,%eax
80105a71:	85 c0                	test   %eax,%eax
80105a73:	74 07                	je     80105a7c <sys_open+0x18b>
80105a75:	b8 01 00 00 00       	mov    $0x1,%eax
80105a7a:	eb 05                	jmp    80105a81 <sys_open+0x190>
80105a7c:	b8 00 00 00 00       	mov    $0x0,%eax
80105a81:	89 c2                	mov    %eax,%edx
80105a83:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105a86:	88 50 09             	mov    %dl,0x9(%eax)
  return fd;
80105a89:	8b 45 ec             	mov    -0x14(%ebp),%eax
}
80105a8c:	c9                   	leave  
80105a8d:	c3                   	ret    

80105a8e <sys_mkdir>:

int
sys_mkdir(void)
{
80105a8e:	55                   	push   %ebp
80105a8f:	89 e5                	mov    %esp,%ebp
80105a91:	83 ec 18             	sub    $0x18,%esp
  char *path;
  struct inode *ip;

  begin_op();
80105a94:	e8 a3 d5 ff ff       	call   8010303c <begin_op>
  if(argstr(0, &path) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
80105a99:	83 ec 08             	sub    $0x8,%esp
80105a9c:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105a9f:	50                   	push   %eax
80105aa0:	6a 00                	push   $0x0
80105aa2:	e8 48 f5 ff ff       	call   80104fef <argstr>
80105aa7:	83 c4 10             	add    $0x10,%esp
80105aaa:	85 c0                	test   %eax,%eax
80105aac:	78 1b                	js     80105ac9 <sys_mkdir+0x3b>
80105aae:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105ab1:	6a 00                	push   $0x0
80105ab3:	6a 00                	push   $0x0
80105ab5:	6a 01                	push   $0x1
80105ab7:	50                   	push   %eax
80105ab8:	e8 62 fc ff ff       	call   8010571f <create>
80105abd:	83 c4 10             	add    $0x10,%esp
80105ac0:	89 45 f4             	mov    %eax,-0xc(%ebp)
80105ac3:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80105ac7:	75 0c                	jne    80105ad5 <sys_mkdir+0x47>
    end_op();
80105ac9:	e8 fa d5 ff ff       	call   801030c8 <end_op>
    return -1;
80105ace:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105ad3:	eb 18                	jmp    80105aed <sys_mkdir+0x5f>
  }
  iunlockput(ip);
80105ad5:	83 ec 0c             	sub    $0xc,%esp
80105ad8:	ff 75 f4             	push   -0xc(%ebp)
80105adb:	e8 3b c1 ff ff       	call   80101c1b <iunlockput>
80105ae0:	83 c4 10             	add    $0x10,%esp
  end_op();
80105ae3:	e8 e0 d5 ff ff       	call   801030c8 <end_op>
  return 0;
80105ae8:	b8 00 00 00 00       	mov    $0x0,%eax
}
80105aed:	c9                   	leave  
80105aee:	c3                   	ret    

80105aef <sys_mknod>:

int
sys_mknod(void)
{
80105aef:	55                   	push   %ebp
80105af0:	89 e5                	mov    %esp,%ebp
80105af2:	83 ec 18             	sub    $0x18,%esp
  struct inode *ip;
  char *path;
  int major, minor;

  begin_op();
80105af5:	e8 42 d5 ff ff       	call   8010303c <begin_op>
  if((argstr(0, &path)) < 0 ||
80105afa:	83 ec 08             	sub    $0x8,%esp
80105afd:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105b00:	50                   	push   %eax
80105b01:	6a 00                	push   $0x0
80105b03:	e8 e7 f4 ff ff       	call   80104fef <argstr>
80105b08:	83 c4 10             	add    $0x10,%esp
80105b0b:	85 c0                	test   %eax,%eax
80105b0d:	78 4f                	js     80105b5e <sys_mknod+0x6f>
     argint(1, &major) < 0 ||
80105b0f:	83 ec 08             	sub    $0x8,%esp
80105b12:	8d 45 ec             	lea    -0x14(%ebp),%eax
80105b15:	50                   	push   %eax
80105b16:	6a 01                	push   $0x1
80105b18:	e8 3d f4 ff ff       	call   80104f5a <argint>
80105b1d:	83 c4 10             	add    $0x10,%esp
  if((argstr(0, &path)) < 0 ||
80105b20:	85 c0                	test   %eax,%eax
80105b22:	78 3a                	js     80105b5e <sys_mknod+0x6f>
     argint(2, &minor) < 0 ||
80105b24:	83 ec 08             	sub    $0x8,%esp
80105b27:	8d 45 e8             	lea    -0x18(%ebp),%eax
80105b2a:	50                   	push   %eax
80105b2b:	6a 02                	push   $0x2
80105b2d:	e8 28 f4 ff ff       	call   80104f5a <argint>
80105b32:	83 c4 10             	add    $0x10,%esp
     argint(1, &major) < 0 ||
80105b35:	85 c0                	test   %eax,%eax
80105b37:	78 25                	js     80105b5e <sys_mknod+0x6f>
     (ip = create(path, T_DEV, major, minor)) == 0){
80105b39:	8b 45 e8             	mov    -0x18(%ebp),%eax
80105b3c:	0f bf c8             	movswl %ax,%ecx
80105b3f:	8b 45 ec             	mov    -0x14(%ebp),%eax
80105b42:	0f bf d0             	movswl %ax,%edx
80105b45:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105b48:	51                   	push   %ecx
80105b49:	52                   	push   %edx
80105b4a:	6a 03                	push   $0x3
80105b4c:	50                   	push   %eax
80105b4d:	e8 cd fb ff ff       	call   8010571f <create>
80105b52:	83 c4 10             	add    $0x10,%esp
80105b55:	89 45 f4             	mov    %eax,-0xc(%ebp)
     argint(2, &minor) < 0 ||
80105b58:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80105b5c:	75 0c                	jne    80105b6a <sys_mknod+0x7b>
    end_op();
80105b5e:	e8 65 d5 ff ff       	call   801030c8 <end_op>
    return -1;
80105b63:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105b68:	eb 18                	jmp    80105b82 <sys_mknod+0x93>
  }
  iunlockput(ip);
80105b6a:	83 ec 0c             	sub    $0xc,%esp
80105b6d:	ff 75 f4             	push   -0xc(%ebp)
80105b70:	e8 a6 c0 ff ff       	call   80101c1b <iunlockput>
80105b75:	83 c4 10             	add    $0x10,%esp
  end_op();
80105b78:	e8 4b d5 ff ff       	call   801030c8 <end_op>
  return 0;
80105b7d:	b8 00 00 00 00       	mov    $0x0,%eax
}
80105b82:	c9                   	leave  
80105b83:	c3                   	ret    

80105b84 <sys_chdir>:

int
sys_chdir(void)
{
80105b84:	55                   	push   %ebp
80105b85:	89 e5                	mov    %esp,%ebp
80105b87:	83 ec 18             	sub    $0x18,%esp
  char *path;
  struct inode *ip;
  struct proc *curproc = myproc();
80105b8a:	e8 a1 de ff ff       	call   80103a30 <myproc>
80105b8f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  
  begin_op();
80105b92:	e8 a5 d4 ff ff       	call   8010303c <begin_op>
  if(argstr(0, &path) < 0 || (ip = namei(path)) == 0){
80105b97:	83 ec 08             	sub    $0x8,%esp
80105b9a:	8d 45 ec             	lea    -0x14(%ebp),%eax
80105b9d:	50                   	push   %eax
80105b9e:	6a 00                	push   $0x0
80105ba0:	e8 4a f4 ff ff       	call   80104fef <argstr>
80105ba5:	83 c4 10             	add    $0x10,%esp
80105ba8:	85 c0                	test   %eax,%eax
80105baa:	78 18                	js     80105bc4 <sys_chdir+0x40>
80105bac:	8b 45 ec             	mov    -0x14(%ebp),%eax
80105baf:	83 ec 0c             	sub    $0xc,%esp
80105bb2:	50                   	push   %eax
80105bb3:	e8 65 c9 ff ff       	call   8010251d <namei>
80105bb8:	83 c4 10             	add    $0x10,%esp
80105bbb:	89 45 f0             	mov    %eax,-0x10(%ebp)
80105bbe:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80105bc2:	75 0c                	jne    80105bd0 <sys_chdir+0x4c>
    end_op();
80105bc4:	e8 ff d4 ff ff       	call   801030c8 <end_op>
    return -1;
80105bc9:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105bce:	eb 68                	jmp    80105c38 <sys_chdir+0xb4>
  }
  ilock(ip);
80105bd0:	83 ec 0c             	sub    $0xc,%esp
80105bd3:	ff 75 f0             	push   -0x10(%ebp)
80105bd6:	e8 0f be ff ff       	call   801019ea <ilock>
80105bdb:	83 c4 10             	add    $0x10,%esp
  if(ip->type != T_DIR){
80105bde:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105be1:	0f b7 40 50          	movzwl 0x50(%eax),%eax
80105be5:	66 83 f8 01          	cmp    $0x1,%ax
80105be9:	74 1a                	je     80105c05 <sys_chdir+0x81>
    iunlockput(ip);
80105beb:	83 ec 0c             	sub    $0xc,%esp
80105bee:	ff 75 f0             	push   -0x10(%ebp)
80105bf1:	e8 25 c0 ff ff       	call   80101c1b <iunlockput>
80105bf6:	83 c4 10             	add    $0x10,%esp
    end_op();
80105bf9:	e8 ca d4 ff ff       	call   801030c8 <end_op>
    return -1;
80105bfe:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105c03:	eb 33                	jmp    80105c38 <sys_chdir+0xb4>
  }
  iunlock(ip);
80105c05:	83 ec 0c             	sub    $0xc,%esp
80105c08:	ff 75 f0             	push   -0x10(%ebp)
80105c0b:	e8 ed be ff ff       	call   80101afd <iunlock>
80105c10:	83 c4 10             	add    $0x10,%esp
  iput(curproc->cwd);
80105c13:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105c16:	8b 40 68             	mov    0x68(%eax),%eax
80105c19:	83 ec 0c             	sub    $0xc,%esp
80105c1c:	50                   	push   %eax
80105c1d:	e8 29 bf ff ff       	call   80101b4b <iput>
80105c22:	83 c4 10             	add    $0x10,%esp
  end_op();
80105c25:	e8 9e d4 ff ff       	call   801030c8 <end_op>
  curproc->cwd = ip;
80105c2a:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105c2d:	8b 55 f0             	mov    -0x10(%ebp),%edx
80105c30:	89 50 68             	mov    %edx,0x68(%eax)
  return 0;
80105c33:	b8 00 00 00 00       	mov    $0x0,%eax
}
80105c38:	c9                   	leave  
80105c39:	c3                   	ret    

80105c3a <sys_exec>:

int
sys_exec(void)
{
80105c3a:	55                   	push   %ebp
80105c3b:	89 e5                	mov    %esp,%ebp
80105c3d:	81 ec 98 00 00 00    	sub    $0x98,%esp
  char *path, *argv[MAXARG];
  int i;
  uint uargv, uarg;

  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
80105c43:	83 ec 08             	sub    $0x8,%esp
80105c46:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105c49:	50                   	push   %eax
80105c4a:	6a 00                	push   $0x0
80105c4c:	e8 9e f3 ff ff       	call   80104fef <argstr>
80105c51:	83 c4 10             	add    $0x10,%esp
80105c54:	85 c0                	test   %eax,%eax
80105c56:	78 18                	js     80105c70 <sys_exec+0x36>
80105c58:	83 ec 08             	sub    $0x8,%esp
80105c5b:	8d 85 6c ff ff ff    	lea    -0x94(%ebp),%eax
80105c61:	50                   	push   %eax
80105c62:	6a 01                	push   $0x1
80105c64:	e8 f1 f2 ff ff       	call   80104f5a <argint>
80105c69:	83 c4 10             	add    $0x10,%esp
80105c6c:	85 c0                	test   %eax,%eax
80105c6e:	79 0a                	jns    80105c7a <sys_exec+0x40>
    return -1;
80105c70:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105c75:	e9 c6 00 00 00       	jmp    80105d40 <sys_exec+0x106>
  }
  memset(argv, 0, sizeof(argv));
80105c7a:	83 ec 04             	sub    $0x4,%esp
80105c7d:	68 80 00 00 00       	push   $0x80
80105c82:	6a 00                	push   $0x0
80105c84:	8d 85 70 ff ff ff    	lea    -0x90(%ebp),%eax
80105c8a:	50                   	push   %eax
80105c8b:	e8 9f ef ff ff       	call   80104c2f <memset>
80105c90:	83 c4 10             	add    $0x10,%esp
  for(i=0;; i++){
80105c93:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    if(i >= NELEM(argv))
80105c9a:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105c9d:	83 f8 1f             	cmp    $0x1f,%eax
80105ca0:	76 0a                	jbe    80105cac <sys_exec+0x72>
      return -1;
80105ca2:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105ca7:	e9 94 00 00 00       	jmp    80105d40 <sys_exec+0x106>
    if(fetchint(uargv+4*i, (int*)&uarg) < 0)
80105cac:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105caf:	c1 e0 02             	shl    $0x2,%eax
80105cb2:	89 c2                	mov    %eax,%edx
80105cb4:	8b 85 6c ff ff ff    	mov    -0x94(%ebp),%eax
80105cba:	01 c2                	add    %eax,%edx
80105cbc:	83 ec 08             	sub    $0x8,%esp
80105cbf:	8d 85 68 ff ff ff    	lea    -0x98(%ebp),%eax
80105cc5:	50                   	push   %eax
80105cc6:	52                   	push   %edx
80105cc7:	e8 ed f1 ff ff       	call   80104eb9 <fetchint>
80105ccc:	83 c4 10             	add    $0x10,%esp
80105ccf:	85 c0                	test   %eax,%eax
80105cd1:	79 07                	jns    80105cda <sys_exec+0xa0>
      return -1;
80105cd3:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105cd8:	eb 66                	jmp    80105d40 <sys_exec+0x106>
    if(uarg == 0){
80105cda:	8b 85 68 ff ff ff    	mov    -0x98(%ebp),%eax
80105ce0:	85 c0                	test   %eax,%eax
80105ce2:	75 27                	jne    80105d0b <sys_exec+0xd1>
      argv[i] = 0;
80105ce4:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105ce7:	c7 84 85 70 ff ff ff 	movl   $0x0,-0x90(%ebp,%eax,4)
80105cee:	00 00 00 00 
      break;
80105cf2:	90                   	nop
    }
    if(fetchstr(uarg, &argv[i]) < 0)
      return -1;
  }
  return exec(path, argv);
80105cf3:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105cf6:	83 ec 08             	sub    $0x8,%esp
80105cf9:	8d 95 70 ff ff ff    	lea    -0x90(%ebp),%edx
80105cff:	52                   	push   %edx
80105d00:	50                   	push   %eax
80105d01:	e8 7a ae ff ff       	call   80100b80 <exec>
80105d06:	83 c4 10             	add    $0x10,%esp
80105d09:	eb 35                	jmp    80105d40 <sys_exec+0x106>
    if(fetchstr(uarg, &argv[i]) < 0)
80105d0b:	8d 95 70 ff ff ff    	lea    -0x90(%ebp),%edx
80105d11:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105d14:	c1 e0 02             	shl    $0x2,%eax
80105d17:	01 c2                	add    %eax,%edx
80105d19:	8b 85 68 ff ff ff    	mov    -0x98(%ebp),%eax
80105d1f:	83 ec 08             	sub    $0x8,%esp
80105d22:	52                   	push   %edx
80105d23:	50                   	push   %eax
80105d24:	e8 cf f1 ff ff       	call   80104ef8 <fetchstr>
80105d29:	83 c4 10             	add    $0x10,%esp
80105d2c:	85 c0                	test   %eax,%eax
80105d2e:	79 07                	jns    80105d37 <sys_exec+0xfd>
      return -1;
80105d30:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105d35:	eb 09                	jmp    80105d40 <sys_exec+0x106>
  for(i=0;; i++){
80105d37:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
    if(i >= NELEM(argv))
80105d3b:	e9 5a ff ff ff       	jmp    80105c9a <sys_exec+0x60>
}
80105d40:	c9                   	leave  
80105d41:	c3                   	ret    

80105d42 <sys_pipe>:

int
sys_pipe(void)
{
80105d42:	55                   	push   %ebp
80105d43:	89 e5                	mov    %esp,%ebp
80105d45:	83 ec 28             	sub    $0x28,%esp
  int *fd;
  struct file *rf, *wf;
  int fd0, fd1;

  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
80105d48:	83 ec 04             	sub    $0x4,%esp
80105d4b:	6a 08                	push   $0x8
80105d4d:	8d 45 ec             	lea    -0x14(%ebp),%eax
80105d50:	50                   	push   %eax
80105d51:	6a 00                	push   $0x0
80105d53:	e8 2f f2 ff ff       	call   80104f87 <argptr>
80105d58:	83 c4 10             	add    $0x10,%esp
80105d5b:	85 c0                	test   %eax,%eax
80105d5d:	79 0a                	jns    80105d69 <sys_pipe+0x27>
    return -1;
80105d5f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105d64:	e9 ae 00 00 00       	jmp    80105e17 <sys_pipe+0xd5>
  if(pipealloc(&rf, &wf) < 0)
80105d69:	83 ec 08             	sub    $0x8,%esp
80105d6c:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80105d6f:	50                   	push   %eax
80105d70:	8d 45 e8             	lea    -0x18(%ebp),%eax
80105d73:	50                   	push   %eax
80105d74:	e8 f4 d7 ff ff       	call   8010356d <pipealloc>
80105d79:	83 c4 10             	add    $0x10,%esp
80105d7c:	85 c0                	test   %eax,%eax
80105d7e:	79 0a                	jns    80105d8a <sys_pipe+0x48>
    return -1;
80105d80:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105d85:	e9 8d 00 00 00       	jmp    80105e17 <sys_pipe+0xd5>
  fd0 = -1;
80105d8a:	c7 45 f4 ff ff ff ff 	movl   $0xffffffff,-0xc(%ebp)
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
80105d91:	8b 45 e8             	mov    -0x18(%ebp),%eax
80105d94:	83 ec 0c             	sub    $0xc,%esp
80105d97:	50                   	push   %eax
80105d98:	e8 7b f3 ff ff       	call   80105118 <fdalloc>
80105d9d:	83 c4 10             	add    $0x10,%esp
80105da0:	89 45 f4             	mov    %eax,-0xc(%ebp)
80105da3:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80105da7:	78 18                	js     80105dc1 <sys_pipe+0x7f>
80105da9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80105dac:	83 ec 0c             	sub    $0xc,%esp
80105daf:	50                   	push   %eax
80105db0:	e8 63 f3 ff ff       	call   80105118 <fdalloc>
80105db5:	83 c4 10             	add    $0x10,%esp
80105db8:	89 45 f0             	mov    %eax,-0x10(%ebp)
80105dbb:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80105dbf:	79 3e                	jns    80105dff <sys_pipe+0xbd>
    if(fd0 >= 0)
80105dc1:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80105dc5:	78 13                	js     80105dda <sys_pipe+0x98>
      myproc()->ofile[fd0] = 0;
80105dc7:	e8 64 dc ff ff       	call   80103a30 <myproc>
80105dcc:	8b 55 f4             	mov    -0xc(%ebp),%edx
80105dcf:	83 c2 08             	add    $0x8,%edx
80105dd2:	c7 44 90 08 00 00 00 	movl   $0x0,0x8(%eax,%edx,4)
80105dd9:	00 
    fileclose(rf);
80105dda:	8b 45 e8             	mov    -0x18(%ebp),%eax
80105ddd:	83 ec 0c             	sub    $0xc,%esp
80105de0:	50                   	push   %eax
80105de1:	e8 b5 b2 ff ff       	call   8010109b <fileclose>
80105de6:	83 c4 10             	add    $0x10,%esp
    fileclose(wf);
80105de9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80105dec:	83 ec 0c             	sub    $0xc,%esp
80105def:	50                   	push   %eax
80105df0:	e8 a6 b2 ff ff       	call   8010109b <fileclose>
80105df5:	83 c4 10             	add    $0x10,%esp
    return -1;
80105df8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105dfd:	eb 18                	jmp    80105e17 <sys_pipe+0xd5>
  }
  fd[0] = fd0;
80105dff:	8b 45 ec             	mov    -0x14(%ebp),%eax
80105e02:	8b 55 f4             	mov    -0xc(%ebp),%edx
80105e05:	89 10                	mov    %edx,(%eax)
  fd[1] = fd1;
80105e07:	8b 45 ec             	mov    -0x14(%ebp),%eax
80105e0a:	8d 50 04             	lea    0x4(%eax),%edx
80105e0d:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105e10:	89 02                	mov    %eax,(%edx)
  return 0;
80105e12:	b8 00 00 00 00       	mov    $0x0,%eax
}
80105e17:	c9                   	leave  
80105e18:	c3                   	ret    

80105e19 <sys_fork>:
#include "spinlock.h"
#include "debug.h"

int
sys_fork(void)
{
80105e19:	55                   	push   %ebp
80105e1a:	89 e5                	mov    %esp,%ebp
80105e1c:	83 ec 08             	sub    $0x8,%esp
  return fork();
80105e1f:	e8 0e df ff ff       	call   80103d32 <fork>
}
80105e24:	c9                   	leave  
80105e25:	c3                   	ret    

80105e26 <sys_exit>:

int
sys_exit(void)
{
80105e26:	55                   	push   %ebp
80105e27:	89 e5                	mov    %esp,%ebp
80105e29:	83 ec 08             	sub    $0x8,%esp
  exit();
80105e2c:	e8 7a e0 ff ff       	call   80103eab <exit>
  return 0;  // not reached
80105e31:	b8 00 00 00 00       	mov    $0x0,%eax
}
80105e36:	c9                   	leave  
80105e37:	c3                   	ret    

80105e38 <sys_uthread_init>:

int sys_uthread_init(void) {
80105e38:	55                   	push   %ebp
80105e39:	89 e5                	mov    %esp,%ebp
80105e3b:	83 ec 18             	sub    $0x18,%esp
  int address;
  //0번째 파라미터로 준 값을 &address에 저장.  유효값 아니라면 리턴 -1
  if (argint(0, &address) < 0)
80105e3e:	83 ec 08             	sub    $0x8,%esp
80105e41:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105e44:	50                   	push   %eax
80105e45:	6a 00                	push   $0x0
80105e47:	e8 0e f1 ff ff       	call   80104f5a <argint>
80105e4c:	83 c4 10             	add    $0x10,%esp
80105e4f:	85 c0                	test   %eax,%eax
80105e51:	79 07                	jns    80105e5a <sys_uthread_init+0x22>
	  return -1;
80105e53:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105e58:	eb 0f                	jmp    80105e69 <sys_uthread_init+0x31>
  //유효값이면 uthread_init 실행
  return uthread_init(address);
80105e5a:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105e5d:	83 ec 0c             	sub    $0xc,%esp
80105e60:	50                   	push   %eax
80105e61:	e8 68 e1 ff ff       	call   80103fce <uthread_init>
80105e66:	83 c4 10             	add    $0x10,%esp
}
80105e69:	c9                   	leave  
80105e6a:	c3                   	ret    

80105e6b <sys_exit2>:

int
sys_exit2(void) 
{
80105e6b:	55                   	push   %ebp
80105e6c:	89 e5                	mov    %esp,%ebp
80105e6e:	83 ec 18             	sub    $0x18,%esp
  int status;

  //첫번쨰 파라미터로 준 값을 &status에 입력한다.
  //유효값 아니라면 리턴 -1
  if (argint(0, &status) < 0)
80105e71:	83 ec 08             	sub    $0x8,%esp
80105e74:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105e77:	50                   	push   %eax
80105e78:	6a 00                	push   $0x0
80105e7a:	e8 db f0 ff ff       	call   80104f5a <argint>
80105e7f:	83 c4 10             	add    $0x10,%esp
80105e82:	85 c0                	test   %eax,%eax
80105e84:	79 07                	jns    80105e8d <sys_exit2+0x22>
	  return -1;
80105e86:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105e8b:	eb 12                	jmp    80105e9f <sys_exit2+0x34>
   
  exit2(status); 
80105e8d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105e90:	83 ec 0c             	sub    $0xc,%esp
80105e93:	50                   	push   %eax
80105e94:	e8 6b e1 ff ff       	call   80104004 <exit2>
80105e99:	83 c4 10             	add    $0x10,%esp
  //return 0; //eax에 리턴해야하니까
  return status; //eax에 리턴해야하니까
80105e9c:	8b 45 f4             	mov    -0xc(%ebp),%eax
}  
80105e9f:	c9                   	leave  
80105ea0:	c3                   	ret    

80105ea1 <sys_wait>:

int
sys_wait(void)
{
80105ea1:	55                   	push   %ebp
80105ea2:	89 e5                	mov    %esp,%ebp
80105ea4:	83 ec 08             	sub    $0x8,%esp
  return wait();
80105ea7:	e8 87 e2 ff ff       	call   80104133 <wait>
}
80105eac:	c9                   	leave  
80105ead:	c3                   	ret    

80105eae <sys_wait2>:
//*********new sys_waiat**********
//********************************

int
sys_wait2(void)
{
80105eae:	55                   	push   %ebp
80105eaf:	89 e5                	mov    %esp,%ebp
80105eb1:	83 ec 18             	sub    $0x18,%esp

  int status;
  //포인터 값 복사, 유효값 아니라면 리턴 -1
  if(argptr(0, (char **)&status, sizeof(int)) < 0)
80105eb4:	83 ec 04             	sub    $0x4,%esp
80105eb7:	6a 04                	push   $0x4
80105eb9:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105ebc:	50                   	push   %eax
80105ebd:	6a 00                	push   $0x0
80105ebf:	e8 c3 f0 ff ff       	call   80104f87 <argptr>
80105ec4:	83 c4 10             	add    $0x10,%esp
80105ec7:	85 c0                	test   %eax,%eax
80105ec9:	79 07                	jns    80105ed2 <sys_wait2+0x24>
    return -1;
80105ecb:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105ed0:	eb 0f                	jmp    80105ee1 <sys_wait2+0x33>

  //유효값이면 wait2 실행
  return wait2(&status);
80105ed2:	83 ec 0c             	sub    $0xc,%esp
80105ed5:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105ed8:	50                   	push   %eax
80105ed9:	e8 78 e3 ff ff       	call   80104256 <wait2>
80105ede:	83 c4 10             	add    $0x10,%esp

}
80105ee1:	c9                   	leave  
80105ee2:	c3                   	ret    

80105ee3 <sys_kill>:
//********************************


int
sys_kill(void)
{
80105ee3:	55                   	push   %ebp
80105ee4:	89 e5                	mov    %esp,%ebp
80105ee6:	83 ec 18             	sub    $0x18,%esp
  int pid;

  if(argint(0, &pid) < 0)
80105ee9:	83 ec 08             	sub    $0x8,%esp
80105eec:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105eef:	50                   	push   %eax
80105ef0:	6a 00                	push   $0x0
80105ef2:	e8 63 f0 ff ff       	call   80104f5a <argint>
80105ef7:	83 c4 10             	add    $0x10,%esp
80105efa:	85 c0                	test   %eax,%eax
80105efc:	79 07                	jns    80105f05 <sys_kill+0x22>
    return -1;
80105efe:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105f03:	eb 0f                	jmp    80105f14 <sys_kill+0x31>
  return kill(pid);
80105f05:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105f08:	83 ec 0c             	sub    $0xc,%esp
80105f0b:	50                   	push   %eax
80105f0c:	e8 a5 e7 ff ff       	call   801046b6 <kill>
80105f11:	83 c4 10             	add    $0x10,%esp
}
80105f14:	c9                   	leave  
80105f15:	c3                   	ret    

80105f16 <sys_getpid>:

int
sys_getpid(void)
{
80105f16:	55                   	push   %ebp
80105f17:	89 e5                	mov    %esp,%ebp
80105f19:	83 ec 08             	sub    $0x8,%esp
  return myproc()->pid;
80105f1c:	e8 0f db ff ff       	call   80103a30 <myproc>
80105f21:	8b 40 10             	mov    0x10(%eax),%eax
}
80105f24:	c9                   	leave  
80105f25:	c3                   	ret    

80105f26 <sys_sbrk>:

int
sys_sbrk(void)
{
80105f26:	55                   	push   %ebp
80105f27:	89 e5                	mov    %esp,%ebp
80105f29:	83 ec 18             	sub    $0x18,%esp
  int addr;
  int n;

  if(argint(0, &n) < 0)
80105f2c:	83 ec 08             	sub    $0x8,%esp
80105f2f:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105f32:	50                   	push   %eax
80105f33:	6a 00                	push   $0x0
80105f35:	e8 20 f0 ff ff       	call   80104f5a <argint>
80105f3a:	83 c4 10             	add    $0x10,%esp
80105f3d:	85 c0                	test   %eax,%eax
80105f3f:	79 07                	jns    80105f48 <sys_sbrk+0x22>
    return -1;
80105f41:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105f46:	eb 27                	jmp    80105f6f <sys_sbrk+0x49>
  addr = myproc()->sz;
80105f48:	e8 e3 da ff ff       	call   80103a30 <myproc>
80105f4d:	8b 00                	mov    (%eax),%eax
80105f4f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(growproc(n) < 0)
80105f52:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105f55:	83 ec 0c             	sub    $0xc,%esp
80105f58:	50                   	push   %eax
80105f59:	e8 39 dd ff ff       	call   80103c97 <growproc>
80105f5e:	83 c4 10             	add    $0x10,%esp
80105f61:	85 c0                	test   %eax,%eax
80105f63:	79 07                	jns    80105f6c <sys_sbrk+0x46>
    return -1;
80105f65:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105f6a:	eb 03                	jmp    80105f6f <sys_sbrk+0x49>
  return addr;
80105f6c:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
80105f6f:	c9                   	leave  
80105f70:	c3                   	ret    

80105f71 <sys_sleep>:

int
sys_sleep(void)
{
80105f71:	55                   	push   %ebp
80105f72:	89 e5                	mov    %esp,%ebp
80105f74:	83 ec 18             	sub    $0x18,%esp
  int n;
  uint ticks0;

  if(argint(0, &n) < 0)
80105f77:	83 ec 08             	sub    $0x8,%esp
80105f7a:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105f7d:	50                   	push   %eax
80105f7e:	6a 00                	push   $0x0
80105f80:	e8 d5 ef ff ff       	call   80104f5a <argint>
80105f85:	83 c4 10             	add    $0x10,%esp
80105f88:	85 c0                	test   %eax,%eax
80105f8a:	79 07                	jns    80105f93 <sys_sleep+0x22>
    return -1;
80105f8c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105f91:	eb 76                	jmp    80106009 <sys_sleep+0x98>
  acquire(&tickslock);
80105f93:	83 ec 0c             	sub    $0xc,%esp
80105f96:	68 40 6b 19 80       	push   $0x80196b40
80105f9b:	e8 19 ea ff ff       	call   801049b9 <acquire>
80105fa0:	83 c4 10             	add    $0x10,%esp
  ticks0 = ticks;
80105fa3:	a1 74 6b 19 80       	mov    0x80196b74,%eax
80105fa8:	89 45 f4             	mov    %eax,-0xc(%ebp)
  while(ticks - ticks0 < n){
80105fab:	eb 38                	jmp    80105fe5 <sys_sleep+0x74>
    if(myproc()->killed){
80105fad:	e8 7e da ff ff       	call   80103a30 <myproc>
80105fb2:	8b 40 24             	mov    0x24(%eax),%eax
80105fb5:	85 c0                	test   %eax,%eax
80105fb7:	74 17                	je     80105fd0 <sys_sleep+0x5f>
      release(&tickslock);
80105fb9:	83 ec 0c             	sub    $0xc,%esp
80105fbc:	68 40 6b 19 80       	push   $0x80196b40
80105fc1:	e8 61 ea ff ff       	call   80104a27 <release>
80105fc6:	83 c4 10             	add    $0x10,%esp
      return -1;
80105fc9:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105fce:	eb 39                	jmp    80106009 <sys_sleep+0x98>
    }
    sleep(&ticks, &tickslock);
80105fd0:	83 ec 08             	sub    $0x8,%esp
80105fd3:	68 40 6b 19 80       	push   $0x80196b40
80105fd8:	68 74 6b 19 80       	push   $0x80196b74
80105fdd:	e8 b3 e5 ff ff       	call   80104595 <sleep>
80105fe2:	83 c4 10             	add    $0x10,%esp
  while(ticks - ticks0 < n){
80105fe5:	a1 74 6b 19 80       	mov    0x80196b74,%eax
80105fea:	2b 45 f4             	sub    -0xc(%ebp),%eax
80105fed:	8b 55 f0             	mov    -0x10(%ebp),%edx
80105ff0:	39 d0                	cmp    %edx,%eax
80105ff2:	72 b9                	jb     80105fad <sys_sleep+0x3c>
  }
  release(&tickslock);
80105ff4:	83 ec 0c             	sub    $0xc,%esp
80105ff7:	68 40 6b 19 80       	push   $0x80196b40
80105ffc:	e8 26 ea ff ff       	call   80104a27 <release>
80106001:	83 c4 10             	add    $0x10,%esp
  return 0;
80106004:	b8 00 00 00 00       	mov    $0x0,%eax
}
80106009:	c9                   	leave  
8010600a:	c3                   	ret    

8010600b <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
int
sys_uptime(void)
{
8010600b:	55                   	push   %ebp
8010600c:	89 e5                	mov    %esp,%ebp
8010600e:	83 ec 18             	sub    $0x18,%esp
  uint xticks;

  acquire(&tickslock);
80106011:	83 ec 0c             	sub    $0xc,%esp
80106014:	68 40 6b 19 80       	push   $0x80196b40
80106019:	e8 9b e9 ff ff       	call   801049b9 <acquire>
8010601e:	83 c4 10             	add    $0x10,%esp
  xticks = ticks;
80106021:	a1 74 6b 19 80       	mov    0x80196b74,%eax
80106026:	89 45 f4             	mov    %eax,-0xc(%ebp)
  release(&tickslock);
80106029:	83 ec 0c             	sub    $0xc,%esp
8010602c:	68 40 6b 19 80       	push   $0x80196b40
80106031:	e8 f1 e9 ff ff       	call   80104a27 <release>
80106036:	83 c4 10             	add    $0x10,%esp
  return xticks;
80106039:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
8010603c:	c9                   	leave  
8010603d:	c3                   	ret    

8010603e <alltraps>:
8010603e:	1e                   	push   %ds
8010603f:	06                   	push   %es
80106040:	0f a0                	push   %fs
80106042:	0f a8                	push   %gs
80106044:	60                   	pusha  
80106045:	66 b8 10 00          	mov    $0x10,%ax
80106049:	8e d8                	mov    %eax,%ds
8010604b:	8e c0                	mov    %eax,%es
8010604d:	54                   	push   %esp
8010604e:	e8 d7 01 00 00       	call   8010622a <trap>
80106053:	83 c4 04             	add    $0x4,%esp

80106056 <trapret>:
80106056:	61                   	popa   
80106057:	0f a9                	pop    %gs
80106059:	0f a1                	pop    %fs
8010605b:	07                   	pop    %es
8010605c:	1f                   	pop    %ds
8010605d:	83 c4 08             	add    $0x8,%esp
80106060:	cf                   	iret   

80106061 <lidt>:
{
80106061:	55                   	push   %ebp
80106062:	89 e5                	mov    %esp,%ebp
80106064:	83 ec 10             	sub    $0x10,%esp
  pd[0] = size-1;
80106067:	8b 45 0c             	mov    0xc(%ebp),%eax
8010606a:	83 e8 01             	sub    $0x1,%eax
8010606d:	66 89 45 fa          	mov    %ax,-0x6(%ebp)
  pd[1] = (uint)p;
80106071:	8b 45 08             	mov    0x8(%ebp),%eax
80106074:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  pd[2] = (uint)p >> 16;
80106078:	8b 45 08             	mov    0x8(%ebp),%eax
8010607b:	c1 e8 10             	shr    $0x10,%eax
8010607e:	66 89 45 fe          	mov    %ax,-0x2(%ebp)
  asm volatile("lidt (%0)" : : "r" (pd));
80106082:	8d 45 fa             	lea    -0x6(%ebp),%eax
80106085:	0f 01 18             	lidtl  (%eax)
}
80106088:	90                   	nop
80106089:	c9                   	leave  
8010608a:	c3                   	ret    

8010608b <rcr2>:

static inline uint
rcr2(void)
{
8010608b:	55                   	push   %ebp
8010608c:	89 e5                	mov    %esp,%ebp
8010608e:	83 ec 10             	sub    $0x10,%esp
  uint val;
  asm volatile("movl %%cr2,%0" : "=r" (val));
80106091:	0f 20 d0             	mov    %cr2,%eax
80106094:	89 45 fc             	mov    %eax,-0x4(%ebp)
  return val;
80106097:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
8010609a:	c9                   	leave  
8010609b:	c3                   	ret    

8010609c <tvinit>:
//extern void thread_switch(void); //************** modified
//uint address; //************** modified

void
tvinit(void)
{
8010609c:	55                   	push   %ebp
8010609d:	89 e5                	mov    %esp,%ebp
8010609f:	83 ec 18             	sub    $0x18,%esp
  int i;

  for(i = 0; i < 256; i++)
801060a2:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
801060a9:	e9 c3 00 00 00       	jmp    80106171 <tvinit+0xd5>
    SETGATE(idt[i], 0, SEG_KCODE<<3, vectors[i], 0);
801060ae:	8b 45 f4             	mov    -0xc(%ebp),%eax
801060b1:	8b 04 85 84 f0 10 80 	mov    -0x7fef0f7c(,%eax,4),%eax
801060b8:	89 c2                	mov    %eax,%edx
801060ba:	8b 45 f4             	mov    -0xc(%ebp),%eax
801060bd:	66 89 14 c5 40 63 19 	mov    %dx,-0x7fe69cc0(,%eax,8)
801060c4:	80 
801060c5:	8b 45 f4             	mov    -0xc(%ebp),%eax
801060c8:	66 c7 04 c5 42 63 19 	movw   $0x8,-0x7fe69cbe(,%eax,8)
801060cf:	80 08 00 
801060d2:	8b 45 f4             	mov    -0xc(%ebp),%eax
801060d5:	0f b6 14 c5 44 63 19 	movzbl -0x7fe69cbc(,%eax,8),%edx
801060dc:	80 
801060dd:	83 e2 e0             	and    $0xffffffe0,%edx
801060e0:	88 14 c5 44 63 19 80 	mov    %dl,-0x7fe69cbc(,%eax,8)
801060e7:	8b 45 f4             	mov    -0xc(%ebp),%eax
801060ea:	0f b6 14 c5 44 63 19 	movzbl -0x7fe69cbc(,%eax,8),%edx
801060f1:	80 
801060f2:	83 e2 1f             	and    $0x1f,%edx
801060f5:	88 14 c5 44 63 19 80 	mov    %dl,-0x7fe69cbc(,%eax,8)
801060fc:	8b 45 f4             	mov    -0xc(%ebp),%eax
801060ff:	0f b6 14 c5 45 63 19 	movzbl -0x7fe69cbb(,%eax,8),%edx
80106106:	80 
80106107:	83 e2 f0             	and    $0xfffffff0,%edx
8010610a:	83 ca 0e             	or     $0xe,%edx
8010610d:	88 14 c5 45 63 19 80 	mov    %dl,-0x7fe69cbb(,%eax,8)
80106114:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106117:	0f b6 14 c5 45 63 19 	movzbl -0x7fe69cbb(,%eax,8),%edx
8010611e:	80 
8010611f:	83 e2 ef             	and    $0xffffffef,%edx
80106122:	88 14 c5 45 63 19 80 	mov    %dl,-0x7fe69cbb(,%eax,8)
80106129:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010612c:	0f b6 14 c5 45 63 19 	movzbl -0x7fe69cbb(,%eax,8),%edx
80106133:	80 
80106134:	83 e2 9f             	and    $0xffffff9f,%edx
80106137:	88 14 c5 45 63 19 80 	mov    %dl,-0x7fe69cbb(,%eax,8)
8010613e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106141:	0f b6 14 c5 45 63 19 	movzbl -0x7fe69cbb(,%eax,8),%edx
80106148:	80 
80106149:	83 ca 80             	or     $0xffffff80,%edx
8010614c:	88 14 c5 45 63 19 80 	mov    %dl,-0x7fe69cbb(,%eax,8)
80106153:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106156:	8b 04 85 84 f0 10 80 	mov    -0x7fef0f7c(,%eax,4),%eax
8010615d:	c1 e8 10             	shr    $0x10,%eax
80106160:	89 c2                	mov    %eax,%edx
80106162:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106165:	66 89 14 c5 46 63 19 	mov    %dx,-0x7fe69cba(,%eax,8)
8010616c:	80 
  for(i = 0; i < 256; i++)
8010616d:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80106171:	81 7d f4 ff 00 00 00 	cmpl   $0xff,-0xc(%ebp)
80106178:	0f 8e 30 ff ff ff    	jle    801060ae <tvinit+0x12>
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
8010617e:	a1 84 f1 10 80       	mov    0x8010f184,%eax
80106183:	66 a3 40 65 19 80    	mov    %ax,0x80196540
80106189:	66 c7 05 42 65 19 80 	movw   $0x8,0x80196542
80106190:	08 00 
80106192:	0f b6 05 44 65 19 80 	movzbl 0x80196544,%eax
80106199:	83 e0 e0             	and    $0xffffffe0,%eax
8010619c:	a2 44 65 19 80       	mov    %al,0x80196544
801061a1:	0f b6 05 44 65 19 80 	movzbl 0x80196544,%eax
801061a8:	83 e0 1f             	and    $0x1f,%eax
801061ab:	a2 44 65 19 80       	mov    %al,0x80196544
801061b0:	0f b6 05 45 65 19 80 	movzbl 0x80196545,%eax
801061b7:	83 c8 0f             	or     $0xf,%eax
801061ba:	a2 45 65 19 80       	mov    %al,0x80196545
801061bf:	0f b6 05 45 65 19 80 	movzbl 0x80196545,%eax
801061c6:	83 e0 ef             	and    $0xffffffef,%eax
801061c9:	a2 45 65 19 80       	mov    %al,0x80196545
801061ce:	0f b6 05 45 65 19 80 	movzbl 0x80196545,%eax
801061d5:	83 c8 60             	or     $0x60,%eax
801061d8:	a2 45 65 19 80       	mov    %al,0x80196545
801061dd:	0f b6 05 45 65 19 80 	movzbl 0x80196545,%eax
801061e4:	83 c8 80             	or     $0xffffff80,%eax
801061e7:	a2 45 65 19 80       	mov    %al,0x80196545
801061ec:	a1 84 f1 10 80       	mov    0x8010f184,%eax
801061f1:	c1 e8 10             	shr    $0x10,%eax
801061f4:	66 a3 46 65 19 80    	mov    %ax,0x80196546

  initlock(&tickslock, "time");
801061fa:	83 ec 08             	sub    $0x8,%esp
801061fd:	68 18 a7 10 80       	push   $0x8010a718
80106202:	68 40 6b 19 80       	push   $0x80196b40
80106207:	e8 8b e7 ff ff       	call   80104997 <initlock>
8010620c:	83 c4 10             	add    $0x10,%esp
}
8010620f:	90                   	nop
80106210:	c9                   	leave  
80106211:	c3                   	ret    

80106212 <idtinit>:

void
idtinit(void)
{
80106212:	55                   	push   %ebp
80106213:	89 e5                	mov    %esp,%ebp
  lidt(idt, sizeof(idt));
80106215:	68 00 08 00 00       	push   $0x800
8010621a:	68 40 63 19 80       	push   $0x80196340
8010621f:	e8 3d fe ff ff       	call   80106061 <lidt>
80106224:	83 c4 08             	add    $0x8,%esp
}
80106227:	90                   	nop
80106228:	c9                   	leave  
80106229:	c3                   	ret    

8010622a <trap>:

//PAGEBREAK: 41
void
trap(struct trapframe *tf)
{
8010622a:	55                   	push   %ebp
8010622b:	89 e5                	mov    %esp,%ebp
8010622d:	57                   	push   %edi
8010622e:	56                   	push   %esi
8010622f:	53                   	push   %ebx
80106230:	83 ec 1c             	sub    $0x1c,%esp
  if(tf->trapno == T_SYSCALL){ //시스템 콜 처리
80106233:	8b 45 08             	mov    0x8(%ebp),%eax
80106236:	8b 40 30             	mov    0x30(%eax),%eax
80106239:	83 f8 40             	cmp    $0x40,%eax
8010623c:	75 3b                	jne    80106279 <trap+0x4f>
    if(myproc()->killed)
8010623e:	e8 ed d7 ff ff       	call   80103a30 <myproc>
80106243:	8b 40 24             	mov    0x24(%eax),%eax
80106246:	85 c0                	test   %eax,%eax
80106248:	74 05                	je     8010624f <trap+0x25>
      exit();
8010624a:	e8 5c dc ff ff       	call   80103eab <exit>
    myproc()->tf = tf;
8010624f:	e8 dc d7 ff ff       	call   80103a30 <myproc>
80106254:	8b 55 08             	mov    0x8(%ebp),%edx
80106257:	89 50 18             	mov    %edx,0x18(%eax)
    syscall(); //usys.S에 정의됨
8010625a:	e8 c7 ed ff ff       	call   80105026 <syscall>
    if(myproc()->killed)
8010625f:	e8 cc d7 ff ff       	call   80103a30 <myproc>
80106264:	8b 40 24             	mov    0x24(%eax),%eax
80106267:	85 c0                	test   %eax,%eax
80106269:	0f 84 15 02 00 00    	je     80106484 <trap+0x25a>
      exit();
8010626f:	e8 37 dc ff ff       	call   80103eab <exit>
    return;
80106274:	e9 0b 02 00 00       	jmp    80106484 <trap+0x25a>
  }

  switch(tf->trapno){
80106279:	8b 45 08             	mov    0x8(%ebp),%eax
8010627c:	8b 40 30             	mov    0x30(%eax),%eax
8010627f:	83 e8 20             	sub    $0x20,%eax
80106282:	83 f8 1f             	cmp    $0x1f,%eax
80106285:	0f 87 c4 00 00 00    	ja     8010634f <trap+0x125>
8010628b:	8b 04 85 c0 a7 10 80 	mov    -0x7fef5840(,%eax,4),%eax
80106292:	ff e0                	jmp    *%eax
  case T_IRQ0 + IRQ_TIMER: //*************timer interrupt
    if(cpuid() == 0){
80106294:	e8 04 d7 ff ff       	call   8010399d <cpuid>
80106299:	85 c0                	test   %eax,%eax
8010629b:	75 3d                	jne    801062da <trap+0xb0>
      acquire(&tickslock);
8010629d:	83 ec 0c             	sub    $0xc,%esp
801062a0:	68 40 6b 19 80       	push   $0x80196b40
801062a5:	e8 0f e7 ff ff       	call   801049b9 <acquire>
801062aa:	83 c4 10             	add    $0x10,%esp
      ticks++;
801062ad:	a1 74 6b 19 80       	mov    0x80196b74,%eax
801062b2:	83 c0 01             	add    $0x1,%eax
801062b5:	a3 74 6b 19 80       	mov    %eax,0x80196b74
      wakeup(&ticks);
801062ba:	83 ec 0c             	sub    $0xc,%esp
801062bd:	68 74 6b 19 80       	push   $0x80196b74
801062c2:	e8 b8 e3 ff ff       	call   8010467f <wakeup>
801062c7:	83 c4 10             	add    $0x10,%esp
      release(&tickslock);
801062ca:	83 ec 0c             	sub    $0xc,%esp
801062cd:	68 40 6b 19 80       	push   $0x80196b40
801062d2:	e8 50 e7 ff ff       	call   80104a27 <release>
801062d7:	83 c4 10             	add    $0x10,%esp
    }
    lapiceoi();
801062da:	e8 3d c8 ff ff       	call   80102b1c <lapiceoi>
//	}
//******************   new code   ****************



    break;
801062df:	e9 20 01 00 00       	jmp    80106404 <trap+0x1da>
       
  case T_IRQ0 + IRQ_IDE:
    ideintr();
801062e4:	e8 f5 3e 00 00       	call   8010a1de <ideintr>
    lapiceoi();
801062e9:	e8 2e c8 ff ff       	call   80102b1c <lapiceoi>
    break;
801062ee:	e9 11 01 00 00       	jmp    80106404 <trap+0x1da>
  case T_IRQ0 + IRQ_IDE+1:
    // Bochs generates spurious IDE1 interrupts.
    break;
  case T_IRQ0 + IRQ_KBD:
    kbdintr();
801062f3:	e8 69 c6 ff ff       	call   80102961 <kbdintr>
    lapiceoi();
801062f8:	e8 1f c8 ff ff       	call   80102b1c <lapiceoi>
    break;
801062fd:	e9 02 01 00 00       	jmp    80106404 <trap+0x1da>
  case T_IRQ0 + IRQ_COM1:
    uartintr();
80106302:	e8 53 03 00 00       	call   8010665a <uartintr>
    lapiceoi();
80106307:	e8 10 c8 ff ff       	call   80102b1c <lapiceoi>
    break;
8010630c:	e9 f3 00 00 00       	jmp    80106404 <trap+0x1da>
  case T_IRQ0 + 0xB:
    i8254_intr();
80106311:	e8 7b 2b 00 00       	call   80108e91 <i8254_intr>
    lapiceoi();
80106316:	e8 01 c8 ff ff       	call   80102b1c <lapiceoi>
    break;
8010631b:	e9 e4 00 00 00       	jmp    80106404 <trap+0x1da>
  case T_IRQ0 + IRQ_SPURIOUS:
    cprintf("cpu%d: spurious interrupt at %x:%x\n",
80106320:	8b 45 08             	mov    0x8(%ebp),%eax
80106323:	8b 70 38             	mov    0x38(%eax),%esi
            cpuid(), tf->cs, tf->eip);
80106326:	8b 45 08             	mov    0x8(%ebp),%eax
80106329:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
    cprintf("cpu%d: spurious interrupt at %x:%x\n",
8010632d:	0f b7 d8             	movzwl %ax,%ebx
80106330:	e8 68 d6 ff ff       	call   8010399d <cpuid>
80106335:	56                   	push   %esi
80106336:	53                   	push   %ebx
80106337:	50                   	push   %eax
80106338:	68 20 a7 10 80       	push   $0x8010a720
8010633d:	e8 b2 a0 ff ff       	call   801003f4 <cprintf>
80106342:	83 c4 10             	add    $0x10,%esp
    lapiceoi();
80106345:	e8 d2 c7 ff ff       	call   80102b1c <lapiceoi>
    break;
8010634a:	e9 b5 00 00 00       	jmp    80106404 <trap+0x1da>

  //PAGEBREAK: 13
  default:
    if(myproc() == 0 || (tf->cs&3) == 0){
8010634f:	e8 dc d6 ff ff       	call   80103a30 <myproc>
80106354:	85 c0                	test   %eax,%eax
80106356:	74 11                	je     80106369 <trap+0x13f>
80106358:	8b 45 08             	mov    0x8(%ebp),%eax
8010635b:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
8010635f:	0f b7 c0             	movzwl %ax,%eax
80106362:	83 e0 03             	and    $0x3,%eax
80106365:	85 c0                	test   %eax,%eax
80106367:	75 39                	jne    801063a2 <trap+0x178>
      // In kernel, it must be our mistake.
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
80106369:	e8 1d fd ff ff       	call   8010608b <rcr2>
8010636e:	89 c3                	mov    %eax,%ebx
80106370:	8b 45 08             	mov    0x8(%ebp),%eax
80106373:	8b 70 38             	mov    0x38(%eax),%esi
80106376:	e8 22 d6 ff ff       	call   8010399d <cpuid>
8010637b:	8b 55 08             	mov    0x8(%ebp),%edx
8010637e:	8b 52 30             	mov    0x30(%edx),%edx
80106381:	83 ec 0c             	sub    $0xc,%esp
80106384:	53                   	push   %ebx
80106385:	56                   	push   %esi
80106386:	50                   	push   %eax
80106387:	52                   	push   %edx
80106388:	68 44 a7 10 80       	push   $0x8010a744
8010638d:	e8 62 a0 ff ff       	call   801003f4 <cprintf>
80106392:	83 c4 20             	add    $0x20,%esp
              tf->trapno, cpuid(), tf->eip, rcr2());
      panic("trap");
80106395:	83 ec 0c             	sub    $0xc,%esp
80106398:	68 76 a7 10 80       	push   $0x8010a776
8010639d:	e8 07 a2 ff ff       	call   801005a9 <panic>
    }
    // In user space, assume process misbehaved.
    cprintf("pid %d %s: trap %d err %d on cpu %d "
801063a2:	e8 e4 fc ff ff       	call   8010608b <rcr2>
801063a7:	89 c6                	mov    %eax,%esi
801063a9:	8b 45 08             	mov    0x8(%ebp),%eax
801063ac:	8b 40 38             	mov    0x38(%eax),%eax
801063af:	89 45 e4             	mov    %eax,-0x1c(%ebp)
801063b2:	e8 e6 d5 ff ff       	call   8010399d <cpuid>
801063b7:	89 c3                	mov    %eax,%ebx
801063b9:	8b 45 08             	mov    0x8(%ebp),%eax
801063bc:	8b 48 34             	mov    0x34(%eax),%ecx
801063bf:	89 4d e0             	mov    %ecx,-0x20(%ebp)
801063c2:	8b 45 08             	mov    0x8(%ebp),%eax
801063c5:	8b 78 30             	mov    0x30(%eax),%edi
            "eip 0x%x addr 0x%x--kill proc\n",
            myproc()->pid, myproc()->name, tf->trapno,
801063c8:	e8 63 d6 ff ff       	call   80103a30 <myproc>
801063cd:	8d 50 6c             	lea    0x6c(%eax),%edx
801063d0:	89 55 dc             	mov    %edx,-0x24(%ebp)
801063d3:	e8 58 d6 ff ff       	call   80103a30 <myproc>
    cprintf("pid %d %s: trap %d err %d on cpu %d "
801063d8:	8b 40 10             	mov    0x10(%eax),%eax
801063db:	56                   	push   %esi
801063dc:	ff 75 e4             	push   -0x1c(%ebp)
801063df:	53                   	push   %ebx
801063e0:	ff 75 e0             	push   -0x20(%ebp)
801063e3:	57                   	push   %edi
801063e4:	ff 75 dc             	push   -0x24(%ebp)
801063e7:	50                   	push   %eax
801063e8:	68 7c a7 10 80       	push   $0x8010a77c
801063ed:	e8 02 a0 ff ff       	call   801003f4 <cprintf>
801063f2:	83 c4 20             	add    $0x20,%esp
            tf->err, cpuid(), tf->eip, rcr2());
    myproc()->killed = 1;
801063f5:	e8 36 d6 ff ff       	call   80103a30 <myproc>
801063fa:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
80106401:	eb 01                	jmp    80106404 <trap+0x1da>
    break;
80106403:	90                   	nop
  }

  // Force process exit if it has been killed and is in user space.
  // (If it is still executing in the kernel, let it keep running
  // until it gets to the regular system call return.)
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80106404:	e8 27 d6 ff ff       	call   80103a30 <myproc>
80106409:	85 c0                	test   %eax,%eax
8010640b:	74 23                	je     80106430 <trap+0x206>
8010640d:	e8 1e d6 ff ff       	call   80103a30 <myproc>
80106412:	8b 40 24             	mov    0x24(%eax),%eax
80106415:	85 c0                	test   %eax,%eax
80106417:	74 17                	je     80106430 <trap+0x206>
80106419:	8b 45 08             	mov    0x8(%ebp),%eax
8010641c:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
80106420:	0f b7 c0             	movzwl %ax,%eax
80106423:	83 e0 03             	and    $0x3,%eax
80106426:	83 f8 03             	cmp    $0x3,%eax
80106429:	75 05                	jne    80106430 <trap+0x206>
    exit();
8010642b:	e8 7b da ff ff       	call   80103eab <exit>

  // Force process to give up CPU on clock tick.
  // If interrupts were on while locks held, would need to check nlock.
  if(myproc() && myproc()->state == RUNNING &&
80106430:	e8 fb d5 ff ff       	call   80103a30 <myproc>
80106435:	85 c0                	test   %eax,%eax
80106437:	74 1d                	je     80106456 <trap+0x22c>
80106439:	e8 f2 d5 ff ff       	call   80103a30 <myproc>
8010643e:	8b 40 0c             	mov    0xc(%eax),%eax
80106441:	83 f8 04             	cmp    $0x4,%eax
80106444:	75 10                	jne    80106456 <trap+0x22c>
     tf->trapno == T_IRQ0+IRQ_TIMER)
80106446:	8b 45 08             	mov    0x8(%ebp),%eax
80106449:	8b 40 30             	mov    0x30(%eax),%eax
  if(myproc() && myproc()->state == RUNNING &&
8010644c:	83 f8 20             	cmp    $0x20,%eax
8010644f:	75 05                	jne    80106456 <trap+0x22c>
    yield();
80106451:	e8 bf e0 ff ff       	call   80104515 <yield>

  // Check if the process has been killed since we yielded
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80106456:	e8 d5 d5 ff ff       	call   80103a30 <myproc>
8010645b:	85 c0                	test   %eax,%eax
8010645d:	74 26                	je     80106485 <trap+0x25b>
8010645f:	e8 cc d5 ff ff       	call   80103a30 <myproc>
80106464:	8b 40 24             	mov    0x24(%eax),%eax
80106467:	85 c0                	test   %eax,%eax
80106469:	74 1a                	je     80106485 <trap+0x25b>
8010646b:	8b 45 08             	mov    0x8(%ebp),%eax
8010646e:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
80106472:	0f b7 c0             	movzwl %ax,%eax
80106475:	83 e0 03             	and    $0x3,%eax
80106478:	83 f8 03             	cmp    $0x3,%eax
8010647b:	75 08                	jne    80106485 <trap+0x25b>
    exit();
8010647d:	e8 29 da ff ff       	call   80103eab <exit>
80106482:	eb 01                	jmp    80106485 <trap+0x25b>
    return;
80106484:	90                   	nop
}
80106485:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106488:	5b                   	pop    %ebx
80106489:	5e                   	pop    %esi
8010648a:	5f                   	pop    %edi
8010648b:	5d                   	pop    %ebp
8010648c:	c3                   	ret    

8010648d <inb>:
{
8010648d:	55                   	push   %ebp
8010648e:	89 e5                	mov    %esp,%ebp
80106490:	83 ec 14             	sub    $0x14,%esp
80106493:	8b 45 08             	mov    0x8(%ebp),%eax
80106496:	66 89 45 ec          	mov    %ax,-0x14(%ebp)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010649a:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
8010649e:	89 c2                	mov    %eax,%edx
801064a0:	ec                   	in     (%dx),%al
801064a1:	88 45 ff             	mov    %al,-0x1(%ebp)
  return data;
801064a4:	0f b6 45 ff          	movzbl -0x1(%ebp),%eax
}
801064a8:	c9                   	leave  
801064a9:	c3                   	ret    

801064aa <outb>:
{
801064aa:	55                   	push   %ebp
801064ab:	89 e5                	mov    %esp,%ebp
801064ad:	83 ec 08             	sub    $0x8,%esp
801064b0:	8b 45 08             	mov    0x8(%ebp),%eax
801064b3:	8b 55 0c             	mov    0xc(%ebp),%edx
801064b6:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
801064ba:	89 d0                	mov    %edx,%eax
801064bc:	88 45 f8             	mov    %al,-0x8(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801064bf:	0f b6 45 f8          	movzbl -0x8(%ebp),%eax
801064c3:	0f b7 55 fc          	movzwl -0x4(%ebp),%edx
801064c7:	ee                   	out    %al,(%dx)
}
801064c8:	90                   	nop
801064c9:	c9                   	leave  
801064ca:	c3                   	ret    

801064cb <uartinit>:

static int uart;    // is there a uart?

void
uartinit(void)
{
801064cb:	55                   	push   %ebp
801064cc:	89 e5                	mov    %esp,%ebp
801064ce:	83 ec 18             	sub    $0x18,%esp
  char *p;

  // Turn off the FIFO
  outb(COM1+2, 0);
801064d1:	6a 00                	push   $0x0
801064d3:	68 fa 03 00 00       	push   $0x3fa
801064d8:	e8 cd ff ff ff       	call   801064aa <outb>
801064dd:	83 c4 08             	add    $0x8,%esp

  // 9600 baud, 8 data bits, 1 stop bit, parity off.
  outb(COM1+3, 0x80);    // Unlock divisor
801064e0:	68 80 00 00 00       	push   $0x80
801064e5:	68 fb 03 00 00       	push   $0x3fb
801064ea:	e8 bb ff ff ff       	call   801064aa <outb>
801064ef:	83 c4 08             	add    $0x8,%esp
  outb(COM1+0, 115200/9600);
801064f2:	6a 0c                	push   $0xc
801064f4:	68 f8 03 00 00       	push   $0x3f8
801064f9:	e8 ac ff ff ff       	call   801064aa <outb>
801064fe:	83 c4 08             	add    $0x8,%esp
  outb(COM1+1, 0);
80106501:	6a 00                	push   $0x0
80106503:	68 f9 03 00 00       	push   $0x3f9
80106508:	e8 9d ff ff ff       	call   801064aa <outb>
8010650d:	83 c4 08             	add    $0x8,%esp
  outb(COM1+3, 0x03);    // Lock divisor, 8 data bits.
80106510:	6a 03                	push   $0x3
80106512:	68 fb 03 00 00       	push   $0x3fb
80106517:	e8 8e ff ff ff       	call   801064aa <outb>
8010651c:	83 c4 08             	add    $0x8,%esp
  outb(COM1+4, 0);
8010651f:	6a 00                	push   $0x0
80106521:	68 fc 03 00 00       	push   $0x3fc
80106526:	e8 7f ff ff ff       	call   801064aa <outb>
8010652b:	83 c4 08             	add    $0x8,%esp
  outb(COM1+1, 0x01);    // Enable receive interrupts.
8010652e:	6a 01                	push   $0x1
80106530:	68 f9 03 00 00       	push   $0x3f9
80106535:	e8 70 ff ff ff       	call   801064aa <outb>
8010653a:	83 c4 08             	add    $0x8,%esp

  // If status is 0xFF, no serial port.
  if(inb(COM1+5) == 0xFF)
8010653d:	68 fd 03 00 00       	push   $0x3fd
80106542:	e8 46 ff ff ff       	call   8010648d <inb>
80106547:	83 c4 04             	add    $0x4,%esp
8010654a:	3c ff                	cmp    $0xff,%al
8010654c:	74 61                	je     801065af <uartinit+0xe4>
    return;
  uart = 1;
8010654e:	c7 05 78 6b 19 80 01 	movl   $0x1,0x80196b78
80106555:	00 00 00 

  // Acknowledge pre-existing interrupt conditions;
  // enable interrupts.
  inb(COM1+2);
80106558:	68 fa 03 00 00       	push   $0x3fa
8010655d:	e8 2b ff ff ff       	call   8010648d <inb>
80106562:	83 c4 04             	add    $0x4,%esp
  inb(COM1+0);
80106565:	68 f8 03 00 00       	push   $0x3f8
8010656a:	e8 1e ff ff ff       	call   8010648d <inb>
8010656f:	83 c4 04             	add    $0x4,%esp
  ioapicenable(IRQ_COM1, 0);
80106572:	83 ec 08             	sub    $0x8,%esp
80106575:	6a 00                	push   $0x0
80106577:	6a 04                	push   $0x4
80106579:	e8 b0 c0 ff ff       	call   8010262e <ioapicenable>
8010657e:	83 c4 10             	add    $0x10,%esp

  // Announce that we're here.
  for(p="xv6...\n"; *p; p++)
80106581:	c7 45 f4 40 a8 10 80 	movl   $0x8010a840,-0xc(%ebp)
80106588:	eb 19                	jmp    801065a3 <uartinit+0xd8>
    uartputc(*p);
8010658a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010658d:	0f b6 00             	movzbl (%eax),%eax
80106590:	0f be c0             	movsbl %al,%eax
80106593:	83 ec 0c             	sub    $0xc,%esp
80106596:	50                   	push   %eax
80106597:	e8 16 00 00 00       	call   801065b2 <uartputc>
8010659c:	83 c4 10             	add    $0x10,%esp
  for(p="xv6...\n"; *p; p++)
8010659f:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
801065a3:	8b 45 f4             	mov    -0xc(%ebp),%eax
801065a6:	0f b6 00             	movzbl (%eax),%eax
801065a9:	84 c0                	test   %al,%al
801065ab:	75 dd                	jne    8010658a <uartinit+0xbf>
801065ad:	eb 01                	jmp    801065b0 <uartinit+0xe5>
    return;
801065af:	90                   	nop
}
801065b0:	c9                   	leave  
801065b1:	c3                   	ret    

801065b2 <uartputc>:

void
uartputc(int c)
{
801065b2:	55                   	push   %ebp
801065b3:	89 e5                	mov    %esp,%ebp
801065b5:	83 ec 18             	sub    $0x18,%esp
  int i;

  if(!uart)
801065b8:	a1 78 6b 19 80       	mov    0x80196b78,%eax
801065bd:	85 c0                	test   %eax,%eax
801065bf:	74 53                	je     80106614 <uartputc+0x62>
    return;
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
801065c1:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
801065c8:	eb 11                	jmp    801065db <uartputc+0x29>
    microdelay(10);
801065ca:	83 ec 0c             	sub    $0xc,%esp
801065cd:	6a 0a                	push   $0xa
801065cf:	e8 63 c5 ff ff       	call   80102b37 <microdelay>
801065d4:	83 c4 10             	add    $0x10,%esp
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
801065d7:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
801065db:	83 7d f4 7f          	cmpl   $0x7f,-0xc(%ebp)
801065df:	7f 1a                	jg     801065fb <uartputc+0x49>
801065e1:	83 ec 0c             	sub    $0xc,%esp
801065e4:	68 fd 03 00 00       	push   $0x3fd
801065e9:	e8 9f fe ff ff       	call   8010648d <inb>
801065ee:	83 c4 10             	add    $0x10,%esp
801065f1:	0f b6 c0             	movzbl %al,%eax
801065f4:	83 e0 20             	and    $0x20,%eax
801065f7:	85 c0                	test   %eax,%eax
801065f9:	74 cf                	je     801065ca <uartputc+0x18>
  outb(COM1+0, c);
801065fb:	8b 45 08             	mov    0x8(%ebp),%eax
801065fe:	0f b6 c0             	movzbl %al,%eax
80106601:	83 ec 08             	sub    $0x8,%esp
80106604:	50                   	push   %eax
80106605:	68 f8 03 00 00       	push   $0x3f8
8010660a:	e8 9b fe ff ff       	call   801064aa <outb>
8010660f:	83 c4 10             	add    $0x10,%esp
80106612:	eb 01                	jmp    80106615 <uartputc+0x63>
    return;
80106614:	90                   	nop
}
80106615:	c9                   	leave  
80106616:	c3                   	ret    

80106617 <uartgetc>:

static int
uartgetc(void)
{
80106617:	55                   	push   %ebp
80106618:	89 e5                	mov    %esp,%ebp
  if(!uart)
8010661a:	a1 78 6b 19 80       	mov    0x80196b78,%eax
8010661f:	85 c0                	test   %eax,%eax
80106621:	75 07                	jne    8010662a <uartgetc+0x13>
    return -1;
80106623:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106628:	eb 2e                	jmp    80106658 <uartgetc+0x41>
  if(!(inb(COM1+5) & 0x01))
8010662a:	68 fd 03 00 00       	push   $0x3fd
8010662f:	e8 59 fe ff ff       	call   8010648d <inb>
80106634:	83 c4 04             	add    $0x4,%esp
80106637:	0f b6 c0             	movzbl %al,%eax
8010663a:	83 e0 01             	and    $0x1,%eax
8010663d:	85 c0                	test   %eax,%eax
8010663f:	75 07                	jne    80106648 <uartgetc+0x31>
    return -1;
80106641:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106646:	eb 10                	jmp    80106658 <uartgetc+0x41>
  return inb(COM1+0);
80106648:	68 f8 03 00 00       	push   $0x3f8
8010664d:	e8 3b fe ff ff       	call   8010648d <inb>
80106652:	83 c4 04             	add    $0x4,%esp
80106655:	0f b6 c0             	movzbl %al,%eax
}
80106658:	c9                   	leave  
80106659:	c3                   	ret    

8010665a <uartintr>:

void
uartintr(void)
{
8010665a:	55                   	push   %ebp
8010665b:	89 e5                	mov    %esp,%ebp
8010665d:	83 ec 08             	sub    $0x8,%esp
  consoleintr(uartgetc);
80106660:	83 ec 0c             	sub    $0xc,%esp
80106663:	68 17 66 10 80       	push   $0x80106617
80106668:	e8 69 a1 ff ff       	call   801007d6 <consoleintr>
8010666d:	83 c4 10             	add    $0x10,%esp
}
80106670:	90                   	nop
80106671:	c9                   	leave  
80106672:	c3                   	ret    

80106673 <vector0>:
80106673:	6a 00                	push   $0x0
80106675:	6a 00                	push   $0x0
80106677:	e9 c2 f9 ff ff       	jmp    8010603e <alltraps>

8010667c <vector1>:
8010667c:	6a 00                	push   $0x0
8010667e:	6a 01                	push   $0x1
80106680:	e9 b9 f9 ff ff       	jmp    8010603e <alltraps>

80106685 <vector2>:
80106685:	6a 00                	push   $0x0
80106687:	6a 02                	push   $0x2
80106689:	e9 b0 f9 ff ff       	jmp    8010603e <alltraps>

8010668e <vector3>:
8010668e:	6a 00                	push   $0x0
80106690:	6a 03                	push   $0x3
80106692:	e9 a7 f9 ff ff       	jmp    8010603e <alltraps>

80106697 <vector4>:
80106697:	6a 00                	push   $0x0
80106699:	6a 04                	push   $0x4
8010669b:	e9 9e f9 ff ff       	jmp    8010603e <alltraps>

801066a0 <vector5>:
801066a0:	6a 00                	push   $0x0
801066a2:	6a 05                	push   $0x5
801066a4:	e9 95 f9 ff ff       	jmp    8010603e <alltraps>

801066a9 <vector6>:
801066a9:	6a 00                	push   $0x0
801066ab:	6a 06                	push   $0x6
801066ad:	e9 8c f9 ff ff       	jmp    8010603e <alltraps>

801066b2 <vector7>:
801066b2:	6a 00                	push   $0x0
801066b4:	6a 07                	push   $0x7
801066b6:	e9 83 f9 ff ff       	jmp    8010603e <alltraps>

801066bb <vector8>:
801066bb:	6a 08                	push   $0x8
801066bd:	e9 7c f9 ff ff       	jmp    8010603e <alltraps>

801066c2 <vector9>:
801066c2:	6a 00                	push   $0x0
801066c4:	6a 09                	push   $0x9
801066c6:	e9 73 f9 ff ff       	jmp    8010603e <alltraps>

801066cb <vector10>:
801066cb:	6a 0a                	push   $0xa
801066cd:	e9 6c f9 ff ff       	jmp    8010603e <alltraps>

801066d2 <vector11>:
801066d2:	6a 0b                	push   $0xb
801066d4:	e9 65 f9 ff ff       	jmp    8010603e <alltraps>

801066d9 <vector12>:
801066d9:	6a 0c                	push   $0xc
801066db:	e9 5e f9 ff ff       	jmp    8010603e <alltraps>

801066e0 <vector13>:
801066e0:	6a 0d                	push   $0xd
801066e2:	e9 57 f9 ff ff       	jmp    8010603e <alltraps>

801066e7 <vector14>:
801066e7:	6a 0e                	push   $0xe
801066e9:	e9 50 f9 ff ff       	jmp    8010603e <alltraps>

801066ee <vector15>:
801066ee:	6a 00                	push   $0x0
801066f0:	6a 0f                	push   $0xf
801066f2:	e9 47 f9 ff ff       	jmp    8010603e <alltraps>

801066f7 <vector16>:
801066f7:	6a 00                	push   $0x0
801066f9:	6a 10                	push   $0x10
801066fb:	e9 3e f9 ff ff       	jmp    8010603e <alltraps>

80106700 <vector17>:
80106700:	6a 11                	push   $0x11
80106702:	e9 37 f9 ff ff       	jmp    8010603e <alltraps>

80106707 <vector18>:
80106707:	6a 00                	push   $0x0
80106709:	6a 12                	push   $0x12
8010670b:	e9 2e f9 ff ff       	jmp    8010603e <alltraps>

80106710 <vector19>:
80106710:	6a 00                	push   $0x0
80106712:	6a 13                	push   $0x13
80106714:	e9 25 f9 ff ff       	jmp    8010603e <alltraps>

80106719 <vector20>:
80106719:	6a 00                	push   $0x0
8010671b:	6a 14                	push   $0x14
8010671d:	e9 1c f9 ff ff       	jmp    8010603e <alltraps>

80106722 <vector21>:
80106722:	6a 00                	push   $0x0
80106724:	6a 15                	push   $0x15
80106726:	e9 13 f9 ff ff       	jmp    8010603e <alltraps>

8010672b <vector22>:
8010672b:	6a 00                	push   $0x0
8010672d:	6a 16                	push   $0x16
8010672f:	e9 0a f9 ff ff       	jmp    8010603e <alltraps>

80106734 <vector23>:
80106734:	6a 00                	push   $0x0
80106736:	6a 17                	push   $0x17
80106738:	e9 01 f9 ff ff       	jmp    8010603e <alltraps>

8010673d <vector24>:
8010673d:	6a 00                	push   $0x0
8010673f:	6a 18                	push   $0x18
80106741:	e9 f8 f8 ff ff       	jmp    8010603e <alltraps>

80106746 <vector25>:
80106746:	6a 00                	push   $0x0
80106748:	6a 19                	push   $0x19
8010674a:	e9 ef f8 ff ff       	jmp    8010603e <alltraps>

8010674f <vector26>:
8010674f:	6a 00                	push   $0x0
80106751:	6a 1a                	push   $0x1a
80106753:	e9 e6 f8 ff ff       	jmp    8010603e <alltraps>

80106758 <vector27>:
80106758:	6a 00                	push   $0x0
8010675a:	6a 1b                	push   $0x1b
8010675c:	e9 dd f8 ff ff       	jmp    8010603e <alltraps>

80106761 <vector28>:
80106761:	6a 00                	push   $0x0
80106763:	6a 1c                	push   $0x1c
80106765:	e9 d4 f8 ff ff       	jmp    8010603e <alltraps>

8010676a <vector29>:
8010676a:	6a 00                	push   $0x0
8010676c:	6a 1d                	push   $0x1d
8010676e:	e9 cb f8 ff ff       	jmp    8010603e <alltraps>

80106773 <vector30>:
80106773:	6a 00                	push   $0x0
80106775:	6a 1e                	push   $0x1e
80106777:	e9 c2 f8 ff ff       	jmp    8010603e <alltraps>

8010677c <vector31>:
8010677c:	6a 00                	push   $0x0
8010677e:	6a 1f                	push   $0x1f
80106780:	e9 b9 f8 ff ff       	jmp    8010603e <alltraps>

80106785 <vector32>:
80106785:	6a 00                	push   $0x0
80106787:	6a 20                	push   $0x20
80106789:	e9 b0 f8 ff ff       	jmp    8010603e <alltraps>

8010678e <vector33>:
8010678e:	6a 00                	push   $0x0
80106790:	6a 21                	push   $0x21
80106792:	e9 a7 f8 ff ff       	jmp    8010603e <alltraps>

80106797 <vector34>:
80106797:	6a 00                	push   $0x0
80106799:	6a 22                	push   $0x22
8010679b:	e9 9e f8 ff ff       	jmp    8010603e <alltraps>

801067a0 <vector35>:
801067a0:	6a 00                	push   $0x0
801067a2:	6a 23                	push   $0x23
801067a4:	e9 95 f8 ff ff       	jmp    8010603e <alltraps>

801067a9 <vector36>:
801067a9:	6a 00                	push   $0x0
801067ab:	6a 24                	push   $0x24
801067ad:	e9 8c f8 ff ff       	jmp    8010603e <alltraps>

801067b2 <vector37>:
801067b2:	6a 00                	push   $0x0
801067b4:	6a 25                	push   $0x25
801067b6:	e9 83 f8 ff ff       	jmp    8010603e <alltraps>

801067bb <vector38>:
801067bb:	6a 00                	push   $0x0
801067bd:	6a 26                	push   $0x26
801067bf:	e9 7a f8 ff ff       	jmp    8010603e <alltraps>

801067c4 <vector39>:
801067c4:	6a 00                	push   $0x0
801067c6:	6a 27                	push   $0x27
801067c8:	e9 71 f8 ff ff       	jmp    8010603e <alltraps>

801067cd <vector40>:
801067cd:	6a 00                	push   $0x0
801067cf:	6a 28                	push   $0x28
801067d1:	e9 68 f8 ff ff       	jmp    8010603e <alltraps>

801067d6 <vector41>:
801067d6:	6a 00                	push   $0x0
801067d8:	6a 29                	push   $0x29
801067da:	e9 5f f8 ff ff       	jmp    8010603e <alltraps>

801067df <vector42>:
801067df:	6a 00                	push   $0x0
801067e1:	6a 2a                	push   $0x2a
801067e3:	e9 56 f8 ff ff       	jmp    8010603e <alltraps>

801067e8 <vector43>:
801067e8:	6a 00                	push   $0x0
801067ea:	6a 2b                	push   $0x2b
801067ec:	e9 4d f8 ff ff       	jmp    8010603e <alltraps>

801067f1 <vector44>:
801067f1:	6a 00                	push   $0x0
801067f3:	6a 2c                	push   $0x2c
801067f5:	e9 44 f8 ff ff       	jmp    8010603e <alltraps>

801067fa <vector45>:
801067fa:	6a 00                	push   $0x0
801067fc:	6a 2d                	push   $0x2d
801067fe:	e9 3b f8 ff ff       	jmp    8010603e <alltraps>

80106803 <vector46>:
80106803:	6a 00                	push   $0x0
80106805:	6a 2e                	push   $0x2e
80106807:	e9 32 f8 ff ff       	jmp    8010603e <alltraps>

8010680c <vector47>:
8010680c:	6a 00                	push   $0x0
8010680e:	6a 2f                	push   $0x2f
80106810:	e9 29 f8 ff ff       	jmp    8010603e <alltraps>

80106815 <vector48>:
80106815:	6a 00                	push   $0x0
80106817:	6a 30                	push   $0x30
80106819:	e9 20 f8 ff ff       	jmp    8010603e <alltraps>

8010681e <vector49>:
8010681e:	6a 00                	push   $0x0
80106820:	6a 31                	push   $0x31
80106822:	e9 17 f8 ff ff       	jmp    8010603e <alltraps>

80106827 <vector50>:
80106827:	6a 00                	push   $0x0
80106829:	6a 32                	push   $0x32
8010682b:	e9 0e f8 ff ff       	jmp    8010603e <alltraps>

80106830 <vector51>:
80106830:	6a 00                	push   $0x0
80106832:	6a 33                	push   $0x33
80106834:	e9 05 f8 ff ff       	jmp    8010603e <alltraps>

80106839 <vector52>:
80106839:	6a 00                	push   $0x0
8010683b:	6a 34                	push   $0x34
8010683d:	e9 fc f7 ff ff       	jmp    8010603e <alltraps>

80106842 <vector53>:
80106842:	6a 00                	push   $0x0
80106844:	6a 35                	push   $0x35
80106846:	e9 f3 f7 ff ff       	jmp    8010603e <alltraps>

8010684b <vector54>:
8010684b:	6a 00                	push   $0x0
8010684d:	6a 36                	push   $0x36
8010684f:	e9 ea f7 ff ff       	jmp    8010603e <alltraps>

80106854 <vector55>:
80106854:	6a 00                	push   $0x0
80106856:	6a 37                	push   $0x37
80106858:	e9 e1 f7 ff ff       	jmp    8010603e <alltraps>

8010685d <vector56>:
8010685d:	6a 00                	push   $0x0
8010685f:	6a 38                	push   $0x38
80106861:	e9 d8 f7 ff ff       	jmp    8010603e <alltraps>

80106866 <vector57>:
80106866:	6a 00                	push   $0x0
80106868:	6a 39                	push   $0x39
8010686a:	e9 cf f7 ff ff       	jmp    8010603e <alltraps>

8010686f <vector58>:
8010686f:	6a 00                	push   $0x0
80106871:	6a 3a                	push   $0x3a
80106873:	e9 c6 f7 ff ff       	jmp    8010603e <alltraps>

80106878 <vector59>:
80106878:	6a 00                	push   $0x0
8010687a:	6a 3b                	push   $0x3b
8010687c:	e9 bd f7 ff ff       	jmp    8010603e <alltraps>

80106881 <vector60>:
80106881:	6a 00                	push   $0x0
80106883:	6a 3c                	push   $0x3c
80106885:	e9 b4 f7 ff ff       	jmp    8010603e <alltraps>

8010688a <vector61>:
8010688a:	6a 00                	push   $0x0
8010688c:	6a 3d                	push   $0x3d
8010688e:	e9 ab f7 ff ff       	jmp    8010603e <alltraps>

80106893 <vector62>:
80106893:	6a 00                	push   $0x0
80106895:	6a 3e                	push   $0x3e
80106897:	e9 a2 f7 ff ff       	jmp    8010603e <alltraps>

8010689c <vector63>:
8010689c:	6a 00                	push   $0x0
8010689e:	6a 3f                	push   $0x3f
801068a0:	e9 99 f7 ff ff       	jmp    8010603e <alltraps>

801068a5 <vector64>:
801068a5:	6a 00                	push   $0x0
801068a7:	6a 40                	push   $0x40
801068a9:	e9 90 f7 ff ff       	jmp    8010603e <alltraps>

801068ae <vector65>:
801068ae:	6a 00                	push   $0x0
801068b0:	6a 41                	push   $0x41
801068b2:	e9 87 f7 ff ff       	jmp    8010603e <alltraps>

801068b7 <vector66>:
801068b7:	6a 00                	push   $0x0
801068b9:	6a 42                	push   $0x42
801068bb:	e9 7e f7 ff ff       	jmp    8010603e <alltraps>

801068c0 <vector67>:
801068c0:	6a 00                	push   $0x0
801068c2:	6a 43                	push   $0x43
801068c4:	e9 75 f7 ff ff       	jmp    8010603e <alltraps>

801068c9 <vector68>:
801068c9:	6a 00                	push   $0x0
801068cb:	6a 44                	push   $0x44
801068cd:	e9 6c f7 ff ff       	jmp    8010603e <alltraps>

801068d2 <vector69>:
801068d2:	6a 00                	push   $0x0
801068d4:	6a 45                	push   $0x45
801068d6:	e9 63 f7 ff ff       	jmp    8010603e <alltraps>

801068db <vector70>:
801068db:	6a 00                	push   $0x0
801068dd:	6a 46                	push   $0x46
801068df:	e9 5a f7 ff ff       	jmp    8010603e <alltraps>

801068e4 <vector71>:
801068e4:	6a 00                	push   $0x0
801068e6:	6a 47                	push   $0x47
801068e8:	e9 51 f7 ff ff       	jmp    8010603e <alltraps>

801068ed <vector72>:
801068ed:	6a 00                	push   $0x0
801068ef:	6a 48                	push   $0x48
801068f1:	e9 48 f7 ff ff       	jmp    8010603e <alltraps>

801068f6 <vector73>:
801068f6:	6a 00                	push   $0x0
801068f8:	6a 49                	push   $0x49
801068fa:	e9 3f f7 ff ff       	jmp    8010603e <alltraps>

801068ff <vector74>:
801068ff:	6a 00                	push   $0x0
80106901:	6a 4a                	push   $0x4a
80106903:	e9 36 f7 ff ff       	jmp    8010603e <alltraps>

80106908 <vector75>:
80106908:	6a 00                	push   $0x0
8010690a:	6a 4b                	push   $0x4b
8010690c:	e9 2d f7 ff ff       	jmp    8010603e <alltraps>

80106911 <vector76>:
80106911:	6a 00                	push   $0x0
80106913:	6a 4c                	push   $0x4c
80106915:	e9 24 f7 ff ff       	jmp    8010603e <alltraps>

8010691a <vector77>:
8010691a:	6a 00                	push   $0x0
8010691c:	6a 4d                	push   $0x4d
8010691e:	e9 1b f7 ff ff       	jmp    8010603e <alltraps>

80106923 <vector78>:
80106923:	6a 00                	push   $0x0
80106925:	6a 4e                	push   $0x4e
80106927:	e9 12 f7 ff ff       	jmp    8010603e <alltraps>

8010692c <vector79>:
8010692c:	6a 00                	push   $0x0
8010692e:	6a 4f                	push   $0x4f
80106930:	e9 09 f7 ff ff       	jmp    8010603e <alltraps>

80106935 <vector80>:
80106935:	6a 00                	push   $0x0
80106937:	6a 50                	push   $0x50
80106939:	e9 00 f7 ff ff       	jmp    8010603e <alltraps>

8010693e <vector81>:
8010693e:	6a 00                	push   $0x0
80106940:	6a 51                	push   $0x51
80106942:	e9 f7 f6 ff ff       	jmp    8010603e <alltraps>

80106947 <vector82>:
80106947:	6a 00                	push   $0x0
80106949:	6a 52                	push   $0x52
8010694b:	e9 ee f6 ff ff       	jmp    8010603e <alltraps>

80106950 <vector83>:
80106950:	6a 00                	push   $0x0
80106952:	6a 53                	push   $0x53
80106954:	e9 e5 f6 ff ff       	jmp    8010603e <alltraps>

80106959 <vector84>:
80106959:	6a 00                	push   $0x0
8010695b:	6a 54                	push   $0x54
8010695d:	e9 dc f6 ff ff       	jmp    8010603e <alltraps>

80106962 <vector85>:
80106962:	6a 00                	push   $0x0
80106964:	6a 55                	push   $0x55
80106966:	e9 d3 f6 ff ff       	jmp    8010603e <alltraps>

8010696b <vector86>:
8010696b:	6a 00                	push   $0x0
8010696d:	6a 56                	push   $0x56
8010696f:	e9 ca f6 ff ff       	jmp    8010603e <alltraps>

80106974 <vector87>:
80106974:	6a 00                	push   $0x0
80106976:	6a 57                	push   $0x57
80106978:	e9 c1 f6 ff ff       	jmp    8010603e <alltraps>

8010697d <vector88>:
8010697d:	6a 00                	push   $0x0
8010697f:	6a 58                	push   $0x58
80106981:	e9 b8 f6 ff ff       	jmp    8010603e <alltraps>

80106986 <vector89>:
80106986:	6a 00                	push   $0x0
80106988:	6a 59                	push   $0x59
8010698a:	e9 af f6 ff ff       	jmp    8010603e <alltraps>

8010698f <vector90>:
8010698f:	6a 00                	push   $0x0
80106991:	6a 5a                	push   $0x5a
80106993:	e9 a6 f6 ff ff       	jmp    8010603e <alltraps>

80106998 <vector91>:
80106998:	6a 00                	push   $0x0
8010699a:	6a 5b                	push   $0x5b
8010699c:	e9 9d f6 ff ff       	jmp    8010603e <alltraps>

801069a1 <vector92>:
801069a1:	6a 00                	push   $0x0
801069a3:	6a 5c                	push   $0x5c
801069a5:	e9 94 f6 ff ff       	jmp    8010603e <alltraps>

801069aa <vector93>:
801069aa:	6a 00                	push   $0x0
801069ac:	6a 5d                	push   $0x5d
801069ae:	e9 8b f6 ff ff       	jmp    8010603e <alltraps>

801069b3 <vector94>:
801069b3:	6a 00                	push   $0x0
801069b5:	6a 5e                	push   $0x5e
801069b7:	e9 82 f6 ff ff       	jmp    8010603e <alltraps>

801069bc <vector95>:
801069bc:	6a 00                	push   $0x0
801069be:	6a 5f                	push   $0x5f
801069c0:	e9 79 f6 ff ff       	jmp    8010603e <alltraps>

801069c5 <vector96>:
801069c5:	6a 00                	push   $0x0
801069c7:	6a 60                	push   $0x60
801069c9:	e9 70 f6 ff ff       	jmp    8010603e <alltraps>

801069ce <vector97>:
801069ce:	6a 00                	push   $0x0
801069d0:	6a 61                	push   $0x61
801069d2:	e9 67 f6 ff ff       	jmp    8010603e <alltraps>

801069d7 <vector98>:
801069d7:	6a 00                	push   $0x0
801069d9:	6a 62                	push   $0x62
801069db:	e9 5e f6 ff ff       	jmp    8010603e <alltraps>

801069e0 <vector99>:
801069e0:	6a 00                	push   $0x0
801069e2:	6a 63                	push   $0x63
801069e4:	e9 55 f6 ff ff       	jmp    8010603e <alltraps>

801069e9 <vector100>:
801069e9:	6a 00                	push   $0x0
801069eb:	6a 64                	push   $0x64
801069ed:	e9 4c f6 ff ff       	jmp    8010603e <alltraps>

801069f2 <vector101>:
801069f2:	6a 00                	push   $0x0
801069f4:	6a 65                	push   $0x65
801069f6:	e9 43 f6 ff ff       	jmp    8010603e <alltraps>

801069fb <vector102>:
801069fb:	6a 00                	push   $0x0
801069fd:	6a 66                	push   $0x66
801069ff:	e9 3a f6 ff ff       	jmp    8010603e <alltraps>

80106a04 <vector103>:
80106a04:	6a 00                	push   $0x0
80106a06:	6a 67                	push   $0x67
80106a08:	e9 31 f6 ff ff       	jmp    8010603e <alltraps>

80106a0d <vector104>:
80106a0d:	6a 00                	push   $0x0
80106a0f:	6a 68                	push   $0x68
80106a11:	e9 28 f6 ff ff       	jmp    8010603e <alltraps>

80106a16 <vector105>:
80106a16:	6a 00                	push   $0x0
80106a18:	6a 69                	push   $0x69
80106a1a:	e9 1f f6 ff ff       	jmp    8010603e <alltraps>

80106a1f <vector106>:
80106a1f:	6a 00                	push   $0x0
80106a21:	6a 6a                	push   $0x6a
80106a23:	e9 16 f6 ff ff       	jmp    8010603e <alltraps>

80106a28 <vector107>:
80106a28:	6a 00                	push   $0x0
80106a2a:	6a 6b                	push   $0x6b
80106a2c:	e9 0d f6 ff ff       	jmp    8010603e <alltraps>

80106a31 <vector108>:
80106a31:	6a 00                	push   $0x0
80106a33:	6a 6c                	push   $0x6c
80106a35:	e9 04 f6 ff ff       	jmp    8010603e <alltraps>

80106a3a <vector109>:
80106a3a:	6a 00                	push   $0x0
80106a3c:	6a 6d                	push   $0x6d
80106a3e:	e9 fb f5 ff ff       	jmp    8010603e <alltraps>

80106a43 <vector110>:
80106a43:	6a 00                	push   $0x0
80106a45:	6a 6e                	push   $0x6e
80106a47:	e9 f2 f5 ff ff       	jmp    8010603e <alltraps>

80106a4c <vector111>:
80106a4c:	6a 00                	push   $0x0
80106a4e:	6a 6f                	push   $0x6f
80106a50:	e9 e9 f5 ff ff       	jmp    8010603e <alltraps>

80106a55 <vector112>:
80106a55:	6a 00                	push   $0x0
80106a57:	6a 70                	push   $0x70
80106a59:	e9 e0 f5 ff ff       	jmp    8010603e <alltraps>

80106a5e <vector113>:
80106a5e:	6a 00                	push   $0x0
80106a60:	6a 71                	push   $0x71
80106a62:	e9 d7 f5 ff ff       	jmp    8010603e <alltraps>

80106a67 <vector114>:
80106a67:	6a 00                	push   $0x0
80106a69:	6a 72                	push   $0x72
80106a6b:	e9 ce f5 ff ff       	jmp    8010603e <alltraps>

80106a70 <vector115>:
80106a70:	6a 00                	push   $0x0
80106a72:	6a 73                	push   $0x73
80106a74:	e9 c5 f5 ff ff       	jmp    8010603e <alltraps>

80106a79 <vector116>:
80106a79:	6a 00                	push   $0x0
80106a7b:	6a 74                	push   $0x74
80106a7d:	e9 bc f5 ff ff       	jmp    8010603e <alltraps>

80106a82 <vector117>:
80106a82:	6a 00                	push   $0x0
80106a84:	6a 75                	push   $0x75
80106a86:	e9 b3 f5 ff ff       	jmp    8010603e <alltraps>

80106a8b <vector118>:
80106a8b:	6a 00                	push   $0x0
80106a8d:	6a 76                	push   $0x76
80106a8f:	e9 aa f5 ff ff       	jmp    8010603e <alltraps>

80106a94 <vector119>:
80106a94:	6a 00                	push   $0x0
80106a96:	6a 77                	push   $0x77
80106a98:	e9 a1 f5 ff ff       	jmp    8010603e <alltraps>

80106a9d <vector120>:
80106a9d:	6a 00                	push   $0x0
80106a9f:	6a 78                	push   $0x78
80106aa1:	e9 98 f5 ff ff       	jmp    8010603e <alltraps>

80106aa6 <vector121>:
80106aa6:	6a 00                	push   $0x0
80106aa8:	6a 79                	push   $0x79
80106aaa:	e9 8f f5 ff ff       	jmp    8010603e <alltraps>

80106aaf <vector122>:
80106aaf:	6a 00                	push   $0x0
80106ab1:	6a 7a                	push   $0x7a
80106ab3:	e9 86 f5 ff ff       	jmp    8010603e <alltraps>

80106ab8 <vector123>:
80106ab8:	6a 00                	push   $0x0
80106aba:	6a 7b                	push   $0x7b
80106abc:	e9 7d f5 ff ff       	jmp    8010603e <alltraps>

80106ac1 <vector124>:
80106ac1:	6a 00                	push   $0x0
80106ac3:	6a 7c                	push   $0x7c
80106ac5:	e9 74 f5 ff ff       	jmp    8010603e <alltraps>

80106aca <vector125>:
80106aca:	6a 00                	push   $0x0
80106acc:	6a 7d                	push   $0x7d
80106ace:	e9 6b f5 ff ff       	jmp    8010603e <alltraps>

80106ad3 <vector126>:
80106ad3:	6a 00                	push   $0x0
80106ad5:	6a 7e                	push   $0x7e
80106ad7:	e9 62 f5 ff ff       	jmp    8010603e <alltraps>

80106adc <vector127>:
80106adc:	6a 00                	push   $0x0
80106ade:	6a 7f                	push   $0x7f
80106ae0:	e9 59 f5 ff ff       	jmp    8010603e <alltraps>

80106ae5 <vector128>:
80106ae5:	6a 00                	push   $0x0
80106ae7:	68 80 00 00 00       	push   $0x80
80106aec:	e9 4d f5 ff ff       	jmp    8010603e <alltraps>

80106af1 <vector129>:
80106af1:	6a 00                	push   $0x0
80106af3:	68 81 00 00 00       	push   $0x81
80106af8:	e9 41 f5 ff ff       	jmp    8010603e <alltraps>

80106afd <vector130>:
80106afd:	6a 00                	push   $0x0
80106aff:	68 82 00 00 00       	push   $0x82
80106b04:	e9 35 f5 ff ff       	jmp    8010603e <alltraps>

80106b09 <vector131>:
80106b09:	6a 00                	push   $0x0
80106b0b:	68 83 00 00 00       	push   $0x83
80106b10:	e9 29 f5 ff ff       	jmp    8010603e <alltraps>

80106b15 <vector132>:
80106b15:	6a 00                	push   $0x0
80106b17:	68 84 00 00 00       	push   $0x84
80106b1c:	e9 1d f5 ff ff       	jmp    8010603e <alltraps>

80106b21 <vector133>:
80106b21:	6a 00                	push   $0x0
80106b23:	68 85 00 00 00       	push   $0x85
80106b28:	e9 11 f5 ff ff       	jmp    8010603e <alltraps>

80106b2d <vector134>:
80106b2d:	6a 00                	push   $0x0
80106b2f:	68 86 00 00 00       	push   $0x86
80106b34:	e9 05 f5 ff ff       	jmp    8010603e <alltraps>

80106b39 <vector135>:
80106b39:	6a 00                	push   $0x0
80106b3b:	68 87 00 00 00       	push   $0x87
80106b40:	e9 f9 f4 ff ff       	jmp    8010603e <alltraps>

80106b45 <vector136>:
80106b45:	6a 00                	push   $0x0
80106b47:	68 88 00 00 00       	push   $0x88
80106b4c:	e9 ed f4 ff ff       	jmp    8010603e <alltraps>

80106b51 <vector137>:
80106b51:	6a 00                	push   $0x0
80106b53:	68 89 00 00 00       	push   $0x89
80106b58:	e9 e1 f4 ff ff       	jmp    8010603e <alltraps>

80106b5d <vector138>:
80106b5d:	6a 00                	push   $0x0
80106b5f:	68 8a 00 00 00       	push   $0x8a
80106b64:	e9 d5 f4 ff ff       	jmp    8010603e <alltraps>

80106b69 <vector139>:
80106b69:	6a 00                	push   $0x0
80106b6b:	68 8b 00 00 00       	push   $0x8b
80106b70:	e9 c9 f4 ff ff       	jmp    8010603e <alltraps>

80106b75 <vector140>:
80106b75:	6a 00                	push   $0x0
80106b77:	68 8c 00 00 00       	push   $0x8c
80106b7c:	e9 bd f4 ff ff       	jmp    8010603e <alltraps>

80106b81 <vector141>:
80106b81:	6a 00                	push   $0x0
80106b83:	68 8d 00 00 00       	push   $0x8d
80106b88:	e9 b1 f4 ff ff       	jmp    8010603e <alltraps>

80106b8d <vector142>:
80106b8d:	6a 00                	push   $0x0
80106b8f:	68 8e 00 00 00       	push   $0x8e
80106b94:	e9 a5 f4 ff ff       	jmp    8010603e <alltraps>

80106b99 <vector143>:
80106b99:	6a 00                	push   $0x0
80106b9b:	68 8f 00 00 00       	push   $0x8f
80106ba0:	e9 99 f4 ff ff       	jmp    8010603e <alltraps>

80106ba5 <vector144>:
80106ba5:	6a 00                	push   $0x0
80106ba7:	68 90 00 00 00       	push   $0x90
80106bac:	e9 8d f4 ff ff       	jmp    8010603e <alltraps>

80106bb1 <vector145>:
80106bb1:	6a 00                	push   $0x0
80106bb3:	68 91 00 00 00       	push   $0x91
80106bb8:	e9 81 f4 ff ff       	jmp    8010603e <alltraps>

80106bbd <vector146>:
80106bbd:	6a 00                	push   $0x0
80106bbf:	68 92 00 00 00       	push   $0x92
80106bc4:	e9 75 f4 ff ff       	jmp    8010603e <alltraps>

80106bc9 <vector147>:
80106bc9:	6a 00                	push   $0x0
80106bcb:	68 93 00 00 00       	push   $0x93
80106bd0:	e9 69 f4 ff ff       	jmp    8010603e <alltraps>

80106bd5 <vector148>:
80106bd5:	6a 00                	push   $0x0
80106bd7:	68 94 00 00 00       	push   $0x94
80106bdc:	e9 5d f4 ff ff       	jmp    8010603e <alltraps>

80106be1 <vector149>:
80106be1:	6a 00                	push   $0x0
80106be3:	68 95 00 00 00       	push   $0x95
80106be8:	e9 51 f4 ff ff       	jmp    8010603e <alltraps>

80106bed <vector150>:
80106bed:	6a 00                	push   $0x0
80106bef:	68 96 00 00 00       	push   $0x96
80106bf4:	e9 45 f4 ff ff       	jmp    8010603e <alltraps>

80106bf9 <vector151>:
80106bf9:	6a 00                	push   $0x0
80106bfb:	68 97 00 00 00       	push   $0x97
80106c00:	e9 39 f4 ff ff       	jmp    8010603e <alltraps>

80106c05 <vector152>:
80106c05:	6a 00                	push   $0x0
80106c07:	68 98 00 00 00       	push   $0x98
80106c0c:	e9 2d f4 ff ff       	jmp    8010603e <alltraps>

80106c11 <vector153>:
80106c11:	6a 00                	push   $0x0
80106c13:	68 99 00 00 00       	push   $0x99
80106c18:	e9 21 f4 ff ff       	jmp    8010603e <alltraps>

80106c1d <vector154>:
80106c1d:	6a 00                	push   $0x0
80106c1f:	68 9a 00 00 00       	push   $0x9a
80106c24:	e9 15 f4 ff ff       	jmp    8010603e <alltraps>

80106c29 <vector155>:
80106c29:	6a 00                	push   $0x0
80106c2b:	68 9b 00 00 00       	push   $0x9b
80106c30:	e9 09 f4 ff ff       	jmp    8010603e <alltraps>

80106c35 <vector156>:
80106c35:	6a 00                	push   $0x0
80106c37:	68 9c 00 00 00       	push   $0x9c
80106c3c:	e9 fd f3 ff ff       	jmp    8010603e <alltraps>

80106c41 <vector157>:
80106c41:	6a 00                	push   $0x0
80106c43:	68 9d 00 00 00       	push   $0x9d
80106c48:	e9 f1 f3 ff ff       	jmp    8010603e <alltraps>

80106c4d <vector158>:
80106c4d:	6a 00                	push   $0x0
80106c4f:	68 9e 00 00 00       	push   $0x9e
80106c54:	e9 e5 f3 ff ff       	jmp    8010603e <alltraps>

80106c59 <vector159>:
80106c59:	6a 00                	push   $0x0
80106c5b:	68 9f 00 00 00       	push   $0x9f
80106c60:	e9 d9 f3 ff ff       	jmp    8010603e <alltraps>

80106c65 <vector160>:
80106c65:	6a 00                	push   $0x0
80106c67:	68 a0 00 00 00       	push   $0xa0
80106c6c:	e9 cd f3 ff ff       	jmp    8010603e <alltraps>

80106c71 <vector161>:
80106c71:	6a 00                	push   $0x0
80106c73:	68 a1 00 00 00       	push   $0xa1
80106c78:	e9 c1 f3 ff ff       	jmp    8010603e <alltraps>

80106c7d <vector162>:
80106c7d:	6a 00                	push   $0x0
80106c7f:	68 a2 00 00 00       	push   $0xa2
80106c84:	e9 b5 f3 ff ff       	jmp    8010603e <alltraps>

80106c89 <vector163>:
80106c89:	6a 00                	push   $0x0
80106c8b:	68 a3 00 00 00       	push   $0xa3
80106c90:	e9 a9 f3 ff ff       	jmp    8010603e <alltraps>

80106c95 <vector164>:
80106c95:	6a 00                	push   $0x0
80106c97:	68 a4 00 00 00       	push   $0xa4
80106c9c:	e9 9d f3 ff ff       	jmp    8010603e <alltraps>

80106ca1 <vector165>:
80106ca1:	6a 00                	push   $0x0
80106ca3:	68 a5 00 00 00       	push   $0xa5
80106ca8:	e9 91 f3 ff ff       	jmp    8010603e <alltraps>

80106cad <vector166>:
80106cad:	6a 00                	push   $0x0
80106caf:	68 a6 00 00 00       	push   $0xa6
80106cb4:	e9 85 f3 ff ff       	jmp    8010603e <alltraps>

80106cb9 <vector167>:
80106cb9:	6a 00                	push   $0x0
80106cbb:	68 a7 00 00 00       	push   $0xa7
80106cc0:	e9 79 f3 ff ff       	jmp    8010603e <alltraps>

80106cc5 <vector168>:
80106cc5:	6a 00                	push   $0x0
80106cc7:	68 a8 00 00 00       	push   $0xa8
80106ccc:	e9 6d f3 ff ff       	jmp    8010603e <alltraps>

80106cd1 <vector169>:
80106cd1:	6a 00                	push   $0x0
80106cd3:	68 a9 00 00 00       	push   $0xa9
80106cd8:	e9 61 f3 ff ff       	jmp    8010603e <alltraps>

80106cdd <vector170>:
80106cdd:	6a 00                	push   $0x0
80106cdf:	68 aa 00 00 00       	push   $0xaa
80106ce4:	e9 55 f3 ff ff       	jmp    8010603e <alltraps>

80106ce9 <vector171>:
80106ce9:	6a 00                	push   $0x0
80106ceb:	68 ab 00 00 00       	push   $0xab
80106cf0:	e9 49 f3 ff ff       	jmp    8010603e <alltraps>

80106cf5 <vector172>:
80106cf5:	6a 00                	push   $0x0
80106cf7:	68 ac 00 00 00       	push   $0xac
80106cfc:	e9 3d f3 ff ff       	jmp    8010603e <alltraps>

80106d01 <vector173>:
80106d01:	6a 00                	push   $0x0
80106d03:	68 ad 00 00 00       	push   $0xad
80106d08:	e9 31 f3 ff ff       	jmp    8010603e <alltraps>

80106d0d <vector174>:
80106d0d:	6a 00                	push   $0x0
80106d0f:	68 ae 00 00 00       	push   $0xae
80106d14:	e9 25 f3 ff ff       	jmp    8010603e <alltraps>

80106d19 <vector175>:
80106d19:	6a 00                	push   $0x0
80106d1b:	68 af 00 00 00       	push   $0xaf
80106d20:	e9 19 f3 ff ff       	jmp    8010603e <alltraps>

80106d25 <vector176>:
80106d25:	6a 00                	push   $0x0
80106d27:	68 b0 00 00 00       	push   $0xb0
80106d2c:	e9 0d f3 ff ff       	jmp    8010603e <alltraps>

80106d31 <vector177>:
80106d31:	6a 00                	push   $0x0
80106d33:	68 b1 00 00 00       	push   $0xb1
80106d38:	e9 01 f3 ff ff       	jmp    8010603e <alltraps>

80106d3d <vector178>:
80106d3d:	6a 00                	push   $0x0
80106d3f:	68 b2 00 00 00       	push   $0xb2
80106d44:	e9 f5 f2 ff ff       	jmp    8010603e <alltraps>

80106d49 <vector179>:
80106d49:	6a 00                	push   $0x0
80106d4b:	68 b3 00 00 00       	push   $0xb3
80106d50:	e9 e9 f2 ff ff       	jmp    8010603e <alltraps>

80106d55 <vector180>:
80106d55:	6a 00                	push   $0x0
80106d57:	68 b4 00 00 00       	push   $0xb4
80106d5c:	e9 dd f2 ff ff       	jmp    8010603e <alltraps>

80106d61 <vector181>:
80106d61:	6a 00                	push   $0x0
80106d63:	68 b5 00 00 00       	push   $0xb5
80106d68:	e9 d1 f2 ff ff       	jmp    8010603e <alltraps>

80106d6d <vector182>:
80106d6d:	6a 00                	push   $0x0
80106d6f:	68 b6 00 00 00       	push   $0xb6
80106d74:	e9 c5 f2 ff ff       	jmp    8010603e <alltraps>

80106d79 <vector183>:
80106d79:	6a 00                	push   $0x0
80106d7b:	68 b7 00 00 00       	push   $0xb7
80106d80:	e9 b9 f2 ff ff       	jmp    8010603e <alltraps>

80106d85 <vector184>:
80106d85:	6a 00                	push   $0x0
80106d87:	68 b8 00 00 00       	push   $0xb8
80106d8c:	e9 ad f2 ff ff       	jmp    8010603e <alltraps>

80106d91 <vector185>:
80106d91:	6a 00                	push   $0x0
80106d93:	68 b9 00 00 00       	push   $0xb9
80106d98:	e9 a1 f2 ff ff       	jmp    8010603e <alltraps>

80106d9d <vector186>:
80106d9d:	6a 00                	push   $0x0
80106d9f:	68 ba 00 00 00       	push   $0xba
80106da4:	e9 95 f2 ff ff       	jmp    8010603e <alltraps>

80106da9 <vector187>:
80106da9:	6a 00                	push   $0x0
80106dab:	68 bb 00 00 00       	push   $0xbb
80106db0:	e9 89 f2 ff ff       	jmp    8010603e <alltraps>

80106db5 <vector188>:
80106db5:	6a 00                	push   $0x0
80106db7:	68 bc 00 00 00       	push   $0xbc
80106dbc:	e9 7d f2 ff ff       	jmp    8010603e <alltraps>

80106dc1 <vector189>:
80106dc1:	6a 00                	push   $0x0
80106dc3:	68 bd 00 00 00       	push   $0xbd
80106dc8:	e9 71 f2 ff ff       	jmp    8010603e <alltraps>

80106dcd <vector190>:
80106dcd:	6a 00                	push   $0x0
80106dcf:	68 be 00 00 00       	push   $0xbe
80106dd4:	e9 65 f2 ff ff       	jmp    8010603e <alltraps>

80106dd9 <vector191>:
80106dd9:	6a 00                	push   $0x0
80106ddb:	68 bf 00 00 00       	push   $0xbf
80106de0:	e9 59 f2 ff ff       	jmp    8010603e <alltraps>

80106de5 <vector192>:
80106de5:	6a 00                	push   $0x0
80106de7:	68 c0 00 00 00       	push   $0xc0
80106dec:	e9 4d f2 ff ff       	jmp    8010603e <alltraps>

80106df1 <vector193>:
80106df1:	6a 00                	push   $0x0
80106df3:	68 c1 00 00 00       	push   $0xc1
80106df8:	e9 41 f2 ff ff       	jmp    8010603e <alltraps>

80106dfd <vector194>:
80106dfd:	6a 00                	push   $0x0
80106dff:	68 c2 00 00 00       	push   $0xc2
80106e04:	e9 35 f2 ff ff       	jmp    8010603e <alltraps>

80106e09 <vector195>:
80106e09:	6a 00                	push   $0x0
80106e0b:	68 c3 00 00 00       	push   $0xc3
80106e10:	e9 29 f2 ff ff       	jmp    8010603e <alltraps>

80106e15 <vector196>:
80106e15:	6a 00                	push   $0x0
80106e17:	68 c4 00 00 00       	push   $0xc4
80106e1c:	e9 1d f2 ff ff       	jmp    8010603e <alltraps>

80106e21 <vector197>:
80106e21:	6a 00                	push   $0x0
80106e23:	68 c5 00 00 00       	push   $0xc5
80106e28:	e9 11 f2 ff ff       	jmp    8010603e <alltraps>

80106e2d <vector198>:
80106e2d:	6a 00                	push   $0x0
80106e2f:	68 c6 00 00 00       	push   $0xc6
80106e34:	e9 05 f2 ff ff       	jmp    8010603e <alltraps>

80106e39 <vector199>:
80106e39:	6a 00                	push   $0x0
80106e3b:	68 c7 00 00 00       	push   $0xc7
80106e40:	e9 f9 f1 ff ff       	jmp    8010603e <alltraps>

80106e45 <vector200>:
80106e45:	6a 00                	push   $0x0
80106e47:	68 c8 00 00 00       	push   $0xc8
80106e4c:	e9 ed f1 ff ff       	jmp    8010603e <alltraps>

80106e51 <vector201>:
80106e51:	6a 00                	push   $0x0
80106e53:	68 c9 00 00 00       	push   $0xc9
80106e58:	e9 e1 f1 ff ff       	jmp    8010603e <alltraps>

80106e5d <vector202>:
80106e5d:	6a 00                	push   $0x0
80106e5f:	68 ca 00 00 00       	push   $0xca
80106e64:	e9 d5 f1 ff ff       	jmp    8010603e <alltraps>

80106e69 <vector203>:
80106e69:	6a 00                	push   $0x0
80106e6b:	68 cb 00 00 00       	push   $0xcb
80106e70:	e9 c9 f1 ff ff       	jmp    8010603e <alltraps>

80106e75 <vector204>:
80106e75:	6a 00                	push   $0x0
80106e77:	68 cc 00 00 00       	push   $0xcc
80106e7c:	e9 bd f1 ff ff       	jmp    8010603e <alltraps>

80106e81 <vector205>:
80106e81:	6a 00                	push   $0x0
80106e83:	68 cd 00 00 00       	push   $0xcd
80106e88:	e9 b1 f1 ff ff       	jmp    8010603e <alltraps>

80106e8d <vector206>:
80106e8d:	6a 00                	push   $0x0
80106e8f:	68 ce 00 00 00       	push   $0xce
80106e94:	e9 a5 f1 ff ff       	jmp    8010603e <alltraps>

80106e99 <vector207>:
80106e99:	6a 00                	push   $0x0
80106e9b:	68 cf 00 00 00       	push   $0xcf
80106ea0:	e9 99 f1 ff ff       	jmp    8010603e <alltraps>

80106ea5 <vector208>:
80106ea5:	6a 00                	push   $0x0
80106ea7:	68 d0 00 00 00       	push   $0xd0
80106eac:	e9 8d f1 ff ff       	jmp    8010603e <alltraps>

80106eb1 <vector209>:
80106eb1:	6a 00                	push   $0x0
80106eb3:	68 d1 00 00 00       	push   $0xd1
80106eb8:	e9 81 f1 ff ff       	jmp    8010603e <alltraps>

80106ebd <vector210>:
80106ebd:	6a 00                	push   $0x0
80106ebf:	68 d2 00 00 00       	push   $0xd2
80106ec4:	e9 75 f1 ff ff       	jmp    8010603e <alltraps>

80106ec9 <vector211>:
80106ec9:	6a 00                	push   $0x0
80106ecb:	68 d3 00 00 00       	push   $0xd3
80106ed0:	e9 69 f1 ff ff       	jmp    8010603e <alltraps>

80106ed5 <vector212>:
80106ed5:	6a 00                	push   $0x0
80106ed7:	68 d4 00 00 00       	push   $0xd4
80106edc:	e9 5d f1 ff ff       	jmp    8010603e <alltraps>

80106ee1 <vector213>:
80106ee1:	6a 00                	push   $0x0
80106ee3:	68 d5 00 00 00       	push   $0xd5
80106ee8:	e9 51 f1 ff ff       	jmp    8010603e <alltraps>

80106eed <vector214>:
80106eed:	6a 00                	push   $0x0
80106eef:	68 d6 00 00 00       	push   $0xd6
80106ef4:	e9 45 f1 ff ff       	jmp    8010603e <alltraps>

80106ef9 <vector215>:
80106ef9:	6a 00                	push   $0x0
80106efb:	68 d7 00 00 00       	push   $0xd7
80106f00:	e9 39 f1 ff ff       	jmp    8010603e <alltraps>

80106f05 <vector216>:
80106f05:	6a 00                	push   $0x0
80106f07:	68 d8 00 00 00       	push   $0xd8
80106f0c:	e9 2d f1 ff ff       	jmp    8010603e <alltraps>

80106f11 <vector217>:
80106f11:	6a 00                	push   $0x0
80106f13:	68 d9 00 00 00       	push   $0xd9
80106f18:	e9 21 f1 ff ff       	jmp    8010603e <alltraps>

80106f1d <vector218>:
80106f1d:	6a 00                	push   $0x0
80106f1f:	68 da 00 00 00       	push   $0xda
80106f24:	e9 15 f1 ff ff       	jmp    8010603e <alltraps>

80106f29 <vector219>:
80106f29:	6a 00                	push   $0x0
80106f2b:	68 db 00 00 00       	push   $0xdb
80106f30:	e9 09 f1 ff ff       	jmp    8010603e <alltraps>

80106f35 <vector220>:
80106f35:	6a 00                	push   $0x0
80106f37:	68 dc 00 00 00       	push   $0xdc
80106f3c:	e9 fd f0 ff ff       	jmp    8010603e <alltraps>

80106f41 <vector221>:
80106f41:	6a 00                	push   $0x0
80106f43:	68 dd 00 00 00       	push   $0xdd
80106f48:	e9 f1 f0 ff ff       	jmp    8010603e <alltraps>

80106f4d <vector222>:
80106f4d:	6a 00                	push   $0x0
80106f4f:	68 de 00 00 00       	push   $0xde
80106f54:	e9 e5 f0 ff ff       	jmp    8010603e <alltraps>

80106f59 <vector223>:
80106f59:	6a 00                	push   $0x0
80106f5b:	68 df 00 00 00       	push   $0xdf
80106f60:	e9 d9 f0 ff ff       	jmp    8010603e <alltraps>

80106f65 <vector224>:
80106f65:	6a 00                	push   $0x0
80106f67:	68 e0 00 00 00       	push   $0xe0
80106f6c:	e9 cd f0 ff ff       	jmp    8010603e <alltraps>

80106f71 <vector225>:
80106f71:	6a 00                	push   $0x0
80106f73:	68 e1 00 00 00       	push   $0xe1
80106f78:	e9 c1 f0 ff ff       	jmp    8010603e <alltraps>

80106f7d <vector226>:
80106f7d:	6a 00                	push   $0x0
80106f7f:	68 e2 00 00 00       	push   $0xe2
80106f84:	e9 b5 f0 ff ff       	jmp    8010603e <alltraps>

80106f89 <vector227>:
80106f89:	6a 00                	push   $0x0
80106f8b:	68 e3 00 00 00       	push   $0xe3
80106f90:	e9 a9 f0 ff ff       	jmp    8010603e <alltraps>

80106f95 <vector228>:
80106f95:	6a 00                	push   $0x0
80106f97:	68 e4 00 00 00       	push   $0xe4
80106f9c:	e9 9d f0 ff ff       	jmp    8010603e <alltraps>

80106fa1 <vector229>:
80106fa1:	6a 00                	push   $0x0
80106fa3:	68 e5 00 00 00       	push   $0xe5
80106fa8:	e9 91 f0 ff ff       	jmp    8010603e <alltraps>

80106fad <vector230>:
80106fad:	6a 00                	push   $0x0
80106faf:	68 e6 00 00 00       	push   $0xe6
80106fb4:	e9 85 f0 ff ff       	jmp    8010603e <alltraps>

80106fb9 <vector231>:
80106fb9:	6a 00                	push   $0x0
80106fbb:	68 e7 00 00 00       	push   $0xe7
80106fc0:	e9 79 f0 ff ff       	jmp    8010603e <alltraps>

80106fc5 <vector232>:
80106fc5:	6a 00                	push   $0x0
80106fc7:	68 e8 00 00 00       	push   $0xe8
80106fcc:	e9 6d f0 ff ff       	jmp    8010603e <alltraps>

80106fd1 <vector233>:
80106fd1:	6a 00                	push   $0x0
80106fd3:	68 e9 00 00 00       	push   $0xe9
80106fd8:	e9 61 f0 ff ff       	jmp    8010603e <alltraps>

80106fdd <vector234>:
80106fdd:	6a 00                	push   $0x0
80106fdf:	68 ea 00 00 00       	push   $0xea
80106fe4:	e9 55 f0 ff ff       	jmp    8010603e <alltraps>

80106fe9 <vector235>:
80106fe9:	6a 00                	push   $0x0
80106feb:	68 eb 00 00 00       	push   $0xeb
80106ff0:	e9 49 f0 ff ff       	jmp    8010603e <alltraps>

80106ff5 <vector236>:
80106ff5:	6a 00                	push   $0x0
80106ff7:	68 ec 00 00 00       	push   $0xec
80106ffc:	e9 3d f0 ff ff       	jmp    8010603e <alltraps>

80107001 <vector237>:
80107001:	6a 00                	push   $0x0
80107003:	68 ed 00 00 00       	push   $0xed
80107008:	e9 31 f0 ff ff       	jmp    8010603e <alltraps>

8010700d <vector238>:
8010700d:	6a 00                	push   $0x0
8010700f:	68 ee 00 00 00       	push   $0xee
80107014:	e9 25 f0 ff ff       	jmp    8010603e <alltraps>

80107019 <vector239>:
80107019:	6a 00                	push   $0x0
8010701b:	68 ef 00 00 00       	push   $0xef
80107020:	e9 19 f0 ff ff       	jmp    8010603e <alltraps>

80107025 <vector240>:
80107025:	6a 00                	push   $0x0
80107027:	68 f0 00 00 00       	push   $0xf0
8010702c:	e9 0d f0 ff ff       	jmp    8010603e <alltraps>

80107031 <vector241>:
80107031:	6a 00                	push   $0x0
80107033:	68 f1 00 00 00       	push   $0xf1
80107038:	e9 01 f0 ff ff       	jmp    8010603e <alltraps>

8010703d <vector242>:
8010703d:	6a 00                	push   $0x0
8010703f:	68 f2 00 00 00       	push   $0xf2
80107044:	e9 f5 ef ff ff       	jmp    8010603e <alltraps>

80107049 <vector243>:
80107049:	6a 00                	push   $0x0
8010704b:	68 f3 00 00 00       	push   $0xf3
80107050:	e9 e9 ef ff ff       	jmp    8010603e <alltraps>

80107055 <vector244>:
80107055:	6a 00                	push   $0x0
80107057:	68 f4 00 00 00       	push   $0xf4
8010705c:	e9 dd ef ff ff       	jmp    8010603e <alltraps>

80107061 <vector245>:
80107061:	6a 00                	push   $0x0
80107063:	68 f5 00 00 00       	push   $0xf5
80107068:	e9 d1 ef ff ff       	jmp    8010603e <alltraps>

8010706d <vector246>:
8010706d:	6a 00                	push   $0x0
8010706f:	68 f6 00 00 00       	push   $0xf6
80107074:	e9 c5 ef ff ff       	jmp    8010603e <alltraps>

80107079 <vector247>:
80107079:	6a 00                	push   $0x0
8010707b:	68 f7 00 00 00       	push   $0xf7
80107080:	e9 b9 ef ff ff       	jmp    8010603e <alltraps>

80107085 <vector248>:
80107085:	6a 00                	push   $0x0
80107087:	68 f8 00 00 00       	push   $0xf8
8010708c:	e9 ad ef ff ff       	jmp    8010603e <alltraps>

80107091 <vector249>:
80107091:	6a 00                	push   $0x0
80107093:	68 f9 00 00 00       	push   $0xf9
80107098:	e9 a1 ef ff ff       	jmp    8010603e <alltraps>

8010709d <vector250>:
8010709d:	6a 00                	push   $0x0
8010709f:	68 fa 00 00 00       	push   $0xfa
801070a4:	e9 95 ef ff ff       	jmp    8010603e <alltraps>

801070a9 <vector251>:
801070a9:	6a 00                	push   $0x0
801070ab:	68 fb 00 00 00       	push   $0xfb
801070b0:	e9 89 ef ff ff       	jmp    8010603e <alltraps>

801070b5 <vector252>:
801070b5:	6a 00                	push   $0x0
801070b7:	68 fc 00 00 00       	push   $0xfc
801070bc:	e9 7d ef ff ff       	jmp    8010603e <alltraps>

801070c1 <vector253>:
801070c1:	6a 00                	push   $0x0
801070c3:	68 fd 00 00 00       	push   $0xfd
801070c8:	e9 71 ef ff ff       	jmp    8010603e <alltraps>

801070cd <vector254>:
801070cd:	6a 00                	push   $0x0
801070cf:	68 fe 00 00 00       	push   $0xfe
801070d4:	e9 65 ef ff ff       	jmp    8010603e <alltraps>

801070d9 <vector255>:
801070d9:	6a 00                	push   $0x0
801070db:	68 ff 00 00 00       	push   $0xff
801070e0:	e9 59 ef ff ff       	jmp    8010603e <alltraps>

801070e5 <lgdt>:
{
801070e5:	55                   	push   %ebp
801070e6:	89 e5                	mov    %esp,%ebp
801070e8:	83 ec 10             	sub    $0x10,%esp
  pd[0] = size-1;
801070eb:	8b 45 0c             	mov    0xc(%ebp),%eax
801070ee:	83 e8 01             	sub    $0x1,%eax
801070f1:	66 89 45 fa          	mov    %ax,-0x6(%ebp)
  pd[1] = (uint)p;
801070f5:	8b 45 08             	mov    0x8(%ebp),%eax
801070f8:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  pd[2] = (uint)p >> 16;
801070fc:	8b 45 08             	mov    0x8(%ebp),%eax
801070ff:	c1 e8 10             	shr    $0x10,%eax
80107102:	66 89 45 fe          	mov    %ax,-0x2(%ebp)
  asm volatile("lgdt (%0)" : : "r" (pd));
80107106:	8d 45 fa             	lea    -0x6(%ebp),%eax
80107109:	0f 01 10             	lgdtl  (%eax)
}
8010710c:	90                   	nop
8010710d:	c9                   	leave  
8010710e:	c3                   	ret    

8010710f <ltr>:
{
8010710f:	55                   	push   %ebp
80107110:	89 e5                	mov    %esp,%ebp
80107112:	83 ec 04             	sub    $0x4,%esp
80107115:	8b 45 08             	mov    0x8(%ebp),%eax
80107118:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  asm volatile("ltr %0" : : "r" (sel));
8010711c:	0f b7 45 fc          	movzwl -0x4(%ebp),%eax
80107120:	0f 00 d8             	ltr    %ax
}
80107123:	90                   	nop
80107124:	c9                   	leave  
80107125:	c3                   	ret    

80107126 <lcr3>:

static inline void
lcr3(uint val)
{
80107126:	55                   	push   %ebp
80107127:	89 e5                	mov    %esp,%ebp
  asm volatile("movl %0,%%cr3" : : "r" (val));
80107129:	8b 45 08             	mov    0x8(%ebp),%eax
8010712c:	0f 22 d8             	mov    %eax,%cr3
}
8010712f:	90                   	nop
80107130:	5d                   	pop    %ebp
80107131:	c3                   	ret    

80107132 <seginit>:
extern struct gpu gpu;
// Set up CPU's kernel segment descriptors.
// Run once on entry on each CPU.
void
seginit(void)
{
80107132:	55                   	push   %ebp
80107133:	89 e5                	mov    %esp,%ebp
80107135:	83 ec 18             	sub    $0x18,%esp

  // Map "logical" addresses to virtual addresses using identity map.
  // Cannot share a CODE descriptor for both kernel and user
  // because it would have to have DPL_USR, but the CPU forbids
  // an interrupt from CPL=0 to DPL=3.
  c = &cpus[cpuid()];
80107138:	e8 60 c8 ff ff       	call   8010399d <cpuid>
8010713d:	69 c0 b0 00 00 00    	imul   $0xb0,%eax,%eax
80107143:	05 80 6b 19 80       	add    $0x80196b80,%eax
80107148:	89 45 f4             	mov    %eax,-0xc(%ebp)

  c->gdt[SEG_KCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, 0);
8010714b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010714e:	66 c7 40 78 ff ff    	movw   $0xffff,0x78(%eax)
80107154:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107157:	66 c7 40 7a 00 00    	movw   $0x0,0x7a(%eax)
8010715d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107160:	c6 40 7c 00          	movb   $0x0,0x7c(%eax)
80107164:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107167:	0f b6 50 7d          	movzbl 0x7d(%eax),%edx
8010716b:	83 e2 f0             	and    $0xfffffff0,%edx
8010716e:	83 ca 0a             	or     $0xa,%edx
80107171:	88 50 7d             	mov    %dl,0x7d(%eax)
80107174:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107177:	0f b6 50 7d          	movzbl 0x7d(%eax),%edx
8010717b:	83 ca 10             	or     $0x10,%edx
8010717e:	88 50 7d             	mov    %dl,0x7d(%eax)
80107181:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107184:	0f b6 50 7d          	movzbl 0x7d(%eax),%edx
80107188:	83 e2 9f             	and    $0xffffff9f,%edx
8010718b:	88 50 7d             	mov    %dl,0x7d(%eax)
8010718e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107191:	0f b6 50 7d          	movzbl 0x7d(%eax),%edx
80107195:	83 ca 80             	or     $0xffffff80,%edx
80107198:	88 50 7d             	mov    %dl,0x7d(%eax)
8010719b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010719e:	0f b6 50 7e          	movzbl 0x7e(%eax),%edx
801071a2:	83 ca 0f             	or     $0xf,%edx
801071a5:	88 50 7e             	mov    %dl,0x7e(%eax)
801071a8:	8b 45 f4             	mov    -0xc(%ebp),%eax
801071ab:	0f b6 50 7e          	movzbl 0x7e(%eax),%edx
801071af:	83 e2 ef             	and    $0xffffffef,%edx
801071b2:	88 50 7e             	mov    %dl,0x7e(%eax)
801071b5:	8b 45 f4             	mov    -0xc(%ebp),%eax
801071b8:	0f b6 50 7e          	movzbl 0x7e(%eax),%edx
801071bc:	83 e2 df             	and    $0xffffffdf,%edx
801071bf:	88 50 7e             	mov    %dl,0x7e(%eax)
801071c2:	8b 45 f4             	mov    -0xc(%ebp),%eax
801071c5:	0f b6 50 7e          	movzbl 0x7e(%eax),%edx
801071c9:	83 ca 40             	or     $0x40,%edx
801071cc:	88 50 7e             	mov    %dl,0x7e(%eax)
801071cf:	8b 45 f4             	mov    -0xc(%ebp),%eax
801071d2:	0f b6 50 7e          	movzbl 0x7e(%eax),%edx
801071d6:	83 ca 80             	or     $0xffffff80,%edx
801071d9:	88 50 7e             	mov    %dl,0x7e(%eax)
801071dc:	8b 45 f4             	mov    -0xc(%ebp),%eax
801071df:	c6 40 7f 00          	movb   $0x0,0x7f(%eax)
  c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
801071e3:	8b 45 f4             	mov    -0xc(%ebp),%eax
801071e6:	66 c7 80 80 00 00 00 	movw   $0xffff,0x80(%eax)
801071ed:	ff ff 
801071ef:	8b 45 f4             	mov    -0xc(%ebp),%eax
801071f2:	66 c7 80 82 00 00 00 	movw   $0x0,0x82(%eax)
801071f9:	00 00 
801071fb:	8b 45 f4             	mov    -0xc(%ebp),%eax
801071fe:	c6 80 84 00 00 00 00 	movb   $0x0,0x84(%eax)
80107205:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107208:	0f b6 90 85 00 00 00 	movzbl 0x85(%eax),%edx
8010720f:	83 e2 f0             	and    $0xfffffff0,%edx
80107212:	83 ca 02             	or     $0x2,%edx
80107215:	88 90 85 00 00 00    	mov    %dl,0x85(%eax)
8010721b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010721e:	0f b6 90 85 00 00 00 	movzbl 0x85(%eax),%edx
80107225:	83 ca 10             	or     $0x10,%edx
80107228:	88 90 85 00 00 00    	mov    %dl,0x85(%eax)
8010722e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107231:	0f b6 90 85 00 00 00 	movzbl 0x85(%eax),%edx
80107238:	83 e2 9f             	and    $0xffffff9f,%edx
8010723b:	88 90 85 00 00 00    	mov    %dl,0x85(%eax)
80107241:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107244:	0f b6 90 85 00 00 00 	movzbl 0x85(%eax),%edx
8010724b:	83 ca 80             	or     $0xffffff80,%edx
8010724e:	88 90 85 00 00 00    	mov    %dl,0x85(%eax)
80107254:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107257:	0f b6 90 86 00 00 00 	movzbl 0x86(%eax),%edx
8010725e:	83 ca 0f             	or     $0xf,%edx
80107261:	88 90 86 00 00 00    	mov    %dl,0x86(%eax)
80107267:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010726a:	0f b6 90 86 00 00 00 	movzbl 0x86(%eax),%edx
80107271:	83 e2 ef             	and    $0xffffffef,%edx
80107274:	88 90 86 00 00 00    	mov    %dl,0x86(%eax)
8010727a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010727d:	0f b6 90 86 00 00 00 	movzbl 0x86(%eax),%edx
80107284:	83 e2 df             	and    $0xffffffdf,%edx
80107287:	88 90 86 00 00 00    	mov    %dl,0x86(%eax)
8010728d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107290:	0f b6 90 86 00 00 00 	movzbl 0x86(%eax),%edx
80107297:	83 ca 40             	or     $0x40,%edx
8010729a:	88 90 86 00 00 00    	mov    %dl,0x86(%eax)
801072a0:	8b 45 f4             	mov    -0xc(%ebp),%eax
801072a3:	0f b6 90 86 00 00 00 	movzbl 0x86(%eax),%edx
801072aa:	83 ca 80             	or     $0xffffff80,%edx
801072ad:	88 90 86 00 00 00    	mov    %dl,0x86(%eax)
801072b3:	8b 45 f4             	mov    -0xc(%ebp),%eax
801072b6:	c6 80 87 00 00 00 00 	movb   $0x0,0x87(%eax)
  c->gdt[SEG_UCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, DPL_USER);
801072bd:	8b 45 f4             	mov    -0xc(%ebp),%eax
801072c0:	66 c7 80 88 00 00 00 	movw   $0xffff,0x88(%eax)
801072c7:	ff ff 
801072c9:	8b 45 f4             	mov    -0xc(%ebp),%eax
801072cc:	66 c7 80 8a 00 00 00 	movw   $0x0,0x8a(%eax)
801072d3:	00 00 
801072d5:	8b 45 f4             	mov    -0xc(%ebp),%eax
801072d8:	c6 80 8c 00 00 00 00 	movb   $0x0,0x8c(%eax)
801072df:	8b 45 f4             	mov    -0xc(%ebp),%eax
801072e2:	0f b6 90 8d 00 00 00 	movzbl 0x8d(%eax),%edx
801072e9:	83 e2 f0             	and    $0xfffffff0,%edx
801072ec:	83 ca 0a             	or     $0xa,%edx
801072ef:	88 90 8d 00 00 00    	mov    %dl,0x8d(%eax)
801072f5:	8b 45 f4             	mov    -0xc(%ebp),%eax
801072f8:	0f b6 90 8d 00 00 00 	movzbl 0x8d(%eax),%edx
801072ff:	83 ca 10             	or     $0x10,%edx
80107302:	88 90 8d 00 00 00    	mov    %dl,0x8d(%eax)
80107308:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010730b:	0f b6 90 8d 00 00 00 	movzbl 0x8d(%eax),%edx
80107312:	83 ca 60             	or     $0x60,%edx
80107315:	88 90 8d 00 00 00    	mov    %dl,0x8d(%eax)
8010731b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010731e:	0f b6 90 8d 00 00 00 	movzbl 0x8d(%eax),%edx
80107325:	83 ca 80             	or     $0xffffff80,%edx
80107328:	88 90 8d 00 00 00    	mov    %dl,0x8d(%eax)
8010732e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107331:	0f b6 90 8e 00 00 00 	movzbl 0x8e(%eax),%edx
80107338:	83 ca 0f             	or     $0xf,%edx
8010733b:	88 90 8e 00 00 00    	mov    %dl,0x8e(%eax)
80107341:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107344:	0f b6 90 8e 00 00 00 	movzbl 0x8e(%eax),%edx
8010734b:	83 e2 ef             	and    $0xffffffef,%edx
8010734e:	88 90 8e 00 00 00    	mov    %dl,0x8e(%eax)
80107354:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107357:	0f b6 90 8e 00 00 00 	movzbl 0x8e(%eax),%edx
8010735e:	83 e2 df             	and    $0xffffffdf,%edx
80107361:	88 90 8e 00 00 00    	mov    %dl,0x8e(%eax)
80107367:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010736a:	0f b6 90 8e 00 00 00 	movzbl 0x8e(%eax),%edx
80107371:	83 ca 40             	or     $0x40,%edx
80107374:	88 90 8e 00 00 00    	mov    %dl,0x8e(%eax)
8010737a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010737d:	0f b6 90 8e 00 00 00 	movzbl 0x8e(%eax),%edx
80107384:	83 ca 80             	or     $0xffffff80,%edx
80107387:	88 90 8e 00 00 00    	mov    %dl,0x8e(%eax)
8010738d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107390:	c6 80 8f 00 00 00 00 	movb   $0x0,0x8f(%eax)
  c->gdt[SEG_UDATA] = SEG(STA_W, 0, 0xffffffff, DPL_USER);
80107397:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010739a:	66 c7 80 90 00 00 00 	movw   $0xffff,0x90(%eax)
801073a1:	ff ff 
801073a3:	8b 45 f4             	mov    -0xc(%ebp),%eax
801073a6:	66 c7 80 92 00 00 00 	movw   $0x0,0x92(%eax)
801073ad:	00 00 
801073af:	8b 45 f4             	mov    -0xc(%ebp),%eax
801073b2:	c6 80 94 00 00 00 00 	movb   $0x0,0x94(%eax)
801073b9:	8b 45 f4             	mov    -0xc(%ebp),%eax
801073bc:	0f b6 90 95 00 00 00 	movzbl 0x95(%eax),%edx
801073c3:	83 e2 f0             	and    $0xfffffff0,%edx
801073c6:	83 ca 02             	or     $0x2,%edx
801073c9:	88 90 95 00 00 00    	mov    %dl,0x95(%eax)
801073cf:	8b 45 f4             	mov    -0xc(%ebp),%eax
801073d2:	0f b6 90 95 00 00 00 	movzbl 0x95(%eax),%edx
801073d9:	83 ca 10             	or     $0x10,%edx
801073dc:	88 90 95 00 00 00    	mov    %dl,0x95(%eax)
801073e2:	8b 45 f4             	mov    -0xc(%ebp),%eax
801073e5:	0f b6 90 95 00 00 00 	movzbl 0x95(%eax),%edx
801073ec:	83 ca 60             	or     $0x60,%edx
801073ef:	88 90 95 00 00 00    	mov    %dl,0x95(%eax)
801073f5:	8b 45 f4             	mov    -0xc(%ebp),%eax
801073f8:	0f b6 90 95 00 00 00 	movzbl 0x95(%eax),%edx
801073ff:	83 ca 80             	or     $0xffffff80,%edx
80107402:	88 90 95 00 00 00    	mov    %dl,0x95(%eax)
80107408:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010740b:	0f b6 90 96 00 00 00 	movzbl 0x96(%eax),%edx
80107412:	83 ca 0f             	or     $0xf,%edx
80107415:	88 90 96 00 00 00    	mov    %dl,0x96(%eax)
8010741b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010741e:	0f b6 90 96 00 00 00 	movzbl 0x96(%eax),%edx
80107425:	83 e2 ef             	and    $0xffffffef,%edx
80107428:	88 90 96 00 00 00    	mov    %dl,0x96(%eax)
8010742e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107431:	0f b6 90 96 00 00 00 	movzbl 0x96(%eax),%edx
80107438:	83 e2 df             	and    $0xffffffdf,%edx
8010743b:	88 90 96 00 00 00    	mov    %dl,0x96(%eax)
80107441:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107444:	0f b6 90 96 00 00 00 	movzbl 0x96(%eax),%edx
8010744b:	83 ca 40             	or     $0x40,%edx
8010744e:	88 90 96 00 00 00    	mov    %dl,0x96(%eax)
80107454:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107457:	0f b6 90 96 00 00 00 	movzbl 0x96(%eax),%edx
8010745e:	83 ca 80             	or     $0xffffff80,%edx
80107461:	88 90 96 00 00 00    	mov    %dl,0x96(%eax)
80107467:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010746a:	c6 80 97 00 00 00 00 	movb   $0x0,0x97(%eax)
  lgdt(c->gdt, sizeof(c->gdt));
80107471:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107474:	83 c0 70             	add    $0x70,%eax
80107477:	83 ec 08             	sub    $0x8,%esp
8010747a:	6a 30                	push   $0x30
8010747c:	50                   	push   %eax
8010747d:	e8 63 fc ff ff       	call   801070e5 <lgdt>
80107482:	83 c4 10             	add    $0x10,%esp
}
80107485:	90                   	nop
80107486:	c9                   	leave  
80107487:	c3                   	ret    

80107488 <walkpgdir>:
// Return the address of the PTE in page table pgdir
// that corresponds to virtual address va.  If alloc!=0,
// create any required page table pages.
static pte_t *
walkpgdir(pde_t *pgdir, const void *va, int alloc)
{
80107488:	55                   	push   %ebp
80107489:	89 e5                	mov    %esp,%ebp
8010748b:	83 ec 18             	sub    $0x18,%esp
  pde_t *pde;
  pte_t *pgtab;

  pde = &pgdir[PDX(va)];
8010748e:	8b 45 0c             	mov    0xc(%ebp),%eax
80107491:	c1 e8 16             	shr    $0x16,%eax
80107494:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
8010749b:	8b 45 08             	mov    0x8(%ebp),%eax
8010749e:	01 d0                	add    %edx,%eax
801074a0:	89 45 f0             	mov    %eax,-0x10(%ebp)
  if(*pde & PTE_P){
801074a3:	8b 45 f0             	mov    -0x10(%ebp),%eax
801074a6:	8b 00                	mov    (%eax),%eax
801074a8:	83 e0 01             	and    $0x1,%eax
801074ab:	85 c0                	test   %eax,%eax
801074ad:	74 14                	je     801074c3 <walkpgdir+0x3b>
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
801074af:	8b 45 f0             	mov    -0x10(%ebp),%eax
801074b2:	8b 00                	mov    (%eax),%eax
801074b4:	25 00 f0 ff ff       	and    $0xfffff000,%eax
801074b9:	05 00 00 00 80       	add    $0x80000000,%eax
801074be:	89 45 f4             	mov    %eax,-0xc(%ebp)
801074c1:	eb 42                	jmp    80107505 <walkpgdir+0x7d>
  } else {
    if(!alloc || (pgtab = (pte_t*)kalloc()) == 0)
801074c3:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
801074c7:	74 0e                	je     801074d7 <walkpgdir+0x4f>
801074c9:	e8 d2 b2 ff ff       	call   801027a0 <kalloc>
801074ce:	89 45 f4             	mov    %eax,-0xc(%ebp)
801074d1:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801074d5:	75 07                	jne    801074de <walkpgdir+0x56>
      return 0;
801074d7:	b8 00 00 00 00       	mov    $0x0,%eax
801074dc:	eb 3e                	jmp    8010751c <walkpgdir+0x94>
    // Make sure all those PTE_P bits are zero.
    memset(pgtab, 0, PGSIZE);
801074de:	83 ec 04             	sub    $0x4,%esp
801074e1:	68 00 10 00 00       	push   $0x1000
801074e6:	6a 00                	push   $0x0
801074e8:	ff 75 f4             	push   -0xc(%ebp)
801074eb:	e8 3f d7 ff ff       	call   80104c2f <memset>
801074f0:	83 c4 10             	add    $0x10,%esp
    // The permissions here are overly generous, but they can
    // be further restricted by the permissions in the page table
    // entries, if necessary.
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
801074f3:	8b 45 f4             	mov    -0xc(%ebp),%eax
801074f6:	05 00 00 00 80       	add    $0x80000000,%eax
801074fb:	83 c8 07             	or     $0x7,%eax
801074fe:	89 c2                	mov    %eax,%edx
80107500:	8b 45 f0             	mov    -0x10(%ebp),%eax
80107503:	89 10                	mov    %edx,(%eax)
  }
  return &pgtab[PTX(va)];
80107505:	8b 45 0c             	mov    0xc(%ebp),%eax
80107508:	c1 e8 0c             	shr    $0xc,%eax
8010750b:	25 ff 03 00 00       	and    $0x3ff,%eax
80107510:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80107517:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010751a:	01 d0                	add    %edx,%eax
}
8010751c:	c9                   	leave  
8010751d:	c3                   	ret    

8010751e <mappages>:
// Create PTEs for virtual addresses starting at va that refer to
// physical addresses starting at pa. va and size might not
// be page-aligned.
static int
mappages(pde_t *pgdir, void *va, uint size, uint pa, int perm)
{
8010751e:	55                   	push   %ebp
8010751f:	89 e5                	mov    %esp,%ebp
80107521:	83 ec 18             	sub    $0x18,%esp
  char *a, *last;
  pte_t *pte;

  a = (char*)PGROUNDDOWN((uint)va);
80107524:	8b 45 0c             	mov    0xc(%ebp),%eax
80107527:	25 00 f0 ff ff       	and    $0xfffff000,%eax
8010752c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
8010752f:	8b 55 0c             	mov    0xc(%ebp),%edx
80107532:	8b 45 10             	mov    0x10(%ebp),%eax
80107535:	01 d0                	add    %edx,%eax
80107537:	83 e8 01             	sub    $0x1,%eax
8010753a:	25 00 f0 ff ff       	and    $0xfffff000,%eax
8010753f:	89 45 f0             	mov    %eax,-0x10(%ebp)
  for(;;){
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
80107542:	83 ec 04             	sub    $0x4,%esp
80107545:	6a 01                	push   $0x1
80107547:	ff 75 f4             	push   -0xc(%ebp)
8010754a:	ff 75 08             	push   0x8(%ebp)
8010754d:	e8 36 ff ff ff       	call   80107488 <walkpgdir>
80107552:	83 c4 10             	add    $0x10,%esp
80107555:	89 45 ec             	mov    %eax,-0x14(%ebp)
80107558:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
8010755c:	75 07                	jne    80107565 <mappages+0x47>
      return -1;
8010755e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80107563:	eb 47                	jmp    801075ac <mappages+0x8e>
    if(*pte & PTE_P)
80107565:	8b 45 ec             	mov    -0x14(%ebp),%eax
80107568:	8b 00                	mov    (%eax),%eax
8010756a:	83 e0 01             	and    $0x1,%eax
8010756d:	85 c0                	test   %eax,%eax
8010756f:	74 0d                	je     8010757e <mappages+0x60>
      panic("remap");
80107571:	83 ec 0c             	sub    $0xc,%esp
80107574:	68 48 a8 10 80       	push   $0x8010a848
80107579:	e8 2b 90 ff ff       	call   801005a9 <panic>
    *pte = pa | perm | PTE_P;
8010757e:	8b 45 18             	mov    0x18(%ebp),%eax
80107581:	0b 45 14             	or     0x14(%ebp),%eax
80107584:	83 c8 01             	or     $0x1,%eax
80107587:	89 c2                	mov    %eax,%edx
80107589:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010758c:	89 10                	mov    %edx,(%eax)
    if(a == last)
8010758e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107591:	3b 45 f0             	cmp    -0x10(%ebp),%eax
80107594:	74 10                	je     801075a6 <mappages+0x88>
      break;
    a += PGSIZE;
80107596:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
    pa += PGSIZE;
8010759d:	81 45 14 00 10 00 00 	addl   $0x1000,0x14(%ebp)
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
801075a4:	eb 9c                	jmp    80107542 <mappages+0x24>
      break;
801075a6:	90                   	nop
  }
  return 0;
801075a7:	b8 00 00 00 00       	mov    $0x0,%eax
}
801075ac:	c9                   	leave  
801075ad:	c3                   	ret    

801075ae <setupkvm>:
};

// Set up kernel part of a page table.
pde_t*
setupkvm(void)
{
801075ae:	55                   	push   %ebp
801075af:	89 e5                	mov    %esp,%ebp
801075b1:	53                   	push   %ebx
801075b2:	83 ec 24             	sub    $0x24,%esp
  pde_t *pgdir;
  struct kmap *k;
  k = kmap;
801075b5:	c7 45 f4 a0 f4 10 80 	movl   $0x8010f4a0,-0xc(%ebp)
  struct kmap vram = { (void*)(DEVSPACE - gpu.vram_size),gpu.pvram_addr,gpu.pvram_addr+gpu.vram_size, PTE_W};
801075bc:	8b 15 50 6e 19 80    	mov    0x80196e50,%edx
801075c2:	b8 00 00 00 fe       	mov    $0xfe000000,%eax
801075c7:	29 d0                	sub    %edx,%eax
801075c9:	89 45 e0             	mov    %eax,-0x20(%ebp)
801075cc:	a1 48 6e 19 80       	mov    0x80196e48,%eax
801075d1:	89 45 e4             	mov    %eax,-0x1c(%ebp)
801075d4:	8b 15 48 6e 19 80    	mov    0x80196e48,%edx
801075da:	a1 50 6e 19 80       	mov    0x80196e50,%eax
801075df:	01 d0                	add    %edx,%eax
801075e1:	89 45 e8             	mov    %eax,-0x18(%ebp)
801075e4:	c7 45 ec 02 00 00 00 	movl   $0x2,-0x14(%ebp)
  k[3] = vram;
801075eb:	8b 45 f4             	mov    -0xc(%ebp),%eax
801075ee:	83 c0 30             	add    $0x30,%eax
801075f1:	8b 55 e0             	mov    -0x20(%ebp),%edx
801075f4:	89 10                	mov    %edx,(%eax)
801075f6:	8b 55 e4             	mov    -0x1c(%ebp),%edx
801075f9:	89 50 04             	mov    %edx,0x4(%eax)
801075fc:	8b 55 e8             	mov    -0x18(%ebp),%edx
801075ff:	89 50 08             	mov    %edx,0x8(%eax)
80107602:	8b 55 ec             	mov    -0x14(%ebp),%edx
80107605:	89 50 0c             	mov    %edx,0xc(%eax)
  if((pgdir = (pde_t*)kalloc()) == 0){
80107608:	e8 93 b1 ff ff       	call   801027a0 <kalloc>
8010760d:	89 45 f0             	mov    %eax,-0x10(%ebp)
80107610:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80107614:	75 07                	jne    8010761d <setupkvm+0x6f>
    return 0;
80107616:	b8 00 00 00 00       	mov    $0x0,%eax
8010761b:	eb 78                	jmp    80107695 <setupkvm+0xe7>
  }
  memset(pgdir, 0, PGSIZE);
8010761d:	83 ec 04             	sub    $0x4,%esp
80107620:	68 00 10 00 00       	push   $0x1000
80107625:	6a 00                	push   $0x0
80107627:	ff 75 f0             	push   -0x10(%ebp)
8010762a:	e8 00 d6 ff ff       	call   80104c2f <memset>
8010762f:	83 c4 10             	add    $0x10,%esp
  if (P2V(PHYSTOP) > (void*)DEVSPACE)
    panic("PHYSTOP too high");
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
80107632:	c7 45 f4 a0 f4 10 80 	movl   $0x8010f4a0,-0xc(%ebp)
80107639:	eb 4e                	jmp    80107689 <setupkvm+0xdb>
    if(mappages(pgdir, k->virt, k->phys_end - k->phys_start,
8010763b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010763e:	8b 48 0c             	mov    0xc(%eax),%ecx
                (uint)k->phys_start, k->perm) < 0) {
80107641:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107644:	8b 50 04             	mov    0x4(%eax),%edx
    if(mappages(pgdir, k->virt, k->phys_end - k->phys_start,
80107647:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010764a:	8b 58 08             	mov    0x8(%eax),%ebx
8010764d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107650:	8b 40 04             	mov    0x4(%eax),%eax
80107653:	29 c3                	sub    %eax,%ebx
80107655:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107658:	8b 00                	mov    (%eax),%eax
8010765a:	83 ec 0c             	sub    $0xc,%esp
8010765d:	51                   	push   %ecx
8010765e:	52                   	push   %edx
8010765f:	53                   	push   %ebx
80107660:	50                   	push   %eax
80107661:	ff 75 f0             	push   -0x10(%ebp)
80107664:	e8 b5 fe ff ff       	call   8010751e <mappages>
80107669:	83 c4 20             	add    $0x20,%esp
8010766c:	85 c0                	test   %eax,%eax
8010766e:	79 15                	jns    80107685 <setupkvm+0xd7>
      freevm(pgdir);
80107670:	83 ec 0c             	sub    $0xc,%esp
80107673:	ff 75 f0             	push   -0x10(%ebp)
80107676:	e8 f5 04 00 00       	call   80107b70 <freevm>
8010767b:	83 c4 10             	add    $0x10,%esp
      return 0;
8010767e:	b8 00 00 00 00       	mov    $0x0,%eax
80107683:	eb 10                	jmp    80107695 <setupkvm+0xe7>
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
80107685:	83 45 f4 10          	addl   $0x10,-0xc(%ebp)
80107689:	81 7d f4 00 f5 10 80 	cmpl   $0x8010f500,-0xc(%ebp)
80107690:	72 a9                	jb     8010763b <setupkvm+0x8d>
    }
  return pgdir;
80107692:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
80107695:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80107698:	c9                   	leave  
80107699:	c3                   	ret    

8010769a <kvmalloc>:

// Allocate one page table for the machine for the kernel address
// space for scheduler processes.
void
kvmalloc(void)
{
8010769a:	55                   	push   %ebp
8010769b:	89 e5                	mov    %esp,%ebp
8010769d:	83 ec 08             	sub    $0x8,%esp
  kpgdir = setupkvm();
801076a0:	e8 09 ff ff ff       	call   801075ae <setupkvm>
801076a5:	a3 7c 6b 19 80       	mov    %eax,0x80196b7c
  switchkvm();
801076aa:	e8 03 00 00 00       	call   801076b2 <switchkvm>
}
801076af:	90                   	nop
801076b0:	c9                   	leave  
801076b1:	c3                   	ret    

801076b2 <switchkvm>:

// Switch h/w page table register to the kernel-only page table,
// for when no process is running.
void
switchkvm(void)
{
801076b2:	55                   	push   %ebp
801076b3:	89 e5                	mov    %esp,%ebp
  lcr3(V2P(kpgdir));   // switch to the kernel page table
801076b5:	a1 7c 6b 19 80       	mov    0x80196b7c,%eax
801076ba:	05 00 00 00 80       	add    $0x80000000,%eax
801076bf:	50                   	push   %eax
801076c0:	e8 61 fa ff ff       	call   80107126 <lcr3>
801076c5:	83 c4 04             	add    $0x4,%esp
}
801076c8:	90                   	nop
801076c9:	c9                   	leave  
801076ca:	c3                   	ret    

801076cb <switchuvm>:

// Switch TSS and h/w page table to correspond to process p.
void
switchuvm(struct proc *p)
{
801076cb:	55                   	push   %ebp
801076cc:	89 e5                	mov    %esp,%ebp
801076ce:	56                   	push   %esi
801076cf:	53                   	push   %ebx
801076d0:	83 ec 10             	sub    $0x10,%esp
  if(p == 0)
801076d3:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
801076d7:	75 0d                	jne    801076e6 <switchuvm+0x1b>
    panic("switchuvm: no process");
801076d9:	83 ec 0c             	sub    $0xc,%esp
801076dc:	68 4e a8 10 80       	push   $0x8010a84e
801076e1:	e8 c3 8e ff ff       	call   801005a9 <panic>
  if(p->kstack == 0)
801076e6:	8b 45 08             	mov    0x8(%ebp),%eax
801076e9:	8b 40 08             	mov    0x8(%eax),%eax
801076ec:	85 c0                	test   %eax,%eax
801076ee:	75 0d                	jne    801076fd <switchuvm+0x32>
    panic("switchuvm: no kstack");
801076f0:	83 ec 0c             	sub    $0xc,%esp
801076f3:	68 64 a8 10 80       	push   $0x8010a864
801076f8:	e8 ac 8e ff ff       	call   801005a9 <panic>
  if(p->pgdir == 0)
801076fd:	8b 45 08             	mov    0x8(%ebp),%eax
80107700:	8b 40 04             	mov    0x4(%eax),%eax
80107703:	85 c0                	test   %eax,%eax
80107705:	75 0d                	jne    80107714 <switchuvm+0x49>
    panic("switchuvm: no pgdir");
80107707:	83 ec 0c             	sub    $0xc,%esp
8010770a:	68 79 a8 10 80       	push   $0x8010a879
8010770f:	e8 95 8e ff ff       	call   801005a9 <panic>

  pushcli();
80107714:	e8 0b d4 ff ff       	call   80104b24 <pushcli>
  mycpu()->gdt[SEG_TSS] = SEG16(STS_T32A, &mycpu()->ts,
80107719:	e8 9a c2 ff ff       	call   801039b8 <mycpu>
8010771e:	89 c3                	mov    %eax,%ebx
80107720:	e8 93 c2 ff ff       	call   801039b8 <mycpu>
80107725:	83 c0 08             	add    $0x8,%eax
80107728:	89 c6                	mov    %eax,%esi
8010772a:	e8 89 c2 ff ff       	call   801039b8 <mycpu>
8010772f:	83 c0 08             	add    $0x8,%eax
80107732:	c1 e8 10             	shr    $0x10,%eax
80107735:	88 45 f7             	mov    %al,-0x9(%ebp)
80107738:	e8 7b c2 ff ff       	call   801039b8 <mycpu>
8010773d:	83 c0 08             	add    $0x8,%eax
80107740:	c1 e8 18             	shr    $0x18,%eax
80107743:	89 c2                	mov    %eax,%edx
80107745:	66 c7 83 98 00 00 00 	movw   $0x67,0x98(%ebx)
8010774c:	67 00 
8010774e:	66 89 b3 9a 00 00 00 	mov    %si,0x9a(%ebx)
80107755:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
80107759:	88 83 9c 00 00 00    	mov    %al,0x9c(%ebx)
8010775f:	0f b6 83 9d 00 00 00 	movzbl 0x9d(%ebx),%eax
80107766:	83 e0 f0             	and    $0xfffffff0,%eax
80107769:	83 c8 09             	or     $0x9,%eax
8010776c:	88 83 9d 00 00 00    	mov    %al,0x9d(%ebx)
80107772:	0f b6 83 9d 00 00 00 	movzbl 0x9d(%ebx),%eax
80107779:	83 c8 10             	or     $0x10,%eax
8010777c:	88 83 9d 00 00 00    	mov    %al,0x9d(%ebx)
80107782:	0f b6 83 9d 00 00 00 	movzbl 0x9d(%ebx),%eax
80107789:	83 e0 9f             	and    $0xffffff9f,%eax
8010778c:	88 83 9d 00 00 00    	mov    %al,0x9d(%ebx)
80107792:	0f b6 83 9d 00 00 00 	movzbl 0x9d(%ebx),%eax
80107799:	83 c8 80             	or     $0xffffff80,%eax
8010779c:	88 83 9d 00 00 00    	mov    %al,0x9d(%ebx)
801077a2:	0f b6 83 9e 00 00 00 	movzbl 0x9e(%ebx),%eax
801077a9:	83 e0 f0             	and    $0xfffffff0,%eax
801077ac:	88 83 9e 00 00 00    	mov    %al,0x9e(%ebx)
801077b2:	0f b6 83 9e 00 00 00 	movzbl 0x9e(%ebx),%eax
801077b9:	83 e0 ef             	and    $0xffffffef,%eax
801077bc:	88 83 9e 00 00 00    	mov    %al,0x9e(%ebx)
801077c2:	0f b6 83 9e 00 00 00 	movzbl 0x9e(%ebx),%eax
801077c9:	83 e0 df             	and    $0xffffffdf,%eax
801077cc:	88 83 9e 00 00 00    	mov    %al,0x9e(%ebx)
801077d2:	0f b6 83 9e 00 00 00 	movzbl 0x9e(%ebx),%eax
801077d9:	83 c8 40             	or     $0x40,%eax
801077dc:	88 83 9e 00 00 00    	mov    %al,0x9e(%ebx)
801077e2:	0f b6 83 9e 00 00 00 	movzbl 0x9e(%ebx),%eax
801077e9:	83 e0 7f             	and    $0x7f,%eax
801077ec:	88 83 9e 00 00 00    	mov    %al,0x9e(%ebx)
801077f2:	88 93 9f 00 00 00    	mov    %dl,0x9f(%ebx)
                                sizeof(mycpu()->ts)-1, 0);
  mycpu()->gdt[SEG_TSS].s = 0;
801077f8:	e8 bb c1 ff ff       	call   801039b8 <mycpu>
801077fd:	0f b6 90 9d 00 00 00 	movzbl 0x9d(%eax),%edx
80107804:	83 e2 ef             	and    $0xffffffef,%edx
80107807:	88 90 9d 00 00 00    	mov    %dl,0x9d(%eax)
  mycpu()->ts.ss0 = SEG_KDATA << 3;
8010780d:	e8 a6 c1 ff ff       	call   801039b8 <mycpu>
80107812:	66 c7 40 10 10 00    	movw   $0x10,0x10(%eax)
  mycpu()->ts.esp0 = (uint)p->kstack + KSTACKSIZE;
80107818:	8b 45 08             	mov    0x8(%ebp),%eax
8010781b:	8b 40 08             	mov    0x8(%eax),%eax
8010781e:	89 c3                	mov    %eax,%ebx
80107820:	e8 93 c1 ff ff       	call   801039b8 <mycpu>
80107825:	8d 93 00 10 00 00    	lea    0x1000(%ebx),%edx
8010782b:	89 50 0c             	mov    %edx,0xc(%eax)
  // setting IOPL=0 in eflags *and* iomb beyond the tss segment limit
  // forbids I/O instructions (e.g., inb and outb) from user space
  mycpu()->ts.iomb = (ushort) 0xFFFF;
8010782e:	e8 85 c1 ff ff       	call   801039b8 <mycpu>
80107833:	66 c7 40 6e ff ff    	movw   $0xffff,0x6e(%eax)
  ltr(SEG_TSS << 3);
80107839:	83 ec 0c             	sub    $0xc,%esp
8010783c:	6a 28                	push   $0x28
8010783e:	e8 cc f8 ff ff       	call   8010710f <ltr>
80107843:	83 c4 10             	add    $0x10,%esp
  lcr3(V2P(p->pgdir));  // switch to process's address space
80107846:	8b 45 08             	mov    0x8(%ebp),%eax
80107849:	8b 40 04             	mov    0x4(%eax),%eax
8010784c:	05 00 00 00 80       	add    $0x80000000,%eax
80107851:	83 ec 0c             	sub    $0xc,%esp
80107854:	50                   	push   %eax
80107855:	e8 cc f8 ff ff       	call   80107126 <lcr3>
8010785a:	83 c4 10             	add    $0x10,%esp
  popcli();
8010785d:	e8 0f d3 ff ff       	call   80104b71 <popcli>
}
80107862:	90                   	nop
80107863:	8d 65 f8             	lea    -0x8(%ebp),%esp
80107866:	5b                   	pop    %ebx
80107867:	5e                   	pop    %esi
80107868:	5d                   	pop    %ebp
80107869:	c3                   	ret    

8010786a <inituvm>:

// Load the initcode into address 0 of pgdir.
// sz must be less than a page.
void
inituvm(pde_t *pgdir, char *init, uint sz)
{
8010786a:	55                   	push   %ebp
8010786b:	89 e5                	mov    %esp,%ebp
8010786d:	83 ec 18             	sub    $0x18,%esp
  char *mem;

  if(sz >= PGSIZE)
80107870:	81 7d 10 ff 0f 00 00 	cmpl   $0xfff,0x10(%ebp)
80107877:	76 0d                	jbe    80107886 <inituvm+0x1c>
    panic("inituvm: more than a page");
80107879:	83 ec 0c             	sub    $0xc,%esp
8010787c:	68 8d a8 10 80       	push   $0x8010a88d
80107881:	e8 23 8d ff ff       	call   801005a9 <panic>
  mem = kalloc();
80107886:	e8 15 af ff ff       	call   801027a0 <kalloc>
8010788b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  memset(mem, 0, PGSIZE);
8010788e:	83 ec 04             	sub    $0x4,%esp
80107891:	68 00 10 00 00       	push   $0x1000
80107896:	6a 00                	push   $0x0
80107898:	ff 75 f4             	push   -0xc(%ebp)
8010789b:	e8 8f d3 ff ff       	call   80104c2f <memset>
801078a0:	83 c4 10             	add    $0x10,%esp
  mappages(pgdir, 0, PGSIZE, V2P(mem), PTE_W|PTE_U);
801078a3:	8b 45 f4             	mov    -0xc(%ebp),%eax
801078a6:	05 00 00 00 80       	add    $0x80000000,%eax
801078ab:	83 ec 0c             	sub    $0xc,%esp
801078ae:	6a 06                	push   $0x6
801078b0:	50                   	push   %eax
801078b1:	68 00 10 00 00       	push   $0x1000
801078b6:	6a 00                	push   $0x0
801078b8:	ff 75 08             	push   0x8(%ebp)
801078bb:	e8 5e fc ff ff       	call   8010751e <mappages>
801078c0:	83 c4 20             	add    $0x20,%esp
  memmove(mem, init, sz);
801078c3:	83 ec 04             	sub    $0x4,%esp
801078c6:	ff 75 10             	push   0x10(%ebp)
801078c9:	ff 75 0c             	push   0xc(%ebp)
801078cc:	ff 75 f4             	push   -0xc(%ebp)
801078cf:	e8 1a d4 ff ff       	call   80104cee <memmove>
801078d4:	83 c4 10             	add    $0x10,%esp
}
801078d7:	90                   	nop
801078d8:	c9                   	leave  
801078d9:	c3                   	ret    

801078da <loaduvm>:

// Load a program segment into pgdir.  addr must be page-aligned
// and the pages from addr to addr+sz must already be mapped.
int
loaduvm(pde_t *pgdir, char *addr, struct inode *ip, uint offset, uint sz)
{
801078da:	55                   	push   %ebp
801078db:	89 e5                	mov    %esp,%ebp
801078dd:	83 ec 18             	sub    $0x18,%esp
  uint i, pa, n;
  pte_t *pte;

  if((uint) addr % PGSIZE != 0)
801078e0:	8b 45 0c             	mov    0xc(%ebp),%eax
801078e3:	25 ff 0f 00 00       	and    $0xfff,%eax
801078e8:	85 c0                	test   %eax,%eax
801078ea:	74 0d                	je     801078f9 <loaduvm+0x1f>
    panic("loaduvm: addr must be page aligned");
801078ec:	83 ec 0c             	sub    $0xc,%esp
801078ef:	68 a8 a8 10 80       	push   $0x8010a8a8
801078f4:	e8 b0 8c ff ff       	call   801005a9 <panic>
  for(i = 0; i < sz; i += PGSIZE){
801078f9:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80107900:	e9 8f 00 00 00       	jmp    80107994 <loaduvm+0xba>
    if((pte = walkpgdir(pgdir, addr+i, 0)) == 0)
80107905:	8b 55 0c             	mov    0xc(%ebp),%edx
80107908:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010790b:	01 d0                	add    %edx,%eax
8010790d:	83 ec 04             	sub    $0x4,%esp
80107910:	6a 00                	push   $0x0
80107912:	50                   	push   %eax
80107913:	ff 75 08             	push   0x8(%ebp)
80107916:	e8 6d fb ff ff       	call   80107488 <walkpgdir>
8010791b:	83 c4 10             	add    $0x10,%esp
8010791e:	89 45 ec             	mov    %eax,-0x14(%ebp)
80107921:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
80107925:	75 0d                	jne    80107934 <loaduvm+0x5a>
      panic("loaduvm: address should exist");
80107927:	83 ec 0c             	sub    $0xc,%esp
8010792a:	68 cb a8 10 80       	push   $0x8010a8cb
8010792f:	e8 75 8c ff ff       	call   801005a9 <panic>
    pa = PTE_ADDR(*pte);
80107934:	8b 45 ec             	mov    -0x14(%ebp),%eax
80107937:	8b 00                	mov    (%eax),%eax
80107939:	25 00 f0 ff ff       	and    $0xfffff000,%eax
8010793e:	89 45 e8             	mov    %eax,-0x18(%ebp)
    if(sz - i < PGSIZE)
80107941:	8b 45 18             	mov    0x18(%ebp),%eax
80107944:	2b 45 f4             	sub    -0xc(%ebp),%eax
80107947:	3d ff 0f 00 00       	cmp    $0xfff,%eax
8010794c:	77 0b                	ja     80107959 <loaduvm+0x7f>
      n = sz - i;
8010794e:	8b 45 18             	mov    0x18(%ebp),%eax
80107951:	2b 45 f4             	sub    -0xc(%ebp),%eax
80107954:	89 45 f0             	mov    %eax,-0x10(%ebp)
80107957:	eb 07                	jmp    80107960 <loaduvm+0x86>
    else
      n = PGSIZE;
80107959:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
    if(readi(ip, P2V(pa), offset+i, n) != n)
80107960:	8b 55 14             	mov    0x14(%ebp),%edx
80107963:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107966:	01 d0                	add    %edx,%eax
80107968:	8b 55 e8             	mov    -0x18(%ebp),%edx
8010796b:	81 c2 00 00 00 80    	add    $0x80000000,%edx
80107971:	ff 75 f0             	push   -0x10(%ebp)
80107974:	50                   	push   %eax
80107975:	52                   	push   %edx
80107976:	ff 75 10             	push   0x10(%ebp)
80107979:	e8 58 a5 ff ff       	call   80101ed6 <readi>
8010797e:	83 c4 10             	add    $0x10,%esp
80107981:	39 45 f0             	cmp    %eax,-0x10(%ebp)
80107984:	74 07                	je     8010798d <loaduvm+0xb3>
      return -1;
80107986:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010798b:	eb 18                	jmp    801079a5 <loaduvm+0xcb>
  for(i = 0; i < sz; i += PGSIZE){
8010798d:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
80107994:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107997:	3b 45 18             	cmp    0x18(%ebp),%eax
8010799a:	0f 82 65 ff ff ff    	jb     80107905 <loaduvm+0x2b>
  }
  return 0;
801079a0:	b8 00 00 00 00       	mov    $0x0,%eax
}
801079a5:	c9                   	leave  
801079a6:	c3                   	ret    

801079a7 <allocuvm>:

// Allocate page tables and physical memory to grow process from oldsz to
// newsz, which need not be page aligned.  Returns new size or 0 on error.
int
allocuvm(pde_t *pgdir, uint oldsz, uint newsz)
{
801079a7:	55                   	push   %ebp
801079a8:	89 e5                	mov    %esp,%ebp
801079aa:	83 ec 18             	sub    $0x18,%esp
  char *mem;
  uint a;

  if(newsz >= KERNBASE)
801079ad:	8b 45 10             	mov    0x10(%ebp),%eax
801079b0:	85 c0                	test   %eax,%eax
801079b2:	79 0a                	jns    801079be <allocuvm+0x17>
    return 0;
801079b4:	b8 00 00 00 00       	mov    $0x0,%eax
801079b9:	e9 ec 00 00 00       	jmp    80107aaa <allocuvm+0x103>
  if(newsz < oldsz)
801079be:	8b 45 10             	mov    0x10(%ebp),%eax
801079c1:	3b 45 0c             	cmp    0xc(%ebp),%eax
801079c4:	73 08                	jae    801079ce <allocuvm+0x27>
    return oldsz;
801079c6:	8b 45 0c             	mov    0xc(%ebp),%eax
801079c9:	e9 dc 00 00 00       	jmp    80107aaa <allocuvm+0x103>

  a = PGROUNDUP(oldsz);
801079ce:	8b 45 0c             	mov    0xc(%ebp),%eax
801079d1:	05 ff 0f 00 00       	add    $0xfff,%eax
801079d6:	25 00 f0 ff ff       	and    $0xfffff000,%eax
801079db:	89 45 f4             	mov    %eax,-0xc(%ebp)
  for(; a < newsz; a += PGSIZE){
801079de:	e9 b8 00 00 00       	jmp    80107a9b <allocuvm+0xf4>
    mem = kalloc();
801079e3:	e8 b8 ad ff ff       	call   801027a0 <kalloc>
801079e8:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(mem == 0){
801079eb:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
801079ef:	75 2e                	jne    80107a1f <allocuvm+0x78>
      cprintf("allocuvm out of memory\n");
801079f1:	83 ec 0c             	sub    $0xc,%esp
801079f4:	68 e9 a8 10 80       	push   $0x8010a8e9
801079f9:	e8 f6 89 ff ff       	call   801003f4 <cprintf>
801079fe:	83 c4 10             	add    $0x10,%esp
      deallocuvm(pgdir, newsz, oldsz);
80107a01:	83 ec 04             	sub    $0x4,%esp
80107a04:	ff 75 0c             	push   0xc(%ebp)
80107a07:	ff 75 10             	push   0x10(%ebp)
80107a0a:	ff 75 08             	push   0x8(%ebp)
80107a0d:	e8 9a 00 00 00       	call   80107aac <deallocuvm>
80107a12:	83 c4 10             	add    $0x10,%esp
      return 0;
80107a15:	b8 00 00 00 00       	mov    $0x0,%eax
80107a1a:	e9 8b 00 00 00       	jmp    80107aaa <allocuvm+0x103>
    }
    memset(mem, 0, PGSIZE);
80107a1f:	83 ec 04             	sub    $0x4,%esp
80107a22:	68 00 10 00 00       	push   $0x1000
80107a27:	6a 00                	push   $0x0
80107a29:	ff 75 f0             	push   -0x10(%ebp)
80107a2c:	e8 fe d1 ff ff       	call   80104c2f <memset>
80107a31:	83 c4 10             	add    $0x10,%esp
    if(mappages(pgdir, (char*)a, PGSIZE, V2P(mem), PTE_W|PTE_U) < 0){
80107a34:	8b 45 f0             	mov    -0x10(%ebp),%eax
80107a37:	8d 90 00 00 00 80    	lea    -0x80000000(%eax),%edx
80107a3d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107a40:	83 ec 0c             	sub    $0xc,%esp
80107a43:	6a 06                	push   $0x6
80107a45:	52                   	push   %edx
80107a46:	68 00 10 00 00       	push   $0x1000
80107a4b:	50                   	push   %eax
80107a4c:	ff 75 08             	push   0x8(%ebp)
80107a4f:	e8 ca fa ff ff       	call   8010751e <mappages>
80107a54:	83 c4 20             	add    $0x20,%esp
80107a57:	85 c0                	test   %eax,%eax
80107a59:	79 39                	jns    80107a94 <allocuvm+0xed>
      cprintf("allocuvm out of memory (2)\n");
80107a5b:	83 ec 0c             	sub    $0xc,%esp
80107a5e:	68 01 a9 10 80       	push   $0x8010a901
80107a63:	e8 8c 89 ff ff       	call   801003f4 <cprintf>
80107a68:	83 c4 10             	add    $0x10,%esp
      deallocuvm(pgdir, newsz, oldsz);
80107a6b:	83 ec 04             	sub    $0x4,%esp
80107a6e:	ff 75 0c             	push   0xc(%ebp)
80107a71:	ff 75 10             	push   0x10(%ebp)
80107a74:	ff 75 08             	push   0x8(%ebp)
80107a77:	e8 30 00 00 00       	call   80107aac <deallocuvm>
80107a7c:	83 c4 10             	add    $0x10,%esp
      kfree(mem);
80107a7f:	83 ec 0c             	sub    $0xc,%esp
80107a82:	ff 75 f0             	push   -0x10(%ebp)
80107a85:	e8 7c ac ff ff       	call   80102706 <kfree>
80107a8a:	83 c4 10             	add    $0x10,%esp
      return 0;
80107a8d:	b8 00 00 00 00       	mov    $0x0,%eax
80107a92:	eb 16                	jmp    80107aaa <allocuvm+0x103>
  for(; a < newsz; a += PGSIZE){
80107a94:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
80107a9b:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107a9e:	3b 45 10             	cmp    0x10(%ebp),%eax
80107aa1:	0f 82 3c ff ff ff    	jb     801079e3 <allocuvm+0x3c>
    }
  }
  return newsz;
80107aa7:	8b 45 10             	mov    0x10(%ebp),%eax
}
80107aaa:	c9                   	leave  
80107aab:	c3                   	ret    

80107aac <deallocuvm>:
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
int
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
{
80107aac:	55                   	push   %ebp
80107aad:	89 e5                	mov    %esp,%ebp
80107aaf:	83 ec 18             	sub    $0x18,%esp
  pte_t *pte;
  uint a, pa;

  if(newsz >= oldsz)
80107ab2:	8b 45 10             	mov    0x10(%ebp),%eax
80107ab5:	3b 45 0c             	cmp    0xc(%ebp),%eax
80107ab8:	72 08                	jb     80107ac2 <deallocuvm+0x16>
    return oldsz;
80107aba:	8b 45 0c             	mov    0xc(%ebp),%eax
80107abd:	e9 ac 00 00 00       	jmp    80107b6e <deallocuvm+0xc2>

  a = PGROUNDUP(newsz);
80107ac2:	8b 45 10             	mov    0x10(%ebp),%eax
80107ac5:	05 ff 0f 00 00       	add    $0xfff,%eax
80107aca:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80107acf:	89 45 f4             	mov    %eax,-0xc(%ebp)
  for(; a  < oldsz; a += PGSIZE){
80107ad2:	e9 88 00 00 00       	jmp    80107b5f <deallocuvm+0xb3>
    pte = walkpgdir(pgdir, (char*)a, 0);
80107ad7:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107ada:	83 ec 04             	sub    $0x4,%esp
80107add:	6a 00                	push   $0x0
80107adf:	50                   	push   %eax
80107ae0:	ff 75 08             	push   0x8(%ebp)
80107ae3:	e8 a0 f9 ff ff       	call   80107488 <walkpgdir>
80107ae8:	83 c4 10             	add    $0x10,%esp
80107aeb:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(!pte)
80107aee:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80107af2:	75 16                	jne    80107b0a <deallocuvm+0x5e>
      a = PGADDR(PDX(a) + 1, 0, 0) - PGSIZE;
80107af4:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107af7:	c1 e8 16             	shr    $0x16,%eax
80107afa:	83 c0 01             	add    $0x1,%eax
80107afd:	c1 e0 16             	shl    $0x16,%eax
80107b00:	2d 00 10 00 00       	sub    $0x1000,%eax
80107b05:	89 45 f4             	mov    %eax,-0xc(%ebp)
80107b08:	eb 4e                	jmp    80107b58 <deallocuvm+0xac>
    else if((*pte & PTE_P) != 0){
80107b0a:	8b 45 f0             	mov    -0x10(%ebp),%eax
80107b0d:	8b 00                	mov    (%eax),%eax
80107b0f:	83 e0 01             	and    $0x1,%eax
80107b12:	85 c0                	test   %eax,%eax
80107b14:	74 42                	je     80107b58 <deallocuvm+0xac>
      pa = PTE_ADDR(*pte);
80107b16:	8b 45 f0             	mov    -0x10(%ebp),%eax
80107b19:	8b 00                	mov    (%eax),%eax
80107b1b:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80107b20:	89 45 ec             	mov    %eax,-0x14(%ebp)
      if(pa == 0)
80107b23:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
80107b27:	75 0d                	jne    80107b36 <deallocuvm+0x8a>
        panic("kfree");
80107b29:	83 ec 0c             	sub    $0xc,%esp
80107b2c:	68 1d a9 10 80       	push   $0x8010a91d
80107b31:	e8 73 8a ff ff       	call   801005a9 <panic>
      char *v = P2V(pa);
80107b36:	8b 45 ec             	mov    -0x14(%ebp),%eax
80107b39:	05 00 00 00 80       	add    $0x80000000,%eax
80107b3e:	89 45 e8             	mov    %eax,-0x18(%ebp)
      kfree(v);
80107b41:	83 ec 0c             	sub    $0xc,%esp
80107b44:	ff 75 e8             	push   -0x18(%ebp)
80107b47:	e8 ba ab ff ff       	call   80102706 <kfree>
80107b4c:	83 c4 10             	add    $0x10,%esp
      *pte = 0;
80107b4f:	8b 45 f0             	mov    -0x10(%ebp),%eax
80107b52:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  for(; a  < oldsz; a += PGSIZE){
80107b58:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
80107b5f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107b62:	3b 45 0c             	cmp    0xc(%ebp),%eax
80107b65:	0f 82 6c ff ff ff    	jb     80107ad7 <deallocuvm+0x2b>
    }
  }
  return newsz;
80107b6b:	8b 45 10             	mov    0x10(%ebp),%eax
}
80107b6e:	c9                   	leave  
80107b6f:	c3                   	ret    

80107b70 <freevm>:

// Free a page table and all the physical memory pages
// in the user part.
void
freevm(pde_t *pgdir)
{
80107b70:	55                   	push   %ebp
80107b71:	89 e5                	mov    %esp,%ebp
80107b73:	83 ec 18             	sub    $0x18,%esp
  uint i;

  if(pgdir == 0)
80107b76:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
80107b7a:	75 0d                	jne    80107b89 <freevm+0x19>
    panic("freevm: no pgdir");
80107b7c:	83 ec 0c             	sub    $0xc,%esp
80107b7f:	68 23 a9 10 80       	push   $0x8010a923
80107b84:	e8 20 8a ff ff       	call   801005a9 <panic>
  deallocuvm(pgdir, KERNBASE, 0);
80107b89:	83 ec 04             	sub    $0x4,%esp
80107b8c:	6a 00                	push   $0x0
80107b8e:	68 00 00 00 80       	push   $0x80000000
80107b93:	ff 75 08             	push   0x8(%ebp)
80107b96:	e8 11 ff ff ff       	call   80107aac <deallocuvm>
80107b9b:	83 c4 10             	add    $0x10,%esp
  for(i = 0; i < NPDENTRIES; i++){
80107b9e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80107ba5:	eb 48                	jmp    80107bef <freevm+0x7f>
    if(pgdir[i] & PTE_P){
80107ba7:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107baa:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80107bb1:	8b 45 08             	mov    0x8(%ebp),%eax
80107bb4:	01 d0                	add    %edx,%eax
80107bb6:	8b 00                	mov    (%eax),%eax
80107bb8:	83 e0 01             	and    $0x1,%eax
80107bbb:	85 c0                	test   %eax,%eax
80107bbd:	74 2c                	je     80107beb <freevm+0x7b>
      char * v = P2V(PTE_ADDR(pgdir[i]));
80107bbf:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107bc2:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80107bc9:	8b 45 08             	mov    0x8(%ebp),%eax
80107bcc:	01 d0                	add    %edx,%eax
80107bce:	8b 00                	mov    (%eax),%eax
80107bd0:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80107bd5:	05 00 00 00 80       	add    $0x80000000,%eax
80107bda:	89 45 f0             	mov    %eax,-0x10(%ebp)
      kfree(v);
80107bdd:	83 ec 0c             	sub    $0xc,%esp
80107be0:	ff 75 f0             	push   -0x10(%ebp)
80107be3:	e8 1e ab ff ff       	call   80102706 <kfree>
80107be8:	83 c4 10             	add    $0x10,%esp
  for(i = 0; i < NPDENTRIES; i++){
80107beb:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80107bef:	81 7d f4 ff 03 00 00 	cmpl   $0x3ff,-0xc(%ebp)
80107bf6:	76 af                	jbe    80107ba7 <freevm+0x37>
    }
  }
  kfree((char*)pgdir);
80107bf8:	83 ec 0c             	sub    $0xc,%esp
80107bfb:	ff 75 08             	push   0x8(%ebp)
80107bfe:	e8 03 ab ff ff       	call   80102706 <kfree>
80107c03:	83 c4 10             	add    $0x10,%esp
}
80107c06:	90                   	nop
80107c07:	c9                   	leave  
80107c08:	c3                   	ret    

80107c09 <clearpteu>:

// Clear PTE_U on a page. Used to create an inaccessible
// page beneath the user stack.
void
clearpteu(pde_t *pgdir, char *uva)
{
80107c09:	55                   	push   %ebp
80107c0a:	89 e5                	mov    %esp,%ebp
80107c0c:	83 ec 18             	sub    $0x18,%esp
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
80107c0f:	83 ec 04             	sub    $0x4,%esp
80107c12:	6a 00                	push   $0x0
80107c14:	ff 75 0c             	push   0xc(%ebp)
80107c17:	ff 75 08             	push   0x8(%ebp)
80107c1a:	e8 69 f8 ff ff       	call   80107488 <walkpgdir>
80107c1f:	83 c4 10             	add    $0x10,%esp
80107c22:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(pte == 0)
80107c25:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80107c29:	75 0d                	jne    80107c38 <clearpteu+0x2f>
    panic("clearpteu");
80107c2b:	83 ec 0c             	sub    $0xc,%esp
80107c2e:	68 34 a9 10 80       	push   $0x8010a934
80107c33:	e8 71 89 ff ff       	call   801005a9 <panic>
  *pte &= ~PTE_U;
80107c38:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107c3b:	8b 00                	mov    (%eax),%eax
80107c3d:	83 e0 fb             	and    $0xfffffffb,%eax
80107c40:	89 c2                	mov    %eax,%edx
80107c42:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107c45:	89 10                	mov    %edx,(%eax)
}
80107c47:	90                   	nop
80107c48:	c9                   	leave  
80107c49:	c3                   	ret    

80107c4a <copyuvm>:

// Given a parent process's page table, create a copy
// of it for a child.
pde_t*
copyuvm(pde_t *pgdir, uint sz)
{
80107c4a:	55                   	push   %ebp
80107c4b:	89 e5                	mov    %esp,%ebp
80107c4d:	83 ec 28             	sub    $0x28,%esp
  pde_t *d;
  pte_t *pte;
  uint pa, i, flags;
  char *mem;

  if((d = setupkvm()) == 0)
80107c50:	e8 59 f9 ff ff       	call   801075ae <setupkvm>
80107c55:	89 45 f0             	mov    %eax,-0x10(%ebp)
80107c58:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80107c5c:	75 0a                	jne    80107c68 <copyuvm+0x1e>
    return 0;
80107c5e:	b8 00 00 00 00       	mov    $0x0,%eax
80107c63:	e9 eb 00 00 00       	jmp    80107d53 <copyuvm+0x109>
  for(i = 0; i < sz; i += PGSIZE){
80107c68:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80107c6f:	e9 b7 00 00 00       	jmp    80107d2b <copyuvm+0xe1>
    if((pte = walkpgdir(pgdir, (void *) i, 0)) == 0)
80107c74:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107c77:	83 ec 04             	sub    $0x4,%esp
80107c7a:	6a 00                	push   $0x0
80107c7c:	50                   	push   %eax
80107c7d:	ff 75 08             	push   0x8(%ebp)
80107c80:	e8 03 f8 ff ff       	call   80107488 <walkpgdir>
80107c85:	83 c4 10             	add    $0x10,%esp
80107c88:	89 45 ec             	mov    %eax,-0x14(%ebp)
80107c8b:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
80107c8f:	75 0d                	jne    80107c9e <copyuvm+0x54>
      panic("copyuvm: pte should exist");
80107c91:	83 ec 0c             	sub    $0xc,%esp
80107c94:	68 3e a9 10 80       	push   $0x8010a93e
80107c99:	e8 0b 89 ff ff       	call   801005a9 <panic>
    if(!(*pte & PTE_P))
80107c9e:	8b 45 ec             	mov    -0x14(%ebp),%eax
80107ca1:	8b 00                	mov    (%eax),%eax
80107ca3:	83 e0 01             	and    $0x1,%eax
80107ca6:	85 c0                	test   %eax,%eax
80107ca8:	75 0d                	jne    80107cb7 <copyuvm+0x6d>
      panic("copyuvm: page not present");
80107caa:	83 ec 0c             	sub    $0xc,%esp
80107cad:	68 58 a9 10 80       	push   $0x8010a958
80107cb2:	e8 f2 88 ff ff       	call   801005a9 <panic>
    pa = PTE_ADDR(*pte);
80107cb7:	8b 45 ec             	mov    -0x14(%ebp),%eax
80107cba:	8b 00                	mov    (%eax),%eax
80107cbc:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80107cc1:	89 45 e8             	mov    %eax,-0x18(%ebp)
    flags = PTE_FLAGS(*pte);
80107cc4:	8b 45 ec             	mov    -0x14(%ebp),%eax
80107cc7:	8b 00                	mov    (%eax),%eax
80107cc9:	25 ff 0f 00 00       	and    $0xfff,%eax
80107cce:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if((mem = kalloc()) == 0)
80107cd1:	e8 ca aa ff ff       	call   801027a0 <kalloc>
80107cd6:	89 45 e0             	mov    %eax,-0x20(%ebp)
80107cd9:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
80107cdd:	74 5d                	je     80107d3c <copyuvm+0xf2>
      goto bad;
    memmove(mem, (char*)P2V(pa), PGSIZE);
80107cdf:	8b 45 e8             	mov    -0x18(%ebp),%eax
80107ce2:	05 00 00 00 80       	add    $0x80000000,%eax
80107ce7:	83 ec 04             	sub    $0x4,%esp
80107cea:	68 00 10 00 00       	push   $0x1000
80107cef:	50                   	push   %eax
80107cf0:	ff 75 e0             	push   -0x20(%ebp)
80107cf3:	e8 f6 cf ff ff       	call   80104cee <memmove>
80107cf8:	83 c4 10             	add    $0x10,%esp
    if(mappages(d, (void*)i, PGSIZE, V2P(mem), flags) < 0)
80107cfb:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80107cfe:	8b 45 e0             	mov    -0x20(%ebp),%eax
80107d01:	8d 88 00 00 00 80    	lea    -0x80000000(%eax),%ecx
80107d07:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107d0a:	83 ec 0c             	sub    $0xc,%esp
80107d0d:	52                   	push   %edx
80107d0e:	51                   	push   %ecx
80107d0f:	68 00 10 00 00       	push   $0x1000
80107d14:	50                   	push   %eax
80107d15:	ff 75 f0             	push   -0x10(%ebp)
80107d18:	e8 01 f8 ff ff       	call   8010751e <mappages>
80107d1d:	83 c4 20             	add    $0x20,%esp
80107d20:	85 c0                	test   %eax,%eax
80107d22:	78 1b                	js     80107d3f <copyuvm+0xf5>
  for(i = 0; i < sz; i += PGSIZE){
80107d24:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
80107d2b:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107d2e:	3b 45 0c             	cmp    0xc(%ebp),%eax
80107d31:	0f 82 3d ff ff ff    	jb     80107c74 <copyuvm+0x2a>
      goto bad;
  }
  return d;
80107d37:	8b 45 f0             	mov    -0x10(%ebp),%eax
80107d3a:	eb 17                	jmp    80107d53 <copyuvm+0x109>
      goto bad;
80107d3c:	90                   	nop
80107d3d:	eb 01                	jmp    80107d40 <copyuvm+0xf6>
      goto bad;
80107d3f:	90                   	nop

bad:
  freevm(d);
80107d40:	83 ec 0c             	sub    $0xc,%esp
80107d43:	ff 75 f0             	push   -0x10(%ebp)
80107d46:	e8 25 fe ff ff       	call   80107b70 <freevm>
80107d4b:	83 c4 10             	add    $0x10,%esp
  return 0;
80107d4e:	b8 00 00 00 00       	mov    $0x0,%eax
}
80107d53:	c9                   	leave  
80107d54:	c3                   	ret    

80107d55 <uva2ka>:

//PAGEBREAK!
// Map user virtual address to kernel address.
char*
uva2ka(pde_t *pgdir, char *uva)
{
80107d55:	55                   	push   %ebp
80107d56:	89 e5                	mov    %esp,%ebp
80107d58:	83 ec 18             	sub    $0x18,%esp
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
80107d5b:	83 ec 04             	sub    $0x4,%esp
80107d5e:	6a 00                	push   $0x0
80107d60:	ff 75 0c             	push   0xc(%ebp)
80107d63:	ff 75 08             	push   0x8(%ebp)
80107d66:	e8 1d f7 ff ff       	call   80107488 <walkpgdir>
80107d6b:	83 c4 10             	add    $0x10,%esp
80107d6e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if((*pte & PTE_P) == 0)
80107d71:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107d74:	8b 00                	mov    (%eax),%eax
80107d76:	83 e0 01             	and    $0x1,%eax
80107d79:	85 c0                	test   %eax,%eax
80107d7b:	75 07                	jne    80107d84 <uva2ka+0x2f>
    return 0;
80107d7d:	b8 00 00 00 00       	mov    $0x0,%eax
80107d82:	eb 22                	jmp    80107da6 <uva2ka+0x51>
  if((*pte & PTE_U) == 0)
80107d84:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107d87:	8b 00                	mov    (%eax),%eax
80107d89:	83 e0 04             	and    $0x4,%eax
80107d8c:	85 c0                	test   %eax,%eax
80107d8e:	75 07                	jne    80107d97 <uva2ka+0x42>
    return 0;
80107d90:	b8 00 00 00 00       	mov    $0x0,%eax
80107d95:	eb 0f                	jmp    80107da6 <uva2ka+0x51>
  return (char*)P2V(PTE_ADDR(*pte));
80107d97:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107d9a:	8b 00                	mov    (%eax),%eax
80107d9c:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80107da1:	05 00 00 00 80       	add    $0x80000000,%eax
}
80107da6:	c9                   	leave  
80107da7:	c3                   	ret    

80107da8 <copyout>:
// Copy len bytes from p to user address va in page table pgdir.
// Most useful when pgdir is not the current page table.
// uva2ka ensures this only works for PTE_U pages.
int
copyout(pde_t *pgdir, uint va, void *p, uint len)
{
80107da8:	55                   	push   %ebp
80107da9:	89 e5                	mov    %esp,%ebp
80107dab:	83 ec 18             	sub    $0x18,%esp
  char *buf, *pa0;
  uint n, va0;

  buf = (char*)p;
80107dae:	8b 45 10             	mov    0x10(%ebp),%eax
80107db1:	89 45 f4             	mov    %eax,-0xc(%ebp)
  while(len > 0){
80107db4:	eb 7f                	jmp    80107e35 <copyout+0x8d>
    va0 = (uint)PGROUNDDOWN(va);
80107db6:	8b 45 0c             	mov    0xc(%ebp),%eax
80107db9:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80107dbe:	89 45 ec             	mov    %eax,-0x14(%ebp)
    pa0 = uva2ka(pgdir, (char*)va0);
80107dc1:	8b 45 ec             	mov    -0x14(%ebp),%eax
80107dc4:	83 ec 08             	sub    $0x8,%esp
80107dc7:	50                   	push   %eax
80107dc8:	ff 75 08             	push   0x8(%ebp)
80107dcb:	e8 85 ff ff ff       	call   80107d55 <uva2ka>
80107dd0:	83 c4 10             	add    $0x10,%esp
80107dd3:	89 45 e8             	mov    %eax,-0x18(%ebp)
    if(pa0 == 0)
80107dd6:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
80107dda:	75 07                	jne    80107de3 <copyout+0x3b>
      return -1;
80107ddc:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80107de1:	eb 61                	jmp    80107e44 <copyout+0x9c>
    n = PGSIZE - (va - va0);
80107de3:	8b 45 ec             	mov    -0x14(%ebp),%eax
80107de6:	2b 45 0c             	sub    0xc(%ebp),%eax
80107de9:	05 00 10 00 00       	add    $0x1000,%eax
80107dee:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(n > len)
80107df1:	8b 45 f0             	mov    -0x10(%ebp),%eax
80107df4:	3b 45 14             	cmp    0x14(%ebp),%eax
80107df7:	76 06                	jbe    80107dff <copyout+0x57>
      n = len;
80107df9:	8b 45 14             	mov    0x14(%ebp),%eax
80107dfc:	89 45 f0             	mov    %eax,-0x10(%ebp)
    memmove(pa0 + (va - va0), buf, n);
80107dff:	8b 45 0c             	mov    0xc(%ebp),%eax
80107e02:	2b 45 ec             	sub    -0x14(%ebp),%eax
80107e05:	89 c2                	mov    %eax,%edx
80107e07:	8b 45 e8             	mov    -0x18(%ebp),%eax
80107e0a:	01 d0                	add    %edx,%eax
80107e0c:	83 ec 04             	sub    $0x4,%esp
80107e0f:	ff 75 f0             	push   -0x10(%ebp)
80107e12:	ff 75 f4             	push   -0xc(%ebp)
80107e15:	50                   	push   %eax
80107e16:	e8 d3 ce ff ff       	call   80104cee <memmove>
80107e1b:	83 c4 10             	add    $0x10,%esp
    len -= n;
80107e1e:	8b 45 f0             	mov    -0x10(%ebp),%eax
80107e21:	29 45 14             	sub    %eax,0x14(%ebp)
    buf += n;
80107e24:	8b 45 f0             	mov    -0x10(%ebp),%eax
80107e27:	01 45 f4             	add    %eax,-0xc(%ebp)
    va = va0 + PGSIZE;
80107e2a:	8b 45 ec             	mov    -0x14(%ebp),%eax
80107e2d:	05 00 10 00 00       	add    $0x1000,%eax
80107e32:	89 45 0c             	mov    %eax,0xc(%ebp)
  while(len > 0){
80107e35:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
80107e39:	0f 85 77 ff ff ff    	jne    80107db6 <copyout+0xe>
  }
  return 0;
80107e3f:	b8 00 00 00 00       	mov    $0x0,%eax
}
80107e44:	c9                   	leave  
80107e45:	c3                   	ret    

80107e46 <mpinit_uefi>:

struct cpu cpus[NCPU];
int ncpu;
uchar ioapicid;
void mpinit_uefi(void)
{
80107e46:	55                   	push   %ebp
80107e47:	89 e5                	mov    %esp,%ebp
80107e49:	83 ec 20             	sub    $0x20,%esp
  struct boot_param *boot_param = (struct boot_param *)P2V_WO(BOOTPARAM);
80107e4c:	c7 45 f8 00 00 05 80 	movl   $0x80050000,-0x8(%ebp)
  struct uefi_madt *madt = (struct uefi_madt*)(P2V_WO(boot_param->madt_addr));
80107e53:	8b 45 f8             	mov    -0x8(%ebp),%eax
80107e56:	8b 40 08             	mov    0x8(%eax),%eax
80107e59:	05 00 00 00 80       	add    $0x80000000,%eax
80107e5e:	89 45 f4             	mov    %eax,-0xc(%ebp)

  uint i=sizeof(struct uefi_madt);
80107e61:	c7 45 fc 2c 00 00 00 	movl   $0x2c,-0x4(%ebp)
  struct uefi_lapic *lapic_entry;
  struct uefi_ioapic *ioapic;
  struct uefi_iso *iso;
  struct uefi_non_maskable_intr *non_mask_intr; 
  
  lapic = (uint *)(madt->lapic_addr);
80107e68:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107e6b:	8b 40 24             	mov    0x24(%eax),%eax
80107e6e:	a3 00 41 19 80       	mov    %eax,0x80194100
  ncpu = 0;
80107e73:	c7 05 40 6e 19 80 00 	movl   $0x0,0x80196e40
80107e7a:	00 00 00 

  while(i<madt->len){
80107e7d:	90                   	nop
80107e7e:	e9 bd 00 00 00       	jmp    80107f40 <mpinit_uefi+0xfa>
    uchar *entry_type = ((uchar *)madt)+i;
80107e83:	8b 55 f4             	mov    -0xc(%ebp),%edx
80107e86:	8b 45 fc             	mov    -0x4(%ebp),%eax
80107e89:	01 d0                	add    %edx,%eax
80107e8b:	89 45 f0             	mov    %eax,-0x10(%ebp)
    switch(*entry_type){
80107e8e:	8b 45 f0             	mov    -0x10(%ebp),%eax
80107e91:	0f b6 00             	movzbl (%eax),%eax
80107e94:	0f b6 c0             	movzbl %al,%eax
80107e97:	83 f8 05             	cmp    $0x5,%eax
80107e9a:	0f 87 a0 00 00 00    	ja     80107f40 <mpinit_uefi+0xfa>
80107ea0:	8b 04 85 74 a9 10 80 	mov    -0x7fef568c(,%eax,4),%eax
80107ea7:	ff e0                	jmp    *%eax
      case 0:
        lapic_entry = (struct uefi_lapic *)entry_type;
80107ea9:	8b 45 f0             	mov    -0x10(%ebp),%eax
80107eac:	89 45 e0             	mov    %eax,-0x20(%ebp)
        if(ncpu < NCPU) {
80107eaf:	a1 40 6e 19 80       	mov    0x80196e40,%eax
80107eb4:	83 f8 03             	cmp    $0x3,%eax
80107eb7:	7f 28                	jg     80107ee1 <mpinit_uefi+0x9b>
          cpus[ncpu].apicid = lapic_entry->lapic_id;
80107eb9:	8b 15 40 6e 19 80    	mov    0x80196e40,%edx
80107ebf:	8b 45 e0             	mov    -0x20(%ebp),%eax
80107ec2:	0f b6 40 03          	movzbl 0x3(%eax),%eax
80107ec6:	69 d2 b0 00 00 00    	imul   $0xb0,%edx,%edx
80107ecc:	81 c2 80 6b 19 80    	add    $0x80196b80,%edx
80107ed2:	88 02                	mov    %al,(%edx)
          ncpu++;
80107ed4:	a1 40 6e 19 80       	mov    0x80196e40,%eax
80107ed9:	83 c0 01             	add    $0x1,%eax
80107edc:	a3 40 6e 19 80       	mov    %eax,0x80196e40
        }
        i += lapic_entry->record_len;
80107ee1:	8b 45 e0             	mov    -0x20(%ebp),%eax
80107ee4:	0f b6 40 01          	movzbl 0x1(%eax),%eax
80107ee8:	0f b6 c0             	movzbl %al,%eax
80107eeb:	01 45 fc             	add    %eax,-0x4(%ebp)
        break;
80107eee:	eb 50                	jmp    80107f40 <mpinit_uefi+0xfa>

      case 1:
        ioapic = (struct uefi_ioapic *)entry_type;
80107ef0:	8b 45 f0             	mov    -0x10(%ebp),%eax
80107ef3:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        ioapicid = ioapic->ioapic_id;
80107ef6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80107ef9:	0f b6 40 02          	movzbl 0x2(%eax),%eax
80107efd:	a2 44 6e 19 80       	mov    %al,0x80196e44
        i += ioapic->record_len;
80107f02:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80107f05:	0f b6 40 01          	movzbl 0x1(%eax),%eax
80107f09:	0f b6 c0             	movzbl %al,%eax
80107f0c:	01 45 fc             	add    %eax,-0x4(%ebp)
        break;
80107f0f:	eb 2f                	jmp    80107f40 <mpinit_uefi+0xfa>

      case 2:
        iso = (struct uefi_iso *)entry_type;
80107f11:	8b 45 f0             	mov    -0x10(%ebp),%eax
80107f14:	89 45 e8             	mov    %eax,-0x18(%ebp)
        i += iso->record_len;
80107f17:	8b 45 e8             	mov    -0x18(%ebp),%eax
80107f1a:	0f b6 40 01          	movzbl 0x1(%eax),%eax
80107f1e:	0f b6 c0             	movzbl %al,%eax
80107f21:	01 45 fc             	add    %eax,-0x4(%ebp)
        break;
80107f24:	eb 1a                	jmp    80107f40 <mpinit_uefi+0xfa>

      case 4:
        non_mask_intr = (struct uefi_non_maskable_intr *)entry_type;
80107f26:	8b 45 f0             	mov    -0x10(%ebp),%eax
80107f29:	89 45 ec             	mov    %eax,-0x14(%ebp)
        i += non_mask_intr->record_len;
80107f2c:	8b 45 ec             	mov    -0x14(%ebp),%eax
80107f2f:	0f b6 40 01          	movzbl 0x1(%eax),%eax
80107f33:	0f b6 c0             	movzbl %al,%eax
80107f36:	01 45 fc             	add    %eax,-0x4(%ebp)
        break;
80107f39:	eb 05                	jmp    80107f40 <mpinit_uefi+0xfa>

      case 5:
        i = i + 0xC;
80107f3b:	83 45 fc 0c          	addl   $0xc,-0x4(%ebp)
        break;
80107f3f:	90                   	nop
  while(i<madt->len){
80107f40:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107f43:	8b 40 04             	mov    0x4(%eax),%eax
80107f46:	39 45 fc             	cmp    %eax,-0x4(%ebp)
80107f49:	0f 82 34 ff ff ff    	jb     80107e83 <mpinit_uefi+0x3d>
    }
  }

}
80107f4f:	90                   	nop
80107f50:	90                   	nop
80107f51:	c9                   	leave  
80107f52:	c3                   	ret    

80107f53 <inb>:
{
80107f53:	55                   	push   %ebp
80107f54:	89 e5                	mov    %esp,%ebp
80107f56:	83 ec 14             	sub    $0x14,%esp
80107f59:	8b 45 08             	mov    0x8(%ebp),%eax
80107f5c:	66 89 45 ec          	mov    %ax,-0x14(%ebp)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80107f60:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
80107f64:	89 c2                	mov    %eax,%edx
80107f66:	ec                   	in     (%dx),%al
80107f67:	88 45 ff             	mov    %al,-0x1(%ebp)
  return data;
80107f6a:	0f b6 45 ff          	movzbl -0x1(%ebp),%eax
}
80107f6e:	c9                   	leave  
80107f6f:	c3                   	ret    

80107f70 <outb>:
{
80107f70:	55                   	push   %ebp
80107f71:	89 e5                	mov    %esp,%ebp
80107f73:	83 ec 08             	sub    $0x8,%esp
80107f76:	8b 45 08             	mov    0x8(%ebp),%eax
80107f79:	8b 55 0c             	mov    0xc(%ebp),%edx
80107f7c:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
80107f80:	89 d0                	mov    %edx,%eax
80107f82:	88 45 f8             	mov    %al,-0x8(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80107f85:	0f b6 45 f8          	movzbl -0x8(%ebp),%eax
80107f89:	0f b7 55 fc          	movzwl -0x4(%ebp),%edx
80107f8d:	ee                   	out    %al,(%dx)
}
80107f8e:	90                   	nop
80107f8f:	c9                   	leave  
80107f90:	c3                   	ret    

80107f91 <uart_debug>:
#include "proc.h"
#include "x86.h"

#define COM1    0x3f8

void uart_debug(char p){
80107f91:	55                   	push   %ebp
80107f92:	89 e5                	mov    %esp,%ebp
80107f94:	83 ec 28             	sub    $0x28,%esp
80107f97:	8b 45 08             	mov    0x8(%ebp),%eax
80107f9a:	88 45 e4             	mov    %al,-0x1c(%ebp)
    // Turn off the FIFO
  outb(COM1+2, 0);
80107f9d:	6a 00                	push   $0x0
80107f9f:	68 fa 03 00 00       	push   $0x3fa
80107fa4:	e8 c7 ff ff ff       	call   80107f70 <outb>
80107fa9:	83 c4 08             	add    $0x8,%esp

  // 9600 baud, 8 data bits, 1 stop bit, parity off.
  outb(COM1+3, 0x80);    // Unlock divisor
80107fac:	68 80 00 00 00       	push   $0x80
80107fb1:	68 fb 03 00 00       	push   $0x3fb
80107fb6:	e8 b5 ff ff ff       	call   80107f70 <outb>
80107fbb:	83 c4 08             	add    $0x8,%esp
  outb(COM1+0, 115200/9600);
80107fbe:	6a 0c                	push   $0xc
80107fc0:	68 f8 03 00 00       	push   $0x3f8
80107fc5:	e8 a6 ff ff ff       	call   80107f70 <outb>
80107fca:	83 c4 08             	add    $0x8,%esp
  outb(COM1+1, 0);
80107fcd:	6a 00                	push   $0x0
80107fcf:	68 f9 03 00 00       	push   $0x3f9
80107fd4:	e8 97 ff ff ff       	call   80107f70 <outb>
80107fd9:	83 c4 08             	add    $0x8,%esp
  outb(COM1+3, 0x03);    // Lock divisor, 8 data bits.
80107fdc:	6a 03                	push   $0x3
80107fde:	68 fb 03 00 00       	push   $0x3fb
80107fe3:	e8 88 ff ff ff       	call   80107f70 <outb>
80107fe8:	83 c4 08             	add    $0x8,%esp
  outb(COM1+4, 0);
80107feb:	6a 00                	push   $0x0
80107fed:	68 fc 03 00 00       	push   $0x3fc
80107ff2:	e8 79 ff ff ff       	call   80107f70 <outb>
80107ff7:	83 c4 08             	add    $0x8,%esp

  for(int i=0;i<128 && !(inb(COM1+5) & 0x20); i++) microdelay(10);
80107ffa:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80108001:	eb 11                	jmp    80108014 <uart_debug+0x83>
80108003:	83 ec 0c             	sub    $0xc,%esp
80108006:	6a 0a                	push   $0xa
80108008:	e8 2a ab ff ff       	call   80102b37 <microdelay>
8010800d:	83 c4 10             	add    $0x10,%esp
80108010:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80108014:	83 7d f4 7f          	cmpl   $0x7f,-0xc(%ebp)
80108018:	7f 1a                	jg     80108034 <uart_debug+0xa3>
8010801a:	83 ec 0c             	sub    $0xc,%esp
8010801d:	68 fd 03 00 00       	push   $0x3fd
80108022:	e8 2c ff ff ff       	call   80107f53 <inb>
80108027:	83 c4 10             	add    $0x10,%esp
8010802a:	0f b6 c0             	movzbl %al,%eax
8010802d:	83 e0 20             	and    $0x20,%eax
80108030:	85 c0                	test   %eax,%eax
80108032:	74 cf                	je     80108003 <uart_debug+0x72>
  outb(COM1+0, p);
80108034:	0f b6 45 e4          	movzbl -0x1c(%ebp),%eax
80108038:	0f b6 c0             	movzbl %al,%eax
8010803b:	83 ec 08             	sub    $0x8,%esp
8010803e:	50                   	push   %eax
8010803f:	68 f8 03 00 00       	push   $0x3f8
80108044:	e8 27 ff ff ff       	call   80107f70 <outb>
80108049:	83 c4 10             	add    $0x10,%esp
}
8010804c:	90                   	nop
8010804d:	c9                   	leave  
8010804e:	c3                   	ret    

8010804f <uart_debugs>:

void uart_debugs(char *p){
8010804f:	55                   	push   %ebp
80108050:	89 e5                	mov    %esp,%ebp
80108052:	83 ec 08             	sub    $0x8,%esp
  while(*p){
80108055:	eb 1b                	jmp    80108072 <uart_debugs+0x23>
    uart_debug(*p++);
80108057:	8b 45 08             	mov    0x8(%ebp),%eax
8010805a:	8d 50 01             	lea    0x1(%eax),%edx
8010805d:	89 55 08             	mov    %edx,0x8(%ebp)
80108060:	0f b6 00             	movzbl (%eax),%eax
80108063:	0f be c0             	movsbl %al,%eax
80108066:	83 ec 0c             	sub    $0xc,%esp
80108069:	50                   	push   %eax
8010806a:	e8 22 ff ff ff       	call   80107f91 <uart_debug>
8010806f:	83 c4 10             	add    $0x10,%esp
  while(*p){
80108072:	8b 45 08             	mov    0x8(%ebp),%eax
80108075:	0f b6 00             	movzbl (%eax),%eax
80108078:	84 c0                	test   %al,%al
8010807a:	75 db                	jne    80108057 <uart_debugs+0x8>
  }
}
8010807c:	90                   	nop
8010807d:	90                   	nop
8010807e:	c9                   	leave  
8010807f:	c3                   	ret    

80108080 <graphic_init>:
 * i%4 = 2 : red
 * i%4 = 3 : black
 */

struct gpu gpu;
void graphic_init(){
80108080:	55                   	push   %ebp
80108081:	89 e5                	mov    %esp,%ebp
80108083:	83 ec 10             	sub    $0x10,%esp
  struct boot_param *boot_param = (struct boot_param *)P2V_WO(BOOTPARAM);
80108086:	c7 45 fc 00 00 05 80 	movl   $0x80050000,-0x4(%ebp)
  gpu.pvram_addr = boot_param->graphic_config.frame_base;
8010808d:	8b 45 fc             	mov    -0x4(%ebp),%eax
80108090:	8b 50 14             	mov    0x14(%eax),%edx
80108093:	8b 40 10             	mov    0x10(%eax),%eax
80108096:	a3 48 6e 19 80       	mov    %eax,0x80196e48
  gpu.vram_size = boot_param->graphic_config.frame_size;
8010809b:	8b 45 fc             	mov    -0x4(%ebp),%eax
8010809e:	8b 50 1c             	mov    0x1c(%eax),%edx
801080a1:	8b 40 18             	mov    0x18(%eax),%eax
801080a4:	a3 50 6e 19 80       	mov    %eax,0x80196e50
  gpu.vvram_addr = DEVSPACE - gpu.vram_size;
801080a9:	8b 15 50 6e 19 80    	mov    0x80196e50,%edx
801080af:	b8 00 00 00 fe       	mov    $0xfe000000,%eax
801080b4:	29 d0                	sub    %edx,%eax
801080b6:	a3 4c 6e 19 80       	mov    %eax,0x80196e4c
  gpu.horizontal_resolution = (uint)(boot_param->graphic_config.horizontal_resolution & 0xFFFFFFFF);
801080bb:	8b 45 fc             	mov    -0x4(%ebp),%eax
801080be:	8b 50 24             	mov    0x24(%eax),%edx
801080c1:	8b 40 20             	mov    0x20(%eax),%eax
801080c4:	a3 54 6e 19 80       	mov    %eax,0x80196e54
  gpu.vertical_resolution = (uint)(boot_param->graphic_config.vertical_resolution & 0xFFFFFFFF);
801080c9:	8b 45 fc             	mov    -0x4(%ebp),%eax
801080cc:	8b 50 2c             	mov    0x2c(%eax),%edx
801080cf:	8b 40 28             	mov    0x28(%eax),%eax
801080d2:	a3 58 6e 19 80       	mov    %eax,0x80196e58
  gpu.pixels_per_line = (uint)(boot_param->graphic_config.pixels_per_line & 0xFFFFFFFF);
801080d7:	8b 45 fc             	mov    -0x4(%ebp),%eax
801080da:	8b 50 34             	mov    0x34(%eax),%edx
801080dd:	8b 40 30             	mov    0x30(%eax),%eax
801080e0:	a3 5c 6e 19 80       	mov    %eax,0x80196e5c
}
801080e5:	90                   	nop
801080e6:	c9                   	leave  
801080e7:	c3                   	ret    

801080e8 <graphic_draw_pixel>:

void graphic_draw_pixel(int x,int y,struct graphic_pixel * buffer){
801080e8:	55                   	push   %ebp
801080e9:	89 e5                	mov    %esp,%ebp
801080eb:	83 ec 10             	sub    $0x10,%esp
  int pixel_addr = (sizeof(struct graphic_pixel))*(y*gpu.pixels_per_line + x);
801080ee:	8b 15 5c 6e 19 80    	mov    0x80196e5c,%edx
801080f4:	8b 45 0c             	mov    0xc(%ebp),%eax
801080f7:	0f af d0             	imul   %eax,%edx
801080fa:	8b 45 08             	mov    0x8(%ebp),%eax
801080fd:	01 d0                	add    %edx,%eax
801080ff:	c1 e0 02             	shl    $0x2,%eax
80108102:	89 45 fc             	mov    %eax,-0x4(%ebp)
  struct graphic_pixel *pixel = (struct graphic_pixel *)(gpu.vvram_addr + pixel_addr);
80108105:	8b 15 4c 6e 19 80    	mov    0x80196e4c,%edx
8010810b:	8b 45 fc             	mov    -0x4(%ebp),%eax
8010810e:	01 d0                	add    %edx,%eax
80108110:	89 45 f8             	mov    %eax,-0x8(%ebp)
  pixel->blue = buffer->blue;
80108113:	8b 45 10             	mov    0x10(%ebp),%eax
80108116:	0f b6 10             	movzbl (%eax),%edx
80108119:	8b 45 f8             	mov    -0x8(%ebp),%eax
8010811c:	88 10                	mov    %dl,(%eax)
  pixel->green = buffer->green;
8010811e:	8b 45 10             	mov    0x10(%ebp),%eax
80108121:	0f b6 50 01          	movzbl 0x1(%eax),%edx
80108125:	8b 45 f8             	mov    -0x8(%ebp),%eax
80108128:	88 50 01             	mov    %dl,0x1(%eax)
  pixel->red = buffer->red;
8010812b:	8b 45 10             	mov    0x10(%ebp),%eax
8010812e:	0f b6 50 02          	movzbl 0x2(%eax),%edx
80108132:	8b 45 f8             	mov    -0x8(%ebp),%eax
80108135:	88 50 02             	mov    %dl,0x2(%eax)
}
80108138:	90                   	nop
80108139:	c9                   	leave  
8010813a:	c3                   	ret    

8010813b <graphic_scroll_up>:

void graphic_scroll_up(int height){
8010813b:	55                   	push   %ebp
8010813c:	89 e5                	mov    %esp,%ebp
8010813e:	83 ec 18             	sub    $0x18,%esp
  int addr_diff = (sizeof(struct graphic_pixel))*gpu.pixels_per_line*height;
80108141:	8b 15 5c 6e 19 80    	mov    0x80196e5c,%edx
80108147:	8b 45 08             	mov    0x8(%ebp),%eax
8010814a:	0f af c2             	imul   %edx,%eax
8010814d:	c1 e0 02             	shl    $0x2,%eax
80108150:	89 45 f4             	mov    %eax,-0xc(%ebp)
  memmove((unsigned int *)gpu.vvram_addr,(unsigned int *)(gpu.vvram_addr + addr_diff),gpu.vram_size - addr_diff);
80108153:	a1 50 6e 19 80       	mov    0x80196e50,%eax
80108158:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010815b:	29 d0                	sub    %edx,%eax
8010815d:	8b 0d 4c 6e 19 80    	mov    0x80196e4c,%ecx
80108163:	8b 55 f4             	mov    -0xc(%ebp),%edx
80108166:	01 ca                	add    %ecx,%edx
80108168:	89 d1                	mov    %edx,%ecx
8010816a:	8b 15 4c 6e 19 80    	mov    0x80196e4c,%edx
80108170:	83 ec 04             	sub    $0x4,%esp
80108173:	50                   	push   %eax
80108174:	51                   	push   %ecx
80108175:	52                   	push   %edx
80108176:	e8 73 cb ff ff       	call   80104cee <memmove>
8010817b:	83 c4 10             	add    $0x10,%esp
  memset((unsigned int *)(gpu.vvram_addr + gpu.vram_size - addr_diff),0,addr_diff);
8010817e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108181:	8b 0d 4c 6e 19 80    	mov    0x80196e4c,%ecx
80108187:	8b 15 50 6e 19 80    	mov    0x80196e50,%edx
8010818d:	01 ca                	add    %ecx,%edx
8010818f:	8b 4d f4             	mov    -0xc(%ebp),%ecx
80108192:	29 ca                	sub    %ecx,%edx
80108194:	83 ec 04             	sub    $0x4,%esp
80108197:	50                   	push   %eax
80108198:	6a 00                	push   $0x0
8010819a:	52                   	push   %edx
8010819b:	e8 8f ca ff ff       	call   80104c2f <memset>
801081a0:	83 c4 10             	add    $0x10,%esp
}
801081a3:	90                   	nop
801081a4:	c9                   	leave  
801081a5:	c3                   	ret    

801081a6 <font_render>:
801081a6:	55                   	push   %ebp
801081a7:	89 e5                	mov    %esp,%ebp
801081a9:	53                   	push   %ebx
801081aa:	83 ec 14             	sub    $0x14,%esp
801081ad:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
801081b4:	e9 b1 00 00 00       	jmp    8010826a <font_render+0xc4>
801081b9:	c7 45 f0 0e 00 00 00 	movl   $0xe,-0x10(%ebp)
801081c0:	e9 97 00 00 00       	jmp    8010825c <font_render+0xb6>
801081c5:	8b 45 10             	mov    0x10(%ebp),%eax
801081c8:	83 e8 20             	sub    $0x20,%eax
801081cb:	6b d0 1e             	imul   $0x1e,%eax,%edx
801081ce:	8b 45 f4             	mov    -0xc(%ebp),%eax
801081d1:	01 d0                	add    %edx,%eax
801081d3:	0f b7 84 00 a0 a9 10 	movzwl -0x7fef5660(%eax,%eax,1),%eax
801081da:	80 
801081db:	0f b7 d0             	movzwl %ax,%edx
801081de:	8b 45 f0             	mov    -0x10(%ebp),%eax
801081e1:	bb 01 00 00 00       	mov    $0x1,%ebx
801081e6:	89 c1                	mov    %eax,%ecx
801081e8:	d3 e3                	shl    %cl,%ebx
801081ea:	89 d8                	mov    %ebx,%eax
801081ec:	21 d0                	and    %edx,%eax
801081ee:	89 45 ec             	mov    %eax,-0x14(%ebp)
801081f1:	8b 45 f0             	mov    -0x10(%ebp),%eax
801081f4:	ba 01 00 00 00       	mov    $0x1,%edx
801081f9:	89 c1                	mov    %eax,%ecx
801081fb:	d3 e2                	shl    %cl,%edx
801081fd:	89 d0                	mov    %edx,%eax
801081ff:	39 45 ec             	cmp    %eax,-0x14(%ebp)
80108202:	75 2b                	jne    8010822f <font_render+0x89>
80108204:	8b 55 0c             	mov    0xc(%ebp),%edx
80108207:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010820a:	01 c2                	add    %eax,%edx
8010820c:	b8 0e 00 00 00       	mov    $0xe,%eax
80108211:	2b 45 f0             	sub    -0x10(%ebp),%eax
80108214:	89 c1                	mov    %eax,%ecx
80108216:	8b 45 08             	mov    0x8(%ebp),%eax
80108219:	01 c8                	add    %ecx,%eax
8010821b:	83 ec 04             	sub    $0x4,%esp
8010821e:	68 00 f5 10 80       	push   $0x8010f500
80108223:	52                   	push   %edx
80108224:	50                   	push   %eax
80108225:	e8 be fe ff ff       	call   801080e8 <graphic_draw_pixel>
8010822a:	83 c4 10             	add    $0x10,%esp
8010822d:	eb 29                	jmp    80108258 <font_render+0xb2>
8010822f:	8b 55 0c             	mov    0xc(%ebp),%edx
80108232:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108235:	01 c2                	add    %eax,%edx
80108237:	b8 0e 00 00 00       	mov    $0xe,%eax
8010823c:	2b 45 f0             	sub    -0x10(%ebp),%eax
8010823f:	89 c1                	mov    %eax,%ecx
80108241:	8b 45 08             	mov    0x8(%ebp),%eax
80108244:	01 c8                	add    %ecx,%eax
80108246:	83 ec 04             	sub    $0x4,%esp
80108249:	68 60 6e 19 80       	push   $0x80196e60
8010824e:	52                   	push   %edx
8010824f:	50                   	push   %eax
80108250:	e8 93 fe ff ff       	call   801080e8 <graphic_draw_pixel>
80108255:	83 c4 10             	add    $0x10,%esp
80108258:	83 6d f0 01          	subl   $0x1,-0x10(%ebp)
8010825c:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80108260:	0f 89 5f ff ff ff    	jns    801081c5 <font_render+0x1f>
80108266:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
8010826a:	83 7d f4 1d          	cmpl   $0x1d,-0xc(%ebp)
8010826e:	0f 8e 45 ff ff ff    	jle    801081b9 <font_render+0x13>
80108274:	90                   	nop
80108275:	90                   	nop
80108276:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80108279:	c9                   	leave  
8010827a:	c3                   	ret    

8010827b <font_render_string>:
8010827b:	55                   	push   %ebp
8010827c:	89 e5                	mov    %esp,%ebp
8010827e:	53                   	push   %ebx
8010827f:	83 ec 14             	sub    $0x14,%esp
80108282:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80108289:	eb 33                	jmp    801082be <font_render_string+0x43>
8010828b:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010828e:	8b 45 08             	mov    0x8(%ebp),%eax
80108291:	01 d0                	add    %edx,%eax
80108293:	0f b6 00             	movzbl (%eax),%eax
80108296:	0f be c8             	movsbl %al,%ecx
80108299:	8b 45 0c             	mov    0xc(%ebp),%eax
8010829c:	6b d0 1e             	imul   $0x1e,%eax,%edx
8010829f:	8b 5d f4             	mov    -0xc(%ebp),%ebx
801082a2:	89 d8                	mov    %ebx,%eax
801082a4:	c1 e0 04             	shl    $0x4,%eax
801082a7:	29 d8                	sub    %ebx,%eax
801082a9:	83 c0 02             	add    $0x2,%eax
801082ac:	83 ec 04             	sub    $0x4,%esp
801082af:	51                   	push   %ecx
801082b0:	52                   	push   %edx
801082b1:	50                   	push   %eax
801082b2:	e8 ef fe ff ff       	call   801081a6 <font_render>
801082b7:	83 c4 10             	add    $0x10,%esp
801082ba:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
801082be:	8b 55 f4             	mov    -0xc(%ebp),%edx
801082c1:	8b 45 08             	mov    0x8(%ebp),%eax
801082c4:	01 d0                	add    %edx,%eax
801082c6:	0f b6 00             	movzbl (%eax),%eax
801082c9:	84 c0                	test   %al,%al
801082cb:	74 06                	je     801082d3 <font_render_string+0x58>
801082cd:	83 7d f4 33          	cmpl   $0x33,-0xc(%ebp)
801082d1:	7e b8                	jle    8010828b <font_render_string+0x10>
801082d3:	90                   	nop
801082d4:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801082d7:	c9                   	leave  
801082d8:	c3                   	ret    

801082d9 <pci_init>:
#include "pci.h"
#include "defs.h"
#include "types.h"
#include "i8254.h"

void pci_init(){
801082d9:	55                   	push   %ebp
801082da:	89 e5                	mov    %esp,%ebp
801082dc:	53                   	push   %ebx
801082dd:	83 ec 14             	sub    $0x14,%esp
  uint data;
  for(int i=0;i<256;i++){
801082e0:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
801082e7:	eb 6b                	jmp    80108354 <pci_init+0x7b>
    for(int j=0;j<32;j++){
801082e9:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
801082f0:	eb 58                	jmp    8010834a <pci_init+0x71>
      for(int k=0;k<8;k++){
801082f2:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
801082f9:	eb 45                	jmp    80108340 <pci_init+0x67>
      pci_access_config(i,j,k,0,&data);
801082fb:	8b 4d ec             	mov    -0x14(%ebp),%ecx
801082fe:	8b 55 f0             	mov    -0x10(%ebp),%edx
80108301:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108304:	83 ec 0c             	sub    $0xc,%esp
80108307:	8d 5d e8             	lea    -0x18(%ebp),%ebx
8010830a:	53                   	push   %ebx
8010830b:	6a 00                	push   $0x0
8010830d:	51                   	push   %ecx
8010830e:	52                   	push   %edx
8010830f:	50                   	push   %eax
80108310:	e8 b0 00 00 00       	call   801083c5 <pci_access_config>
80108315:	83 c4 20             	add    $0x20,%esp
      if((data&0xFFFF) != 0xFFFF){
80108318:	8b 45 e8             	mov    -0x18(%ebp),%eax
8010831b:	0f b7 c0             	movzwl %ax,%eax
8010831e:	3d ff ff 00 00       	cmp    $0xffff,%eax
80108323:	74 17                	je     8010833c <pci_init+0x63>
        pci_init_device(i,j,k);
80108325:	8b 4d ec             	mov    -0x14(%ebp),%ecx
80108328:	8b 55 f0             	mov    -0x10(%ebp),%edx
8010832b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010832e:	83 ec 04             	sub    $0x4,%esp
80108331:	51                   	push   %ecx
80108332:	52                   	push   %edx
80108333:	50                   	push   %eax
80108334:	e8 37 01 00 00       	call   80108470 <pci_init_device>
80108339:	83 c4 10             	add    $0x10,%esp
      for(int k=0;k<8;k++){
8010833c:	83 45 ec 01          	addl   $0x1,-0x14(%ebp)
80108340:	83 7d ec 07          	cmpl   $0x7,-0x14(%ebp)
80108344:	7e b5                	jle    801082fb <pci_init+0x22>
    for(int j=0;j<32;j++){
80108346:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
8010834a:	83 7d f0 1f          	cmpl   $0x1f,-0x10(%ebp)
8010834e:	7e a2                	jle    801082f2 <pci_init+0x19>
  for(int i=0;i<256;i++){
80108350:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80108354:	81 7d f4 ff 00 00 00 	cmpl   $0xff,-0xc(%ebp)
8010835b:	7e 8c                	jle    801082e9 <pci_init+0x10>
      }
      }
    }
  }
}
8010835d:	90                   	nop
8010835e:	90                   	nop
8010835f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80108362:	c9                   	leave  
80108363:	c3                   	ret    

80108364 <pci_write_config>:

void pci_write_config(uint config){
80108364:	55                   	push   %ebp
80108365:	89 e5                	mov    %esp,%ebp
  asm("mov $0xCF8,%%edx\n\t"
80108367:	8b 45 08             	mov    0x8(%ebp),%eax
8010836a:	ba f8 0c 00 00       	mov    $0xcf8,%edx
8010836f:	89 c0                	mov    %eax,%eax
80108371:	ef                   	out    %eax,(%dx)
      "mov %0,%%eax\n\t"
      "out %%eax,%%dx\n\t"
      : :"r"(config));
}
80108372:	90                   	nop
80108373:	5d                   	pop    %ebp
80108374:	c3                   	ret    

80108375 <pci_write_data>:

void pci_write_data(uint config){
80108375:	55                   	push   %ebp
80108376:	89 e5                	mov    %esp,%ebp
  asm("mov $0xCFC,%%edx\n\t"
80108378:	8b 45 08             	mov    0x8(%ebp),%eax
8010837b:	ba fc 0c 00 00       	mov    $0xcfc,%edx
80108380:	89 c0                	mov    %eax,%eax
80108382:	ef                   	out    %eax,(%dx)
      "mov %0,%%eax\n\t"
      "out %%eax,%%dx\n\t"
      : :"r"(config));
}
80108383:	90                   	nop
80108384:	5d                   	pop    %ebp
80108385:	c3                   	ret    

80108386 <pci_read_config>:
uint pci_read_config(){
80108386:	55                   	push   %ebp
80108387:	89 e5                	mov    %esp,%ebp
80108389:	83 ec 18             	sub    $0x18,%esp
  uint data;
  asm("mov $0xCFC,%%edx\n\t"
8010838c:	ba fc 0c 00 00       	mov    $0xcfc,%edx
80108391:	ed                   	in     (%dx),%eax
80108392:	89 45 f4             	mov    %eax,-0xc(%ebp)
      "in %%dx,%%eax\n\t"
      "mov %%eax,%0"
      :"=m"(data):);
  microdelay(200);
80108395:	83 ec 0c             	sub    $0xc,%esp
80108398:	68 c8 00 00 00       	push   $0xc8
8010839d:	e8 95 a7 ff ff       	call   80102b37 <microdelay>
801083a2:	83 c4 10             	add    $0x10,%esp
  return data;
801083a5:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
801083a8:	c9                   	leave  
801083a9:	c3                   	ret    

801083aa <pci_test>:


void pci_test(){
801083aa:	55                   	push   %ebp
801083ab:	89 e5                	mov    %esp,%ebp
801083ad:	83 ec 10             	sub    $0x10,%esp
  uint data = 0x80001804;
801083b0:	c7 45 fc 04 18 00 80 	movl   $0x80001804,-0x4(%ebp)
  pci_write_config(data);
801083b7:	ff 75 fc             	push   -0x4(%ebp)
801083ba:	e8 a5 ff ff ff       	call   80108364 <pci_write_config>
801083bf:	83 c4 04             	add    $0x4,%esp
}
801083c2:	90                   	nop
801083c3:	c9                   	leave  
801083c4:	c3                   	ret    

801083c5 <pci_access_config>:

void pci_access_config(uint bus_num,uint device_num,uint function_num,uint reg_addr,uint *data){
801083c5:	55                   	push   %ebp
801083c6:	89 e5                	mov    %esp,%ebp
801083c8:	83 ec 18             	sub    $0x18,%esp
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
801083ff:	89 45 f4             	mov    %eax,-0xc(%ebp)
  pci_write_config(config_addr);
80108402:	ff 75 f4             	push   -0xc(%ebp)
80108405:	e8 5a ff ff ff       	call   80108364 <pci_write_config>
8010840a:	83 c4 04             	add    $0x4,%esp
  *data = pci_read_config();
8010840d:	e8 74 ff ff ff       	call   80108386 <pci_read_config>
80108412:	8b 55 18             	mov    0x18(%ebp),%edx
80108415:	89 02                	mov    %eax,(%edx)
}
80108417:	90                   	nop
80108418:	c9                   	leave  
80108419:	c3                   	ret    

8010841a <pci_write_config_register>:

void pci_write_config_register(uint bus_num,uint device_num,uint function_num,uint reg_addr,uint data){
8010841a:	55                   	push   %ebp
8010841b:	89 e5                	mov    %esp,%ebp
8010841d:	83 ec 10             	sub    $0x10,%esp
  uint config_addr = ((bus_num & 0xFF)<<16) | ((device_num & 0x1F)<<11) | ((function_num & 0x7)<<8) |
80108420:	8b 45 08             	mov    0x8(%ebp),%eax
80108423:	c1 e0 10             	shl    $0x10,%eax
80108426:	25 00 00 ff 00       	and    $0xff0000,%eax
8010842b:	89 c2                	mov    %eax,%edx
8010842d:	8b 45 0c             	mov    0xc(%ebp),%eax
80108430:	c1 e0 0b             	shl    $0xb,%eax
80108433:	0f b7 c0             	movzwl %ax,%eax
80108436:	09 c2                	or     %eax,%edx
80108438:	8b 45 10             	mov    0x10(%ebp),%eax
8010843b:	c1 e0 08             	shl    $0x8,%eax
8010843e:	25 00 07 00 00       	and    $0x700,%eax
80108443:	09 c2                	or     %eax,%edx
    (reg_addr & 0xFC) | 0x80000000;
80108445:	8b 45 14             	mov    0x14(%ebp),%eax
80108448:	25 fc 00 00 00       	and    $0xfc,%eax
  uint config_addr = ((bus_num & 0xFF)<<16) | ((device_num & 0x1F)<<11) | ((function_num & 0x7)<<8) |
8010844d:	09 d0                	or     %edx,%eax
8010844f:	0d 00 00 00 80       	or     $0x80000000,%eax
80108454:	89 45 fc             	mov    %eax,-0x4(%ebp)
  pci_write_config(config_addr);
80108457:	ff 75 fc             	push   -0x4(%ebp)
8010845a:	e8 05 ff ff ff       	call   80108364 <pci_write_config>
8010845f:	83 c4 04             	add    $0x4,%esp
  pci_write_data(data);
80108462:	ff 75 18             	push   0x18(%ebp)
80108465:	e8 0b ff ff ff       	call   80108375 <pci_write_data>
8010846a:	83 c4 04             	add    $0x4,%esp
}
8010846d:	90                   	nop
8010846e:	c9                   	leave  
8010846f:	c3                   	ret    

80108470 <pci_init_device>:

struct pci_dev dev;
void pci_init_device(uint bus_num,uint device_num,uint function_num){
80108470:	55                   	push   %ebp
80108471:	89 e5                	mov    %esp,%ebp
80108473:	53                   	push   %ebx
80108474:	83 ec 14             	sub    $0x14,%esp
  uint data;
  dev.bus_num = bus_num;
80108477:	8b 45 08             	mov    0x8(%ebp),%eax
8010847a:	a2 64 6e 19 80       	mov    %al,0x80196e64
  dev.device_num = device_num;
8010847f:	8b 45 0c             	mov    0xc(%ebp),%eax
80108482:	a2 65 6e 19 80       	mov    %al,0x80196e65
  dev.function_num = function_num;
80108487:	8b 45 10             	mov    0x10(%ebp),%eax
8010848a:	a2 66 6e 19 80       	mov    %al,0x80196e66
  cprintf("PCI Device Found Bus:0x%x Device:0x%x Function:%x\n",bus_num,device_num,function_num);
8010848f:	ff 75 10             	push   0x10(%ebp)
80108492:	ff 75 0c             	push   0xc(%ebp)
80108495:	ff 75 08             	push   0x8(%ebp)
80108498:	68 e4 bf 10 80       	push   $0x8010bfe4
8010849d:	e8 52 7f ff ff       	call   801003f4 <cprintf>
801084a2:	83 c4 10             	add    $0x10,%esp
  
  pci_access_config(bus_num,device_num,function_num,0,&data);
801084a5:	83 ec 0c             	sub    $0xc,%esp
801084a8:	8d 45 ec             	lea    -0x14(%ebp),%eax
801084ab:	50                   	push   %eax
801084ac:	6a 00                	push   $0x0
801084ae:	ff 75 10             	push   0x10(%ebp)
801084b1:	ff 75 0c             	push   0xc(%ebp)
801084b4:	ff 75 08             	push   0x8(%ebp)
801084b7:	e8 09 ff ff ff       	call   801083c5 <pci_access_config>
801084bc:	83 c4 20             	add    $0x20,%esp
  uint device_id = data>>16;
801084bf:	8b 45 ec             	mov    -0x14(%ebp),%eax
801084c2:	c1 e8 10             	shr    $0x10,%eax
801084c5:	89 45 f4             	mov    %eax,-0xc(%ebp)
  uint vendor_id = data&0xFFFF;
801084c8:	8b 45 ec             	mov    -0x14(%ebp),%eax
801084cb:	25 ff ff 00 00       	and    $0xffff,%eax
801084d0:	89 45 f0             	mov    %eax,-0x10(%ebp)
  dev.device_id = device_id;
801084d3:	8b 45 f4             	mov    -0xc(%ebp),%eax
801084d6:	a3 68 6e 19 80       	mov    %eax,0x80196e68
  dev.vendor_id = vendor_id;
801084db:	8b 45 f0             	mov    -0x10(%ebp),%eax
801084de:	a3 6c 6e 19 80       	mov    %eax,0x80196e6c
  cprintf("  Device ID:0x%x  Vendor ID:0x%x\n",device_id,vendor_id);
801084e3:	83 ec 04             	sub    $0x4,%esp
801084e6:	ff 75 f0             	push   -0x10(%ebp)
801084e9:	ff 75 f4             	push   -0xc(%ebp)
801084ec:	68 18 c0 10 80       	push   $0x8010c018
801084f1:	e8 fe 7e ff ff       	call   801003f4 <cprintf>
801084f6:	83 c4 10             	add    $0x10,%esp
  
  pci_access_config(bus_num,device_num,function_num,0x8,&data);
801084f9:	83 ec 0c             	sub    $0xc,%esp
801084fc:	8d 45 ec             	lea    -0x14(%ebp),%eax
801084ff:	50                   	push   %eax
80108500:	6a 08                	push   $0x8
80108502:	ff 75 10             	push   0x10(%ebp)
80108505:	ff 75 0c             	push   0xc(%ebp)
80108508:	ff 75 08             	push   0x8(%ebp)
8010850b:	e8 b5 fe ff ff       	call   801083c5 <pci_access_config>
80108510:	83 c4 20             	add    $0x20,%esp
  cprintf("  Base Class:0x%x  Sub Class:0x%x  Interface:0x%x  Revision ID:0x%x\n",
80108513:	8b 45 ec             	mov    -0x14(%ebp),%eax
80108516:	0f b6 c8             	movzbl %al,%ecx
      data>>24,(data>>16)&0xFF,(data>>8)&0xFF,data&0xFF);
80108519:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010851c:	c1 e8 08             	shr    $0x8,%eax
  cprintf("  Base Class:0x%x  Sub Class:0x%x  Interface:0x%x  Revision ID:0x%x\n",
8010851f:	0f b6 d0             	movzbl %al,%edx
      data>>24,(data>>16)&0xFF,(data>>8)&0xFF,data&0xFF);
80108522:	8b 45 ec             	mov    -0x14(%ebp),%eax
80108525:	c1 e8 10             	shr    $0x10,%eax
  cprintf("  Base Class:0x%x  Sub Class:0x%x  Interface:0x%x  Revision ID:0x%x\n",
80108528:	0f b6 c0             	movzbl %al,%eax
8010852b:	8b 5d ec             	mov    -0x14(%ebp),%ebx
8010852e:	c1 eb 18             	shr    $0x18,%ebx
80108531:	83 ec 0c             	sub    $0xc,%esp
80108534:	51                   	push   %ecx
80108535:	52                   	push   %edx
80108536:	50                   	push   %eax
80108537:	53                   	push   %ebx
80108538:	68 3c c0 10 80       	push   $0x8010c03c
8010853d:	e8 b2 7e ff ff       	call   801003f4 <cprintf>
80108542:	83 c4 20             	add    $0x20,%esp
  dev.base_class = data>>24;
80108545:	8b 45 ec             	mov    -0x14(%ebp),%eax
80108548:	c1 e8 18             	shr    $0x18,%eax
8010854b:	a2 70 6e 19 80       	mov    %al,0x80196e70
  dev.sub_class = (data>>16)&0xFF;
80108550:	8b 45 ec             	mov    -0x14(%ebp),%eax
80108553:	c1 e8 10             	shr    $0x10,%eax
80108556:	a2 71 6e 19 80       	mov    %al,0x80196e71
  dev.interface = (data>>8)&0xFF;
8010855b:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010855e:	c1 e8 08             	shr    $0x8,%eax
80108561:	a2 72 6e 19 80       	mov    %al,0x80196e72
  dev.revision_id = data&0xFF;
80108566:	8b 45 ec             	mov    -0x14(%ebp),%eax
80108569:	a2 73 6e 19 80       	mov    %al,0x80196e73
  
  pci_access_config(bus_num,device_num,function_num,0x10,&data);
8010856e:	83 ec 0c             	sub    $0xc,%esp
80108571:	8d 45 ec             	lea    -0x14(%ebp),%eax
80108574:	50                   	push   %eax
80108575:	6a 10                	push   $0x10
80108577:	ff 75 10             	push   0x10(%ebp)
8010857a:	ff 75 0c             	push   0xc(%ebp)
8010857d:	ff 75 08             	push   0x8(%ebp)
80108580:	e8 40 fe ff ff       	call   801083c5 <pci_access_config>
80108585:	83 c4 20             	add    $0x20,%esp
  dev.bar0 = data;
80108588:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010858b:	a3 74 6e 19 80       	mov    %eax,0x80196e74
  pci_access_config(bus_num,device_num,function_num,0x14,&data);
80108590:	83 ec 0c             	sub    $0xc,%esp
80108593:	8d 45 ec             	lea    -0x14(%ebp),%eax
80108596:	50                   	push   %eax
80108597:	6a 14                	push   $0x14
80108599:	ff 75 10             	push   0x10(%ebp)
8010859c:	ff 75 0c             	push   0xc(%ebp)
8010859f:	ff 75 08             	push   0x8(%ebp)
801085a2:	e8 1e fe ff ff       	call   801083c5 <pci_access_config>
801085a7:	83 c4 20             	add    $0x20,%esp
  dev.bar1 = data;
801085aa:	8b 45 ec             	mov    -0x14(%ebp),%eax
801085ad:	a3 78 6e 19 80       	mov    %eax,0x80196e78
  if(device_id == I8254_DEVICE_ID && vendor_id == I8254_VENDOR_ID){
801085b2:	81 7d f4 0e 10 00 00 	cmpl   $0x100e,-0xc(%ebp)
801085b9:	75 5a                	jne    80108615 <pci_init_device+0x1a5>
801085bb:	81 7d f0 86 80 00 00 	cmpl   $0x8086,-0x10(%ebp)
801085c2:	75 51                	jne    80108615 <pci_init_device+0x1a5>
    cprintf("E1000 Ethernet NIC Found\n");
801085c4:	83 ec 0c             	sub    $0xc,%esp
801085c7:	68 81 c0 10 80       	push   $0x8010c081
801085cc:	e8 23 7e ff ff       	call   801003f4 <cprintf>
801085d1:	83 c4 10             	add    $0x10,%esp
    pci_access_config(bus_num,device_num,function_num,0xF0,&data);
801085d4:	83 ec 0c             	sub    $0xc,%esp
801085d7:	8d 45 ec             	lea    -0x14(%ebp),%eax
801085da:	50                   	push   %eax
801085db:	68 f0 00 00 00       	push   $0xf0
801085e0:	ff 75 10             	push   0x10(%ebp)
801085e3:	ff 75 0c             	push   0xc(%ebp)
801085e6:	ff 75 08             	push   0x8(%ebp)
801085e9:	e8 d7 fd ff ff       	call   801083c5 <pci_access_config>
801085ee:	83 c4 20             	add    $0x20,%esp
    cprintf("Message Control:%x\n",data);
801085f1:	8b 45 ec             	mov    -0x14(%ebp),%eax
801085f4:	83 ec 08             	sub    $0x8,%esp
801085f7:	50                   	push   %eax
801085f8:	68 9b c0 10 80       	push   $0x8010c09b
801085fd:	e8 f2 7d ff ff       	call   801003f4 <cprintf>
80108602:	83 c4 10             	add    $0x10,%esp
    i8254_init(&dev);
80108605:	83 ec 0c             	sub    $0xc,%esp
80108608:	68 64 6e 19 80       	push   $0x80196e64
8010860d:	e8 09 00 00 00       	call   8010861b <i8254_init>
80108612:	83 c4 10             	add    $0x10,%esp
  }
}
80108615:	90                   	nop
80108616:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80108619:	c9                   	leave  
8010861a:	c3                   	ret    

8010861b <i8254_init>:

uint base_addr;
uchar mac_addr[6] = {0};
uchar my_ip[4] = {10,0,1,10}; 
uint *intr_addr;
void i8254_init(struct pci_dev *dev){
8010861b:	55                   	push   %ebp
8010861c:	89 e5                	mov    %esp,%ebp
8010861e:	53                   	push   %ebx
8010861f:	83 ec 14             	sub    $0x14,%esp
  uint cmd_reg;
  //Enable Bus Master
  pci_access_config(dev->bus_num,dev->device_num,dev->function_num,0x04,&cmd_reg);
80108622:	8b 45 08             	mov    0x8(%ebp),%eax
80108625:	0f b6 40 02          	movzbl 0x2(%eax),%eax
80108629:	0f b6 c8             	movzbl %al,%ecx
8010862c:	8b 45 08             	mov    0x8(%ebp),%eax
8010862f:	0f b6 40 01          	movzbl 0x1(%eax),%eax
80108633:	0f b6 d0             	movzbl %al,%edx
80108636:	8b 45 08             	mov    0x8(%ebp),%eax
80108639:	0f b6 00             	movzbl (%eax),%eax
8010863c:	0f b6 c0             	movzbl %al,%eax
8010863f:	83 ec 0c             	sub    $0xc,%esp
80108642:	8d 5d ec             	lea    -0x14(%ebp),%ebx
80108645:	53                   	push   %ebx
80108646:	6a 04                	push   $0x4
80108648:	51                   	push   %ecx
80108649:	52                   	push   %edx
8010864a:	50                   	push   %eax
8010864b:	e8 75 fd ff ff       	call   801083c5 <pci_access_config>
80108650:	83 c4 20             	add    $0x20,%esp
  cmd_reg = cmd_reg | PCI_CMD_BUS_MASTER;
80108653:	8b 45 ec             	mov    -0x14(%ebp),%eax
80108656:	83 c8 04             	or     $0x4,%eax
80108659:	89 45 ec             	mov    %eax,-0x14(%ebp)
  pci_write_config_register(dev->bus_num,dev->device_num,dev->function_num,0x04,cmd_reg);
8010865c:	8b 5d ec             	mov    -0x14(%ebp),%ebx
8010865f:	8b 45 08             	mov    0x8(%ebp),%eax
80108662:	0f b6 40 02          	movzbl 0x2(%eax),%eax
80108666:	0f b6 c8             	movzbl %al,%ecx
80108669:	8b 45 08             	mov    0x8(%ebp),%eax
8010866c:	0f b6 40 01          	movzbl 0x1(%eax),%eax
80108670:	0f b6 d0             	movzbl %al,%edx
80108673:	8b 45 08             	mov    0x8(%ebp),%eax
80108676:	0f b6 00             	movzbl (%eax),%eax
80108679:	0f b6 c0             	movzbl %al,%eax
8010867c:	83 ec 0c             	sub    $0xc,%esp
8010867f:	53                   	push   %ebx
80108680:	6a 04                	push   $0x4
80108682:	51                   	push   %ecx
80108683:	52                   	push   %edx
80108684:	50                   	push   %eax
80108685:	e8 90 fd ff ff       	call   8010841a <pci_write_config_register>
8010868a:	83 c4 20             	add    $0x20,%esp
  
  base_addr = PCI_P2V(dev->bar0);
8010868d:	8b 45 08             	mov    0x8(%ebp),%eax
80108690:	8b 40 10             	mov    0x10(%eax),%eax
80108693:	05 00 00 00 40       	add    $0x40000000,%eax
80108698:	a3 7c 6e 19 80       	mov    %eax,0x80196e7c
  uint *ctrl = (uint *)base_addr;
8010869d:	a1 7c 6e 19 80       	mov    0x80196e7c,%eax
801086a2:	89 45 f4             	mov    %eax,-0xc(%ebp)
  //Disable Interrupts
  uint *imc = (uint *)(base_addr+0xD8);
801086a5:	a1 7c 6e 19 80       	mov    0x80196e7c,%eax
801086aa:	05 d8 00 00 00       	add    $0xd8,%eax
801086af:	89 45 f0             	mov    %eax,-0x10(%ebp)
  *imc = 0xFFFFFFFF;
801086b2:	8b 45 f0             	mov    -0x10(%ebp),%eax
801086b5:	c7 00 ff ff ff ff    	movl   $0xffffffff,(%eax)
  
  //Reset NIC
  *ctrl = *ctrl | I8254_CTRL_RST;
801086bb:	8b 45 f4             	mov    -0xc(%ebp),%eax
801086be:	8b 00                	mov    (%eax),%eax
801086c0:	0d 00 00 00 04       	or     $0x4000000,%eax
801086c5:	89 c2                	mov    %eax,%edx
801086c7:	8b 45 f4             	mov    -0xc(%ebp),%eax
801086ca:	89 10                	mov    %edx,(%eax)

  //Enable Interrupts
  *imc = 0xFFFFFFFF;
801086cc:	8b 45 f0             	mov    -0x10(%ebp),%eax
801086cf:	c7 00 ff ff ff ff    	movl   $0xffffffff,(%eax)

  //Enable Link
  *ctrl |= I8254_CTRL_SLU;
801086d5:	8b 45 f4             	mov    -0xc(%ebp),%eax
801086d8:	8b 00                	mov    (%eax),%eax
801086da:	83 c8 40             	or     $0x40,%eax
801086dd:	89 c2                	mov    %eax,%edx
801086df:	8b 45 f4             	mov    -0xc(%ebp),%eax
801086e2:	89 10                	mov    %edx,(%eax)
  
  //General Configuration
  *ctrl &= (~I8254_CTRL_PHY_RST | ~I8254_CTRL_VME | ~I8254_CTRL_ILOS);
801086e4:	8b 45 f4             	mov    -0xc(%ebp),%eax
801086e7:	8b 10                	mov    (%eax),%edx
801086e9:	8b 45 f4             	mov    -0xc(%ebp),%eax
801086ec:	89 10                	mov    %edx,(%eax)
  cprintf("E1000 General Configuration Done\n");
801086ee:	83 ec 0c             	sub    $0xc,%esp
801086f1:	68 b0 c0 10 80       	push   $0x8010c0b0
801086f6:	e8 f9 7c ff ff       	call   801003f4 <cprintf>
801086fb:	83 c4 10             	add    $0x10,%esp
  intr_addr = (uint *)kalloc();
801086fe:	e8 9d a0 ff ff       	call   801027a0 <kalloc>
80108703:	a3 88 6e 19 80       	mov    %eax,0x80196e88
  *intr_addr = 0;
80108708:	a1 88 6e 19 80       	mov    0x80196e88,%eax
8010870d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  cprintf("INTR_ADDR:%x\n",intr_addr);
80108713:	a1 88 6e 19 80       	mov    0x80196e88,%eax
80108718:	83 ec 08             	sub    $0x8,%esp
8010871b:	50                   	push   %eax
8010871c:	68 d2 c0 10 80       	push   $0x8010c0d2
80108721:	e8 ce 7c ff ff       	call   801003f4 <cprintf>
80108726:	83 c4 10             	add    $0x10,%esp
  i8254_init_recv();
80108729:	e8 50 00 00 00       	call   8010877e <i8254_init_recv>
  i8254_init_send();
8010872e:	e8 69 03 00 00       	call   80108a9c <i8254_init_send>
  cprintf("IP Address %d.%d.%d.%d\n",
      my_ip[0],
      my_ip[1],
      my_ip[2],
      my_ip[3]);
80108733:	0f b6 05 07 f5 10 80 	movzbl 0x8010f507,%eax
  cprintf("IP Address %d.%d.%d.%d\n",
8010873a:	0f b6 d8             	movzbl %al,%ebx
      my_ip[2],
8010873d:	0f b6 05 06 f5 10 80 	movzbl 0x8010f506,%eax
  cprintf("IP Address %d.%d.%d.%d\n",
80108744:	0f b6 c8             	movzbl %al,%ecx
      my_ip[1],
80108747:	0f b6 05 05 f5 10 80 	movzbl 0x8010f505,%eax
  cprintf("IP Address %d.%d.%d.%d\n",
8010874e:	0f b6 d0             	movzbl %al,%edx
      my_ip[0],
80108751:	0f b6 05 04 f5 10 80 	movzbl 0x8010f504,%eax
  cprintf("IP Address %d.%d.%d.%d\n",
80108758:	0f b6 c0             	movzbl %al,%eax
8010875b:	83 ec 0c             	sub    $0xc,%esp
8010875e:	53                   	push   %ebx
8010875f:	51                   	push   %ecx
80108760:	52                   	push   %edx
80108761:	50                   	push   %eax
80108762:	68 e0 c0 10 80       	push   $0x8010c0e0
80108767:	e8 88 7c ff ff       	call   801003f4 <cprintf>
8010876c:	83 c4 20             	add    $0x20,%esp
  *imc = 0x0;
8010876f:	8b 45 f0             	mov    -0x10(%ebp),%eax
80108772:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
}
80108778:	90                   	nop
80108779:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010877c:	c9                   	leave  
8010877d:	c3                   	ret    

8010877e <i8254_init_recv>:

void i8254_init_recv(){
8010877e:	55                   	push   %ebp
8010877f:	89 e5                	mov    %esp,%ebp
80108781:	57                   	push   %edi
80108782:	56                   	push   %esi
80108783:	53                   	push   %ebx
80108784:	83 ec 6c             	sub    $0x6c,%esp
  
  uint data_l = i8254_read_eeprom(0x0);
80108787:	83 ec 0c             	sub    $0xc,%esp
8010878a:	6a 00                	push   $0x0
8010878c:	e8 e8 04 00 00       	call   80108c79 <i8254_read_eeprom>
80108791:	83 c4 10             	add    $0x10,%esp
80108794:	89 45 d8             	mov    %eax,-0x28(%ebp)
  mac_addr[0] = data_l&0xFF;
80108797:	8b 45 d8             	mov    -0x28(%ebp),%eax
8010879a:	a2 80 6e 19 80       	mov    %al,0x80196e80
  mac_addr[1] = data_l>>8;
8010879f:	8b 45 d8             	mov    -0x28(%ebp),%eax
801087a2:	c1 e8 08             	shr    $0x8,%eax
801087a5:	a2 81 6e 19 80       	mov    %al,0x80196e81
  uint data_m = i8254_read_eeprom(0x1);
801087aa:	83 ec 0c             	sub    $0xc,%esp
801087ad:	6a 01                	push   $0x1
801087af:	e8 c5 04 00 00       	call   80108c79 <i8254_read_eeprom>
801087b4:	83 c4 10             	add    $0x10,%esp
801087b7:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  mac_addr[2] = data_m&0xFF;
801087ba:	8b 45 d4             	mov    -0x2c(%ebp),%eax
801087bd:	a2 82 6e 19 80       	mov    %al,0x80196e82
  mac_addr[3] = data_m>>8;
801087c2:	8b 45 d4             	mov    -0x2c(%ebp),%eax
801087c5:	c1 e8 08             	shr    $0x8,%eax
801087c8:	a2 83 6e 19 80       	mov    %al,0x80196e83
  uint data_h = i8254_read_eeprom(0x2);
801087cd:	83 ec 0c             	sub    $0xc,%esp
801087d0:	6a 02                	push   $0x2
801087d2:	e8 a2 04 00 00       	call   80108c79 <i8254_read_eeprom>
801087d7:	83 c4 10             	add    $0x10,%esp
801087da:	89 45 d0             	mov    %eax,-0x30(%ebp)
  mac_addr[4] = data_h&0xFF;
801087dd:	8b 45 d0             	mov    -0x30(%ebp),%eax
801087e0:	a2 84 6e 19 80       	mov    %al,0x80196e84
  mac_addr[5] = data_h>>8;
801087e5:	8b 45 d0             	mov    -0x30(%ebp),%eax
801087e8:	c1 e8 08             	shr    $0x8,%eax
801087eb:	a2 85 6e 19 80       	mov    %al,0x80196e85
      mac_addr[0],
      mac_addr[1],
      mac_addr[2],
      mac_addr[3],
      mac_addr[4],
      mac_addr[5]);
801087f0:	0f b6 05 85 6e 19 80 	movzbl 0x80196e85,%eax
  cprintf("MAC Address %x:%x:%x:%x:%x:%x\n",
801087f7:	0f b6 f8             	movzbl %al,%edi
      mac_addr[4],
801087fa:	0f b6 05 84 6e 19 80 	movzbl 0x80196e84,%eax
  cprintf("MAC Address %x:%x:%x:%x:%x:%x\n",
80108801:	0f b6 f0             	movzbl %al,%esi
      mac_addr[3],
80108804:	0f b6 05 83 6e 19 80 	movzbl 0x80196e83,%eax
  cprintf("MAC Address %x:%x:%x:%x:%x:%x\n",
8010880b:	0f b6 d8             	movzbl %al,%ebx
      mac_addr[2],
8010880e:	0f b6 05 82 6e 19 80 	movzbl 0x80196e82,%eax
  cprintf("MAC Address %x:%x:%x:%x:%x:%x\n",
80108815:	0f b6 c8             	movzbl %al,%ecx
      mac_addr[1],
80108818:	0f b6 05 81 6e 19 80 	movzbl 0x80196e81,%eax
  cprintf("MAC Address %x:%x:%x:%x:%x:%x\n",
8010881f:	0f b6 d0             	movzbl %al,%edx
      mac_addr[0],
80108822:	0f b6 05 80 6e 19 80 	movzbl 0x80196e80,%eax
  cprintf("MAC Address %x:%x:%x:%x:%x:%x\n",
80108829:	0f b6 c0             	movzbl %al,%eax
8010882c:	83 ec 04             	sub    $0x4,%esp
8010882f:	57                   	push   %edi
80108830:	56                   	push   %esi
80108831:	53                   	push   %ebx
80108832:	51                   	push   %ecx
80108833:	52                   	push   %edx
80108834:	50                   	push   %eax
80108835:	68 f8 c0 10 80       	push   $0x8010c0f8
8010883a:	e8 b5 7b ff ff       	call   801003f4 <cprintf>
8010883f:	83 c4 20             	add    $0x20,%esp

  uint *ral = (uint *)(base_addr + 0x5400);
80108842:	a1 7c 6e 19 80       	mov    0x80196e7c,%eax
80108847:	05 00 54 00 00       	add    $0x5400,%eax
8010884c:	89 45 cc             	mov    %eax,-0x34(%ebp)
  uint *rah = (uint *)(base_addr + 0x5404);
8010884f:	a1 7c 6e 19 80       	mov    0x80196e7c,%eax
80108854:	05 04 54 00 00       	add    $0x5404,%eax
80108859:	89 45 c8             	mov    %eax,-0x38(%ebp)

  *ral = (data_l | (data_m << 16));
8010885c:	8b 45 d4             	mov    -0x2c(%ebp),%eax
8010885f:	c1 e0 10             	shl    $0x10,%eax
80108862:	0b 45 d8             	or     -0x28(%ebp),%eax
80108865:	89 c2                	mov    %eax,%edx
80108867:	8b 45 cc             	mov    -0x34(%ebp),%eax
8010886a:	89 10                	mov    %edx,(%eax)
  *rah = (data_h | I8254_RAH_AS_DEST | I8254_RAH_AV);
8010886c:	8b 45 d0             	mov    -0x30(%ebp),%eax
8010886f:	0d 00 00 00 80       	or     $0x80000000,%eax
80108874:	89 c2                	mov    %eax,%edx
80108876:	8b 45 c8             	mov    -0x38(%ebp),%eax
80108879:	89 10                	mov    %edx,(%eax)

  uint *mta = (uint *)(base_addr + 0x5200);
8010887b:	a1 7c 6e 19 80       	mov    0x80196e7c,%eax
80108880:	05 00 52 00 00       	add    $0x5200,%eax
80108885:	89 45 c4             	mov    %eax,-0x3c(%ebp)
  for(int i=0;i<128;i++){
80108888:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
8010888f:	eb 19                	jmp    801088aa <i8254_init_recv+0x12c>
    mta[i] = 0;
80108891:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80108894:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
8010889b:	8b 45 c4             	mov    -0x3c(%ebp),%eax
8010889e:	01 d0                	add    %edx,%eax
801088a0:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  for(int i=0;i<128;i++){
801088a6:	83 45 e4 01          	addl   $0x1,-0x1c(%ebp)
801088aa:	83 7d e4 7f          	cmpl   $0x7f,-0x1c(%ebp)
801088ae:	7e e1                	jle    80108891 <i8254_init_recv+0x113>
  }

  uint *ims = (uint *)(base_addr + 0xD0);
801088b0:	a1 7c 6e 19 80       	mov    0x80196e7c,%eax
801088b5:	05 d0 00 00 00       	add    $0xd0,%eax
801088ba:	89 45 c0             	mov    %eax,-0x40(%ebp)
  *ims = (I8254_IMS_RXT0 | I8254_IMS_RXDMT0 | I8254_IMS_RXSEQ | I8254_IMS_LSC | I8254_IMS_RXO);
801088bd:	8b 45 c0             	mov    -0x40(%ebp),%eax
801088c0:	c7 00 dc 00 00 00    	movl   $0xdc,(%eax)
  uint *ics = (uint *)(base_addr + 0xC8);
801088c6:	a1 7c 6e 19 80       	mov    0x80196e7c,%eax
801088cb:	05 c8 00 00 00       	add    $0xc8,%eax
801088d0:	89 45 bc             	mov    %eax,-0x44(%ebp)
  *ics = (I8254_IMS_RXT0 | I8254_IMS_RXDMT0 | I8254_IMS_RXSEQ | I8254_IMS_LSC | I8254_IMS_RXO);
801088d3:	8b 45 bc             	mov    -0x44(%ebp),%eax
801088d6:	c7 00 dc 00 00 00    	movl   $0xdc,(%eax)



  uint *rxdctl = (uint *)(base_addr + 0x2828);
801088dc:	a1 7c 6e 19 80       	mov    0x80196e7c,%eax
801088e1:	05 28 28 00 00       	add    $0x2828,%eax
801088e6:	89 45 b8             	mov    %eax,-0x48(%ebp)
  *rxdctl = 0;
801088e9:	8b 45 b8             	mov    -0x48(%ebp),%eax
801088ec:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

  uint *rctl = (uint *)(base_addr + 0x100);
801088f2:	a1 7c 6e 19 80       	mov    0x80196e7c,%eax
801088f7:	05 00 01 00 00       	add    $0x100,%eax
801088fc:	89 45 b4             	mov    %eax,-0x4c(%ebp)
  *rctl = (I8254_RCTL_UPE | I8254_RCTL_MPE | I8254_RCTL_BAM | I8254_RCTL_BSIZE | I8254_RCTL_SECRC);
801088ff:	8b 45 b4             	mov    -0x4c(%ebp),%eax
80108902:	c7 00 18 80 00 04    	movl   $0x4008018,(%eax)

  uint recv_desc_addr = (uint)kalloc();
80108908:	e8 93 9e ff ff       	call   801027a0 <kalloc>
8010890d:	89 45 b0             	mov    %eax,-0x50(%ebp)
  uint *rdbal = (uint *)(base_addr + 0x2800);
80108910:	a1 7c 6e 19 80       	mov    0x80196e7c,%eax
80108915:	05 00 28 00 00       	add    $0x2800,%eax
8010891a:	89 45 ac             	mov    %eax,-0x54(%ebp)
  uint *rdbah = (uint *)(base_addr + 0x2804);
8010891d:	a1 7c 6e 19 80       	mov    0x80196e7c,%eax
80108922:	05 04 28 00 00       	add    $0x2804,%eax
80108927:	89 45 a8             	mov    %eax,-0x58(%ebp)
  uint *rdlen = (uint *)(base_addr + 0x2808);
8010892a:	a1 7c 6e 19 80       	mov    0x80196e7c,%eax
8010892f:	05 08 28 00 00       	add    $0x2808,%eax
80108934:	89 45 a4             	mov    %eax,-0x5c(%ebp)
  uint *rdh = (uint *)(base_addr + 0x2810);
80108937:	a1 7c 6e 19 80       	mov    0x80196e7c,%eax
8010893c:	05 10 28 00 00       	add    $0x2810,%eax
80108941:	89 45 a0             	mov    %eax,-0x60(%ebp)
  uint *rdt = (uint *)(base_addr + 0x2818);
80108944:	a1 7c 6e 19 80       	mov    0x80196e7c,%eax
80108949:	05 18 28 00 00       	add    $0x2818,%eax
8010894e:	89 45 9c             	mov    %eax,-0x64(%ebp)

  *rdbal = V2P(recv_desc_addr);
80108951:	8b 45 b0             	mov    -0x50(%ebp),%eax
80108954:	8d 90 00 00 00 80    	lea    -0x80000000(%eax),%edx
8010895a:	8b 45 ac             	mov    -0x54(%ebp),%eax
8010895d:	89 10                	mov    %edx,(%eax)
  *rdbah = 0;
8010895f:	8b 45 a8             	mov    -0x58(%ebp),%eax
80108962:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  *rdlen = sizeof(struct i8254_recv_desc)*I8254_RECV_DESC_NUM;
80108968:	8b 45 a4             	mov    -0x5c(%ebp),%eax
8010896b:	c7 00 00 10 00 00    	movl   $0x1000,(%eax)
  *rdh = 0;
80108971:	8b 45 a0             	mov    -0x60(%ebp),%eax
80108974:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  *rdt = I8254_RECV_DESC_NUM;
8010897a:	8b 45 9c             	mov    -0x64(%ebp),%eax
8010897d:	c7 00 00 01 00 00    	movl   $0x100,(%eax)

  struct i8254_recv_desc *recv_desc = (struct i8254_recv_desc *)recv_desc_addr;
80108983:	8b 45 b0             	mov    -0x50(%ebp),%eax
80108986:	89 45 98             	mov    %eax,-0x68(%ebp)
  for(int i=0;i<I8254_RECV_DESC_NUM;i++){
80108989:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
80108990:	eb 73                	jmp    80108a05 <i8254_init_recv+0x287>
    recv_desc[i].padding = 0;
80108992:	8b 45 e0             	mov    -0x20(%ebp),%eax
80108995:	c1 e0 04             	shl    $0x4,%eax
80108998:	89 c2                	mov    %eax,%edx
8010899a:	8b 45 98             	mov    -0x68(%ebp),%eax
8010899d:	01 d0                	add    %edx,%eax
8010899f:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
    recv_desc[i].len = 0;
801089a6:	8b 45 e0             	mov    -0x20(%ebp),%eax
801089a9:	c1 e0 04             	shl    $0x4,%eax
801089ac:	89 c2                	mov    %eax,%edx
801089ae:	8b 45 98             	mov    -0x68(%ebp),%eax
801089b1:	01 d0                	add    %edx,%eax
801089b3:	66 c7 40 08 00 00    	movw   $0x0,0x8(%eax)
    recv_desc[i].chk_sum = 0;
801089b9:	8b 45 e0             	mov    -0x20(%ebp),%eax
801089bc:	c1 e0 04             	shl    $0x4,%eax
801089bf:	89 c2                	mov    %eax,%edx
801089c1:	8b 45 98             	mov    -0x68(%ebp),%eax
801089c4:	01 d0                	add    %edx,%eax
801089c6:	66 c7 40 0a 00 00    	movw   $0x0,0xa(%eax)
    recv_desc[i].status = 0;
801089cc:	8b 45 e0             	mov    -0x20(%ebp),%eax
801089cf:	c1 e0 04             	shl    $0x4,%eax
801089d2:	89 c2                	mov    %eax,%edx
801089d4:	8b 45 98             	mov    -0x68(%ebp),%eax
801089d7:	01 d0                	add    %edx,%eax
801089d9:	c6 40 0c 00          	movb   $0x0,0xc(%eax)
    recv_desc[i].errors = 0;
801089dd:	8b 45 e0             	mov    -0x20(%ebp),%eax
801089e0:	c1 e0 04             	shl    $0x4,%eax
801089e3:	89 c2                	mov    %eax,%edx
801089e5:	8b 45 98             	mov    -0x68(%ebp),%eax
801089e8:	01 d0                	add    %edx,%eax
801089ea:	c6 40 0d 00          	movb   $0x0,0xd(%eax)
    recv_desc[i].special = 0;
801089ee:	8b 45 e0             	mov    -0x20(%ebp),%eax
801089f1:	c1 e0 04             	shl    $0x4,%eax
801089f4:	89 c2                	mov    %eax,%edx
801089f6:	8b 45 98             	mov    -0x68(%ebp),%eax
801089f9:	01 d0                	add    %edx,%eax
801089fb:	66 c7 40 0e 00 00    	movw   $0x0,0xe(%eax)
  for(int i=0;i<I8254_RECV_DESC_NUM;i++){
80108a01:	83 45 e0 01          	addl   $0x1,-0x20(%ebp)
80108a05:	81 7d e0 ff 00 00 00 	cmpl   $0xff,-0x20(%ebp)
80108a0c:	7e 84                	jle    80108992 <i8254_init_recv+0x214>
  }

  for(int i=0;i<(I8254_RECV_DESC_NUM)/2;i++){
80108a0e:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
80108a15:	eb 57                	jmp    80108a6e <i8254_init_recv+0x2f0>
    uint buf_addr = (uint)kalloc();
80108a17:	e8 84 9d ff ff       	call   801027a0 <kalloc>
80108a1c:	89 45 94             	mov    %eax,-0x6c(%ebp)
    if(buf_addr == 0){
80108a1f:	83 7d 94 00          	cmpl   $0x0,-0x6c(%ebp)
80108a23:	75 12                	jne    80108a37 <i8254_init_recv+0x2b9>
      cprintf("failed to allocate buffer area\n");
80108a25:	83 ec 0c             	sub    $0xc,%esp
80108a28:	68 18 c1 10 80       	push   $0x8010c118
80108a2d:	e8 c2 79 ff ff       	call   801003f4 <cprintf>
80108a32:	83 c4 10             	add    $0x10,%esp
      break;
80108a35:	eb 3d                	jmp    80108a74 <i8254_init_recv+0x2f6>
    }
    recv_desc[i].buf_addr = V2P(buf_addr);
80108a37:	8b 45 dc             	mov    -0x24(%ebp),%eax
80108a3a:	c1 e0 04             	shl    $0x4,%eax
80108a3d:	89 c2                	mov    %eax,%edx
80108a3f:	8b 45 98             	mov    -0x68(%ebp),%eax
80108a42:	01 d0                	add    %edx,%eax
80108a44:	8b 55 94             	mov    -0x6c(%ebp),%edx
80108a47:	81 c2 00 00 00 80    	add    $0x80000000,%edx
80108a4d:	89 10                	mov    %edx,(%eax)
    recv_desc[i+1].buf_addr = V2P(buf_addr + 0x800);
80108a4f:	8b 45 dc             	mov    -0x24(%ebp),%eax
80108a52:	83 c0 01             	add    $0x1,%eax
80108a55:	c1 e0 04             	shl    $0x4,%eax
80108a58:	89 c2                	mov    %eax,%edx
80108a5a:	8b 45 98             	mov    -0x68(%ebp),%eax
80108a5d:	01 d0                	add    %edx,%eax
80108a5f:	8b 55 94             	mov    -0x6c(%ebp),%edx
80108a62:	81 ea 00 f8 ff 7f    	sub    $0x7ffff800,%edx
80108a68:	89 10                	mov    %edx,(%eax)
  for(int i=0;i<(I8254_RECV_DESC_NUM)/2;i++){
80108a6a:	83 45 dc 01          	addl   $0x1,-0x24(%ebp)
80108a6e:	83 7d dc 7f          	cmpl   $0x7f,-0x24(%ebp)
80108a72:	7e a3                	jle    80108a17 <i8254_init_recv+0x299>
  }

  *rctl |= I8254_RCTL_EN;
80108a74:	8b 45 b4             	mov    -0x4c(%ebp),%eax
80108a77:	8b 00                	mov    (%eax),%eax
80108a79:	83 c8 02             	or     $0x2,%eax
80108a7c:	89 c2                	mov    %eax,%edx
80108a7e:	8b 45 b4             	mov    -0x4c(%ebp),%eax
80108a81:	89 10                	mov    %edx,(%eax)
  cprintf("E1000 Recieve Initialize Done\n");
80108a83:	83 ec 0c             	sub    $0xc,%esp
80108a86:	68 38 c1 10 80       	push   $0x8010c138
80108a8b:	e8 64 79 ff ff       	call   801003f4 <cprintf>
80108a90:	83 c4 10             	add    $0x10,%esp
}
80108a93:	90                   	nop
80108a94:	8d 65 f4             	lea    -0xc(%ebp),%esp
80108a97:	5b                   	pop    %ebx
80108a98:	5e                   	pop    %esi
80108a99:	5f                   	pop    %edi
80108a9a:	5d                   	pop    %ebp
80108a9b:	c3                   	ret    

80108a9c <i8254_init_send>:

void i8254_init_send(){
80108a9c:	55                   	push   %ebp
80108a9d:	89 e5                	mov    %esp,%ebp
80108a9f:	83 ec 48             	sub    $0x48,%esp
  uint *txdctl = (uint *)(base_addr + 0x3828);
80108aa2:	a1 7c 6e 19 80       	mov    0x80196e7c,%eax
80108aa7:	05 28 38 00 00       	add    $0x3828,%eax
80108aac:	89 45 ec             	mov    %eax,-0x14(%ebp)
  *txdctl = (I8254_TXDCTL_WTHRESH | I8254_TXDCTL_GRAN_DESC);
80108aaf:	8b 45 ec             	mov    -0x14(%ebp),%eax
80108ab2:	c7 00 00 00 01 01    	movl   $0x1010000,(%eax)

  uint tx_desc_addr = (uint)kalloc();
80108ab8:	e8 e3 9c ff ff       	call   801027a0 <kalloc>
80108abd:	89 45 e8             	mov    %eax,-0x18(%ebp)
  uint *tdbal = (uint *)(base_addr + 0x3800);
80108ac0:	a1 7c 6e 19 80       	mov    0x80196e7c,%eax
80108ac5:	05 00 38 00 00       	add    $0x3800,%eax
80108aca:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  uint *tdbah = (uint *)(base_addr + 0x3804);
80108acd:	a1 7c 6e 19 80       	mov    0x80196e7c,%eax
80108ad2:	05 04 38 00 00       	add    $0x3804,%eax
80108ad7:	89 45 e0             	mov    %eax,-0x20(%ebp)
  uint *tdlen = (uint *)(base_addr + 0x3808);
80108ada:	a1 7c 6e 19 80       	mov    0x80196e7c,%eax
80108adf:	05 08 38 00 00       	add    $0x3808,%eax
80108ae4:	89 45 dc             	mov    %eax,-0x24(%ebp)

  *tdbal = V2P(tx_desc_addr);
80108ae7:	8b 45 e8             	mov    -0x18(%ebp),%eax
80108aea:	8d 90 00 00 00 80    	lea    -0x80000000(%eax),%edx
80108af0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80108af3:	89 10                	mov    %edx,(%eax)
  *tdbah = 0;
80108af5:	8b 45 e0             	mov    -0x20(%ebp),%eax
80108af8:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  *tdlen = sizeof(struct i8254_send_desc)*I8254_SEND_DESC_NUM;
80108afe:	8b 45 dc             	mov    -0x24(%ebp),%eax
80108b01:	c7 00 00 10 00 00    	movl   $0x1000,(%eax)
  uint *tdh = (uint *)(base_addr + 0x3810);
80108b07:	a1 7c 6e 19 80       	mov    0x80196e7c,%eax
80108b0c:	05 10 38 00 00       	add    $0x3810,%eax
80108b11:	89 45 d8             	mov    %eax,-0x28(%ebp)
  uint *tdt = (uint *)(base_addr + 0x3818);
80108b14:	a1 7c 6e 19 80       	mov    0x80196e7c,%eax
80108b19:	05 18 38 00 00       	add    $0x3818,%eax
80108b1e:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  
  *tdh = 0;
80108b21:	8b 45 d8             	mov    -0x28(%ebp),%eax
80108b24:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  *tdt = 0;
80108b2a:	8b 45 d4             	mov    -0x2c(%ebp),%eax
80108b2d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

  struct i8254_send_desc *send_desc = (struct i8254_send_desc *)tx_desc_addr;
80108b33:	8b 45 e8             	mov    -0x18(%ebp),%eax
80108b36:	89 45 d0             	mov    %eax,-0x30(%ebp)
  for(int i=0;i<I8254_SEND_DESC_NUM;i++){
80108b39:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80108b40:	e9 82 00 00 00       	jmp    80108bc7 <i8254_init_send+0x12b>
    send_desc[i].padding = 0;
80108b45:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108b48:	c1 e0 04             	shl    $0x4,%eax
80108b4b:	89 c2                	mov    %eax,%edx
80108b4d:	8b 45 d0             	mov    -0x30(%ebp),%eax
80108b50:	01 d0                	add    %edx,%eax
80108b52:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
    send_desc[i].len = 0;
80108b59:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108b5c:	c1 e0 04             	shl    $0x4,%eax
80108b5f:	89 c2                	mov    %eax,%edx
80108b61:	8b 45 d0             	mov    -0x30(%ebp),%eax
80108b64:	01 d0                	add    %edx,%eax
80108b66:	66 c7 40 08 00 00    	movw   $0x0,0x8(%eax)
    send_desc[i].cso = 0;
80108b6c:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108b6f:	c1 e0 04             	shl    $0x4,%eax
80108b72:	89 c2                	mov    %eax,%edx
80108b74:	8b 45 d0             	mov    -0x30(%ebp),%eax
80108b77:	01 d0                	add    %edx,%eax
80108b79:	c6 40 0a 00          	movb   $0x0,0xa(%eax)
    send_desc[i].cmd = 0;
80108b7d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108b80:	c1 e0 04             	shl    $0x4,%eax
80108b83:	89 c2                	mov    %eax,%edx
80108b85:	8b 45 d0             	mov    -0x30(%ebp),%eax
80108b88:	01 d0                	add    %edx,%eax
80108b8a:	c6 40 0b 00          	movb   $0x0,0xb(%eax)
    send_desc[i].sta = 0;
80108b8e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108b91:	c1 e0 04             	shl    $0x4,%eax
80108b94:	89 c2                	mov    %eax,%edx
80108b96:	8b 45 d0             	mov    -0x30(%ebp),%eax
80108b99:	01 d0                	add    %edx,%eax
80108b9b:	c6 40 0c 00          	movb   $0x0,0xc(%eax)
    send_desc[i].css = 0;
80108b9f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108ba2:	c1 e0 04             	shl    $0x4,%eax
80108ba5:	89 c2                	mov    %eax,%edx
80108ba7:	8b 45 d0             	mov    -0x30(%ebp),%eax
80108baa:	01 d0                	add    %edx,%eax
80108bac:	c6 40 0d 00          	movb   $0x0,0xd(%eax)
    send_desc[i].special = 0;
80108bb0:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108bb3:	c1 e0 04             	shl    $0x4,%eax
80108bb6:	89 c2                	mov    %eax,%edx
80108bb8:	8b 45 d0             	mov    -0x30(%ebp),%eax
80108bbb:	01 d0                	add    %edx,%eax
80108bbd:	66 c7 40 0e 00 00    	movw   $0x0,0xe(%eax)
  for(int i=0;i<I8254_SEND_DESC_NUM;i++){
80108bc3:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80108bc7:	81 7d f4 ff 00 00 00 	cmpl   $0xff,-0xc(%ebp)
80108bce:	0f 8e 71 ff ff ff    	jle    80108b45 <i8254_init_send+0xa9>
  }

  for(int i=0;i<(I8254_SEND_DESC_NUM)/2;i++){
80108bd4:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
80108bdb:	eb 57                	jmp    80108c34 <i8254_init_send+0x198>
    uint buf_addr = (uint)kalloc();
80108bdd:	e8 be 9b ff ff       	call   801027a0 <kalloc>
80108be2:	89 45 cc             	mov    %eax,-0x34(%ebp)
    if(buf_addr == 0){
80108be5:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
80108be9:	75 12                	jne    80108bfd <i8254_init_send+0x161>
      cprintf("failed to allocate buffer area\n");
80108beb:	83 ec 0c             	sub    $0xc,%esp
80108bee:	68 18 c1 10 80       	push   $0x8010c118
80108bf3:	e8 fc 77 ff ff       	call   801003f4 <cprintf>
80108bf8:	83 c4 10             	add    $0x10,%esp
      break;
80108bfb:	eb 3d                	jmp    80108c3a <i8254_init_send+0x19e>
    }
    send_desc[i].buf_addr = V2P(buf_addr);
80108bfd:	8b 45 f0             	mov    -0x10(%ebp),%eax
80108c00:	c1 e0 04             	shl    $0x4,%eax
80108c03:	89 c2                	mov    %eax,%edx
80108c05:	8b 45 d0             	mov    -0x30(%ebp),%eax
80108c08:	01 d0                	add    %edx,%eax
80108c0a:	8b 55 cc             	mov    -0x34(%ebp),%edx
80108c0d:	81 c2 00 00 00 80    	add    $0x80000000,%edx
80108c13:	89 10                	mov    %edx,(%eax)
    send_desc[i+1].buf_addr = V2P(buf_addr + 0x800);
80108c15:	8b 45 f0             	mov    -0x10(%ebp),%eax
80108c18:	83 c0 01             	add    $0x1,%eax
80108c1b:	c1 e0 04             	shl    $0x4,%eax
80108c1e:	89 c2                	mov    %eax,%edx
80108c20:	8b 45 d0             	mov    -0x30(%ebp),%eax
80108c23:	01 d0                	add    %edx,%eax
80108c25:	8b 55 cc             	mov    -0x34(%ebp),%edx
80108c28:	81 ea 00 f8 ff 7f    	sub    $0x7ffff800,%edx
80108c2e:	89 10                	mov    %edx,(%eax)
  for(int i=0;i<(I8254_SEND_DESC_NUM)/2;i++){
80108c30:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
80108c34:	83 7d f0 7f          	cmpl   $0x7f,-0x10(%ebp)
80108c38:	7e a3                	jle    80108bdd <i8254_init_send+0x141>
  }

  uint *tctl = (uint *)(base_addr + 0x400);
80108c3a:	a1 7c 6e 19 80       	mov    0x80196e7c,%eax
80108c3f:	05 00 04 00 00       	add    $0x400,%eax
80108c44:	89 45 c8             	mov    %eax,-0x38(%ebp)
  *tctl = (I8254_TCTL_EN | I8254_TCTL_PSP | I8254_TCTL_COLD | I8254_TCTL_CT);
80108c47:	8b 45 c8             	mov    -0x38(%ebp),%eax
80108c4a:	c7 00 fa 00 04 00    	movl   $0x400fa,(%eax)

  uint *tipg = (uint *)(base_addr + 0x410);
80108c50:	a1 7c 6e 19 80       	mov    0x80196e7c,%eax
80108c55:	05 10 04 00 00       	add    $0x410,%eax
80108c5a:	89 45 c4             	mov    %eax,-0x3c(%ebp)
  *tipg = (10 | (10<<10) | (10<<20));
80108c5d:	8b 45 c4             	mov    -0x3c(%ebp),%eax
80108c60:	c7 00 0a 28 a0 00    	movl   $0xa0280a,(%eax)
  cprintf("E1000 Transmit Initialize Done\n");
80108c66:	83 ec 0c             	sub    $0xc,%esp
80108c69:	68 58 c1 10 80       	push   $0x8010c158
80108c6e:	e8 81 77 ff ff       	call   801003f4 <cprintf>
80108c73:	83 c4 10             	add    $0x10,%esp

}
80108c76:	90                   	nop
80108c77:	c9                   	leave  
80108c78:	c3                   	ret    

80108c79 <i8254_read_eeprom>:
uint i8254_read_eeprom(uint addr){
80108c79:	55                   	push   %ebp
80108c7a:	89 e5                	mov    %esp,%ebp
80108c7c:	83 ec 18             	sub    $0x18,%esp
  uint *eerd = (uint *)(base_addr + 0x14);
80108c7f:	a1 7c 6e 19 80       	mov    0x80196e7c,%eax
80108c84:	83 c0 14             	add    $0x14,%eax
80108c87:	89 45 f4             	mov    %eax,-0xc(%ebp)
  *eerd = (((addr & 0xFF) << 8) | 1);
80108c8a:	8b 45 08             	mov    0x8(%ebp),%eax
80108c8d:	c1 e0 08             	shl    $0x8,%eax
80108c90:	0f b7 c0             	movzwl %ax,%eax
80108c93:	83 c8 01             	or     $0x1,%eax
80108c96:	89 c2                	mov    %eax,%edx
80108c98:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108c9b:	89 10                	mov    %edx,(%eax)
  while(1){
    cprintf("");
80108c9d:	83 ec 0c             	sub    $0xc,%esp
80108ca0:	68 78 c1 10 80       	push   $0x8010c178
80108ca5:	e8 4a 77 ff ff       	call   801003f4 <cprintf>
80108caa:	83 c4 10             	add    $0x10,%esp
    volatile uint data = *eerd;
80108cad:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108cb0:	8b 00                	mov    (%eax),%eax
80108cb2:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if((data & (1<<4)) != 0){
80108cb5:	8b 45 f0             	mov    -0x10(%ebp),%eax
80108cb8:	83 e0 10             	and    $0x10,%eax
80108cbb:	85 c0                	test   %eax,%eax
80108cbd:	75 02                	jne    80108cc1 <i8254_read_eeprom+0x48>
  while(1){
80108cbf:	eb dc                	jmp    80108c9d <i8254_read_eeprom+0x24>
      break;
80108cc1:	90                   	nop
    }
  }

  return (*eerd >> 16) & 0xFFFF;
80108cc2:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108cc5:	8b 00                	mov    (%eax),%eax
80108cc7:	c1 e8 10             	shr    $0x10,%eax
}
80108cca:	c9                   	leave  
80108ccb:	c3                   	ret    

80108ccc <i8254_recv>:
void i8254_recv(){
80108ccc:	55                   	push   %ebp
80108ccd:	89 e5                	mov    %esp,%ebp
80108ccf:	83 ec 28             	sub    $0x28,%esp
  uint *rdh = (uint *)(base_addr + 0x2810);
80108cd2:	a1 7c 6e 19 80       	mov    0x80196e7c,%eax
80108cd7:	05 10 28 00 00       	add    $0x2810,%eax
80108cdc:	89 45 f4             	mov    %eax,-0xc(%ebp)
  uint *rdt = (uint *)(base_addr + 0x2818);
80108cdf:	a1 7c 6e 19 80       	mov    0x80196e7c,%eax
80108ce4:	05 18 28 00 00       	add    $0x2818,%eax
80108ce9:	89 45 f0             	mov    %eax,-0x10(%ebp)
//  uint *torl = (uint *)(base_addr + 0x40C0);
//  uint *tpr = (uint *)(base_addr + 0x40D0);
//  uint *icr = (uint *)(base_addr + 0xC0);
  uint *rdbal = (uint *)(base_addr + 0x2800);
80108cec:	a1 7c 6e 19 80       	mov    0x80196e7c,%eax
80108cf1:	05 00 28 00 00       	add    $0x2800,%eax
80108cf6:	89 45 ec             	mov    %eax,-0x14(%ebp)
  struct i8254_recv_desc *recv_desc = (struct i8254_recv_desc *)(P2V(*rdbal));
80108cf9:	8b 45 ec             	mov    -0x14(%ebp),%eax
80108cfc:	8b 00                	mov    (%eax),%eax
80108cfe:	05 00 00 00 80       	add    $0x80000000,%eax
80108d03:	89 45 e8             	mov    %eax,-0x18(%ebp)
  while(1){
    int rx_available = (I8254_RECV_DESC_NUM - *rdt + *rdh)%I8254_RECV_DESC_NUM;
80108d06:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108d09:	8b 10                	mov    (%eax),%edx
80108d0b:	8b 45 f0             	mov    -0x10(%ebp),%eax
80108d0e:	8b 08                	mov    (%eax),%ecx
80108d10:	89 d0                	mov    %edx,%eax
80108d12:	29 c8                	sub    %ecx,%eax
80108d14:	25 ff 00 00 00       	and    $0xff,%eax
80108d19:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(rx_available > 0){
80108d1c:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
80108d20:	7e 37                	jle    80108d59 <i8254_recv+0x8d>
      uint buffer_addr = P2V_WO(recv_desc[*rdt].buf_addr);
80108d22:	8b 45 f0             	mov    -0x10(%ebp),%eax
80108d25:	8b 00                	mov    (%eax),%eax
80108d27:	c1 e0 04             	shl    $0x4,%eax
80108d2a:	89 c2                	mov    %eax,%edx
80108d2c:	8b 45 e8             	mov    -0x18(%ebp),%eax
80108d2f:	01 d0                	add    %edx,%eax
80108d31:	8b 00                	mov    (%eax),%eax
80108d33:	05 00 00 00 80       	add    $0x80000000,%eax
80108d38:	89 45 e0             	mov    %eax,-0x20(%ebp)
      *rdt = (*rdt + 1)%I8254_RECV_DESC_NUM;
80108d3b:	8b 45 f0             	mov    -0x10(%ebp),%eax
80108d3e:	8b 00                	mov    (%eax),%eax
80108d40:	83 c0 01             	add    $0x1,%eax
80108d43:	0f b6 d0             	movzbl %al,%edx
80108d46:	8b 45 f0             	mov    -0x10(%ebp),%eax
80108d49:	89 10                	mov    %edx,(%eax)
      eth_proc(buffer_addr);
80108d4b:	83 ec 0c             	sub    $0xc,%esp
80108d4e:	ff 75 e0             	push   -0x20(%ebp)
80108d51:	e8 15 09 00 00       	call   8010966b <eth_proc>
80108d56:	83 c4 10             	add    $0x10,%esp
    }
    if(*rdt == *rdh) {
80108d59:	8b 45 f0             	mov    -0x10(%ebp),%eax
80108d5c:	8b 10                	mov    (%eax),%edx
80108d5e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108d61:	8b 00                	mov    (%eax),%eax
80108d63:	39 c2                	cmp    %eax,%edx
80108d65:	75 9f                	jne    80108d06 <i8254_recv+0x3a>
      (*rdt)--;
80108d67:	8b 45 f0             	mov    -0x10(%ebp),%eax
80108d6a:	8b 00                	mov    (%eax),%eax
80108d6c:	8d 50 ff             	lea    -0x1(%eax),%edx
80108d6f:	8b 45 f0             	mov    -0x10(%ebp),%eax
80108d72:	89 10                	mov    %edx,(%eax)
  while(1){
80108d74:	eb 90                	jmp    80108d06 <i8254_recv+0x3a>

80108d76 <i8254_send>:
    }
  }
}

int i8254_send(const uint pkt_addr,uint len){
80108d76:	55                   	push   %ebp
80108d77:	89 e5                	mov    %esp,%ebp
80108d79:	83 ec 28             	sub    $0x28,%esp
  uint *tdh = (uint *)(base_addr + 0x3810);
80108d7c:	a1 7c 6e 19 80       	mov    0x80196e7c,%eax
80108d81:	05 10 38 00 00       	add    $0x3810,%eax
80108d86:	89 45 f4             	mov    %eax,-0xc(%ebp)
  uint *tdt = (uint *)(base_addr + 0x3818);
80108d89:	a1 7c 6e 19 80       	mov    0x80196e7c,%eax
80108d8e:	05 18 38 00 00       	add    $0x3818,%eax
80108d93:	89 45 f0             	mov    %eax,-0x10(%ebp)
  uint *tdbal = (uint *)(base_addr + 0x3800);
80108d96:	a1 7c 6e 19 80       	mov    0x80196e7c,%eax
80108d9b:	05 00 38 00 00       	add    $0x3800,%eax
80108da0:	89 45 ec             	mov    %eax,-0x14(%ebp)
  struct i8254_send_desc *txdesc = (struct i8254_send_desc *)P2V_WO(*tdbal);
80108da3:	8b 45 ec             	mov    -0x14(%ebp),%eax
80108da6:	8b 00                	mov    (%eax),%eax
80108da8:	05 00 00 00 80       	add    $0x80000000,%eax
80108dad:	89 45 e8             	mov    %eax,-0x18(%ebp)
  int tx_available = I8254_SEND_DESC_NUM - ((I8254_SEND_DESC_NUM - *tdh + *tdt) % I8254_SEND_DESC_NUM);
80108db0:	8b 45 f0             	mov    -0x10(%ebp),%eax
80108db3:	8b 10                	mov    (%eax),%edx
80108db5:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108db8:	8b 08                	mov    (%eax),%ecx
80108dba:	89 d0                	mov    %edx,%eax
80108dbc:	29 c8                	sub    %ecx,%eax
80108dbe:	0f b6 d0             	movzbl %al,%edx
80108dc1:	b8 00 01 00 00       	mov    $0x100,%eax
80108dc6:	29 d0                	sub    %edx,%eax
80108dc8:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  uint index = *tdt%I8254_SEND_DESC_NUM;
80108dcb:	8b 45 f0             	mov    -0x10(%ebp),%eax
80108dce:	8b 00                	mov    (%eax),%eax
80108dd0:	25 ff 00 00 00       	and    $0xff,%eax
80108dd5:	89 45 e0             	mov    %eax,-0x20(%ebp)
  if(tx_available > 0) {
80108dd8:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
80108ddc:	0f 8e a8 00 00 00    	jle    80108e8a <i8254_send+0x114>
    memmove(P2V_WO((void *)txdesc[index].buf_addr),(void *)pkt_addr,len);
80108de2:	8b 45 08             	mov    0x8(%ebp),%eax
80108de5:	8b 55 e0             	mov    -0x20(%ebp),%edx
80108de8:	89 d1                	mov    %edx,%ecx
80108dea:	c1 e1 04             	shl    $0x4,%ecx
80108ded:	8b 55 e8             	mov    -0x18(%ebp),%edx
80108df0:	01 ca                	add    %ecx,%edx
80108df2:	8b 12                	mov    (%edx),%edx
80108df4:	81 c2 00 00 00 80    	add    $0x80000000,%edx
80108dfa:	83 ec 04             	sub    $0x4,%esp
80108dfd:	ff 75 0c             	push   0xc(%ebp)
80108e00:	50                   	push   %eax
80108e01:	52                   	push   %edx
80108e02:	e8 e7 be ff ff       	call   80104cee <memmove>
80108e07:	83 c4 10             	add    $0x10,%esp
    txdesc[index].len = len;
80108e0a:	8b 45 e0             	mov    -0x20(%ebp),%eax
80108e0d:	c1 e0 04             	shl    $0x4,%eax
80108e10:	89 c2                	mov    %eax,%edx
80108e12:	8b 45 e8             	mov    -0x18(%ebp),%eax
80108e15:	01 d0                	add    %edx,%eax
80108e17:	8b 55 0c             	mov    0xc(%ebp),%edx
80108e1a:	66 89 50 08          	mov    %dx,0x8(%eax)
    txdesc[index].sta = 0;
80108e1e:	8b 45 e0             	mov    -0x20(%ebp),%eax
80108e21:	c1 e0 04             	shl    $0x4,%eax
80108e24:	89 c2                	mov    %eax,%edx
80108e26:	8b 45 e8             	mov    -0x18(%ebp),%eax
80108e29:	01 d0                	add    %edx,%eax
80108e2b:	c6 40 0c 00          	movb   $0x0,0xc(%eax)
    txdesc[index].css = 0;
80108e2f:	8b 45 e0             	mov    -0x20(%ebp),%eax
80108e32:	c1 e0 04             	shl    $0x4,%eax
80108e35:	89 c2                	mov    %eax,%edx
80108e37:	8b 45 e8             	mov    -0x18(%ebp),%eax
80108e3a:	01 d0                	add    %edx,%eax
80108e3c:	c6 40 0d 00          	movb   $0x0,0xd(%eax)
    txdesc[index].cmd = 0xb;
80108e40:	8b 45 e0             	mov    -0x20(%ebp),%eax
80108e43:	c1 e0 04             	shl    $0x4,%eax
80108e46:	89 c2                	mov    %eax,%edx
80108e48:	8b 45 e8             	mov    -0x18(%ebp),%eax
80108e4b:	01 d0                	add    %edx,%eax
80108e4d:	c6 40 0b 0b          	movb   $0xb,0xb(%eax)
    txdesc[index].special = 0;
80108e51:	8b 45 e0             	mov    -0x20(%ebp),%eax
80108e54:	c1 e0 04             	shl    $0x4,%eax
80108e57:	89 c2                	mov    %eax,%edx
80108e59:	8b 45 e8             	mov    -0x18(%ebp),%eax
80108e5c:	01 d0                	add    %edx,%eax
80108e5e:	66 c7 40 0e 00 00    	movw   $0x0,0xe(%eax)
    txdesc[index].cso = 0;
80108e64:	8b 45 e0             	mov    -0x20(%ebp),%eax
80108e67:	c1 e0 04             	shl    $0x4,%eax
80108e6a:	89 c2                	mov    %eax,%edx
80108e6c:	8b 45 e8             	mov    -0x18(%ebp),%eax
80108e6f:	01 d0                	add    %edx,%eax
80108e71:	c6 40 0a 00          	movb   $0x0,0xa(%eax)
    *tdt = (*tdt + 1)%I8254_SEND_DESC_NUM;
80108e75:	8b 45 f0             	mov    -0x10(%ebp),%eax
80108e78:	8b 00                	mov    (%eax),%eax
80108e7a:	83 c0 01             	add    $0x1,%eax
80108e7d:	0f b6 d0             	movzbl %al,%edx
80108e80:	8b 45 f0             	mov    -0x10(%ebp),%eax
80108e83:	89 10                	mov    %edx,(%eax)
    return len;
80108e85:	8b 45 0c             	mov    0xc(%ebp),%eax
80108e88:	eb 05                	jmp    80108e8f <i8254_send+0x119>
  }else{
    return -1;
80108e8a:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  }
  return 0;
}
80108e8f:	c9                   	leave  
80108e90:	c3                   	ret    

80108e91 <i8254_intr>:

void i8254_intr(){
80108e91:	55                   	push   %ebp
80108e92:	89 e5                	mov    %esp,%ebp
  *intr_addr = 0xEEEEEE;
80108e94:	a1 88 6e 19 80       	mov    0x80196e88,%eax
80108e99:	c7 00 ee ee ee 00    	movl   $0xeeeeee,(%eax)
}
80108e9f:	90                   	nop
80108ea0:	5d                   	pop    %ebp
80108ea1:	c3                   	ret    

80108ea2 <arp_proc>:
extern uchar mac_addr[6];
extern uchar my_ip[4];

struct arp_entry arp_table[ARP_TABLE_MAX] = {0};

int arp_proc(uint buffer_addr){
80108ea2:	55                   	push   %ebp
80108ea3:	89 e5                	mov    %esp,%ebp
80108ea5:	83 ec 18             	sub    $0x18,%esp
  struct arp_pkt *arp_p = (struct arp_pkt *)(buffer_addr);
80108ea8:	8b 45 08             	mov    0x8(%ebp),%eax
80108eab:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(arp_p->hrd_type != ARP_HARDWARE_TYPE) return -1;
80108eae:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108eb1:	0f b7 00             	movzwl (%eax),%eax
80108eb4:	66 3d 00 01          	cmp    $0x100,%ax
80108eb8:	74 0a                	je     80108ec4 <arp_proc+0x22>
80108eba:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80108ebf:	e9 4f 01 00 00       	jmp    80109013 <arp_proc+0x171>
  if(arp_p->pro_type != ARP_PROTOCOL_TYPE) return -1;
80108ec4:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108ec7:	0f b7 40 02          	movzwl 0x2(%eax),%eax
80108ecb:	66 83 f8 08          	cmp    $0x8,%ax
80108ecf:	74 0a                	je     80108edb <arp_proc+0x39>
80108ed1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80108ed6:	e9 38 01 00 00       	jmp    80109013 <arp_proc+0x171>
  if(arp_p->hrd_len != 6) return -1;
80108edb:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108ede:	0f b6 40 04          	movzbl 0x4(%eax),%eax
80108ee2:	3c 06                	cmp    $0x6,%al
80108ee4:	74 0a                	je     80108ef0 <arp_proc+0x4e>
80108ee6:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80108eeb:	e9 23 01 00 00       	jmp    80109013 <arp_proc+0x171>
  if(arp_p->pro_len != 4) return -1;
80108ef0:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108ef3:	0f b6 40 05          	movzbl 0x5(%eax),%eax
80108ef7:	3c 04                	cmp    $0x4,%al
80108ef9:	74 0a                	je     80108f05 <arp_proc+0x63>
80108efb:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80108f00:	e9 0e 01 00 00       	jmp    80109013 <arp_proc+0x171>
  if(memcmp(my_ip,arp_p->dst_ip,4) != 0 && memcmp(my_ip,arp_p->src_ip,4) != 0) return -1;
80108f05:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108f08:	83 c0 18             	add    $0x18,%eax
80108f0b:	83 ec 04             	sub    $0x4,%esp
80108f0e:	6a 04                	push   $0x4
80108f10:	50                   	push   %eax
80108f11:	68 04 f5 10 80       	push   $0x8010f504
80108f16:	e8 7b bd ff ff       	call   80104c96 <memcmp>
80108f1b:	83 c4 10             	add    $0x10,%esp
80108f1e:	85 c0                	test   %eax,%eax
80108f20:	74 27                	je     80108f49 <arp_proc+0xa7>
80108f22:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108f25:	83 c0 0e             	add    $0xe,%eax
80108f28:	83 ec 04             	sub    $0x4,%esp
80108f2b:	6a 04                	push   $0x4
80108f2d:	50                   	push   %eax
80108f2e:	68 04 f5 10 80       	push   $0x8010f504
80108f33:	e8 5e bd ff ff       	call   80104c96 <memcmp>
80108f38:	83 c4 10             	add    $0x10,%esp
80108f3b:	85 c0                	test   %eax,%eax
80108f3d:	74 0a                	je     80108f49 <arp_proc+0xa7>
80108f3f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80108f44:	e9 ca 00 00 00       	jmp    80109013 <arp_proc+0x171>
  if(arp_p->op == ARP_OPS_REQUEST && memcmp(my_ip,arp_p->dst_ip,4) == 0){
80108f49:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108f4c:	0f b7 40 06          	movzwl 0x6(%eax),%eax
80108f50:	66 3d 00 01          	cmp    $0x100,%ax
80108f54:	75 69                	jne    80108fbf <arp_proc+0x11d>
80108f56:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108f59:	83 c0 18             	add    $0x18,%eax
80108f5c:	83 ec 04             	sub    $0x4,%esp
80108f5f:	6a 04                	push   $0x4
80108f61:	50                   	push   %eax
80108f62:	68 04 f5 10 80       	push   $0x8010f504
80108f67:	e8 2a bd ff ff       	call   80104c96 <memcmp>
80108f6c:	83 c4 10             	add    $0x10,%esp
80108f6f:	85 c0                	test   %eax,%eax
80108f71:	75 4c                	jne    80108fbf <arp_proc+0x11d>
    uint send = (uint)kalloc();
80108f73:	e8 28 98 ff ff       	call   801027a0 <kalloc>
80108f78:	89 45 f0             	mov    %eax,-0x10(%ebp)
    uint send_size=0;
80108f7b:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
    arp_reply_pkt_create(arp_p,send,&send_size);
80108f82:	83 ec 04             	sub    $0x4,%esp
80108f85:	8d 45 ec             	lea    -0x14(%ebp),%eax
80108f88:	50                   	push   %eax
80108f89:	ff 75 f0             	push   -0x10(%ebp)
80108f8c:	ff 75 f4             	push   -0xc(%ebp)
80108f8f:	e8 1f 04 00 00       	call   801093b3 <arp_reply_pkt_create>
80108f94:	83 c4 10             	add    $0x10,%esp
    i8254_send(send,send_size);
80108f97:	8b 45 ec             	mov    -0x14(%ebp),%eax
80108f9a:	83 ec 08             	sub    $0x8,%esp
80108f9d:	50                   	push   %eax
80108f9e:	ff 75 f0             	push   -0x10(%ebp)
80108fa1:	e8 d0 fd ff ff       	call   80108d76 <i8254_send>
80108fa6:	83 c4 10             	add    $0x10,%esp
    kfree((char *)send);
80108fa9:	8b 45 f0             	mov    -0x10(%ebp),%eax
80108fac:	83 ec 0c             	sub    $0xc,%esp
80108faf:	50                   	push   %eax
80108fb0:	e8 51 97 ff ff       	call   80102706 <kfree>
80108fb5:	83 c4 10             	add    $0x10,%esp
    return ARP_CREATED_REPLY;
80108fb8:	b8 02 00 00 00       	mov    $0x2,%eax
80108fbd:	eb 54                	jmp    80109013 <arp_proc+0x171>
  }else if(arp_p->op == ARP_OPS_REPLY && memcmp(my_ip,arp_p->dst_ip,4) == 0){
80108fbf:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108fc2:	0f b7 40 06          	movzwl 0x6(%eax),%eax
80108fc6:	66 3d 00 02          	cmp    $0x200,%ax
80108fca:	75 42                	jne    8010900e <arp_proc+0x16c>
80108fcc:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108fcf:	83 c0 18             	add    $0x18,%eax
80108fd2:	83 ec 04             	sub    $0x4,%esp
80108fd5:	6a 04                	push   $0x4
80108fd7:	50                   	push   %eax
80108fd8:	68 04 f5 10 80       	push   $0x8010f504
80108fdd:	e8 b4 bc ff ff       	call   80104c96 <memcmp>
80108fe2:	83 c4 10             	add    $0x10,%esp
80108fe5:	85 c0                	test   %eax,%eax
80108fe7:	75 25                	jne    8010900e <arp_proc+0x16c>
    cprintf("ARP TABLE UPDATED\n");
80108fe9:	83 ec 0c             	sub    $0xc,%esp
80108fec:	68 7c c1 10 80       	push   $0x8010c17c
80108ff1:	e8 fe 73 ff ff       	call   801003f4 <cprintf>
80108ff6:	83 c4 10             	add    $0x10,%esp
    arp_table_update(arp_p);
80108ff9:	83 ec 0c             	sub    $0xc,%esp
80108ffc:	ff 75 f4             	push   -0xc(%ebp)
80108fff:	e8 af 01 00 00       	call   801091b3 <arp_table_update>
80109004:	83 c4 10             	add    $0x10,%esp
    return ARP_UPDATED_TABLE;
80109007:	b8 01 00 00 00       	mov    $0x1,%eax
8010900c:	eb 05                	jmp    80109013 <arp_proc+0x171>
  }else{
    return -1;
8010900e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  }
}
80109013:	c9                   	leave  
80109014:	c3                   	ret    

80109015 <arp_scan>:

void arp_scan(){
80109015:	55                   	push   %ebp
80109016:	89 e5                	mov    %esp,%ebp
80109018:	83 ec 18             	sub    $0x18,%esp
  uint send_size;
  for(int i=0;i<256;i++){
8010901b:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80109022:	eb 6f                	jmp    80109093 <arp_scan+0x7e>
    uint send = (uint)kalloc();
80109024:	e8 77 97 ff ff       	call   801027a0 <kalloc>
80109029:	89 45 ec             	mov    %eax,-0x14(%ebp)
    arp_broadcast(send,&send_size,i);
8010902c:	83 ec 04             	sub    $0x4,%esp
8010902f:	ff 75 f4             	push   -0xc(%ebp)
80109032:	8d 45 e8             	lea    -0x18(%ebp),%eax
80109035:	50                   	push   %eax
80109036:	ff 75 ec             	push   -0x14(%ebp)
80109039:	e8 62 00 00 00       	call   801090a0 <arp_broadcast>
8010903e:	83 c4 10             	add    $0x10,%esp
    uint res = i8254_send(send,send_size);
80109041:	8b 45 e8             	mov    -0x18(%ebp),%eax
80109044:	83 ec 08             	sub    $0x8,%esp
80109047:	50                   	push   %eax
80109048:	ff 75 ec             	push   -0x14(%ebp)
8010904b:	e8 26 fd ff ff       	call   80108d76 <i8254_send>
80109050:	83 c4 10             	add    $0x10,%esp
80109053:	89 45 f0             	mov    %eax,-0x10(%ebp)
    while(res == -1){
80109056:	eb 22                	jmp    8010907a <arp_scan+0x65>
      microdelay(1);
80109058:	83 ec 0c             	sub    $0xc,%esp
8010905b:	6a 01                	push   $0x1
8010905d:	e8 d5 9a ff ff       	call   80102b37 <microdelay>
80109062:	83 c4 10             	add    $0x10,%esp
      res = i8254_send(send,send_size);
80109065:	8b 45 e8             	mov    -0x18(%ebp),%eax
80109068:	83 ec 08             	sub    $0x8,%esp
8010906b:	50                   	push   %eax
8010906c:	ff 75 ec             	push   -0x14(%ebp)
8010906f:	e8 02 fd ff ff       	call   80108d76 <i8254_send>
80109074:	83 c4 10             	add    $0x10,%esp
80109077:	89 45 f0             	mov    %eax,-0x10(%ebp)
    while(res == -1){
8010907a:	83 7d f0 ff          	cmpl   $0xffffffff,-0x10(%ebp)
8010907e:	74 d8                	je     80109058 <arp_scan+0x43>
    }
    kfree((char *)send);
80109080:	8b 45 ec             	mov    -0x14(%ebp),%eax
80109083:	83 ec 0c             	sub    $0xc,%esp
80109086:	50                   	push   %eax
80109087:	e8 7a 96 ff ff       	call   80102706 <kfree>
8010908c:	83 c4 10             	add    $0x10,%esp
  for(int i=0;i<256;i++){
8010908f:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80109093:	81 7d f4 ff 00 00 00 	cmpl   $0xff,-0xc(%ebp)
8010909a:	7e 88                	jle    80109024 <arp_scan+0xf>
  }
}
8010909c:	90                   	nop
8010909d:	90                   	nop
8010909e:	c9                   	leave  
8010909f:	c3                   	ret    

801090a0 <arp_broadcast>:

void arp_broadcast(uint send,uint *send_size,uint ip){
801090a0:	55                   	push   %ebp
801090a1:	89 e5                	mov    %esp,%ebp
801090a3:	83 ec 28             	sub    $0x28,%esp
  uchar dst_ip[4] = {10,0,1,ip};
801090a6:	c6 45 ec 0a          	movb   $0xa,-0x14(%ebp)
801090aa:	c6 45 ed 00          	movb   $0x0,-0x13(%ebp)
801090ae:	c6 45 ee 01          	movb   $0x1,-0x12(%ebp)
801090b2:	8b 45 10             	mov    0x10(%ebp),%eax
801090b5:	88 45 ef             	mov    %al,-0x11(%ebp)
  uchar dst_mac_eth[6] = {0xff,0xff,0xff,0xff,0xff,0xff};
801090b8:	c7 45 e6 ff ff ff ff 	movl   $0xffffffff,-0x1a(%ebp)
801090bf:	66 c7 45 ea ff ff    	movw   $0xffff,-0x16(%ebp)
  uchar dst_mac_arp[6] = {0,0,0,0,0,0};
801090c5:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
801090cc:	66 c7 45 e4 00 00    	movw   $0x0,-0x1c(%ebp)
  
  *send_size = sizeof(struct eth_pkt) + sizeof(struct arp_pkt);
801090d2:	8b 45 0c             	mov    0xc(%ebp),%eax
801090d5:	c7 00 2c 00 00 00    	movl   $0x2c,(%eax)

  struct eth_pkt *reply_eth = (struct eth_pkt *)send;
801090db:	8b 45 08             	mov    0x8(%ebp),%eax
801090de:	89 45 f4             	mov    %eax,-0xc(%ebp)
  struct arp_pkt *reply_arp = (struct arp_pkt *)(send + sizeof(struct eth_pkt));
801090e1:	8b 45 08             	mov    0x8(%ebp),%eax
801090e4:	83 c0 0e             	add    $0xe,%eax
801090e7:	89 45 f0             	mov    %eax,-0x10(%ebp)
  
  reply_eth->type[0] = 0x08;
801090ea:	8b 45 f4             	mov    -0xc(%ebp),%eax
801090ed:	c6 40 0c 08          	movb   $0x8,0xc(%eax)
  reply_eth->type[1] = 0x06;
801090f1:	8b 45 f4             	mov    -0xc(%ebp),%eax
801090f4:	c6 40 0d 06          	movb   $0x6,0xd(%eax)
  memmove(reply_eth->dst_mac,dst_mac_eth,6);
801090f8:	8b 45 f4             	mov    -0xc(%ebp),%eax
801090fb:	83 ec 04             	sub    $0x4,%esp
801090fe:	6a 06                	push   $0x6
80109100:	8d 55 e6             	lea    -0x1a(%ebp),%edx
80109103:	52                   	push   %edx
80109104:	50                   	push   %eax
80109105:	e8 e4 bb ff ff       	call   80104cee <memmove>
8010910a:	83 c4 10             	add    $0x10,%esp
  memmove(reply_eth->src_mac,mac_addr,6);
8010910d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80109110:	83 c0 06             	add    $0x6,%eax
80109113:	83 ec 04             	sub    $0x4,%esp
80109116:	6a 06                	push   $0x6
80109118:	68 80 6e 19 80       	push   $0x80196e80
8010911d:	50                   	push   %eax
8010911e:	e8 cb bb ff ff       	call   80104cee <memmove>
80109123:	83 c4 10             	add    $0x10,%esp

  reply_arp->hrd_type = ARP_HARDWARE_TYPE;
80109126:	8b 45 f0             	mov    -0x10(%ebp),%eax
80109129:	66 c7 00 00 01       	movw   $0x100,(%eax)
  reply_arp->pro_type = ARP_PROTOCOL_TYPE;
8010912e:	8b 45 f0             	mov    -0x10(%ebp),%eax
80109131:	66 c7 40 02 08 00    	movw   $0x8,0x2(%eax)
  reply_arp->hrd_len = 6;
80109137:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010913a:	c6 40 04 06          	movb   $0x6,0x4(%eax)
  reply_arp->pro_len = 4;
8010913e:	8b 45 f0             	mov    -0x10(%ebp),%eax
80109141:	c6 40 05 04          	movb   $0x4,0x5(%eax)
  reply_arp->op = ARP_OPS_REQUEST;
80109145:	8b 45 f0             	mov    -0x10(%ebp),%eax
80109148:	66 c7 40 06 00 01    	movw   $0x100,0x6(%eax)
  memmove(reply_arp->dst_mac,dst_mac_arp,6);
8010914e:	8b 45 f0             	mov    -0x10(%ebp),%eax
80109151:	8d 50 12             	lea    0x12(%eax),%edx
80109154:	83 ec 04             	sub    $0x4,%esp
80109157:	6a 06                	push   $0x6
80109159:	8d 45 e0             	lea    -0x20(%ebp),%eax
8010915c:	50                   	push   %eax
8010915d:	52                   	push   %edx
8010915e:	e8 8b bb ff ff       	call   80104cee <memmove>
80109163:	83 c4 10             	add    $0x10,%esp
  memmove(reply_arp->dst_ip,dst_ip,4);
80109166:	8b 45 f0             	mov    -0x10(%ebp),%eax
80109169:	8d 50 18             	lea    0x18(%eax),%edx
8010916c:	83 ec 04             	sub    $0x4,%esp
8010916f:	6a 04                	push   $0x4
80109171:	8d 45 ec             	lea    -0x14(%ebp),%eax
80109174:	50                   	push   %eax
80109175:	52                   	push   %edx
80109176:	e8 73 bb ff ff       	call   80104cee <memmove>
8010917b:	83 c4 10             	add    $0x10,%esp
  memmove(reply_arp->src_mac,mac_addr,6);
8010917e:	8b 45 f0             	mov    -0x10(%ebp),%eax
80109181:	83 c0 08             	add    $0x8,%eax
80109184:	83 ec 04             	sub    $0x4,%esp
80109187:	6a 06                	push   $0x6
80109189:	68 80 6e 19 80       	push   $0x80196e80
8010918e:	50                   	push   %eax
8010918f:	e8 5a bb ff ff       	call   80104cee <memmove>
80109194:	83 c4 10             	add    $0x10,%esp
  memmove(reply_arp->src_ip,my_ip,4);
80109197:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010919a:	83 c0 0e             	add    $0xe,%eax
8010919d:	83 ec 04             	sub    $0x4,%esp
801091a0:	6a 04                	push   $0x4
801091a2:	68 04 f5 10 80       	push   $0x8010f504
801091a7:	50                   	push   %eax
801091a8:	e8 41 bb ff ff       	call   80104cee <memmove>
801091ad:	83 c4 10             	add    $0x10,%esp
}
801091b0:	90                   	nop
801091b1:	c9                   	leave  
801091b2:	c3                   	ret    

801091b3 <arp_table_update>:

void arp_table_update(struct arp_pkt *recv_arp){
801091b3:	55                   	push   %ebp
801091b4:	89 e5                	mov    %esp,%ebp
801091b6:	83 ec 18             	sub    $0x18,%esp
  int index = arp_table_search(recv_arp->src_ip);
801091b9:	8b 45 08             	mov    0x8(%ebp),%eax
801091bc:	83 c0 0e             	add    $0xe,%eax
801091bf:	83 ec 0c             	sub    $0xc,%esp
801091c2:	50                   	push   %eax
801091c3:	e8 bc 00 00 00       	call   80109284 <arp_table_search>
801091c8:	83 c4 10             	add    $0x10,%esp
801091cb:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(index > -1){
801091ce:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801091d2:	78 2d                	js     80109201 <arp_table_update+0x4e>
    memmove(arp_table[index].mac,recv_arp->src_mac,6);
801091d4:	8b 45 08             	mov    0x8(%ebp),%eax
801091d7:	8d 48 08             	lea    0x8(%eax),%ecx
801091da:	8b 55 f4             	mov    -0xc(%ebp),%edx
801091dd:	89 d0                	mov    %edx,%eax
801091df:	c1 e0 02             	shl    $0x2,%eax
801091e2:	01 d0                	add    %edx,%eax
801091e4:	01 c0                	add    %eax,%eax
801091e6:	01 d0                	add    %edx,%eax
801091e8:	05 a0 6e 19 80       	add    $0x80196ea0,%eax
801091ed:	83 c0 04             	add    $0x4,%eax
801091f0:	83 ec 04             	sub    $0x4,%esp
801091f3:	6a 06                	push   $0x6
801091f5:	51                   	push   %ecx
801091f6:	50                   	push   %eax
801091f7:	e8 f2 ba ff ff       	call   80104cee <memmove>
801091fc:	83 c4 10             	add    $0x10,%esp
801091ff:	eb 70                	jmp    80109271 <arp_table_update+0xbe>
  }else{
    index += 1;
80109201:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
    index = -index;
80109205:	f7 5d f4             	negl   -0xc(%ebp)
    memmove(arp_table[index].mac,recv_arp->src_mac,6);
80109208:	8b 45 08             	mov    0x8(%ebp),%eax
8010920b:	8d 48 08             	lea    0x8(%eax),%ecx
8010920e:	8b 55 f4             	mov    -0xc(%ebp),%edx
80109211:	89 d0                	mov    %edx,%eax
80109213:	c1 e0 02             	shl    $0x2,%eax
80109216:	01 d0                	add    %edx,%eax
80109218:	01 c0                	add    %eax,%eax
8010921a:	01 d0                	add    %edx,%eax
8010921c:	05 a0 6e 19 80       	add    $0x80196ea0,%eax
80109221:	83 c0 04             	add    $0x4,%eax
80109224:	83 ec 04             	sub    $0x4,%esp
80109227:	6a 06                	push   $0x6
80109229:	51                   	push   %ecx
8010922a:	50                   	push   %eax
8010922b:	e8 be ba ff ff       	call   80104cee <memmove>
80109230:	83 c4 10             	add    $0x10,%esp
    memmove(arp_table[index].ip,recv_arp->src_ip,4);
80109233:	8b 45 08             	mov    0x8(%ebp),%eax
80109236:	8d 48 0e             	lea    0xe(%eax),%ecx
80109239:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010923c:	89 d0                	mov    %edx,%eax
8010923e:	c1 e0 02             	shl    $0x2,%eax
80109241:	01 d0                	add    %edx,%eax
80109243:	01 c0                	add    %eax,%eax
80109245:	01 d0                	add    %edx,%eax
80109247:	05 a0 6e 19 80       	add    $0x80196ea0,%eax
8010924c:	83 ec 04             	sub    $0x4,%esp
8010924f:	6a 04                	push   $0x4
80109251:	51                   	push   %ecx
80109252:	50                   	push   %eax
80109253:	e8 96 ba ff ff       	call   80104cee <memmove>
80109258:	83 c4 10             	add    $0x10,%esp
    arp_table[index].use = 1;
8010925b:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010925e:	89 d0                	mov    %edx,%eax
80109260:	c1 e0 02             	shl    $0x2,%eax
80109263:	01 d0                	add    %edx,%eax
80109265:	01 c0                	add    %eax,%eax
80109267:	01 d0                	add    %edx,%eax
80109269:	05 aa 6e 19 80       	add    $0x80196eaa,%eax
8010926e:	c6 00 01             	movb   $0x1,(%eax)
  }
  print_arp_table(arp_table);
80109271:	83 ec 0c             	sub    $0xc,%esp
80109274:	68 a0 6e 19 80       	push   $0x80196ea0
80109279:	e8 83 00 00 00       	call   80109301 <print_arp_table>
8010927e:	83 c4 10             	add    $0x10,%esp
}
80109281:	90                   	nop
80109282:	c9                   	leave  
80109283:	c3                   	ret    

80109284 <arp_table_search>:

int arp_table_search(uchar *ip){
80109284:	55                   	push   %ebp
80109285:	89 e5                	mov    %esp,%ebp
80109287:	83 ec 18             	sub    $0x18,%esp
  int empty=1;
8010928a:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
  for(int i=0;i<ARP_TABLE_MAX;i++){
80109291:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
80109298:	eb 59                	jmp    801092f3 <arp_table_search+0x6f>
    if(memcmp(arp_table[i].ip,ip,4) == 0){
8010929a:	8b 55 f0             	mov    -0x10(%ebp),%edx
8010929d:	89 d0                	mov    %edx,%eax
8010929f:	c1 e0 02             	shl    $0x2,%eax
801092a2:	01 d0                	add    %edx,%eax
801092a4:	01 c0                	add    %eax,%eax
801092a6:	01 d0                	add    %edx,%eax
801092a8:	05 a0 6e 19 80       	add    $0x80196ea0,%eax
801092ad:	83 ec 04             	sub    $0x4,%esp
801092b0:	6a 04                	push   $0x4
801092b2:	ff 75 08             	push   0x8(%ebp)
801092b5:	50                   	push   %eax
801092b6:	e8 db b9 ff ff       	call   80104c96 <memcmp>
801092bb:	83 c4 10             	add    $0x10,%esp
801092be:	85 c0                	test   %eax,%eax
801092c0:	75 05                	jne    801092c7 <arp_table_search+0x43>
      return i;
801092c2:	8b 45 f0             	mov    -0x10(%ebp),%eax
801092c5:	eb 38                	jmp    801092ff <arp_table_search+0x7b>
    }
    if(arp_table[i].use == 0 && empty == 1){
801092c7:	8b 55 f0             	mov    -0x10(%ebp),%edx
801092ca:	89 d0                	mov    %edx,%eax
801092cc:	c1 e0 02             	shl    $0x2,%eax
801092cf:	01 d0                	add    %edx,%eax
801092d1:	01 c0                	add    %eax,%eax
801092d3:	01 d0                	add    %edx,%eax
801092d5:	05 aa 6e 19 80       	add    $0x80196eaa,%eax
801092da:	0f b6 00             	movzbl (%eax),%eax
801092dd:	84 c0                	test   %al,%al
801092df:	75 0e                	jne    801092ef <arp_table_search+0x6b>
801092e1:	83 7d f4 01          	cmpl   $0x1,-0xc(%ebp)
801092e5:	75 08                	jne    801092ef <arp_table_search+0x6b>
      empty = -i;
801092e7:	8b 45 f0             	mov    -0x10(%ebp),%eax
801092ea:	f7 d8                	neg    %eax
801092ec:	89 45 f4             	mov    %eax,-0xc(%ebp)
  for(int i=0;i<ARP_TABLE_MAX;i++){
801092ef:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
801092f3:	83 7d f0 3f          	cmpl   $0x3f,-0x10(%ebp)
801092f7:	7e a1                	jle    8010929a <arp_table_search+0x16>
    }
  }
  return empty-1;
801092f9:	8b 45 f4             	mov    -0xc(%ebp),%eax
801092fc:	83 e8 01             	sub    $0x1,%eax
}
801092ff:	c9                   	leave  
80109300:	c3                   	ret    

80109301 <print_arp_table>:

void print_arp_table(){
80109301:	55                   	push   %ebp
80109302:	89 e5                	mov    %esp,%ebp
80109304:	83 ec 18             	sub    $0x18,%esp
  for(int i=0;i < ARP_TABLE_MAX;i++){
80109307:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
8010930e:	e9 92 00 00 00       	jmp    801093a5 <print_arp_table+0xa4>
    if(arp_table[i].use != 0){
80109313:	8b 55 f4             	mov    -0xc(%ebp),%edx
80109316:	89 d0                	mov    %edx,%eax
80109318:	c1 e0 02             	shl    $0x2,%eax
8010931b:	01 d0                	add    %edx,%eax
8010931d:	01 c0                	add    %eax,%eax
8010931f:	01 d0                	add    %edx,%eax
80109321:	05 aa 6e 19 80       	add    $0x80196eaa,%eax
80109326:	0f b6 00             	movzbl (%eax),%eax
80109329:	84 c0                	test   %al,%al
8010932b:	74 74                	je     801093a1 <print_arp_table+0xa0>
      cprintf("Entry Num: %d ",i);
8010932d:	83 ec 08             	sub    $0x8,%esp
80109330:	ff 75 f4             	push   -0xc(%ebp)
80109333:	68 8f c1 10 80       	push   $0x8010c18f
80109338:	e8 b7 70 ff ff       	call   801003f4 <cprintf>
8010933d:	83 c4 10             	add    $0x10,%esp
      print_ipv4(arp_table[i].ip);
80109340:	8b 55 f4             	mov    -0xc(%ebp),%edx
80109343:	89 d0                	mov    %edx,%eax
80109345:	c1 e0 02             	shl    $0x2,%eax
80109348:	01 d0                	add    %edx,%eax
8010934a:	01 c0                	add    %eax,%eax
8010934c:	01 d0                	add    %edx,%eax
8010934e:	05 a0 6e 19 80       	add    $0x80196ea0,%eax
80109353:	83 ec 0c             	sub    $0xc,%esp
80109356:	50                   	push   %eax
80109357:	e8 54 02 00 00       	call   801095b0 <print_ipv4>
8010935c:	83 c4 10             	add    $0x10,%esp
      cprintf(" ");
8010935f:	83 ec 0c             	sub    $0xc,%esp
80109362:	68 9e c1 10 80       	push   $0x8010c19e
80109367:	e8 88 70 ff ff       	call   801003f4 <cprintf>
8010936c:	83 c4 10             	add    $0x10,%esp
      print_mac(arp_table[i].mac);
8010936f:	8b 55 f4             	mov    -0xc(%ebp),%edx
80109372:	89 d0                	mov    %edx,%eax
80109374:	c1 e0 02             	shl    $0x2,%eax
80109377:	01 d0                	add    %edx,%eax
80109379:	01 c0                	add    %eax,%eax
8010937b:	01 d0                	add    %edx,%eax
8010937d:	05 a0 6e 19 80       	add    $0x80196ea0,%eax
80109382:	83 c0 04             	add    $0x4,%eax
80109385:	83 ec 0c             	sub    $0xc,%esp
80109388:	50                   	push   %eax
80109389:	e8 70 02 00 00       	call   801095fe <print_mac>
8010938e:	83 c4 10             	add    $0x10,%esp
      cprintf("\n");
80109391:	83 ec 0c             	sub    $0xc,%esp
80109394:	68 a0 c1 10 80       	push   $0x8010c1a0
80109399:	e8 56 70 ff ff       	call   801003f4 <cprintf>
8010939e:	83 c4 10             	add    $0x10,%esp
  for(int i=0;i < ARP_TABLE_MAX;i++){
801093a1:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
801093a5:	83 7d f4 3f          	cmpl   $0x3f,-0xc(%ebp)
801093a9:	0f 8e 64 ff ff ff    	jle    80109313 <print_arp_table+0x12>
    }
  }
}
801093af:	90                   	nop
801093b0:	90                   	nop
801093b1:	c9                   	leave  
801093b2:	c3                   	ret    

801093b3 <arp_reply_pkt_create>:


void arp_reply_pkt_create(struct arp_pkt *arp_recv,uint send,uint *send_size){
801093b3:	55                   	push   %ebp
801093b4:	89 e5                	mov    %esp,%ebp
801093b6:	83 ec 18             	sub    $0x18,%esp
  *send_size = sizeof(struct eth_pkt) + sizeof(struct arp_pkt);
801093b9:	8b 45 10             	mov    0x10(%ebp),%eax
801093bc:	c7 00 2c 00 00 00    	movl   $0x2c,(%eax)
  
  struct eth_pkt *reply_eth = (struct eth_pkt *)send;
801093c2:	8b 45 0c             	mov    0xc(%ebp),%eax
801093c5:	89 45 f4             	mov    %eax,-0xc(%ebp)
  struct arp_pkt *reply_arp = (struct arp_pkt *)(send + sizeof(struct eth_pkt));
801093c8:	8b 45 0c             	mov    0xc(%ebp),%eax
801093cb:	83 c0 0e             	add    $0xe,%eax
801093ce:	89 45 f0             	mov    %eax,-0x10(%ebp)

  reply_eth->type[0] = 0x08;
801093d1:	8b 45 f4             	mov    -0xc(%ebp),%eax
801093d4:	c6 40 0c 08          	movb   $0x8,0xc(%eax)
  reply_eth->type[1] = 0x06;
801093d8:	8b 45 f4             	mov    -0xc(%ebp),%eax
801093db:	c6 40 0d 06          	movb   $0x6,0xd(%eax)
  memmove(reply_eth->dst_mac,arp_recv->src_mac,6);
801093df:	8b 45 08             	mov    0x8(%ebp),%eax
801093e2:	8d 50 08             	lea    0x8(%eax),%edx
801093e5:	8b 45 f4             	mov    -0xc(%ebp),%eax
801093e8:	83 ec 04             	sub    $0x4,%esp
801093eb:	6a 06                	push   $0x6
801093ed:	52                   	push   %edx
801093ee:	50                   	push   %eax
801093ef:	e8 fa b8 ff ff       	call   80104cee <memmove>
801093f4:	83 c4 10             	add    $0x10,%esp
  memmove(reply_eth->src_mac,mac_addr,6);
801093f7:	8b 45 f4             	mov    -0xc(%ebp),%eax
801093fa:	83 c0 06             	add    $0x6,%eax
801093fd:	83 ec 04             	sub    $0x4,%esp
80109400:	6a 06                	push   $0x6
80109402:	68 80 6e 19 80       	push   $0x80196e80
80109407:	50                   	push   %eax
80109408:	e8 e1 b8 ff ff       	call   80104cee <memmove>
8010940d:	83 c4 10             	add    $0x10,%esp

  reply_arp->hrd_type = ARP_HARDWARE_TYPE;
80109410:	8b 45 f0             	mov    -0x10(%ebp),%eax
80109413:	66 c7 00 00 01       	movw   $0x100,(%eax)
  reply_arp->pro_type = ARP_PROTOCOL_TYPE;
80109418:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010941b:	66 c7 40 02 08 00    	movw   $0x8,0x2(%eax)
  reply_arp->hrd_len = 6;
80109421:	8b 45 f0             	mov    -0x10(%ebp),%eax
80109424:	c6 40 04 06          	movb   $0x6,0x4(%eax)
  reply_arp->pro_len = 4;
80109428:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010942b:	c6 40 05 04          	movb   $0x4,0x5(%eax)
  reply_arp->op = ARP_OPS_REPLY;
8010942f:	8b 45 f0             	mov    -0x10(%ebp),%eax
80109432:	66 c7 40 06 00 02    	movw   $0x200,0x6(%eax)
  memmove(reply_arp->dst_mac,arp_recv->src_mac,6);
80109438:	8b 45 08             	mov    0x8(%ebp),%eax
8010943b:	8d 50 08             	lea    0x8(%eax),%edx
8010943e:	8b 45 f0             	mov    -0x10(%ebp),%eax
80109441:	83 c0 12             	add    $0x12,%eax
80109444:	83 ec 04             	sub    $0x4,%esp
80109447:	6a 06                	push   $0x6
80109449:	52                   	push   %edx
8010944a:	50                   	push   %eax
8010944b:	e8 9e b8 ff ff       	call   80104cee <memmove>
80109450:	83 c4 10             	add    $0x10,%esp
  memmove(reply_arp->dst_ip,arp_recv->src_ip,4);
80109453:	8b 45 08             	mov    0x8(%ebp),%eax
80109456:	8d 50 0e             	lea    0xe(%eax),%edx
80109459:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010945c:	83 c0 18             	add    $0x18,%eax
8010945f:	83 ec 04             	sub    $0x4,%esp
80109462:	6a 04                	push   $0x4
80109464:	52                   	push   %edx
80109465:	50                   	push   %eax
80109466:	e8 83 b8 ff ff       	call   80104cee <memmove>
8010946b:	83 c4 10             	add    $0x10,%esp
  memmove(reply_arp->src_mac,mac_addr,6);
8010946e:	8b 45 f0             	mov    -0x10(%ebp),%eax
80109471:	83 c0 08             	add    $0x8,%eax
80109474:	83 ec 04             	sub    $0x4,%esp
80109477:	6a 06                	push   $0x6
80109479:	68 80 6e 19 80       	push   $0x80196e80
8010947e:	50                   	push   %eax
8010947f:	e8 6a b8 ff ff       	call   80104cee <memmove>
80109484:	83 c4 10             	add    $0x10,%esp
  memmove(reply_arp->src_ip,my_ip,4);
80109487:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010948a:	83 c0 0e             	add    $0xe,%eax
8010948d:	83 ec 04             	sub    $0x4,%esp
80109490:	6a 04                	push   $0x4
80109492:	68 04 f5 10 80       	push   $0x8010f504
80109497:	50                   	push   %eax
80109498:	e8 51 b8 ff ff       	call   80104cee <memmove>
8010949d:	83 c4 10             	add    $0x10,%esp
}
801094a0:	90                   	nop
801094a1:	c9                   	leave  
801094a2:	c3                   	ret    

801094a3 <print_arp_info>:

void print_arp_info(struct arp_pkt* arp_p){
801094a3:	55                   	push   %ebp
801094a4:	89 e5                	mov    %esp,%ebp
801094a6:	83 ec 08             	sub    $0x8,%esp
  cprintf("--------Source-------\n");
801094a9:	83 ec 0c             	sub    $0xc,%esp
801094ac:	68 a2 c1 10 80       	push   $0x8010c1a2
801094b1:	e8 3e 6f ff ff       	call   801003f4 <cprintf>
801094b6:	83 c4 10             	add    $0x10,%esp
  print_ipv4(arp_p->src_ip);
801094b9:	8b 45 08             	mov    0x8(%ebp),%eax
801094bc:	83 c0 0e             	add    $0xe,%eax
801094bf:	83 ec 0c             	sub    $0xc,%esp
801094c2:	50                   	push   %eax
801094c3:	e8 e8 00 00 00       	call   801095b0 <print_ipv4>
801094c8:	83 c4 10             	add    $0x10,%esp
  cprintf("\n");
801094cb:	83 ec 0c             	sub    $0xc,%esp
801094ce:	68 a0 c1 10 80       	push   $0x8010c1a0
801094d3:	e8 1c 6f ff ff       	call   801003f4 <cprintf>
801094d8:	83 c4 10             	add    $0x10,%esp
  print_mac(arp_p->src_mac);
801094db:	8b 45 08             	mov    0x8(%ebp),%eax
801094de:	83 c0 08             	add    $0x8,%eax
801094e1:	83 ec 0c             	sub    $0xc,%esp
801094e4:	50                   	push   %eax
801094e5:	e8 14 01 00 00       	call   801095fe <print_mac>
801094ea:	83 c4 10             	add    $0x10,%esp
  cprintf("\n");
801094ed:	83 ec 0c             	sub    $0xc,%esp
801094f0:	68 a0 c1 10 80       	push   $0x8010c1a0
801094f5:	e8 fa 6e ff ff       	call   801003f4 <cprintf>
801094fa:	83 c4 10             	add    $0x10,%esp
  cprintf("-----Destination-----\n");
801094fd:	83 ec 0c             	sub    $0xc,%esp
80109500:	68 b9 c1 10 80       	push   $0x8010c1b9
80109505:	e8 ea 6e ff ff       	call   801003f4 <cprintf>
8010950a:	83 c4 10             	add    $0x10,%esp
  print_ipv4(arp_p->dst_ip);
8010950d:	8b 45 08             	mov    0x8(%ebp),%eax
80109510:	83 c0 18             	add    $0x18,%eax
80109513:	83 ec 0c             	sub    $0xc,%esp
80109516:	50                   	push   %eax
80109517:	e8 94 00 00 00       	call   801095b0 <print_ipv4>
8010951c:	83 c4 10             	add    $0x10,%esp
  cprintf("\n");
8010951f:	83 ec 0c             	sub    $0xc,%esp
80109522:	68 a0 c1 10 80       	push   $0x8010c1a0
80109527:	e8 c8 6e ff ff       	call   801003f4 <cprintf>
8010952c:	83 c4 10             	add    $0x10,%esp
  print_mac(arp_p->dst_mac);
8010952f:	8b 45 08             	mov    0x8(%ebp),%eax
80109532:	83 c0 12             	add    $0x12,%eax
80109535:	83 ec 0c             	sub    $0xc,%esp
80109538:	50                   	push   %eax
80109539:	e8 c0 00 00 00       	call   801095fe <print_mac>
8010953e:	83 c4 10             	add    $0x10,%esp
  cprintf("\n");
80109541:	83 ec 0c             	sub    $0xc,%esp
80109544:	68 a0 c1 10 80       	push   $0x8010c1a0
80109549:	e8 a6 6e ff ff       	call   801003f4 <cprintf>
8010954e:	83 c4 10             	add    $0x10,%esp
  cprintf("Operation: ");
80109551:	83 ec 0c             	sub    $0xc,%esp
80109554:	68 d0 c1 10 80       	push   $0x8010c1d0
80109559:	e8 96 6e ff ff       	call   801003f4 <cprintf>
8010955e:	83 c4 10             	add    $0x10,%esp
  if(arp_p->op == ARP_OPS_REQUEST) cprintf("Request\n");
80109561:	8b 45 08             	mov    0x8(%ebp),%eax
80109564:	0f b7 40 06          	movzwl 0x6(%eax),%eax
80109568:	66 3d 00 01          	cmp    $0x100,%ax
8010956c:	75 12                	jne    80109580 <print_arp_info+0xdd>
8010956e:	83 ec 0c             	sub    $0xc,%esp
80109571:	68 dc c1 10 80       	push   $0x8010c1dc
80109576:	e8 79 6e ff ff       	call   801003f4 <cprintf>
8010957b:	83 c4 10             	add    $0x10,%esp
8010957e:	eb 1d                	jmp    8010959d <print_arp_info+0xfa>
  else if(arp_p->op == ARP_OPS_REPLY) {
80109580:	8b 45 08             	mov    0x8(%ebp),%eax
80109583:	0f b7 40 06          	movzwl 0x6(%eax),%eax
80109587:	66 3d 00 02          	cmp    $0x200,%ax
8010958b:	75 10                	jne    8010959d <print_arp_info+0xfa>
    cprintf("Reply\n");
8010958d:	83 ec 0c             	sub    $0xc,%esp
80109590:	68 e5 c1 10 80       	push   $0x8010c1e5
80109595:	e8 5a 6e ff ff       	call   801003f4 <cprintf>
8010959a:	83 c4 10             	add    $0x10,%esp
  }
  cprintf("\n");
8010959d:	83 ec 0c             	sub    $0xc,%esp
801095a0:	68 a0 c1 10 80       	push   $0x8010c1a0
801095a5:	e8 4a 6e ff ff       	call   801003f4 <cprintf>
801095aa:	83 c4 10             	add    $0x10,%esp
}
801095ad:	90                   	nop
801095ae:	c9                   	leave  
801095af:	c3                   	ret    

801095b0 <print_ipv4>:

void print_ipv4(uchar *ip){
801095b0:	55                   	push   %ebp
801095b1:	89 e5                	mov    %esp,%ebp
801095b3:	53                   	push   %ebx
801095b4:	83 ec 04             	sub    $0x4,%esp
  cprintf("IP address: %d.%d.%d.%d",ip[0],ip[1],ip[2],ip[3]);
801095b7:	8b 45 08             	mov    0x8(%ebp),%eax
801095ba:	83 c0 03             	add    $0x3,%eax
801095bd:	0f b6 00             	movzbl (%eax),%eax
801095c0:	0f b6 d8             	movzbl %al,%ebx
801095c3:	8b 45 08             	mov    0x8(%ebp),%eax
801095c6:	83 c0 02             	add    $0x2,%eax
801095c9:	0f b6 00             	movzbl (%eax),%eax
801095cc:	0f b6 c8             	movzbl %al,%ecx
801095cf:	8b 45 08             	mov    0x8(%ebp),%eax
801095d2:	83 c0 01             	add    $0x1,%eax
801095d5:	0f b6 00             	movzbl (%eax),%eax
801095d8:	0f b6 d0             	movzbl %al,%edx
801095db:	8b 45 08             	mov    0x8(%ebp),%eax
801095de:	0f b6 00             	movzbl (%eax),%eax
801095e1:	0f b6 c0             	movzbl %al,%eax
801095e4:	83 ec 0c             	sub    $0xc,%esp
801095e7:	53                   	push   %ebx
801095e8:	51                   	push   %ecx
801095e9:	52                   	push   %edx
801095ea:	50                   	push   %eax
801095eb:	68 ec c1 10 80       	push   $0x8010c1ec
801095f0:	e8 ff 6d ff ff       	call   801003f4 <cprintf>
801095f5:	83 c4 20             	add    $0x20,%esp
}
801095f8:	90                   	nop
801095f9:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801095fc:	c9                   	leave  
801095fd:	c3                   	ret    

801095fe <print_mac>:

void print_mac(uchar *mac){
801095fe:	55                   	push   %ebp
801095ff:	89 e5                	mov    %esp,%ebp
80109601:	57                   	push   %edi
80109602:	56                   	push   %esi
80109603:	53                   	push   %ebx
80109604:	83 ec 0c             	sub    $0xc,%esp
  cprintf("MAC address: %x:%x:%x:%x:%x:%x",mac[0],mac[1],mac[2],mac[3],mac[4],mac[5]);
80109607:	8b 45 08             	mov    0x8(%ebp),%eax
8010960a:	83 c0 05             	add    $0x5,%eax
8010960d:	0f b6 00             	movzbl (%eax),%eax
80109610:	0f b6 f8             	movzbl %al,%edi
80109613:	8b 45 08             	mov    0x8(%ebp),%eax
80109616:	83 c0 04             	add    $0x4,%eax
80109619:	0f b6 00             	movzbl (%eax),%eax
8010961c:	0f b6 f0             	movzbl %al,%esi
8010961f:	8b 45 08             	mov    0x8(%ebp),%eax
80109622:	83 c0 03             	add    $0x3,%eax
80109625:	0f b6 00             	movzbl (%eax),%eax
80109628:	0f b6 d8             	movzbl %al,%ebx
8010962b:	8b 45 08             	mov    0x8(%ebp),%eax
8010962e:	83 c0 02             	add    $0x2,%eax
80109631:	0f b6 00             	movzbl (%eax),%eax
80109634:	0f b6 c8             	movzbl %al,%ecx
80109637:	8b 45 08             	mov    0x8(%ebp),%eax
8010963a:	83 c0 01             	add    $0x1,%eax
8010963d:	0f b6 00             	movzbl (%eax),%eax
80109640:	0f b6 d0             	movzbl %al,%edx
80109643:	8b 45 08             	mov    0x8(%ebp),%eax
80109646:	0f b6 00             	movzbl (%eax),%eax
80109649:	0f b6 c0             	movzbl %al,%eax
8010964c:	83 ec 04             	sub    $0x4,%esp
8010964f:	57                   	push   %edi
80109650:	56                   	push   %esi
80109651:	53                   	push   %ebx
80109652:	51                   	push   %ecx
80109653:	52                   	push   %edx
80109654:	50                   	push   %eax
80109655:	68 04 c2 10 80       	push   $0x8010c204
8010965a:	e8 95 6d ff ff       	call   801003f4 <cprintf>
8010965f:	83 c4 20             	add    $0x20,%esp
}
80109662:	90                   	nop
80109663:	8d 65 f4             	lea    -0xc(%ebp),%esp
80109666:	5b                   	pop    %ebx
80109667:	5e                   	pop    %esi
80109668:	5f                   	pop    %edi
80109669:	5d                   	pop    %ebp
8010966a:	c3                   	ret    

8010966b <eth_proc>:
#include "arp.h"
#include "types.h"
#include "eth.h"
#include "defs.h"
#include "ipv4.h"
void eth_proc(uint buffer_addr){
8010966b:	55                   	push   %ebp
8010966c:	89 e5                	mov    %esp,%ebp
8010966e:	83 ec 18             	sub    $0x18,%esp
  struct eth_pkt *eth_pkt = (struct eth_pkt *)buffer_addr;
80109671:	8b 45 08             	mov    0x8(%ebp),%eax
80109674:	89 45 f4             	mov    %eax,-0xc(%ebp)
  uint pkt_addr = buffer_addr+sizeof(struct eth_pkt);
80109677:	8b 45 08             	mov    0x8(%ebp),%eax
8010967a:	83 c0 0e             	add    $0xe,%eax
8010967d:	89 45 f0             	mov    %eax,-0x10(%ebp)
  if(eth_pkt->type[0] == 0x08 && eth_pkt->type[1] == 0x06){
80109680:	8b 45 f4             	mov    -0xc(%ebp),%eax
80109683:	0f b6 40 0c          	movzbl 0xc(%eax),%eax
80109687:	3c 08                	cmp    $0x8,%al
80109689:	75 1b                	jne    801096a6 <eth_proc+0x3b>
8010968b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010968e:	0f b6 40 0d          	movzbl 0xd(%eax),%eax
80109692:	3c 06                	cmp    $0x6,%al
80109694:	75 10                	jne    801096a6 <eth_proc+0x3b>
    arp_proc(pkt_addr);
80109696:	83 ec 0c             	sub    $0xc,%esp
80109699:	ff 75 f0             	push   -0x10(%ebp)
8010969c:	e8 01 f8 ff ff       	call   80108ea2 <arp_proc>
801096a1:	83 c4 10             	add    $0x10,%esp
  }else if(eth_pkt->type[0] == 0x08 && eth_pkt->type[1] == 0x00){
    ipv4_proc(buffer_addr);
  }else{
  }
}
801096a4:	eb 24                	jmp    801096ca <eth_proc+0x5f>
  }else if(eth_pkt->type[0] == 0x08 && eth_pkt->type[1] == 0x00){
801096a6:	8b 45 f4             	mov    -0xc(%ebp),%eax
801096a9:	0f b6 40 0c          	movzbl 0xc(%eax),%eax
801096ad:	3c 08                	cmp    $0x8,%al
801096af:	75 19                	jne    801096ca <eth_proc+0x5f>
801096b1:	8b 45 f4             	mov    -0xc(%ebp),%eax
801096b4:	0f b6 40 0d          	movzbl 0xd(%eax),%eax
801096b8:	84 c0                	test   %al,%al
801096ba:	75 0e                	jne    801096ca <eth_proc+0x5f>
    ipv4_proc(buffer_addr);
801096bc:	83 ec 0c             	sub    $0xc,%esp
801096bf:	ff 75 08             	push   0x8(%ebp)
801096c2:	e8 a3 00 00 00       	call   8010976a <ipv4_proc>
801096c7:	83 c4 10             	add    $0x10,%esp
}
801096ca:	90                   	nop
801096cb:	c9                   	leave  
801096cc:	c3                   	ret    

801096cd <N2H_ushort>:

ushort N2H_ushort(ushort value){
801096cd:	55                   	push   %ebp
801096ce:	89 e5                	mov    %esp,%ebp
801096d0:	83 ec 04             	sub    $0x4,%esp
801096d3:	8b 45 08             	mov    0x8(%ebp),%eax
801096d6:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  return (((value)&0xFF)<<8)+(value>>8);
801096da:	0f b7 45 fc          	movzwl -0x4(%ebp),%eax
801096de:	c1 e0 08             	shl    $0x8,%eax
801096e1:	89 c2                	mov    %eax,%edx
801096e3:	0f b7 45 fc          	movzwl -0x4(%ebp),%eax
801096e7:	66 c1 e8 08          	shr    $0x8,%ax
801096eb:	01 d0                	add    %edx,%eax
}
801096ed:	c9                   	leave  
801096ee:	c3                   	ret    

801096ef <H2N_ushort>:

ushort H2N_ushort(ushort value){
801096ef:	55                   	push   %ebp
801096f0:	89 e5                	mov    %esp,%ebp
801096f2:	83 ec 04             	sub    $0x4,%esp
801096f5:	8b 45 08             	mov    0x8(%ebp),%eax
801096f8:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  return (((value)&0xFF)<<8)+(value>>8);
801096fc:	0f b7 45 fc          	movzwl -0x4(%ebp),%eax
80109700:	c1 e0 08             	shl    $0x8,%eax
80109703:	89 c2                	mov    %eax,%edx
80109705:	0f b7 45 fc          	movzwl -0x4(%ebp),%eax
80109709:	66 c1 e8 08          	shr    $0x8,%ax
8010970d:	01 d0                	add    %edx,%eax
}
8010970f:	c9                   	leave  
80109710:	c3                   	ret    

80109711 <H2N_uint>:

uint H2N_uint(uint value){
80109711:	55                   	push   %ebp
80109712:	89 e5                	mov    %esp,%ebp
  return ((value&0xF)<<24)+((value&0xF0)<<8)+((value&0xF00)>>8)+((value&0xF000)>>24);
80109714:	8b 45 08             	mov    0x8(%ebp),%eax
80109717:	c1 e0 18             	shl    $0x18,%eax
8010971a:	25 00 00 00 0f       	and    $0xf000000,%eax
8010971f:	89 c2                	mov    %eax,%edx
80109721:	8b 45 08             	mov    0x8(%ebp),%eax
80109724:	c1 e0 08             	shl    $0x8,%eax
80109727:	25 00 f0 00 00       	and    $0xf000,%eax
8010972c:	09 c2                	or     %eax,%edx
8010972e:	8b 45 08             	mov    0x8(%ebp),%eax
80109731:	c1 e8 08             	shr    $0x8,%eax
80109734:	83 e0 0f             	and    $0xf,%eax
80109737:	01 d0                	add    %edx,%eax
}
80109739:	5d                   	pop    %ebp
8010973a:	c3                   	ret    

8010973b <N2H_uint>:

uint N2H_uint(uint value){
8010973b:	55                   	push   %ebp
8010973c:	89 e5                	mov    %esp,%ebp
  return ((value&0xFF)<<24)+((value&0xFF00)<<8)+((value&0xFF0000)>>8)+((value&0xFF000000)>>24);
8010973e:	8b 45 08             	mov    0x8(%ebp),%eax
80109741:	c1 e0 18             	shl    $0x18,%eax
80109744:	89 c2                	mov    %eax,%edx
80109746:	8b 45 08             	mov    0x8(%ebp),%eax
80109749:	c1 e0 08             	shl    $0x8,%eax
8010974c:	25 00 00 ff 00       	and    $0xff0000,%eax
80109751:	01 c2                	add    %eax,%edx
80109753:	8b 45 08             	mov    0x8(%ebp),%eax
80109756:	c1 e8 08             	shr    $0x8,%eax
80109759:	25 00 ff 00 00       	and    $0xff00,%eax
8010975e:	01 c2                	add    %eax,%edx
80109760:	8b 45 08             	mov    0x8(%ebp),%eax
80109763:	c1 e8 18             	shr    $0x18,%eax
80109766:	01 d0                	add    %edx,%eax
}
80109768:	5d                   	pop    %ebp
80109769:	c3                   	ret    

8010976a <ipv4_proc>:
extern uchar mac_addr[6];
extern uchar my_ip[4];

int ip_id = -1;
ushort send_id = 0;
void ipv4_proc(uint buffer_addr){
8010976a:	55                   	push   %ebp
8010976b:	89 e5                	mov    %esp,%ebp
8010976d:	83 ec 18             	sub    $0x18,%esp
  struct ipv4_pkt *ipv4_p = (struct ipv4_pkt *)(buffer_addr+14);
80109770:	8b 45 08             	mov    0x8(%ebp),%eax
80109773:	83 c0 0e             	add    $0xe,%eax
80109776:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(ip_id != ipv4_p->id && memcmp(my_ip,ipv4_p->src_ip,4) != 0){
80109779:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010977c:	0f b7 40 04          	movzwl 0x4(%eax),%eax
80109780:	0f b7 d0             	movzwl %ax,%edx
80109783:	a1 08 f5 10 80       	mov    0x8010f508,%eax
80109788:	39 c2                	cmp    %eax,%edx
8010978a:	74 60                	je     801097ec <ipv4_proc+0x82>
8010978c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010978f:	83 c0 0c             	add    $0xc,%eax
80109792:	83 ec 04             	sub    $0x4,%esp
80109795:	6a 04                	push   $0x4
80109797:	50                   	push   %eax
80109798:	68 04 f5 10 80       	push   $0x8010f504
8010979d:	e8 f4 b4 ff ff       	call   80104c96 <memcmp>
801097a2:	83 c4 10             	add    $0x10,%esp
801097a5:	85 c0                	test   %eax,%eax
801097a7:	74 43                	je     801097ec <ipv4_proc+0x82>
    ip_id = ipv4_p->id;
801097a9:	8b 45 f4             	mov    -0xc(%ebp),%eax
801097ac:	0f b7 40 04          	movzwl 0x4(%eax),%eax
801097b0:	0f b7 c0             	movzwl %ax,%eax
801097b3:	a3 08 f5 10 80       	mov    %eax,0x8010f508
      if(ipv4_p->protocol == IPV4_TYPE_ICMP){
801097b8:	8b 45 f4             	mov    -0xc(%ebp),%eax
801097bb:	0f b6 40 09          	movzbl 0x9(%eax),%eax
801097bf:	3c 01                	cmp    $0x1,%al
801097c1:	75 10                	jne    801097d3 <ipv4_proc+0x69>
        icmp_proc(buffer_addr);
801097c3:	83 ec 0c             	sub    $0xc,%esp
801097c6:	ff 75 08             	push   0x8(%ebp)
801097c9:	e8 a3 00 00 00       	call   80109871 <icmp_proc>
801097ce:	83 c4 10             	add    $0x10,%esp
      }else if(ipv4_p->protocol == IPV4_TYPE_TCP){
        tcp_proc(buffer_addr);
      }
  }
}
801097d1:	eb 19                	jmp    801097ec <ipv4_proc+0x82>
      }else if(ipv4_p->protocol == IPV4_TYPE_TCP){
801097d3:	8b 45 f4             	mov    -0xc(%ebp),%eax
801097d6:	0f b6 40 09          	movzbl 0x9(%eax),%eax
801097da:	3c 06                	cmp    $0x6,%al
801097dc:	75 0e                	jne    801097ec <ipv4_proc+0x82>
        tcp_proc(buffer_addr);
801097de:	83 ec 0c             	sub    $0xc,%esp
801097e1:	ff 75 08             	push   0x8(%ebp)
801097e4:	e8 b3 03 00 00       	call   80109b9c <tcp_proc>
801097e9:	83 c4 10             	add    $0x10,%esp
}
801097ec:	90                   	nop
801097ed:	c9                   	leave  
801097ee:	c3                   	ret    

801097ef <ipv4_chksum>:

ushort ipv4_chksum(uint ipv4_addr){
801097ef:	55                   	push   %ebp
801097f0:	89 e5                	mov    %esp,%ebp
801097f2:	83 ec 10             	sub    $0x10,%esp
  uchar* bin = (uchar *)ipv4_addr;
801097f5:	8b 45 08             	mov    0x8(%ebp),%eax
801097f8:	89 45 f4             	mov    %eax,-0xc(%ebp)
  uchar len = (bin[0]&0xF)*2;
801097fb:	8b 45 f4             	mov    -0xc(%ebp),%eax
801097fe:	0f b6 00             	movzbl (%eax),%eax
80109801:	83 e0 0f             	and    $0xf,%eax
80109804:	01 c0                	add    %eax,%eax
80109806:	88 45 f3             	mov    %al,-0xd(%ebp)
  uint chk_sum = 0;
80109809:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  for(int i=0;i<len;i++){
80109810:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
80109817:	eb 48                	jmp    80109861 <ipv4_chksum+0x72>
    chk_sum += (bin[i*2]<<8)+bin[i*2+1];
80109819:	8b 45 f8             	mov    -0x8(%ebp),%eax
8010981c:	01 c0                	add    %eax,%eax
8010981e:	89 c2                	mov    %eax,%edx
80109820:	8b 45 f4             	mov    -0xc(%ebp),%eax
80109823:	01 d0                	add    %edx,%eax
80109825:	0f b6 00             	movzbl (%eax),%eax
80109828:	0f b6 c0             	movzbl %al,%eax
8010982b:	c1 e0 08             	shl    $0x8,%eax
8010982e:	89 c2                	mov    %eax,%edx
80109830:	8b 45 f8             	mov    -0x8(%ebp),%eax
80109833:	01 c0                	add    %eax,%eax
80109835:	8d 48 01             	lea    0x1(%eax),%ecx
80109838:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010983b:	01 c8                	add    %ecx,%eax
8010983d:	0f b6 00             	movzbl (%eax),%eax
80109840:	0f b6 c0             	movzbl %al,%eax
80109843:	01 d0                	add    %edx,%eax
80109845:	01 45 fc             	add    %eax,-0x4(%ebp)
    if(chk_sum > 0xFFFF){
80109848:	81 7d fc ff ff 00 00 	cmpl   $0xffff,-0x4(%ebp)
8010984f:	76 0c                	jbe    8010985d <ipv4_chksum+0x6e>
      chk_sum = (chk_sum&0xFFFF)+1;
80109851:	8b 45 fc             	mov    -0x4(%ebp),%eax
80109854:	0f b7 c0             	movzwl %ax,%eax
80109857:	83 c0 01             	add    $0x1,%eax
8010985a:	89 45 fc             	mov    %eax,-0x4(%ebp)
  for(int i=0;i<len;i++){
8010985d:	83 45 f8 01          	addl   $0x1,-0x8(%ebp)
80109861:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
80109865:	39 45 f8             	cmp    %eax,-0x8(%ebp)
80109868:	7c af                	jl     80109819 <ipv4_chksum+0x2a>
    }
  }
  return ~(chk_sum);
8010986a:	8b 45 fc             	mov    -0x4(%ebp),%eax
8010986d:	f7 d0                	not    %eax
}
8010986f:	c9                   	leave  
80109870:	c3                   	ret    

80109871 <icmp_proc>:
#include "eth.h"

extern uchar mac_addr[6];
extern uchar my_ip[4];
extern ushort send_id;
void icmp_proc(uint buffer_addr){
80109871:	55                   	push   %ebp
80109872:	89 e5                	mov    %esp,%ebp
80109874:	83 ec 18             	sub    $0x18,%esp
  struct ipv4_pkt *ipv4_p = (struct ipv4_pkt *)(buffer_addr+sizeof(struct eth_pkt));
80109877:	8b 45 08             	mov    0x8(%ebp),%eax
8010987a:	83 c0 0e             	add    $0xe,%eax
8010987d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  struct icmp_echo_pkt *icmp_p = (struct icmp_echo_pkt *)((uint)ipv4_p + (ipv4_p->ver&0xF)*4);
80109880:	8b 45 f4             	mov    -0xc(%ebp),%eax
80109883:	0f b6 00             	movzbl (%eax),%eax
80109886:	0f b6 c0             	movzbl %al,%eax
80109889:	83 e0 0f             	and    $0xf,%eax
8010988c:	c1 e0 02             	shl    $0x2,%eax
8010988f:	89 c2                	mov    %eax,%edx
80109891:	8b 45 f4             	mov    -0xc(%ebp),%eax
80109894:	01 d0                	add    %edx,%eax
80109896:	89 45 f0             	mov    %eax,-0x10(%ebp)
  if(icmp_p->code == 0){
80109899:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010989c:	0f b6 40 01          	movzbl 0x1(%eax),%eax
801098a0:	84 c0                	test   %al,%al
801098a2:	75 4f                	jne    801098f3 <icmp_proc+0x82>
    if(icmp_p->type == ICMP_TYPE_ECHO_REQUEST){
801098a4:	8b 45 f0             	mov    -0x10(%ebp),%eax
801098a7:	0f b6 00             	movzbl (%eax),%eax
801098aa:	3c 08                	cmp    $0x8,%al
801098ac:	75 45                	jne    801098f3 <icmp_proc+0x82>
      uint send_addr = (uint)kalloc();
801098ae:	e8 ed 8e ff ff       	call   801027a0 <kalloc>
801098b3:	89 45 ec             	mov    %eax,-0x14(%ebp)
      uint send_size = 0;
801098b6:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
      icmp_reply_pkt_create(buffer_addr,send_addr,&send_size);
801098bd:	83 ec 04             	sub    $0x4,%esp
801098c0:	8d 45 e8             	lea    -0x18(%ebp),%eax
801098c3:	50                   	push   %eax
801098c4:	ff 75 ec             	push   -0x14(%ebp)
801098c7:	ff 75 08             	push   0x8(%ebp)
801098ca:	e8 78 00 00 00       	call   80109947 <icmp_reply_pkt_create>
801098cf:	83 c4 10             	add    $0x10,%esp
      i8254_send(send_addr,send_size);
801098d2:	8b 45 e8             	mov    -0x18(%ebp),%eax
801098d5:	83 ec 08             	sub    $0x8,%esp
801098d8:	50                   	push   %eax
801098d9:	ff 75 ec             	push   -0x14(%ebp)
801098dc:	e8 95 f4 ff ff       	call   80108d76 <i8254_send>
801098e1:	83 c4 10             	add    $0x10,%esp
      kfree((char *)send_addr);
801098e4:	8b 45 ec             	mov    -0x14(%ebp),%eax
801098e7:	83 ec 0c             	sub    $0xc,%esp
801098ea:	50                   	push   %eax
801098eb:	e8 16 8e ff ff       	call   80102706 <kfree>
801098f0:	83 c4 10             	add    $0x10,%esp
    }
  }
}
801098f3:	90                   	nop
801098f4:	c9                   	leave  
801098f5:	c3                   	ret    

801098f6 <icmp_proc_req>:

void icmp_proc_req(struct icmp_echo_pkt * icmp_p){
801098f6:	55                   	push   %ebp
801098f7:	89 e5                	mov    %esp,%ebp
801098f9:	53                   	push   %ebx
801098fa:	83 ec 04             	sub    $0x4,%esp
  cprintf("ICMP ID:0x%x SEQ NUM:0x%x\n",N2H_ushort(icmp_p->id),N2H_ushort(icmp_p->seq_num));
801098fd:	8b 45 08             	mov    0x8(%ebp),%eax
80109900:	0f b7 40 06          	movzwl 0x6(%eax),%eax
80109904:	0f b7 c0             	movzwl %ax,%eax
80109907:	83 ec 0c             	sub    $0xc,%esp
8010990a:	50                   	push   %eax
8010990b:	e8 bd fd ff ff       	call   801096cd <N2H_ushort>
80109910:	83 c4 10             	add    $0x10,%esp
80109913:	0f b7 d8             	movzwl %ax,%ebx
80109916:	8b 45 08             	mov    0x8(%ebp),%eax
80109919:	0f b7 40 04          	movzwl 0x4(%eax),%eax
8010991d:	0f b7 c0             	movzwl %ax,%eax
80109920:	83 ec 0c             	sub    $0xc,%esp
80109923:	50                   	push   %eax
80109924:	e8 a4 fd ff ff       	call   801096cd <N2H_ushort>
80109929:	83 c4 10             	add    $0x10,%esp
8010992c:	0f b7 c0             	movzwl %ax,%eax
8010992f:	83 ec 04             	sub    $0x4,%esp
80109932:	53                   	push   %ebx
80109933:	50                   	push   %eax
80109934:	68 23 c2 10 80       	push   $0x8010c223
80109939:	e8 b6 6a ff ff       	call   801003f4 <cprintf>
8010993e:	83 c4 10             	add    $0x10,%esp
}
80109941:	90                   	nop
80109942:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80109945:	c9                   	leave  
80109946:	c3                   	ret    

80109947 <icmp_reply_pkt_create>:

void icmp_reply_pkt_create(uint recv_addr,uint send_addr,uint *send_size){
80109947:	55                   	push   %ebp
80109948:	89 e5                	mov    %esp,%ebp
8010994a:	83 ec 28             	sub    $0x28,%esp
  struct eth_pkt *eth_recv = (struct eth_pkt *)(recv_addr);
8010994d:	8b 45 08             	mov    0x8(%ebp),%eax
80109950:	89 45 f4             	mov    %eax,-0xc(%ebp)
  struct ipv4_pkt *ipv4_recv = (struct ipv4_pkt *)(recv_addr+sizeof(struct eth_pkt));
80109953:	8b 45 08             	mov    0x8(%ebp),%eax
80109956:	83 c0 0e             	add    $0xe,%eax
80109959:	89 45 f0             	mov    %eax,-0x10(%ebp)
  struct icmp_echo_pkt *icmp_recv = (struct icmp_echo_pkt *)((uint)ipv4_recv+(ipv4_recv->ver&0xF)*4);
8010995c:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010995f:	0f b6 00             	movzbl (%eax),%eax
80109962:	0f b6 c0             	movzbl %al,%eax
80109965:	83 e0 0f             	and    $0xf,%eax
80109968:	c1 e0 02             	shl    $0x2,%eax
8010996b:	89 c2                	mov    %eax,%edx
8010996d:	8b 45 f0             	mov    -0x10(%ebp),%eax
80109970:	01 d0                	add    %edx,%eax
80109972:	89 45 ec             	mov    %eax,-0x14(%ebp)
  struct eth_pkt *eth_send = (struct eth_pkt *)(send_addr);
80109975:	8b 45 0c             	mov    0xc(%ebp),%eax
80109978:	89 45 e8             	mov    %eax,-0x18(%ebp)
  struct ipv4_pkt *ipv4_send = (struct ipv4_pkt *)(send_addr+sizeof(struct eth_pkt));
8010997b:	8b 45 0c             	mov    0xc(%ebp),%eax
8010997e:	83 c0 0e             	add    $0xe,%eax
80109981:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  struct icmp_echo_pkt *icmp_send = (struct icmp_echo_pkt *)((uint)ipv4_send+sizeof(struct ipv4_pkt));
80109984:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80109987:	83 c0 14             	add    $0x14,%eax
8010998a:	89 45 e0             	mov    %eax,-0x20(%ebp)
  
  *send_size = sizeof(struct eth_pkt) + sizeof(struct ipv4_pkt) + sizeof(struct icmp_echo_pkt);
8010998d:	8b 45 10             	mov    0x10(%ebp),%eax
80109990:	c7 00 62 00 00 00    	movl   $0x62,(%eax)
  memmove(eth_send->dst_mac,eth_recv->src_mac,6);
80109996:	8b 45 f4             	mov    -0xc(%ebp),%eax
80109999:	8d 50 06             	lea    0x6(%eax),%edx
8010999c:	8b 45 e8             	mov    -0x18(%ebp),%eax
8010999f:	83 ec 04             	sub    $0x4,%esp
801099a2:	6a 06                	push   $0x6
801099a4:	52                   	push   %edx
801099a5:	50                   	push   %eax
801099a6:	e8 43 b3 ff ff       	call   80104cee <memmove>
801099ab:	83 c4 10             	add    $0x10,%esp
  memmove(eth_send->src_mac,mac_addr,6);
801099ae:	8b 45 e8             	mov    -0x18(%ebp),%eax
801099b1:	83 c0 06             	add    $0x6,%eax
801099b4:	83 ec 04             	sub    $0x4,%esp
801099b7:	6a 06                	push   $0x6
801099b9:	68 80 6e 19 80       	push   $0x80196e80
801099be:	50                   	push   %eax
801099bf:	e8 2a b3 ff ff       	call   80104cee <memmove>
801099c4:	83 c4 10             	add    $0x10,%esp
  eth_send->type[0] = 0x08;
801099c7:	8b 45 e8             	mov    -0x18(%ebp),%eax
801099ca:	c6 40 0c 08          	movb   $0x8,0xc(%eax)
  eth_send->type[1] = 0x00;
801099ce:	8b 45 e8             	mov    -0x18(%ebp),%eax
801099d1:	c6 40 0d 00          	movb   $0x0,0xd(%eax)

  ipv4_send->ver = ((0x4)<<4)+((sizeof(struct ipv4_pkt)/4)&0xF);
801099d5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801099d8:	c6 00 45             	movb   $0x45,(%eax)
  ipv4_send->srv_type = 0;
801099db:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801099de:	c6 40 01 00          	movb   $0x0,0x1(%eax)
  ipv4_send->total_len = H2N_ushort(sizeof(struct ipv4_pkt) + sizeof(struct icmp_echo_pkt));
801099e2:	83 ec 0c             	sub    $0xc,%esp
801099e5:	6a 54                	push   $0x54
801099e7:	e8 03 fd ff ff       	call   801096ef <H2N_ushort>
801099ec:	83 c4 10             	add    $0x10,%esp
801099ef:	8b 55 e4             	mov    -0x1c(%ebp),%edx
801099f2:	66 89 42 02          	mov    %ax,0x2(%edx)
  ipv4_send->id = send_id;
801099f6:	0f b7 15 60 71 19 80 	movzwl 0x80197160,%edx
801099fd:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80109a00:	66 89 50 04          	mov    %dx,0x4(%eax)
  send_id++;
80109a04:	0f b7 05 60 71 19 80 	movzwl 0x80197160,%eax
80109a0b:	83 c0 01             	add    $0x1,%eax
80109a0e:	66 a3 60 71 19 80    	mov    %ax,0x80197160
  ipv4_send->fragment = H2N_ushort(0x4000);
80109a14:	83 ec 0c             	sub    $0xc,%esp
80109a17:	68 00 40 00 00       	push   $0x4000
80109a1c:	e8 ce fc ff ff       	call   801096ef <H2N_ushort>
80109a21:	83 c4 10             	add    $0x10,%esp
80109a24:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80109a27:	66 89 42 06          	mov    %ax,0x6(%edx)
  ipv4_send->ttl = 255;
80109a2b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80109a2e:	c6 40 08 ff          	movb   $0xff,0x8(%eax)
  ipv4_send->protocol = 0x1;
80109a32:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80109a35:	c6 40 09 01          	movb   $0x1,0x9(%eax)
  memmove(ipv4_send->src_ip,my_ip,4);
80109a39:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80109a3c:	83 c0 0c             	add    $0xc,%eax
80109a3f:	83 ec 04             	sub    $0x4,%esp
80109a42:	6a 04                	push   $0x4
80109a44:	68 04 f5 10 80       	push   $0x8010f504
80109a49:	50                   	push   %eax
80109a4a:	e8 9f b2 ff ff       	call   80104cee <memmove>
80109a4f:	83 c4 10             	add    $0x10,%esp
  memmove(ipv4_send->dst_ip,ipv4_recv->src_ip,4);
80109a52:	8b 45 f0             	mov    -0x10(%ebp),%eax
80109a55:	8d 50 0c             	lea    0xc(%eax),%edx
80109a58:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80109a5b:	83 c0 10             	add    $0x10,%eax
80109a5e:	83 ec 04             	sub    $0x4,%esp
80109a61:	6a 04                	push   $0x4
80109a63:	52                   	push   %edx
80109a64:	50                   	push   %eax
80109a65:	e8 84 b2 ff ff       	call   80104cee <memmove>
80109a6a:	83 c4 10             	add    $0x10,%esp
  ipv4_send->chk_sum = 0;
80109a6d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80109a70:	66 c7 40 0a 00 00    	movw   $0x0,0xa(%eax)
  ipv4_send->chk_sum = H2N_ushort(ipv4_chksum((uint)ipv4_send));
80109a76:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80109a79:	83 ec 0c             	sub    $0xc,%esp
80109a7c:	50                   	push   %eax
80109a7d:	e8 6d fd ff ff       	call   801097ef <ipv4_chksum>
80109a82:	83 c4 10             	add    $0x10,%esp
80109a85:	0f b7 c0             	movzwl %ax,%eax
80109a88:	83 ec 0c             	sub    $0xc,%esp
80109a8b:	50                   	push   %eax
80109a8c:	e8 5e fc ff ff       	call   801096ef <H2N_ushort>
80109a91:	83 c4 10             	add    $0x10,%esp
80109a94:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80109a97:	66 89 42 0a          	mov    %ax,0xa(%edx)

  icmp_send->type = ICMP_TYPE_ECHO_REPLY;
80109a9b:	8b 45 e0             	mov    -0x20(%ebp),%eax
80109a9e:	c6 00 00             	movb   $0x0,(%eax)
  icmp_send->code = 0;
80109aa1:	8b 45 e0             	mov    -0x20(%ebp),%eax
80109aa4:	c6 40 01 00          	movb   $0x0,0x1(%eax)
  icmp_send->id = icmp_recv->id;
80109aa8:	8b 45 ec             	mov    -0x14(%ebp),%eax
80109aab:	0f b7 50 04          	movzwl 0x4(%eax),%edx
80109aaf:	8b 45 e0             	mov    -0x20(%ebp),%eax
80109ab2:	66 89 50 04          	mov    %dx,0x4(%eax)
  icmp_send->seq_num = icmp_recv->seq_num;
80109ab6:	8b 45 ec             	mov    -0x14(%ebp),%eax
80109ab9:	0f b7 50 06          	movzwl 0x6(%eax),%edx
80109abd:	8b 45 e0             	mov    -0x20(%ebp),%eax
80109ac0:	66 89 50 06          	mov    %dx,0x6(%eax)
  memmove(icmp_send->time_stamp,icmp_recv->time_stamp,8);
80109ac4:	8b 45 ec             	mov    -0x14(%ebp),%eax
80109ac7:	8d 50 08             	lea    0x8(%eax),%edx
80109aca:	8b 45 e0             	mov    -0x20(%ebp),%eax
80109acd:	83 c0 08             	add    $0x8,%eax
80109ad0:	83 ec 04             	sub    $0x4,%esp
80109ad3:	6a 08                	push   $0x8
80109ad5:	52                   	push   %edx
80109ad6:	50                   	push   %eax
80109ad7:	e8 12 b2 ff ff       	call   80104cee <memmove>
80109adc:	83 c4 10             	add    $0x10,%esp
  memmove(icmp_send->data,icmp_recv->data,48);
80109adf:	8b 45 ec             	mov    -0x14(%ebp),%eax
80109ae2:	8d 50 10             	lea    0x10(%eax),%edx
80109ae5:	8b 45 e0             	mov    -0x20(%ebp),%eax
80109ae8:	83 c0 10             	add    $0x10,%eax
80109aeb:	83 ec 04             	sub    $0x4,%esp
80109aee:	6a 30                	push   $0x30
80109af0:	52                   	push   %edx
80109af1:	50                   	push   %eax
80109af2:	e8 f7 b1 ff ff       	call   80104cee <memmove>
80109af7:	83 c4 10             	add    $0x10,%esp
  icmp_send->chk_sum = 0;
80109afa:	8b 45 e0             	mov    -0x20(%ebp),%eax
80109afd:	66 c7 40 02 00 00    	movw   $0x0,0x2(%eax)
  icmp_send->chk_sum = H2N_ushort(icmp_chksum((uint)icmp_send));
80109b03:	8b 45 e0             	mov    -0x20(%ebp),%eax
80109b06:	83 ec 0c             	sub    $0xc,%esp
80109b09:	50                   	push   %eax
80109b0a:	e8 1c 00 00 00       	call   80109b2b <icmp_chksum>
80109b0f:	83 c4 10             	add    $0x10,%esp
80109b12:	0f b7 c0             	movzwl %ax,%eax
80109b15:	83 ec 0c             	sub    $0xc,%esp
80109b18:	50                   	push   %eax
80109b19:	e8 d1 fb ff ff       	call   801096ef <H2N_ushort>
80109b1e:	83 c4 10             	add    $0x10,%esp
80109b21:	8b 55 e0             	mov    -0x20(%ebp),%edx
80109b24:	66 89 42 02          	mov    %ax,0x2(%edx)
}
80109b28:	90                   	nop
80109b29:	c9                   	leave  
80109b2a:	c3                   	ret    

80109b2b <icmp_chksum>:

ushort icmp_chksum(uint icmp_addr){
80109b2b:	55                   	push   %ebp
80109b2c:	89 e5                	mov    %esp,%ebp
80109b2e:	83 ec 10             	sub    $0x10,%esp
  uchar* bin = (uchar *)icmp_addr;
80109b31:	8b 45 08             	mov    0x8(%ebp),%eax
80109b34:	89 45 f4             	mov    %eax,-0xc(%ebp)
  uint chk_sum = 0;
80109b37:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  for(int i=0;i<32;i++){
80109b3e:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
80109b45:	eb 48                	jmp    80109b8f <icmp_chksum+0x64>
    chk_sum += (bin[i*2]<<8)+bin[i*2+1];
80109b47:	8b 45 f8             	mov    -0x8(%ebp),%eax
80109b4a:	01 c0                	add    %eax,%eax
80109b4c:	89 c2                	mov    %eax,%edx
80109b4e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80109b51:	01 d0                	add    %edx,%eax
80109b53:	0f b6 00             	movzbl (%eax),%eax
80109b56:	0f b6 c0             	movzbl %al,%eax
80109b59:	c1 e0 08             	shl    $0x8,%eax
80109b5c:	89 c2                	mov    %eax,%edx
80109b5e:	8b 45 f8             	mov    -0x8(%ebp),%eax
80109b61:	01 c0                	add    %eax,%eax
80109b63:	8d 48 01             	lea    0x1(%eax),%ecx
80109b66:	8b 45 f4             	mov    -0xc(%ebp),%eax
80109b69:	01 c8                	add    %ecx,%eax
80109b6b:	0f b6 00             	movzbl (%eax),%eax
80109b6e:	0f b6 c0             	movzbl %al,%eax
80109b71:	01 d0                	add    %edx,%eax
80109b73:	01 45 fc             	add    %eax,-0x4(%ebp)
    if(chk_sum > 0xFFFF){
80109b76:	81 7d fc ff ff 00 00 	cmpl   $0xffff,-0x4(%ebp)
80109b7d:	76 0c                	jbe    80109b8b <icmp_chksum+0x60>
      chk_sum = (chk_sum&0xFFFF)+1;
80109b7f:	8b 45 fc             	mov    -0x4(%ebp),%eax
80109b82:	0f b7 c0             	movzwl %ax,%eax
80109b85:	83 c0 01             	add    $0x1,%eax
80109b88:	89 45 fc             	mov    %eax,-0x4(%ebp)
  for(int i=0;i<32;i++){
80109b8b:	83 45 f8 01          	addl   $0x1,-0x8(%ebp)
80109b8f:	83 7d f8 1f          	cmpl   $0x1f,-0x8(%ebp)
80109b93:	7e b2                	jle    80109b47 <icmp_chksum+0x1c>
    }
  }
  return ~(chk_sum);
80109b95:	8b 45 fc             	mov    -0x4(%ebp),%eax
80109b98:	f7 d0                	not    %eax
}
80109b9a:	c9                   	leave  
80109b9b:	c3                   	ret    

80109b9c <tcp_proc>:
extern ushort send_id;
extern uchar mac_addr[6];
extern uchar my_ip[4];
int fin_flag = 0;

void tcp_proc(uint buffer_addr){
80109b9c:	55                   	push   %ebp
80109b9d:	89 e5                	mov    %esp,%ebp
80109b9f:	83 ec 38             	sub    $0x38,%esp
  struct ipv4_pkt *ipv4_p = (struct ipv4_pkt *)(buffer_addr + sizeof(struct eth_pkt));
80109ba2:	8b 45 08             	mov    0x8(%ebp),%eax
80109ba5:	83 c0 0e             	add    $0xe,%eax
80109ba8:	89 45 f4             	mov    %eax,-0xc(%ebp)
  struct tcp_pkt *tcp_p = (struct tcp_pkt *)((uint)ipv4_p + (ipv4_p->ver&0xF)*4);
80109bab:	8b 45 f4             	mov    -0xc(%ebp),%eax
80109bae:	0f b6 00             	movzbl (%eax),%eax
80109bb1:	0f b6 c0             	movzbl %al,%eax
80109bb4:	83 e0 0f             	and    $0xf,%eax
80109bb7:	c1 e0 02             	shl    $0x2,%eax
80109bba:	89 c2                	mov    %eax,%edx
80109bbc:	8b 45 f4             	mov    -0xc(%ebp),%eax
80109bbf:	01 d0                	add    %edx,%eax
80109bc1:	89 45 f0             	mov    %eax,-0x10(%ebp)
  char *payload = (char *)((uint)tcp_p + 20);
80109bc4:	8b 45 f0             	mov    -0x10(%ebp),%eax
80109bc7:	83 c0 14             	add    $0x14,%eax
80109bca:	89 45 ec             	mov    %eax,-0x14(%ebp)
  uint send_addr = (uint)kalloc();
80109bcd:	e8 ce 8b ff ff       	call   801027a0 <kalloc>
80109bd2:	89 45 e8             	mov    %eax,-0x18(%ebp)
  uint send_size = 0;
80109bd5:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
  if(tcp_p->code_bits[1]&TCP_CODEBITS_SYN){
80109bdc:	8b 45 f0             	mov    -0x10(%ebp),%eax
80109bdf:	0f b6 40 0d          	movzbl 0xd(%eax),%eax
80109be3:	0f b6 c0             	movzbl %al,%eax
80109be6:	83 e0 02             	and    $0x2,%eax
80109be9:	85 c0                	test   %eax,%eax
80109beb:	74 3d                	je     80109c2a <tcp_proc+0x8e>
    tcp_pkt_create(buffer_addr,send_addr,&send_size,TCP_CODEBITS_ACK | TCP_CODEBITS_SYN,0);
80109bed:	83 ec 0c             	sub    $0xc,%esp
80109bf0:	6a 00                	push   $0x0
80109bf2:	6a 12                	push   $0x12
80109bf4:	8d 45 dc             	lea    -0x24(%ebp),%eax
80109bf7:	50                   	push   %eax
80109bf8:	ff 75 e8             	push   -0x18(%ebp)
80109bfb:	ff 75 08             	push   0x8(%ebp)
80109bfe:	e8 a2 01 00 00       	call   80109da5 <tcp_pkt_create>
80109c03:	83 c4 20             	add    $0x20,%esp
    i8254_send(send_addr,send_size);
80109c06:	8b 45 dc             	mov    -0x24(%ebp),%eax
80109c09:	83 ec 08             	sub    $0x8,%esp
80109c0c:	50                   	push   %eax
80109c0d:	ff 75 e8             	push   -0x18(%ebp)
80109c10:	e8 61 f1 ff ff       	call   80108d76 <i8254_send>
80109c15:	83 c4 10             	add    $0x10,%esp
    seq_num++;
80109c18:	a1 64 71 19 80       	mov    0x80197164,%eax
80109c1d:	83 c0 01             	add    $0x1,%eax
80109c20:	a3 64 71 19 80       	mov    %eax,0x80197164
80109c25:	e9 69 01 00 00       	jmp    80109d93 <tcp_proc+0x1f7>
  }else if(tcp_p->code_bits[1] == (TCP_CODEBITS_PSH | TCP_CODEBITS_ACK)){
80109c2a:	8b 45 f0             	mov    -0x10(%ebp),%eax
80109c2d:	0f b6 40 0d          	movzbl 0xd(%eax),%eax
80109c31:	3c 18                	cmp    $0x18,%al
80109c33:	0f 85 10 01 00 00    	jne    80109d49 <tcp_proc+0x1ad>
    if(memcmp(payload,"GET",3)){
80109c39:	83 ec 04             	sub    $0x4,%esp
80109c3c:	6a 03                	push   $0x3
80109c3e:	68 3e c2 10 80       	push   $0x8010c23e
80109c43:	ff 75 ec             	push   -0x14(%ebp)
80109c46:	e8 4b b0 ff ff       	call   80104c96 <memcmp>
80109c4b:	83 c4 10             	add    $0x10,%esp
80109c4e:	85 c0                	test   %eax,%eax
80109c50:	74 74                	je     80109cc6 <tcp_proc+0x12a>
      cprintf("ACK PSH\n");
80109c52:	83 ec 0c             	sub    $0xc,%esp
80109c55:	68 42 c2 10 80       	push   $0x8010c242
80109c5a:	e8 95 67 ff ff       	call   801003f4 <cprintf>
80109c5f:	83 c4 10             	add    $0x10,%esp
      tcp_pkt_create(buffer_addr,send_addr,&send_size,TCP_CODEBITS_ACK,0);
80109c62:	83 ec 0c             	sub    $0xc,%esp
80109c65:	6a 00                	push   $0x0
80109c67:	6a 10                	push   $0x10
80109c69:	8d 45 dc             	lea    -0x24(%ebp),%eax
80109c6c:	50                   	push   %eax
80109c6d:	ff 75 e8             	push   -0x18(%ebp)
80109c70:	ff 75 08             	push   0x8(%ebp)
80109c73:	e8 2d 01 00 00       	call   80109da5 <tcp_pkt_create>
80109c78:	83 c4 20             	add    $0x20,%esp
      i8254_send(send_addr,send_size);
80109c7b:	8b 45 dc             	mov    -0x24(%ebp),%eax
80109c7e:	83 ec 08             	sub    $0x8,%esp
80109c81:	50                   	push   %eax
80109c82:	ff 75 e8             	push   -0x18(%ebp)
80109c85:	e8 ec f0 ff ff       	call   80108d76 <i8254_send>
80109c8a:	83 c4 10             	add    $0x10,%esp
      uint send_payload = (send_addr + sizeof(struct eth_pkt) + sizeof(struct ipv4_pkt) + sizeof(struct tcp_pkt));
80109c8d:	8b 45 e8             	mov    -0x18(%ebp),%eax
80109c90:	83 c0 36             	add    $0x36,%eax
80109c93:	89 45 e0             	mov    %eax,-0x20(%ebp)
      uint payload_size;
      http_proc(0,0,send_payload,&payload_size);
80109c96:	8d 45 d8             	lea    -0x28(%ebp),%eax
80109c99:	50                   	push   %eax
80109c9a:	ff 75 e0             	push   -0x20(%ebp)
80109c9d:	6a 00                	push   $0x0
80109c9f:	6a 00                	push   $0x0
80109ca1:	e8 5a 04 00 00       	call   8010a100 <http_proc>
80109ca6:	83 c4 10             	add    $0x10,%esp
      tcp_pkt_create(buffer_addr,send_addr,&send_size,(TCP_CODEBITS_ACK|TCP_CODEBITS_PSH),payload_size);
80109ca9:	8b 45 d8             	mov    -0x28(%ebp),%eax
80109cac:	83 ec 0c             	sub    $0xc,%esp
80109caf:	50                   	push   %eax
80109cb0:	6a 18                	push   $0x18
80109cb2:	8d 45 dc             	lea    -0x24(%ebp),%eax
80109cb5:	50                   	push   %eax
80109cb6:	ff 75 e8             	push   -0x18(%ebp)
80109cb9:	ff 75 08             	push   0x8(%ebp)
80109cbc:	e8 e4 00 00 00       	call   80109da5 <tcp_pkt_create>
80109cc1:	83 c4 20             	add    $0x20,%esp
80109cc4:	eb 62                	jmp    80109d28 <tcp_proc+0x18c>
    }else{
     tcp_pkt_create(buffer_addr,send_addr,&send_size,TCP_CODEBITS_ACK,0);
80109cc6:	83 ec 0c             	sub    $0xc,%esp
80109cc9:	6a 00                	push   $0x0
80109ccb:	6a 10                	push   $0x10
80109ccd:	8d 45 dc             	lea    -0x24(%ebp),%eax
80109cd0:	50                   	push   %eax
80109cd1:	ff 75 e8             	push   -0x18(%ebp)
80109cd4:	ff 75 08             	push   0x8(%ebp)
80109cd7:	e8 c9 00 00 00       	call   80109da5 <tcp_pkt_create>
80109cdc:	83 c4 20             	add    $0x20,%esp
     i8254_send(send_addr,send_size);
80109cdf:	8b 45 dc             	mov    -0x24(%ebp),%eax
80109ce2:	83 ec 08             	sub    $0x8,%esp
80109ce5:	50                   	push   %eax
80109ce6:	ff 75 e8             	push   -0x18(%ebp)
80109ce9:	e8 88 f0 ff ff       	call   80108d76 <i8254_send>
80109cee:	83 c4 10             	add    $0x10,%esp
      uint send_payload = (send_addr + sizeof(struct eth_pkt) + sizeof(struct ipv4_pkt) + sizeof(struct tcp_pkt));
80109cf1:	8b 45 e8             	mov    -0x18(%ebp),%eax
80109cf4:	83 c0 36             	add    $0x36,%eax
80109cf7:	89 45 e4             	mov    %eax,-0x1c(%ebp)
      uint payload_size;
      http_proc(0,0,send_payload,&payload_size);
80109cfa:	8d 45 d4             	lea    -0x2c(%ebp),%eax
80109cfd:	50                   	push   %eax
80109cfe:	ff 75 e4             	push   -0x1c(%ebp)
80109d01:	6a 00                	push   $0x0
80109d03:	6a 00                	push   $0x0
80109d05:	e8 f6 03 00 00       	call   8010a100 <http_proc>
80109d0a:	83 c4 10             	add    $0x10,%esp
      tcp_pkt_create(buffer_addr,send_addr,&send_size,(TCP_CODEBITS_ACK|TCP_CODEBITS_PSH),payload_size);
80109d0d:	8b 45 d4             	mov    -0x2c(%ebp),%eax
80109d10:	83 ec 0c             	sub    $0xc,%esp
80109d13:	50                   	push   %eax
80109d14:	6a 18                	push   $0x18
80109d16:	8d 45 dc             	lea    -0x24(%ebp),%eax
80109d19:	50                   	push   %eax
80109d1a:	ff 75 e8             	push   -0x18(%ebp)
80109d1d:	ff 75 08             	push   0x8(%ebp)
80109d20:	e8 80 00 00 00       	call   80109da5 <tcp_pkt_create>
80109d25:	83 c4 20             	add    $0x20,%esp
    }
    i8254_send(send_addr,send_size);
80109d28:	8b 45 dc             	mov    -0x24(%ebp),%eax
80109d2b:	83 ec 08             	sub    $0x8,%esp
80109d2e:	50                   	push   %eax
80109d2f:	ff 75 e8             	push   -0x18(%ebp)
80109d32:	e8 3f f0 ff ff       	call   80108d76 <i8254_send>
80109d37:	83 c4 10             	add    $0x10,%esp
    seq_num++;
80109d3a:	a1 64 71 19 80       	mov    0x80197164,%eax
80109d3f:	83 c0 01             	add    $0x1,%eax
80109d42:	a3 64 71 19 80       	mov    %eax,0x80197164
80109d47:	eb 4a                	jmp    80109d93 <tcp_proc+0x1f7>
  }else if(tcp_p->code_bits[1] == TCP_CODEBITS_ACK){
80109d49:	8b 45 f0             	mov    -0x10(%ebp),%eax
80109d4c:	0f b6 40 0d          	movzbl 0xd(%eax),%eax
80109d50:	3c 10                	cmp    $0x10,%al
80109d52:	75 3f                	jne    80109d93 <tcp_proc+0x1f7>
    if(fin_flag == 1){
80109d54:	a1 68 71 19 80       	mov    0x80197168,%eax
80109d59:	83 f8 01             	cmp    $0x1,%eax
80109d5c:	75 35                	jne    80109d93 <tcp_proc+0x1f7>
      tcp_pkt_create(buffer_addr,send_addr,&send_size,TCP_CODEBITS_FIN,0);
80109d5e:	83 ec 0c             	sub    $0xc,%esp
80109d61:	6a 00                	push   $0x0
80109d63:	6a 01                	push   $0x1
80109d65:	8d 45 dc             	lea    -0x24(%ebp),%eax
80109d68:	50                   	push   %eax
80109d69:	ff 75 e8             	push   -0x18(%ebp)
80109d6c:	ff 75 08             	push   0x8(%ebp)
80109d6f:	e8 31 00 00 00       	call   80109da5 <tcp_pkt_create>
80109d74:	83 c4 20             	add    $0x20,%esp
      i8254_send(send_addr,send_size);
80109d77:	8b 45 dc             	mov    -0x24(%ebp),%eax
80109d7a:	83 ec 08             	sub    $0x8,%esp
80109d7d:	50                   	push   %eax
80109d7e:	ff 75 e8             	push   -0x18(%ebp)
80109d81:	e8 f0 ef ff ff       	call   80108d76 <i8254_send>
80109d86:	83 c4 10             	add    $0x10,%esp
      fin_flag = 0;
80109d89:	c7 05 68 71 19 80 00 	movl   $0x0,0x80197168
80109d90:	00 00 00 
    }
  }
  kfree((char *)send_addr);
80109d93:	8b 45 e8             	mov    -0x18(%ebp),%eax
80109d96:	83 ec 0c             	sub    $0xc,%esp
80109d99:	50                   	push   %eax
80109d9a:	e8 67 89 ff ff       	call   80102706 <kfree>
80109d9f:	83 c4 10             	add    $0x10,%esp
}
80109da2:	90                   	nop
80109da3:	c9                   	leave  
80109da4:	c3                   	ret    

80109da5 <tcp_pkt_create>:

void tcp_pkt_create(uint recv_addr,uint send_addr,uint *send_size,uint pkt_type,uint payload_size){
80109da5:	55                   	push   %ebp
80109da6:	89 e5                	mov    %esp,%ebp
80109da8:	83 ec 28             	sub    $0x28,%esp
  struct eth_pkt *eth_recv = (struct eth_pkt *)(recv_addr);
80109dab:	8b 45 08             	mov    0x8(%ebp),%eax
80109dae:	89 45 f4             	mov    %eax,-0xc(%ebp)
  struct ipv4_pkt *ipv4_recv = (struct ipv4_pkt *)(recv_addr+sizeof(struct eth_pkt));
80109db1:	8b 45 08             	mov    0x8(%ebp),%eax
80109db4:	83 c0 0e             	add    $0xe,%eax
80109db7:	89 45 f0             	mov    %eax,-0x10(%ebp)
  struct tcp_pkt *tcp_recv = (struct tcp_pkt *)((uint)ipv4_recv + (ipv4_recv->ver&0xF)*4);
80109dba:	8b 45 f0             	mov    -0x10(%ebp),%eax
80109dbd:	0f b6 00             	movzbl (%eax),%eax
80109dc0:	0f b6 c0             	movzbl %al,%eax
80109dc3:	83 e0 0f             	and    $0xf,%eax
80109dc6:	c1 e0 02             	shl    $0x2,%eax
80109dc9:	89 c2                	mov    %eax,%edx
80109dcb:	8b 45 f0             	mov    -0x10(%ebp),%eax
80109dce:	01 d0                	add    %edx,%eax
80109dd0:	89 45 ec             	mov    %eax,-0x14(%ebp)

  struct eth_pkt *eth_send = (struct eth_pkt *)(send_addr);
80109dd3:	8b 45 0c             	mov    0xc(%ebp),%eax
80109dd6:	89 45 e8             	mov    %eax,-0x18(%ebp)
  struct ipv4_pkt *ipv4_send = (struct ipv4_pkt *)(send_addr + sizeof(struct eth_pkt));
80109dd9:	8b 45 0c             	mov    0xc(%ebp),%eax
80109ddc:	83 c0 0e             	add    $0xe,%eax
80109ddf:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  struct tcp_pkt *tcp_send = (struct tcp_pkt *)((uint)ipv4_send + sizeof(struct ipv4_pkt));
80109de2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80109de5:	83 c0 14             	add    $0x14,%eax
80109de8:	89 45 e0             	mov    %eax,-0x20(%ebp)

  *send_size = sizeof(struct eth_pkt) + sizeof(struct ipv4_pkt) + sizeof(struct tcp_pkt) + payload_size;
80109deb:	8b 45 18             	mov    0x18(%ebp),%eax
80109dee:	8d 50 36             	lea    0x36(%eax),%edx
80109df1:	8b 45 10             	mov    0x10(%ebp),%eax
80109df4:	89 10                	mov    %edx,(%eax)

  memmove(eth_send->dst_mac,eth_recv->src_mac,6);
80109df6:	8b 45 f4             	mov    -0xc(%ebp),%eax
80109df9:	8d 50 06             	lea    0x6(%eax),%edx
80109dfc:	8b 45 e8             	mov    -0x18(%ebp),%eax
80109dff:	83 ec 04             	sub    $0x4,%esp
80109e02:	6a 06                	push   $0x6
80109e04:	52                   	push   %edx
80109e05:	50                   	push   %eax
80109e06:	e8 e3 ae ff ff       	call   80104cee <memmove>
80109e0b:	83 c4 10             	add    $0x10,%esp
  memmove(eth_send->src_mac,mac_addr,6);
80109e0e:	8b 45 e8             	mov    -0x18(%ebp),%eax
80109e11:	83 c0 06             	add    $0x6,%eax
80109e14:	83 ec 04             	sub    $0x4,%esp
80109e17:	6a 06                	push   $0x6
80109e19:	68 80 6e 19 80       	push   $0x80196e80
80109e1e:	50                   	push   %eax
80109e1f:	e8 ca ae ff ff       	call   80104cee <memmove>
80109e24:	83 c4 10             	add    $0x10,%esp
  eth_send->type[0] = 0x08;
80109e27:	8b 45 e8             	mov    -0x18(%ebp),%eax
80109e2a:	c6 40 0c 08          	movb   $0x8,0xc(%eax)
  eth_send->type[1] = 0x00;
80109e2e:	8b 45 e8             	mov    -0x18(%ebp),%eax
80109e31:	c6 40 0d 00          	movb   $0x0,0xd(%eax)

  ipv4_send->ver = ((0x4)<<4)+((sizeof(struct ipv4_pkt)/4)&0xF);
80109e35:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80109e38:	c6 00 45             	movb   $0x45,(%eax)
  ipv4_send->srv_type = 0;
80109e3b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80109e3e:	c6 40 01 00          	movb   $0x0,0x1(%eax)
  ipv4_send->total_len = H2N_ushort(sizeof(struct ipv4_pkt) + sizeof(struct tcp_pkt) + payload_size);
80109e42:	8b 45 18             	mov    0x18(%ebp),%eax
80109e45:	83 c0 28             	add    $0x28,%eax
80109e48:	0f b7 c0             	movzwl %ax,%eax
80109e4b:	83 ec 0c             	sub    $0xc,%esp
80109e4e:	50                   	push   %eax
80109e4f:	e8 9b f8 ff ff       	call   801096ef <H2N_ushort>
80109e54:	83 c4 10             	add    $0x10,%esp
80109e57:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80109e5a:	66 89 42 02          	mov    %ax,0x2(%edx)
  ipv4_send->id = send_id;
80109e5e:	0f b7 15 60 71 19 80 	movzwl 0x80197160,%edx
80109e65:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80109e68:	66 89 50 04          	mov    %dx,0x4(%eax)
  send_id++;
80109e6c:	0f b7 05 60 71 19 80 	movzwl 0x80197160,%eax
80109e73:	83 c0 01             	add    $0x1,%eax
80109e76:	66 a3 60 71 19 80    	mov    %ax,0x80197160
  ipv4_send->fragment = H2N_ushort(0x0000);
80109e7c:	83 ec 0c             	sub    $0xc,%esp
80109e7f:	6a 00                	push   $0x0
80109e81:	e8 69 f8 ff ff       	call   801096ef <H2N_ushort>
80109e86:	83 c4 10             	add    $0x10,%esp
80109e89:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80109e8c:	66 89 42 06          	mov    %ax,0x6(%edx)
  ipv4_send->ttl = 255;
80109e90:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80109e93:	c6 40 08 ff          	movb   $0xff,0x8(%eax)
  ipv4_send->protocol = IPV4_TYPE_TCP;
80109e97:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80109e9a:	c6 40 09 06          	movb   $0x6,0x9(%eax)
  memmove(ipv4_send->src_ip,my_ip,4);
80109e9e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80109ea1:	83 c0 0c             	add    $0xc,%eax
80109ea4:	83 ec 04             	sub    $0x4,%esp
80109ea7:	6a 04                	push   $0x4
80109ea9:	68 04 f5 10 80       	push   $0x8010f504
80109eae:	50                   	push   %eax
80109eaf:	e8 3a ae ff ff       	call   80104cee <memmove>
80109eb4:	83 c4 10             	add    $0x10,%esp
  memmove(ipv4_send->dst_ip,ipv4_recv->src_ip,4);
80109eb7:	8b 45 f0             	mov    -0x10(%ebp),%eax
80109eba:	8d 50 0c             	lea    0xc(%eax),%edx
80109ebd:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80109ec0:	83 c0 10             	add    $0x10,%eax
80109ec3:	83 ec 04             	sub    $0x4,%esp
80109ec6:	6a 04                	push   $0x4
80109ec8:	52                   	push   %edx
80109ec9:	50                   	push   %eax
80109eca:	e8 1f ae ff ff       	call   80104cee <memmove>
80109ecf:	83 c4 10             	add    $0x10,%esp
  ipv4_send->chk_sum = 0;
80109ed2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80109ed5:	66 c7 40 0a 00 00    	movw   $0x0,0xa(%eax)
  ipv4_send->chk_sum = H2N_ushort(ipv4_chksum((uint)ipv4_send));
80109edb:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80109ede:	83 ec 0c             	sub    $0xc,%esp
80109ee1:	50                   	push   %eax
80109ee2:	e8 08 f9 ff ff       	call   801097ef <ipv4_chksum>
80109ee7:	83 c4 10             	add    $0x10,%esp
80109eea:	0f b7 c0             	movzwl %ax,%eax
80109eed:	83 ec 0c             	sub    $0xc,%esp
80109ef0:	50                   	push   %eax
80109ef1:	e8 f9 f7 ff ff       	call   801096ef <H2N_ushort>
80109ef6:	83 c4 10             	add    $0x10,%esp
80109ef9:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80109efc:	66 89 42 0a          	mov    %ax,0xa(%edx)
  

  tcp_send->src_port = tcp_recv->dst_port;
80109f00:	8b 45 ec             	mov    -0x14(%ebp),%eax
80109f03:	0f b7 50 02          	movzwl 0x2(%eax),%edx
80109f07:	8b 45 e0             	mov    -0x20(%ebp),%eax
80109f0a:	66 89 10             	mov    %dx,(%eax)
  tcp_send->dst_port = tcp_recv->src_port;
80109f0d:	8b 45 ec             	mov    -0x14(%ebp),%eax
80109f10:	0f b7 10             	movzwl (%eax),%edx
80109f13:	8b 45 e0             	mov    -0x20(%ebp),%eax
80109f16:	66 89 50 02          	mov    %dx,0x2(%eax)
  tcp_send->seq_num = H2N_uint(seq_num);
80109f1a:	a1 64 71 19 80       	mov    0x80197164,%eax
80109f1f:	83 ec 0c             	sub    $0xc,%esp
80109f22:	50                   	push   %eax
80109f23:	e8 e9 f7 ff ff       	call   80109711 <H2N_uint>
80109f28:	83 c4 10             	add    $0x10,%esp
80109f2b:	8b 55 e0             	mov    -0x20(%ebp),%edx
80109f2e:	89 42 04             	mov    %eax,0x4(%edx)
  tcp_send->ack_num = tcp_recv->seq_num + (1<<(8*3));
80109f31:	8b 45 ec             	mov    -0x14(%ebp),%eax
80109f34:	8b 40 04             	mov    0x4(%eax),%eax
80109f37:	8d 90 00 00 00 01    	lea    0x1000000(%eax),%edx
80109f3d:	8b 45 e0             	mov    -0x20(%ebp),%eax
80109f40:	89 50 08             	mov    %edx,0x8(%eax)

  tcp_send->code_bits[0] = 0;
80109f43:	8b 45 e0             	mov    -0x20(%ebp),%eax
80109f46:	c6 40 0c 00          	movb   $0x0,0xc(%eax)
  tcp_send->code_bits[1] = 0;
80109f4a:	8b 45 e0             	mov    -0x20(%ebp),%eax
80109f4d:	c6 40 0d 00          	movb   $0x0,0xd(%eax)
  tcp_send->code_bits[0] = 5<<4;
80109f51:	8b 45 e0             	mov    -0x20(%ebp),%eax
80109f54:	c6 40 0c 50          	movb   $0x50,0xc(%eax)
  tcp_send->code_bits[1] = pkt_type;
80109f58:	8b 45 14             	mov    0x14(%ebp),%eax
80109f5b:	89 c2                	mov    %eax,%edx
80109f5d:	8b 45 e0             	mov    -0x20(%ebp),%eax
80109f60:	88 50 0d             	mov    %dl,0xd(%eax)

  tcp_send->window = H2N_ushort(14480);
80109f63:	83 ec 0c             	sub    $0xc,%esp
80109f66:	68 90 38 00 00       	push   $0x3890
80109f6b:	e8 7f f7 ff ff       	call   801096ef <H2N_ushort>
80109f70:	83 c4 10             	add    $0x10,%esp
80109f73:	8b 55 e0             	mov    -0x20(%ebp),%edx
80109f76:	66 89 42 0e          	mov    %ax,0xe(%edx)
  tcp_send->urgent_ptr = 0;
80109f7a:	8b 45 e0             	mov    -0x20(%ebp),%eax
80109f7d:	66 c7 40 12 00 00    	movw   $0x0,0x12(%eax)
  tcp_send->chk_sum = 0;
80109f83:	8b 45 e0             	mov    -0x20(%ebp),%eax
80109f86:	66 c7 40 10 00 00    	movw   $0x0,0x10(%eax)

  tcp_send->chk_sum = H2N_ushort(tcp_chksum((uint)(ipv4_send))+8);
80109f8c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80109f8f:	83 ec 0c             	sub    $0xc,%esp
80109f92:	50                   	push   %eax
80109f93:	e8 1f 00 00 00       	call   80109fb7 <tcp_chksum>
80109f98:	83 c4 10             	add    $0x10,%esp
80109f9b:	83 c0 08             	add    $0x8,%eax
80109f9e:	0f b7 c0             	movzwl %ax,%eax
80109fa1:	83 ec 0c             	sub    $0xc,%esp
80109fa4:	50                   	push   %eax
80109fa5:	e8 45 f7 ff ff       	call   801096ef <H2N_ushort>
80109faa:	83 c4 10             	add    $0x10,%esp
80109fad:	8b 55 e0             	mov    -0x20(%ebp),%edx
80109fb0:	66 89 42 10          	mov    %ax,0x10(%edx)


}
80109fb4:	90                   	nop
80109fb5:	c9                   	leave  
80109fb6:	c3                   	ret    

80109fb7 <tcp_chksum>:

ushort tcp_chksum(uint tcp_addr){
80109fb7:	55                   	push   %ebp
80109fb8:	89 e5                	mov    %esp,%ebp
80109fba:	83 ec 38             	sub    $0x38,%esp
  struct ipv4_pkt *ipv4_p = (struct ipv4_pkt *)(tcp_addr);
80109fbd:	8b 45 08             	mov    0x8(%ebp),%eax
80109fc0:	89 45 e8             	mov    %eax,-0x18(%ebp)
  struct tcp_pkt *tcp_p = (struct tcp_pkt *)((uint)ipv4_p + sizeof(struct ipv4_pkt));
80109fc3:	8b 45 e8             	mov    -0x18(%ebp),%eax
80109fc6:	83 c0 14             	add    $0x14,%eax
80109fc9:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  struct tcp_dummy tcp_dummy;
  
  memmove(tcp_dummy.src_ip,my_ip,4);
80109fcc:	83 ec 04             	sub    $0x4,%esp
80109fcf:	6a 04                	push   $0x4
80109fd1:	68 04 f5 10 80       	push   $0x8010f504
80109fd6:	8d 45 d4             	lea    -0x2c(%ebp),%eax
80109fd9:	50                   	push   %eax
80109fda:	e8 0f ad ff ff       	call   80104cee <memmove>
80109fdf:	83 c4 10             	add    $0x10,%esp
  memmove(tcp_dummy.dst_ip,ipv4_p->src_ip,4);
80109fe2:	8b 45 e8             	mov    -0x18(%ebp),%eax
80109fe5:	83 c0 0c             	add    $0xc,%eax
80109fe8:	83 ec 04             	sub    $0x4,%esp
80109feb:	6a 04                	push   $0x4
80109fed:	50                   	push   %eax
80109fee:	8d 45 d4             	lea    -0x2c(%ebp),%eax
80109ff1:	83 c0 04             	add    $0x4,%eax
80109ff4:	50                   	push   %eax
80109ff5:	e8 f4 ac ff ff       	call   80104cee <memmove>
80109ffa:	83 c4 10             	add    $0x10,%esp
  tcp_dummy.padding = 0;
80109ffd:	c6 45 dc 00          	movb   $0x0,-0x24(%ebp)
  tcp_dummy.protocol = IPV4_TYPE_TCP;
8010a001:	c6 45 dd 06          	movb   $0x6,-0x23(%ebp)
  tcp_dummy.tcp_len = H2N_ushort(N2H_ushort(ipv4_p->total_len) - sizeof(struct ipv4_pkt));
8010a005:	8b 45 e8             	mov    -0x18(%ebp),%eax
8010a008:	0f b7 40 02          	movzwl 0x2(%eax),%eax
8010a00c:	0f b7 c0             	movzwl %ax,%eax
8010a00f:	83 ec 0c             	sub    $0xc,%esp
8010a012:	50                   	push   %eax
8010a013:	e8 b5 f6 ff ff       	call   801096cd <N2H_ushort>
8010a018:	83 c4 10             	add    $0x10,%esp
8010a01b:	83 e8 14             	sub    $0x14,%eax
8010a01e:	0f b7 c0             	movzwl %ax,%eax
8010a021:	83 ec 0c             	sub    $0xc,%esp
8010a024:	50                   	push   %eax
8010a025:	e8 c5 f6 ff ff       	call   801096ef <H2N_ushort>
8010a02a:	83 c4 10             	add    $0x10,%esp
8010a02d:	66 89 45 de          	mov    %ax,-0x22(%ebp)
  uint chk_sum = 0;
8010a031:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  uchar *bin = (uchar *)(&tcp_dummy);
8010a038:	8d 45 d4             	lea    -0x2c(%ebp),%eax
8010a03b:	89 45 e0             	mov    %eax,-0x20(%ebp)
  for(int i=0;i<6;i++){
8010a03e:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
8010a045:	eb 33                	jmp    8010a07a <tcp_chksum+0xc3>
    chk_sum += (bin[i*2]<<8)+bin[i*2+1];
8010a047:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010a04a:	01 c0                	add    %eax,%eax
8010a04c:	89 c2                	mov    %eax,%edx
8010a04e:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010a051:	01 d0                	add    %edx,%eax
8010a053:	0f b6 00             	movzbl (%eax),%eax
8010a056:	0f b6 c0             	movzbl %al,%eax
8010a059:	c1 e0 08             	shl    $0x8,%eax
8010a05c:	89 c2                	mov    %eax,%edx
8010a05e:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010a061:	01 c0                	add    %eax,%eax
8010a063:	8d 48 01             	lea    0x1(%eax),%ecx
8010a066:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010a069:	01 c8                	add    %ecx,%eax
8010a06b:	0f b6 00             	movzbl (%eax),%eax
8010a06e:	0f b6 c0             	movzbl %al,%eax
8010a071:	01 d0                	add    %edx,%eax
8010a073:	01 45 f4             	add    %eax,-0xc(%ebp)
  for(int i=0;i<6;i++){
8010a076:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
8010a07a:	83 7d f0 05          	cmpl   $0x5,-0x10(%ebp)
8010a07e:	7e c7                	jle    8010a047 <tcp_chksum+0x90>
  }

  bin = (uchar *)(tcp_p);
8010a080:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010a083:	89 45 e0             	mov    %eax,-0x20(%ebp)
  for(int i=0;i<(N2H_ushort(tcp_dummy.tcp_len)/2);i++){
8010a086:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
8010a08d:	eb 33                	jmp    8010a0c2 <tcp_chksum+0x10b>
    chk_sum += (bin[i*2]<<8)+bin[i*2+1];
8010a08f:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010a092:	01 c0                	add    %eax,%eax
8010a094:	89 c2                	mov    %eax,%edx
8010a096:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010a099:	01 d0                	add    %edx,%eax
8010a09b:	0f b6 00             	movzbl (%eax),%eax
8010a09e:	0f b6 c0             	movzbl %al,%eax
8010a0a1:	c1 e0 08             	shl    $0x8,%eax
8010a0a4:	89 c2                	mov    %eax,%edx
8010a0a6:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010a0a9:	01 c0                	add    %eax,%eax
8010a0ab:	8d 48 01             	lea    0x1(%eax),%ecx
8010a0ae:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010a0b1:	01 c8                	add    %ecx,%eax
8010a0b3:	0f b6 00             	movzbl (%eax),%eax
8010a0b6:	0f b6 c0             	movzbl %al,%eax
8010a0b9:	01 d0                	add    %edx,%eax
8010a0bb:	01 45 f4             	add    %eax,-0xc(%ebp)
  for(int i=0;i<(N2H_ushort(tcp_dummy.tcp_len)/2);i++){
8010a0be:	83 45 ec 01          	addl   $0x1,-0x14(%ebp)
8010a0c2:	0f b7 45 de          	movzwl -0x22(%ebp),%eax
8010a0c6:	0f b7 c0             	movzwl %ax,%eax
8010a0c9:	83 ec 0c             	sub    $0xc,%esp
8010a0cc:	50                   	push   %eax
8010a0cd:	e8 fb f5 ff ff       	call   801096cd <N2H_ushort>
8010a0d2:	83 c4 10             	add    $0x10,%esp
8010a0d5:	66 d1 e8             	shr    %ax
8010a0d8:	0f b7 c0             	movzwl %ax,%eax
8010a0db:	39 45 ec             	cmp    %eax,-0x14(%ebp)
8010a0de:	7c af                	jl     8010a08f <tcp_chksum+0xd8>
  }
  chk_sum += (chk_sum>>8*2);
8010a0e0:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010a0e3:	c1 e8 10             	shr    $0x10,%eax
8010a0e6:	01 45 f4             	add    %eax,-0xc(%ebp)
  return ~(chk_sum);
8010a0e9:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010a0ec:	f7 d0                	not    %eax
}
8010a0ee:	c9                   	leave  
8010a0ef:	c3                   	ret    

8010a0f0 <tcp_fin>:

void tcp_fin(){
8010a0f0:	55                   	push   %ebp
8010a0f1:	89 e5                	mov    %esp,%ebp
  fin_flag =1;
8010a0f3:	c7 05 68 71 19 80 01 	movl   $0x1,0x80197168
8010a0fa:	00 00 00 
}
8010a0fd:	90                   	nop
8010a0fe:	5d                   	pop    %ebp
8010a0ff:	c3                   	ret    

8010a100 <http_proc>:
#include "defs.h"
#include "types.h"
#include "tcp.h"


void http_proc(uint recv, uint recv_size, uint send, uint *send_size){
8010a100:	55                   	push   %ebp
8010a101:	89 e5                	mov    %esp,%ebp
8010a103:	83 ec 18             	sub    $0x18,%esp
  int len;
  len = http_strcpy((char *)send,"HTTP/1.0 200 OK \r\n",0);
8010a106:	8b 45 10             	mov    0x10(%ebp),%eax
8010a109:	83 ec 04             	sub    $0x4,%esp
8010a10c:	6a 00                	push   $0x0
8010a10e:	68 4b c2 10 80       	push   $0x8010c24b
8010a113:	50                   	push   %eax
8010a114:	e8 65 00 00 00       	call   8010a17e <http_strcpy>
8010a119:	83 c4 10             	add    $0x10,%esp
8010a11c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  len += http_strcpy((char *)send,"Content-Type: text/html \r\n",len);
8010a11f:	8b 45 10             	mov    0x10(%ebp),%eax
8010a122:	83 ec 04             	sub    $0x4,%esp
8010a125:	ff 75 f4             	push   -0xc(%ebp)
8010a128:	68 5e c2 10 80       	push   $0x8010c25e
8010a12d:	50                   	push   %eax
8010a12e:	e8 4b 00 00 00       	call   8010a17e <http_strcpy>
8010a133:	83 c4 10             	add    $0x10,%esp
8010a136:	01 45 f4             	add    %eax,-0xc(%ebp)
  len += http_strcpy((char *)send,"\r\nHello World!\r\n",len);
8010a139:	8b 45 10             	mov    0x10(%ebp),%eax
8010a13c:	83 ec 04             	sub    $0x4,%esp
8010a13f:	ff 75 f4             	push   -0xc(%ebp)
8010a142:	68 79 c2 10 80       	push   $0x8010c279
8010a147:	50                   	push   %eax
8010a148:	e8 31 00 00 00       	call   8010a17e <http_strcpy>
8010a14d:	83 c4 10             	add    $0x10,%esp
8010a150:	01 45 f4             	add    %eax,-0xc(%ebp)
  if(len%2 != 0){
8010a153:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010a156:	83 e0 01             	and    $0x1,%eax
8010a159:	85 c0                	test   %eax,%eax
8010a15b:	74 11                	je     8010a16e <http_proc+0x6e>
    char *payload = (char *)send;
8010a15d:	8b 45 10             	mov    0x10(%ebp),%eax
8010a160:	89 45 f0             	mov    %eax,-0x10(%ebp)
    payload[len] = 0;
8010a163:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010a166:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010a169:	01 d0                	add    %edx,%eax
8010a16b:	c6 00 00             	movb   $0x0,(%eax)
  }
  *send_size = len;
8010a16e:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010a171:	8b 45 14             	mov    0x14(%ebp),%eax
8010a174:	89 10                	mov    %edx,(%eax)
  tcp_fin();
8010a176:	e8 75 ff ff ff       	call   8010a0f0 <tcp_fin>
}
8010a17b:	90                   	nop
8010a17c:	c9                   	leave  
8010a17d:	c3                   	ret    

8010a17e <http_strcpy>:

int http_strcpy(char *dst,const char *src,int start_index){
8010a17e:	55                   	push   %ebp
8010a17f:	89 e5                	mov    %esp,%ebp
8010a181:	83 ec 10             	sub    $0x10,%esp
  int i = 0;
8010a184:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while(src[i]){
8010a18b:	eb 20                	jmp    8010a1ad <http_strcpy+0x2f>
    dst[start_index+i] = src[i];
8010a18d:	8b 55 fc             	mov    -0x4(%ebp),%edx
8010a190:	8b 45 0c             	mov    0xc(%ebp),%eax
8010a193:	01 d0                	add    %edx,%eax
8010a195:	8b 4d 10             	mov    0x10(%ebp),%ecx
8010a198:	8b 55 fc             	mov    -0x4(%ebp),%edx
8010a19b:	01 ca                	add    %ecx,%edx
8010a19d:	89 d1                	mov    %edx,%ecx
8010a19f:	8b 55 08             	mov    0x8(%ebp),%edx
8010a1a2:	01 ca                	add    %ecx,%edx
8010a1a4:	0f b6 00             	movzbl (%eax),%eax
8010a1a7:	88 02                	mov    %al,(%edx)
    i++;
8010a1a9:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
  while(src[i]){
8010a1ad:	8b 55 fc             	mov    -0x4(%ebp),%edx
8010a1b0:	8b 45 0c             	mov    0xc(%ebp),%eax
8010a1b3:	01 d0                	add    %edx,%eax
8010a1b5:	0f b6 00             	movzbl (%eax),%eax
8010a1b8:	84 c0                	test   %al,%al
8010a1ba:	75 d1                	jne    8010a18d <http_strcpy+0xf>
  }
  return i;
8010a1bc:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
8010a1bf:	c9                   	leave  
8010a1c0:	c3                   	ret    

8010a1c1 <ideinit>:
static int disksize;
static uchar *memdisk;

void
ideinit(void)
{
8010a1c1:	55                   	push   %ebp
8010a1c2:	89 e5                	mov    %esp,%ebp
  memdisk = _binary_fs_img_start;
8010a1c4:	c7 05 70 71 19 80 c2 	movl   $0x8010f5c2,0x80197170
8010a1cb:	f5 10 80 
  disksize = (uint)_binary_fs_img_size/BSIZE;
8010a1ce:	b8 00 d0 07 00       	mov    $0x7d000,%eax
8010a1d3:	c1 e8 09             	shr    $0x9,%eax
8010a1d6:	a3 6c 71 19 80       	mov    %eax,0x8019716c
}
8010a1db:	90                   	nop
8010a1dc:	5d                   	pop    %ebp
8010a1dd:	c3                   	ret    

8010a1de <ideintr>:

// Interrupt handler.
void
ideintr(void)
{
8010a1de:	55                   	push   %ebp
8010a1df:	89 e5                	mov    %esp,%ebp
  // no-op
}
8010a1e1:	90                   	nop
8010a1e2:	5d                   	pop    %ebp
8010a1e3:	c3                   	ret    

8010a1e4 <iderw>:
// Sync buf with disk.
// If B_DIRTY is set, write buf to disk, clear B_DIRTY, set B_VALID.
// Else if B_VALID is not set, read buf from disk, set B_VALID.
void
iderw(struct buf *b)
{
8010a1e4:	55                   	push   %ebp
8010a1e5:	89 e5                	mov    %esp,%ebp
8010a1e7:	83 ec 18             	sub    $0x18,%esp
  uchar *p;

  if(!holdingsleep(&b->lock))
8010a1ea:	8b 45 08             	mov    0x8(%ebp),%eax
8010a1ed:	83 c0 0c             	add    $0xc,%eax
8010a1f0:	83 ec 0c             	sub    $0xc,%esp
8010a1f3:	50                   	push   %eax
8010a1f4:	e8 2f a7 ff ff       	call   80104928 <holdingsleep>
8010a1f9:	83 c4 10             	add    $0x10,%esp
8010a1fc:	85 c0                	test   %eax,%eax
8010a1fe:	75 0d                	jne    8010a20d <iderw+0x29>
    panic("iderw: buf not locked");
8010a200:	83 ec 0c             	sub    $0xc,%esp
8010a203:	68 8a c2 10 80       	push   $0x8010c28a
8010a208:	e8 9c 63 ff ff       	call   801005a9 <panic>
  if((b->flags & (B_VALID|B_DIRTY)) == B_VALID)
8010a20d:	8b 45 08             	mov    0x8(%ebp),%eax
8010a210:	8b 00                	mov    (%eax),%eax
8010a212:	83 e0 06             	and    $0x6,%eax
8010a215:	83 f8 02             	cmp    $0x2,%eax
8010a218:	75 0d                	jne    8010a227 <iderw+0x43>
    panic("iderw: nothing to do");
8010a21a:	83 ec 0c             	sub    $0xc,%esp
8010a21d:	68 a0 c2 10 80       	push   $0x8010c2a0
8010a222:	e8 82 63 ff ff       	call   801005a9 <panic>
  if(b->dev != 1)
8010a227:	8b 45 08             	mov    0x8(%ebp),%eax
8010a22a:	8b 40 04             	mov    0x4(%eax),%eax
8010a22d:	83 f8 01             	cmp    $0x1,%eax
8010a230:	74 0d                	je     8010a23f <iderw+0x5b>
    panic("iderw: request not for disk 1");
8010a232:	83 ec 0c             	sub    $0xc,%esp
8010a235:	68 b5 c2 10 80       	push   $0x8010c2b5
8010a23a:	e8 6a 63 ff ff       	call   801005a9 <panic>
  if(b->blockno >= disksize)
8010a23f:	8b 45 08             	mov    0x8(%ebp),%eax
8010a242:	8b 40 08             	mov    0x8(%eax),%eax
8010a245:	8b 15 6c 71 19 80    	mov    0x8019716c,%edx
8010a24b:	39 d0                	cmp    %edx,%eax
8010a24d:	72 0d                	jb     8010a25c <iderw+0x78>
    panic("iderw: block out of range");
8010a24f:	83 ec 0c             	sub    $0xc,%esp
8010a252:	68 d3 c2 10 80       	push   $0x8010c2d3
8010a257:	e8 4d 63 ff ff       	call   801005a9 <panic>

  p = memdisk + b->blockno*BSIZE;
8010a25c:	8b 15 70 71 19 80    	mov    0x80197170,%edx
8010a262:	8b 45 08             	mov    0x8(%ebp),%eax
8010a265:	8b 40 08             	mov    0x8(%eax),%eax
8010a268:	c1 e0 09             	shl    $0x9,%eax
8010a26b:	01 d0                	add    %edx,%eax
8010a26d:	89 45 f4             	mov    %eax,-0xc(%ebp)

  if(b->flags & B_DIRTY){
8010a270:	8b 45 08             	mov    0x8(%ebp),%eax
8010a273:	8b 00                	mov    (%eax),%eax
8010a275:	83 e0 04             	and    $0x4,%eax
8010a278:	85 c0                	test   %eax,%eax
8010a27a:	74 2b                	je     8010a2a7 <iderw+0xc3>
    b->flags &= ~B_DIRTY;
8010a27c:	8b 45 08             	mov    0x8(%ebp),%eax
8010a27f:	8b 00                	mov    (%eax),%eax
8010a281:	83 e0 fb             	and    $0xfffffffb,%eax
8010a284:	89 c2                	mov    %eax,%edx
8010a286:	8b 45 08             	mov    0x8(%ebp),%eax
8010a289:	89 10                	mov    %edx,(%eax)
    memmove(p, b->data, BSIZE);
8010a28b:	8b 45 08             	mov    0x8(%ebp),%eax
8010a28e:	83 c0 5c             	add    $0x5c,%eax
8010a291:	83 ec 04             	sub    $0x4,%esp
8010a294:	68 00 02 00 00       	push   $0x200
8010a299:	50                   	push   %eax
8010a29a:	ff 75 f4             	push   -0xc(%ebp)
8010a29d:	e8 4c aa ff ff       	call   80104cee <memmove>
8010a2a2:	83 c4 10             	add    $0x10,%esp
8010a2a5:	eb 1a                	jmp    8010a2c1 <iderw+0xdd>
  } else
    memmove(b->data, p, BSIZE);
8010a2a7:	8b 45 08             	mov    0x8(%ebp),%eax
8010a2aa:	83 c0 5c             	add    $0x5c,%eax
8010a2ad:	83 ec 04             	sub    $0x4,%esp
8010a2b0:	68 00 02 00 00       	push   $0x200
8010a2b5:	ff 75 f4             	push   -0xc(%ebp)
8010a2b8:	50                   	push   %eax
8010a2b9:	e8 30 aa ff ff       	call   80104cee <memmove>
8010a2be:	83 c4 10             	add    $0x10,%esp
  b->flags |= B_VALID;
8010a2c1:	8b 45 08             	mov    0x8(%ebp),%eax
8010a2c4:	8b 00                	mov    (%eax),%eax
8010a2c6:	83 c8 02             	or     $0x2,%eax
8010a2c9:	89 c2                	mov    %eax,%edx
8010a2cb:	8b 45 08             	mov    0x8(%ebp),%eax
8010a2ce:	89 10                	mov    %edx,(%eax)
}
8010a2d0:	90                   	nop
8010a2d1:	c9                   	leave  
8010a2d2:	c3                   	ret    
