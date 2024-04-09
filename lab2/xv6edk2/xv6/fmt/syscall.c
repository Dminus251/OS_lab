3700 #include "types.h"
3701 #include "defs.h"
3702 #include "param.h"
3703 #include "memlayout.h"
3704 #include "mmu.h"
3705 #include "proc.h"
3706 #include "x86.h"
3707 #include "syscall.h"
3708 
3709 // User code makes a system call with INT T_SYSCALL.
3710 // System call number in %eax.
3711 // Arguments on the stack, from the user call to the C
3712 // library system call function. The saved user %esp points
3713 // to a saved program counter, and then the first argument.
3714 
3715 // Fetch the int at addr from the current process.
3716 int
3717 fetchint(uint addr, int *ip)
3718 {
3719   struct proc *curproc = myproc();
3720 
3721   if(addr >= curproc->sz || addr+4 > curproc->sz)
3722     return -1;
3723   *ip = *(int*)(addr);
3724   return 0;
3725 }
3726 
3727 // Fetch the nul-terminated string at addr from the current process.
3728 // Doesn't actually copy the string - just sets *pp to point at it.
3729 // Returns length of string, not including nul.
3730 int
3731 fetchstr(uint addr, char **pp)
3732 {
3733   char *s, *ep;
3734   struct proc *curproc = myproc();
3735 
3736   if(addr >= curproc->sz)
3737     return -1;
3738   *pp = (char*)addr;
3739   ep = (char*)curproc->sz;
3740   for(s = *pp; s < ep; s++){
3741     if(*s == 0)
3742       return s - *pp;
3743   }
3744   return -1;
3745 }
3746 
3747 
3748 
3749 
3750 // Fetch the nth 32-bit system call argument.
3751 int
3752 argint(int n, int *ip)
3753 {
3754   return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
3755 }
3756 
3757 // Fetch the nth word-sized system call argument as a pointer
3758 // to a block of memory of size bytes.  Check that the pointer
3759 // lies within the process address space.
3760 int
3761 argptr(int n, char **pp, int size)
3762 {
3763   int i;
3764   struct proc *curproc = myproc();
3765 
3766   if(argint(n, &i) < 0)
3767     return -1;
3768   if(size < 0 || (uint)i >= curproc->sz || (uint)i+size > curproc->sz)
3769     return -1;
3770   *pp = (char*)i;
3771   return 0;
3772 }
3773 
3774 // Fetch the nth word-sized system call argument as a string pointer.
3775 // Check that the pointer is valid and the string is nul-terminated.
3776 // (There is no shared writable memory, so the string can't change
3777 // between this check and being used by the kernel.)
3778 int
3779 argstr(int n, char **pp)
3780 {
3781   int addr;
3782   if(argint(n, &addr) < 0)
3783     return -1;
3784   return fetchstr(addr, pp);
3785 }
3786 
3787 
3788 
3789 
3790 
3791 
3792 
3793 
3794 
3795 
3796 
3797 
3798 
3799 
3800 extern int sys_chdir(void);
3801 extern int sys_close(void);
3802 extern int sys_dup(void);
3803 extern int sys_exec(void);
3804 extern int sys_exit(void);
3805 extern int sys_fork(void);
3806 extern int sys_fstat(void);
3807 extern int sys_getpid(void);
3808 extern int sys_kill(void);
3809 extern int sys_link(void);
3810 extern int sys_mkdir(void);
3811 extern int sys_mknod(void);
3812 extern int sys_open(void);
3813 extern int sys_pipe(void);
3814 extern int sys_read(void);
3815 extern int sys_sbrk(void);
3816 extern int sys_sleep(void);
3817 extern int sys_unlink(void);
3818 extern int sys_wait(void);
3819 extern int sys_write(void);
3820 extern int sys_uptime(void);
3821 extern int sys_exit2(void);
3822 extern int sys_wait2(void);
3823 
3824 
3825 
3826 static int (*syscalls[])(void) = {
3827 [SYS_fork]    sys_fork,
3828 [SYS_exit]    sys_exit,
3829 [SYS_wait]    sys_wait,
3830 [SYS_pipe]    sys_pipe,
3831 [SYS_read]    sys_read,
3832 [SYS_kill]    sys_kill,
3833 [SYS_exec]    sys_exec,
3834 [SYS_fstat]   sys_fstat,
3835 [SYS_chdir]   sys_chdir,
3836 [SYS_dup]     sys_dup,
3837 [SYS_getpid]  sys_getpid,
3838 [SYS_sbrk]    sys_sbrk,
3839 [SYS_sleep]   sys_sleep,
3840 [SYS_uptime]  sys_uptime,
3841 [SYS_open]    sys_open,
3842 [SYS_write]   sys_write,
3843 [SYS_mknod]   sys_mknod,
3844 [SYS_unlink]  sys_unlink,
3845 [SYS_link]    sys_link,
3846 [SYS_mkdir]   sys_mkdir,
3847 [SYS_close]   sys_close,
3848 [SYS_exit2]   sys_exit2,
3849 [SYS_wait2]   sys_wait2,
3850 };
3851 
3852 void
3853 syscall(void)
3854 {
3855   int num;
3856   struct proc *curproc = myproc();
3857 
3858   num = curproc->tf->eax;
3859   if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
3860     curproc->tf->eax = syscalls[num]();
3861   } else {
3862     cprintf("%d %s: unknown sys call %d\n",
3863             curproc->pid, curproc->name, num);
3864     curproc->tf->eax = -1;
3865   }
3866 }
3867 
3868 
3869 
3870 
3871 
3872 
3873 
3874 
3875 
3876 
3877 
3878 
3879 
3880 
3881 
3882 
3883 
3884 
3885 
3886 
3887 
3888 
3889 
3890 
3891 
3892 
3893 
3894 
3895 
3896 
3897 
3898 
3899 
