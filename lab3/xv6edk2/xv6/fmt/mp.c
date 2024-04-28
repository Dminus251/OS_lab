7400 // Multiprocessor support
7401 // Search memory for MP description structures.
7402 // http://developer.intel.com/design/pentium/datashts/24201606.pdf
7403 
7404 #include "types.h"
7405 #include "defs.h"
7406 #include "param.h"
7407 #include "memlayout.h"
7408 #include "mp.h"
7409 #include "x86.h"
7410 #include "mmu.h"
7411 #include "proc.h"
7412 
7413 struct cpu cpus[NCPU];
7414 int ncpu;
7415 uchar ioapicid;
7416 
7417 static uchar
7418 sum(uchar *addr, int len)
7419 {
7420   int i, sum;
7421 
7422   sum = 0;
7423   for(i=0; i<len; i++)
7424     sum += addr[i];
7425   return sum;
7426 }
7427 
7428 // Look for an MP structure in the len bytes at addr.
7429 static struct mp*
7430 mpsearch1(uint a, int len)
7431 {
7432   uchar *e, *p, *addr;
7433 
7434   addr = P2V(a);
7435   e = addr+len;
7436   while(1){asm("hlt");}
7437   for(p = addr; p < e; p += sizeof(struct mp))
7438     if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
7439       return (struct mp*)p;
7440   return 0;
7441 }
7442 
7443 
7444 
7445 
7446 
7447 
7448 
7449 
7450 // Search for the MP Floating Pointer Structure, which according to the
7451 // spec is in one of the following three locations:
7452 // 1) in the first KB of the EBDA;
7453 // 2) in the last KB of system base memory;
7454 // 3) in the BIOS ROM between 0xE0000 and 0xFFFFF.
7455 static struct mp*
7456 mpsearch(void)
7457 {
7458   uchar *bda;
7459   uint p;
7460   struct mp *mp;
7461 
7462   bda = (uchar *) P2V(0x400);
7463   if((p = ((bda[0x0F]<<8)| bda[0x0E]) << 4)){
7464     if((mp = mpsearch1(p, 1024)))
7465       return mp;
7466   } else {
7467     p = ((bda[0x14]<<8)|bda[0x13])*1024;
7468     if((mp = mpsearch1(p-1024, 1024)))
7469       return mp;
7470   }
7471   return mpsearch1(0xF0000, 0x10000);
7472 }
7473 
7474 // Search for an MP configuration table.  For now,
7475 // don't accept the default configurations (physaddr == 0).
7476 // Check for correct signature, calculate the checksum and,
7477 // if correct, check the version.
7478 // To do: check extended table checksum.
7479 static struct mpconf*
7480 mpconfig(struct mp **pmp)
7481 {
7482   struct mpconf *conf;
7483   struct mp *mp;
7484 
7485   if((mp = mpsearch()) == 0 || mp->physaddr == 0)
7486     return 0;
7487   conf = (struct mpconf*) P2V((uint) mp->physaddr);
7488   if(memcmp(conf, "PCMP", 4) != 0)
7489     return 0;
7490   if(conf->version != 1 && conf->version != 4)
7491     return 0;
7492   if(sum((uchar*)conf, conf->length) != 0)
7493     return 0;
7494   *pmp = mp;
7495   return conf;
7496 }
7497 
7498 
7499 
7500 void
7501 mpinit(void)
7502 {
7503   uchar *p, *e;
7504   int ismp;
7505   struct mp *mp;
7506   struct mpconf *conf;
7507   struct mpproc *proc;
7508   struct mpioapic *ioapic;
7509 
7510   if((conf = mpconfig(&mp)) == 0)
7511     panic("Expect to run on an SMP");
7512   ismp = 1;
7513   lapic = (uint*)conf->lapicaddr;
7514   for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
7515     switch(*p){
7516     case MPPROC:
7517       proc = (struct mpproc*)p;
7518       if(ncpu < NCPU) {
7519         cpus[ncpu].apicid = proc->apicid;  // apicid may differ from ncpu
7520         ncpu++;
7521       }
7522       p += sizeof(struct mpproc);
7523       continue;
7524     case MPIOAPIC:
7525       ioapic = (struct mpioapic*)p;
7526       ioapicid = ioapic->apicno;
7527       p += sizeof(struct mpioapic);
7528       continue;
7529     case MPBUS:
7530     case MPIOINTR:
7531     case MPLINTR:
7532       p += 8;
7533       continue;
7534     default:
7535       ismp = 0;
7536       break;
7537     }
7538   }
7539   if(!ismp)
7540     panic("Didn't find a suitable machine");
7541 
7542   if(mp->imcrp){
7543     // Bochs doesn't support IMCR, so this doesn't run on Bochs.
7544     // But it would on real hardware.
7545     outb(0x22, 0x70);   // Select IMCR
7546     outb(0x23, inb(0x23) | 1);  // Mask external interrupts.
7547   }
7548 }
7549 
