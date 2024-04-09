3350 // x86 trap and interrupt constants.
3351 
3352 // Processor-defined:
3353 #define T_DIVIDE         0      // divide error
3354 #define T_DEBUG          1      // debug exception
3355 #define T_NMI            2      // non-maskable interrupt
3356 #define T_BRKPT          3      // breakpoint
3357 #define T_OFLOW          4      // overflow
3358 #define T_BOUND          5      // bounds check
3359 #define T_ILLOP          6      // illegal opcode
3360 #define T_DEVICE         7      // device not available
3361 #define T_DBLFLT         8      // double fault
3362 // #define T_COPROC      9      // reserved (not used since 486)
3363 #define T_TSS           10      // invalid task switch segment
3364 #define T_SEGNP         11      // segment not present
3365 #define T_STACK         12      // stack exception
3366 #define T_GPFLT         13      // general protection fault
3367 #define T_PGFLT         14      // page fault
3368 // #define T_RES        15      // reserved
3369 #define T_FPERR         16      // floating point error
3370 #define T_ALIGN         17      // aligment check
3371 #define T_MCHK          18      // machine check
3372 #define T_SIMDERR       19      // SIMD floating point error
3373 
3374 // These are arbitrarily chosen, but with care not to overlap
3375 // processor defined exceptions or interrupt vectors.
3376 #define T_SYSCALL       64      // system call
3377 #define T_DEFAULT      500      // catchall
3378 
3379 #define T_IRQ0          32      // IRQ 0 corresponds to int T_IRQ
3380 
3381 #define IRQ_TIMER        0
3382 #define IRQ_KBD          1
3383 #define IRQ_COM1         4
3384 #define IRQ_IDE         14
3385 #define IRQ_ERROR       19
3386 #define IRQ_SPURIOUS    31
3387 
3388 
3389 
3390 
3391 
3392 
3393 
3394 
3395 
3396 
3397 
3398 
3399 
