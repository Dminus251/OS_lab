
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
8010006f:	68 00 a3 10 80       	push   $0x8010a300
80100074:	68 00 d0 18 80       	push   $0x8018d000
80100079:	e8 1e 49 00 00       	call   8010499c <initlock>
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
801000bd:	68 07 a3 10 80       	push   $0x8010a307
801000c2:	50                   	push   %eax
801000c3:	e8 77 47 00 00       	call   8010483f <initsleeplock>
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
80100101:	e8 b8 48 00 00       	call   801049be <acquire>
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
80100140:	e8 e7 48 00 00       	call   80104a2c <release>
80100145:	83 c4 10             	add    $0x10,%esp
      acquiresleep(&b->lock);
80100148:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010014b:	83 c0 0c             	add    $0xc,%eax
8010014e:	83 ec 0c             	sub    $0xc,%esp
80100151:	50                   	push   %eax
80100152:	e8 24 47 00 00       	call   8010487b <acquiresleep>
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
801001c1:	e8 66 48 00 00       	call   80104a2c <release>
801001c6:	83 c4 10             	add    $0x10,%esp
      acquiresleep(&b->lock);
801001c9:	8b 45 f4             	mov    -0xc(%ebp),%eax
801001cc:	83 c0 0c             	add    $0xc,%eax
801001cf:	83 ec 0c             	sub    $0xc,%esp
801001d2:	50                   	push   %eax
801001d3:	e8 a3 46 00 00       	call   8010487b <acquiresleep>
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
801001f5:	68 0e a3 10 80       	push   $0x8010a30e
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
8010022d:	e8 df 9f 00 00       	call   8010a211 <iderw>
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
8010024a:	e8 de 46 00 00       	call   8010492d <holdingsleep>
8010024f:	83 c4 10             	add    $0x10,%esp
80100252:	85 c0                	test   %eax,%eax
80100254:	75 0d                	jne    80100263 <bwrite+0x29>
    panic("bwrite");
80100256:	83 ec 0c             	sub    $0xc,%esp
80100259:	68 1f a3 10 80       	push   $0x8010a31f
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
80100278:	e8 94 9f 00 00       	call   8010a211 <iderw>
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
80100293:	e8 95 46 00 00       	call   8010492d <holdingsleep>
80100298:	83 c4 10             	add    $0x10,%esp
8010029b:	85 c0                	test   %eax,%eax
8010029d:	75 0d                	jne    801002ac <brelse+0x29>
    panic("brelse");
8010029f:	83 ec 0c             	sub    $0xc,%esp
801002a2:	68 26 a3 10 80       	push   $0x8010a326
801002a7:	e8 fd 02 00 00       	call   801005a9 <panic>

  releasesleep(&b->lock);
801002ac:	8b 45 08             	mov    0x8(%ebp),%eax
801002af:	83 c0 0c             	add    $0xc,%eax
801002b2:	83 ec 0c             	sub    $0xc,%esp
801002b5:	50                   	push   %eax
801002b6:	e8 24 46 00 00       	call   801048df <releasesleep>
801002bb:	83 c4 10             	add    $0x10,%esp

  acquire(&bcache.lock);
801002be:	83 ec 0c             	sub    $0xc,%esp
801002c1:	68 00 d0 18 80       	push   $0x8018d000
801002c6:	e8 f3 46 00 00       	call   801049be <acquire>
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
80100336:	e8 f1 46 00 00       	call   80104a2c <release>
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
80100410:	e8 a9 45 00 00       	call   801049be <acquire>
80100415:	83 c4 10             	add    $0x10,%esp

  if (fmt == 0)
80100418:	8b 45 08             	mov    0x8(%ebp),%eax
8010041b:	85 c0                	test   %eax,%eax
8010041d:	75 0d                	jne    8010042c <cprintf+0x38>
    panic("null fmt");
8010041f:	83 ec 0c             	sub    $0xc,%esp
80100422:	68 2d a3 10 80       	push   $0x8010a32d
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
80100510:	c7 45 ec 36 a3 10 80 	movl   $0x8010a336,-0x14(%ebp)
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
8010059e:	e8 89 44 00 00       	call   80104a2c <release>
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
801005c7:	68 3d a3 10 80       	push   $0x8010a33d
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
801005e6:	68 51 a3 10 80       	push   $0x8010a351
801005eb:	e8 04 fe ff ff       	call   801003f4 <cprintf>
801005f0:	83 c4 10             	add    $0x10,%esp
  getcallerpcs(&s, pcs);
801005f3:	83 ec 08             	sub    $0x8,%esp
801005f6:	8d 45 cc             	lea    -0x34(%ebp),%eax
801005f9:	50                   	push   %eax
801005fa:	8d 45 08             	lea    0x8(%ebp),%eax
801005fd:	50                   	push   %eax
801005fe:	e8 7b 44 00 00       	call   80104a7e <getcallerpcs>
80100603:	83 c4 10             	add    $0x10,%esp
  for(i=0; i<10; i++)
80100606:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
8010060d:	eb 1c                	jmp    8010062b <panic+0x82>
    cprintf(" %p", pcs[i]);
8010060f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100612:	8b 44 85 cc          	mov    -0x34(%ebp,%eax,4),%eax
80100616:	83 ec 08             	sub    $0x8,%esp
80100619:	50                   	push   %eax
8010061a:	68 53 a3 10 80       	push   $0x8010a353
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
801006a0:	e8 c3 7a 00 00       	call   80108168 <graphic_scroll_up>
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
801006f3:	e8 70 7a 00 00       	call   80108168 <graphic_scroll_up>
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
80100757:	e8 77 7a 00 00       	call   801081d3 <font_render>
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
80100793:	e8 47 5e 00 00       	call   801065df <uartputc>
80100798:	83 c4 10             	add    $0x10,%esp
8010079b:	83 ec 0c             	sub    $0xc,%esp
8010079e:	6a 20                	push   $0x20
801007a0:	e8 3a 5e 00 00       	call   801065df <uartputc>
801007a5:	83 c4 10             	add    $0x10,%esp
801007a8:	83 ec 0c             	sub    $0xc,%esp
801007ab:	6a 08                	push   $0x8
801007ad:	e8 2d 5e 00 00       	call   801065df <uartputc>
801007b2:	83 c4 10             	add    $0x10,%esp
801007b5:	eb 0e                	jmp    801007c5 <consputc+0x56>
  } else {
    uartputc(c);
801007b7:	83 ec 0c             	sub    $0xc,%esp
801007ba:	ff 75 08             	push   0x8(%ebp)
801007bd:	e8 1d 5e 00 00       	call   801065df <uartputc>
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
801007eb:	e8 ce 41 00 00       	call   801049be <acquire>
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
8010093f:	e8 40 3d 00 00       	call   80104684 <wakeup>
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
80100962:	e8 c5 40 00 00       	call   80104a2c <release>
80100967:	83 c4 10             	add    $0x10,%esp
  if(doprocdump) {
8010096a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
8010096e:	74 05                	je     80100975 <consoleintr+0x19f>
    procdump();  // now call procdump() wo. cons.lock held
80100970:	e8 cd 3d 00 00       	call   80104742 <procdump>
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
8010099a:	e8 1f 40 00 00       	call   801049be <acquire>
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
801009bb:	e8 6c 40 00 00       	call   80104a2c <release>
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
801009e8:	e8 ad 3b 00 00       	call   8010459a <sleep>
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
80100a66:	e8 c1 3f 00 00       	call   80104a2c <release>
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
80100aa2:	e8 17 3f 00 00       	call   801049be <acquire>
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
80100ae4:	e8 43 3f 00 00       	call   80104a2c <release>
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
80100b12:	68 57 a3 10 80       	push   $0x8010a357
80100b17:	68 00 1a 19 80       	push   $0x80191a00
80100b1c:	e8 7b 3e 00 00       	call   8010499c <initlock>
80100b21:	83 c4 10             	add    $0x10,%esp

  devsw[CONSOLE].write = consolewrite;
80100b24:	c7 05 4c 1a 19 80 86 	movl   $0x80100a86,0x80191a4c
80100b2b:	0a 10 80 
  devsw[CONSOLE].read = consoleread;
80100b2e:	c7 05 48 1a 19 80 78 	movl   $0x80100978,0x80191a48
80100b35:	09 10 80 
  
  char *p;
  for(p="Starting XV6_UEFI...\n"; *p; p++)
80100b38:	c7 45 f4 5f a3 10 80 	movl   $0x8010a35f,-0xc(%ebp)
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
80100bb5:	68 75 a3 10 80       	push   $0x8010a375
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
80100c11:	e8 c5 69 00 00       	call   801075db <setupkvm>
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
80100cb7:	e8 18 6d 00 00       	call   801079d4 <allocuvm>
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
80100cfd:	e8 05 6c 00 00       	call   80107907 <loaduvm>
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
80100d6c:	e8 63 6c 00 00       	call   801079d4 <allocuvm>
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
80100d90:	e8 a1 6e 00 00       	call   80107c36 <clearpteu>
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
80100dc9:	e8 b4 40 00 00       	call   80104e82 <strlen>
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
80100df6:	e8 87 40 00 00       	call   80104e82 <strlen>
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
80100e1c:	e8 b4 6f 00 00       	call   80107dd5 <copyout>
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
80100eb8:	e8 18 6f 00 00       	call   80107dd5 <copyout>
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
80100f06:	e8 2c 3f 00 00       	call   80104e37 <safestrcpy>
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
80100f49:	e8 aa 67 00 00       	call   801076f8 <switchuvm>
80100f4e:	83 c4 10             	add    $0x10,%esp
  freevm(oldpgdir);
80100f51:	83 ec 0c             	sub    $0xc,%esp
80100f54:	ff 75 cc             	push   -0x34(%ebp)
80100f57:	e8 41 6c 00 00       	call   80107b9d <freevm>
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
80100f97:	e8 01 6c 00 00       	call   80107b9d <freevm>
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
80100fc8:	68 81 a3 10 80       	push   $0x8010a381
80100fcd:	68 a0 1a 19 80       	push   $0x80191aa0
80100fd2:	e8 c5 39 00 00       	call   8010499c <initlock>
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
80100feb:	e8 ce 39 00 00       	call   801049be <acquire>
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
80101018:	e8 0f 3a 00 00       	call   80104a2c <release>
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
8010103b:	e8 ec 39 00 00       	call   80104a2c <release>
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
80101058:	e8 61 39 00 00       	call   801049be <acquire>
8010105d:	83 c4 10             	add    $0x10,%esp
  if(f->ref < 1)
80101060:	8b 45 08             	mov    0x8(%ebp),%eax
80101063:	8b 40 04             	mov    0x4(%eax),%eax
80101066:	85 c0                	test   %eax,%eax
80101068:	7f 0d                	jg     80101077 <filedup+0x2d>
    panic("filedup");
8010106a:	83 ec 0c             	sub    $0xc,%esp
8010106d:	68 88 a3 10 80       	push   $0x8010a388
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
8010108e:	e8 99 39 00 00       	call   80104a2c <release>
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
801010a9:	e8 10 39 00 00       	call   801049be <acquire>
801010ae:	83 c4 10             	add    $0x10,%esp
  if(f->ref < 1)
801010b1:	8b 45 08             	mov    0x8(%ebp),%eax
801010b4:	8b 40 04             	mov    0x4(%eax),%eax
801010b7:	85 c0                	test   %eax,%eax
801010b9:	7f 0d                	jg     801010c8 <fileclose+0x2d>
    panic("fileclose");
801010bb:	83 ec 0c             	sub    $0xc,%esp
801010be:	68 90 a3 10 80       	push   $0x8010a390
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
801010e9:	e8 3e 39 00 00       	call   80104a2c <release>
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
80101137:	e8 f0 38 00 00       	call   80104a2c <release>
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
80101286:	68 9a a3 10 80       	push   $0x8010a39a
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
80101389:	68 a3 a3 10 80       	push   $0x8010a3a3
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
801013bf:	68 b3 a3 10 80       	push   $0x8010a3b3
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
801013f7:	e8 f7 38 00 00       	call   80104cf3 <memmove>
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
8010143d:	e8 f2 37 00 00       	call   80104c34 <memset>
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
8010159c:	68 c0 a3 10 80       	push   $0x8010a3c0
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
80101627:	68 d6 a3 10 80       	push   $0x8010a3d6
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
8010168b:	68 e9 a3 10 80       	push   $0x8010a3e9
80101690:	68 60 24 19 80       	push   $0x80192460
80101695:	e8 02 33 00 00       	call   8010499c <initlock>
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
801016c1:	68 f0 a3 10 80       	push   $0x8010a3f0
801016c6:	50                   	push   %eax
801016c7:	e8 73 31 00 00       	call   8010483f <initsleeplock>
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
80101720:	68 f8 a3 10 80       	push   $0x8010a3f8
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
80101799:	e8 96 34 00 00       	call   80104c34 <memset>
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
80101801:	68 4b a4 10 80       	push   $0x8010a44b
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
801018a7:	e8 47 34 00 00       	call   80104cf3 <memmove>
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
801018dc:	e8 dd 30 00 00       	call   801049be <acquire>
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
8010192a:	e8 fd 30 00 00       	call   80104a2c <release>
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
80101966:	68 5d a4 10 80       	push   $0x8010a45d
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
801019a3:	e8 84 30 00 00       	call   80104a2c <release>
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
801019be:	e8 fb 2f 00 00       	call   801049be <acquire>
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
801019dd:	e8 4a 30 00 00       	call   80104a2c <release>
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
80101a03:	68 6d a4 10 80       	push   $0x8010a46d
80101a08:	e8 9c eb ff ff       	call   801005a9 <panic>

  acquiresleep(&ip->lock);
80101a0d:	8b 45 08             	mov    0x8(%ebp),%eax
80101a10:	83 c0 0c             	add    $0xc,%eax
80101a13:	83 ec 0c             	sub    $0xc,%esp
80101a16:	50                   	push   %eax
80101a17:	e8 5f 2e 00 00       	call   8010487b <acquiresleep>
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
80101ac1:	e8 2d 32 00 00       	call   80104cf3 <memmove>
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
80101af0:	68 73 a4 10 80       	push   $0x8010a473
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
80101b13:	e8 15 2e 00 00       	call   8010492d <holdingsleep>
80101b18:	83 c4 10             	add    $0x10,%esp
80101b1b:	85 c0                	test   %eax,%eax
80101b1d:	74 0a                	je     80101b29 <iunlock+0x2c>
80101b1f:	8b 45 08             	mov    0x8(%ebp),%eax
80101b22:	8b 40 08             	mov    0x8(%eax),%eax
80101b25:	85 c0                	test   %eax,%eax
80101b27:	7f 0d                	jg     80101b36 <iunlock+0x39>
    panic("iunlock");
80101b29:	83 ec 0c             	sub    $0xc,%esp
80101b2c:	68 82 a4 10 80       	push   $0x8010a482
80101b31:	e8 73 ea ff ff       	call   801005a9 <panic>

  releasesleep(&ip->lock);
80101b36:	8b 45 08             	mov    0x8(%ebp),%eax
80101b39:	83 c0 0c             	add    $0xc,%eax
80101b3c:	83 ec 0c             	sub    $0xc,%esp
80101b3f:	50                   	push   %eax
80101b40:	e8 9a 2d 00 00       	call   801048df <releasesleep>
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
80101b5b:	e8 1b 2d 00 00       	call   8010487b <acquiresleep>
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
80101b81:	e8 38 2e 00 00       	call   801049be <acquire>
80101b86:	83 c4 10             	add    $0x10,%esp
    int r = ip->ref;
80101b89:	8b 45 08             	mov    0x8(%ebp),%eax
80101b8c:	8b 40 08             	mov    0x8(%eax),%eax
80101b8f:	89 45 f4             	mov    %eax,-0xc(%ebp)
    release(&icache.lock);
80101b92:	83 ec 0c             	sub    $0xc,%esp
80101b95:	68 60 24 19 80       	push   $0x80192460
80101b9a:	e8 8d 2e 00 00       	call   80104a2c <release>
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
80101be1:	e8 f9 2c 00 00       	call   801048df <releasesleep>
80101be6:	83 c4 10             	add    $0x10,%esp

  acquire(&icache.lock);
80101be9:	83 ec 0c             	sub    $0xc,%esp
80101bec:	68 60 24 19 80       	push   $0x80192460
80101bf1:	e8 c8 2d 00 00       	call   801049be <acquire>
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
80101c10:	e8 17 2e 00 00       	call   80104a2c <release>
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
80101d54:	68 8a a4 10 80       	push   $0x8010a48a
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
80101ff2:	e8 fc 2c 00 00       	call   80104cf3 <memmove>
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
80102142:	e8 ac 2b 00 00       	call   80104cf3 <memmove>
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
801021c2:	e8 c2 2b 00 00       	call   80104d89 <strncmp>
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
801021e2:	68 9d a4 10 80       	push   $0x8010a49d
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
80102211:	68 af a4 10 80       	push   $0x8010a4af
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
801022e6:	68 be a4 10 80       	push   $0x8010a4be
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
80102321:	e8 b9 2a 00 00       	call   80104ddf <strncpy>
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
8010234d:	68 cb a4 10 80       	push   $0x8010a4cb
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
801023bf:	e8 2f 29 00 00       	call   80104cf3 <memmove>
801023c4:	83 c4 10             	add    $0x10,%esp
801023c7:	eb 26                	jmp    801023ef <skipelem+0x91>
  else {
    memmove(name, s, len);
801023c9:	8b 45 f0             	mov    -0x10(%ebp),%eax
801023cc:	83 ec 04             	sub    $0x4,%esp
801023cf:	50                   	push   %eax
801023d0:	ff 75 f4             	push   -0xc(%ebp)
801023d3:	ff 75 0c             	push   0xc(%ebp)
801023d6:	e8 18 29 00 00       	call   80104cf3 <memmove>
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
801025cd:	68 d4 a4 10 80       	push   $0x8010a4d4
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
80102674:	68 06 a5 10 80       	push   $0x8010a506
80102679:	68 c0 40 19 80       	push   $0x801940c0
8010267e:	e8 19 23 00 00       	call   8010499c <initlock>
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
80102733:	68 0b a5 10 80       	push   $0x8010a50b
80102738:	e8 6c de ff ff       	call   801005a9 <panic>

  // Fill with junk to catch dangling refs.
  memset(v, 1, PGSIZE);
8010273d:	83 ec 04             	sub    $0x4,%esp
80102740:	68 00 10 00 00       	push   $0x1000
80102745:	6a 01                	push   $0x1
80102747:	ff 75 08             	push   0x8(%ebp)
8010274a:	e8 e5 24 00 00       	call   80104c34 <memset>
8010274f:	83 c4 10             	add    $0x10,%esp

  if(kmem.use_lock)
80102752:	a1 f4 40 19 80       	mov    0x801940f4,%eax
80102757:	85 c0                	test   %eax,%eax
80102759:	74 10                	je     8010276b <kfree+0x65>
    acquire(&kmem.lock);
8010275b:	83 ec 0c             	sub    $0xc,%esp
8010275e:	68 c0 40 19 80       	push   $0x801940c0
80102763:	e8 56 22 00 00       	call   801049be <acquire>
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
80102795:	e8 92 22 00 00       	call   80104a2c <release>
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
801027b7:	e8 02 22 00 00       	call   801049be <acquire>
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
801027e8:	e8 3f 22 00 00       	call   80104a2c <release>
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
80102d12:	e8 84 1f 00 00       	call   80104c9b <memcmp>
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
80102e26:	68 11 a5 10 80       	push   $0x8010a511
80102e2b:	68 20 41 19 80       	push   $0x80194120
80102e30:	e8 67 1b 00 00       	call   8010499c <initlock>
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
80102edb:	e8 13 1e 00 00       	call   80104cf3 <memmove>
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
8010304a:	e8 6f 19 00 00       	call   801049be <acquire>
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
80103068:	e8 2d 15 00 00       	call   8010459a <sleep>
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
8010309d:	e8 f8 14 00 00       	call   8010459a <sleep>
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
801030bc:	e8 6b 19 00 00       	call   80104a2c <release>
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
801030dd:	e8 dc 18 00 00       	call   801049be <acquire>
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
801030fe:	68 15 a5 10 80       	push   $0x8010a515
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
8010312c:	e8 53 15 00 00       	call   80104684 <wakeup>
80103131:	83 c4 10             	add    $0x10,%esp
  }
  release(&log.lock);
80103134:	83 ec 0c             	sub    $0xc,%esp
80103137:	68 20 41 19 80       	push   $0x80194120
8010313c:	e8 eb 18 00 00       	call   80104a2c <release>
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
80103157:	e8 62 18 00 00       	call   801049be <acquire>
8010315c:	83 c4 10             	add    $0x10,%esp
    log.committing = 0;
8010315f:	c7 05 60 41 19 80 00 	movl   $0x0,0x80194160
80103166:	00 00 00 
    wakeup(&log);
80103169:	83 ec 0c             	sub    $0xc,%esp
8010316c:	68 20 41 19 80       	push   $0x80194120
80103171:	e8 0e 15 00 00       	call   80104684 <wakeup>
80103176:	83 c4 10             	add    $0x10,%esp
    release(&log.lock);
80103179:	83 ec 0c             	sub    $0xc,%esp
8010317c:	68 20 41 19 80       	push   $0x80194120
80103181:	e8 a6 18 00 00       	call   80104a2c <release>
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
801031fd:	e8 f1 1a 00 00       	call   80104cf3 <memmove>
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
8010329a:	68 24 a5 10 80       	push   $0x8010a524
8010329f:	e8 05 d3 ff ff       	call   801005a9 <panic>
  if (log.outstanding < 1)
801032a4:	a1 5c 41 19 80       	mov    0x8019415c,%eax
801032a9:	85 c0                	test   %eax,%eax
801032ab:	7f 0d                	jg     801032ba <log_write+0x45>
    panic("log_write outside of trans");
801032ad:	83 ec 0c             	sub    $0xc,%esp
801032b0:	68 3a a5 10 80       	push   $0x8010a53a
801032b5:	e8 ef d2 ff ff       	call   801005a9 <panic>

  acquire(&log.lock);
801032ba:	83 ec 0c             	sub    $0xc,%esp
801032bd:	68 20 41 19 80       	push   $0x80194120
801032c2:	e8 f7 16 00 00       	call   801049be <acquire>
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
80103340:	e8 e7 16 00 00       	call   80104a2c <release>
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
80103376:	e8 32 4d 00 00       	call   801080ad <graphic_init>
  kinit1(end, P2V(4*1024*1024)); // phys page allocator
8010337b:	83 ec 08             	sub    $0x8,%esp
8010337e:	68 00 00 40 80       	push   $0x80400000
80103383:	68 00 90 19 80       	push   $0x80199000
80103388:	e8 de f2 ff ff       	call   8010266b <kinit1>
8010338d:	83 c4 10             	add    $0x10,%esp
  kvmalloc();      // kernel page table
80103390:	e8 32 43 00 00       	call   801076c7 <kvmalloc>
  mpinit_uefi();
80103395:	e8 d9 4a 00 00       	call   80107e73 <mpinit_uefi>
  lapicinit();     // interrupt controller
8010339a:	e8 3c f6 ff ff       	call   801029db <lapicinit>
  seginit();       // segment descriptors
8010339f:	e8 bb 3d 00 00       	call   8010715f <seginit>
  picinit();    // disable pic
801033a4:	e8 9d 01 00 00       	call   80103546 <picinit>
  ioapicinit();    // another interrupt controller
801033a9:	e8 d8 f1 ff ff       	call   80102586 <ioapicinit>
  consoleinit();   // console hardware
801033ae:	e8 4c d7 ff ff       	call   80100aff <consoleinit>
  uartinit();      // serial port
801033b3:	e8 40 31 00 00       	call   801064f8 <uartinit>
  pinit();         // process table
801033b8:	e8 c2 05 00 00       	call   8010397f <pinit>
  tvinit();        // trap vectors
801033bd:	e8 07 2d 00 00       	call   801060c9 <tvinit>
  binit();         // buffer cache
801033c2:	e8 9f cc ff ff       	call   80100066 <binit>
  fileinit();      // file table
801033c7:	e8 f3 db ff ff       	call   80100fbf <fileinit>
  ideinit();       // disk 
801033cc:	e8 1d 6e 00 00       	call   8010a1ee <ideinit>
  startothers();   // start other processors
801033d1:	e8 8a 00 00 00       	call   80103460 <startothers>
  kinit2(P2V(4*1024*1024), P2V(PHYSTOP)); // must come after startothers()
801033d6:	83 ec 08             	sub    $0x8,%esp
801033d9:	68 00 00 00 a0       	push   $0xa0000000
801033de:	68 00 00 40 80       	push   $0x80400000
801033e3:	e8 bc f2 ff ff       	call   801026a4 <kinit2>
801033e8:	83 c4 10             	add    $0x10,%esp
  pci_init();
801033eb:	e8 16 4f 00 00       	call   80108306 <pci_init>
  arp_scan();
801033f0:	e8 4d 5c 00 00       	call   80109042 <arp_scan>
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
80103405:	e8 d5 42 00 00       	call   801076df <switchkvm>
  seginit();
8010340a:	e8 50 3d 00 00       	call   8010715f <seginit>
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
80103431:	68 55 a5 10 80       	push   $0x8010a555
80103436:	e8 b9 cf ff ff       	call   801003f4 <cprintf>
8010343b:	83 c4 10             	add    $0x10,%esp
  idtinit();       // load idt register
8010343e:	e8 fc 2d 00 00       	call   8010623f <idtinit>
  xchg(&(mycpu()->started), 1); // tell startothers() we're up
80103443:	e8 70 05 00 00       	call   801039b8 <mycpu>
80103448:	05 a0 00 00 00       	add    $0xa0,%eax
8010344d:	83 ec 08             	sub    $0x8,%esp
80103450:	6a 01                	push   $0x1
80103452:	50                   	push   %eax
80103453:	e8 f3 fe ff ff       	call   8010334b <xchg>
80103458:	83 c4 10             	add    $0x10,%esp
  scheduler();     // start running processes
8010345b:	e8 46 0f 00 00       	call   801043a6 <scheduler>

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
8010347e:	e8 70 18 00 00       	call   80104cf3 <memmove>
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
80103607:	68 69 a5 10 80       	push   $0x8010a569
8010360c:	50                   	push   %eax
8010360d:	e8 8a 13 00 00       	call   8010499c <initlock>
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
801036cc:	e8 ed 12 00 00       	call   801049be <acquire>
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
801036f3:	e8 8c 0f 00 00       	call   80104684 <wakeup>
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
80103716:	e8 69 0f 00 00       	call   80104684 <wakeup>
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
8010373f:	e8 e8 12 00 00       	call   80104a2c <release>
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
8010375e:	e8 c9 12 00 00       	call   80104a2c <release>
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
80103778:	e8 41 12 00 00       	call   801049be <acquire>
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
801037ac:	e8 7b 12 00 00       	call   80104a2c <release>
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
801037ca:	e8 b5 0e 00 00       	call   80104684 <wakeup>
801037cf:	83 c4 10             	add    $0x10,%esp
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
801037d2:	8b 45 08             	mov    0x8(%ebp),%eax
801037d5:	8b 55 08             	mov    0x8(%ebp),%edx
801037d8:	81 c2 38 02 00 00    	add    $0x238,%edx
801037de:	83 ec 08             	sub    $0x8,%esp
801037e1:	50                   	push   %eax
801037e2:	52                   	push   %edx
801037e3:	e8 b2 0d 00 00       	call   8010459a <sleep>
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
8010384d:	e8 32 0e 00 00       	call   80104684 <wakeup>
80103852:	83 c4 10             	add    $0x10,%esp
  release(&p->lock);
80103855:	8b 45 08             	mov    0x8(%ebp),%eax
80103858:	83 ec 0c             	sub    $0xc,%esp
8010385b:	50                   	push   %eax
8010385c:	e8 cb 11 00 00       	call   80104a2c <release>
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
80103879:	e8 40 11 00 00       	call   801049be <acquire>
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
80103896:	e8 91 11 00 00       	call   80104a2c <release>
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
801038b9:	e8 dc 0c 00 00       	call   8010459a <sleep>
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
8010394c:	e8 33 0d 00 00       	call   80104684 <wakeup>
80103951:	83 c4 10             	add    $0x10,%esp
  release(&p->lock);
80103954:	8b 45 08             	mov    0x8(%ebp),%eax
80103957:	83 ec 0c             	sub    $0xc,%esp
8010395a:	50                   	push   %eax
8010395b:	e8 cc 10 00 00       	call   80104a2c <release>
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
80103988:	68 70 a5 10 80       	push   $0x8010a570
8010398d:	68 00 42 19 80       	push   $0x80194200
80103992:	e8 05 10 00 00       	call   8010499c <initlock>
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
801039cf:	68 78 a5 10 80       	push   $0x8010a578
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
80103a24:	68 9e a5 10 80       	push   $0x8010a59e
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
80103a36:	e8 ee 10 00 00       	call   80104b29 <pushcli>
  c = mycpu();
80103a3b:	e8 78 ff ff ff       	call   801039b8 <mycpu>
80103a40:	89 45 f4             	mov    %eax,-0xc(%ebp)
  p = c->proc;
80103a43:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103a46:	8b 80 ac 00 00 00    	mov    0xac(%eax),%eax
80103a4c:	89 45 f0             	mov    %eax,-0x10(%ebp)
  popcli();
80103a4f:	e8 22 11 00 00       	call   80104b76 <popcli>
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
80103a67:	e8 52 0f 00 00       	call   801049be <acquire>
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
80103a9a:	e8 8d 0f 00 00       	call   80104a2c <release>
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
80103ad3:	e8 54 0f 00 00       	call   80104a2c <release>
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
80103b20:	ba 83 60 10 80       	mov    $0x80106083,%edx
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
80103b45:	e8 ea 10 00 00       	call   80104c34 <memset>
80103b4a:	83 c4 10             	add    $0x10,%esp
  p->context->eip = (uint)forkret;
80103b4d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103b50:	8b 40 1c             	mov    0x1c(%eax),%eax
80103b53:	ba 54 45 10 80       	mov    $0x80104554,%edx
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
80103b76:	e8 60 3a 00 00       	call   801075db <setupkvm>
80103b7b:	8b 55 f4             	mov    -0xc(%ebp),%edx
80103b7e:	89 42 04             	mov    %eax,0x4(%edx)
80103b81:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103b84:	8b 40 04             	mov    0x4(%eax),%eax
80103b87:	85 c0                	test   %eax,%eax
80103b89:	75 0d                	jne    80103b98 <userinit+0x38>
    panic("userinit: out of memory?");
80103b8b:	83 ec 0c             	sub    $0xc,%esp
80103b8e:	68 ae a5 10 80       	push   $0x8010a5ae
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
80103bad:	e8 e5 3c 00 00       	call   80107897 <inituvm>
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
80103bcc:	e8 63 10 00 00       	call   80104c34 <memset>
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
80103c46:	68 c7 a5 10 80       	push   $0x8010a5c7
80103c4b:	50                   	push   %eax
80103c4c:	e8 e6 11 00 00       	call   80104e37 <safestrcpy>
80103c51:	83 c4 10             	add    $0x10,%esp
  p->cwd = namei("/");
80103c54:	83 ec 0c             	sub    $0xc,%esp
80103c57:	68 d0 a5 10 80       	push   $0x8010a5d0
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
80103c72:	e8 47 0d 00 00       	call   801049be <acquire>
80103c77:	83 c4 10             	add    $0x10,%esp

  p->state = RUNNABLE;
80103c7a:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103c7d:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)

  release(&ptable.lock);
80103c84:	83 ec 0c             	sub    $0xc,%esp
80103c87:	68 00 42 19 80       	push   $0x80194200
80103c8c:	e8 9b 0d 00 00       	call   80104a2c <release>
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
80103cc9:	e8 06 3d 00 00       	call   801079d4 <allocuvm>
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
80103cfd:	e8 d7 3d 00 00       	call   80107ad9 <deallocuvm>
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
80103d23:	e8 d0 39 00 00       	call   801076f8 <switchuvm>
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
80103d6b:	e8 07 3f 00 00       	call   80107c77 <copyuvm>
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
80103e65:	e8 cd 0f 00 00       	call   80104e37 <safestrcpy>
80103e6a:	83 c4 10             	add    $0x10,%esp

  pid = np->pid;
80103e6d:	8b 45 dc             	mov    -0x24(%ebp),%eax
80103e70:	8b 40 10             	mov    0x10(%eax),%eax
80103e73:	89 45 d8             	mov    %eax,-0x28(%ebp)

  acquire(&ptable.lock);
80103e76:	83 ec 0c             	sub    $0xc,%esp
80103e79:	68 00 42 19 80       	push   $0x80194200
80103e7e:	e8 3b 0b 00 00       	call   801049be <acquire>
80103e83:	83 c4 10             	add    $0x10,%esp

  np->state = RUNNABLE;
80103e86:	8b 45 dc             	mov    -0x24(%ebp),%eax
80103e89:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)

  release(&ptable.lock);
80103e90:	83 ec 0c             	sub    $0xc,%esp
80103e93:	68 00 42 19 80       	push   $0x80194200
80103e98:	e8 8f 0b 00 00       	call   80104a2c <release>
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
80103ec6:	68 d2 a5 10 80       	push   $0x8010a5d2
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
80103f4c:	e8 6d 0a 00 00       	call   801049be <acquire>
80103f51:	83 c4 10             	add    $0x10,%esp

  // Parent might be sleeping in wait().
  wakeup1(curproc->parent);
80103f54:	8b 45 ec             	mov    -0x14(%ebp),%eax
80103f57:	8b 40 14             	mov    0x14(%eax),%eax
80103f5a:	83 ec 0c             	sub    $0xc,%esp
80103f5d:	50                   	push   %eax
80103f5e:	e8 de 06 00 00       	call   80104641 <wakeup1>
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
80103f9a:	e8 a2 06 00 00       	call   80104641 <wakeup1>
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
80103fbc:	e8 a0 04 00 00       	call   80104461 <sched>
  panic("zombie exit");
80103fc1:	83 ec 0c             	sub    $0xc,%esp
80103fc4:	68 df a5 10 80       	push   $0x8010a5df
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


  //uint a = (unsigned int)&(curproc->scheduler);
  //copyout(curproc->pgdir, a, &address, sizeof(uint));
  //cprintf("!!!! a is %d", a);
  curproc->scheduler = address;
80103fdc:	8b 55 08             	mov    0x8(%ebp),%edx
80103fdf:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103fe2:	89 90 80 00 00 00    	mov    %edx,0x80(%eax)
  cprintf("!!!! scheduler is %d\n", curproc->scheduler);
80103fe8:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103feb:	8b 80 80 00 00 00    	mov    0x80(%eax),%eax
80103ff1:	83 ec 08             	sub    $0x8,%esp
80103ff4:	50                   	push   %eax
80103ff5:	68 eb a5 10 80       	push   $0x8010a5eb
80103ffa:	e8 f5 c3 ff ff       	call   801003f4 <cprintf>
80103fff:	83 c4 10             	add    $0x10,%esp
  return 0;
80104002:	b8 00 00 00 00       	mov    $0x0,%eax
}
80104007:	c9                   	leave  
80104008:	c3                   	ret    

80104009 <exit2>:
//******************************************
//************   new  **********************
//************ eixt2() *********************
//******************************************
void
exit2(int status){
80104009:	55                   	push   %ebp
8010400a:	89 e5                	mov    %esp,%ebp
8010400c:	83 ec 18             	sub    $0x18,%esp
  struct proc *curproc = myproc();
8010400f:	e8 1c fa ff ff       	call   80103a30 <myproc>
80104014:	89 45 ec             	mov    %eax,-0x14(%ebp)
  struct proc *p;
  int fd;
 
  //***********새로 추가된 부분. Copy status to xstate**********
  curproc->parent->xstate = status;
80104017:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010401a:	8b 40 14             	mov    0x14(%eax),%eax
8010401d:	8b 55 08             	mov    0x8(%ebp),%edx
80104020:	89 50 7c             	mov    %edx,0x7c(%eax)
  //************************************************************

  if(curproc == initproc)
80104023:	a1 34 63 19 80       	mov    0x80196334,%eax
80104028:	39 45 ec             	cmp    %eax,-0x14(%ebp)
8010402b:	75 0d                	jne    8010403a <exit2+0x31>
    panic("init exiting");
8010402d:	83 ec 0c             	sub    $0xc,%esp
80104030:	68 d2 a5 10 80       	push   $0x8010a5d2
80104035:	e8 6f c5 ff ff       	call   801005a9 <panic>

  // Close all open files.
  for(fd = 0; fd < NOFILE; fd++){
8010403a:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
80104041:	eb 3f                	jmp    80104082 <exit2+0x79>
    if(curproc->ofile[fd]){
80104043:	8b 45 ec             	mov    -0x14(%ebp),%eax
80104046:	8b 55 f0             	mov    -0x10(%ebp),%edx
80104049:	83 c2 08             	add    $0x8,%edx
8010404c:	8b 44 90 08          	mov    0x8(%eax,%edx,4),%eax
80104050:	85 c0                	test   %eax,%eax
80104052:	74 2a                	je     8010407e <exit2+0x75>
      fileclose(curproc->ofile[fd]);
80104054:	8b 45 ec             	mov    -0x14(%ebp),%eax
80104057:	8b 55 f0             	mov    -0x10(%ebp),%edx
8010405a:	83 c2 08             	add    $0x8,%edx
8010405d:	8b 44 90 08          	mov    0x8(%eax,%edx,4),%eax
80104061:	83 ec 0c             	sub    $0xc,%esp
80104064:	50                   	push   %eax
80104065:	e8 31 d0 ff ff       	call   8010109b <fileclose>
8010406a:	83 c4 10             	add    $0x10,%esp
      curproc->ofile[fd] = 0;
8010406d:	8b 45 ec             	mov    -0x14(%ebp),%eax
80104070:	8b 55 f0             	mov    -0x10(%ebp),%edx
80104073:	83 c2 08             	add    $0x8,%edx
80104076:	c7 44 90 08 00 00 00 	movl   $0x0,0x8(%eax,%edx,4)
8010407d:	00 
  for(fd = 0; fd < NOFILE; fd++){
8010407e:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
80104082:	83 7d f0 0f          	cmpl   $0xf,-0x10(%ebp)
80104086:	7e bb                	jle    80104043 <exit2+0x3a>
    }
  }

  begin_op();
80104088:	e8 af ef ff ff       	call   8010303c <begin_op>
  iput(curproc->cwd);
8010408d:	8b 45 ec             	mov    -0x14(%ebp),%eax
80104090:	8b 40 68             	mov    0x68(%eax),%eax
80104093:	83 ec 0c             	sub    $0xc,%esp
80104096:	50                   	push   %eax
80104097:	e8 af da ff ff       	call   80101b4b <iput>
8010409c:	83 c4 10             	add    $0x10,%esp
  end_op();
8010409f:	e8 24 f0 ff ff       	call   801030c8 <end_op>
  curproc->cwd = 0;
801040a4:	8b 45 ec             	mov    -0x14(%ebp),%eax
801040a7:	c7 40 68 00 00 00 00 	movl   $0x0,0x68(%eax)

  acquire(&ptable.lock);
801040ae:	83 ec 0c             	sub    $0xc,%esp
801040b1:	68 00 42 19 80       	push   $0x80194200
801040b6:	e8 03 09 00 00       	call   801049be <acquire>
801040bb:	83 c4 10             	add    $0x10,%esp

  // Parent might be sleeping in wait().
  wakeup1(curproc->parent);
801040be:	8b 45 ec             	mov    -0x14(%ebp),%eax
801040c1:	8b 40 14             	mov    0x14(%eax),%eax
801040c4:	83 ec 0c             	sub    $0xc,%esp
801040c7:	50                   	push   %eax
801040c8:	e8 74 05 00 00       	call   80104641 <wakeup1>
801040cd:	83 c4 10             	add    $0x10,%esp

  // Pass abandoned children to init.
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801040d0:	c7 45 f4 34 42 19 80 	movl   $0x80194234,-0xc(%ebp)
801040d7:	eb 3a                	jmp    80104113 <exit2+0x10a>
    if(p->parent == curproc){
801040d9:	8b 45 f4             	mov    -0xc(%ebp),%eax
801040dc:	8b 40 14             	mov    0x14(%eax),%eax
801040df:	39 45 ec             	cmp    %eax,-0x14(%ebp)
801040e2:	75 28                	jne    8010410c <exit2+0x103>
      p->parent = initproc;
801040e4:	8b 15 34 63 19 80    	mov    0x80196334,%edx
801040ea:	8b 45 f4             	mov    -0xc(%ebp),%eax
801040ed:	89 50 14             	mov    %edx,0x14(%eax)
      if(p->state == ZOMBIE)
801040f0:	8b 45 f4             	mov    -0xc(%ebp),%eax
801040f3:	8b 40 0c             	mov    0xc(%eax),%eax
801040f6:	83 f8 05             	cmp    $0x5,%eax
801040f9:	75 11                	jne    8010410c <exit2+0x103>
        wakeup1(initproc);
801040fb:	a1 34 63 19 80       	mov    0x80196334,%eax
80104100:	83 ec 0c             	sub    $0xc,%esp
80104103:	50                   	push   %eax
80104104:	e8 38 05 00 00       	call   80104641 <wakeup1>
80104109:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
8010410c:	81 45 f4 84 00 00 00 	addl   $0x84,-0xc(%ebp)
80104113:	81 7d f4 34 63 19 80 	cmpl   $0x80196334,-0xc(%ebp)
8010411a:	72 bd                	jb     801040d9 <exit2+0xd0>
    }
  }

  // Jump into the scheduler, never to return.
  curproc->state = ZOMBIE;
8010411c:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010411f:	c7 40 0c 05 00 00 00 	movl   $0x5,0xc(%eax)
  sched();
80104126:	e8 36 03 00 00       	call   80104461 <sched>
  panic("zombie exit");
8010412b:	83 ec 0c             	sub    $0xc,%esp
8010412e:	68 df a5 10 80       	push   $0x8010a5df
80104133:	e8 71 c4 ff ff       	call   801005a9 <panic>

80104138 <wait>:

// Wait for a child process to exit and return its pid.
// Return -1 if this process has no children.
int
wait(void)
{
80104138:	55                   	push   %ebp
80104139:	89 e5                	mov    %esp,%ebp
8010413b:	83 ec 18             	sub    $0x18,%esp
  struct proc *p;
  int havekids, pid;
  struct proc *curproc = myproc();
8010413e:	e8 ed f8 ff ff       	call   80103a30 <myproc>
80104143:	89 45 ec             	mov    %eax,-0x14(%ebp)
  
  acquire(&ptable.lock);
80104146:	83 ec 0c             	sub    $0xc,%esp
80104149:	68 00 42 19 80       	push   $0x80194200
8010414e:	e8 6b 08 00 00       	call   801049be <acquire>
80104153:	83 c4 10             	add    $0x10,%esp
  for(;;){
    // Scan through table looking for exited children.
    havekids = 0;
80104156:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
8010415d:	c7 45 f4 34 42 19 80 	movl   $0x80194234,-0xc(%ebp)
80104164:	e9 a4 00 00 00       	jmp    8010420d <wait+0xd5>
      if(p->parent != curproc)
80104169:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010416c:	8b 40 14             	mov    0x14(%eax),%eax
8010416f:	39 45 ec             	cmp    %eax,-0x14(%ebp)
80104172:	0f 85 8d 00 00 00    	jne    80104205 <wait+0xcd>
        continue;
      havekids = 1;
80104178:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
      if(p->state == ZOMBIE){
8010417f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104182:	8b 40 0c             	mov    0xc(%eax),%eax
80104185:	83 f8 05             	cmp    $0x5,%eax
80104188:	75 7c                	jne    80104206 <wait+0xce>
        // Found one.
        pid = p->pid;
8010418a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010418d:	8b 40 10             	mov    0x10(%eax),%eax
80104190:	89 45 e8             	mov    %eax,-0x18(%ebp)
        kfree(p->kstack);
80104193:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104196:	8b 40 08             	mov    0x8(%eax),%eax
80104199:	83 ec 0c             	sub    $0xc,%esp
8010419c:	50                   	push   %eax
8010419d:	e8 64 e5 ff ff       	call   80102706 <kfree>
801041a2:	83 c4 10             	add    $0x10,%esp
        p->kstack = 0;
801041a5:	8b 45 f4             	mov    -0xc(%ebp),%eax
801041a8:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
        freevm(p->pgdir);
801041af:	8b 45 f4             	mov    -0xc(%ebp),%eax
801041b2:	8b 40 04             	mov    0x4(%eax),%eax
801041b5:	83 ec 0c             	sub    $0xc,%esp
801041b8:	50                   	push   %eax
801041b9:	e8 df 39 00 00       	call   80107b9d <freevm>
801041be:	83 c4 10             	add    $0x10,%esp
        p->pid = 0;
801041c1:	8b 45 f4             	mov    -0xc(%ebp),%eax
801041c4:	c7 40 10 00 00 00 00 	movl   $0x0,0x10(%eax)
        p->parent = 0;
801041cb:	8b 45 f4             	mov    -0xc(%ebp),%eax
801041ce:	c7 40 14 00 00 00 00 	movl   $0x0,0x14(%eax)
        p->name[0] = 0;
801041d5:	8b 45 f4             	mov    -0xc(%ebp),%eax
801041d8:	c6 40 6c 00          	movb   $0x0,0x6c(%eax)
        p->killed = 0;
801041dc:	8b 45 f4             	mov    -0xc(%ebp),%eax
801041df:	c7 40 24 00 00 00 00 	movl   $0x0,0x24(%eax)
        p->state = UNUSED;
801041e6:	8b 45 f4             	mov    -0xc(%ebp),%eax
801041e9:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
        release(&ptable.lock);
801041f0:	83 ec 0c             	sub    $0xc,%esp
801041f3:	68 00 42 19 80       	push   $0x80194200
801041f8:	e8 2f 08 00 00       	call   80104a2c <release>
801041fd:	83 c4 10             	add    $0x10,%esp
        return pid;
80104200:	8b 45 e8             	mov    -0x18(%ebp),%eax
80104203:	eb 54                	jmp    80104259 <wait+0x121>
        continue;
80104205:	90                   	nop
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104206:	81 45 f4 84 00 00 00 	addl   $0x84,-0xc(%ebp)
8010420d:	81 7d f4 34 63 19 80 	cmpl   $0x80196334,-0xc(%ebp)
80104214:	0f 82 4f ff ff ff    	jb     80104169 <wait+0x31>
      }
    }

    // No point waiting if we don't have any children.
    if(!havekids || curproc->killed){
8010421a:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
8010421e:	74 0a                	je     8010422a <wait+0xf2>
80104220:	8b 45 ec             	mov    -0x14(%ebp),%eax
80104223:	8b 40 24             	mov    0x24(%eax),%eax
80104226:	85 c0                	test   %eax,%eax
80104228:	74 17                	je     80104241 <wait+0x109>
      release(&ptable.lock);
8010422a:	83 ec 0c             	sub    $0xc,%esp
8010422d:	68 00 42 19 80       	push   $0x80194200
80104232:	e8 f5 07 00 00       	call   80104a2c <release>
80104237:	83 c4 10             	add    $0x10,%esp
      return -1;
8010423a:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010423f:	eb 18                	jmp    80104259 <wait+0x121>
    }

    // Wait for children to exit.  (See wakeup1 call in proc_exit.)
    sleep(curproc, &ptable.lock);  //DOC: wait-sleep
80104241:	83 ec 08             	sub    $0x8,%esp
80104244:	68 00 42 19 80       	push   $0x80194200
80104249:	ff 75 ec             	push   -0x14(%ebp)
8010424c:	e8 49 03 00 00       	call   8010459a <sleep>
80104251:	83 c4 10             	add    $0x10,%esp
    havekids = 0;
80104254:	e9 fd fe ff ff       	jmp    80104156 <wait+0x1e>
  }
}
80104259:	c9                   	leave  
8010425a:	c3                   	ret    

8010425b <wait2>:
//******************************************
//************   new  **********************
//************ wait2() *********************
//******************************************
int
wait2(int *status){
8010425b:	55                   	push   %ebp
8010425c:	89 e5                	mov    %esp,%ebp
8010425e:	83 ec 18             	sub    $0x18,%esp

  struct proc *p;
  int havekids, pid;
  struct proc *curproc = myproc();
80104261:	e8 ca f7 ff ff       	call   80103a30 <myproc>
80104266:	89 45 ec             	mov    %eax,-0x14(%ebp)
 
  
  acquire(&ptable.lock);
80104269:	83 ec 0c             	sub    $0xc,%esp
8010426c:	68 00 42 19 80       	push   $0x80194200
80104271:	e8 48 07 00 00       	call   801049be <acquire>
80104276:	83 c4 10             	add    $0x10,%esp
  for(;;){
    // Scan through table looking for exited children.
    havekids = 0;
80104279:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104280:	c7 45 f4 34 42 19 80 	movl   $0x80194234,-0xc(%ebp)
80104287:	e9 a4 00 00 00       	jmp    80104330 <wait2+0xd5>
      if(p->parent != curproc)
8010428c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010428f:	8b 40 14             	mov    0x14(%eax),%eax
80104292:	39 45 ec             	cmp    %eax,-0x14(%ebp)
80104295:	0f 85 8d 00 00 00    	jne    80104328 <wait2+0xcd>
        continue;
      havekids = 1;
8010429b:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
      if(p->state == ZOMBIE){
801042a2:	8b 45 f4             	mov    -0xc(%ebp),%eax
801042a5:	8b 40 0c             	mov    0xc(%eax),%eax
801042a8:	83 f8 05             	cmp    $0x5,%eax
801042ab:	75 7c                	jne    80104329 <wait2+0xce>
        // Found one.
        pid = p->pid;
801042ad:	8b 45 f4             	mov    -0xc(%ebp),%eax
801042b0:	8b 40 10             	mov    0x10(%eax),%eax
801042b3:	89 45 e8             	mov    %eax,-0x18(%ebp)
        kfree(p->kstack);
801042b6:	8b 45 f4             	mov    -0xc(%ebp),%eax
801042b9:	8b 40 08             	mov    0x8(%eax),%eax
801042bc:	83 ec 0c             	sub    $0xc,%esp
801042bf:	50                   	push   %eax
801042c0:	e8 41 e4 ff ff       	call   80102706 <kfree>
801042c5:	83 c4 10             	add    $0x10,%esp
        p->kstack = 0;
801042c8:	8b 45 f4             	mov    -0xc(%ebp),%eax
801042cb:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
        freevm(p->pgdir);
801042d2:	8b 45 f4             	mov    -0xc(%ebp),%eax
801042d5:	8b 40 04             	mov    0x4(%eax),%eax
801042d8:	83 ec 0c             	sub    $0xc,%esp
801042db:	50                   	push   %eax
801042dc:	e8 bc 38 00 00       	call   80107b9d <freevm>
801042e1:	83 c4 10             	add    $0x10,%esp
        p->pid = 0;
801042e4:	8b 45 f4             	mov    -0xc(%ebp),%eax
801042e7:	c7 40 10 00 00 00 00 	movl   $0x0,0x10(%eax)
        p->parent = 0;
801042ee:	8b 45 f4             	mov    -0xc(%ebp),%eax
801042f1:	c7 40 14 00 00 00 00 	movl   $0x0,0x14(%eax)
        p->name[0] = 0;
801042f8:	8b 45 f4             	mov    -0xc(%ebp),%eax
801042fb:	c6 40 6c 00          	movb   $0x0,0x6c(%eax)
        p->killed = 0;
801042ff:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104302:	c7 40 24 00 00 00 00 	movl   $0x0,0x24(%eax)
        p->state = UNUSED;
80104309:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010430c:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
        release(&ptable.lock);
80104313:	83 ec 0c             	sub    $0xc,%esp
80104316:	68 00 42 19 80       	push   $0x80194200
8010431b:	e8 0c 07 00 00       	call   80104a2c <release>
80104320:	83 c4 10             	add    $0x10,%esp
        return pid;
80104323:	8b 45 e8             	mov    -0x18(%ebp),%eax
80104326:	eb 7c                	jmp    801043a4 <wait2+0x149>
        continue;
80104328:	90                   	nop
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104329:	81 45 f4 84 00 00 00 	addl   $0x84,-0xc(%ebp)
80104330:	81 7d f4 34 63 19 80 	cmpl   $0x80196334,-0xc(%ebp)
80104337:	0f 82 4f ff ff ff    	jb     8010428c <wait2+0x31>
      }
    }

    // No point waiting if we don't have any children.
    if(!havekids || curproc->killed){
8010433d:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80104341:	74 0a                	je     8010434d <wait2+0xf2>
80104343:	8b 45 ec             	mov    -0x14(%ebp),%eax
80104346:	8b 40 24             	mov    0x24(%eax),%eax
80104349:	85 c0                	test   %eax,%eax
8010434b:	74 17                	je     80104364 <wait2+0x109>
      release(&ptable.lock);
8010434d:	83 ec 0c             	sub    $0xc,%esp
80104350:	68 00 42 19 80       	push   $0x80194200
80104355:	e8 d2 06 00 00       	call   80104a2c <release>
8010435a:	83 c4 10             	add    $0x10,%esp
      return -1;
8010435d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104362:	eb 40                	jmp    801043a4 <wait2+0x149>
    }

    sleep(curproc, &ptable.lock);  //DOC: wait-sleep
80104364:	83 ec 08             	sub    $0x8,%esp
80104367:	68 00 42 19 80       	push   $0x80194200
8010436c:	ff 75 ec             	push   -0x14(%ebp)
8010436f:	e8 26 02 00 00       	call   8010459a <sleep>
80104374:	83 c4 10             	add    $0x10,%esp
  // copyout(pde_t *pgdir, uint va, void *p, uint len)와 같이 정의됨
  // p 주소의 len 길이만큼을 복사해서 pgdir의 va에 넣는다.
  // 만약 올바른 값이 아니라면 -1을 리턴
  // Wait for children to exit.  (See wakeup1 call in proc_exit.)
  // wakeup되면 마저 실행하는 코드
    if (copyout(curproc->pgdir, *status, &(curproc->xstate), sizeof(int)) < 0)
80104377:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010437a:	8d 50 7c             	lea    0x7c(%eax),%edx
8010437d:	8b 45 08             	mov    0x8(%ebp),%eax
80104380:	8b 00                	mov    (%eax),%eax
80104382:	89 c1                	mov    %eax,%ecx
80104384:	8b 45 ec             	mov    -0x14(%ebp),%eax
80104387:	8b 40 04             	mov    0x4(%eax),%eax
8010438a:	6a 04                	push   $0x4
8010438c:	52                   	push   %edx
8010438d:	51                   	push   %ecx
8010438e:	50                   	push   %eax
8010438f:	e8 41 3a 00 00       	call   80107dd5 <copyout>
80104394:	83 c4 10             	add    $0x10,%esp
80104397:	85 c0                	test   %eax,%eax
80104399:	0f 89 da fe ff ff    	jns    80104279 <wait2+0x1e>
	    return -1;
8010439f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
				     
  }
}
801043a4:	c9                   	leave  
801043a5:	c3                   	ret    

801043a6 <scheduler>:
//  - swtch to start running that process
//  - eventually that process transfers control
//      via swtch back to the scheduler.
void
scheduler(void)
{
801043a6:	55                   	push   %ebp
801043a7:	89 e5                	mov    %esp,%ebp
801043a9:	83 ec 18             	sub    $0x18,%esp
  struct proc *p;
  struct cpu *c = mycpu();
801043ac:	e8 07 f6 ff ff       	call   801039b8 <mycpu>
801043b1:	89 45 f0             	mov    %eax,-0x10(%ebp)
  c->proc = 0;
801043b4:	8b 45 f0             	mov    -0x10(%ebp),%eax
801043b7:	c7 80 ac 00 00 00 00 	movl   $0x0,0xac(%eax)
801043be:	00 00 00 
  
  for(;;){
    // Enable interrupts on this processor.
    sti();
801043c1:	e8 b2 f5 ff ff       	call   80103978 <sti>

    // Loop over process table looking for process to run.
    acquire(&ptable.lock);
801043c6:	83 ec 0c             	sub    $0xc,%esp
801043c9:	68 00 42 19 80       	push   $0x80194200
801043ce:	e8 eb 05 00 00       	call   801049be <acquire>
801043d3:	83 c4 10             	add    $0x10,%esp
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801043d6:	c7 45 f4 34 42 19 80 	movl   $0x80194234,-0xc(%ebp)
801043dd:	eb 64                	jmp    80104443 <scheduler+0x9d>
      if(p->state != RUNNABLE)
801043df:	8b 45 f4             	mov    -0xc(%ebp),%eax
801043e2:	8b 40 0c             	mov    0xc(%eax),%eax
801043e5:	83 f8 03             	cmp    $0x3,%eax
801043e8:	75 51                	jne    8010443b <scheduler+0x95>
        continue;

      // Switch to chosen process.  It is the process's job
      // to release ptable.lock and then reacquire it
      // before jumping back to us.
      c->proc = p;
801043ea:	8b 45 f0             	mov    -0x10(%ebp),%eax
801043ed:	8b 55 f4             	mov    -0xc(%ebp),%edx
801043f0:	89 90 ac 00 00 00    	mov    %edx,0xac(%eax)
      switchuvm(p);
801043f6:	83 ec 0c             	sub    $0xc,%esp
801043f9:	ff 75 f4             	push   -0xc(%ebp)
801043fc:	e8 f7 32 00 00       	call   801076f8 <switchuvm>
80104401:	83 c4 10             	add    $0x10,%esp
      p->state = RUNNING;
80104404:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104407:	c7 40 0c 04 00 00 00 	movl   $0x4,0xc(%eax)

      swtch(&(c->scheduler), p->context);
8010440e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104411:	8b 40 1c             	mov    0x1c(%eax),%eax
80104414:	8b 55 f0             	mov    -0x10(%ebp),%edx
80104417:	83 c2 04             	add    $0x4,%edx
8010441a:	83 ec 08             	sub    $0x8,%esp
8010441d:	50                   	push   %eax
8010441e:	52                   	push   %edx
8010441f:	e8 85 0a 00 00       	call   80104ea9 <swtch>
80104424:	83 c4 10             	add    $0x10,%esp
      switchkvm();
80104427:	e8 b3 32 00 00       	call   801076df <switchkvm>

      // Process is done running for now.
      // It should have changed its p->state before coming back.
      c->proc = 0;
8010442c:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010442f:	c7 80 ac 00 00 00 00 	movl   $0x0,0xac(%eax)
80104436:	00 00 00 
80104439:	eb 01                	jmp    8010443c <scheduler+0x96>
        continue;
8010443b:	90                   	nop
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
8010443c:	81 45 f4 84 00 00 00 	addl   $0x84,-0xc(%ebp)
80104443:	81 7d f4 34 63 19 80 	cmpl   $0x80196334,-0xc(%ebp)
8010444a:	72 93                	jb     801043df <scheduler+0x39>
    }
    release(&ptable.lock);
8010444c:	83 ec 0c             	sub    $0xc,%esp
8010444f:	68 00 42 19 80       	push   $0x80194200
80104454:	e8 d3 05 00 00       	call   80104a2c <release>
80104459:	83 c4 10             	add    $0x10,%esp
    sti();
8010445c:	e9 60 ff ff ff       	jmp    801043c1 <scheduler+0x1b>

80104461 <sched>:
// be proc->intena and proc->ncli, but that would
// break in the few places where a lock is held but
// there's no process.
void
sched(void)
{
80104461:	55                   	push   %ebp
80104462:	89 e5                	mov    %esp,%ebp
80104464:	83 ec 18             	sub    $0x18,%esp
  int intena;
  struct proc *p = myproc();
80104467:	e8 c4 f5 ff ff       	call   80103a30 <myproc>
8010446c:	89 45 f4             	mov    %eax,-0xc(%ebp)

  if(!holding(&ptable.lock))
8010446f:	83 ec 0c             	sub    $0xc,%esp
80104472:	68 00 42 19 80       	push   $0x80194200
80104477:	e8 7d 06 00 00       	call   80104af9 <holding>
8010447c:	83 c4 10             	add    $0x10,%esp
8010447f:	85 c0                	test   %eax,%eax
80104481:	75 0d                	jne    80104490 <sched+0x2f>
    panic("sched ptable.lock");
80104483:	83 ec 0c             	sub    $0xc,%esp
80104486:	68 01 a6 10 80       	push   $0x8010a601
8010448b:	e8 19 c1 ff ff       	call   801005a9 <panic>
  if(mycpu()->ncli != 1)
80104490:	e8 23 f5 ff ff       	call   801039b8 <mycpu>
80104495:	8b 80 a4 00 00 00    	mov    0xa4(%eax),%eax
8010449b:	83 f8 01             	cmp    $0x1,%eax
8010449e:	74 0d                	je     801044ad <sched+0x4c>
    panic("sched locks");
801044a0:	83 ec 0c             	sub    $0xc,%esp
801044a3:	68 13 a6 10 80       	push   $0x8010a613
801044a8:	e8 fc c0 ff ff       	call   801005a9 <panic>
  if(p->state == RUNNING)
801044ad:	8b 45 f4             	mov    -0xc(%ebp),%eax
801044b0:	8b 40 0c             	mov    0xc(%eax),%eax
801044b3:	83 f8 04             	cmp    $0x4,%eax
801044b6:	75 0d                	jne    801044c5 <sched+0x64>
    panic("sched running");
801044b8:	83 ec 0c             	sub    $0xc,%esp
801044bb:	68 1f a6 10 80       	push   $0x8010a61f
801044c0:	e8 e4 c0 ff ff       	call   801005a9 <panic>
  if(readeflags()&FL_IF)
801044c5:	e8 9e f4 ff ff       	call   80103968 <readeflags>
801044ca:	25 00 02 00 00       	and    $0x200,%eax
801044cf:	85 c0                	test   %eax,%eax
801044d1:	74 0d                	je     801044e0 <sched+0x7f>
    panic("sched interruptible");
801044d3:	83 ec 0c             	sub    $0xc,%esp
801044d6:	68 2d a6 10 80       	push   $0x8010a62d
801044db:	e8 c9 c0 ff ff       	call   801005a9 <panic>
  intena = mycpu()->intena;
801044e0:	e8 d3 f4 ff ff       	call   801039b8 <mycpu>
801044e5:	8b 80 a8 00 00 00    	mov    0xa8(%eax),%eax
801044eb:	89 45 f0             	mov    %eax,-0x10(%ebp)
  swtch(&p->context, mycpu()->scheduler);
801044ee:	e8 c5 f4 ff ff       	call   801039b8 <mycpu>
801044f3:	8b 40 04             	mov    0x4(%eax),%eax
801044f6:	8b 55 f4             	mov    -0xc(%ebp),%edx
801044f9:	83 c2 1c             	add    $0x1c,%edx
801044fc:	83 ec 08             	sub    $0x8,%esp
801044ff:	50                   	push   %eax
80104500:	52                   	push   %edx
80104501:	e8 a3 09 00 00       	call   80104ea9 <swtch>
80104506:	83 c4 10             	add    $0x10,%esp
  mycpu()->intena = intena;
80104509:	e8 aa f4 ff ff       	call   801039b8 <mycpu>
8010450e:	8b 55 f0             	mov    -0x10(%ebp),%edx
80104511:	89 90 a8 00 00 00    	mov    %edx,0xa8(%eax)
}
80104517:	90                   	nop
80104518:	c9                   	leave  
80104519:	c3                   	ret    

8010451a <yield>:

// Give up the CPU for one scheduling round.
void
yield(void)
{
8010451a:	55                   	push   %ebp
8010451b:	89 e5                	mov    %esp,%ebp
8010451d:	83 ec 08             	sub    $0x8,%esp
  acquire(&ptable.lock);  //DOC: yieldlock
80104520:	83 ec 0c             	sub    $0xc,%esp
80104523:	68 00 42 19 80       	push   $0x80194200
80104528:	e8 91 04 00 00       	call   801049be <acquire>
8010452d:	83 c4 10             	add    $0x10,%esp
  myproc()->state = RUNNABLE;
80104530:	e8 fb f4 ff ff       	call   80103a30 <myproc>
80104535:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
  sched();
8010453c:	e8 20 ff ff ff       	call   80104461 <sched>
  release(&ptable.lock);
80104541:	83 ec 0c             	sub    $0xc,%esp
80104544:	68 00 42 19 80       	push   $0x80194200
80104549:	e8 de 04 00 00       	call   80104a2c <release>
8010454e:	83 c4 10             	add    $0x10,%esp
}
80104551:	90                   	nop
80104552:	c9                   	leave  
80104553:	c3                   	ret    

80104554 <forkret>:

// A fork child's very first scheduling by scheduler()
// will swtch here.  "Return" to user space.
void
forkret(void)
{
80104554:	55                   	push   %ebp
80104555:	89 e5                	mov    %esp,%ebp
80104557:	83 ec 08             	sub    $0x8,%esp
  static int first = 1;
  // Still holding ptable.lock from scheduler.
  release(&ptable.lock);
8010455a:	83 ec 0c             	sub    $0xc,%esp
8010455d:	68 00 42 19 80       	push   $0x80194200
80104562:	e8 c5 04 00 00       	call   80104a2c <release>
80104567:	83 c4 10             	add    $0x10,%esp

  if (first) {
8010456a:	a1 04 f0 10 80       	mov    0x8010f004,%eax
8010456f:	85 c0                	test   %eax,%eax
80104571:	74 24                	je     80104597 <forkret+0x43>
    // Some initialization functions must be run in the context
    // of a regular process (e.g., they call sleep), and thus cannot
    // be run from main().
    first = 0;
80104573:	c7 05 04 f0 10 80 00 	movl   $0x0,0x8010f004
8010457a:	00 00 00 
    iinit(ROOTDEV);
8010457d:	83 ec 0c             	sub    $0xc,%esp
80104580:	6a 01                	push   $0x1
80104582:	e8 f1 d0 ff ff       	call   80101678 <iinit>
80104587:	83 c4 10             	add    $0x10,%esp
    initlog(ROOTDEV);
8010458a:	83 ec 0c             	sub    $0xc,%esp
8010458d:	6a 01                	push   $0x1
8010458f:	e8 89 e8 ff ff       	call   80102e1d <initlog>
80104594:	83 c4 10             	add    $0x10,%esp
  }

  // Return to "caller", actually trapret (see allocproc).
}
80104597:	90                   	nop
80104598:	c9                   	leave  
80104599:	c3                   	ret    

8010459a <sleep>:

// Atomically release lock and sleep on chan.
// Reacquires lock when awakened.
void
sleep(void *chan, struct spinlock *lk)
{
8010459a:	55                   	push   %ebp
8010459b:	89 e5                	mov    %esp,%ebp
8010459d:	83 ec 18             	sub    $0x18,%esp
  struct proc *p = myproc();
801045a0:	e8 8b f4 ff ff       	call   80103a30 <myproc>
801045a5:	89 45 f4             	mov    %eax,-0xc(%ebp)
  
  if(p == 0)
801045a8:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801045ac:	75 0d                	jne    801045bb <sleep+0x21>
    panic("sleep");
801045ae:	83 ec 0c             	sub    $0xc,%esp
801045b1:	68 41 a6 10 80       	push   $0x8010a641
801045b6:	e8 ee bf ff ff       	call   801005a9 <panic>

  if(lk == 0)
801045bb:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
801045bf:	75 0d                	jne    801045ce <sleep+0x34>
    panic("sleep without lk");
801045c1:	83 ec 0c             	sub    $0xc,%esp
801045c4:	68 47 a6 10 80       	push   $0x8010a647
801045c9:	e8 db bf ff ff       	call   801005a9 <panic>
  // change p->state and then call sched.
  // Once we hold ptable.lock, we can be
  // guaranteed that we won't miss any wakeup
  // (wakeup runs with ptable.lock locked),
  // so it's okay to release lk.
  if(lk != &ptable.lock){  //DOC: sleeplock0
801045ce:	81 7d 0c 00 42 19 80 	cmpl   $0x80194200,0xc(%ebp)
801045d5:	74 1e                	je     801045f5 <sleep+0x5b>
    acquire(&ptable.lock);  //DOC: sleeplock1
801045d7:	83 ec 0c             	sub    $0xc,%esp
801045da:	68 00 42 19 80       	push   $0x80194200
801045df:	e8 da 03 00 00       	call   801049be <acquire>
801045e4:	83 c4 10             	add    $0x10,%esp
    release(lk);
801045e7:	83 ec 0c             	sub    $0xc,%esp
801045ea:	ff 75 0c             	push   0xc(%ebp)
801045ed:	e8 3a 04 00 00       	call   80104a2c <release>
801045f2:	83 c4 10             	add    $0x10,%esp
  }
  // Go to sleep.
  p->chan = chan;
801045f5:	8b 45 f4             	mov    -0xc(%ebp),%eax
801045f8:	8b 55 08             	mov    0x8(%ebp),%edx
801045fb:	89 50 20             	mov    %edx,0x20(%eax)
  p->state = SLEEPING;
801045fe:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104601:	c7 40 0c 02 00 00 00 	movl   $0x2,0xc(%eax)

  sched();
80104608:	e8 54 fe ff ff       	call   80104461 <sched>

  // Tidy up.
  p->chan = 0;
8010460d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104610:	c7 40 20 00 00 00 00 	movl   $0x0,0x20(%eax)

  // Reacquire original lock.
  if(lk != &ptable.lock){  //DOC: sleeplock2
80104617:	81 7d 0c 00 42 19 80 	cmpl   $0x80194200,0xc(%ebp)
8010461e:	74 1e                	je     8010463e <sleep+0xa4>
    release(&ptable.lock);
80104620:	83 ec 0c             	sub    $0xc,%esp
80104623:	68 00 42 19 80       	push   $0x80194200
80104628:	e8 ff 03 00 00       	call   80104a2c <release>
8010462d:	83 c4 10             	add    $0x10,%esp
    acquire(lk);
80104630:	83 ec 0c             	sub    $0xc,%esp
80104633:	ff 75 0c             	push   0xc(%ebp)
80104636:	e8 83 03 00 00       	call   801049be <acquire>
8010463b:	83 c4 10             	add    $0x10,%esp
  }
}
8010463e:	90                   	nop
8010463f:	c9                   	leave  
80104640:	c3                   	ret    

80104641 <wakeup1>:
//PAGEBREAK!
// Wake up all processes sleeping on chan.
// The ptable lock must be held.
static void
wakeup1(void *chan)
{
80104641:	55                   	push   %ebp
80104642:	89 e5                	mov    %esp,%ebp
80104644:	83 ec 10             	sub    $0x10,%esp
  struct proc *p;

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104647:	c7 45 fc 34 42 19 80 	movl   $0x80194234,-0x4(%ebp)
8010464e:	eb 27                	jmp    80104677 <wakeup1+0x36>
    if(p->state == SLEEPING && p->chan == chan)
80104650:	8b 45 fc             	mov    -0x4(%ebp),%eax
80104653:	8b 40 0c             	mov    0xc(%eax),%eax
80104656:	83 f8 02             	cmp    $0x2,%eax
80104659:	75 15                	jne    80104670 <wakeup1+0x2f>
8010465b:	8b 45 fc             	mov    -0x4(%ebp),%eax
8010465e:	8b 40 20             	mov    0x20(%eax),%eax
80104661:	39 45 08             	cmp    %eax,0x8(%ebp)
80104664:	75 0a                	jne    80104670 <wakeup1+0x2f>
      p->state = RUNNABLE;
80104666:	8b 45 fc             	mov    -0x4(%ebp),%eax
80104669:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104670:	81 45 fc 84 00 00 00 	addl   $0x84,-0x4(%ebp)
80104677:	81 7d fc 34 63 19 80 	cmpl   $0x80196334,-0x4(%ebp)
8010467e:	72 d0                	jb     80104650 <wakeup1+0xf>
}
80104680:	90                   	nop
80104681:	90                   	nop
80104682:	c9                   	leave  
80104683:	c3                   	ret    

80104684 <wakeup>:

// Wake up all processes sleeping on chan.
void
wakeup(void *chan)
{
80104684:	55                   	push   %ebp
80104685:	89 e5                	mov    %esp,%ebp
80104687:	83 ec 08             	sub    $0x8,%esp
  acquire(&ptable.lock);
8010468a:	83 ec 0c             	sub    $0xc,%esp
8010468d:	68 00 42 19 80       	push   $0x80194200
80104692:	e8 27 03 00 00       	call   801049be <acquire>
80104697:	83 c4 10             	add    $0x10,%esp
  wakeup1(chan);
8010469a:	83 ec 0c             	sub    $0xc,%esp
8010469d:	ff 75 08             	push   0x8(%ebp)
801046a0:	e8 9c ff ff ff       	call   80104641 <wakeup1>
801046a5:	83 c4 10             	add    $0x10,%esp
  release(&ptable.lock);
801046a8:	83 ec 0c             	sub    $0xc,%esp
801046ab:	68 00 42 19 80       	push   $0x80194200
801046b0:	e8 77 03 00 00       	call   80104a2c <release>
801046b5:	83 c4 10             	add    $0x10,%esp
}
801046b8:	90                   	nop
801046b9:	c9                   	leave  
801046ba:	c3                   	ret    

801046bb <kill>:
// Kill the process with the given pid.
// Process won't exit until it returns
// to user space (see trap in trap.c).
int
kill(int pid)
{
801046bb:	55                   	push   %ebp
801046bc:	89 e5                	mov    %esp,%ebp
801046be:	83 ec 18             	sub    $0x18,%esp
  struct proc *p;

  acquire(&ptable.lock);
801046c1:	83 ec 0c             	sub    $0xc,%esp
801046c4:	68 00 42 19 80       	push   $0x80194200
801046c9:	e8 f0 02 00 00       	call   801049be <acquire>
801046ce:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801046d1:	c7 45 f4 34 42 19 80 	movl   $0x80194234,-0xc(%ebp)
801046d8:	eb 48                	jmp    80104722 <kill+0x67>
    if(p->pid == pid){
801046da:	8b 45 f4             	mov    -0xc(%ebp),%eax
801046dd:	8b 40 10             	mov    0x10(%eax),%eax
801046e0:	39 45 08             	cmp    %eax,0x8(%ebp)
801046e3:	75 36                	jne    8010471b <kill+0x60>
      p->killed = 1;
801046e5:	8b 45 f4             	mov    -0xc(%ebp),%eax
801046e8:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
      // Wake process from sleep if necessary.
      if(p->state == SLEEPING)
801046ef:	8b 45 f4             	mov    -0xc(%ebp),%eax
801046f2:	8b 40 0c             	mov    0xc(%eax),%eax
801046f5:	83 f8 02             	cmp    $0x2,%eax
801046f8:	75 0a                	jne    80104704 <kill+0x49>
        p->state = RUNNABLE;
801046fa:	8b 45 f4             	mov    -0xc(%ebp),%eax
801046fd:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
      release(&ptable.lock);
80104704:	83 ec 0c             	sub    $0xc,%esp
80104707:	68 00 42 19 80       	push   $0x80194200
8010470c:	e8 1b 03 00 00       	call   80104a2c <release>
80104711:	83 c4 10             	add    $0x10,%esp
      return 0;
80104714:	b8 00 00 00 00       	mov    $0x0,%eax
80104719:	eb 25                	jmp    80104740 <kill+0x85>
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
8010471b:	81 45 f4 84 00 00 00 	addl   $0x84,-0xc(%ebp)
80104722:	81 7d f4 34 63 19 80 	cmpl   $0x80196334,-0xc(%ebp)
80104729:	72 af                	jb     801046da <kill+0x1f>
    }
  }
  release(&ptable.lock);
8010472b:	83 ec 0c             	sub    $0xc,%esp
8010472e:	68 00 42 19 80       	push   $0x80194200
80104733:	e8 f4 02 00 00       	call   80104a2c <release>
80104738:	83 c4 10             	add    $0x10,%esp
  return -1;
8010473b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104740:	c9                   	leave  
80104741:	c3                   	ret    

80104742 <procdump>:
// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void
procdump(void)
{
80104742:	55                   	push   %ebp
80104743:	89 e5                	mov    %esp,%ebp
80104745:	83 ec 48             	sub    $0x48,%esp
  int i;
  struct proc *p;
  char *state;
  uint pc[10];

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104748:	c7 45 f0 34 42 19 80 	movl   $0x80194234,-0x10(%ebp)
8010474f:	e9 da 00 00 00       	jmp    8010482e <procdump+0xec>
    if(p->state == UNUSED)
80104754:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104757:	8b 40 0c             	mov    0xc(%eax),%eax
8010475a:	85 c0                	test   %eax,%eax
8010475c:	0f 84 c4 00 00 00    	je     80104826 <procdump+0xe4>
      continue;
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
80104762:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104765:	8b 40 0c             	mov    0xc(%eax),%eax
80104768:	83 f8 05             	cmp    $0x5,%eax
8010476b:	77 23                	ja     80104790 <procdump+0x4e>
8010476d:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104770:	8b 40 0c             	mov    0xc(%eax),%eax
80104773:	8b 04 85 08 f0 10 80 	mov    -0x7fef0ff8(,%eax,4),%eax
8010477a:	85 c0                	test   %eax,%eax
8010477c:	74 12                	je     80104790 <procdump+0x4e>
      state = states[p->state];
8010477e:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104781:	8b 40 0c             	mov    0xc(%eax),%eax
80104784:	8b 04 85 08 f0 10 80 	mov    -0x7fef0ff8(,%eax,4),%eax
8010478b:	89 45 ec             	mov    %eax,-0x14(%ebp)
8010478e:	eb 07                	jmp    80104797 <procdump+0x55>
    else
      state = "???";
80104790:	c7 45 ec 58 a6 10 80 	movl   $0x8010a658,-0x14(%ebp)
    cprintf("%d %s %s", p->pid, state, p->name);
80104797:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010479a:	8d 50 6c             	lea    0x6c(%eax),%edx
8010479d:	8b 45 f0             	mov    -0x10(%ebp),%eax
801047a0:	8b 40 10             	mov    0x10(%eax),%eax
801047a3:	52                   	push   %edx
801047a4:	ff 75 ec             	push   -0x14(%ebp)
801047a7:	50                   	push   %eax
801047a8:	68 5c a6 10 80       	push   $0x8010a65c
801047ad:	e8 42 bc ff ff       	call   801003f4 <cprintf>
801047b2:	83 c4 10             	add    $0x10,%esp
    if(p->state == SLEEPING){
801047b5:	8b 45 f0             	mov    -0x10(%ebp),%eax
801047b8:	8b 40 0c             	mov    0xc(%eax),%eax
801047bb:	83 f8 02             	cmp    $0x2,%eax
801047be:	75 54                	jne    80104814 <procdump+0xd2>
      getcallerpcs((uint*)p->context->ebp+2, pc);
801047c0:	8b 45 f0             	mov    -0x10(%ebp),%eax
801047c3:	8b 40 1c             	mov    0x1c(%eax),%eax
801047c6:	8b 40 0c             	mov    0xc(%eax),%eax
801047c9:	83 c0 08             	add    $0x8,%eax
801047cc:	89 c2                	mov    %eax,%edx
801047ce:	83 ec 08             	sub    $0x8,%esp
801047d1:	8d 45 c4             	lea    -0x3c(%ebp),%eax
801047d4:	50                   	push   %eax
801047d5:	52                   	push   %edx
801047d6:	e8 a3 02 00 00       	call   80104a7e <getcallerpcs>
801047db:	83 c4 10             	add    $0x10,%esp
      for(i=0; i<10 && pc[i] != 0; i++)
801047de:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
801047e5:	eb 1c                	jmp    80104803 <procdump+0xc1>
        cprintf(" %p", pc[i]);
801047e7:	8b 45 f4             	mov    -0xc(%ebp),%eax
801047ea:	8b 44 85 c4          	mov    -0x3c(%ebp,%eax,4),%eax
801047ee:	83 ec 08             	sub    $0x8,%esp
801047f1:	50                   	push   %eax
801047f2:	68 65 a6 10 80       	push   $0x8010a665
801047f7:	e8 f8 bb ff ff       	call   801003f4 <cprintf>
801047fc:	83 c4 10             	add    $0x10,%esp
      for(i=0; i<10 && pc[i] != 0; i++)
801047ff:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80104803:	83 7d f4 09          	cmpl   $0x9,-0xc(%ebp)
80104807:	7f 0b                	jg     80104814 <procdump+0xd2>
80104809:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010480c:	8b 44 85 c4          	mov    -0x3c(%ebp,%eax,4),%eax
80104810:	85 c0                	test   %eax,%eax
80104812:	75 d3                	jne    801047e7 <procdump+0xa5>
    }
    cprintf("\n");
80104814:	83 ec 0c             	sub    $0xc,%esp
80104817:	68 69 a6 10 80       	push   $0x8010a669
8010481c:	e8 d3 bb ff ff       	call   801003f4 <cprintf>
80104821:	83 c4 10             	add    $0x10,%esp
80104824:	eb 01                	jmp    80104827 <procdump+0xe5>
      continue;
80104826:	90                   	nop
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104827:	81 45 f0 84 00 00 00 	addl   $0x84,-0x10(%ebp)
8010482e:	81 7d f0 34 63 19 80 	cmpl   $0x80196334,-0x10(%ebp)
80104835:	0f 82 19 ff ff ff    	jb     80104754 <procdump+0x12>
  }
}
8010483b:	90                   	nop
8010483c:	90                   	nop
8010483d:	c9                   	leave  
8010483e:	c3                   	ret    

8010483f <initsleeplock>:
#include "spinlock.h"
#include "sleeplock.h"

void
initsleeplock(struct sleeplock *lk, char *name)
{
8010483f:	55                   	push   %ebp
80104840:	89 e5                	mov    %esp,%ebp
80104842:	83 ec 08             	sub    $0x8,%esp
  initlock(&lk->lk, "sleep lock");
80104845:	8b 45 08             	mov    0x8(%ebp),%eax
80104848:	83 c0 04             	add    $0x4,%eax
8010484b:	83 ec 08             	sub    $0x8,%esp
8010484e:	68 95 a6 10 80       	push   $0x8010a695
80104853:	50                   	push   %eax
80104854:	e8 43 01 00 00       	call   8010499c <initlock>
80104859:	83 c4 10             	add    $0x10,%esp
  lk->name = name;
8010485c:	8b 45 08             	mov    0x8(%ebp),%eax
8010485f:	8b 55 0c             	mov    0xc(%ebp),%edx
80104862:	89 50 38             	mov    %edx,0x38(%eax)
  lk->locked = 0;
80104865:	8b 45 08             	mov    0x8(%ebp),%eax
80104868:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  lk->pid = 0;
8010486e:	8b 45 08             	mov    0x8(%ebp),%eax
80104871:	c7 40 3c 00 00 00 00 	movl   $0x0,0x3c(%eax)
}
80104878:	90                   	nop
80104879:	c9                   	leave  
8010487a:	c3                   	ret    

8010487b <acquiresleep>:

void
acquiresleep(struct sleeplock *lk)
{
8010487b:	55                   	push   %ebp
8010487c:	89 e5                	mov    %esp,%ebp
8010487e:	83 ec 08             	sub    $0x8,%esp
  acquire(&lk->lk);
80104881:	8b 45 08             	mov    0x8(%ebp),%eax
80104884:	83 c0 04             	add    $0x4,%eax
80104887:	83 ec 0c             	sub    $0xc,%esp
8010488a:	50                   	push   %eax
8010488b:	e8 2e 01 00 00       	call   801049be <acquire>
80104890:	83 c4 10             	add    $0x10,%esp
  while (lk->locked) {
80104893:	eb 15                	jmp    801048aa <acquiresleep+0x2f>
    sleep(lk, &lk->lk);
80104895:	8b 45 08             	mov    0x8(%ebp),%eax
80104898:	83 c0 04             	add    $0x4,%eax
8010489b:	83 ec 08             	sub    $0x8,%esp
8010489e:	50                   	push   %eax
8010489f:	ff 75 08             	push   0x8(%ebp)
801048a2:	e8 f3 fc ff ff       	call   8010459a <sleep>
801048a7:	83 c4 10             	add    $0x10,%esp
  while (lk->locked) {
801048aa:	8b 45 08             	mov    0x8(%ebp),%eax
801048ad:	8b 00                	mov    (%eax),%eax
801048af:	85 c0                	test   %eax,%eax
801048b1:	75 e2                	jne    80104895 <acquiresleep+0x1a>
  }
  lk->locked = 1;
801048b3:	8b 45 08             	mov    0x8(%ebp),%eax
801048b6:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  lk->pid = myproc()->pid;
801048bc:	e8 6f f1 ff ff       	call   80103a30 <myproc>
801048c1:	8b 50 10             	mov    0x10(%eax),%edx
801048c4:	8b 45 08             	mov    0x8(%ebp),%eax
801048c7:	89 50 3c             	mov    %edx,0x3c(%eax)
  release(&lk->lk);
801048ca:	8b 45 08             	mov    0x8(%ebp),%eax
801048cd:	83 c0 04             	add    $0x4,%eax
801048d0:	83 ec 0c             	sub    $0xc,%esp
801048d3:	50                   	push   %eax
801048d4:	e8 53 01 00 00       	call   80104a2c <release>
801048d9:	83 c4 10             	add    $0x10,%esp
}
801048dc:	90                   	nop
801048dd:	c9                   	leave  
801048de:	c3                   	ret    

801048df <releasesleep>:

void
releasesleep(struct sleeplock *lk)
{
801048df:	55                   	push   %ebp
801048e0:	89 e5                	mov    %esp,%ebp
801048e2:	83 ec 08             	sub    $0x8,%esp
  acquire(&lk->lk);
801048e5:	8b 45 08             	mov    0x8(%ebp),%eax
801048e8:	83 c0 04             	add    $0x4,%eax
801048eb:	83 ec 0c             	sub    $0xc,%esp
801048ee:	50                   	push   %eax
801048ef:	e8 ca 00 00 00       	call   801049be <acquire>
801048f4:	83 c4 10             	add    $0x10,%esp
  lk->locked = 0;
801048f7:	8b 45 08             	mov    0x8(%ebp),%eax
801048fa:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  lk->pid = 0;
80104900:	8b 45 08             	mov    0x8(%ebp),%eax
80104903:	c7 40 3c 00 00 00 00 	movl   $0x0,0x3c(%eax)
  wakeup(lk);
8010490a:	83 ec 0c             	sub    $0xc,%esp
8010490d:	ff 75 08             	push   0x8(%ebp)
80104910:	e8 6f fd ff ff       	call   80104684 <wakeup>
80104915:	83 c4 10             	add    $0x10,%esp
  release(&lk->lk);
80104918:	8b 45 08             	mov    0x8(%ebp),%eax
8010491b:	83 c0 04             	add    $0x4,%eax
8010491e:	83 ec 0c             	sub    $0xc,%esp
80104921:	50                   	push   %eax
80104922:	e8 05 01 00 00       	call   80104a2c <release>
80104927:	83 c4 10             	add    $0x10,%esp
}
8010492a:	90                   	nop
8010492b:	c9                   	leave  
8010492c:	c3                   	ret    

8010492d <holdingsleep>:

int
holdingsleep(struct sleeplock *lk)
{
8010492d:	55                   	push   %ebp
8010492e:	89 e5                	mov    %esp,%ebp
80104930:	83 ec 18             	sub    $0x18,%esp
  int r;
  
  acquire(&lk->lk);
80104933:	8b 45 08             	mov    0x8(%ebp),%eax
80104936:	83 c0 04             	add    $0x4,%eax
80104939:	83 ec 0c             	sub    $0xc,%esp
8010493c:	50                   	push   %eax
8010493d:	e8 7c 00 00 00       	call   801049be <acquire>
80104942:	83 c4 10             	add    $0x10,%esp
  r = lk->locked;
80104945:	8b 45 08             	mov    0x8(%ebp),%eax
80104948:	8b 00                	mov    (%eax),%eax
8010494a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  release(&lk->lk);
8010494d:	8b 45 08             	mov    0x8(%ebp),%eax
80104950:	83 c0 04             	add    $0x4,%eax
80104953:	83 ec 0c             	sub    $0xc,%esp
80104956:	50                   	push   %eax
80104957:	e8 d0 00 00 00       	call   80104a2c <release>
8010495c:	83 c4 10             	add    $0x10,%esp
  return r;
8010495f:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
80104962:	c9                   	leave  
80104963:	c3                   	ret    

80104964 <readeflags>:
{
80104964:	55                   	push   %ebp
80104965:	89 e5                	mov    %esp,%ebp
80104967:	83 ec 10             	sub    $0x10,%esp
  asm volatile("pushfl; popl %0" : "=r" (eflags));
8010496a:	9c                   	pushf  
8010496b:	58                   	pop    %eax
8010496c:	89 45 fc             	mov    %eax,-0x4(%ebp)
  return eflags;
8010496f:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
80104972:	c9                   	leave  
80104973:	c3                   	ret    

80104974 <cli>:
{
80104974:	55                   	push   %ebp
80104975:	89 e5                	mov    %esp,%ebp
  asm volatile("cli");
80104977:	fa                   	cli    
}
80104978:	90                   	nop
80104979:	5d                   	pop    %ebp
8010497a:	c3                   	ret    

8010497b <sti>:
{
8010497b:	55                   	push   %ebp
8010497c:	89 e5                	mov    %esp,%ebp
  asm volatile("sti");
8010497e:	fb                   	sti    
}
8010497f:	90                   	nop
80104980:	5d                   	pop    %ebp
80104981:	c3                   	ret    

80104982 <xchg>:
{
80104982:	55                   	push   %ebp
80104983:	89 e5                	mov    %esp,%ebp
80104985:	83 ec 10             	sub    $0x10,%esp
  asm volatile("lock; xchgl %0, %1" :
80104988:	8b 55 08             	mov    0x8(%ebp),%edx
8010498b:	8b 45 0c             	mov    0xc(%ebp),%eax
8010498e:	8b 4d 08             	mov    0x8(%ebp),%ecx
80104991:	f0 87 02             	lock xchg %eax,(%edx)
80104994:	89 45 fc             	mov    %eax,-0x4(%ebp)
  return result;
80104997:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
8010499a:	c9                   	leave  
8010499b:	c3                   	ret    

8010499c <initlock>:
#include "proc.h"
#include "spinlock.h"

void
initlock(struct spinlock *lk, char *name)
{
8010499c:	55                   	push   %ebp
8010499d:	89 e5                	mov    %esp,%ebp
  lk->name = name;
8010499f:	8b 45 08             	mov    0x8(%ebp),%eax
801049a2:	8b 55 0c             	mov    0xc(%ebp),%edx
801049a5:	89 50 04             	mov    %edx,0x4(%eax)
  lk->locked = 0;
801049a8:	8b 45 08             	mov    0x8(%ebp),%eax
801049ab:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  lk->cpu = 0;
801049b1:	8b 45 08             	mov    0x8(%ebp),%eax
801049b4:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
}
801049bb:	90                   	nop
801049bc:	5d                   	pop    %ebp
801049bd:	c3                   	ret    

801049be <acquire>:
// Loops (spins) until the lock is acquired.
// Holding a lock for a long time may cause
// other CPUs to waste time spinning to acquire it.
void
acquire(struct spinlock *lk)
{
801049be:	55                   	push   %ebp
801049bf:	89 e5                	mov    %esp,%ebp
801049c1:	53                   	push   %ebx
801049c2:	83 ec 04             	sub    $0x4,%esp
  pushcli(); // disable interrupts to avoid deadlock.
801049c5:	e8 5f 01 00 00       	call   80104b29 <pushcli>
  if(holding(lk)){
801049ca:	8b 45 08             	mov    0x8(%ebp),%eax
801049cd:	83 ec 0c             	sub    $0xc,%esp
801049d0:	50                   	push   %eax
801049d1:	e8 23 01 00 00       	call   80104af9 <holding>
801049d6:	83 c4 10             	add    $0x10,%esp
801049d9:	85 c0                	test   %eax,%eax
801049db:	74 0d                	je     801049ea <acquire+0x2c>
    panic("acquire");
801049dd:	83 ec 0c             	sub    $0xc,%esp
801049e0:	68 a0 a6 10 80       	push   $0x8010a6a0
801049e5:	e8 bf bb ff ff       	call   801005a9 <panic>
  }

  // The xchg is atomic.
  while(xchg(&lk->locked, 1) != 0)
801049ea:	90                   	nop
801049eb:	8b 45 08             	mov    0x8(%ebp),%eax
801049ee:	83 ec 08             	sub    $0x8,%esp
801049f1:	6a 01                	push   $0x1
801049f3:	50                   	push   %eax
801049f4:	e8 89 ff ff ff       	call   80104982 <xchg>
801049f9:	83 c4 10             	add    $0x10,%esp
801049fc:	85 c0                	test   %eax,%eax
801049fe:	75 eb                	jne    801049eb <acquire+0x2d>
    ;

  // Tell the C compiler and the processor to not move loads or stores
  // past this point, to ensure that the critical section's memory
  // references happen after the lock is acquired.
  __sync_synchronize();
80104a00:	f0 83 0c 24 00       	lock orl $0x0,(%esp)

  // Record info about lock acquisition for debugging.
  lk->cpu = mycpu();
80104a05:	8b 5d 08             	mov    0x8(%ebp),%ebx
80104a08:	e8 ab ef ff ff       	call   801039b8 <mycpu>
80104a0d:	89 43 08             	mov    %eax,0x8(%ebx)
  getcallerpcs(&lk, lk->pcs);
80104a10:	8b 45 08             	mov    0x8(%ebp),%eax
80104a13:	83 c0 0c             	add    $0xc,%eax
80104a16:	83 ec 08             	sub    $0x8,%esp
80104a19:	50                   	push   %eax
80104a1a:	8d 45 08             	lea    0x8(%ebp),%eax
80104a1d:	50                   	push   %eax
80104a1e:	e8 5b 00 00 00       	call   80104a7e <getcallerpcs>
80104a23:	83 c4 10             	add    $0x10,%esp
}
80104a26:	90                   	nop
80104a27:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104a2a:	c9                   	leave  
80104a2b:	c3                   	ret    

80104a2c <release>:

// Release the lock.
void
release(struct spinlock *lk)
{
80104a2c:	55                   	push   %ebp
80104a2d:	89 e5                	mov    %esp,%ebp
80104a2f:	83 ec 08             	sub    $0x8,%esp
  if(!holding(lk))
80104a32:	83 ec 0c             	sub    $0xc,%esp
80104a35:	ff 75 08             	push   0x8(%ebp)
80104a38:	e8 bc 00 00 00       	call   80104af9 <holding>
80104a3d:	83 c4 10             	add    $0x10,%esp
80104a40:	85 c0                	test   %eax,%eax
80104a42:	75 0d                	jne    80104a51 <release+0x25>
    panic("release");
80104a44:	83 ec 0c             	sub    $0xc,%esp
80104a47:	68 a8 a6 10 80       	push   $0x8010a6a8
80104a4c:	e8 58 bb ff ff       	call   801005a9 <panic>

  lk->pcs[0] = 0;
80104a51:	8b 45 08             	mov    0x8(%ebp),%eax
80104a54:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
  lk->cpu = 0;
80104a5b:	8b 45 08             	mov    0x8(%ebp),%eax
80104a5e:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  // Tell the C compiler and the processor to not move loads or stores
  // past this point, to ensure that all the stores in the critical
  // section are visible to other cores before the lock is released.
  // Both the C compiler and the hardware may re-order loads and
  // stores; __sync_synchronize() tells them both not to.
  __sync_synchronize();
80104a65:	f0 83 0c 24 00       	lock orl $0x0,(%esp)

  // Release the lock, equivalent to lk->locked = 0.
  // This code can't use a C assignment, since it might
  // not be atomic. A real OS would use C atomics here.
  asm volatile("movl $0, %0" : "+m" (lk->locked) : );
80104a6a:	8b 45 08             	mov    0x8(%ebp),%eax
80104a6d:	8b 55 08             	mov    0x8(%ebp),%edx
80104a70:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

  popcli();
80104a76:	e8 fb 00 00 00       	call   80104b76 <popcli>
}
80104a7b:	90                   	nop
80104a7c:	c9                   	leave  
80104a7d:	c3                   	ret    

80104a7e <getcallerpcs>:

// Record the current call stack in pcs[] by following the %ebp chain.
void
getcallerpcs(void *v, uint pcs[])
{
80104a7e:	55                   	push   %ebp
80104a7f:	89 e5                	mov    %esp,%ebp
80104a81:	83 ec 10             	sub    $0x10,%esp
  uint *ebp;
  int i;

  ebp = (uint*)v - 2;
80104a84:	8b 45 08             	mov    0x8(%ebp),%eax
80104a87:	83 e8 08             	sub    $0x8,%eax
80104a8a:	89 45 fc             	mov    %eax,-0x4(%ebp)
  for(i = 0; i < 10; i++){
80104a8d:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
80104a94:	eb 38                	jmp    80104ace <getcallerpcs+0x50>
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
80104a96:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
80104a9a:	74 53                	je     80104aef <getcallerpcs+0x71>
80104a9c:	81 7d fc ff ff ff 7f 	cmpl   $0x7fffffff,-0x4(%ebp)
80104aa3:	76 4a                	jbe    80104aef <getcallerpcs+0x71>
80104aa5:	83 7d fc ff          	cmpl   $0xffffffff,-0x4(%ebp)
80104aa9:	74 44                	je     80104aef <getcallerpcs+0x71>
      break;
    pcs[i] = ebp[1];     // saved %eip
80104aab:	8b 45 f8             	mov    -0x8(%ebp),%eax
80104aae:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80104ab5:	8b 45 0c             	mov    0xc(%ebp),%eax
80104ab8:	01 c2                	add    %eax,%edx
80104aba:	8b 45 fc             	mov    -0x4(%ebp),%eax
80104abd:	8b 40 04             	mov    0x4(%eax),%eax
80104ac0:	89 02                	mov    %eax,(%edx)
    ebp = (uint*)ebp[0]; // saved %ebp
80104ac2:	8b 45 fc             	mov    -0x4(%ebp),%eax
80104ac5:	8b 00                	mov    (%eax),%eax
80104ac7:	89 45 fc             	mov    %eax,-0x4(%ebp)
  for(i = 0; i < 10; i++){
80104aca:	83 45 f8 01          	addl   $0x1,-0x8(%ebp)
80104ace:	83 7d f8 09          	cmpl   $0x9,-0x8(%ebp)
80104ad2:	7e c2                	jle    80104a96 <getcallerpcs+0x18>
  }
  for(; i < 10; i++)
80104ad4:	eb 19                	jmp    80104aef <getcallerpcs+0x71>
    pcs[i] = 0;
80104ad6:	8b 45 f8             	mov    -0x8(%ebp),%eax
80104ad9:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80104ae0:	8b 45 0c             	mov    0xc(%ebp),%eax
80104ae3:	01 d0                	add    %edx,%eax
80104ae5:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  for(; i < 10; i++)
80104aeb:	83 45 f8 01          	addl   $0x1,-0x8(%ebp)
80104aef:	83 7d f8 09          	cmpl   $0x9,-0x8(%ebp)
80104af3:	7e e1                	jle    80104ad6 <getcallerpcs+0x58>
}
80104af5:	90                   	nop
80104af6:	90                   	nop
80104af7:	c9                   	leave  
80104af8:	c3                   	ret    

80104af9 <holding>:

// Check whether this cpu is holding the lock.
int
holding(struct spinlock *lock)
{
80104af9:	55                   	push   %ebp
80104afa:	89 e5                	mov    %esp,%ebp
80104afc:	53                   	push   %ebx
80104afd:	83 ec 04             	sub    $0x4,%esp
  return lock->locked && lock->cpu == mycpu();
80104b00:	8b 45 08             	mov    0x8(%ebp),%eax
80104b03:	8b 00                	mov    (%eax),%eax
80104b05:	85 c0                	test   %eax,%eax
80104b07:	74 16                	je     80104b1f <holding+0x26>
80104b09:	8b 45 08             	mov    0x8(%ebp),%eax
80104b0c:	8b 58 08             	mov    0x8(%eax),%ebx
80104b0f:	e8 a4 ee ff ff       	call   801039b8 <mycpu>
80104b14:	39 c3                	cmp    %eax,%ebx
80104b16:	75 07                	jne    80104b1f <holding+0x26>
80104b18:	b8 01 00 00 00       	mov    $0x1,%eax
80104b1d:	eb 05                	jmp    80104b24 <holding+0x2b>
80104b1f:	b8 00 00 00 00       	mov    $0x0,%eax
}
80104b24:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104b27:	c9                   	leave  
80104b28:	c3                   	ret    

80104b29 <pushcli>:
// it takes two popcli to undo two pushcli.  Also, if interrupts
// are off, then pushcli, popcli leaves them off.

void
pushcli(void)
{
80104b29:	55                   	push   %ebp
80104b2a:	89 e5                	mov    %esp,%ebp
80104b2c:	83 ec 18             	sub    $0x18,%esp
  int eflags;

  eflags = readeflags();
80104b2f:	e8 30 fe ff ff       	call   80104964 <readeflags>
80104b34:	89 45 f4             	mov    %eax,-0xc(%ebp)
  cli();
80104b37:	e8 38 fe ff ff       	call   80104974 <cli>
  if(mycpu()->ncli == 0)
80104b3c:	e8 77 ee ff ff       	call   801039b8 <mycpu>
80104b41:	8b 80 a4 00 00 00    	mov    0xa4(%eax),%eax
80104b47:	85 c0                	test   %eax,%eax
80104b49:	75 14                	jne    80104b5f <pushcli+0x36>
    mycpu()->intena = eflags & FL_IF;
80104b4b:	e8 68 ee ff ff       	call   801039b8 <mycpu>
80104b50:	8b 55 f4             	mov    -0xc(%ebp),%edx
80104b53:	81 e2 00 02 00 00    	and    $0x200,%edx
80104b59:	89 90 a8 00 00 00    	mov    %edx,0xa8(%eax)
  mycpu()->ncli += 1;
80104b5f:	e8 54 ee ff ff       	call   801039b8 <mycpu>
80104b64:	8b 90 a4 00 00 00    	mov    0xa4(%eax),%edx
80104b6a:	83 c2 01             	add    $0x1,%edx
80104b6d:	89 90 a4 00 00 00    	mov    %edx,0xa4(%eax)
}
80104b73:	90                   	nop
80104b74:	c9                   	leave  
80104b75:	c3                   	ret    

80104b76 <popcli>:

void
popcli(void)
{
80104b76:	55                   	push   %ebp
80104b77:	89 e5                	mov    %esp,%ebp
80104b79:	83 ec 08             	sub    $0x8,%esp
  if(readeflags()&FL_IF)
80104b7c:	e8 e3 fd ff ff       	call   80104964 <readeflags>
80104b81:	25 00 02 00 00       	and    $0x200,%eax
80104b86:	85 c0                	test   %eax,%eax
80104b88:	74 0d                	je     80104b97 <popcli+0x21>
    panic("popcli - interruptible");
80104b8a:	83 ec 0c             	sub    $0xc,%esp
80104b8d:	68 b0 a6 10 80       	push   $0x8010a6b0
80104b92:	e8 12 ba ff ff       	call   801005a9 <panic>
  if(--mycpu()->ncli < 0)
80104b97:	e8 1c ee ff ff       	call   801039b8 <mycpu>
80104b9c:	8b 90 a4 00 00 00    	mov    0xa4(%eax),%edx
80104ba2:	83 ea 01             	sub    $0x1,%edx
80104ba5:	89 90 a4 00 00 00    	mov    %edx,0xa4(%eax)
80104bab:	8b 80 a4 00 00 00    	mov    0xa4(%eax),%eax
80104bb1:	85 c0                	test   %eax,%eax
80104bb3:	79 0d                	jns    80104bc2 <popcli+0x4c>
    panic("popcli");
80104bb5:	83 ec 0c             	sub    $0xc,%esp
80104bb8:	68 c7 a6 10 80       	push   $0x8010a6c7
80104bbd:	e8 e7 b9 ff ff       	call   801005a9 <panic>
  if(mycpu()->ncli == 0 && mycpu()->intena)
80104bc2:	e8 f1 ed ff ff       	call   801039b8 <mycpu>
80104bc7:	8b 80 a4 00 00 00    	mov    0xa4(%eax),%eax
80104bcd:	85 c0                	test   %eax,%eax
80104bcf:	75 14                	jne    80104be5 <popcli+0x6f>
80104bd1:	e8 e2 ed ff ff       	call   801039b8 <mycpu>
80104bd6:	8b 80 a8 00 00 00    	mov    0xa8(%eax),%eax
80104bdc:	85 c0                	test   %eax,%eax
80104bde:	74 05                	je     80104be5 <popcli+0x6f>
    sti();
80104be0:	e8 96 fd ff ff       	call   8010497b <sti>
}
80104be5:	90                   	nop
80104be6:	c9                   	leave  
80104be7:	c3                   	ret    

80104be8 <stosb>:
80104be8:	55                   	push   %ebp
80104be9:	89 e5                	mov    %esp,%ebp
80104beb:	57                   	push   %edi
80104bec:	53                   	push   %ebx
80104bed:	8b 4d 08             	mov    0x8(%ebp),%ecx
80104bf0:	8b 55 10             	mov    0x10(%ebp),%edx
80104bf3:	8b 45 0c             	mov    0xc(%ebp),%eax
80104bf6:	89 cb                	mov    %ecx,%ebx
80104bf8:	89 df                	mov    %ebx,%edi
80104bfa:	89 d1                	mov    %edx,%ecx
80104bfc:	fc                   	cld    
80104bfd:	f3 aa                	rep stos %al,%es:(%edi)
80104bff:	89 ca                	mov    %ecx,%edx
80104c01:	89 fb                	mov    %edi,%ebx
80104c03:	89 5d 08             	mov    %ebx,0x8(%ebp)
80104c06:	89 55 10             	mov    %edx,0x10(%ebp)
80104c09:	90                   	nop
80104c0a:	5b                   	pop    %ebx
80104c0b:	5f                   	pop    %edi
80104c0c:	5d                   	pop    %ebp
80104c0d:	c3                   	ret    

80104c0e <stosl>:
80104c0e:	55                   	push   %ebp
80104c0f:	89 e5                	mov    %esp,%ebp
80104c11:	57                   	push   %edi
80104c12:	53                   	push   %ebx
80104c13:	8b 4d 08             	mov    0x8(%ebp),%ecx
80104c16:	8b 55 10             	mov    0x10(%ebp),%edx
80104c19:	8b 45 0c             	mov    0xc(%ebp),%eax
80104c1c:	89 cb                	mov    %ecx,%ebx
80104c1e:	89 df                	mov    %ebx,%edi
80104c20:	89 d1                	mov    %edx,%ecx
80104c22:	fc                   	cld    
80104c23:	f3 ab                	rep stos %eax,%es:(%edi)
80104c25:	89 ca                	mov    %ecx,%edx
80104c27:	89 fb                	mov    %edi,%ebx
80104c29:	89 5d 08             	mov    %ebx,0x8(%ebp)
80104c2c:	89 55 10             	mov    %edx,0x10(%ebp)
80104c2f:	90                   	nop
80104c30:	5b                   	pop    %ebx
80104c31:	5f                   	pop    %edi
80104c32:	5d                   	pop    %ebp
80104c33:	c3                   	ret    

80104c34 <memset>:
80104c34:	55                   	push   %ebp
80104c35:	89 e5                	mov    %esp,%ebp
80104c37:	8b 45 08             	mov    0x8(%ebp),%eax
80104c3a:	83 e0 03             	and    $0x3,%eax
80104c3d:	85 c0                	test   %eax,%eax
80104c3f:	75 43                	jne    80104c84 <memset+0x50>
80104c41:	8b 45 10             	mov    0x10(%ebp),%eax
80104c44:	83 e0 03             	and    $0x3,%eax
80104c47:	85 c0                	test   %eax,%eax
80104c49:	75 39                	jne    80104c84 <memset+0x50>
80104c4b:	81 65 0c ff 00 00 00 	andl   $0xff,0xc(%ebp)
80104c52:	8b 45 10             	mov    0x10(%ebp),%eax
80104c55:	c1 e8 02             	shr    $0x2,%eax
80104c58:	89 c2                	mov    %eax,%edx
80104c5a:	8b 45 0c             	mov    0xc(%ebp),%eax
80104c5d:	c1 e0 18             	shl    $0x18,%eax
80104c60:	89 c1                	mov    %eax,%ecx
80104c62:	8b 45 0c             	mov    0xc(%ebp),%eax
80104c65:	c1 e0 10             	shl    $0x10,%eax
80104c68:	09 c1                	or     %eax,%ecx
80104c6a:	8b 45 0c             	mov    0xc(%ebp),%eax
80104c6d:	c1 e0 08             	shl    $0x8,%eax
80104c70:	09 c8                	or     %ecx,%eax
80104c72:	0b 45 0c             	or     0xc(%ebp),%eax
80104c75:	52                   	push   %edx
80104c76:	50                   	push   %eax
80104c77:	ff 75 08             	push   0x8(%ebp)
80104c7a:	e8 8f ff ff ff       	call   80104c0e <stosl>
80104c7f:	83 c4 0c             	add    $0xc,%esp
80104c82:	eb 12                	jmp    80104c96 <memset+0x62>
80104c84:	8b 45 10             	mov    0x10(%ebp),%eax
80104c87:	50                   	push   %eax
80104c88:	ff 75 0c             	push   0xc(%ebp)
80104c8b:	ff 75 08             	push   0x8(%ebp)
80104c8e:	e8 55 ff ff ff       	call   80104be8 <stosb>
80104c93:	83 c4 0c             	add    $0xc,%esp
80104c96:	8b 45 08             	mov    0x8(%ebp),%eax
80104c99:	c9                   	leave  
80104c9a:	c3                   	ret    

80104c9b <memcmp>:
80104c9b:	55                   	push   %ebp
80104c9c:	89 e5                	mov    %esp,%ebp
80104c9e:	83 ec 10             	sub    $0x10,%esp
80104ca1:	8b 45 08             	mov    0x8(%ebp),%eax
80104ca4:	89 45 fc             	mov    %eax,-0x4(%ebp)
80104ca7:	8b 45 0c             	mov    0xc(%ebp),%eax
80104caa:	89 45 f8             	mov    %eax,-0x8(%ebp)
80104cad:	eb 30                	jmp    80104cdf <memcmp+0x44>
80104caf:	8b 45 fc             	mov    -0x4(%ebp),%eax
80104cb2:	0f b6 10             	movzbl (%eax),%edx
80104cb5:	8b 45 f8             	mov    -0x8(%ebp),%eax
80104cb8:	0f b6 00             	movzbl (%eax),%eax
80104cbb:	38 c2                	cmp    %al,%dl
80104cbd:	74 18                	je     80104cd7 <memcmp+0x3c>
80104cbf:	8b 45 fc             	mov    -0x4(%ebp),%eax
80104cc2:	0f b6 00             	movzbl (%eax),%eax
80104cc5:	0f b6 d0             	movzbl %al,%edx
80104cc8:	8b 45 f8             	mov    -0x8(%ebp),%eax
80104ccb:	0f b6 00             	movzbl (%eax),%eax
80104cce:	0f b6 c8             	movzbl %al,%ecx
80104cd1:	89 d0                	mov    %edx,%eax
80104cd3:	29 c8                	sub    %ecx,%eax
80104cd5:	eb 1a                	jmp    80104cf1 <memcmp+0x56>
80104cd7:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
80104cdb:	83 45 f8 01          	addl   $0x1,-0x8(%ebp)
80104cdf:	8b 45 10             	mov    0x10(%ebp),%eax
80104ce2:	8d 50 ff             	lea    -0x1(%eax),%edx
80104ce5:	89 55 10             	mov    %edx,0x10(%ebp)
80104ce8:	85 c0                	test   %eax,%eax
80104cea:	75 c3                	jne    80104caf <memcmp+0x14>
80104cec:	b8 00 00 00 00       	mov    $0x0,%eax
80104cf1:	c9                   	leave  
80104cf2:	c3                   	ret    

80104cf3 <memmove>:
80104cf3:	55                   	push   %ebp
80104cf4:	89 e5                	mov    %esp,%ebp
80104cf6:	83 ec 10             	sub    $0x10,%esp
80104cf9:	8b 45 0c             	mov    0xc(%ebp),%eax
80104cfc:	89 45 fc             	mov    %eax,-0x4(%ebp)
80104cff:	8b 45 08             	mov    0x8(%ebp),%eax
80104d02:	89 45 f8             	mov    %eax,-0x8(%ebp)
80104d05:	8b 45 fc             	mov    -0x4(%ebp),%eax
80104d08:	3b 45 f8             	cmp    -0x8(%ebp),%eax
80104d0b:	73 54                	jae    80104d61 <memmove+0x6e>
80104d0d:	8b 55 fc             	mov    -0x4(%ebp),%edx
80104d10:	8b 45 10             	mov    0x10(%ebp),%eax
80104d13:	01 d0                	add    %edx,%eax
80104d15:	39 45 f8             	cmp    %eax,-0x8(%ebp)
80104d18:	73 47                	jae    80104d61 <memmove+0x6e>
80104d1a:	8b 45 10             	mov    0x10(%ebp),%eax
80104d1d:	01 45 fc             	add    %eax,-0x4(%ebp)
80104d20:	8b 45 10             	mov    0x10(%ebp),%eax
80104d23:	01 45 f8             	add    %eax,-0x8(%ebp)
80104d26:	eb 13                	jmp    80104d3b <memmove+0x48>
80104d28:	83 6d fc 01          	subl   $0x1,-0x4(%ebp)
80104d2c:	83 6d f8 01          	subl   $0x1,-0x8(%ebp)
80104d30:	8b 45 fc             	mov    -0x4(%ebp),%eax
80104d33:	0f b6 10             	movzbl (%eax),%edx
80104d36:	8b 45 f8             	mov    -0x8(%ebp),%eax
80104d39:	88 10                	mov    %dl,(%eax)
80104d3b:	8b 45 10             	mov    0x10(%ebp),%eax
80104d3e:	8d 50 ff             	lea    -0x1(%eax),%edx
80104d41:	89 55 10             	mov    %edx,0x10(%ebp)
80104d44:	85 c0                	test   %eax,%eax
80104d46:	75 e0                	jne    80104d28 <memmove+0x35>
80104d48:	eb 24                	jmp    80104d6e <memmove+0x7b>
80104d4a:	8b 55 fc             	mov    -0x4(%ebp),%edx
80104d4d:	8d 42 01             	lea    0x1(%edx),%eax
80104d50:	89 45 fc             	mov    %eax,-0x4(%ebp)
80104d53:	8b 45 f8             	mov    -0x8(%ebp),%eax
80104d56:	8d 48 01             	lea    0x1(%eax),%ecx
80104d59:	89 4d f8             	mov    %ecx,-0x8(%ebp)
80104d5c:	0f b6 12             	movzbl (%edx),%edx
80104d5f:	88 10                	mov    %dl,(%eax)
80104d61:	8b 45 10             	mov    0x10(%ebp),%eax
80104d64:	8d 50 ff             	lea    -0x1(%eax),%edx
80104d67:	89 55 10             	mov    %edx,0x10(%ebp)
80104d6a:	85 c0                	test   %eax,%eax
80104d6c:	75 dc                	jne    80104d4a <memmove+0x57>
80104d6e:	8b 45 08             	mov    0x8(%ebp),%eax
80104d71:	c9                   	leave  
80104d72:	c3                   	ret    

80104d73 <memcpy>:
80104d73:	55                   	push   %ebp
80104d74:	89 e5                	mov    %esp,%ebp
80104d76:	ff 75 10             	push   0x10(%ebp)
80104d79:	ff 75 0c             	push   0xc(%ebp)
80104d7c:	ff 75 08             	push   0x8(%ebp)
80104d7f:	e8 6f ff ff ff       	call   80104cf3 <memmove>
80104d84:	83 c4 0c             	add    $0xc,%esp
80104d87:	c9                   	leave  
80104d88:	c3                   	ret    

80104d89 <strncmp>:
80104d89:	55                   	push   %ebp
80104d8a:	89 e5                	mov    %esp,%ebp
80104d8c:	eb 0c                	jmp    80104d9a <strncmp+0x11>
80104d8e:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
80104d92:	83 45 08 01          	addl   $0x1,0x8(%ebp)
80104d96:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
80104d9a:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
80104d9e:	74 1a                	je     80104dba <strncmp+0x31>
80104da0:	8b 45 08             	mov    0x8(%ebp),%eax
80104da3:	0f b6 00             	movzbl (%eax),%eax
80104da6:	84 c0                	test   %al,%al
80104da8:	74 10                	je     80104dba <strncmp+0x31>
80104daa:	8b 45 08             	mov    0x8(%ebp),%eax
80104dad:	0f b6 10             	movzbl (%eax),%edx
80104db0:	8b 45 0c             	mov    0xc(%ebp),%eax
80104db3:	0f b6 00             	movzbl (%eax),%eax
80104db6:	38 c2                	cmp    %al,%dl
80104db8:	74 d4                	je     80104d8e <strncmp+0x5>
80104dba:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
80104dbe:	75 07                	jne    80104dc7 <strncmp+0x3e>
80104dc0:	b8 00 00 00 00       	mov    $0x0,%eax
80104dc5:	eb 16                	jmp    80104ddd <strncmp+0x54>
80104dc7:	8b 45 08             	mov    0x8(%ebp),%eax
80104dca:	0f b6 00             	movzbl (%eax),%eax
80104dcd:	0f b6 d0             	movzbl %al,%edx
80104dd0:	8b 45 0c             	mov    0xc(%ebp),%eax
80104dd3:	0f b6 00             	movzbl (%eax),%eax
80104dd6:	0f b6 c8             	movzbl %al,%ecx
80104dd9:	89 d0                	mov    %edx,%eax
80104ddb:	29 c8                	sub    %ecx,%eax
80104ddd:	5d                   	pop    %ebp
80104dde:	c3                   	ret    

80104ddf <strncpy>:
80104ddf:	55                   	push   %ebp
80104de0:	89 e5                	mov    %esp,%ebp
80104de2:	83 ec 10             	sub    $0x10,%esp
80104de5:	8b 45 08             	mov    0x8(%ebp),%eax
80104de8:	89 45 fc             	mov    %eax,-0x4(%ebp)
80104deb:	90                   	nop
80104dec:	8b 45 10             	mov    0x10(%ebp),%eax
80104def:	8d 50 ff             	lea    -0x1(%eax),%edx
80104df2:	89 55 10             	mov    %edx,0x10(%ebp)
80104df5:	85 c0                	test   %eax,%eax
80104df7:	7e 2c                	jle    80104e25 <strncpy+0x46>
80104df9:	8b 55 0c             	mov    0xc(%ebp),%edx
80104dfc:	8d 42 01             	lea    0x1(%edx),%eax
80104dff:	89 45 0c             	mov    %eax,0xc(%ebp)
80104e02:	8b 45 08             	mov    0x8(%ebp),%eax
80104e05:	8d 48 01             	lea    0x1(%eax),%ecx
80104e08:	89 4d 08             	mov    %ecx,0x8(%ebp)
80104e0b:	0f b6 12             	movzbl (%edx),%edx
80104e0e:	88 10                	mov    %dl,(%eax)
80104e10:	0f b6 00             	movzbl (%eax),%eax
80104e13:	84 c0                	test   %al,%al
80104e15:	75 d5                	jne    80104dec <strncpy+0xd>
80104e17:	eb 0c                	jmp    80104e25 <strncpy+0x46>
80104e19:	8b 45 08             	mov    0x8(%ebp),%eax
80104e1c:	8d 50 01             	lea    0x1(%eax),%edx
80104e1f:	89 55 08             	mov    %edx,0x8(%ebp)
80104e22:	c6 00 00             	movb   $0x0,(%eax)
80104e25:	8b 45 10             	mov    0x10(%ebp),%eax
80104e28:	8d 50 ff             	lea    -0x1(%eax),%edx
80104e2b:	89 55 10             	mov    %edx,0x10(%ebp)
80104e2e:	85 c0                	test   %eax,%eax
80104e30:	7f e7                	jg     80104e19 <strncpy+0x3a>
80104e32:	8b 45 fc             	mov    -0x4(%ebp),%eax
80104e35:	c9                   	leave  
80104e36:	c3                   	ret    

80104e37 <safestrcpy>:
80104e37:	55                   	push   %ebp
80104e38:	89 e5                	mov    %esp,%ebp
80104e3a:	83 ec 10             	sub    $0x10,%esp
80104e3d:	8b 45 08             	mov    0x8(%ebp),%eax
80104e40:	89 45 fc             	mov    %eax,-0x4(%ebp)
80104e43:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
80104e47:	7f 05                	jg     80104e4e <safestrcpy+0x17>
80104e49:	8b 45 fc             	mov    -0x4(%ebp),%eax
80104e4c:	eb 32                	jmp    80104e80 <safestrcpy+0x49>
80104e4e:	90                   	nop
80104e4f:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
80104e53:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
80104e57:	7e 1e                	jle    80104e77 <safestrcpy+0x40>
80104e59:	8b 55 0c             	mov    0xc(%ebp),%edx
80104e5c:	8d 42 01             	lea    0x1(%edx),%eax
80104e5f:	89 45 0c             	mov    %eax,0xc(%ebp)
80104e62:	8b 45 08             	mov    0x8(%ebp),%eax
80104e65:	8d 48 01             	lea    0x1(%eax),%ecx
80104e68:	89 4d 08             	mov    %ecx,0x8(%ebp)
80104e6b:	0f b6 12             	movzbl (%edx),%edx
80104e6e:	88 10                	mov    %dl,(%eax)
80104e70:	0f b6 00             	movzbl (%eax),%eax
80104e73:	84 c0                	test   %al,%al
80104e75:	75 d8                	jne    80104e4f <safestrcpy+0x18>
80104e77:	8b 45 08             	mov    0x8(%ebp),%eax
80104e7a:	c6 00 00             	movb   $0x0,(%eax)
80104e7d:	8b 45 fc             	mov    -0x4(%ebp),%eax
80104e80:	c9                   	leave  
80104e81:	c3                   	ret    

80104e82 <strlen>:
80104e82:	55                   	push   %ebp
80104e83:	89 e5                	mov    %esp,%ebp
80104e85:	83 ec 10             	sub    $0x10,%esp
80104e88:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
80104e8f:	eb 04                	jmp    80104e95 <strlen+0x13>
80104e91:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
80104e95:	8b 55 fc             	mov    -0x4(%ebp),%edx
80104e98:	8b 45 08             	mov    0x8(%ebp),%eax
80104e9b:	01 d0                	add    %edx,%eax
80104e9d:	0f b6 00             	movzbl (%eax),%eax
80104ea0:	84 c0                	test   %al,%al
80104ea2:	75 ed                	jne    80104e91 <strlen+0xf>
80104ea4:	8b 45 fc             	mov    -0x4(%ebp),%eax
80104ea7:	c9                   	leave  
80104ea8:	c3                   	ret    

80104ea9 <swtch>:
80104ea9:	8b 44 24 04          	mov    0x4(%esp),%eax
80104ead:	8b 54 24 08          	mov    0x8(%esp),%edx
80104eb1:	55                   	push   %ebp
80104eb2:	53                   	push   %ebx
80104eb3:	56                   	push   %esi
80104eb4:	57                   	push   %edi
80104eb5:	89 20                	mov    %esp,(%eax)
80104eb7:	89 d4                	mov    %edx,%esp
80104eb9:	5f                   	pop    %edi
80104eba:	5e                   	pop    %esi
80104ebb:	5b                   	pop    %ebx
80104ebc:	5d                   	pop    %ebp
80104ebd:	c3                   	ret    

80104ebe <fetchint>:
// to a saved program counter, and then the first argument.

// Fetch the int at addr from the current process.
int
fetchint(uint addr, int *ip)
{
80104ebe:	55                   	push   %ebp
80104ebf:	89 e5                	mov    %esp,%ebp
80104ec1:	83 ec 18             	sub    $0x18,%esp
  struct proc *curproc = myproc();
80104ec4:	e8 67 eb ff ff       	call   80103a30 <myproc>
80104ec9:	89 45 f4             	mov    %eax,-0xc(%ebp)

  if(addr >= curproc->sz || addr+4 > curproc->sz)
80104ecc:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104ecf:	8b 00                	mov    (%eax),%eax
80104ed1:	39 45 08             	cmp    %eax,0x8(%ebp)
80104ed4:	73 0f                	jae    80104ee5 <fetchint+0x27>
80104ed6:	8b 45 08             	mov    0x8(%ebp),%eax
80104ed9:	8d 50 04             	lea    0x4(%eax),%edx
80104edc:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104edf:	8b 00                	mov    (%eax),%eax
80104ee1:	39 c2                	cmp    %eax,%edx
80104ee3:	76 07                	jbe    80104eec <fetchint+0x2e>
    return -1;
80104ee5:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104eea:	eb 0f                	jmp    80104efb <fetchint+0x3d>
  *ip = *(int*)(addr);
80104eec:	8b 45 08             	mov    0x8(%ebp),%eax
80104eef:	8b 10                	mov    (%eax),%edx
80104ef1:	8b 45 0c             	mov    0xc(%ebp),%eax
80104ef4:	89 10                	mov    %edx,(%eax)
  return 0;
80104ef6:	b8 00 00 00 00       	mov    $0x0,%eax
}
80104efb:	c9                   	leave  
80104efc:	c3                   	ret    

80104efd <fetchstr>:
// Fetch the nul-terminated string at addr from the current process.
// Doesn't actually copy the string - just sets *pp to point at it.
// Returns length of string, not including nul.
int
fetchstr(uint addr, char **pp)
{
80104efd:	55                   	push   %ebp
80104efe:	89 e5                	mov    %esp,%ebp
80104f00:	83 ec 18             	sub    $0x18,%esp
  char *s, *ep;
  struct proc *curproc = myproc();
80104f03:	e8 28 eb ff ff       	call   80103a30 <myproc>
80104f08:	89 45 f0             	mov    %eax,-0x10(%ebp)

  if(addr >= curproc->sz)
80104f0b:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104f0e:	8b 00                	mov    (%eax),%eax
80104f10:	39 45 08             	cmp    %eax,0x8(%ebp)
80104f13:	72 07                	jb     80104f1c <fetchstr+0x1f>
    return -1;
80104f15:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104f1a:	eb 41                	jmp    80104f5d <fetchstr+0x60>
  *pp = (char*)addr;
80104f1c:	8b 55 08             	mov    0x8(%ebp),%edx
80104f1f:	8b 45 0c             	mov    0xc(%ebp),%eax
80104f22:	89 10                	mov    %edx,(%eax)
  ep = (char*)curproc->sz;
80104f24:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104f27:	8b 00                	mov    (%eax),%eax
80104f29:	89 45 ec             	mov    %eax,-0x14(%ebp)
  for(s = *pp; s < ep; s++){
80104f2c:	8b 45 0c             	mov    0xc(%ebp),%eax
80104f2f:	8b 00                	mov    (%eax),%eax
80104f31:	89 45 f4             	mov    %eax,-0xc(%ebp)
80104f34:	eb 1a                	jmp    80104f50 <fetchstr+0x53>
    if(*s == 0)
80104f36:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104f39:	0f b6 00             	movzbl (%eax),%eax
80104f3c:	84 c0                	test   %al,%al
80104f3e:	75 0c                	jne    80104f4c <fetchstr+0x4f>
      return s - *pp;
80104f40:	8b 45 0c             	mov    0xc(%ebp),%eax
80104f43:	8b 10                	mov    (%eax),%edx
80104f45:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104f48:	29 d0                	sub    %edx,%eax
80104f4a:	eb 11                	jmp    80104f5d <fetchstr+0x60>
  for(s = *pp; s < ep; s++){
80104f4c:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80104f50:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104f53:	3b 45 ec             	cmp    -0x14(%ebp),%eax
80104f56:	72 de                	jb     80104f36 <fetchstr+0x39>
  }
  return -1;
80104f58:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104f5d:	c9                   	leave  
80104f5e:	c3                   	ret    

80104f5f <argint>:

// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
80104f5f:	55                   	push   %ebp
80104f60:	89 e5                	mov    %esp,%ebp
80104f62:	83 ec 08             	sub    $0x8,%esp
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80104f65:	e8 c6 ea ff ff       	call   80103a30 <myproc>
80104f6a:	8b 40 18             	mov    0x18(%eax),%eax
80104f6d:	8b 50 44             	mov    0x44(%eax),%edx
80104f70:	8b 45 08             	mov    0x8(%ebp),%eax
80104f73:	c1 e0 02             	shl    $0x2,%eax
80104f76:	01 d0                	add    %edx,%eax
80104f78:	83 c0 04             	add    $0x4,%eax
80104f7b:	83 ec 08             	sub    $0x8,%esp
80104f7e:	ff 75 0c             	push   0xc(%ebp)
80104f81:	50                   	push   %eax
80104f82:	e8 37 ff ff ff       	call   80104ebe <fetchint>
80104f87:	83 c4 10             	add    $0x10,%esp
}
80104f8a:	c9                   	leave  
80104f8b:	c3                   	ret    

80104f8c <argptr>:
// Fetch the nth word-sized system call argument as a pointer
// to a block of memory of size bytes.  Check that the pointer
// lies within the process address space.
int
argptr(int n, char **pp, int size)
{
80104f8c:	55                   	push   %ebp
80104f8d:	89 e5                	mov    %esp,%ebp
80104f8f:	83 ec 18             	sub    $0x18,%esp
  int i;
  struct proc *curproc = myproc();
80104f92:	e8 99 ea ff ff       	call   80103a30 <myproc>
80104f97:	89 45 f4             	mov    %eax,-0xc(%ebp)
 
  if(argint(n, &i) < 0)
80104f9a:	83 ec 08             	sub    $0x8,%esp
80104f9d:	8d 45 f0             	lea    -0x10(%ebp),%eax
80104fa0:	50                   	push   %eax
80104fa1:	ff 75 08             	push   0x8(%ebp)
80104fa4:	e8 b6 ff ff ff       	call   80104f5f <argint>
80104fa9:	83 c4 10             	add    $0x10,%esp
80104fac:	85 c0                	test   %eax,%eax
80104fae:	79 07                	jns    80104fb7 <argptr+0x2b>
    return -1;
80104fb0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104fb5:	eb 3b                	jmp    80104ff2 <argptr+0x66>
  if(size < 0 || (uint)i >= curproc->sz || (uint)i+size > curproc->sz)
80104fb7:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
80104fbb:	78 1f                	js     80104fdc <argptr+0x50>
80104fbd:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104fc0:	8b 00                	mov    (%eax),%eax
80104fc2:	8b 55 f0             	mov    -0x10(%ebp),%edx
80104fc5:	39 d0                	cmp    %edx,%eax
80104fc7:	76 13                	jbe    80104fdc <argptr+0x50>
80104fc9:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104fcc:	89 c2                	mov    %eax,%edx
80104fce:	8b 45 10             	mov    0x10(%ebp),%eax
80104fd1:	01 c2                	add    %eax,%edx
80104fd3:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104fd6:	8b 00                	mov    (%eax),%eax
80104fd8:	39 c2                	cmp    %eax,%edx
80104fda:	76 07                	jbe    80104fe3 <argptr+0x57>
    return -1;
80104fdc:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104fe1:	eb 0f                	jmp    80104ff2 <argptr+0x66>
  *pp = (char*)i;
80104fe3:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104fe6:	89 c2                	mov    %eax,%edx
80104fe8:	8b 45 0c             	mov    0xc(%ebp),%eax
80104feb:	89 10                	mov    %edx,(%eax)
  return 0;
80104fed:	b8 00 00 00 00       	mov    $0x0,%eax
}
80104ff2:	c9                   	leave  
80104ff3:	c3                   	ret    

80104ff4 <argstr>:
// Check that the pointer is valid and the string is nul-terminated.
// (There is no shared writable memory, so the string can't change
// between this check and being used by the kernel.)
int
argstr(int n, char **pp)
{
80104ff4:	55                   	push   %ebp
80104ff5:	89 e5                	mov    %esp,%ebp
80104ff7:	83 ec 18             	sub    $0x18,%esp
  int addr;
  if(argint(n, &addr) < 0)
80104ffa:	83 ec 08             	sub    $0x8,%esp
80104ffd:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105000:	50                   	push   %eax
80105001:	ff 75 08             	push   0x8(%ebp)
80105004:	e8 56 ff ff ff       	call   80104f5f <argint>
80105009:	83 c4 10             	add    $0x10,%esp
8010500c:	85 c0                	test   %eax,%eax
8010500e:	79 07                	jns    80105017 <argstr+0x23>
    return -1;
80105010:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105015:	eb 12                	jmp    80105029 <argstr+0x35>
  return fetchstr(addr, pp);
80105017:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010501a:	83 ec 08             	sub    $0x8,%esp
8010501d:	ff 75 0c             	push   0xc(%ebp)
80105020:	50                   	push   %eax
80105021:	e8 d7 fe ff ff       	call   80104efd <fetchstr>
80105026:	83 c4 10             	add    $0x10,%esp
}
80105029:	c9                   	leave  
8010502a:	c3                   	ret    

8010502b <syscall>:
[SYS_uthread_init]   sys_uthread_init,
};

void
syscall(void)
{
8010502b:	55                   	push   %ebp
8010502c:	89 e5                	mov    %esp,%ebp
8010502e:	83 ec 18             	sub    $0x18,%esp
  int num;
  struct proc *curproc = myproc();
80105031:	e8 fa e9 ff ff       	call   80103a30 <myproc>
80105036:	89 45 f4             	mov    %eax,-0xc(%ebp)

  num = curproc->tf->eax;
80105039:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010503c:	8b 40 18             	mov    0x18(%eax),%eax
8010503f:	8b 40 1c             	mov    0x1c(%eax),%eax
80105042:	89 45 f0             	mov    %eax,-0x10(%ebp)
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
80105045:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80105049:	7e 2f                	jle    8010507a <syscall+0x4f>
8010504b:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010504e:	83 f8 18             	cmp    $0x18,%eax
80105051:	77 27                	ja     8010507a <syscall+0x4f>
80105053:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105056:	8b 04 85 20 f0 10 80 	mov    -0x7fef0fe0(,%eax,4),%eax
8010505d:	85 c0                	test   %eax,%eax
8010505f:	74 19                	je     8010507a <syscall+0x4f>
    curproc->tf->eax = syscalls[num]();
80105061:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105064:	8b 04 85 20 f0 10 80 	mov    -0x7fef0fe0(,%eax,4),%eax
8010506b:	ff d0                	call   *%eax
8010506d:	89 c2                	mov    %eax,%edx
8010506f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105072:	8b 40 18             	mov    0x18(%eax),%eax
80105075:	89 50 1c             	mov    %edx,0x1c(%eax)
80105078:	eb 2c                	jmp    801050a6 <syscall+0x7b>
  } else {
    cprintf("%d %s: unknown sys call %d\n",
            curproc->pid, curproc->name, num);
8010507a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010507d:	8d 50 6c             	lea    0x6c(%eax),%edx
    cprintf("%d %s: unknown sys call %d\n",
80105080:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105083:	8b 40 10             	mov    0x10(%eax),%eax
80105086:	ff 75 f0             	push   -0x10(%ebp)
80105089:	52                   	push   %edx
8010508a:	50                   	push   %eax
8010508b:	68 ce a6 10 80       	push   $0x8010a6ce
80105090:	e8 5f b3 ff ff       	call   801003f4 <cprintf>
80105095:	83 c4 10             	add    $0x10,%esp
    curproc->tf->eax = -1;
80105098:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010509b:	8b 40 18             	mov    0x18(%eax),%eax
8010509e:	c7 40 1c ff ff ff ff 	movl   $0xffffffff,0x1c(%eax)
  }
}
801050a5:	90                   	nop
801050a6:	90                   	nop
801050a7:	c9                   	leave  
801050a8:	c3                   	ret    

801050a9 <argfd>:

// Fetch the nth word-sized system call argument as a file descriptor
// and return both the descriptor and the corresponding struct file.
static int
argfd(int n, int *pfd, struct file **pf)
{
801050a9:	55                   	push   %ebp
801050aa:	89 e5                	mov    %esp,%ebp
801050ac:	83 ec 18             	sub    $0x18,%esp
  int fd;
  struct file *f;

  if(argint(n, &fd) < 0)
801050af:	83 ec 08             	sub    $0x8,%esp
801050b2:	8d 45 f0             	lea    -0x10(%ebp),%eax
801050b5:	50                   	push   %eax
801050b6:	ff 75 08             	push   0x8(%ebp)
801050b9:	e8 a1 fe ff ff       	call   80104f5f <argint>
801050be:	83 c4 10             	add    $0x10,%esp
801050c1:	85 c0                	test   %eax,%eax
801050c3:	79 07                	jns    801050cc <argfd+0x23>
    return -1;
801050c5:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801050ca:	eb 4f                	jmp    8010511b <argfd+0x72>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
801050cc:	8b 45 f0             	mov    -0x10(%ebp),%eax
801050cf:	85 c0                	test   %eax,%eax
801050d1:	78 20                	js     801050f3 <argfd+0x4a>
801050d3:	8b 45 f0             	mov    -0x10(%ebp),%eax
801050d6:	83 f8 0f             	cmp    $0xf,%eax
801050d9:	7f 18                	jg     801050f3 <argfd+0x4a>
801050db:	e8 50 e9 ff ff       	call   80103a30 <myproc>
801050e0:	8b 55 f0             	mov    -0x10(%ebp),%edx
801050e3:	83 c2 08             	add    $0x8,%edx
801050e6:	8b 44 90 08          	mov    0x8(%eax,%edx,4),%eax
801050ea:	89 45 f4             	mov    %eax,-0xc(%ebp)
801050ed:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801050f1:	75 07                	jne    801050fa <argfd+0x51>
    return -1;
801050f3:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801050f8:	eb 21                	jmp    8010511b <argfd+0x72>
  if(pfd)
801050fa:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
801050fe:	74 08                	je     80105108 <argfd+0x5f>
    *pfd = fd;
80105100:	8b 55 f0             	mov    -0x10(%ebp),%edx
80105103:	8b 45 0c             	mov    0xc(%ebp),%eax
80105106:	89 10                	mov    %edx,(%eax)
  if(pf)
80105108:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
8010510c:	74 08                	je     80105116 <argfd+0x6d>
    *pf = f;
8010510e:	8b 45 10             	mov    0x10(%ebp),%eax
80105111:	8b 55 f4             	mov    -0xc(%ebp),%edx
80105114:	89 10                	mov    %edx,(%eax)
  return 0;
80105116:	b8 00 00 00 00       	mov    $0x0,%eax
}
8010511b:	c9                   	leave  
8010511c:	c3                   	ret    

8010511d <fdalloc>:

// Allocate a file descriptor for the given file.
// Takes over file reference from caller on success.
static int
fdalloc(struct file *f)
{
8010511d:	55                   	push   %ebp
8010511e:	89 e5                	mov    %esp,%ebp
80105120:	83 ec 18             	sub    $0x18,%esp
  int fd;
  struct proc *curproc = myproc();
80105123:	e8 08 e9 ff ff       	call   80103a30 <myproc>
80105128:	89 45 f0             	mov    %eax,-0x10(%ebp)

  for(fd = 0; fd < NOFILE; fd++){
8010512b:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80105132:	eb 2a                	jmp    8010515e <fdalloc+0x41>
    if(curproc->ofile[fd] == 0){
80105134:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105137:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010513a:	83 c2 08             	add    $0x8,%edx
8010513d:	8b 44 90 08          	mov    0x8(%eax,%edx,4),%eax
80105141:	85 c0                	test   %eax,%eax
80105143:	75 15                	jne    8010515a <fdalloc+0x3d>
      curproc->ofile[fd] = f;
80105145:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105148:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010514b:	8d 4a 08             	lea    0x8(%edx),%ecx
8010514e:	8b 55 08             	mov    0x8(%ebp),%edx
80105151:	89 54 88 08          	mov    %edx,0x8(%eax,%ecx,4)
      return fd;
80105155:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105158:	eb 0f                	jmp    80105169 <fdalloc+0x4c>
  for(fd = 0; fd < NOFILE; fd++){
8010515a:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
8010515e:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
80105162:	7e d0                	jle    80105134 <fdalloc+0x17>
    }
  }
  return -1;
80105164:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105169:	c9                   	leave  
8010516a:	c3                   	ret    

8010516b <sys_dup>:

int
sys_dup(void)
{
8010516b:	55                   	push   %ebp
8010516c:	89 e5                	mov    %esp,%ebp
8010516e:	83 ec 18             	sub    $0x18,%esp
  struct file *f;
  int fd;

  if(argfd(0, 0, &f) < 0)
80105171:	83 ec 04             	sub    $0x4,%esp
80105174:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105177:	50                   	push   %eax
80105178:	6a 00                	push   $0x0
8010517a:	6a 00                	push   $0x0
8010517c:	e8 28 ff ff ff       	call   801050a9 <argfd>
80105181:	83 c4 10             	add    $0x10,%esp
80105184:	85 c0                	test   %eax,%eax
80105186:	79 07                	jns    8010518f <sys_dup+0x24>
    return -1;
80105188:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010518d:	eb 31                	jmp    801051c0 <sys_dup+0x55>
  if((fd=fdalloc(f)) < 0)
8010518f:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105192:	83 ec 0c             	sub    $0xc,%esp
80105195:	50                   	push   %eax
80105196:	e8 82 ff ff ff       	call   8010511d <fdalloc>
8010519b:	83 c4 10             	add    $0x10,%esp
8010519e:	89 45 f4             	mov    %eax,-0xc(%ebp)
801051a1:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801051a5:	79 07                	jns    801051ae <sys_dup+0x43>
    return -1;
801051a7:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801051ac:	eb 12                	jmp    801051c0 <sys_dup+0x55>
  filedup(f);
801051ae:	8b 45 f0             	mov    -0x10(%ebp),%eax
801051b1:	83 ec 0c             	sub    $0xc,%esp
801051b4:	50                   	push   %eax
801051b5:	e8 90 be ff ff       	call   8010104a <filedup>
801051ba:	83 c4 10             	add    $0x10,%esp
  return fd;
801051bd:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
801051c0:	c9                   	leave  
801051c1:	c3                   	ret    

801051c2 <sys_read>:

int
sys_read(void)
{
801051c2:	55                   	push   %ebp
801051c3:	89 e5                	mov    %esp,%ebp
801051c5:	83 ec 18             	sub    $0x18,%esp
  struct file *f;
  int n;
  char *p;

  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
801051c8:	83 ec 04             	sub    $0x4,%esp
801051cb:	8d 45 f4             	lea    -0xc(%ebp),%eax
801051ce:	50                   	push   %eax
801051cf:	6a 00                	push   $0x0
801051d1:	6a 00                	push   $0x0
801051d3:	e8 d1 fe ff ff       	call   801050a9 <argfd>
801051d8:	83 c4 10             	add    $0x10,%esp
801051db:	85 c0                	test   %eax,%eax
801051dd:	78 2e                	js     8010520d <sys_read+0x4b>
801051df:	83 ec 08             	sub    $0x8,%esp
801051e2:	8d 45 f0             	lea    -0x10(%ebp),%eax
801051e5:	50                   	push   %eax
801051e6:	6a 02                	push   $0x2
801051e8:	e8 72 fd ff ff       	call   80104f5f <argint>
801051ed:	83 c4 10             	add    $0x10,%esp
801051f0:	85 c0                	test   %eax,%eax
801051f2:	78 19                	js     8010520d <sys_read+0x4b>
801051f4:	8b 45 f0             	mov    -0x10(%ebp),%eax
801051f7:	83 ec 04             	sub    $0x4,%esp
801051fa:	50                   	push   %eax
801051fb:	8d 45 ec             	lea    -0x14(%ebp),%eax
801051fe:	50                   	push   %eax
801051ff:	6a 01                	push   $0x1
80105201:	e8 86 fd ff ff       	call   80104f8c <argptr>
80105206:	83 c4 10             	add    $0x10,%esp
80105209:	85 c0                	test   %eax,%eax
8010520b:	79 07                	jns    80105214 <sys_read+0x52>
    return -1;
8010520d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105212:	eb 17                	jmp    8010522b <sys_read+0x69>
  return fileread(f, p, n);
80105214:	8b 4d f0             	mov    -0x10(%ebp),%ecx
80105217:	8b 55 ec             	mov    -0x14(%ebp),%edx
8010521a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010521d:	83 ec 04             	sub    $0x4,%esp
80105220:	51                   	push   %ecx
80105221:	52                   	push   %edx
80105222:	50                   	push   %eax
80105223:	e8 b2 bf ff ff       	call   801011da <fileread>
80105228:	83 c4 10             	add    $0x10,%esp
}
8010522b:	c9                   	leave  
8010522c:	c3                   	ret    

8010522d <sys_write>:

int
sys_write(void)
{
8010522d:	55                   	push   %ebp
8010522e:	89 e5                	mov    %esp,%ebp
80105230:	83 ec 18             	sub    $0x18,%esp
  struct file *f;
  int n;
  char *p;

  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80105233:	83 ec 04             	sub    $0x4,%esp
80105236:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105239:	50                   	push   %eax
8010523a:	6a 00                	push   $0x0
8010523c:	6a 00                	push   $0x0
8010523e:	e8 66 fe ff ff       	call   801050a9 <argfd>
80105243:	83 c4 10             	add    $0x10,%esp
80105246:	85 c0                	test   %eax,%eax
80105248:	78 2e                	js     80105278 <sys_write+0x4b>
8010524a:	83 ec 08             	sub    $0x8,%esp
8010524d:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105250:	50                   	push   %eax
80105251:	6a 02                	push   $0x2
80105253:	e8 07 fd ff ff       	call   80104f5f <argint>
80105258:	83 c4 10             	add    $0x10,%esp
8010525b:	85 c0                	test   %eax,%eax
8010525d:	78 19                	js     80105278 <sys_write+0x4b>
8010525f:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105262:	83 ec 04             	sub    $0x4,%esp
80105265:	50                   	push   %eax
80105266:	8d 45 ec             	lea    -0x14(%ebp),%eax
80105269:	50                   	push   %eax
8010526a:	6a 01                	push   $0x1
8010526c:	e8 1b fd ff ff       	call   80104f8c <argptr>
80105271:	83 c4 10             	add    $0x10,%esp
80105274:	85 c0                	test   %eax,%eax
80105276:	79 07                	jns    8010527f <sys_write+0x52>
    return -1;
80105278:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010527d:	eb 17                	jmp    80105296 <sys_write+0x69>
  return filewrite(f, p, n);
8010527f:	8b 4d f0             	mov    -0x10(%ebp),%ecx
80105282:	8b 55 ec             	mov    -0x14(%ebp),%edx
80105285:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105288:	83 ec 04             	sub    $0x4,%esp
8010528b:	51                   	push   %ecx
8010528c:	52                   	push   %edx
8010528d:	50                   	push   %eax
8010528e:	e8 ff bf ff ff       	call   80101292 <filewrite>
80105293:	83 c4 10             	add    $0x10,%esp
}
80105296:	c9                   	leave  
80105297:	c3                   	ret    

80105298 <sys_close>:

int
sys_close(void)
{
80105298:	55                   	push   %ebp
80105299:	89 e5                	mov    %esp,%ebp
8010529b:	83 ec 18             	sub    $0x18,%esp
  int fd;
  struct file *f;

  if(argfd(0, &fd, &f) < 0)
8010529e:	83 ec 04             	sub    $0x4,%esp
801052a1:	8d 45 f0             	lea    -0x10(%ebp),%eax
801052a4:	50                   	push   %eax
801052a5:	8d 45 f4             	lea    -0xc(%ebp),%eax
801052a8:	50                   	push   %eax
801052a9:	6a 00                	push   $0x0
801052ab:	e8 f9 fd ff ff       	call   801050a9 <argfd>
801052b0:	83 c4 10             	add    $0x10,%esp
801052b3:	85 c0                	test   %eax,%eax
801052b5:	79 07                	jns    801052be <sys_close+0x26>
    return -1;
801052b7:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801052bc:	eb 27                	jmp    801052e5 <sys_close+0x4d>
  myproc()->ofile[fd] = 0;
801052be:	e8 6d e7 ff ff       	call   80103a30 <myproc>
801052c3:	8b 55 f4             	mov    -0xc(%ebp),%edx
801052c6:	83 c2 08             	add    $0x8,%edx
801052c9:	c7 44 90 08 00 00 00 	movl   $0x0,0x8(%eax,%edx,4)
801052d0:	00 
  fileclose(f);
801052d1:	8b 45 f0             	mov    -0x10(%ebp),%eax
801052d4:	83 ec 0c             	sub    $0xc,%esp
801052d7:	50                   	push   %eax
801052d8:	e8 be bd ff ff       	call   8010109b <fileclose>
801052dd:	83 c4 10             	add    $0x10,%esp
  return 0;
801052e0:	b8 00 00 00 00       	mov    $0x0,%eax
}
801052e5:	c9                   	leave  
801052e6:	c3                   	ret    

801052e7 <sys_fstat>:

int
sys_fstat(void)
{
801052e7:	55                   	push   %ebp
801052e8:	89 e5                	mov    %esp,%ebp
801052ea:	83 ec 18             	sub    $0x18,%esp
  struct file *f;
  struct stat *st;

  if(argfd(0, 0, &f) < 0 || argptr(1, (void*)&st, sizeof(*st)) < 0)
801052ed:	83 ec 04             	sub    $0x4,%esp
801052f0:	8d 45 f4             	lea    -0xc(%ebp),%eax
801052f3:	50                   	push   %eax
801052f4:	6a 00                	push   $0x0
801052f6:	6a 00                	push   $0x0
801052f8:	e8 ac fd ff ff       	call   801050a9 <argfd>
801052fd:	83 c4 10             	add    $0x10,%esp
80105300:	85 c0                	test   %eax,%eax
80105302:	78 17                	js     8010531b <sys_fstat+0x34>
80105304:	83 ec 04             	sub    $0x4,%esp
80105307:	6a 14                	push   $0x14
80105309:	8d 45 f0             	lea    -0x10(%ebp),%eax
8010530c:	50                   	push   %eax
8010530d:	6a 01                	push   $0x1
8010530f:	e8 78 fc ff ff       	call   80104f8c <argptr>
80105314:	83 c4 10             	add    $0x10,%esp
80105317:	85 c0                	test   %eax,%eax
80105319:	79 07                	jns    80105322 <sys_fstat+0x3b>
    return -1;
8010531b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105320:	eb 13                	jmp    80105335 <sys_fstat+0x4e>
  return filestat(f, st);
80105322:	8b 55 f0             	mov    -0x10(%ebp),%edx
80105325:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105328:	83 ec 08             	sub    $0x8,%esp
8010532b:	52                   	push   %edx
8010532c:	50                   	push   %eax
8010532d:	e8 51 be ff ff       	call   80101183 <filestat>
80105332:	83 c4 10             	add    $0x10,%esp
}
80105335:	c9                   	leave  
80105336:	c3                   	ret    

80105337 <sys_link>:

// Create the path new as a link to the same inode as old.
int
sys_link(void)
{
80105337:	55                   	push   %ebp
80105338:	89 e5                	mov    %esp,%ebp
8010533a:	83 ec 28             	sub    $0x28,%esp
  char name[DIRSIZ], *new, *old;
  struct inode *dp, *ip;

  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
8010533d:	83 ec 08             	sub    $0x8,%esp
80105340:	8d 45 d8             	lea    -0x28(%ebp),%eax
80105343:	50                   	push   %eax
80105344:	6a 00                	push   $0x0
80105346:	e8 a9 fc ff ff       	call   80104ff4 <argstr>
8010534b:	83 c4 10             	add    $0x10,%esp
8010534e:	85 c0                	test   %eax,%eax
80105350:	78 15                	js     80105367 <sys_link+0x30>
80105352:	83 ec 08             	sub    $0x8,%esp
80105355:	8d 45 dc             	lea    -0x24(%ebp),%eax
80105358:	50                   	push   %eax
80105359:	6a 01                	push   $0x1
8010535b:	e8 94 fc ff ff       	call   80104ff4 <argstr>
80105360:	83 c4 10             	add    $0x10,%esp
80105363:	85 c0                	test   %eax,%eax
80105365:	79 0a                	jns    80105371 <sys_link+0x3a>
    return -1;
80105367:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010536c:	e9 68 01 00 00       	jmp    801054d9 <sys_link+0x1a2>

  begin_op();
80105371:	e8 c6 dc ff ff       	call   8010303c <begin_op>
  if((ip = namei(old)) == 0){
80105376:	8b 45 d8             	mov    -0x28(%ebp),%eax
80105379:	83 ec 0c             	sub    $0xc,%esp
8010537c:	50                   	push   %eax
8010537d:	e8 9b d1 ff ff       	call   8010251d <namei>
80105382:	83 c4 10             	add    $0x10,%esp
80105385:	89 45 f4             	mov    %eax,-0xc(%ebp)
80105388:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
8010538c:	75 0f                	jne    8010539d <sys_link+0x66>
    end_op();
8010538e:	e8 35 dd ff ff       	call   801030c8 <end_op>
    return -1;
80105393:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105398:	e9 3c 01 00 00       	jmp    801054d9 <sys_link+0x1a2>
  }

  ilock(ip);
8010539d:	83 ec 0c             	sub    $0xc,%esp
801053a0:	ff 75 f4             	push   -0xc(%ebp)
801053a3:	e8 42 c6 ff ff       	call   801019ea <ilock>
801053a8:	83 c4 10             	add    $0x10,%esp
  if(ip->type == T_DIR){
801053ab:	8b 45 f4             	mov    -0xc(%ebp),%eax
801053ae:	0f b7 40 50          	movzwl 0x50(%eax),%eax
801053b2:	66 83 f8 01          	cmp    $0x1,%ax
801053b6:	75 1d                	jne    801053d5 <sys_link+0x9e>
    iunlockput(ip);
801053b8:	83 ec 0c             	sub    $0xc,%esp
801053bb:	ff 75 f4             	push   -0xc(%ebp)
801053be:	e8 58 c8 ff ff       	call   80101c1b <iunlockput>
801053c3:	83 c4 10             	add    $0x10,%esp
    end_op();
801053c6:	e8 fd dc ff ff       	call   801030c8 <end_op>
    return -1;
801053cb:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801053d0:	e9 04 01 00 00       	jmp    801054d9 <sys_link+0x1a2>
  }

  ip->nlink++;
801053d5:	8b 45 f4             	mov    -0xc(%ebp),%eax
801053d8:	0f b7 40 56          	movzwl 0x56(%eax),%eax
801053dc:	83 c0 01             	add    $0x1,%eax
801053df:	89 c2                	mov    %eax,%edx
801053e1:	8b 45 f4             	mov    -0xc(%ebp),%eax
801053e4:	66 89 50 56          	mov    %dx,0x56(%eax)
  iupdate(ip);
801053e8:	83 ec 0c             	sub    $0xc,%esp
801053eb:	ff 75 f4             	push   -0xc(%ebp)
801053ee:	e8 1a c4 ff ff       	call   8010180d <iupdate>
801053f3:	83 c4 10             	add    $0x10,%esp
  iunlock(ip);
801053f6:	83 ec 0c             	sub    $0xc,%esp
801053f9:	ff 75 f4             	push   -0xc(%ebp)
801053fc:	e8 fc c6 ff ff       	call   80101afd <iunlock>
80105401:	83 c4 10             	add    $0x10,%esp

  if((dp = nameiparent(new, name)) == 0)
80105404:	8b 45 dc             	mov    -0x24(%ebp),%eax
80105407:	83 ec 08             	sub    $0x8,%esp
8010540a:	8d 55 e2             	lea    -0x1e(%ebp),%edx
8010540d:	52                   	push   %edx
8010540e:	50                   	push   %eax
8010540f:	e8 25 d1 ff ff       	call   80102539 <nameiparent>
80105414:	83 c4 10             	add    $0x10,%esp
80105417:	89 45 f0             	mov    %eax,-0x10(%ebp)
8010541a:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
8010541e:	74 71                	je     80105491 <sys_link+0x15a>
    goto bad;
  ilock(dp);
80105420:	83 ec 0c             	sub    $0xc,%esp
80105423:	ff 75 f0             	push   -0x10(%ebp)
80105426:	e8 bf c5 ff ff       	call   801019ea <ilock>
8010542b:	83 c4 10             	add    $0x10,%esp
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
8010542e:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105431:	8b 10                	mov    (%eax),%edx
80105433:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105436:	8b 00                	mov    (%eax),%eax
80105438:	39 c2                	cmp    %eax,%edx
8010543a:	75 1d                	jne    80105459 <sys_link+0x122>
8010543c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010543f:	8b 40 04             	mov    0x4(%eax),%eax
80105442:	83 ec 04             	sub    $0x4,%esp
80105445:	50                   	push   %eax
80105446:	8d 45 e2             	lea    -0x1e(%ebp),%eax
80105449:	50                   	push   %eax
8010544a:	ff 75 f0             	push   -0x10(%ebp)
8010544d:	e8 34 ce ff ff       	call   80102286 <dirlink>
80105452:	83 c4 10             	add    $0x10,%esp
80105455:	85 c0                	test   %eax,%eax
80105457:	79 10                	jns    80105469 <sys_link+0x132>
    iunlockput(dp);
80105459:	83 ec 0c             	sub    $0xc,%esp
8010545c:	ff 75 f0             	push   -0x10(%ebp)
8010545f:	e8 b7 c7 ff ff       	call   80101c1b <iunlockput>
80105464:	83 c4 10             	add    $0x10,%esp
    goto bad;
80105467:	eb 29                	jmp    80105492 <sys_link+0x15b>
  }
  iunlockput(dp);
80105469:	83 ec 0c             	sub    $0xc,%esp
8010546c:	ff 75 f0             	push   -0x10(%ebp)
8010546f:	e8 a7 c7 ff ff       	call   80101c1b <iunlockput>
80105474:	83 c4 10             	add    $0x10,%esp
  iput(ip);
80105477:	83 ec 0c             	sub    $0xc,%esp
8010547a:	ff 75 f4             	push   -0xc(%ebp)
8010547d:	e8 c9 c6 ff ff       	call   80101b4b <iput>
80105482:	83 c4 10             	add    $0x10,%esp

  end_op();
80105485:	e8 3e dc ff ff       	call   801030c8 <end_op>

  return 0;
8010548a:	b8 00 00 00 00       	mov    $0x0,%eax
8010548f:	eb 48                	jmp    801054d9 <sys_link+0x1a2>
    goto bad;
80105491:	90                   	nop

bad:
  ilock(ip);
80105492:	83 ec 0c             	sub    $0xc,%esp
80105495:	ff 75 f4             	push   -0xc(%ebp)
80105498:	e8 4d c5 ff ff       	call   801019ea <ilock>
8010549d:	83 c4 10             	add    $0x10,%esp
  ip->nlink--;
801054a0:	8b 45 f4             	mov    -0xc(%ebp),%eax
801054a3:	0f b7 40 56          	movzwl 0x56(%eax),%eax
801054a7:	83 e8 01             	sub    $0x1,%eax
801054aa:	89 c2                	mov    %eax,%edx
801054ac:	8b 45 f4             	mov    -0xc(%ebp),%eax
801054af:	66 89 50 56          	mov    %dx,0x56(%eax)
  iupdate(ip);
801054b3:	83 ec 0c             	sub    $0xc,%esp
801054b6:	ff 75 f4             	push   -0xc(%ebp)
801054b9:	e8 4f c3 ff ff       	call   8010180d <iupdate>
801054be:	83 c4 10             	add    $0x10,%esp
  iunlockput(ip);
801054c1:	83 ec 0c             	sub    $0xc,%esp
801054c4:	ff 75 f4             	push   -0xc(%ebp)
801054c7:	e8 4f c7 ff ff       	call   80101c1b <iunlockput>
801054cc:	83 c4 10             	add    $0x10,%esp
  end_op();
801054cf:	e8 f4 db ff ff       	call   801030c8 <end_op>
  return -1;
801054d4:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801054d9:	c9                   	leave  
801054da:	c3                   	ret    

801054db <isdirempty>:

// Is the directory dp empty except for "." and ".." ?
static int
isdirempty(struct inode *dp)
{
801054db:	55                   	push   %ebp
801054dc:	89 e5                	mov    %esp,%ebp
801054de:	83 ec 28             	sub    $0x28,%esp
  int off;
  struct dirent de;

  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
801054e1:	c7 45 f4 20 00 00 00 	movl   $0x20,-0xc(%ebp)
801054e8:	eb 40                	jmp    8010552a <isdirempty+0x4f>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
801054ea:	8b 45 f4             	mov    -0xc(%ebp),%eax
801054ed:	6a 10                	push   $0x10
801054ef:	50                   	push   %eax
801054f0:	8d 45 e4             	lea    -0x1c(%ebp),%eax
801054f3:	50                   	push   %eax
801054f4:	ff 75 08             	push   0x8(%ebp)
801054f7:	e8 da c9 ff ff       	call   80101ed6 <readi>
801054fc:	83 c4 10             	add    $0x10,%esp
801054ff:	83 f8 10             	cmp    $0x10,%eax
80105502:	74 0d                	je     80105511 <isdirempty+0x36>
      panic("isdirempty: readi");
80105504:	83 ec 0c             	sub    $0xc,%esp
80105507:	68 ea a6 10 80       	push   $0x8010a6ea
8010550c:	e8 98 b0 ff ff       	call   801005a9 <panic>
    if(de.inum != 0)
80105511:	0f b7 45 e4          	movzwl -0x1c(%ebp),%eax
80105515:	66 85 c0             	test   %ax,%ax
80105518:	74 07                	je     80105521 <isdirempty+0x46>
      return 0;
8010551a:	b8 00 00 00 00       	mov    $0x0,%eax
8010551f:	eb 1b                	jmp    8010553c <isdirempty+0x61>
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
80105521:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105524:	83 c0 10             	add    $0x10,%eax
80105527:	89 45 f4             	mov    %eax,-0xc(%ebp)
8010552a:	8b 45 08             	mov    0x8(%ebp),%eax
8010552d:	8b 50 58             	mov    0x58(%eax),%edx
80105530:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105533:	39 c2                	cmp    %eax,%edx
80105535:	77 b3                	ja     801054ea <isdirempty+0xf>
  }
  return 1;
80105537:	b8 01 00 00 00       	mov    $0x1,%eax
}
8010553c:	c9                   	leave  
8010553d:	c3                   	ret    

8010553e <sys_unlink>:

//PAGEBREAK!
int
sys_unlink(void)
{
8010553e:	55                   	push   %ebp
8010553f:	89 e5                	mov    %esp,%ebp
80105541:	83 ec 38             	sub    $0x38,%esp
  struct inode *ip, *dp;
  struct dirent de;
  char name[DIRSIZ], *path;
  uint off;

  if(argstr(0, &path) < 0)
80105544:	83 ec 08             	sub    $0x8,%esp
80105547:	8d 45 cc             	lea    -0x34(%ebp),%eax
8010554a:	50                   	push   %eax
8010554b:	6a 00                	push   $0x0
8010554d:	e8 a2 fa ff ff       	call   80104ff4 <argstr>
80105552:	83 c4 10             	add    $0x10,%esp
80105555:	85 c0                	test   %eax,%eax
80105557:	79 0a                	jns    80105563 <sys_unlink+0x25>
    return -1;
80105559:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010555e:	e9 bf 01 00 00       	jmp    80105722 <sys_unlink+0x1e4>

  begin_op();
80105563:	e8 d4 da ff ff       	call   8010303c <begin_op>
  if((dp = nameiparent(path, name)) == 0){
80105568:	8b 45 cc             	mov    -0x34(%ebp),%eax
8010556b:	83 ec 08             	sub    $0x8,%esp
8010556e:	8d 55 d2             	lea    -0x2e(%ebp),%edx
80105571:	52                   	push   %edx
80105572:	50                   	push   %eax
80105573:	e8 c1 cf ff ff       	call   80102539 <nameiparent>
80105578:	83 c4 10             	add    $0x10,%esp
8010557b:	89 45 f4             	mov    %eax,-0xc(%ebp)
8010557e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80105582:	75 0f                	jne    80105593 <sys_unlink+0x55>
    end_op();
80105584:	e8 3f db ff ff       	call   801030c8 <end_op>
    return -1;
80105589:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010558e:	e9 8f 01 00 00       	jmp    80105722 <sys_unlink+0x1e4>
  }

  ilock(dp);
80105593:	83 ec 0c             	sub    $0xc,%esp
80105596:	ff 75 f4             	push   -0xc(%ebp)
80105599:	e8 4c c4 ff ff       	call   801019ea <ilock>
8010559e:	83 c4 10             	add    $0x10,%esp

  // Cannot unlink "." or "..".
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
801055a1:	83 ec 08             	sub    $0x8,%esp
801055a4:	68 fc a6 10 80       	push   $0x8010a6fc
801055a9:	8d 45 d2             	lea    -0x2e(%ebp),%eax
801055ac:	50                   	push   %eax
801055ad:	e8 ff cb ff ff       	call   801021b1 <namecmp>
801055b2:	83 c4 10             	add    $0x10,%esp
801055b5:	85 c0                	test   %eax,%eax
801055b7:	0f 84 49 01 00 00    	je     80105706 <sys_unlink+0x1c8>
801055bd:	83 ec 08             	sub    $0x8,%esp
801055c0:	68 fe a6 10 80       	push   $0x8010a6fe
801055c5:	8d 45 d2             	lea    -0x2e(%ebp),%eax
801055c8:	50                   	push   %eax
801055c9:	e8 e3 cb ff ff       	call   801021b1 <namecmp>
801055ce:	83 c4 10             	add    $0x10,%esp
801055d1:	85 c0                	test   %eax,%eax
801055d3:	0f 84 2d 01 00 00    	je     80105706 <sys_unlink+0x1c8>
    goto bad;

  if((ip = dirlookup(dp, name, &off)) == 0)
801055d9:	83 ec 04             	sub    $0x4,%esp
801055dc:	8d 45 c8             	lea    -0x38(%ebp),%eax
801055df:	50                   	push   %eax
801055e0:	8d 45 d2             	lea    -0x2e(%ebp),%eax
801055e3:	50                   	push   %eax
801055e4:	ff 75 f4             	push   -0xc(%ebp)
801055e7:	e8 e0 cb ff ff       	call   801021cc <dirlookup>
801055ec:	83 c4 10             	add    $0x10,%esp
801055ef:	89 45 f0             	mov    %eax,-0x10(%ebp)
801055f2:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
801055f6:	0f 84 0d 01 00 00    	je     80105709 <sys_unlink+0x1cb>
    goto bad;
  ilock(ip);
801055fc:	83 ec 0c             	sub    $0xc,%esp
801055ff:	ff 75 f0             	push   -0x10(%ebp)
80105602:	e8 e3 c3 ff ff       	call   801019ea <ilock>
80105607:	83 c4 10             	add    $0x10,%esp

  if(ip->nlink < 1)
8010560a:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010560d:	0f b7 40 56          	movzwl 0x56(%eax),%eax
80105611:	66 85 c0             	test   %ax,%ax
80105614:	7f 0d                	jg     80105623 <sys_unlink+0xe5>
    panic("unlink: nlink < 1");
80105616:	83 ec 0c             	sub    $0xc,%esp
80105619:	68 01 a7 10 80       	push   $0x8010a701
8010561e:	e8 86 af ff ff       	call   801005a9 <panic>
  if(ip->type == T_DIR && !isdirempty(ip)){
80105623:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105626:	0f b7 40 50          	movzwl 0x50(%eax),%eax
8010562a:	66 83 f8 01          	cmp    $0x1,%ax
8010562e:	75 25                	jne    80105655 <sys_unlink+0x117>
80105630:	83 ec 0c             	sub    $0xc,%esp
80105633:	ff 75 f0             	push   -0x10(%ebp)
80105636:	e8 a0 fe ff ff       	call   801054db <isdirempty>
8010563b:	83 c4 10             	add    $0x10,%esp
8010563e:	85 c0                	test   %eax,%eax
80105640:	75 13                	jne    80105655 <sys_unlink+0x117>
    iunlockput(ip);
80105642:	83 ec 0c             	sub    $0xc,%esp
80105645:	ff 75 f0             	push   -0x10(%ebp)
80105648:	e8 ce c5 ff ff       	call   80101c1b <iunlockput>
8010564d:	83 c4 10             	add    $0x10,%esp
    goto bad;
80105650:	e9 b5 00 00 00       	jmp    8010570a <sys_unlink+0x1cc>
  }

  memset(&de, 0, sizeof(de));
80105655:	83 ec 04             	sub    $0x4,%esp
80105658:	6a 10                	push   $0x10
8010565a:	6a 00                	push   $0x0
8010565c:	8d 45 e0             	lea    -0x20(%ebp),%eax
8010565f:	50                   	push   %eax
80105660:	e8 cf f5 ff ff       	call   80104c34 <memset>
80105665:	83 c4 10             	add    $0x10,%esp
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80105668:	8b 45 c8             	mov    -0x38(%ebp),%eax
8010566b:	6a 10                	push   $0x10
8010566d:	50                   	push   %eax
8010566e:	8d 45 e0             	lea    -0x20(%ebp),%eax
80105671:	50                   	push   %eax
80105672:	ff 75 f4             	push   -0xc(%ebp)
80105675:	e8 b1 c9 ff ff       	call   8010202b <writei>
8010567a:	83 c4 10             	add    $0x10,%esp
8010567d:	83 f8 10             	cmp    $0x10,%eax
80105680:	74 0d                	je     8010568f <sys_unlink+0x151>
    panic("unlink: writei");
80105682:	83 ec 0c             	sub    $0xc,%esp
80105685:	68 13 a7 10 80       	push   $0x8010a713
8010568a:	e8 1a af ff ff       	call   801005a9 <panic>
  if(ip->type == T_DIR){
8010568f:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105692:	0f b7 40 50          	movzwl 0x50(%eax),%eax
80105696:	66 83 f8 01          	cmp    $0x1,%ax
8010569a:	75 21                	jne    801056bd <sys_unlink+0x17f>
    dp->nlink--;
8010569c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010569f:	0f b7 40 56          	movzwl 0x56(%eax),%eax
801056a3:	83 e8 01             	sub    $0x1,%eax
801056a6:	89 c2                	mov    %eax,%edx
801056a8:	8b 45 f4             	mov    -0xc(%ebp),%eax
801056ab:	66 89 50 56          	mov    %dx,0x56(%eax)
    iupdate(dp);
801056af:	83 ec 0c             	sub    $0xc,%esp
801056b2:	ff 75 f4             	push   -0xc(%ebp)
801056b5:	e8 53 c1 ff ff       	call   8010180d <iupdate>
801056ba:	83 c4 10             	add    $0x10,%esp
  }
  iunlockput(dp);
801056bd:	83 ec 0c             	sub    $0xc,%esp
801056c0:	ff 75 f4             	push   -0xc(%ebp)
801056c3:	e8 53 c5 ff ff       	call   80101c1b <iunlockput>
801056c8:	83 c4 10             	add    $0x10,%esp

  ip->nlink--;
801056cb:	8b 45 f0             	mov    -0x10(%ebp),%eax
801056ce:	0f b7 40 56          	movzwl 0x56(%eax),%eax
801056d2:	83 e8 01             	sub    $0x1,%eax
801056d5:	89 c2                	mov    %eax,%edx
801056d7:	8b 45 f0             	mov    -0x10(%ebp),%eax
801056da:	66 89 50 56          	mov    %dx,0x56(%eax)
  iupdate(ip);
801056de:	83 ec 0c             	sub    $0xc,%esp
801056e1:	ff 75 f0             	push   -0x10(%ebp)
801056e4:	e8 24 c1 ff ff       	call   8010180d <iupdate>
801056e9:	83 c4 10             	add    $0x10,%esp
  iunlockput(ip);
801056ec:	83 ec 0c             	sub    $0xc,%esp
801056ef:	ff 75 f0             	push   -0x10(%ebp)
801056f2:	e8 24 c5 ff ff       	call   80101c1b <iunlockput>
801056f7:	83 c4 10             	add    $0x10,%esp

  end_op();
801056fa:	e8 c9 d9 ff ff       	call   801030c8 <end_op>

  return 0;
801056ff:	b8 00 00 00 00       	mov    $0x0,%eax
80105704:	eb 1c                	jmp    80105722 <sys_unlink+0x1e4>
    goto bad;
80105706:	90                   	nop
80105707:	eb 01                	jmp    8010570a <sys_unlink+0x1cc>
    goto bad;
80105709:	90                   	nop

bad:
  iunlockput(dp);
8010570a:	83 ec 0c             	sub    $0xc,%esp
8010570d:	ff 75 f4             	push   -0xc(%ebp)
80105710:	e8 06 c5 ff ff       	call   80101c1b <iunlockput>
80105715:	83 c4 10             	add    $0x10,%esp
  end_op();
80105718:	e8 ab d9 ff ff       	call   801030c8 <end_op>
  return -1;
8010571d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105722:	c9                   	leave  
80105723:	c3                   	ret    

80105724 <create>:

static struct inode*
create(char *path, short type, short major, short minor)
{
80105724:	55                   	push   %ebp
80105725:	89 e5                	mov    %esp,%ebp
80105727:	83 ec 38             	sub    $0x38,%esp
8010572a:	8b 4d 0c             	mov    0xc(%ebp),%ecx
8010572d:	8b 55 10             	mov    0x10(%ebp),%edx
80105730:	8b 45 14             	mov    0x14(%ebp),%eax
80105733:	66 89 4d d4          	mov    %cx,-0x2c(%ebp)
80105737:	66 89 55 d0          	mov    %dx,-0x30(%ebp)
8010573b:	66 89 45 cc          	mov    %ax,-0x34(%ebp)
  uint off;
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
8010573f:	83 ec 08             	sub    $0x8,%esp
80105742:	8d 45 de             	lea    -0x22(%ebp),%eax
80105745:	50                   	push   %eax
80105746:	ff 75 08             	push   0x8(%ebp)
80105749:	e8 eb cd ff ff       	call   80102539 <nameiparent>
8010574e:	83 c4 10             	add    $0x10,%esp
80105751:	89 45 f4             	mov    %eax,-0xc(%ebp)
80105754:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80105758:	75 0a                	jne    80105764 <create+0x40>
    return 0;
8010575a:	b8 00 00 00 00       	mov    $0x0,%eax
8010575f:	e9 90 01 00 00       	jmp    801058f4 <create+0x1d0>
  ilock(dp);
80105764:	83 ec 0c             	sub    $0xc,%esp
80105767:	ff 75 f4             	push   -0xc(%ebp)
8010576a:	e8 7b c2 ff ff       	call   801019ea <ilock>
8010576f:	83 c4 10             	add    $0x10,%esp

  if((ip = dirlookup(dp, name, &off)) != 0){
80105772:	83 ec 04             	sub    $0x4,%esp
80105775:	8d 45 ec             	lea    -0x14(%ebp),%eax
80105778:	50                   	push   %eax
80105779:	8d 45 de             	lea    -0x22(%ebp),%eax
8010577c:	50                   	push   %eax
8010577d:	ff 75 f4             	push   -0xc(%ebp)
80105780:	e8 47 ca ff ff       	call   801021cc <dirlookup>
80105785:	83 c4 10             	add    $0x10,%esp
80105788:	89 45 f0             	mov    %eax,-0x10(%ebp)
8010578b:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
8010578f:	74 50                	je     801057e1 <create+0xbd>
    iunlockput(dp);
80105791:	83 ec 0c             	sub    $0xc,%esp
80105794:	ff 75 f4             	push   -0xc(%ebp)
80105797:	e8 7f c4 ff ff       	call   80101c1b <iunlockput>
8010579c:	83 c4 10             	add    $0x10,%esp
    ilock(ip);
8010579f:	83 ec 0c             	sub    $0xc,%esp
801057a2:	ff 75 f0             	push   -0x10(%ebp)
801057a5:	e8 40 c2 ff ff       	call   801019ea <ilock>
801057aa:	83 c4 10             	add    $0x10,%esp
    if(type == T_FILE && ip->type == T_FILE)
801057ad:	66 83 7d d4 02       	cmpw   $0x2,-0x2c(%ebp)
801057b2:	75 15                	jne    801057c9 <create+0xa5>
801057b4:	8b 45 f0             	mov    -0x10(%ebp),%eax
801057b7:	0f b7 40 50          	movzwl 0x50(%eax),%eax
801057bb:	66 83 f8 02          	cmp    $0x2,%ax
801057bf:	75 08                	jne    801057c9 <create+0xa5>
      return ip;
801057c1:	8b 45 f0             	mov    -0x10(%ebp),%eax
801057c4:	e9 2b 01 00 00       	jmp    801058f4 <create+0x1d0>
    iunlockput(ip);
801057c9:	83 ec 0c             	sub    $0xc,%esp
801057cc:	ff 75 f0             	push   -0x10(%ebp)
801057cf:	e8 47 c4 ff ff       	call   80101c1b <iunlockput>
801057d4:	83 c4 10             	add    $0x10,%esp
    return 0;
801057d7:	b8 00 00 00 00       	mov    $0x0,%eax
801057dc:	e9 13 01 00 00       	jmp    801058f4 <create+0x1d0>
  }

  if((ip = ialloc(dp->dev, type)) == 0)
801057e1:	0f bf 55 d4          	movswl -0x2c(%ebp),%edx
801057e5:	8b 45 f4             	mov    -0xc(%ebp),%eax
801057e8:	8b 00                	mov    (%eax),%eax
801057ea:	83 ec 08             	sub    $0x8,%esp
801057ed:	52                   	push   %edx
801057ee:	50                   	push   %eax
801057ef:	e8 42 bf ff ff       	call   80101736 <ialloc>
801057f4:	83 c4 10             	add    $0x10,%esp
801057f7:	89 45 f0             	mov    %eax,-0x10(%ebp)
801057fa:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
801057fe:	75 0d                	jne    8010580d <create+0xe9>
    panic("create: ialloc");
80105800:	83 ec 0c             	sub    $0xc,%esp
80105803:	68 22 a7 10 80       	push   $0x8010a722
80105808:	e8 9c ad ff ff       	call   801005a9 <panic>

  ilock(ip);
8010580d:	83 ec 0c             	sub    $0xc,%esp
80105810:	ff 75 f0             	push   -0x10(%ebp)
80105813:	e8 d2 c1 ff ff       	call   801019ea <ilock>
80105818:	83 c4 10             	add    $0x10,%esp
  ip->major = major;
8010581b:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010581e:	0f b7 55 d0          	movzwl -0x30(%ebp),%edx
80105822:	66 89 50 52          	mov    %dx,0x52(%eax)
  ip->minor = minor;
80105826:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105829:	0f b7 55 cc          	movzwl -0x34(%ebp),%edx
8010582d:	66 89 50 54          	mov    %dx,0x54(%eax)
  ip->nlink = 1;
80105831:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105834:	66 c7 40 56 01 00    	movw   $0x1,0x56(%eax)
  iupdate(ip);
8010583a:	83 ec 0c             	sub    $0xc,%esp
8010583d:	ff 75 f0             	push   -0x10(%ebp)
80105840:	e8 c8 bf ff ff       	call   8010180d <iupdate>
80105845:	83 c4 10             	add    $0x10,%esp

  if(type == T_DIR){  // Create . and .. entries.
80105848:	66 83 7d d4 01       	cmpw   $0x1,-0x2c(%ebp)
8010584d:	75 6a                	jne    801058b9 <create+0x195>
    dp->nlink++;  // for ".."
8010584f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105852:	0f b7 40 56          	movzwl 0x56(%eax),%eax
80105856:	83 c0 01             	add    $0x1,%eax
80105859:	89 c2                	mov    %eax,%edx
8010585b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010585e:	66 89 50 56          	mov    %dx,0x56(%eax)
    iupdate(dp);
80105862:	83 ec 0c             	sub    $0xc,%esp
80105865:	ff 75 f4             	push   -0xc(%ebp)
80105868:	e8 a0 bf ff ff       	call   8010180d <iupdate>
8010586d:	83 c4 10             	add    $0x10,%esp
    // No ip->nlink++ for ".": avoid cyclic ref count.
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
80105870:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105873:	8b 40 04             	mov    0x4(%eax),%eax
80105876:	83 ec 04             	sub    $0x4,%esp
80105879:	50                   	push   %eax
8010587a:	68 fc a6 10 80       	push   $0x8010a6fc
8010587f:	ff 75 f0             	push   -0x10(%ebp)
80105882:	e8 ff c9 ff ff       	call   80102286 <dirlink>
80105887:	83 c4 10             	add    $0x10,%esp
8010588a:	85 c0                	test   %eax,%eax
8010588c:	78 1e                	js     801058ac <create+0x188>
8010588e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105891:	8b 40 04             	mov    0x4(%eax),%eax
80105894:	83 ec 04             	sub    $0x4,%esp
80105897:	50                   	push   %eax
80105898:	68 fe a6 10 80       	push   $0x8010a6fe
8010589d:	ff 75 f0             	push   -0x10(%ebp)
801058a0:	e8 e1 c9 ff ff       	call   80102286 <dirlink>
801058a5:	83 c4 10             	add    $0x10,%esp
801058a8:	85 c0                	test   %eax,%eax
801058aa:	79 0d                	jns    801058b9 <create+0x195>
      panic("create dots");
801058ac:	83 ec 0c             	sub    $0xc,%esp
801058af:	68 31 a7 10 80       	push   $0x8010a731
801058b4:	e8 f0 ac ff ff       	call   801005a9 <panic>
  }

  if(dirlink(dp, name, ip->inum) < 0)
801058b9:	8b 45 f0             	mov    -0x10(%ebp),%eax
801058bc:	8b 40 04             	mov    0x4(%eax),%eax
801058bf:	83 ec 04             	sub    $0x4,%esp
801058c2:	50                   	push   %eax
801058c3:	8d 45 de             	lea    -0x22(%ebp),%eax
801058c6:	50                   	push   %eax
801058c7:	ff 75 f4             	push   -0xc(%ebp)
801058ca:	e8 b7 c9 ff ff       	call   80102286 <dirlink>
801058cf:	83 c4 10             	add    $0x10,%esp
801058d2:	85 c0                	test   %eax,%eax
801058d4:	79 0d                	jns    801058e3 <create+0x1bf>
    panic("create: dirlink");
801058d6:	83 ec 0c             	sub    $0xc,%esp
801058d9:	68 3d a7 10 80       	push   $0x8010a73d
801058de:	e8 c6 ac ff ff       	call   801005a9 <panic>

  iunlockput(dp);
801058e3:	83 ec 0c             	sub    $0xc,%esp
801058e6:	ff 75 f4             	push   -0xc(%ebp)
801058e9:	e8 2d c3 ff ff       	call   80101c1b <iunlockput>
801058ee:	83 c4 10             	add    $0x10,%esp

  return ip;
801058f1:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
801058f4:	c9                   	leave  
801058f5:	c3                   	ret    

801058f6 <sys_open>:

int
sys_open(void)
{
801058f6:	55                   	push   %ebp
801058f7:	89 e5                	mov    %esp,%ebp
801058f9:	83 ec 28             	sub    $0x28,%esp
  char *path;
  int fd, omode;
  struct file *f;
  struct inode *ip;

  if(argstr(0, &path) < 0 || argint(1, &omode) < 0)
801058fc:	83 ec 08             	sub    $0x8,%esp
801058ff:	8d 45 e8             	lea    -0x18(%ebp),%eax
80105902:	50                   	push   %eax
80105903:	6a 00                	push   $0x0
80105905:	e8 ea f6 ff ff       	call   80104ff4 <argstr>
8010590a:	83 c4 10             	add    $0x10,%esp
8010590d:	85 c0                	test   %eax,%eax
8010590f:	78 15                	js     80105926 <sys_open+0x30>
80105911:	83 ec 08             	sub    $0x8,%esp
80105914:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80105917:	50                   	push   %eax
80105918:	6a 01                	push   $0x1
8010591a:	e8 40 f6 ff ff       	call   80104f5f <argint>
8010591f:	83 c4 10             	add    $0x10,%esp
80105922:	85 c0                	test   %eax,%eax
80105924:	79 0a                	jns    80105930 <sys_open+0x3a>
    return -1;
80105926:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010592b:	e9 61 01 00 00       	jmp    80105a91 <sys_open+0x19b>

  begin_op();
80105930:	e8 07 d7 ff ff       	call   8010303c <begin_op>

  if(omode & O_CREATE){
80105935:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80105938:	25 00 02 00 00       	and    $0x200,%eax
8010593d:	85 c0                	test   %eax,%eax
8010593f:	74 2a                	je     8010596b <sys_open+0x75>
    ip = create(path, T_FILE, 0, 0);
80105941:	8b 45 e8             	mov    -0x18(%ebp),%eax
80105944:	6a 00                	push   $0x0
80105946:	6a 00                	push   $0x0
80105948:	6a 02                	push   $0x2
8010594a:	50                   	push   %eax
8010594b:	e8 d4 fd ff ff       	call   80105724 <create>
80105950:	83 c4 10             	add    $0x10,%esp
80105953:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(ip == 0){
80105956:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
8010595a:	75 75                	jne    801059d1 <sys_open+0xdb>
      end_op();
8010595c:	e8 67 d7 ff ff       	call   801030c8 <end_op>
      return -1;
80105961:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105966:	e9 26 01 00 00       	jmp    80105a91 <sys_open+0x19b>
    }
  } else {
    if((ip = namei(path)) == 0){
8010596b:	8b 45 e8             	mov    -0x18(%ebp),%eax
8010596e:	83 ec 0c             	sub    $0xc,%esp
80105971:	50                   	push   %eax
80105972:	e8 a6 cb ff ff       	call   8010251d <namei>
80105977:	83 c4 10             	add    $0x10,%esp
8010597a:	89 45 f4             	mov    %eax,-0xc(%ebp)
8010597d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80105981:	75 0f                	jne    80105992 <sys_open+0x9c>
      end_op();
80105983:	e8 40 d7 ff ff       	call   801030c8 <end_op>
      return -1;
80105988:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010598d:	e9 ff 00 00 00       	jmp    80105a91 <sys_open+0x19b>
    }
    ilock(ip);
80105992:	83 ec 0c             	sub    $0xc,%esp
80105995:	ff 75 f4             	push   -0xc(%ebp)
80105998:	e8 4d c0 ff ff       	call   801019ea <ilock>
8010599d:	83 c4 10             	add    $0x10,%esp
    if(ip->type == T_DIR && omode != O_RDONLY){
801059a0:	8b 45 f4             	mov    -0xc(%ebp),%eax
801059a3:	0f b7 40 50          	movzwl 0x50(%eax),%eax
801059a7:	66 83 f8 01          	cmp    $0x1,%ax
801059ab:	75 24                	jne    801059d1 <sys_open+0xdb>
801059ad:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801059b0:	85 c0                	test   %eax,%eax
801059b2:	74 1d                	je     801059d1 <sys_open+0xdb>
      iunlockput(ip);
801059b4:	83 ec 0c             	sub    $0xc,%esp
801059b7:	ff 75 f4             	push   -0xc(%ebp)
801059ba:	e8 5c c2 ff ff       	call   80101c1b <iunlockput>
801059bf:	83 c4 10             	add    $0x10,%esp
      end_op();
801059c2:	e8 01 d7 ff ff       	call   801030c8 <end_op>
      return -1;
801059c7:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801059cc:	e9 c0 00 00 00       	jmp    80105a91 <sys_open+0x19b>
    }
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
801059d1:	e8 07 b6 ff ff       	call   80100fdd <filealloc>
801059d6:	89 45 f0             	mov    %eax,-0x10(%ebp)
801059d9:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
801059dd:	74 17                	je     801059f6 <sys_open+0x100>
801059df:	83 ec 0c             	sub    $0xc,%esp
801059e2:	ff 75 f0             	push   -0x10(%ebp)
801059e5:	e8 33 f7 ff ff       	call   8010511d <fdalloc>
801059ea:	83 c4 10             	add    $0x10,%esp
801059ed:	89 45 ec             	mov    %eax,-0x14(%ebp)
801059f0:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
801059f4:	79 2e                	jns    80105a24 <sys_open+0x12e>
    if(f)
801059f6:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
801059fa:	74 0e                	je     80105a0a <sys_open+0x114>
      fileclose(f);
801059fc:	83 ec 0c             	sub    $0xc,%esp
801059ff:	ff 75 f0             	push   -0x10(%ebp)
80105a02:	e8 94 b6 ff ff       	call   8010109b <fileclose>
80105a07:	83 c4 10             	add    $0x10,%esp
    iunlockput(ip);
80105a0a:	83 ec 0c             	sub    $0xc,%esp
80105a0d:	ff 75 f4             	push   -0xc(%ebp)
80105a10:	e8 06 c2 ff ff       	call   80101c1b <iunlockput>
80105a15:	83 c4 10             	add    $0x10,%esp
    end_op();
80105a18:	e8 ab d6 ff ff       	call   801030c8 <end_op>
    return -1;
80105a1d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105a22:	eb 6d                	jmp    80105a91 <sys_open+0x19b>
  }
  iunlock(ip);
80105a24:	83 ec 0c             	sub    $0xc,%esp
80105a27:	ff 75 f4             	push   -0xc(%ebp)
80105a2a:	e8 ce c0 ff ff       	call   80101afd <iunlock>
80105a2f:	83 c4 10             	add    $0x10,%esp
  end_op();
80105a32:	e8 91 d6 ff ff       	call   801030c8 <end_op>

  f->type = FD_INODE;
80105a37:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105a3a:	c7 00 02 00 00 00    	movl   $0x2,(%eax)
  f->ip = ip;
80105a40:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105a43:	8b 55 f4             	mov    -0xc(%ebp),%edx
80105a46:	89 50 10             	mov    %edx,0x10(%eax)
  f->off = 0;
80105a49:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105a4c:	c7 40 14 00 00 00 00 	movl   $0x0,0x14(%eax)
  f->readable = !(omode & O_WRONLY);
80105a53:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80105a56:	83 e0 01             	and    $0x1,%eax
80105a59:	85 c0                	test   %eax,%eax
80105a5b:	0f 94 c0             	sete   %al
80105a5e:	89 c2                	mov    %eax,%edx
80105a60:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105a63:	88 50 08             	mov    %dl,0x8(%eax)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
80105a66:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80105a69:	83 e0 01             	and    $0x1,%eax
80105a6c:	85 c0                	test   %eax,%eax
80105a6e:	75 0a                	jne    80105a7a <sys_open+0x184>
80105a70:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80105a73:	83 e0 02             	and    $0x2,%eax
80105a76:	85 c0                	test   %eax,%eax
80105a78:	74 07                	je     80105a81 <sys_open+0x18b>
80105a7a:	b8 01 00 00 00       	mov    $0x1,%eax
80105a7f:	eb 05                	jmp    80105a86 <sys_open+0x190>
80105a81:	b8 00 00 00 00       	mov    $0x0,%eax
80105a86:	89 c2                	mov    %eax,%edx
80105a88:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105a8b:	88 50 09             	mov    %dl,0x9(%eax)
  return fd;
80105a8e:	8b 45 ec             	mov    -0x14(%ebp),%eax
}
80105a91:	c9                   	leave  
80105a92:	c3                   	ret    

80105a93 <sys_mkdir>:

int
sys_mkdir(void)
{
80105a93:	55                   	push   %ebp
80105a94:	89 e5                	mov    %esp,%ebp
80105a96:	83 ec 18             	sub    $0x18,%esp
  char *path;
  struct inode *ip;

  begin_op();
80105a99:	e8 9e d5 ff ff       	call   8010303c <begin_op>
  if(argstr(0, &path) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
80105a9e:	83 ec 08             	sub    $0x8,%esp
80105aa1:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105aa4:	50                   	push   %eax
80105aa5:	6a 00                	push   $0x0
80105aa7:	e8 48 f5 ff ff       	call   80104ff4 <argstr>
80105aac:	83 c4 10             	add    $0x10,%esp
80105aaf:	85 c0                	test   %eax,%eax
80105ab1:	78 1b                	js     80105ace <sys_mkdir+0x3b>
80105ab3:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105ab6:	6a 00                	push   $0x0
80105ab8:	6a 00                	push   $0x0
80105aba:	6a 01                	push   $0x1
80105abc:	50                   	push   %eax
80105abd:	e8 62 fc ff ff       	call   80105724 <create>
80105ac2:	83 c4 10             	add    $0x10,%esp
80105ac5:	89 45 f4             	mov    %eax,-0xc(%ebp)
80105ac8:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80105acc:	75 0c                	jne    80105ada <sys_mkdir+0x47>
    end_op();
80105ace:	e8 f5 d5 ff ff       	call   801030c8 <end_op>
    return -1;
80105ad3:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105ad8:	eb 18                	jmp    80105af2 <sys_mkdir+0x5f>
  }
  iunlockput(ip);
80105ada:	83 ec 0c             	sub    $0xc,%esp
80105add:	ff 75 f4             	push   -0xc(%ebp)
80105ae0:	e8 36 c1 ff ff       	call   80101c1b <iunlockput>
80105ae5:	83 c4 10             	add    $0x10,%esp
  end_op();
80105ae8:	e8 db d5 ff ff       	call   801030c8 <end_op>
  return 0;
80105aed:	b8 00 00 00 00       	mov    $0x0,%eax
}
80105af2:	c9                   	leave  
80105af3:	c3                   	ret    

80105af4 <sys_mknod>:

int
sys_mknod(void)
{
80105af4:	55                   	push   %ebp
80105af5:	89 e5                	mov    %esp,%ebp
80105af7:	83 ec 18             	sub    $0x18,%esp
  struct inode *ip;
  char *path;
  int major, minor;

  begin_op();
80105afa:	e8 3d d5 ff ff       	call   8010303c <begin_op>
  if((argstr(0, &path)) < 0 ||
80105aff:	83 ec 08             	sub    $0x8,%esp
80105b02:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105b05:	50                   	push   %eax
80105b06:	6a 00                	push   $0x0
80105b08:	e8 e7 f4 ff ff       	call   80104ff4 <argstr>
80105b0d:	83 c4 10             	add    $0x10,%esp
80105b10:	85 c0                	test   %eax,%eax
80105b12:	78 4f                	js     80105b63 <sys_mknod+0x6f>
     argint(1, &major) < 0 ||
80105b14:	83 ec 08             	sub    $0x8,%esp
80105b17:	8d 45 ec             	lea    -0x14(%ebp),%eax
80105b1a:	50                   	push   %eax
80105b1b:	6a 01                	push   $0x1
80105b1d:	e8 3d f4 ff ff       	call   80104f5f <argint>
80105b22:	83 c4 10             	add    $0x10,%esp
  if((argstr(0, &path)) < 0 ||
80105b25:	85 c0                	test   %eax,%eax
80105b27:	78 3a                	js     80105b63 <sys_mknod+0x6f>
     argint(2, &minor) < 0 ||
80105b29:	83 ec 08             	sub    $0x8,%esp
80105b2c:	8d 45 e8             	lea    -0x18(%ebp),%eax
80105b2f:	50                   	push   %eax
80105b30:	6a 02                	push   $0x2
80105b32:	e8 28 f4 ff ff       	call   80104f5f <argint>
80105b37:	83 c4 10             	add    $0x10,%esp
     argint(1, &major) < 0 ||
80105b3a:	85 c0                	test   %eax,%eax
80105b3c:	78 25                	js     80105b63 <sys_mknod+0x6f>
     (ip = create(path, T_DEV, major, minor)) == 0){
80105b3e:	8b 45 e8             	mov    -0x18(%ebp),%eax
80105b41:	0f bf c8             	movswl %ax,%ecx
80105b44:	8b 45 ec             	mov    -0x14(%ebp),%eax
80105b47:	0f bf d0             	movswl %ax,%edx
80105b4a:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105b4d:	51                   	push   %ecx
80105b4e:	52                   	push   %edx
80105b4f:	6a 03                	push   $0x3
80105b51:	50                   	push   %eax
80105b52:	e8 cd fb ff ff       	call   80105724 <create>
80105b57:	83 c4 10             	add    $0x10,%esp
80105b5a:	89 45 f4             	mov    %eax,-0xc(%ebp)
     argint(2, &minor) < 0 ||
80105b5d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80105b61:	75 0c                	jne    80105b6f <sys_mknod+0x7b>
    end_op();
80105b63:	e8 60 d5 ff ff       	call   801030c8 <end_op>
    return -1;
80105b68:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105b6d:	eb 18                	jmp    80105b87 <sys_mknod+0x93>
  }
  iunlockput(ip);
80105b6f:	83 ec 0c             	sub    $0xc,%esp
80105b72:	ff 75 f4             	push   -0xc(%ebp)
80105b75:	e8 a1 c0 ff ff       	call   80101c1b <iunlockput>
80105b7a:	83 c4 10             	add    $0x10,%esp
  end_op();
80105b7d:	e8 46 d5 ff ff       	call   801030c8 <end_op>
  return 0;
80105b82:	b8 00 00 00 00       	mov    $0x0,%eax
}
80105b87:	c9                   	leave  
80105b88:	c3                   	ret    

80105b89 <sys_chdir>:

int
sys_chdir(void)
{
80105b89:	55                   	push   %ebp
80105b8a:	89 e5                	mov    %esp,%ebp
80105b8c:	83 ec 18             	sub    $0x18,%esp
  char *path;
  struct inode *ip;
  struct proc *curproc = myproc();
80105b8f:	e8 9c de ff ff       	call   80103a30 <myproc>
80105b94:	89 45 f4             	mov    %eax,-0xc(%ebp)
  
  begin_op();
80105b97:	e8 a0 d4 ff ff       	call   8010303c <begin_op>
  if(argstr(0, &path) < 0 || (ip = namei(path)) == 0){
80105b9c:	83 ec 08             	sub    $0x8,%esp
80105b9f:	8d 45 ec             	lea    -0x14(%ebp),%eax
80105ba2:	50                   	push   %eax
80105ba3:	6a 00                	push   $0x0
80105ba5:	e8 4a f4 ff ff       	call   80104ff4 <argstr>
80105baa:	83 c4 10             	add    $0x10,%esp
80105bad:	85 c0                	test   %eax,%eax
80105baf:	78 18                	js     80105bc9 <sys_chdir+0x40>
80105bb1:	8b 45 ec             	mov    -0x14(%ebp),%eax
80105bb4:	83 ec 0c             	sub    $0xc,%esp
80105bb7:	50                   	push   %eax
80105bb8:	e8 60 c9 ff ff       	call   8010251d <namei>
80105bbd:	83 c4 10             	add    $0x10,%esp
80105bc0:	89 45 f0             	mov    %eax,-0x10(%ebp)
80105bc3:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80105bc7:	75 0c                	jne    80105bd5 <sys_chdir+0x4c>
    end_op();
80105bc9:	e8 fa d4 ff ff       	call   801030c8 <end_op>
    return -1;
80105bce:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105bd3:	eb 68                	jmp    80105c3d <sys_chdir+0xb4>
  }
  ilock(ip);
80105bd5:	83 ec 0c             	sub    $0xc,%esp
80105bd8:	ff 75 f0             	push   -0x10(%ebp)
80105bdb:	e8 0a be ff ff       	call   801019ea <ilock>
80105be0:	83 c4 10             	add    $0x10,%esp
  if(ip->type != T_DIR){
80105be3:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105be6:	0f b7 40 50          	movzwl 0x50(%eax),%eax
80105bea:	66 83 f8 01          	cmp    $0x1,%ax
80105bee:	74 1a                	je     80105c0a <sys_chdir+0x81>
    iunlockput(ip);
80105bf0:	83 ec 0c             	sub    $0xc,%esp
80105bf3:	ff 75 f0             	push   -0x10(%ebp)
80105bf6:	e8 20 c0 ff ff       	call   80101c1b <iunlockput>
80105bfb:	83 c4 10             	add    $0x10,%esp
    end_op();
80105bfe:	e8 c5 d4 ff ff       	call   801030c8 <end_op>
    return -1;
80105c03:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105c08:	eb 33                	jmp    80105c3d <sys_chdir+0xb4>
  }
  iunlock(ip);
80105c0a:	83 ec 0c             	sub    $0xc,%esp
80105c0d:	ff 75 f0             	push   -0x10(%ebp)
80105c10:	e8 e8 be ff ff       	call   80101afd <iunlock>
80105c15:	83 c4 10             	add    $0x10,%esp
  iput(curproc->cwd);
80105c18:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105c1b:	8b 40 68             	mov    0x68(%eax),%eax
80105c1e:	83 ec 0c             	sub    $0xc,%esp
80105c21:	50                   	push   %eax
80105c22:	e8 24 bf ff ff       	call   80101b4b <iput>
80105c27:	83 c4 10             	add    $0x10,%esp
  end_op();
80105c2a:	e8 99 d4 ff ff       	call   801030c8 <end_op>
  curproc->cwd = ip;
80105c2f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105c32:	8b 55 f0             	mov    -0x10(%ebp),%edx
80105c35:	89 50 68             	mov    %edx,0x68(%eax)
  return 0;
80105c38:	b8 00 00 00 00       	mov    $0x0,%eax
}
80105c3d:	c9                   	leave  
80105c3e:	c3                   	ret    

80105c3f <sys_exec>:

int
sys_exec(void)
{
80105c3f:	55                   	push   %ebp
80105c40:	89 e5                	mov    %esp,%ebp
80105c42:	81 ec 98 00 00 00    	sub    $0x98,%esp
  char *path, *argv[MAXARG];
  int i;
  uint uargv, uarg;

  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
80105c48:	83 ec 08             	sub    $0x8,%esp
80105c4b:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105c4e:	50                   	push   %eax
80105c4f:	6a 00                	push   $0x0
80105c51:	e8 9e f3 ff ff       	call   80104ff4 <argstr>
80105c56:	83 c4 10             	add    $0x10,%esp
80105c59:	85 c0                	test   %eax,%eax
80105c5b:	78 18                	js     80105c75 <sys_exec+0x36>
80105c5d:	83 ec 08             	sub    $0x8,%esp
80105c60:	8d 85 6c ff ff ff    	lea    -0x94(%ebp),%eax
80105c66:	50                   	push   %eax
80105c67:	6a 01                	push   $0x1
80105c69:	e8 f1 f2 ff ff       	call   80104f5f <argint>
80105c6e:	83 c4 10             	add    $0x10,%esp
80105c71:	85 c0                	test   %eax,%eax
80105c73:	79 0a                	jns    80105c7f <sys_exec+0x40>
    return -1;
80105c75:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105c7a:	e9 c6 00 00 00       	jmp    80105d45 <sys_exec+0x106>
  }
  memset(argv, 0, sizeof(argv));
80105c7f:	83 ec 04             	sub    $0x4,%esp
80105c82:	68 80 00 00 00       	push   $0x80
80105c87:	6a 00                	push   $0x0
80105c89:	8d 85 70 ff ff ff    	lea    -0x90(%ebp),%eax
80105c8f:	50                   	push   %eax
80105c90:	e8 9f ef ff ff       	call   80104c34 <memset>
80105c95:	83 c4 10             	add    $0x10,%esp
  for(i=0;; i++){
80105c98:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    if(i >= NELEM(argv))
80105c9f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105ca2:	83 f8 1f             	cmp    $0x1f,%eax
80105ca5:	76 0a                	jbe    80105cb1 <sys_exec+0x72>
      return -1;
80105ca7:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105cac:	e9 94 00 00 00       	jmp    80105d45 <sys_exec+0x106>
    if(fetchint(uargv+4*i, (int*)&uarg) < 0)
80105cb1:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105cb4:	c1 e0 02             	shl    $0x2,%eax
80105cb7:	89 c2                	mov    %eax,%edx
80105cb9:	8b 85 6c ff ff ff    	mov    -0x94(%ebp),%eax
80105cbf:	01 c2                	add    %eax,%edx
80105cc1:	83 ec 08             	sub    $0x8,%esp
80105cc4:	8d 85 68 ff ff ff    	lea    -0x98(%ebp),%eax
80105cca:	50                   	push   %eax
80105ccb:	52                   	push   %edx
80105ccc:	e8 ed f1 ff ff       	call   80104ebe <fetchint>
80105cd1:	83 c4 10             	add    $0x10,%esp
80105cd4:	85 c0                	test   %eax,%eax
80105cd6:	79 07                	jns    80105cdf <sys_exec+0xa0>
      return -1;
80105cd8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105cdd:	eb 66                	jmp    80105d45 <sys_exec+0x106>
    if(uarg == 0){
80105cdf:	8b 85 68 ff ff ff    	mov    -0x98(%ebp),%eax
80105ce5:	85 c0                	test   %eax,%eax
80105ce7:	75 27                	jne    80105d10 <sys_exec+0xd1>
      argv[i] = 0;
80105ce9:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105cec:	c7 84 85 70 ff ff ff 	movl   $0x0,-0x90(%ebp,%eax,4)
80105cf3:	00 00 00 00 
      break;
80105cf7:	90                   	nop
    }
    if(fetchstr(uarg, &argv[i]) < 0)
      return -1;
  }
  return exec(path, argv);
80105cf8:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105cfb:	83 ec 08             	sub    $0x8,%esp
80105cfe:	8d 95 70 ff ff ff    	lea    -0x90(%ebp),%edx
80105d04:	52                   	push   %edx
80105d05:	50                   	push   %eax
80105d06:	e8 75 ae ff ff       	call   80100b80 <exec>
80105d0b:	83 c4 10             	add    $0x10,%esp
80105d0e:	eb 35                	jmp    80105d45 <sys_exec+0x106>
    if(fetchstr(uarg, &argv[i]) < 0)
80105d10:	8d 95 70 ff ff ff    	lea    -0x90(%ebp),%edx
80105d16:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105d19:	c1 e0 02             	shl    $0x2,%eax
80105d1c:	01 c2                	add    %eax,%edx
80105d1e:	8b 85 68 ff ff ff    	mov    -0x98(%ebp),%eax
80105d24:	83 ec 08             	sub    $0x8,%esp
80105d27:	52                   	push   %edx
80105d28:	50                   	push   %eax
80105d29:	e8 cf f1 ff ff       	call   80104efd <fetchstr>
80105d2e:	83 c4 10             	add    $0x10,%esp
80105d31:	85 c0                	test   %eax,%eax
80105d33:	79 07                	jns    80105d3c <sys_exec+0xfd>
      return -1;
80105d35:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105d3a:	eb 09                	jmp    80105d45 <sys_exec+0x106>
  for(i=0;; i++){
80105d3c:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
    if(i >= NELEM(argv))
80105d40:	e9 5a ff ff ff       	jmp    80105c9f <sys_exec+0x60>
}
80105d45:	c9                   	leave  
80105d46:	c3                   	ret    

80105d47 <sys_pipe>:

int
sys_pipe(void)
{
80105d47:	55                   	push   %ebp
80105d48:	89 e5                	mov    %esp,%ebp
80105d4a:	83 ec 28             	sub    $0x28,%esp
  int *fd;
  struct file *rf, *wf;
  int fd0, fd1;

  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
80105d4d:	83 ec 04             	sub    $0x4,%esp
80105d50:	6a 08                	push   $0x8
80105d52:	8d 45 ec             	lea    -0x14(%ebp),%eax
80105d55:	50                   	push   %eax
80105d56:	6a 00                	push   $0x0
80105d58:	e8 2f f2 ff ff       	call   80104f8c <argptr>
80105d5d:	83 c4 10             	add    $0x10,%esp
80105d60:	85 c0                	test   %eax,%eax
80105d62:	79 0a                	jns    80105d6e <sys_pipe+0x27>
    return -1;
80105d64:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105d69:	e9 ae 00 00 00       	jmp    80105e1c <sys_pipe+0xd5>
  if(pipealloc(&rf, &wf) < 0)
80105d6e:	83 ec 08             	sub    $0x8,%esp
80105d71:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80105d74:	50                   	push   %eax
80105d75:	8d 45 e8             	lea    -0x18(%ebp),%eax
80105d78:	50                   	push   %eax
80105d79:	e8 ef d7 ff ff       	call   8010356d <pipealloc>
80105d7e:	83 c4 10             	add    $0x10,%esp
80105d81:	85 c0                	test   %eax,%eax
80105d83:	79 0a                	jns    80105d8f <sys_pipe+0x48>
    return -1;
80105d85:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105d8a:	e9 8d 00 00 00       	jmp    80105e1c <sys_pipe+0xd5>
  fd0 = -1;
80105d8f:	c7 45 f4 ff ff ff ff 	movl   $0xffffffff,-0xc(%ebp)
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
80105d96:	8b 45 e8             	mov    -0x18(%ebp),%eax
80105d99:	83 ec 0c             	sub    $0xc,%esp
80105d9c:	50                   	push   %eax
80105d9d:	e8 7b f3 ff ff       	call   8010511d <fdalloc>
80105da2:	83 c4 10             	add    $0x10,%esp
80105da5:	89 45 f4             	mov    %eax,-0xc(%ebp)
80105da8:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80105dac:	78 18                	js     80105dc6 <sys_pipe+0x7f>
80105dae:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80105db1:	83 ec 0c             	sub    $0xc,%esp
80105db4:	50                   	push   %eax
80105db5:	e8 63 f3 ff ff       	call   8010511d <fdalloc>
80105dba:	83 c4 10             	add    $0x10,%esp
80105dbd:	89 45 f0             	mov    %eax,-0x10(%ebp)
80105dc0:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80105dc4:	79 3e                	jns    80105e04 <sys_pipe+0xbd>
    if(fd0 >= 0)
80105dc6:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80105dca:	78 13                	js     80105ddf <sys_pipe+0x98>
      myproc()->ofile[fd0] = 0;
80105dcc:	e8 5f dc ff ff       	call   80103a30 <myproc>
80105dd1:	8b 55 f4             	mov    -0xc(%ebp),%edx
80105dd4:	83 c2 08             	add    $0x8,%edx
80105dd7:	c7 44 90 08 00 00 00 	movl   $0x0,0x8(%eax,%edx,4)
80105dde:	00 
    fileclose(rf);
80105ddf:	8b 45 e8             	mov    -0x18(%ebp),%eax
80105de2:	83 ec 0c             	sub    $0xc,%esp
80105de5:	50                   	push   %eax
80105de6:	e8 b0 b2 ff ff       	call   8010109b <fileclose>
80105deb:	83 c4 10             	add    $0x10,%esp
    fileclose(wf);
80105dee:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80105df1:	83 ec 0c             	sub    $0xc,%esp
80105df4:	50                   	push   %eax
80105df5:	e8 a1 b2 ff ff       	call   8010109b <fileclose>
80105dfa:	83 c4 10             	add    $0x10,%esp
    return -1;
80105dfd:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105e02:	eb 18                	jmp    80105e1c <sys_pipe+0xd5>
  }
  fd[0] = fd0;
80105e04:	8b 45 ec             	mov    -0x14(%ebp),%eax
80105e07:	8b 55 f4             	mov    -0xc(%ebp),%edx
80105e0a:	89 10                	mov    %edx,(%eax)
  fd[1] = fd1;
80105e0c:	8b 45 ec             	mov    -0x14(%ebp),%eax
80105e0f:	8d 50 04             	lea    0x4(%eax),%edx
80105e12:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105e15:	89 02                	mov    %eax,(%edx)
  return 0;
80105e17:	b8 00 00 00 00       	mov    $0x0,%eax
}
80105e1c:	c9                   	leave  
80105e1d:	c3                   	ret    

80105e1e <sys_fork>:
#include "spinlock.h"
#include "debug.h"

int
sys_fork(void)
{
80105e1e:	55                   	push   %ebp
80105e1f:	89 e5                	mov    %esp,%ebp
80105e21:	83 ec 08             	sub    $0x8,%esp
  return fork();
80105e24:	e8 09 df ff ff       	call   80103d32 <fork>
}
80105e29:	c9                   	leave  
80105e2a:	c3                   	ret    

80105e2b <sys_exit>:

int
sys_exit(void)
{
80105e2b:	55                   	push   %ebp
80105e2c:	89 e5                	mov    %esp,%ebp
80105e2e:	83 ec 08             	sub    $0x8,%esp
  exit();
80105e31:	e8 75 e0 ff ff       	call   80103eab <exit>
  return 0;  // not reached
80105e36:	b8 00 00 00 00       	mov    $0x0,%eax
}
80105e3b:	c9                   	leave  
80105e3c:	c3                   	ret    

80105e3d <sys_uthread_init>:

int sys_uthread_init(void) {
80105e3d:	55                   	push   %ebp
80105e3e:	89 e5                	mov    %esp,%ebp
80105e40:	83 ec 18             	sub    $0x18,%esp
  int address;
  //0번째 파라미터로 준 값을 &address에 저장.  유효값 아니라면 리턴 -1
  if (argint(0, &address) < 0){
80105e43:	83 ec 08             	sub    $0x8,%esp
80105e46:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105e49:	50                   	push   %eax
80105e4a:	6a 00                	push   $0x0
80105e4c:	e8 0e f1 ff ff       	call   80104f5f <argint>
80105e51:	83 c4 10             	add    $0x10,%esp
80105e54:	85 c0                	test   %eax,%eax
80105e56:	79 1b                	jns    80105e73 <sys_uthread_init+0x36>
	  cprintf("****&address is %d\n", address); //에러면 ****
80105e58:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105e5b:	83 ec 08             	sub    $0x8,%esp
80105e5e:	50                   	push   %eax
80105e5f:	68 4d a7 10 80       	push   $0x8010a74d
80105e64:	e8 8b a5 ff ff       	call   801003f4 <cprintf>
80105e69:	83 c4 10             	add    $0x10,%esp
	  return -1;
80105e6c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105e71:	eb 23                	jmp    80105e96 <sys_uthread_init+0x59>
  }
  cprintf("^^^address is %d\n", address); //정상이면 ^^^^인데 0으로 저장되는 에러 
80105e73:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105e76:	83 ec 08             	sub    $0x8,%esp
80105e79:	50                   	push   %eax
80105e7a:	68 61 a7 10 80       	push   $0x8010a761
80105e7f:	e8 70 a5 ff ff       	call   801003f4 <cprintf>
80105e84:	83 c4 10             	add    $0x10,%esp
  return uthread_init(address);
80105e87:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105e8a:	83 ec 0c             	sub    $0xc,%esp
80105e8d:	50                   	push   %eax
80105e8e:	e8 3b e1 ff ff       	call   80103fce <uthread_init>
80105e93:	83 c4 10             	add    $0x10,%esp
}
80105e96:	c9                   	leave  
80105e97:	c3                   	ret    

80105e98 <sys_exit2>:

int
sys_exit2(void) 
{
80105e98:	55                   	push   %ebp
80105e99:	89 e5                	mov    %esp,%ebp
80105e9b:	83 ec 18             	sub    $0x18,%esp
  int status;

  //첫번쨰 파라미터로 준 값을 &status에 입력한다.
  //유효값 아니라면 리턴 -1
  if (argint(0, &status) < 0)
80105e9e:	83 ec 08             	sub    $0x8,%esp
80105ea1:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105ea4:	50                   	push   %eax
80105ea5:	6a 00                	push   $0x0
80105ea7:	e8 b3 f0 ff ff       	call   80104f5f <argint>
80105eac:	83 c4 10             	add    $0x10,%esp
80105eaf:	85 c0                	test   %eax,%eax
80105eb1:	79 07                	jns    80105eba <sys_exit2+0x22>
	  return -1;
80105eb3:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105eb8:	eb 12                	jmp    80105ecc <sys_exit2+0x34>
   
  exit2(status); 
80105eba:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105ebd:	83 ec 0c             	sub    $0xc,%esp
80105ec0:	50                   	push   %eax
80105ec1:	e8 43 e1 ff ff       	call   80104009 <exit2>
80105ec6:	83 c4 10             	add    $0x10,%esp
  //return 0; //eax에 리턴해야하니까
  return status; //eax에 리턴해야하니까
80105ec9:	8b 45 f4             	mov    -0xc(%ebp),%eax
}  
80105ecc:	c9                   	leave  
80105ecd:	c3                   	ret    

80105ece <sys_wait>:

int
sys_wait(void)
{
80105ece:	55                   	push   %ebp
80105ecf:	89 e5                	mov    %esp,%ebp
80105ed1:	83 ec 08             	sub    $0x8,%esp
  return wait();
80105ed4:	e8 5f e2 ff ff       	call   80104138 <wait>
}
80105ed9:	c9                   	leave  
80105eda:	c3                   	ret    

80105edb <sys_wait2>:
//*********new sys_waiat**********
//********************************

int
sys_wait2(void)
{
80105edb:	55                   	push   %ebp
80105edc:	89 e5                	mov    %esp,%ebp
80105ede:	83 ec 18             	sub    $0x18,%esp

  int status;
  //포인터 값 복사, 유효값 아니라면 리턴 -1
  if(argptr(0, (char **)&status, sizeof(int)) < 0)
80105ee1:	83 ec 04             	sub    $0x4,%esp
80105ee4:	6a 04                	push   $0x4
80105ee6:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105ee9:	50                   	push   %eax
80105eea:	6a 00                	push   $0x0
80105eec:	e8 9b f0 ff ff       	call   80104f8c <argptr>
80105ef1:	83 c4 10             	add    $0x10,%esp
80105ef4:	85 c0                	test   %eax,%eax
80105ef6:	79 07                	jns    80105eff <sys_wait2+0x24>
    return -1;
80105ef8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105efd:	eb 0f                	jmp    80105f0e <sys_wait2+0x33>

  //유효값이면 wait2 실행
  return wait2(&status);
80105eff:	83 ec 0c             	sub    $0xc,%esp
80105f02:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105f05:	50                   	push   %eax
80105f06:	e8 50 e3 ff ff       	call   8010425b <wait2>
80105f0b:	83 c4 10             	add    $0x10,%esp

}
80105f0e:	c9                   	leave  
80105f0f:	c3                   	ret    

80105f10 <sys_kill>:
//********************************


int
sys_kill(void)
{
80105f10:	55                   	push   %ebp
80105f11:	89 e5                	mov    %esp,%ebp
80105f13:	83 ec 18             	sub    $0x18,%esp
  int pid;

  if(argint(0, &pid) < 0)
80105f16:	83 ec 08             	sub    $0x8,%esp
80105f19:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105f1c:	50                   	push   %eax
80105f1d:	6a 00                	push   $0x0
80105f1f:	e8 3b f0 ff ff       	call   80104f5f <argint>
80105f24:	83 c4 10             	add    $0x10,%esp
80105f27:	85 c0                	test   %eax,%eax
80105f29:	79 07                	jns    80105f32 <sys_kill+0x22>
    return -1;
80105f2b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105f30:	eb 0f                	jmp    80105f41 <sys_kill+0x31>
  return kill(pid);
80105f32:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105f35:	83 ec 0c             	sub    $0xc,%esp
80105f38:	50                   	push   %eax
80105f39:	e8 7d e7 ff ff       	call   801046bb <kill>
80105f3e:	83 c4 10             	add    $0x10,%esp
}
80105f41:	c9                   	leave  
80105f42:	c3                   	ret    

80105f43 <sys_getpid>:

int
sys_getpid(void)
{
80105f43:	55                   	push   %ebp
80105f44:	89 e5                	mov    %esp,%ebp
80105f46:	83 ec 08             	sub    $0x8,%esp
  return myproc()->pid;
80105f49:	e8 e2 da ff ff       	call   80103a30 <myproc>
80105f4e:	8b 40 10             	mov    0x10(%eax),%eax
}
80105f51:	c9                   	leave  
80105f52:	c3                   	ret    

80105f53 <sys_sbrk>:

int
sys_sbrk(void)
{
80105f53:	55                   	push   %ebp
80105f54:	89 e5                	mov    %esp,%ebp
80105f56:	83 ec 18             	sub    $0x18,%esp
  int addr;
  int n;

  if(argint(0, &n) < 0)
80105f59:	83 ec 08             	sub    $0x8,%esp
80105f5c:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105f5f:	50                   	push   %eax
80105f60:	6a 00                	push   $0x0
80105f62:	e8 f8 ef ff ff       	call   80104f5f <argint>
80105f67:	83 c4 10             	add    $0x10,%esp
80105f6a:	85 c0                	test   %eax,%eax
80105f6c:	79 07                	jns    80105f75 <sys_sbrk+0x22>
    return -1;
80105f6e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105f73:	eb 27                	jmp    80105f9c <sys_sbrk+0x49>
  addr = myproc()->sz;
80105f75:	e8 b6 da ff ff       	call   80103a30 <myproc>
80105f7a:	8b 00                	mov    (%eax),%eax
80105f7c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(growproc(n) < 0)
80105f7f:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105f82:	83 ec 0c             	sub    $0xc,%esp
80105f85:	50                   	push   %eax
80105f86:	e8 0c dd ff ff       	call   80103c97 <growproc>
80105f8b:	83 c4 10             	add    $0x10,%esp
80105f8e:	85 c0                	test   %eax,%eax
80105f90:	79 07                	jns    80105f99 <sys_sbrk+0x46>
    return -1;
80105f92:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105f97:	eb 03                	jmp    80105f9c <sys_sbrk+0x49>
  return addr;
80105f99:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
80105f9c:	c9                   	leave  
80105f9d:	c3                   	ret    

80105f9e <sys_sleep>:

int
sys_sleep(void)
{
80105f9e:	55                   	push   %ebp
80105f9f:	89 e5                	mov    %esp,%ebp
80105fa1:	83 ec 18             	sub    $0x18,%esp
  int n;
  uint ticks0;

  if(argint(0, &n) < 0)
80105fa4:	83 ec 08             	sub    $0x8,%esp
80105fa7:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105faa:	50                   	push   %eax
80105fab:	6a 00                	push   $0x0
80105fad:	e8 ad ef ff ff       	call   80104f5f <argint>
80105fb2:	83 c4 10             	add    $0x10,%esp
80105fb5:	85 c0                	test   %eax,%eax
80105fb7:	79 07                	jns    80105fc0 <sys_sleep+0x22>
    return -1;
80105fb9:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105fbe:	eb 76                	jmp    80106036 <sys_sleep+0x98>
  acquire(&tickslock);
80105fc0:	83 ec 0c             	sub    $0xc,%esp
80105fc3:	68 40 6b 19 80       	push   $0x80196b40
80105fc8:	e8 f1 e9 ff ff       	call   801049be <acquire>
80105fcd:	83 c4 10             	add    $0x10,%esp
  ticks0 = ticks;
80105fd0:	a1 74 6b 19 80       	mov    0x80196b74,%eax
80105fd5:	89 45 f4             	mov    %eax,-0xc(%ebp)
  while(ticks - ticks0 < n){
80105fd8:	eb 38                	jmp    80106012 <sys_sleep+0x74>
    if(myproc()->killed){
80105fda:	e8 51 da ff ff       	call   80103a30 <myproc>
80105fdf:	8b 40 24             	mov    0x24(%eax),%eax
80105fe2:	85 c0                	test   %eax,%eax
80105fe4:	74 17                	je     80105ffd <sys_sleep+0x5f>
      release(&tickslock);
80105fe6:	83 ec 0c             	sub    $0xc,%esp
80105fe9:	68 40 6b 19 80       	push   $0x80196b40
80105fee:	e8 39 ea ff ff       	call   80104a2c <release>
80105ff3:	83 c4 10             	add    $0x10,%esp
      return -1;
80105ff6:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105ffb:	eb 39                	jmp    80106036 <sys_sleep+0x98>
    }
    sleep(&ticks, &tickslock);
80105ffd:	83 ec 08             	sub    $0x8,%esp
80106000:	68 40 6b 19 80       	push   $0x80196b40
80106005:	68 74 6b 19 80       	push   $0x80196b74
8010600a:	e8 8b e5 ff ff       	call   8010459a <sleep>
8010600f:	83 c4 10             	add    $0x10,%esp
  while(ticks - ticks0 < n){
80106012:	a1 74 6b 19 80       	mov    0x80196b74,%eax
80106017:	2b 45 f4             	sub    -0xc(%ebp),%eax
8010601a:	8b 55 f0             	mov    -0x10(%ebp),%edx
8010601d:	39 d0                	cmp    %edx,%eax
8010601f:	72 b9                	jb     80105fda <sys_sleep+0x3c>
  }
  release(&tickslock);
80106021:	83 ec 0c             	sub    $0xc,%esp
80106024:	68 40 6b 19 80       	push   $0x80196b40
80106029:	e8 fe e9 ff ff       	call   80104a2c <release>
8010602e:	83 c4 10             	add    $0x10,%esp
  return 0;
80106031:	b8 00 00 00 00       	mov    $0x0,%eax
}
80106036:	c9                   	leave  
80106037:	c3                   	ret    

80106038 <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
int
sys_uptime(void)
{
80106038:	55                   	push   %ebp
80106039:	89 e5                	mov    %esp,%ebp
8010603b:	83 ec 18             	sub    $0x18,%esp
  uint xticks;

  acquire(&tickslock);
8010603e:	83 ec 0c             	sub    $0xc,%esp
80106041:	68 40 6b 19 80       	push   $0x80196b40
80106046:	e8 73 e9 ff ff       	call   801049be <acquire>
8010604b:	83 c4 10             	add    $0x10,%esp
  xticks = ticks;
8010604e:	a1 74 6b 19 80       	mov    0x80196b74,%eax
80106053:	89 45 f4             	mov    %eax,-0xc(%ebp)
  release(&tickslock);
80106056:	83 ec 0c             	sub    $0xc,%esp
80106059:	68 40 6b 19 80       	push   $0x80196b40
8010605e:	e8 c9 e9 ff ff       	call   80104a2c <release>
80106063:	83 c4 10             	add    $0x10,%esp
  return xticks;
80106066:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
80106069:	c9                   	leave  
8010606a:	c3                   	ret    

8010606b <alltraps>:
8010606b:	1e                   	push   %ds
8010606c:	06                   	push   %es
8010606d:	0f a0                	push   %fs
8010606f:	0f a8                	push   %gs
80106071:	60                   	pusha  
80106072:	66 b8 10 00          	mov    $0x10,%ax
80106076:	8e d8                	mov    %eax,%ds
80106078:	8e c0                	mov    %eax,%es
8010607a:	54                   	push   %esp
8010607b:	e8 d7 01 00 00       	call   80106257 <trap>
80106080:	83 c4 04             	add    $0x4,%esp

80106083 <trapret>:
80106083:	61                   	popa   
80106084:	0f a9                	pop    %gs
80106086:	0f a1                	pop    %fs
80106088:	07                   	pop    %es
80106089:	1f                   	pop    %ds
8010608a:	83 c4 08             	add    $0x8,%esp
8010608d:	cf                   	iret   

8010608e <lidt>:
{
8010608e:	55                   	push   %ebp
8010608f:	89 e5                	mov    %esp,%ebp
80106091:	83 ec 10             	sub    $0x10,%esp
  pd[0] = size-1;
80106094:	8b 45 0c             	mov    0xc(%ebp),%eax
80106097:	83 e8 01             	sub    $0x1,%eax
8010609a:	66 89 45 fa          	mov    %ax,-0x6(%ebp)
  pd[1] = (uint)p;
8010609e:	8b 45 08             	mov    0x8(%ebp),%eax
801060a1:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  pd[2] = (uint)p >> 16;
801060a5:	8b 45 08             	mov    0x8(%ebp),%eax
801060a8:	c1 e8 10             	shr    $0x10,%eax
801060ab:	66 89 45 fe          	mov    %ax,-0x2(%ebp)
  asm volatile("lidt (%0)" : : "r" (pd));
801060af:	8d 45 fa             	lea    -0x6(%ebp),%eax
801060b2:	0f 01 18             	lidtl  (%eax)
}
801060b5:	90                   	nop
801060b6:	c9                   	leave  
801060b7:	c3                   	ret    

801060b8 <rcr2>:

static inline uint
rcr2(void)
{
801060b8:	55                   	push   %ebp
801060b9:	89 e5                	mov    %esp,%ebp
801060bb:	83 ec 10             	sub    $0x10,%esp
  uint val;
  asm volatile("movl %%cr2,%0" : "=r" (val));
801060be:	0f 20 d0             	mov    %cr2,%eax
801060c1:	89 45 fc             	mov    %eax,-0x4(%ebp)
  return val;
801060c4:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
801060c7:	c9                   	leave  
801060c8:	c3                   	ret    

801060c9 <tvinit>:

extern void thread_switch(void); //************** modified

void
tvinit(void)
{
801060c9:	55                   	push   %ebp
801060ca:	89 e5                	mov    %esp,%ebp
801060cc:	83 ec 18             	sub    $0x18,%esp
  int i;

  for(i = 0; i < 256; i++)
801060cf:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
801060d6:	e9 c3 00 00 00       	jmp    8010619e <tvinit+0xd5>
    SETGATE(idt[i], 0, SEG_KCODE<<3, vectors[i], 0);
801060db:	8b 45 f4             	mov    -0xc(%ebp),%eax
801060de:	8b 04 85 84 f0 10 80 	mov    -0x7fef0f7c(,%eax,4),%eax
801060e5:	89 c2                	mov    %eax,%edx
801060e7:	8b 45 f4             	mov    -0xc(%ebp),%eax
801060ea:	66 89 14 c5 40 63 19 	mov    %dx,-0x7fe69cc0(,%eax,8)
801060f1:	80 
801060f2:	8b 45 f4             	mov    -0xc(%ebp),%eax
801060f5:	66 c7 04 c5 42 63 19 	movw   $0x8,-0x7fe69cbe(,%eax,8)
801060fc:	80 08 00 
801060ff:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106102:	0f b6 14 c5 44 63 19 	movzbl -0x7fe69cbc(,%eax,8),%edx
80106109:	80 
8010610a:	83 e2 e0             	and    $0xffffffe0,%edx
8010610d:	88 14 c5 44 63 19 80 	mov    %dl,-0x7fe69cbc(,%eax,8)
80106114:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106117:	0f b6 14 c5 44 63 19 	movzbl -0x7fe69cbc(,%eax,8),%edx
8010611e:	80 
8010611f:	83 e2 1f             	and    $0x1f,%edx
80106122:	88 14 c5 44 63 19 80 	mov    %dl,-0x7fe69cbc(,%eax,8)
80106129:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010612c:	0f b6 14 c5 45 63 19 	movzbl -0x7fe69cbb(,%eax,8),%edx
80106133:	80 
80106134:	83 e2 f0             	and    $0xfffffff0,%edx
80106137:	83 ca 0e             	or     $0xe,%edx
8010613a:	88 14 c5 45 63 19 80 	mov    %dl,-0x7fe69cbb(,%eax,8)
80106141:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106144:	0f b6 14 c5 45 63 19 	movzbl -0x7fe69cbb(,%eax,8),%edx
8010614b:	80 
8010614c:	83 e2 ef             	and    $0xffffffef,%edx
8010614f:	88 14 c5 45 63 19 80 	mov    %dl,-0x7fe69cbb(,%eax,8)
80106156:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106159:	0f b6 14 c5 45 63 19 	movzbl -0x7fe69cbb(,%eax,8),%edx
80106160:	80 
80106161:	83 e2 9f             	and    $0xffffff9f,%edx
80106164:	88 14 c5 45 63 19 80 	mov    %dl,-0x7fe69cbb(,%eax,8)
8010616b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010616e:	0f b6 14 c5 45 63 19 	movzbl -0x7fe69cbb(,%eax,8),%edx
80106175:	80 
80106176:	83 ca 80             	or     $0xffffff80,%edx
80106179:	88 14 c5 45 63 19 80 	mov    %dl,-0x7fe69cbb(,%eax,8)
80106180:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106183:	8b 04 85 84 f0 10 80 	mov    -0x7fef0f7c(,%eax,4),%eax
8010618a:	c1 e8 10             	shr    $0x10,%eax
8010618d:	89 c2                	mov    %eax,%edx
8010618f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106192:	66 89 14 c5 46 63 19 	mov    %dx,-0x7fe69cba(,%eax,8)
80106199:	80 
  for(i = 0; i < 256; i++)
8010619a:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
8010619e:	81 7d f4 ff 00 00 00 	cmpl   $0xff,-0xc(%ebp)
801061a5:	0f 8e 30 ff ff ff    	jle    801060db <tvinit+0x12>
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
801061ab:	a1 84 f1 10 80       	mov    0x8010f184,%eax
801061b0:	66 a3 40 65 19 80    	mov    %ax,0x80196540
801061b6:	66 c7 05 42 65 19 80 	movw   $0x8,0x80196542
801061bd:	08 00 
801061bf:	0f b6 05 44 65 19 80 	movzbl 0x80196544,%eax
801061c6:	83 e0 e0             	and    $0xffffffe0,%eax
801061c9:	a2 44 65 19 80       	mov    %al,0x80196544
801061ce:	0f b6 05 44 65 19 80 	movzbl 0x80196544,%eax
801061d5:	83 e0 1f             	and    $0x1f,%eax
801061d8:	a2 44 65 19 80       	mov    %al,0x80196544
801061dd:	0f b6 05 45 65 19 80 	movzbl 0x80196545,%eax
801061e4:	83 c8 0f             	or     $0xf,%eax
801061e7:	a2 45 65 19 80       	mov    %al,0x80196545
801061ec:	0f b6 05 45 65 19 80 	movzbl 0x80196545,%eax
801061f3:	83 e0 ef             	and    $0xffffffef,%eax
801061f6:	a2 45 65 19 80       	mov    %al,0x80196545
801061fb:	0f b6 05 45 65 19 80 	movzbl 0x80196545,%eax
80106202:	83 c8 60             	or     $0x60,%eax
80106205:	a2 45 65 19 80       	mov    %al,0x80196545
8010620a:	0f b6 05 45 65 19 80 	movzbl 0x80196545,%eax
80106211:	83 c8 80             	or     $0xffffff80,%eax
80106214:	a2 45 65 19 80       	mov    %al,0x80196545
80106219:	a1 84 f1 10 80       	mov    0x8010f184,%eax
8010621e:	c1 e8 10             	shr    $0x10,%eax
80106221:	66 a3 46 65 19 80    	mov    %ax,0x80196546

  initlock(&tickslock, "time");
80106227:	83 ec 08             	sub    $0x8,%esp
8010622a:	68 74 a7 10 80       	push   $0x8010a774
8010622f:	68 40 6b 19 80       	push   $0x80196b40
80106234:	e8 63 e7 ff ff       	call   8010499c <initlock>
80106239:	83 c4 10             	add    $0x10,%esp
}
8010623c:	90                   	nop
8010623d:	c9                   	leave  
8010623e:	c3                   	ret    

8010623f <idtinit>:

void
idtinit(void)
{
8010623f:	55                   	push   %ebp
80106240:	89 e5                	mov    %esp,%ebp
  lidt(idt, sizeof(idt));
80106242:	68 00 08 00 00       	push   $0x800
80106247:	68 40 63 19 80       	push   $0x80196340
8010624c:	e8 3d fe ff ff       	call   8010608e <lidt>
80106251:	83 c4 08             	add    $0x8,%esp
}
80106254:	90                   	nop
80106255:	c9                   	leave  
80106256:	c3                   	ret    

80106257 <trap>:

//PAGEBREAK: 41
void
trap(struct trapframe *tf)
{
80106257:	55                   	push   %ebp
80106258:	89 e5                	mov    %esp,%ebp
8010625a:	57                   	push   %edi
8010625b:	56                   	push   %esi
8010625c:	53                   	push   %ebx
8010625d:	83 ec 1c             	sub    $0x1c,%esp
  if(tf->trapno == T_SYSCALL){ //시스템 콜 처리
80106260:	8b 45 08             	mov    0x8(%ebp),%eax
80106263:	8b 40 30             	mov    0x30(%eax),%eax
80106266:	83 f8 40             	cmp    $0x40,%eax
80106269:	75 3b                	jne    801062a6 <trap+0x4f>
    if(myproc()->killed)
8010626b:	e8 c0 d7 ff ff       	call   80103a30 <myproc>
80106270:	8b 40 24             	mov    0x24(%eax),%eax
80106273:	85 c0                	test   %eax,%eax
80106275:	74 05                	je     8010627c <trap+0x25>
      exit();
80106277:	e8 2f dc ff ff       	call   80103eab <exit>
    myproc()->tf = tf;
8010627c:	e8 af d7 ff ff       	call   80103a30 <myproc>
80106281:	8b 55 08             	mov    0x8(%ebp),%edx
80106284:	89 50 18             	mov    %edx,0x18(%eax)
    syscall(); //usys.S에 정의됨
80106287:	e8 9f ed ff ff       	call   8010502b <syscall>
    if(myproc()->killed)
8010628c:	e8 9f d7 ff ff       	call   80103a30 <myproc>
80106291:	8b 40 24             	mov    0x24(%eax),%eax
80106294:	85 c0                	test   %eax,%eax
80106296:	0f 84 15 02 00 00    	je     801064b1 <trap+0x25a>
      exit();
8010629c:	e8 0a dc ff ff       	call   80103eab <exit>
    return;
801062a1:	e9 0b 02 00 00       	jmp    801064b1 <trap+0x25a>
  }

  switch(tf->trapno){
801062a6:	8b 45 08             	mov    0x8(%ebp),%eax
801062a9:	8b 40 30             	mov    0x30(%eax),%eax
801062ac:	83 e8 20             	sub    $0x20,%eax
801062af:	83 f8 1f             	cmp    $0x1f,%eax
801062b2:	0f 87 c4 00 00 00    	ja     8010637c <trap+0x125>
801062b8:	8b 04 85 1c a8 10 80 	mov    -0x7fef57e4(,%eax,4),%eax
801062bf:	ff e0                	jmp    *%eax
  case T_IRQ0 + IRQ_TIMER: //*************timer interrupt
    if(cpuid() == 0){
801062c1:	e8 d7 d6 ff ff       	call   8010399d <cpuid>
801062c6:	85 c0                	test   %eax,%eax
801062c8:	75 3d                	jne    80106307 <trap+0xb0>
      acquire(&tickslock);
801062ca:	83 ec 0c             	sub    $0xc,%esp
801062cd:	68 40 6b 19 80       	push   $0x80196b40
801062d2:	e8 e7 e6 ff ff       	call   801049be <acquire>
801062d7:	83 c4 10             	add    $0x10,%esp
      ticks++;
801062da:	a1 74 6b 19 80       	mov    0x80196b74,%eax
801062df:	83 c0 01             	add    $0x1,%eax
801062e2:	a3 74 6b 19 80       	mov    %eax,0x80196b74
      wakeup(&ticks);
801062e7:	83 ec 0c             	sub    $0xc,%esp
801062ea:	68 74 6b 19 80       	push   $0x80196b74
801062ef:	e8 90 e3 ff ff       	call   80104684 <wakeup>
801062f4:	83 c4 10             	add    $0x10,%esp
      release(&tickslock);
801062f7:	83 ec 0c             	sub    $0xc,%esp
801062fa:	68 40 6b 19 80       	push   $0x80196b40
801062ff:	e8 28 e7 ff ff       	call   80104a2c <release>
80106304:	83 c4 10             	add    $0x10,%esp
    }
    lapiceoi();
80106307:	e8 10 c8 ff ff       	call   80102b1c <lapiceoi>
//    func(); 
//******************   new code   ****************



    break;
8010630c:	e9 20 01 00 00       	jmp    80106431 <trap+0x1da>
       
  case T_IRQ0 + IRQ_IDE:
    ideintr();
80106311:	e8 f5 3e 00 00       	call   8010a20b <ideintr>
    lapiceoi();
80106316:	e8 01 c8 ff ff       	call   80102b1c <lapiceoi>
    break;
8010631b:	e9 11 01 00 00       	jmp    80106431 <trap+0x1da>
  case T_IRQ0 + IRQ_IDE+1:
    // Bochs generates spurious IDE1 interrupts.
    break;
  case T_IRQ0 + IRQ_KBD:
    kbdintr();
80106320:	e8 3c c6 ff ff       	call   80102961 <kbdintr>
    lapiceoi();
80106325:	e8 f2 c7 ff ff       	call   80102b1c <lapiceoi>
    break;
8010632a:	e9 02 01 00 00       	jmp    80106431 <trap+0x1da>
  case T_IRQ0 + IRQ_COM1:
    uartintr();
8010632f:	e8 53 03 00 00       	call   80106687 <uartintr>
    lapiceoi();
80106334:	e8 e3 c7 ff ff       	call   80102b1c <lapiceoi>
    break;
80106339:	e9 f3 00 00 00       	jmp    80106431 <trap+0x1da>
  case T_IRQ0 + 0xB:
    i8254_intr();
8010633e:	e8 7b 2b 00 00       	call   80108ebe <i8254_intr>
    lapiceoi();
80106343:	e8 d4 c7 ff ff       	call   80102b1c <lapiceoi>
    break;
80106348:	e9 e4 00 00 00       	jmp    80106431 <trap+0x1da>
  case T_IRQ0 + IRQ_SPURIOUS:
    cprintf("cpu%d: spurious interrupt at %x:%x\n",
8010634d:	8b 45 08             	mov    0x8(%ebp),%eax
80106350:	8b 70 38             	mov    0x38(%eax),%esi
            cpuid(), tf->cs, tf->eip);
80106353:	8b 45 08             	mov    0x8(%ebp),%eax
80106356:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
    cprintf("cpu%d: spurious interrupt at %x:%x\n",
8010635a:	0f b7 d8             	movzwl %ax,%ebx
8010635d:	e8 3b d6 ff ff       	call   8010399d <cpuid>
80106362:	56                   	push   %esi
80106363:	53                   	push   %ebx
80106364:	50                   	push   %eax
80106365:	68 7c a7 10 80       	push   $0x8010a77c
8010636a:	e8 85 a0 ff ff       	call   801003f4 <cprintf>
8010636f:	83 c4 10             	add    $0x10,%esp
    lapiceoi();
80106372:	e8 a5 c7 ff ff       	call   80102b1c <lapiceoi>
    break;
80106377:	e9 b5 00 00 00       	jmp    80106431 <trap+0x1da>

  //PAGEBREAK: 13
  default:
    if(myproc() == 0 || (tf->cs&3) == 0){
8010637c:	e8 af d6 ff ff       	call   80103a30 <myproc>
80106381:	85 c0                	test   %eax,%eax
80106383:	74 11                	je     80106396 <trap+0x13f>
80106385:	8b 45 08             	mov    0x8(%ebp),%eax
80106388:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
8010638c:	0f b7 c0             	movzwl %ax,%eax
8010638f:	83 e0 03             	and    $0x3,%eax
80106392:	85 c0                	test   %eax,%eax
80106394:	75 39                	jne    801063cf <trap+0x178>
      // In kernel, it must be our mistake.
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
80106396:	e8 1d fd ff ff       	call   801060b8 <rcr2>
8010639b:	89 c3                	mov    %eax,%ebx
8010639d:	8b 45 08             	mov    0x8(%ebp),%eax
801063a0:	8b 70 38             	mov    0x38(%eax),%esi
801063a3:	e8 f5 d5 ff ff       	call   8010399d <cpuid>
801063a8:	8b 55 08             	mov    0x8(%ebp),%edx
801063ab:	8b 52 30             	mov    0x30(%edx),%edx
801063ae:	83 ec 0c             	sub    $0xc,%esp
801063b1:	53                   	push   %ebx
801063b2:	56                   	push   %esi
801063b3:	50                   	push   %eax
801063b4:	52                   	push   %edx
801063b5:	68 a0 a7 10 80       	push   $0x8010a7a0
801063ba:	e8 35 a0 ff ff       	call   801003f4 <cprintf>
801063bf:	83 c4 20             	add    $0x20,%esp
              tf->trapno, cpuid(), tf->eip, rcr2());
      panic("trap");
801063c2:	83 ec 0c             	sub    $0xc,%esp
801063c5:	68 d2 a7 10 80       	push   $0x8010a7d2
801063ca:	e8 da a1 ff ff       	call   801005a9 <panic>
    }
    // In user space, assume process misbehaved.
    cprintf("pid %d %s: trap %d err %d on cpu %d "
801063cf:	e8 e4 fc ff ff       	call   801060b8 <rcr2>
801063d4:	89 c6                	mov    %eax,%esi
801063d6:	8b 45 08             	mov    0x8(%ebp),%eax
801063d9:	8b 40 38             	mov    0x38(%eax),%eax
801063dc:	89 45 e4             	mov    %eax,-0x1c(%ebp)
801063df:	e8 b9 d5 ff ff       	call   8010399d <cpuid>
801063e4:	89 c3                	mov    %eax,%ebx
801063e6:	8b 45 08             	mov    0x8(%ebp),%eax
801063e9:	8b 48 34             	mov    0x34(%eax),%ecx
801063ec:	89 4d e0             	mov    %ecx,-0x20(%ebp)
801063ef:	8b 45 08             	mov    0x8(%ebp),%eax
801063f2:	8b 78 30             	mov    0x30(%eax),%edi
            "eip 0x%x addr 0x%x--kill proc\n",
            myproc()->pid, myproc()->name, tf->trapno,
801063f5:	e8 36 d6 ff ff       	call   80103a30 <myproc>
801063fa:	8d 50 6c             	lea    0x6c(%eax),%edx
801063fd:	89 55 dc             	mov    %edx,-0x24(%ebp)
80106400:	e8 2b d6 ff ff       	call   80103a30 <myproc>
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80106405:	8b 40 10             	mov    0x10(%eax),%eax
80106408:	56                   	push   %esi
80106409:	ff 75 e4             	push   -0x1c(%ebp)
8010640c:	53                   	push   %ebx
8010640d:	ff 75 e0             	push   -0x20(%ebp)
80106410:	57                   	push   %edi
80106411:	ff 75 dc             	push   -0x24(%ebp)
80106414:	50                   	push   %eax
80106415:	68 d8 a7 10 80       	push   $0x8010a7d8
8010641a:	e8 d5 9f ff ff       	call   801003f4 <cprintf>
8010641f:	83 c4 20             	add    $0x20,%esp
            tf->err, cpuid(), tf->eip, rcr2());
    myproc()->killed = 1;
80106422:	e8 09 d6 ff ff       	call   80103a30 <myproc>
80106427:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
8010642e:	eb 01                	jmp    80106431 <trap+0x1da>
    break;
80106430:	90                   	nop
  }

  // Force process exit if it has been killed and is in user space.
  // (If it is still executing in the kernel, let it keep running
  // until it gets to the regular system call return.)
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80106431:	e8 fa d5 ff ff       	call   80103a30 <myproc>
80106436:	85 c0                	test   %eax,%eax
80106438:	74 23                	je     8010645d <trap+0x206>
8010643a:	e8 f1 d5 ff ff       	call   80103a30 <myproc>
8010643f:	8b 40 24             	mov    0x24(%eax),%eax
80106442:	85 c0                	test   %eax,%eax
80106444:	74 17                	je     8010645d <trap+0x206>
80106446:	8b 45 08             	mov    0x8(%ebp),%eax
80106449:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
8010644d:	0f b7 c0             	movzwl %ax,%eax
80106450:	83 e0 03             	and    $0x3,%eax
80106453:	83 f8 03             	cmp    $0x3,%eax
80106456:	75 05                	jne    8010645d <trap+0x206>
    exit();
80106458:	e8 4e da ff ff       	call   80103eab <exit>

  // Force process to give up CPU on clock tick.
  // If interrupts were on while locks held, would need to check nlock.
  if(myproc() && myproc()->state == RUNNING &&
8010645d:	e8 ce d5 ff ff       	call   80103a30 <myproc>
80106462:	85 c0                	test   %eax,%eax
80106464:	74 1d                	je     80106483 <trap+0x22c>
80106466:	e8 c5 d5 ff ff       	call   80103a30 <myproc>
8010646b:	8b 40 0c             	mov    0xc(%eax),%eax
8010646e:	83 f8 04             	cmp    $0x4,%eax
80106471:	75 10                	jne    80106483 <trap+0x22c>
     tf->trapno == T_IRQ0+IRQ_TIMER)
80106473:	8b 45 08             	mov    0x8(%ebp),%eax
80106476:	8b 40 30             	mov    0x30(%eax),%eax
  if(myproc() && myproc()->state == RUNNING &&
80106479:	83 f8 20             	cmp    $0x20,%eax
8010647c:	75 05                	jne    80106483 <trap+0x22c>
    yield();
8010647e:	e8 97 e0 ff ff       	call   8010451a <yield>

  // Check if the process has been killed since we yielded
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80106483:	e8 a8 d5 ff ff       	call   80103a30 <myproc>
80106488:	85 c0                	test   %eax,%eax
8010648a:	74 26                	je     801064b2 <trap+0x25b>
8010648c:	e8 9f d5 ff ff       	call   80103a30 <myproc>
80106491:	8b 40 24             	mov    0x24(%eax),%eax
80106494:	85 c0                	test   %eax,%eax
80106496:	74 1a                	je     801064b2 <trap+0x25b>
80106498:	8b 45 08             	mov    0x8(%ebp),%eax
8010649b:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
8010649f:	0f b7 c0             	movzwl %ax,%eax
801064a2:	83 e0 03             	and    $0x3,%eax
801064a5:	83 f8 03             	cmp    $0x3,%eax
801064a8:	75 08                	jne    801064b2 <trap+0x25b>
    exit();
801064aa:	e8 fc d9 ff ff       	call   80103eab <exit>
801064af:	eb 01                	jmp    801064b2 <trap+0x25b>
    return;
801064b1:	90                   	nop
}
801064b2:	8d 65 f4             	lea    -0xc(%ebp),%esp
801064b5:	5b                   	pop    %ebx
801064b6:	5e                   	pop    %esi
801064b7:	5f                   	pop    %edi
801064b8:	5d                   	pop    %ebp
801064b9:	c3                   	ret    

801064ba <inb>:
{
801064ba:	55                   	push   %ebp
801064bb:	89 e5                	mov    %esp,%ebp
801064bd:	83 ec 14             	sub    $0x14,%esp
801064c0:	8b 45 08             	mov    0x8(%ebp),%eax
801064c3:	66 89 45 ec          	mov    %ax,-0x14(%ebp)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801064c7:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
801064cb:	89 c2                	mov    %eax,%edx
801064cd:	ec                   	in     (%dx),%al
801064ce:	88 45 ff             	mov    %al,-0x1(%ebp)
  return data;
801064d1:	0f b6 45 ff          	movzbl -0x1(%ebp),%eax
}
801064d5:	c9                   	leave  
801064d6:	c3                   	ret    

801064d7 <outb>:
{
801064d7:	55                   	push   %ebp
801064d8:	89 e5                	mov    %esp,%ebp
801064da:	83 ec 08             	sub    $0x8,%esp
801064dd:	8b 45 08             	mov    0x8(%ebp),%eax
801064e0:	8b 55 0c             	mov    0xc(%ebp),%edx
801064e3:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
801064e7:	89 d0                	mov    %edx,%eax
801064e9:	88 45 f8             	mov    %al,-0x8(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801064ec:	0f b6 45 f8          	movzbl -0x8(%ebp),%eax
801064f0:	0f b7 55 fc          	movzwl -0x4(%ebp),%edx
801064f4:	ee                   	out    %al,(%dx)
}
801064f5:	90                   	nop
801064f6:	c9                   	leave  
801064f7:	c3                   	ret    

801064f8 <uartinit>:

static int uart;    // is there a uart?

void
uartinit(void)
{
801064f8:	55                   	push   %ebp
801064f9:	89 e5                	mov    %esp,%ebp
801064fb:	83 ec 18             	sub    $0x18,%esp
  char *p;

  // Turn off the FIFO
  outb(COM1+2, 0);
801064fe:	6a 00                	push   $0x0
80106500:	68 fa 03 00 00       	push   $0x3fa
80106505:	e8 cd ff ff ff       	call   801064d7 <outb>
8010650a:	83 c4 08             	add    $0x8,%esp

  // 9600 baud, 8 data bits, 1 stop bit, parity off.
  outb(COM1+3, 0x80);    // Unlock divisor
8010650d:	68 80 00 00 00       	push   $0x80
80106512:	68 fb 03 00 00       	push   $0x3fb
80106517:	e8 bb ff ff ff       	call   801064d7 <outb>
8010651c:	83 c4 08             	add    $0x8,%esp
  outb(COM1+0, 115200/9600);
8010651f:	6a 0c                	push   $0xc
80106521:	68 f8 03 00 00       	push   $0x3f8
80106526:	e8 ac ff ff ff       	call   801064d7 <outb>
8010652b:	83 c4 08             	add    $0x8,%esp
  outb(COM1+1, 0);
8010652e:	6a 00                	push   $0x0
80106530:	68 f9 03 00 00       	push   $0x3f9
80106535:	e8 9d ff ff ff       	call   801064d7 <outb>
8010653a:	83 c4 08             	add    $0x8,%esp
  outb(COM1+3, 0x03);    // Lock divisor, 8 data bits.
8010653d:	6a 03                	push   $0x3
8010653f:	68 fb 03 00 00       	push   $0x3fb
80106544:	e8 8e ff ff ff       	call   801064d7 <outb>
80106549:	83 c4 08             	add    $0x8,%esp
  outb(COM1+4, 0);
8010654c:	6a 00                	push   $0x0
8010654e:	68 fc 03 00 00       	push   $0x3fc
80106553:	e8 7f ff ff ff       	call   801064d7 <outb>
80106558:	83 c4 08             	add    $0x8,%esp
  outb(COM1+1, 0x01);    // Enable receive interrupts.
8010655b:	6a 01                	push   $0x1
8010655d:	68 f9 03 00 00       	push   $0x3f9
80106562:	e8 70 ff ff ff       	call   801064d7 <outb>
80106567:	83 c4 08             	add    $0x8,%esp

  // If status is 0xFF, no serial port.
  if(inb(COM1+5) == 0xFF)
8010656a:	68 fd 03 00 00       	push   $0x3fd
8010656f:	e8 46 ff ff ff       	call   801064ba <inb>
80106574:	83 c4 04             	add    $0x4,%esp
80106577:	3c ff                	cmp    $0xff,%al
80106579:	74 61                	je     801065dc <uartinit+0xe4>
    return;
  uart = 1;
8010657b:	c7 05 78 6b 19 80 01 	movl   $0x1,0x80196b78
80106582:	00 00 00 

  // Acknowledge pre-existing interrupt conditions;
  // enable interrupts.
  inb(COM1+2);
80106585:	68 fa 03 00 00       	push   $0x3fa
8010658a:	e8 2b ff ff ff       	call   801064ba <inb>
8010658f:	83 c4 04             	add    $0x4,%esp
  inb(COM1+0);
80106592:	68 f8 03 00 00       	push   $0x3f8
80106597:	e8 1e ff ff ff       	call   801064ba <inb>
8010659c:	83 c4 04             	add    $0x4,%esp
  ioapicenable(IRQ_COM1, 0);
8010659f:	83 ec 08             	sub    $0x8,%esp
801065a2:	6a 00                	push   $0x0
801065a4:	6a 04                	push   $0x4
801065a6:	e8 83 c0 ff ff       	call   8010262e <ioapicenable>
801065ab:	83 c4 10             	add    $0x10,%esp

  // Announce that we're here.
  for(p="xv6...\n"; *p; p++)
801065ae:	c7 45 f4 9c a8 10 80 	movl   $0x8010a89c,-0xc(%ebp)
801065b5:	eb 19                	jmp    801065d0 <uartinit+0xd8>
    uartputc(*p);
801065b7:	8b 45 f4             	mov    -0xc(%ebp),%eax
801065ba:	0f b6 00             	movzbl (%eax),%eax
801065bd:	0f be c0             	movsbl %al,%eax
801065c0:	83 ec 0c             	sub    $0xc,%esp
801065c3:	50                   	push   %eax
801065c4:	e8 16 00 00 00       	call   801065df <uartputc>
801065c9:	83 c4 10             	add    $0x10,%esp
  for(p="xv6...\n"; *p; p++)
801065cc:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
801065d0:	8b 45 f4             	mov    -0xc(%ebp),%eax
801065d3:	0f b6 00             	movzbl (%eax),%eax
801065d6:	84 c0                	test   %al,%al
801065d8:	75 dd                	jne    801065b7 <uartinit+0xbf>
801065da:	eb 01                	jmp    801065dd <uartinit+0xe5>
    return;
801065dc:	90                   	nop
}
801065dd:	c9                   	leave  
801065de:	c3                   	ret    

801065df <uartputc>:

void
uartputc(int c)
{
801065df:	55                   	push   %ebp
801065e0:	89 e5                	mov    %esp,%ebp
801065e2:	83 ec 18             	sub    $0x18,%esp
  int i;

  if(!uart)
801065e5:	a1 78 6b 19 80       	mov    0x80196b78,%eax
801065ea:	85 c0                	test   %eax,%eax
801065ec:	74 53                	je     80106641 <uartputc+0x62>
    return;
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
801065ee:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
801065f5:	eb 11                	jmp    80106608 <uartputc+0x29>
    microdelay(10);
801065f7:	83 ec 0c             	sub    $0xc,%esp
801065fa:	6a 0a                	push   $0xa
801065fc:	e8 36 c5 ff ff       	call   80102b37 <microdelay>
80106601:	83 c4 10             	add    $0x10,%esp
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
80106604:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80106608:	83 7d f4 7f          	cmpl   $0x7f,-0xc(%ebp)
8010660c:	7f 1a                	jg     80106628 <uartputc+0x49>
8010660e:	83 ec 0c             	sub    $0xc,%esp
80106611:	68 fd 03 00 00       	push   $0x3fd
80106616:	e8 9f fe ff ff       	call   801064ba <inb>
8010661b:	83 c4 10             	add    $0x10,%esp
8010661e:	0f b6 c0             	movzbl %al,%eax
80106621:	83 e0 20             	and    $0x20,%eax
80106624:	85 c0                	test   %eax,%eax
80106626:	74 cf                	je     801065f7 <uartputc+0x18>
  outb(COM1+0, c);
80106628:	8b 45 08             	mov    0x8(%ebp),%eax
8010662b:	0f b6 c0             	movzbl %al,%eax
8010662e:	83 ec 08             	sub    $0x8,%esp
80106631:	50                   	push   %eax
80106632:	68 f8 03 00 00       	push   $0x3f8
80106637:	e8 9b fe ff ff       	call   801064d7 <outb>
8010663c:	83 c4 10             	add    $0x10,%esp
8010663f:	eb 01                	jmp    80106642 <uartputc+0x63>
    return;
80106641:	90                   	nop
}
80106642:	c9                   	leave  
80106643:	c3                   	ret    

80106644 <uartgetc>:

static int
uartgetc(void)
{
80106644:	55                   	push   %ebp
80106645:	89 e5                	mov    %esp,%ebp
  if(!uart)
80106647:	a1 78 6b 19 80       	mov    0x80196b78,%eax
8010664c:	85 c0                	test   %eax,%eax
8010664e:	75 07                	jne    80106657 <uartgetc+0x13>
    return -1;
80106650:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106655:	eb 2e                	jmp    80106685 <uartgetc+0x41>
  if(!(inb(COM1+5) & 0x01))
80106657:	68 fd 03 00 00       	push   $0x3fd
8010665c:	e8 59 fe ff ff       	call   801064ba <inb>
80106661:	83 c4 04             	add    $0x4,%esp
80106664:	0f b6 c0             	movzbl %al,%eax
80106667:	83 e0 01             	and    $0x1,%eax
8010666a:	85 c0                	test   %eax,%eax
8010666c:	75 07                	jne    80106675 <uartgetc+0x31>
    return -1;
8010666e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106673:	eb 10                	jmp    80106685 <uartgetc+0x41>
  return inb(COM1+0);
80106675:	68 f8 03 00 00       	push   $0x3f8
8010667a:	e8 3b fe ff ff       	call   801064ba <inb>
8010667f:	83 c4 04             	add    $0x4,%esp
80106682:	0f b6 c0             	movzbl %al,%eax
}
80106685:	c9                   	leave  
80106686:	c3                   	ret    

80106687 <uartintr>:

void
uartintr(void)
{
80106687:	55                   	push   %ebp
80106688:	89 e5                	mov    %esp,%ebp
8010668a:	83 ec 08             	sub    $0x8,%esp
  consoleintr(uartgetc);
8010668d:	83 ec 0c             	sub    $0xc,%esp
80106690:	68 44 66 10 80       	push   $0x80106644
80106695:	e8 3c a1 ff ff       	call   801007d6 <consoleintr>
8010669a:	83 c4 10             	add    $0x10,%esp
}
8010669d:	90                   	nop
8010669e:	c9                   	leave  
8010669f:	c3                   	ret    

801066a0 <vector0>:
801066a0:	6a 00                	push   $0x0
801066a2:	6a 00                	push   $0x0
801066a4:	e9 c2 f9 ff ff       	jmp    8010606b <alltraps>

801066a9 <vector1>:
801066a9:	6a 00                	push   $0x0
801066ab:	6a 01                	push   $0x1
801066ad:	e9 b9 f9 ff ff       	jmp    8010606b <alltraps>

801066b2 <vector2>:
801066b2:	6a 00                	push   $0x0
801066b4:	6a 02                	push   $0x2
801066b6:	e9 b0 f9 ff ff       	jmp    8010606b <alltraps>

801066bb <vector3>:
801066bb:	6a 00                	push   $0x0
801066bd:	6a 03                	push   $0x3
801066bf:	e9 a7 f9 ff ff       	jmp    8010606b <alltraps>

801066c4 <vector4>:
801066c4:	6a 00                	push   $0x0
801066c6:	6a 04                	push   $0x4
801066c8:	e9 9e f9 ff ff       	jmp    8010606b <alltraps>

801066cd <vector5>:
801066cd:	6a 00                	push   $0x0
801066cf:	6a 05                	push   $0x5
801066d1:	e9 95 f9 ff ff       	jmp    8010606b <alltraps>

801066d6 <vector6>:
801066d6:	6a 00                	push   $0x0
801066d8:	6a 06                	push   $0x6
801066da:	e9 8c f9 ff ff       	jmp    8010606b <alltraps>

801066df <vector7>:
801066df:	6a 00                	push   $0x0
801066e1:	6a 07                	push   $0x7
801066e3:	e9 83 f9 ff ff       	jmp    8010606b <alltraps>

801066e8 <vector8>:
801066e8:	6a 08                	push   $0x8
801066ea:	e9 7c f9 ff ff       	jmp    8010606b <alltraps>

801066ef <vector9>:
801066ef:	6a 00                	push   $0x0
801066f1:	6a 09                	push   $0x9
801066f3:	e9 73 f9 ff ff       	jmp    8010606b <alltraps>

801066f8 <vector10>:
801066f8:	6a 0a                	push   $0xa
801066fa:	e9 6c f9 ff ff       	jmp    8010606b <alltraps>

801066ff <vector11>:
801066ff:	6a 0b                	push   $0xb
80106701:	e9 65 f9 ff ff       	jmp    8010606b <alltraps>

80106706 <vector12>:
80106706:	6a 0c                	push   $0xc
80106708:	e9 5e f9 ff ff       	jmp    8010606b <alltraps>

8010670d <vector13>:
8010670d:	6a 0d                	push   $0xd
8010670f:	e9 57 f9 ff ff       	jmp    8010606b <alltraps>

80106714 <vector14>:
80106714:	6a 0e                	push   $0xe
80106716:	e9 50 f9 ff ff       	jmp    8010606b <alltraps>

8010671b <vector15>:
8010671b:	6a 00                	push   $0x0
8010671d:	6a 0f                	push   $0xf
8010671f:	e9 47 f9 ff ff       	jmp    8010606b <alltraps>

80106724 <vector16>:
80106724:	6a 00                	push   $0x0
80106726:	6a 10                	push   $0x10
80106728:	e9 3e f9 ff ff       	jmp    8010606b <alltraps>

8010672d <vector17>:
8010672d:	6a 11                	push   $0x11
8010672f:	e9 37 f9 ff ff       	jmp    8010606b <alltraps>

80106734 <vector18>:
80106734:	6a 00                	push   $0x0
80106736:	6a 12                	push   $0x12
80106738:	e9 2e f9 ff ff       	jmp    8010606b <alltraps>

8010673d <vector19>:
8010673d:	6a 00                	push   $0x0
8010673f:	6a 13                	push   $0x13
80106741:	e9 25 f9 ff ff       	jmp    8010606b <alltraps>

80106746 <vector20>:
80106746:	6a 00                	push   $0x0
80106748:	6a 14                	push   $0x14
8010674a:	e9 1c f9 ff ff       	jmp    8010606b <alltraps>

8010674f <vector21>:
8010674f:	6a 00                	push   $0x0
80106751:	6a 15                	push   $0x15
80106753:	e9 13 f9 ff ff       	jmp    8010606b <alltraps>

80106758 <vector22>:
80106758:	6a 00                	push   $0x0
8010675a:	6a 16                	push   $0x16
8010675c:	e9 0a f9 ff ff       	jmp    8010606b <alltraps>

80106761 <vector23>:
80106761:	6a 00                	push   $0x0
80106763:	6a 17                	push   $0x17
80106765:	e9 01 f9 ff ff       	jmp    8010606b <alltraps>

8010676a <vector24>:
8010676a:	6a 00                	push   $0x0
8010676c:	6a 18                	push   $0x18
8010676e:	e9 f8 f8 ff ff       	jmp    8010606b <alltraps>

80106773 <vector25>:
80106773:	6a 00                	push   $0x0
80106775:	6a 19                	push   $0x19
80106777:	e9 ef f8 ff ff       	jmp    8010606b <alltraps>

8010677c <vector26>:
8010677c:	6a 00                	push   $0x0
8010677e:	6a 1a                	push   $0x1a
80106780:	e9 e6 f8 ff ff       	jmp    8010606b <alltraps>

80106785 <vector27>:
80106785:	6a 00                	push   $0x0
80106787:	6a 1b                	push   $0x1b
80106789:	e9 dd f8 ff ff       	jmp    8010606b <alltraps>

8010678e <vector28>:
8010678e:	6a 00                	push   $0x0
80106790:	6a 1c                	push   $0x1c
80106792:	e9 d4 f8 ff ff       	jmp    8010606b <alltraps>

80106797 <vector29>:
80106797:	6a 00                	push   $0x0
80106799:	6a 1d                	push   $0x1d
8010679b:	e9 cb f8 ff ff       	jmp    8010606b <alltraps>

801067a0 <vector30>:
801067a0:	6a 00                	push   $0x0
801067a2:	6a 1e                	push   $0x1e
801067a4:	e9 c2 f8 ff ff       	jmp    8010606b <alltraps>

801067a9 <vector31>:
801067a9:	6a 00                	push   $0x0
801067ab:	6a 1f                	push   $0x1f
801067ad:	e9 b9 f8 ff ff       	jmp    8010606b <alltraps>

801067b2 <vector32>:
801067b2:	6a 00                	push   $0x0
801067b4:	6a 20                	push   $0x20
801067b6:	e9 b0 f8 ff ff       	jmp    8010606b <alltraps>

801067bb <vector33>:
801067bb:	6a 00                	push   $0x0
801067bd:	6a 21                	push   $0x21
801067bf:	e9 a7 f8 ff ff       	jmp    8010606b <alltraps>

801067c4 <vector34>:
801067c4:	6a 00                	push   $0x0
801067c6:	6a 22                	push   $0x22
801067c8:	e9 9e f8 ff ff       	jmp    8010606b <alltraps>

801067cd <vector35>:
801067cd:	6a 00                	push   $0x0
801067cf:	6a 23                	push   $0x23
801067d1:	e9 95 f8 ff ff       	jmp    8010606b <alltraps>

801067d6 <vector36>:
801067d6:	6a 00                	push   $0x0
801067d8:	6a 24                	push   $0x24
801067da:	e9 8c f8 ff ff       	jmp    8010606b <alltraps>

801067df <vector37>:
801067df:	6a 00                	push   $0x0
801067e1:	6a 25                	push   $0x25
801067e3:	e9 83 f8 ff ff       	jmp    8010606b <alltraps>

801067e8 <vector38>:
801067e8:	6a 00                	push   $0x0
801067ea:	6a 26                	push   $0x26
801067ec:	e9 7a f8 ff ff       	jmp    8010606b <alltraps>

801067f1 <vector39>:
801067f1:	6a 00                	push   $0x0
801067f3:	6a 27                	push   $0x27
801067f5:	e9 71 f8 ff ff       	jmp    8010606b <alltraps>

801067fa <vector40>:
801067fa:	6a 00                	push   $0x0
801067fc:	6a 28                	push   $0x28
801067fe:	e9 68 f8 ff ff       	jmp    8010606b <alltraps>

80106803 <vector41>:
80106803:	6a 00                	push   $0x0
80106805:	6a 29                	push   $0x29
80106807:	e9 5f f8 ff ff       	jmp    8010606b <alltraps>

8010680c <vector42>:
8010680c:	6a 00                	push   $0x0
8010680e:	6a 2a                	push   $0x2a
80106810:	e9 56 f8 ff ff       	jmp    8010606b <alltraps>

80106815 <vector43>:
80106815:	6a 00                	push   $0x0
80106817:	6a 2b                	push   $0x2b
80106819:	e9 4d f8 ff ff       	jmp    8010606b <alltraps>

8010681e <vector44>:
8010681e:	6a 00                	push   $0x0
80106820:	6a 2c                	push   $0x2c
80106822:	e9 44 f8 ff ff       	jmp    8010606b <alltraps>

80106827 <vector45>:
80106827:	6a 00                	push   $0x0
80106829:	6a 2d                	push   $0x2d
8010682b:	e9 3b f8 ff ff       	jmp    8010606b <alltraps>

80106830 <vector46>:
80106830:	6a 00                	push   $0x0
80106832:	6a 2e                	push   $0x2e
80106834:	e9 32 f8 ff ff       	jmp    8010606b <alltraps>

80106839 <vector47>:
80106839:	6a 00                	push   $0x0
8010683b:	6a 2f                	push   $0x2f
8010683d:	e9 29 f8 ff ff       	jmp    8010606b <alltraps>

80106842 <vector48>:
80106842:	6a 00                	push   $0x0
80106844:	6a 30                	push   $0x30
80106846:	e9 20 f8 ff ff       	jmp    8010606b <alltraps>

8010684b <vector49>:
8010684b:	6a 00                	push   $0x0
8010684d:	6a 31                	push   $0x31
8010684f:	e9 17 f8 ff ff       	jmp    8010606b <alltraps>

80106854 <vector50>:
80106854:	6a 00                	push   $0x0
80106856:	6a 32                	push   $0x32
80106858:	e9 0e f8 ff ff       	jmp    8010606b <alltraps>

8010685d <vector51>:
8010685d:	6a 00                	push   $0x0
8010685f:	6a 33                	push   $0x33
80106861:	e9 05 f8 ff ff       	jmp    8010606b <alltraps>

80106866 <vector52>:
80106866:	6a 00                	push   $0x0
80106868:	6a 34                	push   $0x34
8010686a:	e9 fc f7 ff ff       	jmp    8010606b <alltraps>

8010686f <vector53>:
8010686f:	6a 00                	push   $0x0
80106871:	6a 35                	push   $0x35
80106873:	e9 f3 f7 ff ff       	jmp    8010606b <alltraps>

80106878 <vector54>:
80106878:	6a 00                	push   $0x0
8010687a:	6a 36                	push   $0x36
8010687c:	e9 ea f7 ff ff       	jmp    8010606b <alltraps>

80106881 <vector55>:
80106881:	6a 00                	push   $0x0
80106883:	6a 37                	push   $0x37
80106885:	e9 e1 f7 ff ff       	jmp    8010606b <alltraps>

8010688a <vector56>:
8010688a:	6a 00                	push   $0x0
8010688c:	6a 38                	push   $0x38
8010688e:	e9 d8 f7 ff ff       	jmp    8010606b <alltraps>

80106893 <vector57>:
80106893:	6a 00                	push   $0x0
80106895:	6a 39                	push   $0x39
80106897:	e9 cf f7 ff ff       	jmp    8010606b <alltraps>

8010689c <vector58>:
8010689c:	6a 00                	push   $0x0
8010689e:	6a 3a                	push   $0x3a
801068a0:	e9 c6 f7 ff ff       	jmp    8010606b <alltraps>

801068a5 <vector59>:
801068a5:	6a 00                	push   $0x0
801068a7:	6a 3b                	push   $0x3b
801068a9:	e9 bd f7 ff ff       	jmp    8010606b <alltraps>

801068ae <vector60>:
801068ae:	6a 00                	push   $0x0
801068b0:	6a 3c                	push   $0x3c
801068b2:	e9 b4 f7 ff ff       	jmp    8010606b <alltraps>

801068b7 <vector61>:
801068b7:	6a 00                	push   $0x0
801068b9:	6a 3d                	push   $0x3d
801068bb:	e9 ab f7 ff ff       	jmp    8010606b <alltraps>

801068c0 <vector62>:
801068c0:	6a 00                	push   $0x0
801068c2:	6a 3e                	push   $0x3e
801068c4:	e9 a2 f7 ff ff       	jmp    8010606b <alltraps>

801068c9 <vector63>:
801068c9:	6a 00                	push   $0x0
801068cb:	6a 3f                	push   $0x3f
801068cd:	e9 99 f7 ff ff       	jmp    8010606b <alltraps>

801068d2 <vector64>:
801068d2:	6a 00                	push   $0x0
801068d4:	6a 40                	push   $0x40
801068d6:	e9 90 f7 ff ff       	jmp    8010606b <alltraps>

801068db <vector65>:
801068db:	6a 00                	push   $0x0
801068dd:	6a 41                	push   $0x41
801068df:	e9 87 f7 ff ff       	jmp    8010606b <alltraps>

801068e4 <vector66>:
801068e4:	6a 00                	push   $0x0
801068e6:	6a 42                	push   $0x42
801068e8:	e9 7e f7 ff ff       	jmp    8010606b <alltraps>

801068ed <vector67>:
801068ed:	6a 00                	push   $0x0
801068ef:	6a 43                	push   $0x43
801068f1:	e9 75 f7 ff ff       	jmp    8010606b <alltraps>

801068f6 <vector68>:
801068f6:	6a 00                	push   $0x0
801068f8:	6a 44                	push   $0x44
801068fa:	e9 6c f7 ff ff       	jmp    8010606b <alltraps>

801068ff <vector69>:
801068ff:	6a 00                	push   $0x0
80106901:	6a 45                	push   $0x45
80106903:	e9 63 f7 ff ff       	jmp    8010606b <alltraps>

80106908 <vector70>:
80106908:	6a 00                	push   $0x0
8010690a:	6a 46                	push   $0x46
8010690c:	e9 5a f7 ff ff       	jmp    8010606b <alltraps>

80106911 <vector71>:
80106911:	6a 00                	push   $0x0
80106913:	6a 47                	push   $0x47
80106915:	e9 51 f7 ff ff       	jmp    8010606b <alltraps>

8010691a <vector72>:
8010691a:	6a 00                	push   $0x0
8010691c:	6a 48                	push   $0x48
8010691e:	e9 48 f7 ff ff       	jmp    8010606b <alltraps>

80106923 <vector73>:
80106923:	6a 00                	push   $0x0
80106925:	6a 49                	push   $0x49
80106927:	e9 3f f7 ff ff       	jmp    8010606b <alltraps>

8010692c <vector74>:
8010692c:	6a 00                	push   $0x0
8010692e:	6a 4a                	push   $0x4a
80106930:	e9 36 f7 ff ff       	jmp    8010606b <alltraps>

80106935 <vector75>:
80106935:	6a 00                	push   $0x0
80106937:	6a 4b                	push   $0x4b
80106939:	e9 2d f7 ff ff       	jmp    8010606b <alltraps>

8010693e <vector76>:
8010693e:	6a 00                	push   $0x0
80106940:	6a 4c                	push   $0x4c
80106942:	e9 24 f7 ff ff       	jmp    8010606b <alltraps>

80106947 <vector77>:
80106947:	6a 00                	push   $0x0
80106949:	6a 4d                	push   $0x4d
8010694b:	e9 1b f7 ff ff       	jmp    8010606b <alltraps>

80106950 <vector78>:
80106950:	6a 00                	push   $0x0
80106952:	6a 4e                	push   $0x4e
80106954:	e9 12 f7 ff ff       	jmp    8010606b <alltraps>

80106959 <vector79>:
80106959:	6a 00                	push   $0x0
8010695b:	6a 4f                	push   $0x4f
8010695d:	e9 09 f7 ff ff       	jmp    8010606b <alltraps>

80106962 <vector80>:
80106962:	6a 00                	push   $0x0
80106964:	6a 50                	push   $0x50
80106966:	e9 00 f7 ff ff       	jmp    8010606b <alltraps>

8010696b <vector81>:
8010696b:	6a 00                	push   $0x0
8010696d:	6a 51                	push   $0x51
8010696f:	e9 f7 f6 ff ff       	jmp    8010606b <alltraps>

80106974 <vector82>:
80106974:	6a 00                	push   $0x0
80106976:	6a 52                	push   $0x52
80106978:	e9 ee f6 ff ff       	jmp    8010606b <alltraps>

8010697d <vector83>:
8010697d:	6a 00                	push   $0x0
8010697f:	6a 53                	push   $0x53
80106981:	e9 e5 f6 ff ff       	jmp    8010606b <alltraps>

80106986 <vector84>:
80106986:	6a 00                	push   $0x0
80106988:	6a 54                	push   $0x54
8010698a:	e9 dc f6 ff ff       	jmp    8010606b <alltraps>

8010698f <vector85>:
8010698f:	6a 00                	push   $0x0
80106991:	6a 55                	push   $0x55
80106993:	e9 d3 f6 ff ff       	jmp    8010606b <alltraps>

80106998 <vector86>:
80106998:	6a 00                	push   $0x0
8010699a:	6a 56                	push   $0x56
8010699c:	e9 ca f6 ff ff       	jmp    8010606b <alltraps>

801069a1 <vector87>:
801069a1:	6a 00                	push   $0x0
801069a3:	6a 57                	push   $0x57
801069a5:	e9 c1 f6 ff ff       	jmp    8010606b <alltraps>

801069aa <vector88>:
801069aa:	6a 00                	push   $0x0
801069ac:	6a 58                	push   $0x58
801069ae:	e9 b8 f6 ff ff       	jmp    8010606b <alltraps>

801069b3 <vector89>:
801069b3:	6a 00                	push   $0x0
801069b5:	6a 59                	push   $0x59
801069b7:	e9 af f6 ff ff       	jmp    8010606b <alltraps>

801069bc <vector90>:
801069bc:	6a 00                	push   $0x0
801069be:	6a 5a                	push   $0x5a
801069c0:	e9 a6 f6 ff ff       	jmp    8010606b <alltraps>

801069c5 <vector91>:
801069c5:	6a 00                	push   $0x0
801069c7:	6a 5b                	push   $0x5b
801069c9:	e9 9d f6 ff ff       	jmp    8010606b <alltraps>

801069ce <vector92>:
801069ce:	6a 00                	push   $0x0
801069d0:	6a 5c                	push   $0x5c
801069d2:	e9 94 f6 ff ff       	jmp    8010606b <alltraps>

801069d7 <vector93>:
801069d7:	6a 00                	push   $0x0
801069d9:	6a 5d                	push   $0x5d
801069db:	e9 8b f6 ff ff       	jmp    8010606b <alltraps>

801069e0 <vector94>:
801069e0:	6a 00                	push   $0x0
801069e2:	6a 5e                	push   $0x5e
801069e4:	e9 82 f6 ff ff       	jmp    8010606b <alltraps>

801069e9 <vector95>:
801069e9:	6a 00                	push   $0x0
801069eb:	6a 5f                	push   $0x5f
801069ed:	e9 79 f6 ff ff       	jmp    8010606b <alltraps>

801069f2 <vector96>:
801069f2:	6a 00                	push   $0x0
801069f4:	6a 60                	push   $0x60
801069f6:	e9 70 f6 ff ff       	jmp    8010606b <alltraps>

801069fb <vector97>:
801069fb:	6a 00                	push   $0x0
801069fd:	6a 61                	push   $0x61
801069ff:	e9 67 f6 ff ff       	jmp    8010606b <alltraps>

80106a04 <vector98>:
80106a04:	6a 00                	push   $0x0
80106a06:	6a 62                	push   $0x62
80106a08:	e9 5e f6 ff ff       	jmp    8010606b <alltraps>

80106a0d <vector99>:
80106a0d:	6a 00                	push   $0x0
80106a0f:	6a 63                	push   $0x63
80106a11:	e9 55 f6 ff ff       	jmp    8010606b <alltraps>

80106a16 <vector100>:
80106a16:	6a 00                	push   $0x0
80106a18:	6a 64                	push   $0x64
80106a1a:	e9 4c f6 ff ff       	jmp    8010606b <alltraps>

80106a1f <vector101>:
80106a1f:	6a 00                	push   $0x0
80106a21:	6a 65                	push   $0x65
80106a23:	e9 43 f6 ff ff       	jmp    8010606b <alltraps>

80106a28 <vector102>:
80106a28:	6a 00                	push   $0x0
80106a2a:	6a 66                	push   $0x66
80106a2c:	e9 3a f6 ff ff       	jmp    8010606b <alltraps>

80106a31 <vector103>:
80106a31:	6a 00                	push   $0x0
80106a33:	6a 67                	push   $0x67
80106a35:	e9 31 f6 ff ff       	jmp    8010606b <alltraps>

80106a3a <vector104>:
80106a3a:	6a 00                	push   $0x0
80106a3c:	6a 68                	push   $0x68
80106a3e:	e9 28 f6 ff ff       	jmp    8010606b <alltraps>

80106a43 <vector105>:
80106a43:	6a 00                	push   $0x0
80106a45:	6a 69                	push   $0x69
80106a47:	e9 1f f6 ff ff       	jmp    8010606b <alltraps>

80106a4c <vector106>:
80106a4c:	6a 00                	push   $0x0
80106a4e:	6a 6a                	push   $0x6a
80106a50:	e9 16 f6 ff ff       	jmp    8010606b <alltraps>

80106a55 <vector107>:
80106a55:	6a 00                	push   $0x0
80106a57:	6a 6b                	push   $0x6b
80106a59:	e9 0d f6 ff ff       	jmp    8010606b <alltraps>

80106a5e <vector108>:
80106a5e:	6a 00                	push   $0x0
80106a60:	6a 6c                	push   $0x6c
80106a62:	e9 04 f6 ff ff       	jmp    8010606b <alltraps>

80106a67 <vector109>:
80106a67:	6a 00                	push   $0x0
80106a69:	6a 6d                	push   $0x6d
80106a6b:	e9 fb f5 ff ff       	jmp    8010606b <alltraps>

80106a70 <vector110>:
80106a70:	6a 00                	push   $0x0
80106a72:	6a 6e                	push   $0x6e
80106a74:	e9 f2 f5 ff ff       	jmp    8010606b <alltraps>

80106a79 <vector111>:
80106a79:	6a 00                	push   $0x0
80106a7b:	6a 6f                	push   $0x6f
80106a7d:	e9 e9 f5 ff ff       	jmp    8010606b <alltraps>

80106a82 <vector112>:
80106a82:	6a 00                	push   $0x0
80106a84:	6a 70                	push   $0x70
80106a86:	e9 e0 f5 ff ff       	jmp    8010606b <alltraps>

80106a8b <vector113>:
80106a8b:	6a 00                	push   $0x0
80106a8d:	6a 71                	push   $0x71
80106a8f:	e9 d7 f5 ff ff       	jmp    8010606b <alltraps>

80106a94 <vector114>:
80106a94:	6a 00                	push   $0x0
80106a96:	6a 72                	push   $0x72
80106a98:	e9 ce f5 ff ff       	jmp    8010606b <alltraps>

80106a9d <vector115>:
80106a9d:	6a 00                	push   $0x0
80106a9f:	6a 73                	push   $0x73
80106aa1:	e9 c5 f5 ff ff       	jmp    8010606b <alltraps>

80106aa6 <vector116>:
80106aa6:	6a 00                	push   $0x0
80106aa8:	6a 74                	push   $0x74
80106aaa:	e9 bc f5 ff ff       	jmp    8010606b <alltraps>

80106aaf <vector117>:
80106aaf:	6a 00                	push   $0x0
80106ab1:	6a 75                	push   $0x75
80106ab3:	e9 b3 f5 ff ff       	jmp    8010606b <alltraps>

80106ab8 <vector118>:
80106ab8:	6a 00                	push   $0x0
80106aba:	6a 76                	push   $0x76
80106abc:	e9 aa f5 ff ff       	jmp    8010606b <alltraps>

80106ac1 <vector119>:
80106ac1:	6a 00                	push   $0x0
80106ac3:	6a 77                	push   $0x77
80106ac5:	e9 a1 f5 ff ff       	jmp    8010606b <alltraps>

80106aca <vector120>:
80106aca:	6a 00                	push   $0x0
80106acc:	6a 78                	push   $0x78
80106ace:	e9 98 f5 ff ff       	jmp    8010606b <alltraps>

80106ad3 <vector121>:
80106ad3:	6a 00                	push   $0x0
80106ad5:	6a 79                	push   $0x79
80106ad7:	e9 8f f5 ff ff       	jmp    8010606b <alltraps>

80106adc <vector122>:
80106adc:	6a 00                	push   $0x0
80106ade:	6a 7a                	push   $0x7a
80106ae0:	e9 86 f5 ff ff       	jmp    8010606b <alltraps>

80106ae5 <vector123>:
80106ae5:	6a 00                	push   $0x0
80106ae7:	6a 7b                	push   $0x7b
80106ae9:	e9 7d f5 ff ff       	jmp    8010606b <alltraps>

80106aee <vector124>:
80106aee:	6a 00                	push   $0x0
80106af0:	6a 7c                	push   $0x7c
80106af2:	e9 74 f5 ff ff       	jmp    8010606b <alltraps>

80106af7 <vector125>:
80106af7:	6a 00                	push   $0x0
80106af9:	6a 7d                	push   $0x7d
80106afb:	e9 6b f5 ff ff       	jmp    8010606b <alltraps>

80106b00 <vector126>:
80106b00:	6a 00                	push   $0x0
80106b02:	6a 7e                	push   $0x7e
80106b04:	e9 62 f5 ff ff       	jmp    8010606b <alltraps>

80106b09 <vector127>:
80106b09:	6a 00                	push   $0x0
80106b0b:	6a 7f                	push   $0x7f
80106b0d:	e9 59 f5 ff ff       	jmp    8010606b <alltraps>

80106b12 <vector128>:
80106b12:	6a 00                	push   $0x0
80106b14:	68 80 00 00 00       	push   $0x80
80106b19:	e9 4d f5 ff ff       	jmp    8010606b <alltraps>

80106b1e <vector129>:
80106b1e:	6a 00                	push   $0x0
80106b20:	68 81 00 00 00       	push   $0x81
80106b25:	e9 41 f5 ff ff       	jmp    8010606b <alltraps>

80106b2a <vector130>:
80106b2a:	6a 00                	push   $0x0
80106b2c:	68 82 00 00 00       	push   $0x82
80106b31:	e9 35 f5 ff ff       	jmp    8010606b <alltraps>

80106b36 <vector131>:
80106b36:	6a 00                	push   $0x0
80106b38:	68 83 00 00 00       	push   $0x83
80106b3d:	e9 29 f5 ff ff       	jmp    8010606b <alltraps>

80106b42 <vector132>:
80106b42:	6a 00                	push   $0x0
80106b44:	68 84 00 00 00       	push   $0x84
80106b49:	e9 1d f5 ff ff       	jmp    8010606b <alltraps>

80106b4e <vector133>:
80106b4e:	6a 00                	push   $0x0
80106b50:	68 85 00 00 00       	push   $0x85
80106b55:	e9 11 f5 ff ff       	jmp    8010606b <alltraps>

80106b5a <vector134>:
80106b5a:	6a 00                	push   $0x0
80106b5c:	68 86 00 00 00       	push   $0x86
80106b61:	e9 05 f5 ff ff       	jmp    8010606b <alltraps>

80106b66 <vector135>:
80106b66:	6a 00                	push   $0x0
80106b68:	68 87 00 00 00       	push   $0x87
80106b6d:	e9 f9 f4 ff ff       	jmp    8010606b <alltraps>

80106b72 <vector136>:
80106b72:	6a 00                	push   $0x0
80106b74:	68 88 00 00 00       	push   $0x88
80106b79:	e9 ed f4 ff ff       	jmp    8010606b <alltraps>

80106b7e <vector137>:
80106b7e:	6a 00                	push   $0x0
80106b80:	68 89 00 00 00       	push   $0x89
80106b85:	e9 e1 f4 ff ff       	jmp    8010606b <alltraps>

80106b8a <vector138>:
80106b8a:	6a 00                	push   $0x0
80106b8c:	68 8a 00 00 00       	push   $0x8a
80106b91:	e9 d5 f4 ff ff       	jmp    8010606b <alltraps>

80106b96 <vector139>:
80106b96:	6a 00                	push   $0x0
80106b98:	68 8b 00 00 00       	push   $0x8b
80106b9d:	e9 c9 f4 ff ff       	jmp    8010606b <alltraps>

80106ba2 <vector140>:
80106ba2:	6a 00                	push   $0x0
80106ba4:	68 8c 00 00 00       	push   $0x8c
80106ba9:	e9 bd f4 ff ff       	jmp    8010606b <alltraps>

80106bae <vector141>:
80106bae:	6a 00                	push   $0x0
80106bb0:	68 8d 00 00 00       	push   $0x8d
80106bb5:	e9 b1 f4 ff ff       	jmp    8010606b <alltraps>

80106bba <vector142>:
80106bba:	6a 00                	push   $0x0
80106bbc:	68 8e 00 00 00       	push   $0x8e
80106bc1:	e9 a5 f4 ff ff       	jmp    8010606b <alltraps>

80106bc6 <vector143>:
80106bc6:	6a 00                	push   $0x0
80106bc8:	68 8f 00 00 00       	push   $0x8f
80106bcd:	e9 99 f4 ff ff       	jmp    8010606b <alltraps>

80106bd2 <vector144>:
80106bd2:	6a 00                	push   $0x0
80106bd4:	68 90 00 00 00       	push   $0x90
80106bd9:	e9 8d f4 ff ff       	jmp    8010606b <alltraps>

80106bde <vector145>:
80106bde:	6a 00                	push   $0x0
80106be0:	68 91 00 00 00       	push   $0x91
80106be5:	e9 81 f4 ff ff       	jmp    8010606b <alltraps>

80106bea <vector146>:
80106bea:	6a 00                	push   $0x0
80106bec:	68 92 00 00 00       	push   $0x92
80106bf1:	e9 75 f4 ff ff       	jmp    8010606b <alltraps>

80106bf6 <vector147>:
80106bf6:	6a 00                	push   $0x0
80106bf8:	68 93 00 00 00       	push   $0x93
80106bfd:	e9 69 f4 ff ff       	jmp    8010606b <alltraps>

80106c02 <vector148>:
80106c02:	6a 00                	push   $0x0
80106c04:	68 94 00 00 00       	push   $0x94
80106c09:	e9 5d f4 ff ff       	jmp    8010606b <alltraps>

80106c0e <vector149>:
80106c0e:	6a 00                	push   $0x0
80106c10:	68 95 00 00 00       	push   $0x95
80106c15:	e9 51 f4 ff ff       	jmp    8010606b <alltraps>

80106c1a <vector150>:
80106c1a:	6a 00                	push   $0x0
80106c1c:	68 96 00 00 00       	push   $0x96
80106c21:	e9 45 f4 ff ff       	jmp    8010606b <alltraps>

80106c26 <vector151>:
80106c26:	6a 00                	push   $0x0
80106c28:	68 97 00 00 00       	push   $0x97
80106c2d:	e9 39 f4 ff ff       	jmp    8010606b <alltraps>

80106c32 <vector152>:
80106c32:	6a 00                	push   $0x0
80106c34:	68 98 00 00 00       	push   $0x98
80106c39:	e9 2d f4 ff ff       	jmp    8010606b <alltraps>

80106c3e <vector153>:
80106c3e:	6a 00                	push   $0x0
80106c40:	68 99 00 00 00       	push   $0x99
80106c45:	e9 21 f4 ff ff       	jmp    8010606b <alltraps>

80106c4a <vector154>:
80106c4a:	6a 00                	push   $0x0
80106c4c:	68 9a 00 00 00       	push   $0x9a
80106c51:	e9 15 f4 ff ff       	jmp    8010606b <alltraps>

80106c56 <vector155>:
80106c56:	6a 00                	push   $0x0
80106c58:	68 9b 00 00 00       	push   $0x9b
80106c5d:	e9 09 f4 ff ff       	jmp    8010606b <alltraps>

80106c62 <vector156>:
80106c62:	6a 00                	push   $0x0
80106c64:	68 9c 00 00 00       	push   $0x9c
80106c69:	e9 fd f3 ff ff       	jmp    8010606b <alltraps>

80106c6e <vector157>:
80106c6e:	6a 00                	push   $0x0
80106c70:	68 9d 00 00 00       	push   $0x9d
80106c75:	e9 f1 f3 ff ff       	jmp    8010606b <alltraps>

80106c7a <vector158>:
80106c7a:	6a 00                	push   $0x0
80106c7c:	68 9e 00 00 00       	push   $0x9e
80106c81:	e9 e5 f3 ff ff       	jmp    8010606b <alltraps>

80106c86 <vector159>:
80106c86:	6a 00                	push   $0x0
80106c88:	68 9f 00 00 00       	push   $0x9f
80106c8d:	e9 d9 f3 ff ff       	jmp    8010606b <alltraps>

80106c92 <vector160>:
80106c92:	6a 00                	push   $0x0
80106c94:	68 a0 00 00 00       	push   $0xa0
80106c99:	e9 cd f3 ff ff       	jmp    8010606b <alltraps>

80106c9e <vector161>:
80106c9e:	6a 00                	push   $0x0
80106ca0:	68 a1 00 00 00       	push   $0xa1
80106ca5:	e9 c1 f3 ff ff       	jmp    8010606b <alltraps>

80106caa <vector162>:
80106caa:	6a 00                	push   $0x0
80106cac:	68 a2 00 00 00       	push   $0xa2
80106cb1:	e9 b5 f3 ff ff       	jmp    8010606b <alltraps>

80106cb6 <vector163>:
80106cb6:	6a 00                	push   $0x0
80106cb8:	68 a3 00 00 00       	push   $0xa3
80106cbd:	e9 a9 f3 ff ff       	jmp    8010606b <alltraps>

80106cc2 <vector164>:
80106cc2:	6a 00                	push   $0x0
80106cc4:	68 a4 00 00 00       	push   $0xa4
80106cc9:	e9 9d f3 ff ff       	jmp    8010606b <alltraps>

80106cce <vector165>:
80106cce:	6a 00                	push   $0x0
80106cd0:	68 a5 00 00 00       	push   $0xa5
80106cd5:	e9 91 f3 ff ff       	jmp    8010606b <alltraps>

80106cda <vector166>:
80106cda:	6a 00                	push   $0x0
80106cdc:	68 a6 00 00 00       	push   $0xa6
80106ce1:	e9 85 f3 ff ff       	jmp    8010606b <alltraps>

80106ce6 <vector167>:
80106ce6:	6a 00                	push   $0x0
80106ce8:	68 a7 00 00 00       	push   $0xa7
80106ced:	e9 79 f3 ff ff       	jmp    8010606b <alltraps>

80106cf2 <vector168>:
80106cf2:	6a 00                	push   $0x0
80106cf4:	68 a8 00 00 00       	push   $0xa8
80106cf9:	e9 6d f3 ff ff       	jmp    8010606b <alltraps>

80106cfe <vector169>:
80106cfe:	6a 00                	push   $0x0
80106d00:	68 a9 00 00 00       	push   $0xa9
80106d05:	e9 61 f3 ff ff       	jmp    8010606b <alltraps>

80106d0a <vector170>:
80106d0a:	6a 00                	push   $0x0
80106d0c:	68 aa 00 00 00       	push   $0xaa
80106d11:	e9 55 f3 ff ff       	jmp    8010606b <alltraps>

80106d16 <vector171>:
80106d16:	6a 00                	push   $0x0
80106d18:	68 ab 00 00 00       	push   $0xab
80106d1d:	e9 49 f3 ff ff       	jmp    8010606b <alltraps>

80106d22 <vector172>:
80106d22:	6a 00                	push   $0x0
80106d24:	68 ac 00 00 00       	push   $0xac
80106d29:	e9 3d f3 ff ff       	jmp    8010606b <alltraps>

80106d2e <vector173>:
80106d2e:	6a 00                	push   $0x0
80106d30:	68 ad 00 00 00       	push   $0xad
80106d35:	e9 31 f3 ff ff       	jmp    8010606b <alltraps>

80106d3a <vector174>:
80106d3a:	6a 00                	push   $0x0
80106d3c:	68 ae 00 00 00       	push   $0xae
80106d41:	e9 25 f3 ff ff       	jmp    8010606b <alltraps>

80106d46 <vector175>:
80106d46:	6a 00                	push   $0x0
80106d48:	68 af 00 00 00       	push   $0xaf
80106d4d:	e9 19 f3 ff ff       	jmp    8010606b <alltraps>

80106d52 <vector176>:
80106d52:	6a 00                	push   $0x0
80106d54:	68 b0 00 00 00       	push   $0xb0
80106d59:	e9 0d f3 ff ff       	jmp    8010606b <alltraps>

80106d5e <vector177>:
80106d5e:	6a 00                	push   $0x0
80106d60:	68 b1 00 00 00       	push   $0xb1
80106d65:	e9 01 f3 ff ff       	jmp    8010606b <alltraps>

80106d6a <vector178>:
80106d6a:	6a 00                	push   $0x0
80106d6c:	68 b2 00 00 00       	push   $0xb2
80106d71:	e9 f5 f2 ff ff       	jmp    8010606b <alltraps>

80106d76 <vector179>:
80106d76:	6a 00                	push   $0x0
80106d78:	68 b3 00 00 00       	push   $0xb3
80106d7d:	e9 e9 f2 ff ff       	jmp    8010606b <alltraps>

80106d82 <vector180>:
80106d82:	6a 00                	push   $0x0
80106d84:	68 b4 00 00 00       	push   $0xb4
80106d89:	e9 dd f2 ff ff       	jmp    8010606b <alltraps>

80106d8e <vector181>:
80106d8e:	6a 00                	push   $0x0
80106d90:	68 b5 00 00 00       	push   $0xb5
80106d95:	e9 d1 f2 ff ff       	jmp    8010606b <alltraps>

80106d9a <vector182>:
80106d9a:	6a 00                	push   $0x0
80106d9c:	68 b6 00 00 00       	push   $0xb6
80106da1:	e9 c5 f2 ff ff       	jmp    8010606b <alltraps>

80106da6 <vector183>:
80106da6:	6a 00                	push   $0x0
80106da8:	68 b7 00 00 00       	push   $0xb7
80106dad:	e9 b9 f2 ff ff       	jmp    8010606b <alltraps>

80106db2 <vector184>:
80106db2:	6a 00                	push   $0x0
80106db4:	68 b8 00 00 00       	push   $0xb8
80106db9:	e9 ad f2 ff ff       	jmp    8010606b <alltraps>

80106dbe <vector185>:
80106dbe:	6a 00                	push   $0x0
80106dc0:	68 b9 00 00 00       	push   $0xb9
80106dc5:	e9 a1 f2 ff ff       	jmp    8010606b <alltraps>

80106dca <vector186>:
80106dca:	6a 00                	push   $0x0
80106dcc:	68 ba 00 00 00       	push   $0xba
80106dd1:	e9 95 f2 ff ff       	jmp    8010606b <alltraps>

80106dd6 <vector187>:
80106dd6:	6a 00                	push   $0x0
80106dd8:	68 bb 00 00 00       	push   $0xbb
80106ddd:	e9 89 f2 ff ff       	jmp    8010606b <alltraps>

80106de2 <vector188>:
80106de2:	6a 00                	push   $0x0
80106de4:	68 bc 00 00 00       	push   $0xbc
80106de9:	e9 7d f2 ff ff       	jmp    8010606b <alltraps>

80106dee <vector189>:
80106dee:	6a 00                	push   $0x0
80106df0:	68 bd 00 00 00       	push   $0xbd
80106df5:	e9 71 f2 ff ff       	jmp    8010606b <alltraps>

80106dfa <vector190>:
80106dfa:	6a 00                	push   $0x0
80106dfc:	68 be 00 00 00       	push   $0xbe
80106e01:	e9 65 f2 ff ff       	jmp    8010606b <alltraps>

80106e06 <vector191>:
80106e06:	6a 00                	push   $0x0
80106e08:	68 bf 00 00 00       	push   $0xbf
80106e0d:	e9 59 f2 ff ff       	jmp    8010606b <alltraps>

80106e12 <vector192>:
80106e12:	6a 00                	push   $0x0
80106e14:	68 c0 00 00 00       	push   $0xc0
80106e19:	e9 4d f2 ff ff       	jmp    8010606b <alltraps>

80106e1e <vector193>:
80106e1e:	6a 00                	push   $0x0
80106e20:	68 c1 00 00 00       	push   $0xc1
80106e25:	e9 41 f2 ff ff       	jmp    8010606b <alltraps>

80106e2a <vector194>:
80106e2a:	6a 00                	push   $0x0
80106e2c:	68 c2 00 00 00       	push   $0xc2
80106e31:	e9 35 f2 ff ff       	jmp    8010606b <alltraps>

80106e36 <vector195>:
80106e36:	6a 00                	push   $0x0
80106e38:	68 c3 00 00 00       	push   $0xc3
80106e3d:	e9 29 f2 ff ff       	jmp    8010606b <alltraps>

80106e42 <vector196>:
80106e42:	6a 00                	push   $0x0
80106e44:	68 c4 00 00 00       	push   $0xc4
80106e49:	e9 1d f2 ff ff       	jmp    8010606b <alltraps>

80106e4e <vector197>:
80106e4e:	6a 00                	push   $0x0
80106e50:	68 c5 00 00 00       	push   $0xc5
80106e55:	e9 11 f2 ff ff       	jmp    8010606b <alltraps>

80106e5a <vector198>:
80106e5a:	6a 00                	push   $0x0
80106e5c:	68 c6 00 00 00       	push   $0xc6
80106e61:	e9 05 f2 ff ff       	jmp    8010606b <alltraps>

80106e66 <vector199>:
80106e66:	6a 00                	push   $0x0
80106e68:	68 c7 00 00 00       	push   $0xc7
80106e6d:	e9 f9 f1 ff ff       	jmp    8010606b <alltraps>

80106e72 <vector200>:
80106e72:	6a 00                	push   $0x0
80106e74:	68 c8 00 00 00       	push   $0xc8
80106e79:	e9 ed f1 ff ff       	jmp    8010606b <alltraps>

80106e7e <vector201>:
80106e7e:	6a 00                	push   $0x0
80106e80:	68 c9 00 00 00       	push   $0xc9
80106e85:	e9 e1 f1 ff ff       	jmp    8010606b <alltraps>

80106e8a <vector202>:
80106e8a:	6a 00                	push   $0x0
80106e8c:	68 ca 00 00 00       	push   $0xca
80106e91:	e9 d5 f1 ff ff       	jmp    8010606b <alltraps>

80106e96 <vector203>:
80106e96:	6a 00                	push   $0x0
80106e98:	68 cb 00 00 00       	push   $0xcb
80106e9d:	e9 c9 f1 ff ff       	jmp    8010606b <alltraps>

80106ea2 <vector204>:
80106ea2:	6a 00                	push   $0x0
80106ea4:	68 cc 00 00 00       	push   $0xcc
80106ea9:	e9 bd f1 ff ff       	jmp    8010606b <alltraps>

80106eae <vector205>:
80106eae:	6a 00                	push   $0x0
80106eb0:	68 cd 00 00 00       	push   $0xcd
80106eb5:	e9 b1 f1 ff ff       	jmp    8010606b <alltraps>

80106eba <vector206>:
80106eba:	6a 00                	push   $0x0
80106ebc:	68 ce 00 00 00       	push   $0xce
80106ec1:	e9 a5 f1 ff ff       	jmp    8010606b <alltraps>

80106ec6 <vector207>:
80106ec6:	6a 00                	push   $0x0
80106ec8:	68 cf 00 00 00       	push   $0xcf
80106ecd:	e9 99 f1 ff ff       	jmp    8010606b <alltraps>

80106ed2 <vector208>:
80106ed2:	6a 00                	push   $0x0
80106ed4:	68 d0 00 00 00       	push   $0xd0
80106ed9:	e9 8d f1 ff ff       	jmp    8010606b <alltraps>

80106ede <vector209>:
80106ede:	6a 00                	push   $0x0
80106ee0:	68 d1 00 00 00       	push   $0xd1
80106ee5:	e9 81 f1 ff ff       	jmp    8010606b <alltraps>

80106eea <vector210>:
80106eea:	6a 00                	push   $0x0
80106eec:	68 d2 00 00 00       	push   $0xd2
80106ef1:	e9 75 f1 ff ff       	jmp    8010606b <alltraps>

80106ef6 <vector211>:
80106ef6:	6a 00                	push   $0x0
80106ef8:	68 d3 00 00 00       	push   $0xd3
80106efd:	e9 69 f1 ff ff       	jmp    8010606b <alltraps>

80106f02 <vector212>:
80106f02:	6a 00                	push   $0x0
80106f04:	68 d4 00 00 00       	push   $0xd4
80106f09:	e9 5d f1 ff ff       	jmp    8010606b <alltraps>

80106f0e <vector213>:
80106f0e:	6a 00                	push   $0x0
80106f10:	68 d5 00 00 00       	push   $0xd5
80106f15:	e9 51 f1 ff ff       	jmp    8010606b <alltraps>

80106f1a <vector214>:
80106f1a:	6a 00                	push   $0x0
80106f1c:	68 d6 00 00 00       	push   $0xd6
80106f21:	e9 45 f1 ff ff       	jmp    8010606b <alltraps>

80106f26 <vector215>:
80106f26:	6a 00                	push   $0x0
80106f28:	68 d7 00 00 00       	push   $0xd7
80106f2d:	e9 39 f1 ff ff       	jmp    8010606b <alltraps>

80106f32 <vector216>:
80106f32:	6a 00                	push   $0x0
80106f34:	68 d8 00 00 00       	push   $0xd8
80106f39:	e9 2d f1 ff ff       	jmp    8010606b <alltraps>

80106f3e <vector217>:
80106f3e:	6a 00                	push   $0x0
80106f40:	68 d9 00 00 00       	push   $0xd9
80106f45:	e9 21 f1 ff ff       	jmp    8010606b <alltraps>

80106f4a <vector218>:
80106f4a:	6a 00                	push   $0x0
80106f4c:	68 da 00 00 00       	push   $0xda
80106f51:	e9 15 f1 ff ff       	jmp    8010606b <alltraps>

80106f56 <vector219>:
80106f56:	6a 00                	push   $0x0
80106f58:	68 db 00 00 00       	push   $0xdb
80106f5d:	e9 09 f1 ff ff       	jmp    8010606b <alltraps>

80106f62 <vector220>:
80106f62:	6a 00                	push   $0x0
80106f64:	68 dc 00 00 00       	push   $0xdc
80106f69:	e9 fd f0 ff ff       	jmp    8010606b <alltraps>

80106f6e <vector221>:
80106f6e:	6a 00                	push   $0x0
80106f70:	68 dd 00 00 00       	push   $0xdd
80106f75:	e9 f1 f0 ff ff       	jmp    8010606b <alltraps>

80106f7a <vector222>:
80106f7a:	6a 00                	push   $0x0
80106f7c:	68 de 00 00 00       	push   $0xde
80106f81:	e9 e5 f0 ff ff       	jmp    8010606b <alltraps>

80106f86 <vector223>:
80106f86:	6a 00                	push   $0x0
80106f88:	68 df 00 00 00       	push   $0xdf
80106f8d:	e9 d9 f0 ff ff       	jmp    8010606b <alltraps>

80106f92 <vector224>:
80106f92:	6a 00                	push   $0x0
80106f94:	68 e0 00 00 00       	push   $0xe0
80106f99:	e9 cd f0 ff ff       	jmp    8010606b <alltraps>

80106f9e <vector225>:
80106f9e:	6a 00                	push   $0x0
80106fa0:	68 e1 00 00 00       	push   $0xe1
80106fa5:	e9 c1 f0 ff ff       	jmp    8010606b <alltraps>

80106faa <vector226>:
80106faa:	6a 00                	push   $0x0
80106fac:	68 e2 00 00 00       	push   $0xe2
80106fb1:	e9 b5 f0 ff ff       	jmp    8010606b <alltraps>

80106fb6 <vector227>:
80106fb6:	6a 00                	push   $0x0
80106fb8:	68 e3 00 00 00       	push   $0xe3
80106fbd:	e9 a9 f0 ff ff       	jmp    8010606b <alltraps>

80106fc2 <vector228>:
80106fc2:	6a 00                	push   $0x0
80106fc4:	68 e4 00 00 00       	push   $0xe4
80106fc9:	e9 9d f0 ff ff       	jmp    8010606b <alltraps>

80106fce <vector229>:
80106fce:	6a 00                	push   $0x0
80106fd0:	68 e5 00 00 00       	push   $0xe5
80106fd5:	e9 91 f0 ff ff       	jmp    8010606b <alltraps>

80106fda <vector230>:
80106fda:	6a 00                	push   $0x0
80106fdc:	68 e6 00 00 00       	push   $0xe6
80106fe1:	e9 85 f0 ff ff       	jmp    8010606b <alltraps>

80106fe6 <vector231>:
80106fe6:	6a 00                	push   $0x0
80106fe8:	68 e7 00 00 00       	push   $0xe7
80106fed:	e9 79 f0 ff ff       	jmp    8010606b <alltraps>

80106ff2 <vector232>:
80106ff2:	6a 00                	push   $0x0
80106ff4:	68 e8 00 00 00       	push   $0xe8
80106ff9:	e9 6d f0 ff ff       	jmp    8010606b <alltraps>

80106ffe <vector233>:
80106ffe:	6a 00                	push   $0x0
80107000:	68 e9 00 00 00       	push   $0xe9
80107005:	e9 61 f0 ff ff       	jmp    8010606b <alltraps>

8010700a <vector234>:
8010700a:	6a 00                	push   $0x0
8010700c:	68 ea 00 00 00       	push   $0xea
80107011:	e9 55 f0 ff ff       	jmp    8010606b <alltraps>

80107016 <vector235>:
80107016:	6a 00                	push   $0x0
80107018:	68 eb 00 00 00       	push   $0xeb
8010701d:	e9 49 f0 ff ff       	jmp    8010606b <alltraps>

80107022 <vector236>:
80107022:	6a 00                	push   $0x0
80107024:	68 ec 00 00 00       	push   $0xec
80107029:	e9 3d f0 ff ff       	jmp    8010606b <alltraps>

8010702e <vector237>:
8010702e:	6a 00                	push   $0x0
80107030:	68 ed 00 00 00       	push   $0xed
80107035:	e9 31 f0 ff ff       	jmp    8010606b <alltraps>

8010703a <vector238>:
8010703a:	6a 00                	push   $0x0
8010703c:	68 ee 00 00 00       	push   $0xee
80107041:	e9 25 f0 ff ff       	jmp    8010606b <alltraps>

80107046 <vector239>:
80107046:	6a 00                	push   $0x0
80107048:	68 ef 00 00 00       	push   $0xef
8010704d:	e9 19 f0 ff ff       	jmp    8010606b <alltraps>

80107052 <vector240>:
80107052:	6a 00                	push   $0x0
80107054:	68 f0 00 00 00       	push   $0xf0
80107059:	e9 0d f0 ff ff       	jmp    8010606b <alltraps>

8010705e <vector241>:
8010705e:	6a 00                	push   $0x0
80107060:	68 f1 00 00 00       	push   $0xf1
80107065:	e9 01 f0 ff ff       	jmp    8010606b <alltraps>

8010706a <vector242>:
8010706a:	6a 00                	push   $0x0
8010706c:	68 f2 00 00 00       	push   $0xf2
80107071:	e9 f5 ef ff ff       	jmp    8010606b <alltraps>

80107076 <vector243>:
80107076:	6a 00                	push   $0x0
80107078:	68 f3 00 00 00       	push   $0xf3
8010707d:	e9 e9 ef ff ff       	jmp    8010606b <alltraps>

80107082 <vector244>:
80107082:	6a 00                	push   $0x0
80107084:	68 f4 00 00 00       	push   $0xf4
80107089:	e9 dd ef ff ff       	jmp    8010606b <alltraps>

8010708e <vector245>:
8010708e:	6a 00                	push   $0x0
80107090:	68 f5 00 00 00       	push   $0xf5
80107095:	e9 d1 ef ff ff       	jmp    8010606b <alltraps>

8010709a <vector246>:
8010709a:	6a 00                	push   $0x0
8010709c:	68 f6 00 00 00       	push   $0xf6
801070a1:	e9 c5 ef ff ff       	jmp    8010606b <alltraps>

801070a6 <vector247>:
801070a6:	6a 00                	push   $0x0
801070a8:	68 f7 00 00 00       	push   $0xf7
801070ad:	e9 b9 ef ff ff       	jmp    8010606b <alltraps>

801070b2 <vector248>:
801070b2:	6a 00                	push   $0x0
801070b4:	68 f8 00 00 00       	push   $0xf8
801070b9:	e9 ad ef ff ff       	jmp    8010606b <alltraps>

801070be <vector249>:
801070be:	6a 00                	push   $0x0
801070c0:	68 f9 00 00 00       	push   $0xf9
801070c5:	e9 a1 ef ff ff       	jmp    8010606b <alltraps>

801070ca <vector250>:
801070ca:	6a 00                	push   $0x0
801070cc:	68 fa 00 00 00       	push   $0xfa
801070d1:	e9 95 ef ff ff       	jmp    8010606b <alltraps>

801070d6 <vector251>:
801070d6:	6a 00                	push   $0x0
801070d8:	68 fb 00 00 00       	push   $0xfb
801070dd:	e9 89 ef ff ff       	jmp    8010606b <alltraps>

801070e2 <vector252>:
801070e2:	6a 00                	push   $0x0
801070e4:	68 fc 00 00 00       	push   $0xfc
801070e9:	e9 7d ef ff ff       	jmp    8010606b <alltraps>

801070ee <vector253>:
801070ee:	6a 00                	push   $0x0
801070f0:	68 fd 00 00 00       	push   $0xfd
801070f5:	e9 71 ef ff ff       	jmp    8010606b <alltraps>

801070fa <vector254>:
801070fa:	6a 00                	push   $0x0
801070fc:	68 fe 00 00 00       	push   $0xfe
80107101:	e9 65 ef ff ff       	jmp    8010606b <alltraps>

80107106 <vector255>:
80107106:	6a 00                	push   $0x0
80107108:	68 ff 00 00 00       	push   $0xff
8010710d:	e9 59 ef ff ff       	jmp    8010606b <alltraps>

80107112 <lgdt>:
{
80107112:	55                   	push   %ebp
80107113:	89 e5                	mov    %esp,%ebp
80107115:	83 ec 10             	sub    $0x10,%esp
  pd[0] = size-1;
80107118:	8b 45 0c             	mov    0xc(%ebp),%eax
8010711b:	83 e8 01             	sub    $0x1,%eax
8010711e:	66 89 45 fa          	mov    %ax,-0x6(%ebp)
  pd[1] = (uint)p;
80107122:	8b 45 08             	mov    0x8(%ebp),%eax
80107125:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  pd[2] = (uint)p >> 16;
80107129:	8b 45 08             	mov    0x8(%ebp),%eax
8010712c:	c1 e8 10             	shr    $0x10,%eax
8010712f:	66 89 45 fe          	mov    %ax,-0x2(%ebp)
  asm volatile("lgdt (%0)" : : "r" (pd));
80107133:	8d 45 fa             	lea    -0x6(%ebp),%eax
80107136:	0f 01 10             	lgdtl  (%eax)
}
80107139:	90                   	nop
8010713a:	c9                   	leave  
8010713b:	c3                   	ret    

8010713c <ltr>:
{
8010713c:	55                   	push   %ebp
8010713d:	89 e5                	mov    %esp,%ebp
8010713f:	83 ec 04             	sub    $0x4,%esp
80107142:	8b 45 08             	mov    0x8(%ebp),%eax
80107145:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  asm volatile("ltr %0" : : "r" (sel));
80107149:	0f b7 45 fc          	movzwl -0x4(%ebp),%eax
8010714d:	0f 00 d8             	ltr    %ax
}
80107150:	90                   	nop
80107151:	c9                   	leave  
80107152:	c3                   	ret    

80107153 <lcr3>:

static inline void
lcr3(uint val)
{
80107153:	55                   	push   %ebp
80107154:	89 e5                	mov    %esp,%ebp
  asm volatile("movl %0,%%cr3" : : "r" (val));
80107156:	8b 45 08             	mov    0x8(%ebp),%eax
80107159:	0f 22 d8             	mov    %eax,%cr3
}
8010715c:	90                   	nop
8010715d:	5d                   	pop    %ebp
8010715e:	c3                   	ret    

8010715f <seginit>:
extern struct gpu gpu;
// Set up CPU's kernel segment descriptors.
// Run once on entry on each CPU.
void
seginit(void)
{
8010715f:	55                   	push   %ebp
80107160:	89 e5                	mov    %esp,%ebp
80107162:	83 ec 18             	sub    $0x18,%esp

  // Map "logical" addresses to virtual addresses using identity map.
  // Cannot share a CODE descriptor for both kernel and user
  // because it would have to have DPL_USR, but the CPU forbids
  // an interrupt from CPL=0 to DPL=3.
  c = &cpus[cpuid()];
80107165:	e8 33 c8 ff ff       	call   8010399d <cpuid>
8010716a:	69 c0 b0 00 00 00    	imul   $0xb0,%eax,%eax
80107170:	05 80 6b 19 80       	add    $0x80196b80,%eax
80107175:	89 45 f4             	mov    %eax,-0xc(%ebp)

  c->gdt[SEG_KCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, 0);
80107178:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010717b:	66 c7 40 78 ff ff    	movw   $0xffff,0x78(%eax)
80107181:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107184:	66 c7 40 7a 00 00    	movw   $0x0,0x7a(%eax)
8010718a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010718d:	c6 40 7c 00          	movb   $0x0,0x7c(%eax)
80107191:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107194:	0f b6 50 7d          	movzbl 0x7d(%eax),%edx
80107198:	83 e2 f0             	and    $0xfffffff0,%edx
8010719b:	83 ca 0a             	or     $0xa,%edx
8010719e:	88 50 7d             	mov    %dl,0x7d(%eax)
801071a1:	8b 45 f4             	mov    -0xc(%ebp),%eax
801071a4:	0f b6 50 7d          	movzbl 0x7d(%eax),%edx
801071a8:	83 ca 10             	or     $0x10,%edx
801071ab:	88 50 7d             	mov    %dl,0x7d(%eax)
801071ae:	8b 45 f4             	mov    -0xc(%ebp),%eax
801071b1:	0f b6 50 7d          	movzbl 0x7d(%eax),%edx
801071b5:	83 e2 9f             	and    $0xffffff9f,%edx
801071b8:	88 50 7d             	mov    %dl,0x7d(%eax)
801071bb:	8b 45 f4             	mov    -0xc(%ebp),%eax
801071be:	0f b6 50 7d          	movzbl 0x7d(%eax),%edx
801071c2:	83 ca 80             	or     $0xffffff80,%edx
801071c5:	88 50 7d             	mov    %dl,0x7d(%eax)
801071c8:	8b 45 f4             	mov    -0xc(%ebp),%eax
801071cb:	0f b6 50 7e          	movzbl 0x7e(%eax),%edx
801071cf:	83 ca 0f             	or     $0xf,%edx
801071d2:	88 50 7e             	mov    %dl,0x7e(%eax)
801071d5:	8b 45 f4             	mov    -0xc(%ebp),%eax
801071d8:	0f b6 50 7e          	movzbl 0x7e(%eax),%edx
801071dc:	83 e2 ef             	and    $0xffffffef,%edx
801071df:	88 50 7e             	mov    %dl,0x7e(%eax)
801071e2:	8b 45 f4             	mov    -0xc(%ebp),%eax
801071e5:	0f b6 50 7e          	movzbl 0x7e(%eax),%edx
801071e9:	83 e2 df             	and    $0xffffffdf,%edx
801071ec:	88 50 7e             	mov    %dl,0x7e(%eax)
801071ef:	8b 45 f4             	mov    -0xc(%ebp),%eax
801071f2:	0f b6 50 7e          	movzbl 0x7e(%eax),%edx
801071f6:	83 ca 40             	or     $0x40,%edx
801071f9:	88 50 7e             	mov    %dl,0x7e(%eax)
801071fc:	8b 45 f4             	mov    -0xc(%ebp),%eax
801071ff:	0f b6 50 7e          	movzbl 0x7e(%eax),%edx
80107203:	83 ca 80             	or     $0xffffff80,%edx
80107206:	88 50 7e             	mov    %dl,0x7e(%eax)
80107209:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010720c:	c6 40 7f 00          	movb   $0x0,0x7f(%eax)
  c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
80107210:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107213:	66 c7 80 80 00 00 00 	movw   $0xffff,0x80(%eax)
8010721a:	ff ff 
8010721c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010721f:	66 c7 80 82 00 00 00 	movw   $0x0,0x82(%eax)
80107226:	00 00 
80107228:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010722b:	c6 80 84 00 00 00 00 	movb   $0x0,0x84(%eax)
80107232:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107235:	0f b6 90 85 00 00 00 	movzbl 0x85(%eax),%edx
8010723c:	83 e2 f0             	and    $0xfffffff0,%edx
8010723f:	83 ca 02             	or     $0x2,%edx
80107242:	88 90 85 00 00 00    	mov    %dl,0x85(%eax)
80107248:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010724b:	0f b6 90 85 00 00 00 	movzbl 0x85(%eax),%edx
80107252:	83 ca 10             	or     $0x10,%edx
80107255:	88 90 85 00 00 00    	mov    %dl,0x85(%eax)
8010725b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010725e:	0f b6 90 85 00 00 00 	movzbl 0x85(%eax),%edx
80107265:	83 e2 9f             	and    $0xffffff9f,%edx
80107268:	88 90 85 00 00 00    	mov    %dl,0x85(%eax)
8010726e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107271:	0f b6 90 85 00 00 00 	movzbl 0x85(%eax),%edx
80107278:	83 ca 80             	or     $0xffffff80,%edx
8010727b:	88 90 85 00 00 00    	mov    %dl,0x85(%eax)
80107281:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107284:	0f b6 90 86 00 00 00 	movzbl 0x86(%eax),%edx
8010728b:	83 ca 0f             	or     $0xf,%edx
8010728e:	88 90 86 00 00 00    	mov    %dl,0x86(%eax)
80107294:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107297:	0f b6 90 86 00 00 00 	movzbl 0x86(%eax),%edx
8010729e:	83 e2 ef             	and    $0xffffffef,%edx
801072a1:	88 90 86 00 00 00    	mov    %dl,0x86(%eax)
801072a7:	8b 45 f4             	mov    -0xc(%ebp),%eax
801072aa:	0f b6 90 86 00 00 00 	movzbl 0x86(%eax),%edx
801072b1:	83 e2 df             	and    $0xffffffdf,%edx
801072b4:	88 90 86 00 00 00    	mov    %dl,0x86(%eax)
801072ba:	8b 45 f4             	mov    -0xc(%ebp),%eax
801072bd:	0f b6 90 86 00 00 00 	movzbl 0x86(%eax),%edx
801072c4:	83 ca 40             	or     $0x40,%edx
801072c7:	88 90 86 00 00 00    	mov    %dl,0x86(%eax)
801072cd:	8b 45 f4             	mov    -0xc(%ebp),%eax
801072d0:	0f b6 90 86 00 00 00 	movzbl 0x86(%eax),%edx
801072d7:	83 ca 80             	or     $0xffffff80,%edx
801072da:	88 90 86 00 00 00    	mov    %dl,0x86(%eax)
801072e0:	8b 45 f4             	mov    -0xc(%ebp),%eax
801072e3:	c6 80 87 00 00 00 00 	movb   $0x0,0x87(%eax)
  c->gdt[SEG_UCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, DPL_USER);
801072ea:	8b 45 f4             	mov    -0xc(%ebp),%eax
801072ed:	66 c7 80 88 00 00 00 	movw   $0xffff,0x88(%eax)
801072f4:	ff ff 
801072f6:	8b 45 f4             	mov    -0xc(%ebp),%eax
801072f9:	66 c7 80 8a 00 00 00 	movw   $0x0,0x8a(%eax)
80107300:	00 00 
80107302:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107305:	c6 80 8c 00 00 00 00 	movb   $0x0,0x8c(%eax)
8010730c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010730f:	0f b6 90 8d 00 00 00 	movzbl 0x8d(%eax),%edx
80107316:	83 e2 f0             	and    $0xfffffff0,%edx
80107319:	83 ca 0a             	or     $0xa,%edx
8010731c:	88 90 8d 00 00 00    	mov    %dl,0x8d(%eax)
80107322:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107325:	0f b6 90 8d 00 00 00 	movzbl 0x8d(%eax),%edx
8010732c:	83 ca 10             	or     $0x10,%edx
8010732f:	88 90 8d 00 00 00    	mov    %dl,0x8d(%eax)
80107335:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107338:	0f b6 90 8d 00 00 00 	movzbl 0x8d(%eax),%edx
8010733f:	83 ca 60             	or     $0x60,%edx
80107342:	88 90 8d 00 00 00    	mov    %dl,0x8d(%eax)
80107348:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010734b:	0f b6 90 8d 00 00 00 	movzbl 0x8d(%eax),%edx
80107352:	83 ca 80             	or     $0xffffff80,%edx
80107355:	88 90 8d 00 00 00    	mov    %dl,0x8d(%eax)
8010735b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010735e:	0f b6 90 8e 00 00 00 	movzbl 0x8e(%eax),%edx
80107365:	83 ca 0f             	or     $0xf,%edx
80107368:	88 90 8e 00 00 00    	mov    %dl,0x8e(%eax)
8010736e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107371:	0f b6 90 8e 00 00 00 	movzbl 0x8e(%eax),%edx
80107378:	83 e2 ef             	and    $0xffffffef,%edx
8010737b:	88 90 8e 00 00 00    	mov    %dl,0x8e(%eax)
80107381:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107384:	0f b6 90 8e 00 00 00 	movzbl 0x8e(%eax),%edx
8010738b:	83 e2 df             	and    $0xffffffdf,%edx
8010738e:	88 90 8e 00 00 00    	mov    %dl,0x8e(%eax)
80107394:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107397:	0f b6 90 8e 00 00 00 	movzbl 0x8e(%eax),%edx
8010739e:	83 ca 40             	or     $0x40,%edx
801073a1:	88 90 8e 00 00 00    	mov    %dl,0x8e(%eax)
801073a7:	8b 45 f4             	mov    -0xc(%ebp),%eax
801073aa:	0f b6 90 8e 00 00 00 	movzbl 0x8e(%eax),%edx
801073b1:	83 ca 80             	or     $0xffffff80,%edx
801073b4:	88 90 8e 00 00 00    	mov    %dl,0x8e(%eax)
801073ba:	8b 45 f4             	mov    -0xc(%ebp),%eax
801073bd:	c6 80 8f 00 00 00 00 	movb   $0x0,0x8f(%eax)
  c->gdt[SEG_UDATA] = SEG(STA_W, 0, 0xffffffff, DPL_USER);
801073c4:	8b 45 f4             	mov    -0xc(%ebp),%eax
801073c7:	66 c7 80 90 00 00 00 	movw   $0xffff,0x90(%eax)
801073ce:	ff ff 
801073d0:	8b 45 f4             	mov    -0xc(%ebp),%eax
801073d3:	66 c7 80 92 00 00 00 	movw   $0x0,0x92(%eax)
801073da:	00 00 
801073dc:	8b 45 f4             	mov    -0xc(%ebp),%eax
801073df:	c6 80 94 00 00 00 00 	movb   $0x0,0x94(%eax)
801073e6:	8b 45 f4             	mov    -0xc(%ebp),%eax
801073e9:	0f b6 90 95 00 00 00 	movzbl 0x95(%eax),%edx
801073f0:	83 e2 f0             	and    $0xfffffff0,%edx
801073f3:	83 ca 02             	or     $0x2,%edx
801073f6:	88 90 95 00 00 00    	mov    %dl,0x95(%eax)
801073fc:	8b 45 f4             	mov    -0xc(%ebp),%eax
801073ff:	0f b6 90 95 00 00 00 	movzbl 0x95(%eax),%edx
80107406:	83 ca 10             	or     $0x10,%edx
80107409:	88 90 95 00 00 00    	mov    %dl,0x95(%eax)
8010740f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107412:	0f b6 90 95 00 00 00 	movzbl 0x95(%eax),%edx
80107419:	83 ca 60             	or     $0x60,%edx
8010741c:	88 90 95 00 00 00    	mov    %dl,0x95(%eax)
80107422:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107425:	0f b6 90 95 00 00 00 	movzbl 0x95(%eax),%edx
8010742c:	83 ca 80             	or     $0xffffff80,%edx
8010742f:	88 90 95 00 00 00    	mov    %dl,0x95(%eax)
80107435:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107438:	0f b6 90 96 00 00 00 	movzbl 0x96(%eax),%edx
8010743f:	83 ca 0f             	or     $0xf,%edx
80107442:	88 90 96 00 00 00    	mov    %dl,0x96(%eax)
80107448:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010744b:	0f b6 90 96 00 00 00 	movzbl 0x96(%eax),%edx
80107452:	83 e2 ef             	and    $0xffffffef,%edx
80107455:	88 90 96 00 00 00    	mov    %dl,0x96(%eax)
8010745b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010745e:	0f b6 90 96 00 00 00 	movzbl 0x96(%eax),%edx
80107465:	83 e2 df             	and    $0xffffffdf,%edx
80107468:	88 90 96 00 00 00    	mov    %dl,0x96(%eax)
8010746e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107471:	0f b6 90 96 00 00 00 	movzbl 0x96(%eax),%edx
80107478:	83 ca 40             	or     $0x40,%edx
8010747b:	88 90 96 00 00 00    	mov    %dl,0x96(%eax)
80107481:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107484:	0f b6 90 96 00 00 00 	movzbl 0x96(%eax),%edx
8010748b:	83 ca 80             	or     $0xffffff80,%edx
8010748e:	88 90 96 00 00 00    	mov    %dl,0x96(%eax)
80107494:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107497:	c6 80 97 00 00 00 00 	movb   $0x0,0x97(%eax)
  lgdt(c->gdt, sizeof(c->gdt));
8010749e:	8b 45 f4             	mov    -0xc(%ebp),%eax
801074a1:	83 c0 70             	add    $0x70,%eax
801074a4:	83 ec 08             	sub    $0x8,%esp
801074a7:	6a 30                	push   $0x30
801074a9:	50                   	push   %eax
801074aa:	e8 63 fc ff ff       	call   80107112 <lgdt>
801074af:	83 c4 10             	add    $0x10,%esp
}
801074b2:	90                   	nop
801074b3:	c9                   	leave  
801074b4:	c3                   	ret    

801074b5 <walkpgdir>:
// Return the address of the PTE in page table pgdir
// that corresponds to virtual address va.  If alloc!=0,
// create any required page table pages.
static pte_t *
walkpgdir(pde_t *pgdir, const void *va, int alloc)
{
801074b5:	55                   	push   %ebp
801074b6:	89 e5                	mov    %esp,%ebp
801074b8:	83 ec 18             	sub    $0x18,%esp
  pde_t *pde;
  pte_t *pgtab;

  pde = &pgdir[PDX(va)];
801074bb:	8b 45 0c             	mov    0xc(%ebp),%eax
801074be:	c1 e8 16             	shr    $0x16,%eax
801074c1:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
801074c8:	8b 45 08             	mov    0x8(%ebp),%eax
801074cb:	01 d0                	add    %edx,%eax
801074cd:	89 45 f0             	mov    %eax,-0x10(%ebp)
  if(*pde & PTE_P){
801074d0:	8b 45 f0             	mov    -0x10(%ebp),%eax
801074d3:	8b 00                	mov    (%eax),%eax
801074d5:	83 e0 01             	and    $0x1,%eax
801074d8:	85 c0                	test   %eax,%eax
801074da:	74 14                	je     801074f0 <walkpgdir+0x3b>
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
801074dc:	8b 45 f0             	mov    -0x10(%ebp),%eax
801074df:	8b 00                	mov    (%eax),%eax
801074e1:	25 00 f0 ff ff       	and    $0xfffff000,%eax
801074e6:	05 00 00 00 80       	add    $0x80000000,%eax
801074eb:	89 45 f4             	mov    %eax,-0xc(%ebp)
801074ee:	eb 42                	jmp    80107532 <walkpgdir+0x7d>
  } else {
    if(!alloc || (pgtab = (pte_t*)kalloc()) == 0)
801074f0:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
801074f4:	74 0e                	je     80107504 <walkpgdir+0x4f>
801074f6:	e8 a5 b2 ff ff       	call   801027a0 <kalloc>
801074fb:	89 45 f4             	mov    %eax,-0xc(%ebp)
801074fe:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80107502:	75 07                	jne    8010750b <walkpgdir+0x56>
      return 0;
80107504:	b8 00 00 00 00       	mov    $0x0,%eax
80107509:	eb 3e                	jmp    80107549 <walkpgdir+0x94>
    // Make sure all those PTE_P bits are zero.
    memset(pgtab, 0, PGSIZE);
8010750b:	83 ec 04             	sub    $0x4,%esp
8010750e:	68 00 10 00 00       	push   $0x1000
80107513:	6a 00                	push   $0x0
80107515:	ff 75 f4             	push   -0xc(%ebp)
80107518:	e8 17 d7 ff ff       	call   80104c34 <memset>
8010751d:	83 c4 10             	add    $0x10,%esp
    // The permissions here are overly generous, but they can
    // be further restricted by the permissions in the page table
    // entries, if necessary.
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
80107520:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107523:	05 00 00 00 80       	add    $0x80000000,%eax
80107528:	83 c8 07             	or     $0x7,%eax
8010752b:	89 c2                	mov    %eax,%edx
8010752d:	8b 45 f0             	mov    -0x10(%ebp),%eax
80107530:	89 10                	mov    %edx,(%eax)
  }
  return &pgtab[PTX(va)];
80107532:	8b 45 0c             	mov    0xc(%ebp),%eax
80107535:	c1 e8 0c             	shr    $0xc,%eax
80107538:	25 ff 03 00 00       	and    $0x3ff,%eax
8010753d:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80107544:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107547:	01 d0                	add    %edx,%eax
}
80107549:	c9                   	leave  
8010754a:	c3                   	ret    

8010754b <mappages>:
// Create PTEs for virtual addresses starting at va that refer to
// physical addresses starting at pa. va and size might not
// be page-aligned.
static int
mappages(pde_t *pgdir, void *va, uint size, uint pa, int perm)
{
8010754b:	55                   	push   %ebp
8010754c:	89 e5                	mov    %esp,%ebp
8010754e:	83 ec 18             	sub    $0x18,%esp
  char *a, *last;
  pte_t *pte;

  a = (char*)PGROUNDDOWN((uint)va);
80107551:	8b 45 0c             	mov    0xc(%ebp),%eax
80107554:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80107559:	89 45 f4             	mov    %eax,-0xc(%ebp)
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
8010755c:	8b 55 0c             	mov    0xc(%ebp),%edx
8010755f:	8b 45 10             	mov    0x10(%ebp),%eax
80107562:	01 d0                	add    %edx,%eax
80107564:	83 e8 01             	sub    $0x1,%eax
80107567:	25 00 f0 ff ff       	and    $0xfffff000,%eax
8010756c:	89 45 f0             	mov    %eax,-0x10(%ebp)
  for(;;){
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
8010756f:	83 ec 04             	sub    $0x4,%esp
80107572:	6a 01                	push   $0x1
80107574:	ff 75 f4             	push   -0xc(%ebp)
80107577:	ff 75 08             	push   0x8(%ebp)
8010757a:	e8 36 ff ff ff       	call   801074b5 <walkpgdir>
8010757f:	83 c4 10             	add    $0x10,%esp
80107582:	89 45 ec             	mov    %eax,-0x14(%ebp)
80107585:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
80107589:	75 07                	jne    80107592 <mappages+0x47>
      return -1;
8010758b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80107590:	eb 47                	jmp    801075d9 <mappages+0x8e>
    if(*pte & PTE_P)
80107592:	8b 45 ec             	mov    -0x14(%ebp),%eax
80107595:	8b 00                	mov    (%eax),%eax
80107597:	83 e0 01             	and    $0x1,%eax
8010759a:	85 c0                	test   %eax,%eax
8010759c:	74 0d                	je     801075ab <mappages+0x60>
      panic("remap");
8010759e:	83 ec 0c             	sub    $0xc,%esp
801075a1:	68 a4 a8 10 80       	push   $0x8010a8a4
801075a6:	e8 fe 8f ff ff       	call   801005a9 <panic>
    *pte = pa | perm | PTE_P;
801075ab:	8b 45 18             	mov    0x18(%ebp),%eax
801075ae:	0b 45 14             	or     0x14(%ebp),%eax
801075b1:	83 c8 01             	or     $0x1,%eax
801075b4:	89 c2                	mov    %eax,%edx
801075b6:	8b 45 ec             	mov    -0x14(%ebp),%eax
801075b9:	89 10                	mov    %edx,(%eax)
    if(a == last)
801075bb:	8b 45 f4             	mov    -0xc(%ebp),%eax
801075be:	3b 45 f0             	cmp    -0x10(%ebp),%eax
801075c1:	74 10                	je     801075d3 <mappages+0x88>
      break;
    a += PGSIZE;
801075c3:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
    pa += PGSIZE;
801075ca:	81 45 14 00 10 00 00 	addl   $0x1000,0x14(%ebp)
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
801075d1:	eb 9c                	jmp    8010756f <mappages+0x24>
      break;
801075d3:	90                   	nop
  }
  return 0;
801075d4:	b8 00 00 00 00       	mov    $0x0,%eax
}
801075d9:	c9                   	leave  
801075da:	c3                   	ret    

801075db <setupkvm>:
};

// Set up kernel part of a page table.
pde_t*
setupkvm(void)
{
801075db:	55                   	push   %ebp
801075dc:	89 e5                	mov    %esp,%ebp
801075de:	53                   	push   %ebx
801075df:	83 ec 24             	sub    $0x24,%esp
  pde_t *pgdir;
  struct kmap *k;
  k = kmap;
801075e2:	c7 45 f4 a0 f4 10 80 	movl   $0x8010f4a0,-0xc(%ebp)
  struct kmap vram = { (void*)(DEVSPACE - gpu.vram_size),gpu.pvram_addr,gpu.pvram_addr+gpu.vram_size, PTE_W};
801075e9:	8b 15 50 6e 19 80    	mov    0x80196e50,%edx
801075ef:	b8 00 00 00 fe       	mov    $0xfe000000,%eax
801075f4:	29 d0                	sub    %edx,%eax
801075f6:	89 45 e0             	mov    %eax,-0x20(%ebp)
801075f9:	a1 48 6e 19 80       	mov    0x80196e48,%eax
801075fe:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80107601:	8b 15 48 6e 19 80    	mov    0x80196e48,%edx
80107607:	a1 50 6e 19 80       	mov    0x80196e50,%eax
8010760c:	01 d0                	add    %edx,%eax
8010760e:	89 45 e8             	mov    %eax,-0x18(%ebp)
80107611:	c7 45 ec 02 00 00 00 	movl   $0x2,-0x14(%ebp)
  k[3] = vram;
80107618:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010761b:	83 c0 30             	add    $0x30,%eax
8010761e:	8b 55 e0             	mov    -0x20(%ebp),%edx
80107621:	89 10                	mov    %edx,(%eax)
80107623:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80107626:	89 50 04             	mov    %edx,0x4(%eax)
80107629:	8b 55 e8             	mov    -0x18(%ebp),%edx
8010762c:	89 50 08             	mov    %edx,0x8(%eax)
8010762f:	8b 55 ec             	mov    -0x14(%ebp),%edx
80107632:	89 50 0c             	mov    %edx,0xc(%eax)
  if((pgdir = (pde_t*)kalloc()) == 0){
80107635:	e8 66 b1 ff ff       	call   801027a0 <kalloc>
8010763a:	89 45 f0             	mov    %eax,-0x10(%ebp)
8010763d:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80107641:	75 07                	jne    8010764a <setupkvm+0x6f>
    return 0;
80107643:	b8 00 00 00 00       	mov    $0x0,%eax
80107648:	eb 78                	jmp    801076c2 <setupkvm+0xe7>
  }
  memset(pgdir, 0, PGSIZE);
8010764a:	83 ec 04             	sub    $0x4,%esp
8010764d:	68 00 10 00 00       	push   $0x1000
80107652:	6a 00                	push   $0x0
80107654:	ff 75 f0             	push   -0x10(%ebp)
80107657:	e8 d8 d5 ff ff       	call   80104c34 <memset>
8010765c:	83 c4 10             	add    $0x10,%esp
  if (P2V(PHYSTOP) > (void*)DEVSPACE)
    panic("PHYSTOP too high");
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
8010765f:	c7 45 f4 a0 f4 10 80 	movl   $0x8010f4a0,-0xc(%ebp)
80107666:	eb 4e                	jmp    801076b6 <setupkvm+0xdb>
    if(mappages(pgdir, k->virt, k->phys_end - k->phys_start,
80107668:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010766b:	8b 48 0c             	mov    0xc(%eax),%ecx
                (uint)k->phys_start, k->perm) < 0) {
8010766e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107671:	8b 50 04             	mov    0x4(%eax),%edx
    if(mappages(pgdir, k->virt, k->phys_end - k->phys_start,
80107674:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107677:	8b 58 08             	mov    0x8(%eax),%ebx
8010767a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010767d:	8b 40 04             	mov    0x4(%eax),%eax
80107680:	29 c3                	sub    %eax,%ebx
80107682:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107685:	8b 00                	mov    (%eax),%eax
80107687:	83 ec 0c             	sub    $0xc,%esp
8010768a:	51                   	push   %ecx
8010768b:	52                   	push   %edx
8010768c:	53                   	push   %ebx
8010768d:	50                   	push   %eax
8010768e:	ff 75 f0             	push   -0x10(%ebp)
80107691:	e8 b5 fe ff ff       	call   8010754b <mappages>
80107696:	83 c4 20             	add    $0x20,%esp
80107699:	85 c0                	test   %eax,%eax
8010769b:	79 15                	jns    801076b2 <setupkvm+0xd7>
      freevm(pgdir);
8010769d:	83 ec 0c             	sub    $0xc,%esp
801076a0:	ff 75 f0             	push   -0x10(%ebp)
801076a3:	e8 f5 04 00 00       	call   80107b9d <freevm>
801076a8:	83 c4 10             	add    $0x10,%esp
      return 0;
801076ab:	b8 00 00 00 00       	mov    $0x0,%eax
801076b0:	eb 10                	jmp    801076c2 <setupkvm+0xe7>
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
801076b2:	83 45 f4 10          	addl   $0x10,-0xc(%ebp)
801076b6:	81 7d f4 00 f5 10 80 	cmpl   $0x8010f500,-0xc(%ebp)
801076bd:	72 a9                	jb     80107668 <setupkvm+0x8d>
    }
  return pgdir;
801076bf:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
801076c2:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801076c5:	c9                   	leave  
801076c6:	c3                   	ret    

801076c7 <kvmalloc>:

// Allocate one page table for the machine for the kernel address
// space for scheduler processes.
void
kvmalloc(void)
{
801076c7:	55                   	push   %ebp
801076c8:	89 e5                	mov    %esp,%ebp
801076ca:	83 ec 08             	sub    $0x8,%esp
  kpgdir = setupkvm();
801076cd:	e8 09 ff ff ff       	call   801075db <setupkvm>
801076d2:	a3 7c 6b 19 80       	mov    %eax,0x80196b7c
  switchkvm();
801076d7:	e8 03 00 00 00       	call   801076df <switchkvm>
}
801076dc:	90                   	nop
801076dd:	c9                   	leave  
801076de:	c3                   	ret    

801076df <switchkvm>:

// Switch h/w page table register to the kernel-only page table,
// for when no process is running.
void
switchkvm(void)
{
801076df:	55                   	push   %ebp
801076e0:	89 e5                	mov    %esp,%ebp
  lcr3(V2P(kpgdir));   // switch to the kernel page table
801076e2:	a1 7c 6b 19 80       	mov    0x80196b7c,%eax
801076e7:	05 00 00 00 80       	add    $0x80000000,%eax
801076ec:	50                   	push   %eax
801076ed:	e8 61 fa ff ff       	call   80107153 <lcr3>
801076f2:	83 c4 04             	add    $0x4,%esp
}
801076f5:	90                   	nop
801076f6:	c9                   	leave  
801076f7:	c3                   	ret    

801076f8 <switchuvm>:

// Switch TSS and h/w page table to correspond to process p.
void
switchuvm(struct proc *p)
{
801076f8:	55                   	push   %ebp
801076f9:	89 e5                	mov    %esp,%ebp
801076fb:	56                   	push   %esi
801076fc:	53                   	push   %ebx
801076fd:	83 ec 10             	sub    $0x10,%esp
  if(p == 0)
80107700:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
80107704:	75 0d                	jne    80107713 <switchuvm+0x1b>
    panic("switchuvm: no process");
80107706:	83 ec 0c             	sub    $0xc,%esp
80107709:	68 aa a8 10 80       	push   $0x8010a8aa
8010770e:	e8 96 8e ff ff       	call   801005a9 <panic>
  if(p->kstack == 0)
80107713:	8b 45 08             	mov    0x8(%ebp),%eax
80107716:	8b 40 08             	mov    0x8(%eax),%eax
80107719:	85 c0                	test   %eax,%eax
8010771b:	75 0d                	jne    8010772a <switchuvm+0x32>
    panic("switchuvm: no kstack");
8010771d:	83 ec 0c             	sub    $0xc,%esp
80107720:	68 c0 a8 10 80       	push   $0x8010a8c0
80107725:	e8 7f 8e ff ff       	call   801005a9 <panic>
  if(p->pgdir == 0)
8010772a:	8b 45 08             	mov    0x8(%ebp),%eax
8010772d:	8b 40 04             	mov    0x4(%eax),%eax
80107730:	85 c0                	test   %eax,%eax
80107732:	75 0d                	jne    80107741 <switchuvm+0x49>
    panic("switchuvm: no pgdir");
80107734:	83 ec 0c             	sub    $0xc,%esp
80107737:	68 d5 a8 10 80       	push   $0x8010a8d5
8010773c:	e8 68 8e ff ff       	call   801005a9 <panic>

  pushcli();
80107741:	e8 e3 d3 ff ff       	call   80104b29 <pushcli>
  mycpu()->gdt[SEG_TSS] = SEG16(STS_T32A, &mycpu()->ts,
80107746:	e8 6d c2 ff ff       	call   801039b8 <mycpu>
8010774b:	89 c3                	mov    %eax,%ebx
8010774d:	e8 66 c2 ff ff       	call   801039b8 <mycpu>
80107752:	83 c0 08             	add    $0x8,%eax
80107755:	89 c6                	mov    %eax,%esi
80107757:	e8 5c c2 ff ff       	call   801039b8 <mycpu>
8010775c:	83 c0 08             	add    $0x8,%eax
8010775f:	c1 e8 10             	shr    $0x10,%eax
80107762:	88 45 f7             	mov    %al,-0x9(%ebp)
80107765:	e8 4e c2 ff ff       	call   801039b8 <mycpu>
8010776a:	83 c0 08             	add    $0x8,%eax
8010776d:	c1 e8 18             	shr    $0x18,%eax
80107770:	89 c2                	mov    %eax,%edx
80107772:	66 c7 83 98 00 00 00 	movw   $0x67,0x98(%ebx)
80107779:	67 00 
8010777b:	66 89 b3 9a 00 00 00 	mov    %si,0x9a(%ebx)
80107782:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
80107786:	88 83 9c 00 00 00    	mov    %al,0x9c(%ebx)
8010778c:	0f b6 83 9d 00 00 00 	movzbl 0x9d(%ebx),%eax
80107793:	83 e0 f0             	and    $0xfffffff0,%eax
80107796:	83 c8 09             	or     $0x9,%eax
80107799:	88 83 9d 00 00 00    	mov    %al,0x9d(%ebx)
8010779f:	0f b6 83 9d 00 00 00 	movzbl 0x9d(%ebx),%eax
801077a6:	83 c8 10             	or     $0x10,%eax
801077a9:	88 83 9d 00 00 00    	mov    %al,0x9d(%ebx)
801077af:	0f b6 83 9d 00 00 00 	movzbl 0x9d(%ebx),%eax
801077b6:	83 e0 9f             	and    $0xffffff9f,%eax
801077b9:	88 83 9d 00 00 00    	mov    %al,0x9d(%ebx)
801077bf:	0f b6 83 9d 00 00 00 	movzbl 0x9d(%ebx),%eax
801077c6:	83 c8 80             	or     $0xffffff80,%eax
801077c9:	88 83 9d 00 00 00    	mov    %al,0x9d(%ebx)
801077cf:	0f b6 83 9e 00 00 00 	movzbl 0x9e(%ebx),%eax
801077d6:	83 e0 f0             	and    $0xfffffff0,%eax
801077d9:	88 83 9e 00 00 00    	mov    %al,0x9e(%ebx)
801077df:	0f b6 83 9e 00 00 00 	movzbl 0x9e(%ebx),%eax
801077e6:	83 e0 ef             	and    $0xffffffef,%eax
801077e9:	88 83 9e 00 00 00    	mov    %al,0x9e(%ebx)
801077ef:	0f b6 83 9e 00 00 00 	movzbl 0x9e(%ebx),%eax
801077f6:	83 e0 df             	and    $0xffffffdf,%eax
801077f9:	88 83 9e 00 00 00    	mov    %al,0x9e(%ebx)
801077ff:	0f b6 83 9e 00 00 00 	movzbl 0x9e(%ebx),%eax
80107806:	83 c8 40             	or     $0x40,%eax
80107809:	88 83 9e 00 00 00    	mov    %al,0x9e(%ebx)
8010780f:	0f b6 83 9e 00 00 00 	movzbl 0x9e(%ebx),%eax
80107816:	83 e0 7f             	and    $0x7f,%eax
80107819:	88 83 9e 00 00 00    	mov    %al,0x9e(%ebx)
8010781f:	88 93 9f 00 00 00    	mov    %dl,0x9f(%ebx)
                                sizeof(mycpu()->ts)-1, 0);
  mycpu()->gdt[SEG_TSS].s = 0;
80107825:	e8 8e c1 ff ff       	call   801039b8 <mycpu>
8010782a:	0f b6 90 9d 00 00 00 	movzbl 0x9d(%eax),%edx
80107831:	83 e2 ef             	and    $0xffffffef,%edx
80107834:	88 90 9d 00 00 00    	mov    %dl,0x9d(%eax)
  mycpu()->ts.ss0 = SEG_KDATA << 3;
8010783a:	e8 79 c1 ff ff       	call   801039b8 <mycpu>
8010783f:	66 c7 40 10 10 00    	movw   $0x10,0x10(%eax)
  mycpu()->ts.esp0 = (uint)p->kstack + KSTACKSIZE;
80107845:	8b 45 08             	mov    0x8(%ebp),%eax
80107848:	8b 40 08             	mov    0x8(%eax),%eax
8010784b:	89 c3                	mov    %eax,%ebx
8010784d:	e8 66 c1 ff ff       	call   801039b8 <mycpu>
80107852:	8d 93 00 10 00 00    	lea    0x1000(%ebx),%edx
80107858:	89 50 0c             	mov    %edx,0xc(%eax)
  // setting IOPL=0 in eflags *and* iomb beyond the tss segment limit
  // forbids I/O instructions (e.g., inb and outb) from user space
  mycpu()->ts.iomb = (ushort) 0xFFFF;
8010785b:	e8 58 c1 ff ff       	call   801039b8 <mycpu>
80107860:	66 c7 40 6e ff ff    	movw   $0xffff,0x6e(%eax)
  ltr(SEG_TSS << 3);
80107866:	83 ec 0c             	sub    $0xc,%esp
80107869:	6a 28                	push   $0x28
8010786b:	e8 cc f8 ff ff       	call   8010713c <ltr>
80107870:	83 c4 10             	add    $0x10,%esp
  lcr3(V2P(p->pgdir));  // switch to process's address space
80107873:	8b 45 08             	mov    0x8(%ebp),%eax
80107876:	8b 40 04             	mov    0x4(%eax),%eax
80107879:	05 00 00 00 80       	add    $0x80000000,%eax
8010787e:	83 ec 0c             	sub    $0xc,%esp
80107881:	50                   	push   %eax
80107882:	e8 cc f8 ff ff       	call   80107153 <lcr3>
80107887:	83 c4 10             	add    $0x10,%esp
  popcli();
8010788a:	e8 e7 d2 ff ff       	call   80104b76 <popcli>
}
8010788f:	90                   	nop
80107890:	8d 65 f8             	lea    -0x8(%ebp),%esp
80107893:	5b                   	pop    %ebx
80107894:	5e                   	pop    %esi
80107895:	5d                   	pop    %ebp
80107896:	c3                   	ret    

80107897 <inituvm>:

// Load the initcode into address 0 of pgdir.
// sz must be less than a page.
void
inituvm(pde_t *pgdir, char *init, uint sz)
{
80107897:	55                   	push   %ebp
80107898:	89 e5                	mov    %esp,%ebp
8010789a:	83 ec 18             	sub    $0x18,%esp
  char *mem;

  if(sz >= PGSIZE)
8010789d:	81 7d 10 ff 0f 00 00 	cmpl   $0xfff,0x10(%ebp)
801078a4:	76 0d                	jbe    801078b3 <inituvm+0x1c>
    panic("inituvm: more than a page");
801078a6:	83 ec 0c             	sub    $0xc,%esp
801078a9:	68 e9 a8 10 80       	push   $0x8010a8e9
801078ae:	e8 f6 8c ff ff       	call   801005a9 <panic>
  mem = kalloc();
801078b3:	e8 e8 ae ff ff       	call   801027a0 <kalloc>
801078b8:	89 45 f4             	mov    %eax,-0xc(%ebp)
  memset(mem, 0, PGSIZE);
801078bb:	83 ec 04             	sub    $0x4,%esp
801078be:	68 00 10 00 00       	push   $0x1000
801078c3:	6a 00                	push   $0x0
801078c5:	ff 75 f4             	push   -0xc(%ebp)
801078c8:	e8 67 d3 ff ff       	call   80104c34 <memset>
801078cd:	83 c4 10             	add    $0x10,%esp
  mappages(pgdir, 0, PGSIZE, V2P(mem), PTE_W|PTE_U);
801078d0:	8b 45 f4             	mov    -0xc(%ebp),%eax
801078d3:	05 00 00 00 80       	add    $0x80000000,%eax
801078d8:	83 ec 0c             	sub    $0xc,%esp
801078db:	6a 06                	push   $0x6
801078dd:	50                   	push   %eax
801078de:	68 00 10 00 00       	push   $0x1000
801078e3:	6a 00                	push   $0x0
801078e5:	ff 75 08             	push   0x8(%ebp)
801078e8:	e8 5e fc ff ff       	call   8010754b <mappages>
801078ed:	83 c4 20             	add    $0x20,%esp
  memmove(mem, init, sz);
801078f0:	83 ec 04             	sub    $0x4,%esp
801078f3:	ff 75 10             	push   0x10(%ebp)
801078f6:	ff 75 0c             	push   0xc(%ebp)
801078f9:	ff 75 f4             	push   -0xc(%ebp)
801078fc:	e8 f2 d3 ff ff       	call   80104cf3 <memmove>
80107901:	83 c4 10             	add    $0x10,%esp
}
80107904:	90                   	nop
80107905:	c9                   	leave  
80107906:	c3                   	ret    

80107907 <loaduvm>:

// Load a program segment into pgdir.  addr must be page-aligned
// and the pages from addr to addr+sz must already be mapped.
int
loaduvm(pde_t *pgdir, char *addr, struct inode *ip, uint offset, uint sz)
{
80107907:	55                   	push   %ebp
80107908:	89 e5                	mov    %esp,%ebp
8010790a:	83 ec 18             	sub    $0x18,%esp
  uint i, pa, n;
  pte_t *pte;

  if((uint) addr % PGSIZE != 0)
8010790d:	8b 45 0c             	mov    0xc(%ebp),%eax
80107910:	25 ff 0f 00 00       	and    $0xfff,%eax
80107915:	85 c0                	test   %eax,%eax
80107917:	74 0d                	je     80107926 <loaduvm+0x1f>
    panic("loaduvm: addr must be page aligned");
80107919:	83 ec 0c             	sub    $0xc,%esp
8010791c:	68 04 a9 10 80       	push   $0x8010a904
80107921:	e8 83 8c ff ff       	call   801005a9 <panic>
  for(i = 0; i < sz; i += PGSIZE){
80107926:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
8010792d:	e9 8f 00 00 00       	jmp    801079c1 <loaduvm+0xba>
    if((pte = walkpgdir(pgdir, addr+i, 0)) == 0)
80107932:	8b 55 0c             	mov    0xc(%ebp),%edx
80107935:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107938:	01 d0                	add    %edx,%eax
8010793a:	83 ec 04             	sub    $0x4,%esp
8010793d:	6a 00                	push   $0x0
8010793f:	50                   	push   %eax
80107940:	ff 75 08             	push   0x8(%ebp)
80107943:	e8 6d fb ff ff       	call   801074b5 <walkpgdir>
80107948:	83 c4 10             	add    $0x10,%esp
8010794b:	89 45 ec             	mov    %eax,-0x14(%ebp)
8010794e:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
80107952:	75 0d                	jne    80107961 <loaduvm+0x5a>
      panic("loaduvm: address should exist");
80107954:	83 ec 0c             	sub    $0xc,%esp
80107957:	68 27 a9 10 80       	push   $0x8010a927
8010795c:	e8 48 8c ff ff       	call   801005a9 <panic>
    pa = PTE_ADDR(*pte);
80107961:	8b 45 ec             	mov    -0x14(%ebp),%eax
80107964:	8b 00                	mov    (%eax),%eax
80107966:	25 00 f0 ff ff       	and    $0xfffff000,%eax
8010796b:	89 45 e8             	mov    %eax,-0x18(%ebp)
    if(sz - i < PGSIZE)
8010796e:	8b 45 18             	mov    0x18(%ebp),%eax
80107971:	2b 45 f4             	sub    -0xc(%ebp),%eax
80107974:	3d ff 0f 00 00       	cmp    $0xfff,%eax
80107979:	77 0b                	ja     80107986 <loaduvm+0x7f>
      n = sz - i;
8010797b:	8b 45 18             	mov    0x18(%ebp),%eax
8010797e:	2b 45 f4             	sub    -0xc(%ebp),%eax
80107981:	89 45 f0             	mov    %eax,-0x10(%ebp)
80107984:	eb 07                	jmp    8010798d <loaduvm+0x86>
    else
      n = PGSIZE;
80107986:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
    if(readi(ip, P2V(pa), offset+i, n) != n)
8010798d:	8b 55 14             	mov    0x14(%ebp),%edx
80107990:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107993:	01 d0                	add    %edx,%eax
80107995:	8b 55 e8             	mov    -0x18(%ebp),%edx
80107998:	81 c2 00 00 00 80    	add    $0x80000000,%edx
8010799e:	ff 75 f0             	push   -0x10(%ebp)
801079a1:	50                   	push   %eax
801079a2:	52                   	push   %edx
801079a3:	ff 75 10             	push   0x10(%ebp)
801079a6:	e8 2b a5 ff ff       	call   80101ed6 <readi>
801079ab:	83 c4 10             	add    $0x10,%esp
801079ae:	39 45 f0             	cmp    %eax,-0x10(%ebp)
801079b1:	74 07                	je     801079ba <loaduvm+0xb3>
      return -1;
801079b3:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801079b8:	eb 18                	jmp    801079d2 <loaduvm+0xcb>
  for(i = 0; i < sz; i += PGSIZE){
801079ba:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
801079c1:	8b 45 f4             	mov    -0xc(%ebp),%eax
801079c4:	3b 45 18             	cmp    0x18(%ebp),%eax
801079c7:	0f 82 65 ff ff ff    	jb     80107932 <loaduvm+0x2b>
  }
  return 0;
801079cd:	b8 00 00 00 00       	mov    $0x0,%eax
}
801079d2:	c9                   	leave  
801079d3:	c3                   	ret    

801079d4 <allocuvm>:

// Allocate page tables and physical memory to grow process from oldsz to
// newsz, which need not be page aligned.  Returns new size or 0 on error.
int
allocuvm(pde_t *pgdir, uint oldsz, uint newsz)
{
801079d4:	55                   	push   %ebp
801079d5:	89 e5                	mov    %esp,%ebp
801079d7:	83 ec 18             	sub    $0x18,%esp
  char *mem;
  uint a;

  if(newsz >= KERNBASE)
801079da:	8b 45 10             	mov    0x10(%ebp),%eax
801079dd:	85 c0                	test   %eax,%eax
801079df:	79 0a                	jns    801079eb <allocuvm+0x17>
    return 0;
801079e1:	b8 00 00 00 00       	mov    $0x0,%eax
801079e6:	e9 ec 00 00 00       	jmp    80107ad7 <allocuvm+0x103>
  if(newsz < oldsz)
801079eb:	8b 45 10             	mov    0x10(%ebp),%eax
801079ee:	3b 45 0c             	cmp    0xc(%ebp),%eax
801079f1:	73 08                	jae    801079fb <allocuvm+0x27>
    return oldsz;
801079f3:	8b 45 0c             	mov    0xc(%ebp),%eax
801079f6:	e9 dc 00 00 00       	jmp    80107ad7 <allocuvm+0x103>

  a = PGROUNDUP(oldsz);
801079fb:	8b 45 0c             	mov    0xc(%ebp),%eax
801079fe:	05 ff 0f 00 00       	add    $0xfff,%eax
80107a03:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80107a08:	89 45 f4             	mov    %eax,-0xc(%ebp)
  for(; a < newsz; a += PGSIZE){
80107a0b:	e9 b8 00 00 00       	jmp    80107ac8 <allocuvm+0xf4>
    mem = kalloc();
80107a10:	e8 8b ad ff ff       	call   801027a0 <kalloc>
80107a15:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(mem == 0){
80107a18:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80107a1c:	75 2e                	jne    80107a4c <allocuvm+0x78>
      cprintf("allocuvm out of memory\n");
80107a1e:	83 ec 0c             	sub    $0xc,%esp
80107a21:	68 45 a9 10 80       	push   $0x8010a945
80107a26:	e8 c9 89 ff ff       	call   801003f4 <cprintf>
80107a2b:	83 c4 10             	add    $0x10,%esp
      deallocuvm(pgdir, newsz, oldsz);
80107a2e:	83 ec 04             	sub    $0x4,%esp
80107a31:	ff 75 0c             	push   0xc(%ebp)
80107a34:	ff 75 10             	push   0x10(%ebp)
80107a37:	ff 75 08             	push   0x8(%ebp)
80107a3a:	e8 9a 00 00 00       	call   80107ad9 <deallocuvm>
80107a3f:	83 c4 10             	add    $0x10,%esp
      return 0;
80107a42:	b8 00 00 00 00       	mov    $0x0,%eax
80107a47:	e9 8b 00 00 00       	jmp    80107ad7 <allocuvm+0x103>
    }
    memset(mem, 0, PGSIZE);
80107a4c:	83 ec 04             	sub    $0x4,%esp
80107a4f:	68 00 10 00 00       	push   $0x1000
80107a54:	6a 00                	push   $0x0
80107a56:	ff 75 f0             	push   -0x10(%ebp)
80107a59:	e8 d6 d1 ff ff       	call   80104c34 <memset>
80107a5e:	83 c4 10             	add    $0x10,%esp
    if(mappages(pgdir, (char*)a, PGSIZE, V2P(mem), PTE_W|PTE_U) < 0){
80107a61:	8b 45 f0             	mov    -0x10(%ebp),%eax
80107a64:	8d 90 00 00 00 80    	lea    -0x80000000(%eax),%edx
80107a6a:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107a6d:	83 ec 0c             	sub    $0xc,%esp
80107a70:	6a 06                	push   $0x6
80107a72:	52                   	push   %edx
80107a73:	68 00 10 00 00       	push   $0x1000
80107a78:	50                   	push   %eax
80107a79:	ff 75 08             	push   0x8(%ebp)
80107a7c:	e8 ca fa ff ff       	call   8010754b <mappages>
80107a81:	83 c4 20             	add    $0x20,%esp
80107a84:	85 c0                	test   %eax,%eax
80107a86:	79 39                	jns    80107ac1 <allocuvm+0xed>
      cprintf("allocuvm out of memory (2)\n");
80107a88:	83 ec 0c             	sub    $0xc,%esp
80107a8b:	68 5d a9 10 80       	push   $0x8010a95d
80107a90:	e8 5f 89 ff ff       	call   801003f4 <cprintf>
80107a95:	83 c4 10             	add    $0x10,%esp
      deallocuvm(pgdir, newsz, oldsz);
80107a98:	83 ec 04             	sub    $0x4,%esp
80107a9b:	ff 75 0c             	push   0xc(%ebp)
80107a9e:	ff 75 10             	push   0x10(%ebp)
80107aa1:	ff 75 08             	push   0x8(%ebp)
80107aa4:	e8 30 00 00 00       	call   80107ad9 <deallocuvm>
80107aa9:	83 c4 10             	add    $0x10,%esp
      kfree(mem);
80107aac:	83 ec 0c             	sub    $0xc,%esp
80107aaf:	ff 75 f0             	push   -0x10(%ebp)
80107ab2:	e8 4f ac ff ff       	call   80102706 <kfree>
80107ab7:	83 c4 10             	add    $0x10,%esp
      return 0;
80107aba:	b8 00 00 00 00       	mov    $0x0,%eax
80107abf:	eb 16                	jmp    80107ad7 <allocuvm+0x103>
  for(; a < newsz; a += PGSIZE){
80107ac1:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
80107ac8:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107acb:	3b 45 10             	cmp    0x10(%ebp),%eax
80107ace:	0f 82 3c ff ff ff    	jb     80107a10 <allocuvm+0x3c>
    }
  }
  return newsz;
80107ad4:	8b 45 10             	mov    0x10(%ebp),%eax
}
80107ad7:	c9                   	leave  
80107ad8:	c3                   	ret    

80107ad9 <deallocuvm>:
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
int
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
{
80107ad9:	55                   	push   %ebp
80107ada:	89 e5                	mov    %esp,%ebp
80107adc:	83 ec 18             	sub    $0x18,%esp
  pte_t *pte;
  uint a, pa;

  if(newsz >= oldsz)
80107adf:	8b 45 10             	mov    0x10(%ebp),%eax
80107ae2:	3b 45 0c             	cmp    0xc(%ebp),%eax
80107ae5:	72 08                	jb     80107aef <deallocuvm+0x16>
    return oldsz;
80107ae7:	8b 45 0c             	mov    0xc(%ebp),%eax
80107aea:	e9 ac 00 00 00       	jmp    80107b9b <deallocuvm+0xc2>

  a = PGROUNDUP(newsz);
80107aef:	8b 45 10             	mov    0x10(%ebp),%eax
80107af2:	05 ff 0f 00 00       	add    $0xfff,%eax
80107af7:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80107afc:	89 45 f4             	mov    %eax,-0xc(%ebp)
  for(; a  < oldsz; a += PGSIZE){
80107aff:	e9 88 00 00 00       	jmp    80107b8c <deallocuvm+0xb3>
    pte = walkpgdir(pgdir, (char*)a, 0);
80107b04:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107b07:	83 ec 04             	sub    $0x4,%esp
80107b0a:	6a 00                	push   $0x0
80107b0c:	50                   	push   %eax
80107b0d:	ff 75 08             	push   0x8(%ebp)
80107b10:	e8 a0 f9 ff ff       	call   801074b5 <walkpgdir>
80107b15:	83 c4 10             	add    $0x10,%esp
80107b18:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(!pte)
80107b1b:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80107b1f:	75 16                	jne    80107b37 <deallocuvm+0x5e>
      a = PGADDR(PDX(a) + 1, 0, 0) - PGSIZE;
80107b21:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107b24:	c1 e8 16             	shr    $0x16,%eax
80107b27:	83 c0 01             	add    $0x1,%eax
80107b2a:	c1 e0 16             	shl    $0x16,%eax
80107b2d:	2d 00 10 00 00       	sub    $0x1000,%eax
80107b32:	89 45 f4             	mov    %eax,-0xc(%ebp)
80107b35:	eb 4e                	jmp    80107b85 <deallocuvm+0xac>
    else if((*pte & PTE_P) != 0){
80107b37:	8b 45 f0             	mov    -0x10(%ebp),%eax
80107b3a:	8b 00                	mov    (%eax),%eax
80107b3c:	83 e0 01             	and    $0x1,%eax
80107b3f:	85 c0                	test   %eax,%eax
80107b41:	74 42                	je     80107b85 <deallocuvm+0xac>
      pa = PTE_ADDR(*pte);
80107b43:	8b 45 f0             	mov    -0x10(%ebp),%eax
80107b46:	8b 00                	mov    (%eax),%eax
80107b48:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80107b4d:	89 45 ec             	mov    %eax,-0x14(%ebp)
      if(pa == 0)
80107b50:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
80107b54:	75 0d                	jne    80107b63 <deallocuvm+0x8a>
        panic("kfree");
80107b56:	83 ec 0c             	sub    $0xc,%esp
80107b59:	68 79 a9 10 80       	push   $0x8010a979
80107b5e:	e8 46 8a ff ff       	call   801005a9 <panic>
      char *v = P2V(pa);
80107b63:	8b 45 ec             	mov    -0x14(%ebp),%eax
80107b66:	05 00 00 00 80       	add    $0x80000000,%eax
80107b6b:	89 45 e8             	mov    %eax,-0x18(%ebp)
      kfree(v);
80107b6e:	83 ec 0c             	sub    $0xc,%esp
80107b71:	ff 75 e8             	push   -0x18(%ebp)
80107b74:	e8 8d ab ff ff       	call   80102706 <kfree>
80107b79:	83 c4 10             	add    $0x10,%esp
      *pte = 0;
80107b7c:	8b 45 f0             	mov    -0x10(%ebp),%eax
80107b7f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  for(; a  < oldsz; a += PGSIZE){
80107b85:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
80107b8c:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107b8f:	3b 45 0c             	cmp    0xc(%ebp),%eax
80107b92:	0f 82 6c ff ff ff    	jb     80107b04 <deallocuvm+0x2b>
    }
  }
  return newsz;
80107b98:	8b 45 10             	mov    0x10(%ebp),%eax
}
80107b9b:	c9                   	leave  
80107b9c:	c3                   	ret    

80107b9d <freevm>:

// Free a page table and all the physical memory pages
// in the user part.
void
freevm(pde_t *pgdir)
{
80107b9d:	55                   	push   %ebp
80107b9e:	89 e5                	mov    %esp,%ebp
80107ba0:	83 ec 18             	sub    $0x18,%esp
  uint i;

  if(pgdir == 0)
80107ba3:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
80107ba7:	75 0d                	jne    80107bb6 <freevm+0x19>
    panic("freevm: no pgdir");
80107ba9:	83 ec 0c             	sub    $0xc,%esp
80107bac:	68 7f a9 10 80       	push   $0x8010a97f
80107bb1:	e8 f3 89 ff ff       	call   801005a9 <panic>
  deallocuvm(pgdir, KERNBASE, 0);
80107bb6:	83 ec 04             	sub    $0x4,%esp
80107bb9:	6a 00                	push   $0x0
80107bbb:	68 00 00 00 80       	push   $0x80000000
80107bc0:	ff 75 08             	push   0x8(%ebp)
80107bc3:	e8 11 ff ff ff       	call   80107ad9 <deallocuvm>
80107bc8:	83 c4 10             	add    $0x10,%esp
  for(i = 0; i < NPDENTRIES; i++){
80107bcb:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80107bd2:	eb 48                	jmp    80107c1c <freevm+0x7f>
    if(pgdir[i] & PTE_P){
80107bd4:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107bd7:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80107bde:	8b 45 08             	mov    0x8(%ebp),%eax
80107be1:	01 d0                	add    %edx,%eax
80107be3:	8b 00                	mov    (%eax),%eax
80107be5:	83 e0 01             	and    $0x1,%eax
80107be8:	85 c0                	test   %eax,%eax
80107bea:	74 2c                	je     80107c18 <freevm+0x7b>
      char * v = P2V(PTE_ADDR(pgdir[i]));
80107bec:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107bef:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80107bf6:	8b 45 08             	mov    0x8(%ebp),%eax
80107bf9:	01 d0                	add    %edx,%eax
80107bfb:	8b 00                	mov    (%eax),%eax
80107bfd:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80107c02:	05 00 00 00 80       	add    $0x80000000,%eax
80107c07:	89 45 f0             	mov    %eax,-0x10(%ebp)
      kfree(v);
80107c0a:	83 ec 0c             	sub    $0xc,%esp
80107c0d:	ff 75 f0             	push   -0x10(%ebp)
80107c10:	e8 f1 aa ff ff       	call   80102706 <kfree>
80107c15:	83 c4 10             	add    $0x10,%esp
  for(i = 0; i < NPDENTRIES; i++){
80107c18:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80107c1c:	81 7d f4 ff 03 00 00 	cmpl   $0x3ff,-0xc(%ebp)
80107c23:	76 af                	jbe    80107bd4 <freevm+0x37>
    }
  }
  kfree((char*)pgdir);
80107c25:	83 ec 0c             	sub    $0xc,%esp
80107c28:	ff 75 08             	push   0x8(%ebp)
80107c2b:	e8 d6 aa ff ff       	call   80102706 <kfree>
80107c30:	83 c4 10             	add    $0x10,%esp
}
80107c33:	90                   	nop
80107c34:	c9                   	leave  
80107c35:	c3                   	ret    

80107c36 <clearpteu>:

// Clear PTE_U on a page. Used to create an inaccessible
// page beneath the user stack.
void
clearpteu(pde_t *pgdir, char *uva)
{
80107c36:	55                   	push   %ebp
80107c37:	89 e5                	mov    %esp,%ebp
80107c39:	83 ec 18             	sub    $0x18,%esp
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
80107c3c:	83 ec 04             	sub    $0x4,%esp
80107c3f:	6a 00                	push   $0x0
80107c41:	ff 75 0c             	push   0xc(%ebp)
80107c44:	ff 75 08             	push   0x8(%ebp)
80107c47:	e8 69 f8 ff ff       	call   801074b5 <walkpgdir>
80107c4c:	83 c4 10             	add    $0x10,%esp
80107c4f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(pte == 0)
80107c52:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80107c56:	75 0d                	jne    80107c65 <clearpteu+0x2f>
    panic("clearpteu");
80107c58:	83 ec 0c             	sub    $0xc,%esp
80107c5b:	68 90 a9 10 80       	push   $0x8010a990
80107c60:	e8 44 89 ff ff       	call   801005a9 <panic>
  *pte &= ~PTE_U;
80107c65:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107c68:	8b 00                	mov    (%eax),%eax
80107c6a:	83 e0 fb             	and    $0xfffffffb,%eax
80107c6d:	89 c2                	mov    %eax,%edx
80107c6f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107c72:	89 10                	mov    %edx,(%eax)
}
80107c74:	90                   	nop
80107c75:	c9                   	leave  
80107c76:	c3                   	ret    

80107c77 <copyuvm>:

// Given a parent process's page table, create a copy
// of it for a child.
pde_t*
copyuvm(pde_t *pgdir, uint sz)
{
80107c77:	55                   	push   %ebp
80107c78:	89 e5                	mov    %esp,%ebp
80107c7a:	83 ec 28             	sub    $0x28,%esp
  pde_t *d;
  pte_t *pte;
  uint pa, i, flags;
  char *mem;

  if((d = setupkvm()) == 0)
80107c7d:	e8 59 f9 ff ff       	call   801075db <setupkvm>
80107c82:	89 45 f0             	mov    %eax,-0x10(%ebp)
80107c85:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80107c89:	75 0a                	jne    80107c95 <copyuvm+0x1e>
    return 0;
80107c8b:	b8 00 00 00 00       	mov    $0x0,%eax
80107c90:	e9 eb 00 00 00       	jmp    80107d80 <copyuvm+0x109>
  for(i = 0; i < sz; i += PGSIZE){
80107c95:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80107c9c:	e9 b7 00 00 00       	jmp    80107d58 <copyuvm+0xe1>
    if((pte = walkpgdir(pgdir, (void *) i, 0)) == 0)
80107ca1:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107ca4:	83 ec 04             	sub    $0x4,%esp
80107ca7:	6a 00                	push   $0x0
80107ca9:	50                   	push   %eax
80107caa:	ff 75 08             	push   0x8(%ebp)
80107cad:	e8 03 f8 ff ff       	call   801074b5 <walkpgdir>
80107cb2:	83 c4 10             	add    $0x10,%esp
80107cb5:	89 45 ec             	mov    %eax,-0x14(%ebp)
80107cb8:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
80107cbc:	75 0d                	jne    80107ccb <copyuvm+0x54>
      panic("copyuvm: pte should exist");
80107cbe:	83 ec 0c             	sub    $0xc,%esp
80107cc1:	68 9a a9 10 80       	push   $0x8010a99a
80107cc6:	e8 de 88 ff ff       	call   801005a9 <panic>
    if(!(*pte & PTE_P))
80107ccb:	8b 45 ec             	mov    -0x14(%ebp),%eax
80107cce:	8b 00                	mov    (%eax),%eax
80107cd0:	83 e0 01             	and    $0x1,%eax
80107cd3:	85 c0                	test   %eax,%eax
80107cd5:	75 0d                	jne    80107ce4 <copyuvm+0x6d>
      panic("copyuvm: page not present");
80107cd7:	83 ec 0c             	sub    $0xc,%esp
80107cda:	68 b4 a9 10 80       	push   $0x8010a9b4
80107cdf:	e8 c5 88 ff ff       	call   801005a9 <panic>
    pa = PTE_ADDR(*pte);
80107ce4:	8b 45 ec             	mov    -0x14(%ebp),%eax
80107ce7:	8b 00                	mov    (%eax),%eax
80107ce9:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80107cee:	89 45 e8             	mov    %eax,-0x18(%ebp)
    flags = PTE_FLAGS(*pte);
80107cf1:	8b 45 ec             	mov    -0x14(%ebp),%eax
80107cf4:	8b 00                	mov    (%eax),%eax
80107cf6:	25 ff 0f 00 00       	and    $0xfff,%eax
80107cfb:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if((mem = kalloc()) == 0)
80107cfe:	e8 9d aa ff ff       	call   801027a0 <kalloc>
80107d03:	89 45 e0             	mov    %eax,-0x20(%ebp)
80107d06:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
80107d0a:	74 5d                	je     80107d69 <copyuvm+0xf2>
      goto bad;
    memmove(mem, (char*)P2V(pa), PGSIZE);
80107d0c:	8b 45 e8             	mov    -0x18(%ebp),%eax
80107d0f:	05 00 00 00 80       	add    $0x80000000,%eax
80107d14:	83 ec 04             	sub    $0x4,%esp
80107d17:	68 00 10 00 00       	push   $0x1000
80107d1c:	50                   	push   %eax
80107d1d:	ff 75 e0             	push   -0x20(%ebp)
80107d20:	e8 ce cf ff ff       	call   80104cf3 <memmove>
80107d25:	83 c4 10             	add    $0x10,%esp
    if(mappages(d, (void*)i, PGSIZE, V2P(mem), flags) < 0)
80107d28:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80107d2b:	8b 45 e0             	mov    -0x20(%ebp),%eax
80107d2e:	8d 88 00 00 00 80    	lea    -0x80000000(%eax),%ecx
80107d34:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107d37:	83 ec 0c             	sub    $0xc,%esp
80107d3a:	52                   	push   %edx
80107d3b:	51                   	push   %ecx
80107d3c:	68 00 10 00 00       	push   $0x1000
80107d41:	50                   	push   %eax
80107d42:	ff 75 f0             	push   -0x10(%ebp)
80107d45:	e8 01 f8 ff ff       	call   8010754b <mappages>
80107d4a:	83 c4 20             	add    $0x20,%esp
80107d4d:	85 c0                	test   %eax,%eax
80107d4f:	78 1b                	js     80107d6c <copyuvm+0xf5>
  for(i = 0; i < sz; i += PGSIZE){
80107d51:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
80107d58:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107d5b:	3b 45 0c             	cmp    0xc(%ebp),%eax
80107d5e:	0f 82 3d ff ff ff    	jb     80107ca1 <copyuvm+0x2a>
      goto bad;
  }
  return d;
80107d64:	8b 45 f0             	mov    -0x10(%ebp),%eax
80107d67:	eb 17                	jmp    80107d80 <copyuvm+0x109>
      goto bad;
80107d69:	90                   	nop
80107d6a:	eb 01                	jmp    80107d6d <copyuvm+0xf6>
      goto bad;
80107d6c:	90                   	nop

bad:
  freevm(d);
80107d6d:	83 ec 0c             	sub    $0xc,%esp
80107d70:	ff 75 f0             	push   -0x10(%ebp)
80107d73:	e8 25 fe ff ff       	call   80107b9d <freevm>
80107d78:	83 c4 10             	add    $0x10,%esp
  return 0;
80107d7b:	b8 00 00 00 00       	mov    $0x0,%eax
}
80107d80:	c9                   	leave  
80107d81:	c3                   	ret    

80107d82 <uva2ka>:

//PAGEBREAK!
// Map user virtual address to kernel address.
char*
uva2ka(pde_t *pgdir, char *uva)
{
80107d82:	55                   	push   %ebp
80107d83:	89 e5                	mov    %esp,%ebp
80107d85:	83 ec 18             	sub    $0x18,%esp
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
80107d88:	83 ec 04             	sub    $0x4,%esp
80107d8b:	6a 00                	push   $0x0
80107d8d:	ff 75 0c             	push   0xc(%ebp)
80107d90:	ff 75 08             	push   0x8(%ebp)
80107d93:	e8 1d f7 ff ff       	call   801074b5 <walkpgdir>
80107d98:	83 c4 10             	add    $0x10,%esp
80107d9b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if((*pte & PTE_P) == 0)
80107d9e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107da1:	8b 00                	mov    (%eax),%eax
80107da3:	83 e0 01             	and    $0x1,%eax
80107da6:	85 c0                	test   %eax,%eax
80107da8:	75 07                	jne    80107db1 <uva2ka+0x2f>
    return 0;
80107daa:	b8 00 00 00 00       	mov    $0x0,%eax
80107daf:	eb 22                	jmp    80107dd3 <uva2ka+0x51>
  if((*pte & PTE_U) == 0)
80107db1:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107db4:	8b 00                	mov    (%eax),%eax
80107db6:	83 e0 04             	and    $0x4,%eax
80107db9:	85 c0                	test   %eax,%eax
80107dbb:	75 07                	jne    80107dc4 <uva2ka+0x42>
    return 0;
80107dbd:	b8 00 00 00 00       	mov    $0x0,%eax
80107dc2:	eb 0f                	jmp    80107dd3 <uva2ka+0x51>
  return (char*)P2V(PTE_ADDR(*pte));
80107dc4:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107dc7:	8b 00                	mov    (%eax),%eax
80107dc9:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80107dce:	05 00 00 00 80       	add    $0x80000000,%eax
}
80107dd3:	c9                   	leave  
80107dd4:	c3                   	ret    

80107dd5 <copyout>:
// Copy len bytes from p to user address va in page table pgdir.
// Most useful when pgdir is not the current page table.
// uva2ka ensures this only works for PTE_U pages.
int
copyout(pde_t *pgdir, uint va, void *p, uint len)
{
80107dd5:	55                   	push   %ebp
80107dd6:	89 e5                	mov    %esp,%ebp
80107dd8:	83 ec 18             	sub    $0x18,%esp
  char *buf, *pa0;
  uint n, va0;

  buf = (char*)p;
80107ddb:	8b 45 10             	mov    0x10(%ebp),%eax
80107dde:	89 45 f4             	mov    %eax,-0xc(%ebp)
  while(len > 0){
80107de1:	eb 7f                	jmp    80107e62 <copyout+0x8d>
    va0 = (uint)PGROUNDDOWN(va);
80107de3:	8b 45 0c             	mov    0xc(%ebp),%eax
80107de6:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80107deb:	89 45 ec             	mov    %eax,-0x14(%ebp)
    pa0 = uva2ka(pgdir, (char*)va0);
80107dee:	8b 45 ec             	mov    -0x14(%ebp),%eax
80107df1:	83 ec 08             	sub    $0x8,%esp
80107df4:	50                   	push   %eax
80107df5:	ff 75 08             	push   0x8(%ebp)
80107df8:	e8 85 ff ff ff       	call   80107d82 <uva2ka>
80107dfd:	83 c4 10             	add    $0x10,%esp
80107e00:	89 45 e8             	mov    %eax,-0x18(%ebp)
    if(pa0 == 0)
80107e03:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
80107e07:	75 07                	jne    80107e10 <copyout+0x3b>
      return -1;
80107e09:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80107e0e:	eb 61                	jmp    80107e71 <copyout+0x9c>
    n = PGSIZE - (va - va0);
80107e10:	8b 45 ec             	mov    -0x14(%ebp),%eax
80107e13:	2b 45 0c             	sub    0xc(%ebp),%eax
80107e16:	05 00 10 00 00       	add    $0x1000,%eax
80107e1b:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(n > len)
80107e1e:	8b 45 f0             	mov    -0x10(%ebp),%eax
80107e21:	3b 45 14             	cmp    0x14(%ebp),%eax
80107e24:	76 06                	jbe    80107e2c <copyout+0x57>
      n = len;
80107e26:	8b 45 14             	mov    0x14(%ebp),%eax
80107e29:	89 45 f0             	mov    %eax,-0x10(%ebp)
    memmove(pa0 + (va - va0), buf, n);
80107e2c:	8b 45 0c             	mov    0xc(%ebp),%eax
80107e2f:	2b 45 ec             	sub    -0x14(%ebp),%eax
80107e32:	89 c2                	mov    %eax,%edx
80107e34:	8b 45 e8             	mov    -0x18(%ebp),%eax
80107e37:	01 d0                	add    %edx,%eax
80107e39:	83 ec 04             	sub    $0x4,%esp
80107e3c:	ff 75 f0             	push   -0x10(%ebp)
80107e3f:	ff 75 f4             	push   -0xc(%ebp)
80107e42:	50                   	push   %eax
80107e43:	e8 ab ce ff ff       	call   80104cf3 <memmove>
80107e48:	83 c4 10             	add    $0x10,%esp
    len -= n;
80107e4b:	8b 45 f0             	mov    -0x10(%ebp),%eax
80107e4e:	29 45 14             	sub    %eax,0x14(%ebp)
    buf += n;
80107e51:	8b 45 f0             	mov    -0x10(%ebp),%eax
80107e54:	01 45 f4             	add    %eax,-0xc(%ebp)
    va = va0 + PGSIZE;
80107e57:	8b 45 ec             	mov    -0x14(%ebp),%eax
80107e5a:	05 00 10 00 00       	add    $0x1000,%eax
80107e5f:	89 45 0c             	mov    %eax,0xc(%ebp)
  while(len > 0){
80107e62:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
80107e66:	0f 85 77 ff ff ff    	jne    80107de3 <copyout+0xe>
  }
  return 0;
80107e6c:	b8 00 00 00 00       	mov    $0x0,%eax
}
80107e71:	c9                   	leave  
80107e72:	c3                   	ret    

80107e73 <mpinit_uefi>:

struct cpu cpus[NCPU];
int ncpu;
uchar ioapicid;
void mpinit_uefi(void)
{
80107e73:	55                   	push   %ebp
80107e74:	89 e5                	mov    %esp,%ebp
80107e76:	83 ec 20             	sub    $0x20,%esp
  struct boot_param *boot_param = (struct boot_param *)P2V_WO(BOOTPARAM);
80107e79:	c7 45 f8 00 00 05 80 	movl   $0x80050000,-0x8(%ebp)
  struct uefi_madt *madt = (struct uefi_madt*)(P2V_WO(boot_param->madt_addr));
80107e80:	8b 45 f8             	mov    -0x8(%ebp),%eax
80107e83:	8b 40 08             	mov    0x8(%eax),%eax
80107e86:	05 00 00 00 80       	add    $0x80000000,%eax
80107e8b:	89 45 f4             	mov    %eax,-0xc(%ebp)

  uint i=sizeof(struct uefi_madt);
80107e8e:	c7 45 fc 2c 00 00 00 	movl   $0x2c,-0x4(%ebp)
  struct uefi_lapic *lapic_entry;
  struct uefi_ioapic *ioapic;
  struct uefi_iso *iso;
  struct uefi_non_maskable_intr *non_mask_intr; 
  
  lapic = (uint *)(madt->lapic_addr);
80107e95:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107e98:	8b 40 24             	mov    0x24(%eax),%eax
80107e9b:	a3 00 41 19 80       	mov    %eax,0x80194100
  ncpu = 0;
80107ea0:	c7 05 40 6e 19 80 00 	movl   $0x0,0x80196e40
80107ea7:	00 00 00 

  while(i<madt->len){
80107eaa:	90                   	nop
80107eab:	e9 bd 00 00 00       	jmp    80107f6d <mpinit_uefi+0xfa>
    uchar *entry_type = ((uchar *)madt)+i;
80107eb0:	8b 55 f4             	mov    -0xc(%ebp),%edx
80107eb3:	8b 45 fc             	mov    -0x4(%ebp),%eax
80107eb6:	01 d0                	add    %edx,%eax
80107eb8:	89 45 f0             	mov    %eax,-0x10(%ebp)
    switch(*entry_type){
80107ebb:	8b 45 f0             	mov    -0x10(%ebp),%eax
80107ebe:	0f b6 00             	movzbl (%eax),%eax
80107ec1:	0f b6 c0             	movzbl %al,%eax
80107ec4:	83 f8 05             	cmp    $0x5,%eax
80107ec7:	0f 87 a0 00 00 00    	ja     80107f6d <mpinit_uefi+0xfa>
80107ecd:	8b 04 85 d0 a9 10 80 	mov    -0x7fef5630(,%eax,4),%eax
80107ed4:	ff e0                	jmp    *%eax
      case 0:
        lapic_entry = (struct uefi_lapic *)entry_type;
80107ed6:	8b 45 f0             	mov    -0x10(%ebp),%eax
80107ed9:	89 45 e0             	mov    %eax,-0x20(%ebp)
        if(ncpu < NCPU) {
80107edc:	a1 40 6e 19 80       	mov    0x80196e40,%eax
80107ee1:	83 f8 03             	cmp    $0x3,%eax
80107ee4:	7f 28                	jg     80107f0e <mpinit_uefi+0x9b>
          cpus[ncpu].apicid = lapic_entry->lapic_id;
80107ee6:	8b 15 40 6e 19 80    	mov    0x80196e40,%edx
80107eec:	8b 45 e0             	mov    -0x20(%ebp),%eax
80107eef:	0f b6 40 03          	movzbl 0x3(%eax),%eax
80107ef3:	69 d2 b0 00 00 00    	imul   $0xb0,%edx,%edx
80107ef9:	81 c2 80 6b 19 80    	add    $0x80196b80,%edx
80107eff:	88 02                	mov    %al,(%edx)
          ncpu++;
80107f01:	a1 40 6e 19 80       	mov    0x80196e40,%eax
80107f06:	83 c0 01             	add    $0x1,%eax
80107f09:	a3 40 6e 19 80       	mov    %eax,0x80196e40
        }
        i += lapic_entry->record_len;
80107f0e:	8b 45 e0             	mov    -0x20(%ebp),%eax
80107f11:	0f b6 40 01          	movzbl 0x1(%eax),%eax
80107f15:	0f b6 c0             	movzbl %al,%eax
80107f18:	01 45 fc             	add    %eax,-0x4(%ebp)
        break;
80107f1b:	eb 50                	jmp    80107f6d <mpinit_uefi+0xfa>

      case 1:
        ioapic = (struct uefi_ioapic *)entry_type;
80107f1d:	8b 45 f0             	mov    -0x10(%ebp),%eax
80107f20:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        ioapicid = ioapic->ioapic_id;
80107f23:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80107f26:	0f b6 40 02          	movzbl 0x2(%eax),%eax
80107f2a:	a2 44 6e 19 80       	mov    %al,0x80196e44
        i += ioapic->record_len;
80107f2f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80107f32:	0f b6 40 01          	movzbl 0x1(%eax),%eax
80107f36:	0f b6 c0             	movzbl %al,%eax
80107f39:	01 45 fc             	add    %eax,-0x4(%ebp)
        break;
80107f3c:	eb 2f                	jmp    80107f6d <mpinit_uefi+0xfa>

      case 2:
        iso = (struct uefi_iso *)entry_type;
80107f3e:	8b 45 f0             	mov    -0x10(%ebp),%eax
80107f41:	89 45 e8             	mov    %eax,-0x18(%ebp)
        i += iso->record_len;
80107f44:	8b 45 e8             	mov    -0x18(%ebp),%eax
80107f47:	0f b6 40 01          	movzbl 0x1(%eax),%eax
80107f4b:	0f b6 c0             	movzbl %al,%eax
80107f4e:	01 45 fc             	add    %eax,-0x4(%ebp)
        break;
80107f51:	eb 1a                	jmp    80107f6d <mpinit_uefi+0xfa>

      case 4:
        non_mask_intr = (struct uefi_non_maskable_intr *)entry_type;
80107f53:	8b 45 f0             	mov    -0x10(%ebp),%eax
80107f56:	89 45 ec             	mov    %eax,-0x14(%ebp)
        i += non_mask_intr->record_len;
80107f59:	8b 45 ec             	mov    -0x14(%ebp),%eax
80107f5c:	0f b6 40 01          	movzbl 0x1(%eax),%eax
80107f60:	0f b6 c0             	movzbl %al,%eax
80107f63:	01 45 fc             	add    %eax,-0x4(%ebp)
        break;
80107f66:	eb 05                	jmp    80107f6d <mpinit_uefi+0xfa>

      case 5:
        i = i + 0xC;
80107f68:	83 45 fc 0c          	addl   $0xc,-0x4(%ebp)
        break;
80107f6c:	90                   	nop
  while(i<madt->len){
80107f6d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107f70:	8b 40 04             	mov    0x4(%eax),%eax
80107f73:	39 45 fc             	cmp    %eax,-0x4(%ebp)
80107f76:	0f 82 34 ff ff ff    	jb     80107eb0 <mpinit_uefi+0x3d>
    }
  }

}
80107f7c:	90                   	nop
80107f7d:	90                   	nop
80107f7e:	c9                   	leave  
80107f7f:	c3                   	ret    

80107f80 <inb>:
{
80107f80:	55                   	push   %ebp
80107f81:	89 e5                	mov    %esp,%ebp
80107f83:	83 ec 14             	sub    $0x14,%esp
80107f86:	8b 45 08             	mov    0x8(%ebp),%eax
80107f89:	66 89 45 ec          	mov    %ax,-0x14(%ebp)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80107f8d:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
80107f91:	89 c2                	mov    %eax,%edx
80107f93:	ec                   	in     (%dx),%al
80107f94:	88 45 ff             	mov    %al,-0x1(%ebp)
  return data;
80107f97:	0f b6 45 ff          	movzbl -0x1(%ebp),%eax
}
80107f9b:	c9                   	leave  
80107f9c:	c3                   	ret    

80107f9d <outb>:
{
80107f9d:	55                   	push   %ebp
80107f9e:	89 e5                	mov    %esp,%ebp
80107fa0:	83 ec 08             	sub    $0x8,%esp
80107fa3:	8b 45 08             	mov    0x8(%ebp),%eax
80107fa6:	8b 55 0c             	mov    0xc(%ebp),%edx
80107fa9:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
80107fad:	89 d0                	mov    %edx,%eax
80107faf:	88 45 f8             	mov    %al,-0x8(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80107fb2:	0f b6 45 f8          	movzbl -0x8(%ebp),%eax
80107fb6:	0f b7 55 fc          	movzwl -0x4(%ebp),%edx
80107fba:	ee                   	out    %al,(%dx)
}
80107fbb:	90                   	nop
80107fbc:	c9                   	leave  
80107fbd:	c3                   	ret    

80107fbe <uart_debug>:
#include "proc.h"
#include "x86.h"

#define COM1    0x3f8

void uart_debug(char p){
80107fbe:	55                   	push   %ebp
80107fbf:	89 e5                	mov    %esp,%ebp
80107fc1:	83 ec 28             	sub    $0x28,%esp
80107fc4:	8b 45 08             	mov    0x8(%ebp),%eax
80107fc7:	88 45 e4             	mov    %al,-0x1c(%ebp)
    // Turn off the FIFO
  outb(COM1+2, 0);
80107fca:	6a 00                	push   $0x0
80107fcc:	68 fa 03 00 00       	push   $0x3fa
80107fd1:	e8 c7 ff ff ff       	call   80107f9d <outb>
80107fd6:	83 c4 08             	add    $0x8,%esp

  // 9600 baud, 8 data bits, 1 stop bit, parity off.
  outb(COM1+3, 0x80);    // Unlock divisor
80107fd9:	68 80 00 00 00       	push   $0x80
80107fde:	68 fb 03 00 00       	push   $0x3fb
80107fe3:	e8 b5 ff ff ff       	call   80107f9d <outb>
80107fe8:	83 c4 08             	add    $0x8,%esp
  outb(COM1+0, 115200/9600);
80107feb:	6a 0c                	push   $0xc
80107fed:	68 f8 03 00 00       	push   $0x3f8
80107ff2:	e8 a6 ff ff ff       	call   80107f9d <outb>
80107ff7:	83 c4 08             	add    $0x8,%esp
  outb(COM1+1, 0);
80107ffa:	6a 00                	push   $0x0
80107ffc:	68 f9 03 00 00       	push   $0x3f9
80108001:	e8 97 ff ff ff       	call   80107f9d <outb>
80108006:	83 c4 08             	add    $0x8,%esp
  outb(COM1+3, 0x03);    // Lock divisor, 8 data bits.
80108009:	6a 03                	push   $0x3
8010800b:	68 fb 03 00 00       	push   $0x3fb
80108010:	e8 88 ff ff ff       	call   80107f9d <outb>
80108015:	83 c4 08             	add    $0x8,%esp
  outb(COM1+4, 0);
80108018:	6a 00                	push   $0x0
8010801a:	68 fc 03 00 00       	push   $0x3fc
8010801f:	e8 79 ff ff ff       	call   80107f9d <outb>
80108024:	83 c4 08             	add    $0x8,%esp

  for(int i=0;i<128 && !(inb(COM1+5) & 0x20); i++) microdelay(10);
80108027:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
8010802e:	eb 11                	jmp    80108041 <uart_debug+0x83>
80108030:	83 ec 0c             	sub    $0xc,%esp
80108033:	6a 0a                	push   $0xa
80108035:	e8 fd aa ff ff       	call   80102b37 <microdelay>
8010803a:	83 c4 10             	add    $0x10,%esp
8010803d:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80108041:	83 7d f4 7f          	cmpl   $0x7f,-0xc(%ebp)
80108045:	7f 1a                	jg     80108061 <uart_debug+0xa3>
80108047:	83 ec 0c             	sub    $0xc,%esp
8010804a:	68 fd 03 00 00       	push   $0x3fd
8010804f:	e8 2c ff ff ff       	call   80107f80 <inb>
80108054:	83 c4 10             	add    $0x10,%esp
80108057:	0f b6 c0             	movzbl %al,%eax
8010805a:	83 e0 20             	and    $0x20,%eax
8010805d:	85 c0                	test   %eax,%eax
8010805f:	74 cf                	je     80108030 <uart_debug+0x72>
  outb(COM1+0, p);
80108061:	0f b6 45 e4          	movzbl -0x1c(%ebp),%eax
80108065:	0f b6 c0             	movzbl %al,%eax
80108068:	83 ec 08             	sub    $0x8,%esp
8010806b:	50                   	push   %eax
8010806c:	68 f8 03 00 00       	push   $0x3f8
80108071:	e8 27 ff ff ff       	call   80107f9d <outb>
80108076:	83 c4 10             	add    $0x10,%esp
}
80108079:	90                   	nop
8010807a:	c9                   	leave  
8010807b:	c3                   	ret    

8010807c <uart_debugs>:

void uart_debugs(char *p){
8010807c:	55                   	push   %ebp
8010807d:	89 e5                	mov    %esp,%ebp
8010807f:	83 ec 08             	sub    $0x8,%esp
  while(*p){
80108082:	eb 1b                	jmp    8010809f <uart_debugs+0x23>
    uart_debug(*p++);
80108084:	8b 45 08             	mov    0x8(%ebp),%eax
80108087:	8d 50 01             	lea    0x1(%eax),%edx
8010808a:	89 55 08             	mov    %edx,0x8(%ebp)
8010808d:	0f b6 00             	movzbl (%eax),%eax
80108090:	0f be c0             	movsbl %al,%eax
80108093:	83 ec 0c             	sub    $0xc,%esp
80108096:	50                   	push   %eax
80108097:	e8 22 ff ff ff       	call   80107fbe <uart_debug>
8010809c:	83 c4 10             	add    $0x10,%esp
  while(*p){
8010809f:	8b 45 08             	mov    0x8(%ebp),%eax
801080a2:	0f b6 00             	movzbl (%eax),%eax
801080a5:	84 c0                	test   %al,%al
801080a7:	75 db                	jne    80108084 <uart_debugs+0x8>
  }
}
801080a9:	90                   	nop
801080aa:	90                   	nop
801080ab:	c9                   	leave  
801080ac:	c3                   	ret    

801080ad <graphic_init>:
 * i%4 = 2 : red
 * i%4 = 3 : black
 */

struct gpu gpu;
void graphic_init(){
801080ad:	55                   	push   %ebp
801080ae:	89 e5                	mov    %esp,%ebp
801080b0:	83 ec 10             	sub    $0x10,%esp
  struct boot_param *boot_param = (struct boot_param *)P2V_WO(BOOTPARAM);
801080b3:	c7 45 fc 00 00 05 80 	movl   $0x80050000,-0x4(%ebp)
  gpu.pvram_addr = boot_param->graphic_config.frame_base;
801080ba:	8b 45 fc             	mov    -0x4(%ebp),%eax
801080bd:	8b 50 14             	mov    0x14(%eax),%edx
801080c0:	8b 40 10             	mov    0x10(%eax),%eax
801080c3:	a3 48 6e 19 80       	mov    %eax,0x80196e48
  gpu.vram_size = boot_param->graphic_config.frame_size;
801080c8:	8b 45 fc             	mov    -0x4(%ebp),%eax
801080cb:	8b 50 1c             	mov    0x1c(%eax),%edx
801080ce:	8b 40 18             	mov    0x18(%eax),%eax
801080d1:	a3 50 6e 19 80       	mov    %eax,0x80196e50
  gpu.vvram_addr = DEVSPACE - gpu.vram_size;
801080d6:	8b 15 50 6e 19 80    	mov    0x80196e50,%edx
801080dc:	b8 00 00 00 fe       	mov    $0xfe000000,%eax
801080e1:	29 d0                	sub    %edx,%eax
801080e3:	a3 4c 6e 19 80       	mov    %eax,0x80196e4c
  gpu.horizontal_resolution = (uint)(boot_param->graphic_config.horizontal_resolution & 0xFFFFFFFF);
801080e8:	8b 45 fc             	mov    -0x4(%ebp),%eax
801080eb:	8b 50 24             	mov    0x24(%eax),%edx
801080ee:	8b 40 20             	mov    0x20(%eax),%eax
801080f1:	a3 54 6e 19 80       	mov    %eax,0x80196e54
  gpu.vertical_resolution = (uint)(boot_param->graphic_config.vertical_resolution & 0xFFFFFFFF);
801080f6:	8b 45 fc             	mov    -0x4(%ebp),%eax
801080f9:	8b 50 2c             	mov    0x2c(%eax),%edx
801080fc:	8b 40 28             	mov    0x28(%eax),%eax
801080ff:	a3 58 6e 19 80       	mov    %eax,0x80196e58
  gpu.pixels_per_line = (uint)(boot_param->graphic_config.pixels_per_line & 0xFFFFFFFF);
80108104:	8b 45 fc             	mov    -0x4(%ebp),%eax
80108107:	8b 50 34             	mov    0x34(%eax),%edx
8010810a:	8b 40 30             	mov    0x30(%eax),%eax
8010810d:	a3 5c 6e 19 80       	mov    %eax,0x80196e5c
}
80108112:	90                   	nop
80108113:	c9                   	leave  
80108114:	c3                   	ret    

80108115 <graphic_draw_pixel>:

void graphic_draw_pixel(int x,int y,struct graphic_pixel * buffer){
80108115:	55                   	push   %ebp
80108116:	89 e5                	mov    %esp,%ebp
80108118:	83 ec 10             	sub    $0x10,%esp
  int pixel_addr = (sizeof(struct graphic_pixel))*(y*gpu.pixels_per_line + x);
8010811b:	8b 15 5c 6e 19 80    	mov    0x80196e5c,%edx
80108121:	8b 45 0c             	mov    0xc(%ebp),%eax
80108124:	0f af d0             	imul   %eax,%edx
80108127:	8b 45 08             	mov    0x8(%ebp),%eax
8010812a:	01 d0                	add    %edx,%eax
8010812c:	c1 e0 02             	shl    $0x2,%eax
8010812f:	89 45 fc             	mov    %eax,-0x4(%ebp)
  struct graphic_pixel *pixel = (struct graphic_pixel *)(gpu.vvram_addr + pixel_addr);
80108132:	8b 15 4c 6e 19 80    	mov    0x80196e4c,%edx
80108138:	8b 45 fc             	mov    -0x4(%ebp),%eax
8010813b:	01 d0                	add    %edx,%eax
8010813d:	89 45 f8             	mov    %eax,-0x8(%ebp)
  pixel->blue = buffer->blue;
80108140:	8b 45 10             	mov    0x10(%ebp),%eax
80108143:	0f b6 10             	movzbl (%eax),%edx
80108146:	8b 45 f8             	mov    -0x8(%ebp),%eax
80108149:	88 10                	mov    %dl,(%eax)
  pixel->green = buffer->green;
8010814b:	8b 45 10             	mov    0x10(%ebp),%eax
8010814e:	0f b6 50 01          	movzbl 0x1(%eax),%edx
80108152:	8b 45 f8             	mov    -0x8(%ebp),%eax
80108155:	88 50 01             	mov    %dl,0x1(%eax)
  pixel->red = buffer->red;
80108158:	8b 45 10             	mov    0x10(%ebp),%eax
8010815b:	0f b6 50 02          	movzbl 0x2(%eax),%edx
8010815f:	8b 45 f8             	mov    -0x8(%ebp),%eax
80108162:	88 50 02             	mov    %dl,0x2(%eax)
}
80108165:	90                   	nop
80108166:	c9                   	leave  
80108167:	c3                   	ret    

80108168 <graphic_scroll_up>:

void graphic_scroll_up(int height){
80108168:	55                   	push   %ebp
80108169:	89 e5                	mov    %esp,%ebp
8010816b:	83 ec 18             	sub    $0x18,%esp
  int addr_diff = (sizeof(struct graphic_pixel))*gpu.pixels_per_line*height;
8010816e:	8b 15 5c 6e 19 80    	mov    0x80196e5c,%edx
80108174:	8b 45 08             	mov    0x8(%ebp),%eax
80108177:	0f af c2             	imul   %edx,%eax
8010817a:	c1 e0 02             	shl    $0x2,%eax
8010817d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  memmove((unsigned int *)gpu.vvram_addr,(unsigned int *)(gpu.vvram_addr + addr_diff),gpu.vram_size - addr_diff);
80108180:	a1 50 6e 19 80       	mov    0x80196e50,%eax
80108185:	8b 55 f4             	mov    -0xc(%ebp),%edx
80108188:	29 d0                	sub    %edx,%eax
8010818a:	8b 0d 4c 6e 19 80    	mov    0x80196e4c,%ecx
80108190:	8b 55 f4             	mov    -0xc(%ebp),%edx
80108193:	01 ca                	add    %ecx,%edx
80108195:	89 d1                	mov    %edx,%ecx
80108197:	8b 15 4c 6e 19 80    	mov    0x80196e4c,%edx
8010819d:	83 ec 04             	sub    $0x4,%esp
801081a0:	50                   	push   %eax
801081a1:	51                   	push   %ecx
801081a2:	52                   	push   %edx
801081a3:	e8 4b cb ff ff       	call   80104cf3 <memmove>
801081a8:	83 c4 10             	add    $0x10,%esp
  memset((unsigned int *)(gpu.vvram_addr + gpu.vram_size - addr_diff),0,addr_diff);
801081ab:	8b 45 f4             	mov    -0xc(%ebp),%eax
801081ae:	8b 0d 4c 6e 19 80    	mov    0x80196e4c,%ecx
801081b4:	8b 15 50 6e 19 80    	mov    0x80196e50,%edx
801081ba:	01 ca                	add    %ecx,%edx
801081bc:	8b 4d f4             	mov    -0xc(%ebp),%ecx
801081bf:	29 ca                	sub    %ecx,%edx
801081c1:	83 ec 04             	sub    $0x4,%esp
801081c4:	50                   	push   %eax
801081c5:	6a 00                	push   $0x0
801081c7:	52                   	push   %edx
801081c8:	e8 67 ca ff ff       	call   80104c34 <memset>
801081cd:	83 c4 10             	add    $0x10,%esp
}
801081d0:	90                   	nop
801081d1:	c9                   	leave  
801081d2:	c3                   	ret    

801081d3 <font_render>:
801081d3:	55                   	push   %ebp
801081d4:	89 e5                	mov    %esp,%ebp
801081d6:	53                   	push   %ebx
801081d7:	83 ec 14             	sub    $0x14,%esp
801081da:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
801081e1:	e9 b1 00 00 00       	jmp    80108297 <font_render+0xc4>
801081e6:	c7 45 f0 0e 00 00 00 	movl   $0xe,-0x10(%ebp)
801081ed:	e9 97 00 00 00       	jmp    80108289 <font_render+0xb6>
801081f2:	8b 45 10             	mov    0x10(%ebp),%eax
801081f5:	83 e8 20             	sub    $0x20,%eax
801081f8:	6b d0 1e             	imul   $0x1e,%eax,%edx
801081fb:	8b 45 f4             	mov    -0xc(%ebp),%eax
801081fe:	01 d0                	add    %edx,%eax
80108200:	0f b7 84 00 00 aa 10 	movzwl -0x7fef5600(%eax,%eax,1),%eax
80108207:	80 
80108208:	0f b7 d0             	movzwl %ax,%edx
8010820b:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010820e:	bb 01 00 00 00       	mov    $0x1,%ebx
80108213:	89 c1                	mov    %eax,%ecx
80108215:	d3 e3                	shl    %cl,%ebx
80108217:	89 d8                	mov    %ebx,%eax
80108219:	21 d0                	and    %edx,%eax
8010821b:	89 45 ec             	mov    %eax,-0x14(%ebp)
8010821e:	8b 45 f0             	mov    -0x10(%ebp),%eax
80108221:	ba 01 00 00 00       	mov    $0x1,%edx
80108226:	89 c1                	mov    %eax,%ecx
80108228:	d3 e2                	shl    %cl,%edx
8010822a:	89 d0                	mov    %edx,%eax
8010822c:	39 45 ec             	cmp    %eax,-0x14(%ebp)
8010822f:	75 2b                	jne    8010825c <font_render+0x89>
80108231:	8b 55 0c             	mov    0xc(%ebp),%edx
80108234:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108237:	01 c2                	add    %eax,%edx
80108239:	b8 0e 00 00 00       	mov    $0xe,%eax
8010823e:	2b 45 f0             	sub    -0x10(%ebp),%eax
80108241:	89 c1                	mov    %eax,%ecx
80108243:	8b 45 08             	mov    0x8(%ebp),%eax
80108246:	01 c8                	add    %ecx,%eax
80108248:	83 ec 04             	sub    $0x4,%esp
8010824b:	68 00 f5 10 80       	push   $0x8010f500
80108250:	52                   	push   %edx
80108251:	50                   	push   %eax
80108252:	e8 be fe ff ff       	call   80108115 <graphic_draw_pixel>
80108257:	83 c4 10             	add    $0x10,%esp
8010825a:	eb 29                	jmp    80108285 <font_render+0xb2>
8010825c:	8b 55 0c             	mov    0xc(%ebp),%edx
8010825f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108262:	01 c2                	add    %eax,%edx
80108264:	b8 0e 00 00 00       	mov    $0xe,%eax
80108269:	2b 45 f0             	sub    -0x10(%ebp),%eax
8010826c:	89 c1                	mov    %eax,%ecx
8010826e:	8b 45 08             	mov    0x8(%ebp),%eax
80108271:	01 c8                	add    %ecx,%eax
80108273:	83 ec 04             	sub    $0x4,%esp
80108276:	68 60 6e 19 80       	push   $0x80196e60
8010827b:	52                   	push   %edx
8010827c:	50                   	push   %eax
8010827d:	e8 93 fe ff ff       	call   80108115 <graphic_draw_pixel>
80108282:	83 c4 10             	add    $0x10,%esp
80108285:	83 6d f0 01          	subl   $0x1,-0x10(%ebp)
80108289:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
8010828d:	0f 89 5f ff ff ff    	jns    801081f2 <font_render+0x1f>
80108293:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80108297:	83 7d f4 1d          	cmpl   $0x1d,-0xc(%ebp)
8010829b:	0f 8e 45 ff ff ff    	jle    801081e6 <font_render+0x13>
801082a1:	90                   	nop
801082a2:	90                   	nop
801082a3:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801082a6:	c9                   	leave  
801082a7:	c3                   	ret    

801082a8 <font_render_string>:
801082a8:	55                   	push   %ebp
801082a9:	89 e5                	mov    %esp,%ebp
801082ab:	53                   	push   %ebx
801082ac:	83 ec 14             	sub    $0x14,%esp
801082af:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
801082b6:	eb 33                	jmp    801082eb <font_render_string+0x43>
801082b8:	8b 55 f4             	mov    -0xc(%ebp),%edx
801082bb:	8b 45 08             	mov    0x8(%ebp),%eax
801082be:	01 d0                	add    %edx,%eax
801082c0:	0f b6 00             	movzbl (%eax),%eax
801082c3:	0f be c8             	movsbl %al,%ecx
801082c6:	8b 45 0c             	mov    0xc(%ebp),%eax
801082c9:	6b d0 1e             	imul   $0x1e,%eax,%edx
801082cc:	8b 5d f4             	mov    -0xc(%ebp),%ebx
801082cf:	89 d8                	mov    %ebx,%eax
801082d1:	c1 e0 04             	shl    $0x4,%eax
801082d4:	29 d8                	sub    %ebx,%eax
801082d6:	83 c0 02             	add    $0x2,%eax
801082d9:	83 ec 04             	sub    $0x4,%esp
801082dc:	51                   	push   %ecx
801082dd:	52                   	push   %edx
801082de:	50                   	push   %eax
801082df:	e8 ef fe ff ff       	call   801081d3 <font_render>
801082e4:	83 c4 10             	add    $0x10,%esp
801082e7:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
801082eb:	8b 55 f4             	mov    -0xc(%ebp),%edx
801082ee:	8b 45 08             	mov    0x8(%ebp),%eax
801082f1:	01 d0                	add    %edx,%eax
801082f3:	0f b6 00             	movzbl (%eax),%eax
801082f6:	84 c0                	test   %al,%al
801082f8:	74 06                	je     80108300 <font_render_string+0x58>
801082fa:	83 7d f4 33          	cmpl   $0x33,-0xc(%ebp)
801082fe:	7e b8                	jle    801082b8 <font_render_string+0x10>
80108300:	90                   	nop
80108301:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80108304:	c9                   	leave  
80108305:	c3                   	ret    

80108306 <pci_init>:
#include "pci.h"
#include "defs.h"
#include "types.h"
#include "i8254.h"

void pci_init(){
80108306:	55                   	push   %ebp
80108307:	89 e5                	mov    %esp,%ebp
80108309:	53                   	push   %ebx
8010830a:	83 ec 14             	sub    $0x14,%esp
  uint data;
  for(int i=0;i<256;i++){
8010830d:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80108314:	eb 6b                	jmp    80108381 <pci_init+0x7b>
    for(int j=0;j<32;j++){
80108316:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
8010831d:	eb 58                	jmp    80108377 <pci_init+0x71>
      for(int k=0;k<8;k++){
8010831f:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
80108326:	eb 45                	jmp    8010836d <pci_init+0x67>
      pci_access_config(i,j,k,0,&data);
80108328:	8b 4d ec             	mov    -0x14(%ebp),%ecx
8010832b:	8b 55 f0             	mov    -0x10(%ebp),%edx
8010832e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108331:	83 ec 0c             	sub    $0xc,%esp
80108334:	8d 5d e8             	lea    -0x18(%ebp),%ebx
80108337:	53                   	push   %ebx
80108338:	6a 00                	push   $0x0
8010833a:	51                   	push   %ecx
8010833b:	52                   	push   %edx
8010833c:	50                   	push   %eax
8010833d:	e8 b0 00 00 00       	call   801083f2 <pci_access_config>
80108342:	83 c4 20             	add    $0x20,%esp
      if((data&0xFFFF) != 0xFFFF){
80108345:	8b 45 e8             	mov    -0x18(%ebp),%eax
80108348:	0f b7 c0             	movzwl %ax,%eax
8010834b:	3d ff ff 00 00       	cmp    $0xffff,%eax
80108350:	74 17                	je     80108369 <pci_init+0x63>
        pci_init_device(i,j,k);
80108352:	8b 4d ec             	mov    -0x14(%ebp),%ecx
80108355:	8b 55 f0             	mov    -0x10(%ebp),%edx
80108358:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010835b:	83 ec 04             	sub    $0x4,%esp
8010835e:	51                   	push   %ecx
8010835f:	52                   	push   %edx
80108360:	50                   	push   %eax
80108361:	e8 37 01 00 00       	call   8010849d <pci_init_device>
80108366:	83 c4 10             	add    $0x10,%esp
      for(int k=0;k<8;k++){
80108369:	83 45 ec 01          	addl   $0x1,-0x14(%ebp)
8010836d:	83 7d ec 07          	cmpl   $0x7,-0x14(%ebp)
80108371:	7e b5                	jle    80108328 <pci_init+0x22>
    for(int j=0;j<32;j++){
80108373:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
80108377:	83 7d f0 1f          	cmpl   $0x1f,-0x10(%ebp)
8010837b:	7e a2                	jle    8010831f <pci_init+0x19>
  for(int i=0;i<256;i++){
8010837d:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80108381:	81 7d f4 ff 00 00 00 	cmpl   $0xff,-0xc(%ebp)
80108388:	7e 8c                	jle    80108316 <pci_init+0x10>
      }
      }
    }
  }
}
8010838a:	90                   	nop
8010838b:	90                   	nop
8010838c:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010838f:	c9                   	leave  
80108390:	c3                   	ret    

80108391 <pci_write_config>:

void pci_write_config(uint config){
80108391:	55                   	push   %ebp
80108392:	89 e5                	mov    %esp,%ebp
  asm("mov $0xCF8,%%edx\n\t"
80108394:	8b 45 08             	mov    0x8(%ebp),%eax
80108397:	ba f8 0c 00 00       	mov    $0xcf8,%edx
8010839c:	89 c0                	mov    %eax,%eax
8010839e:	ef                   	out    %eax,(%dx)
      "mov %0,%%eax\n\t"
      "out %%eax,%%dx\n\t"
      : :"r"(config));
}
8010839f:	90                   	nop
801083a0:	5d                   	pop    %ebp
801083a1:	c3                   	ret    

801083a2 <pci_write_data>:

void pci_write_data(uint config){
801083a2:	55                   	push   %ebp
801083a3:	89 e5                	mov    %esp,%ebp
  asm("mov $0xCFC,%%edx\n\t"
801083a5:	8b 45 08             	mov    0x8(%ebp),%eax
801083a8:	ba fc 0c 00 00       	mov    $0xcfc,%edx
801083ad:	89 c0                	mov    %eax,%eax
801083af:	ef                   	out    %eax,(%dx)
      "mov %0,%%eax\n\t"
      "out %%eax,%%dx\n\t"
      : :"r"(config));
}
801083b0:	90                   	nop
801083b1:	5d                   	pop    %ebp
801083b2:	c3                   	ret    

801083b3 <pci_read_config>:
uint pci_read_config(){
801083b3:	55                   	push   %ebp
801083b4:	89 e5                	mov    %esp,%ebp
801083b6:	83 ec 18             	sub    $0x18,%esp
  uint data;
  asm("mov $0xCFC,%%edx\n\t"
801083b9:	ba fc 0c 00 00       	mov    $0xcfc,%edx
801083be:	ed                   	in     (%dx),%eax
801083bf:	89 45 f4             	mov    %eax,-0xc(%ebp)
      "in %%dx,%%eax\n\t"
      "mov %%eax,%0"
      :"=m"(data):);
  microdelay(200);
801083c2:	83 ec 0c             	sub    $0xc,%esp
801083c5:	68 c8 00 00 00       	push   $0xc8
801083ca:	e8 68 a7 ff ff       	call   80102b37 <microdelay>
801083cf:	83 c4 10             	add    $0x10,%esp
  return data;
801083d2:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
801083d5:	c9                   	leave  
801083d6:	c3                   	ret    

801083d7 <pci_test>:


void pci_test(){
801083d7:	55                   	push   %ebp
801083d8:	89 e5                	mov    %esp,%ebp
801083da:	83 ec 10             	sub    $0x10,%esp
  uint data = 0x80001804;
801083dd:	c7 45 fc 04 18 00 80 	movl   $0x80001804,-0x4(%ebp)
  pci_write_config(data);
801083e4:	ff 75 fc             	push   -0x4(%ebp)
801083e7:	e8 a5 ff ff ff       	call   80108391 <pci_write_config>
801083ec:	83 c4 04             	add    $0x4,%esp
}
801083ef:	90                   	nop
801083f0:	c9                   	leave  
801083f1:	c3                   	ret    

801083f2 <pci_access_config>:

void pci_access_config(uint bus_num,uint device_num,uint function_num,uint reg_addr,uint *data){
801083f2:	55                   	push   %ebp
801083f3:	89 e5                	mov    %esp,%ebp
801083f5:	83 ec 18             	sub    $0x18,%esp
  uint config_addr = ((bus_num & 0xFF)<<16) | ((device_num & 0x1F)<<11) | ((function_num & 0x7)<<8) |
801083f8:	8b 45 08             	mov    0x8(%ebp),%eax
801083fb:	c1 e0 10             	shl    $0x10,%eax
801083fe:	25 00 00 ff 00       	and    $0xff0000,%eax
80108403:	89 c2                	mov    %eax,%edx
80108405:	8b 45 0c             	mov    0xc(%ebp),%eax
80108408:	c1 e0 0b             	shl    $0xb,%eax
8010840b:	0f b7 c0             	movzwl %ax,%eax
8010840e:	09 c2                	or     %eax,%edx
80108410:	8b 45 10             	mov    0x10(%ebp),%eax
80108413:	c1 e0 08             	shl    $0x8,%eax
80108416:	25 00 07 00 00       	and    $0x700,%eax
8010841b:	09 c2                	or     %eax,%edx
    (reg_addr & 0xFC) | 0x80000000;
8010841d:	8b 45 14             	mov    0x14(%ebp),%eax
80108420:	25 fc 00 00 00       	and    $0xfc,%eax
  uint config_addr = ((bus_num & 0xFF)<<16) | ((device_num & 0x1F)<<11) | ((function_num & 0x7)<<8) |
80108425:	09 d0                	or     %edx,%eax
80108427:	0d 00 00 00 80       	or     $0x80000000,%eax
8010842c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  pci_write_config(config_addr);
8010842f:	ff 75 f4             	push   -0xc(%ebp)
80108432:	e8 5a ff ff ff       	call   80108391 <pci_write_config>
80108437:	83 c4 04             	add    $0x4,%esp
  *data = pci_read_config();
8010843a:	e8 74 ff ff ff       	call   801083b3 <pci_read_config>
8010843f:	8b 55 18             	mov    0x18(%ebp),%edx
80108442:	89 02                	mov    %eax,(%edx)
}
80108444:	90                   	nop
80108445:	c9                   	leave  
80108446:	c3                   	ret    

80108447 <pci_write_config_register>:

void pci_write_config_register(uint bus_num,uint device_num,uint function_num,uint reg_addr,uint data){
80108447:	55                   	push   %ebp
80108448:	89 e5                	mov    %esp,%ebp
8010844a:	83 ec 10             	sub    $0x10,%esp
  uint config_addr = ((bus_num & 0xFF)<<16) | ((device_num & 0x1F)<<11) | ((function_num & 0x7)<<8) |
8010844d:	8b 45 08             	mov    0x8(%ebp),%eax
80108450:	c1 e0 10             	shl    $0x10,%eax
80108453:	25 00 00 ff 00       	and    $0xff0000,%eax
80108458:	89 c2                	mov    %eax,%edx
8010845a:	8b 45 0c             	mov    0xc(%ebp),%eax
8010845d:	c1 e0 0b             	shl    $0xb,%eax
80108460:	0f b7 c0             	movzwl %ax,%eax
80108463:	09 c2                	or     %eax,%edx
80108465:	8b 45 10             	mov    0x10(%ebp),%eax
80108468:	c1 e0 08             	shl    $0x8,%eax
8010846b:	25 00 07 00 00       	and    $0x700,%eax
80108470:	09 c2                	or     %eax,%edx
    (reg_addr & 0xFC) | 0x80000000;
80108472:	8b 45 14             	mov    0x14(%ebp),%eax
80108475:	25 fc 00 00 00       	and    $0xfc,%eax
  uint config_addr = ((bus_num & 0xFF)<<16) | ((device_num & 0x1F)<<11) | ((function_num & 0x7)<<8) |
8010847a:	09 d0                	or     %edx,%eax
8010847c:	0d 00 00 00 80       	or     $0x80000000,%eax
80108481:	89 45 fc             	mov    %eax,-0x4(%ebp)
  pci_write_config(config_addr);
80108484:	ff 75 fc             	push   -0x4(%ebp)
80108487:	e8 05 ff ff ff       	call   80108391 <pci_write_config>
8010848c:	83 c4 04             	add    $0x4,%esp
  pci_write_data(data);
8010848f:	ff 75 18             	push   0x18(%ebp)
80108492:	e8 0b ff ff ff       	call   801083a2 <pci_write_data>
80108497:	83 c4 04             	add    $0x4,%esp
}
8010849a:	90                   	nop
8010849b:	c9                   	leave  
8010849c:	c3                   	ret    

8010849d <pci_init_device>:

struct pci_dev dev;
void pci_init_device(uint bus_num,uint device_num,uint function_num){
8010849d:	55                   	push   %ebp
8010849e:	89 e5                	mov    %esp,%ebp
801084a0:	53                   	push   %ebx
801084a1:	83 ec 14             	sub    $0x14,%esp
  uint data;
  dev.bus_num = bus_num;
801084a4:	8b 45 08             	mov    0x8(%ebp),%eax
801084a7:	a2 64 6e 19 80       	mov    %al,0x80196e64
  dev.device_num = device_num;
801084ac:	8b 45 0c             	mov    0xc(%ebp),%eax
801084af:	a2 65 6e 19 80       	mov    %al,0x80196e65
  dev.function_num = function_num;
801084b4:	8b 45 10             	mov    0x10(%ebp),%eax
801084b7:	a2 66 6e 19 80       	mov    %al,0x80196e66
  cprintf("PCI Device Found Bus:0x%x Device:0x%x Function:%x\n",bus_num,device_num,function_num);
801084bc:	ff 75 10             	push   0x10(%ebp)
801084bf:	ff 75 0c             	push   0xc(%ebp)
801084c2:	ff 75 08             	push   0x8(%ebp)
801084c5:	68 44 c0 10 80       	push   $0x8010c044
801084ca:	e8 25 7f ff ff       	call   801003f4 <cprintf>
801084cf:	83 c4 10             	add    $0x10,%esp
  
  pci_access_config(bus_num,device_num,function_num,0,&data);
801084d2:	83 ec 0c             	sub    $0xc,%esp
801084d5:	8d 45 ec             	lea    -0x14(%ebp),%eax
801084d8:	50                   	push   %eax
801084d9:	6a 00                	push   $0x0
801084db:	ff 75 10             	push   0x10(%ebp)
801084de:	ff 75 0c             	push   0xc(%ebp)
801084e1:	ff 75 08             	push   0x8(%ebp)
801084e4:	e8 09 ff ff ff       	call   801083f2 <pci_access_config>
801084e9:	83 c4 20             	add    $0x20,%esp
  uint device_id = data>>16;
801084ec:	8b 45 ec             	mov    -0x14(%ebp),%eax
801084ef:	c1 e8 10             	shr    $0x10,%eax
801084f2:	89 45 f4             	mov    %eax,-0xc(%ebp)
  uint vendor_id = data&0xFFFF;
801084f5:	8b 45 ec             	mov    -0x14(%ebp),%eax
801084f8:	25 ff ff 00 00       	and    $0xffff,%eax
801084fd:	89 45 f0             	mov    %eax,-0x10(%ebp)
  dev.device_id = device_id;
80108500:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108503:	a3 68 6e 19 80       	mov    %eax,0x80196e68
  dev.vendor_id = vendor_id;
80108508:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010850b:	a3 6c 6e 19 80       	mov    %eax,0x80196e6c
  cprintf("  Device ID:0x%x  Vendor ID:0x%x\n",device_id,vendor_id);
80108510:	83 ec 04             	sub    $0x4,%esp
80108513:	ff 75 f0             	push   -0x10(%ebp)
80108516:	ff 75 f4             	push   -0xc(%ebp)
80108519:	68 78 c0 10 80       	push   $0x8010c078
8010851e:	e8 d1 7e ff ff       	call   801003f4 <cprintf>
80108523:	83 c4 10             	add    $0x10,%esp
  
  pci_access_config(bus_num,device_num,function_num,0x8,&data);
80108526:	83 ec 0c             	sub    $0xc,%esp
80108529:	8d 45 ec             	lea    -0x14(%ebp),%eax
8010852c:	50                   	push   %eax
8010852d:	6a 08                	push   $0x8
8010852f:	ff 75 10             	push   0x10(%ebp)
80108532:	ff 75 0c             	push   0xc(%ebp)
80108535:	ff 75 08             	push   0x8(%ebp)
80108538:	e8 b5 fe ff ff       	call   801083f2 <pci_access_config>
8010853d:	83 c4 20             	add    $0x20,%esp
  cprintf("  Base Class:0x%x  Sub Class:0x%x  Interface:0x%x  Revision ID:0x%x\n",
80108540:	8b 45 ec             	mov    -0x14(%ebp),%eax
80108543:	0f b6 c8             	movzbl %al,%ecx
      data>>24,(data>>16)&0xFF,(data>>8)&0xFF,data&0xFF);
80108546:	8b 45 ec             	mov    -0x14(%ebp),%eax
80108549:	c1 e8 08             	shr    $0x8,%eax
  cprintf("  Base Class:0x%x  Sub Class:0x%x  Interface:0x%x  Revision ID:0x%x\n",
8010854c:	0f b6 d0             	movzbl %al,%edx
      data>>24,(data>>16)&0xFF,(data>>8)&0xFF,data&0xFF);
8010854f:	8b 45 ec             	mov    -0x14(%ebp),%eax
80108552:	c1 e8 10             	shr    $0x10,%eax
  cprintf("  Base Class:0x%x  Sub Class:0x%x  Interface:0x%x  Revision ID:0x%x\n",
80108555:	0f b6 c0             	movzbl %al,%eax
80108558:	8b 5d ec             	mov    -0x14(%ebp),%ebx
8010855b:	c1 eb 18             	shr    $0x18,%ebx
8010855e:	83 ec 0c             	sub    $0xc,%esp
80108561:	51                   	push   %ecx
80108562:	52                   	push   %edx
80108563:	50                   	push   %eax
80108564:	53                   	push   %ebx
80108565:	68 9c c0 10 80       	push   $0x8010c09c
8010856a:	e8 85 7e ff ff       	call   801003f4 <cprintf>
8010856f:	83 c4 20             	add    $0x20,%esp
  dev.base_class = data>>24;
80108572:	8b 45 ec             	mov    -0x14(%ebp),%eax
80108575:	c1 e8 18             	shr    $0x18,%eax
80108578:	a2 70 6e 19 80       	mov    %al,0x80196e70
  dev.sub_class = (data>>16)&0xFF;
8010857d:	8b 45 ec             	mov    -0x14(%ebp),%eax
80108580:	c1 e8 10             	shr    $0x10,%eax
80108583:	a2 71 6e 19 80       	mov    %al,0x80196e71
  dev.interface = (data>>8)&0xFF;
80108588:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010858b:	c1 e8 08             	shr    $0x8,%eax
8010858e:	a2 72 6e 19 80       	mov    %al,0x80196e72
  dev.revision_id = data&0xFF;
80108593:	8b 45 ec             	mov    -0x14(%ebp),%eax
80108596:	a2 73 6e 19 80       	mov    %al,0x80196e73
  
  pci_access_config(bus_num,device_num,function_num,0x10,&data);
8010859b:	83 ec 0c             	sub    $0xc,%esp
8010859e:	8d 45 ec             	lea    -0x14(%ebp),%eax
801085a1:	50                   	push   %eax
801085a2:	6a 10                	push   $0x10
801085a4:	ff 75 10             	push   0x10(%ebp)
801085a7:	ff 75 0c             	push   0xc(%ebp)
801085aa:	ff 75 08             	push   0x8(%ebp)
801085ad:	e8 40 fe ff ff       	call   801083f2 <pci_access_config>
801085b2:	83 c4 20             	add    $0x20,%esp
  dev.bar0 = data;
801085b5:	8b 45 ec             	mov    -0x14(%ebp),%eax
801085b8:	a3 74 6e 19 80       	mov    %eax,0x80196e74
  pci_access_config(bus_num,device_num,function_num,0x14,&data);
801085bd:	83 ec 0c             	sub    $0xc,%esp
801085c0:	8d 45 ec             	lea    -0x14(%ebp),%eax
801085c3:	50                   	push   %eax
801085c4:	6a 14                	push   $0x14
801085c6:	ff 75 10             	push   0x10(%ebp)
801085c9:	ff 75 0c             	push   0xc(%ebp)
801085cc:	ff 75 08             	push   0x8(%ebp)
801085cf:	e8 1e fe ff ff       	call   801083f2 <pci_access_config>
801085d4:	83 c4 20             	add    $0x20,%esp
  dev.bar1 = data;
801085d7:	8b 45 ec             	mov    -0x14(%ebp),%eax
801085da:	a3 78 6e 19 80       	mov    %eax,0x80196e78
  if(device_id == I8254_DEVICE_ID && vendor_id == I8254_VENDOR_ID){
801085df:	81 7d f4 0e 10 00 00 	cmpl   $0x100e,-0xc(%ebp)
801085e6:	75 5a                	jne    80108642 <pci_init_device+0x1a5>
801085e8:	81 7d f0 86 80 00 00 	cmpl   $0x8086,-0x10(%ebp)
801085ef:	75 51                	jne    80108642 <pci_init_device+0x1a5>
    cprintf("E1000 Ethernet NIC Found\n");
801085f1:	83 ec 0c             	sub    $0xc,%esp
801085f4:	68 e1 c0 10 80       	push   $0x8010c0e1
801085f9:	e8 f6 7d ff ff       	call   801003f4 <cprintf>
801085fe:	83 c4 10             	add    $0x10,%esp
    pci_access_config(bus_num,device_num,function_num,0xF0,&data);
80108601:	83 ec 0c             	sub    $0xc,%esp
80108604:	8d 45 ec             	lea    -0x14(%ebp),%eax
80108607:	50                   	push   %eax
80108608:	68 f0 00 00 00       	push   $0xf0
8010860d:	ff 75 10             	push   0x10(%ebp)
80108610:	ff 75 0c             	push   0xc(%ebp)
80108613:	ff 75 08             	push   0x8(%ebp)
80108616:	e8 d7 fd ff ff       	call   801083f2 <pci_access_config>
8010861b:	83 c4 20             	add    $0x20,%esp
    cprintf("Message Control:%x\n",data);
8010861e:	8b 45 ec             	mov    -0x14(%ebp),%eax
80108621:	83 ec 08             	sub    $0x8,%esp
80108624:	50                   	push   %eax
80108625:	68 fb c0 10 80       	push   $0x8010c0fb
8010862a:	e8 c5 7d ff ff       	call   801003f4 <cprintf>
8010862f:	83 c4 10             	add    $0x10,%esp
    i8254_init(&dev);
80108632:	83 ec 0c             	sub    $0xc,%esp
80108635:	68 64 6e 19 80       	push   $0x80196e64
8010863a:	e8 09 00 00 00       	call   80108648 <i8254_init>
8010863f:	83 c4 10             	add    $0x10,%esp
  }
}
80108642:	90                   	nop
80108643:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80108646:	c9                   	leave  
80108647:	c3                   	ret    

80108648 <i8254_init>:

uint base_addr;
uchar mac_addr[6] = {0};
uchar my_ip[4] = {10,0,1,10}; 
uint *intr_addr;
void i8254_init(struct pci_dev *dev){
80108648:	55                   	push   %ebp
80108649:	89 e5                	mov    %esp,%ebp
8010864b:	53                   	push   %ebx
8010864c:	83 ec 14             	sub    $0x14,%esp
  uint cmd_reg;
  //Enable Bus Master
  pci_access_config(dev->bus_num,dev->device_num,dev->function_num,0x04,&cmd_reg);
8010864f:	8b 45 08             	mov    0x8(%ebp),%eax
80108652:	0f b6 40 02          	movzbl 0x2(%eax),%eax
80108656:	0f b6 c8             	movzbl %al,%ecx
80108659:	8b 45 08             	mov    0x8(%ebp),%eax
8010865c:	0f b6 40 01          	movzbl 0x1(%eax),%eax
80108660:	0f b6 d0             	movzbl %al,%edx
80108663:	8b 45 08             	mov    0x8(%ebp),%eax
80108666:	0f b6 00             	movzbl (%eax),%eax
80108669:	0f b6 c0             	movzbl %al,%eax
8010866c:	83 ec 0c             	sub    $0xc,%esp
8010866f:	8d 5d ec             	lea    -0x14(%ebp),%ebx
80108672:	53                   	push   %ebx
80108673:	6a 04                	push   $0x4
80108675:	51                   	push   %ecx
80108676:	52                   	push   %edx
80108677:	50                   	push   %eax
80108678:	e8 75 fd ff ff       	call   801083f2 <pci_access_config>
8010867d:	83 c4 20             	add    $0x20,%esp
  cmd_reg = cmd_reg | PCI_CMD_BUS_MASTER;
80108680:	8b 45 ec             	mov    -0x14(%ebp),%eax
80108683:	83 c8 04             	or     $0x4,%eax
80108686:	89 45 ec             	mov    %eax,-0x14(%ebp)
  pci_write_config_register(dev->bus_num,dev->device_num,dev->function_num,0x04,cmd_reg);
80108689:	8b 5d ec             	mov    -0x14(%ebp),%ebx
8010868c:	8b 45 08             	mov    0x8(%ebp),%eax
8010868f:	0f b6 40 02          	movzbl 0x2(%eax),%eax
80108693:	0f b6 c8             	movzbl %al,%ecx
80108696:	8b 45 08             	mov    0x8(%ebp),%eax
80108699:	0f b6 40 01          	movzbl 0x1(%eax),%eax
8010869d:	0f b6 d0             	movzbl %al,%edx
801086a0:	8b 45 08             	mov    0x8(%ebp),%eax
801086a3:	0f b6 00             	movzbl (%eax),%eax
801086a6:	0f b6 c0             	movzbl %al,%eax
801086a9:	83 ec 0c             	sub    $0xc,%esp
801086ac:	53                   	push   %ebx
801086ad:	6a 04                	push   $0x4
801086af:	51                   	push   %ecx
801086b0:	52                   	push   %edx
801086b1:	50                   	push   %eax
801086b2:	e8 90 fd ff ff       	call   80108447 <pci_write_config_register>
801086b7:	83 c4 20             	add    $0x20,%esp
  
  base_addr = PCI_P2V(dev->bar0);
801086ba:	8b 45 08             	mov    0x8(%ebp),%eax
801086bd:	8b 40 10             	mov    0x10(%eax),%eax
801086c0:	05 00 00 00 40       	add    $0x40000000,%eax
801086c5:	a3 7c 6e 19 80       	mov    %eax,0x80196e7c
  uint *ctrl = (uint *)base_addr;
801086ca:	a1 7c 6e 19 80       	mov    0x80196e7c,%eax
801086cf:	89 45 f4             	mov    %eax,-0xc(%ebp)
  //Disable Interrupts
  uint *imc = (uint *)(base_addr+0xD8);
801086d2:	a1 7c 6e 19 80       	mov    0x80196e7c,%eax
801086d7:	05 d8 00 00 00       	add    $0xd8,%eax
801086dc:	89 45 f0             	mov    %eax,-0x10(%ebp)
  *imc = 0xFFFFFFFF;
801086df:	8b 45 f0             	mov    -0x10(%ebp),%eax
801086e2:	c7 00 ff ff ff ff    	movl   $0xffffffff,(%eax)
  
  //Reset NIC
  *ctrl = *ctrl | I8254_CTRL_RST;
801086e8:	8b 45 f4             	mov    -0xc(%ebp),%eax
801086eb:	8b 00                	mov    (%eax),%eax
801086ed:	0d 00 00 00 04       	or     $0x4000000,%eax
801086f2:	89 c2                	mov    %eax,%edx
801086f4:	8b 45 f4             	mov    -0xc(%ebp),%eax
801086f7:	89 10                	mov    %edx,(%eax)

  //Enable Interrupts
  *imc = 0xFFFFFFFF;
801086f9:	8b 45 f0             	mov    -0x10(%ebp),%eax
801086fc:	c7 00 ff ff ff ff    	movl   $0xffffffff,(%eax)

  //Enable Link
  *ctrl |= I8254_CTRL_SLU;
80108702:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108705:	8b 00                	mov    (%eax),%eax
80108707:	83 c8 40             	or     $0x40,%eax
8010870a:	89 c2                	mov    %eax,%edx
8010870c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010870f:	89 10                	mov    %edx,(%eax)
  
  //General Configuration
  *ctrl &= (~I8254_CTRL_PHY_RST | ~I8254_CTRL_VME | ~I8254_CTRL_ILOS);
80108711:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108714:	8b 10                	mov    (%eax),%edx
80108716:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108719:	89 10                	mov    %edx,(%eax)
  cprintf("E1000 General Configuration Done\n");
8010871b:	83 ec 0c             	sub    $0xc,%esp
8010871e:	68 10 c1 10 80       	push   $0x8010c110
80108723:	e8 cc 7c ff ff       	call   801003f4 <cprintf>
80108728:	83 c4 10             	add    $0x10,%esp
  intr_addr = (uint *)kalloc();
8010872b:	e8 70 a0 ff ff       	call   801027a0 <kalloc>
80108730:	a3 88 6e 19 80       	mov    %eax,0x80196e88
  *intr_addr = 0;
80108735:	a1 88 6e 19 80       	mov    0x80196e88,%eax
8010873a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  cprintf("INTR_ADDR:%x\n",intr_addr);
80108740:	a1 88 6e 19 80       	mov    0x80196e88,%eax
80108745:	83 ec 08             	sub    $0x8,%esp
80108748:	50                   	push   %eax
80108749:	68 32 c1 10 80       	push   $0x8010c132
8010874e:	e8 a1 7c ff ff       	call   801003f4 <cprintf>
80108753:	83 c4 10             	add    $0x10,%esp
  i8254_init_recv();
80108756:	e8 50 00 00 00       	call   801087ab <i8254_init_recv>
  i8254_init_send();
8010875b:	e8 69 03 00 00       	call   80108ac9 <i8254_init_send>
  cprintf("IP Address %d.%d.%d.%d\n",
      my_ip[0],
      my_ip[1],
      my_ip[2],
      my_ip[3]);
80108760:	0f b6 05 07 f5 10 80 	movzbl 0x8010f507,%eax
  cprintf("IP Address %d.%d.%d.%d\n",
80108767:	0f b6 d8             	movzbl %al,%ebx
      my_ip[2],
8010876a:	0f b6 05 06 f5 10 80 	movzbl 0x8010f506,%eax
  cprintf("IP Address %d.%d.%d.%d\n",
80108771:	0f b6 c8             	movzbl %al,%ecx
      my_ip[1],
80108774:	0f b6 05 05 f5 10 80 	movzbl 0x8010f505,%eax
  cprintf("IP Address %d.%d.%d.%d\n",
8010877b:	0f b6 d0             	movzbl %al,%edx
      my_ip[0],
8010877e:	0f b6 05 04 f5 10 80 	movzbl 0x8010f504,%eax
  cprintf("IP Address %d.%d.%d.%d\n",
80108785:	0f b6 c0             	movzbl %al,%eax
80108788:	83 ec 0c             	sub    $0xc,%esp
8010878b:	53                   	push   %ebx
8010878c:	51                   	push   %ecx
8010878d:	52                   	push   %edx
8010878e:	50                   	push   %eax
8010878f:	68 40 c1 10 80       	push   $0x8010c140
80108794:	e8 5b 7c ff ff       	call   801003f4 <cprintf>
80108799:	83 c4 20             	add    $0x20,%esp
  *imc = 0x0;
8010879c:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010879f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
}
801087a5:	90                   	nop
801087a6:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801087a9:	c9                   	leave  
801087aa:	c3                   	ret    

801087ab <i8254_init_recv>:

void i8254_init_recv(){
801087ab:	55                   	push   %ebp
801087ac:	89 e5                	mov    %esp,%ebp
801087ae:	57                   	push   %edi
801087af:	56                   	push   %esi
801087b0:	53                   	push   %ebx
801087b1:	83 ec 6c             	sub    $0x6c,%esp
  
  uint data_l = i8254_read_eeprom(0x0);
801087b4:	83 ec 0c             	sub    $0xc,%esp
801087b7:	6a 00                	push   $0x0
801087b9:	e8 e8 04 00 00       	call   80108ca6 <i8254_read_eeprom>
801087be:	83 c4 10             	add    $0x10,%esp
801087c1:	89 45 d8             	mov    %eax,-0x28(%ebp)
  mac_addr[0] = data_l&0xFF;
801087c4:	8b 45 d8             	mov    -0x28(%ebp),%eax
801087c7:	a2 80 6e 19 80       	mov    %al,0x80196e80
  mac_addr[1] = data_l>>8;
801087cc:	8b 45 d8             	mov    -0x28(%ebp),%eax
801087cf:	c1 e8 08             	shr    $0x8,%eax
801087d2:	a2 81 6e 19 80       	mov    %al,0x80196e81
  uint data_m = i8254_read_eeprom(0x1);
801087d7:	83 ec 0c             	sub    $0xc,%esp
801087da:	6a 01                	push   $0x1
801087dc:	e8 c5 04 00 00       	call   80108ca6 <i8254_read_eeprom>
801087e1:	83 c4 10             	add    $0x10,%esp
801087e4:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  mac_addr[2] = data_m&0xFF;
801087e7:	8b 45 d4             	mov    -0x2c(%ebp),%eax
801087ea:	a2 82 6e 19 80       	mov    %al,0x80196e82
  mac_addr[3] = data_m>>8;
801087ef:	8b 45 d4             	mov    -0x2c(%ebp),%eax
801087f2:	c1 e8 08             	shr    $0x8,%eax
801087f5:	a2 83 6e 19 80       	mov    %al,0x80196e83
  uint data_h = i8254_read_eeprom(0x2);
801087fa:	83 ec 0c             	sub    $0xc,%esp
801087fd:	6a 02                	push   $0x2
801087ff:	e8 a2 04 00 00       	call   80108ca6 <i8254_read_eeprom>
80108804:	83 c4 10             	add    $0x10,%esp
80108807:	89 45 d0             	mov    %eax,-0x30(%ebp)
  mac_addr[4] = data_h&0xFF;
8010880a:	8b 45 d0             	mov    -0x30(%ebp),%eax
8010880d:	a2 84 6e 19 80       	mov    %al,0x80196e84
  mac_addr[5] = data_h>>8;
80108812:	8b 45 d0             	mov    -0x30(%ebp),%eax
80108815:	c1 e8 08             	shr    $0x8,%eax
80108818:	a2 85 6e 19 80       	mov    %al,0x80196e85
      mac_addr[0],
      mac_addr[1],
      mac_addr[2],
      mac_addr[3],
      mac_addr[4],
      mac_addr[5]);
8010881d:	0f b6 05 85 6e 19 80 	movzbl 0x80196e85,%eax
  cprintf("MAC Address %x:%x:%x:%x:%x:%x\n",
80108824:	0f b6 f8             	movzbl %al,%edi
      mac_addr[4],
80108827:	0f b6 05 84 6e 19 80 	movzbl 0x80196e84,%eax
  cprintf("MAC Address %x:%x:%x:%x:%x:%x\n",
8010882e:	0f b6 f0             	movzbl %al,%esi
      mac_addr[3],
80108831:	0f b6 05 83 6e 19 80 	movzbl 0x80196e83,%eax
  cprintf("MAC Address %x:%x:%x:%x:%x:%x\n",
80108838:	0f b6 d8             	movzbl %al,%ebx
      mac_addr[2],
8010883b:	0f b6 05 82 6e 19 80 	movzbl 0x80196e82,%eax
  cprintf("MAC Address %x:%x:%x:%x:%x:%x\n",
80108842:	0f b6 c8             	movzbl %al,%ecx
      mac_addr[1],
80108845:	0f b6 05 81 6e 19 80 	movzbl 0x80196e81,%eax
  cprintf("MAC Address %x:%x:%x:%x:%x:%x\n",
8010884c:	0f b6 d0             	movzbl %al,%edx
      mac_addr[0],
8010884f:	0f b6 05 80 6e 19 80 	movzbl 0x80196e80,%eax
  cprintf("MAC Address %x:%x:%x:%x:%x:%x\n",
80108856:	0f b6 c0             	movzbl %al,%eax
80108859:	83 ec 04             	sub    $0x4,%esp
8010885c:	57                   	push   %edi
8010885d:	56                   	push   %esi
8010885e:	53                   	push   %ebx
8010885f:	51                   	push   %ecx
80108860:	52                   	push   %edx
80108861:	50                   	push   %eax
80108862:	68 58 c1 10 80       	push   $0x8010c158
80108867:	e8 88 7b ff ff       	call   801003f4 <cprintf>
8010886c:	83 c4 20             	add    $0x20,%esp

  uint *ral = (uint *)(base_addr + 0x5400);
8010886f:	a1 7c 6e 19 80       	mov    0x80196e7c,%eax
80108874:	05 00 54 00 00       	add    $0x5400,%eax
80108879:	89 45 cc             	mov    %eax,-0x34(%ebp)
  uint *rah = (uint *)(base_addr + 0x5404);
8010887c:	a1 7c 6e 19 80       	mov    0x80196e7c,%eax
80108881:	05 04 54 00 00       	add    $0x5404,%eax
80108886:	89 45 c8             	mov    %eax,-0x38(%ebp)

  *ral = (data_l | (data_m << 16));
80108889:	8b 45 d4             	mov    -0x2c(%ebp),%eax
8010888c:	c1 e0 10             	shl    $0x10,%eax
8010888f:	0b 45 d8             	or     -0x28(%ebp),%eax
80108892:	89 c2                	mov    %eax,%edx
80108894:	8b 45 cc             	mov    -0x34(%ebp),%eax
80108897:	89 10                	mov    %edx,(%eax)
  *rah = (data_h | I8254_RAH_AS_DEST | I8254_RAH_AV);
80108899:	8b 45 d0             	mov    -0x30(%ebp),%eax
8010889c:	0d 00 00 00 80       	or     $0x80000000,%eax
801088a1:	89 c2                	mov    %eax,%edx
801088a3:	8b 45 c8             	mov    -0x38(%ebp),%eax
801088a6:	89 10                	mov    %edx,(%eax)

  uint *mta = (uint *)(base_addr + 0x5200);
801088a8:	a1 7c 6e 19 80       	mov    0x80196e7c,%eax
801088ad:	05 00 52 00 00       	add    $0x5200,%eax
801088b2:	89 45 c4             	mov    %eax,-0x3c(%ebp)
  for(int i=0;i<128;i++){
801088b5:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
801088bc:	eb 19                	jmp    801088d7 <i8254_init_recv+0x12c>
    mta[i] = 0;
801088be:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801088c1:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
801088c8:	8b 45 c4             	mov    -0x3c(%ebp),%eax
801088cb:	01 d0                	add    %edx,%eax
801088cd:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  for(int i=0;i<128;i++){
801088d3:	83 45 e4 01          	addl   $0x1,-0x1c(%ebp)
801088d7:	83 7d e4 7f          	cmpl   $0x7f,-0x1c(%ebp)
801088db:	7e e1                	jle    801088be <i8254_init_recv+0x113>
  }

  uint *ims = (uint *)(base_addr + 0xD0);
801088dd:	a1 7c 6e 19 80       	mov    0x80196e7c,%eax
801088e2:	05 d0 00 00 00       	add    $0xd0,%eax
801088e7:	89 45 c0             	mov    %eax,-0x40(%ebp)
  *ims = (I8254_IMS_RXT0 | I8254_IMS_RXDMT0 | I8254_IMS_RXSEQ | I8254_IMS_LSC | I8254_IMS_RXO);
801088ea:	8b 45 c0             	mov    -0x40(%ebp),%eax
801088ed:	c7 00 dc 00 00 00    	movl   $0xdc,(%eax)
  uint *ics = (uint *)(base_addr + 0xC8);
801088f3:	a1 7c 6e 19 80       	mov    0x80196e7c,%eax
801088f8:	05 c8 00 00 00       	add    $0xc8,%eax
801088fd:	89 45 bc             	mov    %eax,-0x44(%ebp)
  *ics = (I8254_IMS_RXT0 | I8254_IMS_RXDMT0 | I8254_IMS_RXSEQ | I8254_IMS_LSC | I8254_IMS_RXO);
80108900:	8b 45 bc             	mov    -0x44(%ebp),%eax
80108903:	c7 00 dc 00 00 00    	movl   $0xdc,(%eax)



  uint *rxdctl = (uint *)(base_addr + 0x2828);
80108909:	a1 7c 6e 19 80       	mov    0x80196e7c,%eax
8010890e:	05 28 28 00 00       	add    $0x2828,%eax
80108913:	89 45 b8             	mov    %eax,-0x48(%ebp)
  *rxdctl = 0;
80108916:	8b 45 b8             	mov    -0x48(%ebp),%eax
80108919:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

  uint *rctl = (uint *)(base_addr + 0x100);
8010891f:	a1 7c 6e 19 80       	mov    0x80196e7c,%eax
80108924:	05 00 01 00 00       	add    $0x100,%eax
80108929:	89 45 b4             	mov    %eax,-0x4c(%ebp)
  *rctl = (I8254_RCTL_UPE | I8254_RCTL_MPE | I8254_RCTL_BAM | I8254_RCTL_BSIZE | I8254_RCTL_SECRC);
8010892c:	8b 45 b4             	mov    -0x4c(%ebp),%eax
8010892f:	c7 00 18 80 00 04    	movl   $0x4008018,(%eax)

  uint recv_desc_addr = (uint)kalloc();
80108935:	e8 66 9e ff ff       	call   801027a0 <kalloc>
8010893a:	89 45 b0             	mov    %eax,-0x50(%ebp)
  uint *rdbal = (uint *)(base_addr + 0x2800);
8010893d:	a1 7c 6e 19 80       	mov    0x80196e7c,%eax
80108942:	05 00 28 00 00       	add    $0x2800,%eax
80108947:	89 45 ac             	mov    %eax,-0x54(%ebp)
  uint *rdbah = (uint *)(base_addr + 0x2804);
8010894a:	a1 7c 6e 19 80       	mov    0x80196e7c,%eax
8010894f:	05 04 28 00 00       	add    $0x2804,%eax
80108954:	89 45 a8             	mov    %eax,-0x58(%ebp)
  uint *rdlen = (uint *)(base_addr + 0x2808);
80108957:	a1 7c 6e 19 80       	mov    0x80196e7c,%eax
8010895c:	05 08 28 00 00       	add    $0x2808,%eax
80108961:	89 45 a4             	mov    %eax,-0x5c(%ebp)
  uint *rdh = (uint *)(base_addr + 0x2810);
80108964:	a1 7c 6e 19 80       	mov    0x80196e7c,%eax
80108969:	05 10 28 00 00       	add    $0x2810,%eax
8010896e:	89 45 a0             	mov    %eax,-0x60(%ebp)
  uint *rdt = (uint *)(base_addr + 0x2818);
80108971:	a1 7c 6e 19 80       	mov    0x80196e7c,%eax
80108976:	05 18 28 00 00       	add    $0x2818,%eax
8010897b:	89 45 9c             	mov    %eax,-0x64(%ebp)

  *rdbal = V2P(recv_desc_addr);
8010897e:	8b 45 b0             	mov    -0x50(%ebp),%eax
80108981:	8d 90 00 00 00 80    	lea    -0x80000000(%eax),%edx
80108987:	8b 45 ac             	mov    -0x54(%ebp),%eax
8010898a:	89 10                	mov    %edx,(%eax)
  *rdbah = 0;
8010898c:	8b 45 a8             	mov    -0x58(%ebp),%eax
8010898f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  *rdlen = sizeof(struct i8254_recv_desc)*I8254_RECV_DESC_NUM;
80108995:	8b 45 a4             	mov    -0x5c(%ebp),%eax
80108998:	c7 00 00 10 00 00    	movl   $0x1000,(%eax)
  *rdh = 0;
8010899e:	8b 45 a0             	mov    -0x60(%ebp),%eax
801089a1:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  *rdt = I8254_RECV_DESC_NUM;
801089a7:	8b 45 9c             	mov    -0x64(%ebp),%eax
801089aa:	c7 00 00 01 00 00    	movl   $0x100,(%eax)

  struct i8254_recv_desc *recv_desc = (struct i8254_recv_desc *)recv_desc_addr;
801089b0:	8b 45 b0             	mov    -0x50(%ebp),%eax
801089b3:	89 45 98             	mov    %eax,-0x68(%ebp)
  for(int i=0;i<I8254_RECV_DESC_NUM;i++){
801089b6:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
801089bd:	eb 73                	jmp    80108a32 <i8254_init_recv+0x287>
    recv_desc[i].padding = 0;
801089bf:	8b 45 e0             	mov    -0x20(%ebp),%eax
801089c2:	c1 e0 04             	shl    $0x4,%eax
801089c5:	89 c2                	mov    %eax,%edx
801089c7:	8b 45 98             	mov    -0x68(%ebp),%eax
801089ca:	01 d0                	add    %edx,%eax
801089cc:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
    recv_desc[i].len = 0;
801089d3:	8b 45 e0             	mov    -0x20(%ebp),%eax
801089d6:	c1 e0 04             	shl    $0x4,%eax
801089d9:	89 c2                	mov    %eax,%edx
801089db:	8b 45 98             	mov    -0x68(%ebp),%eax
801089de:	01 d0                	add    %edx,%eax
801089e0:	66 c7 40 08 00 00    	movw   $0x0,0x8(%eax)
    recv_desc[i].chk_sum = 0;
801089e6:	8b 45 e0             	mov    -0x20(%ebp),%eax
801089e9:	c1 e0 04             	shl    $0x4,%eax
801089ec:	89 c2                	mov    %eax,%edx
801089ee:	8b 45 98             	mov    -0x68(%ebp),%eax
801089f1:	01 d0                	add    %edx,%eax
801089f3:	66 c7 40 0a 00 00    	movw   $0x0,0xa(%eax)
    recv_desc[i].status = 0;
801089f9:	8b 45 e0             	mov    -0x20(%ebp),%eax
801089fc:	c1 e0 04             	shl    $0x4,%eax
801089ff:	89 c2                	mov    %eax,%edx
80108a01:	8b 45 98             	mov    -0x68(%ebp),%eax
80108a04:	01 d0                	add    %edx,%eax
80108a06:	c6 40 0c 00          	movb   $0x0,0xc(%eax)
    recv_desc[i].errors = 0;
80108a0a:	8b 45 e0             	mov    -0x20(%ebp),%eax
80108a0d:	c1 e0 04             	shl    $0x4,%eax
80108a10:	89 c2                	mov    %eax,%edx
80108a12:	8b 45 98             	mov    -0x68(%ebp),%eax
80108a15:	01 d0                	add    %edx,%eax
80108a17:	c6 40 0d 00          	movb   $0x0,0xd(%eax)
    recv_desc[i].special = 0;
80108a1b:	8b 45 e0             	mov    -0x20(%ebp),%eax
80108a1e:	c1 e0 04             	shl    $0x4,%eax
80108a21:	89 c2                	mov    %eax,%edx
80108a23:	8b 45 98             	mov    -0x68(%ebp),%eax
80108a26:	01 d0                	add    %edx,%eax
80108a28:	66 c7 40 0e 00 00    	movw   $0x0,0xe(%eax)
  for(int i=0;i<I8254_RECV_DESC_NUM;i++){
80108a2e:	83 45 e0 01          	addl   $0x1,-0x20(%ebp)
80108a32:	81 7d e0 ff 00 00 00 	cmpl   $0xff,-0x20(%ebp)
80108a39:	7e 84                	jle    801089bf <i8254_init_recv+0x214>
  }

  for(int i=0;i<(I8254_RECV_DESC_NUM)/2;i++){
80108a3b:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
80108a42:	eb 57                	jmp    80108a9b <i8254_init_recv+0x2f0>
    uint buf_addr = (uint)kalloc();
80108a44:	e8 57 9d ff ff       	call   801027a0 <kalloc>
80108a49:	89 45 94             	mov    %eax,-0x6c(%ebp)
    if(buf_addr == 0){
80108a4c:	83 7d 94 00          	cmpl   $0x0,-0x6c(%ebp)
80108a50:	75 12                	jne    80108a64 <i8254_init_recv+0x2b9>
      cprintf("failed to allocate buffer area\n");
80108a52:	83 ec 0c             	sub    $0xc,%esp
80108a55:	68 78 c1 10 80       	push   $0x8010c178
80108a5a:	e8 95 79 ff ff       	call   801003f4 <cprintf>
80108a5f:	83 c4 10             	add    $0x10,%esp
      break;
80108a62:	eb 3d                	jmp    80108aa1 <i8254_init_recv+0x2f6>
    }
    recv_desc[i].buf_addr = V2P(buf_addr);
80108a64:	8b 45 dc             	mov    -0x24(%ebp),%eax
80108a67:	c1 e0 04             	shl    $0x4,%eax
80108a6a:	89 c2                	mov    %eax,%edx
80108a6c:	8b 45 98             	mov    -0x68(%ebp),%eax
80108a6f:	01 d0                	add    %edx,%eax
80108a71:	8b 55 94             	mov    -0x6c(%ebp),%edx
80108a74:	81 c2 00 00 00 80    	add    $0x80000000,%edx
80108a7a:	89 10                	mov    %edx,(%eax)
    recv_desc[i+1].buf_addr = V2P(buf_addr + 0x800);
80108a7c:	8b 45 dc             	mov    -0x24(%ebp),%eax
80108a7f:	83 c0 01             	add    $0x1,%eax
80108a82:	c1 e0 04             	shl    $0x4,%eax
80108a85:	89 c2                	mov    %eax,%edx
80108a87:	8b 45 98             	mov    -0x68(%ebp),%eax
80108a8a:	01 d0                	add    %edx,%eax
80108a8c:	8b 55 94             	mov    -0x6c(%ebp),%edx
80108a8f:	81 ea 00 f8 ff 7f    	sub    $0x7ffff800,%edx
80108a95:	89 10                	mov    %edx,(%eax)
  for(int i=0;i<(I8254_RECV_DESC_NUM)/2;i++){
80108a97:	83 45 dc 01          	addl   $0x1,-0x24(%ebp)
80108a9b:	83 7d dc 7f          	cmpl   $0x7f,-0x24(%ebp)
80108a9f:	7e a3                	jle    80108a44 <i8254_init_recv+0x299>
  }

  *rctl |= I8254_RCTL_EN;
80108aa1:	8b 45 b4             	mov    -0x4c(%ebp),%eax
80108aa4:	8b 00                	mov    (%eax),%eax
80108aa6:	83 c8 02             	or     $0x2,%eax
80108aa9:	89 c2                	mov    %eax,%edx
80108aab:	8b 45 b4             	mov    -0x4c(%ebp),%eax
80108aae:	89 10                	mov    %edx,(%eax)
  cprintf("E1000 Recieve Initialize Done\n");
80108ab0:	83 ec 0c             	sub    $0xc,%esp
80108ab3:	68 98 c1 10 80       	push   $0x8010c198
80108ab8:	e8 37 79 ff ff       	call   801003f4 <cprintf>
80108abd:	83 c4 10             	add    $0x10,%esp
}
80108ac0:	90                   	nop
80108ac1:	8d 65 f4             	lea    -0xc(%ebp),%esp
80108ac4:	5b                   	pop    %ebx
80108ac5:	5e                   	pop    %esi
80108ac6:	5f                   	pop    %edi
80108ac7:	5d                   	pop    %ebp
80108ac8:	c3                   	ret    

80108ac9 <i8254_init_send>:

void i8254_init_send(){
80108ac9:	55                   	push   %ebp
80108aca:	89 e5                	mov    %esp,%ebp
80108acc:	83 ec 48             	sub    $0x48,%esp
  uint *txdctl = (uint *)(base_addr + 0x3828);
80108acf:	a1 7c 6e 19 80       	mov    0x80196e7c,%eax
80108ad4:	05 28 38 00 00       	add    $0x3828,%eax
80108ad9:	89 45 ec             	mov    %eax,-0x14(%ebp)
  *txdctl = (I8254_TXDCTL_WTHRESH | I8254_TXDCTL_GRAN_DESC);
80108adc:	8b 45 ec             	mov    -0x14(%ebp),%eax
80108adf:	c7 00 00 00 01 01    	movl   $0x1010000,(%eax)

  uint tx_desc_addr = (uint)kalloc();
80108ae5:	e8 b6 9c ff ff       	call   801027a0 <kalloc>
80108aea:	89 45 e8             	mov    %eax,-0x18(%ebp)
  uint *tdbal = (uint *)(base_addr + 0x3800);
80108aed:	a1 7c 6e 19 80       	mov    0x80196e7c,%eax
80108af2:	05 00 38 00 00       	add    $0x3800,%eax
80108af7:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  uint *tdbah = (uint *)(base_addr + 0x3804);
80108afa:	a1 7c 6e 19 80       	mov    0x80196e7c,%eax
80108aff:	05 04 38 00 00       	add    $0x3804,%eax
80108b04:	89 45 e0             	mov    %eax,-0x20(%ebp)
  uint *tdlen = (uint *)(base_addr + 0x3808);
80108b07:	a1 7c 6e 19 80       	mov    0x80196e7c,%eax
80108b0c:	05 08 38 00 00       	add    $0x3808,%eax
80108b11:	89 45 dc             	mov    %eax,-0x24(%ebp)

  *tdbal = V2P(tx_desc_addr);
80108b14:	8b 45 e8             	mov    -0x18(%ebp),%eax
80108b17:	8d 90 00 00 00 80    	lea    -0x80000000(%eax),%edx
80108b1d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80108b20:	89 10                	mov    %edx,(%eax)
  *tdbah = 0;
80108b22:	8b 45 e0             	mov    -0x20(%ebp),%eax
80108b25:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  *tdlen = sizeof(struct i8254_send_desc)*I8254_SEND_DESC_NUM;
80108b2b:	8b 45 dc             	mov    -0x24(%ebp),%eax
80108b2e:	c7 00 00 10 00 00    	movl   $0x1000,(%eax)
  uint *tdh = (uint *)(base_addr + 0x3810);
80108b34:	a1 7c 6e 19 80       	mov    0x80196e7c,%eax
80108b39:	05 10 38 00 00       	add    $0x3810,%eax
80108b3e:	89 45 d8             	mov    %eax,-0x28(%ebp)
  uint *tdt = (uint *)(base_addr + 0x3818);
80108b41:	a1 7c 6e 19 80       	mov    0x80196e7c,%eax
80108b46:	05 18 38 00 00       	add    $0x3818,%eax
80108b4b:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  
  *tdh = 0;
80108b4e:	8b 45 d8             	mov    -0x28(%ebp),%eax
80108b51:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  *tdt = 0;
80108b57:	8b 45 d4             	mov    -0x2c(%ebp),%eax
80108b5a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

  struct i8254_send_desc *send_desc = (struct i8254_send_desc *)tx_desc_addr;
80108b60:	8b 45 e8             	mov    -0x18(%ebp),%eax
80108b63:	89 45 d0             	mov    %eax,-0x30(%ebp)
  for(int i=0;i<I8254_SEND_DESC_NUM;i++){
80108b66:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80108b6d:	e9 82 00 00 00       	jmp    80108bf4 <i8254_init_send+0x12b>
    send_desc[i].padding = 0;
80108b72:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108b75:	c1 e0 04             	shl    $0x4,%eax
80108b78:	89 c2                	mov    %eax,%edx
80108b7a:	8b 45 d0             	mov    -0x30(%ebp),%eax
80108b7d:	01 d0                	add    %edx,%eax
80108b7f:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
    send_desc[i].len = 0;
80108b86:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108b89:	c1 e0 04             	shl    $0x4,%eax
80108b8c:	89 c2                	mov    %eax,%edx
80108b8e:	8b 45 d0             	mov    -0x30(%ebp),%eax
80108b91:	01 d0                	add    %edx,%eax
80108b93:	66 c7 40 08 00 00    	movw   $0x0,0x8(%eax)
    send_desc[i].cso = 0;
80108b99:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108b9c:	c1 e0 04             	shl    $0x4,%eax
80108b9f:	89 c2                	mov    %eax,%edx
80108ba1:	8b 45 d0             	mov    -0x30(%ebp),%eax
80108ba4:	01 d0                	add    %edx,%eax
80108ba6:	c6 40 0a 00          	movb   $0x0,0xa(%eax)
    send_desc[i].cmd = 0;
80108baa:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108bad:	c1 e0 04             	shl    $0x4,%eax
80108bb0:	89 c2                	mov    %eax,%edx
80108bb2:	8b 45 d0             	mov    -0x30(%ebp),%eax
80108bb5:	01 d0                	add    %edx,%eax
80108bb7:	c6 40 0b 00          	movb   $0x0,0xb(%eax)
    send_desc[i].sta = 0;
80108bbb:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108bbe:	c1 e0 04             	shl    $0x4,%eax
80108bc1:	89 c2                	mov    %eax,%edx
80108bc3:	8b 45 d0             	mov    -0x30(%ebp),%eax
80108bc6:	01 d0                	add    %edx,%eax
80108bc8:	c6 40 0c 00          	movb   $0x0,0xc(%eax)
    send_desc[i].css = 0;
80108bcc:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108bcf:	c1 e0 04             	shl    $0x4,%eax
80108bd2:	89 c2                	mov    %eax,%edx
80108bd4:	8b 45 d0             	mov    -0x30(%ebp),%eax
80108bd7:	01 d0                	add    %edx,%eax
80108bd9:	c6 40 0d 00          	movb   $0x0,0xd(%eax)
    send_desc[i].special = 0;
80108bdd:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108be0:	c1 e0 04             	shl    $0x4,%eax
80108be3:	89 c2                	mov    %eax,%edx
80108be5:	8b 45 d0             	mov    -0x30(%ebp),%eax
80108be8:	01 d0                	add    %edx,%eax
80108bea:	66 c7 40 0e 00 00    	movw   $0x0,0xe(%eax)
  for(int i=0;i<I8254_SEND_DESC_NUM;i++){
80108bf0:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80108bf4:	81 7d f4 ff 00 00 00 	cmpl   $0xff,-0xc(%ebp)
80108bfb:	0f 8e 71 ff ff ff    	jle    80108b72 <i8254_init_send+0xa9>
  }

  for(int i=0;i<(I8254_SEND_DESC_NUM)/2;i++){
80108c01:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
80108c08:	eb 57                	jmp    80108c61 <i8254_init_send+0x198>
    uint buf_addr = (uint)kalloc();
80108c0a:	e8 91 9b ff ff       	call   801027a0 <kalloc>
80108c0f:	89 45 cc             	mov    %eax,-0x34(%ebp)
    if(buf_addr == 0){
80108c12:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
80108c16:	75 12                	jne    80108c2a <i8254_init_send+0x161>
      cprintf("failed to allocate buffer area\n");
80108c18:	83 ec 0c             	sub    $0xc,%esp
80108c1b:	68 78 c1 10 80       	push   $0x8010c178
80108c20:	e8 cf 77 ff ff       	call   801003f4 <cprintf>
80108c25:	83 c4 10             	add    $0x10,%esp
      break;
80108c28:	eb 3d                	jmp    80108c67 <i8254_init_send+0x19e>
    }
    send_desc[i].buf_addr = V2P(buf_addr);
80108c2a:	8b 45 f0             	mov    -0x10(%ebp),%eax
80108c2d:	c1 e0 04             	shl    $0x4,%eax
80108c30:	89 c2                	mov    %eax,%edx
80108c32:	8b 45 d0             	mov    -0x30(%ebp),%eax
80108c35:	01 d0                	add    %edx,%eax
80108c37:	8b 55 cc             	mov    -0x34(%ebp),%edx
80108c3a:	81 c2 00 00 00 80    	add    $0x80000000,%edx
80108c40:	89 10                	mov    %edx,(%eax)
    send_desc[i+1].buf_addr = V2P(buf_addr + 0x800);
80108c42:	8b 45 f0             	mov    -0x10(%ebp),%eax
80108c45:	83 c0 01             	add    $0x1,%eax
80108c48:	c1 e0 04             	shl    $0x4,%eax
80108c4b:	89 c2                	mov    %eax,%edx
80108c4d:	8b 45 d0             	mov    -0x30(%ebp),%eax
80108c50:	01 d0                	add    %edx,%eax
80108c52:	8b 55 cc             	mov    -0x34(%ebp),%edx
80108c55:	81 ea 00 f8 ff 7f    	sub    $0x7ffff800,%edx
80108c5b:	89 10                	mov    %edx,(%eax)
  for(int i=0;i<(I8254_SEND_DESC_NUM)/2;i++){
80108c5d:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
80108c61:	83 7d f0 7f          	cmpl   $0x7f,-0x10(%ebp)
80108c65:	7e a3                	jle    80108c0a <i8254_init_send+0x141>
  }

  uint *tctl = (uint *)(base_addr + 0x400);
80108c67:	a1 7c 6e 19 80       	mov    0x80196e7c,%eax
80108c6c:	05 00 04 00 00       	add    $0x400,%eax
80108c71:	89 45 c8             	mov    %eax,-0x38(%ebp)
  *tctl = (I8254_TCTL_EN | I8254_TCTL_PSP | I8254_TCTL_COLD | I8254_TCTL_CT);
80108c74:	8b 45 c8             	mov    -0x38(%ebp),%eax
80108c77:	c7 00 fa 00 04 00    	movl   $0x400fa,(%eax)

  uint *tipg = (uint *)(base_addr + 0x410);
80108c7d:	a1 7c 6e 19 80       	mov    0x80196e7c,%eax
80108c82:	05 10 04 00 00       	add    $0x410,%eax
80108c87:	89 45 c4             	mov    %eax,-0x3c(%ebp)
  *tipg = (10 | (10<<10) | (10<<20));
80108c8a:	8b 45 c4             	mov    -0x3c(%ebp),%eax
80108c8d:	c7 00 0a 28 a0 00    	movl   $0xa0280a,(%eax)
  cprintf("E1000 Transmit Initialize Done\n");
80108c93:	83 ec 0c             	sub    $0xc,%esp
80108c96:	68 b8 c1 10 80       	push   $0x8010c1b8
80108c9b:	e8 54 77 ff ff       	call   801003f4 <cprintf>
80108ca0:	83 c4 10             	add    $0x10,%esp

}
80108ca3:	90                   	nop
80108ca4:	c9                   	leave  
80108ca5:	c3                   	ret    

80108ca6 <i8254_read_eeprom>:
uint i8254_read_eeprom(uint addr){
80108ca6:	55                   	push   %ebp
80108ca7:	89 e5                	mov    %esp,%ebp
80108ca9:	83 ec 18             	sub    $0x18,%esp
  uint *eerd = (uint *)(base_addr + 0x14);
80108cac:	a1 7c 6e 19 80       	mov    0x80196e7c,%eax
80108cb1:	83 c0 14             	add    $0x14,%eax
80108cb4:	89 45 f4             	mov    %eax,-0xc(%ebp)
  *eerd = (((addr & 0xFF) << 8) | 1);
80108cb7:	8b 45 08             	mov    0x8(%ebp),%eax
80108cba:	c1 e0 08             	shl    $0x8,%eax
80108cbd:	0f b7 c0             	movzwl %ax,%eax
80108cc0:	83 c8 01             	or     $0x1,%eax
80108cc3:	89 c2                	mov    %eax,%edx
80108cc5:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108cc8:	89 10                	mov    %edx,(%eax)
  while(1){
    cprintf("");
80108cca:	83 ec 0c             	sub    $0xc,%esp
80108ccd:	68 d8 c1 10 80       	push   $0x8010c1d8
80108cd2:	e8 1d 77 ff ff       	call   801003f4 <cprintf>
80108cd7:	83 c4 10             	add    $0x10,%esp
    volatile uint data = *eerd;
80108cda:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108cdd:	8b 00                	mov    (%eax),%eax
80108cdf:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if((data & (1<<4)) != 0){
80108ce2:	8b 45 f0             	mov    -0x10(%ebp),%eax
80108ce5:	83 e0 10             	and    $0x10,%eax
80108ce8:	85 c0                	test   %eax,%eax
80108cea:	75 02                	jne    80108cee <i8254_read_eeprom+0x48>
  while(1){
80108cec:	eb dc                	jmp    80108cca <i8254_read_eeprom+0x24>
      break;
80108cee:	90                   	nop
    }
  }

  return (*eerd >> 16) & 0xFFFF;
80108cef:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108cf2:	8b 00                	mov    (%eax),%eax
80108cf4:	c1 e8 10             	shr    $0x10,%eax
}
80108cf7:	c9                   	leave  
80108cf8:	c3                   	ret    

80108cf9 <i8254_recv>:
void i8254_recv(){
80108cf9:	55                   	push   %ebp
80108cfa:	89 e5                	mov    %esp,%ebp
80108cfc:	83 ec 28             	sub    $0x28,%esp
  uint *rdh = (uint *)(base_addr + 0x2810);
80108cff:	a1 7c 6e 19 80       	mov    0x80196e7c,%eax
80108d04:	05 10 28 00 00       	add    $0x2810,%eax
80108d09:	89 45 f4             	mov    %eax,-0xc(%ebp)
  uint *rdt = (uint *)(base_addr + 0x2818);
80108d0c:	a1 7c 6e 19 80       	mov    0x80196e7c,%eax
80108d11:	05 18 28 00 00       	add    $0x2818,%eax
80108d16:	89 45 f0             	mov    %eax,-0x10(%ebp)
//  uint *torl = (uint *)(base_addr + 0x40C0);
//  uint *tpr = (uint *)(base_addr + 0x40D0);
//  uint *icr = (uint *)(base_addr + 0xC0);
  uint *rdbal = (uint *)(base_addr + 0x2800);
80108d19:	a1 7c 6e 19 80       	mov    0x80196e7c,%eax
80108d1e:	05 00 28 00 00       	add    $0x2800,%eax
80108d23:	89 45 ec             	mov    %eax,-0x14(%ebp)
  struct i8254_recv_desc *recv_desc = (struct i8254_recv_desc *)(P2V(*rdbal));
80108d26:	8b 45 ec             	mov    -0x14(%ebp),%eax
80108d29:	8b 00                	mov    (%eax),%eax
80108d2b:	05 00 00 00 80       	add    $0x80000000,%eax
80108d30:	89 45 e8             	mov    %eax,-0x18(%ebp)
  while(1){
    int rx_available = (I8254_RECV_DESC_NUM - *rdt + *rdh)%I8254_RECV_DESC_NUM;
80108d33:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108d36:	8b 10                	mov    (%eax),%edx
80108d38:	8b 45 f0             	mov    -0x10(%ebp),%eax
80108d3b:	8b 08                	mov    (%eax),%ecx
80108d3d:	89 d0                	mov    %edx,%eax
80108d3f:	29 c8                	sub    %ecx,%eax
80108d41:	25 ff 00 00 00       	and    $0xff,%eax
80108d46:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(rx_available > 0){
80108d49:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
80108d4d:	7e 37                	jle    80108d86 <i8254_recv+0x8d>
      uint buffer_addr = P2V_WO(recv_desc[*rdt].buf_addr);
80108d4f:	8b 45 f0             	mov    -0x10(%ebp),%eax
80108d52:	8b 00                	mov    (%eax),%eax
80108d54:	c1 e0 04             	shl    $0x4,%eax
80108d57:	89 c2                	mov    %eax,%edx
80108d59:	8b 45 e8             	mov    -0x18(%ebp),%eax
80108d5c:	01 d0                	add    %edx,%eax
80108d5e:	8b 00                	mov    (%eax),%eax
80108d60:	05 00 00 00 80       	add    $0x80000000,%eax
80108d65:	89 45 e0             	mov    %eax,-0x20(%ebp)
      *rdt = (*rdt + 1)%I8254_RECV_DESC_NUM;
80108d68:	8b 45 f0             	mov    -0x10(%ebp),%eax
80108d6b:	8b 00                	mov    (%eax),%eax
80108d6d:	83 c0 01             	add    $0x1,%eax
80108d70:	0f b6 d0             	movzbl %al,%edx
80108d73:	8b 45 f0             	mov    -0x10(%ebp),%eax
80108d76:	89 10                	mov    %edx,(%eax)
      eth_proc(buffer_addr);
80108d78:	83 ec 0c             	sub    $0xc,%esp
80108d7b:	ff 75 e0             	push   -0x20(%ebp)
80108d7e:	e8 15 09 00 00       	call   80109698 <eth_proc>
80108d83:	83 c4 10             	add    $0x10,%esp
    }
    if(*rdt == *rdh) {
80108d86:	8b 45 f0             	mov    -0x10(%ebp),%eax
80108d89:	8b 10                	mov    (%eax),%edx
80108d8b:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108d8e:	8b 00                	mov    (%eax),%eax
80108d90:	39 c2                	cmp    %eax,%edx
80108d92:	75 9f                	jne    80108d33 <i8254_recv+0x3a>
      (*rdt)--;
80108d94:	8b 45 f0             	mov    -0x10(%ebp),%eax
80108d97:	8b 00                	mov    (%eax),%eax
80108d99:	8d 50 ff             	lea    -0x1(%eax),%edx
80108d9c:	8b 45 f0             	mov    -0x10(%ebp),%eax
80108d9f:	89 10                	mov    %edx,(%eax)
  while(1){
80108da1:	eb 90                	jmp    80108d33 <i8254_recv+0x3a>

80108da3 <i8254_send>:
    }
  }
}

int i8254_send(const uint pkt_addr,uint len){
80108da3:	55                   	push   %ebp
80108da4:	89 e5                	mov    %esp,%ebp
80108da6:	83 ec 28             	sub    $0x28,%esp
  uint *tdh = (uint *)(base_addr + 0x3810);
80108da9:	a1 7c 6e 19 80       	mov    0x80196e7c,%eax
80108dae:	05 10 38 00 00       	add    $0x3810,%eax
80108db3:	89 45 f4             	mov    %eax,-0xc(%ebp)
  uint *tdt = (uint *)(base_addr + 0x3818);
80108db6:	a1 7c 6e 19 80       	mov    0x80196e7c,%eax
80108dbb:	05 18 38 00 00       	add    $0x3818,%eax
80108dc0:	89 45 f0             	mov    %eax,-0x10(%ebp)
  uint *tdbal = (uint *)(base_addr + 0x3800);
80108dc3:	a1 7c 6e 19 80       	mov    0x80196e7c,%eax
80108dc8:	05 00 38 00 00       	add    $0x3800,%eax
80108dcd:	89 45 ec             	mov    %eax,-0x14(%ebp)
  struct i8254_send_desc *txdesc = (struct i8254_send_desc *)P2V_WO(*tdbal);
80108dd0:	8b 45 ec             	mov    -0x14(%ebp),%eax
80108dd3:	8b 00                	mov    (%eax),%eax
80108dd5:	05 00 00 00 80       	add    $0x80000000,%eax
80108dda:	89 45 e8             	mov    %eax,-0x18(%ebp)
  int tx_available = I8254_SEND_DESC_NUM - ((I8254_SEND_DESC_NUM - *tdh + *tdt) % I8254_SEND_DESC_NUM);
80108ddd:	8b 45 f0             	mov    -0x10(%ebp),%eax
80108de0:	8b 10                	mov    (%eax),%edx
80108de2:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108de5:	8b 08                	mov    (%eax),%ecx
80108de7:	89 d0                	mov    %edx,%eax
80108de9:	29 c8                	sub    %ecx,%eax
80108deb:	0f b6 d0             	movzbl %al,%edx
80108dee:	b8 00 01 00 00       	mov    $0x100,%eax
80108df3:	29 d0                	sub    %edx,%eax
80108df5:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  uint index = *tdt%I8254_SEND_DESC_NUM;
80108df8:	8b 45 f0             	mov    -0x10(%ebp),%eax
80108dfb:	8b 00                	mov    (%eax),%eax
80108dfd:	25 ff 00 00 00       	and    $0xff,%eax
80108e02:	89 45 e0             	mov    %eax,-0x20(%ebp)
  if(tx_available > 0) {
80108e05:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
80108e09:	0f 8e a8 00 00 00    	jle    80108eb7 <i8254_send+0x114>
    memmove(P2V_WO((void *)txdesc[index].buf_addr),(void *)pkt_addr,len);
80108e0f:	8b 45 08             	mov    0x8(%ebp),%eax
80108e12:	8b 55 e0             	mov    -0x20(%ebp),%edx
80108e15:	89 d1                	mov    %edx,%ecx
80108e17:	c1 e1 04             	shl    $0x4,%ecx
80108e1a:	8b 55 e8             	mov    -0x18(%ebp),%edx
80108e1d:	01 ca                	add    %ecx,%edx
80108e1f:	8b 12                	mov    (%edx),%edx
80108e21:	81 c2 00 00 00 80    	add    $0x80000000,%edx
80108e27:	83 ec 04             	sub    $0x4,%esp
80108e2a:	ff 75 0c             	push   0xc(%ebp)
80108e2d:	50                   	push   %eax
80108e2e:	52                   	push   %edx
80108e2f:	e8 bf be ff ff       	call   80104cf3 <memmove>
80108e34:	83 c4 10             	add    $0x10,%esp
    txdesc[index].len = len;
80108e37:	8b 45 e0             	mov    -0x20(%ebp),%eax
80108e3a:	c1 e0 04             	shl    $0x4,%eax
80108e3d:	89 c2                	mov    %eax,%edx
80108e3f:	8b 45 e8             	mov    -0x18(%ebp),%eax
80108e42:	01 d0                	add    %edx,%eax
80108e44:	8b 55 0c             	mov    0xc(%ebp),%edx
80108e47:	66 89 50 08          	mov    %dx,0x8(%eax)
    txdesc[index].sta = 0;
80108e4b:	8b 45 e0             	mov    -0x20(%ebp),%eax
80108e4e:	c1 e0 04             	shl    $0x4,%eax
80108e51:	89 c2                	mov    %eax,%edx
80108e53:	8b 45 e8             	mov    -0x18(%ebp),%eax
80108e56:	01 d0                	add    %edx,%eax
80108e58:	c6 40 0c 00          	movb   $0x0,0xc(%eax)
    txdesc[index].css = 0;
80108e5c:	8b 45 e0             	mov    -0x20(%ebp),%eax
80108e5f:	c1 e0 04             	shl    $0x4,%eax
80108e62:	89 c2                	mov    %eax,%edx
80108e64:	8b 45 e8             	mov    -0x18(%ebp),%eax
80108e67:	01 d0                	add    %edx,%eax
80108e69:	c6 40 0d 00          	movb   $0x0,0xd(%eax)
    txdesc[index].cmd = 0xb;
80108e6d:	8b 45 e0             	mov    -0x20(%ebp),%eax
80108e70:	c1 e0 04             	shl    $0x4,%eax
80108e73:	89 c2                	mov    %eax,%edx
80108e75:	8b 45 e8             	mov    -0x18(%ebp),%eax
80108e78:	01 d0                	add    %edx,%eax
80108e7a:	c6 40 0b 0b          	movb   $0xb,0xb(%eax)
    txdesc[index].special = 0;
80108e7e:	8b 45 e0             	mov    -0x20(%ebp),%eax
80108e81:	c1 e0 04             	shl    $0x4,%eax
80108e84:	89 c2                	mov    %eax,%edx
80108e86:	8b 45 e8             	mov    -0x18(%ebp),%eax
80108e89:	01 d0                	add    %edx,%eax
80108e8b:	66 c7 40 0e 00 00    	movw   $0x0,0xe(%eax)
    txdesc[index].cso = 0;
80108e91:	8b 45 e0             	mov    -0x20(%ebp),%eax
80108e94:	c1 e0 04             	shl    $0x4,%eax
80108e97:	89 c2                	mov    %eax,%edx
80108e99:	8b 45 e8             	mov    -0x18(%ebp),%eax
80108e9c:	01 d0                	add    %edx,%eax
80108e9e:	c6 40 0a 00          	movb   $0x0,0xa(%eax)
    *tdt = (*tdt + 1)%I8254_SEND_DESC_NUM;
80108ea2:	8b 45 f0             	mov    -0x10(%ebp),%eax
80108ea5:	8b 00                	mov    (%eax),%eax
80108ea7:	83 c0 01             	add    $0x1,%eax
80108eaa:	0f b6 d0             	movzbl %al,%edx
80108ead:	8b 45 f0             	mov    -0x10(%ebp),%eax
80108eb0:	89 10                	mov    %edx,(%eax)
    return len;
80108eb2:	8b 45 0c             	mov    0xc(%ebp),%eax
80108eb5:	eb 05                	jmp    80108ebc <i8254_send+0x119>
  }else{
    return -1;
80108eb7:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  }
  return 0;
}
80108ebc:	c9                   	leave  
80108ebd:	c3                   	ret    

80108ebe <i8254_intr>:

void i8254_intr(){
80108ebe:	55                   	push   %ebp
80108ebf:	89 e5                	mov    %esp,%ebp
  *intr_addr = 0xEEEEEE;
80108ec1:	a1 88 6e 19 80       	mov    0x80196e88,%eax
80108ec6:	c7 00 ee ee ee 00    	movl   $0xeeeeee,(%eax)
}
80108ecc:	90                   	nop
80108ecd:	5d                   	pop    %ebp
80108ece:	c3                   	ret    

80108ecf <arp_proc>:
extern uchar mac_addr[6];
extern uchar my_ip[4];

struct arp_entry arp_table[ARP_TABLE_MAX] = {0};

int arp_proc(uint buffer_addr){
80108ecf:	55                   	push   %ebp
80108ed0:	89 e5                	mov    %esp,%ebp
80108ed2:	83 ec 18             	sub    $0x18,%esp
  struct arp_pkt *arp_p = (struct arp_pkt *)(buffer_addr);
80108ed5:	8b 45 08             	mov    0x8(%ebp),%eax
80108ed8:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(arp_p->hrd_type != ARP_HARDWARE_TYPE) return -1;
80108edb:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108ede:	0f b7 00             	movzwl (%eax),%eax
80108ee1:	66 3d 00 01          	cmp    $0x100,%ax
80108ee5:	74 0a                	je     80108ef1 <arp_proc+0x22>
80108ee7:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80108eec:	e9 4f 01 00 00       	jmp    80109040 <arp_proc+0x171>
  if(arp_p->pro_type != ARP_PROTOCOL_TYPE) return -1;
80108ef1:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108ef4:	0f b7 40 02          	movzwl 0x2(%eax),%eax
80108ef8:	66 83 f8 08          	cmp    $0x8,%ax
80108efc:	74 0a                	je     80108f08 <arp_proc+0x39>
80108efe:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80108f03:	e9 38 01 00 00       	jmp    80109040 <arp_proc+0x171>
  if(arp_p->hrd_len != 6) return -1;
80108f08:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108f0b:	0f b6 40 04          	movzbl 0x4(%eax),%eax
80108f0f:	3c 06                	cmp    $0x6,%al
80108f11:	74 0a                	je     80108f1d <arp_proc+0x4e>
80108f13:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80108f18:	e9 23 01 00 00       	jmp    80109040 <arp_proc+0x171>
  if(arp_p->pro_len != 4) return -1;
80108f1d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108f20:	0f b6 40 05          	movzbl 0x5(%eax),%eax
80108f24:	3c 04                	cmp    $0x4,%al
80108f26:	74 0a                	je     80108f32 <arp_proc+0x63>
80108f28:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80108f2d:	e9 0e 01 00 00       	jmp    80109040 <arp_proc+0x171>
  if(memcmp(my_ip,arp_p->dst_ip,4) != 0 && memcmp(my_ip,arp_p->src_ip,4) != 0) return -1;
80108f32:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108f35:	83 c0 18             	add    $0x18,%eax
80108f38:	83 ec 04             	sub    $0x4,%esp
80108f3b:	6a 04                	push   $0x4
80108f3d:	50                   	push   %eax
80108f3e:	68 04 f5 10 80       	push   $0x8010f504
80108f43:	e8 53 bd ff ff       	call   80104c9b <memcmp>
80108f48:	83 c4 10             	add    $0x10,%esp
80108f4b:	85 c0                	test   %eax,%eax
80108f4d:	74 27                	je     80108f76 <arp_proc+0xa7>
80108f4f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108f52:	83 c0 0e             	add    $0xe,%eax
80108f55:	83 ec 04             	sub    $0x4,%esp
80108f58:	6a 04                	push   $0x4
80108f5a:	50                   	push   %eax
80108f5b:	68 04 f5 10 80       	push   $0x8010f504
80108f60:	e8 36 bd ff ff       	call   80104c9b <memcmp>
80108f65:	83 c4 10             	add    $0x10,%esp
80108f68:	85 c0                	test   %eax,%eax
80108f6a:	74 0a                	je     80108f76 <arp_proc+0xa7>
80108f6c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80108f71:	e9 ca 00 00 00       	jmp    80109040 <arp_proc+0x171>
  if(arp_p->op == ARP_OPS_REQUEST && memcmp(my_ip,arp_p->dst_ip,4) == 0){
80108f76:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108f79:	0f b7 40 06          	movzwl 0x6(%eax),%eax
80108f7d:	66 3d 00 01          	cmp    $0x100,%ax
80108f81:	75 69                	jne    80108fec <arp_proc+0x11d>
80108f83:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108f86:	83 c0 18             	add    $0x18,%eax
80108f89:	83 ec 04             	sub    $0x4,%esp
80108f8c:	6a 04                	push   $0x4
80108f8e:	50                   	push   %eax
80108f8f:	68 04 f5 10 80       	push   $0x8010f504
80108f94:	e8 02 bd ff ff       	call   80104c9b <memcmp>
80108f99:	83 c4 10             	add    $0x10,%esp
80108f9c:	85 c0                	test   %eax,%eax
80108f9e:	75 4c                	jne    80108fec <arp_proc+0x11d>
    uint send = (uint)kalloc();
80108fa0:	e8 fb 97 ff ff       	call   801027a0 <kalloc>
80108fa5:	89 45 f0             	mov    %eax,-0x10(%ebp)
    uint send_size=0;
80108fa8:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
    arp_reply_pkt_create(arp_p,send,&send_size);
80108faf:	83 ec 04             	sub    $0x4,%esp
80108fb2:	8d 45 ec             	lea    -0x14(%ebp),%eax
80108fb5:	50                   	push   %eax
80108fb6:	ff 75 f0             	push   -0x10(%ebp)
80108fb9:	ff 75 f4             	push   -0xc(%ebp)
80108fbc:	e8 1f 04 00 00       	call   801093e0 <arp_reply_pkt_create>
80108fc1:	83 c4 10             	add    $0x10,%esp
    i8254_send(send,send_size);
80108fc4:	8b 45 ec             	mov    -0x14(%ebp),%eax
80108fc7:	83 ec 08             	sub    $0x8,%esp
80108fca:	50                   	push   %eax
80108fcb:	ff 75 f0             	push   -0x10(%ebp)
80108fce:	e8 d0 fd ff ff       	call   80108da3 <i8254_send>
80108fd3:	83 c4 10             	add    $0x10,%esp
    kfree((char *)send);
80108fd6:	8b 45 f0             	mov    -0x10(%ebp),%eax
80108fd9:	83 ec 0c             	sub    $0xc,%esp
80108fdc:	50                   	push   %eax
80108fdd:	e8 24 97 ff ff       	call   80102706 <kfree>
80108fe2:	83 c4 10             	add    $0x10,%esp
    return ARP_CREATED_REPLY;
80108fe5:	b8 02 00 00 00       	mov    $0x2,%eax
80108fea:	eb 54                	jmp    80109040 <arp_proc+0x171>
  }else if(arp_p->op == ARP_OPS_REPLY && memcmp(my_ip,arp_p->dst_ip,4) == 0){
80108fec:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108fef:	0f b7 40 06          	movzwl 0x6(%eax),%eax
80108ff3:	66 3d 00 02          	cmp    $0x200,%ax
80108ff7:	75 42                	jne    8010903b <arp_proc+0x16c>
80108ff9:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108ffc:	83 c0 18             	add    $0x18,%eax
80108fff:	83 ec 04             	sub    $0x4,%esp
80109002:	6a 04                	push   $0x4
80109004:	50                   	push   %eax
80109005:	68 04 f5 10 80       	push   $0x8010f504
8010900a:	e8 8c bc ff ff       	call   80104c9b <memcmp>
8010900f:	83 c4 10             	add    $0x10,%esp
80109012:	85 c0                	test   %eax,%eax
80109014:	75 25                	jne    8010903b <arp_proc+0x16c>
    cprintf("ARP TABLE UPDATED\n");
80109016:	83 ec 0c             	sub    $0xc,%esp
80109019:	68 dc c1 10 80       	push   $0x8010c1dc
8010901e:	e8 d1 73 ff ff       	call   801003f4 <cprintf>
80109023:	83 c4 10             	add    $0x10,%esp
    arp_table_update(arp_p);
80109026:	83 ec 0c             	sub    $0xc,%esp
80109029:	ff 75 f4             	push   -0xc(%ebp)
8010902c:	e8 af 01 00 00       	call   801091e0 <arp_table_update>
80109031:	83 c4 10             	add    $0x10,%esp
    return ARP_UPDATED_TABLE;
80109034:	b8 01 00 00 00       	mov    $0x1,%eax
80109039:	eb 05                	jmp    80109040 <arp_proc+0x171>
  }else{
    return -1;
8010903b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  }
}
80109040:	c9                   	leave  
80109041:	c3                   	ret    

80109042 <arp_scan>:

void arp_scan(){
80109042:	55                   	push   %ebp
80109043:	89 e5                	mov    %esp,%ebp
80109045:	83 ec 18             	sub    $0x18,%esp
  uint send_size;
  for(int i=0;i<256;i++){
80109048:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
8010904f:	eb 6f                	jmp    801090c0 <arp_scan+0x7e>
    uint send = (uint)kalloc();
80109051:	e8 4a 97 ff ff       	call   801027a0 <kalloc>
80109056:	89 45 ec             	mov    %eax,-0x14(%ebp)
    arp_broadcast(send,&send_size,i);
80109059:	83 ec 04             	sub    $0x4,%esp
8010905c:	ff 75 f4             	push   -0xc(%ebp)
8010905f:	8d 45 e8             	lea    -0x18(%ebp),%eax
80109062:	50                   	push   %eax
80109063:	ff 75 ec             	push   -0x14(%ebp)
80109066:	e8 62 00 00 00       	call   801090cd <arp_broadcast>
8010906b:	83 c4 10             	add    $0x10,%esp
    uint res = i8254_send(send,send_size);
8010906e:	8b 45 e8             	mov    -0x18(%ebp),%eax
80109071:	83 ec 08             	sub    $0x8,%esp
80109074:	50                   	push   %eax
80109075:	ff 75 ec             	push   -0x14(%ebp)
80109078:	e8 26 fd ff ff       	call   80108da3 <i8254_send>
8010907d:	83 c4 10             	add    $0x10,%esp
80109080:	89 45 f0             	mov    %eax,-0x10(%ebp)
    while(res == -1){
80109083:	eb 22                	jmp    801090a7 <arp_scan+0x65>
      microdelay(1);
80109085:	83 ec 0c             	sub    $0xc,%esp
80109088:	6a 01                	push   $0x1
8010908a:	e8 a8 9a ff ff       	call   80102b37 <microdelay>
8010908f:	83 c4 10             	add    $0x10,%esp
      res = i8254_send(send,send_size);
80109092:	8b 45 e8             	mov    -0x18(%ebp),%eax
80109095:	83 ec 08             	sub    $0x8,%esp
80109098:	50                   	push   %eax
80109099:	ff 75 ec             	push   -0x14(%ebp)
8010909c:	e8 02 fd ff ff       	call   80108da3 <i8254_send>
801090a1:	83 c4 10             	add    $0x10,%esp
801090a4:	89 45 f0             	mov    %eax,-0x10(%ebp)
    while(res == -1){
801090a7:	83 7d f0 ff          	cmpl   $0xffffffff,-0x10(%ebp)
801090ab:	74 d8                	je     80109085 <arp_scan+0x43>
    }
    kfree((char *)send);
801090ad:	8b 45 ec             	mov    -0x14(%ebp),%eax
801090b0:	83 ec 0c             	sub    $0xc,%esp
801090b3:	50                   	push   %eax
801090b4:	e8 4d 96 ff ff       	call   80102706 <kfree>
801090b9:	83 c4 10             	add    $0x10,%esp
  for(int i=0;i<256;i++){
801090bc:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
801090c0:	81 7d f4 ff 00 00 00 	cmpl   $0xff,-0xc(%ebp)
801090c7:	7e 88                	jle    80109051 <arp_scan+0xf>
  }
}
801090c9:	90                   	nop
801090ca:	90                   	nop
801090cb:	c9                   	leave  
801090cc:	c3                   	ret    

801090cd <arp_broadcast>:

void arp_broadcast(uint send,uint *send_size,uint ip){
801090cd:	55                   	push   %ebp
801090ce:	89 e5                	mov    %esp,%ebp
801090d0:	83 ec 28             	sub    $0x28,%esp
  uchar dst_ip[4] = {10,0,1,ip};
801090d3:	c6 45 ec 0a          	movb   $0xa,-0x14(%ebp)
801090d7:	c6 45 ed 00          	movb   $0x0,-0x13(%ebp)
801090db:	c6 45 ee 01          	movb   $0x1,-0x12(%ebp)
801090df:	8b 45 10             	mov    0x10(%ebp),%eax
801090e2:	88 45 ef             	mov    %al,-0x11(%ebp)
  uchar dst_mac_eth[6] = {0xff,0xff,0xff,0xff,0xff,0xff};
801090e5:	c7 45 e6 ff ff ff ff 	movl   $0xffffffff,-0x1a(%ebp)
801090ec:	66 c7 45 ea ff ff    	movw   $0xffff,-0x16(%ebp)
  uchar dst_mac_arp[6] = {0,0,0,0,0,0};
801090f2:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
801090f9:	66 c7 45 e4 00 00    	movw   $0x0,-0x1c(%ebp)
  
  *send_size = sizeof(struct eth_pkt) + sizeof(struct arp_pkt);
801090ff:	8b 45 0c             	mov    0xc(%ebp),%eax
80109102:	c7 00 2c 00 00 00    	movl   $0x2c,(%eax)

  struct eth_pkt *reply_eth = (struct eth_pkt *)send;
80109108:	8b 45 08             	mov    0x8(%ebp),%eax
8010910b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  struct arp_pkt *reply_arp = (struct arp_pkt *)(send + sizeof(struct eth_pkt));
8010910e:	8b 45 08             	mov    0x8(%ebp),%eax
80109111:	83 c0 0e             	add    $0xe,%eax
80109114:	89 45 f0             	mov    %eax,-0x10(%ebp)
  
  reply_eth->type[0] = 0x08;
80109117:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010911a:	c6 40 0c 08          	movb   $0x8,0xc(%eax)
  reply_eth->type[1] = 0x06;
8010911e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80109121:	c6 40 0d 06          	movb   $0x6,0xd(%eax)
  memmove(reply_eth->dst_mac,dst_mac_eth,6);
80109125:	8b 45 f4             	mov    -0xc(%ebp),%eax
80109128:	83 ec 04             	sub    $0x4,%esp
8010912b:	6a 06                	push   $0x6
8010912d:	8d 55 e6             	lea    -0x1a(%ebp),%edx
80109130:	52                   	push   %edx
80109131:	50                   	push   %eax
80109132:	e8 bc bb ff ff       	call   80104cf3 <memmove>
80109137:	83 c4 10             	add    $0x10,%esp
  memmove(reply_eth->src_mac,mac_addr,6);
8010913a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010913d:	83 c0 06             	add    $0x6,%eax
80109140:	83 ec 04             	sub    $0x4,%esp
80109143:	6a 06                	push   $0x6
80109145:	68 80 6e 19 80       	push   $0x80196e80
8010914a:	50                   	push   %eax
8010914b:	e8 a3 bb ff ff       	call   80104cf3 <memmove>
80109150:	83 c4 10             	add    $0x10,%esp

  reply_arp->hrd_type = ARP_HARDWARE_TYPE;
80109153:	8b 45 f0             	mov    -0x10(%ebp),%eax
80109156:	66 c7 00 00 01       	movw   $0x100,(%eax)
  reply_arp->pro_type = ARP_PROTOCOL_TYPE;
8010915b:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010915e:	66 c7 40 02 08 00    	movw   $0x8,0x2(%eax)
  reply_arp->hrd_len = 6;
80109164:	8b 45 f0             	mov    -0x10(%ebp),%eax
80109167:	c6 40 04 06          	movb   $0x6,0x4(%eax)
  reply_arp->pro_len = 4;
8010916b:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010916e:	c6 40 05 04          	movb   $0x4,0x5(%eax)
  reply_arp->op = ARP_OPS_REQUEST;
80109172:	8b 45 f0             	mov    -0x10(%ebp),%eax
80109175:	66 c7 40 06 00 01    	movw   $0x100,0x6(%eax)
  memmove(reply_arp->dst_mac,dst_mac_arp,6);
8010917b:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010917e:	8d 50 12             	lea    0x12(%eax),%edx
80109181:	83 ec 04             	sub    $0x4,%esp
80109184:	6a 06                	push   $0x6
80109186:	8d 45 e0             	lea    -0x20(%ebp),%eax
80109189:	50                   	push   %eax
8010918a:	52                   	push   %edx
8010918b:	e8 63 bb ff ff       	call   80104cf3 <memmove>
80109190:	83 c4 10             	add    $0x10,%esp
  memmove(reply_arp->dst_ip,dst_ip,4);
80109193:	8b 45 f0             	mov    -0x10(%ebp),%eax
80109196:	8d 50 18             	lea    0x18(%eax),%edx
80109199:	83 ec 04             	sub    $0x4,%esp
8010919c:	6a 04                	push   $0x4
8010919e:	8d 45 ec             	lea    -0x14(%ebp),%eax
801091a1:	50                   	push   %eax
801091a2:	52                   	push   %edx
801091a3:	e8 4b bb ff ff       	call   80104cf3 <memmove>
801091a8:	83 c4 10             	add    $0x10,%esp
  memmove(reply_arp->src_mac,mac_addr,6);
801091ab:	8b 45 f0             	mov    -0x10(%ebp),%eax
801091ae:	83 c0 08             	add    $0x8,%eax
801091b1:	83 ec 04             	sub    $0x4,%esp
801091b4:	6a 06                	push   $0x6
801091b6:	68 80 6e 19 80       	push   $0x80196e80
801091bb:	50                   	push   %eax
801091bc:	e8 32 bb ff ff       	call   80104cf3 <memmove>
801091c1:	83 c4 10             	add    $0x10,%esp
  memmove(reply_arp->src_ip,my_ip,4);
801091c4:	8b 45 f0             	mov    -0x10(%ebp),%eax
801091c7:	83 c0 0e             	add    $0xe,%eax
801091ca:	83 ec 04             	sub    $0x4,%esp
801091cd:	6a 04                	push   $0x4
801091cf:	68 04 f5 10 80       	push   $0x8010f504
801091d4:	50                   	push   %eax
801091d5:	e8 19 bb ff ff       	call   80104cf3 <memmove>
801091da:	83 c4 10             	add    $0x10,%esp
}
801091dd:	90                   	nop
801091de:	c9                   	leave  
801091df:	c3                   	ret    

801091e0 <arp_table_update>:

void arp_table_update(struct arp_pkt *recv_arp){
801091e0:	55                   	push   %ebp
801091e1:	89 e5                	mov    %esp,%ebp
801091e3:	83 ec 18             	sub    $0x18,%esp
  int index = arp_table_search(recv_arp->src_ip);
801091e6:	8b 45 08             	mov    0x8(%ebp),%eax
801091e9:	83 c0 0e             	add    $0xe,%eax
801091ec:	83 ec 0c             	sub    $0xc,%esp
801091ef:	50                   	push   %eax
801091f0:	e8 bc 00 00 00       	call   801092b1 <arp_table_search>
801091f5:	83 c4 10             	add    $0x10,%esp
801091f8:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(index > -1){
801091fb:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801091ff:	78 2d                	js     8010922e <arp_table_update+0x4e>
    memmove(arp_table[index].mac,recv_arp->src_mac,6);
80109201:	8b 45 08             	mov    0x8(%ebp),%eax
80109204:	8d 48 08             	lea    0x8(%eax),%ecx
80109207:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010920a:	89 d0                	mov    %edx,%eax
8010920c:	c1 e0 02             	shl    $0x2,%eax
8010920f:	01 d0                	add    %edx,%eax
80109211:	01 c0                	add    %eax,%eax
80109213:	01 d0                	add    %edx,%eax
80109215:	05 a0 6e 19 80       	add    $0x80196ea0,%eax
8010921a:	83 c0 04             	add    $0x4,%eax
8010921d:	83 ec 04             	sub    $0x4,%esp
80109220:	6a 06                	push   $0x6
80109222:	51                   	push   %ecx
80109223:	50                   	push   %eax
80109224:	e8 ca ba ff ff       	call   80104cf3 <memmove>
80109229:	83 c4 10             	add    $0x10,%esp
8010922c:	eb 70                	jmp    8010929e <arp_table_update+0xbe>
  }else{
    index += 1;
8010922e:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
    index = -index;
80109232:	f7 5d f4             	negl   -0xc(%ebp)
    memmove(arp_table[index].mac,recv_arp->src_mac,6);
80109235:	8b 45 08             	mov    0x8(%ebp),%eax
80109238:	8d 48 08             	lea    0x8(%eax),%ecx
8010923b:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010923e:	89 d0                	mov    %edx,%eax
80109240:	c1 e0 02             	shl    $0x2,%eax
80109243:	01 d0                	add    %edx,%eax
80109245:	01 c0                	add    %eax,%eax
80109247:	01 d0                	add    %edx,%eax
80109249:	05 a0 6e 19 80       	add    $0x80196ea0,%eax
8010924e:	83 c0 04             	add    $0x4,%eax
80109251:	83 ec 04             	sub    $0x4,%esp
80109254:	6a 06                	push   $0x6
80109256:	51                   	push   %ecx
80109257:	50                   	push   %eax
80109258:	e8 96 ba ff ff       	call   80104cf3 <memmove>
8010925d:	83 c4 10             	add    $0x10,%esp
    memmove(arp_table[index].ip,recv_arp->src_ip,4);
80109260:	8b 45 08             	mov    0x8(%ebp),%eax
80109263:	8d 48 0e             	lea    0xe(%eax),%ecx
80109266:	8b 55 f4             	mov    -0xc(%ebp),%edx
80109269:	89 d0                	mov    %edx,%eax
8010926b:	c1 e0 02             	shl    $0x2,%eax
8010926e:	01 d0                	add    %edx,%eax
80109270:	01 c0                	add    %eax,%eax
80109272:	01 d0                	add    %edx,%eax
80109274:	05 a0 6e 19 80       	add    $0x80196ea0,%eax
80109279:	83 ec 04             	sub    $0x4,%esp
8010927c:	6a 04                	push   $0x4
8010927e:	51                   	push   %ecx
8010927f:	50                   	push   %eax
80109280:	e8 6e ba ff ff       	call   80104cf3 <memmove>
80109285:	83 c4 10             	add    $0x10,%esp
    arp_table[index].use = 1;
80109288:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010928b:	89 d0                	mov    %edx,%eax
8010928d:	c1 e0 02             	shl    $0x2,%eax
80109290:	01 d0                	add    %edx,%eax
80109292:	01 c0                	add    %eax,%eax
80109294:	01 d0                	add    %edx,%eax
80109296:	05 aa 6e 19 80       	add    $0x80196eaa,%eax
8010929b:	c6 00 01             	movb   $0x1,(%eax)
  }
  print_arp_table(arp_table);
8010929e:	83 ec 0c             	sub    $0xc,%esp
801092a1:	68 a0 6e 19 80       	push   $0x80196ea0
801092a6:	e8 83 00 00 00       	call   8010932e <print_arp_table>
801092ab:	83 c4 10             	add    $0x10,%esp
}
801092ae:	90                   	nop
801092af:	c9                   	leave  
801092b0:	c3                   	ret    

801092b1 <arp_table_search>:

int arp_table_search(uchar *ip){
801092b1:	55                   	push   %ebp
801092b2:	89 e5                	mov    %esp,%ebp
801092b4:	83 ec 18             	sub    $0x18,%esp
  int empty=1;
801092b7:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
  for(int i=0;i<ARP_TABLE_MAX;i++){
801092be:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
801092c5:	eb 59                	jmp    80109320 <arp_table_search+0x6f>
    if(memcmp(arp_table[i].ip,ip,4) == 0){
801092c7:	8b 55 f0             	mov    -0x10(%ebp),%edx
801092ca:	89 d0                	mov    %edx,%eax
801092cc:	c1 e0 02             	shl    $0x2,%eax
801092cf:	01 d0                	add    %edx,%eax
801092d1:	01 c0                	add    %eax,%eax
801092d3:	01 d0                	add    %edx,%eax
801092d5:	05 a0 6e 19 80       	add    $0x80196ea0,%eax
801092da:	83 ec 04             	sub    $0x4,%esp
801092dd:	6a 04                	push   $0x4
801092df:	ff 75 08             	push   0x8(%ebp)
801092e2:	50                   	push   %eax
801092e3:	e8 b3 b9 ff ff       	call   80104c9b <memcmp>
801092e8:	83 c4 10             	add    $0x10,%esp
801092eb:	85 c0                	test   %eax,%eax
801092ed:	75 05                	jne    801092f4 <arp_table_search+0x43>
      return i;
801092ef:	8b 45 f0             	mov    -0x10(%ebp),%eax
801092f2:	eb 38                	jmp    8010932c <arp_table_search+0x7b>
    }
    if(arp_table[i].use == 0 && empty == 1){
801092f4:	8b 55 f0             	mov    -0x10(%ebp),%edx
801092f7:	89 d0                	mov    %edx,%eax
801092f9:	c1 e0 02             	shl    $0x2,%eax
801092fc:	01 d0                	add    %edx,%eax
801092fe:	01 c0                	add    %eax,%eax
80109300:	01 d0                	add    %edx,%eax
80109302:	05 aa 6e 19 80       	add    $0x80196eaa,%eax
80109307:	0f b6 00             	movzbl (%eax),%eax
8010930a:	84 c0                	test   %al,%al
8010930c:	75 0e                	jne    8010931c <arp_table_search+0x6b>
8010930e:	83 7d f4 01          	cmpl   $0x1,-0xc(%ebp)
80109312:	75 08                	jne    8010931c <arp_table_search+0x6b>
      empty = -i;
80109314:	8b 45 f0             	mov    -0x10(%ebp),%eax
80109317:	f7 d8                	neg    %eax
80109319:	89 45 f4             	mov    %eax,-0xc(%ebp)
  for(int i=0;i<ARP_TABLE_MAX;i++){
8010931c:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
80109320:	83 7d f0 3f          	cmpl   $0x3f,-0x10(%ebp)
80109324:	7e a1                	jle    801092c7 <arp_table_search+0x16>
    }
  }
  return empty-1;
80109326:	8b 45 f4             	mov    -0xc(%ebp),%eax
80109329:	83 e8 01             	sub    $0x1,%eax
}
8010932c:	c9                   	leave  
8010932d:	c3                   	ret    

8010932e <print_arp_table>:

void print_arp_table(){
8010932e:	55                   	push   %ebp
8010932f:	89 e5                	mov    %esp,%ebp
80109331:	83 ec 18             	sub    $0x18,%esp
  for(int i=0;i < ARP_TABLE_MAX;i++){
80109334:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
8010933b:	e9 92 00 00 00       	jmp    801093d2 <print_arp_table+0xa4>
    if(arp_table[i].use != 0){
80109340:	8b 55 f4             	mov    -0xc(%ebp),%edx
80109343:	89 d0                	mov    %edx,%eax
80109345:	c1 e0 02             	shl    $0x2,%eax
80109348:	01 d0                	add    %edx,%eax
8010934a:	01 c0                	add    %eax,%eax
8010934c:	01 d0                	add    %edx,%eax
8010934e:	05 aa 6e 19 80       	add    $0x80196eaa,%eax
80109353:	0f b6 00             	movzbl (%eax),%eax
80109356:	84 c0                	test   %al,%al
80109358:	74 74                	je     801093ce <print_arp_table+0xa0>
      cprintf("Entry Num: %d ",i);
8010935a:	83 ec 08             	sub    $0x8,%esp
8010935d:	ff 75 f4             	push   -0xc(%ebp)
80109360:	68 ef c1 10 80       	push   $0x8010c1ef
80109365:	e8 8a 70 ff ff       	call   801003f4 <cprintf>
8010936a:	83 c4 10             	add    $0x10,%esp
      print_ipv4(arp_table[i].ip);
8010936d:	8b 55 f4             	mov    -0xc(%ebp),%edx
80109370:	89 d0                	mov    %edx,%eax
80109372:	c1 e0 02             	shl    $0x2,%eax
80109375:	01 d0                	add    %edx,%eax
80109377:	01 c0                	add    %eax,%eax
80109379:	01 d0                	add    %edx,%eax
8010937b:	05 a0 6e 19 80       	add    $0x80196ea0,%eax
80109380:	83 ec 0c             	sub    $0xc,%esp
80109383:	50                   	push   %eax
80109384:	e8 54 02 00 00       	call   801095dd <print_ipv4>
80109389:	83 c4 10             	add    $0x10,%esp
      cprintf(" ");
8010938c:	83 ec 0c             	sub    $0xc,%esp
8010938f:	68 fe c1 10 80       	push   $0x8010c1fe
80109394:	e8 5b 70 ff ff       	call   801003f4 <cprintf>
80109399:	83 c4 10             	add    $0x10,%esp
      print_mac(arp_table[i].mac);
8010939c:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010939f:	89 d0                	mov    %edx,%eax
801093a1:	c1 e0 02             	shl    $0x2,%eax
801093a4:	01 d0                	add    %edx,%eax
801093a6:	01 c0                	add    %eax,%eax
801093a8:	01 d0                	add    %edx,%eax
801093aa:	05 a0 6e 19 80       	add    $0x80196ea0,%eax
801093af:	83 c0 04             	add    $0x4,%eax
801093b2:	83 ec 0c             	sub    $0xc,%esp
801093b5:	50                   	push   %eax
801093b6:	e8 70 02 00 00       	call   8010962b <print_mac>
801093bb:	83 c4 10             	add    $0x10,%esp
      cprintf("\n");
801093be:	83 ec 0c             	sub    $0xc,%esp
801093c1:	68 00 c2 10 80       	push   $0x8010c200
801093c6:	e8 29 70 ff ff       	call   801003f4 <cprintf>
801093cb:	83 c4 10             	add    $0x10,%esp
  for(int i=0;i < ARP_TABLE_MAX;i++){
801093ce:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
801093d2:	83 7d f4 3f          	cmpl   $0x3f,-0xc(%ebp)
801093d6:	0f 8e 64 ff ff ff    	jle    80109340 <print_arp_table+0x12>
    }
  }
}
801093dc:	90                   	nop
801093dd:	90                   	nop
801093de:	c9                   	leave  
801093df:	c3                   	ret    

801093e0 <arp_reply_pkt_create>:


void arp_reply_pkt_create(struct arp_pkt *arp_recv,uint send,uint *send_size){
801093e0:	55                   	push   %ebp
801093e1:	89 e5                	mov    %esp,%ebp
801093e3:	83 ec 18             	sub    $0x18,%esp
  *send_size = sizeof(struct eth_pkt) + sizeof(struct arp_pkt);
801093e6:	8b 45 10             	mov    0x10(%ebp),%eax
801093e9:	c7 00 2c 00 00 00    	movl   $0x2c,(%eax)
  
  struct eth_pkt *reply_eth = (struct eth_pkt *)send;
801093ef:	8b 45 0c             	mov    0xc(%ebp),%eax
801093f2:	89 45 f4             	mov    %eax,-0xc(%ebp)
  struct arp_pkt *reply_arp = (struct arp_pkt *)(send + sizeof(struct eth_pkt));
801093f5:	8b 45 0c             	mov    0xc(%ebp),%eax
801093f8:	83 c0 0e             	add    $0xe,%eax
801093fb:	89 45 f0             	mov    %eax,-0x10(%ebp)

  reply_eth->type[0] = 0x08;
801093fe:	8b 45 f4             	mov    -0xc(%ebp),%eax
80109401:	c6 40 0c 08          	movb   $0x8,0xc(%eax)
  reply_eth->type[1] = 0x06;
80109405:	8b 45 f4             	mov    -0xc(%ebp),%eax
80109408:	c6 40 0d 06          	movb   $0x6,0xd(%eax)
  memmove(reply_eth->dst_mac,arp_recv->src_mac,6);
8010940c:	8b 45 08             	mov    0x8(%ebp),%eax
8010940f:	8d 50 08             	lea    0x8(%eax),%edx
80109412:	8b 45 f4             	mov    -0xc(%ebp),%eax
80109415:	83 ec 04             	sub    $0x4,%esp
80109418:	6a 06                	push   $0x6
8010941a:	52                   	push   %edx
8010941b:	50                   	push   %eax
8010941c:	e8 d2 b8 ff ff       	call   80104cf3 <memmove>
80109421:	83 c4 10             	add    $0x10,%esp
  memmove(reply_eth->src_mac,mac_addr,6);
80109424:	8b 45 f4             	mov    -0xc(%ebp),%eax
80109427:	83 c0 06             	add    $0x6,%eax
8010942a:	83 ec 04             	sub    $0x4,%esp
8010942d:	6a 06                	push   $0x6
8010942f:	68 80 6e 19 80       	push   $0x80196e80
80109434:	50                   	push   %eax
80109435:	e8 b9 b8 ff ff       	call   80104cf3 <memmove>
8010943a:	83 c4 10             	add    $0x10,%esp

  reply_arp->hrd_type = ARP_HARDWARE_TYPE;
8010943d:	8b 45 f0             	mov    -0x10(%ebp),%eax
80109440:	66 c7 00 00 01       	movw   $0x100,(%eax)
  reply_arp->pro_type = ARP_PROTOCOL_TYPE;
80109445:	8b 45 f0             	mov    -0x10(%ebp),%eax
80109448:	66 c7 40 02 08 00    	movw   $0x8,0x2(%eax)
  reply_arp->hrd_len = 6;
8010944e:	8b 45 f0             	mov    -0x10(%ebp),%eax
80109451:	c6 40 04 06          	movb   $0x6,0x4(%eax)
  reply_arp->pro_len = 4;
80109455:	8b 45 f0             	mov    -0x10(%ebp),%eax
80109458:	c6 40 05 04          	movb   $0x4,0x5(%eax)
  reply_arp->op = ARP_OPS_REPLY;
8010945c:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010945f:	66 c7 40 06 00 02    	movw   $0x200,0x6(%eax)
  memmove(reply_arp->dst_mac,arp_recv->src_mac,6);
80109465:	8b 45 08             	mov    0x8(%ebp),%eax
80109468:	8d 50 08             	lea    0x8(%eax),%edx
8010946b:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010946e:	83 c0 12             	add    $0x12,%eax
80109471:	83 ec 04             	sub    $0x4,%esp
80109474:	6a 06                	push   $0x6
80109476:	52                   	push   %edx
80109477:	50                   	push   %eax
80109478:	e8 76 b8 ff ff       	call   80104cf3 <memmove>
8010947d:	83 c4 10             	add    $0x10,%esp
  memmove(reply_arp->dst_ip,arp_recv->src_ip,4);
80109480:	8b 45 08             	mov    0x8(%ebp),%eax
80109483:	8d 50 0e             	lea    0xe(%eax),%edx
80109486:	8b 45 f0             	mov    -0x10(%ebp),%eax
80109489:	83 c0 18             	add    $0x18,%eax
8010948c:	83 ec 04             	sub    $0x4,%esp
8010948f:	6a 04                	push   $0x4
80109491:	52                   	push   %edx
80109492:	50                   	push   %eax
80109493:	e8 5b b8 ff ff       	call   80104cf3 <memmove>
80109498:	83 c4 10             	add    $0x10,%esp
  memmove(reply_arp->src_mac,mac_addr,6);
8010949b:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010949e:	83 c0 08             	add    $0x8,%eax
801094a1:	83 ec 04             	sub    $0x4,%esp
801094a4:	6a 06                	push   $0x6
801094a6:	68 80 6e 19 80       	push   $0x80196e80
801094ab:	50                   	push   %eax
801094ac:	e8 42 b8 ff ff       	call   80104cf3 <memmove>
801094b1:	83 c4 10             	add    $0x10,%esp
  memmove(reply_arp->src_ip,my_ip,4);
801094b4:	8b 45 f0             	mov    -0x10(%ebp),%eax
801094b7:	83 c0 0e             	add    $0xe,%eax
801094ba:	83 ec 04             	sub    $0x4,%esp
801094bd:	6a 04                	push   $0x4
801094bf:	68 04 f5 10 80       	push   $0x8010f504
801094c4:	50                   	push   %eax
801094c5:	e8 29 b8 ff ff       	call   80104cf3 <memmove>
801094ca:	83 c4 10             	add    $0x10,%esp
}
801094cd:	90                   	nop
801094ce:	c9                   	leave  
801094cf:	c3                   	ret    

801094d0 <print_arp_info>:

void print_arp_info(struct arp_pkt* arp_p){
801094d0:	55                   	push   %ebp
801094d1:	89 e5                	mov    %esp,%ebp
801094d3:	83 ec 08             	sub    $0x8,%esp
  cprintf("--------Source-------\n");
801094d6:	83 ec 0c             	sub    $0xc,%esp
801094d9:	68 02 c2 10 80       	push   $0x8010c202
801094de:	e8 11 6f ff ff       	call   801003f4 <cprintf>
801094e3:	83 c4 10             	add    $0x10,%esp
  print_ipv4(arp_p->src_ip);
801094e6:	8b 45 08             	mov    0x8(%ebp),%eax
801094e9:	83 c0 0e             	add    $0xe,%eax
801094ec:	83 ec 0c             	sub    $0xc,%esp
801094ef:	50                   	push   %eax
801094f0:	e8 e8 00 00 00       	call   801095dd <print_ipv4>
801094f5:	83 c4 10             	add    $0x10,%esp
  cprintf("\n");
801094f8:	83 ec 0c             	sub    $0xc,%esp
801094fb:	68 00 c2 10 80       	push   $0x8010c200
80109500:	e8 ef 6e ff ff       	call   801003f4 <cprintf>
80109505:	83 c4 10             	add    $0x10,%esp
  print_mac(arp_p->src_mac);
80109508:	8b 45 08             	mov    0x8(%ebp),%eax
8010950b:	83 c0 08             	add    $0x8,%eax
8010950e:	83 ec 0c             	sub    $0xc,%esp
80109511:	50                   	push   %eax
80109512:	e8 14 01 00 00       	call   8010962b <print_mac>
80109517:	83 c4 10             	add    $0x10,%esp
  cprintf("\n");
8010951a:	83 ec 0c             	sub    $0xc,%esp
8010951d:	68 00 c2 10 80       	push   $0x8010c200
80109522:	e8 cd 6e ff ff       	call   801003f4 <cprintf>
80109527:	83 c4 10             	add    $0x10,%esp
  cprintf("-----Destination-----\n");
8010952a:	83 ec 0c             	sub    $0xc,%esp
8010952d:	68 19 c2 10 80       	push   $0x8010c219
80109532:	e8 bd 6e ff ff       	call   801003f4 <cprintf>
80109537:	83 c4 10             	add    $0x10,%esp
  print_ipv4(arp_p->dst_ip);
8010953a:	8b 45 08             	mov    0x8(%ebp),%eax
8010953d:	83 c0 18             	add    $0x18,%eax
80109540:	83 ec 0c             	sub    $0xc,%esp
80109543:	50                   	push   %eax
80109544:	e8 94 00 00 00       	call   801095dd <print_ipv4>
80109549:	83 c4 10             	add    $0x10,%esp
  cprintf("\n");
8010954c:	83 ec 0c             	sub    $0xc,%esp
8010954f:	68 00 c2 10 80       	push   $0x8010c200
80109554:	e8 9b 6e ff ff       	call   801003f4 <cprintf>
80109559:	83 c4 10             	add    $0x10,%esp
  print_mac(arp_p->dst_mac);
8010955c:	8b 45 08             	mov    0x8(%ebp),%eax
8010955f:	83 c0 12             	add    $0x12,%eax
80109562:	83 ec 0c             	sub    $0xc,%esp
80109565:	50                   	push   %eax
80109566:	e8 c0 00 00 00       	call   8010962b <print_mac>
8010956b:	83 c4 10             	add    $0x10,%esp
  cprintf("\n");
8010956e:	83 ec 0c             	sub    $0xc,%esp
80109571:	68 00 c2 10 80       	push   $0x8010c200
80109576:	e8 79 6e ff ff       	call   801003f4 <cprintf>
8010957b:	83 c4 10             	add    $0x10,%esp
  cprintf("Operation: ");
8010957e:	83 ec 0c             	sub    $0xc,%esp
80109581:	68 30 c2 10 80       	push   $0x8010c230
80109586:	e8 69 6e ff ff       	call   801003f4 <cprintf>
8010958b:	83 c4 10             	add    $0x10,%esp
  if(arp_p->op == ARP_OPS_REQUEST) cprintf("Request\n");
8010958e:	8b 45 08             	mov    0x8(%ebp),%eax
80109591:	0f b7 40 06          	movzwl 0x6(%eax),%eax
80109595:	66 3d 00 01          	cmp    $0x100,%ax
80109599:	75 12                	jne    801095ad <print_arp_info+0xdd>
8010959b:	83 ec 0c             	sub    $0xc,%esp
8010959e:	68 3c c2 10 80       	push   $0x8010c23c
801095a3:	e8 4c 6e ff ff       	call   801003f4 <cprintf>
801095a8:	83 c4 10             	add    $0x10,%esp
801095ab:	eb 1d                	jmp    801095ca <print_arp_info+0xfa>
  else if(arp_p->op == ARP_OPS_REPLY) {
801095ad:	8b 45 08             	mov    0x8(%ebp),%eax
801095b0:	0f b7 40 06          	movzwl 0x6(%eax),%eax
801095b4:	66 3d 00 02          	cmp    $0x200,%ax
801095b8:	75 10                	jne    801095ca <print_arp_info+0xfa>
    cprintf("Reply\n");
801095ba:	83 ec 0c             	sub    $0xc,%esp
801095bd:	68 45 c2 10 80       	push   $0x8010c245
801095c2:	e8 2d 6e ff ff       	call   801003f4 <cprintf>
801095c7:	83 c4 10             	add    $0x10,%esp
  }
  cprintf("\n");
801095ca:	83 ec 0c             	sub    $0xc,%esp
801095cd:	68 00 c2 10 80       	push   $0x8010c200
801095d2:	e8 1d 6e ff ff       	call   801003f4 <cprintf>
801095d7:	83 c4 10             	add    $0x10,%esp
}
801095da:	90                   	nop
801095db:	c9                   	leave  
801095dc:	c3                   	ret    

801095dd <print_ipv4>:

void print_ipv4(uchar *ip){
801095dd:	55                   	push   %ebp
801095de:	89 e5                	mov    %esp,%ebp
801095e0:	53                   	push   %ebx
801095e1:	83 ec 04             	sub    $0x4,%esp
  cprintf("IP address: %d.%d.%d.%d",ip[0],ip[1],ip[2],ip[3]);
801095e4:	8b 45 08             	mov    0x8(%ebp),%eax
801095e7:	83 c0 03             	add    $0x3,%eax
801095ea:	0f b6 00             	movzbl (%eax),%eax
801095ed:	0f b6 d8             	movzbl %al,%ebx
801095f0:	8b 45 08             	mov    0x8(%ebp),%eax
801095f3:	83 c0 02             	add    $0x2,%eax
801095f6:	0f b6 00             	movzbl (%eax),%eax
801095f9:	0f b6 c8             	movzbl %al,%ecx
801095fc:	8b 45 08             	mov    0x8(%ebp),%eax
801095ff:	83 c0 01             	add    $0x1,%eax
80109602:	0f b6 00             	movzbl (%eax),%eax
80109605:	0f b6 d0             	movzbl %al,%edx
80109608:	8b 45 08             	mov    0x8(%ebp),%eax
8010960b:	0f b6 00             	movzbl (%eax),%eax
8010960e:	0f b6 c0             	movzbl %al,%eax
80109611:	83 ec 0c             	sub    $0xc,%esp
80109614:	53                   	push   %ebx
80109615:	51                   	push   %ecx
80109616:	52                   	push   %edx
80109617:	50                   	push   %eax
80109618:	68 4c c2 10 80       	push   $0x8010c24c
8010961d:	e8 d2 6d ff ff       	call   801003f4 <cprintf>
80109622:	83 c4 20             	add    $0x20,%esp
}
80109625:	90                   	nop
80109626:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80109629:	c9                   	leave  
8010962a:	c3                   	ret    

8010962b <print_mac>:

void print_mac(uchar *mac){
8010962b:	55                   	push   %ebp
8010962c:	89 e5                	mov    %esp,%ebp
8010962e:	57                   	push   %edi
8010962f:	56                   	push   %esi
80109630:	53                   	push   %ebx
80109631:	83 ec 0c             	sub    $0xc,%esp
  cprintf("MAC address: %x:%x:%x:%x:%x:%x",mac[0],mac[1],mac[2],mac[3],mac[4],mac[5]);
80109634:	8b 45 08             	mov    0x8(%ebp),%eax
80109637:	83 c0 05             	add    $0x5,%eax
8010963a:	0f b6 00             	movzbl (%eax),%eax
8010963d:	0f b6 f8             	movzbl %al,%edi
80109640:	8b 45 08             	mov    0x8(%ebp),%eax
80109643:	83 c0 04             	add    $0x4,%eax
80109646:	0f b6 00             	movzbl (%eax),%eax
80109649:	0f b6 f0             	movzbl %al,%esi
8010964c:	8b 45 08             	mov    0x8(%ebp),%eax
8010964f:	83 c0 03             	add    $0x3,%eax
80109652:	0f b6 00             	movzbl (%eax),%eax
80109655:	0f b6 d8             	movzbl %al,%ebx
80109658:	8b 45 08             	mov    0x8(%ebp),%eax
8010965b:	83 c0 02             	add    $0x2,%eax
8010965e:	0f b6 00             	movzbl (%eax),%eax
80109661:	0f b6 c8             	movzbl %al,%ecx
80109664:	8b 45 08             	mov    0x8(%ebp),%eax
80109667:	83 c0 01             	add    $0x1,%eax
8010966a:	0f b6 00             	movzbl (%eax),%eax
8010966d:	0f b6 d0             	movzbl %al,%edx
80109670:	8b 45 08             	mov    0x8(%ebp),%eax
80109673:	0f b6 00             	movzbl (%eax),%eax
80109676:	0f b6 c0             	movzbl %al,%eax
80109679:	83 ec 04             	sub    $0x4,%esp
8010967c:	57                   	push   %edi
8010967d:	56                   	push   %esi
8010967e:	53                   	push   %ebx
8010967f:	51                   	push   %ecx
80109680:	52                   	push   %edx
80109681:	50                   	push   %eax
80109682:	68 64 c2 10 80       	push   $0x8010c264
80109687:	e8 68 6d ff ff       	call   801003f4 <cprintf>
8010968c:	83 c4 20             	add    $0x20,%esp
}
8010968f:	90                   	nop
80109690:	8d 65 f4             	lea    -0xc(%ebp),%esp
80109693:	5b                   	pop    %ebx
80109694:	5e                   	pop    %esi
80109695:	5f                   	pop    %edi
80109696:	5d                   	pop    %ebp
80109697:	c3                   	ret    

80109698 <eth_proc>:
#include "arp.h"
#include "types.h"
#include "eth.h"
#include "defs.h"
#include "ipv4.h"
void eth_proc(uint buffer_addr){
80109698:	55                   	push   %ebp
80109699:	89 e5                	mov    %esp,%ebp
8010969b:	83 ec 18             	sub    $0x18,%esp
  struct eth_pkt *eth_pkt = (struct eth_pkt *)buffer_addr;
8010969e:	8b 45 08             	mov    0x8(%ebp),%eax
801096a1:	89 45 f4             	mov    %eax,-0xc(%ebp)
  uint pkt_addr = buffer_addr+sizeof(struct eth_pkt);
801096a4:	8b 45 08             	mov    0x8(%ebp),%eax
801096a7:	83 c0 0e             	add    $0xe,%eax
801096aa:	89 45 f0             	mov    %eax,-0x10(%ebp)
  if(eth_pkt->type[0] == 0x08 && eth_pkt->type[1] == 0x06){
801096ad:	8b 45 f4             	mov    -0xc(%ebp),%eax
801096b0:	0f b6 40 0c          	movzbl 0xc(%eax),%eax
801096b4:	3c 08                	cmp    $0x8,%al
801096b6:	75 1b                	jne    801096d3 <eth_proc+0x3b>
801096b8:	8b 45 f4             	mov    -0xc(%ebp),%eax
801096bb:	0f b6 40 0d          	movzbl 0xd(%eax),%eax
801096bf:	3c 06                	cmp    $0x6,%al
801096c1:	75 10                	jne    801096d3 <eth_proc+0x3b>
    arp_proc(pkt_addr);
801096c3:	83 ec 0c             	sub    $0xc,%esp
801096c6:	ff 75 f0             	push   -0x10(%ebp)
801096c9:	e8 01 f8 ff ff       	call   80108ecf <arp_proc>
801096ce:	83 c4 10             	add    $0x10,%esp
  }else if(eth_pkt->type[0] == 0x08 && eth_pkt->type[1] == 0x00){
    ipv4_proc(buffer_addr);
  }else{
  }
}
801096d1:	eb 24                	jmp    801096f7 <eth_proc+0x5f>
  }else if(eth_pkt->type[0] == 0x08 && eth_pkt->type[1] == 0x00){
801096d3:	8b 45 f4             	mov    -0xc(%ebp),%eax
801096d6:	0f b6 40 0c          	movzbl 0xc(%eax),%eax
801096da:	3c 08                	cmp    $0x8,%al
801096dc:	75 19                	jne    801096f7 <eth_proc+0x5f>
801096de:	8b 45 f4             	mov    -0xc(%ebp),%eax
801096e1:	0f b6 40 0d          	movzbl 0xd(%eax),%eax
801096e5:	84 c0                	test   %al,%al
801096e7:	75 0e                	jne    801096f7 <eth_proc+0x5f>
    ipv4_proc(buffer_addr);
801096e9:	83 ec 0c             	sub    $0xc,%esp
801096ec:	ff 75 08             	push   0x8(%ebp)
801096ef:	e8 a3 00 00 00       	call   80109797 <ipv4_proc>
801096f4:	83 c4 10             	add    $0x10,%esp
}
801096f7:	90                   	nop
801096f8:	c9                   	leave  
801096f9:	c3                   	ret    

801096fa <N2H_ushort>:

ushort N2H_ushort(ushort value){
801096fa:	55                   	push   %ebp
801096fb:	89 e5                	mov    %esp,%ebp
801096fd:	83 ec 04             	sub    $0x4,%esp
80109700:	8b 45 08             	mov    0x8(%ebp),%eax
80109703:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  return (((value)&0xFF)<<8)+(value>>8);
80109707:	0f b7 45 fc          	movzwl -0x4(%ebp),%eax
8010970b:	c1 e0 08             	shl    $0x8,%eax
8010970e:	89 c2                	mov    %eax,%edx
80109710:	0f b7 45 fc          	movzwl -0x4(%ebp),%eax
80109714:	66 c1 e8 08          	shr    $0x8,%ax
80109718:	01 d0                	add    %edx,%eax
}
8010971a:	c9                   	leave  
8010971b:	c3                   	ret    

8010971c <H2N_ushort>:

ushort H2N_ushort(ushort value){
8010971c:	55                   	push   %ebp
8010971d:	89 e5                	mov    %esp,%ebp
8010971f:	83 ec 04             	sub    $0x4,%esp
80109722:	8b 45 08             	mov    0x8(%ebp),%eax
80109725:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  return (((value)&0xFF)<<8)+(value>>8);
80109729:	0f b7 45 fc          	movzwl -0x4(%ebp),%eax
8010972d:	c1 e0 08             	shl    $0x8,%eax
80109730:	89 c2                	mov    %eax,%edx
80109732:	0f b7 45 fc          	movzwl -0x4(%ebp),%eax
80109736:	66 c1 e8 08          	shr    $0x8,%ax
8010973a:	01 d0                	add    %edx,%eax
}
8010973c:	c9                   	leave  
8010973d:	c3                   	ret    

8010973e <H2N_uint>:

uint H2N_uint(uint value){
8010973e:	55                   	push   %ebp
8010973f:	89 e5                	mov    %esp,%ebp
  return ((value&0xF)<<24)+((value&0xF0)<<8)+((value&0xF00)>>8)+((value&0xF000)>>24);
80109741:	8b 45 08             	mov    0x8(%ebp),%eax
80109744:	c1 e0 18             	shl    $0x18,%eax
80109747:	25 00 00 00 0f       	and    $0xf000000,%eax
8010974c:	89 c2                	mov    %eax,%edx
8010974e:	8b 45 08             	mov    0x8(%ebp),%eax
80109751:	c1 e0 08             	shl    $0x8,%eax
80109754:	25 00 f0 00 00       	and    $0xf000,%eax
80109759:	09 c2                	or     %eax,%edx
8010975b:	8b 45 08             	mov    0x8(%ebp),%eax
8010975e:	c1 e8 08             	shr    $0x8,%eax
80109761:	83 e0 0f             	and    $0xf,%eax
80109764:	01 d0                	add    %edx,%eax
}
80109766:	5d                   	pop    %ebp
80109767:	c3                   	ret    

80109768 <N2H_uint>:

uint N2H_uint(uint value){
80109768:	55                   	push   %ebp
80109769:	89 e5                	mov    %esp,%ebp
  return ((value&0xFF)<<24)+((value&0xFF00)<<8)+((value&0xFF0000)>>8)+((value&0xFF000000)>>24);
8010976b:	8b 45 08             	mov    0x8(%ebp),%eax
8010976e:	c1 e0 18             	shl    $0x18,%eax
80109771:	89 c2                	mov    %eax,%edx
80109773:	8b 45 08             	mov    0x8(%ebp),%eax
80109776:	c1 e0 08             	shl    $0x8,%eax
80109779:	25 00 00 ff 00       	and    $0xff0000,%eax
8010977e:	01 c2                	add    %eax,%edx
80109780:	8b 45 08             	mov    0x8(%ebp),%eax
80109783:	c1 e8 08             	shr    $0x8,%eax
80109786:	25 00 ff 00 00       	and    $0xff00,%eax
8010978b:	01 c2                	add    %eax,%edx
8010978d:	8b 45 08             	mov    0x8(%ebp),%eax
80109790:	c1 e8 18             	shr    $0x18,%eax
80109793:	01 d0                	add    %edx,%eax
}
80109795:	5d                   	pop    %ebp
80109796:	c3                   	ret    

80109797 <ipv4_proc>:
extern uchar mac_addr[6];
extern uchar my_ip[4];

int ip_id = -1;
ushort send_id = 0;
void ipv4_proc(uint buffer_addr){
80109797:	55                   	push   %ebp
80109798:	89 e5                	mov    %esp,%ebp
8010979a:	83 ec 18             	sub    $0x18,%esp
  struct ipv4_pkt *ipv4_p = (struct ipv4_pkt *)(buffer_addr+14);
8010979d:	8b 45 08             	mov    0x8(%ebp),%eax
801097a0:	83 c0 0e             	add    $0xe,%eax
801097a3:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(ip_id != ipv4_p->id && memcmp(my_ip,ipv4_p->src_ip,4) != 0){
801097a6:	8b 45 f4             	mov    -0xc(%ebp),%eax
801097a9:	0f b7 40 04          	movzwl 0x4(%eax),%eax
801097ad:	0f b7 d0             	movzwl %ax,%edx
801097b0:	a1 08 f5 10 80       	mov    0x8010f508,%eax
801097b5:	39 c2                	cmp    %eax,%edx
801097b7:	74 60                	je     80109819 <ipv4_proc+0x82>
801097b9:	8b 45 f4             	mov    -0xc(%ebp),%eax
801097bc:	83 c0 0c             	add    $0xc,%eax
801097bf:	83 ec 04             	sub    $0x4,%esp
801097c2:	6a 04                	push   $0x4
801097c4:	50                   	push   %eax
801097c5:	68 04 f5 10 80       	push   $0x8010f504
801097ca:	e8 cc b4 ff ff       	call   80104c9b <memcmp>
801097cf:	83 c4 10             	add    $0x10,%esp
801097d2:	85 c0                	test   %eax,%eax
801097d4:	74 43                	je     80109819 <ipv4_proc+0x82>
    ip_id = ipv4_p->id;
801097d6:	8b 45 f4             	mov    -0xc(%ebp),%eax
801097d9:	0f b7 40 04          	movzwl 0x4(%eax),%eax
801097dd:	0f b7 c0             	movzwl %ax,%eax
801097e0:	a3 08 f5 10 80       	mov    %eax,0x8010f508
      if(ipv4_p->protocol == IPV4_TYPE_ICMP){
801097e5:	8b 45 f4             	mov    -0xc(%ebp),%eax
801097e8:	0f b6 40 09          	movzbl 0x9(%eax),%eax
801097ec:	3c 01                	cmp    $0x1,%al
801097ee:	75 10                	jne    80109800 <ipv4_proc+0x69>
        icmp_proc(buffer_addr);
801097f0:	83 ec 0c             	sub    $0xc,%esp
801097f3:	ff 75 08             	push   0x8(%ebp)
801097f6:	e8 a3 00 00 00       	call   8010989e <icmp_proc>
801097fb:	83 c4 10             	add    $0x10,%esp
      }else if(ipv4_p->protocol == IPV4_TYPE_TCP){
        tcp_proc(buffer_addr);
      }
  }
}
801097fe:	eb 19                	jmp    80109819 <ipv4_proc+0x82>
      }else if(ipv4_p->protocol == IPV4_TYPE_TCP){
80109800:	8b 45 f4             	mov    -0xc(%ebp),%eax
80109803:	0f b6 40 09          	movzbl 0x9(%eax),%eax
80109807:	3c 06                	cmp    $0x6,%al
80109809:	75 0e                	jne    80109819 <ipv4_proc+0x82>
        tcp_proc(buffer_addr);
8010980b:	83 ec 0c             	sub    $0xc,%esp
8010980e:	ff 75 08             	push   0x8(%ebp)
80109811:	e8 b3 03 00 00       	call   80109bc9 <tcp_proc>
80109816:	83 c4 10             	add    $0x10,%esp
}
80109819:	90                   	nop
8010981a:	c9                   	leave  
8010981b:	c3                   	ret    

8010981c <ipv4_chksum>:

ushort ipv4_chksum(uint ipv4_addr){
8010981c:	55                   	push   %ebp
8010981d:	89 e5                	mov    %esp,%ebp
8010981f:	83 ec 10             	sub    $0x10,%esp
  uchar* bin = (uchar *)ipv4_addr;
80109822:	8b 45 08             	mov    0x8(%ebp),%eax
80109825:	89 45 f4             	mov    %eax,-0xc(%ebp)
  uchar len = (bin[0]&0xF)*2;
80109828:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010982b:	0f b6 00             	movzbl (%eax),%eax
8010982e:	83 e0 0f             	and    $0xf,%eax
80109831:	01 c0                	add    %eax,%eax
80109833:	88 45 f3             	mov    %al,-0xd(%ebp)
  uint chk_sum = 0;
80109836:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  for(int i=0;i<len;i++){
8010983d:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
80109844:	eb 48                	jmp    8010988e <ipv4_chksum+0x72>
    chk_sum += (bin[i*2]<<8)+bin[i*2+1];
80109846:	8b 45 f8             	mov    -0x8(%ebp),%eax
80109849:	01 c0                	add    %eax,%eax
8010984b:	89 c2                	mov    %eax,%edx
8010984d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80109850:	01 d0                	add    %edx,%eax
80109852:	0f b6 00             	movzbl (%eax),%eax
80109855:	0f b6 c0             	movzbl %al,%eax
80109858:	c1 e0 08             	shl    $0x8,%eax
8010985b:	89 c2                	mov    %eax,%edx
8010985d:	8b 45 f8             	mov    -0x8(%ebp),%eax
80109860:	01 c0                	add    %eax,%eax
80109862:	8d 48 01             	lea    0x1(%eax),%ecx
80109865:	8b 45 f4             	mov    -0xc(%ebp),%eax
80109868:	01 c8                	add    %ecx,%eax
8010986a:	0f b6 00             	movzbl (%eax),%eax
8010986d:	0f b6 c0             	movzbl %al,%eax
80109870:	01 d0                	add    %edx,%eax
80109872:	01 45 fc             	add    %eax,-0x4(%ebp)
    if(chk_sum > 0xFFFF){
80109875:	81 7d fc ff ff 00 00 	cmpl   $0xffff,-0x4(%ebp)
8010987c:	76 0c                	jbe    8010988a <ipv4_chksum+0x6e>
      chk_sum = (chk_sum&0xFFFF)+1;
8010987e:	8b 45 fc             	mov    -0x4(%ebp),%eax
80109881:	0f b7 c0             	movzwl %ax,%eax
80109884:	83 c0 01             	add    $0x1,%eax
80109887:	89 45 fc             	mov    %eax,-0x4(%ebp)
  for(int i=0;i<len;i++){
8010988a:	83 45 f8 01          	addl   $0x1,-0x8(%ebp)
8010988e:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
80109892:	39 45 f8             	cmp    %eax,-0x8(%ebp)
80109895:	7c af                	jl     80109846 <ipv4_chksum+0x2a>
    }
  }
  return ~(chk_sum);
80109897:	8b 45 fc             	mov    -0x4(%ebp),%eax
8010989a:	f7 d0                	not    %eax
}
8010989c:	c9                   	leave  
8010989d:	c3                   	ret    

8010989e <icmp_proc>:
#include "eth.h"

extern uchar mac_addr[6];
extern uchar my_ip[4];
extern ushort send_id;
void icmp_proc(uint buffer_addr){
8010989e:	55                   	push   %ebp
8010989f:	89 e5                	mov    %esp,%ebp
801098a1:	83 ec 18             	sub    $0x18,%esp
  struct ipv4_pkt *ipv4_p = (struct ipv4_pkt *)(buffer_addr+sizeof(struct eth_pkt));
801098a4:	8b 45 08             	mov    0x8(%ebp),%eax
801098a7:	83 c0 0e             	add    $0xe,%eax
801098aa:	89 45 f4             	mov    %eax,-0xc(%ebp)
  struct icmp_echo_pkt *icmp_p = (struct icmp_echo_pkt *)((uint)ipv4_p + (ipv4_p->ver&0xF)*4);
801098ad:	8b 45 f4             	mov    -0xc(%ebp),%eax
801098b0:	0f b6 00             	movzbl (%eax),%eax
801098b3:	0f b6 c0             	movzbl %al,%eax
801098b6:	83 e0 0f             	and    $0xf,%eax
801098b9:	c1 e0 02             	shl    $0x2,%eax
801098bc:	89 c2                	mov    %eax,%edx
801098be:	8b 45 f4             	mov    -0xc(%ebp),%eax
801098c1:	01 d0                	add    %edx,%eax
801098c3:	89 45 f0             	mov    %eax,-0x10(%ebp)
  if(icmp_p->code == 0){
801098c6:	8b 45 f0             	mov    -0x10(%ebp),%eax
801098c9:	0f b6 40 01          	movzbl 0x1(%eax),%eax
801098cd:	84 c0                	test   %al,%al
801098cf:	75 4f                	jne    80109920 <icmp_proc+0x82>
    if(icmp_p->type == ICMP_TYPE_ECHO_REQUEST){
801098d1:	8b 45 f0             	mov    -0x10(%ebp),%eax
801098d4:	0f b6 00             	movzbl (%eax),%eax
801098d7:	3c 08                	cmp    $0x8,%al
801098d9:	75 45                	jne    80109920 <icmp_proc+0x82>
      uint send_addr = (uint)kalloc();
801098db:	e8 c0 8e ff ff       	call   801027a0 <kalloc>
801098e0:	89 45 ec             	mov    %eax,-0x14(%ebp)
      uint send_size = 0;
801098e3:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
      icmp_reply_pkt_create(buffer_addr,send_addr,&send_size);
801098ea:	83 ec 04             	sub    $0x4,%esp
801098ed:	8d 45 e8             	lea    -0x18(%ebp),%eax
801098f0:	50                   	push   %eax
801098f1:	ff 75 ec             	push   -0x14(%ebp)
801098f4:	ff 75 08             	push   0x8(%ebp)
801098f7:	e8 78 00 00 00       	call   80109974 <icmp_reply_pkt_create>
801098fc:	83 c4 10             	add    $0x10,%esp
      i8254_send(send_addr,send_size);
801098ff:	8b 45 e8             	mov    -0x18(%ebp),%eax
80109902:	83 ec 08             	sub    $0x8,%esp
80109905:	50                   	push   %eax
80109906:	ff 75 ec             	push   -0x14(%ebp)
80109909:	e8 95 f4 ff ff       	call   80108da3 <i8254_send>
8010990e:	83 c4 10             	add    $0x10,%esp
      kfree((char *)send_addr);
80109911:	8b 45 ec             	mov    -0x14(%ebp),%eax
80109914:	83 ec 0c             	sub    $0xc,%esp
80109917:	50                   	push   %eax
80109918:	e8 e9 8d ff ff       	call   80102706 <kfree>
8010991d:	83 c4 10             	add    $0x10,%esp
    }
  }
}
80109920:	90                   	nop
80109921:	c9                   	leave  
80109922:	c3                   	ret    

80109923 <icmp_proc_req>:

void icmp_proc_req(struct icmp_echo_pkt * icmp_p){
80109923:	55                   	push   %ebp
80109924:	89 e5                	mov    %esp,%ebp
80109926:	53                   	push   %ebx
80109927:	83 ec 04             	sub    $0x4,%esp
  cprintf("ICMP ID:0x%x SEQ NUM:0x%x\n",N2H_ushort(icmp_p->id),N2H_ushort(icmp_p->seq_num));
8010992a:	8b 45 08             	mov    0x8(%ebp),%eax
8010992d:	0f b7 40 06          	movzwl 0x6(%eax),%eax
80109931:	0f b7 c0             	movzwl %ax,%eax
80109934:	83 ec 0c             	sub    $0xc,%esp
80109937:	50                   	push   %eax
80109938:	e8 bd fd ff ff       	call   801096fa <N2H_ushort>
8010993d:	83 c4 10             	add    $0x10,%esp
80109940:	0f b7 d8             	movzwl %ax,%ebx
80109943:	8b 45 08             	mov    0x8(%ebp),%eax
80109946:	0f b7 40 04          	movzwl 0x4(%eax),%eax
8010994a:	0f b7 c0             	movzwl %ax,%eax
8010994d:	83 ec 0c             	sub    $0xc,%esp
80109950:	50                   	push   %eax
80109951:	e8 a4 fd ff ff       	call   801096fa <N2H_ushort>
80109956:	83 c4 10             	add    $0x10,%esp
80109959:	0f b7 c0             	movzwl %ax,%eax
8010995c:	83 ec 04             	sub    $0x4,%esp
8010995f:	53                   	push   %ebx
80109960:	50                   	push   %eax
80109961:	68 83 c2 10 80       	push   $0x8010c283
80109966:	e8 89 6a ff ff       	call   801003f4 <cprintf>
8010996b:	83 c4 10             	add    $0x10,%esp
}
8010996e:	90                   	nop
8010996f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80109972:	c9                   	leave  
80109973:	c3                   	ret    

80109974 <icmp_reply_pkt_create>:

void icmp_reply_pkt_create(uint recv_addr,uint send_addr,uint *send_size){
80109974:	55                   	push   %ebp
80109975:	89 e5                	mov    %esp,%ebp
80109977:	83 ec 28             	sub    $0x28,%esp
  struct eth_pkt *eth_recv = (struct eth_pkt *)(recv_addr);
8010997a:	8b 45 08             	mov    0x8(%ebp),%eax
8010997d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  struct ipv4_pkt *ipv4_recv = (struct ipv4_pkt *)(recv_addr+sizeof(struct eth_pkt));
80109980:	8b 45 08             	mov    0x8(%ebp),%eax
80109983:	83 c0 0e             	add    $0xe,%eax
80109986:	89 45 f0             	mov    %eax,-0x10(%ebp)
  struct icmp_echo_pkt *icmp_recv = (struct icmp_echo_pkt *)((uint)ipv4_recv+(ipv4_recv->ver&0xF)*4);
80109989:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010998c:	0f b6 00             	movzbl (%eax),%eax
8010998f:	0f b6 c0             	movzbl %al,%eax
80109992:	83 e0 0f             	and    $0xf,%eax
80109995:	c1 e0 02             	shl    $0x2,%eax
80109998:	89 c2                	mov    %eax,%edx
8010999a:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010999d:	01 d0                	add    %edx,%eax
8010999f:	89 45 ec             	mov    %eax,-0x14(%ebp)
  struct eth_pkt *eth_send = (struct eth_pkt *)(send_addr);
801099a2:	8b 45 0c             	mov    0xc(%ebp),%eax
801099a5:	89 45 e8             	mov    %eax,-0x18(%ebp)
  struct ipv4_pkt *ipv4_send = (struct ipv4_pkt *)(send_addr+sizeof(struct eth_pkt));
801099a8:	8b 45 0c             	mov    0xc(%ebp),%eax
801099ab:	83 c0 0e             	add    $0xe,%eax
801099ae:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  struct icmp_echo_pkt *icmp_send = (struct icmp_echo_pkt *)((uint)ipv4_send+sizeof(struct ipv4_pkt));
801099b1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801099b4:	83 c0 14             	add    $0x14,%eax
801099b7:	89 45 e0             	mov    %eax,-0x20(%ebp)
  
  *send_size = sizeof(struct eth_pkt) + sizeof(struct ipv4_pkt) + sizeof(struct icmp_echo_pkt);
801099ba:	8b 45 10             	mov    0x10(%ebp),%eax
801099bd:	c7 00 62 00 00 00    	movl   $0x62,(%eax)
  memmove(eth_send->dst_mac,eth_recv->src_mac,6);
801099c3:	8b 45 f4             	mov    -0xc(%ebp),%eax
801099c6:	8d 50 06             	lea    0x6(%eax),%edx
801099c9:	8b 45 e8             	mov    -0x18(%ebp),%eax
801099cc:	83 ec 04             	sub    $0x4,%esp
801099cf:	6a 06                	push   $0x6
801099d1:	52                   	push   %edx
801099d2:	50                   	push   %eax
801099d3:	e8 1b b3 ff ff       	call   80104cf3 <memmove>
801099d8:	83 c4 10             	add    $0x10,%esp
  memmove(eth_send->src_mac,mac_addr,6);
801099db:	8b 45 e8             	mov    -0x18(%ebp),%eax
801099de:	83 c0 06             	add    $0x6,%eax
801099e1:	83 ec 04             	sub    $0x4,%esp
801099e4:	6a 06                	push   $0x6
801099e6:	68 80 6e 19 80       	push   $0x80196e80
801099eb:	50                   	push   %eax
801099ec:	e8 02 b3 ff ff       	call   80104cf3 <memmove>
801099f1:	83 c4 10             	add    $0x10,%esp
  eth_send->type[0] = 0x08;
801099f4:	8b 45 e8             	mov    -0x18(%ebp),%eax
801099f7:	c6 40 0c 08          	movb   $0x8,0xc(%eax)
  eth_send->type[1] = 0x00;
801099fb:	8b 45 e8             	mov    -0x18(%ebp),%eax
801099fe:	c6 40 0d 00          	movb   $0x0,0xd(%eax)

  ipv4_send->ver = ((0x4)<<4)+((sizeof(struct ipv4_pkt)/4)&0xF);
80109a02:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80109a05:	c6 00 45             	movb   $0x45,(%eax)
  ipv4_send->srv_type = 0;
80109a08:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80109a0b:	c6 40 01 00          	movb   $0x0,0x1(%eax)
  ipv4_send->total_len = H2N_ushort(sizeof(struct ipv4_pkt) + sizeof(struct icmp_echo_pkt));
80109a0f:	83 ec 0c             	sub    $0xc,%esp
80109a12:	6a 54                	push   $0x54
80109a14:	e8 03 fd ff ff       	call   8010971c <H2N_ushort>
80109a19:	83 c4 10             	add    $0x10,%esp
80109a1c:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80109a1f:	66 89 42 02          	mov    %ax,0x2(%edx)
  ipv4_send->id = send_id;
80109a23:	0f b7 15 60 71 19 80 	movzwl 0x80197160,%edx
80109a2a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80109a2d:	66 89 50 04          	mov    %dx,0x4(%eax)
  send_id++;
80109a31:	0f b7 05 60 71 19 80 	movzwl 0x80197160,%eax
80109a38:	83 c0 01             	add    $0x1,%eax
80109a3b:	66 a3 60 71 19 80    	mov    %ax,0x80197160
  ipv4_send->fragment = H2N_ushort(0x4000);
80109a41:	83 ec 0c             	sub    $0xc,%esp
80109a44:	68 00 40 00 00       	push   $0x4000
80109a49:	e8 ce fc ff ff       	call   8010971c <H2N_ushort>
80109a4e:	83 c4 10             	add    $0x10,%esp
80109a51:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80109a54:	66 89 42 06          	mov    %ax,0x6(%edx)
  ipv4_send->ttl = 255;
80109a58:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80109a5b:	c6 40 08 ff          	movb   $0xff,0x8(%eax)
  ipv4_send->protocol = 0x1;
80109a5f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80109a62:	c6 40 09 01          	movb   $0x1,0x9(%eax)
  memmove(ipv4_send->src_ip,my_ip,4);
80109a66:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80109a69:	83 c0 0c             	add    $0xc,%eax
80109a6c:	83 ec 04             	sub    $0x4,%esp
80109a6f:	6a 04                	push   $0x4
80109a71:	68 04 f5 10 80       	push   $0x8010f504
80109a76:	50                   	push   %eax
80109a77:	e8 77 b2 ff ff       	call   80104cf3 <memmove>
80109a7c:	83 c4 10             	add    $0x10,%esp
  memmove(ipv4_send->dst_ip,ipv4_recv->src_ip,4);
80109a7f:	8b 45 f0             	mov    -0x10(%ebp),%eax
80109a82:	8d 50 0c             	lea    0xc(%eax),%edx
80109a85:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80109a88:	83 c0 10             	add    $0x10,%eax
80109a8b:	83 ec 04             	sub    $0x4,%esp
80109a8e:	6a 04                	push   $0x4
80109a90:	52                   	push   %edx
80109a91:	50                   	push   %eax
80109a92:	e8 5c b2 ff ff       	call   80104cf3 <memmove>
80109a97:	83 c4 10             	add    $0x10,%esp
  ipv4_send->chk_sum = 0;
80109a9a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80109a9d:	66 c7 40 0a 00 00    	movw   $0x0,0xa(%eax)
  ipv4_send->chk_sum = H2N_ushort(ipv4_chksum((uint)ipv4_send));
80109aa3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80109aa6:	83 ec 0c             	sub    $0xc,%esp
80109aa9:	50                   	push   %eax
80109aaa:	e8 6d fd ff ff       	call   8010981c <ipv4_chksum>
80109aaf:	83 c4 10             	add    $0x10,%esp
80109ab2:	0f b7 c0             	movzwl %ax,%eax
80109ab5:	83 ec 0c             	sub    $0xc,%esp
80109ab8:	50                   	push   %eax
80109ab9:	e8 5e fc ff ff       	call   8010971c <H2N_ushort>
80109abe:	83 c4 10             	add    $0x10,%esp
80109ac1:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80109ac4:	66 89 42 0a          	mov    %ax,0xa(%edx)

  icmp_send->type = ICMP_TYPE_ECHO_REPLY;
80109ac8:	8b 45 e0             	mov    -0x20(%ebp),%eax
80109acb:	c6 00 00             	movb   $0x0,(%eax)
  icmp_send->code = 0;
80109ace:	8b 45 e0             	mov    -0x20(%ebp),%eax
80109ad1:	c6 40 01 00          	movb   $0x0,0x1(%eax)
  icmp_send->id = icmp_recv->id;
80109ad5:	8b 45 ec             	mov    -0x14(%ebp),%eax
80109ad8:	0f b7 50 04          	movzwl 0x4(%eax),%edx
80109adc:	8b 45 e0             	mov    -0x20(%ebp),%eax
80109adf:	66 89 50 04          	mov    %dx,0x4(%eax)
  icmp_send->seq_num = icmp_recv->seq_num;
80109ae3:	8b 45 ec             	mov    -0x14(%ebp),%eax
80109ae6:	0f b7 50 06          	movzwl 0x6(%eax),%edx
80109aea:	8b 45 e0             	mov    -0x20(%ebp),%eax
80109aed:	66 89 50 06          	mov    %dx,0x6(%eax)
  memmove(icmp_send->time_stamp,icmp_recv->time_stamp,8);
80109af1:	8b 45 ec             	mov    -0x14(%ebp),%eax
80109af4:	8d 50 08             	lea    0x8(%eax),%edx
80109af7:	8b 45 e0             	mov    -0x20(%ebp),%eax
80109afa:	83 c0 08             	add    $0x8,%eax
80109afd:	83 ec 04             	sub    $0x4,%esp
80109b00:	6a 08                	push   $0x8
80109b02:	52                   	push   %edx
80109b03:	50                   	push   %eax
80109b04:	e8 ea b1 ff ff       	call   80104cf3 <memmove>
80109b09:	83 c4 10             	add    $0x10,%esp
  memmove(icmp_send->data,icmp_recv->data,48);
80109b0c:	8b 45 ec             	mov    -0x14(%ebp),%eax
80109b0f:	8d 50 10             	lea    0x10(%eax),%edx
80109b12:	8b 45 e0             	mov    -0x20(%ebp),%eax
80109b15:	83 c0 10             	add    $0x10,%eax
80109b18:	83 ec 04             	sub    $0x4,%esp
80109b1b:	6a 30                	push   $0x30
80109b1d:	52                   	push   %edx
80109b1e:	50                   	push   %eax
80109b1f:	e8 cf b1 ff ff       	call   80104cf3 <memmove>
80109b24:	83 c4 10             	add    $0x10,%esp
  icmp_send->chk_sum = 0;
80109b27:	8b 45 e0             	mov    -0x20(%ebp),%eax
80109b2a:	66 c7 40 02 00 00    	movw   $0x0,0x2(%eax)
  icmp_send->chk_sum = H2N_ushort(icmp_chksum((uint)icmp_send));
80109b30:	8b 45 e0             	mov    -0x20(%ebp),%eax
80109b33:	83 ec 0c             	sub    $0xc,%esp
80109b36:	50                   	push   %eax
80109b37:	e8 1c 00 00 00       	call   80109b58 <icmp_chksum>
80109b3c:	83 c4 10             	add    $0x10,%esp
80109b3f:	0f b7 c0             	movzwl %ax,%eax
80109b42:	83 ec 0c             	sub    $0xc,%esp
80109b45:	50                   	push   %eax
80109b46:	e8 d1 fb ff ff       	call   8010971c <H2N_ushort>
80109b4b:	83 c4 10             	add    $0x10,%esp
80109b4e:	8b 55 e0             	mov    -0x20(%ebp),%edx
80109b51:	66 89 42 02          	mov    %ax,0x2(%edx)
}
80109b55:	90                   	nop
80109b56:	c9                   	leave  
80109b57:	c3                   	ret    

80109b58 <icmp_chksum>:

ushort icmp_chksum(uint icmp_addr){
80109b58:	55                   	push   %ebp
80109b59:	89 e5                	mov    %esp,%ebp
80109b5b:	83 ec 10             	sub    $0x10,%esp
  uchar* bin = (uchar *)icmp_addr;
80109b5e:	8b 45 08             	mov    0x8(%ebp),%eax
80109b61:	89 45 f4             	mov    %eax,-0xc(%ebp)
  uint chk_sum = 0;
80109b64:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  for(int i=0;i<32;i++){
80109b6b:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
80109b72:	eb 48                	jmp    80109bbc <icmp_chksum+0x64>
    chk_sum += (bin[i*2]<<8)+bin[i*2+1];
80109b74:	8b 45 f8             	mov    -0x8(%ebp),%eax
80109b77:	01 c0                	add    %eax,%eax
80109b79:	89 c2                	mov    %eax,%edx
80109b7b:	8b 45 f4             	mov    -0xc(%ebp),%eax
80109b7e:	01 d0                	add    %edx,%eax
80109b80:	0f b6 00             	movzbl (%eax),%eax
80109b83:	0f b6 c0             	movzbl %al,%eax
80109b86:	c1 e0 08             	shl    $0x8,%eax
80109b89:	89 c2                	mov    %eax,%edx
80109b8b:	8b 45 f8             	mov    -0x8(%ebp),%eax
80109b8e:	01 c0                	add    %eax,%eax
80109b90:	8d 48 01             	lea    0x1(%eax),%ecx
80109b93:	8b 45 f4             	mov    -0xc(%ebp),%eax
80109b96:	01 c8                	add    %ecx,%eax
80109b98:	0f b6 00             	movzbl (%eax),%eax
80109b9b:	0f b6 c0             	movzbl %al,%eax
80109b9e:	01 d0                	add    %edx,%eax
80109ba0:	01 45 fc             	add    %eax,-0x4(%ebp)
    if(chk_sum > 0xFFFF){
80109ba3:	81 7d fc ff ff 00 00 	cmpl   $0xffff,-0x4(%ebp)
80109baa:	76 0c                	jbe    80109bb8 <icmp_chksum+0x60>
      chk_sum = (chk_sum&0xFFFF)+1;
80109bac:	8b 45 fc             	mov    -0x4(%ebp),%eax
80109baf:	0f b7 c0             	movzwl %ax,%eax
80109bb2:	83 c0 01             	add    $0x1,%eax
80109bb5:	89 45 fc             	mov    %eax,-0x4(%ebp)
  for(int i=0;i<32;i++){
80109bb8:	83 45 f8 01          	addl   $0x1,-0x8(%ebp)
80109bbc:	83 7d f8 1f          	cmpl   $0x1f,-0x8(%ebp)
80109bc0:	7e b2                	jle    80109b74 <icmp_chksum+0x1c>
    }
  }
  return ~(chk_sum);
80109bc2:	8b 45 fc             	mov    -0x4(%ebp),%eax
80109bc5:	f7 d0                	not    %eax
}
80109bc7:	c9                   	leave  
80109bc8:	c3                   	ret    

80109bc9 <tcp_proc>:
extern ushort send_id;
extern uchar mac_addr[6];
extern uchar my_ip[4];
int fin_flag = 0;

void tcp_proc(uint buffer_addr){
80109bc9:	55                   	push   %ebp
80109bca:	89 e5                	mov    %esp,%ebp
80109bcc:	83 ec 38             	sub    $0x38,%esp
  struct ipv4_pkt *ipv4_p = (struct ipv4_pkt *)(buffer_addr + sizeof(struct eth_pkt));
80109bcf:	8b 45 08             	mov    0x8(%ebp),%eax
80109bd2:	83 c0 0e             	add    $0xe,%eax
80109bd5:	89 45 f4             	mov    %eax,-0xc(%ebp)
  struct tcp_pkt *tcp_p = (struct tcp_pkt *)((uint)ipv4_p + (ipv4_p->ver&0xF)*4);
80109bd8:	8b 45 f4             	mov    -0xc(%ebp),%eax
80109bdb:	0f b6 00             	movzbl (%eax),%eax
80109bde:	0f b6 c0             	movzbl %al,%eax
80109be1:	83 e0 0f             	and    $0xf,%eax
80109be4:	c1 e0 02             	shl    $0x2,%eax
80109be7:	89 c2                	mov    %eax,%edx
80109be9:	8b 45 f4             	mov    -0xc(%ebp),%eax
80109bec:	01 d0                	add    %edx,%eax
80109bee:	89 45 f0             	mov    %eax,-0x10(%ebp)
  char *payload = (char *)((uint)tcp_p + 20);
80109bf1:	8b 45 f0             	mov    -0x10(%ebp),%eax
80109bf4:	83 c0 14             	add    $0x14,%eax
80109bf7:	89 45 ec             	mov    %eax,-0x14(%ebp)
  uint send_addr = (uint)kalloc();
80109bfa:	e8 a1 8b ff ff       	call   801027a0 <kalloc>
80109bff:	89 45 e8             	mov    %eax,-0x18(%ebp)
  uint send_size = 0;
80109c02:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
  if(tcp_p->code_bits[1]&TCP_CODEBITS_SYN){
80109c09:	8b 45 f0             	mov    -0x10(%ebp),%eax
80109c0c:	0f b6 40 0d          	movzbl 0xd(%eax),%eax
80109c10:	0f b6 c0             	movzbl %al,%eax
80109c13:	83 e0 02             	and    $0x2,%eax
80109c16:	85 c0                	test   %eax,%eax
80109c18:	74 3d                	je     80109c57 <tcp_proc+0x8e>
    tcp_pkt_create(buffer_addr,send_addr,&send_size,TCP_CODEBITS_ACK | TCP_CODEBITS_SYN,0);
80109c1a:	83 ec 0c             	sub    $0xc,%esp
80109c1d:	6a 00                	push   $0x0
80109c1f:	6a 12                	push   $0x12
80109c21:	8d 45 dc             	lea    -0x24(%ebp),%eax
80109c24:	50                   	push   %eax
80109c25:	ff 75 e8             	push   -0x18(%ebp)
80109c28:	ff 75 08             	push   0x8(%ebp)
80109c2b:	e8 a2 01 00 00       	call   80109dd2 <tcp_pkt_create>
80109c30:	83 c4 20             	add    $0x20,%esp
    i8254_send(send_addr,send_size);
80109c33:	8b 45 dc             	mov    -0x24(%ebp),%eax
80109c36:	83 ec 08             	sub    $0x8,%esp
80109c39:	50                   	push   %eax
80109c3a:	ff 75 e8             	push   -0x18(%ebp)
80109c3d:	e8 61 f1 ff ff       	call   80108da3 <i8254_send>
80109c42:	83 c4 10             	add    $0x10,%esp
    seq_num++;
80109c45:	a1 64 71 19 80       	mov    0x80197164,%eax
80109c4a:	83 c0 01             	add    $0x1,%eax
80109c4d:	a3 64 71 19 80       	mov    %eax,0x80197164
80109c52:	e9 69 01 00 00       	jmp    80109dc0 <tcp_proc+0x1f7>
  }else if(tcp_p->code_bits[1] == (TCP_CODEBITS_PSH | TCP_CODEBITS_ACK)){
80109c57:	8b 45 f0             	mov    -0x10(%ebp),%eax
80109c5a:	0f b6 40 0d          	movzbl 0xd(%eax),%eax
80109c5e:	3c 18                	cmp    $0x18,%al
80109c60:	0f 85 10 01 00 00    	jne    80109d76 <tcp_proc+0x1ad>
    if(memcmp(payload,"GET",3)){
80109c66:	83 ec 04             	sub    $0x4,%esp
80109c69:	6a 03                	push   $0x3
80109c6b:	68 9e c2 10 80       	push   $0x8010c29e
80109c70:	ff 75 ec             	push   -0x14(%ebp)
80109c73:	e8 23 b0 ff ff       	call   80104c9b <memcmp>
80109c78:	83 c4 10             	add    $0x10,%esp
80109c7b:	85 c0                	test   %eax,%eax
80109c7d:	74 74                	je     80109cf3 <tcp_proc+0x12a>
      cprintf("ACK PSH\n");
80109c7f:	83 ec 0c             	sub    $0xc,%esp
80109c82:	68 a2 c2 10 80       	push   $0x8010c2a2
80109c87:	e8 68 67 ff ff       	call   801003f4 <cprintf>
80109c8c:	83 c4 10             	add    $0x10,%esp
      tcp_pkt_create(buffer_addr,send_addr,&send_size,TCP_CODEBITS_ACK,0);
80109c8f:	83 ec 0c             	sub    $0xc,%esp
80109c92:	6a 00                	push   $0x0
80109c94:	6a 10                	push   $0x10
80109c96:	8d 45 dc             	lea    -0x24(%ebp),%eax
80109c99:	50                   	push   %eax
80109c9a:	ff 75 e8             	push   -0x18(%ebp)
80109c9d:	ff 75 08             	push   0x8(%ebp)
80109ca0:	e8 2d 01 00 00       	call   80109dd2 <tcp_pkt_create>
80109ca5:	83 c4 20             	add    $0x20,%esp
      i8254_send(send_addr,send_size);
80109ca8:	8b 45 dc             	mov    -0x24(%ebp),%eax
80109cab:	83 ec 08             	sub    $0x8,%esp
80109cae:	50                   	push   %eax
80109caf:	ff 75 e8             	push   -0x18(%ebp)
80109cb2:	e8 ec f0 ff ff       	call   80108da3 <i8254_send>
80109cb7:	83 c4 10             	add    $0x10,%esp
      uint send_payload = (send_addr + sizeof(struct eth_pkt) + sizeof(struct ipv4_pkt) + sizeof(struct tcp_pkt));
80109cba:	8b 45 e8             	mov    -0x18(%ebp),%eax
80109cbd:	83 c0 36             	add    $0x36,%eax
80109cc0:	89 45 e0             	mov    %eax,-0x20(%ebp)
      uint payload_size;
      http_proc(0,0,send_payload,&payload_size);
80109cc3:	8d 45 d8             	lea    -0x28(%ebp),%eax
80109cc6:	50                   	push   %eax
80109cc7:	ff 75 e0             	push   -0x20(%ebp)
80109cca:	6a 00                	push   $0x0
80109ccc:	6a 00                	push   $0x0
80109cce:	e8 5a 04 00 00       	call   8010a12d <http_proc>
80109cd3:	83 c4 10             	add    $0x10,%esp
      tcp_pkt_create(buffer_addr,send_addr,&send_size,(TCP_CODEBITS_ACK|TCP_CODEBITS_PSH),payload_size);
80109cd6:	8b 45 d8             	mov    -0x28(%ebp),%eax
80109cd9:	83 ec 0c             	sub    $0xc,%esp
80109cdc:	50                   	push   %eax
80109cdd:	6a 18                	push   $0x18
80109cdf:	8d 45 dc             	lea    -0x24(%ebp),%eax
80109ce2:	50                   	push   %eax
80109ce3:	ff 75 e8             	push   -0x18(%ebp)
80109ce6:	ff 75 08             	push   0x8(%ebp)
80109ce9:	e8 e4 00 00 00       	call   80109dd2 <tcp_pkt_create>
80109cee:	83 c4 20             	add    $0x20,%esp
80109cf1:	eb 62                	jmp    80109d55 <tcp_proc+0x18c>
    }else{
     tcp_pkt_create(buffer_addr,send_addr,&send_size,TCP_CODEBITS_ACK,0);
80109cf3:	83 ec 0c             	sub    $0xc,%esp
80109cf6:	6a 00                	push   $0x0
80109cf8:	6a 10                	push   $0x10
80109cfa:	8d 45 dc             	lea    -0x24(%ebp),%eax
80109cfd:	50                   	push   %eax
80109cfe:	ff 75 e8             	push   -0x18(%ebp)
80109d01:	ff 75 08             	push   0x8(%ebp)
80109d04:	e8 c9 00 00 00       	call   80109dd2 <tcp_pkt_create>
80109d09:	83 c4 20             	add    $0x20,%esp
     i8254_send(send_addr,send_size);
80109d0c:	8b 45 dc             	mov    -0x24(%ebp),%eax
80109d0f:	83 ec 08             	sub    $0x8,%esp
80109d12:	50                   	push   %eax
80109d13:	ff 75 e8             	push   -0x18(%ebp)
80109d16:	e8 88 f0 ff ff       	call   80108da3 <i8254_send>
80109d1b:	83 c4 10             	add    $0x10,%esp
      uint send_payload = (send_addr + sizeof(struct eth_pkt) + sizeof(struct ipv4_pkt) + sizeof(struct tcp_pkt));
80109d1e:	8b 45 e8             	mov    -0x18(%ebp),%eax
80109d21:	83 c0 36             	add    $0x36,%eax
80109d24:	89 45 e4             	mov    %eax,-0x1c(%ebp)
      uint payload_size;
      http_proc(0,0,send_payload,&payload_size);
80109d27:	8d 45 d4             	lea    -0x2c(%ebp),%eax
80109d2a:	50                   	push   %eax
80109d2b:	ff 75 e4             	push   -0x1c(%ebp)
80109d2e:	6a 00                	push   $0x0
80109d30:	6a 00                	push   $0x0
80109d32:	e8 f6 03 00 00       	call   8010a12d <http_proc>
80109d37:	83 c4 10             	add    $0x10,%esp
      tcp_pkt_create(buffer_addr,send_addr,&send_size,(TCP_CODEBITS_ACK|TCP_CODEBITS_PSH),payload_size);
80109d3a:	8b 45 d4             	mov    -0x2c(%ebp),%eax
80109d3d:	83 ec 0c             	sub    $0xc,%esp
80109d40:	50                   	push   %eax
80109d41:	6a 18                	push   $0x18
80109d43:	8d 45 dc             	lea    -0x24(%ebp),%eax
80109d46:	50                   	push   %eax
80109d47:	ff 75 e8             	push   -0x18(%ebp)
80109d4a:	ff 75 08             	push   0x8(%ebp)
80109d4d:	e8 80 00 00 00       	call   80109dd2 <tcp_pkt_create>
80109d52:	83 c4 20             	add    $0x20,%esp
    }
    i8254_send(send_addr,send_size);
80109d55:	8b 45 dc             	mov    -0x24(%ebp),%eax
80109d58:	83 ec 08             	sub    $0x8,%esp
80109d5b:	50                   	push   %eax
80109d5c:	ff 75 e8             	push   -0x18(%ebp)
80109d5f:	e8 3f f0 ff ff       	call   80108da3 <i8254_send>
80109d64:	83 c4 10             	add    $0x10,%esp
    seq_num++;
80109d67:	a1 64 71 19 80       	mov    0x80197164,%eax
80109d6c:	83 c0 01             	add    $0x1,%eax
80109d6f:	a3 64 71 19 80       	mov    %eax,0x80197164
80109d74:	eb 4a                	jmp    80109dc0 <tcp_proc+0x1f7>
  }else if(tcp_p->code_bits[1] == TCP_CODEBITS_ACK){
80109d76:	8b 45 f0             	mov    -0x10(%ebp),%eax
80109d79:	0f b6 40 0d          	movzbl 0xd(%eax),%eax
80109d7d:	3c 10                	cmp    $0x10,%al
80109d7f:	75 3f                	jne    80109dc0 <tcp_proc+0x1f7>
    if(fin_flag == 1){
80109d81:	a1 68 71 19 80       	mov    0x80197168,%eax
80109d86:	83 f8 01             	cmp    $0x1,%eax
80109d89:	75 35                	jne    80109dc0 <tcp_proc+0x1f7>
      tcp_pkt_create(buffer_addr,send_addr,&send_size,TCP_CODEBITS_FIN,0);
80109d8b:	83 ec 0c             	sub    $0xc,%esp
80109d8e:	6a 00                	push   $0x0
80109d90:	6a 01                	push   $0x1
80109d92:	8d 45 dc             	lea    -0x24(%ebp),%eax
80109d95:	50                   	push   %eax
80109d96:	ff 75 e8             	push   -0x18(%ebp)
80109d99:	ff 75 08             	push   0x8(%ebp)
80109d9c:	e8 31 00 00 00       	call   80109dd2 <tcp_pkt_create>
80109da1:	83 c4 20             	add    $0x20,%esp
      i8254_send(send_addr,send_size);
80109da4:	8b 45 dc             	mov    -0x24(%ebp),%eax
80109da7:	83 ec 08             	sub    $0x8,%esp
80109daa:	50                   	push   %eax
80109dab:	ff 75 e8             	push   -0x18(%ebp)
80109dae:	e8 f0 ef ff ff       	call   80108da3 <i8254_send>
80109db3:	83 c4 10             	add    $0x10,%esp
      fin_flag = 0;
80109db6:	c7 05 68 71 19 80 00 	movl   $0x0,0x80197168
80109dbd:	00 00 00 
    }
  }
  kfree((char *)send_addr);
80109dc0:	8b 45 e8             	mov    -0x18(%ebp),%eax
80109dc3:	83 ec 0c             	sub    $0xc,%esp
80109dc6:	50                   	push   %eax
80109dc7:	e8 3a 89 ff ff       	call   80102706 <kfree>
80109dcc:	83 c4 10             	add    $0x10,%esp
}
80109dcf:	90                   	nop
80109dd0:	c9                   	leave  
80109dd1:	c3                   	ret    

80109dd2 <tcp_pkt_create>:

void tcp_pkt_create(uint recv_addr,uint send_addr,uint *send_size,uint pkt_type,uint payload_size){
80109dd2:	55                   	push   %ebp
80109dd3:	89 e5                	mov    %esp,%ebp
80109dd5:	83 ec 28             	sub    $0x28,%esp
  struct eth_pkt *eth_recv = (struct eth_pkt *)(recv_addr);
80109dd8:	8b 45 08             	mov    0x8(%ebp),%eax
80109ddb:	89 45 f4             	mov    %eax,-0xc(%ebp)
  struct ipv4_pkt *ipv4_recv = (struct ipv4_pkt *)(recv_addr+sizeof(struct eth_pkt));
80109dde:	8b 45 08             	mov    0x8(%ebp),%eax
80109de1:	83 c0 0e             	add    $0xe,%eax
80109de4:	89 45 f0             	mov    %eax,-0x10(%ebp)
  struct tcp_pkt *tcp_recv = (struct tcp_pkt *)((uint)ipv4_recv + (ipv4_recv->ver&0xF)*4);
80109de7:	8b 45 f0             	mov    -0x10(%ebp),%eax
80109dea:	0f b6 00             	movzbl (%eax),%eax
80109ded:	0f b6 c0             	movzbl %al,%eax
80109df0:	83 e0 0f             	and    $0xf,%eax
80109df3:	c1 e0 02             	shl    $0x2,%eax
80109df6:	89 c2                	mov    %eax,%edx
80109df8:	8b 45 f0             	mov    -0x10(%ebp),%eax
80109dfb:	01 d0                	add    %edx,%eax
80109dfd:	89 45 ec             	mov    %eax,-0x14(%ebp)

  struct eth_pkt *eth_send = (struct eth_pkt *)(send_addr);
80109e00:	8b 45 0c             	mov    0xc(%ebp),%eax
80109e03:	89 45 e8             	mov    %eax,-0x18(%ebp)
  struct ipv4_pkt *ipv4_send = (struct ipv4_pkt *)(send_addr + sizeof(struct eth_pkt));
80109e06:	8b 45 0c             	mov    0xc(%ebp),%eax
80109e09:	83 c0 0e             	add    $0xe,%eax
80109e0c:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  struct tcp_pkt *tcp_send = (struct tcp_pkt *)((uint)ipv4_send + sizeof(struct ipv4_pkt));
80109e0f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80109e12:	83 c0 14             	add    $0x14,%eax
80109e15:	89 45 e0             	mov    %eax,-0x20(%ebp)

  *send_size = sizeof(struct eth_pkt) + sizeof(struct ipv4_pkt) + sizeof(struct tcp_pkt) + payload_size;
80109e18:	8b 45 18             	mov    0x18(%ebp),%eax
80109e1b:	8d 50 36             	lea    0x36(%eax),%edx
80109e1e:	8b 45 10             	mov    0x10(%ebp),%eax
80109e21:	89 10                	mov    %edx,(%eax)

  memmove(eth_send->dst_mac,eth_recv->src_mac,6);
80109e23:	8b 45 f4             	mov    -0xc(%ebp),%eax
80109e26:	8d 50 06             	lea    0x6(%eax),%edx
80109e29:	8b 45 e8             	mov    -0x18(%ebp),%eax
80109e2c:	83 ec 04             	sub    $0x4,%esp
80109e2f:	6a 06                	push   $0x6
80109e31:	52                   	push   %edx
80109e32:	50                   	push   %eax
80109e33:	e8 bb ae ff ff       	call   80104cf3 <memmove>
80109e38:	83 c4 10             	add    $0x10,%esp
  memmove(eth_send->src_mac,mac_addr,6);
80109e3b:	8b 45 e8             	mov    -0x18(%ebp),%eax
80109e3e:	83 c0 06             	add    $0x6,%eax
80109e41:	83 ec 04             	sub    $0x4,%esp
80109e44:	6a 06                	push   $0x6
80109e46:	68 80 6e 19 80       	push   $0x80196e80
80109e4b:	50                   	push   %eax
80109e4c:	e8 a2 ae ff ff       	call   80104cf3 <memmove>
80109e51:	83 c4 10             	add    $0x10,%esp
  eth_send->type[0] = 0x08;
80109e54:	8b 45 e8             	mov    -0x18(%ebp),%eax
80109e57:	c6 40 0c 08          	movb   $0x8,0xc(%eax)
  eth_send->type[1] = 0x00;
80109e5b:	8b 45 e8             	mov    -0x18(%ebp),%eax
80109e5e:	c6 40 0d 00          	movb   $0x0,0xd(%eax)

  ipv4_send->ver = ((0x4)<<4)+((sizeof(struct ipv4_pkt)/4)&0xF);
80109e62:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80109e65:	c6 00 45             	movb   $0x45,(%eax)
  ipv4_send->srv_type = 0;
80109e68:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80109e6b:	c6 40 01 00          	movb   $0x0,0x1(%eax)
  ipv4_send->total_len = H2N_ushort(sizeof(struct ipv4_pkt) + sizeof(struct tcp_pkt) + payload_size);
80109e6f:	8b 45 18             	mov    0x18(%ebp),%eax
80109e72:	83 c0 28             	add    $0x28,%eax
80109e75:	0f b7 c0             	movzwl %ax,%eax
80109e78:	83 ec 0c             	sub    $0xc,%esp
80109e7b:	50                   	push   %eax
80109e7c:	e8 9b f8 ff ff       	call   8010971c <H2N_ushort>
80109e81:	83 c4 10             	add    $0x10,%esp
80109e84:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80109e87:	66 89 42 02          	mov    %ax,0x2(%edx)
  ipv4_send->id = send_id;
80109e8b:	0f b7 15 60 71 19 80 	movzwl 0x80197160,%edx
80109e92:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80109e95:	66 89 50 04          	mov    %dx,0x4(%eax)
  send_id++;
80109e99:	0f b7 05 60 71 19 80 	movzwl 0x80197160,%eax
80109ea0:	83 c0 01             	add    $0x1,%eax
80109ea3:	66 a3 60 71 19 80    	mov    %ax,0x80197160
  ipv4_send->fragment = H2N_ushort(0x0000);
80109ea9:	83 ec 0c             	sub    $0xc,%esp
80109eac:	6a 00                	push   $0x0
80109eae:	e8 69 f8 ff ff       	call   8010971c <H2N_ushort>
80109eb3:	83 c4 10             	add    $0x10,%esp
80109eb6:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80109eb9:	66 89 42 06          	mov    %ax,0x6(%edx)
  ipv4_send->ttl = 255;
80109ebd:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80109ec0:	c6 40 08 ff          	movb   $0xff,0x8(%eax)
  ipv4_send->protocol = IPV4_TYPE_TCP;
80109ec4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80109ec7:	c6 40 09 06          	movb   $0x6,0x9(%eax)
  memmove(ipv4_send->src_ip,my_ip,4);
80109ecb:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80109ece:	83 c0 0c             	add    $0xc,%eax
80109ed1:	83 ec 04             	sub    $0x4,%esp
80109ed4:	6a 04                	push   $0x4
80109ed6:	68 04 f5 10 80       	push   $0x8010f504
80109edb:	50                   	push   %eax
80109edc:	e8 12 ae ff ff       	call   80104cf3 <memmove>
80109ee1:	83 c4 10             	add    $0x10,%esp
  memmove(ipv4_send->dst_ip,ipv4_recv->src_ip,4);
80109ee4:	8b 45 f0             	mov    -0x10(%ebp),%eax
80109ee7:	8d 50 0c             	lea    0xc(%eax),%edx
80109eea:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80109eed:	83 c0 10             	add    $0x10,%eax
80109ef0:	83 ec 04             	sub    $0x4,%esp
80109ef3:	6a 04                	push   $0x4
80109ef5:	52                   	push   %edx
80109ef6:	50                   	push   %eax
80109ef7:	e8 f7 ad ff ff       	call   80104cf3 <memmove>
80109efc:	83 c4 10             	add    $0x10,%esp
  ipv4_send->chk_sum = 0;
80109eff:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80109f02:	66 c7 40 0a 00 00    	movw   $0x0,0xa(%eax)
  ipv4_send->chk_sum = H2N_ushort(ipv4_chksum((uint)ipv4_send));
80109f08:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80109f0b:	83 ec 0c             	sub    $0xc,%esp
80109f0e:	50                   	push   %eax
80109f0f:	e8 08 f9 ff ff       	call   8010981c <ipv4_chksum>
80109f14:	83 c4 10             	add    $0x10,%esp
80109f17:	0f b7 c0             	movzwl %ax,%eax
80109f1a:	83 ec 0c             	sub    $0xc,%esp
80109f1d:	50                   	push   %eax
80109f1e:	e8 f9 f7 ff ff       	call   8010971c <H2N_ushort>
80109f23:	83 c4 10             	add    $0x10,%esp
80109f26:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80109f29:	66 89 42 0a          	mov    %ax,0xa(%edx)
  

  tcp_send->src_port = tcp_recv->dst_port;
80109f2d:	8b 45 ec             	mov    -0x14(%ebp),%eax
80109f30:	0f b7 50 02          	movzwl 0x2(%eax),%edx
80109f34:	8b 45 e0             	mov    -0x20(%ebp),%eax
80109f37:	66 89 10             	mov    %dx,(%eax)
  tcp_send->dst_port = tcp_recv->src_port;
80109f3a:	8b 45 ec             	mov    -0x14(%ebp),%eax
80109f3d:	0f b7 10             	movzwl (%eax),%edx
80109f40:	8b 45 e0             	mov    -0x20(%ebp),%eax
80109f43:	66 89 50 02          	mov    %dx,0x2(%eax)
  tcp_send->seq_num = H2N_uint(seq_num);
80109f47:	a1 64 71 19 80       	mov    0x80197164,%eax
80109f4c:	83 ec 0c             	sub    $0xc,%esp
80109f4f:	50                   	push   %eax
80109f50:	e8 e9 f7 ff ff       	call   8010973e <H2N_uint>
80109f55:	83 c4 10             	add    $0x10,%esp
80109f58:	8b 55 e0             	mov    -0x20(%ebp),%edx
80109f5b:	89 42 04             	mov    %eax,0x4(%edx)
  tcp_send->ack_num = tcp_recv->seq_num + (1<<(8*3));
80109f5e:	8b 45 ec             	mov    -0x14(%ebp),%eax
80109f61:	8b 40 04             	mov    0x4(%eax),%eax
80109f64:	8d 90 00 00 00 01    	lea    0x1000000(%eax),%edx
80109f6a:	8b 45 e0             	mov    -0x20(%ebp),%eax
80109f6d:	89 50 08             	mov    %edx,0x8(%eax)

  tcp_send->code_bits[0] = 0;
80109f70:	8b 45 e0             	mov    -0x20(%ebp),%eax
80109f73:	c6 40 0c 00          	movb   $0x0,0xc(%eax)
  tcp_send->code_bits[1] = 0;
80109f77:	8b 45 e0             	mov    -0x20(%ebp),%eax
80109f7a:	c6 40 0d 00          	movb   $0x0,0xd(%eax)
  tcp_send->code_bits[0] = 5<<4;
80109f7e:	8b 45 e0             	mov    -0x20(%ebp),%eax
80109f81:	c6 40 0c 50          	movb   $0x50,0xc(%eax)
  tcp_send->code_bits[1] = pkt_type;
80109f85:	8b 45 14             	mov    0x14(%ebp),%eax
80109f88:	89 c2                	mov    %eax,%edx
80109f8a:	8b 45 e0             	mov    -0x20(%ebp),%eax
80109f8d:	88 50 0d             	mov    %dl,0xd(%eax)

  tcp_send->window = H2N_ushort(14480);
80109f90:	83 ec 0c             	sub    $0xc,%esp
80109f93:	68 90 38 00 00       	push   $0x3890
80109f98:	e8 7f f7 ff ff       	call   8010971c <H2N_ushort>
80109f9d:	83 c4 10             	add    $0x10,%esp
80109fa0:	8b 55 e0             	mov    -0x20(%ebp),%edx
80109fa3:	66 89 42 0e          	mov    %ax,0xe(%edx)
  tcp_send->urgent_ptr = 0;
80109fa7:	8b 45 e0             	mov    -0x20(%ebp),%eax
80109faa:	66 c7 40 12 00 00    	movw   $0x0,0x12(%eax)
  tcp_send->chk_sum = 0;
80109fb0:	8b 45 e0             	mov    -0x20(%ebp),%eax
80109fb3:	66 c7 40 10 00 00    	movw   $0x0,0x10(%eax)

  tcp_send->chk_sum = H2N_ushort(tcp_chksum((uint)(ipv4_send))+8);
80109fb9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80109fbc:	83 ec 0c             	sub    $0xc,%esp
80109fbf:	50                   	push   %eax
80109fc0:	e8 1f 00 00 00       	call   80109fe4 <tcp_chksum>
80109fc5:	83 c4 10             	add    $0x10,%esp
80109fc8:	83 c0 08             	add    $0x8,%eax
80109fcb:	0f b7 c0             	movzwl %ax,%eax
80109fce:	83 ec 0c             	sub    $0xc,%esp
80109fd1:	50                   	push   %eax
80109fd2:	e8 45 f7 ff ff       	call   8010971c <H2N_ushort>
80109fd7:	83 c4 10             	add    $0x10,%esp
80109fda:	8b 55 e0             	mov    -0x20(%ebp),%edx
80109fdd:	66 89 42 10          	mov    %ax,0x10(%edx)


}
80109fe1:	90                   	nop
80109fe2:	c9                   	leave  
80109fe3:	c3                   	ret    

80109fe4 <tcp_chksum>:

ushort tcp_chksum(uint tcp_addr){
80109fe4:	55                   	push   %ebp
80109fe5:	89 e5                	mov    %esp,%ebp
80109fe7:	83 ec 38             	sub    $0x38,%esp
  struct ipv4_pkt *ipv4_p = (struct ipv4_pkt *)(tcp_addr);
80109fea:	8b 45 08             	mov    0x8(%ebp),%eax
80109fed:	89 45 e8             	mov    %eax,-0x18(%ebp)
  struct tcp_pkt *tcp_p = (struct tcp_pkt *)((uint)ipv4_p + sizeof(struct ipv4_pkt));
80109ff0:	8b 45 e8             	mov    -0x18(%ebp),%eax
80109ff3:	83 c0 14             	add    $0x14,%eax
80109ff6:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  struct tcp_dummy tcp_dummy;
  
  memmove(tcp_dummy.src_ip,my_ip,4);
80109ff9:	83 ec 04             	sub    $0x4,%esp
80109ffc:	6a 04                	push   $0x4
80109ffe:	68 04 f5 10 80       	push   $0x8010f504
8010a003:	8d 45 d4             	lea    -0x2c(%ebp),%eax
8010a006:	50                   	push   %eax
8010a007:	e8 e7 ac ff ff       	call   80104cf3 <memmove>
8010a00c:	83 c4 10             	add    $0x10,%esp
  memmove(tcp_dummy.dst_ip,ipv4_p->src_ip,4);
8010a00f:	8b 45 e8             	mov    -0x18(%ebp),%eax
8010a012:	83 c0 0c             	add    $0xc,%eax
8010a015:	83 ec 04             	sub    $0x4,%esp
8010a018:	6a 04                	push   $0x4
8010a01a:	50                   	push   %eax
8010a01b:	8d 45 d4             	lea    -0x2c(%ebp),%eax
8010a01e:	83 c0 04             	add    $0x4,%eax
8010a021:	50                   	push   %eax
8010a022:	e8 cc ac ff ff       	call   80104cf3 <memmove>
8010a027:	83 c4 10             	add    $0x10,%esp
  tcp_dummy.padding = 0;
8010a02a:	c6 45 dc 00          	movb   $0x0,-0x24(%ebp)
  tcp_dummy.protocol = IPV4_TYPE_TCP;
8010a02e:	c6 45 dd 06          	movb   $0x6,-0x23(%ebp)
  tcp_dummy.tcp_len = H2N_ushort(N2H_ushort(ipv4_p->total_len) - sizeof(struct ipv4_pkt));
8010a032:	8b 45 e8             	mov    -0x18(%ebp),%eax
8010a035:	0f b7 40 02          	movzwl 0x2(%eax),%eax
8010a039:	0f b7 c0             	movzwl %ax,%eax
8010a03c:	83 ec 0c             	sub    $0xc,%esp
8010a03f:	50                   	push   %eax
8010a040:	e8 b5 f6 ff ff       	call   801096fa <N2H_ushort>
8010a045:	83 c4 10             	add    $0x10,%esp
8010a048:	83 e8 14             	sub    $0x14,%eax
8010a04b:	0f b7 c0             	movzwl %ax,%eax
8010a04e:	83 ec 0c             	sub    $0xc,%esp
8010a051:	50                   	push   %eax
8010a052:	e8 c5 f6 ff ff       	call   8010971c <H2N_ushort>
8010a057:	83 c4 10             	add    $0x10,%esp
8010a05a:	66 89 45 de          	mov    %ax,-0x22(%ebp)
  uint chk_sum = 0;
8010a05e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  uchar *bin = (uchar *)(&tcp_dummy);
8010a065:	8d 45 d4             	lea    -0x2c(%ebp),%eax
8010a068:	89 45 e0             	mov    %eax,-0x20(%ebp)
  for(int i=0;i<6;i++){
8010a06b:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
8010a072:	eb 33                	jmp    8010a0a7 <tcp_chksum+0xc3>
    chk_sum += (bin[i*2]<<8)+bin[i*2+1];
8010a074:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010a077:	01 c0                	add    %eax,%eax
8010a079:	89 c2                	mov    %eax,%edx
8010a07b:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010a07e:	01 d0                	add    %edx,%eax
8010a080:	0f b6 00             	movzbl (%eax),%eax
8010a083:	0f b6 c0             	movzbl %al,%eax
8010a086:	c1 e0 08             	shl    $0x8,%eax
8010a089:	89 c2                	mov    %eax,%edx
8010a08b:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010a08e:	01 c0                	add    %eax,%eax
8010a090:	8d 48 01             	lea    0x1(%eax),%ecx
8010a093:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010a096:	01 c8                	add    %ecx,%eax
8010a098:	0f b6 00             	movzbl (%eax),%eax
8010a09b:	0f b6 c0             	movzbl %al,%eax
8010a09e:	01 d0                	add    %edx,%eax
8010a0a0:	01 45 f4             	add    %eax,-0xc(%ebp)
  for(int i=0;i<6;i++){
8010a0a3:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
8010a0a7:	83 7d f0 05          	cmpl   $0x5,-0x10(%ebp)
8010a0ab:	7e c7                	jle    8010a074 <tcp_chksum+0x90>
  }

  bin = (uchar *)(tcp_p);
8010a0ad:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010a0b0:	89 45 e0             	mov    %eax,-0x20(%ebp)
  for(int i=0;i<(N2H_ushort(tcp_dummy.tcp_len)/2);i++){
8010a0b3:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
8010a0ba:	eb 33                	jmp    8010a0ef <tcp_chksum+0x10b>
    chk_sum += (bin[i*2]<<8)+bin[i*2+1];
8010a0bc:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010a0bf:	01 c0                	add    %eax,%eax
8010a0c1:	89 c2                	mov    %eax,%edx
8010a0c3:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010a0c6:	01 d0                	add    %edx,%eax
8010a0c8:	0f b6 00             	movzbl (%eax),%eax
8010a0cb:	0f b6 c0             	movzbl %al,%eax
8010a0ce:	c1 e0 08             	shl    $0x8,%eax
8010a0d1:	89 c2                	mov    %eax,%edx
8010a0d3:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010a0d6:	01 c0                	add    %eax,%eax
8010a0d8:	8d 48 01             	lea    0x1(%eax),%ecx
8010a0db:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010a0de:	01 c8                	add    %ecx,%eax
8010a0e0:	0f b6 00             	movzbl (%eax),%eax
8010a0e3:	0f b6 c0             	movzbl %al,%eax
8010a0e6:	01 d0                	add    %edx,%eax
8010a0e8:	01 45 f4             	add    %eax,-0xc(%ebp)
  for(int i=0;i<(N2H_ushort(tcp_dummy.tcp_len)/2);i++){
8010a0eb:	83 45 ec 01          	addl   $0x1,-0x14(%ebp)
8010a0ef:	0f b7 45 de          	movzwl -0x22(%ebp),%eax
8010a0f3:	0f b7 c0             	movzwl %ax,%eax
8010a0f6:	83 ec 0c             	sub    $0xc,%esp
8010a0f9:	50                   	push   %eax
8010a0fa:	e8 fb f5 ff ff       	call   801096fa <N2H_ushort>
8010a0ff:	83 c4 10             	add    $0x10,%esp
8010a102:	66 d1 e8             	shr    %ax
8010a105:	0f b7 c0             	movzwl %ax,%eax
8010a108:	39 45 ec             	cmp    %eax,-0x14(%ebp)
8010a10b:	7c af                	jl     8010a0bc <tcp_chksum+0xd8>
  }
  chk_sum += (chk_sum>>8*2);
8010a10d:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010a110:	c1 e8 10             	shr    $0x10,%eax
8010a113:	01 45 f4             	add    %eax,-0xc(%ebp)
  return ~(chk_sum);
8010a116:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010a119:	f7 d0                	not    %eax
}
8010a11b:	c9                   	leave  
8010a11c:	c3                   	ret    

8010a11d <tcp_fin>:

void tcp_fin(){
8010a11d:	55                   	push   %ebp
8010a11e:	89 e5                	mov    %esp,%ebp
  fin_flag =1;
8010a120:	c7 05 68 71 19 80 01 	movl   $0x1,0x80197168
8010a127:	00 00 00 
}
8010a12a:	90                   	nop
8010a12b:	5d                   	pop    %ebp
8010a12c:	c3                   	ret    

8010a12d <http_proc>:
#include "defs.h"
#include "types.h"
#include "tcp.h"


void http_proc(uint recv, uint recv_size, uint send, uint *send_size){
8010a12d:	55                   	push   %ebp
8010a12e:	89 e5                	mov    %esp,%ebp
8010a130:	83 ec 18             	sub    $0x18,%esp
  int len;
  len = http_strcpy((char *)send,"HTTP/1.0 200 OK \r\n",0);
8010a133:	8b 45 10             	mov    0x10(%ebp),%eax
8010a136:	83 ec 04             	sub    $0x4,%esp
8010a139:	6a 00                	push   $0x0
8010a13b:	68 ab c2 10 80       	push   $0x8010c2ab
8010a140:	50                   	push   %eax
8010a141:	e8 65 00 00 00       	call   8010a1ab <http_strcpy>
8010a146:	83 c4 10             	add    $0x10,%esp
8010a149:	89 45 f4             	mov    %eax,-0xc(%ebp)
  len += http_strcpy((char *)send,"Content-Type: text/html \r\n",len);
8010a14c:	8b 45 10             	mov    0x10(%ebp),%eax
8010a14f:	83 ec 04             	sub    $0x4,%esp
8010a152:	ff 75 f4             	push   -0xc(%ebp)
8010a155:	68 be c2 10 80       	push   $0x8010c2be
8010a15a:	50                   	push   %eax
8010a15b:	e8 4b 00 00 00       	call   8010a1ab <http_strcpy>
8010a160:	83 c4 10             	add    $0x10,%esp
8010a163:	01 45 f4             	add    %eax,-0xc(%ebp)
  len += http_strcpy((char *)send,"\r\nHello World!\r\n",len);
8010a166:	8b 45 10             	mov    0x10(%ebp),%eax
8010a169:	83 ec 04             	sub    $0x4,%esp
8010a16c:	ff 75 f4             	push   -0xc(%ebp)
8010a16f:	68 d9 c2 10 80       	push   $0x8010c2d9
8010a174:	50                   	push   %eax
8010a175:	e8 31 00 00 00       	call   8010a1ab <http_strcpy>
8010a17a:	83 c4 10             	add    $0x10,%esp
8010a17d:	01 45 f4             	add    %eax,-0xc(%ebp)
  if(len%2 != 0){
8010a180:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010a183:	83 e0 01             	and    $0x1,%eax
8010a186:	85 c0                	test   %eax,%eax
8010a188:	74 11                	je     8010a19b <http_proc+0x6e>
    char *payload = (char *)send;
8010a18a:	8b 45 10             	mov    0x10(%ebp),%eax
8010a18d:	89 45 f0             	mov    %eax,-0x10(%ebp)
    payload[len] = 0;
8010a190:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010a193:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010a196:	01 d0                	add    %edx,%eax
8010a198:	c6 00 00             	movb   $0x0,(%eax)
  }
  *send_size = len;
8010a19b:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010a19e:	8b 45 14             	mov    0x14(%ebp),%eax
8010a1a1:	89 10                	mov    %edx,(%eax)
  tcp_fin();
8010a1a3:	e8 75 ff ff ff       	call   8010a11d <tcp_fin>
}
8010a1a8:	90                   	nop
8010a1a9:	c9                   	leave  
8010a1aa:	c3                   	ret    

8010a1ab <http_strcpy>:

int http_strcpy(char *dst,const char *src,int start_index){
8010a1ab:	55                   	push   %ebp
8010a1ac:	89 e5                	mov    %esp,%ebp
8010a1ae:	83 ec 10             	sub    $0x10,%esp
  int i = 0;
8010a1b1:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while(src[i]){
8010a1b8:	eb 20                	jmp    8010a1da <http_strcpy+0x2f>
    dst[start_index+i] = src[i];
8010a1ba:	8b 55 fc             	mov    -0x4(%ebp),%edx
8010a1bd:	8b 45 0c             	mov    0xc(%ebp),%eax
8010a1c0:	01 d0                	add    %edx,%eax
8010a1c2:	8b 4d 10             	mov    0x10(%ebp),%ecx
8010a1c5:	8b 55 fc             	mov    -0x4(%ebp),%edx
8010a1c8:	01 ca                	add    %ecx,%edx
8010a1ca:	89 d1                	mov    %edx,%ecx
8010a1cc:	8b 55 08             	mov    0x8(%ebp),%edx
8010a1cf:	01 ca                	add    %ecx,%edx
8010a1d1:	0f b6 00             	movzbl (%eax),%eax
8010a1d4:	88 02                	mov    %al,(%edx)
    i++;
8010a1d6:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
  while(src[i]){
8010a1da:	8b 55 fc             	mov    -0x4(%ebp),%edx
8010a1dd:	8b 45 0c             	mov    0xc(%ebp),%eax
8010a1e0:	01 d0                	add    %edx,%eax
8010a1e2:	0f b6 00             	movzbl (%eax),%eax
8010a1e5:	84 c0                	test   %al,%al
8010a1e7:	75 d1                	jne    8010a1ba <http_strcpy+0xf>
  }
  return i;
8010a1e9:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
8010a1ec:	c9                   	leave  
8010a1ed:	c3                   	ret    

8010a1ee <ideinit>:
static int disksize;
static uchar *memdisk;

void
ideinit(void)
{
8010a1ee:	55                   	push   %ebp
8010a1ef:	89 e5                	mov    %esp,%ebp
  memdisk = _binary_fs_img_start;
8010a1f1:	c7 05 70 71 19 80 c2 	movl   $0x8010f5c2,0x80197170
8010a1f8:	f5 10 80 
  disksize = (uint)_binary_fs_img_size/BSIZE;
8010a1fb:	b8 00 d0 07 00       	mov    $0x7d000,%eax
8010a200:	c1 e8 09             	shr    $0x9,%eax
8010a203:	a3 6c 71 19 80       	mov    %eax,0x8019716c
}
8010a208:	90                   	nop
8010a209:	5d                   	pop    %ebp
8010a20a:	c3                   	ret    

8010a20b <ideintr>:

// Interrupt handler.
void
ideintr(void)
{
8010a20b:	55                   	push   %ebp
8010a20c:	89 e5                	mov    %esp,%ebp
  // no-op
}
8010a20e:	90                   	nop
8010a20f:	5d                   	pop    %ebp
8010a210:	c3                   	ret    

8010a211 <iderw>:
// Sync buf with disk.
// If B_DIRTY is set, write buf to disk, clear B_DIRTY, set B_VALID.
// Else if B_VALID is not set, read buf from disk, set B_VALID.
void
iderw(struct buf *b)
{
8010a211:	55                   	push   %ebp
8010a212:	89 e5                	mov    %esp,%ebp
8010a214:	83 ec 18             	sub    $0x18,%esp
  uchar *p;

  if(!holdingsleep(&b->lock))
8010a217:	8b 45 08             	mov    0x8(%ebp),%eax
8010a21a:	83 c0 0c             	add    $0xc,%eax
8010a21d:	83 ec 0c             	sub    $0xc,%esp
8010a220:	50                   	push   %eax
8010a221:	e8 07 a7 ff ff       	call   8010492d <holdingsleep>
8010a226:	83 c4 10             	add    $0x10,%esp
8010a229:	85 c0                	test   %eax,%eax
8010a22b:	75 0d                	jne    8010a23a <iderw+0x29>
    panic("iderw: buf not locked");
8010a22d:	83 ec 0c             	sub    $0xc,%esp
8010a230:	68 ea c2 10 80       	push   $0x8010c2ea
8010a235:	e8 6f 63 ff ff       	call   801005a9 <panic>
  if((b->flags & (B_VALID|B_DIRTY)) == B_VALID)
8010a23a:	8b 45 08             	mov    0x8(%ebp),%eax
8010a23d:	8b 00                	mov    (%eax),%eax
8010a23f:	83 e0 06             	and    $0x6,%eax
8010a242:	83 f8 02             	cmp    $0x2,%eax
8010a245:	75 0d                	jne    8010a254 <iderw+0x43>
    panic("iderw: nothing to do");
8010a247:	83 ec 0c             	sub    $0xc,%esp
8010a24a:	68 00 c3 10 80       	push   $0x8010c300
8010a24f:	e8 55 63 ff ff       	call   801005a9 <panic>
  if(b->dev != 1)
8010a254:	8b 45 08             	mov    0x8(%ebp),%eax
8010a257:	8b 40 04             	mov    0x4(%eax),%eax
8010a25a:	83 f8 01             	cmp    $0x1,%eax
8010a25d:	74 0d                	je     8010a26c <iderw+0x5b>
    panic("iderw: request not for disk 1");
8010a25f:	83 ec 0c             	sub    $0xc,%esp
8010a262:	68 15 c3 10 80       	push   $0x8010c315
8010a267:	e8 3d 63 ff ff       	call   801005a9 <panic>
  if(b->blockno >= disksize)
8010a26c:	8b 45 08             	mov    0x8(%ebp),%eax
8010a26f:	8b 40 08             	mov    0x8(%eax),%eax
8010a272:	8b 15 6c 71 19 80    	mov    0x8019716c,%edx
8010a278:	39 d0                	cmp    %edx,%eax
8010a27a:	72 0d                	jb     8010a289 <iderw+0x78>
    panic("iderw: block out of range");
8010a27c:	83 ec 0c             	sub    $0xc,%esp
8010a27f:	68 33 c3 10 80       	push   $0x8010c333
8010a284:	e8 20 63 ff ff       	call   801005a9 <panic>

  p = memdisk + b->blockno*BSIZE;
8010a289:	8b 15 70 71 19 80    	mov    0x80197170,%edx
8010a28f:	8b 45 08             	mov    0x8(%ebp),%eax
8010a292:	8b 40 08             	mov    0x8(%eax),%eax
8010a295:	c1 e0 09             	shl    $0x9,%eax
8010a298:	01 d0                	add    %edx,%eax
8010a29a:	89 45 f4             	mov    %eax,-0xc(%ebp)

  if(b->flags & B_DIRTY){
8010a29d:	8b 45 08             	mov    0x8(%ebp),%eax
8010a2a0:	8b 00                	mov    (%eax),%eax
8010a2a2:	83 e0 04             	and    $0x4,%eax
8010a2a5:	85 c0                	test   %eax,%eax
8010a2a7:	74 2b                	je     8010a2d4 <iderw+0xc3>
    b->flags &= ~B_DIRTY;
8010a2a9:	8b 45 08             	mov    0x8(%ebp),%eax
8010a2ac:	8b 00                	mov    (%eax),%eax
8010a2ae:	83 e0 fb             	and    $0xfffffffb,%eax
8010a2b1:	89 c2                	mov    %eax,%edx
8010a2b3:	8b 45 08             	mov    0x8(%ebp),%eax
8010a2b6:	89 10                	mov    %edx,(%eax)
    memmove(p, b->data, BSIZE);
8010a2b8:	8b 45 08             	mov    0x8(%ebp),%eax
8010a2bb:	83 c0 5c             	add    $0x5c,%eax
8010a2be:	83 ec 04             	sub    $0x4,%esp
8010a2c1:	68 00 02 00 00       	push   $0x200
8010a2c6:	50                   	push   %eax
8010a2c7:	ff 75 f4             	push   -0xc(%ebp)
8010a2ca:	e8 24 aa ff ff       	call   80104cf3 <memmove>
8010a2cf:	83 c4 10             	add    $0x10,%esp
8010a2d2:	eb 1a                	jmp    8010a2ee <iderw+0xdd>
  } else
    memmove(b->data, p, BSIZE);
8010a2d4:	8b 45 08             	mov    0x8(%ebp),%eax
8010a2d7:	83 c0 5c             	add    $0x5c,%eax
8010a2da:	83 ec 04             	sub    $0x4,%esp
8010a2dd:	68 00 02 00 00       	push   $0x200
8010a2e2:	ff 75 f4             	push   -0xc(%ebp)
8010a2e5:	50                   	push   %eax
8010a2e6:	e8 08 aa ff ff       	call   80104cf3 <memmove>
8010a2eb:	83 c4 10             	add    $0x10,%esp
  b->flags |= B_VALID;
8010a2ee:	8b 45 08             	mov    0x8(%ebp),%eax
8010a2f1:	8b 00                	mov    (%eax),%eax
8010a2f3:	83 c8 02             	or     $0x2,%eax
8010a2f6:	89 c2                	mov    %eax,%edx
8010a2f8:	8b 45 08             	mov    0x8(%ebp),%eax
8010a2fb:	89 10                	mov    %edx,(%eax)
}
8010a2fd:	90                   	nop
8010a2fe:	c9                   	leave  
8010a2ff:	c3                   	ret    
