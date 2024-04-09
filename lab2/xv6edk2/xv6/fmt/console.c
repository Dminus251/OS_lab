8100 // Console input and output.
8101 // Input is from the keyboard or serial port.
8102 // Output is written to the screen and serial port.
8103 
8104 #include "types.h"
8105 #include "defs.h"
8106 #include "param.h"
8107 #include "traps.h"
8108 #include "spinlock.h"
8109 #include "sleeplock.h"
8110 #include "fs.h"
8111 #include "file.h"
8112 #include "memlayout.h"
8113 #include "mmu.h"
8114 #include "proc.h"
8115 #include "x86.h"
8116 #include "font.h"
8117 #include "graphic.h"
8118 
8119 static void consputc(int);
8120 
8121 static int panicked = 0;
8122 
8123 static struct {
8124   struct spinlock lock;
8125   int locking;
8126 } cons;
8127 
8128 static void
8129 printint(int xx, int base, int sign)
8130 {
8131   static char digits[] = "0123456789abcdef";
8132   char buf[16];
8133   int i;
8134   uint x;
8135 
8136   if(sign && (sign = xx < 0))
8137     x = -xx;
8138   else
8139     x = xx;
8140 
8141   i = 0;
8142   do{
8143     buf[i++] = digits[x % base];
8144   }while((x /= base) != 0);
8145 
8146   if(sign)
8147     buf[i++] = '-';
8148 
8149 
8150   while(--i >= 0)
8151     consputc(buf[i]);
8152 }
8153 
8154 
8155 
8156 
8157 
8158 
8159 
8160 
8161 
8162 
8163 
8164 
8165 
8166 
8167 
8168 
8169 
8170 
8171 
8172 
8173 
8174 
8175 
8176 
8177 
8178 
8179 
8180 
8181 
8182 
8183 
8184 
8185 
8186 
8187 
8188 
8189 
8190 
8191 
8192 
8193 
8194 
8195 
8196 
8197 
8198 
8199 
8200 // Print to the console. only understands %d, %x, %p, %s.
8201 void
8202 cprintf(char *fmt, ...)
8203 {
8204   int i, c, locking;
8205   uint *argp;
8206   char *s;
8207 
8208   locking = cons.locking;
8209   if(locking)
8210     acquire(&cons.lock);
8211 
8212   if (fmt == 0)
8213     panic("null fmt");
8214 
8215 
8216   argp = (uint*)(void*)(&fmt + 1);
8217   for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
8218     if(c != '%'){
8219       consputc(c);
8220       continue;
8221     }
8222     c = fmt[++i] & 0xff;
8223     if(c == 0)
8224       break;
8225     switch(c){
8226     case 'd':
8227       printint(*argp++, 10, 1);
8228       break;
8229     case 'x':
8230     case 'p':
8231       printint(*argp++, 16, 0);
8232       break;
8233     case 's':
8234       if((s = (char*)*argp++) == 0)
8235         s = "(null)";
8236       for(; *s; s++)
8237         consputc(*s);
8238       break;
8239     case '%':
8240       consputc('%');
8241       break;
8242     default:
8243       // Print unknown % sequence to draw attention.
8244       consputc('%');
8245       consputc(c);
8246       break;
8247     }
8248   }
8249 
8250   if(locking)
8251     release(&cons.lock);
8252 }
8253 
8254 void
8255 panic(char *s)
8256 {
8257   int i;
8258   uint pcs[10];
8259 
8260   cli();
8261   cons.locking = 0;
8262   // use lapiccpunum so that we can call panic from mycpu()
8263   cprintf("lapicid %d: panic: ", lapicid());
8264   cprintf(s);
8265   cprintf("\n");
8266   getcallerpcs(&s, pcs);
8267   for(i=0; i<10; i++)
8268     cprintf(" %p", pcs[i]);
8269   panicked = 1; // freeze other CPU
8270   for(;;)
8271     ;
8272 }
8273 
8274 
8275 
8276 
8277 
8278 
8279 
8280 
8281 
8282 
8283 
8284 
8285 
8286 
8287 
8288 
8289 
8290 
8291 
8292 
8293 
8294 
8295 
8296 
8297 
8298 
8299 
8300 #define BACKSPACE 0x100
8301 #define CRTPORT 0x3d4
8302 /*static ushort *crt = (ushort*)P2V(0xb8000);  // CGA memory
8303 
8304 static void
8305 cgaputc(int c)
8306 {
8307   int pos;
8308 
8309   // Cursor position: col + 80*row.
8310   outb(CRTPORT, 14);
8311   pos = inb(CRTPORT+1) << 8;
8312   outb(CRTPORT, 15);
8313   pos |= inb(CRTPORT+1);
8314 
8315   if(c == '\n')
8316     pos += 80 - pos%80;
8317   else if(c == BACKSPACE){
8318     if(pos > 0) --pos;
8319   } else
8320     crt[pos++] = (c&0xff) | 0x0700;  // black on white
8321 
8322   if(pos < 0 || pos > 25*80)
8323     panic("pos under/overflow");
8324 
8325   if((pos/80) >= 24){  // Scroll up.
8326     memmove(crt, crt+80, sizeof(crt[0])*23*80);
8327     pos -= 80;
8328     memset(crt+pos, 0, sizeof(crt[0])*(24*80 - pos));
8329   }
8330 
8331   outb(CRTPORT, 14);
8332   outb(CRTPORT+1, pos>>8);
8333   outb(CRTPORT, 15);
8334   outb(CRTPORT+1, pos);
8335   crt[pos] = ' ' | 0x0700;
8336 }*/
8337 
8338 
8339 #define CONSOLE_HORIZONTAL_MAX 53
8340 #define CONSOLE_VERTICAL_MAX 20
8341 int console_pos = CONSOLE_HORIZONTAL_MAX*(CONSOLE_VERTICAL_MAX);
8342 //int console_pos = 0;
8343 void graphic_putc(int c){
8344   if(c == '\n'){
8345     console_pos += CONSOLE_HORIZONTAL_MAX - console_pos%CONSOLE_HORIZONTAL_MAX;
8346     if(console_pos >= CONSOLE_VERTICAL_MAX * CONSOLE_HORIZONTAL_MAX){
8347       console_pos -= CONSOLE_HORIZONTAL_MAX;
8348       graphic_scroll_up(30);
8349     }
8350   }else if(c == BACKSPACE){
8351     if(console_pos>0) --console_pos;
8352   }else{
8353     if(console_pos >= CONSOLE_VERTICAL_MAX * CONSOLE_HORIZONTAL_MAX){
8354       console_pos -= CONSOLE_HORIZONTAL_MAX;
8355       graphic_scroll_up(30);
8356     }
8357     int x = (console_pos%CONSOLE_HORIZONTAL_MAX)*FONT_WIDTH + 2;
8358     int y = (console_pos/CONSOLE_HORIZONTAL_MAX)*FONT_HEIGHT;
8359     font_render(x,y,c);
8360     console_pos++;
8361   }
8362 }
8363 
8364 
8365 void
8366 consputc(int c)
8367 {
8368   if(panicked){
8369     cli();
8370     for(;;)
8371       ;
8372   }
8373 
8374   if(c == BACKSPACE){
8375     uartputc('\b'); uartputc(' '); uartputc('\b');
8376   } else {
8377     uartputc(c);
8378   }
8379   graphic_putc(c);
8380 }
8381 
8382 #define INPUT_BUF 128
8383 struct {
8384   char buf[INPUT_BUF];
8385   uint r;  // Read index
8386   uint w;  // Write index
8387   uint e;  // Edit index
8388 } input;
8389 
8390 #define C(x)  ((x)-'@')  // Control-x
8391 
8392 void
8393 consoleintr(int (*getc)(void))
8394 {
8395   int c, doprocdump = 0;
8396 
8397   acquire(&cons.lock);
8398   while((c = getc()) >= 0){
8399     switch(c){
8400     case C('P'):  // Process listing.
8401       // procdump() locks cons.lock indirectly; invoke later
8402       doprocdump = 1;
8403       break;
8404     case C('U'):  // Kill line.
8405       while(input.e != input.w &&
8406             input.buf[(input.e-1) % INPUT_BUF] != '\n'){
8407         input.e--;
8408         consputc(BACKSPACE);
8409       }
8410       break;
8411     case C('H'): case '\x7f':  // Backspace
8412       if(input.e != input.w){
8413         input.e--;
8414         consputc(BACKSPACE);
8415       }
8416       break;
8417     default:
8418       if(c != 0 && input.e-input.r < INPUT_BUF){
8419         c = (c == '\r') ? '\n' : c;
8420         input.buf[input.e++ % INPUT_BUF] = c;
8421         consputc(c);
8422         if(c == '\n' || c == C('D') || input.e == input.r+INPUT_BUF){
8423           input.w = input.e;
8424           wakeup(&input.r);
8425         }
8426       }
8427       break;
8428     }
8429   }
8430   release(&cons.lock);
8431   if(doprocdump) {
8432     procdump();  // now call procdump() wo. cons.lock held
8433   }
8434 }
8435 
8436 
8437 
8438 
8439 
8440 
8441 
8442 
8443 
8444 
8445 
8446 
8447 
8448 
8449 
8450 int
8451 consoleread(struct inode *ip, char *dst, int n)
8452 {
8453   uint target;
8454   int c;
8455 
8456   iunlock(ip);
8457   target = n;
8458   acquire(&cons.lock);
8459   while(n > 0){
8460     while(input.r == input.w){
8461       if(myproc()->killed){
8462         release(&cons.lock);
8463         ilock(ip);
8464         return -1;
8465       }
8466       sleep(&input.r, &cons.lock);
8467     }
8468     c = input.buf[input.r++ % INPUT_BUF];
8469     if(c == C('D')){  // EOF
8470       if(n < target){
8471         // Save ^D for next time, to make sure
8472         // caller gets a 0-byte result.
8473         input.r--;
8474       }
8475       break;
8476     }
8477     *dst++ = c;
8478     --n;
8479     if(c == '\n')
8480       break;
8481   }
8482   release(&cons.lock);
8483   ilock(ip);
8484 
8485   return target - n;
8486 }
8487 
8488 
8489 
8490 
8491 
8492 
8493 
8494 
8495 
8496 
8497 
8498 
8499 
8500 int
8501 consolewrite(struct inode *ip, char *buf, int n)
8502 {
8503   int i;
8504 
8505   iunlock(ip);
8506   acquire(&cons.lock);
8507   for(i = 0; i < n; i++)
8508     consputc(buf[i] & 0xff);
8509   release(&cons.lock);
8510   ilock(ip);
8511 
8512   return n;
8513 }
8514 
8515 void
8516 consoleinit(void)
8517 {
8518   panicked = 0;
8519   initlock(&cons.lock, "console");
8520 
8521   devsw[CONSOLE].write = consolewrite;
8522   devsw[CONSOLE].read = consoleread;
8523 
8524   char *p;
8525   for(p="Starting XV6_UEFI...\n"; *p; p++)
8526     graphic_putc(*p);
8527 
8528   cons.locking = 1;
8529 
8530   ioapicenable(IRQ_KBD, 0);
8531 }
8532 
8533 
8534 
8535 
8536 
8537 
8538 
8539 
8540 
8541 
8542 
8543 
8544 
8545 
8546 
8547 
8548 
8549 
