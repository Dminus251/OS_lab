#include "types.h"
#include "x86.h"
#include "defs.h"
#include "date.h"
#include "param.h"
#include "memlayout.h"
#include "mmu.h"
#include "proc.h"
#include "spinlock.h"
#include "debug.h"

int
sys_fork(void)
{
  return fork();
}

int
sys_exit(void)
{
  exit();
  return 0;  // not reached
}

int sys_uthread_init(void) {
  int address;
  //0번째 파라미터로 준 값을 &address에 저장.  유효값 아니라면 리턴 -1
  if (argint(0, &address) < 0)
	  return -1;
  //유효값이면 uthread_init 실행
  return uthread_init(address);
}

int
sys_exit2(void) 
{
  int status;

  //첫번쨰 파라미터로 준 값을 &status에 입력한다.
  //유효값 아니라면 리턴 -1
  if (argint(0, &status) < 0)
	  return -1;
   
  exit2(status); 
  //return 0; //eax에 리턴해야하니까
  return status; //eax에 리턴해야하니까
}  

int
sys_wait(void)
{
  return wait();
}


//********************************
//*********new sys_waiat**********
//********************************

int
sys_wait2(void)
{

  int status;
  //포인터 값 복사, 유효값 아니라면 리턴 -1
  if(argptr(0, (char **)&status, sizeof(int)) < 0)
    return -1;

  //유효값이면 wait2 실행
  return wait2(&status);

}
//********************************
//*********new sys_waiat**********
//********************************


int
sys_kill(void)
{
  int pid;

  if(argint(0, &pid) < 0)
    return -1;
  return kill(pid);
}

int
sys_getpid(void)
{
  return myproc()->pid;
}

int
sys_sbrk(void)
{
  int addr;
  int n;

  if(argint(0, &n) < 0)
    return -1;
  addr = myproc()->sz;
  if(growproc(n) < 0)
    return -1;
  return addr;
}

int
sys_sleep(void)
{
  int n;
  uint ticks0;

  if(argint(0, &n) < 0)
    return -1;
  acquire(&tickslock);
  ticks0 = ticks;
  while(ticks - ticks0 < n){
    if(myproc()->killed){
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
  }
  release(&tickslock);
  return 0;
}

// return how many clock tick interrupts have occurred
// since start.
int
sys_uptime(void)
{
  uint xticks;

  acquire(&tickslock);
  xticks = ticks;
  release(&tickslock);
  return xticks;
}
