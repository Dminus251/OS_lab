3900 #include "types.h"
3901 #include "x86.h"
3902 #include "defs.h"
3903 #include "date.h"
3904 #include "param.h"
3905 #include "memlayout.h"
3906 #include "mmu.h"
3907 #include "proc.h"
3908 #include "spinlock.h"
3909 #include "debug.h"
3910 
3911 int
3912 sys_fork(void)
3913 {
3914   return fork();
3915 }
3916 
3917 int
3918 sys_exit(void)
3919 {
3920   exit();
3921   return 0;  // not reached
3922 }
3923 
3924 int
3925 sys_exit2(void)
3926 {
3927   int status;
3928 
3929   //첫번쨰 파라미터로 준 값을 &status에 입력한다.
3930   //유효값 아니라면 리턴 -1
3931   if (argint(0, &status) < 0)
3932 	  return -1;
3933 
3934   exit2(status);
3935   //return 0; //eax에 리턴해야하니까
3936   return status; //eax에 리턴해야하니까
3937 }
3938 
3939 int
3940 sys_wait(void)
3941 {
3942   return wait();
3943 }
3944 
3945 
3946 
3947 
3948 
3949 
3950 //********************************
3951 //*********new sys_waiat**********
3952 //********************************
3953 
3954 int
3955 sys_wait2(void)
3956 {
3957 
3958   int status;
3959   //포인터 값 복사, 유효값 아니라면 리턴 -1
3960   if(argptr(0, (char **)&status, sizeof(int)) < 0)
3961     return -1;
3962 
3963   //유효값이면 wait2 실행
3964   return wait2(&status);
3965 
3966 }
3967 //********************************
3968 //*********new sys_waiat**********
3969 //********************************
3970 
3971 
3972 int
3973 sys_kill(void)
3974 {
3975   int pid;
3976 
3977   if(argint(0, &pid) < 0)
3978     return -1;
3979   return kill(pid);
3980 }
3981 
3982 int
3983 sys_getpid(void)
3984 {
3985   return myproc()->pid;
3986 }
3987 
3988 
3989 
3990 
3991 
3992 
3993 
3994 
3995 
3996 
3997 
3998 
3999 
4000 int
4001 sys_sbrk(void)
4002 {
4003   int addr;
4004   int n;
4005 
4006   if(argint(0, &n) < 0)
4007     return -1;
4008   addr = myproc()->sz;
4009   if(growproc(n) < 0)
4010     return -1;
4011   return addr;
4012 }
4013 
4014 int
4015 sys_sleep(void)
4016 {
4017   int n;
4018   uint ticks0;
4019 
4020   if(argint(0, &n) < 0)
4021     return -1;
4022   acquire(&tickslock);
4023   ticks0 = ticks;
4024   while(ticks - ticks0 < n){
4025     if(myproc()->killed){
4026       release(&tickslock);
4027       return -1;
4028     }
4029     sleep(&ticks, &tickslock);
4030   }
4031   release(&tickslock);
4032   return 0;
4033 }
4034 
4035 // return how many clock tick interrupts have occurred
4036 // since start.
4037 int
4038 sys_uptime(void)
4039 {
4040   uint xticks;
4041 
4042   acquire(&tickslock);
4043   xticks = ticks;
4044   release(&tickslock);
4045   return xticks;
4046 }
4047 
4048 
4049 
