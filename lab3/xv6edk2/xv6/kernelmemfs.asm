
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
8010006f:	68 c0 a2 10 80       	push   $0x8010a2c0
80100074:	68 00 d0 18 80       	push   $0x8018d000
80100079:	e8 04 49 00 00       	call   80104982 <initlock>
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
801000bd:	68 c7 a2 10 80       	push   $0x8010a2c7
801000c2:	50                   	push   %eax
801000c3:	e8 5d 47 00 00       	call   80104825 <initsleeplock>
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
80100101:	e8 9e 48 00 00       	call   801049a4 <acquire>
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
80100140:	e8 cd 48 00 00       	call   80104a12 <release>
80100145:	83 c4 10             	add    $0x10,%esp
      acquiresleep(&b->lock);
80100148:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010014b:	83 c0 0c             	add    $0xc,%eax
8010014e:	83 ec 0c             	sub    $0xc,%esp
80100151:	50                   	push   %eax
80100152:	e8 0a 47 00 00       	call   80104861 <acquiresleep>
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
801001c1:	e8 4c 48 00 00       	call   80104a12 <release>
801001c6:	83 c4 10             	add    $0x10,%esp
      acquiresleep(&b->lock);
801001c9:	8b 45 f4             	mov    -0xc(%ebp),%eax
801001cc:	83 c0 0c             	add    $0xc,%eax
801001cf:	83 ec 0c             	sub    $0xc,%esp
801001d2:	50                   	push   %eax
801001d3:	e8 89 46 00 00       	call   80104861 <acquiresleep>
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
801001f5:	68 ce a2 10 80       	push   $0x8010a2ce
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
8010022d:	e8 9d 9f 00 00       	call   8010a1cf <iderw>
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
8010024a:	e8 c4 46 00 00       	call   80104913 <holdingsleep>
8010024f:	83 c4 10             	add    $0x10,%esp
80100252:	85 c0                	test   %eax,%eax
80100254:	75 0d                	jne    80100263 <bwrite+0x29>
    panic("bwrite");
80100256:	83 ec 0c             	sub    $0xc,%esp
80100259:	68 df a2 10 80       	push   $0x8010a2df
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
80100278:	e8 52 9f 00 00       	call   8010a1cf <iderw>
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
80100293:	e8 7b 46 00 00       	call   80104913 <holdingsleep>
80100298:	83 c4 10             	add    $0x10,%esp
8010029b:	85 c0                	test   %eax,%eax
8010029d:	75 0d                	jne    801002ac <brelse+0x29>
    panic("brelse");
8010029f:	83 ec 0c             	sub    $0xc,%esp
801002a2:	68 e6 a2 10 80       	push   $0x8010a2e6
801002a7:	e8 fd 02 00 00       	call   801005a9 <panic>

  releasesleep(&b->lock);
801002ac:	8b 45 08             	mov    0x8(%ebp),%eax
801002af:	83 c0 0c             	add    $0xc,%eax
801002b2:	83 ec 0c             	sub    $0xc,%esp
801002b5:	50                   	push   %eax
801002b6:	e8 0a 46 00 00       	call   801048c5 <releasesleep>
801002bb:	83 c4 10             	add    $0x10,%esp

  acquire(&bcache.lock);
801002be:	83 ec 0c             	sub    $0xc,%esp
801002c1:	68 00 d0 18 80       	push   $0x8018d000
801002c6:	e8 d9 46 00 00       	call   801049a4 <acquire>
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
80100336:	e8 d7 46 00 00       	call   80104a12 <release>
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
80100410:	e8 8f 45 00 00       	call   801049a4 <acquire>
80100415:	83 c4 10             	add    $0x10,%esp

  if (fmt == 0)
80100418:	8b 45 08             	mov    0x8(%ebp),%eax
8010041b:	85 c0                	test   %eax,%eax
8010041d:	75 0d                	jne    8010042c <cprintf+0x38>
    panic("null fmt");
8010041f:	83 ec 0c             	sub    $0xc,%esp
80100422:	68 ed a2 10 80       	push   $0x8010a2ed
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
80100510:	c7 45 ec f6 a2 10 80 	movl   $0x8010a2f6,-0x14(%ebp)
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
8010059e:	e8 6f 44 00 00       	call   80104a12 <release>
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
801005c7:	68 fd a2 10 80       	push   $0x8010a2fd
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
801005e6:	68 11 a3 10 80       	push   $0x8010a311
801005eb:	e8 04 fe ff ff       	call   801003f4 <cprintf>
801005f0:	83 c4 10             	add    $0x10,%esp
  getcallerpcs(&s, pcs);
801005f3:	83 ec 08             	sub    $0x8,%esp
801005f6:	8d 45 cc             	lea    -0x34(%ebp),%eax
801005f9:	50                   	push   %eax
801005fa:	8d 45 08             	lea    0x8(%ebp),%eax
801005fd:	50                   	push   %eax
801005fe:	e8 61 44 00 00       	call   80104a64 <getcallerpcs>
80100603:	83 c4 10             	add    $0x10,%esp
  for(i=0; i<10; i++)
80100606:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
8010060d:	eb 1c                	jmp    8010062b <panic+0x82>
    cprintf(" %p", pcs[i]);
8010060f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100612:	8b 44 85 cc          	mov    -0x34(%ebp,%eax,4),%eax
80100616:	83 ec 08             	sub    $0x8,%esp
80100619:	50                   	push   %eax
8010061a:	68 13 a3 10 80       	push   $0x8010a313
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
801006a0:	e8 81 7a 00 00       	call   80108126 <graphic_scroll_up>
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
801006f3:	e8 2e 7a 00 00       	call   80108126 <graphic_scroll_up>
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
80100757:	e8 35 7a 00 00       	call   80108191 <font_render>
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
80100793:	e8 05 5e 00 00       	call   8010659d <uartputc>
80100798:	83 c4 10             	add    $0x10,%esp
8010079b:	83 ec 0c             	sub    $0xc,%esp
8010079e:	6a 20                	push   $0x20
801007a0:	e8 f8 5d 00 00       	call   8010659d <uartputc>
801007a5:	83 c4 10             	add    $0x10,%esp
801007a8:	83 ec 0c             	sub    $0xc,%esp
801007ab:	6a 08                	push   $0x8
801007ad:	e8 eb 5d 00 00       	call   8010659d <uartputc>
801007b2:	83 c4 10             	add    $0x10,%esp
801007b5:	eb 0e                	jmp    801007c5 <consputc+0x56>
  } else {
    uartputc(c);
801007b7:	83 ec 0c             	sub    $0xc,%esp
801007ba:	ff 75 08             	push   0x8(%ebp)
801007bd:	e8 db 5d 00 00       	call   8010659d <uartputc>
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
801007eb:	e8 b4 41 00 00       	call   801049a4 <acquire>
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
8010093f:	e8 26 3d 00 00       	call   8010466a <wakeup>
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
80100962:	e8 ab 40 00 00       	call   80104a12 <release>
80100967:	83 c4 10             	add    $0x10,%esp
  if(doprocdump) {
8010096a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
8010096e:	74 05                	je     80100975 <consoleintr+0x19f>
    procdump();  // now call procdump() wo. cons.lock held
80100970:	e8 b3 3d 00 00       	call   80104728 <procdump>
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
8010099a:	e8 05 40 00 00       	call   801049a4 <acquire>
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
801009bb:	e8 52 40 00 00       	call   80104a12 <release>
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
801009e8:	e8 93 3b 00 00       	call   80104580 <sleep>
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
80100a66:	e8 a7 3f 00 00       	call   80104a12 <release>
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
80100aa2:	e8 fd 3e 00 00       	call   801049a4 <acquire>
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
80100ae4:	e8 29 3f 00 00       	call   80104a12 <release>
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
80100b12:	68 17 a3 10 80       	push   $0x8010a317
80100b17:	68 00 1a 19 80       	push   $0x80191a00
80100b1c:	e8 61 3e 00 00       	call   80104982 <initlock>
80100b21:	83 c4 10             	add    $0x10,%esp

  devsw[CONSOLE].write = consolewrite;
80100b24:	c7 05 4c 1a 19 80 86 	movl   $0x80100a86,0x80191a4c
80100b2b:	0a 10 80 
  devsw[CONSOLE].read = consoleread;
80100b2e:	c7 05 48 1a 19 80 78 	movl   $0x80100978,0x80191a48
80100b35:	09 10 80 
  
  char *p;
  for(p="Starting XV6_UEFI...\n"; *p; p++)
80100b38:	c7 45 f4 1f a3 10 80 	movl   $0x8010a31f,-0xc(%ebp)
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
80100bb5:	68 35 a3 10 80       	push   $0x8010a335
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
80100c11:	e8 83 69 00 00       	call   80107599 <setupkvm>
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
80100cb7:	e8 d6 6c 00 00       	call   80107992 <allocuvm>
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
80100cfd:	e8 c3 6b 00 00       	call   801078c5 <loaduvm>
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
80100d6c:	e8 21 6c 00 00       	call   80107992 <allocuvm>
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
80100d90:	e8 5f 6e 00 00       	call   80107bf4 <clearpteu>
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
80100dc9:	e8 9a 40 00 00       	call   80104e68 <strlen>
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
80100df6:	e8 6d 40 00 00       	call   80104e68 <strlen>
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
80100e1c:	e8 72 6f 00 00       	call   80107d93 <copyout>
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
80100eb8:	e8 d6 6e 00 00       	call   80107d93 <copyout>
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
80100f06:	e8 12 3f 00 00       	call   80104e1d <safestrcpy>
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
80100f49:	e8 68 67 00 00       	call   801076b6 <switchuvm>
80100f4e:	83 c4 10             	add    $0x10,%esp
  freevm(oldpgdir);
80100f51:	83 ec 0c             	sub    $0xc,%esp
80100f54:	ff 75 cc             	push   -0x34(%ebp)
80100f57:	e8 ff 6b 00 00       	call   80107b5b <freevm>
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
80100f97:	e8 bf 6b 00 00       	call   80107b5b <freevm>
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
80100fc8:	68 41 a3 10 80       	push   $0x8010a341
80100fcd:	68 a0 1a 19 80       	push   $0x80191aa0
80100fd2:	e8 ab 39 00 00       	call   80104982 <initlock>
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
80100feb:	e8 b4 39 00 00       	call   801049a4 <acquire>
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
80101018:	e8 f5 39 00 00       	call   80104a12 <release>
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
8010103b:	e8 d2 39 00 00       	call   80104a12 <release>
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
80101058:	e8 47 39 00 00       	call   801049a4 <acquire>
8010105d:	83 c4 10             	add    $0x10,%esp
  if(f->ref < 1)
80101060:	8b 45 08             	mov    0x8(%ebp),%eax
80101063:	8b 40 04             	mov    0x4(%eax),%eax
80101066:	85 c0                	test   %eax,%eax
80101068:	7f 0d                	jg     80101077 <filedup+0x2d>
    panic("filedup");
8010106a:	83 ec 0c             	sub    $0xc,%esp
8010106d:	68 48 a3 10 80       	push   $0x8010a348
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
8010108e:	e8 7f 39 00 00       	call   80104a12 <release>
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
801010a9:	e8 f6 38 00 00       	call   801049a4 <acquire>
801010ae:	83 c4 10             	add    $0x10,%esp
  if(f->ref < 1)
801010b1:	8b 45 08             	mov    0x8(%ebp),%eax
801010b4:	8b 40 04             	mov    0x4(%eax),%eax
801010b7:	85 c0                	test   %eax,%eax
801010b9:	7f 0d                	jg     801010c8 <fileclose+0x2d>
    panic("fileclose");
801010bb:	83 ec 0c             	sub    $0xc,%esp
801010be:	68 50 a3 10 80       	push   $0x8010a350
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
801010e9:	e8 24 39 00 00       	call   80104a12 <release>
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
80101137:	e8 d6 38 00 00       	call   80104a12 <release>
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
80101286:	68 5a a3 10 80       	push   $0x8010a35a
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
80101389:	68 63 a3 10 80       	push   $0x8010a363
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
801013bf:	68 73 a3 10 80       	push   $0x8010a373
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
801013f7:	e8 dd 38 00 00       	call   80104cd9 <memmove>
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
8010143d:	e8 d8 37 00 00       	call   80104c1a <memset>
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
8010159c:	68 80 a3 10 80       	push   $0x8010a380
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
80101627:	68 96 a3 10 80       	push   $0x8010a396
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
8010168b:	68 a9 a3 10 80       	push   $0x8010a3a9
80101690:	68 60 24 19 80       	push   $0x80192460
80101695:	e8 e8 32 00 00       	call   80104982 <initlock>
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
801016c1:	68 b0 a3 10 80       	push   $0x8010a3b0
801016c6:	50                   	push   %eax
801016c7:	e8 59 31 00 00       	call   80104825 <initsleeplock>
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
80101720:	68 b8 a3 10 80       	push   $0x8010a3b8
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
80101799:	e8 7c 34 00 00       	call   80104c1a <memset>
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
80101801:	68 0b a4 10 80       	push   $0x8010a40b
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
801018a7:	e8 2d 34 00 00       	call   80104cd9 <memmove>
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
801018dc:	e8 c3 30 00 00       	call   801049a4 <acquire>
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
8010192a:	e8 e3 30 00 00       	call   80104a12 <release>
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
80101966:	68 1d a4 10 80       	push   $0x8010a41d
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
801019a3:	e8 6a 30 00 00       	call   80104a12 <release>
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
801019be:	e8 e1 2f 00 00       	call   801049a4 <acquire>
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
801019dd:	e8 30 30 00 00       	call   80104a12 <release>
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
80101a03:	68 2d a4 10 80       	push   $0x8010a42d
80101a08:	e8 9c eb ff ff       	call   801005a9 <panic>

  acquiresleep(&ip->lock);
80101a0d:	8b 45 08             	mov    0x8(%ebp),%eax
80101a10:	83 c0 0c             	add    $0xc,%eax
80101a13:	83 ec 0c             	sub    $0xc,%esp
80101a16:	50                   	push   %eax
80101a17:	e8 45 2e 00 00       	call   80104861 <acquiresleep>
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
80101ac1:	e8 13 32 00 00       	call   80104cd9 <memmove>
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
80101af0:	68 33 a4 10 80       	push   $0x8010a433
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
80101b13:	e8 fb 2d 00 00       	call   80104913 <holdingsleep>
80101b18:	83 c4 10             	add    $0x10,%esp
80101b1b:	85 c0                	test   %eax,%eax
80101b1d:	74 0a                	je     80101b29 <iunlock+0x2c>
80101b1f:	8b 45 08             	mov    0x8(%ebp),%eax
80101b22:	8b 40 08             	mov    0x8(%eax),%eax
80101b25:	85 c0                	test   %eax,%eax
80101b27:	7f 0d                	jg     80101b36 <iunlock+0x39>
    panic("iunlock");
80101b29:	83 ec 0c             	sub    $0xc,%esp
80101b2c:	68 42 a4 10 80       	push   $0x8010a442
80101b31:	e8 73 ea ff ff       	call   801005a9 <panic>

  releasesleep(&ip->lock);
80101b36:	8b 45 08             	mov    0x8(%ebp),%eax
80101b39:	83 c0 0c             	add    $0xc,%eax
80101b3c:	83 ec 0c             	sub    $0xc,%esp
80101b3f:	50                   	push   %eax
80101b40:	e8 80 2d 00 00       	call   801048c5 <releasesleep>
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
80101b5b:	e8 01 2d 00 00       	call   80104861 <acquiresleep>
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
80101b81:	e8 1e 2e 00 00       	call   801049a4 <acquire>
80101b86:	83 c4 10             	add    $0x10,%esp
    int r = ip->ref;
80101b89:	8b 45 08             	mov    0x8(%ebp),%eax
80101b8c:	8b 40 08             	mov    0x8(%eax),%eax
80101b8f:	89 45 f4             	mov    %eax,-0xc(%ebp)
    release(&icache.lock);
80101b92:	83 ec 0c             	sub    $0xc,%esp
80101b95:	68 60 24 19 80       	push   $0x80192460
80101b9a:	e8 73 2e 00 00       	call   80104a12 <release>
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
80101be1:	e8 df 2c 00 00       	call   801048c5 <releasesleep>
80101be6:	83 c4 10             	add    $0x10,%esp

  acquire(&icache.lock);
80101be9:	83 ec 0c             	sub    $0xc,%esp
80101bec:	68 60 24 19 80       	push   $0x80192460
80101bf1:	e8 ae 2d 00 00       	call   801049a4 <acquire>
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
80101c10:	e8 fd 2d 00 00       	call   80104a12 <release>
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
80101d54:	68 4a a4 10 80       	push   $0x8010a44a
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
80101ff2:	e8 e2 2c 00 00       	call   80104cd9 <memmove>
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
80102142:	e8 92 2b 00 00       	call   80104cd9 <memmove>
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
801021c2:	e8 a8 2b 00 00       	call   80104d6f <strncmp>
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
801021e2:	68 5d a4 10 80       	push   $0x8010a45d
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
80102211:	68 6f a4 10 80       	push   $0x8010a46f
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
801022e6:	68 7e a4 10 80       	push   $0x8010a47e
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
80102321:	e8 9f 2a 00 00       	call   80104dc5 <strncpy>
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
8010234d:	68 8b a4 10 80       	push   $0x8010a48b
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
801023bf:	e8 15 29 00 00       	call   80104cd9 <memmove>
801023c4:	83 c4 10             	add    $0x10,%esp
801023c7:	eb 26                	jmp    801023ef <skipelem+0x91>
  else {
    memmove(name, s, len);
801023c9:	8b 45 f0             	mov    -0x10(%ebp),%eax
801023cc:	83 ec 04             	sub    $0x4,%esp
801023cf:	50                   	push   %eax
801023d0:	ff 75 f4             	push   -0xc(%ebp)
801023d3:	ff 75 0c             	push   0xc(%ebp)
801023d6:	e8 fe 28 00 00       	call   80104cd9 <memmove>
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
801025cd:	68 94 a4 10 80       	push   $0x8010a494
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
80102674:	68 c6 a4 10 80       	push   $0x8010a4c6
80102679:	68 c0 40 19 80       	push   $0x801940c0
8010267e:	e8 ff 22 00 00       	call   80104982 <initlock>
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
80102733:	68 cb a4 10 80       	push   $0x8010a4cb
80102738:	e8 6c de ff ff       	call   801005a9 <panic>

  // Fill with junk to catch dangling refs.
  memset(v, 1, PGSIZE);
8010273d:	83 ec 04             	sub    $0x4,%esp
80102740:	68 00 10 00 00       	push   $0x1000
80102745:	6a 01                	push   $0x1
80102747:	ff 75 08             	push   0x8(%ebp)
8010274a:	e8 cb 24 00 00       	call   80104c1a <memset>
8010274f:	83 c4 10             	add    $0x10,%esp

  if(kmem.use_lock)
80102752:	a1 f4 40 19 80       	mov    0x801940f4,%eax
80102757:	85 c0                	test   %eax,%eax
80102759:	74 10                	je     8010276b <kfree+0x65>
    acquire(&kmem.lock);
8010275b:	83 ec 0c             	sub    $0xc,%esp
8010275e:	68 c0 40 19 80       	push   $0x801940c0
80102763:	e8 3c 22 00 00       	call   801049a4 <acquire>
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
80102795:	e8 78 22 00 00       	call   80104a12 <release>
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
801027b7:	e8 e8 21 00 00       	call   801049a4 <acquire>
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
801027e8:	e8 25 22 00 00       	call   80104a12 <release>
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
80102d12:	e8 6a 1f 00 00       	call   80104c81 <memcmp>
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
80102e26:	68 d1 a4 10 80       	push   $0x8010a4d1
80102e2b:	68 20 41 19 80       	push   $0x80194120
80102e30:	e8 4d 1b 00 00       	call   80104982 <initlock>
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
80102edb:	e8 f9 1d 00 00       	call   80104cd9 <memmove>
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
8010304a:	e8 55 19 00 00       	call   801049a4 <acquire>
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
80103068:	e8 13 15 00 00       	call   80104580 <sleep>
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
8010309d:	e8 de 14 00 00       	call   80104580 <sleep>
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
801030bc:	e8 51 19 00 00       	call   80104a12 <release>
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
801030dd:	e8 c2 18 00 00       	call   801049a4 <acquire>
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
801030fe:	68 d5 a4 10 80       	push   $0x8010a4d5
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
8010312c:	e8 39 15 00 00       	call   8010466a <wakeup>
80103131:	83 c4 10             	add    $0x10,%esp
  }
  release(&log.lock);
80103134:	83 ec 0c             	sub    $0xc,%esp
80103137:	68 20 41 19 80       	push   $0x80194120
8010313c:	e8 d1 18 00 00       	call   80104a12 <release>
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
80103157:	e8 48 18 00 00       	call   801049a4 <acquire>
8010315c:	83 c4 10             	add    $0x10,%esp
    log.committing = 0;
8010315f:	c7 05 60 41 19 80 00 	movl   $0x0,0x80194160
80103166:	00 00 00 
    wakeup(&log);
80103169:	83 ec 0c             	sub    $0xc,%esp
8010316c:	68 20 41 19 80       	push   $0x80194120
80103171:	e8 f4 14 00 00       	call   8010466a <wakeup>
80103176:	83 c4 10             	add    $0x10,%esp
    release(&log.lock);
80103179:	83 ec 0c             	sub    $0xc,%esp
8010317c:	68 20 41 19 80       	push   $0x80194120
80103181:	e8 8c 18 00 00       	call   80104a12 <release>
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
801031fd:	e8 d7 1a 00 00       	call   80104cd9 <memmove>
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
8010329a:	68 e4 a4 10 80       	push   $0x8010a4e4
8010329f:	e8 05 d3 ff ff       	call   801005a9 <panic>
  if (log.outstanding < 1)
801032a4:	a1 5c 41 19 80       	mov    0x8019415c,%eax
801032a9:	85 c0                	test   %eax,%eax
801032ab:	7f 0d                	jg     801032ba <log_write+0x45>
    panic("log_write outside of trans");
801032ad:	83 ec 0c             	sub    $0xc,%esp
801032b0:	68 fa a4 10 80       	push   $0x8010a4fa
801032b5:	e8 ef d2 ff ff       	call   801005a9 <panic>

  acquire(&log.lock);
801032ba:	83 ec 0c             	sub    $0xc,%esp
801032bd:	68 20 41 19 80       	push   $0x80194120
801032c2:	e8 dd 16 00 00       	call   801049a4 <acquire>
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
80103340:	e8 cd 16 00 00       	call   80104a12 <release>
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
80103376:	e8 f0 4c 00 00       	call   8010806b <graphic_init>
  kinit1(end, P2V(4*1024*1024)); // phys page allocator
8010337b:	83 ec 08             	sub    $0x8,%esp
8010337e:	68 00 00 40 80       	push   $0x80400000
80103383:	68 00 90 19 80       	push   $0x80199000
80103388:	e8 de f2 ff ff       	call   8010266b <kinit1>
8010338d:	83 c4 10             	add    $0x10,%esp
  kvmalloc();      // kernel page table
80103390:	e8 f0 42 00 00       	call   80107685 <kvmalloc>
  mpinit_uefi();
80103395:	e8 97 4a 00 00       	call   80107e31 <mpinit_uefi>
  lapicinit();     // interrupt controller
8010339a:	e8 3c f6 ff ff       	call   801029db <lapicinit>
  seginit();       // segment descriptors
8010339f:	e8 79 3d 00 00       	call   8010711d <seginit>
  picinit();    // disable pic
801033a4:	e8 9d 01 00 00       	call   80103546 <picinit>
  ioapicinit();    // another interrupt controller
801033a9:	e8 d8 f1 ff ff       	call   80102586 <ioapicinit>
  consoleinit();   // console hardware
801033ae:	e8 4c d7 ff ff       	call   80100aff <consoleinit>
  uartinit();      // serial port
801033b3:	e8 fe 30 00 00       	call   801064b6 <uartinit>
  pinit();         // process table
801033b8:	e8 c2 05 00 00       	call   8010397f <pinit>
  tvinit();        // trap vectors
801033bd:	e8 c5 2c 00 00       	call   80106087 <tvinit>
  binit();         // buffer cache
801033c2:	e8 9f cc ff ff       	call   80100066 <binit>
  fileinit();      // file table
801033c7:	e8 f3 db ff ff       	call   80100fbf <fileinit>
  ideinit();       // disk 
801033cc:	e8 db 6d 00 00       	call   8010a1ac <ideinit>
  startothers();   // start other processors
801033d1:	e8 8a 00 00 00       	call   80103460 <startothers>
  kinit2(P2V(4*1024*1024), P2V(PHYSTOP)); // must come after startothers()
801033d6:	83 ec 08             	sub    $0x8,%esp
801033d9:	68 00 00 00 a0       	push   $0xa0000000
801033de:	68 00 00 40 80       	push   $0x80400000
801033e3:	e8 bc f2 ff ff       	call   801026a4 <kinit2>
801033e8:	83 c4 10             	add    $0x10,%esp
  pci_init();
801033eb:	e8 d4 4e 00 00       	call   801082c4 <pci_init>
  arp_scan();
801033f0:	e8 0b 5c 00 00       	call   80109000 <arp_scan>
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
80103405:	e8 93 42 00 00       	call   8010769d <switchkvm>
  seginit();
8010340a:	e8 0e 3d 00 00       	call   8010711d <seginit>
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
80103431:	68 15 a5 10 80       	push   $0x8010a515
80103436:	e8 b9 cf ff ff       	call   801003f4 <cprintf>
8010343b:	83 c4 10             	add    $0x10,%esp
  idtinit();       // load idt register
8010343e:	e8 ba 2d 00 00       	call   801061fd <idtinit>
  xchg(&(mycpu()->started), 1); // tell startothers() we're up
80103443:	e8 70 05 00 00       	call   801039b8 <mycpu>
80103448:	05 a0 00 00 00       	add    $0xa0,%eax
8010344d:	83 ec 08             	sub    $0x8,%esp
80103450:	6a 01                	push   $0x1
80103452:	50                   	push   %eax
80103453:	e8 f3 fe ff ff       	call   8010334b <xchg>
80103458:	83 c4 10             	add    $0x10,%esp
  scheduler();     // start running processes
8010345b:	e8 2c 0f 00 00       	call   8010438c <scheduler>

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
8010347e:	e8 56 18 00 00       	call   80104cd9 <memmove>
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
80103607:	68 29 a5 10 80       	push   $0x8010a529
8010360c:	50                   	push   %eax
8010360d:	e8 70 13 00 00       	call   80104982 <initlock>
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
801036cc:	e8 d3 12 00 00       	call   801049a4 <acquire>
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
801036f3:	e8 72 0f 00 00       	call   8010466a <wakeup>
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
80103716:	e8 4f 0f 00 00       	call   8010466a <wakeup>
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
8010373f:	e8 ce 12 00 00       	call   80104a12 <release>
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
8010375e:	e8 af 12 00 00       	call   80104a12 <release>
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
80103778:	e8 27 12 00 00       	call   801049a4 <acquire>
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
801037ac:	e8 61 12 00 00       	call   80104a12 <release>
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
801037ca:	e8 9b 0e 00 00       	call   8010466a <wakeup>
801037cf:	83 c4 10             	add    $0x10,%esp
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
801037d2:	8b 45 08             	mov    0x8(%ebp),%eax
801037d5:	8b 55 08             	mov    0x8(%ebp),%edx
801037d8:	81 c2 38 02 00 00    	add    $0x238,%edx
801037de:	83 ec 08             	sub    $0x8,%esp
801037e1:	50                   	push   %eax
801037e2:	52                   	push   %edx
801037e3:	e8 98 0d 00 00       	call   80104580 <sleep>
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
8010384d:	e8 18 0e 00 00       	call   8010466a <wakeup>
80103852:	83 c4 10             	add    $0x10,%esp
  release(&p->lock);
80103855:	8b 45 08             	mov    0x8(%ebp),%eax
80103858:	83 ec 0c             	sub    $0xc,%esp
8010385b:	50                   	push   %eax
8010385c:	e8 b1 11 00 00       	call   80104a12 <release>
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
80103879:	e8 26 11 00 00       	call   801049a4 <acquire>
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
80103896:	e8 77 11 00 00       	call   80104a12 <release>
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
801038b9:	e8 c2 0c 00 00       	call   80104580 <sleep>
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
8010394c:	e8 19 0d 00 00       	call   8010466a <wakeup>
80103951:	83 c4 10             	add    $0x10,%esp
  release(&p->lock);
80103954:	8b 45 08             	mov    0x8(%ebp),%eax
80103957:	83 ec 0c             	sub    $0xc,%esp
8010395a:	50                   	push   %eax
8010395b:	e8 b2 10 00 00       	call   80104a12 <release>
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
80103988:	68 30 a5 10 80       	push   $0x8010a530
8010398d:	68 00 42 19 80       	push   $0x80194200
80103992:	e8 eb 0f 00 00       	call   80104982 <initlock>
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
801039cf:	68 38 a5 10 80       	push   $0x8010a538
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
80103a24:	68 5e a5 10 80       	push   $0x8010a55e
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
80103a36:	e8 d4 10 00 00       	call   80104b0f <pushcli>
  c = mycpu();
80103a3b:	e8 78 ff ff ff       	call   801039b8 <mycpu>
80103a40:	89 45 f4             	mov    %eax,-0xc(%ebp)
  p = c->proc;
80103a43:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103a46:	8b 80 ac 00 00 00    	mov    0xac(%eax),%eax
80103a4c:	89 45 f0             	mov    %eax,-0x10(%ebp)
  popcli();
80103a4f:	e8 08 11 00 00       	call   80104b5c <popcli>
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
80103a67:	e8 38 0f 00 00       	call   801049a4 <acquire>
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
80103a9a:	e8 73 0f 00 00       	call   80104a12 <release>
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
80103ad3:	e8 3a 0f 00 00       	call   80104a12 <release>
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
80103b20:	ba 41 60 10 80       	mov    $0x80106041,%edx
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
80103b45:	e8 d0 10 00 00       	call   80104c1a <memset>
80103b4a:	83 c4 10             	add    $0x10,%esp
  p->context->eip = (uint)forkret;
80103b4d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103b50:	8b 40 1c             	mov    0x1c(%eax),%eax
80103b53:	ba 3a 45 10 80       	mov    $0x8010453a,%edx
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
80103b76:	e8 1e 3a 00 00       	call   80107599 <setupkvm>
80103b7b:	8b 55 f4             	mov    -0xc(%ebp),%edx
80103b7e:	89 42 04             	mov    %eax,0x4(%edx)
80103b81:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103b84:	8b 40 04             	mov    0x4(%eax),%eax
80103b87:	85 c0                	test   %eax,%eax
80103b89:	75 0d                	jne    80103b98 <userinit+0x38>
    panic("userinit: out of memory?");
80103b8b:	83 ec 0c             	sub    $0xc,%esp
80103b8e:	68 6e a5 10 80       	push   $0x8010a56e
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
80103bad:	e8 a3 3c 00 00       	call   80107855 <inituvm>
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
80103bcc:	e8 49 10 00 00       	call   80104c1a <memset>
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
80103c46:	68 87 a5 10 80       	push   $0x8010a587
80103c4b:	50                   	push   %eax
80103c4c:	e8 cc 11 00 00       	call   80104e1d <safestrcpy>
80103c51:	83 c4 10             	add    $0x10,%esp
  p->cwd = namei("/");
80103c54:	83 ec 0c             	sub    $0xc,%esp
80103c57:	68 90 a5 10 80       	push   $0x8010a590
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
80103c72:	e8 2d 0d 00 00       	call   801049a4 <acquire>
80103c77:	83 c4 10             	add    $0x10,%esp

  p->state = RUNNABLE;
80103c7a:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103c7d:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)

  release(&ptable.lock);
80103c84:	83 ec 0c             	sub    $0xc,%esp
80103c87:	68 00 42 19 80       	push   $0x80194200
80103c8c:	e8 81 0d 00 00       	call   80104a12 <release>
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
80103cc9:	e8 c4 3c 00 00       	call   80107992 <allocuvm>
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
80103cfd:	e8 95 3d 00 00       	call   80107a97 <deallocuvm>
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
80103d23:	e8 8e 39 00 00       	call   801076b6 <switchuvm>
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
80103d6b:	e8 c5 3e 00 00       	call   80107c35 <copyuvm>
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
80103e65:	e8 b3 0f 00 00       	call   80104e1d <safestrcpy>
80103e6a:	83 c4 10             	add    $0x10,%esp

  pid = np->pid;
80103e6d:	8b 45 dc             	mov    -0x24(%ebp),%eax
80103e70:	8b 40 10             	mov    0x10(%eax),%eax
80103e73:	89 45 d8             	mov    %eax,-0x28(%ebp)

  acquire(&ptable.lock);
80103e76:	83 ec 0c             	sub    $0xc,%esp
80103e79:	68 00 42 19 80       	push   $0x80194200
80103e7e:	e8 21 0b 00 00       	call   801049a4 <acquire>
80103e83:	83 c4 10             	add    $0x10,%esp

  np->state = RUNNABLE;
80103e86:	8b 45 dc             	mov    -0x24(%ebp),%eax
80103e89:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)

  release(&ptable.lock);
80103e90:	83 ec 0c             	sub    $0xc,%esp
80103e93:	68 00 42 19 80       	push   $0x80194200
80103e98:	e8 75 0b 00 00       	call   80104a12 <release>
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
80103ec6:	68 92 a5 10 80       	push   $0x8010a592
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
80103f4c:	e8 53 0a 00 00       	call   801049a4 <acquire>
80103f51:	83 c4 10             	add    $0x10,%esp

  // Parent might be sleeping in wait().
  wakeup1(curproc->parent);
80103f54:	8b 45 ec             	mov    -0x14(%ebp),%eax
80103f57:	8b 40 14             	mov    0x14(%eax),%eax
80103f5a:	83 ec 0c             	sub    $0xc,%esp
80103f5d:	50                   	push   %eax
80103f5e:	e8 c4 06 00 00       	call   80104627 <wakeup1>
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
80103f9a:	e8 88 06 00 00       	call   80104627 <wakeup1>
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
80103fbc:	e8 86 04 00 00       	call   80104447 <sched>
  panic("zombie exit");
80103fc1:	83 ec 0c             	sub    $0xc,%esp
80103fc4:	68 9f a5 10 80       	push   $0x8010a59f
80103fc9:	e8 db c5 ff ff       	call   801005a9 <panic>

80103fce <uthread_init>:
}

int
uthread_init(int address){
80103fce:	55                   	push   %ebp
80103fcf:	89 e5                	mov    %esp,%ebp
80103fd1:	83 ec 18             	sub    $0x18,%esp
  struct proc *curproc = myproc();
80103fd4:	e8 57 fa ff ff       	call   80103a30 <myproc>
80103fd9:	89 45 f4             	mov    %eax,-0xc(%ebp)

  curproc->scheduler = address;
80103fdc:	8b 55 08             	mov    0x8(%ebp),%edx
80103fdf:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103fe2:	89 90 80 00 00 00    	mov    %edx,0x80(%eax)
  return 0;
80103fe8:	b8 00 00 00 00       	mov    $0x0,%eax
}
80103fed:	c9                   	leave  
80103fee:	c3                   	ret    

80103fef <exit2>:
//******************************************
//************   new  **********************
//************ eixt2() *********************
//******************************************
void
exit2(int status){
80103fef:	55                   	push   %ebp
80103ff0:	89 e5                	mov    %esp,%ebp
80103ff2:	83 ec 18             	sub    $0x18,%esp
  struct proc *curproc = myproc();
80103ff5:	e8 36 fa ff ff       	call   80103a30 <myproc>
80103ffa:	89 45 ec             	mov    %eax,-0x14(%ebp)
  struct proc *p;
  int fd;
 
  //***********새로 추가된 부분. Copy status to xstate**********
  curproc->parent->xstate = status;
80103ffd:	8b 45 ec             	mov    -0x14(%ebp),%eax
80104000:	8b 40 14             	mov    0x14(%eax),%eax
80104003:	8b 55 08             	mov    0x8(%ebp),%edx
80104006:	89 50 7c             	mov    %edx,0x7c(%eax)
  //************************************************************

  if(curproc == initproc)
80104009:	a1 34 63 19 80       	mov    0x80196334,%eax
8010400e:	39 45 ec             	cmp    %eax,-0x14(%ebp)
80104011:	75 0d                	jne    80104020 <exit2+0x31>
    panic("init exiting");
80104013:	83 ec 0c             	sub    $0xc,%esp
80104016:	68 92 a5 10 80       	push   $0x8010a592
8010401b:	e8 89 c5 ff ff       	call   801005a9 <panic>

  // Close all open files.
  for(fd = 0; fd < NOFILE; fd++){
80104020:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
80104027:	eb 3f                	jmp    80104068 <exit2+0x79>
    if(curproc->ofile[fd]){
80104029:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010402c:	8b 55 f0             	mov    -0x10(%ebp),%edx
8010402f:	83 c2 08             	add    $0x8,%edx
80104032:	8b 44 90 08          	mov    0x8(%eax,%edx,4),%eax
80104036:	85 c0                	test   %eax,%eax
80104038:	74 2a                	je     80104064 <exit2+0x75>
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
8010406c:	7e bb                	jle    80104029 <exit2+0x3a>
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
8010409c:	e8 03 09 00 00       	call   801049a4 <acquire>
801040a1:	83 c4 10             	add    $0x10,%esp

  // Parent might be sleeping in wait().
  wakeup1(curproc->parent);
801040a4:	8b 45 ec             	mov    -0x14(%ebp),%eax
801040a7:	8b 40 14             	mov    0x14(%eax),%eax
801040aa:	83 ec 0c             	sub    $0xc,%esp
801040ad:	50                   	push   %eax
801040ae:	e8 74 05 00 00       	call   80104627 <wakeup1>
801040b3:	83 c4 10             	add    $0x10,%esp

  // Pass abandoned children to init.
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801040b6:	c7 45 f4 34 42 19 80 	movl   $0x80194234,-0xc(%ebp)
801040bd:	eb 3a                	jmp    801040f9 <exit2+0x10a>
    if(p->parent == curproc){
801040bf:	8b 45 f4             	mov    -0xc(%ebp),%eax
801040c2:	8b 40 14             	mov    0x14(%eax),%eax
801040c5:	39 45 ec             	cmp    %eax,-0x14(%ebp)
801040c8:	75 28                	jne    801040f2 <exit2+0x103>
      p->parent = initproc;
801040ca:	8b 15 34 63 19 80    	mov    0x80196334,%edx
801040d0:	8b 45 f4             	mov    -0xc(%ebp),%eax
801040d3:	89 50 14             	mov    %edx,0x14(%eax)
      if(p->state == ZOMBIE)
801040d6:	8b 45 f4             	mov    -0xc(%ebp),%eax
801040d9:	8b 40 0c             	mov    0xc(%eax),%eax
801040dc:	83 f8 05             	cmp    $0x5,%eax
801040df:	75 11                	jne    801040f2 <exit2+0x103>
        wakeup1(initproc);
801040e1:	a1 34 63 19 80       	mov    0x80196334,%eax
801040e6:	83 ec 0c             	sub    $0xc,%esp
801040e9:	50                   	push   %eax
801040ea:	e8 38 05 00 00       	call   80104627 <wakeup1>
801040ef:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801040f2:	81 45 f4 84 00 00 00 	addl   $0x84,-0xc(%ebp)
801040f9:	81 7d f4 34 63 19 80 	cmpl   $0x80196334,-0xc(%ebp)
80104100:	72 bd                	jb     801040bf <exit2+0xd0>
    }
  }

  // Jump into the scheduler, never to return.
  curproc->state = ZOMBIE;
80104102:	8b 45 ec             	mov    -0x14(%ebp),%eax
80104105:	c7 40 0c 05 00 00 00 	movl   $0x5,0xc(%eax)
  sched();
8010410c:	e8 36 03 00 00       	call   80104447 <sched>
  panic("zombie exit");
80104111:	83 ec 0c             	sub    $0xc,%esp
80104114:	68 9f a5 10 80       	push   $0x8010a59f
80104119:	e8 8b c4 ff ff       	call   801005a9 <panic>

8010411e <wait>:

// Wait for a child process to exit and return its pid.
// Return -1 if this process has no children.
int
wait(void)
{
8010411e:	55                   	push   %ebp
8010411f:	89 e5                	mov    %esp,%ebp
80104121:	83 ec 18             	sub    $0x18,%esp
  struct proc *p;
  int havekids, pid;
  struct proc *curproc = myproc();
80104124:	e8 07 f9 ff ff       	call   80103a30 <myproc>
80104129:	89 45 ec             	mov    %eax,-0x14(%ebp)
  
  acquire(&ptable.lock);
8010412c:	83 ec 0c             	sub    $0xc,%esp
8010412f:	68 00 42 19 80       	push   $0x80194200
80104134:	e8 6b 08 00 00       	call   801049a4 <acquire>
80104139:	83 c4 10             	add    $0x10,%esp
  for(;;){
    // Scan through table looking for exited children.
    havekids = 0;
8010413c:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104143:	c7 45 f4 34 42 19 80 	movl   $0x80194234,-0xc(%ebp)
8010414a:	e9 a4 00 00 00       	jmp    801041f3 <wait+0xd5>
      if(p->parent != curproc)
8010414f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104152:	8b 40 14             	mov    0x14(%eax),%eax
80104155:	39 45 ec             	cmp    %eax,-0x14(%ebp)
80104158:	0f 85 8d 00 00 00    	jne    801041eb <wait+0xcd>
        continue;
      havekids = 1;
8010415e:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
      if(p->state == ZOMBIE){
80104165:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104168:	8b 40 0c             	mov    0xc(%eax),%eax
8010416b:	83 f8 05             	cmp    $0x5,%eax
8010416e:	75 7c                	jne    801041ec <wait+0xce>
        // Found one.
        pid = p->pid;
80104170:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104173:	8b 40 10             	mov    0x10(%eax),%eax
80104176:	89 45 e8             	mov    %eax,-0x18(%ebp)
        kfree(p->kstack);
80104179:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010417c:	8b 40 08             	mov    0x8(%eax),%eax
8010417f:	83 ec 0c             	sub    $0xc,%esp
80104182:	50                   	push   %eax
80104183:	e8 7e e5 ff ff       	call   80102706 <kfree>
80104188:	83 c4 10             	add    $0x10,%esp
        p->kstack = 0;
8010418b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010418e:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
        freevm(p->pgdir);
80104195:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104198:	8b 40 04             	mov    0x4(%eax),%eax
8010419b:	83 ec 0c             	sub    $0xc,%esp
8010419e:	50                   	push   %eax
8010419f:	e8 b7 39 00 00       	call   80107b5b <freevm>
801041a4:	83 c4 10             	add    $0x10,%esp
        p->pid = 0;
801041a7:	8b 45 f4             	mov    -0xc(%ebp),%eax
801041aa:	c7 40 10 00 00 00 00 	movl   $0x0,0x10(%eax)
        p->parent = 0;
801041b1:	8b 45 f4             	mov    -0xc(%ebp),%eax
801041b4:	c7 40 14 00 00 00 00 	movl   $0x0,0x14(%eax)
        p->name[0] = 0;
801041bb:	8b 45 f4             	mov    -0xc(%ebp),%eax
801041be:	c6 40 6c 00          	movb   $0x0,0x6c(%eax)
        p->killed = 0;
801041c2:	8b 45 f4             	mov    -0xc(%ebp),%eax
801041c5:	c7 40 24 00 00 00 00 	movl   $0x0,0x24(%eax)
        p->state = UNUSED;
801041cc:	8b 45 f4             	mov    -0xc(%ebp),%eax
801041cf:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
        release(&ptable.lock);
801041d6:	83 ec 0c             	sub    $0xc,%esp
801041d9:	68 00 42 19 80       	push   $0x80194200
801041de:	e8 2f 08 00 00       	call   80104a12 <release>
801041e3:	83 c4 10             	add    $0x10,%esp
        return pid;
801041e6:	8b 45 e8             	mov    -0x18(%ebp),%eax
801041e9:	eb 54                	jmp    8010423f <wait+0x121>
        continue;
801041eb:	90                   	nop
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801041ec:	81 45 f4 84 00 00 00 	addl   $0x84,-0xc(%ebp)
801041f3:	81 7d f4 34 63 19 80 	cmpl   $0x80196334,-0xc(%ebp)
801041fa:	0f 82 4f ff ff ff    	jb     8010414f <wait+0x31>
      }
    }

    // No point waiting if we don't have any children.
    if(!havekids || curproc->killed){
80104200:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80104204:	74 0a                	je     80104210 <wait+0xf2>
80104206:	8b 45 ec             	mov    -0x14(%ebp),%eax
80104209:	8b 40 24             	mov    0x24(%eax),%eax
8010420c:	85 c0                	test   %eax,%eax
8010420e:	74 17                	je     80104227 <wait+0x109>
      release(&ptable.lock);
80104210:	83 ec 0c             	sub    $0xc,%esp
80104213:	68 00 42 19 80       	push   $0x80194200
80104218:	e8 f5 07 00 00       	call   80104a12 <release>
8010421d:	83 c4 10             	add    $0x10,%esp
      return -1;
80104220:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104225:	eb 18                	jmp    8010423f <wait+0x121>
    }

    // Wait for children to exit.  (See wakeup1 call in proc_exit.)
    sleep(curproc, &ptable.lock);  //DOC: wait-sleep
80104227:	83 ec 08             	sub    $0x8,%esp
8010422a:	68 00 42 19 80       	push   $0x80194200
8010422f:	ff 75 ec             	push   -0x14(%ebp)
80104232:	e8 49 03 00 00       	call   80104580 <sleep>
80104237:	83 c4 10             	add    $0x10,%esp
    havekids = 0;
8010423a:	e9 fd fe ff ff       	jmp    8010413c <wait+0x1e>
  }
}
8010423f:	c9                   	leave  
80104240:	c3                   	ret    

80104241 <wait2>:
//******************************************
//************   new  **********************
//************ wait2() *********************
//******************************************
int
wait2(int *status){
80104241:	55                   	push   %ebp
80104242:	89 e5                	mov    %esp,%ebp
80104244:	83 ec 18             	sub    $0x18,%esp

  struct proc *p;
  int havekids, pid;
  struct proc *curproc = myproc();
80104247:	e8 e4 f7 ff ff       	call   80103a30 <myproc>
8010424c:	89 45 ec             	mov    %eax,-0x14(%ebp)
 
  
  acquire(&ptable.lock);
8010424f:	83 ec 0c             	sub    $0xc,%esp
80104252:	68 00 42 19 80       	push   $0x80194200
80104257:	e8 48 07 00 00       	call   801049a4 <acquire>
8010425c:	83 c4 10             	add    $0x10,%esp
  for(;;){
    // Scan through table looking for exited children.
    havekids = 0;
8010425f:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104266:	c7 45 f4 34 42 19 80 	movl   $0x80194234,-0xc(%ebp)
8010426d:	e9 a4 00 00 00       	jmp    80104316 <wait2+0xd5>
      if(p->parent != curproc)
80104272:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104275:	8b 40 14             	mov    0x14(%eax),%eax
80104278:	39 45 ec             	cmp    %eax,-0x14(%ebp)
8010427b:	0f 85 8d 00 00 00    	jne    8010430e <wait2+0xcd>
        continue;
      havekids = 1;
80104281:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
      if(p->state == ZOMBIE){
80104288:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010428b:	8b 40 0c             	mov    0xc(%eax),%eax
8010428e:	83 f8 05             	cmp    $0x5,%eax
80104291:	75 7c                	jne    8010430f <wait2+0xce>
        // Found one.
        pid = p->pid;
80104293:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104296:	8b 40 10             	mov    0x10(%eax),%eax
80104299:	89 45 e8             	mov    %eax,-0x18(%ebp)
        kfree(p->kstack);
8010429c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010429f:	8b 40 08             	mov    0x8(%eax),%eax
801042a2:	83 ec 0c             	sub    $0xc,%esp
801042a5:	50                   	push   %eax
801042a6:	e8 5b e4 ff ff       	call   80102706 <kfree>
801042ab:	83 c4 10             	add    $0x10,%esp
        p->kstack = 0;
801042ae:	8b 45 f4             	mov    -0xc(%ebp),%eax
801042b1:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
        freevm(p->pgdir);
801042b8:	8b 45 f4             	mov    -0xc(%ebp),%eax
801042bb:	8b 40 04             	mov    0x4(%eax),%eax
801042be:	83 ec 0c             	sub    $0xc,%esp
801042c1:	50                   	push   %eax
801042c2:	e8 94 38 00 00       	call   80107b5b <freevm>
801042c7:	83 c4 10             	add    $0x10,%esp
        p->pid = 0;
801042ca:	8b 45 f4             	mov    -0xc(%ebp),%eax
801042cd:	c7 40 10 00 00 00 00 	movl   $0x0,0x10(%eax)
        p->parent = 0;
801042d4:	8b 45 f4             	mov    -0xc(%ebp),%eax
801042d7:	c7 40 14 00 00 00 00 	movl   $0x0,0x14(%eax)
        p->name[0] = 0;
801042de:	8b 45 f4             	mov    -0xc(%ebp),%eax
801042e1:	c6 40 6c 00          	movb   $0x0,0x6c(%eax)
        p->killed = 0;
801042e5:	8b 45 f4             	mov    -0xc(%ebp),%eax
801042e8:	c7 40 24 00 00 00 00 	movl   $0x0,0x24(%eax)
        p->state = UNUSED;
801042ef:	8b 45 f4             	mov    -0xc(%ebp),%eax
801042f2:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
        release(&ptable.lock);
801042f9:	83 ec 0c             	sub    $0xc,%esp
801042fc:	68 00 42 19 80       	push   $0x80194200
80104301:	e8 0c 07 00 00       	call   80104a12 <release>
80104306:	83 c4 10             	add    $0x10,%esp
        return pid;
80104309:	8b 45 e8             	mov    -0x18(%ebp),%eax
8010430c:	eb 7c                	jmp    8010438a <wait2+0x149>
        continue;
8010430e:	90                   	nop
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
8010430f:	81 45 f4 84 00 00 00 	addl   $0x84,-0xc(%ebp)
80104316:	81 7d f4 34 63 19 80 	cmpl   $0x80196334,-0xc(%ebp)
8010431d:	0f 82 4f ff ff ff    	jb     80104272 <wait2+0x31>
      }
    }

    // No point waiting if we don't have any children.
    if(!havekids || curproc->killed){
80104323:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80104327:	74 0a                	je     80104333 <wait2+0xf2>
80104329:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010432c:	8b 40 24             	mov    0x24(%eax),%eax
8010432f:	85 c0                	test   %eax,%eax
80104331:	74 17                	je     8010434a <wait2+0x109>
      release(&ptable.lock);
80104333:	83 ec 0c             	sub    $0xc,%esp
80104336:	68 00 42 19 80       	push   $0x80194200
8010433b:	e8 d2 06 00 00       	call   80104a12 <release>
80104340:	83 c4 10             	add    $0x10,%esp
      return -1;
80104343:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104348:	eb 40                	jmp    8010438a <wait2+0x149>
    }

    sleep(curproc, &ptable.lock);  //DOC: wait-sleep
8010434a:	83 ec 08             	sub    $0x8,%esp
8010434d:	68 00 42 19 80       	push   $0x80194200
80104352:	ff 75 ec             	push   -0x14(%ebp)
80104355:	e8 26 02 00 00       	call   80104580 <sleep>
8010435a:	83 c4 10             	add    $0x10,%esp
  // copyout(pde_t *pgdir, uint va, void *p, uint len)와 같이 정의됨
  // p 주소의 len 길이만큼을 복사해서 pgdir의 va에 넣는다.
  // 만약 올바른 값이 아니라면 -1을 리턴
  // Wait for children to exit.  (See wakeup1 call in proc_exit.)
  // wakeup되면 마저 실행하는 코드
    if (copyout(curproc->pgdir, *status, &(curproc->xstate), sizeof(int)) < 0)
8010435d:	8b 45 ec             	mov    -0x14(%ebp),%eax
80104360:	8d 50 7c             	lea    0x7c(%eax),%edx
80104363:	8b 45 08             	mov    0x8(%ebp),%eax
80104366:	8b 00                	mov    (%eax),%eax
80104368:	89 c1                	mov    %eax,%ecx
8010436a:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010436d:	8b 40 04             	mov    0x4(%eax),%eax
80104370:	6a 04                	push   $0x4
80104372:	52                   	push   %edx
80104373:	51                   	push   %ecx
80104374:	50                   	push   %eax
80104375:	e8 19 3a 00 00       	call   80107d93 <copyout>
8010437a:	83 c4 10             	add    $0x10,%esp
8010437d:	85 c0                	test   %eax,%eax
8010437f:	0f 89 da fe ff ff    	jns    8010425f <wait2+0x1e>
	    return -1;
80104385:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
				     
  }
}
8010438a:	c9                   	leave  
8010438b:	c3                   	ret    

8010438c <scheduler>:
//  - swtch to start running that process
//  - eventually that process transfers control
//      via swtch back to the scheduler.
void
scheduler(void)
{
8010438c:	55                   	push   %ebp
8010438d:	89 e5                	mov    %esp,%ebp
8010438f:	83 ec 18             	sub    $0x18,%esp
  struct proc *p;
  struct cpu *c = mycpu();
80104392:	e8 21 f6 ff ff       	call   801039b8 <mycpu>
80104397:	89 45 f0             	mov    %eax,-0x10(%ebp)
  c->proc = 0;
8010439a:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010439d:	c7 80 ac 00 00 00 00 	movl   $0x0,0xac(%eax)
801043a4:	00 00 00 
  
  for(;;){
    // Enable interrupts on this processor.
    sti();
801043a7:	e8 cc f5 ff ff       	call   80103978 <sti>

    // Loop over process table looking for process to run.
    acquire(&ptable.lock);
801043ac:	83 ec 0c             	sub    $0xc,%esp
801043af:	68 00 42 19 80       	push   $0x80194200
801043b4:	e8 eb 05 00 00       	call   801049a4 <acquire>
801043b9:	83 c4 10             	add    $0x10,%esp
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801043bc:	c7 45 f4 34 42 19 80 	movl   $0x80194234,-0xc(%ebp)
801043c3:	eb 64                	jmp    80104429 <scheduler+0x9d>
      if(p->state != RUNNABLE)
801043c5:	8b 45 f4             	mov    -0xc(%ebp),%eax
801043c8:	8b 40 0c             	mov    0xc(%eax),%eax
801043cb:	83 f8 03             	cmp    $0x3,%eax
801043ce:	75 51                	jne    80104421 <scheduler+0x95>
        continue;

      // Switch to chosen process.  It is the process's job
      // to release ptable.lock and then reacquire it
      // before jumping back to us.
      c->proc = p;
801043d0:	8b 45 f0             	mov    -0x10(%ebp),%eax
801043d3:	8b 55 f4             	mov    -0xc(%ebp),%edx
801043d6:	89 90 ac 00 00 00    	mov    %edx,0xac(%eax)
      switchuvm(p);
801043dc:	83 ec 0c             	sub    $0xc,%esp
801043df:	ff 75 f4             	push   -0xc(%ebp)
801043e2:	e8 cf 32 00 00       	call   801076b6 <switchuvm>
801043e7:	83 c4 10             	add    $0x10,%esp
      p->state = RUNNING;
801043ea:	8b 45 f4             	mov    -0xc(%ebp),%eax
801043ed:	c7 40 0c 04 00 00 00 	movl   $0x4,0xc(%eax)

      swtch(&(c->scheduler), p->context);
801043f4:	8b 45 f4             	mov    -0xc(%ebp),%eax
801043f7:	8b 40 1c             	mov    0x1c(%eax),%eax
801043fa:	8b 55 f0             	mov    -0x10(%ebp),%edx
801043fd:	83 c2 04             	add    $0x4,%edx
80104400:	83 ec 08             	sub    $0x8,%esp
80104403:	50                   	push   %eax
80104404:	52                   	push   %edx
80104405:	e8 85 0a 00 00       	call   80104e8f <swtch>
8010440a:	83 c4 10             	add    $0x10,%esp
      switchkvm();
8010440d:	e8 8b 32 00 00       	call   8010769d <switchkvm>

      // Process is done running for now.
      // It should have changed its p->state before coming back.
      c->proc = 0;
80104412:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104415:	c7 80 ac 00 00 00 00 	movl   $0x0,0xac(%eax)
8010441c:	00 00 00 
8010441f:	eb 01                	jmp    80104422 <scheduler+0x96>
        continue;
80104421:	90                   	nop
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104422:	81 45 f4 84 00 00 00 	addl   $0x84,-0xc(%ebp)
80104429:	81 7d f4 34 63 19 80 	cmpl   $0x80196334,-0xc(%ebp)
80104430:	72 93                	jb     801043c5 <scheduler+0x39>
    }
    release(&ptable.lock);
80104432:	83 ec 0c             	sub    $0xc,%esp
80104435:	68 00 42 19 80       	push   $0x80194200
8010443a:	e8 d3 05 00 00       	call   80104a12 <release>
8010443f:	83 c4 10             	add    $0x10,%esp
    sti();
80104442:	e9 60 ff ff ff       	jmp    801043a7 <scheduler+0x1b>

80104447 <sched>:
// be proc->intena and proc->ncli, but that would
// break in the few places where a lock is held but
// there's no process.
void
sched(void)
{
80104447:	55                   	push   %ebp
80104448:	89 e5                	mov    %esp,%ebp
8010444a:	83 ec 18             	sub    $0x18,%esp
  int intena;
  struct proc *p = myproc();
8010444d:	e8 de f5 ff ff       	call   80103a30 <myproc>
80104452:	89 45 f4             	mov    %eax,-0xc(%ebp)

  if(!holding(&ptable.lock))
80104455:	83 ec 0c             	sub    $0xc,%esp
80104458:	68 00 42 19 80       	push   $0x80194200
8010445d:	e8 7d 06 00 00       	call   80104adf <holding>
80104462:	83 c4 10             	add    $0x10,%esp
80104465:	85 c0                	test   %eax,%eax
80104467:	75 0d                	jne    80104476 <sched+0x2f>
    panic("sched ptable.lock");
80104469:	83 ec 0c             	sub    $0xc,%esp
8010446c:	68 ab a5 10 80       	push   $0x8010a5ab
80104471:	e8 33 c1 ff ff       	call   801005a9 <panic>
  if(mycpu()->ncli != 1)
80104476:	e8 3d f5 ff ff       	call   801039b8 <mycpu>
8010447b:	8b 80 a4 00 00 00    	mov    0xa4(%eax),%eax
80104481:	83 f8 01             	cmp    $0x1,%eax
80104484:	74 0d                	je     80104493 <sched+0x4c>
    panic("sched locks");
80104486:	83 ec 0c             	sub    $0xc,%esp
80104489:	68 bd a5 10 80       	push   $0x8010a5bd
8010448e:	e8 16 c1 ff ff       	call   801005a9 <panic>
  if(p->state == RUNNING)
80104493:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104496:	8b 40 0c             	mov    0xc(%eax),%eax
80104499:	83 f8 04             	cmp    $0x4,%eax
8010449c:	75 0d                	jne    801044ab <sched+0x64>
    panic("sched running");
8010449e:	83 ec 0c             	sub    $0xc,%esp
801044a1:	68 c9 a5 10 80       	push   $0x8010a5c9
801044a6:	e8 fe c0 ff ff       	call   801005a9 <panic>
  if(readeflags()&FL_IF)
801044ab:	e8 b8 f4 ff ff       	call   80103968 <readeflags>
801044b0:	25 00 02 00 00       	and    $0x200,%eax
801044b5:	85 c0                	test   %eax,%eax
801044b7:	74 0d                	je     801044c6 <sched+0x7f>
    panic("sched interruptible");
801044b9:	83 ec 0c             	sub    $0xc,%esp
801044bc:	68 d7 a5 10 80       	push   $0x8010a5d7
801044c1:	e8 e3 c0 ff ff       	call   801005a9 <panic>
  intena = mycpu()->intena;
801044c6:	e8 ed f4 ff ff       	call   801039b8 <mycpu>
801044cb:	8b 80 a8 00 00 00    	mov    0xa8(%eax),%eax
801044d1:	89 45 f0             	mov    %eax,-0x10(%ebp)
  swtch(&p->context, mycpu()->scheduler);
801044d4:	e8 df f4 ff ff       	call   801039b8 <mycpu>
801044d9:	8b 40 04             	mov    0x4(%eax),%eax
801044dc:	8b 55 f4             	mov    -0xc(%ebp),%edx
801044df:	83 c2 1c             	add    $0x1c,%edx
801044e2:	83 ec 08             	sub    $0x8,%esp
801044e5:	50                   	push   %eax
801044e6:	52                   	push   %edx
801044e7:	e8 a3 09 00 00       	call   80104e8f <swtch>
801044ec:	83 c4 10             	add    $0x10,%esp
  mycpu()->intena = intena;
801044ef:	e8 c4 f4 ff ff       	call   801039b8 <mycpu>
801044f4:	8b 55 f0             	mov    -0x10(%ebp),%edx
801044f7:	89 90 a8 00 00 00    	mov    %edx,0xa8(%eax)
}
801044fd:	90                   	nop
801044fe:	c9                   	leave  
801044ff:	c3                   	ret    

80104500 <yield>:

// Give up the CPU for one scheduling round.
void
yield(void)
{
80104500:	55                   	push   %ebp
80104501:	89 e5                	mov    %esp,%ebp
80104503:	83 ec 08             	sub    $0x8,%esp
  acquire(&ptable.lock);  //DOC: yieldlock
80104506:	83 ec 0c             	sub    $0xc,%esp
80104509:	68 00 42 19 80       	push   $0x80194200
8010450e:	e8 91 04 00 00       	call   801049a4 <acquire>
80104513:	83 c4 10             	add    $0x10,%esp
  myproc()->state = RUNNABLE;
80104516:	e8 15 f5 ff ff       	call   80103a30 <myproc>
8010451b:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
  sched();
80104522:	e8 20 ff ff ff       	call   80104447 <sched>
  release(&ptable.lock);
80104527:	83 ec 0c             	sub    $0xc,%esp
8010452a:	68 00 42 19 80       	push   $0x80194200
8010452f:	e8 de 04 00 00       	call   80104a12 <release>
80104534:	83 c4 10             	add    $0x10,%esp
}
80104537:	90                   	nop
80104538:	c9                   	leave  
80104539:	c3                   	ret    

8010453a <forkret>:

// A fork child's very first scheduling by scheduler()
// will swtch here.  "Return" to user space.
void
forkret(void)
{
8010453a:	55                   	push   %ebp
8010453b:	89 e5                	mov    %esp,%ebp
8010453d:	83 ec 08             	sub    $0x8,%esp
  static int first = 1;
  // Still holding ptable.lock from scheduler.
  release(&ptable.lock);
80104540:	83 ec 0c             	sub    $0xc,%esp
80104543:	68 00 42 19 80       	push   $0x80194200
80104548:	e8 c5 04 00 00       	call   80104a12 <release>
8010454d:	83 c4 10             	add    $0x10,%esp

  if (first) {
80104550:	a1 04 f0 10 80       	mov    0x8010f004,%eax
80104555:	85 c0                	test   %eax,%eax
80104557:	74 24                	je     8010457d <forkret+0x43>
    // Some initialization functions must be run in the context
    // of a regular process (e.g., they call sleep), and thus cannot
    // be run from main().
    first = 0;
80104559:	c7 05 04 f0 10 80 00 	movl   $0x0,0x8010f004
80104560:	00 00 00 
    iinit(ROOTDEV);
80104563:	83 ec 0c             	sub    $0xc,%esp
80104566:	6a 01                	push   $0x1
80104568:	e8 0b d1 ff ff       	call   80101678 <iinit>
8010456d:	83 c4 10             	add    $0x10,%esp
    initlog(ROOTDEV);
80104570:	83 ec 0c             	sub    $0xc,%esp
80104573:	6a 01                	push   $0x1
80104575:	e8 a3 e8 ff ff       	call   80102e1d <initlog>
8010457a:	83 c4 10             	add    $0x10,%esp
  }

  // Return to "caller", actually trapret (see allocproc).
}
8010457d:	90                   	nop
8010457e:	c9                   	leave  
8010457f:	c3                   	ret    

80104580 <sleep>:

// Atomically release lock and sleep on chan.
// Reacquires lock when awakened.
void
sleep(void *chan, struct spinlock *lk)
{
80104580:	55                   	push   %ebp
80104581:	89 e5                	mov    %esp,%ebp
80104583:	83 ec 18             	sub    $0x18,%esp
  struct proc *p = myproc();
80104586:	e8 a5 f4 ff ff       	call   80103a30 <myproc>
8010458b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  
  if(p == 0)
8010458e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80104592:	75 0d                	jne    801045a1 <sleep+0x21>
    panic("sleep");
80104594:	83 ec 0c             	sub    $0xc,%esp
80104597:	68 eb a5 10 80       	push   $0x8010a5eb
8010459c:	e8 08 c0 ff ff       	call   801005a9 <panic>

  if(lk == 0)
801045a1:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
801045a5:	75 0d                	jne    801045b4 <sleep+0x34>
    panic("sleep without lk");
801045a7:	83 ec 0c             	sub    $0xc,%esp
801045aa:	68 f1 a5 10 80       	push   $0x8010a5f1
801045af:	e8 f5 bf ff ff       	call   801005a9 <panic>
  // change p->state and then call sched.
  // Once we hold ptable.lock, we can be
  // guaranteed that we won't miss any wakeup
  // (wakeup runs with ptable.lock locked),
  // so it's okay to release lk.
  if(lk != &ptable.lock){  //DOC: sleeplock0
801045b4:	81 7d 0c 00 42 19 80 	cmpl   $0x80194200,0xc(%ebp)
801045bb:	74 1e                	je     801045db <sleep+0x5b>
    acquire(&ptable.lock);  //DOC: sleeplock1
801045bd:	83 ec 0c             	sub    $0xc,%esp
801045c0:	68 00 42 19 80       	push   $0x80194200
801045c5:	e8 da 03 00 00       	call   801049a4 <acquire>
801045ca:	83 c4 10             	add    $0x10,%esp
    release(lk);
801045cd:	83 ec 0c             	sub    $0xc,%esp
801045d0:	ff 75 0c             	push   0xc(%ebp)
801045d3:	e8 3a 04 00 00       	call   80104a12 <release>
801045d8:	83 c4 10             	add    $0x10,%esp
  }
  // Go to sleep.
  p->chan = chan;
801045db:	8b 45 f4             	mov    -0xc(%ebp),%eax
801045de:	8b 55 08             	mov    0x8(%ebp),%edx
801045e1:	89 50 20             	mov    %edx,0x20(%eax)
  p->state = SLEEPING;
801045e4:	8b 45 f4             	mov    -0xc(%ebp),%eax
801045e7:	c7 40 0c 02 00 00 00 	movl   $0x2,0xc(%eax)

  sched();
801045ee:	e8 54 fe ff ff       	call   80104447 <sched>

  // Tidy up.
  p->chan = 0;
801045f3:	8b 45 f4             	mov    -0xc(%ebp),%eax
801045f6:	c7 40 20 00 00 00 00 	movl   $0x0,0x20(%eax)

  // Reacquire original lock.
  if(lk != &ptable.lock){  //DOC: sleeplock2
801045fd:	81 7d 0c 00 42 19 80 	cmpl   $0x80194200,0xc(%ebp)
80104604:	74 1e                	je     80104624 <sleep+0xa4>
    release(&ptable.lock);
80104606:	83 ec 0c             	sub    $0xc,%esp
80104609:	68 00 42 19 80       	push   $0x80194200
8010460e:	e8 ff 03 00 00       	call   80104a12 <release>
80104613:	83 c4 10             	add    $0x10,%esp
    acquire(lk);
80104616:	83 ec 0c             	sub    $0xc,%esp
80104619:	ff 75 0c             	push   0xc(%ebp)
8010461c:	e8 83 03 00 00       	call   801049a4 <acquire>
80104621:	83 c4 10             	add    $0x10,%esp
  }
}
80104624:	90                   	nop
80104625:	c9                   	leave  
80104626:	c3                   	ret    

80104627 <wakeup1>:
//PAGEBREAK!
// Wake up all processes sleeping on chan.
// The ptable lock must be held.
static void
wakeup1(void *chan)
{
80104627:	55                   	push   %ebp
80104628:	89 e5                	mov    %esp,%ebp
8010462a:	83 ec 10             	sub    $0x10,%esp
  struct proc *p;

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
8010462d:	c7 45 fc 34 42 19 80 	movl   $0x80194234,-0x4(%ebp)
80104634:	eb 27                	jmp    8010465d <wakeup1+0x36>
    if(p->state == SLEEPING && p->chan == chan)
80104636:	8b 45 fc             	mov    -0x4(%ebp),%eax
80104639:	8b 40 0c             	mov    0xc(%eax),%eax
8010463c:	83 f8 02             	cmp    $0x2,%eax
8010463f:	75 15                	jne    80104656 <wakeup1+0x2f>
80104641:	8b 45 fc             	mov    -0x4(%ebp),%eax
80104644:	8b 40 20             	mov    0x20(%eax),%eax
80104647:	39 45 08             	cmp    %eax,0x8(%ebp)
8010464a:	75 0a                	jne    80104656 <wakeup1+0x2f>
      p->state = RUNNABLE;
8010464c:	8b 45 fc             	mov    -0x4(%ebp),%eax
8010464f:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104656:	81 45 fc 84 00 00 00 	addl   $0x84,-0x4(%ebp)
8010465d:	81 7d fc 34 63 19 80 	cmpl   $0x80196334,-0x4(%ebp)
80104664:	72 d0                	jb     80104636 <wakeup1+0xf>
}
80104666:	90                   	nop
80104667:	90                   	nop
80104668:	c9                   	leave  
80104669:	c3                   	ret    

8010466a <wakeup>:

// Wake up all processes sleeping on chan.
void
wakeup(void *chan)
{
8010466a:	55                   	push   %ebp
8010466b:	89 e5                	mov    %esp,%ebp
8010466d:	83 ec 08             	sub    $0x8,%esp
  acquire(&ptable.lock);
80104670:	83 ec 0c             	sub    $0xc,%esp
80104673:	68 00 42 19 80       	push   $0x80194200
80104678:	e8 27 03 00 00       	call   801049a4 <acquire>
8010467d:	83 c4 10             	add    $0x10,%esp
  wakeup1(chan);
80104680:	83 ec 0c             	sub    $0xc,%esp
80104683:	ff 75 08             	push   0x8(%ebp)
80104686:	e8 9c ff ff ff       	call   80104627 <wakeup1>
8010468b:	83 c4 10             	add    $0x10,%esp
  release(&ptable.lock);
8010468e:	83 ec 0c             	sub    $0xc,%esp
80104691:	68 00 42 19 80       	push   $0x80194200
80104696:	e8 77 03 00 00       	call   80104a12 <release>
8010469b:	83 c4 10             	add    $0x10,%esp
}
8010469e:	90                   	nop
8010469f:	c9                   	leave  
801046a0:	c3                   	ret    

801046a1 <kill>:
// Kill the process with the given pid.
// Process won't exit until it returns
// to user space (see trap in trap.c).
int
kill(int pid)
{
801046a1:	55                   	push   %ebp
801046a2:	89 e5                	mov    %esp,%ebp
801046a4:	83 ec 18             	sub    $0x18,%esp
  struct proc *p;

  acquire(&ptable.lock);
801046a7:	83 ec 0c             	sub    $0xc,%esp
801046aa:	68 00 42 19 80       	push   $0x80194200
801046af:	e8 f0 02 00 00       	call   801049a4 <acquire>
801046b4:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801046b7:	c7 45 f4 34 42 19 80 	movl   $0x80194234,-0xc(%ebp)
801046be:	eb 48                	jmp    80104708 <kill+0x67>
    if(p->pid == pid){
801046c0:	8b 45 f4             	mov    -0xc(%ebp),%eax
801046c3:	8b 40 10             	mov    0x10(%eax),%eax
801046c6:	39 45 08             	cmp    %eax,0x8(%ebp)
801046c9:	75 36                	jne    80104701 <kill+0x60>
      p->killed = 1;
801046cb:	8b 45 f4             	mov    -0xc(%ebp),%eax
801046ce:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
      // Wake process from sleep if necessary.
      if(p->state == SLEEPING)
801046d5:	8b 45 f4             	mov    -0xc(%ebp),%eax
801046d8:	8b 40 0c             	mov    0xc(%eax),%eax
801046db:	83 f8 02             	cmp    $0x2,%eax
801046de:	75 0a                	jne    801046ea <kill+0x49>
        p->state = RUNNABLE;
801046e0:	8b 45 f4             	mov    -0xc(%ebp),%eax
801046e3:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
      release(&ptable.lock);
801046ea:	83 ec 0c             	sub    $0xc,%esp
801046ed:	68 00 42 19 80       	push   $0x80194200
801046f2:	e8 1b 03 00 00       	call   80104a12 <release>
801046f7:	83 c4 10             	add    $0x10,%esp
      return 0;
801046fa:	b8 00 00 00 00       	mov    $0x0,%eax
801046ff:	eb 25                	jmp    80104726 <kill+0x85>
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104701:	81 45 f4 84 00 00 00 	addl   $0x84,-0xc(%ebp)
80104708:	81 7d f4 34 63 19 80 	cmpl   $0x80196334,-0xc(%ebp)
8010470f:	72 af                	jb     801046c0 <kill+0x1f>
    }
  }
  release(&ptable.lock);
80104711:	83 ec 0c             	sub    $0xc,%esp
80104714:	68 00 42 19 80       	push   $0x80194200
80104719:	e8 f4 02 00 00       	call   80104a12 <release>
8010471e:	83 c4 10             	add    $0x10,%esp
  return -1;
80104721:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104726:	c9                   	leave  
80104727:	c3                   	ret    

80104728 <procdump>:
// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void
procdump(void)
{
80104728:	55                   	push   %ebp
80104729:	89 e5                	mov    %esp,%ebp
8010472b:	83 ec 48             	sub    $0x48,%esp
  int i;
  struct proc *p;
  char *state;
  uint pc[10];

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
8010472e:	c7 45 f0 34 42 19 80 	movl   $0x80194234,-0x10(%ebp)
80104735:	e9 da 00 00 00       	jmp    80104814 <procdump+0xec>
    if(p->state == UNUSED)
8010473a:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010473d:	8b 40 0c             	mov    0xc(%eax),%eax
80104740:	85 c0                	test   %eax,%eax
80104742:	0f 84 c4 00 00 00    	je     8010480c <procdump+0xe4>
      continue;
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
80104748:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010474b:	8b 40 0c             	mov    0xc(%eax),%eax
8010474e:	83 f8 05             	cmp    $0x5,%eax
80104751:	77 23                	ja     80104776 <procdump+0x4e>
80104753:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104756:	8b 40 0c             	mov    0xc(%eax),%eax
80104759:	8b 04 85 08 f0 10 80 	mov    -0x7fef0ff8(,%eax,4),%eax
80104760:	85 c0                	test   %eax,%eax
80104762:	74 12                	je     80104776 <procdump+0x4e>
      state = states[p->state];
80104764:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104767:	8b 40 0c             	mov    0xc(%eax),%eax
8010476a:	8b 04 85 08 f0 10 80 	mov    -0x7fef0ff8(,%eax,4),%eax
80104771:	89 45 ec             	mov    %eax,-0x14(%ebp)
80104774:	eb 07                	jmp    8010477d <procdump+0x55>
    else
      state = "???";
80104776:	c7 45 ec 02 a6 10 80 	movl   $0x8010a602,-0x14(%ebp)
    cprintf("%d %s %s", p->pid, state, p->name);
8010477d:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104780:	8d 50 6c             	lea    0x6c(%eax),%edx
80104783:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104786:	8b 40 10             	mov    0x10(%eax),%eax
80104789:	52                   	push   %edx
8010478a:	ff 75 ec             	push   -0x14(%ebp)
8010478d:	50                   	push   %eax
8010478e:	68 06 a6 10 80       	push   $0x8010a606
80104793:	e8 5c bc ff ff       	call   801003f4 <cprintf>
80104798:	83 c4 10             	add    $0x10,%esp
    if(p->state == SLEEPING){
8010479b:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010479e:	8b 40 0c             	mov    0xc(%eax),%eax
801047a1:	83 f8 02             	cmp    $0x2,%eax
801047a4:	75 54                	jne    801047fa <procdump+0xd2>
      getcallerpcs((uint*)p->context->ebp+2, pc);
801047a6:	8b 45 f0             	mov    -0x10(%ebp),%eax
801047a9:	8b 40 1c             	mov    0x1c(%eax),%eax
801047ac:	8b 40 0c             	mov    0xc(%eax),%eax
801047af:	83 c0 08             	add    $0x8,%eax
801047b2:	89 c2                	mov    %eax,%edx
801047b4:	83 ec 08             	sub    $0x8,%esp
801047b7:	8d 45 c4             	lea    -0x3c(%ebp),%eax
801047ba:	50                   	push   %eax
801047bb:	52                   	push   %edx
801047bc:	e8 a3 02 00 00       	call   80104a64 <getcallerpcs>
801047c1:	83 c4 10             	add    $0x10,%esp
      for(i=0; i<10 && pc[i] != 0; i++)
801047c4:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
801047cb:	eb 1c                	jmp    801047e9 <procdump+0xc1>
        cprintf(" %p", pc[i]);
801047cd:	8b 45 f4             	mov    -0xc(%ebp),%eax
801047d0:	8b 44 85 c4          	mov    -0x3c(%ebp,%eax,4),%eax
801047d4:	83 ec 08             	sub    $0x8,%esp
801047d7:	50                   	push   %eax
801047d8:	68 0f a6 10 80       	push   $0x8010a60f
801047dd:	e8 12 bc ff ff       	call   801003f4 <cprintf>
801047e2:	83 c4 10             	add    $0x10,%esp
      for(i=0; i<10 && pc[i] != 0; i++)
801047e5:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
801047e9:	83 7d f4 09          	cmpl   $0x9,-0xc(%ebp)
801047ed:	7f 0b                	jg     801047fa <procdump+0xd2>
801047ef:	8b 45 f4             	mov    -0xc(%ebp),%eax
801047f2:	8b 44 85 c4          	mov    -0x3c(%ebp,%eax,4),%eax
801047f6:	85 c0                	test   %eax,%eax
801047f8:	75 d3                	jne    801047cd <procdump+0xa5>
    }
    cprintf("\n");
801047fa:	83 ec 0c             	sub    $0xc,%esp
801047fd:	68 13 a6 10 80       	push   $0x8010a613
80104802:	e8 ed bb ff ff       	call   801003f4 <cprintf>
80104807:	83 c4 10             	add    $0x10,%esp
8010480a:	eb 01                	jmp    8010480d <procdump+0xe5>
      continue;
8010480c:	90                   	nop
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
8010480d:	81 45 f0 84 00 00 00 	addl   $0x84,-0x10(%ebp)
80104814:	81 7d f0 34 63 19 80 	cmpl   $0x80196334,-0x10(%ebp)
8010481b:	0f 82 19 ff ff ff    	jb     8010473a <procdump+0x12>
  }
}
80104821:	90                   	nop
80104822:	90                   	nop
80104823:	c9                   	leave  
80104824:	c3                   	ret    

80104825 <initsleeplock>:
#include "spinlock.h"
#include "sleeplock.h"

void
initsleeplock(struct sleeplock *lk, char *name)
{
80104825:	55                   	push   %ebp
80104826:	89 e5                	mov    %esp,%ebp
80104828:	83 ec 08             	sub    $0x8,%esp
  initlock(&lk->lk, "sleep lock");
8010482b:	8b 45 08             	mov    0x8(%ebp),%eax
8010482e:	83 c0 04             	add    $0x4,%eax
80104831:	83 ec 08             	sub    $0x8,%esp
80104834:	68 3f a6 10 80       	push   $0x8010a63f
80104839:	50                   	push   %eax
8010483a:	e8 43 01 00 00       	call   80104982 <initlock>
8010483f:	83 c4 10             	add    $0x10,%esp
  lk->name = name;
80104842:	8b 45 08             	mov    0x8(%ebp),%eax
80104845:	8b 55 0c             	mov    0xc(%ebp),%edx
80104848:	89 50 38             	mov    %edx,0x38(%eax)
  lk->locked = 0;
8010484b:	8b 45 08             	mov    0x8(%ebp),%eax
8010484e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  lk->pid = 0;
80104854:	8b 45 08             	mov    0x8(%ebp),%eax
80104857:	c7 40 3c 00 00 00 00 	movl   $0x0,0x3c(%eax)
}
8010485e:	90                   	nop
8010485f:	c9                   	leave  
80104860:	c3                   	ret    

80104861 <acquiresleep>:

void
acquiresleep(struct sleeplock *lk)
{
80104861:	55                   	push   %ebp
80104862:	89 e5                	mov    %esp,%ebp
80104864:	83 ec 08             	sub    $0x8,%esp
  acquire(&lk->lk);
80104867:	8b 45 08             	mov    0x8(%ebp),%eax
8010486a:	83 c0 04             	add    $0x4,%eax
8010486d:	83 ec 0c             	sub    $0xc,%esp
80104870:	50                   	push   %eax
80104871:	e8 2e 01 00 00       	call   801049a4 <acquire>
80104876:	83 c4 10             	add    $0x10,%esp
  while (lk->locked) {
80104879:	eb 15                	jmp    80104890 <acquiresleep+0x2f>
    sleep(lk, &lk->lk);
8010487b:	8b 45 08             	mov    0x8(%ebp),%eax
8010487e:	83 c0 04             	add    $0x4,%eax
80104881:	83 ec 08             	sub    $0x8,%esp
80104884:	50                   	push   %eax
80104885:	ff 75 08             	push   0x8(%ebp)
80104888:	e8 f3 fc ff ff       	call   80104580 <sleep>
8010488d:	83 c4 10             	add    $0x10,%esp
  while (lk->locked) {
80104890:	8b 45 08             	mov    0x8(%ebp),%eax
80104893:	8b 00                	mov    (%eax),%eax
80104895:	85 c0                	test   %eax,%eax
80104897:	75 e2                	jne    8010487b <acquiresleep+0x1a>
  }
  lk->locked = 1;
80104899:	8b 45 08             	mov    0x8(%ebp),%eax
8010489c:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  lk->pid = myproc()->pid;
801048a2:	e8 89 f1 ff ff       	call   80103a30 <myproc>
801048a7:	8b 50 10             	mov    0x10(%eax),%edx
801048aa:	8b 45 08             	mov    0x8(%ebp),%eax
801048ad:	89 50 3c             	mov    %edx,0x3c(%eax)
  release(&lk->lk);
801048b0:	8b 45 08             	mov    0x8(%ebp),%eax
801048b3:	83 c0 04             	add    $0x4,%eax
801048b6:	83 ec 0c             	sub    $0xc,%esp
801048b9:	50                   	push   %eax
801048ba:	e8 53 01 00 00       	call   80104a12 <release>
801048bf:	83 c4 10             	add    $0x10,%esp
}
801048c2:	90                   	nop
801048c3:	c9                   	leave  
801048c4:	c3                   	ret    

801048c5 <releasesleep>:

void
releasesleep(struct sleeplock *lk)
{
801048c5:	55                   	push   %ebp
801048c6:	89 e5                	mov    %esp,%ebp
801048c8:	83 ec 08             	sub    $0x8,%esp
  acquire(&lk->lk);
801048cb:	8b 45 08             	mov    0x8(%ebp),%eax
801048ce:	83 c0 04             	add    $0x4,%eax
801048d1:	83 ec 0c             	sub    $0xc,%esp
801048d4:	50                   	push   %eax
801048d5:	e8 ca 00 00 00       	call   801049a4 <acquire>
801048da:	83 c4 10             	add    $0x10,%esp
  lk->locked = 0;
801048dd:	8b 45 08             	mov    0x8(%ebp),%eax
801048e0:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  lk->pid = 0;
801048e6:	8b 45 08             	mov    0x8(%ebp),%eax
801048e9:	c7 40 3c 00 00 00 00 	movl   $0x0,0x3c(%eax)
  wakeup(lk);
801048f0:	83 ec 0c             	sub    $0xc,%esp
801048f3:	ff 75 08             	push   0x8(%ebp)
801048f6:	e8 6f fd ff ff       	call   8010466a <wakeup>
801048fb:	83 c4 10             	add    $0x10,%esp
  release(&lk->lk);
801048fe:	8b 45 08             	mov    0x8(%ebp),%eax
80104901:	83 c0 04             	add    $0x4,%eax
80104904:	83 ec 0c             	sub    $0xc,%esp
80104907:	50                   	push   %eax
80104908:	e8 05 01 00 00       	call   80104a12 <release>
8010490d:	83 c4 10             	add    $0x10,%esp
}
80104910:	90                   	nop
80104911:	c9                   	leave  
80104912:	c3                   	ret    

80104913 <holdingsleep>:

int
holdingsleep(struct sleeplock *lk)
{
80104913:	55                   	push   %ebp
80104914:	89 e5                	mov    %esp,%ebp
80104916:	83 ec 18             	sub    $0x18,%esp
  int r;
  
  acquire(&lk->lk);
80104919:	8b 45 08             	mov    0x8(%ebp),%eax
8010491c:	83 c0 04             	add    $0x4,%eax
8010491f:	83 ec 0c             	sub    $0xc,%esp
80104922:	50                   	push   %eax
80104923:	e8 7c 00 00 00       	call   801049a4 <acquire>
80104928:	83 c4 10             	add    $0x10,%esp
  r = lk->locked;
8010492b:	8b 45 08             	mov    0x8(%ebp),%eax
8010492e:	8b 00                	mov    (%eax),%eax
80104930:	89 45 f4             	mov    %eax,-0xc(%ebp)
  release(&lk->lk);
80104933:	8b 45 08             	mov    0x8(%ebp),%eax
80104936:	83 c0 04             	add    $0x4,%eax
80104939:	83 ec 0c             	sub    $0xc,%esp
8010493c:	50                   	push   %eax
8010493d:	e8 d0 00 00 00       	call   80104a12 <release>
80104942:	83 c4 10             	add    $0x10,%esp
  return r;
80104945:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
80104948:	c9                   	leave  
80104949:	c3                   	ret    

8010494a <readeflags>:
{
8010494a:	55                   	push   %ebp
8010494b:	89 e5                	mov    %esp,%ebp
8010494d:	83 ec 10             	sub    $0x10,%esp
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80104950:	9c                   	pushf  
80104951:	58                   	pop    %eax
80104952:	89 45 fc             	mov    %eax,-0x4(%ebp)
  return eflags;
80104955:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
80104958:	c9                   	leave  
80104959:	c3                   	ret    

8010495a <cli>:
{
8010495a:	55                   	push   %ebp
8010495b:	89 e5                	mov    %esp,%ebp
  asm volatile("cli");
8010495d:	fa                   	cli    
}
8010495e:	90                   	nop
8010495f:	5d                   	pop    %ebp
80104960:	c3                   	ret    

80104961 <sti>:
{
80104961:	55                   	push   %ebp
80104962:	89 e5                	mov    %esp,%ebp
  asm volatile("sti");
80104964:	fb                   	sti    
}
80104965:	90                   	nop
80104966:	5d                   	pop    %ebp
80104967:	c3                   	ret    

80104968 <xchg>:
{
80104968:	55                   	push   %ebp
80104969:	89 e5                	mov    %esp,%ebp
8010496b:	83 ec 10             	sub    $0x10,%esp
  asm volatile("lock; xchgl %0, %1" :
8010496e:	8b 55 08             	mov    0x8(%ebp),%edx
80104971:	8b 45 0c             	mov    0xc(%ebp),%eax
80104974:	8b 4d 08             	mov    0x8(%ebp),%ecx
80104977:	f0 87 02             	lock xchg %eax,(%edx)
8010497a:	89 45 fc             	mov    %eax,-0x4(%ebp)
  return result;
8010497d:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
80104980:	c9                   	leave  
80104981:	c3                   	ret    

80104982 <initlock>:
#include "proc.h"
#include "spinlock.h"

void
initlock(struct spinlock *lk, char *name)
{
80104982:	55                   	push   %ebp
80104983:	89 e5                	mov    %esp,%ebp
  lk->name = name;
80104985:	8b 45 08             	mov    0x8(%ebp),%eax
80104988:	8b 55 0c             	mov    0xc(%ebp),%edx
8010498b:	89 50 04             	mov    %edx,0x4(%eax)
  lk->locked = 0;
8010498e:	8b 45 08             	mov    0x8(%ebp),%eax
80104991:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  lk->cpu = 0;
80104997:	8b 45 08             	mov    0x8(%ebp),%eax
8010499a:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
}
801049a1:	90                   	nop
801049a2:	5d                   	pop    %ebp
801049a3:	c3                   	ret    

801049a4 <acquire>:
// Loops (spins) until the lock is acquired.
// Holding a lock for a long time may cause
// other CPUs to waste time spinning to acquire it.
void
acquire(struct spinlock *lk)
{
801049a4:	55                   	push   %ebp
801049a5:	89 e5                	mov    %esp,%ebp
801049a7:	53                   	push   %ebx
801049a8:	83 ec 04             	sub    $0x4,%esp
  pushcli(); // disable interrupts to avoid deadlock.
801049ab:	e8 5f 01 00 00       	call   80104b0f <pushcli>
  if(holding(lk)){
801049b0:	8b 45 08             	mov    0x8(%ebp),%eax
801049b3:	83 ec 0c             	sub    $0xc,%esp
801049b6:	50                   	push   %eax
801049b7:	e8 23 01 00 00       	call   80104adf <holding>
801049bc:	83 c4 10             	add    $0x10,%esp
801049bf:	85 c0                	test   %eax,%eax
801049c1:	74 0d                	je     801049d0 <acquire+0x2c>
    panic("acquire");
801049c3:	83 ec 0c             	sub    $0xc,%esp
801049c6:	68 4a a6 10 80       	push   $0x8010a64a
801049cb:	e8 d9 bb ff ff       	call   801005a9 <panic>
  }

  // The xchg is atomic.
  while(xchg(&lk->locked, 1) != 0)
801049d0:	90                   	nop
801049d1:	8b 45 08             	mov    0x8(%ebp),%eax
801049d4:	83 ec 08             	sub    $0x8,%esp
801049d7:	6a 01                	push   $0x1
801049d9:	50                   	push   %eax
801049da:	e8 89 ff ff ff       	call   80104968 <xchg>
801049df:	83 c4 10             	add    $0x10,%esp
801049e2:	85 c0                	test   %eax,%eax
801049e4:	75 eb                	jne    801049d1 <acquire+0x2d>
    ;

  // Tell the C compiler and the processor to not move loads or stores
  // past this point, to ensure that the critical section's memory
  // references happen after the lock is acquired.
  __sync_synchronize();
801049e6:	f0 83 0c 24 00       	lock orl $0x0,(%esp)

  // Record info about lock acquisition for debugging.
  lk->cpu = mycpu();
801049eb:	8b 5d 08             	mov    0x8(%ebp),%ebx
801049ee:	e8 c5 ef ff ff       	call   801039b8 <mycpu>
801049f3:	89 43 08             	mov    %eax,0x8(%ebx)
  getcallerpcs(&lk, lk->pcs);
801049f6:	8b 45 08             	mov    0x8(%ebp),%eax
801049f9:	83 c0 0c             	add    $0xc,%eax
801049fc:	83 ec 08             	sub    $0x8,%esp
801049ff:	50                   	push   %eax
80104a00:	8d 45 08             	lea    0x8(%ebp),%eax
80104a03:	50                   	push   %eax
80104a04:	e8 5b 00 00 00       	call   80104a64 <getcallerpcs>
80104a09:	83 c4 10             	add    $0x10,%esp
}
80104a0c:	90                   	nop
80104a0d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104a10:	c9                   	leave  
80104a11:	c3                   	ret    

80104a12 <release>:

// Release the lock.
void
release(struct spinlock *lk)
{
80104a12:	55                   	push   %ebp
80104a13:	89 e5                	mov    %esp,%ebp
80104a15:	83 ec 08             	sub    $0x8,%esp
  if(!holding(lk))
80104a18:	83 ec 0c             	sub    $0xc,%esp
80104a1b:	ff 75 08             	push   0x8(%ebp)
80104a1e:	e8 bc 00 00 00       	call   80104adf <holding>
80104a23:	83 c4 10             	add    $0x10,%esp
80104a26:	85 c0                	test   %eax,%eax
80104a28:	75 0d                	jne    80104a37 <release+0x25>
    panic("release");
80104a2a:	83 ec 0c             	sub    $0xc,%esp
80104a2d:	68 52 a6 10 80       	push   $0x8010a652
80104a32:	e8 72 bb ff ff       	call   801005a9 <panic>

  lk->pcs[0] = 0;
80104a37:	8b 45 08             	mov    0x8(%ebp),%eax
80104a3a:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
  lk->cpu = 0;
80104a41:	8b 45 08             	mov    0x8(%ebp),%eax
80104a44:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  // Tell the C compiler and the processor to not move loads or stores
  // past this point, to ensure that all the stores in the critical
  // section are visible to other cores before the lock is released.
  // Both the C compiler and the hardware may re-order loads and
  // stores; __sync_synchronize() tells them both not to.
  __sync_synchronize();
80104a4b:	f0 83 0c 24 00       	lock orl $0x0,(%esp)

  // Release the lock, equivalent to lk->locked = 0.
  // This code can't use a C assignment, since it might
  // not be atomic. A real OS would use C atomics here.
  asm volatile("movl $0, %0" : "+m" (lk->locked) : );
80104a50:	8b 45 08             	mov    0x8(%ebp),%eax
80104a53:	8b 55 08             	mov    0x8(%ebp),%edx
80104a56:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

  popcli();
80104a5c:	e8 fb 00 00 00       	call   80104b5c <popcli>
}
80104a61:	90                   	nop
80104a62:	c9                   	leave  
80104a63:	c3                   	ret    

80104a64 <getcallerpcs>:

// Record the current call stack in pcs[] by following the %ebp chain.
void
getcallerpcs(void *v, uint pcs[])
{
80104a64:	55                   	push   %ebp
80104a65:	89 e5                	mov    %esp,%ebp
80104a67:	83 ec 10             	sub    $0x10,%esp
  uint *ebp;
  int i;

  ebp = (uint*)v - 2;
80104a6a:	8b 45 08             	mov    0x8(%ebp),%eax
80104a6d:	83 e8 08             	sub    $0x8,%eax
80104a70:	89 45 fc             	mov    %eax,-0x4(%ebp)
  for(i = 0; i < 10; i++){
80104a73:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
80104a7a:	eb 38                	jmp    80104ab4 <getcallerpcs+0x50>
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
80104a7c:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
80104a80:	74 53                	je     80104ad5 <getcallerpcs+0x71>
80104a82:	81 7d fc ff ff ff 7f 	cmpl   $0x7fffffff,-0x4(%ebp)
80104a89:	76 4a                	jbe    80104ad5 <getcallerpcs+0x71>
80104a8b:	83 7d fc ff          	cmpl   $0xffffffff,-0x4(%ebp)
80104a8f:	74 44                	je     80104ad5 <getcallerpcs+0x71>
      break;
    pcs[i] = ebp[1];     // saved %eip
80104a91:	8b 45 f8             	mov    -0x8(%ebp),%eax
80104a94:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80104a9b:	8b 45 0c             	mov    0xc(%ebp),%eax
80104a9e:	01 c2                	add    %eax,%edx
80104aa0:	8b 45 fc             	mov    -0x4(%ebp),%eax
80104aa3:	8b 40 04             	mov    0x4(%eax),%eax
80104aa6:	89 02                	mov    %eax,(%edx)
    ebp = (uint*)ebp[0]; // saved %ebp
80104aa8:	8b 45 fc             	mov    -0x4(%ebp),%eax
80104aab:	8b 00                	mov    (%eax),%eax
80104aad:	89 45 fc             	mov    %eax,-0x4(%ebp)
  for(i = 0; i < 10; i++){
80104ab0:	83 45 f8 01          	addl   $0x1,-0x8(%ebp)
80104ab4:	83 7d f8 09          	cmpl   $0x9,-0x8(%ebp)
80104ab8:	7e c2                	jle    80104a7c <getcallerpcs+0x18>
  }
  for(; i < 10; i++)
80104aba:	eb 19                	jmp    80104ad5 <getcallerpcs+0x71>
    pcs[i] = 0;
80104abc:	8b 45 f8             	mov    -0x8(%ebp),%eax
80104abf:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80104ac6:	8b 45 0c             	mov    0xc(%ebp),%eax
80104ac9:	01 d0                	add    %edx,%eax
80104acb:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  for(; i < 10; i++)
80104ad1:	83 45 f8 01          	addl   $0x1,-0x8(%ebp)
80104ad5:	83 7d f8 09          	cmpl   $0x9,-0x8(%ebp)
80104ad9:	7e e1                	jle    80104abc <getcallerpcs+0x58>
}
80104adb:	90                   	nop
80104adc:	90                   	nop
80104add:	c9                   	leave  
80104ade:	c3                   	ret    

80104adf <holding>:

// Check whether this cpu is holding the lock.
int
holding(struct spinlock *lock)
{
80104adf:	55                   	push   %ebp
80104ae0:	89 e5                	mov    %esp,%ebp
80104ae2:	53                   	push   %ebx
80104ae3:	83 ec 04             	sub    $0x4,%esp
  return lock->locked && lock->cpu == mycpu();
80104ae6:	8b 45 08             	mov    0x8(%ebp),%eax
80104ae9:	8b 00                	mov    (%eax),%eax
80104aeb:	85 c0                	test   %eax,%eax
80104aed:	74 16                	je     80104b05 <holding+0x26>
80104aef:	8b 45 08             	mov    0x8(%ebp),%eax
80104af2:	8b 58 08             	mov    0x8(%eax),%ebx
80104af5:	e8 be ee ff ff       	call   801039b8 <mycpu>
80104afa:	39 c3                	cmp    %eax,%ebx
80104afc:	75 07                	jne    80104b05 <holding+0x26>
80104afe:	b8 01 00 00 00       	mov    $0x1,%eax
80104b03:	eb 05                	jmp    80104b0a <holding+0x2b>
80104b05:	b8 00 00 00 00       	mov    $0x0,%eax
}
80104b0a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104b0d:	c9                   	leave  
80104b0e:	c3                   	ret    

80104b0f <pushcli>:
// it takes two popcli to undo two pushcli.  Also, if interrupts
// are off, then pushcli, popcli leaves them off.

void
pushcli(void)
{
80104b0f:	55                   	push   %ebp
80104b10:	89 e5                	mov    %esp,%ebp
80104b12:	83 ec 18             	sub    $0x18,%esp
  int eflags;

  eflags = readeflags();
80104b15:	e8 30 fe ff ff       	call   8010494a <readeflags>
80104b1a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  cli();
80104b1d:	e8 38 fe ff ff       	call   8010495a <cli>
  if(mycpu()->ncli == 0)
80104b22:	e8 91 ee ff ff       	call   801039b8 <mycpu>
80104b27:	8b 80 a4 00 00 00    	mov    0xa4(%eax),%eax
80104b2d:	85 c0                	test   %eax,%eax
80104b2f:	75 14                	jne    80104b45 <pushcli+0x36>
    mycpu()->intena = eflags & FL_IF;
80104b31:	e8 82 ee ff ff       	call   801039b8 <mycpu>
80104b36:	8b 55 f4             	mov    -0xc(%ebp),%edx
80104b39:	81 e2 00 02 00 00    	and    $0x200,%edx
80104b3f:	89 90 a8 00 00 00    	mov    %edx,0xa8(%eax)
  mycpu()->ncli += 1;
80104b45:	e8 6e ee ff ff       	call   801039b8 <mycpu>
80104b4a:	8b 90 a4 00 00 00    	mov    0xa4(%eax),%edx
80104b50:	83 c2 01             	add    $0x1,%edx
80104b53:	89 90 a4 00 00 00    	mov    %edx,0xa4(%eax)
}
80104b59:	90                   	nop
80104b5a:	c9                   	leave  
80104b5b:	c3                   	ret    

80104b5c <popcli>:

void
popcli(void)
{
80104b5c:	55                   	push   %ebp
80104b5d:	89 e5                	mov    %esp,%ebp
80104b5f:	83 ec 08             	sub    $0x8,%esp
  if(readeflags()&FL_IF)
80104b62:	e8 e3 fd ff ff       	call   8010494a <readeflags>
80104b67:	25 00 02 00 00       	and    $0x200,%eax
80104b6c:	85 c0                	test   %eax,%eax
80104b6e:	74 0d                	je     80104b7d <popcli+0x21>
    panic("popcli - interruptible");
80104b70:	83 ec 0c             	sub    $0xc,%esp
80104b73:	68 5a a6 10 80       	push   $0x8010a65a
80104b78:	e8 2c ba ff ff       	call   801005a9 <panic>
  if(--mycpu()->ncli < 0)
80104b7d:	e8 36 ee ff ff       	call   801039b8 <mycpu>
80104b82:	8b 90 a4 00 00 00    	mov    0xa4(%eax),%edx
80104b88:	83 ea 01             	sub    $0x1,%edx
80104b8b:	89 90 a4 00 00 00    	mov    %edx,0xa4(%eax)
80104b91:	8b 80 a4 00 00 00    	mov    0xa4(%eax),%eax
80104b97:	85 c0                	test   %eax,%eax
80104b99:	79 0d                	jns    80104ba8 <popcli+0x4c>
    panic("popcli");
80104b9b:	83 ec 0c             	sub    $0xc,%esp
80104b9e:	68 71 a6 10 80       	push   $0x8010a671
80104ba3:	e8 01 ba ff ff       	call   801005a9 <panic>
  if(mycpu()->ncli == 0 && mycpu()->intena)
80104ba8:	e8 0b ee ff ff       	call   801039b8 <mycpu>
80104bad:	8b 80 a4 00 00 00    	mov    0xa4(%eax),%eax
80104bb3:	85 c0                	test   %eax,%eax
80104bb5:	75 14                	jne    80104bcb <popcli+0x6f>
80104bb7:	e8 fc ed ff ff       	call   801039b8 <mycpu>
80104bbc:	8b 80 a8 00 00 00    	mov    0xa8(%eax),%eax
80104bc2:	85 c0                	test   %eax,%eax
80104bc4:	74 05                	je     80104bcb <popcli+0x6f>
    sti();
80104bc6:	e8 96 fd ff ff       	call   80104961 <sti>
}
80104bcb:	90                   	nop
80104bcc:	c9                   	leave  
80104bcd:	c3                   	ret    

80104bce <stosb>:
80104bce:	55                   	push   %ebp
80104bcf:	89 e5                	mov    %esp,%ebp
80104bd1:	57                   	push   %edi
80104bd2:	53                   	push   %ebx
80104bd3:	8b 4d 08             	mov    0x8(%ebp),%ecx
80104bd6:	8b 55 10             	mov    0x10(%ebp),%edx
80104bd9:	8b 45 0c             	mov    0xc(%ebp),%eax
80104bdc:	89 cb                	mov    %ecx,%ebx
80104bde:	89 df                	mov    %ebx,%edi
80104be0:	89 d1                	mov    %edx,%ecx
80104be2:	fc                   	cld    
80104be3:	f3 aa                	rep stos %al,%es:(%edi)
80104be5:	89 ca                	mov    %ecx,%edx
80104be7:	89 fb                	mov    %edi,%ebx
80104be9:	89 5d 08             	mov    %ebx,0x8(%ebp)
80104bec:	89 55 10             	mov    %edx,0x10(%ebp)
80104bef:	90                   	nop
80104bf0:	5b                   	pop    %ebx
80104bf1:	5f                   	pop    %edi
80104bf2:	5d                   	pop    %ebp
80104bf3:	c3                   	ret    

80104bf4 <stosl>:
80104bf4:	55                   	push   %ebp
80104bf5:	89 e5                	mov    %esp,%ebp
80104bf7:	57                   	push   %edi
80104bf8:	53                   	push   %ebx
80104bf9:	8b 4d 08             	mov    0x8(%ebp),%ecx
80104bfc:	8b 55 10             	mov    0x10(%ebp),%edx
80104bff:	8b 45 0c             	mov    0xc(%ebp),%eax
80104c02:	89 cb                	mov    %ecx,%ebx
80104c04:	89 df                	mov    %ebx,%edi
80104c06:	89 d1                	mov    %edx,%ecx
80104c08:	fc                   	cld    
80104c09:	f3 ab                	rep stos %eax,%es:(%edi)
80104c0b:	89 ca                	mov    %ecx,%edx
80104c0d:	89 fb                	mov    %edi,%ebx
80104c0f:	89 5d 08             	mov    %ebx,0x8(%ebp)
80104c12:	89 55 10             	mov    %edx,0x10(%ebp)
80104c15:	90                   	nop
80104c16:	5b                   	pop    %ebx
80104c17:	5f                   	pop    %edi
80104c18:	5d                   	pop    %ebp
80104c19:	c3                   	ret    

80104c1a <memset>:
80104c1a:	55                   	push   %ebp
80104c1b:	89 e5                	mov    %esp,%ebp
80104c1d:	8b 45 08             	mov    0x8(%ebp),%eax
80104c20:	83 e0 03             	and    $0x3,%eax
80104c23:	85 c0                	test   %eax,%eax
80104c25:	75 43                	jne    80104c6a <memset+0x50>
80104c27:	8b 45 10             	mov    0x10(%ebp),%eax
80104c2a:	83 e0 03             	and    $0x3,%eax
80104c2d:	85 c0                	test   %eax,%eax
80104c2f:	75 39                	jne    80104c6a <memset+0x50>
80104c31:	81 65 0c ff 00 00 00 	andl   $0xff,0xc(%ebp)
80104c38:	8b 45 10             	mov    0x10(%ebp),%eax
80104c3b:	c1 e8 02             	shr    $0x2,%eax
80104c3e:	89 c2                	mov    %eax,%edx
80104c40:	8b 45 0c             	mov    0xc(%ebp),%eax
80104c43:	c1 e0 18             	shl    $0x18,%eax
80104c46:	89 c1                	mov    %eax,%ecx
80104c48:	8b 45 0c             	mov    0xc(%ebp),%eax
80104c4b:	c1 e0 10             	shl    $0x10,%eax
80104c4e:	09 c1                	or     %eax,%ecx
80104c50:	8b 45 0c             	mov    0xc(%ebp),%eax
80104c53:	c1 e0 08             	shl    $0x8,%eax
80104c56:	09 c8                	or     %ecx,%eax
80104c58:	0b 45 0c             	or     0xc(%ebp),%eax
80104c5b:	52                   	push   %edx
80104c5c:	50                   	push   %eax
80104c5d:	ff 75 08             	push   0x8(%ebp)
80104c60:	e8 8f ff ff ff       	call   80104bf4 <stosl>
80104c65:	83 c4 0c             	add    $0xc,%esp
80104c68:	eb 12                	jmp    80104c7c <memset+0x62>
80104c6a:	8b 45 10             	mov    0x10(%ebp),%eax
80104c6d:	50                   	push   %eax
80104c6e:	ff 75 0c             	push   0xc(%ebp)
80104c71:	ff 75 08             	push   0x8(%ebp)
80104c74:	e8 55 ff ff ff       	call   80104bce <stosb>
80104c79:	83 c4 0c             	add    $0xc,%esp
80104c7c:	8b 45 08             	mov    0x8(%ebp),%eax
80104c7f:	c9                   	leave  
80104c80:	c3                   	ret    

80104c81 <memcmp>:
80104c81:	55                   	push   %ebp
80104c82:	89 e5                	mov    %esp,%ebp
80104c84:	83 ec 10             	sub    $0x10,%esp
80104c87:	8b 45 08             	mov    0x8(%ebp),%eax
80104c8a:	89 45 fc             	mov    %eax,-0x4(%ebp)
80104c8d:	8b 45 0c             	mov    0xc(%ebp),%eax
80104c90:	89 45 f8             	mov    %eax,-0x8(%ebp)
80104c93:	eb 30                	jmp    80104cc5 <memcmp+0x44>
80104c95:	8b 45 fc             	mov    -0x4(%ebp),%eax
80104c98:	0f b6 10             	movzbl (%eax),%edx
80104c9b:	8b 45 f8             	mov    -0x8(%ebp),%eax
80104c9e:	0f b6 00             	movzbl (%eax),%eax
80104ca1:	38 c2                	cmp    %al,%dl
80104ca3:	74 18                	je     80104cbd <memcmp+0x3c>
80104ca5:	8b 45 fc             	mov    -0x4(%ebp),%eax
80104ca8:	0f b6 00             	movzbl (%eax),%eax
80104cab:	0f b6 d0             	movzbl %al,%edx
80104cae:	8b 45 f8             	mov    -0x8(%ebp),%eax
80104cb1:	0f b6 00             	movzbl (%eax),%eax
80104cb4:	0f b6 c8             	movzbl %al,%ecx
80104cb7:	89 d0                	mov    %edx,%eax
80104cb9:	29 c8                	sub    %ecx,%eax
80104cbb:	eb 1a                	jmp    80104cd7 <memcmp+0x56>
80104cbd:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
80104cc1:	83 45 f8 01          	addl   $0x1,-0x8(%ebp)
80104cc5:	8b 45 10             	mov    0x10(%ebp),%eax
80104cc8:	8d 50 ff             	lea    -0x1(%eax),%edx
80104ccb:	89 55 10             	mov    %edx,0x10(%ebp)
80104cce:	85 c0                	test   %eax,%eax
80104cd0:	75 c3                	jne    80104c95 <memcmp+0x14>
80104cd2:	b8 00 00 00 00       	mov    $0x0,%eax
80104cd7:	c9                   	leave  
80104cd8:	c3                   	ret    

80104cd9 <memmove>:
80104cd9:	55                   	push   %ebp
80104cda:	89 e5                	mov    %esp,%ebp
80104cdc:	83 ec 10             	sub    $0x10,%esp
80104cdf:	8b 45 0c             	mov    0xc(%ebp),%eax
80104ce2:	89 45 fc             	mov    %eax,-0x4(%ebp)
80104ce5:	8b 45 08             	mov    0x8(%ebp),%eax
80104ce8:	89 45 f8             	mov    %eax,-0x8(%ebp)
80104ceb:	8b 45 fc             	mov    -0x4(%ebp),%eax
80104cee:	3b 45 f8             	cmp    -0x8(%ebp),%eax
80104cf1:	73 54                	jae    80104d47 <memmove+0x6e>
80104cf3:	8b 55 fc             	mov    -0x4(%ebp),%edx
80104cf6:	8b 45 10             	mov    0x10(%ebp),%eax
80104cf9:	01 d0                	add    %edx,%eax
80104cfb:	39 45 f8             	cmp    %eax,-0x8(%ebp)
80104cfe:	73 47                	jae    80104d47 <memmove+0x6e>
80104d00:	8b 45 10             	mov    0x10(%ebp),%eax
80104d03:	01 45 fc             	add    %eax,-0x4(%ebp)
80104d06:	8b 45 10             	mov    0x10(%ebp),%eax
80104d09:	01 45 f8             	add    %eax,-0x8(%ebp)
80104d0c:	eb 13                	jmp    80104d21 <memmove+0x48>
80104d0e:	83 6d fc 01          	subl   $0x1,-0x4(%ebp)
80104d12:	83 6d f8 01          	subl   $0x1,-0x8(%ebp)
80104d16:	8b 45 fc             	mov    -0x4(%ebp),%eax
80104d19:	0f b6 10             	movzbl (%eax),%edx
80104d1c:	8b 45 f8             	mov    -0x8(%ebp),%eax
80104d1f:	88 10                	mov    %dl,(%eax)
80104d21:	8b 45 10             	mov    0x10(%ebp),%eax
80104d24:	8d 50 ff             	lea    -0x1(%eax),%edx
80104d27:	89 55 10             	mov    %edx,0x10(%ebp)
80104d2a:	85 c0                	test   %eax,%eax
80104d2c:	75 e0                	jne    80104d0e <memmove+0x35>
80104d2e:	eb 24                	jmp    80104d54 <memmove+0x7b>
80104d30:	8b 55 fc             	mov    -0x4(%ebp),%edx
80104d33:	8d 42 01             	lea    0x1(%edx),%eax
80104d36:	89 45 fc             	mov    %eax,-0x4(%ebp)
80104d39:	8b 45 f8             	mov    -0x8(%ebp),%eax
80104d3c:	8d 48 01             	lea    0x1(%eax),%ecx
80104d3f:	89 4d f8             	mov    %ecx,-0x8(%ebp)
80104d42:	0f b6 12             	movzbl (%edx),%edx
80104d45:	88 10                	mov    %dl,(%eax)
80104d47:	8b 45 10             	mov    0x10(%ebp),%eax
80104d4a:	8d 50 ff             	lea    -0x1(%eax),%edx
80104d4d:	89 55 10             	mov    %edx,0x10(%ebp)
80104d50:	85 c0                	test   %eax,%eax
80104d52:	75 dc                	jne    80104d30 <memmove+0x57>
80104d54:	8b 45 08             	mov    0x8(%ebp),%eax
80104d57:	c9                   	leave  
80104d58:	c3                   	ret    

80104d59 <memcpy>:
80104d59:	55                   	push   %ebp
80104d5a:	89 e5                	mov    %esp,%ebp
80104d5c:	ff 75 10             	push   0x10(%ebp)
80104d5f:	ff 75 0c             	push   0xc(%ebp)
80104d62:	ff 75 08             	push   0x8(%ebp)
80104d65:	e8 6f ff ff ff       	call   80104cd9 <memmove>
80104d6a:	83 c4 0c             	add    $0xc,%esp
80104d6d:	c9                   	leave  
80104d6e:	c3                   	ret    

80104d6f <strncmp>:
80104d6f:	55                   	push   %ebp
80104d70:	89 e5                	mov    %esp,%ebp
80104d72:	eb 0c                	jmp    80104d80 <strncmp+0x11>
80104d74:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
80104d78:	83 45 08 01          	addl   $0x1,0x8(%ebp)
80104d7c:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
80104d80:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
80104d84:	74 1a                	je     80104da0 <strncmp+0x31>
80104d86:	8b 45 08             	mov    0x8(%ebp),%eax
80104d89:	0f b6 00             	movzbl (%eax),%eax
80104d8c:	84 c0                	test   %al,%al
80104d8e:	74 10                	je     80104da0 <strncmp+0x31>
80104d90:	8b 45 08             	mov    0x8(%ebp),%eax
80104d93:	0f b6 10             	movzbl (%eax),%edx
80104d96:	8b 45 0c             	mov    0xc(%ebp),%eax
80104d99:	0f b6 00             	movzbl (%eax),%eax
80104d9c:	38 c2                	cmp    %al,%dl
80104d9e:	74 d4                	je     80104d74 <strncmp+0x5>
80104da0:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
80104da4:	75 07                	jne    80104dad <strncmp+0x3e>
80104da6:	b8 00 00 00 00       	mov    $0x0,%eax
80104dab:	eb 16                	jmp    80104dc3 <strncmp+0x54>
80104dad:	8b 45 08             	mov    0x8(%ebp),%eax
80104db0:	0f b6 00             	movzbl (%eax),%eax
80104db3:	0f b6 d0             	movzbl %al,%edx
80104db6:	8b 45 0c             	mov    0xc(%ebp),%eax
80104db9:	0f b6 00             	movzbl (%eax),%eax
80104dbc:	0f b6 c8             	movzbl %al,%ecx
80104dbf:	89 d0                	mov    %edx,%eax
80104dc1:	29 c8                	sub    %ecx,%eax
80104dc3:	5d                   	pop    %ebp
80104dc4:	c3                   	ret    

80104dc5 <strncpy>:
80104dc5:	55                   	push   %ebp
80104dc6:	89 e5                	mov    %esp,%ebp
80104dc8:	83 ec 10             	sub    $0x10,%esp
80104dcb:	8b 45 08             	mov    0x8(%ebp),%eax
80104dce:	89 45 fc             	mov    %eax,-0x4(%ebp)
80104dd1:	90                   	nop
80104dd2:	8b 45 10             	mov    0x10(%ebp),%eax
80104dd5:	8d 50 ff             	lea    -0x1(%eax),%edx
80104dd8:	89 55 10             	mov    %edx,0x10(%ebp)
80104ddb:	85 c0                	test   %eax,%eax
80104ddd:	7e 2c                	jle    80104e0b <strncpy+0x46>
80104ddf:	8b 55 0c             	mov    0xc(%ebp),%edx
80104de2:	8d 42 01             	lea    0x1(%edx),%eax
80104de5:	89 45 0c             	mov    %eax,0xc(%ebp)
80104de8:	8b 45 08             	mov    0x8(%ebp),%eax
80104deb:	8d 48 01             	lea    0x1(%eax),%ecx
80104dee:	89 4d 08             	mov    %ecx,0x8(%ebp)
80104df1:	0f b6 12             	movzbl (%edx),%edx
80104df4:	88 10                	mov    %dl,(%eax)
80104df6:	0f b6 00             	movzbl (%eax),%eax
80104df9:	84 c0                	test   %al,%al
80104dfb:	75 d5                	jne    80104dd2 <strncpy+0xd>
80104dfd:	eb 0c                	jmp    80104e0b <strncpy+0x46>
80104dff:	8b 45 08             	mov    0x8(%ebp),%eax
80104e02:	8d 50 01             	lea    0x1(%eax),%edx
80104e05:	89 55 08             	mov    %edx,0x8(%ebp)
80104e08:	c6 00 00             	movb   $0x0,(%eax)
80104e0b:	8b 45 10             	mov    0x10(%ebp),%eax
80104e0e:	8d 50 ff             	lea    -0x1(%eax),%edx
80104e11:	89 55 10             	mov    %edx,0x10(%ebp)
80104e14:	85 c0                	test   %eax,%eax
80104e16:	7f e7                	jg     80104dff <strncpy+0x3a>
80104e18:	8b 45 fc             	mov    -0x4(%ebp),%eax
80104e1b:	c9                   	leave  
80104e1c:	c3                   	ret    

80104e1d <safestrcpy>:
80104e1d:	55                   	push   %ebp
80104e1e:	89 e5                	mov    %esp,%ebp
80104e20:	83 ec 10             	sub    $0x10,%esp
80104e23:	8b 45 08             	mov    0x8(%ebp),%eax
80104e26:	89 45 fc             	mov    %eax,-0x4(%ebp)
80104e29:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
80104e2d:	7f 05                	jg     80104e34 <safestrcpy+0x17>
80104e2f:	8b 45 fc             	mov    -0x4(%ebp),%eax
80104e32:	eb 32                	jmp    80104e66 <safestrcpy+0x49>
80104e34:	90                   	nop
80104e35:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
80104e39:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
80104e3d:	7e 1e                	jle    80104e5d <safestrcpy+0x40>
80104e3f:	8b 55 0c             	mov    0xc(%ebp),%edx
80104e42:	8d 42 01             	lea    0x1(%edx),%eax
80104e45:	89 45 0c             	mov    %eax,0xc(%ebp)
80104e48:	8b 45 08             	mov    0x8(%ebp),%eax
80104e4b:	8d 48 01             	lea    0x1(%eax),%ecx
80104e4e:	89 4d 08             	mov    %ecx,0x8(%ebp)
80104e51:	0f b6 12             	movzbl (%edx),%edx
80104e54:	88 10                	mov    %dl,(%eax)
80104e56:	0f b6 00             	movzbl (%eax),%eax
80104e59:	84 c0                	test   %al,%al
80104e5b:	75 d8                	jne    80104e35 <safestrcpy+0x18>
80104e5d:	8b 45 08             	mov    0x8(%ebp),%eax
80104e60:	c6 00 00             	movb   $0x0,(%eax)
80104e63:	8b 45 fc             	mov    -0x4(%ebp),%eax
80104e66:	c9                   	leave  
80104e67:	c3                   	ret    

80104e68 <strlen>:
80104e68:	55                   	push   %ebp
80104e69:	89 e5                	mov    %esp,%ebp
80104e6b:	83 ec 10             	sub    $0x10,%esp
80104e6e:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
80104e75:	eb 04                	jmp    80104e7b <strlen+0x13>
80104e77:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
80104e7b:	8b 55 fc             	mov    -0x4(%ebp),%edx
80104e7e:	8b 45 08             	mov    0x8(%ebp),%eax
80104e81:	01 d0                	add    %edx,%eax
80104e83:	0f b6 00             	movzbl (%eax),%eax
80104e86:	84 c0                	test   %al,%al
80104e88:	75 ed                	jne    80104e77 <strlen+0xf>
80104e8a:	8b 45 fc             	mov    -0x4(%ebp),%eax
80104e8d:	c9                   	leave  
80104e8e:	c3                   	ret    

80104e8f <swtch>:
80104e8f:	8b 44 24 04          	mov    0x4(%esp),%eax
80104e93:	8b 54 24 08          	mov    0x8(%esp),%edx
80104e97:	55                   	push   %ebp
80104e98:	53                   	push   %ebx
80104e99:	56                   	push   %esi
80104e9a:	57                   	push   %edi
80104e9b:	89 20                	mov    %esp,(%eax)
80104e9d:	89 d4                	mov    %edx,%esp
80104e9f:	5f                   	pop    %edi
80104ea0:	5e                   	pop    %esi
80104ea1:	5b                   	pop    %ebx
80104ea2:	5d                   	pop    %ebp
80104ea3:	c3                   	ret    

80104ea4 <fetchint>:
// to a saved program counter, and then the first argument.

// Fetch the int at addr from the current process.
int
fetchint(uint addr, int *ip)
{
80104ea4:	55                   	push   %ebp
80104ea5:	89 e5                	mov    %esp,%ebp
80104ea7:	83 ec 18             	sub    $0x18,%esp
  struct proc *curproc = myproc();
80104eaa:	e8 81 eb ff ff       	call   80103a30 <myproc>
80104eaf:	89 45 f4             	mov    %eax,-0xc(%ebp)

  if(addr >= curproc->sz || addr+4 > curproc->sz)
80104eb2:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104eb5:	8b 00                	mov    (%eax),%eax
80104eb7:	39 45 08             	cmp    %eax,0x8(%ebp)
80104eba:	73 0f                	jae    80104ecb <fetchint+0x27>
80104ebc:	8b 45 08             	mov    0x8(%ebp),%eax
80104ebf:	8d 50 04             	lea    0x4(%eax),%edx
80104ec2:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104ec5:	8b 00                	mov    (%eax),%eax
80104ec7:	39 c2                	cmp    %eax,%edx
80104ec9:	76 07                	jbe    80104ed2 <fetchint+0x2e>
    return -1;
80104ecb:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104ed0:	eb 0f                	jmp    80104ee1 <fetchint+0x3d>
  *ip = *(int*)(addr);
80104ed2:	8b 45 08             	mov    0x8(%ebp),%eax
80104ed5:	8b 10                	mov    (%eax),%edx
80104ed7:	8b 45 0c             	mov    0xc(%ebp),%eax
80104eda:	89 10                	mov    %edx,(%eax)
  return 0;
80104edc:	b8 00 00 00 00       	mov    $0x0,%eax
}
80104ee1:	c9                   	leave  
80104ee2:	c3                   	ret    

80104ee3 <fetchstr>:
// Fetch the nul-terminated string at addr from the current process.
// Doesn't actually copy the string - just sets *pp to point at it.
// Returns length of string, not including nul.
int
fetchstr(uint addr, char **pp)
{
80104ee3:	55                   	push   %ebp
80104ee4:	89 e5                	mov    %esp,%ebp
80104ee6:	83 ec 18             	sub    $0x18,%esp
  char *s, *ep;
  struct proc *curproc = myproc();
80104ee9:	e8 42 eb ff ff       	call   80103a30 <myproc>
80104eee:	89 45 f0             	mov    %eax,-0x10(%ebp)

  if(addr >= curproc->sz)
80104ef1:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104ef4:	8b 00                	mov    (%eax),%eax
80104ef6:	39 45 08             	cmp    %eax,0x8(%ebp)
80104ef9:	72 07                	jb     80104f02 <fetchstr+0x1f>
    return -1;
80104efb:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104f00:	eb 41                	jmp    80104f43 <fetchstr+0x60>
  *pp = (char*)addr;
80104f02:	8b 55 08             	mov    0x8(%ebp),%edx
80104f05:	8b 45 0c             	mov    0xc(%ebp),%eax
80104f08:	89 10                	mov    %edx,(%eax)
  ep = (char*)curproc->sz;
80104f0a:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104f0d:	8b 00                	mov    (%eax),%eax
80104f0f:	89 45 ec             	mov    %eax,-0x14(%ebp)
  for(s = *pp; s < ep; s++){
80104f12:	8b 45 0c             	mov    0xc(%ebp),%eax
80104f15:	8b 00                	mov    (%eax),%eax
80104f17:	89 45 f4             	mov    %eax,-0xc(%ebp)
80104f1a:	eb 1a                	jmp    80104f36 <fetchstr+0x53>
    if(*s == 0)
80104f1c:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104f1f:	0f b6 00             	movzbl (%eax),%eax
80104f22:	84 c0                	test   %al,%al
80104f24:	75 0c                	jne    80104f32 <fetchstr+0x4f>
      return s - *pp;
80104f26:	8b 45 0c             	mov    0xc(%ebp),%eax
80104f29:	8b 10                	mov    (%eax),%edx
80104f2b:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104f2e:	29 d0                	sub    %edx,%eax
80104f30:	eb 11                	jmp    80104f43 <fetchstr+0x60>
  for(s = *pp; s < ep; s++){
80104f32:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80104f36:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104f39:	3b 45 ec             	cmp    -0x14(%ebp),%eax
80104f3c:	72 de                	jb     80104f1c <fetchstr+0x39>
  }
  return -1;
80104f3e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104f43:	c9                   	leave  
80104f44:	c3                   	ret    

80104f45 <argint>:

// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
80104f45:	55                   	push   %ebp
80104f46:	89 e5                	mov    %esp,%ebp
80104f48:	83 ec 08             	sub    $0x8,%esp
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80104f4b:	e8 e0 ea ff ff       	call   80103a30 <myproc>
80104f50:	8b 40 18             	mov    0x18(%eax),%eax
80104f53:	8b 50 44             	mov    0x44(%eax),%edx
80104f56:	8b 45 08             	mov    0x8(%ebp),%eax
80104f59:	c1 e0 02             	shl    $0x2,%eax
80104f5c:	01 d0                	add    %edx,%eax
80104f5e:	83 c0 04             	add    $0x4,%eax
80104f61:	83 ec 08             	sub    $0x8,%esp
80104f64:	ff 75 0c             	push   0xc(%ebp)
80104f67:	50                   	push   %eax
80104f68:	e8 37 ff ff ff       	call   80104ea4 <fetchint>
80104f6d:	83 c4 10             	add    $0x10,%esp
}
80104f70:	c9                   	leave  
80104f71:	c3                   	ret    

80104f72 <argptr>:
// Fetch the nth word-sized system call argument as a pointer
// to a block of memory of size bytes.  Check that the pointer
// lies within the process address space.
int
argptr(int n, char **pp, int size)
{
80104f72:	55                   	push   %ebp
80104f73:	89 e5                	mov    %esp,%ebp
80104f75:	83 ec 18             	sub    $0x18,%esp
  int i;
  struct proc *curproc = myproc();
80104f78:	e8 b3 ea ff ff       	call   80103a30 <myproc>
80104f7d:	89 45 f4             	mov    %eax,-0xc(%ebp)
 
  if(argint(n, &i) < 0)
80104f80:	83 ec 08             	sub    $0x8,%esp
80104f83:	8d 45 f0             	lea    -0x10(%ebp),%eax
80104f86:	50                   	push   %eax
80104f87:	ff 75 08             	push   0x8(%ebp)
80104f8a:	e8 b6 ff ff ff       	call   80104f45 <argint>
80104f8f:	83 c4 10             	add    $0x10,%esp
80104f92:	85 c0                	test   %eax,%eax
80104f94:	79 07                	jns    80104f9d <argptr+0x2b>
    return -1;
80104f96:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104f9b:	eb 3b                	jmp    80104fd8 <argptr+0x66>
  if(size < 0 || (uint)i >= curproc->sz || (uint)i+size > curproc->sz)
80104f9d:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
80104fa1:	78 1f                	js     80104fc2 <argptr+0x50>
80104fa3:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104fa6:	8b 00                	mov    (%eax),%eax
80104fa8:	8b 55 f0             	mov    -0x10(%ebp),%edx
80104fab:	39 d0                	cmp    %edx,%eax
80104fad:	76 13                	jbe    80104fc2 <argptr+0x50>
80104faf:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104fb2:	89 c2                	mov    %eax,%edx
80104fb4:	8b 45 10             	mov    0x10(%ebp),%eax
80104fb7:	01 c2                	add    %eax,%edx
80104fb9:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104fbc:	8b 00                	mov    (%eax),%eax
80104fbe:	39 c2                	cmp    %eax,%edx
80104fc0:	76 07                	jbe    80104fc9 <argptr+0x57>
    return -1;
80104fc2:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104fc7:	eb 0f                	jmp    80104fd8 <argptr+0x66>
  *pp = (char*)i;
80104fc9:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104fcc:	89 c2                	mov    %eax,%edx
80104fce:	8b 45 0c             	mov    0xc(%ebp),%eax
80104fd1:	89 10                	mov    %edx,(%eax)
  return 0;
80104fd3:	b8 00 00 00 00       	mov    $0x0,%eax
}
80104fd8:	c9                   	leave  
80104fd9:	c3                   	ret    

80104fda <argstr>:
// Check that the pointer is valid and the string is nul-terminated.
// (There is no shared writable memory, so the string can't change
// between this check and being used by the kernel.)
int
argstr(int n, char **pp)
{
80104fda:	55                   	push   %ebp
80104fdb:	89 e5                	mov    %esp,%ebp
80104fdd:	83 ec 18             	sub    $0x18,%esp
  int addr;
  if(argint(n, &addr) < 0)
80104fe0:	83 ec 08             	sub    $0x8,%esp
80104fe3:	8d 45 f4             	lea    -0xc(%ebp),%eax
80104fe6:	50                   	push   %eax
80104fe7:	ff 75 08             	push   0x8(%ebp)
80104fea:	e8 56 ff ff ff       	call   80104f45 <argint>
80104fef:	83 c4 10             	add    $0x10,%esp
80104ff2:	85 c0                	test   %eax,%eax
80104ff4:	79 07                	jns    80104ffd <argstr+0x23>
    return -1;
80104ff6:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104ffb:	eb 12                	jmp    8010500f <argstr+0x35>
  return fetchstr(addr, pp);
80104ffd:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105000:	83 ec 08             	sub    $0x8,%esp
80105003:	ff 75 0c             	push   0xc(%ebp)
80105006:	50                   	push   %eax
80105007:	e8 d7 fe ff ff       	call   80104ee3 <fetchstr>
8010500c:	83 c4 10             	add    $0x10,%esp
}
8010500f:	c9                   	leave  
80105010:	c3                   	ret    

80105011 <syscall>:
[SYS_uthread_init]   sys_uthread_init,
};

void
syscall(void)
{
80105011:	55                   	push   %ebp
80105012:	89 e5                	mov    %esp,%ebp
80105014:	83 ec 18             	sub    $0x18,%esp
  int num;
  struct proc *curproc = myproc();
80105017:	e8 14 ea ff ff       	call   80103a30 <myproc>
8010501c:	89 45 f4             	mov    %eax,-0xc(%ebp)

  num = curproc->tf->eax;
8010501f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105022:	8b 40 18             	mov    0x18(%eax),%eax
80105025:	8b 40 1c             	mov    0x1c(%eax),%eax
80105028:	89 45 f0             	mov    %eax,-0x10(%ebp)
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
8010502b:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
8010502f:	7e 2f                	jle    80105060 <syscall+0x4f>
80105031:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105034:	83 f8 18             	cmp    $0x18,%eax
80105037:	77 27                	ja     80105060 <syscall+0x4f>
80105039:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010503c:	8b 04 85 20 f0 10 80 	mov    -0x7fef0fe0(,%eax,4),%eax
80105043:	85 c0                	test   %eax,%eax
80105045:	74 19                	je     80105060 <syscall+0x4f>
    curproc->tf->eax = syscalls[num]();
80105047:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010504a:	8b 04 85 20 f0 10 80 	mov    -0x7fef0fe0(,%eax,4),%eax
80105051:	ff d0                	call   *%eax
80105053:	89 c2                	mov    %eax,%edx
80105055:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105058:	8b 40 18             	mov    0x18(%eax),%eax
8010505b:	89 50 1c             	mov    %edx,0x1c(%eax)
8010505e:	eb 2c                	jmp    8010508c <syscall+0x7b>
  } else {
    cprintf("%d %s: unknown sys call %d\n",
            curproc->pid, curproc->name, num);
80105060:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105063:	8d 50 6c             	lea    0x6c(%eax),%edx
    cprintf("%d %s: unknown sys call %d\n",
80105066:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105069:	8b 40 10             	mov    0x10(%eax),%eax
8010506c:	ff 75 f0             	push   -0x10(%ebp)
8010506f:	52                   	push   %edx
80105070:	50                   	push   %eax
80105071:	68 78 a6 10 80       	push   $0x8010a678
80105076:	e8 79 b3 ff ff       	call   801003f4 <cprintf>
8010507b:	83 c4 10             	add    $0x10,%esp
    curproc->tf->eax = -1;
8010507e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105081:	8b 40 18             	mov    0x18(%eax),%eax
80105084:	c7 40 1c ff ff ff ff 	movl   $0xffffffff,0x1c(%eax)
  }
}
8010508b:	90                   	nop
8010508c:	90                   	nop
8010508d:	c9                   	leave  
8010508e:	c3                   	ret    

8010508f <argfd>:

// Fetch the nth word-sized system call argument as a file descriptor
// and return both the descriptor and the corresponding struct file.
static int
argfd(int n, int *pfd, struct file **pf)
{
8010508f:	55                   	push   %ebp
80105090:	89 e5                	mov    %esp,%ebp
80105092:	83 ec 18             	sub    $0x18,%esp
  int fd;
  struct file *f;

  if(argint(n, &fd) < 0)
80105095:	83 ec 08             	sub    $0x8,%esp
80105098:	8d 45 f0             	lea    -0x10(%ebp),%eax
8010509b:	50                   	push   %eax
8010509c:	ff 75 08             	push   0x8(%ebp)
8010509f:	e8 a1 fe ff ff       	call   80104f45 <argint>
801050a4:	83 c4 10             	add    $0x10,%esp
801050a7:	85 c0                	test   %eax,%eax
801050a9:	79 07                	jns    801050b2 <argfd+0x23>
    return -1;
801050ab:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801050b0:	eb 4f                	jmp    80105101 <argfd+0x72>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
801050b2:	8b 45 f0             	mov    -0x10(%ebp),%eax
801050b5:	85 c0                	test   %eax,%eax
801050b7:	78 20                	js     801050d9 <argfd+0x4a>
801050b9:	8b 45 f0             	mov    -0x10(%ebp),%eax
801050bc:	83 f8 0f             	cmp    $0xf,%eax
801050bf:	7f 18                	jg     801050d9 <argfd+0x4a>
801050c1:	e8 6a e9 ff ff       	call   80103a30 <myproc>
801050c6:	8b 55 f0             	mov    -0x10(%ebp),%edx
801050c9:	83 c2 08             	add    $0x8,%edx
801050cc:	8b 44 90 08          	mov    0x8(%eax,%edx,4),%eax
801050d0:	89 45 f4             	mov    %eax,-0xc(%ebp)
801050d3:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801050d7:	75 07                	jne    801050e0 <argfd+0x51>
    return -1;
801050d9:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801050de:	eb 21                	jmp    80105101 <argfd+0x72>
  if(pfd)
801050e0:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
801050e4:	74 08                	je     801050ee <argfd+0x5f>
    *pfd = fd;
801050e6:	8b 55 f0             	mov    -0x10(%ebp),%edx
801050e9:	8b 45 0c             	mov    0xc(%ebp),%eax
801050ec:	89 10                	mov    %edx,(%eax)
  if(pf)
801050ee:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
801050f2:	74 08                	je     801050fc <argfd+0x6d>
    *pf = f;
801050f4:	8b 45 10             	mov    0x10(%ebp),%eax
801050f7:	8b 55 f4             	mov    -0xc(%ebp),%edx
801050fa:	89 10                	mov    %edx,(%eax)
  return 0;
801050fc:	b8 00 00 00 00       	mov    $0x0,%eax
}
80105101:	c9                   	leave  
80105102:	c3                   	ret    

80105103 <fdalloc>:

// Allocate a file descriptor for the given file.
// Takes over file reference from caller on success.
static int
fdalloc(struct file *f)
{
80105103:	55                   	push   %ebp
80105104:	89 e5                	mov    %esp,%ebp
80105106:	83 ec 18             	sub    $0x18,%esp
  int fd;
  struct proc *curproc = myproc();
80105109:	e8 22 e9 ff ff       	call   80103a30 <myproc>
8010510e:	89 45 f0             	mov    %eax,-0x10(%ebp)

  for(fd = 0; fd < NOFILE; fd++){
80105111:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80105118:	eb 2a                	jmp    80105144 <fdalloc+0x41>
    if(curproc->ofile[fd] == 0){
8010511a:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010511d:	8b 55 f4             	mov    -0xc(%ebp),%edx
80105120:	83 c2 08             	add    $0x8,%edx
80105123:	8b 44 90 08          	mov    0x8(%eax,%edx,4),%eax
80105127:	85 c0                	test   %eax,%eax
80105129:	75 15                	jne    80105140 <fdalloc+0x3d>
      curproc->ofile[fd] = f;
8010512b:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010512e:	8b 55 f4             	mov    -0xc(%ebp),%edx
80105131:	8d 4a 08             	lea    0x8(%edx),%ecx
80105134:	8b 55 08             	mov    0x8(%ebp),%edx
80105137:	89 54 88 08          	mov    %edx,0x8(%eax,%ecx,4)
      return fd;
8010513b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010513e:	eb 0f                	jmp    8010514f <fdalloc+0x4c>
  for(fd = 0; fd < NOFILE; fd++){
80105140:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80105144:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
80105148:	7e d0                	jle    8010511a <fdalloc+0x17>
    }
  }
  return -1;
8010514a:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
8010514f:	c9                   	leave  
80105150:	c3                   	ret    

80105151 <sys_dup>:

int
sys_dup(void)
{
80105151:	55                   	push   %ebp
80105152:	89 e5                	mov    %esp,%ebp
80105154:	83 ec 18             	sub    $0x18,%esp
  struct file *f;
  int fd;

  if(argfd(0, 0, &f) < 0)
80105157:	83 ec 04             	sub    $0x4,%esp
8010515a:	8d 45 f0             	lea    -0x10(%ebp),%eax
8010515d:	50                   	push   %eax
8010515e:	6a 00                	push   $0x0
80105160:	6a 00                	push   $0x0
80105162:	e8 28 ff ff ff       	call   8010508f <argfd>
80105167:	83 c4 10             	add    $0x10,%esp
8010516a:	85 c0                	test   %eax,%eax
8010516c:	79 07                	jns    80105175 <sys_dup+0x24>
    return -1;
8010516e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105173:	eb 31                	jmp    801051a6 <sys_dup+0x55>
  if((fd=fdalloc(f)) < 0)
80105175:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105178:	83 ec 0c             	sub    $0xc,%esp
8010517b:	50                   	push   %eax
8010517c:	e8 82 ff ff ff       	call   80105103 <fdalloc>
80105181:	83 c4 10             	add    $0x10,%esp
80105184:	89 45 f4             	mov    %eax,-0xc(%ebp)
80105187:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
8010518b:	79 07                	jns    80105194 <sys_dup+0x43>
    return -1;
8010518d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105192:	eb 12                	jmp    801051a6 <sys_dup+0x55>
  filedup(f);
80105194:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105197:	83 ec 0c             	sub    $0xc,%esp
8010519a:	50                   	push   %eax
8010519b:	e8 aa be ff ff       	call   8010104a <filedup>
801051a0:	83 c4 10             	add    $0x10,%esp
  return fd;
801051a3:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
801051a6:	c9                   	leave  
801051a7:	c3                   	ret    

801051a8 <sys_read>:

int
sys_read(void)
{
801051a8:	55                   	push   %ebp
801051a9:	89 e5                	mov    %esp,%ebp
801051ab:	83 ec 18             	sub    $0x18,%esp
  struct file *f;
  int n;
  char *p;

  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
801051ae:	83 ec 04             	sub    $0x4,%esp
801051b1:	8d 45 f4             	lea    -0xc(%ebp),%eax
801051b4:	50                   	push   %eax
801051b5:	6a 00                	push   $0x0
801051b7:	6a 00                	push   $0x0
801051b9:	e8 d1 fe ff ff       	call   8010508f <argfd>
801051be:	83 c4 10             	add    $0x10,%esp
801051c1:	85 c0                	test   %eax,%eax
801051c3:	78 2e                	js     801051f3 <sys_read+0x4b>
801051c5:	83 ec 08             	sub    $0x8,%esp
801051c8:	8d 45 f0             	lea    -0x10(%ebp),%eax
801051cb:	50                   	push   %eax
801051cc:	6a 02                	push   $0x2
801051ce:	e8 72 fd ff ff       	call   80104f45 <argint>
801051d3:	83 c4 10             	add    $0x10,%esp
801051d6:	85 c0                	test   %eax,%eax
801051d8:	78 19                	js     801051f3 <sys_read+0x4b>
801051da:	8b 45 f0             	mov    -0x10(%ebp),%eax
801051dd:	83 ec 04             	sub    $0x4,%esp
801051e0:	50                   	push   %eax
801051e1:	8d 45 ec             	lea    -0x14(%ebp),%eax
801051e4:	50                   	push   %eax
801051e5:	6a 01                	push   $0x1
801051e7:	e8 86 fd ff ff       	call   80104f72 <argptr>
801051ec:	83 c4 10             	add    $0x10,%esp
801051ef:	85 c0                	test   %eax,%eax
801051f1:	79 07                	jns    801051fa <sys_read+0x52>
    return -1;
801051f3:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801051f8:	eb 17                	jmp    80105211 <sys_read+0x69>
  return fileread(f, p, n);
801051fa:	8b 4d f0             	mov    -0x10(%ebp),%ecx
801051fd:	8b 55 ec             	mov    -0x14(%ebp),%edx
80105200:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105203:	83 ec 04             	sub    $0x4,%esp
80105206:	51                   	push   %ecx
80105207:	52                   	push   %edx
80105208:	50                   	push   %eax
80105209:	e8 cc bf ff ff       	call   801011da <fileread>
8010520e:	83 c4 10             	add    $0x10,%esp
}
80105211:	c9                   	leave  
80105212:	c3                   	ret    

80105213 <sys_write>:

int
sys_write(void)
{
80105213:	55                   	push   %ebp
80105214:	89 e5                	mov    %esp,%ebp
80105216:	83 ec 18             	sub    $0x18,%esp
  struct file *f;
  int n;
  char *p;

  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80105219:	83 ec 04             	sub    $0x4,%esp
8010521c:	8d 45 f4             	lea    -0xc(%ebp),%eax
8010521f:	50                   	push   %eax
80105220:	6a 00                	push   $0x0
80105222:	6a 00                	push   $0x0
80105224:	e8 66 fe ff ff       	call   8010508f <argfd>
80105229:	83 c4 10             	add    $0x10,%esp
8010522c:	85 c0                	test   %eax,%eax
8010522e:	78 2e                	js     8010525e <sys_write+0x4b>
80105230:	83 ec 08             	sub    $0x8,%esp
80105233:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105236:	50                   	push   %eax
80105237:	6a 02                	push   $0x2
80105239:	e8 07 fd ff ff       	call   80104f45 <argint>
8010523e:	83 c4 10             	add    $0x10,%esp
80105241:	85 c0                	test   %eax,%eax
80105243:	78 19                	js     8010525e <sys_write+0x4b>
80105245:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105248:	83 ec 04             	sub    $0x4,%esp
8010524b:	50                   	push   %eax
8010524c:	8d 45 ec             	lea    -0x14(%ebp),%eax
8010524f:	50                   	push   %eax
80105250:	6a 01                	push   $0x1
80105252:	e8 1b fd ff ff       	call   80104f72 <argptr>
80105257:	83 c4 10             	add    $0x10,%esp
8010525a:	85 c0                	test   %eax,%eax
8010525c:	79 07                	jns    80105265 <sys_write+0x52>
    return -1;
8010525e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105263:	eb 17                	jmp    8010527c <sys_write+0x69>
  return filewrite(f, p, n);
80105265:	8b 4d f0             	mov    -0x10(%ebp),%ecx
80105268:	8b 55 ec             	mov    -0x14(%ebp),%edx
8010526b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010526e:	83 ec 04             	sub    $0x4,%esp
80105271:	51                   	push   %ecx
80105272:	52                   	push   %edx
80105273:	50                   	push   %eax
80105274:	e8 19 c0 ff ff       	call   80101292 <filewrite>
80105279:	83 c4 10             	add    $0x10,%esp
}
8010527c:	c9                   	leave  
8010527d:	c3                   	ret    

8010527e <sys_close>:

int
sys_close(void)
{
8010527e:	55                   	push   %ebp
8010527f:	89 e5                	mov    %esp,%ebp
80105281:	83 ec 18             	sub    $0x18,%esp
  int fd;
  struct file *f;

  if(argfd(0, &fd, &f) < 0)
80105284:	83 ec 04             	sub    $0x4,%esp
80105287:	8d 45 f0             	lea    -0x10(%ebp),%eax
8010528a:	50                   	push   %eax
8010528b:	8d 45 f4             	lea    -0xc(%ebp),%eax
8010528e:	50                   	push   %eax
8010528f:	6a 00                	push   $0x0
80105291:	e8 f9 fd ff ff       	call   8010508f <argfd>
80105296:	83 c4 10             	add    $0x10,%esp
80105299:	85 c0                	test   %eax,%eax
8010529b:	79 07                	jns    801052a4 <sys_close+0x26>
    return -1;
8010529d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801052a2:	eb 27                	jmp    801052cb <sys_close+0x4d>
  myproc()->ofile[fd] = 0;
801052a4:	e8 87 e7 ff ff       	call   80103a30 <myproc>
801052a9:	8b 55 f4             	mov    -0xc(%ebp),%edx
801052ac:	83 c2 08             	add    $0x8,%edx
801052af:	c7 44 90 08 00 00 00 	movl   $0x0,0x8(%eax,%edx,4)
801052b6:	00 
  fileclose(f);
801052b7:	8b 45 f0             	mov    -0x10(%ebp),%eax
801052ba:	83 ec 0c             	sub    $0xc,%esp
801052bd:	50                   	push   %eax
801052be:	e8 d8 bd ff ff       	call   8010109b <fileclose>
801052c3:	83 c4 10             	add    $0x10,%esp
  return 0;
801052c6:	b8 00 00 00 00       	mov    $0x0,%eax
}
801052cb:	c9                   	leave  
801052cc:	c3                   	ret    

801052cd <sys_fstat>:

int
sys_fstat(void)
{
801052cd:	55                   	push   %ebp
801052ce:	89 e5                	mov    %esp,%ebp
801052d0:	83 ec 18             	sub    $0x18,%esp
  struct file *f;
  struct stat *st;

  if(argfd(0, 0, &f) < 0 || argptr(1, (void*)&st, sizeof(*st)) < 0)
801052d3:	83 ec 04             	sub    $0x4,%esp
801052d6:	8d 45 f4             	lea    -0xc(%ebp),%eax
801052d9:	50                   	push   %eax
801052da:	6a 00                	push   $0x0
801052dc:	6a 00                	push   $0x0
801052de:	e8 ac fd ff ff       	call   8010508f <argfd>
801052e3:	83 c4 10             	add    $0x10,%esp
801052e6:	85 c0                	test   %eax,%eax
801052e8:	78 17                	js     80105301 <sys_fstat+0x34>
801052ea:	83 ec 04             	sub    $0x4,%esp
801052ed:	6a 14                	push   $0x14
801052ef:	8d 45 f0             	lea    -0x10(%ebp),%eax
801052f2:	50                   	push   %eax
801052f3:	6a 01                	push   $0x1
801052f5:	e8 78 fc ff ff       	call   80104f72 <argptr>
801052fa:	83 c4 10             	add    $0x10,%esp
801052fd:	85 c0                	test   %eax,%eax
801052ff:	79 07                	jns    80105308 <sys_fstat+0x3b>
    return -1;
80105301:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105306:	eb 13                	jmp    8010531b <sys_fstat+0x4e>
  return filestat(f, st);
80105308:	8b 55 f0             	mov    -0x10(%ebp),%edx
8010530b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010530e:	83 ec 08             	sub    $0x8,%esp
80105311:	52                   	push   %edx
80105312:	50                   	push   %eax
80105313:	e8 6b be ff ff       	call   80101183 <filestat>
80105318:	83 c4 10             	add    $0x10,%esp
}
8010531b:	c9                   	leave  
8010531c:	c3                   	ret    

8010531d <sys_link>:

// Create the path new as a link to the same inode as old.
int
sys_link(void)
{
8010531d:	55                   	push   %ebp
8010531e:	89 e5                	mov    %esp,%ebp
80105320:	83 ec 28             	sub    $0x28,%esp
  char name[DIRSIZ], *new, *old;
  struct inode *dp, *ip;

  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
80105323:	83 ec 08             	sub    $0x8,%esp
80105326:	8d 45 d8             	lea    -0x28(%ebp),%eax
80105329:	50                   	push   %eax
8010532a:	6a 00                	push   $0x0
8010532c:	e8 a9 fc ff ff       	call   80104fda <argstr>
80105331:	83 c4 10             	add    $0x10,%esp
80105334:	85 c0                	test   %eax,%eax
80105336:	78 15                	js     8010534d <sys_link+0x30>
80105338:	83 ec 08             	sub    $0x8,%esp
8010533b:	8d 45 dc             	lea    -0x24(%ebp),%eax
8010533e:	50                   	push   %eax
8010533f:	6a 01                	push   $0x1
80105341:	e8 94 fc ff ff       	call   80104fda <argstr>
80105346:	83 c4 10             	add    $0x10,%esp
80105349:	85 c0                	test   %eax,%eax
8010534b:	79 0a                	jns    80105357 <sys_link+0x3a>
    return -1;
8010534d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105352:	e9 68 01 00 00       	jmp    801054bf <sys_link+0x1a2>

  begin_op();
80105357:	e8 e0 dc ff ff       	call   8010303c <begin_op>
  if((ip = namei(old)) == 0){
8010535c:	8b 45 d8             	mov    -0x28(%ebp),%eax
8010535f:	83 ec 0c             	sub    $0xc,%esp
80105362:	50                   	push   %eax
80105363:	e8 b5 d1 ff ff       	call   8010251d <namei>
80105368:	83 c4 10             	add    $0x10,%esp
8010536b:	89 45 f4             	mov    %eax,-0xc(%ebp)
8010536e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80105372:	75 0f                	jne    80105383 <sys_link+0x66>
    end_op();
80105374:	e8 4f dd ff ff       	call   801030c8 <end_op>
    return -1;
80105379:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010537e:	e9 3c 01 00 00       	jmp    801054bf <sys_link+0x1a2>
  }

  ilock(ip);
80105383:	83 ec 0c             	sub    $0xc,%esp
80105386:	ff 75 f4             	push   -0xc(%ebp)
80105389:	e8 5c c6 ff ff       	call   801019ea <ilock>
8010538e:	83 c4 10             	add    $0x10,%esp
  if(ip->type == T_DIR){
80105391:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105394:	0f b7 40 50          	movzwl 0x50(%eax),%eax
80105398:	66 83 f8 01          	cmp    $0x1,%ax
8010539c:	75 1d                	jne    801053bb <sys_link+0x9e>
    iunlockput(ip);
8010539e:	83 ec 0c             	sub    $0xc,%esp
801053a1:	ff 75 f4             	push   -0xc(%ebp)
801053a4:	e8 72 c8 ff ff       	call   80101c1b <iunlockput>
801053a9:	83 c4 10             	add    $0x10,%esp
    end_op();
801053ac:	e8 17 dd ff ff       	call   801030c8 <end_op>
    return -1;
801053b1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801053b6:	e9 04 01 00 00       	jmp    801054bf <sys_link+0x1a2>
  }

  ip->nlink++;
801053bb:	8b 45 f4             	mov    -0xc(%ebp),%eax
801053be:	0f b7 40 56          	movzwl 0x56(%eax),%eax
801053c2:	83 c0 01             	add    $0x1,%eax
801053c5:	89 c2                	mov    %eax,%edx
801053c7:	8b 45 f4             	mov    -0xc(%ebp),%eax
801053ca:	66 89 50 56          	mov    %dx,0x56(%eax)
  iupdate(ip);
801053ce:	83 ec 0c             	sub    $0xc,%esp
801053d1:	ff 75 f4             	push   -0xc(%ebp)
801053d4:	e8 34 c4 ff ff       	call   8010180d <iupdate>
801053d9:	83 c4 10             	add    $0x10,%esp
  iunlock(ip);
801053dc:	83 ec 0c             	sub    $0xc,%esp
801053df:	ff 75 f4             	push   -0xc(%ebp)
801053e2:	e8 16 c7 ff ff       	call   80101afd <iunlock>
801053e7:	83 c4 10             	add    $0x10,%esp

  if((dp = nameiparent(new, name)) == 0)
801053ea:	8b 45 dc             	mov    -0x24(%ebp),%eax
801053ed:	83 ec 08             	sub    $0x8,%esp
801053f0:	8d 55 e2             	lea    -0x1e(%ebp),%edx
801053f3:	52                   	push   %edx
801053f4:	50                   	push   %eax
801053f5:	e8 3f d1 ff ff       	call   80102539 <nameiparent>
801053fa:	83 c4 10             	add    $0x10,%esp
801053fd:	89 45 f0             	mov    %eax,-0x10(%ebp)
80105400:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80105404:	74 71                	je     80105477 <sys_link+0x15a>
    goto bad;
  ilock(dp);
80105406:	83 ec 0c             	sub    $0xc,%esp
80105409:	ff 75 f0             	push   -0x10(%ebp)
8010540c:	e8 d9 c5 ff ff       	call   801019ea <ilock>
80105411:	83 c4 10             	add    $0x10,%esp
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
80105414:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105417:	8b 10                	mov    (%eax),%edx
80105419:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010541c:	8b 00                	mov    (%eax),%eax
8010541e:	39 c2                	cmp    %eax,%edx
80105420:	75 1d                	jne    8010543f <sys_link+0x122>
80105422:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105425:	8b 40 04             	mov    0x4(%eax),%eax
80105428:	83 ec 04             	sub    $0x4,%esp
8010542b:	50                   	push   %eax
8010542c:	8d 45 e2             	lea    -0x1e(%ebp),%eax
8010542f:	50                   	push   %eax
80105430:	ff 75 f0             	push   -0x10(%ebp)
80105433:	e8 4e ce ff ff       	call   80102286 <dirlink>
80105438:	83 c4 10             	add    $0x10,%esp
8010543b:	85 c0                	test   %eax,%eax
8010543d:	79 10                	jns    8010544f <sys_link+0x132>
    iunlockput(dp);
8010543f:	83 ec 0c             	sub    $0xc,%esp
80105442:	ff 75 f0             	push   -0x10(%ebp)
80105445:	e8 d1 c7 ff ff       	call   80101c1b <iunlockput>
8010544a:	83 c4 10             	add    $0x10,%esp
    goto bad;
8010544d:	eb 29                	jmp    80105478 <sys_link+0x15b>
  }
  iunlockput(dp);
8010544f:	83 ec 0c             	sub    $0xc,%esp
80105452:	ff 75 f0             	push   -0x10(%ebp)
80105455:	e8 c1 c7 ff ff       	call   80101c1b <iunlockput>
8010545a:	83 c4 10             	add    $0x10,%esp
  iput(ip);
8010545d:	83 ec 0c             	sub    $0xc,%esp
80105460:	ff 75 f4             	push   -0xc(%ebp)
80105463:	e8 e3 c6 ff ff       	call   80101b4b <iput>
80105468:	83 c4 10             	add    $0x10,%esp

  end_op();
8010546b:	e8 58 dc ff ff       	call   801030c8 <end_op>

  return 0;
80105470:	b8 00 00 00 00       	mov    $0x0,%eax
80105475:	eb 48                	jmp    801054bf <sys_link+0x1a2>
    goto bad;
80105477:	90                   	nop

bad:
  ilock(ip);
80105478:	83 ec 0c             	sub    $0xc,%esp
8010547b:	ff 75 f4             	push   -0xc(%ebp)
8010547e:	e8 67 c5 ff ff       	call   801019ea <ilock>
80105483:	83 c4 10             	add    $0x10,%esp
  ip->nlink--;
80105486:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105489:	0f b7 40 56          	movzwl 0x56(%eax),%eax
8010548d:	83 e8 01             	sub    $0x1,%eax
80105490:	89 c2                	mov    %eax,%edx
80105492:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105495:	66 89 50 56          	mov    %dx,0x56(%eax)
  iupdate(ip);
80105499:	83 ec 0c             	sub    $0xc,%esp
8010549c:	ff 75 f4             	push   -0xc(%ebp)
8010549f:	e8 69 c3 ff ff       	call   8010180d <iupdate>
801054a4:	83 c4 10             	add    $0x10,%esp
  iunlockput(ip);
801054a7:	83 ec 0c             	sub    $0xc,%esp
801054aa:	ff 75 f4             	push   -0xc(%ebp)
801054ad:	e8 69 c7 ff ff       	call   80101c1b <iunlockput>
801054b2:	83 c4 10             	add    $0x10,%esp
  end_op();
801054b5:	e8 0e dc ff ff       	call   801030c8 <end_op>
  return -1;
801054ba:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801054bf:	c9                   	leave  
801054c0:	c3                   	ret    

801054c1 <isdirempty>:

// Is the directory dp empty except for "." and ".." ?
static int
isdirempty(struct inode *dp)
{
801054c1:	55                   	push   %ebp
801054c2:	89 e5                	mov    %esp,%ebp
801054c4:	83 ec 28             	sub    $0x28,%esp
  int off;
  struct dirent de;

  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
801054c7:	c7 45 f4 20 00 00 00 	movl   $0x20,-0xc(%ebp)
801054ce:	eb 40                	jmp    80105510 <isdirempty+0x4f>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
801054d0:	8b 45 f4             	mov    -0xc(%ebp),%eax
801054d3:	6a 10                	push   $0x10
801054d5:	50                   	push   %eax
801054d6:	8d 45 e4             	lea    -0x1c(%ebp),%eax
801054d9:	50                   	push   %eax
801054da:	ff 75 08             	push   0x8(%ebp)
801054dd:	e8 f4 c9 ff ff       	call   80101ed6 <readi>
801054e2:	83 c4 10             	add    $0x10,%esp
801054e5:	83 f8 10             	cmp    $0x10,%eax
801054e8:	74 0d                	je     801054f7 <isdirempty+0x36>
      panic("isdirempty: readi");
801054ea:	83 ec 0c             	sub    $0xc,%esp
801054ed:	68 94 a6 10 80       	push   $0x8010a694
801054f2:	e8 b2 b0 ff ff       	call   801005a9 <panic>
    if(de.inum != 0)
801054f7:	0f b7 45 e4          	movzwl -0x1c(%ebp),%eax
801054fb:	66 85 c0             	test   %ax,%ax
801054fe:	74 07                	je     80105507 <isdirempty+0x46>
      return 0;
80105500:	b8 00 00 00 00       	mov    $0x0,%eax
80105505:	eb 1b                	jmp    80105522 <isdirempty+0x61>
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
80105507:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010550a:	83 c0 10             	add    $0x10,%eax
8010550d:	89 45 f4             	mov    %eax,-0xc(%ebp)
80105510:	8b 45 08             	mov    0x8(%ebp),%eax
80105513:	8b 50 58             	mov    0x58(%eax),%edx
80105516:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105519:	39 c2                	cmp    %eax,%edx
8010551b:	77 b3                	ja     801054d0 <isdirempty+0xf>
  }
  return 1;
8010551d:	b8 01 00 00 00       	mov    $0x1,%eax
}
80105522:	c9                   	leave  
80105523:	c3                   	ret    

80105524 <sys_unlink>:

//PAGEBREAK!
int
sys_unlink(void)
{
80105524:	55                   	push   %ebp
80105525:	89 e5                	mov    %esp,%ebp
80105527:	83 ec 38             	sub    $0x38,%esp
  struct inode *ip, *dp;
  struct dirent de;
  char name[DIRSIZ], *path;
  uint off;

  if(argstr(0, &path) < 0)
8010552a:	83 ec 08             	sub    $0x8,%esp
8010552d:	8d 45 cc             	lea    -0x34(%ebp),%eax
80105530:	50                   	push   %eax
80105531:	6a 00                	push   $0x0
80105533:	e8 a2 fa ff ff       	call   80104fda <argstr>
80105538:	83 c4 10             	add    $0x10,%esp
8010553b:	85 c0                	test   %eax,%eax
8010553d:	79 0a                	jns    80105549 <sys_unlink+0x25>
    return -1;
8010553f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105544:	e9 bf 01 00 00       	jmp    80105708 <sys_unlink+0x1e4>

  begin_op();
80105549:	e8 ee da ff ff       	call   8010303c <begin_op>
  if((dp = nameiparent(path, name)) == 0){
8010554e:	8b 45 cc             	mov    -0x34(%ebp),%eax
80105551:	83 ec 08             	sub    $0x8,%esp
80105554:	8d 55 d2             	lea    -0x2e(%ebp),%edx
80105557:	52                   	push   %edx
80105558:	50                   	push   %eax
80105559:	e8 db cf ff ff       	call   80102539 <nameiparent>
8010555e:	83 c4 10             	add    $0x10,%esp
80105561:	89 45 f4             	mov    %eax,-0xc(%ebp)
80105564:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80105568:	75 0f                	jne    80105579 <sys_unlink+0x55>
    end_op();
8010556a:	e8 59 db ff ff       	call   801030c8 <end_op>
    return -1;
8010556f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105574:	e9 8f 01 00 00       	jmp    80105708 <sys_unlink+0x1e4>
  }

  ilock(dp);
80105579:	83 ec 0c             	sub    $0xc,%esp
8010557c:	ff 75 f4             	push   -0xc(%ebp)
8010557f:	e8 66 c4 ff ff       	call   801019ea <ilock>
80105584:	83 c4 10             	add    $0x10,%esp

  // Cannot unlink "." or "..".
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
80105587:	83 ec 08             	sub    $0x8,%esp
8010558a:	68 a6 a6 10 80       	push   $0x8010a6a6
8010558f:	8d 45 d2             	lea    -0x2e(%ebp),%eax
80105592:	50                   	push   %eax
80105593:	e8 19 cc ff ff       	call   801021b1 <namecmp>
80105598:	83 c4 10             	add    $0x10,%esp
8010559b:	85 c0                	test   %eax,%eax
8010559d:	0f 84 49 01 00 00    	je     801056ec <sys_unlink+0x1c8>
801055a3:	83 ec 08             	sub    $0x8,%esp
801055a6:	68 a8 a6 10 80       	push   $0x8010a6a8
801055ab:	8d 45 d2             	lea    -0x2e(%ebp),%eax
801055ae:	50                   	push   %eax
801055af:	e8 fd cb ff ff       	call   801021b1 <namecmp>
801055b4:	83 c4 10             	add    $0x10,%esp
801055b7:	85 c0                	test   %eax,%eax
801055b9:	0f 84 2d 01 00 00    	je     801056ec <sys_unlink+0x1c8>
    goto bad;

  if((ip = dirlookup(dp, name, &off)) == 0)
801055bf:	83 ec 04             	sub    $0x4,%esp
801055c2:	8d 45 c8             	lea    -0x38(%ebp),%eax
801055c5:	50                   	push   %eax
801055c6:	8d 45 d2             	lea    -0x2e(%ebp),%eax
801055c9:	50                   	push   %eax
801055ca:	ff 75 f4             	push   -0xc(%ebp)
801055cd:	e8 fa cb ff ff       	call   801021cc <dirlookup>
801055d2:	83 c4 10             	add    $0x10,%esp
801055d5:	89 45 f0             	mov    %eax,-0x10(%ebp)
801055d8:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
801055dc:	0f 84 0d 01 00 00    	je     801056ef <sys_unlink+0x1cb>
    goto bad;
  ilock(ip);
801055e2:	83 ec 0c             	sub    $0xc,%esp
801055e5:	ff 75 f0             	push   -0x10(%ebp)
801055e8:	e8 fd c3 ff ff       	call   801019ea <ilock>
801055ed:	83 c4 10             	add    $0x10,%esp

  if(ip->nlink < 1)
801055f0:	8b 45 f0             	mov    -0x10(%ebp),%eax
801055f3:	0f b7 40 56          	movzwl 0x56(%eax),%eax
801055f7:	66 85 c0             	test   %ax,%ax
801055fa:	7f 0d                	jg     80105609 <sys_unlink+0xe5>
    panic("unlink: nlink < 1");
801055fc:	83 ec 0c             	sub    $0xc,%esp
801055ff:	68 ab a6 10 80       	push   $0x8010a6ab
80105604:	e8 a0 af ff ff       	call   801005a9 <panic>
  if(ip->type == T_DIR && !isdirempty(ip)){
80105609:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010560c:	0f b7 40 50          	movzwl 0x50(%eax),%eax
80105610:	66 83 f8 01          	cmp    $0x1,%ax
80105614:	75 25                	jne    8010563b <sys_unlink+0x117>
80105616:	83 ec 0c             	sub    $0xc,%esp
80105619:	ff 75 f0             	push   -0x10(%ebp)
8010561c:	e8 a0 fe ff ff       	call   801054c1 <isdirempty>
80105621:	83 c4 10             	add    $0x10,%esp
80105624:	85 c0                	test   %eax,%eax
80105626:	75 13                	jne    8010563b <sys_unlink+0x117>
    iunlockput(ip);
80105628:	83 ec 0c             	sub    $0xc,%esp
8010562b:	ff 75 f0             	push   -0x10(%ebp)
8010562e:	e8 e8 c5 ff ff       	call   80101c1b <iunlockput>
80105633:	83 c4 10             	add    $0x10,%esp
    goto bad;
80105636:	e9 b5 00 00 00       	jmp    801056f0 <sys_unlink+0x1cc>
  }

  memset(&de, 0, sizeof(de));
8010563b:	83 ec 04             	sub    $0x4,%esp
8010563e:	6a 10                	push   $0x10
80105640:	6a 00                	push   $0x0
80105642:	8d 45 e0             	lea    -0x20(%ebp),%eax
80105645:	50                   	push   %eax
80105646:	e8 cf f5 ff ff       	call   80104c1a <memset>
8010564b:	83 c4 10             	add    $0x10,%esp
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
8010564e:	8b 45 c8             	mov    -0x38(%ebp),%eax
80105651:	6a 10                	push   $0x10
80105653:	50                   	push   %eax
80105654:	8d 45 e0             	lea    -0x20(%ebp),%eax
80105657:	50                   	push   %eax
80105658:	ff 75 f4             	push   -0xc(%ebp)
8010565b:	e8 cb c9 ff ff       	call   8010202b <writei>
80105660:	83 c4 10             	add    $0x10,%esp
80105663:	83 f8 10             	cmp    $0x10,%eax
80105666:	74 0d                	je     80105675 <sys_unlink+0x151>
    panic("unlink: writei");
80105668:	83 ec 0c             	sub    $0xc,%esp
8010566b:	68 bd a6 10 80       	push   $0x8010a6bd
80105670:	e8 34 af ff ff       	call   801005a9 <panic>
  if(ip->type == T_DIR){
80105675:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105678:	0f b7 40 50          	movzwl 0x50(%eax),%eax
8010567c:	66 83 f8 01          	cmp    $0x1,%ax
80105680:	75 21                	jne    801056a3 <sys_unlink+0x17f>
    dp->nlink--;
80105682:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105685:	0f b7 40 56          	movzwl 0x56(%eax),%eax
80105689:	83 e8 01             	sub    $0x1,%eax
8010568c:	89 c2                	mov    %eax,%edx
8010568e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105691:	66 89 50 56          	mov    %dx,0x56(%eax)
    iupdate(dp);
80105695:	83 ec 0c             	sub    $0xc,%esp
80105698:	ff 75 f4             	push   -0xc(%ebp)
8010569b:	e8 6d c1 ff ff       	call   8010180d <iupdate>
801056a0:	83 c4 10             	add    $0x10,%esp
  }
  iunlockput(dp);
801056a3:	83 ec 0c             	sub    $0xc,%esp
801056a6:	ff 75 f4             	push   -0xc(%ebp)
801056a9:	e8 6d c5 ff ff       	call   80101c1b <iunlockput>
801056ae:	83 c4 10             	add    $0x10,%esp

  ip->nlink--;
801056b1:	8b 45 f0             	mov    -0x10(%ebp),%eax
801056b4:	0f b7 40 56          	movzwl 0x56(%eax),%eax
801056b8:	83 e8 01             	sub    $0x1,%eax
801056bb:	89 c2                	mov    %eax,%edx
801056bd:	8b 45 f0             	mov    -0x10(%ebp),%eax
801056c0:	66 89 50 56          	mov    %dx,0x56(%eax)
  iupdate(ip);
801056c4:	83 ec 0c             	sub    $0xc,%esp
801056c7:	ff 75 f0             	push   -0x10(%ebp)
801056ca:	e8 3e c1 ff ff       	call   8010180d <iupdate>
801056cf:	83 c4 10             	add    $0x10,%esp
  iunlockput(ip);
801056d2:	83 ec 0c             	sub    $0xc,%esp
801056d5:	ff 75 f0             	push   -0x10(%ebp)
801056d8:	e8 3e c5 ff ff       	call   80101c1b <iunlockput>
801056dd:	83 c4 10             	add    $0x10,%esp

  end_op();
801056e0:	e8 e3 d9 ff ff       	call   801030c8 <end_op>

  return 0;
801056e5:	b8 00 00 00 00       	mov    $0x0,%eax
801056ea:	eb 1c                	jmp    80105708 <sys_unlink+0x1e4>
    goto bad;
801056ec:	90                   	nop
801056ed:	eb 01                	jmp    801056f0 <sys_unlink+0x1cc>
    goto bad;
801056ef:	90                   	nop

bad:
  iunlockput(dp);
801056f0:	83 ec 0c             	sub    $0xc,%esp
801056f3:	ff 75 f4             	push   -0xc(%ebp)
801056f6:	e8 20 c5 ff ff       	call   80101c1b <iunlockput>
801056fb:	83 c4 10             	add    $0x10,%esp
  end_op();
801056fe:	e8 c5 d9 ff ff       	call   801030c8 <end_op>
  return -1;
80105703:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105708:	c9                   	leave  
80105709:	c3                   	ret    

8010570a <create>:

static struct inode*
create(char *path, short type, short major, short minor)
{
8010570a:	55                   	push   %ebp
8010570b:	89 e5                	mov    %esp,%ebp
8010570d:	83 ec 38             	sub    $0x38,%esp
80105710:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80105713:	8b 55 10             	mov    0x10(%ebp),%edx
80105716:	8b 45 14             	mov    0x14(%ebp),%eax
80105719:	66 89 4d d4          	mov    %cx,-0x2c(%ebp)
8010571d:	66 89 55 d0          	mov    %dx,-0x30(%ebp)
80105721:	66 89 45 cc          	mov    %ax,-0x34(%ebp)
  uint off;
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
80105725:	83 ec 08             	sub    $0x8,%esp
80105728:	8d 45 de             	lea    -0x22(%ebp),%eax
8010572b:	50                   	push   %eax
8010572c:	ff 75 08             	push   0x8(%ebp)
8010572f:	e8 05 ce ff ff       	call   80102539 <nameiparent>
80105734:	83 c4 10             	add    $0x10,%esp
80105737:	89 45 f4             	mov    %eax,-0xc(%ebp)
8010573a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
8010573e:	75 0a                	jne    8010574a <create+0x40>
    return 0;
80105740:	b8 00 00 00 00       	mov    $0x0,%eax
80105745:	e9 90 01 00 00       	jmp    801058da <create+0x1d0>
  ilock(dp);
8010574a:	83 ec 0c             	sub    $0xc,%esp
8010574d:	ff 75 f4             	push   -0xc(%ebp)
80105750:	e8 95 c2 ff ff       	call   801019ea <ilock>
80105755:	83 c4 10             	add    $0x10,%esp

  if((ip = dirlookup(dp, name, &off)) != 0){
80105758:	83 ec 04             	sub    $0x4,%esp
8010575b:	8d 45 ec             	lea    -0x14(%ebp),%eax
8010575e:	50                   	push   %eax
8010575f:	8d 45 de             	lea    -0x22(%ebp),%eax
80105762:	50                   	push   %eax
80105763:	ff 75 f4             	push   -0xc(%ebp)
80105766:	e8 61 ca ff ff       	call   801021cc <dirlookup>
8010576b:	83 c4 10             	add    $0x10,%esp
8010576e:	89 45 f0             	mov    %eax,-0x10(%ebp)
80105771:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80105775:	74 50                	je     801057c7 <create+0xbd>
    iunlockput(dp);
80105777:	83 ec 0c             	sub    $0xc,%esp
8010577a:	ff 75 f4             	push   -0xc(%ebp)
8010577d:	e8 99 c4 ff ff       	call   80101c1b <iunlockput>
80105782:	83 c4 10             	add    $0x10,%esp
    ilock(ip);
80105785:	83 ec 0c             	sub    $0xc,%esp
80105788:	ff 75 f0             	push   -0x10(%ebp)
8010578b:	e8 5a c2 ff ff       	call   801019ea <ilock>
80105790:	83 c4 10             	add    $0x10,%esp
    if(type == T_FILE && ip->type == T_FILE)
80105793:	66 83 7d d4 02       	cmpw   $0x2,-0x2c(%ebp)
80105798:	75 15                	jne    801057af <create+0xa5>
8010579a:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010579d:	0f b7 40 50          	movzwl 0x50(%eax),%eax
801057a1:	66 83 f8 02          	cmp    $0x2,%ax
801057a5:	75 08                	jne    801057af <create+0xa5>
      return ip;
801057a7:	8b 45 f0             	mov    -0x10(%ebp),%eax
801057aa:	e9 2b 01 00 00       	jmp    801058da <create+0x1d0>
    iunlockput(ip);
801057af:	83 ec 0c             	sub    $0xc,%esp
801057b2:	ff 75 f0             	push   -0x10(%ebp)
801057b5:	e8 61 c4 ff ff       	call   80101c1b <iunlockput>
801057ba:	83 c4 10             	add    $0x10,%esp
    return 0;
801057bd:	b8 00 00 00 00       	mov    $0x0,%eax
801057c2:	e9 13 01 00 00       	jmp    801058da <create+0x1d0>
  }

  if((ip = ialloc(dp->dev, type)) == 0)
801057c7:	0f bf 55 d4          	movswl -0x2c(%ebp),%edx
801057cb:	8b 45 f4             	mov    -0xc(%ebp),%eax
801057ce:	8b 00                	mov    (%eax),%eax
801057d0:	83 ec 08             	sub    $0x8,%esp
801057d3:	52                   	push   %edx
801057d4:	50                   	push   %eax
801057d5:	e8 5c bf ff ff       	call   80101736 <ialloc>
801057da:	83 c4 10             	add    $0x10,%esp
801057dd:	89 45 f0             	mov    %eax,-0x10(%ebp)
801057e0:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
801057e4:	75 0d                	jne    801057f3 <create+0xe9>
    panic("create: ialloc");
801057e6:	83 ec 0c             	sub    $0xc,%esp
801057e9:	68 cc a6 10 80       	push   $0x8010a6cc
801057ee:	e8 b6 ad ff ff       	call   801005a9 <panic>

  ilock(ip);
801057f3:	83 ec 0c             	sub    $0xc,%esp
801057f6:	ff 75 f0             	push   -0x10(%ebp)
801057f9:	e8 ec c1 ff ff       	call   801019ea <ilock>
801057fe:	83 c4 10             	add    $0x10,%esp
  ip->major = major;
80105801:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105804:	0f b7 55 d0          	movzwl -0x30(%ebp),%edx
80105808:	66 89 50 52          	mov    %dx,0x52(%eax)
  ip->minor = minor;
8010580c:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010580f:	0f b7 55 cc          	movzwl -0x34(%ebp),%edx
80105813:	66 89 50 54          	mov    %dx,0x54(%eax)
  ip->nlink = 1;
80105817:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010581a:	66 c7 40 56 01 00    	movw   $0x1,0x56(%eax)
  iupdate(ip);
80105820:	83 ec 0c             	sub    $0xc,%esp
80105823:	ff 75 f0             	push   -0x10(%ebp)
80105826:	e8 e2 bf ff ff       	call   8010180d <iupdate>
8010582b:	83 c4 10             	add    $0x10,%esp

  if(type == T_DIR){  // Create . and .. entries.
8010582e:	66 83 7d d4 01       	cmpw   $0x1,-0x2c(%ebp)
80105833:	75 6a                	jne    8010589f <create+0x195>
    dp->nlink++;  // for ".."
80105835:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105838:	0f b7 40 56          	movzwl 0x56(%eax),%eax
8010583c:	83 c0 01             	add    $0x1,%eax
8010583f:	89 c2                	mov    %eax,%edx
80105841:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105844:	66 89 50 56          	mov    %dx,0x56(%eax)
    iupdate(dp);
80105848:	83 ec 0c             	sub    $0xc,%esp
8010584b:	ff 75 f4             	push   -0xc(%ebp)
8010584e:	e8 ba bf ff ff       	call   8010180d <iupdate>
80105853:	83 c4 10             	add    $0x10,%esp
    // No ip->nlink++ for ".": avoid cyclic ref count.
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
80105856:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105859:	8b 40 04             	mov    0x4(%eax),%eax
8010585c:	83 ec 04             	sub    $0x4,%esp
8010585f:	50                   	push   %eax
80105860:	68 a6 a6 10 80       	push   $0x8010a6a6
80105865:	ff 75 f0             	push   -0x10(%ebp)
80105868:	e8 19 ca ff ff       	call   80102286 <dirlink>
8010586d:	83 c4 10             	add    $0x10,%esp
80105870:	85 c0                	test   %eax,%eax
80105872:	78 1e                	js     80105892 <create+0x188>
80105874:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105877:	8b 40 04             	mov    0x4(%eax),%eax
8010587a:	83 ec 04             	sub    $0x4,%esp
8010587d:	50                   	push   %eax
8010587e:	68 a8 a6 10 80       	push   $0x8010a6a8
80105883:	ff 75 f0             	push   -0x10(%ebp)
80105886:	e8 fb c9 ff ff       	call   80102286 <dirlink>
8010588b:	83 c4 10             	add    $0x10,%esp
8010588e:	85 c0                	test   %eax,%eax
80105890:	79 0d                	jns    8010589f <create+0x195>
      panic("create dots");
80105892:	83 ec 0c             	sub    $0xc,%esp
80105895:	68 db a6 10 80       	push   $0x8010a6db
8010589a:	e8 0a ad ff ff       	call   801005a9 <panic>
  }

  if(dirlink(dp, name, ip->inum) < 0)
8010589f:	8b 45 f0             	mov    -0x10(%ebp),%eax
801058a2:	8b 40 04             	mov    0x4(%eax),%eax
801058a5:	83 ec 04             	sub    $0x4,%esp
801058a8:	50                   	push   %eax
801058a9:	8d 45 de             	lea    -0x22(%ebp),%eax
801058ac:	50                   	push   %eax
801058ad:	ff 75 f4             	push   -0xc(%ebp)
801058b0:	e8 d1 c9 ff ff       	call   80102286 <dirlink>
801058b5:	83 c4 10             	add    $0x10,%esp
801058b8:	85 c0                	test   %eax,%eax
801058ba:	79 0d                	jns    801058c9 <create+0x1bf>
    panic("create: dirlink");
801058bc:	83 ec 0c             	sub    $0xc,%esp
801058bf:	68 e7 a6 10 80       	push   $0x8010a6e7
801058c4:	e8 e0 ac ff ff       	call   801005a9 <panic>

  iunlockput(dp);
801058c9:	83 ec 0c             	sub    $0xc,%esp
801058cc:	ff 75 f4             	push   -0xc(%ebp)
801058cf:	e8 47 c3 ff ff       	call   80101c1b <iunlockput>
801058d4:	83 c4 10             	add    $0x10,%esp

  return ip;
801058d7:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
801058da:	c9                   	leave  
801058db:	c3                   	ret    

801058dc <sys_open>:

int
sys_open(void)
{
801058dc:	55                   	push   %ebp
801058dd:	89 e5                	mov    %esp,%ebp
801058df:	83 ec 28             	sub    $0x28,%esp
  char *path;
  int fd, omode;
  struct file *f;
  struct inode *ip;

  if(argstr(0, &path) < 0 || argint(1, &omode) < 0)
801058e2:	83 ec 08             	sub    $0x8,%esp
801058e5:	8d 45 e8             	lea    -0x18(%ebp),%eax
801058e8:	50                   	push   %eax
801058e9:	6a 00                	push   $0x0
801058eb:	e8 ea f6 ff ff       	call   80104fda <argstr>
801058f0:	83 c4 10             	add    $0x10,%esp
801058f3:	85 c0                	test   %eax,%eax
801058f5:	78 15                	js     8010590c <sys_open+0x30>
801058f7:	83 ec 08             	sub    $0x8,%esp
801058fa:	8d 45 e4             	lea    -0x1c(%ebp),%eax
801058fd:	50                   	push   %eax
801058fe:	6a 01                	push   $0x1
80105900:	e8 40 f6 ff ff       	call   80104f45 <argint>
80105905:	83 c4 10             	add    $0x10,%esp
80105908:	85 c0                	test   %eax,%eax
8010590a:	79 0a                	jns    80105916 <sys_open+0x3a>
    return -1;
8010590c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105911:	e9 61 01 00 00       	jmp    80105a77 <sys_open+0x19b>

  begin_op();
80105916:	e8 21 d7 ff ff       	call   8010303c <begin_op>

  if(omode & O_CREATE){
8010591b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010591e:	25 00 02 00 00       	and    $0x200,%eax
80105923:	85 c0                	test   %eax,%eax
80105925:	74 2a                	je     80105951 <sys_open+0x75>
    ip = create(path, T_FILE, 0, 0);
80105927:	8b 45 e8             	mov    -0x18(%ebp),%eax
8010592a:	6a 00                	push   $0x0
8010592c:	6a 00                	push   $0x0
8010592e:	6a 02                	push   $0x2
80105930:	50                   	push   %eax
80105931:	e8 d4 fd ff ff       	call   8010570a <create>
80105936:	83 c4 10             	add    $0x10,%esp
80105939:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(ip == 0){
8010593c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80105940:	75 75                	jne    801059b7 <sys_open+0xdb>
      end_op();
80105942:	e8 81 d7 ff ff       	call   801030c8 <end_op>
      return -1;
80105947:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010594c:	e9 26 01 00 00       	jmp    80105a77 <sys_open+0x19b>
    }
  } else {
    if((ip = namei(path)) == 0){
80105951:	8b 45 e8             	mov    -0x18(%ebp),%eax
80105954:	83 ec 0c             	sub    $0xc,%esp
80105957:	50                   	push   %eax
80105958:	e8 c0 cb ff ff       	call   8010251d <namei>
8010595d:	83 c4 10             	add    $0x10,%esp
80105960:	89 45 f4             	mov    %eax,-0xc(%ebp)
80105963:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80105967:	75 0f                	jne    80105978 <sys_open+0x9c>
      end_op();
80105969:	e8 5a d7 ff ff       	call   801030c8 <end_op>
      return -1;
8010596e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105973:	e9 ff 00 00 00       	jmp    80105a77 <sys_open+0x19b>
    }
    ilock(ip);
80105978:	83 ec 0c             	sub    $0xc,%esp
8010597b:	ff 75 f4             	push   -0xc(%ebp)
8010597e:	e8 67 c0 ff ff       	call   801019ea <ilock>
80105983:	83 c4 10             	add    $0x10,%esp
    if(ip->type == T_DIR && omode != O_RDONLY){
80105986:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105989:	0f b7 40 50          	movzwl 0x50(%eax),%eax
8010598d:	66 83 f8 01          	cmp    $0x1,%ax
80105991:	75 24                	jne    801059b7 <sys_open+0xdb>
80105993:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80105996:	85 c0                	test   %eax,%eax
80105998:	74 1d                	je     801059b7 <sys_open+0xdb>
      iunlockput(ip);
8010599a:	83 ec 0c             	sub    $0xc,%esp
8010599d:	ff 75 f4             	push   -0xc(%ebp)
801059a0:	e8 76 c2 ff ff       	call   80101c1b <iunlockput>
801059a5:	83 c4 10             	add    $0x10,%esp
      end_op();
801059a8:	e8 1b d7 ff ff       	call   801030c8 <end_op>
      return -1;
801059ad:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801059b2:	e9 c0 00 00 00       	jmp    80105a77 <sys_open+0x19b>
    }
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
801059b7:	e8 21 b6 ff ff       	call   80100fdd <filealloc>
801059bc:	89 45 f0             	mov    %eax,-0x10(%ebp)
801059bf:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
801059c3:	74 17                	je     801059dc <sys_open+0x100>
801059c5:	83 ec 0c             	sub    $0xc,%esp
801059c8:	ff 75 f0             	push   -0x10(%ebp)
801059cb:	e8 33 f7 ff ff       	call   80105103 <fdalloc>
801059d0:	83 c4 10             	add    $0x10,%esp
801059d3:	89 45 ec             	mov    %eax,-0x14(%ebp)
801059d6:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
801059da:	79 2e                	jns    80105a0a <sys_open+0x12e>
    if(f)
801059dc:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
801059e0:	74 0e                	je     801059f0 <sys_open+0x114>
      fileclose(f);
801059e2:	83 ec 0c             	sub    $0xc,%esp
801059e5:	ff 75 f0             	push   -0x10(%ebp)
801059e8:	e8 ae b6 ff ff       	call   8010109b <fileclose>
801059ed:	83 c4 10             	add    $0x10,%esp
    iunlockput(ip);
801059f0:	83 ec 0c             	sub    $0xc,%esp
801059f3:	ff 75 f4             	push   -0xc(%ebp)
801059f6:	e8 20 c2 ff ff       	call   80101c1b <iunlockput>
801059fb:	83 c4 10             	add    $0x10,%esp
    end_op();
801059fe:	e8 c5 d6 ff ff       	call   801030c8 <end_op>
    return -1;
80105a03:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105a08:	eb 6d                	jmp    80105a77 <sys_open+0x19b>
  }
  iunlock(ip);
80105a0a:	83 ec 0c             	sub    $0xc,%esp
80105a0d:	ff 75 f4             	push   -0xc(%ebp)
80105a10:	e8 e8 c0 ff ff       	call   80101afd <iunlock>
80105a15:	83 c4 10             	add    $0x10,%esp
  end_op();
80105a18:	e8 ab d6 ff ff       	call   801030c8 <end_op>

  f->type = FD_INODE;
80105a1d:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105a20:	c7 00 02 00 00 00    	movl   $0x2,(%eax)
  f->ip = ip;
80105a26:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105a29:	8b 55 f4             	mov    -0xc(%ebp),%edx
80105a2c:	89 50 10             	mov    %edx,0x10(%eax)
  f->off = 0;
80105a2f:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105a32:	c7 40 14 00 00 00 00 	movl   $0x0,0x14(%eax)
  f->readable = !(omode & O_WRONLY);
80105a39:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80105a3c:	83 e0 01             	and    $0x1,%eax
80105a3f:	85 c0                	test   %eax,%eax
80105a41:	0f 94 c0             	sete   %al
80105a44:	89 c2                	mov    %eax,%edx
80105a46:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105a49:	88 50 08             	mov    %dl,0x8(%eax)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
80105a4c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80105a4f:	83 e0 01             	and    $0x1,%eax
80105a52:	85 c0                	test   %eax,%eax
80105a54:	75 0a                	jne    80105a60 <sys_open+0x184>
80105a56:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80105a59:	83 e0 02             	and    $0x2,%eax
80105a5c:	85 c0                	test   %eax,%eax
80105a5e:	74 07                	je     80105a67 <sys_open+0x18b>
80105a60:	b8 01 00 00 00       	mov    $0x1,%eax
80105a65:	eb 05                	jmp    80105a6c <sys_open+0x190>
80105a67:	b8 00 00 00 00       	mov    $0x0,%eax
80105a6c:	89 c2                	mov    %eax,%edx
80105a6e:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105a71:	88 50 09             	mov    %dl,0x9(%eax)
  return fd;
80105a74:	8b 45 ec             	mov    -0x14(%ebp),%eax
}
80105a77:	c9                   	leave  
80105a78:	c3                   	ret    

80105a79 <sys_mkdir>:

int
sys_mkdir(void)
{
80105a79:	55                   	push   %ebp
80105a7a:	89 e5                	mov    %esp,%ebp
80105a7c:	83 ec 18             	sub    $0x18,%esp
  char *path;
  struct inode *ip;

  begin_op();
80105a7f:	e8 b8 d5 ff ff       	call   8010303c <begin_op>
  if(argstr(0, &path) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
80105a84:	83 ec 08             	sub    $0x8,%esp
80105a87:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105a8a:	50                   	push   %eax
80105a8b:	6a 00                	push   $0x0
80105a8d:	e8 48 f5 ff ff       	call   80104fda <argstr>
80105a92:	83 c4 10             	add    $0x10,%esp
80105a95:	85 c0                	test   %eax,%eax
80105a97:	78 1b                	js     80105ab4 <sys_mkdir+0x3b>
80105a99:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105a9c:	6a 00                	push   $0x0
80105a9e:	6a 00                	push   $0x0
80105aa0:	6a 01                	push   $0x1
80105aa2:	50                   	push   %eax
80105aa3:	e8 62 fc ff ff       	call   8010570a <create>
80105aa8:	83 c4 10             	add    $0x10,%esp
80105aab:	89 45 f4             	mov    %eax,-0xc(%ebp)
80105aae:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80105ab2:	75 0c                	jne    80105ac0 <sys_mkdir+0x47>
    end_op();
80105ab4:	e8 0f d6 ff ff       	call   801030c8 <end_op>
    return -1;
80105ab9:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105abe:	eb 18                	jmp    80105ad8 <sys_mkdir+0x5f>
  }
  iunlockput(ip);
80105ac0:	83 ec 0c             	sub    $0xc,%esp
80105ac3:	ff 75 f4             	push   -0xc(%ebp)
80105ac6:	e8 50 c1 ff ff       	call   80101c1b <iunlockput>
80105acb:	83 c4 10             	add    $0x10,%esp
  end_op();
80105ace:	e8 f5 d5 ff ff       	call   801030c8 <end_op>
  return 0;
80105ad3:	b8 00 00 00 00       	mov    $0x0,%eax
}
80105ad8:	c9                   	leave  
80105ad9:	c3                   	ret    

80105ada <sys_mknod>:

int
sys_mknod(void)
{
80105ada:	55                   	push   %ebp
80105adb:	89 e5                	mov    %esp,%ebp
80105add:	83 ec 18             	sub    $0x18,%esp
  struct inode *ip;
  char *path;
  int major, minor;

  begin_op();
80105ae0:	e8 57 d5 ff ff       	call   8010303c <begin_op>
  if((argstr(0, &path)) < 0 ||
80105ae5:	83 ec 08             	sub    $0x8,%esp
80105ae8:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105aeb:	50                   	push   %eax
80105aec:	6a 00                	push   $0x0
80105aee:	e8 e7 f4 ff ff       	call   80104fda <argstr>
80105af3:	83 c4 10             	add    $0x10,%esp
80105af6:	85 c0                	test   %eax,%eax
80105af8:	78 4f                	js     80105b49 <sys_mknod+0x6f>
     argint(1, &major) < 0 ||
80105afa:	83 ec 08             	sub    $0x8,%esp
80105afd:	8d 45 ec             	lea    -0x14(%ebp),%eax
80105b00:	50                   	push   %eax
80105b01:	6a 01                	push   $0x1
80105b03:	e8 3d f4 ff ff       	call   80104f45 <argint>
80105b08:	83 c4 10             	add    $0x10,%esp
  if((argstr(0, &path)) < 0 ||
80105b0b:	85 c0                	test   %eax,%eax
80105b0d:	78 3a                	js     80105b49 <sys_mknod+0x6f>
     argint(2, &minor) < 0 ||
80105b0f:	83 ec 08             	sub    $0x8,%esp
80105b12:	8d 45 e8             	lea    -0x18(%ebp),%eax
80105b15:	50                   	push   %eax
80105b16:	6a 02                	push   $0x2
80105b18:	e8 28 f4 ff ff       	call   80104f45 <argint>
80105b1d:	83 c4 10             	add    $0x10,%esp
     argint(1, &major) < 0 ||
80105b20:	85 c0                	test   %eax,%eax
80105b22:	78 25                	js     80105b49 <sys_mknod+0x6f>
     (ip = create(path, T_DEV, major, minor)) == 0){
80105b24:	8b 45 e8             	mov    -0x18(%ebp),%eax
80105b27:	0f bf c8             	movswl %ax,%ecx
80105b2a:	8b 45 ec             	mov    -0x14(%ebp),%eax
80105b2d:	0f bf d0             	movswl %ax,%edx
80105b30:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105b33:	51                   	push   %ecx
80105b34:	52                   	push   %edx
80105b35:	6a 03                	push   $0x3
80105b37:	50                   	push   %eax
80105b38:	e8 cd fb ff ff       	call   8010570a <create>
80105b3d:	83 c4 10             	add    $0x10,%esp
80105b40:	89 45 f4             	mov    %eax,-0xc(%ebp)
     argint(2, &minor) < 0 ||
80105b43:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80105b47:	75 0c                	jne    80105b55 <sys_mknod+0x7b>
    end_op();
80105b49:	e8 7a d5 ff ff       	call   801030c8 <end_op>
    return -1;
80105b4e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105b53:	eb 18                	jmp    80105b6d <sys_mknod+0x93>
  }
  iunlockput(ip);
80105b55:	83 ec 0c             	sub    $0xc,%esp
80105b58:	ff 75 f4             	push   -0xc(%ebp)
80105b5b:	e8 bb c0 ff ff       	call   80101c1b <iunlockput>
80105b60:	83 c4 10             	add    $0x10,%esp
  end_op();
80105b63:	e8 60 d5 ff ff       	call   801030c8 <end_op>
  return 0;
80105b68:	b8 00 00 00 00       	mov    $0x0,%eax
}
80105b6d:	c9                   	leave  
80105b6e:	c3                   	ret    

80105b6f <sys_chdir>:

int
sys_chdir(void)
{
80105b6f:	55                   	push   %ebp
80105b70:	89 e5                	mov    %esp,%ebp
80105b72:	83 ec 18             	sub    $0x18,%esp
  char *path;
  struct inode *ip;
  struct proc *curproc = myproc();
80105b75:	e8 b6 de ff ff       	call   80103a30 <myproc>
80105b7a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  
  begin_op();
80105b7d:	e8 ba d4 ff ff       	call   8010303c <begin_op>
  if(argstr(0, &path) < 0 || (ip = namei(path)) == 0){
80105b82:	83 ec 08             	sub    $0x8,%esp
80105b85:	8d 45 ec             	lea    -0x14(%ebp),%eax
80105b88:	50                   	push   %eax
80105b89:	6a 00                	push   $0x0
80105b8b:	e8 4a f4 ff ff       	call   80104fda <argstr>
80105b90:	83 c4 10             	add    $0x10,%esp
80105b93:	85 c0                	test   %eax,%eax
80105b95:	78 18                	js     80105baf <sys_chdir+0x40>
80105b97:	8b 45 ec             	mov    -0x14(%ebp),%eax
80105b9a:	83 ec 0c             	sub    $0xc,%esp
80105b9d:	50                   	push   %eax
80105b9e:	e8 7a c9 ff ff       	call   8010251d <namei>
80105ba3:	83 c4 10             	add    $0x10,%esp
80105ba6:	89 45 f0             	mov    %eax,-0x10(%ebp)
80105ba9:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80105bad:	75 0c                	jne    80105bbb <sys_chdir+0x4c>
    end_op();
80105baf:	e8 14 d5 ff ff       	call   801030c8 <end_op>
    return -1;
80105bb4:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105bb9:	eb 68                	jmp    80105c23 <sys_chdir+0xb4>
  }
  ilock(ip);
80105bbb:	83 ec 0c             	sub    $0xc,%esp
80105bbe:	ff 75 f0             	push   -0x10(%ebp)
80105bc1:	e8 24 be ff ff       	call   801019ea <ilock>
80105bc6:	83 c4 10             	add    $0x10,%esp
  if(ip->type != T_DIR){
80105bc9:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105bcc:	0f b7 40 50          	movzwl 0x50(%eax),%eax
80105bd0:	66 83 f8 01          	cmp    $0x1,%ax
80105bd4:	74 1a                	je     80105bf0 <sys_chdir+0x81>
    iunlockput(ip);
80105bd6:	83 ec 0c             	sub    $0xc,%esp
80105bd9:	ff 75 f0             	push   -0x10(%ebp)
80105bdc:	e8 3a c0 ff ff       	call   80101c1b <iunlockput>
80105be1:	83 c4 10             	add    $0x10,%esp
    end_op();
80105be4:	e8 df d4 ff ff       	call   801030c8 <end_op>
    return -1;
80105be9:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105bee:	eb 33                	jmp    80105c23 <sys_chdir+0xb4>
  }
  iunlock(ip);
80105bf0:	83 ec 0c             	sub    $0xc,%esp
80105bf3:	ff 75 f0             	push   -0x10(%ebp)
80105bf6:	e8 02 bf ff ff       	call   80101afd <iunlock>
80105bfb:	83 c4 10             	add    $0x10,%esp
  iput(curproc->cwd);
80105bfe:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105c01:	8b 40 68             	mov    0x68(%eax),%eax
80105c04:	83 ec 0c             	sub    $0xc,%esp
80105c07:	50                   	push   %eax
80105c08:	e8 3e bf ff ff       	call   80101b4b <iput>
80105c0d:	83 c4 10             	add    $0x10,%esp
  end_op();
80105c10:	e8 b3 d4 ff ff       	call   801030c8 <end_op>
  curproc->cwd = ip;
80105c15:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105c18:	8b 55 f0             	mov    -0x10(%ebp),%edx
80105c1b:	89 50 68             	mov    %edx,0x68(%eax)
  return 0;
80105c1e:	b8 00 00 00 00       	mov    $0x0,%eax
}
80105c23:	c9                   	leave  
80105c24:	c3                   	ret    

80105c25 <sys_exec>:

int
sys_exec(void)
{
80105c25:	55                   	push   %ebp
80105c26:	89 e5                	mov    %esp,%ebp
80105c28:	81 ec 98 00 00 00    	sub    $0x98,%esp
  char *path, *argv[MAXARG];
  int i;
  uint uargv, uarg;

  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
80105c2e:	83 ec 08             	sub    $0x8,%esp
80105c31:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105c34:	50                   	push   %eax
80105c35:	6a 00                	push   $0x0
80105c37:	e8 9e f3 ff ff       	call   80104fda <argstr>
80105c3c:	83 c4 10             	add    $0x10,%esp
80105c3f:	85 c0                	test   %eax,%eax
80105c41:	78 18                	js     80105c5b <sys_exec+0x36>
80105c43:	83 ec 08             	sub    $0x8,%esp
80105c46:	8d 85 6c ff ff ff    	lea    -0x94(%ebp),%eax
80105c4c:	50                   	push   %eax
80105c4d:	6a 01                	push   $0x1
80105c4f:	e8 f1 f2 ff ff       	call   80104f45 <argint>
80105c54:	83 c4 10             	add    $0x10,%esp
80105c57:	85 c0                	test   %eax,%eax
80105c59:	79 0a                	jns    80105c65 <sys_exec+0x40>
    return -1;
80105c5b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105c60:	e9 c6 00 00 00       	jmp    80105d2b <sys_exec+0x106>
  }
  memset(argv, 0, sizeof(argv));
80105c65:	83 ec 04             	sub    $0x4,%esp
80105c68:	68 80 00 00 00       	push   $0x80
80105c6d:	6a 00                	push   $0x0
80105c6f:	8d 85 70 ff ff ff    	lea    -0x90(%ebp),%eax
80105c75:	50                   	push   %eax
80105c76:	e8 9f ef ff ff       	call   80104c1a <memset>
80105c7b:	83 c4 10             	add    $0x10,%esp
  for(i=0;; i++){
80105c7e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    if(i >= NELEM(argv))
80105c85:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105c88:	83 f8 1f             	cmp    $0x1f,%eax
80105c8b:	76 0a                	jbe    80105c97 <sys_exec+0x72>
      return -1;
80105c8d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105c92:	e9 94 00 00 00       	jmp    80105d2b <sys_exec+0x106>
    if(fetchint(uargv+4*i, (int*)&uarg) < 0)
80105c97:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105c9a:	c1 e0 02             	shl    $0x2,%eax
80105c9d:	89 c2                	mov    %eax,%edx
80105c9f:	8b 85 6c ff ff ff    	mov    -0x94(%ebp),%eax
80105ca5:	01 c2                	add    %eax,%edx
80105ca7:	83 ec 08             	sub    $0x8,%esp
80105caa:	8d 85 68 ff ff ff    	lea    -0x98(%ebp),%eax
80105cb0:	50                   	push   %eax
80105cb1:	52                   	push   %edx
80105cb2:	e8 ed f1 ff ff       	call   80104ea4 <fetchint>
80105cb7:	83 c4 10             	add    $0x10,%esp
80105cba:	85 c0                	test   %eax,%eax
80105cbc:	79 07                	jns    80105cc5 <sys_exec+0xa0>
      return -1;
80105cbe:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105cc3:	eb 66                	jmp    80105d2b <sys_exec+0x106>
    if(uarg == 0){
80105cc5:	8b 85 68 ff ff ff    	mov    -0x98(%ebp),%eax
80105ccb:	85 c0                	test   %eax,%eax
80105ccd:	75 27                	jne    80105cf6 <sys_exec+0xd1>
      argv[i] = 0;
80105ccf:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105cd2:	c7 84 85 70 ff ff ff 	movl   $0x0,-0x90(%ebp,%eax,4)
80105cd9:	00 00 00 00 
      break;
80105cdd:	90                   	nop
    }
    if(fetchstr(uarg, &argv[i]) < 0)
      return -1;
  }
  return exec(path, argv);
80105cde:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105ce1:	83 ec 08             	sub    $0x8,%esp
80105ce4:	8d 95 70 ff ff ff    	lea    -0x90(%ebp),%edx
80105cea:	52                   	push   %edx
80105ceb:	50                   	push   %eax
80105cec:	e8 8f ae ff ff       	call   80100b80 <exec>
80105cf1:	83 c4 10             	add    $0x10,%esp
80105cf4:	eb 35                	jmp    80105d2b <sys_exec+0x106>
    if(fetchstr(uarg, &argv[i]) < 0)
80105cf6:	8d 95 70 ff ff ff    	lea    -0x90(%ebp),%edx
80105cfc:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105cff:	c1 e0 02             	shl    $0x2,%eax
80105d02:	01 c2                	add    %eax,%edx
80105d04:	8b 85 68 ff ff ff    	mov    -0x98(%ebp),%eax
80105d0a:	83 ec 08             	sub    $0x8,%esp
80105d0d:	52                   	push   %edx
80105d0e:	50                   	push   %eax
80105d0f:	e8 cf f1 ff ff       	call   80104ee3 <fetchstr>
80105d14:	83 c4 10             	add    $0x10,%esp
80105d17:	85 c0                	test   %eax,%eax
80105d19:	79 07                	jns    80105d22 <sys_exec+0xfd>
      return -1;
80105d1b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105d20:	eb 09                	jmp    80105d2b <sys_exec+0x106>
  for(i=0;; i++){
80105d22:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
    if(i >= NELEM(argv))
80105d26:	e9 5a ff ff ff       	jmp    80105c85 <sys_exec+0x60>
}
80105d2b:	c9                   	leave  
80105d2c:	c3                   	ret    

80105d2d <sys_pipe>:

int
sys_pipe(void)
{
80105d2d:	55                   	push   %ebp
80105d2e:	89 e5                	mov    %esp,%ebp
80105d30:	83 ec 28             	sub    $0x28,%esp
  int *fd;
  struct file *rf, *wf;
  int fd0, fd1;

  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
80105d33:	83 ec 04             	sub    $0x4,%esp
80105d36:	6a 08                	push   $0x8
80105d38:	8d 45 ec             	lea    -0x14(%ebp),%eax
80105d3b:	50                   	push   %eax
80105d3c:	6a 00                	push   $0x0
80105d3e:	e8 2f f2 ff ff       	call   80104f72 <argptr>
80105d43:	83 c4 10             	add    $0x10,%esp
80105d46:	85 c0                	test   %eax,%eax
80105d48:	79 0a                	jns    80105d54 <sys_pipe+0x27>
    return -1;
80105d4a:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105d4f:	e9 ae 00 00 00       	jmp    80105e02 <sys_pipe+0xd5>
  if(pipealloc(&rf, &wf) < 0)
80105d54:	83 ec 08             	sub    $0x8,%esp
80105d57:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80105d5a:	50                   	push   %eax
80105d5b:	8d 45 e8             	lea    -0x18(%ebp),%eax
80105d5e:	50                   	push   %eax
80105d5f:	e8 09 d8 ff ff       	call   8010356d <pipealloc>
80105d64:	83 c4 10             	add    $0x10,%esp
80105d67:	85 c0                	test   %eax,%eax
80105d69:	79 0a                	jns    80105d75 <sys_pipe+0x48>
    return -1;
80105d6b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105d70:	e9 8d 00 00 00       	jmp    80105e02 <sys_pipe+0xd5>
  fd0 = -1;
80105d75:	c7 45 f4 ff ff ff ff 	movl   $0xffffffff,-0xc(%ebp)
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
80105d7c:	8b 45 e8             	mov    -0x18(%ebp),%eax
80105d7f:	83 ec 0c             	sub    $0xc,%esp
80105d82:	50                   	push   %eax
80105d83:	e8 7b f3 ff ff       	call   80105103 <fdalloc>
80105d88:	83 c4 10             	add    $0x10,%esp
80105d8b:	89 45 f4             	mov    %eax,-0xc(%ebp)
80105d8e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80105d92:	78 18                	js     80105dac <sys_pipe+0x7f>
80105d94:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80105d97:	83 ec 0c             	sub    $0xc,%esp
80105d9a:	50                   	push   %eax
80105d9b:	e8 63 f3 ff ff       	call   80105103 <fdalloc>
80105da0:	83 c4 10             	add    $0x10,%esp
80105da3:	89 45 f0             	mov    %eax,-0x10(%ebp)
80105da6:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80105daa:	79 3e                	jns    80105dea <sys_pipe+0xbd>
    if(fd0 >= 0)
80105dac:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80105db0:	78 13                	js     80105dc5 <sys_pipe+0x98>
      myproc()->ofile[fd0] = 0;
80105db2:	e8 79 dc ff ff       	call   80103a30 <myproc>
80105db7:	8b 55 f4             	mov    -0xc(%ebp),%edx
80105dba:	83 c2 08             	add    $0x8,%edx
80105dbd:	c7 44 90 08 00 00 00 	movl   $0x0,0x8(%eax,%edx,4)
80105dc4:	00 
    fileclose(rf);
80105dc5:	8b 45 e8             	mov    -0x18(%ebp),%eax
80105dc8:	83 ec 0c             	sub    $0xc,%esp
80105dcb:	50                   	push   %eax
80105dcc:	e8 ca b2 ff ff       	call   8010109b <fileclose>
80105dd1:	83 c4 10             	add    $0x10,%esp
    fileclose(wf);
80105dd4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80105dd7:	83 ec 0c             	sub    $0xc,%esp
80105dda:	50                   	push   %eax
80105ddb:	e8 bb b2 ff ff       	call   8010109b <fileclose>
80105de0:	83 c4 10             	add    $0x10,%esp
    return -1;
80105de3:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105de8:	eb 18                	jmp    80105e02 <sys_pipe+0xd5>
  }
  fd[0] = fd0;
80105dea:	8b 45 ec             	mov    -0x14(%ebp),%eax
80105ded:	8b 55 f4             	mov    -0xc(%ebp),%edx
80105df0:	89 10                	mov    %edx,(%eax)
  fd[1] = fd1;
80105df2:	8b 45 ec             	mov    -0x14(%ebp),%eax
80105df5:	8d 50 04             	lea    0x4(%eax),%edx
80105df8:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105dfb:	89 02                	mov    %eax,(%edx)
  return 0;
80105dfd:	b8 00 00 00 00       	mov    $0x0,%eax
}
80105e02:	c9                   	leave  
80105e03:	c3                   	ret    

80105e04 <sys_fork>:
#include "spinlock.h"
#include "debug.h"

int
sys_fork(void)
{
80105e04:	55                   	push   %ebp
80105e05:	89 e5                	mov    %esp,%ebp
80105e07:	83 ec 08             	sub    $0x8,%esp
  return fork();
80105e0a:	e8 23 df ff ff       	call   80103d32 <fork>
}
80105e0f:	c9                   	leave  
80105e10:	c3                   	ret    

80105e11 <sys_exit>:

int
sys_exit(void)
{
80105e11:	55                   	push   %ebp
80105e12:	89 e5                	mov    %esp,%ebp
80105e14:	83 ec 08             	sub    $0x8,%esp
  exit();
80105e17:	e8 8f e0 ff ff       	call   80103eab <exit>
  return 0;  // not reached
80105e1c:	b8 00 00 00 00       	mov    $0x0,%eax
}
80105e21:	c9                   	leave  
80105e22:	c3                   	ret    

80105e23 <sys_uthread_init>:

int sys_uthread_init(void) {
80105e23:	55                   	push   %ebp
80105e24:	89 e5                	mov    %esp,%ebp
80105e26:	83 ec 18             	sub    $0x18,%esp
  int address;
  //0번째 파라미터로 준 값을 &address에 저장.  유효값 아니라면 리턴 -1
  if (argint(0, &address) < 0){
80105e29:	83 ec 08             	sub    $0x8,%esp
80105e2c:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105e2f:	50                   	push   %eax
80105e30:	6a 00                	push   $0x0
80105e32:	e8 0e f1 ff ff       	call   80104f45 <argint>
80105e37:	83 c4 10             	add    $0x10,%esp
80105e3a:	85 c0                	test   %eax,%eax
80105e3c:	79 07                	jns    80105e45 <sys_uthread_init+0x22>
	  return -1;
80105e3e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105e43:	eb 0f                	jmp    80105e54 <sys_uthread_init+0x31>
  }
  return uthread_init(address);
80105e45:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105e48:	83 ec 0c             	sub    $0xc,%esp
80105e4b:	50                   	push   %eax
80105e4c:	e8 7d e1 ff ff       	call   80103fce <uthread_init>
80105e51:	83 c4 10             	add    $0x10,%esp
}
80105e54:	c9                   	leave  
80105e55:	c3                   	ret    

80105e56 <sys_exit2>:

int
sys_exit2(void) 
{
80105e56:	55                   	push   %ebp
80105e57:	89 e5                	mov    %esp,%ebp
80105e59:	83 ec 18             	sub    $0x18,%esp
  int status;

  //첫번쨰 파라미터로 준 값을 &status에 입력한다.
  //유효값 아니라면 리턴 -1
  if (argint(0, &status) < 0)
80105e5c:	83 ec 08             	sub    $0x8,%esp
80105e5f:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105e62:	50                   	push   %eax
80105e63:	6a 00                	push   $0x0
80105e65:	e8 db f0 ff ff       	call   80104f45 <argint>
80105e6a:	83 c4 10             	add    $0x10,%esp
80105e6d:	85 c0                	test   %eax,%eax
80105e6f:	79 07                	jns    80105e78 <sys_exit2+0x22>
	  return -1;
80105e71:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105e76:	eb 12                	jmp    80105e8a <sys_exit2+0x34>
   
  exit2(status); 
80105e78:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105e7b:	83 ec 0c             	sub    $0xc,%esp
80105e7e:	50                   	push   %eax
80105e7f:	e8 6b e1 ff ff       	call   80103fef <exit2>
80105e84:	83 c4 10             	add    $0x10,%esp
  //return 0; //eax에 리턴해야하니까
  return status; //eax에 리턴해야하니까
80105e87:	8b 45 f4             	mov    -0xc(%ebp),%eax
}  
80105e8a:	c9                   	leave  
80105e8b:	c3                   	ret    

80105e8c <sys_wait>:

int
sys_wait(void)
{
80105e8c:	55                   	push   %ebp
80105e8d:	89 e5                	mov    %esp,%ebp
80105e8f:	83 ec 08             	sub    $0x8,%esp
  return wait();
80105e92:	e8 87 e2 ff ff       	call   8010411e <wait>
}
80105e97:	c9                   	leave  
80105e98:	c3                   	ret    

80105e99 <sys_wait2>:
//*********new sys_waiat**********
//********************************

int
sys_wait2(void)
{
80105e99:	55                   	push   %ebp
80105e9a:	89 e5                	mov    %esp,%ebp
80105e9c:	83 ec 18             	sub    $0x18,%esp

  int status;
  //포인터 값 복사, 유효값 아니라면 리턴 -1
  if(argptr(0, (char **)&status, sizeof(int)) < 0)
80105e9f:	83 ec 04             	sub    $0x4,%esp
80105ea2:	6a 04                	push   $0x4
80105ea4:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105ea7:	50                   	push   %eax
80105ea8:	6a 00                	push   $0x0
80105eaa:	e8 c3 f0 ff ff       	call   80104f72 <argptr>
80105eaf:	83 c4 10             	add    $0x10,%esp
80105eb2:	85 c0                	test   %eax,%eax
80105eb4:	79 07                	jns    80105ebd <sys_wait2+0x24>
    return -1;
80105eb6:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105ebb:	eb 0f                	jmp    80105ecc <sys_wait2+0x33>

  //유효값이면 wait2 실행
  return wait2(&status);
80105ebd:	83 ec 0c             	sub    $0xc,%esp
80105ec0:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105ec3:	50                   	push   %eax
80105ec4:	e8 78 e3 ff ff       	call   80104241 <wait2>
80105ec9:	83 c4 10             	add    $0x10,%esp

}
80105ecc:	c9                   	leave  
80105ecd:	c3                   	ret    

80105ece <sys_kill>:
//********************************


int
sys_kill(void)
{
80105ece:	55                   	push   %ebp
80105ecf:	89 e5                	mov    %esp,%ebp
80105ed1:	83 ec 18             	sub    $0x18,%esp
  int pid;

  if(argint(0, &pid) < 0)
80105ed4:	83 ec 08             	sub    $0x8,%esp
80105ed7:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105eda:	50                   	push   %eax
80105edb:	6a 00                	push   $0x0
80105edd:	e8 63 f0 ff ff       	call   80104f45 <argint>
80105ee2:	83 c4 10             	add    $0x10,%esp
80105ee5:	85 c0                	test   %eax,%eax
80105ee7:	79 07                	jns    80105ef0 <sys_kill+0x22>
    return -1;
80105ee9:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105eee:	eb 0f                	jmp    80105eff <sys_kill+0x31>
  return kill(pid);
80105ef0:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105ef3:	83 ec 0c             	sub    $0xc,%esp
80105ef6:	50                   	push   %eax
80105ef7:	e8 a5 e7 ff ff       	call   801046a1 <kill>
80105efc:	83 c4 10             	add    $0x10,%esp
}
80105eff:	c9                   	leave  
80105f00:	c3                   	ret    

80105f01 <sys_getpid>:

int
sys_getpid(void)
{
80105f01:	55                   	push   %ebp
80105f02:	89 e5                	mov    %esp,%ebp
80105f04:	83 ec 08             	sub    $0x8,%esp
  return myproc()->pid;
80105f07:	e8 24 db ff ff       	call   80103a30 <myproc>
80105f0c:	8b 40 10             	mov    0x10(%eax),%eax
}
80105f0f:	c9                   	leave  
80105f10:	c3                   	ret    

80105f11 <sys_sbrk>:

int
sys_sbrk(void)
{
80105f11:	55                   	push   %ebp
80105f12:	89 e5                	mov    %esp,%ebp
80105f14:	83 ec 18             	sub    $0x18,%esp
  int addr;
  int n;

  if(argint(0, &n) < 0)
80105f17:	83 ec 08             	sub    $0x8,%esp
80105f1a:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105f1d:	50                   	push   %eax
80105f1e:	6a 00                	push   $0x0
80105f20:	e8 20 f0 ff ff       	call   80104f45 <argint>
80105f25:	83 c4 10             	add    $0x10,%esp
80105f28:	85 c0                	test   %eax,%eax
80105f2a:	79 07                	jns    80105f33 <sys_sbrk+0x22>
    return -1;
80105f2c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105f31:	eb 27                	jmp    80105f5a <sys_sbrk+0x49>
  addr = myproc()->sz;
80105f33:	e8 f8 da ff ff       	call   80103a30 <myproc>
80105f38:	8b 00                	mov    (%eax),%eax
80105f3a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(growproc(n) < 0)
80105f3d:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105f40:	83 ec 0c             	sub    $0xc,%esp
80105f43:	50                   	push   %eax
80105f44:	e8 4e dd ff ff       	call   80103c97 <growproc>
80105f49:	83 c4 10             	add    $0x10,%esp
80105f4c:	85 c0                	test   %eax,%eax
80105f4e:	79 07                	jns    80105f57 <sys_sbrk+0x46>
    return -1;
80105f50:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105f55:	eb 03                	jmp    80105f5a <sys_sbrk+0x49>
  return addr;
80105f57:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
80105f5a:	c9                   	leave  
80105f5b:	c3                   	ret    

80105f5c <sys_sleep>:

int
sys_sleep(void)
{
80105f5c:	55                   	push   %ebp
80105f5d:	89 e5                	mov    %esp,%ebp
80105f5f:	83 ec 18             	sub    $0x18,%esp
  int n;
  uint ticks0;

  if(argint(0, &n) < 0)
80105f62:	83 ec 08             	sub    $0x8,%esp
80105f65:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105f68:	50                   	push   %eax
80105f69:	6a 00                	push   $0x0
80105f6b:	e8 d5 ef ff ff       	call   80104f45 <argint>
80105f70:	83 c4 10             	add    $0x10,%esp
80105f73:	85 c0                	test   %eax,%eax
80105f75:	79 07                	jns    80105f7e <sys_sleep+0x22>
    return -1;
80105f77:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105f7c:	eb 76                	jmp    80105ff4 <sys_sleep+0x98>
  acquire(&tickslock);
80105f7e:	83 ec 0c             	sub    $0xc,%esp
80105f81:	68 40 6b 19 80       	push   $0x80196b40
80105f86:	e8 19 ea ff ff       	call   801049a4 <acquire>
80105f8b:	83 c4 10             	add    $0x10,%esp
  ticks0 = ticks;
80105f8e:	a1 74 6b 19 80       	mov    0x80196b74,%eax
80105f93:	89 45 f4             	mov    %eax,-0xc(%ebp)
  while(ticks - ticks0 < n){
80105f96:	eb 38                	jmp    80105fd0 <sys_sleep+0x74>
    if(myproc()->killed){
80105f98:	e8 93 da ff ff       	call   80103a30 <myproc>
80105f9d:	8b 40 24             	mov    0x24(%eax),%eax
80105fa0:	85 c0                	test   %eax,%eax
80105fa2:	74 17                	je     80105fbb <sys_sleep+0x5f>
      release(&tickslock);
80105fa4:	83 ec 0c             	sub    $0xc,%esp
80105fa7:	68 40 6b 19 80       	push   $0x80196b40
80105fac:	e8 61 ea ff ff       	call   80104a12 <release>
80105fb1:	83 c4 10             	add    $0x10,%esp
      return -1;
80105fb4:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105fb9:	eb 39                	jmp    80105ff4 <sys_sleep+0x98>
    }
    sleep(&ticks, &tickslock);
80105fbb:	83 ec 08             	sub    $0x8,%esp
80105fbe:	68 40 6b 19 80       	push   $0x80196b40
80105fc3:	68 74 6b 19 80       	push   $0x80196b74
80105fc8:	e8 b3 e5 ff ff       	call   80104580 <sleep>
80105fcd:	83 c4 10             	add    $0x10,%esp
  while(ticks - ticks0 < n){
80105fd0:	a1 74 6b 19 80       	mov    0x80196b74,%eax
80105fd5:	2b 45 f4             	sub    -0xc(%ebp),%eax
80105fd8:	8b 55 f0             	mov    -0x10(%ebp),%edx
80105fdb:	39 d0                	cmp    %edx,%eax
80105fdd:	72 b9                	jb     80105f98 <sys_sleep+0x3c>
  }
  release(&tickslock);
80105fdf:	83 ec 0c             	sub    $0xc,%esp
80105fe2:	68 40 6b 19 80       	push   $0x80196b40
80105fe7:	e8 26 ea ff ff       	call   80104a12 <release>
80105fec:	83 c4 10             	add    $0x10,%esp
  return 0;
80105fef:	b8 00 00 00 00       	mov    $0x0,%eax
}
80105ff4:	c9                   	leave  
80105ff5:	c3                   	ret    

80105ff6 <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
int
sys_uptime(void)
{
80105ff6:	55                   	push   %ebp
80105ff7:	89 e5                	mov    %esp,%ebp
80105ff9:	83 ec 18             	sub    $0x18,%esp
  uint xticks;

  acquire(&tickslock);
80105ffc:	83 ec 0c             	sub    $0xc,%esp
80105fff:	68 40 6b 19 80       	push   $0x80196b40
80106004:	e8 9b e9 ff ff       	call   801049a4 <acquire>
80106009:	83 c4 10             	add    $0x10,%esp
  xticks = ticks;
8010600c:	a1 74 6b 19 80       	mov    0x80196b74,%eax
80106011:	89 45 f4             	mov    %eax,-0xc(%ebp)
  release(&tickslock);
80106014:	83 ec 0c             	sub    $0xc,%esp
80106017:	68 40 6b 19 80       	push   $0x80196b40
8010601c:	e8 f1 e9 ff ff       	call   80104a12 <release>
80106021:	83 c4 10             	add    $0x10,%esp
  return xticks;
80106024:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
80106027:	c9                   	leave  
80106028:	c3                   	ret    

80106029 <alltraps>:
80106029:	1e                   	push   %ds
8010602a:	06                   	push   %es
8010602b:	0f a0                	push   %fs
8010602d:	0f a8                	push   %gs
8010602f:	60                   	pusha  
80106030:	66 b8 10 00          	mov    $0x10,%ax
80106034:	8e d8                	mov    %eax,%ds
80106036:	8e c0                	mov    %eax,%es
80106038:	54                   	push   %esp
80106039:	e8 d7 01 00 00       	call   80106215 <trap>
8010603e:	83 c4 04             	add    $0x4,%esp

80106041 <trapret>:
80106041:	61                   	popa   
80106042:	0f a9                	pop    %gs
80106044:	0f a1                	pop    %fs
80106046:	07                   	pop    %es
80106047:	1f                   	pop    %ds
80106048:	83 c4 08             	add    $0x8,%esp
8010604b:	cf                   	iret   

8010604c <lidt>:
{
8010604c:	55                   	push   %ebp
8010604d:	89 e5                	mov    %esp,%ebp
8010604f:	83 ec 10             	sub    $0x10,%esp
  pd[0] = size-1;
80106052:	8b 45 0c             	mov    0xc(%ebp),%eax
80106055:	83 e8 01             	sub    $0x1,%eax
80106058:	66 89 45 fa          	mov    %ax,-0x6(%ebp)
  pd[1] = (uint)p;
8010605c:	8b 45 08             	mov    0x8(%ebp),%eax
8010605f:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  pd[2] = (uint)p >> 16;
80106063:	8b 45 08             	mov    0x8(%ebp),%eax
80106066:	c1 e8 10             	shr    $0x10,%eax
80106069:	66 89 45 fe          	mov    %ax,-0x2(%ebp)
  asm volatile("lidt (%0)" : : "r" (pd));
8010606d:	8d 45 fa             	lea    -0x6(%ebp),%eax
80106070:	0f 01 18             	lidtl  (%eax)
}
80106073:	90                   	nop
80106074:	c9                   	leave  
80106075:	c3                   	ret    

80106076 <rcr2>:

static inline uint
rcr2(void)
{
80106076:	55                   	push   %ebp
80106077:	89 e5                	mov    %esp,%ebp
80106079:	83 ec 10             	sub    $0x10,%esp
  uint val;
  asm volatile("movl %%cr2,%0" : "=r" (val));
8010607c:	0f 20 d0             	mov    %cr2,%eax
8010607f:	89 45 fc             	mov    %eax,-0x4(%ebp)
  return val;
80106082:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
80106085:	c9                   	leave  
80106086:	c3                   	ret    

80106087 <tvinit>:

extern void thread_switch(void); //************** modified

void
tvinit(void)
{
80106087:	55                   	push   %ebp
80106088:	89 e5                	mov    %esp,%ebp
8010608a:	83 ec 18             	sub    $0x18,%esp
  int i;

  for(i = 0; i < 256; i++)
8010608d:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80106094:	e9 c3 00 00 00       	jmp    8010615c <tvinit+0xd5>
    SETGATE(idt[i], 0, SEG_KCODE<<3, vectors[i], 0);
80106099:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010609c:	8b 04 85 84 f0 10 80 	mov    -0x7fef0f7c(,%eax,4),%eax
801060a3:	89 c2                	mov    %eax,%edx
801060a5:	8b 45 f4             	mov    -0xc(%ebp),%eax
801060a8:	66 89 14 c5 40 63 19 	mov    %dx,-0x7fe69cc0(,%eax,8)
801060af:	80 
801060b0:	8b 45 f4             	mov    -0xc(%ebp),%eax
801060b3:	66 c7 04 c5 42 63 19 	movw   $0x8,-0x7fe69cbe(,%eax,8)
801060ba:	80 08 00 
801060bd:	8b 45 f4             	mov    -0xc(%ebp),%eax
801060c0:	0f b6 14 c5 44 63 19 	movzbl -0x7fe69cbc(,%eax,8),%edx
801060c7:	80 
801060c8:	83 e2 e0             	and    $0xffffffe0,%edx
801060cb:	88 14 c5 44 63 19 80 	mov    %dl,-0x7fe69cbc(,%eax,8)
801060d2:	8b 45 f4             	mov    -0xc(%ebp),%eax
801060d5:	0f b6 14 c5 44 63 19 	movzbl -0x7fe69cbc(,%eax,8),%edx
801060dc:	80 
801060dd:	83 e2 1f             	and    $0x1f,%edx
801060e0:	88 14 c5 44 63 19 80 	mov    %dl,-0x7fe69cbc(,%eax,8)
801060e7:	8b 45 f4             	mov    -0xc(%ebp),%eax
801060ea:	0f b6 14 c5 45 63 19 	movzbl -0x7fe69cbb(,%eax,8),%edx
801060f1:	80 
801060f2:	83 e2 f0             	and    $0xfffffff0,%edx
801060f5:	83 ca 0e             	or     $0xe,%edx
801060f8:	88 14 c5 45 63 19 80 	mov    %dl,-0x7fe69cbb(,%eax,8)
801060ff:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106102:	0f b6 14 c5 45 63 19 	movzbl -0x7fe69cbb(,%eax,8),%edx
80106109:	80 
8010610a:	83 e2 ef             	and    $0xffffffef,%edx
8010610d:	88 14 c5 45 63 19 80 	mov    %dl,-0x7fe69cbb(,%eax,8)
80106114:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106117:	0f b6 14 c5 45 63 19 	movzbl -0x7fe69cbb(,%eax,8),%edx
8010611e:	80 
8010611f:	83 e2 9f             	and    $0xffffff9f,%edx
80106122:	88 14 c5 45 63 19 80 	mov    %dl,-0x7fe69cbb(,%eax,8)
80106129:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010612c:	0f b6 14 c5 45 63 19 	movzbl -0x7fe69cbb(,%eax,8),%edx
80106133:	80 
80106134:	83 ca 80             	or     $0xffffff80,%edx
80106137:	88 14 c5 45 63 19 80 	mov    %dl,-0x7fe69cbb(,%eax,8)
8010613e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106141:	8b 04 85 84 f0 10 80 	mov    -0x7fef0f7c(,%eax,4),%eax
80106148:	c1 e8 10             	shr    $0x10,%eax
8010614b:	89 c2                	mov    %eax,%edx
8010614d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106150:	66 89 14 c5 46 63 19 	mov    %dx,-0x7fe69cba(,%eax,8)
80106157:	80 
  for(i = 0; i < 256; i++)
80106158:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
8010615c:	81 7d f4 ff 00 00 00 	cmpl   $0xff,-0xc(%ebp)
80106163:	0f 8e 30 ff ff ff    	jle    80106099 <tvinit+0x12>
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
80106169:	a1 84 f1 10 80       	mov    0x8010f184,%eax
8010616e:	66 a3 40 65 19 80    	mov    %ax,0x80196540
80106174:	66 c7 05 42 65 19 80 	movw   $0x8,0x80196542
8010617b:	08 00 
8010617d:	0f b6 05 44 65 19 80 	movzbl 0x80196544,%eax
80106184:	83 e0 e0             	and    $0xffffffe0,%eax
80106187:	a2 44 65 19 80       	mov    %al,0x80196544
8010618c:	0f b6 05 44 65 19 80 	movzbl 0x80196544,%eax
80106193:	83 e0 1f             	and    $0x1f,%eax
80106196:	a2 44 65 19 80       	mov    %al,0x80196544
8010619b:	0f b6 05 45 65 19 80 	movzbl 0x80196545,%eax
801061a2:	83 c8 0f             	or     $0xf,%eax
801061a5:	a2 45 65 19 80       	mov    %al,0x80196545
801061aa:	0f b6 05 45 65 19 80 	movzbl 0x80196545,%eax
801061b1:	83 e0 ef             	and    $0xffffffef,%eax
801061b4:	a2 45 65 19 80       	mov    %al,0x80196545
801061b9:	0f b6 05 45 65 19 80 	movzbl 0x80196545,%eax
801061c0:	83 c8 60             	or     $0x60,%eax
801061c3:	a2 45 65 19 80       	mov    %al,0x80196545
801061c8:	0f b6 05 45 65 19 80 	movzbl 0x80196545,%eax
801061cf:	83 c8 80             	or     $0xffffff80,%eax
801061d2:	a2 45 65 19 80       	mov    %al,0x80196545
801061d7:	a1 84 f1 10 80       	mov    0x8010f184,%eax
801061dc:	c1 e8 10             	shr    $0x10,%eax
801061df:	66 a3 46 65 19 80    	mov    %ax,0x80196546

  initlock(&tickslock, "time");
801061e5:	83 ec 08             	sub    $0x8,%esp
801061e8:	68 f8 a6 10 80       	push   $0x8010a6f8
801061ed:	68 40 6b 19 80       	push   $0x80196b40
801061f2:	e8 8b e7 ff ff       	call   80104982 <initlock>
801061f7:	83 c4 10             	add    $0x10,%esp
}
801061fa:	90                   	nop
801061fb:	c9                   	leave  
801061fc:	c3                   	ret    

801061fd <idtinit>:

void
idtinit(void)
{
801061fd:	55                   	push   %ebp
801061fe:	89 e5                	mov    %esp,%ebp
  lidt(idt, sizeof(idt));
80106200:	68 00 08 00 00       	push   $0x800
80106205:	68 40 63 19 80       	push   $0x80196340
8010620a:	e8 3d fe ff ff       	call   8010604c <lidt>
8010620f:	83 c4 08             	add    $0x8,%esp
}
80106212:	90                   	nop
80106213:	c9                   	leave  
80106214:	c3                   	ret    

80106215 <trap>:

//PAGEBREAK: 41
void
trap(struct trapframe *tf)
{
80106215:	55                   	push   %ebp
80106216:	89 e5                	mov    %esp,%ebp
80106218:	57                   	push   %edi
80106219:	56                   	push   %esi
8010621a:	53                   	push   %ebx
8010621b:	83 ec 1c             	sub    $0x1c,%esp
  if(tf->trapno == T_SYSCALL){ //시스템 콜 처리
8010621e:	8b 45 08             	mov    0x8(%ebp),%eax
80106221:	8b 40 30             	mov    0x30(%eax),%eax
80106224:	83 f8 40             	cmp    $0x40,%eax
80106227:	75 3b                	jne    80106264 <trap+0x4f>
    if(myproc()->killed)
80106229:	e8 02 d8 ff ff       	call   80103a30 <myproc>
8010622e:	8b 40 24             	mov    0x24(%eax),%eax
80106231:	85 c0                	test   %eax,%eax
80106233:	74 05                	je     8010623a <trap+0x25>
      exit();
80106235:	e8 71 dc ff ff       	call   80103eab <exit>
    myproc()->tf = tf;
8010623a:	e8 f1 d7 ff ff       	call   80103a30 <myproc>
8010623f:	8b 55 08             	mov    0x8(%ebp),%edx
80106242:	89 50 18             	mov    %edx,0x18(%eax)
    syscall(); //usys.S에 정의됨
80106245:	e8 c7 ed ff ff       	call   80105011 <syscall>
    if(myproc()->killed)
8010624a:	e8 e1 d7 ff ff       	call   80103a30 <myproc>
8010624f:	8b 40 24             	mov    0x24(%eax),%eax
80106252:	85 c0                	test   %eax,%eax
80106254:	0f 84 15 02 00 00    	je     8010646f <trap+0x25a>
      exit();
8010625a:	e8 4c dc ff ff       	call   80103eab <exit>
    return;
8010625f:	e9 0b 02 00 00       	jmp    8010646f <trap+0x25a>
  }

  switch(tf->trapno){
80106264:	8b 45 08             	mov    0x8(%ebp),%eax
80106267:	8b 40 30             	mov    0x30(%eax),%eax
8010626a:	83 e8 20             	sub    $0x20,%eax
8010626d:	83 f8 1f             	cmp    $0x1f,%eax
80106270:	0f 87 c4 00 00 00    	ja     8010633a <trap+0x125>
80106276:	8b 04 85 a0 a7 10 80 	mov    -0x7fef5860(,%eax,4),%eax
8010627d:	ff e0                	jmp    *%eax
  case T_IRQ0 + IRQ_TIMER: //*************timer interrupt
    if(cpuid() == 0){
8010627f:	e8 19 d7 ff ff       	call   8010399d <cpuid>
80106284:	85 c0                	test   %eax,%eax
80106286:	75 3d                	jne    801062c5 <trap+0xb0>
      acquire(&tickslock);
80106288:	83 ec 0c             	sub    $0xc,%esp
8010628b:	68 40 6b 19 80       	push   $0x80196b40
80106290:	e8 0f e7 ff ff       	call   801049a4 <acquire>
80106295:	83 c4 10             	add    $0x10,%esp
      ticks++;
80106298:	a1 74 6b 19 80       	mov    0x80196b74,%eax
8010629d:	83 c0 01             	add    $0x1,%eax
801062a0:	a3 74 6b 19 80       	mov    %eax,0x80196b74
      wakeup(&ticks);
801062a5:	83 ec 0c             	sub    $0xc,%esp
801062a8:	68 74 6b 19 80       	push   $0x80196b74
801062ad:	e8 b8 e3 ff ff       	call   8010466a <wakeup>
801062b2:	83 c4 10             	add    $0x10,%esp
      release(&tickslock);
801062b5:	83 ec 0c             	sub    $0xc,%esp
801062b8:	68 40 6b 19 80       	push   $0x80196b40
801062bd:	e8 50 e7 ff ff       	call   80104a12 <release>
801062c2:	83 c4 10             	add    $0x10,%esp
    }
    lapiceoi();
801062c5:	e8 52 c8 ff ff       	call   80102b1c <lapiceoi>
//      void (*func)(void); //함수 포인터 선언
//      func = (void (*)())address; //thread_schedule()의 주소를 함수 포인터에 할당
//    func(); //thread_schedule() 함수 실행
//    }
//******************   new code   ****************
    break;
801062ca:	e9 20 01 00 00       	jmp    801063ef <trap+0x1da>
       
  case T_IRQ0 + IRQ_IDE:
    ideintr();
801062cf:	e8 f5 3e 00 00       	call   8010a1c9 <ideintr>
    lapiceoi();
801062d4:	e8 43 c8 ff ff       	call   80102b1c <lapiceoi>
    break;
801062d9:	e9 11 01 00 00       	jmp    801063ef <trap+0x1da>
  case T_IRQ0 + IRQ_IDE+1:
    // Bochs generates spurious IDE1 interrupts.
    break;
  case T_IRQ0 + IRQ_KBD:
    kbdintr();
801062de:	e8 7e c6 ff ff       	call   80102961 <kbdintr>
    lapiceoi();
801062e3:	e8 34 c8 ff ff       	call   80102b1c <lapiceoi>
    break;
801062e8:	e9 02 01 00 00       	jmp    801063ef <trap+0x1da>
  case T_IRQ0 + IRQ_COM1:
    uartintr();
801062ed:	e8 53 03 00 00       	call   80106645 <uartintr>
    lapiceoi();
801062f2:	e8 25 c8 ff ff       	call   80102b1c <lapiceoi>
    break;
801062f7:	e9 f3 00 00 00       	jmp    801063ef <trap+0x1da>
  case T_IRQ0 + 0xB:
    i8254_intr();
801062fc:	e8 7b 2b 00 00       	call   80108e7c <i8254_intr>
    lapiceoi();
80106301:	e8 16 c8 ff ff       	call   80102b1c <lapiceoi>
    break;
80106306:	e9 e4 00 00 00       	jmp    801063ef <trap+0x1da>
  case T_IRQ0 + IRQ_SPURIOUS:
    cprintf("cpu%d: spurious interrupt at %x:%x\n",
8010630b:	8b 45 08             	mov    0x8(%ebp),%eax
8010630e:	8b 70 38             	mov    0x38(%eax),%esi
            cpuid(), tf->cs, tf->eip);
80106311:	8b 45 08             	mov    0x8(%ebp),%eax
80106314:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
    cprintf("cpu%d: spurious interrupt at %x:%x\n",
80106318:	0f b7 d8             	movzwl %ax,%ebx
8010631b:	e8 7d d6 ff ff       	call   8010399d <cpuid>
80106320:	56                   	push   %esi
80106321:	53                   	push   %ebx
80106322:	50                   	push   %eax
80106323:	68 00 a7 10 80       	push   $0x8010a700
80106328:	e8 c7 a0 ff ff       	call   801003f4 <cprintf>
8010632d:	83 c4 10             	add    $0x10,%esp
    lapiceoi();
80106330:	e8 e7 c7 ff ff       	call   80102b1c <lapiceoi>
    break;
80106335:	e9 b5 00 00 00       	jmp    801063ef <trap+0x1da>

  //PAGEBREAK: 13
  default:
    if(myproc() == 0 || (tf->cs&3) == 0){
8010633a:	e8 f1 d6 ff ff       	call   80103a30 <myproc>
8010633f:	85 c0                	test   %eax,%eax
80106341:	74 11                	je     80106354 <trap+0x13f>
80106343:	8b 45 08             	mov    0x8(%ebp),%eax
80106346:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
8010634a:	0f b7 c0             	movzwl %ax,%eax
8010634d:	83 e0 03             	and    $0x3,%eax
80106350:	85 c0                	test   %eax,%eax
80106352:	75 39                	jne    8010638d <trap+0x178>
      // In kernel, it must be our mistake.
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
80106354:	e8 1d fd ff ff       	call   80106076 <rcr2>
80106359:	89 c3                	mov    %eax,%ebx
8010635b:	8b 45 08             	mov    0x8(%ebp),%eax
8010635e:	8b 70 38             	mov    0x38(%eax),%esi
80106361:	e8 37 d6 ff ff       	call   8010399d <cpuid>
80106366:	8b 55 08             	mov    0x8(%ebp),%edx
80106369:	8b 52 30             	mov    0x30(%edx),%edx
8010636c:	83 ec 0c             	sub    $0xc,%esp
8010636f:	53                   	push   %ebx
80106370:	56                   	push   %esi
80106371:	50                   	push   %eax
80106372:	52                   	push   %edx
80106373:	68 24 a7 10 80       	push   $0x8010a724
80106378:	e8 77 a0 ff ff       	call   801003f4 <cprintf>
8010637d:	83 c4 20             	add    $0x20,%esp
              tf->trapno, cpuid(), tf->eip, rcr2());
      panic("trap");
80106380:	83 ec 0c             	sub    $0xc,%esp
80106383:	68 56 a7 10 80       	push   $0x8010a756
80106388:	e8 1c a2 ff ff       	call   801005a9 <panic>
    }
    // In user space, assume process misbehaved.
    cprintf("pid %d %s: trap %d err %d on cpu %d "
8010638d:	e8 e4 fc ff ff       	call   80106076 <rcr2>
80106392:	89 c6                	mov    %eax,%esi
80106394:	8b 45 08             	mov    0x8(%ebp),%eax
80106397:	8b 40 38             	mov    0x38(%eax),%eax
8010639a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
8010639d:	e8 fb d5 ff ff       	call   8010399d <cpuid>
801063a2:	89 c3                	mov    %eax,%ebx
801063a4:	8b 45 08             	mov    0x8(%ebp),%eax
801063a7:	8b 48 34             	mov    0x34(%eax),%ecx
801063aa:	89 4d e0             	mov    %ecx,-0x20(%ebp)
801063ad:	8b 45 08             	mov    0x8(%ebp),%eax
801063b0:	8b 78 30             	mov    0x30(%eax),%edi
            "eip 0x%x addr 0x%x--kill proc\n",
            myproc()->pid, myproc()->name, tf->trapno,
801063b3:	e8 78 d6 ff ff       	call   80103a30 <myproc>
801063b8:	8d 50 6c             	lea    0x6c(%eax),%edx
801063bb:	89 55 dc             	mov    %edx,-0x24(%ebp)
801063be:	e8 6d d6 ff ff       	call   80103a30 <myproc>
    cprintf("pid %d %s: trap %d err %d on cpu %d "
801063c3:	8b 40 10             	mov    0x10(%eax),%eax
801063c6:	56                   	push   %esi
801063c7:	ff 75 e4             	push   -0x1c(%ebp)
801063ca:	53                   	push   %ebx
801063cb:	ff 75 e0             	push   -0x20(%ebp)
801063ce:	57                   	push   %edi
801063cf:	ff 75 dc             	push   -0x24(%ebp)
801063d2:	50                   	push   %eax
801063d3:	68 5c a7 10 80       	push   $0x8010a75c
801063d8:	e8 17 a0 ff ff       	call   801003f4 <cprintf>
801063dd:	83 c4 20             	add    $0x20,%esp
            tf->err, cpuid(), tf->eip, rcr2());
    myproc()->killed = 1;
801063e0:	e8 4b d6 ff ff       	call   80103a30 <myproc>
801063e5:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
801063ec:	eb 01                	jmp    801063ef <trap+0x1da>
    break;
801063ee:	90                   	nop
  }

  // Force process exit if it has been killed and is in user space.
  // (If it is still executing in the kernel, let it keep running
  // until it gets to the regular system call return.)
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
801063ef:	e8 3c d6 ff ff       	call   80103a30 <myproc>
801063f4:	85 c0                	test   %eax,%eax
801063f6:	74 23                	je     8010641b <trap+0x206>
801063f8:	e8 33 d6 ff ff       	call   80103a30 <myproc>
801063fd:	8b 40 24             	mov    0x24(%eax),%eax
80106400:	85 c0                	test   %eax,%eax
80106402:	74 17                	je     8010641b <trap+0x206>
80106404:	8b 45 08             	mov    0x8(%ebp),%eax
80106407:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
8010640b:	0f b7 c0             	movzwl %ax,%eax
8010640e:	83 e0 03             	and    $0x3,%eax
80106411:	83 f8 03             	cmp    $0x3,%eax
80106414:	75 05                	jne    8010641b <trap+0x206>
    exit();
80106416:	e8 90 da ff ff       	call   80103eab <exit>

  // Force process to give up CPU on clock tick.
  // If interrupts were on while locks held, would need to check nlock.
  if(myproc() && myproc()->state == RUNNING &&
8010641b:	e8 10 d6 ff ff       	call   80103a30 <myproc>
80106420:	85 c0                	test   %eax,%eax
80106422:	74 1d                	je     80106441 <trap+0x22c>
80106424:	e8 07 d6 ff ff       	call   80103a30 <myproc>
80106429:	8b 40 0c             	mov    0xc(%eax),%eax
8010642c:	83 f8 04             	cmp    $0x4,%eax
8010642f:	75 10                	jne    80106441 <trap+0x22c>
     tf->trapno == T_IRQ0+IRQ_TIMER)
80106431:	8b 45 08             	mov    0x8(%ebp),%eax
80106434:	8b 40 30             	mov    0x30(%eax),%eax
  if(myproc() && myproc()->state == RUNNING &&
80106437:	83 f8 20             	cmp    $0x20,%eax
8010643a:	75 05                	jne    80106441 <trap+0x22c>
    yield();
8010643c:	e8 bf e0 ff ff       	call   80104500 <yield>

  // Check if the process has been killed since we yielded
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80106441:	e8 ea d5 ff ff       	call   80103a30 <myproc>
80106446:	85 c0                	test   %eax,%eax
80106448:	74 26                	je     80106470 <trap+0x25b>
8010644a:	e8 e1 d5 ff ff       	call   80103a30 <myproc>
8010644f:	8b 40 24             	mov    0x24(%eax),%eax
80106452:	85 c0                	test   %eax,%eax
80106454:	74 1a                	je     80106470 <trap+0x25b>
80106456:	8b 45 08             	mov    0x8(%ebp),%eax
80106459:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
8010645d:	0f b7 c0             	movzwl %ax,%eax
80106460:	83 e0 03             	and    $0x3,%eax
80106463:	83 f8 03             	cmp    $0x3,%eax
80106466:	75 08                	jne    80106470 <trap+0x25b>
    exit();
80106468:	e8 3e da ff ff       	call   80103eab <exit>
8010646d:	eb 01                	jmp    80106470 <trap+0x25b>
    return;
8010646f:	90                   	nop
}
80106470:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106473:	5b                   	pop    %ebx
80106474:	5e                   	pop    %esi
80106475:	5f                   	pop    %edi
80106476:	5d                   	pop    %ebp
80106477:	c3                   	ret    

80106478 <inb>:
{
80106478:	55                   	push   %ebp
80106479:	89 e5                	mov    %esp,%ebp
8010647b:	83 ec 14             	sub    $0x14,%esp
8010647e:	8b 45 08             	mov    0x8(%ebp),%eax
80106481:	66 89 45 ec          	mov    %ax,-0x14(%ebp)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80106485:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
80106489:	89 c2                	mov    %eax,%edx
8010648b:	ec                   	in     (%dx),%al
8010648c:	88 45 ff             	mov    %al,-0x1(%ebp)
  return data;
8010648f:	0f b6 45 ff          	movzbl -0x1(%ebp),%eax
}
80106493:	c9                   	leave  
80106494:	c3                   	ret    

80106495 <outb>:
{
80106495:	55                   	push   %ebp
80106496:	89 e5                	mov    %esp,%ebp
80106498:	83 ec 08             	sub    $0x8,%esp
8010649b:	8b 45 08             	mov    0x8(%ebp),%eax
8010649e:	8b 55 0c             	mov    0xc(%ebp),%edx
801064a1:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
801064a5:	89 d0                	mov    %edx,%eax
801064a7:	88 45 f8             	mov    %al,-0x8(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801064aa:	0f b6 45 f8          	movzbl -0x8(%ebp),%eax
801064ae:	0f b7 55 fc          	movzwl -0x4(%ebp),%edx
801064b2:	ee                   	out    %al,(%dx)
}
801064b3:	90                   	nop
801064b4:	c9                   	leave  
801064b5:	c3                   	ret    

801064b6 <uartinit>:

static int uart;    // is there a uart?

void
uartinit(void)
{
801064b6:	55                   	push   %ebp
801064b7:	89 e5                	mov    %esp,%ebp
801064b9:	83 ec 18             	sub    $0x18,%esp
  char *p;

  // Turn off the FIFO
  outb(COM1+2, 0);
801064bc:	6a 00                	push   $0x0
801064be:	68 fa 03 00 00       	push   $0x3fa
801064c3:	e8 cd ff ff ff       	call   80106495 <outb>
801064c8:	83 c4 08             	add    $0x8,%esp

  // 9600 baud, 8 data bits, 1 stop bit, parity off.
  outb(COM1+3, 0x80);    // Unlock divisor
801064cb:	68 80 00 00 00       	push   $0x80
801064d0:	68 fb 03 00 00       	push   $0x3fb
801064d5:	e8 bb ff ff ff       	call   80106495 <outb>
801064da:	83 c4 08             	add    $0x8,%esp
  outb(COM1+0, 115200/9600);
801064dd:	6a 0c                	push   $0xc
801064df:	68 f8 03 00 00       	push   $0x3f8
801064e4:	e8 ac ff ff ff       	call   80106495 <outb>
801064e9:	83 c4 08             	add    $0x8,%esp
  outb(COM1+1, 0);
801064ec:	6a 00                	push   $0x0
801064ee:	68 f9 03 00 00       	push   $0x3f9
801064f3:	e8 9d ff ff ff       	call   80106495 <outb>
801064f8:	83 c4 08             	add    $0x8,%esp
  outb(COM1+3, 0x03);    // Lock divisor, 8 data bits.
801064fb:	6a 03                	push   $0x3
801064fd:	68 fb 03 00 00       	push   $0x3fb
80106502:	e8 8e ff ff ff       	call   80106495 <outb>
80106507:	83 c4 08             	add    $0x8,%esp
  outb(COM1+4, 0);
8010650a:	6a 00                	push   $0x0
8010650c:	68 fc 03 00 00       	push   $0x3fc
80106511:	e8 7f ff ff ff       	call   80106495 <outb>
80106516:	83 c4 08             	add    $0x8,%esp
  outb(COM1+1, 0x01);    // Enable receive interrupts.
80106519:	6a 01                	push   $0x1
8010651b:	68 f9 03 00 00       	push   $0x3f9
80106520:	e8 70 ff ff ff       	call   80106495 <outb>
80106525:	83 c4 08             	add    $0x8,%esp

  // If status is 0xFF, no serial port.
  if(inb(COM1+5) == 0xFF)
80106528:	68 fd 03 00 00       	push   $0x3fd
8010652d:	e8 46 ff ff ff       	call   80106478 <inb>
80106532:	83 c4 04             	add    $0x4,%esp
80106535:	3c ff                	cmp    $0xff,%al
80106537:	74 61                	je     8010659a <uartinit+0xe4>
    return;
  uart = 1;
80106539:	c7 05 78 6b 19 80 01 	movl   $0x1,0x80196b78
80106540:	00 00 00 

  // Acknowledge pre-existing interrupt conditions;
  // enable interrupts.
  inb(COM1+2);
80106543:	68 fa 03 00 00       	push   $0x3fa
80106548:	e8 2b ff ff ff       	call   80106478 <inb>
8010654d:	83 c4 04             	add    $0x4,%esp
  inb(COM1+0);
80106550:	68 f8 03 00 00       	push   $0x3f8
80106555:	e8 1e ff ff ff       	call   80106478 <inb>
8010655a:	83 c4 04             	add    $0x4,%esp
  ioapicenable(IRQ_COM1, 0);
8010655d:	83 ec 08             	sub    $0x8,%esp
80106560:	6a 00                	push   $0x0
80106562:	6a 04                	push   $0x4
80106564:	e8 c5 c0 ff ff       	call   8010262e <ioapicenable>
80106569:	83 c4 10             	add    $0x10,%esp

  // Announce that we're here.
  for(p="xv6...\n"; *p; p++)
8010656c:	c7 45 f4 20 a8 10 80 	movl   $0x8010a820,-0xc(%ebp)
80106573:	eb 19                	jmp    8010658e <uartinit+0xd8>
    uartputc(*p);
80106575:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106578:	0f b6 00             	movzbl (%eax),%eax
8010657b:	0f be c0             	movsbl %al,%eax
8010657e:	83 ec 0c             	sub    $0xc,%esp
80106581:	50                   	push   %eax
80106582:	e8 16 00 00 00       	call   8010659d <uartputc>
80106587:	83 c4 10             	add    $0x10,%esp
  for(p="xv6...\n"; *p; p++)
8010658a:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
8010658e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106591:	0f b6 00             	movzbl (%eax),%eax
80106594:	84 c0                	test   %al,%al
80106596:	75 dd                	jne    80106575 <uartinit+0xbf>
80106598:	eb 01                	jmp    8010659b <uartinit+0xe5>
    return;
8010659a:	90                   	nop
}
8010659b:	c9                   	leave  
8010659c:	c3                   	ret    

8010659d <uartputc>:

void
uartputc(int c)
{
8010659d:	55                   	push   %ebp
8010659e:	89 e5                	mov    %esp,%ebp
801065a0:	83 ec 18             	sub    $0x18,%esp
  int i;

  if(!uart)
801065a3:	a1 78 6b 19 80       	mov    0x80196b78,%eax
801065a8:	85 c0                	test   %eax,%eax
801065aa:	74 53                	je     801065ff <uartputc+0x62>
    return;
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
801065ac:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
801065b3:	eb 11                	jmp    801065c6 <uartputc+0x29>
    microdelay(10);
801065b5:	83 ec 0c             	sub    $0xc,%esp
801065b8:	6a 0a                	push   $0xa
801065ba:	e8 78 c5 ff ff       	call   80102b37 <microdelay>
801065bf:	83 c4 10             	add    $0x10,%esp
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
801065c2:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
801065c6:	83 7d f4 7f          	cmpl   $0x7f,-0xc(%ebp)
801065ca:	7f 1a                	jg     801065e6 <uartputc+0x49>
801065cc:	83 ec 0c             	sub    $0xc,%esp
801065cf:	68 fd 03 00 00       	push   $0x3fd
801065d4:	e8 9f fe ff ff       	call   80106478 <inb>
801065d9:	83 c4 10             	add    $0x10,%esp
801065dc:	0f b6 c0             	movzbl %al,%eax
801065df:	83 e0 20             	and    $0x20,%eax
801065e2:	85 c0                	test   %eax,%eax
801065e4:	74 cf                	je     801065b5 <uartputc+0x18>
  outb(COM1+0, c);
801065e6:	8b 45 08             	mov    0x8(%ebp),%eax
801065e9:	0f b6 c0             	movzbl %al,%eax
801065ec:	83 ec 08             	sub    $0x8,%esp
801065ef:	50                   	push   %eax
801065f0:	68 f8 03 00 00       	push   $0x3f8
801065f5:	e8 9b fe ff ff       	call   80106495 <outb>
801065fa:	83 c4 10             	add    $0x10,%esp
801065fd:	eb 01                	jmp    80106600 <uartputc+0x63>
    return;
801065ff:	90                   	nop
}
80106600:	c9                   	leave  
80106601:	c3                   	ret    

80106602 <uartgetc>:

static int
uartgetc(void)
{
80106602:	55                   	push   %ebp
80106603:	89 e5                	mov    %esp,%ebp
  if(!uart)
80106605:	a1 78 6b 19 80       	mov    0x80196b78,%eax
8010660a:	85 c0                	test   %eax,%eax
8010660c:	75 07                	jne    80106615 <uartgetc+0x13>
    return -1;
8010660e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106613:	eb 2e                	jmp    80106643 <uartgetc+0x41>
  if(!(inb(COM1+5) & 0x01))
80106615:	68 fd 03 00 00       	push   $0x3fd
8010661a:	e8 59 fe ff ff       	call   80106478 <inb>
8010661f:	83 c4 04             	add    $0x4,%esp
80106622:	0f b6 c0             	movzbl %al,%eax
80106625:	83 e0 01             	and    $0x1,%eax
80106628:	85 c0                	test   %eax,%eax
8010662a:	75 07                	jne    80106633 <uartgetc+0x31>
    return -1;
8010662c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106631:	eb 10                	jmp    80106643 <uartgetc+0x41>
  return inb(COM1+0);
80106633:	68 f8 03 00 00       	push   $0x3f8
80106638:	e8 3b fe ff ff       	call   80106478 <inb>
8010663d:	83 c4 04             	add    $0x4,%esp
80106640:	0f b6 c0             	movzbl %al,%eax
}
80106643:	c9                   	leave  
80106644:	c3                   	ret    

80106645 <uartintr>:

void
uartintr(void)
{
80106645:	55                   	push   %ebp
80106646:	89 e5                	mov    %esp,%ebp
80106648:	83 ec 08             	sub    $0x8,%esp
  consoleintr(uartgetc);
8010664b:	83 ec 0c             	sub    $0xc,%esp
8010664e:	68 02 66 10 80       	push   $0x80106602
80106653:	e8 7e a1 ff ff       	call   801007d6 <consoleintr>
80106658:	83 c4 10             	add    $0x10,%esp
}
8010665b:	90                   	nop
8010665c:	c9                   	leave  
8010665d:	c3                   	ret    

8010665e <vector0>:
8010665e:	6a 00                	push   $0x0
80106660:	6a 00                	push   $0x0
80106662:	e9 c2 f9 ff ff       	jmp    80106029 <alltraps>

80106667 <vector1>:
80106667:	6a 00                	push   $0x0
80106669:	6a 01                	push   $0x1
8010666b:	e9 b9 f9 ff ff       	jmp    80106029 <alltraps>

80106670 <vector2>:
80106670:	6a 00                	push   $0x0
80106672:	6a 02                	push   $0x2
80106674:	e9 b0 f9 ff ff       	jmp    80106029 <alltraps>

80106679 <vector3>:
80106679:	6a 00                	push   $0x0
8010667b:	6a 03                	push   $0x3
8010667d:	e9 a7 f9 ff ff       	jmp    80106029 <alltraps>

80106682 <vector4>:
80106682:	6a 00                	push   $0x0
80106684:	6a 04                	push   $0x4
80106686:	e9 9e f9 ff ff       	jmp    80106029 <alltraps>

8010668b <vector5>:
8010668b:	6a 00                	push   $0x0
8010668d:	6a 05                	push   $0x5
8010668f:	e9 95 f9 ff ff       	jmp    80106029 <alltraps>

80106694 <vector6>:
80106694:	6a 00                	push   $0x0
80106696:	6a 06                	push   $0x6
80106698:	e9 8c f9 ff ff       	jmp    80106029 <alltraps>

8010669d <vector7>:
8010669d:	6a 00                	push   $0x0
8010669f:	6a 07                	push   $0x7
801066a1:	e9 83 f9 ff ff       	jmp    80106029 <alltraps>

801066a6 <vector8>:
801066a6:	6a 08                	push   $0x8
801066a8:	e9 7c f9 ff ff       	jmp    80106029 <alltraps>

801066ad <vector9>:
801066ad:	6a 00                	push   $0x0
801066af:	6a 09                	push   $0x9
801066b1:	e9 73 f9 ff ff       	jmp    80106029 <alltraps>

801066b6 <vector10>:
801066b6:	6a 0a                	push   $0xa
801066b8:	e9 6c f9 ff ff       	jmp    80106029 <alltraps>

801066bd <vector11>:
801066bd:	6a 0b                	push   $0xb
801066bf:	e9 65 f9 ff ff       	jmp    80106029 <alltraps>

801066c4 <vector12>:
801066c4:	6a 0c                	push   $0xc
801066c6:	e9 5e f9 ff ff       	jmp    80106029 <alltraps>

801066cb <vector13>:
801066cb:	6a 0d                	push   $0xd
801066cd:	e9 57 f9 ff ff       	jmp    80106029 <alltraps>

801066d2 <vector14>:
801066d2:	6a 0e                	push   $0xe
801066d4:	e9 50 f9 ff ff       	jmp    80106029 <alltraps>

801066d9 <vector15>:
801066d9:	6a 00                	push   $0x0
801066db:	6a 0f                	push   $0xf
801066dd:	e9 47 f9 ff ff       	jmp    80106029 <alltraps>

801066e2 <vector16>:
801066e2:	6a 00                	push   $0x0
801066e4:	6a 10                	push   $0x10
801066e6:	e9 3e f9 ff ff       	jmp    80106029 <alltraps>

801066eb <vector17>:
801066eb:	6a 11                	push   $0x11
801066ed:	e9 37 f9 ff ff       	jmp    80106029 <alltraps>

801066f2 <vector18>:
801066f2:	6a 00                	push   $0x0
801066f4:	6a 12                	push   $0x12
801066f6:	e9 2e f9 ff ff       	jmp    80106029 <alltraps>

801066fb <vector19>:
801066fb:	6a 00                	push   $0x0
801066fd:	6a 13                	push   $0x13
801066ff:	e9 25 f9 ff ff       	jmp    80106029 <alltraps>

80106704 <vector20>:
80106704:	6a 00                	push   $0x0
80106706:	6a 14                	push   $0x14
80106708:	e9 1c f9 ff ff       	jmp    80106029 <alltraps>

8010670d <vector21>:
8010670d:	6a 00                	push   $0x0
8010670f:	6a 15                	push   $0x15
80106711:	e9 13 f9 ff ff       	jmp    80106029 <alltraps>

80106716 <vector22>:
80106716:	6a 00                	push   $0x0
80106718:	6a 16                	push   $0x16
8010671a:	e9 0a f9 ff ff       	jmp    80106029 <alltraps>

8010671f <vector23>:
8010671f:	6a 00                	push   $0x0
80106721:	6a 17                	push   $0x17
80106723:	e9 01 f9 ff ff       	jmp    80106029 <alltraps>

80106728 <vector24>:
80106728:	6a 00                	push   $0x0
8010672a:	6a 18                	push   $0x18
8010672c:	e9 f8 f8 ff ff       	jmp    80106029 <alltraps>

80106731 <vector25>:
80106731:	6a 00                	push   $0x0
80106733:	6a 19                	push   $0x19
80106735:	e9 ef f8 ff ff       	jmp    80106029 <alltraps>

8010673a <vector26>:
8010673a:	6a 00                	push   $0x0
8010673c:	6a 1a                	push   $0x1a
8010673e:	e9 e6 f8 ff ff       	jmp    80106029 <alltraps>

80106743 <vector27>:
80106743:	6a 00                	push   $0x0
80106745:	6a 1b                	push   $0x1b
80106747:	e9 dd f8 ff ff       	jmp    80106029 <alltraps>

8010674c <vector28>:
8010674c:	6a 00                	push   $0x0
8010674e:	6a 1c                	push   $0x1c
80106750:	e9 d4 f8 ff ff       	jmp    80106029 <alltraps>

80106755 <vector29>:
80106755:	6a 00                	push   $0x0
80106757:	6a 1d                	push   $0x1d
80106759:	e9 cb f8 ff ff       	jmp    80106029 <alltraps>

8010675e <vector30>:
8010675e:	6a 00                	push   $0x0
80106760:	6a 1e                	push   $0x1e
80106762:	e9 c2 f8 ff ff       	jmp    80106029 <alltraps>

80106767 <vector31>:
80106767:	6a 00                	push   $0x0
80106769:	6a 1f                	push   $0x1f
8010676b:	e9 b9 f8 ff ff       	jmp    80106029 <alltraps>

80106770 <vector32>:
80106770:	6a 00                	push   $0x0
80106772:	6a 20                	push   $0x20
80106774:	e9 b0 f8 ff ff       	jmp    80106029 <alltraps>

80106779 <vector33>:
80106779:	6a 00                	push   $0x0
8010677b:	6a 21                	push   $0x21
8010677d:	e9 a7 f8 ff ff       	jmp    80106029 <alltraps>

80106782 <vector34>:
80106782:	6a 00                	push   $0x0
80106784:	6a 22                	push   $0x22
80106786:	e9 9e f8 ff ff       	jmp    80106029 <alltraps>

8010678b <vector35>:
8010678b:	6a 00                	push   $0x0
8010678d:	6a 23                	push   $0x23
8010678f:	e9 95 f8 ff ff       	jmp    80106029 <alltraps>

80106794 <vector36>:
80106794:	6a 00                	push   $0x0
80106796:	6a 24                	push   $0x24
80106798:	e9 8c f8 ff ff       	jmp    80106029 <alltraps>

8010679d <vector37>:
8010679d:	6a 00                	push   $0x0
8010679f:	6a 25                	push   $0x25
801067a1:	e9 83 f8 ff ff       	jmp    80106029 <alltraps>

801067a6 <vector38>:
801067a6:	6a 00                	push   $0x0
801067a8:	6a 26                	push   $0x26
801067aa:	e9 7a f8 ff ff       	jmp    80106029 <alltraps>

801067af <vector39>:
801067af:	6a 00                	push   $0x0
801067b1:	6a 27                	push   $0x27
801067b3:	e9 71 f8 ff ff       	jmp    80106029 <alltraps>

801067b8 <vector40>:
801067b8:	6a 00                	push   $0x0
801067ba:	6a 28                	push   $0x28
801067bc:	e9 68 f8 ff ff       	jmp    80106029 <alltraps>

801067c1 <vector41>:
801067c1:	6a 00                	push   $0x0
801067c3:	6a 29                	push   $0x29
801067c5:	e9 5f f8 ff ff       	jmp    80106029 <alltraps>

801067ca <vector42>:
801067ca:	6a 00                	push   $0x0
801067cc:	6a 2a                	push   $0x2a
801067ce:	e9 56 f8 ff ff       	jmp    80106029 <alltraps>

801067d3 <vector43>:
801067d3:	6a 00                	push   $0x0
801067d5:	6a 2b                	push   $0x2b
801067d7:	e9 4d f8 ff ff       	jmp    80106029 <alltraps>

801067dc <vector44>:
801067dc:	6a 00                	push   $0x0
801067de:	6a 2c                	push   $0x2c
801067e0:	e9 44 f8 ff ff       	jmp    80106029 <alltraps>

801067e5 <vector45>:
801067e5:	6a 00                	push   $0x0
801067e7:	6a 2d                	push   $0x2d
801067e9:	e9 3b f8 ff ff       	jmp    80106029 <alltraps>

801067ee <vector46>:
801067ee:	6a 00                	push   $0x0
801067f0:	6a 2e                	push   $0x2e
801067f2:	e9 32 f8 ff ff       	jmp    80106029 <alltraps>

801067f7 <vector47>:
801067f7:	6a 00                	push   $0x0
801067f9:	6a 2f                	push   $0x2f
801067fb:	e9 29 f8 ff ff       	jmp    80106029 <alltraps>

80106800 <vector48>:
80106800:	6a 00                	push   $0x0
80106802:	6a 30                	push   $0x30
80106804:	e9 20 f8 ff ff       	jmp    80106029 <alltraps>

80106809 <vector49>:
80106809:	6a 00                	push   $0x0
8010680b:	6a 31                	push   $0x31
8010680d:	e9 17 f8 ff ff       	jmp    80106029 <alltraps>

80106812 <vector50>:
80106812:	6a 00                	push   $0x0
80106814:	6a 32                	push   $0x32
80106816:	e9 0e f8 ff ff       	jmp    80106029 <alltraps>

8010681b <vector51>:
8010681b:	6a 00                	push   $0x0
8010681d:	6a 33                	push   $0x33
8010681f:	e9 05 f8 ff ff       	jmp    80106029 <alltraps>

80106824 <vector52>:
80106824:	6a 00                	push   $0x0
80106826:	6a 34                	push   $0x34
80106828:	e9 fc f7 ff ff       	jmp    80106029 <alltraps>

8010682d <vector53>:
8010682d:	6a 00                	push   $0x0
8010682f:	6a 35                	push   $0x35
80106831:	e9 f3 f7 ff ff       	jmp    80106029 <alltraps>

80106836 <vector54>:
80106836:	6a 00                	push   $0x0
80106838:	6a 36                	push   $0x36
8010683a:	e9 ea f7 ff ff       	jmp    80106029 <alltraps>

8010683f <vector55>:
8010683f:	6a 00                	push   $0x0
80106841:	6a 37                	push   $0x37
80106843:	e9 e1 f7 ff ff       	jmp    80106029 <alltraps>

80106848 <vector56>:
80106848:	6a 00                	push   $0x0
8010684a:	6a 38                	push   $0x38
8010684c:	e9 d8 f7 ff ff       	jmp    80106029 <alltraps>

80106851 <vector57>:
80106851:	6a 00                	push   $0x0
80106853:	6a 39                	push   $0x39
80106855:	e9 cf f7 ff ff       	jmp    80106029 <alltraps>

8010685a <vector58>:
8010685a:	6a 00                	push   $0x0
8010685c:	6a 3a                	push   $0x3a
8010685e:	e9 c6 f7 ff ff       	jmp    80106029 <alltraps>

80106863 <vector59>:
80106863:	6a 00                	push   $0x0
80106865:	6a 3b                	push   $0x3b
80106867:	e9 bd f7 ff ff       	jmp    80106029 <alltraps>

8010686c <vector60>:
8010686c:	6a 00                	push   $0x0
8010686e:	6a 3c                	push   $0x3c
80106870:	e9 b4 f7 ff ff       	jmp    80106029 <alltraps>

80106875 <vector61>:
80106875:	6a 00                	push   $0x0
80106877:	6a 3d                	push   $0x3d
80106879:	e9 ab f7 ff ff       	jmp    80106029 <alltraps>

8010687e <vector62>:
8010687e:	6a 00                	push   $0x0
80106880:	6a 3e                	push   $0x3e
80106882:	e9 a2 f7 ff ff       	jmp    80106029 <alltraps>

80106887 <vector63>:
80106887:	6a 00                	push   $0x0
80106889:	6a 3f                	push   $0x3f
8010688b:	e9 99 f7 ff ff       	jmp    80106029 <alltraps>

80106890 <vector64>:
80106890:	6a 00                	push   $0x0
80106892:	6a 40                	push   $0x40
80106894:	e9 90 f7 ff ff       	jmp    80106029 <alltraps>

80106899 <vector65>:
80106899:	6a 00                	push   $0x0
8010689b:	6a 41                	push   $0x41
8010689d:	e9 87 f7 ff ff       	jmp    80106029 <alltraps>

801068a2 <vector66>:
801068a2:	6a 00                	push   $0x0
801068a4:	6a 42                	push   $0x42
801068a6:	e9 7e f7 ff ff       	jmp    80106029 <alltraps>

801068ab <vector67>:
801068ab:	6a 00                	push   $0x0
801068ad:	6a 43                	push   $0x43
801068af:	e9 75 f7 ff ff       	jmp    80106029 <alltraps>

801068b4 <vector68>:
801068b4:	6a 00                	push   $0x0
801068b6:	6a 44                	push   $0x44
801068b8:	e9 6c f7 ff ff       	jmp    80106029 <alltraps>

801068bd <vector69>:
801068bd:	6a 00                	push   $0x0
801068bf:	6a 45                	push   $0x45
801068c1:	e9 63 f7 ff ff       	jmp    80106029 <alltraps>

801068c6 <vector70>:
801068c6:	6a 00                	push   $0x0
801068c8:	6a 46                	push   $0x46
801068ca:	e9 5a f7 ff ff       	jmp    80106029 <alltraps>

801068cf <vector71>:
801068cf:	6a 00                	push   $0x0
801068d1:	6a 47                	push   $0x47
801068d3:	e9 51 f7 ff ff       	jmp    80106029 <alltraps>

801068d8 <vector72>:
801068d8:	6a 00                	push   $0x0
801068da:	6a 48                	push   $0x48
801068dc:	e9 48 f7 ff ff       	jmp    80106029 <alltraps>

801068e1 <vector73>:
801068e1:	6a 00                	push   $0x0
801068e3:	6a 49                	push   $0x49
801068e5:	e9 3f f7 ff ff       	jmp    80106029 <alltraps>

801068ea <vector74>:
801068ea:	6a 00                	push   $0x0
801068ec:	6a 4a                	push   $0x4a
801068ee:	e9 36 f7 ff ff       	jmp    80106029 <alltraps>

801068f3 <vector75>:
801068f3:	6a 00                	push   $0x0
801068f5:	6a 4b                	push   $0x4b
801068f7:	e9 2d f7 ff ff       	jmp    80106029 <alltraps>

801068fc <vector76>:
801068fc:	6a 00                	push   $0x0
801068fe:	6a 4c                	push   $0x4c
80106900:	e9 24 f7 ff ff       	jmp    80106029 <alltraps>

80106905 <vector77>:
80106905:	6a 00                	push   $0x0
80106907:	6a 4d                	push   $0x4d
80106909:	e9 1b f7 ff ff       	jmp    80106029 <alltraps>

8010690e <vector78>:
8010690e:	6a 00                	push   $0x0
80106910:	6a 4e                	push   $0x4e
80106912:	e9 12 f7 ff ff       	jmp    80106029 <alltraps>

80106917 <vector79>:
80106917:	6a 00                	push   $0x0
80106919:	6a 4f                	push   $0x4f
8010691b:	e9 09 f7 ff ff       	jmp    80106029 <alltraps>

80106920 <vector80>:
80106920:	6a 00                	push   $0x0
80106922:	6a 50                	push   $0x50
80106924:	e9 00 f7 ff ff       	jmp    80106029 <alltraps>

80106929 <vector81>:
80106929:	6a 00                	push   $0x0
8010692b:	6a 51                	push   $0x51
8010692d:	e9 f7 f6 ff ff       	jmp    80106029 <alltraps>

80106932 <vector82>:
80106932:	6a 00                	push   $0x0
80106934:	6a 52                	push   $0x52
80106936:	e9 ee f6 ff ff       	jmp    80106029 <alltraps>

8010693b <vector83>:
8010693b:	6a 00                	push   $0x0
8010693d:	6a 53                	push   $0x53
8010693f:	e9 e5 f6 ff ff       	jmp    80106029 <alltraps>

80106944 <vector84>:
80106944:	6a 00                	push   $0x0
80106946:	6a 54                	push   $0x54
80106948:	e9 dc f6 ff ff       	jmp    80106029 <alltraps>

8010694d <vector85>:
8010694d:	6a 00                	push   $0x0
8010694f:	6a 55                	push   $0x55
80106951:	e9 d3 f6 ff ff       	jmp    80106029 <alltraps>

80106956 <vector86>:
80106956:	6a 00                	push   $0x0
80106958:	6a 56                	push   $0x56
8010695a:	e9 ca f6 ff ff       	jmp    80106029 <alltraps>

8010695f <vector87>:
8010695f:	6a 00                	push   $0x0
80106961:	6a 57                	push   $0x57
80106963:	e9 c1 f6 ff ff       	jmp    80106029 <alltraps>

80106968 <vector88>:
80106968:	6a 00                	push   $0x0
8010696a:	6a 58                	push   $0x58
8010696c:	e9 b8 f6 ff ff       	jmp    80106029 <alltraps>

80106971 <vector89>:
80106971:	6a 00                	push   $0x0
80106973:	6a 59                	push   $0x59
80106975:	e9 af f6 ff ff       	jmp    80106029 <alltraps>

8010697a <vector90>:
8010697a:	6a 00                	push   $0x0
8010697c:	6a 5a                	push   $0x5a
8010697e:	e9 a6 f6 ff ff       	jmp    80106029 <alltraps>

80106983 <vector91>:
80106983:	6a 00                	push   $0x0
80106985:	6a 5b                	push   $0x5b
80106987:	e9 9d f6 ff ff       	jmp    80106029 <alltraps>

8010698c <vector92>:
8010698c:	6a 00                	push   $0x0
8010698e:	6a 5c                	push   $0x5c
80106990:	e9 94 f6 ff ff       	jmp    80106029 <alltraps>

80106995 <vector93>:
80106995:	6a 00                	push   $0x0
80106997:	6a 5d                	push   $0x5d
80106999:	e9 8b f6 ff ff       	jmp    80106029 <alltraps>

8010699e <vector94>:
8010699e:	6a 00                	push   $0x0
801069a0:	6a 5e                	push   $0x5e
801069a2:	e9 82 f6 ff ff       	jmp    80106029 <alltraps>

801069a7 <vector95>:
801069a7:	6a 00                	push   $0x0
801069a9:	6a 5f                	push   $0x5f
801069ab:	e9 79 f6 ff ff       	jmp    80106029 <alltraps>

801069b0 <vector96>:
801069b0:	6a 00                	push   $0x0
801069b2:	6a 60                	push   $0x60
801069b4:	e9 70 f6 ff ff       	jmp    80106029 <alltraps>

801069b9 <vector97>:
801069b9:	6a 00                	push   $0x0
801069bb:	6a 61                	push   $0x61
801069bd:	e9 67 f6 ff ff       	jmp    80106029 <alltraps>

801069c2 <vector98>:
801069c2:	6a 00                	push   $0x0
801069c4:	6a 62                	push   $0x62
801069c6:	e9 5e f6 ff ff       	jmp    80106029 <alltraps>

801069cb <vector99>:
801069cb:	6a 00                	push   $0x0
801069cd:	6a 63                	push   $0x63
801069cf:	e9 55 f6 ff ff       	jmp    80106029 <alltraps>

801069d4 <vector100>:
801069d4:	6a 00                	push   $0x0
801069d6:	6a 64                	push   $0x64
801069d8:	e9 4c f6 ff ff       	jmp    80106029 <alltraps>

801069dd <vector101>:
801069dd:	6a 00                	push   $0x0
801069df:	6a 65                	push   $0x65
801069e1:	e9 43 f6 ff ff       	jmp    80106029 <alltraps>

801069e6 <vector102>:
801069e6:	6a 00                	push   $0x0
801069e8:	6a 66                	push   $0x66
801069ea:	e9 3a f6 ff ff       	jmp    80106029 <alltraps>

801069ef <vector103>:
801069ef:	6a 00                	push   $0x0
801069f1:	6a 67                	push   $0x67
801069f3:	e9 31 f6 ff ff       	jmp    80106029 <alltraps>

801069f8 <vector104>:
801069f8:	6a 00                	push   $0x0
801069fa:	6a 68                	push   $0x68
801069fc:	e9 28 f6 ff ff       	jmp    80106029 <alltraps>

80106a01 <vector105>:
80106a01:	6a 00                	push   $0x0
80106a03:	6a 69                	push   $0x69
80106a05:	e9 1f f6 ff ff       	jmp    80106029 <alltraps>

80106a0a <vector106>:
80106a0a:	6a 00                	push   $0x0
80106a0c:	6a 6a                	push   $0x6a
80106a0e:	e9 16 f6 ff ff       	jmp    80106029 <alltraps>

80106a13 <vector107>:
80106a13:	6a 00                	push   $0x0
80106a15:	6a 6b                	push   $0x6b
80106a17:	e9 0d f6 ff ff       	jmp    80106029 <alltraps>

80106a1c <vector108>:
80106a1c:	6a 00                	push   $0x0
80106a1e:	6a 6c                	push   $0x6c
80106a20:	e9 04 f6 ff ff       	jmp    80106029 <alltraps>

80106a25 <vector109>:
80106a25:	6a 00                	push   $0x0
80106a27:	6a 6d                	push   $0x6d
80106a29:	e9 fb f5 ff ff       	jmp    80106029 <alltraps>

80106a2e <vector110>:
80106a2e:	6a 00                	push   $0x0
80106a30:	6a 6e                	push   $0x6e
80106a32:	e9 f2 f5 ff ff       	jmp    80106029 <alltraps>

80106a37 <vector111>:
80106a37:	6a 00                	push   $0x0
80106a39:	6a 6f                	push   $0x6f
80106a3b:	e9 e9 f5 ff ff       	jmp    80106029 <alltraps>

80106a40 <vector112>:
80106a40:	6a 00                	push   $0x0
80106a42:	6a 70                	push   $0x70
80106a44:	e9 e0 f5 ff ff       	jmp    80106029 <alltraps>

80106a49 <vector113>:
80106a49:	6a 00                	push   $0x0
80106a4b:	6a 71                	push   $0x71
80106a4d:	e9 d7 f5 ff ff       	jmp    80106029 <alltraps>

80106a52 <vector114>:
80106a52:	6a 00                	push   $0x0
80106a54:	6a 72                	push   $0x72
80106a56:	e9 ce f5 ff ff       	jmp    80106029 <alltraps>

80106a5b <vector115>:
80106a5b:	6a 00                	push   $0x0
80106a5d:	6a 73                	push   $0x73
80106a5f:	e9 c5 f5 ff ff       	jmp    80106029 <alltraps>

80106a64 <vector116>:
80106a64:	6a 00                	push   $0x0
80106a66:	6a 74                	push   $0x74
80106a68:	e9 bc f5 ff ff       	jmp    80106029 <alltraps>

80106a6d <vector117>:
80106a6d:	6a 00                	push   $0x0
80106a6f:	6a 75                	push   $0x75
80106a71:	e9 b3 f5 ff ff       	jmp    80106029 <alltraps>

80106a76 <vector118>:
80106a76:	6a 00                	push   $0x0
80106a78:	6a 76                	push   $0x76
80106a7a:	e9 aa f5 ff ff       	jmp    80106029 <alltraps>

80106a7f <vector119>:
80106a7f:	6a 00                	push   $0x0
80106a81:	6a 77                	push   $0x77
80106a83:	e9 a1 f5 ff ff       	jmp    80106029 <alltraps>

80106a88 <vector120>:
80106a88:	6a 00                	push   $0x0
80106a8a:	6a 78                	push   $0x78
80106a8c:	e9 98 f5 ff ff       	jmp    80106029 <alltraps>

80106a91 <vector121>:
80106a91:	6a 00                	push   $0x0
80106a93:	6a 79                	push   $0x79
80106a95:	e9 8f f5 ff ff       	jmp    80106029 <alltraps>

80106a9a <vector122>:
80106a9a:	6a 00                	push   $0x0
80106a9c:	6a 7a                	push   $0x7a
80106a9e:	e9 86 f5 ff ff       	jmp    80106029 <alltraps>

80106aa3 <vector123>:
80106aa3:	6a 00                	push   $0x0
80106aa5:	6a 7b                	push   $0x7b
80106aa7:	e9 7d f5 ff ff       	jmp    80106029 <alltraps>

80106aac <vector124>:
80106aac:	6a 00                	push   $0x0
80106aae:	6a 7c                	push   $0x7c
80106ab0:	e9 74 f5 ff ff       	jmp    80106029 <alltraps>

80106ab5 <vector125>:
80106ab5:	6a 00                	push   $0x0
80106ab7:	6a 7d                	push   $0x7d
80106ab9:	e9 6b f5 ff ff       	jmp    80106029 <alltraps>

80106abe <vector126>:
80106abe:	6a 00                	push   $0x0
80106ac0:	6a 7e                	push   $0x7e
80106ac2:	e9 62 f5 ff ff       	jmp    80106029 <alltraps>

80106ac7 <vector127>:
80106ac7:	6a 00                	push   $0x0
80106ac9:	6a 7f                	push   $0x7f
80106acb:	e9 59 f5 ff ff       	jmp    80106029 <alltraps>

80106ad0 <vector128>:
80106ad0:	6a 00                	push   $0x0
80106ad2:	68 80 00 00 00       	push   $0x80
80106ad7:	e9 4d f5 ff ff       	jmp    80106029 <alltraps>

80106adc <vector129>:
80106adc:	6a 00                	push   $0x0
80106ade:	68 81 00 00 00       	push   $0x81
80106ae3:	e9 41 f5 ff ff       	jmp    80106029 <alltraps>

80106ae8 <vector130>:
80106ae8:	6a 00                	push   $0x0
80106aea:	68 82 00 00 00       	push   $0x82
80106aef:	e9 35 f5 ff ff       	jmp    80106029 <alltraps>

80106af4 <vector131>:
80106af4:	6a 00                	push   $0x0
80106af6:	68 83 00 00 00       	push   $0x83
80106afb:	e9 29 f5 ff ff       	jmp    80106029 <alltraps>

80106b00 <vector132>:
80106b00:	6a 00                	push   $0x0
80106b02:	68 84 00 00 00       	push   $0x84
80106b07:	e9 1d f5 ff ff       	jmp    80106029 <alltraps>

80106b0c <vector133>:
80106b0c:	6a 00                	push   $0x0
80106b0e:	68 85 00 00 00       	push   $0x85
80106b13:	e9 11 f5 ff ff       	jmp    80106029 <alltraps>

80106b18 <vector134>:
80106b18:	6a 00                	push   $0x0
80106b1a:	68 86 00 00 00       	push   $0x86
80106b1f:	e9 05 f5 ff ff       	jmp    80106029 <alltraps>

80106b24 <vector135>:
80106b24:	6a 00                	push   $0x0
80106b26:	68 87 00 00 00       	push   $0x87
80106b2b:	e9 f9 f4 ff ff       	jmp    80106029 <alltraps>

80106b30 <vector136>:
80106b30:	6a 00                	push   $0x0
80106b32:	68 88 00 00 00       	push   $0x88
80106b37:	e9 ed f4 ff ff       	jmp    80106029 <alltraps>

80106b3c <vector137>:
80106b3c:	6a 00                	push   $0x0
80106b3e:	68 89 00 00 00       	push   $0x89
80106b43:	e9 e1 f4 ff ff       	jmp    80106029 <alltraps>

80106b48 <vector138>:
80106b48:	6a 00                	push   $0x0
80106b4a:	68 8a 00 00 00       	push   $0x8a
80106b4f:	e9 d5 f4 ff ff       	jmp    80106029 <alltraps>

80106b54 <vector139>:
80106b54:	6a 00                	push   $0x0
80106b56:	68 8b 00 00 00       	push   $0x8b
80106b5b:	e9 c9 f4 ff ff       	jmp    80106029 <alltraps>

80106b60 <vector140>:
80106b60:	6a 00                	push   $0x0
80106b62:	68 8c 00 00 00       	push   $0x8c
80106b67:	e9 bd f4 ff ff       	jmp    80106029 <alltraps>

80106b6c <vector141>:
80106b6c:	6a 00                	push   $0x0
80106b6e:	68 8d 00 00 00       	push   $0x8d
80106b73:	e9 b1 f4 ff ff       	jmp    80106029 <alltraps>

80106b78 <vector142>:
80106b78:	6a 00                	push   $0x0
80106b7a:	68 8e 00 00 00       	push   $0x8e
80106b7f:	e9 a5 f4 ff ff       	jmp    80106029 <alltraps>

80106b84 <vector143>:
80106b84:	6a 00                	push   $0x0
80106b86:	68 8f 00 00 00       	push   $0x8f
80106b8b:	e9 99 f4 ff ff       	jmp    80106029 <alltraps>

80106b90 <vector144>:
80106b90:	6a 00                	push   $0x0
80106b92:	68 90 00 00 00       	push   $0x90
80106b97:	e9 8d f4 ff ff       	jmp    80106029 <alltraps>

80106b9c <vector145>:
80106b9c:	6a 00                	push   $0x0
80106b9e:	68 91 00 00 00       	push   $0x91
80106ba3:	e9 81 f4 ff ff       	jmp    80106029 <alltraps>

80106ba8 <vector146>:
80106ba8:	6a 00                	push   $0x0
80106baa:	68 92 00 00 00       	push   $0x92
80106baf:	e9 75 f4 ff ff       	jmp    80106029 <alltraps>

80106bb4 <vector147>:
80106bb4:	6a 00                	push   $0x0
80106bb6:	68 93 00 00 00       	push   $0x93
80106bbb:	e9 69 f4 ff ff       	jmp    80106029 <alltraps>

80106bc0 <vector148>:
80106bc0:	6a 00                	push   $0x0
80106bc2:	68 94 00 00 00       	push   $0x94
80106bc7:	e9 5d f4 ff ff       	jmp    80106029 <alltraps>

80106bcc <vector149>:
80106bcc:	6a 00                	push   $0x0
80106bce:	68 95 00 00 00       	push   $0x95
80106bd3:	e9 51 f4 ff ff       	jmp    80106029 <alltraps>

80106bd8 <vector150>:
80106bd8:	6a 00                	push   $0x0
80106bda:	68 96 00 00 00       	push   $0x96
80106bdf:	e9 45 f4 ff ff       	jmp    80106029 <alltraps>

80106be4 <vector151>:
80106be4:	6a 00                	push   $0x0
80106be6:	68 97 00 00 00       	push   $0x97
80106beb:	e9 39 f4 ff ff       	jmp    80106029 <alltraps>

80106bf0 <vector152>:
80106bf0:	6a 00                	push   $0x0
80106bf2:	68 98 00 00 00       	push   $0x98
80106bf7:	e9 2d f4 ff ff       	jmp    80106029 <alltraps>

80106bfc <vector153>:
80106bfc:	6a 00                	push   $0x0
80106bfe:	68 99 00 00 00       	push   $0x99
80106c03:	e9 21 f4 ff ff       	jmp    80106029 <alltraps>

80106c08 <vector154>:
80106c08:	6a 00                	push   $0x0
80106c0a:	68 9a 00 00 00       	push   $0x9a
80106c0f:	e9 15 f4 ff ff       	jmp    80106029 <alltraps>

80106c14 <vector155>:
80106c14:	6a 00                	push   $0x0
80106c16:	68 9b 00 00 00       	push   $0x9b
80106c1b:	e9 09 f4 ff ff       	jmp    80106029 <alltraps>

80106c20 <vector156>:
80106c20:	6a 00                	push   $0x0
80106c22:	68 9c 00 00 00       	push   $0x9c
80106c27:	e9 fd f3 ff ff       	jmp    80106029 <alltraps>

80106c2c <vector157>:
80106c2c:	6a 00                	push   $0x0
80106c2e:	68 9d 00 00 00       	push   $0x9d
80106c33:	e9 f1 f3 ff ff       	jmp    80106029 <alltraps>

80106c38 <vector158>:
80106c38:	6a 00                	push   $0x0
80106c3a:	68 9e 00 00 00       	push   $0x9e
80106c3f:	e9 e5 f3 ff ff       	jmp    80106029 <alltraps>

80106c44 <vector159>:
80106c44:	6a 00                	push   $0x0
80106c46:	68 9f 00 00 00       	push   $0x9f
80106c4b:	e9 d9 f3 ff ff       	jmp    80106029 <alltraps>

80106c50 <vector160>:
80106c50:	6a 00                	push   $0x0
80106c52:	68 a0 00 00 00       	push   $0xa0
80106c57:	e9 cd f3 ff ff       	jmp    80106029 <alltraps>

80106c5c <vector161>:
80106c5c:	6a 00                	push   $0x0
80106c5e:	68 a1 00 00 00       	push   $0xa1
80106c63:	e9 c1 f3 ff ff       	jmp    80106029 <alltraps>

80106c68 <vector162>:
80106c68:	6a 00                	push   $0x0
80106c6a:	68 a2 00 00 00       	push   $0xa2
80106c6f:	e9 b5 f3 ff ff       	jmp    80106029 <alltraps>

80106c74 <vector163>:
80106c74:	6a 00                	push   $0x0
80106c76:	68 a3 00 00 00       	push   $0xa3
80106c7b:	e9 a9 f3 ff ff       	jmp    80106029 <alltraps>

80106c80 <vector164>:
80106c80:	6a 00                	push   $0x0
80106c82:	68 a4 00 00 00       	push   $0xa4
80106c87:	e9 9d f3 ff ff       	jmp    80106029 <alltraps>

80106c8c <vector165>:
80106c8c:	6a 00                	push   $0x0
80106c8e:	68 a5 00 00 00       	push   $0xa5
80106c93:	e9 91 f3 ff ff       	jmp    80106029 <alltraps>

80106c98 <vector166>:
80106c98:	6a 00                	push   $0x0
80106c9a:	68 a6 00 00 00       	push   $0xa6
80106c9f:	e9 85 f3 ff ff       	jmp    80106029 <alltraps>

80106ca4 <vector167>:
80106ca4:	6a 00                	push   $0x0
80106ca6:	68 a7 00 00 00       	push   $0xa7
80106cab:	e9 79 f3 ff ff       	jmp    80106029 <alltraps>

80106cb0 <vector168>:
80106cb0:	6a 00                	push   $0x0
80106cb2:	68 a8 00 00 00       	push   $0xa8
80106cb7:	e9 6d f3 ff ff       	jmp    80106029 <alltraps>

80106cbc <vector169>:
80106cbc:	6a 00                	push   $0x0
80106cbe:	68 a9 00 00 00       	push   $0xa9
80106cc3:	e9 61 f3 ff ff       	jmp    80106029 <alltraps>

80106cc8 <vector170>:
80106cc8:	6a 00                	push   $0x0
80106cca:	68 aa 00 00 00       	push   $0xaa
80106ccf:	e9 55 f3 ff ff       	jmp    80106029 <alltraps>

80106cd4 <vector171>:
80106cd4:	6a 00                	push   $0x0
80106cd6:	68 ab 00 00 00       	push   $0xab
80106cdb:	e9 49 f3 ff ff       	jmp    80106029 <alltraps>

80106ce0 <vector172>:
80106ce0:	6a 00                	push   $0x0
80106ce2:	68 ac 00 00 00       	push   $0xac
80106ce7:	e9 3d f3 ff ff       	jmp    80106029 <alltraps>

80106cec <vector173>:
80106cec:	6a 00                	push   $0x0
80106cee:	68 ad 00 00 00       	push   $0xad
80106cf3:	e9 31 f3 ff ff       	jmp    80106029 <alltraps>

80106cf8 <vector174>:
80106cf8:	6a 00                	push   $0x0
80106cfa:	68 ae 00 00 00       	push   $0xae
80106cff:	e9 25 f3 ff ff       	jmp    80106029 <alltraps>

80106d04 <vector175>:
80106d04:	6a 00                	push   $0x0
80106d06:	68 af 00 00 00       	push   $0xaf
80106d0b:	e9 19 f3 ff ff       	jmp    80106029 <alltraps>

80106d10 <vector176>:
80106d10:	6a 00                	push   $0x0
80106d12:	68 b0 00 00 00       	push   $0xb0
80106d17:	e9 0d f3 ff ff       	jmp    80106029 <alltraps>

80106d1c <vector177>:
80106d1c:	6a 00                	push   $0x0
80106d1e:	68 b1 00 00 00       	push   $0xb1
80106d23:	e9 01 f3 ff ff       	jmp    80106029 <alltraps>

80106d28 <vector178>:
80106d28:	6a 00                	push   $0x0
80106d2a:	68 b2 00 00 00       	push   $0xb2
80106d2f:	e9 f5 f2 ff ff       	jmp    80106029 <alltraps>

80106d34 <vector179>:
80106d34:	6a 00                	push   $0x0
80106d36:	68 b3 00 00 00       	push   $0xb3
80106d3b:	e9 e9 f2 ff ff       	jmp    80106029 <alltraps>

80106d40 <vector180>:
80106d40:	6a 00                	push   $0x0
80106d42:	68 b4 00 00 00       	push   $0xb4
80106d47:	e9 dd f2 ff ff       	jmp    80106029 <alltraps>

80106d4c <vector181>:
80106d4c:	6a 00                	push   $0x0
80106d4e:	68 b5 00 00 00       	push   $0xb5
80106d53:	e9 d1 f2 ff ff       	jmp    80106029 <alltraps>

80106d58 <vector182>:
80106d58:	6a 00                	push   $0x0
80106d5a:	68 b6 00 00 00       	push   $0xb6
80106d5f:	e9 c5 f2 ff ff       	jmp    80106029 <alltraps>

80106d64 <vector183>:
80106d64:	6a 00                	push   $0x0
80106d66:	68 b7 00 00 00       	push   $0xb7
80106d6b:	e9 b9 f2 ff ff       	jmp    80106029 <alltraps>

80106d70 <vector184>:
80106d70:	6a 00                	push   $0x0
80106d72:	68 b8 00 00 00       	push   $0xb8
80106d77:	e9 ad f2 ff ff       	jmp    80106029 <alltraps>

80106d7c <vector185>:
80106d7c:	6a 00                	push   $0x0
80106d7e:	68 b9 00 00 00       	push   $0xb9
80106d83:	e9 a1 f2 ff ff       	jmp    80106029 <alltraps>

80106d88 <vector186>:
80106d88:	6a 00                	push   $0x0
80106d8a:	68 ba 00 00 00       	push   $0xba
80106d8f:	e9 95 f2 ff ff       	jmp    80106029 <alltraps>

80106d94 <vector187>:
80106d94:	6a 00                	push   $0x0
80106d96:	68 bb 00 00 00       	push   $0xbb
80106d9b:	e9 89 f2 ff ff       	jmp    80106029 <alltraps>

80106da0 <vector188>:
80106da0:	6a 00                	push   $0x0
80106da2:	68 bc 00 00 00       	push   $0xbc
80106da7:	e9 7d f2 ff ff       	jmp    80106029 <alltraps>

80106dac <vector189>:
80106dac:	6a 00                	push   $0x0
80106dae:	68 bd 00 00 00       	push   $0xbd
80106db3:	e9 71 f2 ff ff       	jmp    80106029 <alltraps>

80106db8 <vector190>:
80106db8:	6a 00                	push   $0x0
80106dba:	68 be 00 00 00       	push   $0xbe
80106dbf:	e9 65 f2 ff ff       	jmp    80106029 <alltraps>

80106dc4 <vector191>:
80106dc4:	6a 00                	push   $0x0
80106dc6:	68 bf 00 00 00       	push   $0xbf
80106dcb:	e9 59 f2 ff ff       	jmp    80106029 <alltraps>

80106dd0 <vector192>:
80106dd0:	6a 00                	push   $0x0
80106dd2:	68 c0 00 00 00       	push   $0xc0
80106dd7:	e9 4d f2 ff ff       	jmp    80106029 <alltraps>

80106ddc <vector193>:
80106ddc:	6a 00                	push   $0x0
80106dde:	68 c1 00 00 00       	push   $0xc1
80106de3:	e9 41 f2 ff ff       	jmp    80106029 <alltraps>

80106de8 <vector194>:
80106de8:	6a 00                	push   $0x0
80106dea:	68 c2 00 00 00       	push   $0xc2
80106def:	e9 35 f2 ff ff       	jmp    80106029 <alltraps>

80106df4 <vector195>:
80106df4:	6a 00                	push   $0x0
80106df6:	68 c3 00 00 00       	push   $0xc3
80106dfb:	e9 29 f2 ff ff       	jmp    80106029 <alltraps>

80106e00 <vector196>:
80106e00:	6a 00                	push   $0x0
80106e02:	68 c4 00 00 00       	push   $0xc4
80106e07:	e9 1d f2 ff ff       	jmp    80106029 <alltraps>

80106e0c <vector197>:
80106e0c:	6a 00                	push   $0x0
80106e0e:	68 c5 00 00 00       	push   $0xc5
80106e13:	e9 11 f2 ff ff       	jmp    80106029 <alltraps>

80106e18 <vector198>:
80106e18:	6a 00                	push   $0x0
80106e1a:	68 c6 00 00 00       	push   $0xc6
80106e1f:	e9 05 f2 ff ff       	jmp    80106029 <alltraps>

80106e24 <vector199>:
80106e24:	6a 00                	push   $0x0
80106e26:	68 c7 00 00 00       	push   $0xc7
80106e2b:	e9 f9 f1 ff ff       	jmp    80106029 <alltraps>

80106e30 <vector200>:
80106e30:	6a 00                	push   $0x0
80106e32:	68 c8 00 00 00       	push   $0xc8
80106e37:	e9 ed f1 ff ff       	jmp    80106029 <alltraps>

80106e3c <vector201>:
80106e3c:	6a 00                	push   $0x0
80106e3e:	68 c9 00 00 00       	push   $0xc9
80106e43:	e9 e1 f1 ff ff       	jmp    80106029 <alltraps>

80106e48 <vector202>:
80106e48:	6a 00                	push   $0x0
80106e4a:	68 ca 00 00 00       	push   $0xca
80106e4f:	e9 d5 f1 ff ff       	jmp    80106029 <alltraps>

80106e54 <vector203>:
80106e54:	6a 00                	push   $0x0
80106e56:	68 cb 00 00 00       	push   $0xcb
80106e5b:	e9 c9 f1 ff ff       	jmp    80106029 <alltraps>

80106e60 <vector204>:
80106e60:	6a 00                	push   $0x0
80106e62:	68 cc 00 00 00       	push   $0xcc
80106e67:	e9 bd f1 ff ff       	jmp    80106029 <alltraps>

80106e6c <vector205>:
80106e6c:	6a 00                	push   $0x0
80106e6e:	68 cd 00 00 00       	push   $0xcd
80106e73:	e9 b1 f1 ff ff       	jmp    80106029 <alltraps>

80106e78 <vector206>:
80106e78:	6a 00                	push   $0x0
80106e7a:	68 ce 00 00 00       	push   $0xce
80106e7f:	e9 a5 f1 ff ff       	jmp    80106029 <alltraps>

80106e84 <vector207>:
80106e84:	6a 00                	push   $0x0
80106e86:	68 cf 00 00 00       	push   $0xcf
80106e8b:	e9 99 f1 ff ff       	jmp    80106029 <alltraps>

80106e90 <vector208>:
80106e90:	6a 00                	push   $0x0
80106e92:	68 d0 00 00 00       	push   $0xd0
80106e97:	e9 8d f1 ff ff       	jmp    80106029 <alltraps>

80106e9c <vector209>:
80106e9c:	6a 00                	push   $0x0
80106e9e:	68 d1 00 00 00       	push   $0xd1
80106ea3:	e9 81 f1 ff ff       	jmp    80106029 <alltraps>

80106ea8 <vector210>:
80106ea8:	6a 00                	push   $0x0
80106eaa:	68 d2 00 00 00       	push   $0xd2
80106eaf:	e9 75 f1 ff ff       	jmp    80106029 <alltraps>

80106eb4 <vector211>:
80106eb4:	6a 00                	push   $0x0
80106eb6:	68 d3 00 00 00       	push   $0xd3
80106ebb:	e9 69 f1 ff ff       	jmp    80106029 <alltraps>

80106ec0 <vector212>:
80106ec0:	6a 00                	push   $0x0
80106ec2:	68 d4 00 00 00       	push   $0xd4
80106ec7:	e9 5d f1 ff ff       	jmp    80106029 <alltraps>

80106ecc <vector213>:
80106ecc:	6a 00                	push   $0x0
80106ece:	68 d5 00 00 00       	push   $0xd5
80106ed3:	e9 51 f1 ff ff       	jmp    80106029 <alltraps>

80106ed8 <vector214>:
80106ed8:	6a 00                	push   $0x0
80106eda:	68 d6 00 00 00       	push   $0xd6
80106edf:	e9 45 f1 ff ff       	jmp    80106029 <alltraps>

80106ee4 <vector215>:
80106ee4:	6a 00                	push   $0x0
80106ee6:	68 d7 00 00 00       	push   $0xd7
80106eeb:	e9 39 f1 ff ff       	jmp    80106029 <alltraps>

80106ef0 <vector216>:
80106ef0:	6a 00                	push   $0x0
80106ef2:	68 d8 00 00 00       	push   $0xd8
80106ef7:	e9 2d f1 ff ff       	jmp    80106029 <alltraps>

80106efc <vector217>:
80106efc:	6a 00                	push   $0x0
80106efe:	68 d9 00 00 00       	push   $0xd9
80106f03:	e9 21 f1 ff ff       	jmp    80106029 <alltraps>

80106f08 <vector218>:
80106f08:	6a 00                	push   $0x0
80106f0a:	68 da 00 00 00       	push   $0xda
80106f0f:	e9 15 f1 ff ff       	jmp    80106029 <alltraps>

80106f14 <vector219>:
80106f14:	6a 00                	push   $0x0
80106f16:	68 db 00 00 00       	push   $0xdb
80106f1b:	e9 09 f1 ff ff       	jmp    80106029 <alltraps>

80106f20 <vector220>:
80106f20:	6a 00                	push   $0x0
80106f22:	68 dc 00 00 00       	push   $0xdc
80106f27:	e9 fd f0 ff ff       	jmp    80106029 <alltraps>

80106f2c <vector221>:
80106f2c:	6a 00                	push   $0x0
80106f2e:	68 dd 00 00 00       	push   $0xdd
80106f33:	e9 f1 f0 ff ff       	jmp    80106029 <alltraps>

80106f38 <vector222>:
80106f38:	6a 00                	push   $0x0
80106f3a:	68 de 00 00 00       	push   $0xde
80106f3f:	e9 e5 f0 ff ff       	jmp    80106029 <alltraps>

80106f44 <vector223>:
80106f44:	6a 00                	push   $0x0
80106f46:	68 df 00 00 00       	push   $0xdf
80106f4b:	e9 d9 f0 ff ff       	jmp    80106029 <alltraps>

80106f50 <vector224>:
80106f50:	6a 00                	push   $0x0
80106f52:	68 e0 00 00 00       	push   $0xe0
80106f57:	e9 cd f0 ff ff       	jmp    80106029 <alltraps>

80106f5c <vector225>:
80106f5c:	6a 00                	push   $0x0
80106f5e:	68 e1 00 00 00       	push   $0xe1
80106f63:	e9 c1 f0 ff ff       	jmp    80106029 <alltraps>

80106f68 <vector226>:
80106f68:	6a 00                	push   $0x0
80106f6a:	68 e2 00 00 00       	push   $0xe2
80106f6f:	e9 b5 f0 ff ff       	jmp    80106029 <alltraps>

80106f74 <vector227>:
80106f74:	6a 00                	push   $0x0
80106f76:	68 e3 00 00 00       	push   $0xe3
80106f7b:	e9 a9 f0 ff ff       	jmp    80106029 <alltraps>

80106f80 <vector228>:
80106f80:	6a 00                	push   $0x0
80106f82:	68 e4 00 00 00       	push   $0xe4
80106f87:	e9 9d f0 ff ff       	jmp    80106029 <alltraps>

80106f8c <vector229>:
80106f8c:	6a 00                	push   $0x0
80106f8e:	68 e5 00 00 00       	push   $0xe5
80106f93:	e9 91 f0 ff ff       	jmp    80106029 <alltraps>

80106f98 <vector230>:
80106f98:	6a 00                	push   $0x0
80106f9a:	68 e6 00 00 00       	push   $0xe6
80106f9f:	e9 85 f0 ff ff       	jmp    80106029 <alltraps>

80106fa4 <vector231>:
80106fa4:	6a 00                	push   $0x0
80106fa6:	68 e7 00 00 00       	push   $0xe7
80106fab:	e9 79 f0 ff ff       	jmp    80106029 <alltraps>

80106fb0 <vector232>:
80106fb0:	6a 00                	push   $0x0
80106fb2:	68 e8 00 00 00       	push   $0xe8
80106fb7:	e9 6d f0 ff ff       	jmp    80106029 <alltraps>

80106fbc <vector233>:
80106fbc:	6a 00                	push   $0x0
80106fbe:	68 e9 00 00 00       	push   $0xe9
80106fc3:	e9 61 f0 ff ff       	jmp    80106029 <alltraps>

80106fc8 <vector234>:
80106fc8:	6a 00                	push   $0x0
80106fca:	68 ea 00 00 00       	push   $0xea
80106fcf:	e9 55 f0 ff ff       	jmp    80106029 <alltraps>

80106fd4 <vector235>:
80106fd4:	6a 00                	push   $0x0
80106fd6:	68 eb 00 00 00       	push   $0xeb
80106fdb:	e9 49 f0 ff ff       	jmp    80106029 <alltraps>

80106fe0 <vector236>:
80106fe0:	6a 00                	push   $0x0
80106fe2:	68 ec 00 00 00       	push   $0xec
80106fe7:	e9 3d f0 ff ff       	jmp    80106029 <alltraps>

80106fec <vector237>:
80106fec:	6a 00                	push   $0x0
80106fee:	68 ed 00 00 00       	push   $0xed
80106ff3:	e9 31 f0 ff ff       	jmp    80106029 <alltraps>

80106ff8 <vector238>:
80106ff8:	6a 00                	push   $0x0
80106ffa:	68 ee 00 00 00       	push   $0xee
80106fff:	e9 25 f0 ff ff       	jmp    80106029 <alltraps>

80107004 <vector239>:
80107004:	6a 00                	push   $0x0
80107006:	68 ef 00 00 00       	push   $0xef
8010700b:	e9 19 f0 ff ff       	jmp    80106029 <alltraps>

80107010 <vector240>:
80107010:	6a 00                	push   $0x0
80107012:	68 f0 00 00 00       	push   $0xf0
80107017:	e9 0d f0 ff ff       	jmp    80106029 <alltraps>

8010701c <vector241>:
8010701c:	6a 00                	push   $0x0
8010701e:	68 f1 00 00 00       	push   $0xf1
80107023:	e9 01 f0 ff ff       	jmp    80106029 <alltraps>

80107028 <vector242>:
80107028:	6a 00                	push   $0x0
8010702a:	68 f2 00 00 00       	push   $0xf2
8010702f:	e9 f5 ef ff ff       	jmp    80106029 <alltraps>

80107034 <vector243>:
80107034:	6a 00                	push   $0x0
80107036:	68 f3 00 00 00       	push   $0xf3
8010703b:	e9 e9 ef ff ff       	jmp    80106029 <alltraps>

80107040 <vector244>:
80107040:	6a 00                	push   $0x0
80107042:	68 f4 00 00 00       	push   $0xf4
80107047:	e9 dd ef ff ff       	jmp    80106029 <alltraps>

8010704c <vector245>:
8010704c:	6a 00                	push   $0x0
8010704e:	68 f5 00 00 00       	push   $0xf5
80107053:	e9 d1 ef ff ff       	jmp    80106029 <alltraps>

80107058 <vector246>:
80107058:	6a 00                	push   $0x0
8010705a:	68 f6 00 00 00       	push   $0xf6
8010705f:	e9 c5 ef ff ff       	jmp    80106029 <alltraps>

80107064 <vector247>:
80107064:	6a 00                	push   $0x0
80107066:	68 f7 00 00 00       	push   $0xf7
8010706b:	e9 b9 ef ff ff       	jmp    80106029 <alltraps>

80107070 <vector248>:
80107070:	6a 00                	push   $0x0
80107072:	68 f8 00 00 00       	push   $0xf8
80107077:	e9 ad ef ff ff       	jmp    80106029 <alltraps>

8010707c <vector249>:
8010707c:	6a 00                	push   $0x0
8010707e:	68 f9 00 00 00       	push   $0xf9
80107083:	e9 a1 ef ff ff       	jmp    80106029 <alltraps>

80107088 <vector250>:
80107088:	6a 00                	push   $0x0
8010708a:	68 fa 00 00 00       	push   $0xfa
8010708f:	e9 95 ef ff ff       	jmp    80106029 <alltraps>

80107094 <vector251>:
80107094:	6a 00                	push   $0x0
80107096:	68 fb 00 00 00       	push   $0xfb
8010709b:	e9 89 ef ff ff       	jmp    80106029 <alltraps>

801070a0 <vector252>:
801070a0:	6a 00                	push   $0x0
801070a2:	68 fc 00 00 00       	push   $0xfc
801070a7:	e9 7d ef ff ff       	jmp    80106029 <alltraps>

801070ac <vector253>:
801070ac:	6a 00                	push   $0x0
801070ae:	68 fd 00 00 00       	push   $0xfd
801070b3:	e9 71 ef ff ff       	jmp    80106029 <alltraps>

801070b8 <vector254>:
801070b8:	6a 00                	push   $0x0
801070ba:	68 fe 00 00 00       	push   $0xfe
801070bf:	e9 65 ef ff ff       	jmp    80106029 <alltraps>

801070c4 <vector255>:
801070c4:	6a 00                	push   $0x0
801070c6:	68 ff 00 00 00       	push   $0xff
801070cb:	e9 59 ef ff ff       	jmp    80106029 <alltraps>

801070d0 <lgdt>:
{
801070d0:	55                   	push   %ebp
801070d1:	89 e5                	mov    %esp,%ebp
801070d3:	83 ec 10             	sub    $0x10,%esp
  pd[0] = size-1;
801070d6:	8b 45 0c             	mov    0xc(%ebp),%eax
801070d9:	83 e8 01             	sub    $0x1,%eax
801070dc:	66 89 45 fa          	mov    %ax,-0x6(%ebp)
  pd[1] = (uint)p;
801070e0:	8b 45 08             	mov    0x8(%ebp),%eax
801070e3:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  pd[2] = (uint)p >> 16;
801070e7:	8b 45 08             	mov    0x8(%ebp),%eax
801070ea:	c1 e8 10             	shr    $0x10,%eax
801070ed:	66 89 45 fe          	mov    %ax,-0x2(%ebp)
  asm volatile("lgdt (%0)" : : "r" (pd));
801070f1:	8d 45 fa             	lea    -0x6(%ebp),%eax
801070f4:	0f 01 10             	lgdtl  (%eax)
}
801070f7:	90                   	nop
801070f8:	c9                   	leave  
801070f9:	c3                   	ret    

801070fa <ltr>:
{
801070fa:	55                   	push   %ebp
801070fb:	89 e5                	mov    %esp,%ebp
801070fd:	83 ec 04             	sub    $0x4,%esp
80107100:	8b 45 08             	mov    0x8(%ebp),%eax
80107103:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  asm volatile("ltr %0" : : "r" (sel));
80107107:	0f b7 45 fc          	movzwl -0x4(%ebp),%eax
8010710b:	0f 00 d8             	ltr    %ax
}
8010710e:	90                   	nop
8010710f:	c9                   	leave  
80107110:	c3                   	ret    

80107111 <lcr3>:

static inline void
lcr3(uint val)
{
80107111:	55                   	push   %ebp
80107112:	89 e5                	mov    %esp,%ebp
  asm volatile("movl %0,%%cr3" : : "r" (val));
80107114:	8b 45 08             	mov    0x8(%ebp),%eax
80107117:	0f 22 d8             	mov    %eax,%cr3
}
8010711a:	90                   	nop
8010711b:	5d                   	pop    %ebp
8010711c:	c3                   	ret    

8010711d <seginit>:
extern struct gpu gpu;
// Set up CPU's kernel segment descriptors.
// Run once on entry on each CPU.
void
seginit(void)
{
8010711d:	55                   	push   %ebp
8010711e:	89 e5                	mov    %esp,%ebp
80107120:	83 ec 18             	sub    $0x18,%esp

  // Map "logical" addresses to virtual addresses using identity map.
  // Cannot share a CODE descriptor for both kernel and user
  // because it would have to have DPL_USR, but the CPU forbids
  // an interrupt from CPL=0 to DPL=3.
  c = &cpus[cpuid()];
80107123:	e8 75 c8 ff ff       	call   8010399d <cpuid>
80107128:	69 c0 b0 00 00 00    	imul   $0xb0,%eax,%eax
8010712e:	05 80 6b 19 80       	add    $0x80196b80,%eax
80107133:	89 45 f4             	mov    %eax,-0xc(%ebp)

  c->gdt[SEG_KCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, 0);
80107136:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107139:	66 c7 40 78 ff ff    	movw   $0xffff,0x78(%eax)
8010713f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107142:	66 c7 40 7a 00 00    	movw   $0x0,0x7a(%eax)
80107148:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010714b:	c6 40 7c 00          	movb   $0x0,0x7c(%eax)
8010714f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107152:	0f b6 50 7d          	movzbl 0x7d(%eax),%edx
80107156:	83 e2 f0             	and    $0xfffffff0,%edx
80107159:	83 ca 0a             	or     $0xa,%edx
8010715c:	88 50 7d             	mov    %dl,0x7d(%eax)
8010715f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107162:	0f b6 50 7d          	movzbl 0x7d(%eax),%edx
80107166:	83 ca 10             	or     $0x10,%edx
80107169:	88 50 7d             	mov    %dl,0x7d(%eax)
8010716c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010716f:	0f b6 50 7d          	movzbl 0x7d(%eax),%edx
80107173:	83 e2 9f             	and    $0xffffff9f,%edx
80107176:	88 50 7d             	mov    %dl,0x7d(%eax)
80107179:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010717c:	0f b6 50 7d          	movzbl 0x7d(%eax),%edx
80107180:	83 ca 80             	or     $0xffffff80,%edx
80107183:	88 50 7d             	mov    %dl,0x7d(%eax)
80107186:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107189:	0f b6 50 7e          	movzbl 0x7e(%eax),%edx
8010718d:	83 ca 0f             	or     $0xf,%edx
80107190:	88 50 7e             	mov    %dl,0x7e(%eax)
80107193:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107196:	0f b6 50 7e          	movzbl 0x7e(%eax),%edx
8010719a:	83 e2 ef             	and    $0xffffffef,%edx
8010719d:	88 50 7e             	mov    %dl,0x7e(%eax)
801071a0:	8b 45 f4             	mov    -0xc(%ebp),%eax
801071a3:	0f b6 50 7e          	movzbl 0x7e(%eax),%edx
801071a7:	83 e2 df             	and    $0xffffffdf,%edx
801071aa:	88 50 7e             	mov    %dl,0x7e(%eax)
801071ad:	8b 45 f4             	mov    -0xc(%ebp),%eax
801071b0:	0f b6 50 7e          	movzbl 0x7e(%eax),%edx
801071b4:	83 ca 40             	or     $0x40,%edx
801071b7:	88 50 7e             	mov    %dl,0x7e(%eax)
801071ba:	8b 45 f4             	mov    -0xc(%ebp),%eax
801071bd:	0f b6 50 7e          	movzbl 0x7e(%eax),%edx
801071c1:	83 ca 80             	or     $0xffffff80,%edx
801071c4:	88 50 7e             	mov    %dl,0x7e(%eax)
801071c7:	8b 45 f4             	mov    -0xc(%ebp),%eax
801071ca:	c6 40 7f 00          	movb   $0x0,0x7f(%eax)
  c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
801071ce:	8b 45 f4             	mov    -0xc(%ebp),%eax
801071d1:	66 c7 80 80 00 00 00 	movw   $0xffff,0x80(%eax)
801071d8:	ff ff 
801071da:	8b 45 f4             	mov    -0xc(%ebp),%eax
801071dd:	66 c7 80 82 00 00 00 	movw   $0x0,0x82(%eax)
801071e4:	00 00 
801071e6:	8b 45 f4             	mov    -0xc(%ebp),%eax
801071e9:	c6 80 84 00 00 00 00 	movb   $0x0,0x84(%eax)
801071f0:	8b 45 f4             	mov    -0xc(%ebp),%eax
801071f3:	0f b6 90 85 00 00 00 	movzbl 0x85(%eax),%edx
801071fa:	83 e2 f0             	and    $0xfffffff0,%edx
801071fd:	83 ca 02             	or     $0x2,%edx
80107200:	88 90 85 00 00 00    	mov    %dl,0x85(%eax)
80107206:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107209:	0f b6 90 85 00 00 00 	movzbl 0x85(%eax),%edx
80107210:	83 ca 10             	or     $0x10,%edx
80107213:	88 90 85 00 00 00    	mov    %dl,0x85(%eax)
80107219:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010721c:	0f b6 90 85 00 00 00 	movzbl 0x85(%eax),%edx
80107223:	83 e2 9f             	and    $0xffffff9f,%edx
80107226:	88 90 85 00 00 00    	mov    %dl,0x85(%eax)
8010722c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010722f:	0f b6 90 85 00 00 00 	movzbl 0x85(%eax),%edx
80107236:	83 ca 80             	or     $0xffffff80,%edx
80107239:	88 90 85 00 00 00    	mov    %dl,0x85(%eax)
8010723f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107242:	0f b6 90 86 00 00 00 	movzbl 0x86(%eax),%edx
80107249:	83 ca 0f             	or     $0xf,%edx
8010724c:	88 90 86 00 00 00    	mov    %dl,0x86(%eax)
80107252:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107255:	0f b6 90 86 00 00 00 	movzbl 0x86(%eax),%edx
8010725c:	83 e2 ef             	and    $0xffffffef,%edx
8010725f:	88 90 86 00 00 00    	mov    %dl,0x86(%eax)
80107265:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107268:	0f b6 90 86 00 00 00 	movzbl 0x86(%eax),%edx
8010726f:	83 e2 df             	and    $0xffffffdf,%edx
80107272:	88 90 86 00 00 00    	mov    %dl,0x86(%eax)
80107278:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010727b:	0f b6 90 86 00 00 00 	movzbl 0x86(%eax),%edx
80107282:	83 ca 40             	or     $0x40,%edx
80107285:	88 90 86 00 00 00    	mov    %dl,0x86(%eax)
8010728b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010728e:	0f b6 90 86 00 00 00 	movzbl 0x86(%eax),%edx
80107295:	83 ca 80             	or     $0xffffff80,%edx
80107298:	88 90 86 00 00 00    	mov    %dl,0x86(%eax)
8010729e:	8b 45 f4             	mov    -0xc(%ebp),%eax
801072a1:	c6 80 87 00 00 00 00 	movb   $0x0,0x87(%eax)
  c->gdt[SEG_UCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, DPL_USER);
801072a8:	8b 45 f4             	mov    -0xc(%ebp),%eax
801072ab:	66 c7 80 88 00 00 00 	movw   $0xffff,0x88(%eax)
801072b2:	ff ff 
801072b4:	8b 45 f4             	mov    -0xc(%ebp),%eax
801072b7:	66 c7 80 8a 00 00 00 	movw   $0x0,0x8a(%eax)
801072be:	00 00 
801072c0:	8b 45 f4             	mov    -0xc(%ebp),%eax
801072c3:	c6 80 8c 00 00 00 00 	movb   $0x0,0x8c(%eax)
801072ca:	8b 45 f4             	mov    -0xc(%ebp),%eax
801072cd:	0f b6 90 8d 00 00 00 	movzbl 0x8d(%eax),%edx
801072d4:	83 e2 f0             	and    $0xfffffff0,%edx
801072d7:	83 ca 0a             	or     $0xa,%edx
801072da:	88 90 8d 00 00 00    	mov    %dl,0x8d(%eax)
801072e0:	8b 45 f4             	mov    -0xc(%ebp),%eax
801072e3:	0f b6 90 8d 00 00 00 	movzbl 0x8d(%eax),%edx
801072ea:	83 ca 10             	or     $0x10,%edx
801072ed:	88 90 8d 00 00 00    	mov    %dl,0x8d(%eax)
801072f3:	8b 45 f4             	mov    -0xc(%ebp),%eax
801072f6:	0f b6 90 8d 00 00 00 	movzbl 0x8d(%eax),%edx
801072fd:	83 ca 60             	or     $0x60,%edx
80107300:	88 90 8d 00 00 00    	mov    %dl,0x8d(%eax)
80107306:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107309:	0f b6 90 8d 00 00 00 	movzbl 0x8d(%eax),%edx
80107310:	83 ca 80             	or     $0xffffff80,%edx
80107313:	88 90 8d 00 00 00    	mov    %dl,0x8d(%eax)
80107319:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010731c:	0f b6 90 8e 00 00 00 	movzbl 0x8e(%eax),%edx
80107323:	83 ca 0f             	or     $0xf,%edx
80107326:	88 90 8e 00 00 00    	mov    %dl,0x8e(%eax)
8010732c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010732f:	0f b6 90 8e 00 00 00 	movzbl 0x8e(%eax),%edx
80107336:	83 e2 ef             	and    $0xffffffef,%edx
80107339:	88 90 8e 00 00 00    	mov    %dl,0x8e(%eax)
8010733f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107342:	0f b6 90 8e 00 00 00 	movzbl 0x8e(%eax),%edx
80107349:	83 e2 df             	and    $0xffffffdf,%edx
8010734c:	88 90 8e 00 00 00    	mov    %dl,0x8e(%eax)
80107352:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107355:	0f b6 90 8e 00 00 00 	movzbl 0x8e(%eax),%edx
8010735c:	83 ca 40             	or     $0x40,%edx
8010735f:	88 90 8e 00 00 00    	mov    %dl,0x8e(%eax)
80107365:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107368:	0f b6 90 8e 00 00 00 	movzbl 0x8e(%eax),%edx
8010736f:	83 ca 80             	or     $0xffffff80,%edx
80107372:	88 90 8e 00 00 00    	mov    %dl,0x8e(%eax)
80107378:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010737b:	c6 80 8f 00 00 00 00 	movb   $0x0,0x8f(%eax)
  c->gdt[SEG_UDATA] = SEG(STA_W, 0, 0xffffffff, DPL_USER);
80107382:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107385:	66 c7 80 90 00 00 00 	movw   $0xffff,0x90(%eax)
8010738c:	ff ff 
8010738e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107391:	66 c7 80 92 00 00 00 	movw   $0x0,0x92(%eax)
80107398:	00 00 
8010739a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010739d:	c6 80 94 00 00 00 00 	movb   $0x0,0x94(%eax)
801073a4:	8b 45 f4             	mov    -0xc(%ebp),%eax
801073a7:	0f b6 90 95 00 00 00 	movzbl 0x95(%eax),%edx
801073ae:	83 e2 f0             	and    $0xfffffff0,%edx
801073b1:	83 ca 02             	or     $0x2,%edx
801073b4:	88 90 95 00 00 00    	mov    %dl,0x95(%eax)
801073ba:	8b 45 f4             	mov    -0xc(%ebp),%eax
801073bd:	0f b6 90 95 00 00 00 	movzbl 0x95(%eax),%edx
801073c4:	83 ca 10             	or     $0x10,%edx
801073c7:	88 90 95 00 00 00    	mov    %dl,0x95(%eax)
801073cd:	8b 45 f4             	mov    -0xc(%ebp),%eax
801073d0:	0f b6 90 95 00 00 00 	movzbl 0x95(%eax),%edx
801073d7:	83 ca 60             	or     $0x60,%edx
801073da:	88 90 95 00 00 00    	mov    %dl,0x95(%eax)
801073e0:	8b 45 f4             	mov    -0xc(%ebp),%eax
801073e3:	0f b6 90 95 00 00 00 	movzbl 0x95(%eax),%edx
801073ea:	83 ca 80             	or     $0xffffff80,%edx
801073ed:	88 90 95 00 00 00    	mov    %dl,0x95(%eax)
801073f3:	8b 45 f4             	mov    -0xc(%ebp),%eax
801073f6:	0f b6 90 96 00 00 00 	movzbl 0x96(%eax),%edx
801073fd:	83 ca 0f             	or     $0xf,%edx
80107400:	88 90 96 00 00 00    	mov    %dl,0x96(%eax)
80107406:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107409:	0f b6 90 96 00 00 00 	movzbl 0x96(%eax),%edx
80107410:	83 e2 ef             	and    $0xffffffef,%edx
80107413:	88 90 96 00 00 00    	mov    %dl,0x96(%eax)
80107419:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010741c:	0f b6 90 96 00 00 00 	movzbl 0x96(%eax),%edx
80107423:	83 e2 df             	and    $0xffffffdf,%edx
80107426:	88 90 96 00 00 00    	mov    %dl,0x96(%eax)
8010742c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010742f:	0f b6 90 96 00 00 00 	movzbl 0x96(%eax),%edx
80107436:	83 ca 40             	or     $0x40,%edx
80107439:	88 90 96 00 00 00    	mov    %dl,0x96(%eax)
8010743f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107442:	0f b6 90 96 00 00 00 	movzbl 0x96(%eax),%edx
80107449:	83 ca 80             	or     $0xffffff80,%edx
8010744c:	88 90 96 00 00 00    	mov    %dl,0x96(%eax)
80107452:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107455:	c6 80 97 00 00 00 00 	movb   $0x0,0x97(%eax)
  lgdt(c->gdt, sizeof(c->gdt));
8010745c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010745f:	83 c0 70             	add    $0x70,%eax
80107462:	83 ec 08             	sub    $0x8,%esp
80107465:	6a 30                	push   $0x30
80107467:	50                   	push   %eax
80107468:	e8 63 fc ff ff       	call   801070d0 <lgdt>
8010746d:	83 c4 10             	add    $0x10,%esp
}
80107470:	90                   	nop
80107471:	c9                   	leave  
80107472:	c3                   	ret    

80107473 <walkpgdir>:
// Return the address of the PTE in page table pgdir
// that corresponds to virtual address va.  If alloc!=0,
// create any required page table pages.
static pte_t *
walkpgdir(pde_t *pgdir, const void *va, int alloc)
{
80107473:	55                   	push   %ebp
80107474:	89 e5                	mov    %esp,%ebp
80107476:	83 ec 18             	sub    $0x18,%esp
  pde_t *pde;
  pte_t *pgtab;

  pde = &pgdir[PDX(va)];
80107479:	8b 45 0c             	mov    0xc(%ebp),%eax
8010747c:	c1 e8 16             	shr    $0x16,%eax
8010747f:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80107486:	8b 45 08             	mov    0x8(%ebp),%eax
80107489:	01 d0                	add    %edx,%eax
8010748b:	89 45 f0             	mov    %eax,-0x10(%ebp)
  if(*pde & PTE_P){
8010748e:	8b 45 f0             	mov    -0x10(%ebp),%eax
80107491:	8b 00                	mov    (%eax),%eax
80107493:	83 e0 01             	and    $0x1,%eax
80107496:	85 c0                	test   %eax,%eax
80107498:	74 14                	je     801074ae <walkpgdir+0x3b>
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
8010749a:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010749d:	8b 00                	mov    (%eax),%eax
8010749f:	25 00 f0 ff ff       	and    $0xfffff000,%eax
801074a4:	05 00 00 00 80       	add    $0x80000000,%eax
801074a9:	89 45 f4             	mov    %eax,-0xc(%ebp)
801074ac:	eb 42                	jmp    801074f0 <walkpgdir+0x7d>
  } else {
    if(!alloc || (pgtab = (pte_t*)kalloc()) == 0)
801074ae:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
801074b2:	74 0e                	je     801074c2 <walkpgdir+0x4f>
801074b4:	e8 e7 b2 ff ff       	call   801027a0 <kalloc>
801074b9:	89 45 f4             	mov    %eax,-0xc(%ebp)
801074bc:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801074c0:	75 07                	jne    801074c9 <walkpgdir+0x56>
      return 0;
801074c2:	b8 00 00 00 00       	mov    $0x0,%eax
801074c7:	eb 3e                	jmp    80107507 <walkpgdir+0x94>
    // Make sure all those PTE_P bits are zero.
    memset(pgtab, 0, PGSIZE);
801074c9:	83 ec 04             	sub    $0x4,%esp
801074cc:	68 00 10 00 00       	push   $0x1000
801074d1:	6a 00                	push   $0x0
801074d3:	ff 75 f4             	push   -0xc(%ebp)
801074d6:	e8 3f d7 ff ff       	call   80104c1a <memset>
801074db:	83 c4 10             	add    $0x10,%esp
    // The permissions here are overly generous, but they can
    // be further restricted by the permissions in the page table
    // entries, if necessary.
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
801074de:	8b 45 f4             	mov    -0xc(%ebp),%eax
801074e1:	05 00 00 00 80       	add    $0x80000000,%eax
801074e6:	83 c8 07             	or     $0x7,%eax
801074e9:	89 c2                	mov    %eax,%edx
801074eb:	8b 45 f0             	mov    -0x10(%ebp),%eax
801074ee:	89 10                	mov    %edx,(%eax)
  }
  return &pgtab[PTX(va)];
801074f0:	8b 45 0c             	mov    0xc(%ebp),%eax
801074f3:	c1 e8 0c             	shr    $0xc,%eax
801074f6:	25 ff 03 00 00       	and    $0x3ff,%eax
801074fb:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80107502:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107505:	01 d0                	add    %edx,%eax
}
80107507:	c9                   	leave  
80107508:	c3                   	ret    

80107509 <mappages>:
// Create PTEs for virtual addresses starting at va that refer to
// physical addresses starting at pa. va and size might not
// be page-aligned.
static int
mappages(pde_t *pgdir, void *va, uint size, uint pa, int perm)
{
80107509:	55                   	push   %ebp
8010750a:	89 e5                	mov    %esp,%ebp
8010750c:	83 ec 18             	sub    $0x18,%esp
  char *a, *last;
  pte_t *pte;

  a = (char*)PGROUNDDOWN((uint)va);
8010750f:	8b 45 0c             	mov    0xc(%ebp),%eax
80107512:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80107517:	89 45 f4             	mov    %eax,-0xc(%ebp)
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
8010751a:	8b 55 0c             	mov    0xc(%ebp),%edx
8010751d:	8b 45 10             	mov    0x10(%ebp),%eax
80107520:	01 d0                	add    %edx,%eax
80107522:	83 e8 01             	sub    $0x1,%eax
80107525:	25 00 f0 ff ff       	and    $0xfffff000,%eax
8010752a:	89 45 f0             	mov    %eax,-0x10(%ebp)
  for(;;){
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
8010752d:	83 ec 04             	sub    $0x4,%esp
80107530:	6a 01                	push   $0x1
80107532:	ff 75 f4             	push   -0xc(%ebp)
80107535:	ff 75 08             	push   0x8(%ebp)
80107538:	e8 36 ff ff ff       	call   80107473 <walkpgdir>
8010753d:	83 c4 10             	add    $0x10,%esp
80107540:	89 45 ec             	mov    %eax,-0x14(%ebp)
80107543:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
80107547:	75 07                	jne    80107550 <mappages+0x47>
      return -1;
80107549:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010754e:	eb 47                	jmp    80107597 <mappages+0x8e>
    if(*pte & PTE_P)
80107550:	8b 45 ec             	mov    -0x14(%ebp),%eax
80107553:	8b 00                	mov    (%eax),%eax
80107555:	83 e0 01             	and    $0x1,%eax
80107558:	85 c0                	test   %eax,%eax
8010755a:	74 0d                	je     80107569 <mappages+0x60>
      panic("remap");
8010755c:	83 ec 0c             	sub    $0xc,%esp
8010755f:	68 28 a8 10 80       	push   $0x8010a828
80107564:	e8 40 90 ff ff       	call   801005a9 <panic>
    *pte = pa | perm | PTE_P;
80107569:	8b 45 18             	mov    0x18(%ebp),%eax
8010756c:	0b 45 14             	or     0x14(%ebp),%eax
8010756f:	83 c8 01             	or     $0x1,%eax
80107572:	89 c2                	mov    %eax,%edx
80107574:	8b 45 ec             	mov    -0x14(%ebp),%eax
80107577:	89 10                	mov    %edx,(%eax)
    if(a == last)
80107579:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010757c:	3b 45 f0             	cmp    -0x10(%ebp),%eax
8010757f:	74 10                	je     80107591 <mappages+0x88>
      break;
    a += PGSIZE;
80107581:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
    pa += PGSIZE;
80107588:	81 45 14 00 10 00 00 	addl   $0x1000,0x14(%ebp)
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
8010758f:	eb 9c                	jmp    8010752d <mappages+0x24>
      break;
80107591:	90                   	nop
  }
  return 0;
80107592:	b8 00 00 00 00       	mov    $0x0,%eax
}
80107597:	c9                   	leave  
80107598:	c3                   	ret    

80107599 <setupkvm>:
};

// Set up kernel part of a page table.
pde_t*
setupkvm(void)
{
80107599:	55                   	push   %ebp
8010759a:	89 e5                	mov    %esp,%ebp
8010759c:	53                   	push   %ebx
8010759d:	83 ec 24             	sub    $0x24,%esp
  pde_t *pgdir;
  struct kmap *k;
  k = kmap;
801075a0:	c7 45 f4 a0 f4 10 80 	movl   $0x8010f4a0,-0xc(%ebp)
  struct kmap vram = { (void*)(DEVSPACE - gpu.vram_size),gpu.pvram_addr,gpu.pvram_addr+gpu.vram_size, PTE_W};
801075a7:	8b 15 50 6e 19 80    	mov    0x80196e50,%edx
801075ad:	b8 00 00 00 fe       	mov    $0xfe000000,%eax
801075b2:	29 d0                	sub    %edx,%eax
801075b4:	89 45 e0             	mov    %eax,-0x20(%ebp)
801075b7:	a1 48 6e 19 80       	mov    0x80196e48,%eax
801075bc:	89 45 e4             	mov    %eax,-0x1c(%ebp)
801075bf:	8b 15 48 6e 19 80    	mov    0x80196e48,%edx
801075c5:	a1 50 6e 19 80       	mov    0x80196e50,%eax
801075ca:	01 d0                	add    %edx,%eax
801075cc:	89 45 e8             	mov    %eax,-0x18(%ebp)
801075cf:	c7 45 ec 02 00 00 00 	movl   $0x2,-0x14(%ebp)
  k[3] = vram;
801075d6:	8b 45 f4             	mov    -0xc(%ebp),%eax
801075d9:	83 c0 30             	add    $0x30,%eax
801075dc:	8b 55 e0             	mov    -0x20(%ebp),%edx
801075df:	89 10                	mov    %edx,(%eax)
801075e1:	8b 55 e4             	mov    -0x1c(%ebp),%edx
801075e4:	89 50 04             	mov    %edx,0x4(%eax)
801075e7:	8b 55 e8             	mov    -0x18(%ebp),%edx
801075ea:	89 50 08             	mov    %edx,0x8(%eax)
801075ed:	8b 55 ec             	mov    -0x14(%ebp),%edx
801075f0:	89 50 0c             	mov    %edx,0xc(%eax)
  if((pgdir = (pde_t*)kalloc()) == 0){
801075f3:	e8 a8 b1 ff ff       	call   801027a0 <kalloc>
801075f8:	89 45 f0             	mov    %eax,-0x10(%ebp)
801075fb:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
801075ff:	75 07                	jne    80107608 <setupkvm+0x6f>
    return 0;
80107601:	b8 00 00 00 00       	mov    $0x0,%eax
80107606:	eb 78                	jmp    80107680 <setupkvm+0xe7>
  }
  memset(pgdir, 0, PGSIZE);
80107608:	83 ec 04             	sub    $0x4,%esp
8010760b:	68 00 10 00 00       	push   $0x1000
80107610:	6a 00                	push   $0x0
80107612:	ff 75 f0             	push   -0x10(%ebp)
80107615:	e8 00 d6 ff ff       	call   80104c1a <memset>
8010761a:	83 c4 10             	add    $0x10,%esp
  if (P2V(PHYSTOP) > (void*)DEVSPACE)
    panic("PHYSTOP too high");
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
8010761d:	c7 45 f4 a0 f4 10 80 	movl   $0x8010f4a0,-0xc(%ebp)
80107624:	eb 4e                	jmp    80107674 <setupkvm+0xdb>
    if(mappages(pgdir, k->virt, k->phys_end - k->phys_start,
80107626:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107629:	8b 48 0c             	mov    0xc(%eax),%ecx
                (uint)k->phys_start, k->perm) < 0) {
8010762c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010762f:	8b 50 04             	mov    0x4(%eax),%edx
    if(mappages(pgdir, k->virt, k->phys_end - k->phys_start,
80107632:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107635:	8b 58 08             	mov    0x8(%eax),%ebx
80107638:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010763b:	8b 40 04             	mov    0x4(%eax),%eax
8010763e:	29 c3                	sub    %eax,%ebx
80107640:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107643:	8b 00                	mov    (%eax),%eax
80107645:	83 ec 0c             	sub    $0xc,%esp
80107648:	51                   	push   %ecx
80107649:	52                   	push   %edx
8010764a:	53                   	push   %ebx
8010764b:	50                   	push   %eax
8010764c:	ff 75 f0             	push   -0x10(%ebp)
8010764f:	e8 b5 fe ff ff       	call   80107509 <mappages>
80107654:	83 c4 20             	add    $0x20,%esp
80107657:	85 c0                	test   %eax,%eax
80107659:	79 15                	jns    80107670 <setupkvm+0xd7>
      freevm(pgdir);
8010765b:	83 ec 0c             	sub    $0xc,%esp
8010765e:	ff 75 f0             	push   -0x10(%ebp)
80107661:	e8 f5 04 00 00       	call   80107b5b <freevm>
80107666:	83 c4 10             	add    $0x10,%esp
      return 0;
80107669:	b8 00 00 00 00       	mov    $0x0,%eax
8010766e:	eb 10                	jmp    80107680 <setupkvm+0xe7>
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
80107670:	83 45 f4 10          	addl   $0x10,-0xc(%ebp)
80107674:	81 7d f4 00 f5 10 80 	cmpl   $0x8010f500,-0xc(%ebp)
8010767b:	72 a9                	jb     80107626 <setupkvm+0x8d>
    }
  return pgdir;
8010767d:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
80107680:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80107683:	c9                   	leave  
80107684:	c3                   	ret    

80107685 <kvmalloc>:

// Allocate one page table for the machine for the kernel address
// space for scheduler processes.
void
kvmalloc(void)
{
80107685:	55                   	push   %ebp
80107686:	89 e5                	mov    %esp,%ebp
80107688:	83 ec 08             	sub    $0x8,%esp
  kpgdir = setupkvm();
8010768b:	e8 09 ff ff ff       	call   80107599 <setupkvm>
80107690:	a3 7c 6b 19 80       	mov    %eax,0x80196b7c
  switchkvm();
80107695:	e8 03 00 00 00       	call   8010769d <switchkvm>
}
8010769a:	90                   	nop
8010769b:	c9                   	leave  
8010769c:	c3                   	ret    

8010769d <switchkvm>:

// Switch h/w page table register to the kernel-only page table,
// for when no process is running.
void
switchkvm(void)
{
8010769d:	55                   	push   %ebp
8010769e:	89 e5                	mov    %esp,%ebp
  lcr3(V2P(kpgdir));   // switch to the kernel page table
801076a0:	a1 7c 6b 19 80       	mov    0x80196b7c,%eax
801076a5:	05 00 00 00 80       	add    $0x80000000,%eax
801076aa:	50                   	push   %eax
801076ab:	e8 61 fa ff ff       	call   80107111 <lcr3>
801076b0:	83 c4 04             	add    $0x4,%esp
}
801076b3:	90                   	nop
801076b4:	c9                   	leave  
801076b5:	c3                   	ret    

801076b6 <switchuvm>:

// Switch TSS and h/w page table to correspond to process p.
void
switchuvm(struct proc *p)
{
801076b6:	55                   	push   %ebp
801076b7:	89 e5                	mov    %esp,%ebp
801076b9:	56                   	push   %esi
801076ba:	53                   	push   %ebx
801076bb:	83 ec 10             	sub    $0x10,%esp
  if(p == 0)
801076be:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
801076c2:	75 0d                	jne    801076d1 <switchuvm+0x1b>
    panic("switchuvm: no process");
801076c4:	83 ec 0c             	sub    $0xc,%esp
801076c7:	68 2e a8 10 80       	push   $0x8010a82e
801076cc:	e8 d8 8e ff ff       	call   801005a9 <panic>
  if(p->kstack == 0)
801076d1:	8b 45 08             	mov    0x8(%ebp),%eax
801076d4:	8b 40 08             	mov    0x8(%eax),%eax
801076d7:	85 c0                	test   %eax,%eax
801076d9:	75 0d                	jne    801076e8 <switchuvm+0x32>
    panic("switchuvm: no kstack");
801076db:	83 ec 0c             	sub    $0xc,%esp
801076de:	68 44 a8 10 80       	push   $0x8010a844
801076e3:	e8 c1 8e ff ff       	call   801005a9 <panic>
  if(p->pgdir == 0)
801076e8:	8b 45 08             	mov    0x8(%ebp),%eax
801076eb:	8b 40 04             	mov    0x4(%eax),%eax
801076ee:	85 c0                	test   %eax,%eax
801076f0:	75 0d                	jne    801076ff <switchuvm+0x49>
    panic("switchuvm: no pgdir");
801076f2:	83 ec 0c             	sub    $0xc,%esp
801076f5:	68 59 a8 10 80       	push   $0x8010a859
801076fa:	e8 aa 8e ff ff       	call   801005a9 <panic>

  pushcli();
801076ff:	e8 0b d4 ff ff       	call   80104b0f <pushcli>
  mycpu()->gdt[SEG_TSS] = SEG16(STS_T32A, &mycpu()->ts,
80107704:	e8 af c2 ff ff       	call   801039b8 <mycpu>
80107709:	89 c3                	mov    %eax,%ebx
8010770b:	e8 a8 c2 ff ff       	call   801039b8 <mycpu>
80107710:	83 c0 08             	add    $0x8,%eax
80107713:	89 c6                	mov    %eax,%esi
80107715:	e8 9e c2 ff ff       	call   801039b8 <mycpu>
8010771a:	83 c0 08             	add    $0x8,%eax
8010771d:	c1 e8 10             	shr    $0x10,%eax
80107720:	88 45 f7             	mov    %al,-0x9(%ebp)
80107723:	e8 90 c2 ff ff       	call   801039b8 <mycpu>
80107728:	83 c0 08             	add    $0x8,%eax
8010772b:	c1 e8 18             	shr    $0x18,%eax
8010772e:	89 c2                	mov    %eax,%edx
80107730:	66 c7 83 98 00 00 00 	movw   $0x67,0x98(%ebx)
80107737:	67 00 
80107739:	66 89 b3 9a 00 00 00 	mov    %si,0x9a(%ebx)
80107740:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
80107744:	88 83 9c 00 00 00    	mov    %al,0x9c(%ebx)
8010774a:	0f b6 83 9d 00 00 00 	movzbl 0x9d(%ebx),%eax
80107751:	83 e0 f0             	and    $0xfffffff0,%eax
80107754:	83 c8 09             	or     $0x9,%eax
80107757:	88 83 9d 00 00 00    	mov    %al,0x9d(%ebx)
8010775d:	0f b6 83 9d 00 00 00 	movzbl 0x9d(%ebx),%eax
80107764:	83 c8 10             	or     $0x10,%eax
80107767:	88 83 9d 00 00 00    	mov    %al,0x9d(%ebx)
8010776d:	0f b6 83 9d 00 00 00 	movzbl 0x9d(%ebx),%eax
80107774:	83 e0 9f             	and    $0xffffff9f,%eax
80107777:	88 83 9d 00 00 00    	mov    %al,0x9d(%ebx)
8010777d:	0f b6 83 9d 00 00 00 	movzbl 0x9d(%ebx),%eax
80107784:	83 c8 80             	or     $0xffffff80,%eax
80107787:	88 83 9d 00 00 00    	mov    %al,0x9d(%ebx)
8010778d:	0f b6 83 9e 00 00 00 	movzbl 0x9e(%ebx),%eax
80107794:	83 e0 f0             	and    $0xfffffff0,%eax
80107797:	88 83 9e 00 00 00    	mov    %al,0x9e(%ebx)
8010779d:	0f b6 83 9e 00 00 00 	movzbl 0x9e(%ebx),%eax
801077a4:	83 e0 ef             	and    $0xffffffef,%eax
801077a7:	88 83 9e 00 00 00    	mov    %al,0x9e(%ebx)
801077ad:	0f b6 83 9e 00 00 00 	movzbl 0x9e(%ebx),%eax
801077b4:	83 e0 df             	and    $0xffffffdf,%eax
801077b7:	88 83 9e 00 00 00    	mov    %al,0x9e(%ebx)
801077bd:	0f b6 83 9e 00 00 00 	movzbl 0x9e(%ebx),%eax
801077c4:	83 c8 40             	or     $0x40,%eax
801077c7:	88 83 9e 00 00 00    	mov    %al,0x9e(%ebx)
801077cd:	0f b6 83 9e 00 00 00 	movzbl 0x9e(%ebx),%eax
801077d4:	83 e0 7f             	and    $0x7f,%eax
801077d7:	88 83 9e 00 00 00    	mov    %al,0x9e(%ebx)
801077dd:	88 93 9f 00 00 00    	mov    %dl,0x9f(%ebx)
                                sizeof(mycpu()->ts)-1, 0);
  mycpu()->gdt[SEG_TSS].s = 0;
801077e3:	e8 d0 c1 ff ff       	call   801039b8 <mycpu>
801077e8:	0f b6 90 9d 00 00 00 	movzbl 0x9d(%eax),%edx
801077ef:	83 e2 ef             	and    $0xffffffef,%edx
801077f2:	88 90 9d 00 00 00    	mov    %dl,0x9d(%eax)
  mycpu()->ts.ss0 = SEG_KDATA << 3;
801077f8:	e8 bb c1 ff ff       	call   801039b8 <mycpu>
801077fd:	66 c7 40 10 10 00    	movw   $0x10,0x10(%eax)
  mycpu()->ts.esp0 = (uint)p->kstack + KSTACKSIZE;
80107803:	8b 45 08             	mov    0x8(%ebp),%eax
80107806:	8b 40 08             	mov    0x8(%eax),%eax
80107809:	89 c3                	mov    %eax,%ebx
8010780b:	e8 a8 c1 ff ff       	call   801039b8 <mycpu>
80107810:	8d 93 00 10 00 00    	lea    0x1000(%ebx),%edx
80107816:	89 50 0c             	mov    %edx,0xc(%eax)
  // setting IOPL=0 in eflags *and* iomb beyond the tss segment limit
  // forbids I/O instructions (e.g., inb and outb) from user space
  mycpu()->ts.iomb = (ushort) 0xFFFF;
80107819:	e8 9a c1 ff ff       	call   801039b8 <mycpu>
8010781e:	66 c7 40 6e ff ff    	movw   $0xffff,0x6e(%eax)
  ltr(SEG_TSS << 3);
80107824:	83 ec 0c             	sub    $0xc,%esp
80107827:	6a 28                	push   $0x28
80107829:	e8 cc f8 ff ff       	call   801070fa <ltr>
8010782e:	83 c4 10             	add    $0x10,%esp
  lcr3(V2P(p->pgdir));  // switch to process's address space
80107831:	8b 45 08             	mov    0x8(%ebp),%eax
80107834:	8b 40 04             	mov    0x4(%eax),%eax
80107837:	05 00 00 00 80       	add    $0x80000000,%eax
8010783c:	83 ec 0c             	sub    $0xc,%esp
8010783f:	50                   	push   %eax
80107840:	e8 cc f8 ff ff       	call   80107111 <lcr3>
80107845:	83 c4 10             	add    $0x10,%esp
  popcli();
80107848:	e8 0f d3 ff ff       	call   80104b5c <popcli>
}
8010784d:	90                   	nop
8010784e:	8d 65 f8             	lea    -0x8(%ebp),%esp
80107851:	5b                   	pop    %ebx
80107852:	5e                   	pop    %esi
80107853:	5d                   	pop    %ebp
80107854:	c3                   	ret    

80107855 <inituvm>:

// Load the initcode into address 0 of pgdir.
// sz must be less than a page.
void
inituvm(pde_t *pgdir, char *init, uint sz)
{
80107855:	55                   	push   %ebp
80107856:	89 e5                	mov    %esp,%ebp
80107858:	83 ec 18             	sub    $0x18,%esp
  char *mem;

  if(sz >= PGSIZE)
8010785b:	81 7d 10 ff 0f 00 00 	cmpl   $0xfff,0x10(%ebp)
80107862:	76 0d                	jbe    80107871 <inituvm+0x1c>
    panic("inituvm: more than a page");
80107864:	83 ec 0c             	sub    $0xc,%esp
80107867:	68 6d a8 10 80       	push   $0x8010a86d
8010786c:	e8 38 8d ff ff       	call   801005a9 <panic>
  mem = kalloc();
80107871:	e8 2a af ff ff       	call   801027a0 <kalloc>
80107876:	89 45 f4             	mov    %eax,-0xc(%ebp)
  memset(mem, 0, PGSIZE);
80107879:	83 ec 04             	sub    $0x4,%esp
8010787c:	68 00 10 00 00       	push   $0x1000
80107881:	6a 00                	push   $0x0
80107883:	ff 75 f4             	push   -0xc(%ebp)
80107886:	e8 8f d3 ff ff       	call   80104c1a <memset>
8010788b:	83 c4 10             	add    $0x10,%esp
  mappages(pgdir, 0, PGSIZE, V2P(mem), PTE_W|PTE_U);
8010788e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107891:	05 00 00 00 80       	add    $0x80000000,%eax
80107896:	83 ec 0c             	sub    $0xc,%esp
80107899:	6a 06                	push   $0x6
8010789b:	50                   	push   %eax
8010789c:	68 00 10 00 00       	push   $0x1000
801078a1:	6a 00                	push   $0x0
801078a3:	ff 75 08             	push   0x8(%ebp)
801078a6:	e8 5e fc ff ff       	call   80107509 <mappages>
801078ab:	83 c4 20             	add    $0x20,%esp
  memmove(mem, init, sz);
801078ae:	83 ec 04             	sub    $0x4,%esp
801078b1:	ff 75 10             	push   0x10(%ebp)
801078b4:	ff 75 0c             	push   0xc(%ebp)
801078b7:	ff 75 f4             	push   -0xc(%ebp)
801078ba:	e8 1a d4 ff ff       	call   80104cd9 <memmove>
801078bf:	83 c4 10             	add    $0x10,%esp
}
801078c2:	90                   	nop
801078c3:	c9                   	leave  
801078c4:	c3                   	ret    

801078c5 <loaduvm>:

// Load a program segment into pgdir.  addr must be page-aligned
// and the pages from addr to addr+sz must already be mapped.
int
loaduvm(pde_t *pgdir, char *addr, struct inode *ip, uint offset, uint sz)
{
801078c5:	55                   	push   %ebp
801078c6:	89 e5                	mov    %esp,%ebp
801078c8:	83 ec 18             	sub    $0x18,%esp
  uint i, pa, n;
  pte_t *pte;

  if((uint) addr % PGSIZE != 0)
801078cb:	8b 45 0c             	mov    0xc(%ebp),%eax
801078ce:	25 ff 0f 00 00       	and    $0xfff,%eax
801078d3:	85 c0                	test   %eax,%eax
801078d5:	74 0d                	je     801078e4 <loaduvm+0x1f>
    panic("loaduvm: addr must be page aligned");
801078d7:	83 ec 0c             	sub    $0xc,%esp
801078da:	68 88 a8 10 80       	push   $0x8010a888
801078df:	e8 c5 8c ff ff       	call   801005a9 <panic>
  for(i = 0; i < sz; i += PGSIZE){
801078e4:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
801078eb:	e9 8f 00 00 00       	jmp    8010797f <loaduvm+0xba>
    if((pte = walkpgdir(pgdir, addr+i, 0)) == 0)
801078f0:	8b 55 0c             	mov    0xc(%ebp),%edx
801078f3:	8b 45 f4             	mov    -0xc(%ebp),%eax
801078f6:	01 d0                	add    %edx,%eax
801078f8:	83 ec 04             	sub    $0x4,%esp
801078fb:	6a 00                	push   $0x0
801078fd:	50                   	push   %eax
801078fe:	ff 75 08             	push   0x8(%ebp)
80107901:	e8 6d fb ff ff       	call   80107473 <walkpgdir>
80107906:	83 c4 10             	add    $0x10,%esp
80107909:	89 45 ec             	mov    %eax,-0x14(%ebp)
8010790c:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
80107910:	75 0d                	jne    8010791f <loaduvm+0x5a>
      panic("loaduvm: address should exist");
80107912:	83 ec 0c             	sub    $0xc,%esp
80107915:	68 ab a8 10 80       	push   $0x8010a8ab
8010791a:	e8 8a 8c ff ff       	call   801005a9 <panic>
    pa = PTE_ADDR(*pte);
8010791f:	8b 45 ec             	mov    -0x14(%ebp),%eax
80107922:	8b 00                	mov    (%eax),%eax
80107924:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80107929:	89 45 e8             	mov    %eax,-0x18(%ebp)
    if(sz - i < PGSIZE)
8010792c:	8b 45 18             	mov    0x18(%ebp),%eax
8010792f:	2b 45 f4             	sub    -0xc(%ebp),%eax
80107932:	3d ff 0f 00 00       	cmp    $0xfff,%eax
80107937:	77 0b                	ja     80107944 <loaduvm+0x7f>
      n = sz - i;
80107939:	8b 45 18             	mov    0x18(%ebp),%eax
8010793c:	2b 45 f4             	sub    -0xc(%ebp),%eax
8010793f:	89 45 f0             	mov    %eax,-0x10(%ebp)
80107942:	eb 07                	jmp    8010794b <loaduvm+0x86>
    else
      n = PGSIZE;
80107944:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
    if(readi(ip, P2V(pa), offset+i, n) != n)
8010794b:	8b 55 14             	mov    0x14(%ebp),%edx
8010794e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107951:	01 d0                	add    %edx,%eax
80107953:	8b 55 e8             	mov    -0x18(%ebp),%edx
80107956:	81 c2 00 00 00 80    	add    $0x80000000,%edx
8010795c:	ff 75 f0             	push   -0x10(%ebp)
8010795f:	50                   	push   %eax
80107960:	52                   	push   %edx
80107961:	ff 75 10             	push   0x10(%ebp)
80107964:	e8 6d a5 ff ff       	call   80101ed6 <readi>
80107969:	83 c4 10             	add    $0x10,%esp
8010796c:	39 45 f0             	cmp    %eax,-0x10(%ebp)
8010796f:	74 07                	je     80107978 <loaduvm+0xb3>
      return -1;
80107971:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80107976:	eb 18                	jmp    80107990 <loaduvm+0xcb>
  for(i = 0; i < sz; i += PGSIZE){
80107978:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
8010797f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107982:	3b 45 18             	cmp    0x18(%ebp),%eax
80107985:	0f 82 65 ff ff ff    	jb     801078f0 <loaduvm+0x2b>
  }
  return 0;
8010798b:	b8 00 00 00 00       	mov    $0x0,%eax
}
80107990:	c9                   	leave  
80107991:	c3                   	ret    

80107992 <allocuvm>:

// Allocate page tables and physical memory to grow process from oldsz to
// newsz, which need not be page aligned.  Returns new size or 0 on error.
int
allocuvm(pde_t *pgdir, uint oldsz, uint newsz)
{
80107992:	55                   	push   %ebp
80107993:	89 e5                	mov    %esp,%ebp
80107995:	83 ec 18             	sub    $0x18,%esp
  char *mem;
  uint a;

  if(newsz >= KERNBASE)
80107998:	8b 45 10             	mov    0x10(%ebp),%eax
8010799b:	85 c0                	test   %eax,%eax
8010799d:	79 0a                	jns    801079a9 <allocuvm+0x17>
    return 0;
8010799f:	b8 00 00 00 00       	mov    $0x0,%eax
801079a4:	e9 ec 00 00 00       	jmp    80107a95 <allocuvm+0x103>
  if(newsz < oldsz)
801079a9:	8b 45 10             	mov    0x10(%ebp),%eax
801079ac:	3b 45 0c             	cmp    0xc(%ebp),%eax
801079af:	73 08                	jae    801079b9 <allocuvm+0x27>
    return oldsz;
801079b1:	8b 45 0c             	mov    0xc(%ebp),%eax
801079b4:	e9 dc 00 00 00       	jmp    80107a95 <allocuvm+0x103>

  a = PGROUNDUP(oldsz);
801079b9:	8b 45 0c             	mov    0xc(%ebp),%eax
801079bc:	05 ff 0f 00 00       	add    $0xfff,%eax
801079c1:	25 00 f0 ff ff       	and    $0xfffff000,%eax
801079c6:	89 45 f4             	mov    %eax,-0xc(%ebp)
  for(; a < newsz; a += PGSIZE){
801079c9:	e9 b8 00 00 00       	jmp    80107a86 <allocuvm+0xf4>
    mem = kalloc();
801079ce:	e8 cd ad ff ff       	call   801027a0 <kalloc>
801079d3:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(mem == 0){
801079d6:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
801079da:	75 2e                	jne    80107a0a <allocuvm+0x78>
      cprintf("allocuvm out of memory\n");
801079dc:	83 ec 0c             	sub    $0xc,%esp
801079df:	68 c9 a8 10 80       	push   $0x8010a8c9
801079e4:	e8 0b 8a ff ff       	call   801003f4 <cprintf>
801079e9:	83 c4 10             	add    $0x10,%esp
      deallocuvm(pgdir, newsz, oldsz);
801079ec:	83 ec 04             	sub    $0x4,%esp
801079ef:	ff 75 0c             	push   0xc(%ebp)
801079f2:	ff 75 10             	push   0x10(%ebp)
801079f5:	ff 75 08             	push   0x8(%ebp)
801079f8:	e8 9a 00 00 00       	call   80107a97 <deallocuvm>
801079fd:	83 c4 10             	add    $0x10,%esp
      return 0;
80107a00:	b8 00 00 00 00       	mov    $0x0,%eax
80107a05:	e9 8b 00 00 00       	jmp    80107a95 <allocuvm+0x103>
    }
    memset(mem, 0, PGSIZE);
80107a0a:	83 ec 04             	sub    $0x4,%esp
80107a0d:	68 00 10 00 00       	push   $0x1000
80107a12:	6a 00                	push   $0x0
80107a14:	ff 75 f0             	push   -0x10(%ebp)
80107a17:	e8 fe d1 ff ff       	call   80104c1a <memset>
80107a1c:	83 c4 10             	add    $0x10,%esp
    if(mappages(pgdir, (char*)a, PGSIZE, V2P(mem), PTE_W|PTE_U) < 0){
80107a1f:	8b 45 f0             	mov    -0x10(%ebp),%eax
80107a22:	8d 90 00 00 00 80    	lea    -0x80000000(%eax),%edx
80107a28:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107a2b:	83 ec 0c             	sub    $0xc,%esp
80107a2e:	6a 06                	push   $0x6
80107a30:	52                   	push   %edx
80107a31:	68 00 10 00 00       	push   $0x1000
80107a36:	50                   	push   %eax
80107a37:	ff 75 08             	push   0x8(%ebp)
80107a3a:	e8 ca fa ff ff       	call   80107509 <mappages>
80107a3f:	83 c4 20             	add    $0x20,%esp
80107a42:	85 c0                	test   %eax,%eax
80107a44:	79 39                	jns    80107a7f <allocuvm+0xed>
      cprintf("allocuvm out of memory (2)\n");
80107a46:	83 ec 0c             	sub    $0xc,%esp
80107a49:	68 e1 a8 10 80       	push   $0x8010a8e1
80107a4e:	e8 a1 89 ff ff       	call   801003f4 <cprintf>
80107a53:	83 c4 10             	add    $0x10,%esp
      deallocuvm(pgdir, newsz, oldsz);
80107a56:	83 ec 04             	sub    $0x4,%esp
80107a59:	ff 75 0c             	push   0xc(%ebp)
80107a5c:	ff 75 10             	push   0x10(%ebp)
80107a5f:	ff 75 08             	push   0x8(%ebp)
80107a62:	e8 30 00 00 00       	call   80107a97 <deallocuvm>
80107a67:	83 c4 10             	add    $0x10,%esp
      kfree(mem);
80107a6a:	83 ec 0c             	sub    $0xc,%esp
80107a6d:	ff 75 f0             	push   -0x10(%ebp)
80107a70:	e8 91 ac ff ff       	call   80102706 <kfree>
80107a75:	83 c4 10             	add    $0x10,%esp
      return 0;
80107a78:	b8 00 00 00 00       	mov    $0x0,%eax
80107a7d:	eb 16                	jmp    80107a95 <allocuvm+0x103>
  for(; a < newsz; a += PGSIZE){
80107a7f:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
80107a86:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107a89:	3b 45 10             	cmp    0x10(%ebp),%eax
80107a8c:	0f 82 3c ff ff ff    	jb     801079ce <allocuvm+0x3c>
    }
  }
  return newsz;
80107a92:	8b 45 10             	mov    0x10(%ebp),%eax
}
80107a95:	c9                   	leave  
80107a96:	c3                   	ret    

80107a97 <deallocuvm>:
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
int
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
{
80107a97:	55                   	push   %ebp
80107a98:	89 e5                	mov    %esp,%ebp
80107a9a:	83 ec 18             	sub    $0x18,%esp
  pte_t *pte;
  uint a, pa;

  if(newsz >= oldsz)
80107a9d:	8b 45 10             	mov    0x10(%ebp),%eax
80107aa0:	3b 45 0c             	cmp    0xc(%ebp),%eax
80107aa3:	72 08                	jb     80107aad <deallocuvm+0x16>
    return oldsz;
80107aa5:	8b 45 0c             	mov    0xc(%ebp),%eax
80107aa8:	e9 ac 00 00 00       	jmp    80107b59 <deallocuvm+0xc2>

  a = PGROUNDUP(newsz);
80107aad:	8b 45 10             	mov    0x10(%ebp),%eax
80107ab0:	05 ff 0f 00 00       	add    $0xfff,%eax
80107ab5:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80107aba:	89 45 f4             	mov    %eax,-0xc(%ebp)
  for(; a  < oldsz; a += PGSIZE){
80107abd:	e9 88 00 00 00       	jmp    80107b4a <deallocuvm+0xb3>
    pte = walkpgdir(pgdir, (char*)a, 0);
80107ac2:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107ac5:	83 ec 04             	sub    $0x4,%esp
80107ac8:	6a 00                	push   $0x0
80107aca:	50                   	push   %eax
80107acb:	ff 75 08             	push   0x8(%ebp)
80107ace:	e8 a0 f9 ff ff       	call   80107473 <walkpgdir>
80107ad3:	83 c4 10             	add    $0x10,%esp
80107ad6:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(!pte)
80107ad9:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80107add:	75 16                	jne    80107af5 <deallocuvm+0x5e>
      a = PGADDR(PDX(a) + 1, 0, 0) - PGSIZE;
80107adf:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107ae2:	c1 e8 16             	shr    $0x16,%eax
80107ae5:	83 c0 01             	add    $0x1,%eax
80107ae8:	c1 e0 16             	shl    $0x16,%eax
80107aeb:	2d 00 10 00 00       	sub    $0x1000,%eax
80107af0:	89 45 f4             	mov    %eax,-0xc(%ebp)
80107af3:	eb 4e                	jmp    80107b43 <deallocuvm+0xac>
    else if((*pte & PTE_P) != 0){
80107af5:	8b 45 f0             	mov    -0x10(%ebp),%eax
80107af8:	8b 00                	mov    (%eax),%eax
80107afa:	83 e0 01             	and    $0x1,%eax
80107afd:	85 c0                	test   %eax,%eax
80107aff:	74 42                	je     80107b43 <deallocuvm+0xac>
      pa = PTE_ADDR(*pte);
80107b01:	8b 45 f0             	mov    -0x10(%ebp),%eax
80107b04:	8b 00                	mov    (%eax),%eax
80107b06:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80107b0b:	89 45 ec             	mov    %eax,-0x14(%ebp)
      if(pa == 0)
80107b0e:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
80107b12:	75 0d                	jne    80107b21 <deallocuvm+0x8a>
        panic("kfree");
80107b14:	83 ec 0c             	sub    $0xc,%esp
80107b17:	68 fd a8 10 80       	push   $0x8010a8fd
80107b1c:	e8 88 8a ff ff       	call   801005a9 <panic>
      char *v = P2V(pa);
80107b21:	8b 45 ec             	mov    -0x14(%ebp),%eax
80107b24:	05 00 00 00 80       	add    $0x80000000,%eax
80107b29:	89 45 e8             	mov    %eax,-0x18(%ebp)
      kfree(v);
80107b2c:	83 ec 0c             	sub    $0xc,%esp
80107b2f:	ff 75 e8             	push   -0x18(%ebp)
80107b32:	e8 cf ab ff ff       	call   80102706 <kfree>
80107b37:	83 c4 10             	add    $0x10,%esp
      *pte = 0;
80107b3a:	8b 45 f0             	mov    -0x10(%ebp),%eax
80107b3d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  for(; a  < oldsz; a += PGSIZE){
80107b43:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
80107b4a:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107b4d:	3b 45 0c             	cmp    0xc(%ebp),%eax
80107b50:	0f 82 6c ff ff ff    	jb     80107ac2 <deallocuvm+0x2b>
    }
  }
  return newsz;
80107b56:	8b 45 10             	mov    0x10(%ebp),%eax
}
80107b59:	c9                   	leave  
80107b5a:	c3                   	ret    

80107b5b <freevm>:

// Free a page table and all the physical memory pages
// in the user part.
void
freevm(pde_t *pgdir)
{
80107b5b:	55                   	push   %ebp
80107b5c:	89 e5                	mov    %esp,%ebp
80107b5e:	83 ec 18             	sub    $0x18,%esp
  uint i;

  if(pgdir == 0)
80107b61:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
80107b65:	75 0d                	jne    80107b74 <freevm+0x19>
    panic("freevm: no pgdir");
80107b67:	83 ec 0c             	sub    $0xc,%esp
80107b6a:	68 03 a9 10 80       	push   $0x8010a903
80107b6f:	e8 35 8a ff ff       	call   801005a9 <panic>
  deallocuvm(pgdir, KERNBASE, 0);
80107b74:	83 ec 04             	sub    $0x4,%esp
80107b77:	6a 00                	push   $0x0
80107b79:	68 00 00 00 80       	push   $0x80000000
80107b7e:	ff 75 08             	push   0x8(%ebp)
80107b81:	e8 11 ff ff ff       	call   80107a97 <deallocuvm>
80107b86:	83 c4 10             	add    $0x10,%esp
  for(i = 0; i < NPDENTRIES; i++){
80107b89:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80107b90:	eb 48                	jmp    80107bda <freevm+0x7f>
    if(pgdir[i] & PTE_P){
80107b92:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107b95:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80107b9c:	8b 45 08             	mov    0x8(%ebp),%eax
80107b9f:	01 d0                	add    %edx,%eax
80107ba1:	8b 00                	mov    (%eax),%eax
80107ba3:	83 e0 01             	and    $0x1,%eax
80107ba6:	85 c0                	test   %eax,%eax
80107ba8:	74 2c                	je     80107bd6 <freevm+0x7b>
      char * v = P2V(PTE_ADDR(pgdir[i]));
80107baa:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107bad:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80107bb4:	8b 45 08             	mov    0x8(%ebp),%eax
80107bb7:	01 d0                	add    %edx,%eax
80107bb9:	8b 00                	mov    (%eax),%eax
80107bbb:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80107bc0:	05 00 00 00 80       	add    $0x80000000,%eax
80107bc5:	89 45 f0             	mov    %eax,-0x10(%ebp)
      kfree(v);
80107bc8:	83 ec 0c             	sub    $0xc,%esp
80107bcb:	ff 75 f0             	push   -0x10(%ebp)
80107bce:	e8 33 ab ff ff       	call   80102706 <kfree>
80107bd3:	83 c4 10             	add    $0x10,%esp
  for(i = 0; i < NPDENTRIES; i++){
80107bd6:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80107bda:	81 7d f4 ff 03 00 00 	cmpl   $0x3ff,-0xc(%ebp)
80107be1:	76 af                	jbe    80107b92 <freevm+0x37>
    }
  }
  kfree((char*)pgdir);
80107be3:	83 ec 0c             	sub    $0xc,%esp
80107be6:	ff 75 08             	push   0x8(%ebp)
80107be9:	e8 18 ab ff ff       	call   80102706 <kfree>
80107bee:	83 c4 10             	add    $0x10,%esp
}
80107bf1:	90                   	nop
80107bf2:	c9                   	leave  
80107bf3:	c3                   	ret    

80107bf4 <clearpteu>:

// Clear PTE_U on a page. Used to create an inaccessible
// page beneath the user stack.
void
clearpteu(pde_t *pgdir, char *uva)
{
80107bf4:	55                   	push   %ebp
80107bf5:	89 e5                	mov    %esp,%ebp
80107bf7:	83 ec 18             	sub    $0x18,%esp
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
80107bfa:	83 ec 04             	sub    $0x4,%esp
80107bfd:	6a 00                	push   $0x0
80107bff:	ff 75 0c             	push   0xc(%ebp)
80107c02:	ff 75 08             	push   0x8(%ebp)
80107c05:	e8 69 f8 ff ff       	call   80107473 <walkpgdir>
80107c0a:	83 c4 10             	add    $0x10,%esp
80107c0d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(pte == 0)
80107c10:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80107c14:	75 0d                	jne    80107c23 <clearpteu+0x2f>
    panic("clearpteu");
80107c16:	83 ec 0c             	sub    $0xc,%esp
80107c19:	68 14 a9 10 80       	push   $0x8010a914
80107c1e:	e8 86 89 ff ff       	call   801005a9 <panic>
  *pte &= ~PTE_U;
80107c23:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107c26:	8b 00                	mov    (%eax),%eax
80107c28:	83 e0 fb             	and    $0xfffffffb,%eax
80107c2b:	89 c2                	mov    %eax,%edx
80107c2d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107c30:	89 10                	mov    %edx,(%eax)
}
80107c32:	90                   	nop
80107c33:	c9                   	leave  
80107c34:	c3                   	ret    

80107c35 <copyuvm>:

// Given a parent process's page table, create a copy
// of it for a child.
pde_t*
copyuvm(pde_t *pgdir, uint sz)
{
80107c35:	55                   	push   %ebp
80107c36:	89 e5                	mov    %esp,%ebp
80107c38:	83 ec 28             	sub    $0x28,%esp
  pde_t *d;
  pte_t *pte;
  uint pa, i, flags;
  char *mem;

  if((d = setupkvm()) == 0)
80107c3b:	e8 59 f9 ff ff       	call   80107599 <setupkvm>
80107c40:	89 45 f0             	mov    %eax,-0x10(%ebp)
80107c43:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80107c47:	75 0a                	jne    80107c53 <copyuvm+0x1e>
    return 0;
80107c49:	b8 00 00 00 00       	mov    $0x0,%eax
80107c4e:	e9 eb 00 00 00       	jmp    80107d3e <copyuvm+0x109>
  for(i = 0; i < sz; i += PGSIZE){
80107c53:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80107c5a:	e9 b7 00 00 00       	jmp    80107d16 <copyuvm+0xe1>
    if((pte = walkpgdir(pgdir, (void *) i, 0)) == 0)
80107c5f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107c62:	83 ec 04             	sub    $0x4,%esp
80107c65:	6a 00                	push   $0x0
80107c67:	50                   	push   %eax
80107c68:	ff 75 08             	push   0x8(%ebp)
80107c6b:	e8 03 f8 ff ff       	call   80107473 <walkpgdir>
80107c70:	83 c4 10             	add    $0x10,%esp
80107c73:	89 45 ec             	mov    %eax,-0x14(%ebp)
80107c76:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
80107c7a:	75 0d                	jne    80107c89 <copyuvm+0x54>
      panic("copyuvm: pte should exist");
80107c7c:	83 ec 0c             	sub    $0xc,%esp
80107c7f:	68 1e a9 10 80       	push   $0x8010a91e
80107c84:	e8 20 89 ff ff       	call   801005a9 <panic>
    if(!(*pte & PTE_P))
80107c89:	8b 45 ec             	mov    -0x14(%ebp),%eax
80107c8c:	8b 00                	mov    (%eax),%eax
80107c8e:	83 e0 01             	and    $0x1,%eax
80107c91:	85 c0                	test   %eax,%eax
80107c93:	75 0d                	jne    80107ca2 <copyuvm+0x6d>
      panic("copyuvm: page not present");
80107c95:	83 ec 0c             	sub    $0xc,%esp
80107c98:	68 38 a9 10 80       	push   $0x8010a938
80107c9d:	e8 07 89 ff ff       	call   801005a9 <panic>
    pa = PTE_ADDR(*pte);
80107ca2:	8b 45 ec             	mov    -0x14(%ebp),%eax
80107ca5:	8b 00                	mov    (%eax),%eax
80107ca7:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80107cac:	89 45 e8             	mov    %eax,-0x18(%ebp)
    flags = PTE_FLAGS(*pte);
80107caf:	8b 45 ec             	mov    -0x14(%ebp),%eax
80107cb2:	8b 00                	mov    (%eax),%eax
80107cb4:	25 ff 0f 00 00       	and    $0xfff,%eax
80107cb9:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if((mem = kalloc()) == 0)
80107cbc:	e8 df aa ff ff       	call   801027a0 <kalloc>
80107cc1:	89 45 e0             	mov    %eax,-0x20(%ebp)
80107cc4:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
80107cc8:	74 5d                	je     80107d27 <copyuvm+0xf2>
      goto bad;
    memmove(mem, (char*)P2V(pa), PGSIZE);
80107cca:	8b 45 e8             	mov    -0x18(%ebp),%eax
80107ccd:	05 00 00 00 80       	add    $0x80000000,%eax
80107cd2:	83 ec 04             	sub    $0x4,%esp
80107cd5:	68 00 10 00 00       	push   $0x1000
80107cda:	50                   	push   %eax
80107cdb:	ff 75 e0             	push   -0x20(%ebp)
80107cde:	e8 f6 cf ff ff       	call   80104cd9 <memmove>
80107ce3:	83 c4 10             	add    $0x10,%esp
    if(mappages(d, (void*)i, PGSIZE, V2P(mem), flags) < 0)
80107ce6:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80107ce9:	8b 45 e0             	mov    -0x20(%ebp),%eax
80107cec:	8d 88 00 00 00 80    	lea    -0x80000000(%eax),%ecx
80107cf2:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107cf5:	83 ec 0c             	sub    $0xc,%esp
80107cf8:	52                   	push   %edx
80107cf9:	51                   	push   %ecx
80107cfa:	68 00 10 00 00       	push   $0x1000
80107cff:	50                   	push   %eax
80107d00:	ff 75 f0             	push   -0x10(%ebp)
80107d03:	e8 01 f8 ff ff       	call   80107509 <mappages>
80107d08:	83 c4 20             	add    $0x20,%esp
80107d0b:	85 c0                	test   %eax,%eax
80107d0d:	78 1b                	js     80107d2a <copyuvm+0xf5>
  for(i = 0; i < sz; i += PGSIZE){
80107d0f:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
80107d16:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107d19:	3b 45 0c             	cmp    0xc(%ebp),%eax
80107d1c:	0f 82 3d ff ff ff    	jb     80107c5f <copyuvm+0x2a>
      goto bad;
  }
  return d;
80107d22:	8b 45 f0             	mov    -0x10(%ebp),%eax
80107d25:	eb 17                	jmp    80107d3e <copyuvm+0x109>
      goto bad;
80107d27:	90                   	nop
80107d28:	eb 01                	jmp    80107d2b <copyuvm+0xf6>
      goto bad;
80107d2a:	90                   	nop

bad:
  freevm(d);
80107d2b:	83 ec 0c             	sub    $0xc,%esp
80107d2e:	ff 75 f0             	push   -0x10(%ebp)
80107d31:	e8 25 fe ff ff       	call   80107b5b <freevm>
80107d36:	83 c4 10             	add    $0x10,%esp
  return 0;
80107d39:	b8 00 00 00 00       	mov    $0x0,%eax
}
80107d3e:	c9                   	leave  
80107d3f:	c3                   	ret    

80107d40 <uva2ka>:

//PAGEBREAK!
// Map user virtual address to kernel address.
char*
uva2ka(pde_t *pgdir, char *uva)
{
80107d40:	55                   	push   %ebp
80107d41:	89 e5                	mov    %esp,%ebp
80107d43:	83 ec 18             	sub    $0x18,%esp
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
80107d46:	83 ec 04             	sub    $0x4,%esp
80107d49:	6a 00                	push   $0x0
80107d4b:	ff 75 0c             	push   0xc(%ebp)
80107d4e:	ff 75 08             	push   0x8(%ebp)
80107d51:	e8 1d f7 ff ff       	call   80107473 <walkpgdir>
80107d56:	83 c4 10             	add    $0x10,%esp
80107d59:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if((*pte & PTE_P) == 0)
80107d5c:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107d5f:	8b 00                	mov    (%eax),%eax
80107d61:	83 e0 01             	and    $0x1,%eax
80107d64:	85 c0                	test   %eax,%eax
80107d66:	75 07                	jne    80107d6f <uva2ka+0x2f>
    return 0;
80107d68:	b8 00 00 00 00       	mov    $0x0,%eax
80107d6d:	eb 22                	jmp    80107d91 <uva2ka+0x51>
  if((*pte & PTE_U) == 0)
80107d6f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107d72:	8b 00                	mov    (%eax),%eax
80107d74:	83 e0 04             	and    $0x4,%eax
80107d77:	85 c0                	test   %eax,%eax
80107d79:	75 07                	jne    80107d82 <uva2ka+0x42>
    return 0;
80107d7b:	b8 00 00 00 00       	mov    $0x0,%eax
80107d80:	eb 0f                	jmp    80107d91 <uva2ka+0x51>
  return (char*)P2V(PTE_ADDR(*pte));
80107d82:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107d85:	8b 00                	mov    (%eax),%eax
80107d87:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80107d8c:	05 00 00 00 80       	add    $0x80000000,%eax
}
80107d91:	c9                   	leave  
80107d92:	c3                   	ret    

80107d93 <copyout>:
// Copy len bytes from p to user address va in page table pgdir.
// Most useful when pgdir is not the current page table.
// uva2ka ensures this only works for PTE_U pages.
int
copyout(pde_t *pgdir, uint va, void *p, uint len)
{
80107d93:	55                   	push   %ebp
80107d94:	89 e5                	mov    %esp,%ebp
80107d96:	83 ec 18             	sub    $0x18,%esp
  char *buf, *pa0;
  uint n, va0;

  buf = (char*)p;
80107d99:	8b 45 10             	mov    0x10(%ebp),%eax
80107d9c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  while(len > 0){
80107d9f:	eb 7f                	jmp    80107e20 <copyout+0x8d>
    va0 = (uint)PGROUNDDOWN(va);
80107da1:	8b 45 0c             	mov    0xc(%ebp),%eax
80107da4:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80107da9:	89 45 ec             	mov    %eax,-0x14(%ebp)
    pa0 = uva2ka(pgdir, (char*)va0);
80107dac:	8b 45 ec             	mov    -0x14(%ebp),%eax
80107daf:	83 ec 08             	sub    $0x8,%esp
80107db2:	50                   	push   %eax
80107db3:	ff 75 08             	push   0x8(%ebp)
80107db6:	e8 85 ff ff ff       	call   80107d40 <uva2ka>
80107dbb:	83 c4 10             	add    $0x10,%esp
80107dbe:	89 45 e8             	mov    %eax,-0x18(%ebp)
    if(pa0 == 0)
80107dc1:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
80107dc5:	75 07                	jne    80107dce <copyout+0x3b>
      return -1;
80107dc7:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80107dcc:	eb 61                	jmp    80107e2f <copyout+0x9c>
    n = PGSIZE - (va - va0);
80107dce:	8b 45 ec             	mov    -0x14(%ebp),%eax
80107dd1:	2b 45 0c             	sub    0xc(%ebp),%eax
80107dd4:	05 00 10 00 00       	add    $0x1000,%eax
80107dd9:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(n > len)
80107ddc:	8b 45 f0             	mov    -0x10(%ebp),%eax
80107ddf:	3b 45 14             	cmp    0x14(%ebp),%eax
80107de2:	76 06                	jbe    80107dea <copyout+0x57>
      n = len;
80107de4:	8b 45 14             	mov    0x14(%ebp),%eax
80107de7:	89 45 f0             	mov    %eax,-0x10(%ebp)
    memmove(pa0 + (va - va0), buf, n);
80107dea:	8b 45 0c             	mov    0xc(%ebp),%eax
80107ded:	2b 45 ec             	sub    -0x14(%ebp),%eax
80107df0:	89 c2                	mov    %eax,%edx
80107df2:	8b 45 e8             	mov    -0x18(%ebp),%eax
80107df5:	01 d0                	add    %edx,%eax
80107df7:	83 ec 04             	sub    $0x4,%esp
80107dfa:	ff 75 f0             	push   -0x10(%ebp)
80107dfd:	ff 75 f4             	push   -0xc(%ebp)
80107e00:	50                   	push   %eax
80107e01:	e8 d3 ce ff ff       	call   80104cd9 <memmove>
80107e06:	83 c4 10             	add    $0x10,%esp
    len -= n;
80107e09:	8b 45 f0             	mov    -0x10(%ebp),%eax
80107e0c:	29 45 14             	sub    %eax,0x14(%ebp)
    buf += n;
80107e0f:	8b 45 f0             	mov    -0x10(%ebp),%eax
80107e12:	01 45 f4             	add    %eax,-0xc(%ebp)
    va = va0 + PGSIZE;
80107e15:	8b 45 ec             	mov    -0x14(%ebp),%eax
80107e18:	05 00 10 00 00       	add    $0x1000,%eax
80107e1d:	89 45 0c             	mov    %eax,0xc(%ebp)
  while(len > 0){
80107e20:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
80107e24:	0f 85 77 ff ff ff    	jne    80107da1 <copyout+0xe>
  }
  return 0;
80107e2a:	b8 00 00 00 00       	mov    $0x0,%eax
}
80107e2f:	c9                   	leave  
80107e30:	c3                   	ret    

80107e31 <mpinit_uefi>:

struct cpu cpus[NCPU];
int ncpu;
uchar ioapicid;
void mpinit_uefi(void)
{
80107e31:	55                   	push   %ebp
80107e32:	89 e5                	mov    %esp,%ebp
80107e34:	83 ec 20             	sub    $0x20,%esp
  struct boot_param *boot_param = (struct boot_param *)P2V_WO(BOOTPARAM);
80107e37:	c7 45 f8 00 00 05 80 	movl   $0x80050000,-0x8(%ebp)
  struct uefi_madt *madt = (struct uefi_madt*)(P2V_WO(boot_param->madt_addr));
80107e3e:	8b 45 f8             	mov    -0x8(%ebp),%eax
80107e41:	8b 40 08             	mov    0x8(%eax),%eax
80107e44:	05 00 00 00 80       	add    $0x80000000,%eax
80107e49:	89 45 f4             	mov    %eax,-0xc(%ebp)

  uint i=sizeof(struct uefi_madt);
80107e4c:	c7 45 fc 2c 00 00 00 	movl   $0x2c,-0x4(%ebp)
  struct uefi_lapic *lapic_entry;
  struct uefi_ioapic *ioapic;
  struct uefi_iso *iso;
  struct uefi_non_maskable_intr *non_mask_intr; 
  
  lapic = (uint *)(madt->lapic_addr);
80107e53:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107e56:	8b 40 24             	mov    0x24(%eax),%eax
80107e59:	a3 00 41 19 80       	mov    %eax,0x80194100
  ncpu = 0;
80107e5e:	c7 05 40 6e 19 80 00 	movl   $0x0,0x80196e40
80107e65:	00 00 00 

  while(i<madt->len){
80107e68:	90                   	nop
80107e69:	e9 bd 00 00 00       	jmp    80107f2b <mpinit_uefi+0xfa>
    uchar *entry_type = ((uchar *)madt)+i;
80107e6e:	8b 55 f4             	mov    -0xc(%ebp),%edx
80107e71:	8b 45 fc             	mov    -0x4(%ebp),%eax
80107e74:	01 d0                	add    %edx,%eax
80107e76:	89 45 f0             	mov    %eax,-0x10(%ebp)
    switch(*entry_type){
80107e79:	8b 45 f0             	mov    -0x10(%ebp),%eax
80107e7c:	0f b6 00             	movzbl (%eax),%eax
80107e7f:	0f b6 c0             	movzbl %al,%eax
80107e82:	83 f8 05             	cmp    $0x5,%eax
80107e85:	0f 87 a0 00 00 00    	ja     80107f2b <mpinit_uefi+0xfa>
80107e8b:	8b 04 85 54 a9 10 80 	mov    -0x7fef56ac(,%eax,4),%eax
80107e92:	ff e0                	jmp    *%eax
      case 0:
        lapic_entry = (struct uefi_lapic *)entry_type;
80107e94:	8b 45 f0             	mov    -0x10(%ebp),%eax
80107e97:	89 45 e0             	mov    %eax,-0x20(%ebp)
        if(ncpu < NCPU) {
80107e9a:	a1 40 6e 19 80       	mov    0x80196e40,%eax
80107e9f:	83 f8 03             	cmp    $0x3,%eax
80107ea2:	7f 28                	jg     80107ecc <mpinit_uefi+0x9b>
          cpus[ncpu].apicid = lapic_entry->lapic_id;
80107ea4:	8b 15 40 6e 19 80    	mov    0x80196e40,%edx
80107eaa:	8b 45 e0             	mov    -0x20(%ebp),%eax
80107ead:	0f b6 40 03          	movzbl 0x3(%eax),%eax
80107eb1:	69 d2 b0 00 00 00    	imul   $0xb0,%edx,%edx
80107eb7:	81 c2 80 6b 19 80    	add    $0x80196b80,%edx
80107ebd:	88 02                	mov    %al,(%edx)
          ncpu++;
80107ebf:	a1 40 6e 19 80       	mov    0x80196e40,%eax
80107ec4:	83 c0 01             	add    $0x1,%eax
80107ec7:	a3 40 6e 19 80       	mov    %eax,0x80196e40
        }
        i += lapic_entry->record_len;
80107ecc:	8b 45 e0             	mov    -0x20(%ebp),%eax
80107ecf:	0f b6 40 01          	movzbl 0x1(%eax),%eax
80107ed3:	0f b6 c0             	movzbl %al,%eax
80107ed6:	01 45 fc             	add    %eax,-0x4(%ebp)
        break;
80107ed9:	eb 50                	jmp    80107f2b <mpinit_uefi+0xfa>

      case 1:
        ioapic = (struct uefi_ioapic *)entry_type;
80107edb:	8b 45 f0             	mov    -0x10(%ebp),%eax
80107ede:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        ioapicid = ioapic->ioapic_id;
80107ee1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80107ee4:	0f b6 40 02          	movzbl 0x2(%eax),%eax
80107ee8:	a2 44 6e 19 80       	mov    %al,0x80196e44
        i += ioapic->record_len;
80107eed:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80107ef0:	0f b6 40 01          	movzbl 0x1(%eax),%eax
80107ef4:	0f b6 c0             	movzbl %al,%eax
80107ef7:	01 45 fc             	add    %eax,-0x4(%ebp)
        break;
80107efa:	eb 2f                	jmp    80107f2b <mpinit_uefi+0xfa>

      case 2:
        iso = (struct uefi_iso *)entry_type;
80107efc:	8b 45 f0             	mov    -0x10(%ebp),%eax
80107eff:	89 45 e8             	mov    %eax,-0x18(%ebp)
        i += iso->record_len;
80107f02:	8b 45 e8             	mov    -0x18(%ebp),%eax
80107f05:	0f b6 40 01          	movzbl 0x1(%eax),%eax
80107f09:	0f b6 c0             	movzbl %al,%eax
80107f0c:	01 45 fc             	add    %eax,-0x4(%ebp)
        break;
80107f0f:	eb 1a                	jmp    80107f2b <mpinit_uefi+0xfa>

      case 4:
        non_mask_intr = (struct uefi_non_maskable_intr *)entry_type;
80107f11:	8b 45 f0             	mov    -0x10(%ebp),%eax
80107f14:	89 45 ec             	mov    %eax,-0x14(%ebp)
        i += non_mask_intr->record_len;
80107f17:	8b 45 ec             	mov    -0x14(%ebp),%eax
80107f1a:	0f b6 40 01          	movzbl 0x1(%eax),%eax
80107f1e:	0f b6 c0             	movzbl %al,%eax
80107f21:	01 45 fc             	add    %eax,-0x4(%ebp)
        break;
80107f24:	eb 05                	jmp    80107f2b <mpinit_uefi+0xfa>

      case 5:
        i = i + 0xC;
80107f26:	83 45 fc 0c          	addl   $0xc,-0x4(%ebp)
        break;
80107f2a:	90                   	nop
  while(i<madt->len){
80107f2b:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107f2e:	8b 40 04             	mov    0x4(%eax),%eax
80107f31:	39 45 fc             	cmp    %eax,-0x4(%ebp)
80107f34:	0f 82 34 ff ff ff    	jb     80107e6e <mpinit_uefi+0x3d>
    }
  }

}
80107f3a:	90                   	nop
80107f3b:	90                   	nop
80107f3c:	c9                   	leave  
80107f3d:	c3                   	ret    

80107f3e <inb>:
{
80107f3e:	55                   	push   %ebp
80107f3f:	89 e5                	mov    %esp,%ebp
80107f41:	83 ec 14             	sub    $0x14,%esp
80107f44:	8b 45 08             	mov    0x8(%ebp),%eax
80107f47:	66 89 45 ec          	mov    %ax,-0x14(%ebp)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80107f4b:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
80107f4f:	89 c2                	mov    %eax,%edx
80107f51:	ec                   	in     (%dx),%al
80107f52:	88 45 ff             	mov    %al,-0x1(%ebp)
  return data;
80107f55:	0f b6 45 ff          	movzbl -0x1(%ebp),%eax
}
80107f59:	c9                   	leave  
80107f5a:	c3                   	ret    

80107f5b <outb>:
{
80107f5b:	55                   	push   %ebp
80107f5c:	89 e5                	mov    %esp,%ebp
80107f5e:	83 ec 08             	sub    $0x8,%esp
80107f61:	8b 45 08             	mov    0x8(%ebp),%eax
80107f64:	8b 55 0c             	mov    0xc(%ebp),%edx
80107f67:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
80107f6b:	89 d0                	mov    %edx,%eax
80107f6d:	88 45 f8             	mov    %al,-0x8(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80107f70:	0f b6 45 f8          	movzbl -0x8(%ebp),%eax
80107f74:	0f b7 55 fc          	movzwl -0x4(%ebp),%edx
80107f78:	ee                   	out    %al,(%dx)
}
80107f79:	90                   	nop
80107f7a:	c9                   	leave  
80107f7b:	c3                   	ret    

80107f7c <uart_debug>:
#include "proc.h"
#include "x86.h"

#define COM1    0x3f8

void uart_debug(char p){
80107f7c:	55                   	push   %ebp
80107f7d:	89 e5                	mov    %esp,%ebp
80107f7f:	83 ec 28             	sub    $0x28,%esp
80107f82:	8b 45 08             	mov    0x8(%ebp),%eax
80107f85:	88 45 e4             	mov    %al,-0x1c(%ebp)
    // Turn off the FIFO
  outb(COM1+2, 0);
80107f88:	6a 00                	push   $0x0
80107f8a:	68 fa 03 00 00       	push   $0x3fa
80107f8f:	e8 c7 ff ff ff       	call   80107f5b <outb>
80107f94:	83 c4 08             	add    $0x8,%esp

  // 9600 baud, 8 data bits, 1 stop bit, parity off.
  outb(COM1+3, 0x80);    // Unlock divisor
80107f97:	68 80 00 00 00       	push   $0x80
80107f9c:	68 fb 03 00 00       	push   $0x3fb
80107fa1:	e8 b5 ff ff ff       	call   80107f5b <outb>
80107fa6:	83 c4 08             	add    $0x8,%esp
  outb(COM1+0, 115200/9600);
80107fa9:	6a 0c                	push   $0xc
80107fab:	68 f8 03 00 00       	push   $0x3f8
80107fb0:	e8 a6 ff ff ff       	call   80107f5b <outb>
80107fb5:	83 c4 08             	add    $0x8,%esp
  outb(COM1+1, 0);
80107fb8:	6a 00                	push   $0x0
80107fba:	68 f9 03 00 00       	push   $0x3f9
80107fbf:	e8 97 ff ff ff       	call   80107f5b <outb>
80107fc4:	83 c4 08             	add    $0x8,%esp
  outb(COM1+3, 0x03);    // Lock divisor, 8 data bits.
80107fc7:	6a 03                	push   $0x3
80107fc9:	68 fb 03 00 00       	push   $0x3fb
80107fce:	e8 88 ff ff ff       	call   80107f5b <outb>
80107fd3:	83 c4 08             	add    $0x8,%esp
  outb(COM1+4, 0);
80107fd6:	6a 00                	push   $0x0
80107fd8:	68 fc 03 00 00       	push   $0x3fc
80107fdd:	e8 79 ff ff ff       	call   80107f5b <outb>
80107fe2:	83 c4 08             	add    $0x8,%esp

  for(int i=0;i<128 && !(inb(COM1+5) & 0x20); i++) microdelay(10);
80107fe5:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80107fec:	eb 11                	jmp    80107fff <uart_debug+0x83>
80107fee:	83 ec 0c             	sub    $0xc,%esp
80107ff1:	6a 0a                	push   $0xa
80107ff3:	e8 3f ab ff ff       	call   80102b37 <microdelay>
80107ff8:	83 c4 10             	add    $0x10,%esp
80107ffb:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80107fff:	83 7d f4 7f          	cmpl   $0x7f,-0xc(%ebp)
80108003:	7f 1a                	jg     8010801f <uart_debug+0xa3>
80108005:	83 ec 0c             	sub    $0xc,%esp
80108008:	68 fd 03 00 00       	push   $0x3fd
8010800d:	e8 2c ff ff ff       	call   80107f3e <inb>
80108012:	83 c4 10             	add    $0x10,%esp
80108015:	0f b6 c0             	movzbl %al,%eax
80108018:	83 e0 20             	and    $0x20,%eax
8010801b:	85 c0                	test   %eax,%eax
8010801d:	74 cf                	je     80107fee <uart_debug+0x72>
  outb(COM1+0, p);
8010801f:	0f b6 45 e4          	movzbl -0x1c(%ebp),%eax
80108023:	0f b6 c0             	movzbl %al,%eax
80108026:	83 ec 08             	sub    $0x8,%esp
80108029:	50                   	push   %eax
8010802a:	68 f8 03 00 00       	push   $0x3f8
8010802f:	e8 27 ff ff ff       	call   80107f5b <outb>
80108034:	83 c4 10             	add    $0x10,%esp
}
80108037:	90                   	nop
80108038:	c9                   	leave  
80108039:	c3                   	ret    

8010803a <uart_debugs>:

void uart_debugs(char *p){
8010803a:	55                   	push   %ebp
8010803b:	89 e5                	mov    %esp,%ebp
8010803d:	83 ec 08             	sub    $0x8,%esp
  while(*p){
80108040:	eb 1b                	jmp    8010805d <uart_debugs+0x23>
    uart_debug(*p++);
80108042:	8b 45 08             	mov    0x8(%ebp),%eax
80108045:	8d 50 01             	lea    0x1(%eax),%edx
80108048:	89 55 08             	mov    %edx,0x8(%ebp)
8010804b:	0f b6 00             	movzbl (%eax),%eax
8010804e:	0f be c0             	movsbl %al,%eax
80108051:	83 ec 0c             	sub    $0xc,%esp
80108054:	50                   	push   %eax
80108055:	e8 22 ff ff ff       	call   80107f7c <uart_debug>
8010805a:	83 c4 10             	add    $0x10,%esp
  while(*p){
8010805d:	8b 45 08             	mov    0x8(%ebp),%eax
80108060:	0f b6 00             	movzbl (%eax),%eax
80108063:	84 c0                	test   %al,%al
80108065:	75 db                	jne    80108042 <uart_debugs+0x8>
  }
}
80108067:	90                   	nop
80108068:	90                   	nop
80108069:	c9                   	leave  
8010806a:	c3                   	ret    

8010806b <graphic_init>:
 * i%4 = 2 : red
 * i%4 = 3 : black
 */

struct gpu gpu;
void graphic_init(){
8010806b:	55                   	push   %ebp
8010806c:	89 e5                	mov    %esp,%ebp
8010806e:	83 ec 10             	sub    $0x10,%esp
  struct boot_param *boot_param = (struct boot_param *)P2V_WO(BOOTPARAM);
80108071:	c7 45 fc 00 00 05 80 	movl   $0x80050000,-0x4(%ebp)
  gpu.pvram_addr = boot_param->graphic_config.frame_base;
80108078:	8b 45 fc             	mov    -0x4(%ebp),%eax
8010807b:	8b 50 14             	mov    0x14(%eax),%edx
8010807e:	8b 40 10             	mov    0x10(%eax),%eax
80108081:	a3 48 6e 19 80       	mov    %eax,0x80196e48
  gpu.vram_size = boot_param->graphic_config.frame_size;
80108086:	8b 45 fc             	mov    -0x4(%ebp),%eax
80108089:	8b 50 1c             	mov    0x1c(%eax),%edx
8010808c:	8b 40 18             	mov    0x18(%eax),%eax
8010808f:	a3 50 6e 19 80       	mov    %eax,0x80196e50
  gpu.vvram_addr = DEVSPACE - gpu.vram_size;
80108094:	8b 15 50 6e 19 80    	mov    0x80196e50,%edx
8010809a:	b8 00 00 00 fe       	mov    $0xfe000000,%eax
8010809f:	29 d0                	sub    %edx,%eax
801080a1:	a3 4c 6e 19 80       	mov    %eax,0x80196e4c
  gpu.horizontal_resolution = (uint)(boot_param->graphic_config.horizontal_resolution & 0xFFFFFFFF);
801080a6:	8b 45 fc             	mov    -0x4(%ebp),%eax
801080a9:	8b 50 24             	mov    0x24(%eax),%edx
801080ac:	8b 40 20             	mov    0x20(%eax),%eax
801080af:	a3 54 6e 19 80       	mov    %eax,0x80196e54
  gpu.vertical_resolution = (uint)(boot_param->graphic_config.vertical_resolution & 0xFFFFFFFF);
801080b4:	8b 45 fc             	mov    -0x4(%ebp),%eax
801080b7:	8b 50 2c             	mov    0x2c(%eax),%edx
801080ba:	8b 40 28             	mov    0x28(%eax),%eax
801080bd:	a3 58 6e 19 80       	mov    %eax,0x80196e58
  gpu.pixels_per_line = (uint)(boot_param->graphic_config.pixels_per_line & 0xFFFFFFFF);
801080c2:	8b 45 fc             	mov    -0x4(%ebp),%eax
801080c5:	8b 50 34             	mov    0x34(%eax),%edx
801080c8:	8b 40 30             	mov    0x30(%eax),%eax
801080cb:	a3 5c 6e 19 80       	mov    %eax,0x80196e5c
}
801080d0:	90                   	nop
801080d1:	c9                   	leave  
801080d2:	c3                   	ret    

801080d3 <graphic_draw_pixel>:

void graphic_draw_pixel(int x,int y,struct graphic_pixel * buffer){
801080d3:	55                   	push   %ebp
801080d4:	89 e5                	mov    %esp,%ebp
801080d6:	83 ec 10             	sub    $0x10,%esp
  int pixel_addr = (sizeof(struct graphic_pixel))*(y*gpu.pixels_per_line + x);
801080d9:	8b 15 5c 6e 19 80    	mov    0x80196e5c,%edx
801080df:	8b 45 0c             	mov    0xc(%ebp),%eax
801080e2:	0f af d0             	imul   %eax,%edx
801080e5:	8b 45 08             	mov    0x8(%ebp),%eax
801080e8:	01 d0                	add    %edx,%eax
801080ea:	c1 e0 02             	shl    $0x2,%eax
801080ed:	89 45 fc             	mov    %eax,-0x4(%ebp)
  struct graphic_pixel *pixel = (struct graphic_pixel *)(gpu.vvram_addr + pixel_addr);
801080f0:	8b 15 4c 6e 19 80    	mov    0x80196e4c,%edx
801080f6:	8b 45 fc             	mov    -0x4(%ebp),%eax
801080f9:	01 d0                	add    %edx,%eax
801080fb:	89 45 f8             	mov    %eax,-0x8(%ebp)
  pixel->blue = buffer->blue;
801080fe:	8b 45 10             	mov    0x10(%ebp),%eax
80108101:	0f b6 10             	movzbl (%eax),%edx
80108104:	8b 45 f8             	mov    -0x8(%ebp),%eax
80108107:	88 10                	mov    %dl,(%eax)
  pixel->green = buffer->green;
80108109:	8b 45 10             	mov    0x10(%ebp),%eax
8010810c:	0f b6 50 01          	movzbl 0x1(%eax),%edx
80108110:	8b 45 f8             	mov    -0x8(%ebp),%eax
80108113:	88 50 01             	mov    %dl,0x1(%eax)
  pixel->red = buffer->red;
80108116:	8b 45 10             	mov    0x10(%ebp),%eax
80108119:	0f b6 50 02          	movzbl 0x2(%eax),%edx
8010811d:	8b 45 f8             	mov    -0x8(%ebp),%eax
80108120:	88 50 02             	mov    %dl,0x2(%eax)
}
80108123:	90                   	nop
80108124:	c9                   	leave  
80108125:	c3                   	ret    

80108126 <graphic_scroll_up>:

void graphic_scroll_up(int height){
80108126:	55                   	push   %ebp
80108127:	89 e5                	mov    %esp,%ebp
80108129:	83 ec 18             	sub    $0x18,%esp
  int addr_diff = (sizeof(struct graphic_pixel))*gpu.pixels_per_line*height;
8010812c:	8b 15 5c 6e 19 80    	mov    0x80196e5c,%edx
80108132:	8b 45 08             	mov    0x8(%ebp),%eax
80108135:	0f af c2             	imul   %edx,%eax
80108138:	c1 e0 02             	shl    $0x2,%eax
8010813b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  memmove((unsigned int *)gpu.vvram_addr,(unsigned int *)(gpu.vvram_addr + addr_diff),gpu.vram_size - addr_diff);
8010813e:	a1 50 6e 19 80       	mov    0x80196e50,%eax
80108143:	8b 55 f4             	mov    -0xc(%ebp),%edx
80108146:	29 d0                	sub    %edx,%eax
80108148:	8b 0d 4c 6e 19 80    	mov    0x80196e4c,%ecx
8010814e:	8b 55 f4             	mov    -0xc(%ebp),%edx
80108151:	01 ca                	add    %ecx,%edx
80108153:	89 d1                	mov    %edx,%ecx
80108155:	8b 15 4c 6e 19 80    	mov    0x80196e4c,%edx
8010815b:	83 ec 04             	sub    $0x4,%esp
8010815e:	50                   	push   %eax
8010815f:	51                   	push   %ecx
80108160:	52                   	push   %edx
80108161:	e8 73 cb ff ff       	call   80104cd9 <memmove>
80108166:	83 c4 10             	add    $0x10,%esp
  memset((unsigned int *)(gpu.vvram_addr + gpu.vram_size - addr_diff),0,addr_diff);
80108169:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010816c:	8b 0d 4c 6e 19 80    	mov    0x80196e4c,%ecx
80108172:	8b 15 50 6e 19 80    	mov    0x80196e50,%edx
80108178:	01 ca                	add    %ecx,%edx
8010817a:	8b 4d f4             	mov    -0xc(%ebp),%ecx
8010817d:	29 ca                	sub    %ecx,%edx
8010817f:	83 ec 04             	sub    $0x4,%esp
80108182:	50                   	push   %eax
80108183:	6a 00                	push   $0x0
80108185:	52                   	push   %edx
80108186:	e8 8f ca ff ff       	call   80104c1a <memset>
8010818b:	83 c4 10             	add    $0x10,%esp
}
8010818e:	90                   	nop
8010818f:	c9                   	leave  
80108190:	c3                   	ret    

80108191 <font_render>:
80108191:	55                   	push   %ebp
80108192:	89 e5                	mov    %esp,%ebp
80108194:	53                   	push   %ebx
80108195:	83 ec 14             	sub    $0x14,%esp
80108198:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
8010819f:	e9 b1 00 00 00       	jmp    80108255 <font_render+0xc4>
801081a4:	c7 45 f0 0e 00 00 00 	movl   $0xe,-0x10(%ebp)
801081ab:	e9 97 00 00 00       	jmp    80108247 <font_render+0xb6>
801081b0:	8b 45 10             	mov    0x10(%ebp),%eax
801081b3:	83 e8 20             	sub    $0x20,%eax
801081b6:	6b d0 1e             	imul   $0x1e,%eax,%edx
801081b9:	8b 45 f4             	mov    -0xc(%ebp),%eax
801081bc:	01 d0                	add    %edx,%eax
801081be:	0f b7 84 00 80 a9 10 	movzwl -0x7fef5680(%eax,%eax,1),%eax
801081c5:	80 
801081c6:	0f b7 d0             	movzwl %ax,%edx
801081c9:	8b 45 f0             	mov    -0x10(%ebp),%eax
801081cc:	bb 01 00 00 00       	mov    $0x1,%ebx
801081d1:	89 c1                	mov    %eax,%ecx
801081d3:	d3 e3                	shl    %cl,%ebx
801081d5:	89 d8                	mov    %ebx,%eax
801081d7:	21 d0                	and    %edx,%eax
801081d9:	89 45 ec             	mov    %eax,-0x14(%ebp)
801081dc:	8b 45 f0             	mov    -0x10(%ebp),%eax
801081df:	ba 01 00 00 00       	mov    $0x1,%edx
801081e4:	89 c1                	mov    %eax,%ecx
801081e6:	d3 e2                	shl    %cl,%edx
801081e8:	89 d0                	mov    %edx,%eax
801081ea:	39 45 ec             	cmp    %eax,-0x14(%ebp)
801081ed:	75 2b                	jne    8010821a <font_render+0x89>
801081ef:	8b 55 0c             	mov    0xc(%ebp),%edx
801081f2:	8b 45 f4             	mov    -0xc(%ebp),%eax
801081f5:	01 c2                	add    %eax,%edx
801081f7:	b8 0e 00 00 00       	mov    $0xe,%eax
801081fc:	2b 45 f0             	sub    -0x10(%ebp),%eax
801081ff:	89 c1                	mov    %eax,%ecx
80108201:	8b 45 08             	mov    0x8(%ebp),%eax
80108204:	01 c8                	add    %ecx,%eax
80108206:	83 ec 04             	sub    $0x4,%esp
80108209:	68 00 f5 10 80       	push   $0x8010f500
8010820e:	52                   	push   %edx
8010820f:	50                   	push   %eax
80108210:	e8 be fe ff ff       	call   801080d3 <graphic_draw_pixel>
80108215:	83 c4 10             	add    $0x10,%esp
80108218:	eb 29                	jmp    80108243 <font_render+0xb2>
8010821a:	8b 55 0c             	mov    0xc(%ebp),%edx
8010821d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108220:	01 c2                	add    %eax,%edx
80108222:	b8 0e 00 00 00       	mov    $0xe,%eax
80108227:	2b 45 f0             	sub    -0x10(%ebp),%eax
8010822a:	89 c1                	mov    %eax,%ecx
8010822c:	8b 45 08             	mov    0x8(%ebp),%eax
8010822f:	01 c8                	add    %ecx,%eax
80108231:	83 ec 04             	sub    $0x4,%esp
80108234:	68 60 6e 19 80       	push   $0x80196e60
80108239:	52                   	push   %edx
8010823a:	50                   	push   %eax
8010823b:	e8 93 fe ff ff       	call   801080d3 <graphic_draw_pixel>
80108240:	83 c4 10             	add    $0x10,%esp
80108243:	83 6d f0 01          	subl   $0x1,-0x10(%ebp)
80108247:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
8010824b:	0f 89 5f ff ff ff    	jns    801081b0 <font_render+0x1f>
80108251:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80108255:	83 7d f4 1d          	cmpl   $0x1d,-0xc(%ebp)
80108259:	0f 8e 45 ff ff ff    	jle    801081a4 <font_render+0x13>
8010825f:	90                   	nop
80108260:	90                   	nop
80108261:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80108264:	c9                   	leave  
80108265:	c3                   	ret    

80108266 <font_render_string>:
80108266:	55                   	push   %ebp
80108267:	89 e5                	mov    %esp,%ebp
80108269:	53                   	push   %ebx
8010826a:	83 ec 14             	sub    $0x14,%esp
8010826d:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80108274:	eb 33                	jmp    801082a9 <font_render_string+0x43>
80108276:	8b 55 f4             	mov    -0xc(%ebp),%edx
80108279:	8b 45 08             	mov    0x8(%ebp),%eax
8010827c:	01 d0                	add    %edx,%eax
8010827e:	0f b6 00             	movzbl (%eax),%eax
80108281:	0f be c8             	movsbl %al,%ecx
80108284:	8b 45 0c             	mov    0xc(%ebp),%eax
80108287:	6b d0 1e             	imul   $0x1e,%eax,%edx
8010828a:	8b 5d f4             	mov    -0xc(%ebp),%ebx
8010828d:	89 d8                	mov    %ebx,%eax
8010828f:	c1 e0 04             	shl    $0x4,%eax
80108292:	29 d8                	sub    %ebx,%eax
80108294:	83 c0 02             	add    $0x2,%eax
80108297:	83 ec 04             	sub    $0x4,%esp
8010829a:	51                   	push   %ecx
8010829b:	52                   	push   %edx
8010829c:	50                   	push   %eax
8010829d:	e8 ef fe ff ff       	call   80108191 <font_render>
801082a2:	83 c4 10             	add    $0x10,%esp
801082a5:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
801082a9:	8b 55 f4             	mov    -0xc(%ebp),%edx
801082ac:	8b 45 08             	mov    0x8(%ebp),%eax
801082af:	01 d0                	add    %edx,%eax
801082b1:	0f b6 00             	movzbl (%eax),%eax
801082b4:	84 c0                	test   %al,%al
801082b6:	74 06                	je     801082be <font_render_string+0x58>
801082b8:	83 7d f4 33          	cmpl   $0x33,-0xc(%ebp)
801082bc:	7e b8                	jle    80108276 <font_render_string+0x10>
801082be:	90                   	nop
801082bf:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801082c2:	c9                   	leave  
801082c3:	c3                   	ret    

801082c4 <pci_init>:
#include "pci.h"
#include "defs.h"
#include "types.h"
#include "i8254.h"

void pci_init(){
801082c4:	55                   	push   %ebp
801082c5:	89 e5                	mov    %esp,%ebp
801082c7:	53                   	push   %ebx
801082c8:	83 ec 14             	sub    $0x14,%esp
  uint data;
  for(int i=0;i<256;i++){
801082cb:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
801082d2:	eb 6b                	jmp    8010833f <pci_init+0x7b>
    for(int j=0;j<32;j++){
801082d4:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
801082db:	eb 58                	jmp    80108335 <pci_init+0x71>
      for(int k=0;k<8;k++){
801082dd:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
801082e4:	eb 45                	jmp    8010832b <pci_init+0x67>
      pci_access_config(i,j,k,0,&data);
801082e6:	8b 4d ec             	mov    -0x14(%ebp),%ecx
801082e9:	8b 55 f0             	mov    -0x10(%ebp),%edx
801082ec:	8b 45 f4             	mov    -0xc(%ebp),%eax
801082ef:	83 ec 0c             	sub    $0xc,%esp
801082f2:	8d 5d e8             	lea    -0x18(%ebp),%ebx
801082f5:	53                   	push   %ebx
801082f6:	6a 00                	push   $0x0
801082f8:	51                   	push   %ecx
801082f9:	52                   	push   %edx
801082fa:	50                   	push   %eax
801082fb:	e8 b0 00 00 00       	call   801083b0 <pci_access_config>
80108300:	83 c4 20             	add    $0x20,%esp
      if((data&0xFFFF) != 0xFFFF){
80108303:	8b 45 e8             	mov    -0x18(%ebp),%eax
80108306:	0f b7 c0             	movzwl %ax,%eax
80108309:	3d ff ff 00 00       	cmp    $0xffff,%eax
8010830e:	74 17                	je     80108327 <pci_init+0x63>
        pci_init_device(i,j,k);
80108310:	8b 4d ec             	mov    -0x14(%ebp),%ecx
80108313:	8b 55 f0             	mov    -0x10(%ebp),%edx
80108316:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108319:	83 ec 04             	sub    $0x4,%esp
8010831c:	51                   	push   %ecx
8010831d:	52                   	push   %edx
8010831e:	50                   	push   %eax
8010831f:	e8 37 01 00 00       	call   8010845b <pci_init_device>
80108324:	83 c4 10             	add    $0x10,%esp
      for(int k=0;k<8;k++){
80108327:	83 45 ec 01          	addl   $0x1,-0x14(%ebp)
8010832b:	83 7d ec 07          	cmpl   $0x7,-0x14(%ebp)
8010832f:	7e b5                	jle    801082e6 <pci_init+0x22>
    for(int j=0;j<32;j++){
80108331:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
80108335:	83 7d f0 1f          	cmpl   $0x1f,-0x10(%ebp)
80108339:	7e a2                	jle    801082dd <pci_init+0x19>
  for(int i=0;i<256;i++){
8010833b:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
8010833f:	81 7d f4 ff 00 00 00 	cmpl   $0xff,-0xc(%ebp)
80108346:	7e 8c                	jle    801082d4 <pci_init+0x10>
      }
      }
    }
  }
}
80108348:	90                   	nop
80108349:	90                   	nop
8010834a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010834d:	c9                   	leave  
8010834e:	c3                   	ret    

8010834f <pci_write_config>:

void pci_write_config(uint config){
8010834f:	55                   	push   %ebp
80108350:	89 e5                	mov    %esp,%ebp
  asm("mov $0xCF8,%%edx\n\t"
80108352:	8b 45 08             	mov    0x8(%ebp),%eax
80108355:	ba f8 0c 00 00       	mov    $0xcf8,%edx
8010835a:	89 c0                	mov    %eax,%eax
8010835c:	ef                   	out    %eax,(%dx)
      "mov %0,%%eax\n\t"
      "out %%eax,%%dx\n\t"
      : :"r"(config));
}
8010835d:	90                   	nop
8010835e:	5d                   	pop    %ebp
8010835f:	c3                   	ret    

80108360 <pci_write_data>:

void pci_write_data(uint config){
80108360:	55                   	push   %ebp
80108361:	89 e5                	mov    %esp,%ebp
  asm("mov $0xCFC,%%edx\n\t"
80108363:	8b 45 08             	mov    0x8(%ebp),%eax
80108366:	ba fc 0c 00 00       	mov    $0xcfc,%edx
8010836b:	89 c0                	mov    %eax,%eax
8010836d:	ef                   	out    %eax,(%dx)
      "mov %0,%%eax\n\t"
      "out %%eax,%%dx\n\t"
      : :"r"(config));
}
8010836e:	90                   	nop
8010836f:	5d                   	pop    %ebp
80108370:	c3                   	ret    

80108371 <pci_read_config>:
uint pci_read_config(){
80108371:	55                   	push   %ebp
80108372:	89 e5                	mov    %esp,%ebp
80108374:	83 ec 18             	sub    $0x18,%esp
  uint data;
  asm("mov $0xCFC,%%edx\n\t"
80108377:	ba fc 0c 00 00       	mov    $0xcfc,%edx
8010837c:	ed                   	in     (%dx),%eax
8010837d:	89 45 f4             	mov    %eax,-0xc(%ebp)
      "in %%dx,%%eax\n\t"
      "mov %%eax,%0"
      :"=m"(data):);
  microdelay(200);
80108380:	83 ec 0c             	sub    $0xc,%esp
80108383:	68 c8 00 00 00       	push   $0xc8
80108388:	e8 aa a7 ff ff       	call   80102b37 <microdelay>
8010838d:	83 c4 10             	add    $0x10,%esp
  return data;
80108390:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
80108393:	c9                   	leave  
80108394:	c3                   	ret    

80108395 <pci_test>:


void pci_test(){
80108395:	55                   	push   %ebp
80108396:	89 e5                	mov    %esp,%ebp
80108398:	83 ec 10             	sub    $0x10,%esp
  uint data = 0x80001804;
8010839b:	c7 45 fc 04 18 00 80 	movl   $0x80001804,-0x4(%ebp)
  pci_write_config(data);
801083a2:	ff 75 fc             	push   -0x4(%ebp)
801083a5:	e8 a5 ff ff ff       	call   8010834f <pci_write_config>
801083aa:	83 c4 04             	add    $0x4,%esp
}
801083ad:	90                   	nop
801083ae:	c9                   	leave  
801083af:	c3                   	ret    

801083b0 <pci_access_config>:

void pci_access_config(uint bus_num,uint device_num,uint function_num,uint reg_addr,uint *data){
801083b0:	55                   	push   %ebp
801083b1:	89 e5                	mov    %esp,%ebp
801083b3:	83 ec 18             	sub    $0x18,%esp
  uint config_addr = ((bus_num & 0xFF)<<16) | ((device_num & 0x1F)<<11) | ((function_num & 0x7)<<8) |
801083b6:	8b 45 08             	mov    0x8(%ebp),%eax
801083b9:	c1 e0 10             	shl    $0x10,%eax
801083bc:	25 00 00 ff 00       	and    $0xff0000,%eax
801083c1:	89 c2                	mov    %eax,%edx
801083c3:	8b 45 0c             	mov    0xc(%ebp),%eax
801083c6:	c1 e0 0b             	shl    $0xb,%eax
801083c9:	0f b7 c0             	movzwl %ax,%eax
801083cc:	09 c2                	or     %eax,%edx
801083ce:	8b 45 10             	mov    0x10(%ebp),%eax
801083d1:	c1 e0 08             	shl    $0x8,%eax
801083d4:	25 00 07 00 00       	and    $0x700,%eax
801083d9:	09 c2                	or     %eax,%edx
    (reg_addr & 0xFC) | 0x80000000;
801083db:	8b 45 14             	mov    0x14(%ebp),%eax
801083de:	25 fc 00 00 00       	and    $0xfc,%eax
  uint config_addr = ((bus_num & 0xFF)<<16) | ((device_num & 0x1F)<<11) | ((function_num & 0x7)<<8) |
801083e3:	09 d0                	or     %edx,%eax
801083e5:	0d 00 00 00 80       	or     $0x80000000,%eax
801083ea:	89 45 f4             	mov    %eax,-0xc(%ebp)
  pci_write_config(config_addr);
801083ed:	ff 75 f4             	push   -0xc(%ebp)
801083f0:	e8 5a ff ff ff       	call   8010834f <pci_write_config>
801083f5:	83 c4 04             	add    $0x4,%esp
  *data = pci_read_config();
801083f8:	e8 74 ff ff ff       	call   80108371 <pci_read_config>
801083fd:	8b 55 18             	mov    0x18(%ebp),%edx
80108400:	89 02                	mov    %eax,(%edx)
}
80108402:	90                   	nop
80108403:	c9                   	leave  
80108404:	c3                   	ret    

80108405 <pci_write_config_register>:

void pci_write_config_register(uint bus_num,uint device_num,uint function_num,uint reg_addr,uint data){
80108405:	55                   	push   %ebp
80108406:	89 e5                	mov    %esp,%ebp
80108408:	83 ec 10             	sub    $0x10,%esp
  uint config_addr = ((bus_num & 0xFF)<<16) | ((device_num & 0x1F)<<11) | ((function_num & 0x7)<<8) |
8010840b:	8b 45 08             	mov    0x8(%ebp),%eax
8010840e:	c1 e0 10             	shl    $0x10,%eax
80108411:	25 00 00 ff 00       	and    $0xff0000,%eax
80108416:	89 c2                	mov    %eax,%edx
80108418:	8b 45 0c             	mov    0xc(%ebp),%eax
8010841b:	c1 e0 0b             	shl    $0xb,%eax
8010841e:	0f b7 c0             	movzwl %ax,%eax
80108421:	09 c2                	or     %eax,%edx
80108423:	8b 45 10             	mov    0x10(%ebp),%eax
80108426:	c1 e0 08             	shl    $0x8,%eax
80108429:	25 00 07 00 00       	and    $0x700,%eax
8010842e:	09 c2                	or     %eax,%edx
    (reg_addr & 0xFC) | 0x80000000;
80108430:	8b 45 14             	mov    0x14(%ebp),%eax
80108433:	25 fc 00 00 00       	and    $0xfc,%eax
  uint config_addr = ((bus_num & 0xFF)<<16) | ((device_num & 0x1F)<<11) | ((function_num & 0x7)<<8) |
80108438:	09 d0                	or     %edx,%eax
8010843a:	0d 00 00 00 80       	or     $0x80000000,%eax
8010843f:	89 45 fc             	mov    %eax,-0x4(%ebp)
  pci_write_config(config_addr);
80108442:	ff 75 fc             	push   -0x4(%ebp)
80108445:	e8 05 ff ff ff       	call   8010834f <pci_write_config>
8010844a:	83 c4 04             	add    $0x4,%esp
  pci_write_data(data);
8010844d:	ff 75 18             	push   0x18(%ebp)
80108450:	e8 0b ff ff ff       	call   80108360 <pci_write_data>
80108455:	83 c4 04             	add    $0x4,%esp
}
80108458:	90                   	nop
80108459:	c9                   	leave  
8010845a:	c3                   	ret    

8010845b <pci_init_device>:

struct pci_dev dev;
void pci_init_device(uint bus_num,uint device_num,uint function_num){
8010845b:	55                   	push   %ebp
8010845c:	89 e5                	mov    %esp,%ebp
8010845e:	53                   	push   %ebx
8010845f:	83 ec 14             	sub    $0x14,%esp
  uint data;
  dev.bus_num = bus_num;
80108462:	8b 45 08             	mov    0x8(%ebp),%eax
80108465:	a2 64 6e 19 80       	mov    %al,0x80196e64
  dev.device_num = device_num;
8010846a:	8b 45 0c             	mov    0xc(%ebp),%eax
8010846d:	a2 65 6e 19 80       	mov    %al,0x80196e65
  dev.function_num = function_num;
80108472:	8b 45 10             	mov    0x10(%ebp),%eax
80108475:	a2 66 6e 19 80       	mov    %al,0x80196e66
  cprintf("PCI Device Found Bus:0x%x Device:0x%x Function:%x\n",bus_num,device_num,function_num);
8010847a:	ff 75 10             	push   0x10(%ebp)
8010847d:	ff 75 0c             	push   0xc(%ebp)
80108480:	ff 75 08             	push   0x8(%ebp)
80108483:	68 c4 bf 10 80       	push   $0x8010bfc4
80108488:	e8 67 7f ff ff       	call   801003f4 <cprintf>
8010848d:	83 c4 10             	add    $0x10,%esp
  
  pci_access_config(bus_num,device_num,function_num,0,&data);
80108490:	83 ec 0c             	sub    $0xc,%esp
80108493:	8d 45 ec             	lea    -0x14(%ebp),%eax
80108496:	50                   	push   %eax
80108497:	6a 00                	push   $0x0
80108499:	ff 75 10             	push   0x10(%ebp)
8010849c:	ff 75 0c             	push   0xc(%ebp)
8010849f:	ff 75 08             	push   0x8(%ebp)
801084a2:	e8 09 ff ff ff       	call   801083b0 <pci_access_config>
801084a7:	83 c4 20             	add    $0x20,%esp
  uint device_id = data>>16;
801084aa:	8b 45 ec             	mov    -0x14(%ebp),%eax
801084ad:	c1 e8 10             	shr    $0x10,%eax
801084b0:	89 45 f4             	mov    %eax,-0xc(%ebp)
  uint vendor_id = data&0xFFFF;
801084b3:	8b 45 ec             	mov    -0x14(%ebp),%eax
801084b6:	25 ff ff 00 00       	and    $0xffff,%eax
801084bb:	89 45 f0             	mov    %eax,-0x10(%ebp)
  dev.device_id = device_id;
801084be:	8b 45 f4             	mov    -0xc(%ebp),%eax
801084c1:	a3 68 6e 19 80       	mov    %eax,0x80196e68
  dev.vendor_id = vendor_id;
801084c6:	8b 45 f0             	mov    -0x10(%ebp),%eax
801084c9:	a3 6c 6e 19 80       	mov    %eax,0x80196e6c
  cprintf("  Device ID:0x%x  Vendor ID:0x%x\n",device_id,vendor_id);
801084ce:	83 ec 04             	sub    $0x4,%esp
801084d1:	ff 75 f0             	push   -0x10(%ebp)
801084d4:	ff 75 f4             	push   -0xc(%ebp)
801084d7:	68 f8 bf 10 80       	push   $0x8010bff8
801084dc:	e8 13 7f ff ff       	call   801003f4 <cprintf>
801084e1:	83 c4 10             	add    $0x10,%esp
  
  pci_access_config(bus_num,device_num,function_num,0x8,&data);
801084e4:	83 ec 0c             	sub    $0xc,%esp
801084e7:	8d 45 ec             	lea    -0x14(%ebp),%eax
801084ea:	50                   	push   %eax
801084eb:	6a 08                	push   $0x8
801084ed:	ff 75 10             	push   0x10(%ebp)
801084f0:	ff 75 0c             	push   0xc(%ebp)
801084f3:	ff 75 08             	push   0x8(%ebp)
801084f6:	e8 b5 fe ff ff       	call   801083b0 <pci_access_config>
801084fb:	83 c4 20             	add    $0x20,%esp
  cprintf("  Base Class:0x%x  Sub Class:0x%x  Interface:0x%x  Revision ID:0x%x\n",
801084fe:	8b 45 ec             	mov    -0x14(%ebp),%eax
80108501:	0f b6 c8             	movzbl %al,%ecx
      data>>24,(data>>16)&0xFF,(data>>8)&0xFF,data&0xFF);
80108504:	8b 45 ec             	mov    -0x14(%ebp),%eax
80108507:	c1 e8 08             	shr    $0x8,%eax
  cprintf("  Base Class:0x%x  Sub Class:0x%x  Interface:0x%x  Revision ID:0x%x\n",
8010850a:	0f b6 d0             	movzbl %al,%edx
      data>>24,(data>>16)&0xFF,(data>>8)&0xFF,data&0xFF);
8010850d:	8b 45 ec             	mov    -0x14(%ebp),%eax
80108510:	c1 e8 10             	shr    $0x10,%eax
  cprintf("  Base Class:0x%x  Sub Class:0x%x  Interface:0x%x  Revision ID:0x%x\n",
80108513:	0f b6 c0             	movzbl %al,%eax
80108516:	8b 5d ec             	mov    -0x14(%ebp),%ebx
80108519:	c1 eb 18             	shr    $0x18,%ebx
8010851c:	83 ec 0c             	sub    $0xc,%esp
8010851f:	51                   	push   %ecx
80108520:	52                   	push   %edx
80108521:	50                   	push   %eax
80108522:	53                   	push   %ebx
80108523:	68 1c c0 10 80       	push   $0x8010c01c
80108528:	e8 c7 7e ff ff       	call   801003f4 <cprintf>
8010852d:	83 c4 20             	add    $0x20,%esp
  dev.base_class = data>>24;
80108530:	8b 45 ec             	mov    -0x14(%ebp),%eax
80108533:	c1 e8 18             	shr    $0x18,%eax
80108536:	a2 70 6e 19 80       	mov    %al,0x80196e70
  dev.sub_class = (data>>16)&0xFF;
8010853b:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010853e:	c1 e8 10             	shr    $0x10,%eax
80108541:	a2 71 6e 19 80       	mov    %al,0x80196e71
  dev.interface = (data>>8)&0xFF;
80108546:	8b 45 ec             	mov    -0x14(%ebp),%eax
80108549:	c1 e8 08             	shr    $0x8,%eax
8010854c:	a2 72 6e 19 80       	mov    %al,0x80196e72
  dev.revision_id = data&0xFF;
80108551:	8b 45 ec             	mov    -0x14(%ebp),%eax
80108554:	a2 73 6e 19 80       	mov    %al,0x80196e73
  
  pci_access_config(bus_num,device_num,function_num,0x10,&data);
80108559:	83 ec 0c             	sub    $0xc,%esp
8010855c:	8d 45 ec             	lea    -0x14(%ebp),%eax
8010855f:	50                   	push   %eax
80108560:	6a 10                	push   $0x10
80108562:	ff 75 10             	push   0x10(%ebp)
80108565:	ff 75 0c             	push   0xc(%ebp)
80108568:	ff 75 08             	push   0x8(%ebp)
8010856b:	e8 40 fe ff ff       	call   801083b0 <pci_access_config>
80108570:	83 c4 20             	add    $0x20,%esp
  dev.bar0 = data;
80108573:	8b 45 ec             	mov    -0x14(%ebp),%eax
80108576:	a3 74 6e 19 80       	mov    %eax,0x80196e74
  pci_access_config(bus_num,device_num,function_num,0x14,&data);
8010857b:	83 ec 0c             	sub    $0xc,%esp
8010857e:	8d 45 ec             	lea    -0x14(%ebp),%eax
80108581:	50                   	push   %eax
80108582:	6a 14                	push   $0x14
80108584:	ff 75 10             	push   0x10(%ebp)
80108587:	ff 75 0c             	push   0xc(%ebp)
8010858a:	ff 75 08             	push   0x8(%ebp)
8010858d:	e8 1e fe ff ff       	call   801083b0 <pci_access_config>
80108592:	83 c4 20             	add    $0x20,%esp
  dev.bar1 = data;
80108595:	8b 45 ec             	mov    -0x14(%ebp),%eax
80108598:	a3 78 6e 19 80       	mov    %eax,0x80196e78
  if(device_id == I8254_DEVICE_ID && vendor_id == I8254_VENDOR_ID){
8010859d:	81 7d f4 0e 10 00 00 	cmpl   $0x100e,-0xc(%ebp)
801085a4:	75 5a                	jne    80108600 <pci_init_device+0x1a5>
801085a6:	81 7d f0 86 80 00 00 	cmpl   $0x8086,-0x10(%ebp)
801085ad:	75 51                	jne    80108600 <pci_init_device+0x1a5>
    cprintf("E1000 Ethernet NIC Found\n");
801085af:	83 ec 0c             	sub    $0xc,%esp
801085b2:	68 61 c0 10 80       	push   $0x8010c061
801085b7:	e8 38 7e ff ff       	call   801003f4 <cprintf>
801085bc:	83 c4 10             	add    $0x10,%esp
    pci_access_config(bus_num,device_num,function_num,0xF0,&data);
801085bf:	83 ec 0c             	sub    $0xc,%esp
801085c2:	8d 45 ec             	lea    -0x14(%ebp),%eax
801085c5:	50                   	push   %eax
801085c6:	68 f0 00 00 00       	push   $0xf0
801085cb:	ff 75 10             	push   0x10(%ebp)
801085ce:	ff 75 0c             	push   0xc(%ebp)
801085d1:	ff 75 08             	push   0x8(%ebp)
801085d4:	e8 d7 fd ff ff       	call   801083b0 <pci_access_config>
801085d9:	83 c4 20             	add    $0x20,%esp
    cprintf("Message Control:%x\n",data);
801085dc:	8b 45 ec             	mov    -0x14(%ebp),%eax
801085df:	83 ec 08             	sub    $0x8,%esp
801085e2:	50                   	push   %eax
801085e3:	68 7b c0 10 80       	push   $0x8010c07b
801085e8:	e8 07 7e ff ff       	call   801003f4 <cprintf>
801085ed:	83 c4 10             	add    $0x10,%esp
    i8254_init(&dev);
801085f0:	83 ec 0c             	sub    $0xc,%esp
801085f3:	68 64 6e 19 80       	push   $0x80196e64
801085f8:	e8 09 00 00 00       	call   80108606 <i8254_init>
801085fd:	83 c4 10             	add    $0x10,%esp
  }
}
80108600:	90                   	nop
80108601:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80108604:	c9                   	leave  
80108605:	c3                   	ret    

80108606 <i8254_init>:

uint base_addr;
uchar mac_addr[6] = {0};
uchar my_ip[4] = {10,0,1,10}; 
uint *intr_addr;
void i8254_init(struct pci_dev *dev){
80108606:	55                   	push   %ebp
80108607:	89 e5                	mov    %esp,%ebp
80108609:	53                   	push   %ebx
8010860a:	83 ec 14             	sub    $0x14,%esp
  uint cmd_reg;
  //Enable Bus Master
  pci_access_config(dev->bus_num,dev->device_num,dev->function_num,0x04,&cmd_reg);
8010860d:	8b 45 08             	mov    0x8(%ebp),%eax
80108610:	0f b6 40 02          	movzbl 0x2(%eax),%eax
80108614:	0f b6 c8             	movzbl %al,%ecx
80108617:	8b 45 08             	mov    0x8(%ebp),%eax
8010861a:	0f b6 40 01          	movzbl 0x1(%eax),%eax
8010861e:	0f b6 d0             	movzbl %al,%edx
80108621:	8b 45 08             	mov    0x8(%ebp),%eax
80108624:	0f b6 00             	movzbl (%eax),%eax
80108627:	0f b6 c0             	movzbl %al,%eax
8010862a:	83 ec 0c             	sub    $0xc,%esp
8010862d:	8d 5d ec             	lea    -0x14(%ebp),%ebx
80108630:	53                   	push   %ebx
80108631:	6a 04                	push   $0x4
80108633:	51                   	push   %ecx
80108634:	52                   	push   %edx
80108635:	50                   	push   %eax
80108636:	e8 75 fd ff ff       	call   801083b0 <pci_access_config>
8010863b:	83 c4 20             	add    $0x20,%esp
  cmd_reg = cmd_reg | PCI_CMD_BUS_MASTER;
8010863e:	8b 45 ec             	mov    -0x14(%ebp),%eax
80108641:	83 c8 04             	or     $0x4,%eax
80108644:	89 45 ec             	mov    %eax,-0x14(%ebp)
  pci_write_config_register(dev->bus_num,dev->device_num,dev->function_num,0x04,cmd_reg);
80108647:	8b 5d ec             	mov    -0x14(%ebp),%ebx
8010864a:	8b 45 08             	mov    0x8(%ebp),%eax
8010864d:	0f b6 40 02          	movzbl 0x2(%eax),%eax
80108651:	0f b6 c8             	movzbl %al,%ecx
80108654:	8b 45 08             	mov    0x8(%ebp),%eax
80108657:	0f b6 40 01          	movzbl 0x1(%eax),%eax
8010865b:	0f b6 d0             	movzbl %al,%edx
8010865e:	8b 45 08             	mov    0x8(%ebp),%eax
80108661:	0f b6 00             	movzbl (%eax),%eax
80108664:	0f b6 c0             	movzbl %al,%eax
80108667:	83 ec 0c             	sub    $0xc,%esp
8010866a:	53                   	push   %ebx
8010866b:	6a 04                	push   $0x4
8010866d:	51                   	push   %ecx
8010866e:	52                   	push   %edx
8010866f:	50                   	push   %eax
80108670:	e8 90 fd ff ff       	call   80108405 <pci_write_config_register>
80108675:	83 c4 20             	add    $0x20,%esp
  
  base_addr = PCI_P2V(dev->bar0);
80108678:	8b 45 08             	mov    0x8(%ebp),%eax
8010867b:	8b 40 10             	mov    0x10(%eax),%eax
8010867e:	05 00 00 00 40       	add    $0x40000000,%eax
80108683:	a3 7c 6e 19 80       	mov    %eax,0x80196e7c
  uint *ctrl = (uint *)base_addr;
80108688:	a1 7c 6e 19 80       	mov    0x80196e7c,%eax
8010868d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  //Disable Interrupts
  uint *imc = (uint *)(base_addr+0xD8);
80108690:	a1 7c 6e 19 80       	mov    0x80196e7c,%eax
80108695:	05 d8 00 00 00       	add    $0xd8,%eax
8010869a:	89 45 f0             	mov    %eax,-0x10(%ebp)
  *imc = 0xFFFFFFFF;
8010869d:	8b 45 f0             	mov    -0x10(%ebp),%eax
801086a0:	c7 00 ff ff ff ff    	movl   $0xffffffff,(%eax)
  
  //Reset NIC
  *ctrl = *ctrl | I8254_CTRL_RST;
801086a6:	8b 45 f4             	mov    -0xc(%ebp),%eax
801086a9:	8b 00                	mov    (%eax),%eax
801086ab:	0d 00 00 00 04       	or     $0x4000000,%eax
801086b0:	89 c2                	mov    %eax,%edx
801086b2:	8b 45 f4             	mov    -0xc(%ebp),%eax
801086b5:	89 10                	mov    %edx,(%eax)

  //Enable Interrupts
  *imc = 0xFFFFFFFF;
801086b7:	8b 45 f0             	mov    -0x10(%ebp),%eax
801086ba:	c7 00 ff ff ff ff    	movl   $0xffffffff,(%eax)

  //Enable Link
  *ctrl |= I8254_CTRL_SLU;
801086c0:	8b 45 f4             	mov    -0xc(%ebp),%eax
801086c3:	8b 00                	mov    (%eax),%eax
801086c5:	83 c8 40             	or     $0x40,%eax
801086c8:	89 c2                	mov    %eax,%edx
801086ca:	8b 45 f4             	mov    -0xc(%ebp),%eax
801086cd:	89 10                	mov    %edx,(%eax)
  
  //General Configuration
  *ctrl &= (~I8254_CTRL_PHY_RST | ~I8254_CTRL_VME | ~I8254_CTRL_ILOS);
801086cf:	8b 45 f4             	mov    -0xc(%ebp),%eax
801086d2:	8b 10                	mov    (%eax),%edx
801086d4:	8b 45 f4             	mov    -0xc(%ebp),%eax
801086d7:	89 10                	mov    %edx,(%eax)
  cprintf("E1000 General Configuration Done\n");
801086d9:	83 ec 0c             	sub    $0xc,%esp
801086dc:	68 90 c0 10 80       	push   $0x8010c090
801086e1:	e8 0e 7d ff ff       	call   801003f4 <cprintf>
801086e6:	83 c4 10             	add    $0x10,%esp
  intr_addr = (uint *)kalloc();
801086e9:	e8 b2 a0 ff ff       	call   801027a0 <kalloc>
801086ee:	a3 88 6e 19 80       	mov    %eax,0x80196e88
  *intr_addr = 0;
801086f3:	a1 88 6e 19 80       	mov    0x80196e88,%eax
801086f8:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  cprintf("INTR_ADDR:%x\n",intr_addr);
801086fe:	a1 88 6e 19 80       	mov    0x80196e88,%eax
80108703:	83 ec 08             	sub    $0x8,%esp
80108706:	50                   	push   %eax
80108707:	68 b2 c0 10 80       	push   $0x8010c0b2
8010870c:	e8 e3 7c ff ff       	call   801003f4 <cprintf>
80108711:	83 c4 10             	add    $0x10,%esp
  i8254_init_recv();
80108714:	e8 50 00 00 00       	call   80108769 <i8254_init_recv>
  i8254_init_send();
80108719:	e8 69 03 00 00       	call   80108a87 <i8254_init_send>
  cprintf("IP Address %d.%d.%d.%d\n",
      my_ip[0],
      my_ip[1],
      my_ip[2],
      my_ip[3]);
8010871e:	0f b6 05 07 f5 10 80 	movzbl 0x8010f507,%eax
  cprintf("IP Address %d.%d.%d.%d\n",
80108725:	0f b6 d8             	movzbl %al,%ebx
      my_ip[2],
80108728:	0f b6 05 06 f5 10 80 	movzbl 0x8010f506,%eax
  cprintf("IP Address %d.%d.%d.%d\n",
8010872f:	0f b6 c8             	movzbl %al,%ecx
      my_ip[1],
80108732:	0f b6 05 05 f5 10 80 	movzbl 0x8010f505,%eax
  cprintf("IP Address %d.%d.%d.%d\n",
80108739:	0f b6 d0             	movzbl %al,%edx
      my_ip[0],
8010873c:	0f b6 05 04 f5 10 80 	movzbl 0x8010f504,%eax
  cprintf("IP Address %d.%d.%d.%d\n",
80108743:	0f b6 c0             	movzbl %al,%eax
80108746:	83 ec 0c             	sub    $0xc,%esp
80108749:	53                   	push   %ebx
8010874a:	51                   	push   %ecx
8010874b:	52                   	push   %edx
8010874c:	50                   	push   %eax
8010874d:	68 c0 c0 10 80       	push   $0x8010c0c0
80108752:	e8 9d 7c ff ff       	call   801003f4 <cprintf>
80108757:	83 c4 20             	add    $0x20,%esp
  *imc = 0x0;
8010875a:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010875d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
}
80108763:	90                   	nop
80108764:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80108767:	c9                   	leave  
80108768:	c3                   	ret    

80108769 <i8254_init_recv>:

void i8254_init_recv(){
80108769:	55                   	push   %ebp
8010876a:	89 e5                	mov    %esp,%ebp
8010876c:	57                   	push   %edi
8010876d:	56                   	push   %esi
8010876e:	53                   	push   %ebx
8010876f:	83 ec 6c             	sub    $0x6c,%esp
  
  uint data_l = i8254_read_eeprom(0x0);
80108772:	83 ec 0c             	sub    $0xc,%esp
80108775:	6a 00                	push   $0x0
80108777:	e8 e8 04 00 00       	call   80108c64 <i8254_read_eeprom>
8010877c:	83 c4 10             	add    $0x10,%esp
8010877f:	89 45 d8             	mov    %eax,-0x28(%ebp)
  mac_addr[0] = data_l&0xFF;
80108782:	8b 45 d8             	mov    -0x28(%ebp),%eax
80108785:	a2 80 6e 19 80       	mov    %al,0x80196e80
  mac_addr[1] = data_l>>8;
8010878a:	8b 45 d8             	mov    -0x28(%ebp),%eax
8010878d:	c1 e8 08             	shr    $0x8,%eax
80108790:	a2 81 6e 19 80       	mov    %al,0x80196e81
  uint data_m = i8254_read_eeprom(0x1);
80108795:	83 ec 0c             	sub    $0xc,%esp
80108798:	6a 01                	push   $0x1
8010879a:	e8 c5 04 00 00       	call   80108c64 <i8254_read_eeprom>
8010879f:	83 c4 10             	add    $0x10,%esp
801087a2:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  mac_addr[2] = data_m&0xFF;
801087a5:	8b 45 d4             	mov    -0x2c(%ebp),%eax
801087a8:	a2 82 6e 19 80       	mov    %al,0x80196e82
  mac_addr[3] = data_m>>8;
801087ad:	8b 45 d4             	mov    -0x2c(%ebp),%eax
801087b0:	c1 e8 08             	shr    $0x8,%eax
801087b3:	a2 83 6e 19 80       	mov    %al,0x80196e83
  uint data_h = i8254_read_eeprom(0x2);
801087b8:	83 ec 0c             	sub    $0xc,%esp
801087bb:	6a 02                	push   $0x2
801087bd:	e8 a2 04 00 00       	call   80108c64 <i8254_read_eeprom>
801087c2:	83 c4 10             	add    $0x10,%esp
801087c5:	89 45 d0             	mov    %eax,-0x30(%ebp)
  mac_addr[4] = data_h&0xFF;
801087c8:	8b 45 d0             	mov    -0x30(%ebp),%eax
801087cb:	a2 84 6e 19 80       	mov    %al,0x80196e84
  mac_addr[5] = data_h>>8;
801087d0:	8b 45 d0             	mov    -0x30(%ebp),%eax
801087d3:	c1 e8 08             	shr    $0x8,%eax
801087d6:	a2 85 6e 19 80       	mov    %al,0x80196e85
      mac_addr[0],
      mac_addr[1],
      mac_addr[2],
      mac_addr[3],
      mac_addr[4],
      mac_addr[5]);
801087db:	0f b6 05 85 6e 19 80 	movzbl 0x80196e85,%eax
  cprintf("MAC Address %x:%x:%x:%x:%x:%x\n",
801087e2:	0f b6 f8             	movzbl %al,%edi
      mac_addr[4],
801087e5:	0f b6 05 84 6e 19 80 	movzbl 0x80196e84,%eax
  cprintf("MAC Address %x:%x:%x:%x:%x:%x\n",
801087ec:	0f b6 f0             	movzbl %al,%esi
      mac_addr[3],
801087ef:	0f b6 05 83 6e 19 80 	movzbl 0x80196e83,%eax
  cprintf("MAC Address %x:%x:%x:%x:%x:%x\n",
801087f6:	0f b6 d8             	movzbl %al,%ebx
      mac_addr[2],
801087f9:	0f b6 05 82 6e 19 80 	movzbl 0x80196e82,%eax
  cprintf("MAC Address %x:%x:%x:%x:%x:%x\n",
80108800:	0f b6 c8             	movzbl %al,%ecx
      mac_addr[1],
80108803:	0f b6 05 81 6e 19 80 	movzbl 0x80196e81,%eax
  cprintf("MAC Address %x:%x:%x:%x:%x:%x\n",
8010880a:	0f b6 d0             	movzbl %al,%edx
      mac_addr[0],
8010880d:	0f b6 05 80 6e 19 80 	movzbl 0x80196e80,%eax
  cprintf("MAC Address %x:%x:%x:%x:%x:%x\n",
80108814:	0f b6 c0             	movzbl %al,%eax
80108817:	83 ec 04             	sub    $0x4,%esp
8010881a:	57                   	push   %edi
8010881b:	56                   	push   %esi
8010881c:	53                   	push   %ebx
8010881d:	51                   	push   %ecx
8010881e:	52                   	push   %edx
8010881f:	50                   	push   %eax
80108820:	68 d8 c0 10 80       	push   $0x8010c0d8
80108825:	e8 ca 7b ff ff       	call   801003f4 <cprintf>
8010882a:	83 c4 20             	add    $0x20,%esp

  uint *ral = (uint *)(base_addr + 0x5400);
8010882d:	a1 7c 6e 19 80       	mov    0x80196e7c,%eax
80108832:	05 00 54 00 00       	add    $0x5400,%eax
80108837:	89 45 cc             	mov    %eax,-0x34(%ebp)
  uint *rah = (uint *)(base_addr + 0x5404);
8010883a:	a1 7c 6e 19 80       	mov    0x80196e7c,%eax
8010883f:	05 04 54 00 00       	add    $0x5404,%eax
80108844:	89 45 c8             	mov    %eax,-0x38(%ebp)

  *ral = (data_l | (data_m << 16));
80108847:	8b 45 d4             	mov    -0x2c(%ebp),%eax
8010884a:	c1 e0 10             	shl    $0x10,%eax
8010884d:	0b 45 d8             	or     -0x28(%ebp),%eax
80108850:	89 c2                	mov    %eax,%edx
80108852:	8b 45 cc             	mov    -0x34(%ebp),%eax
80108855:	89 10                	mov    %edx,(%eax)
  *rah = (data_h | I8254_RAH_AS_DEST | I8254_RAH_AV);
80108857:	8b 45 d0             	mov    -0x30(%ebp),%eax
8010885a:	0d 00 00 00 80       	or     $0x80000000,%eax
8010885f:	89 c2                	mov    %eax,%edx
80108861:	8b 45 c8             	mov    -0x38(%ebp),%eax
80108864:	89 10                	mov    %edx,(%eax)

  uint *mta = (uint *)(base_addr + 0x5200);
80108866:	a1 7c 6e 19 80       	mov    0x80196e7c,%eax
8010886b:	05 00 52 00 00       	add    $0x5200,%eax
80108870:	89 45 c4             	mov    %eax,-0x3c(%ebp)
  for(int i=0;i<128;i++){
80108873:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
8010887a:	eb 19                	jmp    80108895 <i8254_init_recv+0x12c>
    mta[i] = 0;
8010887c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010887f:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80108886:	8b 45 c4             	mov    -0x3c(%ebp),%eax
80108889:	01 d0                	add    %edx,%eax
8010888b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  for(int i=0;i<128;i++){
80108891:	83 45 e4 01          	addl   $0x1,-0x1c(%ebp)
80108895:	83 7d e4 7f          	cmpl   $0x7f,-0x1c(%ebp)
80108899:	7e e1                	jle    8010887c <i8254_init_recv+0x113>
  }

  uint *ims = (uint *)(base_addr + 0xD0);
8010889b:	a1 7c 6e 19 80       	mov    0x80196e7c,%eax
801088a0:	05 d0 00 00 00       	add    $0xd0,%eax
801088a5:	89 45 c0             	mov    %eax,-0x40(%ebp)
  *ims = (I8254_IMS_RXT0 | I8254_IMS_RXDMT0 | I8254_IMS_RXSEQ | I8254_IMS_LSC | I8254_IMS_RXO);
801088a8:	8b 45 c0             	mov    -0x40(%ebp),%eax
801088ab:	c7 00 dc 00 00 00    	movl   $0xdc,(%eax)
  uint *ics = (uint *)(base_addr + 0xC8);
801088b1:	a1 7c 6e 19 80       	mov    0x80196e7c,%eax
801088b6:	05 c8 00 00 00       	add    $0xc8,%eax
801088bb:	89 45 bc             	mov    %eax,-0x44(%ebp)
  *ics = (I8254_IMS_RXT0 | I8254_IMS_RXDMT0 | I8254_IMS_RXSEQ | I8254_IMS_LSC | I8254_IMS_RXO);
801088be:	8b 45 bc             	mov    -0x44(%ebp),%eax
801088c1:	c7 00 dc 00 00 00    	movl   $0xdc,(%eax)



  uint *rxdctl = (uint *)(base_addr + 0x2828);
801088c7:	a1 7c 6e 19 80       	mov    0x80196e7c,%eax
801088cc:	05 28 28 00 00       	add    $0x2828,%eax
801088d1:	89 45 b8             	mov    %eax,-0x48(%ebp)
  *rxdctl = 0;
801088d4:	8b 45 b8             	mov    -0x48(%ebp),%eax
801088d7:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

  uint *rctl = (uint *)(base_addr + 0x100);
801088dd:	a1 7c 6e 19 80       	mov    0x80196e7c,%eax
801088e2:	05 00 01 00 00       	add    $0x100,%eax
801088e7:	89 45 b4             	mov    %eax,-0x4c(%ebp)
  *rctl = (I8254_RCTL_UPE | I8254_RCTL_MPE | I8254_RCTL_BAM | I8254_RCTL_BSIZE | I8254_RCTL_SECRC);
801088ea:	8b 45 b4             	mov    -0x4c(%ebp),%eax
801088ed:	c7 00 18 80 00 04    	movl   $0x4008018,(%eax)

  uint recv_desc_addr = (uint)kalloc();
801088f3:	e8 a8 9e ff ff       	call   801027a0 <kalloc>
801088f8:	89 45 b0             	mov    %eax,-0x50(%ebp)
  uint *rdbal = (uint *)(base_addr + 0x2800);
801088fb:	a1 7c 6e 19 80       	mov    0x80196e7c,%eax
80108900:	05 00 28 00 00       	add    $0x2800,%eax
80108905:	89 45 ac             	mov    %eax,-0x54(%ebp)
  uint *rdbah = (uint *)(base_addr + 0x2804);
80108908:	a1 7c 6e 19 80       	mov    0x80196e7c,%eax
8010890d:	05 04 28 00 00       	add    $0x2804,%eax
80108912:	89 45 a8             	mov    %eax,-0x58(%ebp)
  uint *rdlen = (uint *)(base_addr + 0x2808);
80108915:	a1 7c 6e 19 80       	mov    0x80196e7c,%eax
8010891a:	05 08 28 00 00       	add    $0x2808,%eax
8010891f:	89 45 a4             	mov    %eax,-0x5c(%ebp)
  uint *rdh = (uint *)(base_addr + 0x2810);
80108922:	a1 7c 6e 19 80       	mov    0x80196e7c,%eax
80108927:	05 10 28 00 00       	add    $0x2810,%eax
8010892c:	89 45 a0             	mov    %eax,-0x60(%ebp)
  uint *rdt = (uint *)(base_addr + 0x2818);
8010892f:	a1 7c 6e 19 80       	mov    0x80196e7c,%eax
80108934:	05 18 28 00 00       	add    $0x2818,%eax
80108939:	89 45 9c             	mov    %eax,-0x64(%ebp)

  *rdbal = V2P(recv_desc_addr);
8010893c:	8b 45 b0             	mov    -0x50(%ebp),%eax
8010893f:	8d 90 00 00 00 80    	lea    -0x80000000(%eax),%edx
80108945:	8b 45 ac             	mov    -0x54(%ebp),%eax
80108948:	89 10                	mov    %edx,(%eax)
  *rdbah = 0;
8010894a:	8b 45 a8             	mov    -0x58(%ebp),%eax
8010894d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  *rdlen = sizeof(struct i8254_recv_desc)*I8254_RECV_DESC_NUM;
80108953:	8b 45 a4             	mov    -0x5c(%ebp),%eax
80108956:	c7 00 00 10 00 00    	movl   $0x1000,(%eax)
  *rdh = 0;
8010895c:	8b 45 a0             	mov    -0x60(%ebp),%eax
8010895f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  *rdt = I8254_RECV_DESC_NUM;
80108965:	8b 45 9c             	mov    -0x64(%ebp),%eax
80108968:	c7 00 00 01 00 00    	movl   $0x100,(%eax)

  struct i8254_recv_desc *recv_desc = (struct i8254_recv_desc *)recv_desc_addr;
8010896e:	8b 45 b0             	mov    -0x50(%ebp),%eax
80108971:	89 45 98             	mov    %eax,-0x68(%ebp)
  for(int i=0;i<I8254_RECV_DESC_NUM;i++){
80108974:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
8010897b:	eb 73                	jmp    801089f0 <i8254_init_recv+0x287>
    recv_desc[i].padding = 0;
8010897d:	8b 45 e0             	mov    -0x20(%ebp),%eax
80108980:	c1 e0 04             	shl    $0x4,%eax
80108983:	89 c2                	mov    %eax,%edx
80108985:	8b 45 98             	mov    -0x68(%ebp),%eax
80108988:	01 d0                	add    %edx,%eax
8010898a:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
    recv_desc[i].len = 0;
80108991:	8b 45 e0             	mov    -0x20(%ebp),%eax
80108994:	c1 e0 04             	shl    $0x4,%eax
80108997:	89 c2                	mov    %eax,%edx
80108999:	8b 45 98             	mov    -0x68(%ebp),%eax
8010899c:	01 d0                	add    %edx,%eax
8010899e:	66 c7 40 08 00 00    	movw   $0x0,0x8(%eax)
    recv_desc[i].chk_sum = 0;
801089a4:	8b 45 e0             	mov    -0x20(%ebp),%eax
801089a7:	c1 e0 04             	shl    $0x4,%eax
801089aa:	89 c2                	mov    %eax,%edx
801089ac:	8b 45 98             	mov    -0x68(%ebp),%eax
801089af:	01 d0                	add    %edx,%eax
801089b1:	66 c7 40 0a 00 00    	movw   $0x0,0xa(%eax)
    recv_desc[i].status = 0;
801089b7:	8b 45 e0             	mov    -0x20(%ebp),%eax
801089ba:	c1 e0 04             	shl    $0x4,%eax
801089bd:	89 c2                	mov    %eax,%edx
801089bf:	8b 45 98             	mov    -0x68(%ebp),%eax
801089c2:	01 d0                	add    %edx,%eax
801089c4:	c6 40 0c 00          	movb   $0x0,0xc(%eax)
    recv_desc[i].errors = 0;
801089c8:	8b 45 e0             	mov    -0x20(%ebp),%eax
801089cb:	c1 e0 04             	shl    $0x4,%eax
801089ce:	89 c2                	mov    %eax,%edx
801089d0:	8b 45 98             	mov    -0x68(%ebp),%eax
801089d3:	01 d0                	add    %edx,%eax
801089d5:	c6 40 0d 00          	movb   $0x0,0xd(%eax)
    recv_desc[i].special = 0;
801089d9:	8b 45 e0             	mov    -0x20(%ebp),%eax
801089dc:	c1 e0 04             	shl    $0x4,%eax
801089df:	89 c2                	mov    %eax,%edx
801089e1:	8b 45 98             	mov    -0x68(%ebp),%eax
801089e4:	01 d0                	add    %edx,%eax
801089e6:	66 c7 40 0e 00 00    	movw   $0x0,0xe(%eax)
  for(int i=0;i<I8254_RECV_DESC_NUM;i++){
801089ec:	83 45 e0 01          	addl   $0x1,-0x20(%ebp)
801089f0:	81 7d e0 ff 00 00 00 	cmpl   $0xff,-0x20(%ebp)
801089f7:	7e 84                	jle    8010897d <i8254_init_recv+0x214>
  }

  for(int i=0;i<(I8254_RECV_DESC_NUM)/2;i++){
801089f9:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
80108a00:	eb 57                	jmp    80108a59 <i8254_init_recv+0x2f0>
    uint buf_addr = (uint)kalloc();
80108a02:	e8 99 9d ff ff       	call   801027a0 <kalloc>
80108a07:	89 45 94             	mov    %eax,-0x6c(%ebp)
    if(buf_addr == 0){
80108a0a:	83 7d 94 00          	cmpl   $0x0,-0x6c(%ebp)
80108a0e:	75 12                	jne    80108a22 <i8254_init_recv+0x2b9>
      cprintf("failed to allocate buffer area\n");
80108a10:	83 ec 0c             	sub    $0xc,%esp
80108a13:	68 f8 c0 10 80       	push   $0x8010c0f8
80108a18:	e8 d7 79 ff ff       	call   801003f4 <cprintf>
80108a1d:	83 c4 10             	add    $0x10,%esp
      break;
80108a20:	eb 3d                	jmp    80108a5f <i8254_init_recv+0x2f6>
    }
    recv_desc[i].buf_addr = V2P(buf_addr);
80108a22:	8b 45 dc             	mov    -0x24(%ebp),%eax
80108a25:	c1 e0 04             	shl    $0x4,%eax
80108a28:	89 c2                	mov    %eax,%edx
80108a2a:	8b 45 98             	mov    -0x68(%ebp),%eax
80108a2d:	01 d0                	add    %edx,%eax
80108a2f:	8b 55 94             	mov    -0x6c(%ebp),%edx
80108a32:	81 c2 00 00 00 80    	add    $0x80000000,%edx
80108a38:	89 10                	mov    %edx,(%eax)
    recv_desc[i+1].buf_addr = V2P(buf_addr + 0x800);
80108a3a:	8b 45 dc             	mov    -0x24(%ebp),%eax
80108a3d:	83 c0 01             	add    $0x1,%eax
80108a40:	c1 e0 04             	shl    $0x4,%eax
80108a43:	89 c2                	mov    %eax,%edx
80108a45:	8b 45 98             	mov    -0x68(%ebp),%eax
80108a48:	01 d0                	add    %edx,%eax
80108a4a:	8b 55 94             	mov    -0x6c(%ebp),%edx
80108a4d:	81 ea 00 f8 ff 7f    	sub    $0x7ffff800,%edx
80108a53:	89 10                	mov    %edx,(%eax)
  for(int i=0;i<(I8254_RECV_DESC_NUM)/2;i++){
80108a55:	83 45 dc 01          	addl   $0x1,-0x24(%ebp)
80108a59:	83 7d dc 7f          	cmpl   $0x7f,-0x24(%ebp)
80108a5d:	7e a3                	jle    80108a02 <i8254_init_recv+0x299>
  }

  *rctl |= I8254_RCTL_EN;
80108a5f:	8b 45 b4             	mov    -0x4c(%ebp),%eax
80108a62:	8b 00                	mov    (%eax),%eax
80108a64:	83 c8 02             	or     $0x2,%eax
80108a67:	89 c2                	mov    %eax,%edx
80108a69:	8b 45 b4             	mov    -0x4c(%ebp),%eax
80108a6c:	89 10                	mov    %edx,(%eax)
  cprintf("E1000 Recieve Initialize Done\n");
80108a6e:	83 ec 0c             	sub    $0xc,%esp
80108a71:	68 18 c1 10 80       	push   $0x8010c118
80108a76:	e8 79 79 ff ff       	call   801003f4 <cprintf>
80108a7b:	83 c4 10             	add    $0x10,%esp
}
80108a7e:	90                   	nop
80108a7f:	8d 65 f4             	lea    -0xc(%ebp),%esp
80108a82:	5b                   	pop    %ebx
80108a83:	5e                   	pop    %esi
80108a84:	5f                   	pop    %edi
80108a85:	5d                   	pop    %ebp
80108a86:	c3                   	ret    

80108a87 <i8254_init_send>:

void i8254_init_send(){
80108a87:	55                   	push   %ebp
80108a88:	89 e5                	mov    %esp,%ebp
80108a8a:	83 ec 48             	sub    $0x48,%esp
  uint *txdctl = (uint *)(base_addr + 0x3828);
80108a8d:	a1 7c 6e 19 80       	mov    0x80196e7c,%eax
80108a92:	05 28 38 00 00       	add    $0x3828,%eax
80108a97:	89 45 ec             	mov    %eax,-0x14(%ebp)
  *txdctl = (I8254_TXDCTL_WTHRESH | I8254_TXDCTL_GRAN_DESC);
80108a9a:	8b 45 ec             	mov    -0x14(%ebp),%eax
80108a9d:	c7 00 00 00 01 01    	movl   $0x1010000,(%eax)

  uint tx_desc_addr = (uint)kalloc();
80108aa3:	e8 f8 9c ff ff       	call   801027a0 <kalloc>
80108aa8:	89 45 e8             	mov    %eax,-0x18(%ebp)
  uint *tdbal = (uint *)(base_addr + 0x3800);
80108aab:	a1 7c 6e 19 80       	mov    0x80196e7c,%eax
80108ab0:	05 00 38 00 00       	add    $0x3800,%eax
80108ab5:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  uint *tdbah = (uint *)(base_addr + 0x3804);
80108ab8:	a1 7c 6e 19 80       	mov    0x80196e7c,%eax
80108abd:	05 04 38 00 00       	add    $0x3804,%eax
80108ac2:	89 45 e0             	mov    %eax,-0x20(%ebp)
  uint *tdlen = (uint *)(base_addr + 0x3808);
80108ac5:	a1 7c 6e 19 80       	mov    0x80196e7c,%eax
80108aca:	05 08 38 00 00       	add    $0x3808,%eax
80108acf:	89 45 dc             	mov    %eax,-0x24(%ebp)

  *tdbal = V2P(tx_desc_addr);
80108ad2:	8b 45 e8             	mov    -0x18(%ebp),%eax
80108ad5:	8d 90 00 00 00 80    	lea    -0x80000000(%eax),%edx
80108adb:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80108ade:	89 10                	mov    %edx,(%eax)
  *tdbah = 0;
80108ae0:	8b 45 e0             	mov    -0x20(%ebp),%eax
80108ae3:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  *tdlen = sizeof(struct i8254_send_desc)*I8254_SEND_DESC_NUM;
80108ae9:	8b 45 dc             	mov    -0x24(%ebp),%eax
80108aec:	c7 00 00 10 00 00    	movl   $0x1000,(%eax)
  uint *tdh = (uint *)(base_addr + 0x3810);
80108af2:	a1 7c 6e 19 80       	mov    0x80196e7c,%eax
80108af7:	05 10 38 00 00       	add    $0x3810,%eax
80108afc:	89 45 d8             	mov    %eax,-0x28(%ebp)
  uint *tdt = (uint *)(base_addr + 0x3818);
80108aff:	a1 7c 6e 19 80       	mov    0x80196e7c,%eax
80108b04:	05 18 38 00 00       	add    $0x3818,%eax
80108b09:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  
  *tdh = 0;
80108b0c:	8b 45 d8             	mov    -0x28(%ebp),%eax
80108b0f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  *tdt = 0;
80108b15:	8b 45 d4             	mov    -0x2c(%ebp),%eax
80108b18:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

  struct i8254_send_desc *send_desc = (struct i8254_send_desc *)tx_desc_addr;
80108b1e:	8b 45 e8             	mov    -0x18(%ebp),%eax
80108b21:	89 45 d0             	mov    %eax,-0x30(%ebp)
  for(int i=0;i<I8254_SEND_DESC_NUM;i++){
80108b24:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80108b2b:	e9 82 00 00 00       	jmp    80108bb2 <i8254_init_send+0x12b>
    send_desc[i].padding = 0;
80108b30:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108b33:	c1 e0 04             	shl    $0x4,%eax
80108b36:	89 c2                	mov    %eax,%edx
80108b38:	8b 45 d0             	mov    -0x30(%ebp),%eax
80108b3b:	01 d0                	add    %edx,%eax
80108b3d:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
    send_desc[i].len = 0;
80108b44:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108b47:	c1 e0 04             	shl    $0x4,%eax
80108b4a:	89 c2                	mov    %eax,%edx
80108b4c:	8b 45 d0             	mov    -0x30(%ebp),%eax
80108b4f:	01 d0                	add    %edx,%eax
80108b51:	66 c7 40 08 00 00    	movw   $0x0,0x8(%eax)
    send_desc[i].cso = 0;
80108b57:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108b5a:	c1 e0 04             	shl    $0x4,%eax
80108b5d:	89 c2                	mov    %eax,%edx
80108b5f:	8b 45 d0             	mov    -0x30(%ebp),%eax
80108b62:	01 d0                	add    %edx,%eax
80108b64:	c6 40 0a 00          	movb   $0x0,0xa(%eax)
    send_desc[i].cmd = 0;
80108b68:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108b6b:	c1 e0 04             	shl    $0x4,%eax
80108b6e:	89 c2                	mov    %eax,%edx
80108b70:	8b 45 d0             	mov    -0x30(%ebp),%eax
80108b73:	01 d0                	add    %edx,%eax
80108b75:	c6 40 0b 00          	movb   $0x0,0xb(%eax)
    send_desc[i].sta = 0;
80108b79:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108b7c:	c1 e0 04             	shl    $0x4,%eax
80108b7f:	89 c2                	mov    %eax,%edx
80108b81:	8b 45 d0             	mov    -0x30(%ebp),%eax
80108b84:	01 d0                	add    %edx,%eax
80108b86:	c6 40 0c 00          	movb   $0x0,0xc(%eax)
    send_desc[i].css = 0;
80108b8a:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108b8d:	c1 e0 04             	shl    $0x4,%eax
80108b90:	89 c2                	mov    %eax,%edx
80108b92:	8b 45 d0             	mov    -0x30(%ebp),%eax
80108b95:	01 d0                	add    %edx,%eax
80108b97:	c6 40 0d 00          	movb   $0x0,0xd(%eax)
    send_desc[i].special = 0;
80108b9b:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108b9e:	c1 e0 04             	shl    $0x4,%eax
80108ba1:	89 c2                	mov    %eax,%edx
80108ba3:	8b 45 d0             	mov    -0x30(%ebp),%eax
80108ba6:	01 d0                	add    %edx,%eax
80108ba8:	66 c7 40 0e 00 00    	movw   $0x0,0xe(%eax)
  for(int i=0;i<I8254_SEND_DESC_NUM;i++){
80108bae:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80108bb2:	81 7d f4 ff 00 00 00 	cmpl   $0xff,-0xc(%ebp)
80108bb9:	0f 8e 71 ff ff ff    	jle    80108b30 <i8254_init_send+0xa9>
  }

  for(int i=0;i<(I8254_SEND_DESC_NUM)/2;i++){
80108bbf:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
80108bc6:	eb 57                	jmp    80108c1f <i8254_init_send+0x198>
    uint buf_addr = (uint)kalloc();
80108bc8:	e8 d3 9b ff ff       	call   801027a0 <kalloc>
80108bcd:	89 45 cc             	mov    %eax,-0x34(%ebp)
    if(buf_addr == 0){
80108bd0:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
80108bd4:	75 12                	jne    80108be8 <i8254_init_send+0x161>
      cprintf("failed to allocate buffer area\n");
80108bd6:	83 ec 0c             	sub    $0xc,%esp
80108bd9:	68 f8 c0 10 80       	push   $0x8010c0f8
80108bde:	e8 11 78 ff ff       	call   801003f4 <cprintf>
80108be3:	83 c4 10             	add    $0x10,%esp
      break;
80108be6:	eb 3d                	jmp    80108c25 <i8254_init_send+0x19e>
    }
    send_desc[i].buf_addr = V2P(buf_addr);
80108be8:	8b 45 f0             	mov    -0x10(%ebp),%eax
80108beb:	c1 e0 04             	shl    $0x4,%eax
80108bee:	89 c2                	mov    %eax,%edx
80108bf0:	8b 45 d0             	mov    -0x30(%ebp),%eax
80108bf3:	01 d0                	add    %edx,%eax
80108bf5:	8b 55 cc             	mov    -0x34(%ebp),%edx
80108bf8:	81 c2 00 00 00 80    	add    $0x80000000,%edx
80108bfe:	89 10                	mov    %edx,(%eax)
    send_desc[i+1].buf_addr = V2P(buf_addr + 0x800);
80108c00:	8b 45 f0             	mov    -0x10(%ebp),%eax
80108c03:	83 c0 01             	add    $0x1,%eax
80108c06:	c1 e0 04             	shl    $0x4,%eax
80108c09:	89 c2                	mov    %eax,%edx
80108c0b:	8b 45 d0             	mov    -0x30(%ebp),%eax
80108c0e:	01 d0                	add    %edx,%eax
80108c10:	8b 55 cc             	mov    -0x34(%ebp),%edx
80108c13:	81 ea 00 f8 ff 7f    	sub    $0x7ffff800,%edx
80108c19:	89 10                	mov    %edx,(%eax)
  for(int i=0;i<(I8254_SEND_DESC_NUM)/2;i++){
80108c1b:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
80108c1f:	83 7d f0 7f          	cmpl   $0x7f,-0x10(%ebp)
80108c23:	7e a3                	jle    80108bc8 <i8254_init_send+0x141>
  }

  uint *tctl = (uint *)(base_addr + 0x400);
80108c25:	a1 7c 6e 19 80       	mov    0x80196e7c,%eax
80108c2a:	05 00 04 00 00       	add    $0x400,%eax
80108c2f:	89 45 c8             	mov    %eax,-0x38(%ebp)
  *tctl = (I8254_TCTL_EN | I8254_TCTL_PSP | I8254_TCTL_COLD | I8254_TCTL_CT);
80108c32:	8b 45 c8             	mov    -0x38(%ebp),%eax
80108c35:	c7 00 fa 00 04 00    	movl   $0x400fa,(%eax)

  uint *tipg = (uint *)(base_addr + 0x410);
80108c3b:	a1 7c 6e 19 80       	mov    0x80196e7c,%eax
80108c40:	05 10 04 00 00       	add    $0x410,%eax
80108c45:	89 45 c4             	mov    %eax,-0x3c(%ebp)
  *tipg = (10 | (10<<10) | (10<<20));
80108c48:	8b 45 c4             	mov    -0x3c(%ebp),%eax
80108c4b:	c7 00 0a 28 a0 00    	movl   $0xa0280a,(%eax)
  cprintf("E1000 Transmit Initialize Done\n");
80108c51:	83 ec 0c             	sub    $0xc,%esp
80108c54:	68 38 c1 10 80       	push   $0x8010c138
80108c59:	e8 96 77 ff ff       	call   801003f4 <cprintf>
80108c5e:	83 c4 10             	add    $0x10,%esp

}
80108c61:	90                   	nop
80108c62:	c9                   	leave  
80108c63:	c3                   	ret    

80108c64 <i8254_read_eeprom>:
uint i8254_read_eeprom(uint addr){
80108c64:	55                   	push   %ebp
80108c65:	89 e5                	mov    %esp,%ebp
80108c67:	83 ec 18             	sub    $0x18,%esp
  uint *eerd = (uint *)(base_addr + 0x14);
80108c6a:	a1 7c 6e 19 80       	mov    0x80196e7c,%eax
80108c6f:	83 c0 14             	add    $0x14,%eax
80108c72:	89 45 f4             	mov    %eax,-0xc(%ebp)
  *eerd = (((addr & 0xFF) << 8) | 1);
80108c75:	8b 45 08             	mov    0x8(%ebp),%eax
80108c78:	c1 e0 08             	shl    $0x8,%eax
80108c7b:	0f b7 c0             	movzwl %ax,%eax
80108c7e:	83 c8 01             	or     $0x1,%eax
80108c81:	89 c2                	mov    %eax,%edx
80108c83:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108c86:	89 10                	mov    %edx,(%eax)
  while(1){
    cprintf("");
80108c88:	83 ec 0c             	sub    $0xc,%esp
80108c8b:	68 58 c1 10 80       	push   $0x8010c158
80108c90:	e8 5f 77 ff ff       	call   801003f4 <cprintf>
80108c95:	83 c4 10             	add    $0x10,%esp
    volatile uint data = *eerd;
80108c98:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108c9b:	8b 00                	mov    (%eax),%eax
80108c9d:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if((data & (1<<4)) != 0){
80108ca0:	8b 45 f0             	mov    -0x10(%ebp),%eax
80108ca3:	83 e0 10             	and    $0x10,%eax
80108ca6:	85 c0                	test   %eax,%eax
80108ca8:	75 02                	jne    80108cac <i8254_read_eeprom+0x48>
  while(1){
80108caa:	eb dc                	jmp    80108c88 <i8254_read_eeprom+0x24>
      break;
80108cac:	90                   	nop
    }
  }

  return (*eerd >> 16) & 0xFFFF;
80108cad:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108cb0:	8b 00                	mov    (%eax),%eax
80108cb2:	c1 e8 10             	shr    $0x10,%eax
}
80108cb5:	c9                   	leave  
80108cb6:	c3                   	ret    

80108cb7 <i8254_recv>:
void i8254_recv(){
80108cb7:	55                   	push   %ebp
80108cb8:	89 e5                	mov    %esp,%ebp
80108cba:	83 ec 28             	sub    $0x28,%esp
  uint *rdh = (uint *)(base_addr + 0x2810);
80108cbd:	a1 7c 6e 19 80       	mov    0x80196e7c,%eax
80108cc2:	05 10 28 00 00       	add    $0x2810,%eax
80108cc7:	89 45 f4             	mov    %eax,-0xc(%ebp)
  uint *rdt = (uint *)(base_addr + 0x2818);
80108cca:	a1 7c 6e 19 80       	mov    0x80196e7c,%eax
80108ccf:	05 18 28 00 00       	add    $0x2818,%eax
80108cd4:	89 45 f0             	mov    %eax,-0x10(%ebp)
//  uint *torl = (uint *)(base_addr + 0x40C0);
//  uint *tpr = (uint *)(base_addr + 0x40D0);
//  uint *icr = (uint *)(base_addr + 0xC0);
  uint *rdbal = (uint *)(base_addr + 0x2800);
80108cd7:	a1 7c 6e 19 80       	mov    0x80196e7c,%eax
80108cdc:	05 00 28 00 00       	add    $0x2800,%eax
80108ce1:	89 45 ec             	mov    %eax,-0x14(%ebp)
  struct i8254_recv_desc *recv_desc = (struct i8254_recv_desc *)(P2V(*rdbal));
80108ce4:	8b 45 ec             	mov    -0x14(%ebp),%eax
80108ce7:	8b 00                	mov    (%eax),%eax
80108ce9:	05 00 00 00 80       	add    $0x80000000,%eax
80108cee:	89 45 e8             	mov    %eax,-0x18(%ebp)
  while(1){
    int rx_available = (I8254_RECV_DESC_NUM - *rdt + *rdh)%I8254_RECV_DESC_NUM;
80108cf1:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108cf4:	8b 10                	mov    (%eax),%edx
80108cf6:	8b 45 f0             	mov    -0x10(%ebp),%eax
80108cf9:	8b 08                	mov    (%eax),%ecx
80108cfb:	89 d0                	mov    %edx,%eax
80108cfd:	29 c8                	sub    %ecx,%eax
80108cff:	25 ff 00 00 00       	and    $0xff,%eax
80108d04:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(rx_available > 0){
80108d07:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
80108d0b:	7e 37                	jle    80108d44 <i8254_recv+0x8d>
      uint buffer_addr = P2V_WO(recv_desc[*rdt].buf_addr);
80108d0d:	8b 45 f0             	mov    -0x10(%ebp),%eax
80108d10:	8b 00                	mov    (%eax),%eax
80108d12:	c1 e0 04             	shl    $0x4,%eax
80108d15:	89 c2                	mov    %eax,%edx
80108d17:	8b 45 e8             	mov    -0x18(%ebp),%eax
80108d1a:	01 d0                	add    %edx,%eax
80108d1c:	8b 00                	mov    (%eax),%eax
80108d1e:	05 00 00 00 80       	add    $0x80000000,%eax
80108d23:	89 45 e0             	mov    %eax,-0x20(%ebp)
      *rdt = (*rdt + 1)%I8254_RECV_DESC_NUM;
80108d26:	8b 45 f0             	mov    -0x10(%ebp),%eax
80108d29:	8b 00                	mov    (%eax),%eax
80108d2b:	83 c0 01             	add    $0x1,%eax
80108d2e:	0f b6 d0             	movzbl %al,%edx
80108d31:	8b 45 f0             	mov    -0x10(%ebp),%eax
80108d34:	89 10                	mov    %edx,(%eax)
      eth_proc(buffer_addr);
80108d36:	83 ec 0c             	sub    $0xc,%esp
80108d39:	ff 75 e0             	push   -0x20(%ebp)
80108d3c:	e8 15 09 00 00       	call   80109656 <eth_proc>
80108d41:	83 c4 10             	add    $0x10,%esp
    }
    if(*rdt == *rdh) {
80108d44:	8b 45 f0             	mov    -0x10(%ebp),%eax
80108d47:	8b 10                	mov    (%eax),%edx
80108d49:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108d4c:	8b 00                	mov    (%eax),%eax
80108d4e:	39 c2                	cmp    %eax,%edx
80108d50:	75 9f                	jne    80108cf1 <i8254_recv+0x3a>
      (*rdt)--;
80108d52:	8b 45 f0             	mov    -0x10(%ebp),%eax
80108d55:	8b 00                	mov    (%eax),%eax
80108d57:	8d 50 ff             	lea    -0x1(%eax),%edx
80108d5a:	8b 45 f0             	mov    -0x10(%ebp),%eax
80108d5d:	89 10                	mov    %edx,(%eax)
  while(1){
80108d5f:	eb 90                	jmp    80108cf1 <i8254_recv+0x3a>

80108d61 <i8254_send>:
    }
  }
}

int i8254_send(const uint pkt_addr,uint len){
80108d61:	55                   	push   %ebp
80108d62:	89 e5                	mov    %esp,%ebp
80108d64:	83 ec 28             	sub    $0x28,%esp
  uint *tdh = (uint *)(base_addr + 0x3810);
80108d67:	a1 7c 6e 19 80       	mov    0x80196e7c,%eax
80108d6c:	05 10 38 00 00       	add    $0x3810,%eax
80108d71:	89 45 f4             	mov    %eax,-0xc(%ebp)
  uint *tdt = (uint *)(base_addr + 0x3818);
80108d74:	a1 7c 6e 19 80       	mov    0x80196e7c,%eax
80108d79:	05 18 38 00 00       	add    $0x3818,%eax
80108d7e:	89 45 f0             	mov    %eax,-0x10(%ebp)
  uint *tdbal = (uint *)(base_addr + 0x3800);
80108d81:	a1 7c 6e 19 80       	mov    0x80196e7c,%eax
80108d86:	05 00 38 00 00       	add    $0x3800,%eax
80108d8b:	89 45 ec             	mov    %eax,-0x14(%ebp)
  struct i8254_send_desc *txdesc = (struct i8254_send_desc *)P2V_WO(*tdbal);
80108d8e:	8b 45 ec             	mov    -0x14(%ebp),%eax
80108d91:	8b 00                	mov    (%eax),%eax
80108d93:	05 00 00 00 80       	add    $0x80000000,%eax
80108d98:	89 45 e8             	mov    %eax,-0x18(%ebp)
  int tx_available = I8254_SEND_DESC_NUM - ((I8254_SEND_DESC_NUM - *tdh + *tdt) % I8254_SEND_DESC_NUM);
80108d9b:	8b 45 f0             	mov    -0x10(%ebp),%eax
80108d9e:	8b 10                	mov    (%eax),%edx
80108da0:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108da3:	8b 08                	mov    (%eax),%ecx
80108da5:	89 d0                	mov    %edx,%eax
80108da7:	29 c8                	sub    %ecx,%eax
80108da9:	0f b6 d0             	movzbl %al,%edx
80108dac:	b8 00 01 00 00       	mov    $0x100,%eax
80108db1:	29 d0                	sub    %edx,%eax
80108db3:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  uint index = *tdt%I8254_SEND_DESC_NUM;
80108db6:	8b 45 f0             	mov    -0x10(%ebp),%eax
80108db9:	8b 00                	mov    (%eax),%eax
80108dbb:	25 ff 00 00 00       	and    $0xff,%eax
80108dc0:	89 45 e0             	mov    %eax,-0x20(%ebp)
  if(tx_available > 0) {
80108dc3:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
80108dc7:	0f 8e a8 00 00 00    	jle    80108e75 <i8254_send+0x114>
    memmove(P2V_WO((void *)txdesc[index].buf_addr),(void *)pkt_addr,len);
80108dcd:	8b 45 08             	mov    0x8(%ebp),%eax
80108dd0:	8b 55 e0             	mov    -0x20(%ebp),%edx
80108dd3:	89 d1                	mov    %edx,%ecx
80108dd5:	c1 e1 04             	shl    $0x4,%ecx
80108dd8:	8b 55 e8             	mov    -0x18(%ebp),%edx
80108ddb:	01 ca                	add    %ecx,%edx
80108ddd:	8b 12                	mov    (%edx),%edx
80108ddf:	81 c2 00 00 00 80    	add    $0x80000000,%edx
80108de5:	83 ec 04             	sub    $0x4,%esp
80108de8:	ff 75 0c             	push   0xc(%ebp)
80108deb:	50                   	push   %eax
80108dec:	52                   	push   %edx
80108ded:	e8 e7 be ff ff       	call   80104cd9 <memmove>
80108df2:	83 c4 10             	add    $0x10,%esp
    txdesc[index].len = len;
80108df5:	8b 45 e0             	mov    -0x20(%ebp),%eax
80108df8:	c1 e0 04             	shl    $0x4,%eax
80108dfb:	89 c2                	mov    %eax,%edx
80108dfd:	8b 45 e8             	mov    -0x18(%ebp),%eax
80108e00:	01 d0                	add    %edx,%eax
80108e02:	8b 55 0c             	mov    0xc(%ebp),%edx
80108e05:	66 89 50 08          	mov    %dx,0x8(%eax)
    txdesc[index].sta = 0;
80108e09:	8b 45 e0             	mov    -0x20(%ebp),%eax
80108e0c:	c1 e0 04             	shl    $0x4,%eax
80108e0f:	89 c2                	mov    %eax,%edx
80108e11:	8b 45 e8             	mov    -0x18(%ebp),%eax
80108e14:	01 d0                	add    %edx,%eax
80108e16:	c6 40 0c 00          	movb   $0x0,0xc(%eax)
    txdesc[index].css = 0;
80108e1a:	8b 45 e0             	mov    -0x20(%ebp),%eax
80108e1d:	c1 e0 04             	shl    $0x4,%eax
80108e20:	89 c2                	mov    %eax,%edx
80108e22:	8b 45 e8             	mov    -0x18(%ebp),%eax
80108e25:	01 d0                	add    %edx,%eax
80108e27:	c6 40 0d 00          	movb   $0x0,0xd(%eax)
    txdesc[index].cmd = 0xb;
80108e2b:	8b 45 e0             	mov    -0x20(%ebp),%eax
80108e2e:	c1 e0 04             	shl    $0x4,%eax
80108e31:	89 c2                	mov    %eax,%edx
80108e33:	8b 45 e8             	mov    -0x18(%ebp),%eax
80108e36:	01 d0                	add    %edx,%eax
80108e38:	c6 40 0b 0b          	movb   $0xb,0xb(%eax)
    txdesc[index].special = 0;
80108e3c:	8b 45 e0             	mov    -0x20(%ebp),%eax
80108e3f:	c1 e0 04             	shl    $0x4,%eax
80108e42:	89 c2                	mov    %eax,%edx
80108e44:	8b 45 e8             	mov    -0x18(%ebp),%eax
80108e47:	01 d0                	add    %edx,%eax
80108e49:	66 c7 40 0e 00 00    	movw   $0x0,0xe(%eax)
    txdesc[index].cso = 0;
80108e4f:	8b 45 e0             	mov    -0x20(%ebp),%eax
80108e52:	c1 e0 04             	shl    $0x4,%eax
80108e55:	89 c2                	mov    %eax,%edx
80108e57:	8b 45 e8             	mov    -0x18(%ebp),%eax
80108e5a:	01 d0                	add    %edx,%eax
80108e5c:	c6 40 0a 00          	movb   $0x0,0xa(%eax)
    *tdt = (*tdt + 1)%I8254_SEND_DESC_NUM;
80108e60:	8b 45 f0             	mov    -0x10(%ebp),%eax
80108e63:	8b 00                	mov    (%eax),%eax
80108e65:	83 c0 01             	add    $0x1,%eax
80108e68:	0f b6 d0             	movzbl %al,%edx
80108e6b:	8b 45 f0             	mov    -0x10(%ebp),%eax
80108e6e:	89 10                	mov    %edx,(%eax)
    return len;
80108e70:	8b 45 0c             	mov    0xc(%ebp),%eax
80108e73:	eb 05                	jmp    80108e7a <i8254_send+0x119>
  }else{
    return -1;
80108e75:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  }
  return 0;
}
80108e7a:	c9                   	leave  
80108e7b:	c3                   	ret    

80108e7c <i8254_intr>:

void i8254_intr(){
80108e7c:	55                   	push   %ebp
80108e7d:	89 e5                	mov    %esp,%ebp
  *intr_addr = 0xEEEEEE;
80108e7f:	a1 88 6e 19 80       	mov    0x80196e88,%eax
80108e84:	c7 00 ee ee ee 00    	movl   $0xeeeeee,(%eax)
}
80108e8a:	90                   	nop
80108e8b:	5d                   	pop    %ebp
80108e8c:	c3                   	ret    

80108e8d <arp_proc>:
extern uchar mac_addr[6];
extern uchar my_ip[4];

struct arp_entry arp_table[ARP_TABLE_MAX] = {0};

int arp_proc(uint buffer_addr){
80108e8d:	55                   	push   %ebp
80108e8e:	89 e5                	mov    %esp,%ebp
80108e90:	83 ec 18             	sub    $0x18,%esp
  struct arp_pkt *arp_p = (struct arp_pkt *)(buffer_addr);
80108e93:	8b 45 08             	mov    0x8(%ebp),%eax
80108e96:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(arp_p->hrd_type != ARP_HARDWARE_TYPE) return -1;
80108e99:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108e9c:	0f b7 00             	movzwl (%eax),%eax
80108e9f:	66 3d 00 01          	cmp    $0x100,%ax
80108ea3:	74 0a                	je     80108eaf <arp_proc+0x22>
80108ea5:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80108eaa:	e9 4f 01 00 00       	jmp    80108ffe <arp_proc+0x171>
  if(arp_p->pro_type != ARP_PROTOCOL_TYPE) return -1;
80108eaf:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108eb2:	0f b7 40 02          	movzwl 0x2(%eax),%eax
80108eb6:	66 83 f8 08          	cmp    $0x8,%ax
80108eba:	74 0a                	je     80108ec6 <arp_proc+0x39>
80108ebc:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80108ec1:	e9 38 01 00 00       	jmp    80108ffe <arp_proc+0x171>
  if(arp_p->hrd_len != 6) return -1;
80108ec6:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108ec9:	0f b6 40 04          	movzbl 0x4(%eax),%eax
80108ecd:	3c 06                	cmp    $0x6,%al
80108ecf:	74 0a                	je     80108edb <arp_proc+0x4e>
80108ed1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80108ed6:	e9 23 01 00 00       	jmp    80108ffe <arp_proc+0x171>
  if(arp_p->pro_len != 4) return -1;
80108edb:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108ede:	0f b6 40 05          	movzbl 0x5(%eax),%eax
80108ee2:	3c 04                	cmp    $0x4,%al
80108ee4:	74 0a                	je     80108ef0 <arp_proc+0x63>
80108ee6:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80108eeb:	e9 0e 01 00 00       	jmp    80108ffe <arp_proc+0x171>
  if(memcmp(my_ip,arp_p->dst_ip,4) != 0 && memcmp(my_ip,arp_p->src_ip,4) != 0) return -1;
80108ef0:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108ef3:	83 c0 18             	add    $0x18,%eax
80108ef6:	83 ec 04             	sub    $0x4,%esp
80108ef9:	6a 04                	push   $0x4
80108efb:	50                   	push   %eax
80108efc:	68 04 f5 10 80       	push   $0x8010f504
80108f01:	e8 7b bd ff ff       	call   80104c81 <memcmp>
80108f06:	83 c4 10             	add    $0x10,%esp
80108f09:	85 c0                	test   %eax,%eax
80108f0b:	74 27                	je     80108f34 <arp_proc+0xa7>
80108f0d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108f10:	83 c0 0e             	add    $0xe,%eax
80108f13:	83 ec 04             	sub    $0x4,%esp
80108f16:	6a 04                	push   $0x4
80108f18:	50                   	push   %eax
80108f19:	68 04 f5 10 80       	push   $0x8010f504
80108f1e:	e8 5e bd ff ff       	call   80104c81 <memcmp>
80108f23:	83 c4 10             	add    $0x10,%esp
80108f26:	85 c0                	test   %eax,%eax
80108f28:	74 0a                	je     80108f34 <arp_proc+0xa7>
80108f2a:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80108f2f:	e9 ca 00 00 00       	jmp    80108ffe <arp_proc+0x171>
  if(arp_p->op == ARP_OPS_REQUEST && memcmp(my_ip,arp_p->dst_ip,4) == 0){
80108f34:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108f37:	0f b7 40 06          	movzwl 0x6(%eax),%eax
80108f3b:	66 3d 00 01          	cmp    $0x100,%ax
80108f3f:	75 69                	jne    80108faa <arp_proc+0x11d>
80108f41:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108f44:	83 c0 18             	add    $0x18,%eax
80108f47:	83 ec 04             	sub    $0x4,%esp
80108f4a:	6a 04                	push   $0x4
80108f4c:	50                   	push   %eax
80108f4d:	68 04 f5 10 80       	push   $0x8010f504
80108f52:	e8 2a bd ff ff       	call   80104c81 <memcmp>
80108f57:	83 c4 10             	add    $0x10,%esp
80108f5a:	85 c0                	test   %eax,%eax
80108f5c:	75 4c                	jne    80108faa <arp_proc+0x11d>
    uint send = (uint)kalloc();
80108f5e:	e8 3d 98 ff ff       	call   801027a0 <kalloc>
80108f63:	89 45 f0             	mov    %eax,-0x10(%ebp)
    uint send_size=0;
80108f66:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
    arp_reply_pkt_create(arp_p,send,&send_size);
80108f6d:	83 ec 04             	sub    $0x4,%esp
80108f70:	8d 45 ec             	lea    -0x14(%ebp),%eax
80108f73:	50                   	push   %eax
80108f74:	ff 75 f0             	push   -0x10(%ebp)
80108f77:	ff 75 f4             	push   -0xc(%ebp)
80108f7a:	e8 1f 04 00 00       	call   8010939e <arp_reply_pkt_create>
80108f7f:	83 c4 10             	add    $0x10,%esp
    i8254_send(send,send_size);
80108f82:	8b 45 ec             	mov    -0x14(%ebp),%eax
80108f85:	83 ec 08             	sub    $0x8,%esp
80108f88:	50                   	push   %eax
80108f89:	ff 75 f0             	push   -0x10(%ebp)
80108f8c:	e8 d0 fd ff ff       	call   80108d61 <i8254_send>
80108f91:	83 c4 10             	add    $0x10,%esp
    kfree((char *)send);
80108f94:	8b 45 f0             	mov    -0x10(%ebp),%eax
80108f97:	83 ec 0c             	sub    $0xc,%esp
80108f9a:	50                   	push   %eax
80108f9b:	e8 66 97 ff ff       	call   80102706 <kfree>
80108fa0:	83 c4 10             	add    $0x10,%esp
    return ARP_CREATED_REPLY;
80108fa3:	b8 02 00 00 00       	mov    $0x2,%eax
80108fa8:	eb 54                	jmp    80108ffe <arp_proc+0x171>
  }else if(arp_p->op == ARP_OPS_REPLY && memcmp(my_ip,arp_p->dst_ip,4) == 0){
80108faa:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108fad:	0f b7 40 06          	movzwl 0x6(%eax),%eax
80108fb1:	66 3d 00 02          	cmp    $0x200,%ax
80108fb5:	75 42                	jne    80108ff9 <arp_proc+0x16c>
80108fb7:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108fba:	83 c0 18             	add    $0x18,%eax
80108fbd:	83 ec 04             	sub    $0x4,%esp
80108fc0:	6a 04                	push   $0x4
80108fc2:	50                   	push   %eax
80108fc3:	68 04 f5 10 80       	push   $0x8010f504
80108fc8:	e8 b4 bc ff ff       	call   80104c81 <memcmp>
80108fcd:	83 c4 10             	add    $0x10,%esp
80108fd0:	85 c0                	test   %eax,%eax
80108fd2:	75 25                	jne    80108ff9 <arp_proc+0x16c>
    cprintf("ARP TABLE UPDATED\n");
80108fd4:	83 ec 0c             	sub    $0xc,%esp
80108fd7:	68 5c c1 10 80       	push   $0x8010c15c
80108fdc:	e8 13 74 ff ff       	call   801003f4 <cprintf>
80108fe1:	83 c4 10             	add    $0x10,%esp
    arp_table_update(arp_p);
80108fe4:	83 ec 0c             	sub    $0xc,%esp
80108fe7:	ff 75 f4             	push   -0xc(%ebp)
80108fea:	e8 af 01 00 00       	call   8010919e <arp_table_update>
80108fef:	83 c4 10             	add    $0x10,%esp
    return ARP_UPDATED_TABLE;
80108ff2:	b8 01 00 00 00       	mov    $0x1,%eax
80108ff7:	eb 05                	jmp    80108ffe <arp_proc+0x171>
  }else{
    return -1;
80108ff9:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  }
}
80108ffe:	c9                   	leave  
80108fff:	c3                   	ret    

80109000 <arp_scan>:

void arp_scan(){
80109000:	55                   	push   %ebp
80109001:	89 e5                	mov    %esp,%ebp
80109003:	83 ec 18             	sub    $0x18,%esp
  uint send_size;
  for(int i=0;i<256;i++){
80109006:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
8010900d:	eb 6f                	jmp    8010907e <arp_scan+0x7e>
    uint send = (uint)kalloc();
8010900f:	e8 8c 97 ff ff       	call   801027a0 <kalloc>
80109014:	89 45 ec             	mov    %eax,-0x14(%ebp)
    arp_broadcast(send,&send_size,i);
80109017:	83 ec 04             	sub    $0x4,%esp
8010901a:	ff 75 f4             	push   -0xc(%ebp)
8010901d:	8d 45 e8             	lea    -0x18(%ebp),%eax
80109020:	50                   	push   %eax
80109021:	ff 75 ec             	push   -0x14(%ebp)
80109024:	e8 62 00 00 00       	call   8010908b <arp_broadcast>
80109029:	83 c4 10             	add    $0x10,%esp
    uint res = i8254_send(send,send_size);
8010902c:	8b 45 e8             	mov    -0x18(%ebp),%eax
8010902f:	83 ec 08             	sub    $0x8,%esp
80109032:	50                   	push   %eax
80109033:	ff 75 ec             	push   -0x14(%ebp)
80109036:	e8 26 fd ff ff       	call   80108d61 <i8254_send>
8010903b:	83 c4 10             	add    $0x10,%esp
8010903e:	89 45 f0             	mov    %eax,-0x10(%ebp)
    while(res == -1){
80109041:	eb 22                	jmp    80109065 <arp_scan+0x65>
      microdelay(1);
80109043:	83 ec 0c             	sub    $0xc,%esp
80109046:	6a 01                	push   $0x1
80109048:	e8 ea 9a ff ff       	call   80102b37 <microdelay>
8010904d:	83 c4 10             	add    $0x10,%esp
      res = i8254_send(send,send_size);
80109050:	8b 45 e8             	mov    -0x18(%ebp),%eax
80109053:	83 ec 08             	sub    $0x8,%esp
80109056:	50                   	push   %eax
80109057:	ff 75 ec             	push   -0x14(%ebp)
8010905a:	e8 02 fd ff ff       	call   80108d61 <i8254_send>
8010905f:	83 c4 10             	add    $0x10,%esp
80109062:	89 45 f0             	mov    %eax,-0x10(%ebp)
    while(res == -1){
80109065:	83 7d f0 ff          	cmpl   $0xffffffff,-0x10(%ebp)
80109069:	74 d8                	je     80109043 <arp_scan+0x43>
    }
    kfree((char *)send);
8010906b:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010906e:	83 ec 0c             	sub    $0xc,%esp
80109071:	50                   	push   %eax
80109072:	e8 8f 96 ff ff       	call   80102706 <kfree>
80109077:	83 c4 10             	add    $0x10,%esp
  for(int i=0;i<256;i++){
8010907a:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
8010907e:	81 7d f4 ff 00 00 00 	cmpl   $0xff,-0xc(%ebp)
80109085:	7e 88                	jle    8010900f <arp_scan+0xf>
  }
}
80109087:	90                   	nop
80109088:	90                   	nop
80109089:	c9                   	leave  
8010908a:	c3                   	ret    

8010908b <arp_broadcast>:

void arp_broadcast(uint send,uint *send_size,uint ip){
8010908b:	55                   	push   %ebp
8010908c:	89 e5                	mov    %esp,%ebp
8010908e:	83 ec 28             	sub    $0x28,%esp
  uchar dst_ip[4] = {10,0,1,ip};
80109091:	c6 45 ec 0a          	movb   $0xa,-0x14(%ebp)
80109095:	c6 45 ed 00          	movb   $0x0,-0x13(%ebp)
80109099:	c6 45 ee 01          	movb   $0x1,-0x12(%ebp)
8010909d:	8b 45 10             	mov    0x10(%ebp),%eax
801090a0:	88 45 ef             	mov    %al,-0x11(%ebp)
  uchar dst_mac_eth[6] = {0xff,0xff,0xff,0xff,0xff,0xff};
801090a3:	c7 45 e6 ff ff ff ff 	movl   $0xffffffff,-0x1a(%ebp)
801090aa:	66 c7 45 ea ff ff    	movw   $0xffff,-0x16(%ebp)
  uchar dst_mac_arp[6] = {0,0,0,0,0,0};
801090b0:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
801090b7:	66 c7 45 e4 00 00    	movw   $0x0,-0x1c(%ebp)
  
  *send_size = sizeof(struct eth_pkt) + sizeof(struct arp_pkt);
801090bd:	8b 45 0c             	mov    0xc(%ebp),%eax
801090c0:	c7 00 2c 00 00 00    	movl   $0x2c,(%eax)

  struct eth_pkt *reply_eth = (struct eth_pkt *)send;
801090c6:	8b 45 08             	mov    0x8(%ebp),%eax
801090c9:	89 45 f4             	mov    %eax,-0xc(%ebp)
  struct arp_pkt *reply_arp = (struct arp_pkt *)(send + sizeof(struct eth_pkt));
801090cc:	8b 45 08             	mov    0x8(%ebp),%eax
801090cf:	83 c0 0e             	add    $0xe,%eax
801090d2:	89 45 f0             	mov    %eax,-0x10(%ebp)
  
  reply_eth->type[0] = 0x08;
801090d5:	8b 45 f4             	mov    -0xc(%ebp),%eax
801090d8:	c6 40 0c 08          	movb   $0x8,0xc(%eax)
  reply_eth->type[1] = 0x06;
801090dc:	8b 45 f4             	mov    -0xc(%ebp),%eax
801090df:	c6 40 0d 06          	movb   $0x6,0xd(%eax)
  memmove(reply_eth->dst_mac,dst_mac_eth,6);
801090e3:	8b 45 f4             	mov    -0xc(%ebp),%eax
801090e6:	83 ec 04             	sub    $0x4,%esp
801090e9:	6a 06                	push   $0x6
801090eb:	8d 55 e6             	lea    -0x1a(%ebp),%edx
801090ee:	52                   	push   %edx
801090ef:	50                   	push   %eax
801090f0:	e8 e4 bb ff ff       	call   80104cd9 <memmove>
801090f5:	83 c4 10             	add    $0x10,%esp
  memmove(reply_eth->src_mac,mac_addr,6);
801090f8:	8b 45 f4             	mov    -0xc(%ebp),%eax
801090fb:	83 c0 06             	add    $0x6,%eax
801090fe:	83 ec 04             	sub    $0x4,%esp
80109101:	6a 06                	push   $0x6
80109103:	68 80 6e 19 80       	push   $0x80196e80
80109108:	50                   	push   %eax
80109109:	e8 cb bb ff ff       	call   80104cd9 <memmove>
8010910e:	83 c4 10             	add    $0x10,%esp

  reply_arp->hrd_type = ARP_HARDWARE_TYPE;
80109111:	8b 45 f0             	mov    -0x10(%ebp),%eax
80109114:	66 c7 00 00 01       	movw   $0x100,(%eax)
  reply_arp->pro_type = ARP_PROTOCOL_TYPE;
80109119:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010911c:	66 c7 40 02 08 00    	movw   $0x8,0x2(%eax)
  reply_arp->hrd_len = 6;
80109122:	8b 45 f0             	mov    -0x10(%ebp),%eax
80109125:	c6 40 04 06          	movb   $0x6,0x4(%eax)
  reply_arp->pro_len = 4;
80109129:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010912c:	c6 40 05 04          	movb   $0x4,0x5(%eax)
  reply_arp->op = ARP_OPS_REQUEST;
80109130:	8b 45 f0             	mov    -0x10(%ebp),%eax
80109133:	66 c7 40 06 00 01    	movw   $0x100,0x6(%eax)
  memmove(reply_arp->dst_mac,dst_mac_arp,6);
80109139:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010913c:	8d 50 12             	lea    0x12(%eax),%edx
8010913f:	83 ec 04             	sub    $0x4,%esp
80109142:	6a 06                	push   $0x6
80109144:	8d 45 e0             	lea    -0x20(%ebp),%eax
80109147:	50                   	push   %eax
80109148:	52                   	push   %edx
80109149:	e8 8b bb ff ff       	call   80104cd9 <memmove>
8010914e:	83 c4 10             	add    $0x10,%esp
  memmove(reply_arp->dst_ip,dst_ip,4);
80109151:	8b 45 f0             	mov    -0x10(%ebp),%eax
80109154:	8d 50 18             	lea    0x18(%eax),%edx
80109157:	83 ec 04             	sub    $0x4,%esp
8010915a:	6a 04                	push   $0x4
8010915c:	8d 45 ec             	lea    -0x14(%ebp),%eax
8010915f:	50                   	push   %eax
80109160:	52                   	push   %edx
80109161:	e8 73 bb ff ff       	call   80104cd9 <memmove>
80109166:	83 c4 10             	add    $0x10,%esp
  memmove(reply_arp->src_mac,mac_addr,6);
80109169:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010916c:	83 c0 08             	add    $0x8,%eax
8010916f:	83 ec 04             	sub    $0x4,%esp
80109172:	6a 06                	push   $0x6
80109174:	68 80 6e 19 80       	push   $0x80196e80
80109179:	50                   	push   %eax
8010917a:	e8 5a bb ff ff       	call   80104cd9 <memmove>
8010917f:	83 c4 10             	add    $0x10,%esp
  memmove(reply_arp->src_ip,my_ip,4);
80109182:	8b 45 f0             	mov    -0x10(%ebp),%eax
80109185:	83 c0 0e             	add    $0xe,%eax
80109188:	83 ec 04             	sub    $0x4,%esp
8010918b:	6a 04                	push   $0x4
8010918d:	68 04 f5 10 80       	push   $0x8010f504
80109192:	50                   	push   %eax
80109193:	e8 41 bb ff ff       	call   80104cd9 <memmove>
80109198:	83 c4 10             	add    $0x10,%esp
}
8010919b:	90                   	nop
8010919c:	c9                   	leave  
8010919d:	c3                   	ret    

8010919e <arp_table_update>:

void arp_table_update(struct arp_pkt *recv_arp){
8010919e:	55                   	push   %ebp
8010919f:	89 e5                	mov    %esp,%ebp
801091a1:	83 ec 18             	sub    $0x18,%esp
  int index = arp_table_search(recv_arp->src_ip);
801091a4:	8b 45 08             	mov    0x8(%ebp),%eax
801091a7:	83 c0 0e             	add    $0xe,%eax
801091aa:	83 ec 0c             	sub    $0xc,%esp
801091ad:	50                   	push   %eax
801091ae:	e8 bc 00 00 00       	call   8010926f <arp_table_search>
801091b3:	83 c4 10             	add    $0x10,%esp
801091b6:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(index > -1){
801091b9:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801091bd:	78 2d                	js     801091ec <arp_table_update+0x4e>
    memmove(arp_table[index].mac,recv_arp->src_mac,6);
801091bf:	8b 45 08             	mov    0x8(%ebp),%eax
801091c2:	8d 48 08             	lea    0x8(%eax),%ecx
801091c5:	8b 55 f4             	mov    -0xc(%ebp),%edx
801091c8:	89 d0                	mov    %edx,%eax
801091ca:	c1 e0 02             	shl    $0x2,%eax
801091cd:	01 d0                	add    %edx,%eax
801091cf:	01 c0                	add    %eax,%eax
801091d1:	01 d0                	add    %edx,%eax
801091d3:	05 a0 6e 19 80       	add    $0x80196ea0,%eax
801091d8:	83 c0 04             	add    $0x4,%eax
801091db:	83 ec 04             	sub    $0x4,%esp
801091de:	6a 06                	push   $0x6
801091e0:	51                   	push   %ecx
801091e1:	50                   	push   %eax
801091e2:	e8 f2 ba ff ff       	call   80104cd9 <memmove>
801091e7:	83 c4 10             	add    $0x10,%esp
801091ea:	eb 70                	jmp    8010925c <arp_table_update+0xbe>
  }else{
    index += 1;
801091ec:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
    index = -index;
801091f0:	f7 5d f4             	negl   -0xc(%ebp)
    memmove(arp_table[index].mac,recv_arp->src_mac,6);
801091f3:	8b 45 08             	mov    0x8(%ebp),%eax
801091f6:	8d 48 08             	lea    0x8(%eax),%ecx
801091f9:	8b 55 f4             	mov    -0xc(%ebp),%edx
801091fc:	89 d0                	mov    %edx,%eax
801091fe:	c1 e0 02             	shl    $0x2,%eax
80109201:	01 d0                	add    %edx,%eax
80109203:	01 c0                	add    %eax,%eax
80109205:	01 d0                	add    %edx,%eax
80109207:	05 a0 6e 19 80       	add    $0x80196ea0,%eax
8010920c:	83 c0 04             	add    $0x4,%eax
8010920f:	83 ec 04             	sub    $0x4,%esp
80109212:	6a 06                	push   $0x6
80109214:	51                   	push   %ecx
80109215:	50                   	push   %eax
80109216:	e8 be ba ff ff       	call   80104cd9 <memmove>
8010921b:	83 c4 10             	add    $0x10,%esp
    memmove(arp_table[index].ip,recv_arp->src_ip,4);
8010921e:	8b 45 08             	mov    0x8(%ebp),%eax
80109221:	8d 48 0e             	lea    0xe(%eax),%ecx
80109224:	8b 55 f4             	mov    -0xc(%ebp),%edx
80109227:	89 d0                	mov    %edx,%eax
80109229:	c1 e0 02             	shl    $0x2,%eax
8010922c:	01 d0                	add    %edx,%eax
8010922e:	01 c0                	add    %eax,%eax
80109230:	01 d0                	add    %edx,%eax
80109232:	05 a0 6e 19 80       	add    $0x80196ea0,%eax
80109237:	83 ec 04             	sub    $0x4,%esp
8010923a:	6a 04                	push   $0x4
8010923c:	51                   	push   %ecx
8010923d:	50                   	push   %eax
8010923e:	e8 96 ba ff ff       	call   80104cd9 <memmove>
80109243:	83 c4 10             	add    $0x10,%esp
    arp_table[index].use = 1;
80109246:	8b 55 f4             	mov    -0xc(%ebp),%edx
80109249:	89 d0                	mov    %edx,%eax
8010924b:	c1 e0 02             	shl    $0x2,%eax
8010924e:	01 d0                	add    %edx,%eax
80109250:	01 c0                	add    %eax,%eax
80109252:	01 d0                	add    %edx,%eax
80109254:	05 aa 6e 19 80       	add    $0x80196eaa,%eax
80109259:	c6 00 01             	movb   $0x1,(%eax)
  }
  print_arp_table(arp_table);
8010925c:	83 ec 0c             	sub    $0xc,%esp
8010925f:	68 a0 6e 19 80       	push   $0x80196ea0
80109264:	e8 83 00 00 00       	call   801092ec <print_arp_table>
80109269:	83 c4 10             	add    $0x10,%esp
}
8010926c:	90                   	nop
8010926d:	c9                   	leave  
8010926e:	c3                   	ret    

8010926f <arp_table_search>:

int arp_table_search(uchar *ip){
8010926f:	55                   	push   %ebp
80109270:	89 e5                	mov    %esp,%ebp
80109272:	83 ec 18             	sub    $0x18,%esp
  int empty=1;
80109275:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
  for(int i=0;i<ARP_TABLE_MAX;i++){
8010927c:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
80109283:	eb 59                	jmp    801092de <arp_table_search+0x6f>
    if(memcmp(arp_table[i].ip,ip,4) == 0){
80109285:	8b 55 f0             	mov    -0x10(%ebp),%edx
80109288:	89 d0                	mov    %edx,%eax
8010928a:	c1 e0 02             	shl    $0x2,%eax
8010928d:	01 d0                	add    %edx,%eax
8010928f:	01 c0                	add    %eax,%eax
80109291:	01 d0                	add    %edx,%eax
80109293:	05 a0 6e 19 80       	add    $0x80196ea0,%eax
80109298:	83 ec 04             	sub    $0x4,%esp
8010929b:	6a 04                	push   $0x4
8010929d:	ff 75 08             	push   0x8(%ebp)
801092a0:	50                   	push   %eax
801092a1:	e8 db b9 ff ff       	call   80104c81 <memcmp>
801092a6:	83 c4 10             	add    $0x10,%esp
801092a9:	85 c0                	test   %eax,%eax
801092ab:	75 05                	jne    801092b2 <arp_table_search+0x43>
      return i;
801092ad:	8b 45 f0             	mov    -0x10(%ebp),%eax
801092b0:	eb 38                	jmp    801092ea <arp_table_search+0x7b>
    }
    if(arp_table[i].use == 0 && empty == 1){
801092b2:	8b 55 f0             	mov    -0x10(%ebp),%edx
801092b5:	89 d0                	mov    %edx,%eax
801092b7:	c1 e0 02             	shl    $0x2,%eax
801092ba:	01 d0                	add    %edx,%eax
801092bc:	01 c0                	add    %eax,%eax
801092be:	01 d0                	add    %edx,%eax
801092c0:	05 aa 6e 19 80       	add    $0x80196eaa,%eax
801092c5:	0f b6 00             	movzbl (%eax),%eax
801092c8:	84 c0                	test   %al,%al
801092ca:	75 0e                	jne    801092da <arp_table_search+0x6b>
801092cc:	83 7d f4 01          	cmpl   $0x1,-0xc(%ebp)
801092d0:	75 08                	jne    801092da <arp_table_search+0x6b>
      empty = -i;
801092d2:	8b 45 f0             	mov    -0x10(%ebp),%eax
801092d5:	f7 d8                	neg    %eax
801092d7:	89 45 f4             	mov    %eax,-0xc(%ebp)
  for(int i=0;i<ARP_TABLE_MAX;i++){
801092da:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
801092de:	83 7d f0 3f          	cmpl   $0x3f,-0x10(%ebp)
801092e2:	7e a1                	jle    80109285 <arp_table_search+0x16>
    }
  }
  return empty-1;
801092e4:	8b 45 f4             	mov    -0xc(%ebp),%eax
801092e7:	83 e8 01             	sub    $0x1,%eax
}
801092ea:	c9                   	leave  
801092eb:	c3                   	ret    

801092ec <print_arp_table>:

void print_arp_table(){
801092ec:	55                   	push   %ebp
801092ed:	89 e5                	mov    %esp,%ebp
801092ef:	83 ec 18             	sub    $0x18,%esp
  for(int i=0;i < ARP_TABLE_MAX;i++){
801092f2:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
801092f9:	e9 92 00 00 00       	jmp    80109390 <print_arp_table+0xa4>
    if(arp_table[i].use != 0){
801092fe:	8b 55 f4             	mov    -0xc(%ebp),%edx
80109301:	89 d0                	mov    %edx,%eax
80109303:	c1 e0 02             	shl    $0x2,%eax
80109306:	01 d0                	add    %edx,%eax
80109308:	01 c0                	add    %eax,%eax
8010930a:	01 d0                	add    %edx,%eax
8010930c:	05 aa 6e 19 80       	add    $0x80196eaa,%eax
80109311:	0f b6 00             	movzbl (%eax),%eax
80109314:	84 c0                	test   %al,%al
80109316:	74 74                	je     8010938c <print_arp_table+0xa0>
      cprintf("Entry Num: %d ",i);
80109318:	83 ec 08             	sub    $0x8,%esp
8010931b:	ff 75 f4             	push   -0xc(%ebp)
8010931e:	68 6f c1 10 80       	push   $0x8010c16f
80109323:	e8 cc 70 ff ff       	call   801003f4 <cprintf>
80109328:	83 c4 10             	add    $0x10,%esp
      print_ipv4(arp_table[i].ip);
8010932b:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010932e:	89 d0                	mov    %edx,%eax
80109330:	c1 e0 02             	shl    $0x2,%eax
80109333:	01 d0                	add    %edx,%eax
80109335:	01 c0                	add    %eax,%eax
80109337:	01 d0                	add    %edx,%eax
80109339:	05 a0 6e 19 80       	add    $0x80196ea0,%eax
8010933e:	83 ec 0c             	sub    $0xc,%esp
80109341:	50                   	push   %eax
80109342:	e8 54 02 00 00       	call   8010959b <print_ipv4>
80109347:	83 c4 10             	add    $0x10,%esp
      cprintf(" ");
8010934a:	83 ec 0c             	sub    $0xc,%esp
8010934d:	68 7e c1 10 80       	push   $0x8010c17e
80109352:	e8 9d 70 ff ff       	call   801003f4 <cprintf>
80109357:	83 c4 10             	add    $0x10,%esp
      print_mac(arp_table[i].mac);
8010935a:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010935d:	89 d0                	mov    %edx,%eax
8010935f:	c1 e0 02             	shl    $0x2,%eax
80109362:	01 d0                	add    %edx,%eax
80109364:	01 c0                	add    %eax,%eax
80109366:	01 d0                	add    %edx,%eax
80109368:	05 a0 6e 19 80       	add    $0x80196ea0,%eax
8010936d:	83 c0 04             	add    $0x4,%eax
80109370:	83 ec 0c             	sub    $0xc,%esp
80109373:	50                   	push   %eax
80109374:	e8 70 02 00 00       	call   801095e9 <print_mac>
80109379:	83 c4 10             	add    $0x10,%esp
      cprintf("\n");
8010937c:	83 ec 0c             	sub    $0xc,%esp
8010937f:	68 80 c1 10 80       	push   $0x8010c180
80109384:	e8 6b 70 ff ff       	call   801003f4 <cprintf>
80109389:	83 c4 10             	add    $0x10,%esp
  for(int i=0;i < ARP_TABLE_MAX;i++){
8010938c:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80109390:	83 7d f4 3f          	cmpl   $0x3f,-0xc(%ebp)
80109394:	0f 8e 64 ff ff ff    	jle    801092fe <print_arp_table+0x12>
    }
  }
}
8010939a:	90                   	nop
8010939b:	90                   	nop
8010939c:	c9                   	leave  
8010939d:	c3                   	ret    

8010939e <arp_reply_pkt_create>:


void arp_reply_pkt_create(struct arp_pkt *arp_recv,uint send,uint *send_size){
8010939e:	55                   	push   %ebp
8010939f:	89 e5                	mov    %esp,%ebp
801093a1:	83 ec 18             	sub    $0x18,%esp
  *send_size = sizeof(struct eth_pkt) + sizeof(struct arp_pkt);
801093a4:	8b 45 10             	mov    0x10(%ebp),%eax
801093a7:	c7 00 2c 00 00 00    	movl   $0x2c,(%eax)
  
  struct eth_pkt *reply_eth = (struct eth_pkt *)send;
801093ad:	8b 45 0c             	mov    0xc(%ebp),%eax
801093b0:	89 45 f4             	mov    %eax,-0xc(%ebp)
  struct arp_pkt *reply_arp = (struct arp_pkt *)(send + sizeof(struct eth_pkt));
801093b3:	8b 45 0c             	mov    0xc(%ebp),%eax
801093b6:	83 c0 0e             	add    $0xe,%eax
801093b9:	89 45 f0             	mov    %eax,-0x10(%ebp)

  reply_eth->type[0] = 0x08;
801093bc:	8b 45 f4             	mov    -0xc(%ebp),%eax
801093bf:	c6 40 0c 08          	movb   $0x8,0xc(%eax)
  reply_eth->type[1] = 0x06;
801093c3:	8b 45 f4             	mov    -0xc(%ebp),%eax
801093c6:	c6 40 0d 06          	movb   $0x6,0xd(%eax)
  memmove(reply_eth->dst_mac,arp_recv->src_mac,6);
801093ca:	8b 45 08             	mov    0x8(%ebp),%eax
801093cd:	8d 50 08             	lea    0x8(%eax),%edx
801093d0:	8b 45 f4             	mov    -0xc(%ebp),%eax
801093d3:	83 ec 04             	sub    $0x4,%esp
801093d6:	6a 06                	push   $0x6
801093d8:	52                   	push   %edx
801093d9:	50                   	push   %eax
801093da:	e8 fa b8 ff ff       	call   80104cd9 <memmove>
801093df:	83 c4 10             	add    $0x10,%esp
  memmove(reply_eth->src_mac,mac_addr,6);
801093e2:	8b 45 f4             	mov    -0xc(%ebp),%eax
801093e5:	83 c0 06             	add    $0x6,%eax
801093e8:	83 ec 04             	sub    $0x4,%esp
801093eb:	6a 06                	push   $0x6
801093ed:	68 80 6e 19 80       	push   $0x80196e80
801093f2:	50                   	push   %eax
801093f3:	e8 e1 b8 ff ff       	call   80104cd9 <memmove>
801093f8:	83 c4 10             	add    $0x10,%esp

  reply_arp->hrd_type = ARP_HARDWARE_TYPE;
801093fb:	8b 45 f0             	mov    -0x10(%ebp),%eax
801093fe:	66 c7 00 00 01       	movw   $0x100,(%eax)
  reply_arp->pro_type = ARP_PROTOCOL_TYPE;
80109403:	8b 45 f0             	mov    -0x10(%ebp),%eax
80109406:	66 c7 40 02 08 00    	movw   $0x8,0x2(%eax)
  reply_arp->hrd_len = 6;
8010940c:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010940f:	c6 40 04 06          	movb   $0x6,0x4(%eax)
  reply_arp->pro_len = 4;
80109413:	8b 45 f0             	mov    -0x10(%ebp),%eax
80109416:	c6 40 05 04          	movb   $0x4,0x5(%eax)
  reply_arp->op = ARP_OPS_REPLY;
8010941a:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010941d:	66 c7 40 06 00 02    	movw   $0x200,0x6(%eax)
  memmove(reply_arp->dst_mac,arp_recv->src_mac,6);
80109423:	8b 45 08             	mov    0x8(%ebp),%eax
80109426:	8d 50 08             	lea    0x8(%eax),%edx
80109429:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010942c:	83 c0 12             	add    $0x12,%eax
8010942f:	83 ec 04             	sub    $0x4,%esp
80109432:	6a 06                	push   $0x6
80109434:	52                   	push   %edx
80109435:	50                   	push   %eax
80109436:	e8 9e b8 ff ff       	call   80104cd9 <memmove>
8010943b:	83 c4 10             	add    $0x10,%esp
  memmove(reply_arp->dst_ip,arp_recv->src_ip,4);
8010943e:	8b 45 08             	mov    0x8(%ebp),%eax
80109441:	8d 50 0e             	lea    0xe(%eax),%edx
80109444:	8b 45 f0             	mov    -0x10(%ebp),%eax
80109447:	83 c0 18             	add    $0x18,%eax
8010944a:	83 ec 04             	sub    $0x4,%esp
8010944d:	6a 04                	push   $0x4
8010944f:	52                   	push   %edx
80109450:	50                   	push   %eax
80109451:	e8 83 b8 ff ff       	call   80104cd9 <memmove>
80109456:	83 c4 10             	add    $0x10,%esp
  memmove(reply_arp->src_mac,mac_addr,6);
80109459:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010945c:	83 c0 08             	add    $0x8,%eax
8010945f:	83 ec 04             	sub    $0x4,%esp
80109462:	6a 06                	push   $0x6
80109464:	68 80 6e 19 80       	push   $0x80196e80
80109469:	50                   	push   %eax
8010946a:	e8 6a b8 ff ff       	call   80104cd9 <memmove>
8010946f:	83 c4 10             	add    $0x10,%esp
  memmove(reply_arp->src_ip,my_ip,4);
80109472:	8b 45 f0             	mov    -0x10(%ebp),%eax
80109475:	83 c0 0e             	add    $0xe,%eax
80109478:	83 ec 04             	sub    $0x4,%esp
8010947b:	6a 04                	push   $0x4
8010947d:	68 04 f5 10 80       	push   $0x8010f504
80109482:	50                   	push   %eax
80109483:	e8 51 b8 ff ff       	call   80104cd9 <memmove>
80109488:	83 c4 10             	add    $0x10,%esp
}
8010948b:	90                   	nop
8010948c:	c9                   	leave  
8010948d:	c3                   	ret    

8010948e <print_arp_info>:

void print_arp_info(struct arp_pkt* arp_p){
8010948e:	55                   	push   %ebp
8010948f:	89 e5                	mov    %esp,%ebp
80109491:	83 ec 08             	sub    $0x8,%esp
  cprintf("--------Source-------\n");
80109494:	83 ec 0c             	sub    $0xc,%esp
80109497:	68 82 c1 10 80       	push   $0x8010c182
8010949c:	e8 53 6f ff ff       	call   801003f4 <cprintf>
801094a1:	83 c4 10             	add    $0x10,%esp
  print_ipv4(arp_p->src_ip);
801094a4:	8b 45 08             	mov    0x8(%ebp),%eax
801094a7:	83 c0 0e             	add    $0xe,%eax
801094aa:	83 ec 0c             	sub    $0xc,%esp
801094ad:	50                   	push   %eax
801094ae:	e8 e8 00 00 00       	call   8010959b <print_ipv4>
801094b3:	83 c4 10             	add    $0x10,%esp
  cprintf("\n");
801094b6:	83 ec 0c             	sub    $0xc,%esp
801094b9:	68 80 c1 10 80       	push   $0x8010c180
801094be:	e8 31 6f ff ff       	call   801003f4 <cprintf>
801094c3:	83 c4 10             	add    $0x10,%esp
  print_mac(arp_p->src_mac);
801094c6:	8b 45 08             	mov    0x8(%ebp),%eax
801094c9:	83 c0 08             	add    $0x8,%eax
801094cc:	83 ec 0c             	sub    $0xc,%esp
801094cf:	50                   	push   %eax
801094d0:	e8 14 01 00 00       	call   801095e9 <print_mac>
801094d5:	83 c4 10             	add    $0x10,%esp
  cprintf("\n");
801094d8:	83 ec 0c             	sub    $0xc,%esp
801094db:	68 80 c1 10 80       	push   $0x8010c180
801094e0:	e8 0f 6f ff ff       	call   801003f4 <cprintf>
801094e5:	83 c4 10             	add    $0x10,%esp
  cprintf("-----Destination-----\n");
801094e8:	83 ec 0c             	sub    $0xc,%esp
801094eb:	68 99 c1 10 80       	push   $0x8010c199
801094f0:	e8 ff 6e ff ff       	call   801003f4 <cprintf>
801094f5:	83 c4 10             	add    $0x10,%esp
  print_ipv4(arp_p->dst_ip);
801094f8:	8b 45 08             	mov    0x8(%ebp),%eax
801094fb:	83 c0 18             	add    $0x18,%eax
801094fe:	83 ec 0c             	sub    $0xc,%esp
80109501:	50                   	push   %eax
80109502:	e8 94 00 00 00       	call   8010959b <print_ipv4>
80109507:	83 c4 10             	add    $0x10,%esp
  cprintf("\n");
8010950a:	83 ec 0c             	sub    $0xc,%esp
8010950d:	68 80 c1 10 80       	push   $0x8010c180
80109512:	e8 dd 6e ff ff       	call   801003f4 <cprintf>
80109517:	83 c4 10             	add    $0x10,%esp
  print_mac(arp_p->dst_mac);
8010951a:	8b 45 08             	mov    0x8(%ebp),%eax
8010951d:	83 c0 12             	add    $0x12,%eax
80109520:	83 ec 0c             	sub    $0xc,%esp
80109523:	50                   	push   %eax
80109524:	e8 c0 00 00 00       	call   801095e9 <print_mac>
80109529:	83 c4 10             	add    $0x10,%esp
  cprintf("\n");
8010952c:	83 ec 0c             	sub    $0xc,%esp
8010952f:	68 80 c1 10 80       	push   $0x8010c180
80109534:	e8 bb 6e ff ff       	call   801003f4 <cprintf>
80109539:	83 c4 10             	add    $0x10,%esp
  cprintf("Operation: ");
8010953c:	83 ec 0c             	sub    $0xc,%esp
8010953f:	68 b0 c1 10 80       	push   $0x8010c1b0
80109544:	e8 ab 6e ff ff       	call   801003f4 <cprintf>
80109549:	83 c4 10             	add    $0x10,%esp
  if(arp_p->op == ARP_OPS_REQUEST) cprintf("Request\n");
8010954c:	8b 45 08             	mov    0x8(%ebp),%eax
8010954f:	0f b7 40 06          	movzwl 0x6(%eax),%eax
80109553:	66 3d 00 01          	cmp    $0x100,%ax
80109557:	75 12                	jne    8010956b <print_arp_info+0xdd>
80109559:	83 ec 0c             	sub    $0xc,%esp
8010955c:	68 bc c1 10 80       	push   $0x8010c1bc
80109561:	e8 8e 6e ff ff       	call   801003f4 <cprintf>
80109566:	83 c4 10             	add    $0x10,%esp
80109569:	eb 1d                	jmp    80109588 <print_arp_info+0xfa>
  else if(arp_p->op == ARP_OPS_REPLY) {
8010956b:	8b 45 08             	mov    0x8(%ebp),%eax
8010956e:	0f b7 40 06          	movzwl 0x6(%eax),%eax
80109572:	66 3d 00 02          	cmp    $0x200,%ax
80109576:	75 10                	jne    80109588 <print_arp_info+0xfa>
    cprintf("Reply\n");
80109578:	83 ec 0c             	sub    $0xc,%esp
8010957b:	68 c5 c1 10 80       	push   $0x8010c1c5
80109580:	e8 6f 6e ff ff       	call   801003f4 <cprintf>
80109585:	83 c4 10             	add    $0x10,%esp
  }
  cprintf("\n");
80109588:	83 ec 0c             	sub    $0xc,%esp
8010958b:	68 80 c1 10 80       	push   $0x8010c180
80109590:	e8 5f 6e ff ff       	call   801003f4 <cprintf>
80109595:	83 c4 10             	add    $0x10,%esp
}
80109598:	90                   	nop
80109599:	c9                   	leave  
8010959a:	c3                   	ret    

8010959b <print_ipv4>:

void print_ipv4(uchar *ip){
8010959b:	55                   	push   %ebp
8010959c:	89 e5                	mov    %esp,%ebp
8010959e:	53                   	push   %ebx
8010959f:	83 ec 04             	sub    $0x4,%esp
  cprintf("IP address: %d.%d.%d.%d",ip[0],ip[1],ip[2],ip[3]);
801095a2:	8b 45 08             	mov    0x8(%ebp),%eax
801095a5:	83 c0 03             	add    $0x3,%eax
801095a8:	0f b6 00             	movzbl (%eax),%eax
801095ab:	0f b6 d8             	movzbl %al,%ebx
801095ae:	8b 45 08             	mov    0x8(%ebp),%eax
801095b1:	83 c0 02             	add    $0x2,%eax
801095b4:	0f b6 00             	movzbl (%eax),%eax
801095b7:	0f b6 c8             	movzbl %al,%ecx
801095ba:	8b 45 08             	mov    0x8(%ebp),%eax
801095bd:	83 c0 01             	add    $0x1,%eax
801095c0:	0f b6 00             	movzbl (%eax),%eax
801095c3:	0f b6 d0             	movzbl %al,%edx
801095c6:	8b 45 08             	mov    0x8(%ebp),%eax
801095c9:	0f b6 00             	movzbl (%eax),%eax
801095cc:	0f b6 c0             	movzbl %al,%eax
801095cf:	83 ec 0c             	sub    $0xc,%esp
801095d2:	53                   	push   %ebx
801095d3:	51                   	push   %ecx
801095d4:	52                   	push   %edx
801095d5:	50                   	push   %eax
801095d6:	68 cc c1 10 80       	push   $0x8010c1cc
801095db:	e8 14 6e ff ff       	call   801003f4 <cprintf>
801095e0:	83 c4 20             	add    $0x20,%esp
}
801095e3:	90                   	nop
801095e4:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801095e7:	c9                   	leave  
801095e8:	c3                   	ret    

801095e9 <print_mac>:

void print_mac(uchar *mac){
801095e9:	55                   	push   %ebp
801095ea:	89 e5                	mov    %esp,%ebp
801095ec:	57                   	push   %edi
801095ed:	56                   	push   %esi
801095ee:	53                   	push   %ebx
801095ef:	83 ec 0c             	sub    $0xc,%esp
  cprintf("MAC address: %x:%x:%x:%x:%x:%x",mac[0],mac[1],mac[2],mac[3],mac[4],mac[5]);
801095f2:	8b 45 08             	mov    0x8(%ebp),%eax
801095f5:	83 c0 05             	add    $0x5,%eax
801095f8:	0f b6 00             	movzbl (%eax),%eax
801095fb:	0f b6 f8             	movzbl %al,%edi
801095fe:	8b 45 08             	mov    0x8(%ebp),%eax
80109601:	83 c0 04             	add    $0x4,%eax
80109604:	0f b6 00             	movzbl (%eax),%eax
80109607:	0f b6 f0             	movzbl %al,%esi
8010960a:	8b 45 08             	mov    0x8(%ebp),%eax
8010960d:	83 c0 03             	add    $0x3,%eax
80109610:	0f b6 00             	movzbl (%eax),%eax
80109613:	0f b6 d8             	movzbl %al,%ebx
80109616:	8b 45 08             	mov    0x8(%ebp),%eax
80109619:	83 c0 02             	add    $0x2,%eax
8010961c:	0f b6 00             	movzbl (%eax),%eax
8010961f:	0f b6 c8             	movzbl %al,%ecx
80109622:	8b 45 08             	mov    0x8(%ebp),%eax
80109625:	83 c0 01             	add    $0x1,%eax
80109628:	0f b6 00             	movzbl (%eax),%eax
8010962b:	0f b6 d0             	movzbl %al,%edx
8010962e:	8b 45 08             	mov    0x8(%ebp),%eax
80109631:	0f b6 00             	movzbl (%eax),%eax
80109634:	0f b6 c0             	movzbl %al,%eax
80109637:	83 ec 04             	sub    $0x4,%esp
8010963a:	57                   	push   %edi
8010963b:	56                   	push   %esi
8010963c:	53                   	push   %ebx
8010963d:	51                   	push   %ecx
8010963e:	52                   	push   %edx
8010963f:	50                   	push   %eax
80109640:	68 e4 c1 10 80       	push   $0x8010c1e4
80109645:	e8 aa 6d ff ff       	call   801003f4 <cprintf>
8010964a:	83 c4 20             	add    $0x20,%esp
}
8010964d:	90                   	nop
8010964e:	8d 65 f4             	lea    -0xc(%ebp),%esp
80109651:	5b                   	pop    %ebx
80109652:	5e                   	pop    %esi
80109653:	5f                   	pop    %edi
80109654:	5d                   	pop    %ebp
80109655:	c3                   	ret    

80109656 <eth_proc>:
#include "arp.h"
#include "types.h"
#include "eth.h"
#include "defs.h"
#include "ipv4.h"
void eth_proc(uint buffer_addr){
80109656:	55                   	push   %ebp
80109657:	89 e5                	mov    %esp,%ebp
80109659:	83 ec 18             	sub    $0x18,%esp
  struct eth_pkt *eth_pkt = (struct eth_pkt *)buffer_addr;
8010965c:	8b 45 08             	mov    0x8(%ebp),%eax
8010965f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  uint pkt_addr = buffer_addr+sizeof(struct eth_pkt);
80109662:	8b 45 08             	mov    0x8(%ebp),%eax
80109665:	83 c0 0e             	add    $0xe,%eax
80109668:	89 45 f0             	mov    %eax,-0x10(%ebp)
  if(eth_pkt->type[0] == 0x08 && eth_pkt->type[1] == 0x06){
8010966b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010966e:	0f b6 40 0c          	movzbl 0xc(%eax),%eax
80109672:	3c 08                	cmp    $0x8,%al
80109674:	75 1b                	jne    80109691 <eth_proc+0x3b>
80109676:	8b 45 f4             	mov    -0xc(%ebp),%eax
80109679:	0f b6 40 0d          	movzbl 0xd(%eax),%eax
8010967d:	3c 06                	cmp    $0x6,%al
8010967f:	75 10                	jne    80109691 <eth_proc+0x3b>
    arp_proc(pkt_addr);
80109681:	83 ec 0c             	sub    $0xc,%esp
80109684:	ff 75 f0             	push   -0x10(%ebp)
80109687:	e8 01 f8 ff ff       	call   80108e8d <arp_proc>
8010968c:	83 c4 10             	add    $0x10,%esp
  }else if(eth_pkt->type[0] == 0x08 && eth_pkt->type[1] == 0x00){
    ipv4_proc(buffer_addr);
  }else{
  }
}
8010968f:	eb 24                	jmp    801096b5 <eth_proc+0x5f>
  }else if(eth_pkt->type[0] == 0x08 && eth_pkt->type[1] == 0x00){
80109691:	8b 45 f4             	mov    -0xc(%ebp),%eax
80109694:	0f b6 40 0c          	movzbl 0xc(%eax),%eax
80109698:	3c 08                	cmp    $0x8,%al
8010969a:	75 19                	jne    801096b5 <eth_proc+0x5f>
8010969c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010969f:	0f b6 40 0d          	movzbl 0xd(%eax),%eax
801096a3:	84 c0                	test   %al,%al
801096a5:	75 0e                	jne    801096b5 <eth_proc+0x5f>
    ipv4_proc(buffer_addr);
801096a7:	83 ec 0c             	sub    $0xc,%esp
801096aa:	ff 75 08             	push   0x8(%ebp)
801096ad:	e8 a3 00 00 00       	call   80109755 <ipv4_proc>
801096b2:	83 c4 10             	add    $0x10,%esp
}
801096b5:	90                   	nop
801096b6:	c9                   	leave  
801096b7:	c3                   	ret    

801096b8 <N2H_ushort>:

ushort N2H_ushort(ushort value){
801096b8:	55                   	push   %ebp
801096b9:	89 e5                	mov    %esp,%ebp
801096bb:	83 ec 04             	sub    $0x4,%esp
801096be:	8b 45 08             	mov    0x8(%ebp),%eax
801096c1:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  return (((value)&0xFF)<<8)+(value>>8);
801096c5:	0f b7 45 fc          	movzwl -0x4(%ebp),%eax
801096c9:	c1 e0 08             	shl    $0x8,%eax
801096cc:	89 c2                	mov    %eax,%edx
801096ce:	0f b7 45 fc          	movzwl -0x4(%ebp),%eax
801096d2:	66 c1 e8 08          	shr    $0x8,%ax
801096d6:	01 d0                	add    %edx,%eax
}
801096d8:	c9                   	leave  
801096d9:	c3                   	ret    

801096da <H2N_ushort>:

ushort H2N_ushort(ushort value){
801096da:	55                   	push   %ebp
801096db:	89 e5                	mov    %esp,%ebp
801096dd:	83 ec 04             	sub    $0x4,%esp
801096e0:	8b 45 08             	mov    0x8(%ebp),%eax
801096e3:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  return (((value)&0xFF)<<8)+(value>>8);
801096e7:	0f b7 45 fc          	movzwl -0x4(%ebp),%eax
801096eb:	c1 e0 08             	shl    $0x8,%eax
801096ee:	89 c2                	mov    %eax,%edx
801096f0:	0f b7 45 fc          	movzwl -0x4(%ebp),%eax
801096f4:	66 c1 e8 08          	shr    $0x8,%ax
801096f8:	01 d0                	add    %edx,%eax
}
801096fa:	c9                   	leave  
801096fb:	c3                   	ret    

801096fc <H2N_uint>:

uint H2N_uint(uint value){
801096fc:	55                   	push   %ebp
801096fd:	89 e5                	mov    %esp,%ebp
  return ((value&0xF)<<24)+((value&0xF0)<<8)+((value&0xF00)>>8)+((value&0xF000)>>24);
801096ff:	8b 45 08             	mov    0x8(%ebp),%eax
80109702:	c1 e0 18             	shl    $0x18,%eax
80109705:	25 00 00 00 0f       	and    $0xf000000,%eax
8010970a:	89 c2                	mov    %eax,%edx
8010970c:	8b 45 08             	mov    0x8(%ebp),%eax
8010970f:	c1 e0 08             	shl    $0x8,%eax
80109712:	25 00 f0 00 00       	and    $0xf000,%eax
80109717:	09 c2                	or     %eax,%edx
80109719:	8b 45 08             	mov    0x8(%ebp),%eax
8010971c:	c1 e8 08             	shr    $0x8,%eax
8010971f:	83 e0 0f             	and    $0xf,%eax
80109722:	01 d0                	add    %edx,%eax
}
80109724:	5d                   	pop    %ebp
80109725:	c3                   	ret    

80109726 <N2H_uint>:

uint N2H_uint(uint value){
80109726:	55                   	push   %ebp
80109727:	89 e5                	mov    %esp,%ebp
  return ((value&0xFF)<<24)+((value&0xFF00)<<8)+((value&0xFF0000)>>8)+((value&0xFF000000)>>24);
80109729:	8b 45 08             	mov    0x8(%ebp),%eax
8010972c:	c1 e0 18             	shl    $0x18,%eax
8010972f:	89 c2                	mov    %eax,%edx
80109731:	8b 45 08             	mov    0x8(%ebp),%eax
80109734:	c1 e0 08             	shl    $0x8,%eax
80109737:	25 00 00 ff 00       	and    $0xff0000,%eax
8010973c:	01 c2                	add    %eax,%edx
8010973e:	8b 45 08             	mov    0x8(%ebp),%eax
80109741:	c1 e8 08             	shr    $0x8,%eax
80109744:	25 00 ff 00 00       	and    $0xff00,%eax
80109749:	01 c2                	add    %eax,%edx
8010974b:	8b 45 08             	mov    0x8(%ebp),%eax
8010974e:	c1 e8 18             	shr    $0x18,%eax
80109751:	01 d0                	add    %edx,%eax
}
80109753:	5d                   	pop    %ebp
80109754:	c3                   	ret    

80109755 <ipv4_proc>:
extern uchar mac_addr[6];
extern uchar my_ip[4];

int ip_id = -1;
ushort send_id = 0;
void ipv4_proc(uint buffer_addr){
80109755:	55                   	push   %ebp
80109756:	89 e5                	mov    %esp,%ebp
80109758:	83 ec 18             	sub    $0x18,%esp
  struct ipv4_pkt *ipv4_p = (struct ipv4_pkt *)(buffer_addr+14);
8010975b:	8b 45 08             	mov    0x8(%ebp),%eax
8010975e:	83 c0 0e             	add    $0xe,%eax
80109761:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(ip_id != ipv4_p->id && memcmp(my_ip,ipv4_p->src_ip,4) != 0){
80109764:	8b 45 f4             	mov    -0xc(%ebp),%eax
80109767:	0f b7 40 04          	movzwl 0x4(%eax),%eax
8010976b:	0f b7 d0             	movzwl %ax,%edx
8010976e:	a1 08 f5 10 80       	mov    0x8010f508,%eax
80109773:	39 c2                	cmp    %eax,%edx
80109775:	74 60                	je     801097d7 <ipv4_proc+0x82>
80109777:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010977a:	83 c0 0c             	add    $0xc,%eax
8010977d:	83 ec 04             	sub    $0x4,%esp
80109780:	6a 04                	push   $0x4
80109782:	50                   	push   %eax
80109783:	68 04 f5 10 80       	push   $0x8010f504
80109788:	e8 f4 b4 ff ff       	call   80104c81 <memcmp>
8010978d:	83 c4 10             	add    $0x10,%esp
80109790:	85 c0                	test   %eax,%eax
80109792:	74 43                	je     801097d7 <ipv4_proc+0x82>
    ip_id = ipv4_p->id;
80109794:	8b 45 f4             	mov    -0xc(%ebp),%eax
80109797:	0f b7 40 04          	movzwl 0x4(%eax),%eax
8010979b:	0f b7 c0             	movzwl %ax,%eax
8010979e:	a3 08 f5 10 80       	mov    %eax,0x8010f508
      if(ipv4_p->protocol == IPV4_TYPE_ICMP){
801097a3:	8b 45 f4             	mov    -0xc(%ebp),%eax
801097a6:	0f b6 40 09          	movzbl 0x9(%eax),%eax
801097aa:	3c 01                	cmp    $0x1,%al
801097ac:	75 10                	jne    801097be <ipv4_proc+0x69>
        icmp_proc(buffer_addr);
801097ae:	83 ec 0c             	sub    $0xc,%esp
801097b1:	ff 75 08             	push   0x8(%ebp)
801097b4:	e8 a3 00 00 00       	call   8010985c <icmp_proc>
801097b9:	83 c4 10             	add    $0x10,%esp
      }else if(ipv4_p->protocol == IPV4_TYPE_TCP){
        tcp_proc(buffer_addr);
      }
  }
}
801097bc:	eb 19                	jmp    801097d7 <ipv4_proc+0x82>
      }else if(ipv4_p->protocol == IPV4_TYPE_TCP){
801097be:	8b 45 f4             	mov    -0xc(%ebp),%eax
801097c1:	0f b6 40 09          	movzbl 0x9(%eax),%eax
801097c5:	3c 06                	cmp    $0x6,%al
801097c7:	75 0e                	jne    801097d7 <ipv4_proc+0x82>
        tcp_proc(buffer_addr);
801097c9:	83 ec 0c             	sub    $0xc,%esp
801097cc:	ff 75 08             	push   0x8(%ebp)
801097cf:	e8 b3 03 00 00       	call   80109b87 <tcp_proc>
801097d4:	83 c4 10             	add    $0x10,%esp
}
801097d7:	90                   	nop
801097d8:	c9                   	leave  
801097d9:	c3                   	ret    

801097da <ipv4_chksum>:

ushort ipv4_chksum(uint ipv4_addr){
801097da:	55                   	push   %ebp
801097db:	89 e5                	mov    %esp,%ebp
801097dd:	83 ec 10             	sub    $0x10,%esp
  uchar* bin = (uchar *)ipv4_addr;
801097e0:	8b 45 08             	mov    0x8(%ebp),%eax
801097e3:	89 45 f4             	mov    %eax,-0xc(%ebp)
  uchar len = (bin[0]&0xF)*2;
801097e6:	8b 45 f4             	mov    -0xc(%ebp),%eax
801097e9:	0f b6 00             	movzbl (%eax),%eax
801097ec:	83 e0 0f             	and    $0xf,%eax
801097ef:	01 c0                	add    %eax,%eax
801097f1:	88 45 f3             	mov    %al,-0xd(%ebp)
  uint chk_sum = 0;
801097f4:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  for(int i=0;i<len;i++){
801097fb:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
80109802:	eb 48                	jmp    8010984c <ipv4_chksum+0x72>
    chk_sum += (bin[i*2]<<8)+bin[i*2+1];
80109804:	8b 45 f8             	mov    -0x8(%ebp),%eax
80109807:	01 c0                	add    %eax,%eax
80109809:	89 c2                	mov    %eax,%edx
8010980b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010980e:	01 d0                	add    %edx,%eax
80109810:	0f b6 00             	movzbl (%eax),%eax
80109813:	0f b6 c0             	movzbl %al,%eax
80109816:	c1 e0 08             	shl    $0x8,%eax
80109819:	89 c2                	mov    %eax,%edx
8010981b:	8b 45 f8             	mov    -0x8(%ebp),%eax
8010981e:	01 c0                	add    %eax,%eax
80109820:	8d 48 01             	lea    0x1(%eax),%ecx
80109823:	8b 45 f4             	mov    -0xc(%ebp),%eax
80109826:	01 c8                	add    %ecx,%eax
80109828:	0f b6 00             	movzbl (%eax),%eax
8010982b:	0f b6 c0             	movzbl %al,%eax
8010982e:	01 d0                	add    %edx,%eax
80109830:	01 45 fc             	add    %eax,-0x4(%ebp)
    if(chk_sum > 0xFFFF){
80109833:	81 7d fc ff ff 00 00 	cmpl   $0xffff,-0x4(%ebp)
8010983a:	76 0c                	jbe    80109848 <ipv4_chksum+0x6e>
      chk_sum = (chk_sum&0xFFFF)+1;
8010983c:	8b 45 fc             	mov    -0x4(%ebp),%eax
8010983f:	0f b7 c0             	movzwl %ax,%eax
80109842:	83 c0 01             	add    $0x1,%eax
80109845:	89 45 fc             	mov    %eax,-0x4(%ebp)
  for(int i=0;i<len;i++){
80109848:	83 45 f8 01          	addl   $0x1,-0x8(%ebp)
8010984c:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
80109850:	39 45 f8             	cmp    %eax,-0x8(%ebp)
80109853:	7c af                	jl     80109804 <ipv4_chksum+0x2a>
    }
  }
  return ~(chk_sum);
80109855:	8b 45 fc             	mov    -0x4(%ebp),%eax
80109858:	f7 d0                	not    %eax
}
8010985a:	c9                   	leave  
8010985b:	c3                   	ret    

8010985c <icmp_proc>:
#include "eth.h"

extern uchar mac_addr[6];
extern uchar my_ip[4];
extern ushort send_id;
void icmp_proc(uint buffer_addr){
8010985c:	55                   	push   %ebp
8010985d:	89 e5                	mov    %esp,%ebp
8010985f:	83 ec 18             	sub    $0x18,%esp
  struct ipv4_pkt *ipv4_p = (struct ipv4_pkt *)(buffer_addr+sizeof(struct eth_pkt));
80109862:	8b 45 08             	mov    0x8(%ebp),%eax
80109865:	83 c0 0e             	add    $0xe,%eax
80109868:	89 45 f4             	mov    %eax,-0xc(%ebp)
  struct icmp_echo_pkt *icmp_p = (struct icmp_echo_pkt *)((uint)ipv4_p + (ipv4_p->ver&0xF)*4);
8010986b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010986e:	0f b6 00             	movzbl (%eax),%eax
80109871:	0f b6 c0             	movzbl %al,%eax
80109874:	83 e0 0f             	and    $0xf,%eax
80109877:	c1 e0 02             	shl    $0x2,%eax
8010987a:	89 c2                	mov    %eax,%edx
8010987c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010987f:	01 d0                	add    %edx,%eax
80109881:	89 45 f0             	mov    %eax,-0x10(%ebp)
  if(icmp_p->code == 0){
80109884:	8b 45 f0             	mov    -0x10(%ebp),%eax
80109887:	0f b6 40 01          	movzbl 0x1(%eax),%eax
8010988b:	84 c0                	test   %al,%al
8010988d:	75 4f                	jne    801098de <icmp_proc+0x82>
    if(icmp_p->type == ICMP_TYPE_ECHO_REQUEST){
8010988f:	8b 45 f0             	mov    -0x10(%ebp),%eax
80109892:	0f b6 00             	movzbl (%eax),%eax
80109895:	3c 08                	cmp    $0x8,%al
80109897:	75 45                	jne    801098de <icmp_proc+0x82>
      uint send_addr = (uint)kalloc();
80109899:	e8 02 8f ff ff       	call   801027a0 <kalloc>
8010989e:	89 45 ec             	mov    %eax,-0x14(%ebp)
      uint send_size = 0;
801098a1:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
      icmp_reply_pkt_create(buffer_addr,send_addr,&send_size);
801098a8:	83 ec 04             	sub    $0x4,%esp
801098ab:	8d 45 e8             	lea    -0x18(%ebp),%eax
801098ae:	50                   	push   %eax
801098af:	ff 75 ec             	push   -0x14(%ebp)
801098b2:	ff 75 08             	push   0x8(%ebp)
801098b5:	e8 78 00 00 00       	call   80109932 <icmp_reply_pkt_create>
801098ba:	83 c4 10             	add    $0x10,%esp
      i8254_send(send_addr,send_size);
801098bd:	8b 45 e8             	mov    -0x18(%ebp),%eax
801098c0:	83 ec 08             	sub    $0x8,%esp
801098c3:	50                   	push   %eax
801098c4:	ff 75 ec             	push   -0x14(%ebp)
801098c7:	e8 95 f4 ff ff       	call   80108d61 <i8254_send>
801098cc:	83 c4 10             	add    $0x10,%esp
      kfree((char *)send_addr);
801098cf:	8b 45 ec             	mov    -0x14(%ebp),%eax
801098d2:	83 ec 0c             	sub    $0xc,%esp
801098d5:	50                   	push   %eax
801098d6:	e8 2b 8e ff ff       	call   80102706 <kfree>
801098db:	83 c4 10             	add    $0x10,%esp
    }
  }
}
801098de:	90                   	nop
801098df:	c9                   	leave  
801098e0:	c3                   	ret    

801098e1 <icmp_proc_req>:

void icmp_proc_req(struct icmp_echo_pkt * icmp_p){
801098e1:	55                   	push   %ebp
801098e2:	89 e5                	mov    %esp,%ebp
801098e4:	53                   	push   %ebx
801098e5:	83 ec 04             	sub    $0x4,%esp
  cprintf("ICMP ID:0x%x SEQ NUM:0x%x\n",N2H_ushort(icmp_p->id),N2H_ushort(icmp_p->seq_num));
801098e8:	8b 45 08             	mov    0x8(%ebp),%eax
801098eb:	0f b7 40 06          	movzwl 0x6(%eax),%eax
801098ef:	0f b7 c0             	movzwl %ax,%eax
801098f2:	83 ec 0c             	sub    $0xc,%esp
801098f5:	50                   	push   %eax
801098f6:	e8 bd fd ff ff       	call   801096b8 <N2H_ushort>
801098fb:	83 c4 10             	add    $0x10,%esp
801098fe:	0f b7 d8             	movzwl %ax,%ebx
80109901:	8b 45 08             	mov    0x8(%ebp),%eax
80109904:	0f b7 40 04          	movzwl 0x4(%eax),%eax
80109908:	0f b7 c0             	movzwl %ax,%eax
8010990b:	83 ec 0c             	sub    $0xc,%esp
8010990e:	50                   	push   %eax
8010990f:	e8 a4 fd ff ff       	call   801096b8 <N2H_ushort>
80109914:	83 c4 10             	add    $0x10,%esp
80109917:	0f b7 c0             	movzwl %ax,%eax
8010991a:	83 ec 04             	sub    $0x4,%esp
8010991d:	53                   	push   %ebx
8010991e:	50                   	push   %eax
8010991f:	68 03 c2 10 80       	push   $0x8010c203
80109924:	e8 cb 6a ff ff       	call   801003f4 <cprintf>
80109929:	83 c4 10             	add    $0x10,%esp
}
8010992c:	90                   	nop
8010992d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80109930:	c9                   	leave  
80109931:	c3                   	ret    

80109932 <icmp_reply_pkt_create>:

void icmp_reply_pkt_create(uint recv_addr,uint send_addr,uint *send_size){
80109932:	55                   	push   %ebp
80109933:	89 e5                	mov    %esp,%ebp
80109935:	83 ec 28             	sub    $0x28,%esp
  struct eth_pkt *eth_recv = (struct eth_pkt *)(recv_addr);
80109938:	8b 45 08             	mov    0x8(%ebp),%eax
8010993b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  struct ipv4_pkt *ipv4_recv = (struct ipv4_pkt *)(recv_addr+sizeof(struct eth_pkt));
8010993e:	8b 45 08             	mov    0x8(%ebp),%eax
80109941:	83 c0 0e             	add    $0xe,%eax
80109944:	89 45 f0             	mov    %eax,-0x10(%ebp)
  struct icmp_echo_pkt *icmp_recv = (struct icmp_echo_pkt *)((uint)ipv4_recv+(ipv4_recv->ver&0xF)*4);
80109947:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010994a:	0f b6 00             	movzbl (%eax),%eax
8010994d:	0f b6 c0             	movzbl %al,%eax
80109950:	83 e0 0f             	and    $0xf,%eax
80109953:	c1 e0 02             	shl    $0x2,%eax
80109956:	89 c2                	mov    %eax,%edx
80109958:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010995b:	01 d0                	add    %edx,%eax
8010995d:	89 45 ec             	mov    %eax,-0x14(%ebp)
  struct eth_pkt *eth_send = (struct eth_pkt *)(send_addr);
80109960:	8b 45 0c             	mov    0xc(%ebp),%eax
80109963:	89 45 e8             	mov    %eax,-0x18(%ebp)
  struct ipv4_pkt *ipv4_send = (struct ipv4_pkt *)(send_addr+sizeof(struct eth_pkt));
80109966:	8b 45 0c             	mov    0xc(%ebp),%eax
80109969:	83 c0 0e             	add    $0xe,%eax
8010996c:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  struct icmp_echo_pkt *icmp_send = (struct icmp_echo_pkt *)((uint)ipv4_send+sizeof(struct ipv4_pkt));
8010996f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80109972:	83 c0 14             	add    $0x14,%eax
80109975:	89 45 e0             	mov    %eax,-0x20(%ebp)
  
  *send_size = sizeof(struct eth_pkt) + sizeof(struct ipv4_pkt) + sizeof(struct icmp_echo_pkt);
80109978:	8b 45 10             	mov    0x10(%ebp),%eax
8010997b:	c7 00 62 00 00 00    	movl   $0x62,(%eax)
  memmove(eth_send->dst_mac,eth_recv->src_mac,6);
80109981:	8b 45 f4             	mov    -0xc(%ebp),%eax
80109984:	8d 50 06             	lea    0x6(%eax),%edx
80109987:	8b 45 e8             	mov    -0x18(%ebp),%eax
8010998a:	83 ec 04             	sub    $0x4,%esp
8010998d:	6a 06                	push   $0x6
8010998f:	52                   	push   %edx
80109990:	50                   	push   %eax
80109991:	e8 43 b3 ff ff       	call   80104cd9 <memmove>
80109996:	83 c4 10             	add    $0x10,%esp
  memmove(eth_send->src_mac,mac_addr,6);
80109999:	8b 45 e8             	mov    -0x18(%ebp),%eax
8010999c:	83 c0 06             	add    $0x6,%eax
8010999f:	83 ec 04             	sub    $0x4,%esp
801099a2:	6a 06                	push   $0x6
801099a4:	68 80 6e 19 80       	push   $0x80196e80
801099a9:	50                   	push   %eax
801099aa:	e8 2a b3 ff ff       	call   80104cd9 <memmove>
801099af:	83 c4 10             	add    $0x10,%esp
  eth_send->type[0] = 0x08;
801099b2:	8b 45 e8             	mov    -0x18(%ebp),%eax
801099b5:	c6 40 0c 08          	movb   $0x8,0xc(%eax)
  eth_send->type[1] = 0x00;
801099b9:	8b 45 e8             	mov    -0x18(%ebp),%eax
801099bc:	c6 40 0d 00          	movb   $0x0,0xd(%eax)

  ipv4_send->ver = ((0x4)<<4)+((sizeof(struct ipv4_pkt)/4)&0xF);
801099c0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801099c3:	c6 00 45             	movb   $0x45,(%eax)
  ipv4_send->srv_type = 0;
801099c6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801099c9:	c6 40 01 00          	movb   $0x0,0x1(%eax)
  ipv4_send->total_len = H2N_ushort(sizeof(struct ipv4_pkt) + sizeof(struct icmp_echo_pkt));
801099cd:	83 ec 0c             	sub    $0xc,%esp
801099d0:	6a 54                	push   $0x54
801099d2:	e8 03 fd ff ff       	call   801096da <H2N_ushort>
801099d7:	83 c4 10             	add    $0x10,%esp
801099da:	8b 55 e4             	mov    -0x1c(%ebp),%edx
801099dd:	66 89 42 02          	mov    %ax,0x2(%edx)
  ipv4_send->id = send_id;
801099e1:	0f b7 15 60 71 19 80 	movzwl 0x80197160,%edx
801099e8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801099eb:	66 89 50 04          	mov    %dx,0x4(%eax)
  send_id++;
801099ef:	0f b7 05 60 71 19 80 	movzwl 0x80197160,%eax
801099f6:	83 c0 01             	add    $0x1,%eax
801099f9:	66 a3 60 71 19 80    	mov    %ax,0x80197160
  ipv4_send->fragment = H2N_ushort(0x4000);
801099ff:	83 ec 0c             	sub    $0xc,%esp
80109a02:	68 00 40 00 00       	push   $0x4000
80109a07:	e8 ce fc ff ff       	call   801096da <H2N_ushort>
80109a0c:	83 c4 10             	add    $0x10,%esp
80109a0f:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80109a12:	66 89 42 06          	mov    %ax,0x6(%edx)
  ipv4_send->ttl = 255;
80109a16:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80109a19:	c6 40 08 ff          	movb   $0xff,0x8(%eax)
  ipv4_send->protocol = 0x1;
80109a1d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80109a20:	c6 40 09 01          	movb   $0x1,0x9(%eax)
  memmove(ipv4_send->src_ip,my_ip,4);
80109a24:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80109a27:	83 c0 0c             	add    $0xc,%eax
80109a2a:	83 ec 04             	sub    $0x4,%esp
80109a2d:	6a 04                	push   $0x4
80109a2f:	68 04 f5 10 80       	push   $0x8010f504
80109a34:	50                   	push   %eax
80109a35:	e8 9f b2 ff ff       	call   80104cd9 <memmove>
80109a3a:	83 c4 10             	add    $0x10,%esp
  memmove(ipv4_send->dst_ip,ipv4_recv->src_ip,4);
80109a3d:	8b 45 f0             	mov    -0x10(%ebp),%eax
80109a40:	8d 50 0c             	lea    0xc(%eax),%edx
80109a43:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80109a46:	83 c0 10             	add    $0x10,%eax
80109a49:	83 ec 04             	sub    $0x4,%esp
80109a4c:	6a 04                	push   $0x4
80109a4e:	52                   	push   %edx
80109a4f:	50                   	push   %eax
80109a50:	e8 84 b2 ff ff       	call   80104cd9 <memmove>
80109a55:	83 c4 10             	add    $0x10,%esp
  ipv4_send->chk_sum = 0;
80109a58:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80109a5b:	66 c7 40 0a 00 00    	movw   $0x0,0xa(%eax)
  ipv4_send->chk_sum = H2N_ushort(ipv4_chksum((uint)ipv4_send));
80109a61:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80109a64:	83 ec 0c             	sub    $0xc,%esp
80109a67:	50                   	push   %eax
80109a68:	e8 6d fd ff ff       	call   801097da <ipv4_chksum>
80109a6d:	83 c4 10             	add    $0x10,%esp
80109a70:	0f b7 c0             	movzwl %ax,%eax
80109a73:	83 ec 0c             	sub    $0xc,%esp
80109a76:	50                   	push   %eax
80109a77:	e8 5e fc ff ff       	call   801096da <H2N_ushort>
80109a7c:	83 c4 10             	add    $0x10,%esp
80109a7f:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80109a82:	66 89 42 0a          	mov    %ax,0xa(%edx)

  icmp_send->type = ICMP_TYPE_ECHO_REPLY;
80109a86:	8b 45 e0             	mov    -0x20(%ebp),%eax
80109a89:	c6 00 00             	movb   $0x0,(%eax)
  icmp_send->code = 0;
80109a8c:	8b 45 e0             	mov    -0x20(%ebp),%eax
80109a8f:	c6 40 01 00          	movb   $0x0,0x1(%eax)
  icmp_send->id = icmp_recv->id;
80109a93:	8b 45 ec             	mov    -0x14(%ebp),%eax
80109a96:	0f b7 50 04          	movzwl 0x4(%eax),%edx
80109a9a:	8b 45 e0             	mov    -0x20(%ebp),%eax
80109a9d:	66 89 50 04          	mov    %dx,0x4(%eax)
  icmp_send->seq_num = icmp_recv->seq_num;
80109aa1:	8b 45 ec             	mov    -0x14(%ebp),%eax
80109aa4:	0f b7 50 06          	movzwl 0x6(%eax),%edx
80109aa8:	8b 45 e0             	mov    -0x20(%ebp),%eax
80109aab:	66 89 50 06          	mov    %dx,0x6(%eax)
  memmove(icmp_send->time_stamp,icmp_recv->time_stamp,8);
80109aaf:	8b 45 ec             	mov    -0x14(%ebp),%eax
80109ab2:	8d 50 08             	lea    0x8(%eax),%edx
80109ab5:	8b 45 e0             	mov    -0x20(%ebp),%eax
80109ab8:	83 c0 08             	add    $0x8,%eax
80109abb:	83 ec 04             	sub    $0x4,%esp
80109abe:	6a 08                	push   $0x8
80109ac0:	52                   	push   %edx
80109ac1:	50                   	push   %eax
80109ac2:	e8 12 b2 ff ff       	call   80104cd9 <memmove>
80109ac7:	83 c4 10             	add    $0x10,%esp
  memmove(icmp_send->data,icmp_recv->data,48);
80109aca:	8b 45 ec             	mov    -0x14(%ebp),%eax
80109acd:	8d 50 10             	lea    0x10(%eax),%edx
80109ad0:	8b 45 e0             	mov    -0x20(%ebp),%eax
80109ad3:	83 c0 10             	add    $0x10,%eax
80109ad6:	83 ec 04             	sub    $0x4,%esp
80109ad9:	6a 30                	push   $0x30
80109adb:	52                   	push   %edx
80109adc:	50                   	push   %eax
80109add:	e8 f7 b1 ff ff       	call   80104cd9 <memmove>
80109ae2:	83 c4 10             	add    $0x10,%esp
  icmp_send->chk_sum = 0;
80109ae5:	8b 45 e0             	mov    -0x20(%ebp),%eax
80109ae8:	66 c7 40 02 00 00    	movw   $0x0,0x2(%eax)
  icmp_send->chk_sum = H2N_ushort(icmp_chksum((uint)icmp_send));
80109aee:	8b 45 e0             	mov    -0x20(%ebp),%eax
80109af1:	83 ec 0c             	sub    $0xc,%esp
80109af4:	50                   	push   %eax
80109af5:	e8 1c 00 00 00       	call   80109b16 <icmp_chksum>
80109afa:	83 c4 10             	add    $0x10,%esp
80109afd:	0f b7 c0             	movzwl %ax,%eax
80109b00:	83 ec 0c             	sub    $0xc,%esp
80109b03:	50                   	push   %eax
80109b04:	e8 d1 fb ff ff       	call   801096da <H2N_ushort>
80109b09:	83 c4 10             	add    $0x10,%esp
80109b0c:	8b 55 e0             	mov    -0x20(%ebp),%edx
80109b0f:	66 89 42 02          	mov    %ax,0x2(%edx)
}
80109b13:	90                   	nop
80109b14:	c9                   	leave  
80109b15:	c3                   	ret    

80109b16 <icmp_chksum>:

ushort icmp_chksum(uint icmp_addr){
80109b16:	55                   	push   %ebp
80109b17:	89 e5                	mov    %esp,%ebp
80109b19:	83 ec 10             	sub    $0x10,%esp
  uchar* bin = (uchar *)icmp_addr;
80109b1c:	8b 45 08             	mov    0x8(%ebp),%eax
80109b1f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  uint chk_sum = 0;
80109b22:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  for(int i=0;i<32;i++){
80109b29:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
80109b30:	eb 48                	jmp    80109b7a <icmp_chksum+0x64>
    chk_sum += (bin[i*2]<<8)+bin[i*2+1];
80109b32:	8b 45 f8             	mov    -0x8(%ebp),%eax
80109b35:	01 c0                	add    %eax,%eax
80109b37:	89 c2                	mov    %eax,%edx
80109b39:	8b 45 f4             	mov    -0xc(%ebp),%eax
80109b3c:	01 d0                	add    %edx,%eax
80109b3e:	0f b6 00             	movzbl (%eax),%eax
80109b41:	0f b6 c0             	movzbl %al,%eax
80109b44:	c1 e0 08             	shl    $0x8,%eax
80109b47:	89 c2                	mov    %eax,%edx
80109b49:	8b 45 f8             	mov    -0x8(%ebp),%eax
80109b4c:	01 c0                	add    %eax,%eax
80109b4e:	8d 48 01             	lea    0x1(%eax),%ecx
80109b51:	8b 45 f4             	mov    -0xc(%ebp),%eax
80109b54:	01 c8                	add    %ecx,%eax
80109b56:	0f b6 00             	movzbl (%eax),%eax
80109b59:	0f b6 c0             	movzbl %al,%eax
80109b5c:	01 d0                	add    %edx,%eax
80109b5e:	01 45 fc             	add    %eax,-0x4(%ebp)
    if(chk_sum > 0xFFFF){
80109b61:	81 7d fc ff ff 00 00 	cmpl   $0xffff,-0x4(%ebp)
80109b68:	76 0c                	jbe    80109b76 <icmp_chksum+0x60>
      chk_sum = (chk_sum&0xFFFF)+1;
80109b6a:	8b 45 fc             	mov    -0x4(%ebp),%eax
80109b6d:	0f b7 c0             	movzwl %ax,%eax
80109b70:	83 c0 01             	add    $0x1,%eax
80109b73:	89 45 fc             	mov    %eax,-0x4(%ebp)
  for(int i=0;i<32;i++){
80109b76:	83 45 f8 01          	addl   $0x1,-0x8(%ebp)
80109b7a:	83 7d f8 1f          	cmpl   $0x1f,-0x8(%ebp)
80109b7e:	7e b2                	jle    80109b32 <icmp_chksum+0x1c>
    }
  }
  return ~(chk_sum);
80109b80:	8b 45 fc             	mov    -0x4(%ebp),%eax
80109b83:	f7 d0                	not    %eax
}
80109b85:	c9                   	leave  
80109b86:	c3                   	ret    

80109b87 <tcp_proc>:
extern ushort send_id;
extern uchar mac_addr[6];
extern uchar my_ip[4];
int fin_flag = 0;

void tcp_proc(uint buffer_addr){
80109b87:	55                   	push   %ebp
80109b88:	89 e5                	mov    %esp,%ebp
80109b8a:	83 ec 38             	sub    $0x38,%esp
  struct ipv4_pkt *ipv4_p = (struct ipv4_pkt *)(buffer_addr + sizeof(struct eth_pkt));
80109b8d:	8b 45 08             	mov    0x8(%ebp),%eax
80109b90:	83 c0 0e             	add    $0xe,%eax
80109b93:	89 45 f4             	mov    %eax,-0xc(%ebp)
  struct tcp_pkt *tcp_p = (struct tcp_pkt *)((uint)ipv4_p + (ipv4_p->ver&0xF)*4);
80109b96:	8b 45 f4             	mov    -0xc(%ebp),%eax
80109b99:	0f b6 00             	movzbl (%eax),%eax
80109b9c:	0f b6 c0             	movzbl %al,%eax
80109b9f:	83 e0 0f             	and    $0xf,%eax
80109ba2:	c1 e0 02             	shl    $0x2,%eax
80109ba5:	89 c2                	mov    %eax,%edx
80109ba7:	8b 45 f4             	mov    -0xc(%ebp),%eax
80109baa:	01 d0                	add    %edx,%eax
80109bac:	89 45 f0             	mov    %eax,-0x10(%ebp)
  char *payload = (char *)((uint)tcp_p + 20);
80109baf:	8b 45 f0             	mov    -0x10(%ebp),%eax
80109bb2:	83 c0 14             	add    $0x14,%eax
80109bb5:	89 45 ec             	mov    %eax,-0x14(%ebp)
  uint send_addr = (uint)kalloc();
80109bb8:	e8 e3 8b ff ff       	call   801027a0 <kalloc>
80109bbd:	89 45 e8             	mov    %eax,-0x18(%ebp)
  uint send_size = 0;
80109bc0:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
  if(tcp_p->code_bits[1]&TCP_CODEBITS_SYN){
80109bc7:	8b 45 f0             	mov    -0x10(%ebp),%eax
80109bca:	0f b6 40 0d          	movzbl 0xd(%eax),%eax
80109bce:	0f b6 c0             	movzbl %al,%eax
80109bd1:	83 e0 02             	and    $0x2,%eax
80109bd4:	85 c0                	test   %eax,%eax
80109bd6:	74 3d                	je     80109c15 <tcp_proc+0x8e>
    tcp_pkt_create(buffer_addr,send_addr,&send_size,TCP_CODEBITS_ACK | TCP_CODEBITS_SYN,0);
80109bd8:	83 ec 0c             	sub    $0xc,%esp
80109bdb:	6a 00                	push   $0x0
80109bdd:	6a 12                	push   $0x12
80109bdf:	8d 45 dc             	lea    -0x24(%ebp),%eax
80109be2:	50                   	push   %eax
80109be3:	ff 75 e8             	push   -0x18(%ebp)
80109be6:	ff 75 08             	push   0x8(%ebp)
80109be9:	e8 a2 01 00 00       	call   80109d90 <tcp_pkt_create>
80109bee:	83 c4 20             	add    $0x20,%esp
    i8254_send(send_addr,send_size);
80109bf1:	8b 45 dc             	mov    -0x24(%ebp),%eax
80109bf4:	83 ec 08             	sub    $0x8,%esp
80109bf7:	50                   	push   %eax
80109bf8:	ff 75 e8             	push   -0x18(%ebp)
80109bfb:	e8 61 f1 ff ff       	call   80108d61 <i8254_send>
80109c00:	83 c4 10             	add    $0x10,%esp
    seq_num++;
80109c03:	a1 64 71 19 80       	mov    0x80197164,%eax
80109c08:	83 c0 01             	add    $0x1,%eax
80109c0b:	a3 64 71 19 80       	mov    %eax,0x80197164
80109c10:	e9 69 01 00 00       	jmp    80109d7e <tcp_proc+0x1f7>
  }else if(tcp_p->code_bits[1] == (TCP_CODEBITS_PSH | TCP_CODEBITS_ACK)){
80109c15:	8b 45 f0             	mov    -0x10(%ebp),%eax
80109c18:	0f b6 40 0d          	movzbl 0xd(%eax),%eax
80109c1c:	3c 18                	cmp    $0x18,%al
80109c1e:	0f 85 10 01 00 00    	jne    80109d34 <tcp_proc+0x1ad>
    if(memcmp(payload,"GET",3)){
80109c24:	83 ec 04             	sub    $0x4,%esp
80109c27:	6a 03                	push   $0x3
80109c29:	68 1e c2 10 80       	push   $0x8010c21e
80109c2e:	ff 75 ec             	push   -0x14(%ebp)
80109c31:	e8 4b b0 ff ff       	call   80104c81 <memcmp>
80109c36:	83 c4 10             	add    $0x10,%esp
80109c39:	85 c0                	test   %eax,%eax
80109c3b:	74 74                	je     80109cb1 <tcp_proc+0x12a>
      cprintf("ACK PSH\n");
80109c3d:	83 ec 0c             	sub    $0xc,%esp
80109c40:	68 22 c2 10 80       	push   $0x8010c222
80109c45:	e8 aa 67 ff ff       	call   801003f4 <cprintf>
80109c4a:	83 c4 10             	add    $0x10,%esp
      tcp_pkt_create(buffer_addr,send_addr,&send_size,TCP_CODEBITS_ACK,0);
80109c4d:	83 ec 0c             	sub    $0xc,%esp
80109c50:	6a 00                	push   $0x0
80109c52:	6a 10                	push   $0x10
80109c54:	8d 45 dc             	lea    -0x24(%ebp),%eax
80109c57:	50                   	push   %eax
80109c58:	ff 75 e8             	push   -0x18(%ebp)
80109c5b:	ff 75 08             	push   0x8(%ebp)
80109c5e:	e8 2d 01 00 00       	call   80109d90 <tcp_pkt_create>
80109c63:	83 c4 20             	add    $0x20,%esp
      i8254_send(send_addr,send_size);
80109c66:	8b 45 dc             	mov    -0x24(%ebp),%eax
80109c69:	83 ec 08             	sub    $0x8,%esp
80109c6c:	50                   	push   %eax
80109c6d:	ff 75 e8             	push   -0x18(%ebp)
80109c70:	e8 ec f0 ff ff       	call   80108d61 <i8254_send>
80109c75:	83 c4 10             	add    $0x10,%esp
      uint send_payload = (send_addr + sizeof(struct eth_pkt) + sizeof(struct ipv4_pkt) + sizeof(struct tcp_pkt));
80109c78:	8b 45 e8             	mov    -0x18(%ebp),%eax
80109c7b:	83 c0 36             	add    $0x36,%eax
80109c7e:	89 45 e0             	mov    %eax,-0x20(%ebp)
      uint payload_size;
      http_proc(0,0,send_payload,&payload_size);
80109c81:	8d 45 d8             	lea    -0x28(%ebp),%eax
80109c84:	50                   	push   %eax
80109c85:	ff 75 e0             	push   -0x20(%ebp)
80109c88:	6a 00                	push   $0x0
80109c8a:	6a 00                	push   $0x0
80109c8c:	e8 5a 04 00 00       	call   8010a0eb <http_proc>
80109c91:	83 c4 10             	add    $0x10,%esp
      tcp_pkt_create(buffer_addr,send_addr,&send_size,(TCP_CODEBITS_ACK|TCP_CODEBITS_PSH),payload_size);
80109c94:	8b 45 d8             	mov    -0x28(%ebp),%eax
80109c97:	83 ec 0c             	sub    $0xc,%esp
80109c9a:	50                   	push   %eax
80109c9b:	6a 18                	push   $0x18
80109c9d:	8d 45 dc             	lea    -0x24(%ebp),%eax
80109ca0:	50                   	push   %eax
80109ca1:	ff 75 e8             	push   -0x18(%ebp)
80109ca4:	ff 75 08             	push   0x8(%ebp)
80109ca7:	e8 e4 00 00 00       	call   80109d90 <tcp_pkt_create>
80109cac:	83 c4 20             	add    $0x20,%esp
80109caf:	eb 62                	jmp    80109d13 <tcp_proc+0x18c>
    }else{
     tcp_pkt_create(buffer_addr,send_addr,&send_size,TCP_CODEBITS_ACK,0);
80109cb1:	83 ec 0c             	sub    $0xc,%esp
80109cb4:	6a 00                	push   $0x0
80109cb6:	6a 10                	push   $0x10
80109cb8:	8d 45 dc             	lea    -0x24(%ebp),%eax
80109cbb:	50                   	push   %eax
80109cbc:	ff 75 e8             	push   -0x18(%ebp)
80109cbf:	ff 75 08             	push   0x8(%ebp)
80109cc2:	e8 c9 00 00 00       	call   80109d90 <tcp_pkt_create>
80109cc7:	83 c4 20             	add    $0x20,%esp
     i8254_send(send_addr,send_size);
80109cca:	8b 45 dc             	mov    -0x24(%ebp),%eax
80109ccd:	83 ec 08             	sub    $0x8,%esp
80109cd0:	50                   	push   %eax
80109cd1:	ff 75 e8             	push   -0x18(%ebp)
80109cd4:	e8 88 f0 ff ff       	call   80108d61 <i8254_send>
80109cd9:	83 c4 10             	add    $0x10,%esp
      uint send_payload = (send_addr + sizeof(struct eth_pkt) + sizeof(struct ipv4_pkt) + sizeof(struct tcp_pkt));
80109cdc:	8b 45 e8             	mov    -0x18(%ebp),%eax
80109cdf:	83 c0 36             	add    $0x36,%eax
80109ce2:	89 45 e4             	mov    %eax,-0x1c(%ebp)
      uint payload_size;
      http_proc(0,0,send_payload,&payload_size);
80109ce5:	8d 45 d4             	lea    -0x2c(%ebp),%eax
80109ce8:	50                   	push   %eax
80109ce9:	ff 75 e4             	push   -0x1c(%ebp)
80109cec:	6a 00                	push   $0x0
80109cee:	6a 00                	push   $0x0
80109cf0:	e8 f6 03 00 00       	call   8010a0eb <http_proc>
80109cf5:	83 c4 10             	add    $0x10,%esp
      tcp_pkt_create(buffer_addr,send_addr,&send_size,(TCP_CODEBITS_ACK|TCP_CODEBITS_PSH),payload_size);
80109cf8:	8b 45 d4             	mov    -0x2c(%ebp),%eax
80109cfb:	83 ec 0c             	sub    $0xc,%esp
80109cfe:	50                   	push   %eax
80109cff:	6a 18                	push   $0x18
80109d01:	8d 45 dc             	lea    -0x24(%ebp),%eax
80109d04:	50                   	push   %eax
80109d05:	ff 75 e8             	push   -0x18(%ebp)
80109d08:	ff 75 08             	push   0x8(%ebp)
80109d0b:	e8 80 00 00 00       	call   80109d90 <tcp_pkt_create>
80109d10:	83 c4 20             	add    $0x20,%esp
    }
    i8254_send(send_addr,send_size);
80109d13:	8b 45 dc             	mov    -0x24(%ebp),%eax
80109d16:	83 ec 08             	sub    $0x8,%esp
80109d19:	50                   	push   %eax
80109d1a:	ff 75 e8             	push   -0x18(%ebp)
80109d1d:	e8 3f f0 ff ff       	call   80108d61 <i8254_send>
80109d22:	83 c4 10             	add    $0x10,%esp
    seq_num++;
80109d25:	a1 64 71 19 80       	mov    0x80197164,%eax
80109d2a:	83 c0 01             	add    $0x1,%eax
80109d2d:	a3 64 71 19 80       	mov    %eax,0x80197164
80109d32:	eb 4a                	jmp    80109d7e <tcp_proc+0x1f7>
  }else if(tcp_p->code_bits[1] == TCP_CODEBITS_ACK){
80109d34:	8b 45 f0             	mov    -0x10(%ebp),%eax
80109d37:	0f b6 40 0d          	movzbl 0xd(%eax),%eax
80109d3b:	3c 10                	cmp    $0x10,%al
80109d3d:	75 3f                	jne    80109d7e <tcp_proc+0x1f7>
    if(fin_flag == 1){
80109d3f:	a1 68 71 19 80       	mov    0x80197168,%eax
80109d44:	83 f8 01             	cmp    $0x1,%eax
80109d47:	75 35                	jne    80109d7e <tcp_proc+0x1f7>
      tcp_pkt_create(buffer_addr,send_addr,&send_size,TCP_CODEBITS_FIN,0);
80109d49:	83 ec 0c             	sub    $0xc,%esp
80109d4c:	6a 00                	push   $0x0
80109d4e:	6a 01                	push   $0x1
80109d50:	8d 45 dc             	lea    -0x24(%ebp),%eax
80109d53:	50                   	push   %eax
80109d54:	ff 75 e8             	push   -0x18(%ebp)
80109d57:	ff 75 08             	push   0x8(%ebp)
80109d5a:	e8 31 00 00 00       	call   80109d90 <tcp_pkt_create>
80109d5f:	83 c4 20             	add    $0x20,%esp
      i8254_send(send_addr,send_size);
80109d62:	8b 45 dc             	mov    -0x24(%ebp),%eax
80109d65:	83 ec 08             	sub    $0x8,%esp
80109d68:	50                   	push   %eax
80109d69:	ff 75 e8             	push   -0x18(%ebp)
80109d6c:	e8 f0 ef ff ff       	call   80108d61 <i8254_send>
80109d71:	83 c4 10             	add    $0x10,%esp
      fin_flag = 0;
80109d74:	c7 05 68 71 19 80 00 	movl   $0x0,0x80197168
80109d7b:	00 00 00 
    }
  }
  kfree((char *)send_addr);
80109d7e:	8b 45 e8             	mov    -0x18(%ebp),%eax
80109d81:	83 ec 0c             	sub    $0xc,%esp
80109d84:	50                   	push   %eax
80109d85:	e8 7c 89 ff ff       	call   80102706 <kfree>
80109d8a:	83 c4 10             	add    $0x10,%esp
}
80109d8d:	90                   	nop
80109d8e:	c9                   	leave  
80109d8f:	c3                   	ret    

80109d90 <tcp_pkt_create>:

void tcp_pkt_create(uint recv_addr,uint send_addr,uint *send_size,uint pkt_type,uint payload_size){
80109d90:	55                   	push   %ebp
80109d91:	89 e5                	mov    %esp,%ebp
80109d93:	83 ec 28             	sub    $0x28,%esp
  struct eth_pkt *eth_recv = (struct eth_pkt *)(recv_addr);
80109d96:	8b 45 08             	mov    0x8(%ebp),%eax
80109d99:	89 45 f4             	mov    %eax,-0xc(%ebp)
  struct ipv4_pkt *ipv4_recv = (struct ipv4_pkt *)(recv_addr+sizeof(struct eth_pkt));
80109d9c:	8b 45 08             	mov    0x8(%ebp),%eax
80109d9f:	83 c0 0e             	add    $0xe,%eax
80109da2:	89 45 f0             	mov    %eax,-0x10(%ebp)
  struct tcp_pkt *tcp_recv = (struct tcp_pkt *)((uint)ipv4_recv + (ipv4_recv->ver&0xF)*4);
80109da5:	8b 45 f0             	mov    -0x10(%ebp),%eax
80109da8:	0f b6 00             	movzbl (%eax),%eax
80109dab:	0f b6 c0             	movzbl %al,%eax
80109dae:	83 e0 0f             	and    $0xf,%eax
80109db1:	c1 e0 02             	shl    $0x2,%eax
80109db4:	89 c2                	mov    %eax,%edx
80109db6:	8b 45 f0             	mov    -0x10(%ebp),%eax
80109db9:	01 d0                	add    %edx,%eax
80109dbb:	89 45 ec             	mov    %eax,-0x14(%ebp)

  struct eth_pkt *eth_send = (struct eth_pkt *)(send_addr);
80109dbe:	8b 45 0c             	mov    0xc(%ebp),%eax
80109dc1:	89 45 e8             	mov    %eax,-0x18(%ebp)
  struct ipv4_pkt *ipv4_send = (struct ipv4_pkt *)(send_addr + sizeof(struct eth_pkt));
80109dc4:	8b 45 0c             	mov    0xc(%ebp),%eax
80109dc7:	83 c0 0e             	add    $0xe,%eax
80109dca:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  struct tcp_pkt *tcp_send = (struct tcp_pkt *)((uint)ipv4_send + sizeof(struct ipv4_pkt));
80109dcd:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80109dd0:	83 c0 14             	add    $0x14,%eax
80109dd3:	89 45 e0             	mov    %eax,-0x20(%ebp)

  *send_size = sizeof(struct eth_pkt) + sizeof(struct ipv4_pkt) + sizeof(struct tcp_pkt) + payload_size;
80109dd6:	8b 45 18             	mov    0x18(%ebp),%eax
80109dd9:	8d 50 36             	lea    0x36(%eax),%edx
80109ddc:	8b 45 10             	mov    0x10(%ebp),%eax
80109ddf:	89 10                	mov    %edx,(%eax)

  memmove(eth_send->dst_mac,eth_recv->src_mac,6);
80109de1:	8b 45 f4             	mov    -0xc(%ebp),%eax
80109de4:	8d 50 06             	lea    0x6(%eax),%edx
80109de7:	8b 45 e8             	mov    -0x18(%ebp),%eax
80109dea:	83 ec 04             	sub    $0x4,%esp
80109ded:	6a 06                	push   $0x6
80109def:	52                   	push   %edx
80109df0:	50                   	push   %eax
80109df1:	e8 e3 ae ff ff       	call   80104cd9 <memmove>
80109df6:	83 c4 10             	add    $0x10,%esp
  memmove(eth_send->src_mac,mac_addr,6);
80109df9:	8b 45 e8             	mov    -0x18(%ebp),%eax
80109dfc:	83 c0 06             	add    $0x6,%eax
80109dff:	83 ec 04             	sub    $0x4,%esp
80109e02:	6a 06                	push   $0x6
80109e04:	68 80 6e 19 80       	push   $0x80196e80
80109e09:	50                   	push   %eax
80109e0a:	e8 ca ae ff ff       	call   80104cd9 <memmove>
80109e0f:	83 c4 10             	add    $0x10,%esp
  eth_send->type[0] = 0x08;
80109e12:	8b 45 e8             	mov    -0x18(%ebp),%eax
80109e15:	c6 40 0c 08          	movb   $0x8,0xc(%eax)
  eth_send->type[1] = 0x00;
80109e19:	8b 45 e8             	mov    -0x18(%ebp),%eax
80109e1c:	c6 40 0d 00          	movb   $0x0,0xd(%eax)

  ipv4_send->ver = ((0x4)<<4)+((sizeof(struct ipv4_pkt)/4)&0xF);
80109e20:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80109e23:	c6 00 45             	movb   $0x45,(%eax)
  ipv4_send->srv_type = 0;
80109e26:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80109e29:	c6 40 01 00          	movb   $0x0,0x1(%eax)
  ipv4_send->total_len = H2N_ushort(sizeof(struct ipv4_pkt) + sizeof(struct tcp_pkt) + payload_size);
80109e2d:	8b 45 18             	mov    0x18(%ebp),%eax
80109e30:	83 c0 28             	add    $0x28,%eax
80109e33:	0f b7 c0             	movzwl %ax,%eax
80109e36:	83 ec 0c             	sub    $0xc,%esp
80109e39:	50                   	push   %eax
80109e3a:	e8 9b f8 ff ff       	call   801096da <H2N_ushort>
80109e3f:	83 c4 10             	add    $0x10,%esp
80109e42:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80109e45:	66 89 42 02          	mov    %ax,0x2(%edx)
  ipv4_send->id = send_id;
80109e49:	0f b7 15 60 71 19 80 	movzwl 0x80197160,%edx
80109e50:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80109e53:	66 89 50 04          	mov    %dx,0x4(%eax)
  send_id++;
80109e57:	0f b7 05 60 71 19 80 	movzwl 0x80197160,%eax
80109e5e:	83 c0 01             	add    $0x1,%eax
80109e61:	66 a3 60 71 19 80    	mov    %ax,0x80197160
  ipv4_send->fragment = H2N_ushort(0x0000);
80109e67:	83 ec 0c             	sub    $0xc,%esp
80109e6a:	6a 00                	push   $0x0
80109e6c:	e8 69 f8 ff ff       	call   801096da <H2N_ushort>
80109e71:	83 c4 10             	add    $0x10,%esp
80109e74:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80109e77:	66 89 42 06          	mov    %ax,0x6(%edx)
  ipv4_send->ttl = 255;
80109e7b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80109e7e:	c6 40 08 ff          	movb   $0xff,0x8(%eax)
  ipv4_send->protocol = IPV4_TYPE_TCP;
80109e82:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80109e85:	c6 40 09 06          	movb   $0x6,0x9(%eax)
  memmove(ipv4_send->src_ip,my_ip,4);
80109e89:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80109e8c:	83 c0 0c             	add    $0xc,%eax
80109e8f:	83 ec 04             	sub    $0x4,%esp
80109e92:	6a 04                	push   $0x4
80109e94:	68 04 f5 10 80       	push   $0x8010f504
80109e99:	50                   	push   %eax
80109e9a:	e8 3a ae ff ff       	call   80104cd9 <memmove>
80109e9f:	83 c4 10             	add    $0x10,%esp
  memmove(ipv4_send->dst_ip,ipv4_recv->src_ip,4);
80109ea2:	8b 45 f0             	mov    -0x10(%ebp),%eax
80109ea5:	8d 50 0c             	lea    0xc(%eax),%edx
80109ea8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80109eab:	83 c0 10             	add    $0x10,%eax
80109eae:	83 ec 04             	sub    $0x4,%esp
80109eb1:	6a 04                	push   $0x4
80109eb3:	52                   	push   %edx
80109eb4:	50                   	push   %eax
80109eb5:	e8 1f ae ff ff       	call   80104cd9 <memmove>
80109eba:	83 c4 10             	add    $0x10,%esp
  ipv4_send->chk_sum = 0;
80109ebd:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80109ec0:	66 c7 40 0a 00 00    	movw   $0x0,0xa(%eax)
  ipv4_send->chk_sum = H2N_ushort(ipv4_chksum((uint)ipv4_send));
80109ec6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80109ec9:	83 ec 0c             	sub    $0xc,%esp
80109ecc:	50                   	push   %eax
80109ecd:	e8 08 f9 ff ff       	call   801097da <ipv4_chksum>
80109ed2:	83 c4 10             	add    $0x10,%esp
80109ed5:	0f b7 c0             	movzwl %ax,%eax
80109ed8:	83 ec 0c             	sub    $0xc,%esp
80109edb:	50                   	push   %eax
80109edc:	e8 f9 f7 ff ff       	call   801096da <H2N_ushort>
80109ee1:	83 c4 10             	add    $0x10,%esp
80109ee4:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80109ee7:	66 89 42 0a          	mov    %ax,0xa(%edx)
  

  tcp_send->src_port = tcp_recv->dst_port;
80109eeb:	8b 45 ec             	mov    -0x14(%ebp),%eax
80109eee:	0f b7 50 02          	movzwl 0x2(%eax),%edx
80109ef2:	8b 45 e0             	mov    -0x20(%ebp),%eax
80109ef5:	66 89 10             	mov    %dx,(%eax)
  tcp_send->dst_port = tcp_recv->src_port;
80109ef8:	8b 45 ec             	mov    -0x14(%ebp),%eax
80109efb:	0f b7 10             	movzwl (%eax),%edx
80109efe:	8b 45 e0             	mov    -0x20(%ebp),%eax
80109f01:	66 89 50 02          	mov    %dx,0x2(%eax)
  tcp_send->seq_num = H2N_uint(seq_num);
80109f05:	a1 64 71 19 80       	mov    0x80197164,%eax
80109f0a:	83 ec 0c             	sub    $0xc,%esp
80109f0d:	50                   	push   %eax
80109f0e:	e8 e9 f7 ff ff       	call   801096fc <H2N_uint>
80109f13:	83 c4 10             	add    $0x10,%esp
80109f16:	8b 55 e0             	mov    -0x20(%ebp),%edx
80109f19:	89 42 04             	mov    %eax,0x4(%edx)
  tcp_send->ack_num = tcp_recv->seq_num + (1<<(8*3));
80109f1c:	8b 45 ec             	mov    -0x14(%ebp),%eax
80109f1f:	8b 40 04             	mov    0x4(%eax),%eax
80109f22:	8d 90 00 00 00 01    	lea    0x1000000(%eax),%edx
80109f28:	8b 45 e0             	mov    -0x20(%ebp),%eax
80109f2b:	89 50 08             	mov    %edx,0x8(%eax)

  tcp_send->code_bits[0] = 0;
80109f2e:	8b 45 e0             	mov    -0x20(%ebp),%eax
80109f31:	c6 40 0c 00          	movb   $0x0,0xc(%eax)
  tcp_send->code_bits[1] = 0;
80109f35:	8b 45 e0             	mov    -0x20(%ebp),%eax
80109f38:	c6 40 0d 00          	movb   $0x0,0xd(%eax)
  tcp_send->code_bits[0] = 5<<4;
80109f3c:	8b 45 e0             	mov    -0x20(%ebp),%eax
80109f3f:	c6 40 0c 50          	movb   $0x50,0xc(%eax)
  tcp_send->code_bits[1] = pkt_type;
80109f43:	8b 45 14             	mov    0x14(%ebp),%eax
80109f46:	89 c2                	mov    %eax,%edx
80109f48:	8b 45 e0             	mov    -0x20(%ebp),%eax
80109f4b:	88 50 0d             	mov    %dl,0xd(%eax)

  tcp_send->window = H2N_ushort(14480);
80109f4e:	83 ec 0c             	sub    $0xc,%esp
80109f51:	68 90 38 00 00       	push   $0x3890
80109f56:	e8 7f f7 ff ff       	call   801096da <H2N_ushort>
80109f5b:	83 c4 10             	add    $0x10,%esp
80109f5e:	8b 55 e0             	mov    -0x20(%ebp),%edx
80109f61:	66 89 42 0e          	mov    %ax,0xe(%edx)
  tcp_send->urgent_ptr = 0;
80109f65:	8b 45 e0             	mov    -0x20(%ebp),%eax
80109f68:	66 c7 40 12 00 00    	movw   $0x0,0x12(%eax)
  tcp_send->chk_sum = 0;
80109f6e:	8b 45 e0             	mov    -0x20(%ebp),%eax
80109f71:	66 c7 40 10 00 00    	movw   $0x0,0x10(%eax)

  tcp_send->chk_sum = H2N_ushort(tcp_chksum((uint)(ipv4_send))+8);
80109f77:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80109f7a:	83 ec 0c             	sub    $0xc,%esp
80109f7d:	50                   	push   %eax
80109f7e:	e8 1f 00 00 00       	call   80109fa2 <tcp_chksum>
80109f83:	83 c4 10             	add    $0x10,%esp
80109f86:	83 c0 08             	add    $0x8,%eax
80109f89:	0f b7 c0             	movzwl %ax,%eax
80109f8c:	83 ec 0c             	sub    $0xc,%esp
80109f8f:	50                   	push   %eax
80109f90:	e8 45 f7 ff ff       	call   801096da <H2N_ushort>
80109f95:	83 c4 10             	add    $0x10,%esp
80109f98:	8b 55 e0             	mov    -0x20(%ebp),%edx
80109f9b:	66 89 42 10          	mov    %ax,0x10(%edx)


}
80109f9f:	90                   	nop
80109fa0:	c9                   	leave  
80109fa1:	c3                   	ret    

80109fa2 <tcp_chksum>:

ushort tcp_chksum(uint tcp_addr){
80109fa2:	55                   	push   %ebp
80109fa3:	89 e5                	mov    %esp,%ebp
80109fa5:	83 ec 38             	sub    $0x38,%esp
  struct ipv4_pkt *ipv4_p = (struct ipv4_pkt *)(tcp_addr);
80109fa8:	8b 45 08             	mov    0x8(%ebp),%eax
80109fab:	89 45 e8             	mov    %eax,-0x18(%ebp)
  struct tcp_pkt *tcp_p = (struct tcp_pkt *)((uint)ipv4_p + sizeof(struct ipv4_pkt));
80109fae:	8b 45 e8             	mov    -0x18(%ebp),%eax
80109fb1:	83 c0 14             	add    $0x14,%eax
80109fb4:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  struct tcp_dummy tcp_dummy;
  
  memmove(tcp_dummy.src_ip,my_ip,4);
80109fb7:	83 ec 04             	sub    $0x4,%esp
80109fba:	6a 04                	push   $0x4
80109fbc:	68 04 f5 10 80       	push   $0x8010f504
80109fc1:	8d 45 d4             	lea    -0x2c(%ebp),%eax
80109fc4:	50                   	push   %eax
80109fc5:	e8 0f ad ff ff       	call   80104cd9 <memmove>
80109fca:	83 c4 10             	add    $0x10,%esp
  memmove(tcp_dummy.dst_ip,ipv4_p->src_ip,4);
80109fcd:	8b 45 e8             	mov    -0x18(%ebp),%eax
80109fd0:	83 c0 0c             	add    $0xc,%eax
80109fd3:	83 ec 04             	sub    $0x4,%esp
80109fd6:	6a 04                	push   $0x4
80109fd8:	50                   	push   %eax
80109fd9:	8d 45 d4             	lea    -0x2c(%ebp),%eax
80109fdc:	83 c0 04             	add    $0x4,%eax
80109fdf:	50                   	push   %eax
80109fe0:	e8 f4 ac ff ff       	call   80104cd9 <memmove>
80109fe5:	83 c4 10             	add    $0x10,%esp
  tcp_dummy.padding = 0;
80109fe8:	c6 45 dc 00          	movb   $0x0,-0x24(%ebp)
  tcp_dummy.protocol = IPV4_TYPE_TCP;
80109fec:	c6 45 dd 06          	movb   $0x6,-0x23(%ebp)
  tcp_dummy.tcp_len = H2N_ushort(N2H_ushort(ipv4_p->total_len) - sizeof(struct ipv4_pkt));
80109ff0:	8b 45 e8             	mov    -0x18(%ebp),%eax
80109ff3:	0f b7 40 02          	movzwl 0x2(%eax),%eax
80109ff7:	0f b7 c0             	movzwl %ax,%eax
80109ffa:	83 ec 0c             	sub    $0xc,%esp
80109ffd:	50                   	push   %eax
80109ffe:	e8 b5 f6 ff ff       	call   801096b8 <N2H_ushort>
8010a003:	83 c4 10             	add    $0x10,%esp
8010a006:	83 e8 14             	sub    $0x14,%eax
8010a009:	0f b7 c0             	movzwl %ax,%eax
8010a00c:	83 ec 0c             	sub    $0xc,%esp
8010a00f:	50                   	push   %eax
8010a010:	e8 c5 f6 ff ff       	call   801096da <H2N_ushort>
8010a015:	83 c4 10             	add    $0x10,%esp
8010a018:	66 89 45 de          	mov    %ax,-0x22(%ebp)
  uint chk_sum = 0;
8010a01c:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  uchar *bin = (uchar *)(&tcp_dummy);
8010a023:	8d 45 d4             	lea    -0x2c(%ebp),%eax
8010a026:	89 45 e0             	mov    %eax,-0x20(%ebp)
  for(int i=0;i<6;i++){
8010a029:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
8010a030:	eb 33                	jmp    8010a065 <tcp_chksum+0xc3>
    chk_sum += (bin[i*2]<<8)+bin[i*2+1];
8010a032:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010a035:	01 c0                	add    %eax,%eax
8010a037:	89 c2                	mov    %eax,%edx
8010a039:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010a03c:	01 d0                	add    %edx,%eax
8010a03e:	0f b6 00             	movzbl (%eax),%eax
8010a041:	0f b6 c0             	movzbl %al,%eax
8010a044:	c1 e0 08             	shl    $0x8,%eax
8010a047:	89 c2                	mov    %eax,%edx
8010a049:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010a04c:	01 c0                	add    %eax,%eax
8010a04e:	8d 48 01             	lea    0x1(%eax),%ecx
8010a051:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010a054:	01 c8                	add    %ecx,%eax
8010a056:	0f b6 00             	movzbl (%eax),%eax
8010a059:	0f b6 c0             	movzbl %al,%eax
8010a05c:	01 d0                	add    %edx,%eax
8010a05e:	01 45 f4             	add    %eax,-0xc(%ebp)
  for(int i=0;i<6;i++){
8010a061:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
8010a065:	83 7d f0 05          	cmpl   $0x5,-0x10(%ebp)
8010a069:	7e c7                	jle    8010a032 <tcp_chksum+0x90>
  }

  bin = (uchar *)(tcp_p);
8010a06b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010a06e:	89 45 e0             	mov    %eax,-0x20(%ebp)
  for(int i=0;i<(N2H_ushort(tcp_dummy.tcp_len)/2);i++){
8010a071:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
8010a078:	eb 33                	jmp    8010a0ad <tcp_chksum+0x10b>
    chk_sum += (bin[i*2]<<8)+bin[i*2+1];
8010a07a:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010a07d:	01 c0                	add    %eax,%eax
8010a07f:	89 c2                	mov    %eax,%edx
8010a081:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010a084:	01 d0                	add    %edx,%eax
8010a086:	0f b6 00             	movzbl (%eax),%eax
8010a089:	0f b6 c0             	movzbl %al,%eax
8010a08c:	c1 e0 08             	shl    $0x8,%eax
8010a08f:	89 c2                	mov    %eax,%edx
8010a091:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010a094:	01 c0                	add    %eax,%eax
8010a096:	8d 48 01             	lea    0x1(%eax),%ecx
8010a099:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010a09c:	01 c8                	add    %ecx,%eax
8010a09e:	0f b6 00             	movzbl (%eax),%eax
8010a0a1:	0f b6 c0             	movzbl %al,%eax
8010a0a4:	01 d0                	add    %edx,%eax
8010a0a6:	01 45 f4             	add    %eax,-0xc(%ebp)
  for(int i=0;i<(N2H_ushort(tcp_dummy.tcp_len)/2);i++){
8010a0a9:	83 45 ec 01          	addl   $0x1,-0x14(%ebp)
8010a0ad:	0f b7 45 de          	movzwl -0x22(%ebp),%eax
8010a0b1:	0f b7 c0             	movzwl %ax,%eax
8010a0b4:	83 ec 0c             	sub    $0xc,%esp
8010a0b7:	50                   	push   %eax
8010a0b8:	e8 fb f5 ff ff       	call   801096b8 <N2H_ushort>
8010a0bd:	83 c4 10             	add    $0x10,%esp
8010a0c0:	66 d1 e8             	shr    %ax
8010a0c3:	0f b7 c0             	movzwl %ax,%eax
8010a0c6:	39 45 ec             	cmp    %eax,-0x14(%ebp)
8010a0c9:	7c af                	jl     8010a07a <tcp_chksum+0xd8>
  }
  chk_sum += (chk_sum>>8*2);
8010a0cb:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010a0ce:	c1 e8 10             	shr    $0x10,%eax
8010a0d1:	01 45 f4             	add    %eax,-0xc(%ebp)
  return ~(chk_sum);
8010a0d4:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010a0d7:	f7 d0                	not    %eax
}
8010a0d9:	c9                   	leave  
8010a0da:	c3                   	ret    

8010a0db <tcp_fin>:

void tcp_fin(){
8010a0db:	55                   	push   %ebp
8010a0dc:	89 e5                	mov    %esp,%ebp
  fin_flag =1;
8010a0de:	c7 05 68 71 19 80 01 	movl   $0x1,0x80197168
8010a0e5:	00 00 00 
}
8010a0e8:	90                   	nop
8010a0e9:	5d                   	pop    %ebp
8010a0ea:	c3                   	ret    

8010a0eb <http_proc>:
#include "defs.h"
#include "types.h"
#include "tcp.h"


void http_proc(uint recv, uint recv_size, uint send, uint *send_size){
8010a0eb:	55                   	push   %ebp
8010a0ec:	89 e5                	mov    %esp,%ebp
8010a0ee:	83 ec 18             	sub    $0x18,%esp
  int len;
  len = http_strcpy((char *)send,"HTTP/1.0 200 OK \r\n",0);
8010a0f1:	8b 45 10             	mov    0x10(%ebp),%eax
8010a0f4:	83 ec 04             	sub    $0x4,%esp
8010a0f7:	6a 00                	push   $0x0
8010a0f9:	68 2b c2 10 80       	push   $0x8010c22b
8010a0fe:	50                   	push   %eax
8010a0ff:	e8 65 00 00 00       	call   8010a169 <http_strcpy>
8010a104:	83 c4 10             	add    $0x10,%esp
8010a107:	89 45 f4             	mov    %eax,-0xc(%ebp)
  len += http_strcpy((char *)send,"Content-Type: text/html \r\n",len);
8010a10a:	8b 45 10             	mov    0x10(%ebp),%eax
8010a10d:	83 ec 04             	sub    $0x4,%esp
8010a110:	ff 75 f4             	push   -0xc(%ebp)
8010a113:	68 3e c2 10 80       	push   $0x8010c23e
8010a118:	50                   	push   %eax
8010a119:	e8 4b 00 00 00       	call   8010a169 <http_strcpy>
8010a11e:	83 c4 10             	add    $0x10,%esp
8010a121:	01 45 f4             	add    %eax,-0xc(%ebp)
  len += http_strcpy((char *)send,"\r\nHello World!\r\n",len);
8010a124:	8b 45 10             	mov    0x10(%ebp),%eax
8010a127:	83 ec 04             	sub    $0x4,%esp
8010a12a:	ff 75 f4             	push   -0xc(%ebp)
8010a12d:	68 59 c2 10 80       	push   $0x8010c259
8010a132:	50                   	push   %eax
8010a133:	e8 31 00 00 00       	call   8010a169 <http_strcpy>
8010a138:	83 c4 10             	add    $0x10,%esp
8010a13b:	01 45 f4             	add    %eax,-0xc(%ebp)
  if(len%2 != 0){
8010a13e:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010a141:	83 e0 01             	and    $0x1,%eax
8010a144:	85 c0                	test   %eax,%eax
8010a146:	74 11                	je     8010a159 <http_proc+0x6e>
    char *payload = (char *)send;
8010a148:	8b 45 10             	mov    0x10(%ebp),%eax
8010a14b:	89 45 f0             	mov    %eax,-0x10(%ebp)
    payload[len] = 0;
8010a14e:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010a151:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010a154:	01 d0                	add    %edx,%eax
8010a156:	c6 00 00             	movb   $0x0,(%eax)
  }
  *send_size = len;
8010a159:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010a15c:	8b 45 14             	mov    0x14(%ebp),%eax
8010a15f:	89 10                	mov    %edx,(%eax)
  tcp_fin();
8010a161:	e8 75 ff ff ff       	call   8010a0db <tcp_fin>
}
8010a166:	90                   	nop
8010a167:	c9                   	leave  
8010a168:	c3                   	ret    

8010a169 <http_strcpy>:

int http_strcpy(char *dst,const char *src,int start_index){
8010a169:	55                   	push   %ebp
8010a16a:	89 e5                	mov    %esp,%ebp
8010a16c:	83 ec 10             	sub    $0x10,%esp
  int i = 0;
8010a16f:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while(src[i]){
8010a176:	eb 20                	jmp    8010a198 <http_strcpy+0x2f>
    dst[start_index+i] = src[i];
8010a178:	8b 55 fc             	mov    -0x4(%ebp),%edx
8010a17b:	8b 45 0c             	mov    0xc(%ebp),%eax
8010a17e:	01 d0                	add    %edx,%eax
8010a180:	8b 4d 10             	mov    0x10(%ebp),%ecx
8010a183:	8b 55 fc             	mov    -0x4(%ebp),%edx
8010a186:	01 ca                	add    %ecx,%edx
8010a188:	89 d1                	mov    %edx,%ecx
8010a18a:	8b 55 08             	mov    0x8(%ebp),%edx
8010a18d:	01 ca                	add    %ecx,%edx
8010a18f:	0f b6 00             	movzbl (%eax),%eax
8010a192:	88 02                	mov    %al,(%edx)
    i++;
8010a194:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
  while(src[i]){
8010a198:	8b 55 fc             	mov    -0x4(%ebp),%edx
8010a19b:	8b 45 0c             	mov    0xc(%ebp),%eax
8010a19e:	01 d0                	add    %edx,%eax
8010a1a0:	0f b6 00             	movzbl (%eax),%eax
8010a1a3:	84 c0                	test   %al,%al
8010a1a5:	75 d1                	jne    8010a178 <http_strcpy+0xf>
  }
  return i;
8010a1a7:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
8010a1aa:	c9                   	leave  
8010a1ab:	c3                   	ret    

8010a1ac <ideinit>:
static int disksize;
static uchar *memdisk;

void
ideinit(void)
{
8010a1ac:	55                   	push   %ebp
8010a1ad:	89 e5                	mov    %esp,%ebp
  memdisk = _binary_fs_img_start;
8010a1af:	c7 05 70 71 19 80 c2 	movl   $0x8010f5c2,0x80197170
8010a1b6:	f5 10 80 
  disksize = (uint)_binary_fs_img_size/BSIZE;
8010a1b9:	b8 00 d0 07 00       	mov    $0x7d000,%eax
8010a1be:	c1 e8 09             	shr    $0x9,%eax
8010a1c1:	a3 6c 71 19 80       	mov    %eax,0x8019716c
}
8010a1c6:	90                   	nop
8010a1c7:	5d                   	pop    %ebp
8010a1c8:	c3                   	ret    

8010a1c9 <ideintr>:

// Interrupt handler.
void
ideintr(void)
{
8010a1c9:	55                   	push   %ebp
8010a1ca:	89 e5                	mov    %esp,%ebp
  // no-op
}
8010a1cc:	90                   	nop
8010a1cd:	5d                   	pop    %ebp
8010a1ce:	c3                   	ret    

8010a1cf <iderw>:
// Sync buf with disk.
// If B_DIRTY is set, write buf to disk, clear B_DIRTY, set B_VALID.
// Else if B_VALID is not set, read buf from disk, set B_VALID.
void
iderw(struct buf *b)
{
8010a1cf:	55                   	push   %ebp
8010a1d0:	89 e5                	mov    %esp,%ebp
8010a1d2:	83 ec 18             	sub    $0x18,%esp
  uchar *p;

  if(!holdingsleep(&b->lock))
8010a1d5:	8b 45 08             	mov    0x8(%ebp),%eax
8010a1d8:	83 c0 0c             	add    $0xc,%eax
8010a1db:	83 ec 0c             	sub    $0xc,%esp
8010a1de:	50                   	push   %eax
8010a1df:	e8 2f a7 ff ff       	call   80104913 <holdingsleep>
8010a1e4:	83 c4 10             	add    $0x10,%esp
8010a1e7:	85 c0                	test   %eax,%eax
8010a1e9:	75 0d                	jne    8010a1f8 <iderw+0x29>
    panic("iderw: buf not locked");
8010a1eb:	83 ec 0c             	sub    $0xc,%esp
8010a1ee:	68 6a c2 10 80       	push   $0x8010c26a
8010a1f3:	e8 b1 63 ff ff       	call   801005a9 <panic>
  if((b->flags & (B_VALID|B_DIRTY)) == B_VALID)
8010a1f8:	8b 45 08             	mov    0x8(%ebp),%eax
8010a1fb:	8b 00                	mov    (%eax),%eax
8010a1fd:	83 e0 06             	and    $0x6,%eax
8010a200:	83 f8 02             	cmp    $0x2,%eax
8010a203:	75 0d                	jne    8010a212 <iderw+0x43>
    panic("iderw: nothing to do");
8010a205:	83 ec 0c             	sub    $0xc,%esp
8010a208:	68 80 c2 10 80       	push   $0x8010c280
8010a20d:	e8 97 63 ff ff       	call   801005a9 <panic>
  if(b->dev != 1)
8010a212:	8b 45 08             	mov    0x8(%ebp),%eax
8010a215:	8b 40 04             	mov    0x4(%eax),%eax
8010a218:	83 f8 01             	cmp    $0x1,%eax
8010a21b:	74 0d                	je     8010a22a <iderw+0x5b>
    panic("iderw: request not for disk 1");
8010a21d:	83 ec 0c             	sub    $0xc,%esp
8010a220:	68 95 c2 10 80       	push   $0x8010c295
8010a225:	e8 7f 63 ff ff       	call   801005a9 <panic>
  if(b->blockno >= disksize)
8010a22a:	8b 45 08             	mov    0x8(%ebp),%eax
8010a22d:	8b 40 08             	mov    0x8(%eax),%eax
8010a230:	8b 15 6c 71 19 80    	mov    0x8019716c,%edx
8010a236:	39 d0                	cmp    %edx,%eax
8010a238:	72 0d                	jb     8010a247 <iderw+0x78>
    panic("iderw: block out of range");
8010a23a:	83 ec 0c             	sub    $0xc,%esp
8010a23d:	68 b3 c2 10 80       	push   $0x8010c2b3
8010a242:	e8 62 63 ff ff       	call   801005a9 <panic>

  p = memdisk + b->blockno*BSIZE;
8010a247:	8b 15 70 71 19 80    	mov    0x80197170,%edx
8010a24d:	8b 45 08             	mov    0x8(%ebp),%eax
8010a250:	8b 40 08             	mov    0x8(%eax),%eax
8010a253:	c1 e0 09             	shl    $0x9,%eax
8010a256:	01 d0                	add    %edx,%eax
8010a258:	89 45 f4             	mov    %eax,-0xc(%ebp)

  if(b->flags & B_DIRTY){
8010a25b:	8b 45 08             	mov    0x8(%ebp),%eax
8010a25e:	8b 00                	mov    (%eax),%eax
8010a260:	83 e0 04             	and    $0x4,%eax
8010a263:	85 c0                	test   %eax,%eax
8010a265:	74 2b                	je     8010a292 <iderw+0xc3>
    b->flags &= ~B_DIRTY;
8010a267:	8b 45 08             	mov    0x8(%ebp),%eax
8010a26a:	8b 00                	mov    (%eax),%eax
8010a26c:	83 e0 fb             	and    $0xfffffffb,%eax
8010a26f:	89 c2                	mov    %eax,%edx
8010a271:	8b 45 08             	mov    0x8(%ebp),%eax
8010a274:	89 10                	mov    %edx,(%eax)
    memmove(p, b->data, BSIZE);
8010a276:	8b 45 08             	mov    0x8(%ebp),%eax
8010a279:	83 c0 5c             	add    $0x5c,%eax
8010a27c:	83 ec 04             	sub    $0x4,%esp
8010a27f:	68 00 02 00 00       	push   $0x200
8010a284:	50                   	push   %eax
8010a285:	ff 75 f4             	push   -0xc(%ebp)
8010a288:	e8 4c aa ff ff       	call   80104cd9 <memmove>
8010a28d:	83 c4 10             	add    $0x10,%esp
8010a290:	eb 1a                	jmp    8010a2ac <iderw+0xdd>
  } else
    memmove(b->data, p, BSIZE);
8010a292:	8b 45 08             	mov    0x8(%ebp),%eax
8010a295:	83 c0 5c             	add    $0x5c,%eax
8010a298:	83 ec 04             	sub    $0x4,%esp
8010a29b:	68 00 02 00 00       	push   $0x200
8010a2a0:	ff 75 f4             	push   -0xc(%ebp)
8010a2a3:	50                   	push   %eax
8010a2a4:	e8 30 aa ff ff       	call   80104cd9 <memmove>
8010a2a9:	83 c4 10             	add    $0x10,%esp
  b->flags |= B_VALID;
8010a2ac:	8b 45 08             	mov    0x8(%ebp),%eax
8010a2af:	8b 00                	mov    (%eax),%eax
8010a2b1:	83 c8 02             	or     $0x2,%eax
8010a2b4:	89 c2                	mov    %eax,%edx
8010a2b6:	8b 45 08             	mov    0x8(%ebp),%eax
8010a2b9:	89 10                	mov    %edx,(%eax)
}
8010a2bb:	90                   	nop
8010a2bc:	c9                   	leave  
8010a2bd:	c3                   	ret    
