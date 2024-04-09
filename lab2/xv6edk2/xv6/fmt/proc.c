2400 #include "types.h"
2401 #include "defs.h"
2402 #include "param.h"
2403 #include "memlayout.h"
2404 #include "mmu.h"
2405 #include "x86.h"
2406 #include "proc.h"
2407 #include "spinlock.h"
2408 #include "debug.h"
2409 
2410 struct {
2411   struct spinlock lock;
2412   struct proc proc[NPROC];
2413 } ptable;
2414 
2415 static struct proc *initproc;
2416 
2417 int nextpid = 1;
2418 extern void forkret(void);
2419 extern void trapret(void);
2420 
2421 static void wakeup1(void *chan);
2422 
2423 void
2424 pinit(void)
2425 {
2426   initlock(&ptable.lock, "ptable");
2427 }
2428 
2429 // Must be called with interrupts disabled
2430 int
2431 cpuid() {
2432   return mycpu()-cpus;
2433 }
2434 
2435 // Must be called with interrupts disabled to avoid the caller being
2436 // rescheduled between reading lapicid and running through the loop.
2437 struct cpu*
2438 mycpu(void)
2439 {
2440   int apicid, i;
2441 
2442   if(readeflags()&FL_IF){
2443     panic("mycpu called with interrupts enabled\n");
2444   }
2445 
2446 
2447 
2448 
2449 
2450   apicid = lapicid();
2451   // APIC IDs are not guaranteed to be contiguous. Maybe we should have
2452   // a reverse map, or reserve a register to store &cpus[i].
2453   for (i = 0; i < ncpu; ++i) {
2454     if (cpus[i].apicid == apicid){
2455       return &cpus[i];
2456     }
2457   }
2458   panic("unknown apicid\n");
2459 }
2460 
2461 // Disable interrupts so that we are not rescheduled
2462 // while reading proc from the cpu structure
2463 struct proc*
2464 myproc(void) {
2465   struct cpu *c;
2466   struct proc *p;
2467   pushcli();
2468   c = mycpu();
2469   p = c->proc;
2470   popcli();
2471   return p;
2472 }
2473 
2474 
2475 
2476 
2477 
2478 
2479 
2480 
2481 
2482 
2483 
2484 
2485 
2486 
2487 
2488 
2489 
2490 
2491 
2492 
2493 
2494 
2495 
2496 
2497 
2498 
2499 
2500 // Look in the process table for an UNUSED proc.
2501 // If found, change state to EMBRYO and initialize
2502 // state required to run in the kernel.
2503 // Otherwise return 0.
2504 static struct proc*
2505 allocproc(void)
2506 {
2507   struct proc *p;
2508   char *sp;
2509 
2510   acquire(&ptable.lock);
2511 
2512   for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
2513     if(p->state == UNUSED){
2514       goto found;
2515     }
2516 
2517   release(&ptable.lock);
2518   return 0;
2519 
2520 found:
2521   p->state = EMBRYO;
2522   p->pid = nextpid++;
2523 
2524   release(&ptable.lock);
2525 
2526 
2527   // Allocate kernel stack.
2528   if((p->kstack = kalloc()) == 0){
2529     p->state = UNUSED;
2530     return 0;
2531   }
2532   sp = p->kstack + KSTACKSIZE;
2533 
2534   // Leave room for trap frame.
2535   sp -= sizeof *p->tf;
2536   p->tf = (struct trapframe*)sp;
2537 
2538   // Set up new context to start executing at forkret,
2539   // which returns to trapret.
2540   sp -= 4;
2541   *(uint*)sp = (uint)trapret;
2542 
2543   sp -= sizeof *p->context;
2544   p->context = (struct context*)sp;
2545   memset(p->context, 0, sizeof *p->context);
2546   p->context->eip = (uint)forkret;
2547 
2548   return p;
2549 }
2550 
2551 // Set up first user process.
2552 void
2553 userinit(void)
2554 {
2555   struct proc *p;
2556   extern char _binary_initcode_start[], _binary_initcode_size[];
2557 
2558   p = allocproc();
2559 
2560   initproc = p;
2561   if((p->pgdir = setupkvm()) == 0){
2562     panic("userinit: out of memory?");
2563   }
2564   inituvm(p->pgdir, _binary_initcode_start, (int)_binary_initcode_size);
2565   p->sz = PGSIZE;
2566   memset(p->tf, 0, sizeof(*p->tf));
2567   p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
2568   p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
2569   p->tf->es = p->tf->ds;
2570   p->tf->ss = p->tf->ds;
2571   p->tf->eflags = FL_IF;
2572   p->tf->esp = PGSIZE;
2573   p->tf->eip = 0;  // beginning of initcode.S
2574 
2575   safestrcpy(p->name, "initcode", sizeof(p->name));
2576   p->cwd = namei("/");
2577 
2578   // this assignment to p->state lets other cores
2579   // run this process. the acquire forces the above
2580   // writes to be visible, and the lock is also needed
2581   // because the assignment might not be atomic.
2582   acquire(&ptable.lock);
2583 
2584   p->state = RUNNABLE;
2585 
2586   release(&ptable.lock);
2587 }
2588 
2589 
2590 
2591 
2592 
2593 
2594 
2595 
2596 
2597 
2598 
2599 
2600 // Grow current process's memory by n bytes.
2601 // Return 0 on success, -1 on failure.
2602 int
2603 growproc(int n)
2604 {
2605   uint sz;
2606   struct proc *curproc = myproc();
2607 
2608   sz = curproc->sz;
2609   if(n > 0){
2610     if((sz = allocuvm(curproc->pgdir, sz, sz + n)) == 0)
2611       return -1;
2612   } else if(n < 0){
2613     if((sz = deallocuvm(curproc->pgdir, sz, sz + n)) == 0)
2614       return -1;
2615   }
2616   curproc->sz = sz;
2617   switchuvm(curproc);
2618   return 0;
2619 }
2620 
2621 // Create a new process copying p as the parent.
2622 // Sets up stack to return as if from system call.
2623 // Caller must set state of returned proc to RUNNABLE.
2624 int
2625 fork(void)
2626 {
2627   int i, pid;
2628   struct proc *np;
2629   struct proc *curproc = myproc();
2630 
2631   // Allocate process.
2632   if((np = allocproc()) == 0){
2633     return -1;
2634   }
2635 
2636   // Copy process state from proc.
2637   if((np->pgdir = copyuvm(curproc->pgdir, curproc->sz)) == 0){
2638     kfree(np->kstack);
2639     np->kstack = 0;
2640     np->state = UNUSED;
2641     return -1;
2642   }
2643   np->sz = curproc->sz;
2644   np->parent = curproc;
2645   *np->tf = *curproc->tf;
2646 
2647   // Clear %eax so that fork returns 0 in the child.
2648   np->tf->eax = 0;
2649 
2650   for(i = 0; i < NOFILE; i++)
2651     if(curproc->ofile[i])
2652       np->ofile[i] = filedup(curproc->ofile[i]);
2653   np->cwd = idup(curproc->cwd);
2654 
2655   safestrcpy(np->name, curproc->name, sizeof(curproc->name));
2656 
2657   pid = np->pid;
2658 
2659   acquire(&ptable.lock);
2660 
2661   np->state = RUNNABLE;
2662 
2663   release(&ptable.lock);
2664 
2665   return pid;
2666 }
2667 
2668 // Exit the current process.  Does not return.
2669 // An exited process remains in the zombie state
2670 // until its parent calls wait() to find out it exited.
2671 void
2672 exit(void)
2673 {
2674   struct proc *curproc = myproc();
2675   struct proc *p;
2676   int fd;
2677 
2678   if(curproc == initproc)
2679     panic("init exiting");
2680 
2681   // Close all open files.
2682   for(fd = 0; fd < NOFILE; fd++){
2683     if(curproc->ofile[fd]){
2684       fileclose(curproc->ofile[fd]);
2685       curproc->ofile[fd] = 0;
2686     }
2687   }
2688 
2689   begin_op();
2690   iput(curproc->cwd);
2691   end_op();
2692   curproc->cwd = 0;
2693 
2694   acquire(&ptable.lock);
2695 
2696   // Parent might be sleeping in wait().
2697   wakeup1(curproc->parent);
2698 
2699 
2700   // Pass abandoned children to init.
2701   for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
2702     if(p->parent == curproc){
2703       p->parent = initproc;
2704       if(p->state == ZOMBIE)
2705         wakeup1(initproc);
2706     }
2707   }
2708 
2709   // Jump into the scheduler, never to return.
2710   curproc->state = ZOMBIE;
2711   sched();
2712   panic("zombie exit");
2713 }
2714 
2715 //******************************************
2716 //************   new  **********************
2717 //************ eixt2() *********************
2718 //******************************************
2719 void
2720 exit2(int status){
2721   struct proc *curproc = myproc();
2722   struct proc *p;
2723   int fd;
2724 
2725   //***********새로 추가된 부분. Copy status to xstate**********
2726   curproc->xstate = status;
2727   //************************************************************
2728 
2729   if(curproc == initproc)
2730     panic("init exiting");
2731 
2732   // Close all open files.
2733   for(fd = 0; fd < NOFILE; fd++){
2734     if(curproc->ofile[fd]){
2735       fileclose(curproc->ofile[fd]);
2736       curproc->ofile[fd] = 0;
2737     }
2738   }
2739 
2740   begin_op();
2741   iput(curproc->cwd);
2742   end_op();
2743   curproc->cwd = 0;
2744 
2745   acquire(&ptable.lock);
2746 
2747   // Parent might be sleeping in wait().
2748   wakeup1(curproc->parent);
2749 
2750   // Pass abandoned children to init.
2751   for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
2752     if(p->parent == curproc){
2753       p->parent = initproc;
2754       if(p->state == ZOMBIE)
2755         wakeup1(initproc);
2756     }
2757   }
2758 
2759   // Jump into the scheduler, never to return.
2760   curproc->state = ZOMBIE;
2761   sched();
2762   panic("zombie exit");
2763 }
2764 //******************************************
2765 //************   new  **********************
2766 //************ eixt2() *********************
2767 //******************************************
2768 
2769 
2770 
2771 // Wait for a child process to exit and return its pid.
2772 // Return -1 if this process has no children.
2773 int
2774 wait(void)
2775 {
2776   struct proc *p;
2777   int havekids, pid;
2778   struct proc *curproc = myproc();
2779 
2780   acquire(&ptable.lock);
2781   for(;;){
2782     // Scan through table looking for exited children.
2783     havekids = 0;
2784     for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
2785       if(p->parent != curproc)
2786         continue;
2787       havekids = 1;
2788       if(p->state == ZOMBIE){
2789         // Found one.
2790         pid = p->pid;
2791         kfree(p->kstack);
2792         p->kstack = 0;
2793         freevm(p->pgdir);
2794         p->pid = 0;
2795         p->parent = 0;
2796         p->name[0] = 0;
2797         p->killed = 0;
2798         p->state = UNUSED;
2799         release(&ptable.lock);
2800         return pid;
2801       }
2802     }
2803 
2804     // No point waiting if we don't have any children.
2805     if(!havekids || curproc->killed){
2806       release(&ptable.lock);
2807       return -1;
2808     }
2809 
2810     // Wait for children to exit.  (See wakeup1 call in proc_exit.)
2811     sleep(curproc, &ptable.lock);  //DOC: wait-sleep
2812   }
2813 }
2814 
2815 
2816 //******************************************
2817 //************   new  **********************
2818 //************ wait2() *********************
2819 //******************************************
2820 int
2821 wait2(int *status){
2822 
2823   struct proc *p;
2824   int havekids, pid;
2825   struct proc *curproc = myproc();
2826 
2827 
2828   //***********새로 추가된 부분. xstate로 status 값을 복사**********
2829   // copyout(pde_t *pgdir, uint va, void *p, uint len)와 같이 정의됨
2830   // p 주소의 len 길이만큼을 복사해서 pgdir의 va에 넣는다.
2831   // 따라서 인자로 받은 status 주소의 int 크기만큼 복사해서 curproc의 xstate에 복사함.
2832   // 만약 올바른 값이 아니라면 -1을 리턴
2833   //if (copyout(curproc->pgdir, curproc->xstate, &status, sizeof(int)) < 0)
2834 	  //return -1;
2835 
2836   acquire(&ptable.lock);
2837   for(;;){
2838     // Scan through table looking for exited children.
2839     havekids = 0;
2840     for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
2841       if(p->parent != curproc)
2842         continue;
2843       havekids = 1;
2844       if(p->state == ZOMBIE){
2845         // Found one.
2846         pid = p->pid;
2847         kfree(p->kstack);
2848         p->kstack = 0;
2849         freevm(p->pgdir);
2850         p->pid = 0;
2851         p->parent = 0;
2852         p->name[0] = 0;
2853         p->killed = 0;
2854         p->state = UNUSED;
2855         release(&ptable.lock);
2856         return pid;
2857       }
2858     }
2859 
2860     // No point waiting if we don't have any children.
2861     if(!havekids || curproc->killed){
2862       release(&ptable.lock);
2863       return -1;
2864     }
2865 
2866   //***********새로 추가된 부분. xstate로 status 값을 복사**********
2867   // copyout(pde_t *pgdir, uint va, void *p, uint len)와 같이 정의됨
2868   // p 주소의 len 길이만큼을 복사해서 pgdir의 va에 넣는다.
2869   // 따라서 인자로 받은 status 주소의 int 크기만큼 복사해서 curproc의 xstate에 복사함.
2870   // 만약 올바른 값이 아니라면 -1을 리턴
2871   // Wait for children to exit.  (See wakeup1 call in proc_exit.)
2872     //if (*status == 0) {
2873     sleep(curproc, &ptable.lock);  //DOC: wait-sleep
2874 
2875     if (copyout(curproc->pgdir, *status, &(curproc->xstate), sizeof(int)) < 0)
2876 	    return -1;
2877 
2878     //}
2879     //sleep(curproc, &ptable.lock);  //DOC: wait-sleep
2880   }
2881 }
2882 //******************************************
2883 //************   new  **********************
2884 //************ wait2() *********************
2885 //******************************************
2886 
2887 
2888 
2889 
2890 
2891 
2892 
2893 
2894 
2895 
2896 
2897 
2898 
2899 
2900 // Per-CPU process scheduler.
2901 // Each CPU calls scheduler() after setting itself up.
2902 // Scheduler never returns.  It loops, doing:
2903 //  - choose a process to run
2904 //  - swtch to start running that process
2905 //  - eventually that process transfers control
2906 //      via swtch back to the scheduler.
2907 void
2908 scheduler(void)
2909 {
2910   struct proc *p;
2911   struct cpu *c = mycpu();
2912   c->proc = 0;
2913 
2914   for(;;){
2915     // Enable interrupts on this processor.
2916     sti();
2917 
2918     // Loop over process table looking for process to run.
2919     acquire(&ptable.lock);
2920     for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
2921       if(p->state != RUNNABLE)
2922         continue;
2923 
2924       // Switch to chosen process.  It is the process's job
2925       // to release ptable.lock and then reacquire it
2926       // before jumping back to us.
2927       c->proc = p;
2928       switchuvm(p);
2929       p->state = RUNNING;
2930 
2931       swtch(&(c->scheduler), p->context);
2932       switchkvm();
2933 
2934       // Process is done running for now.
2935       // It should have changed its p->state before coming back.
2936       c->proc = 0;
2937     }
2938     release(&ptable.lock);
2939 
2940   }
2941 }
2942 
2943 
2944 
2945 
2946 
2947 
2948 
2949 
2950 // Enter scheduler.  Must hold only ptable.lock
2951 // and have changed proc->state. Saves and restores
2952 // intena because intena is a property of this
2953 // kernel thread, not this CPU. It should
2954 // be proc->intena and proc->ncli, but that would
2955 // break in the few places where a lock is held but
2956 // there's no process.
2957 void
2958 sched(void)
2959 {
2960   int intena;
2961   struct proc *p = myproc();
2962 
2963   if(!holding(&ptable.lock))
2964     panic("sched ptable.lock");
2965   if(mycpu()->ncli != 1)
2966     panic("sched locks");
2967   if(p->state == RUNNING)
2968     panic("sched running");
2969   if(readeflags()&FL_IF)
2970     panic("sched interruptible");
2971   intena = mycpu()->intena;
2972   swtch(&p->context, mycpu()->scheduler);
2973   mycpu()->intena = intena;
2974 }
2975 
2976 // Give up the CPU for one scheduling round.
2977 void
2978 yield(void)
2979 {
2980   acquire(&ptable.lock);  //DOC: yieldlock
2981   myproc()->state = RUNNABLE;
2982   sched();
2983   release(&ptable.lock);
2984 }
2985 
2986 
2987 
2988 
2989 
2990 
2991 
2992 
2993 
2994 
2995 
2996 
2997 
2998 
2999 
3000 // A fork child's very first scheduling by scheduler()
3001 // will swtch here.  "Return" to user space.
3002 void
3003 forkret(void)
3004 {
3005   static int first = 1;
3006   // Still holding ptable.lock from scheduler.
3007   release(&ptable.lock);
3008 
3009   if (first) {
3010     // Some initialization functions must be run in the context
3011     // of a regular process (e.g., they call sleep), and thus cannot
3012     // be run from main().
3013     first = 0;
3014     iinit(ROOTDEV);
3015     initlog(ROOTDEV);
3016   }
3017 
3018   // Return to "caller", actually trapret (see allocproc).
3019 }
3020 
3021 // Atomically release lock and sleep on chan.
3022 // Reacquires lock when awakened.
3023 void
3024 sleep(void *chan, struct spinlock *lk)
3025 {
3026   struct proc *p = myproc();
3027 
3028   if(p == 0)
3029     panic("sleep");
3030 
3031   if(lk == 0)
3032     panic("sleep without lk");
3033 
3034   // Must acquire ptable.lock in order to
3035   // change p->state and then call sched.
3036   // Once we hold ptable.lock, we can be
3037   // guaranteed that we won't miss any wakeup
3038   // (wakeup runs with ptable.lock locked),
3039   // so it's okay to release lk.
3040   if(lk != &ptable.lock){  //DOC: sleeplock0
3041     acquire(&ptable.lock);  //DOC: sleeplock1
3042     release(lk);
3043   }
3044   // Go to sleep.
3045   p->chan = chan;
3046   p->state = SLEEPING;
3047 
3048   sched();
3049 
3050   // Tidy up.
3051   p->chan = 0;
3052 
3053   // Reacquire original lock.
3054   if(lk != &ptable.lock){  //DOC: sleeplock2
3055     release(&ptable.lock);
3056     acquire(lk);
3057   }
3058 }
3059 
3060 
3061 
3062 
3063 
3064 
3065 
3066 
3067 
3068 
3069 
3070 
3071 
3072 
3073 
3074 
3075 
3076 
3077 
3078 
3079 
3080 
3081 
3082 
3083 
3084 
3085 
3086 
3087 
3088 
3089 
3090 
3091 
3092 
3093 
3094 
3095 
3096 
3097 
3098 
3099 
3100 // Wake up all processes sleeping on chan.
3101 // The ptable lock must be held.
3102 static void
3103 wakeup1(void *chan)
3104 {
3105   struct proc *p;
3106 
3107   for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
3108     if(p->state == SLEEPING && p->chan == chan)
3109       p->state = RUNNABLE;
3110 }
3111 
3112 // Wake up all processes sleeping on chan.
3113 void
3114 wakeup(void *chan)
3115 {
3116   acquire(&ptable.lock);
3117   wakeup1(chan);
3118   release(&ptable.lock);
3119 }
3120 
3121 // Kill the process with the given pid.
3122 // Process won't exit until it returns
3123 // to user space (see trap in trap.c).
3124 int
3125 kill(int pid)
3126 {
3127   struct proc *p;
3128 
3129   acquire(&ptable.lock);
3130   for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
3131     if(p->pid == pid){
3132       p->killed = 1;
3133       // Wake process from sleep if necessary.
3134       if(p->state == SLEEPING)
3135         p->state = RUNNABLE;
3136       release(&ptable.lock);
3137       return 0;
3138     }
3139   }
3140   release(&ptable.lock);
3141   return -1;
3142 }
3143 
3144 
3145 
3146 
3147 
3148 
3149 
3150 // Print a process listing to console.  For debugging.
3151 // Runs when user types ^P on console.
3152 // No lock to avoid wedging a stuck machine further.
3153 void
3154 procdump(void)
3155 {
3156   static char *states[] = {
3157   [UNUSED]    "unused",
3158   [EMBRYO]    "embryo",
3159   [SLEEPING]  "sleep ",
3160   [RUNNABLE]  "runble",
3161   [RUNNING]   "run   ",
3162   [ZOMBIE]    "zombie"
3163   };
3164   int i;
3165   struct proc *p;
3166   char *state;
3167   uint pc[10];
3168 
3169   for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
3170     if(p->state == UNUSED)
3171       continue;
3172     if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
3173       state = states[p->state];
3174     else
3175       state = "???";
3176     cprintf("%d %s %s", p->pid, state, p->name);
3177     if(p->state == SLEEPING){
3178       getcallerpcs((uint*)p->context->ebp+2, pc);
3179       for(i=0; i<10 && pc[i] != 0; i++)
3180         cprintf(" %p", pc[i]);
3181     }
3182     cprintf("\n");
3183   }
3184 }
3185 
3186 
3187 
3188 
3189 
3190 
3191 
3192 
3193 
3194 
3195 
3196 
3197 
3198 
3199 
