3500 #include "types.h"
3501 #include "defs.h"
3502 #include "param.h"
3503 #include "memlayout.h"
3504 #include "mmu.h"
3505 #include "proc.h"
3506 #include "x86.h"
3507 #include "traps.h"
3508 #include "spinlock.h"
3509 #include "i8254.h"
3510 
3511 // Interrupt descriptor table (shared by all CPUs).
3512 struct gatedesc idt[256];
3513 extern uint vectors[];  // in vectors.S: array of 256 entry pointers
3514 struct spinlock tickslock;
3515 uint ticks;
3516 
3517 void
3518 tvinit(void)
3519 {
3520   int i;
3521 
3522   for(i = 0; i < 256; i++)
3523     SETGATE(idt[i], 0, SEG_KCODE<<3, vectors[i], 0);
3524   SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
3525 
3526   initlock(&tickslock, "time");
3527 }
3528 
3529 void
3530 idtinit(void)
3531 {
3532   lidt(idt, sizeof(idt));
3533 }
3534 
3535 
3536 
3537 
3538 
3539 
3540 
3541 
3542 
3543 
3544 
3545 
3546 
3547 
3548 
3549 
3550 void
3551 trap(struct trapframe *tf)
3552 {
3553   if(tf->trapno == T_SYSCALL){
3554     if(myproc()->killed)
3555       exit();
3556     myproc()->tf = tf;
3557     syscall();
3558     if(myproc()->killed)
3559       exit();
3560     return;
3561   }
3562 
3563   switch(tf->trapno){
3564   case T_IRQ0 + IRQ_TIMER:
3565     if(cpuid() == 0){
3566       acquire(&tickslock);
3567       ticks++;
3568       wakeup(&ticks);
3569       release(&tickslock);
3570     }
3571     lapiceoi();
3572     break;
3573   case T_IRQ0 + IRQ_IDE:
3574     ideintr();
3575     lapiceoi();
3576     break;
3577   case T_IRQ0 + IRQ_IDE+1:
3578     // Bochs generates spurious IDE1 interrupts.
3579     break;
3580   case T_IRQ0 + IRQ_KBD:
3581     kbdintr();
3582     lapiceoi();
3583     break;
3584   case T_IRQ0 + IRQ_COM1:
3585     uartintr();
3586     lapiceoi();
3587     break;
3588   case T_IRQ0 + 0xB:
3589     i8254_intr();
3590     lapiceoi();
3591     break;
3592   case T_IRQ0 + IRQ_SPURIOUS:
3593     cprintf("cpu%d: spurious interrupt at %x:%x\n",
3594             cpuid(), tf->cs, tf->eip);
3595     lapiceoi();
3596     break;
3597 
3598 
3599 
3600   default:
3601     if(myproc() == 0 || (tf->cs&3) == 0){
3602       // In kernel, it must be our mistake.
3603       cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
3604               tf->trapno, cpuid(), tf->eip, rcr2());
3605       panic("trap");
3606     }
3607     // In user space, assume process misbehaved.
3608     cprintf("pid %d %s: trap %d err %d on cpu %d "
3609             "eip 0x%x addr 0x%x--kill proc\n",
3610             myproc()->pid, myproc()->name, tf->trapno,
3611             tf->err, cpuid(), tf->eip, rcr2());
3612     myproc()->killed = 1;
3613   }
3614 
3615   // Force process exit if it has been killed and is in user space.
3616   // (If it is still executing in the kernel, let it keep running
3617   // until it gets to the regular system call return.)
3618   if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
3619     exit();
3620 
3621   // Force process to give up CPU on clock tick.
3622   // If interrupts were on while locks held, would need to check nlock.
3623   if(myproc() && myproc()->state == RUNNING &&
3624      tf->trapno == T_IRQ0+IRQ_TIMER)
3625     yield();
3626 
3627   // Check if the process has been killed since we yielded
3628   if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
3629     exit();
3630 }
3631 
3632 
3633 
3634 
3635 
3636 
3637 
3638 
3639 
3640 
3641 
3642 
3643 
3644 
3645 
3646 
3647 
3648 
3649 
