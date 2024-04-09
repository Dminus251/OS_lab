
kernel:     file format elf32-i386


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
8010005a:	bc b0 b0 11 80       	mov    $0x8011b0b0,%esp
8010005f:	ba 49 38 10 80       	mov    $0x80103849,%edx
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
8010006f:	68 20 a6 10 80       	push   $0x8010a620
80100074:	68 00 00 11 80       	push   $0x80110000
80100079:	e8 a8 4d 00 00       	call   80104e26 <initlock>
8010007e:	83 c4 10             	add    $0x10,%esp

//PAGEBREAK!
  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
80100081:	c7 05 4c 47 11 80 fc 	movl   $0x801146fc,0x8011474c
80100088:	46 11 80 
  bcache.head.next = &bcache.head;
8010008b:	c7 05 50 47 11 80 fc 	movl   $0x801146fc,0x80114750
80100092:	46 11 80 
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
80100095:	c7 45 f4 34 00 11 80 	movl   $0x80110034,-0xc(%ebp)
8010009c:	eb 47                	jmp    801000e5 <binit+0x7f>
    b->next = bcache.head.next;
8010009e:	8b 15 50 47 11 80    	mov    0x80114750,%edx
801000a4:	8b 45 f4             	mov    -0xc(%ebp),%eax
801000a7:	89 50 54             	mov    %edx,0x54(%eax)
    b->prev = &bcache.head;
801000aa:	8b 45 f4             	mov    -0xc(%ebp),%eax
801000ad:	c7 40 50 fc 46 11 80 	movl   $0x801146fc,0x50(%eax)
    initsleeplock(&b->lock, "buffer");
801000b4:	8b 45 f4             	mov    -0xc(%ebp),%eax
801000b7:	83 c0 0c             	add    $0xc,%eax
801000ba:	83 ec 08             	sub    $0x8,%esp
801000bd:	68 27 a6 10 80       	push   $0x8010a627
801000c2:	50                   	push   %eax
801000c3:	e8 01 4c 00 00       	call   80104cc9 <initsleeplock>
801000c8:	83 c4 10             	add    $0x10,%esp
    bcache.head.next->prev = b;
801000cb:	a1 50 47 11 80       	mov    0x80114750,%eax
801000d0:	8b 55 f4             	mov    -0xc(%ebp),%edx
801000d3:	89 50 50             	mov    %edx,0x50(%eax)
    bcache.head.next = b;
801000d6:	8b 45 f4             	mov    -0xc(%ebp),%eax
801000d9:	a3 50 47 11 80       	mov    %eax,0x80114750
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
801000de:	81 45 f4 5c 02 00 00 	addl   $0x25c,-0xc(%ebp)
801000e5:	b8 fc 46 11 80       	mov    $0x801146fc,%eax
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
801000fc:	68 00 00 11 80       	push   $0x80110000
80100101:	e8 42 4d 00 00       	call   80104e48 <acquire>
80100106:	83 c4 10             	add    $0x10,%esp

  // Is the block already cached?
  for(b = bcache.head.next; b != &bcache.head; b = b->next){
80100109:	a1 50 47 11 80       	mov    0x80114750,%eax
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
8010013b:	68 00 00 11 80       	push   $0x80110000
80100140:	e8 71 4d 00 00       	call   80104eb6 <release>
80100145:	83 c4 10             	add    $0x10,%esp
      acquiresleep(&b->lock);
80100148:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010014b:	83 c0 0c             	add    $0xc,%eax
8010014e:	83 ec 0c             	sub    $0xc,%esp
80100151:	50                   	push   %eax
80100152:	e8 ae 4b 00 00       	call   80104d05 <acquiresleep>
80100157:	83 c4 10             	add    $0x10,%esp
      return b;
8010015a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010015d:	e9 9d 00 00 00       	jmp    801001ff <bget+0x10c>
  for(b = bcache.head.next; b != &bcache.head; b = b->next){
80100162:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100165:	8b 40 54             	mov    0x54(%eax),%eax
80100168:	89 45 f4             	mov    %eax,-0xc(%ebp)
8010016b:	81 7d f4 fc 46 11 80 	cmpl   $0x801146fc,-0xc(%ebp)
80100172:	75 9f                	jne    80100113 <bget+0x20>
  }

  // Not cached; recycle an unused buffer.
  // Even if refcnt==0, B_DIRTY indicates a buffer is in use
  // because log.c has modified it but not yet committed it.
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
80100174:	a1 4c 47 11 80       	mov    0x8011474c,%eax
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
801001bc:	68 00 00 11 80       	push   $0x80110000
801001c1:	e8 f0 4c 00 00       	call   80104eb6 <release>
801001c6:	83 c4 10             	add    $0x10,%esp
      acquiresleep(&b->lock);
801001c9:	8b 45 f4             	mov    -0xc(%ebp),%eax
801001cc:	83 c0 0c             	add    $0xc,%eax
801001cf:	83 ec 0c             	sub    $0xc,%esp
801001d2:	50                   	push   %eax
801001d3:	e8 2d 4b 00 00       	call   80104d05 <acquiresleep>
801001d8:	83 c4 10             	add    $0x10,%esp
      return b;
801001db:	8b 45 f4             	mov    -0xc(%ebp),%eax
801001de:	eb 1f                	jmp    801001ff <bget+0x10c>
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
801001e0:	8b 45 f4             	mov    -0xc(%ebp),%eax
801001e3:	8b 40 50             	mov    0x50(%eax),%eax
801001e6:	89 45 f4             	mov    %eax,-0xc(%ebp)
801001e9:	81 7d f4 fc 46 11 80 	cmpl   $0x801146fc,-0xc(%ebp)
801001f0:	75 8c                	jne    8010017e <bget+0x8b>
    }
  }
  panic("bget: no buffers");
801001f2:	83 ec 0c             	sub    $0xc,%esp
801001f5:	68 2e a6 10 80       	push   $0x8010a62e
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
8010022d:	e8 f9 26 00 00       	call   8010292b <iderw>
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
8010024a:	e8 68 4b 00 00       	call   80104db7 <holdingsleep>
8010024f:	83 c4 10             	add    $0x10,%esp
80100252:	85 c0                	test   %eax,%eax
80100254:	75 0d                	jne    80100263 <bwrite+0x29>
    panic("bwrite");
80100256:	83 ec 0c             	sub    $0xc,%esp
80100259:	68 3f a6 10 80       	push   $0x8010a63f
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
80100278:	e8 ae 26 00 00       	call   8010292b <iderw>
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
80100293:	e8 1f 4b 00 00       	call   80104db7 <holdingsleep>
80100298:	83 c4 10             	add    $0x10,%esp
8010029b:	85 c0                	test   %eax,%eax
8010029d:	75 0d                	jne    801002ac <brelse+0x29>
    panic("brelse");
8010029f:	83 ec 0c             	sub    $0xc,%esp
801002a2:	68 46 a6 10 80       	push   $0x8010a646
801002a7:	e8 fd 02 00 00       	call   801005a9 <panic>

  releasesleep(&b->lock);
801002ac:	8b 45 08             	mov    0x8(%ebp),%eax
801002af:	83 c0 0c             	add    $0xc,%eax
801002b2:	83 ec 0c             	sub    $0xc,%esp
801002b5:	50                   	push   %eax
801002b6:	e8 ae 4a 00 00       	call   80104d69 <releasesleep>
801002bb:	83 c4 10             	add    $0x10,%esp

  acquire(&bcache.lock);
801002be:	83 ec 0c             	sub    $0xc,%esp
801002c1:	68 00 00 11 80       	push   $0x80110000
801002c6:	e8 7d 4b 00 00       	call   80104e48 <acquire>
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
80100305:	8b 15 50 47 11 80    	mov    0x80114750,%edx
8010030b:	8b 45 08             	mov    0x8(%ebp),%eax
8010030e:	89 50 54             	mov    %edx,0x54(%eax)
    b->prev = &bcache.head;
80100311:	8b 45 08             	mov    0x8(%ebp),%eax
80100314:	c7 40 50 fc 46 11 80 	movl   $0x801146fc,0x50(%eax)
    bcache.head.next->prev = b;
8010031b:	a1 50 47 11 80       	mov    0x80114750,%eax
80100320:	8b 55 08             	mov    0x8(%ebp),%edx
80100323:	89 50 50             	mov    %edx,0x50(%eax)
    bcache.head.next = b;
80100326:	8b 45 08             	mov    0x8(%ebp),%eax
80100329:	a3 50 47 11 80       	mov    %eax,0x80114750
  }
  
  release(&bcache.lock);
8010032e:	83 ec 0c             	sub    $0xc,%esp
80100331:	68 00 00 11 80       	push   $0x80110000
80100336:	e8 7b 4b 00 00       	call   80104eb6 <release>
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
801003fa:	a1 34 4a 11 80       	mov    0x80114a34,%eax
801003ff:	89 45 e8             	mov    %eax,-0x18(%ebp)
  if(locking)
80100402:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
80100406:	74 10                	je     80100418 <cprintf+0x24>
    acquire(&cons.lock);
80100408:	83 ec 0c             	sub    $0xc,%esp
8010040b:	68 00 4a 11 80       	push   $0x80114a00
80100410:	e8 33 4a 00 00       	call   80104e48 <acquire>
80100415:	83 c4 10             	add    $0x10,%esp

  if (fmt == 0)
80100418:	8b 45 08             	mov    0x8(%ebp),%eax
8010041b:	85 c0                	test   %eax,%eax
8010041d:	75 0d                	jne    8010042c <cprintf+0x38>
    panic("null fmt");
8010041f:	83 ec 0c             	sub    $0xc,%esp
80100422:	68 4d a6 10 80       	push   $0x8010a64d
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
80100510:	c7 45 ec 56 a6 10 80 	movl   $0x8010a656,-0x14(%ebp)
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
80100599:	68 00 4a 11 80       	push   $0x80114a00
8010059e:	e8 13 49 00 00       	call   80104eb6 <release>
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
801005b4:	c7 05 34 4a 11 80 00 	movl   $0x0,0x80114a34
801005bb:	00 00 00 
  // use lapiccpunum so that we can call panic from mycpu()
  cprintf("lapicid %d: panic: ", lapicid());
801005be:	e8 1b 2a 00 00       	call   80102fde <lapicid>
801005c3:	83 ec 08             	sub    $0x8,%esp
801005c6:	50                   	push   %eax
801005c7:	68 5d a6 10 80       	push   $0x8010a65d
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
801005e6:	68 71 a6 10 80       	push   $0x8010a671
801005eb:	e8 04 fe ff ff       	call   801003f4 <cprintf>
801005f0:	83 c4 10             	add    $0x10,%esp
  getcallerpcs(&s, pcs);
801005f3:	83 ec 08             	sub    $0x8,%esp
801005f6:	8d 45 cc             	lea    -0x34(%ebp),%eax
801005f9:	50                   	push   %eax
801005fa:	8d 45 08             	lea    0x8(%ebp),%eax
801005fd:	50                   	push   %eax
801005fe:	e8 05 49 00 00       	call   80104f08 <getcallerpcs>
80100603:	83 c4 10             	add    $0x10,%esp
  for(i=0; i<10; i++)
80100606:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
8010060d:	eb 1c                	jmp    8010062b <panic+0x82>
    cprintf(" %p", pcs[i]);
8010060f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100612:	8b 44 85 cc          	mov    -0x34(%ebp,%eax,4),%eax
80100616:	83 ec 08             	sub    $0x8,%esp
80100619:	50                   	push   %eax
8010061a:	68 73 a6 10 80       	push   $0x8010a673
8010061f:	e8 d0 fd ff ff       	call   801003f4 <cprintf>
80100624:	83 c4 10             	add    $0x10,%esp
  for(i=0; i<10; i++)
80100627:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
8010062b:	83 7d f4 09          	cmpl   $0x9,-0xc(%ebp)
8010062f:	7e de                	jle    8010060f <panic+0x66>
  panicked = 1; // freeze other CPU
80100631:	c7 05 ec 49 11 80 01 	movl   $0x1,0x801149ec
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
801006a0:	e8 e9 7e 00 00       	call   8010858e <graphic_scroll_up>
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
801006f3:	e8 96 7e 00 00       	call   8010858e <graphic_scroll_up>
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
80100757:	e8 9d 7e 00 00       	call   801085f9 <font_render>
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
80100775:	a1 ec 49 11 80       	mov    0x801149ec,%eax
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
80100793:	e8 6d 62 00 00       	call   80106a05 <uartputc>
80100798:	83 c4 10             	add    $0x10,%esp
8010079b:	83 ec 0c             	sub    $0xc,%esp
8010079e:	6a 20                	push   $0x20
801007a0:	e8 60 62 00 00       	call   80106a05 <uartputc>
801007a5:	83 c4 10             	add    $0x10,%esp
801007a8:	83 ec 0c             	sub    $0xc,%esp
801007ab:	6a 08                	push   $0x8
801007ad:	e8 53 62 00 00       	call   80106a05 <uartputc>
801007b2:	83 c4 10             	add    $0x10,%esp
801007b5:	eb 0e                	jmp    801007c5 <consputc+0x56>
  } else {
    uartputc(c);
801007b7:	83 ec 0c             	sub    $0xc,%esp
801007ba:	ff 75 08             	push   0x8(%ebp)
801007bd:	e8 43 62 00 00       	call   80106a05 <uartputc>
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
801007e6:	68 00 4a 11 80       	push   $0x80114a00
801007eb:	e8 58 46 00 00       	call   80104e48 <acquire>
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
80100838:	a1 e8 49 11 80       	mov    0x801149e8,%eax
8010083d:	83 e8 01             	sub    $0x1,%eax
80100840:	a3 e8 49 11 80       	mov    %eax,0x801149e8
        consputc(BACKSPACE);
80100845:	83 ec 0c             	sub    $0xc,%esp
80100848:	68 00 01 00 00       	push   $0x100
8010084d:	e8 1d ff ff ff       	call   8010076f <consputc>
80100852:	83 c4 10             	add    $0x10,%esp
      while(input.e != input.w &&
80100855:	8b 15 e8 49 11 80    	mov    0x801149e8,%edx
8010085b:	a1 e4 49 11 80       	mov    0x801149e4,%eax
80100860:	39 c2                	cmp    %eax,%edx
80100862:	0f 84 e0 00 00 00    	je     80100948 <consoleintr+0x172>
            input.buf[(input.e-1) % INPUT_BUF] != '\n'){
80100868:	a1 e8 49 11 80       	mov    0x801149e8,%eax
8010086d:	83 e8 01             	sub    $0x1,%eax
80100870:	83 e0 7f             	and    $0x7f,%eax
80100873:	0f b6 80 60 49 11 80 	movzbl -0x7feeb6a0(%eax),%eax
      while(input.e != input.w &&
8010087a:	3c 0a                	cmp    $0xa,%al
8010087c:	75 ba                	jne    80100838 <consoleintr+0x62>
      }
      break;
8010087e:	e9 c5 00 00 00       	jmp    80100948 <consoleintr+0x172>
    case C('H'): case '\x7f':  // Backspace
      if(input.e != input.w){
80100883:	8b 15 e8 49 11 80    	mov    0x801149e8,%edx
80100889:	a1 e4 49 11 80       	mov    0x801149e4,%eax
8010088e:	39 c2                	cmp    %eax,%edx
80100890:	0f 84 b2 00 00 00    	je     80100948 <consoleintr+0x172>
        input.e--;
80100896:	a1 e8 49 11 80       	mov    0x801149e8,%eax
8010089b:	83 e8 01             	sub    $0x1,%eax
8010089e:	a3 e8 49 11 80       	mov    %eax,0x801149e8
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
801008c2:	a1 e8 49 11 80       	mov    0x801149e8,%eax
801008c7:	8b 15 e0 49 11 80    	mov    0x801149e0,%edx
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
801008e7:	a1 e8 49 11 80       	mov    0x801149e8,%eax
801008ec:	8d 50 01             	lea    0x1(%eax),%edx
801008ef:	89 15 e8 49 11 80    	mov    %edx,0x801149e8
801008f5:	83 e0 7f             	and    $0x7f,%eax
801008f8:	8b 55 f0             	mov    -0x10(%ebp),%edx
801008fb:	88 90 60 49 11 80    	mov    %dl,-0x7feeb6a0(%eax)
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
8010091b:	a1 e8 49 11 80       	mov    0x801149e8,%eax
80100920:	8b 15 e0 49 11 80    	mov    0x801149e0,%edx
80100926:	83 ea 80             	sub    $0xffffff80,%edx
80100929:	39 d0                	cmp    %edx,%eax
8010092b:	75 1a                	jne    80100947 <consoleintr+0x171>
          input.w = input.e;
8010092d:	a1 e8 49 11 80       	mov    0x801149e8,%eax
80100932:	a3 e4 49 11 80       	mov    %eax,0x801149e4
          wakeup(&input.r);
80100937:	83 ec 0c             	sub    $0xc,%esp
8010093a:	68 e0 49 11 80       	push   $0x801149e0
8010093f:	e8 d0 41 00 00       	call   80104b14 <wakeup>
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
8010095d:	68 00 4a 11 80       	push   $0x80114a00
80100962:	e8 4f 45 00 00       	call   80104eb6 <release>
80100967:	83 c4 10             	add    $0x10,%esp
  if(doprocdump) {
8010096a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
8010096e:	74 05                	je     80100975 <consoleintr+0x19f>
    procdump();  // now call procdump() wo. cons.lock held
80100970:	e8 5a 42 00 00       	call   80104bcf <procdump>
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
80100995:	68 00 4a 11 80       	push   $0x80114a00
8010099a:	e8 a9 44 00 00       	call   80104e48 <acquire>
8010099f:	83 c4 10             	add    $0x10,%esp
  while(n > 0){
801009a2:	e9 ab 00 00 00       	jmp    80100a52 <consoleread+0xda>
    while(input.r == input.w){
      if(myproc()->killed){
801009a7:	e8 68 35 00 00       	call   80103f14 <myproc>
801009ac:	8b 40 24             	mov    0x24(%eax),%eax
801009af:	85 c0                	test   %eax,%eax
801009b1:	74 28                	je     801009db <consoleread+0x63>
        release(&cons.lock);
801009b3:	83 ec 0c             	sub    $0xc,%esp
801009b6:	68 00 4a 11 80       	push   $0x80114a00
801009bb:	e8 f6 44 00 00       	call   80104eb6 <release>
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
801009de:	68 00 4a 11 80       	push   $0x80114a00
801009e3:	68 e0 49 11 80       	push   $0x801149e0
801009e8:	e8 40 40 00 00       	call   80104a2d <sleep>
801009ed:	83 c4 10             	add    $0x10,%esp
    while(input.r == input.w){
801009f0:	8b 15 e0 49 11 80    	mov    0x801149e0,%edx
801009f6:	a1 e4 49 11 80       	mov    0x801149e4,%eax
801009fb:	39 c2                	cmp    %eax,%edx
801009fd:	74 a8                	je     801009a7 <consoleread+0x2f>
    }
    c = input.buf[input.r++ % INPUT_BUF];
801009ff:	a1 e0 49 11 80       	mov    0x801149e0,%eax
80100a04:	8d 50 01             	lea    0x1(%eax),%edx
80100a07:	89 15 e0 49 11 80    	mov    %edx,0x801149e0
80100a0d:	83 e0 7f             	and    $0x7f,%eax
80100a10:	0f b6 80 60 49 11 80 	movzbl -0x7feeb6a0(%eax),%eax
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
80100a2b:	a1 e0 49 11 80       	mov    0x801149e0,%eax
80100a30:	83 e8 01             	sub    $0x1,%eax
80100a33:	a3 e0 49 11 80       	mov    %eax,0x801149e0
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
80100a61:	68 00 4a 11 80       	push   $0x80114a00
80100a66:	e8 4b 44 00 00       	call   80104eb6 <release>
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
80100a9d:	68 00 4a 11 80       	push   $0x80114a00
80100aa2:	e8 a1 43 00 00       	call   80104e48 <acquire>
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
80100adf:	68 00 4a 11 80       	push   $0x80114a00
80100ae4:	e8 cd 43 00 00       	call   80104eb6 <release>
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
80100b05:	c7 05 ec 49 11 80 00 	movl   $0x0,0x801149ec
80100b0c:	00 00 00 
  initlock(&cons.lock, "console");
80100b0f:	83 ec 08             	sub    $0x8,%esp
80100b12:	68 77 a6 10 80       	push   $0x8010a677
80100b17:	68 00 4a 11 80       	push   $0x80114a00
80100b1c:	e8 05 43 00 00       	call   80104e26 <initlock>
80100b21:	83 c4 10             	add    $0x10,%esp

  devsw[CONSOLE].write = consolewrite;
80100b24:	c7 05 4c 4a 11 80 86 	movl   $0x80100a86,0x80114a4c
80100b2b:	0a 10 80 
  devsw[CONSOLE].read = consoleread;
80100b2e:	c7 05 48 4a 11 80 78 	movl   $0x80100978,0x80114a48
80100b35:	09 10 80 
  
  char *p;
  for(p="Starting XV6_UEFI...\n"; *p; p++)
80100b38:	c7 45 f4 7f a6 10 80 	movl   $0x8010a67f,-0xc(%ebp)
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
80100b64:	c7 05 34 4a 11 80 01 	movl   $0x1,0x80114a34
80100b6b:	00 00 00 

  ioapicenable(IRQ_KBD, 0);
80100b6e:	83 ec 08             	sub    $0x8,%esp
80100b71:	6a 00                	push   $0x0
80100b73:	6a 01                	push   $0x1
80100b75:	e8 98 1f 00 00       	call   80102b12 <ioapicenable>
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
80100b89:	e8 86 33 00 00       	call   80103f14 <myproc>
80100b8e:	89 45 d0             	mov    %eax,-0x30(%ebp)

  begin_op();
80100b91:	e8 8a 29 00 00       	call   80103520 <begin_op>

  if((ip = namei(path)) == 0){
80100b96:	83 ec 0c             	sub    $0xc,%esp
80100b99:	ff 75 08             	push   0x8(%ebp)
80100b9c:	e8 7c 19 00 00       	call   8010251d <namei>
80100ba1:	83 c4 10             	add    $0x10,%esp
80100ba4:	89 45 d8             	mov    %eax,-0x28(%ebp)
80100ba7:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
80100bab:	75 1f                	jne    80100bcc <exec+0x4c>
    end_op();
80100bad:	e8 fa 29 00 00       	call   801035ac <end_op>
    cprintf("exec: fail\n");
80100bb2:	83 ec 0c             	sub    $0xc,%esp
80100bb5:	68 95 a6 10 80       	push   $0x8010a695
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
80100c11:	e8 eb 6d 00 00       	call   80107a01 <setupkvm>
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
80100cb7:	e8 3e 71 00 00       	call   80107dfa <allocuvm>
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
80100cfd:	e8 2b 70 00 00       	call   80107d2d <loaduvm>
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
80100d3e:	e8 69 28 00 00       	call   801035ac <end_op>
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
80100d6c:	e8 89 70 00 00       	call   80107dfa <allocuvm>
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
80100d90:	e8 c7 72 00 00       	call   8010805c <clearpteu>
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
80100dc9:	e8 3e 45 00 00       	call   8010530c <strlen>
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
80100df6:	e8 11 45 00 00       	call   8010530c <strlen>
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
80100e1c:	e8 da 73 00 00       	call   801081fb <copyout>
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
80100eb8:	e8 3e 73 00 00       	call   801081fb <copyout>
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
80100f06:	e8 b6 43 00 00       	call   801052c1 <safestrcpy>
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
80100f49:	e8 d0 6b 00 00       	call   80107b1e <switchuvm>
80100f4e:	83 c4 10             	add    $0x10,%esp
  freevm(oldpgdir);
80100f51:	83 ec 0c             	sub    $0xc,%esp
80100f54:	ff 75 cc             	push   -0x34(%ebp)
80100f57:	e8 67 70 00 00       	call   80107fc3 <freevm>
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
80100f97:	e8 27 70 00 00       	call   80107fc3 <freevm>
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
80100fb3:	e8 f4 25 00 00       	call   801035ac <end_op>
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
80100fc8:	68 a1 a6 10 80       	push   $0x8010a6a1
80100fcd:	68 a0 4a 11 80       	push   $0x80114aa0
80100fd2:	e8 4f 3e 00 00       	call   80104e26 <initlock>
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
80100fe6:	68 a0 4a 11 80       	push   $0x80114aa0
80100feb:	e8 58 3e 00 00       	call   80104e48 <acquire>
80100ff0:	83 c4 10             	add    $0x10,%esp
  for(f = ftable.file; f < ftable.file + NFILE; f++){
80100ff3:	c7 45 f4 d4 4a 11 80 	movl   $0x80114ad4,-0xc(%ebp)
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
80101013:	68 a0 4a 11 80       	push   $0x80114aa0
80101018:	e8 99 3e 00 00       	call   80104eb6 <release>
8010101d:	83 c4 10             	add    $0x10,%esp
      return f;
80101020:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101023:	eb 23                	jmp    80101048 <filealloc+0x6b>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
80101025:	83 45 f4 18          	addl   $0x18,-0xc(%ebp)
80101029:	b8 34 54 11 80       	mov    $0x80115434,%eax
8010102e:	39 45 f4             	cmp    %eax,-0xc(%ebp)
80101031:	72 c9                	jb     80100ffc <filealloc+0x1f>
    }
  }
  release(&ftable.lock);
80101033:	83 ec 0c             	sub    $0xc,%esp
80101036:	68 a0 4a 11 80       	push   $0x80114aa0
8010103b:	e8 76 3e 00 00       	call   80104eb6 <release>
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
80101053:	68 a0 4a 11 80       	push   $0x80114aa0
80101058:	e8 eb 3d 00 00       	call   80104e48 <acquire>
8010105d:	83 c4 10             	add    $0x10,%esp
  if(f->ref < 1)
80101060:	8b 45 08             	mov    0x8(%ebp),%eax
80101063:	8b 40 04             	mov    0x4(%eax),%eax
80101066:	85 c0                	test   %eax,%eax
80101068:	7f 0d                	jg     80101077 <filedup+0x2d>
    panic("filedup");
8010106a:	83 ec 0c             	sub    $0xc,%esp
8010106d:	68 a8 a6 10 80       	push   $0x8010a6a8
80101072:	e8 32 f5 ff ff       	call   801005a9 <panic>
  f->ref++;
80101077:	8b 45 08             	mov    0x8(%ebp),%eax
8010107a:	8b 40 04             	mov    0x4(%eax),%eax
8010107d:	8d 50 01             	lea    0x1(%eax),%edx
80101080:	8b 45 08             	mov    0x8(%ebp),%eax
80101083:	89 50 04             	mov    %edx,0x4(%eax)
  release(&ftable.lock);
80101086:	83 ec 0c             	sub    $0xc,%esp
80101089:	68 a0 4a 11 80       	push   $0x80114aa0
8010108e:	e8 23 3e 00 00       	call   80104eb6 <release>
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
801010a4:	68 a0 4a 11 80       	push   $0x80114aa0
801010a9:	e8 9a 3d 00 00       	call   80104e48 <acquire>
801010ae:	83 c4 10             	add    $0x10,%esp
  if(f->ref < 1)
801010b1:	8b 45 08             	mov    0x8(%ebp),%eax
801010b4:	8b 40 04             	mov    0x4(%eax),%eax
801010b7:	85 c0                	test   %eax,%eax
801010b9:	7f 0d                	jg     801010c8 <fileclose+0x2d>
    panic("fileclose");
801010bb:	83 ec 0c             	sub    $0xc,%esp
801010be:	68 b0 a6 10 80       	push   $0x8010a6b0
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
801010e4:	68 a0 4a 11 80       	push   $0x80114aa0
801010e9:	e8 c8 3d 00 00       	call   80104eb6 <release>
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
80101132:	68 a0 4a 11 80       	push   $0x80114aa0
80101137:	e8 7a 3d 00 00       	call   80104eb6 <release>
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
80101156:	e8 48 2a 00 00       	call   80103ba3 <pipeclose>
8010115b:	83 c4 10             	add    $0x10,%esp
8010115e:	eb 21                	jmp    80101181 <fileclose+0xe6>
  else if(ff.type == FD_INODE){
80101160:	8b 45 e0             	mov    -0x20(%ebp),%eax
80101163:	83 f8 02             	cmp    $0x2,%eax
80101166:	75 19                	jne    80101181 <fileclose+0xe6>
    begin_op();
80101168:	e8 b3 23 00 00       	call   80103520 <begin_op>
    iput(ff.ip);
8010116d:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101170:	83 ec 0c             	sub    $0xc,%esp
80101173:	50                   	push   %eax
80101174:	e8 d2 09 00 00       	call   80101b4b <iput>
80101179:	83 c4 10             	add    $0x10,%esp
    end_op();
8010117c:	e8 2b 24 00 00       	call   801035ac <end_op>
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
8010120f:	e8 3c 2b 00 00       	call   80103d50 <piperead>
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
80101286:	68 ba a6 10 80       	push   $0x8010a6ba
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
801012c8:	e8 81 29 00 00       	call   80103c4e <pipewrite>
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
8010130d:	e8 0e 22 00 00       	call   80103520 <begin_op>
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
80101373:	e8 34 22 00 00       	call   801035ac <end_op>

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
80101389:	68 c3 a6 10 80       	push   $0x8010a6c3
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
801013bf:	68 d3 a6 10 80       	push   $0x8010a6d3
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
801013f7:	e8 81 3d 00 00       	call   8010517d <memmove>
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
8010143d:	e8 7c 3c 00 00       	call   801050be <memset>
80101442:	83 c4 10             	add    $0x10,%esp
  log_write(bp);
80101445:	83 ec 0c             	sub    $0xc,%esp
80101448:	ff 75 f4             	push   -0xc(%ebp)
8010144b:	e8 09 23 00 00       	call   80103759 <log_write>
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
80101490:	a1 58 54 11 80       	mov    0x80115458,%eax
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
80101517:	e8 3d 22 00 00       	call   80103759 <log_write>
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
80101566:	a1 40 54 11 80       	mov    0x80115440,%eax
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
80101588:	8b 15 40 54 11 80    	mov    0x80115440,%edx
8010158e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101591:	39 c2                	cmp    %eax,%edx
80101593:	0f 87 e4 fe ff ff    	ja     8010147d <balloc+0x19>
  }
  panic("balloc: out of blocks");
80101599:	83 ec 0c             	sub    $0xc,%esp
8010159c:	68 e0 a6 10 80       	push   $0x8010a6e0
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
801015b1:	68 40 54 11 80       	push   $0x80115440
801015b6:	ff 75 08             	push   0x8(%ebp)
801015b9:	e8 10 fe ff ff       	call   801013ce <readsb>
801015be:	83 c4 10             	add    $0x10,%esp
  bp = bread(dev, BBLOCK(b, sb));
801015c1:	8b 45 0c             	mov    0xc(%ebp),%eax
801015c4:	c1 e8 0c             	shr    $0xc,%eax
801015c7:	89 c2                	mov    %eax,%edx
801015c9:	a1 58 54 11 80       	mov    0x80115458,%eax
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
80101627:	68 f6 a6 10 80       	push   $0x8010a6f6
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
8010165f:	e8 f5 20 00 00       	call   80103759 <log_write>
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
8010168b:	68 09 a7 10 80       	push   $0x8010a709
80101690:	68 60 54 11 80       	push   $0x80115460
80101695:	e8 8c 37 00 00       	call   80104e26 <initlock>
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
801016b6:	05 60 54 11 80       	add    $0x80115460,%eax
801016bb:	83 c0 10             	add    $0x10,%eax
801016be:	83 ec 08             	sub    $0x8,%esp
801016c1:	68 10 a7 10 80       	push   $0x8010a710
801016c6:	50                   	push   %eax
801016c7:	e8 fd 35 00 00       	call   80104cc9 <initsleeplock>
801016cc:	83 c4 10             	add    $0x10,%esp
  for(i = 0; i < NINODE; i++) {
801016cf:	83 45 e4 01          	addl   $0x1,-0x1c(%ebp)
801016d3:	83 7d e4 31          	cmpl   $0x31,-0x1c(%ebp)
801016d7:	7e cd                	jle    801016a6 <iinit+0x2e>
  }

  readsb(dev, &sb);
801016d9:	83 ec 08             	sub    $0x8,%esp
801016dc:	68 40 54 11 80       	push   $0x80115440
801016e1:	ff 75 08             	push   0x8(%ebp)
801016e4:	e8 e5 fc ff ff       	call   801013ce <readsb>
801016e9:	83 c4 10             	add    $0x10,%esp
  cprintf("sb: size %d nblocks %d ninodes %d nlog %d logstart %d\
801016ec:	a1 58 54 11 80       	mov    0x80115458,%eax
801016f1:	89 45 d4             	mov    %eax,-0x2c(%ebp)
801016f4:	8b 3d 54 54 11 80    	mov    0x80115454,%edi
801016fa:	8b 35 50 54 11 80    	mov    0x80115450,%esi
80101700:	8b 1d 4c 54 11 80    	mov    0x8011544c,%ebx
80101706:	8b 0d 48 54 11 80    	mov    0x80115448,%ecx
8010170c:	8b 15 44 54 11 80    	mov    0x80115444,%edx
80101712:	a1 40 54 11 80       	mov    0x80115440,%eax
80101717:	ff 75 d4             	push   -0x2c(%ebp)
8010171a:	57                   	push   %edi
8010171b:	56                   	push   %esi
8010171c:	53                   	push   %ebx
8010171d:	51                   	push   %ecx
8010171e:	52                   	push   %edx
8010171f:	50                   	push   %eax
80101720:	68 18 a7 10 80       	push   $0x8010a718
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
80101757:	a1 54 54 11 80       	mov    0x80115454,%eax
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
80101799:	e8 20 39 00 00       	call   801050be <memset>
8010179e:	83 c4 10             	add    $0x10,%esp
      dip->type = type;
801017a1:	8b 45 ec             	mov    -0x14(%ebp),%eax
801017a4:	0f b7 55 e4          	movzwl -0x1c(%ebp),%edx
801017a8:	66 89 10             	mov    %dx,(%eax)
      log_write(bp);   // mark it allocated on the disk
801017ab:	83 ec 0c             	sub    $0xc,%esp
801017ae:	ff 75 f0             	push   -0x10(%ebp)
801017b1:	e8 a3 1f 00 00       	call   80103759 <log_write>
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
801017ed:	8b 15 48 54 11 80    	mov    0x80115448,%edx
801017f3:	8b 45 f4             	mov    -0xc(%ebp),%eax
801017f6:	39 c2                	cmp    %eax,%edx
801017f8:	0f 87 51 ff ff ff    	ja     8010174f <ialloc+0x19>
  }
  panic("ialloc: no inodes");
801017fe:	83 ec 0c             	sub    $0xc,%esp
80101801:	68 6b a7 10 80       	push   $0x8010a76b
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
8010181e:	a1 54 54 11 80       	mov    0x80115454,%eax
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
801018a7:	e8 d1 38 00 00       	call   8010517d <memmove>
801018ac:	83 c4 10             	add    $0x10,%esp
  log_write(bp);
801018af:	83 ec 0c             	sub    $0xc,%esp
801018b2:	ff 75 f4             	push   -0xc(%ebp)
801018b5:	e8 9f 1e 00 00       	call   80103759 <log_write>
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
801018d7:	68 60 54 11 80       	push   $0x80115460
801018dc:	e8 67 35 00 00       	call   80104e48 <acquire>
801018e1:	83 c4 10             	add    $0x10,%esp

  // Is the inode already cached?
  empty = 0;
801018e4:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
801018eb:	c7 45 f4 94 54 11 80 	movl   $0x80115494,-0xc(%ebp)
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
80101925:	68 60 54 11 80       	push   $0x80115460
8010192a:	e8 87 35 00 00       	call   80104eb6 <release>
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
80101954:	81 7d f4 b4 70 11 80 	cmpl   $0x801170b4,-0xc(%ebp)
8010195b:	72 97                	jb     801018f4 <iget+0x26>
  }

  // Recycle an inode cache entry.
  if(empty == 0)
8010195d:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80101961:	75 0d                	jne    80101970 <iget+0xa2>
    panic("iget: no inodes");
80101963:	83 ec 0c             	sub    $0xc,%esp
80101966:	68 7d a7 10 80       	push   $0x8010a77d
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
8010199e:	68 60 54 11 80       	push   $0x80115460
801019a3:	e8 0e 35 00 00       	call   80104eb6 <release>
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
801019b9:	68 60 54 11 80       	push   $0x80115460
801019be:	e8 85 34 00 00       	call   80104e48 <acquire>
801019c3:	83 c4 10             	add    $0x10,%esp
  ip->ref++;
801019c6:	8b 45 08             	mov    0x8(%ebp),%eax
801019c9:	8b 40 08             	mov    0x8(%eax),%eax
801019cc:	8d 50 01             	lea    0x1(%eax),%edx
801019cf:	8b 45 08             	mov    0x8(%ebp),%eax
801019d2:	89 50 08             	mov    %edx,0x8(%eax)
  release(&icache.lock);
801019d5:	83 ec 0c             	sub    $0xc,%esp
801019d8:	68 60 54 11 80       	push   $0x80115460
801019dd:	e8 d4 34 00 00       	call   80104eb6 <release>
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
80101a03:	68 8d a7 10 80       	push   $0x8010a78d
80101a08:	e8 9c eb ff ff       	call   801005a9 <panic>

  acquiresleep(&ip->lock);
80101a0d:	8b 45 08             	mov    0x8(%ebp),%eax
80101a10:	83 c0 0c             	add    $0xc,%eax
80101a13:	83 ec 0c             	sub    $0xc,%esp
80101a16:	50                   	push   %eax
80101a17:	e8 e9 32 00 00       	call   80104d05 <acquiresleep>
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
80101a38:	a1 54 54 11 80       	mov    0x80115454,%eax
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
80101ac1:	e8 b7 36 00 00       	call   8010517d <memmove>
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
80101af0:	68 93 a7 10 80       	push   $0x8010a793
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
80101b13:	e8 9f 32 00 00       	call   80104db7 <holdingsleep>
80101b18:	83 c4 10             	add    $0x10,%esp
80101b1b:	85 c0                	test   %eax,%eax
80101b1d:	74 0a                	je     80101b29 <iunlock+0x2c>
80101b1f:	8b 45 08             	mov    0x8(%ebp),%eax
80101b22:	8b 40 08             	mov    0x8(%eax),%eax
80101b25:	85 c0                	test   %eax,%eax
80101b27:	7f 0d                	jg     80101b36 <iunlock+0x39>
    panic("iunlock");
80101b29:	83 ec 0c             	sub    $0xc,%esp
80101b2c:	68 a2 a7 10 80       	push   $0x8010a7a2
80101b31:	e8 73 ea ff ff       	call   801005a9 <panic>

  releasesleep(&ip->lock);
80101b36:	8b 45 08             	mov    0x8(%ebp),%eax
80101b39:	83 c0 0c             	add    $0xc,%eax
80101b3c:	83 ec 0c             	sub    $0xc,%esp
80101b3f:	50                   	push   %eax
80101b40:	e8 24 32 00 00       	call   80104d69 <releasesleep>
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
80101b5b:	e8 a5 31 00 00       	call   80104d05 <acquiresleep>
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
80101b7c:	68 60 54 11 80       	push   $0x80115460
80101b81:	e8 c2 32 00 00       	call   80104e48 <acquire>
80101b86:	83 c4 10             	add    $0x10,%esp
    int r = ip->ref;
80101b89:	8b 45 08             	mov    0x8(%ebp),%eax
80101b8c:	8b 40 08             	mov    0x8(%eax),%eax
80101b8f:	89 45 f4             	mov    %eax,-0xc(%ebp)
    release(&icache.lock);
80101b92:	83 ec 0c             	sub    $0xc,%esp
80101b95:	68 60 54 11 80       	push   $0x80115460
80101b9a:	e8 17 33 00 00       	call   80104eb6 <release>
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
80101be1:	e8 83 31 00 00       	call   80104d69 <releasesleep>
80101be6:	83 c4 10             	add    $0x10,%esp

  acquire(&icache.lock);
80101be9:	83 ec 0c             	sub    $0xc,%esp
80101bec:	68 60 54 11 80       	push   $0x80115460
80101bf1:	e8 52 32 00 00       	call   80104e48 <acquire>
80101bf6:	83 c4 10             	add    $0x10,%esp
  ip->ref--;
80101bf9:	8b 45 08             	mov    0x8(%ebp),%eax
80101bfc:	8b 40 08             	mov    0x8(%eax),%eax
80101bff:	8d 50 ff             	lea    -0x1(%eax),%edx
80101c02:	8b 45 08             	mov    0x8(%ebp),%eax
80101c05:	89 50 08             	mov    %edx,0x8(%eax)
  release(&icache.lock);
80101c08:	83 ec 0c             	sub    $0xc,%esp
80101c0b:	68 60 54 11 80       	push   $0x80115460
80101c10:	e8 a1 32 00 00       	call   80104eb6 <release>
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
80101d36:	e8 1e 1a 00 00       	call   80103759 <log_write>
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
80101d54:	68 aa a7 10 80       	push   $0x8010a7aa
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
80101f0a:	8b 04 c5 40 4a 11 80 	mov    -0x7feeb5c0(,%eax,8),%eax
80101f11:	85 c0                	test   %eax,%eax
80101f13:	75 0a                	jne    80101f1f <readi+0x49>
      return -1;
80101f15:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101f1a:	e9 0a 01 00 00       	jmp    80102029 <readi+0x153>
    return devsw[ip->major].read(ip, dst, n);
80101f1f:	8b 45 08             	mov    0x8(%ebp),%eax
80101f22:	0f b7 40 52          	movzwl 0x52(%eax),%eax
80101f26:	98                   	cwtl   
80101f27:	8b 04 c5 40 4a 11 80 	mov    -0x7feeb5c0(,%eax,8),%eax
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
80101ff2:	e8 86 31 00 00       	call   8010517d <memmove>
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
8010205f:	8b 04 c5 44 4a 11 80 	mov    -0x7feeb5bc(,%eax,8),%eax
80102066:	85 c0                	test   %eax,%eax
80102068:	75 0a                	jne    80102074 <writei+0x49>
      return -1;
8010206a:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010206f:	e9 3b 01 00 00       	jmp    801021af <writei+0x184>
    return devsw[ip->major].write(ip, src, n);
80102074:	8b 45 08             	mov    0x8(%ebp),%eax
80102077:	0f b7 40 52          	movzwl 0x52(%eax),%eax
8010207b:	98                   	cwtl   
8010207c:	8b 04 c5 44 4a 11 80 	mov    -0x7feeb5bc(,%eax,8),%eax
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
80102142:	e8 36 30 00 00       	call   8010517d <memmove>
80102147:	83 c4 10             	add    $0x10,%esp
    log_write(bp);
8010214a:	83 ec 0c             	sub    $0xc,%esp
8010214d:	ff 75 f0             	push   -0x10(%ebp)
80102150:	e8 04 16 00 00       	call   80103759 <log_write>
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
801021c2:	e8 4c 30 00 00       	call   80105213 <strncmp>
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
801021e2:	68 bd a7 10 80       	push   $0x8010a7bd
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
80102211:	68 cf a7 10 80       	push   $0x8010a7cf
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
801022e6:	68 de a7 10 80       	push   $0x8010a7de
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
80102321:	e8 43 2f 00 00       	call   80105269 <strncpy>
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
8010234d:	68 eb a7 10 80       	push   $0x8010a7eb
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
801023bf:	e8 b9 2d 00 00       	call   8010517d <memmove>
801023c4:	83 c4 10             	add    $0x10,%esp
801023c7:	eb 26                	jmp    801023ef <skipelem+0x91>
  else {
    memmove(name, s, len);
801023c9:	8b 45 f0             	mov    -0x10(%ebp),%eax
801023cc:	83 ec 04             	sub    $0x4,%esp
801023cf:	50                   	push   %eax
801023d0:	ff 75 f4             	push   -0xc(%ebp)
801023d3:	ff 75 0c             	push   0xc(%ebp)
801023d6:	e8 a2 2d 00 00       	call   8010517d <memmove>
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
80102425:	e8 ea 1a 00 00       	call   80103f14 <myproc>
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

80102554 <inb>:
{
80102554:	55                   	push   %ebp
80102555:	89 e5                	mov    %esp,%ebp
80102557:	83 ec 14             	sub    $0x14,%esp
8010255a:	8b 45 08             	mov    0x8(%ebp),%eax
8010255d:	66 89 45 ec          	mov    %ax,-0x14(%ebp)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102561:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
80102565:	89 c2                	mov    %eax,%edx
80102567:	ec                   	in     (%dx),%al
80102568:	88 45 ff             	mov    %al,-0x1(%ebp)
  return data;
8010256b:	0f b6 45 ff          	movzbl -0x1(%ebp),%eax
}
8010256f:	c9                   	leave  
80102570:	c3                   	ret    

80102571 <insl>:
{
80102571:	55                   	push   %ebp
80102572:	89 e5                	mov    %esp,%ebp
80102574:	57                   	push   %edi
80102575:	53                   	push   %ebx
  asm volatile("cld; rep insl" :
80102576:	8b 55 08             	mov    0x8(%ebp),%edx
80102579:	8b 4d 0c             	mov    0xc(%ebp),%ecx
8010257c:	8b 45 10             	mov    0x10(%ebp),%eax
8010257f:	89 cb                	mov    %ecx,%ebx
80102581:	89 df                	mov    %ebx,%edi
80102583:	89 c1                	mov    %eax,%ecx
80102585:	fc                   	cld    
80102586:	f3 6d                	rep insl (%dx),%es:(%edi)
80102588:	89 c8                	mov    %ecx,%eax
8010258a:	89 fb                	mov    %edi,%ebx
8010258c:	89 5d 0c             	mov    %ebx,0xc(%ebp)
8010258f:	89 45 10             	mov    %eax,0x10(%ebp)
}
80102592:	90                   	nop
80102593:	5b                   	pop    %ebx
80102594:	5f                   	pop    %edi
80102595:	5d                   	pop    %ebp
80102596:	c3                   	ret    

80102597 <outb>:
{
80102597:	55                   	push   %ebp
80102598:	89 e5                	mov    %esp,%ebp
8010259a:	83 ec 08             	sub    $0x8,%esp
8010259d:	8b 45 08             	mov    0x8(%ebp),%eax
801025a0:	8b 55 0c             	mov    0xc(%ebp),%edx
801025a3:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
801025a7:	89 d0                	mov    %edx,%eax
801025a9:	88 45 f8             	mov    %al,-0x8(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801025ac:	0f b6 45 f8          	movzbl -0x8(%ebp),%eax
801025b0:	0f b7 55 fc          	movzwl -0x4(%ebp),%edx
801025b4:	ee                   	out    %al,(%dx)
}
801025b5:	90                   	nop
801025b6:	c9                   	leave  
801025b7:	c3                   	ret    

801025b8 <outsl>:
{
801025b8:	55                   	push   %ebp
801025b9:	89 e5                	mov    %esp,%ebp
801025bb:	56                   	push   %esi
801025bc:	53                   	push   %ebx
  asm volatile("cld; rep outsl" :
801025bd:	8b 55 08             	mov    0x8(%ebp),%edx
801025c0:	8b 4d 0c             	mov    0xc(%ebp),%ecx
801025c3:	8b 45 10             	mov    0x10(%ebp),%eax
801025c6:	89 cb                	mov    %ecx,%ebx
801025c8:	89 de                	mov    %ebx,%esi
801025ca:	89 c1                	mov    %eax,%ecx
801025cc:	fc                   	cld    
801025cd:	f3 6f                	rep outsl %ds:(%esi),(%dx)
801025cf:	89 c8                	mov    %ecx,%eax
801025d1:	89 f3                	mov    %esi,%ebx
801025d3:	89 5d 0c             	mov    %ebx,0xc(%ebp)
801025d6:	89 45 10             	mov    %eax,0x10(%ebp)
}
801025d9:	90                   	nop
801025da:	5b                   	pop    %ebx
801025db:	5e                   	pop    %esi
801025dc:	5d                   	pop    %ebp
801025dd:	c3                   	ret    

801025de <idewait>:
static void idestart(struct buf*);

// Wait for IDE disk to become ready.
static int
idewait(int checkerr)
{
801025de:	55                   	push   %ebp
801025df:	89 e5                	mov    %esp,%ebp
801025e1:	83 ec 10             	sub    $0x10,%esp
  int r;

  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
801025e4:	90                   	nop
801025e5:	68 f7 01 00 00       	push   $0x1f7
801025ea:	e8 65 ff ff ff       	call   80102554 <inb>
801025ef:	83 c4 04             	add    $0x4,%esp
801025f2:	0f b6 c0             	movzbl %al,%eax
801025f5:	89 45 fc             	mov    %eax,-0x4(%ebp)
801025f8:	8b 45 fc             	mov    -0x4(%ebp),%eax
801025fb:	25 c0 00 00 00       	and    $0xc0,%eax
80102600:	83 f8 40             	cmp    $0x40,%eax
80102603:	75 e0                	jne    801025e5 <idewait+0x7>
    ;
  if(checkerr && (r & (IDE_DF|IDE_ERR)) != 0)
80102605:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
80102609:	74 11                	je     8010261c <idewait+0x3e>
8010260b:	8b 45 fc             	mov    -0x4(%ebp),%eax
8010260e:	83 e0 21             	and    $0x21,%eax
80102611:	85 c0                	test   %eax,%eax
80102613:	74 07                	je     8010261c <idewait+0x3e>
    return -1;
80102615:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010261a:	eb 05                	jmp    80102621 <idewait+0x43>
  return 0;
8010261c:	b8 00 00 00 00       	mov    $0x0,%eax
}
80102621:	c9                   	leave  
80102622:	c3                   	ret    

80102623 <ideinit>:

void
ideinit(void)
{
80102623:	55                   	push   %ebp
80102624:	89 e5                	mov    %esp,%ebp
80102626:	83 ec 18             	sub    $0x18,%esp
  int i;

  initlock(&idelock, "ide");
80102629:	83 ec 08             	sub    $0x8,%esp
8010262c:	68 f3 a7 10 80       	push   $0x8010a7f3
80102631:	68 c0 70 11 80       	push   $0x801170c0
80102636:	e8 eb 27 00 00       	call   80104e26 <initlock>
8010263b:	83 c4 10             	add    $0x10,%esp
  ioapicenable(IRQ_IDE, ncpu - 1);
8010263e:	a1 80 9d 11 80       	mov    0x80119d80,%eax
80102643:	83 e8 01             	sub    $0x1,%eax
80102646:	83 ec 08             	sub    $0x8,%esp
80102649:	50                   	push   %eax
8010264a:	6a 0e                	push   $0xe
8010264c:	e8 c1 04 00 00       	call   80102b12 <ioapicenable>
80102651:	83 c4 10             	add    $0x10,%esp
  idewait(0);
80102654:	83 ec 0c             	sub    $0xc,%esp
80102657:	6a 00                	push   $0x0
80102659:	e8 80 ff ff ff       	call   801025de <idewait>
8010265e:	83 c4 10             	add    $0x10,%esp

  // Check if disk 1 is present
  outb(0x1f6, 0xe0 | (1<<4));
80102661:	83 ec 08             	sub    $0x8,%esp
80102664:	68 f0 00 00 00       	push   $0xf0
80102669:	68 f6 01 00 00       	push   $0x1f6
8010266e:	e8 24 ff ff ff       	call   80102597 <outb>
80102673:	83 c4 10             	add    $0x10,%esp
  for(i=0; i<1000; i++){
80102676:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
8010267d:	eb 24                	jmp    801026a3 <ideinit+0x80>
    if(inb(0x1f7) != 0){
8010267f:	83 ec 0c             	sub    $0xc,%esp
80102682:	68 f7 01 00 00       	push   $0x1f7
80102687:	e8 c8 fe ff ff       	call   80102554 <inb>
8010268c:	83 c4 10             	add    $0x10,%esp
8010268f:	84 c0                	test   %al,%al
80102691:	74 0c                	je     8010269f <ideinit+0x7c>
      havedisk1 = 1;
80102693:	c7 05 f8 70 11 80 01 	movl   $0x1,0x801170f8
8010269a:	00 00 00 
      break;
8010269d:	eb 0d                	jmp    801026ac <ideinit+0x89>
  for(i=0; i<1000; i++){
8010269f:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
801026a3:	81 7d f4 e7 03 00 00 	cmpl   $0x3e7,-0xc(%ebp)
801026aa:	7e d3                	jle    8010267f <ideinit+0x5c>
    }
  }

  // Switch back to disk 0.
  outb(0x1f6, 0xe0 | (0<<4));
801026ac:	83 ec 08             	sub    $0x8,%esp
801026af:	68 e0 00 00 00       	push   $0xe0
801026b4:	68 f6 01 00 00       	push   $0x1f6
801026b9:	e8 d9 fe ff ff       	call   80102597 <outb>
801026be:	83 c4 10             	add    $0x10,%esp
}
801026c1:	90                   	nop
801026c2:	c9                   	leave  
801026c3:	c3                   	ret    

801026c4 <idestart>:

// Start the request for b.  Caller must hold idelock.
static void
idestart(struct buf *b)
{
801026c4:	55                   	push   %ebp
801026c5:	89 e5                	mov    %esp,%ebp
801026c7:	83 ec 18             	sub    $0x18,%esp
  if(b == 0)
801026ca:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
801026ce:	75 0d                	jne    801026dd <idestart+0x19>
    panic("idestart");
801026d0:	83 ec 0c             	sub    $0xc,%esp
801026d3:	68 f7 a7 10 80       	push   $0x8010a7f7
801026d8:	e8 cc de ff ff       	call   801005a9 <panic>
  if(b->blockno >= FSSIZE)
801026dd:	8b 45 08             	mov    0x8(%ebp),%eax
801026e0:	8b 40 08             	mov    0x8(%eax),%eax
801026e3:	3d e7 03 00 00       	cmp    $0x3e7,%eax
801026e8:	76 0d                	jbe    801026f7 <idestart+0x33>
    panic("incorrect blockno");
801026ea:	83 ec 0c             	sub    $0xc,%esp
801026ed:	68 00 a8 10 80       	push   $0x8010a800
801026f2:	e8 b2 de ff ff       	call   801005a9 <panic>
  int sector_per_block =  BSIZE/SECTOR_SIZE;
801026f7:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
  int sector = b->blockno * sector_per_block;
801026fe:	8b 45 08             	mov    0x8(%ebp),%eax
80102701:	8b 50 08             	mov    0x8(%eax),%edx
80102704:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102707:	0f af c2             	imul   %edx,%eax
8010270a:	89 45 f0             	mov    %eax,-0x10(%ebp)
  int read_cmd = (sector_per_block == 1) ? IDE_CMD_READ :  IDE_CMD_RDMUL;
8010270d:	83 7d f4 01          	cmpl   $0x1,-0xc(%ebp)
80102711:	75 07                	jne    8010271a <idestart+0x56>
80102713:	b8 20 00 00 00       	mov    $0x20,%eax
80102718:	eb 05                	jmp    8010271f <idestart+0x5b>
8010271a:	b8 c4 00 00 00       	mov    $0xc4,%eax
8010271f:	89 45 ec             	mov    %eax,-0x14(%ebp)
  int write_cmd = (sector_per_block == 1) ? IDE_CMD_WRITE : IDE_CMD_WRMUL;
80102722:	83 7d f4 01          	cmpl   $0x1,-0xc(%ebp)
80102726:	75 07                	jne    8010272f <idestart+0x6b>
80102728:	b8 30 00 00 00       	mov    $0x30,%eax
8010272d:	eb 05                	jmp    80102734 <idestart+0x70>
8010272f:	b8 c5 00 00 00       	mov    $0xc5,%eax
80102734:	89 45 e8             	mov    %eax,-0x18(%ebp)

  if (sector_per_block > 7) panic("idestart");
80102737:	83 7d f4 07          	cmpl   $0x7,-0xc(%ebp)
8010273b:	7e 0d                	jle    8010274a <idestart+0x86>
8010273d:	83 ec 0c             	sub    $0xc,%esp
80102740:	68 f7 a7 10 80       	push   $0x8010a7f7
80102745:	e8 5f de ff ff       	call   801005a9 <panic>

  idewait(0);
8010274a:	83 ec 0c             	sub    $0xc,%esp
8010274d:	6a 00                	push   $0x0
8010274f:	e8 8a fe ff ff       	call   801025de <idewait>
80102754:	83 c4 10             	add    $0x10,%esp
  outb(0x3f6, 0);  // generate interrupt
80102757:	83 ec 08             	sub    $0x8,%esp
8010275a:	6a 00                	push   $0x0
8010275c:	68 f6 03 00 00       	push   $0x3f6
80102761:	e8 31 fe ff ff       	call   80102597 <outb>
80102766:	83 c4 10             	add    $0x10,%esp
  outb(0x1f2, sector_per_block);  // number of sectors
80102769:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010276c:	0f b6 c0             	movzbl %al,%eax
8010276f:	83 ec 08             	sub    $0x8,%esp
80102772:	50                   	push   %eax
80102773:	68 f2 01 00 00       	push   $0x1f2
80102778:	e8 1a fe ff ff       	call   80102597 <outb>
8010277d:	83 c4 10             	add    $0x10,%esp
  outb(0x1f3, sector & 0xff);
80102780:	8b 45 f0             	mov    -0x10(%ebp),%eax
80102783:	0f b6 c0             	movzbl %al,%eax
80102786:	83 ec 08             	sub    $0x8,%esp
80102789:	50                   	push   %eax
8010278a:	68 f3 01 00 00       	push   $0x1f3
8010278f:	e8 03 fe ff ff       	call   80102597 <outb>
80102794:	83 c4 10             	add    $0x10,%esp
  outb(0x1f4, (sector >> 8) & 0xff);
80102797:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010279a:	c1 f8 08             	sar    $0x8,%eax
8010279d:	0f b6 c0             	movzbl %al,%eax
801027a0:	83 ec 08             	sub    $0x8,%esp
801027a3:	50                   	push   %eax
801027a4:	68 f4 01 00 00       	push   $0x1f4
801027a9:	e8 e9 fd ff ff       	call   80102597 <outb>
801027ae:	83 c4 10             	add    $0x10,%esp
  outb(0x1f5, (sector >> 16) & 0xff);
801027b1:	8b 45 f0             	mov    -0x10(%ebp),%eax
801027b4:	c1 f8 10             	sar    $0x10,%eax
801027b7:	0f b6 c0             	movzbl %al,%eax
801027ba:	83 ec 08             	sub    $0x8,%esp
801027bd:	50                   	push   %eax
801027be:	68 f5 01 00 00       	push   $0x1f5
801027c3:	e8 cf fd ff ff       	call   80102597 <outb>
801027c8:	83 c4 10             	add    $0x10,%esp
  outb(0x1f6, 0xe0 | ((b->dev&1)<<4) | ((sector>>24)&0x0f));
801027cb:	8b 45 08             	mov    0x8(%ebp),%eax
801027ce:	8b 40 04             	mov    0x4(%eax),%eax
801027d1:	c1 e0 04             	shl    $0x4,%eax
801027d4:	83 e0 10             	and    $0x10,%eax
801027d7:	89 c2                	mov    %eax,%edx
801027d9:	8b 45 f0             	mov    -0x10(%ebp),%eax
801027dc:	c1 f8 18             	sar    $0x18,%eax
801027df:	83 e0 0f             	and    $0xf,%eax
801027e2:	09 d0                	or     %edx,%eax
801027e4:	83 c8 e0             	or     $0xffffffe0,%eax
801027e7:	0f b6 c0             	movzbl %al,%eax
801027ea:	83 ec 08             	sub    $0x8,%esp
801027ed:	50                   	push   %eax
801027ee:	68 f6 01 00 00       	push   $0x1f6
801027f3:	e8 9f fd ff ff       	call   80102597 <outb>
801027f8:	83 c4 10             	add    $0x10,%esp
  if(b->flags & B_DIRTY){
801027fb:	8b 45 08             	mov    0x8(%ebp),%eax
801027fe:	8b 00                	mov    (%eax),%eax
80102800:	83 e0 04             	and    $0x4,%eax
80102803:	85 c0                	test   %eax,%eax
80102805:	74 35                	je     8010283c <idestart+0x178>
    outb(0x1f7, write_cmd);
80102807:	8b 45 e8             	mov    -0x18(%ebp),%eax
8010280a:	0f b6 c0             	movzbl %al,%eax
8010280d:	83 ec 08             	sub    $0x8,%esp
80102810:	50                   	push   %eax
80102811:	68 f7 01 00 00       	push   $0x1f7
80102816:	e8 7c fd ff ff       	call   80102597 <outb>
8010281b:	83 c4 10             	add    $0x10,%esp
    outsl(0x1f0, b->data, BSIZE/4);
8010281e:	8b 45 08             	mov    0x8(%ebp),%eax
80102821:	83 c0 5c             	add    $0x5c,%eax
80102824:	83 ec 04             	sub    $0x4,%esp
80102827:	68 80 00 00 00       	push   $0x80
8010282c:	50                   	push   %eax
8010282d:	68 f0 01 00 00       	push   $0x1f0
80102832:	e8 81 fd ff ff       	call   801025b8 <outsl>
80102837:	83 c4 10             	add    $0x10,%esp
  } else {
    outb(0x1f7, read_cmd);
  }
}
8010283a:	eb 17                	jmp    80102853 <idestart+0x18f>
    outb(0x1f7, read_cmd);
8010283c:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010283f:	0f b6 c0             	movzbl %al,%eax
80102842:	83 ec 08             	sub    $0x8,%esp
80102845:	50                   	push   %eax
80102846:	68 f7 01 00 00       	push   $0x1f7
8010284b:	e8 47 fd ff ff       	call   80102597 <outb>
80102850:	83 c4 10             	add    $0x10,%esp
}
80102853:	90                   	nop
80102854:	c9                   	leave  
80102855:	c3                   	ret    

80102856 <ideintr>:

// Interrupt handler.
void
ideintr(void)
{
80102856:	55                   	push   %ebp
80102857:	89 e5                	mov    %esp,%ebp
80102859:	83 ec 18             	sub    $0x18,%esp
  struct buf *b;

  // First queued buffer is the active request.
  acquire(&idelock);
8010285c:	83 ec 0c             	sub    $0xc,%esp
8010285f:	68 c0 70 11 80       	push   $0x801170c0
80102864:	e8 df 25 00 00       	call   80104e48 <acquire>
80102869:	83 c4 10             	add    $0x10,%esp

  if((b = idequeue) == 0){
8010286c:	a1 f4 70 11 80       	mov    0x801170f4,%eax
80102871:	89 45 f4             	mov    %eax,-0xc(%ebp)
80102874:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80102878:	75 15                	jne    8010288f <ideintr+0x39>
    release(&idelock);
8010287a:	83 ec 0c             	sub    $0xc,%esp
8010287d:	68 c0 70 11 80       	push   $0x801170c0
80102882:	e8 2f 26 00 00       	call   80104eb6 <release>
80102887:	83 c4 10             	add    $0x10,%esp
    return;
8010288a:	e9 9a 00 00 00       	jmp    80102929 <ideintr+0xd3>
  }
  idequeue = b->qnext;
8010288f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102892:	8b 40 58             	mov    0x58(%eax),%eax
80102895:	a3 f4 70 11 80       	mov    %eax,0x801170f4

  // Read data if needed.
  if(!(b->flags & B_DIRTY) && idewait(1) >= 0)
8010289a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010289d:	8b 00                	mov    (%eax),%eax
8010289f:	83 e0 04             	and    $0x4,%eax
801028a2:	85 c0                	test   %eax,%eax
801028a4:	75 2d                	jne    801028d3 <ideintr+0x7d>
801028a6:	83 ec 0c             	sub    $0xc,%esp
801028a9:	6a 01                	push   $0x1
801028ab:	e8 2e fd ff ff       	call   801025de <idewait>
801028b0:	83 c4 10             	add    $0x10,%esp
801028b3:	85 c0                	test   %eax,%eax
801028b5:	78 1c                	js     801028d3 <ideintr+0x7d>
    insl(0x1f0, b->data, BSIZE/4);
801028b7:	8b 45 f4             	mov    -0xc(%ebp),%eax
801028ba:	83 c0 5c             	add    $0x5c,%eax
801028bd:	83 ec 04             	sub    $0x4,%esp
801028c0:	68 80 00 00 00       	push   $0x80
801028c5:	50                   	push   %eax
801028c6:	68 f0 01 00 00       	push   $0x1f0
801028cb:	e8 a1 fc ff ff       	call   80102571 <insl>
801028d0:	83 c4 10             	add    $0x10,%esp

  // Wake process waiting for this buf.
  b->flags |= B_VALID;
801028d3:	8b 45 f4             	mov    -0xc(%ebp),%eax
801028d6:	8b 00                	mov    (%eax),%eax
801028d8:	83 c8 02             	or     $0x2,%eax
801028db:	89 c2                	mov    %eax,%edx
801028dd:	8b 45 f4             	mov    -0xc(%ebp),%eax
801028e0:	89 10                	mov    %edx,(%eax)
  b->flags &= ~B_DIRTY;
801028e2:	8b 45 f4             	mov    -0xc(%ebp),%eax
801028e5:	8b 00                	mov    (%eax),%eax
801028e7:	83 e0 fb             	and    $0xfffffffb,%eax
801028ea:	89 c2                	mov    %eax,%edx
801028ec:	8b 45 f4             	mov    -0xc(%ebp),%eax
801028ef:	89 10                	mov    %edx,(%eax)
  wakeup(b);
801028f1:	83 ec 0c             	sub    $0xc,%esp
801028f4:	ff 75 f4             	push   -0xc(%ebp)
801028f7:	e8 18 22 00 00       	call   80104b14 <wakeup>
801028fc:	83 c4 10             	add    $0x10,%esp

  // Start disk on next buf in queue.
  if(idequeue != 0)
801028ff:	a1 f4 70 11 80       	mov    0x801170f4,%eax
80102904:	85 c0                	test   %eax,%eax
80102906:	74 11                	je     80102919 <ideintr+0xc3>
    idestart(idequeue);
80102908:	a1 f4 70 11 80       	mov    0x801170f4,%eax
8010290d:	83 ec 0c             	sub    $0xc,%esp
80102910:	50                   	push   %eax
80102911:	e8 ae fd ff ff       	call   801026c4 <idestart>
80102916:	83 c4 10             	add    $0x10,%esp

  release(&idelock);
80102919:	83 ec 0c             	sub    $0xc,%esp
8010291c:	68 c0 70 11 80       	push   $0x801170c0
80102921:	e8 90 25 00 00       	call   80104eb6 <release>
80102926:	83 c4 10             	add    $0x10,%esp
}
80102929:	c9                   	leave  
8010292a:	c3                   	ret    

8010292b <iderw>:
// Sync buf with disk.
// If B_DIRTY is set, write buf to disk, clear B_DIRTY, set B_VALID.
// Else if B_VALID is not set, read buf from disk, set B_VALID.
void
iderw(struct buf *b)
{
8010292b:	55                   	push   %ebp
8010292c:	89 e5                	mov    %esp,%ebp
8010292e:	83 ec 18             	sub    $0x18,%esp
  struct buf **pp;
#if IDE_DEBUG
  cprintf("b->dev: %x havedisk1: %x\n",b->dev,havedisk1);
80102931:	8b 15 f8 70 11 80    	mov    0x801170f8,%edx
80102937:	8b 45 08             	mov    0x8(%ebp),%eax
8010293a:	8b 40 04             	mov    0x4(%eax),%eax
8010293d:	83 ec 04             	sub    $0x4,%esp
80102940:	52                   	push   %edx
80102941:	50                   	push   %eax
80102942:	68 12 a8 10 80       	push   $0x8010a812
80102947:	e8 a8 da ff ff       	call   801003f4 <cprintf>
8010294c:	83 c4 10             	add    $0x10,%esp
#endif
  if(!holdingsleep(&b->lock))
8010294f:	8b 45 08             	mov    0x8(%ebp),%eax
80102952:	83 c0 0c             	add    $0xc,%eax
80102955:	83 ec 0c             	sub    $0xc,%esp
80102958:	50                   	push   %eax
80102959:	e8 59 24 00 00       	call   80104db7 <holdingsleep>
8010295e:	83 c4 10             	add    $0x10,%esp
80102961:	85 c0                	test   %eax,%eax
80102963:	75 0d                	jne    80102972 <iderw+0x47>
    panic("iderw: buf not locked");
80102965:	83 ec 0c             	sub    $0xc,%esp
80102968:	68 2c a8 10 80       	push   $0x8010a82c
8010296d:	e8 37 dc ff ff       	call   801005a9 <panic>
  if((b->flags & (B_VALID|B_DIRTY)) == B_VALID)
80102972:	8b 45 08             	mov    0x8(%ebp),%eax
80102975:	8b 00                	mov    (%eax),%eax
80102977:	83 e0 06             	and    $0x6,%eax
8010297a:	83 f8 02             	cmp    $0x2,%eax
8010297d:	75 0d                	jne    8010298c <iderw+0x61>
    panic("iderw: nothing to do");
8010297f:	83 ec 0c             	sub    $0xc,%esp
80102982:	68 42 a8 10 80       	push   $0x8010a842
80102987:	e8 1d dc ff ff       	call   801005a9 <panic>
  if(b->dev != 0 && !havedisk1)
8010298c:	8b 45 08             	mov    0x8(%ebp),%eax
8010298f:	8b 40 04             	mov    0x4(%eax),%eax
80102992:	85 c0                	test   %eax,%eax
80102994:	74 16                	je     801029ac <iderw+0x81>
80102996:	a1 f8 70 11 80       	mov    0x801170f8,%eax
8010299b:	85 c0                	test   %eax,%eax
8010299d:	75 0d                	jne    801029ac <iderw+0x81>
    panic("iderw: ide disk 1 not present");
8010299f:	83 ec 0c             	sub    $0xc,%esp
801029a2:	68 57 a8 10 80       	push   $0x8010a857
801029a7:	e8 fd db ff ff       	call   801005a9 <panic>

  acquire(&idelock);  //DOC:acquire-lock
801029ac:	83 ec 0c             	sub    $0xc,%esp
801029af:	68 c0 70 11 80       	push   $0x801170c0
801029b4:	e8 8f 24 00 00       	call   80104e48 <acquire>
801029b9:	83 c4 10             	add    $0x10,%esp

  // Append b to idequeue.
  b->qnext = 0;
801029bc:	8b 45 08             	mov    0x8(%ebp),%eax
801029bf:	c7 40 58 00 00 00 00 	movl   $0x0,0x58(%eax)
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
801029c6:	c7 45 f4 f4 70 11 80 	movl   $0x801170f4,-0xc(%ebp)
801029cd:	eb 0b                	jmp    801029da <iderw+0xaf>
801029cf:	8b 45 f4             	mov    -0xc(%ebp),%eax
801029d2:	8b 00                	mov    (%eax),%eax
801029d4:	83 c0 58             	add    $0x58,%eax
801029d7:	89 45 f4             	mov    %eax,-0xc(%ebp)
801029da:	8b 45 f4             	mov    -0xc(%ebp),%eax
801029dd:	8b 00                	mov    (%eax),%eax
801029df:	85 c0                	test   %eax,%eax
801029e1:	75 ec                	jne    801029cf <iderw+0xa4>
    ;
  *pp = b;
801029e3:	8b 45 f4             	mov    -0xc(%ebp),%eax
801029e6:	8b 55 08             	mov    0x8(%ebp),%edx
801029e9:	89 10                	mov    %edx,(%eax)

  // Start disk if necessary.
  if(idequeue == b)
801029eb:	a1 f4 70 11 80       	mov    0x801170f4,%eax
801029f0:	39 45 08             	cmp    %eax,0x8(%ebp)
801029f3:	75 23                	jne    80102a18 <iderw+0xed>
    idestart(b);
801029f5:	83 ec 0c             	sub    $0xc,%esp
801029f8:	ff 75 08             	push   0x8(%ebp)
801029fb:	e8 c4 fc ff ff       	call   801026c4 <idestart>
80102a00:	83 c4 10             	add    $0x10,%esp

  // Wait for request to finish.
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
80102a03:	eb 13                	jmp    80102a18 <iderw+0xed>
    sleep(b, &idelock);
80102a05:	83 ec 08             	sub    $0x8,%esp
80102a08:	68 c0 70 11 80       	push   $0x801170c0
80102a0d:	ff 75 08             	push   0x8(%ebp)
80102a10:	e8 18 20 00 00       	call   80104a2d <sleep>
80102a15:	83 c4 10             	add    $0x10,%esp
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
80102a18:	8b 45 08             	mov    0x8(%ebp),%eax
80102a1b:	8b 00                	mov    (%eax),%eax
80102a1d:	83 e0 06             	and    $0x6,%eax
80102a20:	83 f8 02             	cmp    $0x2,%eax
80102a23:	75 e0                	jne    80102a05 <iderw+0xda>
  }


  release(&idelock);
80102a25:	83 ec 0c             	sub    $0xc,%esp
80102a28:	68 c0 70 11 80       	push   $0x801170c0
80102a2d:	e8 84 24 00 00       	call   80104eb6 <release>
80102a32:	83 c4 10             	add    $0x10,%esp
}
80102a35:	90                   	nop
80102a36:	c9                   	leave  
80102a37:	c3                   	ret    

80102a38 <ioapicread>:
  uint data;
};

static uint
ioapicread(int reg)
{
80102a38:	55                   	push   %ebp
80102a39:	89 e5                	mov    %esp,%ebp
  ioapic->reg = reg;
80102a3b:	a1 fc 70 11 80       	mov    0x801170fc,%eax
80102a40:	8b 55 08             	mov    0x8(%ebp),%edx
80102a43:	89 10                	mov    %edx,(%eax)
  return ioapic->data;
80102a45:	a1 fc 70 11 80       	mov    0x801170fc,%eax
80102a4a:	8b 40 10             	mov    0x10(%eax),%eax
}
80102a4d:	5d                   	pop    %ebp
80102a4e:	c3                   	ret    

80102a4f <ioapicwrite>:

static void
ioapicwrite(int reg, uint data)
{
80102a4f:	55                   	push   %ebp
80102a50:	89 e5                	mov    %esp,%ebp
  ioapic->reg = reg;
80102a52:	a1 fc 70 11 80       	mov    0x801170fc,%eax
80102a57:	8b 55 08             	mov    0x8(%ebp),%edx
80102a5a:	89 10                	mov    %edx,(%eax)
  ioapic->data = data;
80102a5c:	a1 fc 70 11 80       	mov    0x801170fc,%eax
80102a61:	8b 55 0c             	mov    0xc(%ebp),%edx
80102a64:	89 50 10             	mov    %edx,0x10(%eax)
}
80102a67:	90                   	nop
80102a68:	5d                   	pop    %ebp
80102a69:	c3                   	ret    

80102a6a <ioapicinit>:

void
ioapicinit(void)
{
80102a6a:	55                   	push   %ebp
80102a6b:	89 e5                	mov    %esp,%ebp
80102a6d:	83 ec 18             	sub    $0x18,%esp
  int i, id, maxintr;

  ioapic = (volatile struct ioapic*)IOAPIC;
80102a70:	c7 05 fc 70 11 80 00 	movl   $0xfec00000,0x801170fc
80102a77:	00 c0 fe 
  maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
80102a7a:	6a 01                	push   $0x1
80102a7c:	e8 b7 ff ff ff       	call   80102a38 <ioapicread>
80102a81:	83 c4 04             	add    $0x4,%esp
80102a84:	c1 e8 10             	shr    $0x10,%eax
80102a87:	25 ff 00 00 00       	and    $0xff,%eax
80102a8c:	89 45 f0             	mov    %eax,-0x10(%ebp)
  id = ioapicread(REG_ID) >> 24;
80102a8f:	6a 00                	push   $0x0
80102a91:	e8 a2 ff ff ff       	call   80102a38 <ioapicread>
80102a96:	83 c4 04             	add    $0x4,%esp
80102a99:	c1 e8 18             	shr    $0x18,%eax
80102a9c:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if(id != ioapicid)
80102a9f:	0f b6 05 84 9d 11 80 	movzbl 0x80119d84,%eax
80102aa6:	0f b6 c0             	movzbl %al,%eax
80102aa9:	39 45 ec             	cmp    %eax,-0x14(%ebp)
80102aac:	74 10                	je     80102abe <ioapicinit+0x54>
    cprintf("ioapicinit: id isn't equal to ioapicid; not a MP\n");
80102aae:	83 ec 0c             	sub    $0xc,%esp
80102ab1:	68 78 a8 10 80       	push   $0x8010a878
80102ab6:	e8 39 d9 ff ff       	call   801003f4 <cprintf>
80102abb:	83 c4 10             	add    $0x10,%esp

  // Mark all interrupts edge-triggered, active high, disabled,
  // and not routed to any CPUs.
  for(i = 0; i <= maxintr; i++){
80102abe:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80102ac5:	eb 3f                	jmp    80102b06 <ioapicinit+0x9c>
    ioapicwrite(REG_TABLE+2*i, INT_DISABLED | (T_IRQ0 + i));
80102ac7:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102aca:	83 c0 20             	add    $0x20,%eax
80102acd:	0d 00 00 01 00       	or     $0x10000,%eax
80102ad2:	89 c2                	mov    %eax,%edx
80102ad4:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102ad7:	83 c0 08             	add    $0x8,%eax
80102ada:	01 c0                	add    %eax,%eax
80102adc:	83 ec 08             	sub    $0x8,%esp
80102adf:	52                   	push   %edx
80102ae0:	50                   	push   %eax
80102ae1:	e8 69 ff ff ff       	call   80102a4f <ioapicwrite>
80102ae6:	83 c4 10             	add    $0x10,%esp
    ioapicwrite(REG_TABLE+2*i+1, 0);
80102ae9:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102aec:	83 c0 08             	add    $0x8,%eax
80102aef:	01 c0                	add    %eax,%eax
80102af1:	83 c0 01             	add    $0x1,%eax
80102af4:	83 ec 08             	sub    $0x8,%esp
80102af7:	6a 00                	push   $0x0
80102af9:	50                   	push   %eax
80102afa:	e8 50 ff ff ff       	call   80102a4f <ioapicwrite>
80102aff:	83 c4 10             	add    $0x10,%esp
  for(i = 0; i <= maxintr; i++){
80102b02:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80102b06:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102b09:	3b 45 f0             	cmp    -0x10(%ebp),%eax
80102b0c:	7e b9                	jle    80102ac7 <ioapicinit+0x5d>
  }
}
80102b0e:	90                   	nop
80102b0f:	90                   	nop
80102b10:	c9                   	leave  
80102b11:	c3                   	ret    

80102b12 <ioapicenable>:

void
ioapicenable(int irq, int cpunum)
{
80102b12:	55                   	push   %ebp
80102b13:	89 e5                	mov    %esp,%ebp
  // Mark interrupt edge-triggered, active high,
  // enabled, and routed to the given cpunum,
  // which happens to be that cpu's APIC ID.
  ioapicwrite(REG_TABLE+2*irq, T_IRQ0 + irq);
80102b15:	8b 45 08             	mov    0x8(%ebp),%eax
80102b18:	83 c0 20             	add    $0x20,%eax
80102b1b:	89 c2                	mov    %eax,%edx
80102b1d:	8b 45 08             	mov    0x8(%ebp),%eax
80102b20:	83 c0 08             	add    $0x8,%eax
80102b23:	01 c0                	add    %eax,%eax
80102b25:	52                   	push   %edx
80102b26:	50                   	push   %eax
80102b27:	e8 23 ff ff ff       	call   80102a4f <ioapicwrite>
80102b2c:	83 c4 08             	add    $0x8,%esp
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
80102b2f:	8b 45 0c             	mov    0xc(%ebp),%eax
80102b32:	c1 e0 18             	shl    $0x18,%eax
80102b35:	89 c2                	mov    %eax,%edx
80102b37:	8b 45 08             	mov    0x8(%ebp),%eax
80102b3a:	83 c0 08             	add    $0x8,%eax
80102b3d:	01 c0                	add    %eax,%eax
80102b3f:	83 c0 01             	add    $0x1,%eax
80102b42:	52                   	push   %edx
80102b43:	50                   	push   %eax
80102b44:	e8 06 ff ff ff       	call   80102a4f <ioapicwrite>
80102b49:	83 c4 08             	add    $0x8,%esp
}
80102b4c:	90                   	nop
80102b4d:	c9                   	leave  
80102b4e:	c3                   	ret    

80102b4f <kinit1>:
// the pages mapped by entrypgdir on free list.
// 2. main() calls kinit2() with the rest of the physical pages
// after installing a full page table that maps them on all cores.
void
kinit1(void *vstart, void *vend)
{
80102b4f:	55                   	push   %ebp
80102b50:	89 e5                	mov    %esp,%ebp
80102b52:	83 ec 08             	sub    $0x8,%esp
  initlock(&kmem.lock, "kmem");
80102b55:	83 ec 08             	sub    $0x8,%esp
80102b58:	68 aa a8 10 80       	push   $0x8010a8aa
80102b5d:	68 00 71 11 80       	push   $0x80117100
80102b62:	e8 bf 22 00 00       	call   80104e26 <initlock>
80102b67:	83 c4 10             	add    $0x10,%esp
  kmem.use_lock = 0;
80102b6a:	c7 05 34 71 11 80 00 	movl   $0x0,0x80117134
80102b71:	00 00 00 
  freerange(vstart, vend);
80102b74:	83 ec 08             	sub    $0x8,%esp
80102b77:	ff 75 0c             	push   0xc(%ebp)
80102b7a:	ff 75 08             	push   0x8(%ebp)
80102b7d:	e8 2a 00 00 00       	call   80102bac <freerange>
80102b82:	83 c4 10             	add    $0x10,%esp
}
80102b85:	90                   	nop
80102b86:	c9                   	leave  
80102b87:	c3                   	ret    

80102b88 <kinit2>:

void
kinit2(void *vstart, void *vend)
{
80102b88:	55                   	push   %ebp
80102b89:	89 e5                	mov    %esp,%ebp
80102b8b:	83 ec 08             	sub    $0x8,%esp
  freerange(vstart, vend);
80102b8e:	83 ec 08             	sub    $0x8,%esp
80102b91:	ff 75 0c             	push   0xc(%ebp)
80102b94:	ff 75 08             	push   0x8(%ebp)
80102b97:	e8 10 00 00 00       	call   80102bac <freerange>
80102b9c:	83 c4 10             	add    $0x10,%esp
  kmem.use_lock = 1;
80102b9f:	c7 05 34 71 11 80 01 	movl   $0x1,0x80117134
80102ba6:	00 00 00 
}
80102ba9:	90                   	nop
80102baa:	c9                   	leave  
80102bab:	c3                   	ret    

80102bac <freerange>:

void
freerange(void *vstart, void *vend)
{
80102bac:	55                   	push   %ebp
80102bad:	89 e5                	mov    %esp,%ebp
80102baf:	83 ec 18             	sub    $0x18,%esp
  char *p;
  p = (char*)PGROUNDUP((uint)vstart);
80102bb2:	8b 45 08             	mov    0x8(%ebp),%eax
80102bb5:	05 ff 0f 00 00       	add    $0xfff,%eax
80102bba:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80102bbf:	89 45 f4             	mov    %eax,-0xc(%ebp)
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102bc2:	eb 15                	jmp    80102bd9 <freerange+0x2d>
    kfree(p);
80102bc4:	83 ec 0c             	sub    $0xc,%esp
80102bc7:	ff 75 f4             	push   -0xc(%ebp)
80102bca:	e8 1b 00 00 00       	call   80102bea <kfree>
80102bcf:	83 c4 10             	add    $0x10,%esp
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102bd2:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
80102bd9:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102bdc:	05 00 10 00 00       	add    $0x1000,%eax
80102be1:	39 45 0c             	cmp    %eax,0xc(%ebp)
80102be4:	73 de                	jae    80102bc4 <freerange+0x18>
}
80102be6:	90                   	nop
80102be7:	90                   	nop
80102be8:	c9                   	leave  
80102be9:	c3                   	ret    

80102bea <kfree>:
// which normally should have been returned by a
// call to kalloc().  (The exception is when
// initializing the allocator; see kinit above.)
void
kfree(char *v)
{
80102bea:	55                   	push   %ebp
80102beb:	89 e5                	mov    %esp,%ebp
80102bed:	83 ec 18             	sub    $0x18,%esp
  struct run *r;

  if((uint)v % PGSIZE || v < end || V2P(v) >= PHYSTOP)
80102bf0:	8b 45 08             	mov    0x8(%ebp),%eax
80102bf3:	25 ff 0f 00 00       	and    $0xfff,%eax
80102bf8:	85 c0                	test   %eax,%eax
80102bfa:	75 18                	jne    80102c14 <kfree+0x2a>
80102bfc:	81 7d 08 00 c0 11 80 	cmpl   $0x8011c000,0x8(%ebp)
80102c03:	72 0f                	jb     80102c14 <kfree+0x2a>
80102c05:	8b 45 08             	mov    0x8(%ebp),%eax
80102c08:	05 00 00 00 80       	add    $0x80000000,%eax
80102c0d:	3d ff ff ff 1f       	cmp    $0x1fffffff,%eax
80102c12:	76 0d                	jbe    80102c21 <kfree+0x37>
    panic("kfree");
80102c14:	83 ec 0c             	sub    $0xc,%esp
80102c17:	68 af a8 10 80       	push   $0x8010a8af
80102c1c:	e8 88 d9 ff ff       	call   801005a9 <panic>

  // Fill with junk to catch dangling refs.
  memset(v, 1, PGSIZE);
80102c21:	83 ec 04             	sub    $0x4,%esp
80102c24:	68 00 10 00 00       	push   $0x1000
80102c29:	6a 01                	push   $0x1
80102c2b:	ff 75 08             	push   0x8(%ebp)
80102c2e:	e8 8b 24 00 00       	call   801050be <memset>
80102c33:	83 c4 10             	add    $0x10,%esp

  if(kmem.use_lock)
80102c36:	a1 34 71 11 80       	mov    0x80117134,%eax
80102c3b:	85 c0                	test   %eax,%eax
80102c3d:	74 10                	je     80102c4f <kfree+0x65>
    acquire(&kmem.lock);
80102c3f:	83 ec 0c             	sub    $0xc,%esp
80102c42:	68 00 71 11 80       	push   $0x80117100
80102c47:	e8 fc 21 00 00       	call   80104e48 <acquire>
80102c4c:	83 c4 10             	add    $0x10,%esp
  r = (struct run*)v;
80102c4f:	8b 45 08             	mov    0x8(%ebp),%eax
80102c52:	89 45 f4             	mov    %eax,-0xc(%ebp)
  r->next = kmem.freelist;
80102c55:	8b 15 38 71 11 80    	mov    0x80117138,%edx
80102c5b:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102c5e:	89 10                	mov    %edx,(%eax)
  kmem.freelist = r;
80102c60:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102c63:	a3 38 71 11 80       	mov    %eax,0x80117138
  if(kmem.use_lock)
80102c68:	a1 34 71 11 80       	mov    0x80117134,%eax
80102c6d:	85 c0                	test   %eax,%eax
80102c6f:	74 10                	je     80102c81 <kfree+0x97>
    release(&kmem.lock);
80102c71:	83 ec 0c             	sub    $0xc,%esp
80102c74:	68 00 71 11 80       	push   $0x80117100
80102c79:	e8 38 22 00 00       	call   80104eb6 <release>
80102c7e:	83 c4 10             	add    $0x10,%esp
}
80102c81:	90                   	nop
80102c82:	c9                   	leave  
80102c83:	c3                   	ret    

80102c84 <kalloc>:
// Allocate one 4096-byte page of physical memory.
// Returns a pointer that the kernel can use.
// Returns 0 if the memory cannot be allocated.
char*
kalloc(void)
{
80102c84:	55                   	push   %ebp
80102c85:	89 e5                	mov    %esp,%ebp
80102c87:	83 ec 18             	sub    $0x18,%esp
  struct run *r;

  if(kmem.use_lock)
80102c8a:	a1 34 71 11 80       	mov    0x80117134,%eax
80102c8f:	85 c0                	test   %eax,%eax
80102c91:	74 10                	je     80102ca3 <kalloc+0x1f>
    acquire(&kmem.lock);
80102c93:	83 ec 0c             	sub    $0xc,%esp
80102c96:	68 00 71 11 80       	push   $0x80117100
80102c9b:	e8 a8 21 00 00       	call   80104e48 <acquire>
80102ca0:	83 c4 10             	add    $0x10,%esp
  r = kmem.freelist;
80102ca3:	a1 38 71 11 80       	mov    0x80117138,%eax
80102ca8:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(r)
80102cab:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80102caf:	74 0a                	je     80102cbb <kalloc+0x37>
    kmem.freelist = r->next;
80102cb1:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102cb4:	8b 00                	mov    (%eax),%eax
80102cb6:	a3 38 71 11 80       	mov    %eax,0x80117138
  if(kmem.use_lock)
80102cbb:	a1 34 71 11 80       	mov    0x80117134,%eax
80102cc0:	85 c0                	test   %eax,%eax
80102cc2:	74 10                	je     80102cd4 <kalloc+0x50>
    release(&kmem.lock);
80102cc4:	83 ec 0c             	sub    $0xc,%esp
80102cc7:	68 00 71 11 80       	push   $0x80117100
80102ccc:	e8 e5 21 00 00       	call   80104eb6 <release>
80102cd1:	83 c4 10             	add    $0x10,%esp
  return (char*)r;
80102cd4:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
80102cd7:	c9                   	leave  
80102cd8:	c3                   	ret    

80102cd9 <inb>:
{
80102cd9:	55                   	push   %ebp
80102cda:	89 e5                	mov    %esp,%ebp
80102cdc:	83 ec 14             	sub    $0x14,%esp
80102cdf:	8b 45 08             	mov    0x8(%ebp),%eax
80102ce2:	66 89 45 ec          	mov    %ax,-0x14(%ebp)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102ce6:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
80102cea:	89 c2                	mov    %eax,%edx
80102cec:	ec                   	in     (%dx),%al
80102ced:	88 45 ff             	mov    %al,-0x1(%ebp)
  return data;
80102cf0:	0f b6 45 ff          	movzbl -0x1(%ebp),%eax
}
80102cf4:	c9                   	leave  
80102cf5:	c3                   	ret    

80102cf6 <kbdgetc>:
#include "defs.h"
#include "kbd.h"

int
kbdgetc(void)
{
80102cf6:	55                   	push   %ebp
80102cf7:	89 e5                	mov    %esp,%ebp
80102cf9:	83 ec 10             	sub    $0x10,%esp
  static uchar *charcode[4] = {
    normalmap, shiftmap, ctlmap, ctlmap
  };
  uint st, data, c;

  st = inb(KBSTATP);
80102cfc:	6a 64                	push   $0x64
80102cfe:	e8 d6 ff ff ff       	call   80102cd9 <inb>
80102d03:	83 c4 04             	add    $0x4,%esp
80102d06:	0f b6 c0             	movzbl %al,%eax
80102d09:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if((st & KBS_DIB) == 0)
80102d0c:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102d0f:	83 e0 01             	and    $0x1,%eax
80102d12:	85 c0                	test   %eax,%eax
80102d14:	75 0a                	jne    80102d20 <kbdgetc+0x2a>
    return -1;
80102d16:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80102d1b:	e9 23 01 00 00       	jmp    80102e43 <kbdgetc+0x14d>
  data = inb(KBDATAP);
80102d20:	6a 60                	push   $0x60
80102d22:	e8 b2 ff ff ff       	call   80102cd9 <inb>
80102d27:	83 c4 04             	add    $0x4,%esp
80102d2a:	0f b6 c0             	movzbl %al,%eax
80102d2d:	89 45 fc             	mov    %eax,-0x4(%ebp)

  if(data == 0xE0){
80102d30:	81 7d fc e0 00 00 00 	cmpl   $0xe0,-0x4(%ebp)
80102d37:	75 17                	jne    80102d50 <kbdgetc+0x5a>
    shift |= E0ESC;
80102d39:	a1 3c 71 11 80       	mov    0x8011713c,%eax
80102d3e:	83 c8 40             	or     $0x40,%eax
80102d41:	a3 3c 71 11 80       	mov    %eax,0x8011713c
    return 0;
80102d46:	b8 00 00 00 00       	mov    $0x0,%eax
80102d4b:	e9 f3 00 00 00       	jmp    80102e43 <kbdgetc+0x14d>
  } else if(data & 0x80){
80102d50:	8b 45 fc             	mov    -0x4(%ebp),%eax
80102d53:	25 80 00 00 00       	and    $0x80,%eax
80102d58:	85 c0                	test   %eax,%eax
80102d5a:	74 45                	je     80102da1 <kbdgetc+0xab>
    // Key released
    data = (shift & E0ESC ? data : data & 0x7F);
80102d5c:	a1 3c 71 11 80       	mov    0x8011713c,%eax
80102d61:	83 e0 40             	and    $0x40,%eax
80102d64:	85 c0                	test   %eax,%eax
80102d66:	75 08                	jne    80102d70 <kbdgetc+0x7a>
80102d68:	8b 45 fc             	mov    -0x4(%ebp),%eax
80102d6b:	83 e0 7f             	and    $0x7f,%eax
80102d6e:	eb 03                	jmp    80102d73 <kbdgetc+0x7d>
80102d70:	8b 45 fc             	mov    -0x4(%ebp),%eax
80102d73:	89 45 fc             	mov    %eax,-0x4(%ebp)
    shift &= ~(shiftcode[data] | E0ESC);
80102d76:	8b 45 fc             	mov    -0x4(%ebp),%eax
80102d79:	05 20 d0 10 80       	add    $0x8010d020,%eax
80102d7e:	0f b6 00             	movzbl (%eax),%eax
80102d81:	83 c8 40             	or     $0x40,%eax
80102d84:	0f b6 c0             	movzbl %al,%eax
80102d87:	f7 d0                	not    %eax
80102d89:	89 c2                	mov    %eax,%edx
80102d8b:	a1 3c 71 11 80       	mov    0x8011713c,%eax
80102d90:	21 d0                	and    %edx,%eax
80102d92:	a3 3c 71 11 80       	mov    %eax,0x8011713c
    return 0;
80102d97:	b8 00 00 00 00       	mov    $0x0,%eax
80102d9c:	e9 a2 00 00 00       	jmp    80102e43 <kbdgetc+0x14d>
  } else if(shift & E0ESC){
80102da1:	a1 3c 71 11 80       	mov    0x8011713c,%eax
80102da6:	83 e0 40             	and    $0x40,%eax
80102da9:	85 c0                	test   %eax,%eax
80102dab:	74 14                	je     80102dc1 <kbdgetc+0xcb>
    // Last character was an E0 escape; or with 0x80
    data |= 0x80;
80102dad:	81 4d fc 80 00 00 00 	orl    $0x80,-0x4(%ebp)
    shift &= ~E0ESC;
80102db4:	a1 3c 71 11 80       	mov    0x8011713c,%eax
80102db9:	83 e0 bf             	and    $0xffffffbf,%eax
80102dbc:	a3 3c 71 11 80       	mov    %eax,0x8011713c
  }

  shift |= shiftcode[data];
80102dc1:	8b 45 fc             	mov    -0x4(%ebp),%eax
80102dc4:	05 20 d0 10 80       	add    $0x8010d020,%eax
80102dc9:	0f b6 00             	movzbl (%eax),%eax
80102dcc:	0f b6 d0             	movzbl %al,%edx
80102dcf:	a1 3c 71 11 80       	mov    0x8011713c,%eax
80102dd4:	09 d0                	or     %edx,%eax
80102dd6:	a3 3c 71 11 80       	mov    %eax,0x8011713c
  shift ^= togglecode[data];
80102ddb:	8b 45 fc             	mov    -0x4(%ebp),%eax
80102dde:	05 20 d1 10 80       	add    $0x8010d120,%eax
80102de3:	0f b6 00             	movzbl (%eax),%eax
80102de6:	0f b6 d0             	movzbl %al,%edx
80102de9:	a1 3c 71 11 80       	mov    0x8011713c,%eax
80102dee:	31 d0                	xor    %edx,%eax
80102df0:	a3 3c 71 11 80       	mov    %eax,0x8011713c
  c = charcode[shift & (CTL | SHIFT)][data];
80102df5:	a1 3c 71 11 80       	mov    0x8011713c,%eax
80102dfa:	83 e0 03             	and    $0x3,%eax
80102dfd:	8b 14 85 20 d5 10 80 	mov    -0x7fef2ae0(,%eax,4),%edx
80102e04:	8b 45 fc             	mov    -0x4(%ebp),%eax
80102e07:	01 d0                	add    %edx,%eax
80102e09:	0f b6 00             	movzbl (%eax),%eax
80102e0c:	0f b6 c0             	movzbl %al,%eax
80102e0f:	89 45 f8             	mov    %eax,-0x8(%ebp)
  if(shift & CAPSLOCK){
80102e12:	a1 3c 71 11 80       	mov    0x8011713c,%eax
80102e17:	83 e0 08             	and    $0x8,%eax
80102e1a:	85 c0                	test   %eax,%eax
80102e1c:	74 22                	je     80102e40 <kbdgetc+0x14a>
    if('a' <= c && c <= 'z')
80102e1e:	83 7d f8 60          	cmpl   $0x60,-0x8(%ebp)
80102e22:	76 0c                	jbe    80102e30 <kbdgetc+0x13a>
80102e24:	83 7d f8 7a          	cmpl   $0x7a,-0x8(%ebp)
80102e28:	77 06                	ja     80102e30 <kbdgetc+0x13a>
      c += 'A' - 'a';
80102e2a:	83 6d f8 20          	subl   $0x20,-0x8(%ebp)
80102e2e:	eb 10                	jmp    80102e40 <kbdgetc+0x14a>
    else if('A' <= c && c <= 'Z')
80102e30:	83 7d f8 40          	cmpl   $0x40,-0x8(%ebp)
80102e34:	76 0a                	jbe    80102e40 <kbdgetc+0x14a>
80102e36:	83 7d f8 5a          	cmpl   $0x5a,-0x8(%ebp)
80102e3a:	77 04                	ja     80102e40 <kbdgetc+0x14a>
      c += 'a' - 'A';
80102e3c:	83 45 f8 20          	addl   $0x20,-0x8(%ebp)
  }
  return c;
80102e40:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
80102e43:	c9                   	leave  
80102e44:	c3                   	ret    

80102e45 <kbdintr>:

void
kbdintr(void)
{
80102e45:	55                   	push   %ebp
80102e46:	89 e5                	mov    %esp,%ebp
80102e48:	83 ec 08             	sub    $0x8,%esp
  consoleintr(kbdgetc);
80102e4b:	83 ec 0c             	sub    $0xc,%esp
80102e4e:	68 f6 2c 10 80       	push   $0x80102cf6
80102e53:	e8 7e d9 ff ff       	call   801007d6 <consoleintr>
80102e58:	83 c4 10             	add    $0x10,%esp
}
80102e5b:	90                   	nop
80102e5c:	c9                   	leave  
80102e5d:	c3                   	ret    

80102e5e <inb>:
{
80102e5e:	55                   	push   %ebp
80102e5f:	89 e5                	mov    %esp,%ebp
80102e61:	83 ec 14             	sub    $0x14,%esp
80102e64:	8b 45 08             	mov    0x8(%ebp),%eax
80102e67:	66 89 45 ec          	mov    %ax,-0x14(%ebp)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102e6b:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
80102e6f:	89 c2                	mov    %eax,%edx
80102e71:	ec                   	in     (%dx),%al
80102e72:	88 45 ff             	mov    %al,-0x1(%ebp)
  return data;
80102e75:	0f b6 45 ff          	movzbl -0x1(%ebp),%eax
}
80102e79:	c9                   	leave  
80102e7a:	c3                   	ret    

80102e7b <outb>:
{
80102e7b:	55                   	push   %ebp
80102e7c:	89 e5                	mov    %esp,%ebp
80102e7e:	83 ec 08             	sub    $0x8,%esp
80102e81:	8b 45 08             	mov    0x8(%ebp),%eax
80102e84:	8b 55 0c             	mov    0xc(%ebp),%edx
80102e87:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
80102e8b:	89 d0                	mov    %edx,%eax
80102e8d:	88 45 f8             	mov    %al,-0x8(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102e90:	0f b6 45 f8          	movzbl -0x8(%ebp),%eax
80102e94:	0f b7 55 fc          	movzwl -0x4(%ebp),%edx
80102e98:	ee                   	out    %al,(%dx)
}
80102e99:	90                   	nop
80102e9a:	c9                   	leave  
80102e9b:	c3                   	ret    

80102e9c <lapicw>:
volatile uint *lapic;  // Initialized in mp.c

//PAGEBREAK!
static void
lapicw(int index, int value)
{
80102e9c:	55                   	push   %ebp
80102e9d:	89 e5                	mov    %esp,%ebp
  lapic[index] = value;
80102e9f:	8b 15 40 71 11 80    	mov    0x80117140,%edx
80102ea5:	8b 45 08             	mov    0x8(%ebp),%eax
80102ea8:	c1 e0 02             	shl    $0x2,%eax
80102eab:	01 c2                	add    %eax,%edx
80102ead:	8b 45 0c             	mov    0xc(%ebp),%eax
80102eb0:	89 02                	mov    %eax,(%edx)
  lapic[ID];  // wait for write to finish, by reading
80102eb2:	a1 40 71 11 80       	mov    0x80117140,%eax
80102eb7:	83 c0 20             	add    $0x20,%eax
80102eba:	8b 00                	mov    (%eax),%eax
}
80102ebc:	90                   	nop
80102ebd:	5d                   	pop    %ebp
80102ebe:	c3                   	ret    

80102ebf <lapicinit>:

void
lapicinit(void)
{
80102ebf:	55                   	push   %ebp
80102ec0:	89 e5                	mov    %esp,%ebp
  if(!lapic)
80102ec2:	a1 40 71 11 80       	mov    0x80117140,%eax
80102ec7:	85 c0                	test   %eax,%eax
80102ec9:	0f 84 0c 01 00 00    	je     80102fdb <lapicinit+0x11c>
    return;

  // Enable local APIC; set spurious interrupt vector.
  lapicw(SVR, ENABLE | (T_IRQ0 + IRQ_SPURIOUS));
80102ecf:	68 3f 01 00 00       	push   $0x13f
80102ed4:	6a 3c                	push   $0x3c
80102ed6:	e8 c1 ff ff ff       	call   80102e9c <lapicw>
80102edb:	83 c4 08             	add    $0x8,%esp

  // The timer repeatedly counts down at bus frequency
  // from lapic[TICR] and then issues an interrupt.
  // If xv6 cared more about precise timekeeping,
  // TICR would be calibrated using an external time source.
  lapicw(TDCR, X1);
80102ede:	6a 0b                	push   $0xb
80102ee0:	68 f8 00 00 00       	push   $0xf8
80102ee5:	e8 b2 ff ff ff       	call   80102e9c <lapicw>
80102eea:	83 c4 08             	add    $0x8,%esp
  lapicw(TIMER, PERIODIC | (T_IRQ0 + IRQ_TIMER));
80102eed:	68 20 00 02 00       	push   $0x20020
80102ef2:	68 c8 00 00 00       	push   $0xc8
80102ef7:	e8 a0 ff ff ff       	call   80102e9c <lapicw>
80102efc:	83 c4 08             	add    $0x8,%esp
  lapicw(TICR, 10000000);
80102eff:	68 80 96 98 00       	push   $0x989680
80102f04:	68 e0 00 00 00       	push   $0xe0
80102f09:	e8 8e ff ff ff       	call   80102e9c <lapicw>
80102f0e:	83 c4 08             	add    $0x8,%esp

  // Disable logical interrupt lines.
  lapicw(LINT0, MASKED);
80102f11:	68 00 00 01 00       	push   $0x10000
80102f16:	68 d4 00 00 00       	push   $0xd4
80102f1b:	e8 7c ff ff ff       	call   80102e9c <lapicw>
80102f20:	83 c4 08             	add    $0x8,%esp
  lapicw(LINT1, MASKED);
80102f23:	68 00 00 01 00       	push   $0x10000
80102f28:	68 d8 00 00 00       	push   $0xd8
80102f2d:	e8 6a ff ff ff       	call   80102e9c <lapicw>
80102f32:	83 c4 08             	add    $0x8,%esp

  // Disable performance counter overflow interrupts
  // on machines that provide that interrupt entry.
  if(((lapic[VER]>>16) & 0xFF) >= 4)
80102f35:	a1 40 71 11 80       	mov    0x80117140,%eax
80102f3a:	83 c0 30             	add    $0x30,%eax
80102f3d:	8b 00                	mov    (%eax),%eax
80102f3f:	c1 e8 10             	shr    $0x10,%eax
80102f42:	25 fc 00 00 00       	and    $0xfc,%eax
80102f47:	85 c0                	test   %eax,%eax
80102f49:	74 12                	je     80102f5d <lapicinit+0x9e>
    lapicw(PCINT, MASKED);
80102f4b:	68 00 00 01 00       	push   $0x10000
80102f50:	68 d0 00 00 00       	push   $0xd0
80102f55:	e8 42 ff ff ff       	call   80102e9c <lapicw>
80102f5a:	83 c4 08             	add    $0x8,%esp

  // Map error interrupt to IRQ_ERROR.
  lapicw(ERROR, T_IRQ0 + IRQ_ERROR);
80102f5d:	6a 33                	push   $0x33
80102f5f:	68 dc 00 00 00       	push   $0xdc
80102f64:	e8 33 ff ff ff       	call   80102e9c <lapicw>
80102f69:	83 c4 08             	add    $0x8,%esp

  // Clear error status register (requires back-to-back writes).
  lapicw(ESR, 0);
80102f6c:	6a 00                	push   $0x0
80102f6e:	68 a0 00 00 00       	push   $0xa0
80102f73:	e8 24 ff ff ff       	call   80102e9c <lapicw>
80102f78:	83 c4 08             	add    $0x8,%esp
  lapicw(ESR, 0);
80102f7b:	6a 00                	push   $0x0
80102f7d:	68 a0 00 00 00       	push   $0xa0
80102f82:	e8 15 ff ff ff       	call   80102e9c <lapicw>
80102f87:	83 c4 08             	add    $0x8,%esp

  // Ack any outstanding interrupts.
  lapicw(EOI, 0);
80102f8a:	6a 00                	push   $0x0
80102f8c:	6a 2c                	push   $0x2c
80102f8e:	e8 09 ff ff ff       	call   80102e9c <lapicw>
80102f93:	83 c4 08             	add    $0x8,%esp

  // Send an Init Level De-Assert to synchronise arbitration ID's.
  lapicw(ICRHI, 0);
80102f96:	6a 00                	push   $0x0
80102f98:	68 c4 00 00 00       	push   $0xc4
80102f9d:	e8 fa fe ff ff       	call   80102e9c <lapicw>
80102fa2:	83 c4 08             	add    $0x8,%esp
  lapicw(ICRLO, BCAST | INIT | LEVEL);
80102fa5:	68 00 85 08 00       	push   $0x88500
80102faa:	68 c0 00 00 00       	push   $0xc0
80102faf:	e8 e8 fe ff ff       	call   80102e9c <lapicw>
80102fb4:	83 c4 08             	add    $0x8,%esp
  while(lapic[ICRLO] & DELIVS)
80102fb7:	90                   	nop
80102fb8:	a1 40 71 11 80       	mov    0x80117140,%eax
80102fbd:	05 00 03 00 00       	add    $0x300,%eax
80102fc2:	8b 00                	mov    (%eax),%eax
80102fc4:	25 00 10 00 00       	and    $0x1000,%eax
80102fc9:	85 c0                	test   %eax,%eax
80102fcb:	75 eb                	jne    80102fb8 <lapicinit+0xf9>
    ;

  // Enable interrupts on the APIC (but not on the processor).
  lapicw(TPR, 0);
80102fcd:	6a 00                	push   $0x0
80102fcf:	6a 20                	push   $0x20
80102fd1:	e8 c6 fe ff ff       	call   80102e9c <lapicw>
80102fd6:	83 c4 08             	add    $0x8,%esp
80102fd9:	eb 01                	jmp    80102fdc <lapicinit+0x11d>
    return;
80102fdb:	90                   	nop
}
80102fdc:	c9                   	leave  
80102fdd:	c3                   	ret    

80102fde <lapicid>:

int
lapicid(void)
{
80102fde:	55                   	push   %ebp
80102fdf:	89 e5                	mov    %esp,%ebp

  if (!lapic){
80102fe1:	a1 40 71 11 80       	mov    0x80117140,%eax
80102fe6:	85 c0                	test   %eax,%eax
80102fe8:	75 07                	jne    80102ff1 <lapicid+0x13>
    return 0;
80102fea:	b8 00 00 00 00       	mov    $0x0,%eax
80102fef:	eb 0d                	jmp    80102ffe <lapicid+0x20>
  }
  return lapic[ID] >> 24;
80102ff1:	a1 40 71 11 80       	mov    0x80117140,%eax
80102ff6:	83 c0 20             	add    $0x20,%eax
80102ff9:	8b 00                	mov    (%eax),%eax
80102ffb:	c1 e8 18             	shr    $0x18,%eax
}
80102ffe:	5d                   	pop    %ebp
80102fff:	c3                   	ret    

80103000 <lapiceoi>:

// Acknowledge interrupt.
void
lapiceoi(void)
{
80103000:	55                   	push   %ebp
80103001:	89 e5                	mov    %esp,%ebp
  if(lapic)
80103003:	a1 40 71 11 80       	mov    0x80117140,%eax
80103008:	85 c0                	test   %eax,%eax
8010300a:	74 0c                	je     80103018 <lapiceoi+0x18>
    lapicw(EOI, 0);
8010300c:	6a 00                	push   $0x0
8010300e:	6a 2c                	push   $0x2c
80103010:	e8 87 fe ff ff       	call   80102e9c <lapicw>
80103015:	83 c4 08             	add    $0x8,%esp
}
80103018:	90                   	nop
80103019:	c9                   	leave  
8010301a:	c3                   	ret    

8010301b <microdelay>:

// Spin for a given number of microseconds.
// On real hardware would want to tune this dynamically.
void
microdelay(int us)
{
8010301b:	55                   	push   %ebp
8010301c:	89 e5                	mov    %esp,%ebp
}
8010301e:	90                   	nop
8010301f:	5d                   	pop    %ebp
80103020:	c3                   	ret    

80103021 <lapicstartap>:

// Start additional processor running entry code at addr.
// See Appendix B of MultiProcessor Specification.
void
lapicstartap(uchar apicid, uint addr)
{
80103021:	55                   	push   %ebp
80103022:	89 e5                	mov    %esp,%ebp
80103024:	83 ec 14             	sub    $0x14,%esp
80103027:	8b 45 08             	mov    0x8(%ebp),%eax
8010302a:	88 45 ec             	mov    %al,-0x14(%ebp)
  ushort *wrv;

  // "The BSP must initialize CMOS shutdown code to 0AH
  // and the warm reset vector (DWORD based at 40:67) to point at
  // the AP startup code prior to the [universal startup algorithm]."
  outb(CMOS_PORT, 0xF);  // offset 0xF is shutdown code
8010302d:	6a 0f                	push   $0xf
8010302f:	6a 70                	push   $0x70
80103031:	e8 45 fe ff ff       	call   80102e7b <outb>
80103036:	83 c4 08             	add    $0x8,%esp
  outb(CMOS_PORT+1, 0x0A);
80103039:	6a 0a                	push   $0xa
8010303b:	6a 71                	push   $0x71
8010303d:	e8 39 fe ff ff       	call   80102e7b <outb>
80103042:	83 c4 08             	add    $0x8,%esp
  wrv = (ushort*)P2V((0x40<<4 | 0x67));  // Warm reset vector
80103045:	c7 45 f8 67 04 00 80 	movl   $0x80000467,-0x8(%ebp)
  wrv[0] = 0;
8010304c:	8b 45 f8             	mov    -0x8(%ebp),%eax
8010304f:	66 c7 00 00 00       	movw   $0x0,(%eax)
  wrv[1] = addr >> 4;
80103054:	8b 45 0c             	mov    0xc(%ebp),%eax
80103057:	c1 e8 04             	shr    $0x4,%eax
8010305a:	89 c2                	mov    %eax,%edx
8010305c:	8b 45 f8             	mov    -0x8(%ebp),%eax
8010305f:	83 c0 02             	add    $0x2,%eax
80103062:	66 89 10             	mov    %dx,(%eax)

  // "Universal startup algorithm."
  // Send INIT (level-triggered) interrupt to reset other CPU.
  lapicw(ICRHI, apicid<<24);
80103065:	0f b6 45 ec          	movzbl -0x14(%ebp),%eax
80103069:	c1 e0 18             	shl    $0x18,%eax
8010306c:	50                   	push   %eax
8010306d:	68 c4 00 00 00       	push   $0xc4
80103072:	e8 25 fe ff ff       	call   80102e9c <lapicw>
80103077:	83 c4 08             	add    $0x8,%esp
  lapicw(ICRLO, INIT | LEVEL | ASSERT);
8010307a:	68 00 c5 00 00       	push   $0xc500
8010307f:	68 c0 00 00 00       	push   $0xc0
80103084:	e8 13 fe ff ff       	call   80102e9c <lapicw>
80103089:	83 c4 08             	add    $0x8,%esp
  microdelay(200);
8010308c:	68 c8 00 00 00       	push   $0xc8
80103091:	e8 85 ff ff ff       	call   8010301b <microdelay>
80103096:	83 c4 04             	add    $0x4,%esp
  lapicw(ICRLO, INIT | LEVEL);
80103099:	68 00 85 00 00       	push   $0x8500
8010309e:	68 c0 00 00 00       	push   $0xc0
801030a3:	e8 f4 fd ff ff       	call   80102e9c <lapicw>
801030a8:	83 c4 08             	add    $0x8,%esp
  microdelay(100);    // should be 10ms, but too slow in Bochs!
801030ab:	6a 64                	push   $0x64
801030ad:	e8 69 ff ff ff       	call   8010301b <microdelay>
801030b2:	83 c4 04             	add    $0x4,%esp
  // Send startup IPI (twice!) to enter code.
  // Regular hardware is supposed to only accept a STARTUP
  // when it is in the halted state due to an INIT.  So the second
  // should be ignored, but it is part of the official Intel algorithm.
  // Bochs complains about the second one.  Too bad for Bochs.
  for(i = 0; i < 2; i++){
801030b5:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
801030bc:	eb 3d                	jmp    801030fb <lapicstartap+0xda>
    lapicw(ICRHI, apicid<<24);
801030be:	0f b6 45 ec          	movzbl -0x14(%ebp),%eax
801030c2:	c1 e0 18             	shl    $0x18,%eax
801030c5:	50                   	push   %eax
801030c6:	68 c4 00 00 00       	push   $0xc4
801030cb:	e8 cc fd ff ff       	call   80102e9c <lapicw>
801030d0:	83 c4 08             	add    $0x8,%esp
    lapicw(ICRLO, STARTUP | (addr>>12));
801030d3:	8b 45 0c             	mov    0xc(%ebp),%eax
801030d6:	c1 e8 0c             	shr    $0xc,%eax
801030d9:	80 cc 06             	or     $0x6,%ah
801030dc:	50                   	push   %eax
801030dd:	68 c0 00 00 00       	push   $0xc0
801030e2:	e8 b5 fd ff ff       	call   80102e9c <lapicw>
801030e7:	83 c4 08             	add    $0x8,%esp
    microdelay(200);
801030ea:	68 c8 00 00 00       	push   $0xc8
801030ef:	e8 27 ff ff ff       	call   8010301b <microdelay>
801030f4:	83 c4 04             	add    $0x4,%esp
  for(i = 0; i < 2; i++){
801030f7:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
801030fb:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
801030ff:	7e bd                	jle    801030be <lapicstartap+0x9d>
  }
}
80103101:	90                   	nop
80103102:	90                   	nop
80103103:	c9                   	leave  
80103104:	c3                   	ret    

80103105 <cmos_read>:
#define DAY     0x07
#define MONTH   0x08
#define YEAR    0x09

static uint cmos_read(uint reg)
{
80103105:	55                   	push   %ebp
80103106:	89 e5                	mov    %esp,%ebp
  outb(CMOS_PORT,  reg);
80103108:	8b 45 08             	mov    0x8(%ebp),%eax
8010310b:	0f b6 c0             	movzbl %al,%eax
8010310e:	50                   	push   %eax
8010310f:	6a 70                	push   $0x70
80103111:	e8 65 fd ff ff       	call   80102e7b <outb>
80103116:	83 c4 08             	add    $0x8,%esp
  microdelay(200);
80103119:	68 c8 00 00 00       	push   $0xc8
8010311e:	e8 f8 fe ff ff       	call   8010301b <microdelay>
80103123:	83 c4 04             	add    $0x4,%esp

  return inb(CMOS_RETURN);
80103126:	6a 71                	push   $0x71
80103128:	e8 31 fd ff ff       	call   80102e5e <inb>
8010312d:	83 c4 04             	add    $0x4,%esp
80103130:	0f b6 c0             	movzbl %al,%eax
}
80103133:	c9                   	leave  
80103134:	c3                   	ret    

80103135 <fill_rtcdate>:

static void fill_rtcdate(struct rtcdate *r)
{
80103135:	55                   	push   %ebp
80103136:	89 e5                	mov    %esp,%ebp
  r->second = cmos_read(SECS);
80103138:	6a 00                	push   $0x0
8010313a:	e8 c6 ff ff ff       	call   80103105 <cmos_read>
8010313f:	83 c4 04             	add    $0x4,%esp
80103142:	8b 55 08             	mov    0x8(%ebp),%edx
80103145:	89 02                	mov    %eax,(%edx)
  r->minute = cmos_read(MINS);
80103147:	6a 02                	push   $0x2
80103149:	e8 b7 ff ff ff       	call   80103105 <cmos_read>
8010314e:	83 c4 04             	add    $0x4,%esp
80103151:	8b 55 08             	mov    0x8(%ebp),%edx
80103154:	89 42 04             	mov    %eax,0x4(%edx)
  r->hour   = cmos_read(HOURS);
80103157:	6a 04                	push   $0x4
80103159:	e8 a7 ff ff ff       	call   80103105 <cmos_read>
8010315e:	83 c4 04             	add    $0x4,%esp
80103161:	8b 55 08             	mov    0x8(%ebp),%edx
80103164:	89 42 08             	mov    %eax,0x8(%edx)
  r->day    = cmos_read(DAY);
80103167:	6a 07                	push   $0x7
80103169:	e8 97 ff ff ff       	call   80103105 <cmos_read>
8010316e:	83 c4 04             	add    $0x4,%esp
80103171:	8b 55 08             	mov    0x8(%ebp),%edx
80103174:	89 42 0c             	mov    %eax,0xc(%edx)
  r->month  = cmos_read(MONTH);
80103177:	6a 08                	push   $0x8
80103179:	e8 87 ff ff ff       	call   80103105 <cmos_read>
8010317e:	83 c4 04             	add    $0x4,%esp
80103181:	8b 55 08             	mov    0x8(%ebp),%edx
80103184:	89 42 10             	mov    %eax,0x10(%edx)
  r->year   = cmos_read(YEAR);
80103187:	6a 09                	push   $0x9
80103189:	e8 77 ff ff ff       	call   80103105 <cmos_read>
8010318e:	83 c4 04             	add    $0x4,%esp
80103191:	8b 55 08             	mov    0x8(%ebp),%edx
80103194:	89 42 14             	mov    %eax,0x14(%edx)
}
80103197:	90                   	nop
80103198:	c9                   	leave  
80103199:	c3                   	ret    

8010319a <cmostime>:

// qemu seems to use 24-hour GWT and the values are BCD encoded
void cmostime(struct rtcdate *r)
{
8010319a:	55                   	push   %ebp
8010319b:	89 e5                	mov    %esp,%ebp
8010319d:	83 ec 48             	sub    $0x48,%esp
  struct rtcdate t1, t2;
  int sb, bcd;

  sb = cmos_read(CMOS_STATB);
801031a0:	6a 0b                	push   $0xb
801031a2:	e8 5e ff ff ff       	call   80103105 <cmos_read>
801031a7:	83 c4 04             	add    $0x4,%esp
801031aa:	89 45 f4             	mov    %eax,-0xc(%ebp)

  bcd = (sb & (1 << 2)) == 0;
801031ad:	8b 45 f4             	mov    -0xc(%ebp),%eax
801031b0:	83 e0 04             	and    $0x4,%eax
801031b3:	85 c0                	test   %eax,%eax
801031b5:	0f 94 c0             	sete   %al
801031b8:	0f b6 c0             	movzbl %al,%eax
801031bb:	89 45 f0             	mov    %eax,-0x10(%ebp)

  // make sure CMOS doesn't modify time while we read it
  for(;;) {
    fill_rtcdate(&t1);
801031be:	8d 45 d8             	lea    -0x28(%ebp),%eax
801031c1:	50                   	push   %eax
801031c2:	e8 6e ff ff ff       	call   80103135 <fill_rtcdate>
801031c7:	83 c4 04             	add    $0x4,%esp
    if(cmos_read(CMOS_STATA) & CMOS_UIP)
801031ca:	6a 0a                	push   $0xa
801031cc:	e8 34 ff ff ff       	call   80103105 <cmos_read>
801031d1:	83 c4 04             	add    $0x4,%esp
801031d4:	25 80 00 00 00       	and    $0x80,%eax
801031d9:	85 c0                	test   %eax,%eax
801031db:	75 27                	jne    80103204 <cmostime+0x6a>
        continue;
    fill_rtcdate(&t2);
801031dd:	8d 45 c0             	lea    -0x40(%ebp),%eax
801031e0:	50                   	push   %eax
801031e1:	e8 4f ff ff ff       	call   80103135 <fill_rtcdate>
801031e6:	83 c4 04             	add    $0x4,%esp
    if(memcmp(&t1, &t2, sizeof(t1)) == 0)
801031e9:	83 ec 04             	sub    $0x4,%esp
801031ec:	6a 18                	push   $0x18
801031ee:	8d 45 c0             	lea    -0x40(%ebp),%eax
801031f1:	50                   	push   %eax
801031f2:	8d 45 d8             	lea    -0x28(%ebp),%eax
801031f5:	50                   	push   %eax
801031f6:	e8 2a 1f 00 00       	call   80105125 <memcmp>
801031fb:	83 c4 10             	add    $0x10,%esp
801031fe:	85 c0                	test   %eax,%eax
80103200:	74 05                	je     80103207 <cmostime+0x6d>
80103202:	eb ba                	jmp    801031be <cmostime+0x24>
        continue;
80103204:	90                   	nop
    fill_rtcdate(&t1);
80103205:	eb b7                	jmp    801031be <cmostime+0x24>
      break;
80103207:	90                   	nop
  }

  // convert
  if(bcd) {
80103208:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
8010320c:	0f 84 b4 00 00 00    	je     801032c6 <cmostime+0x12c>
#define    CONV(x)     (t1.x = ((t1.x >> 4) * 10) + (t1.x & 0xf))
    CONV(second);
80103212:	8b 45 d8             	mov    -0x28(%ebp),%eax
80103215:	c1 e8 04             	shr    $0x4,%eax
80103218:	89 c2                	mov    %eax,%edx
8010321a:	89 d0                	mov    %edx,%eax
8010321c:	c1 e0 02             	shl    $0x2,%eax
8010321f:	01 d0                	add    %edx,%eax
80103221:	01 c0                	add    %eax,%eax
80103223:	89 c2                	mov    %eax,%edx
80103225:	8b 45 d8             	mov    -0x28(%ebp),%eax
80103228:	83 e0 0f             	and    $0xf,%eax
8010322b:	01 d0                	add    %edx,%eax
8010322d:	89 45 d8             	mov    %eax,-0x28(%ebp)
    CONV(minute);
80103230:	8b 45 dc             	mov    -0x24(%ebp),%eax
80103233:	c1 e8 04             	shr    $0x4,%eax
80103236:	89 c2                	mov    %eax,%edx
80103238:	89 d0                	mov    %edx,%eax
8010323a:	c1 e0 02             	shl    $0x2,%eax
8010323d:	01 d0                	add    %edx,%eax
8010323f:	01 c0                	add    %eax,%eax
80103241:	89 c2                	mov    %eax,%edx
80103243:	8b 45 dc             	mov    -0x24(%ebp),%eax
80103246:	83 e0 0f             	and    $0xf,%eax
80103249:	01 d0                	add    %edx,%eax
8010324b:	89 45 dc             	mov    %eax,-0x24(%ebp)
    CONV(hour  );
8010324e:	8b 45 e0             	mov    -0x20(%ebp),%eax
80103251:	c1 e8 04             	shr    $0x4,%eax
80103254:	89 c2                	mov    %eax,%edx
80103256:	89 d0                	mov    %edx,%eax
80103258:	c1 e0 02             	shl    $0x2,%eax
8010325b:	01 d0                	add    %edx,%eax
8010325d:	01 c0                	add    %eax,%eax
8010325f:	89 c2                	mov    %eax,%edx
80103261:	8b 45 e0             	mov    -0x20(%ebp),%eax
80103264:	83 e0 0f             	and    $0xf,%eax
80103267:	01 d0                	add    %edx,%eax
80103269:	89 45 e0             	mov    %eax,-0x20(%ebp)
    CONV(day   );
8010326c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010326f:	c1 e8 04             	shr    $0x4,%eax
80103272:	89 c2                	mov    %eax,%edx
80103274:	89 d0                	mov    %edx,%eax
80103276:	c1 e0 02             	shl    $0x2,%eax
80103279:	01 d0                	add    %edx,%eax
8010327b:	01 c0                	add    %eax,%eax
8010327d:	89 c2                	mov    %eax,%edx
8010327f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80103282:	83 e0 0f             	and    $0xf,%eax
80103285:	01 d0                	add    %edx,%eax
80103287:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    CONV(month );
8010328a:	8b 45 e8             	mov    -0x18(%ebp),%eax
8010328d:	c1 e8 04             	shr    $0x4,%eax
80103290:	89 c2                	mov    %eax,%edx
80103292:	89 d0                	mov    %edx,%eax
80103294:	c1 e0 02             	shl    $0x2,%eax
80103297:	01 d0                	add    %edx,%eax
80103299:	01 c0                	add    %eax,%eax
8010329b:	89 c2                	mov    %eax,%edx
8010329d:	8b 45 e8             	mov    -0x18(%ebp),%eax
801032a0:	83 e0 0f             	and    $0xf,%eax
801032a3:	01 d0                	add    %edx,%eax
801032a5:	89 45 e8             	mov    %eax,-0x18(%ebp)
    CONV(year  );
801032a8:	8b 45 ec             	mov    -0x14(%ebp),%eax
801032ab:	c1 e8 04             	shr    $0x4,%eax
801032ae:	89 c2                	mov    %eax,%edx
801032b0:	89 d0                	mov    %edx,%eax
801032b2:	c1 e0 02             	shl    $0x2,%eax
801032b5:	01 d0                	add    %edx,%eax
801032b7:	01 c0                	add    %eax,%eax
801032b9:	89 c2                	mov    %eax,%edx
801032bb:	8b 45 ec             	mov    -0x14(%ebp),%eax
801032be:	83 e0 0f             	and    $0xf,%eax
801032c1:	01 d0                	add    %edx,%eax
801032c3:	89 45 ec             	mov    %eax,-0x14(%ebp)
#undef     CONV
  }

  *r = t1;
801032c6:	8b 45 08             	mov    0x8(%ebp),%eax
801032c9:	8b 55 d8             	mov    -0x28(%ebp),%edx
801032cc:	89 10                	mov    %edx,(%eax)
801032ce:	8b 55 dc             	mov    -0x24(%ebp),%edx
801032d1:	89 50 04             	mov    %edx,0x4(%eax)
801032d4:	8b 55 e0             	mov    -0x20(%ebp),%edx
801032d7:	89 50 08             	mov    %edx,0x8(%eax)
801032da:	8b 55 e4             	mov    -0x1c(%ebp),%edx
801032dd:	89 50 0c             	mov    %edx,0xc(%eax)
801032e0:	8b 55 e8             	mov    -0x18(%ebp),%edx
801032e3:	89 50 10             	mov    %edx,0x10(%eax)
801032e6:	8b 55 ec             	mov    -0x14(%ebp),%edx
801032e9:	89 50 14             	mov    %edx,0x14(%eax)
  r->year += 2000;
801032ec:	8b 45 08             	mov    0x8(%ebp),%eax
801032ef:	8b 40 14             	mov    0x14(%eax),%eax
801032f2:	8d 90 d0 07 00 00    	lea    0x7d0(%eax),%edx
801032f8:	8b 45 08             	mov    0x8(%ebp),%eax
801032fb:	89 50 14             	mov    %edx,0x14(%eax)
}
801032fe:	90                   	nop
801032ff:	c9                   	leave  
80103300:	c3                   	ret    

80103301 <initlog>:
static void recover_from_log(void);
static void commit();

void
initlog(int dev)
{
80103301:	55                   	push   %ebp
80103302:	89 e5                	mov    %esp,%ebp
80103304:	83 ec 28             	sub    $0x28,%esp
  if (sizeof(struct logheader) >= BSIZE)
    panic("initlog: too big logheader");

  struct superblock sb;
  initlock(&log.lock, "log");
80103307:	83 ec 08             	sub    $0x8,%esp
8010330a:	68 b5 a8 10 80       	push   $0x8010a8b5
8010330f:	68 60 71 11 80       	push   $0x80117160
80103314:	e8 0d 1b 00 00       	call   80104e26 <initlock>
80103319:	83 c4 10             	add    $0x10,%esp
  readsb(dev, &sb);
8010331c:	83 ec 08             	sub    $0x8,%esp
8010331f:	8d 45 dc             	lea    -0x24(%ebp),%eax
80103322:	50                   	push   %eax
80103323:	ff 75 08             	push   0x8(%ebp)
80103326:	e8 a3 e0 ff ff       	call   801013ce <readsb>
8010332b:	83 c4 10             	add    $0x10,%esp
  log.start = sb.logstart;
8010332e:	8b 45 ec             	mov    -0x14(%ebp),%eax
80103331:	a3 94 71 11 80       	mov    %eax,0x80117194
  log.size = sb.nlog;
80103336:	8b 45 e8             	mov    -0x18(%ebp),%eax
80103339:	a3 98 71 11 80       	mov    %eax,0x80117198
  log.dev = dev;
8010333e:	8b 45 08             	mov    0x8(%ebp),%eax
80103341:	a3 a4 71 11 80       	mov    %eax,0x801171a4
  recover_from_log();
80103346:	e8 b3 01 00 00       	call   801034fe <recover_from_log>
}
8010334b:	90                   	nop
8010334c:	c9                   	leave  
8010334d:	c3                   	ret    

8010334e <install_trans>:

// Copy committed blocks from log to their home location
static void
install_trans(void)
{
8010334e:	55                   	push   %ebp
8010334f:	89 e5                	mov    %esp,%ebp
80103351:	83 ec 18             	sub    $0x18,%esp
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
80103354:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
8010335b:	e9 95 00 00 00       	jmp    801033f5 <install_trans+0xa7>
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
80103360:	8b 15 94 71 11 80    	mov    0x80117194,%edx
80103366:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103369:	01 d0                	add    %edx,%eax
8010336b:	83 c0 01             	add    $0x1,%eax
8010336e:	89 c2                	mov    %eax,%edx
80103370:	a1 a4 71 11 80       	mov    0x801171a4,%eax
80103375:	83 ec 08             	sub    $0x8,%esp
80103378:	52                   	push   %edx
80103379:	50                   	push   %eax
8010337a:	e8 82 ce ff ff       	call   80100201 <bread>
8010337f:	83 c4 10             	add    $0x10,%esp
80103382:	89 45 f0             	mov    %eax,-0x10(%ebp)
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
80103385:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103388:	83 c0 10             	add    $0x10,%eax
8010338b:	8b 04 85 6c 71 11 80 	mov    -0x7fee8e94(,%eax,4),%eax
80103392:	89 c2                	mov    %eax,%edx
80103394:	a1 a4 71 11 80       	mov    0x801171a4,%eax
80103399:	83 ec 08             	sub    $0x8,%esp
8010339c:	52                   	push   %edx
8010339d:	50                   	push   %eax
8010339e:	e8 5e ce ff ff       	call   80100201 <bread>
801033a3:	83 c4 10             	add    $0x10,%esp
801033a6:	89 45 ec             	mov    %eax,-0x14(%ebp)
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
801033a9:	8b 45 f0             	mov    -0x10(%ebp),%eax
801033ac:	8d 50 5c             	lea    0x5c(%eax),%edx
801033af:	8b 45 ec             	mov    -0x14(%ebp),%eax
801033b2:	83 c0 5c             	add    $0x5c,%eax
801033b5:	83 ec 04             	sub    $0x4,%esp
801033b8:	68 00 02 00 00       	push   $0x200
801033bd:	52                   	push   %edx
801033be:	50                   	push   %eax
801033bf:	e8 b9 1d 00 00       	call   8010517d <memmove>
801033c4:	83 c4 10             	add    $0x10,%esp
    bwrite(dbuf);  // write dst to disk
801033c7:	83 ec 0c             	sub    $0xc,%esp
801033ca:	ff 75 ec             	push   -0x14(%ebp)
801033cd:	e8 68 ce ff ff       	call   8010023a <bwrite>
801033d2:	83 c4 10             	add    $0x10,%esp
    brelse(lbuf);
801033d5:	83 ec 0c             	sub    $0xc,%esp
801033d8:	ff 75 f0             	push   -0x10(%ebp)
801033db:	e8 a3 ce ff ff       	call   80100283 <brelse>
801033e0:	83 c4 10             	add    $0x10,%esp
    brelse(dbuf);
801033e3:	83 ec 0c             	sub    $0xc,%esp
801033e6:	ff 75 ec             	push   -0x14(%ebp)
801033e9:	e8 95 ce ff ff       	call   80100283 <brelse>
801033ee:	83 c4 10             	add    $0x10,%esp
  for (tail = 0; tail < log.lh.n; tail++) {
801033f1:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
801033f5:	a1 a8 71 11 80       	mov    0x801171a8,%eax
801033fa:	39 45 f4             	cmp    %eax,-0xc(%ebp)
801033fd:	0f 8c 5d ff ff ff    	jl     80103360 <install_trans+0x12>
  }
}
80103403:	90                   	nop
80103404:	90                   	nop
80103405:	c9                   	leave  
80103406:	c3                   	ret    

80103407 <read_head>:

// Read the log header from disk into the in-memory log header
static void
read_head(void)
{
80103407:	55                   	push   %ebp
80103408:	89 e5                	mov    %esp,%ebp
8010340a:	83 ec 18             	sub    $0x18,%esp
  struct buf *buf = bread(log.dev, log.start);
8010340d:	a1 94 71 11 80       	mov    0x80117194,%eax
80103412:	89 c2                	mov    %eax,%edx
80103414:	a1 a4 71 11 80       	mov    0x801171a4,%eax
80103419:	83 ec 08             	sub    $0x8,%esp
8010341c:	52                   	push   %edx
8010341d:	50                   	push   %eax
8010341e:	e8 de cd ff ff       	call   80100201 <bread>
80103423:	83 c4 10             	add    $0x10,%esp
80103426:	89 45 f0             	mov    %eax,-0x10(%ebp)
  struct logheader *lh = (struct logheader *) (buf->data);
80103429:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010342c:	83 c0 5c             	add    $0x5c,%eax
8010342f:	89 45 ec             	mov    %eax,-0x14(%ebp)
  int i;
  log.lh.n = lh->n;
80103432:	8b 45 ec             	mov    -0x14(%ebp),%eax
80103435:	8b 00                	mov    (%eax),%eax
80103437:	a3 a8 71 11 80       	mov    %eax,0x801171a8
  for (i = 0; i < log.lh.n; i++) {
8010343c:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80103443:	eb 1b                	jmp    80103460 <read_head+0x59>
    log.lh.block[i] = lh->block[i];
80103445:	8b 45 ec             	mov    -0x14(%ebp),%eax
80103448:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010344b:	8b 44 90 04          	mov    0x4(%eax,%edx,4),%eax
8010344f:	8b 55 f4             	mov    -0xc(%ebp),%edx
80103452:	83 c2 10             	add    $0x10,%edx
80103455:	89 04 95 6c 71 11 80 	mov    %eax,-0x7fee8e94(,%edx,4)
  for (i = 0; i < log.lh.n; i++) {
8010345c:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80103460:	a1 a8 71 11 80       	mov    0x801171a8,%eax
80103465:	39 45 f4             	cmp    %eax,-0xc(%ebp)
80103468:	7c db                	jl     80103445 <read_head+0x3e>
  }
  brelse(buf);
8010346a:	83 ec 0c             	sub    $0xc,%esp
8010346d:	ff 75 f0             	push   -0x10(%ebp)
80103470:	e8 0e ce ff ff       	call   80100283 <brelse>
80103475:	83 c4 10             	add    $0x10,%esp
}
80103478:	90                   	nop
80103479:	c9                   	leave  
8010347a:	c3                   	ret    

8010347b <write_head>:
// Write in-memory log header to disk.
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
8010347b:	55                   	push   %ebp
8010347c:	89 e5                	mov    %esp,%ebp
8010347e:	83 ec 18             	sub    $0x18,%esp
  struct buf *buf = bread(log.dev, log.start);
80103481:	a1 94 71 11 80       	mov    0x80117194,%eax
80103486:	89 c2                	mov    %eax,%edx
80103488:	a1 a4 71 11 80       	mov    0x801171a4,%eax
8010348d:	83 ec 08             	sub    $0x8,%esp
80103490:	52                   	push   %edx
80103491:	50                   	push   %eax
80103492:	e8 6a cd ff ff       	call   80100201 <bread>
80103497:	83 c4 10             	add    $0x10,%esp
8010349a:	89 45 f0             	mov    %eax,-0x10(%ebp)
  struct logheader *hb = (struct logheader *) (buf->data);
8010349d:	8b 45 f0             	mov    -0x10(%ebp),%eax
801034a0:	83 c0 5c             	add    $0x5c,%eax
801034a3:	89 45 ec             	mov    %eax,-0x14(%ebp)
  int i;
  hb->n = log.lh.n;
801034a6:	8b 15 a8 71 11 80    	mov    0x801171a8,%edx
801034ac:	8b 45 ec             	mov    -0x14(%ebp),%eax
801034af:	89 10                	mov    %edx,(%eax)
  for (i = 0; i < log.lh.n; i++) {
801034b1:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
801034b8:	eb 1b                	jmp    801034d5 <write_head+0x5a>
    hb->block[i] = log.lh.block[i];
801034ba:	8b 45 f4             	mov    -0xc(%ebp),%eax
801034bd:	83 c0 10             	add    $0x10,%eax
801034c0:	8b 0c 85 6c 71 11 80 	mov    -0x7fee8e94(,%eax,4),%ecx
801034c7:	8b 45 ec             	mov    -0x14(%ebp),%eax
801034ca:	8b 55 f4             	mov    -0xc(%ebp),%edx
801034cd:	89 4c 90 04          	mov    %ecx,0x4(%eax,%edx,4)
  for (i = 0; i < log.lh.n; i++) {
801034d1:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
801034d5:	a1 a8 71 11 80       	mov    0x801171a8,%eax
801034da:	39 45 f4             	cmp    %eax,-0xc(%ebp)
801034dd:	7c db                	jl     801034ba <write_head+0x3f>
  }
  bwrite(buf);
801034df:	83 ec 0c             	sub    $0xc,%esp
801034e2:	ff 75 f0             	push   -0x10(%ebp)
801034e5:	e8 50 cd ff ff       	call   8010023a <bwrite>
801034ea:	83 c4 10             	add    $0x10,%esp
  brelse(buf);
801034ed:	83 ec 0c             	sub    $0xc,%esp
801034f0:	ff 75 f0             	push   -0x10(%ebp)
801034f3:	e8 8b cd ff ff       	call   80100283 <brelse>
801034f8:	83 c4 10             	add    $0x10,%esp
}
801034fb:	90                   	nop
801034fc:	c9                   	leave  
801034fd:	c3                   	ret    

801034fe <recover_from_log>:

static void
recover_from_log(void)
{
801034fe:	55                   	push   %ebp
801034ff:	89 e5                	mov    %esp,%ebp
80103501:	83 ec 08             	sub    $0x8,%esp
  read_head();
80103504:	e8 fe fe ff ff       	call   80103407 <read_head>
  install_trans(); // if committed, copy from log to disk
80103509:	e8 40 fe ff ff       	call   8010334e <install_trans>
  log.lh.n = 0;
8010350e:	c7 05 a8 71 11 80 00 	movl   $0x0,0x801171a8
80103515:	00 00 00 
  write_head(); // clear the log
80103518:	e8 5e ff ff ff       	call   8010347b <write_head>
}
8010351d:	90                   	nop
8010351e:	c9                   	leave  
8010351f:	c3                   	ret    

80103520 <begin_op>:

// called at the start of each FS system call.
void
begin_op(void)
{
80103520:	55                   	push   %ebp
80103521:	89 e5                	mov    %esp,%ebp
80103523:	83 ec 08             	sub    $0x8,%esp
  acquire(&log.lock);
80103526:	83 ec 0c             	sub    $0xc,%esp
80103529:	68 60 71 11 80       	push   $0x80117160
8010352e:	e8 15 19 00 00       	call   80104e48 <acquire>
80103533:	83 c4 10             	add    $0x10,%esp
  while(1){
    if(log.committing){
80103536:	a1 a0 71 11 80       	mov    0x801171a0,%eax
8010353b:	85 c0                	test   %eax,%eax
8010353d:	74 17                	je     80103556 <begin_op+0x36>
      sleep(&log, &log.lock);
8010353f:	83 ec 08             	sub    $0x8,%esp
80103542:	68 60 71 11 80       	push   $0x80117160
80103547:	68 60 71 11 80       	push   $0x80117160
8010354c:	e8 dc 14 00 00       	call   80104a2d <sleep>
80103551:	83 c4 10             	add    $0x10,%esp
80103554:	eb e0                	jmp    80103536 <begin_op+0x16>
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
80103556:	8b 0d a8 71 11 80    	mov    0x801171a8,%ecx
8010355c:	a1 9c 71 11 80       	mov    0x8011719c,%eax
80103561:	8d 50 01             	lea    0x1(%eax),%edx
80103564:	89 d0                	mov    %edx,%eax
80103566:	c1 e0 02             	shl    $0x2,%eax
80103569:	01 d0                	add    %edx,%eax
8010356b:	01 c0                	add    %eax,%eax
8010356d:	01 c8                	add    %ecx,%eax
8010356f:	83 f8 1e             	cmp    $0x1e,%eax
80103572:	7e 17                	jle    8010358b <begin_op+0x6b>
      // this op might exhaust log space; wait for commit.
      sleep(&log, &log.lock);
80103574:	83 ec 08             	sub    $0x8,%esp
80103577:	68 60 71 11 80       	push   $0x80117160
8010357c:	68 60 71 11 80       	push   $0x80117160
80103581:	e8 a7 14 00 00       	call   80104a2d <sleep>
80103586:	83 c4 10             	add    $0x10,%esp
80103589:	eb ab                	jmp    80103536 <begin_op+0x16>
    } else {
      log.outstanding += 1;
8010358b:	a1 9c 71 11 80       	mov    0x8011719c,%eax
80103590:	83 c0 01             	add    $0x1,%eax
80103593:	a3 9c 71 11 80       	mov    %eax,0x8011719c
      release(&log.lock);
80103598:	83 ec 0c             	sub    $0xc,%esp
8010359b:	68 60 71 11 80       	push   $0x80117160
801035a0:	e8 11 19 00 00       	call   80104eb6 <release>
801035a5:	83 c4 10             	add    $0x10,%esp
      break;
801035a8:	90                   	nop
    }
  }
}
801035a9:	90                   	nop
801035aa:	c9                   	leave  
801035ab:	c3                   	ret    

801035ac <end_op>:

// called at the end of each FS system call.
// commits if this was the last outstanding operation.
void
end_op(void)
{
801035ac:	55                   	push   %ebp
801035ad:	89 e5                	mov    %esp,%ebp
801035af:	83 ec 18             	sub    $0x18,%esp
  int do_commit = 0;
801035b2:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

  acquire(&log.lock);
801035b9:	83 ec 0c             	sub    $0xc,%esp
801035bc:	68 60 71 11 80       	push   $0x80117160
801035c1:	e8 82 18 00 00       	call   80104e48 <acquire>
801035c6:	83 c4 10             	add    $0x10,%esp
  log.outstanding -= 1;
801035c9:	a1 9c 71 11 80       	mov    0x8011719c,%eax
801035ce:	83 e8 01             	sub    $0x1,%eax
801035d1:	a3 9c 71 11 80       	mov    %eax,0x8011719c
  if(log.committing)
801035d6:	a1 a0 71 11 80       	mov    0x801171a0,%eax
801035db:	85 c0                	test   %eax,%eax
801035dd:	74 0d                	je     801035ec <end_op+0x40>
    panic("log.committing");
801035df:	83 ec 0c             	sub    $0xc,%esp
801035e2:	68 b9 a8 10 80       	push   $0x8010a8b9
801035e7:	e8 bd cf ff ff       	call   801005a9 <panic>
  if(log.outstanding == 0){
801035ec:	a1 9c 71 11 80       	mov    0x8011719c,%eax
801035f1:	85 c0                	test   %eax,%eax
801035f3:	75 13                	jne    80103608 <end_op+0x5c>
    do_commit = 1;
801035f5:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
    log.committing = 1;
801035fc:	c7 05 a0 71 11 80 01 	movl   $0x1,0x801171a0
80103603:	00 00 00 
80103606:	eb 10                	jmp    80103618 <end_op+0x6c>
  } else {
    // begin_op() may be waiting for log space,
    // and decrementing log.outstanding has decreased
    // the amount of reserved space.
    wakeup(&log);
80103608:	83 ec 0c             	sub    $0xc,%esp
8010360b:	68 60 71 11 80       	push   $0x80117160
80103610:	e8 ff 14 00 00       	call   80104b14 <wakeup>
80103615:	83 c4 10             	add    $0x10,%esp
  }
  release(&log.lock);
80103618:	83 ec 0c             	sub    $0xc,%esp
8010361b:	68 60 71 11 80       	push   $0x80117160
80103620:	e8 91 18 00 00       	call   80104eb6 <release>
80103625:	83 c4 10             	add    $0x10,%esp

  if(do_commit){
80103628:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
8010362c:	74 3f                	je     8010366d <end_op+0xc1>
    // call commit w/o holding locks, since not allowed
    // to sleep with locks.
    commit();
8010362e:	e8 f6 00 00 00       	call   80103729 <commit>
    acquire(&log.lock);
80103633:	83 ec 0c             	sub    $0xc,%esp
80103636:	68 60 71 11 80       	push   $0x80117160
8010363b:	e8 08 18 00 00       	call   80104e48 <acquire>
80103640:	83 c4 10             	add    $0x10,%esp
    log.committing = 0;
80103643:	c7 05 a0 71 11 80 00 	movl   $0x0,0x801171a0
8010364a:	00 00 00 
    wakeup(&log);
8010364d:	83 ec 0c             	sub    $0xc,%esp
80103650:	68 60 71 11 80       	push   $0x80117160
80103655:	e8 ba 14 00 00       	call   80104b14 <wakeup>
8010365a:	83 c4 10             	add    $0x10,%esp
    release(&log.lock);
8010365d:	83 ec 0c             	sub    $0xc,%esp
80103660:	68 60 71 11 80       	push   $0x80117160
80103665:	e8 4c 18 00 00       	call   80104eb6 <release>
8010366a:	83 c4 10             	add    $0x10,%esp
  }
}
8010366d:	90                   	nop
8010366e:	c9                   	leave  
8010366f:	c3                   	ret    

80103670 <write_log>:

// Copy modified blocks from cache to log.
static void
write_log(void)
{
80103670:	55                   	push   %ebp
80103671:	89 e5                	mov    %esp,%ebp
80103673:	83 ec 18             	sub    $0x18,%esp
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
80103676:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
8010367d:	e9 95 00 00 00       	jmp    80103717 <write_log+0xa7>
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
80103682:	8b 15 94 71 11 80    	mov    0x80117194,%edx
80103688:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010368b:	01 d0                	add    %edx,%eax
8010368d:	83 c0 01             	add    $0x1,%eax
80103690:	89 c2                	mov    %eax,%edx
80103692:	a1 a4 71 11 80       	mov    0x801171a4,%eax
80103697:	83 ec 08             	sub    $0x8,%esp
8010369a:	52                   	push   %edx
8010369b:	50                   	push   %eax
8010369c:	e8 60 cb ff ff       	call   80100201 <bread>
801036a1:	83 c4 10             	add    $0x10,%esp
801036a4:	89 45 f0             	mov    %eax,-0x10(%ebp)
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
801036a7:	8b 45 f4             	mov    -0xc(%ebp),%eax
801036aa:	83 c0 10             	add    $0x10,%eax
801036ad:	8b 04 85 6c 71 11 80 	mov    -0x7fee8e94(,%eax,4),%eax
801036b4:	89 c2                	mov    %eax,%edx
801036b6:	a1 a4 71 11 80       	mov    0x801171a4,%eax
801036bb:	83 ec 08             	sub    $0x8,%esp
801036be:	52                   	push   %edx
801036bf:	50                   	push   %eax
801036c0:	e8 3c cb ff ff       	call   80100201 <bread>
801036c5:	83 c4 10             	add    $0x10,%esp
801036c8:	89 45 ec             	mov    %eax,-0x14(%ebp)
    memmove(to->data, from->data, BSIZE);
801036cb:	8b 45 ec             	mov    -0x14(%ebp),%eax
801036ce:	8d 50 5c             	lea    0x5c(%eax),%edx
801036d1:	8b 45 f0             	mov    -0x10(%ebp),%eax
801036d4:	83 c0 5c             	add    $0x5c,%eax
801036d7:	83 ec 04             	sub    $0x4,%esp
801036da:	68 00 02 00 00       	push   $0x200
801036df:	52                   	push   %edx
801036e0:	50                   	push   %eax
801036e1:	e8 97 1a 00 00       	call   8010517d <memmove>
801036e6:	83 c4 10             	add    $0x10,%esp
    bwrite(to);  // write the log
801036e9:	83 ec 0c             	sub    $0xc,%esp
801036ec:	ff 75 f0             	push   -0x10(%ebp)
801036ef:	e8 46 cb ff ff       	call   8010023a <bwrite>
801036f4:	83 c4 10             	add    $0x10,%esp
    brelse(from);
801036f7:	83 ec 0c             	sub    $0xc,%esp
801036fa:	ff 75 ec             	push   -0x14(%ebp)
801036fd:	e8 81 cb ff ff       	call   80100283 <brelse>
80103702:	83 c4 10             	add    $0x10,%esp
    brelse(to);
80103705:	83 ec 0c             	sub    $0xc,%esp
80103708:	ff 75 f0             	push   -0x10(%ebp)
8010370b:	e8 73 cb ff ff       	call   80100283 <brelse>
80103710:	83 c4 10             	add    $0x10,%esp
  for (tail = 0; tail < log.lh.n; tail++) {
80103713:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80103717:	a1 a8 71 11 80       	mov    0x801171a8,%eax
8010371c:	39 45 f4             	cmp    %eax,-0xc(%ebp)
8010371f:	0f 8c 5d ff ff ff    	jl     80103682 <write_log+0x12>
  }
}
80103725:	90                   	nop
80103726:	90                   	nop
80103727:	c9                   	leave  
80103728:	c3                   	ret    

80103729 <commit>:

static void
commit()
{
80103729:	55                   	push   %ebp
8010372a:	89 e5                	mov    %esp,%ebp
8010372c:	83 ec 08             	sub    $0x8,%esp
  if (log.lh.n > 0) {
8010372f:	a1 a8 71 11 80       	mov    0x801171a8,%eax
80103734:	85 c0                	test   %eax,%eax
80103736:	7e 1e                	jle    80103756 <commit+0x2d>
    write_log();     // Write modified blocks from cache to log
80103738:	e8 33 ff ff ff       	call   80103670 <write_log>
    write_head();    // Write header to disk -- the real commit
8010373d:	e8 39 fd ff ff       	call   8010347b <write_head>
    install_trans(); // Now install writes to home locations
80103742:	e8 07 fc ff ff       	call   8010334e <install_trans>
    log.lh.n = 0;
80103747:	c7 05 a8 71 11 80 00 	movl   $0x0,0x801171a8
8010374e:	00 00 00 
    write_head();    // Erase the transaction from the log
80103751:	e8 25 fd ff ff       	call   8010347b <write_head>
  }
}
80103756:	90                   	nop
80103757:	c9                   	leave  
80103758:	c3                   	ret    

80103759 <log_write>:
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
80103759:	55                   	push   %ebp
8010375a:	89 e5                	mov    %esp,%ebp
8010375c:	83 ec 18             	sub    $0x18,%esp
  int i;

  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
8010375f:	a1 a8 71 11 80       	mov    0x801171a8,%eax
80103764:	83 f8 1d             	cmp    $0x1d,%eax
80103767:	7f 12                	jg     8010377b <log_write+0x22>
80103769:	a1 a8 71 11 80       	mov    0x801171a8,%eax
8010376e:	8b 15 98 71 11 80    	mov    0x80117198,%edx
80103774:	83 ea 01             	sub    $0x1,%edx
80103777:	39 d0                	cmp    %edx,%eax
80103779:	7c 0d                	jl     80103788 <log_write+0x2f>
    panic("too big a transaction");
8010377b:	83 ec 0c             	sub    $0xc,%esp
8010377e:	68 c8 a8 10 80       	push   $0x8010a8c8
80103783:	e8 21 ce ff ff       	call   801005a9 <panic>
  if (log.outstanding < 1)
80103788:	a1 9c 71 11 80       	mov    0x8011719c,%eax
8010378d:	85 c0                	test   %eax,%eax
8010378f:	7f 0d                	jg     8010379e <log_write+0x45>
    panic("log_write outside of trans");
80103791:	83 ec 0c             	sub    $0xc,%esp
80103794:	68 de a8 10 80       	push   $0x8010a8de
80103799:	e8 0b ce ff ff       	call   801005a9 <panic>

  acquire(&log.lock);
8010379e:	83 ec 0c             	sub    $0xc,%esp
801037a1:	68 60 71 11 80       	push   $0x80117160
801037a6:	e8 9d 16 00 00       	call   80104e48 <acquire>
801037ab:	83 c4 10             	add    $0x10,%esp
  for (i = 0; i < log.lh.n; i++) {
801037ae:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
801037b5:	eb 1d                	jmp    801037d4 <log_write+0x7b>
    if (log.lh.block[i] == b->blockno)   // log absorbtion
801037b7:	8b 45 f4             	mov    -0xc(%ebp),%eax
801037ba:	83 c0 10             	add    $0x10,%eax
801037bd:	8b 04 85 6c 71 11 80 	mov    -0x7fee8e94(,%eax,4),%eax
801037c4:	89 c2                	mov    %eax,%edx
801037c6:	8b 45 08             	mov    0x8(%ebp),%eax
801037c9:	8b 40 08             	mov    0x8(%eax),%eax
801037cc:	39 c2                	cmp    %eax,%edx
801037ce:	74 10                	je     801037e0 <log_write+0x87>
  for (i = 0; i < log.lh.n; i++) {
801037d0:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
801037d4:	a1 a8 71 11 80       	mov    0x801171a8,%eax
801037d9:	39 45 f4             	cmp    %eax,-0xc(%ebp)
801037dc:	7c d9                	jl     801037b7 <log_write+0x5e>
801037de:	eb 01                	jmp    801037e1 <log_write+0x88>
      break;
801037e0:	90                   	nop
  }
  log.lh.block[i] = b->blockno;
801037e1:	8b 45 08             	mov    0x8(%ebp),%eax
801037e4:	8b 40 08             	mov    0x8(%eax),%eax
801037e7:	89 c2                	mov    %eax,%edx
801037e9:	8b 45 f4             	mov    -0xc(%ebp),%eax
801037ec:	83 c0 10             	add    $0x10,%eax
801037ef:	89 14 85 6c 71 11 80 	mov    %edx,-0x7fee8e94(,%eax,4)
  if (i == log.lh.n)
801037f6:	a1 a8 71 11 80       	mov    0x801171a8,%eax
801037fb:	39 45 f4             	cmp    %eax,-0xc(%ebp)
801037fe:	75 0d                	jne    8010380d <log_write+0xb4>
    log.lh.n++;
80103800:	a1 a8 71 11 80       	mov    0x801171a8,%eax
80103805:	83 c0 01             	add    $0x1,%eax
80103808:	a3 a8 71 11 80       	mov    %eax,0x801171a8
  b->flags |= B_DIRTY; // prevent eviction
8010380d:	8b 45 08             	mov    0x8(%ebp),%eax
80103810:	8b 00                	mov    (%eax),%eax
80103812:	83 c8 04             	or     $0x4,%eax
80103815:	89 c2                	mov    %eax,%edx
80103817:	8b 45 08             	mov    0x8(%ebp),%eax
8010381a:	89 10                	mov    %edx,(%eax)
  release(&log.lock);
8010381c:	83 ec 0c             	sub    $0xc,%esp
8010381f:	68 60 71 11 80       	push   $0x80117160
80103824:	e8 8d 16 00 00       	call   80104eb6 <release>
80103829:	83 c4 10             	add    $0x10,%esp
}
8010382c:	90                   	nop
8010382d:	c9                   	leave  
8010382e:	c3                   	ret    

8010382f <xchg>:
  asm volatile("sti");
}

static inline uint
xchg(volatile uint *addr, uint newval)
{
8010382f:	55                   	push   %ebp
80103830:	89 e5                	mov    %esp,%ebp
80103832:	83 ec 10             	sub    $0x10,%esp
  uint result;

  // The + in "+m" denotes a read-modify-write operand.
  asm volatile("lock; xchgl %0, %1" :
80103835:	8b 55 08             	mov    0x8(%ebp),%edx
80103838:	8b 45 0c             	mov    0xc(%ebp),%eax
8010383b:	8b 4d 08             	mov    0x8(%ebp),%ecx
8010383e:	f0 87 02             	lock xchg %eax,(%edx)
80103841:	89 45 fc             	mov    %eax,-0x4(%ebp)
               "+m" (*addr), "=a" (result) :
               "1" (newval) :
               "cc");
  return result;
80103844:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
80103847:	c9                   	leave  
80103848:	c3                   	ret    

80103849 <main>:
// Bootstrap processor starts running C code here.
// Allocate a real stack and switch to it, first
// doing some setup required for memory allocator to work.
int
main(void)
{
80103849:	8d 4c 24 04          	lea    0x4(%esp),%ecx
8010384d:	83 e4 f0             	and    $0xfffffff0,%esp
80103850:	ff 71 fc             	push   -0x4(%ecx)
80103853:	55                   	push   %ebp
80103854:	89 e5                	mov    %esp,%ebp
80103856:	51                   	push   %ecx
80103857:	83 ec 04             	sub    $0x4,%esp
  graphic_init();
8010385a:	e8 74 4c 00 00       	call   801084d3 <graphic_init>
  kinit1(end, P2V(4*1024*1024)); // phys page allocator
8010385f:	83 ec 08             	sub    $0x8,%esp
80103862:	68 00 00 40 80       	push   $0x80400000
80103867:	68 00 c0 11 80       	push   $0x8011c000
8010386c:	e8 de f2 ff ff       	call   80102b4f <kinit1>
80103871:	83 c4 10             	add    $0x10,%esp
  kvmalloc();      // kernel page table
80103874:	e8 74 42 00 00       	call   80107aed <kvmalloc>
  mpinit_uefi();
80103879:	e8 1b 4a 00 00       	call   80108299 <mpinit_uefi>
  lapicinit();     // interrupt controller
8010387e:	e8 3c f6 ff ff       	call   80102ebf <lapicinit>
  seginit();       // segment descriptors
80103883:	e8 fd 3c 00 00       	call   80107585 <seginit>
  picinit();    // disable pic
80103888:	e8 9d 01 00 00       	call   80103a2a <picinit>
  ioapicinit();    // another interrupt controller
8010388d:	e8 d8 f1 ff ff       	call   80102a6a <ioapicinit>
  consoleinit();   // console hardware
80103892:	e8 68 d2 ff ff       	call   80100aff <consoleinit>
  uartinit();      // serial port
80103897:	e8 82 30 00 00       	call   8010691e <uartinit>
  pinit();         // process table
8010389c:	e8 c2 05 00 00       	call   80103e63 <pinit>
  tvinit();        // trap vectors
801038a1:	e8 49 2c 00 00       	call   801064ef <tvinit>
  binit();         // buffer cache
801038a6:	e8 bb c7 ff ff       	call   80100066 <binit>
  fileinit();      // file table
801038ab:	e8 0f d7 ff ff       	call   80100fbf <fileinit>
  ideinit();       // disk 
801038b0:	e8 6e ed ff ff       	call   80102623 <ideinit>
  startothers();   // start other processors
801038b5:	e8 8a 00 00 00       	call   80103944 <startothers>
  kinit2(P2V(4*1024*1024), P2V(PHYSTOP)); // must come after startothers()
801038ba:	83 ec 08             	sub    $0x8,%esp
801038bd:	68 00 00 00 a0       	push   $0xa0000000
801038c2:	68 00 00 40 80       	push   $0x80400000
801038c7:	e8 bc f2 ff ff       	call   80102b88 <kinit2>
801038cc:	83 c4 10             	add    $0x10,%esp
  pci_init();
801038cf:	e8 58 4e 00 00       	call   8010872c <pci_init>
  arp_scan();
801038d4:	e8 8f 5b 00 00       	call   80109468 <arp_scan>
  //i8254_recv();
  userinit();      // first user process
801038d9:	e8 63 07 00 00       	call   80104041 <userinit>

  mpmain();        // finish this processor's setup
801038de:	e8 1a 00 00 00       	call   801038fd <mpmain>

801038e3 <mpenter>:
}

// Other CPUs jump here from entryother.S.
static void
mpenter(void)
{
801038e3:	55                   	push   %ebp
801038e4:	89 e5                	mov    %esp,%ebp
801038e6:	83 ec 08             	sub    $0x8,%esp
  switchkvm();
801038e9:	e8 17 42 00 00       	call   80107b05 <switchkvm>
  seginit();
801038ee:	e8 92 3c 00 00       	call   80107585 <seginit>
  lapicinit();
801038f3:	e8 c7 f5 ff ff       	call   80102ebf <lapicinit>
  mpmain();
801038f8:	e8 00 00 00 00       	call   801038fd <mpmain>

801038fd <mpmain>:
}

// Common CPU setup code.
static void
mpmain(void)
{
801038fd:	55                   	push   %ebp
801038fe:	89 e5                	mov    %esp,%ebp
80103900:	53                   	push   %ebx
80103901:	83 ec 04             	sub    $0x4,%esp
  cprintf("cpu%d: starting %d\n", cpuid(), cpuid());
80103904:	e8 78 05 00 00       	call   80103e81 <cpuid>
80103909:	89 c3                	mov    %eax,%ebx
8010390b:	e8 71 05 00 00       	call   80103e81 <cpuid>
80103910:	83 ec 04             	sub    $0x4,%esp
80103913:	53                   	push   %ebx
80103914:	50                   	push   %eax
80103915:	68 f9 a8 10 80       	push   $0x8010a8f9
8010391a:	e8 d5 ca ff ff       	call   801003f4 <cprintf>
8010391f:	83 c4 10             	add    $0x10,%esp
  idtinit();       // load idt register
80103922:	e8 3e 2d 00 00       	call   80106665 <idtinit>
  xchg(&(mycpu()->started), 1); // tell startothers() we're up
80103927:	e8 70 05 00 00       	call   80103e9c <mycpu>
8010392c:	05 a0 00 00 00       	add    $0xa0,%eax
80103931:	83 ec 08             	sub    $0x8,%esp
80103934:	6a 01                	push   $0x1
80103936:	50                   	push   %eax
80103937:	e8 f3 fe ff ff       	call   8010382f <xchg>
8010393c:	83 c4 10             	add    $0x10,%esp
  scheduler();     // start running processes
8010393f:	e8 f8 0e 00 00       	call   8010483c <scheduler>

80103944 <startothers>:
pde_t entrypgdir[];  // For entry.S

// Start the non-boot (AP) processors.
static void
startothers(void)
{
80103944:	55                   	push   %ebp
80103945:	89 e5                	mov    %esp,%ebp
80103947:	83 ec 18             	sub    $0x18,%esp
  char *stack;

  // Write entry code to unused memory at 0x7000.
  // The linker has placed the image of entryother.S in
  // _binary_entryother_start.
  code = P2V(0x7000);
8010394a:	c7 45 f0 00 70 00 80 	movl   $0x80007000,-0x10(%ebp)
  memmove(code, _binary_entryother_start, (uint)_binary_entryother_size);
80103951:	b8 8a 00 00 00       	mov    $0x8a,%eax
80103956:	83 ec 04             	sub    $0x4,%esp
80103959:	50                   	push   %eax
8010395a:	68 18 f5 10 80       	push   $0x8010f518
8010395f:	ff 75 f0             	push   -0x10(%ebp)
80103962:	e8 16 18 00 00       	call   8010517d <memmove>
80103967:	83 c4 10             	add    $0x10,%esp

  for(c = cpus; c < cpus+ncpu; c++){
8010396a:	c7 45 f4 c0 9a 11 80 	movl   $0x80119ac0,-0xc(%ebp)
80103971:	eb 79                	jmp    801039ec <startothers+0xa8>
    if(c == mycpu()){  // We've started already.
80103973:	e8 24 05 00 00       	call   80103e9c <mycpu>
80103978:	39 45 f4             	cmp    %eax,-0xc(%ebp)
8010397b:	74 67                	je     801039e4 <startothers+0xa0>
      continue;
    }
    // Tell entryother.S what stack to use, where to enter, and what
    // pgdir to use. We cannot use kpgdir yet, because the AP processor
    // is running in low  memory, so we use entrypgdir for the APs too.
    stack = kalloc();
8010397d:	e8 02 f3 ff ff       	call   80102c84 <kalloc>
80103982:	89 45 ec             	mov    %eax,-0x14(%ebp)
    *(void**)(code-4) = stack + KSTACKSIZE;
80103985:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103988:	83 e8 04             	sub    $0x4,%eax
8010398b:	8b 55 ec             	mov    -0x14(%ebp),%edx
8010398e:	81 c2 00 10 00 00    	add    $0x1000,%edx
80103994:	89 10                	mov    %edx,(%eax)
    *(void**)(code-8) = mpenter;
80103996:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103999:	83 e8 08             	sub    $0x8,%eax
8010399c:	c7 00 e3 38 10 80    	movl   $0x801038e3,(%eax)
    *(int**)(code-12) = (void *) V2P(entrypgdir);
801039a2:	b8 00 e0 10 80       	mov    $0x8010e000,%eax
801039a7:	8d 90 00 00 00 80    	lea    -0x80000000(%eax),%edx
801039ad:	8b 45 f0             	mov    -0x10(%ebp),%eax
801039b0:	83 e8 0c             	sub    $0xc,%eax
801039b3:	89 10                	mov    %edx,(%eax)

    lapicstartap(c->apicid, V2P(code));
801039b5:	8b 45 f0             	mov    -0x10(%ebp),%eax
801039b8:	8d 90 00 00 00 80    	lea    -0x80000000(%eax),%edx
801039be:	8b 45 f4             	mov    -0xc(%ebp),%eax
801039c1:	0f b6 00             	movzbl (%eax),%eax
801039c4:	0f b6 c0             	movzbl %al,%eax
801039c7:	83 ec 08             	sub    $0x8,%esp
801039ca:	52                   	push   %edx
801039cb:	50                   	push   %eax
801039cc:	e8 50 f6 ff ff       	call   80103021 <lapicstartap>
801039d1:	83 c4 10             	add    $0x10,%esp

    // wait for cpu to finish mpmain()
    while(c->started == 0)
801039d4:	90                   	nop
801039d5:	8b 45 f4             	mov    -0xc(%ebp),%eax
801039d8:	8b 80 a0 00 00 00    	mov    0xa0(%eax),%eax
801039de:	85 c0                	test   %eax,%eax
801039e0:	74 f3                	je     801039d5 <startothers+0x91>
801039e2:	eb 01                	jmp    801039e5 <startothers+0xa1>
      continue;
801039e4:	90                   	nop
  for(c = cpus; c < cpus+ncpu; c++){
801039e5:	81 45 f4 b0 00 00 00 	addl   $0xb0,-0xc(%ebp)
801039ec:	a1 80 9d 11 80       	mov    0x80119d80,%eax
801039f1:	69 c0 b0 00 00 00    	imul   $0xb0,%eax,%eax
801039f7:	05 c0 9a 11 80       	add    $0x80119ac0,%eax
801039fc:	39 45 f4             	cmp    %eax,-0xc(%ebp)
801039ff:	0f 82 6e ff ff ff    	jb     80103973 <startothers+0x2f>
      ;
  }
}
80103a05:	90                   	nop
80103a06:	90                   	nop
80103a07:	c9                   	leave  
80103a08:	c3                   	ret    

80103a09 <outb>:
80103a09:	55                   	push   %ebp
80103a0a:	89 e5                	mov    %esp,%ebp
80103a0c:	83 ec 08             	sub    $0x8,%esp
80103a0f:	8b 45 08             	mov    0x8(%ebp),%eax
80103a12:	8b 55 0c             	mov    0xc(%ebp),%edx
80103a15:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
80103a19:	89 d0                	mov    %edx,%eax
80103a1b:	88 45 f8             	mov    %al,-0x8(%ebp)
80103a1e:	0f b6 45 f8          	movzbl -0x8(%ebp),%eax
80103a22:	0f b7 55 fc          	movzwl -0x4(%ebp),%edx
80103a26:	ee                   	out    %al,(%dx)
80103a27:	90                   	nop
80103a28:	c9                   	leave  
80103a29:	c3                   	ret    

80103a2a <picinit>:
80103a2a:	55                   	push   %ebp
80103a2b:	89 e5                	mov    %esp,%ebp
80103a2d:	68 ff 00 00 00       	push   $0xff
80103a32:	6a 21                	push   $0x21
80103a34:	e8 d0 ff ff ff       	call   80103a09 <outb>
80103a39:	83 c4 08             	add    $0x8,%esp
80103a3c:	68 ff 00 00 00       	push   $0xff
80103a41:	68 a1 00 00 00       	push   $0xa1
80103a46:	e8 be ff ff ff       	call   80103a09 <outb>
80103a4b:	83 c4 08             	add    $0x8,%esp
80103a4e:	90                   	nop
80103a4f:	c9                   	leave  
80103a50:	c3                   	ret    

80103a51 <pipealloc>:
  int writeopen;  // write fd is still open
};

int
pipealloc(struct file **f0, struct file **f1)
{
80103a51:	55                   	push   %ebp
80103a52:	89 e5                	mov    %esp,%ebp
80103a54:	83 ec 18             	sub    $0x18,%esp
  struct pipe *p;

  p = 0;
80103a57:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  *f0 = *f1 = 0;
80103a5e:	8b 45 0c             	mov    0xc(%ebp),%eax
80103a61:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
80103a67:	8b 45 0c             	mov    0xc(%ebp),%eax
80103a6a:	8b 10                	mov    (%eax),%edx
80103a6c:	8b 45 08             	mov    0x8(%ebp),%eax
80103a6f:	89 10                	mov    %edx,(%eax)
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
80103a71:	e8 67 d5 ff ff       	call   80100fdd <filealloc>
80103a76:	8b 55 08             	mov    0x8(%ebp),%edx
80103a79:	89 02                	mov    %eax,(%edx)
80103a7b:	8b 45 08             	mov    0x8(%ebp),%eax
80103a7e:	8b 00                	mov    (%eax),%eax
80103a80:	85 c0                	test   %eax,%eax
80103a82:	0f 84 c8 00 00 00    	je     80103b50 <pipealloc+0xff>
80103a88:	e8 50 d5 ff ff       	call   80100fdd <filealloc>
80103a8d:	8b 55 0c             	mov    0xc(%ebp),%edx
80103a90:	89 02                	mov    %eax,(%edx)
80103a92:	8b 45 0c             	mov    0xc(%ebp),%eax
80103a95:	8b 00                	mov    (%eax),%eax
80103a97:	85 c0                	test   %eax,%eax
80103a99:	0f 84 b1 00 00 00    	je     80103b50 <pipealloc+0xff>
    goto bad;
  if((p = (struct pipe*)kalloc()) == 0)
80103a9f:	e8 e0 f1 ff ff       	call   80102c84 <kalloc>
80103aa4:	89 45 f4             	mov    %eax,-0xc(%ebp)
80103aa7:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80103aab:	0f 84 a2 00 00 00    	je     80103b53 <pipealloc+0x102>
    goto bad;
  p->readopen = 1;
80103ab1:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103ab4:	c7 80 3c 02 00 00 01 	movl   $0x1,0x23c(%eax)
80103abb:	00 00 00 
  p->writeopen = 1;
80103abe:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103ac1:	c7 80 40 02 00 00 01 	movl   $0x1,0x240(%eax)
80103ac8:	00 00 00 
  p->nwrite = 0;
80103acb:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103ace:	c7 80 38 02 00 00 00 	movl   $0x0,0x238(%eax)
80103ad5:	00 00 00 
  p->nread = 0;
80103ad8:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103adb:	c7 80 34 02 00 00 00 	movl   $0x0,0x234(%eax)
80103ae2:	00 00 00 
  initlock(&p->lock, "pipe");
80103ae5:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103ae8:	83 ec 08             	sub    $0x8,%esp
80103aeb:	68 0d a9 10 80       	push   $0x8010a90d
80103af0:	50                   	push   %eax
80103af1:	e8 30 13 00 00       	call   80104e26 <initlock>
80103af6:	83 c4 10             	add    $0x10,%esp
  (*f0)->type = FD_PIPE;
80103af9:	8b 45 08             	mov    0x8(%ebp),%eax
80103afc:	8b 00                	mov    (%eax),%eax
80103afe:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  (*f0)->readable = 1;
80103b04:	8b 45 08             	mov    0x8(%ebp),%eax
80103b07:	8b 00                	mov    (%eax),%eax
80103b09:	c6 40 08 01          	movb   $0x1,0x8(%eax)
  (*f0)->writable = 0;
80103b0d:	8b 45 08             	mov    0x8(%ebp),%eax
80103b10:	8b 00                	mov    (%eax),%eax
80103b12:	c6 40 09 00          	movb   $0x0,0x9(%eax)
  (*f0)->pipe = p;
80103b16:	8b 45 08             	mov    0x8(%ebp),%eax
80103b19:	8b 00                	mov    (%eax),%eax
80103b1b:	8b 55 f4             	mov    -0xc(%ebp),%edx
80103b1e:	89 50 0c             	mov    %edx,0xc(%eax)
  (*f1)->type = FD_PIPE;
80103b21:	8b 45 0c             	mov    0xc(%ebp),%eax
80103b24:	8b 00                	mov    (%eax),%eax
80103b26:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  (*f1)->readable = 0;
80103b2c:	8b 45 0c             	mov    0xc(%ebp),%eax
80103b2f:	8b 00                	mov    (%eax),%eax
80103b31:	c6 40 08 00          	movb   $0x0,0x8(%eax)
  (*f1)->writable = 1;
80103b35:	8b 45 0c             	mov    0xc(%ebp),%eax
80103b38:	8b 00                	mov    (%eax),%eax
80103b3a:	c6 40 09 01          	movb   $0x1,0x9(%eax)
  (*f1)->pipe = p;
80103b3e:	8b 45 0c             	mov    0xc(%ebp),%eax
80103b41:	8b 00                	mov    (%eax),%eax
80103b43:	8b 55 f4             	mov    -0xc(%ebp),%edx
80103b46:	89 50 0c             	mov    %edx,0xc(%eax)
  return 0;
80103b49:	b8 00 00 00 00       	mov    $0x0,%eax
80103b4e:	eb 51                	jmp    80103ba1 <pipealloc+0x150>
    goto bad;
80103b50:	90                   	nop
80103b51:	eb 01                	jmp    80103b54 <pipealloc+0x103>
    goto bad;
80103b53:	90                   	nop

//PAGEBREAK: 20
 bad:
  if(p)
80103b54:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80103b58:	74 0e                	je     80103b68 <pipealloc+0x117>
    kfree((char*)p);
80103b5a:	83 ec 0c             	sub    $0xc,%esp
80103b5d:	ff 75 f4             	push   -0xc(%ebp)
80103b60:	e8 85 f0 ff ff       	call   80102bea <kfree>
80103b65:	83 c4 10             	add    $0x10,%esp
  if(*f0)
80103b68:	8b 45 08             	mov    0x8(%ebp),%eax
80103b6b:	8b 00                	mov    (%eax),%eax
80103b6d:	85 c0                	test   %eax,%eax
80103b6f:	74 11                	je     80103b82 <pipealloc+0x131>
    fileclose(*f0);
80103b71:	8b 45 08             	mov    0x8(%ebp),%eax
80103b74:	8b 00                	mov    (%eax),%eax
80103b76:	83 ec 0c             	sub    $0xc,%esp
80103b79:	50                   	push   %eax
80103b7a:	e8 1c d5 ff ff       	call   8010109b <fileclose>
80103b7f:	83 c4 10             	add    $0x10,%esp
  if(*f1)
80103b82:	8b 45 0c             	mov    0xc(%ebp),%eax
80103b85:	8b 00                	mov    (%eax),%eax
80103b87:	85 c0                	test   %eax,%eax
80103b89:	74 11                	je     80103b9c <pipealloc+0x14b>
    fileclose(*f1);
80103b8b:	8b 45 0c             	mov    0xc(%ebp),%eax
80103b8e:	8b 00                	mov    (%eax),%eax
80103b90:	83 ec 0c             	sub    $0xc,%esp
80103b93:	50                   	push   %eax
80103b94:	e8 02 d5 ff ff       	call   8010109b <fileclose>
80103b99:	83 c4 10             	add    $0x10,%esp
  return -1;
80103b9c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80103ba1:	c9                   	leave  
80103ba2:	c3                   	ret    

80103ba3 <pipeclose>:

void
pipeclose(struct pipe *p, int writable)
{
80103ba3:	55                   	push   %ebp
80103ba4:	89 e5                	mov    %esp,%ebp
80103ba6:	83 ec 08             	sub    $0x8,%esp
  acquire(&p->lock);
80103ba9:	8b 45 08             	mov    0x8(%ebp),%eax
80103bac:	83 ec 0c             	sub    $0xc,%esp
80103baf:	50                   	push   %eax
80103bb0:	e8 93 12 00 00       	call   80104e48 <acquire>
80103bb5:	83 c4 10             	add    $0x10,%esp
  if(writable){
80103bb8:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
80103bbc:	74 23                	je     80103be1 <pipeclose+0x3e>
    p->writeopen = 0;
80103bbe:	8b 45 08             	mov    0x8(%ebp),%eax
80103bc1:	c7 80 40 02 00 00 00 	movl   $0x0,0x240(%eax)
80103bc8:	00 00 00 
    wakeup(&p->nread);
80103bcb:	8b 45 08             	mov    0x8(%ebp),%eax
80103bce:	05 34 02 00 00       	add    $0x234,%eax
80103bd3:	83 ec 0c             	sub    $0xc,%esp
80103bd6:	50                   	push   %eax
80103bd7:	e8 38 0f 00 00       	call   80104b14 <wakeup>
80103bdc:	83 c4 10             	add    $0x10,%esp
80103bdf:	eb 21                	jmp    80103c02 <pipeclose+0x5f>
  } else {
    p->readopen = 0;
80103be1:	8b 45 08             	mov    0x8(%ebp),%eax
80103be4:	c7 80 3c 02 00 00 00 	movl   $0x0,0x23c(%eax)
80103beb:	00 00 00 
    wakeup(&p->nwrite);
80103bee:	8b 45 08             	mov    0x8(%ebp),%eax
80103bf1:	05 38 02 00 00       	add    $0x238,%eax
80103bf6:	83 ec 0c             	sub    $0xc,%esp
80103bf9:	50                   	push   %eax
80103bfa:	e8 15 0f 00 00       	call   80104b14 <wakeup>
80103bff:	83 c4 10             	add    $0x10,%esp
  }
  if(p->readopen == 0 && p->writeopen == 0){
80103c02:	8b 45 08             	mov    0x8(%ebp),%eax
80103c05:	8b 80 3c 02 00 00    	mov    0x23c(%eax),%eax
80103c0b:	85 c0                	test   %eax,%eax
80103c0d:	75 2c                	jne    80103c3b <pipeclose+0x98>
80103c0f:	8b 45 08             	mov    0x8(%ebp),%eax
80103c12:	8b 80 40 02 00 00    	mov    0x240(%eax),%eax
80103c18:	85 c0                	test   %eax,%eax
80103c1a:	75 1f                	jne    80103c3b <pipeclose+0x98>
    release(&p->lock);
80103c1c:	8b 45 08             	mov    0x8(%ebp),%eax
80103c1f:	83 ec 0c             	sub    $0xc,%esp
80103c22:	50                   	push   %eax
80103c23:	e8 8e 12 00 00       	call   80104eb6 <release>
80103c28:	83 c4 10             	add    $0x10,%esp
    kfree((char*)p);
80103c2b:	83 ec 0c             	sub    $0xc,%esp
80103c2e:	ff 75 08             	push   0x8(%ebp)
80103c31:	e8 b4 ef ff ff       	call   80102bea <kfree>
80103c36:	83 c4 10             	add    $0x10,%esp
80103c39:	eb 10                	jmp    80103c4b <pipeclose+0xa8>
  } else
    release(&p->lock);
80103c3b:	8b 45 08             	mov    0x8(%ebp),%eax
80103c3e:	83 ec 0c             	sub    $0xc,%esp
80103c41:	50                   	push   %eax
80103c42:	e8 6f 12 00 00       	call   80104eb6 <release>
80103c47:	83 c4 10             	add    $0x10,%esp
}
80103c4a:	90                   	nop
80103c4b:	90                   	nop
80103c4c:	c9                   	leave  
80103c4d:	c3                   	ret    

80103c4e <pipewrite>:

//PAGEBREAK: 40
int
pipewrite(struct pipe *p, char *addr, int n)
{
80103c4e:	55                   	push   %ebp
80103c4f:	89 e5                	mov    %esp,%ebp
80103c51:	53                   	push   %ebx
80103c52:	83 ec 14             	sub    $0x14,%esp
  int i;

  acquire(&p->lock);
80103c55:	8b 45 08             	mov    0x8(%ebp),%eax
80103c58:	83 ec 0c             	sub    $0xc,%esp
80103c5b:	50                   	push   %eax
80103c5c:	e8 e7 11 00 00       	call   80104e48 <acquire>
80103c61:	83 c4 10             	add    $0x10,%esp
  for(i = 0; i < n; i++){
80103c64:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80103c6b:	e9 ad 00 00 00       	jmp    80103d1d <pipewrite+0xcf>
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
      if(p->readopen == 0 || myproc()->killed){
80103c70:	8b 45 08             	mov    0x8(%ebp),%eax
80103c73:	8b 80 3c 02 00 00    	mov    0x23c(%eax),%eax
80103c79:	85 c0                	test   %eax,%eax
80103c7b:	74 0c                	je     80103c89 <pipewrite+0x3b>
80103c7d:	e8 92 02 00 00       	call   80103f14 <myproc>
80103c82:	8b 40 24             	mov    0x24(%eax),%eax
80103c85:	85 c0                	test   %eax,%eax
80103c87:	74 19                	je     80103ca2 <pipewrite+0x54>
        release(&p->lock);
80103c89:	8b 45 08             	mov    0x8(%ebp),%eax
80103c8c:	83 ec 0c             	sub    $0xc,%esp
80103c8f:	50                   	push   %eax
80103c90:	e8 21 12 00 00       	call   80104eb6 <release>
80103c95:	83 c4 10             	add    $0x10,%esp
        return -1;
80103c98:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80103c9d:	e9 a9 00 00 00       	jmp    80103d4b <pipewrite+0xfd>
      }
      wakeup(&p->nread);
80103ca2:	8b 45 08             	mov    0x8(%ebp),%eax
80103ca5:	05 34 02 00 00       	add    $0x234,%eax
80103caa:	83 ec 0c             	sub    $0xc,%esp
80103cad:	50                   	push   %eax
80103cae:	e8 61 0e 00 00       	call   80104b14 <wakeup>
80103cb3:	83 c4 10             	add    $0x10,%esp
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
80103cb6:	8b 45 08             	mov    0x8(%ebp),%eax
80103cb9:	8b 55 08             	mov    0x8(%ebp),%edx
80103cbc:	81 c2 38 02 00 00    	add    $0x238,%edx
80103cc2:	83 ec 08             	sub    $0x8,%esp
80103cc5:	50                   	push   %eax
80103cc6:	52                   	push   %edx
80103cc7:	e8 61 0d 00 00       	call   80104a2d <sleep>
80103ccc:	83 c4 10             	add    $0x10,%esp
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
80103ccf:	8b 45 08             	mov    0x8(%ebp),%eax
80103cd2:	8b 90 38 02 00 00    	mov    0x238(%eax),%edx
80103cd8:	8b 45 08             	mov    0x8(%ebp),%eax
80103cdb:	8b 80 34 02 00 00    	mov    0x234(%eax),%eax
80103ce1:	05 00 02 00 00       	add    $0x200,%eax
80103ce6:	39 c2                	cmp    %eax,%edx
80103ce8:	74 86                	je     80103c70 <pipewrite+0x22>
    }
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
80103cea:	8b 55 f4             	mov    -0xc(%ebp),%edx
80103ced:	8b 45 0c             	mov    0xc(%ebp),%eax
80103cf0:	8d 1c 02             	lea    (%edx,%eax,1),%ebx
80103cf3:	8b 45 08             	mov    0x8(%ebp),%eax
80103cf6:	8b 80 38 02 00 00    	mov    0x238(%eax),%eax
80103cfc:	8d 48 01             	lea    0x1(%eax),%ecx
80103cff:	8b 55 08             	mov    0x8(%ebp),%edx
80103d02:	89 8a 38 02 00 00    	mov    %ecx,0x238(%edx)
80103d08:	25 ff 01 00 00       	and    $0x1ff,%eax
80103d0d:	89 c1                	mov    %eax,%ecx
80103d0f:	0f b6 13             	movzbl (%ebx),%edx
80103d12:	8b 45 08             	mov    0x8(%ebp),%eax
80103d15:	88 54 08 34          	mov    %dl,0x34(%eax,%ecx,1)
  for(i = 0; i < n; i++){
80103d19:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80103d1d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103d20:	3b 45 10             	cmp    0x10(%ebp),%eax
80103d23:	7c aa                	jl     80103ccf <pipewrite+0x81>
  }
  wakeup(&p->nread);  //DOC: pipewrite-wakeup1
80103d25:	8b 45 08             	mov    0x8(%ebp),%eax
80103d28:	05 34 02 00 00       	add    $0x234,%eax
80103d2d:	83 ec 0c             	sub    $0xc,%esp
80103d30:	50                   	push   %eax
80103d31:	e8 de 0d 00 00       	call   80104b14 <wakeup>
80103d36:	83 c4 10             	add    $0x10,%esp
  release(&p->lock);
80103d39:	8b 45 08             	mov    0x8(%ebp),%eax
80103d3c:	83 ec 0c             	sub    $0xc,%esp
80103d3f:	50                   	push   %eax
80103d40:	e8 71 11 00 00       	call   80104eb6 <release>
80103d45:	83 c4 10             	add    $0x10,%esp
  return n;
80103d48:	8b 45 10             	mov    0x10(%ebp),%eax
}
80103d4b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103d4e:	c9                   	leave  
80103d4f:	c3                   	ret    

80103d50 <piperead>:

int
piperead(struct pipe *p, char *addr, int n)
{
80103d50:	55                   	push   %ebp
80103d51:	89 e5                	mov    %esp,%ebp
80103d53:	83 ec 18             	sub    $0x18,%esp
  int i;

  acquire(&p->lock);
80103d56:	8b 45 08             	mov    0x8(%ebp),%eax
80103d59:	83 ec 0c             	sub    $0xc,%esp
80103d5c:	50                   	push   %eax
80103d5d:	e8 e6 10 00 00       	call   80104e48 <acquire>
80103d62:	83 c4 10             	add    $0x10,%esp
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
80103d65:	eb 3e                	jmp    80103da5 <piperead+0x55>
    if(myproc()->killed){
80103d67:	e8 a8 01 00 00       	call   80103f14 <myproc>
80103d6c:	8b 40 24             	mov    0x24(%eax),%eax
80103d6f:	85 c0                	test   %eax,%eax
80103d71:	74 19                	je     80103d8c <piperead+0x3c>
      release(&p->lock);
80103d73:	8b 45 08             	mov    0x8(%ebp),%eax
80103d76:	83 ec 0c             	sub    $0xc,%esp
80103d79:	50                   	push   %eax
80103d7a:	e8 37 11 00 00       	call   80104eb6 <release>
80103d7f:	83 c4 10             	add    $0x10,%esp
      return -1;
80103d82:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80103d87:	e9 be 00 00 00       	jmp    80103e4a <piperead+0xfa>
    }
    sleep(&p->nread, &p->lock); //DOC: piperead-sleep
80103d8c:	8b 45 08             	mov    0x8(%ebp),%eax
80103d8f:	8b 55 08             	mov    0x8(%ebp),%edx
80103d92:	81 c2 34 02 00 00    	add    $0x234,%edx
80103d98:	83 ec 08             	sub    $0x8,%esp
80103d9b:	50                   	push   %eax
80103d9c:	52                   	push   %edx
80103d9d:	e8 8b 0c 00 00       	call   80104a2d <sleep>
80103da2:	83 c4 10             	add    $0x10,%esp
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
80103da5:	8b 45 08             	mov    0x8(%ebp),%eax
80103da8:	8b 90 34 02 00 00    	mov    0x234(%eax),%edx
80103dae:	8b 45 08             	mov    0x8(%ebp),%eax
80103db1:	8b 80 38 02 00 00    	mov    0x238(%eax),%eax
80103db7:	39 c2                	cmp    %eax,%edx
80103db9:	75 0d                	jne    80103dc8 <piperead+0x78>
80103dbb:	8b 45 08             	mov    0x8(%ebp),%eax
80103dbe:	8b 80 40 02 00 00    	mov    0x240(%eax),%eax
80103dc4:	85 c0                	test   %eax,%eax
80103dc6:	75 9f                	jne    80103d67 <piperead+0x17>
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
80103dc8:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80103dcf:	eb 48                	jmp    80103e19 <piperead+0xc9>
    if(p->nread == p->nwrite)
80103dd1:	8b 45 08             	mov    0x8(%ebp),%eax
80103dd4:	8b 90 34 02 00 00    	mov    0x234(%eax),%edx
80103dda:	8b 45 08             	mov    0x8(%ebp),%eax
80103ddd:	8b 80 38 02 00 00    	mov    0x238(%eax),%eax
80103de3:	39 c2                	cmp    %eax,%edx
80103de5:	74 3c                	je     80103e23 <piperead+0xd3>
      break;
    addr[i] = p->data[p->nread++ % PIPESIZE];
80103de7:	8b 45 08             	mov    0x8(%ebp),%eax
80103dea:	8b 80 34 02 00 00    	mov    0x234(%eax),%eax
80103df0:	8d 48 01             	lea    0x1(%eax),%ecx
80103df3:	8b 55 08             	mov    0x8(%ebp),%edx
80103df6:	89 8a 34 02 00 00    	mov    %ecx,0x234(%edx)
80103dfc:	25 ff 01 00 00       	and    $0x1ff,%eax
80103e01:	89 c1                	mov    %eax,%ecx
80103e03:	8b 55 f4             	mov    -0xc(%ebp),%edx
80103e06:	8b 45 0c             	mov    0xc(%ebp),%eax
80103e09:	01 c2                	add    %eax,%edx
80103e0b:	8b 45 08             	mov    0x8(%ebp),%eax
80103e0e:	0f b6 44 08 34       	movzbl 0x34(%eax,%ecx,1),%eax
80103e13:	88 02                	mov    %al,(%edx)
  for(i = 0; i < n; i++){  //DOC: piperead-copy
80103e15:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80103e19:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103e1c:	3b 45 10             	cmp    0x10(%ebp),%eax
80103e1f:	7c b0                	jl     80103dd1 <piperead+0x81>
80103e21:	eb 01                	jmp    80103e24 <piperead+0xd4>
      break;
80103e23:	90                   	nop
  }
  wakeup(&p->nwrite);  //DOC: piperead-wakeup
80103e24:	8b 45 08             	mov    0x8(%ebp),%eax
80103e27:	05 38 02 00 00       	add    $0x238,%eax
80103e2c:	83 ec 0c             	sub    $0xc,%esp
80103e2f:	50                   	push   %eax
80103e30:	e8 df 0c 00 00       	call   80104b14 <wakeup>
80103e35:	83 c4 10             	add    $0x10,%esp
  release(&p->lock);
80103e38:	8b 45 08             	mov    0x8(%ebp),%eax
80103e3b:	83 ec 0c             	sub    $0xc,%esp
80103e3e:	50                   	push   %eax
80103e3f:	e8 72 10 00 00       	call   80104eb6 <release>
80103e44:	83 c4 10             	add    $0x10,%esp
  return i;
80103e47:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
80103e4a:	c9                   	leave  
80103e4b:	c3                   	ret    

80103e4c <readeflags>:
{
80103e4c:	55                   	push   %ebp
80103e4d:	89 e5                	mov    %esp,%ebp
80103e4f:	83 ec 10             	sub    $0x10,%esp
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80103e52:	9c                   	pushf  
80103e53:	58                   	pop    %eax
80103e54:	89 45 fc             	mov    %eax,-0x4(%ebp)
  return eflags;
80103e57:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
80103e5a:	c9                   	leave  
80103e5b:	c3                   	ret    

80103e5c <sti>:
{
80103e5c:	55                   	push   %ebp
80103e5d:	89 e5                	mov    %esp,%ebp
  asm volatile("sti");
80103e5f:	fb                   	sti    
}
80103e60:	90                   	nop
80103e61:	5d                   	pop    %ebp
80103e62:	c3                   	ret    

80103e63 <pinit>:

static void wakeup1(void *chan);

void
pinit(void)
{
80103e63:	55                   	push   %ebp
80103e64:	89 e5                	mov    %esp,%ebp
80103e66:	83 ec 08             	sub    $0x8,%esp
  initlock(&ptable.lock, "ptable");
80103e69:	83 ec 08             	sub    $0x8,%esp
80103e6c:	68 14 a9 10 80       	push   $0x8010a914
80103e71:	68 40 72 11 80       	push   $0x80117240
80103e76:	e8 ab 0f 00 00       	call   80104e26 <initlock>
80103e7b:	83 c4 10             	add    $0x10,%esp
}
80103e7e:	90                   	nop
80103e7f:	c9                   	leave  
80103e80:	c3                   	ret    

80103e81 <cpuid>:

// Must be called with interrupts disabled
int
cpuid() {
80103e81:	55                   	push   %ebp
80103e82:	89 e5                	mov    %esp,%ebp
80103e84:	83 ec 08             	sub    $0x8,%esp
  return mycpu()-cpus;
80103e87:	e8 10 00 00 00       	call   80103e9c <mycpu>
80103e8c:	2d c0 9a 11 80       	sub    $0x80119ac0,%eax
80103e91:	c1 f8 04             	sar    $0x4,%eax
80103e94:	69 c0 a3 8b 2e ba    	imul   $0xba2e8ba3,%eax,%eax
}
80103e9a:	c9                   	leave  
80103e9b:	c3                   	ret    

80103e9c <mycpu>:

// Must be called with interrupts disabled to avoid the caller being
// rescheduled between reading lapicid and running through the loop.
struct cpu*
mycpu(void)
{
80103e9c:	55                   	push   %ebp
80103e9d:	89 e5                	mov    %esp,%ebp
80103e9f:	83 ec 18             	sub    $0x18,%esp
  int apicid, i;
  
  if(readeflags()&FL_IF){
80103ea2:	e8 a5 ff ff ff       	call   80103e4c <readeflags>
80103ea7:	25 00 02 00 00       	and    $0x200,%eax
80103eac:	85 c0                	test   %eax,%eax
80103eae:	74 0d                	je     80103ebd <mycpu+0x21>
    panic("mycpu called with interrupts enabled\n");
80103eb0:	83 ec 0c             	sub    $0xc,%esp
80103eb3:	68 1c a9 10 80       	push   $0x8010a91c
80103eb8:	e8 ec c6 ff ff       	call   801005a9 <panic>
  }

  apicid = lapicid();
80103ebd:	e8 1c f1 ff ff       	call   80102fde <lapicid>
80103ec2:	89 45 f0             	mov    %eax,-0x10(%ebp)
  // APIC IDs are not guaranteed to be contiguous. Maybe we should have
  // a reverse map, or reserve a register to store &cpus[i].
  for (i = 0; i < ncpu; ++i) {
80103ec5:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80103ecc:	eb 2d                	jmp    80103efb <mycpu+0x5f>
    if (cpus[i].apicid == apicid){
80103ece:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103ed1:	69 c0 b0 00 00 00    	imul   $0xb0,%eax,%eax
80103ed7:	05 c0 9a 11 80       	add    $0x80119ac0,%eax
80103edc:	0f b6 00             	movzbl (%eax),%eax
80103edf:	0f b6 c0             	movzbl %al,%eax
80103ee2:	39 45 f0             	cmp    %eax,-0x10(%ebp)
80103ee5:	75 10                	jne    80103ef7 <mycpu+0x5b>
      return &cpus[i];
80103ee7:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103eea:	69 c0 b0 00 00 00    	imul   $0xb0,%eax,%eax
80103ef0:	05 c0 9a 11 80       	add    $0x80119ac0,%eax
80103ef5:	eb 1b                	jmp    80103f12 <mycpu+0x76>
  for (i = 0; i < ncpu; ++i) {
80103ef7:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80103efb:	a1 80 9d 11 80       	mov    0x80119d80,%eax
80103f00:	39 45 f4             	cmp    %eax,-0xc(%ebp)
80103f03:	7c c9                	jl     80103ece <mycpu+0x32>
    }
  }
  panic("unknown apicid\n");
80103f05:	83 ec 0c             	sub    $0xc,%esp
80103f08:	68 42 a9 10 80       	push   $0x8010a942
80103f0d:	e8 97 c6 ff ff       	call   801005a9 <panic>
}
80103f12:	c9                   	leave  
80103f13:	c3                   	ret    

80103f14 <myproc>:

// Disable interrupts so that we are not rescheduled
// while reading proc from the cpu structure
struct proc*
myproc(void) {
80103f14:	55                   	push   %ebp
80103f15:	89 e5                	mov    %esp,%ebp
80103f17:	83 ec 18             	sub    $0x18,%esp
  struct cpu *c;
  struct proc *p;
  pushcli();
80103f1a:	e8 94 10 00 00       	call   80104fb3 <pushcli>
  c = mycpu();
80103f1f:	e8 78 ff ff ff       	call   80103e9c <mycpu>
80103f24:	89 45 f4             	mov    %eax,-0xc(%ebp)
  p = c->proc;
80103f27:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103f2a:	8b 80 ac 00 00 00    	mov    0xac(%eax),%eax
80103f30:	89 45 f0             	mov    %eax,-0x10(%ebp)
  popcli();
80103f33:	e8 c8 10 00 00       	call   80105000 <popcli>
  return p;
80103f38:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
80103f3b:	c9                   	leave  
80103f3c:	c3                   	ret    

80103f3d <allocproc>:
// If found, change state to EMBRYO and initialize
// state required to run in the kernel.
// Otherwise return 0.
static struct proc*
allocproc(void)
{
80103f3d:	55                   	push   %ebp
80103f3e:	89 e5                	mov    %esp,%ebp
80103f40:	83 ec 18             	sub    $0x18,%esp
  struct proc *p;
  char *sp;

  acquire(&ptable.lock);
80103f43:	83 ec 0c             	sub    $0xc,%esp
80103f46:	68 40 72 11 80       	push   $0x80117240
80103f4b:	e8 f8 0e 00 00       	call   80104e48 <acquire>
80103f50:	83 c4 10             	add    $0x10,%esp

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103f53:	c7 45 f4 74 72 11 80 	movl   $0x80117274,-0xc(%ebp)
80103f5a:	eb 0e                	jmp    80103f6a <allocproc+0x2d>
    if(p->state == UNUSED){
80103f5c:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103f5f:	8b 40 0c             	mov    0xc(%eax),%eax
80103f62:	85 c0                	test   %eax,%eax
80103f64:	74 27                	je     80103f8d <allocproc+0x50>
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103f66:	83 6d f4 80          	subl   $0xffffff80,-0xc(%ebp)
80103f6a:	81 7d f4 74 92 11 80 	cmpl   $0x80119274,-0xc(%ebp)
80103f71:	72 e9                	jb     80103f5c <allocproc+0x1f>
      goto found;
    }

  release(&ptable.lock);
80103f73:	83 ec 0c             	sub    $0xc,%esp
80103f76:	68 40 72 11 80       	push   $0x80117240
80103f7b:	e8 36 0f 00 00       	call   80104eb6 <release>
80103f80:	83 c4 10             	add    $0x10,%esp
  return 0;
80103f83:	b8 00 00 00 00       	mov    $0x0,%eax
80103f88:	e9 b2 00 00 00       	jmp    8010403f <allocproc+0x102>
      goto found;
80103f8d:	90                   	nop

found:
  p->state = EMBRYO;
80103f8e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103f91:	c7 40 0c 01 00 00 00 	movl   $0x1,0xc(%eax)
  p->pid = nextpid++;
80103f98:	a1 00 f0 10 80       	mov    0x8010f000,%eax
80103f9d:	8d 50 01             	lea    0x1(%eax),%edx
80103fa0:	89 15 00 f0 10 80    	mov    %edx,0x8010f000
80103fa6:	8b 55 f4             	mov    -0xc(%ebp),%edx
80103fa9:	89 42 10             	mov    %eax,0x10(%edx)

  release(&ptable.lock);
80103fac:	83 ec 0c             	sub    $0xc,%esp
80103faf:	68 40 72 11 80       	push   $0x80117240
80103fb4:	e8 fd 0e 00 00       	call   80104eb6 <release>
80103fb9:	83 c4 10             	add    $0x10,%esp


  // Allocate kernel stack.
  if((p->kstack = kalloc()) == 0){
80103fbc:	e8 c3 ec ff ff       	call   80102c84 <kalloc>
80103fc1:	8b 55 f4             	mov    -0xc(%ebp),%edx
80103fc4:	89 42 08             	mov    %eax,0x8(%edx)
80103fc7:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103fca:	8b 40 08             	mov    0x8(%eax),%eax
80103fcd:	85 c0                	test   %eax,%eax
80103fcf:	75 11                	jne    80103fe2 <allocproc+0xa5>
    p->state = UNUSED;
80103fd1:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103fd4:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
    return 0;
80103fdb:	b8 00 00 00 00       	mov    $0x0,%eax
80103fe0:	eb 5d                	jmp    8010403f <allocproc+0x102>
  }
  sp = p->kstack + KSTACKSIZE;
80103fe2:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103fe5:	8b 40 08             	mov    0x8(%eax),%eax
80103fe8:	05 00 10 00 00       	add    $0x1000,%eax
80103fed:	89 45 f0             	mov    %eax,-0x10(%ebp)

  // Leave room for trap frame.
  sp -= sizeof *p->tf;
80103ff0:	83 6d f0 4c          	subl   $0x4c,-0x10(%ebp)
  p->tf = (struct trapframe*)sp;
80103ff4:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103ff7:	8b 55 f0             	mov    -0x10(%ebp),%edx
80103ffa:	89 50 18             	mov    %edx,0x18(%eax)

  // Set up new context to start executing at forkret,
  // which returns to trapret.
  sp -= 4;
80103ffd:	83 6d f0 04          	subl   $0x4,-0x10(%ebp)
  *(uint*)sp = (uint)trapret;
80104001:	ba a9 64 10 80       	mov    $0x801064a9,%edx
80104006:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104009:	89 10                	mov    %edx,(%eax)

  sp -= sizeof *p->context;
8010400b:	83 6d f0 14          	subl   $0x14,-0x10(%ebp)
  p->context = (struct context*)sp;
8010400f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104012:	8b 55 f0             	mov    -0x10(%ebp),%edx
80104015:	89 50 1c             	mov    %edx,0x1c(%eax)
  memset(p->context, 0, sizeof *p->context);
80104018:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010401b:	8b 40 1c             	mov    0x1c(%eax),%eax
8010401e:	83 ec 04             	sub    $0x4,%esp
80104021:	6a 14                	push   $0x14
80104023:	6a 00                	push   $0x0
80104025:	50                   	push   %eax
80104026:	e8 93 10 00 00       	call   801050be <memset>
8010402b:	83 c4 10             	add    $0x10,%esp
  p->context->eip = (uint)forkret;
8010402e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104031:	8b 40 1c             	mov    0x1c(%eax),%eax
80104034:	ba e7 49 10 80       	mov    $0x801049e7,%edx
80104039:	89 50 10             	mov    %edx,0x10(%eax)

  return p;
8010403c:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
8010403f:	c9                   	leave  
80104040:	c3                   	ret    

80104041 <userinit>:

//PAGEBREAK: 32
// Set up first user process.
void
userinit(void)
{
80104041:	55                   	push   %ebp
80104042:	89 e5                	mov    %esp,%ebp
80104044:	83 ec 18             	sub    $0x18,%esp
  struct proc *p;
  extern char _binary_initcode_start[], _binary_initcode_size[];

  p = allocproc();
80104047:	e8 f1 fe ff ff       	call   80103f3d <allocproc>
8010404c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  
  initproc = p;
8010404f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104052:	a3 74 92 11 80       	mov    %eax,0x80119274
  if((p->pgdir = setupkvm()) == 0){
80104057:	e8 a5 39 00 00       	call   80107a01 <setupkvm>
8010405c:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010405f:	89 42 04             	mov    %eax,0x4(%edx)
80104062:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104065:	8b 40 04             	mov    0x4(%eax),%eax
80104068:	85 c0                	test   %eax,%eax
8010406a:	75 0d                	jne    80104079 <userinit+0x38>
    panic("userinit: out of memory?");
8010406c:	83 ec 0c             	sub    $0xc,%esp
8010406f:	68 52 a9 10 80       	push   $0x8010a952
80104074:	e8 30 c5 ff ff       	call   801005a9 <panic>
  }
  inituvm(p->pgdir, _binary_initcode_start, (int)_binary_initcode_size);
80104079:	ba 2c 00 00 00       	mov    $0x2c,%edx
8010407e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104081:	8b 40 04             	mov    0x4(%eax),%eax
80104084:	83 ec 04             	sub    $0x4,%esp
80104087:	52                   	push   %edx
80104088:	68 ec f4 10 80       	push   $0x8010f4ec
8010408d:	50                   	push   %eax
8010408e:	e8 2a 3c 00 00       	call   80107cbd <inituvm>
80104093:	83 c4 10             	add    $0x10,%esp
  p->sz = PGSIZE;
80104096:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104099:	c7 00 00 10 00 00    	movl   $0x1000,(%eax)
  memset(p->tf, 0, sizeof(*p->tf));
8010409f:	8b 45 f4             	mov    -0xc(%ebp),%eax
801040a2:	8b 40 18             	mov    0x18(%eax),%eax
801040a5:	83 ec 04             	sub    $0x4,%esp
801040a8:	6a 4c                	push   $0x4c
801040aa:	6a 00                	push   $0x0
801040ac:	50                   	push   %eax
801040ad:	e8 0c 10 00 00       	call   801050be <memset>
801040b2:	83 c4 10             	add    $0x10,%esp
  p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
801040b5:	8b 45 f4             	mov    -0xc(%ebp),%eax
801040b8:	8b 40 18             	mov    0x18(%eax),%eax
801040bb:	66 c7 40 3c 1b 00    	movw   $0x1b,0x3c(%eax)
  p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
801040c1:	8b 45 f4             	mov    -0xc(%ebp),%eax
801040c4:	8b 40 18             	mov    0x18(%eax),%eax
801040c7:	66 c7 40 2c 23 00    	movw   $0x23,0x2c(%eax)
  p->tf->es = p->tf->ds;
801040cd:	8b 45 f4             	mov    -0xc(%ebp),%eax
801040d0:	8b 50 18             	mov    0x18(%eax),%edx
801040d3:	8b 45 f4             	mov    -0xc(%ebp),%eax
801040d6:	8b 40 18             	mov    0x18(%eax),%eax
801040d9:	0f b7 52 2c          	movzwl 0x2c(%edx),%edx
801040dd:	66 89 50 28          	mov    %dx,0x28(%eax)
  p->tf->ss = p->tf->ds;
801040e1:	8b 45 f4             	mov    -0xc(%ebp),%eax
801040e4:	8b 50 18             	mov    0x18(%eax),%edx
801040e7:	8b 45 f4             	mov    -0xc(%ebp),%eax
801040ea:	8b 40 18             	mov    0x18(%eax),%eax
801040ed:	0f b7 52 2c          	movzwl 0x2c(%edx),%edx
801040f1:	66 89 50 48          	mov    %dx,0x48(%eax)
  p->tf->eflags = FL_IF;
801040f5:	8b 45 f4             	mov    -0xc(%ebp),%eax
801040f8:	8b 40 18             	mov    0x18(%eax),%eax
801040fb:	c7 40 40 00 02 00 00 	movl   $0x200,0x40(%eax)
  p->tf->esp = PGSIZE;
80104102:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104105:	8b 40 18             	mov    0x18(%eax),%eax
80104108:	c7 40 44 00 10 00 00 	movl   $0x1000,0x44(%eax)
  p->tf->eip = 0;  // beginning of initcode.S
8010410f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104112:	8b 40 18             	mov    0x18(%eax),%eax
80104115:	c7 40 38 00 00 00 00 	movl   $0x0,0x38(%eax)

  safestrcpy(p->name, "initcode", sizeof(p->name));
8010411c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010411f:	83 c0 6c             	add    $0x6c,%eax
80104122:	83 ec 04             	sub    $0x4,%esp
80104125:	6a 10                	push   $0x10
80104127:	68 6b a9 10 80       	push   $0x8010a96b
8010412c:	50                   	push   %eax
8010412d:	e8 8f 11 00 00       	call   801052c1 <safestrcpy>
80104132:	83 c4 10             	add    $0x10,%esp
  p->cwd = namei("/");
80104135:	83 ec 0c             	sub    $0xc,%esp
80104138:	68 74 a9 10 80       	push   $0x8010a974
8010413d:	e8 db e3 ff ff       	call   8010251d <namei>
80104142:	83 c4 10             	add    $0x10,%esp
80104145:	8b 55 f4             	mov    -0xc(%ebp),%edx
80104148:	89 42 68             	mov    %eax,0x68(%edx)

  // this assignment to p->state lets other cores
  // run this process. the acquire forces the above
  // writes to be visible, and the lock is also needed
  // because the assignment might not be atomic.
  acquire(&ptable.lock);
8010414b:	83 ec 0c             	sub    $0xc,%esp
8010414e:	68 40 72 11 80       	push   $0x80117240
80104153:	e8 f0 0c 00 00       	call   80104e48 <acquire>
80104158:	83 c4 10             	add    $0x10,%esp

  p->state = RUNNABLE;
8010415b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010415e:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)

  release(&ptable.lock);
80104165:	83 ec 0c             	sub    $0xc,%esp
80104168:	68 40 72 11 80       	push   $0x80117240
8010416d:	e8 44 0d 00 00       	call   80104eb6 <release>
80104172:	83 c4 10             	add    $0x10,%esp
}
80104175:	90                   	nop
80104176:	c9                   	leave  
80104177:	c3                   	ret    

80104178 <growproc>:

// Grow current process's memory by n bytes.
// Return 0 on success, -1 on failure.
int
growproc(int n)
{
80104178:	55                   	push   %ebp
80104179:	89 e5                	mov    %esp,%ebp
8010417b:	83 ec 18             	sub    $0x18,%esp
  uint sz;
  struct proc *curproc = myproc();
8010417e:	e8 91 fd ff ff       	call   80103f14 <myproc>
80104183:	89 45 f0             	mov    %eax,-0x10(%ebp)

  sz = curproc->sz;
80104186:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104189:	8b 00                	mov    (%eax),%eax
8010418b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(n > 0){
8010418e:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
80104192:	7e 2e                	jle    801041c2 <growproc+0x4a>
    if((sz = allocuvm(curproc->pgdir, sz, sz + n)) == 0)
80104194:	8b 55 08             	mov    0x8(%ebp),%edx
80104197:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010419a:	01 c2                	add    %eax,%edx
8010419c:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010419f:	8b 40 04             	mov    0x4(%eax),%eax
801041a2:	83 ec 04             	sub    $0x4,%esp
801041a5:	52                   	push   %edx
801041a6:	ff 75 f4             	push   -0xc(%ebp)
801041a9:	50                   	push   %eax
801041aa:	e8 4b 3c 00 00       	call   80107dfa <allocuvm>
801041af:	83 c4 10             	add    $0x10,%esp
801041b2:	89 45 f4             	mov    %eax,-0xc(%ebp)
801041b5:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801041b9:	75 3b                	jne    801041f6 <growproc+0x7e>
      return -1;
801041bb:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801041c0:	eb 4f                	jmp    80104211 <growproc+0x99>
  } else if(n < 0){
801041c2:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
801041c6:	79 2e                	jns    801041f6 <growproc+0x7e>
    if((sz = deallocuvm(curproc->pgdir, sz, sz + n)) == 0)
801041c8:	8b 55 08             	mov    0x8(%ebp),%edx
801041cb:	8b 45 f4             	mov    -0xc(%ebp),%eax
801041ce:	01 c2                	add    %eax,%edx
801041d0:	8b 45 f0             	mov    -0x10(%ebp),%eax
801041d3:	8b 40 04             	mov    0x4(%eax),%eax
801041d6:	83 ec 04             	sub    $0x4,%esp
801041d9:	52                   	push   %edx
801041da:	ff 75 f4             	push   -0xc(%ebp)
801041dd:	50                   	push   %eax
801041de:	e8 1c 3d 00 00       	call   80107eff <deallocuvm>
801041e3:	83 c4 10             	add    $0x10,%esp
801041e6:	89 45 f4             	mov    %eax,-0xc(%ebp)
801041e9:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801041ed:	75 07                	jne    801041f6 <growproc+0x7e>
      return -1;
801041ef:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801041f4:	eb 1b                	jmp    80104211 <growproc+0x99>
  }
  curproc->sz = sz;
801041f6:	8b 45 f0             	mov    -0x10(%ebp),%eax
801041f9:	8b 55 f4             	mov    -0xc(%ebp),%edx
801041fc:	89 10                	mov    %edx,(%eax)
  switchuvm(curproc);
801041fe:	83 ec 0c             	sub    $0xc,%esp
80104201:	ff 75 f0             	push   -0x10(%ebp)
80104204:	e8 15 39 00 00       	call   80107b1e <switchuvm>
80104209:	83 c4 10             	add    $0x10,%esp
  return 0;
8010420c:	b8 00 00 00 00       	mov    $0x0,%eax
}
80104211:	c9                   	leave  
80104212:	c3                   	ret    

80104213 <fork>:
// Create a new process copying p as the parent.
// Sets up stack to return as if from system call.
// Caller must set state of returned proc to RUNNABLE.
int
fork(void)
{
80104213:	55                   	push   %ebp
80104214:	89 e5                	mov    %esp,%ebp
80104216:	57                   	push   %edi
80104217:	56                   	push   %esi
80104218:	53                   	push   %ebx
80104219:	83 ec 1c             	sub    $0x1c,%esp
  int i, pid;
  struct proc *np;
  struct proc *curproc = myproc();
8010421c:	e8 f3 fc ff ff       	call   80103f14 <myproc>
80104221:	89 45 e0             	mov    %eax,-0x20(%ebp)

  // Allocate process.
  if((np = allocproc()) == 0){
80104224:	e8 14 fd ff ff       	call   80103f3d <allocproc>
80104229:	89 45 dc             	mov    %eax,-0x24(%ebp)
8010422c:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
80104230:	75 0a                	jne    8010423c <fork+0x29>
    return -1;
80104232:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104237:	e9 48 01 00 00       	jmp    80104384 <fork+0x171>
  }

  // Copy process state from proc.
  if((np->pgdir = copyuvm(curproc->pgdir, curproc->sz)) == 0){
8010423c:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010423f:	8b 10                	mov    (%eax),%edx
80104241:	8b 45 e0             	mov    -0x20(%ebp),%eax
80104244:	8b 40 04             	mov    0x4(%eax),%eax
80104247:	83 ec 08             	sub    $0x8,%esp
8010424a:	52                   	push   %edx
8010424b:	50                   	push   %eax
8010424c:	e8 4c 3e 00 00       	call   8010809d <copyuvm>
80104251:	83 c4 10             	add    $0x10,%esp
80104254:	8b 55 dc             	mov    -0x24(%ebp),%edx
80104257:	89 42 04             	mov    %eax,0x4(%edx)
8010425a:	8b 45 dc             	mov    -0x24(%ebp),%eax
8010425d:	8b 40 04             	mov    0x4(%eax),%eax
80104260:	85 c0                	test   %eax,%eax
80104262:	75 30                	jne    80104294 <fork+0x81>
    kfree(np->kstack);
80104264:	8b 45 dc             	mov    -0x24(%ebp),%eax
80104267:	8b 40 08             	mov    0x8(%eax),%eax
8010426a:	83 ec 0c             	sub    $0xc,%esp
8010426d:	50                   	push   %eax
8010426e:	e8 77 e9 ff ff       	call   80102bea <kfree>
80104273:	83 c4 10             	add    $0x10,%esp
    np->kstack = 0;
80104276:	8b 45 dc             	mov    -0x24(%ebp),%eax
80104279:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
    np->state = UNUSED;
80104280:	8b 45 dc             	mov    -0x24(%ebp),%eax
80104283:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
    return -1;
8010428a:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010428f:	e9 f0 00 00 00       	jmp    80104384 <fork+0x171>
  }
  np->sz = curproc->sz;
80104294:	8b 45 e0             	mov    -0x20(%ebp),%eax
80104297:	8b 10                	mov    (%eax),%edx
80104299:	8b 45 dc             	mov    -0x24(%ebp),%eax
8010429c:	89 10                	mov    %edx,(%eax)
  np->parent = curproc;
8010429e:	8b 45 dc             	mov    -0x24(%ebp),%eax
801042a1:	8b 55 e0             	mov    -0x20(%ebp),%edx
801042a4:	89 50 14             	mov    %edx,0x14(%eax)
  *np->tf = *curproc->tf;
801042a7:	8b 45 e0             	mov    -0x20(%ebp),%eax
801042aa:	8b 48 18             	mov    0x18(%eax),%ecx
801042ad:	8b 45 dc             	mov    -0x24(%ebp),%eax
801042b0:	8b 40 18             	mov    0x18(%eax),%eax
801042b3:	89 c2                	mov    %eax,%edx
801042b5:	89 cb                	mov    %ecx,%ebx
801042b7:	b8 13 00 00 00       	mov    $0x13,%eax
801042bc:	89 d7                	mov    %edx,%edi
801042be:	89 de                	mov    %ebx,%esi
801042c0:	89 c1                	mov    %eax,%ecx
801042c2:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)

  // Clear %eax so that fork returns 0 in the child.
  np->tf->eax = 0;
801042c4:	8b 45 dc             	mov    -0x24(%ebp),%eax
801042c7:	8b 40 18             	mov    0x18(%eax),%eax
801042ca:	c7 40 1c 00 00 00 00 	movl   $0x0,0x1c(%eax)

  for(i = 0; i < NOFILE; i++)
801042d1:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
801042d8:	eb 3b                	jmp    80104315 <fork+0x102>
    if(curproc->ofile[i])
801042da:	8b 45 e0             	mov    -0x20(%ebp),%eax
801042dd:	8b 55 e4             	mov    -0x1c(%ebp),%edx
801042e0:	83 c2 08             	add    $0x8,%edx
801042e3:	8b 44 90 08          	mov    0x8(%eax,%edx,4),%eax
801042e7:	85 c0                	test   %eax,%eax
801042e9:	74 26                	je     80104311 <fork+0xfe>
      np->ofile[i] = filedup(curproc->ofile[i]);
801042eb:	8b 45 e0             	mov    -0x20(%ebp),%eax
801042ee:	8b 55 e4             	mov    -0x1c(%ebp),%edx
801042f1:	83 c2 08             	add    $0x8,%edx
801042f4:	8b 44 90 08          	mov    0x8(%eax,%edx,4),%eax
801042f8:	83 ec 0c             	sub    $0xc,%esp
801042fb:	50                   	push   %eax
801042fc:	e8 49 cd ff ff       	call   8010104a <filedup>
80104301:	83 c4 10             	add    $0x10,%esp
80104304:	8b 55 dc             	mov    -0x24(%ebp),%edx
80104307:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
8010430a:	83 c1 08             	add    $0x8,%ecx
8010430d:	89 44 8a 08          	mov    %eax,0x8(%edx,%ecx,4)
  for(i = 0; i < NOFILE; i++)
80104311:	83 45 e4 01          	addl   $0x1,-0x1c(%ebp)
80104315:	83 7d e4 0f          	cmpl   $0xf,-0x1c(%ebp)
80104319:	7e bf                	jle    801042da <fork+0xc7>
  np->cwd = idup(curproc->cwd);
8010431b:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010431e:	8b 40 68             	mov    0x68(%eax),%eax
80104321:	83 ec 0c             	sub    $0xc,%esp
80104324:	50                   	push   %eax
80104325:	e8 86 d6 ff ff       	call   801019b0 <idup>
8010432a:	83 c4 10             	add    $0x10,%esp
8010432d:	8b 55 dc             	mov    -0x24(%ebp),%edx
80104330:	89 42 68             	mov    %eax,0x68(%edx)

  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
80104333:	8b 45 e0             	mov    -0x20(%ebp),%eax
80104336:	8d 50 6c             	lea    0x6c(%eax),%edx
80104339:	8b 45 dc             	mov    -0x24(%ebp),%eax
8010433c:	83 c0 6c             	add    $0x6c,%eax
8010433f:	83 ec 04             	sub    $0x4,%esp
80104342:	6a 10                	push   $0x10
80104344:	52                   	push   %edx
80104345:	50                   	push   %eax
80104346:	e8 76 0f 00 00       	call   801052c1 <safestrcpy>
8010434b:	83 c4 10             	add    $0x10,%esp

  pid = np->pid;
8010434e:	8b 45 dc             	mov    -0x24(%ebp),%eax
80104351:	8b 40 10             	mov    0x10(%eax),%eax
80104354:	89 45 d8             	mov    %eax,-0x28(%ebp)

  acquire(&ptable.lock);
80104357:	83 ec 0c             	sub    $0xc,%esp
8010435a:	68 40 72 11 80       	push   $0x80117240
8010435f:	e8 e4 0a 00 00       	call   80104e48 <acquire>
80104364:	83 c4 10             	add    $0x10,%esp

  np->state = RUNNABLE;
80104367:	8b 45 dc             	mov    -0x24(%ebp),%eax
8010436a:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)

  release(&ptable.lock);
80104371:	83 ec 0c             	sub    $0xc,%esp
80104374:	68 40 72 11 80       	push   $0x80117240
80104379:	e8 38 0b 00 00       	call   80104eb6 <release>
8010437e:	83 c4 10             	add    $0x10,%esp

  return pid;
80104381:	8b 45 d8             	mov    -0x28(%ebp),%eax
}
80104384:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104387:	5b                   	pop    %ebx
80104388:	5e                   	pop    %esi
80104389:	5f                   	pop    %edi
8010438a:	5d                   	pop    %ebp
8010438b:	c3                   	ret    

8010438c <exit>:
// Exit the current process.  Does not return.
// An exited process remains in the zombie state
// until its parent calls wait() to find out it exited.
void
exit(void)
{
8010438c:	55                   	push   %ebp
8010438d:	89 e5                	mov    %esp,%ebp
8010438f:	83 ec 18             	sub    $0x18,%esp
  struct proc *curproc = myproc();
80104392:	e8 7d fb ff ff       	call   80103f14 <myproc>
80104397:	89 45 ec             	mov    %eax,-0x14(%ebp)
  struct proc *p;
  int fd;

  if(curproc == initproc)
8010439a:	a1 74 92 11 80       	mov    0x80119274,%eax
8010439f:	39 45 ec             	cmp    %eax,-0x14(%ebp)
801043a2:	75 0d                	jne    801043b1 <exit+0x25>
    panic("init exiting");
801043a4:	83 ec 0c             	sub    $0xc,%esp
801043a7:	68 76 a9 10 80       	push   $0x8010a976
801043ac:	e8 f8 c1 ff ff       	call   801005a9 <panic>

  // Close all open files.
  for(fd = 0; fd < NOFILE; fd++){
801043b1:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
801043b8:	eb 3f                	jmp    801043f9 <exit+0x6d>
    if(curproc->ofile[fd]){
801043ba:	8b 45 ec             	mov    -0x14(%ebp),%eax
801043bd:	8b 55 f0             	mov    -0x10(%ebp),%edx
801043c0:	83 c2 08             	add    $0x8,%edx
801043c3:	8b 44 90 08          	mov    0x8(%eax,%edx,4),%eax
801043c7:	85 c0                	test   %eax,%eax
801043c9:	74 2a                	je     801043f5 <exit+0x69>
      fileclose(curproc->ofile[fd]);
801043cb:	8b 45 ec             	mov    -0x14(%ebp),%eax
801043ce:	8b 55 f0             	mov    -0x10(%ebp),%edx
801043d1:	83 c2 08             	add    $0x8,%edx
801043d4:	8b 44 90 08          	mov    0x8(%eax,%edx,4),%eax
801043d8:	83 ec 0c             	sub    $0xc,%esp
801043db:	50                   	push   %eax
801043dc:	e8 ba cc ff ff       	call   8010109b <fileclose>
801043e1:	83 c4 10             	add    $0x10,%esp
      curproc->ofile[fd] = 0;
801043e4:	8b 45 ec             	mov    -0x14(%ebp),%eax
801043e7:	8b 55 f0             	mov    -0x10(%ebp),%edx
801043ea:	83 c2 08             	add    $0x8,%edx
801043ed:	c7 44 90 08 00 00 00 	movl   $0x0,0x8(%eax,%edx,4)
801043f4:	00 
  for(fd = 0; fd < NOFILE; fd++){
801043f5:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
801043f9:	83 7d f0 0f          	cmpl   $0xf,-0x10(%ebp)
801043fd:	7e bb                	jle    801043ba <exit+0x2e>
    }
  }

  begin_op();
801043ff:	e8 1c f1 ff ff       	call   80103520 <begin_op>
  iput(curproc->cwd);
80104404:	8b 45 ec             	mov    -0x14(%ebp),%eax
80104407:	8b 40 68             	mov    0x68(%eax),%eax
8010440a:	83 ec 0c             	sub    $0xc,%esp
8010440d:	50                   	push   %eax
8010440e:	e8 38 d7 ff ff       	call   80101b4b <iput>
80104413:	83 c4 10             	add    $0x10,%esp
  end_op();
80104416:	e8 91 f1 ff ff       	call   801035ac <end_op>
  curproc->cwd = 0;
8010441b:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010441e:	c7 40 68 00 00 00 00 	movl   $0x0,0x68(%eax)

  acquire(&ptable.lock);
80104425:	83 ec 0c             	sub    $0xc,%esp
80104428:	68 40 72 11 80       	push   $0x80117240
8010442d:	e8 16 0a 00 00       	call   80104e48 <acquire>
80104432:	83 c4 10             	add    $0x10,%esp

  // Parent might be sleeping in wait().
  wakeup1(curproc->parent);
80104435:	8b 45 ec             	mov    -0x14(%ebp),%eax
80104438:	8b 40 14             	mov    0x14(%eax),%eax
8010443b:	83 ec 0c             	sub    $0xc,%esp
8010443e:	50                   	push   %eax
8010443f:	e8 90 06 00 00       	call   80104ad4 <wakeup1>
80104444:	83 c4 10             	add    $0x10,%esp

  // Pass abandoned children to init.
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104447:	c7 45 f4 74 72 11 80 	movl   $0x80117274,-0xc(%ebp)
8010444e:	eb 37                	jmp    80104487 <exit+0xfb>
    if(p->parent == curproc){
80104450:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104453:	8b 40 14             	mov    0x14(%eax),%eax
80104456:	39 45 ec             	cmp    %eax,-0x14(%ebp)
80104459:	75 28                	jne    80104483 <exit+0xf7>
      p->parent = initproc;
8010445b:	8b 15 74 92 11 80    	mov    0x80119274,%edx
80104461:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104464:	89 50 14             	mov    %edx,0x14(%eax)
      if(p->state == ZOMBIE)
80104467:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010446a:	8b 40 0c             	mov    0xc(%eax),%eax
8010446d:	83 f8 05             	cmp    $0x5,%eax
80104470:	75 11                	jne    80104483 <exit+0xf7>
        wakeup1(initproc);
80104472:	a1 74 92 11 80       	mov    0x80119274,%eax
80104477:	83 ec 0c             	sub    $0xc,%esp
8010447a:	50                   	push   %eax
8010447b:	e8 54 06 00 00       	call   80104ad4 <wakeup1>
80104480:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104483:	83 6d f4 80          	subl   $0xffffff80,-0xc(%ebp)
80104487:	81 7d f4 74 92 11 80 	cmpl   $0x80119274,-0xc(%ebp)
8010448e:	72 c0                	jb     80104450 <exit+0xc4>
    }
  }

  // Jump into the scheduler, never to return.
  curproc->state = ZOMBIE;
80104490:	8b 45 ec             	mov    -0x14(%ebp),%eax
80104493:	c7 40 0c 05 00 00 00 	movl   $0x5,0xc(%eax)
  sched();
8010449a:	e8 55 04 00 00       	call   801048f4 <sched>
  panic("zombie exit");
8010449f:	83 ec 0c             	sub    $0xc,%esp
801044a2:	68 83 a9 10 80       	push   $0x8010a983
801044a7:	e8 fd c0 ff ff       	call   801005a9 <panic>

801044ac <exit2>:
//******************************************
//************   new  **********************
//************ eixt2() *********************
//******************************************
void
exit2(int status){
801044ac:	55                   	push   %ebp
801044ad:	89 e5                	mov    %esp,%ebp
801044af:	83 ec 18             	sub    $0x18,%esp
  struct proc *curproc = myproc();
801044b2:	e8 5d fa ff ff       	call   80103f14 <myproc>
801044b7:	89 45 ec             	mov    %eax,-0x14(%ebp)
  struct proc *p;
  int fd;
 
  //***********새로 추가된 부분. Copy status to xstate**********
  curproc->xstate = status;
801044ba:	8b 45 ec             	mov    -0x14(%ebp),%eax
801044bd:	8b 55 08             	mov    0x8(%ebp),%edx
801044c0:	89 50 7c             	mov    %edx,0x7c(%eax)
  int test =curproc->xstate;
801044c3:	8b 45 ec             	mov    -0x14(%ebp),%eax
801044c6:	8b 40 7c             	mov    0x7c(%eax),%eax
801044c9:	89 45 e8             	mov    %eax,-0x18(%ebp)

  cprintf("%d\n", test);
801044cc:	83 ec 08             	sub    $0x8,%esp
801044cf:	ff 75 e8             	push   -0x18(%ebp)
801044d2:	68 8f a9 10 80       	push   $0x8010a98f
801044d7:	e8 18 bf ff ff       	call   801003f4 <cprintf>
801044dc:	83 c4 10             	add    $0x10,%esp

  if(curproc == initproc)
801044df:	a1 74 92 11 80       	mov    0x80119274,%eax
801044e4:	39 45 ec             	cmp    %eax,-0x14(%ebp)
801044e7:	75 0d                	jne    801044f6 <exit2+0x4a>
    panic("init exiting");
801044e9:	83 ec 0c             	sub    $0xc,%esp
801044ec:	68 76 a9 10 80       	push   $0x8010a976
801044f1:	e8 b3 c0 ff ff       	call   801005a9 <panic>

  // Close all open files.
  for(fd = 0; fd < NOFILE; fd++){
801044f6:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
801044fd:	eb 3f                	jmp    8010453e <exit2+0x92>
    if(curproc->ofile[fd]){
801044ff:	8b 45 ec             	mov    -0x14(%ebp),%eax
80104502:	8b 55 f0             	mov    -0x10(%ebp),%edx
80104505:	83 c2 08             	add    $0x8,%edx
80104508:	8b 44 90 08          	mov    0x8(%eax,%edx,4),%eax
8010450c:	85 c0                	test   %eax,%eax
8010450e:	74 2a                	je     8010453a <exit2+0x8e>
      fileclose(curproc->ofile[fd]);
80104510:	8b 45 ec             	mov    -0x14(%ebp),%eax
80104513:	8b 55 f0             	mov    -0x10(%ebp),%edx
80104516:	83 c2 08             	add    $0x8,%edx
80104519:	8b 44 90 08          	mov    0x8(%eax,%edx,4),%eax
8010451d:	83 ec 0c             	sub    $0xc,%esp
80104520:	50                   	push   %eax
80104521:	e8 75 cb ff ff       	call   8010109b <fileclose>
80104526:	83 c4 10             	add    $0x10,%esp
      curproc->ofile[fd] = 0;
80104529:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010452c:	8b 55 f0             	mov    -0x10(%ebp),%edx
8010452f:	83 c2 08             	add    $0x8,%edx
80104532:	c7 44 90 08 00 00 00 	movl   $0x0,0x8(%eax,%edx,4)
80104539:	00 
  for(fd = 0; fd < NOFILE; fd++){
8010453a:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
8010453e:	83 7d f0 0f          	cmpl   $0xf,-0x10(%ebp)
80104542:	7e bb                	jle    801044ff <exit2+0x53>
    }
  }

  begin_op();
80104544:	e8 d7 ef ff ff       	call   80103520 <begin_op>
  iput(curproc->cwd);
80104549:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010454c:	8b 40 68             	mov    0x68(%eax),%eax
8010454f:	83 ec 0c             	sub    $0xc,%esp
80104552:	50                   	push   %eax
80104553:	e8 f3 d5 ff ff       	call   80101b4b <iput>
80104558:	83 c4 10             	add    $0x10,%esp
  end_op();
8010455b:	e8 4c f0 ff ff       	call   801035ac <end_op>
  curproc->cwd = 0;
80104560:	8b 45 ec             	mov    -0x14(%ebp),%eax
80104563:	c7 40 68 00 00 00 00 	movl   $0x0,0x68(%eax)

  acquire(&ptable.lock);
8010456a:	83 ec 0c             	sub    $0xc,%esp
8010456d:	68 40 72 11 80       	push   $0x80117240
80104572:	e8 d1 08 00 00       	call   80104e48 <acquire>
80104577:	83 c4 10             	add    $0x10,%esp

  // Parent might be sleeping in wait().
  wakeup1(curproc->parent);
8010457a:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010457d:	8b 40 14             	mov    0x14(%eax),%eax
80104580:	83 ec 0c             	sub    $0xc,%esp
80104583:	50                   	push   %eax
80104584:	e8 4b 05 00 00       	call   80104ad4 <wakeup1>
80104589:	83 c4 10             	add    $0x10,%esp

  // Pass abandoned children to init.
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
8010458c:	c7 45 f4 74 72 11 80 	movl   $0x80117274,-0xc(%ebp)
80104593:	eb 37                	jmp    801045cc <exit2+0x120>
    if(p->parent == curproc){
80104595:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104598:	8b 40 14             	mov    0x14(%eax),%eax
8010459b:	39 45 ec             	cmp    %eax,-0x14(%ebp)
8010459e:	75 28                	jne    801045c8 <exit2+0x11c>
      p->parent = initproc;
801045a0:	8b 15 74 92 11 80    	mov    0x80119274,%edx
801045a6:	8b 45 f4             	mov    -0xc(%ebp),%eax
801045a9:	89 50 14             	mov    %edx,0x14(%eax)
      if(p->state == ZOMBIE)
801045ac:	8b 45 f4             	mov    -0xc(%ebp),%eax
801045af:	8b 40 0c             	mov    0xc(%eax),%eax
801045b2:	83 f8 05             	cmp    $0x5,%eax
801045b5:	75 11                	jne    801045c8 <exit2+0x11c>
        wakeup1(initproc);
801045b7:	a1 74 92 11 80       	mov    0x80119274,%eax
801045bc:	83 ec 0c             	sub    $0xc,%esp
801045bf:	50                   	push   %eax
801045c0:	e8 0f 05 00 00       	call   80104ad4 <wakeup1>
801045c5:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801045c8:	83 6d f4 80          	subl   $0xffffff80,-0xc(%ebp)
801045cc:	81 7d f4 74 92 11 80 	cmpl   $0x80119274,-0xc(%ebp)
801045d3:	72 c0                	jb     80104595 <exit2+0xe9>
    }
  }

  // Jump into the scheduler, never to return.
  curproc->state = ZOMBIE;
801045d5:	8b 45 ec             	mov    -0x14(%ebp),%eax
801045d8:	c7 40 0c 05 00 00 00 	movl   $0x5,0xc(%eax)
  sched();
801045df:	e8 10 03 00 00       	call   801048f4 <sched>
  panic("zombie exit");
801045e4:	83 ec 0c             	sub    $0xc,%esp
801045e7:	68 83 a9 10 80       	push   $0x8010a983
801045ec:	e8 b8 bf ff ff       	call   801005a9 <panic>

801045f1 <wait>:

// Wait for a child process to exit and return its pid.
// Return -1 if this process has no children.
int
wait(void)
{
801045f1:	55                   	push   %ebp
801045f2:	89 e5                	mov    %esp,%ebp
801045f4:	83 ec 18             	sub    $0x18,%esp
  struct proc *p;
  int havekids, pid;
  struct proc *curproc = myproc();
801045f7:	e8 18 f9 ff ff       	call   80103f14 <myproc>
801045fc:	89 45 ec             	mov    %eax,-0x14(%ebp)
  
  acquire(&ptable.lock);
801045ff:	83 ec 0c             	sub    $0xc,%esp
80104602:	68 40 72 11 80       	push   $0x80117240
80104607:	e8 3c 08 00 00       	call   80104e48 <acquire>
8010460c:	83 c4 10             	add    $0x10,%esp
  for(;;){
    // Scan through table looking for exited children.
    havekids = 0;
8010460f:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104616:	c7 45 f4 74 72 11 80 	movl   $0x80117274,-0xc(%ebp)
8010461d:	e9 a1 00 00 00       	jmp    801046c3 <wait+0xd2>
      if(p->parent != curproc)
80104622:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104625:	8b 40 14             	mov    0x14(%eax),%eax
80104628:	39 45 ec             	cmp    %eax,-0x14(%ebp)
8010462b:	0f 85 8d 00 00 00    	jne    801046be <wait+0xcd>
        continue;
      havekids = 1;
80104631:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
      if(p->state == ZOMBIE){
80104638:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010463b:	8b 40 0c             	mov    0xc(%eax),%eax
8010463e:	83 f8 05             	cmp    $0x5,%eax
80104641:	75 7c                	jne    801046bf <wait+0xce>
        // Found one.
        pid = p->pid;
80104643:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104646:	8b 40 10             	mov    0x10(%eax),%eax
80104649:	89 45 e8             	mov    %eax,-0x18(%ebp)
        kfree(p->kstack);
8010464c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010464f:	8b 40 08             	mov    0x8(%eax),%eax
80104652:	83 ec 0c             	sub    $0xc,%esp
80104655:	50                   	push   %eax
80104656:	e8 8f e5 ff ff       	call   80102bea <kfree>
8010465b:	83 c4 10             	add    $0x10,%esp
        p->kstack = 0;
8010465e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104661:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
        freevm(p->pgdir);
80104668:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010466b:	8b 40 04             	mov    0x4(%eax),%eax
8010466e:	83 ec 0c             	sub    $0xc,%esp
80104671:	50                   	push   %eax
80104672:	e8 4c 39 00 00       	call   80107fc3 <freevm>
80104677:	83 c4 10             	add    $0x10,%esp
        p->pid = 0;
8010467a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010467d:	c7 40 10 00 00 00 00 	movl   $0x0,0x10(%eax)
        p->parent = 0;
80104684:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104687:	c7 40 14 00 00 00 00 	movl   $0x0,0x14(%eax)
        p->name[0] = 0;
8010468e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104691:	c6 40 6c 00          	movb   $0x0,0x6c(%eax)
        p->killed = 0;
80104695:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104698:	c7 40 24 00 00 00 00 	movl   $0x0,0x24(%eax)
        p->state = UNUSED;
8010469f:	8b 45 f4             	mov    -0xc(%ebp),%eax
801046a2:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
        release(&ptable.lock);
801046a9:	83 ec 0c             	sub    $0xc,%esp
801046ac:	68 40 72 11 80       	push   $0x80117240
801046b1:	e8 00 08 00 00       	call   80104eb6 <release>
801046b6:	83 c4 10             	add    $0x10,%esp
        return pid;
801046b9:	8b 45 e8             	mov    -0x18(%ebp),%eax
801046bc:	eb 51                	jmp    8010470f <wait+0x11e>
        continue;
801046be:	90                   	nop
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801046bf:	83 6d f4 80          	subl   $0xffffff80,-0xc(%ebp)
801046c3:	81 7d f4 74 92 11 80 	cmpl   $0x80119274,-0xc(%ebp)
801046ca:	0f 82 52 ff ff ff    	jb     80104622 <wait+0x31>
      }
    }

    // No point waiting if we don't have any children.
    if(!havekids || curproc->killed){
801046d0:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
801046d4:	74 0a                	je     801046e0 <wait+0xef>
801046d6:	8b 45 ec             	mov    -0x14(%ebp),%eax
801046d9:	8b 40 24             	mov    0x24(%eax),%eax
801046dc:	85 c0                	test   %eax,%eax
801046de:	74 17                	je     801046f7 <wait+0x106>
      release(&ptable.lock);
801046e0:	83 ec 0c             	sub    $0xc,%esp
801046e3:	68 40 72 11 80       	push   $0x80117240
801046e8:	e8 c9 07 00 00       	call   80104eb6 <release>
801046ed:	83 c4 10             	add    $0x10,%esp
      return -1;
801046f0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801046f5:	eb 18                	jmp    8010470f <wait+0x11e>
    }

    // Wait for children to exit.  (See wakeup1 call in proc_exit.)
    sleep(curproc, &ptable.lock);  //DOC: wait-sleep
801046f7:	83 ec 08             	sub    $0x8,%esp
801046fa:	68 40 72 11 80       	push   $0x80117240
801046ff:	ff 75 ec             	push   -0x14(%ebp)
80104702:	e8 26 03 00 00       	call   80104a2d <sleep>
80104707:	83 c4 10             	add    $0x10,%esp
    havekids = 0;
8010470a:	e9 00 ff ff ff       	jmp    8010460f <wait+0x1e>
  }
}
8010470f:	c9                   	leave  
80104710:	c3                   	ret    

80104711 <wait2>:
//******************************************
//************   new  **********************
//************ wait2() *********************
//******************************************
int
wait2(int *status){
80104711:	55                   	push   %ebp
80104712:	89 e5                	mov    %esp,%ebp
80104714:	83 ec 18             	sub    $0x18,%esp

  struct proc *p;
  int havekids, pid;
  struct proc *curproc = myproc();
80104717:	e8 f8 f7 ff ff       	call   80103f14 <myproc>
8010471c:	89 45 ec             	mov    %eax,-0x14(%ebp)
 
  
  //***********새로 추가된 부분. xstate로 status 값을 복사**********
  curproc->xstate = *status;
8010471f:	8b 45 08             	mov    0x8(%ebp),%eax
80104722:	8b 10                	mov    (%eax),%edx
80104724:	8b 45 ec             	mov    -0x14(%ebp),%eax
80104727:	89 50 7c             	mov    %edx,0x7c(%eax)




  acquire(&ptable.lock);
8010472a:	83 ec 0c             	sub    $0xc,%esp
8010472d:	68 40 72 11 80       	push   $0x80117240
80104732:	e8 11 07 00 00       	call   80104e48 <acquire>
80104737:	83 c4 10             	add    $0x10,%esp
  for(;;){
    // Scan through table looking for exited children.
    havekids = 0;
8010473a:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104741:	c7 45 f4 74 72 11 80 	movl   $0x80117274,-0xc(%ebp)
80104748:	e9 a1 00 00 00       	jmp    801047ee <wait2+0xdd>
      if(p->parent != curproc)
8010474d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104750:	8b 40 14             	mov    0x14(%eax),%eax
80104753:	39 45 ec             	cmp    %eax,-0x14(%ebp)
80104756:	0f 85 8d 00 00 00    	jne    801047e9 <wait2+0xd8>
        continue;
      havekids = 1;
8010475c:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
      if(p->state == ZOMBIE){
80104763:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104766:	8b 40 0c             	mov    0xc(%eax),%eax
80104769:	83 f8 05             	cmp    $0x5,%eax
8010476c:	75 7c                	jne    801047ea <wait2+0xd9>
        // Found one.
        pid = p->pid;
8010476e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104771:	8b 40 10             	mov    0x10(%eax),%eax
80104774:	89 45 e8             	mov    %eax,-0x18(%ebp)
        kfree(p->kstack);
80104777:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010477a:	8b 40 08             	mov    0x8(%eax),%eax
8010477d:	83 ec 0c             	sub    $0xc,%esp
80104780:	50                   	push   %eax
80104781:	e8 64 e4 ff ff       	call   80102bea <kfree>
80104786:	83 c4 10             	add    $0x10,%esp
        p->kstack = 0;
80104789:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010478c:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
        freevm(p->pgdir);
80104793:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104796:	8b 40 04             	mov    0x4(%eax),%eax
80104799:	83 ec 0c             	sub    $0xc,%esp
8010479c:	50                   	push   %eax
8010479d:	e8 21 38 00 00       	call   80107fc3 <freevm>
801047a2:	83 c4 10             	add    $0x10,%esp
        p->pid = 0;
801047a5:	8b 45 f4             	mov    -0xc(%ebp),%eax
801047a8:	c7 40 10 00 00 00 00 	movl   $0x0,0x10(%eax)
        p->parent = 0;
801047af:	8b 45 f4             	mov    -0xc(%ebp),%eax
801047b2:	c7 40 14 00 00 00 00 	movl   $0x0,0x14(%eax)
        p->name[0] = 0;
801047b9:	8b 45 f4             	mov    -0xc(%ebp),%eax
801047bc:	c6 40 6c 00          	movb   $0x0,0x6c(%eax)
        p->killed = 0;
801047c0:	8b 45 f4             	mov    -0xc(%ebp),%eax
801047c3:	c7 40 24 00 00 00 00 	movl   $0x0,0x24(%eax)
        p->state = UNUSED;
801047ca:	8b 45 f4             	mov    -0xc(%ebp),%eax
801047cd:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
        release(&ptable.lock);
801047d4:	83 ec 0c             	sub    $0xc,%esp
801047d7:	68 40 72 11 80       	push   $0x80117240
801047dc:	e8 d5 06 00 00       	call   80104eb6 <release>
801047e1:	83 c4 10             	add    $0x10,%esp
        return pid;
801047e4:	8b 45 e8             	mov    -0x18(%ebp),%eax
801047e7:	eb 51                	jmp    8010483a <wait2+0x129>
        continue;
801047e9:	90                   	nop
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801047ea:	83 6d f4 80          	subl   $0xffffff80,-0xc(%ebp)
801047ee:	81 7d f4 74 92 11 80 	cmpl   $0x80119274,-0xc(%ebp)
801047f5:	0f 82 52 ff ff ff    	jb     8010474d <wait2+0x3c>
      }
    }

    // No point waiting if we don't have any children.
    if(!havekids || curproc->killed){
801047fb:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
801047ff:	74 0a                	je     8010480b <wait2+0xfa>
80104801:	8b 45 ec             	mov    -0x14(%ebp),%eax
80104804:	8b 40 24             	mov    0x24(%eax),%eax
80104807:	85 c0                	test   %eax,%eax
80104809:	74 17                	je     80104822 <wait2+0x111>
      release(&ptable.lock);
8010480b:	83 ec 0c             	sub    $0xc,%esp
8010480e:	68 40 72 11 80       	push   $0x80117240
80104813:	e8 9e 06 00 00       	call   80104eb6 <release>
80104818:	83 c4 10             	add    $0x10,%esp
      return -1;
8010481b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104820:	eb 18                	jmp    8010483a <wait2+0x129>
    }

    // Wait for children to exit.  (See wakeup1 call in proc_exit.)
    sleep(curproc, &ptable.lock);  //DOC: wait-sleep
80104822:	83 ec 08             	sub    $0x8,%esp
80104825:	68 40 72 11 80       	push   $0x80117240
8010482a:	ff 75 ec             	push   -0x14(%ebp)
8010482d:	e8 fb 01 00 00       	call   80104a2d <sleep>
80104832:	83 c4 10             	add    $0x10,%esp
    havekids = 0;
80104835:	e9 00 ff ff ff       	jmp    8010473a <wait2+0x29>
  }
}
8010483a:	c9                   	leave  
8010483b:	c3                   	ret    

8010483c <scheduler>:
//  - swtch to start running that process
//  - eventually that process transfers control
//      via swtch back to the scheduler.
void
scheduler(void)
{
8010483c:	55                   	push   %ebp
8010483d:	89 e5                	mov    %esp,%ebp
8010483f:	83 ec 18             	sub    $0x18,%esp
  struct proc *p;
  struct cpu *c = mycpu();
80104842:	e8 55 f6 ff ff       	call   80103e9c <mycpu>
80104847:	89 45 f0             	mov    %eax,-0x10(%ebp)
  c->proc = 0;
8010484a:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010484d:	c7 80 ac 00 00 00 00 	movl   $0x0,0xac(%eax)
80104854:	00 00 00 
  
  for(;;){
    // Enable interrupts on this processor.
    sti();
80104857:	e8 00 f6 ff ff       	call   80103e5c <sti>

    // Loop over process table looking for process to run.
    acquire(&ptable.lock);
8010485c:	83 ec 0c             	sub    $0xc,%esp
8010485f:	68 40 72 11 80       	push   $0x80117240
80104864:	e8 df 05 00 00       	call   80104e48 <acquire>
80104869:	83 c4 10             	add    $0x10,%esp
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
8010486c:	c7 45 f4 74 72 11 80 	movl   $0x80117274,-0xc(%ebp)
80104873:	eb 61                	jmp    801048d6 <scheduler+0x9a>
      if(p->state != RUNNABLE)
80104875:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104878:	8b 40 0c             	mov    0xc(%eax),%eax
8010487b:	83 f8 03             	cmp    $0x3,%eax
8010487e:	75 51                	jne    801048d1 <scheduler+0x95>
        continue;

      // Switch to chosen process.  It is the process's job
      // to release ptable.lock and then reacquire it
      // before jumping back to us.
      c->proc = p;
80104880:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104883:	8b 55 f4             	mov    -0xc(%ebp),%edx
80104886:	89 90 ac 00 00 00    	mov    %edx,0xac(%eax)
      switchuvm(p);
8010488c:	83 ec 0c             	sub    $0xc,%esp
8010488f:	ff 75 f4             	push   -0xc(%ebp)
80104892:	e8 87 32 00 00       	call   80107b1e <switchuvm>
80104897:	83 c4 10             	add    $0x10,%esp
      p->state = RUNNING;
8010489a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010489d:	c7 40 0c 04 00 00 00 	movl   $0x4,0xc(%eax)

      swtch(&(c->scheduler), p->context);
801048a4:	8b 45 f4             	mov    -0xc(%ebp),%eax
801048a7:	8b 40 1c             	mov    0x1c(%eax),%eax
801048aa:	8b 55 f0             	mov    -0x10(%ebp),%edx
801048ad:	83 c2 04             	add    $0x4,%edx
801048b0:	83 ec 08             	sub    $0x8,%esp
801048b3:	50                   	push   %eax
801048b4:	52                   	push   %edx
801048b5:	e8 79 0a 00 00       	call   80105333 <swtch>
801048ba:	83 c4 10             	add    $0x10,%esp
      switchkvm();
801048bd:	e8 43 32 00 00       	call   80107b05 <switchkvm>

      // Process is done running for now.
      // It should have changed its p->state before coming back.
      c->proc = 0;
801048c2:	8b 45 f0             	mov    -0x10(%ebp),%eax
801048c5:	c7 80 ac 00 00 00 00 	movl   $0x0,0xac(%eax)
801048cc:	00 00 00 
801048cf:	eb 01                	jmp    801048d2 <scheduler+0x96>
        continue;
801048d1:	90                   	nop
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801048d2:	83 6d f4 80          	subl   $0xffffff80,-0xc(%ebp)
801048d6:	81 7d f4 74 92 11 80 	cmpl   $0x80119274,-0xc(%ebp)
801048dd:	72 96                	jb     80104875 <scheduler+0x39>
    }
    release(&ptable.lock);
801048df:	83 ec 0c             	sub    $0xc,%esp
801048e2:	68 40 72 11 80       	push   $0x80117240
801048e7:	e8 ca 05 00 00       	call   80104eb6 <release>
801048ec:	83 c4 10             	add    $0x10,%esp
    sti();
801048ef:	e9 63 ff ff ff       	jmp    80104857 <scheduler+0x1b>

801048f4 <sched>:
// be proc->intena and proc->ncli, but that would
// break in the few places where a lock is held but
// there's no process.
void
sched(void)
{
801048f4:	55                   	push   %ebp
801048f5:	89 e5                	mov    %esp,%ebp
801048f7:	83 ec 18             	sub    $0x18,%esp
  int intena;
  struct proc *p = myproc();
801048fa:	e8 15 f6 ff ff       	call   80103f14 <myproc>
801048ff:	89 45 f4             	mov    %eax,-0xc(%ebp)

  if(!holding(&ptable.lock))
80104902:	83 ec 0c             	sub    $0xc,%esp
80104905:	68 40 72 11 80       	push   $0x80117240
8010490a:	e8 74 06 00 00       	call   80104f83 <holding>
8010490f:	83 c4 10             	add    $0x10,%esp
80104912:	85 c0                	test   %eax,%eax
80104914:	75 0d                	jne    80104923 <sched+0x2f>
    panic("sched ptable.lock");
80104916:	83 ec 0c             	sub    $0xc,%esp
80104919:	68 93 a9 10 80       	push   $0x8010a993
8010491e:	e8 86 bc ff ff       	call   801005a9 <panic>
  if(mycpu()->ncli != 1)
80104923:	e8 74 f5 ff ff       	call   80103e9c <mycpu>
80104928:	8b 80 a4 00 00 00    	mov    0xa4(%eax),%eax
8010492e:	83 f8 01             	cmp    $0x1,%eax
80104931:	74 0d                	je     80104940 <sched+0x4c>
    panic("sched locks");
80104933:	83 ec 0c             	sub    $0xc,%esp
80104936:	68 a5 a9 10 80       	push   $0x8010a9a5
8010493b:	e8 69 bc ff ff       	call   801005a9 <panic>
  if(p->state == RUNNING)
80104940:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104943:	8b 40 0c             	mov    0xc(%eax),%eax
80104946:	83 f8 04             	cmp    $0x4,%eax
80104949:	75 0d                	jne    80104958 <sched+0x64>
    panic("sched running");
8010494b:	83 ec 0c             	sub    $0xc,%esp
8010494e:	68 b1 a9 10 80       	push   $0x8010a9b1
80104953:	e8 51 bc ff ff       	call   801005a9 <panic>
  if(readeflags()&FL_IF)
80104958:	e8 ef f4 ff ff       	call   80103e4c <readeflags>
8010495d:	25 00 02 00 00       	and    $0x200,%eax
80104962:	85 c0                	test   %eax,%eax
80104964:	74 0d                	je     80104973 <sched+0x7f>
    panic("sched interruptible");
80104966:	83 ec 0c             	sub    $0xc,%esp
80104969:	68 bf a9 10 80       	push   $0x8010a9bf
8010496e:	e8 36 bc ff ff       	call   801005a9 <panic>
  intena = mycpu()->intena;
80104973:	e8 24 f5 ff ff       	call   80103e9c <mycpu>
80104978:	8b 80 a8 00 00 00    	mov    0xa8(%eax),%eax
8010497e:	89 45 f0             	mov    %eax,-0x10(%ebp)
  swtch(&p->context, mycpu()->scheduler);
80104981:	e8 16 f5 ff ff       	call   80103e9c <mycpu>
80104986:	8b 40 04             	mov    0x4(%eax),%eax
80104989:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010498c:	83 c2 1c             	add    $0x1c,%edx
8010498f:	83 ec 08             	sub    $0x8,%esp
80104992:	50                   	push   %eax
80104993:	52                   	push   %edx
80104994:	e8 9a 09 00 00       	call   80105333 <swtch>
80104999:	83 c4 10             	add    $0x10,%esp
  mycpu()->intena = intena;
8010499c:	e8 fb f4 ff ff       	call   80103e9c <mycpu>
801049a1:	8b 55 f0             	mov    -0x10(%ebp),%edx
801049a4:	89 90 a8 00 00 00    	mov    %edx,0xa8(%eax)
}
801049aa:	90                   	nop
801049ab:	c9                   	leave  
801049ac:	c3                   	ret    

801049ad <yield>:

// Give up the CPU for one scheduling round.
void
yield(void)
{
801049ad:	55                   	push   %ebp
801049ae:	89 e5                	mov    %esp,%ebp
801049b0:	83 ec 08             	sub    $0x8,%esp
  acquire(&ptable.lock);  //DOC: yieldlock
801049b3:	83 ec 0c             	sub    $0xc,%esp
801049b6:	68 40 72 11 80       	push   $0x80117240
801049bb:	e8 88 04 00 00       	call   80104e48 <acquire>
801049c0:	83 c4 10             	add    $0x10,%esp
  myproc()->state = RUNNABLE;
801049c3:	e8 4c f5 ff ff       	call   80103f14 <myproc>
801049c8:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
  sched();
801049cf:	e8 20 ff ff ff       	call   801048f4 <sched>
  release(&ptable.lock);
801049d4:	83 ec 0c             	sub    $0xc,%esp
801049d7:	68 40 72 11 80       	push   $0x80117240
801049dc:	e8 d5 04 00 00       	call   80104eb6 <release>
801049e1:	83 c4 10             	add    $0x10,%esp
}
801049e4:	90                   	nop
801049e5:	c9                   	leave  
801049e6:	c3                   	ret    

801049e7 <forkret>:

// A fork child's very first scheduling by scheduler()
// will swtch here.  "Return" to user space.
void
forkret(void)
{
801049e7:	55                   	push   %ebp
801049e8:	89 e5                	mov    %esp,%ebp
801049ea:	83 ec 08             	sub    $0x8,%esp
  static int first = 1;
  // Still holding ptable.lock from scheduler.
  release(&ptable.lock);
801049ed:	83 ec 0c             	sub    $0xc,%esp
801049f0:	68 40 72 11 80       	push   $0x80117240
801049f5:	e8 bc 04 00 00       	call   80104eb6 <release>
801049fa:	83 c4 10             	add    $0x10,%esp

  if (first) {
801049fd:	a1 04 f0 10 80       	mov    0x8010f004,%eax
80104a02:	85 c0                	test   %eax,%eax
80104a04:	74 24                	je     80104a2a <forkret+0x43>
    // Some initialization functions must be run in the context
    // of a regular process (e.g., they call sleep), and thus cannot
    // be run from main().
    first = 0;
80104a06:	c7 05 04 f0 10 80 00 	movl   $0x0,0x8010f004
80104a0d:	00 00 00 
    iinit(ROOTDEV);
80104a10:	83 ec 0c             	sub    $0xc,%esp
80104a13:	6a 01                	push   $0x1
80104a15:	e8 5e cc ff ff       	call   80101678 <iinit>
80104a1a:	83 c4 10             	add    $0x10,%esp
    initlog(ROOTDEV);
80104a1d:	83 ec 0c             	sub    $0xc,%esp
80104a20:	6a 01                	push   $0x1
80104a22:	e8 da e8 ff ff       	call   80103301 <initlog>
80104a27:	83 c4 10             	add    $0x10,%esp
  }

  // Return to "caller", actually trapret (see allocproc).
}
80104a2a:	90                   	nop
80104a2b:	c9                   	leave  
80104a2c:	c3                   	ret    

80104a2d <sleep>:

// Atomically release lock and sleep on chan.
// Reacquires lock when awakened.
void
sleep(void *chan, struct spinlock *lk)
{
80104a2d:	55                   	push   %ebp
80104a2e:	89 e5                	mov    %esp,%ebp
80104a30:	83 ec 18             	sub    $0x18,%esp
  struct proc *p = myproc();
80104a33:	e8 dc f4 ff ff       	call   80103f14 <myproc>
80104a38:	89 45 f4             	mov    %eax,-0xc(%ebp)
  
  if(p == 0)
80104a3b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80104a3f:	75 0d                	jne    80104a4e <sleep+0x21>
    panic("sleep");
80104a41:	83 ec 0c             	sub    $0xc,%esp
80104a44:	68 d3 a9 10 80       	push   $0x8010a9d3
80104a49:	e8 5b bb ff ff       	call   801005a9 <panic>

  if(lk == 0)
80104a4e:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
80104a52:	75 0d                	jne    80104a61 <sleep+0x34>
    panic("sleep without lk");
80104a54:	83 ec 0c             	sub    $0xc,%esp
80104a57:	68 d9 a9 10 80       	push   $0x8010a9d9
80104a5c:	e8 48 bb ff ff       	call   801005a9 <panic>
  // change p->state and then call sched.
  // Once we hold ptable.lock, we can be
  // guaranteed that we won't miss any wakeup
  // (wakeup runs with ptable.lock locked),
  // so it's okay to release lk.
  if(lk != &ptable.lock){  //DOC: sleeplock0
80104a61:	81 7d 0c 40 72 11 80 	cmpl   $0x80117240,0xc(%ebp)
80104a68:	74 1e                	je     80104a88 <sleep+0x5b>
    acquire(&ptable.lock);  //DOC: sleeplock1
80104a6a:	83 ec 0c             	sub    $0xc,%esp
80104a6d:	68 40 72 11 80       	push   $0x80117240
80104a72:	e8 d1 03 00 00       	call   80104e48 <acquire>
80104a77:	83 c4 10             	add    $0x10,%esp
    release(lk);
80104a7a:	83 ec 0c             	sub    $0xc,%esp
80104a7d:	ff 75 0c             	push   0xc(%ebp)
80104a80:	e8 31 04 00 00       	call   80104eb6 <release>
80104a85:	83 c4 10             	add    $0x10,%esp
  }
  // Go to sleep.
  p->chan = chan;
80104a88:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104a8b:	8b 55 08             	mov    0x8(%ebp),%edx
80104a8e:	89 50 20             	mov    %edx,0x20(%eax)
  p->state = SLEEPING;
80104a91:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104a94:	c7 40 0c 02 00 00 00 	movl   $0x2,0xc(%eax)

  sched();
80104a9b:	e8 54 fe ff ff       	call   801048f4 <sched>

  // Tidy up.
  p->chan = 0;
80104aa0:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104aa3:	c7 40 20 00 00 00 00 	movl   $0x0,0x20(%eax)

  // Reacquire original lock.
  if(lk != &ptable.lock){  //DOC: sleeplock2
80104aaa:	81 7d 0c 40 72 11 80 	cmpl   $0x80117240,0xc(%ebp)
80104ab1:	74 1e                	je     80104ad1 <sleep+0xa4>
    release(&ptable.lock);
80104ab3:	83 ec 0c             	sub    $0xc,%esp
80104ab6:	68 40 72 11 80       	push   $0x80117240
80104abb:	e8 f6 03 00 00       	call   80104eb6 <release>
80104ac0:	83 c4 10             	add    $0x10,%esp
    acquire(lk);
80104ac3:	83 ec 0c             	sub    $0xc,%esp
80104ac6:	ff 75 0c             	push   0xc(%ebp)
80104ac9:	e8 7a 03 00 00       	call   80104e48 <acquire>
80104ace:	83 c4 10             	add    $0x10,%esp
  }
}
80104ad1:	90                   	nop
80104ad2:	c9                   	leave  
80104ad3:	c3                   	ret    

80104ad4 <wakeup1>:
//PAGEBREAK!
// Wake up all processes sleeping on chan.
// The ptable lock must be held.
static void
wakeup1(void *chan)
{
80104ad4:	55                   	push   %ebp
80104ad5:	89 e5                	mov    %esp,%ebp
80104ad7:	83 ec 10             	sub    $0x10,%esp
  struct proc *p;

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104ada:	c7 45 fc 74 72 11 80 	movl   $0x80117274,-0x4(%ebp)
80104ae1:	eb 24                	jmp    80104b07 <wakeup1+0x33>
    if(p->state == SLEEPING && p->chan == chan)
80104ae3:	8b 45 fc             	mov    -0x4(%ebp),%eax
80104ae6:	8b 40 0c             	mov    0xc(%eax),%eax
80104ae9:	83 f8 02             	cmp    $0x2,%eax
80104aec:	75 15                	jne    80104b03 <wakeup1+0x2f>
80104aee:	8b 45 fc             	mov    -0x4(%ebp),%eax
80104af1:	8b 40 20             	mov    0x20(%eax),%eax
80104af4:	39 45 08             	cmp    %eax,0x8(%ebp)
80104af7:	75 0a                	jne    80104b03 <wakeup1+0x2f>
      p->state = RUNNABLE;
80104af9:	8b 45 fc             	mov    -0x4(%ebp),%eax
80104afc:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104b03:	83 6d fc 80          	subl   $0xffffff80,-0x4(%ebp)
80104b07:	81 7d fc 74 92 11 80 	cmpl   $0x80119274,-0x4(%ebp)
80104b0e:	72 d3                	jb     80104ae3 <wakeup1+0xf>
}
80104b10:	90                   	nop
80104b11:	90                   	nop
80104b12:	c9                   	leave  
80104b13:	c3                   	ret    

80104b14 <wakeup>:

// Wake up all processes sleeping on chan.
void
wakeup(void *chan)
{
80104b14:	55                   	push   %ebp
80104b15:	89 e5                	mov    %esp,%ebp
80104b17:	83 ec 08             	sub    $0x8,%esp
  acquire(&ptable.lock);
80104b1a:	83 ec 0c             	sub    $0xc,%esp
80104b1d:	68 40 72 11 80       	push   $0x80117240
80104b22:	e8 21 03 00 00       	call   80104e48 <acquire>
80104b27:	83 c4 10             	add    $0x10,%esp
  wakeup1(chan);
80104b2a:	83 ec 0c             	sub    $0xc,%esp
80104b2d:	ff 75 08             	push   0x8(%ebp)
80104b30:	e8 9f ff ff ff       	call   80104ad4 <wakeup1>
80104b35:	83 c4 10             	add    $0x10,%esp
  release(&ptable.lock);
80104b38:	83 ec 0c             	sub    $0xc,%esp
80104b3b:	68 40 72 11 80       	push   $0x80117240
80104b40:	e8 71 03 00 00       	call   80104eb6 <release>
80104b45:	83 c4 10             	add    $0x10,%esp
}
80104b48:	90                   	nop
80104b49:	c9                   	leave  
80104b4a:	c3                   	ret    

80104b4b <kill>:
// Kill the process with the given pid.
// Process won't exit until it returns
// to user space (see trap in trap.c).
int
kill(int pid)
{
80104b4b:	55                   	push   %ebp
80104b4c:	89 e5                	mov    %esp,%ebp
80104b4e:	83 ec 18             	sub    $0x18,%esp
  struct proc *p;

  acquire(&ptable.lock);
80104b51:	83 ec 0c             	sub    $0xc,%esp
80104b54:	68 40 72 11 80       	push   $0x80117240
80104b59:	e8 ea 02 00 00       	call   80104e48 <acquire>
80104b5e:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104b61:	c7 45 f4 74 72 11 80 	movl   $0x80117274,-0xc(%ebp)
80104b68:	eb 45                	jmp    80104baf <kill+0x64>
    if(p->pid == pid){
80104b6a:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104b6d:	8b 40 10             	mov    0x10(%eax),%eax
80104b70:	39 45 08             	cmp    %eax,0x8(%ebp)
80104b73:	75 36                	jne    80104bab <kill+0x60>
      p->killed = 1;
80104b75:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104b78:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
      // Wake process from sleep if necessary.
      if(p->state == SLEEPING)
80104b7f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104b82:	8b 40 0c             	mov    0xc(%eax),%eax
80104b85:	83 f8 02             	cmp    $0x2,%eax
80104b88:	75 0a                	jne    80104b94 <kill+0x49>
        p->state = RUNNABLE;
80104b8a:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104b8d:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
      release(&ptable.lock);
80104b94:	83 ec 0c             	sub    $0xc,%esp
80104b97:	68 40 72 11 80       	push   $0x80117240
80104b9c:	e8 15 03 00 00       	call   80104eb6 <release>
80104ba1:	83 c4 10             	add    $0x10,%esp
      return 0;
80104ba4:	b8 00 00 00 00       	mov    $0x0,%eax
80104ba9:	eb 22                	jmp    80104bcd <kill+0x82>
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104bab:	83 6d f4 80          	subl   $0xffffff80,-0xc(%ebp)
80104baf:	81 7d f4 74 92 11 80 	cmpl   $0x80119274,-0xc(%ebp)
80104bb6:	72 b2                	jb     80104b6a <kill+0x1f>
    }
  }
  release(&ptable.lock);
80104bb8:	83 ec 0c             	sub    $0xc,%esp
80104bbb:	68 40 72 11 80       	push   $0x80117240
80104bc0:	e8 f1 02 00 00       	call   80104eb6 <release>
80104bc5:	83 c4 10             	add    $0x10,%esp
  return -1;
80104bc8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104bcd:	c9                   	leave  
80104bce:	c3                   	ret    

80104bcf <procdump>:
// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void
procdump(void)
{
80104bcf:	55                   	push   %ebp
80104bd0:	89 e5                	mov    %esp,%ebp
80104bd2:	83 ec 48             	sub    $0x48,%esp
  int i;
  struct proc *p;
  char *state;
  uint pc[10];

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104bd5:	c7 45 f0 74 72 11 80 	movl   $0x80117274,-0x10(%ebp)
80104bdc:	e9 d7 00 00 00       	jmp    80104cb8 <procdump+0xe9>
    if(p->state == UNUSED)
80104be1:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104be4:	8b 40 0c             	mov    0xc(%eax),%eax
80104be7:	85 c0                	test   %eax,%eax
80104be9:	0f 84 c4 00 00 00    	je     80104cb3 <procdump+0xe4>
      continue;
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
80104bef:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104bf2:	8b 40 0c             	mov    0xc(%eax),%eax
80104bf5:	83 f8 05             	cmp    $0x5,%eax
80104bf8:	77 23                	ja     80104c1d <procdump+0x4e>
80104bfa:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104bfd:	8b 40 0c             	mov    0xc(%eax),%eax
80104c00:	8b 04 85 08 f0 10 80 	mov    -0x7fef0ff8(,%eax,4),%eax
80104c07:	85 c0                	test   %eax,%eax
80104c09:	74 12                	je     80104c1d <procdump+0x4e>
      state = states[p->state];
80104c0b:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104c0e:	8b 40 0c             	mov    0xc(%eax),%eax
80104c11:	8b 04 85 08 f0 10 80 	mov    -0x7fef0ff8(,%eax,4),%eax
80104c18:	89 45 ec             	mov    %eax,-0x14(%ebp)
80104c1b:	eb 07                	jmp    80104c24 <procdump+0x55>
    else
      state = "???";
80104c1d:	c7 45 ec ea a9 10 80 	movl   $0x8010a9ea,-0x14(%ebp)
    cprintf("%d %s %s", p->pid, state, p->name);
80104c24:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104c27:	8d 50 6c             	lea    0x6c(%eax),%edx
80104c2a:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104c2d:	8b 40 10             	mov    0x10(%eax),%eax
80104c30:	52                   	push   %edx
80104c31:	ff 75 ec             	push   -0x14(%ebp)
80104c34:	50                   	push   %eax
80104c35:	68 ee a9 10 80       	push   $0x8010a9ee
80104c3a:	e8 b5 b7 ff ff       	call   801003f4 <cprintf>
80104c3f:	83 c4 10             	add    $0x10,%esp
    if(p->state == SLEEPING){
80104c42:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104c45:	8b 40 0c             	mov    0xc(%eax),%eax
80104c48:	83 f8 02             	cmp    $0x2,%eax
80104c4b:	75 54                	jne    80104ca1 <procdump+0xd2>
      getcallerpcs((uint*)p->context->ebp+2, pc);
80104c4d:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104c50:	8b 40 1c             	mov    0x1c(%eax),%eax
80104c53:	8b 40 0c             	mov    0xc(%eax),%eax
80104c56:	83 c0 08             	add    $0x8,%eax
80104c59:	89 c2                	mov    %eax,%edx
80104c5b:	83 ec 08             	sub    $0x8,%esp
80104c5e:	8d 45 c4             	lea    -0x3c(%ebp),%eax
80104c61:	50                   	push   %eax
80104c62:	52                   	push   %edx
80104c63:	e8 a0 02 00 00       	call   80104f08 <getcallerpcs>
80104c68:	83 c4 10             	add    $0x10,%esp
      for(i=0; i<10 && pc[i] != 0; i++)
80104c6b:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80104c72:	eb 1c                	jmp    80104c90 <procdump+0xc1>
        cprintf(" %p", pc[i]);
80104c74:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104c77:	8b 44 85 c4          	mov    -0x3c(%ebp,%eax,4),%eax
80104c7b:	83 ec 08             	sub    $0x8,%esp
80104c7e:	50                   	push   %eax
80104c7f:	68 f7 a9 10 80       	push   $0x8010a9f7
80104c84:	e8 6b b7 ff ff       	call   801003f4 <cprintf>
80104c89:	83 c4 10             	add    $0x10,%esp
      for(i=0; i<10 && pc[i] != 0; i++)
80104c8c:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80104c90:	83 7d f4 09          	cmpl   $0x9,-0xc(%ebp)
80104c94:	7f 0b                	jg     80104ca1 <procdump+0xd2>
80104c96:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104c99:	8b 44 85 c4          	mov    -0x3c(%ebp,%eax,4),%eax
80104c9d:	85 c0                	test   %eax,%eax
80104c9f:	75 d3                	jne    80104c74 <procdump+0xa5>
    }
    cprintf("\n");
80104ca1:	83 ec 0c             	sub    $0xc,%esp
80104ca4:	68 fb a9 10 80       	push   $0x8010a9fb
80104ca9:	e8 46 b7 ff ff       	call   801003f4 <cprintf>
80104cae:	83 c4 10             	add    $0x10,%esp
80104cb1:	eb 01                	jmp    80104cb4 <procdump+0xe5>
      continue;
80104cb3:	90                   	nop
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104cb4:	83 6d f0 80          	subl   $0xffffff80,-0x10(%ebp)
80104cb8:	81 7d f0 74 92 11 80 	cmpl   $0x80119274,-0x10(%ebp)
80104cbf:	0f 82 1c ff ff ff    	jb     80104be1 <procdump+0x12>
  }
}
80104cc5:	90                   	nop
80104cc6:	90                   	nop
80104cc7:	c9                   	leave  
80104cc8:	c3                   	ret    

80104cc9 <initsleeplock>:
#include "spinlock.h"
#include "sleeplock.h"

void
initsleeplock(struct sleeplock *lk, char *name)
{
80104cc9:	55                   	push   %ebp
80104cca:	89 e5                	mov    %esp,%ebp
80104ccc:	83 ec 08             	sub    $0x8,%esp
  initlock(&lk->lk, "sleep lock");
80104ccf:	8b 45 08             	mov    0x8(%ebp),%eax
80104cd2:	83 c0 04             	add    $0x4,%eax
80104cd5:	83 ec 08             	sub    $0x8,%esp
80104cd8:	68 27 aa 10 80       	push   $0x8010aa27
80104cdd:	50                   	push   %eax
80104cde:	e8 43 01 00 00       	call   80104e26 <initlock>
80104ce3:	83 c4 10             	add    $0x10,%esp
  lk->name = name;
80104ce6:	8b 45 08             	mov    0x8(%ebp),%eax
80104ce9:	8b 55 0c             	mov    0xc(%ebp),%edx
80104cec:	89 50 38             	mov    %edx,0x38(%eax)
  lk->locked = 0;
80104cef:	8b 45 08             	mov    0x8(%ebp),%eax
80104cf2:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  lk->pid = 0;
80104cf8:	8b 45 08             	mov    0x8(%ebp),%eax
80104cfb:	c7 40 3c 00 00 00 00 	movl   $0x0,0x3c(%eax)
}
80104d02:	90                   	nop
80104d03:	c9                   	leave  
80104d04:	c3                   	ret    

80104d05 <acquiresleep>:

void
acquiresleep(struct sleeplock *lk)
{
80104d05:	55                   	push   %ebp
80104d06:	89 e5                	mov    %esp,%ebp
80104d08:	83 ec 08             	sub    $0x8,%esp
  acquire(&lk->lk);
80104d0b:	8b 45 08             	mov    0x8(%ebp),%eax
80104d0e:	83 c0 04             	add    $0x4,%eax
80104d11:	83 ec 0c             	sub    $0xc,%esp
80104d14:	50                   	push   %eax
80104d15:	e8 2e 01 00 00       	call   80104e48 <acquire>
80104d1a:	83 c4 10             	add    $0x10,%esp
  while (lk->locked) {
80104d1d:	eb 15                	jmp    80104d34 <acquiresleep+0x2f>
    sleep(lk, &lk->lk);
80104d1f:	8b 45 08             	mov    0x8(%ebp),%eax
80104d22:	83 c0 04             	add    $0x4,%eax
80104d25:	83 ec 08             	sub    $0x8,%esp
80104d28:	50                   	push   %eax
80104d29:	ff 75 08             	push   0x8(%ebp)
80104d2c:	e8 fc fc ff ff       	call   80104a2d <sleep>
80104d31:	83 c4 10             	add    $0x10,%esp
  while (lk->locked) {
80104d34:	8b 45 08             	mov    0x8(%ebp),%eax
80104d37:	8b 00                	mov    (%eax),%eax
80104d39:	85 c0                	test   %eax,%eax
80104d3b:	75 e2                	jne    80104d1f <acquiresleep+0x1a>
  }
  lk->locked = 1;
80104d3d:	8b 45 08             	mov    0x8(%ebp),%eax
80104d40:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  lk->pid = myproc()->pid;
80104d46:	e8 c9 f1 ff ff       	call   80103f14 <myproc>
80104d4b:	8b 50 10             	mov    0x10(%eax),%edx
80104d4e:	8b 45 08             	mov    0x8(%ebp),%eax
80104d51:	89 50 3c             	mov    %edx,0x3c(%eax)
  release(&lk->lk);
80104d54:	8b 45 08             	mov    0x8(%ebp),%eax
80104d57:	83 c0 04             	add    $0x4,%eax
80104d5a:	83 ec 0c             	sub    $0xc,%esp
80104d5d:	50                   	push   %eax
80104d5e:	e8 53 01 00 00       	call   80104eb6 <release>
80104d63:	83 c4 10             	add    $0x10,%esp
}
80104d66:	90                   	nop
80104d67:	c9                   	leave  
80104d68:	c3                   	ret    

80104d69 <releasesleep>:

void
releasesleep(struct sleeplock *lk)
{
80104d69:	55                   	push   %ebp
80104d6a:	89 e5                	mov    %esp,%ebp
80104d6c:	83 ec 08             	sub    $0x8,%esp
  acquire(&lk->lk);
80104d6f:	8b 45 08             	mov    0x8(%ebp),%eax
80104d72:	83 c0 04             	add    $0x4,%eax
80104d75:	83 ec 0c             	sub    $0xc,%esp
80104d78:	50                   	push   %eax
80104d79:	e8 ca 00 00 00       	call   80104e48 <acquire>
80104d7e:	83 c4 10             	add    $0x10,%esp
  lk->locked = 0;
80104d81:	8b 45 08             	mov    0x8(%ebp),%eax
80104d84:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  lk->pid = 0;
80104d8a:	8b 45 08             	mov    0x8(%ebp),%eax
80104d8d:	c7 40 3c 00 00 00 00 	movl   $0x0,0x3c(%eax)
  wakeup(lk);
80104d94:	83 ec 0c             	sub    $0xc,%esp
80104d97:	ff 75 08             	push   0x8(%ebp)
80104d9a:	e8 75 fd ff ff       	call   80104b14 <wakeup>
80104d9f:	83 c4 10             	add    $0x10,%esp
  release(&lk->lk);
80104da2:	8b 45 08             	mov    0x8(%ebp),%eax
80104da5:	83 c0 04             	add    $0x4,%eax
80104da8:	83 ec 0c             	sub    $0xc,%esp
80104dab:	50                   	push   %eax
80104dac:	e8 05 01 00 00       	call   80104eb6 <release>
80104db1:	83 c4 10             	add    $0x10,%esp
}
80104db4:	90                   	nop
80104db5:	c9                   	leave  
80104db6:	c3                   	ret    

80104db7 <holdingsleep>:

int
holdingsleep(struct sleeplock *lk)
{
80104db7:	55                   	push   %ebp
80104db8:	89 e5                	mov    %esp,%ebp
80104dba:	83 ec 18             	sub    $0x18,%esp
  int r;
  
  acquire(&lk->lk);
80104dbd:	8b 45 08             	mov    0x8(%ebp),%eax
80104dc0:	83 c0 04             	add    $0x4,%eax
80104dc3:	83 ec 0c             	sub    $0xc,%esp
80104dc6:	50                   	push   %eax
80104dc7:	e8 7c 00 00 00       	call   80104e48 <acquire>
80104dcc:	83 c4 10             	add    $0x10,%esp
  r = lk->locked;
80104dcf:	8b 45 08             	mov    0x8(%ebp),%eax
80104dd2:	8b 00                	mov    (%eax),%eax
80104dd4:	89 45 f4             	mov    %eax,-0xc(%ebp)
  release(&lk->lk);
80104dd7:	8b 45 08             	mov    0x8(%ebp),%eax
80104dda:	83 c0 04             	add    $0x4,%eax
80104ddd:	83 ec 0c             	sub    $0xc,%esp
80104de0:	50                   	push   %eax
80104de1:	e8 d0 00 00 00       	call   80104eb6 <release>
80104de6:	83 c4 10             	add    $0x10,%esp
  return r;
80104de9:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
80104dec:	c9                   	leave  
80104ded:	c3                   	ret    

80104dee <readeflags>:
{
80104dee:	55                   	push   %ebp
80104def:	89 e5                	mov    %esp,%ebp
80104df1:	83 ec 10             	sub    $0x10,%esp
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80104df4:	9c                   	pushf  
80104df5:	58                   	pop    %eax
80104df6:	89 45 fc             	mov    %eax,-0x4(%ebp)
  return eflags;
80104df9:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
80104dfc:	c9                   	leave  
80104dfd:	c3                   	ret    

80104dfe <cli>:
{
80104dfe:	55                   	push   %ebp
80104dff:	89 e5                	mov    %esp,%ebp
  asm volatile("cli");
80104e01:	fa                   	cli    
}
80104e02:	90                   	nop
80104e03:	5d                   	pop    %ebp
80104e04:	c3                   	ret    

80104e05 <sti>:
{
80104e05:	55                   	push   %ebp
80104e06:	89 e5                	mov    %esp,%ebp
  asm volatile("sti");
80104e08:	fb                   	sti    
}
80104e09:	90                   	nop
80104e0a:	5d                   	pop    %ebp
80104e0b:	c3                   	ret    

80104e0c <xchg>:
{
80104e0c:	55                   	push   %ebp
80104e0d:	89 e5                	mov    %esp,%ebp
80104e0f:	83 ec 10             	sub    $0x10,%esp
  asm volatile("lock; xchgl %0, %1" :
80104e12:	8b 55 08             	mov    0x8(%ebp),%edx
80104e15:	8b 45 0c             	mov    0xc(%ebp),%eax
80104e18:	8b 4d 08             	mov    0x8(%ebp),%ecx
80104e1b:	f0 87 02             	lock xchg %eax,(%edx)
80104e1e:	89 45 fc             	mov    %eax,-0x4(%ebp)
  return result;
80104e21:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
80104e24:	c9                   	leave  
80104e25:	c3                   	ret    

80104e26 <initlock>:
#include "proc.h"
#include "spinlock.h"

void
initlock(struct spinlock *lk, char *name)
{
80104e26:	55                   	push   %ebp
80104e27:	89 e5                	mov    %esp,%ebp
  lk->name = name;
80104e29:	8b 45 08             	mov    0x8(%ebp),%eax
80104e2c:	8b 55 0c             	mov    0xc(%ebp),%edx
80104e2f:	89 50 04             	mov    %edx,0x4(%eax)
  lk->locked = 0;
80104e32:	8b 45 08             	mov    0x8(%ebp),%eax
80104e35:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  lk->cpu = 0;
80104e3b:	8b 45 08             	mov    0x8(%ebp),%eax
80104e3e:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
}
80104e45:	90                   	nop
80104e46:	5d                   	pop    %ebp
80104e47:	c3                   	ret    

80104e48 <acquire>:
// Loops (spins) until the lock is acquired.
// Holding a lock for a long time may cause
// other CPUs to waste time spinning to acquire it.
void
acquire(struct spinlock *lk)
{
80104e48:	55                   	push   %ebp
80104e49:	89 e5                	mov    %esp,%ebp
80104e4b:	53                   	push   %ebx
80104e4c:	83 ec 04             	sub    $0x4,%esp
  pushcli(); // disable interrupts to avoid deadlock.
80104e4f:	e8 5f 01 00 00       	call   80104fb3 <pushcli>
  if(holding(lk)){
80104e54:	8b 45 08             	mov    0x8(%ebp),%eax
80104e57:	83 ec 0c             	sub    $0xc,%esp
80104e5a:	50                   	push   %eax
80104e5b:	e8 23 01 00 00       	call   80104f83 <holding>
80104e60:	83 c4 10             	add    $0x10,%esp
80104e63:	85 c0                	test   %eax,%eax
80104e65:	74 0d                	je     80104e74 <acquire+0x2c>
    panic("acquire");
80104e67:	83 ec 0c             	sub    $0xc,%esp
80104e6a:	68 32 aa 10 80       	push   $0x8010aa32
80104e6f:	e8 35 b7 ff ff       	call   801005a9 <panic>
  }

  // The xchg is atomic.
  while(xchg(&lk->locked, 1) != 0)
80104e74:	90                   	nop
80104e75:	8b 45 08             	mov    0x8(%ebp),%eax
80104e78:	83 ec 08             	sub    $0x8,%esp
80104e7b:	6a 01                	push   $0x1
80104e7d:	50                   	push   %eax
80104e7e:	e8 89 ff ff ff       	call   80104e0c <xchg>
80104e83:	83 c4 10             	add    $0x10,%esp
80104e86:	85 c0                	test   %eax,%eax
80104e88:	75 eb                	jne    80104e75 <acquire+0x2d>
    ;

  // Tell the C compiler and the processor to not move loads or stores
  // past this point, to ensure that the critical section's memory
  // references happen after the lock is acquired.
  __sync_synchronize();
80104e8a:	f0 83 0c 24 00       	lock orl $0x0,(%esp)

  // Record info about lock acquisition for debugging.
  lk->cpu = mycpu();
80104e8f:	8b 5d 08             	mov    0x8(%ebp),%ebx
80104e92:	e8 05 f0 ff ff       	call   80103e9c <mycpu>
80104e97:	89 43 08             	mov    %eax,0x8(%ebx)
  getcallerpcs(&lk, lk->pcs);
80104e9a:	8b 45 08             	mov    0x8(%ebp),%eax
80104e9d:	83 c0 0c             	add    $0xc,%eax
80104ea0:	83 ec 08             	sub    $0x8,%esp
80104ea3:	50                   	push   %eax
80104ea4:	8d 45 08             	lea    0x8(%ebp),%eax
80104ea7:	50                   	push   %eax
80104ea8:	e8 5b 00 00 00       	call   80104f08 <getcallerpcs>
80104ead:	83 c4 10             	add    $0x10,%esp
}
80104eb0:	90                   	nop
80104eb1:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104eb4:	c9                   	leave  
80104eb5:	c3                   	ret    

80104eb6 <release>:

// Release the lock.
void
release(struct spinlock *lk)
{
80104eb6:	55                   	push   %ebp
80104eb7:	89 e5                	mov    %esp,%ebp
80104eb9:	83 ec 08             	sub    $0x8,%esp
  if(!holding(lk))
80104ebc:	83 ec 0c             	sub    $0xc,%esp
80104ebf:	ff 75 08             	push   0x8(%ebp)
80104ec2:	e8 bc 00 00 00       	call   80104f83 <holding>
80104ec7:	83 c4 10             	add    $0x10,%esp
80104eca:	85 c0                	test   %eax,%eax
80104ecc:	75 0d                	jne    80104edb <release+0x25>
    panic("release");
80104ece:	83 ec 0c             	sub    $0xc,%esp
80104ed1:	68 3a aa 10 80       	push   $0x8010aa3a
80104ed6:	e8 ce b6 ff ff       	call   801005a9 <panic>

  lk->pcs[0] = 0;
80104edb:	8b 45 08             	mov    0x8(%ebp),%eax
80104ede:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
  lk->cpu = 0;
80104ee5:	8b 45 08             	mov    0x8(%ebp),%eax
80104ee8:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  // Tell the C compiler and the processor to not move loads or stores
  // past this point, to ensure that all the stores in the critical
  // section are visible to other cores before the lock is released.
  // Both the C compiler and the hardware may re-order loads and
  // stores; __sync_synchronize() tells them both not to.
  __sync_synchronize();
80104eef:	f0 83 0c 24 00       	lock orl $0x0,(%esp)

  // Release the lock, equivalent to lk->locked = 0.
  // This code can't use a C assignment, since it might
  // not be atomic. A real OS would use C atomics here.
  asm volatile("movl $0, %0" : "+m" (lk->locked) : );
80104ef4:	8b 45 08             	mov    0x8(%ebp),%eax
80104ef7:	8b 55 08             	mov    0x8(%ebp),%edx
80104efa:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

  popcli();
80104f00:	e8 fb 00 00 00       	call   80105000 <popcli>
}
80104f05:	90                   	nop
80104f06:	c9                   	leave  
80104f07:	c3                   	ret    

80104f08 <getcallerpcs>:

// Record the current call stack in pcs[] by following the %ebp chain.
void
getcallerpcs(void *v, uint pcs[])
{
80104f08:	55                   	push   %ebp
80104f09:	89 e5                	mov    %esp,%ebp
80104f0b:	83 ec 10             	sub    $0x10,%esp
  uint *ebp;
  int i;

  ebp = (uint*)v - 2;
80104f0e:	8b 45 08             	mov    0x8(%ebp),%eax
80104f11:	83 e8 08             	sub    $0x8,%eax
80104f14:	89 45 fc             	mov    %eax,-0x4(%ebp)
  for(i = 0; i < 10; i++){
80104f17:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
80104f1e:	eb 38                	jmp    80104f58 <getcallerpcs+0x50>
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
80104f20:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
80104f24:	74 53                	je     80104f79 <getcallerpcs+0x71>
80104f26:	81 7d fc ff ff ff 7f 	cmpl   $0x7fffffff,-0x4(%ebp)
80104f2d:	76 4a                	jbe    80104f79 <getcallerpcs+0x71>
80104f2f:	83 7d fc ff          	cmpl   $0xffffffff,-0x4(%ebp)
80104f33:	74 44                	je     80104f79 <getcallerpcs+0x71>
      break;
    pcs[i] = ebp[1];     // saved %eip
80104f35:	8b 45 f8             	mov    -0x8(%ebp),%eax
80104f38:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80104f3f:	8b 45 0c             	mov    0xc(%ebp),%eax
80104f42:	01 c2                	add    %eax,%edx
80104f44:	8b 45 fc             	mov    -0x4(%ebp),%eax
80104f47:	8b 40 04             	mov    0x4(%eax),%eax
80104f4a:	89 02                	mov    %eax,(%edx)
    ebp = (uint*)ebp[0]; // saved %ebp
80104f4c:	8b 45 fc             	mov    -0x4(%ebp),%eax
80104f4f:	8b 00                	mov    (%eax),%eax
80104f51:	89 45 fc             	mov    %eax,-0x4(%ebp)
  for(i = 0; i < 10; i++){
80104f54:	83 45 f8 01          	addl   $0x1,-0x8(%ebp)
80104f58:	83 7d f8 09          	cmpl   $0x9,-0x8(%ebp)
80104f5c:	7e c2                	jle    80104f20 <getcallerpcs+0x18>
  }
  for(; i < 10; i++)
80104f5e:	eb 19                	jmp    80104f79 <getcallerpcs+0x71>
    pcs[i] = 0;
80104f60:	8b 45 f8             	mov    -0x8(%ebp),%eax
80104f63:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80104f6a:	8b 45 0c             	mov    0xc(%ebp),%eax
80104f6d:	01 d0                	add    %edx,%eax
80104f6f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  for(; i < 10; i++)
80104f75:	83 45 f8 01          	addl   $0x1,-0x8(%ebp)
80104f79:	83 7d f8 09          	cmpl   $0x9,-0x8(%ebp)
80104f7d:	7e e1                	jle    80104f60 <getcallerpcs+0x58>
}
80104f7f:	90                   	nop
80104f80:	90                   	nop
80104f81:	c9                   	leave  
80104f82:	c3                   	ret    

80104f83 <holding>:

// Check whether this cpu is holding the lock.
int
holding(struct spinlock *lock)
{
80104f83:	55                   	push   %ebp
80104f84:	89 e5                	mov    %esp,%ebp
80104f86:	53                   	push   %ebx
80104f87:	83 ec 04             	sub    $0x4,%esp
  return lock->locked && lock->cpu == mycpu();
80104f8a:	8b 45 08             	mov    0x8(%ebp),%eax
80104f8d:	8b 00                	mov    (%eax),%eax
80104f8f:	85 c0                	test   %eax,%eax
80104f91:	74 16                	je     80104fa9 <holding+0x26>
80104f93:	8b 45 08             	mov    0x8(%ebp),%eax
80104f96:	8b 58 08             	mov    0x8(%eax),%ebx
80104f99:	e8 fe ee ff ff       	call   80103e9c <mycpu>
80104f9e:	39 c3                	cmp    %eax,%ebx
80104fa0:	75 07                	jne    80104fa9 <holding+0x26>
80104fa2:	b8 01 00 00 00       	mov    $0x1,%eax
80104fa7:	eb 05                	jmp    80104fae <holding+0x2b>
80104fa9:	b8 00 00 00 00       	mov    $0x0,%eax
}
80104fae:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104fb1:	c9                   	leave  
80104fb2:	c3                   	ret    

80104fb3 <pushcli>:
// it takes two popcli to undo two pushcli.  Also, if interrupts
// are off, then pushcli, popcli leaves them off.

void
pushcli(void)
{
80104fb3:	55                   	push   %ebp
80104fb4:	89 e5                	mov    %esp,%ebp
80104fb6:	83 ec 18             	sub    $0x18,%esp
  int eflags;

  eflags = readeflags();
80104fb9:	e8 30 fe ff ff       	call   80104dee <readeflags>
80104fbe:	89 45 f4             	mov    %eax,-0xc(%ebp)
  cli();
80104fc1:	e8 38 fe ff ff       	call   80104dfe <cli>
  if(mycpu()->ncli == 0)
80104fc6:	e8 d1 ee ff ff       	call   80103e9c <mycpu>
80104fcb:	8b 80 a4 00 00 00    	mov    0xa4(%eax),%eax
80104fd1:	85 c0                	test   %eax,%eax
80104fd3:	75 14                	jne    80104fe9 <pushcli+0x36>
    mycpu()->intena = eflags & FL_IF;
80104fd5:	e8 c2 ee ff ff       	call   80103e9c <mycpu>
80104fda:	8b 55 f4             	mov    -0xc(%ebp),%edx
80104fdd:	81 e2 00 02 00 00    	and    $0x200,%edx
80104fe3:	89 90 a8 00 00 00    	mov    %edx,0xa8(%eax)
  mycpu()->ncli += 1;
80104fe9:	e8 ae ee ff ff       	call   80103e9c <mycpu>
80104fee:	8b 90 a4 00 00 00    	mov    0xa4(%eax),%edx
80104ff4:	83 c2 01             	add    $0x1,%edx
80104ff7:	89 90 a4 00 00 00    	mov    %edx,0xa4(%eax)
}
80104ffd:	90                   	nop
80104ffe:	c9                   	leave  
80104fff:	c3                   	ret    

80105000 <popcli>:

void
popcli(void)
{
80105000:	55                   	push   %ebp
80105001:	89 e5                	mov    %esp,%ebp
80105003:	83 ec 08             	sub    $0x8,%esp
  if(readeflags()&FL_IF)
80105006:	e8 e3 fd ff ff       	call   80104dee <readeflags>
8010500b:	25 00 02 00 00       	and    $0x200,%eax
80105010:	85 c0                	test   %eax,%eax
80105012:	74 0d                	je     80105021 <popcli+0x21>
    panic("popcli - interruptible");
80105014:	83 ec 0c             	sub    $0xc,%esp
80105017:	68 42 aa 10 80       	push   $0x8010aa42
8010501c:	e8 88 b5 ff ff       	call   801005a9 <panic>
  if(--mycpu()->ncli < 0)
80105021:	e8 76 ee ff ff       	call   80103e9c <mycpu>
80105026:	8b 90 a4 00 00 00    	mov    0xa4(%eax),%edx
8010502c:	83 ea 01             	sub    $0x1,%edx
8010502f:	89 90 a4 00 00 00    	mov    %edx,0xa4(%eax)
80105035:	8b 80 a4 00 00 00    	mov    0xa4(%eax),%eax
8010503b:	85 c0                	test   %eax,%eax
8010503d:	79 0d                	jns    8010504c <popcli+0x4c>
    panic("popcli");
8010503f:	83 ec 0c             	sub    $0xc,%esp
80105042:	68 59 aa 10 80       	push   $0x8010aa59
80105047:	e8 5d b5 ff ff       	call   801005a9 <panic>
  if(mycpu()->ncli == 0 && mycpu()->intena)
8010504c:	e8 4b ee ff ff       	call   80103e9c <mycpu>
80105051:	8b 80 a4 00 00 00    	mov    0xa4(%eax),%eax
80105057:	85 c0                	test   %eax,%eax
80105059:	75 14                	jne    8010506f <popcli+0x6f>
8010505b:	e8 3c ee ff ff       	call   80103e9c <mycpu>
80105060:	8b 80 a8 00 00 00    	mov    0xa8(%eax),%eax
80105066:	85 c0                	test   %eax,%eax
80105068:	74 05                	je     8010506f <popcli+0x6f>
    sti();
8010506a:	e8 96 fd ff ff       	call   80104e05 <sti>
}
8010506f:	90                   	nop
80105070:	c9                   	leave  
80105071:	c3                   	ret    

80105072 <stosb>:
80105072:	55                   	push   %ebp
80105073:	89 e5                	mov    %esp,%ebp
80105075:	57                   	push   %edi
80105076:	53                   	push   %ebx
80105077:	8b 4d 08             	mov    0x8(%ebp),%ecx
8010507a:	8b 55 10             	mov    0x10(%ebp),%edx
8010507d:	8b 45 0c             	mov    0xc(%ebp),%eax
80105080:	89 cb                	mov    %ecx,%ebx
80105082:	89 df                	mov    %ebx,%edi
80105084:	89 d1                	mov    %edx,%ecx
80105086:	fc                   	cld    
80105087:	f3 aa                	rep stos %al,%es:(%edi)
80105089:	89 ca                	mov    %ecx,%edx
8010508b:	89 fb                	mov    %edi,%ebx
8010508d:	89 5d 08             	mov    %ebx,0x8(%ebp)
80105090:	89 55 10             	mov    %edx,0x10(%ebp)
80105093:	90                   	nop
80105094:	5b                   	pop    %ebx
80105095:	5f                   	pop    %edi
80105096:	5d                   	pop    %ebp
80105097:	c3                   	ret    

80105098 <stosl>:
80105098:	55                   	push   %ebp
80105099:	89 e5                	mov    %esp,%ebp
8010509b:	57                   	push   %edi
8010509c:	53                   	push   %ebx
8010509d:	8b 4d 08             	mov    0x8(%ebp),%ecx
801050a0:	8b 55 10             	mov    0x10(%ebp),%edx
801050a3:	8b 45 0c             	mov    0xc(%ebp),%eax
801050a6:	89 cb                	mov    %ecx,%ebx
801050a8:	89 df                	mov    %ebx,%edi
801050aa:	89 d1                	mov    %edx,%ecx
801050ac:	fc                   	cld    
801050ad:	f3 ab                	rep stos %eax,%es:(%edi)
801050af:	89 ca                	mov    %ecx,%edx
801050b1:	89 fb                	mov    %edi,%ebx
801050b3:	89 5d 08             	mov    %ebx,0x8(%ebp)
801050b6:	89 55 10             	mov    %edx,0x10(%ebp)
801050b9:	90                   	nop
801050ba:	5b                   	pop    %ebx
801050bb:	5f                   	pop    %edi
801050bc:	5d                   	pop    %ebp
801050bd:	c3                   	ret    

801050be <memset>:
801050be:	55                   	push   %ebp
801050bf:	89 e5                	mov    %esp,%ebp
801050c1:	8b 45 08             	mov    0x8(%ebp),%eax
801050c4:	83 e0 03             	and    $0x3,%eax
801050c7:	85 c0                	test   %eax,%eax
801050c9:	75 43                	jne    8010510e <memset+0x50>
801050cb:	8b 45 10             	mov    0x10(%ebp),%eax
801050ce:	83 e0 03             	and    $0x3,%eax
801050d1:	85 c0                	test   %eax,%eax
801050d3:	75 39                	jne    8010510e <memset+0x50>
801050d5:	81 65 0c ff 00 00 00 	andl   $0xff,0xc(%ebp)
801050dc:	8b 45 10             	mov    0x10(%ebp),%eax
801050df:	c1 e8 02             	shr    $0x2,%eax
801050e2:	89 c2                	mov    %eax,%edx
801050e4:	8b 45 0c             	mov    0xc(%ebp),%eax
801050e7:	c1 e0 18             	shl    $0x18,%eax
801050ea:	89 c1                	mov    %eax,%ecx
801050ec:	8b 45 0c             	mov    0xc(%ebp),%eax
801050ef:	c1 e0 10             	shl    $0x10,%eax
801050f2:	09 c1                	or     %eax,%ecx
801050f4:	8b 45 0c             	mov    0xc(%ebp),%eax
801050f7:	c1 e0 08             	shl    $0x8,%eax
801050fa:	09 c8                	or     %ecx,%eax
801050fc:	0b 45 0c             	or     0xc(%ebp),%eax
801050ff:	52                   	push   %edx
80105100:	50                   	push   %eax
80105101:	ff 75 08             	push   0x8(%ebp)
80105104:	e8 8f ff ff ff       	call   80105098 <stosl>
80105109:	83 c4 0c             	add    $0xc,%esp
8010510c:	eb 12                	jmp    80105120 <memset+0x62>
8010510e:	8b 45 10             	mov    0x10(%ebp),%eax
80105111:	50                   	push   %eax
80105112:	ff 75 0c             	push   0xc(%ebp)
80105115:	ff 75 08             	push   0x8(%ebp)
80105118:	e8 55 ff ff ff       	call   80105072 <stosb>
8010511d:	83 c4 0c             	add    $0xc,%esp
80105120:	8b 45 08             	mov    0x8(%ebp),%eax
80105123:	c9                   	leave  
80105124:	c3                   	ret    

80105125 <memcmp>:
80105125:	55                   	push   %ebp
80105126:	89 e5                	mov    %esp,%ebp
80105128:	83 ec 10             	sub    $0x10,%esp
8010512b:	8b 45 08             	mov    0x8(%ebp),%eax
8010512e:	89 45 fc             	mov    %eax,-0x4(%ebp)
80105131:	8b 45 0c             	mov    0xc(%ebp),%eax
80105134:	89 45 f8             	mov    %eax,-0x8(%ebp)
80105137:	eb 30                	jmp    80105169 <memcmp+0x44>
80105139:	8b 45 fc             	mov    -0x4(%ebp),%eax
8010513c:	0f b6 10             	movzbl (%eax),%edx
8010513f:	8b 45 f8             	mov    -0x8(%ebp),%eax
80105142:	0f b6 00             	movzbl (%eax),%eax
80105145:	38 c2                	cmp    %al,%dl
80105147:	74 18                	je     80105161 <memcmp+0x3c>
80105149:	8b 45 fc             	mov    -0x4(%ebp),%eax
8010514c:	0f b6 00             	movzbl (%eax),%eax
8010514f:	0f b6 d0             	movzbl %al,%edx
80105152:	8b 45 f8             	mov    -0x8(%ebp),%eax
80105155:	0f b6 00             	movzbl (%eax),%eax
80105158:	0f b6 c8             	movzbl %al,%ecx
8010515b:	89 d0                	mov    %edx,%eax
8010515d:	29 c8                	sub    %ecx,%eax
8010515f:	eb 1a                	jmp    8010517b <memcmp+0x56>
80105161:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
80105165:	83 45 f8 01          	addl   $0x1,-0x8(%ebp)
80105169:	8b 45 10             	mov    0x10(%ebp),%eax
8010516c:	8d 50 ff             	lea    -0x1(%eax),%edx
8010516f:	89 55 10             	mov    %edx,0x10(%ebp)
80105172:	85 c0                	test   %eax,%eax
80105174:	75 c3                	jne    80105139 <memcmp+0x14>
80105176:	b8 00 00 00 00       	mov    $0x0,%eax
8010517b:	c9                   	leave  
8010517c:	c3                   	ret    

8010517d <memmove>:
8010517d:	55                   	push   %ebp
8010517e:	89 e5                	mov    %esp,%ebp
80105180:	83 ec 10             	sub    $0x10,%esp
80105183:	8b 45 0c             	mov    0xc(%ebp),%eax
80105186:	89 45 fc             	mov    %eax,-0x4(%ebp)
80105189:	8b 45 08             	mov    0x8(%ebp),%eax
8010518c:	89 45 f8             	mov    %eax,-0x8(%ebp)
8010518f:	8b 45 fc             	mov    -0x4(%ebp),%eax
80105192:	3b 45 f8             	cmp    -0x8(%ebp),%eax
80105195:	73 54                	jae    801051eb <memmove+0x6e>
80105197:	8b 55 fc             	mov    -0x4(%ebp),%edx
8010519a:	8b 45 10             	mov    0x10(%ebp),%eax
8010519d:	01 d0                	add    %edx,%eax
8010519f:	39 45 f8             	cmp    %eax,-0x8(%ebp)
801051a2:	73 47                	jae    801051eb <memmove+0x6e>
801051a4:	8b 45 10             	mov    0x10(%ebp),%eax
801051a7:	01 45 fc             	add    %eax,-0x4(%ebp)
801051aa:	8b 45 10             	mov    0x10(%ebp),%eax
801051ad:	01 45 f8             	add    %eax,-0x8(%ebp)
801051b0:	eb 13                	jmp    801051c5 <memmove+0x48>
801051b2:	83 6d fc 01          	subl   $0x1,-0x4(%ebp)
801051b6:	83 6d f8 01          	subl   $0x1,-0x8(%ebp)
801051ba:	8b 45 fc             	mov    -0x4(%ebp),%eax
801051bd:	0f b6 10             	movzbl (%eax),%edx
801051c0:	8b 45 f8             	mov    -0x8(%ebp),%eax
801051c3:	88 10                	mov    %dl,(%eax)
801051c5:	8b 45 10             	mov    0x10(%ebp),%eax
801051c8:	8d 50 ff             	lea    -0x1(%eax),%edx
801051cb:	89 55 10             	mov    %edx,0x10(%ebp)
801051ce:	85 c0                	test   %eax,%eax
801051d0:	75 e0                	jne    801051b2 <memmove+0x35>
801051d2:	eb 24                	jmp    801051f8 <memmove+0x7b>
801051d4:	8b 55 fc             	mov    -0x4(%ebp),%edx
801051d7:	8d 42 01             	lea    0x1(%edx),%eax
801051da:	89 45 fc             	mov    %eax,-0x4(%ebp)
801051dd:	8b 45 f8             	mov    -0x8(%ebp),%eax
801051e0:	8d 48 01             	lea    0x1(%eax),%ecx
801051e3:	89 4d f8             	mov    %ecx,-0x8(%ebp)
801051e6:	0f b6 12             	movzbl (%edx),%edx
801051e9:	88 10                	mov    %dl,(%eax)
801051eb:	8b 45 10             	mov    0x10(%ebp),%eax
801051ee:	8d 50 ff             	lea    -0x1(%eax),%edx
801051f1:	89 55 10             	mov    %edx,0x10(%ebp)
801051f4:	85 c0                	test   %eax,%eax
801051f6:	75 dc                	jne    801051d4 <memmove+0x57>
801051f8:	8b 45 08             	mov    0x8(%ebp),%eax
801051fb:	c9                   	leave  
801051fc:	c3                   	ret    

801051fd <memcpy>:
801051fd:	55                   	push   %ebp
801051fe:	89 e5                	mov    %esp,%ebp
80105200:	ff 75 10             	push   0x10(%ebp)
80105203:	ff 75 0c             	push   0xc(%ebp)
80105206:	ff 75 08             	push   0x8(%ebp)
80105209:	e8 6f ff ff ff       	call   8010517d <memmove>
8010520e:	83 c4 0c             	add    $0xc,%esp
80105211:	c9                   	leave  
80105212:	c3                   	ret    

80105213 <strncmp>:
80105213:	55                   	push   %ebp
80105214:	89 e5                	mov    %esp,%ebp
80105216:	eb 0c                	jmp    80105224 <strncmp+0x11>
80105218:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
8010521c:	83 45 08 01          	addl   $0x1,0x8(%ebp)
80105220:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
80105224:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
80105228:	74 1a                	je     80105244 <strncmp+0x31>
8010522a:	8b 45 08             	mov    0x8(%ebp),%eax
8010522d:	0f b6 00             	movzbl (%eax),%eax
80105230:	84 c0                	test   %al,%al
80105232:	74 10                	je     80105244 <strncmp+0x31>
80105234:	8b 45 08             	mov    0x8(%ebp),%eax
80105237:	0f b6 10             	movzbl (%eax),%edx
8010523a:	8b 45 0c             	mov    0xc(%ebp),%eax
8010523d:	0f b6 00             	movzbl (%eax),%eax
80105240:	38 c2                	cmp    %al,%dl
80105242:	74 d4                	je     80105218 <strncmp+0x5>
80105244:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
80105248:	75 07                	jne    80105251 <strncmp+0x3e>
8010524a:	b8 00 00 00 00       	mov    $0x0,%eax
8010524f:	eb 16                	jmp    80105267 <strncmp+0x54>
80105251:	8b 45 08             	mov    0x8(%ebp),%eax
80105254:	0f b6 00             	movzbl (%eax),%eax
80105257:	0f b6 d0             	movzbl %al,%edx
8010525a:	8b 45 0c             	mov    0xc(%ebp),%eax
8010525d:	0f b6 00             	movzbl (%eax),%eax
80105260:	0f b6 c8             	movzbl %al,%ecx
80105263:	89 d0                	mov    %edx,%eax
80105265:	29 c8                	sub    %ecx,%eax
80105267:	5d                   	pop    %ebp
80105268:	c3                   	ret    

80105269 <strncpy>:
80105269:	55                   	push   %ebp
8010526a:	89 e5                	mov    %esp,%ebp
8010526c:	83 ec 10             	sub    $0x10,%esp
8010526f:	8b 45 08             	mov    0x8(%ebp),%eax
80105272:	89 45 fc             	mov    %eax,-0x4(%ebp)
80105275:	90                   	nop
80105276:	8b 45 10             	mov    0x10(%ebp),%eax
80105279:	8d 50 ff             	lea    -0x1(%eax),%edx
8010527c:	89 55 10             	mov    %edx,0x10(%ebp)
8010527f:	85 c0                	test   %eax,%eax
80105281:	7e 2c                	jle    801052af <strncpy+0x46>
80105283:	8b 55 0c             	mov    0xc(%ebp),%edx
80105286:	8d 42 01             	lea    0x1(%edx),%eax
80105289:	89 45 0c             	mov    %eax,0xc(%ebp)
8010528c:	8b 45 08             	mov    0x8(%ebp),%eax
8010528f:	8d 48 01             	lea    0x1(%eax),%ecx
80105292:	89 4d 08             	mov    %ecx,0x8(%ebp)
80105295:	0f b6 12             	movzbl (%edx),%edx
80105298:	88 10                	mov    %dl,(%eax)
8010529a:	0f b6 00             	movzbl (%eax),%eax
8010529d:	84 c0                	test   %al,%al
8010529f:	75 d5                	jne    80105276 <strncpy+0xd>
801052a1:	eb 0c                	jmp    801052af <strncpy+0x46>
801052a3:	8b 45 08             	mov    0x8(%ebp),%eax
801052a6:	8d 50 01             	lea    0x1(%eax),%edx
801052a9:	89 55 08             	mov    %edx,0x8(%ebp)
801052ac:	c6 00 00             	movb   $0x0,(%eax)
801052af:	8b 45 10             	mov    0x10(%ebp),%eax
801052b2:	8d 50 ff             	lea    -0x1(%eax),%edx
801052b5:	89 55 10             	mov    %edx,0x10(%ebp)
801052b8:	85 c0                	test   %eax,%eax
801052ba:	7f e7                	jg     801052a3 <strncpy+0x3a>
801052bc:	8b 45 fc             	mov    -0x4(%ebp),%eax
801052bf:	c9                   	leave  
801052c0:	c3                   	ret    

801052c1 <safestrcpy>:
801052c1:	55                   	push   %ebp
801052c2:	89 e5                	mov    %esp,%ebp
801052c4:	83 ec 10             	sub    $0x10,%esp
801052c7:	8b 45 08             	mov    0x8(%ebp),%eax
801052ca:	89 45 fc             	mov    %eax,-0x4(%ebp)
801052cd:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
801052d1:	7f 05                	jg     801052d8 <safestrcpy+0x17>
801052d3:	8b 45 fc             	mov    -0x4(%ebp),%eax
801052d6:	eb 32                	jmp    8010530a <safestrcpy+0x49>
801052d8:	90                   	nop
801052d9:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
801052dd:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
801052e1:	7e 1e                	jle    80105301 <safestrcpy+0x40>
801052e3:	8b 55 0c             	mov    0xc(%ebp),%edx
801052e6:	8d 42 01             	lea    0x1(%edx),%eax
801052e9:	89 45 0c             	mov    %eax,0xc(%ebp)
801052ec:	8b 45 08             	mov    0x8(%ebp),%eax
801052ef:	8d 48 01             	lea    0x1(%eax),%ecx
801052f2:	89 4d 08             	mov    %ecx,0x8(%ebp)
801052f5:	0f b6 12             	movzbl (%edx),%edx
801052f8:	88 10                	mov    %dl,(%eax)
801052fa:	0f b6 00             	movzbl (%eax),%eax
801052fd:	84 c0                	test   %al,%al
801052ff:	75 d8                	jne    801052d9 <safestrcpy+0x18>
80105301:	8b 45 08             	mov    0x8(%ebp),%eax
80105304:	c6 00 00             	movb   $0x0,(%eax)
80105307:	8b 45 fc             	mov    -0x4(%ebp),%eax
8010530a:	c9                   	leave  
8010530b:	c3                   	ret    

8010530c <strlen>:
8010530c:	55                   	push   %ebp
8010530d:	89 e5                	mov    %esp,%ebp
8010530f:	83 ec 10             	sub    $0x10,%esp
80105312:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
80105319:	eb 04                	jmp    8010531f <strlen+0x13>
8010531b:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
8010531f:	8b 55 fc             	mov    -0x4(%ebp),%edx
80105322:	8b 45 08             	mov    0x8(%ebp),%eax
80105325:	01 d0                	add    %edx,%eax
80105327:	0f b6 00             	movzbl (%eax),%eax
8010532a:	84 c0                	test   %al,%al
8010532c:	75 ed                	jne    8010531b <strlen+0xf>
8010532e:	8b 45 fc             	mov    -0x4(%ebp),%eax
80105331:	c9                   	leave  
80105332:	c3                   	ret    

80105333 <swtch>:
80105333:	8b 44 24 04          	mov    0x4(%esp),%eax
80105337:	8b 54 24 08          	mov    0x8(%esp),%edx
8010533b:	55                   	push   %ebp
8010533c:	53                   	push   %ebx
8010533d:	56                   	push   %esi
8010533e:	57                   	push   %edi
8010533f:	89 20                	mov    %esp,(%eax)
80105341:	89 d4                	mov    %edx,%esp
80105343:	5f                   	pop    %edi
80105344:	5e                   	pop    %esi
80105345:	5b                   	pop    %ebx
80105346:	5d                   	pop    %ebp
80105347:	c3                   	ret    

80105348 <fetchint>:
// to a saved program counter, and then the first argument.

// Fetch the int at addr from the current process.
int
fetchint(uint addr, int *ip)
{
80105348:	55                   	push   %ebp
80105349:	89 e5                	mov    %esp,%ebp
8010534b:	83 ec 18             	sub    $0x18,%esp
  struct proc *curproc = myproc();
8010534e:	e8 c1 eb ff ff       	call   80103f14 <myproc>
80105353:	89 45 f4             	mov    %eax,-0xc(%ebp)

  if(addr >= curproc->sz || addr+4 > curproc->sz)
80105356:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105359:	8b 00                	mov    (%eax),%eax
8010535b:	39 45 08             	cmp    %eax,0x8(%ebp)
8010535e:	73 0f                	jae    8010536f <fetchint+0x27>
80105360:	8b 45 08             	mov    0x8(%ebp),%eax
80105363:	8d 50 04             	lea    0x4(%eax),%edx
80105366:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105369:	8b 00                	mov    (%eax),%eax
8010536b:	39 c2                	cmp    %eax,%edx
8010536d:	76 07                	jbe    80105376 <fetchint+0x2e>
    return -1;
8010536f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105374:	eb 0f                	jmp    80105385 <fetchint+0x3d>
  *ip = *(int*)(addr);
80105376:	8b 45 08             	mov    0x8(%ebp),%eax
80105379:	8b 10                	mov    (%eax),%edx
8010537b:	8b 45 0c             	mov    0xc(%ebp),%eax
8010537e:	89 10                	mov    %edx,(%eax)
  return 0;
80105380:	b8 00 00 00 00       	mov    $0x0,%eax
}
80105385:	c9                   	leave  
80105386:	c3                   	ret    

80105387 <fetchstr>:
// Fetch the nul-terminated string at addr from the current process.
// Doesn't actually copy the string - just sets *pp to point at it.
// Returns length of string, not including nul.
int
fetchstr(uint addr, char **pp)
{
80105387:	55                   	push   %ebp
80105388:	89 e5                	mov    %esp,%ebp
8010538a:	83 ec 18             	sub    $0x18,%esp
  char *s, *ep;
  struct proc *curproc = myproc();
8010538d:	e8 82 eb ff ff       	call   80103f14 <myproc>
80105392:	89 45 f0             	mov    %eax,-0x10(%ebp)

  if(addr >= curproc->sz)
80105395:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105398:	8b 00                	mov    (%eax),%eax
8010539a:	39 45 08             	cmp    %eax,0x8(%ebp)
8010539d:	72 07                	jb     801053a6 <fetchstr+0x1f>
    return -1;
8010539f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801053a4:	eb 41                	jmp    801053e7 <fetchstr+0x60>
  *pp = (char*)addr;
801053a6:	8b 55 08             	mov    0x8(%ebp),%edx
801053a9:	8b 45 0c             	mov    0xc(%ebp),%eax
801053ac:	89 10                	mov    %edx,(%eax)
  ep = (char*)curproc->sz;
801053ae:	8b 45 f0             	mov    -0x10(%ebp),%eax
801053b1:	8b 00                	mov    (%eax),%eax
801053b3:	89 45 ec             	mov    %eax,-0x14(%ebp)
  for(s = *pp; s < ep; s++){
801053b6:	8b 45 0c             	mov    0xc(%ebp),%eax
801053b9:	8b 00                	mov    (%eax),%eax
801053bb:	89 45 f4             	mov    %eax,-0xc(%ebp)
801053be:	eb 1a                	jmp    801053da <fetchstr+0x53>
    if(*s == 0)
801053c0:	8b 45 f4             	mov    -0xc(%ebp),%eax
801053c3:	0f b6 00             	movzbl (%eax),%eax
801053c6:	84 c0                	test   %al,%al
801053c8:	75 0c                	jne    801053d6 <fetchstr+0x4f>
      return s - *pp;
801053ca:	8b 45 0c             	mov    0xc(%ebp),%eax
801053cd:	8b 10                	mov    (%eax),%edx
801053cf:	8b 45 f4             	mov    -0xc(%ebp),%eax
801053d2:	29 d0                	sub    %edx,%eax
801053d4:	eb 11                	jmp    801053e7 <fetchstr+0x60>
  for(s = *pp; s < ep; s++){
801053d6:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
801053da:	8b 45 f4             	mov    -0xc(%ebp),%eax
801053dd:	3b 45 ec             	cmp    -0x14(%ebp),%eax
801053e0:	72 de                	jb     801053c0 <fetchstr+0x39>
  }
  return -1;
801053e2:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801053e7:	c9                   	leave  
801053e8:	c3                   	ret    

801053e9 <argint>:

// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
801053e9:	55                   	push   %ebp
801053ea:	89 e5                	mov    %esp,%ebp
801053ec:	83 ec 08             	sub    $0x8,%esp
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
801053ef:	e8 20 eb ff ff       	call   80103f14 <myproc>
801053f4:	8b 40 18             	mov    0x18(%eax),%eax
801053f7:	8b 50 44             	mov    0x44(%eax),%edx
801053fa:	8b 45 08             	mov    0x8(%ebp),%eax
801053fd:	c1 e0 02             	shl    $0x2,%eax
80105400:	01 d0                	add    %edx,%eax
80105402:	83 c0 04             	add    $0x4,%eax
80105405:	83 ec 08             	sub    $0x8,%esp
80105408:	ff 75 0c             	push   0xc(%ebp)
8010540b:	50                   	push   %eax
8010540c:	e8 37 ff ff ff       	call   80105348 <fetchint>
80105411:	83 c4 10             	add    $0x10,%esp
}
80105414:	c9                   	leave  
80105415:	c3                   	ret    

80105416 <argptr>:
// Fetch the nth word-sized system call argument as a pointer
// to a block of memory of size bytes.  Check that the pointer
// lies within the process address space.
int
argptr(int n, char **pp, int size)
{
80105416:	55                   	push   %ebp
80105417:	89 e5                	mov    %esp,%ebp
80105419:	83 ec 18             	sub    $0x18,%esp
  int i;
  struct proc *curproc = myproc();
8010541c:	e8 f3 ea ff ff       	call   80103f14 <myproc>
80105421:	89 45 f4             	mov    %eax,-0xc(%ebp)
 
  if(argint(n, &i) < 0)
80105424:	83 ec 08             	sub    $0x8,%esp
80105427:	8d 45 f0             	lea    -0x10(%ebp),%eax
8010542a:	50                   	push   %eax
8010542b:	ff 75 08             	push   0x8(%ebp)
8010542e:	e8 b6 ff ff ff       	call   801053e9 <argint>
80105433:	83 c4 10             	add    $0x10,%esp
80105436:	85 c0                	test   %eax,%eax
80105438:	79 07                	jns    80105441 <argptr+0x2b>
    return -1;
8010543a:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010543f:	eb 3b                	jmp    8010547c <argptr+0x66>
  if(size < 0 || (uint)i >= curproc->sz || (uint)i+size > curproc->sz)
80105441:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
80105445:	78 1f                	js     80105466 <argptr+0x50>
80105447:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010544a:	8b 00                	mov    (%eax),%eax
8010544c:	8b 55 f0             	mov    -0x10(%ebp),%edx
8010544f:	39 d0                	cmp    %edx,%eax
80105451:	76 13                	jbe    80105466 <argptr+0x50>
80105453:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105456:	89 c2                	mov    %eax,%edx
80105458:	8b 45 10             	mov    0x10(%ebp),%eax
8010545b:	01 c2                	add    %eax,%edx
8010545d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105460:	8b 00                	mov    (%eax),%eax
80105462:	39 c2                	cmp    %eax,%edx
80105464:	76 07                	jbe    8010546d <argptr+0x57>
    return -1;
80105466:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010546b:	eb 0f                	jmp    8010547c <argptr+0x66>
  *pp = (char*)i;
8010546d:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105470:	89 c2                	mov    %eax,%edx
80105472:	8b 45 0c             	mov    0xc(%ebp),%eax
80105475:	89 10                	mov    %edx,(%eax)
  return 0;
80105477:	b8 00 00 00 00       	mov    $0x0,%eax
}
8010547c:	c9                   	leave  
8010547d:	c3                   	ret    

8010547e <argstr>:
// Check that the pointer is valid and the string is nul-terminated.
// (There is no shared writable memory, so the string can't change
// between this check and being used by the kernel.)
int
argstr(int n, char **pp)
{
8010547e:	55                   	push   %ebp
8010547f:	89 e5                	mov    %esp,%ebp
80105481:	83 ec 18             	sub    $0x18,%esp
  int addr;
  if(argint(n, &addr) < 0)
80105484:	83 ec 08             	sub    $0x8,%esp
80105487:	8d 45 f4             	lea    -0xc(%ebp),%eax
8010548a:	50                   	push   %eax
8010548b:	ff 75 08             	push   0x8(%ebp)
8010548e:	e8 56 ff ff ff       	call   801053e9 <argint>
80105493:	83 c4 10             	add    $0x10,%esp
80105496:	85 c0                	test   %eax,%eax
80105498:	79 07                	jns    801054a1 <argstr+0x23>
    return -1;
8010549a:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010549f:	eb 12                	jmp    801054b3 <argstr+0x35>
  return fetchstr(addr, pp);
801054a1:	8b 45 f4             	mov    -0xc(%ebp),%eax
801054a4:	83 ec 08             	sub    $0x8,%esp
801054a7:	ff 75 0c             	push   0xc(%ebp)
801054aa:	50                   	push   %eax
801054ab:	e8 d7 fe ff ff       	call   80105387 <fetchstr>
801054b0:	83 c4 10             	add    $0x10,%esp
}
801054b3:	c9                   	leave  
801054b4:	c3                   	ret    

801054b5 <syscall>:
[SYS_wait2]   sys_wait2,
};

void
syscall(void)
{
801054b5:	55                   	push   %ebp
801054b6:	89 e5                	mov    %esp,%ebp
801054b8:	83 ec 18             	sub    $0x18,%esp
  int num;
  struct proc *curproc = myproc();
801054bb:	e8 54 ea ff ff       	call   80103f14 <myproc>
801054c0:	89 45 f4             	mov    %eax,-0xc(%ebp)

  num = curproc->tf->eax;
801054c3:	8b 45 f4             	mov    -0xc(%ebp),%eax
801054c6:	8b 40 18             	mov    0x18(%eax),%eax
801054c9:	8b 40 1c             	mov    0x1c(%eax),%eax
801054cc:	89 45 f0             	mov    %eax,-0x10(%ebp)
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
801054cf:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
801054d3:	7e 2f                	jle    80105504 <syscall+0x4f>
801054d5:	8b 45 f0             	mov    -0x10(%ebp),%eax
801054d8:	83 f8 17             	cmp    $0x17,%eax
801054db:	77 27                	ja     80105504 <syscall+0x4f>
801054dd:	8b 45 f0             	mov    -0x10(%ebp),%eax
801054e0:	8b 04 85 20 f0 10 80 	mov    -0x7fef0fe0(,%eax,4),%eax
801054e7:	85 c0                	test   %eax,%eax
801054e9:	74 19                	je     80105504 <syscall+0x4f>
    curproc->tf->eax = syscalls[num]();
801054eb:	8b 45 f0             	mov    -0x10(%ebp),%eax
801054ee:	8b 04 85 20 f0 10 80 	mov    -0x7fef0fe0(,%eax,4),%eax
801054f5:	ff d0                	call   *%eax
801054f7:	89 c2                	mov    %eax,%edx
801054f9:	8b 45 f4             	mov    -0xc(%ebp),%eax
801054fc:	8b 40 18             	mov    0x18(%eax),%eax
801054ff:	89 50 1c             	mov    %edx,0x1c(%eax)
80105502:	eb 2c                	jmp    80105530 <syscall+0x7b>
  } else {
    cprintf("%d %s: unknown sys call %d\n",
            curproc->pid, curproc->name, num);
80105504:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105507:	8d 50 6c             	lea    0x6c(%eax),%edx
    cprintf("%d %s: unknown sys call %d\n",
8010550a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010550d:	8b 40 10             	mov    0x10(%eax),%eax
80105510:	ff 75 f0             	push   -0x10(%ebp)
80105513:	52                   	push   %edx
80105514:	50                   	push   %eax
80105515:	68 60 aa 10 80       	push   $0x8010aa60
8010551a:	e8 d5 ae ff ff       	call   801003f4 <cprintf>
8010551f:	83 c4 10             	add    $0x10,%esp
    curproc->tf->eax = -1;
80105522:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105525:	8b 40 18             	mov    0x18(%eax),%eax
80105528:	c7 40 1c ff ff ff ff 	movl   $0xffffffff,0x1c(%eax)
  }
}
8010552f:	90                   	nop
80105530:	90                   	nop
80105531:	c9                   	leave  
80105532:	c3                   	ret    

80105533 <argfd>:

// Fetch the nth word-sized system call argument as a file descriptor
// and return both the descriptor and the corresponding struct file.
static int
argfd(int n, int *pfd, struct file **pf)
{
80105533:	55                   	push   %ebp
80105534:	89 e5                	mov    %esp,%ebp
80105536:	83 ec 18             	sub    $0x18,%esp
  int fd;
  struct file *f;

  if(argint(n, &fd) < 0)
80105539:	83 ec 08             	sub    $0x8,%esp
8010553c:	8d 45 f0             	lea    -0x10(%ebp),%eax
8010553f:	50                   	push   %eax
80105540:	ff 75 08             	push   0x8(%ebp)
80105543:	e8 a1 fe ff ff       	call   801053e9 <argint>
80105548:	83 c4 10             	add    $0x10,%esp
8010554b:	85 c0                	test   %eax,%eax
8010554d:	79 07                	jns    80105556 <argfd+0x23>
    return -1;
8010554f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105554:	eb 4f                	jmp    801055a5 <argfd+0x72>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
80105556:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105559:	85 c0                	test   %eax,%eax
8010555b:	78 20                	js     8010557d <argfd+0x4a>
8010555d:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105560:	83 f8 0f             	cmp    $0xf,%eax
80105563:	7f 18                	jg     8010557d <argfd+0x4a>
80105565:	e8 aa e9 ff ff       	call   80103f14 <myproc>
8010556a:	8b 55 f0             	mov    -0x10(%ebp),%edx
8010556d:	83 c2 08             	add    $0x8,%edx
80105570:	8b 44 90 08          	mov    0x8(%eax,%edx,4),%eax
80105574:	89 45 f4             	mov    %eax,-0xc(%ebp)
80105577:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
8010557b:	75 07                	jne    80105584 <argfd+0x51>
    return -1;
8010557d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105582:	eb 21                	jmp    801055a5 <argfd+0x72>
  if(pfd)
80105584:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
80105588:	74 08                	je     80105592 <argfd+0x5f>
    *pfd = fd;
8010558a:	8b 55 f0             	mov    -0x10(%ebp),%edx
8010558d:	8b 45 0c             	mov    0xc(%ebp),%eax
80105590:	89 10                	mov    %edx,(%eax)
  if(pf)
80105592:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
80105596:	74 08                	je     801055a0 <argfd+0x6d>
    *pf = f;
80105598:	8b 45 10             	mov    0x10(%ebp),%eax
8010559b:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010559e:	89 10                	mov    %edx,(%eax)
  return 0;
801055a0:	b8 00 00 00 00       	mov    $0x0,%eax
}
801055a5:	c9                   	leave  
801055a6:	c3                   	ret    

801055a7 <fdalloc>:

// Allocate a file descriptor for the given file.
// Takes over file reference from caller on success.
static int
fdalloc(struct file *f)
{
801055a7:	55                   	push   %ebp
801055a8:	89 e5                	mov    %esp,%ebp
801055aa:	83 ec 18             	sub    $0x18,%esp
  int fd;
  struct proc *curproc = myproc();
801055ad:	e8 62 e9 ff ff       	call   80103f14 <myproc>
801055b2:	89 45 f0             	mov    %eax,-0x10(%ebp)

  for(fd = 0; fd < NOFILE; fd++){
801055b5:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
801055bc:	eb 2a                	jmp    801055e8 <fdalloc+0x41>
    if(curproc->ofile[fd] == 0){
801055be:	8b 45 f0             	mov    -0x10(%ebp),%eax
801055c1:	8b 55 f4             	mov    -0xc(%ebp),%edx
801055c4:	83 c2 08             	add    $0x8,%edx
801055c7:	8b 44 90 08          	mov    0x8(%eax,%edx,4),%eax
801055cb:	85 c0                	test   %eax,%eax
801055cd:	75 15                	jne    801055e4 <fdalloc+0x3d>
      curproc->ofile[fd] = f;
801055cf:	8b 45 f0             	mov    -0x10(%ebp),%eax
801055d2:	8b 55 f4             	mov    -0xc(%ebp),%edx
801055d5:	8d 4a 08             	lea    0x8(%edx),%ecx
801055d8:	8b 55 08             	mov    0x8(%ebp),%edx
801055db:	89 54 88 08          	mov    %edx,0x8(%eax,%ecx,4)
      return fd;
801055df:	8b 45 f4             	mov    -0xc(%ebp),%eax
801055e2:	eb 0f                	jmp    801055f3 <fdalloc+0x4c>
  for(fd = 0; fd < NOFILE; fd++){
801055e4:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
801055e8:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
801055ec:	7e d0                	jle    801055be <fdalloc+0x17>
    }
  }
  return -1;
801055ee:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801055f3:	c9                   	leave  
801055f4:	c3                   	ret    

801055f5 <sys_dup>:

int
sys_dup(void)
{
801055f5:	55                   	push   %ebp
801055f6:	89 e5                	mov    %esp,%ebp
801055f8:	83 ec 18             	sub    $0x18,%esp
  struct file *f;
  int fd;

  if(argfd(0, 0, &f) < 0)
801055fb:	83 ec 04             	sub    $0x4,%esp
801055fe:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105601:	50                   	push   %eax
80105602:	6a 00                	push   $0x0
80105604:	6a 00                	push   $0x0
80105606:	e8 28 ff ff ff       	call   80105533 <argfd>
8010560b:	83 c4 10             	add    $0x10,%esp
8010560e:	85 c0                	test   %eax,%eax
80105610:	79 07                	jns    80105619 <sys_dup+0x24>
    return -1;
80105612:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105617:	eb 31                	jmp    8010564a <sys_dup+0x55>
  if((fd=fdalloc(f)) < 0)
80105619:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010561c:	83 ec 0c             	sub    $0xc,%esp
8010561f:	50                   	push   %eax
80105620:	e8 82 ff ff ff       	call   801055a7 <fdalloc>
80105625:	83 c4 10             	add    $0x10,%esp
80105628:	89 45 f4             	mov    %eax,-0xc(%ebp)
8010562b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
8010562f:	79 07                	jns    80105638 <sys_dup+0x43>
    return -1;
80105631:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105636:	eb 12                	jmp    8010564a <sys_dup+0x55>
  filedup(f);
80105638:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010563b:	83 ec 0c             	sub    $0xc,%esp
8010563e:	50                   	push   %eax
8010563f:	e8 06 ba ff ff       	call   8010104a <filedup>
80105644:	83 c4 10             	add    $0x10,%esp
  return fd;
80105647:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
8010564a:	c9                   	leave  
8010564b:	c3                   	ret    

8010564c <sys_read>:

int
sys_read(void)
{
8010564c:	55                   	push   %ebp
8010564d:	89 e5                	mov    %esp,%ebp
8010564f:	83 ec 18             	sub    $0x18,%esp
  struct file *f;
  int n;
  char *p;

  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80105652:	83 ec 04             	sub    $0x4,%esp
80105655:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105658:	50                   	push   %eax
80105659:	6a 00                	push   $0x0
8010565b:	6a 00                	push   $0x0
8010565d:	e8 d1 fe ff ff       	call   80105533 <argfd>
80105662:	83 c4 10             	add    $0x10,%esp
80105665:	85 c0                	test   %eax,%eax
80105667:	78 2e                	js     80105697 <sys_read+0x4b>
80105669:	83 ec 08             	sub    $0x8,%esp
8010566c:	8d 45 f0             	lea    -0x10(%ebp),%eax
8010566f:	50                   	push   %eax
80105670:	6a 02                	push   $0x2
80105672:	e8 72 fd ff ff       	call   801053e9 <argint>
80105677:	83 c4 10             	add    $0x10,%esp
8010567a:	85 c0                	test   %eax,%eax
8010567c:	78 19                	js     80105697 <sys_read+0x4b>
8010567e:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105681:	83 ec 04             	sub    $0x4,%esp
80105684:	50                   	push   %eax
80105685:	8d 45 ec             	lea    -0x14(%ebp),%eax
80105688:	50                   	push   %eax
80105689:	6a 01                	push   $0x1
8010568b:	e8 86 fd ff ff       	call   80105416 <argptr>
80105690:	83 c4 10             	add    $0x10,%esp
80105693:	85 c0                	test   %eax,%eax
80105695:	79 07                	jns    8010569e <sys_read+0x52>
    return -1;
80105697:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010569c:	eb 17                	jmp    801056b5 <sys_read+0x69>
  return fileread(f, p, n);
8010569e:	8b 4d f0             	mov    -0x10(%ebp),%ecx
801056a1:	8b 55 ec             	mov    -0x14(%ebp),%edx
801056a4:	8b 45 f4             	mov    -0xc(%ebp),%eax
801056a7:	83 ec 04             	sub    $0x4,%esp
801056aa:	51                   	push   %ecx
801056ab:	52                   	push   %edx
801056ac:	50                   	push   %eax
801056ad:	e8 28 bb ff ff       	call   801011da <fileread>
801056b2:	83 c4 10             	add    $0x10,%esp
}
801056b5:	c9                   	leave  
801056b6:	c3                   	ret    

801056b7 <sys_write>:

int
sys_write(void)
{
801056b7:	55                   	push   %ebp
801056b8:	89 e5                	mov    %esp,%ebp
801056ba:	83 ec 18             	sub    $0x18,%esp
  struct file *f;
  int n;
  char *p;

  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
801056bd:	83 ec 04             	sub    $0x4,%esp
801056c0:	8d 45 f4             	lea    -0xc(%ebp),%eax
801056c3:	50                   	push   %eax
801056c4:	6a 00                	push   $0x0
801056c6:	6a 00                	push   $0x0
801056c8:	e8 66 fe ff ff       	call   80105533 <argfd>
801056cd:	83 c4 10             	add    $0x10,%esp
801056d0:	85 c0                	test   %eax,%eax
801056d2:	78 2e                	js     80105702 <sys_write+0x4b>
801056d4:	83 ec 08             	sub    $0x8,%esp
801056d7:	8d 45 f0             	lea    -0x10(%ebp),%eax
801056da:	50                   	push   %eax
801056db:	6a 02                	push   $0x2
801056dd:	e8 07 fd ff ff       	call   801053e9 <argint>
801056e2:	83 c4 10             	add    $0x10,%esp
801056e5:	85 c0                	test   %eax,%eax
801056e7:	78 19                	js     80105702 <sys_write+0x4b>
801056e9:	8b 45 f0             	mov    -0x10(%ebp),%eax
801056ec:	83 ec 04             	sub    $0x4,%esp
801056ef:	50                   	push   %eax
801056f0:	8d 45 ec             	lea    -0x14(%ebp),%eax
801056f3:	50                   	push   %eax
801056f4:	6a 01                	push   $0x1
801056f6:	e8 1b fd ff ff       	call   80105416 <argptr>
801056fb:	83 c4 10             	add    $0x10,%esp
801056fe:	85 c0                	test   %eax,%eax
80105700:	79 07                	jns    80105709 <sys_write+0x52>
    return -1;
80105702:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105707:	eb 17                	jmp    80105720 <sys_write+0x69>
  return filewrite(f, p, n);
80105709:	8b 4d f0             	mov    -0x10(%ebp),%ecx
8010570c:	8b 55 ec             	mov    -0x14(%ebp),%edx
8010570f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105712:	83 ec 04             	sub    $0x4,%esp
80105715:	51                   	push   %ecx
80105716:	52                   	push   %edx
80105717:	50                   	push   %eax
80105718:	e8 75 bb ff ff       	call   80101292 <filewrite>
8010571d:	83 c4 10             	add    $0x10,%esp
}
80105720:	c9                   	leave  
80105721:	c3                   	ret    

80105722 <sys_close>:

int
sys_close(void)
{
80105722:	55                   	push   %ebp
80105723:	89 e5                	mov    %esp,%ebp
80105725:	83 ec 18             	sub    $0x18,%esp
  int fd;
  struct file *f;

  if(argfd(0, &fd, &f) < 0)
80105728:	83 ec 04             	sub    $0x4,%esp
8010572b:	8d 45 f0             	lea    -0x10(%ebp),%eax
8010572e:	50                   	push   %eax
8010572f:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105732:	50                   	push   %eax
80105733:	6a 00                	push   $0x0
80105735:	e8 f9 fd ff ff       	call   80105533 <argfd>
8010573a:	83 c4 10             	add    $0x10,%esp
8010573d:	85 c0                	test   %eax,%eax
8010573f:	79 07                	jns    80105748 <sys_close+0x26>
    return -1;
80105741:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105746:	eb 27                	jmp    8010576f <sys_close+0x4d>
  myproc()->ofile[fd] = 0;
80105748:	e8 c7 e7 ff ff       	call   80103f14 <myproc>
8010574d:	8b 55 f4             	mov    -0xc(%ebp),%edx
80105750:	83 c2 08             	add    $0x8,%edx
80105753:	c7 44 90 08 00 00 00 	movl   $0x0,0x8(%eax,%edx,4)
8010575a:	00 
  fileclose(f);
8010575b:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010575e:	83 ec 0c             	sub    $0xc,%esp
80105761:	50                   	push   %eax
80105762:	e8 34 b9 ff ff       	call   8010109b <fileclose>
80105767:	83 c4 10             	add    $0x10,%esp
  return 0;
8010576a:	b8 00 00 00 00       	mov    $0x0,%eax
}
8010576f:	c9                   	leave  
80105770:	c3                   	ret    

80105771 <sys_fstat>:

int
sys_fstat(void)
{
80105771:	55                   	push   %ebp
80105772:	89 e5                	mov    %esp,%ebp
80105774:	83 ec 18             	sub    $0x18,%esp
  struct file *f;
  struct stat *st;

  if(argfd(0, 0, &f) < 0 || argptr(1, (void*)&st, sizeof(*st)) < 0)
80105777:	83 ec 04             	sub    $0x4,%esp
8010577a:	8d 45 f4             	lea    -0xc(%ebp),%eax
8010577d:	50                   	push   %eax
8010577e:	6a 00                	push   $0x0
80105780:	6a 00                	push   $0x0
80105782:	e8 ac fd ff ff       	call   80105533 <argfd>
80105787:	83 c4 10             	add    $0x10,%esp
8010578a:	85 c0                	test   %eax,%eax
8010578c:	78 17                	js     801057a5 <sys_fstat+0x34>
8010578e:	83 ec 04             	sub    $0x4,%esp
80105791:	6a 14                	push   $0x14
80105793:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105796:	50                   	push   %eax
80105797:	6a 01                	push   $0x1
80105799:	e8 78 fc ff ff       	call   80105416 <argptr>
8010579e:	83 c4 10             	add    $0x10,%esp
801057a1:	85 c0                	test   %eax,%eax
801057a3:	79 07                	jns    801057ac <sys_fstat+0x3b>
    return -1;
801057a5:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801057aa:	eb 13                	jmp    801057bf <sys_fstat+0x4e>
  return filestat(f, st);
801057ac:	8b 55 f0             	mov    -0x10(%ebp),%edx
801057af:	8b 45 f4             	mov    -0xc(%ebp),%eax
801057b2:	83 ec 08             	sub    $0x8,%esp
801057b5:	52                   	push   %edx
801057b6:	50                   	push   %eax
801057b7:	e8 c7 b9 ff ff       	call   80101183 <filestat>
801057bc:	83 c4 10             	add    $0x10,%esp
}
801057bf:	c9                   	leave  
801057c0:	c3                   	ret    

801057c1 <sys_link>:

// Create the path new as a link to the same inode as old.
int
sys_link(void)
{
801057c1:	55                   	push   %ebp
801057c2:	89 e5                	mov    %esp,%ebp
801057c4:	83 ec 28             	sub    $0x28,%esp
  char name[DIRSIZ], *new, *old;
  struct inode *dp, *ip;

  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
801057c7:	83 ec 08             	sub    $0x8,%esp
801057ca:	8d 45 d8             	lea    -0x28(%ebp),%eax
801057cd:	50                   	push   %eax
801057ce:	6a 00                	push   $0x0
801057d0:	e8 a9 fc ff ff       	call   8010547e <argstr>
801057d5:	83 c4 10             	add    $0x10,%esp
801057d8:	85 c0                	test   %eax,%eax
801057da:	78 15                	js     801057f1 <sys_link+0x30>
801057dc:	83 ec 08             	sub    $0x8,%esp
801057df:	8d 45 dc             	lea    -0x24(%ebp),%eax
801057e2:	50                   	push   %eax
801057e3:	6a 01                	push   $0x1
801057e5:	e8 94 fc ff ff       	call   8010547e <argstr>
801057ea:	83 c4 10             	add    $0x10,%esp
801057ed:	85 c0                	test   %eax,%eax
801057ef:	79 0a                	jns    801057fb <sys_link+0x3a>
    return -1;
801057f1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801057f6:	e9 68 01 00 00       	jmp    80105963 <sys_link+0x1a2>

  begin_op();
801057fb:	e8 20 dd ff ff       	call   80103520 <begin_op>
  if((ip = namei(old)) == 0){
80105800:	8b 45 d8             	mov    -0x28(%ebp),%eax
80105803:	83 ec 0c             	sub    $0xc,%esp
80105806:	50                   	push   %eax
80105807:	e8 11 cd ff ff       	call   8010251d <namei>
8010580c:	83 c4 10             	add    $0x10,%esp
8010580f:	89 45 f4             	mov    %eax,-0xc(%ebp)
80105812:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80105816:	75 0f                	jne    80105827 <sys_link+0x66>
    end_op();
80105818:	e8 8f dd ff ff       	call   801035ac <end_op>
    return -1;
8010581d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105822:	e9 3c 01 00 00       	jmp    80105963 <sys_link+0x1a2>
  }

  ilock(ip);
80105827:	83 ec 0c             	sub    $0xc,%esp
8010582a:	ff 75 f4             	push   -0xc(%ebp)
8010582d:	e8 b8 c1 ff ff       	call   801019ea <ilock>
80105832:	83 c4 10             	add    $0x10,%esp
  if(ip->type == T_DIR){
80105835:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105838:	0f b7 40 50          	movzwl 0x50(%eax),%eax
8010583c:	66 83 f8 01          	cmp    $0x1,%ax
80105840:	75 1d                	jne    8010585f <sys_link+0x9e>
    iunlockput(ip);
80105842:	83 ec 0c             	sub    $0xc,%esp
80105845:	ff 75 f4             	push   -0xc(%ebp)
80105848:	e8 ce c3 ff ff       	call   80101c1b <iunlockput>
8010584d:	83 c4 10             	add    $0x10,%esp
    end_op();
80105850:	e8 57 dd ff ff       	call   801035ac <end_op>
    return -1;
80105855:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010585a:	e9 04 01 00 00       	jmp    80105963 <sys_link+0x1a2>
  }

  ip->nlink++;
8010585f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105862:	0f b7 40 56          	movzwl 0x56(%eax),%eax
80105866:	83 c0 01             	add    $0x1,%eax
80105869:	89 c2                	mov    %eax,%edx
8010586b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010586e:	66 89 50 56          	mov    %dx,0x56(%eax)
  iupdate(ip);
80105872:	83 ec 0c             	sub    $0xc,%esp
80105875:	ff 75 f4             	push   -0xc(%ebp)
80105878:	e8 90 bf ff ff       	call   8010180d <iupdate>
8010587d:	83 c4 10             	add    $0x10,%esp
  iunlock(ip);
80105880:	83 ec 0c             	sub    $0xc,%esp
80105883:	ff 75 f4             	push   -0xc(%ebp)
80105886:	e8 72 c2 ff ff       	call   80101afd <iunlock>
8010588b:	83 c4 10             	add    $0x10,%esp

  if((dp = nameiparent(new, name)) == 0)
8010588e:	8b 45 dc             	mov    -0x24(%ebp),%eax
80105891:	83 ec 08             	sub    $0x8,%esp
80105894:	8d 55 e2             	lea    -0x1e(%ebp),%edx
80105897:	52                   	push   %edx
80105898:	50                   	push   %eax
80105899:	e8 9b cc ff ff       	call   80102539 <nameiparent>
8010589e:	83 c4 10             	add    $0x10,%esp
801058a1:	89 45 f0             	mov    %eax,-0x10(%ebp)
801058a4:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
801058a8:	74 71                	je     8010591b <sys_link+0x15a>
    goto bad;
  ilock(dp);
801058aa:	83 ec 0c             	sub    $0xc,%esp
801058ad:	ff 75 f0             	push   -0x10(%ebp)
801058b0:	e8 35 c1 ff ff       	call   801019ea <ilock>
801058b5:	83 c4 10             	add    $0x10,%esp
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
801058b8:	8b 45 f0             	mov    -0x10(%ebp),%eax
801058bb:	8b 10                	mov    (%eax),%edx
801058bd:	8b 45 f4             	mov    -0xc(%ebp),%eax
801058c0:	8b 00                	mov    (%eax),%eax
801058c2:	39 c2                	cmp    %eax,%edx
801058c4:	75 1d                	jne    801058e3 <sys_link+0x122>
801058c6:	8b 45 f4             	mov    -0xc(%ebp),%eax
801058c9:	8b 40 04             	mov    0x4(%eax),%eax
801058cc:	83 ec 04             	sub    $0x4,%esp
801058cf:	50                   	push   %eax
801058d0:	8d 45 e2             	lea    -0x1e(%ebp),%eax
801058d3:	50                   	push   %eax
801058d4:	ff 75 f0             	push   -0x10(%ebp)
801058d7:	e8 aa c9 ff ff       	call   80102286 <dirlink>
801058dc:	83 c4 10             	add    $0x10,%esp
801058df:	85 c0                	test   %eax,%eax
801058e1:	79 10                	jns    801058f3 <sys_link+0x132>
    iunlockput(dp);
801058e3:	83 ec 0c             	sub    $0xc,%esp
801058e6:	ff 75 f0             	push   -0x10(%ebp)
801058e9:	e8 2d c3 ff ff       	call   80101c1b <iunlockput>
801058ee:	83 c4 10             	add    $0x10,%esp
    goto bad;
801058f1:	eb 29                	jmp    8010591c <sys_link+0x15b>
  }
  iunlockput(dp);
801058f3:	83 ec 0c             	sub    $0xc,%esp
801058f6:	ff 75 f0             	push   -0x10(%ebp)
801058f9:	e8 1d c3 ff ff       	call   80101c1b <iunlockput>
801058fe:	83 c4 10             	add    $0x10,%esp
  iput(ip);
80105901:	83 ec 0c             	sub    $0xc,%esp
80105904:	ff 75 f4             	push   -0xc(%ebp)
80105907:	e8 3f c2 ff ff       	call   80101b4b <iput>
8010590c:	83 c4 10             	add    $0x10,%esp

  end_op();
8010590f:	e8 98 dc ff ff       	call   801035ac <end_op>

  return 0;
80105914:	b8 00 00 00 00       	mov    $0x0,%eax
80105919:	eb 48                	jmp    80105963 <sys_link+0x1a2>
    goto bad;
8010591b:	90                   	nop

bad:
  ilock(ip);
8010591c:	83 ec 0c             	sub    $0xc,%esp
8010591f:	ff 75 f4             	push   -0xc(%ebp)
80105922:	e8 c3 c0 ff ff       	call   801019ea <ilock>
80105927:	83 c4 10             	add    $0x10,%esp
  ip->nlink--;
8010592a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010592d:	0f b7 40 56          	movzwl 0x56(%eax),%eax
80105931:	83 e8 01             	sub    $0x1,%eax
80105934:	89 c2                	mov    %eax,%edx
80105936:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105939:	66 89 50 56          	mov    %dx,0x56(%eax)
  iupdate(ip);
8010593d:	83 ec 0c             	sub    $0xc,%esp
80105940:	ff 75 f4             	push   -0xc(%ebp)
80105943:	e8 c5 be ff ff       	call   8010180d <iupdate>
80105948:	83 c4 10             	add    $0x10,%esp
  iunlockput(ip);
8010594b:	83 ec 0c             	sub    $0xc,%esp
8010594e:	ff 75 f4             	push   -0xc(%ebp)
80105951:	e8 c5 c2 ff ff       	call   80101c1b <iunlockput>
80105956:	83 c4 10             	add    $0x10,%esp
  end_op();
80105959:	e8 4e dc ff ff       	call   801035ac <end_op>
  return -1;
8010595e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105963:	c9                   	leave  
80105964:	c3                   	ret    

80105965 <isdirempty>:

// Is the directory dp empty except for "." and ".." ?
static int
isdirempty(struct inode *dp)
{
80105965:	55                   	push   %ebp
80105966:	89 e5                	mov    %esp,%ebp
80105968:	83 ec 28             	sub    $0x28,%esp
  int off;
  struct dirent de;

  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
8010596b:	c7 45 f4 20 00 00 00 	movl   $0x20,-0xc(%ebp)
80105972:	eb 40                	jmp    801059b4 <isdirempty+0x4f>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80105974:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105977:	6a 10                	push   $0x10
80105979:	50                   	push   %eax
8010597a:	8d 45 e4             	lea    -0x1c(%ebp),%eax
8010597d:	50                   	push   %eax
8010597e:	ff 75 08             	push   0x8(%ebp)
80105981:	e8 50 c5 ff ff       	call   80101ed6 <readi>
80105986:	83 c4 10             	add    $0x10,%esp
80105989:	83 f8 10             	cmp    $0x10,%eax
8010598c:	74 0d                	je     8010599b <isdirempty+0x36>
      panic("isdirempty: readi");
8010598e:	83 ec 0c             	sub    $0xc,%esp
80105991:	68 7c aa 10 80       	push   $0x8010aa7c
80105996:	e8 0e ac ff ff       	call   801005a9 <panic>
    if(de.inum != 0)
8010599b:	0f b7 45 e4          	movzwl -0x1c(%ebp),%eax
8010599f:	66 85 c0             	test   %ax,%ax
801059a2:	74 07                	je     801059ab <isdirempty+0x46>
      return 0;
801059a4:	b8 00 00 00 00       	mov    $0x0,%eax
801059a9:	eb 1b                	jmp    801059c6 <isdirempty+0x61>
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
801059ab:	8b 45 f4             	mov    -0xc(%ebp),%eax
801059ae:	83 c0 10             	add    $0x10,%eax
801059b1:	89 45 f4             	mov    %eax,-0xc(%ebp)
801059b4:	8b 45 08             	mov    0x8(%ebp),%eax
801059b7:	8b 50 58             	mov    0x58(%eax),%edx
801059ba:	8b 45 f4             	mov    -0xc(%ebp),%eax
801059bd:	39 c2                	cmp    %eax,%edx
801059bf:	77 b3                	ja     80105974 <isdirempty+0xf>
  }
  return 1;
801059c1:	b8 01 00 00 00       	mov    $0x1,%eax
}
801059c6:	c9                   	leave  
801059c7:	c3                   	ret    

801059c8 <sys_unlink>:

//PAGEBREAK!
int
sys_unlink(void)
{
801059c8:	55                   	push   %ebp
801059c9:	89 e5                	mov    %esp,%ebp
801059cb:	83 ec 38             	sub    $0x38,%esp
  struct inode *ip, *dp;
  struct dirent de;
  char name[DIRSIZ], *path;
  uint off;

  if(argstr(0, &path) < 0)
801059ce:	83 ec 08             	sub    $0x8,%esp
801059d1:	8d 45 cc             	lea    -0x34(%ebp),%eax
801059d4:	50                   	push   %eax
801059d5:	6a 00                	push   $0x0
801059d7:	e8 a2 fa ff ff       	call   8010547e <argstr>
801059dc:	83 c4 10             	add    $0x10,%esp
801059df:	85 c0                	test   %eax,%eax
801059e1:	79 0a                	jns    801059ed <sys_unlink+0x25>
    return -1;
801059e3:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801059e8:	e9 bf 01 00 00       	jmp    80105bac <sys_unlink+0x1e4>

  begin_op();
801059ed:	e8 2e db ff ff       	call   80103520 <begin_op>
  if((dp = nameiparent(path, name)) == 0){
801059f2:	8b 45 cc             	mov    -0x34(%ebp),%eax
801059f5:	83 ec 08             	sub    $0x8,%esp
801059f8:	8d 55 d2             	lea    -0x2e(%ebp),%edx
801059fb:	52                   	push   %edx
801059fc:	50                   	push   %eax
801059fd:	e8 37 cb ff ff       	call   80102539 <nameiparent>
80105a02:	83 c4 10             	add    $0x10,%esp
80105a05:	89 45 f4             	mov    %eax,-0xc(%ebp)
80105a08:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80105a0c:	75 0f                	jne    80105a1d <sys_unlink+0x55>
    end_op();
80105a0e:	e8 99 db ff ff       	call   801035ac <end_op>
    return -1;
80105a13:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105a18:	e9 8f 01 00 00       	jmp    80105bac <sys_unlink+0x1e4>
  }

  ilock(dp);
80105a1d:	83 ec 0c             	sub    $0xc,%esp
80105a20:	ff 75 f4             	push   -0xc(%ebp)
80105a23:	e8 c2 bf ff ff       	call   801019ea <ilock>
80105a28:	83 c4 10             	add    $0x10,%esp

  // Cannot unlink "." or "..".
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
80105a2b:	83 ec 08             	sub    $0x8,%esp
80105a2e:	68 8e aa 10 80       	push   $0x8010aa8e
80105a33:	8d 45 d2             	lea    -0x2e(%ebp),%eax
80105a36:	50                   	push   %eax
80105a37:	e8 75 c7 ff ff       	call   801021b1 <namecmp>
80105a3c:	83 c4 10             	add    $0x10,%esp
80105a3f:	85 c0                	test   %eax,%eax
80105a41:	0f 84 49 01 00 00    	je     80105b90 <sys_unlink+0x1c8>
80105a47:	83 ec 08             	sub    $0x8,%esp
80105a4a:	68 90 aa 10 80       	push   $0x8010aa90
80105a4f:	8d 45 d2             	lea    -0x2e(%ebp),%eax
80105a52:	50                   	push   %eax
80105a53:	e8 59 c7 ff ff       	call   801021b1 <namecmp>
80105a58:	83 c4 10             	add    $0x10,%esp
80105a5b:	85 c0                	test   %eax,%eax
80105a5d:	0f 84 2d 01 00 00    	je     80105b90 <sys_unlink+0x1c8>
    goto bad;

  if((ip = dirlookup(dp, name, &off)) == 0)
80105a63:	83 ec 04             	sub    $0x4,%esp
80105a66:	8d 45 c8             	lea    -0x38(%ebp),%eax
80105a69:	50                   	push   %eax
80105a6a:	8d 45 d2             	lea    -0x2e(%ebp),%eax
80105a6d:	50                   	push   %eax
80105a6e:	ff 75 f4             	push   -0xc(%ebp)
80105a71:	e8 56 c7 ff ff       	call   801021cc <dirlookup>
80105a76:	83 c4 10             	add    $0x10,%esp
80105a79:	89 45 f0             	mov    %eax,-0x10(%ebp)
80105a7c:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80105a80:	0f 84 0d 01 00 00    	je     80105b93 <sys_unlink+0x1cb>
    goto bad;
  ilock(ip);
80105a86:	83 ec 0c             	sub    $0xc,%esp
80105a89:	ff 75 f0             	push   -0x10(%ebp)
80105a8c:	e8 59 bf ff ff       	call   801019ea <ilock>
80105a91:	83 c4 10             	add    $0x10,%esp

  if(ip->nlink < 1)
80105a94:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105a97:	0f b7 40 56          	movzwl 0x56(%eax),%eax
80105a9b:	66 85 c0             	test   %ax,%ax
80105a9e:	7f 0d                	jg     80105aad <sys_unlink+0xe5>
    panic("unlink: nlink < 1");
80105aa0:	83 ec 0c             	sub    $0xc,%esp
80105aa3:	68 93 aa 10 80       	push   $0x8010aa93
80105aa8:	e8 fc aa ff ff       	call   801005a9 <panic>
  if(ip->type == T_DIR && !isdirempty(ip)){
80105aad:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105ab0:	0f b7 40 50          	movzwl 0x50(%eax),%eax
80105ab4:	66 83 f8 01          	cmp    $0x1,%ax
80105ab8:	75 25                	jne    80105adf <sys_unlink+0x117>
80105aba:	83 ec 0c             	sub    $0xc,%esp
80105abd:	ff 75 f0             	push   -0x10(%ebp)
80105ac0:	e8 a0 fe ff ff       	call   80105965 <isdirempty>
80105ac5:	83 c4 10             	add    $0x10,%esp
80105ac8:	85 c0                	test   %eax,%eax
80105aca:	75 13                	jne    80105adf <sys_unlink+0x117>
    iunlockput(ip);
80105acc:	83 ec 0c             	sub    $0xc,%esp
80105acf:	ff 75 f0             	push   -0x10(%ebp)
80105ad2:	e8 44 c1 ff ff       	call   80101c1b <iunlockput>
80105ad7:	83 c4 10             	add    $0x10,%esp
    goto bad;
80105ada:	e9 b5 00 00 00       	jmp    80105b94 <sys_unlink+0x1cc>
  }

  memset(&de, 0, sizeof(de));
80105adf:	83 ec 04             	sub    $0x4,%esp
80105ae2:	6a 10                	push   $0x10
80105ae4:	6a 00                	push   $0x0
80105ae6:	8d 45 e0             	lea    -0x20(%ebp),%eax
80105ae9:	50                   	push   %eax
80105aea:	e8 cf f5 ff ff       	call   801050be <memset>
80105aef:	83 c4 10             	add    $0x10,%esp
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80105af2:	8b 45 c8             	mov    -0x38(%ebp),%eax
80105af5:	6a 10                	push   $0x10
80105af7:	50                   	push   %eax
80105af8:	8d 45 e0             	lea    -0x20(%ebp),%eax
80105afb:	50                   	push   %eax
80105afc:	ff 75 f4             	push   -0xc(%ebp)
80105aff:	e8 27 c5 ff ff       	call   8010202b <writei>
80105b04:	83 c4 10             	add    $0x10,%esp
80105b07:	83 f8 10             	cmp    $0x10,%eax
80105b0a:	74 0d                	je     80105b19 <sys_unlink+0x151>
    panic("unlink: writei");
80105b0c:	83 ec 0c             	sub    $0xc,%esp
80105b0f:	68 a5 aa 10 80       	push   $0x8010aaa5
80105b14:	e8 90 aa ff ff       	call   801005a9 <panic>
  if(ip->type == T_DIR){
80105b19:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105b1c:	0f b7 40 50          	movzwl 0x50(%eax),%eax
80105b20:	66 83 f8 01          	cmp    $0x1,%ax
80105b24:	75 21                	jne    80105b47 <sys_unlink+0x17f>
    dp->nlink--;
80105b26:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105b29:	0f b7 40 56          	movzwl 0x56(%eax),%eax
80105b2d:	83 e8 01             	sub    $0x1,%eax
80105b30:	89 c2                	mov    %eax,%edx
80105b32:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105b35:	66 89 50 56          	mov    %dx,0x56(%eax)
    iupdate(dp);
80105b39:	83 ec 0c             	sub    $0xc,%esp
80105b3c:	ff 75 f4             	push   -0xc(%ebp)
80105b3f:	e8 c9 bc ff ff       	call   8010180d <iupdate>
80105b44:	83 c4 10             	add    $0x10,%esp
  }
  iunlockput(dp);
80105b47:	83 ec 0c             	sub    $0xc,%esp
80105b4a:	ff 75 f4             	push   -0xc(%ebp)
80105b4d:	e8 c9 c0 ff ff       	call   80101c1b <iunlockput>
80105b52:	83 c4 10             	add    $0x10,%esp

  ip->nlink--;
80105b55:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105b58:	0f b7 40 56          	movzwl 0x56(%eax),%eax
80105b5c:	83 e8 01             	sub    $0x1,%eax
80105b5f:	89 c2                	mov    %eax,%edx
80105b61:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105b64:	66 89 50 56          	mov    %dx,0x56(%eax)
  iupdate(ip);
80105b68:	83 ec 0c             	sub    $0xc,%esp
80105b6b:	ff 75 f0             	push   -0x10(%ebp)
80105b6e:	e8 9a bc ff ff       	call   8010180d <iupdate>
80105b73:	83 c4 10             	add    $0x10,%esp
  iunlockput(ip);
80105b76:	83 ec 0c             	sub    $0xc,%esp
80105b79:	ff 75 f0             	push   -0x10(%ebp)
80105b7c:	e8 9a c0 ff ff       	call   80101c1b <iunlockput>
80105b81:	83 c4 10             	add    $0x10,%esp

  end_op();
80105b84:	e8 23 da ff ff       	call   801035ac <end_op>

  return 0;
80105b89:	b8 00 00 00 00       	mov    $0x0,%eax
80105b8e:	eb 1c                	jmp    80105bac <sys_unlink+0x1e4>
    goto bad;
80105b90:	90                   	nop
80105b91:	eb 01                	jmp    80105b94 <sys_unlink+0x1cc>
    goto bad;
80105b93:	90                   	nop

bad:
  iunlockput(dp);
80105b94:	83 ec 0c             	sub    $0xc,%esp
80105b97:	ff 75 f4             	push   -0xc(%ebp)
80105b9a:	e8 7c c0 ff ff       	call   80101c1b <iunlockput>
80105b9f:	83 c4 10             	add    $0x10,%esp
  end_op();
80105ba2:	e8 05 da ff ff       	call   801035ac <end_op>
  return -1;
80105ba7:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105bac:	c9                   	leave  
80105bad:	c3                   	ret    

80105bae <create>:

static struct inode*
create(char *path, short type, short major, short minor)
{
80105bae:	55                   	push   %ebp
80105baf:	89 e5                	mov    %esp,%ebp
80105bb1:	83 ec 38             	sub    $0x38,%esp
80105bb4:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80105bb7:	8b 55 10             	mov    0x10(%ebp),%edx
80105bba:	8b 45 14             	mov    0x14(%ebp),%eax
80105bbd:	66 89 4d d4          	mov    %cx,-0x2c(%ebp)
80105bc1:	66 89 55 d0          	mov    %dx,-0x30(%ebp)
80105bc5:	66 89 45 cc          	mov    %ax,-0x34(%ebp)
  uint off;
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
80105bc9:	83 ec 08             	sub    $0x8,%esp
80105bcc:	8d 45 de             	lea    -0x22(%ebp),%eax
80105bcf:	50                   	push   %eax
80105bd0:	ff 75 08             	push   0x8(%ebp)
80105bd3:	e8 61 c9 ff ff       	call   80102539 <nameiparent>
80105bd8:	83 c4 10             	add    $0x10,%esp
80105bdb:	89 45 f4             	mov    %eax,-0xc(%ebp)
80105bde:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80105be2:	75 0a                	jne    80105bee <create+0x40>
    return 0;
80105be4:	b8 00 00 00 00       	mov    $0x0,%eax
80105be9:	e9 90 01 00 00       	jmp    80105d7e <create+0x1d0>
  ilock(dp);
80105bee:	83 ec 0c             	sub    $0xc,%esp
80105bf1:	ff 75 f4             	push   -0xc(%ebp)
80105bf4:	e8 f1 bd ff ff       	call   801019ea <ilock>
80105bf9:	83 c4 10             	add    $0x10,%esp

  if((ip = dirlookup(dp, name, &off)) != 0){
80105bfc:	83 ec 04             	sub    $0x4,%esp
80105bff:	8d 45 ec             	lea    -0x14(%ebp),%eax
80105c02:	50                   	push   %eax
80105c03:	8d 45 de             	lea    -0x22(%ebp),%eax
80105c06:	50                   	push   %eax
80105c07:	ff 75 f4             	push   -0xc(%ebp)
80105c0a:	e8 bd c5 ff ff       	call   801021cc <dirlookup>
80105c0f:	83 c4 10             	add    $0x10,%esp
80105c12:	89 45 f0             	mov    %eax,-0x10(%ebp)
80105c15:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80105c19:	74 50                	je     80105c6b <create+0xbd>
    iunlockput(dp);
80105c1b:	83 ec 0c             	sub    $0xc,%esp
80105c1e:	ff 75 f4             	push   -0xc(%ebp)
80105c21:	e8 f5 bf ff ff       	call   80101c1b <iunlockput>
80105c26:	83 c4 10             	add    $0x10,%esp
    ilock(ip);
80105c29:	83 ec 0c             	sub    $0xc,%esp
80105c2c:	ff 75 f0             	push   -0x10(%ebp)
80105c2f:	e8 b6 bd ff ff       	call   801019ea <ilock>
80105c34:	83 c4 10             	add    $0x10,%esp
    if(type == T_FILE && ip->type == T_FILE)
80105c37:	66 83 7d d4 02       	cmpw   $0x2,-0x2c(%ebp)
80105c3c:	75 15                	jne    80105c53 <create+0xa5>
80105c3e:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105c41:	0f b7 40 50          	movzwl 0x50(%eax),%eax
80105c45:	66 83 f8 02          	cmp    $0x2,%ax
80105c49:	75 08                	jne    80105c53 <create+0xa5>
      return ip;
80105c4b:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105c4e:	e9 2b 01 00 00       	jmp    80105d7e <create+0x1d0>
    iunlockput(ip);
80105c53:	83 ec 0c             	sub    $0xc,%esp
80105c56:	ff 75 f0             	push   -0x10(%ebp)
80105c59:	e8 bd bf ff ff       	call   80101c1b <iunlockput>
80105c5e:	83 c4 10             	add    $0x10,%esp
    return 0;
80105c61:	b8 00 00 00 00       	mov    $0x0,%eax
80105c66:	e9 13 01 00 00       	jmp    80105d7e <create+0x1d0>
  }

  if((ip = ialloc(dp->dev, type)) == 0)
80105c6b:	0f bf 55 d4          	movswl -0x2c(%ebp),%edx
80105c6f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105c72:	8b 00                	mov    (%eax),%eax
80105c74:	83 ec 08             	sub    $0x8,%esp
80105c77:	52                   	push   %edx
80105c78:	50                   	push   %eax
80105c79:	e8 b8 ba ff ff       	call   80101736 <ialloc>
80105c7e:	83 c4 10             	add    $0x10,%esp
80105c81:	89 45 f0             	mov    %eax,-0x10(%ebp)
80105c84:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80105c88:	75 0d                	jne    80105c97 <create+0xe9>
    panic("create: ialloc");
80105c8a:	83 ec 0c             	sub    $0xc,%esp
80105c8d:	68 b4 aa 10 80       	push   $0x8010aab4
80105c92:	e8 12 a9 ff ff       	call   801005a9 <panic>

  ilock(ip);
80105c97:	83 ec 0c             	sub    $0xc,%esp
80105c9a:	ff 75 f0             	push   -0x10(%ebp)
80105c9d:	e8 48 bd ff ff       	call   801019ea <ilock>
80105ca2:	83 c4 10             	add    $0x10,%esp
  ip->major = major;
80105ca5:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105ca8:	0f b7 55 d0          	movzwl -0x30(%ebp),%edx
80105cac:	66 89 50 52          	mov    %dx,0x52(%eax)
  ip->minor = minor;
80105cb0:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105cb3:	0f b7 55 cc          	movzwl -0x34(%ebp),%edx
80105cb7:	66 89 50 54          	mov    %dx,0x54(%eax)
  ip->nlink = 1;
80105cbb:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105cbe:	66 c7 40 56 01 00    	movw   $0x1,0x56(%eax)
  iupdate(ip);
80105cc4:	83 ec 0c             	sub    $0xc,%esp
80105cc7:	ff 75 f0             	push   -0x10(%ebp)
80105cca:	e8 3e bb ff ff       	call   8010180d <iupdate>
80105ccf:	83 c4 10             	add    $0x10,%esp

  if(type == T_DIR){  // Create . and .. entries.
80105cd2:	66 83 7d d4 01       	cmpw   $0x1,-0x2c(%ebp)
80105cd7:	75 6a                	jne    80105d43 <create+0x195>
    dp->nlink++;  // for ".."
80105cd9:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105cdc:	0f b7 40 56          	movzwl 0x56(%eax),%eax
80105ce0:	83 c0 01             	add    $0x1,%eax
80105ce3:	89 c2                	mov    %eax,%edx
80105ce5:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105ce8:	66 89 50 56          	mov    %dx,0x56(%eax)
    iupdate(dp);
80105cec:	83 ec 0c             	sub    $0xc,%esp
80105cef:	ff 75 f4             	push   -0xc(%ebp)
80105cf2:	e8 16 bb ff ff       	call   8010180d <iupdate>
80105cf7:	83 c4 10             	add    $0x10,%esp
    // No ip->nlink++ for ".": avoid cyclic ref count.
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
80105cfa:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105cfd:	8b 40 04             	mov    0x4(%eax),%eax
80105d00:	83 ec 04             	sub    $0x4,%esp
80105d03:	50                   	push   %eax
80105d04:	68 8e aa 10 80       	push   $0x8010aa8e
80105d09:	ff 75 f0             	push   -0x10(%ebp)
80105d0c:	e8 75 c5 ff ff       	call   80102286 <dirlink>
80105d11:	83 c4 10             	add    $0x10,%esp
80105d14:	85 c0                	test   %eax,%eax
80105d16:	78 1e                	js     80105d36 <create+0x188>
80105d18:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105d1b:	8b 40 04             	mov    0x4(%eax),%eax
80105d1e:	83 ec 04             	sub    $0x4,%esp
80105d21:	50                   	push   %eax
80105d22:	68 90 aa 10 80       	push   $0x8010aa90
80105d27:	ff 75 f0             	push   -0x10(%ebp)
80105d2a:	e8 57 c5 ff ff       	call   80102286 <dirlink>
80105d2f:	83 c4 10             	add    $0x10,%esp
80105d32:	85 c0                	test   %eax,%eax
80105d34:	79 0d                	jns    80105d43 <create+0x195>
      panic("create dots");
80105d36:	83 ec 0c             	sub    $0xc,%esp
80105d39:	68 c3 aa 10 80       	push   $0x8010aac3
80105d3e:	e8 66 a8 ff ff       	call   801005a9 <panic>
  }

  if(dirlink(dp, name, ip->inum) < 0)
80105d43:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105d46:	8b 40 04             	mov    0x4(%eax),%eax
80105d49:	83 ec 04             	sub    $0x4,%esp
80105d4c:	50                   	push   %eax
80105d4d:	8d 45 de             	lea    -0x22(%ebp),%eax
80105d50:	50                   	push   %eax
80105d51:	ff 75 f4             	push   -0xc(%ebp)
80105d54:	e8 2d c5 ff ff       	call   80102286 <dirlink>
80105d59:	83 c4 10             	add    $0x10,%esp
80105d5c:	85 c0                	test   %eax,%eax
80105d5e:	79 0d                	jns    80105d6d <create+0x1bf>
    panic("create: dirlink");
80105d60:	83 ec 0c             	sub    $0xc,%esp
80105d63:	68 cf aa 10 80       	push   $0x8010aacf
80105d68:	e8 3c a8 ff ff       	call   801005a9 <panic>

  iunlockput(dp);
80105d6d:	83 ec 0c             	sub    $0xc,%esp
80105d70:	ff 75 f4             	push   -0xc(%ebp)
80105d73:	e8 a3 be ff ff       	call   80101c1b <iunlockput>
80105d78:	83 c4 10             	add    $0x10,%esp

  return ip;
80105d7b:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
80105d7e:	c9                   	leave  
80105d7f:	c3                   	ret    

80105d80 <sys_open>:

int
sys_open(void)
{
80105d80:	55                   	push   %ebp
80105d81:	89 e5                	mov    %esp,%ebp
80105d83:	83 ec 28             	sub    $0x28,%esp
  char *path;
  int fd, omode;
  struct file *f;
  struct inode *ip;

  if(argstr(0, &path) < 0 || argint(1, &omode) < 0)
80105d86:	83 ec 08             	sub    $0x8,%esp
80105d89:	8d 45 e8             	lea    -0x18(%ebp),%eax
80105d8c:	50                   	push   %eax
80105d8d:	6a 00                	push   $0x0
80105d8f:	e8 ea f6 ff ff       	call   8010547e <argstr>
80105d94:	83 c4 10             	add    $0x10,%esp
80105d97:	85 c0                	test   %eax,%eax
80105d99:	78 15                	js     80105db0 <sys_open+0x30>
80105d9b:	83 ec 08             	sub    $0x8,%esp
80105d9e:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80105da1:	50                   	push   %eax
80105da2:	6a 01                	push   $0x1
80105da4:	e8 40 f6 ff ff       	call   801053e9 <argint>
80105da9:	83 c4 10             	add    $0x10,%esp
80105dac:	85 c0                	test   %eax,%eax
80105dae:	79 0a                	jns    80105dba <sys_open+0x3a>
    return -1;
80105db0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105db5:	e9 61 01 00 00       	jmp    80105f1b <sys_open+0x19b>

  begin_op();
80105dba:	e8 61 d7 ff ff       	call   80103520 <begin_op>

  if(omode & O_CREATE){
80105dbf:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80105dc2:	25 00 02 00 00       	and    $0x200,%eax
80105dc7:	85 c0                	test   %eax,%eax
80105dc9:	74 2a                	je     80105df5 <sys_open+0x75>
    ip = create(path, T_FILE, 0, 0);
80105dcb:	8b 45 e8             	mov    -0x18(%ebp),%eax
80105dce:	6a 00                	push   $0x0
80105dd0:	6a 00                	push   $0x0
80105dd2:	6a 02                	push   $0x2
80105dd4:	50                   	push   %eax
80105dd5:	e8 d4 fd ff ff       	call   80105bae <create>
80105dda:	83 c4 10             	add    $0x10,%esp
80105ddd:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(ip == 0){
80105de0:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80105de4:	75 75                	jne    80105e5b <sys_open+0xdb>
      end_op();
80105de6:	e8 c1 d7 ff ff       	call   801035ac <end_op>
      return -1;
80105deb:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105df0:	e9 26 01 00 00       	jmp    80105f1b <sys_open+0x19b>
    }
  } else {
    if((ip = namei(path)) == 0){
80105df5:	8b 45 e8             	mov    -0x18(%ebp),%eax
80105df8:	83 ec 0c             	sub    $0xc,%esp
80105dfb:	50                   	push   %eax
80105dfc:	e8 1c c7 ff ff       	call   8010251d <namei>
80105e01:	83 c4 10             	add    $0x10,%esp
80105e04:	89 45 f4             	mov    %eax,-0xc(%ebp)
80105e07:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80105e0b:	75 0f                	jne    80105e1c <sys_open+0x9c>
      end_op();
80105e0d:	e8 9a d7 ff ff       	call   801035ac <end_op>
      return -1;
80105e12:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105e17:	e9 ff 00 00 00       	jmp    80105f1b <sys_open+0x19b>
    }
    ilock(ip);
80105e1c:	83 ec 0c             	sub    $0xc,%esp
80105e1f:	ff 75 f4             	push   -0xc(%ebp)
80105e22:	e8 c3 bb ff ff       	call   801019ea <ilock>
80105e27:	83 c4 10             	add    $0x10,%esp
    if(ip->type == T_DIR && omode != O_RDONLY){
80105e2a:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105e2d:	0f b7 40 50          	movzwl 0x50(%eax),%eax
80105e31:	66 83 f8 01          	cmp    $0x1,%ax
80105e35:	75 24                	jne    80105e5b <sys_open+0xdb>
80105e37:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80105e3a:	85 c0                	test   %eax,%eax
80105e3c:	74 1d                	je     80105e5b <sys_open+0xdb>
      iunlockput(ip);
80105e3e:	83 ec 0c             	sub    $0xc,%esp
80105e41:	ff 75 f4             	push   -0xc(%ebp)
80105e44:	e8 d2 bd ff ff       	call   80101c1b <iunlockput>
80105e49:	83 c4 10             	add    $0x10,%esp
      end_op();
80105e4c:	e8 5b d7 ff ff       	call   801035ac <end_op>
      return -1;
80105e51:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105e56:	e9 c0 00 00 00       	jmp    80105f1b <sys_open+0x19b>
    }
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
80105e5b:	e8 7d b1 ff ff       	call   80100fdd <filealloc>
80105e60:	89 45 f0             	mov    %eax,-0x10(%ebp)
80105e63:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80105e67:	74 17                	je     80105e80 <sys_open+0x100>
80105e69:	83 ec 0c             	sub    $0xc,%esp
80105e6c:	ff 75 f0             	push   -0x10(%ebp)
80105e6f:	e8 33 f7 ff ff       	call   801055a7 <fdalloc>
80105e74:	83 c4 10             	add    $0x10,%esp
80105e77:	89 45 ec             	mov    %eax,-0x14(%ebp)
80105e7a:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
80105e7e:	79 2e                	jns    80105eae <sys_open+0x12e>
    if(f)
80105e80:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80105e84:	74 0e                	je     80105e94 <sys_open+0x114>
      fileclose(f);
80105e86:	83 ec 0c             	sub    $0xc,%esp
80105e89:	ff 75 f0             	push   -0x10(%ebp)
80105e8c:	e8 0a b2 ff ff       	call   8010109b <fileclose>
80105e91:	83 c4 10             	add    $0x10,%esp
    iunlockput(ip);
80105e94:	83 ec 0c             	sub    $0xc,%esp
80105e97:	ff 75 f4             	push   -0xc(%ebp)
80105e9a:	e8 7c bd ff ff       	call   80101c1b <iunlockput>
80105e9f:	83 c4 10             	add    $0x10,%esp
    end_op();
80105ea2:	e8 05 d7 ff ff       	call   801035ac <end_op>
    return -1;
80105ea7:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105eac:	eb 6d                	jmp    80105f1b <sys_open+0x19b>
  }
  iunlock(ip);
80105eae:	83 ec 0c             	sub    $0xc,%esp
80105eb1:	ff 75 f4             	push   -0xc(%ebp)
80105eb4:	e8 44 bc ff ff       	call   80101afd <iunlock>
80105eb9:	83 c4 10             	add    $0x10,%esp
  end_op();
80105ebc:	e8 eb d6 ff ff       	call   801035ac <end_op>

  f->type = FD_INODE;
80105ec1:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105ec4:	c7 00 02 00 00 00    	movl   $0x2,(%eax)
  f->ip = ip;
80105eca:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105ecd:	8b 55 f4             	mov    -0xc(%ebp),%edx
80105ed0:	89 50 10             	mov    %edx,0x10(%eax)
  f->off = 0;
80105ed3:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105ed6:	c7 40 14 00 00 00 00 	movl   $0x0,0x14(%eax)
  f->readable = !(omode & O_WRONLY);
80105edd:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80105ee0:	83 e0 01             	and    $0x1,%eax
80105ee3:	85 c0                	test   %eax,%eax
80105ee5:	0f 94 c0             	sete   %al
80105ee8:	89 c2                	mov    %eax,%edx
80105eea:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105eed:	88 50 08             	mov    %dl,0x8(%eax)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
80105ef0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80105ef3:	83 e0 01             	and    $0x1,%eax
80105ef6:	85 c0                	test   %eax,%eax
80105ef8:	75 0a                	jne    80105f04 <sys_open+0x184>
80105efa:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80105efd:	83 e0 02             	and    $0x2,%eax
80105f00:	85 c0                	test   %eax,%eax
80105f02:	74 07                	je     80105f0b <sys_open+0x18b>
80105f04:	b8 01 00 00 00       	mov    $0x1,%eax
80105f09:	eb 05                	jmp    80105f10 <sys_open+0x190>
80105f0b:	b8 00 00 00 00       	mov    $0x0,%eax
80105f10:	89 c2                	mov    %eax,%edx
80105f12:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105f15:	88 50 09             	mov    %dl,0x9(%eax)
  return fd;
80105f18:	8b 45 ec             	mov    -0x14(%ebp),%eax
}
80105f1b:	c9                   	leave  
80105f1c:	c3                   	ret    

80105f1d <sys_mkdir>:

int
sys_mkdir(void)
{
80105f1d:	55                   	push   %ebp
80105f1e:	89 e5                	mov    %esp,%ebp
80105f20:	83 ec 18             	sub    $0x18,%esp
  char *path;
  struct inode *ip;

  begin_op();
80105f23:	e8 f8 d5 ff ff       	call   80103520 <begin_op>
  if(argstr(0, &path) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
80105f28:	83 ec 08             	sub    $0x8,%esp
80105f2b:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105f2e:	50                   	push   %eax
80105f2f:	6a 00                	push   $0x0
80105f31:	e8 48 f5 ff ff       	call   8010547e <argstr>
80105f36:	83 c4 10             	add    $0x10,%esp
80105f39:	85 c0                	test   %eax,%eax
80105f3b:	78 1b                	js     80105f58 <sys_mkdir+0x3b>
80105f3d:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105f40:	6a 00                	push   $0x0
80105f42:	6a 00                	push   $0x0
80105f44:	6a 01                	push   $0x1
80105f46:	50                   	push   %eax
80105f47:	e8 62 fc ff ff       	call   80105bae <create>
80105f4c:	83 c4 10             	add    $0x10,%esp
80105f4f:	89 45 f4             	mov    %eax,-0xc(%ebp)
80105f52:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80105f56:	75 0c                	jne    80105f64 <sys_mkdir+0x47>
    end_op();
80105f58:	e8 4f d6 ff ff       	call   801035ac <end_op>
    return -1;
80105f5d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105f62:	eb 18                	jmp    80105f7c <sys_mkdir+0x5f>
  }
  iunlockput(ip);
80105f64:	83 ec 0c             	sub    $0xc,%esp
80105f67:	ff 75 f4             	push   -0xc(%ebp)
80105f6a:	e8 ac bc ff ff       	call   80101c1b <iunlockput>
80105f6f:	83 c4 10             	add    $0x10,%esp
  end_op();
80105f72:	e8 35 d6 ff ff       	call   801035ac <end_op>
  return 0;
80105f77:	b8 00 00 00 00       	mov    $0x0,%eax
}
80105f7c:	c9                   	leave  
80105f7d:	c3                   	ret    

80105f7e <sys_mknod>:

int
sys_mknod(void)
{
80105f7e:	55                   	push   %ebp
80105f7f:	89 e5                	mov    %esp,%ebp
80105f81:	83 ec 18             	sub    $0x18,%esp
  struct inode *ip;
  char *path;
  int major, minor;

  begin_op();
80105f84:	e8 97 d5 ff ff       	call   80103520 <begin_op>
  if((argstr(0, &path)) < 0 ||
80105f89:	83 ec 08             	sub    $0x8,%esp
80105f8c:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105f8f:	50                   	push   %eax
80105f90:	6a 00                	push   $0x0
80105f92:	e8 e7 f4 ff ff       	call   8010547e <argstr>
80105f97:	83 c4 10             	add    $0x10,%esp
80105f9a:	85 c0                	test   %eax,%eax
80105f9c:	78 4f                	js     80105fed <sys_mknod+0x6f>
     argint(1, &major) < 0 ||
80105f9e:	83 ec 08             	sub    $0x8,%esp
80105fa1:	8d 45 ec             	lea    -0x14(%ebp),%eax
80105fa4:	50                   	push   %eax
80105fa5:	6a 01                	push   $0x1
80105fa7:	e8 3d f4 ff ff       	call   801053e9 <argint>
80105fac:	83 c4 10             	add    $0x10,%esp
  if((argstr(0, &path)) < 0 ||
80105faf:	85 c0                	test   %eax,%eax
80105fb1:	78 3a                	js     80105fed <sys_mknod+0x6f>
     argint(2, &minor) < 0 ||
80105fb3:	83 ec 08             	sub    $0x8,%esp
80105fb6:	8d 45 e8             	lea    -0x18(%ebp),%eax
80105fb9:	50                   	push   %eax
80105fba:	6a 02                	push   $0x2
80105fbc:	e8 28 f4 ff ff       	call   801053e9 <argint>
80105fc1:	83 c4 10             	add    $0x10,%esp
     argint(1, &major) < 0 ||
80105fc4:	85 c0                	test   %eax,%eax
80105fc6:	78 25                	js     80105fed <sys_mknod+0x6f>
     (ip = create(path, T_DEV, major, minor)) == 0){
80105fc8:	8b 45 e8             	mov    -0x18(%ebp),%eax
80105fcb:	0f bf c8             	movswl %ax,%ecx
80105fce:	8b 45 ec             	mov    -0x14(%ebp),%eax
80105fd1:	0f bf d0             	movswl %ax,%edx
80105fd4:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105fd7:	51                   	push   %ecx
80105fd8:	52                   	push   %edx
80105fd9:	6a 03                	push   $0x3
80105fdb:	50                   	push   %eax
80105fdc:	e8 cd fb ff ff       	call   80105bae <create>
80105fe1:	83 c4 10             	add    $0x10,%esp
80105fe4:	89 45 f4             	mov    %eax,-0xc(%ebp)
     argint(2, &minor) < 0 ||
80105fe7:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80105feb:	75 0c                	jne    80105ff9 <sys_mknod+0x7b>
    end_op();
80105fed:	e8 ba d5 ff ff       	call   801035ac <end_op>
    return -1;
80105ff2:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105ff7:	eb 18                	jmp    80106011 <sys_mknod+0x93>
  }
  iunlockput(ip);
80105ff9:	83 ec 0c             	sub    $0xc,%esp
80105ffc:	ff 75 f4             	push   -0xc(%ebp)
80105fff:	e8 17 bc ff ff       	call   80101c1b <iunlockput>
80106004:	83 c4 10             	add    $0x10,%esp
  end_op();
80106007:	e8 a0 d5 ff ff       	call   801035ac <end_op>
  return 0;
8010600c:	b8 00 00 00 00       	mov    $0x0,%eax
}
80106011:	c9                   	leave  
80106012:	c3                   	ret    

80106013 <sys_chdir>:

int
sys_chdir(void)
{
80106013:	55                   	push   %ebp
80106014:	89 e5                	mov    %esp,%ebp
80106016:	83 ec 18             	sub    $0x18,%esp
  char *path;
  struct inode *ip;
  struct proc *curproc = myproc();
80106019:	e8 f6 de ff ff       	call   80103f14 <myproc>
8010601e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  
  begin_op();
80106021:	e8 fa d4 ff ff       	call   80103520 <begin_op>
  if(argstr(0, &path) < 0 || (ip = namei(path)) == 0){
80106026:	83 ec 08             	sub    $0x8,%esp
80106029:	8d 45 ec             	lea    -0x14(%ebp),%eax
8010602c:	50                   	push   %eax
8010602d:	6a 00                	push   $0x0
8010602f:	e8 4a f4 ff ff       	call   8010547e <argstr>
80106034:	83 c4 10             	add    $0x10,%esp
80106037:	85 c0                	test   %eax,%eax
80106039:	78 18                	js     80106053 <sys_chdir+0x40>
8010603b:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010603e:	83 ec 0c             	sub    $0xc,%esp
80106041:	50                   	push   %eax
80106042:	e8 d6 c4 ff ff       	call   8010251d <namei>
80106047:	83 c4 10             	add    $0x10,%esp
8010604a:	89 45 f0             	mov    %eax,-0x10(%ebp)
8010604d:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80106051:	75 0c                	jne    8010605f <sys_chdir+0x4c>
    end_op();
80106053:	e8 54 d5 ff ff       	call   801035ac <end_op>
    return -1;
80106058:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010605d:	eb 68                	jmp    801060c7 <sys_chdir+0xb4>
  }
  ilock(ip);
8010605f:	83 ec 0c             	sub    $0xc,%esp
80106062:	ff 75 f0             	push   -0x10(%ebp)
80106065:	e8 80 b9 ff ff       	call   801019ea <ilock>
8010606a:	83 c4 10             	add    $0x10,%esp
  if(ip->type != T_DIR){
8010606d:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106070:	0f b7 40 50          	movzwl 0x50(%eax),%eax
80106074:	66 83 f8 01          	cmp    $0x1,%ax
80106078:	74 1a                	je     80106094 <sys_chdir+0x81>
    iunlockput(ip);
8010607a:	83 ec 0c             	sub    $0xc,%esp
8010607d:	ff 75 f0             	push   -0x10(%ebp)
80106080:	e8 96 bb ff ff       	call   80101c1b <iunlockput>
80106085:	83 c4 10             	add    $0x10,%esp
    end_op();
80106088:	e8 1f d5 ff ff       	call   801035ac <end_op>
    return -1;
8010608d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106092:	eb 33                	jmp    801060c7 <sys_chdir+0xb4>
  }
  iunlock(ip);
80106094:	83 ec 0c             	sub    $0xc,%esp
80106097:	ff 75 f0             	push   -0x10(%ebp)
8010609a:	e8 5e ba ff ff       	call   80101afd <iunlock>
8010609f:	83 c4 10             	add    $0x10,%esp
  iput(curproc->cwd);
801060a2:	8b 45 f4             	mov    -0xc(%ebp),%eax
801060a5:	8b 40 68             	mov    0x68(%eax),%eax
801060a8:	83 ec 0c             	sub    $0xc,%esp
801060ab:	50                   	push   %eax
801060ac:	e8 9a ba ff ff       	call   80101b4b <iput>
801060b1:	83 c4 10             	add    $0x10,%esp
  end_op();
801060b4:	e8 f3 d4 ff ff       	call   801035ac <end_op>
  curproc->cwd = ip;
801060b9:	8b 45 f4             	mov    -0xc(%ebp),%eax
801060bc:	8b 55 f0             	mov    -0x10(%ebp),%edx
801060bf:	89 50 68             	mov    %edx,0x68(%eax)
  return 0;
801060c2:	b8 00 00 00 00       	mov    $0x0,%eax
}
801060c7:	c9                   	leave  
801060c8:	c3                   	ret    

801060c9 <sys_exec>:

int
sys_exec(void)
{
801060c9:	55                   	push   %ebp
801060ca:	89 e5                	mov    %esp,%ebp
801060cc:	81 ec 98 00 00 00    	sub    $0x98,%esp
  char *path, *argv[MAXARG];
  int i;
  uint uargv, uarg;

  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
801060d2:	83 ec 08             	sub    $0x8,%esp
801060d5:	8d 45 f0             	lea    -0x10(%ebp),%eax
801060d8:	50                   	push   %eax
801060d9:	6a 00                	push   $0x0
801060db:	e8 9e f3 ff ff       	call   8010547e <argstr>
801060e0:	83 c4 10             	add    $0x10,%esp
801060e3:	85 c0                	test   %eax,%eax
801060e5:	78 18                	js     801060ff <sys_exec+0x36>
801060e7:	83 ec 08             	sub    $0x8,%esp
801060ea:	8d 85 6c ff ff ff    	lea    -0x94(%ebp),%eax
801060f0:	50                   	push   %eax
801060f1:	6a 01                	push   $0x1
801060f3:	e8 f1 f2 ff ff       	call   801053e9 <argint>
801060f8:	83 c4 10             	add    $0x10,%esp
801060fb:	85 c0                	test   %eax,%eax
801060fd:	79 0a                	jns    80106109 <sys_exec+0x40>
    return -1;
801060ff:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106104:	e9 c6 00 00 00       	jmp    801061cf <sys_exec+0x106>
  }
  memset(argv, 0, sizeof(argv));
80106109:	83 ec 04             	sub    $0x4,%esp
8010610c:	68 80 00 00 00       	push   $0x80
80106111:	6a 00                	push   $0x0
80106113:	8d 85 70 ff ff ff    	lea    -0x90(%ebp),%eax
80106119:	50                   	push   %eax
8010611a:	e8 9f ef ff ff       	call   801050be <memset>
8010611f:	83 c4 10             	add    $0x10,%esp
  for(i=0;; i++){
80106122:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    if(i >= NELEM(argv))
80106129:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010612c:	83 f8 1f             	cmp    $0x1f,%eax
8010612f:	76 0a                	jbe    8010613b <sys_exec+0x72>
      return -1;
80106131:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106136:	e9 94 00 00 00       	jmp    801061cf <sys_exec+0x106>
    if(fetchint(uargv+4*i, (int*)&uarg) < 0)
8010613b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010613e:	c1 e0 02             	shl    $0x2,%eax
80106141:	89 c2                	mov    %eax,%edx
80106143:	8b 85 6c ff ff ff    	mov    -0x94(%ebp),%eax
80106149:	01 c2                	add    %eax,%edx
8010614b:	83 ec 08             	sub    $0x8,%esp
8010614e:	8d 85 68 ff ff ff    	lea    -0x98(%ebp),%eax
80106154:	50                   	push   %eax
80106155:	52                   	push   %edx
80106156:	e8 ed f1 ff ff       	call   80105348 <fetchint>
8010615b:	83 c4 10             	add    $0x10,%esp
8010615e:	85 c0                	test   %eax,%eax
80106160:	79 07                	jns    80106169 <sys_exec+0xa0>
      return -1;
80106162:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106167:	eb 66                	jmp    801061cf <sys_exec+0x106>
    if(uarg == 0){
80106169:	8b 85 68 ff ff ff    	mov    -0x98(%ebp),%eax
8010616f:	85 c0                	test   %eax,%eax
80106171:	75 27                	jne    8010619a <sys_exec+0xd1>
      argv[i] = 0;
80106173:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106176:	c7 84 85 70 ff ff ff 	movl   $0x0,-0x90(%ebp,%eax,4)
8010617d:	00 00 00 00 
      break;
80106181:	90                   	nop
    }
    if(fetchstr(uarg, &argv[i]) < 0)
      return -1;
  }
  return exec(path, argv);
80106182:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106185:	83 ec 08             	sub    $0x8,%esp
80106188:	8d 95 70 ff ff ff    	lea    -0x90(%ebp),%edx
8010618e:	52                   	push   %edx
8010618f:	50                   	push   %eax
80106190:	e8 eb a9 ff ff       	call   80100b80 <exec>
80106195:	83 c4 10             	add    $0x10,%esp
80106198:	eb 35                	jmp    801061cf <sys_exec+0x106>
    if(fetchstr(uarg, &argv[i]) < 0)
8010619a:	8d 95 70 ff ff ff    	lea    -0x90(%ebp),%edx
801061a0:	8b 45 f4             	mov    -0xc(%ebp),%eax
801061a3:	c1 e0 02             	shl    $0x2,%eax
801061a6:	01 c2                	add    %eax,%edx
801061a8:	8b 85 68 ff ff ff    	mov    -0x98(%ebp),%eax
801061ae:	83 ec 08             	sub    $0x8,%esp
801061b1:	52                   	push   %edx
801061b2:	50                   	push   %eax
801061b3:	e8 cf f1 ff ff       	call   80105387 <fetchstr>
801061b8:	83 c4 10             	add    $0x10,%esp
801061bb:	85 c0                	test   %eax,%eax
801061bd:	79 07                	jns    801061c6 <sys_exec+0xfd>
      return -1;
801061bf:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801061c4:	eb 09                	jmp    801061cf <sys_exec+0x106>
  for(i=0;; i++){
801061c6:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
    if(i >= NELEM(argv))
801061ca:	e9 5a ff ff ff       	jmp    80106129 <sys_exec+0x60>
}
801061cf:	c9                   	leave  
801061d0:	c3                   	ret    

801061d1 <sys_pipe>:

int
sys_pipe(void)
{
801061d1:	55                   	push   %ebp
801061d2:	89 e5                	mov    %esp,%ebp
801061d4:	83 ec 28             	sub    $0x28,%esp
  int *fd;
  struct file *rf, *wf;
  int fd0, fd1;

  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
801061d7:	83 ec 04             	sub    $0x4,%esp
801061da:	6a 08                	push   $0x8
801061dc:	8d 45 ec             	lea    -0x14(%ebp),%eax
801061df:	50                   	push   %eax
801061e0:	6a 00                	push   $0x0
801061e2:	e8 2f f2 ff ff       	call   80105416 <argptr>
801061e7:	83 c4 10             	add    $0x10,%esp
801061ea:	85 c0                	test   %eax,%eax
801061ec:	79 0a                	jns    801061f8 <sys_pipe+0x27>
    return -1;
801061ee:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801061f3:	e9 ae 00 00 00       	jmp    801062a6 <sys_pipe+0xd5>
  if(pipealloc(&rf, &wf) < 0)
801061f8:	83 ec 08             	sub    $0x8,%esp
801061fb:	8d 45 e4             	lea    -0x1c(%ebp),%eax
801061fe:	50                   	push   %eax
801061ff:	8d 45 e8             	lea    -0x18(%ebp),%eax
80106202:	50                   	push   %eax
80106203:	e8 49 d8 ff ff       	call   80103a51 <pipealloc>
80106208:	83 c4 10             	add    $0x10,%esp
8010620b:	85 c0                	test   %eax,%eax
8010620d:	79 0a                	jns    80106219 <sys_pipe+0x48>
    return -1;
8010620f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106214:	e9 8d 00 00 00       	jmp    801062a6 <sys_pipe+0xd5>
  fd0 = -1;
80106219:	c7 45 f4 ff ff ff ff 	movl   $0xffffffff,-0xc(%ebp)
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
80106220:	8b 45 e8             	mov    -0x18(%ebp),%eax
80106223:	83 ec 0c             	sub    $0xc,%esp
80106226:	50                   	push   %eax
80106227:	e8 7b f3 ff ff       	call   801055a7 <fdalloc>
8010622c:	83 c4 10             	add    $0x10,%esp
8010622f:	89 45 f4             	mov    %eax,-0xc(%ebp)
80106232:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80106236:	78 18                	js     80106250 <sys_pipe+0x7f>
80106238:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010623b:	83 ec 0c             	sub    $0xc,%esp
8010623e:	50                   	push   %eax
8010623f:	e8 63 f3 ff ff       	call   801055a7 <fdalloc>
80106244:	83 c4 10             	add    $0x10,%esp
80106247:	89 45 f0             	mov    %eax,-0x10(%ebp)
8010624a:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
8010624e:	79 3e                	jns    8010628e <sys_pipe+0xbd>
    if(fd0 >= 0)
80106250:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80106254:	78 13                	js     80106269 <sys_pipe+0x98>
      myproc()->ofile[fd0] = 0;
80106256:	e8 b9 dc ff ff       	call   80103f14 <myproc>
8010625b:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010625e:	83 c2 08             	add    $0x8,%edx
80106261:	c7 44 90 08 00 00 00 	movl   $0x0,0x8(%eax,%edx,4)
80106268:	00 
    fileclose(rf);
80106269:	8b 45 e8             	mov    -0x18(%ebp),%eax
8010626c:	83 ec 0c             	sub    $0xc,%esp
8010626f:	50                   	push   %eax
80106270:	e8 26 ae ff ff       	call   8010109b <fileclose>
80106275:	83 c4 10             	add    $0x10,%esp
    fileclose(wf);
80106278:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010627b:	83 ec 0c             	sub    $0xc,%esp
8010627e:	50                   	push   %eax
8010627f:	e8 17 ae ff ff       	call   8010109b <fileclose>
80106284:	83 c4 10             	add    $0x10,%esp
    return -1;
80106287:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010628c:	eb 18                	jmp    801062a6 <sys_pipe+0xd5>
  }
  fd[0] = fd0;
8010628e:	8b 45 ec             	mov    -0x14(%ebp),%eax
80106291:	8b 55 f4             	mov    -0xc(%ebp),%edx
80106294:	89 10                	mov    %edx,(%eax)
  fd[1] = fd1;
80106296:	8b 45 ec             	mov    -0x14(%ebp),%eax
80106299:	8d 50 04             	lea    0x4(%eax),%edx
8010629c:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010629f:	89 02                	mov    %eax,(%edx)
  return 0;
801062a1:	b8 00 00 00 00       	mov    $0x0,%eax
}
801062a6:	c9                   	leave  
801062a7:	c3                   	ret    

801062a8 <sys_fork>:
#include "spinlock.h"
#include "debug.h"

int
sys_fork(void)
{
801062a8:	55                   	push   %ebp
801062a9:	89 e5                	mov    %esp,%ebp
801062ab:	83 ec 08             	sub    $0x8,%esp
  return fork();
801062ae:	e8 60 df ff ff       	call   80104213 <fork>
}
801062b3:	c9                   	leave  
801062b4:	c3                   	ret    

801062b5 <sys_exit>:

int
sys_exit(void)
{
801062b5:	55                   	push   %ebp
801062b6:	89 e5                	mov    %esp,%ebp
801062b8:	83 ec 08             	sub    $0x8,%esp
  exit();
801062bb:	e8 cc e0 ff ff       	call   8010438c <exit>
  return 0;  // not reached
801062c0:	b8 00 00 00 00       	mov    $0x0,%eax
}
801062c5:	c9                   	leave  
801062c6:	c3                   	ret    

801062c7 <sys_exit2>:

int
sys_exit2(void) 
{
801062c7:	55                   	push   %ebp
801062c8:	89 e5                	mov    %esp,%ebp
801062ca:	83 ec 18             	sub    $0x18,%esp
  //struct proc *curproc = myproc();
  int status;

  argint(0, &status);
801062cd:	83 ec 08             	sub    $0x8,%esp
801062d0:	8d 45 f4             	lea    -0xc(%ebp),%eax
801062d3:	50                   	push   %eax
801062d4:	6a 00                	push   $0x0
801062d6:	e8 0e f1 ff ff       	call   801053e9 <argint>
801062db:	83 c4 10             	add    $0x10,%esp
   
  exit2(status); 
801062de:	8b 45 f4             	mov    -0xc(%ebp),%eax
801062e1:	83 ec 0c             	sub    $0xc,%esp
801062e4:	50                   	push   %eax
801062e5:	e8 c2 e1 ff ff       	call   801044ac <exit2>
801062ea:	83 c4 10             	add    $0x10,%esp
  return 0; //eax에 리턴해야하니까
801062ed:	b8 00 00 00 00       	mov    $0x0,%eax
}  
801062f2:	c9                   	leave  
801062f3:	c3                   	ret    

801062f4 <sys_wait>:

int
sys_wait(void)
{
801062f4:	55                   	push   %ebp
801062f5:	89 e5                	mov    %esp,%ebp
801062f7:	83 ec 08             	sub    $0x8,%esp
  return wait();
801062fa:	e8 f2 e2 ff ff       	call   801045f1 <wait>
}
801062ff:	c9                   	leave  
80106300:	c3                   	ret    

80106301 <sys_wait2>:
//*********new sys_waiat**********
//********************************

int
sys_wait2(void)
{
80106301:	55                   	push   %ebp
80106302:	89 e5                	mov    %esp,%ebp
80106304:	83 ec 18             	sub    $0x18,%esp

  int status;
  //포인터 값 복사, 유효값 아니라면 리턴 -1
  if(argptr(0, (char **)&status, sizeof(int)) < 0)
80106307:	83 ec 04             	sub    $0x4,%esp
8010630a:	6a 04                	push   $0x4
8010630c:	8d 45 f4             	lea    -0xc(%ebp),%eax
8010630f:	50                   	push   %eax
80106310:	6a 00                	push   $0x0
80106312:	e8 ff f0 ff ff       	call   80105416 <argptr>
80106317:	83 c4 10             	add    $0x10,%esp
8010631a:	85 c0                	test   %eax,%eax
8010631c:	79 07                	jns    80106325 <sys_wait2+0x24>
    return -1;
8010631e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106323:	eb 0f                	jmp    80106334 <sys_wait2+0x33>

  //유효값이면 wait2 실행
  return wait2(&status);
80106325:	83 ec 0c             	sub    $0xc,%esp
80106328:	8d 45 f4             	lea    -0xc(%ebp),%eax
8010632b:	50                   	push   %eax
8010632c:	e8 e0 e3 ff ff       	call   80104711 <wait2>
80106331:	83 c4 10             	add    $0x10,%esp

}
80106334:	c9                   	leave  
80106335:	c3                   	ret    

80106336 <sys_kill>:
//********************************


int
sys_kill(void)
{
80106336:	55                   	push   %ebp
80106337:	89 e5                	mov    %esp,%ebp
80106339:	83 ec 18             	sub    $0x18,%esp
  int pid;

  if(argint(0, &pid) < 0)
8010633c:	83 ec 08             	sub    $0x8,%esp
8010633f:	8d 45 f4             	lea    -0xc(%ebp),%eax
80106342:	50                   	push   %eax
80106343:	6a 00                	push   $0x0
80106345:	e8 9f f0 ff ff       	call   801053e9 <argint>
8010634a:	83 c4 10             	add    $0x10,%esp
8010634d:	85 c0                	test   %eax,%eax
8010634f:	79 07                	jns    80106358 <sys_kill+0x22>
    return -1;
80106351:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106356:	eb 0f                	jmp    80106367 <sys_kill+0x31>
  return kill(pid);
80106358:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010635b:	83 ec 0c             	sub    $0xc,%esp
8010635e:	50                   	push   %eax
8010635f:	e8 e7 e7 ff ff       	call   80104b4b <kill>
80106364:	83 c4 10             	add    $0x10,%esp
}
80106367:	c9                   	leave  
80106368:	c3                   	ret    

80106369 <sys_getpid>:

int
sys_getpid(void)
{
80106369:	55                   	push   %ebp
8010636a:	89 e5                	mov    %esp,%ebp
8010636c:	83 ec 08             	sub    $0x8,%esp
  return myproc()->pid;
8010636f:	e8 a0 db ff ff       	call   80103f14 <myproc>
80106374:	8b 40 10             	mov    0x10(%eax),%eax
}
80106377:	c9                   	leave  
80106378:	c3                   	ret    

80106379 <sys_sbrk>:

int
sys_sbrk(void)
{
80106379:	55                   	push   %ebp
8010637a:	89 e5                	mov    %esp,%ebp
8010637c:	83 ec 18             	sub    $0x18,%esp
  int addr;
  int n;

  if(argint(0, &n) < 0)
8010637f:	83 ec 08             	sub    $0x8,%esp
80106382:	8d 45 f0             	lea    -0x10(%ebp),%eax
80106385:	50                   	push   %eax
80106386:	6a 00                	push   $0x0
80106388:	e8 5c f0 ff ff       	call   801053e9 <argint>
8010638d:	83 c4 10             	add    $0x10,%esp
80106390:	85 c0                	test   %eax,%eax
80106392:	79 07                	jns    8010639b <sys_sbrk+0x22>
    return -1;
80106394:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106399:	eb 27                	jmp    801063c2 <sys_sbrk+0x49>
  addr = myproc()->sz;
8010639b:	e8 74 db ff ff       	call   80103f14 <myproc>
801063a0:	8b 00                	mov    (%eax),%eax
801063a2:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(growproc(n) < 0)
801063a5:	8b 45 f0             	mov    -0x10(%ebp),%eax
801063a8:	83 ec 0c             	sub    $0xc,%esp
801063ab:	50                   	push   %eax
801063ac:	e8 c7 dd ff ff       	call   80104178 <growproc>
801063b1:	83 c4 10             	add    $0x10,%esp
801063b4:	85 c0                	test   %eax,%eax
801063b6:	79 07                	jns    801063bf <sys_sbrk+0x46>
    return -1;
801063b8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801063bd:	eb 03                	jmp    801063c2 <sys_sbrk+0x49>
  return addr;
801063bf:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
801063c2:	c9                   	leave  
801063c3:	c3                   	ret    

801063c4 <sys_sleep>:

int
sys_sleep(void)
{
801063c4:	55                   	push   %ebp
801063c5:	89 e5                	mov    %esp,%ebp
801063c7:	83 ec 18             	sub    $0x18,%esp
  int n;
  uint ticks0;

  if(argint(0, &n) < 0)
801063ca:	83 ec 08             	sub    $0x8,%esp
801063cd:	8d 45 f0             	lea    -0x10(%ebp),%eax
801063d0:	50                   	push   %eax
801063d1:	6a 00                	push   $0x0
801063d3:	e8 11 f0 ff ff       	call   801053e9 <argint>
801063d8:	83 c4 10             	add    $0x10,%esp
801063db:	85 c0                	test   %eax,%eax
801063dd:	79 07                	jns    801063e6 <sys_sleep+0x22>
    return -1;
801063df:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801063e4:	eb 76                	jmp    8010645c <sys_sleep+0x98>
  acquire(&tickslock);
801063e6:	83 ec 0c             	sub    $0xc,%esp
801063e9:	68 80 9a 11 80       	push   $0x80119a80
801063ee:	e8 55 ea ff ff       	call   80104e48 <acquire>
801063f3:	83 c4 10             	add    $0x10,%esp
  ticks0 = ticks;
801063f6:	a1 b4 9a 11 80       	mov    0x80119ab4,%eax
801063fb:	89 45 f4             	mov    %eax,-0xc(%ebp)
  while(ticks - ticks0 < n){
801063fe:	eb 38                	jmp    80106438 <sys_sleep+0x74>
    if(myproc()->killed){
80106400:	e8 0f db ff ff       	call   80103f14 <myproc>
80106405:	8b 40 24             	mov    0x24(%eax),%eax
80106408:	85 c0                	test   %eax,%eax
8010640a:	74 17                	je     80106423 <sys_sleep+0x5f>
      release(&tickslock);
8010640c:	83 ec 0c             	sub    $0xc,%esp
8010640f:	68 80 9a 11 80       	push   $0x80119a80
80106414:	e8 9d ea ff ff       	call   80104eb6 <release>
80106419:	83 c4 10             	add    $0x10,%esp
      return -1;
8010641c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106421:	eb 39                	jmp    8010645c <sys_sleep+0x98>
    }
    sleep(&ticks, &tickslock);
80106423:	83 ec 08             	sub    $0x8,%esp
80106426:	68 80 9a 11 80       	push   $0x80119a80
8010642b:	68 b4 9a 11 80       	push   $0x80119ab4
80106430:	e8 f8 e5 ff ff       	call   80104a2d <sleep>
80106435:	83 c4 10             	add    $0x10,%esp
  while(ticks - ticks0 < n){
80106438:	a1 b4 9a 11 80       	mov    0x80119ab4,%eax
8010643d:	2b 45 f4             	sub    -0xc(%ebp),%eax
80106440:	8b 55 f0             	mov    -0x10(%ebp),%edx
80106443:	39 d0                	cmp    %edx,%eax
80106445:	72 b9                	jb     80106400 <sys_sleep+0x3c>
  }
  release(&tickslock);
80106447:	83 ec 0c             	sub    $0xc,%esp
8010644a:	68 80 9a 11 80       	push   $0x80119a80
8010644f:	e8 62 ea ff ff       	call   80104eb6 <release>
80106454:	83 c4 10             	add    $0x10,%esp
  return 0;
80106457:	b8 00 00 00 00       	mov    $0x0,%eax
}
8010645c:	c9                   	leave  
8010645d:	c3                   	ret    

8010645e <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
int
sys_uptime(void)
{
8010645e:	55                   	push   %ebp
8010645f:	89 e5                	mov    %esp,%ebp
80106461:	83 ec 18             	sub    $0x18,%esp
  uint xticks;

  acquire(&tickslock);
80106464:	83 ec 0c             	sub    $0xc,%esp
80106467:	68 80 9a 11 80       	push   $0x80119a80
8010646c:	e8 d7 e9 ff ff       	call   80104e48 <acquire>
80106471:	83 c4 10             	add    $0x10,%esp
  xticks = ticks;
80106474:	a1 b4 9a 11 80       	mov    0x80119ab4,%eax
80106479:	89 45 f4             	mov    %eax,-0xc(%ebp)
  release(&tickslock);
8010647c:	83 ec 0c             	sub    $0xc,%esp
8010647f:	68 80 9a 11 80       	push   $0x80119a80
80106484:	e8 2d ea ff ff       	call   80104eb6 <release>
80106489:	83 c4 10             	add    $0x10,%esp
  return xticks;
8010648c:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
8010648f:	c9                   	leave  
80106490:	c3                   	ret    

80106491 <alltraps>:
80106491:	1e                   	push   %ds
80106492:	06                   	push   %es
80106493:	0f a0                	push   %fs
80106495:	0f a8                	push   %gs
80106497:	60                   	pusha  
80106498:	66 b8 10 00          	mov    $0x10,%ax
8010649c:	8e d8                	mov    %eax,%ds
8010649e:	8e c0                	mov    %eax,%es
801064a0:	54                   	push   %esp
801064a1:	e8 d7 01 00 00       	call   8010667d <trap>
801064a6:	83 c4 04             	add    $0x4,%esp

801064a9 <trapret>:
801064a9:	61                   	popa   
801064aa:	0f a9                	pop    %gs
801064ac:	0f a1                	pop    %fs
801064ae:	07                   	pop    %es
801064af:	1f                   	pop    %ds
801064b0:	83 c4 08             	add    $0x8,%esp
801064b3:	cf                   	iret   

801064b4 <lidt>:
{
801064b4:	55                   	push   %ebp
801064b5:	89 e5                	mov    %esp,%ebp
801064b7:	83 ec 10             	sub    $0x10,%esp
  pd[0] = size-1;
801064ba:	8b 45 0c             	mov    0xc(%ebp),%eax
801064bd:	83 e8 01             	sub    $0x1,%eax
801064c0:	66 89 45 fa          	mov    %ax,-0x6(%ebp)
  pd[1] = (uint)p;
801064c4:	8b 45 08             	mov    0x8(%ebp),%eax
801064c7:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  pd[2] = (uint)p >> 16;
801064cb:	8b 45 08             	mov    0x8(%ebp),%eax
801064ce:	c1 e8 10             	shr    $0x10,%eax
801064d1:	66 89 45 fe          	mov    %ax,-0x2(%ebp)
  asm volatile("lidt (%0)" : : "r" (pd));
801064d5:	8d 45 fa             	lea    -0x6(%ebp),%eax
801064d8:	0f 01 18             	lidtl  (%eax)
}
801064db:	90                   	nop
801064dc:	c9                   	leave  
801064dd:	c3                   	ret    

801064de <rcr2>:

static inline uint
rcr2(void)
{
801064de:	55                   	push   %ebp
801064df:	89 e5                	mov    %esp,%ebp
801064e1:	83 ec 10             	sub    $0x10,%esp
  uint val;
  asm volatile("movl %%cr2,%0" : "=r" (val));
801064e4:	0f 20 d0             	mov    %cr2,%eax
801064e7:	89 45 fc             	mov    %eax,-0x4(%ebp)
  return val;
801064ea:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
801064ed:	c9                   	leave  
801064ee:	c3                   	ret    

801064ef <tvinit>:
struct spinlock tickslock;
uint ticks;

void
tvinit(void)
{
801064ef:	55                   	push   %ebp
801064f0:	89 e5                	mov    %esp,%ebp
801064f2:	83 ec 18             	sub    $0x18,%esp
  int i;

  for(i = 0; i < 256; i++)
801064f5:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
801064fc:	e9 c3 00 00 00       	jmp    801065c4 <tvinit+0xd5>
    SETGATE(idt[i], 0, SEG_KCODE<<3, vectors[i], 0);
80106501:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106504:	8b 04 85 80 f0 10 80 	mov    -0x7fef0f80(,%eax,4),%eax
8010650b:	89 c2                	mov    %eax,%edx
8010650d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106510:	66 89 14 c5 80 92 11 	mov    %dx,-0x7fee6d80(,%eax,8)
80106517:	80 
80106518:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010651b:	66 c7 04 c5 82 92 11 	movw   $0x8,-0x7fee6d7e(,%eax,8)
80106522:	80 08 00 
80106525:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106528:	0f b6 14 c5 84 92 11 	movzbl -0x7fee6d7c(,%eax,8),%edx
8010652f:	80 
80106530:	83 e2 e0             	and    $0xffffffe0,%edx
80106533:	88 14 c5 84 92 11 80 	mov    %dl,-0x7fee6d7c(,%eax,8)
8010653a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010653d:	0f b6 14 c5 84 92 11 	movzbl -0x7fee6d7c(,%eax,8),%edx
80106544:	80 
80106545:	83 e2 1f             	and    $0x1f,%edx
80106548:	88 14 c5 84 92 11 80 	mov    %dl,-0x7fee6d7c(,%eax,8)
8010654f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106552:	0f b6 14 c5 85 92 11 	movzbl -0x7fee6d7b(,%eax,8),%edx
80106559:	80 
8010655a:	83 e2 f0             	and    $0xfffffff0,%edx
8010655d:	83 ca 0e             	or     $0xe,%edx
80106560:	88 14 c5 85 92 11 80 	mov    %dl,-0x7fee6d7b(,%eax,8)
80106567:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010656a:	0f b6 14 c5 85 92 11 	movzbl -0x7fee6d7b(,%eax,8),%edx
80106571:	80 
80106572:	83 e2 ef             	and    $0xffffffef,%edx
80106575:	88 14 c5 85 92 11 80 	mov    %dl,-0x7fee6d7b(,%eax,8)
8010657c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010657f:	0f b6 14 c5 85 92 11 	movzbl -0x7fee6d7b(,%eax,8),%edx
80106586:	80 
80106587:	83 e2 9f             	and    $0xffffff9f,%edx
8010658a:	88 14 c5 85 92 11 80 	mov    %dl,-0x7fee6d7b(,%eax,8)
80106591:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106594:	0f b6 14 c5 85 92 11 	movzbl -0x7fee6d7b(,%eax,8),%edx
8010659b:	80 
8010659c:	83 ca 80             	or     $0xffffff80,%edx
8010659f:	88 14 c5 85 92 11 80 	mov    %dl,-0x7fee6d7b(,%eax,8)
801065a6:	8b 45 f4             	mov    -0xc(%ebp),%eax
801065a9:	8b 04 85 80 f0 10 80 	mov    -0x7fef0f80(,%eax,4),%eax
801065b0:	c1 e8 10             	shr    $0x10,%eax
801065b3:	89 c2                	mov    %eax,%edx
801065b5:	8b 45 f4             	mov    -0xc(%ebp),%eax
801065b8:	66 89 14 c5 86 92 11 	mov    %dx,-0x7fee6d7a(,%eax,8)
801065bf:	80 
  for(i = 0; i < 256; i++)
801065c0:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
801065c4:	81 7d f4 ff 00 00 00 	cmpl   $0xff,-0xc(%ebp)
801065cb:	0f 8e 30 ff ff ff    	jle    80106501 <tvinit+0x12>
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
801065d1:	a1 80 f1 10 80       	mov    0x8010f180,%eax
801065d6:	66 a3 80 94 11 80    	mov    %ax,0x80119480
801065dc:	66 c7 05 82 94 11 80 	movw   $0x8,0x80119482
801065e3:	08 00 
801065e5:	0f b6 05 84 94 11 80 	movzbl 0x80119484,%eax
801065ec:	83 e0 e0             	and    $0xffffffe0,%eax
801065ef:	a2 84 94 11 80       	mov    %al,0x80119484
801065f4:	0f b6 05 84 94 11 80 	movzbl 0x80119484,%eax
801065fb:	83 e0 1f             	and    $0x1f,%eax
801065fe:	a2 84 94 11 80       	mov    %al,0x80119484
80106603:	0f b6 05 85 94 11 80 	movzbl 0x80119485,%eax
8010660a:	83 c8 0f             	or     $0xf,%eax
8010660d:	a2 85 94 11 80       	mov    %al,0x80119485
80106612:	0f b6 05 85 94 11 80 	movzbl 0x80119485,%eax
80106619:	83 e0 ef             	and    $0xffffffef,%eax
8010661c:	a2 85 94 11 80       	mov    %al,0x80119485
80106621:	0f b6 05 85 94 11 80 	movzbl 0x80119485,%eax
80106628:	83 c8 60             	or     $0x60,%eax
8010662b:	a2 85 94 11 80       	mov    %al,0x80119485
80106630:	0f b6 05 85 94 11 80 	movzbl 0x80119485,%eax
80106637:	83 c8 80             	or     $0xffffff80,%eax
8010663a:	a2 85 94 11 80       	mov    %al,0x80119485
8010663f:	a1 80 f1 10 80       	mov    0x8010f180,%eax
80106644:	c1 e8 10             	shr    $0x10,%eax
80106647:	66 a3 86 94 11 80    	mov    %ax,0x80119486

  initlock(&tickslock, "time");
8010664d:	83 ec 08             	sub    $0x8,%esp
80106650:	68 e0 aa 10 80       	push   $0x8010aae0
80106655:	68 80 9a 11 80       	push   $0x80119a80
8010665a:	e8 c7 e7 ff ff       	call   80104e26 <initlock>
8010665f:	83 c4 10             	add    $0x10,%esp
}
80106662:	90                   	nop
80106663:	c9                   	leave  
80106664:	c3                   	ret    

80106665 <idtinit>:

void
idtinit(void)
{
80106665:	55                   	push   %ebp
80106666:	89 e5                	mov    %esp,%ebp
  lidt(idt, sizeof(idt));
80106668:	68 00 08 00 00       	push   $0x800
8010666d:	68 80 92 11 80       	push   $0x80119280
80106672:	e8 3d fe ff ff       	call   801064b4 <lidt>
80106677:	83 c4 08             	add    $0x8,%esp
}
8010667a:	90                   	nop
8010667b:	c9                   	leave  
8010667c:	c3                   	ret    

8010667d <trap>:

//PAGEBREAK: 41
void
trap(struct trapframe *tf)
{
8010667d:	55                   	push   %ebp
8010667e:	89 e5                	mov    %esp,%ebp
80106680:	57                   	push   %edi
80106681:	56                   	push   %esi
80106682:	53                   	push   %ebx
80106683:	83 ec 1c             	sub    $0x1c,%esp
  if(tf->trapno == T_SYSCALL){
80106686:	8b 45 08             	mov    0x8(%ebp),%eax
80106689:	8b 40 30             	mov    0x30(%eax),%eax
8010668c:	83 f8 40             	cmp    $0x40,%eax
8010668f:	75 3b                	jne    801066cc <trap+0x4f>
    if(myproc()->killed)
80106691:	e8 7e d8 ff ff       	call   80103f14 <myproc>
80106696:	8b 40 24             	mov    0x24(%eax),%eax
80106699:	85 c0                	test   %eax,%eax
8010669b:	74 05                	je     801066a2 <trap+0x25>
      exit();
8010669d:	e8 ea dc ff ff       	call   8010438c <exit>
    myproc()->tf = tf;
801066a2:	e8 6d d8 ff ff       	call   80103f14 <myproc>
801066a7:	8b 55 08             	mov    0x8(%ebp),%edx
801066aa:	89 50 18             	mov    %edx,0x18(%eax)
    syscall();
801066ad:	e8 03 ee ff ff       	call   801054b5 <syscall>
    if(myproc()->killed)
801066b2:	e8 5d d8 ff ff       	call   80103f14 <myproc>
801066b7:	8b 40 24             	mov    0x24(%eax),%eax
801066ba:	85 c0                	test   %eax,%eax
801066bc:	0f 84 15 02 00 00    	je     801068d7 <trap+0x25a>
      exit();
801066c2:	e8 c5 dc ff ff       	call   8010438c <exit>
    return;
801066c7:	e9 0b 02 00 00       	jmp    801068d7 <trap+0x25a>
  }

  switch(tf->trapno){
801066cc:	8b 45 08             	mov    0x8(%ebp),%eax
801066cf:	8b 40 30             	mov    0x30(%eax),%eax
801066d2:	83 e8 20             	sub    $0x20,%eax
801066d5:	83 f8 1f             	cmp    $0x1f,%eax
801066d8:	0f 87 c4 00 00 00    	ja     801067a2 <trap+0x125>
801066de:	8b 04 85 88 ab 10 80 	mov    -0x7fef5478(,%eax,4),%eax
801066e5:	ff e0                	jmp    *%eax
  case T_IRQ0 + IRQ_TIMER:
    if(cpuid() == 0){
801066e7:	e8 95 d7 ff ff       	call   80103e81 <cpuid>
801066ec:	85 c0                	test   %eax,%eax
801066ee:	75 3d                	jne    8010672d <trap+0xb0>
      acquire(&tickslock);
801066f0:	83 ec 0c             	sub    $0xc,%esp
801066f3:	68 80 9a 11 80       	push   $0x80119a80
801066f8:	e8 4b e7 ff ff       	call   80104e48 <acquire>
801066fd:	83 c4 10             	add    $0x10,%esp
      ticks++;
80106700:	a1 b4 9a 11 80       	mov    0x80119ab4,%eax
80106705:	83 c0 01             	add    $0x1,%eax
80106708:	a3 b4 9a 11 80       	mov    %eax,0x80119ab4
      wakeup(&ticks);
8010670d:	83 ec 0c             	sub    $0xc,%esp
80106710:	68 b4 9a 11 80       	push   $0x80119ab4
80106715:	e8 fa e3 ff ff       	call   80104b14 <wakeup>
8010671a:	83 c4 10             	add    $0x10,%esp
      release(&tickslock);
8010671d:	83 ec 0c             	sub    $0xc,%esp
80106720:	68 80 9a 11 80       	push   $0x80119a80
80106725:	e8 8c e7 ff ff       	call   80104eb6 <release>
8010672a:	83 c4 10             	add    $0x10,%esp
    }
    lapiceoi();
8010672d:	e8 ce c8 ff ff       	call   80103000 <lapiceoi>
    break;
80106732:	e9 20 01 00 00       	jmp    80106857 <trap+0x1da>
  case T_IRQ0 + IRQ_IDE:
    ideintr();
80106737:	e8 1a c1 ff ff       	call   80102856 <ideintr>
    lapiceoi();
8010673c:	e8 bf c8 ff ff       	call   80103000 <lapiceoi>
    break;
80106741:	e9 11 01 00 00       	jmp    80106857 <trap+0x1da>
  case T_IRQ0 + IRQ_IDE+1:
    // Bochs generates spurious IDE1 interrupts.
    break;
  case T_IRQ0 + IRQ_KBD:
    kbdintr();
80106746:	e8 fa c6 ff ff       	call   80102e45 <kbdintr>
    lapiceoi();
8010674b:	e8 b0 c8 ff ff       	call   80103000 <lapiceoi>
    break;
80106750:	e9 02 01 00 00       	jmp    80106857 <trap+0x1da>
  case T_IRQ0 + IRQ_COM1:
    uartintr();
80106755:	e8 53 03 00 00       	call   80106aad <uartintr>
    lapiceoi();
8010675a:	e8 a1 c8 ff ff       	call   80103000 <lapiceoi>
    break;
8010675f:	e9 f3 00 00 00       	jmp    80106857 <trap+0x1da>
  case T_IRQ0 + 0xB:
    i8254_intr();
80106764:	e8 7b 2b 00 00       	call   801092e4 <i8254_intr>
    lapiceoi();
80106769:	e8 92 c8 ff ff       	call   80103000 <lapiceoi>
    break;
8010676e:	e9 e4 00 00 00       	jmp    80106857 <trap+0x1da>
  case T_IRQ0 + IRQ_SPURIOUS:
    cprintf("cpu%d: spurious interrupt at %x:%x\n",
80106773:	8b 45 08             	mov    0x8(%ebp),%eax
80106776:	8b 70 38             	mov    0x38(%eax),%esi
            cpuid(), tf->cs, tf->eip);
80106779:	8b 45 08             	mov    0x8(%ebp),%eax
8010677c:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
    cprintf("cpu%d: spurious interrupt at %x:%x\n",
80106780:	0f b7 d8             	movzwl %ax,%ebx
80106783:	e8 f9 d6 ff ff       	call   80103e81 <cpuid>
80106788:	56                   	push   %esi
80106789:	53                   	push   %ebx
8010678a:	50                   	push   %eax
8010678b:	68 e8 aa 10 80       	push   $0x8010aae8
80106790:	e8 5f 9c ff ff       	call   801003f4 <cprintf>
80106795:	83 c4 10             	add    $0x10,%esp
    lapiceoi();
80106798:	e8 63 c8 ff ff       	call   80103000 <lapiceoi>
    break;
8010679d:	e9 b5 00 00 00       	jmp    80106857 <trap+0x1da>

  //PAGEBREAK: 13
  default:
    if(myproc() == 0 || (tf->cs&3) == 0){
801067a2:	e8 6d d7 ff ff       	call   80103f14 <myproc>
801067a7:	85 c0                	test   %eax,%eax
801067a9:	74 11                	je     801067bc <trap+0x13f>
801067ab:	8b 45 08             	mov    0x8(%ebp),%eax
801067ae:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
801067b2:	0f b7 c0             	movzwl %ax,%eax
801067b5:	83 e0 03             	and    $0x3,%eax
801067b8:	85 c0                	test   %eax,%eax
801067ba:	75 39                	jne    801067f5 <trap+0x178>
      // In kernel, it must be our mistake.
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
801067bc:	e8 1d fd ff ff       	call   801064de <rcr2>
801067c1:	89 c3                	mov    %eax,%ebx
801067c3:	8b 45 08             	mov    0x8(%ebp),%eax
801067c6:	8b 70 38             	mov    0x38(%eax),%esi
801067c9:	e8 b3 d6 ff ff       	call   80103e81 <cpuid>
801067ce:	8b 55 08             	mov    0x8(%ebp),%edx
801067d1:	8b 52 30             	mov    0x30(%edx),%edx
801067d4:	83 ec 0c             	sub    $0xc,%esp
801067d7:	53                   	push   %ebx
801067d8:	56                   	push   %esi
801067d9:	50                   	push   %eax
801067da:	52                   	push   %edx
801067db:	68 0c ab 10 80       	push   $0x8010ab0c
801067e0:	e8 0f 9c ff ff       	call   801003f4 <cprintf>
801067e5:	83 c4 20             	add    $0x20,%esp
              tf->trapno, cpuid(), tf->eip, rcr2());
      panic("trap");
801067e8:	83 ec 0c             	sub    $0xc,%esp
801067eb:	68 3e ab 10 80       	push   $0x8010ab3e
801067f0:	e8 b4 9d ff ff       	call   801005a9 <panic>
    }
    // In user space, assume process misbehaved.
    cprintf("pid %d %s: trap %d err %d on cpu %d "
801067f5:	e8 e4 fc ff ff       	call   801064de <rcr2>
801067fa:	89 c6                	mov    %eax,%esi
801067fc:	8b 45 08             	mov    0x8(%ebp),%eax
801067ff:	8b 40 38             	mov    0x38(%eax),%eax
80106802:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80106805:	e8 77 d6 ff ff       	call   80103e81 <cpuid>
8010680a:	89 c3                	mov    %eax,%ebx
8010680c:	8b 45 08             	mov    0x8(%ebp),%eax
8010680f:	8b 48 34             	mov    0x34(%eax),%ecx
80106812:	89 4d e0             	mov    %ecx,-0x20(%ebp)
80106815:	8b 45 08             	mov    0x8(%ebp),%eax
80106818:	8b 78 30             	mov    0x30(%eax),%edi
            "eip 0x%x addr 0x%x--kill proc\n",
            myproc()->pid, myproc()->name, tf->trapno,
8010681b:	e8 f4 d6 ff ff       	call   80103f14 <myproc>
80106820:	8d 50 6c             	lea    0x6c(%eax),%edx
80106823:	89 55 dc             	mov    %edx,-0x24(%ebp)
80106826:	e8 e9 d6 ff ff       	call   80103f14 <myproc>
    cprintf("pid %d %s: trap %d err %d on cpu %d "
8010682b:	8b 40 10             	mov    0x10(%eax),%eax
8010682e:	56                   	push   %esi
8010682f:	ff 75 e4             	push   -0x1c(%ebp)
80106832:	53                   	push   %ebx
80106833:	ff 75 e0             	push   -0x20(%ebp)
80106836:	57                   	push   %edi
80106837:	ff 75 dc             	push   -0x24(%ebp)
8010683a:	50                   	push   %eax
8010683b:	68 44 ab 10 80       	push   $0x8010ab44
80106840:	e8 af 9b ff ff       	call   801003f4 <cprintf>
80106845:	83 c4 20             	add    $0x20,%esp
            tf->err, cpuid(), tf->eip, rcr2());
    myproc()->killed = 1;
80106848:	e8 c7 d6 ff ff       	call   80103f14 <myproc>
8010684d:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
80106854:	eb 01                	jmp    80106857 <trap+0x1da>
    break;
80106856:	90                   	nop
  }

  // Force process exit if it has been killed and is in user space.
  // (If it is still executing in the kernel, let it keep running
  // until it gets to the regular system call return.)
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80106857:	e8 b8 d6 ff ff       	call   80103f14 <myproc>
8010685c:	85 c0                	test   %eax,%eax
8010685e:	74 23                	je     80106883 <trap+0x206>
80106860:	e8 af d6 ff ff       	call   80103f14 <myproc>
80106865:	8b 40 24             	mov    0x24(%eax),%eax
80106868:	85 c0                	test   %eax,%eax
8010686a:	74 17                	je     80106883 <trap+0x206>
8010686c:	8b 45 08             	mov    0x8(%ebp),%eax
8010686f:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
80106873:	0f b7 c0             	movzwl %ax,%eax
80106876:	83 e0 03             	and    $0x3,%eax
80106879:	83 f8 03             	cmp    $0x3,%eax
8010687c:	75 05                	jne    80106883 <trap+0x206>
    exit();
8010687e:	e8 09 db ff ff       	call   8010438c <exit>

  // Force process to give up CPU on clock tick.
  // If interrupts were on while locks held, would need to check nlock.
  if(myproc() && myproc()->state == RUNNING &&
80106883:	e8 8c d6 ff ff       	call   80103f14 <myproc>
80106888:	85 c0                	test   %eax,%eax
8010688a:	74 1d                	je     801068a9 <trap+0x22c>
8010688c:	e8 83 d6 ff ff       	call   80103f14 <myproc>
80106891:	8b 40 0c             	mov    0xc(%eax),%eax
80106894:	83 f8 04             	cmp    $0x4,%eax
80106897:	75 10                	jne    801068a9 <trap+0x22c>
     tf->trapno == T_IRQ0+IRQ_TIMER)
80106899:	8b 45 08             	mov    0x8(%ebp),%eax
8010689c:	8b 40 30             	mov    0x30(%eax),%eax
  if(myproc() && myproc()->state == RUNNING &&
8010689f:	83 f8 20             	cmp    $0x20,%eax
801068a2:	75 05                	jne    801068a9 <trap+0x22c>
    yield();
801068a4:	e8 04 e1 ff ff       	call   801049ad <yield>

  // Check if the process has been killed since we yielded
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
801068a9:	e8 66 d6 ff ff       	call   80103f14 <myproc>
801068ae:	85 c0                	test   %eax,%eax
801068b0:	74 26                	je     801068d8 <trap+0x25b>
801068b2:	e8 5d d6 ff ff       	call   80103f14 <myproc>
801068b7:	8b 40 24             	mov    0x24(%eax),%eax
801068ba:	85 c0                	test   %eax,%eax
801068bc:	74 1a                	je     801068d8 <trap+0x25b>
801068be:	8b 45 08             	mov    0x8(%ebp),%eax
801068c1:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
801068c5:	0f b7 c0             	movzwl %ax,%eax
801068c8:	83 e0 03             	and    $0x3,%eax
801068cb:	83 f8 03             	cmp    $0x3,%eax
801068ce:	75 08                	jne    801068d8 <trap+0x25b>
    exit();
801068d0:	e8 b7 da ff ff       	call   8010438c <exit>
801068d5:	eb 01                	jmp    801068d8 <trap+0x25b>
    return;
801068d7:	90                   	nop
}
801068d8:	8d 65 f4             	lea    -0xc(%ebp),%esp
801068db:	5b                   	pop    %ebx
801068dc:	5e                   	pop    %esi
801068dd:	5f                   	pop    %edi
801068de:	5d                   	pop    %ebp
801068df:	c3                   	ret    

801068e0 <inb>:
{
801068e0:	55                   	push   %ebp
801068e1:	89 e5                	mov    %esp,%ebp
801068e3:	83 ec 14             	sub    $0x14,%esp
801068e6:	8b 45 08             	mov    0x8(%ebp),%eax
801068e9:	66 89 45 ec          	mov    %ax,-0x14(%ebp)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801068ed:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
801068f1:	89 c2                	mov    %eax,%edx
801068f3:	ec                   	in     (%dx),%al
801068f4:	88 45 ff             	mov    %al,-0x1(%ebp)
  return data;
801068f7:	0f b6 45 ff          	movzbl -0x1(%ebp),%eax
}
801068fb:	c9                   	leave  
801068fc:	c3                   	ret    

801068fd <outb>:
{
801068fd:	55                   	push   %ebp
801068fe:	89 e5                	mov    %esp,%ebp
80106900:	83 ec 08             	sub    $0x8,%esp
80106903:	8b 45 08             	mov    0x8(%ebp),%eax
80106906:	8b 55 0c             	mov    0xc(%ebp),%edx
80106909:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
8010690d:	89 d0                	mov    %edx,%eax
8010690f:	88 45 f8             	mov    %al,-0x8(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80106912:	0f b6 45 f8          	movzbl -0x8(%ebp),%eax
80106916:	0f b7 55 fc          	movzwl -0x4(%ebp),%edx
8010691a:	ee                   	out    %al,(%dx)
}
8010691b:	90                   	nop
8010691c:	c9                   	leave  
8010691d:	c3                   	ret    

8010691e <uartinit>:

static int uart;    // is there a uart?

void
uartinit(void)
{
8010691e:	55                   	push   %ebp
8010691f:	89 e5                	mov    %esp,%ebp
80106921:	83 ec 18             	sub    $0x18,%esp
  char *p;

  // Turn off the FIFO
  outb(COM1+2, 0);
80106924:	6a 00                	push   $0x0
80106926:	68 fa 03 00 00       	push   $0x3fa
8010692b:	e8 cd ff ff ff       	call   801068fd <outb>
80106930:	83 c4 08             	add    $0x8,%esp

  // 9600 baud, 8 data bits, 1 stop bit, parity off.
  outb(COM1+3, 0x80);    // Unlock divisor
80106933:	68 80 00 00 00       	push   $0x80
80106938:	68 fb 03 00 00       	push   $0x3fb
8010693d:	e8 bb ff ff ff       	call   801068fd <outb>
80106942:	83 c4 08             	add    $0x8,%esp
  outb(COM1+0, 115200/9600);
80106945:	6a 0c                	push   $0xc
80106947:	68 f8 03 00 00       	push   $0x3f8
8010694c:	e8 ac ff ff ff       	call   801068fd <outb>
80106951:	83 c4 08             	add    $0x8,%esp
  outb(COM1+1, 0);
80106954:	6a 00                	push   $0x0
80106956:	68 f9 03 00 00       	push   $0x3f9
8010695b:	e8 9d ff ff ff       	call   801068fd <outb>
80106960:	83 c4 08             	add    $0x8,%esp
  outb(COM1+3, 0x03);    // Lock divisor, 8 data bits.
80106963:	6a 03                	push   $0x3
80106965:	68 fb 03 00 00       	push   $0x3fb
8010696a:	e8 8e ff ff ff       	call   801068fd <outb>
8010696f:	83 c4 08             	add    $0x8,%esp
  outb(COM1+4, 0);
80106972:	6a 00                	push   $0x0
80106974:	68 fc 03 00 00       	push   $0x3fc
80106979:	e8 7f ff ff ff       	call   801068fd <outb>
8010697e:	83 c4 08             	add    $0x8,%esp
  outb(COM1+1, 0x01);    // Enable receive interrupts.
80106981:	6a 01                	push   $0x1
80106983:	68 f9 03 00 00       	push   $0x3f9
80106988:	e8 70 ff ff ff       	call   801068fd <outb>
8010698d:	83 c4 08             	add    $0x8,%esp

  // If status is 0xFF, no serial port.
  if(inb(COM1+5) == 0xFF)
80106990:	68 fd 03 00 00       	push   $0x3fd
80106995:	e8 46 ff ff ff       	call   801068e0 <inb>
8010699a:	83 c4 04             	add    $0x4,%esp
8010699d:	3c ff                	cmp    $0xff,%al
8010699f:	74 61                	je     80106a02 <uartinit+0xe4>
    return;
  uart = 1;
801069a1:	c7 05 b8 9a 11 80 01 	movl   $0x1,0x80119ab8
801069a8:	00 00 00 

  // Acknowledge pre-existing interrupt conditions;
  // enable interrupts.
  inb(COM1+2);
801069ab:	68 fa 03 00 00       	push   $0x3fa
801069b0:	e8 2b ff ff ff       	call   801068e0 <inb>
801069b5:	83 c4 04             	add    $0x4,%esp
  inb(COM1+0);
801069b8:	68 f8 03 00 00       	push   $0x3f8
801069bd:	e8 1e ff ff ff       	call   801068e0 <inb>
801069c2:	83 c4 04             	add    $0x4,%esp
  ioapicenable(IRQ_COM1, 0);
801069c5:	83 ec 08             	sub    $0x8,%esp
801069c8:	6a 00                	push   $0x0
801069ca:	6a 04                	push   $0x4
801069cc:	e8 41 c1 ff ff       	call   80102b12 <ioapicenable>
801069d1:	83 c4 10             	add    $0x10,%esp

  // Announce that we're here.
  for(p="xv6...\n"; *p; p++)
801069d4:	c7 45 f4 08 ac 10 80 	movl   $0x8010ac08,-0xc(%ebp)
801069db:	eb 19                	jmp    801069f6 <uartinit+0xd8>
    uartputc(*p);
801069dd:	8b 45 f4             	mov    -0xc(%ebp),%eax
801069e0:	0f b6 00             	movzbl (%eax),%eax
801069e3:	0f be c0             	movsbl %al,%eax
801069e6:	83 ec 0c             	sub    $0xc,%esp
801069e9:	50                   	push   %eax
801069ea:	e8 16 00 00 00       	call   80106a05 <uartputc>
801069ef:	83 c4 10             	add    $0x10,%esp
  for(p="xv6...\n"; *p; p++)
801069f2:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
801069f6:	8b 45 f4             	mov    -0xc(%ebp),%eax
801069f9:	0f b6 00             	movzbl (%eax),%eax
801069fc:	84 c0                	test   %al,%al
801069fe:	75 dd                	jne    801069dd <uartinit+0xbf>
80106a00:	eb 01                	jmp    80106a03 <uartinit+0xe5>
    return;
80106a02:	90                   	nop
}
80106a03:	c9                   	leave  
80106a04:	c3                   	ret    

80106a05 <uartputc>:

void
uartputc(int c)
{
80106a05:	55                   	push   %ebp
80106a06:	89 e5                	mov    %esp,%ebp
80106a08:	83 ec 18             	sub    $0x18,%esp
  int i;

  if(!uart)
80106a0b:	a1 b8 9a 11 80       	mov    0x80119ab8,%eax
80106a10:	85 c0                	test   %eax,%eax
80106a12:	74 53                	je     80106a67 <uartputc+0x62>
    return;
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
80106a14:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80106a1b:	eb 11                	jmp    80106a2e <uartputc+0x29>
    microdelay(10);
80106a1d:	83 ec 0c             	sub    $0xc,%esp
80106a20:	6a 0a                	push   $0xa
80106a22:	e8 f4 c5 ff ff       	call   8010301b <microdelay>
80106a27:	83 c4 10             	add    $0x10,%esp
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
80106a2a:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80106a2e:	83 7d f4 7f          	cmpl   $0x7f,-0xc(%ebp)
80106a32:	7f 1a                	jg     80106a4e <uartputc+0x49>
80106a34:	83 ec 0c             	sub    $0xc,%esp
80106a37:	68 fd 03 00 00       	push   $0x3fd
80106a3c:	e8 9f fe ff ff       	call   801068e0 <inb>
80106a41:	83 c4 10             	add    $0x10,%esp
80106a44:	0f b6 c0             	movzbl %al,%eax
80106a47:	83 e0 20             	and    $0x20,%eax
80106a4a:	85 c0                	test   %eax,%eax
80106a4c:	74 cf                	je     80106a1d <uartputc+0x18>
  outb(COM1+0, c);
80106a4e:	8b 45 08             	mov    0x8(%ebp),%eax
80106a51:	0f b6 c0             	movzbl %al,%eax
80106a54:	83 ec 08             	sub    $0x8,%esp
80106a57:	50                   	push   %eax
80106a58:	68 f8 03 00 00       	push   $0x3f8
80106a5d:	e8 9b fe ff ff       	call   801068fd <outb>
80106a62:	83 c4 10             	add    $0x10,%esp
80106a65:	eb 01                	jmp    80106a68 <uartputc+0x63>
    return;
80106a67:	90                   	nop
}
80106a68:	c9                   	leave  
80106a69:	c3                   	ret    

80106a6a <uartgetc>:

static int
uartgetc(void)
{
80106a6a:	55                   	push   %ebp
80106a6b:	89 e5                	mov    %esp,%ebp
  if(!uart)
80106a6d:	a1 b8 9a 11 80       	mov    0x80119ab8,%eax
80106a72:	85 c0                	test   %eax,%eax
80106a74:	75 07                	jne    80106a7d <uartgetc+0x13>
    return -1;
80106a76:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106a7b:	eb 2e                	jmp    80106aab <uartgetc+0x41>
  if(!(inb(COM1+5) & 0x01))
80106a7d:	68 fd 03 00 00       	push   $0x3fd
80106a82:	e8 59 fe ff ff       	call   801068e0 <inb>
80106a87:	83 c4 04             	add    $0x4,%esp
80106a8a:	0f b6 c0             	movzbl %al,%eax
80106a8d:	83 e0 01             	and    $0x1,%eax
80106a90:	85 c0                	test   %eax,%eax
80106a92:	75 07                	jne    80106a9b <uartgetc+0x31>
    return -1;
80106a94:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106a99:	eb 10                	jmp    80106aab <uartgetc+0x41>
  return inb(COM1+0);
80106a9b:	68 f8 03 00 00       	push   $0x3f8
80106aa0:	e8 3b fe ff ff       	call   801068e0 <inb>
80106aa5:	83 c4 04             	add    $0x4,%esp
80106aa8:	0f b6 c0             	movzbl %al,%eax
}
80106aab:	c9                   	leave  
80106aac:	c3                   	ret    

80106aad <uartintr>:

void
uartintr(void)
{
80106aad:	55                   	push   %ebp
80106aae:	89 e5                	mov    %esp,%ebp
80106ab0:	83 ec 08             	sub    $0x8,%esp
  consoleintr(uartgetc);
80106ab3:	83 ec 0c             	sub    $0xc,%esp
80106ab6:	68 6a 6a 10 80       	push   $0x80106a6a
80106abb:	e8 16 9d ff ff       	call   801007d6 <consoleintr>
80106ac0:	83 c4 10             	add    $0x10,%esp
}
80106ac3:	90                   	nop
80106ac4:	c9                   	leave  
80106ac5:	c3                   	ret    

80106ac6 <vector0>:
80106ac6:	6a 00                	push   $0x0
80106ac8:	6a 00                	push   $0x0
80106aca:	e9 c2 f9 ff ff       	jmp    80106491 <alltraps>

80106acf <vector1>:
80106acf:	6a 00                	push   $0x0
80106ad1:	6a 01                	push   $0x1
80106ad3:	e9 b9 f9 ff ff       	jmp    80106491 <alltraps>

80106ad8 <vector2>:
80106ad8:	6a 00                	push   $0x0
80106ada:	6a 02                	push   $0x2
80106adc:	e9 b0 f9 ff ff       	jmp    80106491 <alltraps>

80106ae1 <vector3>:
80106ae1:	6a 00                	push   $0x0
80106ae3:	6a 03                	push   $0x3
80106ae5:	e9 a7 f9 ff ff       	jmp    80106491 <alltraps>

80106aea <vector4>:
80106aea:	6a 00                	push   $0x0
80106aec:	6a 04                	push   $0x4
80106aee:	e9 9e f9 ff ff       	jmp    80106491 <alltraps>

80106af3 <vector5>:
80106af3:	6a 00                	push   $0x0
80106af5:	6a 05                	push   $0x5
80106af7:	e9 95 f9 ff ff       	jmp    80106491 <alltraps>

80106afc <vector6>:
80106afc:	6a 00                	push   $0x0
80106afe:	6a 06                	push   $0x6
80106b00:	e9 8c f9 ff ff       	jmp    80106491 <alltraps>

80106b05 <vector7>:
80106b05:	6a 00                	push   $0x0
80106b07:	6a 07                	push   $0x7
80106b09:	e9 83 f9 ff ff       	jmp    80106491 <alltraps>

80106b0e <vector8>:
80106b0e:	6a 08                	push   $0x8
80106b10:	e9 7c f9 ff ff       	jmp    80106491 <alltraps>

80106b15 <vector9>:
80106b15:	6a 00                	push   $0x0
80106b17:	6a 09                	push   $0x9
80106b19:	e9 73 f9 ff ff       	jmp    80106491 <alltraps>

80106b1e <vector10>:
80106b1e:	6a 0a                	push   $0xa
80106b20:	e9 6c f9 ff ff       	jmp    80106491 <alltraps>

80106b25 <vector11>:
80106b25:	6a 0b                	push   $0xb
80106b27:	e9 65 f9 ff ff       	jmp    80106491 <alltraps>

80106b2c <vector12>:
80106b2c:	6a 0c                	push   $0xc
80106b2e:	e9 5e f9 ff ff       	jmp    80106491 <alltraps>

80106b33 <vector13>:
80106b33:	6a 0d                	push   $0xd
80106b35:	e9 57 f9 ff ff       	jmp    80106491 <alltraps>

80106b3a <vector14>:
80106b3a:	6a 0e                	push   $0xe
80106b3c:	e9 50 f9 ff ff       	jmp    80106491 <alltraps>

80106b41 <vector15>:
80106b41:	6a 00                	push   $0x0
80106b43:	6a 0f                	push   $0xf
80106b45:	e9 47 f9 ff ff       	jmp    80106491 <alltraps>

80106b4a <vector16>:
80106b4a:	6a 00                	push   $0x0
80106b4c:	6a 10                	push   $0x10
80106b4e:	e9 3e f9 ff ff       	jmp    80106491 <alltraps>

80106b53 <vector17>:
80106b53:	6a 11                	push   $0x11
80106b55:	e9 37 f9 ff ff       	jmp    80106491 <alltraps>

80106b5a <vector18>:
80106b5a:	6a 00                	push   $0x0
80106b5c:	6a 12                	push   $0x12
80106b5e:	e9 2e f9 ff ff       	jmp    80106491 <alltraps>

80106b63 <vector19>:
80106b63:	6a 00                	push   $0x0
80106b65:	6a 13                	push   $0x13
80106b67:	e9 25 f9 ff ff       	jmp    80106491 <alltraps>

80106b6c <vector20>:
80106b6c:	6a 00                	push   $0x0
80106b6e:	6a 14                	push   $0x14
80106b70:	e9 1c f9 ff ff       	jmp    80106491 <alltraps>

80106b75 <vector21>:
80106b75:	6a 00                	push   $0x0
80106b77:	6a 15                	push   $0x15
80106b79:	e9 13 f9 ff ff       	jmp    80106491 <alltraps>

80106b7e <vector22>:
80106b7e:	6a 00                	push   $0x0
80106b80:	6a 16                	push   $0x16
80106b82:	e9 0a f9 ff ff       	jmp    80106491 <alltraps>

80106b87 <vector23>:
80106b87:	6a 00                	push   $0x0
80106b89:	6a 17                	push   $0x17
80106b8b:	e9 01 f9 ff ff       	jmp    80106491 <alltraps>

80106b90 <vector24>:
80106b90:	6a 00                	push   $0x0
80106b92:	6a 18                	push   $0x18
80106b94:	e9 f8 f8 ff ff       	jmp    80106491 <alltraps>

80106b99 <vector25>:
80106b99:	6a 00                	push   $0x0
80106b9b:	6a 19                	push   $0x19
80106b9d:	e9 ef f8 ff ff       	jmp    80106491 <alltraps>

80106ba2 <vector26>:
80106ba2:	6a 00                	push   $0x0
80106ba4:	6a 1a                	push   $0x1a
80106ba6:	e9 e6 f8 ff ff       	jmp    80106491 <alltraps>

80106bab <vector27>:
80106bab:	6a 00                	push   $0x0
80106bad:	6a 1b                	push   $0x1b
80106baf:	e9 dd f8 ff ff       	jmp    80106491 <alltraps>

80106bb4 <vector28>:
80106bb4:	6a 00                	push   $0x0
80106bb6:	6a 1c                	push   $0x1c
80106bb8:	e9 d4 f8 ff ff       	jmp    80106491 <alltraps>

80106bbd <vector29>:
80106bbd:	6a 00                	push   $0x0
80106bbf:	6a 1d                	push   $0x1d
80106bc1:	e9 cb f8 ff ff       	jmp    80106491 <alltraps>

80106bc6 <vector30>:
80106bc6:	6a 00                	push   $0x0
80106bc8:	6a 1e                	push   $0x1e
80106bca:	e9 c2 f8 ff ff       	jmp    80106491 <alltraps>

80106bcf <vector31>:
80106bcf:	6a 00                	push   $0x0
80106bd1:	6a 1f                	push   $0x1f
80106bd3:	e9 b9 f8 ff ff       	jmp    80106491 <alltraps>

80106bd8 <vector32>:
80106bd8:	6a 00                	push   $0x0
80106bda:	6a 20                	push   $0x20
80106bdc:	e9 b0 f8 ff ff       	jmp    80106491 <alltraps>

80106be1 <vector33>:
80106be1:	6a 00                	push   $0x0
80106be3:	6a 21                	push   $0x21
80106be5:	e9 a7 f8 ff ff       	jmp    80106491 <alltraps>

80106bea <vector34>:
80106bea:	6a 00                	push   $0x0
80106bec:	6a 22                	push   $0x22
80106bee:	e9 9e f8 ff ff       	jmp    80106491 <alltraps>

80106bf3 <vector35>:
80106bf3:	6a 00                	push   $0x0
80106bf5:	6a 23                	push   $0x23
80106bf7:	e9 95 f8 ff ff       	jmp    80106491 <alltraps>

80106bfc <vector36>:
80106bfc:	6a 00                	push   $0x0
80106bfe:	6a 24                	push   $0x24
80106c00:	e9 8c f8 ff ff       	jmp    80106491 <alltraps>

80106c05 <vector37>:
80106c05:	6a 00                	push   $0x0
80106c07:	6a 25                	push   $0x25
80106c09:	e9 83 f8 ff ff       	jmp    80106491 <alltraps>

80106c0e <vector38>:
80106c0e:	6a 00                	push   $0x0
80106c10:	6a 26                	push   $0x26
80106c12:	e9 7a f8 ff ff       	jmp    80106491 <alltraps>

80106c17 <vector39>:
80106c17:	6a 00                	push   $0x0
80106c19:	6a 27                	push   $0x27
80106c1b:	e9 71 f8 ff ff       	jmp    80106491 <alltraps>

80106c20 <vector40>:
80106c20:	6a 00                	push   $0x0
80106c22:	6a 28                	push   $0x28
80106c24:	e9 68 f8 ff ff       	jmp    80106491 <alltraps>

80106c29 <vector41>:
80106c29:	6a 00                	push   $0x0
80106c2b:	6a 29                	push   $0x29
80106c2d:	e9 5f f8 ff ff       	jmp    80106491 <alltraps>

80106c32 <vector42>:
80106c32:	6a 00                	push   $0x0
80106c34:	6a 2a                	push   $0x2a
80106c36:	e9 56 f8 ff ff       	jmp    80106491 <alltraps>

80106c3b <vector43>:
80106c3b:	6a 00                	push   $0x0
80106c3d:	6a 2b                	push   $0x2b
80106c3f:	e9 4d f8 ff ff       	jmp    80106491 <alltraps>

80106c44 <vector44>:
80106c44:	6a 00                	push   $0x0
80106c46:	6a 2c                	push   $0x2c
80106c48:	e9 44 f8 ff ff       	jmp    80106491 <alltraps>

80106c4d <vector45>:
80106c4d:	6a 00                	push   $0x0
80106c4f:	6a 2d                	push   $0x2d
80106c51:	e9 3b f8 ff ff       	jmp    80106491 <alltraps>

80106c56 <vector46>:
80106c56:	6a 00                	push   $0x0
80106c58:	6a 2e                	push   $0x2e
80106c5a:	e9 32 f8 ff ff       	jmp    80106491 <alltraps>

80106c5f <vector47>:
80106c5f:	6a 00                	push   $0x0
80106c61:	6a 2f                	push   $0x2f
80106c63:	e9 29 f8 ff ff       	jmp    80106491 <alltraps>

80106c68 <vector48>:
80106c68:	6a 00                	push   $0x0
80106c6a:	6a 30                	push   $0x30
80106c6c:	e9 20 f8 ff ff       	jmp    80106491 <alltraps>

80106c71 <vector49>:
80106c71:	6a 00                	push   $0x0
80106c73:	6a 31                	push   $0x31
80106c75:	e9 17 f8 ff ff       	jmp    80106491 <alltraps>

80106c7a <vector50>:
80106c7a:	6a 00                	push   $0x0
80106c7c:	6a 32                	push   $0x32
80106c7e:	e9 0e f8 ff ff       	jmp    80106491 <alltraps>

80106c83 <vector51>:
80106c83:	6a 00                	push   $0x0
80106c85:	6a 33                	push   $0x33
80106c87:	e9 05 f8 ff ff       	jmp    80106491 <alltraps>

80106c8c <vector52>:
80106c8c:	6a 00                	push   $0x0
80106c8e:	6a 34                	push   $0x34
80106c90:	e9 fc f7 ff ff       	jmp    80106491 <alltraps>

80106c95 <vector53>:
80106c95:	6a 00                	push   $0x0
80106c97:	6a 35                	push   $0x35
80106c99:	e9 f3 f7 ff ff       	jmp    80106491 <alltraps>

80106c9e <vector54>:
80106c9e:	6a 00                	push   $0x0
80106ca0:	6a 36                	push   $0x36
80106ca2:	e9 ea f7 ff ff       	jmp    80106491 <alltraps>

80106ca7 <vector55>:
80106ca7:	6a 00                	push   $0x0
80106ca9:	6a 37                	push   $0x37
80106cab:	e9 e1 f7 ff ff       	jmp    80106491 <alltraps>

80106cb0 <vector56>:
80106cb0:	6a 00                	push   $0x0
80106cb2:	6a 38                	push   $0x38
80106cb4:	e9 d8 f7 ff ff       	jmp    80106491 <alltraps>

80106cb9 <vector57>:
80106cb9:	6a 00                	push   $0x0
80106cbb:	6a 39                	push   $0x39
80106cbd:	e9 cf f7 ff ff       	jmp    80106491 <alltraps>

80106cc2 <vector58>:
80106cc2:	6a 00                	push   $0x0
80106cc4:	6a 3a                	push   $0x3a
80106cc6:	e9 c6 f7 ff ff       	jmp    80106491 <alltraps>

80106ccb <vector59>:
80106ccb:	6a 00                	push   $0x0
80106ccd:	6a 3b                	push   $0x3b
80106ccf:	e9 bd f7 ff ff       	jmp    80106491 <alltraps>

80106cd4 <vector60>:
80106cd4:	6a 00                	push   $0x0
80106cd6:	6a 3c                	push   $0x3c
80106cd8:	e9 b4 f7 ff ff       	jmp    80106491 <alltraps>

80106cdd <vector61>:
80106cdd:	6a 00                	push   $0x0
80106cdf:	6a 3d                	push   $0x3d
80106ce1:	e9 ab f7 ff ff       	jmp    80106491 <alltraps>

80106ce6 <vector62>:
80106ce6:	6a 00                	push   $0x0
80106ce8:	6a 3e                	push   $0x3e
80106cea:	e9 a2 f7 ff ff       	jmp    80106491 <alltraps>

80106cef <vector63>:
80106cef:	6a 00                	push   $0x0
80106cf1:	6a 3f                	push   $0x3f
80106cf3:	e9 99 f7 ff ff       	jmp    80106491 <alltraps>

80106cf8 <vector64>:
80106cf8:	6a 00                	push   $0x0
80106cfa:	6a 40                	push   $0x40
80106cfc:	e9 90 f7 ff ff       	jmp    80106491 <alltraps>

80106d01 <vector65>:
80106d01:	6a 00                	push   $0x0
80106d03:	6a 41                	push   $0x41
80106d05:	e9 87 f7 ff ff       	jmp    80106491 <alltraps>

80106d0a <vector66>:
80106d0a:	6a 00                	push   $0x0
80106d0c:	6a 42                	push   $0x42
80106d0e:	e9 7e f7 ff ff       	jmp    80106491 <alltraps>

80106d13 <vector67>:
80106d13:	6a 00                	push   $0x0
80106d15:	6a 43                	push   $0x43
80106d17:	e9 75 f7 ff ff       	jmp    80106491 <alltraps>

80106d1c <vector68>:
80106d1c:	6a 00                	push   $0x0
80106d1e:	6a 44                	push   $0x44
80106d20:	e9 6c f7 ff ff       	jmp    80106491 <alltraps>

80106d25 <vector69>:
80106d25:	6a 00                	push   $0x0
80106d27:	6a 45                	push   $0x45
80106d29:	e9 63 f7 ff ff       	jmp    80106491 <alltraps>

80106d2e <vector70>:
80106d2e:	6a 00                	push   $0x0
80106d30:	6a 46                	push   $0x46
80106d32:	e9 5a f7 ff ff       	jmp    80106491 <alltraps>

80106d37 <vector71>:
80106d37:	6a 00                	push   $0x0
80106d39:	6a 47                	push   $0x47
80106d3b:	e9 51 f7 ff ff       	jmp    80106491 <alltraps>

80106d40 <vector72>:
80106d40:	6a 00                	push   $0x0
80106d42:	6a 48                	push   $0x48
80106d44:	e9 48 f7 ff ff       	jmp    80106491 <alltraps>

80106d49 <vector73>:
80106d49:	6a 00                	push   $0x0
80106d4b:	6a 49                	push   $0x49
80106d4d:	e9 3f f7 ff ff       	jmp    80106491 <alltraps>

80106d52 <vector74>:
80106d52:	6a 00                	push   $0x0
80106d54:	6a 4a                	push   $0x4a
80106d56:	e9 36 f7 ff ff       	jmp    80106491 <alltraps>

80106d5b <vector75>:
80106d5b:	6a 00                	push   $0x0
80106d5d:	6a 4b                	push   $0x4b
80106d5f:	e9 2d f7 ff ff       	jmp    80106491 <alltraps>

80106d64 <vector76>:
80106d64:	6a 00                	push   $0x0
80106d66:	6a 4c                	push   $0x4c
80106d68:	e9 24 f7 ff ff       	jmp    80106491 <alltraps>

80106d6d <vector77>:
80106d6d:	6a 00                	push   $0x0
80106d6f:	6a 4d                	push   $0x4d
80106d71:	e9 1b f7 ff ff       	jmp    80106491 <alltraps>

80106d76 <vector78>:
80106d76:	6a 00                	push   $0x0
80106d78:	6a 4e                	push   $0x4e
80106d7a:	e9 12 f7 ff ff       	jmp    80106491 <alltraps>

80106d7f <vector79>:
80106d7f:	6a 00                	push   $0x0
80106d81:	6a 4f                	push   $0x4f
80106d83:	e9 09 f7 ff ff       	jmp    80106491 <alltraps>

80106d88 <vector80>:
80106d88:	6a 00                	push   $0x0
80106d8a:	6a 50                	push   $0x50
80106d8c:	e9 00 f7 ff ff       	jmp    80106491 <alltraps>

80106d91 <vector81>:
80106d91:	6a 00                	push   $0x0
80106d93:	6a 51                	push   $0x51
80106d95:	e9 f7 f6 ff ff       	jmp    80106491 <alltraps>

80106d9a <vector82>:
80106d9a:	6a 00                	push   $0x0
80106d9c:	6a 52                	push   $0x52
80106d9e:	e9 ee f6 ff ff       	jmp    80106491 <alltraps>

80106da3 <vector83>:
80106da3:	6a 00                	push   $0x0
80106da5:	6a 53                	push   $0x53
80106da7:	e9 e5 f6 ff ff       	jmp    80106491 <alltraps>

80106dac <vector84>:
80106dac:	6a 00                	push   $0x0
80106dae:	6a 54                	push   $0x54
80106db0:	e9 dc f6 ff ff       	jmp    80106491 <alltraps>

80106db5 <vector85>:
80106db5:	6a 00                	push   $0x0
80106db7:	6a 55                	push   $0x55
80106db9:	e9 d3 f6 ff ff       	jmp    80106491 <alltraps>

80106dbe <vector86>:
80106dbe:	6a 00                	push   $0x0
80106dc0:	6a 56                	push   $0x56
80106dc2:	e9 ca f6 ff ff       	jmp    80106491 <alltraps>

80106dc7 <vector87>:
80106dc7:	6a 00                	push   $0x0
80106dc9:	6a 57                	push   $0x57
80106dcb:	e9 c1 f6 ff ff       	jmp    80106491 <alltraps>

80106dd0 <vector88>:
80106dd0:	6a 00                	push   $0x0
80106dd2:	6a 58                	push   $0x58
80106dd4:	e9 b8 f6 ff ff       	jmp    80106491 <alltraps>

80106dd9 <vector89>:
80106dd9:	6a 00                	push   $0x0
80106ddb:	6a 59                	push   $0x59
80106ddd:	e9 af f6 ff ff       	jmp    80106491 <alltraps>

80106de2 <vector90>:
80106de2:	6a 00                	push   $0x0
80106de4:	6a 5a                	push   $0x5a
80106de6:	e9 a6 f6 ff ff       	jmp    80106491 <alltraps>

80106deb <vector91>:
80106deb:	6a 00                	push   $0x0
80106ded:	6a 5b                	push   $0x5b
80106def:	e9 9d f6 ff ff       	jmp    80106491 <alltraps>

80106df4 <vector92>:
80106df4:	6a 00                	push   $0x0
80106df6:	6a 5c                	push   $0x5c
80106df8:	e9 94 f6 ff ff       	jmp    80106491 <alltraps>

80106dfd <vector93>:
80106dfd:	6a 00                	push   $0x0
80106dff:	6a 5d                	push   $0x5d
80106e01:	e9 8b f6 ff ff       	jmp    80106491 <alltraps>

80106e06 <vector94>:
80106e06:	6a 00                	push   $0x0
80106e08:	6a 5e                	push   $0x5e
80106e0a:	e9 82 f6 ff ff       	jmp    80106491 <alltraps>

80106e0f <vector95>:
80106e0f:	6a 00                	push   $0x0
80106e11:	6a 5f                	push   $0x5f
80106e13:	e9 79 f6 ff ff       	jmp    80106491 <alltraps>

80106e18 <vector96>:
80106e18:	6a 00                	push   $0x0
80106e1a:	6a 60                	push   $0x60
80106e1c:	e9 70 f6 ff ff       	jmp    80106491 <alltraps>

80106e21 <vector97>:
80106e21:	6a 00                	push   $0x0
80106e23:	6a 61                	push   $0x61
80106e25:	e9 67 f6 ff ff       	jmp    80106491 <alltraps>

80106e2a <vector98>:
80106e2a:	6a 00                	push   $0x0
80106e2c:	6a 62                	push   $0x62
80106e2e:	e9 5e f6 ff ff       	jmp    80106491 <alltraps>

80106e33 <vector99>:
80106e33:	6a 00                	push   $0x0
80106e35:	6a 63                	push   $0x63
80106e37:	e9 55 f6 ff ff       	jmp    80106491 <alltraps>

80106e3c <vector100>:
80106e3c:	6a 00                	push   $0x0
80106e3e:	6a 64                	push   $0x64
80106e40:	e9 4c f6 ff ff       	jmp    80106491 <alltraps>

80106e45 <vector101>:
80106e45:	6a 00                	push   $0x0
80106e47:	6a 65                	push   $0x65
80106e49:	e9 43 f6 ff ff       	jmp    80106491 <alltraps>

80106e4e <vector102>:
80106e4e:	6a 00                	push   $0x0
80106e50:	6a 66                	push   $0x66
80106e52:	e9 3a f6 ff ff       	jmp    80106491 <alltraps>

80106e57 <vector103>:
80106e57:	6a 00                	push   $0x0
80106e59:	6a 67                	push   $0x67
80106e5b:	e9 31 f6 ff ff       	jmp    80106491 <alltraps>

80106e60 <vector104>:
80106e60:	6a 00                	push   $0x0
80106e62:	6a 68                	push   $0x68
80106e64:	e9 28 f6 ff ff       	jmp    80106491 <alltraps>

80106e69 <vector105>:
80106e69:	6a 00                	push   $0x0
80106e6b:	6a 69                	push   $0x69
80106e6d:	e9 1f f6 ff ff       	jmp    80106491 <alltraps>

80106e72 <vector106>:
80106e72:	6a 00                	push   $0x0
80106e74:	6a 6a                	push   $0x6a
80106e76:	e9 16 f6 ff ff       	jmp    80106491 <alltraps>

80106e7b <vector107>:
80106e7b:	6a 00                	push   $0x0
80106e7d:	6a 6b                	push   $0x6b
80106e7f:	e9 0d f6 ff ff       	jmp    80106491 <alltraps>

80106e84 <vector108>:
80106e84:	6a 00                	push   $0x0
80106e86:	6a 6c                	push   $0x6c
80106e88:	e9 04 f6 ff ff       	jmp    80106491 <alltraps>

80106e8d <vector109>:
80106e8d:	6a 00                	push   $0x0
80106e8f:	6a 6d                	push   $0x6d
80106e91:	e9 fb f5 ff ff       	jmp    80106491 <alltraps>

80106e96 <vector110>:
80106e96:	6a 00                	push   $0x0
80106e98:	6a 6e                	push   $0x6e
80106e9a:	e9 f2 f5 ff ff       	jmp    80106491 <alltraps>

80106e9f <vector111>:
80106e9f:	6a 00                	push   $0x0
80106ea1:	6a 6f                	push   $0x6f
80106ea3:	e9 e9 f5 ff ff       	jmp    80106491 <alltraps>

80106ea8 <vector112>:
80106ea8:	6a 00                	push   $0x0
80106eaa:	6a 70                	push   $0x70
80106eac:	e9 e0 f5 ff ff       	jmp    80106491 <alltraps>

80106eb1 <vector113>:
80106eb1:	6a 00                	push   $0x0
80106eb3:	6a 71                	push   $0x71
80106eb5:	e9 d7 f5 ff ff       	jmp    80106491 <alltraps>

80106eba <vector114>:
80106eba:	6a 00                	push   $0x0
80106ebc:	6a 72                	push   $0x72
80106ebe:	e9 ce f5 ff ff       	jmp    80106491 <alltraps>

80106ec3 <vector115>:
80106ec3:	6a 00                	push   $0x0
80106ec5:	6a 73                	push   $0x73
80106ec7:	e9 c5 f5 ff ff       	jmp    80106491 <alltraps>

80106ecc <vector116>:
80106ecc:	6a 00                	push   $0x0
80106ece:	6a 74                	push   $0x74
80106ed0:	e9 bc f5 ff ff       	jmp    80106491 <alltraps>

80106ed5 <vector117>:
80106ed5:	6a 00                	push   $0x0
80106ed7:	6a 75                	push   $0x75
80106ed9:	e9 b3 f5 ff ff       	jmp    80106491 <alltraps>

80106ede <vector118>:
80106ede:	6a 00                	push   $0x0
80106ee0:	6a 76                	push   $0x76
80106ee2:	e9 aa f5 ff ff       	jmp    80106491 <alltraps>

80106ee7 <vector119>:
80106ee7:	6a 00                	push   $0x0
80106ee9:	6a 77                	push   $0x77
80106eeb:	e9 a1 f5 ff ff       	jmp    80106491 <alltraps>

80106ef0 <vector120>:
80106ef0:	6a 00                	push   $0x0
80106ef2:	6a 78                	push   $0x78
80106ef4:	e9 98 f5 ff ff       	jmp    80106491 <alltraps>

80106ef9 <vector121>:
80106ef9:	6a 00                	push   $0x0
80106efb:	6a 79                	push   $0x79
80106efd:	e9 8f f5 ff ff       	jmp    80106491 <alltraps>

80106f02 <vector122>:
80106f02:	6a 00                	push   $0x0
80106f04:	6a 7a                	push   $0x7a
80106f06:	e9 86 f5 ff ff       	jmp    80106491 <alltraps>

80106f0b <vector123>:
80106f0b:	6a 00                	push   $0x0
80106f0d:	6a 7b                	push   $0x7b
80106f0f:	e9 7d f5 ff ff       	jmp    80106491 <alltraps>

80106f14 <vector124>:
80106f14:	6a 00                	push   $0x0
80106f16:	6a 7c                	push   $0x7c
80106f18:	e9 74 f5 ff ff       	jmp    80106491 <alltraps>

80106f1d <vector125>:
80106f1d:	6a 00                	push   $0x0
80106f1f:	6a 7d                	push   $0x7d
80106f21:	e9 6b f5 ff ff       	jmp    80106491 <alltraps>

80106f26 <vector126>:
80106f26:	6a 00                	push   $0x0
80106f28:	6a 7e                	push   $0x7e
80106f2a:	e9 62 f5 ff ff       	jmp    80106491 <alltraps>

80106f2f <vector127>:
80106f2f:	6a 00                	push   $0x0
80106f31:	6a 7f                	push   $0x7f
80106f33:	e9 59 f5 ff ff       	jmp    80106491 <alltraps>

80106f38 <vector128>:
80106f38:	6a 00                	push   $0x0
80106f3a:	68 80 00 00 00       	push   $0x80
80106f3f:	e9 4d f5 ff ff       	jmp    80106491 <alltraps>

80106f44 <vector129>:
80106f44:	6a 00                	push   $0x0
80106f46:	68 81 00 00 00       	push   $0x81
80106f4b:	e9 41 f5 ff ff       	jmp    80106491 <alltraps>

80106f50 <vector130>:
80106f50:	6a 00                	push   $0x0
80106f52:	68 82 00 00 00       	push   $0x82
80106f57:	e9 35 f5 ff ff       	jmp    80106491 <alltraps>

80106f5c <vector131>:
80106f5c:	6a 00                	push   $0x0
80106f5e:	68 83 00 00 00       	push   $0x83
80106f63:	e9 29 f5 ff ff       	jmp    80106491 <alltraps>

80106f68 <vector132>:
80106f68:	6a 00                	push   $0x0
80106f6a:	68 84 00 00 00       	push   $0x84
80106f6f:	e9 1d f5 ff ff       	jmp    80106491 <alltraps>

80106f74 <vector133>:
80106f74:	6a 00                	push   $0x0
80106f76:	68 85 00 00 00       	push   $0x85
80106f7b:	e9 11 f5 ff ff       	jmp    80106491 <alltraps>

80106f80 <vector134>:
80106f80:	6a 00                	push   $0x0
80106f82:	68 86 00 00 00       	push   $0x86
80106f87:	e9 05 f5 ff ff       	jmp    80106491 <alltraps>

80106f8c <vector135>:
80106f8c:	6a 00                	push   $0x0
80106f8e:	68 87 00 00 00       	push   $0x87
80106f93:	e9 f9 f4 ff ff       	jmp    80106491 <alltraps>

80106f98 <vector136>:
80106f98:	6a 00                	push   $0x0
80106f9a:	68 88 00 00 00       	push   $0x88
80106f9f:	e9 ed f4 ff ff       	jmp    80106491 <alltraps>

80106fa4 <vector137>:
80106fa4:	6a 00                	push   $0x0
80106fa6:	68 89 00 00 00       	push   $0x89
80106fab:	e9 e1 f4 ff ff       	jmp    80106491 <alltraps>

80106fb0 <vector138>:
80106fb0:	6a 00                	push   $0x0
80106fb2:	68 8a 00 00 00       	push   $0x8a
80106fb7:	e9 d5 f4 ff ff       	jmp    80106491 <alltraps>

80106fbc <vector139>:
80106fbc:	6a 00                	push   $0x0
80106fbe:	68 8b 00 00 00       	push   $0x8b
80106fc3:	e9 c9 f4 ff ff       	jmp    80106491 <alltraps>

80106fc8 <vector140>:
80106fc8:	6a 00                	push   $0x0
80106fca:	68 8c 00 00 00       	push   $0x8c
80106fcf:	e9 bd f4 ff ff       	jmp    80106491 <alltraps>

80106fd4 <vector141>:
80106fd4:	6a 00                	push   $0x0
80106fd6:	68 8d 00 00 00       	push   $0x8d
80106fdb:	e9 b1 f4 ff ff       	jmp    80106491 <alltraps>

80106fe0 <vector142>:
80106fe0:	6a 00                	push   $0x0
80106fe2:	68 8e 00 00 00       	push   $0x8e
80106fe7:	e9 a5 f4 ff ff       	jmp    80106491 <alltraps>

80106fec <vector143>:
80106fec:	6a 00                	push   $0x0
80106fee:	68 8f 00 00 00       	push   $0x8f
80106ff3:	e9 99 f4 ff ff       	jmp    80106491 <alltraps>

80106ff8 <vector144>:
80106ff8:	6a 00                	push   $0x0
80106ffa:	68 90 00 00 00       	push   $0x90
80106fff:	e9 8d f4 ff ff       	jmp    80106491 <alltraps>

80107004 <vector145>:
80107004:	6a 00                	push   $0x0
80107006:	68 91 00 00 00       	push   $0x91
8010700b:	e9 81 f4 ff ff       	jmp    80106491 <alltraps>

80107010 <vector146>:
80107010:	6a 00                	push   $0x0
80107012:	68 92 00 00 00       	push   $0x92
80107017:	e9 75 f4 ff ff       	jmp    80106491 <alltraps>

8010701c <vector147>:
8010701c:	6a 00                	push   $0x0
8010701e:	68 93 00 00 00       	push   $0x93
80107023:	e9 69 f4 ff ff       	jmp    80106491 <alltraps>

80107028 <vector148>:
80107028:	6a 00                	push   $0x0
8010702a:	68 94 00 00 00       	push   $0x94
8010702f:	e9 5d f4 ff ff       	jmp    80106491 <alltraps>

80107034 <vector149>:
80107034:	6a 00                	push   $0x0
80107036:	68 95 00 00 00       	push   $0x95
8010703b:	e9 51 f4 ff ff       	jmp    80106491 <alltraps>

80107040 <vector150>:
80107040:	6a 00                	push   $0x0
80107042:	68 96 00 00 00       	push   $0x96
80107047:	e9 45 f4 ff ff       	jmp    80106491 <alltraps>

8010704c <vector151>:
8010704c:	6a 00                	push   $0x0
8010704e:	68 97 00 00 00       	push   $0x97
80107053:	e9 39 f4 ff ff       	jmp    80106491 <alltraps>

80107058 <vector152>:
80107058:	6a 00                	push   $0x0
8010705a:	68 98 00 00 00       	push   $0x98
8010705f:	e9 2d f4 ff ff       	jmp    80106491 <alltraps>

80107064 <vector153>:
80107064:	6a 00                	push   $0x0
80107066:	68 99 00 00 00       	push   $0x99
8010706b:	e9 21 f4 ff ff       	jmp    80106491 <alltraps>

80107070 <vector154>:
80107070:	6a 00                	push   $0x0
80107072:	68 9a 00 00 00       	push   $0x9a
80107077:	e9 15 f4 ff ff       	jmp    80106491 <alltraps>

8010707c <vector155>:
8010707c:	6a 00                	push   $0x0
8010707e:	68 9b 00 00 00       	push   $0x9b
80107083:	e9 09 f4 ff ff       	jmp    80106491 <alltraps>

80107088 <vector156>:
80107088:	6a 00                	push   $0x0
8010708a:	68 9c 00 00 00       	push   $0x9c
8010708f:	e9 fd f3 ff ff       	jmp    80106491 <alltraps>

80107094 <vector157>:
80107094:	6a 00                	push   $0x0
80107096:	68 9d 00 00 00       	push   $0x9d
8010709b:	e9 f1 f3 ff ff       	jmp    80106491 <alltraps>

801070a0 <vector158>:
801070a0:	6a 00                	push   $0x0
801070a2:	68 9e 00 00 00       	push   $0x9e
801070a7:	e9 e5 f3 ff ff       	jmp    80106491 <alltraps>

801070ac <vector159>:
801070ac:	6a 00                	push   $0x0
801070ae:	68 9f 00 00 00       	push   $0x9f
801070b3:	e9 d9 f3 ff ff       	jmp    80106491 <alltraps>

801070b8 <vector160>:
801070b8:	6a 00                	push   $0x0
801070ba:	68 a0 00 00 00       	push   $0xa0
801070bf:	e9 cd f3 ff ff       	jmp    80106491 <alltraps>

801070c4 <vector161>:
801070c4:	6a 00                	push   $0x0
801070c6:	68 a1 00 00 00       	push   $0xa1
801070cb:	e9 c1 f3 ff ff       	jmp    80106491 <alltraps>

801070d0 <vector162>:
801070d0:	6a 00                	push   $0x0
801070d2:	68 a2 00 00 00       	push   $0xa2
801070d7:	e9 b5 f3 ff ff       	jmp    80106491 <alltraps>

801070dc <vector163>:
801070dc:	6a 00                	push   $0x0
801070de:	68 a3 00 00 00       	push   $0xa3
801070e3:	e9 a9 f3 ff ff       	jmp    80106491 <alltraps>

801070e8 <vector164>:
801070e8:	6a 00                	push   $0x0
801070ea:	68 a4 00 00 00       	push   $0xa4
801070ef:	e9 9d f3 ff ff       	jmp    80106491 <alltraps>

801070f4 <vector165>:
801070f4:	6a 00                	push   $0x0
801070f6:	68 a5 00 00 00       	push   $0xa5
801070fb:	e9 91 f3 ff ff       	jmp    80106491 <alltraps>

80107100 <vector166>:
80107100:	6a 00                	push   $0x0
80107102:	68 a6 00 00 00       	push   $0xa6
80107107:	e9 85 f3 ff ff       	jmp    80106491 <alltraps>

8010710c <vector167>:
8010710c:	6a 00                	push   $0x0
8010710e:	68 a7 00 00 00       	push   $0xa7
80107113:	e9 79 f3 ff ff       	jmp    80106491 <alltraps>

80107118 <vector168>:
80107118:	6a 00                	push   $0x0
8010711a:	68 a8 00 00 00       	push   $0xa8
8010711f:	e9 6d f3 ff ff       	jmp    80106491 <alltraps>

80107124 <vector169>:
80107124:	6a 00                	push   $0x0
80107126:	68 a9 00 00 00       	push   $0xa9
8010712b:	e9 61 f3 ff ff       	jmp    80106491 <alltraps>

80107130 <vector170>:
80107130:	6a 00                	push   $0x0
80107132:	68 aa 00 00 00       	push   $0xaa
80107137:	e9 55 f3 ff ff       	jmp    80106491 <alltraps>

8010713c <vector171>:
8010713c:	6a 00                	push   $0x0
8010713e:	68 ab 00 00 00       	push   $0xab
80107143:	e9 49 f3 ff ff       	jmp    80106491 <alltraps>

80107148 <vector172>:
80107148:	6a 00                	push   $0x0
8010714a:	68 ac 00 00 00       	push   $0xac
8010714f:	e9 3d f3 ff ff       	jmp    80106491 <alltraps>

80107154 <vector173>:
80107154:	6a 00                	push   $0x0
80107156:	68 ad 00 00 00       	push   $0xad
8010715b:	e9 31 f3 ff ff       	jmp    80106491 <alltraps>

80107160 <vector174>:
80107160:	6a 00                	push   $0x0
80107162:	68 ae 00 00 00       	push   $0xae
80107167:	e9 25 f3 ff ff       	jmp    80106491 <alltraps>

8010716c <vector175>:
8010716c:	6a 00                	push   $0x0
8010716e:	68 af 00 00 00       	push   $0xaf
80107173:	e9 19 f3 ff ff       	jmp    80106491 <alltraps>

80107178 <vector176>:
80107178:	6a 00                	push   $0x0
8010717a:	68 b0 00 00 00       	push   $0xb0
8010717f:	e9 0d f3 ff ff       	jmp    80106491 <alltraps>

80107184 <vector177>:
80107184:	6a 00                	push   $0x0
80107186:	68 b1 00 00 00       	push   $0xb1
8010718b:	e9 01 f3 ff ff       	jmp    80106491 <alltraps>

80107190 <vector178>:
80107190:	6a 00                	push   $0x0
80107192:	68 b2 00 00 00       	push   $0xb2
80107197:	e9 f5 f2 ff ff       	jmp    80106491 <alltraps>

8010719c <vector179>:
8010719c:	6a 00                	push   $0x0
8010719e:	68 b3 00 00 00       	push   $0xb3
801071a3:	e9 e9 f2 ff ff       	jmp    80106491 <alltraps>

801071a8 <vector180>:
801071a8:	6a 00                	push   $0x0
801071aa:	68 b4 00 00 00       	push   $0xb4
801071af:	e9 dd f2 ff ff       	jmp    80106491 <alltraps>

801071b4 <vector181>:
801071b4:	6a 00                	push   $0x0
801071b6:	68 b5 00 00 00       	push   $0xb5
801071bb:	e9 d1 f2 ff ff       	jmp    80106491 <alltraps>

801071c0 <vector182>:
801071c0:	6a 00                	push   $0x0
801071c2:	68 b6 00 00 00       	push   $0xb6
801071c7:	e9 c5 f2 ff ff       	jmp    80106491 <alltraps>

801071cc <vector183>:
801071cc:	6a 00                	push   $0x0
801071ce:	68 b7 00 00 00       	push   $0xb7
801071d3:	e9 b9 f2 ff ff       	jmp    80106491 <alltraps>

801071d8 <vector184>:
801071d8:	6a 00                	push   $0x0
801071da:	68 b8 00 00 00       	push   $0xb8
801071df:	e9 ad f2 ff ff       	jmp    80106491 <alltraps>

801071e4 <vector185>:
801071e4:	6a 00                	push   $0x0
801071e6:	68 b9 00 00 00       	push   $0xb9
801071eb:	e9 a1 f2 ff ff       	jmp    80106491 <alltraps>

801071f0 <vector186>:
801071f0:	6a 00                	push   $0x0
801071f2:	68 ba 00 00 00       	push   $0xba
801071f7:	e9 95 f2 ff ff       	jmp    80106491 <alltraps>

801071fc <vector187>:
801071fc:	6a 00                	push   $0x0
801071fe:	68 bb 00 00 00       	push   $0xbb
80107203:	e9 89 f2 ff ff       	jmp    80106491 <alltraps>

80107208 <vector188>:
80107208:	6a 00                	push   $0x0
8010720a:	68 bc 00 00 00       	push   $0xbc
8010720f:	e9 7d f2 ff ff       	jmp    80106491 <alltraps>

80107214 <vector189>:
80107214:	6a 00                	push   $0x0
80107216:	68 bd 00 00 00       	push   $0xbd
8010721b:	e9 71 f2 ff ff       	jmp    80106491 <alltraps>

80107220 <vector190>:
80107220:	6a 00                	push   $0x0
80107222:	68 be 00 00 00       	push   $0xbe
80107227:	e9 65 f2 ff ff       	jmp    80106491 <alltraps>

8010722c <vector191>:
8010722c:	6a 00                	push   $0x0
8010722e:	68 bf 00 00 00       	push   $0xbf
80107233:	e9 59 f2 ff ff       	jmp    80106491 <alltraps>

80107238 <vector192>:
80107238:	6a 00                	push   $0x0
8010723a:	68 c0 00 00 00       	push   $0xc0
8010723f:	e9 4d f2 ff ff       	jmp    80106491 <alltraps>

80107244 <vector193>:
80107244:	6a 00                	push   $0x0
80107246:	68 c1 00 00 00       	push   $0xc1
8010724b:	e9 41 f2 ff ff       	jmp    80106491 <alltraps>

80107250 <vector194>:
80107250:	6a 00                	push   $0x0
80107252:	68 c2 00 00 00       	push   $0xc2
80107257:	e9 35 f2 ff ff       	jmp    80106491 <alltraps>

8010725c <vector195>:
8010725c:	6a 00                	push   $0x0
8010725e:	68 c3 00 00 00       	push   $0xc3
80107263:	e9 29 f2 ff ff       	jmp    80106491 <alltraps>

80107268 <vector196>:
80107268:	6a 00                	push   $0x0
8010726a:	68 c4 00 00 00       	push   $0xc4
8010726f:	e9 1d f2 ff ff       	jmp    80106491 <alltraps>

80107274 <vector197>:
80107274:	6a 00                	push   $0x0
80107276:	68 c5 00 00 00       	push   $0xc5
8010727b:	e9 11 f2 ff ff       	jmp    80106491 <alltraps>

80107280 <vector198>:
80107280:	6a 00                	push   $0x0
80107282:	68 c6 00 00 00       	push   $0xc6
80107287:	e9 05 f2 ff ff       	jmp    80106491 <alltraps>

8010728c <vector199>:
8010728c:	6a 00                	push   $0x0
8010728e:	68 c7 00 00 00       	push   $0xc7
80107293:	e9 f9 f1 ff ff       	jmp    80106491 <alltraps>

80107298 <vector200>:
80107298:	6a 00                	push   $0x0
8010729a:	68 c8 00 00 00       	push   $0xc8
8010729f:	e9 ed f1 ff ff       	jmp    80106491 <alltraps>

801072a4 <vector201>:
801072a4:	6a 00                	push   $0x0
801072a6:	68 c9 00 00 00       	push   $0xc9
801072ab:	e9 e1 f1 ff ff       	jmp    80106491 <alltraps>

801072b0 <vector202>:
801072b0:	6a 00                	push   $0x0
801072b2:	68 ca 00 00 00       	push   $0xca
801072b7:	e9 d5 f1 ff ff       	jmp    80106491 <alltraps>

801072bc <vector203>:
801072bc:	6a 00                	push   $0x0
801072be:	68 cb 00 00 00       	push   $0xcb
801072c3:	e9 c9 f1 ff ff       	jmp    80106491 <alltraps>

801072c8 <vector204>:
801072c8:	6a 00                	push   $0x0
801072ca:	68 cc 00 00 00       	push   $0xcc
801072cf:	e9 bd f1 ff ff       	jmp    80106491 <alltraps>

801072d4 <vector205>:
801072d4:	6a 00                	push   $0x0
801072d6:	68 cd 00 00 00       	push   $0xcd
801072db:	e9 b1 f1 ff ff       	jmp    80106491 <alltraps>

801072e0 <vector206>:
801072e0:	6a 00                	push   $0x0
801072e2:	68 ce 00 00 00       	push   $0xce
801072e7:	e9 a5 f1 ff ff       	jmp    80106491 <alltraps>

801072ec <vector207>:
801072ec:	6a 00                	push   $0x0
801072ee:	68 cf 00 00 00       	push   $0xcf
801072f3:	e9 99 f1 ff ff       	jmp    80106491 <alltraps>

801072f8 <vector208>:
801072f8:	6a 00                	push   $0x0
801072fa:	68 d0 00 00 00       	push   $0xd0
801072ff:	e9 8d f1 ff ff       	jmp    80106491 <alltraps>

80107304 <vector209>:
80107304:	6a 00                	push   $0x0
80107306:	68 d1 00 00 00       	push   $0xd1
8010730b:	e9 81 f1 ff ff       	jmp    80106491 <alltraps>

80107310 <vector210>:
80107310:	6a 00                	push   $0x0
80107312:	68 d2 00 00 00       	push   $0xd2
80107317:	e9 75 f1 ff ff       	jmp    80106491 <alltraps>

8010731c <vector211>:
8010731c:	6a 00                	push   $0x0
8010731e:	68 d3 00 00 00       	push   $0xd3
80107323:	e9 69 f1 ff ff       	jmp    80106491 <alltraps>

80107328 <vector212>:
80107328:	6a 00                	push   $0x0
8010732a:	68 d4 00 00 00       	push   $0xd4
8010732f:	e9 5d f1 ff ff       	jmp    80106491 <alltraps>

80107334 <vector213>:
80107334:	6a 00                	push   $0x0
80107336:	68 d5 00 00 00       	push   $0xd5
8010733b:	e9 51 f1 ff ff       	jmp    80106491 <alltraps>

80107340 <vector214>:
80107340:	6a 00                	push   $0x0
80107342:	68 d6 00 00 00       	push   $0xd6
80107347:	e9 45 f1 ff ff       	jmp    80106491 <alltraps>

8010734c <vector215>:
8010734c:	6a 00                	push   $0x0
8010734e:	68 d7 00 00 00       	push   $0xd7
80107353:	e9 39 f1 ff ff       	jmp    80106491 <alltraps>

80107358 <vector216>:
80107358:	6a 00                	push   $0x0
8010735a:	68 d8 00 00 00       	push   $0xd8
8010735f:	e9 2d f1 ff ff       	jmp    80106491 <alltraps>

80107364 <vector217>:
80107364:	6a 00                	push   $0x0
80107366:	68 d9 00 00 00       	push   $0xd9
8010736b:	e9 21 f1 ff ff       	jmp    80106491 <alltraps>

80107370 <vector218>:
80107370:	6a 00                	push   $0x0
80107372:	68 da 00 00 00       	push   $0xda
80107377:	e9 15 f1 ff ff       	jmp    80106491 <alltraps>

8010737c <vector219>:
8010737c:	6a 00                	push   $0x0
8010737e:	68 db 00 00 00       	push   $0xdb
80107383:	e9 09 f1 ff ff       	jmp    80106491 <alltraps>

80107388 <vector220>:
80107388:	6a 00                	push   $0x0
8010738a:	68 dc 00 00 00       	push   $0xdc
8010738f:	e9 fd f0 ff ff       	jmp    80106491 <alltraps>

80107394 <vector221>:
80107394:	6a 00                	push   $0x0
80107396:	68 dd 00 00 00       	push   $0xdd
8010739b:	e9 f1 f0 ff ff       	jmp    80106491 <alltraps>

801073a0 <vector222>:
801073a0:	6a 00                	push   $0x0
801073a2:	68 de 00 00 00       	push   $0xde
801073a7:	e9 e5 f0 ff ff       	jmp    80106491 <alltraps>

801073ac <vector223>:
801073ac:	6a 00                	push   $0x0
801073ae:	68 df 00 00 00       	push   $0xdf
801073b3:	e9 d9 f0 ff ff       	jmp    80106491 <alltraps>

801073b8 <vector224>:
801073b8:	6a 00                	push   $0x0
801073ba:	68 e0 00 00 00       	push   $0xe0
801073bf:	e9 cd f0 ff ff       	jmp    80106491 <alltraps>

801073c4 <vector225>:
801073c4:	6a 00                	push   $0x0
801073c6:	68 e1 00 00 00       	push   $0xe1
801073cb:	e9 c1 f0 ff ff       	jmp    80106491 <alltraps>

801073d0 <vector226>:
801073d0:	6a 00                	push   $0x0
801073d2:	68 e2 00 00 00       	push   $0xe2
801073d7:	e9 b5 f0 ff ff       	jmp    80106491 <alltraps>

801073dc <vector227>:
801073dc:	6a 00                	push   $0x0
801073de:	68 e3 00 00 00       	push   $0xe3
801073e3:	e9 a9 f0 ff ff       	jmp    80106491 <alltraps>

801073e8 <vector228>:
801073e8:	6a 00                	push   $0x0
801073ea:	68 e4 00 00 00       	push   $0xe4
801073ef:	e9 9d f0 ff ff       	jmp    80106491 <alltraps>

801073f4 <vector229>:
801073f4:	6a 00                	push   $0x0
801073f6:	68 e5 00 00 00       	push   $0xe5
801073fb:	e9 91 f0 ff ff       	jmp    80106491 <alltraps>

80107400 <vector230>:
80107400:	6a 00                	push   $0x0
80107402:	68 e6 00 00 00       	push   $0xe6
80107407:	e9 85 f0 ff ff       	jmp    80106491 <alltraps>

8010740c <vector231>:
8010740c:	6a 00                	push   $0x0
8010740e:	68 e7 00 00 00       	push   $0xe7
80107413:	e9 79 f0 ff ff       	jmp    80106491 <alltraps>

80107418 <vector232>:
80107418:	6a 00                	push   $0x0
8010741a:	68 e8 00 00 00       	push   $0xe8
8010741f:	e9 6d f0 ff ff       	jmp    80106491 <alltraps>

80107424 <vector233>:
80107424:	6a 00                	push   $0x0
80107426:	68 e9 00 00 00       	push   $0xe9
8010742b:	e9 61 f0 ff ff       	jmp    80106491 <alltraps>

80107430 <vector234>:
80107430:	6a 00                	push   $0x0
80107432:	68 ea 00 00 00       	push   $0xea
80107437:	e9 55 f0 ff ff       	jmp    80106491 <alltraps>

8010743c <vector235>:
8010743c:	6a 00                	push   $0x0
8010743e:	68 eb 00 00 00       	push   $0xeb
80107443:	e9 49 f0 ff ff       	jmp    80106491 <alltraps>

80107448 <vector236>:
80107448:	6a 00                	push   $0x0
8010744a:	68 ec 00 00 00       	push   $0xec
8010744f:	e9 3d f0 ff ff       	jmp    80106491 <alltraps>

80107454 <vector237>:
80107454:	6a 00                	push   $0x0
80107456:	68 ed 00 00 00       	push   $0xed
8010745b:	e9 31 f0 ff ff       	jmp    80106491 <alltraps>

80107460 <vector238>:
80107460:	6a 00                	push   $0x0
80107462:	68 ee 00 00 00       	push   $0xee
80107467:	e9 25 f0 ff ff       	jmp    80106491 <alltraps>

8010746c <vector239>:
8010746c:	6a 00                	push   $0x0
8010746e:	68 ef 00 00 00       	push   $0xef
80107473:	e9 19 f0 ff ff       	jmp    80106491 <alltraps>

80107478 <vector240>:
80107478:	6a 00                	push   $0x0
8010747a:	68 f0 00 00 00       	push   $0xf0
8010747f:	e9 0d f0 ff ff       	jmp    80106491 <alltraps>

80107484 <vector241>:
80107484:	6a 00                	push   $0x0
80107486:	68 f1 00 00 00       	push   $0xf1
8010748b:	e9 01 f0 ff ff       	jmp    80106491 <alltraps>

80107490 <vector242>:
80107490:	6a 00                	push   $0x0
80107492:	68 f2 00 00 00       	push   $0xf2
80107497:	e9 f5 ef ff ff       	jmp    80106491 <alltraps>

8010749c <vector243>:
8010749c:	6a 00                	push   $0x0
8010749e:	68 f3 00 00 00       	push   $0xf3
801074a3:	e9 e9 ef ff ff       	jmp    80106491 <alltraps>

801074a8 <vector244>:
801074a8:	6a 00                	push   $0x0
801074aa:	68 f4 00 00 00       	push   $0xf4
801074af:	e9 dd ef ff ff       	jmp    80106491 <alltraps>

801074b4 <vector245>:
801074b4:	6a 00                	push   $0x0
801074b6:	68 f5 00 00 00       	push   $0xf5
801074bb:	e9 d1 ef ff ff       	jmp    80106491 <alltraps>

801074c0 <vector246>:
801074c0:	6a 00                	push   $0x0
801074c2:	68 f6 00 00 00       	push   $0xf6
801074c7:	e9 c5 ef ff ff       	jmp    80106491 <alltraps>

801074cc <vector247>:
801074cc:	6a 00                	push   $0x0
801074ce:	68 f7 00 00 00       	push   $0xf7
801074d3:	e9 b9 ef ff ff       	jmp    80106491 <alltraps>

801074d8 <vector248>:
801074d8:	6a 00                	push   $0x0
801074da:	68 f8 00 00 00       	push   $0xf8
801074df:	e9 ad ef ff ff       	jmp    80106491 <alltraps>

801074e4 <vector249>:
801074e4:	6a 00                	push   $0x0
801074e6:	68 f9 00 00 00       	push   $0xf9
801074eb:	e9 a1 ef ff ff       	jmp    80106491 <alltraps>

801074f0 <vector250>:
801074f0:	6a 00                	push   $0x0
801074f2:	68 fa 00 00 00       	push   $0xfa
801074f7:	e9 95 ef ff ff       	jmp    80106491 <alltraps>

801074fc <vector251>:
801074fc:	6a 00                	push   $0x0
801074fe:	68 fb 00 00 00       	push   $0xfb
80107503:	e9 89 ef ff ff       	jmp    80106491 <alltraps>

80107508 <vector252>:
80107508:	6a 00                	push   $0x0
8010750a:	68 fc 00 00 00       	push   $0xfc
8010750f:	e9 7d ef ff ff       	jmp    80106491 <alltraps>

80107514 <vector253>:
80107514:	6a 00                	push   $0x0
80107516:	68 fd 00 00 00       	push   $0xfd
8010751b:	e9 71 ef ff ff       	jmp    80106491 <alltraps>

80107520 <vector254>:
80107520:	6a 00                	push   $0x0
80107522:	68 fe 00 00 00       	push   $0xfe
80107527:	e9 65 ef ff ff       	jmp    80106491 <alltraps>

8010752c <vector255>:
8010752c:	6a 00                	push   $0x0
8010752e:	68 ff 00 00 00       	push   $0xff
80107533:	e9 59 ef ff ff       	jmp    80106491 <alltraps>

80107538 <lgdt>:
{
80107538:	55                   	push   %ebp
80107539:	89 e5                	mov    %esp,%ebp
8010753b:	83 ec 10             	sub    $0x10,%esp
  pd[0] = size-1;
8010753e:	8b 45 0c             	mov    0xc(%ebp),%eax
80107541:	83 e8 01             	sub    $0x1,%eax
80107544:	66 89 45 fa          	mov    %ax,-0x6(%ebp)
  pd[1] = (uint)p;
80107548:	8b 45 08             	mov    0x8(%ebp),%eax
8010754b:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  pd[2] = (uint)p >> 16;
8010754f:	8b 45 08             	mov    0x8(%ebp),%eax
80107552:	c1 e8 10             	shr    $0x10,%eax
80107555:	66 89 45 fe          	mov    %ax,-0x2(%ebp)
  asm volatile("lgdt (%0)" : : "r" (pd));
80107559:	8d 45 fa             	lea    -0x6(%ebp),%eax
8010755c:	0f 01 10             	lgdtl  (%eax)
}
8010755f:	90                   	nop
80107560:	c9                   	leave  
80107561:	c3                   	ret    

80107562 <ltr>:
{
80107562:	55                   	push   %ebp
80107563:	89 e5                	mov    %esp,%ebp
80107565:	83 ec 04             	sub    $0x4,%esp
80107568:	8b 45 08             	mov    0x8(%ebp),%eax
8010756b:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  asm volatile("ltr %0" : : "r" (sel));
8010756f:	0f b7 45 fc          	movzwl -0x4(%ebp),%eax
80107573:	0f 00 d8             	ltr    %ax
}
80107576:	90                   	nop
80107577:	c9                   	leave  
80107578:	c3                   	ret    

80107579 <lcr3>:

static inline void
lcr3(uint val)
{
80107579:	55                   	push   %ebp
8010757a:	89 e5                	mov    %esp,%ebp
  asm volatile("movl %0,%%cr3" : : "r" (val));
8010757c:	8b 45 08             	mov    0x8(%ebp),%eax
8010757f:	0f 22 d8             	mov    %eax,%cr3
}
80107582:	90                   	nop
80107583:	5d                   	pop    %ebp
80107584:	c3                   	ret    

80107585 <seginit>:
extern struct gpu gpu;
// Set up CPU's kernel segment descriptors.
// Run once on entry on each CPU.
void
seginit(void)
{
80107585:	55                   	push   %ebp
80107586:	89 e5                	mov    %esp,%ebp
80107588:	83 ec 18             	sub    $0x18,%esp

  // Map "logical" addresses to virtual addresses using identity map.
  // Cannot share a CODE descriptor for both kernel and user
  // because it would have to have DPL_USR, but the CPU forbids
  // an interrupt from CPL=0 to DPL=3.
  c = &cpus[cpuid()];
8010758b:	e8 f1 c8 ff ff       	call   80103e81 <cpuid>
80107590:	69 c0 b0 00 00 00    	imul   $0xb0,%eax,%eax
80107596:	05 c0 9a 11 80       	add    $0x80119ac0,%eax
8010759b:	89 45 f4             	mov    %eax,-0xc(%ebp)

  c->gdt[SEG_KCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, 0);
8010759e:	8b 45 f4             	mov    -0xc(%ebp),%eax
801075a1:	66 c7 40 78 ff ff    	movw   $0xffff,0x78(%eax)
801075a7:	8b 45 f4             	mov    -0xc(%ebp),%eax
801075aa:	66 c7 40 7a 00 00    	movw   $0x0,0x7a(%eax)
801075b0:	8b 45 f4             	mov    -0xc(%ebp),%eax
801075b3:	c6 40 7c 00          	movb   $0x0,0x7c(%eax)
801075b7:	8b 45 f4             	mov    -0xc(%ebp),%eax
801075ba:	0f b6 50 7d          	movzbl 0x7d(%eax),%edx
801075be:	83 e2 f0             	and    $0xfffffff0,%edx
801075c1:	83 ca 0a             	or     $0xa,%edx
801075c4:	88 50 7d             	mov    %dl,0x7d(%eax)
801075c7:	8b 45 f4             	mov    -0xc(%ebp),%eax
801075ca:	0f b6 50 7d          	movzbl 0x7d(%eax),%edx
801075ce:	83 ca 10             	or     $0x10,%edx
801075d1:	88 50 7d             	mov    %dl,0x7d(%eax)
801075d4:	8b 45 f4             	mov    -0xc(%ebp),%eax
801075d7:	0f b6 50 7d          	movzbl 0x7d(%eax),%edx
801075db:	83 e2 9f             	and    $0xffffff9f,%edx
801075de:	88 50 7d             	mov    %dl,0x7d(%eax)
801075e1:	8b 45 f4             	mov    -0xc(%ebp),%eax
801075e4:	0f b6 50 7d          	movzbl 0x7d(%eax),%edx
801075e8:	83 ca 80             	or     $0xffffff80,%edx
801075eb:	88 50 7d             	mov    %dl,0x7d(%eax)
801075ee:	8b 45 f4             	mov    -0xc(%ebp),%eax
801075f1:	0f b6 50 7e          	movzbl 0x7e(%eax),%edx
801075f5:	83 ca 0f             	or     $0xf,%edx
801075f8:	88 50 7e             	mov    %dl,0x7e(%eax)
801075fb:	8b 45 f4             	mov    -0xc(%ebp),%eax
801075fe:	0f b6 50 7e          	movzbl 0x7e(%eax),%edx
80107602:	83 e2 ef             	and    $0xffffffef,%edx
80107605:	88 50 7e             	mov    %dl,0x7e(%eax)
80107608:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010760b:	0f b6 50 7e          	movzbl 0x7e(%eax),%edx
8010760f:	83 e2 df             	and    $0xffffffdf,%edx
80107612:	88 50 7e             	mov    %dl,0x7e(%eax)
80107615:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107618:	0f b6 50 7e          	movzbl 0x7e(%eax),%edx
8010761c:	83 ca 40             	or     $0x40,%edx
8010761f:	88 50 7e             	mov    %dl,0x7e(%eax)
80107622:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107625:	0f b6 50 7e          	movzbl 0x7e(%eax),%edx
80107629:	83 ca 80             	or     $0xffffff80,%edx
8010762c:	88 50 7e             	mov    %dl,0x7e(%eax)
8010762f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107632:	c6 40 7f 00          	movb   $0x0,0x7f(%eax)
  c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
80107636:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107639:	66 c7 80 80 00 00 00 	movw   $0xffff,0x80(%eax)
80107640:	ff ff 
80107642:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107645:	66 c7 80 82 00 00 00 	movw   $0x0,0x82(%eax)
8010764c:	00 00 
8010764e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107651:	c6 80 84 00 00 00 00 	movb   $0x0,0x84(%eax)
80107658:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010765b:	0f b6 90 85 00 00 00 	movzbl 0x85(%eax),%edx
80107662:	83 e2 f0             	and    $0xfffffff0,%edx
80107665:	83 ca 02             	or     $0x2,%edx
80107668:	88 90 85 00 00 00    	mov    %dl,0x85(%eax)
8010766e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107671:	0f b6 90 85 00 00 00 	movzbl 0x85(%eax),%edx
80107678:	83 ca 10             	or     $0x10,%edx
8010767b:	88 90 85 00 00 00    	mov    %dl,0x85(%eax)
80107681:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107684:	0f b6 90 85 00 00 00 	movzbl 0x85(%eax),%edx
8010768b:	83 e2 9f             	and    $0xffffff9f,%edx
8010768e:	88 90 85 00 00 00    	mov    %dl,0x85(%eax)
80107694:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107697:	0f b6 90 85 00 00 00 	movzbl 0x85(%eax),%edx
8010769e:	83 ca 80             	or     $0xffffff80,%edx
801076a1:	88 90 85 00 00 00    	mov    %dl,0x85(%eax)
801076a7:	8b 45 f4             	mov    -0xc(%ebp),%eax
801076aa:	0f b6 90 86 00 00 00 	movzbl 0x86(%eax),%edx
801076b1:	83 ca 0f             	or     $0xf,%edx
801076b4:	88 90 86 00 00 00    	mov    %dl,0x86(%eax)
801076ba:	8b 45 f4             	mov    -0xc(%ebp),%eax
801076bd:	0f b6 90 86 00 00 00 	movzbl 0x86(%eax),%edx
801076c4:	83 e2 ef             	and    $0xffffffef,%edx
801076c7:	88 90 86 00 00 00    	mov    %dl,0x86(%eax)
801076cd:	8b 45 f4             	mov    -0xc(%ebp),%eax
801076d0:	0f b6 90 86 00 00 00 	movzbl 0x86(%eax),%edx
801076d7:	83 e2 df             	and    $0xffffffdf,%edx
801076da:	88 90 86 00 00 00    	mov    %dl,0x86(%eax)
801076e0:	8b 45 f4             	mov    -0xc(%ebp),%eax
801076e3:	0f b6 90 86 00 00 00 	movzbl 0x86(%eax),%edx
801076ea:	83 ca 40             	or     $0x40,%edx
801076ed:	88 90 86 00 00 00    	mov    %dl,0x86(%eax)
801076f3:	8b 45 f4             	mov    -0xc(%ebp),%eax
801076f6:	0f b6 90 86 00 00 00 	movzbl 0x86(%eax),%edx
801076fd:	83 ca 80             	or     $0xffffff80,%edx
80107700:	88 90 86 00 00 00    	mov    %dl,0x86(%eax)
80107706:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107709:	c6 80 87 00 00 00 00 	movb   $0x0,0x87(%eax)
  c->gdt[SEG_UCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, DPL_USER);
80107710:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107713:	66 c7 80 88 00 00 00 	movw   $0xffff,0x88(%eax)
8010771a:	ff ff 
8010771c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010771f:	66 c7 80 8a 00 00 00 	movw   $0x0,0x8a(%eax)
80107726:	00 00 
80107728:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010772b:	c6 80 8c 00 00 00 00 	movb   $0x0,0x8c(%eax)
80107732:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107735:	0f b6 90 8d 00 00 00 	movzbl 0x8d(%eax),%edx
8010773c:	83 e2 f0             	and    $0xfffffff0,%edx
8010773f:	83 ca 0a             	or     $0xa,%edx
80107742:	88 90 8d 00 00 00    	mov    %dl,0x8d(%eax)
80107748:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010774b:	0f b6 90 8d 00 00 00 	movzbl 0x8d(%eax),%edx
80107752:	83 ca 10             	or     $0x10,%edx
80107755:	88 90 8d 00 00 00    	mov    %dl,0x8d(%eax)
8010775b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010775e:	0f b6 90 8d 00 00 00 	movzbl 0x8d(%eax),%edx
80107765:	83 ca 60             	or     $0x60,%edx
80107768:	88 90 8d 00 00 00    	mov    %dl,0x8d(%eax)
8010776e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107771:	0f b6 90 8d 00 00 00 	movzbl 0x8d(%eax),%edx
80107778:	83 ca 80             	or     $0xffffff80,%edx
8010777b:	88 90 8d 00 00 00    	mov    %dl,0x8d(%eax)
80107781:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107784:	0f b6 90 8e 00 00 00 	movzbl 0x8e(%eax),%edx
8010778b:	83 ca 0f             	or     $0xf,%edx
8010778e:	88 90 8e 00 00 00    	mov    %dl,0x8e(%eax)
80107794:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107797:	0f b6 90 8e 00 00 00 	movzbl 0x8e(%eax),%edx
8010779e:	83 e2 ef             	and    $0xffffffef,%edx
801077a1:	88 90 8e 00 00 00    	mov    %dl,0x8e(%eax)
801077a7:	8b 45 f4             	mov    -0xc(%ebp),%eax
801077aa:	0f b6 90 8e 00 00 00 	movzbl 0x8e(%eax),%edx
801077b1:	83 e2 df             	and    $0xffffffdf,%edx
801077b4:	88 90 8e 00 00 00    	mov    %dl,0x8e(%eax)
801077ba:	8b 45 f4             	mov    -0xc(%ebp),%eax
801077bd:	0f b6 90 8e 00 00 00 	movzbl 0x8e(%eax),%edx
801077c4:	83 ca 40             	or     $0x40,%edx
801077c7:	88 90 8e 00 00 00    	mov    %dl,0x8e(%eax)
801077cd:	8b 45 f4             	mov    -0xc(%ebp),%eax
801077d0:	0f b6 90 8e 00 00 00 	movzbl 0x8e(%eax),%edx
801077d7:	83 ca 80             	or     $0xffffff80,%edx
801077da:	88 90 8e 00 00 00    	mov    %dl,0x8e(%eax)
801077e0:	8b 45 f4             	mov    -0xc(%ebp),%eax
801077e3:	c6 80 8f 00 00 00 00 	movb   $0x0,0x8f(%eax)
  c->gdt[SEG_UDATA] = SEG(STA_W, 0, 0xffffffff, DPL_USER);
801077ea:	8b 45 f4             	mov    -0xc(%ebp),%eax
801077ed:	66 c7 80 90 00 00 00 	movw   $0xffff,0x90(%eax)
801077f4:	ff ff 
801077f6:	8b 45 f4             	mov    -0xc(%ebp),%eax
801077f9:	66 c7 80 92 00 00 00 	movw   $0x0,0x92(%eax)
80107800:	00 00 
80107802:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107805:	c6 80 94 00 00 00 00 	movb   $0x0,0x94(%eax)
8010780c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010780f:	0f b6 90 95 00 00 00 	movzbl 0x95(%eax),%edx
80107816:	83 e2 f0             	and    $0xfffffff0,%edx
80107819:	83 ca 02             	or     $0x2,%edx
8010781c:	88 90 95 00 00 00    	mov    %dl,0x95(%eax)
80107822:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107825:	0f b6 90 95 00 00 00 	movzbl 0x95(%eax),%edx
8010782c:	83 ca 10             	or     $0x10,%edx
8010782f:	88 90 95 00 00 00    	mov    %dl,0x95(%eax)
80107835:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107838:	0f b6 90 95 00 00 00 	movzbl 0x95(%eax),%edx
8010783f:	83 ca 60             	or     $0x60,%edx
80107842:	88 90 95 00 00 00    	mov    %dl,0x95(%eax)
80107848:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010784b:	0f b6 90 95 00 00 00 	movzbl 0x95(%eax),%edx
80107852:	83 ca 80             	or     $0xffffff80,%edx
80107855:	88 90 95 00 00 00    	mov    %dl,0x95(%eax)
8010785b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010785e:	0f b6 90 96 00 00 00 	movzbl 0x96(%eax),%edx
80107865:	83 ca 0f             	or     $0xf,%edx
80107868:	88 90 96 00 00 00    	mov    %dl,0x96(%eax)
8010786e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107871:	0f b6 90 96 00 00 00 	movzbl 0x96(%eax),%edx
80107878:	83 e2 ef             	and    $0xffffffef,%edx
8010787b:	88 90 96 00 00 00    	mov    %dl,0x96(%eax)
80107881:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107884:	0f b6 90 96 00 00 00 	movzbl 0x96(%eax),%edx
8010788b:	83 e2 df             	and    $0xffffffdf,%edx
8010788e:	88 90 96 00 00 00    	mov    %dl,0x96(%eax)
80107894:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107897:	0f b6 90 96 00 00 00 	movzbl 0x96(%eax),%edx
8010789e:	83 ca 40             	or     $0x40,%edx
801078a1:	88 90 96 00 00 00    	mov    %dl,0x96(%eax)
801078a7:	8b 45 f4             	mov    -0xc(%ebp),%eax
801078aa:	0f b6 90 96 00 00 00 	movzbl 0x96(%eax),%edx
801078b1:	83 ca 80             	or     $0xffffff80,%edx
801078b4:	88 90 96 00 00 00    	mov    %dl,0x96(%eax)
801078ba:	8b 45 f4             	mov    -0xc(%ebp),%eax
801078bd:	c6 80 97 00 00 00 00 	movb   $0x0,0x97(%eax)
  lgdt(c->gdt, sizeof(c->gdt));
801078c4:	8b 45 f4             	mov    -0xc(%ebp),%eax
801078c7:	83 c0 70             	add    $0x70,%eax
801078ca:	83 ec 08             	sub    $0x8,%esp
801078cd:	6a 30                	push   $0x30
801078cf:	50                   	push   %eax
801078d0:	e8 63 fc ff ff       	call   80107538 <lgdt>
801078d5:	83 c4 10             	add    $0x10,%esp
}
801078d8:	90                   	nop
801078d9:	c9                   	leave  
801078da:	c3                   	ret    

801078db <walkpgdir>:
// Return the address of the PTE in page table pgdir
// that corresponds to virtual address va.  If alloc!=0,
// create any required page table pages.
static pte_t *
walkpgdir(pde_t *pgdir, const void *va, int alloc)
{
801078db:	55                   	push   %ebp
801078dc:	89 e5                	mov    %esp,%ebp
801078de:	83 ec 18             	sub    $0x18,%esp
  pde_t *pde;
  pte_t *pgtab;

  pde = &pgdir[PDX(va)];
801078e1:	8b 45 0c             	mov    0xc(%ebp),%eax
801078e4:	c1 e8 16             	shr    $0x16,%eax
801078e7:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
801078ee:	8b 45 08             	mov    0x8(%ebp),%eax
801078f1:	01 d0                	add    %edx,%eax
801078f3:	89 45 f0             	mov    %eax,-0x10(%ebp)
  if(*pde & PTE_P){
801078f6:	8b 45 f0             	mov    -0x10(%ebp),%eax
801078f9:	8b 00                	mov    (%eax),%eax
801078fb:	83 e0 01             	and    $0x1,%eax
801078fe:	85 c0                	test   %eax,%eax
80107900:	74 14                	je     80107916 <walkpgdir+0x3b>
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
80107902:	8b 45 f0             	mov    -0x10(%ebp),%eax
80107905:	8b 00                	mov    (%eax),%eax
80107907:	25 00 f0 ff ff       	and    $0xfffff000,%eax
8010790c:	05 00 00 00 80       	add    $0x80000000,%eax
80107911:	89 45 f4             	mov    %eax,-0xc(%ebp)
80107914:	eb 42                	jmp    80107958 <walkpgdir+0x7d>
  } else {
    if(!alloc || (pgtab = (pte_t*)kalloc()) == 0)
80107916:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
8010791a:	74 0e                	je     8010792a <walkpgdir+0x4f>
8010791c:	e8 63 b3 ff ff       	call   80102c84 <kalloc>
80107921:	89 45 f4             	mov    %eax,-0xc(%ebp)
80107924:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80107928:	75 07                	jne    80107931 <walkpgdir+0x56>
      return 0;
8010792a:	b8 00 00 00 00       	mov    $0x0,%eax
8010792f:	eb 3e                	jmp    8010796f <walkpgdir+0x94>
    // Make sure all those PTE_P bits are zero.
    memset(pgtab, 0, PGSIZE);
80107931:	83 ec 04             	sub    $0x4,%esp
80107934:	68 00 10 00 00       	push   $0x1000
80107939:	6a 00                	push   $0x0
8010793b:	ff 75 f4             	push   -0xc(%ebp)
8010793e:	e8 7b d7 ff ff       	call   801050be <memset>
80107943:	83 c4 10             	add    $0x10,%esp
    // The permissions here are overly generous, but they can
    // be further restricted by the permissions in the page table
    // entries, if necessary.
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
80107946:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107949:	05 00 00 00 80       	add    $0x80000000,%eax
8010794e:	83 c8 07             	or     $0x7,%eax
80107951:	89 c2                	mov    %eax,%edx
80107953:	8b 45 f0             	mov    -0x10(%ebp),%eax
80107956:	89 10                	mov    %edx,(%eax)
  }
  return &pgtab[PTX(va)];
80107958:	8b 45 0c             	mov    0xc(%ebp),%eax
8010795b:	c1 e8 0c             	shr    $0xc,%eax
8010795e:	25 ff 03 00 00       	and    $0x3ff,%eax
80107963:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
8010796a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010796d:	01 d0                	add    %edx,%eax
}
8010796f:	c9                   	leave  
80107970:	c3                   	ret    

80107971 <mappages>:
// Create PTEs for virtual addresses starting at va that refer to
// physical addresses starting at pa. va and size might not
// be page-aligned.
static int
mappages(pde_t *pgdir, void *va, uint size, uint pa, int perm)
{
80107971:	55                   	push   %ebp
80107972:	89 e5                	mov    %esp,%ebp
80107974:	83 ec 18             	sub    $0x18,%esp
  char *a, *last;
  pte_t *pte;

  a = (char*)PGROUNDDOWN((uint)va);
80107977:	8b 45 0c             	mov    0xc(%ebp),%eax
8010797a:	25 00 f0 ff ff       	and    $0xfffff000,%eax
8010797f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
80107982:	8b 55 0c             	mov    0xc(%ebp),%edx
80107985:	8b 45 10             	mov    0x10(%ebp),%eax
80107988:	01 d0                	add    %edx,%eax
8010798a:	83 e8 01             	sub    $0x1,%eax
8010798d:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80107992:	89 45 f0             	mov    %eax,-0x10(%ebp)
  for(;;){
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
80107995:	83 ec 04             	sub    $0x4,%esp
80107998:	6a 01                	push   $0x1
8010799a:	ff 75 f4             	push   -0xc(%ebp)
8010799d:	ff 75 08             	push   0x8(%ebp)
801079a0:	e8 36 ff ff ff       	call   801078db <walkpgdir>
801079a5:	83 c4 10             	add    $0x10,%esp
801079a8:	89 45 ec             	mov    %eax,-0x14(%ebp)
801079ab:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
801079af:	75 07                	jne    801079b8 <mappages+0x47>
      return -1;
801079b1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801079b6:	eb 47                	jmp    801079ff <mappages+0x8e>
    if(*pte & PTE_P)
801079b8:	8b 45 ec             	mov    -0x14(%ebp),%eax
801079bb:	8b 00                	mov    (%eax),%eax
801079bd:	83 e0 01             	and    $0x1,%eax
801079c0:	85 c0                	test   %eax,%eax
801079c2:	74 0d                	je     801079d1 <mappages+0x60>
      panic("remap");
801079c4:	83 ec 0c             	sub    $0xc,%esp
801079c7:	68 10 ac 10 80       	push   $0x8010ac10
801079cc:	e8 d8 8b ff ff       	call   801005a9 <panic>
    *pte = pa | perm | PTE_P;
801079d1:	8b 45 18             	mov    0x18(%ebp),%eax
801079d4:	0b 45 14             	or     0x14(%ebp),%eax
801079d7:	83 c8 01             	or     $0x1,%eax
801079da:	89 c2                	mov    %eax,%edx
801079dc:	8b 45 ec             	mov    -0x14(%ebp),%eax
801079df:	89 10                	mov    %edx,(%eax)
    if(a == last)
801079e1:	8b 45 f4             	mov    -0xc(%ebp),%eax
801079e4:	3b 45 f0             	cmp    -0x10(%ebp),%eax
801079e7:	74 10                	je     801079f9 <mappages+0x88>
      break;
    a += PGSIZE;
801079e9:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
    pa += PGSIZE;
801079f0:	81 45 14 00 10 00 00 	addl   $0x1000,0x14(%ebp)
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
801079f7:	eb 9c                	jmp    80107995 <mappages+0x24>
      break;
801079f9:	90                   	nop
  }
  return 0;
801079fa:	b8 00 00 00 00       	mov    $0x0,%eax
}
801079ff:	c9                   	leave  
80107a00:	c3                   	ret    

80107a01 <setupkvm>:
};

// Set up kernel part of a page table.
pde_t*
setupkvm(void)
{
80107a01:	55                   	push   %ebp
80107a02:	89 e5                	mov    %esp,%ebp
80107a04:	53                   	push   %ebx
80107a05:	83 ec 24             	sub    $0x24,%esp
  pde_t *pgdir;
  struct kmap *k;
  k = kmap;
80107a08:	c7 45 f4 80 f4 10 80 	movl   $0x8010f480,-0xc(%ebp)
  struct kmap vram = { (void*)(DEVSPACE - gpu.vram_size),gpu.pvram_addr,gpu.pvram_addr+gpu.vram_size, PTE_W};
80107a0f:	8b 15 90 9d 11 80    	mov    0x80119d90,%edx
80107a15:	b8 00 00 00 fe       	mov    $0xfe000000,%eax
80107a1a:	29 d0                	sub    %edx,%eax
80107a1c:	89 45 e0             	mov    %eax,-0x20(%ebp)
80107a1f:	a1 88 9d 11 80       	mov    0x80119d88,%eax
80107a24:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80107a27:	8b 15 88 9d 11 80    	mov    0x80119d88,%edx
80107a2d:	a1 90 9d 11 80       	mov    0x80119d90,%eax
80107a32:	01 d0                	add    %edx,%eax
80107a34:	89 45 e8             	mov    %eax,-0x18(%ebp)
80107a37:	c7 45 ec 02 00 00 00 	movl   $0x2,-0x14(%ebp)
  k[3] = vram;
80107a3e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107a41:	83 c0 30             	add    $0x30,%eax
80107a44:	8b 55 e0             	mov    -0x20(%ebp),%edx
80107a47:	89 10                	mov    %edx,(%eax)
80107a49:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80107a4c:	89 50 04             	mov    %edx,0x4(%eax)
80107a4f:	8b 55 e8             	mov    -0x18(%ebp),%edx
80107a52:	89 50 08             	mov    %edx,0x8(%eax)
80107a55:	8b 55 ec             	mov    -0x14(%ebp),%edx
80107a58:	89 50 0c             	mov    %edx,0xc(%eax)
  if((pgdir = (pde_t*)kalloc()) == 0){
80107a5b:	e8 24 b2 ff ff       	call   80102c84 <kalloc>
80107a60:	89 45 f0             	mov    %eax,-0x10(%ebp)
80107a63:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80107a67:	75 07                	jne    80107a70 <setupkvm+0x6f>
    return 0;
80107a69:	b8 00 00 00 00       	mov    $0x0,%eax
80107a6e:	eb 78                	jmp    80107ae8 <setupkvm+0xe7>
  }
  memset(pgdir, 0, PGSIZE);
80107a70:	83 ec 04             	sub    $0x4,%esp
80107a73:	68 00 10 00 00       	push   $0x1000
80107a78:	6a 00                	push   $0x0
80107a7a:	ff 75 f0             	push   -0x10(%ebp)
80107a7d:	e8 3c d6 ff ff       	call   801050be <memset>
80107a82:	83 c4 10             	add    $0x10,%esp
  if (P2V(PHYSTOP) > (void*)DEVSPACE)
    panic("PHYSTOP too high");
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
80107a85:	c7 45 f4 80 f4 10 80 	movl   $0x8010f480,-0xc(%ebp)
80107a8c:	eb 4e                	jmp    80107adc <setupkvm+0xdb>
    if(mappages(pgdir, k->virt, k->phys_end - k->phys_start,
80107a8e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107a91:	8b 48 0c             	mov    0xc(%eax),%ecx
                (uint)k->phys_start, k->perm) < 0) {
80107a94:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107a97:	8b 50 04             	mov    0x4(%eax),%edx
    if(mappages(pgdir, k->virt, k->phys_end - k->phys_start,
80107a9a:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107a9d:	8b 58 08             	mov    0x8(%eax),%ebx
80107aa0:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107aa3:	8b 40 04             	mov    0x4(%eax),%eax
80107aa6:	29 c3                	sub    %eax,%ebx
80107aa8:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107aab:	8b 00                	mov    (%eax),%eax
80107aad:	83 ec 0c             	sub    $0xc,%esp
80107ab0:	51                   	push   %ecx
80107ab1:	52                   	push   %edx
80107ab2:	53                   	push   %ebx
80107ab3:	50                   	push   %eax
80107ab4:	ff 75 f0             	push   -0x10(%ebp)
80107ab7:	e8 b5 fe ff ff       	call   80107971 <mappages>
80107abc:	83 c4 20             	add    $0x20,%esp
80107abf:	85 c0                	test   %eax,%eax
80107ac1:	79 15                	jns    80107ad8 <setupkvm+0xd7>
      freevm(pgdir);
80107ac3:	83 ec 0c             	sub    $0xc,%esp
80107ac6:	ff 75 f0             	push   -0x10(%ebp)
80107ac9:	e8 f5 04 00 00       	call   80107fc3 <freevm>
80107ace:	83 c4 10             	add    $0x10,%esp
      return 0;
80107ad1:	b8 00 00 00 00       	mov    $0x0,%eax
80107ad6:	eb 10                	jmp    80107ae8 <setupkvm+0xe7>
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
80107ad8:	83 45 f4 10          	addl   $0x10,-0xc(%ebp)
80107adc:	81 7d f4 e0 f4 10 80 	cmpl   $0x8010f4e0,-0xc(%ebp)
80107ae3:	72 a9                	jb     80107a8e <setupkvm+0x8d>
    }
  return pgdir;
80107ae5:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
80107ae8:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80107aeb:	c9                   	leave  
80107aec:	c3                   	ret    

80107aed <kvmalloc>:

// Allocate one page table for the machine for the kernel address
// space for scheduler processes.
void
kvmalloc(void)
{
80107aed:	55                   	push   %ebp
80107aee:	89 e5                	mov    %esp,%ebp
80107af0:	83 ec 08             	sub    $0x8,%esp
  kpgdir = setupkvm();
80107af3:	e8 09 ff ff ff       	call   80107a01 <setupkvm>
80107af8:	a3 bc 9a 11 80       	mov    %eax,0x80119abc
  switchkvm();
80107afd:	e8 03 00 00 00       	call   80107b05 <switchkvm>
}
80107b02:	90                   	nop
80107b03:	c9                   	leave  
80107b04:	c3                   	ret    

80107b05 <switchkvm>:

// Switch h/w page table register to the kernel-only page table,
// for when no process is running.
void
switchkvm(void)
{
80107b05:	55                   	push   %ebp
80107b06:	89 e5                	mov    %esp,%ebp
  lcr3(V2P(kpgdir));   // switch to the kernel page table
80107b08:	a1 bc 9a 11 80       	mov    0x80119abc,%eax
80107b0d:	05 00 00 00 80       	add    $0x80000000,%eax
80107b12:	50                   	push   %eax
80107b13:	e8 61 fa ff ff       	call   80107579 <lcr3>
80107b18:	83 c4 04             	add    $0x4,%esp
}
80107b1b:	90                   	nop
80107b1c:	c9                   	leave  
80107b1d:	c3                   	ret    

80107b1e <switchuvm>:

// Switch TSS and h/w page table to correspond to process p.
void
switchuvm(struct proc *p)
{
80107b1e:	55                   	push   %ebp
80107b1f:	89 e5                	mov    %esp,%ebp
80107b21:	56                   	push   %esi
80107b22:	53                   	push   %ebx
80107b23:	83 ec 10             	sub    $0x10,%esp
  if(p == 0)
80107b26:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
80107b2a:	75 0d                	jne    80107b39 <switchuvm+0x1b>
    panic("switchuvm: no process");
80107b2c:	83 ec 0c             	sub    $0xc,%esp
80107b2f:	68 16 ac 10 80       	push   $0x8010ac16
80107b34:	e8 70 8a ff ff       	call   801005a9 <panic>
  if(p->kstack == 0)
80107b39:	8b 45 08             	mov    0x8(%ebp),%eax
80107b3c:	8b 40 08             	mov    0x8(%eax),%eax
80107b3f:	85 c0                	test   %eax,%eax
80107b41:	75 0d                	jne    80107b50 <switchuvm+0x32>
    panic("switchuvm: no kstack");
80107b43:	83 ec 0c             	sub    $0xc,%esp
80107b46:	68 2c ac 10 80       	push   $0x8010ac2c
80107b4b:	e8 59 8a ff ff       	call   801005a9 <panic>
  if(p->pgdir == 0)
80107b50:	8b 45 08             	mov    0x8(%ebp),%eax
80107b53:	8b 40 04             	mov    0x4(%eax),%eax
80107b56:	85 c0                	test   %eax,%eax
80107b58:	75 0d                	jne    80107b67 <switchuvm+0x49>
    panic("switchuvm: no pgdir");
80107b5a:	83 ec 0c             	sub    $0xc,%esp
80107b5d:	68 41 ac 10 80       	push   $0x8010ac41
80107b62:	e8 42 8a ff ff       	call   801005a9 <panic>

  pushcli();
80107b67:	e8 47 d4 ff ff       	call   80104fb3 <pushcli>
  mycpu()->gdt[SEG_TSS] = SEG16(STS_T32A, &mycpu()->ts,
80107b6c:	e8 2b c3 ff ff       	call   80103e9c <mycpu>
80107b71:	89 c3                	mov    %eax,%ebx
80107b73:	e8 24 c3 ff ff       	call   80103e9c <mycpu>
80107b78:	83 c0 08             	add    $0x8,%eax
80107b7b:	89 c6                	mov    %eax,%esi
80107b7d:	e8 1a c3 ff ff       	call   80103e9c <mycpu>
80107b82:	83 c0 08             	add    $0x8,%eax
80107b85:	c1 e8 10             	shr    $0x10,%eax
80107b88:	88 45 f7             	mov    %al,-0x9(%ebp)
80107b8b:	e8 0c c3 ff ff       	call   80103e9c <mycpu>
80107b90:	83 c0 08             	add    $0x8,%eax
80107b93:	c1 e8 18             	shr    $0x18,%eax
80107b96:	89 c2                	mov    %eax,%edx
80107b98:	66 c7 83 98 00 00 00 	movw   $0x67,0x98(%ebx)
80107b9f:	67 00 
80107ba1:	66 89 b3 9a 00 00 00 	mov    %si,0x9a(%ebx)
80107ba8:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
80107bac:	88 83 9c 00 00 00    	mov    %al,0x9c(%ebx)
80107bb2:	0f b6 83 9d 00 00 00 	movzbl 0x9d(%ebx),%eax
80107bb9:	83 e0 f0             	and    $0xfffffff0,%eax
80107bbc:	83 c8 09             	or     $0x9,%eax
80107bbf:	88 83 9d 00 00 00    	mov    %al,0x9d(%ebx)
80107bc5:	0f b6 83 9d 00 00 00 	movzbl 0x9d(%ebx),%eax
80107bcc:	83 c8 10             	or     $0x10,%eax
80107bcf:	88 83 9d 00 00 00    	mov    %al,0x9d(%ebx)
80107bd5:	0f b6 83 9d 00 00 00 	movzbl 0x9d(%ebx),%eax
80107bdc:	83 e0 9f             	and    $0xffffff9f,%eax
80107bdf:	88 83 9d 00 00 00    	mov    %al,0x9d(%ebx)
80107be5:	0f b6 83 9d 00 00 00 	movzbl 0x9d(%ebx),%eax
80107bec:	83 c8 80             	or     $0xffffff80,%eax
80107bef:	88 83 9d 00 00 00    	mov    %al,0x9d(%ebx)
80107bf5:	0f b6 83 9e 00 00 00 	movzbl 0x9e(%ebx),%eax
80107bfc:	83 e0 f0             	and    $0xfffffff0,%eax
80107bff:	88 83 9e 00 00 00    	mov    %al,0x9e(%ebx)
80107c05:	0f b6 83 9e 00 00 00 	movzbl 0x9e(%ebx),%eax
80107c0c:	83 e0 ef             	and    $0xffffffef,%eax
80107c0f:	88 83 9e 00 00 00    	mov    %al,0x9e(%ebx)
80107c15:	0f b6 83 9e 00 00 00 	movzbl 0x9e(%ebx),%eax
80107c1c:	83 e0 df             	and    $0xffffffdf,%eax
80107c1f:	88 83 9e 00 00 00    	mov    %al,0x9e(%ebx)
80107c25:	0f b6 83 9e 00 00 00 	movzbl 0x9e(%ebx),%eax
80107c2c:	83 c8 40             	or     $0x40,%eax
80107c2f:	88 83 9e 00 00 00    	mov    %al,0x9e(%ebx)
80107c35:	0f b6 83 9e 00 00 00 	movzbl 0x9e(%ebx),%eax
80107c3c:	83 e0 7f             	and    $0x7f,%eax
80107c3f:	88 83 9e 00 00 00    	mov    %al,0x9e(%ebx)
80107c45:	88 93 9f 00 00 00    	mov    %dl,0x9f(%ebx)
                                sizeof(mycpu()->ts)-1, 0);
  mycpu()->gdt[SEG_TSS].s = 0;
80107c4b:	e8 4c c2 ff ff       	call   80103e9c <mycpu>
80107c50:	0f b6 90 9d 00 00 00 	movzbl 0x9d(%eax),%edx
80107c57:	83 e2 ef             	and    $0xffffffef,%edx
80107c5a:	88 90 9d 00 00 00    	mov    %dl,0x9d(%eax)
  mycpu()->ts.ss0 = SEG_KDATA << 3;
80107c60:	e8 37 c2 ff ff       	call   80103e9c <mycpu>
80107c65:	66 c7 40 10 10 00    	movw   $0x10,0x10(%eax)
  mycpu()->ts.esp0 = (uint)p->kstack + KSTACKSIZE;
80107c6b:	8b 45 08             	mov    0x8(%ebp),%eax
80107c6e:	8b 40 08             	mov    0x8(%eax),%eax
80107c71:	89 c3                	mov    %eax,%ebx
80107c73:	e8 24 c2 ff ff       	call   80103e9c <mycpu>
80107c78:	8d 93 00 10 00 00    	lea    0x1000(%ebx),%edx
80107c7e:	89 50 0c             	mov    %edx,0xc(%eax)
  // setting IOPL=0 in eflags *and* iomb beyond the tss segment limit
  // forbids I/O instructions (e.g., inb and outb) from user space
  mycpu()->ts.iomb = (ushort) 0xFFFF;
80107c81:	e8 16 c2 ff ff       	call   80103e9c <mycpu>
80107c86:	66 c7 40 6e ff ff    	movw   $0xffff,0x6e(%eax)
  ltr(SEG_TSS << 3);
80107c8c:	83 ec 0c             	sub    $0xc,%esp
80107c8f:	6a 28                	push   $0x28
80107c91:	e8 cc f8 ff ff       	call   80107562 <ltr>
80107c96:	83 c4 10             	add    $0x10,%esp
  lcr3(V2P(p->pgdir));  // switch to process's address space
80107c99:	8b 45 08             	mov    0x8(%ebp),%eax
80107c9c:	8b 40 04             	mov    0x4(%eax),%eax
80107c9f:	05 00 00 00 80       	add    $0x80000000,%eax
80107ca4:	83 ec 0c             	sub    $0xc,%esp
80107ca7:	50                   	push   %eax
80107ca8:	e8 cc f8 ff ff       	call   80107579 <lcr3>
80107cad:	83 c4 10             	add    $0x10,%esp
  popcli();
80107cb0:	e8 4b d3 ff ff       	call   80105000 <popcli>
}
80107cb5:	90                   	nop
80107cb6:	8d 65 f8             	lea    -0x8(%ebp),%esp
80107cb9:	5b                   	pop    %ebx
80107cba:	5e                   	pop    %esi
80107cbb:	5d                   	pop    %ebp
80107cbc:	c3                   	ret    

80107cbd <inituvm>:

// Load the initcode into address 0 of pgdir.
// sz must be less than a page.
void
inituvm(pde_t *pgdir, char *init, uint sz)
{
80107cbd:	55                   	push   %ebp
80107cbe:	89 e5                	mov    %esp,%ebp
80107cc0:	83 ec 18             	sub    $0x18,%esp
  char *mem;

  if(sz >= PGSIZE)
80107cc3:	81 7d 10 ff 0f 00 00 	cmpl   $0xfff,0x10(%ebp)
80107cca:	76 0d                	jbe    80107cd9 <inituvm+0x1c>
    panic("inituvm: more than a page");
80107ccc:	83 ec 0c             	sub    $0xc,%esp
80107ccf:	68 55 ac 10 80       	push   $0x8010ac55
80107cd4:	e8 d0 88 ff ff       	call   801005a9 <panic>
  mem = kalloc();
80107cd9:	e8 a6 af ff ff       	call   80102c84 <kalloc>
80107cde:	89 45 f4             	mov    %eax,-0xc(%ebp)
  memset(mem, 0, PGSIZE);
80107ce1:	83 ec 04             	sub    $0x4,%esp
80107ce4:	68 00 10 00 00       	push   $0x1000
80107ce9:	6a 00                	push   $0x0
80107ceb:	ff 75 f4             	push   -0xc(%ebp)
80107cee:	e8 cb d3 ff ff       	call   801050be <memset>
80107cf3:	83 c4 10             	add    $0x10,%esp
  mappages(pgdir, 0, PGSIZE, V2P(mem), PTE_W|PTE_U);
80107cf6:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107cf9:	05 00 00 00 80       	add    $0x80000000,%eax
80107cfe:	83 ec 0c             	sub    $0xc,%esp
80107d01:	6a 06                	push   $0x6
80107d03:	50                   	push   %eax
80107d04:	68 00 10 00 00       	push   $0x1000
80107d09:	6a 00                	push   $0x0
80107d0b:	ff 75 08             	push   0x8(%ebp)
80107d0e:	e8 5e fc ff ff       	call   80107971 <mappages>
80107d13:	83 c4 20             	add    $0x20,%esp
  memmove(mem, init, sz);
80107d16:	83 ec 04             	sub    $0x4,%esp
80107d19:	ff 75 10             	push   0x10(%ebp)
80107d1c:	ff 75 0c             	push   0xc(%ebp)
80107d1f:	ff 75 f4             	push   -0xc(%ebp)
80107d22:	e8 56 d4 ff ff       	call   8010517d <memmove>
80107d27:	83 c4 10             	add    $0x10,%esp
}
80107d2a:	90                   	nop
80107d2b:	c9                   	leave  
80107d2c:	c3                   	ret    

80107d2d <loaduvm>:

// Load a program segment into pgdir.  addr must be page-aligned
// and the pages from addr to addr+sz must already be mapped.
int
loaduvm(pde_t *pgdir, char *addr, struct inode *ip, uint offset, uint sz)
{
80107d2d:	55                   	push   %ebp
80107d2e:	89 e5                	mov    %esp,%ebp
80107d30:	83 ec 18             	sub    $0x18,%esp
  uint i, pa, n;
  pte_t *pte;

  if((uint) addr % PGSIZE != 0)
80107d33:	8b 45 0c             	mov    0xc(%ebp),%eax
80107d36:	25 ff 0f 00 00       	and    $0xfff,%eax
80107d3b:	85 c0                	test   %eax,%eax
80107d3d:	74 0d                	je     80107d4c <loaduvm+0x1f>
    panic("loaduvm: addr must be page aligned");
80107d3f:	83 ec 0c             	sub    $0xc,%esp
80107d42:	68 70 ac 10 80       	push   $0x8010ac70
80107d47:	e8 5d 88 ff ff       	call   801005a9 <panic>
  for(i = 0; i < sz; i += PGSIZE){
80107d4c:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80107d53:	e9 8f 00 00 00       	jmp    80107de7 <loaduvm+0xba>
    if((pte = walkpgdir(pgdir, addr+i, 0)) == 0)
80107d58:	8b 55 0c             	mov    0xc(%ebp),%edx
80107d5b:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107d5e:	01 d0                	add    %edx,%eax
80107d60:	83 ec 04             	sub    $0x4,%esp
80107d63:	6a 00                	push   $0x0
80107d65:	50                   	push   %eax
80107d66:	ff 75 08             	push   0x8(%ebp)
80107d69:	e8 6d fb ff ff       	call   801078db <walkpgdir>
80107d6e:	83 c4 10             	add    $0x10,%esp
80107d71:	89 45 ec             	mov    %eax,-0x14(%ebp)
80107d74:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
80107d78:	75 0d                	jne    80107d87 <loaduvm+0x5a>
      panic("loaduvm: address should exist");
80107d7a:	83 ec 0c             	sub    $0xc,%esp
80107d7d:	68 93 ac 10 80       	push   $0x8010ac93
80107d82:	e8 22 88 ff ff       	call   801005a9 <panic>
    pa = PTE_ADDR(*pte);
80107d87:	8b 45 ec             	mov    -0x14(%ebp),%eax
80107d8a:	8b 00                	mov    (%eax),%eax
80107d8c:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80107d91:	89 45 e8             	mov    %eax,-0x18(%ebp)
    if(sz - i < PGSIZE)
80107d94:	8b 45 18             	mov    0x18(%ebp),%eax
80107d97:	2b 45 f4             	sub    -0xc(%ebp),%eax
80107d9a:	3d ff 0f 00 00       	cmp    $0xfff,%eax
80107d9f:	77 0b                	ja     80107dac <loaduvm+0x7f>
      n = sz - i;
80107da1:	8b 45 18             	mov    0x18(%ebp),%eax
80107da4:	2b 45 f4             	sub    -0xc(%ebp),%eax
80107da7:	89 45 f0             	mov    %eax,-0x10(%ebp)
80107daa:	eb 07                	jmp    80107db3 <loaduvm+0x86>
    else
      n = PGSIZE;
80107dac:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
    if(readi(ip, P2V(pa), offset+i, n) != n)
80107db3:	8b 55 14             	mov    0x14(%ebp),%edx
80107db6:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107db9:	01 d0                	add    %edx,%eax
80107dbb:	8b 55 e8             	mov    -0x18(%ebp),%edx
80107dbe:	81 c2 00 00 00 80    	add    $0x80000000,%edx
80107dc4:	ff 75 f0             	push   -0x10(%ebp)
80107dc7:	50                   	push   %eax
80107dc8:	52                   	push   %edx
80107dc9:	ff 75 10             	push   0x10(%ebp)
80107dcc:	e8 05 a1 ff ff       	call   80101ed6 <readi>
80107dd1:	83 c4 10             	add    $0x10,%esp
80107dd4:	39 45 f0             	cmp    %eax,-0x10(%ebp)
80107dd7:	74 07                	je     80107de0 <loaduvm+0xb3>
      return -1;
80107dd9:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80107dde:	eb 18                	jmp    80107df8 <loaduvm+0xcb>
  for(i = 0; i < sz; i += PGSIZE){
80107de0:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
80107de7:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107dea:	3b 45 18             	cmp    0x18(%ebp),%eax
80107ded:	0f 82 65 ff ff ff    	jb     80107d58 <loaduvm+0x2b>
  }
  return 0;
80107df3:	b8 00 00 00 00       	mov    $0x0,%eax
}
80107df8:	c9                   	leave  
80107df9:	c3                   	ret    

80107dfa <allocuvm>:

// Allocate page tables and physical memory to grow process from oldsz to
// newsz, which need not be page aligned.  Returns new size or 0 on error.
int
allocuvm(pde_t *pgdir, uint oldsz, uint newsz)
{
80107dfa:	55                   	push   %ebp
80107dfb:	89 e5                	mov    %esp,%ebp
80107dfd:	83 ec 18             	sub    $0x18,%esp
  char *mem;
  uint a;

  if(newsz >= KERNBASE)
80107e00:	8b 45 10             	mov    0x10(%ebp),%eax
80107e03:	85 c0                	test   %eax,%eax
80107e05:	79 0a                	jns    80107e11 <allocuvm+0x17>
    return 0;
80107e07:	b8 00 00 00 00       	mov    $0x0,%eax
80107e0c:	e9 ec 00 00 00       	jmp    80107efd <allocuvm+0x103>
  if(newsz < oldsz)
80107e11:	8b 45 10             	mov    0x10(%ebp),%eax
80107e14:	3b 45 0c             	cmp    0xc(%ebp),%eax
80107e17:	73 08                	jae    80107e21 <allocuvm+0x27>
    return oldsz;
80107e19:	8b 45 0c             	mov    0xc(%ebp),%eax
80107e1c:	e9 dc 00 00 00       	jmp    80107efd <allocuvm+0x103>

  a = PGROUNDUP(oldsz);
80107e21:	8b 45 0c             	mov    0xc(%ebp),%eax
80107e24:	05 ff 0f 00 00       	add    $0xfff,%eax
80107e29:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80107e2e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  for(; a < newsz; a += PGSIZE){
80107e31:	e9 b8 00 00 00       	jmp    80107eee <allocuvm+0xf4>
    mem = kalloc();
80107e36:	e8 49 ae ff ff       	call   80102c84 <kalloc>
80107e3b:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(mem == 0){
80107e3e:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80107e42:	75 2e                	jne    80107e72 <allocuvm+0x78>
      cprintf("allocuvm out of memory\n");
80107e44:	83 ec 0c             	sub    $0xc,%esp
80107e47:	68 b1 ac 10 80       	push   $0x8010acb1
80107e4c:	e8 a3 85 ff ff       	call   801003f4 <cprintf>
80107e51:	83 c4 10             	add    $0x10,%esp
      deallocuvm(pgdir, newsz, oldsz);
80107e54:	83 ec 04             	sub    $0x4,%esp
80107e57:	ff 75 0c             	push   0xc(%ebp)
80107e5a:	ff 75 10             	push   0x10(%ebp)
80107e5d:	ff 75 08             	push   0x8(%ebp)
80107e60:	e8 9a 00 00 00       	call   80107eff <deallocuvm>
80107e65:	83 c4 10             	add    $0x10,%esp
      return 0;
80107e68:	b8 00 00 00 00       	mov    $0x0,%eax
80107e6d:	e9 8b 00 00 00       	jmp    80107efd <allocuvm+0x103>
    }
    memset(mem, 0, PGSIZE);
80107e72:	83 ec 04             	sub    $0x4,%esp
80107e75:	68 00 10 00 00       	push   $0x1000
80107e7a:	6a 00                	push   $0x0
80107e7c:	ff 75 f0             	push   -0x10(%ebp)
80107e7f:	e8 3a d2 ff ff       	call   801050be <memset>
80107e84:	83 c4 10             	add    $0x10,%esp
    if(mappages(pgdir, (char*)a, PGSIZE, V2P(mem), PTE_W|PTE_U) < 0){
80107e87:	8b 45 f0             	mov    -0x10(%ebp),%eax
80107e8a:	8d 90 00 00 00 80    	lea    -0x80000000(%eax),%edx
80107e90:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107e93:	83 ec 0c             	sub    $0xc,%esp
80107e96:	6a 06                	push   $0x6
80107e98:	52                   	push   %edx
80107e99:	68 00 10 00 00       	push   $0x1000
80107e9e:	50                   	push   %eax
80107e9f:	ff 75 08             	push   0x8(%ebp)
80107ea2:	e8 ca fa ff ff       	call   80107971 <mappages>
80107ea7:	83 c4 20             	add    $0x20,%esp
80107eaa:	85 c0                	test   %eax,%eax
80107eac:	79 39                	jns    80107ee7 <allocuvm+0xed>
      cprintf("allocuvm out of memory (2)\n");
80107eae:	83 ec 0c             	sub    $0xc,%esp
80107eb1:	68 c9 ac 10 80       	push   $0x8010acc9
80107eb6:	e8 39 85 ff ff       	call   801003f4 <cprintf>
80107ebb:	83 c4 10             	add    $0x10,%esp
      deallocuvm(pgdir, newsz, oldsz);
80107ebe:	83 ec 04             	sub    $0x4,%esp
80107ec1:	ff 75 0c             	push   0xc(%ebp)
80107ec4:	ff 75 10             	push   0x10(%ebp)
80107ec7:	ff 75 08             	push   0x8(%ebp)
80107eca:	e8 30 00 00 00       	call   80107eff <deallocuvm>
80107ecf:	83 c4 10             	add    $0x10,%esp
      kfree(mem);
80107ed2:	83 ec 0c             	sub    $0xc,%esp
80107ed5:	ff 75 f0             	push   -0x10(%ebp)
80107ed8:	e8 0d ad ff ff       	call   80102bea <kfree>
80107edd:	83 c4 10             	add    $0x10,%esp
      return 0;
80107ee0:	b8 00 00 00 00       	mov    $0x0,%eax
80107ee5:	eb 16                	jmp    80107efd <allocuvm+0x103>
  for(; a < newsz; a += PGSIZE){
80107ee7:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
80107eee:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107ef1:	3b 45 10             	cmp    0x10(%ebp),%eax
80107ef4:	0f 82 3c ff ff ff    	jb     80107e36 <allocuvm+0x3c>
    }
  }
  return newsz;
80107efa:	8b 45 10             	mov    0x10(%ebp),%eax
}
80107efd:	c9                   	leave  
80107efe:	c3                   	ret    

80107eff <deallocuvm>:
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
int
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
{
80107eff:	55                   	push   %ebp
80107f00:	89 e5                	mov    %esp,%ebp
80107f02:	83 ec 18             	sub    $0x18,%esp
  pte_t *pte;
  uint a, pa;

  if(newsz >= oldsz)
80107f05:	8b 45 10             	mov    0x10(%ebp),%eax
80107f08:	3b 45 0c             	cmp    0xc(%ebp),%eax
80107f0b:	72 08                	jb     80107f15 <deallocuvm+0x16>
    return oldsz;
80107f0d:	8b 45 0c             	mov    0xc(%ebp),%eax
80107f10:	e9 ac 00 00 00       	jmp    80107fc1 <deallocuvm+0xc2>

  a = PGROUNDUP(newsz);
80107f15:	8b 45 10             	mov    0x10(%ebp),%eax
80107f18:	05 ff 0f 00 00       	add    $0xfff,%eax
80107f1d:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80107f22:	89 45 f4             	mov    %eax,-0xc(%ebp)
  for(; a  < oldsz; a += PGSIZE){
80107f25:	e9 88 00 00 00       	jmp    80107fb2 <deallocuvm+0xb3>
    pte = walkpgdir(pgdir, (char*)a, 0);
80107f2a:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107f2d:	83 ec 04             	sub    $0x4,%esp
80107f30:	6a 00                	push   $0x0
80107f32:	50                   	push   %eax
80107f33:	ff 75 08             	push   0x8(%ebp)
80107f36:	e8 a0 f9 ff ff       	call   801078db <walkpgdir>
80107f3b:	83 c4 10             	add    $0x10,%esp
80107f3e:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(!pte)
80107f41:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80107f45:	75 16                	jne    80107f5d <deallocuvm+0x5e>
      a = PGADDR(PDX(a) + 1, 0, 0) - PGSIZE;
80107f47:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107f4a:	c1 e8 16             	shr    $0x16,%eax
80107f4d:	83 c0 01             	add    $0x1,%eax
80107f50:	c1 e0 16             	shl    $0x16,%eax
80107f53:	2d 00 10 00 00       	sub    $0x1000,%eax
80107f58:	89 45 f4             	mov    %eax,-0xc(%ebp)
80107f5b:	eb 4e                	jmp    80107fab <deallocuvm+0xac>
    else if((*pte & PTE_P) != 0){
80107f5d:	8b 45 f0             	mov    -0x10(%ebp),%eax
80107f60:	8b 00                	mov    (%eax),%eax
80107f62:	83 e0 01             	and    $0x1,%eax
80107f65:	85 c0                	test   %eax,%eax
80107f67:	74 42                	je     80107fab <deallocuvm+0xac>
      pa = PTE_ADDR(*pte);
80107f69:	8b 45 f0             	mov    -0x10(%ebp),%eax
80107f6c:	8b 00                	mov    (%eax),%eax
80107f6e:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80107f73:	89 45 ec             	mov    %eax,-0x14(%ebp)
      if(pa == 0)
80107f76:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
80107f7a:	75 0d                	jne    80107f89 <deallocuvm+0x8a>
        panic("kfree");
80107f7c:	83 ec 0c             	sub    $0xc,%esp
80107f7f:	68 e5 ac 10 80       	push   $0x8010ace5
80107f84:	e8 20 86 ff ff       	call   801005a9 <panic>
      char *v = P2V(pa);
80107f89:	8b 45 ec             	mov    -0x14(%ebp),%eax
80107f8c:	05 00 00 00 80       	add    $0x80000000,%eax
80107f91:	89 45 e8             	mov    %eax,-0x18(%ebp)
      kfree(v);
80107f94:	83 ec 0c             	sub    $0xc,%esp
80107f97:	ff 75 e8             	push   -0x18(%ebp)
80107f9a:	e8 4b ac ff ff       	call   80102bea <kfree>
80107f9f:	83 c4 10             	add    $0x10,%esp
      *pte = 0;
80107fa2:	8b 45 f0             	mov    -0x10(%ebp),%eax
80107fa5:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  for(; a  < oldsz; a += PGSIZE){
80107fab:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
80107fb2:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107fb5:	3b 45 0c             	cmp    0xc(%ebp),%eax
80107fb8:	0f 82 6c ff ff ff    	jb     80107f2a <deallocuvm+0x2b>
    }
  }
  return newsz;
80107fbe:	8b 45 10             	mov    0x10(%ebp),%eax
}
80107fc1:	c9                   	leave  
80107fc2:	c3                   	ret    

80107fc3 <freevm>:

// Free a page table and all the physical memory pages
// in the user part.
void
freevm(pde_t *pgdir)
{
80107fc3:	55                   	push   %ebp
80107fc4:	89 e5                	mov    %esp,%ebp
80107fc6:	83 ec 18             	sub    $0x18,%esp
  uint i;

  if(pgdir == 0)
80107fc9:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
80107fcd:	75 0d                	jne    80107fdc <freevm+0x19>
    panic("freevm: no pgdir");
80107fcf:	83 ec 0c             	sub    $0xc,%esp
80107fd2:	68 eb ac 10 80       	push   $0x8010aceb
80107fd7:	e8 cd 85 ff ff       	call   801005a9 <panic>
  deallocuvm(pgdir, KERNBASE, 0);
80107fdc:	83 ec 04             	sub    $0x4,%esp
80107fdf:	6a 00                	push   $0x0
80107fe1:	68 00 00 00 80       	push   $0x80000000
80107fe6:	ff 75 08             	push   0x8(%ebp)
80107fe9:	e8 11 ff ff ff       	call   80107eff <deallocuvm>
80107fee:	83 c4 10             	add    $0x10,%esp
  for(i = 0; i < NPDENTRIES; i++){
80107ff1:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80107ff8:	eb 48                	jmp    80108042 <freevm+0x7f>
    if(pgdir[i] & PTE_P){
80107ffa:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107ffd:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80108004:	8b 45 08             	mov    0x8(%ebp),%eax
80108007:	01 d0                	add    %edx,%eax
80108009:	8b 00                	mov    (%eax),%eax
8010800b:	83 e0 01             	and    $0x1,%eax
8010800e:	85 c0                	test   %eax,%eax
80108010:	74 2c                	je     8010803e <freevm+0x7b>
      char * v = P2V(PTE_ADDR(pgdir[i]));
80108012:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108015:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
8010801c:	8b 45 08             	mov    0x8(%ebp),%eax
8010801f:	01 d0                	add    %edx,%eax
80108021:	8b 00                	mov    (%eax),%eax
80108023:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80108028:	05 00 00 00 80       	add    $0x80000000,%eax
8010802d:	89 45 f0             	mov    %eax,-0x10(%ebp)
      kfree(v);
80108030:	83 ec 0c             	sub    $0xc,%esp
80108033:	ff 75 f0             	push   -0x10(%ebp)
80108036:	e8 af ab ff ff       	call   80102bea <kfree>
8010803b:	83 c4 10             	add    $0x10,%esp
  for(i = 0; i < NPDENTRIES; i++){
8010803e:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80108042:	81 7d f4 ff 03 00 00 	cmpl   $0x3ff,-0xc(%ebp)
80108049:	76 af                	jbe    80107ffa <freevm+0x37>
    }
  }
  kfree((char*)pgdir);
8010804b:	83 ec 0c             	sub    $0xc,%esp
8010804e:	ff 75 08             	push   0x8(%ebp)
80108051:	e8 94 ab ff ff       	call   80102bea <kfree>
80108056:	83 c4 10             	add    $0x10,%esp
}
80108059:	90                   	nop
8010805a:	c9                   	leave  
8010805b:	c3                   	ret    

8010805c <clearpteu>:

// Clear PTE_U on a page. Used to create an inaccessible
// page beneath the user stack.
void
clearpteu(pde_t *pgdir, char *uva)
{
8010805c:	55                   	push   %ebp
8010805d:	89 e5                	mov    %esp,%ebp
8010805f:	83 ec 18             	sub    $0x18,%esp
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
80108062:	83 ec 04             	sub    $0x4,%esp
80108065:	6a 00                	push   $0x0
80108067:	ff 75 0c             	push   0xc(%ebp)
8010806a:	ff 75 08             	push   0x8(%ebp)
8010806d:	e8 69 f8 ff ff       	call   801078db <walkpgdir>
80108072:	83 c4 10             	add    $0x10,%esp
80108075:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(pte == 0)
80108078:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
8010807c:	75 0d                	jne    8010808b <clearpteu+0x2f>
    panic("clearpteu");
8010807e:	83 ec 0c             	sub    $0xc,%esp
80108081:	68 fc ac 10 80       	push   $0x8010acfc
80108086:	e8 1e 85 ff ff       	call   801005a9 <panic>
  *pte &= ~PTE_U;
8010808b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010808e:	8b 00                	mov    (%eax),%eax
80108090:	83 e0 fb             	and    $0xfffffffb,%eax
80108093:	89 c2                	mov    %eax,%edx
80108095:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108098:	89 10                	mov    %edx,(%eax)
}
8010809a:	90                   	nop
8010809b:	c9                   	leave  
8010809c:	c3                   	ret    

8010809d <copyuvm>:

// Given a parent process's page table, create a copy
// of it for a child.
pde_t*
copyuvm(pde_t *pgdir, uint sz)
{
8010809d:	55                   	push   %ebp
8010809e:	89 e5                	mov    %esp,%ebp
801080a0:	83 ec 28             	sub    $0x28,%esp
  pde_t *d;
  pte_t *pte;
  uint pa, i, flags;
  char *mem;

  if((d = setupkvm()) == 0)
801080a3:	e8 59 f9 ff ff       	call   80107a01 <setupkvm>
801080a8:	89 45 f0             	mov    %eax,-0x10(%ebp)
801080ab:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
801080af:	75 0a                	jne    801080bb <copyuvm+0x1e>
    return 0;
801080b1:	b8 00 00 00 00       	mov    $0x0,%eax
801080b6:	e9 eb 00 00 00       	jmp    801081a6 <copyuvm+0x109>
  for(i = 0; i < sz; i += PGSIZE){
801080bb:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
801080c2:	e9 b7 00 00 00       	jmp    8010817e <copyuvm+0xe1>
    if((pte = walkpgdir(pgdir, (void *) i, 0)) == 0)
801080c7:	8b 45 f4             	mov    -0xc(%ebp),%eax
801080ca:	83 ec 04             	sub    $0x4,%esp
801080cd:	6a 00                	push   $0x0
801080cf:	50                   	push   %eax
801080d0:	ff 75 08             	push   0x8(%ebp)
801080d3:	e8 03 f8 ff ff       	call   801078db <walkpgdir>
801080d8:	83 c4 10             	add    $0x10,%esp
801080db:	89 45 ec             	mov    %eax,-0x14(%ebp)
801080de:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
801080e2:	75 0d                	jne    801080f1 <copyuvm+0x54>
      panic("copyuvm: pte should exist");
801080e4:	83 ec 0c             	sub    $0xc,%esp
801080e7:	68 06 ad 10 80       	push   $0x8010ad06
801080ec:	e8 b8 84 ff ff       	call   801005a9 <panic>
    if(!(*pte & PTE_P))
801080f1:	8b 45 ec             	mov    -0x14(%ebp),%eax
801080f4:	8b 00                	mov    (%eax),%eax
801080f6:	83 e0 01             	and    $0x1,%eax
801080f9:	85 c0                	test   %eax,%eax
801080fb:	75 0d                	jne    8010810a <copyuvm+0x6d>
      panic("copyuvm: page not present");
801080fd:	83 ec 0c             	sub    $0xc,%esp
80108100:	68 20 ad 10 80       	push   $0x8010ad20
80108105:	e8 9f 84 ff ff       	call   801005a9 <panic>
    pa = PTE_ADDR(*pte);
8010810a:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010810d:	8b 00                	mov    (%eax),%eax
8010810f:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80108114:	89 45 e8             	mov    %eax,-0x18(%ebp)
    flags = PTE_FLAGS(*pte);
80108117:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010811a:	8b 00                	mov    (%eax),%eax
8010811c:	25 ff 0f 00 00       	and    $0xfff,%eax
80108121:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if((mem = kalloc()) == 0)
80108124:	e8 5b ab ff ff       	call   80102c84 <kalloc>
80108129:	89 45 e0             	mov    %eax,-0x20(%ebp)
8010812c:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
80108130:	74 5d                	je     8010818f <copyuvm+0xf2>
      goto bad;
    memmove(mem, (char*)P2V(pa), PGSIZE);
80108132:	8b 45 e8             	mov    -0x18(%ebp),%eax
80108135:	05 00 00 00 80       	add    $0x80000000,%eax
8010813a:	83 ec 04             	sub    $0x4,%esp
8010813d:	68 00 10 00 00       	push   $0x1000
80108142:	50                   	push   %eax
80108143:	ff 75 e0             	push   -0x20(%ebp)
80108146:	e8 32 d0 ff ff       	call   8010517d <memmove>
8010814b:	83 c4 10             	add    $0x10,%esp
    if(mappages(d, (void*)i, PGSIZE, V2P(mem), flags) < 0)
8010814e:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80108151:	8b 45 e0             	mov    -0x20(%ebp),%eax
80108154:	8d 88 00 00 00 80    	lea    -0x80000000(%eax),%ecx
8010815a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010815d:	83 ec 0c             	sub    $0xc,%esp
80108160:	52                   	push   %edx
80108161:	51                   	push   %ecx
80108162:	68 00 10 00 00       	push   $0x1000
80108167:	50                   	push   %eax
80108168:	ff 75 f0             	push   -0x10(%ebp)
8010816b:	e8 01 f8 ff ff       	call   80107971 <mappages>
80108170:	83 c4 20             	add    $0x20,%esp
80108173:	85 c0                	test   %eax,%eax
80108175:	78 1b                	js     80108192 <copyuvm+0xf5>
  for(i = 0; i < sz; i += PGSIZE){
80108177:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
8010817e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108181:	3b 45 0c             	cmp    0xc(%ebp),%eax
80108184:	0f 82 3d ff ff ff    	jb     801080c7 <copyuvm+0x2a>
      goto bad;
  }
  return d;
8010818a:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010818d:	eb 17                	jmp    801081a6 <copyuvm+0x109>
      goto bad;
8010818f:	90                   	nop
80108190:	eb 01                	jmp    80108193 <copyuvm+0xf6>
      goto bad;
80108192:	90                   	nop

bad:
  freevm(d);
80108193:	83 ec 0c             	sub    $0xc,%esp
80108196:	ff 75 f0             	push   -0x10(%ebp)
80108199:	e8 25 fe ff ff       	call   80107fc3 <freevm>
8010819e:	83 c4 10             	add    $0x10,%esp
  return 0;
801081a1:	b8 00 00 00 00       	mov    $0x0,%eax
}
801081a6:	c9                   	leave  
801081a7:	c3                   	ret    

801081a8 <uva2ka>:

//PAGEBREAK!
// Map user virtual address to kernel address.
char*
uva2ka(pde_t *pgdir, char *uva)
{
801081a8:	55                   	push   %ebp
801081a9:	89 e5                	mov    %esp,%ebp
801081ab:	83 ec 18             	sub    $0x18,%esp
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
801081ae:	83 ec 04             	sub    $0x4,%esp
801081b1:	6a 00                	push   $0x0
801081b3:	ff 75 0c             	push   0xc(%ebp)
801081b6:	ff 75 08             	push   0x8(%ebp)
801081b9:	e8 1d f7 ff ff       	call   801078db <walkpgdir>
801081be:	83 c4 10             	add    $0x10,%esp
801081c1:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if((*pte & PTE_P) == 0)
801081c4:	8b 45 f4             	mov    -0xc(%ebp),%eax
801081c7:	8b 00                	mov    (%eax),%eax
801081c9:	83 e0 01             	and    $0x1,%eax
801081cc:	85 c0                	test   %eax,%eax
801081ce:	75 07                	jne    801081d7 <uva2ka+0x2f>
    return 0;
801081d0:	b8 00 00 00 00       	mov    $0x0,%eax
801081d5:	eb 22                	jmp    801081f9 <uva2ka+0x51>
  if((*pte & PTE_U) == 0)
801081d7:	8b 45 f4             	mov    -0xc(%ebp),%eax
801081da:	8b 00                	mov    (%eax),%eax
801081dc:	83 e0 04             	and    $0x4,%eax
801081df:	85 c0                	test   %eax,%eax
801081e1:	75 07                	jne    801081ea <uva2ka+0x42>
    return 0;
801081e3:	b8 00 00 00 00       	mov    $0x0,%eax
801081e8:	eb 0f                	jmp    801081f9 <uva2ka+0x51>
  return (char*)P2V(PTE_ADDR(*pte));
801081ea:	8b 45 f4             	mov    -0xc(%ebp),%eax
801081ed:	8b 00                	mov    (%eax),%eax
801081ef:	25 00 f0 ff ff       	and    $0xfffff000,%eax
801081f4:	05 00 00 00 80       	add    $0x80000000,%eax
}
801081f9:	c9                   	leave  
801081fa:	c3                   	ret    

801081fb <copyout>:
// Copy len bytes from p to user address va in page table pgdir.
// Most useful when pgdir is not the current page table.
// uva2ka ensures this only works for PTE_U pages.
int
copyout(pde_t *pgdir, uint va, void *p, uint len)
{
801081fb:	55                   	push   %ebp
801081fc:	89 e5                	mov    %esp,%ebp
801081fe:	83 ec 18             	sub    $0x18,%esp
  char *buf, *pa0;
  uint n, va0;

  buf = (char*)p;
80108201:	8b 45 10             	mov    0x10(%ebp),%eax
80108204:	89 45 f4             	mov    %eax,-0xc(%ebp)
  while(len > 0){
80108207:	eb 7f                	jmp    80108288 <copyout+0x8d>
    va0 = (uint)PGROUNDDOWN(va);
80108209:	8b 45 0c             	mov    0xc(%ebp),%eax
8010820c:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80108211:	89 45 ec             	mov    %eax,-0x14(%ebp)
    pa0 = uva2ka(pgdir, (char*)va0);
80108214:	8b 45 ec             	mov    -0x14(%ebp),%eax
80108217:	83 ec 08             	sub    $0x8,%esp
8010821a:	50                   	push   %eax
8010821b:	ff 75 08             	push   0x8(%ebp)
8010821e:	e8 85 ff ff ff       	call   801081a8 <uva2ka>
80108223:	83 c4 10             	add    $0x10,%esp
80108226:	89 45 e8             	mov    %eax,-0x18(%ebp)
    if(pa0 == 0)
80108229:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
8010822d:	75 07                	jne    80108236 <copyout+0x3b>
      return -1;
8010822f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80108234:	eb 61                	jmp    80108297 <copyout+0x9c>
    n = PGSIZE - (va - va0);
80108236:	8b 45 ec             	mov    -0x14(%ebp),%eax
80108239:	2b 45 0c             	sub    0xc(%ebp),%eax
8010823c:	05 00 10 00 00       	add    $0x1000,%eax
80108241:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(n > len)
80108244:	8b 45 f0             	mov    -0x10(%ebp),%eax
80108247:	3b 45 14             	cmp    0x14(%ebp),%eax
8010824a:	76 06                	jbe    80108252 <copyout+0x57>
      n = len;
8010824c:	8b 45 14             	mov    0x14(%ebp),%eax
8010824f:	89 45 f0             	mov    %eax,-0x10(%ebp)
    memmove(pa0 + (va - va0), buf, n);
80108252:	8b 45 0c             	mov    0xc(%ebp),%eax
80108255:	2b 45 ec             	sub    -0x14(%ebp),%eax
80108258:	89 c2                	mov    %eax,%edx
8010825a:	8b 45 e8             	mov    -0x18(%ebp),%eax
8010825d:	01 d0                	add    %edx,%eax
8010825f:	83 ec 04             	sub    $0x4,%esp
80108262:	ff 75 f0             	push   -0x10(%ebp)
80108265:	ff 75 f4             	push   -0xc(%ebp)
80108268:	50                   	push   %eax
80108269:	e8 0f cf ff ff       	call   8010517d <memmove>
8010826e:	83 c4 10             	add    $0x10,%esp
    len -= n;
80108271:	8b 45 f0             	mov    -0x10(%ebp),%eax
80108274:	29 45 14             	sub    %eax,0x14(%ebp)
    buf += n;
80108277:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010827a:	01 45 f4             	add    %eax,-0xc(%ebp)
    va = va0 + PGSIZE;
8010827d:	8b 45 ec             	mov    -0x14(%ebp),%eax
80108280:	05 00 10 00 00       	add    $0x1000,%eax
80108285:	89 45 0c             	mov    %eax,0xc(%ebp)
  while(len > 0){
80108288:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
8010828c:	0f 85 77 ff ff ff    	jne    80108209 <copyout+0xe>
  }
  return 0;
80108292:	b8 00 00 00 00       	mov    $0x0,%eax
}
80108297:	c9                   	leave  
80108298:	c3                   	ret    

80108299 <mpinit_uefi>:

struct cpu cpus[NCPU];
int ncpu;
uchar ioapicid;
void mpinit_uefi(void)
{
80108299:	55                   	push   %ebp
8010829a:	89 e5                	mov    %esp,%ebp
8010829c:	83 ec 20             	sub    $0x20,%esp
  struct boot_param *boot_param = (struct boot_param *)P2V_WO(BOOTPARAM);
8010829f:	c7 45 f8 00 00 05 80 	movl   $0x80050000,-0x8(%ebp)
  struct uefi_madt *madt = (struct uefi_madt*)(P2V_WO(boot_param->madt_addr));
801082a6:	8b 45 f8             	mov    -0x8(%ebp),%eax
801082a9:	8b 40 08             	mov    0x8(%eax),%eax
801082ac:	05 00 00 00 80       	add    $0x80000000,%eax
801082b1:	89 45 f4             	mov    %eax,-0xc(%ebp)

  uint i=sizeof(struct uefi_madt);
801082b4:	c7 45 fc 2c 00 00 00 	movl   $0x2c,-0x4(%ebp)
  struct uefi_lapic *lapic_entry;
  struct uefi_ioapic *ioapic;
  struct uefi_iso *iso;
  struct uefi_non_maskable_intr *non_mask_intr; 
  
  lapic = (uint *)(madt->lapic_addr);
801082bb:	8b 45 f4             	mov    -0xc(%ebp),%eax
801082be:	8b 40 24             	mov    0x24(%eax),%eax
801082c1:	a3 40 71 11 80       	mov    %eax,0x80117140
  ncpu = 0;
801082c6:	c7 05 80 9d 11 80 00 	movl   $0x0,0x80119d80
801082cd:	00 00 00 

  while(i<madt->len){
801082d0:	90                   	nop
801082d1:	e9 bd 00 00 00       	jmp    80108393 <mpinit_uefi+0xfa>
    uchar *entry_type = ((uchar *)madt)+i;
801082d6:	8b 55 f4             	mov    -0xc(%ebp),%edx
801082d9:	8b 45 fc             	mov    -0x4(%ebp),%eax
801082dc:	01 d0                	add    %edx,%eax
801082de:	89 45 f0             	mov    %eax,-0x10(%ebp)
    switch(*entry_type){
801082e1:	8b 45 f0             	mov    -0x10(%ebp),%eax
801082e4:	0f b6 00             	movzbl (%eax),%eax
801082e7:	0f b6 c0             	movzbl %al,%eax
801082ea:	83 f8 05             	cmp    $0x5,%eax
801082ed:	0f 87 a0 00 00 00    	ja     80108393 <mpinit_uefi+0xfa>
801082f3:	8b 04 85 3c ad 10 80 	mov    -0x7fef52c4(,%eax,4),%eax
801082fa:	ff e0                	jmp    *%eax
      case 0:
        lapic_entry = (struct uefi_lapic *)entry_type;
801082fc:	8b 45 f0             	mov    -0x10(%ebp),%eax
801082ff:	89 45 e0             	mov    %eax,-0x20(%ebp)
        if(ncpu < NCPU) {
80108302:	a1 80 9d 11 80       	mov    0x80119d80,%eax
80108307:	83 f8 03             	cmp    $0x3,%eax
8010830a:	7f 28                	jg     80108334 <mpinit_uefi+0x9b>
          cpus[ncpu].apicid = lapic_entry->lapic_id;
8010830c:	8b 15 80 9d 11 80    	mov    0x80119d80,%edx
80108312:	8b 45 e0             	mov    -0x20(%ebp),%eax
80108315:	0f b6 40 03          	movzbl 0x3(%eax),%eax
80108319:	69 d2 b0 00 00 00    	imul   $0xb0,%edx,%edx
8010831f:	81 c2 c0 9a 11 80    	add    $0x80119ac0,%edx
80108325:	88 02                	mov    %al,(%edx)
          ncpu++;
80108327:	a1 80 9d 11 80       	mov    0x80119d80,%eax
8010832c:	83 c0 01             	add    $0x1,%eax
8010832f:	a3 80 9d 11 80       	mov    %eax,0x80119d80
        }
        i += lapic_entry->record_len;
80108334:	8b 45 e0             	mov    -0x20(%ebp),%eax
80108337:	0f b6 40 01          	movzbl 0x1(%eax),%eax
8010833b:	0f b6 c0             	movzbl %al,%eax
8010833e:	01 45 fc             	add    %eax,-0x4(%ebp)
        break;
80108341:	eb 50                	jmp    80108393 <mpinit_uefi+0xfa>

      case 1:
        ioapic = (struct uefi_ioapic *)entry_type;
80108343:	8b 45 f0             	mov    -0x10(%ebp),%eax
80108346:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        ioapicid = ioapic->ioapic_id;
80108349:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010834c:	0f b6 40 02          	movzbl 0x2(%eax),%eax
80108350:	a2 84 9d 11 80       	mov    %al,0x80119d84
        i += ioapic->record_len;
80108355:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80108358:	0f b6 40 01          	movzbl 0x1(%eax),%eax
8010835c:	0f b6 c0             	movzbl %al,%eax
8010835f:	01 45 fc             	add    %eax,-0x4(%ebp)
        break;
80108362:	eb 2f                	jmp    80108393 <mpinit_uefi+0xfa>

      case 2:
        iso = (struct uefi_iso *)entry_type;
80108364:	8b 45 f0             	mov    -0x10(%ebp),%eax
80108367:	89 45 e8             	mov    %eax,-0x18(%ebp)
        i += iso->record_len;
8010836a:	8b 45 e8             	mov    -0x18(%ebp),%eax
8010836d:	0f b6 40 01          	movzbl 0x1(%eax),%eax
80108371:	0f b6 c0             	movzbl %al,%eax
80108374:	01 45 fc             	add    %eax,-0x4(%ebp)
        break;
80108377:	eb 1a                	jmp    80108393 <mpinit_uefi+0xfa>

      case 4:
        non_mask_intr = (struct uefi_non_maskable_intr *)entry_type;
80108379:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010837c:	89 45 ec             	mov    %eax,-0x14(%ebp)
        i += non_mask_intr->record_len;
8010837f:	8b 45 ec             	mov    -0x14(%ebp),%eax
80108382:	0f b6 40 01          	movzbl 0x1(%eax),%eax
80108386:	0f b6 c0             	movzbl %al,%eax
80108389:	01 45 fc             	add    %eax,-0x4(%ebp)
        break;
8010838c:	eb 05                	jmp    80108393 <mpinit_uefi+0xfa>

      case 5:
        i = i + 0xC;
8010838e:	83 45 fc 0c          	addl   $0xc,-0x4(%ebp)
        break;
80108392:	90                   	nop
  while(i<madt->len){
80108393:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108396:	8b 40 04             	mov    0x4(%eax),%eax
80108399:	39 45 fc             	cmp    %eax,-0x4(%ebp)
8010839c:	0f 82 34 ff ff ff    	jb     801082d6 <mpinit_uefi+0x3d>
    }
  }

}
801083a2:	90                   	nop
801083a3:	90                   	nop
801083a4:	c9                   	leave  
801083a5:	c3                   	ret    

801083a6 <inb>:
{
801083a6:	55                   	push   %ebp
801083a7:	89 e5                	mov    %esp,%ebp
801083a9:	83 ec 14             	sub    $0x14,%esp
801083ac:	8b 45 08             	mov    0x8(%ebp),%eax
801083af:	66 89 45 ec          	mov    %ax,-0x14(%ebp)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801083b3:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
801083b7:	89 c2                	mov    %eax,%edx
801083b9:	ec                   	in     (%dx),%al
801083ba:	88 45 ff             	mov    %al,-0x1(%ebp)
  return data;
801083bd:	0f b6 45 ff          	movzbl -0x1(%ebp),%eax
}
801083c1:	c9                   	leave  
801083c2:	c3                   	ret    

801083c3 <outb>:
{
801083c3:	55                   	push   %ebp
801083c4:	89 e5                	mov    %esp,%ebp
801083c6:	83 ec 08             	sub    $0x8,%esp
801083c9:	8b 45 08             	mov    0x8(%ebp),%eax
801083cc:	8b 55 0c             	mov    0xc(%ebp),%edx
801083cf:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
801083d3:	89 d0                	mov    %edx,%eax
801083d5:	88 45 f8             	mov    %al,-0x8(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801083d8:	0f b6 45 f8          	movzbl -0x8(%ebp),%eax
801083dc:	0f b7 55 fc          	movzwl -0x4(%ebp),%edx
801083e0:	ee                   	out    %al,(%dx)
}
801083e1:	90                   	nop
801083e2:	c9                   	leave  
801083e3:	c3                   	ret    

801083e4 <uart_debug>:
#include "proc.h"
#include "x86.h"

#define COM1    0x3f8

void uart_debug(char p){
801083e4:	55                   	push   %ebp
801083e5:	89 e5                	mov    %esp,%ebp
801083e7:	83 ec 28             	sub    $0x28,%esp
801083ea:	8b 45 08             	mov    0x8(%ebp),%eax
801083ed:	88 45 e4             	mov    %al,-0x1c(%ebp)
    // Turn off the FIFO
  outb(COM1+2, 0);
801083f0:	6a 00                	push   $0x0
801083f2:	68 fa 03 00 00       	push   $0x3fa
801083f7:	e8 c7 ff ff ff       	call   801083c3 <outb>
801083fc:	83 c4 08             	add    $0x8,%esp

  // 9600 baud, 8 data bits, 1 stop bit, parity off.
  outb(COM1+3, 0x80);    // Unlock divisor
801083ff:	68 80 00 00 00       	push   $0x80
80108404:	68 fb 03 00 00       	push   $0x3fb
80108409:	e8 b5 ff ff ff       	call   801083c3 <outb>
8010840e:	83 c4 08             	add    $0x8,%esp
  outb(COM1+0, 115200/9600);
80108411:	6a 0c                	push   $0xc
80108413:	68 f8 03 00 00       	push   $0x3f8
80108418:	e8 a6 ff ff ff       	call   801083c3 <outb>
8010841d:	83 c4 08             	add    $0x8,%esp
  outb(COM1+1, 0);
80108420:	6a 00                	push   $0x0
80108422:	68 f9 03 00 00       	push   $0x3f9
80108427:	e8 97 ff ff ff       	call   801083c3 <outb>
8010842c:	83 c4 08             	add    $0x8,%esp
  outb(COM1+3, 0x03);    // Lock divisor, 8 data bits.
8010842f:	6a 03                	push   $0x3
80108431:	68 fb 03 00 00       	push   $0x3fb
80108436:	e8 88 ff ff ff       	call   801083c3 <outb>
8010843b:	83 c4 08             	add    $0x8,%esp
  outb(COM1+4, 0);
8010843e:	6a 00                	push   $0x0
80108440:	68 fc 03 00 00       	push   $0x3fc
80108445:	e8 79 ff ff ff       	call   801083c3 <outb>
8010844a:	83 c4 08             	add    $0x8,%esp

  for(int i=0;i<128 && !(inb(COM1+5) & 0x20); i++) microdelay(10);
8010844d:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80108454:	eb 11                	jmp    80108467 <uart_debug+0x83>
80108456:	83 ec 0c             	sub    $0xc,%esp
80108459:	6a 0a                	push   $0xa
8010845b:	e8 bb ab ff ff       	call   8010301b <microdelay>
80108460:	83 c4 10             	add    $0x10,%esp
80108463:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80108467:	83 7d f4 7f          	cmpl   $0x7f,-0xc(%ebp)
8010846b:	7f 1a                	jg     80108487 <uart_debug+0xa3>
8010846d:	83 ec 0c             	sub    $0xc,%esp
80108470:	68 fd 03 00 00       	push   $0x3fd
80108475:	e8 2c ff ff ff       	call   801083a6 <inb>
8010847a:	83 c4 10             	add    $0x10,%esp
8010847d:	0f b6 c0             	movzbl %al,%eax
80108480:	83 e0 20             	and    $0x20,%eax
80108483:	85 c0                	test   %eax,%eax
80108485:	74 cf                	je     80108456 <uart_debug+0x72>
  outb(COM1+0, p);
80108487:	0f b6 45 e4          	movzbl -0x1c(%ebp),%eax
8010848b:	0f b6 c0             	movzbl %al,%eax
8010848e:	83 ec 08             	sub    $0x8,%esp
80108491:	50                   	push   %eax
80108492:	68 f8 03 00 00       	push   $0x3f8
80108497:	e8 27 ff ff ff       	call   801083c3 <outb>
8010849c:	83 c4 10             	add    $0x10,%esp
}
8010849f:	90                   	nop
801084a0:	c9                   	leave  
801084a1:	c3                   	ret    

801084a2 <uart_debugs>:

void uart_debugs(char *p){
801084a2:	55                   	push   %ebp
801084a3:	89 e5                	mov    %esp,%ebp
801084a5:	83 ec 08             	sub    $0x8,%esp
  while(*p){
801084a8:	eb 1b                	jmp    801084c5 <uart_debugs+0x23>
    uart_debug(*p++);
801084aa:	8b 45 08             	mov    0x8(%ebp),%eax
801084ad:	8d 50 01             	lea    0x1(%eax),%edx
801084b0:	89 55 08             	mov    %edx,0x8(%ebp)
801084b3:	0f b6 00             	movzbl (%eax),%eax
801084b6:	0f be c0             	movsbl %al,%eax
801084b9:	83 ec 0c             	sub    $0xc,%esp
801084bc:	50                   	push   %eax
801084bd:	e8 22 ff ff ff       	call   801083e4 <uart_debug>
801084c2:	83 c4 10             	add    $0x10,%esp
  while(*p){
801084c5:	8b 45 08             	mov    0x8(%ebp),%eax
801084c8:	0f b6 00             	movzbl (%eax),%eax
801084cb:	84 c0                	test   %al,%al
801084cd:	75 db                	jne    801084aa <uart_debugs+0x8>
  }
}
801084cf:	90                   	nop
801084d0:	90                   	nop
801084d1:	c9                   	leave  
801084d2:	c3                   	ret    

801084d3 <graphic_init>:
 * i%4 = 2 : red
 * i%4 = 3 : black
 */

struct gpu gpu;
void graphic_init(){
801084d3:	55                   	push   %ebp
801084d4:	89 e5                	mov    %esp,%ebp
801084d6:	83 ec 10             	sub    $0x10,%esp
  struct boot_param *boot_param = (struct boot_param *)P2V_WO(BOOTPARAM);
801084d9:	c7 45 fc 00 00 05 80 	movl   $0x80050000,-0x4(%ebp)
  gpu.pvram_addr = boot_param->graphic_config.frame_base;
801084e0:	8b 45 fc             	mov    -0x4(%ebp),%eax
801084e3:	8b 50 14             	mov    0x14(%eax),%edx
801084e6:	8b 40 10             	mov    0x10(%eax),%eax
801084e9:	a3 88 9d 11 80       	mov    %eax,0x80119d88
  gpu.vram_size = boot_param->graphic_config.frame_size;
801084ee:	8b 45 fc             	mov    -0x4(%ebp),%eax
801084f1:	8b 50 1c             	mov    0x1c(%eax),%edx
801084f4:	8b 40 18             	mov    0x18(%eax),%eax
801084f7:	a3 90 9d 11 80       	mov    %eax,0x80119d90
  gpu.vvram_addr = DEVSPACE - gpu.vram_size;
801084fc:	8b 15 90 9d 11 80    	mov    0x80119d90,%edx
80108502:	b8 00 00 00 fe       	mov    $0xfe000000,%eax
80108507:	29 d0                	sub    %edx,%eax
80108509:	a3 8c 9d 11 80       	mov    %eax,0x80119d8c
  gpu.horizontal_resolution = (uint)(boot_param->graphic_config.horizontal_resolution & 0xFFFFFFFF);
8010850e:	8b 45 fc             	mov    -0x4(%ebp),%eax
80108511:	8b 50 24             	mov    0x24(%eax),%edx
80108514:	8b 40 20             	mov    0x20(%eax),%eax
80108517:	a3 94 9d 11 80       	mov    %eax,0x80119d94
  gpu.vertical_resolution = (uint)(boot_param->graphic_config.vertical_resolution & 0xFFFFFFFF);
8010851c:	8b 45 fc             	mov    -0x4(%ebp),%eax
8010851f:	8b 50 2c             	mov    0x2c(%eax),%edx
80108522:	8b 40 28             	mov    0x28(%eax),%eax
80108525:	a3 98 9d 11 80       	mov    %eax,0x80119d98
  gpu.pixels_per_line = (uint)(boot_param->graphic_config.pixels_per_line & 0xFFFFFFFF);
8010852a:	8b 45 fc             	mov    -0x4(%ebp),%eax
8010852d:	8b 50 34             	mov    0x34(%eax),%edx
80108530:	8b 40 30             	mov    0x30(%eax),%eax
80108533:	a3 9c 9d 11 80       	mov    %eax,0x80119d9c
}
80108538:	90                   	nop
80108539:	c9                   	leave  
8010853a:	c3                   	ret    

8010853b <graphic_draw_pixel>:

void graphic_draw_pixel(int x,int y,struct graphic_pixel * buffer){
8010853b:	55                   	push   %ebp
8010853c:	89 e5                	mov    %esp,%ebp
8010853e:	83 ec 10             	sub    $0x10,%esp
  int pixel_addr = (sizeof(struct graphic_pixel))*(y*gpu.pixels_per_line + x);
80108541:	8b 15 9c 9d 11 80    	mov    0x80119d9c,%edx
80108547:	8b 45 0c             	mov    0xc(%ebp),%eax
8010854a:	0f af d0             	imul   %eax,%edx
8010854d:	8b 45 08             	mov    0x8(%ebp),%eax
80108550:	01 d0                	add    %edx,%eax
80108552:	c1 e0 02             	shl    $0x2,%eax
80108555:	89 45 fc             	mov    %eax,-0x4(%ebp)
  struct graphic_pixel *pixel = (struct graphic_pixel *)(gpu.vvram_addr + pixel_addr);
80108558:	8b 15 8c 9d 11 80    	mov    0x80119d8c,%edx
8010855e:	8b 45 fc             	mov    -0x4(%ebp),%eax
80108561:	01 d0                	add    %edx,%eax
80108563:	89 45 f8             	mov    %eax,-0x8(%ebp)
  pixel->blue = buffer->blue;
80108566:	8b 45 10             	mov    0x10(%ebp),%eax
80108569:	0f b6 10             	movzbl (%eax),%edx
8010856c:	8b 45 f8             	mov    -0x8(%ebp),%eax
8010856f:	88 10                	mov    %dl,(%eax)
  pixel->green = buffer->green;
80108571:	8b 45 10             	mov    0x10(%ebp),%eax
80108574:	0f b6 50 01          	movzbl 0x1(%eax),%edx
80108578:	8b 45 f8             	mov    -0x8(%ebp),%eax
8010857b:	88 50 01             	mov    %dl,0x1(%eax)
  pixel->red = buffer->red;
8010857e:	8b 45 10             	mov    0x10(%ebp),%eax
80108581:	0f b6 50 02          	movzbl 0x2(%eax),%edx
80108585:	8b 45 f8             	mov    -0x8(%ebp),%eax
80108588:	88 50 02             	mov    %dl,0x2(%eax)
}
8010858b:	90                   	nop
8010858c:	c9                   	leave  
8010858d:	c3                   	ret    

8010858e <graphic_scroll_up>:

void graphic_scroll_up(int height){
8010858e:	55                   	push   %ebp
8010858f:	89 e5                	mov    %esp,%ebp
80108591:	83 ec 18             	sub    $0x18,%esp
  int addr_diff = (sizeof(struct graphic_pixel))*gpu.pixels_per_line*height;
80108594:	8b 15 9c 9d 11 80    	mov    0x80119d9c,%edx
8010859a:	8b 45 08             	mov    0x8(%ebp),%eax
8010859d:	0f af c2             	imul   %edx,%eax
801085a0:	c1 e0 02             	shl    $0x2,%eax
801085a3:	89 45 f4             	mov    %eax,-0xc(%ebp)
  memmove((unsigned int *)gpu.vvram_addr,(unsigned int *)(gpu.vvram_addr + addr_diff),gpu.vram_size - addr_diff);
801085a6:	a1 90 9d 11 80       	mov    0x80119d90,%eax
801085ab:	8b 55 f4             	mov    -0xc(%ebp),%edx
801085ae:	29 d0                	sub    %edx,%eax
801085b0:	8b 0d 8c 9d 11 80    	mov    0x80119d8c,%ecx
801085b6:	8b 55 f4             	mov    -0xc(%ebp),%edx
801085b9:	01 ca                	add    %ecx,%edx
801085bb:	89 d1                	mov    %edx,%ecx
801085bd:	8b 15 8c 9d 11 80    	mov    0x80119d8c,%edx
801085c3:	83 ec 04             	sub    $0x4,%esp
801085c6:	50                   	push   %eax
801085c7:	51                   	push   %ecx
801085c8:	52                   	push   %edx
801085c9:	e8 af cb ff ff       	call   8010517d <memmove>
801085ce:	83 c4 10             	add    $0x10,%esp
  memset((unsigned int *)(gpu.vvram_addr + gpu.vram_size - addr_diff),0,addr_diff);
801085d1:	8b 45 f4             	mov    -0xc(%ebp),%eax
801085d4:	8b 0d 8c 9d 11 80    	mov    0x80119d8c,%ecx
801085da:	8b 15 90 9d 11 80    	mov    0x80119d90,%edx
801085e0:	01 ca                	add    %ecx,%edx
801085e2:	8b 4d f4             	mov    -0xc(%ebp),%ecx
801085e5:	29 ca                	sub    %ecx,%edx
801085e7:	83 ec 04             	sub    $0x4,%esp
801085ea:	50                   	push   %eax
801085eb:	6a 00                	push   $0x0
801085ed:	52                   	push   %edx
801085ee:	e8 cb ca ff ff       	call   801050be <memset>
801085f3:	83 c4 10             	add    $0x10,%esp
}
801085f6:	90                   	nop
801085f7:	c9                   	leave  
801085f8:	c3                   	ret    

801085f9 <font_render>:
801085f9:	55                   	push   %ebp
801085fa:	89 e5                	mov    %esp,%ebp
801085fc:	53                   	push   %ebx
801085fd:	83 ec 14             	sub    $0x14,%esp
80108600:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80108607:	e9 b1 00 00 00       	jmp    801086bd <font_render+0xc4>
8010860c:	c7 45 f0 0e 00 00 00 	movl   $0xe,-0x10(%ebp)
80108613:	e9 97 00 00 00       	jmp    801086af <font_render+0xb6>
80108618:	8b 45 10             	mov    0x10(%ebp),%eax
8010861b:	83 e8 20             	sub    $0x20,%eax
8010861e:	6b d0 1e             	imul   $0x1e,%eax,%edx
80108621:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108624:	01 d0                	add    %edx,%eax
80108626:	0f b7 84 00 60 ad 10 	movzwl -0x7fef52a0(%eax,%eax,1),%eax
8010862d:	80 
8010862e:	0f b7 d0             	movzwl %ax,%edx
80108631:	8b 45 f0             	mov    -0x10(%ebp),%eax
80108634:	bb 01 00 00 00       	mov    $0x1,%ebx
80108639:	89 c1                	mov    %eax,%ecx
8010863b:	d3 e3                	shl    %cl,%ebx
8010863d:	89 d8                	mov    %ebx,%eax
8010863f:	21 d0                	and    %edx,%eax
80108641:	89 45 ec             	mov    %eax,-0x14(%ebp)
80108644:	8b 45 f0             	mov    -0x10(%ebp),%eax
80108647:	ba 01 00 00 00       	mov    $0x1,%edx
8010864c:	89 c1                	mov    %eax,%ecx
8010864e:	d3 e2                	shl    %cl,%edx
80108650:	89 d0                	mov    %edx,%eax
80108652:	39 45 ec             	cmp    %eax,-0x14(%ebp)
80108655:	75 2b                	jne    80108682 <font_render+0x89>
80108657:	8b 55 0c             	mov    0xc(%ebp),%edx
8010865a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010865d:	01 c2                	add    %eax,%edx
8010865f:	b8 0e 00 00 00       	mov    $0xe,%eax
80108664:	2b 45 f0             	sub    -0x10(%ebp),%eax
80108667:	89 c1                	mov    %eax,%ecx
80108669:	8b 45 08             	mov    0x8(%ebp),%eax
8010866c:	01 c8                	add    %ecx,%eax
8010866e:	83 ec 04             	sub    $0x4,%esp
80108671:	68 e0 f4 10 80       	push   $0x8010f4e0
80108676:	52                   	push   %edx
80108677:	50                   	push   %eax
80108678:	e8 be fe ff ff       	call   8010853b <graphic_draw_pixel>
8010867d:	83 c4 10             	add    $0x10,%esp
80108680:	eb 29                	jmp    801086ab <font_render+0xb2>
80108682:	8b 55 0c             	mov    0xc(%ebp),%edx
80108685:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108688:	01 c2                	add    %eax,%edx
8010868a:	b8 0e 00 00 00       	mov    $0xe,%eax
8010868f:	2b 45 f0             	sub    -0x10(%ebp),%eax
80108692:	89 c1                	mov    %eax,%ecx
80108694:	8b 45 08             	mov    0x8(%ebp),%eax
80108697:	01 c8                	add    %ecx,%eax
80108699:	83 ec 04             	sub    $0x4,%esp
8010869c:	68 a0 9d 11 80       	push   $0x80119da0
801086a1:	52                   	push   %edx
801086a2:	50                   	push   %eax
801086a3:	e8 93 fe ff ff       	call   8010853b <graphic_draw_pixel>
801086a8:	83 c4 10             	add    $0x10,%esp
801086ab:	83 6d f0 01          	subl   $0x1,-0x10(%ebp)
801086af:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
801086b3:	0f 89 5f ff ff ff    	jns    80108618 <font_render+0x1f>
801086b9:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
801086bd:	83 7d f4 1d          	cmpl   $0x1d,-0xc(%ebp)
801086c1:	0f 8e 45 ff ff ff    	jle    8010860c <font_render+0x13>
801086c7:	90                   	nop
801086c8:	90                   	nop
801086c9:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801086cc:	c9                   	leave  
801086cd:	c3                   	ret    

801086ce <font_render_string>:
801086ce:	55                   	push   %ebp
801086cf:	89 e5                	mov    %esp,%ebp
801086d1:	53                   	push   %ebx
801086d2:	83 ec 14             	sub    $0x14,%esp
801086d5:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
801086dc:	eb 33                	jmp    80108711 <font_render_string+0x43>
801086de:	8b 55 f4             	mov    -0xc(%ebp),%edx
801086e1:	8b 45 08             	mov    0x8(%ebp),%eax
801086e4:	01 d0                	add    %edx,%eax
801086e6:	0f b6 00             	movzbl (%eax),%eax
801086e9:	0f be c8             	movsbl %al,%ecx
801086ec:	8b 45 0c             	mov    0xc(%ebp),%eax
801086ef:	6b d0 1e             	imul   $0x1e,%eax,%edx
801086f2:	8b 5d f4             	mov    -0xc(%ebp),%ebx
801086f5:	89 d8                	mov    %ebx,%eax
801086f7:	c1 e0 04             	shl    $0x4,%eax
801086fa:	29 d8                	sub    %ebx,%eax
801086fc:	83 c0 02             	add    $0x2,%eax
801086ff:	83 ec 04             	sub    $0x4,%esp
80108702:	51                   	push   %ecx
80108703:	52                   	push   %edx
80108704:	50                   	push   %eax
80108705:	e8 ef fe ff ff       	call   801085f9 <font_render>
8010870a:	83 c4 10             	add    $0x10,%esp
8010870d:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80108711:	8b 55 f4             	mov    -0xc(%ebp),%edx
80108714:	8b 45 08             	mov    0x8(%ebp),%eax
80108717:	01 d0                	add    %edx,%eax
80108719:	0f b6 00             	movzbl (%eax),%eax
8010871c:	84 c0                	test   %al,%al
8010871e:	74 06                	je     80108726 <font_render_string+0x58>
80108720:	83 7d f4 33          	cmpl   $0x33,-0xc(%ebp)
80108724:	7e b8                	jle    801086de <font_render_string+0x10>
80108726:	90                   	nop
80108727:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010872a:	c9                   	leave  
8010872b:	c3                   	ret    

8010872c <pci_init>:
#include "pci.h"
#include "defs.h"
#include "types.h"
#include "i8254.h"

void pci_init(){
8010872c:	55                   	push   %ebp
8010872d:	89 e5                	mov    %esp,%ebp
8010872f:	53                   	push   %ebx
80108730:	83 ec 14             	sub    $0x14,%esp
  uint data;
  for(int i=0;i<256;i++){
80108733:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
8010873a:	eb 6b                	jmp    801087a7 <pci_init+0x7b>
    for(int j=0;j<32;j++){
8010873c:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
80108743:	eb 58                	jmp    8010879d <pci_init+0x71>
      for(int k=0;k<8;k++){
80108745:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
8010874c:	eb 45                	jmp    80108793 <pci_init+0x67>
      pci_access_config(i,j,k,0,&data);
8010874e:	8b 4d ec             	mov    -0x14(%ebp),%ecx
80108751:	8b 55 f0             	mov    -0x10(%ebp),%edx
80108754:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108757:	83 ec 0c             	sub    $0xc,%esp
8010875a:	8d 5d e8             	lea    -0x18(%ebp),%ebx
8010875d:	53                   	push   %ebx
8010875e:	6a 00                	push   $0x0
80108760:	51                   	push   %ecx
80108761:	52                   	push   %edx
80108762:	50                   	push   %eax
80108763:	e8 b0 00 00 00       	call   80108818 <pci_access_config>
80108768:	83 c4 20             	add    $0x20,%esp
      if((data&0xFFFF) != 0xFFFF){
8010876b:	8b 45 e8             	mov    -0x18(%ebp),%eax
8010876e:	0f b7 c0             	movzwl %ax,%eax
80108771:	3d ff ff 00 00       	cmp    $0xffff,%eax
80108776:	74 17                	je     8010878f <pci_init+0x63>
        pci_init_device(i,j,k);
80108778:	8b 4d ec             	mov    -0x14(%ebp),%ecx
8010877b:	8b 55 f0             	mov    -0x10(%ebp),%edx
8010877e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108781:	83 ec 04             	sub    $0x4,%esp
80108784:	51                   	push   %ecx
80108785:	52                   	push   %edx
80108786:	50                   	push   %eax
80108787:	e8 37 01 00 00       	call   801088c3 <pci_init_device>
8010878c:	83 c4 10             	add    $0x10,%esp
      for(int k=0;k<8;k++){
8010878f:	83 45 ec 01          	addl   $0x1,-0x14(%ebp)
80108793:	83 7d ec 07          	cmpl   $0x7,-0x14(%ebp)
80108797:	7e b5                	jle    8010874e <pci_init+0x22>
    for(int j=0;j<32;j++){
80108799:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
8010879d:	83 7d f0 1f          	cmpl   $0x1f,-0x10(%ebp)
801087a1:	7e a2                	jle    80108745 <pci_init+0x19>
  for(int i=0;i<256;i++){
801087a3:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
801087a7:	81 7d f4 ff 00 00 00 	cmpl   $0xff,-0xc(%ebp)
801087ae:	7e 8c                	jle    8010873c <pci_init+0x10>
      }
      }
    }
  }
}
801087b0:	90                   	nop
801087b1:	90                   	nop
801087b2:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801087b5:	c9                   	leave  
801087b6:	c3                   	ret    

801087b7 <pci_write_config>:

void pci_write_config(uint config){
801087b7:	55                   	push   %ebp
801087b8:	89 e5                	mov    %esp,%ebp
  asm("mov $0xCF8,%%edx\n\t"
801087ba:	8b 45 08             	mov    0x8(%ebp),%eax
801087bd:	ba f8 0c 00 00       	mov    $0xcf8,%edx
801087c2:	89 c0                	mov    %eax,%eax
801087c4:	ef                   	out    %eax,(%dx)
      "mov %0,%%eax\n\t"
      "out %%eax,%%dx\n\t"
      : :"r"(config));
}
801087c5:	90                   	nop
801087c6:	5d                   	pop    %ebp
801087c7:	c3                   	ret    

801087c8 <pci_write_data>:

void pci_write_data(uint config){
801087c8:	55                   	push   %ebp
801087c9:	89 e5                	mov    %esp,%ebp
  asm("mov $0xCFC,%%edx\n\t"
801087cb:	8b 45 08             	mov    0x8(%ebp),%eax
801087ce:	ba fc 0c 00 00       	mov    $0xcfc,%edx
801087d3:	89 c0                	mov    %eax,%eax
801087d5:	ef                   	out    %eax,(%dx)
      "mov %0,%%eax\n\t"
      "out %%eax,%%dx\n\t"
      : :"r"(config));
}
801087d6:	90                   	nop
801087d7:	5d                   	pop    %ebp
801087d8:	c3                   	ret    

801087d9 <pci_read_config>:
uint pci_read_config(){
801087d9:	55                   	push   %ebp
801087da:	89 e5                	mov    %esp,%ebp
801087dc:	83 ec 18             	sub    $0x18,%esp
  uint data;
  asm("mov $0xCFC,%%edx\n\t"
801087df:	ba fc 0c 00 00       	mov    $0xcfc,%edx
801087e4:	ed                   	in     (%dx),%eax
801087e5:	89 45 f4             	mov    %eax,-0xc(%ebp)
      "in %%dx,%%eax\n\t"
      "mov %%eax,%0"
      :"=m"(data):);
  microdelay(200);
801087e8:	83 ec 0c             	sub    $0xc,%esp
801087eb:	68 c8 00 00 00       	push   $0xc8
801087f0:	e8 26 a8 ff ff       	call   8010301b <microdelay>
801087f5:	83 c4 10             	add    $0x10,%esp
  return data;
801087f8:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
801087fb:	c9                   	leave  
801087fc:	c3                   	ret    

801087fd <pci_test>:


void pci_test(){
801087fd:	55                   	push   %ebp
801087fe:	89 e5                	mov    %esp,%ebp
80108800:	83 ec 10             	sub    $0x10,%esp
  uint data = 0x80001804;
80108803:	c7 45 fc 04 18 00 80 	movl   $0x80001804,-0x4(%ebp)
  pci_write_config(data);
8010880a:	ff 75 fc             	push   -0x4(%ebp)
8010880d:	e8 a5 ff ff ff       	call   801087b7 <pci_write_config>
80108812:	83 c4 04             	add    $0x4,%esp
}
80108815:	90                   	nop
80108816:	c9                   	leave  
80108817:	c3                   	ret    

80108818 <pci_access_config>:

void pci_access_config(uint bus_num,uint device_num,uint function_num,uint reg_addr,uint *data){
80108818:	55                   	push   %ebp
80108819:	89 e5                	mov    %esp,%ebp
8010881b:	83 ec 18             	sub    $0x18,%esp
  uint config_addr = ((bus_num & 0xFF)<<16) | ((device_num & 0x1F)<<11) | ((function_num & 0x7)<<8) |
8010881e:	8b 45 08             	mov    0x8(%ebp),%eax
80108821:	c1 e0 10             	shl    $0x10,%eax
80108824:	25 00 00 ff 00       	and    $0xff0000,%eax
80108829:	89 c2                	mov    %eax,%edx
8010882b:	8b 45 0c             	mov    0xc(%ebp),%eax
8010882e:	c1 e0 0b             	shl    $0xb,%eax
80108831:	0f b7 c0             	movzwl %ax,%eax
80108834:	09 c2                	or     %eax,%edx
80108836:	8b 45 10             	mov    0x10(%ebp),%eax
80108839:	c1 e0 08             	shl    $0x8,%eax
8010883c:	25 00 07 00 00       	and    $0x700,%eax
80108841:	09 c2                	or     %eax,%edx
    (reg_addr & 0xFC) | 0x80000000;
80108843:	8b 45 14             	mov    0x14(%ebp),%eax
80108846:	25 fc 00 00 00       	and    $0xfc,%eax
  uint config_addr = ((bus_num & 0xFF)<<16) | ((device_num & 0x1F)<<11) | ((function_num & 0x7)<<8) |
8010884b:	09 d0                	or     %edx,%eax
8010884d:	0d 00 00 00 80       	or     $0x80000000,%eax
80108852:	89 45 f4             	mov    %eax,-0xc(%ebp)
  pci_write_config(config_addr);
80108855:	ff 75 f4             	push   -0xc(%ebp)
80108858:	e8 5a ff ff ff       	call   801087b7 <pci_write_config>
8010885d:	83 c4 04             	add    $0x4,%esp
  *data = pci_read_config();
80108860:	e8 74 ff ff ff       	call   801087d9 <pci_read_config>
80108865:	8b 55 18             	mov    0x18(%ebp),%edx
80108868:	89 02                	mov    %eax,(%edx)
}
8010886a:	90                   	nop
8010886b:	c9                   	leave  
8010886c:	c3                   	ret    

8010886d <pci_write_config_register>:

void pci_write_config_register(uint bus_num,uint device_num,uint function_num,uint reg_addr,uint data){
8010886d:	55                   	push   %ebp
8010886e:	89 e5                	mov    %esp,%ebp
80108870:	83 ec 10             	sub    $0x10,%esp
  uint config_addr = ((bus_num & 0xFF)<<16) | ((device_num & 0x1F)<<11) | ((function_num & 0x7)<<8) |
80108873:	8b 45 08             	mov    0x8(%ebp),%eax
80108876:	c1 e0 10             	shl    $0x10,%eax
80108879:	25 00 00 ff 00       	and    $0xff0000,%eax
8010887e:	89 c2                	mov    %eax,%edx
80108880:	8b 45 0c             	mov    0xc(%ebp),%eax
80108883:	c1 e0 0b             	shl    $0xb,%eax
80108886:	0f b7 c0             	movzwl %ax,%eax
80108889:	09 c2                	or     %eax,%edx
8010888b:	8b 45 10             	mov    0x10(%ebp),%eax
8010888e:	c1 e0 08             	shl    $0x8,%eax
80108891:	25 00 07 00 00       	and    $0x700,%eax
80108896:	09 c2                	or     %eax,%edx
    (reg_addr & 0xFC) | 0x80000000;
80108898:	8b 45 14             	mov    0x14(%ebp),%eax
8010889b:	25 fc 00 00 00       	and    $0xfc,%eax
  uint config_addr = ((bus_num & 0xFF)<<16) | ((device_num & 0x1F)<<11) | ((function_num & 0x7)<<8) |
801088a0:	09 d0                	or     %edx,%eax
801088a2:	0d 00 00 00 80       	or     $0x80000000,%eax
801088a7:	89 45 fc             	mov    %eax,-0x4(%ebp)
  pci_write_config(config_addr);
801088aa:	ff 75 fc             	push   -0x4(%ebp)
801088ad:	e8 05 ff ff ff       	call   801087b7 <pci_write_config>
801088b2:	83 c4 04             	add    $0x4,%esp
  pci_write_data(data);
801088b5:	ff 75 18             	push   0x18(%ebp)
801088b8:	e8 0b ff ff ff       	call   801087c8 <pci_write_data>
801088bd:	83 c4 04             	add    $0x4,%esp
}
801088c0:	90                   	nop
801088c1:	c9                   	leave  
801088c2:	c3                   	ret    

801088c3 <pci_init_device>:

struct pci_dev dev;
void pci_init_device(uint bus_num,uint device_num,uint function_num){
801088c3:	55                   	push   %ebp
801088c4:	89 e5                	mov    %esp,%ebp
801088c6:	53                   	push   %ebx
801088c7:	83 ec 14             	sub    $0x14,%esp
  uint data;
  dev.bus_num = bus_num;
801088ca:	8b 45 08             	mov    0x8(%ebp),%eax
801088cd:	a2 a4 9d 11 80       	mov    %al,0x80119da4
  dev.device_num = device_num;
801088d2:	8b 45 0c             	mov    0xc(%ebp),%eax
801088d5:	a2 a5 9d 11 80       	mov    %al,0x80119da5
  dev.function_num = function_num;
801088da:	8b 45 10             	mov    0x10(%ebp),%eax
801088dd:	a2 a6 9d 11 80       	mov    %al,0x80119da6
  cprintf("PCI Device Found Bus:0x%x Device:0x%x Function:%x\n",bus_num,device_num,function_num);
801088e2:	ff 75 10             	push   0x10(%ebp)
801088e5:	ff 75 0c             	push   0xc(%ebp)
801088e8:	ff 75 08             	push   0x8(%ebp)
801088eb:	68 a4 c3 10 80       	push   $0x8010c3a4
801088f0:	e8 ff 7a ff ff       	call   801003f4 <cprintf>
801088f5:	83 c4 10             	add    $0x10,%esp
  
  pci_access_config(bus_num,device_num,function_num,0,&data);
801088f8:	83 ec 0c             	sub    $0xc,%esp
801088fb:	8d 45 ec             	lea    -0x14(%ebp),%eax
801088fe:	50                   	push   %eax
801088ff:	6a 00                	push   $0x0
80108901:	ff 75 10             	push   0x10(%ebp)
80108904:	ff 75 0c             	push   0xc(%ebp)
80108907:	ff 75 08             	push   0x8(%ebp)
8010890a:	e8 09 ff ff ff       	call   80108818 <pci_access_config>
8010890f:	83 c4 20             	add    $0x20,%esp
  uint device_id = data>>16;
80108912:	8b 45 ec             	mov    -0x14(%ebp),%eax
80108915:	c1 e8 10             	shr    $0x10,%eax
80108918:	89 45 f4             	mov    %eax,-0xc(%ebp)
  uint vendor_id = data&0xFFFF;
8010891b:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010891e:	25 ff ff 00 00       	and    $0xffff,%eax
80108923:	89 45 f0             	mov    %eax,-0x10(%ebp)
  dev.device_id = device_id;
80108926:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108929:	a3 a8 9d 11 80       	mov    %eax,0x80119da8
  dev.vendor_id = vendor_id;
8010892e:	8b 45 f0             	mov    -0x10(%ebp),%eax
80108931:	a3 ac 9d 11 80       	mov    %eax,0x80119dac
  cprintf("  Device ID:0x%x  Vendor ID:0x%x\n",device_id,vendor_id);
80108936:	83 ec 04             	sub    $0x4,%esp
80108939:	ff 75 f0             	push   -0x10(%ebp)
8010893c:	ff 75 f4             	push   -0xc(%ebp)
8010893f:	68 d8 c3 10 80       	push   $0x8010c3d8
80108944:	e8 ab 7a ff ff       	call   801003f4 <cprintf>
80108949:	83 c4 10             	add    $0x10,%esp
  
  pci_access_config(bus_num,device_num,function_num,0x8,&data);
8010894c:	83 ec 0c             	sub    $0xc,%esp
8010894f:	8d 45 ec             	lea    -0x14(%ebp),%eax
80108952:	50                   	push   %eax
80108953:	6a 08                	push   $0x8
80108955:	ff 75 10             	push   0x10(%ebp)
80108958:	ff 75 0c             	push   0xc(%ebp)
8010895b:	ff 75 08             	push   0x8(%ebp)
8010895e:	e8 b5 fe ff ff       	call   80108818 <pci_access_config>
80108963:	83 c4 20             	add    $0x20,%esp
  cprintf("  Base Class:0x%x  Sub Class:0x%x  Interface:0x%x  Revision ID:0x%x\n",
80108966:	8b 45 ec             	mov    -0x14(%ebp),%eax
80108969:	0f b6 c8             	movzbl %al,%ecx
      data>>24,(data>>16)&0xFF,(data>>8)&0xFF,data&0xFF);
8010896c:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010896f:	c1 e8 08             	shr    $0x8,%eax
  cprintf("  Base Class:0x%x  Sub Class:0x%x  Interface:0x%x  Revision ID:0x%x\n",
80108972:	0f b6 d0             	movzbl %al,%edx
      data>>24,(data>>16)&0xFF,(data>>8)&0xFF,data&0xFF);
80108975:	8b 45 ec             	mov    -0x14(%ebp),%eax
80108978:	c1 e8 10             	shr    $0x10,%eax
  cprintf("  Base Class:0x%x  Sub Class:0x%x  Interface:0x%x  Revision ID:0x%x\n",
8010897b:	0f b6 c0             	movzbl %al,%eax
8010897e:	8b 5d ec             	mov    -0x14(%ebp),%ebx
80108981:	c1 eb 18             	shr    $0x18,%ebx
80108984:	83 ec 0c             	sub    $0xc,%esp
80108987:	51                   	push   %ecx
80108988:	52                   	push   %edx
80108989:	50                   	push   %eax
8010898a:	53                   	push   %ebx
8010898b:	68 fc c3 10 80       	push   $0x8010c3fc
80108990:	e8 5f 7a ff ff       	call   801003f4 <cprintf>
80108995:	83 c4 20             	add    $0x20,%esp
  dev.base_class = data>>24;
80108998:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010899b:	c1 e8 18             	shr    $0x18,%eax
8010899e:	a2 b0 9d 11 80       	mov    %al,0x80119db0
  dev.sub_class = (data>>16)&0xFF;
801089a3:	8b 45 ec             	mov    -0x14(%ebp),%eax
801089a6:	c1 e8 10             	shr    $0x10,%eax
801089a9:	a2 b1 9d 11 80       	mov    %al,0x80119db1
  dev.interface = (data>>8)&0xFF;
801089ae:	8b 45 ec             	mov    -0x14(%ebp),%eax
801089b1:	c1 e8 08             	shr    $0x8,%eax
801089b4:	a2 b2 9d 11 80       	mov    %al,0x80119db2
  dev.revision_id = data&0xFF;
801089b9:	8b 45 ec             	mov    -0x14(%ebp),%eax
801089bc:	a2 b3 9d 11 80       	mov    %al,0x80119db3
  
  pci_access_config(bus_num,device_num,function_num,0x10,&data);
801089c1:	83 ec 0c             	sub    $0xc,%esp
801089c4:	8d 45 ec             	lea    -0x14(%ebp),%eax
801089c7:	50                   	push   %eax
801089c8:	6a 10                	push   $0x10
801089ca:	ff 75 10             	push   0x10(%ebp)
801089cd:	ff 75 0c             	push   0xc(%ebp)
801089d0:	ff 75 08             	push   0x8(%ebp)
801089d3:	e8 40 fe ff ff       	call   80108818 <pci_access_config>
801089d8:	83 c4 20             	add    $0x20,%esp
  dev.bar0 = data;
801089db:	8b 45 ec             	mov    -0x14(%ebp),%eax
801089de:	a3 b4 9d 11 80       	mov    %eax,0x80119db4
  pci_access_config(bus_num,device_num,function_num,0x14,&data);
801089e3:	83 ec 0c             	sub    $0xc,%esp
801089e6:	8d 45 ec             	lea    -0x14(%ebp),%eax
801089e9:	50                   	push   %eax
801089ea:	6a 14                	push   $0x14
801089ec:	ff 75 10             	push   0x10(%ebp)
801089ef:	ff 75 0c             	push   0xc(%ebp)
801089f2:	ff 75 08             	push   0x8(%ebp)
801089f5:	e8 1e fe ff ff       	call   80108818 <pci_access_config>
801089fa:	83 c4 20             	add    $0x20,%esp
  dev.bar1 = data;
801089fd:	8b 45 ec             	mov    -0x14(%ebp),%eax
80108a00:	a3 b8 9d 11 80       	mov    %eax,0x80119db8
  if(device_id == I8254_DEVICE_ID && vendor_id == I8254_VENDOR_ID){
80108a05:	81 7d f4 0e 10 00 00 	cmpl   $0x100e,-0xc(%ebp)
80108a0c:	75 5a                	jne    80108a68 <pci_init_device+0x1a5>
80108a0e:	81 7d f0 86 80 00 00 	cmpl   $0x8086,-0x10(%ebp)
80108a15:	75 51                	jne    80108a68 <pci_init_device+0x1a5>
    cprintf("E1000 Ethernet NIC Found\n");
80108a17:	83 ec 0c             	sub    $0xc,%esp
80108a1a:	68 41 c4 10 80       	push   $0x8010c441
80108a1f:	e8 d0 79 ff ff       	call   801003f4 <cprintf>
80108a24:	83 c4 10             	add    $0x10,%esp
    pci_access_config(bus_num,device_num,function_num,0xF0,&data);
80108a27:	83 ec 0c             	sub    $0xc,%esp
80108a2a:	8d 45 ec             	lea    -0x14(%ebp),%eax
80108a2d:	50                   	push   %eax
80108a2e:	68 f0 00 00 00       	push   $0xf0
80108a33:	ff 75 10             	push   0x10(%ebp)
80108a36:	ff 75 0c             	push   0xc(%ebp)
80108a39:	ff 75 08             	push   0x8(%ebp)
80108a3c:	e8 d7 fd ff ff       	call   80108818 <pci_access_config>
80108a41:	83 c4 20             	add    $0x20,%esp
    cprintf("Message Control:%x\n",data);
80108a44:	8b 45 ec             	mov    -0x14(%ebp),%eax
80108a47:	83 ec 08             	sub    $0x8,%esp
80108a4a:	50                   	push   %eax
80108a4b:	68 5b c4 10 80       	push   $0x8010c45b
80108a50:	e8 9f 79 ff ff       	call   801003f4 <cprintf>
80108a55:	83 c4 10             	add    $0x10,%esp
    i8254_init(&dev);
80108a58:	83 ec 0c             	sub    $0xc,%esp
80108a5b:	68 a4 9d 11 80       	push   $0x80119da4
80108a60:	e8 09 00 00 00       	call   80108a6e <i8254_init>
80108a65:	83 c4 10             	add    $0x10,%esp
  }
}
80108a68:	90                   	nop
80108a69:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80108a6c:	c9                   	leave  
80108a6d:	c3                   	ret    

80108a6e <i8254_init>:

uint base_addr;
uchar mac_addr[6] = {0};
uchar my_ip[4] = {10,0,1,10}; 
uint *intr_addr;
void i8254_init(struct pci_dev *dev){
80108a6e:	55                   	push   %ebp
80108a6f:	89 e5                	mov    %esp,%ebp
80108a71:	53                   	push   %ebx
80108a72:	83 ec 14             	sub    $0x14,%esp
  uint cmd_reg;
  //Enable Bus Master
  pci_access_config(dev->bus_num,dev->device_num,dev->function_num,0x04,&cmd_reg);
80108a75:	8b 45 08             	mov    0x8(%ebp),%eax
80108a78:	0f b6 40 02          	movzbl 0x2(%eax),%eax
80108a7c:	0f b6 c8             	movzbl %al,%ecx
80108a7f:	8b 45 08             	mov    0x8(%ebp),%eax
80108a82:	0f b6 40 01          	movzbl 0x1(%eax),%eax
80108a86:	0f b6 d0             	movzbl %al,%edx
80108a89:	8b 45 08             	mov    0x8(%ebp),%eax
80108a8c:	0f b6 00             	movzbl (%eax),%eax
80108a8f:	0f b6 c0             	movzbl %al,%eax
80108a92:	83 ec 0c             	sub    $0xc,%esp
80108a95:	8d 5d ec             	lea    -0x14(%ebp),%ebx
80108a98:	53                   	push   %ebx
80108a99:	6a 04                	push   $0x4
80108a9b:	51                   	push   %ecx
80108a9c:	52                   	push   %edx
80108a9d:	50                   	push   %eax
80108a9e:	e8 75 fd ff ff       	call   80108818 <pci_access_config>
80108aa3:	83 c4 20             	add    $0x20,%esp
  cmd_reg = cmd_reg | PCI_CMD_BUS_MASTER;
80108aa6:	8b 45 ec             	mov    -0x14(%ebp),%eax
80108aa9:	83 c8 04             	or     $0x4,%eax
80108aac:	89 45 ec             	mov    %eax,-0x14(%ebp)
  pci_write_config_register(dev->bus_num,dev->device_num,dev->function_num,0x04,cmd_reg);
80108aaf:	8b 5d ec             	mov    -0x14(%ebp),%ebx
80108ab2:	8b 45 08             	mov    0x8(%ebp),%eax
80108ab5:	0f b6 40 02          	movzbl 0x2(%eax),%eax
80108ab9:	0f b6 c8             	movzbl %al,%ecx
80108abc:	8b 45 08             	mov    0x8(%ebp),%eax
80108abf:	0f b6 40 01          	movzbl 0x1(%eax),%eax
80108ac3:	0f b6 d0             	movzbl %al,%edx
80108ac6:	8b 45 08             	mov    0x8(%ebp),%eax
80108ac9:	0f b6 00             	movzbl (%eax),%eax
80108acc:	0f b6 c0             	movzbl %al,%eax
80108acf:	83 ec 0c             	sub    $0xc,%esp
80108ad2:	53                   	push   %ebx
80108ad3:	6a 04                	push   $0x4
80108ad5:	51                   	push   %ecx
80108ad6:	52                   	push   %edx
80108ad7:	50                   	push   %eax
80108ad8:	e8 90 fd ff ff       	call   8010886d <pci_write_config_register>
80108add:	83 c4 20             	add    $0x20,%esp
  
  base_addr = PCI_P2V(dev->bar0);
80108ae0:	8b 45 08             	mov    0x8(%ebp),%eax
80108ae3:	8b 40 10             	mov    0x10(%eax),%eax
80108ae6:	05 00 00 00 40       	add    $0x40000000,%eax
80108aeb:	a3 bc 9d 11 80       	mov    %eax,0x80119dbc
  uint *ctrl = (uint *)base_addr;
80108af0:	a1 bc 9d 11 80       	mov    0x80119dbc,%eax
80108af5:	89 45 f4             	mov    %eax,-0xc(%ebp)
  //Disable Interrupts
  uint *imc = (uint *)(base_addr+0xD8);
80108af8:	a1 bc 9d 11 80       	mov    0x80119dbc,%eax
80108afd:	05 d8 00 00 00       	add    $0xd8,%eax
80108b02:	89 45 f0             	mov    %eax,-0x10(%ebp)
  *imc = 0xFFFFFFFF;
80108b05:	8b 45 f0             	mov    -0x10(%ebp),%eax
80108b08:	c7 00 ff ff ff ff    	movl   $0xffffffff,(%eax)
  
  //Reset NIC
  *ctrl = *ctrl | I8254_CTRL_RST;
80108b0e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108b11:	8b 00                	mov    (%eax),%eax
80108b13:	0d 00 00 00 04       	or     $0x4000000,%eax
80108b18:	89 c2                	mov    %eax,%edx
80108b1a:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108b1d:	89 10                	mov    %edx,(%eax)

  //Enable Interrupts
  *imc = 0xFFFFFFFF;
80108b1f:	8b 45 f0             	mov    -0x10(%ebp),%eax
80108b22:	c7 00 ff ff ff ff    	movl   $0xffffffff,(%eax)

  //Enable Link
  *ctrl |= I8254_CTRL_SLU;
80108b28:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108b2b:	8b 00                	mov    (%eax),%eax
80108b2d:	83 c8 40             	or     $0x40,%eax
80108b30:	89 c2                	mov    %eax,%edx
80108b32:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108b35:	89 10                	mov    %edx,(%eax)
  
  //General Configuration
  *ctrl &= (~I8254_CTRL_PHY_RST | ~I8254_CTRL_VME | ~I8254_CTRL_ILOS);
80108b37:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108b3a:	8b 10                	mov    (%eax),%edx
80108b3c:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108b3f:	89 10                	mov    %edx,(%eax)
  cprintf("E1000 General Configuration Done\n");
80108b41:	83 ec 0c             	sub    $0xc,%esp
80108b44:	68 70 c4 10 80       	push   $0x8010c470
80108b49:	e8 a6 78 ff ff       	call   801003f4 <cprintf>
80108b4e:	83 c4 10             	add    $0x10,%esp
  intr_addr = (uint *)kalloc();
80108b51:	e8 2e a1 ff ff       	call   80102c84 <kalloc>
80108b56:	a3 c8 9d 11 80       	mov    %eax,0x80119dc8
  *intr_addr = 0;
80108b5b:	a1 c8 9d 11 80       	mov    0x80119dc8,%eax
80108b60:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  cprintf("INTR_ADDR:%x\n",intr_addr);
80108b66:	a1 c8 9d 11 80       	mov    0x80119dc8,%eax
80108b6b:	83 ec 08             	sub    $0x8,%esp
80108b6e:	50                   	push   %eax
80108b6f:	68 92 c4 10 80       	push   $0x8010c492
80108b74:	e8 7b 78 ff ff       	call   801003f4 <cprintf>
80108b79:	83 c4 10             	add    $0x10,%esp
  i8254_init_recv();
80108b7c:	e8 50 00 00 00       	call   80108bd1 <i8254_init_recv>
  i8254_init_send();
80108b81:	e8 69 03 00 00       	call   80108eef <i8254_init_send>
  cprintf("IP Address %d.%d.%d.%d\n",
      my_ip[0],
      my_ip[1],
      my_ip[2],
      my_ip[3]);
80108b86:	0f b6 05 e7 f4 10 80 	movzbl 0x8010f4e7,%eax
  cprintf("IP Address %d.%d.%d.%d\n",
80108b8d:	0f b6 d8             	movzbl %al,%ebx
      my_ip[2],
80108b90:	0f b6 05 e6 f4 10 80 	movzbl 0x8010f4e6,%eax
  cprintf("IP Address %d.%d.%d.%d\n",
80108b97:	0f b6 c8             	movzbl %al,%ecx
      my_ip[1],
80108b9a:	0f b6 05 e5 f4 10 80 	movzbl 0x8010f4e5,%eax
  cprintf("IP Address %d.%d.%d.%d\n",
80108ba1:	0f b6 d0             	movzbl %al,%edx
      my_ip[0],
80108ba4:	0f b6 05 e4 f4 10 80 	movzbl 0x8010f4e4,%eax
  cprintf("IP Address %d.%d.%d.%d\n",
80108bab:	0f b6 c0             	movzbl %al,%eax
80108bae:	83 ec 0c             	sub    $0xc,%esp
80108bb1:	53                   	push   %ebx
80108bb2:	51                   	push   %ecx
80108bb3:	52                   	push   %edx
80108bb4:	50                   	push   %eax
80108bb5:	68 a0 c4 10 80       	push   $0x8010c4a0
80108bba:	e8 35 78 ff ff       	call   801003f4 <cprintf>
80108bbf:	83 c4 20             	add    $0x20,%esp
  *imc = 0x0;
80108bc2:	8b 45 f0             	mov    -0x10(%ebp),%eax
80108bc5:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
}
80108bcb:	90                   	nop
80108bcc:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80108bcf:	c9                   	leave  
80108bd0:	c3                   	ret    

80108bd1 <i8254_init_recv>:

void i8254_init_recv(){
80108bd1:	55                   	push   %ebp
80108bd2:	89 e5                	mov    %esp,%ebp
80108bd4:	57                   	push   %edi
80108bd5:	56                   	push   %esi
80108bd6:	53                   	push   %ebx
80108bd7:	83 ec 6c             	sub    $0x6c,%esp
  
  uint data_l = i8254_read_eeprom(0x0);
80108bda:	83 ec 0c             	sub    $0xc,%esp
80108bdd:	6a 00                	push   $0x0
80108bdf:	e8 e8 04 00 00       	call   801090cc <i8254_read_eeprom>
80108be4:	83 c4 10             	add    $0x10,%esp
80108be7:	89 45 d8             	mov    %eax,-0x28(%ebp)
  mac_addr[0] = data_l&0xFF;
80108bea:	8b 45 d8             	mov    -0x28(%ebp),%eax
80108bed:	a2 c0 9d 11 80       	mov    %al,0x80119dc0
  mac_addr[1] = data_l>>8;
80108bf2:	8b 45 d8             	mov    -0x28(%ebp),%eax
80108bf5:	c1 e8 08             	shr    $0x8,%eax
80108bf8:	a2 c1 9d 11 80       	mov    %al,0x80119dc1
  uint data_m = i8254_read_eeprom(0x1);
80108bfd:	83 ec 0c             	sub    $0xc,%esp
80108c00:	6a 01                	push   $0x1
80108c02:	e8 c5 04 00 00       	call   801090cc <i8254_read_eeprom>
80108c07:	83 c4 10             	add    $0x10,%esp
80108c0a:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  mac_addr[2] = data_m&0xFF;
80108c0d:	8b 45 d4             	mov    -0x2c(%ebp),%eax
80108c10:	a2 c2 9d 11 80       	mov    %al,0x80119dc2
  mac_addr[3] = data_m>>8;
80108c15:	8b 45 d4             	mov    -0x2c(%ebp),%eax
80108c18:	c1 e8 08             	shr    $0x8,%eax
80108c1b:	a2 c3 9d 11 80       	mov    %al,0x80119dc3
  uint data_h = i8254_read_eeprom(0x2);
80108c20:	83 ec 0c             	sub    $0xc,%esp
80108c23:	6a 02                	push   $0x2
80108c25:	e8 a2 04 00 00       	call   801090cc <i8254_read_eeprom>
80108c2a:	83 c4 10             	add    $0x10,%esp
80108c2d:	89 45 d0             	mov    %eax,-0x30(%ebp)
  mac_addr[4] = data_h&0xFF;
80108c30:	8b 45 d0             	mov    -0x30(%ebp),%eax
80108c33:	a2 c4 9d 11 80       	mov    %al,0x80119dc4
  mac_addr[5] = data_h>>8;
80108c38:	8b 45 d0             	mov    -0x30(%ebp),%eax
80108c3b:	c1 e8 08             	shr    $0x8,%eax
80108c3e:	a2 c5 9d 11 80       	mov    %al,0x80119dc5
      mac_addr[0],
      mac_addr[1],
      mac_addr[2],
      mac_addr[3],
      mac_addr[4],
      mac_addr[5]);
80108c43:	0f b6 05 c5 9d 11 80 	movzbl 0x80119dc5,%eax
  cprintf("MAC Address %x:%x:%x:%x:%x:%x\n",
80108c4a:	0f b6 f8             	movzbl %al,%edi
      mac_addr[4],
80108c4d:	0f b6 05 c4 9d 11 80 	movzbl 0x80119dc4,%eax
  cprintf("MAC Address %x:%x:%x:%x:%x:%x\n",
80108c54:	0f b6 f0             	movzbl %al,%esi
      mac_addr[3],
80108c57:	0f b6 05 c3 9d 11 80 	movzbl 0x80119dc3,%eax
  cprintf("MAC Address %x:%x:%x:%x:%x:%x\n",
80108c5e:	0f b6 d8             	movzbl %al,%ebx
      mac_addr[2],
80108c61:	0f b6 05 c2 9d 11 80 	movzbl 0x80119dc2,%eax
  cprintf("MAC Address %x:%x:%x:%x:%x:%x\n",
80108c68:	0f b6 c8             	movzbl %al,%ecx
      mac_addr[1],
80108c6b:	0f b6 05 c1 9d 11 80 	movzbl 0x80119dc1,%eax
  cprintf("MAC Address %x:%x:%x:%x:%x:%x\n",
80108c72:	0f b6 d0             	movzbl %al,%edx
      mac_addr[0],
80108c75:	0f b6 05 c0 9d 11 80 	movzbl 0x80119dc0,%eax
  cprintf("MAC Address %x:%x:%x:%x:%x:%x\n",
80108c7c:	0f b6 c0             	movzbl %al,%eax
80108c7f:	83 ec 04             	sub    $0x4,%esp
80108c82:	57                   	push   %edi
80108c83:	56                   	push   %esi
80108c84:	53                   	push   %ebx
80108c85:	51                   	push   %ecx
80108c86:	52                   	push   %edx
80108c87:	50                   	push   %eax
80108c88:	68 b8 c4 10 80       	push   $0x8010c4b8
80108c8d:	e8 62 77 ff ff       	call   801003f4 <cprintf>
80108c92:	83 c4 20             	add    $0x20,%esp

  uint *ral = (uint *)(base_addr + 0x5400);
80108c95:	a1 bc 9d 11 80       	mov    0x80119dbc,%eax
80108c9a:	05 00 54 00 00       	add    $0x5400,%eax
80108c9f:	89 45 cc             	mov    %eax,-0x34(%ebp)
  uint *rah = (uint *)(base_addr + 0x5404);
80108ca2:	a1 bc 9d 11 80       	mov    0x80119dbc,%eax
80108ca7:	05 04 54 00 00       	add    $0x5404,%eax
80108cac:	89 45 c8             	mov    %eax,-0x38(%ebp)

  *ral = (data_l | (data_m << 16));
80108caf:	8b 45 d4             	mov    -0x2c(%ebp),%eax
80108cb2:	c1 e0 10             	shl    $0x10,%eax
80108cb5:	0b 45 d8             	or     -0x28(%ebp),%eax
80108cb8:	89 c2                	mov    %eax,%edx
80108cba:	8b 45 cc             	mov    -0x34(%ebp),%eax
80108cbd:	89 10                	mov    %edx,(%eax)
  *rah = (data_h | I8254_RAH_AS_DEST | I8254_RAH_AV);
80108cbf:	8b 45 d0             	mov    -0x30(%ebp),%eax
80108cc2:	0d 00 00 00 80       	or     $0x80000000,%eax
80108cc7:	89 c2                	mov    %eax,%edx
80108cc9:	8b 45 c8             	mov    -0x38(%ebp),%eax
80108ccc:	89 10                	mov    %edx,(%eax)

  uint *mta = (uint *)(base_addr + 0x5200);
80108cce:	a1 bc 9d 11 80       	mov    0x80119dbc,%eax
80108cd3:	05 00 52 00 00       	add    $0x5200,%eax
80108cd8:	89 45 c4             	mov    %eax,-0x3c(%ebp)
  for(int i=0;i<128;i++){
80108cdb:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
80108ce2:	eb 19                	jmp    80108cfd <i8254_init_recv+0x12c>
    mta[i] = 0;
80108ce4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80108ce7:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80108cee:	8b 45 c4             	mov    -0x3c(%ebp),%eax
80108cf1:	01 d0                	add    %edx,%eax
80108cf3:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  for(int i=0;i<128;i++){
80108cf9:	83 45 e4 01          	addl   $0x1,-0x1c(%ebp)
80108cfd:	83 7d e4 7f          	cmpl   $0x7f,-0x1c(%ebp)
80108d01:	7e e1                	jle    80108ce4 <i8254_init_recv+0x113>
  }

  uint *ims = (uint *)(base_addr + 0xD0);
80108d03:	a1 bc 9d 11 80       	mov    0x80119dbc,%eax
80108d08:	05 d0 00 00 00       	add    $0xd0,%eax
80108d0d:	89 45 c0             	mov    %eax,-0x40(%ebp)
  *ims = (I8254_IMS_RXT0 | I8254_IMS_RXDMT0 | I8254_IMS_RXSEQ | I8254_IMS_LSC | I8254_IMS_RXO);
80108d10:	8b 45 c0             	mov    -0x40(%ebp),%eax
80108d13:	c7 00 dc 00 00 00    	movl   $0xdc,(%eax)
  uint *ics = (uint *)(base_addr + 0xC8);
80108d19:	a1 bc 9d 11 80       	mov    0x80119dbc,%eax
80108d1e:	05 c8 00 00 00       	add    $0xc8,%eax
80108d23:	89 45 bc             	mov    %eax,-0x44(%ebp)
  *ics = (I8254_IMS_RXT0 | I8254_IMS_RXDMT0 | I8254_IMS_RXSEQ | I8254_IMS_LSC | I8254_IMS_RXO);
80108d26:	8b 45 bc             	mov    -0x44(%ebp),%eax
80108d29:	c7 00 dc 00 00 00    	movl   $0xdc,(%eax)



  uint *rxdctl = (uint *)(base_addr + 0x2828);
80108d2f:	a1 bc 9d 11 80       	mov    0x80119dbc,%eax
80108d34:	05 28 28 00 00       	add    $0x2828,%eax
80108d39:	89 45 b8             	mov    %eax,-0x48(%ebp)
  *rxdctl = 0;
80108d3c:	8b 45 b8             	mov    -0x48(%ebp),%eax
80108d3f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

  uint *rctl = (uint *)(base_addr + 0x100);
80108d45:	a1 bc 9d 11 80       	mov    0x80119dbc,%eax
80108d4a:	05 00 01 00 00       	add    $0x100,%eax
80108d4f:	89 45 b4             	mov    %eax,-0x4c(%ebp)
  *rctl = (I8254_RCTL_UPE | I8254_RCTL_MPE | I8254_RCTL_BAM | I8254_RCTL_BSIZE | I8254_RCTL_SECRC);
80108d52:	8b 45 b4             	mov    -0x4c(%ebp),%eax
80108d55:	c7 00 18 80 00 04    	movl   $0x4008018,(%eax)

  uint recv_desc_addr = (uint)kalloc();
80108d5b:	e8 24 9f ff ff       	call   80102c84 <kalloc>
80108d60:	89 45 b0             	mov    %eax,-0x50(%ebp)
  uint *rdbal = (uint *)(base_addr + 0x2800);
80108d63:	a1 bc 9d 11 80       	mov    0x80119dbc,%eax
80108d68:	05 00 28 00 00       	add    $0x2800,%eax
80108d6d:	89 45 ac             	mov    %eax,-0x54(%ebp)
  uint *rdbah = (uint *)(base_addr + 0x2804);
80108d70:	a1 bc 9d 11 80       	mov    0x80119dbc,%eax
80108d75:	05 04 28 00 00       	add    $0x2804,%eax
80108d7a:	89 45 a8             	mov    %eax,-0x58(%ebp)
  uint *rdlen = (uint *)(base_addr + 0x2808);
80108d7d:	a1 bc 9d 11 80       	mov    0x80119dbc,%eax
80108d82:	05 08 28 00 00       	add    $0x2808,%eax
80108d87:	89 45 a4             	mov    %eax,-0x5c(%ebp)
  uint *rdh = (uint *)(base_addr + 0x2810);
80108d8a:	a1 bc 9d 11 80       	mov    0x80119dbc,%eax
80108d8f:	05 10 28 00 00       	add    $0x2810,%eax
80108d94:	89 45 a0             	mov    %eax,-0x60(%ebp)
  uint *rdt = (uint *)(base_addr + 0x2818);
80108d97:	a1 bc 9d 11 80       	mov    0x80119dbc,%eax
80108d9c:	05 18 28 00 00       	add    $0x2818,%eax
80108da1:	89 45 9c             	mov    %eax,-0x64(%ebp)

  *rdbal = V2P(recv_desc_addr);
80108da4:	8b 45 b0             	mov    -0x50(%ebp),%eax
80108da7:	8d 90 00 00 00 80    	lea    -0x80000000(%eax),%edx
80108dad:	8b 45 ac             	mov    -0x54(%ebp),%eax
80108db0:	89 10                	mov    %edx,(%eax)
  *rdbah = 0;
80108db2:	8b 45 a8             	mov    -0x58(%ebp),%eax
80108db5:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  *rdlen = sizeof(struct i8254_recv_desc)*I8254_RECV_DESC_NUM;
80108dbb:	8b 45 a4             	mov    -0x5c(%ebp),%eax
80108dbe:	c7 00 00 10 00 00    	movl   $0x1000,(%eax)
  *rdh = 0;
80108dc4:	8b 45 a0             	mov    -0x60(%ebp),%eax
80108dc7:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  *rdt = I8254_RECV_DESC_NUM;
80108dcd:	8b 45 9c             	mov    -0x64(%ebp),%eax
80108dd0:	c7 00 00 01 00 00    	movl   $0x100,(%eax)

  struct i8254_recv_desc *recv_desc = (struct i8254_recv_desc *)recv_desc_addr;
80108dd6:	8b 45 b0             	mov    -0x50(%ebp),%eax
80108dd9:	89 45 98             	mov    %eax,-0x68(%ebp)
  for(int i=0;i<I8254_RECV_DESC_NUM;i++){
80108ddc:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
80108de3:	eb 73                	jmp    80108e58 <i8254_init_recv+0x287>
    recv_desc[i].padding = 0;
80108de5:	8b 45 e0             	mov    -0x20(%ebp),%eax
80108de8:	c1 e0 04             	shl    $0x4,%eax
80108deb:	89 c2                	mov    %eax,%edx
80108ded:	8b 45 98             	mov    -0x68(%ebp),%eax
80108df0:	01 d0                	add    %edx,%eax
80108df2:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
    recv_desc[i].len = 0;
80108df9:	8b 45 e0             	mov    -0x20(%ebp),%eax
80108dfc:	c1 e0 04             	shl    $0x4,%eax
80108dff:	89 c2                	mov    %eax,%edx
80108e01:	8b 45 98             	mov    -0x68(%ebp),%eax
80108e04:	01 d0                	add    %edx,%eax
80108e06:	66 c7 40 08 00 00    	movw   $0x0,0x8(%eax)
    recv_desc[i].chk_sum = 0;
80108e0c:	8b 45 e0             	mov    -0x20(%ebp),%eax
80108e0f:	c1 e0 04             	shl    $0x4,%eax
80108e12:	89 c2                	mov    %eax,%edx
80108e14:	8b 45 98             	mov    -0x68(%ebp),%eax
80108e17:	01 d0                	add    %edx,%eax
80108e19:	66 c7 40 0a 00 00    	movw   $0x0,0xa(%eax)
    recv_desc[i].status = 0;
80108e1f:	8b 45 e0             	mov    -0x20(%ebp),%eax
80108e22:	c1 e0 04             	shl    $0x4,%eax
80108e25:	89 c2                	mov    %eax,%edx
80108e27:	8b 45 98             	mov    -0x68(%ebp),%eax
80108e2a:	01 d0                	add    %edx,%eax
80108e2c:	c6 40 0c 00          	movb   $0x0,0xc(%eax)
    recv_desc[i].errors = 0;
80108e30:	8b 45 e0             	mov    -0x20(%ebp),%eax
80108e33:	c1 e0 04             	shl    $0x4,%eax
80108e36:	89 c2                	mov    %eax,%edx
80108e38:	8b 45 98             	mov    -0x68(%ebp),%eax
80108e3b:	01 d0                	add    %edx,%eax
80108e3d:	c6 40 0d 00          	movb   $0x0,0xd(%eax)
    recv_desc[i].special = 0;
80108e41:	8b 45 e0             	mov    -0x20(%ebp),%eax
80108e44:	c1 e0 04             	shl    $0x4,%eax
80108e47:	89 c2                	mov    %eax,%edx
80108e49:	8b 45 98             	mov    -0x68(%ebp),%eax
80108e4c:	01 d0                	add    %edx,%eax
80108e4e:	66 c7 40 0e 00 00    	movw   $0x0,0xe(%eax)
  for(int i=0;i<I8254_RECV_DESC_NUM;i++){
80108e54:	83 45 e0 01          	addl   $0x1,-0x20(%ebp)
80108e58:	81 7d e0 ff 00 00 00 	cmpl   $0xff,-0x20(%ebp)
80108e5f:	7e 84                	jle    80108de5 <i8254_init_recv+0x214>
  }

  for(int i=0;i<(I8254_RECV_DESC_NUM)/2;i++){
80108e61:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
80108e68:	eb 57                	jmp    80108ec1 <i8254_init_recv+0x2f0>
    uint buf_addr = (uint)kalloc();
80108e6a:	e8 15 9e ff ff       	call   80102c84 <kalloc>
80108e6f:	89 45 94             	mov    %eax,-0x6c(%ebp)
    if(buf_addr == 0){
80108e72:	83 7d 94 00          	cmpl   $0x0,-0x6c(%ebp)
80108e76:	75 12                	jne    80108e8a <i8254_init_recv+0x2b9>
      cprintf("failed to allocate buffer area\n");
80108e78:	83 ec 0c             	sub    $0xc,%esp
80108e7b:	68 d8 c4 10 80       	push   $0x8010c4d8
80108e80:	e8 6f 75 ff ff       	call   801003f4 <cprintf>
80108e85:	83 c4 10             	add    $0x10,%esp
      break;
80108e88:	eb 3d                	jmp    80108ec7 <i8254_init_recv+0x2f6>
    }
    recv_desc[i].buf_addr = V2P(buf_addr);
80108e8a:	8b 45 dc             	mov    -0x24(%ebp),%eax
80108e8d:	c1 e0 04             	shl    $0x4,%eax
80108e90:	89 c2                	mov    %eax,%edx
80108e92:	8b 45 98             	mov    -0x68(%ebp),%eax
80108e95:	01 d0                	add    %edx,%eax
80108e97:	8b 55 94             	mov    -0x6c(%ebp),%edx
80108e9a:	81 c2 00 00 00 80    	add    $0x80000000,%edx
80108ea0:	89 10                	mov    %edx,(%eax)
    recv_desc[i+1].buf_addr = V2P(buf_addr + 0x800);
80108ea2:	8b 45 dc             	mov    -0x24(%ebp),%eax
80108ea5:	83 c0 01             	add    $0x1,%eax
80108ea8:	c1 e0 04             	shl    $0x4,%eax
80108eab:	89 c2                	mov    %eax,%edx
80108ead:	8b 45 98             	mov    -0x68(%ebp),%eax
80108eb0:	01 d0                	add    %edx,%eax
80108eb2:	8b 55 94             	mov    -0x6c(%ebp),%edx
80108eb5:	81 ea 00 f8 ff 7f    	sub    $0x7ffff800,%edx
80108ebb:	89 10                	mov    %edx,(%eax)
  for(int i=0;i<(I8254_RECV_DESC_NUM)/2;i++){
80108ebd:	83 45 dc 01          	addl   $0x1,-0x24(%ebp)
80108ec1:	83 7d dc 7f          	cmpl   $0x7f,-0x24(%ebp)
80108ec5:	7e a3                	jle    80108e6a <i8254_init_recv+0x299>
  }

  *rctl |= I8254_RCTL_EN;
80108ec7:	8b 45 b4             	mov    -0x4c(%ebp),%eax
80108eca:	8b 00                	mov    (%eax),%eax
80108ecc:	83 c8 02             	or     $0x2,%eax
80108ecf:	89 c2                	mov    %eax,%edx
80108ed1:	8b 45 b4             	mov    -0x4c(%ebp),%eax
80108ed4:	89 10                	mov    %edx,(%eax)
  cprintf("E1000 Recieve Initialize Done\n");
80108ed6:	83 ec 0c             	sub    $0xc,%esp
80108ed9:	68 f8 c4 10 80       	push   $0x8010c4f8
80108ede:	e8 11 75 ff ff       	call   801003f4 <cprintf>
80108ee3:	83 c4 10             	add    $0x10,%esp
}
80108ee6:	90                   	nop
80108ee7:	8d 65 f4             	lea    -0xc(%ebp),%esp
80108eea:	5b                   	pop    %ebx
80108eeb:	5e                   	pop    %esi
80108eec:	5f                   	pop    %edi
80108eed:	5d                   	pop    %ebp
80108eee:	c3                   	ret    

80108eef <i8254_init_send>:

void i8254_init_send(){
80108eef:	55                   	push   %ebp
80108ef0:	89 e5                	mov    %esp,%ebp
80108ef2:	83 ec 48             	sub    $0x48,%esp
  uint *txdctl = (uint *)(base_addr + 0x3828);
80108ef5:	a1 bc 9d 11 80       	mov    0x80119dbc,%eax
80108efa:	05 28 38 00 00       	add    $0x3828,%eax
80108eff:	89 45 ec             	mov    %eax,-0x14(%ebp)
  *txdctl = (I8254_TXDCTL_WTHRESH | I8254_TXDCTL_GRAN_DESC);
80108f02:	8b 45 ec             	mov    -0x14(%ebp),%eax
80108f05:	c7 00 00 00 01 01    	movl   $0x1010000,(%eax)

  uint tx_desc_addr = (uint)kalloc();
80108f0b:	e8 74 9d ff ff       	call   80102c84 <kalloc>
80108f10:	89 45 e8             	mov    %eax,-0x18(%ebp)
  uint *tdbal = (uint *)(base_addr + 0x3800);
80108f13:	a1 bc 9d 11 80       	mov    0x80119dbc,%eax
80108f18:	05 00 38 00 00       	add    $0x3800,%eax
80108f1d:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  uint *tdbah = (uint *)(base_addr + 0x3804);
80108f20:	a1 bc 9d 11 80       	mov    0x80119dbc,%eax
80108f25:	05 04 38 00 00       	add    $0x3804,%eax
80108f2a:	89 45 e0             	mov    %eax,-0x20(%ebp)
  uint *tdlen = (uint *)(base_addr + 0x3808);
80108f2d:	a1 bc 9d 11 80       	mov    0x80119dbc,%eax
80108f32:	05 08 38 00 00       	add    $0x3808,%eax
80108f37:	89 45 dc             	mov    %eax,-0x24(%ebp)

  *tdbal = V2P(tx_desc_addr);
80108f3a:	8b 45 e8             	mov    -0x18(%ebp),%eax
80108f3d:	8d 90 00 00 00 80    	lea    -0x80000000(%eax),%edx
80108f43:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80108f46:	89 10                	mov    %edx,(%eax)
  *tdbah = 0;
80108f48:	8b 45 e0             	mov    -0x20(%ebp),%eax
80108f4b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  *tdlen = sizeof(struct i8254_send_desc)*I8254_SEND_DESC_NUM;
80108f51:	8b 45 dc             	mov    -0x24(%ebp),%eax
80108f54:	c7 00 00 10 00 00    	movl   $0x1000,(%eax)
  uint *tdh = (uint *)(base_addr + 0x3810);
80108f5a:	a1 bc 9d 11 80       	mov    0x80119dbc,%eax
80108f5f:	05 10 38 00 00       	add    $0x3810,%eax
80108f64:	89 45 d8             	mov    %eax,-0x28(%ebp)
  uint *tdt = (uint *)(base_addr + 0x3818);
80108f67:	a1 bc 9d 11 80       	mov    0x80119dbc,%eax
80108f6c:	05 18 38 00 00       	add    $0x3818,%eax
80108f71:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  
  *tdh = 0;
80108f74:	8b 45 d8             	mov    -0x28(%ebp),%eax
80108f77:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  *tdt = 0;
80108f7d:	8b 45 d4             	mov    -0x2c(%ebp),%eax
80108f80:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

  struct i8254_send_desc *send_desc = (struct i8254_send_desc *)tx_desc_addr;
80108f86:	8b 45 e8             	mov    -0x18(%ebp),%eax
80108f89:	89 45 d0             	mov    %eax,-0x30(%ebp)
  for(int i=0;i<I8254_SEND_DESC_NUM;i++){
80108f8c:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80108f93:	e9 82 00 00 00       	jmp    8010901a <i8254_init_send+0x12b>
    send_desc[i].padding = 0;
80108f98:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108f9b:	c1 e0 04             	shl    $0x4,%eax
80108f9e:	89 c2                	mov    %eax,%edx
80108fa0:	8b 45 d0             	mov    -0x30(%ebp),%eax
80108fa3:	01 d0                	add    %edx,%eax
80108fa5:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
    send_desc[i].len = 0;
80108fac:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108faf:	c1 e0 04             	shl    $0x4,%eax
80108fb2:	89 c2                	mov    %eax,%edx
80108fb4:	8b 45 d0             	mov    -0x30(%ebp),%eax
80108fb7:	01 d0                	add    %edx,%eax
80108fb9:	66 c7 40 08 00 00    	movw   $0x0,0x8(%eax)
    send_desc[i].cso = 0;
80108fbf:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108fc2:	c1 e0 04             	shl    $0x4,%eax
80108fc5:	89 c2                	mov    %eax,%edx
80108fc7:	8b 45 d0             	mov    -0x30(%ebp),%eax
80108fca:	01 d0                	add    %edx,%eax
80108fcc:	c6 40 0a 00          	movb   $0x0,0xa(%eax)
    send_desc[i].cmd = 0;
80108fd0:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108fd3:	c1 e0 04             	shl    $0x4,%eax
80108fd6:	89 c2                	mov    %eax,%edx
80108fd8:	8b 45 d0             	mov    -0x30(%ebp),%eax
80108fdb:	01 d0                	add    %edx,%eax
80108fdd:	c6 40 0b 00          	movb   $0x0,0xb(%eax)
    send_desc[i].sta = 0;
80108fe1:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108fe4:	c1 e0 04             	shl    $0x4,%eax
80108fe7:	89 c2                	mov    %eax,%edx
80108fe9:	8b 45 d0             	mov    -0x30(%ebp),%eax
80108fec:	01 d0                	add    %edx,%eax
80108fee:	c6 40 0c 00          	movb   $0x0,0xc(%eax)
    send_desc[i].css = 0;
80108ff2:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108ff5:	c1 e0 04             	shl    $0x4,%eax
80108ff8:	89 c2                	mov    %eax,%edx
80108ffa:	8b 45 d0             	mov    -0x30(%ebp),%eax
80108ffd:	01 d0                	add    %edx,%eax
80108fff:	c6 40 0d 00          	movb   $0x0,0xd(%eax)
    send_desc[i].special = 0;
80109003:	8b 45 f4             	mov    -0xc(%ebp),%eax
80109006:	c1 e0 04             	shl    $0x4,%eax
80109009:	89 c2                	mov    %eax,%edx
8010900b:	8b 45 d0             	mov    -0x30(%ebp),%eax
8010900e:	01 d0                	add    %edx,%eax
80109010:	66 c7 40 0e 00 00    	movw   $0x0,0xe(%eax)
  for(int i=0;i<I8254_SEND_DESC_NUM;i++){
80109016:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
8010901a:	81 7d f4 ff 00 00 00 	cmpl   $0xff,-0xc(%ebp)
80109021:	0f 8e 71 ff ff ff    	jle    80108f98 <i8254_init_send+0xa9>
  }

  for(int i=0;i<(I8254_SEND_DESC_NUM)/2;i++){
80109027:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
8010902e:	eb 57                	jmp    80109087 <i8254_init_send+0x198>
    uint buf_addr = (uint)kalloc();
80109030:	e8 4f 9c ff ff       	call   80102c84 <kalloc>
80109035:	89 45 cc             	mov    %eax,-0x34(%ebp)
    if(buf_addr == 0){
80109038:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
8010903c:	75 12                	jne    80109050 <i8254_init_send+0x161>
      cprintf("failed to allocate buffer area\n");
8010903e:	83 ec 0c             	sub    $0xc,%esp
80109041:	68 d8 c4 10 80       	push   $0x8010c4d8
80109046:	e8 a9 73 ff ff       	call   801003f4 <cprintf>
8010904b:	83 c4 10             	add    $0x10,%esp
      break;
8010904e:	eb 3d                	jmp    8010908d <i8254_init_send+0x19e>
    }
    send_desc[i].buf_addr = V2P(buf_addr);
80109050:	8b 45 f0             	mov    -0x10(%ebp),%eax
80109053:	c1 e0 04             	shl    $0x4,%eax
80109056:	89 c2                	mov    %eax,%edx
80109058:	8b 45 d0             	mov    -0x30(%ebp),%eax
8010905b:	01 d0                	add    %edx,%eax
8010905d:	8b 55 cc             	mov    -0x34(%ebp),%edx
80109060:	81 c2 00 00 00 80    	add    $0x80000000,%edx
80109066:	89 10                	mov    %edx,(%eax)
    send_desc[i+1].buf_addr = V2P(buf_addr + 0x800);
80109068:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010906b:	83 c0 01             	add    $0x1,%eax
8010906e:	c1 e0 04             	shl    $0x4,%eax
80109071:	89 c2                	mov    %eax,%edx
80109073:	8b 45 d0             	mov    -0x30(%ebp),%eax
80109076:	01 d0                	add    %edx,%eax
80109078:	8b 55 cc             	mov    -0x34(%ebp),%edx
8010907b:	81 ea 00 f8 ff 7f    	sub    $0x7ffff800,%edx
80109081:	89 10                	mov    %edx,(%eax)
  for(int i=0;i<(I8254_SEND_DESC_NUM)/2;i++){
80109083:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
80109087:	83 7d f0 7f          	cmpl   $0x7f,-0x10(%ebp)
8010908b:	7e a3                	jle    80109030 <i8254_init_send+0x141>
  }

  uint *tctl = (uint *)(base_addr + 0x400);
8010908d:	a1 bc 9d 11 80       	mov    0x80119dbc,%eax
80109092:	05 00 04 00 00       	add    $0x400,%eax
80109097:	89 45 c8             	mov    %eax,-0x38(%ebp)
  *tctl = (I8254_TCTL_EN | I8254_TCTL_PSP | I8254_TCTL_COLD | I8254_TCTL_CT);
8010909a:	8b 45 c8             	mov    -0x38(%ebp),%eax
8010909d:	c7 00 fa 00 04 00    	movl   $0x400fa,(%eax)

  uint *tipg = (uint *)(base_addr + 0x410);
801090a3:	a1 bc 9d 11 80       	mov    0x80119dbc,%eax
801090a8:	05 10 04 00 00       	add    $0x410,%eax
801090ad:	89 45 c4             	mov    %eax,-0x3c(%ebp)
  *tipg = (10 | (10<<10) | (10<<20));
801090b0:	8b 45 c4             	mov    -0x3c(%ebp),%eax
801090b3:	c7 00 0a 28 a0 00    	movl   $0xa0280a,(%eax)
  cprintf("E1000 Transmit Initialize Done\n");
801090b9:	83 ec 0c             	sub    $0xc,%esp
801090bc:	68 18 c5 10 80       	push   $0x8010c518
801090c1:	e8 2e 73 ff ff       	call   801003f4 <cprintf>
801090c6:	83 c4 10             	add    $0x10,%esp

}
801090c9:	90                   	nop
801090ca:	c9                   	leave  
801090cb:	c3                   	ret    

801090cc <i8254_read_eeprom>:
uint i8254_read_eeprom(uint addr){
801090cc:	55                   	push   %ebp
801090cd:	89 e5                	mov    %esp,%ebp
801090cf:	83 ec 18             	sub    $0x18,%esp
  uint *eerd = (uint *)(base_addr + 0x14);
801090d2:	a1 bc 9d 11 80       	mov    0x80119dbc,%eax
801090d7:	83 c0 14             	add    $0x14,%eax
801090da:	89 45 f4             	mov    %eax,-0xc(%ebp)
  *eerd = (((addr & 0xFF) << 8) | 1);
801090dd:	8b 45 08             	mov    0x8(%ebp),%eax
801090e0:	c1 e0 08             	shl    $0x8,%eax
801090e3:	0f b7 c0             	movzwl %ax,%eax
801090e6:	83 c8 01             	or     $0x1,%eax
801090e9:	89 c2                	mov    %eax,%edx
801090eb:	8b 45 f4             	mov    -0xc(%ebp),%eax
801090ee:	89 10                	mov    %edx,(%eax)
  while(1){
    cprintf("");
801090f0:	83 ec 0c             	sub    $0xc,%esp
801090f3:	68 38 c5 10 80       	push   $0x8010c538
801090f8:	e8 f7 72 ff ff       	call   801003f4 <cprintf>
801090fd:	83 c4 10             	add    $0x10,%esp
    volatile uint data = *eerd;
80109100:	8b 45 f4             	mov    -0xc(%ebp),%eax
80109103:	8b 00                	mov    (%eax),%eax
80109105:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if((data & (1<<4)) != 0){
80109108:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010910b:	83 e0 10             	and    $0x10,%eax
8010910e:	85 c0                	test   %eax,%eax
80109110:	75 02                	jne    80109114 <i8254_read_eeprom+0x48>
  while(1){
80109112:	eb dc                	jmp    801090f0 <i8254_read_eeprom+0x24>
      break;
80109114:	90                   	nop
    }
  }

  return (*eerd >> 16) & 0xFFFF;
80109115:	8b 45 f4             	mov    -0xc(%ebp),%eax
80109118:	8b 00                	mov    (%eax),%eax
8010911a:	c1 e8 10             	shr    $0x10,%eax
}
8010911d:	c9                   	leave  
8010911e:	c3                   	ret    

8010911f <i8254_recv>:
void i8254_recv(){
8010911f:	55                   	push   %ebp
80109120:	89 e5                	mov    %esp,%ebp
80109122:	83 ec 28             	sub    $0x28,%esp
  uint *rdh = (uint *)(base_addr + 0x2810);
80109125:	a1 bc 9d 11 80       	mov    0x80119dbc,%eax
8010912a:	05 10 28 00 00       	add    $0x2810,%eax
8010912f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  uint *rdt = (uint *)(base_addr + 0x2818);
80109132:	a1 bc 9d 11 80       	mov    0x80119dbc,%eax
80109137:	05 18 28 00 00       	add    $0x2818,%eax
8010913c:	89 45 f0             	mov    %eax,-0x10(%ebp)
//  uint *torl = (uint *)(base_addr + 0x40C0);
//  uint *tpr = (uint *)(base_addr + 0x40D0);
//  uint *icr = (uint *)(base_addr + 0xC0);
  uint *rdbal = (uint *)(base_addr + 0x2800);
8010913f:	a1 bc 9d 11 80       	mov    0x80119dbc,%eax
80109144:	05 00 28 00 00       	add    $0x2800,%eax
80109149:	89 45 ec             	mov    %eax,-0x14(%ebp)
  struct i8254_recv_desc *recv_desc = (struct i8254_recv_desc *)(P2V(*rdbal));
8010914c:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010914f:	8b 00                	mov    (%eax),%eax
80109151:	05 00 00 00 80       	add    $0x80000000,%eax
80109156:	89 45 e8             	mov    %eax,-0x18(%ebp)
  while(1){
    int rx_available = (I8254_RECV_DESC_NUM - *rdt + *rdh)%I8254_RECV_DESC_NUM;
80109159:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010915c:	8b 10                	mov    (%eax),%edx
8010915e:	8b 45 f0             	mov    -0x10(%ebp),%eax
80109161:	8b 08                	mov    (%eax),%ecx
80109163:	89 d0                	mov    %edx,%eax
80109165:	29 c8                	sub    %ecx,%eax
80109167:	25 ff 00 00 00       	and    $0xff,%eax
8010916c:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(rx_available > 0){
8010916f:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
80109173:	7e 37                	jle    801091ac <i8254_recv+0x8d>
      uint buffer_addr = P2V_WO(recv_desc[*rdt].buf_addr);
80109175:	8b 45 f0             	mov    -0x10(%ebp),%eax
80109178:	8b 00                	mov    (%eax),%eax
8010917a:	c1 e0 04             	shl    $0x4,%eax
8010917d:	89 c2                	mov    %eax,%edx
8010917f:	8b 45 e8             	mov    -0x18(%ebp),%eax
80109182:	01 d0                	add    %edx,%eax
80109184:	8b 00                	mov    (%eax),%eax
80109186:	05 00 00 00 80       	add    $0x80000000,%eax
8010918b:	89 45 e0             	mov    %eax,-0x20(%ebp)
      *rdt = (*rdt + 1)%I8254_RECV_DESC_NUM;
8010918e:	8b 45 f0             	mov    -0x10(%ebp),%eax
80109191:	8b 00                	mov    (%eax),%eax
80109193:	83 c0 01             	add    $0x1,%eax
80109196:	0f b6 d0             	movzbl %al,%edx
80109199:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010919c:	89 10                	mov    %edx,(%eax)
      eth_proc(buffer_addr);
8010919e:	83 ec 0c             	sub    $0xc,%esp
801091a1:	ff 75 e0             	push   -0x20(%ebp)
801091a4:	e8 15 09 00 00       	call   80109abe <eth_proc>
801091a9:	83 c4 10             	add    $0x10,%esp
    }
    if(*rdt == *rdh) {
801091ac:	8b 45 f0             	mov    -0x10(%ebp),%eax
801091af:	8b 10                	mov    (%eax),%edx
801091b1:	8b 45 f4             	mov    -0xc(%ebp),%eax
801091b4:	8b 00                	mov    (%eax),%eax
801091b6:	39 c2                	cmp    %eax,%edx
801091b8:	75 9f                	jne    80109159 <i8254_recv+0x3a>
      (*rdt)--;
801091ba:	8b 45 f0             	mov    -0x10(%ebp),%eax
801091bd:	8b 00                	mov    (%eax),%eax
801091bf:	8d 50 ff             	lea    -0x1(%eax),%edx
801091c2:	8b 45 f0             	mov    -0x10(%ebp),%eax
801091c5:	89 10                	mov    %edx,(%eax)
  while(1){
801091c7:	eb 90                	jmp    80109159 <i8254_recv+0x3a>

801091c9 <i8254_send>:
    }
  }
}

int i8254_send(const uint pkt_addr,uint len){
801091c9:	55                   	push   %ebp
801091ca:	89 e5                	mov    %esp,%ebp
801091cc:	83 ec 28             	sub    $0x28,%esp
  uint *tdh = (uint *)(base_addr + 0x3810);
801091cf:	a1 bc 9d 11 80       	mov    0x80119dbc,%eax
801091d4:	05 10 38 00 00       	add    $0x3810,%eax
801091d9:	89 45 f4             	mov    %eax,-0xc(%ebp)
  uint *tdt = (uint *)(base_addr + 0x3818);
801091dc:	a1 bc 9d 11 80       	mov    0x80119dbc,%eax
801091e1:	05 18 38 00 00       	add    $0x3818,%eax
801091e6:	89 45 f0             	mov    %eax,-0x10(%ebp)
  uint *tdbal = (uint *)(base_addr + 0x3800);
801091e9:	a1 bc 9d 11 80       	mov    0x80119dbc,%eax
801091ee:	05 00 38 00 00       	add    $0x3800,%eax
801091f3:	89 45 ec             	mov    %eax,-0x14(%ebp)
  struct i8254_send_desc *txdesc = (struct i8254_send_desc *)P2V_WO(*tdbal);
801091f6:	8b 45 ec             	mov    -0x14(%ebp),%eax
801091f9:	8b 00                	mov    (%eax),%eax
801091fb:	05 00 00 00 80       	add    $0x80000000,%eax
80109200:	89 45 e8             	mov    %eax,-0x18(%ebp)
  int tx_available = I8254_SEND_DESC_NUM - ((I8254_SEND_DESC_NUM - *tdh + *tdt) % I8254_SEND_DESC_NUM);
80109203:	8b 45 f0             	mov    -0x10(%ebp),%eax
80109206:	8b 10                	mov    (%eax),%edx
80109208:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010920b:	8b 08                	mov    (%eax),%ecx
8010920d:	89 d0                	mov    %edx,%eax
8010920f:	29 c8                	sub    %ecx,%eax
80109211:	0f b6 d0             	movzbl %al,%edx
80109214:	b8 00 01 00 00       	mov    $0x100,%eax
80109219:	29 d0                	sub    %edx,%eax
8010921b:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  uint index = *tdt%I8254_SEND_DESC_NUM;
8010921e:	8b 45 f0             	mov    -0x10(%ebp),%eax
80109221:	8b 00                	mov    (%eax),%eax
80109223:	25 ff 00 00 00       	and    $0xff,%eax
80109228:	89 45 e0             	mov    %eax,-0x20(%ebp)
  if(tx_available > 0) {
8010922b:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
8010922f:	0f 8e a8 00 00 00    	jle    801092dd <i8254_send+0x114>
    memmove(P2V_WO((void *)txdesc[index].buf_addr),(void *)pkt_addr,len);
80109235:	8b 45 08             	mov    0x8(%ebp),%eax
80109238:	8b 55 e0             	mov    -0x20(%ebp),%edx
8010923b:	89 d1                	mov    %edx,%ecx
8010923d:	c1 e1 04             	shl    $0x4,%ecx
80109240:	8b 55 e8             	mov    -0x18(%ebp),%edx
80109243:	01 ca                	add    %ecx,%edx
80109245:	8b 12                	mov    (%edx),%edx
80109247:	81 c2 00 00 00 80    	add    $0x80000000,%edx
8010924d:	83 ec 04             	sub    $0x4,%esp
80109250:	ff 75 0c             	push   0xc(%ebp)
80109253:	50                   	push   %eax
80109254:	52                   	push   %edx
80109255:	e8 23 bf ff ff       	call   8010517d <memmove>
8010925a:	83 c4 10             	add    $0x10,%esp
    txdesc[index].len = len;
8010925d:	8b 45 e0             	mov    -0x20(%ebp),%eax
80109260:	c1 e0 04             	shl    $0x4,%eax
80109263:	89 c2                	mov    %eax,%edx
80109265:	8b 45 e8             	mov    -0x18(%ebp),%eax
80109268:	01 d0                	add    %edx,%eax
8010926a:	8b 55 0c             	mov    0xc(%ebp),%edx
8010926d:	66 89 50 08          	mov    %dx,0x8(%eax)
    txdesc[index].sta = 0;
80109271:	8b 45 e0             	mov    -0x20(%ebp),%eax
80109274:	c1 e0 04             	shl    $0x4,%eax
80109277:	89 c2                	mov    %eax,%edx
80109279:	8b 45 e8             	mov    -0x18(%ebp),%eax
8010927c:	01 d0                	add    %edx,%eax
8010927e:	c6 40 0c 00          	movb   $0x0,0xc(%eax)
    txdesc[index].css = 0;
80109282:	8b 45 e0             	mov    -0x20(%ebp),%eax
80109285:	c1 e0 04             	shl    $0x4,%eax
80109288:	89 c2                	mov    %eax,%edx
8010928a:	8b 45 e8             	mov    -0x18(%ebp),%eax
8010928d:	01 d0                	add    %edx,%eax
8010928f:	c6 40 0d 00          	movb   $0x0,0xd(%eax)
    txdesc[index].cmd = 0xb;
80109293:	8b 45 e0             	mov    -0x20(%ebp),%eax
80109296:	c1 e0 04             	shl    $0x4,%eax
80109299:	89 c2                	mov    %eax,%edx
8010929b:	8b 45 e8             	mov    -0x18(%ebp),%eax
8010929e:	01 d0                	add    %edx,%eax
801092a0:	c6 40 0b 0b          	movb   $0xb,0xb(%eax)
    txdesc[index].special = 0;
801092a4:	8b 45 e0             	mov    -0x20(%ebp),%eax
801092a7:	c1 e0 04             	shl    $0x4,%eax
801092aa:	89 c2                	mov    %eax,%edx
801092ac:	8b 45 e8             	mov    -0x18(%ebp),%eax
801092af:	01 d0                	add    %edx,%eax
801092b1:	66 c7 40 0e 00 00    	movw   $0x0,0xe(%eax)
    txdesc[index].cso = 0;
801092b7:	8b 45 e0             	mov    -0x20(%ebp),%eax
801092ba:	c1 e0 04             	shl    $0x4,%eax
801092bd:	89 c2                	mov    %eax,%edx
801092bf:	8b 45 e8             	mov    -0x18(%ebp),%eax
801092c2:	01 d0                	add    %edx,%eax
801092c4:	c6 40 0a 00          	movb   $0x0,0xa(%eax)
    *tdt = (*tdt + 1)%I8254_SEND_DESC_NUM;
801092c8:	8b 45 f0             	mov    -0x10(%ebp),%eax
801092cb:	8b 00                	mov    (%eax),%eax
801092cd:	83 c0 01             	add    $0x1,%eax
801092d0:	0f b6 d0             	movzbl %al,%edx
801092d3:	8b 45 f0             	mov    -0x10(%ebp),%eax
801092d6:	89 10                	mov    %edx,(%eax)
    return len;
801092d8:	8b 45 0c             	mov    0xc(%ebp),%eax
801092db:	eb 05                	jmp    801092e2 <i8254_send+0x119>
  }else{
    return -1;
801092dd:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  }
  return 0;
}
801092e2:	c9                   	leave  
801092e3:	c3                   	ret    

801092e4 <i8254_intr>:

void i8254_intr(){
801092e4:	55                   	push   %ebp
801092e5:	89 e5                	mov    %esp,%ebp
  *intr_addr = 0xEEEEEE;
801092e7:	a1 c8 9d 11 80       	mov    0x80119dc8,%eax
801092ec:	c7 00 ee ee ee 00    	movl   $0xeeeeee,(%eax)
}
801092f2:	90                   	nop
801092f3:	5d                   	pop    %ebp
801092f4:	c3                   	ret    

801092f5 <arp_proc>:
extern uchar mac_addr[6];
extern uchar my_ip[4];

struct arp_entry arp_table[ARP_TABLE_MAX] = {0};

int arp_proc(uint buffer_addr){
801092f5:	55                   	push   %ebp
801092f6:	89 e5                	mov    %esp,%ebp
801092f8:	83 ec 18             	sub    $0x18,%esp
  struct arp_pkt *arp_p = (struct arp_pkt *)(buffer_addr);
801092fb:	8b 45 08             	mov    0x8(%ebp),%eax
801092fe:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(arp_p->hrd_type != ARP_HARDWARE_TYPE) return -1;
80109301:	8b 45 f4             	mov    -0xc(%ebp),%eax
80109304:	0f b7 00             	movzwl (%eax),%eax
80109307:	66 3d 00 01          	cmp    $0x100,%ax
8010930b:	74 0a                	je     80109317 <arp_proc+0x22>
8010930d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80109312:	e9 4f 01 00 00       	jmp    80109466 <arp_proc+0x171>
  if(arp_p->pro_type != ARP_PROTOCOL_TYPE) return -1;
80109317:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010931a:	0f b7 40 02          	movzwl 0x2(%eax),%eax
8010931e:	66 83 f8 08          	cmp    $0x8,%ax
80109322:	74 0a                	je     8010932e <arp_proc+0x39>
80109324:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80109329:	e9 38 01 00 00       	jmp    80109466 <arp_proc+0x171>
  if(arp_p->hrd_len != 6) return -1;
8010932e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80109331:	0f b6 40 04          	movzbl 0x4(%eax),%eax
80109335:	3c 06                	cmp    $0x6,%al
80109337:	74 0a                	je     80109343 <arp_proc+0x4e>
80109339:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010933e:	e9 23 01 00 00       	jmp    80109466 <arp_proc+0x171>
  if(arp_p->pro_len != 4) return -1;
80109343:	8b 45 f4             	mov    -0xc(%ebp),%eax
80109346:	0f b6 40 05          	movzbl 0x5(%eax),%eax
8010934a:	3c 04                	cmp    $0x4,%al
8010934c:	74 0a                	je     80109358 <arp_proc+0x63>
8010934e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80109353:	e9 0e 01 00 00       	jmp    80109466 <arp_proc+0x171>
  if(memcmp(my_ip,arp_p->dst_ip,4) != 0 && memcmp(my_ip,arp_p->src_ip,4) != 0) return -1;
80109358:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010935b:	83 c0 18             	add    $0x18,%eax
8010935e:	83 ec 04             	sub    $0x4,%esp
80109361:	6a 04                	push   $0x4
80109363:	50                   	push   %eax
80109364:	68 e4 f4 10 80       	push   $0x8010f4e4
80109369:	e8 b7 bd ff ff       	call   80105125 <memcmp>
8010936e:	83 c4 10             	add    $0x10,%esp
80109371:	85 c0                	test   %eax,%eax
80109373:	74 27                	je     8010939c <arp_proc+0xa7>
80109375:	8b 45 f4             	mov    -0xc(%ebp),%eax
80109378:	83 c0 0e             	add    $0xe,%eax
8010937b:	83 ec 04             	sub    $0x4,%esp
8010937e:	6a 04                	push   $0x4
80109380:	50                   	push   %eax
80109381:	68 e4 f4 10 80       	push   $0x8010f4e4
80109386:	e8 9a bd ff ff       	call   80105125 <memcmp>
8010938b:	83 c4 10             	add    $0x10,%esp
8010938e:	85 c0                	test   %eax,%eax
80109390:	74 0a                	je     8010939c <arp_proc+0xa7>
80109392:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80109397:	e9 ca 00 00 00       	jmp    80109466 <arp_proc+0x171>
  if(arp_p->op == ARP_OPS_REQUEST && memcmp(my_ip,arp_p->dst_ip,4) == 0){
8010939c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010939f:	0f b7 40 06          	movzwl 0x6(%eax),%eax
801093a3:	66 3d 00 01          	cmp    $0x100,%ax
801093a7:	75 69                	jne    80109412 <arp_proc+0x11d>
801093a9:	8b 45 f4             	mov    -0xc(%ebp),%eax
801093ac:	83 c0 18             	add    $0x18,%eax
801093af:	83 ec 04             	sub    $0x4,%esp
801093b2:	6a 04                	push   $0x4
801093b4:	50                   	push   %eax
801093b5:	68 e4 f4 10 80       	push   $0x8010f4e4
801093ba:	e8 66 bd ff ff       	call   80105125 <memcmp>
801093bf:	83 c4 10             	add    $0x10,%esp
801093c2:	85 c0                	test   %eax,%eax
801093c4:	75 4c                	jne    80109412 <arp_proc+0x11d>
    uint send = (uint)kalloc();
801093c6:	e8 b9 98 ff ff       	call   80102c84 <kalloc>
801093cb:	89 45 f0             	mov    %eax,-0x10(%ebp)
    uint send_size=0;
801093ce:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
    arp_reply_pkt_create(arp_p,send,&send_size);
801093d5:	83 ec 04             	sub    $0x4,%esp
801093d8:	8d 45 ec             	lea    -0x14(%ebp),%eax
801093db:	50                   	push   %eax
801093dc:	ff 75 f0             	push   -0x10(%ebp)
801093df:	ff 75 f4             	push   -0xc(%ebp)
801093e2:	e8 1f 04 00 00       	call   80109806 <arp_reply_pkt_create>
801093e7:	83 c4 10             	add    $0x10,%esp
    i8254_send(send,send_size);
801093ea:	8b 45 ec             	mov    -0x14(%ebp),%eax
801093ed:	83 ec 08             	sub    $0x8,%esp
801093f0:	50                   	push   %eax
801093f1:	ff 75 f0             	push   -0x10(%ebp)
801093f4:	e8 d0 fd ff ff       	call   801091c9 <i8254_send>
801093f9:	83 c4 10             	add    $0x10,%esp
    kfree((char *)send);
801093fc:	8b 45 f0             	mov    -0x10(%ebp),%eax
801093ff:	83 ec 0c             	sub    $0xc,%esp
80109402:	50                   	push   %eax
80109403:	e8 e2 97 ff ff       	call   80102bea <kfree>
80109408:	83 c4 10             	add    $0x10,%esp
    return ARP_CREATED_REPLY;
8010940b:	b8 02 00 00 00       	mov    $0x2,%eax
80109410:	eb 54                	jmp    80109466 <arp_proc+0x171>
  }else if(arp_p->op == ARP_OPS_REPLY && memcmp(my_ip,arp_p->dst_ip,4) == 0){
80109412:	8b 45 f4             	mov    -0xc(%ebp),%eax
80109415:	0f b7 40 06          	movzwl 0x6(%eax),%eax
80109419:	66 3d 00 02          	cmp    $0x200,%ax
8010941d:	75 42                	jne    80109461 <arp_proc+0x16c>
8010941f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80109422:	83 c0 18             	add    $0x18,%eax
80109425:	83 ec 04             	sub    $0x4,%esp
80109428:	6a 04                	push   $0x4
8010942a:	50                   	push   %eax
8010942b:	68 e4 f4 10 80       	push   $0x8010f4e4
80109430:	e8 f0 bc ff ff       	call   80105125 <memcmp>
80109435:	83 c4 10             	add    $0x10,%esp
80109438:	85 c0                	test   %eax,%eax
8010943a:	75 25                	jne    80109461 <arp_proc+0x16c>
    cprintf("ARP TABLE UPDATED\n");
8010943c:	83 ec 0c             	sub    $0xc,%esp
8010943f:	68 3c c5 10 80       	push   $0x8010c53c
80109444:	e8 ab 6f ff ff       	call   801003f4 <cprintf>
80109449:	83 c4 10             	add    $0x10,%esp
    arp_table_update(arp_p);
8010944c:	83 ec 0c             	sub    $0xc,%esp
8010944f:	ff 75 f4             	push   -0xc(%ebp)
80109452:	e8 af 01 00 00       	call   80109606 <arp_table_update>
80109457:	83 c4 10             	add    $0x10,%esp
    return ARP_UPDATED_TABLE;
8010945a:	b8 01 00 00 00       	mov    $0x1,%eax
8010945f:	eb 05                	jmp    80109466 <arp_proc+0x171>
  }else{
    return -1;
80109461:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  }
}
80109466:	c9                   	leave  
80109467:	c3                   	ret    

80109468 <arp_scan>:

void arp_scan(){
80109468:	55                   	push   %ebp
80109469:	89 e5                	mov    %esp,%ebp
8010946b:	83 ec 18             	sub    $0x18,%esp
  uint send_size;
  for(int i=0;i<256;i++){
8010946e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80109475:	eb 6f                	jmp    801094e6 <arp_scan+0x7e>
    uint send = (uint)kalloc();
80109477:	e8 08 98 ff ff       	call   80102c84 <kalloc>
8010947c:	89 45 ec             	mov    %eax,-0x14(%ebp)
    arp_broadcast(send,&send_size,i);
8010947f:	83 ec 04             	sub    $0x4,%esp
80109482:	ff 75 f4             	push   -0xc(%ebp)
80109485:	8d 45 e8             	lea    -0x18(%ebp),%eax
80109488:	50                   	push   %eax
80109489:	ff 75 ec             	push   -0x14(%ebp)
8010948c:	e8 62 00 00 00       	call   801094f3 <arp_broadcast>
80109491:	83 c4 10             	add    $0x10,%esp
    uint res = i8254_send(send,send_size);
80109494:	8b 45 e8             	mov    -0x18(%ebp),%eax
80109497:	83 ec 08             	sub    $0x8,%esp
8010949a:	50                   	push   %eax
8010949b:	ff 75 ec             	push   -0x14(%ebp)
8010949e:	e8 26 fd ff ff       	call   801091c9 <i8254_send>
801094a3:	83 c4 10             	add    $0x10,%esp
801094a6:	89 45 f0             	mov    %eax,-0x10(%ebp)
    while(res == -1){
801094a9:	eb 22                	jmp    801094cd <arp_scan+0x65>
      microdelay(1);
801094ab:	83 ec 0c             	sub    $0xc,%esp
801094ae:	6a 01                	push   $0x1
801094b0:	e8 66 9b ff ff       	call   8010301b <microdelay>
801094b5:	83 c4 10             	add    $0x10,%esp
      res = i8254_send(send,send_size);
801094b8:	8b 45 e8             	mov    -0x18(%ebp),%eax
801094bb:	83 ec 08             	sub    $0x8,%esp
801094be:	50                   	push   %eax
801094bf:	ff 75 ec             	push   -0x14(%ebp)
801094c2:	e8 02 fd ff ff       	call   801091c9 <i8254_send>
801094c7:	83 c4 10             	add    $0x10,%esp
801094ca:	89 45 f0             	mov    %eax,-0x10(%ebp)
    while(res == -1){
801094cd:	83 7d f0 ff          	cmpl   $0xffffffff,-0x10(%ebp)
801094d1:	74 d8                	je     801094ab <arp_scan+0x43>
    }
    kfree((char *)send);
801094d3:	8b 45 ec             	mov    -0x14(%ebp),%eax
801094d6:	83 ec 0c             	sub    $0xc,%esp
801094d9:	50                   	push   %eax
801094da:	e8 0b 97 ff ff       	call   80102bea <kfree>
801094df:	83 c4 10             	add    $0x10,%esp
  for(int i=0;i<256;i++){
801094e2:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
801094e6:	81 7d f4 ff 00 00 00 	cmpl   $0xff,-0xc(%ebp)
801094ed:	7e 88                	jle    80109477 <arp_scan+0xf>
  }
}
801094ef:	90                   	nop
801094f0:	90                   	nop
801094f1:	c9                   	leave  
801094f2:	c3                   	ret    

801094f3 <arp_broadcast>:

void arp_broadcast(uint send,uint *send_size,uint ip){
801094f3:	55                   	push   %ebp
801094f4:	89 e5                	mov    %esp,%ebp
801094f6:	83 ec 28             	sub    $0x28,%esp
  uchar dst_ip[4] = {10,0,1,ip};
801094f9:	c6 45 ec 0a          	movb   $0xa,-0x14(%ebp)
801094fd:	c6 45 ed 00          	movb   $0x0,-0x13(%ebp)
80109501:	c6 45 ee 01          	movb   $0x1,-0x12(%ebp)
80109505:	8b 45 10             	mov    0x10(%ebp),%eax
80109508:	88 45 ef             	mov    %al,-0x11(%ebp)
  uchar dst_mac_eth[6] = {0xff,0xff,0xff,0xff,0xff,0xff};
8010950b:	c7 45 e6 ff ff ff ff 	movl   $0xffffffff,-0x1a(%ebp)
80109512:	66 c7 45 ea ff ff    	movw   $0xffff,-0x16(%ebp)
  uchar dst_mac_arp[6] = {0,0,0,0,0,0};
80109518:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
8010951f:	66 c7 45 e4 00 00    	movw   $0x0,-0x1c(%ebp)
  
  *send_size = sizeof(struct eth_pkt) + sizeof(struct arp_pkt);
80109525:	8b 45 0c             	mov    0xc(%ebp),%eax
80109528:	c7 00 2c 00 00 00    	movl   $0x2c,(%eax)

  struct eth_pkt *reply_eth = (struct eth_pkt *)send;
8010952e:	8b 45 08             	mov    0x8(%ebp),%eax
80109531:	89 45 f4             	mov    %eax,-0xc(%ebp)
  struct arp_pkt *reply_arp = (struct arp_pkt *)(send + sizeof(struct eth_pkt));
80109534:	8b 45 08             	mov    0x8(%ebp),%eax
80109537:	83 c0 0e             	add    $0xe,%eax
8010953a:	89 45 f0             	mov    %eax,-0x10(%ebp)
  
  reply_eth->type[0] = 0x08;
8010953d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80109540:	c6 40 0c 08          	movb   $0x8,0xc(%eax)
  reply_eth->type[1] = 0x06;
80109544:	8b 45 f4             	mov    -0xc(%ebp),%eax
80109547:	c6 40 0d 06          	movb   $0x6,0xd(%eax)
  memmove(reply_eth->dst_mac,dst_mac_eth,6);
8010954b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010954e:	83 ec 04             	sub    $0x4,%esp
80109551:	6a 06                	push   $0x6
80109553:	8d 55 e6             	lea    -0x1a(%ebp),%edx
80109556:	52                   	push   %edx
80109557:	50                   	push   %eax
80109558:	e8 20 bc ff ff       	call   8010517d <memmove>
8010955d:	83 c4 10             	add    $0x10,%esp
  memmove(reply_eth->src_mac,mac_addr,6);
80109560:	8b 45 f4             	mov    -0xc(%ebp),%eax
80109563:	83 c0 06             	add    $0x6,%eax
80109566:	83 ec 04             	sub    $0x4,%esp
80109569:	6a 06                	push   $0x6
8010956b:	68 c0 9d 11 80       	push   $0x80119dc0
80109570:	50                   	push   %eax
80109571:	e8 07 bc ff ff       	call   8010517d <memmove>
80109576:	83 c4 10             	add    $0x10,%esp

  reply_arp->hrd_type = ARP_HARDWARE_TYPE;
80109579:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010957c:	66 c7 00 00 01       	movw   $0x100,(%eax)
  reply_arp->pro_type = ARP_PROTOCOL_TYPE;
80109581:	8b 45 f0             	mov    -0x10(%ebp),%eax
80109584:	66 c7 40 02 08 00    	movw   $0x8,0x2(%eax)
  reply_arp->hrd_len = 6;
8010958a:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010958d:	c6 40 04 06          	movb   $0x6,0x4(%eax)
  reply_arp->pro_len = 4;
80109591:	8b 45 f0             	mov    -0x10(%ebp),%eax
80109594:	c6 40 05 04          	movb   $0x4,0x5(%eax)
  reply_arp->op = ARP_OPS_REQUEST;
80109598:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010959b:	66 c7 40 06 00 01    	movw   $0x100,0x6(%eax)
  memmove(reply_arp->dst_mac,dst_mac_arp,6);
801095a1:	8b 45 f0             	mov    -0x10(%ebp),%eax
801095a4:	8d 50 12             	lea    0x12(%eax),%edx
801095a7:	83 ec 04             	sub    $0x4,%esp
801095aa:	6a 06                	push   $0x6
801095ac:	8d 45 e0             	lea    -0x20(%ebp),%eax
801095af:	50                   	push   %eax
801095b0:	52                   	push   %edx
801095b1:	e8 c7 bb ff ff       	call   8010517d <memmove>
801095b6:	83 c4 10             	add    $0x10,%esp
  memmove(reply_arp->dst_ip,dst_ip,4);
801095b9:	8b 45 f0             	mov    -0x10(%ebp),%eax
801095bc:	8d 50 18             	lea    0x18(%eax),%edx
801095bf:	83 ec 04             	sub    $0x4,%esp
801095c2:	6a 04                	push   $0x4
801095c4:	8d 45 ec             	lea    -0x14(%ebp),%eax
801095c7:	50                   	push   %eax
801095c8:	52                   	push   %edx
801095c9:	e8 af bb ff ff       	call   8010517d <memmove>
801095ce:	83 c4 10             	add    $0x10,%esp
  memmove(reply_arp->src_mac,mac_addr,6);
801095d1:	8b 45 f0             	mov    -0x10(%ebp),%eax
801095d4:	83 c0 08             	add    $0x8,%eax
801095d7:	83 ec 04             	sub    $0x4,%esp
801095da:	6a 06                	push   $0x6
801095dc:	68 c0 9d 11 80       	push   $0x80119dc0
801095e1:	50                   	push   %eax
801095e2:	e8 96 bb ff ff       	call   8010517d <memmove>
801095e7:	83 c4 10             	add    $0x10,%esp
  memmove(reply_arp->src_ip,my_ip,4);
801095ea:	8b 45 f0             	mov    -0x10(%ebp),%eax
801095ed:	83 c0 0e             	add    $0xe,%eax
801095f0:	83 ec 04             	sub    $0x4,%esp
801095f3:	6a 04                	push   $0x4
801095f5:	68 e4 f4 10 80       	push   $0x8010f4e4
801095fa:	50                   	push   %eax
801095fb:	e8 7d bb ff ff       	call   8010517d <memmove>
80109600:	83 c4 10             	add    $0x10,%esp
}
80109603:	90                   	nop
80109604:	c9                   	leave  
80109605:	c3                   	ret    

80109606 <arp_table_update>:

void arp_table_update(struct arp_pkt *recv_arp){
80109606:	55                   	push   %ebp
80109607:	89 e5                	mov    %esp,%ebp
80109609:	83 ec 18             	sub    $0x18,%esp
  int index = arp_table_search(recv_arp->src_ip);
8010960c:	8b 45 08             	mov    0x8(%ebp),%eax
8010960f:	83 c0 0e             	add    $0xe,%eax
80109612:	83 ec 0c             	sub    $0xc,%esp
80109615:	50                   	push   %eax
80109616:	e8 bc 00 00 00       	call   801096d7 <arp_table_search>
8010961b:	83 c4 10             	add    $0x10,%esp
8010961e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(index > -1){
80109621:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80109625:	78 2d                	js     80109654 <arp_table_update+0x4e>
    memmove(arp_table[index].mac,recv_arp->src_mac,6);
80109627:	8b 45 08             	mov    0x8(%ebp),%eax
8010962a:	8d 48 08             	lea    0x8(%eax),%ecx
8010962d:	8b 55 f4             	mov    -0xc(%ebp),%edx
80109630:	89 d0                	mov    %edx,%eax
80109632:	c1 e0 02             	shl    $0x2,%eax
80109635:	01 d0                	add    %edx,%eax
80109637:	01 c0                	add    %eax,%eax
80109639:	01 d0                	add    %edx,%eax
8010963b:	05 e0 9d 11 80       	add    $0x80119de0,%eax
80109640:	83 c0 04             	add    $0x4,%eax
80109643:	83 ec 04             	sub    $0x4,%esp
80109646:	6a 06                	push   $0x6
80109648:	51                   	push   %ecx
80109649:	50                   	push   %eax
8010964a:	e8 2e bb ff ff       	call   8010517d <memmove>
8010964f:	83 c4 10             	add    $0x10,%esp
80109652:	eb 70                	jmp    801096c4 <arp_table_update+0xbe>
  }else{
    index += 1;
80109654:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
    index = -index;
80109658:	f7 5d f4             	negl   -0xc(%ebp)
    memmove(arp_table[index].mac,recv_arp->src_mac,6);
8010965b:	8b 45 08             	mov    0x8(%ebp),%eax
8010965e:	8d 48 08             	lea    0x8(%eax),%ecx
80109661:	8b 55 f4             	mov    -0xc(%ebp),%edx
80109664:	89 d0                	mov    %edx,%eax
80109666:	c1 e0 02             	shl    $0x2,%eax
80109669:	01 d0                	add    %edx,%eax
8010966b:	01 c0                	add    %eax,%eax
8010966d:	01 d0                	add    %edx,%eax
8010966f:	05 e0 9d 11 80       	add    $0x80119de0,%eax
80109674:	83 c0 04             	add    $0x4,%eax
80109677:	83 ec 04             	sub    $0x4,%esp
8010967a:	6a 06                	push   $0x6
8010967c:	51                   	push   %ecx
8010967d:	50                   	push   %eax
8010967e:	e8 fa ba ff ff       	call   8010517d <memmove>
80109683:	83 c4 10             	add    $0x10,%esp
    memmove(arp_table[index].ip,recv_arp->src_ip,4);
80109686:	8b 45 08             	mov    0x8(%ebp),%eax
80109689:	8d 48 0e             	lea    0xe(%eax),%ecx
8010968c:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010968f:	89 d0                	mov    %edx,%eax
80109691:	c1 e0 02             	shl    $0x2,%eax
80109694:	01 d0                	add    %edx,%eax
80109696:	01 c0                	add    %eax,%eax
80109698:	01 d0                	add    %edx,%eax
8010969a:	05 e0 9d 11 80       	add    $0x80119de0,%eax
8010969f:	83 ec 04             	sub    $0x4,%esp
801096a2:	6a 04                	push   $0x4
801096a4:	51                   	push   %ecx
801096a5:	50                   	push   %eax
801096a6:	e8 d2 ba ff ff       	call   8010517d <memmove>
801096ab:	83 c4 10             	add    $0x10,%esp
    arp_table[index].use = 1;
801096ae:	8b 55 f4             	mov    -0xc(%ebp),%edx
801096b1:	89 d0                	mov    %edx,%eax
801096b3:	c1 e0 02             	shl    $0x2,%eax
801096b6:	01 d0                	add    %edx,%eax
801096b8:	01 c0                	add    %eax,%eax
801096ba:	01 d0                	add    %edx,%eax
801096bc:	05 ea 9d 11 80       	add    $0x80119dea,%eax
801096c1:	c6 00 01             	movb   $0x1,(%eax)
  }
  print_arp_table(arp_table);
801096c4:	83 ec 0c             	sub    $0xc,%esp
801096c7:	68 e0 9d 11 80       	push   $0x80119de0
801096cc:	e8 83 00 00 00       	call   80109754 <print_arp_table>
801096d1:	83 c4 10             	add    $0x10,%esp
}
801096d4:	90                   	nop
801096d5:	c9                   	leave  
801096d6:	c3                   	ret    

801096d7 <arp_table_search>:

int arp_table_search(uchar *ip){
801096d7:	55                   	push   %ebp
801096d8:	89 e5                	mov    %esp,%ebp
801096da:	83 ec 18             	sub    $0x18,%esp
  int empty=1;
801096dd:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
  for(int i=0;i<ARP_TABLE_MAX;i++){
801096e4:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
801096eb:	eb 59                	jmp    80109746 <arp_table_search+0x6f>
    if(memcmp(arp_table[i].ip,ip,4) == 0){
801096ed:	8b 55 f0             	mov    -0x10(%ebp),%edx
801096f0:	89 d0                	mov    %edx,%eax
801096f2:	c1 e0 02             	shl    $0x2,%eax
801096f5:	01 d0                	add    %edx,%eax
801096f7:	01 c0                	add    %eax,%eax
801096f9:	01 d0                	add    %edx,%eax
801096fb:	05 e0 9d 11 80       	add    $0x80119de0,%eax
80109700:	83 ec 04             	sub    $0x4,%esp
80109703:	6a 04                	push   $0x4
80109705:	ff 75 08             	push   0x8(%ebp)
80109708:	50                   	push   %eax
80109709:	e8 17 ba ff ff       	call   80105125 <memcmp>
8010970e:	83 c4 10             	add    $0x10,%esp
80109711:	85 c0                	test   %eax,%eax
80109713:	75 05                	jne    8010971a <arp_table_search+0x43>
      return i;
80109715:	8b 45 f0             	mov    -0x10(%ebp),%eax
80109718:	eb 38                	jmp    80109752 <arp_table_search+0x7b>
    }
    if(arp_table[i].use == 0 && empty == 1){
8010971a:	8b 55 f0             	mov    -0x10(%ebp),%edx
8010971d:	89 d0                	mov    %edx,%eax
8010971f:	c1 e0 02             	shl    $0x2,%eax
80109722:	01 d0                	add    %edx,%eax
80109724:	01 c0                	add    %eax,%eax
80109726:	01 d0                	add    %edx,%eax
80109728:	05 ea 9d 11 80       	add    $0x80119dea,%eax
8010972d:	0f b6 00             	movzbl (%eax),%eax
80109730:	84 c0                	test   %al,%al
80109732:	75 0e                	jne    80109742 <arp_table_search+0x6b>
80109734:	83 7d f4 01          	cmpl   $0x1,-0xc(%ebp)
80109738:	75 08                	jne    80109742 <arp_table_search+0x6b>
      empty = -i;
8010973a:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010973d:	f7 d8                	neg    %eax
8010973f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  for(int i=0;i<ARP_TABLE_MAX;i++){
80109742:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
80109746:	83 7d f0 3f          	cmpl   $0x3f,-0x10(%ebp)
8010974a:	7e a1                	jle    801096ed <arp_table_search+0x16>
    }
  }
  return empty-1;
8010974c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010974f:	83 e8 01             	sub    $0x1,%eax
}
80109752:	c9                   	leave  
80109753:	c3                   	ret    

80109754 <print_arp_table>:

void print_arp_table(){
80109754:	55                   	push   %ebp
80109755:	89 e5                	mov    %esp,%ebp
80109757:	83 ec 18             	sub    $0x18,%esp
  for(int i=0;i < ARP_TABLE_MAX;i++){
8010975a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80109761:	e9 92 00 00 00       	jmp    801097f8 <print_arp_table+0xa4>
    if(arp_table[i].use != 0){
80109766:	8b 55 f4             	mov    -0xc(%ebp),%edx
80109769:	89 d0                	mov    %edx,%eax
8010976b:	c1 e0 02             	shl    $0x2,%eax
8010976e:	01 d0                	add    %edx,%eax
80109770:	01 c0                	add    %eax,%eax
80109772:	01 d0                	add    %edx,%eax
80109774:	05 ea 9d 11 80       	add    $0x80119dea,%eax
80109779:	0f b6 00             	movzbl (%eax),%eax
8010977c:	84 c0                	test   %al,%al
8010977e:	74 74                	je     801097f4 <print_arp_table+0xa0>
      cprintf("Entry Num: %d ",i);
80109780:	83 ec 08             	sub    $0x8,%esp
80109783:	ff 75 f4             	push   -0xc(%ebp)
80109786:	68 4f c5 10 80       	push   $0x8010c54f
8010978b:	e8 64 6c ff ff       	call   801003f4 <cprintf>
80109790:	83 c4 10             	add    $0x10,%esp
      print_ipv4(arp_table[i].ip);
80109793:	8b 55 f4             	mov    -0xc(%ebp),%edx
80109796:	89 d0                	mov    %edx,%eax
80109798:	c1 e0 02             	shl    $0x2,%eax
8010979b:	01 d0                	add    %edx,%eax
8010979d:	01 c0                	add    %eax,%eax
8010979f:	01 d0                	add    %edx,%eax
801097a1:	05 e0 9d 11 80       	add    $0x80119de0,%eax
801097a6:	83 ec 0c             	sub    $0xc,%esp
801097a9:	50                   	push   %eax
801097aa:	e8 54 02 00 00       	call   80109a03 <print_ipv4>
801097af:	83 c4 10             	add    $0x10,%esp
      cprintf(" ");
801097b2:	83 ec 0c             	sub    $0xc,%esp
801097b5:	68 5e c5 10 80       	push   $0x8010c55e
801097ba:	e8 35 6c ff ff       	call   801003f4 <cprintf>
801097bf:	83 c4 10             	add    $0x10,%esp
      print_mac(arp_table[i].mac);
801097c2:	8b 55 f4             	mov    -0xc(%ebp),%edx
801097c5:	89 d0                	mov    %edx,%eax
801097c7:	c1 e0 02             	shl    $0x2,%eax
801097ca:	01 d0                	add    %edx,%eax
801097cc:	01 c0                	add    %eax,%eax
801097ce:	01 d0                	add    %edx,%eax
801097d0:	05 e0 9d 11 80       	add    $0x80119de0,%eax
801097d5:	83 c0 04             	add    $0x4,%eax
801097d8:	83 ec 0c             	sub    $0xc,%esp
801097db:	50                   	push   %eax
801097dc:	e8 70 02 00 00       	call   80109a51 <print_mac>
801097e1:	83 c4 10             	add    $0x10,%esp
      cprintf("\n");
801097e4:	83 ec 0c             	sub    $0xc,%esp
801097e7:	68 60 c5 10 80       	push   $0x8010c560
801097ec:	e8 03 6c ff ff       	call   801003f4 <cprintf>
801097f1:	83 c4 10             	add    $0x10,%esp
  for(int i=0;i < ARP_TABLE_MAX;i++){
801097f4:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
801097f8:	83 7d f4 3f          	cmpl   $0x3f,-0xc(%ebp)
801097fc:	0f 8e 64 ff ff ff    	jle    80109766 <print_arp_table+0x12>
    }
  }
}
80109802:	90                   	nop
80109803:	90                   	nop
80109804:	c9                   	leave  
80109805:	c3                   	ret    

80109806 <arp_reply_pkt_create>:


void arp_reply_pkt_create(struct arp_pkt *arp_recv,uint send,uint *send_size){
80109806:	55                   	push   %ebp
80109807:	89 e5                	mov    %esp,%ebp
80109809:	83 ec 18             	sub    $0x18,%esp
  *send_size = sizeof(struct eth_pkt) + sizeof(struct arp_pkt);
8010980c:	8b 45 10             	mov    0x10(%ebp),%eax
8010980f:	c7 00 2c 00 00 00    	movl   $0x2c,(%eax)
  
  struct eth_pkt *reply_eth = (struct eth_pkt *)send;
80109815:	8b 45 0c             	mov    0xc(%ebp),%eax
80109818:	89 45 f4             	mov    %eax,-0xc(%ebp)
  struct arp_pkt *reply_arp = (struct arp_pkt *)(send + sizeof(struct eth_pkt));
8010981b:	8b 45 0c             	mov    0xc(%ebp),%eax
8010981e:	83 c0 0e             	add    $0xe,%eax
80109821:	89 45 f0             	mov    %eax,-0x10(%ebp)

  reply_eth->type[0] = 0x08;
80109824:	8b 45 f4             	mov    -0xc(%ebp),%eax
80109827:	c6 40 0c 08          	movb   $0x8,0xc(%eax)
  reply_eth->type[1] = 0x06;
8010982b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010982e:	c6 40 0d 06          	movb   $0x6,0xd(%eax)
  memmove(reply_eth->dst_mac,arp_recv->src_mac,6);
80109832:	8b 45 08             	mov    0x8(%ebp),%eax
80109835:	8d 50 08             	lea    0x8(%eax),%edx
80109838:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010983b:	83 ec 04             	sub    $0x4,%esp
8010983e:	6a 06                	push   $0x6
80109840:	52                   	push   %edx
80109841:	50                   	push   %eax
80109842:	e8 36 b9 ff ff       	call   8010517d <memmove>
80109847:	83 c4 10             	add    $0x10,%esp
  memmove(reply_eth->src_mac,mac_addr,6);
8010984a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010984d:	83 c0 06             	add    $0x6,%eax
80109850:	83 ec 04             	sub    $0x4,%esp
80109853:	6a 06                	push   $0x6
80109855:	68 c0 9d 11 80       	push   $0x80119dc0
8010985a:	50                   	push   %eax
8010985b:	e8 1d b9 ff ff       	call   8010517d <memmove>
80109860:	83 c4 10             	add    $0x10,%esp

  reply_arp->hrd_type = ARP_HARDWARE_TYPE;
80109863:	8b 45 f0             	mov    -0x10(%ebp),%eax
80109866:	66 c7 00 00 01       	movw   $0x100,(%eax)
  reply_arp->pro_type = ARP_PROTOCOL_TYPE;
8010986b:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010986e:	66 c7 40 02 08 00    	movw   $0x8,0x2(%eax)
  reply_arp->hrd_len = 6;
80109874:	8b 45 f0             	mov    -0x10(%ebp),%eax
80109877:	c6 40 04 06          	movb   $0x6,0x4(%eax)
  reply_arp->pro_len = 4;
8010987b:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010987e:	c6 40 05 04          	movb   $0x4,0x5(%eax)
  reply_arp->op = ARP_OPS_REPLY;
80109882:	8b 45 f0             	mov    -0x10(%ebp),%eax
80109885:	66 c7 40 06 00 02    	movw   $0x200,0x6(%eax)
  memmove(reply_arp->dst_mac,arp_recv->src_mac,6);
8010988b:	8b 45 08             	mov    0x8(%ebp),%eax
8010988e:	8d 50 08             	lea    0x8(%eax),%edx
80109891:	8b 45 f0             	mov    -0x10(%ebp),%eax
80109894:	83 c0 12             	add    $0x12,%eax
80109897:	83 ec 04             	sub    $0x4,%esp
8010989a:	6a 06                	push   $0x6
8010989c:	52                   	push   %edx
8010989d:	50                   	push   %eax
8010989e:	e8 da b8 ff ff       	call   8010517d <memmove>
801098a3:	83 c4 10             	add    $0x10,%esp
  memmove(reply_arp->dst_ip,arp_recv->src_ip,4);
801098a6:	8b 45 08             	mov    0x8(%ebp),%eax
801098a9:	8d 50 0e             	lea    0xe(%eax),%edx
801098ac:	8b 45 f0             	mov    -0x10(%ebp),%eax
801098af:	83 c0 18             	add    $0x18,%eax
801098b2:	83 ec 04             	sub    $0x4,%esp
801098b5:	6a 04                	push   $0x4
801098b7:	52                   	push   %edx
801098b8:	50                   	push   %eax
801098b9:	e8 bf b8 ff ff       	call   8010517d <memmove>
801098be:	83 c4 10             	add    $0x10,%esp
  memmove(reply_arp->src_mac,mac_addr,6);
801098c1:	8b 45 f0             	mov    -0x10(%ebp),%eax
801098c4:	83 c0 08             	add    $0x8,%eax
801098c7:	83 ec 04             	sub    $0x4,%esp
801098ca:	6a 06                	push   $0x6
801098cc:	68 c0 9d 11 80       	push   $0x80119dc0
801098d1:	50                   	push   %eax
801098d2:	e8 a6 b8 ff ff       	call   8010517d <memmove>
801098d7:	83 c4 10             	add    $0x10,%esp
  memmove(reply_arp->src_ip,my_ip,4);
801098da:	8b 45 f0             	mov    -0x10(%ebp),%eax
801098dd:	83 c0 0e             	add    $0xe,%eax
801098e0:	83 ec 04             	sub    $0x4,%esp
801098e3:	6a 04                	push   $0x4
801098e5:	68 e4 f4 10 80       	push   $0x8010f4e4
801098ea:	50                   	push   %eax
801098eb:	e8 8d b8 ff ff       	call   8010517d <memmove>
801098f0:	83 c4 10             	add    $0x10,%esp
}
801098f3:	90                   	nop
801098f4:	c9                   	leave  
801098f5:	c3                   	ret    

801098f6 <print_arp_info>:

void print_arp_info(struct arp_pkt* arp_p){
801098f6:	55                   	push   %ebp
801098f7:	89 e5                	mov    %esp,%ebp
801098f9:	83 ec 08             	sub    $0x8,%esp
  cprintf("--------Source-------\n");
801098fc:	83 ec 0c             	sub    $0xc,%esp
801098ff:	68 62 c5 10 80       	push   $0x8010c562
80109904:	e8 eb 6a ff ff       	call   801003f4 <cprintf>
80109909:	83 c4 10             	add    $0x10,%esp
  print_ipv4(arp_p->src_ip);
8010990c:	8b 45 08             	mov    0x8(%ebp),%eax
8010990f:	83 c0 0e             	add    $0xe,%eax
80109912:	83 ec 0c             	sub    $0xc,%esp
80109915:	50                   	push   %eax
80109916:	e8 e8 00 00 00       	call   80109a03 <print_ipv4>
8010991b:	83 c4 10             	add    $0x10,%esp
  cprintf("\n");
8010991e:	83 ec 0c             	sub    $0xc,%esp
80109921:	68 60 c5 10 80       	push   $0x8010c560
80109926:	e8 c9 6a ff ff       	call   801003f4 <cprintf>
8010992b:	83 c4 10             	add    $0x10,%esp
  print_mac(arp_p->src_mac);
8010992e:	8b 45 08             	mov    0x8(%ebp),%eax
80109931:	83 c0 08             	add    $0x8,%eax
80109934:	83 ec 0c             	sub    $0xc,%esp
80109937:	50                   	push   %eax
80109938:	e8 14 01 00 00       	call   80109a51 <print_mac>
8010993d:	83 c4 10             	add    $0x10,%esp
  cprintf("\n");
80109940:	83 ec 0c             	sub    $0xc,%esp
80109943:	68 60 c5 10 80       	push   $0x8010c560
80109948:	e8 a7 6a ff ff       	call   801003f4 <cprintf>
8010994d:	83 c4 10             	add    $0x10,%esp
  cprintf("-----Destination-----\n");
80109950:	83 ec 0c             	sub    $0xc,%esp
80109953:	68 79 c5 10 80       	push   $0x8010c579
80109958:	e8 97 6a ff ff       	call   801003f4 <cprintf>
8010995d:	83 c4 10             	add    $0x10,%esp
  print_ipv4(arp_p->dst_ip);
80109960:	8b 45 08             	mov    0x8(%ebp),%eax
80109963:	83 c0 18             	add    $0x18,%eax
80109966:	83 ec 0c             	sub    $0xc,%esp
80109969:	50                   	push   %eax
8010996a:	e8 94 00 00 00       	call   80109a03 <print_ipv4>
8010996f:	83 c4 10             	add    $0x10,%esp
  cprintf("\n");
80109972:	83 ec 0c             	sub    $0xc,%esp
80109975:	68 60 c5 10 80       	push   $0x8010c560
8010997a:	e8 75 6a ff ff       	call   801003f4 <cprintf>
8010997f:	83 c4 10             	add    $0x10,%esp
  print_mac(arp_p->dst_mac);
80109982:	8b 45 08             	mov    0x8(%ebp),%eax
80109985:	83 c0 12             	add    $0x12,%eax
80109988:	83 ec 0c             	sub    $0xc,%esp
8010998b:	50                   	push   %eax
8010998c:	e8 c0 00 00 00       	call   80109a51 <print_mac>
80109991:	83 c4 10             	add    $0x10,%esp
  cprintf("\n");
80109994:	83 ec 0c             	sub    $0xc,%esp
80109997:	68 60 c5 10 80       	push   $0x8010c560
8010999c:	e8 53 6a ff ff       	call   801003f4 <cprintf>
801099a1:	83 c4 10             	add    $0x10,%esp
  cprintf("Operation: ");
801099a4:	83 ec 0c             	sub    $0xc,%esp
801099a7:	68 90 c5 10 80       	push   $0x8010c590
801099ac:	e8 43 6a ff ff       	call   801003f4 <cprintf>
801099b1:	83 c4 10             	add    $0x10,%esp
  if(arp_p->op == ARP_OPS_REQUEST) cprintf("Request\n");
801099b4:	8b 45 08             	mov    0x8(%ebp),%eax
801099b7:	0f b7 40 06          	movzwl 0x6(%eax),%eax
801099bb:	66 3d 00 01          	cmp    $0x100,%ax
801099bf:	75 12                	jne    801099d3 <print_arp_info+0xdd>
801099c1:	83 ec 0c             	sub    $0xc,%esp
801099c4:	68 9c c5 10 80       	push   $0x8010c59c
801099c9:	e8 26 6a ff ff       	call   801003f4 <cprintf>
801099ce:	83 c4 10             	add    $0x10,%esp
801099d1:	eb 1d                	jmp    801099f0 <print_arp_info+0xfa>
  else if(arp_p->op == ARP_OPS_REPLY) {
801099d3:	8b 45 08             	mov    0x8(%ebp),%eax
801099d6:	0f b7 40 06          	movzwl 0x6(%eax),%eax
801099da:	66 3d 00 02          	cmp    $0x200,%ax
801099de:	75 10                	jne    801099f0 <print_arp_info+0xfa>
    cprintf("Reply\n");
801099e0:	83 ec 0c             	sub    $0xc,%esp
801099e3:	68 a5 c5 10 80       	push   $0x8010c5a5
801099e8:	e8 07 6a ff ff       	call   801003f4 <cprintf>
801099ed:	83 c4 10             	add    $0x10,%esp
  }
  cprintf("\n");
801099f0:	83 ec 0c             	sub    $0xc,%esp
801099f3:	68 60 c5 10 80       	push   $0x8010c560
801099f8:	e8 f7 69 ff ff       	call   801003f4 <cprintf>
801099fd:	83 c4 10             	add    $0x10,%esp
}
80109a00:	90                   	nop
80109a01:	c9                   	leave  
80109a02:	c3                   	ret    

80109a03 <print_ipv4>:

void print_ipv4(uchar *ip){
80109a03:	55                   	push   %ebp
80109a04:	89 e5                	mov    %esp,%ebp
80109a06:	53                   	push   %ebx
80109a07:	83 ec 04             	sub    $0x4,%esp
  cprintf("IP address: %d.%d.%d.%d",ip[0],ip[1],ip[2],ip[3]);
80109a0a:	8b 45 08             	mov    0x8(%ebp),%eax
80109a0d:	83 c0 03             	add    $0x3,%eax
80109a10:	0f b6 00             	movzbl (%eax),%eax
80109a13:	0f b6 d8             	movzbl %al,%ebx
80109a16:	8b 45 08             	mov    0x8(%ebp),%eax
80109a19:	83 c0 02             	add    $0x2,%eax
80109a1c:	0f b6 00             	movzbl (%eax),%eax
80109a1f:	0f b6 c8             	movzbl %al,%ecx
80109a22:	8b 45 08             	mov    0x8(%ebp),%eax
80109a25:	83 c0 01             	add    $0x1,%eax
80109a28:	0f b6 00             	movzbl (%eax),%eax
80109a2b:	0f b6 d0             	movzbl %al,%edx
80109a2e:	8b 45 08             	mov    0x8(%ebp),%eax
80109a31:	0f b6 00             	movzbl (%eax),%eax
80109a34:	0f b6 c0             	movzbl %al,%eax
80109a37:	83 ec 0c             	sub    $0xc,%esp
80109a3a:	53                   	push   %ebx
80109a3b:	51                   	push   %ecx
80109a3c:	52                   	push   %edx
80109a3d:	50                   	push   %eax
80109a3e:	68 ac c5 10 80       	push   $0x8010c5ac
80109a43:	e8 ac 69 ff ff       	call   801003f4 <cprintf>
80109a48:	83 c4 20             	add    $0x20,%esp
}
80109a4b:	90                   	nop
80109a4c:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80109a4f:	c9                   	leave  
80109a50:	c3                   	ret    

80109a51 <print_mac>:

void print_mac(uchar *mac){
80109a51:	55                   	push   %ebp
80109a52:	89 e5                	mov    %esp,%ebp
80109a54:	57                   	push   %edi
80109a55:	56                   	push   %esi
80109a56:	53                   	push   %ebx
80109a57:	83 ec 0c             	sub    $0xc,%esp
  cprintf("MAC address: %x:%x:%x:%x:%x:%x",mac[0],mac[1],mac[2],mac[3],mac[4],mac[5]);
80109a5a:	8b 45 08             	mov    0x8(%ebp),%eax
80109a5d:	83 c0 05             	add    $0x5,%eax
80109a60:	0f b6 00             	movzbl (%eax),%eax
80109a63:	0f b6 f8             	movzbl %al,%edi
80109a66:	8b 45 08             	mov    0x8(%ebp),%eax
80109a69:	83 c0 04             	add    $0x4,%eax
80109a6c:	0f b6 00             	movzbl (%eax),%eax
80109a6f:	0f b6 f0             	movzbl %al,%esi
80109a72:	8b 45 08             	mov    0x8(%ebp),%eax
80109a75:	83 c0 03             	add    $0x3,%eax
80109a78:	0f b6 00             	movzbl (%eax),%eax
80109a7b:	0f b6 d8             	movzbl %al,%ebx
80109a7e:	8b 45 08             	mov    0x8(%ebp),%eax
80109a81:	83 c0 02             	add    $0x2,%eax
80109a84:	0f b6 00             	movzbl (%eax),%eax
80109a87:	0f b6 c8             	movzbl %al,%ecx
80109a8a:	8b 45 08             	mov    0x8(%ebp),%eax
80109a8d:	83 c0 01             	add    $0x1,%eax
80109a90:	0f b6 00             	movzbl (%eax),%eax
80109a93:	0f b6 d0             	movzbl %al,%edx
80109a96:	8b 45 08             	mov    0x8(%ebp),%eax
80109a99:	0f b6 00             	movzbl (%eax),%eax
80109a9c:	0f b6 c0             	movzbl %al,%eax
80109a9f:	83 ec 04             	sub    $0x4,%esp
80109aa2:	57                   	push   %edi
80109aa3:	56                   	push   %esi
80109aa4:	53                   	push   %ebx
80109aa5:	51                   	push   %ecx
80109aa6:	52                   	push   %edx
80109aa7:	50                   	push   %eax
80109aa8:	68 c4 c5 10 80       	push   $0x8010c5c4
80109aad:	e8 42 69 ff ff       	call   801003f4 <cprintf>
80109ab2:	83 c4 20             	add    $0x20,%esp
}
80109ab5:	90                   	nop
80109ab6:	8d 65 f4             	lea    -0xc(%ebp),%esp
80109ab9:	5b                   	pop    %ebx
80109aba:	5e                   	pop    %esi
80109abb:	5f                   	pop    %edi
80109abc:	5d                   	pop    %ebp
80109abd:	c3                   	ret    

80109abe <eth_proc>:
#include "arp.h"
#include "types.h"
#include "eth.h"
#include "defs.h"
#include "ipv4.h"
void eth_proc(uint buffer_addr){
80109abe:	55                   	push   %ebp
80109abf:	89 e5                	mov    %esp,%ebp
80109ac1:	83 ec 18             	sub    $0x18,%esp
  struct eth_pkt *eth_pkt = (struct eth_pkt *)buffer_addr;
80109ac4:	8b 45 08             	mov    0x8(%ebp),%eax
80109ac7:	89 45 f4             	mov    %eax,-0xc(%ebp)
  uint pkt_addr = buffer_addr+sizeof(struct eth_pkt);
80109aca:	8b 45 08             	mov    0x8(%ebp),%eax
80109acd:	83 c0 0e             	add    $0xe,%eax
80109ad0:	89 45 f0             	mov    %eax,-0x10(%ebp)
  if(eth_pkt->type[0] == 0x08 && eth_pkt->type[1] == 0x06){
80109ad3:	8b 45 f4             	mov    -0xc(%ebp),%eax
80109ad6:	0f b6 40 0c          	movzbl 0xc(%eax),%eax
80109ada:	3c 08                	cmp    $0x8,%al
80109adc:	75 1b                	jne    80109af9 <eth_proc+0x3b>
80109ade:	8b 45 f4             	mov    -0xc(%ebp),%eax
80109ae1:	0f b6 40 0d          	movzbl 0xd(%eax),%eax
80109ae5:	3c 06                	cmp    $0x6,%al
80109ae7:	75 10                	jne    80109af9 <eth_proc+0x3b>
    arp_proc(pkt_addr);
80109ae9:	83 ec 0c             	sub    $0xc,%esp
80109aec:	ff 75 f0             	push   -0x10(%ebp)
80109aef:	e8 01 f8 ff ff       	call   801092f5 <arp_proc>
80109af4:	83 c4 10             	add    $0x10,%esp
  }else if(eth_pkt->type[0] == 0x08 && eth_pkt->type[1] == 0x00){
    ipv4_proc(buffer_addr);
  }else{
  }
}
80109af7:	eb 24                	jmp    80109b1d <eth_proc+0x5f>
  }else if(eth_pkt->type[0] == 0x08 && eth_pkt->type[1] == 0x00){
80109af9:	8b 45 f4             	mov    -0xc(%ebp),%eax
80109afc:	0f b6 40 0c          	movzbl 0xc(%eax),%eax
80109b00:	3c 08                	cmp    $0x8,%al
80109b02:	75 19                	jne    80109b1d <eth_proc+0x5f>
80109b04:	8b 45 f4             	mov    -0xc(%ebp),%eax
80109b07:	0f b6 40 0d          	movzbl 0xd(%eax),%eax
80109b0b:	84 c0                	test   %al,%al
80109b0d:	75 0e                	jne    80109b1d <eth_proc+0x5f>
    ipv4_proc(buffer_addr);
80109b0f:	83 ec 0c             	sub    $0xc,%esp
80109b12:	ff 75 08             	push   0x8(%ebp)
80109b15:	e8 a3 00 00 00       	call   80109bbd <ipv4_proc>
80109b1a:	83 c4 10             	add    $0x10,%esp
}
80109b1d:	90                   	nop
80109b1e:	c9                   	leave  
80109b1f:	c3                   	ret    

80109b20 <N2H_ushort>:

ushort N2H_ushort(ushort value){
80109b20:	55                   	push   %ebp
80109b21:	89 e5                	mov    %esp,%ebp
80109b23:	83 ec 04             	sub    $0x4,%esp
80109b26:	8b 45 08             	mov    0x8(%ebp),%eax
80109b29:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  return (((value)&0xFF)<<8)+(value>>8);
80109b2d:	0f b7 45 fc          	movzwl -0x4(%ebp),%eax
80109b31:	c1 e0 08             	shl    $0x8,%eax
80109b34:	89 c2                	mov    %eax,%edx
80109b36:	0f b7 45 fc          	movzwl -0x4(%ebp),%eax
80109b3a:	66 c1 e8 08          	shr    $0x8,%ax
80109b3e:	01 d0                	add    %edx,%eax
}
80109b40:	c9                   	leave  
80109b41:	c3                   	ret    

80109b42 <H2N_ushort>:

ushort H2N_ushort(ushort value){
80109b42:	55                   	push   %ebp
80109b43:	89 e5                	mov    %esp,%ebp
80109b45:	83 ec 04             	sub    $0x4,%esp
80109b48:	8b 45 08             	mov    0x8(%ebp),%eax
80109b4b:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  return (((value)&0xFF)<<8)+(value>>8);
80109b4f:	0f b7 45 fc          	movzwl -0x4(%ebp),%eax
80109b53:	c1 e0 08             	shl    $0x8,%eax
80109b56:	89 c2                	mov    %eax,%edx
80109b58:	0f b7 45 fc          	movzwl -0x4(%ebp),%eax
80109b5c:	66 c1 e8 08          	shr    $0x8,%ax
80109b60:	01 d0                	add    %edx,%eax
}
80109b62:	c9                   	leave  
80109b63:	c3                   	ret    

80109b64 <H2N_uint>:

uint H2N_uint(uint value){
80109b64:	55                   	push   %ebp
80109b65:	89 e5                	mov    %esp,%ebp
  return ((value&0xF)<<24)+((value&0xF0)<<8)+((value&0xF00)>>8)+((value&0xF000)>>24);
80109b67:	8b 45 08             	mov    0x8(%ebp),%eax
80109b6a:	c1 e0 18             	shl    $0x18,%eax
80109b6d:	25 00 00 00 0f       	and    $0xf000000,%eax
80109b72:	89 c2                	mov    %eax,%edx
80109b74:	8b 45 08             	mov    0x8(%ebp),%eax
80109b77:	c1 e0 08             	shl    $0x8,%eax
80109b7a:	25 00 f0 00 00       	and    $0xf000,%eax
80109b7f:	09 c2                	or     %eax,%edx
80109b81:	8b 45 08             	mov    0x8(%ebp),%eax
80109b84:	c1 e8 08             	shr    $0x8,%eax
80109b87:	83 e0 0f             	and    $0xf,%eax
80109b8a:	01 d0                	add    %edx,%eax
}
80109b8c:	5d                   	pop    %ebp
80109b8d:	c3                   	ret    

80109b8e <N2H_uint>:

uint N2H_uint(uint value){
80109b8e:	55                   	push   %ebp
80109b8f:	89 e5                	mov    %esp,%ebp
  return ((value&0xFF)<<24)+((value&0xFF00)<<8)+((value&0xFF0000)>>8)+((value&0xFF000000)>>24);
80109b91:	8b 45 08             	mov    0x8(%ebp),%eax
80109b94:	c1 e0 18             	shl    $0x18,%eax
80109b97:	89 c2                	mov    %eax,%edx
80109b99:	8b 45 08             	mov    0x8(%ebp),%eax
80109b9c:	c1 e0 08             	shl    $0x8,%eax
80109b9f:	25 00 00 ff 00       	and    $0xff0000,%eax
80109ba4:	01 c2                	add    %eax,%edx
80109ba6:	8b 45 08             	mov    0x8(%ebp),%eax
80109ba9:	c1 e8 08             	shr    $0x8,%eax
80109bac:	25 00 ff 00 00       	and    $0xff00,%eax
80109bb1:	01 c2                	add    %eax,%edx
80109bb3:	8b 45 08             	mov    0x8(%ebp),%eax
80109bb6:	c1 e8 18             	shr    $0x18,%eax
80109bb9:	01 d0                	add    %edx,%eax
}
80109bbb:	5d                   	pop    %ebp
80109bbc:	c3                   	ret    

80109bbd <ipv4_proc>:
extern uchar mac_addr[6];
extern uchar my_ip[4];

int ip_id = -1;
ushort send_id = 0;
void ipv4_proc(uint buffer_addr){
80109bbd:	55                   	push   %ebp
80109bbe:	89 e5                	mov    %esp,%ebp
80109bc0:	83 ec 18             	sub    $0x18,%esp
  struct ipv4_pkt *ipv4_p = (struct ipv4_pkt *)(buffer_addr+14);
80109bc3:	8b 45 08             	mov    0x8(%ebp),%eax
80109bc6:	83 c0 0e             	add    $0xe,%eax
80109bc9:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(ip_id != ipv4_p->id && memcmp(my_ip,ipv4_p->src_ip,4) != 0){
80109bcc:	8b 45 f4             	mov    -0xc(%ebp),%eax
80109bcf:	0f b7 40 04          	movzwl 0x4(%eax),%eax
80109bd3:	0f b7 d0             	movzwl %ax,%edx
80109bd6:	a1 e8 f4 10 80       	mov    0x8010f4e8,%eax
80109bdb:	39 c2                	cmp    %eax,%edx
80109bdd:	74 60                	je     80109c3f <ipv4_proc+0x82>
80109bdf:	8b 45 f4             	mov    -0xc(%ebp),%eax
80109be2:	83 c0 0c             	add    $0xc,%eax
80109be5:	83 ec 04             	sub    $0x4,%esp
80109be8:	6a 04                	push   $0x4
80109bea:	50                   	push   %eax
80109beb:	68 e4 f4 10 80       	push   $0x8010f4e4
80109bf0:	e8 30 b5 ff ff       	call   80105125 <memcmp>
80109bf5:	83 c4 10             	add    $0x10,%esp
80109bf8:	85 c0                	test   %eax,%eax
80109bfa:	74 43                	je     80109c3f <ipv4_proc+0x82>
    ip_id = ipv4_p->id;
80109bfc:	8b 45 f4             	mov    -0xc(%ebp),%eax
80109bff:	0f b7 40 04          	movzwl 0x4(%eax),%eax
80109c03:	0f b7 c0             	movzwl %ax,%eax
80109c06:	a3 e8 f4 10 80       	mov    %eax,0x8010f4e8
      if(ipv4_p->protocol == IPV4_TYPE_ICMP){
80109c0b:	8b 45 f4             	mov    -0xc(%ebp),%eax
80109c0e:	0f b6 40 09          	movzbl 0x9(%eax),%eax
80109c12:	3c 01                	cmp    $0x1,%al
80109c14:	75 10                	jne    80109c26 <ipv4_proc+0x69>
        icmp_proc(buffer_addr);
80109c16:	83 ec 0c             	sub    $0xc,%esp
80109c19:	ff 75 08             	push   0x8(%ebp)
80109c1c:	e8 a3 00 00 00       	call   80109cc4 <icmp_proc>
80109c21:	83 c4 10             	add    $0x10,%esp
      }else if(ipv4_p->protocol == IPV4_TYPE_TCP){
        tcp_proc(buffer_addr);
      }
  }
}
80109c24:	eb 19                	jmp    80109c3f <ipv4_proc+0x82>
      }else if(ipv4_p->protocol == IPV4_TYPE_TCP){
80109c26:	8b 45 f4             	mov    -0xc(%ebp),%eax
80109c29:	0f b6 40 09          	movzbl 0x9(%eax),%eax
80109c2d:	3c 06                	cmp    $0x6,%al
80109c2f:	75 0e                	jne    80109c3f <ipv4_proc+0x82>
        tcp_proc(buffer_addr);
80109c31:	83 ec 0c             	sub    $0xc,%esp
80109c34:	ff 75 08             	push   0x8(%ebp)
80109c37:	e8 b3 03 00 00       	call   80109fef <tcp_proc>
80109c3c:	83 c4 10             	add    $0x10,%esp
}
80109c3f:	90                   	nop
80109c40:	c9                   	leave  
80109c41:	c3                   	ret    

80109c42 <ipv4_chksum>:

ushort ipv4_chksum(uint ipv4_addr){
80109c42:	55                   	push   %ebp
80109c43:	89 e5                	mov    %esp,%ebp
80109c45:	83 ec 10             	sub    $0x10,%esp
  uchar* bin = (uchar *)ipv4_addr;
80109c48:	8b 45 08             	mov    0x8(%ebp),%eax
80109c4b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  uchar len = (bin[0]&0xF)*2;
80109c4e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80109c51:	0f b6 00             	movzbl (%eax),%eax
80109c54:	83 e0 0f             	and    $0xf,%eax
80109c57:	01 c0                	add    %eax,%eax
80109c59:	88 45 f3             	mov    %al,-0xd(%ebp)
  uint chk_sum = 0;
80109c5c:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  for(int i=0;i<len;i++){
80109c63:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
80109c6a:	eb 48                	jmp    80109cb4 <ipv4_chksum+0x72>
    chk_sum += (bin[i*2]<<8)+bin[i*2+1];
80109c6c:	8b 45 f8             	mov    -0x8(%ebp),%eax
80109c6f:	01 c0                	add    %eax,%eax
80109c71:	89 c2                	mov    %eax,%edx
80109c73:	8b 45 f4             	mov    -0xc(%ebp),%eax
80109c76:	01 d0                	add    %edx,%eax
80109c78:	0f b6 00             	movzbl (%eax),%eax
80109c7b:	0f b6 c0             	movzbl %al,%eax
80109c7e:	c1 e0 08             	shl    $0x8,%eax
80109c81:	89 c2                	mov    %eax,%edx
80109c83:	8b 45 f8             	mov    -0x8(%ebp),%eax
80109c86:	01 c0                	add    %eax,%eax
80109c88:	8d 48 01             	lea    0x1(%eax),%ecx
80109c8b:	8b 45 f4             	mov    -0xc(%ebp),%eax
80109c8e:	01 c8                	add    %ecx,%eax
80109c90:	0f b6 00             	movzbl (%eax),%eax
80109c93:	0f b6 c0             	movzbl %al,%eax
80109c96:	01 d0                	add    %edx,%eax
80109c98:	01 45 fc             	add    %eax,-0x4(%ebp)
    if(chk_sum > 0xFFFF){
80109c9b:	81 7d fc ff ff 00 00 	cmpl   $0xffff,-0x4(%ebp)
80109ca2:	76 0c                	jbe    80109cb0 <ipv4_chksum+0x6e>
      chk_sum = (chk_sum&0xFFFF)+1;
80109ca4:	8b 45 fc             	mov    -0x4(%ebp),%eax
80109ca7:	0f b7 c0             	movzwl %ax,%eax
80109caa:	83 c0 01             	add    $0x1,%eax
80109cad:	89 45 fc             	mov    %eax,-0x4(%ebp)
  for(int i=0;i<len;i++){
80109cb0:	83 45 f8 01          	addl   $0x1,-0x8(%ebp)
80109cb4:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
80109cb8:	39 45 f8             	cmp    %eax,-0x8(%ebp)
80109cbb:	7c af                	jl     80109c6c <ipv4_chksum+0x2a>
    }
  }
  return ~(chk_sum);
80109cbd:	8b 45 fc             	mov    -0x4(%ebp),%eax
80109cc0:	f7 d0                	not    %eax
}
80109cc2:	c9                   	leave  
80109cc3:	c3                   	ret    

80109cc4 <icmp_proc>:
#include "eth.h"

extern uchar mac_addr[6];
extern uchar my_ip[4];
extern ushort send_id;
void icmp_proc(uint buffer_addr){
80109cc4:	55                   	push   %ebp
80109cc5:	89 e5                	mov    %esp,%ebp
80109cc7:	83 ec 18             	sub    $0x18,%esp
  struct ipv4_pkt *ipv4_p = (struct ipv4_pkt *)(buffer_addr+sizeof(struct eth_pkt));
80109cca:	8b 45 08             	mov    0x8(%ebp),%eax
80109ccd:	83 c0 0e             	add    $0xe,%eax
80109cd0:	89 45 f4             	mov    %eax,-0xc(%ebp)
  struct icmp_echo_pkt *icmp_p = (struct icmp_echo_pkt *)((uint)ipv4_p + (ipv4_p->ver&0xF)*4);
80109cd3:	8b 45 f4             	mov    -0xc(%ebp),%eax
80109cd6:	0f b6 00             	movzbl (%eax),%eax
80109cd9:	0f b6 c0             	movzbl %al,%eax
80109cdc:	83 e0 0f             	and    $0xf,%eax
80109cdf:	c1 e0 02             	shl    $0x2,%eax
80109ce2:	89 c2                	mov    %eax,%edx
80109ce4:	8b 45 f4             	mov    -0xc(%ebp),%eax
80109ce7:	01 d0                	add    %edx,%eax
80109ce9:	89 45 f0             	mov    %eax,-0x10(%ebp)
  if(icmp_p->code == 0){
80109cec:	8b 45 f0             	mov    -0x10(%ebp),%eax
80109cef:	0f b6 40 01          	movzbl 0x1(%eax),%eax
80109cf3:	84 c0                	test   %al,%al
80109cf5:	75 4f                	jne    80109d46 <icmp_proc+0x82>
    if(icmp_p->type == ICMP_TYPE_ECHO_REQUEST){
80109cf7:	8b 45 f0             	mov    -0x10(%ebp),%eax
80109cfa:	0f b6 00             	movzbl (%eax),%eax
80109cfd:	3c 08                	cmp    $0x8,%al
80109cff:	75 45                	jne    80109d46 <icmp_proc+0x82>
      uint send_addr = (uint)kalloc();
80109d01:	e8 7e 8f ff ff       	call   80102c84 <kalloc>
80109d06:	89 45 ec             	mov    %eax,-0x14(%ebp)
      uint send_size = 0;
80109d09:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
      icmp_reply_pkt_create(buffer_addr,send_addr,&send_size);
80109d10:	83 ec 04             	sub    $0x4,%esp
80109d13:	8d 45 e8             	lea    -0x18(%ebp),%eax
80109d16:	50                   	push   %eax
80109d17:	ff 75 ec             	push   -0x14(%ebp)
80109d1a:	ff 75 08             	push   0x8(%ebp)
80109d1d:	e8 78 00 00 00       	call   80109d9a <icmp_reply_pkt_create>
80109d22:	83 c4 10             	add    $0x10,%esp
      i8254_send(send_addr,send_size);
80109d25:	8b 45 e8             	mov    -0x18(%ebp),%eax
80109d28:	83 ec 08             	sub    $0x8,%esp
80109d2b:	50                   	push   %eax
80109d2c:	ff 75 ec             	push   -0x14(%ebp)
80109d2f:	e8 95 f4 ff ff       	call   801091c9 <i8254_send>
80109d34:	83 c4 10             	add    $0x10,%esp
      kfree((char *)send_addr);
80109d37:	8b 45 ec             	mov    -0x14(%ebp),%eax
80109d3a:	83 ec 0c             	sub    $0xc,%esp
80109d3d:	50                   	push   %eax
80109d3e:	e8 a7 8e ff ff       	call   80102bea <kfree>
80109d43:	83 c4 10             	add    $0x10,%esp
    }
  }
}
80109d46:	90                   	nop
80109d47:	c9                   	leave  
80109d48:	c3                   	ret    

80109d49 <icmp_proc_req>:

void icmp_proc_req(struct icmp_echo_pkt * icmp_p){
80109d49:	55                   	push   %ebp
80109d4a:	89 e5                	mov    %esp,%ebp
80109d4c:	53                   	push   %ebx
80109d4d:	83 ec 04             	sub    $0x4,%esp
  cprintf("ICMP ID:0x%x SEQ NUM:0x%x\n",N2H_ushort(icmp_p->id),N2H_ushort(icmp_p->seq_num));
80109d50:	8b 45 08             	mov    0x8(%ebp),%eax
80109d53:	0f b7 40 06          	movzwl 0x6(%eax),%eax
80109d57:	0f b7 c0             	movzwl %ax,%eax
80109d5a:	83 ec 0c             	sub    $0xc,%esp
80109d5d:	50                   	push   %eax
80109d5e:	e8 bd fd ff ff       	call   80109b20 <N2H_ushort>
80109d63:	83 c4 10             	add    $0x10,%esp
80109d66:	0f b7 d8             	movzwl %ax,%ebx
80109d69:	8b 45 08             	mov    0x8(%ebp),%eax
80109d6c:	0f b7 40 04          	movzwl 0x4(%eax),%eax
80109d70:	0f b7 c0             	movzwl %ax,%eax
80109d73:	83 ec 0c             	sub    $0xc,%esp
80109d76:	50                   	push   %eax
80109d77:	e8 a4 fd ff ff       	call   80109b20 <N2H_ushort>
80109d7c:	83 c4 10             	add    $0x10,%esp
80109d7f:	0f b7 c0             	movzwl %ax,%eax
80109d82:	83 ec 04             	sub    $0x4,%esp
80109d85:	53                   	push   %ebx
80109d86:	50                   	push   %eax
80109d87:	68 e3 c5 10 80       	push   $0x8010c5e3
80109d8c:	e8 63 66 ff ff       	call   801003f4 <cprintf>
80109d91:	83 c4 10             	add    $0x10,%esp
}
80109d94:	90                   	nop
80109d95:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80109d98:	c9                   	leave  
80109d99:	c3                   	ret    

80109d9a <icmp_reply_pkt_create>:

void icmp_reply_pkt_create(uint recv_addr,uint send_addr,uint *send_size){
80109d9a:	55                   	push   %ebp
80109d9b:	89 e5                	mov    %esp,%ebp
80109d9d:	83 ec 28             	sub    $0x28,%esp
  struct eth_pkt *eth_recv = (struct eth_pkt *)(recv_addr);
80109da0:	8b 45 08             	mov    0x8(%ebp),%eax
80109da3:	89 45 f4             	mov    %eax,-0xc(%ebp)
  struct ipv4_pkt *ipv4_recv = (struct ipv4_pkt *)(recv_addr+sizeof(struct eth_pkt));
80109da6:	8b 45 08             	mov    0x8(%ebp),%eax
80109da9:	83 c0 0e             	add    $0xe,%eax
80109dac:	89 45 f0             	mov    %eax,-0x10(%ebp)
  struct icmp_echo_pkt *icmp_recv = (struct icmp_echo_pkt *)((uint)ipv4_recv+(ipv4_recv->ver&0xF)*4);
80109daf:	8b 45 f0             	mov    -0x10(%ebp),%eax
80109db2:	0f b6 00             	movzbl (%eax),%eax
80109db5:	0f b6 c0             	movzbl %al,%eax
80109db8:	83 e0 0f             	and    $0xf,%eax
80109dbb:	c1 e0 02             	shl    $0x2,%eax
80109dbe:	89 c2                	mov    %eax,%edx
80109dc0:	8b 45 f0             	mov    -0x10(%ebp),%eax
80109dc3:	01 d0                	add    %edx,%eax
80109dc5:	89 45 ec             	mov    %eax,-0x14(%ebp)
  struct eth_pkt *eth_send = (struct eth_pkt *)(send_addr);
80109dc8:	8b 45 0c             	mov    0xc(%ebp),%eax
80109dcb:	89 45 e8             	mov    %eax,-0x18(%ebp)
  struct ipv4_pkt *ipv4_send = (struct ipv4_pkt *)(send_addr+sizeof(struct eth_pkt));
80109dce:	8b 45 0c             	mov    0xc(%ebp),%eax
80109dd1:	83 c0 0e             	add    $0xe,%eax
80109dd4:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  struct icmp_echo_pkt *icmp_send = (struct icmp_echo_pkt *)((uint)ipv4_send+sizeof(struct ipv4_pkt));
80109dd7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80109dda:	83 c0 14             	add    $0x14,%eax
80109ddd:	89 45 e0             	mov    %eax,-0x20(%ebp)
  
  *send_size = sizeof(struct eth_pkt) + sizeof(struct ipv4_pkt) + sizeof(struct icmp_echo_pkt);
80109de0:	8b 45 10             	mov    0x10(%ebp),%eax
80109de3:	c7 00 62 00 00 00    	movl   $0x62,(%eax)
  memmove(eth_send->dst_mac,eth_recv->src_mac,6);
80109de9:	8b 45 f4             	mov    -0xc(%ebp),%eax
80109dec:	8d 50 06             	lea    0x6(%eax),%edx
80109def:	8b 45 e8             	mov    -0x18(%ebp),%eax
80109df2:	83 ec 04             	sub    $0x4,%esp
80109df5:	6a 06                	push   $0x6
80109df7:	52                   	push   %edx
80109df8:	50                   	push   %eax
80109df9:	e8 7f b3 ff ff       	call   8010517d <memmove>
80109dfe:	83 c4 10             	add    $0x10,%esp
  memmove(eth_send->src_mac,mac_addr,6);
80109e01:	8b 45 e8             	mov    -0x18(%ebp),%eax
80109e04:	83 c0 06             	add    $0x6,%eax
80109e07:	83 ec 04             	sub    $0x4,%esp
80109e0a:	6a 06                	push   $0x6
80109e0c:	68 c0 9d 11 80       	push   $0x80119dc0
80109e11:	50                   	push   %eax
80109e12:	e8 66 b3 ff ff       	call   8010517d <memmove>
80109e17:	83 c4 10             	add    $0x10,%esp
  eth_send->type[0] = 0x08;
80109e1a:	8b 45 e8             	mov    -0x18(%ebp),%eax
80109e1d:	c6 40 0c 08          	movb   $0x8,0xc(%eax)
  eth_send->type[1] = 0x00;
80109e21:	8b 45 e8             	mov    -0x18(%ebp),%eax
80109e24:	c6 40 0d 00          	movb   $0x0,0xd(%eax)

  ipv4_send->ver = ((0x4)<<4)+((sizeof(struct ipv4_pkt)/4)&0xF);
80109e28:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80109e2b:	c6 00 45             	movb   $0x45,(%eax)
  ipv4_send->srv_type = 0;
80109e2e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80109e31:	c6 40 01 00          	movb   $0x0,0x1(%eax)
  ipv4_send->total_len = H2N_ushort(sizeof(struct ipv4_pkt) + sizeof(struct icmp_echo_pkt));
80109e35:	83 ec 0c             	sub    $0xc,%esp
80109e38:	6a 54                	push   $0x54
80109e3a:	e8 03 fd ff ff       	call   80109b42 <H2N_ushort>
80109e3f:	83 c4 10             	add    $0x10,%esp
80109e42:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80109e45:	66 89 42 02          	mov    %ax,0x2(%edx)
  ipv4_send->id = send_id;
80109e49:	0f b7 15 a0 a0 11 80 	movzwl 0x8011a0a0,%edx
80109e50:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80109e53:	66 89 50 04          	mov    %dx,0x4(%eax)
  send_id++;
80109e57:	0f b7 05 a0 a0 11 80 	movzwl 0x8011a0a0,%eax
80109e5e:	83 c0 01             	add    $0x1,%eax
80109e61:	66 a3 a0 a0 11 80    	mov    %ax,0x8011a0a0
  ipv4_send->fragment = H2N_ushort(0x4000);
80109e67:	83 ec 0c             	sub    $0xc,%esp
80109e6a:	68 00 40 00 00       	push   $0x4000
80109e6f:	e8 ce fc ff ff       	call   80109b42 <H2N_ushort>
80109e74:	83 c4 10             	add    $0x10,%esp
80109e77:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80109e7a:	66 89 42 06          	mov    %ax,0x6(%edx)
  ipv4_send->ttl = 255;
80109e7e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80109e81:	c6 40 08 ff          	movb   $0xff,0x8(%eax)
  ipv4_send->protocol = 0x1;
80109e85:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80109e88:	c6 40 09 01          	movb   $0x1,0x9(%eax)
  memmove(ipv4_send->src_ip,my_ip,4);
80109e8c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80109e8f:	83 c0 0c             	add    $0xc,%eax
80109e92:	83 ec 04             	sub    $0x4,%esp
80109e95:	6a 04                	push   $0x4
80109e97:	68 e4 f4 10 80       	push   $0x8010f4e4
80109e9c:	50                   	push   %eax
80109e9d:	e8 db b2 ff ff       	call   8010517d <memmove>
80109ea2:	83 c4 10             	add    $0x10,%esp
  memmove(ipv4_send->dst_ip,ipv4_recv->src_ip,4);
80109ea5:	8b 45 f0             	mov    -0x10(%ebp),%eax
80109ea8:	8d 50 0c             	lea    0xc(%eax),%edx
80109eab:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80109eae:	83 c0 10             	add    $0x10,%eax
80109eb1:	83 ec 04             	sub    $0x4,%esp
80109eb4:	6a 04                	push   $0x4
80109eb6:	52                   	push   %edx
80109eb7:	50                   	push   %eax
80109eb8:	e8 c0 b2 ff ff       	call   8010517d <memmove>
80109ebd:	83 c4 10             	add    $0x10,%esp
  ipv4_send->chk_sum = 0;
80109ec0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80109ec3:	66 c7 40 0a 00 00    	movw   $0x0,0xa(%eax)
  ipv4_send->chk_sum = H2N_ushort(ipv4_chksum((uint)ipv4_send));
80109ec9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80109ecc:	83 ec 0c             	sub    $0xc,%esp
80109ecf:	50                   	push   %eax
80109ed0:	e8 6d fd ff ff       	call   80109c42 <ipv4_chksum>
80109ed5:	83 c4 10             	add    $0x10,%esp
80109ed8:	0f b7 c0             	movzwl %ax,%eax
80109edb:	83 ec 0c             	sub    $0xc,%esp
80109ede:	50                   	push   %eax
80109edf:	e8 5e fc ff ff       	call   80109b42 <H2N_ushort>
80109ee4:	83 c4 10             	add    $0x10,%esp
80109ee7:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80109eea:	66 89 42 0a          	mov    %ax,0xa(%edx)

  icmp_send->type = ICMP_TYPE_ECHO_REPLY;
80109eee:	8b 45 e0             	mov    -0x20(%ebp),%eax
80109ef1:	c6 00 00             	movb   $0x0,(%eax)
  icmp_send->code = 0;
80109ef4:	8b 45 e0             	mov    -0x20(%ebp),%eax
80109ef7:	c6 40 01 00          	movb   $0x0,0x1(%eax)
  icmp_send->id = icmp_recv->id;
80109efb:	8b 45 ec             	mov    -0x14(%ebp),%eax
80109efe:	0f b7 50 04          	movzwl 0x4(%eax),%edx
80109f02:	8b 45 e0             	mov    -0x20(%ebp),%eax
80109f05:	66 89 50 04          	mov    %dx,0x4(%eax)
  icmp_send->seq_num = icmp_recv->seq_num;
80109f09:	8b 45 ec             	mov    -0x14(%ebp),%eax
80109f0c:	0f b7 50 06          	movzwl 0x6(%eax),%edx
80109f10:	8b 45 e0             	mov    -0x20(%ebp),%eax
80109f13:	66 89 50 06          	mov    %dx,0x6(%eax)
  memmove(icmp_send->time_stamp,icmp_recv->time_stamp,8);
80109f17:	8b 45 ec             	mov    -0x14(%ebp),%eax
80109f1a:	8d 50 08             	lea    0x8(%eax),%edx
80109f1d:	8b 45 e0             	mov    -0x20(%ebp),%eax
80109f20:	83 c0 08             	add    $0x8,%eax
80109f23:	83 ec 04             	sub    $0x4,%esp
80109f26:	6a 08                	push   $0x8
80109f28:	52                   	push   %edx
80109f29:	50                   	push   %eax
80109f2a:	e8 4e b2 ff ff       	call   8010517d <memmove>
80109f2f:	83 c4 10             	add    $0x10,%esp
  memmove(icmp_send->data,icmp_recv->data,48);
80109f32:	8b 45 ec             	mov    -0x14(%ebp),%eax
80109f35:	8d 50 10             	lea    0x10(%eax),%edx
80109f38:	8b 45 e0             	mov    -0x20(%ebp),%eax
80109f3b:	83 c0 10             	add    $0x10,%eax
80109f3e:	83 ec 04             	sub    $0x4,%esp
80109f41:	6a 30                	push   $0x30
80109f43:	52                   	push   %edx
80109f44:	50                   	push   %eax
80109f45:	e8 33 b2 ff ff       	call   8010517d <memmove>
80109f4a:	83 c4 10             	add    $0x10,%esp
  icmp_send->chk_sum = 0;
80109f4d:	8b 45 e0             	mov    -0x20(%ebp),%eax
80109f50:	66 c7 40 02 00 00    	movw   $0x0,0x2(%eax)
  icmp_send->chk_sum = H2N_ushort(icmp_chksum((uint)icmp_send));
80109f56:	8b 45 e0             	mov    -0x20(%ebp),%eax
80109f59:	83 ec 0c             	sub    $0xc,%esp
80109f5c:	50                   	push   %eax
80109f5d:	e8 1c 00 00 00       	call   80109f7e <icmp_chksum>
80109f62:	83 c4 10             	add    $0x10,%esp
80109f65:	0f b7 c0             	movzwl %ax,%eax
80109f68:	83 ec 0c             	sub    $0xc,%esp
80109f6b:	50                   	push   %eax
80109f6c:	e8 d1 fb ff ff       	call   80109b42 <H2N_ushort>
80109f71:	83 c4 10             	add    $0x10,%esp
80109f74:	8b 55 e0             	mov    -0x20(%ebp),%edx
80109f77:	66 89 42 02          	mov    %ax,0x2(%edx)
}
80109f7b:	90                   	nop
80109f7c:	c9                   	leave  
80109f7d:	c3                   	ret    

80109f7e <icmp_chksum>:

ushort icmp_chksum(uint icmp_addr){
80109f7e:	55                   	push   %ebp
80109f7f:	89 e5                	mov    %esp,%ebp
80109f81:	83 ec 10             	sub    $0x10,%esp
  uchar* bin = (uchar *)icmp_addr;
80109f84:	8b 45 08             	mov    0x8(%ebp),%eax
80109f87:	89 45 f4             	mov    %eax,-0xc(%ebp)
  uint chk_sum = 0;
80109f8a:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  for(int i=0;i<32;i++){
80109f91:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
80109f98:	eb 48                	jmp    80109fe2 <icmp_chksum+0x64>
    chk_sum += (bin[i*2]<<8)+bin[i*2+1];
80109f9a:	8b 45 f8             	mov    -0x8(%ebp),%eax
80109f9d:	01 c0                	add    %eax,%eax
80109f9f:	89 c2                	mov    %eax,%edx
80109fa1:	8b 45 f4             	mov    -0xc(%ebp),%eax
80109fa4:	01 d0                	add    %edx,%eax
80109fa6:	0f b6 00             	movzbl (%eax),%eax
80109fa9:	0f b6 c0             	movzbl %al,%eax
80109fac:	c1 e0 08             	shl    $0x8,%eax
80109faf:	89 c2                	mov    %eax,%edx
80109fb1:	8b 45 f8             	mov    -0x8(%ebp),%eax
80109fb4:	01 c0                	add    %eax,%eax
80109fb6:	8d 48 01             	lea    0x1(%eax),%ecx
80109fb9:	8b 45 f4             	mov    -0xc(%ebp),%eax
80109fbc:	01 c8                	add    %ecx,%eax
80109fbe:	0f b6 00             	movzbl (%eax),%eax
80109fc1:	0f b6 c0             	movzbl %al,%eax
80109fc4:	01 d0                	add    %edx,%eax
80109fc6:	01 45 fc             	add    %eax,-0x4(%ebp)
    if(chk_sum > 0xFFFF){
80109fc9:	81 7d fc ff ff 00 00 	cmpl   $0xffff,-0x4(%ebp)
80109fd0:	76 0c                	jbe    80109fde <icmp_chksum+0x60>
      chk_sum = (chk_sum&0xFFFF)+1;
80109fd2:	8b 45 fc             	mov    -0x4(%ebp),%eax
80109fd5:	0f b7 c0             	movzwl %ax,%eax
80109fd8:	83 c0 01             	add    $0x1,%eax
80109fdb:	89 45 fc             	mov    %eax,-0x4(%ebp)
  for(int i=0;i<32;i++){
80109fde:	83 45 f8 01          	addl   $0x1,-0x8(%ebp)
80109fe2:	83 7d f8 1f          	cmpl   $0x1f,-0x8(%ebp)
80109fe6:	7e b2                	jle    80109f9a <icmp_chksum+0x1c>
    }
  }
  return ~(chk_sum);
80109fe8:	8b 45 fc             	mov    -0x4(%ebp),%eax
80109feb:	f7 d0                	not    %eax
}
80109fed:	c9                   	leave  
80109fee:	c3                   	ret    

80109fef <tcp_proc>:
extern ushort send_id;
extern uchar mac_addr[6];
extern uchar my_ip[4];
int fin_flag = 0;

void tcp_proc(uint buffer_addr){
80109fef:	55                   	push   %ebp
80109ff0:	89 e5                	mov    %esp,%ebp
80109ff2:	83 ec 38             	sub    $0x38,%esp
  struct ipv4_pkt *ipv4_p = (struct ipv4_pkt *)(buffer_addr + sizeof(struct eth_pkt));
80109ff5:	8b 45 08             	mov    0x8(%ebp),%eax
80109ff8:	83 c0 0e             	add    $0xe,%eax
80109ffb:	89 45 f4             	mov    %eax,-0xc(%ebp)
  struct tcp_pkt *tcp_p = (struct tcp_pkt *)((uint)ipv4_p + (ipv4_p->ver&0xF)*4);
80109ffe:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010a001:	0f b6 00             	movzbl (%eax),%eax
8010a004:	0f b6 c0             	movzbl %al,%eax
8010a007:	83 e0 0f             	and    $0xf,%eax
8010a00a:	c1 e0 02             	shl    $0x2,%eax
8010a00d:	89 c2                	mov    %eax,%edx
8010a00f:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010a012:	01 d0                	add    %edx,%eax
8010a014:	89 45 f0             	mov    %eax,-0x10(%ebp)
  char *payload = (char *)((uint)tcp_p + 20);
8010a017:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010a01a:	83 c0 14             	add    $0x14,%eax
8010a01d:	89 45 ec             	mov    %eax,-0x14(%ebp)
  uint send_addr = (uint)kalloc();
8010a020:	e8 5f 8c ff ff       	call   80102c84 <kalloc>
8010a025:	89 45 e8             	mov    %eax,-0x18(%ebp)
  uint send_size = 0;
8010a028:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
  if(tcp_p->code_bits[1]&TCP_CODEBITS_SYN){
8010a02f:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010a032:	0f b6 40 0d          	movzbl 0xd(%eax),%eax
8010a036:	0f b6 c0             	movzbl %al,%eax
8010a039:	83 e0 02             	and    $0x2,%eax
8010a03c:	85 c0                	test   %eax,%eax
8010a03e:	74 3d                	je     8010a07d <tcp_proc+0x8e>
    tcp_pkt_create(buffer_addr,send_addr,&send_size,TCP_CODEBITS_ACK | TCP_CODEBITS_SYN,0);
8010a040:	83 ec 0c             	sub    $0xc,%esp
8010a043:	6a 00                	push   $0x0
8010a045:	6a 12                	push   $0x12
8010a047:	8d 45 dc             	lea    -0x24(%ebp),%eax
8010a04a:	50                   	push   %eax
8010a04b:	ff 75 e8             	push   -0x18(%ebp)
8010a04e:	ff 75 08             	push   0x8(%ebp)
8010a051:	e8 a2 01 00 00       	call   8010a1f8 <tcp_pkt_create>
8010a056:	83 c4 20             	add    $0x20,%esp
    i8254_send(send_addr,send_size);
8010a059:	8b 45 dc             	mov    -0x24(%ebp),%eax
8010a05c:	83 ec 08             	sub    $0x8,%esp
8010a05f:	50                   	push   %eax
8010a060:	ff 75 e8             	push   -0x18(%ebp)
8010a063:	e8 61 f1 ff ff       	call   801091c9 <i8254_send>
8010a068:	83 c4 10             	add    $0x10,%esp
    seq_num++;
8010a06b:	a1 a4 a0 11 80       	mov    0x8011a0a4,%eax
8010a070:	83 c0 01             	add    $0x1,%eax
8010a073:	a3 a4 a0 11 80       	mov    %eax,0x8011a0a4
8010a078:	e9 69 01 00 00       	jmp    8010a1e6 <tcp_proc+0x1f7>
  }else if(tcp_p->code_bits[1] == (TCP_CODEBITS_PSH | TCP_CODEBITS_ACK)){
8010a07d:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010a080:	0f b6 40 0d          	movzbl 0xd(%eax),%eax
8010a084:	3c 18                	cmp    $0x18,%al
8010a086:	0f 85 10 01 00 00    	jne    8010a19c <tcp_proc+0x1ad>
    if(memcmp(payload,"GET",3)){
8010a08c:	83 ec 04             	sub    $0x4,%esp
8010a08f:	6a 03                	push   $0x3
8010a091:	68 fe c5 10 80       	push   $0x8010c5fe
8010a096:	ff 75 ec             	push   -0x14(%ebp)
8010a099:	e8 87 b0 ff ff       	call   80105125 <memcmp>
8010a09e:	83 c4 10             	add    $0x10,%esp
8010a0a1:	85 c0                	test   %eax,%eax
8010a0a3:	74 74                	je     8010a119 <tcp_proc+0x12a>
      cprintf("ACK PSH\n");
8010a0a5:	83 ec 0c             	sub    $0xc,%esp
8010a0a8:	68 02 c6 10 80       	push   $0x8010c602
8010a0ad:	e8 42 63 ff ff       	call   801003f4 <cprintf>
8010a0b2:	83 c4 10             	add    $0x10,%esp
      tcp_pkt_create(buffer_addr,send_addr,&send_size,TCP_CODEBITS_ACK,0);
8010a0b5:	83 ec 0c             	sub    $0xc,%esp
8010a0b8:	6a 00                	push   $0x0
8010a0ba:	6a 10                	push   $0x10
8010a0bc:	8d 45 dc             	lea    -0x24(%ebp),%eax
8010a0bf:	50                   	push   %eax
8010a0c0:	ff 75 e8             	push   -0x18(%ebp)
8010a0c3:	ff 75 08             	push   0x8(%ebp)
8010a0c6:	e8 2d 01 00 00       	call   8010a1f8 <tcp_pkt_create>
8010a0cb:	83 c4 20             	add    $0x20,%esp
      i8254_send(send_addr,send_size);
8010a0ce:	8b 45 dc             	mov    -0x24(%ebp),%eax
8010a0d1:	83 ec 08             	sub    $0x8,%esp
8010a0d4:	50                   	push   %eax
8010a0d5:	ff 75 e8             	push   -0x18(%ebp)
8010a0d8:	e8 ec f0 ff ff       	call   801091c9 <i8254_send>
8010a0dd:	83 c4 10             	add    $0x10,%esp
      uint send_payload = (send_addr + sizeof(struct eth_pkt) + sizeof(struct ipv4_pkt) + sizeof(struct tcp_pkt));
8010a0e0:	8b 45 e8             	mov    -0x18(%ebp),%eax
8010a0e3:	83 c0 36             	add    $0x36,%eax
8010a0e6:	89 45 e0             	mov    %eax,-0x20(%ebp)
      uint payload_size;
      http_proc(0,0,send_payload,&payload_size);
8010a0e9:	8d 45 d8             	lea    -0x28(%ebp),%eax
8010a0ec:	50                   	push   %eax
8010a0ed:	ff 75 e0             	push   -0x20(%ebp)
8010a0f0:	6a 00                	push   $0x0
8010a0f2:	6a 00                	push   $0x0
8010a0f4:	e8 5a 04 00 00       	call   8010a553 <http_proc>
8010a0f9:	83 c4 10             	add    $0x10,%esp
      tcp_pkt_create(buffer_addr,send_addr,&send_size,(TCP_CODEBITS_ACK|TCP_CODEBITS_PSH),payload_size);
8010a0fc:	8b 45 d8             	mov    -0x28(%ebp),%eax
8010a0ff:	83 ec 0c             	sub    $0xc,%esp
8010a102:	50                   	push   %eax
8010a103:	6a 18                	push   $0x18
8010a105:	8d 45 dc             	lea    -0x24(%ebp),%eax
8010a108:	50                   	push   %eax
8010a109:	ff 75 e8             	push   -0x18(%ebp)
8010a10c:	ff 75 08             	push   0x8(%ebp)
8010a10f:	e8 e4 00 00 00       	call   8010a1f8 <tcp_pkt_create>
8010a114:	83 c4 20             	add    $0x20,%esp
8010a117:	eb 62                	jmp    8010a17b <tcp_proc+0x18c>
    }else{
     tcp_pkt_create(buffer_addr,send_addr,&send_size,TCP_CODEBITS_ACK,0);
8010a119:	83 ec 0c             	sub    $0xc,%esp
8010a11c:	6a 00                	push   $0x0
8010a11e:	6a 10                	push   $0x10
8010a120:	8d 45 dc             	lea    -0x24(%ebp),%eax
8010a123:	50                   	push   %eax
8010a124:	ff 75 e8             	push   -0x18(%ebp)
8010a127:	ff 75 08             	push   0x8(%ebp)
8010a12a:	e8 c9 00 00 00       	call   8010a1f8 <tcp_pkt_create>
8010a12f:	83 c4 20             	add    $0x20,%esp
     i8254_send(send_addr,send_size);
8010a132:	8b 45 dc             	mov    -0x24(%ebp),%eax
8010a135:	83 ec 08             	sub    $0x8,%esp
8010a138:	50                   	push   %eax
8010a139:	ff 75 e8             	push   -0x18(%ebp)
8010a13c:	e8 88 f0 ff ff       	call   801091c9 <i8254_send>
8010a141:	83 c4 10             	add    $0x10,%esp
      uint send_payload = (send_addr + sizeof(struct eth_pkt) + sizeof(struct ipv4_pkt) + sizeof(struct tcp_pkt));
8010a144:	8b 45 e8             	mov    -0x18(%ebp),%eax
8010a147:	83 c0 36             	add    $0x36,%eax
8010a14a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
      uint payload_size;
      http_proc(0,0,send_payload,&payload_size);
8010a14d:	8d 45 d4             	lea    -0x2c(%ebp),%eax
8010a150:	50                   	push   %eax
8010a151:	ff 75 e4             	push   -0x1c(%ebp)
8010a154:	6a 00                	push   $0x0
8010a156:	6a 00                	push   $0x0
8010a158:	e8 f6 03 00 00       	call   8010a553 <http_proc>
8010a15d:	83 c4 10             	add    $0x10,%esp
      tcp_pkt_create(buffer_addr,send_addr,&send_size,(TCP_CODEBITS_ACK|TCP_CODEBITS_PSH),payload_size);
8010a160:	8b 45 d4             	mov    -0x2c(%ebp),%eax
8010a163:	83 ec 0c             	sub    $0xc,%esp
8010a166:	50                   	push   %eax
8010a167:	6a 18                	push   $0x18
8010a169:	8d 45 dc             	lea    -0x24(%ebp),%eax
8010a16c:	50                   	push   %eax
8010a16d:	ff 75 e8             	push   -0x18(%ebp)
8010a170:	ff 75 08             	push   0x8(%ebp)
8010a173:	e8 80 00 00 00       	call   8010a1f8 <tcp_pkt_create>
8010a178:	83 c4 20             	add    $0x20,%esp
    }
    i8254_send(send_addr,send_size);
8010a17b:	8b 45 dc             	mov    -0x24(%ebp),%eax
8010a17e:	83 ec 08             	sub    $0x8,%esp
8010a181:	50                   	push   %eax
8010a182:	ff 75 e8             	push   -0x18(%ebp)
8010a185:	e8 3f f0 ff ff       	call   801091c9 <i8254_send>
8010a18a:	83 c4 10             	add    $0x10,%esp
    seq_num++;
8010a18d:	a1 a4 a0 11 80       	mov    0x8011a0a4,%eax
8010a192:	83 c0 01             	add    $0x1,%eax
8010a195:	a3 a4 a0 11 80       	mov    %eax,0x8011a0a4
8010a19a:	eb 4a                	jmp    8010a1e6 <tcp_proc+0x1f7>
  }else if(tcp_p->code_bits[1] == TCP_CODEBITS_ACK){
8010a19c:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010a19f:	0f b6 40 0d          	movzbl 0xd(%eax),%eax
8010a1a3:	3c 10                	cmp    $0x10,%al
8010a1a5:	75 3f                	jne    8010a1e6 <tcp_proc+0x1f7>
    if(fin_flag == 1){
8010a1a7:	a1 a8 a0 11 80       	mov    0x8011a0a8,%eax
8010a1ac:	83 f8 01             	cmp    $0x1,%eax
8010a1af:	75 35                	jne    8010a1e6 <tcp_proc+0x1f7>
      tcp_pkt_create(buffer_addr,send_addr,&send_size,TCP_CODEBITS_FIN,0);
8010a1b1:	83 ec 0c             	sub    $0xc,%esp
8010a1b4:	6a 00                	push   $0x0
8010a1b6:	6a 01                	push   $0x1
8010a1b8:	8d 45 dc             	lea    -0x24(%ebp),%eax
8010a1bb:	50                   	push   %eax
8010a1bc:	ff 75 e8             	push   -0x18(%ebp)
8010a1bf:	ff 75 08             	push   0x8(%ebp)
8010a1c2:	e8 31 00 00 00       	call   8010a1f8 <tcp_pkt_create>
8010a1c7:	83 c4 20             	add    $0x20,%esp
      i8254_send(send_addr,send_size);
8010a1ca:	8b 45 dc             	mov    -0x24(%ebp),%eax
8010a1cd:	83 ec 08             	sub    $0x8,%esp
8010a1d0:	50                   	push   %eax
8010a1d1:	ff 75 e8             	push   -0x18(%ebp)
8010a1d4:	e8 f0 ef ff ff       	call   801091c9 <i8254_send>
8010a1d9:	83 c4 10             	add    $0x10,%esp
      fin_flag = 0;
8010a1dc:	c7 05 a8 a0 11 80 00 	movl   $0x0,0x8011a0a8
8010a1e3:	00 00 00 
    }
  }
  kfree((char *)send_addr);
8010a1e6:	8b 45 e8             	mov    -0x18(%ebp),%eax
8010a1e9:	83 ec 0c             	sub    $0xc,%esp
8010a1ec:	50                   	push   %eax
8010a1ed:	e8 f8 89 ff ff       	call   80102bea <kfree>
8010a1f2:	83 c4 10             	add    $0x10,%esp
}
8010a1f5:	90                   	nop
8010a1f6:	c9                   	leave  
8010a1f7:	c3                   	ret    

8010a1f8 <tcp_pkt_create>:

void tcp_pkt_create(uint recv_addr,uint send_addr,uint *send_size,uint pkt_type,uint payload_size){
8010a1f8:	55                   	push   %ebp
8010a1f9:	89 e5                	mov    %esp,%ebp
8010a1fb:	83 ec 28             	sub    $0x28,%esp
  struct eth_pkt *eth_recv = (struct eth_pkt *)(recv_addr);
8010a1fe:	8b 45 08             	mov    0x8(%ebp),%eax
8010a201:	89 45 f4             	mov    %eax,-0xc(%ebp)
  struct ipv4_pkt *ipv4_recv = (struct ipv4_pkt *)(recv_addr+sizeof(struct eth_pkt));
8010a204:	8b 45 08             	mov    0x8(%ebp),%eax
8010a207:	83 c0 0e             	add    $0xe,%eax
8010a20a:	89 45 f0             	mov    %eax,-0x10(%ebp)
  struct tcp_pkt *tcp_recv = (struct tcp_pkt *)((uint)ipv4_recv + (ipv4_recv->ver&0xF)*4);
8010a20d:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010a210:	0f b6 00             	movzbl (%eax),%eax
8010a213:	0f b6 c0             	movzbl %al,%eax
8010a216:	83 e0 0f             	and    $0xf,%eax
8010a219:	c1 e0 02             	shl    $0x2,%eax
8010a21c:	89 c2                	mov    %eax,%edx
8010a21e:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010a221:	01 d0                	add    %edx,%eax
8010a223:	89 45 ec             	mov    %eax,-0x14(%ebp)

  struct eth_pkt *eth_send = (struct eth_pkt *)(send_addr);
8010a226:	8b 45 0c             	mov    0xc(%ebp),%eax
8010a229:	89 45 e8             	mov    %eax,-0x18(%ebp)
  struct ipv4_pkt *ipv4_send = (struct ipv4_pkt *)(send_addr + sizeof(struct eth_pkt));
8010a22c:	8b 45 0c             	mov    0xc(%ebp),%eax
8010a22f:	83 c0 0e             	add    $0xe,%eax
8010a232:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  struct tcp_pkt *tcp_send = (struct tcp_pkt *)((uint)ipv4_send + sizeof(struct ipv4_pkt));
8010a235:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010a238:	83 c0 14             	add    $0x14,%eax
8010a23b:	89 45 e0             	mov    %eax,-0x20(%ebp)

  *send_size = sizeof(struct eth_pkt) + sizeof(struct ipv4_pkt) + sizeof(struct tcp_pkt) + payload_size;
8010a23e:	8b 45 18             	mov    0x18(%ebp),%eax
8010a241:	8d 50 36             	lea    0x36(%eax),%edx
8010a244:	8b 45 10             	mov    0x10(%ebp),%eax
8010a247:	89 10                	mov    %edx,(%eax)

  memmove(eth_send->dst_mac,eth_recv->src_mac,6);
8010a249:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010a24c:	8d 50 06             	lea    0x6(%eax),%edx
8010a24f:	8b 45 e8             	mov    -0x18(%ebp),%eax
8010a252:	83 ec 04             	sub    $0x4,%esp
8010a255:	6a 06                	push   $0x6
8010a257:	52                   	push   %edx
8010a258:	50                   	push   %eax
8010a259:	e8 1f af ff ff       	call   8010517d <memmove>
8010a25e:	83 c4 10             	add    $0x10,%esp
  memmove(eth_send->src_mac,mac_addr,6);
8010a261:	8b 45 e8             	mov    -0x18(%ebp),%eax
8010a264:	83 c0 06             	add    $0x6,%eax
8010a267:	83 ec 04             	sub    $0x4,%esp
8010a26a:	6a 06                	push   $0x6
8010a26c:	68 c0 9d 11 80       	push   $0x80119dc0
8010a271:	50                   	push   %eax
8010a272:	e8 06 af ff ff       	call   8010517d <memmove>
8010a277:	83 c4 10             	add    $0x10,%esp
  eth_send->type[0] = 0x08;
8010a27a:	8b 45 e8             	mov    -0x18(%ebp),%eax
8010a27d:	c6 40 0c 08          	movb   $0x8,0xc(%eax)
  eth_send->type[1] = 0x00;
8010a281:	8b 45 e8             	mov    -0x18(%ebp),%eax
8010a284:	c6 40 0d 00          	movb   $0x0,0xd(%eax)

  ipv4_send->ver = ((0x4)<<4)+((sizeof(struct ipv4_pkt)/4)&0xF);
8010a288:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010a28b:	c6 00 45             	movb   $0x45,(%eax)
  ipv4_send->srv_type = 0;
8010a28e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010a291:	c6 40 01 00          	movb   $0x0,0x1(%eax)
  ipv4_send->total_len = H2N_ushort(sizeof(struct ipv4_pkt) + sizeof(struct tcp_pkt) + payload_size);
8010a295:	8b 45 18             	mov    0x18(%ebp),%eax
8010a298:	83 c0 28             	add    $0x28,%eax
8010a29b:	0f b7 c0             	movzwl %ax,%eax
8010a29e:	83 ec 0c             	sub    $0xc,%esp
8010a2a1:	50                   	push   %eax
8010a2a2:	e8 9b f8 ff ff       	call   80109b42 <H2N_ushort>
8010a2a7:	83 c4 10             	add    $0x10,%esp
8010a2aa:	8b 55 e4             	mov    -0x1c(%ebp),%edx
8010a2ad:	66 89 42 02          	mov    %ax,0x2(%edx)
  ipv4_send->id = send_id;
8010a2b1:	0f b7 15 a0 a0 11 80 	movzwl 0x8011a0a0,%edx
8010a2b8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010a2bb:	66 89 50 04          	mov    %dx,0x4(%eax)
  send_id++;
8010a2bf:	0f b7 05 a0 a0 11 80 	movzwl 0x8011a0a0,%eax
8010a2c6:	83 c0 01             	add    $0x1,%eax
8010a2c9:	66 a3 a0 a0 11 80    	mov    %ax,0x8011a0a0
  ipv4_send->fragment = H2N_ushort(0x0000);
8010a2cf:	83 ec 0c             	sub    $0xc,%esp
8010a2d2:	6a 00                	push   $0x0
8010a2d4:	e8 69 f8 ff ff       	call   80109b42 <H2N_ushort>
8010a2d9:	83 c4 10             	add    $0x10,%esp
8010a2dc:	8b 55 e4             	mov    -0x1c(%ebp),%edx
8010a2df:	66 89 42 06          	mov    %ax,0x6(%edx)
  ipv4_send->ttl = 255;
8010a2e3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010a2e6:	c6 40 08 ff          	movb   $0xff,0x8(%eax)
  ipv4_send->protocol = IPV4_TYPE_TCP;
8010a2ea:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010a2ed:	c6 40 09 06          	movb   $0x6,0x9(%eax)
  memmove(ipv4_send->src_ip,my_ip,4);
8010a2f1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010a2f4:	83 c0 0c             	add    $0xc,%eax
8010a2f7:	83 ec 04             	sub    $0x4,%esp
8010a2fa:	6a 04                	push   $0x4
8010a2fc:	68 e4 f4 10 80       	push   $0x8010f4e4
8010a301:	50                   	push   %eax
8010a302:	e8 76 ae ff ff       	call   8010517d <memmove>
8010a307:	83 c4 10             	add    $0x10,%esp
  memmove(ipv4_send->dst_ip,ipv4_recv->src_ip,4);
8010a30a:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010a30d:	8d 50 0c             	lea    0xc(%eax),%edx
8010a310:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010a313:	83 c0 10             	add    $0x10,%eax
8010a316:	83 ec 04             	sub    $0x4,%esp
8010a319:	6a 04                	push   $0x4
8010a31b:	52                   	push   %edx
8010a31c:	50                   	push   %eax
8010a31d:	e8 5b ae ff ff       	call   8010517d <memmove>
8010a322:	83 c4 10             	add    $0x10,%esp
  ipv4_send->chk_sum = 0;
8010a325:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010a328:	66 c7 40 0a 00 00    	movw   $0x0,0xa(%eax)
  ipv4_send->chk_sum = H2N_ushort(ipv4_chksum((uint)ipv4_send));
8010a32e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010a331:	83 ec 0c             	sub    $0xc,%esp
8010a334:	50                   	push   %eax
8010a335:	e8 08 f9 ff ff       	call   80109c42 <ipv4_chksum>
8010a33a:	83 c4 10             	add    $0x10,%esp
8010a33d:	0f b7 c0             	movzwl %ax,%eax
8010a340:	83 ec 0c             	sub    $0xc,%esp
8010a343:	50                   	push   %eax
8010a344:	e8 f9 f7 ff ff       	call   80109b42 <H2N_ushort>
8010a349:	83 c4 10             	add    $0x10,%esp
8010a34c:	8b 55 e4             	mov    -0x1c(%ebp),%edx
8010a34f:	66 89 42 0a          	mov    %ax,0xa(%edx)
  

  tcp_send->src_port = tcp_recv->dst_port;
8010a353:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010a356:	0f b7 50 02          	movzwl 0x2(%eax),%edx
8010a35a:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010a35d:	66 89 10             	mov    %dx,(%eax)
  tcp_send->dst_port = tcp_recv->src_port;
8010a360:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010a363:	0f b7 10             	movzwl (%eax),%edx
8010a366:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010a369:	66 89 50 02          	mov    %dx,0x2(%eax)
  tcp_send->seq_num = H2N_uint(seq_num);
8010a36d:	a1 a4 a0 11 80       	mov    0x8011a0a4,%eax
8010a372:	83 ec 0c             	sub    $0xc,%esp
8010a375:	50                   	push   %eax
8010a376:	e8 e9 f7 ff ff       	call   80109b64 <H2N_uint>
8010a37b:	83 c4 10             	add    $0x10,%esp
8010a37e:	8b 55 e0             	mov    -0x20(%ebp),%edx
8010a381:	89 42 04             	mov    %eax,0x4(%edx)
  tcp_send->ack_num = tcp_recv->seq_num + (1<<(8*3));
8010a384:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010a387:	8b 40 04             	mov    0x4(%eax),%eax
8010a38a:	8d 90 00 00 00 01    	lea    0x1000000(%eax),%edx
8010a390:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010a393:	89 50 08             	mov    %edx,0x8(%eax)

  tcp_send->code_bits[0] = 0;
8010a396:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010a399:	c6 40 0c 00          	movb   $0x0,0xc(%eax)
  tcp_send->code_bits[1] = 0;
8010a39d:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010a3a0:	c6 40 0d 00          	movb   $0x0,0xd(%eax)
  tcp_send->code_bits[0] = 5<<4;
8010a3a4:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010a3a7:	c6 40 0c 50          	movb   $0x50,0xc(%eax)
  tcp_send->code_bits[1] = pkt_type;
8010a3ab:	8b 45 14             	mov    0x14(%ebp),%eax
8010a3ae:	89 c2                	mov    %eax,%edx
8010a3b0:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010a3b3:	88 50 0d             	mov    %dl,0xd(%eax)

  tcp_send->window = H2N_ushort(14480);
8010a3b6:	83 ec 0c             	sub    $0xc,%esp
8010a3b9:	68 90 38 00 00       	push   $0x3890
8010a3be:	e8 7f f7 ff ff       	call   80109b42 <H2N_ushort>
8010a3c3:	83 c4 10             	add    $0x10,%esp
8010a3c6:	8b 55 e0             	mov    -0x20(%ebp),%edx
8010a3c9:	66 89 42 0e          	mov    %ax,0xe(%edx)
  tcp_send->urgent_ptr = 0;
8010a3cd:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010a3d0:	66 c7 40 12 00 00    	movw   $0x0,0x12(%eax)
  tcp_send->chk_sum = 0;
8010a3d6:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010a3d9:	66 c7 40 10 00 00    	movw   $0x0,0x10(%eax)

  tcp_send->chk_sum = H2N_ushort(tcp_chksum((uint)(ipv4_send))+8);
8010a3df:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010a3e2:	83 ec 0c             	sub    $0xc,%esp
8010a3e5:	50                   	push   %eax
8010a3e6:	e8 1f 00 00 00       	call   8010a40a <tcp_chksum>
8010a3eb:	83 c4 10             	add    $0x10,%esp
8010a3ee:	83 c0 08             	add    $0x8,%eax
8010a3f1:	0f b7 c0             	movzwl %ax,%eax
8010a3f4:	83 ec 0c             	sub    $0xc,%esp
8010a3f7:	50                   	push   %eax
8010a3f8:	e8 45 f7 ff ff       	call   80109b42 <H2N_ushort>
8010a3fd:	83 c4 10             	add    $0x10,%esp
8010a400:	8b 55 e0             	mov    -0x20(%ebp),%edx
8010a403:	66 89 42 10          	mov    %ax,0x10(%edx)


}
8010a407:	90                   	nop
8010a408:	c9                   	leave  
8010a409:	c3                   	ret    

8010a40a <tcp_chksum>:

ushort tcp_chksum(uint tcp_addr){
8010a40a:	55                   	push   %ebp
8010a40b:	89 e5                	mov    %esp,%ebp
8010a40d:	83 ec 38             	sub    $0x38,%esp
  struct ipv4_pkt *ipv4_p = (struct ipv4_pkt *)(tcp_addr);
8010a410:	8b 45 08             	mov    0x8(%ebp),%eax
8010a413:	89 45 e8             	mov    %eax,-0x18(%ebp)
  struct tcp_pkt *tcp_p = (struct tcp_pkt *)((uint)ipv4_p + sizeof(struct ipv4_pkt));
8010a416:	8b 45 e8             	mov    -0x18(%ebp),%eax
8010a419:	83 c0 14             	add    $0x14,%eax
8010a41c:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  struct tcp_dummy tcp_dummy;
  
  memmove(tcp_dummy.src_ip,my_ip,4);
8010a41f:	83 ec 04             	sub    $0x4,%esp
8010a422:	6a 04                	push   $0x4
8010a424:	68 e4 f4 10 80       	push   $0x8010f4e4
8010a429:	8d 45 d4             	lea    -0x2c(%ebp),%eax
8010a42c:	50                   	push   %eax
8010a42d:	e8 4b ad ff ff       	call   8010517d <memmove>
8010a432:	83 c4 10             	add    $0x10,%esp
  memmove(tcp_dummy.dst_ip,ipv4_p->src_ip,4);
8010a435:	8b 45 e8             	mov    -0x18(%ebp),%eax
8010a438:	83 c0 0c             	add    $0xc,%eax
8010a43b:	83 ec 04             	sub    $0x4,%esp
8010a43e:	6a 04                	push   $0x4
8010a440:	50                   	push   %eax
8010a441:	8d 45 d4             	lea    -0x2c(%ebp),%eax
8010a444:	83 c0 04             	add    $0x4,%eax
8010a447:	50                   	push   %eax
8010a448:	e8 30 ad ff ff       	call   8010517d <memmove>
8010a44d:	83 c4 10             	add    $0x10,%esp
  tcp_dummy.padding = 0;
8010a450:	c6 45 dc 00          	movb   $0x0,-0x24(%ebp)
  tcp_dummy.protocol = IPV4_TYPE_TCP;
8010a454:	c6 45 dd 06          	movb   $0x6,-0x23(%ebp)
  tcp_dummy.tcp_len = H2N_ushort(N2H_ushort(ipv4_p->total_len) - sizeof(struct ipv4_pkt));
8010a458:	8b 45 e8             	mov    -0x18(%ebp),%eax
8010a45b:	0f b7 40 02          	movzwl 0x2(%eax),%eax
8010a45f:	0f b7 c0             	movzwl %ax,%eax
8010a462:	83 ec 0c             	sub    $0xc,%esp
8010a465:	50                   	push   %eax
8010a466:	e8 b5 f6 ff ff       	call   80109b20 <N2H_ushort>
8010a46b:	83 c4 10             	add    $0x10,%esp
8010a46e:	83 e8 14             	sub    $0x14,%eax
8010a471:	0f b7 c0             	movzwl %ax,%eax
8010a474:	83 ec 0c             	sub    $0xc,%esp
8010a477:	50                   	push   %eax
8010a478:	e8 c5 f6 ff ff       	call   80109b42 <H2N_ushort>
8010a47d:	83 c4 10             	add    $0x10,%esp
8010a480:	66 89 45 de          	mov    %ax,-0x22(%ebp)
  uint chk_sum = 0;
8010a484:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  uchar *bin = (uchar *)(&tcp_dummy);
8010a48b:	8d 45 d4             	lea    -0x2c(%ebp),%eax
8010a48e:	89 45 e0             	mov    %eax,-0x20(%ebp)
  for(int i=0;i<6;i++){
8010a491:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
8010a498:	eb 33                	jmp    8010a4cd <tcp_chksum+0xc3>
    chk_sum += (bin[i*2]<<8)+bin[i*2+1];
8010a49a:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010a49d:	01 c0                	add    %eax,%eax
8010a49f:	89 c2                	mov    %eax,%edx
8010a4a1:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010a4a4:	01 d0                	add    %edx,%eax
8010a4a6:	0f b6 00             	movzbl (%eax),%eax
8010a4a9:	0f b6 c0             	movzbl %al,%eax
8010a4ac:	c1 e0 08             	shl    $0x8,%eax
8010a4af:	89 c2                	mov    %eax,%edx
8010a4b1:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010a4b4:	01 c0                	add    %eax,%eax
8010a4b6:	8d 48 01             	lea    0x1(%eax),%ecx
8010a4b9:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010a4bc:	01 c8                	add    %ecx,%eax
8010a4be:	0f b6 00             	movzbl (%eax),%eax
8010a4c1:	0f b6 c0             	movzbl %al,%eax
8010a4c4:	01 d0                	add    %edx,%eax
8010a4c6:	01 45 f4             	add    %eax,-0xc(%ebp)
  for(int i=0;i<6;i++){
8010a4c9:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
8010a4cd:	83 7d f0 05          	cmpl   $0x5,-0x10(%ebp)
8010a4d1:	7e c7                	jle    8010a49a <tcp_chksum+0x90>
  }

  bin = (uchar *)(tcp_p);
8010a4d3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010a4d6:	89 45 e0             	mov    %eax,-0x20(%ebp)
  for(int i=0;i<(N2H_ushort(tcp_dummy.tcp_len)/2);i++){
8010a4d9:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
8010a4e0:	eb 33                	jmp    8010a515 <tcp_chksum+0x10b>
    chk_sum += (bin[i*2]<<8)+bin[i*2+1];
8010a4e2:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010a4e5:	01 c0                	add    %eax,%eax
8010a4e7:	89 c2                	mov    %eax,%edx
8010a4e9:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010a4ec:	01 d0                	add    %edx,%eax
8010a4ee:	0f b6 00             	movzbl (%eax),%eax
8010a4f1:	0f b6 c0             	movzbl %al,%eax
8010a4f4:	c1 e0 08             	shl    $0x8,%eax
8010a4f7:	89 c2                	mov    %eax,%edx
8010a4f9:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010a4fc:	01 c0                	add    %eax,%eax
8010a4fe:	8d 48 01             	lea    0x1(%eax),%ecx
8010a501:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010a504:	01 c8                	add    %ecx,%eax
8010a506:	0f b6 00             	movzbl (%eax),%eax
8010a509:	0f b6 c0             	movzbl %al,%eax
8010a50c:	01 d0                	add    %edx,%eax
8010a50e:	01 45 f4             	add    %eax,-0xc(%ebp)
  for(int i=0;i<(N2H_ushort(tcp_dummy.tcp_len)/2);i++){
8010a511:	83 45 ec 01          	addl   $0x1,-0x14(%ebp)
8010a515:	0f b7 45 de          	movzwl -0x22(%ebp),%eax
8010a519:	0f b7 c0             	movzwl %ax,%eax
8010a51c:	83 ec 0c             	sub    $0xc,%esp
8010a51f:	50                   	push   %eax
8010a520:	e8 fb f5 ff ff       	call   80109b20 <N2H_ushort>
8010a525:	83 c4 10             	add    $0x10,%esp
8010a528:	66 d1 e8             	shr    %ax
8010a52b:	0f b7 c0             	movzwl %ax,%eax
8010a52e:	39 45 ec             	cmp    %eax,-0x14(%ebp)
8010a531:	7c af                	jl     8010a4e2 <tcp_chksum+0xd8>
  }
  chk_sum += (chk_sum>>8*2);
8010a533:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010a536:	c1 e8 10             	shr    $0x10,%eax
8010a539:	01 45 f4             	add    %eax,-0xc(%ebp)
  return ~(chk_sum);
8010a53c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010a53f:	f7 d0                	not    %eax
}
8010a541:	c9                   	leave  
8010a542:	c3                   	ret    

8010a543 <tcp_fin>:

void tcp_fin(){
8010a543:	55                   	push   %ebp
8010a544:	89 e5                	mov    %esp,%ebp
  fin_flag =1;
8010a546:	c7 05 a8 a0 11 80 01 	movl   $0x1,0x8011a0a8
8010a54d:	00 00 00 
}
8010a550:	90                   	nop
8010a551:	5d                   	pop    %ebp
8010a552:	c3                   	ret    

8010a553 <http_proc>:
#include "defs.h"
#include "types.h"
#include "tcp.h"


void http_proc(uint recv, uint recv_size, uint send, uint *send_size){
8010a553:	55                   	push   %ebp
8010a554:	89 e5                	mov    %esp,%ebp
8010a556:	83 ec 18             	sub    $0x18,%esp
  int len;
  len = http_strcpy((char *)send,"HTTP/1.0 200 OK \r\n",0);
8010a559:	8b 45 10             	mov    0x10(%ebp),%eax
8010a55c:	83 ec 04             	sub    $0x4,%esp
8010a55f:	6a 00                	push   $0x0
8010a561:	68 0b c6 10 80       	push   $0x8010c60b
8010a566:	50                   	push   %eax
8010a567:	e8 65 00 00 00       	call   8010a5d1 <http_strcpy>
8010a56c:	83 c4 10             	add    $0x10,%esp
8010a56f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  len += http_strcpy((char *)send,"Content-Type: text/html \r\n",len);
8010a572:	8b 45 10             	mov    0x10(%ebp),%eax
8010a575:	83 ec 04             	sub    $0x4,%esp
8010a578:	ff 75 f4             	push   -0xc(%ebp)
8010a57b:	68 1e c6 10 80       	push   $0x8010c61e
8010a580:	50                   	push   %eax
8010a581:	e8 4b 00 00 00       	call   8010a5d1 <http_strcpy>
8010a586:	83 c4 10             	add    $0x10,%esp
8010a589:	01 45 f4             	add    %eax,-0xc(%ebp)
  len += http_strcpy((char *)send,"\r\nHello World!\r\n",len);
8010a58c:	8b 45 10             	mov    0x10(%ebp),%eax
8010a58f:	83 ec 04             	sub    $0x4,%esp
8010a592:	ff 75 f4             	push   -0xc(%ebp)
8010a595:	68 39 c6 10 80       	push   $0x8010c639
8010a59a:	50                   	push   %eax
8010a59b:	e8 31 00 00 00       	call   8010a5d1 <http_strcpy>
8010a5a0:	83 c4 10             	add    $0x10,%esp
8010a5a3:	01 45 f4             	add    %eax,-0xc(%ebp)
  if(len%2 != 0){
8010a5a6:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010a5a9:	83 e0 01             	and    $0x1,%eax
8010a5ac:	85 c0                	test   %eax,%eax
8010a5ae:	74 11                	je     8010a5c1 <http_proc+0x6e>
    char *payload = (char *)send;
8010a5b0:	8b 45 10             	mov    0x10(%ebp),%eax
8010a5b3:	89 45 f0             	mov    %eax,-0x10(%ebp)
    payload[len] = 0;
8010a5b6:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010a5b9:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010a5bc:	01 d0                	add    %edx,%eax
8010a5be:	c6 00 00             	movb   $0x0,(%eax)
  }
  *send_size = len;
8010a5c1:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010a5c4:	8b 45 14             	mov    0x14(%ebp),%eax
8010a5c7:	89 10                	mov    %edx,(%eax)
  tcp_fin();
8010a5c9:	e8 75 ff ff ff       	call   8010a543 <tcp_fin>
}
8010a5ce:	90                   	nop
8010a5cf:	c9                   	leave  
8010a5d0:	c3                   	ret    

8010a5d1 <http_strcpy>:

int http_strcpy(char *dst,const char *src,int start_index){
8010a5d1:	55                   	push   %ebp
8010a5d2:	89 e5                	mov    %esp,%ebp
8010a5d4:	83 ec 10             	sub    $0x10,%esp
  int i = 0;
8010a5d7:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while(src[i]){
8010a5de:	eb 20                	jmp    8010a600 <http_strcpy+0x2f>
    dst[start_index+i] = src[i];
8010a5e0:	8b 55 fc             	mov    -0x4(%ebp),%edx
8010a5e3:	8b 45 0c             	mov    0xc(%ebp),%eax
8010a5e6:	01 d0                	add    %edx,%eax
8010a5e8:	8b 4d 10             	mov    0x10(%ebp),%ecx
8010a5eb:	8b 55 fc             	mov    -0x4(%ebp),%edx
8010a5ee:	01 ca                	add    %ecx,%edx
8010a5f0:	89 d1                	mov    %edx,%ecx
8010a5f2:	8b 55 08             	mov    0x8(%ebp),%edx
8010a5f5:	01 ca                	add    %ecx,%edx
8010a5f7:	0f b6 00             	movzbl (%eax),%eax
8010a5fa:	88 02                	mov    %al,(%edx)
    i++;
8010a5fc:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
  while(src[i]){
8010a600:	8b 55 fc             	mov    -0x4(%ebp),%edx
8010a603:	8b 45 0c             	mov    0xc(%ebp),%eax
8010a606:	01 d0                	add    %edx,%eax
8010a608:	0f b6 00             	movzbl (%eax),%eax
8010a60b:	84 c0                	test   %al,%al
8010a60d:	75 d1                	jne    8010a5e0 <http_strcpy+0xf>
  }
  return i;
8010a60f:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
8010a612:	c9                   	leave  
8010a613:	c3                   	ret    
