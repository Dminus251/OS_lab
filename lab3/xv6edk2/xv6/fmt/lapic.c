7550 // The local APIC manages internal (non-I/O) interrupts.
7551 // See Chapter 8 & Appendix C of Intel processor manual volume 3.
7552 
7553 #include "param.h"
7554 #include "types.h"
7555 #include "defs.h"
7556 #include "date.h"
7557 #include "memlayout.h"
7558 #include "traps.h"
7559 #include "mmu.h"
7560 #include "x86.h"
7561 #include "debug.h"
7562 // Local APIC registers, divided by 4 for use as uint[] indices.
7563 #define ID      (0x0020/4)   // ID
7564 #define VER     (0x0030/4)   // Version
7565 #define TPR     (0x0080/4)   // Task Priority
7566 #define EOI     (0x00B0/4)   // EOI
7567 #define SVR     (0x00F0/4)   // Spurious Interrupt Vector
7568   #define ENABLE     0x00000100   // Unit Enable
7569 #define ESR     (0x0280/4)   // Error Status
7570 #define ICRLO   (0x0300/4)   // Interrupt Command
7571   #define INIT       0x00000500   // INIT/RESET
7572   #define STARTUP    0x00000600   // Startup IPI
7573   #define DELIVS     0x00001000   // Delivery status
7574   #define ASSERT     0x00004000   // Assert interrupt (vs deassert)
7575   #define DEASSERT   0x00000000
7576   #define LEVEL      0x00008000   // Level triggered
7577   #define BCAST      0x00080000   // Send to all APICs, including self.
7578   #define BUSY       0x00001000
7579   #define FIXED      0x00000000
7580 #define ICRHI   (0x0310/4)   // Interrupt Command [63:32]
7581 #define TIMER   (0x0320/4)   // Local Vector Table 0 (TIMER)
7582   #define X1         0x0000000B   // divide counts by 1
7583   #define PERIODIC   0x00020000   // Periodic
7584 #define PCINT   (0x0340/4)   // Performance Counter LVT
7585 #define LINT0   (0x0350/4)   // Local Vector Table 1 (LINT0)
7586 #define LINT1   (0x0360/4)   // Local Vector Table 2 (LINT1)
7587 #define ERROR   (0x0370/4)   // Local Vector Table 3 (ERROR)
7588   #define MASKED     0x00010000   // Interrupt masked
7589 #define TICR    (0x0380/4)   // Timer Initial Count
7590 #define TCCR    (0x0390/4)   // Timer Current Count
7591 #define TDCR    (0x03E0/4)   // Timer Divide Configuration
7592 
7593 volatile uint *lapic;  // Initialized in mp.c
7594 
7595 
7596 
7597 
7598 
7599 
7600 static void
7601 lapicw(int index, int value)
7602 {
7603   lapic[index] = value;
7604   lapic[ID];  // wait for write to finish, by reading
7605 }
7606 
7607 void
7608 lapicinit(void)
7609 {
7610   if(!lapic)
7611     return;
7612 
7613   // Enable local APIC; set spurious interrupt vector.
7614   lapicw(SVR, ENABLE | (T_IRQ0 + IRQ_SPURIOUS));
7615 
7616   // The timer repeatedly counts down at bus frequency
7617   // from lapic[TICR] and then issues an interrupt.
7618   // If xv6 cared more about precise timekeeping,
7619   // TICR would be calibrated using an external time source.
7620   lapicw(TDCR, X1);
7621   lapicw(TIMER, PERIODIC | (T_IRQ0 + IRQ_TIMER));
7622   lapicw(TICR, 10000000);
7623 
7624   // Disable logical interrupt lines.
7625   lapicw(LINT0, MASKED);
7626   lapicw(LINT1, MASKED);
7627 
7628   // Disable performance counter overflow interrupts
7629   // on machines that provide that interrupt entry.
7630   if(((lapic[VER]>>16) & 0xFF) >= 4)
7631     lapicw(PCINT, MASKED);
7632 
7633   // Map error interrupt to IRQ_ERROR.
7634   lapicw(ERROR, T_IRQ0 + IRQ_ERROR);
7635 
7636   // Clear error status register (requires back-to-back writes).
7637   lapicw(ESR, 0);
7638   lapicw(ESR, 0);
7639 
7640   // Ack any outstanding interrupts.
7641   lapicw(EOI, 0);
7642 
7643   // Send an Init Level De-Assert to synchronise arbitration ID's.
7644   lapicw(ICRHI, 0);
7645   lapicw(ICRLO, BCAST | INIT | LEVEL);
7646   while(lapic[ICRLO] & DELIVS)
7647     ;
7648 
7649 
7650   // Enable interrupts on the APIC (but not on the processor).
7651   lapicw(TPR, 0);
7652 }
7653 
7654 int
7655 lapicid(void)
7656 {
7657 
7658   if (!lapic){
7659     return 0;
7660   }
7661   return lapic[ID] >> 24;
7662 }
7663 
7664 // Acknowledge interrupt.
7665 void
7666 lapiceoi(void)
7667 {
7668   if(lapic)
7669     lapicw(EOI, 0);
7670 }
7671 
7672 // Spin for a given number of microseconds.
7673 // On real hardware would want to tune this dynamically.
7674 void
7675 microdelay(int us)
7676 {
7677 }
7678 
7679 #define CMOS_PORT    0x70
7680 #define CMOS_RETURN  0x71
7681 
7682 // Start additional processor running entry code at addr.
7683 // See Appendix B of MultiProcessor Specification.
7684 void
7685 lapicstartap(uchar apicid, uint addr)
7686 {
7687   int i;
7688   ushort *wrv;
7689 
7690   // "The BSP must initialize CMOS shutdown code to 0AH
7691   // and the warm reset vector (DWORD based at 40:67) to point at
7692   // the AP startup code prior to the [universal startup algorithm]."
7693   outb(CMOS_PORT, 0xF);  // offset 0xF is shutdown code
7694   outb(CMOS_PORT+1, 0x0A);
7695   wrv = (ushort*)P2V((0x40<<4 | 0x67));  // Warm reset vector
7696   wrv[0] = 0;
7697   wrv[1] = addr >> 4;
7698 
7699 
7700   // "Universal startup algorithm."
7701   // Send INIT (level-triggered) interrupt to reset other CPU.
7702   lapicw(ICRHI, apicid<<24);
7703   lapicw(ICRLO, INIT | LEVEL | ASSERT);
7704   microdelay(200);
7705   lapicw(ICRLO, INIT | LEVEL);
7706   microdelay(100);    // should be 10ms, but too slow in Bochs!
7707 
7708   // Send startup IPI (twice!) to enter code.
7709   // Regular hardware is supposed to only accept a STARTUP
7710   // when it is in the halted state due to an INIT.  So the second
7711   // should be ignored, but it is part of the official Intel algorithm.
7712   // Bochs complains about the second one.  Too bad for Bochs.
7713   for(i = 0; i < 2; i++){
7714     lapicw(ICRHI, apicid<<24);
7715     lapicw(ICRLO, STARTUP | (addr>>12));
7716     microdelay(200);
7717   }
7718 }
7719 
7720 #define CMOS_STATA   0x0a
7721 #define CMOS_STATB   0x0b
7722 #define CMOS_UIP    (1 << 7)        // RTC update in progress
7723 
7724 #define SECS    0x00
7725 #define MINS    0x02
7726 #define HOURS   0x04
7727 #define DAY     0x07
7728 #define MONTH   0x08
7729 #define YEAR    0x09
7730 
7731 static uint cmos_read(uint reg)
7732 {
7733   outb(CMOS_PORT,  reg);
7734   microdelay(200);
7735 
7736   return inb(CMOS_RETURN);
7737 }
7738 
7739 static void fill_rtcdate(struct rtcdate *r)
7740 {
7741   r->second = cmos_read(SECS);
7742   r->minute = cmos_read(MINS);
7743   r->hour   = cmos_read(HOURS);
7744   r->day    = cmos_read(DAY);
7745   r->month  = cmos_read(MONTH);
7746   r->year   = cmos_read(YEAR);
7747 }
7748 
7749 
7750 // qemu seems to use 24-hour GWT and the values are BCD encoded
7751 void cmostime(struct rtcdate *r)
7752 {
7753   struct rtcdate t1, t2;
7754   int sb, bcd;
7755 
7756   sb = cmos_read(CMOS_STATB);
7757 
7758   bcd = (sb & (1 << 2)) == 0;
7759 
7760   // make sure CMOS doesn't modify time while we read it
7761   for(;;) {
7762     fill_rtcdate(&t1);
7763     if(cmos_read(CMOS_STATA) & CMOS_UIP)
7764         continue;
7765     fill_rtcdate(&t2);
7766     if(memcmp(&t1, &t2, sizeof(t1)) == 0)
7767       break;
7768   }
7769 
7770   // convert
7771   if(bcd) {
7772 #define    CONV(x)     (t1.x = ((t1.x >> 4) * 10) + (t1.x & 0xf))
7773     CONV(second);
7774     CONV(minute);
7775     CONV(hour  );
7776     CONV(day   );
7777     CONV(month );
7778     CONV(year  );
7779 #undef     CONV
7780   }
7781 
7782   *r = t1;
7783   r->year += 2000;
7784 }
7785 
7786 
7787 
7788 
7789 
7790 
7791 
7792 
7793 
7794 
7795 
7796 
7797 
7798 
7799 
