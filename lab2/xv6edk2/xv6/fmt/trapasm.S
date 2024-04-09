3450 #include "mmu.h"
3451 
3452   # vectors.S sends all traps here.
3453 .globl alltraps
3454 alltraps:
3455   # Build trap frame.
3456   pushl %ds
3457   pushl %es
3458   pushl %fs
3459   pushl %gs
3460   pushal
3461 
3462   # Set up data segments.
3463   movw $(SEG_KDATA<<3), %ax
3464   movw %ax, %ds
3465   movw %ax, %es
3466 
3467   # Call trap(tf), where tf=%esp
3468   pushl %esp
3469   call trap
3470   addl $4, %esp
3471 
3472   # Return falls through to trapret...
3473 .globl trapret
3474 trapret:
3475   popal
3476   popl %gs
3477   popl %fs
3478   popl %es
3479   popl %ds
3480   addl $0x8, %esp  # trapno and errcode
3481   iret
3482 
3483 
3484 
3485 
3486 
3487 
3488 
3489 
3490 
3491 
3492 
3493 
3494 
3495 
3496 
3497 
3498 
3499 
