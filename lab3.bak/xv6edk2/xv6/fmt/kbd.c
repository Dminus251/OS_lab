8050 #include "types.h"
8051 #include "x86.h"
8052 #include "defs.h"
8053 #include "kbd.h"
8054 
8055 int
8056 kbdgetc(void)
8057 {
8058   static uint shift;
8059   static uchar *charcode[4] = {
8060     normalmap, shiftmap, ctlmap, ctlmap
8061   };
8062   uint st, data, c;
8063 
8064   st = inb(KBSTATP);
8065   if((st & KBS_DIB) == 0)
8066     return -1;
8067   data = inb(KBDATAP);
8068 
8069   if(data == 0xE0){
8070     shift |= E0ESC;
8071     return 0;
8072   } else if(data & 0x80){
8073     // Key released
8074     data = (shift & E0ESC ? data : data & 0x7F);
8075     shift &= ~(shiftcode[data] | E0ESC);
8076     return 0;
8077   } else if(shift & E0ESC){
8078     // Last character was an E0 escape; or with 0x80
8079     data |= 0x80;
8080     shift &= ~E0ESC;
8081   }
8082 
8083   shift |= shiftcode[data];
8084   shift ^= togglecode[data];
8085   c = charcode[shift & (CTL | SHIFT)][data];
8086   if(shift & CAPSLOCK){
8087     if('a' <= c && c <= 'z')
8088       c += 'A' - 'a';
8089     else if('A' <= c && c <= 'Z')
8090       c += 'a' - 'A';
8091   }
8092   return c;
8093 }
8094 
8095 void
8096 kbdintr(void)
8097 {
8098   consoleintr(kbdgetc);
8099 }
