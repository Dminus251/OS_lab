
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
8010005a:	bc b0 b1 11 80       	mov    $0x8011b1b0,%esp
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
8010006f:	68 c0 a6 10 80       	push   $0x8010a6c0
80100074:	68 00 00 11 80       	push   $0x80110000
80100079:	e8 fd 4d 00 00       	call   80104e7b <initlock>
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
801000bd:	68 c7 a6 10 80       	push   $0x8010a6c7
801000c2:	50                   	push   %eax
801000c3:	e8 56 4c 00 00       	call   80104d1e <initsleeplock>
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
80100101:	e8 97 4d 00 00       	call   80104e9d <acquire>
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
80100140:	e8 c6 4d 00 00       	call   80104f0b <release>
80100145:	83 c4 10             	add    $0x10,%esp
      acquiresleep(&b->lock);
80100148:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010014b:	83 c0 0c             	add    $0xc,%eax
8010014e:	83 ec 0c             	sub    $0xc,%esp
80100151:	50                   	push   %eax
80100152:	e8 03 4c 00 00       	call   80104d5a <acquiresleep>
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
801001c1:	e8 45 4d 00 00       	call   80104f0b <release>
801001c6:	83 c4 10             	add    $0x10,%esp
      acquiresleep(&b->lock);
801001c9:	8b 45 f4             	mov    -0xc(%ebp),%eax
801001cc:	83 c0 0c             	add    $0xc,%eax
801001cf:	83 ec 0c             	sub    $0xc,%esp
801001d2:	50                   	push   %eax
801001d3:	e8 82 4b 00 00       	call   80104d5a <acquiresleep>
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
801001f5:	68 ce a6 10 80       	push   $0x8010a6ce
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
8010024a:	e8 bd 4b 00 00       	call   80104e0c <holdingsleep>
8010024f:	83 c4 10             	add    $0x10,%esp
80100252:	85 c0                	test   %eax,%eax
80100254:	75 0d                	jne    80100263 <bwrite+0x29>
    panic("bwrite");
80100256:	83 ec 0c             	sub    $0xc,%esp
80100259:	68 df a6 10 80       	push   $0x8010a6df
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
80100293:	e8 74 4b 00 00       	call   80104e0c <holdingsleep>
80100298:	83 c4 10             	add    $0x10,%esp
8010029b:	85 c0                	test   %eax,%eax
8010029d:	75 0d                	jne    801002ac <brelse+0x29>
    panic("brelse");
8010029f:	83 ec 0c             	sub    $0xc,%esp
801002a2:	68 e6 a6 10 80       	push   $0x8010a6e6
801002a7:	e8 fd 02 00 00       	call   801005a9 <panic>

  releasesleep(&b->lock);
801002ac:	8b 45 08             	mov    0x8(%ebp),%eax
801002af:	83 c0 0c             	add    $0xc,%eax
801002b2:	83 ec 0c             	sub    $0xc,%esp
801002b5:	50                   	push   %eax
801002b6:	e8 03 4b 00 00       	call   80104dbe <releasesleep>
801002bb:	83 c4 10             	add    $0x10,%esp

  acquire(&bcache.lock);
801002be:	83 ec 0c             	sub    $0xc,%esp
801002c1:	68 00 00 11 80       	push   $0x80110000
801002c6:	e8 d2 4b 00 00       	call   80104e9d <acquire>
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
80100336:	e8 d0 4b 00 00       	call   80104f0b <release>
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
80100410:	e8 88 4a 00 00       	call   80104e9d <acquire>
80100415:	83 c4 10             	add    $0x10,%esp

  if (fmt == 0)
80100418:	8b 45 08             	mov    0x8(%ebp),%eax
8010041b:	85 c0                	test   %eax,%eax
8010041d:	75 0d                	jne    8010042c <cprintf+0x38>
    panic("null fmt");
8010041f:	83 ec 0c             	sub    $0xc,%esp
80100422:	68 ed a6 10 80       	push   $0x8010a6ed
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
80100510:	c7 45 ec f6 a6 10 80 	movl   $0x8010a6f6,-0x14(%ebp)
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
8010059e:	e8 68 49 00 00       	call   80104f0b <release>
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
801005c7:	68 fd a6 10 80       	push   $0x8010a6fd
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
801005e6:	68 11 a7 10 80       	push   $0x8010a711
801005eb:	e8 04 fe ff ff       	call   801003f4 <cprintf>
801005f0:	83 c4 10             	add    $0x10,%esp
  getcallerpcs(&s, pcs);
801005f3:	83 ec 08             	sub    $0x8,%esp
801005f6:	8d 45 cc             	lea    -0x34(%ebp),%eax
801005f9:	50                   	push   %eax
801005fa:	8d 45 08             	lea    0x8(%ebp),%eax
801005fd:	50                   	push   %eax
801005fe:	e8 5a 49 00 00       	call   80104f5d <getcallerpcs>
80100603:	83 c4 10             	add    $0x10,%esp
  for(i=0; i<10; i++)
80100606:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
8010060d:	eb 1c                	jmp    8010062b <panic+0x82>
    cprintf(" %p", pcs[i]);
8010060f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100612:	8b 44 85 cc          	mov    -0x34(%ebp,%eax,4),%eax
80100616:	83 ec 08             	sub    $0x8,%esp
80100619:	50                   	push   %eax
8010061a:	68 13 a7 10 80       	push   $0x8010a713
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
801006a0:	e8 93 7f 00 00       	call   80108638 <graphic_scroll_up>
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
801006f3:	e8 40 7f 00 00       	call   80108638 <graphic_scroll_up>
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
80100757:	e8 47 7f 00 00       	call   801086a3 <font_render>
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
80100793:	e8 17 63 00 00       	call   80106aaf <uartputc>
80100798:	83 c4 10             	add    $0x10,%esp
8010079b:	83 ec 0c             	sub    $0xc,%esp
8010079e:	6a 20                	push   $0x20
801007a0:	e8 0a 63 00 00       	call   80106aaf <uartputc>
801007a5:	83 c4 10             	add    $0x10,%esp
801007a8:	83 ec 0c             	sub    $0xc,%esp
801007ab:	6a 08                	push   $0x8
801007ad:	e8 fd 62 00 00       	call   80106aaf <uartputc>
801007b2:	83 c4 10             	add    $0x10,%esp
801007b5:	eb 0e                	jmp    801007c5 <consputc+0x56>
  } else {
    uartputc(c);
801007b7:	83 ec 0c             	sub    $0xc,%esp
801007ba:	ff 75 08             	push   0x8(%ebp)
801007bd:	e8 ed 62 00 00       	call   80106aaf <uartputc>
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
801007eb:	e8 ad 46 00 00       	call   80104e9d <acquire>
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
8010093f:	e8 1f 42 00 00       	call   80104b63 <wakeup>
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
80100962:	e8 a4 45 00 00       	call   80104f0b <release>
80100967:	83 c4 10             	add    $0x10,%esp
  if(doprocdump) {
8010096a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
8010096e:	74 05                	je     80100975 <consoleintr+0x19f>
    procdump();  // now call procdump() wo. cons.lock held
80100970:	e8 ac 42 00 00       	call   80104c21 <procdump>
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
8010099a:	e8 fe 44 00 00       	call   80104e9d <acquire>
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
801009bb:	e8 4b 45 00 00       	call   80104f0b <release>
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
801009e8:	e8 8c 40 00 00       	call   80104a79 <sleep>
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
80100a66:	e8 a0 44 00 00       	call   80104f0b <release>
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
80100aa2:	e8 f6 43 00 00       	call   80104e9d <acquire>
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
80100ae4:	e8 22 44 00 00       	call   80104f0b <release>
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
80100b12:	68 17 a7 10 80       	push   $0x8010a717
80100b17:	68 00 4a 11 80       	push   $0x80114a00
80100b1c:	e8 5a 43 00 00       	call   80104e7b <initlock>
80100b21:	83 c4 10             	add    $0x10,%esp

  devsw[CONSOLE].write = consolewrite;
80100b24:	c7 05 4c 4a 11 80 86 	movl   $0x80100a86,0x80114a4c
80100b2b:	0a 10 80 
  devsw[CONSOLE].read = consoleread;
80100b2e:	c7 05 48 4a 11 80 78 	movl   $0x80100978,0x80114a48
80100b35:	09 10 80 
  
  char *p;
  for(p="Starting XV6_UEFI...\n"; *p; p++)
80100b38:	c7 45 f4 1f a7 10 80 	movl   $0x8010a71f,-0xc(%ebp)
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
80100bb5:	68 35 a7 10 80       	push   $0x8010a735
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
80100c11:	e8 95 6e 00 00       	call   80107aab <setupkvm>
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
80100cb7:	e8 e8 71 00 00       	call   80107ea4 <allocuvm>
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
80100cfd:	e8 d5 70 00 00       	call   80107dd7 <loaduvm>
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
80100d6c:	e8 33 71 00 00       	call   80107ea4 <allocuvm>
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
80100d90:	e8 71 73 00 00       	call   80108106 <clearpteu>
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
80100dc9:	e8 93 45 00 00       	call   80105361 <strlen>
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
80100df6:	e8 66 45 00 00       	call   80105361 <strlen>
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
80100e1c:	e8 84 74 00 00       	call   801082a5 <copyout>
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
80100eb8:	e8 e8 73 00 00       	call   801082a5 <copyout>
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
80100f06:	e8 0b 44 00 00       	call   80105316 <safestrcpy>
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
80100f49:	e8 7a 6c 00 00       	call   80107bc8 <switchuvm>
80100f4e:	83 c4 10             	add    $0x10,%esp
  freevm(oldpgdir);
80100f51:	83 ec 0c             	sub    $0xc,%esp
80100f54:	ff 75 cc             	push   -0x34(%ebp)
80100f57:	e8 11 71 00 00       	call   8010806d <freevm>
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
80100f97:	e8 d1 70 00 00       	call   8010806d <freevm>
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
80100fc8:	68 41 a7 10 80       	push   $0x8010a741
80100fcd:	68 a0 4a 11 80       	push   $0x80114aa0
80100fd2:	e8 a4 3e 00 00       	call   80104e7b <initlock>
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
80100feb:	e8 ad 3e 00 00       	call   80104e9d <acquire>
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
80101018:	e8 ee 3e 00 00       	call   80104f0b <release>
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
8010103b:	e8 cb 3e 00 00       	call   80104f0b <release>
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
80101058:	e8 40 3e 00 00       	call   80104e9d <acquire>
8010105d:	83 c4 10             	add    $0x10,%esp
  if(f->ref < 1)
80101060:	8b 45 08             	mov    0x8(%ebp),%eax
80101063:	8b 40 04             	mov    0x4(%eax),%eax
80101066:	85 c0                	test   %eax,%eax
80101068:	7f 0d                	jg     80101077 <filedup+0x2d>
    panic("filedup");
8010106a:	83 ec 0c             	sub    $0xc,%esp
8010106d:	68 48 a7 10 80       	push   $0x8010a748
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
8010108e:	e8 78 3e 00 00       	call   80104f0b <release>
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
801010a9:	e8 ef 3d 00 00       	call   80104e9d <acquire>
801010ae:	83 c4 10             	add    $0x10,%esp
  if(f->ref < 1)
801010b1:	8b 45 08             	mov    0x8(%ebp),%eax
801010b4:	8b 40 04             	mov    0x4(%eax),%eax
801010b7:	85 c0                	test   %eax,%eax
801010b9:	7f 0d                	jg     801010c8 <fileclose+0x2d>
    panic("fileclose");
801010bb:	83 ec 0c             	sub    $0xc,%esp
801010be:	68 50 a7 10 80       	push   $0x8010a750
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
801010e9:	e8 1d 3e 00 00       	call   80104f0b <release>
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
80101137:	e8 cf 3d 00 00       	call   80104f0b <release>
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
80101286:	68 5a a7 10 80       	push   $0x8010a75a
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
80101389:	68 63 a7 10 80       	push   $0x8010a763
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
801013bf:	68 73 a7 10 80       	push   $0x8010a773
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
801013f7:	e8 d6 3d 00 00       	call   801051d2 <memmove>
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
8010143d:	e8 d1 3c 00 00       	call   80105113 <memset>
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
8010159c:	68 80 a7 10 80       	push   $0x8010a780
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
80101627:	68 96 a7 10 80       	push   $0x8010a796
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
8010168b:	68 a9 a7 10 80       	push   $0x8010a7a9
80101690:	68 60 54 11 80       	push   $0x80115460
80101695:	e8 e1 37 00 00       	call   80104e7b <initlock>
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
801016c1:	68 b0 a7 10 80       	push   $0x8010a7b0
801016c6:	50                   	push   %eax
801016c7:	e8 52 36 00 00       	call   80104d1e <initsleeplock>
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
80101720:	68 b8 a7 10 80       	push   $0x8010a7b8
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
80101799:	e8 75 39 00 00       	call   80105113 <memset>
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
80101801:	68 0b a8 10 80       	push   $0x8010a80b
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
801018a7:	e8 26 39 00 00       	call   801051d2 <memmove>
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
801018dc:	e8 bc 35 00 00       	call   80104e9d <acquire>
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
8010192a:	e8 dc 35 00 00       	call   80104f0b <release>
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
80101966:	68 1d a8 10 80       	push   $0x8010a81d
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
801019a3:	e8 63 35 00 00       	call   80104f0b <release>
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
801019be:	e8 da 34 00 00       	call   80104e9d <acquire>
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
801019dd:	e8 29 35 00 00       	call   80104f0b <release>
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
80101a03:	68 2d a8 10 80       	push   $0x8010a82d
80101a08:	e8 9c eb ff ff       	call   801005a9 <panic>

  acquiresleep(&ip->lock);
80101a0d:	8b 45 08             	mov    0x8(%ebp),%eax
80101a10:	83 c0 0c             	add    $0xc,%eax
80101a13:	83 ec 0c             	sub    $0xc,%esp
80101a16:	50                   	push   %eax
80101a17:	e8 3e 33 00 00       	call   80104d5a <acquiresleep>
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
80101ac1:	e8 0c 37 00 00       	call   801051d2 <memmove>
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
80101af0:	68 33 a8 10 80       	push   $0x8010a833
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
80101b13:	e8 f4 32 00 00       	call   80104e0c <holdingsleep>
80101b18:	83 c4 10             	add    $0x10,%esp
80101b1b:	85 c0                	test   %eax,%eax
80101b1d:	74 0a                	je     80101b29 <iunlock+0x2c>
80101b1f:	8b 45 08             	mov    0x8(%ebp),%eax
80101b22:	8b 40 08             	mov    0x8(%eax),%eax
80101b25:	85 c0                	test   %eax,%eax
80101b27:	7f 0d                	jg     80101b36 <iunlock+0x39>
    panic("iunlock");
80101b29:	83 ec 0c             	sub    $0xc,%esp
80101b2c:	68 42 a8 10 80       	push   $0x8010a842
80101b31:	e8 73 ea ff ff       	call   801005a9 <panic>

  releasesleep(&ip->lock);
80101b36:	8b 45 08             	mov    0x8(%ebp),%eax
80101b39:	83 c0 0c             	add    $0xc,%eax
80101b3c:	83 ec 0c             	sub    $0xc,%esp
80101b3f:	50                   	push   %eax
80101b40:	e8 79 32 00 00       	call   80104dbe <releasesleep>
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
80101b5b:	e8 fa 31 00 00       	call   80104d5a <acquiresleep>
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
80101b81:	e8 17 33 00 00       	call   80104e9d <acquire>
80101b86:	83 c4 10             	add    $0x10,%esp
    int r = ip->ref;
80101b89:	8b 45 08             	mov    0x8(%ebp),%eax
80101b8c:	8b 40 08             	mov    0x8(%eax),%eax
80101b8f:	89 45 f4             	mov    %eax,-0xc(%ebp)
    release(&icache.lock);
80101b92:	83 ec 0c             	sub    $0xc,%esp
80101b95:	68 60 54 11 80       	push   $0x80115460
80101b9a:	e8 6c 33 00 00       	call   80104f0b <release>
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
80101be1:	e8 d8 31 00 00       	call   80104dbe <releasesleep>
80101be6:	83 c4 10             	add    $0x10,%esp

  acquire(&icache.lock);
80101be9:	83 ec 0c             	sub    $0xc,%esp
80101bec:	68 60 54 11 80       	push   $0x80115460
80101bf1:	e8 a7 32 00 00       	call   80104e9d <acquire>
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
80101c10:	e8 f6 32 00 00       	call   80104f0b <release>
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
80101d54:	68 4a a8 10 80       	push   $0x8010a84a
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
80101ff2:	e8 db 31 00 00       	call   801051d2 <memmove>
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
80102142:	e8 8b 30 00 00       	call   801051d2 <memmove>
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
801021c2:	e8 a1 30 00 00       	call   80105268 <strncmp>
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
801021e2:	68 5d a8 10 80       	push   $0x8010a85d
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
80102211:	68 6f a8 10 80       	push   $0x8010a86f
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
801022e6:	68 7e a8 10 80       	push   $0x8010a87e
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
80102321:	e8 98 2f 00 00       	call   801052be <strncpy>
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
8010234d:	68 8b a8 10 80       	push   $0x8010a88b
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
801023bf:	e8 0e 2e 00 00       	call   801051d2 <memmove>
801023c4:	83 c4 10             	add    $0x10,%esp
801023c7:	eb 26                	jmp    801023ef <skipelem+0x91>
  else {
    memmove(name, s, len);
801023c9:	8b 45 f0             	mov    -0x10(%ebp),%eax
801023cc:	83 ec 04             	sub    $0x4,%esp
801023cf:	50                   	push   %eax
801023d0:	ff 75 f4             	push   -0xc(%ebp)
801023d3:	ff 75 0c             	push   0xc(%ebp)
801023d6:	e8 f7 2d 00 00       	call   801051d2 <memmove>
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
8010262c:	68 93 a8 10 80       	push   $0x8010a893
80102631:	68 c0 70 11 80       	push   $0x801170c0
80102636:	e8 40 28 00 00       	call   80104e7b <initlock>
8010263b:	83 c4 10             	add    $0x10,%esp
  ioapicenable(IRQ_IDE, ncpu - 1);
8010263e:	a1 80 9e 11 80       	mov    0x80119e80,%eax
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
801026d3:	68 97 a8 10 80       	push   $0x8010a897
801026d8:	e8 cc de ff ff       	call   801005a9 <panic>
  if(b->blockno >= FSSIZE)
801026dd:	8b 45 08             	mov    0x8(%ebp),%eax
801026e0:	8b 40 08             	mov    0x8(%eax),%eax
801026e3:	3d e7 03 00 00       	cmp    $0x3e7,%eax
801026e8:	76 0d                	jbe    801026f7 <idestart+0x33>
    panic("incorrect blockno");
801026ea:	83 ec 0c             	sub    $0xc,%esp
801026ed:	68 a0 a8 10 80       	push   $0x8010a8a0
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
80102740:	68 97 a8 10 80       	push   $0x8010a897
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
80102864:	e8 34 26 00 00       	call   80104e9d <acquire>
80102869:	83 c4 10             	add    $0x10,%esp

  if((b = idequeue) == 0){
8010286c:	a1 f4 70 11 80       	mov    0x801170f4,%eax
80102871:	89 45 f4             	mov    %eax,-0xc(%ebp)
80102874:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80102878:	75 15                	jne    8010288f <ideintr+0x39>
    release(&idelock);
8010287a:	83 ec 0c             	sub    $0xc,%esp
8010287d:	68 c0 70 11 80       	push   $0x801170c0
80102882:	e8 84 26 00 00       	call   80104f0b <release>
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
801028f7:	e8 67 22 00 00       	call   80104b63 <wakeup>
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
80102921:	e8 e5 25 00 00       	call   80104f0b <release>
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
80102942:	68 b2 a8 10 80       	push   $0x8010a8b2
80102947:	e8 a8 da ff ff       	call   801003f4 <cprintf>
8010294c:	83 c4 10             	add    $0x10,%esp
#endif
  if(!holdingsleep(&b->lock))
8010294f:	8b 45 08             	mov    0x8(%ebp),%eax
80102952:	83 c0 0c             	add    $0xc,%eax
80102955:	83 ec 0c             	sub    $0xc,%esp
80102958:	50                   	push   %eax
80102959:	e8 ae 24 00 00       	call   80104e0c <holdingsleep>
8010295e:	83 c4 10             	add    $0x10,%esp
80102961:	85 c0                	test   %eax,%eax
80102963:	75 0d                	jne    80102972 <iderw+0x47>
    panic("iderw: buf not locked");
80102965:	83 ec 0c             	sub    $0xc,%esp
80102968:	68 cc a8 10 80       	push   $0x8010a8cc
8010296d:	e8 37 dc ff ff       	call   801005a9 <panic>
  if((b->flags & (B_VALID|B_DIRTY)) == B_VALID)
80102972:	8b 45 08             	mov    0x8(%ebp),%eax
80102975:	8b 00                	mov    (%eax),%eax
80102977:	83 e0 06             	and    $0x6,%eax
8010297a:	83 f8 02             	cmp    $0x2,%eax
8010297d:	75 0d                	jne    8010298c <iderw+0x61>
    panic("iderw: nothing to do");
8010297f:	83 ec 0c             	sub    $0xc,%esp
80102982:	68 e2 a8 10 80       	push   $0x8010a8e2
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
801029a2:	68 f7 a8 10 80       	push   $0x8010a8f7
801029a7:	e8 fd db ff ff       	call   801005a9 <panic>

  acquire(&idelock);  //DOC:acquire-lock
801029ac:	83 ec 0c             	sub    $0xc,%esp
801029af:	68 c0 70 11 80       	push   $0x801170c0
801029b4:	e8 e4 24 00 00       	call   80104e9d <acquire>
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
80102a10:	e8 64 20 00 00       	call   80104a79 <sleep>
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
80102a2d:	e8 d9 24 00 00       	call   80104f0b <release>
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
80102a9f:	0f b6 05 84 9e 11 80 	movzbl 0x80119e84,%eax
80102aa6:	0f b6 c0             	movzbl %al,%eax
80102aa9:	39 45 ec             	cmp    %eax,-0x14(%ebp)
80102aac:	74 10                	je     80102abe <ioapicinit+0x54>
    cprintf("ioapicinit: id isn't equal to ioapicid; not a MP\n");
80102aae:	83 ec 0c             	sub    $0xc,%esp
80102ab1:	68 18 a9 10 80       	push   $0x8010a918
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
80102b58:	68 4a a9 10 80       	push   $0x8010a94a
80102b5d:	68 00 71 11 80       	push   $0x80117100
80102b62:	e8 14 23 00 00       	call   80104e7b <initlock>
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
80102c17:	68 4f a9 10 80       	push   $0x8010a94f
80102c1c:	e8 88 d9 ff ff       	call   801005a9 <panic>

  // Fill with junk to catch dangling refs.
  memset(v, 1, PGSIZE);
80102c21:	83 ec 04             	sub    $0x4,%esp
80102c24:	68 00 10 00 00       	push   $0x1000
80102c29:	6a 01                	push   $0x1
80102c2b:	ff 75 08             	push   0x8(%ebp)
80102c2e:	e8 e0 24 00 00       	call   80105113 <memset>
80102c33:	83 c4 10             	add    $0x10,%esp

  if(kmem.use_lock)
80102c36:	a1 34 71 11 80       	mov    0x80117134,%eax
80102c3b:	85 c0                	test   %eax,%eax
80102c3d:	74 10                	je     80102c4f <kfree+0x65>
    acquire(&kmem.lock);
80102c3f:	83 ec 0c             	sub    $0xc,%esp
80102c42:	68 00 71 11 80       	push   $0x80117100
80102c47:	e8 51 22 00 00       	call   80104e9d <acquire>
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
80102c79:	e8 8d 22 00 00       	call   80104f0b <release>
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
80102c9b:	e8 fd 21 00 00       	call   80104e9d <acquire>
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
80102ccc:	e8 3a 22 00 00       	call   80104f0b <release>
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
801031f6:	e8 7f 1f 00 00       	call   8010517a <memcmp>
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
8010330a:	68 55 a9 10 80       	push   $0x8010a955
8010330f:	68 60 71 11 80       	push   $0x80117160
80103314:	e8 62 1b 00 00       	call   80104e7b <initlock>
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
801033bf:	e8 0e 1e 00 00       	call   801051d2 <memmove>
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
8010352e:	e8 6a 19 00 00       	call   80104e9d <acquire>
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
8010354c:	e8 28 15 00 00       	call   80104a79 <sleep>
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
80103581:	e8 f3 14 00 00       	call   80104a79 <sleep>
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
801035a0:	e8 66 19 00 00       	call   80104f0b <release>
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
801035c1:	e8 d7 18 00 00       	call   80104e9d <acquire>
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
801035e2:	68 59 a9 10 80       	push   $0x8010a959
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
80103610:	e8 4e 15 00 00       	call   80104b63 <wakeup>
80103615:	83 c4 10             	add    $0x10,%esp
  }
  release(&log.lock);
80103618:	83 ec 0c             	sub    $0xc,%esp
8010361b:	68 60 71 11 80       	push   $0x80117160
80103620:	e8 e6 18 00 00       	call   80104f0b <release>
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
8010363b:	e8 5d 18 00 00       	call   80104e9d <acquire>
80103640:	83 c4 10             	add    $0x10,%esp
    log.committing = 0;
80103643:	c7 05 a0 71 11 80 00 	movl   $0x0,0x801171a0
8010364a:	00 00 00 
    wakeup(&log);
8010364d:	83 ec 0c             	sub    $0xc,%esp
80103650:	68 60 71 11 80       	push   $0x80117160
80103655:	e8 09 15 00 00       	call   80104b63 <wakeup>
8010365a:	83 c4 10             	add    $0x10,%esp
    release(&log.lock);
8010365d:	83 ec 0c             	sub    $0xc,%esp
80103660:	68 60 71 11 80       	push   $0x80117160
80103665:	e8 a1 18 00 00       	call   80104f0b <release>
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
801036e1:	e8 ec 1a 00 00       	call   801051d2 <memmove>
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
8010377e:	68 68 a9 10 80       	push   $0x8010a968
80103783:	e8 21 ce ff ff       	call   801005a9 <panic>
  if (log.outstanding < 1)
80103788:	a1 9c 71 11 80       	mov    0x8011719c,%eax
8010378d:	85 c0                	test   %eax,%eax
8010378f:	7f 0d                	jg     8010379e <log_write+0x45>
    panic("log_write outside of trans");
80103791:	83 ec 0c             	sub    $0xc,%esp
80103794:	68 7e a9 10 80       	push   $0x8010a97e
80103799:	e8 0b ce ff ff       	call   801005a9 <panic>

  acquire(&log.lock);
8010379e:	83 ec 0c             	sub    $0xc,%esp
801037a1:	68 60 71 11 80       	push   $0x80117160
801037a6:	e8 f2 16 00 00       	call   80104e9d <acquire>
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
80103824:	e8 e2 16 00 00       	call   80104f0b <release>
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
8010385a:	e8 1e 4d 00 00       	call   8010857d <graphic_init>
  kinit1(end, P2V(4*1024*1024)); // phys page allocator
8010385f:	83 ec 08             	sub    $0x8,%esp
80103862:	68 00 00 40 80       	push   $0x80400000
80103867:	68 00 c0 11 80       	push   $0x8011c000
8010386c:	e8 de f2 ff ff       	call   80102b4f <kinit1>
80103871:	83 c4 10             	add    $0x10,%esp
  kvmalloc();      // kernel page table
80103874:	e8 1e 43 00 00       	call   80107b97 <kvmalloc>
  mpinit_uefi();
80103879:	e8 c5 4a 00 00       	call   80108343 <mpinit_uefi>
  lapicinit();     // interrupt controller
8010387e:	e8 3c f6 ff ff       	call   80102ebf <lapicinit>
  seginit();       // segment descriptors
80103883:	e8 a7 3d 00 00       	call   8010762f <seginit>
  picinit();    // disable pic
80103888:	e8 9d 01 00 00       	call   80103a2a <picinit>
  ioapicinit();    // another interrupt controller
8010388d:	e8 d8 f1 ff ff       	call   80102a6a <ioapicinit>
  consoleinit();   // console hardware
80103892:	e8 68 d2 ff ff       	call   80100aff <consoleinit>
  uartinit();      // serial port
80103897:	e8 2c 31 00 00       	call   801069c8 <uartinit>
  pinit();         // process table
8010389c:	e8 c2 05 00 00       	call   80103e63 <pinit>
  tvinit();        // trap vectors
801038a1:	e8 da 2c 00 00       	call   80106580 <tvinit>
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
801038cf:	e8 02 4f 00 00       	call   801087d6 <pci_init>
  arp_scan();
801038d4:	e8 39 5c 00 00       	call   80109512 <arp_scan>
  //i8254_recv();
  userinit();      // first user process
801038d9:	e8 66 07 00 00       	call   80104044 <userinit>

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
801038e9:	e8 c1 42 00 00       	call   80107baf <switchkvm>
  seginit();
801038ee:	e8 3c 3d 00 00       	call   8010762f <seginit>
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
80103915:	68 99 a9 10 80       	push   $0x8010a999
8010391a:	e8 d5 ca ff ff       	call   801003f4 <cprintf>
8010391f:	83 c4 10             	add    $0x10,%esp
  idtinit();       // load idt register
80103922:	e8 cf 2d 00 00       	call   801066f6 <idtinit>
  xchg(&(mycpu()->started), 1); // tell startothers() we're up
80103927:	e8 70 05 00 00       	call   80103e9c <mycpu>
8010392c:	05 a0 00 00 00       	add    $0xa0,%eax
80103931:	83 ec 08             	sub    $0x8,%esp
80103934:	6a 01                	push   $0x1
80103936:	50                   	push   %eax
80103937:	e8 f3 fe ff ff       	call   8010382f <xchg>
8010393c:	83 c4 10             	add    $0x10,%esp
  scheduler();     // start running processes
8010393f:	e8 41 0f 00 00       	call   80104885 <scheduler>

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
8010395a:	68 38 f5 10 80       	push   $0x8010f538
8010395f:	ff 75 f0             	push   -0x10(%ebp)
80103962:	e8 6b 18 00 00       	call   801051d2 <memmove>
80103967:	83 c4 10             	add    $0x10,%esp

  for(c = cpus; c < cpus+ncpu; c++){
8010396a:	c7 45 f4 c0 9b 11 80 	movl   $0x80119bc0,-0xc(%ebp)
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
801039ec:	a1 80 9e 11 80       	mov    0x80119e80,%eax
801039f1:	69 c0 b0 00 00 00    	imul   $0xb0,%eax,%eax
801039f7:	05 c0 9b 11 80       	add    $0x80119bc0,%eax
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
80103aeb:	68 ad a9 10 80       	push   $0x8010a9ad
80103af0:	50                   	push   %eax
80103af1:	e8 85 13 00 00       	call   80104e7b <initlock>
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
80103bb0:	e8 e8 12 00 00       	call   80104e9d <acquire>
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
80103bd7:	e8 87 0f 00 00       	call   80104b63 <wakeup>
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
80103bfa:	e8 64 0f 00 00       	call   80104b63 <wakeup>
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
80103c23:	e8 e3 12 00 00       	call   80104f0b <release>
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
80103c42:	e8 c4 12 00 00       	call   80104f0b <release>
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
80103c5c:	e8 3c 12 00 00       	call   80104e9d <acquire>
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
80103c90:	e8 76 12 00 00       	call   80104f0b <release>
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
80103cae:	e8 b0 0e 00 00       	call   80104b63 <wakeup>
80103cb3:	83 c4 10             	add    $0x10,%esp
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
80103cb6:	8b 45 08             	mov    0x8(%ebp),%eax
80103cb9:	8b 55 08             	mov    0x8(%ebp),%edx
80103cbc:	81 c2 38 02 00 00    	add    $0x238,%edx
80103cc2:	83 ec 08             	sub    $0x8,%esp
80103cc5:	50                   	push   %eax
80103cc6:	52                   	push   %edx
80103cc7:	e8 ad 0d 00 00       	call   80104a79 <sleep>
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
80103d31:	e8 2d 0e 00 00       	call   80104b63 <wakeup>
80103d36:	83 c4 10             	add    $0x10,%esp
  release(&p->lock);
80103d39:	8b 45 08             	mov    0x8(%ebp),%eax
80103d3c:	83 ec 0c             	sub    $0xc,%esp
80103d3f:	50                   	push   %eax
80103d40:	e8 c6 11 00 00       	call   80104f0b <release>
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
80103d5d:	e8 3b 11 00 00       	call   80104e9d <acquire>
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
80103d7a:	e8 8c 11 00 00       	call   80104f0b <release>
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
80103d9d:	e8 d7 0c 00 00       	call   80104a79 <sleep>
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
80103e30:	e8 2e 0d 00 00       	call   80104b63 <wakeup>
80103e35:	83 c4 10             	add    $0x10,%esp
  release(&p->lock);
80103e38:	8b 45 08             	mov    0x8(%ebp),%eax
80103e3b:	83 ec 0c             	sub    $0xc,%esp
80103e3e:	50                   	push   %eax
80103e3f:	e8 c7 10 00 00       	call   80104f0b <release>
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
80103e6c:	68 b4 a9 10 80       	push   $0x8010a9b4
80103e71:	68 40 72 11 80       	push   $0x80117240
80103e76:	e8 00 10 00 00       	call   80104e7b <initlock>
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
80103e8c:	2d c0 9b 11 80       	sub    $0x80119bc0,%eax
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
80103eb3:	68 bc a9 10 80       	push   $0x8010a9bc
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
80103ed7:	05 c0 9b 11 80       	add    $0x80119bc0,%eax
80103edc:	0f b6 00             	movzbl (%eax),%eax
80103edf:	0f b6 c0             	movzbl %al,%eax
80103ee2:	39 45 f0             	cmp    %eax,-0x10(%ebp)
80103ee5:	75 10                	jne    80103ef7 <mycpu+0x5b>
      return &cpus[i];
80103ee7:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103eea:	69 c0 b0 00 00 00    	imul   $0xb0,%eax,%eax
80103ef0:	05 c0 9b 11 80       	add    $0x80119bc0,%eax
80103ef5:	eb 1b                	jmp    80103f12 <mycpu+0x76>
  for (i = 0; i < ncpu; ++i) {
80103ef7:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80103efb:	a1 80 9e 11 80       	mov    0x80119e80,%eax
80103f00:	39 45 f4             	cmp    %eax,-0xc(%ebp)
80103f03:	7c c9                	jl     80103ece <mycpu+0x32>
    }
  }
  panic("unknown apicid\n");
80103f05:	83 ec 0c             	sub    $0xc,%esp
80103f08:	68 e2 a9 10 80       	push   $0x8010a9e2
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
80103f1a:	e8 e9 10 00 00       	call   80105008 <pushcli>
  c = mycpu();
80103f1f:	e8 78 ff ff ff       	call   80103e9c <mycpu>
80103f24:	89 45 f4             	mov    %eax,-0xc(%ebp)
  p = c->proc;
80103f27:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103f2a:	8b 80 ac 00 00 00    	mov    0xac(%eax),%eax
80103f30:	89 45 f0             	mov    %eax,-0x10(%ebp)
  popcli();
80103f33:	e8 1d 11 00 00       	call   80105055 <popcli>
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
80103f4b:	e8 4d 0f 00 00       	call   80104e9d <acquire>
80103f50:	83 c4 10             	add    $0x10,%esp

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103f53:	c7 45 f4 74 72 11 80 	movl   $0x80117274,-0xc(%ebp)
80103f5a:	eb 11                	jmp    80103f6d <allocproc+0x30>
    if(p->state == UNUSED){
80103f5c:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103f5f:	8b 40 0c             	mov    0xc(%eax),%eax
80103f62:	85 c0                	test   %eax,%eax
80103f64:	74 2a                	je     80103f90 <allocproc+0x53>
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103f66:	81 45 f4 84 00 00 00 	addl   $0x84,-0xc(%ebp)
80103f6d:	81 7d f4 74 93 11 80 	cmpl   $0x80119374,-0xc(%ebp)
80103f74:	72 e6                	jb     80103f5c <allocproc+0x1f>
      goto found;
    }

  release(&ptable.lock);
80103f76:	83 ec 0c             	sub    $0xc,%esp
80103f79:	68 40 72 11 80       	push   $0x80117240
80103f7e:	e8 88 0f 00 00       	call   80104f0b <release>
80103f83:	83 c4 10             	add    $0x10,%esp
  return 0;
80103f86:	b8 00 00 00 00       	mov    $0x0,%eax
80103f8b:	e9 b2 00 00 00       	jmp    80104042 <allocproc+0x105>
      goto found;
80103f90:	90                   	nop

found:
  p->state = EMBRYO;
80103f91:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103f94:	c7 40 0c 01 00 00 00 	movl   $0x1,0xc(%eax)
  p->pid = nextpid++;
80103f9b:	a1 00 f0 10 80       	mov    0x8010f000,%eax
80103fa0:	8d 50 01             	lea    0x1(%eax),%edx
80103fa3:	89 15 00 f0 10 80    	mov    %edx,0x8010f000
80103fa9:	8b 55 f4             	mov    -0xc(%ebp),%edx
80103fac:	89 42 10             	mov    %eax,0x10(%edx)

  release(&ptable.lock);
80103faf:	83 ec 0c             	sub    $0xc,%esp
80103fb2:	68 40 72 11 80       	push   $0x80117240
80103fb7:	e8 4f 0f 00 00       	call   80104f0b <release>
80103fbc:	83 c4 10             	add    $0x10,%esp


  // Allocate kernel stack.
  if((p->kstack = kalloc()) == 0){
80103fbf:	e8 c0 ec ff ff       	call   80102c84 <kalloc>
80103fc4:	8b 55 f4             	mov    -0xc(%ebp),%edx
80103fc7:	89 42 08             	mov    %eax,0x8(%edx)
80103fca:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103fcd:	8b 40 08             	mov    0x8(%eax),%eax
80103fd0:	85 c0                	test   %eax,%eax
80103fd2:	75 11                	jne    80103fe5 <allocproc+0xa8>
    p->state = UNUSED;
80103fd4:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103fd7:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
    return 0;
80103fde:	b8 00 00 00 00       	mov    $0x0,%eax
80103fe3:	eb 5d                	jmp    80104042 <allocproc+0x105>
  }
  sp = p->kstack + KSTACKSIZE;
80103fe5:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103fe8:	8b 40 08             	mov    0x8(%eax),%eax
80103feb:	05 00 10 00 00       	add    $0x1000,%eax
80103ff0:	89 45 f0             	mov    %eax,-0x10(%ebp)

  // Leave room for trap frame.
  sp -= sizeof *p->tf;
80103ff3:	83 6d f0 4c          	subl   $0x4c,-0x10(%ebp)
  p->tf = (struct trapframe*)sp;
80103ff7:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103ffa:	8b 55 f0             	mov    -0x10(%ebp),%edx
80103ffd:	89 50 18             	mov    %edx,0x18(%eax)

  // Set up new context to start executing at forkret,
  // which returns to trapret.
  sp -= 4;
80104000:	83 6d f0 04          	subl   $0x4,-0x10(%ebp)
  *(uint*)sp = (uint)trapret;
80104004:	ba 3a 65 10 80       	mov    $0x8010653a,%edx
80104009:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010400c:	89 10                	mov    %edx,(%eax)

  sp -= sizeof *p->context;
8010400e:	83 6d f0 14          	subl   $0x14,-0x10(%ebp)
  p->context = (struct context*)sp;
80104012:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104015:	8b 55 f0             	mov    -0x10(%ebp),%edx
80104018:	89 50 1c             	mov    %edx,0x1c(%eax)
  memset(p->context, 0, sizeof *p->context);
8010401b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010401e:	8b 40 1c             	mov    0x1c(%eax),%eax
80104021:	83 ec 04             	sub    $0x4,%esp
80104024:	6a 14                	push   $0x14
80104026:	6a 00                	push   $0x0
80104028:	50                   	push   %eax
80104029:	e8 e5 10 00 00       	call   80105113 <memset>
8010402e:	83 c4 10             	add    $0x10,%esp
  p->context->eip = (uint)forkret;
80104031:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104034:	8b 40 1c             	mov    0x1c(%eax),%eax
80104037:	ba 33 4a 10 80       	mov    $0x80104a33,%edx
8010403c:	89 50 10             	mov    %edx,0x10(%eax)

  return p;
8010403f:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
80104042:	c9                   	leave  
80104043:	c3                   	ret    

80104044 <userinit>:

//PAGEBREAK: 32
// Set up first user process.
void
userinit(void)
{
80104044:	55                   	push   %ebp
80104045:	89 e5                	mov    %esp,%ebp
80104047:	83 ec 18             	sub    $0x18,%esp
  struct proc *p;
  extern char _binary_initcode_start[], _binary_initcode_size[];

  p = allocproc();
8010404a:	e8 ee fe ff ff       	call   80103f3d <allocproc>
8010404f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  
  initproc = p;
80104052:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104055:	a3 74 93 11 80       	mov    %eax,0x80119374
  if((p->pgdir = setupkvm()) == 0){
8010405a:	e8 4c 3a 00 00       	call   80107aab <setupkvm>
8010405f:	8b 55 f4             	mov    -0xc(%ebp),%edx
80104062:	89 42 04             	mov    %eax,0x4(%edx)
80104065:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104068:	8b 40 04             	mov    0x4(%eax),%eax
8010406b:	85 c0                	test   %eax,%eax
8010406d:	75 0d                	jne    8010407c <userinit+0x38>
    panic("userinit: out of memory?");
8010406f:	83 ec 0c             	sub    $0xc,%esp
80104072:	68 f2 a9 10 80       	push   $0x8010a9f2
80104077:	e8 2d c5 ff ff       	call   801005a9 <panic>
  }
  inituvm(p->pgdir, _binary_initcode_start, (int)_binary_initcode_size);
8010407c:	ba 2c 00 00 00       	mov    $0x2c,%edx
80104081:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104084:	8b 40 04             	mov    0x4(%eax),%eax
80104087:	83 ec 04             	sub    $0x4,%esp
8010408a:	52                   	push   %edx
8010408b:	68 0c f5 10 80       	push   $0x8010f50c
80104090:	50                   	push   %eax
80104091:	e8 d1 3c 00 00       	call   80107d67 <inituvm>
80104096:	83 c4 10             	add    $0x10,%esp
  p->sz = PGSIZE;
80104099:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010409c:	c7 00 00 10 00 00    	movl   $0x1000,(%eax)
  memset(p->tf, 0, sizeof(*p->tf));
801040a2:	8b 45 f4             	mov    -0xc(%ebp),%eax
801040a5:	8b 40 18             	mov    0x18(%eax),%eax
801040a8:	83 ec 04             	sub    $0x4,%esp
801040ab:	6a 4c                	push   $0x4c
801040ad:	6a 00                	push   $0x0
801040af:	50                   	push   %eax
801040b0:	e8 5e 10 00 00       	call   80105113 <memset>
801040b5:	83 c4 10             	add    $0x10,%esp
  p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
801040b8:	8b 45 f4             	mov    -0xc(%ebp),%eax
801040bb:	8b 40 18             	mov    0x18(%eax),%eax
801040be:	66 c7 40 3c 1b 00    	movw   $0x1b,0x3c(%eax)
  p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
801040c4:	8b 45 f4             	mov    -0xc(%ebp),%eax
801040c7:	8b 40 18             	mov    0x18(%eax),%eax
801040ca:	66 c7 40 2c 23 00    	movw   $0x23,0x2c(%eax)
  p->tf->es = p->tf->ds;
801040d0:	8b 45 f4             	mov    -0xc(%ebp),%eax
801040d3:	8b 50 18             	mov    0x18(%eax),%edx
801040d6:	8b 45 f4             	mov    -0xc(%ebp),%eax
801040d9:	8b 40 18             	mov    0x18(%eax),%eax
801040dc:	0f b7 52 2c          	movzwl 0x2c(%edx),%edx
801040e0:	66 89 50 28          	mov    %dx,0x28(%eax)
  p->tf->ss = p->tf->ds;
801040e4:	8b 45 f4             	mov    -0xc(%ebp),%eax
801040e7:	8b 50 18             	mov    0x18(%eax),%edx
801040ea:	8b 45 f4             	mov    -0xc(%ebp),%eax
801040ed:	8b 40 18             	mov    0x18(%eax),%eax
801040f0:	0f b7 52 2c          	movzwl 0x2c(%edx),%edx
801040f4:	66 89 50 48          	mov    %dx,0x48(%eax)
  p->tf->eflags = FL_IF;
801040f8:	8b 45 f4             	mov    -0xc(%ebp),%eax
801040fb:	8b 40 18             	mov    0x18(%eax),%eax
801040fe:	c7 40 40 00 02 00 00 	movl   $0x200,0x40(%eax)
  p->tf->esp = PGSIZE;
80104105:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104108:	8b 40 18             	mov    0x18(%eax),%eax
8010410b:	c7 40 44 00 10 00 00 	movl   $0x1000,0x44(%eax)
  p->tf->eip = 0;  // beginning of initcode.S
80104112:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104115:	8b 40 18             	mov    0x18(%eax),%eax
80104118:	c7 40 38 00 00 00 00 	movl   $0x0,0x38(%eax)

  safestrcpy(p->name, "initcode", sizeof(p->name));
8010411f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104122:	83 c0 6c             	add    $0x6c,%eax
80104125:	83 ec 04             	sub    $0x4,%esp
80104128:	6a 10                	push   $0x10
8010412a:	68 0b aa 10 80       	push   $0x8010aa0b
8010412f:	50                   	push   %eax
80104130:	e8 e1 11 00 00       	call   80105316 <safestrcpy>
80104135:	83 c4 10             	add    $0x10,%esp
  p->cwd = namei("/");
80104138:	83 ec 0c             	sub    $0xc,%esp
8010413b:	68 14 aa 10 80       	push   $0x8010aa14
80104140:	e8 d8 e3 ff ff       	call   8010251d <namei>
80104145:	83 c4 10             	add    $0x10,%esp
80104148:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010414b:	89 42 68             	mov    %eax,0x68(%edx)

  // this assignment to p->state lets other cores
  // run this process. the acquire forces the above
  // writes to be visible, and the lock is also needed
  // because the assignment might not be atomic.
  acquire(&ptable.lock);
8010414e:	83 ec 0c             	sub    $0xc,%esp
80104151:	68 40 72 11 80       	push   $0x80117240
80104156:	e8 42 0d 00 00       	call   80104e9d <acquire>
8010415b:	83 c4 10             	add    $0x10,%esp

  p->state = RUNNABLE;
8010415e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104161:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)

  release(&ptable.lock);
80104168:	83 ec 0c             	sub    $0xc,%esp
8010416b:	68 40 72 11 80       	push   $0x80117240
80104170:	e8 96 0d 00 00       	call   80104f0b <release>
80104175:	83 c4 10             	add    $0x10,%esp
}
80104178:	90                   	nop
80104179:	c9                   	leave  
8010417a:	c3                   	ret    

8010417b <growproc>:

// Grow current process's memory by n bytes.
// Return 0 on success, -1 on failure.
int
growproc(int n)
{
8010417b:	55                   	push   %ebp
8010417c:	89 e5                	mov    %esp,%ebp
8010417e:	83 ec 18             	sub    $0x18,%esp
  uint sz;
  struct proc *curproc = myproc();
80104181:	e8 8e fd ff ff       	call   80103f14 <myproc>
80104186:	89 45 f0             	mov    %eax,-0x10(%ebp)

  sz = curproc->sz;
80104189:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010418c:	8b 00                	mov    (%eax),%eax
8010418e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(n > 0){
80104191:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
80104195:	7e 2e                	jle    801041c5 <growproc+0x4a>
    if((sz = allocuvm(curproc->pgdir, sz, sz + n)) == 0)
80104197:	8b 55 08             	mov    0x8(%ebp),%edx
8010419a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010419d:	01 c2                	add    %eax,%edx
8010419f:	8b 45 f0             	mov    -0x10(%ebp),%eax
801041a2:	8b 40 04             	mov    0x4(%eax),%eax
801041a5:	83 ec 04             	sub    $0x4,%esp
801041a8:	52                   	push   %edx
801041a9:	ff 75 f4             	push   -0xc(%ebp)
801041ac:	50                   	push   %eax
801041ad:	e8 f2 3c 00 00       	call   80107ea4 <allocuvm>
801041b2:	83 c4 10             	add    $0x10,%esp
801041b5:	89 45 f4             	mov    %eax,-0xc(%ebp)
801041b8:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801041bc:	75 3b                	jne    801041f9 <growproc+0x7e>
      return -1;
801041be:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801041c3:	eb 4f                	jmp    80104214 <growproc+0x99>
  } else if(n < 0){
801041c5:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
801041c9:	79 2e                	jns    801041f9 <growproc+0x7e>
    if((sz = deallocuvm(curproc->pgdir, sz, sz + n)) == 0)
801041cb:	8b 55 08             	mov    0x8(%ebp),%edx
801041ce:	8b 45 f4             	mov    -0xc(%ebp),%eax
801041d1:	01 c2                	add    %eax,%edx
801041d3:	8b 45 f0             	mov    -0x10(%ebp),%eax
801041d6:	8b 40 04             	mov    0x4(%eax),%eax
801041d9:	83 ec 04             	sub    $0x4,%esp
801041dc:	52                   	push   %edx
801041dd:	ff 75 f4             	push   -0xc(%ebp)
801041e0:	50                   	push   %eax
801041e1:	e8 c3 3d 00 00       	call   80107fa9 <deallocuvm>
801041e6:	83 c4 10             	add    $0x10,%esp
801041e9:	89 45 f4             	mov    %eax,-0xc(%ebp)
801041ec:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801041f0:	75 07                	jne    801041f9 <growproc+0x7e>
      return -1;
801041f2:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801041f7:	eb 1b                	jmp    80104214 <growproc+0x99>
  }
  curproc->sz = sz;
801041f9:	8b 45 f0             	mov    -0x10(%ebp),%eax
801041fc:	8b 55 f4             	mov    -0xc(%ebp),%edx
801041ff:	89 10                	mov    %edx,(%eax)
  switchuvm(curproc);
80104201:	83 ec 0c             	sub    $0xc,%esp
80104204:	ff 75 f0             	push   -0x10(%ebp)
80104207:	e8 bc 39 00 00       	call   80107bc8 <switchuvm>
8010420c:	83 c4 10             	add    $0x10,%esp
  return 0;
8010420f:	b8 00 00 00 00       	mov    $0x0,%eax
}
80104214:	c9                   	leave  
80104215:	c3                   	ret    

80104216 <fork>:
// Create a new process copying p as the parent.
// Sets up stack to return as if from system call.
// Caller must set state of returned proc to RUNNABLE.
int
fork(void)
{
80104216:	55                   	push   %ebp
80104217:	89 e5                	mov    %esp,%ebp
80104219:	57                   	push   %edi
8010421a:	56                   	push   %esi
8010421b:	53                   	push   %ebx
8010421c:	83 ec 1c             	sub    $0x1c,%esp
  int i, pid;
  struct proc *np;
  struct proc *curproc = myproc();
8010421f:	e8 f0 fc ff ff       	call   80103f14 <myproc>
80104224:	89 45 e0             	mov    %eax,-0x20(%ebp)

  // Allocate process.
  if((np = allocproc()) == 0){
80104227:	e8 11 fd ff ff       	call   80103f3d <allocproc>
8010422c:	89 45 dc             	mov    %eax,-0x24(%ebp)
8010422f:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
80104233:	75 0a                	jne    8010423f <fork+0x29>
    return -1;
80104235:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010423a:	e9 48 01 00 00       	jmp    80104387 <fork+0x171>
  }

  // Copy process state from proc.
  if((np->pgdir = copyuvm(curproc->pgdir, curproc->sz)) == 0){
8010423f:	8b 45 e0             	mov    -0x20(%ebp),%eax
80104242:	8b 10                	mov    (%eax),%edx
80104244:	8b 45 e0             	mov    -0x20(%ebp),%eax
80104247:	8b 40 04             	mov    0x4(%eax),%eax
8010424a:	83 ec 08             	sub    $0x8,%esp
8010424d:	52                   	push   %edx
8010424e:	50                   	push   %eax
8010424f:	e8 f3 3e 00 00       	call   80108147 <copyuvm>
80104254:	83 c4 10             	add    $0x10,%esp
80104257:	8b 55 dc             	mov    -0x24(%ebp),%edx
8010425a:	89 42 04             	mov    %eax,0x4(%edx)
8010425d:	8b 45 dc             	mov    -0x24(%ebp),%eax
80104260:	8b 40 04             	mov    0x4(%eax),%eax
80104263:	85 c0                	test   %eax,%eax
80104265:	75 30                	jne    80104297 <fork+0x81>
    kfree(np->kstack);
80104267:	8b 45 dc             	mov    -0x24(%ebp),%eax
8010426a:	8b 40 08             	mov    0x8(%eax),%eax
8010426d:	83 ec 0c             	sub    $0xc,%esp
80104270:	50                   	push   %eax
80104271:	e8 74 e9 ff ff       	call   80102bea <kfree>
80104276:	83 c4 10             	add    $0x10,%esp
    np->kstack = 0;
80104279:	8b 45 dc             	mov    -0x24(%ebp),%eax
8010427c:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
    np->state = UNUSED;
80104283:	8b 45 dc             	mov    -0x24(%ebp),%eax
80104286:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
    return -1;
8010428d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104292:	e9 f0 00 00 00       	jmp    80104387 <fork+0x171>
  }
  np->sz = curproc->sz;
80104297:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010429a:	8b 10                	mov    (%eax),%edx
8010429c:	8b 45 dc             	mov    -0x24(%ebp),%eax
8010429f:	89 10                	mov    %edx,(%eax)
  np->parent = curproc;
801042a1:	8b 45 dc             	mov    -0x24(%ebp),%eax
801042a4:	8b 55 e0             	mov    -0x20(%ebp),%edx
801042a7:	89 50 14             	mov    %edx,0x14(%eax)
  *np->tf = *curproc->tf;
801042aa:	8b 45 e0             	mov    -0x20(%ebp),%eax
801042ad:	8b 48 18             	mov    0x18(%eax),%ecx
801042b0:	8b 45 dc             	mov    -0x24(%ebp),%eax
801042b3:	8b 40 18             	mov    0x18(%eax),%eax
801042b6:	89 c2                	mov    %eax,%edx
801042b8:	89 cb                	mov    %ecx,%ebx
801042ba:	b8 13 00 00 00       	mov    $0x13,%eax
801042bf:	89 d7                	mov    %edx,%edi
801042c1:	89 de                	mov    %ebx,%esi
801042c3:	89 c1                	mov    %eax,%ecx
801042c5:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)

  // Clear %eax so that fork returns 0 in the child.
  np->tf->eax = 0;
801042c7:	8b 45 dc             	mov    -0x24(%ebp),%eax
801042ca:	8b 40 18             	mov    0x18(%eax),%eax
801042cd:	c7 40 1c 00 00 00 00 	movl   $0x0,0x1c(%eax)

  for(i = 0; i < NOFILE; i++)
801042d4:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
801042db:	eb 3b                	jmp    80104318 <fork+0x102>
    if(curproc->ofile[i])
801042dd:	8b 45 e0             	mov    -0x20(%ebp),%eax
801042e0:	8b 55 e4             	mov    -0x1c(%ebp),%edx
801042e3:	83 c2 08             	add    $0x8,%edx
801042e6:	8b 44 90 08          	mov    0x8(%eax,%edx,4),%eax
801042ea:	85 c0                	test   %eax,%eax
801042ec:	74 26                	je     80104314 <fork+0xfe>
      np->ofile[i] = filedup(curproc->ofile[i]);
801042ee:	8b 45 e0             	mov    -0x20(%ebp),%eax
801042f1:	8b 55 e4             	mov    -0x1c(%ebp),%edx
801042f4:	83 c2 08             	add    $0x8,%edx
801042f7:	8b 44 90 08          	mov    0x8(%eax,%edx,4),%eax
801042fb:	83 ec 0c             	sub    $0xc,%esp
801042fe:	50                   	push   %eax
801042ff:	e8 46 cd ff ff       	call   8010104a <filedup>
80104304:	83 c4 10             	add    $0x10,%esp
80104307:	8b 55 dc             	mov    -0x24(%ebp),%edx
8010430a:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
8010430d:	83 c1 08             	add    $0x8,%ecx
80104310:	89 44 8a 08          	mov    %eax,0x8(%edx,%ecx,4)
  for(i = 0; i < NOFILE; i++)
80104314:	83 45 e4 01          	addl   $0x1,-0x1c(%ebp)
80104318:	83 7d e4 0f          	cmpl   $0xf,-0x1c(%ebp)
8010431c:	7e bf                	jle    801042dd <fork+0xc7>
  np->cwd = idup(curproc->cwd);
8010431e:	8b 45 e0             	mov    -0x20(%ebp),%eax
80104321:	8b 40 68             	mov    0x68(%eax),%eax
80104324:	83 ec 0c             	sub    $0xc,%esp
80104327:	50                   	push   %eax
80104328:	e8 83 d6 ff ff       	call   801019b0 <idup>
8010432d:	83 c4 10             	add    $0x10,%esp
80104330:	8b 55 dc             	mov    -0x24(%ebp),%edx
80104333:	89 42 68             	mov    %eax,0x68(%edx)

  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
80104336:	8b 45 e0             	mov    -0x20(%ebp),%eax
80104339:	8d 50 6c             	lea    0x6c(%eax),%edx
8010433c:	8b 45 dc             	mov    -0x24(%ebp),%eax
8010433f:	83 c0 6c             	add    $0x6c,%eax
80104342:	83 ec 04             	sub    $0x4,%esp
80104345:	6a 10                	push   $0x10
80104347:	52                   	push   %edx
80104348:	50                   	push   %eax
80104349:	e8 c8 0f 00 00       	call   80105316 <safestrcpy>
8010434e:	83 c4 10             	add    $0x10,%esp

  pid = np->pid;
80104351:	8b 45 dc             	mov    -0x24(%ebp),%eax
80104354:	8b 40 10             	mov    0x10(%eax),%eax
80104357:	89 45 d8             	mov    %eax,-0x28(%ebp)

  acquire(&ptable.lock);
8010435a:	83 ec 0c             	sub    $0xc,%esp
8010435d:	68 40 72 11 80       	push   $0x80117240
80104362:	e8 36 0b 00 00       	call   80104e9d <acquire>
80104367:	83 c4 10             	add    $0x10,%esp

  np->state = RUNNABLE;
8010436a:	8b 45 dc             	mov    -0x24(%ebp),%eax
8010436d:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)

  release(&ptable.lock);
80104374:	83 ec 0c             	sub    $0xc,%esp
80104377:	68 40 72 11 80       	push   $0x80117240
8010437c:	e8 8a 0b 00 00       	call   80104f0b <release>
80104381:	83 c4 10             	add    $0x10,%esp

  return pid;
80104384:	8b 45 d8             	mov    -0x28(%ebp),%eax
}
80104387:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010438a:	5b                   	pop    %ebx
8010438b:	5e                   	pop    %esi
8010438c:	5f                   	pop    %edi
8010438d:	5d                   	pop    %ebp
8010438e:	c3                   	ret    

8010438f <exit>:
// Exit the current process.  Does not return.
// An exited process remains in the zombie state
// until its parent calls wait() to find out it exited.
void
exit(void)
{
8010438f:	55                   	push   %ebp
80104390:	89 e5                	mov    %esp,%ebp
80104392:	83 ec 18             	sub    $0x18,%esp
  struct proc *curproc = myproc();
80104395:	e8 7a fb ff ff       	call   80103f14 <myproc>
8010439a:	89 45 ec             	mov    %eax,-0x14(%ebp)
  struct proc *p;
  int fd;

  if(curproc == initproc)
8010439d:	a1 74 93 11 80       	mov    0x80119374,%eax
801043a2:	39 45 ec             	cmp    %eax,-0x14(%ebp)
801043a5:	75 0d                	jne    801043b4 <exit+0x25>
    panic("init exiting");
801043a7:	83 ec 0c             	sub    $0xc,%esp
801043aa:	68 16 aa 10 80       	push   $0x8010aa16
801043af:	e8 f5 c1 ff ff       	call   801005a9 <panic>

  // Close all open files.
  for(fd = 0; fd < NOFILE; fd++){
801043b4:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
801043bb:	eb 3f                	jmp    801043fc <exit+0x6d>
    if(curproc->ofile[fd]){
801043bd:	8b 45 ec             	mov    -0x14(%ebp),%eax
801043c0:	8b 55 f0             	mov    -0x10(%ebp),%edx
801043c3:	83 c2 08             	add    $0x8,%edx
801043c6:	8b 44 90 08          	mov    0x8(%eax,%edx,4),%eax
801043ca:	85 c0                	test   %eax,%eax
801043cc:	74 2a                	je     801043f8 <exit+0x69>
      fileclose(curproc->ofile[fd]);
801043ce:	8b 45 ec             	mov    -0x14(%ebp),%eax
801043d1:	8b 55 f0             	mov    -0x10(%ebp),%edx
801043d4:	83 c2 08             	add    $0x8,%edx
801043d7:	8b 44 90 08          	mov    0x8(%eax,%edx,4),%eax
801043db:	83 ec 0c             	sub    $0xc,%esp
801043de:	50                   	push   %eax
801043df:	e8 b7 cc ff ff       	call   8010109b <fileclose>
801043e4:	83 c4 10             	add    $0x10,%esp
      curproc->ofile[fd] = 0;
801043e7:	8b 45 ec             	mov    -0x14(%ebp),%eax
801043ea:	8b 55 f0             	mov    -0x10(%ebp),%edx
801043ed:	83 c2 08             	add    $0x8,%edx
801043f0:	c7 44 90 08 00 00 00 	movl   $0x0,0x8(%eax,%edx,4)
801043f7:	00 
  for(fd = 0; fd < NOFILE; fd++){
801043f8:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
801043fc:	83 7d f0 0f          	cmpl   $0xf,-0x10(%ebp)
80104400:	7e bb                	jle    801043bd <exit+0x2e>
    }
  }

  begin_op();
80104402:	e8 19 f1 ff ff       	call   80103520 <begin_op>
  iput(curproc->cwd);
80104407:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010440a:	8b 40 68             	mov    0x68(%eax),%eax
8010440d:	83 ec 0c             	sub    $0xc,%esp
80104410:	50                   	push   %eax
80104411:	e8 35 d7 ff ff       	call   80101b4b <iput>
80104416:	83 c4 10             	add    $0x10,%esp
  end_op();
80104419:	e8 8e f1 ff ff       	call   801035ac <end_op>
  curproc->cwd = 0;
8010441e:	8b 45 ec             	mov    -0x14(%ebp),%eax
80104421:	c7 40 68 00 00 00 00 	movl   $0x0,0x68(%eax)

  acquire(&ptable.lock);
80104428:	83 ec 0c             	sub    $0xc,%esp
8010442b:	68 40 72 11 80       	push   $0x80117240
80104430:	e8 68 0a 00 00       	call   80104e9d <acquire>
80104435:	83 c4 10             	add    $0x10,%esp

  // Parent might be sleeping in wait().
  wakeup1(curproc->parent);
80104438:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010443b:	8b 40 14             	mov    0x14(%eax),%eax
8010443e:	83 ec 0c             	sub    $0xc,%esp
80104441:	50                   	push   %eax
80104442:	e8 d9 06 00 00       	call   80104b20 <wakeup1>
80104447:	83 c4 10             	add    $0x10,%esp

  // Pass abandoned children to init.
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
8010444a:	c7 45 f4 74 72 11 80 	movl   $0x80117274,-0xc(%ebp)
80104451:	eb 3a                	jmp    8010448d <exit+0xfe>
    if(p->parent == curproc){
80104453:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104456:	8b 40 14             	mov    0x14(%eax),%eax
80104459:	39 45 ec             	cmp    %eax,-0x14(%ebp)
8010445c:	75 28                	jne    80104486 <exit+0xf7>
      p->parent = initproc;
8010445e:	8b 15 74 93 11 80    	mov    0x80119374,%edx
80104464:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104467:	89 50 14             	mov    %edx,0x14(%eax)
      if(p->state == ZOMBIE)
8010446a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010446d:	8b 40 0c             	mov    0xc(%eax),%eax
80104470:	83 f8 05             	cmp    $0x5,%eax
80104473:	75 11                	jne    80104486 <exit+0xf7>
        wakeup1(initproc);
80104475:	a1 74 93 11 80       	mov    0x80119374,%eax
8010447a:	83 ec 0c             	sub    $0xc,%esp
8010447d:	50                   	push   %eax
8010447e:	e8 9d 06 00 00       	call   80104b20 <wakeup1>
80104483:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104486:	81 45 f4 84 00 00 00 	addl   $0x84,-0xc(%ebp)
8010448d:	81 7d f4 74 93 11 80 	cmpl   $0x80119374,-0xc(%ebp)
80104494:	72 bd                	jb     80104453 <exit+0xc4>
    }
  }

  // Jump into the scheduler, never to return.
  curproc->state = ZOMBIE;
80104496:	8b 45 ec             	mov    -0x14(%ebp),%eax
80104499:	c7 40 0c 05 00 00 00 	movl   $0x5,0xc(%eax)
  sched();
801044a0:	e8 9b 04 00 00       	call   80104940 <sched>
  panic("zombie exit");
801044a5:	83 ec 0c             	sub    $0xc,%esp
801044a8:	68 23 aa 10 80       	push   $0x8010aa23
801044ad:	e8 f7 c0 ff ff       	call   801005a9 <panic>

801044b2 <uthread_init>:
}

int
uthread_init(int address){
801044b2:	55                   	push   %ebp
801044b3:	89 e5                	mov    %esp,%ebp
801044b5:	83 ec 18             	sub    $0x18,%esp
	//require to implement
  struct proc *curproc = myproc();
801044b8:	e8 57 fa ff ff       	call   80103f14 <myproc>
801044bd:	89 45 f4             	mov    %eax,-0xc(%ebp)
    //if (copyout(curproc->pgdir, *(curproc->scheduler), &address, sizeof(uint)) < 0)
            //return -1;
    //if (copyout(curproc->pgdir, *status, &(curproc->xstate), sizeof(int)) < 0)
	    //return -1;
  //copyin 함수
  uint a = (unsigned int)&(curproc->scheduler);
801044c0:	8b 45 f4             	mov    -0xc(%ebp),%eax
801044c3:	83 e8 80             	sub    $0xffffff80,%eax
801044c6:	89 45 f0             	mov    %eax,-0x10(%ebp)
  copyout(curproc->pgdir, a, &address, sizeof(uint));
801044c9:	8b 45 f4             	mov    -0xc(%ebp),%eax
801044cc:	8b 40 04             	mov    0x4(%eax),%eax
801044cf:	6a 04                	push   $0x4
801044d1:	8d 55 08             	lea    0x8(%ebp),%edx
801044d4:	52                   	push   %edx
801044d5:	ff 75 f0             	push   -0x10(%ebp)
801044d8:	50                   	push   %eax
801044d9:	e8 c7 3d 00 00       	call   801082a5 <copyout>
801044de:	83 c4 10             	add    $0x10,%esp
  return 0;
801044e1:	b8 00 00 00 00       	mov    $0x0,%eax
}
801044e6:	c9                   	leave  
801044e7:	c3                   	ret    

801044e8 <exit2>:
//******************************************
//************   new  **********************
//************ eixt2() *********************
//******************************************
void
exit2(int status){
801044e8:	55                   	push   %ebp
801044e9:	89 e5                	mov    %esp,%ebp
801044eb:	83 ec 18             	sub    $0x18,%esp
  struct proc *curproc = myproc();
801044ee:	e8 21 fa ff ff       	call   80103f14 <myproc>
801044f3:	89 45 ec             	mov    %eax,-0x14(%ebp)
  struct proc *p;
  int fd;
 
  //***********새로 추가된 부분. Copy status to xstate**********
  curproc->parent->xstate = status;
801044f6:	8b 45 ec             	mov    -0x14(%ebp),%eax
801044f9:	8b 40 14             	mov    0x14(%eax),%eax
801044fc:	8b 55 08             	mov    0x8(%ebp),%edx
801044ff:	89 50 7c             	mov    %edx,0x7c(%eax)
  //************************************************************

  if(curproc == initproc)
80104502:	a1 74 93 11 80       	mov    0x80119374,%eax
80104507:	39 45 ec             	cmp    %eax,-0x14(%ebp)
8010450a:	75 0d                	jne    80104519 <exit2+0x31>
    panic("init exiting");
8010450c:	83 ec 0c             	sub    $0xc,%esp
8010450f:	68 16 aa 10 80       	push   $0x8010aa16
80104514:	e8 90 c0 ff ff       	call   801005a9 <panic>

  // Close all open files.
  for(fd = 0; fd < NOFILE; fd++){
80104519:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
80104520:	eb 3f                	jmp    80104561 <exit2+0x79>
    if(curproc->ofile[fd]){
80104522:	8b 45 ec             	mov    -0x14(%ebp),%eax
80104525:	8b 55 f0             	mov    -0x10(%ebp),%edx
80104528:	83 c2 08             	add    $0x8,%edx
8010452b:	8b 44 90 08          	mov    0x8(%eax,%edx,4),%eax
8010452f:	85 c0                	test   %eax,%eax
80104531:	74 2a                	je     8010455d <exit2+0x75>
      fileclose(curproc->ofile[fd]);
80104533:	8b 45 ec             	mov    -0x14(%ebp),%eax
80104536:	8b 55 f0             	mov    -0x10(%ebp),%edx
80104539:	83 c2 08             	add    $0x8,%edx
8010453c:	8b 44 90 08          	mov    0x8(%eax,%edx,4),%eax
80104540:	83 ec 0c             	sub    $0xc,%esp
80104543:	50                   	push   %eax
80104544:	e8 52 cb ff ff       	call   8010109b <fileclose>
80104549:	83 c4 10             	add    $0x10,%esp
      curproc->ofile[fd] = 0;
8010454c:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010454f:	8b 55 f0             	mov    -0x10(%ebp),%edx
80104552:	83 c2 08             	add    $0x8,%edx
80104555:	c7 44 90 08 00 00 00 	movl   $0x0,0x8(%eax,%edx,4)
8010455c:	00 
  for(fd = 0; fd < NOFILE; fd++){
8010455d:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
80104561:	83 7d f0 0f          	cmpl   $0xf,-0x10(%ebp)
80104565:	7e bb                	jle    80104522 <exit2+0x3a>
    }
  }

  begin_op();
80104567:	e8 b4 ef ff ff       	call   80103520 <begin_op>
  iput(curproc->cwd);
8010456c:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010456f:	8b 40 68             	mov    0x68(%eax),%eax
80104572:	83 ec 0c             	sub    $0xc,%esp
80104575:	50                   	push   %eax
80104576:	e8 d0 d5 ff ff       	call   80101b4b <iput>
8010457b:	83 c4 10             	add    $0x10,%esp
  end_op();
8010457e:	e8 29 f0 ff ff       	call   801035ac <end_op>
  curproc->cwd = 0;
80104583:	8b 45 ec             	mov    -0x14(%ebp),%eax
80104586:	c7 40 68 00 00 00 00 	movl   $0x0,0x68(%eax)

  acquire(&ptable.lock);
8010458d:	83 ec 0c             	sub    $0xc,%esp
80104590:	68 40 72 11 80       	push   $0x80117240
80104595:	e8 03 09 00 00       	call   80104e9d <acquire>
8010459a:	83 c4 10             	add    $0x10,%esp

  // Parent might be sleeping in wait().
  wakeup1(curproc->parent);
8010459d:	8b 45 ec             	mov    -0x14(%ebp),%eax
801045a0:	8b 40 14             	mov    0x14(%eax),%eax
801045a3:	83 ec 0c             	sub    $0xc,%esp
801045a6:	50                   	push   %eax
801045a7:	e8 74 05 00 00       	call   80104b20 <wakeup1>
801045ac:	83 c4 10             	add    $0x10,%esp

  // Pass abandoned children to init.
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801045af:	c7 45 f4 74 72 11 80 	movl   $0x80117274,-0xc(%ebp)
801045b6:	eb 3a                	jmp    801045f2 <exit2+0x10a>
    if(p->parent == curproc){
801045b8:	8b 45 f4             	mov    -0xc(%ebp),%eax
801045bb:	8b 40 14             	mov    0x14(%eax),%eax
801045be:	39 45 ec             	cmp    %eax,-0x14(%ebp)
801045c1:	75 28                	jne    801045eb <exit2+0x103>
      p->parent = initproc;
801045c3:	8b 15 74 93 11 80    	mov    0x80119374,%edx
801045c9:	8b 45 f4             	mov    -0xc(%ebp),%eax
801045cc:	89 50 14             	mov    %edx,0x14(%eax)
      if(p->state == ZOMBIE)
801045cf:	8b 45 f4             	mov    -0xc(%ebp),%eax
801045d2:	8b 40 0c             	mov    0xc(%eax),%eax
801045d5:	83 f8 05             	cmp    $0x5,%eax
801045d8:	75 11                	jne    801045eb <exit2+0x103>
        wakeup1(initproc);
801045da:	a1 74 93 11 80       	mov    0x80119374,%eax
801045df:	83 ec 0c             	sub    $0xc,%esp
801045e2:	50                   	push   %eax
801045e3:	e8 38 05 00 00       	call   80104b20 <wakeup1>
801045e8:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801045eb:	81 45 f4 84 00 00 00 	addl   $0x84,-0xc(%ebp)
801045f2:	81 7d f4 74 93 11 80 	cmpl   $0x80119374,-0xc(%ebp)
801045f9:	72 bd                	jb     801045b8 <exit2+0xd0>
    }
  }

  // Jump into the scheduler, never to return.
  curproc->state = ZOMBIE;
801045fb:	8b 45 ec             	mov    -0x14(%ebp),%eax
801045fe:	c7 40 0c 05 00 00 00 	movl   $0x5,0xc(%eax)
  sched();
80104605:	e8 36 03 00 00       	call   80104940 <sched>
  panic("zombie exit");
8010460a:	83 ec 0c             	sub    $0xc,%esp
8010460d:	68 23 aa 10 80       	push   $0x8010aa23
80104612:	e8 92 bf ff ff       	call   801005a9 <panic>

80104617 <wait>:

// Wait for a child process to exit and return its pid.
// Return -1 if this process has no children.
int
wait(void)
{
80104617:	55                   	push   %ebp
80104618:	89 e5                	mov    %esp,%ebp
8010461a:	83 ec 18             	sub    $0x18,%esp
  struct proc *p;
  int havekids, pid;
  struct proc *curproc = myproc();
8010461d:	e8 f2 f8 ff ff       	call   80103f14 <myproc>
80104622:	89 45 ec             	mov    %eax,-0x14(%ebp)
  
  acquire(&ptable.lock);
80104625:	83 ec 0c             	sub    $0xc,%esp
80104628:	68 40 72 11 80       	push   $0x80117240
8010462d:	e8 6b 08 00 00       	call   80104e9d <acquire>
80104632:	83 c4 10             	add    $0x10,%esp
  for(;;){
    // Scan through table looking for exited children.
    havekids = 0;
80104635:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
8010463c:	c7 45 f4 74 72 11 80 	movl   $0x80117274,-0xc(%ebp)
80104643:	e9 a4 00 00 00       	jmp    801046ec <wait+0xd5>
      if(p->parent != curproc)
80104648:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010464b:	8b 40 14             	mov    0x14(%eax),%eax
8010464e:	39 45 ec             	cmp    %eax,-0x14(%ebp)
80104651:	0f 85 8d 00 00 00    	jne    801046e4 <wait+0xcd>
        continue;
      havekids = 1;
80104657:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
      if(p->state == ZOMBIE){
8010465e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104661:	8b 40 0c             	mov    0xc(%eax),%eax
80104664:	83 f8 05             	cmp    $0x5,%eax
80104667:	75 7c                	jne    801046e5 <wait+0xce>
        // Found one.
        pid = p->pid;
80104669:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010466c:	8b 40 10             	mov    0x10(%eax),%eax
8010466f:	89 45 e8             	mov    %eax,-0x18(%ebp)
        kfree(p->kstack);
80104672:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104675:	8b 40 08             	mov    0x8(%eax),%eax
80104678:	83 ec 0c             	sub    $0xc,%esp
8010467b:	50                   	push   %eax
8010467c:	e8 69 e5 ff ff       	call   80102bea <kfree>
80104681:	83 c4 10             	add    $0x10,%esp
        p->kstack = 0;
80104684:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104687:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
        freevm(p->pgdir);
8010468e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104691:	8b 40 04             	mov    0x4(%eax),%eax
80104694:	83 ec 0c             	sub    $0xc,%esp
80104697:	50                   	push   %eax
80104698:	e8 d0 39 00 00       	call   8010806d <freevm>
8010469d:	83 c4 10             	add    $0x10,%esp
        p->pid = 0;
801046a0:	8b 45 f4             	mov    -0xc(%ebp),%eax
801046a3:	c7 40 10 00 00 00 00 	movl   $0x0,0x10(%eax)
        p->parent = 0;
801046aa:	8b 45 f4             	mov    -0xc(%ebp),%eax
801046ad:	c7 40 14 00 00 00 00 	movl   $0x0,0x14(%eax)
        p->name[0] = 0;
801046b4:	8b 45 f4             	mov    -0xc(%ebp),%eax
801046b7:	c6 40 6c 00          	movb   $0x0,0x6c(%eax)
        p->killed = 0;
801046bb:	8b 45 f4             	mov    -0xc(%ebp),%eax
801046be:	c7 40 24 00 00 00 00 	movl   $0x0,0x24(%eax)
        p->state = UNUSED;
801046c5:	8b 45 f4             	mov    -0xc(%ebp),%eax
801046c8:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
        release(&ptable.lock);
801046cf:	83 ec 0c             	sub    $0xc,%esp
801046d2:	68 40 72 11 80       	push   $0x80117240
801046d7:	e8 2f 08 00 00       	call   80104f0b <release>
801046dc:	83 c4 10             	add    $0x10,%esp
        return pid;
801046df:	8b 45 e8             	mov    -0x18(%ebp),%eax
801046e2:	eb 54                	jmp    80104738 <wait+0x121>
        continue;
801046e4:	90                   	nop
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801046e5:	81 45 f4 84 00 00 00 	addl   $0x84,-0xc(%ebp)
801046ec:	81 7d f4 74 93 11 80 	cmpl   $0x80119374,-0xc(%ebp)
801046f3:	0f 82 4f ff ff ff    	jb     80104648 <wait+0x31>
      }
    }

    // No point waiting if we don't have any children.
    if(!havekids || curproc->killed){
801046f9:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
801046fd:	74 0a                	je     80104709 <wait+0xf2>
801046ff:	8b 45 ec             	mov    -0x14(%ebp),%eax
80104702:	8b 40 24             	mov    0x24(%eax),%eax
80104705:	85 c0                	test   %eax,%eax
80104707:	74 17                	je     80104720 <wait+0x109>
      release(&ptable.lock);
80104709:	83 ec 0c             	sub    $0xc,%esp
8010470c:	68 40 72 11 80       	push   $0x80117240
80104711:	e8 f5 07 00 00       	call   80104f0b <release>
80104716:	83 c4 10             	add    $0x10,%esp
      return -1;
80104719:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010471e:	eb 18                	jmp    80104738 <wait+0x121>
    }

    // Wait for children to exit.  (See wakeup1 call in proc_exit.)
    sleep(curproc, &ptable.lock);  //DOC: wait-sleep
80104720:	83 ec 08             	sub    $0x8,%esp
80104723:	68 40 72 11 80       	push   $0x80117240
80104728:	ff 75 ec             	push   -0x14(%ebp)
8010472b:	e8 49 03 00 00       	call   80104a79 <sleep>
80104730:	83 c4 10             	add    $0x10,%esp
    havekids = 0;
80104733:	e9 fd fe ff ff       	jmp    80104635 <wait+0x1e>
  }
}
80104738:	c9                   	leave  
80104739:	c3                   	ret    

8010473a <wait2>:
//******************************************
//************   new  **********************
//************ wait2() *********************
//******************************************
int
wait2(int *status){
8010473a:	55                   	push   %ebp
8010473b:	89 e5                	mov    %esp,%ebp
8010473d:	83 ec 18             	sub    $0x18,%esp

  struct proc *p;
  int havekids, pid;
  struct proc *curproc = myproc();
80104740:	e8 cf f7 ff ff       	call   80103f14 <myproc>
80104745:	89 45 ec             	mov    %eax,-0x14(%ebp)
 
  
  acquire(&ptable.lock);
80104748:	83 ec 0c             	sub    $0xc,%esp
8010474b:	68 40 72 11 80       	push   $0x80117240
80104750:	e8 48 07 00 00       	call   80104e9d <acquire>
80104755:	83 c4 10             	add    $0x10,%esp
  for(;;){
    // Scan through table looking for exited children.
    havekids = 0;
80104758:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
8010475f:	c7 45 f4 74 72 11 80 	movl   $0x80117274,-0xc(%ebp)
80104766:	e9 a4 00 00 00       	jmp    8010480f <wait2+0xd5>
      if(p->parent != curproc)
8010476b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010476e:	8b 40 14             	mov    0x14(%eax),%eax
80104771:	39 45 ec             	cmp    %eax,-0x14(%ebp)
80104774:	0f 85 8d 00 00 00    	jne    80104807 <wait2+0xcd>
        continue;
      havekids = 1;
8010477a:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
      if(p->state == ZOMBIE){
80104781:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104784:	8b 40 0c             	mov    0xc(%eax),%eax
80104787:	83 f8 05             	cmp    $0x5,%eax
8010478a:	75 7c                	jne    80104808 <wait2+0xce>
        // Found one.
        pid = p->pid;
8010478c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010478f:	8b 40 10             	mov    0x10(%eax),%eax
80104792:	89 45 e8             	mov    %eax,-0x18(%ebp)
        kfree(p->kstack);
80104795:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104798:	8b 40 08             	mov    0x8(%eax),%eax
8010479b:	83 ec 0c             	sub    $0xc,%esp
8010479e:	50                   	push   %eax
8010479f:	e8 46 e4 ff ff       	call   80102bea <kfree>
801047a4:	83 c4 10             	add    $0x10,%esp
        p->kstack = 0;
801047a7:	8b 45 f4             	mov    -0xc(%ebp),%eax
801047aa:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
        freevm(p->pgdir);
801047b1:	8b 45 f4             	mov    -0xc(%ebp),%eax
801047b4:	8b 40 04             	mov    0x4(%eax),%eax
801047b7:	83 ec 0c             	sub    $0xc,%esp
801047ba:	50                   	push   %eax
801047bb:	e8 ad 38 00 00       	call   8010806d <freevm>
801047c0:	83 c4 10             	add    $0x10,%esp
        p->pid = 0;
801047c3:	8b 45 f4             	mov    -0xc(%ebp),%eax
801047c6:	c7 40 10 00 00 00 00 	movl   $0x0,0x10(%eax)
        p->parent = 0;
801047cd:	8b 45 f4             	mov    -0xc(%ebp),%eax
801047d0:	c7 40 14 00 00 00 00 	movl   $0x0,0x14(%eax)
        p->name[0] = 0;
801047d7:	8b 45 f4             	mov    -0xc(%ebp),%eax
801047da:	c6 40 6c 00          	movb   $0x0,0x6c(%eax)
        p->killed = 0;
801047de:	8b 45 f4             	mov    -0xc(%ebp),%eax
801047e1:	c7 40 24 00 00 00 00 	movl   $0x0,0x24(%eax)
        p->state = UNUSED;
801047e8:	8b 45 f4             	mov    -0xc(%ebp),%eax
801047eb:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
        release(&ptable.lock);
801047f2:	83 ec 0c             	sub    $0xc,%esp
801047f5:	68 40 72 11 80       	push   $0x80117240
801047fa:	e8 0c 07 00 00       	call   80104f0b <release>
801047ff:	83 c4 10             	add    $0x10,%esp
        return pid;
80104802:	8b 45 e8             	mov    -0x18(%ebp),%eax
80104805:	eb 7c                	jmp    80104883 <wait2+0x149>
        continue;
80104807:	90                   	nop
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104808:	81 45 f4 84 00 00 00 	addl   $0x84,-0xc(%ebp)
8010480f:	81 7d f4 74 93 11 80 	cmpl   $0x80119374,-0xc(%ebp)
80104816:	0f 82 4f ff ff ff    	jb     8010476b <wait2+0x31>
      }
    }

    // No point waiting if we don't have any children.
    if(!havekids || curproc->killed){
8010481c:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80104820:	74 0a                	je     8010482c <wait2+0xf2>
80104822:	8b 45 ec             	mov    -0x14(%ebp),%eax
80104825:	8b 40 24             	mov    0x24(%eax),%eax
80104828:	85 c0                	test   %eax,%eax
8010482a:	74 17                	je     80104843 <wait2+0x109>
      release(&ptable.lock);
8010482c:	83 ec 0c             	sub    $0xc,%esp
8010482f:	68 40 72 11 80       	push   $0x80117240
80104834:	e8 d2 06 00 00       	call   80104f0b <release>
80104839:	83 c4 10             	add    $0x10,%esp
      return -1;
8010483c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104841:	eb 40                	jmp    80104883 <wait2+0x149>
    }

    sleep(curproc, &ptable.lock);  //DOC: wait-sleep
80104843:	83 ec 08             	sub    $0x8,%esp
80104846:	68 40 72 11 80       	push   $0x80117240
8010484b:	ff 75 ec             	push   -0x14(%ebp)
8010484e:	e8 26 02 00 00       	call   80104a79 <sleep>
80104853:	83 c4 10             	add    $0x10,%esp
  // copyout(pde_t *pgdir, uint va, void *p, uint len)와 같이 정의됨
  // p 주소의 len 길이만큼을 복사해서 pgdir의 va에 넣는다.
  // 만약 올바른 값이 아니라면 -1을 리턴
  // Wait for children to exit.  (See wakeup1 call in proc_exit.)
  // wakeup되면 마저 실행하는 코드
    if (copyout(curproc->pgdir, *status, &(curproc->xstate), sizeof(int)) < 0)
80104856:	8b 45 ec             	mov    -0x14(%ebp),%eax
80104859:	8d 50 7c             	lea    0x7c(%eax),%edx
8010485c:	8b 45 08             	mov    0x8(%ebp),%eax
8010485f:	8b 00                	mov    (%eax),%eax
80104861:	89 c1                	mov    %eax,%ecx
80104863:	8b 45 ec             	mov    -0x14(%ebp),%eax
80104866:	8b 40 04             	mov    0x4(%eax),%eax
80104869:	6a 04                	push   $0x4
8010486b:	52                   	push   %edx
8010486c:	51                   	push   %ecx
8010486d:	50                   	push   %eax
8010486e:	e8 32 3a 00 00       	call   801082a5 <copyout>
80104873:	83 c4 10             	add    $0x10,%esp
80104876:	85 c0                	test   %eax,%eax
80104878:	0f 89 da fe ff ff    	jns    80104758 <wait2+0x1e>
	    return -1;
8010487e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
				     
  }
}
80104883:	c9                   	leave  
80104884:	c3                   	ret    

80104885 <scheduler>:
//  - swtch to start running that process
//  - eventually that process transfers control
//      via swtch back to the scheduler.
void
scheduler(void)
{
80104885:	55                   	push   %ebp
80104886:	89 e5                	mov    %esp,%ebp
80104888:	83 ec 18             	sub    $0x18,%esp
  struct proc *p;
  struct cpu *c = mycpu();
8010488b:	e8 0c f6 ff ff       	call   80103e9c <mycpu>
80104890:	89 45 f0             	mov    %eax,-0x10(%ebp)
  c->proc = 0;
80104893:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104896:	c7 80 ac 00 00 00 00 	movl   $0x0,0xac(%eax)
8010489d:	00 00 00 
  
  for(;;){
    // Enable interrupts on this processor.
    sti();
801048a0:	e8 b7 f5 ff ff       	call   80103e5c <sti>

    // Loop over process table looking for process to run.
    acquire(&ptable.lock);
801048a5:	83 ec 0c             	sub    $0xc,%esp
801048a8:	68 40 72 11 80       	push   $0x80117240
801048ad:	e8 eb 05 00 00       	call   80104e9d <acquire>
801048b2:	83 c4 10             	add    $0x10,%esp
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801048b5:	c7 45 f4 74 72 11 80 	movl   $0x80117274,-0xc(%ebp)
801048bc:	eb 64                	jmp    80104922 <scheduler+0x9d>
      if(p->state != RUNNABLE)
801048be:	8b 45 f4             	mov    -0xc(%ebp),%eax
801048c1:	8b 40 0c             	mov    0xc(%eax),%eax
801048c4:	83 f8 03             	cmp    $0x3,%eax
801048c7:	75 51                	jne    8010491a <scheduler+0x95>
        continue;

      // Switch to chosen process.  It is the process's job
      // to release ptable.lock and then reacquire it
      // before jumping back to us.
      c->proc = p;
801048c9:	8b 45 f0             	mov    -0x10(%ebp),%eax
801048cc:	8b 55 f4             	mov    -0xc(%ebp),%edx
801048cf:	89 90 ac 00 00 00    	mov    %edx,0xac(%eax)
      switchuvm(p);
801048d5:	83 ec 0c             	sub    $0xc,%esp
801048d8:	ff 75 f4             	push   -0xc(%ebp)
801048db:	e8 e8 32 00 00       	call   80107bc8 <switchuvm>
801048e0:	83 c4 10             	add    $0x10,%esp
      p->state = RUNNING;
801048e3:	8b 45 f4             	mov    -0xc(%ebp),%eax
801048e6:	c7 40 0c 04 00 00 00 	movl   $0x4,0xc(%eax)

      swtch(&(c->scheduler), p->context);
801048ed:	8b 45 f4             	mov    -0xc(%ebp),%eax
801048f0:	8b 40 1c             	mov    0x1c(%eax),%eax
801048f3:	8b 55 f0             	mov    -0x10(%ebp),%edx
801048f6:	83 c2 04             	add    $0x4,%edx
801048f9:	83 ec 08             	sub    $0x8,%esp
801048fc:	50                   	push   %eax
801048fd:	52                   	push   %edx
801048fe:	e8 85 0a 00 00       	call   80105388 <swtch>
80104903:	83 c4 10             	add    $0x10,%esp
      switchkvm();
80104906:	e8 a4 32 00 00       	call   80107baf <switchkvm>

      // Process is done running for now.
      // It should have changed its p->state before coming back.
      c->proc = 0;
8010490b:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010490e:	c7 80 ac 00 00 00 00 	movl   $0x0,0xac(%eax)
80104915:	00 00 00 
80104918:	eb 01                	jmp    8010491b <scheduler+0x96>
        continue;
8010491a:	90                   	nop
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
8010491b:	81 45 f4 84 00 00 00 	addl   $0x84,-0xc(%ebp)
80104922:	81 7d f4 74 93 11 80 	cmpl   $0x80119374,-0xc(%ebp)
80104929:	72 93                	jb     801048be <scheduler+0x39>
    }
    release(&ptable.lock);
8010492b:	83 ec 0c             	sub    $0xc,%esp
8010492e:	68 40 72 11 80       	push   $0x80117240
80104933:	e8 d3 05 00 00       	call   80104f0b <release>
80104938:	83 c4 10             	add    $0x10,%esp
    sti();
8010493b:	e9 60 ff ff ff       	jmp    801048a0 <scheduler+0x1b>

80104940 <sched>:
// be proc->intena and proc->ncli, but that would
// break in the few places where a lock is held but
// there's no process.
void
sched(void)
{
80104940:	55                   	push   %ebp
80104941:	89 e5                	mov    %esp,%ebp
80104943:	83 ec 18             	sub    $0x18,%esp
  int intena;
  struct proc *p = myproc();
80104946:	e8 c9 f5 ff ff       	call   80103f14 <myproc>
8010494b:	89 45 f4             	mov    %eax,-0xc(%ebp)

  if(!holding(&ptable.lock))
8010494e:	83 ec 0c             	sub    $0xc,%esp
80104951:	68 40 72 11 80       	push   $0x80117240
80104956:	e8 7d 06 00 00       	call   80104fd8 <holding>
8010495b:	83 c4 10             	add    $0x10,%esp
8010495e:	85 c0                	test   %eax,%eax
80104960:	75 0d                	jne    8010496f <sched+0x2f>
    panic("sched ptable.lock");
80104962:	83 ec 0c             	sub    $0xc,%esp
80104965:	68 2f aa 10 80       	push   $0x8010aa2f
8010496a:	e8 3a bc ff ff       	call   801005a9 <panic>
  if(mycpu()->ncli != 1)
8010496f:	e8 28 f5 ff ff       	call   80103e9c <mycpu>
80104974:	8b 80 a4 00 00 00    	mov    0xa4(%eax),%eax
8010497a:	83 f8 01             	cmp    $0x1,%eax
8010497d:	74 0d                	je     8010498c <sched+0x4c>
    panic("sched locks");
8010497f:	83 ec 0c             	sub    $0xc,%esp
80104982:	68 41 aa 10 80       	push   $0x8010aa41
80104987:	e8 1d bc ff ff       	call   801005a9 <panic>
  if(p->state == RUNNING)
8010498c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010498f:	8b 40 0c             	mov    0xc(%eax),%eax
80104992:	83 f8 04             	cmp    $0x4,%eax
80104995:	75 0d                	jne    801049a4 <sched+0x64>
    panic("sched running");
80104997:	83 ec 0c             	sub    $0xc,%esp
8010499a:	68 4d aa 10 80       	push   $0x8010aa4d
8010499f:	e8 05 bc ff ff       	call   801005a9 <panic>
  if(readeflags()&FL_IF)
801049a4:	e8 a3 f4 ff ff       	call   80103e4c <readeflags>
801049a9:	25 00 02 00 00       	and    $0x200,%eax
801049ae:	85 c0                	test   %eax,%eax
801049b0:	74 0d                	je     801049bf <sched+0x7f>
    panic("sched interruptible");
801049b2:	83 ec 0c             	sub    $0xc,%esp
801049b5:	68 5b aa 10 80       	push   $0x8010aa5b
801049ba:	e8 ea bb ff ff       	call   801005a9 <panic>
  intena = mycpu()->intena;
801049bf:	e8 d8 f4 ff ff       	call   80103e9c <mycpu>
801049c4:	8b 80 a8 00 00 00    	mov    0xa8(%eax),%eax
801049ca:	89 45 f0             	mov    %eax,-0x10(%ebp)
  swtch(&p->context, mycpu()->scheduler);
801049cd:	e8 ca f4 ff ff       	call   80103e9c <mycpu>
801049d2:	8b 40 04             	mov    0x4(%eax),%eax
801049d5:	8b 55 f4             	mov    -0xc(%ebp),%edx
801049d8:	83 c2 1c             	add    $0x1c,%edx
801049db:	83 ec 08             	sub    $0x8,%esp
801049de:	50                   	push   %eax
801049df:	52                   	push   %edx
801049e0:	e8 a3 09 00 00       	call   80105388 <swtch>
801049e5:	83 c4 10             	add    $0x10,%esp
  mycpu()->intena = intena;
801049e8:	e8 af f4 ff ff       	call   80103e9c <mycpu>
801049ed:	8b 55 f0             	mov    -0x10(%ebp),%edx
801049f0:	89 90 a8 00 00 00    	mov    %edx,0xa8(%eax)
}
801049f6:	90                   	nop
801049f7:	c9                   	leave  
801049f8:	c3                   	ret    

801049f9 <yield>:

// Give up the CPU for one scheduling round.
void
yield(void)
{
801049f9:	55                   	push   %ebp
801049fa:	89 e5                	mov    %esp,%ebp
801049fc:	83 ec 08             	sub    $0x8,%esp
  acquire(&ptable.lock);  //DOC: yieldlock
801049ff:	83 ec 0c             	sub    $0xc,%esp
80104a02:	68 40 72 11 80       	push   $0x80117240
80104a07:	e8 91 04 00 00       	call   80104e9d <acquire>
80104a0c:	83 c4 10             	add    $0x10,%esp
  myproc()->state = RUNNABLE;
80104a0f:	e8 00 f5 ff ff       	call   80103f14 <myproc>
80104a14:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
  sched();
80104a1b:	e8 20 ff ff ff       	call   80104940 <sched>
  release(&ptable.lock);
80104a20:	83 ec 0c             	sub    $0xc,%esp
80104a23:	68 40 72 11 80       	push   $0x80117240
80104a28:	e8 de 04 00 00       	call   80104f0b <release>
80104a2d:	83 c4 10             	add    $0x10,%esp
}
80104a30:	90                   	nop
80104a31:	c9                   	leave  
80104a32:	c3                   	ret    

80104a33 <forkret>:

// A fork child's very first scheduling by scheduler()
// will swtch here.  "Return" to user space.
void
forkret(void)
{
80104a33:	55                   	push   %ebp
80104a34:	89 e5                	mov    %esp,%ebp
80104a36:	83 ec 08             	sub    $0x8,%esp
  static int first = 1;
  // Still holding ptable.lock from scheduler.
  release(&ptable.lock);
80104a39:	83 ec 0c             	sub    $0xc,%esp
80104a3c:	68 40 72 11 80       	push   $0x80117240
80104a41:	e8 c5 04 00 00       	call   80104f0b <release>
80104a46:	83 c4 10             	add    $0x10,%esp

  if (first) {
80104a49:	a1 04 f0 10 80       	mov    0x8010f004,%eax
80104a4e:	85 c0                	test   %eax,%eax
80104a50:	74 24                	je     80104a76 <forkret+0x43>
    // Some initialization functions must be run in the context
    // of a regular process (e.g., they call sleep), and thus cannot
    // be run from main().
    first = 0;
80104a52:	c7 05 04 f0 10 80 00 	movl   $0x0,0x8010f004
80104a59:	00 00 00 
    iinit(ROOTDEV);
80104a5c:	83 ec 0c             	sub    $0xc,%esp
80104a5f:	6a 01                	push   $0x1
80104a61:	e8 12 cc ff ff       	call   80101678 <iinit>
80104a66:	83 c4 10             	add    $0x10,%esp
    initlog(ROOTDEV);
80104a69:	83 ec 0c             	sub    $0xc,%esp
80104a6c:	6a 01                	push   $0x1
80104a6e:	e8 8e e8 ff ff       	call   80103301 <initlog>
80104a73:	83 c4 10             	add    $0x10,%esp
  }

  // Return to "caller", actually trapret (see allocproc).
}
80104a76:	90                   	nop
80104a77:	c9                   	leave  
80104a78:	c3                   	ret    

80104a79 <sleep>:

// Atomically release lock and sleep on chan.
// Reacquires lock when awakened.
void
sleep(void *chan, struct spinlock *lk)
{
80104a79:	55                   	push   %ebp
80104a7a:	89 e5                	mov    %esp,%ebp
80104a7c:	83 ec 18             	sub    $0x18,%esp
  struct proc *p = myproc();
80104a7f:	e8 90 f4 ff ff       	call   80103f14 <myproc>
80104a84:	89 45 f4             	mov    %eax,-0xc(%ebp)
  
  if(p == 0)
80104a87:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80104a8b:	75 0d                	jne    80104a9a <sleep+0x21>
    panic("sleep");
80104a8d:	83 ec 0c             	sub    $0xc,%esp
80104a90:	68 6f aa 10 80       	push   $0x8010aa6f
80104a95:	e8 0f bb ff ff       	call   801005a9 <panic>

  if(lk == 0)
80104a9a:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
80104a9e:	75 0d                	jne    80104aad <sleep+0x34>
    panic("sleep without lk");
80104aa0:	83 ec 0c             	sub    $0xc,%esp
80104aa3:	68 75 aa 10 80       	push   $0x8010aa75
80104aa8:	e8 fc ba ff ff       	call   801005a9 <panic>
  // change p->state and then call sched.
  // Once we hold ptable.lock, we can be
  // guaranteed that we won't miss any wakeup
  // (wakeup runs with ptable.lock locked),
  // so it's okay to release lk.
  if(lk != &ptable.lock){  //DOC: sleeplock0
80104aad:	81 7d 0c 40 72 11 80 	cmpl   $0x80117240,0xc(%ebp)
80104ab4:	74 1e                	je     80104ad4 <sleep+0x5b>
    acquire(&ptable.lock);  //DOC: sleeplock1
80104ab6:	83 ec 0c             	sub    $0xc,%esp
80104ab9:	68 40 72 11 80       	push   $0x80117240
80104abe:	e8 da 03 00 00       	call   80104e9d <acquire>
80104ac3:	83 c4 10             	add    $0x10,%esp
    release(lk);
80104ac6:	83 ec 0c             	sub    $0xc,%esp
80104ac9:	ff 75 0c             	push   0xc(%ebp)
80104acc:	e8 3a 04 00 00       	call   80104f0b <release>
80104ad1:	83 c4 10             	add    $0x10,%esp
  }
  // Go to sleep.
  p->chan = chan;
80104ad4:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104ad7:	8b 55 08             	mov    0x8(%ebp),%edx
80104ada:	89 50 20             	mov    %edx,0x20(%eax)
  p->state = SLEEPING;
80104add:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104ae0:	c7 40 0c 02 00 00 00 	movl   $0x2,0xc(%eax)

  sched();
80104ae7:	e8 54 fe ff ff       	call   80104940 <sched>

  // Tidy up.
  p->chan = 0;
80104aec:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104aef:	c7 40 20 00 00 00 00 	movl   $0x0,0x20(%eax)

  // Reacquire original lock.
  if(lk != &ptable.lock){  //DOC: sleeplock2
80104af6:	81 7d 0c 40 72 11 80 	cmpl   $0x80117240,0xc(%ebp)
80104afd:	74 1e                	je     80104b1d <sleep+0xa4>
    release(&ptable.lock);
80104aff:	83 ec 0c             	sub    $0xc,%esp
80104b02:	68 40 72 11 80       	push   $0x80117240
80104b07:	e8 ff 03 00 00       	call   80104f0b <release>
80104b0c:	83 c4 10             	add    $0x10,%esp
    acquire(lk);
80104b0f:	83 ec 0c             	sub    $0xc,%esp
80104b12:	ff 75 0c             	push   0xc(%ebp)
80104b15:	e8 83 03 00 00       	call   80104e9d <acquire>
80104b1a:	83 c4 10             	add    $0x10,%esp
  }
}
80104b1d:	90                   	nop
80104b1e:	c9                   	leave  
80104b1f:	c3                   	ret    

80104b20 <wakeup1>:
//PAGEBREAK!
// Wake up all processes sleeping on chan.
// The ptable lock must be held.
static void
wakeup1(void *chan)
{
80104b20:	55                   	push   %ebp
80104b21:	89 e5                	mov    %esp,%ebp
80104b23:	83 ec 10             	sub    $0x10,%esp
  struct proc *p;

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104b26:	c7 45 fc 74 72 11 80 	movl   $0x80117274,-0x4(%ebp)
80104b2d:	eb 27                	jmp    80104b56 <wakeup1+0x36>
    if(p->state == SLEEPING && p->chan == chan)
80104b2f:	8b 45 fc             	mov    -0x4(%ebp),%eax
80104b32:	8b 40 0c             	mov    0xc(%eax),%eax
80104b35:	83 f8 02             	cmp    $0x2,%eax
80104b38:	75 15                	jne    80104b4f <wakeup1+0x2f>
80104b3a:	8b 45 fc             	mov    -0x4(%ebp),%eax
80104b3d:	8b 40 20             	mov    0x20(%eax),%eax
80104b40:	39 45 08             	cmp    %eax,0x8(%ebp)
80104b43:	75 0a                	jne    80104b4f <wakeup1+0x2f>
      p->state = RUNNABLE;
80104b45:	8b 45 fc             	mov    -0x4(%ebp),%eax
80104b48:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104b4f:	81 45 fc 84 00 00 00 	addl   $0x84,-0x4(%ebp)
80104b56:	81 7d fc 74 93 11 80 	cmpl   $0x80119374,-0x4(%ebp)
80104b5d:	72 d0                	jb     80104b2f <wakeup1+0xf>
}
80104b5f:	90                   	nop
80104b60:	90                   	nop
80104b61:	c9                   	leave  
80104b62:	c3                   	ret    

80104b63 <wakeup>:

// Wake up all processes sleeping on chan.
void
wakeup(void *chan)
{
80104b63:	55                   	push   %ebp
80104b64:	89 e5                	mov    %esp,%ebp
80104b66:	83 ec 08             	sub    $0x8,%esp
  acquire(&ptable.lock);
80104b69:	83 ec 0c             	sub    $0xc,%esp
80104b6c:	68 40 72 11 80       	push   $0x80117240
80104b71:	e8 27 03 00 00       	call   80104e9d <acquire>
80104b76:	83 c4 10             	add    $0x10,%esp
  wakeup1(chan);
80104b79:	83 ec 0c             	sub    $0xc,%esp
80104b7c:	ff 75 08             	push   0x8(%ebp)
80104b7f:	e8 9c ff ff ff       	call   80104b20 <wakeup1>
80104b84:	83 c4 10             	add    $0x10,%esp
  release(&ptable.lock);
80104b87:	83 ec 0c             	sub    $0xc,%esp
80104b8a:	68 40 72 11 80       	push   $0x80117240
80104b8f:	e8 77 03 00 00       	call   80104f0b <release>
80104b94:	83 c4 10             	add    $0x10,%esp
}
80104b97:	90                   	nop
80104b98:	c9                   	leave  
80104b99:	c3                   	ret    

80104b9a <kill>:
// Kill the process with the given pid.
// Process won't exit until it returns
// to user space (see trap in trap.c).
int
kill(int pid)
{
80104b9a:	55                   	push   %ebp
80104b9b:	89 e5                	mov    %esp,%ebp
80104b9d:	83 ec 18             	sub    $0x18,%esp
  struct proc *p;

  acquire(&ptable.lock);
80104ba0:	83 ec 0c             	sub    $0xc,%esp
80104ba3:	68 40 72 11 80       	push   $0x80117240
80104ba8:	e8 f0 02 00 00       	call   80104e9d <acquire>
80104bad:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104bb0:	c7 45 f4 74 72 11 80 	movl   $0x80117274,-0xc(%ebp)
80104bb7:	eb 48                	jmp    80104c01 <kill+0x67>
    if(p->pid == pid){
80104bb9:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104bbc:	8b 40 10             	mov    0x10(%eax),%eax
80104bbf:	39 45 08             	cmp    %eax,0x8(%ebp)
80104bc2:	75 36                	jne    80104bfa <kill+0x60>
      p->killed = 1;
80104bc4:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104bc7:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
      // Wake process from sleep if necessary.
      if(p->state == SLEEPING)
80104bce:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104bd1:	8b 40 0c             	mov    0xc(%eax),%eax
80104bd4:	83 f8 02             	cmp    $0x2,%eax
80104bd7:	75 0a                	jne    80104be3 <kill+0x49>
        p->state = RUNNABLE;
80104bd9:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104bdc:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
      release(&ptable.lock);
80104be3:	83 ec 0c             	sub    $0xc,%esp
80104be6:	68 40 72 11 80       	push   $0x80117240
80104beb:	e8 1b 03 00 00       	call   80104f0b <release>
80104bf0:	83 c4 10             	add    $0x10,%esp
      return 0;
80104bf3:	b8 00 00 00 00       	mov    $0x0,%eax
80104bf8:	eb 25                	jmp    80104c1f <kill+0x85>
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104bfa:	81 45 f4 84 00 00 00 	addl   $0x84,-0xc(%ebp)
80104c01:	81 7d f4 74 93 11 80 	cmpl   $0x80119374,-0xc(%ebp)
80104c08:	72 af                	jb     80104bb9 <kill+0x1f>
    }
  }
  release(&ptable.lock);
80104c0a:	83 ec 0c             	sub    $0xc,%esp
80104c0d:	68 40 72 11 80       	push   $0x80117240
80104c12:	e8 f4 02 00 00       	call   80104f0b <release>
80104c17:	83 c4 10             	add    $0x10,%esp
  return -1;
80104c1a:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104c1f:	c9                   	leave  
80104c20:	c3                   	ret    

80104c21 <procdump>:
// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void
procdump(void)
{
80104c21:	55                   	push   %ebp
80104c22:	89 e5                	mov    %esp,%ebp
80104c24:	83 ec 48             	sub    $0x48,%esp
  int i;
  struct proc *p;
  char *state;
  uint pc[10];

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104c27:	c7 45 f0 74 72 11 80 	movl   $0x80117274,-0x10(%ebp)
80104c2e:	e9 da 00 00 00       	jmp    80104d0d <procdump+0xec>
    if(p->state == UNUSED)
80104c33:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104c36:	8b 40 0c             	mov    0xc(%eax),%eax
80104c39:	85 c0                	test   %eax,%eax
80104c3b:	0f 84 c4 00 00 00    	je     80104d05 <procdump+0xe4>
      continue;
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
80104c41:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104c44:	8b 40 0c             	mov    0xc(%eax),%eax
80104c47:	83 f8 05             	cmp    $0x5,%eax
80104c4a:	77 23                	ja     80104c6f <procdump+0x4e>
80104c4c:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104c4f:	8b 40 0c             	mov    0xc(%eax),%eax
80104c52:	8b 04 85 08 f0 10 80 	mov    -0x7fef0ff8(,%eax,4),%eax
80104c59:	85 c0                	test   %eax,%eax
80104c5b:	74 12                	je     80104c6f <procdump+0x4e>
      state = states[p->state];
80104c5d:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104c60:	8b 40 0c             	mov    0xc(%eax),%eax
80104c63:	8b 04 85 08 f0 10 80 	mov    -0x7fef0ff8(,%eax,4),%eax
80104c6a:	89 45 ec             	mov    %eax,-0x14(%ebp)
80104c6d:	eb 07                	jmp    80104c76 <procdump+0x55>
    else
      state = "???";
80104c6f:	c7 45 ec 86 aa 10 80 	movl   $0x8010aa86,-0x14(%ebp)
    cprintf("%d %s %s", p->pid, state, p->name);
80104c76:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104c79:	8d 50 6c             	lea    0x6c(%eax),%edx
80104c7c:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104c7f:	8b 40 10             	mov    0x10(%eax),%eax
80104c82:	52                   	push   %edx
80104c83:	ff 75 ec             	push   -0x14(%ebp)
80104c86:	50                   	push   %eax
80104c87:	68 8a aa 10 80       	push   $0x8010aa8a
80104c8c:	e8 63 b7 ff ff       	call   801003f4 <cprintf>
80104c91:	83 c4 10             	add    $0x10,%esp
    if(p->state == SLEEPING){
80104c94:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104c97:	8b 40 0c             	mov    0xc(%eax),%eax
80104c9a:	83 f8 02             	cmp    $0x2,%eax
80104c9d:	75 54                	jne    80104cf3 <procdump+0xd2>
      getcallerpcs((uint*)p->context->ebp+2, pc);
80104c9f:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104ca2:	8b 40 1c             	mov    0x1c(%eax),%eax
80104ca5:	8b 40 0c             	mov    0xc(%eax),%eax
80104ca8:	83 c0 08             	add    $0x8,%eax
80104cab:	89 c2                	mov    %eax,%edx
80104cad:	83 ec 08             	sub    $0x8,%esp
80104cb0:	8d 45 c4             	lea    -0x3c(%ebp),%eax
80104cb3:	50                   	push   %eax
80104cb4:	52                   	push   %edx
80104cb5:	e8 a3 02 00 00       	call   80104f5d <getcallerpcs>
80104cba:	83 c4 10             	add    $0x10,%esp
      for(i=0; i<10 && pc[i] != 0; i++)
80104cbd:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80104cc4:	eb 1c                	jmp    80104ce2 <procdump+0xc1>
        cprintf(" %p", pc[i]);
80104cc6:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104cc9:	8b 44 85 c4          	mov    -0x3c(%ebp,%eax,4),%eax
80104ccd:	83 ec 08             	sub    $0x8,%esp
80104cd0:	50                   	push   %eax
80104cd1:	68 93 aa 10 80       	push   $0x8010aa93
80104cd6:	e8 19 b7 ff ff       	call   801003f4 <cprintf>
80104cdb:	83 c4 10             	add    $0x10,%esp
      for(i=0; i<10 && pc[i] != 0; i++)
80104cde:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80104ce2:	83 7d f4 09          	cmpl   $0x9,-0xc(%ebp)
80104ce6:	7f 0b                	jg     80104cf3 <procdump+0xd2>
80104ce8:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104ceb:	8b 44 85 c4          	mov    -0x3c(%ebp,%eax,4),%eax
80104cef:	85 c0                	test   %eax,%eax
80104cf1:	75 d3                	jne    80104cc6 <procdump+0xa5>
    }
    cprintf("\n");
80104cf3:	83 ec 0c             	sub    $0xc,%esp
80104cf6:	68 97 aa 10 80       	push   $0x8010aa97
80104cfb:	e8 f4 b6 ff ff       	call   801003f4 <cprintf>
80104d00:	83 c4 10             	add    $0x10,%esp
80104d03:	eb 01                	jmp    80104d06 <procdump+0xe5>
      continue;
80104d05:	90                   	nop
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104d06:	81 45 f0 84 00 00 00 	addl   $0x84,-0x10(%ebp)
80104d0d:	81 7d f0 74 93 11 80 	cmpl   $0x80119374,-0x10(%ebp)
80104d14:	0f 82 19 ff ff ff    	jb     80104c33 <procdump+0x12>
  }
}
80104d1a:	90                   	nop
80104d1b:	90                   	nop
80104d1c:	c9                   	leave  
80104d1d:	c3                   	ret    

80104d1e <initsleeplock>:
#include "spinlock.h"
#include "sleeplock.h"

void
initsleeplock(struct sleeplock *lk, char *name)
{
80104d1e:	55                   	push   %ebp
80104d1f:	89 e5                	mov    %esp,%ebp
80104d21:	83 ec 08             	sub    $0x8,%esp
  initlock(&lk->lk, "sleep lock");
80104d24:	8b 45 08             	mov    0x8(%ebp),%eax
80104d27:	83 c0 04             	add    $0x4,%eax
80104d2a:	83 ec 08             	sub    $0x8,%esp
80104d2d:	68 c3 aa 10 80       	push   $0x8010aac3
80104d32:	50                   	push   %eax
80104d33:	e8 43 01 00 00       	call   80104e7b <initlock>
80104d38:	83 c4 10             	add    $0x10,%esp
  lk->name = name;
80104d3b:	8b 45 08             	mov    0x8(%ebp),%eax
80104d3e:	8b 55 0c             	mov    0xc(%ebp),%edx
80104d41:	89 50 38             	mov    %edx,0x38(%eax)
  lk->locked = 0;
80104d44:	8b 45 08             	mov    0x8(%ebp),%eax
80104d47:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  lk->pid = 0;
80104d4d:	8b 45 08             	mov    0x8(%ebp),%eax
80104d50:	c7 40 3c 00 00 00 00 	movl   $0x0,0x3c(%eax)
}
80104d57:	90                   	nop
80104d58:	c9                   	leave  
80104d59:	c3                   	ret    

80104d5a <acquiresleep>:

void
acquiresleep(struct sleeplock *lk)
{
80104d5a:	55                   	push   %ebp
80104d5b:	89 e5                	mov    %esp,%ebp
80104d5d:	83 ec 08             	sub    $0x8,%esp
  acquire(&lk->lk);
80104d60:	8b 45 08             	mov    0x8(%ebp),%eax
80104d63:	83 c0 04             	add    $0x4,%eax
80104d66:	83 ec 0c             	sub    $0xc,%esp
80104d69:	50                   	push   %eax
80104d6a:	e8 2e 01 00 00       	call   80104e9d <acquire>
80104d6f:	83 c4 10             	add    $0x10,%esp
  while (lk->locked) {
80104d72:	eb 15                	jmp    80104d89 <acquiresleep+0x2f>
    sleep(lk, &lk->lk);
80104d74:	8b 45 08             	mov    0x8(%ebp),%eax
80104d77:	83 c0 04             	add    $0x4,%eax
80104d7a:	83 ec 08             	sub    $0x8,%esp
80104d7d:	50                   	push   %eax
80104d7e:	ff 75 08             	push   0x8(%ebp)
80104d81:	e8 f3 fc ff ff       	call   80104a79 <sleep>
80104d86:	83 c4 10             	add    $0x10,%esp
  while (lk->locked) {
80104d89:	8b 45 08             	mov    0x8(%ebp),%eax
80104d8c:	8b 00                	mov    (%eax),%eax
80104d8e:	85 c0                	test   %eax,%eax
80104d90:	75 e2                	jne    80104d74 <acquiresleep+0x1a>
  }
  lk->locked = 1;
80104d92:	8b 45 08             	mov    0x8(%ebp),%eax
80104d95:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  lk->pid = myproc()->pid;
80104d9b:	e8 74 f1 ff ff       	call   80103f14 <myproc>
80104da0:	8b 50 10             	mov    0x10(%eax),%edx
80104da3:	8b 45 08             	mov    0x8(%ebp),%eax
80104da6:	89 50 3c             	mov    %edx,0x3c(%eax)
  release(&lk->lk);
80104da9:	8b 45 08             	mov    0x8(%ebp),%eax
80104dac:	83 c0 04             	add    $0x4,%eax
80104daf:	83 ec 0c             	sub    $0xc,%esp
80104db2:	50                   	push   %eax
80104db3:	e8 53 01 00 00       	call   80104f0b <release>
80104db8:	83 c4 10             	add    $0x10,%esp
}
80104dbb:	90                   	nop
80104dbc:	c9                   	leave  
80104dbd:	c3                   	ret    

80104dbe <releasesleep>:

void
releasesleep(struct sleeplock *lk)
{
80104dbe:	55                   	push   %ebp
80104dbf:	89 e5                	mov    %esp,%ebp
80104dc1:	83 ec 08             	sub    $0x8,%esp
  acquire(&lk->lk);
80104dc4:	8b 45 08             	mov    0x8(%ebp),%eax
80104dc7:	83 c0 04             	add    $0x4,%eax
80104dca:	83 ec 0c             	sub    $0xc,%esp
80104dcd:	50                   	push   %eax
80104dce:	e8 ca 00 00 00       	call   80104e9d <acquire>
80104dd3:	83 c4 10             	add    $0x10,%esp
  lk->locked = 0;
80104dd6:	8b 45 08             	mov    0x8(%ebp),%eax
80104dd9:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  lk->pid = 0;
80104ddf:	8b 45 08             	mov    0x8(%ebp),%eax
80104de2:	c7 40 3c 00 00 00 00 	movl   $0x0,0x3c(%eax)
  wakeup(lk);
80104de9:	83 ec 0c             	sub    $0xc,%esp
80104dec:	ff 75 08             	push   0x8(%ebp)
80104def:	e8 6f fd ff ff       	call   80104b63 <wakeup>
80104df4:	83 c4 10             	add    $0x10,%esp
  release(&lk->lk);
80104df7:	8b 45 08             	mov    0x8(%ebp),%eax
80104dfa:	83 c0 04             	add    $0x4,%eax
80104dfd:	83 ec 0c             	sub    $0xc,%esp
80104e00:	50                   	push   %eax
80104e01:	e8 05 01 00 00       	call   80104f0b <release>
80104e06:	83 c4 10             	add    $0x10,%esp
}
80104e09:	90                   	nop
80104e0a:	c9                   	leave  
80104e0b:	c3                   	ret    

80104e0c <holdingsleep>:

int
holdingsleep(struct sleeplock *lk)
{
80104e0c:	55                   	push   %ebp
80104e0d:	89 e5                	mov    %esp,%ebp
80104e0f:	83 ec 18             	sub    $0x18,%esp
  int r;
  
  acquire(&lk->lk);
80104e12:	8b 45 08             	mov    0x8(%ebp),%eax
80104e15:	83 c0 04             	add    $0x4,%eax
80104e18:	83 ec 0c             	sub    $0xc,%esp
80104e1b:	50                   	push   %eax
80104e1c:	e8 7c 00 00 00       	call   80104e9d <acquire>
80104e21:	83 c4 10             	add    $0x10,%esp
  r = lk->locked;
80104e24:	8b 45 08             	mov    0x8(%ebp),%eax
80104e27:	8b 00                	mov    (%eax),%eax
80104e29:	89 45 f4             	mov    %eax,-0xc(%ebp)
  release(&lk->lk);
80104e2c:	8b 45 08             	mov    0x8(%ebp),%eax
80104e2f:	83 c0 04             	add    $0x4,%eax
80104e32:	83 ec 0c             	sub    $0xc,%esp
80104e35:	50                   	push   %eax
80104e36:	e8 d0 00 00 00       	call   80104f0b <release>
80104e3b:	83 c4 10             	add    $0x10,%esp
  return r;
80104e3e:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
80104e41:	c9                   	leave  
80104e42:	c3                   	ret    

80104e43 <readeflags>:
{
80104e43:	55                   	push   %ebp
80104e44:	89 e5                	mov    %esp,%ebp
80104e46:	83 ec 10             	sub    $0x10,%esp
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80104e49:	9c                   	pushf  
80104e4a:	58                   	pop    %eax
80104e4b:	89 45 fc             	mov    %eax,-0x4(%ebp)
  return eflags;
80104e4e:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
80104e51:	c9                   	leave  
80104e52:	c3                   	ret    

80104e53 <cli>:
{
80104e53:	55                   	push   %ebp
80104e54:	89 e5                	mov    %esp,%ebp
  asm volatile("cli");
80104e56:	fa                   	cli    
}
80104e57:	90                   	nop
80104e58:	5d                   	pop    %ebp
80104e59:	c3                   	ret    

80104e5a <sti>:
{
80104e5a:	55                   	push   %ebp
80104e5b:	89 e5                	mov    %esp,%ebp
  asm volatile("sti");
80104e5d:	fb                   	sti    
}
80104e5e:	90                   	nop
80104e5f:	5d                   	pop    %ebp
80104e60:	c3                   	ret    

80104e61 <xchg>:
{
80104e61:	55                   	push   %ebp
80104e62:	89 e5                	mov    %esp,%ebp
80104e64:	83 ec 10             	sub    $0x10,%esp
  asm volatile("lock; xchgl %0, %1" :
80104e67:	8b 55 08             	mov    0x8(%ebp),%edx
80104e6a:	8b 45 0c             	mov    0xc(%ebp),%eax
80104e6d:	8b 4d 08             	mov    0x8(%ebp),%ecx
80104e70:	f0 87 02             	lock xchg %eax,(%edx)
80104e73:	89 45 fc             	mov    %eax,-0x4(%ebp)
  return result;
80104e76:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
80104e79:	c9                   	leave  
80104e7a:	c3                   	ret    

80104e7b <initlock>:
#include "proc.h"
#include "spinlock.h"

void
initlock(struct spinlock *lk, char *name)
{
80104e7b:	55                   	push   %ebp
80104e7c:	89 e5                	mov    %esp,%ebp
  lk->name = name;
80104e7e:	8b 45 08             	mov    0x8(%ebp),%eax
80104e81:	8b 55 0c             	mov    0xc(%ebp),%edx
80104e84:	89 50 04             	mov    %edx,0x4(%eax)
  lk->locked = 0;
80104e87:	8b 45 08             	mov    0x8(%ebp),%eax
80104e8a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  lk->cpu = 0;
80104e90:	8b 45 08             	mov    0x8(%ebp),%eax
80104e93:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
}
80104e9a:	90                   	nop
80104e9b:	5d                   	pop    %ebp
80104e9c:	c3                   	ret    

80104e9d <acquire>:
// Loops (spins) until the lock is acquired.
// Holding a lock for a long time may cause
// other CPUs to waste time spinning to acquire it.
void
acquire(struct spinlock *lk)
{
80104e9d:	55                   	push   %ebp
80104e9e:	89 e5                	mov    %esp,%ebp
80104ea0:	53                   	push   %ebx
80104ea1:	83 ec 04             	sub    $0x4,%esp
  pushcli(); // disable interrupts to avoid deadlock.
80104ea4:	e8 5f 01 00 00       	call   80105008 <pushcli>
  if(holding(lk)){
80104ea9:	8b 45 08             	mov    0x8(%ebp),%eax
80104eac:	83 ec 0c             	sub    $0xc,%esp
80104eaf:	50                   	push   %eax
80104eb0:	e8 23 01 00 00       	call   80104fd8 <holding>
80104eb5:	83 c4 10             	add    $0x10,%esp
80104eb8:	85 c0                	test   %eax,%eax
80104eba:	74 0d                	je     80104ec9 <acquire+0x2c>
    panic("acquire");
80104ebc:	83 ec 0c             	sub    $0xc,%esp
80104ebf:	68 ce aa 10 80       	push   $0x8010aace
80104ec4:	e8 e0 b6 ff ff       	call   801005a9 <panic>
  }

  // The xchg is atomic.
  while(xchg(&lk->locked, 1) != 0)
80104ec9:	90                   	nop
80104eca:	8b 45 08             	mov    0x8(%ebp),%eax
80104ecd:	83 ec 08             	sub    $0x8,%esp
80104ed0:	6a 01                	push   $0x1
80104ed2:	50                   	push   %eax
80104ed3:	e8 89 ff ff ff       	call   80104e61 <xchg>
80104ed8:	83 c4 10             	add    $0x10,%esp
80104edb:	85 c0                	test   %eax,%eax
80104edd:	75 eb                	jne    80104eca <acquire+0x2d>
    ;

  // Tell the C compiler and the processor to not move loads or stores
  // past this point, to ensure that the critical section's memory
  // references happen after the lock is acquired.
  __sync_synchronize();
80104edf:	f0 83 0c 24 00       	lock orl $0x0,(%esp)

  // Record info about lock acquisition for debugging.
  lk->cpu = mycpu();
80104ee4:	8b 5d 08             	mov    0x8(%ebp),%ebx
80104ee7:	e8 b0 ef ff ff       	call   80103e9c <mycpu>
80104eec:	89 43 08             	mov    %eax,0x8(%ebx)
  getcallerpcs(&lk, lk->pcs);
80104eef:	8b 45 08             	mov    0x8(%ebp),%eax
80104ef2:	83 c0 0c             	add    $0xc,%eax
80104ef5:	83 ec 08             	sub    $0x8,%esp
80104ef8:	50                   	push   %eax
80104ef9:	8d 45 08             	lea    0x8(%ebp),%eax
80104efc:	50                   	push   %eax
80104efd:	e8 5b 00 00 00       	call   80104f5d <getcallerpcs>
80104f02:	83 c4 10             	add    $0x10,%esp
}
80104f05:	90                   	nop
80104f06:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104f09:	c9                   	leave  
80104f0a:	c3                   	ret    

80104f0b <release>:

// Release the lock.
void
release(struct spinlock *lk)
{
80104f0b:	55                   	push   %ebp
80104f0c:	89 e5                	mov    %esp,%ebp
80104f0e:	83 ec 08             	sub    $0x8,%esp
  if(!holding(lk))
80104f11:	83 ec 0c             	sub    $0xc,%esp
80104f14:	ff 75 08             	push   0x8(%ebp)
80104f17:	e8 bc 00 00 00       	call   80104fd8 <holding>
80104f1c:	83 c4 10             	add    $0x10,%esp
80104f1f:	85 c0                	test   %eax,%eax
80104f21:	75 0d                	jne    80104f30 <release+0x25>
    panic("release");
80104f23:	83 ec 0c             	sub    $0xc,%esp
80104f26:	68 d6 aa 10 80       	push   $0x8010aad6
80104f2b:	e8 79 b6 ff ff       	call   801005a9 <panic>

  lk->pcs[0] = 0;
80104f30:	8b 45 08             	mov    0x8(%ebp),%eax
80104f33:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
  lk->cpu = 0;
80104f3a:	8b 45 08             	mov    0x8(%ebp),%eax
80104f3d:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  // Tell the C compiler and the processor to not move loads or stores
  // past this point, to ensure that all the stores in the critical
  // section are visible to other cores before the lock is released.
  // Both the C compiler and the hardware may re-order loads and
  // stores; __sync_synchronize() tells them both not to.
  __sync_synchronize();
80104f44:	f0 83 0c 24 00       	lock orl $0x0,(%esp)

  // Release the lock, equivalent to lk->locked = 0.
  // This code can't use a C assignment, since it might
  // not be atomic. A real OS would use C atomics here.
  asm volatile("movl $0, %0" : "+m" (lk->locked) : );
80104f49:	8b 45 08             	mov    0x8(%ebp),%eax
80104f4c:	8b 55 08             	mov    0x8(%ebp),%edx
80104f4f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

  popcli();
80104f55:	e8 fb 00 00 00       	call   80105055 <popcli>
}
80104f5a:	90                   	nop
80104f5b:	c9                   	leave  
80104f5c:	c3                   	ret    

80104f5d <getcallerpcs>:

// Record the current call stack in pcs[] by following the %ebp chain.
void
getcallerpcs(void *v, uint pcs[])
{
80104f5d:	55                   	push   %ebp
80104f5e:	89 e5                	mov    %esp,%ebp
80104f60:	83 ec 10             	sub    $0x10,%esp
  uint *ebp;
  int i;

  ebp = (uint*)v - 2;
80104f63:	8b 45 08             	mov    0x8(%ebp),%eax
80104f66:	83 e8 08             	sub    $0x8,%eax
80104f69:	89 45 fc             	mov    %eax,-0x4(%ebp)
  for(i = 0; i < 10; i++){
80104f6c:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
80104f73:	eb 38                	jmp    80104fad <getcallerpcs+0x50>
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
80104f75:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
80104f79:	74 53                	je     80104fce <getcallerpcs+0x71>
80104f7b:	81 7d fc ff ff ff 7f 	cmpl   $0x7fffffff,-0x4(%ebp)
80104f82:	76 4a                	jbe    80104fce <getcallerpcs+0x71>
80104f84:	83 7d fc ff          	cmpl   $0xffffffff,-0x4(%ebp)
80104f88:	74 44                	je     80104fce <getcallerpcs+0x71>
      break;
    pcs[i] = ebp[1];     // saved %eip
80104f8a:	8b 45 f8             	mov    -0x8(%ebp),%eax
80104f8d:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80104f94:	8b 45 0c             	mov    0xc(%ebp),%eax
80104f97:	01 c2                	add    %eax,%edx
80104f99:	8b 45 fc             	mov    -0x4(%ebp),%eax
80104f9c:	8b 40 04             	mov    0x4(%eax),%eax
80104f9f:	89 02                	mov    %eax,(%edx)
    ebp = (uint*)ebp[0]; // saved %ebp
80104fa1:	8b 45 fc             	mov    -0x4(%ebp),%eax
80104fa4:	8b 00                	mov    (%eax),%eax
80104fa6:	89 45 fc             	mov    %eax,-0x4(%ebp)
  for(i = 0; i < 10; i++){
80104fa9:	83 45 f8 01          	addl   $0x1,-0x8(%ebp)
80104fad:	83 7d f8 09          	cmpl   $0x9,-0x8(%ebp)
80104fb1:	7e c2                	jle    80104f75 <getcallerpcs+0x18>
  }
  for(; i < 10; i++)
80104fb3:	eb 19                	jmp    80104fce <getcallerpcs+0x71>
    pcs[i] = 0;
80104fb5:	8b 45 f8             	mov    -0x8(%ebp),%eax
80104fb8:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80104fbf:	8b 45 0c             	mov    0xc(%ebp),%eax
80104fc2:	01 d0                	add    %edx,%eax
80104fc4:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  for(; i < 10; i++)
80104fca:	83 45 f8 01          	addl   $0x1,-0x8(%ebp)
80104fce:	83 7d f8 09          	cmpl   $0x9,-0x8(%ebp)
80104fd2:	7e e1                	jle    80104fb5 <getcallerpcs+0x58>
}
80104fd4:	90                   	nop
80104fd5:	90                   	nop
80104fd6:	c9                   	leave  
80104fd7:	c3                   	ret    

80104fd8 <holding>:

// Check whether this cpu is holding the lock.
int
holding(struct spinlock *lock)
{
80104fd8:	55                   	push   %ebp
80104fd9:	89 e5                	mov    %esp,%ebp
80104fdb:	53                   	push   %ebx
80104fdc:	83 ec 04             	sub    $0x4,%esp
  return lock->locked && lock->cpu == mycpu();
80104fdf:	8b 45 08             	mov    0x8(%ebp),%eax
80104fe2:	8b 00                	mov    (%eax),%eax
80104fe4:	85 c0                	test   %eax,%eax
80104fe6:	74 16                	je     80104ffe <holding+0x26>
80104fe8:	8b 45 08             	mov    0x8(%ebp),%eax
80104feb:	8b 58 08             	mov    0x8(%eax),%ebx
80104fee:	e8 a9 ee ff ff       	call   80103e9c <mycpu>
80104ff3:	39 c3                	cmp    %eax,%ebx
80104ff5:	75 07                	jne    80104ffe <holding+0x26>
80104ff7:	b8 01 00 00 00       	mov    $0x1,%eax
80104ffc:	eb 05                	jmp    80105003 <holding+0x2b>
80104ffe:	b8 00 00 00 00       	mov    $0x0,%eax
}
80105003:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105006:	c9                   	leave  
80105007:	c3                   	ret    

80105008 <pushcli>:
// it takes two popcli to undo two pushcli.  Also, if interrupts
// are off, then pushcli, popcli leaves them off.

void
pushcli(void)
{
80105008:	55                   	push   %ebp
80105009:	89 e5                	mov    %esp,%ebp
8010500b:	83 ec 18             	sub    $0x18,%esp
  int eflags;

  eflags = readeflags();
8010500e:	e8 30 fe ff ff       	call   80104e43 <readeflags>
80105013:	89 45 f4             	mov    %eax,-0xc(%ebp)
  cli();
80105016:	e8 38 fe ff ff       	call   80104e53 <cli>
  if(mycpu()->ncli == 0)
8010501b:	e8 7c ee ff ff       	call   80103e9c <mycpu>
80105020:	8b 80 a4 00 00 00    	mov    0xa4(%eax),%eax
80105026:	85 c0                	test   %eax,%eax
80105028:	75 14                	jne    8010503e <pushcli+0x36>
    mycpu()->intena = eflags & FL_IF;
8010502a:	e8 6d ee ff ff       	call   80103e9c <mycpu>
8010502f:	8b 55 f4             	mov    -0xc(%ebp),%edx
80105032:	81 e2 00 02 00 00    	and    $0x200,%edx
80105038:	89 90 a8 00 00 00    	mov    %edx,0xa8(%eax)
  mycpu()->ncli += 1;
8010503e:	e8 59 ee ff ff       	call   80103e9c <mycpu>
80105043:	8b 90 a4 00 00 00    	mov    0xa4(%eax),%edx
80105049:	83 c2 01             	add    $0x1,%edx
8010504c:	89 90 a4 00 00 00    	mov    %edx,0xa4(%eax)
}
80105052:	90                   	nop
80105053:	c9                   	leave  
80105054:	c3                   	ret    

80105055 <popcli>:

void
popcli(void)
{
80105055:	55                   	push   %ebp
80105056:	89 e5                	mov    %esp,%ebp
80105058:	83 ec 08             	sub    $0x8,%esp
  if(readeflags()&FL_IF)
8010505b:	e8 e3 fd ff ff       	call   80104e43 <readeflags>
80105060:	25 00 02 00 00       	and    $0x200,%eax
80105065:	85 c0                	test   %eax,%eax
80105067:	74 0d                	je     80105076 <popcli+0x21>
    panic("popcli - interruptible");
80105069:	83 ec 0c             	sub    $0xc,%esp
8010506c:	68 de aa 10 80       	push   $0x8010aade
80105071:	e8 33 b5 ff ff       	call   801005a9 <panic>
  if(--mycpu()->ncli < 0)
80105076:	e8 21 ee ff ff       	call   80103e9c <mycpu>
8010507b:	8b 90 a4 00 00 00    	mov    0xa4(%eax),%edx
80105081:	83 ea 01             	sub    $0x1,%edx
80105084:	89 90 a4 00 00 00    	mov    %edx,0xa4(%eax)
8010508a:	8b 80 a4 00 00 00    	mov    0xa4(%eax),%eax
80105090:	85 c0                	test   %eax,%eax
80105092:	79 0d                	jns    801050a1 <popcli+0x4c>
    panic("popcli");
80105094:	83 ec 0c             	sub    $0xc,%esp
80105097:	68 f5 aa 10 80       	push   $0x8010aaf5
8010509c:	e8 08 b5 ff ff       	call   801005a9 <panic>
  if(mycpu()->ncli == 0 && mycpu()->intena)
801050a1:	e8 f6 ed ff ff       	call   80103e9c <mycpu>
801050a6:	8b 80 a4 00 00 00    	mov    0xa4(%eax),%eax
801050ac:	85 c0                	test   %eax,%eax
801050ae:	75 14                	jne    801050c4 <popcli+0x6f>
801050b0:	e8 e7 ed ff ff       	call   80103e9c <mycpu>
801050b5:	8b 80 a8 00 00 00    	mov    0xa8(%eax),%eax
801050bb:	85 c0                	test   %eax,%eax
801050bd:	74 05                	je     801050c4 <popcli+0x6f>
    sti();
801050bf:	e8 96 fd ff ff       	call   80104e5a <sti>
}
801050c4:	90                   	nop
801050c5:	c9                   	leave  
801050c6:	c3                   	ret    

801050c7 <stosb>:
801050c7:	55                   	push   %ebp
801050c8:	89 e5                	mov    %esp,%ebp
801050ca:	57                   	push   %edi
801050cb:	53                   	push   %ebx
801050cc:	8b 4d 08             	mov    0x8(%ebp),%ecx
801050cf:	8b 55 10             	mov    0x10(%ebp),%edx
801050d2:	8b 45 0c             	mov    0xc(%ebp),%eax
801050d5:	89 cb                	mov    %ecx,%ebx
801050d7:	89 df                	mov    %ebx,%edi
801050d9:	89 d1                	mov    %edx,%ecx
801050db:	fc                   	cld    
801050dc:	f3 aa                	rep stos %al,%es:(%edi)
801050de:	89 ca                	mov    %ecx,%edx
801050e0:	89 fb                	mov    %edi,%ebx
801050e2:	89 5d 08             	mov    %ebx,0x8(%ebp)
801050e5:	89 55 10             	mov    %edx,0x10(%ebp)
801050e8:	90                   	nop
801050e9:	5b                   	pop    %ebx
801050ea:	5f                   	pop    %edi
801050eb:	5d                   	pop    %ebp
801050ec:	c3                   	ret    

801050ed <stosl>:
801050ed:	55                   	push   %ebp
801050ee:	89 e5                	mov    %esp,%ebp
801050f0:	57                   	push   %edi
801050f1:	53                   	push   %ebx
801050f2:	8b 4d 08             	mov    0x8(%ebp),%ecx
801050f5:	8b 55 10             	mov    0x10(%ebp),%edx
801050f8:	8b 45 0c             	mov    0xc(%ebp),%eax
801050fb:	89 cb                	mov    %ecx,%ebx
801050fd:	89 df                	mov    %ebx,%edi
801050ff:	89 d1                	mov    %edx,%ecx
80105101:	fc                   	cld    
80105102:	f3 ab                	rep stos %eax,%es:(%edi)
80105104:	89 ca                	mov    %ecx,%edx
80105106:	89 fb                	mov    %edi,%ebx
80105108:	89 5d 08             	mov    %ebx,0x8(%ebp)
8010510b:	89 55 10             	mov    %edx,0x10(%ebp)
8010510e:	90                   	nop
8010510f:	5b                   	pop    %ebx
80105110:	5f                   	pop    %edi
80105111:	5d                   	pop    %ebp
80105112:	c3                   	ret    

80105113 <memset>:
80105113:	55                   	push   %ebp
80105114:	89 e5                	mov    %esp,%ebp
80105116:	8b 45 08             	mov    0x8(%ebp),%eax
80105119:	83 e0 03             	and    $0x3,%eax
8010511c:	85 c0                	test   %eax,%eax
8010511e:	75 43                	jne    80105163 <memset+0x50>
80105120:	8b 45 10             	mov    0x10(%ebp),%eax
80105123:	83 e0 03             	and    $0x3,%eax
80105126:	85 c0                	test   %eax,%eax
80105128:	75 39                	jne    80105163 <memset+0x50>
8010512a:	81 65 0c ff 00 00 00 	andl   $0xff,0xc(%ebp)
80105131:	8b 45 10             	mov    0x10(%ebp),%eax
80105134:	c1 e8 02             	shr    $0x2,%eax
80105137:	89 c2                	mov    %eax,%edx
80105139:	8b 45 0c             	mov    0xc(%ebp),%eax
8010513c:	c1 e0 18             	shl    $0x18,%eax
8010513f:	89 c1                	mov    %eax,%ecx
80105141:	8b 45 0c             	mov    0xc(%ebp),%eax
80105144:	c1 e0 10             	shl    $0x10,%eax
80105147:	09 c1                	or     %eax,%ecx
80105149:	8b 45 0c             	mov    0xc(%ebp),%eax
8010514c:	c1 e0 08             	shl    $0x8,%eax
8010514f:	09 c8                	or     %ecx,%eax
80105151:	0b 45 0c             	or     0xc(%ebp),%eax
80105154:	52                   	push   %edx
80105155:	50                   	push   %eax
80105156:	ff 75 08             	push   0x8(%ebp)
80105159:	e8 8f ff ff ff       	call   801050ed <stosl>
8010515e:	83 c4 0c             	add    $0xc,%esp
80105161:	eb 12                	jmp    80105175 <memset+0x62>
80105163:	8b 45 10             	mov    0x10(%ebp),%eax
80105166:	50                   	push   %eax
80105167:	ff 75 0c             	push   0xc(%ebp)
8010516a:	ff 75 08             	push   0x8(%ebp)
8010516d:	e8 55 ff ff ff       	call   801050c7 <stosb>
80105172:	83 c4 0c             	add    $0xc,%esp
80105175:	8b 45 08             	mov    0x8(%ebp),%eax
80105178:	c9                   	leave  
80105179:	c3                   	ret    

8010517a <memcmp>:
8010517a:	55                   	push   %ebp
8010517b:	89 e5                	mov    %esp,%ebp
8010517d:	83 ec 10             	sub    $0x10,%esp
80105180:	8b 45 08             	mov    0x8(%ebp),%eax
80105183:	89 45 fc             	mov    %eax,-0x4(%ebp)
80105186:	8b 45 0c             	mov    0xc(%ebp),%eax
80105189:	89 45 f8             	mov    %eax,-0x8(%ebp)
8010518c:	eb 30                	jmp    801051be <memcmp+0x44>
8010518e:	8b 45 fc             	mov    -0x4(%ebp),%eax
80105191:	0f b6 10             	movzbl (%eax),%edx
80105194:	8b 45 f8             	mov    -0x8(%ebp),%eax
80105197:	0f b6 00             	movzbl (%eax),%eax
8010519a:	38 c2                	cmp    %al,%dl
8010519c:	74 18                	je     801051b6 <memcmp+0x3c>
8010519e:	8b 45 fc             	mov    -0x4(%ebp),%eax
801051a1:	0f b6 00             	movzbl (%eax),%eax
801051a4:	0f b6 d0             	movzbl %al,%edx
801051a7:	8b 45 f8             	mov    -0x8(%ebp),%eax
801051aa:	0f b6 00             	movzbl (%eax),%eax
801051ad:	0f b6 c8             	movzbl %al,%ecx
801051b0:	89 d0                	mov    %edx,%eax
801051b2:	29 c8                	sub    %ecx,%eax
801051b4:	eb 1a                	jmp    801051d0 <memcmp+0x56>
801051b6:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
801051ba:	83 45 f8 01          	addl   $0x1,-0x8(%ebp)
801051be:	8b 45 10             	mov    0x10(%ebp),%eax
801051c1:	8d 50 ff             	lea    -0x1(%eax),%edx
801051c4:	89 55 10             	mov    %edx,0x10(%ebp)
801051c7:	85 c0                	test   %eax,%eax
801051c9:	75 c3                	jne    8010518e <memcmp+0x14>
801051cb:	b8 00 00 00 00       	mov    $0x0,%eax
801051d0:	c9                   	leave  
801051d1:	c3                   	ret    

801051d2 <memmove>:
801051d2:	55                   	push   %ebp
801051d3:	89 e5                	mov    %esp,%ebp
801051d5:	83 ec 10             	sub    $0x10,%esp
801051d8:	8b 45 0c             	mov    0xc(%ebp),%eax
801051db:	89 45 fc             	mov    %eax,-0x4(%ebp)
801051de:	8b 45 08             	mov    0x8(%ebp),%eax
801051e1:	89 45 f8             	mov    %eax,-0x8(%ebp)
801051e4:	8b 45 fc             	mov    -0x4(%ebp),%eax
801051e7:	3b 45 f8             	cmp    -0x8(%ebp),%eax
801051ea:	73 54                	jae    80105240 <memmove+0x6e>
801051ec:	8b 55 fc             	mov    -0x4(%ebp),%edx
801051ef:	8b 45 10             	mov    0x10(%ebp),%eax
801051f2:	01 d0                	add    %edx,%eax
801051f4:	39 45 f8             	cmp    %eax,-0x8(%ebp)
801051f7:	73 47                	jae    80105240 <memmove+0x6e>
801051f9:	8b 45 10             	mov    0x10(%ebp),%eax
801051fc:	01 45 fc             	add    %eax,-0x4(%ebp)
801051ff:	8b 45 10             	mov    0x10(%ebp),%eax
80105202:	01 45 f8             	add    %eax,-0x8(%ebp)
80105205:	eb 13                	jmp    8010521a <memmove+0x48>
80105207:	83 6d fc 01          	subl   $0x1,-0x4(%ebp)
8010520b:	83 6d f8 01          	subl   $0x1,-0x8(%ebp)
8010520f:	8b 45 fc             	mov    -0x4(%ebp),%eax
80105212:	0f b6 10             	movzbl (%eax),%edx
80105215:	8b 45 f8             	mov    -0x8(%ebp),%eax
80105218:	88 10                	mov    %dl,(%eax)
8010521a:	8b 45 10             	mov    0x10(%ebp),%eax
8010521d:	8d 50 ff             	lea    -0x1(%eax),%edx
80105220:	89 55 10             	mov    %edx,0x10(%ebp)
80105223:	85 c0                	test   %eax,%eax
80105225:	75 e0                	jne    80105207 <memmove+0x35>
80105227:	eb 24                	jmp    8010524d <memmove+0x7b>
80105229:	8b 55 fc             	mov    -0x4(%ebp),%edx
8010522c:	8d 42 01             	lea    0x1(%edx),%eax
8010522f:	89 45 fc             	mov    %eax,-0x4(%ebp)
80105232:	8b 45 f8             	mov    -0x8(%ebp),%eax
80105235:	8d 48 01             	lea    0x1(%eax),%ecx
80105238:	89 4d f8             	mov    %ecx,-0x8(%ebp)
8010523b:	0f b6 12             	movzbl (%edx),%edx
8010523e:	88 10                	mov    %dl,(%eax)
80105240:	8b 45 10             	mov    0x10(%ebp),%eax
80105243:	8d 50 ff             	lea    -0x1(%eax),%edx
80105246:	89 55 10             	mov    %edx,0x10(%ebp)
80105249:	85 c0                	test   %eax,%eax
8010524b:	75 dc                	jne    80105229 <memmove+0x57>
8010524d:	8b 45 08             	mov    0x8(%ebp),%eax
80105250:	c9                   	leave  
80105251:	c3                   	ret    

80105252 <memcpy>:
80105252:	55                   	push   %ebp
80105253:	89 e5                	mov    %esp,%ebp
80105255:	ff 75 10             	push   0x10(%ebp)
80105258:	ff 75 0c             	push   0xc(%ebp)
8010525b:	ff 75 08             	push   0x8(%ebp)
8010525e:	e8 6f ff ff ff       	call   801051d2 <memmove>
80105263:	83 c4 0c             	add    $0xc,%esp
80105266:	c9                   	leave  
80105267:	c3                   	ret    

80105268 <strncmp>:
80105268:	55                   	push   %ebp
80105269:	89 e5                	mov    %esp,%ebp
8010526b:	eb 0c                	jmp    80105279 <strncmp+0x11>
8010526d:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
80105271:	83 45 08 01          	addl   $0x1,0x8(%ebp)
80105275:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
80105279:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
8010527d:	74 1a                	je     80105299 <strncmp+0x31>
8010527f:	8b 45 08             	mov    0x8(%ebp),%eax
80105282:	0f b6 00             	movzbl (%eax),%eax
80105285:	84 c0                	test   %al,%al
80105287:	74 10                	je     80105299 <strncmp+0x31>
80105289:	8b 45 08             	mov    0x8(%ebp),%eax
8010528c:	0f b6 10             	movzbl (%eax),%edx
8010528f:	8b 45 0c             	mov    0xc(%ebp),%eax
80105292:	0f b6 00             	movzbl (%eax),%eax
80105295:	38 c2                	cmp    %al,%dl
80105297:	74 d4                	je     8010526d <strncmp+0x5>
80105299:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
8010529d:	75 07                	jne    801052a6 <strncmp+0x3e>
8010529f:	b8 00 00 00 00       	mov    $0x0,%eax
801052a4:	eb 16                	jmp    801052bc <strncmp+0x54>
801052a6:	8b 45 08             	mov    0x8(%ebp),%eax
801052a9:	0f b6 00             	movzbl (%eax),%eax
801052ac:	0f b6 d0             	movzbl %al,%edx
801052af:	8b 45 0c             	mov    0xc(%ebp),%eax
801052b2:	0f b6 00             	movzbl (%eax),%eax
801052b5:	0f b6 c8             	movzbl %al,%ecx
801052b8:	89 d0                	mov    %edx,%eax
801052ba:	29 c8                	sub    %ecx,%eax
801052bc:	5d                   	pop    %ebp
801052bd:	c3                   	ret    

801052be <strncpy>:
801052be:	55                   	push   %ebp
801052bf:	89 e5                	mov    %esp,%ebp
801052c1:	83 ec 10             	sub    $0x10,%esp
801052c4:	8b 45 08             	mov    0x8(%ebp),%eax
801052c7:	89 45 fc             	mov    %eax,-0x4(%ebp)
801052ca:	90                   	nop
801052cb:	8b 45 10             	mov    0x10(%ebp),%eax
801052ce:	8d 50 ff             	lea    -0x1(%eax),%edx
801052d1:	89 55 10             	mov    %edx,0x10(%ebp)
801052d4:	85 c0                	test   %eax,%eax
801052d6:	7e 2c                	jle    80105304 <strncpy+0x46>
801052d8:	8b 55 0c             	mov    0xc(%ebp),%edx
801052db:	8d 42 01             	lea    0x1(%edx),%eax
801052de:	89 45 0c             	mov    %eax,0xc(%ebp)
801052e1:	8b 45 08             	mov    0x8(%ebp),%eax
801052e4:	8d 48 01             	lea    0x1(%eax),%ecx
801052e7:	89 4d 08             	mov    %ecx,0x8(%ebp)
801052ea:	0f b6 12             	movzbl (%edx),%edx
801052ed:	88 10                	mov    %dl,(%eax)
801052ef:	0f b6 00             	movzbl (%eax),%eax
801052f2:	84 c0                	test   %al,%al
801052f4:	75 d5                	jne    801052cb <strncpy+0xd>
801052f6:	eb 0c                	jmp    80105304 <strncpy+0x46>
801052f8:	8b 45 08             	mov    0x8(%ebp),%eax
801052fb:	8d 50 01             	lea    0x1(%eax),%edx
801052fe:	89 55 08             	mov    %edx,0x8(%ebp)
80105301:	c6 00 00             	movb   $0x0,(%eax)
80105304:	8b 45 10             	mov    0x10(%ebp),%eax
80105307:	8d 50 ff             	lea    -0x1(%eax),%edx
8010530a:	89 55 10             	mov    %edx,0x10(%ebp)
8010530d:	85 c0                	test   %eax,%eax
8010530f:	7f e7                	jg     801052f8 <strncpy+0x3a>
80105311:	8b 45 fc             	mov    -0x4(%ebp),%eax
80105314:	c9                   	leave  
80105315:	c3                   	ret    

80105316 <safestrcpy>:
80105316:	55                   	push   %ebp
80105317:	89 e5                	mov    %esp,%ebp
80105319:	83 ec 10             	sub    $0x10,%esp
8010531c:	8b 45 08             	mov    0x8(%ebp),%eax
8010531f:	89 45 fc             	mov    %eax,-0x4(%ebp)
80105322:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
80105326:	7f 05                	jg     8010532d <safestrcpy+0x17>
80105328:	8b 45 fc             	mov    -0x4(%ebp),%eax
8010532b:	eb 32                	jmp    8010535f <safestrcpy+0x49>
8010532d:	90                   	nop
8010532e:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
80105332:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
80105336:	7e 1e                	jle    80105356 <safestrcpy+0x40>
80105338:	8b 55 0c             	mov    0xc(%ebp),%edx
8010533b:	8d 42 01             	lea    0x1(%edx),%eax
8010533e:	89 45 0c             	mov    %eax,0xc(%ebp)
80105341:	8b 45 08             	mov    0x8(%ebp),%eax
80105344:	8d 48 01             	lea    0x1(%eax),%ecx
80105347:	89 4d 08             	mov    %ecx,0x8(%ebp)
8010534a:	0f b6 12             	movzbl (%edx),%edx
8010534d:	88 10                	mov    %dl,(%eax)
8010534f:	0f b6 00             	movzbl (%eax),%eax
80105352:	84 c0                	test   %al,%al
80105354:	75 d8                	jne    8010532e <safestrcpy+0x18>
80105356:	8b 45 08             	mov    0x8(%ebp),%eax
80105359:	c6 00 00             	movb   $0x0,(%eax)
8010535c:	8b 45 fc             	mov    -0x4(%ebp),%eax
8010535f:	c9                   	leave  
80105360:	c3                   	ret    

80105361 <strlen>:
80105361:	55                   	push   %ebp
80105362:	89 e5                	mov    %esp,%ebp
80105364:	83 ec 10             	sub    $0x10,%esp
80105367:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
8010536e:	eb 04                	jmp    80105374 <strlen+0x13>
80105370:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
80105374:	8b 55 fc             	mov    -0x4(%ebp),%edx
80105377:	8b 45 08             	mov    0x8(%ebp),%eax
8010537a:	01 d0                	add    %edx,%eax
8010537c:	0f b6 00             	movzbl (%eax),%eax
8010537f:	84 c0                	test   %al,%al
80105381:	75 ed                	jne    80105370 <strlen+0xf>
80105383:	8b 45 fc             	mov    -0x4(%ebp),%eax
80105386:	c9                   	leave  
80105387:	c3                   	ret    

80105388 <swtch>:
80105388:	8b 44 24 04          	mov    0x4(%esp),%eax
8010538c:	8b 54 24 08          	mov    0x8(%esp),%edx
80105390:	55                   	push   %ebp
80105391:	53                   	push   %ebx
80105392:	56                   	push   %esi
80105393:	57                   	push   %edi
80105394:	89 20                	mov    %esp,(%eax)
80105396:	89 d4                	mov    %edx,%esp
80105398:	5f                   	pop    %edi
80105399:	5e                   	pop    %esi
8010539a:	5b                   	pop    %ebx
8010539b:	5d                   	pop    %ebp
8010539c:	c3                   	ret    

8010539d <fetchint>:
// to a saved program counter, and then the first argument.

// Fetch the int at addr from the current process.
int
fetchint(uint addr, int *ip)
{
8010539d:	55                   	push   %ebp
8010539e:	89 e5                	mov    %esp,%ebp
801053a0:	83 ec 18             	sub    $0x18,%esp
  struct proc *curproc = myproc();
801053a3:	e8 6c eb ff ff       	call   80103f14 <myproc>
801053a8:	89 45 f4             	mov    %eax,-0xc(%ebp)

  if(addr >= curproc->sz || addr+4 > curproc->sz)
801053ab:	8b 45 f4             	mov    -0xc(%ebp),%eax
801053ae:	8b 00                	mov    (%eax),%eax
801053b0:	39 45 08             	cmp    %eax,0x8(%ebp)
801053b3:	73 0f                	jae    801053c4 <fetchint+0x27>
801053b5:	8b 45 08             	mov    0x8(%ebp),%eax
801053b8:	8d 50 04             	lea    0x4(%eax),%edx
801053bb:	8b 45 f4             	mov    -0xc(%ebp),%eax
801053be:	8b 00                	mov    (%eax),%eax
801053c0:	39 c2                	cmp    %eax,%edx
801053c2:	76 07                	jbe    801053cb <fetchint+0x2e>
    return -1;
801053c4:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801053c9:	eb 0f                	jmp    801053da <fetchint+0x3d>
  *ip = *(int*)(addr);
801053cb:	8b 45 08             	mov    0x8(%ebp),%eax
801053ce:	8b 10                	mov    (%eax),%edx
801053d0:	8b 45 0c             	mov    0xc(%ebp),%eax
801053d3:	89 10                	mov    %edx,(%eax)
  return 0;
801053d5:	b8 00 00 00 00       	mov    $0x0,%eax
}
801053da:	c9                   	leave  
801053db:	c3                   	ret    

801053dc <fetchstr>:
// Fetch the nul-terminated string at addr from the current process.
// Doesn't actually copy the string - just sets *pp to point at it.
// Returns length of string, not including nul.
int
fetchstr(uint addr, char **pp)
{
801053dc:	55                   	push   %ebp
801053dd:	89 e5                	mov    %esp,%ebp
801053df:	83 ec 18             	sub    $0x18,%esp
  char *s, *ep;
  struct proc *curproc = myproc();
801053e2:	e8 2d eb ff ff       	call   80103f14 <myproc>
801053e7:	89 45 f0             	mov    %eax,-0x10(%ebp)

  if(addr >= curproc->sz)
801053ea:	8b 45 f0             	mov    -0x10(%ebp),%eax
801053ed:	8b 00                	mov    (%eax),%eax
801053ef:	39 45 08             	cmp    %eax,0x8(%ebp)
801053f2:	72 07                	jb     801053fb <fetchstr+0x1f>
    return -1;
801053f4:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801053f9:	eb 41                	jmp    8010543c <fetchstr+0x60>
  *pp = (char*)addr;
801053fb:	8b 55 08             	mov    0x8(%ebp),%edx
801053fe:	8b 45 0c             	mov    0xc(%ebp),%eax
80105401:	89 10                	mov    %edx,(%eax)
  ep = (char*)curproc->sz;
80105403:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105406:	8b 00                	mov    (%eax),%eax
80105408:	89 45 ec             	mov    %eax,-0x14(%ebp)
  for(s = *pp; s < ep; s++){
8010540b:	8b 45 0c             	mov    0xc(%ebp),%eax
8010540e:	8b 00                	mov    (%eax),%eax
80105410:	89 45 f4             	mov    %eax,-0xc(%ebp)
80105413:	eb 1a                	jmp    8010542f <fetchstr+0x53>
    if(*s == 0)
80105415:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105418:	0f b6 00             	movzbl (%eax),%eax
8010541b:	84 c0                	test   %al,%al
8010541d:	75 0c                	jne    8010542b <fetchstr+0x4f>
      return s - *pp;
8010541f:	8b 45 0c             	mov    0xc(%ebp),%eax
80105422:	8b 10                	mov    (%eax),%edx
80105424:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105427:	29 d0                	sub    %edx,%eax
80105429:	eb 11                	jmp    8010543c <fetchstr+0x60>
  for(s = *pp; s < ep; s++){
8010542b:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
8010542f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105432:	3b 45 ec             	cmp    -0x14(%ebp),%eax
80105435:	72 de                	jb     80105415 <fetchstr+0x39>
  }
  return -1;
80105437:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
8010543c:	c9                   	leave  
8010543d:	c3                   	ret    

8010543e <argint>:

// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
8010543e:	55                   	push   %ebp
8010543f:	89 e5                	mov    %esp,%ebp
80105441:	83 ec 08             	sub    $0x8,%esp
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80105444:	e8 cb ea ff ff       	call   80103f14 <myproc>
80105449:	8b 40 18             	mov    0x18(%eax),%eax
8010544c:	8b 50 44             	mov    0x44(%eax),%edx
8010544f:	8b 45 08             	mov    0x8(%ebp),%eax
80105452:	c1 e0 02             	shl    $0x2,%eax
80105455:	01 d0                	add    %edx,%eax
80105457:	83 c0 04             	add    $0x4,%eax
8010545a:	83 ec 08             	sub    $0x8,%esp
8010545d:	ff 75 0c             	push   0xc(%ebp)
80105460:	50                   	push   %eax
80105461:	e8 37 ff ff ff       	call   8010539d <fetchint>
80105466:	83 c4 10             	add    $0x10,%esp
}
80105469:	c9                   	leave  
8010546a:	c3                   	ret    

8010546b <argptr>:
// Fetch the nth word-sized system call argument as a pointer
// to a block of memory of size bytes.  Check that the pointer
// lies within the process address space.
int
argptr(int n, char **pp, int size)
{
8010546b:	55                   	push   %ebp
8010546c:	89 e5                	mov    %esp,%ebp
8010546e:	83 ec 18             	sub    $0x18,%esp
  int i;
  struct proc *curproc = myproc();
80105471:	e8 9e ea ff ff       	call   80103f14 <myproc>
80105476:	89 45 f4             	mov    %eax,-0xc(%ebp)
 
  if(argint(n, &i) < 0)
80105479:	83 ec 08             	sub    $0x8,%esp
8010547c:	8d 45 f0             	lea    -0x10(%ebp),%eax
8010547f:	50                   	push   %eax
80105480:	ff 75 08             	push   0x8(%ebp)
80105483:	e8 b6 ff ff ff       	call   8010543e <argint>
80105488:	83 c4 10             	add    $0x10,%esp
8010548b:	85 c0                	test   %eax,%eax
8010548d:	79 07                	jns    80105496 <argptr+0x2b>
    return -1;
8010548f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105494:	eb 3b                	jmp    801054d1 <argptr+0x66>
  if(size < 0 || (uint)i >= curproc->sz || (uint)i+size > curproc->sz)
80105496:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
8010549a:	78 1f                	js     801054bb <argptr+0x50>
8010549c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010549f:	8b 00                	mov    (%eax),%eax
801054a1:	8b 55 f0             	mov    -0x10(%ebp),%edx
801054a4:	39 d0                	cmp    %edx,%eax
801054a6:	76 13                	jbe    801054bb <argptr+0x50>
801054a8:	8b 45 f0             	mov    -0x10(%ebp),%eax
801054ab:	89 c2                	mov    %eax,%edx
801054ad:	8b 45 10             	mov    0x10(%ebp),%eax
801054b0:	01 c2                	add    %eax,%edx
801054b2:	8b 45 f4             	mov    -0xc(%ebp),%eax
801054b5:	8b 00                	mov    (%eax),%eax
801054b7:	39 c2                	cmp    %eax,%edx
801054b9:	76 07                	jbe    801054c2 <argptr+0x57>
    return -1;
801054bb:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801054c0:	eb 0f                	jmp    801054d1 <argptr+0x66>
  *pp = (char*)i;
801054c2:	8b 45 f0             	mov    -0x10(%ebp),%eax
801054c5:	89 c2                	mov    %eax,%edx
801054c7:	8b 45 0c             	mov    0xc(%ebp),%eax
801054ca:	89 10                	mov    %edx,(%eax)
  return 0;
801054cc:	b8 00 00 00 00       	mov    $0x0,%eax
}
801054d1:	c9                   	leave  
801054d2:	c3                   	ret    

801054d3 <argstr>:
// Check that the pointer is valid and the string is nul-terminated.
// (There is no shared writable memory, so the string can't change
// between this check and being used by the kernel.)
int
argstr(int n, char **pp)
{
801054d3:	55                   	push   %ebp
801054d4:	89 e5                	mov    %esp,%ebp
801054d6:	83 ec 18             	sub    $0x18,%esp
  int addr;
  if(argint(n, &addr) < 0)
801054d9:	83 ec 08             	sub    $0x8,%esp
801054dc:	8d 45 f4             	lea    -0xc(%ebp),%eax
801054df:	50                   	push   %eax
801054e0:	ff 75 08             	push   0x8(%ebp)
801054e3:	e8 56 ff ff ff       	call   8010543e <argint>
801054e8:	83 c4 10             	add    $0x10,%esp
801054eb:	85 c0                	test   %eax,%eax
801054ed:	79 07                	jns    801054f6 <argstr+0x23>
    return -1;
801054ef:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801054f4:	eb 12                	jmp    80105508 <argstr+0x35>
  return fetchstr(addr, pp);
801054f6:	8b 45 f4             	mov    -0xc(%ebp),%eax
801054f9:	83 ec 08             	sub    $0x8,%esp
801054fc:	ff 75 0c             	push   0xc(%ebp)
801054ff:	50                   	push   %eax
80105500:	e8 d7 fe ff ff       	call   801053dc <fetchstr>
80105505:	83 c4 10             	add    $0x10,%esp
}
80105508:	c9                   	leave  
80105509:	c3                   	ret    

8010550a <syscall>:
[SYS_uthread_init]   sys_uthread_init,
};

void
syscall(void)
{
8010550a:	55                   	push   %ebp
8010550b:	89 e5                	mov    %esp,%ebp
8010550d:	83 ec 18             	sub    $0x18,%esp
  int num;
  struct proc *curproc = myproc();
80105510:	e8 ff e9 ff ff       	call   80103f14 <myproc>
80105515:	89 45 f4             	mov    %eax,-0xc(%ebp)

  num = curproc->tf->eax;
80105518:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010551b:	8b 40 18             	mov    0x18(%eax),%eax
8010551e:	8b 40 1c             	mov    0x1c(%eax),%eax
80105521:	89 45 f0             	mov    %eax,-0x10(%ebp)
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
80105524:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80105528:	7e 2f                	jle    80105559 <syscall+0x4f>
8010552a:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010552d:	83 f8 18             	cmp    $0x18,%eax
80105530:	77 27                	ja     80105559 <syscall+0x4f>
80105532:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105535:	8b 04 85 20 f0 10 80 	mov    -0x7fef0fe0(,%eax,4),%eax
8010553c:	85 c0                	test   %eax,%eax
8010553e:	74 19                	je     80105559 <syscall+0x4f>
    curproc->tf->eax = syscalls[num]();
80105540:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105543:	8b 04 85 20 f0 10 80 	mov    -0x7fef0fe0(,%eax,4),%eax
8010554a:	ff d0                	call   *%eax
8010554c:	89 c2                	mov    %eax,%edx
8010554e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105551:	8b 40 18             	mov    0x18(%eax),%eax
80105554:	89 50 1c             	mov    %edx,0x1c(%eax)
80105557:	eb 2c                	jmp    80105585 <syscall+0x7b>
  } else {
    cprintf("%d %s: unknown sys call %d\n",
            curproc->pid, curproc->name, num);
80105559:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010555c:	8d 50 6c             	lea    0x6c(%eax),%edx
    cprintf("%d %s: unknown sys call %d\n",
8010555f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105562:	8b 40 10             	mov    0x10(%eax),%eax
80105565:	ff 75 f0             	push   -0x10(%ebp)
80105568:	52                   	push   %edx
80105569:	50                   	push   %eax
8010556a:	68 fc aa 10 80       	push   $0x8010aafc
8010556f:	e8 80 ae ff ff       	call   801003f4 <cprintf>
80105574:	83 c4 10             	add    $0x10,%esp
    curproc->tf->eax = -1;
80105577:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010557a:	8b 40 18             	mov    0x18(%eax),%eax
8010557d:	c7 40 1c ff ff ff ff 	movl   $0xffffffff,0x1c(%eax)
  }
}
80105584:	90                   	nop
80105585:	90                   	nop
80105586:	c9                   	leave  
80105587:	c3                   	ret    

80105588 <argfd>:

// Fetch the nth word-sized system call argument as a file descriptor
// and return both the descriptor and the corresponding struct file.
static int
argfd(int n, int *pfd, struct file **pf)
{
80105588:	55                   	push   %ebp
80105589:	89 e5                	mov    %esp,%ebp
8010558b:	83 ec 18             	sub    $0x18,%esp
  int fd;
  struct file *f;

  if(argint(n, &fd) < 0)
8010558e:	83 ec 08             	sub    $0x8,%esp
80105591:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105594:	50                   	push   %eax
80105595:	ff 75 08             	push   0x8(%ebp)
80105598:	e8 a1 fe ff ff       	call   8010543e <argint>
8010559d:	83 c4 10             	add    $0x10,%esp
801055a0:	85 c0                	test   %eax,%eax
801055a2:	79 07                	jns    801055ab <argfd+0x23>
    return -1;
801055a4:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801055a9:	eb 4f                	jmp    801055fa <argfd+0x72>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
801055ab:	8b 45 f0             	mov    -0x10(%ebp),%eax
801055ae:	85 c0                	test   %eax,%eax
801055b0:	78 20                	js     801055d2 <argfd+0x4a>
801055b2:	8b 45 f0             	mov    -0x10(%ebp),%eax
801055b5:	83 f8 0f             	cmp    $0xf,%eax
801055b8:	7f 18                	jg     801055d2 <argfd+0x4a>
801055ba:	e8 55 e9 ff ff       	call   80103f14 <myproc>
801055bf:	8b 55 f0             	mov    -0x10(%ebp),%edx
801055c2:	83 c2 08             	add    $0x8,%edx
801055c5:	8b 44 90 08          	mov    0x8(%eax,%edx,4),%eax
801055c9:	89 45 f4             	mov    %eax,-0xc(%ebp)
801055cc:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801055d0:	75 07                	jne    801055d9 <argfd+0x51>
    return -1;
801055d2:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801055d7:	eb 21                	jmp    801055fa <argfd+0x72>
  if(pfd)
801055d9:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
801055dd:	74 08                	je     801055e7 <argfd+0x5f>
    *pfd = fd;
801055df:	8b 55 f0             	mov    -0x10(%ebp),%edx
801055e2:	8b 45 0c             	mov    0xc(%ebp),%eax
801055e5:	89 10                	mov    %edx,(%eax)
  if(pf)
801055e7:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
801055eb:	74 08                	je     801055f5 <argfd+0x6d>
    *pf = f;
801055ed:	8b 45 10             	mov    0x10(%ebp),%eax
801055f0:	8b 55 f4             	mov    -0xc(%ebp),%edx
801055f3:	89 10                	mov    %edx,(%eax)
  return 0;
801055f5:	b8 00 00 00 00       	mov    $0x0,%eax
}
801055fa:	c9                   	leave  
801055fb:	c3                   	ret    

801055fc <fdalloc>:

// Allocate a file descriptor for the given file.
// Takes over file reference from caller on success.
static int
fdalloc(struct file *f)
{
801055fc:	55                   	push   %ebp
801055fd:	89 e5                	mov    %esp,%ebp
801055ff:	83 ec 18             	sub    $0x18,%esp
  int fd;
  struct proc *curproc = myproc();
80105602:	e8 0d e9 ff ff       	call   80103f14 <myproc>
80105607:	89 45 f0             	mov    %eax,-0x10(%ebp)

  for(fd = 0; fd < NOFILE; fd++){
8010560a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80105611:	eb 2a                	jmp    8010563d <fdalloc+0x41>
    if(curproc->ofile[fd] == 0){
80105613:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105616:	8b 55 f4             	mov    -0xc(%ebp),%edx
80105619:	83 c2 08             	add    $0x8,%edx
8010561c:	8b 44 90 08          	mov    0x8(%eax,%edx,4),%eax
80105620:	85 c0                	test   %eax,%eax
80105622:	75 15                	jne    80105639 <fdalloc+0x3d>
      curproc->ofile[fd] = f;
80105624:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105627:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010562a:	8d 4a 08             	lea    0x8(%edx),%ecx
8010562d:	8b 55 08             	mov    0x8(%ebp),%edx
80105630:	89 54 88 08          	mov    %edx,0x8(%eax,%ecx,4)
      return fd;
80105634:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105637:	eb 0f                	jmp    80105648 <fdalloc+0x4c>
  for(fd = 0; fd < NOFILE; fd++){
80105639:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
8010563d:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
80105641:	7e d0                	jle    80105613 <fdalloc+0x17>
    }
  }
  return -1;
80105643:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105648:	c9                   	leave  
80105649:	c3                   	ret    

8010564a <sys_dup>:

int
sys_dup(void)
{
8010564a:	55                   	push   %ebp
8010564b:	89 e5                	mov    %esp,%ebp
8010564d:	83 ec 18             	sub    $0x18,%esp
  struct file *f;
  int fd;

  if(argfd(0, 0, &f) < 0)
80105650:	83 ec 04             	sub    $0x4,%esp
80105653:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105656:	50                   	push   %eax
80105657:	6a 00                	push   $0x0
80105659:	6a 00                	push   $0x0
8010565b:	e8 28 ff ff ff       	call   80105588 <argfd>
80105660:	83 c4 10             	add    $0x10,%esp
80105663:	85 c0                	test   %eax,%eax
80105665:	79 07                	jns    8010566e <sys_dup+0x24>
    return -1;
80105667:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010566c:	eb 31                	jmp    8010569f <sys_dup+0x55>
  if((fd=fdalloc(f)) < 0)
8010566e:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105671:	83 ec 0c             	sub    $0xc,%esp
80105674:	50                   	push   %eax
80105675:	e8 82 ff ff ff       	call   801055fc <fdalloc>
8010567a:	83 c4 10             	add    $0x10,%esp
8010567d:	89 45 f4             	mov    %eax,-0xc(%ebp)
80105680:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80105684:	79 07                	jns    8010568d <sys_dup+0x43>
    return -1;
80105686:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010568b:	eb 12                	jmp    8010569f <sys_dup+0x55>
  filedup(f);
8010568d:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105690:	83 ec 0c             	sub    $0xc,%esp
80105693:	50                   	push   %eax
80105694:	e8 b1 b9 ff ff       	call   8010104a <filedup>
80105699:	83 c4 10             	add    $0x10,%esp
  return fd;
8010569c:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
8010569f:	c9                   	leave  
801056a0:	c3                   	ret    

801056a1 <sys_read>:

int
sys_read(void)
{
801056a1:	55                   	push   %ebp
801056a2:	89 e5                	mov    %esp,%ebp
801056a4:	83 ec 18             	sub    $0x18,%esp
  struct file *f;
  int n;
  char *p;

  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
801056a7:	83 ec 04             	sub    $0x4,%esp
801056aa:	8d 45 f4             	lea    -0xc(%ebp),%eax
801056ad:	50                   	push   %eax
801056ae:	6a 00                	push   $0x0
801056b0:	6a 00                	push   $0x0
801056b2:	e8 d1 fe ff ff       	call   80105588 <argfd>
801056b7:	83 c4 10             	add    $0x10,%esp
801056ba:	85 c0                	test   %eax,%eax
801056bc:	78 2e                	js     801056ec <sys_read+0x4b>
801056be:	83 ec 08             	sub    $0x8,%esp
801056c1:	8d 45 f0             	lea    -0x10(%ebp),%eax
801056c4:	50                   	push   %eax
801056c5:	6a 02                	push   $0x2
801056c7:	e8 72 fd ff ff       	call   8010543e <argint>
801056cc:	83 c4 10             	add    $0x10,%esp
801056cf:	85 c0                	test   %eax,%eax
801056d1:	78 19                	js     801056ec <sys_read+0x4b>
801056d3:	8b 45 f0             	mov    -0x10(%ebp),%eax
801056d6:	83 ec 04             	sub    $0x4,%esp
801056d9:	50                   	push   %eax
801056da:	8d 45 ec             	lea    -0x14(%ebp),%eax
801056dd:	50                   	push   %eax
801056de:	6a 01                	push   $0x1
801056e0:	e8 86 fd ff ff       	call   8010546b <argptr>
801056e5:	83 c4 10             	add    $0x10,%esp
801056e8:	85 c0                	test   %eax,%eax
801056ea:	79 07                	jns    801056f3 <sys_read+0x52>
    return -1;
801056ec:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801056f1:	eb 17                	jmp    8010570a <sys_read+0x69>
  return fileread(f, p, n);
801056f3:	8b 4d f0             	mov    -0x10(%ebp),%ecx
801056f6:	8b 55 ec             	mov    -0x14(%ebp),%edx
801056f9:	8b 45 f4             	mov    -0xc(%ebp),%eax
801056fc:	83 ec 04             	sub    $0x4,%esp
801056ff:	51                   	push   %ecx
80105700:	52                   	push   %edx
80105701:	50                   	push   %eax
80105702:	e8 d3 ba ff ff       	call   801011da <fileread>
80105707:	83 c4 10             	add    $0x10,%esp
}
8010570a:	c9                   	leave  
8010570b:	c3                   	ret    

8010570c <sys_write>:

int
sys_write(void)
{
8010570c:	55                   	push   %ebp
8010570d:	89 e5                	mov    %esp,%ebp
8010570f:	83 ec 18             	sub    $0x18,%esp
  struct file *f;
  int n;
  char *p;

  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80105712:	83 ec 04             	sub    $0x4,%esp
80105715:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105718:	50                   	push   %eax
80105719:	6a 00                	push   $0x0
8010571b:	6a 00                	push   $0x0
8010571d:	e8 66 fe ff ff       	call   80105588 <argfd>
80105722:	83 c4 10             	add    $0x10,%esp
80105725:	85 c0                	test   %eax,%eax
80105727:	78 2e                	js     80105757 <sys_write+0x4b>
80105729:	83 ec 08             	sub    $0x8,%esp
8010572c:	8d 45 f0             	lea    -0x10(%ebp),%eax
8010572f:	50                   	push   %eax
80105730:	6a 02                	push   $0x2
80105732:	e8 07 fd ff ff       	call   8010543e <argint>
80105737:	83 c4 10             	add    $0x10,%esp
8010573a:	85 c0                	test   %eax,%eax
8010573c:	78 19                	js     80105757 <sys_write+0x4b>
8010573e:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105741:	83 ec 04             	sub    $0x4,%esp
80105744:	50                   	push   %eax
80105745:	8d 45 ec             	lea    -0x14(%ebp),%eax
80105748:	50                   	push   %eax
80105749:	6a 01                	push   $0x1
8010574b:	e8 1b fd ff ff       	call   8010546b <argptr>
80105750:	83 c4 10             	add    $0x10,%esp
80105753:	85 c0                	test   %eax,%eax
80105755:	79 07                	jns    8010575e <sys_write+0x52>
    return -1;
80105757:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010575c:	eb 17                	jmp    80105775 <sys_write+0x69>
  return filewrite(f, p, n);
8010575e:	8b 4d f0             	mov    -0x10(%ebp),%ecx
80105761:	8b 55 ec             	mov    -0x14(%ebp),%edx
80105764:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105767:	83 ec 04             	sub    $0x4,%esp
8010576a:	51                   	push   %ecx
8010576b:	52                   	push   %edx
8010576c:	50                   	push   %eax
8010576d:	e8 20 bb ff ff       	call   80101292 <filewrite>
80105772:	83 c4 10             	add    $0x10,%esp
}
80105775:	c9                   	leave  
80105776:	c3                   	ret    

80105777 <sys_close>:

int
sys_close(void)
{
80105777:	55                   	push   %ebp
80105778:	89 e5                	mov    %esp,%ebp
8010577a:	83 ec 18             	sub    $0x18,%esp
  int fd;
  struct file *f;

  if(argfd(0, &fd, &f) < 0)
8010577d:	83 ec 04             	sub    $0x4,%esp
80105780:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105783:	50                   	push   %eax
80105784:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105787:	50                   	push   %eax
80105788:	6a 00                	push   $0x0
8010578a:	e8 f9 fd ff ff       	call   80105588 <argfd>
8010578f:	83 c4 10             	add    $0x10,%esp
80105792:	85 c0                	test   %eax,%eax
80105794:	79 07                	jns    8010579d <sys_close+0x26>
    return -1;
80105796:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010579b:	eb 27                	jmp    801057c4 <sys_close+0x4d>
  myproc()->ofile[fd] = 0;
8010579d:	e8 72 e7 ff ff       	call   80103f14 <myproc>
801057a2:	8b 55 f4             	mov    -0xc(%ebp),%edx
801057a5:	83 c2 08             	add    $0x8,%edx
801057a8:	c7 44 90 08 00 00 00 	movl   $0x0,0x8(%eax,%edx,4)
801057af:	00 
  fileclose(f);
801057b0:	8b 45 f0             	mov    -0x10(%ebp),%eax
801057b3:	83 ec 0c             	sub    $0xc,%esp
801057b6:	50                   	push   %eax
801057b7:	e8 df b8 ff ff       	call   8010109b <fileclose>
801057bc:	83 c4 10             	add    $0x10,%esp
  return 0;
801057bf:	b8 00 00 00 00       	mov    $0x0,%eax
}
801057c4:	c9                   	leave  
801057c5:	c3                   	ret    

801057c6 <sys_fstat>:

int
sys_fstat(void)
{
801057c6:	55                   	push   %ebp
801057c7:	89 e5                	mov    %esp,%ebp
801057c9:	83 ec 18             	sub    $0x18,%esp
  struct file *f;
  struct stat *st;

  if(argfd(0, 0, &f) < 0 || argptr(1, (void*)&st, sizeof(*st)) < 0)
801057cc:	83 ec 04             	sub    $0x4,%esp
801057cf:	8d 45 f4             	lea    -0xc(%ebp),%eax
801057d2:	50                   	push   %eax
801057d3:	6a 00                	push   $0x0
801057d5:	6a 00                	push   $0x0
801057d7:	e8 ac fd ff ff       	call   80105588 <argfd>
801057dc:	83 c4 10             	add    $0x10,%esp
801057df:	85 c0                	test   %eax,%eax
801057e1:	78 17                	js     801057fa <sys_fstat+0x34>
801057e3:	83 ec 04             	sub    $0x4,%esp
801057e6:	6a 14                	push   $0x14
801057e8:	8d 45 f0             	lea    -0x10(%ebp),%eax
801057eb:	50                   	push   %eax
801057ec:	6a 01                	push   $0x1
801057ee:	e8 78 fc ff ff       	call   8010546b <argptr>
801057f3:	83 c4 10             	add    $0x10,%esp
801057f6:	85 c0                	test   %eax,%eax
801057f8:	79 07                	jns    80105801 <sys_fstat+0x3b>
    return -1;
801057fa:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801057ff:	eb 13                	jmp    80105814 <sys_fstat+0x4e>
  return filestat(f, st);
80105801:	8b 55 f0             	mov    -0x10(%ebp),%edx
80105804:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105807:	83 ec 08             	sub    $0x8,%esp
8010580a:	52                   	push   %edx
8010580b:	50                   	push   %eax
8010580c:	e8 72 b9 ff ff       	call   80101183 <filestat>
80105811:	83 c4 10             	add    $0x10,%esp
}
80105814:	c9                   	leave  
80105815:	c3                   	ret    

80105816 <sys_link>:

// Create the path new as a link to the same inode as old.
int
sys_link(void)
{
80105816:	55                   	push   %ebp
80105817:	89 e5                	mov    %esp,%ebp
80105819:	83 ec 28             	sub    $0x28,%esp
  char name[DIRSIZ], *new, *old;
  struct inode *dp, *ip;

  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
8010581c:	83 ec 08             	sub    $0x8,%esp
8010581f:	8d 45 d8             	lea    -0x28(%ebp),%eax
80105822:	50                   	push   %eax
80105823:	6a 00                	push   $0x0
80105825:	e8 a9 fc ff ff       	call   801054d3 <argstr>
8010582a:	83 c4 10             	add    $0x10,%esp
8010582d:	85 c0                	test   %eax,%eax
8010582f:	78 15                	js     80105846 <sys_link+0x30>
80105831:	83 ec 08             	sub    $0x8,%esp
80105834:	8d 45 dc             	lea    -0x24(%ebp),%eax
80105837:	50                   	push   %eax
80105838:	6a 01                	push   $0x1
8010583a:	e8 94 fc ff ff       	call   801054d3 <argstr>
8010583f:	83 c4 10             	add    $0x10,%esp
80105842:	85 c0                	test   %eax,%eax
80105844:	79 0a                	jns    80105850 <sys_link+0x3a>
    return -1;
80105846:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010584b:	e9 68 01 00 00       	jmp    801059b8 <sys_link+0x1a2>

  begin_op();
80105850:	e8 cb dc ff ff       	call   80103520 <begin_op>
  if((ip = namei(old)) == 0){
80105855:	8b 45 d8             	mov    -0x28(%ebp),%eax
80105858:	83 ec 0c             	sub    $0xc,%esp
8010585b:	50                   	push   %eax
8010585c:	e8 bc cc ff ff       	call   8010251d <namei>
80105861:	83 c4 10             	add    $0x10,%esp
80105864:	89 45 f4             	mov    %eax,-0xc(%ebp)
80105867:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
8010586b:	75 0f                	jne    8010587c <sys_link+0x66>
    end_op();
8010586d:	e8 3a dd ff ff       	call   801035ac <end_op>
    return -1;
80105872:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105877:	e9 3c 01 00 00       	jmp    801059b8 <sys_link+0x1a2>
  }

  ilock(ip);
8010587c:	83 ec 0c             	sub    $0xc,%esp
8010587f:	ff 75 f4             	push   -0xc(%ebp)
80105882:	e8 63 c1 ff ff       	call   801019ea <ilock>
80105887:	83 c4 10             	add    $0x10,%esp
  if(ip->type == T_DIR){
8010588a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010588d:	0f b7 40 50          	movzwl 0x50(%eax),%eax
80105891:	66 83 f8 01          	cmp    $0x1,%ax
80105895:	75 1d                	jne    801058b4 <sys_link+0x9e>
    iunlockput(ip);
80105897:	83 ec 0c             	sub    $0xc,%esp
8010589a:	ff 75 f4             	push   -0xc(%ebp)
8010589d:	e8 79 c3 ff ff       	call   80101c1b <iunlockput>
801058a2:	83 c4 10             	add    $0x10,%esp
    end_op();
801058a5:	e8 02 dd ff ff       	call   801035ac <end_op>
    return -1;
801058aa:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801058af:	e9 04 01 00 00       	jmp    801059b8 <sys_link+0x1a2>
  }

  ip->nlink++;
801058b4:	8b 45 f4             	mov    -0xc(%ebp),%eax
801058b7:	0f b7 40 56          	movzwl 0x56(%eax),%eax
801058bb:	83 c0 01             	add    $0x1,%eax
801058be:	89 c2                	mov    %eax,%edx
801058c0:	8b 45 f4             	mov    -0xc(%ebp),%eax
801058c3:	66 89 50 56          	mov    %dx,0x56(%eax)
  iupdate(ip);
801058c7:	83 ec 0c             	sub    $0xc,%esp
801058ca:	ff 75 f4             	push   -0xc(%ebp)
801058cd:	e8 3b bf ff ff       	call   8010180d <iupdate>
801058d2:	83 c4 10             	add    $0x10,%esp
  iunlock(ip);
801058d5:	83 ec 0c             	sub    $0xc,%esp
801058d8:	ff 75 f4             	push   -0xc(%ebp)
801058db:	e8 1d c2 ff ff       	call   80101afd <iunlock>
801058e0:	83 c4 10             	add    $0x10,%esp

  if((dp = nameiparent(new, name)) == 0)
801058e3:	8b 45 dc             	mov    -0x24(%ebp),%eax
801058e6:	83 ec 08             	sub    $0x8,%esp
801058e9:	8d 55 e2             	lea    -0x1e(%ebp),%edx
801058ec:	52                   	push   %edx
801058ed:	50                   	push   %eax
801058ee:	e8 46 cc ff ff       	call   80102539 <nameiparent>
801058f3:	83 c4 10             	add    $0x10,%esp
801058f6:	89 45 f0             	mov    %eax,-0x10(%ebp)
801058f9:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
801058fd:	74 71                	je     80105970 <sys_link+0x15a>
    goto bad;
  ilock(dp);
801058ff:	83 ec 0c             	sub    $0xc,%esp
80105902:	ff 75 f0             	push   -0x10(%ebp)
80105905:	e8 e0 c0 ff ff       	call   801019ea <ilock>
8010590a:	83 c4 10             	add    $0x10,%esp
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
8010590d:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105910:	8b 10                	mov    (%eax),%edx
80105912:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105915:	8b 00                	mov    (%eax),%eax
80105917:	39 c2                	cmp    %eax,%edx
80105919:	75 1d                	jne    80105938 <sys_link+0x122>
8010591b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010591e:	8b 40 04             	mov    0x4(%eax),%eax
80105921:	83 ec 04             	sub    $0x4,%esp
80105924:	50                   	push   %eax
80105925:	8d 45 e2             	lea    -0x1e(%ebp),%eax
80105928:	50                   	push   %eax
80105929:	ff 75 f0             	push   -0x10(%ebp)
8010592c:	e8 55 c9 ff ff       	call   80102286 <dirlink>
80105931:	83 c4 10             	add    $0x10,%esp
80105934:	85 c0                	test   %eax,%eax
80105936:	79 10                	jns    80105948 <sys_link+0x132>
    iunlockput(dp);
80105938:	83 ec 0c             	sub    $0xc,%esp
8010593b:	ff 75 f0             	push   -0x10(%ebp)
8010593e:	e8 d8 c2 ff ff       	call   80101c1b <iunlockput>
80105943:	83 c4 10             	add    $0x10,%esp
    goto bad;
80105946:	eb 29                	jmp    80105971 <sys_link+0x15b>
  }
  iunlockput(dp);
80105948:	83 ec 0c             	sub    $0xc,%esp
8010594b:	ff 75 f0             	push   -0x10(%ebp)
8010594e:	e8 c8 c2 ff ff       	call   80101c1b <iunlockput>
80105953:	83 c4 10             	add    $0x10,%esp
  iput(ip);
80105956:	83 ec 0c             	sub    $0xc,%esp
80105959:	ff 75 f4             	push   -0xc(%ebp)
8010595c:	e8 ea c1 ff ff       	call   80101b4b <iput>
80105961:	83 c4 10             	add    $0x10,%esp

  end_op();
80105964:	e8 43 dc ff ff       	call   801035ac <end_op>

  return 0;
80105969:	b8 00 00 00 00       	mov    $0x0,%eax
8010596e:	eb 48                	jmp    801059b8 <sys_link+0x1a2>
    goto bad;
80105970:	90                   	nop

bad:
  ilock(ip);
80105971:	83 ec 0c             	sub    $0xc,%esp
80105974:	ff 75 f4             	push   -0xc(%ebp)
80105977:	e8 6e c0 ff ff       	call   801019ea <ilock>
8010597c:	83 c4 10             	add    $0x10,%esp
  ip->nlink--;
8010597f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105982:	0f b7 40 56          	movzwl 0x56(%eax),%eax
80105986:	83 e8 01             	sub    $0x1,%eax
80105989:	89 c2                	mov    %eax,%edx
8010598b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010598e:	66 89 50 56          	mov    %dx,0x56(%eax)
  iupdate(ip);
80105992:	83 ec 0c             	sub    $0xc,%esp
80105995:	ff 75 f4             	push   -0xc(%ebp)
80105998:	e8 70 be ff ff       	call   8010180d <iupdate>
8010599d:	83 c4 10             	add    $0x10,%esp
  iunlockput(ip);
801059a0:	83 ec 0c             	sub    $0xc,%esp
801059a3:	ff 75 f4             	push   -0xc(%ebp)
801059a6:	e8 70 c2 ff ff       	call   80101c1b <iunlockput>
801059ab:	83 c4 10             	add    $0x10,%esp
  end_op();
801059ae:	e8 f9 db ff ff       	call   801035ac <end_op>
  return -1;
801059b3:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801059b8:	c9                   	leave  
801059b9:	c3                   	ret    

801059ba <isdirempty>:

// Is the directory dp empty except for "." and ".." ?
static int
isdirempty(struct inode *dp)
{
801059ba:	55                   	push   %ebp
801059bb:	89 e5                	mov    %esp,%ebp
801059bd:	83 ec 28             	sub    $0x28,%esp
  int off;
  struct dirent de;

  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
801059c0:	c7 45 f4 20 00 00 00 	movl   $0x20,-0xc(%ebp)
801059c7:	eb 40                	jmp    80105a09 <isdirempty+0x4f>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
801059c9:	8b 45 f4             	mov    -0xc(%ebp),%eax
801059cc:	6a 10                	push   $0x10
801059ce:	50                   	push   %eax
801059cf:	8d 45 e4             	lea    -0x1c(%ebp),%eax
801059d2:	50                   	push   %eax
801059d3:	ff 75 08             	push   0x8(%ebp)
801059d6:	e8 fb c4 ff ff       	call   80101ed6 <readi>
801059db:	83 c4 10             	add    $0x10,%esp
801059de:	83 f8 10             	cmp    $0x10,%eax
801059e1:	74 0d                	je     801059f0 <isdirempty+0x36>
      panic("isdirempty: readi");
801059e3:	83 ec 0c             	sub    $0xc,%esp
801059e6:	68 18 ab 10 80       	push   $0x8010ab18
801059eb:	e8 b9 ab ff ff       	call   801005a9 <panic>
    if(de.inum != 0)
801059f0:	0f b7 45 e4          	movzwl -0x1c(%ebp),%eax
801059f4:	66 85 c0             	test   %ax,%ax
801059f7:	74 07                	je     80105a00 <isdirempty+0x46>
      return 0;
801059f9:	b8 00 00 00 00       	mov    $0x0,%eax
801059fe:	eb 1b                	jmp    80105a1b <isdirempty+0x61>
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
80105a00:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105a03:	83 c0 10             	add    $0x10,%eax
80105a06:	89 45 f4             	mov    %eax,-0xc(%ebp)
80105a09:	8b 45 08             	mov    0x8(%ebp),%eax
80105a0c:	8b 50 58             	mov    0x58(%eax),%edx
80105a0f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105a12:	39 c2                	cmp    %eax,%edx
80105a14:	77 b3                	ja     801059c9 <isdirempty+0xf>
  }
  return 1;
80105a16:	b8 01 00 00 00       	mov    $0x1,%eax
}
80105a1b:	c9                   	leave  
80105a1c:	c3                   	ret    

80105a1d <sys_unlink>:

//PAGEBREAK!
int
sys_unlink(void)
{
80105a1d:	55                   	push   %ebp
80105a1e:	89 e5                	mov    %esp,%ebp
80105a20:	83 ec 38             	sub    $0x38,%esp
  struct inode *ip, *dp;
  struct dirent de;
  char name[DIRSIZ], *path;
  uint off;

  if(argstr(0, &path) < 0)
80105a23:	83 ec 08             	sub    $0x8,%esp
80105a26:	8d 45 cc             	lea    -0x34(%ebp),%eax
80105a29:	50                   	push   %eax
80105a2a:	6a 00                	push   $0x0
80105a2c:	e8 a2 fa ff ff       	call   801054d3 <argstr>
80105a31:	83 c4 10             	add    $0x10,%esp
80105a34:	85 c0                	test   %eax,%eax
80105a36:	79 0a                	jns    80105a42 <sys_unlink+0x25>
    return -1;
80105a38:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105a3d:	e9 bf 01 00 00       	jmp    80105c01 <sys_unlink+0x1e4>

  begin_op();
80105a42:	e8 d9 da ff ff       	call   80103520 <begin_op>
  if((dp = nameiparent(path, name)) == 0){
80105a47:	8b 45 cc             	mov    -0x34(%ebp),%eax
80105a4a:	83 ec 08             	sub    $0x8,%esp
80105a4d:	8d 55 d2             	lea    -0x2e(%ebp),%edx
80105a50:	52                   	push   %edx
80105a51:	50                   	push   %eax
80105a52:	e8 e2 ca ff ff       	call   80102539 <nameiparent>
80105a57:	83 c4 10             	add    $0x10,%esp
80105a5a:	89 45 f4             	mov    %eax,-0xc(%ebp)
80105a5d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80105a61:	75 0f                	jne    80105a72 <sys_unlink+0x55>
    end_op();
80105a63:	e8 44 db ff ff       	call   801035ac <end_op>
    return -1;
80105a68:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105a6d:	e9 8f 01 00 00       	jmp    80105c01 <sys_unlink+0x1e4>
  }

  ilock(dp);
80105a72:	83 ec 0c             	sub    $0xc,%esp
80105a75:	ff 75 f4             	push   -0xc(%ebp)
80105a78:	e8 6d bf ff ff       	call   801019ea <ilock>
80105a7d:	83 c4 10             	add    $0x10,%esp

  // Cannot unlink "." or "..".
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
80105a80:	83 ec 08             	sub    $0x8,%esp
80105a83:	68 2a ab 10 80       	push   $0x8010ab2a
80105a88:	8d 45 d2             	lea    -0x2e(%ebp),%eax
80105a8b:	50                   	push   %eax
80105a8c:	e8 20 c7 ff ff       	call   801021b1 <namecmp>
80105a91:	83 c4 10             	add    $0x10,%esp
80105a94:	85 c0                	test   %eax,%eax
80105a96:	0f 84 49 01 00 00    	je     80105be5 <sys_unlink+0x1c8>
80105a9c:	83 ec 08             	sub    $0x8,%esp
80105a9f:	68 2c ab 10 80       	push   $0x8010ab2c
80105aa4:	8d 45 d2             	lea    -0x2e(%ebp),%eax
80105aa7:	50                   	push   %eax
80105aa8:	e8 04 c7 ff ff       	call   801021b1 <namecmp>
80105aad:	83 c4 10             	add    $0x10,%esp
80105ab0:	85 c0                	test   %eax,%eax
80105ab2:	0f 84 2d 01 00 00    	je     80105be5 <sys_unlink+0x1c8>
    goto bad;

  if((ip = dirlookup(dp, name, &off)) == 0)
80105ab8:	83 ec 04             	sub    $0x4,%esp
80105abb:	8d 45 c8             	lea    -0x38(%ebp),%eax
80105abe:	50                   	push   %eax
80105abf:	8d 45 d2             	lea    -0x2e(%ebp),%eax
80105ac2:	50                   	push   %eax
80105ac3:	ff 75 f4             	push   -0xc(%ebp)
80105ac6:	e8 01 c7 ff ff       	call   801021cc <dirlookup>
80105acb:	83 c4 10             	add    $0x10,%esp
80105ace:	89 45 f0             	mov    %eax,-0x10(%ebp)
80105ad1:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80105ad5:	0f 84 0d 01 00 00    	je     80105be8 <sys_unlink+0x1cb>
    goto bad;
  ilock(ip);
80105adb:	83 ec 0c             	sub    $0xc,%esp
80105ade:	ff 75 f0             	push   -0x10(%ebp)
80105ae1:	e8 04 bf ff ff       	call   801019ea <ilock>
80105ae6:	83 c4 10             	add    $0x10,%esp

  if(ip->nlink < 1)
80105ae9:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105aec:	0f b7 40 56          	movzwl 0x56(%eax),%eax
80105af0:	66 85 c0             	test   %ax,%ax
80105af3:	7f 0d                	jg     80105b02 <sys_unlink+0xe5>
    panic("unlink: nlink < 1");
80105af5:	83 ec 0c             	sub    $0xc,%esp
80105af8:	68 2f ab 10 80       	push   $0x8010ab2f
80105afd:	e8 a7 aa ff ff       	call   801005a9 <panic>
  if(ip->type == T_DIR && !isdirempty(ip)){
80105b02:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105b05:	0f b7 40 50          	movzwl 0x50(%eax),%eax
80105b09:	66 83 f8 01          	cmp    $0x1,%ax
80105b0d:	75 25                	jne    80105b34 <sys_unlink+0x117>
80105b0f:	83 ec 0c             	sub    $0xc,%esp
80105b12:	ff 75 f0             	push   -0x10(%ebp)
80105b15:	e8 a0 fe ff ff       	call   801059ba <isdirempty>
80105b1a:	83 c4 10             	add    $0x10,%esp
80105b1d:	85 c0                	test   %eax,%eax
80105b1f:	75 13                	jne    80105b34 <sys_unlink+0x117>
    iunlockput(ip);
80105b21:	83 ec 0c             	sub    $0xc,%esp
80105b24:	ff 75 f0             	push   -0x10(%ebp)
80105b27:	e8 ef c0 ff ff       	call   80101c1b <iunlockput>
80105b2c:	83 c4 10             	add    $0x10,%esp
    goto bad;
80105b2f:	e9 b5 00 00 00       	jmp    80105be9 <sys_unlink+0x1cc>
  }

  memset(&de, 0, sizeof(de));
80105b34:	83 ec 04             	sub    $0x4,%esp
80105b37:	6a 10                	push   $0x10
80105b39:	6a 00                	push   $0x0
80105b3b:	8d 45 e0             	lea    -0x20(%ebp),%eax
80105b3e:	50                   	push   %eax
80105b3f:	e8 cf f5 ff ff       	call   80105113 <memset>
80105b44:	83 c4 10             	add    $0x10,%esp
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80105b47:	8b 45 c8             	mov    -0x38(%ebp),%eax
80105b4a:	6a 10                	push   $0x10
80105b4c:	50                   	push   %eax
80105b4d:	8d 45 e0             	lea    -0x20(%ebp),%eax
80105b50:	50                   	push   %eax
80105b51:	ff 75 f4             	push   -0xc(%ebp)
80105b54:	e8 d2 c4 ff ff       	call   8010202b <writei>
80105b59:	83 c4 10             	add    $0x10,%esp
80105b5c:	83 f8 10             	cmp    $0x10,%eax
80105b5f:	74 0d                	je     80105b6e <sys_unlink+0x151>
    panic("unlink: writei");
80105b61:	83 ec 0c             	sub    $0xc,%esp
80105b64:	68 41 ab 10 80       	push   $0x8010ab41
80105b69:	e8 3b aa ff ff       	call   801005a9 <panic>
  if(ip->type == T_DIR){
80105b6e:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105b71:	0f b7 40 50          	movzwl 0x50(%eax),%eax
80105b75:	66 83 f8 01          	cmp    $0x1,%ax
80105b79:	75 21                	jne    80105b9c <sys_unlink+0x17f>
    dp->nlink--;
80105b7b:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105b7e:	0f b7 40 56          	movzwl 0x56(%eax),%eax
80105b82:	83 e8 01             	sub    $0x1,%eax
80105b85:	89 c2                	mov    %eax,%edx
80105b87:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105b8a:	66 89 50 56          	mov    %dx,0x56(%eax)
    iupdate(dp);
80105b8e:	83 ec 0c             	sub    $0xc,%esp
80105b91:	ff 75 f4             	push   -0xc(%ebp)
80105b94:	e8 74 bc ff ff       	call   8010180d <iupdate>
80105b99:	83 c4 10             	add    $0x10,%esp
  }
  iunlockput(dp);
80105b9c:	83 ec 0c             	sub    $0xc,%esp
80105b9f:	ff 75 f4             	push   -0xc(%ebp)
80105ba2:	e8 74 c0 ff ff       	call   80101c1b <iunlockput>
80105ba7:	83 c4 10             	add    $0x10,%esp

  ip->nlink--;
80105baa:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105bad:	0f b7 40 56          	movzwl 0x56(%eax),%eax
80105bb1:	83 e8 01             	sub    $0x1,%eax
80105bb4:	89 c2                	mov    %eax,%edx
80105bb6:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105bb9:	66 89 50 56          	mov    %dx,0x56(%eax)
  iupdate(ip);
80105bbd:	83 ec 0c             	sub    $0xc,%esp
80105bc0:	ff 75 f0             	push   -0x10(%ebp)
80105bc3:	e8 45 bc ff ff       	call   8010180d <iupdate>
80105bc8:	83 c4 10             	add    $0x10,%esp
  iunlockput(ip);
80105bcb:	83 ec 0c             	sub    $0xc,%esp
80105bce:	ff 75 f0             	push   -0x10(%ebp)
80105bd1:	e8 45 c0 ff ff       	call   80101c1b <iunlockput>
80105bd6:	83 c4 10             	add    $0x10,%esp

  end_op();
80105bd9:	e8 ce d9 ff ff       	call   801035ac <end_op>

  return 0;
80105bde:	b8 00 00 00 00       	mov    $0x0,%eax
80105be3:	eb 1c                	jmp    80105c01 <sys_unlink+0x1e4>
    goto bad;
80105be5:	90                   	nop
80105be6:	eb 01                	jmp    80105be9 <sys_unlink+0x1cc>
    goto bad;
80105be8:	90                   	nop

bad:
  iunlockput(dp);
80105be9:	83 ec 0c             	sub    $0xc,%esp
80105bec:	ff 75 f4             	push   -0xc(%ebp)
80105bef:	e8 27 c0 ff ff       	call   80101c1b <iunlockput>
80105bf4:	83 c4 10             	add    $0x10,%esp
  end_op();
80105bf7:	e8 b0 d9 ff ff       	call   801035ac <end_op>
  return -1;
80105bfc:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105c01:	c9                   	leave  
80105c02:	c3                   	ret    

80105c03 <create>:

static struct inode*
create(char *path, short type, short major, short minor)
{
80105c03:	55                   	push   %ebp
80105c04:	89 e5                	mov    %esp,%ebp
80105c06:	83 ec 38             	sub    $0x38,%esp
80105c09:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80105c0c:	8b 55 10             	mov    0x10(%ebp),%edx
80105c0f:	8b 45 14             	mov    0x14(%ebp),%eax
80105c12:	66 89 4d d4          	mov    %cx,-0x2c(%ebp)
80105c16:	66 89 55 d0          	mov    %dx,-0x30(%ebp)
80105c1a:	66 89 45 cc          	mov    %ax,-0x34(%ebp)
  uint off;
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
80105c1e:	83 ec 08             	sub    $0x8,%esp
80105c21:	8d 45 de             	lea    -0x22(%ebp),%eax
80105c24:	50                   	push   %eax
80105c25:	ff 75 08             	push   0x8(%ebp)
80105c28:	e8 0c c9 ff ff       	call   80102539 <nameiparent>
80105c2d:	83 c4 10             	add    $0x10,%esp
80105c30:	89 45 f4             	mov    %eax,-0xc(%ebp)
80105c33:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80105c37:	75 0a                	jne    80105c43 <create+0x40>
    return 0;
80105c39:	b8 00 00 00 00       	mov    $0x0,%eax
80105c3e:	e9 90 01 00 00       	jmp    80105dd3 <create+0x1d0>
  ilock(dp);
80105c43:	83 ec 0c             	sub    $0xc,%esp
80105c46:	ff 75 f4             	push   -0xc(%ebp)
80105c49:	e8 9c bd ff ff       	call   801019ea <ilock>
80105c4e:	83 c4 10             	add    $0x10,%esp

  if((ip = dirlookup(dp, name, &off)) != 0){
80105c51:	83 ec 04             	sub    $0x4,%esp
80105c54:	8d 45 ec             	lea    -0x14(%ebp),%eax
80105c57:	50                   	push   %eax
80105c58:	8d 45 de             	lea    -0x22(%ebp),%eax
80105c5b:	50                   	push   %eax
80105c5c:	ff 75 f4             	push   -0xc(%ebp)
80105c5f:	e8 68 c5 ff ff       	call   801021cc <dirlookup>
80105c64:	83 c4 10             	add    $0x10,%esp
80105c67:	89 45 f0             	mov    %eax,-0x10(%ebp)
80105c6a:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80105c6e:	74 50                	je     80105cc0 <create+0xbd>
    iunlockput(dp);
80105c70:	83 ec 0c             	sub    $0xc,%esp
80105c73:	ff 75 f4             	push   -0xc(%ebp)
80105c76:	e8 a0 bf ff ff       	call   80101c1b <iunlockput>
80105c7b:	83 c4 10             	add    $0x10,%esp
    ilock(ip);
80105c7e:	83 ec 0c             	sub    $0xc,%esp
80105c81:	ff 75 f0             	push   -0x10(%ebp)
80105c84:	e8 61 bd ff ff       	call   801019ea <ilock>
80105c89:	83 c4 10             	add    $0x10,%esp
    if(type == T_FILE && ip->type == T_FILE)
80105c8c:	66 83 7d d4 02       	cmpw   $0x2,-0x2c(%ebp)
80105c91:	75 15                	jne    80105ca8 <create+0xa5>
80105c93:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105c96:	0f b7 40 50          	movzwl 0x50(%eax),%eax
80105c9a:	66 83 f8 02          	cmp    $0x2,%ax
80105c9e:	75 08                	jne    80105ca8 <create+0xa5>
      return ip;
80105ca0:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105ca3:	e9 2b 01 00 00       	jmp    80105dd3 <create+0x1d0>
    iunlockput(ip);
80105ca8:	83 ec 0c             	sub    $0xc,%esp
80105cab:	ff 75 f0             	push   -0x10(%ebp)
80105cae:	e8 68 bf ff ff       	call   80101c1b <iunlockput>
80105cb3:	83 c4 10             	add    $0x10,%esp
    return 0;
80105cb6:	b8 00 00 00 00       	mov    $0x0,%eax
80105cbb:	e9 13 01 00 00       	jmp    80105dd3 <create+0x1d0>
  }

  if((ip = ialloc(dp->dev, type)) == 0)
80105cc0:	0f bf 55 d4          	movswl -0x2c(%ebp),%edx
80105cc4:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105cc7:	8b 00                	mov    (%eax),%eax
80105cc9:	83 ec 08             	sub    $0x8,%esp
80105ccc:	52                   	push   %edx
80105ccd:	50                   	push   %eax
80105cce:	e8 63 ba ff ff       	call   80101736 <ialloc>
80105cd3:	83 c4 10             	add    $0x10,%esp
80105cd6:	89 45 f0             	mov    %eax,-0x10(%ebp)
80105cd9:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80105cdd:	75 0d                	jne    80105cec <create+0xe9>
    panic("create: ialloc");
80105cdf:	83 ec 0c             	sub    $0xc,%esp
80105ce2:	68 50 ab 10 80       	push   $0x8010ab50
80105ce7:	e8 bd a8 ff ff       	call   801005a9 <panic>

  ilock(ip);
80105cec:	83 ec 0c             	sub    $0xc,%esp
80105cef:	ff 75 f0             	push   -0x10(%ebp)
80105cf2:	e8 f3 bc ff ff       	call   801019ea <ilock>
80105cf7:	83 c4 10             	add    $0x10,%esp
  ip->major = major;
80105cfa:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105cfd:	0f b7 55 d0          	movzwl -0x30(%ebp),%edx
80105d01:	66 89 50 52          	mov    %dx,0x52(%eax)
  ip->minor = minor;
80105d05:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105d08:	0f b7 55 cc          	movzwl -0x34(%ebp),%edx
80105d0c:	66 89 50 54          	mov    %dx,0x54(%eax)
  ip->nlink = 1;
80105d10:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105d13:	66 c7 40 56 01 00    	movw   $0x1,0x56(%eax)
  iupdate(ip);
80105d19:	83 ec 0c             	sub    $0xc,%esp
80105d1c:	ff 75 f0             	push   -0x10(%ebp)
80105d1f:	e8 e9 ba ff ff       	call   8010180d <iupdate>
80105d24:	83 c4 10             	add    $0x10,%esp

  if(type == T_DIR){  // Create . and .. entries.
80105d27:	66 83 7d d4 01       	cmpw   $0x1,-0x2c(%ebp)
80105d2c:	75 6a                	jne    80105d98 <create+0x195>
    dp->nlink++;  // for ".."
80105d2e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105d31:	0f b7 40 56          	movzwl 0x56(%eax),%eax
80105d35:	83 c0 01             	add    $0x1,%eax
80105d38:	89 c2                	mov    %eax,%edx
80105d3a:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105d3d:	66 89 50 56          	mov    %dx,0x56(%eax)
    iupdate(dp);
80105d41:	83 ec 0c             	sub    $0xc,%esp
80105d44:	ff 75 f4             	push   -0xc(%ebp)
80105d47:	e8 c1 ba ff ff       	call   8010180d <iupdate>
80105d4c:	83 c4 10             	add    $0x10,%esp
    // No ip->nlink++ for ".": avoid cyclic ref count.
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
80105d4f:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105d52:	8b 40 04             	mov    0x4(%eax),%eax
80105d55:	83 ec 04             	sub    $0x4,%esp
80105d58:	50                   	push   %eax
80105d59:	68 2a ab 10 80       	push   $0x8010ab2a
80105d5e:	ff 75 f0             	push   -0x10(%ebp)
80105d61:	e8 20 c5 ff ff       	call   80102286 <dirlink>
80105d66:	83 c4 10             	add    $0x10,%esp
80105d69:	85 c0                	test   %eax,%eax
80105d6b:	78 1e                	js     80105d8b <create+0x188>
80105d6d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105d70:	8b 40 04             	mov    0x4(%eax),%eax
80105d73:	83 ec 04             	sub    $0x4,%esp
80105d76:	50                   	push   %eax
80105d77:	68 2c ab 10 80       	push   $0x8010ab2c
80105d7c:	ff 75 f0             	push   -0x10(%ebp)
80105d7f:	e8 02 c5 ff ff       	call   80102286 <dirlink>
80105d84:	83 c4 10             	add    $0x10,%esp
80105d87:	85 c0                	test   %eax,%eax
80105d89:	79 0d                	jns    80105d98 <create+0x195>
      panic("create dots");
80105d8b:	83 ec 0c             	sub    $0xc,%esp
80105d8e:	68 5f ab 10 80       	push   $0x8010ab5f
80105d93:	e8 11 a8 ff ff       	call   801005a9 <panic>
  }

  if(dirlink(dp, name, ip->inum) < 0)
80105d98:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105d9b:	8b 40 04             	mov    0x4(%eax),%eax
80105d9e:	83 ec 04             	sub    $0x4,%esp
80105da1:	50                   	push   %eax
80105da2:	8d 45 de             	lea    -0x22(%ebp),%eax
80105da5:	50                   	push   %eax
80105da6:	ff 75 f4             	push   -0xc(%ebp)
80105da9:	e8 d8 c4 ff ff       	call   80102286 <dirlink>
80105dae:	83 c4 10             	add    $0x10,%esp
80105db1:	85 c0                	test   %eax,%eax
80105db3:	79 0d                	jns    80105dc2 <create+0x1bf>
    panic("create: dirlink");
80105db5:	83 ec 0c             	sub    $0xc,%esp
80105db8:	68 6b ab 10 80       	push   $0x8010ab6b
80105dbd:	e8 e7 a7 ff ff       	call   801005a9 <panic>

  iunlockput(dp);
80105dc2:	83 ec 0c             	sub    $0xc,%esp
80105dc5:	ff 75 f4             	push   -0xc(%ebp)
80105dc8:	e8 4e be ff ff       	call   80101c1b <iunlockput>
80105dcd:	83 c4 10             	add    $0x10,%esp

  return ip;
80105dd0:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
80105dd3:	c9                   	leave  
80105dd4:	c3                   	ret    

80105dd5 <sys_open>:

int
sys_open(void)
{
80105dd5:	55                   	push   %ebp
80105dd6:	89 e5                	mov    %esp,%ebp
80105dd8:	83 ec 28             	sub    $0x28,%esp
  char *path;
  int fd, omode;
  struct file *f;
  struct inode *ip;

  if(argstr(0, &path) < 0 || argint(1, &omode) < 0)
80105ddb:	83 ec 08             	sub    $0x8,%esp
80105dde:	8d 45 e8             	lea    -0x18(%ebp),%eax
80105de1:	50                   	push   %eax
80105de2:	6a 00                	push   $0x0
80105de4:	e8 ea f6 ff ff       	call   801054d3 <argstr>
80105de9:	83 c4 10             	add    $0x10,%esp
80105dec:	85 c0                	test   %eax,%eax
80105dee:	78 15                	js     80105e05 <sys_open+0x30>
80105df0:	83 ec 08             	sub    $0x8,%esp
80105df3:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80105df6:	50                   	push   %eax
80105df7:	6a 01                	push   $0x1
80105df9:	e8 40 f6 ff ff       	call   8010543e <argint>
80105dfe:	83 c4 10             	add    $0x10,%esp
80105e01:	85 c0                	test   %eax,%eax
80105e03:	79 0a                	jns    80105e0f <sys_open+0x3a>
    return -1;
80105e05:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105e0a:	e9 61 01 00 00       	jmp    80105f70 <sys_open+0x19b>

  begin_op();
80105e0f:	e8 0c d7 ff ff       	call   80103520 <begin_op>

  if(omode & O_CREATE){
80105e14:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80105e17:	25 00 02 00 00       	and    $0x200,%eax
80105e1c:	85 c0                	test   %eax,%eax
80105e1e:	74 2a                	je     80105e4a <sys_open+0x75>
    ip = create(path, T_FILE, 0, 0);
80105e20:	8b 45 e8             	mov    -0x18(%ebp),%eax
80105e23:	6a 00                	push   $0x0
80105e25:	6a 00                	push   $0x0
80105e27:	6a 02                	push   $0x2
80105e29:	50                   	push   %eax
80105e2a:	e8 d4 fd ff ff       	call   80105c03 <create>
80105e2f:	83 c4 10             	add    $0x10,%esp
80105e32:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(ip == 0){
80105e35:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80105e39:	75 75                	jne    80105eb0 <sys_open+0xdb>
      end_op();
80105e3b:	e8 6c d7 ff ff       	call   801035ac <end_op>
      return -1;
80105e40:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105e45:	e9 26 01 00 00       	jmp    80105f70 <sys_open+0x19b>
    }
  } else {
    if((ip = namei(path)) == 0){
80105e4a:	8b 45 e8             	mov    -0x18(%ebp),%eax
80105e4d:	83 ec 0c             	sub    $0xc,%esp
80105e50:	50                   	push   %eax
80105e51:	e8 c7 c6 ff ff       	call   8010251d <namei>
80105e56:	83 c4 10             	add    $0x10,%esp
80105e59:	89 45 f4             	mov    %eax,-0xc(%ebp)
80105e5c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80105e60:	75 0f                	jne    80105e71 <sys_open+0x9c>
      end_op();
80105e62:	e8 45 d7 ff ff       	call   801035ac <end_op>
      return -1;
80105e67:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105e6c:	e9 ff 00 00 00       	jmp    80105f70 <sys_open+0x19b>
    }
    ilock(ip);
80105e71:	83 ec 0c             	sub    $0xc,%esp
80105e74:	ff 75 f4             	push   -0xc(%ebp)
80105e77:	e8 6e bb ff ff       	call   801019ea <ilock>
80105e7c:	83 c4 10             	add    $0x10,%esp
    if(ip->type == T_DIR && omode != O_RDONLY){
80105e7f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105e82:	0f b7 40 50          	movzwl 0x50(%eax),%eax
80105e86:	66 83 f8 01          	cmp    $0x1,%ax
80105e8a:	75 24                	jne    80105eb0 <sys_open+0xdb>
80105e8c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80105e8f:	85 c0                	test   %eax,%eax
80105e91:	74 1d                	je     80105eb0 <sys_open+0xdb>
      iunlockput(ip);
80105e93:	83 ec 0c             	sub    $0xc,%esp
80105e96:	ff 75 f4             	push   -0xc(%ebp)
80105e99:	e8 7d bd ff ff       	call   80101c1b <iunlockput>
80105e9e:	83 c4 10             	add    $0x10,%esp
      end_op();
80105ea1:	e8 06 d7 ff ff       	call   801035ac <end_op>
      return -1;
80105ea6:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105eab:	e9 c0 00 00 00       	jmp    80105f70 <sys_open+0x19b>
    }
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
80105eb0:	e8 28 b1 ff ff       	call   80100fdd <filealloc>
80105eb5:	89 45 f0             	mov    %eax,-0x10(%ebp)
80105eb8:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80105ebc:	74 17                	je     80105ed5 <sys_open+0x100>
80105ebe:	83 ec 0c             	sub    $0xc,%esp
80105ec1:	ff 75 f0             	push   -0x10(%ebp)
80105ec4:	e8 33 f7 ff ff       	call   801055fc <fdalloc>
80105ec9:	83 c4 10             	add    $0x10,%esp
80105ecc:	89 45 ec             	mov    %eax,-0x14(%ebp)
80105ecf:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
80105ed3:	79 2e                	jns    80105f03 <sys_open+0x12e>
    if(f)
80105ed5:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80105ed9:	74 0e                	je     80105ee9 <sys_open+0x114>
      fileclose(f);
80105edb:	83 ec 0c             	sub    $0xc,%esp
80105ede:	ff 75 f0             	push   -0x10(%ebp)
80105ee1:	e8 b5 b1 ff ff       	call   8010109b <fileclose>
80105ee6:	83 c4 10             	add    $0x10,%esp
    iunlockput(ip);
80105ee9:	83 ec 0c             	sub    $0xc,%esp
80105eec:	ff 75 f4             	push   -0xc(%ebp)
80105eef:	e8 27 bd ff ff       	call   80101c1b <iunlockput>
80105ef4:	83 c4 10             	add    $0x10,%esp
    end_op();
80105ef7:	e8 b0 d6 ff ff       	call   801035ac <end_op>
    return -1;
80105efc:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105f01:	eb 6d                	jmp    80105f70 <sys_open+0x19b>
  }
  iunlock(ip);
80105f03:	83 ec 0c             	sub    $0xc,%esp
80105f06:	ff 75 f4             	push   -0xc(%ebp)
80105f09:	e8 ef bb ff ff       	call   80101afd <iunlock>
80105f0e:	83 c4 10             	add    $0x10,%esp
  end_op();
80105f11:	e8 96 d6 ff ff       	call   801035ac <end_op>

  f->type = FD_INODE;
80105f16:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105f19:	c7 00 02 00 00 00    	movl   $0x2,(%eax)
  f->ip = ip;
80105f1f:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105f22:	8b 55 f4             	mov    -0xc(%ebp),%edx
80105f25:	89 50 10             	mov    %edx,0x10(%eax)
  f->off = 0;
80105f28:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105f2b:	c7 40 14 00 00 00 00 	movl   $0x0,0x14(%eax)
  f->readable = !(omode & O_WRONLY);
80105f32:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80105f35:	83 e0 01             	and    $0x1,%eax
80105f38:	85 c0                	test   %eax,%eax
80105f3a:	0f 94 c0             	sete   %al
80105f3d:	89 c2                	mov    %eax,%edx
80105f3f:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105f42:	88 50 08             	mov    %dl,0x8(%eax)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
80105f45:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80105f48:	83 e0 01             	and    $0x1,%eax
80105f4b:	85 c0                	test   %eax,%eax
80105f4d:	75 0a                	jne    80105f59 <sys_open+0x184>
80105f4f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80105f52:	83 e0 02             	and    $0x2,%eax
80105f55:	85 c0                	test   %eax,%eax
80105f57:	74 07                	je     80105f60 <sys_open+0x18b>
80105f59:	b8 01 00 00 00       	mov    $0x1,%eax
80105f5e:	eb 05                	jmp    80105f65 <sys_open+0x190>
80105f60:	b8 00 00 00 00       	mov    $0x0,%eax
80105f65:	89 c2                	mov    %eax,%edx
80105f67:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105f6a:	88 50 09             	mov    %dl,0x9(%eax)
  return fd;
80105f6d:	8b 45 ec             	mov    -0x14(%ebp),%eax
}
80105f70:	c9                   	leave  
80105f71:	c3                   	ret    

80105f72 <sys_mkdir>:

int
sys_mkdir(void)
{
80105f72:	55                   	push   %ebp
80105f73:	89 e5                	mov    %esp,%ebp
80105f75:	83 ec 18             	sub    $0x18,%esp
  char *path;
  struct inode *ip;

  begin_op();
80105f78:	e8 a3 d5 ff ff       	call   80103520 <begin_op>
  if(argstr(0, &path) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
80105f7d:	83 ec 08             	sub    $0x8,%esp
80105f80:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105f83:	50                   	push   %eax
80105f84:	6a 00                	push   $0x0
80105f86:	e8 48 f5 ff ff       	call   801054d3 <argstr>
80105f8b:	83 c4 10             	add    $0x10,%esp
80105f8e:	85 c0                	test   %eax,%eax
80105f90:	78 1b                	js     80105fad <sys_mkdir+0x3b>
80105f92:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105f95:	6a 00                	push   $0x0
80105f97:	6a 00                	push   $0x0
80105f99:	6a 01                	push   $0x1
80105f9b:	50                   	push   %eax
80105f9c:	e8 62 fc ff ff       	call   80105c03 <create>
80105fa1:	83 c4 10             	add    $0x10,%esp
80105fa4:	89 45 f4             	mov    %eax,-0xc(%ebp)
80105fa7:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80105fab:	75 0c                	jne    80105fb9 <sys_mkdir+0x47>
    end_op();
80105fad:	e8 fa d5 ff ff       	call   801035ac <end_op>
    return -1;
80105fb2:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105fb7:	eb 18                	jmp    80105fd1 <sys_mkdir+0x5f>
  }
  iunlockput(ip);
80105fb9:	83 ec 0c             	sub    $0xc,%esp
80105fbc:	ff 75 f4             	push   -0xc(%ebp)
80105fbf:	e8 57 bc ff ff       	call   80101c1b <iunlockput>
80105fc4:	83 c4 10             	add    $0x10,%esp
  end_op();
80105fc7:	e8 e0 d5 ff ff       	call   801035ac <end_op>
  return 0;
80105fcc:	b8 00 00 00 00       	mov    $0x0,%eax
}
80105fd1:	c9                   	leave  
80105fd2:	c3                   	ret    

80105fd3 <sys_mknod>:

int
sys_mknod(void)
{
80105fd3:	55                   	push   %ebp
80105fd4:	89 e5                	mov    %esp,%ebp
80105fd6:	83 ec 18             	sub    $0x18,%esp
  struct inode *ip;
  char *path;
  int major, minor;

  begin_op();
80105fd9:	e8 42 d5 ff ff       	call   80103520 <begin_op>
  if((argstr(0, &path)) < 0 ||
80105fde:	83 ec 08             	sub    $0x8,%esp
80105fe1:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105fe4:	50                   	push   %eax
80105fe5:	6a 00                	push   $0x0
80105fe7:	e8 e7 f4 ff ff       	call   801054d3 <argstr>
80105fec:	83 c4 10             	add    $0x10,%esp
80105fef:	85 c0                	test   %eax,%eax
80105ff1:	78 4f                	js     80106042 <sys_mknod+0x6f>
     argint(1, &major) < 0 ||
80105ff3:	83 ec 08             	sub    $0x8,%esp
80105ff6:	8d 45 ec             	lea    -0x14(%ebp),%eax
80105ff9:	50                   	push   %eax
80105ffa:	6a 01                	push   $0x1
80105ffc:	e8 3d f4 ff ff       	call   8010543e <argint>
80106001:	83 c4 10             	add    $0x10,%esp
  if((argstr(0, &path)) < 0 ||
80106004:	85 c0                	test   %eax,%eax
80106006:	78 3a                	js     80106042 <sys_mknod+0x6f>
     argint(2, &minor) < 0 ||
80106008:	83 ec 08             	sub    $0x8,%esp
8010600b:	8d 45 e8             	lea    -0x18(%ebp),%eax
8010600e:	50                   	push   %eax
8010600f:	6a 02                	push   $0x2
80106011:	e8 28 f4 ff ff       	call   8010543e <argint>
80106016:	83 c4 10             	add    $0x10,%esp
     argint(1, &major) < 0 ||
80106019:	85 c0                	test   %eax,%eax
8010601b:	78 25                	js     80106042 <sys_mknod+0x6f>
     (ip = create(path, T_DEV, major, minor)) == 0){
8010601d:	8b 45 e8             	mov    -0x18(%ebp),%eax
80106020:	0f bf c8             	movswl %ax,%ecx
80106023:	8b 45 ec             	mov    -0x14(%ebp),%eax
80106026:	0f bf d0             	movswl %ax,%edx
80106029:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010602c:	51                   	push   %ecx
8010602d:	52                   	push   %edx
8010602e:	6a 03                	push   $0x3
80106030:	50                   	push   %eax
80106031:	e8 cd fb ff ff       	call   80105c03 <create>
80106036:	83 c4 10             	add    $0x10,%esp
80106039:	89 45 f4             	mov    %eax,-0xc(%ebp)
     argint(2, &minor) < 0 ||
8010603c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80106040:	75 0c                	jne    8010604e <sys_mknod+0x7b>
    end_op();
80106042:	e8 65 d5 ff ff       	call   801035ac <end_op>
    return -1;
80106047:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010604c:	eb 18                	jmp    80106066 <sys_mknod+0x93>
  }
  iunlockput(ip);
8010604e:	83 ec 0c             	sub    $0xc,%esp
80106051:	ff 75 f4             	push   -0xc(%ebp)
80106054:	e8 c2 bb ff ff       	call   80101c1b <iunlockput>
80106059:	83 c4 10             	add    $0x10,%esp
  end_op();
8010605c:	e8 4b d5 ff ff       	call   801035ac <end_op>
  return 0;
80106061:	b8 00 00 00 00       	mov    $0x0,%eax
}
80106066:	c9                   	leave  
80106067:	c3                   	ret    

80106068 <sys_chdir>:

int
sys_chdir(void)
{
80106068:	55                   	push   %ebp
80106069:	89 e5                	mov    %esp,%ebp
8010606b:	83 ec 18             	sub    $0x18,%esp
  char *path;
  struct inode *ip;
  struct proc *curproc = myproc();
8010606e:	e8 a1 de ff ff       	call   80103f14 <myproc>
80106073:	89 45 f4             	mov    %eax,-0xc(%ebp)
  
  begin_op();
80106076:	e8 a5 d4 ff ff       	call   80103520 <begin_op>
  if(argstr(0, &path) < 0 || (ip = namei(path)) == 0){
8010607b:	83 ec 08             	sub    $0x8,%esp
8010607e:	8d 45 ec             	lea    -0x14(%ebp),%eax
80106081:	50                   	push   %eax
80106082:	6a 00                	push   $0x0
80106084:	e8 4a f4 ff ff       	call   801054d3 <argstr>
80106089:	83 c4 10             	add    $0x10,%esp
8010608c:	85 c0                	test   %eax,%eax
8010608e:	78 18                	js     801060a8 <sys_chdir+0x40>
80106090:	8b 45 ec             	mov    -0x14(%ebp),%eax
80106093:	83 ec 0c             	sub    $0xc,%esp
80106096:	50                   	push   %eax
80106097:	e8 81 c4 ff ff       	call   8010251d <namei>
8010609c:	83 c4 10             	add    $0x10,%esp
8010609f:	89 45 f0             	mov    %eax,-0x10(%ebp)
801060a2:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
801060a6:	75 0c                	jne    801060b4 <sys_chdir+0x4c>
    end_op();
801060a8:	e8 ff d4 ff ff       	call   801035ac <end_op>
    return -1;
801060ad:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801060b2:	eb 68                	jmp    8010611c <sys_chdir+0xb4>
  }
  ilock(ip);
801060b4:	83 ec 0c             	sub    $0xc,%esp
801060b7:	ff 75 f0             	push   -0x10(%ebp)
801060ba:	e8 2b b9 ff ff       	call   801019ea <ilock>
801060bf:	83 c4 10             	add    $0x10,%esp
  if(ip->type != T_DIR){
801060c2:	8b 45 f0             	mov    -0x10(%ebp),%eax
801060c5:	0f b7 40 50          	movzwl 0x50(%eax),%eax
801060c9:	66 83 f8 01          	cmp    $0x1,%ax
801060cd:	74 1a                	je     801060e9 <sys_chdir+0x81>
    iunlockput(ip);
801060cf:	83 ec 0c             	sub    $0xc,%esp
801060d2:	ff 75 f0             	push   -0x10(%ebp)
801060d5:	e8 41 bb ff ff       	call   80101c1b <iunlockput>
801060da:	83 c4 10             	add    $0x10,%esp
    end_op();
801060dd:	e8 ca d4 ff ff       	call   801035ac <end_op>
    return -1;
801060e2:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801060e7:	eb 33                	jmp    8010611c <sys_chdir+0xb4>
  }
  iunlock(ip);
801060e9:	83 ec 0c             	sub    $0xc,%esp
801060ec:	ff 75 f0             	push   -0x10(%ebp)
801060ef:	e8 09 ba ff ff       	call   80101afd <iunlock>
801060f4:	83 c4 10             	add    $0x10,%esp
  iput(curproc->cwd);
801060f7:	8b 45 f4             	mov    -0xc(%ebp),%eax
801060fa:	8b 40 68             	mov    0x68(%eax),%eax
801060fd:	83 ec 0c             	sub    $0xc,%esp
80106100:	50                   	push   %eax
80106101:	e8 45 ba ff ff       	call   80101b4b <iput>
80106106:	83 c4 10             	add    $0x10,%esp
  end_op();
80106109:	e8 9e d4 ff ff       	call   801035ac <end_op>
  curproc->cwd = ip;
8010610e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106111:	8b 55 f0             	mov    -0x10(%ebp),%edx
80106114:	89 50 68             	mov    %edx,0x68(%eax)
  return 0;
80106117:	b8 00 00 00 00       	mov    $0x0,%eax
}
8010611c:	c9                   	leave  
8010611d:	c3                   	ret    

8010611e <sys_exec>:

int
sys_exec(void)
{
8010611e:	55                   	push   %ebp
8010611f:	89 e5                	mov    %esp,%ebp
80106121:	81 ec 98 00 00 00    	sub    $0x98,%esp
  char *path, *argv[MAXARG];
  int i;
  uint uargv, uarg;

  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
80106127:	83 ec 08             	sub    $0x8,%esp
8010612a:	8d 45 f0             	lea    -0x10(%ebp),%eax
8010612d:	50                   	push   %eax
8010612e:	6a 00                	push   $0x0
80106130:	e8 9e f3 ff ff       	call   801054d3 <argstr>
80106135:	83 c4 10             	add    $0x10,%esp
80106138:	85 c0                	test   %eax,%eax
8010613a:	78 18                	js     80106154 <sys_exec+0x36>
8010613c:	83 ec 08             	sub    $0x8,%esp
8010613f:	8d 85 6c ff ff ff    	lea    -0x94(%ebp),%eax
80106145:	50                   	push   %eax
80106146:	6a 01                	push   $0x1
80106148:	e8 f1 f2 ff ff       	call   8010543e <argint>
8010614d:	83 c4 10             	add    $0x10,%esp
80106150:	85 c0                	test   %eax,%eax
80106152:	79 0a                	jns    8010615e <sys_exec+0x40>
    return -1;
80106154:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106159:	e9 c6 00 00 00       	jmp    80106224 <sys_exec+0x106>
  }
  memset(argv, 0, sizeof(argv));
8010615e:	83 ec 04             	sub    $0x4,%esp
80106161:	68 80 00 00 00       	push   $0x80
80106166:	6a 00                	push   $0x0
80106168:	8d 85 70 ff ff ff    	lea    -0x90(%ebp),%eax
8010616e:	50                   	push   %eax
8010616f:	e8 9f ef ff ff       	call   80105113 <memset>
80106174:	83 c4 10             	add    $0x10,%esp
  for(i=0;; i++){
80106177:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    if(i >= NELEM(argv))
8010617e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106181:	83 f8 1f             	cmp    $0x1f,%eax
80106184:	76 0a                	jbe    80106190 <sys_exec+0x72>
      return -1;
80106186:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010618b:	e9 94 00 00 00       	jmp    80106224 <sys_exec+0x106>
    if(fetchint(uargv+4*i, (int*)&uarg) < 0)
80106190:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106193:	c1 e0 02             	shl    $0x2,%eax
80106196:	89 c2                	mov    %eax,%edx
80106198:	8b 85 6c ff ff ff    	mov    -0x94(%ebp),%eax
8010619e:	01 c2                	add    %eax,%edx
801061a0:	83 ec 08             	sub    $0x8,%esp
801061a3:	8d 85 68 ff ff ff    	lea    -0x98(%ebp),%eax
801061a9:	50                   	push   %eax
801061aa:	52                   	push   %edx
801061ab:	e8 ed f1 ff ff       	call   8010539d <fetchint>
801061b0:	83 c4 10             	add    $0x10,%esp
801061b3:	85 c0                	test   %eax,%eax
801061b5:	79 07                	jns    801061be <sys_exec+0xa0>
      return -1;
801061b7:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801061bc:	eb 66                	jmp    80106224 <sys_exec+0x106>
    if(uarg == 0){
801061be:	8b 85 68 ff ff ff    	mov    -0x98(%ebp),%eax
801061c4:	85 c0                	test   %eax,%eax
801061c6:	75 27                	jne    801061ef <sys_exec+0xd1>
      argv[i] = 0;
801061c8:	8b 45 f4             	mov    -0xc(%ebp),%eax
801061cb:	c7 84 85 70 ff ff ff 	movl   $0x0,-0x90(%ebp,%eax,4)
801061d2:	00 00 00 00 
      break;
801061d6:	90                   	nop
    }
    if(fetchstr(uarg, &argv[i]) < 0)
      return -1;
  }
  return exec(path, argv);
801061d7:	8b 45 f0             	mov    -0x10(%ebp),%eax
801061da:	83 ec 08             	sub    $0x8,%esp
801061dd:	8d 95 70 ff ff ff    	lea    -0x90(%ebp),%edx
801061e3:	52                   	push   %edx
801061e4:	50                   	push   %eax
801061e5:	e8 96 a9 ff ff       	call   80100b80 <exec>
801061ea:	83 c4 10             	add    $0x10,%esp
801061ed:	eb 35                	jmp    80106224 <sys_exec+0x106>
    if(fetchstr(uarg, &argv[i]) < 0)
801061ef:	8d 95 70 ff ff ff    	lea    -0x90(%ebp),%edx
801061f5:	8b 45 f4             	mov    -0xc(%ebp),%eax
801061f8:	c1 e0 02             	shl    $0x2,%eax
801061fb:	01 c2                	add    %eax,%edx
801061fd:	8b 85 68 ff ff ff    	mov    -0x98(%ebp),%eax
80106203:	83 ec 08             	sub    $0x8,%esp
80106206:	52                   	push   %edx
80106207:	50                   	push   %eax
80106208:	e8 cf f1 ff ff       	call   801053dc <fetchstr>
8010620d:	83 c4 10             	add    $0x10,%esp
80106210:	85 c0                	test   %eax,%eax
80106212:	79 07                	jns    8010621b <sys_exec+0xfd>
      return -1;
80106214:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106219:	eb 09                	jmp    80106224 <sys_exec+0x106>
  for(i=0;; i++){
8010621b:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
    if(i >= NELEM(argv))
8010621f:	e9 5a ff ff ff       	jmp    8010617e <sys_exec+0x60>
}
80106224:	c9                   	leave  
80106225:	c3                   	ret    

80106226 <sys_pipe>:

int
sys_pipe(void)
{
80106226:	55                   	push   %ebp
80106227:	89 e5                	mov    %esp,%ebp
80106229:	83 ec 28             	sub    $0x28,%esp
  int *fd;
  struct file *rf, *wf;
  int fd0, fd1;

  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
8010622c:	83 ec 04             	sub    $0x4,%esp
8010622f:	6a 08                	push   $0x8
80106231:	8d 45 ec             	lea    -0x14(%ebp),%eax
80106234:	50                   	push   %eax
80106235:	6a 00                	push   $0x0
80106237:	e8 2f f2 ff ff       	call   8010546b <argptr>
8010623c:	83 c4 10             	add    $0x10,%esp
8010623f:	85 c0                	test   %eax,%eax
80106241:	79 0a                	jns    8010624d <sys_pipe+0x27>
    return -1;
80106243:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106248:	e9 ae 00 00 00       	jmp    801062fb <sys_pipe+0xd5>
  if(pipealloc(&rf, &wf) < 0)
8010624d:	83 ec 08             	sub    $0x8,%esp
80106250:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80106253:	50                   	push   %eax
80106254:	8d 45 e8             	lea    -0x18(%ebp),%eax
80106257:	50                   	push   %eax
80106258:	e8 f4 d7 ff ff       	call   80103a51 <pipealloc>
8010625d:	83 c4 10             	add    $0x10,%esp
80106260:	85 c0                	test   %eax,%eax
80106262:	79 0a                	jns    8010626e <sys_pipe+0x48>
    return -1;
80106264:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106269:	e9 8d 00 00 00       	jmp    801062fb <sys_pipe+0xd5>
  fd0 = -1;
8010626e:	c7 45 f4 ff ff ff ff 	movl   $0xffffffff,-0xc(%ebp)
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
80106275:	8b 45 e8             	mov    -0x18(%ebp),%eax
80106278:	83 ec 0c             	sub    $0xc,%esp
8010627b:	50                   	push   %eax
8010627c:	e8 7b f3 ff ff       	call   801055fc <fdalloc>
80106281:	83 c4 10             	add    $0x10,%esp
80106284:	89 45 f4             	mov    %eax,-0xc(%ebp)
80106287:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
8010628b:	78 18                	js     801062a5 <sys_pipe+0x7f>
8010628d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80106290:	83 ec 0c             	sub    $0xc,%esp
80106293:	50                   	push   %eax
80106294:	e8 63 f3 ff ff       	call   801055fc <fdalloc>
80106299:	83 c4 10             	add    $0x10,%esp
8010629c:	89 45 f0             	mov    %eax,-0x10(%ebp)
8010629f:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
801062a3:	79 3e                	jns    801062e3 <sys_pipe+0xbd>
    if(fd0 >= 0)
801062a5:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801062a9:	78 13                	js     801062be <sys_pipe+0x98>
      myproc()->ofile[fd0] = 0;
801062ab:	e8 64 dc ff ff       	call   80103f14 <myproc>
801062b0:	8b 55 f4             	mov    -0xc(%ebp),%edx
801062b3:	83 c2 08             	add    $0x8,%edx
801062b6:	c7 44 90 08 00 00 00 	movl   $0x0,0x8(%eax,%edx,4)
801062bd:	00 
    fileclose(rf);
801062be:	8b 45 e8             	mov    -0x18(%ebp),%eax
801062c1:	83 ec 0c             	sub    $0xc,%esp
801062c4:	50                   	push   %eax
801062c5:	e8 d1 ad ff ff       	call   8010109b <fileclose>
801062ca:	83 c4 10             	add    $0x10,%esp
    fileclose(wf);
801062cd:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801062d0:	83 ec 0c             	sub    $0xc,%esp
801062d3:	50                   	push   %eax
801062d4:	e8 c2 ad ff ff       	call   8010109b <fileclose>
801062d9:	83 c4 10             	add    $0x10,%esp
    return -1;
801062dc:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801062e1:	eb 18                	jmp    801062fb <sys_pipe+0xd5>
  }
  fd[0] = fd0;
801062e3:	8b 45 ec             	mov    -0x14(%ebp),%eax
801062e6:	8b 55 f4             	mov    -0xc(%ebp),%edx
801062e9:	89 10                	mov    %edx,(%eax)
  fd[1] = fd1;
801062eb:	8b 45 ec             	mov    -0x14(%ebp),%eax
801062ee:	8d 50 04             	lea    0x4(%eax),%edx
801062f1:	8b 45 f0             	mov    -0x10(%ebp),%eax
801062f4:	89 02                	mov    %eax,(%edx)
  return 0;
801062f6:	b8 00 00 00 00       	mov    $0x0,%eax
}
801062fb:	c9                   	leave  
801062fc:	c3                   	ret    

801062fd <sys_fork>:
#include "spinlock.h"
#include "debug.h"

int
sys_fork(void)
{
801062fd:	55                   	push   %ebp
801062fe:	89 e5                	mov    %esp,%ebp
80106300:	83 ec 08             	sub    $0x8,%esp
  return fork();
80106303:	e8 0e df ff ff       	call   80104216 <fork>
}
80106308:	c9                   	leave  
80106309:	c3                   	ret    

8010630a <sys_exit>:

int
sys_exit(void)
{
8010630a:	55                   	push   %ebp
8010630b:	89 e5                	mov    %esp,%ebp
8010630d:	83 ec 08             	sub    $0x8,%esp
  exit();
80106310:	e8 7a e0 ff ff       	call   8010438f <exit>
  return 0;  // not reached
80106315:	b8 00 00 00 00       	mov    $0x0,%eax
}
8010631a:	c9                   	leave  
8010631b:	c3                   	ret    

8010631c <sys_uthread_init>:

int sys_uthread_init(void) {
8010631c:	55                   	push   %ebp
8010631d:	89 e5                	mov    %esp,%ebp
8010631f:	83 ec 18             	sub    $0x18,%esp
  int address;
  //0번째 파라미터로 준 값을 &address에 저장.  유효값 아니라면 리턴 -1
  if (argint(0, &address) < 0)
80106322:	83 ec 08             	sub    $0x8,%esp
80106325:	8d 45 f4             	lea    -0xc(%ebp),%eax
80106328:	50                   	push   %eax
80106329:	6a 00                	push   $0x0
8010632b:	e8 0e f1 ff ff       	call   8010543e <argint>
80106330:	83 c4 10             	add    $0x10,%esp
80106333:	85 c0                	test   %eax,%eax
80106335:	79 07                	jns    8010633e <sys_uthread_init+0x22>
	  return -1;
80106337:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010633c:	eb 0f                	jmp    8010634d <sys_uthread_init+0x31>
  //유효값이면 uthread_init 실행
  return uthread_init(address);
8010633e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106341:	83 ec 0c             	sub    $0xc,%esp
80106344:	50                   	push   %eax
80106345:	e8 68 e1 ff ff       	call   801044b2 <uthread_init>
8010634a:	83 c4 10             	add    $0x10,%esp
}
8010634d:	c9                   	leave  
8010634e:	c3                   	ret    

8010634f <sys_exit2>:

int
sys_exit2(void) 
{
8010634f:	55                   	push   %ebp
80106350:	89 e5                	mov    %esp,%ebp
80106352:	83 ec 18             	sub    $0x18,%esp
  int status;

  //첫번쨰 파라미터로 준 값을 &status에 입력한다.
  //유효값 아니라면 리턴 -1
  if (argint(0, &status) < 0)
80106355:	83 ec 08             	sub    $0x8,%esp
80106358:	8d 45 f4             	lea    -0xc(%ebp),%eax
8010635b:	50                   	push   %eax
8010635c:	6a 00                	push   $0x0
8010635e:	e8 db f0 ff ff       	call   8010543e <argint>
80106363:	83 c4 10             	add    $0x10,%esp
80106366:	85 c0                	test   %eax,%eax
80106368:	79 07                	jns    80106371 <sys_exit2+0x22>
	  return -1;
8010636a:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010636f:	eb 12                	jmp    80106383 <sys_exit2+0x34>
   
  exit2(status); 
80106371:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106374:	83 ec 0c             	sub    $0xc,%esp
80106377:	50                   	push   %eax
80106378:	e8 6b e1 ff ff       	call   801044e8 <exit2>
8010637d:	83 c4 10             	add    $0x10,%esp
  //return 0; //eax에 리턴해야하니까
  return status; //eax에 리턴해야하니까
80106380:	8b 45 f4             	mov    -0xc(%ebp),%eax
}  
80106383:	c9                   	leave  
80106384:	c3                   	ret    

80106385 <sys_wait>:

int
sys_wait(void)
{
80106385:	55                   	push   %ebp
80106386:	89 e5                	mov    %esp,%ebp
80106388:	83 ec 08             	sub    $0x8,%esp
  return wait();
8010638b:	e8 87 e2 ff ff       	call   80104617 <wait>
}
80106390:	c9                   	leave  
80106391:	c3                   	ret    

80106392 <sys_wait2>:
//*********new sys_waiat**********
//********************************

int
sys_wait2(void)
{
80106392:	55                   	push   %ebp
80106393:	89 e5                	mov    %esp,%ebp
80106395:	83 ec 18             	sub    $0x18,%esp

  int status;
  //포인터 값 복사, 유효값 아니라면 리턴 -1
  if(argptr(0, (char **)&status, sizeof(int)) < 0)
80106398:	83 ec 04             	sub    $0x4,%esp
8010639b:	6a 04                	push   $0x4
8010639d:	8d 45 f4             	lea    -0xc(%ebp),%eax
801063a0:	50                   	push   %eax
801063a1:	6a 00                	push   $0x0
801063a3:	e8 c3 f0 ff ff       	call   8010546b <argptr>
801063a8:	83 c4 10             	add    $0x10,%esp
801063ab:	85 c0                	test   %eax,%eax
801063ad:	79 07                	jns    801063b6 <sys_wait2+0x24>
    return -1;
801063af:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801063b4:	eb 0f                	jmp    801063c5 <sys_wait2+0x33>

  //유효값이면 wait2 실행
  return wait2(&status);
801063b6:	83 ec 0c             	sub    $0xc,%esp
801063b9:	8d 45 f4             	lea    -0xc(%ebp),%eax
801063bc:	50                   	push   %eax
801063bd:	e8 78 e3 ff ff       	call   8010473a <wait2>
801063c2:	83 c4 10             	add    $0x10,%esp

}
801063c5:	c9                   	leave  
801063c6:	c3                   	ret    

801063c7 <sys_kill>:
//********************************


int
sys_kill(void)
{
801063c7:	55                   	push   %ebp
801063c8:	89 e5                	mov    %esp,%ebp
801063ca:	83 ec 18             	sub    $0x18,%esp
  int pid;

  if(argint(0, &pid) < 0)
801063cd:	83 ec 08             	sub    $0x8,%esp
801063d0:	8d 45 f4             	lea    -0xc(%ebp),%eax
801063d3:	50                   	push   %eax
801063d4:	6a 00                	push   $0x0
801063d6:	e8 63 f0 ff ff       	call   8010543e <argint>
801063db:	83 c4 10             	add    $0x10,%esp
801063de:	85 c0                	test   %eax,%eax
801063e0:	79 07                	jns    801063e9 <sys_kill+0x22>
    return -1;
801063e2:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801063e7:	eb 0f                	jmp    801063f8 <sys_kill+0x31>
  return kill(pid);
801063e9:	8b 45 f4             	mov    -0xc(%ebp),%eax
801063ec:	83 ec 0c             	sub    $0xc,%esp
801063ef:	50                   	push   %eax
801063f0:	e8 a5 e7 ff ff       	call   80104b9a <kill>
801063f5:	83 c4 10             	add    $0x10,%esp
}
801063f8:	c9                   	leave  
801063f9:	c3                   	ret    

801063fa <sys_getpid>:

int
sys_getpid(void)
{
801063fa:	55                   	push   %ebp
801063fb:	89 e5                	mov    %esp,%ebp
801063fd:	83 ec 08             	sub    $0x8,%esp
  return myproc()->pid;
80106400:	e8 0f db ff ff       	call   80103f14 <myproc>
80106405:	8b 40 10             	mov    0x10(%eax),%eax
}
80106408:	c9                   	leave  
80106409:	c3                   	ret    

8010640a <sys_sbrk>:

int
sys_sbrk(void)
{
8010640a:	55                   	push   %ebp
8010640b:	89 e5                	mov    %esp,%ebp
8010640d:	83 ec 18             	sub    $0x18,%esp
  int addr;
  int n;

  if(argint(0, &n) < 0)
80106410:	83 ec 08             	sub    $0x8,%esp
80106413:	8d 45 f0             	lea    -0x10(%ebp),%eax
80106416:	50                   	push   %eax
80106417:	6a 00                	push   $0x0
80106419:	e8 20 f0 ff ff       	call   8010543e <argint>
8010641e:	83 c4 10             	add    $0x10,%esp
80106421:	85 c0                	test   %eax,%eax
80106423:	79 07                	jns    8010642c <sys_sbrk+0x22>
    return -1;
80106425:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010642a:	eb 27                	jmp    80106453 <sys_sbrk+0x49>
  addr = myproc()->sz;
8010642c:	e8 e3 da ff ff       	call   80103f14 <myproc>
80106431:	8b 00                	mov    (%eax),%eax
80106433:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(growproc(n) < 0)
80106436:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106439:	83 ec 0c             	sub    $0xc,%esp
8010643c:	50                   	push   %eax
8010643d:	e8 39 dd ff ff       	call   8010417b <growproc>
80106442:	83 c4 10             	add    $0x10,%esp
80106445:	85 c0                	test   %eax,%eax
80106447:	79 07                	jns    80106450 <sys_sbrk+0x46>
    return -1;
80106449:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010644e:	eb 03                	jmp    80106453 <sys_sbrk+0x49>
  return addr;
80106450:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
80106453:	c9                   	leave  
80106454:	c3                   	ret    

80106455 <sys_sleep>:

int
sys_sleep(void)
{
80106455:	55                   	push   %ebp
80106456:	89 e5                	mov    %esp,%ebp
80106458:	83 ec 18             	sub    $0x18,%esp
  int n;
  uint ticks0;

  if(argint(0, &n) < 0)
8010645b:	83 ec 08             	sub    $0x8,%esp
8010645e:	8d 45 f0             	lea    -0x10(%ebp),%eax
80106461:	50                   	push   %eax
80106462:	6a 00                	push   $0x0
80106464:	e8 d5 ef ff ff       	call   8010543e <argint>
80106469:	83 c4 10             	add    $0x10,%esp
8010646c:	85 c0                	test   %eax,%eax
8010646e:	79 07                	jns    80106477 <sys_sleep+0x22>
    return -1;
80106470:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106475:	eb 76                	jmp    801064ed <sys_sleep+0x98>
  acquire(&tickslock);
80106477:	83 ec 0c             	sub    $0xc,%esp
8010647a:	68 80 9b 11 80       	push   $0x80119b80
8010647f:	e8 19 ea ff ff       	call   80104e9d <acquire>
80106484:	83 c4 10             	add    $0x10,%esp
  ticks0 = ticks;
80106487:	a1 b4 9b 11 80       	mov    0x80119bb4,%eax
8010648c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  while(ticks - ticks0 < n){
8010648f:	eb 38                	jmp    801064c9 <sys_sleep+0x74>
    if(myproc()->killed){
80106491:	e8 7e da ff ff       	call   80103f14 <myproc>
80106496:	8b 40 24             	mov    0x24(%eax),%eax
80106499:	85 c0                	test   %eax,%eax
8010649b:	74 17                	je     801064b4 <sys_sleep+0x5f>
      release(&tickslock);
8010649d:	83 ec 0c             	sub    $0xc,%esp
801064a0:	68 80 9b 11 80       	push   $0x80119b80
801064a5:	e8 61 ea ff ff       	call   80104f0b <release>
801064aa:	83 c4 10             	add    $0x10,%esp
      return -1;
801064ad:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801064b2:	eb 39                	jmp    801064ed <sys_sleep+0x98>
    }
    sleep(&ticks, &tickslock);
801064b4:	83 ec 08             	sub    $0x8,%esp
801064b7:	68 80 9b 11 80       	push   $0x80119b80
801064bc:	68 b4 9b 11 80       	push   $0x80119bb4
801064c1:	e8 b3 e5 ff ff       	call   80104a79 <sleep>
801064c6:	83 c4 10             	add    $0x10,%esp
  while(ticks - ticks0 < n){
801064c9:	a1 b4 9b 11 80       	mov    0x80119bb4,%eax
801064ce:	2b 45 f4             	sub    -0xc(%ebp),%eax
801064d1:	8b 55 f0             	mov    -0x10(%ebp),%edx
801064d4:	39 d0                	cmp    %edx,%eax
801064d6:	72 b9                	jb     80106491 <sys_sleep+0x3c>
  }
  release(&tickslock);
801064d8:	83 ec 0c             	sub    $0xc,%esp
801064db:	68 80 9b 11 80       	push   $0x80119b80
801064e0:	e8 26 ea ff ff       	call   80104f0b <release>
801064e5:	83 c4 10             	add    $0x10,%esp
  return 0;
801064e8:	b8 00 00 00 00       	mov    $0x0,%eax
}
801064ed:	c9                   	leave  
801064ee:	c3                   	ret    

801064ef <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
int
sys_uptime(void)
{
801064ef:	55                   	push   %ebp
801064f0:	89 e5                	mov    %esp,%ebp
801064f2:	83 ec 18             	sub    $0x18,%esp
  uint xticks;

  acquire(&tickslock);
801064f5:	83 ec 0c             	sub    $0xc,%esp
801064f8:	68 80 9b 11 80       	push   $0x80119b80
801064fd:	e8 9b e9 ff ff       	call   80104e9d <acquire>
80106502:	83 c4 10             	add    $0x10,%esp
  xticks = ticks;
80106505:	a1 b4 9b 11 80       	mov    0x80119bb4,%eax
8010650a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  release(&tickslock);
8010650d:	83 ec 0c             	sub    $0xc,%esp
80106510:	68 80 9b 11 80       	push   $0x80119b80
80106515:	e8 f1 e9 ff ff       	call   80104f0b <release>
8010651a:	83 c4 10             	add    $0x10,%esp
  return xticks;
8010651d:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
80106520:	c9                   	leave  
80106521:	c3                   	ret    

80106522 <alltraps>:
80106522:	1e                   	push   %ds
80106523:	06                   	push   %es
80106524:	0f a0                	push   %fs
80106526:	0f a8                	push   %gs
80106528:	60                   	pusha  
80106529:	66 b8 10 00          	mov    $0x10,%ax
8010652d:	8e d8                	mov    %eax,%ds
8010652f:	8e c0                	mov    %eax,%es
80106531:	54                   	push   %esp
80106532:	e8 d7 01 00 00       	call   8010670e <trap>
80106537:	83 c4 04             	add    $0x4,%esp

8010653a <trapret>:
8010653a:	61                   	popa   
8010653b:	0f a9                	pop    %gs
8010653d:	0f a1                	pop    %fs
8010653f:	07                   	pop    %es
80106540:	1f                   	pop    %ds
80106541:	83 c4 08             	add    $0x8,%esp
80106544:	cf                   	iret   

80106545 <lidt>:
{
80106545:	55                   	push   %ebp
80106546:	89 e5                	mov    %esp,%ebp
80106548:	83 ec 10             	sub    $0x10,%esp
  pd[0] = size-1;
8010654b:	8b 45 0c             	mov    0xc(%ebp),%eax
8010654e:	83 e8 01             	sub    $0x1,%eax
80106551:	66 89 45 fa          	mov    %ax,-0x6(%ebp)
  pd[1] = (uint)p;
80106555:	8b 45 08             	mov    0x8(%ebp),%eax
80106558:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  pd[2] = (uint)p >> 16;
8010655c:	8b 45 08             	mov    0x8(%ebp),%eax
8010655f:	c1 e8 10             	shr    $0x10,%eax
80106562:	66 89 45 fe          	mov    %ax,-0x2(%ebp)
  asm volatile("lidt (%0)" : : "r" (pd));
80106566:	8d 45 fa             	lea    -0x6(%ebp),%eax
80106569:	0f 01 18             	lidtl  (%eax)
}
8010656c:	90                   	nop
8010656d:	c9                   	leave  
8010656e:	c3                   	ret    

8010656f <rcr2>:

static inline uint
rcr2(void)
{
8010656f:	55                   	push   %ebp
80106570:	89 e5                	mov    %esp,%ebp
80106572:	83 ec 10             	sub    $0x10,%esp
  uint val;
  asm volatile("movl %%cr2,%0" : "=r" (val));
80106575:	0f 20 d0             	mov    %cr2,%eax
80106578:	89 45 fc             	mov    %eax,-0x4(%ebp)
  return val;
8010657b:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
8010657e:	c9                   	leave  
8010657f:	c3                   	ret    

80106580 <tvinit>:

extern void thread_switch(void); //************** modified

void
tvinit(void)
{
80106580:	55                   	push   %ebp
80106581:	89 e5                	mov    %esp,%ebp
80106583:	83 ec 18             	sub    $0x18,%esp
  int i;

  for(i = 0; i < 256; i++)
80106586:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
8010658d:	e9 c3 00 00 00       	jmp    80106655 <tvinit+0xd5>
    SETGATE(idt[i], 0, SEG_KCODE<<3, vectors[i], 0);
80106592:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106595:	8b 04 85 84 f0 10 80 	mov    -0x7fef0f7c(,%eax,4),%eax
8010659c:	89 c2                	mov    %eax,%edx
8010659e:	8b 45 f4             	mov    -0xc(%ebp),%eax
801065a1:	66 89 14 c5 80 93 11 	mov    %dx,-0x7fee6c80(,%eax,8)
801065a8:	80 
801065a9:	8b 45 f4             	mov    -0xc(%ebp),%eax
801065ac:	66 c7 04 c5 82 93 11 	movw   $0x8,-0x7fee6c7e(,%eax,8)
801065b3:	80 08 00 
801065b6:	8b 45 f4             	mov    -0xc(%ebp),%eax
801065b9:	0f b6 14 c5 84 93 11 	movzbl -0x7fee6c7c(,%eax,8),%edx
801065c0:	80 
801065c1:	83 e2 e0             	and    $0xffffffe0,%edx
801065c4:	88 14 c5 84 93 11 80 	mov    %dl,-0x7fee6c7c(,%eax,8)
801065cb:	8b 45 f4             	mov    -0xc(%ebp),%eax
801065ce:	0f b6 14 c5 84 93 11 	movzbl -0x7fee6c7c(,%eax,8),%edx
801065d5:	80 
801065d6:	83 e2 1f             	and    $0x1f,%edx
801065d9:	88 14 c5 84 93 11 80 	mov    %dl,-0x7fee6c7c(,%eax,8)
801065e0:	8b 45 f4             	mov    -0xc(%ebp),%eax
801065e3:	0f b6 14 c5 85 93 11 	movzbl -0x7fee6c7b(,%eax,8),%edx
801065ea:	80 
801065eb:	83 e2 f0             	and    $0xfffffff0,%edx
801065ee:	83 ca 0e             	or     $0xe,%edx
801065f1:	88 14 c5 85 93 11 80 	mov    %dl,-0x7fee6c7b(,%eax,8)
801065f8:	8b 45 f4             	mov    -0xc(%ebp),%eax
801065fb:	0f b6 14 c5 85 93 11 	movzbl -0x7fee6c7b(,%eax,8),%edx
80106602:	80 
80106603:	83 e2 ef             	and    $0xffffffef,%edx
80106606:	88 14 c5 85 93 11 80 	mov    %dl,-0x7fee6c7b(,%eax,8)
8010660d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106610:	0f b6 14 c5 85 93 11 	movzbl -0x7fee6c7b(,%eax,8),%edx
80106617:	80 
80106618:	83 e2 9f             	and    $0xffffff9f,%edx
8010661b:	88 14 c5 85 93 11 80 	mov    %dl,-0x7fee6c7b(,%eax,8)
80106622:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106625:	0f b6 14 c5 85 93 11 	movzbl -0x7fee6c7b(,%eax,8),%edx
8010662c:	80 
8010662d:	83 ca 80             	or     $0xffffff80,%edx
80106630:	88 14 c5 85 93 11 80 	mov    %dl,-0x7fee6c7b(,%eax,8)
80106637:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010663a:	8b 04 85 84 f0 10 80 	mov    -0x7fef0f7c(,%eax,4),%eax
80106641:	c1 e8 10             	shr    $0x10,%eax
80106644:	89 c2                	mov    %eax,%edx
80106646:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106649:	66 89 14 c5 86 93 11 	mov    %dx,-0x7fee6c7a(,%eax,8)
80106650:	80 
  for(i = 0; i < 256; i++)
80106651:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80106655:	81 7d f4 ff 00 00 00 	cmpl   $0xff,-0xc(%ebp)
8010665c:	0f 8e 30 ff ff ff    	jle    80106592 <tvinit+0x12>
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
80106662:	a1 84 f1 10 80       	mov    0x8010f184,%eax
80106667:	66 a3 80 95 11 80    	mov    %ax,0x80119580
8010666d:	66 c7 05 82 95 11 80 	movw   $0x8,0x80119582
80106674:	08 00 
80106676:	0f b6 05 84 95 11 80 	movzbl 0x80119584,%eax
8010667d:	83 e0 e0             	and    $0xffffffe0,%eax
80106680:	a2 84 95 11 80       	mov    %al,0x80119584
80106685:	0f b6 05 84 95 11 80 	movzbl 0x80119584,%eax
8010668c:	83 e0 1f             	and    $0x1f,%eax
8010668f:	a2 84 95 11 80       	mov    %al,0x80119584
80106694:	0f b6 05 85 95 11 80 	movzbl 0x80119585,%eax
8010669b:	83 c8 0f             	or     $0xf,%eax
8010669e:	a2 85 95 11 80       	mov    %al,0x80119585
801066a3:	0f b6 05 85 95 11 80 	movzbl 0x80119585,%eax
801066aa:	83 e0 ef             	and    $0xffffffef,%eax
801066ad:	a2 85 95 11 80       	mov    %al,0x80119585
801066b2:	0f b6 05 85 95 11 80 	movzbl 0x80119585,%eax
801066b9:	83 c8 60             	or     $0x60,%eax
801066bc:	a2 85 95 11 80       	mov    %al,0x80119585
801066c1:	0f b6 05 85 95 11 80 	movzbl 0x80119585,%eax
801066c8:	83 c8 80             	or     $0xffffff80,%eax
801066cb:	a2 85 95 11 80       	mov    %al,0x80119585
801066d0:	a1 84 f1 10 80       	mov    0x8010f184,%eax
801066d5:	c1 e8 10             	shr    $0x10,%eax
801066d8:	66 a3 86 95 11 80    	mov    %ax,0x80119586

  initlock(&tickslock, "time");
801066de:	83 ec 08             	sub    $0x8,%esp
801066e1:	68 7c ab 10 80       	push   $0x8010ab7c
801066e6:	68 80 9b 11 80       	push   $0x80119b80
801066eb:	e8 8b e7 ff ff       	call   80104e7b <initlock>
801066f0:	83 c4 10             	add    $0x10,%esp
}
801066f3:	90                   	nop
801066f4:	c9                   	leave  
801066f5:	c3                   	ret    

801066f6 <idtinit>:

void
idtinit(void)
{
801066f6:	55                   	push   %ebp
801066f7:	89 e5                	mov    %esp,%ebp
  lidt(idt, sizeof(idt));
801066f9:	68 00 08 00 00       	push   $0x800
801066fe:	68 80 93 11 80       	push   $0x80119380
80106703:	e8 3d fe ff ff       	call   80106545 <lidt>
80106708:	83 c4 08             	add    $0x8,%esp
}
8010670b:	90                   	nop
8010670c:	c9                   	leave  
8010670d:	c3                   	ret    

8010670e <trap>:

//PAGEBREAK: 41
void
trap(struct trapframe *tf)
{
8010670e:	55                   	push   %ebp
8010670f:	89 e5                	mov    %esp,%ebp
80106711:	57                   	push   %edi
80106712:	56                   	push   %esi
80106713:	53                   	push   %ebx
80106714:	83 ec 2c             	sub    $0x2c,%esp
  if(tf->trapno == T_SYSCALL){ //시스템 콜 처리
80106717:	8b 45 08             	mov    0x8(%ebp),%eax
8010671a:	8b 40 30             	mov    0x30(%eax),%eax
8010671d:	83 f8 40             	cmp    $0x40,%eax
80106720:	75 3b                	jne    8010675d <trap+0x4f>
    if(myproc()->killed)
80106722:	e8 ed d7 ff ff       	call   80103f14 <myproc>
80106727:	8b 40 24             	mov    0x24(%eax),%eax
8010672a:	85 c0                	test   %eax,%eax
8010672c:	74 05                	je     80106733 <trap+0x25>
      exit();
8010672e:	e8 5c dc ff ff       	call   8010438f <exit>
    myproc()->tf = tf;
80106733:	e8 dc d7 ff ff       	call   80103f14 <myproc>
80106738:	8b 55 08             	mov    0x8(%ebp),%edx
8010673b:	89 50 18             	mov    %edx,0x18(%eax)
    syscall(); //usys.S에 정의됨
8010673e:	e8 c7 ed ff ff       	call   8010550a <syscall>
    if(myproc()->killed)
80106743:	e8 cc d7 ff ff       	call   80103f14 <myproc>
80106748:	8b 40 24             	mov    0x24(%eax),%eax
8010674b:	85 c0                	test   %eax,%eax
8010674d:	0f 84 2e 02 00 00    	je     80106981 <trap+0x273>
      exit();
80106753:	e8 37 dc ff ff       	call   8010438f <exit>
    return;
80106758:	e9 24 02 00 00       	jmp    80106981 <trap+0x273>
  }

  switch(tf->trapno){
8010675d:	8b 45 08             	mov    0x8(%ebp),%eax
80106760:	8b 40 30             	mov    0x30(%eax),%eax
80106763:	83 e8 20             	sub    $0x20,%eax
80106766:	83 f8 1f             	cmp    $0x1f,%eax
80106769:	0f 87 dd 00 00 00    	ja     8010684c <trap+0x13e>
8010676f:	8b 04 85 24 ac 10 80 	mov    -0x7fef53dc(,%eax,4),%eax
80106776:	ff e0                	jmp    *%eax
  case T_IRQ0 + IRQ_TIMER: //*************timer interrupt
    if(cpuid() == 0){
80106778:	e8 04 d7 ff ff       	call   80103e81 <cpuid>
8010677d:	85 c0                	test   %eax,%eax
8010677f:	75 3d                	jne    801067be <trap+0xb0>
      acquire(&tickslock);
80106781:	83 ec 0c             	sub    $0xc,%esp
80106784:	68 80 9b 11 80       	push   $0x80119b80
80106789:	e8 0f e7 ff ff       	call   80104e9d <acquire>
8010678e:	83 c4 10             	add    $0x10,%esp
      ticks++;
80106791:	a1 b4 9b 11 80       	mov    0x80119bb4,%eax
80106796:	83 c0 01             	add    $0x1,%eax
80106799:	a3 b4 9b 11 80       	mov    %eax,0x80119bb4
      wakeup(&ticks);
8010679e:	83 ec 0c             	sub    $0xc,%esp
801067a1:	68 b4 9b 11 80       	push   $0x80119bb4
801067a6:	e8 b8 e3 ff ff       	call   80104b63 <wakeup>
801067ab:	83 c4 10             	add    $0x10,%esp
      release(&tickslock);
801067ae:	83 ec 0c             	sub    $0xc,%esp
801067b1:	68 80 9b 11 80       	push   $0x80119b80
801067b6:	e8 50 e7 ff ff       	call   80104f0b <release>
801067bb:	83 c4 10             	add    $0x10,%esp
    }
    lapiceoi();
801067be:	e8 3d c8 ff ff       	call   80103000 <lapiceoi>
//******************   new code   ****************
    uint address = (uint)myproc()->scheduler; //************* modified
801067c3:	e8 4c d7 ff ff       	call   80103f14 <myproc>
801067c8:	8b 80 80 00 00 00    	mov    0x80(%eax),%eax
801067ce:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    scheduler_func func = (scheduler_func)(uintptr_t)address; //********* modified
801067d1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801067d4:	89 45 e0             	mov    %eax,-0x20(%ebp)
    func(); 
801067d7:	8b 45 e0             	mov    -0x20(%ebp),%eax
801067da:	ff d0                	call   *%eax
//******************   new code   ****************



    break;
801067dc:	e9 20 01 00 00       	jmp    80106901 <trap+0x1f3>
       
  case T_IRQ0 + IRQ_IDE:
    ideintr();
801067e1:	e8 70 c0 ff ff       	call   80102856 <ideintr>
    lapiceoi();
801067e6:	e8 15 c8 ff ff       	call   80103000 <lapiceoi>
    break;
801067eb:	e9 11 01 00 00       	jmp    80106901 <trap+0x1f3>
  case T_IRQ0 + IRQ_IDE+1:
    // Bochs generates spurious IDE1 interrupts.
    break;
  case T_IRQ0 + IRQ_KBD:
    kbdintr();
801067f0:	e8 50 c6 ff ff       	call   80102e45 <kbdintr>
    lapiceoi();
801067f5:	e8 06 c8 ff ff       	call   80103000 <lapiceoi>
    break;
801067fa:	e9 02 01 00 00       	jmp    80106901 <trap+0x1f3>
  case T_IRQ0 + IRQ_COM1:
    uartintr();
801067ff:	e8 53 03 00 00       	call   80106b57 <uartintr>
    lapiceoi();
80106804:	e8 f7 c7 ff ff       	call   80103000 <lapiceoi>
    break;
80106809:	e9 f3 00 00 00       	jmp    80106901 <trap+0x1f3>
  case T_IRQ0 + 0xB:
    i8254_intr();
8010680e:	e8 7b 2b 00 00       	call   8010938e <i8254_intr>
    lapiceoi();
80106813:	e8 e8 c7 ff ff       	call   80103000 <lapiceoi>
    break;
80106818:	e9 e4 00 00 00       	jmp    80106901 <trap+0x1f3>
  case T_IRQ0 + IRQ_SPURIOUS:
    cprintf("cpu%d: spurious interrupt at %x:%x\n",
8010681d:	8b 45 08             	mov    0x8(%ebp),%eax
80106820:	8b 70 38             	mov    0x38(%eax),%esi
            cpuid(), tf->cs, tf->eip);
80106823:	8b 45 08             	mov    0x8(%ebp),%eax
80106826:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
    cprintf("cpu%d: spurious interrupt at %x:%x\n",
8010682a:	0f b7 d8             	movzwl %ax,%ebx
8010682d:	e8 4f d6 ff ff       	call   80103e81 <cpuid>
80106832:	56                   	push   %esi
80106833:	53                   	push   %ebx
80106834:	50                   	push   %eax
80106835:	68 84 ab 10 80       	push   $0x8010ab84
8010683a:	e8 b5 9b ff ff       	call   801003f4 <cprintf>
8010683f:	83 c4 10             	add    $0x10,%esp
    lapiceoi();
80106842:	e8 b9 c7 ff ff       	call   80103000 <lapiceoi>
    break;
80106847:	e9 b5 00 00 00       	jmp    80106901 <trap+0x1f3>

  //PAGEBREAK: 13
  default:
    if(myproc() == 0 || (tf->cs&3) == 0){
8010684c:	e8 c3 d6 ff ff       	call   80103f14 <myproc>
80106851:	85 c0                	test   %eax,%eax
80106853:	74 11                	je     80106866 <trap+0x158>
80106855:	8b 45 08             	mov    0x8(%ebp),%eax
80106858:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
8010685c:	0f b7 c0             	movzwl %ax,%eax
8010685f:	83 e0 03             	and    $0x3,%eax
80106862:	85 c0                	test   %eax,%eax
80106864:	75 39                	jne    8010689f <trap+0x191>
      // In kernel, it must be our mistake.
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
80106866:	e8 04 fd ff ff       	call   8010656f <rcr2>
8010686b:	89 c3                	mov    %eax,%ebx
8010686d:	8b 45 08             	mov    0x8(%ebp),%eax
80106870:	8b 70 38             	mov    0x38(%eax),%esi
80106873:	e8 09 d6 ff ff       	call   80103e81 <cpuid>
80106878:	8b 55 08             	mov    0x8(%ebp),%edx
8010687b:	8b 52 30             	mov    0x30(%edx),%edx
8010687e:	83 ec 0c             	sub    $0xc,%esp
80106881:	53                   	push   %ebx
80106882:	56                   	push   %esi
80106883:	50                   	push   %eax
80106884:	52                   	push   %edx
80106885:	68 a8 ab 10 80       	push   $0x8010aba8
8010688a:	e8 65 9b ff ff       	call   801003f4 <cprintf>
8010688f:	83 c4 20             	add    $0x20,%esp
              tf->trapno, cpuid(), tf->eip, rcr2());
      panic("trap");
80106892:	83 ec 0c             	sub    $0xc,%esp
80106895:	68 da ab 10 80       	push   $0x8010abda
8010689a:	e8 0a 9d ff ff       	call   801005a9 <panic>
    }
    // In user space, assume process misbehaved.
    cprintf("pid %d %s: trap %d err %d on cpu %d "
8010689f:	e8 cb fc ff ff       	call   8010656f <rcr2>
801068a4:	89 c6                	mov    %eax,%esi
801068a6:	8b 45 08             	mov    0x8(%ebp),%eax
801068a9:	8b 40 38             	mov    0x38(%eax),%eax
801068ac:	89 45 d4             	mov    %eax,-0x2c(%ebp)
801068af:	e8 cd d5 ff ff       	call   80103e81 <cpuid>
801068b4:	89 c3                	mov    %eax,%ebx
801068b6:	8b 45 08             	mov    0x8(%ebp),%eax
801068b9:	8b 48 34             	mov    0x34(%eax),%ecx
801068bc:	89 4d d0             	mov    %ecx,-0x30(%ebp)
801068bf:	8b 45 08             	mov    0x8(%ebp),%eax
801068c2:	8b 78 30             	mov    0x30(%eax),%edi
            "eip 0x%x addr 0x%x--kill proc\n",
            myproc()->pid, myproc()->name, tf->trapno,
801068c5:	e8 4a d6 ff ff       	call   80103f14 <myproc>
801068ca:	8d 50 6c             	lea    0x6c(%eax),%edx
801068cd:	89 55 cc             	mov    %edx,-0x34(%ebp)
801068d0:	e8 3f d6 ff ff       	call   80103f14 <myproc>
    cprintf("pid %d %s: trap %d err %d on cpu %d "
801068d5:	8b 40 10             	mov    0x10(%eax),%eax
801068d8:	56                   	push   %esi
801068d9:	ff 75 d4             	push   -0x2c(%ebp)
801068dc:	53                   	push   %ebx
801068dd:	ff 75 d0             	push   -0x30(%ebp)
801068e0:	57                   	push   %edi
801068e1:	ff 75 cc             	push   -0x34(%ebp)
801068e4:	50                   	push   %eax
801068e5:	68 e0 ab 10 80       	push   $0x8010abe0
801068ea:	e8 05 9b ff ff       	call   801003f4 <cprintf>
801068ef:	83 c4 20             	add    $0x20,%esp
            tf->err, cpuid(), tf->eip, rcr2());
    myproc()->killed = 1;
801068f2:	e8 1d d6 ff ff       	call   80103f14 <myproc>
801068f7:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
801068fe:	eb 01                	jmp    80106901 <trap+0x1f3>
    break;
80106900:	90                   	nop
  }

  // Force process exit if it has been killed and is in user space.
  // (If it is still executing in the kernel, let it keep running
  // until it gets to the regular system call return.)
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80106901:	e8 0e d6 ff ff       	call   80103f14 <myproc>
80106906:	85 c0                	test   %eax,%eax
80106908:	74 23                	je     8010692d <trap+0x21f>
8010690a:	e8 05 d6 ff ff       	call   80103f14 <myproc>
8010690f:	8b 40 24             	mov    0x24(%eax),%eax
80106912:	85 c0                	test   %eax,%eax
80106914:	74 17                	je     8010692d <trap+0x21f>
80106916:	8b 45 08             	mov    0x8(%ebp),%eax
80106919:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
8010691d:	0f b7 c0             	movzwl %ax,%eax
80106920:	83 e0 03             	and    $0x3,%eax
80106923:	83 f8 03             	cmp    $0x3,%eax
80106926:	75 05                	jne    8010692d <trap+0x21f>
    exit();
80106928:	e8 62 da ff ff       	call   8010438f <exit>

  // Force process to give up CPU on clock tick.
  // If interrupts were on while locks held, would need to check nlock.
  if(myproc() && myproc()->state == RUNNING &&
8010692d:	e8 e2 d5 ff ff       	call   80103f14 <myproc>
80106932:	85 c0                	test   %eax,%eax
80106934:	74 1d                	je     80106953 <trap+0x245>
80106936:	e8 d9 d5 ff ff       	call   80103f14 <myproc>
8010693b:	8b 40 0c             	mov    0xc(%eax),%eax
8010693e:	83 f8 04             	cmp    $0x4,%eax
80106941:	75 10                	jne    80106953 <trap+0x245>
     tf->trapno == T_IRQ0+IRQ_TIMER)
80106943:	8b 45 08             	mov    0x8(%ebp),%eax
80106946:	8b 40 30             	mov    0x30(%eax),%eax
  if(myproc() && myproc()->state == RUNNING &&
80106949:	83 f8 20             	cmp    $0x20,%eax
8010694c:	75 05                	jne    80106953 <trap+0x245>
    yield();
8010694e:	e8 a6 e0 ff ff       	call   801049f9 <yield>

  // Check if the process has been killed since we yielded
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80106953:	e8 bc d5 ff ff       	call   80103f14 <myproc>
80106958:	85 c0                	test   %eax,%eax
8010695a:	74 26                	je     80106982 <trap+0x274>
8010695c:	e8 b3 d5 ff ff       	call   80103f14 <myproc>
80106961:	8b 40 24             	mov    0x24(%eax),%eax
80106964:	85 c0                	test   %eax,%eax
80106966:	74 1a                	je     80106982 <trap+0x274>
80106968:	8b 45 08             	mov    0x8(%ebp),%eax
8010696b:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
8010696f:	0f b7 c0             	movzwl %ax,%eax
80106972:	83 e0 03             	and    $0x3,%eax
80106975:	83 f8 03             	cmp    $0x3,%eax
80106978:	75 08                	jne    80106982 <trap+0x274>
    exit();
8010697a:	e8 10 da ff ff       	call   8010438f <exit>
8010697f:	eb 01                	jmp    80106982 <trap+0x274>
    return;
80106981:	90                   	nop
}
80106982:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106985:	5b                   	pop    %ebx
80106986:	5e                   	pop    %esi
80106987:	5f                   	pop    %edi
80106988:	5d                   	pop    %ebp
80106989:	c3                   	ret    

8010698a <inb>:
{
8010698a:	55                   	push   %ebp
8010698b:	89 e5                	mov    %esp,%ebp
8010698d:	83 ec 14             	sub    $0x14,%esp
80106990:	8b 45 08             	mov    0x8(%ebp),%eax
80106993:	66 89 45 ec          	mov    %ax,-0x14(%ebp)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80106997:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
8010699b:	89 c2                	mov    %eax,%edx
8010699d:	ec                   	in     (%dx),%al
8010699e:	88 45 ff             	mov    %al,-0x1(%ebp)
  return data;
801069a1:	0f b6 45 ff          	movzbl -0x1(%ebp),%eax
}
801069a5:	c9                   	leave  
801069a6:	c3                   	ret    

801069a7 <outb>:
{
801069a7:	55                   	push   %ebp
801069a8:	89 e5                	mov    %esp,%ebp
801069aa:	83 ec 08             	sub    $0x8,%esp
801069ad:	8b 45 08             	mov    0x8(%ebp),%eax
801069b0:	8b 55 0c             	mov    0xc(%ebp),%edx
801069b3:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
801069b7:	89 d0                	mov    %edx,%eax
801069b9:	88 45 f8             	mov    %al,-0x8(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801069bc:	0f b6 45 f8          	movzbl -0x8(%ebp),%eax
801069c0:	0f b7 55 fc          	movzwl -0x4(%ebp),%edx
801069c4:	ee                   	out    %al,(%dx)
}
801069c5:	90                   	nop
801069c6:	c9                   	leave  
801069c7:	c3                   	ret    

801069c8 <uartinit>:

static int uart;    // is there a uart?

void
uartinit(void)
{
801069c8:	55                   	push   %ebp
801069c9:	89 e5                	mov    %esp,%ebp
801069cb:	83 ec 18             	sub    $0x18,%esp
  char *p;

  // Turn off the FIFO
  outb(COM1+2, 0);
801069ce:	6a 00                	push   $0x0
801069d0:	68 fa 03 00 00       	push   $0x3fa
801069d5:	e8 cd ff ff ff       	call   801069a7 <outb>
801069da:	83 c4 08             	add    $0x8,%esp

  // 9600 baud, 8 data bits, 1 stop bit, parity off.
  outb(COM1+3, 0x80);    // Unlock divisor
801069dd:	68 80 00 00 00       	push   $0x80
801069e2:	68 fb 03 00 00       	push   $0x3fb
801069e7:	e8 bb ff ff ff       	call   801069a7 <outb>
801069ec:	83 c4 08             	add    $0x8,%esp
  outb(COM1+0, 115200/9600);
801069ef:	6a 0c                	push   $0xc
801069f1:	68 f8 03 00 00       	push   $0x3f8
801069f6:	e8 ac ff ff ff       	call   801069a7 <outb>
801069fb:	83 c4 08             	add    $0x8,%esp
  outb(COM1+1, 0);
801069fe:	6a 00                	push   $0x0
80106a00:	68 f9 03 00 00       	push   $0x3f9
80106a05:	e8 9d ff ff ff       	call   801069a7 <outb>
80106a0a:	83 c4 08             	add    $0x8,%esp
  outb(COM1+3, 0x03);    // Lock divisor, 8 data bits.
80106a0d:	6a 03                	push   $0x3
80106a0f:	68 fb 03 00 00       	push   $0x3fb
80106a14:	e8 8e ff ff ff       	call   801069a7 <outb>
80106a19:	83 c4 08             	add    $0x8,%esp
  outb(COM1+4, 0);
80106a1c:	6a 00                	push   $0x0
80106a1e:	68 fc 03 00 00       	push   $0x3fc
80106a23:	e8 7f ff ff ff       	call   801069a7 <outb>
80106a28:	83 c4 08             	add    $0x8,%esp
  outb(COM1+1, 0x01);    // Enable receive interrupts.
80106a2b:	6a 01                	push   $0x1
80106a2d:	68 f9 03 00 00       	push   $0x3f9
80106a32:	e8 70 ff ff ff       	call   801069a7 <outb>
80106a37:	83 c4 08             	add    $0x8,%esp

  // If status is 0xFF, no serial port.
  if(inb(COM1+5) == 0xFF)
80106a3a:	68 fd 03 00 00       	push   $0x3fd
80106a3f:	e8 46 ff ff ff       	call   8010698a <inb>
80106a44:	83 c4 04             	add    $0x4,%esp
80106a47:	3c ff                	cmp    $0xff,%al
80106a49:	74 61                	je     80106aac <uartinit+0xe4>
    return;
  uart = 1;
80106a4b:	c7 05 b8 9b 11 80 01 	movl   $0x1,0x80119bb8
80106a52:	00 00 00 

  // Acknowledge pre-existing interrupt conditions;
  // enable interrupts.
  inb(COM1+2);
80106a55:	68 fa 03 00 00       	push   $0x3fa
80106a5a:	e8 2b ff ff ff       	call   8010698a <inb>
80106a5f:	83 c4 04             	add    $0x4,%esp
  inb(COM1+0);
80106a62:	68 f8 03 00 00       	push   $0x3f8
80106a67:	e8 1e ff ff ff       	call   8010698a <inb>
80106a6c:	83 c4 04             	add    $0x4,%esp
  ioapicenable(IRQ_COM1, 0);
80106a6f:	83 ec 08             	sub    $0x8,%esp
80106a72:	6a 00                	push   $0x0
80106a74:	6a 04                	push   $0x4
80106a76:	e8 97 c0 ff ff       	call   80102b12 <ioapicenable>
80106a7b:	83 c4 10             	add    $0x10,%esp

  // Announce that we're here.
  for(p="xv6...\n"; *p; p++)
80106a7e:	c7 45 f4 a4 ac 10 80 	movl   $0x8010aca4,-0xc(%ebp)
80106a85:	eb 19                	jmp    80106aa0 <uartinit+0xd8>
    uartputc(*p);
80106a87:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106a8a:	0f b6 00             	movzbl (%eax),%eax
80106a8d:	0f be c0             	movsbl %al,%eax
80106a90:	83 ec 0c             	sub    $0xc,%esp
80106a93:	50                   	push   %eax
80106a94:	e8 16 00 00 00       	call   80106aaf <uartputc>
80106a99:	83 c4 10             	add    $0x10,%esp
  for(p="xv6...\n"; *p; p++)
80106a9c:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80106aa0:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106aa3:	0f b6 00             	movzbl (%eax),%eax
80106aa6:	84 c0                	test   %al,%al
80106aa8:	75 dd                	jne    80106a87 <uartinit+0xbf>
80106aaa:	eb 01                	jmp    80106aad <uartinit+0xe5>
    return;
80106aac:	90                   	nop
}
80106aad:	c9                   	leave  
80106aae:	c3                   	ret    

80106aaf <uartputc>:

void
uartputc(int c)
{
80106aaf:	55                   	push   %ebp
80106ab0:	89 e5                	mov    %esp,%ebp
80106ab2:	83 ec 18             	sub    $0x18,%esp
  int i;

  if(!uart)
80106ab5:	a1 b8 9b 11 80       	mov    0x80119bb8,%eax
80106aba:	85 c0                	test   %eax,%eax
80106abc:	74 53                	je     80106b11 <uartputc+0x62>
    return;
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
80106abe:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80106ac5:	eb 11                	jmp    80106ad8 <uartputc+0x29>
    microdelay(10);
80106ac7:	83 ec 0c             	sub    $0xc,%esp
80106aca:	6a 0a                	push   $0xa
80106acc:	e8 4a c5 ff ff       	call   8010301b <microdelay>
80106ad1:	83 c4 10             	add    $0x10,%esp
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
80106ad4:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80106ad8:	83 7d f4 7f          	cmpl   $0x7f,-0xc(%ebp)
80106adc:	7f 1a                	jg     80106af8 <uartputc+0x49>
80106ade:	83 ec 0c             	sub    $0xc,%esp
80106ae1:	68 fd 03 00 00       	push   $0x3fd
80106ae6:	e8 9f fe ff ff       	call   8010698a <inb>
80106aeb:	83 c4 10             	add    $0x10,%esp
80106aee:	0f b6 c0             	movzbl %al,%eax
80106af1:	83 e0 20             	and    $0x20,%eax
80106af4:	85 c0                	test   %eax,%eax
80106af6:	74 cf                	je     80106ac7 <uartputc+0x18>
  outb(COM1+0, c);
80106af8:	8b 45 08             	mov    0x8(%ebp),%eax
80106afb:	0f b6 c0             	movzbl %al,%eax
80106afe:	83 ec 08             	sub    $0x8,%esp
80106b01:	50                   	push   %eax
80106b02:	68 f8 03 00 00       	push   $0x3f8
80106b07:	e8 9b fe ff ff       	call   801069a7 <outb>
80106b0c:	83 c4 10             	add    $0x10,%esp
80106b0f:	eb 01                	jmp    80106b12 <uartputc+0x63>
    return;
80106b11:	90                   	nop
}
80106b12:	c9                   	leave  
80106b13:	c3                   	ret    

80106b14 <uartgetc>:

static int
uartgetc(void)
{
80106b14:	55                   	push   %ebp
80106b15:	89 e5                	mov    %esp,%ebp
  if(!uart)
80106b17:	a1 b8 9b 11 80       	mov    0x80119bb8,%eax
80106b1c:	85 c0                	test   %eax,%eax
80106b1e:	75 07                	jne    80106b27 <uartgetc+0x13>
    return -1;
80106b20:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106b25:	eb 2e                	jmp    80106b55 <uartgetc+0x41>
  if(!(inb(COM1+5) & 0x01))
80106b27:	68 fd 03 00 00       	push   $0x3fd
80106b2c:	e8 59 fe ff ff       	call   8010698a <inb>
80106b31:	83 c4 04             	add    $0x4,%esp
80106b34:	0f b6 c0             	movzbl %al,%eax
80106b37:	83 e0 01             	and    $0x1,%eax
80106b3a:	85 c0                	test   %eax,%eax
80106b3c:	75 07                	jne    80106b45 <uartgetc+0x31>
    return -1;
80106b3e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106b43:	eb 10                	jmp    80106b55 <uartgetc+0x41>
  return inb(COM1+0);
80106b45:	68 f8 03 00 00       	push   $0x3f8
80106b4a:	e8 3b fe ff ff       	call   8010698a <inb>
80106b4f:	83 c4 04             	add    $0x4,%esp
80106b52:	0f b6 c0             	movzbl %al,%eax
}
80106b55:	c9                   	leave  
80106b56:	c3                   	ret    

80106b57 <uartintr>:

void
uartintr(void)
{
80106b57:	55                   	push   %ebp
80106b58:	89 e5                	mov    %esp,%ebp
80106b5a:	83 ec 08             	sub    $0x8,%esp
  consoleintr(uartgetc);
80106b5d:	83 ec 0c             	sub    $0xc,%esp
80106b60:	68 14 6b 10 80       	push   $0x80106b14
80106b65:	e8 6c 9c ff ff       	call   801007d6 <consoleintr>
80106b6a:	83 c4 10             	add    $0x10,%esp
}
80106b6d:	90                   	nop
80106b6e:	c9                   	leave  
80106b6f:	c3                   	ret    

80106b70 <vector0>:
80106b70:	6a 00                	push   $0x0
80106b72:	6a 00                	push   $0x0
80106b74:	e9 a9 f9 ff ff       	jmp    80106522 <alltraps>

80106b79 <vector1>:
80106b79:	6a 00                	push   $0x0
80106b7b:	6a 01                	push   $0x1
80106b7d:	e9 a0 f9 ff ff       	jmp    80106522 <alltraps>

80106b82 <vector2>:
80106b82:	6a 00                	push   $0x0
80106b84:	6a 02                	push   $0x2
80106b86:	e9 97 f9 ff ff       	jmp    80106522 <alltraps>

80106b8b <vector3>:
80106b8b:	6a 00                	push   $0x0
80106b8d:	6a 03                	push   $0x3
80106b8f:	e9 8e f9 ff ff       	jmp    80106522 <alltraps>

80106b94 <vector4>:
80106b94:	6a 00                	push   $0x0
80106b96:	6a 04                	push   $0x4
80106b98:	e9 85 f9 ff ff       	jmp    80106522 <alltraps>

80106b9d <vector5>:
80106b9d:	6a 00                	push   $0x0
80106b9f:	6a 05                	push   $0x5
80106ba1:	e9 7c f9 ff ff       	jmp    80106522 <alltraps>

80106ba6 <vector6>:
80106ba6:	6a 00                	push   $0x0
80106ba8:	6a 06                	push   $0x6
80106baa:	e9 73 f9 ff ff       	jmp    80106522 <alltraps>

80106baf <vector7>:
80106baf:	6a 00                	push   $0x0
80106bb1:	6a 07                	push   $0x7
80106bb3:	e9 6a f9 ff ff       	jmp    80106522 <alltraps>

80106bb8 <vector8>:
80106bb8:	6a 08                	push   $0x8
80106bba:	e9 63 f9 ff ff       	jmp    80106522 <alltraps>

80106bbf <vector9>:
80106bbf:	6a 00                	push   $0x0
80106bc1:	6a 09                	push   $0x9
80106bc3:	e9 5a f9 ff ff       	jmp    80106522 <alltraps>

80106bc8 <vector10>:
80106bc8:	6a 0a                	push   $0xa
80106bca:	e9 53 f9 ff ff       	jmp    80106522 <alltraps>

80106bcf <vector11>:
80106bcf:	6a 0b                	push   $0xb
80106bd1:	e9 4c f9 ff ff       	jmp    80106522 <alltraps>

80106bd6 <vector12>:
80106bd6:	6a 0c                	push   $0xc
80106bd8:	e9 45 f9 ff ff       	jmp    80106522 <alltraps>

80106bdd <vector13>:
80106bdd:	6a 0d                	push   $0xd
80106bdf:	e9 3e f9 ff ff       	jmp    80106522 <alltraps>

80106be4 <vector14>:
80106be4:	6a 0e                	push   $0xe
80106be6:	e9 37 f9 ff ff       	jmp    80106522 <alltraps>

80106beb <vector15>:
80106beb:	6a 00                	push   $0x0
80106bed:	6a 0f                	push   $0xf
80106bef:	e9 2e f9 ff ff       	jmp    80106522 <alltraps>

80106bf4 <vector16>:
80106bf4:	6a 00                	push   $0x0
80106bf6:	6a 10                	push   $0x10
80106bf8:	e9 25 f9 ff ff       	jmp    80106522 <alltraps>

80106bfd <vector17>:
80106bfd:	6a 11                	push   $0x11
80106bff:	e9 1e f9 ff ff       	jmp    80106522 <alltraps>

80106c04 <vector18>:
80106c04:	6a 00                	push   $0x0
80106c06:	6a 12                	push   $0x12
80106c08:	e9 15 f9 ff ff       	jmp    80106522 <alltraps>

80106c0d <vector19>:
80106c0d:	6a 00                	push   $0x0
80106c0f:	6a 13                	push   $0x13
80106c11:	e9 0c f9 ff ff       	jmp    80106522 <alltraps>

80106c16 <vector20>:
80106c16:	6a 00                	push   $0x0
80106c18:	6a 14                	push   $0x14
80106c1a:	e9 03 f9 ff ff       	jmp    80106522 <alltraps>

80106c1f <vector21>:
80106c1f:	6a 00                	push   $0x0
80106c21:	6a 15                	push   $0x15
80106c23:	e9 fa f8 ff ff       	jmp    80106522 <alltraps>

80106c28 <vector22>:
80106c28:	6a 00                	push   $0x0
80106c2a:	6a 16                	push   $0x16
80106c2c:	e9 f1 f8 ff ff       	jmp    80106522 <alltraps>

80106c31 <vector23>:
80106c31:	6a 00                	push   $0x0
80106c33:	6a 17                	push   $0x17
80106c35:	e9 e8 f8 ff ff       	jmp    80106522 <alltraps>

80106c3a <vector24>:
80106c3a:	6a 00                	push   $0x0
80106c3c:	6a 18                	push   $0x18
80106c3e:	e9 df f8 ff ff       	jmp    80106522 <alltraps>

80106c43 <vector25>:
80106c43:	6a 00                	push   $0x0
80106c45:	6a 19                	push   $0x19
80106c47:	e9 d6 f8 ff ff       	jmp    80106522 <alltraps>

80106c4c <vector26>:
80106c4c:	6a 00                	push   $0x0
80106c4e:	6a 1a                	push   $0x1a
80106c50:	e9 cd f8 ff ff       	jmp    80106522 <alltraps>

80106c55 <vector27>:
80106c55:	6a 00                	push   $0x0
80106c57:	6a 1b                	push   $0x1b
80106c59:	e9 c4 f8 ff ff       	jmp    80106522 <alltraps>

80106c5e <vector28>:
80106c5e:	6a 00                	push   $0x0
80106c60:	6a 1c                	push   $0x1c
80106c62:	e9 bb f8 ff ff       	jmp    80106522 <alltraps>

80106c67 <vector29>:
80106c67:	6a 00                	push   $0x0
80106c69:	6a 1d                	push   $0x1d
80106c6b:	e9 b2 f8 ff ff       	jmp    80106522 <alltraps>

80106c70 <vector30>:
80106c70:	6a 00                	push   $0x0
80106c72:	6a 1e                	push   $0x1e
80106c74:	e9 a9 f8 ff ff       	jmp    80106522 <alltraps>

80106c79 <vector31>:
80106c79:	6a 00                	push   $0x0
80106c7b:	6a 1f                	push   $0x1f
80106c7d:	e9 a0 f8 ff ff       	jmp    80106522 <alltraps>

80106c82 <vector32>:
80106c82:	6a 00                	push   $0x0
80106c84:	6a 20                	push   $0x20
80106c86:	e9 97 f8 ff ff       	jmp    80106522 <alltraps>

80106c8b <vector33>:
80106c8b:	6a 00                	push   $0x0
80106c8d:	6a 21                	push   $0x21
80106c8f:	e9 8e f8 ff ff       	jmp    80106522 <alltraps>

80106c94 <vector34>:
80106c94:	6a 00                	push   $0x0
80106c96:	6a 22                	push   $0x22
80106c98:	e9 85 f8 ff ff       	jmp    80106522 <alltraps>

80106c9d <vector35>:
80106c9d:	6a 00                	push   $0x0
80106c9f:	6a 23                	push   $0x23
80106ca1:	e9 7c f8 ff ff       	jmp    80106522 <alltraps>

80106ca6 <vector36>:
80106ca6:	6a 00                	push   $0x0
80106ca8:	6a 24                	push   $0x24
80106caa:	e9 73 f8 ff ff       	jmp    80106522 <alltraps>

80106caf <vector37>:
80106caf:	6a 00                	push   $0x0
80106cb1:	6a 25                	push   $0x25
80106cb3:	e9 6a f8 ff ff       	jmp    80106522 <alltraps>

80106cb8 <vector38>:
80106cb8:	6a 00                	push   $0x0
80106cba:	6a 26                	push   $0x26
80106cbc:	e9 61 f8 ff ff       	jmp    80106522 <alltraps>

80106cc1 <vector39>:
80106cc1:	6a 00                	push   $0x0
80106cc3:	6a 27                	push   $0x27
80106cc5:	e9 58 f8 ff ff       	jmp    80106522 <alltraps>

80106cca <vector40>:
80106cca:	6a 00                	push   $0x0
80106ccc:	6a 28                	push   $0x28
80106cce:	e9 4f f8 ff ff       	jmp    80106522 <alltraps>

80106cd3 <vector41>:
80106cd3:	6a 00                	push   $0x0
80106cd5:	6a 29                	push   $0x29
80106cd7:	e9 46 f8 ff ff       	jmp    80106522 <alltraps>

80106cdc <vector42>:
80106cdc:	6a 00                	push   $0x0
80106cde:	6a 2a                	push   $0x2a
80106ce0:	e9 3d f8 ff ff       	jmp    80106522 <alltraps>

80106ce5 <vector43>:
80106ce5:	6a 00                	push   $0x0
80106ce7:	6a 2b                	push   $0x2b
80106ce9:	e9 34 f8 ff ff       	jmp    80106522 <alltraps>

80106cee <vector44>:
80106cee:	6a 00                	push   $0x0
80106cf0:	6a 2c                	push   $0x2c
80106cf2:	e9 2b f8 ff ff       	jmp    80106522 <alltraps>

80106cf7 <vector45>:
80106cf7:	6a 00                	push   $0x0
80106cf9:	6a 2d                	push   $0x2d
80106cfb:	e9 22 f8 ff ff       	jmp    80106522 <alltraps>

80106d00 <vector46>:
80106d00:	6a 00                	push   $0x0
80106d02:	6a 2e                	push   $0x2e
80106d04:	e9 19 f8 ff ff       	jmp    80106522 <alltraps>

80106d09 <vector47>:
80106d09:	6a 00                	push   $0x0
80106d0b:	6a 2f                	push   $0x2f
80106d0d:	e9 10 f8 ff ff       	jmp    80106522 <alltraps>

80106d12 <vector48>:
80106d12:	6a 00                	push   $0x0
80106d14:	6a 30                	push   $0x30
80106d16:	e9 07 f8 ff ff       	jmp    80106522 <alltraps>

80106d1b <vector49>:
80106d1b:	6a 00                	push   $0x0
80106d1d:	6a 31                	push   $0x31
80106d1f:	e9 fe f7 ff ff       	jmp    80106522 <alltraps>

80106d24 <vector50>:
80106d24:	6a 00                	push   $0x0
80106d26:	6a 32                	push   $0x32
80106d28:	e9 f5 f7 ff ff       	jmp    80106522 <alltraps>

80106d2d <vector51>:
80106d2d:	6a 00                	push   $0x0
80106d2f:	6a 33                	push   $0x33
80106d31:	e9 ec f7 ff ff       	jmp    80106522 <alltraps>

80106d36 <vector52>:
80106d36:	6a 00                	push   $0x0
80106d38:	6a 34                	push   $0x34
80106d3a:	e9 e3 f7 ff ff       	jmp    80106522 <alltraps>

80106d3f <vector53>:
80106d3f:	6a 00                	push   $0x0
80106d41:	6a 35                	push   $0x35
80106d43:	e9 da f7 ff ff       	jmp    80106522 <alltraps>

80106d48 <vector54>:
80106d48:	6a 00                	push   $0x0
80106d4a:	6a 36                	push   $0x36
80106d4c:	e9 d1 f7 ff ff       	jmp    80106522 <alltraps>

80106d51 <vector55>:
80106d51:	6a 00                	push   $0x0
80106d53:	6a 37                	push   $0x37
80106d55:	e9 c8 f7 ff ff       	jmp    80106522 <alltraps>

80106d5a <vector56>:
80106d5a:	6a 00                	push   $0x0
80106d5c:	6a 38                	push   $0x38
80106d5e:	e9 bf f7 ff ff       	jmp    80106522 <alltraps>

80106d63 <vector57>:
80106d63:	6a 00                	push   $0x0
80106d65:	6a 39                	push   $0x39
80106d67:	e9 b6 f7 ff ff       	jmp    80106522 <alltraps>

80106d6c <vector58>:
80106d6c:	6a 00                	push   $0x0
80106d6e:	6a 3a                	push   $0x3a
80106d70:	e9 ad f7 ff ff       	jmp    80106522 <alltraps>

80106d75 <vector59>:
80106d75:	6a 00                	push   $0x0
80106d77:	6a 3b                	push   $0x3b
80106d79:	e9 a4 f7 ff ff       	jmp    80106522 <alltraps>

80106d7e <vector60>:
80106d7e:	6a 00                	push   $0x0
80106d80:	6a 3c                	push   $0x3c
80106d82:	e9 9b f7 ff ff       	jmp    80106522 <alltraps>

80106d87 <vector61>:
80106d87:	6a 00                	push   $0x0
80106d89:	6a 3d                	push   $0x3d
80106d8b:	e9 92 f7 ff ff       	jmp    80106522 <alltraps>

80106d90 <vector62>:
80106d90:	6a 00                	push   $0x0
80106d92:	6a 3e                	push   $0x3e
80106d94:	e9 89 f7 ff ff       	jmp    80106522 <alltraps>

80106d99 <vector63>:
80106d99:	6a 00                	push   $0x0
80106d9b:	6a 3f                	push   $0x3f
80106d9d:	e9 80 f7 ff ff       	jmp    80106522 <alltraps>

80106da2 <vector64>:
80106da2:	6a 00                	push   $0x0
80106da4:	6a 40                	push   $0x40
80106da6:	e9 77 f7 ff ff       	jmp    80106522 <alltraps>

80106dab <vector65>:
80106dab:	6a 00                	push   $0x0
80106dad:	6a 41                	push   $0x41
80106daf:	e9 6e f7 ff ff       	jmp    80106522 <alltraps>

80106db4 <vector66>:
80106db4:	6a 00                	push   $0x0
80106db6:	6a 42                	push   $0x42
80106db8:	e9 65 f7 ff ff       	jmp    80106522 <alltraps>

80106dbd <vector67>:
80106dbd:	6a 00                	push   $0x0
80106dbf:	6a 43                	push   $0x43
80106dc1:	e9 5c f7 ff ff       	jmp    80106522 <alltraps>

80106dc6 <vector68>:
80106dc6:	6a 00                	push   $0x0
80106dc8:	6a 44                	push   $0x44
80106dca:	e9 53 f7 ff ff       	jmp    80106522 <alltraps>

80106dcf <vector69>:
80106dcf:	6a 00                	push   $0x0
80106dd1:	6a 45                	push   $0x45
80106dd3:	e9 4a f7 ff ff       	jmp    80106522 <alltraps>

80106dd8 <vector70>:
80106dd8:	6a 00                	push   $0x0
80106dda:	6a 46                	push   $0x46
80106ddc:	e9 41 f7 ff ff       	jmp    80106522 <alltraps>

80106de1 <vector71>:
80106de1:	6a 00                	push   $0x0
80106de3:	6a 47                	push   $0x47
80106de5:	e9 38 f7 ff ff       	jmp    80106522 <alltraps>

80106dea <vector72>:
80106dea:	6a 00                	push   $0x0
80106dec:	6a 48                	push   $0x48
80106dee:	e9 2f f7 ff ff       	jmp    80106522 <alltraps>

80106df3 <vector73>:
80106df3:	6a 00                	push   $0x0
80106df5:	6a 49                	push   $0x49
80106df7:	e9 26 f7 ff ff       	jmp    80106522 <alltraps>

80106dfc <vector74>:
80106dfc:	6a 00                	push   $0x0
80106dfe:	6a 4a                	push   $0x4a
80106e00:	e9 1d f7 ff ff       	jmp    80106522 <alltraps>

80106e05 <vector75>:
80106e05:	6a 00                	push   $0x0
80106e07:	6a 4b                	push   $0x4b
80106e09:	e9 14 f7 ff ff       	jmp    80106522 <alltraps>

80106e0e <vector76>:
80106e0e:	6a 00                	push   $0x0
80106e10:	6a 4c                	push   $0x4c
80106e12:	e9 0b f7 ff ff       	jmp    80106522 <alltraps>

80106e17 <vector77>:
80106e17:	6a 00                	push   $0x0
80106e19:	6a 4d                	push   $0x4d
80106e1b:	e9 02 f7 ff ff       	jmp    80106522 <alltraps>

80106e20 <vector78>:
80106e20:	6a 00                	push   $0x0
80106e22:	6a 4e                	push   $0x4e
80106e24:	e9 f9 f6 ff ff       	jmp    80106522 <alltraps>

80106e29 <vector79>:
80106e29:	6a 00                	push   $0x0
80106e2b:	6a 4f                	push   $0x4f
80106e2d:	e9 f0 f6 ff ff       	jmp    80106522 <alltraps>

80106e32 <vector80>:
80106e32:	6a 00                	push   $0x0
80106e34:	6a 50                	push   $0x50
80106e36:	e9 e7 f6 ff ff       	jmp    80106522 <alltraps>

80106e3b <vector81>:
80106e3b:	6a 00                	push   $0x0
80106e3d:	6a 51                	push   $0x51
80106e3f:	e9 de f6 ff ff       	jmp    80106522 <alltraps>

80106e44 <vector82>:
80106e44:	6a 00                	push   $0x0
80106e46:	6a 52                	push   $0x52
80106e48:	e9 d5 f6 ff ff       	jmp    80106522 <alltraps>

80106e4d <vector83>:
80106e4d:	6a 00                	push   $0x0
80106e4f:	6a 53                	push   $0x53
80106e51:	e9 cc f6 ff ff       	jmp    80106522 <alltraps>

80106e56 <vector84>:
80106e56:	6a 00                	push   $0x0
80106e58:	6a 54                	push   $0x54
80106e5a:	e9 c3 f6 ff ff       	jmp    80106522 <alltraps>

80106e5f <vector85>:
80106e5f:	6a 00                	push   $0x0
80106e61:	6a 55                	push   $0x55
80106e63:	e9 ba f6 ff ff       	jmp    80106522 <alltraps>

80106e68 <vector86>:
80106e68:	6a 00                	push   $0x0
80106e6a:	6a 56                	push   $0x56
80106e6c:	e9 b1 f6 ff ff       	jmp    80106522 <alltraps>

80106e71 <vector87>:
80106e71:	6a 00                	push   $0x0
80106e73:	6a 57                	push   $0x57
80106e75:	e9 a8 f6 ff ff       	jmp    80106522 <alltraps>

80106e7a <vector88>:
80106e7a:	6a 00                	push   $0x0
80106e7c:	6a 58                	push   $0x58
80106e7e:	e9 9f f6 ff ff       	jmp    80106522 <alltraps>

80106e83 <vector89>:
80106e83:	6a 00                	push   $0x0
80106e85:	6a 59                	push   $0x59
80106e87:	e9 96 f6 ff ff       	jmp    80106522 <alltraps>

80106e8c <vector90>:
80106e8c:	6a 00                	push   $0x0
80106e8e:	6a 5a                	push   $0x5a
80106e90:	e9 8d f6 ff ff       	jmp    80106522 <alltraps>

80106e95 <vector91>:
80106e95:	6a 00                	push   $0x0
80106e97:	6a 5b                	push   $0x5b
80106e99:	e9 84 f6 ff ff       	jmp    80106522 <alltraps>

80106e9e <vector92>:
80106e9e:	6a 00                	push   $0x0
80106ea0:	6a 5c                	push   $0x5c
80106ea2:	e9 7b f6 ff ff       	jmp    80106522 <alltraps>

80106ea7 <vector93>:
80106ea7:	6a 00                	push   $0x0
80106ea9:	6a 5d                	push   $0x5d
80106eab:	e9 72 f6 ff ff       	jmp    80106522 <alltraps>

80106eb0 <vector94>:
80106eb0:	6a 00                	push   $0x0
80106eb2:	6a 5e                	push   $0x5e
80106eb4:	e9 69 f6 ff ff       	jmp    80106522 <alltraps>

80106eb9 <vector95>:
80106eb9:	6a 00                	push   $0x0
80106ebb:	6a 5f                	push   $0x5f
80106ebd:	e9 60 f6 ff ff       	jmp    80106522 <alltraps>

80106ec2 <vector96>:
80106ec2:	6a 00                	push   $0x0
80106ec4:	6a 60                	push   $0x60
80106ec6:	e9 57 f6 ff ff       	jmp    80106522 <alltraps>

80106ecb <vector97>:
80106ecb:	6a 00                	push   $0x0
80106ecd:	6a 61                	push   $0x61
80106ecf:	e9 4e f6 ff ff       	jmp    80106522 <alltraps>

80106ed4 <vector98>:
80106ed4:	6a 00                	push   $0x0
80106ed6:	6a 62                	push   $0x62
80106ed8:	e9 45 f6 ff ff       	jmp    80106522 <alltraps>

80106edd <vector99>:
80106edd:	6a 00                	push   $0x0
80106edf:	6a 63                	push   $0x63
80106ee1:	e9 3c f6 ff ff       	jmp    80106522 <alltraps>

80106ee6 <vector100>:
80106ee6:	6a 00                	push   $0x0
80106ee8:	6a 64                	push   $0x64
80106eea:	e9 33 f6 ff ff       	jmp    80106522 <alltraps>

80106eef <vector101>:
80106eef:	6a 00                	push   $0x0
80106ef1:	6a 65                	push   $0x65
80106ef3:	e9 2a f6 ff ff       	jmp    80106522 <alltraps>

80106ef8 <vector102>:
80106ef8:	6a 00                	push   $0x0
80106efa:	6a 66                	push   $0x66
80106efc:	e9 21 f6 ff ff       	jmp    80106522 <alltraps>

80106f01 <vector103>:
80106f01:	6a 00                	push   $0x0
80106f03:	6a 67                	push   $0x67
80106f05:	e9 18 f6 ff ff       	jmp    80106522 <alltraps>

80106f0a <vector104>:
80106f0a:	6a 00                	push   $0x0
80106f0c:	6a 68                	push   $0x68
80106f0e:	e9 0f f6 ff ff       	jmp    80106522 <alltraps>

80106f13 <vector105>:
80106f13:	6a 00                	push   $0x0
80106f15:	6a 69                	push   $0x69
80106f17:	e9 06 f6 ff ff       	jmp    80106522 <alltraps>

80106f1c <vector106>:
80106f1c:	6a 00                	push   $0x0
80106f1e:	6a 6a                	push   $0x6a
80106f20:	e9 fd f5 ff ff       	jmp    80106522 <alltraps>

80106f25 <vector107>:
80106f25:	6a 00                	push   $0x0
80106f27:	6a 6b                	push   $0x6b
80106f29:	e9 f4 f5 ff ff       	jmp    80106522 <alltraps>

80106f2e <vector108>:
80106f2e:	6a 00                	push   $0x0
80106f30:	6a 6c                	push   $0x6c
80106f32:	e9 eb f5 ff ff       	jmp    80106522 <alltraps>

80106f37 <vector109>:
80106f37:	6a 00                	push   $0x0
80106f39:	6a 6d                	push   $0x6d
80106f3b:	e9 e2 f5 ff ff       	jmp    80106522 <alltraps>

80106f40 <vector110>:
80106f40:	6a 00                	push   $0x0
80106f42:	6a 6e                	push   $0x6e
80106f44:	e9 d9 f5 ff ff       	jmp    80106522 <alltraps>

80106f49 <vector111>:
80106f49:	6a 00                	push   $0x0
80106f4b:	6a 6f                	push   $0x6f
80106f4d:	e9 d0 f5 ff ff       	jmp    80106522 <alltraps>

80106f52 <vector112>:
80106f52:	6a 00                	push   $0x0
80106f54:	6a 70                	push   $0x70
80106f56:	e9 c7 f5 ff ff       	jmp    80106522 <alltraps>

80106f5b <vector113>:
80106f5b:	6a 00                	push   $0x0
80106f5d:	6a 71                	push   $0x71
80106f5f:	e9 be f5 ff ff       	jmp    80106522 <alltraps>

80106f64 <vector114>:
80106f64:	6a 00                	push   $0x0
80106f66:	6a 72                	push   $0x72
80106f68:	e9 b5 f5 ff ff       	jmp    80106522 <alltraps>

80106f6d <vector115>:
80106f6d:	6a 00                	push   $0x0
80106f6f:	6a 73                	push   $0x73
80106f71:	e9 ac f5 ff ff       	jmp    80106522 <alltraps>

80106f76 <vector116>:
80106f76:	6a 00                	push   $0x0
80106f78:	6a 74                	push   $0x74
80106f7a:	e9 a3 f5 ff ff       	jmp    80106522 <alltraps>

80106f7f <vector117>:
80106f7f:	6a 00                	push   $0x0
80106f81:	6a 75                	push   $0x75
80106f83:	e9 9a f5 ff ff       	jmp    80106522 <alltraps>

80106f88 <vector118>:
80106f88:	6a 00                	push   $0x0
80106f8a:	6a 76                	push   $0x76
80106f8c:	e9 91 f5 ff ff       	jmp    80106522 <alltraps>

80106f91 <vector119>:
80106f91:	6a 00                	push   $0x0
80106f93:	6a 77                	push   $0x77
80106f95:	e9 88 f5 ff ff       	jmp    80106522 <alltraps>

80106f9a <vector120>:
80106f9a:	6a 00                	push   $0x0
80106f9c:	6a 78                	push   $0x78
80106f9e:	e9 7f f5 ff ff       	jmp    80106522 <alltraps>

80106fa3 <vector121>:
80106fa3:	6a 00                	push   $0x0
80106fa5:	6a 79                	push   $0x79
80106fa7:	e9 76 f5 ff ff       	jmp    80106522 <alltraps>

80106fac <vector122>:
80106fac:	6a 00                	push   $0x0
80106fae:	6a 7a                	push   $0x7a
80106fb0:	e9 6d f5 ff ff       	jmp    80106522 <alltraps>

80106fb5 <vector123>:
80106fb5:	6a 00                	push   $0x0
80106fb7:	6a 7b                	push   $0x7b
80106fb9:	e9 64 f5 ff ff       	jmp    80106522 <alltraps>

80106fbe <vector124>:
80106fbe:	6a 00                	push   $0x0
80106fc0:	6a 7c                	push   $0x7c
80106fc2:	e9 5b f5 ff ff       	jmp    80106522 <alltraps>

80106fc7 <vector125>:
80106fc7:	6a 00                	push   $0x0
80106fc9:	6a 7d                	push   $0x7d
80106fcb:	e9 52 f5 ff ff       	jmp    80106522 <alltraps>

80106fd0 <vector126>:
80106fd0:	6a 00                	push   $0x0
80106fd2:	6a 7e                	push   $0x7e
80106fd4:	e9 49 f5 ff ff       	jmp    80106522 <alltraps>

80106fd9 <vector127>:
80106fd9:	6a 00                	push   $0x0
80106fdb:	6a 7f                	push   $0x7f
80106fdd:	e9 40 f5 ff ff       	jmp    80106522 <alltraps>

80106fe2 <vector128>:
80106fe2:	6a 00                	push   $0x0
80106fe4:	68 80 00 00 00       	push   $0x80
80106fe9:	e9 34 f5 ff ff       	jmp    80106522 <alltraps>

80106fee <vector129>:
80106fee:	6a 00                	push   $0x0
80106ff0:	68 81 00 00 00       	push   $0x81
80106ff5:	e9 28 f5 ff ff       	jmp    80106522 <alltraps>

80106ffa <vector130>:
80106ffa:	6a 00                	push   $0x0
80106ffc:	68 82 00 00 00       	push   $0x82
80107001:	e9 1c f5 ff ff       	jmp    80106522 <alltraps>

80107006 <vector131>:
80107006:	6a 00                	push   $0x0
80107008:	68 83 00 00 00       	push   $0x83
8010700d:	e9 10 f5 ff ff       	jmp    80106522 <alltraps>

80107012 <vector132>:
80107012:	6a 00                	push   $0x0
80107014:	68 84 00 00 00       	push   $0x84
80107019:	e9 04 f5 ff ff       	jmp    80106522 <alltraps>

8010701e <vector133>:
8010701e:	6a 00                	push   $0x0
80107020:	68 85 00 00 00       	push   $0x85
80107025:	e9 f8 f4 ff ff       	jmp    80106522 <alltraps>

8010702a <vector134>:
8010702a:	6a 00                	push   $0x0
8010702c:	68 86 00 00 00       	push   $0x86
80107031:	e9 ec f4 ff ff       	jmp    80106522 <alltraps>

80107036 <vector135>:
80107036:	6a 00                	push   $0x0
80107038:	68 87 00 00 00       	push   $0x87
8010703d:	e9 e0 f4 ff ff       	jmp    80106522 <alltraps>

80107042 <vector136>:
80107042:	6a 00                	push   $0x0
80107044:	68 88 00 00 00       	push   $0x88
80107049:	e9 d4 f4 ff ff       	jmp    80106522 <alltraps>

8010704e <vector137>:
8010704e:	6a 00                	push   $0x0
80107050:	68 89 00 00 00       	push   $0x89
80107055:	e9 c8 f4 ff ff       	jmp    80106522 <alltraps>

8010705a <vector138>:
8010705a:	6a 00                	push   $0x0
8010705c:	68 8a 00 00 00       	push   $0x8a
80107061:	e9 bc f4 ff ff       	jmp    80106522 <alltraps>

80107066 <vector139>:
80107066:	6a 00                	push   $0x0
80107068:	68 8b 00 00 00       	push   $0x8b
8010706d:	e9 b0 f4 ff ff       	jmp    80106522 <alltraps>

80107072 <vector140>:
80107072:	6a 00                	push   $0x0
80107074:	68 8c 00 00 00       	push   $0x8c
80107079:	e9 a4 f4 ff ff       	jmp    80106522 <alltraps>

8010707e <vector141>:
8010707e:	6a 00                	push   $0x0
80107080:	68 8d 00 00 00       	push   $0x8d
80107085:	e9 98 f4 ff ff       	jmp    80106522 <alltraps>

8010708a <vector142>:
8010708a:	6a 00                	push   $0x0
8010708c:	68 8e 00 00 00       	push   $0x8e
80107091:	e9 8c f4 ff ff       	jmp    80106522 <alltraps>

80107096 <vector143>:
80107096:	6a 00                	push   $0x0
80107098:	68 8f 00 00 00       	push   $0x8f
8010709d:	e9 80 f4 ff ff       	jmp    80106522 <alltraps>

801070a2 <vector144>:
801070a2:	6a 00                	push   $0x0
801070a4:	68 90 00 00 00       	push   $0x90
801070a9:	e9 74 f4 ff ff       	jmp    80106522 <alltraps>

801070ae <vector145>:
801070ae:	6a 00                	push   $0x0
801070b0:	68 91 00 00 00       	push   $0x91
801070b5:	e9 68 f4 ff ff       	jmp    80106522 <alltraps>

801070ba <vector146>:
801070ba:	6a 00                	push   $0x0
801070bc:	68 92 00 00 00       	push   $0x92
801070c1:	e9 5c f4 ff ff       	jmp    80106522 <alltraps>

801070c6 <vector147>:
801070c6:	6a 00                	push   $0x0
801070c8:	68 93 00 00 00       	push   $0x93
801070cd:	e9 50 f4 ff ff       	jmp    80106522 <alltraps>

801070d2 <vector148>:
801070d2:	6a 00                	push   $0x0
801070d4:	68 94 00 00 00       	push   $0x94
801070d9:	e9 44 f4 ff ff       	jmp    80106522 <alltraps>

801070de <vector149>:
801070de:	6a 00                	push   $0x0
801070e0:	68 95 00 00 00       	push   $0x95
801070e5:	e9 38 f4 ff ff       	jmp    80106522 <alltraps>

801070ea <vector150>:
801070ea:	6a 00                	push   $0x0
801070ec:	68 96 00 00 00       	push   $0x96
801070f1:	e9 2c f4 ff ff       	jmp    80106522 <alltraps>

801070f6 <vector151>:
801070f6:	6a 00                	push   $0x0
801070f8:	68 97 00 00 00       	push   $0x97
801070fd:	e9 20 f4 ff ff       	jmp    80106522 <alltraps>

80107102 <vector152>:
80107102:	6a 00                	push   $0x0
80107104:	68 98 00 00 00       	push   $0x98
80107109:	e9 14 f4 ff ff       	jmp    80106522 <alltraps>

8010710e <vector153>:
8010710e:	6a 00                	push   $0x0
80107110:	68 99 00 00 00       	push   $0x99
80107115:	e9 08 f4 ff ff       	jmp    80106522 <alltraps>

8010711a <vector154>:
8010711a:	6a 00                	push   $0x0
8010711c:	68 9a 00 00 00       	push   $0x9a
80107121:	e9 fc f3 ff ff       	jmp    80106522 <alltraps>

80107126 <vector155>:
80107126:	6a 00                	push   $0x0
80107128:	68 9b 00 00 00       	push   $0x9b
8010712d:	e9 f0 f3 ff ff       	jmp    80106522 <alltraps>

80107132 <vector156>:
80107132:	6a 00                	push   $0x0
80107134:	68 9c 00 00 00       	push   $0x9c
80107139:	e9 e4 f3 ff ff       	jmp    80106522 <alltraps>

8010713e <vector157>:
8010713e:	6a 00                	push   $0x0
80107140:	68 9d 00 00 00       	push   $0x9d
80107145:	e9 d8 f3 ff ff       	jmp    80106522 <alltraps>

8010714a <vector158>:
8010714a:	6a 00                	push   $0x0
8010714c:	68 9e 00 00 00       	push   $0x9e
80107151:	e9 cc f3 ff ff       	jmp    80106522 <alltraps>

80107156 <vector159>:
80107156:	6a 00                	push   $0x0
80107158:	68 9f 00 00 00       	push   $0x9f
8010715d:	e9 c0 f3 ff ff       	jmp    80106522 <alltraps>

80107162 <vector160>:
80107162:	6a 00                	push   $0x0
80107164:	68 a0 00 00 00       	push   $0xa0
80107169:	e9 b4 f3 ff ff       	jmp    80106522 <alltraps>

8010716e <vector161>:
8010716e:	6a 00                	push   $0x0
80107170:	68 a1 00 00 00       	push   $0xa1
80107175:	e9 a8 f3 ff ff       	jmp    80106522 <alltraps>

8010717a <vector162>:
8010717a:	6a 00                	push   $0x0
8010717c:	68 a2 00 00 00       	push   $0xa2
80107181:	e9 9c f3 ff ff       	jmp    80106522 <alltraps>

80107186 <vector163>:
80107186:	6a 00                	push   $0x0
80107188:	68 a3 00 00 00       	push   $0xa3
8010718d:	e9 90 f3 ff ff       	jmp    80106522 <alltraps>

80107192 <vector164>:
80107192:	6a 00                	push   $0x0
80107194:	68 a4 00 00 00       	push   $0xa4
80107199:	e9 84 f3 ff ff       	jmp    80106522 <alltraps>

8010719e <vector165>:
8010719e:	6a 00                	push   $0x0
801071a0:	68 a5 00 00 00       	push   $0xa5
801071a5:	e9 78 f3 ff ff       	jmp    80106522 <alltraps>

801071aa <vector166>:
801071aa:	6a 00                	push   $0x0
801071ac:	68 a6 00 00 00       	push   $0xa6
801071b1:	e9 6c f3 ff ff       	jmp    80106522 <alltraps>

801071b6 <vector167>:
801071b6:	6a 00                	push   $0x0
801071b8:	68 a7 00 00 00       	push   $0xa7
801071bd:	e9 60 f3 ff ff       	jmp    80106522 <alltraps>

801071c2 <vector168>:
801071c2:	6a 00                	push   $0x0
801071c4:	68 a8 00 00 00       	push   $0xa8
801071c9:	e9 54 f3 ff ff       	jmp    80106522 <alltraps>

801071ce <vector169>:
801071ce:	6a 00                	push   $0x0
801071d0:	68 a9 00 00 00       	push   $0xa9
801071d5:	e9 48 f3 ff ff       	jmp    80106522 <alltraps>

801071da <vector170>:
801071da:	6a 00                	push   $0x0
801071dc:	68 aa 00 00 00       	push   $0xaa
801071e1:	e9 3c f3 ff ff       	jmp    80106522 <alltraps>

801071e6 <vector171>:
801071e6:	6a 00                	push   $0x0
801071e8:	68 ab 00 00 00       	push   $0xab
801071ed:	e9 30 f3 ff ff       	jmp    80106522 <alltraps>

801071f2 <vector172>:
801071f2:	6a 00                	push   $0x0
801071f4:	68 ac 00 00 00       	push   $0xac
801071f9:	e9 24 f3 ff ff       	jmp    80106522 <alltraps>

801071fe <vector173>:
801071fe:	6a 00                	push   $0x0
80107200:	68 ad 00 00 00       	push   $0xad
80107205:	e9 18 f3 ff ff       	jmp    80106522 <alltraps>

8010720a <vector174>:
8010720a:	6a 00                	push   $0x0
8010720c:	68 ae 00 00 00       	push   $0xae
80107211:	e9 0c f3 ff ff       	jmp    80106522 <alltraps>

80107216 <vector175>:
80107216:	6a 00                	push   $0x0
80107218:	68 af 00 00 00       	push   $0xaf
8010721d:	e9 00 f3 ff ff       	jmp    80106522 <alltraps>

80107222 <vector176>:
80107222:	6a 00                	push   $0x0
80107224:	68 b0 00 00 00       	push   $0xb0
80107229:	e9 f4 f2 ff ff       	jmp    80106522 <alltraps>

8010722e <vector177>:
8010722e:	6a 00                	push   $0x0
80107230:	68 b1 00 00 00       	push   $0xb1
80107235:	e9 e8 f2 ff ff       	jmp    80106522 <alltraps>

8010723a <vector178>:
8010723a:	6a 00                	push   $0x0
8010723c:	68 b2 00 00 00       	push   $0xb2
80107241:	e9 dc f2 ff ff       	jmp    80106522 <alltraps>

80107246 <vector179>:
80107246:	6a 00                	push   $0x0
80107248:	68 b3 00 00 00       	push   $0xb3
8010724d:	e9 d0 f2 ff ff       	jmp    80106522 <alltraps>

80107252 <vector180>:
80107252:	6a 00                	push   $0x0
80107254:	68 b4 00 00 00       	push   $0xb4
80107259:	e9 c4 f2 ff ff       	jmp    80106522 <alltraps>

8010725e <vector181>:
8010725e:	6a 00                	push   $0x0
80107260:	68 b5 00 00 00       	push   $0xb5
80107265:	e9 b8 f2 ff ff       	jmp    80106522 <alltraps>

8010726a <vector182>:
8010726a:	6a 00                	push   $0x0
8010726c:	68 b6 00 00 00       	push   $0xb6
80107271:	e9 ac f2 ff ff       	jmp    80106522 <alltraps>

80107276 <vector183>:
80107276:	6a 00                	push   $0x0
80107278:	68 b7 00 00 00       	push   $0xb7
8010727d:	e9 a0 f2 ff ff       	jmp    80106522 <alltraps>

80107282 <vector184>:
80107282:	6a 00                	push   $0x0
80107284:	68 b8 00 00 00       	push   $0xb8
80107289:	e9 94 f2 ff ff       	jmp    80106522 <alltraps>

8010728e <vector185>:
8010728e:	6a 00                	push   $0x0
80107290:	68 b9 00 00 00       	push   $0xb9
80107295:	e9 88 f2 ff ff       	jmp    80106522 <alltraps>

8010729a <vector186>:
8010729a:	6a 00                	push   $0x0
8010729c:	68 ba 00 00 00       	push   $0xba
801072a1:	e9 7c f2 ff ff       	jmp    80106522 <alltraps>

801072a6 <vector187>:
801072a6:	6a 00                	push   $0x0
801072a8:	68 bb 00 00 00       	push   $0xbb
801072ad:	e9 70 f2 ff ff       	jmp    80106522 <alltraps>

801072b2 <vector188>:
801072b2:	6a 00                	push   $0x0
801072b4:	68 bc 00 00 00       	push   $0xbc
801072b9:	e9 64 f2 ff ff       	jmp    80106522 <alltraps>

801072be <vector189>:
801072be:	6a 00                	push   $0x0
801072c0:	68 bd 00 00 00       	push   $0xbd
801072c5:	e9 58 f2 ff ff       	jmp    80106522 <alltraps>

801072ca <vector190>:
801072ca:	6a 00                	push   $0x0
801072cc:	68 be 00 00 00       	push   $0xbe
801072d1:	e9 4c f2 ff ff       	jmp    80106522 <alltraps>

801072d6 <vector191>:
801072d6:	6a 00                	push   $0x0
801072d8:	68 bf 00 00 00       	push   $0xbf
801072dd:	e9 40 f2 ff ff       	jmp    80106522 <alltraps>

801072e2 <vector192>:
801072e2:	6a 00                	push   $0x0
801072e4:	68 c0 00 00 00       	push   $0xc0
801072e9:	e9 34 f2 ff ff       	jmp    80106522 <alltraps>

801072ee <vector193>:
801072ee:	6a 00                	push   $0x0
801072f0:	68 c1 00 00 00       	push   $0xc1
801072f5:	e9 28 f2 ff ff       	jmp    80106522 <alltraps>

801072fa <vector194>:
801072fa:	6a 00                	push   $0x0
801072fc:	68 c2 00 00 00       	push   $0xc2
80107301:	e9 1c f2 ff ff       	jmp    80106522 <alltraps>

80107306 <vector195>:
80107306:	6a 00                	push   $0x0
80107308:	68 c3 00 00 00       	push   $0xc3
8010730d:	e9 10 f2 ff ff       	jmp    80106522 <alltraps>

80107312 <vector196>:
80107312:	6a 00                	push   $0x0
80107314:	68 c4 00 00 00       	push   $0xc4
80107319:	e9 04 f2 ff ff       	jmp    80106522 <alltraps>

8010731e <vector197>:
8010731e:	6a 00                	push   $0x0
80107320:	68 c5 00 00 00       	push   $0xc5
80107325:	e9 f8 f1 ff ff       	jmp    80106522 <alltraps>

8010732a <vector198>:
8010732a:	6a 00                	push   $0x0
8010732c:	68 c6 00 00 00       	push   $0xc6
80107331:	e9 ec f1 ff ff       	jmp    80106522 <alltraps>

80107336 <vector199>:
80107336:	6a 00                	push   $0x0
80107338:	68 c7 00 00 00       	push   $0xc7
8010733d:	e9 e0 f1 ff ff       	jmp    80106522 <alltraps>

80107342 <vector200>:
80107342:	6a 00                	push   $0x0
80107344:	68 c8 00 00 00       	push   $0xc8
80107349:	e9 d4 f1 ff ff       	jmp    80106522 <alltraps>

8010734e <vector201>:
8010734e:	6a 00                	push   $0x0
80107350:	68 c9 00 00 00       	push   $0xc9
80107355:	e9 c8 f1 ff ff       	jmp    80106522 <alltraps>

8010735a <vector202>:
8010735a:	6a 00                	push   $0x0
8010735c:	68 ca 00 00 00       	push   $0xca
80107361:	e9 bc f1 ff ff       	jmp    80106522 <alltraps>

80107366 <vector203>:
80107366:	6a 00                	push   $0x0
80107368:	68 cb 00 00 00       	push   $0xcb
8010736d:	e9 b0 f1 ff ff       	jmp    80106522 <alltraps>

80107372 <vector204>:
80107372:	6a 00                	push   $0x0
80107374:	68 cc 00 00 00       	push   $0xcc
80107379:	e9 a4 f1 ff ff       	jmp    80106522 <alltraps>

8010737e <vector205>:
8010737e:	6a 00                	push   $0x0
80107380:	68 cd 00 00 00       	push   $0xcd
80107385:	e9 98 f1 ff ff       	jmp    80106522 <alltraps>

8010738a <vector206>:
8010738a:	6a 00                	push   $0x0
8010738c:	68 ce 00 00 00       	push   $0xce
80107391:	e9 8c f1 ff ff       	jmp    80106522 <alltraps>

80107396 <vector207>:
80107396:	6a 00                	push   $0x0
80107398:	68 cf 00 00 00       	push   $0xcf
8010739d:	e9 80 f1 ff ff       	jmp    80106522 <alltraps>

801073a2 <vector208>:
801073a2:	6a 00                	push   $0x0
801073a4:	68 d0 00 00 00       	push   $0xd0
801073a9:	e9 74 f1 ff ff       	jmp    80106522 <alltraps>

801073ae <vector209>:
801073ae:	6a 00                	push   $0x0
801073b0:	68 d1 00 00 00       	push   $0xd1
801073b5:	e9 68 f1 ff ff       	jmp    80106522 <alltraps>

801073ba <vector210>:
801073ba:	6a 00                	push   $0x0
801073bc:	68 d2 00 00 00       	push   $0xd2
801073c1:	e9 5c f1 ff ff       	jmp    80106522 <alltraps>

801073c6 <vector211>:
801073c6:	6a 00                	push   $0x0
801073c8:	68 d3 00 00 00       	push   $0xd3
801073cd:	e9 50 f1 ff ff       	jmp    80106522 <alltraps>

801073d2 <vector212>:
801073d2:	6a 00                	push   $0x0
801073d4:	68 d4 00 00 00       	push   $0xd4
801073d9:	e9 44 f1 ff ff       	jmp    80106522 <alltraps>

801073de <vector213>:
801073de:	6a 00                	push   $0x0
801073e0:	68 d5 00 00 00       	push   $0xd5
801073e5:	e9 38 f1 ff ff       	jmp    80106522 <alltraps>

801073ea <vector214>:
801073ea:	6a 00                	push   $0x0
801073ec:	68 d6 00 00 00       	push   $0xd6
801073f1:	e9 2c f1 ff ff       	jmp    80106522 <alltraps>

801073f6 <vector215>:
801073f6:	6a 00                	push   $0x0
801073f8:	68 d7 00 00 00       	push   $0xd7
801073fd:	e9 20 f1 ff ff       	jmp    80106522 <alltraps>

80107402 <vector216>:
80107402:	6a 00                	push   $0x0
80107404:	68 d8 00 00 00       	push   $0xd8
80107409:	e9 14 f1 ff ff       	jmp    80106522 <alltraps>

8010740e <vector217>:
8010740e:	6a 00                	push   $0x0
80107410:	68 d9 00 00 00       	push   $0xd9
80107415:	e9 08 f1 ff ff       	jmp    80106522 <alltraps>

8010741a <vector218>:
8010741a:	6a 00                	push   $0x0
8010741c:	68 da 00 00 00       	push   $0xda
80107421:	e9 fc f0 ff ff       	jmp    80106522 <alltraps>

80107426 <vector219>:
80107426:	6a 00                	push   $0x0
80107428:	68 db 00 00 00       	push   $0xdb
8010742d:	e9 f0 f0 ff ff       	jmp    80106522 <alltraps>

80107432 <vector220>:
80107432:	6a 00                	push   $0x0
80107434:	68 dc 00 00 00       	push   $0xdc
80107439:	e9 e4 f0 ff ff       	jmp    80106522 <alltraps>

8010743e <vector221>:
8010743e:	6a 00                	push   $0x0
80107440:	68 dd 00 00 00       	push   $0xdd
80107445:	e9 d8 f0 ff ff       	jmp    80106522 <alltraps>

8010744a <vector222>:
8010744a:	6a 00                	push   $0x0
8010744c:	68 de 00 00 00       	push   $0xde
80107451:	e9 cc f0 ff ff       	jmp    80106522 <alltraps>

80107456 <vector223>:
80107456:	6a 00                	push   $0x0
80107458:	68 df 00 00 00       	push   $0xdf
8010745d:	e9 c0 f0 ff ff       	jmp    80106522 <alltraps>

80107462 <vector224>:
80107462:	6a 00                	push   $0x0
80107464:	68 e0 00 00 00       	push   $0xe0
80107469:	e9 b4 f0 ff ff       	jmp    80106522 <alltraps>

8010746e <vector225>:
8010746e:	6a 00                	push   $0x0
80107470:	68 e1 00 00 00       	push   $0xe1
80107475:	e9 a8 f0 ff ff       	jmp    80106522 <alltraps>

8010747a <vector226>:
8010747a:	6a 00                	push   $0x0
8010747c:	68 e2 00 00 00       	push   $0xe2
80107481:	e9 9c f0 ff ff       	jmp    80106522 <alltraps>

80107486 <vector227>:
80107486:	6a 00                	push   $0x0
80107488:	68 e3 00 00 00       	push   $0xe3
8010748d:	e9 90 f0 ff ff       	jmp    80106522 <alltraps>

80107492 <vector228>:
80107492:	6a 00                	push   $0x0
80107494:	68 e4 00 00 00       	push   $0xe4
80107499:	e9 84 f0 ff ff       	jmp    80106522 <alltraps>

8010749e <vector229>:
8010749e:	6a 00                	push   $0x0
801074a0:	68 e5 00 00 00       	push   $0xe5
801074a5:	e9 78 f0 ff ff       	jmp    80106522 <alltraps>

801074aa <vector230>:
801074aa:	6a 00                	push   $0x0
801074ac:	68 e6 00 00 00       	push   $0xe6
801074b1:	e9 6c f0 ff ff       	jmp    80106522 <alltraps>

801074b6 <vector231>:
801074b6:	6a 00                	push   $0x0
801074b8:	68 e7 00 00 00       	push   $0xe7
801074bd:	e9 60 f0 ff ff       	jmp    80106522 <alltraps>

801074c2 <vector232>:
801074c2:	6a 00                	push   $0x0
801074c4:	68 e8 00 00 00       	push   $0xe8
801074c9:	e9 54 f0 ff ff       	jmp    80106522 <alltraps>

801074ce <vector233>:
801074ce:	6a 00                	push   $0x0
801074d0:	68 e9 00 00 00       	push   $0xe9
801074d5:	e9 48 f0 ff ff       	jmp    80106522 <alltraps>

801074da <vector234>:
801074da:	6a 00                	push   $0x0
801074dc:	68 ea 00 00 00       	push   $0xea
801074e1:	e9 3c f0 ff ff       	jmp    80106522 <alltraps>

801074e6 <vector235>:
801074e6:	6a 00                	push   $0x0
801074e8:	68 eb 00 00 00       	push   $0xeb
801074ed:	e9 30 f0 ff ff       	jmp    80106522 <alltraps>

801074f2 <vector236>:
801074f2:	6a 00                	push   $0x0
801074f4:	68 ec 00 00 00       	push   $0xec
801074f9:	e9 24 f0 ff ff       	jmp    80106522 <alltraps>

801074fe <vector237>:
801074fe:	6a 00                	push   $0x0
80107500:	68 ed 00 00 00       	push   $0xed
80107505:	e9 18 f0 ff ff       	jmp    80106522 <alltraps>

8010750a <vector238>:
8010750a:	6a 00                	push   $0x0
8010750c:	68 ee 00 00 00       	push   $0xee
80107511:	e9 0c f0 ff ff       	jmp    80106522 <alltraps>

80107516 <vector239>:
80107516:	6a 00                	push   $0x0
80107518:	68 ef 00 00 00       	push   $0xef
8010751d:	e9 00 f0 ff ff       	jmp    80106522 <alltraps>

80107522 <vector240>:
80107522:	6a 00                	push   $0x0
80107524:	68 f0 00 00 00       	push   $0xf0
80107529:	e9 f4 ef ff ff       	jmp    80106522 <alltraps>

8010752e <vector241>:
8010752e:	6a 00                	push   $0x0
80107530:	68 f1 00 00 00       	push   $0xf1
80107535:	e9 e8 ef ff ff       	jmp    80106522 <alltraps>

8010753a <vector242>:
8010753a:	6a 00                	push   $0x0
8010753c:	68 f2 00 00 00       	push   $0xf2
80107541:	e9 dc ef ff ff       	jmp    80106522 <alltraps>

80107546 <vector243>:
80107546:	6a 00                	push   $0x0
80107548:	68 f3 00 00 00       	push   $0xf3
8010754d:	e9 d0 ef ff ff       	jmp    80106522 <alltraps>

80107552 <vector244>:
80107552:	6a 00                	push   $0x0
80107554:	68 f4 00 00 00       	push   $0xf4
80107559:	e9 c4 ef ff ff       	jmp    80106522 <alltraps>

8010755e <vector245>:
8010755e:	6a 00                	push   $0x0
80107560:	68 f5 00 00 00       	push   $0xf5
80107565:	e9 b8 ef ff ff       	jmp    80106522 <alltraps>

8010756a <vector246>:
8010756a:	6a 00                	push   $0x0
8010756c:	68 f6 00 00 00       	push   $0xf6
80107571:	e9 ac ef ff ff       	jmp    80106522 <alltraps>

80107576 <vector247>:
80107576:	6a 00                	push   $0x0
80107578:	68 f7 00 00 00       	push   $0xf7
8010757d:	e9 a0 ef ff ff       	jmp    80106522 <alltraps>

80107582 <vector248>:
80107582:	6a 00                	push   $0x0
80107584:	68 f8 00 00 00       	push   $0xf8
80107589:	e9 94 ef ff ff       	jmp    80106522 <alltraps>

8010758e <vector249>:
8010758e:	6a 00                	push   $0x0
80107590:	68 f9 00 00 00       	push   $0xf9
80107595:	e9 88 ef ff ff       	jmp    80106522 <alltraps>

8010759a <vector250>:
8010759a:	6a 00                	push   $0x0
8010759c:	68 fa 00 00 00       	push   $0xfa
801075a1:	e9 7c ef ff ff       	jmp    80106522 <alltraps>

801075a6 <vector251>:
801075a6:	6a 00                	push   $0x0
801075a8:	68 fb 00 00 00       	push   $0xfb
801075ad:	e9 70 ef ff ff       	jmp    80106522 <alltraps>

801075b2 <vector252>:
801075b2:	6a 00                	push   $0x0
801075b4:	68 fc 00 00 00       	push   $0xfc
801075b9:	e9 64 ef ff ff       	jmp    80106522 <alltraps>

801075be <vector253>:
801075be:	6a 00                	push   $0x0
801075c0:	68 fd 00 00 00       	push   $0xfd
801075c5:	e9 58 ef ff ff       	jmp    80106522 <alltraps>

801075ca <vector254>:
801075ca:	6a 00                	push   $0x0
801075cc:	68 fe 00 00 00       	push   $0xfe
801075d1:	e9 4c ef ff ff       	jmp    80106522 <alltraps>

801075d6 <vector255>:
801075d6:	6a 00                	push   $0x0
801075d8:	68 ff 00 00 00       	push   $0xff
801075dd:	e9 40 ef ff ff       	jmp    80106522 <alltraps>

801075e2 <lgdt>:
{
801075e2:	55                   	push   %ebp
801075e3:	89 e5                	mov    %esp,%ebp
801075e5:	83 ec 10             	sub    $0x10,%esp
  pd[0] = size-1;
801075e8:	8b 45 0c             	mov    0xc(%ebp),%eax
801075eb:	83 e8 01             	sub    $0x1,%eax
801075ee:	66 89 45 fa          	mov    %ax,-0x6(%ebp)
  pd[1] = (uint)p;
801075f2:	8b 45 08             	mov    0x8(%ebp),%eax
801075f5:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  pd[2] = (uint)p >> 16;
801075f9:	8b 45 08             	mov    0x8(%ebp),%eax
801075fc:	c1 e8 10             	shr    $0x10,%eax
801075ff:	66 89 45 fe          	mov    %ax,-0x2(%ebp)
  asm volatile("lgdt (%0)" : : "r" (pd));
80107603:	8d 45 fa             	lea    -0x6(%ebp),%eax
80107606:	0f 01 10             	lgdtl  (%eax)
}
80107609:	90                   	nop
8010760a:	c9                   	leave  
8010760b:	c3                   	ret    

8010760c <ltr>:
{
8010760c:	55                   	push   %ebp
8010760d:	89 e5                	mov    %esp,%ebp
8010760f:	83 ec 04             	sub    $0x4,%esp
80107612:	8b 45 08             	mov    0x8(%ebp),%eax
80107615:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  asm volatile("ltr %0" : : "r" (sel));
80107619:	0f b7 45 fc          	movzwl -0x4(%ebp),%eax
8010761d:	0f 00 d8             	ltr    %ax
}
80107620:	90                   	nop
80107621:	c9                   	leave  
80107622:	c3                   	ret    

80107623 <lcr3>:

static inline void
lcr3(uint val)
{
80107623:	55                   	push   %ebp
80107624:	89 e5                	mov    %esp,%ebp
  asm volatile("movl %0,%%cr3" : : "r" (val));
80107626:	8b 45 08             	mov    0x8(%ebp),%eax
80107629:	0f 22 d8             	mov    %eax,%cr3
}
8010762c:	90                   	nop
8010762d:	5d                   	pop    %ebp
8010762e:	c3                   	ret    

8010762f <seginit>:
extern struct gpu gpu;
// Set up CPU's kernel segment descriptors.
// Run once on entry on each CPU.
void
seginit(void)
{
8010762f:	55                   	push   %ebp
80107630:	89 e5                	mov    %esp,%ebp
80107632:	83 ec 18             	sub    $0x18,%esp

  // Map "logical" addresses to virtual addresses using identity map.
  // Cannot share a CODE descriptor for both kernel and user
  // because it would have to have DPL_USR, but the CPU forbids
  // an interrupt from CPL=0 to DPL=3.
  c = &cpus[cpuid()];
80107635:	e8 47 c8 ff ff       	call   80103e81 <cpuid>
8010763a:	69 c0 b0 00 00 00    	imul   $0xb0,%eax,%eax
80107640:	05 c0 9b 11 80       	add    $0x80119bc0,%eax
80107645:	89 45 f4             	mov    %eax,-0xc(%ebp)

  c->gdt[SEG_KCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, 0);
80107648:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010764b:	66 c7 40 78 ff ff    	movw   $0xffff,0x78(%eax)
80107651:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107654:	66 c7 40 7a 00 00    	movw   $0x0,0x7a(%eax)
8010765a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010765d:	c6 40 7c 00          	movb   $0x0,0x7c(%eax)
80107661:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107664:	0f b6 50 7d          	movzbl 0x7d(%eax),%edx
80107668:	83 e2 f0             	and    $0xfffffff0,%edx
8010766b:	83 ca 0a             	or     $0xa,%edx
8010766e:	88 50 7d             	mov    %dl,0x7d(%eax)
80107671:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107674:	0f b6 50 7d          	movzbl 0x7d(%eax),%edx
80107678:	83 ca 10             	or     $0x10,%edx
8010767b:	88 50 7d             	mov    %dl,0x7d(%eax)
8010767e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107681:	0f b6 50 7d          	movzbl 0x7d(%eax),%edx
80107685:	83 e2 9f             	and    $0xffffff9f,%edx
80107688:	88 50 7d             	mov    %dl,0x7d(%eax)
8010768b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010768e:	0f b6 50 7d          	movzbl 0x7d(%eax),%edx
80107692:	83 ca 80             	or     $0xffffff80,%edx
80107695:	88 50 7d             	mov    %dl,0x7d(%eax)
80107698:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010769b:	0f b6 50 7e          	movzbl 0x7e(%eax),%edx
8010769f:	83 ca 0f             	or     $0xf,%edx
801076a2:	88 50 7e             	mov    %dl,0x7e(%eax)
801076a5:	8b 45 f4             	mov    -0xc(%ebp),%eax
801076a8:	0f b6 50 7e          	movzbl 0x7e(%eax),%edx
801076ac:	83 e2 ef             	and    $0xffffffef,%edx
801076af:	88 50 7e             	mov    %dl,0x7e(%eax)
801076b2:	8b 45 f4             	mov    -0xc(%ebp),%eax
801076b5:	0f b6 50 7e          	movzbl 0x7e(%eax),%edx
801076b9:	83 e2 df             	and    $0xffffffdf,%edx
801076bc:	88 50 7e             	mov    %dl,0x7e(%eax)
801076bf:	8b 45 f4             	mov    -0xc(%ebp),%eax
801076c2:	0f b6 50 7e          	movzbl 0x7e(%eax),%edx
801076c6:	83 ca 40             	or     $0x40,%edx
801076c9:	88 50 7e             	mov    %dl,0x7e(%eax)
801076cc:	8b 45 f4             	mov    -0xc(%ebp),%eax
801076cf:	0f b6 50 7e          	movzbl 0x7e(%eax),%edx
801076d3:	83 ca 80             	or     $0xffffff80,%edx
801076d6:	88 50 7e             	mov    %dl,0x7e(%eax)
801076d9:	8b 45 f4             	mov    -0xc(%ebp),%eax
801076dc:	c6 40 7f 00          	movb   $0x0,0x7f(%eax)
  c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
801076e0:	8b 45 f4             	mov    -0xc(%ebp),%eax
801076e3:	66 c7 80 80 00 00 00 	movw   $0xffff,0x80(%eax)
801076ea:	ff ff 
801076ec:	8b 45 f4             	mov    -0xc(%ebp),%eax
801076ef:	66 c7 80 82 00 00 00 	movw   $0x0,0x82(%eax)
801076f6:	00 00 
801076f8:	8b 45 f4             	mov    -0xc(%ebp),%eax
801076fb:	c6 80 84 00 00 00 00 	movb   $0x0,0x84(%eax)
80107702:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107705:	0f b6 90 85 00 00 00 	movzbl 0x85(%eax),%edx
8010770c:	83 e2 f0             	and    $0xfffffff0,%edx
8010770f:	83 ca 02             	or     $0x2,%edx
80107712:	88 90 85 00 00 00    	mov    %dl,0x85(%eax)
80107718:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010771b:	0f b6 90 85 00 00 00 	movzbl 0x85(%eax),%edx
80107722:	83 ca 10             	or     $0x10,%edx
80107725:	88 90 85 00 00 00    	mov    %dl,0x85(%eax)
8010772b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010772e:	0f b6 90 85 00 00 00 	movzbl 0x85(%eax),%edx
80107735:	83 e2 9f             	and    $0xffffff9f,%edx
80107738:	88 90 85 00 00 00    	mov    %dl,0x85(%eax)
8010773e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107741:	0f b6 90 85 00 00 00 	movzbl 0x85(%eax),%edx
80107748:	83 ca 80             	or     $0xffffff80,%edx
8010774b:	88 90 85 00 00 00    	mov    %dl,0x85(%eax)
80107751:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107754:	0f b6 90 86 00 00 00 	movzbl 0x86(%eax),%edx
8010775b:	83 ca 0f             	or     $0xf,%edx
8010775e:	88 90 86 00 00 00    	mov    %dl,0x86(%eax)
80107764:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107767:	0f b6 90 86 00 00 00 	movzbl 0x86(%eax),%edx
8010776e:	83 e2 ef             	and    $0xffffffef,%edx
80107771:	88 90 86 00 00 00    	mov    %dl,0x86(%eax)
80107777:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010777a:	0f b6 90 86 00 00 00 	movzbl 0x86(%eax),%edx
80107781:	83 e2 df             	and    $0xffffffdf,%edx
80107784:	88 90 86 00 00 00    	mov    %dl,0x86(%eax)
8010778a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010778d:	0f b6 90 86 00 00 00 	movzbl 0x86(%eax),%edx
80107794:	83 ca 40             	or     $0x40,%edx
80107797:	88 90 86 00 00 00    	mov    %dl,0x86(%eax)
8010779d:	8b 45 f4             	mov    -0xc(%ebp),%eax
801077a0:	0f b6 90 86 00 00 00 	movzbl 0x86(%eax),%edx
801077a7:	83 ca 80             	or     $0xffffff80,%edx
801077aa:	88 90 86 00 00 00    	mov    %dl,0x86(%eax)
801077b0:	8b 45 f4             	mov    -0xc(%ebp),%eax
801077b3:	c6 80 87 00 00 00 00 	movb   $0x0,0x87(%eax)
  c->gdt[SEG_UCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, DPL_USER);
801077ba:	8b 45 f4             	mov    -0xc(%ebp),%eax
801077bd:	66 c7 80 88 00 00 00 	movw   $0xffff,0x88(%eax)
801077c4:	ff ff 
801077c6:	8b 45 f4             	mov    -0xc(%ebp),%eax
801077c9:	66 c7 80 8a 00 00 00 	movw   $0x0,0x8a(%eax)
801077d0:	00 00 
801077d2:	8b 45 f4             	mov    -0xc(%ebp),%eax
801077d5:	c6 80 8c 00 00 00 00 	movb   $0x0,0x8c(%eax)
801077dc:	8b 45 f4             	mov    -0xc(%ebp),%eax
801077df:	0f b6 90 8d 00 00 00 	movzbl 0x8d(%eax),%edx
801077e6:	83 e2 f0             	and    $0xfffffff0,%edx
801077e9:	83 ca 0a             	or     $0xa,%edx
801077ec:	88 90 8d 00 00 00    	mov    %dl,0x8d(%eax)
801077f2:	8b 45 f4             	mov    -0xc(%ebp),%eax
801077f5:	0f b6 90 8d 00 00 00 	movzbl 0x8d(%eax),%edx
801077fc:	83 ca 10             	or     $0x10,%edx
801077ff:	88 90 8d 00 00 00    	mov    %dl,0x8d(%eax)
80107805:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107808:	0f b6 90 8d 00 00 00 	movzbl 0x8d(%eax),%edx
8010780f:	83 ca 60             	or     $0x60,%edx
80107812:	88 90 8d 00 00 00    	mov    %dl,0x8d(%eax)
80107818:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010781b:	0f b6 90 8d 00 00 00 	movzbl 0x8d(%eax),%edx
80107822:	83 ca 80             	or     $0xffffff80,%edx
80107825:	88 90 8d 00 00 00    	mov    %dl,0x8d(%eax)
8010782b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010782e:	0f b6 90 8e 00 00 00 	movzbl 0x8e(%eax),%edx
80107835:	83 ca 0f             	or     $0xf,%edx
80107838:	88 90 8e 00 00 00    	mov    %dl,0x8e(%eax)
8010783e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107841:	0f b6 90 8e 00 00 00 	movzbl 0x8e(%eax),%edx
80107848:	83 e2 ef             	and    $0xffffffef,%edx
8010784b:	88 90 8e 00 00 00    	mov    %dl,0x8e(%eax)
80107851:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107854:	0f b6 90 8e 00 00 00 	movzbl 0x8e(%eax),%edx
8010785b:	83 e2 df             	and    $0xffffffdf,%edx
8010785e:	88 90 8e 00 00 00    	mov    %dl,0x8e(%eax)
80107864:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107867:	0f b6 90 8e 00 00 00 	movzbl 0x8e(%eax),%edx
8010786e:	83 ca 40             	or     $0x40,%edx
80107871:	88 90 8e 00 00 00    	mov    %dl,0x8e(%eax)
80107877:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010787a:	0f b6 90 8e 00 00 00 	movzbl 0x8e(%eax),%edx
80107881:	83 ca 80             	or     $0xffffff80,%edx
80107884:	88 90 8e 00 00 00    	mov    %dl,0x8e(%eax)
8010788a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010788d:	c6 80 8f 00 00 00 00 	movb   $0x0,0x8f(%eax)
  c->gdt[SEG_UDATA] = SEG(STA_W, 0, 0xffffffff, DPL_USER);
80107894:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107897:	66 c7 80 90 00 00 00 	movw   $0xffff,0x90(%eax)
8010789e:	ff ff 
801078a0:	8b 45 f4             	mov    -0xc(%ebp),%eax
801078a3:	66 c7 80 92 00 00 00 	movw   $0x0,0x92(%eax)
801078aa:	00 00 
801078ac:	8b 45 f4             	mov    -0xc(%ebp),%eax
801078af:	c6 80 94 00 00 00 00 	movb   $0x0,0x94(%eax)
801078b6:	8b 45 f4             	mov    -0xc(%ebp),%eax
801078b9:	0f b6 90 95 00 00 00 	movzbl 0x95(%eax),%edx
801078c0:	83 e2 f0             	and    $0xfffffff0,%edx
801078c3:	83 ca 02             	or     $0x2,%edx
801078c6:	88 90 95 00 00 00    	mov    %dl,0x95(%eax)
801078cc:	8b 45 f4             	mov    -0xc(%ebp),%eax
801078cf:	0f b6 90 95 00 00 00 	movzbl 0x95(%eax),%edx
801078d6:	83 ca 10             	or     $0x10,%edx
801078d9:	88 90 95 00 00 00    	mov    %dl,0x95(%eax)
801078df:	8b 45 f4             	mov    -0xc(%ebp),%eax
801078e2:	0f b6 90 95 00 00 00 	movzbl 0x95(%eax),%edx
801078e9:	83 ca 60             	or     $0x60,%edx
801078ec:	88 90 95 00 00 00    	mov    %dl,0x95(%eax)
801078f2:	8b 45 f4             	mov    -0xc(%ebp),%eax
801078f5:	0f b6 90 95 00 00 00 	movzbl 0x95(%eax),%edx
801078fc:	83 ca 80             	or     $0xffffff80,%edx
801078ff:	88 90 95 00 00 00    	mov    %dl,0x95(%eax)
80107905:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107908:	0f b6 90 96 00 00 00 	movzbl 0x96(%eax),%edx
8010790f:	83 ca 0f             	or     $0xf,%edx
80107912:	88 90 96 00 00 00    	mov    %dl,0x96(%eax)
80107918:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010791b:	0f b6 90 96 00 00 00 	movzbl 0x96(%eax),%edx
80107922:	83 e2 ef             	and    $0xffffffef,%edx
80107925:	88 90 96 00 00 00    	mov    %dl,0x96(%eax)
8010792b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010792e:	0f b6 90 96 00 00 00 	movzbl 0x96(%eax),%edx
80107935:	83 e2 df             	and    $0xffffffdf,%edx
80107938:	88 90 96 00 00 00    	mov    %dl,0x96(%eax)
8010793e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107941:	0f b6 90 96 00 00 00 	movzbl 0x96(%eax),%edx
80107948:	83 ca 40             	or     $0x40,%edx
8010794b:	88 90 96 00 00 00    	mov    %dl,0x96(%eax)
80107951:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107954:	0f b6 90 96 00 00 00 	movzbl 0x96(%eax),%edx
8010795b:	83 ca 80             	or     $0xffffff80,%edx
8010795e:	88 90 96 00 00 00    	mov    %dl,0x96(%eax)
80107964:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107967:	c6 80 97 00 00 00 00 	movb   $0x0,0x97(%eax)
  lgdt(c->gdt, sizeof(c->gdt));
8010796e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107971:	83 c0 70             	add    $0x70,%eax
80107974:	83 ec 08             	sub    $0x8,%esp
80107977:	6a 30                	push   $0x30
80107979:	50                   	push   %eax
8010797a:	e8 63 fc ff ff       	call   801075e2 <lgdt>
8010797f:	83 c4 10             	add    $0x10,%esp
}
80107982:	90                   	nop
80107983:	c9                   	leave  
80107984:	c3                   	ret    

80107985 <walkpgdir>:
// Return the address of the PTE in page table pgdir
// that corresponds to virtual address va.  If alloc!=0,
// create any required page table pages.
static pte_t *
walkpgdir(pde_t *pgdir, const void *va, int alloc)
{
80107985:	55                   	push   %ebp
80107986:	89 e5                	mov    %esp,%ebp
80107988:	83 ec 18             	sub    $0x18,%esp
  pde_t *pde;
  pte_t *pgtab;

  pde = &pgdir[PDX(va)];
8010798b:	8b 45 0c             	mov    0xc(%ebp),%eax
8010798e:	c1 e8 16             	shr    $0x16,%eax
80107991:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80107998:	8b 45 08             	mov    0x8(%ebp),%eax
8010799b:	01 d0                	add    %edx,%eax
8010799d:	89 45 f0             	mov    %eax,-0x10(%ebp)
  if(*pde & PTE_P){
801079a0:	8b 45 f0             	mov    -0x10(%ebp),%eax
801079a3:	8b 00                	mov    (%eax),%eax
801079a5:	83 e0 01             	and    $0x1,%eax
801079a8:	85 c0                	test   %eax,%eax
801079aa:	74 14                	je     801079c0 <walkpgdir+0x3b>
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
801079ac:	8b 45 f0             	mov    -0x10(%ebp),%eax
801079af:	8b 00                	mov    (%eax),%eax
801079b1:	25 00 f0 ff ff       	and    $0xfffff000,%eax
801079b6:	05 00 00 00 80       	add    $0x80000000,%eax
801079bb:	89 45 f4             	mov    %eax,-0xc(%ebp)
801079be:	eb 42                	jmp    80107a02 <walkpgdir+0x7d>
  } else {
    if(!alloc || (pgtab = (pte_t*)kalloc()) == 0)
801079c0:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
801079c4:	74 0e                	je     801079d4 <walkpgdir+0x4f>
801079c6:	e8 b9 b2 ff ff       	call   80102c84 <kalloc>
801079cb:	89 45 f4             	mov    %eax,-0xc(%ebp)
801079ce:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801079d2:	75 07                	jne    801079db <walkpgdir+0x56>
      return 0;
801079d4:	b8 00 00 00 00       	mov    $0x0,%eax
801079d9:	eb 3e                	jmp    80107a19 <walkpgdir+0x94>
    // Make sure all those PTE_P bits are zero.
    memset(pgtab, 0, PGSIZE);
801079db:	83 ec 04             	sub    $0x4,%esp
801079de:	68 00 10 00 00       	push   $0x1000
801079e3:	6a 00                	push   $0x0
801079e5:	ff 75 f4             	push   -0xc(%ebp)
801079e8:	e8 26 d7 ff ff       	call   80105113 <memset>
801079ed:	83 c4 10             	add    $0x10,%esp
    // The permissions here are overly generous, but they can
    // be further restricted by the permissions in the page table
    // entries, if necessary.
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
801079f0:	8b 45 f4             	mov    -0xc(%ebp),%eax
801079f3:	05 00 00 00 80       	add    $0x80000000,%eax
801079f8:	83 c8 07             	or     $0x7,%eax
801079fb:	89 c2                	mov    %eax,%edx
801079fd:	8b 45 f0             	mov    -0x10(%ebp),%eax
80107a00:	89 10                	mov    %edx,(%eax)
  }
  return &pgtab[PTX(va)];
80107a02:	8b 45 0c             	mov    0xc(%ebp),%eax
80107a05:	c1 e8 0c             	shr    $0xc,%eax
80107a08:	25 ff 03 00 00       	and    $0x3ff,%eax
80107a0d:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80107a14:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107a17:	01 d0                	add    %edx,%eax
}
80107a19:	c9                   	leave  
80107a1a:	c3                   	ret    

80107a1b <mappages>:
// Create PTEs for virtual addresses starting at va that refer to
// physical addresses starting at pa. va and size might not
// be page-aligned.
static int
mappages(pde_t *pgdir, void *va, uint size, uint pa, int perm)
{
80107a1b:	55                   	push   %ebp
80107a1c:	89 e5                	mov    %esp,%ebp
80107a1e:	83 ec 18             	sub    $0x18,%esp
  char *a, *last;
  pte_t *pte;

  a = (char*)PGROUNDDOWN((uint)va);
80107a21:	8b 45 0c             	mov    0xc(%ebp),%eax
80107a24:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80107a29:	89 45 f4             	mov    %eax,-0xc(%ebp)
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
80107a2c:	8b 55 0c             	mov    0xc(%ebp),%edx
80107a2f:	8b 45 10             	mov    0x10(%ebp),%eax
80107a32:	01 d0                	add    %edx,%eax
80107a34:	83 e8 01             	sub    $0x1,%eax
80107a37:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80107a3c:	89 45 f0             	mov    %eax,-0x10(%ebp)
  for(;;){
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
80107a3f:	83 ec 04             	sub    $0x4,%esp
80107a42:	6a 01                	push   $0x1
80107a44:	ff 75 f4             	push   -0xc(%ebp)
80107a47:	ff 75 08             	push   0x8(%ebp)
80107a4a:	e8 36 ff ff ff       	call   80107985 <walkpgdir>
80107a4f:	83 c4 10             	add    $0x10,%esp
80107a52:	89 45 ec             	mov    %eax,-0x14(%ebp)
80107a55:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
80107a59:	75 07                	jne    80107a62 <mappages+0x47>
      return -1;
80107a5b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80107a60:	eb 47                	jmp    80107aa9 <mappages+0x8e>
    if(*pte & PTE_P)
80107a62:	8b 45 ec             	mov    -0x14(%ebp),%eax
80107a65:	8b 00                	mov    (%eax),%eax
80107a67:	83 e0 01             	and    $0x1,%eax
80107a6a:	85 c0                	test   %eax,%eax
80107a6c:	74 0d                	je     80107a7b <mappages+0x60>
      panic("remap");
80107a6e:	83 ec 0c             	sub    $0xc,%esp
80107a71:	68 ac ac 10 80       	push   $0x8010acac
80107a76:	e8 2e 8b ff ff       	call   801005a9 <panic>
    *pte = pa | perm | PTE_P;
80107a7b:	8b 45 18             	mov    0x18(%ebp),%eax
80107a7e:	0b 45 14             	or     0x14(%ebp),%eax
80107a81:	83 c8 01             	or     $0x1,%eax
80107a84:	89 c2                	mov    %eax,%edx
80107a86:	8b 45 ec             	mov    -0x14(%ebp),%eax
80107a89:	89 10                	mov    %edx,(%eax)
    if(a == last)
80107a8b:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107a8e:	3b 45 f0             	cmp    -0x10(%ebp),%eax
80107a91:	74 10                	je     80107aa3 <mappages+0x88>
      break;
    a += PGSIZE;
80107a93:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
    pa += PGSIZE;
80107a9a:	81 45 14 00 10 00 00 	addl   $0x1000,0x14(%ebp)
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
80107aa1:	eb 9c                	jmp    80107a3f <mappages+0x24>
      break;
80107aa3:	90                   	nop
  }
  return 0;
80107aa4:	b8 00 00 00 00       	mov    $0x0,%eax
}
80107aa9:	c9                   	leave  
80107aaa:	c3                   	ret    

80107aab <setupkvm>:
};

// Set up kernel part of a page table.
pde_t*
setupkvm(void)
{
80107aab:	55                   	push   %ebp
80107aac:	89 e5                	mov    %esp,%ebp
80107aae:	53                   	push   %ebx
80107aaf:	83 ec 24             	sub    $0x24,%esp
  pde_t *pgdir;
  struct kmap *k;
  k = kmap;
80107ab2:	c7 45 f4 a0 f4 10 80 	movl   $0x8010f4a0,-0xc(%ebp)
  struct kmap vram = { (void*)(DEVSPACE - gpu.vram_size),gpu.pvram_addr,gpu.pvram_addr+gpu.vram_size, PTE_W};
80107ab9:	8b 15 90 9e 11 80    	mov    0x80119e90,%edx
80107abf:	b8 00 00 00 fe       	mov    $0xfe000000,%eax
80107ac4:	29 d0                	sub    %edx,%eax
80107ac6:	89 45 e0             	mov    %eax,-0x20(%ebp)
80107ac9:	a1 88 9e 11 80       	mov    0x80119e88,%eax
80107ace:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80107ad1:	8b 15 88 9e 11 80    	mov    0x80119e88,%edx
80107ad7:	a1 90 9e 11 80       	mov    0x80119e90,%eax
80107adc:	01 d0                	add    %edx,%eax
80107ade:	89 45 e8             	mov    %eax,-0x18(%ebp)
80107ae1:	c7 45 ec 02 00 00 00 	movl   $0x2,-0x14(%ebp)
  k[3] = vram;
80107ae8:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107aeb:	83 c0 30             	add    $0x30,%eax
80107aee:	8b 55 e0             	mov    -0x20(%ebp),%edx
80107af1:	89 10                	mov    %edx,(%eax)
80107af3:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80107af6:	89 50 04             	mov    %edx,0x4(%eax)
80107af9:	8b 55 e8             	mov    -0x18(%ebp),%edx
80107afc:	89 50 08             	mov    %edx,0x8(%eax)
80107aff:	8b 55 ec             	mov    -0x14(%ebp),%edx
80107b02:	89 50 0c             	mov    %edx,0xc(%eax)
  if((pgdir = (pde_t*)kalloc()) == 0){
80107b05:	e8 7a b1 ff ff       	call   80102c84 <kalloc>
80107b0a:	89 45 f0             	mov    %eax,-0x10(%ebp)
80107b0d:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80107b11:	75 07                	jne    80107b1a <setupkvm+0x6f>
    return 0;
80107b13:	b8 00 00 00 00       	mov    $0x0,%eax
80107b18:	eb 78                	jmp    80107b92 <setupkvm+0xe7>
  }
  memset(pgdir, 0, PGSIZE);
80107b1a:	83 ec 04             	sub    $0x4,%esp
80107b1d:	68 00 10 00 00       	push   $0x1000
80107b22:	6a 00                	push   $0x0
80107b24:	ff 75 f0             	push   -0x10(%ebp)
80107b27:	e8 e7 d5 ff ff       	call   80105113 <memset>
80107b2c:	83 c4 10             	add    $0x10,%esp
  if (P2V(PHYSTOP) > (void*)DEVSPACE)
    panic("PHYSTOP too high");
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
80107b2f:	c7 45 f4 a0 f4 10 80 	movl   $0x8010f4a0,-0xc(%ebp)
80107b36:	eb 4e                	jmp    80107b86 <setupkvm+0xdb>
    if(mappages(pgdir, k->virt, k->phys_end - k->phys_start,
80107b38:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107b3b:	8b 48 0c             	mov    0xc(%eax),%ecx
                (uint)k->phys_start, k->perm) < 0) {
80107b3e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107b41:	8b 50 04             	mov    0x4(%eax),%edx
    if(mappages(pgdir, k->virt, k->phys_end - k->phys_start,
80107b44:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107b47:	8b 58 08             	mov    0x8(%eax),%ebx
80107b4a:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107b4d:	8b 40 04             	mov    0x4(%eax),%eax
80107b50:	29 c3                	sub    %eax,%ebx
80107b52:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107b55:	8b 00                	mov    (%eax),%eax
80107b57:	83 ec 0c             	sub    $0xc,%esp
80107b5a:	51                   	push   %ecx
80107b5b:	52                   	push   %edx
80107b5c:	53                   	push   %ebx
80107b5d:	50                   	push   %eax
80107b5e:	ff 75 f0             	push   -0x10(%ebp)
80107b61:	e8 b5 fe ff ff       	call   80107a1b <mappages>
80107b66:	83 c4 20             	add    $0x20,%esp
80107b69:	85 c0                	test   %eax,%eax
80107b6b:	79 15                	jns    80107b82 <setupkvm+0xd7>
      freevm(pgdir);
80107b6d:	83 ec 0c             	sub    $0xc,%esp
80107b70:	ff 75 f0             	push   -0x10(%ebp)
80107b73:	e8 f5 04 00 00       	call   8010806d <freevm>
80107b78:	83 c4 10             	add    $0x10,%esp
      return 0;
80107b7b:	b8 00 00 00 00       	mov    $0x0,%eax
80107b80:	eb 10                	jmp    80107b92 <setupkvm+0xe7>
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
80107b82:	83 45 f4 10          	addl   $0x10,-0xc(%ebp)
80107b86:	81 7d f4 00 f5 10 80 	cmpl   $0x8010f500,-0xc(%ebp)
80107b8d:	72 a9                	jb     80107b38 <setupkvm+0x8d>
    }
  return pgdir;
80107b8f:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
80107b92:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80107b95:	c9                   	leave  
80107b96:	c3                   	ret    

80107b97 <kvmalloc>:

// Allocate one page table for the machine for the kernel address
// space for scheduler processes.
void
kvmalloc(void)
{
80107b97:	55                   	push   %ebp
80107b98:	89 e5                	mov    %esp,%ebp
80107b9a:	83 ec 08             	sub    $0x8,%esp
  kpgdir = setupkvm();
80107b9d:	e8 09 ff ff ff       	call   80107aab <setupkvm>
80107ba2:	a3 bc 9b 11 80       	mov    %eax,0x80119bbc
  switchkvm();
80107ba7:	e8 03 00 00 00       	call   80107baf <switchkvm>
}
80107bac:	90                   	nop
80107bad:	c9                   	leave  
80107bae:	c3                   	ret    

80107baf <switchkvm>:

// Switch h/w page table register to the kernel-only page table,
// for when no process is running.
void
switchkvm(void)
{
80107baf:	55                   	push   %ebp
80107bb0:	89 e5                	mov    %esp,%ebp
  lcr3(V2P(kpgdir));   // switch to the kernel page table
80107bb2:	a1 bc 9b 11 80       	mov    0x80119bbc,%eax
80107bb7:	05 00 00 00 80       	add    $0x80000000,%eax
80107bbc:	50                   	push   %eax
80107bbd:	e8 61 fa ff ff       	call   80107623 <lcr3>
80107bc2:	83 c4 04             	add    $0x4,%esp
}
80107bc5:	90                   	nop
80107bc6:	c9                   	leave  
80107bc7:	c3                   	ret    

80107bc8 <switchuvm>:

// Switch TSS and h/w page table to correspond to process p.
void
switchuvm(struct proc *p)
{
80107bc8:	55                   	push   %ebp
80107bc9:	89 e5                	mov    %esp,%ebp
80107bcb:	56                   	push   %esi
80107bcc:	53                   	push   %ebx
80107bcd:	83 ec 10             	sub    $0x10,%esp
  if(p == 0)
80107bd0:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
80107bd4:	75 0d                	jne    80107be3 <switchuvm+0x1b>
    panic("switchuvm: no process");
80107bd6:	83 ec 0c             	sub    $0xc,%esp
80107bd9:	68 b2 ac 10 80       	push   $0x8010acb2
80107bde:	e8 c6 89 ff ff       	call   801005a9 <panic>
  if(p->kstack == 0)
80107be3:	8b 45 08             	mov    0x8(%ebp),%eax
80107be6:	8b 40 08             	mov    0x8(%eax),%eax
80107be9:	85 c0                	test   %eax,%eax
80107beb:	75 0d                	jne    80107bfa <switchuvm+0x32>
    panic("switchuvm: no kstack");
80107bed:	83 ec 0c             	sub    $0xc,%esp
80107bf0:	68 c8 ac 10 80       	push   $0x8010acc8
80107bf5:	e8 af 89 ff ff       	call   801005a9 <panic>
  if(p->pgdir == 0)
80107bfa:	8b 45 08             	mov    0x8(%ebp),%eax
80107bfd:	8b 40 04             	mov    0x4(%eax),%eax
80107c00:	85 c0                	test   %eax,%eax
80107c02:	75 0d                	jne    80107c11 <switchuvm+0x49>
    panic("switchuvm: no pgdir");
80107c04:	83 ec 0c             	sub    $0xc,%esp
80107c07:	68 dd ac 10 80       	push   $0x8010acdd
80107c0c:	e8 98 89 ff ff       	call   801005a9 <panic>

  pushcli();
80107c11:	e8 f2 d3 ff ff       	call   80105008 <pushcli>
  mycpu()->gdt[SEG_TSS] = SEG16(STS_T32A, &mycpu()->ts,
80107c16:	e8 81 c2 ff ff       	call   80103e9c <mycpu>
80107c1b:	89 c3                	mov    %eax,%ebx
80107c1d:	e8 7a c2 ff ff       	call   80103e9c <mycpu>
80107c22:	83 c0 08             	add    $0x8,%eax
80107c25:	89 c6                	mov    %eax,%esi
80107c27:	e8 70 c2 ff ff       	call   80103e9c <mycpu>
80107c2c:	83 c0 08             	add    $0x8,%eax
80107c2f:	c1 e8 10             	shr    $0x10,%eax
80107c32:	88 45 f7             	mov    %al,-0x9(%ebp)
80107c35:	e8 62 c2 ff ff       	call   80103e9c <mycpu>
80107c3a:	83 c0 08             	add    $0x8,%eax
80107c3d:	c1 e8 18             	shr    $0x18,%eax
80107c40:	89 c2                	mov    %eax,%edx
80107c42:	66 c7 83 98 00 00 00 	movw   $0x67,0x98(%ebx)
80107c49:	67 00 
80107c4b:	66 89 b3 9a 00 00 00 	mov    %si,0x9a(%ebx)
80107c52:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
80107c56:	88 83 9c 00 00 00    	mov    %al,0x9c(%ebx)
80107c5c:	0f b6 83 9d 00 00 00 	movzbl 0x9d(%ebx),%eax
80107c63:	83 e0 f0             	and    $0xfffffff0,%eax
80107c66:	83 c8 09             	or     $0x9,%eax
80107c69:	88 83 9d 00 00 00    	mov    %al,0x9d(%ebx)
80107c6f:	0f b6 83 9d 00 00 00 	movzbl 0x9d(%ebx),%eax
80107c76:	83 c8 10             	or     $0x10,%eax
80107c79:	88 83 9d 00 00 00    	mov    %al,0x9d(%ebx)
80107c7f:	0f b6 83 9d 00 00 00 	movzbl 0x9d(%ebx),%eax
80107c86:	83 e0 9f             	and    $0xffffff9f,%eax
80107c89:	88 83 9d 00 00 00    	mov    %al,0x9d(%ebx)
80107c8f:	0f b6 83 9d 00 00 00 	movzbl 0x9d(%ebx),%eax
80107c96:	83 c8 80             	or     $0xffffff80,%eax
80107c99:	88 83 9d 00 00 00    	mov    %al,0x9d(%ebx)
80107c9f:	0f b6 83 9e 00 00 00 	movzbl 0x9e(%ebx),%eax
80107ca6:	83 e0 f0             	and    $0xfffffff0,%eax
80107ca9:	88 83 9e 00 00 00    	mov    %al,0x9e(%ebx)
80107caf:	0f b6 83 9e 00 00 00 	movzbl 0x9e(%ebx),%eax
80107cb6:	83 e0 ef             	and    $0xffffffef,%eax
80107cb9:	88 83 9e 00 00 00    	mov    %al,0x9e(%ebx)
80107cbf:	0f b6 83 9e 00 00 00 	movzbl 0x9e(%ebx),%eax
80107cc6:	83 e0 df             	and    $0xffffffdf,%eax
80107cc9:	88 83 9e 00 00 00    	mov    %al,0x9e(%ebx)
80107ccf:	0f b6 83 9e 00 00 00 	movzbl 0x9e(%ebx),%eax
80107cd6:	83 c8 40             	or     $0x40,%eax
80107cd9:	88 83 9e 00 00 00    	mov    %al,0x9e(%ebx)
80107cdf:	0f b6 83 9e 00 00 00 	movzbl 0x9e(%ebx),%eax
80107ce6:	83 e0 7f             	and    $0x7f,%eax
80107ce9:	88 83 9e 00 00 00    	mov    %al,0x9e(%ebx)
80107cef:	88 93 9f 00 00 00    	mov    %dl,0x9f(%ebx)
                                sizeof(mycpu()->ts)-1, 0);
  mycpu()->gdt[SEG_TSS].s = 0;
80107cf5:	e8 a2 c1 ff ff       	call   80103e9c <mycpu>
80107cfa:	0f b6 90 9d 00 00 00 	movzbl 0x9d(%eax),%edx
80107d01:	83 e2 ef             	and    $0xffffffef,%edx
80107d04:	88 90 9d 00 00 00    	mov    %dl,0x9d(%eax)
  mycpu()->ts.ss0 = SEG_KDATA << 3;
80107d0a:	e8 8d c1 ff ff       	call   80103e9c <mycpu>
80107d0f:	66 c7 40 10 10 00    	movw   $0x10,0x10(%eax)
  mycpu()->ts.esp0 = (uint)p->kstack + KSTACKSIZE;
80107d15:	8b 45 08             	mov    0x8(%ebp),%eax
80107d18:	8b 40 08             	mov    0x8(%eax),%eax
80107d1b:	89 c3                	mov    %eax,%ebx
80107d1d:	e8 7a c1 ff ff       	call   80103e9c <mycpu>
80107d22:	8d 93 00 10 00 00    	lea    0x1000(%ebx),%edx
80107d28:	89 50 0c             	mov    %edx,0xc(%eax)
  // setting IOPL=0 in eflags *and* iomb beyond the tss segment limit
  // forbids I/O instructions (e.g., inb and outb) from user space
  mycpu()->ts.iomb = (ushort) 0xFFFF;
80107d2b:	e8 6c c1 ff ff       	call   80103e9c <mycpu>
80107d30:	66 c7 40 6e ff ff    	movw   $0xffff,0x6e(%eax)
  ltr(SEG_TSS << 3);
80107d36:	83 ec 0c             	sub    $0xc,%esp
80107d39:	6a 28                	push   $0x28
80107d3b:	e8 cc f8 ff ff       	call   8010760c <ltr>
80107d40:	83 c4 10             	add    $0x10,%esp
  lcr3(V2P(p->pgdir));  // switch to process's address space
80107d43:	8b 45 08             	mov    0x8(%ebp),%eax
80107d46:	8b 40 04             	mov    0x4(%eax),%eax
80107d49:	05 00 00 00 80       	add    $0x80000000,%eax
80107d4e:	83 ec 0c             	sub    $0xc,%esp
80107d51:	50                   	push   %eax
80107d52:	e8 cc f8 ff ff       	call   80107623 <lcr3>
80107d57:	83 c4 10             	add    $0x10,%esp
  popcli();
80107d5a:	e8 f6 d2 ff ff       	call   80105055 <popcli>
}
80107d5f:	90                   	nop
80107d60:	8d 65 f8             	lea    -0x8(%ebp),%esp
80107d63:	5b                   	pop    %ebx
80107d64:	5e                   	pop    %esi
80107d65:	5d                   	pop    %ebp
80107d66:	c3                   	ret    

80107d67 <inituvm>:

// Load the initcode into address 0 of pgdir.
// sz must be less than a page.
void
inituvm(pde_t *pgdir, char *init, uint sz)
{
80107d67:	55                   	push   %ebp
80107d68:	89 e5                	mov    %esp,%ebp
80107d6a:	83 ec 18             	sub    $0x18,%esp
  char *mem;

  if(sz >= PGSIZE)
80107d6d:	81 7d 10 ff 0f 00 00 	cmpl   $0xfff,0x10(%ebp)
80107d74:	76 0d                	jbe    80107d83 <inituvm+0x1c>
    panic("inituvm: more than a page");
80107d76:	83 ec 0c             	sub    $0xc,%esp
80107d79:	68 f1 ac 10 80       	push   $0x8010acf1
80107d7e:	e8 26 88 ff ff       	call   801005a9 <panic>
  mem = kalloc();
80107d83:	e8 fc ae ff ff       	call   80102c84 <kalloc>
80107d88:	89 45 f4             	mov    %eax,-0xc(%ebp)
  memset(mem, 0, PGSIZE);
80107d8b:	83 ec 04             	sub    $0x4,%esp
80107d8e:	68 00 10 00 00       	push   $0x1000
80107d93:	6a 00                	push   $0x0
80107d95:	ff 75 f4             	push   -0xc(%ebp)
80107d98:	e8 76 d3 ff ff       	call   80105113 <memset>
80107d9d:	83 c4 10             	add    $0x10,%esp
  mappages(pgdir, 0, PGSIZE, V2P(mem), PTE_W|PTE_U);
80107da0:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107da3:	05 00 00 00 80       	add    $0x80000000,%eax
80107da8:	83 ec 0c             	sub    $0xc,%esp
80107dab:	6a 06                	push   $0x6
80107dad:	50                   	push   %eax
80107dae:	68 00 10 00 00       	push   $0x1000
80107db3:	6a 00                	push   $0x0
80107db5:	ff 75 08             	push   0x8(%ebp)
80107db8:	e8 5e fc ff ff       	call   80107a1b <mappages>
80107dbd:	83 c4 20             	add    $0x20,%esp
  memmove(mem, init, sz);
80107dc0:	83 ec 04             	sub    $0x4,%esp
80107dc3:	ff 75 10             	push   0x10(%ebp)
80107dc6:	ff 75 0c             	push   0xc(%ebp)
80107dc9:	ff 75 f4             	push   -0xc(%ebp)
80107dcc:	e8 01 d4 ff ff       	call   801051d2 <memmove>
80107dd1:	83 c4 10             	add    $0x10,%esp
}
80107dd4:	90                   	nop
80107dd5:	c9                   	leave  
80107dd6:	c3                   	ret    

80107dd7 <loaduvm>:

// Load a program segment into pgdir.  addr must be page-aligned
// and the pages from addr to addr+sz must already be mapped.
int
loaduvm(pde_t *pgdir, char *addr, struct inode *ip, uint offset, uint sz)
{
80107dd7:	55                   	push   %ebp
80107dd8:	89 e5                	mov    %esp,%ebp
80107dda:	83 ec 18             	sub    $0x18,%esp
  uint i, pa, n;
  pte_t *pte;

  if((uint) addr % PGSIZE != 0)
80107ddd:	8b 45 0c             	mov    0xc(%ebp),%eax
80107de0:	25 ff 0f 00 00       	and    $0xfff,%eax
80107de5:	85 c0                	test   %eax,%eax
80107de7:	74 0d                	je     80107df6 <loaduvm+0x1f>
    panic("loaduvm: addr must be page aligned");
80107de9:	83 ec 0c             	sub    $0xc,%esp
80107dec:	68 0c ad 10 80       	push   $0x8010ad0c
80107df1:	e8 b3 87 ff ff       	call   801005a9 <panic>
  for(i = 0; i < sz; i += PGSIZE){
80107df6:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80107dfd:	e9 8f 00 00 00       	jmp    80107e91 <loaduvm+0xba>
    if((pte = walkpgdir(pgdir, addr+i, 0)) == 0)
80107e02:	8b 55 0c             	mov    0xc(%ebp),%edx
80107e05:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107e08:	01 d0                	add    %edx,%eax
80107e0a:	83 ec 04             	sub    $0x4,%esp
80107e0d:	6a 00                	push   $0x0
80107e0f:	50                   	push   %eax
80107e10:	ff 75 08             	push   0x8(%ebp)
80107e13:	e8 6d fb ff ff       	call   80107985 <walkpgdir>
80107e18:	83 c4 10             	add    $0x10,%esp
80107e1b:	89 45 ec             	mov    %eax,-0x14(%ebp)
80107e1e:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
80107e22:	75 0d                	jne    80107e31 <loaduvm+0x5a>
      panic("loaduvm: address should exist");
80107e24:	83 ec 0c             	sub    $0xc,%esp
80107e27:	68 2f ad 10 80       	push   $0x8010ad2f
80107e2c:	e8 78 87 ff ff       	call   801005a9 <panic>
    pa = PTE_ADDR(*pte);
80107e31:	8b 45 ec             	mov    -0x14(%ebp),%eax
80107e34:	8b 00                	mov    (%eax),%eax
80107e36:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80107e3b:	89 45 e8             	mov    %eax,-0x18(%ebp)
    if(sz - i < PGSIZE)
80107e3e:	8b 45 18             	mov    0x18(%ebp),%eax
80107e41:	2b 45 f4             	sub    -0xc(%ebp),%eax
80107e44:	3d ff 0f 00 00       	cmp    $0xfff,%eax
80107e49:	77 0b                	ja     80107e56 <loaduvm+0x7f>
      n = sz - i;
80107e4b:	8b 45 18             	mov    0x18(%ebp),%eax
80107e4e:	2b 45 f4             	sub    -0xc(%ebp),%eax
80107e51:	89 45 f0             	mov    %eax,-0x10(%ebp)
80107e54:	eb 07                	jmp    80107e5d <loaduvm+0x86>
    else
      n = PGSIZE;
80107e56:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
    if(readi(ip, P2V(pa), offset+i, n) != n)
80107e5d:	8b 55 14             	mov    0x14(%ebp),%edx
80107e60:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107e63:	01 d0                	add    %edx,%eax
80107e65:	8b 55 e8             	mov    -0x18(%ebp),%edx
80107e68:	81 c2 00 00 00 80    	add    $0x80000000,%edx
80107e6e:	ff 75 f0             	push   -0x10(%ebp)
80107e71:	50                   	push   %eax
80107e72:	52                   	push   %edx
80107e73:	ff 75 10             	push   0x10(%ebp)
80107e76:	e8 5b a0 ff ff       	call   80101ed6 <readi>
80107e7b:	83 c4 10             	add    $0x10,%esp
80107e7e:	39 45 f0             	cmp    %eax,-0x10(%ebp)
80107e81:	74 07                	je     80107e8a <loaduvm+0xb3>
      return -1;
80107e83:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80107e88:	eb 18                	jmp    80107ea2 <loaduvm+0xcb>
  for(i = 0; i < sz; i += PGSIZE){
80107e8a:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
80107e91:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107e94:	3b 45 18             	cmp    0x18(%ebp),%eax
80107e97:	0f 82 65 ff ff ff    	jb     80107e02 <loaduvm+0x2b>
  }
  return 0;
80107e9d:	b8 00 00 00 00       	mov    $0x0,%eax
}
80107ea2:	c9                   	leave  
80107ea3:	c3                   	ret    

80107ea4 <allocuvm>:

// Allocate page tables and physical memory to grow process from oldsz to
// newsz, which need not be page aligned.  Returns new size or 0 on error.
int
allocuvm(pde_t *pgdir, uint oldsz, uint newsz)
{
80107ea4:	55                   	push   %ebp
80107ea5:	89 e5                	mov    %esp,%ebp
80107ea7:	83 ec 18             	sub    $0x18,%esp
  char *mem;
  uint a;

  if(newsz >= KERNBASE)
80107eaa:	8b 45 10             	mov    0x10(%ebp),%eax
80107ead:	85 c0                	test   %eax,%eax
80107eaf:	79 0a                	jns    80107ebb <allocuvm+0x17>
    return 0;
80107eb1:	b8 00 00 00 00       	mov    $0x0,%eax
80107eb6:	e9 ec 00 00 00       	jmp    80107fa7 <allocuvm+0x103>
  if(newsz < oldsz)
80107ebb:	8b 45 10             	mov    0x10(%ebp),%eax
80107ebe:	3b 45 0c             	cmp    0xc(%ebp),%eax
80107ec1:	73 08                	jae    80107ecb <allocuvm+0x27>
    return oldsz;
80107ec3:	8b 45 0c             	mov    0xc(%ebp),%eax
80107ec6:	e9 dc 00 00 00       	jmp    80107fa7 <allocuvm+0x103>

  a = PGROUNDUP(oldsz);
80107ecb:	8b 45 0c             	mov    0xc(%ebp),%eax
80107ece:	05 ff 0f 00 00       	add    $0xfff,%eax
80107ed3:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80107ed8:	89 45 f4             	mov    %eax,-0xc(%ebp)
  for(; a < newsz; a += PGSIZE){
80107edb:	e9 b8 00 00 00       	jmp    80107f98 <allocuvm+0xf4>
    mem = kalloc();
80107ee0:	e8 9f ad ff ff       	call   80102c84 <kalloc>
80107ee5:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(mem == 0){
80107ee8:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80107eec:	75 2e                	jne    80107f1c <allocuvm+0x78>
      cprintf("allocuvm out of memory\n");
80107eee:	83 ec 0c             	sub    $0xc,%esp
80107ef1:	68 4d ad 10 80       	push   $0x8010ad4d
80107ef6:	e8 f9 84 ff ff       	call   801003f4 <cprintf>
80107efb:	83 c4 10             	add    $0x10,%esp
      deallocuvm(pgdir, newsz, oldsz);
80107efe:	83 ec 04             	sub    $0x4,%esp
80107f01:	ff 75 0c             	push   0xc(%ebp)
80107f04:	ff 75 10             	push   0x10(%ebp)
80107f07:	ff 75 08             	push   0x8(%ebp)
80107f0a:	e8 9a 00 00 00       	call   80107fa9 <deallocuvm>
80107f0f:	83 c4 10             	add    $0x10,%esp
      return 0;
80107f12:	b8 00 00 00 00       	mov    $0x0,%eax
80107f17:	e9 8b 00 00 00       	jmp    80107fa7 <allocuvm+0x103>
    }
    memset(mem, 0, PGSIZE);
80107f1c:	83 ec 04             	sub    $0x4,%esp
80107f1f:	68 00 10 00 00       	push   $0x1000
80107f24:	6a 00                	push   $0x0
80107f26:	ff 75 f0             	push   -0x10(%ebp)
80107f29:	e8 e5 d1 ff ff       	call   80105113 <memset>
80107f2e:	83 c4 10             	add    $0x10,%esp
    if(mappages(pgdir, (char*)a, PGSIZE, V2P(mem), PTE_W|PTE_U) < 0){
80107f31:	8b 45 f0             	mov    -0x10(%ebp),%eax
80107f34:	8d 90 00 00 00 80    	lea    -0x80000000(%eax),%edx
80107f3a:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107f3d:	83 ec 0c             	sub    $0xc,%esp
80107f40:	6a 06                	push   $0x6
80107f42:	52                   	push   %edx
80107f43:	68 00 10 00 00       	push   $0x1000
80107f48:	50                   	push   %eax
80107f49:	ff 75 08             	push   0x8(%ebp)
80107f4c:	e8 ca fa ff ff       	call   80107a1b <mappages>
80107f51:	83 c4 20             	add    $0x20,%esp
80107f54:	85 c0                	test   %eax,%eax
80107f56:	79 39                	jns    80107f91 <allocuvm+0xed>
      cprintf("allocuvm out of memory (2)\n");
80107f58:	83 ec 0c             	sub    $0xc,%esp
80107f5b:	68 65 ad 10 80       	push   $0x8010ad65
80107f60:	e8 8f 84 ff ff       	call   801003f4 <cprintf>
80107f65:	83 c4 10             	add    $0x10,%esp
      deallocuvm(pgdir, newsz, oldsz);
80107f68:	83 ec 04             	sub    $0x4,%esp
80107f6b:	ff 75 0c             	push   0xc(%ebp)
80107f6e:	ff 75 10             	push   0x10(%ebp)
80107f71:	ff 75 08             	push   0x8(%ebp)
80107f74:	e8 30 00 00 00       	call   80107fa9 <deallocuvm>
80107f79:	83 c4 10             	add    $0x10,%esp
      kfree(mem);
80107f7c:	83 ec 0c             	sub    $0xc,%esp
80107f7f:	ff 75 f0             	push   -0x10(%ebp)
80107f82:	e8 63 ac ff ff       	call   80102bea <kfree>
80107f87:	83 c4 10             	add    $0x10,%esp
      return 0;
80107f8a:	b8 00 00 00 00       	mov    $0x0,%eax
80107f8f:	eb 16                	jmp    80107fa7 <allocuvm+0x103>
  for(; a < newsz; a += PGSIZE){
80107f91:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
80107f98:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107f9b:	3b 45 10             	cmp    0x10(%ebp),%eax
80107f9e:	0f 82 3c ff ff ff    	jb     80107ee0 <allocuvm+0x3c>
    }
  }
  return newsz;
80107fa4:	8b 45 10             	mov    0x10(%ebp),%eax
}
80107fa7:	c9                   	leave  
80107fa8:	c3                   	ret    

80107fa9 <deallocuvm>:
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
int
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
{
80107fa9:	55                   	push   %ebp
80107faa:	89 e5                	mov    %esp,%ebp
80107fac:	83 ec 18             	sub    $0x18,%esp
  pte_t *pte;
  uint a, pa;

  if(newsz >= oldsz)
80107faf:	8b 45 10             	mov    0x10(%ebp),%eax
80107fb2:	3b 45 0c             	cmp    0xc(%ebp),%eax
80107fb5:	72 08                	jb     80107fbf <deallocuvm+0x16>
    return oldsz;
80107fb7:	8b 45 0c             	mov    0xc(%ebp),%eax
80107fba:	e9 ac 00 00 00       	jmp    8010806b <deallocuvm+0xc2>

  a = PGROUNDUP(newsz);
80107fbf:	8b 45 10             	mov    0x10(%ebp),%eax
80107fc2:	05 ff 0f 00 00       	add    $0xfff,%eax
80107fc7:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80107fcc:	89 45 f4             	mov    %eax,-0xc(%ebp)
  for(; a  < oldsz; a += PGSIZE){
80107fcf:	e9 88 00 00 00       	jmp    8010805c <deallocuvm+0xb3>
    pte = walkpgdir(pgdir, (char*)a, 0);
80107fd4:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107fd7:	83 ec 04             	sub    $0x4,%esp
80107fda:	6a 00                	push   $0x0
80107fdc:	50                   	push   %eax
80107fdd:	ff 75 08             	push   0x8(%ebp)
80107fe0:	e8 a0 f9 ff ff       	call   80107985 <walkpgdir>
80107fe5:	83 c4 10             	add    $0x10,%esp
80107fe8:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(!pte)
80107feb:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80107fef:	75 16                	jne    80108007 <deallocuvm+0x5e>
      a = PGADDR(PDX(a) + 1, 0, 0) - PGSIZE;
80107ff1:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107ff4:	c1 e8 16             	shr    $0x16,%eax
80107ff7:	83 c0 01             	add    $0x1,%eax
80107ffa:	c1 e0 16             	shl    $0x16,%eax
80107ffd:	2d 00 10 00 00       	sub    $0x1000,%eax
80108002:	89 45 f4             	mov    %eax,-0xc(%ebp)
80108005:	eb 4e                	jmp    80108055 <deallocuvm+0xac>
    else if((*pte & PTE_P) != 0){
80108007:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010800a:	8b 00                	mov    (%eax),%eax
8010800c:	83 e0 01             	and    $0x1,%eax
8010800f:	85 c0                	test   %eax,%eax
80108011:	74 42                	je     80108055 <deallocuvm+0xac>
      pa = PTE_ADDR(*pte);
80108013:	8b 45 f0             	mov    -0x10(%ebp),%eax
80108016:	8b 00                	mov    (%eax),%eax
80108018:	25 00 f0 ff ff       	and    $0xfffff000,%eax
8010801d:	89 45 ec             	mov    %eax,-0x14(%ebp)
      if(pa == 0)
80108020:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
80108024:	75 0d                	jne    80108033 <deallocuvm+0x8a>
        panic("kfree");
80108026:	83 ec 0c             	sub    $0xc,%esp
80108029:	68 81 ad 10 80       	push   $0x8010ad81
8010802e:	e8 76 85 ff ff       	call   801005a9 <panic>
      char *v = P2V(pa);
80108033:	8b 45 ec             	mov    -0x14(%ebp),%eax
80108036:	05 00 00 00 80       	add    $0x80000000,%eax
8010803b:	89 45 e8             	mov    %eax,-0x18(%ebp)
      kfree(v);
8010803e:	83 ec 0c             	sub    $0xc,%esp
80108041:	ff 75 e8             	push   -0x18(%ebp)
80108044:	e8 a1 ab ff ff       	call   80102bea <kfree>
80108049:	83 c4 10             	add    $0x10,%esp
      *pte = 0;
8010804c:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010804f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  for(; a  < oldsz; a += PGSIZE){
80108055:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
8010805c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010805f:	3b 45 0c             	cmp    0xc(%ebp),%eax
80108062:	0f 82 6c ff ff ff    	jb     80107fd4 <deallocuvm+0x2b>
    }
  }
  return newsz;
80108068:	8b 45 10             	mov    0x10(%ebp),%eax
}
8010806b:	c9                   	leave  
8010806c:	c3                   	ret    

8010806d <freevm>:

// Free a page table and all the physical memory pages
// in the user part.
void
freevm(pde_t *pgdir)
{
8010806d:	55                   	push   %ebp
8010806e:	89 e5                	mov    %esp,%ebp
80108070:	83 ec 18             	sub    $0x18,%esp
  uint i;

  if(pgdir == 0)
80108073:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
80108077:	75 0d                	jne    80108086 <freevm+0x19>
    panic("freevm: no pgdir");
80108079:	83 ec 0c             	sub    $0xc,%esp
8010807c:	68 87 ad 10 80       	push   $0x8010ad87
80108081:	e8 23 85 ff ff       	call   801005a9 <panic>
  deallocuvm(pgdir, KERNBASE, 0);
80108086:	83 ec 04             	sub    $0x4,%esp
80108089:	6a 00                	push   $0x0
8010808b:	68 00 00 00 80       	push   $0x80000000
80108090:	ff 75 08             	push   0x8(%ebp)
80108093:	e8 11 ff ff ff       	call   80107fa9 <deallocuvm>
80108098:	83 c4 10             	add    $0x10,%esp
  for(i = 0; i < NPDENTRIES; i++){
8010809b:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
801080a2:	eb 48                	jmp    801080ec <freevm+0x7f>
    if(pgdir[i] & PTE_P){
801080a4:	8b 45 f4             	mov    -0xc(%ebp),%eax
801080a7:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
801080ae:	8b 45 08             	mov    0x8(%ebp),%eax
801080b1:	01 d0                	add    %edx,%eax
801080b3:	8b 00                	mov    (%eax),%eax
801080b5:	83 e0 01             	and    $0x1,%eax
801080b8:	85 c0                	test   %eax,%eax
801080ba:	74 2c                	je     801080e8 <freevm+0x7b>
      char * v = P2V(PTE_ADDR(pgdir[i]));
801080bc:	8b 45 f4             	mov    -0xc(%ebp),%eax
801080bf:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
801080c6:	8b 45 08             	mov    0x8(%ebp),%eax
801080c9:	01 d0                	add    %edx,%eax
801080cb:	8b 00                	mov    (%eax),%eax
801080cd:	25 00 f0 ff ff       	and    $0xfffff000,%eax
801080d2:	05 00 00 00 80       	add    $0x80000000,%eax
801080d7:	89 45 f0             	mov    %eax,-0x10(%ebp)
      kfree(v);
801080da:	83 ec 0c             	sub    $0xc,%esp
801080dd:	ff 75 f0             	push   -0x10(%ebp)
801080e0:	e8 05 ab ff ff       	call   80102bea <kfree>
801080e5:	83 c4 10             	add    $0x10,%esp
  for(i = 0; i < NPDENTRIES; i++){
801080e8:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
801080ec:	81 7d f4 ff 03 00 00 	cmpl   $0x3ff,-0xc(%ebp)
801080f3:	76 af                	jbe    801080a4 <freevm+0x37>
    }
  }
  kfree((char*)pgdir);
801080f5:	83 ec 0c             	sub    $0xc,%esp
801080f8:	ff 75 08             	push   0x8(%ebp)
801080fb:	e8 ea aa ff ff       	call   80102bea <kfree>
80108100:	83 c4 10             	add    $0x10,%esp
}
80108103:	90                   	nop
80108104:	c9                   	leave  
80108105:	c3                   	ret    

80108106 <clearpteu>:

// Clear PTE_U on a page. Used to create an inaccessible
// page beneath the user stack.
void
clearpteu(pde_t *pgdir, char *uva)
{
80108106:	55                   	push   %ebp
80108107:	89 e5                	mov    %esp,%ebp
80108109:	83 ec 18             	sub    $0x18,%esp
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
8010810c:	83 ec 04             	sub    $0x4,%esp
8010810f:	6a 00                	push   $0x0
80108111:	ff 75 0c             	push   0xc(%ebp)
80108114:	ff 75 08             	push   0x8(%ebp)
80108117:	e8 69 f8 ff ff       	call   80107985 <walkpgdir>
8010811c:	83 c4 10             	add    $0x10,%esp
8010811f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(pte == 0)
80108122:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80108126:	75 0d                	jne    80108135 <clearpteu+0x2f>
    panic("clearpteu");
80108128:	83 ec 0c             	sub    $0xc,%esp
8010812b:	68 98 ad 10 80       	push   $0x8010ad98
80108130:	e8 74 84 ff ff       	call   801005a9 <panic>
  *pte &= ~PTE_U;
80108135:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108138:	8b 00                	mov    (%eax),%eax
8010813a:	83 e0 fb             	and    $0xfffffffb,%eax
8010813d:	89 c2                	mov    %eax,%edx
8010813f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108142:	89 10                	mov    %edx,(%eax)
}
80108144:	90                   	nop
80108145:	c9                   	leave  
80108146:	c3                   	ret    

80108147 <copyuvm>:

// Given a parent process's page table, create a copy
// of it for a child.
pde_t*
copyuvm(pde_t *pgdir, uint sz)
{
80108147:	55                   	push   %ebp
80108148:	89 e5                	mov    %esp,%ebp
8010814a:	83 ec 28             	sub    $0x28,%esp
  pde_t *d;
  pte_t *pte;
  uint pa, i, flags;
  char *mem;

  if((d = setupkvm()) == 0)
8010814d:	e8 59 f9 ff ff       	call   80107aab <setupkvm>
80108152:	89 45 f0             	mov    %eax,-0x10(%ebp)
80108155:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80108159:	75 0a                	jne    80108165 <copyuvm+0x1e>
    return 0;
8010815b:	b8 00 00 00 00       	mov    $0x0,%eax
80108160:	e9 eb 00 00 00       	jmp    80108250 <copyuvm+0x109>
  for(i = 0; i < sz; i += PGSIZE){
80108165:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
8010816c:	e9 b7 00 00 00       	jmp    80108228 <copyuvm+0xe1>
    if((pte = walkpgdir(pgdir, (void *) i, 0)) == 0)
80108171:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108174:	83 ec 04             	sub    $0x4,%esp
80108177:	6a 00                	push   $0x0
80108179:	50                   	push   %eax
8010817a:	ff 75 08             	push   0x8(%ebp)
8010817d:	e8 03 f8 ff ff       	call   80107985 <walkpgdir>
80108182:	83 c4 10             	add    $0x10,%esp
80108185:	89 45 ec             	mov    %eax,-0x14(%ebp)
80108188:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
8010818c:	75 0d                	jne    8010819b <copyuvm+0x54>
      panic("copyuvm: pte should exist");
8010818e:	83 ec 0c             	sub    $0xc,%esp
80108191:	68 a2 ad 10 80       	push   $0x8010ada2
80108196:	e8 0e 84 ff ff       	call   801005a9 <panic>
    if(!(*pte & PTE_P))
8010819b:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010819e:	8b 00                	mov    (%eax),%eax
801081a0:	83 e0 01             	and    $0x1,%eax
801081a3:	85 c0                	test   %eax,%eax
801081a5:	75 0d                	jne    801081b4 <copyuvm+0x6d>
      panic("copyuvm: page not present");
801081a7:	83 ec 0c             	sub    $0xc,%esp
801081aa:	68 bc ad 10 80       	push   $0x8010adbc
801081af:	e8 f5 83 ff ff       	call   801005a9 <panic>
    pa = PTE_ADDR(*pte);
801081b4:	8b 45 ec             	mov    -0x14(%ebp),%eax
801081b7:	8b 00                	mov    (%eax),%eax
801081b9:	25 00 f0 ff ff       	and    $0xfffff000,%eax
801081be:	89 45 e8             	mov    %eax,-0x18(%ebp)
    flags = PTE_FLAGS(*pte);
801081c1:	8b 45 ec             	mov    -0x14(%ebp),%eax
801081c4:	8b 00                	mov    (%eax),%eax
801081c6:	25 ff 0f 00 00       	and    $0xfff,%eax
801081cb:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if((mem = kalloc()) == 0)
801081ce:	e8 b1 aa ff ff       	call   80102c84 <kalloc>
801081d3:	89 45 e0             	mov    %eax,-0x20(%ebp)
801081d6:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
801081da:	74 5d                	je     80108239 <copyuvm+0xf2>
      goto bad;
    memmove(mem, (char*)P2V(pa), PGSIZE);
801081dc:	8b 45 e8             	mov    -0x18(%ebp),%eax
801081df:	05 00 00 00 80       	add    $0x80000000,%eax
801081e4:	83 ec 04             	sub    $0x4,%esp
801081e7:	68 00 10 00 00       	push   $0x1000
801081ec:	50                   	push   %eax
801081ed:	ff 75 e0             	push   -0x20(%ebp)
801081f0:	e8 dd cf ff ff       	call   801051d2 <memmove>
801081f5:	83 c4 10             	add    $0x10,%esp
    if(mappages(d, (void*)i, PGSIZE, V2P(mem), flags) < 0)
801081f8:	8b 55 e4             	mov    -0x1c(%ebp),%edx
801081fb:	8b 45 e0             	mov    -0x20(%ebp),%eax
801081fe:	8d 88 00 00 00 80    	lea    -0x80000000(%eax),%ecx
80108204:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108207:	83 ec 0c             	sub    $0xc,%esp
8010820a:	52                   	push   %edx
8010820b:	51                   	push   %ecx
8010820c:	68 00 10 00 00       	push   $0x1000
80108211:	50                   	push   %eax
80108212:	ff 75 f0             	push   -0x10(%ebp)
80108215:	e8 01 f8 ff ff       	call   80107a1b <mappages>
8010821a:	83 c4 20             	add    $0x20,%esp
8010821d:	85 c0                	test   %eax,%eax
8010821f:	78 1b                	js     8010823c <copyuvm+0xf5>
  for(i = 0; i < sz; i += PGSIZE){
80108221:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
80108228:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010822b:	3b 45 0c             	cmp    0xc(%ebp),%eax
8010822e:	0f 82 3d ff ff ff    	jb     80108171 <copyuvm+0x2a>
      goto bad;
  }
  return d;
80108234:	8b 45 f0             	mov    -0x10(%ebp),%eax
80108237:	eb 17                	jmp    80108250 <copyuvm+0x109>
      goto bad;
80108239:	90                   	nop
8010823a:	eb 01                	jmp    8010823d <copyuvm+0xf6>
      goto bad;
8010823c:	90                   	nop

bad:
  freevm(d);
8010823d:	83 ec 0c             	sub    $0xc,%esp
80108240:	ff 75 f0             	push   -0x10(%ebp)
80108243:	e8 25 fe ff ff       	call   8010806d <freevm>
80108248:	83 c4 10             	add    $0x10,%esp
  return 0;
8010824b:	b8 00 00 00 00       	mov    $0x0,%eax
}
80108250:	c9                   	leave  
80108251:	c3                   	ret    

80108252 <uva2ka>:

//PAGEBREAK!
// Map user virtual address to kernel address.
char*
uva2ka(pde_t *pgdir, char *uva)
{
80108252:	55                   	push   %ebp
80108253:	89 e5                	mov    %esp,%ebp
80108255:	83 ec 18             	sub    $0x18,%esp
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
80108258:	83 ec 04             	sub    $0x4,%esp
8010825b:	6a 00                	push   $0x0
8010825d:	ff 75 0c             	push   0xc(%ebp)
80108260:	ff 75 08             	push   0x8(%ebp)
80108263:	e8 1d f7 ff ff       	call   80107985 <walkpgdir>
80108268:	83 c4 10             	add    $0x10,%esp
8010826b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if((*pte & PTE_P) == 0)
8010826e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108271:	8b 00                	mov    (%eax),%eax
80108273:	83 e0 01             	and    $0x1,%eax
80108276:	85 c0                	test   %eax,%eax
80108278:	75 07                	jne    80108281 <uva2ka+0x2f>
    return 0;
8010827a:	b8 00 00 00 00       	mov    $0x0,%eax
8010827f:	eb 22                	jmp    801082a3 <uva2ka+0x51>
  if((*pte & PTE_U) == 0)
80108281:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108284:	8b 00                	mov    (%eax),%eax
80108286:	83 e0 04             	and    $0x4,%eax
80108289:	85 c0                	test   %eax,%eax
8010828b:	75 07                	jne    80108294 <uva2ka+0x42>
    return 0;
8010828d:	b8 00 00 00 00       	mov    $0x0,%eax
80108292:	eb 0f                	jmp    801082a3 <uva2ka+0x51>
  return (char*)P2V(PTE_ADDR(*pte));
80108294:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108297:	8b 00                	mov    (%eax),%eax
80108299:	25 00 f0 ff ff       	and    $0xfffff000,%eax
8010829e:	05 00 00 00 80       	add    $0x80000000,%eax
}
801082a3:	c9                   	leave  
801082a4:	c3                   	ret    

801082a5 <copyout>:
// Copy len bytes from p to user address va in page table pgdir.
// Most useful when pgdir is not the current page table.
// uva2ka ensures this only works for PTE_U pages.
int
copyout(pde_t *pgdir, uint va, void *p, uint len)
{
801082a5:	55                   	push   %ebp
801082a6:	89 e5                	mov    %esp,%ebp
801082a8:	83 ec 18             	sub    $0x18,%esp
  char *buf, *pa0;
  uint n, va0;

  buf = (char*)p;
801082ab:	8b 45 10             	mov    0x10(%ebp),%eax
801082ae:	89 45 f4             	mov    %eax,-0xc(%ebp)
  while(len > 0){
801082b1:	eb 7f                	jmp    80108332 <copyout+0x8d>
    va0 = (uint)PGROUNDDOWN(va);
801082b3:	8b 45 0c             	mov    0xc(%ebp),%eax
801082b6:	25 00 f0 ff ff       	and    $0xfffff000,%eax
801082bb:	89 45 ec             	mov    %eax,-0x14(%ebp)
    pa0 = uva2ka(pgdir, (char*)va0);
801082be:	8b 45 ec             	mov    -0x14(%ebp),%eax
801082c1:	83 ec 08             	sub    $0x8,%esp
801082c4:	50                   	push   %eax
801082c5:	ff 75 08             	push   0x8(%ebp)
801082c8:	e8 85 ff ff ff       	call   80108252 <uva2ka>
801082cd:	83 c4 10             	add    $0x10,%esp
801082d0:	89 45 e8             	mov    %eax,-0x18(%ebp)
    if(pa0 == 0)
801082d3:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
801082d7:	75 07                	jne    801082e0 <copyout+0x3b>
      return -1;
801082d9:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801082de:	eb 61                	jmp    80108341 <copyout+0x9c>
    n = PGSIZE - (va - va0);
801082e0:	8b 45 ec             	mov    -0x14(%ebp),%eax
801082e3:	2b 45 0c             	sub    0xc(%ebp),%eax
801082e6:	05 00 10 00 00       	add    $0x1000,%eax
801082eb:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(n > len)
801082ee:	8b 45 f0             	mov    -0x10(%ebp),%eax
801082f1:	3b 45 14             	cmp    0x14(%ebp),%eax
801082f4:	76 06                	jbe    801082fc <copyout+0x57>
      n = len;
801082f6:	8b 45 14             	mov    0x14(%ebp),%eax
801082f9:	89 45 f0             	mov    %eax,-0x10(%ebp)
    memmove(pa0 + (va - va0), buf, n);
801082fc:	8b 45 0c             	mov    0xc(%ebp),%eax
801082ff:	2b 45 ec             	sub    -0x14(%ebp),%eax
80108302:	89 c2                	mov    %eax,%edx
80108304:	8b 45 e8             	mov    -0x18(%ebp),%eax
80108307:	01 d0                	add    %edx,%eax
80108309:	83 ec 04             	sub    $0x4,%esp
8010830c:	ff 75 f0             	push   -0x10(%ebp)
8010830f:	ff 75 f4             	push   -0xc(%ebp)
80108312:	50                   	push   %eax
80108313:	e8 ba ce ff ff       	call   801051d2 <memmove>
80108318:	83 c4 10             	add    $0x10,%esp
    len -= n;
8010831b:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010831e:	29 45 14             	sub    %eax,0x14(%ebp)
    buf += n;
80108321:	8b 45 f0             	mov    -0x10(%ebp),%eax
80108324:	01 45 f4             	add    %eax,-0xc(%ebp)
    va = va0 + PGSIZE;
80108327:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010832a:	05 00 10 00 00       	add    $0x1000,%eax
8010832f:	89 45 0c             	mov    %eax,0xc(%ebp)
  while(len > 0){
80108332:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
80108336:	0f 85 77 ff ff ff    	jne    801082b3 <copyout+0xe>
  }
  return 0;
8010833c:	b8 00 00 00 00       	mov    $0x0,%eax
}
80108341:	c9                   	leave  
80108342:	c3                   	ret    

80108343 <mpinit_uefi>:

struct cpu cpus[NCPU];
int ncpu;
uchar ioapicid;
void mpinit_uefi(void)
{
80108343:	55                   	push   %ebp
80108344:	89 e5                	mov    %esp,%ebp
80108346:	83 ec 20             	sub    $0x20,%esp
  struct boot_param *boot_param = (struct boot_param *)P2V_WO(BOOTPARAM);
80108349:	c7 45 f8 00 00 05 80 	movl   $0x80050000,-0x8(%ebp)
  struct uefi_madt *madt = (struct uefi_madt*)(P2V_WO(boot_param->madt_addr));
80108350:	8b 45 f8             	mov    -0x8(%ebp),%eax
80108353:	8b 40 08             	mov    0x8(%eax),%eax
80108356:	05 00 00 00 80       	add    $0x80000000,%eax
8010835b:	89 45 f4             	mov    %eax,-0xc(%ebp)

  uint i=sizeof(struct uefi_madt);
8010835e:	c7 45 fc 2c 00 00 00 	movl   $0x2c,-0x4(%ebp)
  struct uefi_lapic *lapic_entry;
  struct uefi_ioapic *ioapic;
  struct uefi_iso *iso;
  struct uefi_non_maskable_intr *non_mask_intr; 
  
  lapic = (uint *)(madt->lapic_addr);
80108365:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108368:	8b 40 24             	mov    0x24(%eax),%eax
8010836b:	a3 40 71 11 80       	mov    %eax,0x80117140
  ncpu = 0;
80108370:	c7 05 80 9e 11 80 00 	movl   $0x0,0x80119e80
80108377:	00 00 00 

  while(i<madt->len){
8010837a:	90                   	nop
8010837b:	e9 bd 00 00 00       	jmp    8010843d <mpinit_uefi+0xfa>
    uchar *entry_type = ((uchar *)madt)+i;
80108380:	8b 55 f4             	mov    -0xc(%ebp),%edx
80108383:	8b 45 fc             	mov    -0x4(%ebp),%eax
80108386:	01 d0                	add    %edx,%eax
80108388:	89 45 f0             	mov    %eax,-0x10(%ebp)
    switch(*entry_type){
8010838b:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010838e:	0f b6 00             	movzbl (%eax),%eax
80108391:	0f b6 c0             	movzbl %al,%eax
80108394:	83 f8 05             	cmp    $0x5,%eax
80108397:	0f 87 a0 00 00 00    	ja     8010843d <mpinit_uefi+0xfa>
8010839d:	8b 04 85 d8 ad 10 80 	mov    -0x7fef5228(,%eax,4),%eax
801083a4:	ff e0                	jmp    *%eax
      case 0:
        lapic_entry = (struct uefi_lapic *)entry_type;
801083a6:	8b 45 f0             	mov    -0x10(%ebp),%eax
801083a9:	89 45 e0             	mov    %eax,-0x20(%ebp)
        if(ncpu < NCPU) {
801083ac:	a1 80 9e 11 80       	mov    0x80119e80,%eax
801083b1:	83 f8 03             	cmp    $0x3,%eax
801083b4:	7f 28                	jg     801083de <mpinit_uefi+0x9b>
          cpus[ncpu].apicid = lapic_entry->lapic_id;
801083b6:	8b 15 80 9e 11 80    	mov    0x80119e80,%edx
801083bc:	8b 45 e0             	mov    -0x20(%ebp),%eax
801083bf:	0f b6 40 03          	movzbl 0x3(%eax),%eax
801083c3:	69 d2 b0 00 00 00    	imul   $0xb0,%edx,%edx
801083c9:	81 c2 c0 9b 11 80    	add    $0x80119bc0,%edx
801083cf:	88 02                	mov    %al,(%edx)
          ncpu++;
801083d1:	a1 80 9e 11 80       	mov    0x80119e80,%eax
801083d6:	83 c0 01             	add    $0x1,%eax
801083d9:	a3 80 9e 11 80       	mov    %eax,0x80119e80
        }
        i += lapic_entry->record_len;
801083de:	8b 45 e0             	mov    -0x20(%ebp),%eax
801083e1:	0f b6 40 01          	movzbl 0x1(%eax),%eax
801083e5:	0f b6 c0             	movzbl %al,%eax
801083e8:	01 45 fc             	add    %eax,-0x4(%ebp)
        break;
801083eb:	eb 50                	jmp    8010843d <mpinit_uefi+0xfa>

      case 1:
        ioapic = (struct uefi_ioapic *)entry_type;
801083ed:	8b 45 f0             	mov    -0x10(%ebp),%eax
801083f0:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        ioapicid = ioapic->ioapic_id;
801083f3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801083f6:	0f b6 40 02          	movzbl 0x2(%eax),%eax
801083fa:	a2 84 9e 11 80       	mov    %al,0x80119e84
        i += ioapic->record_len;
801083ff:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80108402:	0f b6 40 01          	movzbl 0x1(%eax),%eax
80108406:	0f b6 c0             	movzbl %al,%eax
80108409:	01 45 fc             	add    %eax,-0x4(%ebp)
        break;
8010840c:	eb 2f                	jmp    8010843d <mpinit_uefi+0xfa>

      case 2:
        iso = (struct uefi_iso *)entry_type;
8010840e:	8b 45 f0             	mov    -0x10(%ebp),%eax
80108411:	89 45 e8             	mov    %eax,-0x18(%ebp)
        i += iso->record_len;
80108414:	8b 45 e8             	mov    -0x18(%ebp),%eax
80108417:	0f b6 40 01          	movzbl 0x1(%eax),%eax
8010841b:	0f b6 c0             	movzbl %al,%eax
8010841e:	01 45 fc             	add    %eax,-0x4(%ebp)
        break;
80108421:	eb 1a                	jmp    8010843d <mpinit_uefi+0xfa>

      case 4:
        non_mask_intr = (struct uefi_non_maskable_intr *)entry_type;
80108423:	8b 45 f0             	mov    -0x10(%ebp),%eax
80108426:	89 45 ec             	mov    %eax,-0x14(%ebp)
        i += non_mask_intr->record_len;
80108429:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010842c:	0f b6 40 01          	movzbl 0x1(%eax),%eax
80108430:	0f b6 c0             	movzbl %al,%eax
80108433:	01 45 fc             	add    %eax,-0x4(%ebp)
        break;
80108436:	eb 05                	jmp    8010843d <mpinit_uefi+0xfa>

      case 5:
        i = i + 0xC;
80108438:	83 45 fc 0c          	addl   $0xc,-0x4(%ebp)
        break;
8010843c:	90                   	nop
  while(i<madt->len){
8010843d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108440:	8b 40 04             	mov    0x4(%eax),%eax
80108443:	39 45 fc             	cmp    %eax,-0x4(%ebp)
80108446:	0f 82 34 ff ff ff    	jb     80108380 <mpinit_uefi+0x3d>
    }
  }

}
8010844c:	90                   	nop
8010844d:	90                   	nop
8010844e:	c9                   	leave  
8010844f:	c3                   	ret    

80108450 <inb>:
{
80108450:	55                   	push   %ebp
80108451:	89 e5                	mov    %esp,%ebp
80108453:	83 ec 14             	sub    $0x14,%esp
80108456:	8b 45 08             	mov    0x8(%ebp),%eax
80108459:	66 89 45 ec          	mov    %ax,-0x14(%ebp)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010845d:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
80108461:	89 c2                	mov    %eax,%edx
80108463:	ec                   	in     (%dx),%al
80108464:	88 45 ff             	mov    %al,-0x1(%ebp)
  return data;
80108467:	0f b6 45 ff          	movzbl -0x1(%ebp),%eax
}
8010846b:	c9                   	leave  
8010846c:	c3                   	ret    

8010846d <outb>:
{
8010846d:	55                   	push   %ebp
8010846e:	89 e5                	mov    %esp,%ebp
80108470:	83 ec 08             	sub    $0x8,%esp
80108473:	8b 45 08             	mov    0x8(%ebp),%eax
80108476:	8b 55 0c             	mov    0xc(%ebp),%edx
80108479:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
8010847d:	89 d0                	mov    %edx,%eax
8010847f:	88 45 f8             	mov    %al,-0x8(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80108482:	0f b6 45 f8          	movzbl -0x8(%ebp),%eax
80108486:	0f b7 55 fc          	movzwl -0x4(%ebp),%edx
8010848a:	ee                   	out    %al,(%dx)
}
8010848b:	90                   	nop
8010848c:	c9                   	leave  
8010848d:	c3                   	ret    

8010848e <uart_debug>:
#include "proc.h"
#include "x86.h"

#define COM1    0x3f8

void uart_debug(char p){
8010848e:	55                   	push   %ebp
8010848f:	89 e5                	mov    %esp,%ebp
80108491:	83 ec 28             	sub    $0x28,%esp
80108494:	8b 45 08             	mov    0x8(%ebp),%eax
80108497:	88 45 e4             	mov    %al,-0x1c(%ebp)
    // Turn off the FIFO
  outb(COM1+2, 0);
8010849a:	6a 00                	push   $0x0
8010849c:	68 fa 03 00 00       	push   $0x3fa
801084a1:	e8 c7 ff ff ff       	call   8010846d <outb>
801084a6:	83 c4 08             	add    $0x8,%esp

  // 9600 baud, 8 data bits, 1 stop bit, parity off.
  outb(COM1+3, 0x80);    // Unlock divisor
801084a9:	68 80 00 00 00       	push   $0x80
801084ae:	68 fb 03 00 00       	push   $0x3fb
801084b3:	e8 b5 ff ff ff       	call   8010846d <outb>
801084b8:	83 c4 08             	add    $0x8,%esp
  outb(COM1+0, 115200/9600);
801084bb:	6a 0c                	push   $0xc
801084bd:	68 f8 03 00 00       	push   $0x3f8
801084c2:	e8 a6 ff ff ff       	call   8010846d <outb>
801084c7:	83 c4 08             	add    $0x8,%esp
  outb(COM1+1, 0);
801084ca:	6a 00                	push   $0x0
801084cc:	68 f9 03 00 00       	push   $0x3f9
801084d1:	e8 97 ff ff ff       	call   8010846d <outb>
801084d6:	83 c4 08             	add    $0x8,%esp
  outb(COM1+3, 0x03);    // Lock divisor, 8 data bits.
801084d9:	6a 03                	push   $0x3
801084db:	68 fb 03 00 00       	push   $0x3fb
801084e0:	e8 88 ff ff ff       	call   8010846d <outb>
801084e5:	83 c4 08             	add    $0x8,%esp
  outb(COM1+4, 0);
801084e8:	6a 00                	push   $0x0
801084ea:	68 fc 03 00 00       	push   $0x3fc
801084ef:	e8 79 ff ff ff       	call   8010846d <outb>
801084f4:	83 c4 08             	add    $0x8,%esp

  for(int i=0;i<128 && !(inb(COM1+5) & 0x20); i++) microdelay(10);
801084f7:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
801084fe:	eb 11                	jmp    80108511 <uart_debug+0x83>
80108500:	83 ec 0c             	sub    $0xc,%esp
80108503:	6a 0a                	push   $0xa
80108505:	e8 11 ab ff ff       	call   8010301b <microdelay>
8010850a:	83 c4 10             	add    $0x10,%esp
8010850d:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80108511:	83 7d f4 7f          	cmpl   $0x7f,-0xc(%ebp)
80108515:	7f 1a                	jg     80108531 <uart_debug+0xa3>
80108517:	83 ec 0c             	sub    $0xc,%esp
8010851a:	68 fd 03 00 00       	push   $0x3fd
8010851f:	e8 2c ff ff ff       	call   80108450 <inb>
80108524:	83 c4 10             	add    $0x10,%esp
80108527:	0f b6 c0             	movzbl %al,%eax
8010852a:	83 e0 20             	and    $0x20,%eax
8010852d:	85 c0                	test   %eax,%eax
8010852f:	74 cf                	je     80108500 <uart_debug+0x72>
  outb(COM1+0, p);
80108531:	0f b6 45 e4          	movzbl -0x1c(%ebp),%eax
80108535:	0f b6 c0             	movzbl %al,%eax
80108538:	83 ec 08             	sub    $0x8,%esp
8010853b:	50                   	push   %eax
8010853c:	68 f8 03 00 00       	push   $0x3f8
80108541:	e8 27 ff ff ff       	call   8010846d <outb>
80108546:	83 c4 10             	add    $0x10,%esp
}
80108549:	90                   	nop
8010854a:	c9                   	leave  
8010854b:	c3                   	ret    

8010854c <uart_debugs>:

void uart_debugs(char *p){
8010854c:	55                   	push   %ebp
8010854d:	89 e5                	mov    %esp,%ebp
8010854f:	83 ec 08             	sub    $0x8,%esp
  while(*p){
80108552:	eb 1b                	jmp    8010856f <uart_debugs+0x23>
    uart_debug(*p++);
80108554:	8b 45 08             	mov    0x8(%ebp),%eax
80108557:	8d 50 01             	lea    0x1(%eax),%edx
8010855a:	89 55 08             	mov    %edx,0x8(%ebp)
8010855d:	0f b6 00             	movzbl (%eax),%eax
80108560:	0f be c0             	movsbl %al,%eax
80108563:	83 ec 0c             	sub    $0xc,%esp
80108566:	50                   	push   %eax
80108567:	e8 22 ff ff ff       	call   8010848e <uart_debug>
8010856c:	83 c4 10             	add    $0x10,%esp
  while(*p){
8010856f:	8b 45 08             	mov    0x8(%ebp),%eax
80108572:	0f b6 00             	movzbl (%eax),%eax
80108575:	84 c0                	test   %al,%al
80108577:	75 db                	jne    80108554 <uart_debugs+0x8>
  }
}
80108579:	90                   	nop
8010857a:	90                   	nop
8010857b:	c9                   	leave  
8010857c:	c3                   	ret    

8010857d <graphic_init>:
 * i%4 = 2 : red
 * i%4 = 3 : black
 */

struct gpu gpu;
void graphic_init(){
8010857d:	55                   	push   %ebp
8010857e:	89 e5                	mov    %esp,%ebp
80108580:	83 ec 10             	sub    $0x10,%esp
  struct boot_param *boot_param = (struct boot_param *)P2V_WO(BOOTPARAM);
80108583:	c7 45 fc 00 00 05 80 	movl   $0x80050000,-0x4(%ebp)
  gpu.pvram_addr = boot_param->graphic_config.frame_base;
8010858a:	8b 45 fc             	mov    -0x4(%ebp),%eax
8010858d:	8b 50 14             	mov    0x14(%eax),%edx
80108590:	8b 40 10             	mov    0x10(%eax),%eax
80108593:	a3 88 9e 11 80       	mov    %eax,0x80119e88
  gpu.vram_size = boot_param->graphic_config.frame_size;
80108598:	8b 45 fc             	mov    -0x4(%ebp),%eax
8010859b:	8b 50 1c             	mov    0x1c(%eax),%edx
8010859e:	8b 40 18             	mov    0x18(%eax),%eax
801085a1:	a3 90 9e 11 80       	mov    %eax,0x80119e90
  gpu.vvram_addr = DEVSPACE - gpu.vram_size;
801085a6:	8b 15 90 9e 11 80    	mov    0x80119e90,%edx
801085ac:	b8 00 00 00 fe       	mov    $0xfe000000,%eax
801085b1:	29 d0                	sub    %edx,%eax
801085b3:	a3 8c 9e 11 80       	mov    %eax,0x80119e8c
  gpu.horizontal_resolution = (uint)(boot_param->graphic_config.horizontal_resolution & 0xFFFFFFFF);
801085b8:	8b 45 fc             	mov    -0x4(%ebp),%eax
801085bb:	8b 50 24             	mov    0x24(%eax),%edx
801085be:	8b 40 20             	mov    0x20(%eax),%eax
801085c1:	a3 94 9e 11 80       	mov    %eax,0x80119e94
  gpu.vertical_resolution = (uint)(boot_param->graphic_config.vertical_resolution & 0xFFFFFFFF);
801085c6:	8b 45 fc             	mov    -0x4(%ebp),%eax
801085c9:	8b 50 2c             	mov    0x2c(%eax),%edx
801085cc:	8b 40 28             	mov    0x28(%eax),%eax
801085cf:	a3 98 9e 11 80       	mov    %eax,0x80119e98
  gpu.pixels_per_line = (uint)(boot_param->graphic_config.pixels_per_line & 0xFFFFFFFF);
801085d4:	8b 45 fc             	mov    -0x4(%ebp),%eax
801085d7:	8b 50 34             	mov    0x34(%eax),%edx
801085da:	8b 40 30             	mov    0x30(%eax),%eax
801085dd:	a3 9c 9e 11 80       	mov    %eax,0x80119e9c
}
801085e2:	90                   	nop
801085e3:	c9                   	leave  
801085e4:	c3                   	ret    

801085e5 <graphic_draw_pixel>:

void graphic_draw_pixel(int x,int y,struct graphic_pixel * buffer){
801085e5:	55                   	push   %ebp
801085e6:	89 e5                	mov    %esp,%ebp
801085e8:	83 ec 10             	sub    $0x10,%esp
  int pixel_addr = (sizeof(struct graphic_pixel))*(y*gpu.pixels_per_line + x);
801085eb:	8b 15 9c 9e 11 80    	mov    0x80119e9c,%edx
801085f1:	8b 45 0c             	mov    0xc(%ebp),%eax
801085f4:	0f af d0             	imul   %eax,%edx
801085f7:	8b 45 08             	mov    0x8(%ebp),%eax
801085fa:	01 d0                	add    %edx,%eax
801085fc:	c1 e0 02             	shl    $0x2,%eax
801085ff:	89 45 fc             	mov    %eax,-0x4(%ebp)
  struct graphic_pixel *pixel = (struct graphic_pixel *)(gpu.vvram_addr + pixel_addr);
80108602:	8b 15 8c 9e 11 80    	mov    0x80119e8c,%edx
80108608:	8b 45 fc             	mov    -0x4(%ebp),%eax
8010860b:	01 d0                	add    %edx,%eax
8010860d:	89 45 f8             	mov    %eax,-0x8(%ebp)
  pixel->blue = buffer->blue;
80108610:	8b 45 10             	mov    0x10(%ebp),%eax
80108613:	0f b6 10             	movzbl (%eax),%edx
80108616:	8b 45 f8             	mov    -0x8(%ebp),%eax
80108619:	88 10                	mov    %dl,(%eax)
  pixel->green = buffer->green;
8010861b:	8b 45 10             	mov    0x10(%ebp),%eax
8010861e:	0f b6 50 01          	movzbl 0x1(%eax),%edx
80108622:	8b 45 f8             	mov    -0x8(%ebp),%eax
80108625:	88 50 01             	mov    %dl,0x1(%eax)
  pixel->red = buffer->red;
80108628:	8b 45 10             	mov    0x10(%ebp),%eax
8010862b:	0f b6 50 02          	movzbl 0x2(%eax),%edx
8010862f:	8b 45 f8             	mov    -0x8(%ebp),%eax
80108632:	88 50 02             	mov    %dl,0x2(%eax)
}
80108635:	90                   	nop
80108636:	c9                   	leave  
80108637:	c3                   	ret    

80108638 <graphic_scroll_up>:

void graphic_scroll_up(int height){
80108638:	55                   	push   %ebp
80108639:	89 e5                	mov    %esp,%ebp
8010863b:	83 ec 18             	sub    $0x18,%esp
  int addr_diff = (sizeof(struct graphic_pixel))*gpu.pixels_per_line*height;
8010863e:	8b 15 9c 9e 11 80    	mov    0x80119e9c,%edx
80108644:	8b 45 08             	mov    0x8(%ebp),%eax
80108647:	0f af c2             	imul   %edx,%eax
8010864a:	c1 e0 02             	shl    $0x2,%eax
8010864d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  memmove((unsigned int *)gpu.vvram_addr,(unsigned int *)(gpu.vvram_addr + addr_diff),gpu.vram_size - addr_diff);
80108650:	a1 90 9e 11 80       	mov    0x80119e90,%eax
80108655:	8b 55 f4             	mov    -0xc(%ebp),%edx
80108658:	29 d0                	sub    %edx,%eax
8010865a:	8b 0d 8c 9e 11 80    	mov    0x80119e8c,%ecx
80108660:	8b 55 f4             	mov    -0xc(%ebp),%edx
80108663:	01 ca                	add    %ecx,%edx
80108665:	89 d1                	mov    %edx,%ecx
80108667:	8b 15 8c 9e 11 80    	mov    0x80119e8c,%edx
8010866d:	83 ec 04             	sub    $0x4,%esp
80108670:	50                   	push   %eax
80108671:	51                   	push   %ecx
80108672:	52                   	push   %edx
80108673:	e8 5a cb ff ff       	call   801051d2 <memmove>
80108678:	83 c4 10             	add    $0x10,%esp
  memset((unsigned int *)(gpu.vvram_addr + gpu.vram_size - addr_diff),0,addr_diff);
8010867b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010867e:	8b 0d 8c 9e 11 80    	mov    0x80119e8c,%ecx
80108684:	8b 15 90 9e 11 80    	mov    0x80119e90,%edx
8010868a:	01 ca                	add    %ecx,%edx
8010868c:	8b 4d f4             	mov    -0xc(%ebp),%ecx
8010868f:	29 ca                	sub    %ecx,%edx
80108691:	83 ec 04             	sub    $0x4,%esp
80108694:	50                   	push   %eax
80108695:	6a 00                	push   $0x0
80108697:	52                   	push   %edx
80108698:	e8 76 ca ff ff       	call   80105113 <memset>
8010869d:	83 c4 10             	add    $0x10,%esp
}
801086a0:	90                   	nop
801086a1:	c9                   	leave  
801086a2:	c3                   	ret    

801086a3 <font_render>:
801086a3:	55                   	push   %ebp
801086a4:	89 e5                	mov    %esp,%ebp
801086a6:	53                   	push   %ebx
801086a7:	83 ec 14             	sub    $0x14,%esp
801086aa:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
801086b1:	e9 b1 00 00 00       	jmp    80108767 <font_render+0xc4>
801086b6:	c7 45 f0 0e 00 00 00 	movl   $0xe,-0x10(%ebp)
801086bd:	e9 97 00 00 00       	jmp    80108759 <font_render+0xb6>
801086c2:	8b 45 10             	mov    0x10(%ebp),%eax
801086c5:	83 e8 20             	sub    $0x20,%eax
801086c8:	6b d0 1e             	imul   $0x1e,%eax,%edx
801086cb:	8b 45 f4             	mov    -0xc(%ebp),%eax
801086ce:	01 d0                	add    %edx,%eax
801086d0:	0f b7 84 00 00 ae 10 	movzwl -0x7fef5200(%eax,%eax,1),%eax
801086d7:	80 
801086d8:	0f b7 d0             	movzwl %ax,%edx
801086db:	8b 45 f0             	mov    -0x10(%ebp),%eax
801086de:	bb 01 00 00 00       	mov    $0x1,%ebx
801086e3:	89 c1                	mov    %eax,%ecx
801086e5:	d3 e3                	shl    %cl,%ebx
801086e7:	89 d8                	mov    %ebx,%eax
801086e9:	21 d0                	and    %edx,%eax
801086eb:	89 45 ec             	mov    %eax,-0x14(%ebp)
801086ee:	8b 45 f0             	mov    -0x10(%ebp),%eax
801086f1:	ba 01 00 00 00       	mov    $0x1,%edx
801086f6:	89 c1                	mov    %eax,%ecx
801086f8:	d3 e2                	shl    %cl,%edx
801086fa:	89 d0                	mov    %edx,%eax
801086fc:	39 45 ec             	cmp    %eax,-0x14(%ebp)
801086ff:	75 2b                	jne    8010872c <font_render+0x89>
80108701:	8b 55 0c             	mov    0xc(%ebp),%edx
80108704:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108707:	01 c2                	add    %eax,%edx
80108709:	b8 0e 00 00 00       	mov    $0xe,%eax
8010870e:	2b 45 f0             	sub    -0x10(%ebp),%eax
80108711:	89 c1                	mov    %eax,%ecx
80108713:	8b 45 08             	mov    0x8(%ebp),%eax
80108716:	01 c8                	add    %ecx,%eax
80108718:	83 ec 04             	sub    $0x4,%esp
8010871b:	68 00 f5 10 80       	push   $0x8010f500
80108720:	52                   	push   %edx
80108721:	50                   	push   %eax
80108722:	e8 be fe ff ff       	call   801085e5 <graphic_draw_pixel>
80108727:	83 c4 10             	add    $0x10,%esp
8010872a:	eb 29                	jmp    80108755 <font_render+0xb2>
8010872c:	8b 55 0c             	mov    0xc(%ebp),%edx
8010872f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108732:	01 c2                	add    %eax,%edx
80108734:	b8 0e 00 00 00       	mov    $0xe,%eax
80108739:	2b 45 f0             	sub    -0x10(%ebp),%eax
8010873c:	89 c1                	mov    %eax,%ecx
8010873e:	8b 45 08             	mov    0x8(%ebp),%eax
80108741:	01 c8                	add    %ecx,%eax
80108743:	83 ec 04             	sub    $0x4,%esp
80108746:	68 a0 9e 11 80       	push   $0x80119ea0
8010874b:	52                   	push   %edx
8010874c:	50                   	push   %eax
8010874d:	e8 93 fe ff ff       	call   801085e5 <graphic_draw_pixel>
80108752:	83 c4 10             	add    $0x10,%esp
80108755:	83 6d f0 01          	subl   $0x1,-0x10(%ebp)
80108759:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
8010875d:	0f 89 5f ff ff ff    	jns    801086c2 <font_render+0x1f>
80108763:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80108767:	83 7d f4 1d          	cmpl   $0x1d,-0xc(%ebp)
8010876b:	0f 8e 45 ff ff ff    	jle    801086b6 <font_render+0x13>
80108771:	90                   	nop
80108772:	90                   	nop
80108773:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80108776:	c9                   	leave  
80108777:	c3                   	ret    

80108778 <font_render_string>:
80108778:	55                   	push   %ebp
80108779:	89 e5                	mov    %esp,%ebp
8010877b:	53                   	push   %ebx
8010877c:	83 ec 14             	sub    $0x14,%esp
8010877f:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80108786:	eb 33                	jmp    801087bb <font_render_string+0x43>
80108788:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010878b:	8b 45 08             	mov    0x8(%ebp),%eax
8010878e:	01 d0                	add    %edx,%eax
80108790:	0f b6 00             	movzbl (%eax),%eax
80108793:	0f be c8             	movsbl %al,%ecx
80108796:	8b 45 0c             	mov    0xc(%ebp),%eax
80108799:	6b d0 1e             	imul   $0x1e,%eax,%edx
8010879c:	8b 5d f4             	mov    -0xc(%ebp),%ebx
8010879f:	89 d8                	mov    %ebx,%eax
801087a1:	c1 e0 04             	shl    $0x4,%eax
801087a4:	29 d8                	sub    %ebx,%eax
801087a6:	83 c0 02             	add    $0x2,%eax
801087a9:	83 ec 04             	sub    $0x4,%esp
801087ac:	51                   	push   %ecx
801087ad:	52                   	push   %edx
801087ae:	50                   	push   %eax
801087af:	e8 ef fe ff ff       	call   801086a3 <font_render>
801087b4:	83 c4 10             	add    $0x10,%esp
801087b7:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
801087bb:	8b 55 f4             	mov    -0xc(%ebp),%edx
801087be:	8b 45 08             	mov    0x8(%ebp),%eax
801087c1:	01 d0                	add    %edx,%eax
801087c3:	0f b6 00             	movzbl (%eax),%eax
801087c6:	84 c0                	test   %al,%al
801087c8:	74 06                	je     801087d0 <font_render_string+0x58>
801087ca:	83 7d f4 33          	cmpl   $0x33,-0xc(%ebp)
801087ce:	7e b8                	jle    80108788 <font_render_string+0x10>
801087d0:	90                   	nop
801087d1:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801087d4:	c9                   	leave  
801087d5:	c3                   	ret    

801087d6 <pci_init>:
#include "pci.h"
#include "defs.h"
#include "types.h"
#include "i8254.h"

void pci_init(){
801087d6:	55                   	push   %ebp
801087d7:	89 e5                	mov    %esp,%ebp
801087d9:	53                   	push   %ebx
801087da:	83 ec 14             	sub    $0x14,%esp
  uint data;
  for(int i=0;i<256;i++){
801087dd:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
801087e4:	eb 6b                	jmp    80108851 <pci_init+0x7b>
    for(int j=0;j<32;j++){
801087e6:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
801087ed:	eb 58                	jmp    80108847 <pci_init+0x71>
      for(int k=0;k<8;k++){
801087ef:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
801087f6:	eb 45                	jmp    8010883d <pci_init+0x67>
      pci_access_config(i,j,k,0,&data);
801087f8:	8b 4d ec             	mov    -0x14(%ebp),%ecx
801087fb:	8b 55 f0             	mov    -0x10(%ebp),%edx
801087fe:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108801:	83 ec 0c             	sub    $0xc,%esp
80108804:	8d 5d e8             	lea    -0x18(%ebp),%ebx
80108807:	53                   	push   %ebx
80108808:	6a 00                	push   $0x0
8010880a:	51                   	push   %ecx
8010880b:	52                   	push   %edx
8010880c:	50                   	push   %eax
8010880d:	e8 b0 00 00 00       	call   801088c2 <pci_access_config>
80108812:	83 c4 20             	add    $0x20,%esp
      if((data&0xFFFF) != 0xFFFF){
80108815:	8b 45 e8             	mov    -0x18(%ebp),%eax
80108818:	0f b7 c0             	movzwl %ax,%eax
8010881b:	3d ff ff 00 00       	cmp    $0xffff,%eax
80108820:	74 17                	je     80108839 <pci_init+0x63>
        pci_init_device(i,j,k);
80108822:	8b 4d ec             	mov    -0x14(%ebp),%ecx
80108825:	8b 55 f0             	mov    -0x10(%ebp),%edx
80108828:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010882b:	83 ec 04             	sub    $0x4,%esp
8010882e:	51                   	push   %ecx
8010882f:	52                   	push   %edx
80108830:	50                   	push   %eax
80108831:	e8 37 01 00 00       	call   8010896d <pci_init_device>
80108836:	83 c4 10             	add    $0x10,%esp
      for(int k=0;k<8;k++){
80108839:	83 45 ec 01          	addl   $0x1,-0x14(%ebp)
8010883d:	83 7d ec 07          	cmpl   $0x7,-0x14(%ebp)
80108841:	7e b5                	jle    801087f8 <pci_init+0x22>
    for(int j=0;j<32;j++){
80108843:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
80108847:	83 7d f0 1f          	cmpl   $0x1f,-0x10(%ebp)
8010884b:	7e a2                	jle    801087ef <pci_init+0x19>
  for(int i=0;i<256;i++){
8010884d:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80108851:	81 7d f4 ff 00 00 00 	cmpl   $0xff,-0xc(%ebp)
80108858:	7e 8c                	jle    801087e6 <pci_init+0x10>
      }
      }
    }
  }
}
8010885a:	90                   	nop
8010885b:	90                   	nop
8010885c:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010885f:	c9                   	leave  
80108860:	c3                   	ret    

80108861 <pci_write_config>:

void pci_write_config(uint config){
80108861:	55                   	push   %ebp
80108862:	89 e5                	mov    %esp,%ebp
  asm("mov $0xCF8,%%edx\n\t"
80108864:	8b 45 08             	mov    0x8(%ebp),%eax
80108867:	ba f8 0c 00 00       	mov    $0xcf8,%edx
8010886c:	89 c0                	mov    %eax,%eax
8010886e:	ef                   	out    %eax,(%dx)
      "mov %0,%%eax\n\t"
      "out %%eax,%%dx\n\t"
      : :"r"(config));
}
8010886f:	90                   	nop
80108870:	5d                   	pop    %ebp
80108871:	c3                   	ret    

80108872 <pci_write_data>:

void pci_write_data(uint config){
80108872:	55                   	push   %ebp
80108873:	89 e5                	mov    %esp,%ebp
  asm("mov $0xCFC,%%edx\n\t"
80108875:	8b 45 08             	mov    0x8(%ebp),%eax
80108878:	ba fc 0c 00 00       	mov    $0xcfc,%edx
8010887d:	89 c0                	mov    %eax,%eax
8010887f:	ef                   	out    %eax,(%dx)
      "mov %0,%%eax\n\t"
      "out %%eax,%%dx\n\t"
      : :"r"(config));
}
80108880:	90                   	nop
80108881:	5d                   	pop    %ebp
80108882:	c3                   	ret    

80108883 <pci_read_config>:
uint pci_read_config(){
80108883:	55                   	push   %ebp
80108884:	89 e5                	mov    %esp,%ebp
80108886:	83 ec 18             	sub    $0x18,%esp
  uint data;
  asm("mov $0xCFC,%%edx\n\t"
80108889:	ba fc 0c 00 00       	mov    $0xcfc,%edx
8010888e:	ed                   	in     (%dx),%eax
8010888f:	89 45 f4             	mov    %eax,-0xc(%ebp)
      "in %%dx,%%eax\n\t"
      "mov %%eax,%0"
      :"=m"(data):);
  microdelay(200);
80108892:	83 ec 0c             	sub    $0xc,%esp
80108895:	68 c8 00 00 00       	push   $0xc8
8010889a:	e8 7c a7 ff ff       	call   8010301b <microdelay>
8010889f:	83 c4 10             	add    $0x10,%esp
  return data;
801088a2:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
801088a5:	c9                   	leave  
801088a6:	c3                   	ret    

801088a7 <pci_test>:


void pci_test(){
801088a7:	55                   	push   %ebp
801088a8:	89 e5                	mov    %esp,%ebp
801088aa:	83 ec 10             	sub    $0x10,%esp
  uint data = 0x80001804;
801088ad:	c7 45 fc 04 18 00 80 	movl   $0x80001804,-0x4(%ebp)
  pci_write_config(data);
801088b4:	ff 75 fc             	push   -0x4(%ebp)
801088b7:	e8 a5 ff ff ff       	call   80108861 <pci_write_config>
801088bc:	83 c4 04             	add    $0x4,%esp
}
801088bf:	90                   	nop
801088c0:	c9                   	leave  
801088c1:	c3                   	ret    

801088c2 <pci_access_config>:

void pci_access_config(uint bus_num,uint device_num,uint function_num,uint reg_addr,uint *data){
801088c2:	55                   	push   %ebp
801088c3:	89 e5                	mov    %esp,%ebp
801088c5:	83 ec 18             	sub    $0x18,%esp
  uint config_addr = ((bus_num & 0xFF)<<16) | ((device_num & 0x1F)<<11) | ((function_num & 0x7)<<8) |
801088c8:	8b 45 08             	mov    0x8(%ebp),%eax
801088cb:	c1 e0 10             	shl    $0x10,%eax
801088ce:	25 00 00 ff 00       	and    $0xff0000,%eax
801088d3:	89 c2                	mov    %eax,%edx
801088d5:	8b 45 0c             	mov    0xc(%ebp),%eax
801088d8:	c1 e0 0b             	shl    $0xb,%eax
801088db:	0f b7 c0             	movzwl %ax,%eax
801088de:	09 c2                	or     %eax,%edx
801088e0:	8b 45 10             	mov    0x10(%ebp),%eax
801088e3:	c1 e0 08             	shl    $0x8,%eax
801088e6:	25 00 07 00 00       	and    $0x700,%eax
801088eb:	09 c2                	or     %eax,%edx
    (reg_addr & 0xFC) | 0x80000000;
801088ed:	8b 45 14             	mov    0x14(%ebp),%eax
801088f0:	25 fc 00 00 00       	and    $0xfc,%eax
  uint config_addr = ((bus_num & 0xFF)<<16) | ((device_num & 0x1F)<<11) | ((function_num & 0x7)<<8) |
801088f5:	09 d0                	or     %edx,%eax
801088f7:	0d 00 00 00 80       	or     $0x80000000,%eax
801088fc:	89 45 f4             	mov    %eax,-0xc(%ebp)
  pci_write_config(config_addr);
801088ff:	ff 75 f4             	push   -0xc(%ebp)
80108902:	e8 5a ff ff ff       	call   80108861 <pci_write_config>
80108907:	83 c4 04             	add    $0x4,%esp
  *data = pci_read_config();
8010890a:	e8 74 ff ff ff       	call   80108883 <pci_read_config>
8010890f:	8b 55 18             	mov    0x18(%ebp),%edx
80108912:	89 02                	mov    %eax,(%edx)
}
80108914:	90                   	nop
80108915:	c9                   	leave  
80108916:	c3                   	ret    

80108917 <pci_write_config_register>:

void pci_write_config_register(uint bus_num,uint device_num,uint function_num,uint reg_addr,uint data){
80108917:	55                   	push   %ebp
80108918:	89 e5                	mov    %esp,%ebp
8010891a:	83 ec 10             	sub    $0x10,%esp
  uint config_addr = ((bus_num & 0xFF)<<16) | ((device_num & 0x1F)<<11) | ((function_num & 0x7)<<8) |
8010891d:	8b 45 08             	mov    0x8(%ebp),%eax
80108920:	c1 e0 10             	shl    $0x10,%eax
80108923:	25 00 00 ff 00       	and    $0xff0000,%eax
80108928:	89 c2                	mov    %eax,%edx
8010892a:	8b 45 0c             	mov    0xc(%ebp),%eax
8010892d:	c1 e0 0b             	shl    $0xb,%eax
80108930:	0f b7 c0             	movzwl %ax,%eax
80108933:	09 c2                	or     %eax,%edx
80108935:	8b 45 10             	mov    0x10(%ebp),%eax
80108938:	c1 e0 08             	shl    $0x8,%eax
8010893b:	25 00 07 00 00       	and    $0x700,%eax
80108940:	09 c2                	or     %eax,%edx
    (reg_addr & 0xFC) | 0x80000000;
80108942:	8b 45 14             	mov    0x14(%ebp),%eax
80108945:	25 fc 00 00 00       	and    $0xfc,%eax
  uint config_addr = ((bus_num & 0xFF)<<16) | ((device_num & 0x1F)<<11) | ((function_num & 0x7)<<8) |
8010894a:	09 d0                	or     %edx,%eax
8010894c:	0d 00 00 00 80       	or     $0x80000000,%eax
80108951:	89 45 fc             	mov    %eax,-0x4(%ebp)
  pci_write_config(config_addr);
80108954:	ff 75 fc             	push   -0x4(%ebp)
80108957:	e8 05 ff ff ff       	call   80108861 <pci_write_config>
8010895c:	83 c4 04             	add    $0x4,%esp
  pci_write_data(data);
8010895f:	ff 75 18             	push   0x18(%ebp)
80108962:	e8 0b ff ff ff       	call   80108872 <pci_write_data>
80108967:	83 c4 04             	add    $0x4,%esp
}
8010896a:	90                   	nop
8010896b:	c9                   	leave  
8010896c:	c3                   	ret    

8010896d <pci_init_device>:

struct pci_dev dev;
void pci_init_device(uint bus_num,uint device_num,uint function_num){
8010896d:	55                   	push   %ebp
8010896e:	89 e5                	mov    %esp,%ebp
80108970:	53                   	push   %ebx
80108971:	83 ec 14             	sub    $0x14,%esp
  uint data;
  dev.bus_num = bus_num;
80108974:	8b 45 08             	mov    0x8(%ebp),%eax
80108977:	a2 a4 9e 11 80       	mov    %al,0x80119ea4
  dev.device_num = device_num;
8010897c:	8b 45 0c             	mov    0xc(%ebp),%eax
8010897f:	a2 a5 9e 11 80       	mov    %al,0x80119ea5
  dev.function_num = function_num;
80108984:	8b 45 10             	mov    0x10(%ebp),%eax
80108987:	a2 a6 9e 11 80       	mov    %al,0x80119ea6
  cprintf("PCI Device Found Bus:0x%x Device:0x%x Function:%x\n",bus_num,device_num,function_num);
8010898c:	ff 75 10             	push   0x10(%ebp)
8010898f:	ff 75 0c             	push   0xc(%ebp)
80108992:	ff 75 08             	push   0x8(%ebp)
80108995:	68 44 c4 10 80       	push   $0x8010c444
8010899a:	e8 55 7a ff ff       	call   801003f4 <cprintf>
8010899f:	83 c4 10             	add    $0x10,%esp
  
  pci_access_config(bus_num,device_num,function_num,0,&data);
801089a2:	83 ec 0c             	sub    $0xc,%esp
801089a5:	8d 45 ec             	lea    -0x14(%ebp),%eax
801089a8:	50                   	push   %eax
801089a9:	6a 00                	push   $0x0
801089ab:	ff 75 10             	push   0x10(%ebp)
801089ae:	ff 75 0c             	push   0xc(%ebp)
801089b1:	ff 75 08             	push   0x8(%ebp)
801089b4:	e8 09 ff ff ff       	call   801088c2 <pci_access_config>
801089b9:	83 c4 20             	add    $0x20,%esp
  uint device_id = data>>16;
801089bc:	8b 45 ec             	mov    -0x14(%ebp),%eax
801089bf:	c1 e8 10             	shr    $0x10,%eax
801089c2:	89 45 f4             	mov    %eax,-0xc(%ebp)
  uint vendor_id = data&0xFFFF;
801089c5:	8b 45 ec             	mov    -0x14(%ebp),%eax
801089c8:	25 ff ff 00 00       	and    $0xffff,%eax
801089cd:	89 45 f0             	mov    %eax,-0x10(%ebp)
  dev.device_id = device_id;
801089d0:	8b 45 f4             	mov    -0xc(%ebp),%eax
801089d3:	a3 a8 9e 11 80       	mov    %eax,0x80119ea8
  dev.vendor_id = vendor_id;
801089d8:	8b 45 f0             	mov    -0x10(%ebp),%eax
801089db:	a3 ac 9e 11 80       	mov    %eax,0x80119eac
  cprintf("  Device ID:0x%x  Vendor ID:0x%x\n",device_id,vendor_id);
801089e0:	83 ec 04             	sub    $0x4,%esp
801089e3:	ff 75 f0             	push   -0x10(%ebp)
801089e6:	ff 75 f4             	push   -0xc(%ebp)
801089e9:	68 78 c4 10 80       	push   $0x8010c478
801089ee:	e8 01 7a ff ff       	call   801003f4 <cprintf>
801089f3:	83 c4 10             	add    $0x10,%esp
  
  pci_access_config(bus_num,device_num,function_num,0x8,&data);
801089f6:	83 ec 0c             	sub    $0xc,%esp
801089f9:	8d 45 ec             	lea    -0x14(%ebp),%eax
801089fc:	50                   	push   %eax
801089fd:	6a 08                	push   $0x8
801089ff:	ff 75 10             	push   0x10(%ebp)
80108a02:	ff 75 0c             	push   0xc(%ebp)
80108a05:	ff 75 08             	push   0x8(%ebp)
80108a08:	e8 b5 fe ff ff       	call   801088c2 <pci_access_config>
80108a0d:	83 c4 20             	add    $0x20,%esp
  cprintf("  Base Class:0x%x  Sub Class:0x%x  Interface:0x%x  Revision ID:0x%x\n",
80108a10:	8b 45 ec             	mov    -0x14(%ebp),%eax
80108a13:	0f b6 c8             	movzbl %al,%ecx
      data>>24,(data>>16)&0xFF,(data>>8)&0xFF,data&0xFF);
80108a16:	8b 45 ec             	mov    -0x14(%ebp),%eax
80108a19:	c1 e8 08             	shr    $0x8,%eax
  cprintf("  Base Class:0x%x  Sub Class:0x%x  Interface:0x%x  Revision ID:0x%x\n",
80108a1c:	0f b6 d0             	movzbl %al,%edx
      data>>24,(data>>16)&0xFF,(data>>8)&0xFF,data&0xFF);
80108a1f:	8b 45 ec             	mov    -0x14(%ebp),%eax
80108a22:	c1 e8 10             	shr    $0x10,%eax
  cprintf("  Base Class:0x%x  Sub Class:0x%x  Interface:0x%x  Revision ID:0x%x\n",
80108a25:	0f b6 c0             	movzbl %al,%eax
80108a28:	8b 5d ec             	mov    -0x14(%ebp),%ebx
80108a2b:	c1 eb 18             	shr    $0x18,%ebx
80108a2e:	83 ec 0c             	sub    $0xc,%esp
80108a31:	51                   	push   %ecx
80108a32:	52                   	push   %edx
80108a33:	50                   	push   %eax
80108a34:	53                   	push   %ebx
80108a35:	68 9c c4 10 80       	push   $0x8010c49c
80108a3a:	e8 b5 79 ff ff       	call   801003f4 <cprintf>
80108a3f:	83 c4 20             	add    $0x20,%esp
  dev.base_class = data>>24;
80108a42:	8b 45 ec             	mov    -0x14(%ebp),%eax
80108a45:	c1 e8 18             	shr    $0x18,%eax
80108a48:	a2 b0 9e 11 80       	mov    %al,0x80119eb0
  dev.sub_class = (data>>16)&0xFF;
80108a4d:	8b 45 ec             	mov    -0x14(%ebp),%eax
80108a50:	c1 e8 10             	shr    $0x10,%eax
80108a53:	a2 b1 9e 11 80       	mov    %al,0x80119eb1
  dev.interface = (data>>8)&0xFF;
80108a58:	8b 45 ec             	mov    -0x14(%ebp),%eax
80108a5b:	c1 e8 08             	shr    $0x8,%eax
80108a5e:	a2 b2 9e 11 80       	mov    %al,0x80119eb2
  dev.revision_id = data&0xFF;
80108a63:	8b 45 ec             	mov    -0x14(%ebp),%eax
80108a66:	a2 b3 9e 11 80       	mov    %al,0x80119eb3
  
  pci_access_config(bus_num,device_num,function_num,0x10,&data);
80108a6b:	83 ec 0c             	sub    $0xc,%esp
80108a6e:	8d 45 ec             	lea    -0x14(%ebp),%eax
80108a71:	50                   	push   %eax
80108a72:	6a 10                	push   $0x10
80108a74:	ff 75 10             	push   0x10(%ebp)
80108a77:	ff 75 0c             	push   0xc(%ebp)
80108a7a:	ff 75 08             	push   0x8(%ebp)
80108a7d:	e8 40 fe ff ff       	call   801088c2 <pci_access_config>
80108a82:	83 c4 20             	add    $0x20,%esp
  dev.bar0 = data;
80108a85:	8b 45 ec             	mov    -0x14(%ebp),%eax
80108a88:	a3 b4 9e 11 80       	mov    %eax,0x80119eb4
  pci_access_config(bus_num,device_num,function_num,0x14,&data);
80108a8d:	83 ec 0c             	sub    $0xc,%esp
80108a90:	8d 45 ec             	lea    -0x14(%ebp),%eax
80108a93:	50                   	push   %eax
80108a94:	6a 14                	push   $0x14
80108a96:	ff 75 10             	push   0x10(%ebp)
80108a99:	ff 75 0c             	push   0xc(%ebp)
80108a9c:	ff 75 08             	push   0x8(%ebp)
80108a9f:	e8 1e fe ff ff       	call   801088c2 <pci_access_config>
80108aa4:	83 c4 20             	add    $0x20,%esp
  dev.bar1 = data;
80108aa7:	8b 45 ec             	mov    -0x14(%ebp),%eax
80108aaa:	a3 b8 9e 11 80       	mov    %eax,0x80119eb8
  if(device_id == I8254_DEVICE_ID && vendor_id == I8254_VENDOR_ID){
80108aaf:	81 7d f4 0e 10 00 00 	cmpl   $0x100e,-0xc(%ebp)
80108ab6:	75 5a                	jne    80108b12 <pci_init_device+0x1a5>
80108ab8:	81 7d f0 86 80 00 00 	cmpl   $0x8086,-0x10(%ebp)
80108abf:	75 51                	jne    80108b12 <pci_init_device+0x1a5>
    cprintf("E1000 Ethernet NIC Found\n");
80108ac1:	83 ec 0c             	sub    $0xc,%esp
80108ac4:	68 e1 c4 10 80       	push   $0x8010c4e1
80108ac9:	e8 26 79 ff ff       	call   801003f4 <cprintf>
80108ace:	83 c4 10             	add    $0x10,%esp
    pci_access_config(bus_num,device_num,function_num,0xF0,&data);
80108ad1:	83 ec 0c             	sub    $0xc,%esp
80108ad4:	8d 45 ec             	lea    -0x14(%ebp),%eax
80108ad7:	50                   	push   %eax
80108ad8:	68 f0 00 00 00       	push   $0xf0
80108add:	ff 75 10             	push   0x10(%ebp)
80108ae0:	ff 75 0c             	push   0xc(%ebp)
80108ae3:	ff 75 08             	push   0x8(%ebp)
80108ae6:	e8 d7 fd ff ff       	call   801088c2 <pci_access_config>
80108aeb:	83 c4 20             	add    $0x20,%esp
    cprintf("Message Control:%x\n",data);
80108aee:	8b 45 ec             	mov    -0x14(%ebp),%eax
80108af1:	83 ec 08             	sub    $0x8,%esp
80108af4:	50                   	push   %eax
80108af5:	68 fb c4 10 80       	push   $0x8010c4fb
80108afa:	e8 f5 78 ff ff       	call   801003f4 <cprintf>
80108aff:	83 c4 10             	add    $0x10,%esp
    i8254_init(&dev);
80108b02:	83 ec 0c             	sub    $0xc,%esp
80108b05:	68 a4 9e 11 80       	push   $0x80119ea4
80108b0a:	e8 09 00 00 00       	call   80108b18 <i8254_init>
80108b0f:	83 c4 10             	add    $0x10,%esp
  }
}
80108b12:	90                   	nop
80108b13:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80108b16:	c9                   	leave  
80108b17:	c3                   	ret    

80108b18 <i8254_init>:

uint base_addr;
uchar mac_addr[6] = {0};
uchar my_ip[4] = {10,0,1,10}; 
uint *intr_addr;
void i8254_init(struct pci_dev *dev){
80108b18:	55                   	push   %ebp
80108b19:	89 e5                	mov    %esp,%ebp
80108b1b:	53                   	push   %ebx
80108b1c:	83 ec 14             	sub    $0x14,%esp
  uint cmd_reg;
  //Enable Bus Master
  pci_access_config(dev->bus_num,dev->device_num,dev->function_num,0x04,&cmd_reg);
80108b1f:	8b 45 08             	mov    0x8(%ebp),%eax
80108b22:	0f b6 40 02          	movzbl 0x2(%eax),%eax
80108b26:	0f b6 c8             	movzbl %al,%ecx
80108b29:	8b 45 08             	mov    0x8(%ebp),%eax
80108b2c:	0f b6 40 01          	movzbl 0x1(%eax),%eax
80108b30:	0f b6 d0             	movzbl %al,%edx
80108b33:	8b 45 08             	mov    0x8(%ebp),%eax
80108b36:	0f b6 00             	movzbl (%eax),%eax
80108b39:	0f b6 c0             	movzbl %al,%eax
80108b3c:	83 ec 0c             	sub    $0xc,%esp
80108b3f:	8d 5d ec             	lea    -0x14(%ebp),%ebx
80108b42:	53                   	push   %ebx
80108b43:	6a 04                	push   $0x4
80108b45:	51                   	push   %ecx
80108b46:	52                   	push   %edx
80108b47:	50                   	push   %eax
80108b48:	e8 75 fd ff ff       	call   801088c2 <pci_access_config>
80108b4d:	83 c4 20             	add    $0x20,%esp
  cmd_reg = cmd_reg | PCI_CMD_BUS_MASTER;
80108b50:	8b 45 ec             	mov    -0x14(%ebp),%eax
80108b53:	83 c8 04             	or     $0x4,%eax
80108b56:	89 45 ec             	mov    %eax,-0x14(%ebp)
  pci_write_config_register(dev->bus_num,dev->device_num,dev->function_num,0x04,cmd_reg);
80108b59:	8b 5d ec             	mov    -0x14(%ebp),%ebx
80108b5c:	8b 45 08             	mov    0x8(%ebp),%eax
80108b5f:	0f b6 40 02          	movzbl 0x2(%eax),%eax
80108b63:	0f b6 c8             	movzbl %al,%ecx
80108b66:	8b 45 08             	mov    0x8(%ebp),%eax
80108b69:	0f b6 40 01          	movzbl 0x1(%eax),%eax
80108b6d:	0f b6 d0             	movzbl %al,%edx
80108b70:	8b 45 08             	mov    0x8(%ebp),%eax
80108b73:	0f b6 00             	movzbl (%eax),%eax
80108b76:	0f b6 c0             	movzbl %al,%eax
80108b79:	83 ec 0c             	sub    $0xc,%esp
80108b7c:	53                   	push   %ebx
80108b7d:	6a 04                	push   $0x4
80108b7f:	51                   	push   %ecx
80108b80:	52                   	push   %edx
80108b81:	50                   	push   %eax
80108b82:	e8 90 fd ff ff       	call   80108917 <pci_write_config_register>
80108b87:	83 c4 20             	add    $0x20,%esp
  
  base_addr = PCI_P2V(dev->bar0);
80108b8a:	8b 45 08             	mov    0x8(%ebp),%eax
80108b8d:	8b 40 10             	mov    0x10(%eax),%eax
80108b90:	05 00 00 00 40       	add    $0x40000000,%eax
80108b95:	a3 bc 9e 11 80       	mov    %eax,0x80119ebc
  uint *ctrl = (uint *)base_addr;
80108b9a:	a1 bc 9e 11 80       	mov    0x80119ebc,%eax
80108b9f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  //Disable Interrupts
  uint *imc = (uint *)(base_addr+0xD8);
80108ba2:	a1 bc 9e 11 80       	mov    0x80119ebc,%eax
80108ba7:	05 d8 00 00 00       	add    $0xd8,%eax
80108bac:	89 45 f0             	mov    %eax,-0x10(%ebp)
  *imc = 0xFFFFFFFF;
80108baf:	8b 45 f0             	mov    -0x10(%ebp),%eax
80108bb2:	c7 00 ff ff ff ff    	movl   $0xffffffff,(%eax)
  
  //Reset NIC
  *ctrl = *ctrl | I8254_CTRL_RST;
80108bb8:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108bbb:	8b 00                	mov    (%eax),%eax
80108bbd:	0d 00 00 00 04       	or     $0x4000000,%eax
80108bc2:	89 c2                	mov    %eax,%edx
80108bc4:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108bc7:	89 10                	mov    %edx,(%eax)

  //Enable Interrupts
  *imc = 0xFFFFFFFF;
80108bc9:	8b 45 f0             	mov    -0x10(%ebp),%eax
80108bcc:	c7 00 ff ff ff ff    	movl   $0xffffffff,(%eax)

  //Enable Link
  *ctrl |= I8254_CTRL_SLU;
80108bd2:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108bd5:	8b 00                	mov    (%eax),%eax
80108bd7:	83 c8 40             	or     $0x40,%eax
80108bda:	89 c2                	mov    %eax,%edx
80108bdc:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108bdf:	89 10                	mov    %edx,(%eax)
  
  //General Configuration
  *ctrl &= (~I8254_CTRL_PHY_RST | ~I8254_CTRL_VME | ~I8254_CTRL_ILOS);
80108be1:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108be4:	8b 10                	mov    (%eax),%edx
80108be6:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108be9:	89 10                	mov    %edx,(%eax)
  cprintf("E1000 General Configuration Done\n");
80108beb:	83 ec 0c             	sub    $0xc,%esp
80108bee:	68 10 c5 10 80       	push   $0x8010c510
80108bf3:	e8 fc 77 ff ff       	call   801003f4 <cprintf>
80108bf8:	83 c4 10             	add    $0x10,%esp
  intr_addr = (uint *)kalloc();
80108bfb:	e8 84 a0 ff ff       	call   80102c84 <kalloc>
80108c00:	a3 c8 9e 11 80       	mov    %eax,0x80119ec8
  *intr_addr = 0;
80108c05:	a1 c8 9e 11 80       	mov    0x80119ec8,%eax
80108c0a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  cprintf("INTR_ADDR:%x\n",intr_addr);
80108c10:	a1 c8 9e 11 80       	mov    0x80119ec8,%eax
80108c15:	83 ec 08             	sub    $0x8,%esp
80108c18:	50                   	push   %eax
80108c19:	68 32 c5 10 80       	push   $0x8010c532
80108c1e:	e8 d1 77 ff ff       	call   801003f4 <cprintf>
80108c23:	83 c4 10             	add    $0x10,%esp
  i8254_init_recv();
80108c26:	e8 50 00 00 00       	call   80108c7b <i8254_init_recv>
  i8254_init_send();
80108c2b:	e8 69 03 00 00       	call   80108f99 <i8254_init_send>
  cprintf("IP Address %d.%d.%d.%d\n",
      my_ip[0],
      my_ip[1],
      my_ip[2],
      my_ip[3]);
80108c30:	0f b6 05 07 f5 10 80 	movzbl 0x8010f507,%eax
  cprintf("IP Address %d.%d.%d.%d\n",
80108c37:	0f b6 d8             	movzbl %al,%ebx
      my_ip[2],
80108c3a:	0f b6 05 06 f5 10 80 	movzbl 0x8010f506,%eax
  cprintf("IP Address %d.%d.%d.%d\n",
80108c41:	0f b6 c8             	movzbl %al,%ecx
      my_ip[1],
80108c44:	0f b6 05 05 f5 10 80 	movzbl 0x8010f505,%eax
  cprintf("IP Address %d.%d.%d.%d\n",
80108c4b:	0f b6 d0             	movzbl %al,%edx
      my_ip[0],
80108c4e:	0f b6 05 04 f5 10 80 	movzbl 0x8010f504,%eax
  cprintf("IP Address %d.%d.%d.%d\n",
80108c55:	0f b6 c0             	movzbl %al,%eax
80108c58:	83 ec 0c             	sub    $0xc,%esp
80108c5b:	53                   	push   %ebx
80108c5c:	51                   	push   %ecx
80108c5d:	52                   	push   %edx
80108c5e:	50                   	push   %eax
80108c5f:	68 40 c5 10 80       	push   $0x8010c540
80108c64:	e8 8b 77 ff ff       	call   801003f4 <cprintf>
80108c69:	83 c4 20             	add    $0x20,%esp
  *imc = 0x0;
80108c6c:	8b 45 f0             	mov    -0x10(%ebp),%eax
80108c6f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
}
80108c75:	90                   	nop
80108c76:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80108c79:	c9                   	leave  
80108c7a:	c3                   	ret    

80108c7b <i8254_init_recv>:

void i8254_init_recv(){
80108c7b:	55                   	push   %ebp
80108c7c:	89 e5                	mov    %esp,%ebp
80108c7e:	57                   	push   %edi
80108c7f:	56                   	push   %esi
80108c80:	53                   	push   %ebx
80108c81:	83 ec 6c             	sub    $0x6c,%esp
  
  uint data_l = i8254_read_eeprom(0x0);
80108c84:	83 ec 0c             	sub    $0xc,%esp
80108c87:	6a 00                	push   $0x0
80108c89:	e8 e8 04 00 00       	call   80109176 <i8254_read_eeprom>
80108c8e:	83 c4 10             	add    $0x10,%esp
80108c91:	89 45 d8             	mov    %eax,-0x28(%ebp)
  mac_addr[0] = data_l&0xFF;
80108c94:	8b 45 d8             	mov    -0x28(%ebp),%eax
80108c97:	a2 c0 9e 11 80       	mov    %al,0x80119ec0
  mac_addr[1] = data_l>>8;
80108c9c:	8b 45 d8             	mov    -0x28(%ebp),%eax
80108c9f:	c1 e8 08             	shr    $0x8,%eax
80108ca2:	a2 c1 9e 11 80       	mov    %al,0x80119ec1
  uint data_m = i8254_read_eeprom(0x1);
80108ca7:	83 ec 0c             	sub    $0xc,%esp
80108caa:	6a 01                	push   $0x1
80108cac:	e8 c5 04 00 00       	call   80109176 <i8254_read_eeprom>
80108cb1:	83 c4 10             	add    $0x10,%esp
80108cb4:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  mac_addr[2] = data_m&0xFF;
80108cb7:	8b 45 d4             	mov    -0x2c(%ebp),%eax
80108cba:	a2 c2 9e 11 80       	mov    %al,0x80119ec2
  mac_addr[3] = data_m>>8;
80108cbf:	8b 45 d4             	mov    -0x2c(%ebp),%eax
80108cc2:	c1 e8 08             	shr    $0x8,%eax
80108cc5:	a2 c3 9e 11 80       	mov    %al,0x80119ec3
  uint data_h = i8254_read_eeprom(0x2);
80108cca:	83 ec 0c             	sub    $0xc,%esp
80108ccd:	6a 02                	push   $0x2
80108ccf:	e8 a2 04 00 00       	call   80109176 <i8254_read_eeprom>
80108cd4:	83 c4 10             	add    $0x10,%esp
80108cd7:	89 45 d0             	mov    %eax,-0x30(%ebp)
  mac_addr[4] = data_h&0xFF;
80108cda:	8b 45 d0             	mov    -0x30(%ebp),%eax
80108cdd:	a2 c4 9e 11 80       	mov    %al,0x80119ec4
  mac_addr[5] = data_h>>8;
80108ce2:	8b 45 d0             	mov    -0x30(%ebp),%eax
80108ce5:	c1 e8 08             	shr    $0x8,%eax
80108ce8:	a2 c5 9e 11 80       	mov    %al,0x80119ec5
      mac_addr[0],
      mac_addr[1],
      mac_addr[2],
      mac_addr[3],
      mac_addr[4],
      mac_addr[5]);
80108ced:	0f b6 05 c5 9e 11 80 	movzbl 0x80119ec5,%eax
  cprintf("MAC Address %x:%x:%x:%x:%x:%x\n",
80108cf4:	0f b6 f8             	movzbl %al,%edi
      mac_addr[4],
80108cf7:	0f b6 05 c4 9e 11 80 	movzbl 0x80119ec4,%eax
  cprintf("MAC Address %x:%x:%x:%x:%x:%x\n",
80108cfe:	0f b6 f0             	movzbl %al,%esi
      mac_addr[3],
80108d01:	0f b6 05 c3 9e 11 80 	movzbl 0x80119ec3,%eax
  cprintf("MAC Address %x:%x:%x:%x:%x:%x\n",
80108d08:	0f b6 d8             	movzbl %al,%ebx
      mac_addr[2],
80108d0b:	0f b6 05 c2 9e 11 80 	movzbl 0x80119ec2,%eax
  cprintf("MAC Address %x:%x:%x:%x:%x:%x\n",
80108d12:	0f b6 c8             	movzbl %al,%ecx
      mac_addr[1],
80108d15:	0f b6 05 c1 9e 11 80 	movzbl 0x80119ec1,%eax
  cprintf("MAC Address %x:%x:%x:%x:%x:%x\n",
80108d1c:	0f b6 d0             	movzbl %al,%edx
      mac_addr[0],
80108d1f:	0f b6 05 c0 9e 11 80 	movzbl 0x80119ec0,%eax
  cprintf("MAC Address %x:%x:%x:%x:%x:%x\n",
80108d26:	0f b6 c0             	movzbl %al,%eax
80108d29:	83 ec 04             	sub    $0x4,%esp
80108d2c:	57                   	push   %edi
80108d2d:	56                   	push   %esi
80108d2e:	53                   	push   %ebx
80108d2f:	51                   	push   %ecx
80108d30:	52                   	push   %edx
80108d31:	50                   	push   %eax
80108d32:	68 58 c5 10 80       	push   $0x8010c558
80108d37:	e8 b8 76 ff ff       	call   801003f4 <cprintf>
80108d3c:	83 c4 20             	add    $0x20,%esp

  uint *ral = (uint *)(base_addr + 0x5400);
80108d3f:	a1 bc 9e 11 80       	mov    0x80119ebc,%eax
80108d44:	05 00 54 00 00       	add    $0x5400,%eax
80108d49:	89 45 cc             	mov    %eax,-0x34(%ebp)
  uint *rah = (uint *)(base_addr + 0x5404);
80108d4c:	a1 bc 9e 11 80       	mov    0x80119ebc,%eax
80108d51:	05 04 54 00 00       	add    $0x5404,%eax
80108d56:	89 45 c8             	mov    %eax,-0x38(%ebp)

  *ral = (data_l | (data_m << 16));
80108d59:	8b 45 d4             	mov    -0x2c(%ebp),%eax
80108d5c:	c1 e0 10             	shl    $0x10,%eax
80108d5f:	0b 45 d8             	or     -0x28(%ebp),%eax
80108d62:	89 c2                	mov    %eax,%edx
80108d64:	8b 45 cc             	mov    -0x34(%ebp),%eax
80108d67:	89 10                	mov    %edx,(%eax)
  *rah = (data_h | I8254_RAH_AS_DEST | I8254_RAH_AV);
80108d69:	8b 45 d0             	mov    -0x30(%ebp),%eax
80108d6c:	0d 00 00 00 80       	or     $0x80000000,%eax
80108d71:	89 c2                	mov    %eax,%edx
80108d73:	8b 45 c8             	mov    -0x38(%ebp),%eax
80108d76:	89 10                	mov    %edx,(%eax)

  uint *mta = (uint *)(base_addr + 0x5200);
80108d78:	a1 bc 9e 11 80       	mov    0x80119ebc,%eax
80108d7d:	05 00 52 00 00       	add    $0x5200,%eax
80108d82:	89 45 c4             	mov    %eax,-0x3c(%ebp)
  for(int i=0;i<128;i++){
80108d85:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
80108d8c:	eb 19                	jmp    80108da7 <i8254_init_recv+0x12c>
    mta[i] = 0;
80108d8e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80108d91:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80108d98:	8b 45 c4             	mov    -0x3c(%ebp),%eax
80108d9b:	01 d0                	add    %edx,%eax
80108d9d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  for(int i=0;i<128;i++){
80108da3:	83 45 e4 01          	addl   $0x1,-0x1c(%ebp)
80108da7:	83 7d e4 7f          	cmpl   $0x7f,-0x1c(%ebp)
80108dab:	7e e1                	jle    80108d8e <i8254_init_recv+0x113>
  }

  uint *ims = (uint *)(base_addr + 0xD0);
80108dad:	a1 bc 9e 11 80       	mov    0x80119ebc,%eax
80108db2:	05 d0 00 00 00       	add    $0xd0,%eax
80108db7:	89 45 c0             	mov    %eax,-0x40(%ebp)
  *ims = (I8254_IMS_RXT0 | I8254_IMS_RXDMT0 | I8254_IMS_RXSEQ | I8254_IMS_LSC | I8254_IMS_RXO);
80108dba:	8b 45 c0             	mov    -0x40(%ebp),%eax
80108dbd:	c7 00 dc 00 00 00    	movl   $0xdc,(%eax)
  uint *ics = (uint *)(base_addr + 0xC8);
80108dc3:	a1 bc 9e 11 80       	mov    0x80119ebc,%eax
80108dc8:	05 c8 00 00 00       	add    $0xc8,%eax
80108dcd:	89 45 bc             	mov    %eax,-0x44(%ebp)
  *ics = (I8254_IMS_RXT0 | I8254_IMS_RXDMT0 | I8254_IMS_RXSEQ | I8254_IMS_LSC | I8254_IMS_RXO);
80108dd0:	8b 45 bc             	mov    -0x44(%ebp),%eax
80108dd3:	c7 00 dc 00 00 00    	movl   $0xdc,(%eax)



  uint *rxdctl = (uint *)(base_addr + 0x2828);
80108dd9:	a1 bc 9e 11 80       	mov    0x80119ebc,%eax
80108dde:	05 28 28 00 00       	add    $0x2828,%eax
80108de3:	89 45 b8             	mov    %eax,-0x48(%ebp)
  *rxdctl = 0;
80108de6:	8b 45 b8             	mov    -0x48(%ebp),%eax
80108de9:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

  uint *rctl = (uint *)(base_addr + 0x100);
80108def:	a1 bc 9e 11 80       	mov    0x80119ebc,%eax
80108df4:	05 00 01 00 00       	add    $0x100,%eax
80108df9:	89 45 b4             	mov    %eax,-0x4c(%ebp)
  *rctl = (I8254_RCTL_UPE | I8254_RCTL_MPE | I8254_RCTL_BAM | I8254_RCTL_BSIZE | I8254_RCTL_SECRC);
80108dfc:	8b 45 b4             	mov    -0x4c(%ebp),%eax
80108dff:	c7 00 18 80 00 04    	movl   $0x4008018,(%eax)

  uint recv_desc_addr = (uint)kalloc();
80108e05:	e8 7a 9e ff ff       	call   80102c84 <kalloc>
80108e0a:	89 45 b0             	mov    %eax,-0x50(%ebp)
  uint *rdbal = (uint *)(base_addr + 0x2800);
80108e0d:	a1 bc 9e 11 80       	mov    0x80119ebc,%eax
80108e12:	05 00 28 00 00       	add    $0x2800,%eax
80108e17:	89 45 ac             	mov    %eax,-0x54(%ebp)
  uint *rdbah = (uint *)(base_addr + 0x2804);
80108e1a:	a1 bc 9e 11 80       	mov    0x80119ebc,%eax
80108e1f:	05 04 28 00 00       	add    $0x2804,%eax
80108e24:	89 45 a8             	mov    %eax,-0x58(%ebp)
  uint *rdlen = (uint *)(base_addr + 0x2808);
80108e27:	a1 bc 9e 11 80       	mov    0x80119ebc,%eax
80108e2c:	05 08 28 00 00       	add    $0x2808,%eax
80108e31:	89 45 a4             	mov    %eax,-0x5c(%ebp)
  uint *rdh = (uint *)(base_addr + 0x2810);
80108e34:	a1 bc 9e 11 80       	mov    0x80119ebc,%eax
80108e39:	05 10 28 00 00       	add    $0x2810,%eax
80108e3e:	89 45 a0             	mov    %eax,-0x60(%ebp)
  uint *rdt = (uint *)(base_addr + 0x2818);
80108e41:	a1 bc 9e 11 80       	mov    0x80119ebc,%eax
80108e46:	05 18 28 00 00       	add    $0x2818,%eax
80108e4b:	89 45 9c             	mov    %eax,-0x64(%ebp)

  *rdbal = V2P(recv_desc_addr);
80108e4e:	8b 45 b0             	mov    -0x50(%ebp),%eax
80108e51:	8d 90 00 00 00 80    	lea    -0x80000000(%eax),%edx
80108e57:	8b 45 ac             	mov    -0x54(%ebp),%eax
80108e5a:	89 10                	mov    %edx,(%eax)
  *rdbah = 0;
80108e5c:	8b 45 a8             	mov    -0x58(%ebp),%eax
80108e5f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  *rdlen = sizeof(struct i8254_recv_desc)*I8254_RECV_DESC_NUM;
80108e65:	8b 45 a4             	mov    -0x5c(%ebp),%eax
80108e68:	c7 00 00 10 00 00    	movl   $0x1000,(%eax)
  *rdh = 0;
80108e6e:	8b 45 a0             	mov    -0x60(%ebp),%eax
80108e71:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  *rdt = I8254_RECV_DESC_NUM;
80108e77:	8b 45 9c             	mov    -0x64(%ebp),%eax
80108e7a:	c7 00 00 01 00 00    	movl   $0x100,(%eax)

  struct i8254_recv_desc *recv_desc = (struct i8254_recv_desc *)recv_desc_addr;
80108e80:	8b 45 b0             	mov    -0x50(%ebp),%eax
80108e83:	89 45 98             	mov    %eax,-0x68(%ebp)
  for(int i=0;i<I8254_RECV_DESC_NUM;i++){
80108e86:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
80108e8d:	eb 73                	jmp    80108f02 <i8254_init_recv+0x287>
    recv_desc[i].padding = 0;
80108e8f:	8b 45 e0             	mov    -0x20(%ebp),%eax
80108e92:	c1 e0 04             	shl    $0x4,%eax
80108e95:	89 c2                	mov    %eax,%edx
80108e97:	8b 45 98             	mov    -0x68(%ebp),%eax
80108e9a:	01 d0                	add    %edx,%eax
80108e9c:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
    recv_desc[i].len = 0;
80108ea3:	8b 45 e0             	mov    -0x20(%ebp),%eax
80108ea6:	c1 e0 04             	shl    $0x4,%eax
80108ea9:	89 c2                	mov    %eax,%edx
80108eab:	8b 45 98             	mov    -0x68(%ebp),%eax
80108eae:	01 d0                	add    %edx,%eax
80108eb0:	66 c7 40 08 00 00    	movw   $0x0,0x8(%eax)
    recv_desc[i].chk_sum = 0;
80108eb6:	8b 45 e0             	mov    -0x20(%ebp),%eax
80108eb9:	c1 e0 04             	shl    $0x4,%eax
80108ebc:	89 c2                	mov    %eax,%edx
80108ebe:	8b 45 98             	mov    -0x68(%ebp),%eax
80108ec1:	01 d0                	add    %edx,%eax
80108ec3:	66 c7 40 0a 00 00    	movw   $0x0,0xa(%eax)
    recv_desc[i].status = 0;
80108ec9:	8b 45 e0             	mov    -0x20(%ebp),%eax
80108ecc:	c1 e0 04             	shl    $0x4,%eax
80108ecf:	89 c2                	mov    %eax,%edx
80108ed1:	8b 45 98             	mov    -0x68(%ebp),%eax
80108ed4:	01 d0                	add    %edx,%eax
80108ed6:	c6 40 0c 00          	movb   $0x0,0xc(%eax)
    recv_desc[i].errors = 0;
80108eda:	8b 45 e0             	mov    -0x20(%ebp),%eax
80108edd:	c1 e0 04             	shl    $0x4,%eax
80108ee0:	89 c2                	mov    %eax,%edx
80108ee2:	8b 45 98             	mov    -0x68(%ebp),%eax
80108ee5:	01 d0                	add    %edx,%eax
80108ee7:	c6 40 0d 00          	movb   $0x0,0xd(%eax)
    recv_desc[i].special = 0;
80108eeb:	8b 45 e0             	mov    -0x20(%ebp),%eax
80108eee:	c1 e0 04             	shl    $0x4,%eax
80108ef1:	89 c2                	mov    %eax,%edx
80108ef3:	8b 45 98             	mov    -0x68(%ebp),%eax
80108ef6:	01 d0                	add    %edx,%eax
80108ef8:	66 c7 40 0e 00 00    	movw   $0x0,0xe(%eax)
  for(int i=0;i<I8254_RECV_DESC_NUM;i++){
80108efe:	83 45 e0 01          	addl   $0x1,-0x20(%ebp)
80108f02:	81 7d e0 ff 00 00 00 	cmpl   $0xff,-0x20(%ebp)
80108f09:	7e 84                	jle    80108e8f <i8254_init_recv+0x214>
  }

  for(int i=0;i<(I8254_RECV_DESC_NUM)/2;i++){
80108f0b:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
80108f12:	eb 57                	jmp    80108f6b <i8254_init_recv+0x2f0>
    uint buf_addr = (uint)kalloc();
80108f14:	e8 6b 9d ff ff       	call   80102c84 <kalloc>
80108f19:	89 45 94             	mov    %eax,-0x6c(%ebp)
    if(buf_addr == 0){
80108f1c:	83 7d 94 00          	cmpl   $0x0,-0x6c(%ebp)
80108f20:	75 12                	jne    80108f34 <i8254_init_recv+0x2b9>
      cprintf("failed to allocate buffer area\n");
80108f22:	83 ec 0c             	sub    $0xc,%esp
80108f25:	68 78 c5 10 80       	push   $0x8010c578
80108f2a:	e8 c5 74 ff ff       	call   801003f4 <cprintf>
80108f2f:	83 c4 10             	add    $0x10,%esp
      break;
80108f32:	eb 3d                	jmp    80108f71 <i8254_init_recv+0x2f6>
    }
    recv_desc[i].buf_addr = V2P(buf_addr);
80108f34:	8b 45 dc             	mov    -0x24(%ebp),%eax
80108f37:	c1 e0 04             	shl    $0x4,%eax
80108f3a:	89 c2                	mov    %eax,%edx
80108f3c:	8b 45 98             	mov    -0x68(%ebp),%eax
80108f3f:	01 d0                	add    %edx,%eax
80108f41:	8b 55 94             	mov    -0x6c(%ebp),%edx
80108f44:	81 c2 00 00 00 80    	add    $0x80000000,%edx
80108f4a:	89 10                	mov    %edx,(%eax)
    recv_desc[i+1].buf_addr = V2P(buf_addr + 0x800);
80108f4c:	8b 45 dc             	mov    -0x24(%ebp),%eax
80108f4f:	83 c0 01             	add    $0x1,%eax
80108f52:	c1 e0 04             	shl    $0x4,%eax
80108f55:	89 c2                	mov    %eax,%edx
80108f57:	8b 45 98             	mov    -0x68(%ebp),%eax
80108f5a:	01 d0                	add    %edx,%eax
80108f5c:	8b 55 94             	mov    -0x6c(%ebp),%edx
80108f5f:	81 ea 00 f8 ff 7f    	sub    $0x7ffff800,%edx
80108f65:	89 10                	mov    %edx,(%eax)
  for(int i=0;i<(I8254_RECV_DESC_NUM)/2;i++){
80108f67:	83 45 dc 01          	addl   $0x1,-0x24(%ebp)
80108f6b:	83 7d dc 7f          	cmpl   $0x7f,-0x24(%ebp)
80108f6f:	7e a3                	jle    80108f14 <i8254_init_recv+0x299>
  }

  *rctl |= I8254_RCTL_EN;
80108f71:	8b 45 b4             	mov    -0x4c(%ebp),%eax
80108f74:	8b 00                	mov    (%eax),%eax
80108f76:	83 c8 02             	or     $0x2,%eax
80108f79:	89 c2                	mov    %eax,%edx
80108f7b:	8b 45 b4             	mov    -0x4c(%ebp),%eax
80108f7e:	89 10                	mov    %edx,(%eax)
  cprintf("E1000 Recieve Initialize Done\n");
80108f80:	83 ec 0c             	sub    $0xc,%esp
80108f83:	68 98 c5 10 80       	push   $0x8010c598
80108f88:	e8 67 74 ff ff       	call   801003f4 <cprintf>
80108f8d:	83 c4 10             	add    $0x10,%esp
}
80108f90:	90                   	nop
80108f91:	8d 65 f4             	lea    -0xc(%ebp),%esp
80108f94:	5b                   	pop    %ebx
80108f95:	5e                   	pop    %esi
80108f96:	5f                   	pop    %edi
80108f97:	5d                   	pop    %ebp
80108f98:	c3                   	ret    

80108f99 <i8254_init_send>:

void i8254_init_send(){
80108f99:	55                   	push   %ebp
80108f9a:	89 e5                	mov    %esp,%ebp
80108f9c:	83 ec 48             	sub    $0x48,%esp
  uint *txdctl = (uint *)(base_addr + 0x3828);
80108f9f:	a1 bc 9e 11 80       	mov    0x80119ebc,%eax
80108fa4:	05 28 38 00 00       	add    $0x3828,%eax
80108fa9:	89 45 ec             	mov    %eax,-0x14(%ebp)
  *txdctl = (I8254_TXDCTL_WTHRESH | I8254_TXDCTL_GRAN_DESC);
80108fac:	8b 45 ec             	mov    -0x14(%ebp),%eax
80108faf:	c7 00 00 00 01 01    	movl   $0x1010000,(%eax)

  uint tx_desc_addr = (uint)kalloc();
80108fb5:	e8 ca 9c ff ff       	call   80102c84 <kalloc>
80108fba:	89 45 e8             	mov    %eax,-0x18(%ebp)
  uint *tdbal = (uint *)(base_addr + 0x3800);
80108fbd:	a1 bc 9e 11 80       	mov    0x80119ebc,%eax
80108fc2:	05 00 38 00 00       	add    $0x3800,%eax
80108fc7:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  uint *tdbah = (uint *)(base_addr + 0x3804);
80108fca:	a1 bc 9e 11 80       	mov    0x80119ebc,%eax
80108fcf:	05 04 38 00 00       	add    $0x3804,%eax
80108fd4:	89 45 e0             	mov    %eax,-0x20(%ebp)
  uint *tdlen = (uint *)(base_addr + 0x3808);
80108fd7:	a1 bc 9e 11 80       	mov    0x80119ebc,%eax
80108fdc:	05 08 38 00 00       	add    $0x3808,%eax
80108fe1:	89 45 dc             	mov    %eax,-0x24(%ebp)

  *tdbal = V2P(tx_desc_addr);
80108fe4:	8b 45 e8             	mov    -0x18(%ebp),%eax
80108fe7:	8d 90 00 00 00 80    	lea    -0x80000000(%eax),%edx
80108fed:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80108ff0:	89 10                	mov    %edx,(%eax)
  *tdbah = 0;
80108ff2:	8b 45 e0             	mov    -0x20(%ebp),%eax
80108ff5:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  *tdlen = sizeof(struct i8254_send_desc)*I8254_SEND_DESC_NUM;
80108ffb:	8b 45 dc             	mov    -0x24(%ebp),%eax
80108ffe:	c7 00 00 10 00 00    	movl   $0x1000,(%eax)
  uint *tdh = (uint *)(base_addr + 0x3810);
80109004:	a1 bc 9e 11 80       	mov    0x80119ebc,%eax
80109009:	05 10 38 00 00       	add    $0x3810,%eax
8010900e:	89 45 d8             	mov    %eax,-0x28(%ebp)
  uint *tdt = (uint *)(base_addr + 0x3818);
80109011:	a1 bc 9e 11 80       	mov    0x80119ebc,%eax
80109016:	05 18 38 00 00       	add    $0x3818,%eax
8010901b:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  
  *tdh = 0;
8010901e:	8b 45 d8             	mov    -0x28(%ebp),%eax
80109021:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  *tdt = 0;
80109027:	8b 45 d4             	mov    -0x2c(%ebp),%eax
8010902a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

  struct i8254_send_desc *send_desc = (struct i8254_send_desc *)tx_desc_addr;
80109030:	8b 45 e8             	mov    -0x18(%ebp),%eax
80109033:	89 45 d0             	mov    %eax,-0x30(%ebp)
  for(int i=0;i<I8254_SEND_DESC_NUM;i++){
80109036:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
8010903d:	e9 82 00 00 00       	jmp    801090c4 <i8254_init_send+0x12b>
    send_desc[i].padding = 0;
80109042:	8b 45 f4             	mov    -0xc(%ebp),%eax
80109045:	c1 e0 04             	shl    $0x4,%eax
80109048:	89 c2                	mov    %eax,%edx
8010904a:	8b 45 d0             	mov    -0x30(%ebp),%eax
8010904d:	01 d0                	add    %edx,%eax
8010904f:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
    send_desc[i].len = 0;
80109056:	8b 45 f4             	mov    -0xc(%ebp),%eax
80109059:	c1 e0 04             	shl    $0x4,%eax
8010905c:	89 c2                	mov    %eax,%edx
8010905e:	8b 45 d0             	mov    -0x30(%ebp),%eax
80109061:	01 d0                	add    %edx,%eax
80109063:	66 c7 40 08 00 00    	movw   $0x0,0x8(%eax)
    send_desc[i].cso = 0;
80109069:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010906c:	c1 e0 04             	shl    $0x4,%eax
8010906f:	89 c2                	mov    %eax,%edx
80109071:	8b 45 d0             	mov    -0x30(%ebp),%eax
80109074:	01 d0                	add    %edx,%eax
80109076:	c6 40 0a 00          	movb   $0x0,0xa(%eax)
    send_desc[i].cmd = 0;
8010907a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010907d:	c1 e0 04             	shl    $0x4,%eax
80109080:	89 c2                	mov    %eax,%edx
80109082:	8b 45 d0             	mov    -0x30(%ebp),%eax
80109085:	01 d0                	add    %edx,%eax
80109087:	c6 40 0b 00          	movb   $0x0,0xb(%eax)
    send_desc[i].sta = 0;
8010908b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010908e:	c1 e0 04             	shl    $0x4,%eax
80109091:	89 c2                	mov    %eax,%edx
80109093:	8b 45 d0             	mov    -0x30(%ebp),%eax
80109096:	01 d0                	add    %edx,%eax
80109098:	c6 40 0c 00          	movb   $0x0,0xc(%eax)
    send_desc[i].css = 0;
8010909c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010909f:	c1 e0 04             	shl    $0x4,%eax
801090a2:	89 c2                	mov    %eax,%edx
801090a4:	8b 45 d0             	mov    -0x30(%ebp),%eax
801090a7:	01 d0                	add    %edx,%eax
801090a9:	c6 40 0d 00          	movb   $0x0,0xd(%eax)
    send_desc[i].special = 0;
801090ad:	8b 45 f4             	mov    -0xc(%ebp),%eax
801090b0:	c1 e0 04             	shl    $0x4,%eax
801090b3:	89 c2                	mov    %eax,%edx
801090b5:	8b 45 d0             	mov    -0x30(%ebp),%eax
801090b8:	01 d0                	add    %edx,%eax
801090ba:	66 c7 40 0e 00 00    	movw   $0x0,0xe(%eax)
  for(int i=0;i<I8254_SEND_DESC_NUM;i++){
801090c0:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
801090c4:	81 7d f4 ff 00 00 00 	cmpl   $0xff,-0xc(%ebp)
801090cb:	0f 8e 71 ff ff ff    	jle    80109042 <i8254_init_send+0xa9>
  }

  for(int i=0;i<(I8254_SEND_DESC_NUM)/2;i++){
801090d1:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
801090d8:	eb 57                	jmp    80109131 <i8254_init_send+0x198>
    uint buf_addr = (uint)kalloc();
801090da:	e8 a5 9b ff ff       	call   80102c84 <kalloc>
801090df:	89 45 cc             	mov    %eax,-0x34(%ebp)
    if(buf_addr == 0){
801090e2:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
801090e6:	75 12                	jne    801090fa <i8254_init_send+0x161>
      cprintf("failed to allocate buffer area\n");
801090e8:	83 ec 0c             	sub    $0xc,%esp
801090eb:	68 78 c5 10 80       	push   $0x8010c578
801090f0:	e8 ff 72 ff ff       	call   801003f4 <cprintf>
801090f5:	83 c4 10             	add    $0x10,%esp
      break;
801090f8:	eb 3d                	jmp    80109137 <i8254_init_send+0x19e>
    }
    send_desc[i].buf_addr = V2P(buf_addr);
801090fa:	8b 45 f0             	mov    -0x10(%ebp),%eax
801090fd:	c1 e0 04             	shl    $0x4,%eax
80109100:	89 c2                	mov    %eax,%edx
80109102:	8b 45 d0             	mov    -0x30(%ebp),%eax
80109105:	01 d0                	add    %edx,%eax
80109107:	8b 55 cc             	mov    -0x34(%ebp),%edx
8010910a:	81 c2 00 00 00 80    	add    $0x80000000,%edx
80109110:	89 10                	mov    %edx,(%eax)
    send_desc[i+1].buf_addr = V2P(buf_addr + 0x800);
80109112:	8b 45 f0             	mov    -0x10(%ebp),%eax
80109115:	83 c0 01             	add    $0x1,%eax
80109118:	c1 e0 04             	shl    $0x4,%eax
8010911b:	89 c2                	mov    %eax,%edx
8010911d:	8b 45 d0             	mov    -0x30(%ebp),%eax
80109120:	01 d0                	add    %edx,%eax
80109122:	8b 55 cc             	mov    -0x34(%ebp),%edx
80109125:	81 ea 00 f8 ff 7f    	sub    $0x7ffff800,%edx
8010912b:	89 10                	mov    %edx,(%eax)
  for(int i=0;i<(I8254_SEND_DESC_NUM)/2;i++){
8010912d:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
80109131:	83 7d f0 7f          	cmpl   $0x7f,-0x10(%ebp)
80109135:	7e a3                	jle    801090da <i8254_init_send+0x141>
  }

  uint *tctl = (uint *)(base_addr + 0x400);
80109137:	a1 bc 9e 11 80       	mov    0x80119ebc,%eax
8010913c:	05 00 04 00 00       	add    $0x400,%eax
80109141:	89 45 c8             	mov    %eax,-0x38(%ebp)
  *tctl = (I8254_TCTL_EN | I8254_TCTL_PSP | I8254_TCTL_COLD | I8254_TCTL_CT);
80109144:	8b 45 c8             	mov    -0x38(%ebp),%eax
80109147:	c7 00 fa 00 04 00    	movl   $0x400fa,(%eax)

  uint *tipg = (uint *)(base_addr + 0x410);
8010914d:	a1 bc 9e 11 80       	mov    0x80119ebc,%eax
80109152:	05 10 04 00 00       	add    $0x410,%eax
80109157:	89 45 c4             	mov    %eax,-0x3c(%ebp)
  *tipg = (10 | (10<<10) | (10<<20));
8010915a:	8b 45 c4             	mov    -0x3c(%ebp),%eax
8010915d:	c7 00 0a 28 a0 00    	movl   $0xa0280a,(%eax)
  cprintf("E1000 Transmit Initialize Done\n");
80109163:	83 ec 0c             	sub    $0xc,%esp
80109166:	68 b8 c5 10 80       	push   $0x8010c5b8
8010916b:	e8 84 72 ff ff       	call   801003f4 <cprintf>
80109170:	83 c4 10             	add    $0x10,%esp

}
80109173:	90                   	nop
80109174:	c9                   	leave  
80109175:	c3                   	ret    

80109176 <i8254_read_eeprom>:
uint i8254_read_eeprom(uint addr){
80109176:	55                   	push   %ebp
80109177:	89 e5                	mov    %esp,%ebp
80109179:	83 ec 18             	sub    $0x18,%esp
  uint *eerd = (uint *)(base_addr + 0x14);
8010917c:	a1 bc 9e 11 80       	mov    0x80119ebc,%eax
80109181:	83 c0 14             	add    $0x14,%eax
80109184:	89 45 f4             	mov    %eax,-0xc(%ebp)
  *eerd = (((addr & 0xFF) << 8) | 1);
80109187:	8b 45 08             	mov    0x8(%ebp),%eax
8010918a:	c1 e0 08             	shl    $0x8,%eax
8010918d:	0f b7 c0             	movzwl %ax,%eax
80109190:	83 c8 01             	or     $0x1,%eax
80109193:	89 c2                	mov    %eax,%edx
80109195:	8b 45 f4             	mov    -0xc(%ebp),%eax
80109198:	89 10                	mov    %edx,(%eax)
  while(1){
    cprintf("");
8010919a:	83 ec 0c             	sub    $0xc,%esp
8010919d:	68 d8 c5 10 80       	push   $0x8010c5d8
801091a2:	e8 4d 72 ff ff       	call   801003f4 <cprintf>
801091a7:	83 c4 10             	add    $0x10,%esp
    volatile uint data = *eerd;
801091aa:	8b 45 f4             	mov    -0xc(%ebp),%eax
801091ad:	8b 00                	mov    (%eax),%eax
801091af:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if((data & (1<<4)) != 0){
801091b2:	8b 45 f0             	mov    -0x10(%ebp),%eax
801091b5:	83 e0 10             	and    $0x10,%eax
801091b8:	85 c0                	test   %eax,%eax
801091ba:	75 02                	jne    801091be <i8254_read_eeprom+0x48>
  while(1){
801091bc:	eb dc                	jmp    8010919a <i8254_read_eeprom+0x24>
      break;
801091be:	90                   	nop
    }
  }

  return (*eerd >> 16) & 0xFFFF;
801091bf:	8b 45 f4             	mov    -0xc(%ebp),%eax
801091c2:	8b 00                	mov    (%eax),%eax
801091c4:	c1 e8 10             	shr    $0x10,%eax
}
801091c7:	c9                   	leave  
801091c8:	c3                   	ret    

801091c9 <i8254_recv>:
void i8254_recv(){
801091c9:	55                   	push   %ebp
801091ca:	89 e5                	mov    %esp,%ebp
801091cc:	83 ec 28             	sub    $0x28,%esp
  uint *rdh = (uint *)(base_addr + 0x2810);
801091cf:	a1 bc 9e 11 80       	mov    0x80119ebc,%eax
801091d4:	05 10 28 00 00       	add    $0x2810,%eax
801091d9:	89 45 f4             	mov    %eax,-0xc(%ebp)
  uint *rdt = (uint *)(base_addr + 0x2818);
801091dc:	a1 bc 9e 11 80       	mov    0x80119ebc,%eax
801091e1:	05 18 28 00 00       	add    $0x2818,%eax
801091e6:	89 45 f0             	mov    %eax,-0x10(%ebp)
//  uint *torl = (uint *)(base_addr + 0x40C0);
//  uint *tpr = (uint *)(base_addr + 0x40D0);
//  uint *icr = (uint *)(base_addr + 0xC0);
  uint *rdbal = (uint *)(base_addr + 0x2800);
801091e9:	a1 bc 9e 11 80       	mov    0x80119ebc,%eax
801091ee:	05 00 28 00 00       	add    $0x2800,%eax
801091f3:	89 45 ec             	mov    %eax,-0x14(%ebp)
  struct i8254_recv_desc *recv_desc = (struct i8254_recv_desc *)(P2V(*rdbal));
801091f6:	8b 45 ec             	mov    -0x14(%ebp),%eax
801091f9:	8b 00                	mov    (%eax),%eax
801091fb:	05 00 00 00 80       	add    $0x80000000,%eax
80109200:	89 45 e8             	mov    %eax,-0x18(%ebp)
  while(1){
    int rx_available = (I8254_RECV_DESC_NUM - *rdt + *rdh)%I8254_RECV_DESC_NUM;
80109203:	8b 45 f4             	mov    -0xc(%ebp),%eax
80109206:	8b 10                	mov    (%eax),%edx
80109208:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010920b:	8b 08                	mov    (%eax),%ecx
8010920d:	89 d0                	mov    %edx,%eax
8010920f:	29 c8                	sub    %ecx,%eax
80109211:	25 ff 00 00 00       	and    $0xff,%eax
80109216:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(rx_available > 0){
80109219:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
8010921d:	7e 37                	jle    80109256 <i8254_recv+0x8d>
      uint buffer_addr = P2V_WO(recv_desc[*rdt].buf_addr);
8010921f:	8b 45 f0             	mov    -0x10(%ebp),%eax
80109222:	8b 00                	mov    (%eax),%eax
80109224:	c1 e0 04             	shl    $0x4,%eax
80109227:	89 c2                	mov    %eax,%edx
80109229:	8b 45 e8             	mov    -0x18(%ebp),%eax
8010922c:	01 d0                	add    %edx,%eax
8010922e:	8b 00                	mov    (%eax),%eax
80109230:	05 00 00 00 80       	add    $0x80000000,%eax
80109235:	89 45 e0             	mov    %eax,-0x20(%ebp)
      *rdt = (*rdt + 1)%I8254_RECV_DESC_NUM;
80109238:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010923b:	8b 00                	mov    (%eax),%eax
8010923d:	83 c0 01             	add    $0x1,%eax
80109240:	0f b6 d0             	movzbl %al,%edx
80109243:	8b 45 f0             	mov    -0x10(%ebp),%eax
80109246:	89 10                	mov    %edx,(%eax)
      eth_proc(buffer_addr);
80109248:	83 ec 0c             	sub    $0xc,%esp
8010924b:	ff 75 e0             	push   -0x20(%ebp)
8010924e:	e8 15 09 00 00       	call   80109b68 <eth_proc>
80109253:	83 c4 10             	add    $0x10,%esp
    }
    if(*rdt == *rdh) {
80109256:	8b 45 f0             	mov    -0x10(%ebp),%eax
80109259:	8b 10                	mov    (%eax),%edx
8010925b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010925e:	8b 00                	mov    (%eax),%eax
80109260:	39 c2                	cmp    %eax,%edx
80109262:	75 9f                	jne    80109203 <i8254_recv+0x3a>
      (*rdt)--;
80109264:	8b 45 f0             	mov    -0x10(%ebp),%eax
80109267:	8b 00                	mov    (%eax),%eax
80109269:	8d 50 ff             	lea    -0x1(%eax),%edx
8010926c:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010926f:	89 10                	mov    %edx,(%eax)
  while(1){
80109271:	eb 90                	jmp    80109203 <i8254_recv+0x3a>

80109273 <i8254_send>:
    }
  }
}

int i8254_send(const uint pkt_addr,uint len){
80109273:	55                   	push   %ebp
80109274:	89 e5                	mov    %esp,%ebp
80109276:	83 ec 28             	sub    $0x28,%esp
  uint *tdh = (uint *)(base_addr + 0x3810);
80109279:	a1 bc 9e 11 80       	mov    0x80119ebc,%eax
8010927e:	05 10 38 00 00       	add    $0x3810,%eax
80109283:	89 45 f4             	mov    %eax,-0xc(%ebp)
  uint *tdt = (uint *)(base_addr + 0x3818);
80109286:	a1 bc 9e 11 80       	mov    0x80119ebc,%eax
8010928b:	05 18 38 00 00       	add    $0x3818,%eax
80109290:	89 45 f0             	mov    %eax,-0x10(%ebp)
  uint *tdbal = (uint *)(base_addr + 0x3800);
80109293:	a1 bc 9e 11 80       	mov    0x80119ebc,%eax
80109298:	05 00 38 00 00       	add    $0x3800,%eax
8010929d:	89 45 ec             	mov    %eax,-0x14(%ebp)
  struct i8254_send_desc *txdesc = (struct i8254_send_desc *)P2V_WO(*tdbal);
801092a0:	8b 45 ec             	mov    -0x14(%ebp),%eax
801092a3:	8b 00                	mov    (%eax),%eax
801092a5:	05 00 00 00 80       	add    $0x80000000,%eax
801092aa:	89 45 e8             	mov    %eax,-0x18(%ebp)
  int tx_available = I8254_SEND_DESC_NUM - ((I8254_SEND_DESC_NUM - *tdh + *tdt) % I8254_SEND_DESC_NUM);
801092ad:	8b 45 f0             	mov    -0x10(%ebp),%eax
801092b0:	8b 10                	mov    (%eax),%edx
801092b2:	8b 45 f4             	mov    -0xc(%ebp),%eax
801092b5:	8b 08                	mov    (%eax),%ecx
801092b7:	89 d0                	mov    %edx,%eax
801092b9:	29 c8                	sub    %ecx,%eax
801092bb:	0f b6 d0             	movzbl %al,%edx
801092be:	b8 00 01 00 00       	mov    $0x100,%eax
801092c3:	29 d0                	sub    %edx,%eax
801092c5:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  uint index = *tdt%I8254_SEND_DESC_NUM;
801092c8:	8b 45 f0             	mov    -0x10(%ebp),%eax
801092cb:	8b 00                	mov    (%eax),%eax
801092cd:	25 ff 00 00 00       	and    $0xff,%eax
801092d2:	89 45 e0             	mov    %eax,-0x20(%ebp)
  if(tx_available > 0) {
801092d5:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
801092d9:	0f 8e a8 00 00 00    	jle    80109387 <i8254_send+0x114>
    memmove(P2V_WO((void *)txdesc[index].buf_addr),(void *)pkt_addr,len);
801092df:	8b 45 08             	mov    0x8(%ebp),%eax
801092e2:	8b 55 e0             	mov    -0x20(%ebp),%edx
801092e5:	89 d1                	mov    %edx,%ecx
801092e7:	c1 e1 04             	shl    $0x4,%ecx
801092ea:	8b 55 e8             	mov    -0x18(%ebp),%edx
801092ed:	01 ca                	add    %ecx,%edx
801092ef:	8b 12                	mov    (%edx),%edx
801092f1:	81 c2 00 00 00 80    	add    $0x80000000,%edx
801092f7:	83 ec 04             	sub    $0x4,%esp
801092fa:	ff 75 0c             	push   0xc(%ebp)
801092fd:	50                   	push   %eax
801092fe:	52                   	push   %edx
801092ff:	e8 ce be ff ff       	call   801051d2 <memmove>
80109304:	83 c4 10             	add    $0x10,%esp
    txdesc[index].len = len;
80109307:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010930a:	c1 e0 04             	shl    $0x4,%eax
8010930d:	89 c2                	mov    %eax,%edx
8010930f:	8b 45 e8             	mov    -0x18(%ebp),%eax
80109312:	01 d0                	add    %edx,%eax
80109314:	8b 55 0c             	mov    0xc(%ebp),%edx
80109317:	66 89 50 08          	mov    %dx,0x8(%eax)
    txdesc[index].sta = 0;
8010931b:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010931e:	c1 e0 04             	shl    $0x4,%eax
80109321:	89 c2                	mov    %eax,%edx
80109323:	8b 45 e8             	mov    -0x18(%ebp),%eax
80109326:	01 d0                	add    %edx,%eax
80109328:	c6 40 0c 00          	movb   $0x0,0xc(%eax)
    txdesc[index].css = 0;
8010932c:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010932f:	c1 e0 04             	shl    $0x4,%eax
80109332:	89 c2                	mov    %eax,%edx
80109334:	8b 45 e8             	mov    -0x18(%ebp),%eax
80109337:	01 d0                	add    %edx,%eax
80109339:	c6 40 0d 00          	movb   $0x0,0xd(%eax)
    txdesc[index].cmd = 0xb;
8010933d:	8b 45 e0             	mov    -0x20(%ebp),%eax
80109340:	c1 e0 04             	shl    $0x4,%eax
80109343:	89 c2                	mov    %eax,%edx
80109345:	8b 45 e8             	mov    -0x18(%ebp),%eax
80109348:	01 d0                	add    %edx,%eax
8010934a:	c6 40 0b 0b          	movb   $0xb,0xb(%eax)
    txdesc[index].special = 0;
8010934e:	8b 45 e0             	mov    -0x20(%ebp),%eax
80109351:	c1 e0 04             	shl    $0x4,%eax
80109354:	89 c2                	mov    %eax,%edx
80109356:	8b 45 e8             	mov    -0x18(%ebp),%eax
80109359:	01 d0                	add    %edx,%eax
8010935b:	66 c7 40 0e 00 00    	movw   $0x0,0xe(%eax)
    txdesc[index].cso = 0;
80109361:	8b 45 e0             	mov    -0x20(%ebp),%eax
80109364:	c1 e0 04             	shl    $0x4,%eax
80109367:	89 c2                	mov    %eax,%edx
80109369:	8b 45 e8             	mov    -0x18(%ebp),%eax
8010936c:	01 d0                	add    %edx,%eax
8010936e:	c6 40 0a 00          	movb   $0x0,0xa(%eax)
    *tdt = (*tdt + 1)%I8254_SEND_DESC_NUM;
80109372:	8b 45 f0             	mov    -0x10(%ebp),%eax
80109375:	8b 00                	mov    (%eax),%eax
80109377:	83 c0 01             	add    $0x1,%eax
8010937a:	0f b6 d0             	movzbl %al,%edx
8010937d:	8b 45 f0             	mov    -0x10(%ebp),%eax
80109380:	89 10                	mov    %edx,(%eax)
    return len;
80109382:	8b 45 0c             	mov    0xc(%ebp),%eax
80109385:	eb 05                	jmp    8010938c <i8254_send+0x119>
  }else{
    return -1;
80109387:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  }
  return 0;
}
8010938c:	c9                   	leave  
8010938d:	c3                   	ret    

8010938e <i8254_intr>:

void i8254_intr(){
8010938e:	55                   	push   %ebp
8010938f:	89 e5                	mov    %esp,%ebp
  *intr_addr = 0xEEEEEE;
80109391:	a1 c8 9e 11 80       	mov    0x80119ec8,%eax
80109396:	c7 00 ee ee ee 00    	movl   $0xeeeeee,(%eax)
}
8010939c:	90                   	nop
8010939d:	5d                   	pop    %ebp
8010939e:	c3                   	ret    

8010939f <arp_proc>:
extern uchar mac_addr[6];
extern uchar my_ip[4];

struct arp_entry arp_table[ARP_TABLE_MAX] = {0};

int arp_proc(uint buffer_addr){
8010939f:	55                   	push   %ebp
801093a0:	89 e5                	mov    %esp,%ebp
801093a2:	83 ec 18             	sub    $0x18,%esp
  struct arp_pkt *arp_p = (struct arp_pkt *)(buffer_addr);
801093a5:	8b 45 08             	mov    0x8(%ebp),%eax
801093a8:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(arp_p->hrd_type != ARP_HARDWARE_TYPE) return -1;
801093ab:	8b 45 f4             	mov    -0xc(%ebp),%eax
801093ae:	0f b7 00             	movzwl (%eax),%eax
801093b1:	66 3d 00 01          	cmp    $0x100,%ax
801093b5:	74 0a                	je     801093c1 <arp_proc+0x22>
801093b7:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801093bc:	e9 4f 01 00 00       	jmp    80109510 <arp_proc+0x171>
  if(arp_p->pro_type != ARP_PROTOCOL_TYPE) return -1;
801093c1:	8b 45 f4             	mov    -0xc(%ebp),%eax
801093c4:	0f b7 40 02          	movzwl 0x2(%eax),%eax
801093c8:	66 83 f8 08          	cmp    $0x8,%ax
801093cc:	74 0a                	je     801093d8 <arp_proc+0x39>
801093ce:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801093d3:	e9 38 01 00 00       	jmp    80109510 <arp_proc+0x171>
  if(arp_p->hrd_len != 6) return -1;
801093d8:	8b 45 f4             	mov    -0xc(%ebp),%eax
801093db:	0f b6 40 04          	movzbl 0x4(%eax),%eax
801093df:	3c 06                	cmp    $0x6,%al
801093e1:	74 0a                	je     801093ed <arp_proc+0x4e>
801093e3:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801093e8:	e9 23 01 00 00       	jmp    80109510 <arp_proc+0x171>
  if(arp_p->pro_len != 4) return -1;
801093ed:	8b 45 f4             	mov    -0xc(%ebp),%eax
801093f0:	0f b6 40 05          	movzbl 0x5(%eax),%eax
801093f4:	3c 04                	cmp    $0x4,%al
801093f6:	74 0a                	je     80109402 <arp_proc+0x63>
801093f8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801093fd:	e9 0e 01 00 00       	jmp    80109510 <arp_proc+0x171>
  if(memcmp(my_ip,arp_p->dst_ip,4) != 0 && memcmp(my_ip,arp_p->src_ip,4) != 0) return -1;
80109402:	8b 45 f4             	mov    -0xc(%ebp),%eax
80109405:	83 c0 18             	add    $0x18,%eax
80109408:	83 ec 04             	sub    $0x4,%esp
8010940b:	6a 04                	push   $0x4
8010940d:	50                   	push   %eax
8010940e:	68 04 f5 10 80       	push   $0x8010f504
80109413:	e8 62 bd ff ff       	call   8010517a <memcmp>
80109418:	83 c4 10             	add    $0x10,%esp
8010941b:	85 c0                	test   %eax,%eax
8010941d:	74 27                	je     80109446 <arp_proc+0xa7>
8010941f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80109422:	83 c0 0e             	add    $0xe,%eax
80109425:	83 ec 04             	sub    $0x4,%esp
80109428:	6a 04                	push   $0x4
8010942a:	50                   	push   %eax
8010942b:	68 04 f5 10 80       	push   $0x8010f504
80109430:	e8 45 bd ff ff       	call   8010517a <memcmp>
80109435:	83 c4 10             	add    $0x10,%esp
80109438:	85 c0                	test   %eax,%eax
8010943a:	74 0a                	je     80109446 <arp_proc+0xa7>
8010943c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80109441:	e9 ca 00 00 00       	jmp    80109510 <arp_proc+0x171>
  if(arp_p->op == ARP_OPS_REQUEST && memcmp(my_ip,arp_p->dst_ip,4) == 0){
80109446:	8b 45 f4             	mov    -0xc(%ebp),%eax
80109449:	0f b7 40 06          	movzwl 0x6(%eax),%eax
8010944d:	66 3d 00 01          	cmp    $0x100,%ax
80109451:	75 69                	jne    801094bc <arp_proc+0x11d>
80109453:	8b 45 f4             	mov    -0xc(%ebp),%eax
80109456:	83 c0 18             	add    $0x18,%eax
80109459:	83 ec 04             	sub    $0x4,%esp
8010945c:	6a 04                	push   $0x4
8010945e:	50                   	push   %eax
8010945f:	68 04 f5 10 80       	push   $0x8010f504
80109464:	e8 11 bd ff ff       	call   8010517a <memcmp>
80109469:	83 c4 10             	add    $0x10,%esp
8010946c:	85 c0                	test   %eax,%eax
8010946e:	75 4c                	jne    801094bc <arp_proc+0x11d>
    uint send = (uint)kalloc();
80109470:	e8 0f 98 ff ff       	call   80102c84 <kalloc>
80109475:	89 45 f0             	mov    %eax,-0x10(%ebp)
    uint send_size=0;
80109478:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
    arp_reply_pkt_create(arp_p,send,&send_size);
8010947f:	83 ec 04             	sub    $0x4,%esp
80109482:	8d 45 ec             	lea    -0x14(%ebp),%eax
80109485:	50                   	push   %eax
80109486:	ff 75 f0             	push   -0x10(%ebp)
80109489:	ff 75 f4             	push   -0xc(%ebp)
8010948c:	e8 1f 04 00 00       	call   801098b0 <arp_reply_pkt_create>
80109491:	83 c4 10             	add    $0x10,%esp
    i8254_send(send,send_size);
80109494:	8b 45 ec             	mov    -0x14(%ebp),%eax
80109497:	83 ec 08             	sub    $0x8,%esp
8010949a:	50                   	push   %eax
8010949b:	ff 75 f0             	push   -0x10(%ebp)
8010949e:	e8 d0 fd ff ff       	call   80109273 <i8254_send>
801094a3:	83 c4 10             	add    $0x10,%esp
    kfree((char *)send);
801094a6:	8b 45 f0             	mov    -0x10(%ebp),%eax
801094a9:	83 ec 0c             	sub    $0xc,%esp
801094ac:	50                   	push   %eax
801094ad:	e8 38 97 ff ff       	call   80102bea <kfree>
801094b2:	83 c4 10             	add    $0x10,%esp
    return ARP_CREATED_REPLY;
801094b5:	b8 02 00 00 00       	mov    $0x2,%eax
801094ba:	eb 54                	jmp    80109510 <arp_proc+0x171>
  }else if(arp_p->op == ARP_OPS_REPLY && memcmp(my_ip,arp_p->dst_ip,4) == 0){
801094bc:	8b 45 f4             	mov    -0xc(%ebp),%eax
801094bf:	0f b7 40 06          	movzwl 0x6(%eax),%eax
801094c3:	66 3d 00 02          	cmp    $0x200,%ax
801094c7:	75 42                	jne    8010950b <arp_proc+0x16c>
801094c9:	8b 45 f4             	mov    -0xc(%ebp),%eax
801094cc:	83 c0 18             	add    $0x18,%eax
801094cf:	83 ec 04             	sub    $0x4,%esp
801094d2:	6a 04                	push   $0x4
801094d4:	50                   	push   %eax
801094d5:	68 04 f5 10 80       	push   $0x8010f504
801094da:	e8 9b bc ff ff       	call   8010517a <memcmp>
801094df:	83 c4 10             	add    $0x10,%esp
801094e2:	85 c0                	test   %eax,%eax
801094e4:	75 25                	jne    8010950b <arp_proc+0x16c>
    cprintf("ARP TABLE UPDATED\n");
801094e6:	83 ec 0c             	sub    $0xc,%esp
801094e9:	68 dc c5 10 80       	push   $0x8010c5dc
801094ee:	e8 01 6f ff ff       	call   801003f4 <cprintf>
801094f3:	83 c4 10             	add    $0x10,%esp
    arp_table_update(arp_p);
801094f6:	83 ec 0c             	sub    $0xc,%esp
801094f9:	ff 75 f4             	push   -0xc(%ebp)
801094fc:	e8 af 01 00 00       	call   801096b0 <arp_table_update>
80109501:	83 c4 10             	add    $0x10,%esp
    return ARP_UPDATED_TABLE;
80109504:	b8 01 00 00 00       	mov    $0x1,%eax
80109509:	eb 05                	jmp    80109510 <arp_proc+0x171>
  }else{
    return -1;
8010950b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  }
}
80109510:	c9                   	leave  
80109511:	c3                   	ret    

80109512 <arp_scan>:

void arp_scan(){
80109512:	55                   	push   %ebp
80109513:	89 e5                	mov    %esp,%ebp
80109515:	83 ec 18             	sub    $0x18,%esp
  uint send_size;
  for(int i=0;i<256;i++){
80109518:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
8010951f:	eb 6f                	jmp    80109590 <arp_scan+0x7e>
    uint send = (uint)kalloc();
80109521:	e8 5e 97 ff ff       	call   80102c84 <kalloc>
80109526:	89 45 ec             	mov    %eax,-0x14(%ebp)
    arp_broadcast(send,&send_size,i);
80109529:	83 ec 04             	sub    $0x4,%esp
8010952c:	ff 75 f4             	push   -0xc(%ebp)
8010952f:	8d 45 e8             	lea    -0x18(%ebp),%eax
80109532:	50                   	push   %eax
80109533:	ff 75 ec             	push   -0x14(%ebp)
80109536:	e8 62 00 00 00       	call   8010959d <arp_broadcast>
8010953b:	83 c4 10             	add    $0x10,%esp
    uint res = i8254_send(send,send_size);
8010953e:	8b 45 e8             	mov    -0x18(%ebp),%eax
80109541:	83 ec 08             	sub    $0x8,%esp
80109544:	50                   	push   %eax
80109545:	ff 75 ec             	push   -0x14(%ebp)
80109548:	e8 26 fd ff ff       	call   80109273 <i8254_send>
8010954d:	83 c4 10             	add    $0x10,%esp
80109550:	89 45 f0             	mov    %eax,-0x10(%ebp)
    while(res == -1){
80109553:	eb 22                	jmp    80109577 <arp_scan+0x65>
      microdelay(1);
80109555:	83 ec 0c             	sub    $0xc,%esp
80109558:	6a 01                	push   $0x1
8010955a:	e8 bc 9a ff ff       	call   8010301b <microdelay>
8010955f:	83 c4 10             	add    $0x10,%esp
      res = i8254_send(send,send_size);
80109562:	8b 45 e8             	mov    -0x18(%ebp),%eax
80109565:	83 ec 08             	sub    $0x8,%esp
80109568:	50                   	push   %eax
80109569:	ff 75 ec             	push   -0x14(%ebp)
8010956c:	e8 02 fd ff ff       	call   80109273 <i8254_send>
80109571:	83 c4 10             	add    $0x10,%esp
80109574:	89 45 f0             	mov    %eax,-0x10(%ebp)
    while(res == -1){
80109577:	83 7d f0 ff          	cmpl   $0xffffffff,-0x10(%ebp)
8010957b:	74 d8                	je     80109555 <arp_scan+0x43>
    }
    kfree((char *)send);
8010957d:	8b 45 ec             	mov    -0x14(%ebp),%eax
80109580:	83 ec 0c             	sub    $0xc,%esp
80109583:	50                   	push   %eax
80109584:	e8 61 96 ff ff       	call   80102bea <kfree>
80109589:	83 c4 10             	add    $0x10,%esp
  for(int i=0;i<256;i++){
8010958c:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80109590:	81 7d f4 ff 00 00 00 	cmpl   $0xff,-0xc(%ebp)
80109597:	7e 88                	jle    80109521 <arp_scan+0xf>
  }
}
80109599:	90                   	nop
8010959a:	90                   	nop
8010959b:	c9                   	leave  
8010959c:	c3                   	ret    

8010959d <arp_broadcast>:

void arp_broadcast(uint send,uint *send_size,uint ip){
8010959d:	55                   	push   %ebp
8010959e:	89 e5                	mov    %esp,%ebp
801095a0:	83 ec 28             	sub    $0x28,%esp
  uchar dst_ip[4] = {10,0,1,ip};
801095a3:	c6 45 ec 0a          	movb   $0xa,-0x14(%ebp)
801095a7:	c6 45 ed 00          	movb   $0x0,-0x13(%ebp)
801095ab:	c6 45 ee 01          	movb   $0x1,-0x12(%ebp)
801095af:	8b 45 10             	mov    0x10(%ebp),%eax
801095b2:	88 45 ef             	mov    %al,-0x11(%ebp)
  uchar dst_mac_eth[6] = {0xff,0xff,0xff,0xff,0xff,0xff};
801095b5:	c7 45 e6 ff ff ff ff 	movl   $0xffffffff,-0x1a(%ebp)
801095bc:	66 c7 45 ea ff ff    	movw   $0xffff,-0x16(%ebp)
  uchar dst_mac_arp[6] = {0,0,0,0,0,0};
801095c2:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
801095c9:	66 c7 45 e4 00 00    	movw   $0x0,-0x1c(%ebp)
  
  *send_size = sizeof(struct eth_pkt) + sizeof(struct arp_pkt);
801095cf:	8b 45 0c             	mov    0xc(%ebp),%eax
801095d2:	c7 00 2c 00 00 00    	movl   $0x2c,(%eax)

  struct eth_pkt *reply_eth = (struct eth_pkt *)send;
801095d8:	8b 45 08             	mov    0x8(%ebp),%eax
801095db:	89 45 f4             	mov    %eax,-0xc(%ebp)
  struct arp_pkt *reply_arp = (struct arp_pkt *)(send + sizeof(struct eth_pkt));
801095de:	8b 45 08             	mov    0x8(%ebp),%eax
801095e1:	83 c0 0e             	add    $0xe,%eax
801095e4:	89 45 f0             	mov    %eax,-0x10(%ebp)
  
  reply_eth->type[0] = 0x08;
801095e7:	8b 45 f4             	mov    -0xc(%ebp),%eax
801095ea:	c6 40 0c 08          	movb   $0x8,0xc(%eax)
  reply_eth->type[1] = 0x06;
801095ee:	8b 45 f4             	mov    -0xc(%ebp),%eax
801095f1:	c6 40 0d 06          	movb   $0x6,0xd(%eax)
  memmove(reply_eth->dst_mac,dst_mac_eth,6);
801095f5:	8b 45 f4             	mov    -0xc(%ebp),%eax
801095f8:	83 ec 04             	sub    $0x4,%esp
801095fb:	6a 06                	push   $0x6
801095fd:	8d 55 e6             	lea    -0x1a(%ebp),%edx
80109600:	52                   	push   %edx
80109601:	50                   	push   %eax
80109602:	e8 cb bb ff ff       	call   801051d2 <memmove>
80109607:	83 c4 10             	add    $0x10,%esp
  memmove(reply_eth->src_mac,mac_addr,6);
8010960a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010960d:	83 c0 06             	add    $0x6,%eax
80109610:	83 ec 04             	sub    $0x4,%esp
80109613:	6a 06                	push   $0x6
80109615:	68 c0 9e 11 80       	push   $0x80119ec0
8010961a:	50                   	push   %eax
8010961b:	e8 b2 bb ff ff       	call   801051d2 <memmove>
80109620:	83 c4 10             	add    $0x10,%esp

  reply_arp->hrd_type = ARP_HARDWARE_TYPE;
80109623:	8b 45 f0             	mov    -0x10(%ebp),%eax
80109626:	66 c7 00 00 01       	movw   $0x100,(%eax)
  reply_arp->pro_type = ARP_PROTOCOL_TYPE;
8010962b:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010962e:	66 c7 40 02 08 00    	movw   $0x8,0x2(%eax)
  reply_arp->hrd_len = 6;
80109634:	8b 45 f0             	mov    -0x10(%ebp),%eax
80109637:	c6 40 04 06          	movb   $0x6,0x4(%eax)
  reply_arp->pro_len = 4;
8010963b:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010963e:	c6 40 05 04          	movb   $0x4,0x5(%eax)
  reply_arp->op = ARP_OPS_REQUEST;
80109642:	8b 45 f0             	mov    -0x10(%ebp),%eax
80109645:	66 c7 40 06 00 01    	movw   $0x100,0x6(%eax)
  memmove(reply_arp->dst_mac,dst_mac_arp,6);
8010964b:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010964e:	8d 50 12             	lea    0x12(%eax),%edx
80109651:	83 ec 04             	sub    $0x4,%esp
80109654:	6a 06                	push   $0x6
80109656:	8d 45 e0             	lea    -0x20(%ebp),%eax
80109659:	50                   	push   %eax
8010965a:	52                   	push   %edx
8010965b:	e8 72 bb ff ff       	call   801051d2 <memmove>
80109660:	83 c4 10             	add    $0x10,%esp
  memmove(reply_arp->dst_ip,dst_ip,4);
80109663:	8b 45 f0             	mov    -0x10(%ebp),%eax
80109666:	8d 50 18             	lea    0x18(%eax),%edx
80109669:	83 ec 04             	sub    $0x4,%esp
8010966c:	6a 04                	push   $0x4
8010966e:	8d 45 ec             	lea    -0x14(%ebp),%eax
80109671:	50                   	push   %eax
80109672:	52                   	push   %edx
80109673:	e8 5a bb ff ff       	call   801051d2 <memmove>
80109678:	83 c4 10             	add    $0x10,%esp
  memmove(reply_arp->src_mac,mac_addr,6);
8010967b:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010967e:	83 c0 08             	add    $0x8,%eax
80109681:	83 ec 04             	sub    $0x4,%esp
80109684:	6a 06                	push   $0x6
80109686:	68 c0 9e 11 80       	push   $0x80119ec0
8010968b:	50                   	push   %eax
8010968c:	e8 41 bb ff ff       	call   801051d2 <memmove>
80109691:	83 c4 10             	add    $0x10,%esp
  memmove(reply_arp->src_ip,my_ip,4);
80109694:	8b 45 f0             	mov    -0x10(%ebp),%eax
80109697:	83 c0 0e             	add    $0xe,%eax
8010969a:	83 ec 04             	sub    $0x4,%esp
8010969d:	6a 04                	push   $0x4
8010969f:	68 04 f5 10 80       	push   $0x8010f504
801096a4:	50                   	push   %eax
801096a5:	e8 28 bb ff ff       	call   801051d2 <memmove>
801096aa:	83 c4 10             	add    $0x10,%esp
}
801096ad:	90                   	nop
801096ae:	c9                   	leave  
801096af:	c3                   	ret    

801096b0 <arp_table_update>:

void arp_table_update(struct arp_pkt *recv_arp){
801096b0:	55                   	push   %ebp
801096b1:	89 e5                	mov    %esp,%ebp
801096b3:	83 ec 18             	sub    $0x18,%esp
  int index = arp_table_search(recv_arp->src_ip);
801096b6:	8b 45 08             	mov    0x8(%ebp),%eax
801096b9:	83 c0 0e             	add    $0xe,%eax
801096bc:	83 ec 0c             	sub    $0xc,%esp
801096bf:	50                   	push   %eax
801096c0:	e8 bc 00 00 00       	call   80109781 <arp_table_search>
801096c5:	83 c4 10             	add    $0x10,%esp
801096c8:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(index > -1){
801096cb:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801096cf:	78 2d                	js     801096fe <arp_table_update+0x4e>
    memmove(arp_table[index].mac,recv_arp->src_mac,6);
801096d1:	8b 45 08             	mov    0x8(%ebp),%eax
801096d4:	8d 48 08             	lea    0x8(%eax),%ecx
801096d7:	8b 55 f4             	mov    -0xc(%ebp),%edx
801096da:	89 d0                	mov    %edx,%eax
801096dc:	c1 e0 02             	shl    $0x2,%eax
801096df:	01 d0                	add    %edx,%eax
801096e1:	01 c0                	add    %eax,%eax
801096e3:	01 d0                	add    %edx,%eax
801096e5:	05 e0 9e 11 80       	add    $0x80119ee0,%eax
801096ea:	83 c0 04             	add    $0x4,%eax
801096ed:	83 ec 04             	sub    $0x4,%esp
801096f0:	6a 06                	push   $0x6
801096f2:	51                   	push   %ecx
801096f3:	50                   	push   %eax
801096f4:	e8 d9 ba ff ff       	call   801051d2 <memmove>
801096f9:	83 c4 10             	add    $0x10,%esp
801096fc:	eb 70                	jmp    8010976e <arp_table_update+0xbe>
  }else{
    index += 1;
801096fe:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
    index = -index;
80109702:	f7 5d f4             	negl   -0xc(%ebp)
    memmove(arp_table[index].mac,recv_arp->src_mac,6);
80109705:	8b 45 08             	mov    0x8(%ebp),%eax
80109708:	8d 48 08             	lea    0x8(%eax),%ecx
8010970b:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010970e:	89 d0                	mov    %edx,%eax
80109710:	c1 e0 02             	shl    $0x2,%eax
80109713:	01 d0                	add    %edx,%eax
80109715:	01 c0                	add    %eax,%eax
80109717:	01 d0                	add    %edx,%eax
80109719:	05 e0 9e 11 80       	add    $0x80119ee0,%eax
8010971e:	83 c0 04             	add    $0x4,%eax
80109721:	83 ec 04             	sub    $0x4,%esp
80109724:	6a 06                	push   $0x6
80109726:	51                   	push   %ecx
80109727:	50                   	push   %eax
80109728:	e8 a5 ba ff ff       	call   801051d2 <memmove>
8010972d:	83 c4 10             	add    $0x10,%esp
    memmove(arp_table[index].ip,recv_arp->src_ip,4);
80109730:	8b 45 08             	mov    0x8(%ebp),%eax
80109733:	8d 48 0e             	lea    0xe(%eax),%ecx
80109736:	8b 55 f4             	mov    -0xc(%ebp),%edx
80109739:	89 d0                	mov    %edx,%eax
8010973b:	c1 e0 02             	shl    $0x2,%eax
8010973e:	01 d0                	add    %edx,%eax
80109740:	01 c0                	add    %eax,%eax
80109742:	01 d0                	add    %edx,%eax
80109744:	05 e0 9e 11 80       	add    $0x80119ee0,%eax
80109749:	83 ec 04             	sub    $0x4,%esp
8010974c:	6a 04                	push   $0x4
8010974e:	51                   	push   %ecx
8010974f:	50                   	push   %eax
80109750:	e8 7d ba ff ff       	call   801051d2 <memmove>
80109755:	83 c4 10             	add    $0x10,%esp
    arp_table[index].use = 1;
80109758:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010975b:	89 d0                	mov    %edx,%eax
8010975d:	c1 e0 02             	shl    $0x2,%eax
80109760:	01 d0                	add    %edx,%eax
80109762:	01 c0                	add    %eax,%eax
80109764:	01 d0                	add    %edx,%eax
80109766:	05 ea 9e 11 80       	add    $0x80119eea,%eax
8010976b:	c6 00 01             	movb   $0x1,(%eax)
  }
  print_arp_table(arp_table);
8010976e:	83 ec 0c             	sub    $0xc,%esp
80109771:	68 e0 9e 11 80       	push   $0x80119ee0
80109776:	e8 83 00 00 00       	call   801097fe <print_arp_table>
8010977b:	83 c4 10             	add    $0x10,%esp
}
8010977e:	90                   	nop
8010977f:	c9                   	leave  
80109780:	c3                   	ret    

80109781 <arp_table_search>:

int arp_table_search(uchar *ip){
80109781:	55                   	push   %ebp
80109782:	89 e5                	mov    %esp,%ebp
80109784:	83 ec 18             	sub    $0x18,%esp
  int empty=1;
80109787:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
  for(int i=0;i<ARP_TABLE_MAX;i++){
8010978e:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
80109795:	eb 59                	jmp    801097f0 <arp_table_search+0x6f>
    if(memcmp(arp_table[i].ip,ip,4) == 0){
80109797:	8b 55 f0             	mov    -0x10(%ebp),%edx
8010979a:	89 d0                	mov    %edx,%eax
8010979c:	c1 e0 02             	shl    $0x2,%eax
8010979f:	01 d0                	add    %edx,%eax
801097a1:	01 c0                	add    %eax,%eax
801097a3:	01 d0                	add    %edx,%eax
801097a5:	05 e0 9e 11 80       	add    $0x80119ee0,%eax
801097aa:	83 ec 04             	sub    $0x4,%esp
801097ad:	6a 04                	push   $0x4
801097af:	ff 75 08             	push   0x8(%ebp)
801097b2:	50                   	push   %eax
801097b3:	e8 c2 b9 ff ff       	call   8010517a <memcmp>
801097b8:	83 c4 10             	add    $0x10,%esp
801097bb:	85 c0                	test   %eax,%eax
801097bd:	75 05                	jne    801097c4 <arp_table_search+0x43>
      return i;
801097bf:	8b 45 f0             	mov    -0x10(%ebp),%eax
801097c2:	eb 38                	jmp    801097fc <arp_table_search+0x7b>
    }
    if(arp_table[i].use == 0 && empty == 1){
801097c4:	8b 55 f0             	mov    -0x10(%ebp),%edx
801097c7:	89 d0                	mov    %edx,%eax
801097c9:	c1 e0 02             	shl    $0x2,%eax
801097cc:	01 d0                	add    %edx,%eax
801097ce:	01 c0                	add    %eax,%eax
801097d0:	01 d0                	add    %edx,%eax
801097d2:	05 ea 9e 11 80       	add    $0x80119eea,%eax
801097d7:	0f b6 00             	movzbl (%eax),%eax
801097da:	84 c0                	test   %al,%al
801097dc:	75 0e                	jne    801097ec <arp_table_search+0x6b>
801097de:	83 7d f4 01          	cmpl   $0x1,-0xc(%ebp)
801097e2:	75 08                	jne    801097ec <arp_table_search+0x6b>
      empty = -i;
801097e4:	8b 45 f0             	mov    -0x10(%ebp),%eax
801097e7:	f7 d8                	neg    %eax
801097e9:	89 45 f4             	mov    %eax,-0xc(%ebp)
  for(int i=0;i<ARP_TABLE_MAX;i++){
801097ec:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
801097f0:	83 7d f0 3f          	cmpl   $0x3f,-0x10(%ebp)
801097f4:	7e a1                	jle    80109797 <arp_table_search+0x16>
    }
  }
  return empty-1;
801097f6:	8b 45 f4             	mov    -0xc(%ebp),%eax
801097f9:	83 e8 01             	sub    $0x1,%eax
}
801097fc:	c9                   	leave  
801097fd:	c3                   	ret    

801097fe <print_arp_table>:

void print_arp_table(){
801097fe:	55                   	push   %ebp
801097ff:	89 e5                	mov    %esp,%ebp
80109801:	83 ec 18             	sub    $0x18,%esp
  for(int i=0;i < ARP_TABLE_MAX;i++){
80109804:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
8010980b:	e9 92 00 00 00       	jmp    801098a2 <print_arp_table+0xa4>
    if(arp_table[i].use != 0){
80109810:	8b 55 f4             	mov    -0xc(%ebp),%edx
80109813:	89 d0                	mov    %edx,%eax
80109815:	c1 e0 02             	shl    $0x2,%eax
80109818:	01 d0                	add    %edx,%eax
8010981a:	01 c0                	add    %eax,%eax
8010981c:	01 d0                	add    %edx,%eax
8010981e:	05 ea 9e 11 80       	add    $0x80119eea,%eax
80109823:	0f b6 00             	movzbl (%eax),%eax
80109826:	84 c0                	test   %al,%al
80109828:	74 74                	je     8010989e <print_arp_table+0xa0>
      cprintf("Entry Num: %d ",i);
8010982a:	83 ec 08             	sub    $0x8,%esp
8010982d:	ff 75 f4             	push   -0xc(%ebp)
80109830:	68 ef c5 10 80       	push   $0x8010c5ef
80109835:	e8 ba 6b ff ff       	call   801003f4 <cprintf>
8010983a:	83 c4 10             	add    $0x10,%esp
      print_ipv4(arp_table[i].ip);
8010983d:	8b 55 f4             	mov    -0xc(%ebp),%edx
80109840:	89 d0                	mov    %edx,%eax
80109842:	c1 e0 02             	shl    $0x2,%eax
80109845:	01 d0                	add    %edx,%eax
80109847:	01 c0                	add    %eax,%eax
80109849:	01 d0                	add    %edx,%eax
8010984b:	05 e0 9e 11 80       	add    $0x80119ee0,%eax
80109850:	83 ec 0c             	sub    $0xc,%esp
80109853:	50                   	push   %eax
80109854:	e8 54 02 00 00       	call   80109aad <print_ipv4>
80109859:	83 c4 10             	add    $0x10,%esp
      cprintf(" ");
8010985c:	83 ec 0c             	sub    $0xc,%esp
8010985f:	68 fe c5 10 80       	push   $0x8010c5fe
80109864:	e8 8b 6b ff ff       	call   801003f4 <cprintf>
80109869:	83 c4 10             	add    $0x10,%esp
      print_mac(arp_table[i].mac);
8010986c:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010986f:	89 d0                	mov    %edx,%eax
80109871:	c1 e0 02             	shl    $0x2,%eax
80109874:	01 d0                	add    %edx,%eax
80109876:	01 c0                	add    %eax,%eax
80109878:	01 d0                	add    %edx,%eax
8010987a:	05 e0 9e 11 80       	add    $0x80119ee0,%eax
8010987f:	83 c0 04             	add    $0x4,%eax
80109882:	83 ec 0c             	sub    $0xc,%esp
80109885:	50                   	push   %eax
80109886:	e8 70 02 00 00       	call   80109afb <print_mac>
8010988b:	83 c4 10             	add    $0x10,%esp
      cprintf("\n");
8010988e:	83 ec 0c             	sub    $0xc,%esp
80109891:	68 00 c6 10 80       	push   $0x8010c600
80109896:	e8 59 6b ff ff       	call   801003f4 <cprintf>
8010989b:	83 c4 10             	add    $0x10,%esp
  for(int i=0;i < ARP_TABLE_MAX;i++){
8010989e:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
801098a2:	83 7d f4 3f          	cmpl   $0x3f,-0xc(%ebp)
801098a6:	0f 8e 64 ff ff ff    	jle    80109810 <print_arp_table+0x12>
    }
  }
}
801098ac:	90                   	nop
801098ad:	90                   	nop
801098ae:	c9                   	leave  
801098af:	c3                   	ret    

801098b0 <arp_reply_pkt_create>:


void arp_reply_pkt_create(struct arp_pkt *arp_recv,uint send,uint *send_size){
801098b0:	55                   	push   %ebp
801098b1:	89 e5                	mov    %esp,%ebp
801098b3:	83 ec 18             	sub    $0x18,%esp
  *send_size = sizeof(struct eth_pkt) + sizeof(struct arp_pkt);
801098b6:	8b 45 10             	mov    0x10(%ebp),%eax
801098b9:	c7 00 2c 00 00 00    	movl   $0x2c,(%eax)
  
  struct eth_pkt *reply_eth = (struct eth_pkt *)send;
801098bf:	8b 45 0c             	mov    0xc(%ebp),%eax
801098c2:	89 45 f4             	mov    %eax,-0xc(%ebp)
  struct arp_pkt *reply_arp = (struct arp_pkt *)(send + sizeof(struct eth_pkt));
801098c5:	8b 45 0c             	mov    0xc(%ebp),%eax
801098c8:	83 c0 0e             	add    $0xe,%eax
801098cb:	89 45 f0             	mov    %eax,-0x10(%ebp)

  reply_eth->type[0] = 0x08;
801098ce:	8b 45 f4             	mov    -0xc(%ebp),%eax
801098d1:	c6 40 0c 08          	movb   $0x8,0xc(%eax)
  reply_eth->type[1] = 0x06;
801098d5:	8b 45 f4             	mov    -0xc(%ebp),%eax
801098d8:	c6 40 0d 06          	movb   $0x6,0xd(%eax)
  memmove(reply_eth->dst_mac,arp_recv->src_mac,6);
801098dc:	8b 45 08             	mov    0x8(%ebp),%eax
801098df:	8d 50 08             	lea    0x8(%eax),%edx
801098e2:	8b 45 f4             	mov    -0xc(%ebp),%eax
801098e5:	83 ec 04             	sub    $0x4,%esp
801098e8:	6a 06                	push   $0x6
801098ea:	52                   	push   %edx
801098eb:	50                   	push   %eax
801098ec:	e8 e1 b8 ff ff       	call   801051d2 <memmove>
801098f1:	83 c4 10             	add    $0x10,%esp
  memmove(reply_eth->src_mac,mac_addr,6);
801098f4:	8b 45 f4             	mov    -0xc(%ebp),%eax
801098f7:	83 c0 06             	add    $0x6,%eax
801098fa:	83 ec 04             	sub    $0x4,%esp
801098fd:	6a 06                	push   $0x6
801098ff:	68 c0 9e 11 80       	push   $0x80119ec0
80109904:	50                   	push   %eax
80109905:	e8 c8 b8 ff ff       	call   801051d2 <memmove>
8010990a:	83 c4 10             	add    $0x10,%esp

  reply_arp->hrd_type = ARP_HARDWARE_TYPE;
8010990d:	8b 45 f0             	mov    -0x10(%ebp),%eax
80109910:	66 c7 00 00 01       	movw   $0x100,(%eax)
  reply_arp->pro_type = ARP_PROTOCOL_TYPE;
80109915:	8b 45 f0             	mov    -0x10(%ebp),%eax
80109918:	66 c7 40 02 08 00    	movw   $0x8,0x2(%eax)
  reply_arp->hrd_len = 6;
8010991e:	8b 45 f0             	mov    -0x10(%ebp),%eax
80109921:	c6 40 04 06          	movb   $0x6,0x4(%eax)
  reply_arp->pro_len = 4;
80109925:	8b 45 f0             	mov    -0x10(%ebp),%eax
80109928:	c6 40 05 04          	movb   $0x4,0x5(%eax)
  reply_arp->op = ARP_OPS_REPLY;
8010992c:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010992f:	66 c7 40 06 00 02    	movw   $0x200,0x6(%eax)
  memmove(reply_arp->dst_mac,arp_recv->src_mac,6);
80109935:	8b 45 08             	mov    0x8(%ebp),%eax
80109938:	8d 50 08             	lea    0x8(%eax),%edx
8010993b:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010993e:	83 c0 12             	add    $0x12,%eax
80109941:	83 ec 04             	sub    $0x4,%esp
80109944:	6a 06                	push   $0x6
80109946:	52                   	push   %edx
80109947:	50                   	push   %eax
80109948:	e8 85 b8 ff ff       	call   801051d2 <memmove>
8010994d:	83 c4 10             	add    $0x10,%esp
  memmove(reply_arp->dst_ip,arp_recv->src_ip,4);
80109950:	8b 45 08             	mov    0x8(%ebp),%eax
80109953:	8d 50 0e             	lea    0xe(%eax),%edx
80109956:	8b 45 f0             	mov    -0x10(%ebp),%eax
80109959:	83 c0 18             	add    $0x18,%eax
8010995c:	83 ec 04             	sub    $0x4,%esp
8010995f:	6a 04                	push   $0x4
80109961:	52                   	push   %edx
80109962:	50                   	push   %eax
80109963:	e8 6a b8 ff ff       	call   801051d2 <memmove>
80109968:	83 c4 10             	add    $0x10,%esp
  memmove(reply_arp->src_mac,mac_addr,6);
8010996b:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010996e:	83 c0 08             	add    $0x8,%eax
80109971:	83 ec 04             	sub    $0x4,%esp
80109974:	6a 06                	push   $0x6
80109976:	68 c0 9e 11 80       	push   $0x80119ec0
8010997b:	50                   	push   %eax
8010997c:	e8 51 b8 ff ff       	call   801051d2 <memmove>
80109981:	83 c4 10             	add    $0x10,%esp
  memmove(reply_arp->src_ip,my_ip,4);
80109984:	8b 45 f0             	mov    -0x10(%ebp),%eax
80109987:	83 c0 0e             	add    $0xe,%eax
8010998a:	83 ec 04             	sub    $0x4,%esp
8010998d:	6a 04                	push   $0x4
8010998f:	68 04 f5 10 80       	push   $0x8010f504
80109994:	50                   	push   %eax
80109995:	e8 38 b8 ff ff       	call   801051d2 <memmove>
8010999a:	83 c4 10             	add    $0x10,%esp
}
8010999d:	90                   	nop
8010999e:	c9                   	leave  
8010999f:	c3                   	ret    

801099a0 <print_arp_info>:

void print_arp_info(struct arp_pkt* arp_p){
801099a0:	55                   	push   %ebp
801099a1:	89 e5                	mov    %esp,%ebp
801099a3:	83 ec 08             	sub    $0x8,%esp
  cprintf("--------Source-------\n");
801099a6:	83 ec 0c             	sub    $0xc,%esp
801099a9:	68 02 c6 10 80       	push   $0x8010c602
801099ae:	e8 41 6a ff ff       	call   801003f4 <cprintf>
801099b3:	83 c4 10             	add    $0x10,%esp
  print_ipv4(arp_p->src_ip);
801099b6:	8b 45 08             	mov    0x8(%ebp),%eax
801099b9:	83 c0 0e             	add    $0xe,%eax
801099bc:	83 ec 0c             	sub    $0xc,%esp
801099bf:	50                   	push   %eax
801099c0:	e8 e8 00 00 00       	call   80109aad <print_ipv4>
801099c5:	83 c4 10             	add    $0x10,%esp
  cprintf("\n");
801099c8:	83 ec 0c             	sub    $0xc,%esp
801099cb:	68 00 c6 10 80       	push   $0x8010c600
801099d0:	e8 1f 6a ff ff       	call   801003f4 <cprintf>
801099d5:	83 c4 10             	add    $0x10,%esp
  print_mac(arp_p->src_mac);
801099d8:	8b 45 08             	mov    0x8(%ebp),%eax
801099db:	83 c0 08             	add    $0x8,%eax
801099de:	83 ec 0c             	sub    $0xc,%esp
801099e1:	50                   	push   %eax
801099e2:	e8 14 01 00 00       	call   80109afb <print_mac>
801099e7:	83 c4 10             	add    $0x10,%esp
  cprintf("\n");
801099ea:	83 ec 0c             	sub    $0xc,%esp
801099ed:	68 00 c6 10 80       	push   $0x8010c600
801099f2:	e8 fd 69 ff ff       	call   801003f4 <cprintf>
801099f7:	83 c4 10             	add    $0x10,%esp
  cprintf("-----Destination-----\n");
801099fa:	83 ec 0c             	sub    $0xc,%esp
801099fd:	68 19 c6 10 80       	push   $0x8010c619
80109a02:	e8 ed 69 ff ff       	call   801003f4 <cprintf>
80109a07:	83 c4 10             	add    $0x10,%esp
  print_ipv4(arp_p->dst_ip);
80109a0a:	8b 45 08             	mov    0x8(%ebp),%eax
80109a0d:	83 c0 18             	add    $0x18,%eax
80109a10:	83 ec 0c             	sub    $0xc,%esp
80109a13:	50                   	push   %eax
80109a14:	e8 94 00 00 00       	call   80109aad <print_ipv4>
80109a19:	83 c4 10             	add    $0x10,%esp
  cprintf("\n");
80109a1c:	83 ec 0c             	sub    $0xc,%esp
80109a1f:	68 00 c6 10 80       	push   $0x8010c600
80109a24:	e8 cb 69 ff ff       	call   801003f4 <cprintf>
80109a29:	83 c4 10             	add    $0x10,%esp
  print_mac(arp_p->dst_mac);
80109a2c:	8b 45 08             	mov    0x8(%ebp),%eax
80109a2f:	83 c0 12             	add    $0x12,%eax
80109a32:	83 ec 0c             	sub    $0xc,%esp
80109a35:	50                   	push   %eax
80109a36:	e8 c0 00 00 00       	call   80109afb <print_mac>
80109a3b:	83 c4 10             	add    $0x10,%esp
  cprintf("\n");
80109a3e:	83 ec 0c             	sub    $0xc,%esp
80109a41:	68 00 c6 10 80       	push   $0x8010c600
80109a46:	e8 a9 69 ff ff       	call   801003f4 <cprintf>
80109a4b:	83 c4 10             	add    $0x10,%esp
  cprintf("Operation: ");
80109a4e:	83 ec 0c             	sub    $0xc,%esp
80109a51:	68 30 c6 10 80       	push   $0x8010c630
80109a56:	e8 99 69 ff ff       	call   801003f4 <cprintf>
80109a5b:	83 c4 10             	add    $0x10,%esp
  if(arp_p->op == ARP_OPS_REQUEST) cprintf("Request\n");
80109a5e:	8b 45 08             	mov    0x8(%ebp),%eax
80109a61:	0f b7 40 06          	movzwl 0x6(%eax),%eax
80109a65:	66 3d 00 01          	cmp    $0x100,%ax
80109a69:	75 12                	jne    80109a7d <print_arp_info+0xdd>
80109a6b:	83 ec 0c             	sub    $0xc,%esp
80109a6e:	68 3c c6 10 80       	push   $0x8010c63c
80109a73:	e8 7c 69 ff ff       	call   801003f4 <cprintf>
80109a78:	83 c4 10             	add    $0x10,%esp
80109a7b:	eb 1d                	jmp    80109a9a <print_arp_info+0xfa>
  else if(arp_p->op == ARP_OPS_REPLY) {
80109a7d:	8b 45 08             	mov    0x8(%ebp),%eax
80109a80:	0f b7 40 06          	movzwl 0x6(%eax),%eax
80109a84:	66 3d 00 02          	cmp    $0x200,%ax
80109a88:	75 10                	jne    80109a9a <print_arp_info+0xfa>
    cprintf("Reply\n");
80109a8a:	83 ec 0c             	sub    $0xc,%esp
80109a8d:	68 45 c6 10 80       	push   $0x8010c645
80109a92:	e8 5d 69 ff ff       	call   801003f4 <cprintf>
80109a97:	83 c4 10             	add    $0x10,%esp
  }
  cprintf("\n");
80109a9a:	83 ec 0c             	sub    $0xc,%esp
80109a9d:	68 00 c6 10 80       	push   $0x8010c600
80109aa2:	e8 4d 69 ff ff       	call   801003f4 <cprintf>
80109aa7:	83 c4 10             	add    $0x10,%esp
}
80109aaa:	90                   	nop
80109aab:	c9                   	leave  
80109aac:	c3                   	ret    

80109aad <print_ipv4>:

void print_ipv4(uchar *ip){
80109aad:	55                   	push   %ebp
80109aae:	89 e5                	mov    %esp,%ebp
80109ab0:	53                   	push   %ebx
80109ab1:	83 ec 04             	sub    $0x4,%esp
  cprintf("IP address: %d.%d.%d.%d",ip[0],ip[1],ip[2],ip[3]);
80109ab4:	8b 45 08             	mov    0x8(%ebp),%eax
80109ab7:	83 c0 03             	add    $0x3,%eax
80109aba:	0f b6 00             	movzbl (%eax),%eax
80109abd:	0f b6 d8             	movzbl %al,%ebx
80109ac0:	8b 45 08             	mov    0x8(%ebp),%eax
80109ac3:	83 c0 02             	add    $0x2,%eax
80109ac6:	0f b6 00             	movzbl (%eax),%eax
80109ac9:	0f b6 c8             	movzbl %al,%ecx
80109acc:	8b 45 08             	mov    0x8(%ebp),%eax
80109acf:	83 c0 01             	add    $0x1,%eax
80109ad2:	0f b6 00             	movzbl (%eax),%eax
80109ad5:	0f b6 d0             	movzbl %al,%edx
80109ad8:	8b 45 08             	mov    0x8(%ebp),%eax
80109adb:	0f b6 00             	movzbl (%eax),%eax
80109ade:	0f b6 c0             	movzbl %al,%eax
80109ae1:	83 ec 0c             	sub    $0xc,%esp
80109ae4:	53                   	push   %ebx
80109ae5:	51                   	push   %ecx
80109ae6:	52                   	push   %edx
80109ae7:	50                   	push   %eax
80109ae8:	68 4c c6 10 80       	push   $0x8010c64c
80109aed:	e8 02 69 ff ff       	call   801003f4 <cprintf>
80109af2:	83 c4 20             	add    $0x20,%esp
}
80109af5:	90                   	nop
80109af6:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80109af9:	c9                   	leave  
80109afa:	c3                   	ret    

80109afb <print_mac>:

void print_mac(uchar *mac){
80109afb:	55                   	push   %ebp
80109afc:	89 e5                	mov    %esp,%ebp
80109afe:	57                   	push   %edi
80109aff:	56                   	push   %esi
80109b00:	53                   	push   %ebx
80109b01:	83 ec 0c             	sub    $0xc,%esp
  cprintf("MAC address: %x:%x:%x:%x:%x:%x",mac[0],mac[1],mac[2],mac[3],mac[4],mac[5]);
80109b04:	8b 45 08             	mov    0x8(%ebp),%eax
80109b07:	83 c0 05             	add    $0x5,%eax
80109b0a:	0f b6 00             	movzbl (%eax),%eax
80109b0d:	0f b6 f8             	movzbl %al,%edi
80109b10:	8b 45 08             	mov    0x8(%ebp),%eax
80109b13:	83 c0 04             	add    $0x4,%eax
80109b16:	0f b6 00             	movzbl (%eax),%eax
80109b19:	0f b6 f0             	movzbl %al,%esi
80109b1c:	8b 45 08             	mov    0x8(%ebp),%eax
80109b1f:	83 c0 03             	add    $0x3,%eax
80109b22:	0f b6 00             	movzbl (%eax),%eax
80109b25:	0f b6 d8             	movzbl %al,%ebx
80109b28:	8b 45 08             	mov    0x8(%ebp),%eax
80109b2b:	83 c0 02             	add    $0x2,%eax
80109b2e:	0f b6 00             	movzbl (%eax),%eax
80109b31:	0f b6 c8             	movzbl %al,%ecx
80109b34:	8b 45 08             	mov    0x8(%ebp),%eax
80109b37:	83 c0 01             	add    $0x1,%eax
80109b3a:	0f b6 00             	movzbl (%eax),%eax
80109b3d:	0f b6 d0             	movzbl %al,%edx
80109b40:	8b 45 08             	mov    0x8(%ebp),%eax
80109b43:	0f b6 00             	movzbl (%eax),%eax
80109b46:	0f b6 c0             	movzbl %al,%eax
80109b49:	83 ec 04             	sub    $0x4,%esp
80109b4c:	57                   	push   %edi
80109b4d:	56                   	push   %esi
80109b4e:	53                   	push   %ebx
80109b4f:	51                   	push   %ecx
80109b50:	52                   	push   %edx
80109b51:	50                   	push   %eax
80109b52:	68 64 c6 10 80       	push   $0x8010c664
80109b57:	e8 98 68 ff ff       	call   801003f4 <cprintf>
80109b5c:	83 c4 20             	add    $0x20,%esp
}
80109b5f:	90                   	nop
80109b60:	8d 65 f4             	lea    -0xc(%ebp),%esp
80109b63:	5b                   	pop    %ebx
80109b64:	5e                   	pop    %esi
80109b65:	5f                   	pop    %edi
80109b66:	5d                   	pop    %ebp
80109b67:	c3                   	ret    

80109b68 <eth_proc>:
#include "arp.h"
#include "types.h"
#include "eth.h"
#include "defs.h"
#include "ipv4.h"
void eth_proc(uint buffer_addr){
80109b68:	55                   	push   %ebp
80109b69:	89 e5                	mov    %esp,%ebp
80109b6b:	83 ec 18             	sub    $0x18,%esp
  struct eth_pkt *eth_pkt = (struct eth_pkt *)buffer_addr;
80109b6e:	8b 45 08             	mov    0x8(%ebp),%eax
80109b71:	89 45 f4             	mov    %eax,-0xc(%ebp)
  uint pkt_addr = buffer_addr+sizeof(struct eth_pkt);
80109b74:	8b 45 08             	mov    0x8(%ebp),%eax
80109b77:	83 c0 0e             	add    $0xe,%eax
80109b7a:	89 45 f0             	mov    %eax,-0x10(%ebp)
  if(eth_pkt->type[0] == 0x08 && eth_pkt->type[1] == 0x06){
80109b7d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80109b80:	0f b6 40 0c          	movzbl 0xc(%eax),%eax
80109b84:	3c 08                	cmp    $0x8,%al
80109b86:	75 1b                	jne    80109ba3 <eth_proc+0x3b>
80109b88:	8b 45 f4             	mov    -0xc(%ebp),%eax
80109b8b:	0f b6 40 0d          	movzbl 0xd(%eax),%eax
80109b8f:	3c 06                	cmp    $0x6,%al
80109b91:	75 10                	jne    80109ba3 <eth_proc+0x3b>
    arp_proc(pkt_addr);
80109b93:	83 ec 0c             	sub    $0xc,%esp
80109b96:	ff 75 f0             	push   -0x10(%ebp)
80109b99:	e8 01 f8 ff ff       	call   8010939f <arp_proc>
80109b9e:	83 c4 10             	add    $0x10,%esp
  }else if(eth_pkt->type[0] == 0x08 && eth_pkt->type[1] == 0x00){
    ipv4_proc(buffer_addr);
  }else{
  }
}
80109ba1:	eb 24                	jmp    80109bc7 <eth_proc+0x5f>
  }else if(eth_pkt->type[0] == 0x08 && eth_pkt->type[1] == 0x00){
80109ba3:	8b 45 f4             	mov    -0xc(%ebp),%eax
80109ba6:	0f b6 40 0c          	movzbl 0xc(%eax),%eax
80109baa:	3c 08                	cmp    $0x8,%al
80109bac:	75 19                	jne    80109bc7 <eth_proc+0x5f>
80109bae:	8b 45 f4             	mov    -0xc(%ebp),%eax
80109bb1:	0f b6 40 0d          	movzbl 0xd(%eax),%eax
80109bb5:	84 c0                	test   %al,%al
80109bb7:	75 0e                	jne    80109bc7 <eth_proc+0x5f>
    ipv4_proc(buffer_addr);
80109bb9:	83 ec 0c             	sub    $0xc,%esp
80109bbc:	ff 75 08             	push   0x8(%ebp)
80109bbf:	e8 a3 00 00 00       	call   80109c67 <ipv4_proc>
80109bc4:	83 c4 10             	add    $0x10,%esp
}
80109bc7:	90                   	nop
80109bc8:	c9                   	leave  
80109bc9:	c3                   	ret    

80109bca <N2H_ushort>:

ushort N2H_ushort(ushort value){
80109bca:	55                   	push   %ebp
80109bcb:	89 e5                	mov    %esp,%ebp
80109bcd:	83 ec 04             	sub    $0x4,%esp
80109bd0:	8b 45 08             	mov    0x8(%ebp),%eax
80109bd3:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  return (((value)&0xFF)<<8)+(value>>8);
80109bd7:	0f b7 45 fc          	movzwl -0x4(%ebp),%eax
80109bdb:	c1 e0 08             	shl    $0x8,%eax
80109bde:	89 c2                	mov    %eax,%edx
80109be0:	0f b7 45 fc          	movzwl -0x4(%ebp),%eax
80109be4:	66 c1 e8 08          	shr    $0x8,%ax
80109be8:	01 d0                	add    %edx,%eax
}
80109bea:	c9                   	leave  
80109beb:	c3                   	ret    

80109bec <H2N_ushort>:

ushort H2N_ushort(ushort value){
80109bec:	55                   	push   %ebp
80109bed:	89 e5                	mov    %esp,%ebp
80109bef:	83 ec 04             	sub    $0x4,%esp
80109bf2:	8b 45 08             	mov    0x8(%ebp),%eax
80109bf5:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  return (((value)&0xFF)<<8)+(value>>8);
80109bf9:	0f b7 45 fc          	movzwl -0x4(%ebp),%eax
80109bfd:	c1 e0 08             	shl    $0x8,%eax
80109c00:	89 c2                	mov    %eax,%edx
80109c02:	0f b7 45 fc          	movzwl -0x4(%ebp),%eax
80109c06:	66 c1 e8 08          	shr    $0x8,%ax
80109c0a:	01 d0                	add    %edx,%eax
}
80109c0c:	c9                   	leave  
80109c0d:	c3                   	ret    

80109c0e <H2N_uint>:

uint H2N_uint(uint value){
80109c0e:	55                   	push   %ebp
80109c0f:	89 e5                	mov    %esp,%ebp
  return ((value&0xF)<<24)+((value&0xF0)<<8)+((value&0xF00)>>8)+((value&0xF000)>>24);
80109c11:	8b 45 08             	mov    0x8(%ebp),%eax
80109c14:	c1 e0 18             	shl    $0x18,%eax
80109c17:	25 00 00 00 0f       	and    $0xf000000,%eax
80109c1c:	89 c2                	mov    %eax,%edx
80109c1e:	8b 45 08             	mov    0x8(%ebp),%eax
80109c21:	c1 e0 08             	shl    $0x8,%eax
80109c24:	25 00 f0 00 00       	and    $0xf000,%eax
80109c29:	09 c2                	or     %eax,%edx
80109c2b:	8b 45 08             	mov    0x8(%ebp),%eax
80109c2e:	c1 e8 08             	shr    $0x8,%eax
80109c31:	83 e0 0f             	and    $0xf,%eax
80109c34:	01 d0                	add    %edx,%eax
}
80109c36:	5d                   	pop    %ebp
80109c37:	c3                   	ret    

80109c38 <N2H_uint>:

uint N2H_uint(uint value){
80109c38:	55                   	push   %ebp
80109c39:	89 e5                	mov    %esp,%ebp
  return ((value&0xFF)<<24)+((value&0xFF00)<<8)+((value&0xFF0000)>>8)+((value&0xFF000000)>>24);
80109c3b:	8b 45 08             	mov    0x8(%ebp),%eax
80109c3e:	c1 e0 18             	shl    $0x18,%eax
80109c41:	89 c2                	mov    %eax,%edx
80109c43:	8b 45 08             	mov    0x8(%ebp),%eax
80109c46:	c1 e0 08             	shl    $0x8,%eax
80109c49:	25 00 00 ff 00       	and    $0xff0000,%eax
80109c4e:	01 c2                	add    %eax,%edx
80109c50:	8b 45 08             	mov    0x8(%ebp),%eax
80109c53:	c1 e8 08             	shr    $0x8,%eax
80109c56:	25 00 ff 00 00       	and    $0xff00,%eax
80109c5b:	01 c2                	add    %eax,%edx
80109c5d:	8b 45 08             	mov    0x8(%ebp),%eax
80109c60:	c1 e8 18             	shr    $0x18,%eax
80109c63:	01 d0                	add    %edx,%eax
}
80109c65:	5d                   	pop    %ebp
80109c66:	c3                   	ret    

80109c67 <ipv4_proc>:
extern uchar mac_addr[6];
extern uchar my_ip[4];

int ip_id = -1;
ushort send_id = 0;
void ipv4_proc(uint buffer_addr){
80109c67:	55                   	push   %ebp
80109c68:	89 e5                	mov    %esp,%ebp
80109c6a:	83 ec 18             	sub    $0x18,%esp
  struct ipv4_pkt *ipv4_p = (struct ipv4_pkt *)(buffer_addr+14);
80109c6d:	8b 45 08             	mov    0x8(%ebp),%eax
80109c70:	83 c0 0e             	add    $0xe,%eax
80109c73:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(ip_id != ipv4_p->id && memcmp(my_ip,ipv4_p->src_ip,4) != 0){
80109c76:	8b 45 f4             	mov    -0xc(%ebp),%eax
80109c79:	0f b7 40 04          	movzwl 0x4(%eax),%eax
80109c7d:	0f b7 d0             	movzwl %ax,%edx
80109c80:	a1 08 f5 10 80       	mov    0x8010f508,%eax
80109c85:	39 c2                	cmp    %eax,%edx
80109c87:	74 60                	je     80109ce9 <ipv4_proc+0x82>
80109c89:	8b 45 f4             	mov    -0xc(%ebp),%eax
80109c8c:	83 c0 0c             	add    $0xc,%eax
80109c8f:	83 ec 04             	sub    $0x4,%esp
80109c92:	6a 04                	push   $0x4
80109c94:	50                   	push   %eax
80109c95:	68 04 f5 10 80       	push   $0x8010f504
80109c9a:	e8 db b4 ff ff       	call   8010517a <memcmp>
80109c9f:	83 c4 10             	add    $0x10,%esp
80109ca2:	85 c0                	test   %eax,%eax
80109ca4:	74 43                	je     80109ce9 <ipv4_proc+0x82>
    ip_id = ipv4_p->id;
80109ca6:	8b 45 f4             	mov    -0xc(%ebp),%eax
80109ca9:	0f b7 40 04          	movzwl 0x4(%eax),%eax
80109cad:	0f b7 c0             	movzwl %ax,%eax
80109cb0:	a3 08 f5 10 80       	mov    %eax,0x8010f508
      if(ipv4_p->protocol == IPV4_TYPE_ICMP){
80109cb5:	8b 45 f4             	mov    -0xc(%ebp),%eax
80109cb8:	0f b6 40 09          	movzbl 0x9(%eax),%eax
80109cbc:	3c 01                	cmp    $0x1,%al
80109cbe:	75 10                	jne    80109cd0 <ipv4_proc+0x69>
        icmp_proc(buffer_addr);
80109cc0:	83 ec 0c             	sub    $0xc,%esp
80109cc3:	ff 75 08             	push   0x8(%ebp)
80109cc6:	e8 a3 00 00 00       	call   80109d6e <icmp_proc>
80109ccb:	83 c4 10             	add    $0x10,%esp
      }else if(ipv4_p->protocol == IPV4_TYPE_TCP){
        tcp_proc(buffer_addr);
      }
  }
}
80109cce:	eb 19                	jmp    80109ce9 <ipv4_proc+0x82>
      }else if(ipv4_p->protocol == IPV4_TYPE_TCP){
80109cd0:	8b 45 f4             	mov    -0xc(%ebp),%eax
80109cd3:	0f b6 40 09          	movzbl 0x9(%eax),%eax
80109cd7:	3c 06                	cmp    $0x6,%al
80109cd9:	75 0e                	jne    80109ce9 <ipv4_proc+0x82>
        tcp_proc(buffer_addr);
80109cdb:	83 ec 0c             	sub    $0xc,%esp
80109cde:	ff 75 08             	push   0x8(%ebp)
80109ce1:	e8 b3 03 00 00       	call   8010a099 <tcp_proc>
80109ce6:	83 c4 10             	add    $0x10,%esp
}
80109ce9:	90                   	nop
80109cea:	c9                   	leave  
80109ceb:	c3                   	ret    

80109cec <ipv4_chksum>:

ushort ipv4_chksum(uint ipv4_addr){
80109cec:	55                   	push   %ebp
80109ced:	89 e5                	mov    %esp,%ebp
80109cef:	83 ec 10             	sub    $0x10,%esp
  uchar* bin = (uchar *)ipv4_addr;
80109cf2:	8b 45 08             	mov    0x8(%ebp),%eax
80109cf5:	89 45 f4             	mov    %eax,-0xc(%ebp)
  uchar len = (bin[0]&0xF)*2;
80109cf8:	8b 45 f4             	mov    -0xc(%ebp),%eax
80109cfb:	0f b6 00             	movzbl (%eax),%eax
80109cfe:	83 e0 0f             	and    $0xf,%eax
80109d01:	01 c0                	add    %eax,%eax
80109d03:	88 45 f3             	mov    %al,-0xd(%ebp)
  uint chk_sum = 0;
80109d06:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  for(int i=0;i<len;i++){
80109d0d:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
80109d14:	eb 48                	jmp    80109d5e <ipv4_chksum+0x72>
    chk_sum += (bin[i*2]<<8)+bin[i*2+1];
80109d16:	8b 45 f8             	mov    -0x8(%ebp),%eax
80109d19:	01 c0                	add    %eax,%eax
80109d1b:	89 c2                	mov    %eax,%edx
80109d1d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80109d20:	01 d0                	add    %edx,%eax
80109d22:	0f b6 00             	movzbl (%eax),%eax
80109d25:	0f b6 c0             	movzbl %al,%eax
80109d28:	c1 e0 08             	shl    $0x8,%eax
80109d2b:	89 c2                	mov    %eax,%edx
80109d2d:	8b 45 f8             	mov    -0x8(%ebp),%eax
80109d30:	01 c0                	add    %eax,%eax
80109d32:	8d 48 01             	lea    0x1(%eax),%ecx
80109d35:	8b 45 f4             	mov    -0xc(%ebp),%eax
80109d38:	01 c8                	add    %ecx,%eax
80109d3a:	0f b6 00             	movzbl (%eax),%eax
80109d3d:	0f b6 c0             	movzbl %al,%eax
80109d40:	01 d0                	add    %edx,%eax
80109d42:	01 45 fc             	add    %eax,-0x4(%ebp)
    if(chk_sum > 0xFFFF){
80109d45:	81 7d fc ff ff 00 00 	cmpl   $0xffff,-0x4(%ebp)
80109d4c:	76 0c                	jbe    80109d5a <ipv4_chksum+0x6e>
      chk_sum = (chk_sum&0xFFFF)+1;
80109d4e:	8b 45 fc             	mov    -0x4(%ebp),%eax
80109d51:	0f b7 c0             	movzwl %ax,%eax
80109d54:	83 c0 01             	add    $0x1,%eax
80109d57:	89 45 fc             	mov    %eax,-0x4(%ebp)
  for(int i=0;i<len;i++){
80109d5a:	83 45 f8 01          	addl   $0x1,-0x8(%ebp)
80109d5e:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
80109d62:	39 45 f8             	cmp    %eax,-0x8(%ebp)
80109d65:	7c af                	jl     80109d16 <ipv4_chksum+0x2a>
    }
  }
  return ~(chk_sum);
80109d67:	8b 45 fc             	mov    -0x4(%ebp),%eax
80109d6a:	f7 d0                	not    %eax
}
80109d6c:	c9                   	leave  
80109d6d:	c3                   	ret    

80109d6e <icmp_proc>:
#include "eth.h"

extern uchar mac_addr[6];
extern uchar my_ip[4];
extern ushort send_id;
void icmp_proc(uint buffer_addr){
80109d6e:	55                   	push   %ebp
80109d6f:	89 e5                	mov    %esp,%ebp
80109d71:	83 ec 18             	sub    $0x18,%esp
  struct ipv4_pkt *ipv4_p = (struct ipv4_pkt *)(buffer_addr+sizeof(struct eth_pkt));
80109d74:	8b 45 08             	mov    0x8(%ebp),%eax
80109d77:	83 c0 0e             	add    $0xe,%eax
80109d7a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  struct icmp_echo_pkt *icmp_p = (struct icmp_echo_pkt *)((uint)ipv4_p + (ipv4_p->ver&0xF)*4);
80109d7d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80109d80:	0f b6 00             	movzbl (%eax),%eax
80109d83:	0f b6 c0             	movzbl %al,%eax
80109d86:	83 e0 0f             	and    $0xf,%eax
80109d89:	c1 e0 02             	shl    $0x2,%eax
80109d8c:	89 c2                	mov    %eax,%edx
80109d8e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80109d91:	01 d0                	add    %edx,%eax
80109d93:	89 45 f0             	mov    %eax,-0x10(%ebp)
  if(icmp_p->code == 0){
80109d96:	8b 45 f0             	mov    -0x10(%ebp),%eax
80109d99:	0f b6 40 01          	movzbl 0x1(%eax),%eax
80109d9d:	84 c0                	test   %al,%al
80109d9f:	75 4f                	jne    80109df0 <icmp_proc+0x82>
    if(icmp_p->type == ICMP_TYPE_ECHO_REQUEST){
80109da1:	8b 45 f0             	mov    -0x10(%ebp),%eax
80109da4:	0f b6 00             	movzbl (%eax),%eax
80109da7:	3c 08                	cmp    $0x8,%al
80109da9:	75 45                	jne    80109df0 <icmp_proc+0x82>
      uint send_addr = (uint)kalloc();
80109dab:	e8 d4 8e ff ff       	call   80102c84 <kalloc>
80109db0:	89 45 ec             	mov    %eax,-0x14(%ebp)
      uint send_size = 0;
80109db3:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
      icmp_reply_pkt_create(buffer_addr,send_addr,&send_size);
80109dba:	83 ec 04             	sub    $0x4,%esp
80109dbd:	8d 45 e8             	lea    -0x18(%ebp),%eax
80109dc0:	50                   	push   %eax
80109dc1:	ff 75 ec             	push   -0x14(%ebp)
80109dc4:	ff 75 08             	push   0x8(%ebp)
80109dc7:	e8 78 00 00 00       	call   80109e44 <icmp_reply_pkt_create>
80109dcc:	83 c4 10             	add    $0x10,%esp
      i8254_send(send_addr,send_size);
80109dcf:	8b 45 e8             	mov    -0x18(%ebp),%eax
80109dd2:	83 ec 08             	sub    $0x8,%esp
80109dd5:	50                   	push   %eax
80109dd6:	ff 75 ec             	push   -0x14(%ebp)
80109dd9:	e8 95 f4 ff ff       	call   80109273 <i8254_send>
80109dde:	83 c4 10             	add    $0x10,%esp
      kfree((char *)send_addr);
80109de1:	8b 45 ec             	mov    -0x14(%ebp),%eax
80109de4:	83 ec 0c             	sub    $0xc,%esp
80109de7:	50                   	push   %eax
80109de8:	e8 fd 8d ff ff       	call   80102bea <kfree>
80109ded:	83 c4 10             	add    $0x10,%esp
    }
  }
}
80109df0:	90                   	nop
80109df1:	c9                   	leave  
80109df2:	c3                   	ret    

80109df3 <icmp_proc_req>:

void icmp_proc_req(struct icmp_echo_pkt * icmp_p){
80109df3:	55                   	push   %ebp
80109df4:	89 e5                	mov    %esp,%ebp
80109df6:	53                   	push   %ebx
80109df7:	83 ec 04             	sub    $0x4,%esp
  cprintf("ICMP ID:0x%x SEQ NUM:0x%x\n",N2H_ushort(icmp_p->id),N2H_ushort(icmp_p->seq_num));
80109dfa:	8b 45 08             	mov    0x8(%ebp),%eax
80109dfd:	0f b7 40 06          	movzwl 0x6(%eax),%eax
80109e01:	0f b7 c0             	movzwl %ax,%eax
80109e04:	83 ec 0c             	sub    $0xc,%esp
80109e07:	50                   	push   %eax
80109e08:	e8 bd fd ff ff       	call   80109bca <N2H_ushort>
80109e0d:	83 c4 10             	add    $0x10,%esp
80109e10:	0f b7 d8             	movzwl %ax,%ebx
80109e13:	8b 45 08             	mov    0x8(%ebp),%eax
80109e16:	0f b7 40 04          	movzwl 0x4(%eax),%eax
80109e1a:	0f b7 c0             	movzwl %ax,%eax
80109e1d:	83 ec 0c             	sub    $0xc,%esp
80109e20:	50                   	push   %eax
80109e21:	e8 a4 fd ff ff       	call   80109bca <N2H_ushort>
80109e26:	83 c4 10             	add    $0x10,%esp
80109e29:	0f b7 c0             	movzwl %ax,%eax
80109e2c:	83 ec 04             	sub    $0x4,%esp
80109e2f:	53                   	push   %ebx
80109e30:	50                   	push   %eax
80109e31:	68 83 c6 10 80       	push   $0x8010c683
80109e36:	e8 b9 65 ff ff       	call   801003f4 <cprintf>
80109e3b:	83 c4 10             	add    $0x10,%esp
}
80109e3e:	90                   	nop
80109e3f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80109e42:	c9                   	leave  
80109e43:	c3                   	ret    

80109e44 <icmp_reply_pkt_create>:

void icmp_reply_pkt_create(uint recv_addr,uint send_addr,uint *send_size){
80109e44:	55                   	push   %ebp
80109e45:	89 e5                	mov    %esp,%ebp
80109e47:	83 ec 28             	sub    $0x28,%esp
  struct eth_pkt *eth_recv = (struct eth_pkt *)(recv_addr);
80109e4a:	8b 45 08             	mov    0x8(%ebp),%eax
80109e4d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  struct ipv4_pkt *ipv4_recv = (struct ipv4_pkt *)(recv_addr+sizeof(struct eth_pkt));
80109e50:	8b 45 08             	mov    0x8(%ebp),%eax
80109e53:	83 c0 0e             	add    $0xe,%eax
80109e56:	89 45 f0             	mov    %eax,-0x10(%ebp)
  struct icmp_echo_pkt *icmp_recv = (struct icmp_echo_pkt *)((uint)ipv4_recv+(ipv4_recv->ver&0xF)*4);
80109e59:	8b 45 f0             	mov    -0x10(%ebp),%eax
80109e5c:	0f b6 00             	movzbl (%eax),%eax
80109e5f:	0f b6 c0             	movzbl %al,%eax
80109e62:	83 e0 0f             	and    $0xf,%eax
80109e65:	c1 e0 02             	shl    $0x2,%eax
80109e68:	89 c2                	mov    %eax,%edx
80109e6a:	8b 45 f0             	mov    -0x10(%ebp),%eax
80109e6d:	01 d0                	add    %edx,%eax
80109e6f:	89 45 ec             	mov    %eax,-0x14(%ebp)
  struct eth_pkt *eth_send = (struct eth_pkt *)(send_addr);
80109e72:	8b 45 0c             	mov    0xc(%ebp),%eax
80109e75:	89 45 e8             	mov    %eax,-0x18(%ebp)
  struct ipv4_pkt *ipv4_send = (struct ipv4_pkt *)(send_addr+sizeof(struct eth_pkt));
80109e78:	8b 45 0c             	mov    0xc(%ebp),%eax
80109e7b:	83 c0 0e             	add    $0xe,%eax
80109e7e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  struct icmp_echo_pkt *icmp_send = (struct icmp_echo_pkt *)((uint)ipv4_send+sizeof(struct ipv4_pkt));
80109e81:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80109e84:	83 c0 14             	add    $0x14,%eax
80109e87:	89 45 e0             	mov    %eax,-0x20(%ebp)
  
  *send_size = sizeof(struct eth_pkt) + sizeof(struct ipv4_pkt) + sizeof(struct icmp_echo_pkt);
80109e8a:	8b 45 10             	mov    0x10(%ebp),%eax
80109e8d:	c7 00 62 00 00 00    	movl   $0x62,(%eax)
  memmove(eth_send->dst_mac,eth_recv->src_mac,6);
80109e93:	8b 45 f4             	mov    -0xc(%ebp),%eax
80109e96:	8d 50 06             	lea    0x6(%eax),%edx
80109e99:	8b 45 e8             	mov    -0x18(%ebp),%eax
80109e9c:	83 ec 04             	sub    $0x4,%esp
80109e9f:	6a 06                	push   $0x6
80109ea1:	52                   	push   %edx
80109ea2:	50                   	push   %eax
80109ea3:	e8 2a b3 ff ff       	call   801051d2 <memmove>
80109ea8:	83 c4 10             	add    $0x10,%esp
  memmove(eth_send->src_mac,mac_addr,6);
80109eab:	8b 45 e8             	mov    -0x18(%ebp),%eax
80109eae:	83 c0 06             	add    $0x6,%eax
80109eb1:	83 ec 04             	sub    $0x4,%esp
80109eb4:	6a 06                	push   $0x6
80109eb6:	68 c0 9e 11 80       	push   $0x80119ec0
80109ebb:	50                   	push   %eax
80109ebc:	e8 11 b3 ff ff       	call   801051d2 <memmove>
80109ec1:	83 c4 10             	add    $0x10,%esp
  eth_send->type[0] = 0x08;
80109ec4:	8b 45 e8             	mov    -0x18(%ebp),%eax
80109ec7:	c6 40 0c 08          	movb   $0x8,0xc(%eax)
  eth_send->type[1] = 0x00;
80109ecb:	8b 45 e8             	mov    -0x18(%ebp),%eax
80109ece:	c6 40 0d 00          	movb   $0x0,0xd(%eax)

  ipv4_send->ver = ((0x4)<<4)+((sizeof(struct ipv4_pkt)/4)&0xF);
80109ed2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80109ed5:	c6 00 45             	movb   $0x45,(%eax)
  ipv4_send->srv_type = 0;
80109ed8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80109edb:	c6 40 01 00          	movb   $0x0,0x1(%eax)
  ipv4_send->total_len = H2N_ushort(sizeof(struct ipv4_pkt) + sizeof(struct icmp_echo_pkt));
80109edf:	83 ec 0c             	sub    $0xc,%esp
80109ee2:	6a 54                	push   $0x54
80109ee4:	e8 03 fd ff ff       	call   80109bec <H2N_ushort>
80109ee9:	83 c4 10             	add    $0x10,%esp
80109eec:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80109eef:	66 89 42 02          	mov    %ax,0x2(%edx)
  ipv4_send->id = send_id;
80109ef3:	0f b7 15 a0 a1 11 80 	movzwl 0x8011a1a0,%edx
80109efa:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80109efd:	66 89 50 04          	mov    %dx,0x4(%eax)
  send_id++;
80109f01:	0f b7 05 a0 a1 11 80 	movzwl 0x8011a1a0,%eax
80109f08:	83 c0 01             	add    $0x1,%eax
80109f0b:	66 a3 a0 a1 11 80    	mov    %ax,0x8011a1a0
  ipv4_send->fragment = H2N_ushort(0x4000);
80109f11:	83 ec 0c             	sub    $0xc,%esp
80109f14:	68 00 40 00 00       	push   $0x4000
80109f19:	e8 ce fc ff ff       	call   80109bec <H2N_ushort>
80109f1e:	83 c4 10             	add    $0x10,%esp
80109f21:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80109f24:	66 89 42 06          	mov    %ax,0x6(%edx)
  ipv4_send->ttl = 255;
80109f28:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80109f2b:	c6 40 08 ff          	movb   $0xff,0x8(%eax)
  ipv4_send->protocol = 0x1;
80109f2f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80109f32:	c6 40 09 01          	movb   $0x1,0x9(%eax)
  memmove(ipv4_send->src_ip,my_ip,4);
80109f36:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80109f39:	83 c0 0c             	add    $0xc,%eax
80109f3c:	83 ec 04             	sub    $0x4,%esp
80109f3f:	6a 04                	push   $0x4
80109f41:	68 04 f5 10 80       	push   $0x8010f504
80109f46:	50                   	push   %eax
80109f47:	e8 86 b2 ff ff       	call   801051d2 <memmove>
80109f4c:	83 c4 10             	add    $0x10,%esp
  memmove(ipv4_send->dst_ip,ipv4_recv->src_ip,4);
80109f4f:	8b 45 f0             	mov    -0x10(%ebp),%eax
80109f52:	8d 50 0c             	lea    0xc(%eax),%edx
80109f55:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80109f58:	83 c0 10             	add    $0x10,%eax
80109f5b:	83 ec 04             	sub    $0x4,%esp
80109f5e:	6a 04                	push   $0x4
80109f60:	52                   	push   %edx
80109f61:	50                   	push   %eax
80109f62:	e8 6b b2 ff ff       	call   801051d2 <memmove>
80109f67:	83 c4 10             	add    $0x10,%esp
  ipv4_send->chk_sum = 0;
80109f6a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80109f6d:	66 c7 40 0a 00 00    	movw   $0x0,0xa(%eax)
  ipv4_send->chk_sum = H2N_ushort(ipv4_chksum((uint)ipv4_send));
80109f73:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80109f76:	83 ec 0c             	sub    $0xc,%esp
80109f79:	50                   	push   %eax
80109f7a:	e8 6d fd ff ff       	call   80109cec <ipv4_chksum>
80109f7f:	83 c4 10             	add    $0x10,%esp
80109f82:	0f b7 c0             	movzwl %ax,%eax
80109f85:	83 ec 0c             	sub    $0xc,%esp
80109f88:	50                   	push   %eax
80109f89:	e8 5e fc ff ff       	call   80109bec <H2N_ushort>
80109f8e:	83 c4 10             	add    $0x10,%esp
80109f91:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80109f94:	66 89 42 0a          	mov    %ax,0xa(%edx)

  icmp_send->type = ICMP_TYPE_ECHO_REPLY;
80109f98:	8b 45 e0             	mov    -0x20(%ebp),%eax
80109f9b:	c6 00 00             	movb   $0x0,(%eax)
  icmp_send->code = 0;
80109f9e:	8b 45 e0             	mov    -0x20(%ebp),%eax
80109fa1:	c6 40 01 00          	movb   $0x0,0x1(%eax)
  icmp_send->id = icmp_recv->id;
80109fa5:	8b 45 ec             	mov    -0x14(%ebp),%eax
80109fa8:	0f b7 50 04          	movzwl 0x4(%eax),%edx
80109fac:	8b 45 e0             	mov    -0x20(%ebp),%eax
80109faf:	66 89 50 04          	mov    %dx,0x4(%eax)
  icmp_send->seq_num = icmp_recv->seq_num;
80109fb3:	8b 45 ec             	mov    -0x14(%ebp),%eax
80109fb6:	0f b7 50 06          	movzwl 0x6(%eax),%edx
80109fba:	8b 45 e0             	mov    -0x20(%ebp),%eax
80109fbd:	66 89 50 06          	mov    %dx,0x6(%eax)
  memmove(icmp_send->time_stamp,icmp_recv->time_stamp,8);
80109fc1:	8b 45 ec             	mov    -0x14(%ebp),%eax
80109fc4:	8d 50 08             	lea    0x8(%eax),%edx
80109fc7:	8b 45 e0             	mov    -0x20(%ebp),%eax
80109fca:	83 c0 08             	add    $0x8,%eax
80109fcd:	83 ec 04             	sub    $0x4,%esp
80109fd0:	6a 08                	push   $0x8
80109fd2:	52                   	push   %edx
80109fd3:	50                   	push   %eax
80109fd4:	e8 f9 b1 ff ff       	call   801051d2 <memmove>
80109fd9:	83 c4 10             	add    $0x10,%esp
  memmove(icmp_send->data,icmp_recv->data,48);
80109fdc:	8b 45 ec             	mov    -0x14(%ebp),%eax
80109fdf:	8d 50 10             	lea    0x10(%eax),%edx
80109fe2:	8b 45 e0             	mov    -0x20(%ebp),%eax
80109fe5:	83 c0 10             	add    $0x10,%eax
80109fe8:	83 ec 04             	sub    $0x4,%esp
80109feb:	6a 30                	push   $0x30
80109fed:	52                   	push   %edx
80109fee:	50                   	push   %eax
80109fef:	e8 de b1 ff ff       	call   801051d2 <memmove>
80109ff4:	83 c4 10             	add    $0x10,%esp
  icmp_send->chk_sum = 0;
80109ff7:	8b 45 e0             	mov    -0x20(%ebp),%eax
80109ffa:	66 c7 40 02 00 00    	movw   $0x0,0x2(%eax)
  icmp_send->chk_sum = H2N_ushort(icmp_chksum((uint)icmp_send));
8010a000:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010a003:	83 ec 0c             	sub    $0xc,%esp
8010a006:	50                   	push   %eax
8010a007:	e8 1c 00 00 00       	call   8010a028 <icmp_chksum>
8010a00c:	83 c4 10             	add    $0x10,%esp
8010a00f:	0f b7 c0             	movzwl %ax,%eax
8010a012:	83 ec 0c             	sub    $0xc,%esp
8010a015:	50                   	push   %eax
8010a016:	e8 d1 fb ff ff       	call   80109bec <H2N_ushort>
8010a01b:	83 c4 10             	add    $0x10,%esp
8010a01e:	8b 55 e0             	mov    -0x20(%ebp),%edx
8010a021:	66 89 42 02          	mov    %ax,0x2(%edx)
}
8010a025:	90                   	nop
8010a026:	c9                   	leave  
8010a027:	c3                   	ret    

8010a028 <icmp_chksum>:

ushort icmp_chksum(uint icmp_addr){
8010a028:	55                   	push   %ebp
8010a029:	89 e5                	mov    %esp,%ebp
8010a02b:	83 ec 10             	sub    $0x10,%esp
  uchar* bin = (uchar *)icmp_addr;
8010a02e:	8b 45 08             	mov    0x8(%ebp),%eax
8010a031:	89 45 f4             	mov    %eax,-0xc(%ebp)
  uint chk_sum = 0;
8010a034:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  for(int i=0;i<32;i++){
8010a03b:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
8010a042:	eb 48                	jmp    8010a08c <icmp_chksum+0x64>
    chk_sum += (bin[i*2]<<8)+bin[i*2+1];
8010a044:	8b 45 f8             	mov    -0x8(%ebp),%eax
8010a047:	01 c0                	add    %eax,%eax
8010a049:	89 c2                	mov    %eax,%edx
8010a04b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010a04e:	01 d0                	add    %edx,%eax
8010a050:	0f b6 00             	movzbl (%eax),%eax
8010a053:	0f b6 c0             	movzbl %al,%eax
8010a056:	c1 e0 08             	shl    $0x8,%eax
8010a059:	89 c2                	mov    %eax,%edx
8010a05b:	8b 45 f8             	mov    -0x8(%ebp),%eax
8010a05e:	01 c0                	add    %eax,%eax
8010a060:	8d 48 01             	lea    0x1(%eax),%ecx
8010a063:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010a066:	01 c8                	add    %ecx,%eax
8010a068:	0f b6 00             	movzbl (%eax),%eax
8010a06b:	0f b6 c0             	movzbl %al,%eax
8010a06e:	01 d0                	add    %edx,%eax
8010a070:	01 45 fc             	add    %eax,-0x4(%ebp)
    if(chk_sum > 0xFFFF){
8010a073:	81 7d fc ff ff 00 00 	cmpl   $0xffff,-0x4(%ebp)
8010a07a:	76 0c                	jbe    8010a088 <icmp_chksum+0x60>
      chk_sum = (chk_sum&0xFFFF)+1;
8010a07c:	8b 45 fc             	mov    -0x4(%ebp),%eax
8010a07f:	0f b7 c0             	movzwl %ax,%eax
8010a082:	83 c0 01             	add    $0x1,%eax
8010a085:	89 45 fc             	mov    %eax,-0x4(%ebp)
  for(int i=0;i<32;i++){
8010a088:	83 45 f8 01          	addl   $0x1,-0x8(%ebp)
8010a08c:	83 7d f8 1f          	cmpl   $0x1f,-0x8(%ebp)
8010a090:	7e b2                	jle    8010a044 <icmp_chksum+0x1c>
    }
  }
  return ~(chk_sum);
8010a092:	8b 45 fc             	mov    -0x4(%ebp),%eax
8010a095:	f7 d0                	not    %eax
}
8010a097:	c9                   	leave  
8010a098:	c3                   	ret    

8010a099 <tcp_proc>:
extern ushort send_id;
extern uchar mac_addr[6];
extern uchar my_ip[4];
int fin_flag = 0;

void tcp_proc(uint buffer_addr){
8010a099:	55                   	push   %ebp
8010a09a:	89 e5                	mov    %esp,%ebp
8010a09c:	83 ec 38             	sub    $0x38,%esp
  struct ipv4_pkt *ipv4_p = (struct ipv4_pkt *)(buffer_addr + sizeof(struct eth_pkt));
8010a09f:	8b 45 08             	mov    0x8(%ebp),%eax
8010a0a2:	83 c0 0e             	add    $0xe,%eax
8010a0a5:	89 45 f4             	mov    %eax,-0xc(%ebp)
  struct tcp_pkt *tcp_p = (struct tcp_pkt *)((uint)ipv4_p + (ipv4_p->ver&0xF)*4);
8010a0a8:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010a0ab:	0f b6 00             	movzbl (%eax),%eax
8010a0ae:	0f b6 c0             	movzbl %al,%eax
8010a0b1:	83 e0 0f             	and    $0xf,%eax
8010a0b4:	c1 e0 02             	shl    $0x2,%eax
8010a0b7:	89 c2                	mov    %eax,%edx
8010a0b9:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010a0bc:	01 d0                	add    %edx,%eax
8010a0be:	89 45 f0             	mov    %eax,-0x10(%ebp)
  char *payload = (char *)((uint)tcp_p + 20);
8010a0c1:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010a0c4:	83 c0 14             	add    $0x14,%eax
8010a0c7:	89 45 ec             	mov    %eax,-0x14(%ebp)
  uint send_addr = (uint)kalloc();
8010a0ca:	e8 b5 8b ff ff       	call   80102c84 <kalloc>
8010a0cf:	89 45 e8             	mov    %eax,-0x18(%ebp)
  uint send_size = 0;
8010a0d2:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
  if(tcp_p->code_bits[1]&TCP_CODEBITS_SYN){
8010a0d9:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010a0dc:	0f b6 40 0d          	movzbl 0xd(%eax),%eax
8010a0e0:	0f b6 c0             	movzbl %al,%eax
8010a0e3:	83 e0 02             	and    $0x2,%eax
8010a0e6:	85 c0                	test   %eax,%eax
8010a0e8:	74 3d                	je     8010a127 <tcp_proc+0x8e>
    tcp_pkt_create(buffer_addr,send_addr,&send_size,TCP_CODEBITS_ACK | TCP_CODEBITS_SYN,0);
8010a0ea:	83 ec 0c             	sub    $0xc,%esp
8010a0ed:	6a 00                	push   $0x0
8010a0ef:	6a 12                	push   $0x12
8010a0f1:	8d 45 dc             	lea    -0x24(%ebp),%eax
8010a0f4:	50                   	push   %eax
8010a0f5:	ff 75 e8             	push   -0x18(%ebp)
8010a0f8:	ff 75 08             	push   0x8(%ebp)
8010a0fb:	e8 a2 01 00 00       	call   8010a2a2 <tcp_pkt_create>
8010a100:	83 c4 20             	add    $0x20,%esp
    i8254_send(send_addr,send_size);
8010a103:	8b 45 dc             	mov    -0x24(%ebp),%eax
8010a106:	83 ec 08             	sub    $0x8,%esp
8010a109:	50                   	push   %eax
8010a10a:	ff 75 e8             	push   -0x18(%ebp)
8010a10d:	e8 61 f1 ff ff       	call   80109273 <i8254_send>
8010a112:	83 c4 10             	add    $0x10,%esp
    seq_num++;
8010a115:	a1 a4 a1 11 80       	mov    0x8011a1a4,%eax
8010a11a:	83 c0 01             	add    $0x1,%eax
8010a11d:	a3 a4 a1 11 80       	mov    %eax,0x8011a1a4
8010a122:	e9 69 01 00 00       	jmp    8010a290 <tcp_proc+0x1f7>
  }else if(tcp_p->code_bits[1] == (TCP_CODEBITS_PSH | TCP_CODEBITS_ACK)){
8010a127:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010a12a:	0f b6 40 0d          	movzbl 0xd(%eax),%eax
8010a12e:	3c 18                	cmp    $0x18,%al
8010a130:	0f 85 10 01 00 00    	jne    8010a246 <tcp_proc+0x1ad>
    if(memcmp(payload,"GET",3)){
8010a136:	83 ec 04             	sub    $0x4,%esp
8010a139:	6a 03                	push   $0x3
8010a13b:	68 9e c6 10 80       	push   $0x8010c69e
8010a140:	ff 75 ec             	push   -0x14(%ebp)
8010a143:	e8 32 b0 ff ff       	call   8010517a <memcmp>
8010a148:	83 c4 10             	add    $0x10,%esp
8010a14b:	85 c0                	test   %eax,%eax
8010a14d:	74 74                	je     8010a1c3 <tcp_proc+0x12a>
      cprintf("ACK PSH\n");
8010a14f:	83 ec 0c             	sub    $0xc,%esp
8010a152:	68 a2 c6 10 80       	push   $0x8010c6a2
8010a157:	e8 98 62 ff ff       	call   801003f4 <cprintf>
8010a15c:	83 c4 10             	add    $0x10,%esp
      tcp_pkt_create(buffer_addr,send_addr,&send_size,TCP_CODEBITS_ACK,0);
8010a15f:	83 ec 0c             	sub    $0xc,%esp
8010a162:	6a 00                	push   $0x0
8010a164:	6a 10                	push   $0x10
8010a166:	8d 45 dc             	lea    -0x24(%ebp),%eax
8010a169:	50                   	push   %eax
8010a16a:	ff 75 e8             	push   -0x18(%ebp)
8010a16d:	ff 75 08             	push   0x8(%ebp)
8010a170:	e8 2d 01 00 00       	call   8010a2a2 <tcp_pkt_create>
8010a175:	83 c4 20             	add    $0x20,%esp
      i8254_send(send_addr,send_size);
8010a178:	8b 45 dc             	mov    -0x24(%ebp),%eax
8010a17b:	83 ec 08             	sub    $0x8,%esp
8010a17e:	50                   	push   %eax
8010a17f:	ff 75 e8             	push   -0x18(%ebp)
8010a182:	e8 ec f0 ff ff       	call   80109273 <i8254_send>
8010a187:	83 c4 10             	add    $0x10,%esp
      uint send_payload = (send_addr + sizeof(struct eth_pkt) + sizeof(struct ipv4_pkt) + sizeof(struct tcp_pkt));
8010a18a:	8b 45 e8             	mov    -0x18(%ebp),%eax
8010a18d:	83 c0 36             	add    $0x36,%eax
8010a190:	89 45 e0             	mov    %eax,-0x20(%ebp)
      uint payload_size;
      http_proc(0,0,send_payload,&payload_size);
8010a193:	8d 45 d8             	lea    -0x28(%ebp),%eax
8010a196:	50                   	push   %eax
8010a197:	ff 75 e0             	push   -0x20(%ebp)
8010a19a:	6a 00                	push   $0x0
8010a19c:	6a 00                	push   $0x0
8010a19e:	e8 5a 04 00 00       	call   8010a5fd <http_proc>
8010a1a3:	83 c4 10             	add    $0x10,%esp
      tcp_pkt_create(buffer_addr,send_addr,&send_size,(TCP_CODEBITS_ACK|TCP_CODEBITS_PSH),payload_size);
8010a1a6:	8b 45 d8             	mov    -0x28(%ebp),%eax
8010a1a9:	83 ec 0c             	sub    $0xc,%esp
8010a1ac:	50                   	push   %eax
8010a1ad:	6a 18                	push   $0x18
8010a1af:	8d 45 dc             	lea    -0x24(%ebp),%eax
8010a1b2:	50                   	push   %eax
8010a1b3:	ff 75 e8             	push   -0x18(%ebp)
8010a1b6:	ff 75 08             	push   0x8(%ebp)
8010a1b9:	e8 e4 00 00 00       	call   8010a2a2 <tcp_pkt_create>
8010a1be:	83 c4 20             	add    $0x20,%esp
8010a1c1:	eb 62                	jmp    8010a225 <tcp_proc+0x18c>
    }else{
     tcp_pkt_create(buffer_addr,send_addr,&send_size,TCP_CODEBITS_ACK,0);
8010a1c3:	83 ec 0c             	sub    $0xc,%esp
8010a1c6:	6a 00                	push   $0x0
8010a1c8:	6a 10                	push   $0x10
8010a1ca:	8d 45 dc             	lea    -0x24(%ebp),%eax
8010a1cd:	50                   	push   %eax
8010a1ce:	ff 75 e8             	push   -0x18(%ebp)
8010a1d1:	ff 75 08             	push   0x8(%ebp)
8010a1d4:	e8 c9 00 00 00       	call   8010a2a2 <tcp_pkt_create>
8010a1d9:	83 c4 20             	add    $0x20,%esp
     i8254_send(send_addr,send_size);
8010a1dc:	8b 45 dc             	mov    -0x24(%ebp),%eax
8010a1df:	83 ec 08             	sub    $0x8,%esp
8010a1e2:	50                   	push   %eax
8010a1e3:	ff 75 e8             	push   -0x18(%ebp)
8010a1e6:	e8 88 f0 ff ff       	call   80109273 <i8254_send>
8010a1eb:	83 c4 10             	add    $0x10,%esp
      uint send_payload = (send_addr + sizeof(struct eth_pkt) + sizeof(struct ipv4_pkt) + sizeof(struct tcp_pkt));
8010a1ee:	8b 45 e8             	mov    -0x18(%ebp),%eax
8010a1f1:	83 c0 36             	add    $0x36,%eax
8010a1f4:	89 45 e4             	mov    %eax,-0x1c(%ebp)
      uint payload_size;
      http_proc(0,0,send_payload,&payload_size);
8010a1f7:	8d 45 d4             	lea    -0x2c(%ebp),%eax
8010a1fa:	50                   	push   %eax
8010a1fb:	ff 75 e4             	push   -0x1c(%ebp)
8010a1fe:	6a 00                	push   $0x0
8010a200:	6a 00                	push   $0x0
8010a202:	e8 f6 03 00 00       	call   8010a5fd <http_proc>
8010a207:	83 c4 10             	add    $0x10,%esp
      tcp_pkt_create(buffer_addr,send_addr,&send_size,(TCP_CODEBITS_ACK|TCP_CODEBITS_PSH),payload_size);
8010a20a:	8b 45 d4             	mov    -0x2c(%ebp),%eax
8010a20d:	83 ec 0c             	sub    $0xc,%esp
8010a210:	50                   	push   %eax
8010a211:	6a 18                	push   $0x18
8010a213:	8d 45 dc             	lea    -0x24(%ebp),%eax
8010a216:	50                   	push   %eax
8010a217:	ff 75 e8             	push   -0x18(%ebp)
8010a21a:	ff 75 08             	push   0x8(%ebp)
8010a21d:	e8 80 00 00 00       	call   8010a2a2 <tcp_pkt_create>
8010a222:	83 c4 20             	add    $0x20,%esp
    }
    i8254_send(send_addr,send_size);
8010a225:	8b 45 dc             	mov    -0x24(%ebp),%eax
8010a228:	83 ec 08             	sub    $0x8,%esp
8010a22b:	50                   	push   %eax
8010a22c:	ff 75 e8             	push   -0x18(%ebp)
8010a22f:	e8 3f f0 ff ff       	call   80109273 <i8254_send>
8010a234:	83 c4 10             	add    $0x10,%esp
    seq_num++;
8010a237:	a1 a4 a1 11 80       	mov    0x8011a1a4,%eax
8010a23c:	83 c0 01             	add    $0x1,%eax
8010a23f:	a3 a4 a1 11 80       	mov    %eax,0x8011a1a4
8010a244:	eb 4a                	jmp    8010a290 <tcp_proc+0x1f7>
  }else if(tcp_p->code_bits[1] == TCP_CODEBITS_ACK){
8010a246:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010a249:	0f b6 40 0d          	movzbl 0xd(%eax),%eax
8010a24d:	3c 10                	cmp    $0x10,%al
8010a24f:	75 3f                	jne    8010a290 <tcp_proc+0x1f7>
    if(fin_flag == 1){
8010a251:	a1 a8 a1 11 80       	mov    0x8011a1a8,%eax
8010a256:	83 f8 01             	cmp    $0x1,%eax
8010a259:	75 35                	jne    8010a290 <tcp_proc+0x1f7>
      tcp_pkt_create(buffer_addr,send_addr,&send_size,TCP_CODEBITS_FIN,0);
8010a25b:	83 ec 0c             	sub    $0xc,%esp
8010a25e:	6a 00                	push   $0x0
8010a260:	6a 01                	push   $0x1
8010a262:	8d 45 dc             	lea    -0x24(%ebp),%eax
8010a265:	50                   	push   %eax
8010a266:	ff 75 e8             	push   -0x18(%ebp)
8010a269:	ff 75 08             	push   0x8(%ebp)
8010a26c:	e8 31 00 00 00       	call   8010a2a2 <tcp_pkt_create>
8010a271:	83 c4 20             	add    $0x20,%esp
      i8254_send(send_addr,send_size);
8010a274:	8b 45 dc             	mov    -0x24(%ebp),%eax
8010a277:	83 ec 08             	sub    $0x8,%esp
8010a27a:	50                   	push   %eax
8010a27b:	ff 75 e8             	push   -0x18(%ebp)
8010a27e:	e8 f0 ef ff ff       	call   80109273 <i8254_send>
8010a283:	83 c4 10             	add    $0x10,%esp
      fin_flag = 0;
8010a286:	c7 05 a8 a1 11 80 00 	movl   $0x0,0x8011a1a8
8010a28d:	00 00 00 
    }
  }
  kfree((char *)send_addr);
8010a290:	8b 45 e8             	mov    -0x18(%ebp),%eax
8010a293:	83 ec 0c             	sub    $0xc,%esp
8010a296:	50                   	push   %eax
8010a297:	e8 4e 89 ff ff       	call   80102bea <kfree>
8010a29c:	83 c4 10             	add    $0x10,%esp
}
8010a29f:	90                   	nop
8010a2a0:	c9                   	leave  
8010a2a1:	c3                   	ret    

8010a2a2 <tcp_pkt_create>:

void tcp_pkt_create(uint recv_addr,uint send_addr,uint *send_size,uint pkt_type,uint payload_size){
8010a2a2:	55                   	push   %ebp
8010a2a3:	89 e5                	mov    %esp,%ebp
8010a2a5:	83 ec 28             	sub    $0x28,%esp
  struct eth_pkt *eth_recv = (struct eth_pkt *)(recv_addr);
8010a2a8:	8b 45 08             	mov    0x8(%ebp),%eax
8010a2ab:	89 45 f4             	mov    %eax,-0xc(%ebp)
  struct ipv4_pkt *ipv4_recv = (struct ipv4_pkt *)(recv_addr+sizeof(struct eth_pkt));
8010a2ae:	8b 45 08             	mov    0x8(%ebp),%eax
8010a2b1:	83 c0 0e             	add    $0xe,%eax
8010a2b4:	89 45 f0             	mov    %eax,-0x10(%ebp)
  struct tcp_pkt *tcp_recv = (struct tcp_pkt *)((uint)ipv4_recv + (ipv4_recv->ver&0xF)*4);
8010a2b7:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010a2ba:	0f b6 00             	movzbl (%eax),%eax
8010a2bd:	0f b6 c0             	movzbl %al,%eax
8010a2c0:	83 e0 0f             	and    $0xf,%eax
8010a2c3:	c1 e0 02             	shl    $0x2,%eax
8010a2c6:	89 c2                	mov    %eax,%edx
8010a2c8:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010a2cb:	01 d0                	add    %edx,%eax
8010a2cd:	89 45 ec             	mov    %eax,-0x14(%ebp)

  struct eth_pkt *eth_send = (struct eth_pkt *)(send_addr);
8010a2d0:	8b 45 0c             	mov    0xc(%ebp),%eax
8010a2d3:	89 45 e8             	mov    %eax,-0x18(%ebp)
  struct ipv4_pkt *ipv4_send = (struct ipv4_pkt *)(send_addr + sizeof(struct eth_pkt));
8010a2d6:	8b 45 0c             	mov    0xc(%ebp),%eax
8010a2d9:	83 c0 0e             	add    $0xe,%eax
8010a2dc:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  struct tcp_pkt *tcp_send = (struct tcp_pkt *)((uint)ipv4_send + sizeof(struct ipv4_pkt));
8010a2df:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010a2e2:	83 c0 14             	add    $0x14,%eax
8010a2e5:	89 45 e0             	mov    %eax,-0x20(%ebp)

  *send_size = sizeof(struct eth_pkt) + sizeof(struct ipv4_pkt) + sizeof(struct tcp_pkt) + payload_size;
8010a2e8:	8b 45 18             	mov    0x18(%ebp),%eax
8010a2eb:	8d 50 36             	lea    0x36(%eax),%edx
8010a2ee:	8b 45 10             	mov    0x10(%ebp),%eax
8010a2f1:	89 10                	mov    %edx,(%eax)

  memmove(eth_send->dst_mac,eth_recv->src_mac,6);
8010a2f3:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010a2f6:	8d 50 06             	lea    0x6(%eax),%edx
8010a2f9:	8b 45 e8             	mov    -0x18(%ebp),%eax
8010a2fc:	83 ec 04             	sub    $0x4,%esp
8010a2ff:	6a 06                	push   $0x6
8010a301:	52                   	push   %edx
8010a302:	50                   	push   %eax
8010a303:	e8 ca ae ff ff       	call   801051d2 <memmove>
8010a308:	83 c4 10             	add    $0x10,%esp
  memmove(eth_send->src_mac,mac_addr,6);
8010a30b:	8b 45 e8             	mov    -0x18(%ebp),%eax
8010a30e:	83 c0 06             	add    $0x6,%eax
8010a311:	83 ec 04             	sub    $0x4,%esp
8010a314:	6a 06                	push   $0x6
8010a316:	68 c0 9e 11 80       	push   $0x80119ec0
8010a31b:	50                   	push   %eax
8010a31c:	e8 b1 ae ff ff       	call   801051d2 <memmove>
8010a321:	83 c4 10             	add    $0x10,%esp
  eth_send->type[0] = 0x08;
8010a324:	8b 45 e8             	mov    -0x18(%ebp),%eax
8010a327:	c6 40 0c 08          	movb   $0x8,0xc(%eax)
  eth_send->type[1] = 0x00;
8010a32b:	8b 45 e8             	mov    -0x18(%ebp),%eax
8010a32e:	c6 40 0d 00          	movb   $0x0,0xd(%eax)

  ipv4_send->ver = ((0x4)<<4)+((sizeof(struct ipv4_pkt)/4)&0xF);
8010a332:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010a335:	c6 00 45             	movb   $0x45,(%eax)
  ipv4_send->srv_type = 0;
8010a338:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010a33b:	c6 40 01 00          	movb   $0x0,0x1(%eax)
  ipv4_send->total_len = H2N_ushort(sizeof(struct ipv4_pkt) + sizeof(struct tcp_pkt) + payload_size);
8010a33f:	8b 45 18             	mov    0x18(%ebp),%eax
8010a342:	83 c0 28             	add    $0x28,%eax
8010a345:	0f b7 c0             	movzwl %ax,%eax
8010a348:	83 ec 0c             	sub    $0xc,%esp
8010a34b:	50                   	push   %eax
8010a34c:	e8 9b f8 ff ff       	call   80109bec <H2N_ushort>
8010a351:	83 c4 10             	add    $0x10,%esp
8010a354:	8b 55 e4             	mov    -0x1c(%ebp),%edx
8010a357:	66 89 42 02          	mov    %ax,0x2(%edx)
  ipv4_send->id = send_id;
8010a35b:	0f b7 15 a0 a1 11 80 	movzwl 0x8011a1a0,%edx
8010a362:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010a365:	66 89 50 04          	mov    %dx,0x4(%eax)
  send_id++;
8010a369:	0f b7 05 a0 a1 11 80 	movzwl 0x8011a1a0,%eax
8010a370:	83 c0 01             	add    $0x1,%eax
8010a373:	66 a3 a0 a1 11 80    	mov    %ax,0x8011a1a0
  ipv4_send->fragment = H2N_ushort(0x0000);
8010a379:	83 ec 0c             	sub    $0xc,%esp
8010a37c:	6a 00                	push   $0x0
8010a37e:	e8 69 f8 ff ff       	call   80109bec <H2N_ushort>
8010a383:	83 c4 10             	add    $0x10,%esp
8010a386:	8b 55 e4             	mov    -0x1c(%ebp),%edx
8010a389:	66 89 42 06          	mov    %ax,0x6(%edx)
  ipv4_send->ttl = 255;
8010a38d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010a390:	c6 40 08 ff          	movb   $0xff,0x8(%eax)
  ipv4_send->protocol = IPV4_TYPE_TCP;
8010a394:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010a397:	c6 40 09 06          	movb   $0x6,0x9(%eax)
  memmove(ipv4_send->src_ip,my_ip,4);
8010a39b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010a39e:	83 c0 0c             	add    $0xc,%eax
8010a3a1:	83 ec 04             	sub    $0x4,%esp
8010a3a4:	6a 04                	push   $0x4
8010a3a6:	68 04 f5 10 80       	push   $0x8010f504
8010a3ab:	50                   	push   %eax
8010a3ac:	e8 21 ae ff ff       	call   801051d2 <memmove>
8010a3b1:	83 c4 10             	add    $0x10,%esp
  memmove(ipv4_send->dst_ip,ipv4_recv->src_ip,4);
8010a3b4:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010a3b7:	8d 50 0c             	lea    0xc(%eax),%edx
8010a3ba:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010a3bd:	83 c0 10             	add    $0x10,%eax
8010a3c0:	83 ec 04             	sub    $0x4,%esp
8010a3c3:	6a 04                	push   $0x4
8010a3c5:	52                   	push   %edx
8010a3c6:	50                   	push   %eax
8010a3c7:	e8 06 ae ff ff       	call   801051d2 <memmove>
8010a3cc:	83 c4 10             	add    $0x10,%esp
  ipv4_send->chk_sum = 0;
8010a3cf:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010a3d2:	66 c7 40 0a 00 00    	movw   $0x0,0xa(%eax)
  ipv4_send->chk_sum = H2N_ushort(ipv4_chksum((uint)ipv4_send));
8010a3d8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010a3db:	83 ec 0c             	sub    $0xc,%esp
8010a3de:	50                   	push   %eax
8010a3df:	e8 08 f9 ff ff       	call   80109cec <ipv4_chksum>
8010a3e4:	83 c4 10             	add    $0x10,%esp
8010a3e7:	0f b7 c0             	movzwl %ax,%eax
8010a3ea:	83 ec 0c             	sub    $0xc,%esp
8010a3ed:	50                   	push   %eax
8010a3ee:	e8 f9 f7 ff ff       	call   80109bec <H2N_ushort>
8010a3f3:	83 c4 10             	add    $0x10,%esp
8010a3f6:	8b 55 e4             	mov    -0x1c(%ebp),%edx
8010a3f9:	66 89 42 0a          	mov    %ax,0xa(%edx)
  

  tcp_send->src_port = tcp_recv->dst_port;
8010a3fd:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010a400:	0f b7 50 02          	movzwl 0x2(%eax),%edx
8010a404:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010a407:	66 89 10             	mov    %dx,(%eax)
  tcp_send->dst_port = tcp_recv->src_port;
8010a40a:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010a40d:	0f b7 10             	movzwl (%eax),%edx
8010a410:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010a413:	66 89 50 02          	mov    %dx,0x2(%eax)
  tcp_send->seq_num = H2N_uint(seq_num);
8010a417:	a1 a4 a1 11 80       	mov    0x8011a1a4,%eax
8010a41c:	83 ec 0c             	sub    $0xc,%esp
8010a41f:	50                   	push   %eax
8010a420:	e8 e9 f7 ff ff       	call   80109c0e <H2N_uint>
8010a425:	83 c4 10             	add    $0x10,%esp
8010a428:	8b 55 e0             	mov    -0x20(%ebp),%edx
8010a42b:	89 42 04             	mov    %eax,0x4(%edx)
  tcp_send->ack_num = tcp_recv->seq_num + (1<<(8*3));
8010a42e:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010a431:	8b 40 04             	mov    0x4(%eax),%eax
8010a434:	8d 90 00 00 00 01    	lea    0x1000000(%eax),%edx
8010a43a:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010a43d:	89 50 08             	mov    %edx,0x8(%eax)

  tcp_send->code_bits[0] = 0;
8010a440:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010a443:	c6 40 0c 00          	movb   $0x0,0xc(%eax)
  tcp_send->code_bits[1] = 0;
8010a447:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010a44a:	c6 40 0d 00          	movb   $0x0,0xd(%eax)
  tcp_send->code_bits[0] = 5<<4;
8010a44e:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010a451:	c6 40 0c 50          	movb   $0x50,0xc(%eax)
  tcp_send->code_bits[1] = pkt_type;
8010a455:	8b 45 14             	mov    0x14(%ebp),%eax
8010a458:	89 c2                	mov    %eax,%edx
8010a45a:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010a45d:	88 50 0d             	mov    %dl,0xd(%eax)

  tcp_send->window = H2N_ushort(14480);
8010a460:	83 ec 0c             	sub    $0xc,%esp
8010a463:	68 90 38 00 00       	push   $0x3890
8010a468:	e8 7f f7 ff ff       	call   80109bec <H2N_ushort>
8010a46d:	83 c4 10             	add    $0x10,%esp
8010a470:	8b 55 e0             	mov    -0x20(%ebp),%edx
8010a473:	66 89 42 0e          	mov    %ax,0xe(%edx)
  tcp_send->urgent_ptr = 0;
8010a477:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010a47a:	66 c7 40 12 00 00    	movw   $0x0,0x12(%eax)
  tcp_send->chk_sum = 0;
8010a480:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010a483:	66 c7 40 10 00 00    	movw   $0x0,0x10(%eax)

  tcp_send->chk_sum = H2N_ushort(tcp_chksum((uint)(ipv4_send))+8);
8010a489:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010a48c:	83 ec 0c             	sub    $0xc,%esp
8010a48f:	50                   	push   %eax
8010a490:	e8 1f 00 00 00       	call   8010a4b4 <tcp_chksum>
8010a495:	83 c4 10             	add    $0x10,%esp
8010a498:	83 c0 08             	add    $0x8,%eax
8010a49b:	0f b7 c0             	movzwl %ax,%eax
8010a49e:	83 ec 0c             	sub    $0xc,%esp
8010a4a1:	50                   	push   %eax
8010a4a2:	e8 45 f7 ff ff       	call   80109bec <H2N_ushort>
8010a4a7:	83 c4 10             	add    $0x10,%esp
8010a4aa:	8b 55 e0             	mov    -0x20(%ebp),%edx
8010a4ad:	66 89 42 10          	mov    %ax,0x10(%edx)


}
8010a4b1:	90                   	nop
8010a4b2:	c9                   	leave  
8010a4b3:	c3                   	ret    

8010a4b4 <tcp_chksum>:

ushort tcp_chksum(uint tcp_addr){
8010a4b4:	55                   	push   %ebp
8010a4b5:	89 e5                	mov    %esp,%ebp
8010a4b7:	83 ec 38             	sub    $0x38,%esp
  struct ipv4_pkt *ipv4_p = (struct ipv4_pkt *)(tcp_addr);
8010a4ba:	8b 45 08             	mov    0x8(%ebp),%eax
8010a4bd:	89 45 e8             	mov    %eax,-0x18(%ebp)
  struct tcp_pkt *tcp_p = (struct tcp_pkt *)((uint)ipv4_p + sizeof(struct ipv4_pkt));
8010a4c0:	8b 45 e8             	mov    -0x18(%ebp),%eax
8010a4c3:	83 c0 14             	add    $0x14,%eax
8010a4c6:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  struct tcp_dummy tcp_dummy;
  
  memmove(tcp_dummy.src_ip,my_ip,4);
8010a4c9:	83 ec 04             	sub    $0x4,%esp
8010a4cc:	6a 04                	push   $0x4
8010a4ce:	68 04 f5 10 80       	push   $0x8010f504
8010a4d3:	8d 45 d4             	lea    -0x2c(%ebp),%eax
8010a4d6:	50                   	push   %eax
8010a4d7:	e8 f6 ac ff ff       	call   801051d2 <memmove>
8010a4dc:	83 c4 10             	add    $0x10,%esp
  memmove(tcp_dummy.dst_ip,ipv4_p->src_ip,4);
8010a4df:	8b 45 e8             	mov    -0x18(%ebp),%eax
8010a4e2:	83 c0 0c             	add    $0xc,%eax
8010a4e5:	83 ec 04             	sub    $0x4,%esp
8010a4e8:	6a 04                	push   $0x4
8010a4ea:	50                   	push   %eax
8010a4eb:	8d 45 d4             	lea    -0x2c(%ebp),%eax
8010a4ee:	83 c0 04             	add    $0x4,%eax
8010a4f1:	50                   	push   %eax
8010a4f2:	e8 db ac ff ff       	call   801051d2 <memmove>
8010a4f7:	83 c4 10             	add    $0x10,%esp
  tcp_dummy.padding = 0;
8010a4fa:	c6 45 dc 00          	movb   $0x0,-0x24(%ebp)
  tcp_dummy.protocol = IPV4_TYPE_TCP;
8010a4fe:	c6 45 dd 06          	movb   $0x6,-0x23(%ebp)
  tcp_dummy.tcp_len = H2N_ushort(N2H_ushort(ipv4_p->total_len) - sizeof(struct ipv4_pkt));
8010a502:	8b 45 e8             	mov    -0x18(%ebp),%eax
8010a505:	0f b7 40 02          	movzwl 0x2(%eax),%eax
8010a509:	0f b7 c0             	movzwl %ax,%eax
8010a50c:	83 ec 0c             	sub    $0xc,%esp
8010a50f:	50                   	push   %eax
8010a510:	e8 b5 f6 ff ff       	call   80109bca <N2H_ushort>
8010a515:	83 c4 10             	add    $0x10,%esp
8010a518:	83 e8 14             	sub    $0x14,%eax
8010a51b:	0f b7 c0             	movzwl %ax,%eax
8010a51e:	83 ec 0c             	sub    $0xc,%esp
8010a521:	50                   	push   %eax
8010a522:	e8 c5 f6 ff ff       	call   80109bec <H2N_ushort>
8010a527:	83 c4 10             	add    $0x10,%esp
8010a52a:	66 89 45 de          	mov    %ax,-0x22(%ebp)
  uint chk_sum = 0;
8010a52e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  uchar *bin = (uchar *)(&tcp_dummy);
8010a535:	8d 45 d4             	lea    -0x2c(%ebp),%eax
8010a538:	89 45 e0             	mov    %eax,-0x20(%ebp)
  for(int i=0;i<6;i++){
8010a53b:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
8010a542:	eb 33                	jmp    8010a577 <tcp_chksum+0xc3>
    chk_sum += (bin[i*2]<<8)+bin[i*2+1];
8010a544:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010a547:	01 c0                	add    %eax,%eax
8010a549:	89 c2                	mov    %eax,%edx
8010a54b:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010a54e:	01 d0                	add    %edx,%eax
8010a550:	0f b6 00             	movzbl (%eax),%eax
8010a553:	0f b6 c0             	movzbl %al,%eax
8010a556:	c1 e0 08             	shl    $0x8,%eax
8010a559:	89 c2                	mov    %eax,%edx
8010a55b:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010a55e:	01 c0                	add    %eax,%eax
8010a560:	8d 48 01             	lea    0x1(%eax),%ecx
8010a563:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010a566:	01 c8                	add    %ecx,%eax
8010a568:	0f b6 00             	movzbl (%eax),%eax
8010a56b:	0f b6 c0             	movzbl %al,%eax
8010a56e:	01 d0                	add    %edx,%eax
8010a570:	01 45 f4             	add    %eax,-0xc(%ebp)
  for(int i=0;i<6;i++){
8010a573:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
8010a577:	83 7d f0 05          	cmpl   $0x5,-0x10(%ebp)
8010a57b:	7e c7                	jle    8010a544 <tcp_chksum+0x90>
  }

  bin = (uchar *)(tcp_p);
8010a57d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010a580:	89 45 e0             	mov    %eax,-0x20(%ebp)
  for(int i=0;i<(N2H_ushort(tcp_dummy.tcp_len)/2);i++){
8010a583:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
8010a58a:	eb 33                	jmp    8010a5bf <tcp_chksum+0x10b>
    chk_sum += (bin[i*2]<<8)+bin[i*2+1];
8010a58c:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010a58f:	01 c0                	add    %eax,%eax
8010a591:	89 c2                	mov    %eax,%edx
8010a593:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010a596:	01 d0                	add    %edx,%eax
8010a598:	0f b6 00             	movzbl (%eax),%eax
8010a59b:	0f b6 c0             	movzbl %al,%eax
8010a59e:	c1 e0 08             	shl    $0x8,%eax
8010a5a1:	89 c2                	mov    %eax,%edx
8010a5a3:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010a5a6:	01 c0                	add    %eax,%eax
8010a5a8:	8d 48 01             	lea    0x1(%eax),%ecx
8010a5ab:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010a5ae:	01 c8                	add    %ecx,%eax
8010a5b0:	0f b6 00             	movzbl (%eax),%eax
8010a5b3:	0f b6 c0             	movzbl %al,%eax
8010a5b6:	01 d0                	add    %edx,%eax
8010a5b8:	01 45 f4             	add    %eax,-0xc(%ebp)
  for(int i=0;i<(N2H_ushort(tcp_dummy.tcp_len)/2);i++){
8010a5bb:	83 45 ec 01          	addl   $0x1,-0x14(%ebp)
8010a5bf:	0f b7 45 de          	movzwl -0x22(%ebp),%eax
8010a5c3:	0f b7 c0             	movzwl %ax,%eax
8010a5c6:	83 ec 0c             	sub    $0xc,%esp
8010a5c9:	50                   	push   %eax
8010a5ca:	e8 fb f5 ff ff       	call   80109bca <N2H_ushort>
8010a5cf:	83 c4 10             	add    $0x10,%esp
8010a5d2:	66 d1 e8             	shr    %ax
8010a5d5:	0f b7 c0             	movzwl %ax,%eax
8010a5d8:	39 45 ec             	cmp    %eax,-0x14(%ebp)
8010a5db:	7c af                	jl     8010a58c <tcp_chksum+0xd8>
  }
  chk_sum += (chk_sum>>8*2);
8010a5dd:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010a5e0:	c1 e8 10             	shr    $0x10,%eax
8010a5e3:	01 45 f4             	add    %eax,-0xc(%ebp)
  return ~(chk_sum);
8010a5e6:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010a5e9:	f7 d0                	not    %eax
}
8010a5eb:	c9                   	leave  
8010a5ec:	c3                   	ret    

8010a5ed <tcp_fin>:

void tcp_fin(){
8010a5ed:	55                   	push   %ebp
8010a5ee:	89 e5                	mov    %esp,%ebp
  fin_flag =1;
8010a5f0:	c7 05 a8 a1 11 80 01 	movl   $0x1,0x8011a1a8
8010a5f7:	00 00 00 
}
8010a5fa:	90                   	nop
8010a5fb:	5d                   	pop    %ebp
8010a5fc:	c3                   	ret    

8010a5fd <http_proc>:
#include "defs.h"
#include "types.h"
#include "tcp.h"


void http_proc(uint recv, uint recv_size, uint send, uint *send_size){
8010a5fd:	55                   	push   %ebp
8010a5fe:	89 e5                	mov    %esp,%ebp
8010a600:	83 ec 18             	sub    $0x18,%esp
  int len;
  len = http_strcpy((char *)send,"HTTP/1.0 200 OK \r\n",0);
8010a603:	8b 45 10             	mov    0x10(%ebp),%eax
8010a606:	83 ec 04             	sub    $0x4,%esp
8010a609:	6a 00                	push   $0x0
8010a60b:	68 ab c6 10 80       	push   $0x8010c6ab
8010a610:	50                   	push   %eax
8010a611:	e8 65 00 00 00       	call   8010a67b <http_strcpy>
8010a616:	83 c4 10             	add    $0x10,%esp
8010a619:	89 45 f4             	mov    %eax,-0xc(%ebp)
  len += http_strcpy((char *)send,"Content-Type: text/html \r\n",len);
8010a61c:	8b 45 10             	mov    0x10(%ebp),%eax
8010a61f:	83 ec 04             	sub    $0x4,%esp
8010a622:	ff 75 f4             	push   -0xc(%ebp)
8010a625:	68 be c6 10 80       	push   $0x8010c6be
8010a62a:	50                   	push   %eax
8010a62b:	e8 4b 00 00 00       	call   8010a67b <http_strcpy>
8010a630:	83 c4 10             	add    $0x10,%esp
8010a633:	01 45 f4             	add    %eax,-0xc(%ebp)
  len += http_strcpy((char *)send,"\r\nHello World!\r\n",len);
8010a636:	8b 45 10             	mov    0x10(%ebp),%eax
8010a639:	83 ec 04             	sub    $0x4,%esp
8010a63c:	ff 75 f4             	push   -0xc(%ebp)
8010a63f:	68 d9 c6 10 80       	push   $0x8010c6d9
8010a644:	50                   	push   %eax
8010a645:	e8 31 00 00 00       	call   8010a67b <http_strcpy>
8010a64a:	83 c4 10             	add    $0x10,%esp
8010a64d:	01 45 f4             	add    %eax,-0xc(%ebp)
  if(len%2 != 0){
8010a650:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010a653:	83 e0 01             	and    $0x1,%eax
8010a656:	85 c0                	test   %eax,%eax
8010a658:	74 11                	je     8010a66b <http_proc+0x6e>
    char *payload = (char *)send;
8010a65a:	8b 45 10             	mov    0x10(%ebp),%eax
8010a65d:	89 45 f0             	mov    %eax,-0x10(%ebp)
    payload[len] = 0;
8010a660:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010a663:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010a666:	01 d0                	add    %edx,%eax
8010a668:	c6 00 00             	movb   $0x0,(%eax)
  }
  *send_size = len;
8010a66b:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010a66e:	8b 45 14             	mov    0x14(%ebp),%eax
8010a671:	89 10                	mov    %edx,(%eax)
  tcp_fin();
8010a673:	e8 75 ff ff ff       	call   8010a5ed <tcp_fin>
}
8010a678:	90                   	nop
8010a679:	c9                   	leave  
8010a67a:	c3                   	ret    

8010a67b <http_strcpy>:

int http_strcpy(char *dst,const char *src,int start_index){
8010a67b:	55                   	push   %ebp
8010a67c:	89 e5                	mov    %esp,%ebp
8010a67e:	83 ec 10             	sub    $0x10,%esp
  int i = 0;
8010a681:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while(src[i]){
8010a688:	eb 20                	jmp    8010a6aa <http_strcpy+0x2f>
    dst[start_index+i] = src[i];
8010a68a:	8b 55 fc             	mov    -0x4(%ebp),%edx
8010a68d:	8b 45 0c             	mov    0xc(%ebp),%eax
8010a690:	01 d0                	add    %edx,%eax
8010a692:	8b 4d 10             	mov    0x10(%ebp),%ecx
8010a695:	8b 55 fc             	mov    -0x4(%ebp),%edx
8010a698:	01 ca                	add    %ecx,%edx
8010a69a:	89 d1                	mov    %edx,%ecx
8010a69c:	8b 55 08             	mov    0x8(%ebp),%edx
8010a69f:	01 ca                	add    %ecx,%edx
8010a6a1:	0f b6 00             	movzbl (%eax),%eax
8010a6a4:	88 02                	mov    %al,(%edx)
    i++;
8010a6a6:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
  while(src[i]){
8010a6aa:	8b 55 fc             	mov    -0x4(%ebp),%edx
8010a6ad:	8b 45 0c             	mov    0xc(%ebp),%eax
8010a6b0:	01 d0                	add    %edx,%eax
8010a6b2:	0f b6 00             	movzbl (%eax),%eax
8010a6b5:	84 c0                	test   %al,%al
8010a6b7:	75 d1                	jne    8010a68a <http_strcpy+0xf>
  }
  return i;
8010a6b9:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
8010a6bc:	c9                   	leave  
8010a6bd:	c3                   	ret    
