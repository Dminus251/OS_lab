
_uthread:     file format elf32-i386


Disassembly of section .text:

00000000 <testFunc>:
static thread_t all_thread[MAX_THREAD];
thread_p  current_thread;
thread_p  next_thread;
extern void thread_switch(void);

void testFunc(void){
   0:	55                   	push   %ebp
   1:	89 e5                	mov    %esp,%ebp
   3:	83 ec 08             	sub    $0x8,%esp
	printf(2, "test");
   6:	83 ec 08             	sub    $0x8,%esp
   9:	68 24 0a 00 00       	push   $0xa24
   e:	6a 02                	push   $0x2
  10:	e8 55 06 00 00       	call   66a <printf>
  15:	83 c4 10             	add    $0x10,%esp
}
  18:	90                   	nop
  19:	c9                   	leave  
  1a:	c3                   	ret    

0000001b <thread_schedule>:

static void 
thread_schedule(void)
{
  1b:	55                   	push   %ebp
  1c:	89 e5                	mov    %esp,%ebp
  1e:	83 ec 18             	sub    $0x18,%esp
  thread_p t;

  /* Find another runnable thread. */
  next_thread = 0;
  21:	c7 05 c4 0d 00 00 00 	movl   $0x0,0xdc4
  28:	00 00 00 
  for (t = all_thread; t < all_thread + MAX_THREAD; t++) {
  2b:	c7 45 f4 e0 0d 00 00 	movl   $0xde0,-0xc(%ebp)
  32:	eb 29                	jmp    5d <thread_schedule+0x42>
    if (t->state == RUNNABLE && t != current_thread) {
  34:	8b 45 f4             	mov    -0xc(%ebp),%eax
  37:	8b 80 04 20 00 00    	mov    0x2004(%eax),%eax
  3d:	83 f8 02             	cmp    $0x2,%eax
  40:	75 14                	jne    56 <thread_schedule+0x3b>
  42:	a1 c0 0d 00 00       	mov    0xdc0,%eax
  47:	39 45 f4             	cmp    %eax,-0xc(%ebp)
  4a:	74 0a                	je     56 <thread_schedule+0x3b>
      next_thread = t;
  4c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  4f:	a3 c4 0d 00 00       	mov    %eax,0xdc4
      break;
  54:	eb 11                	jmp    67 <thread_schedule+0x4c>
  for (t = all_thread; t < all_thread + MAX_THREAD; t++) {
  56:	81 45 f4 08 20 00 00 	addl   $0x2008,-0xc(%ebp)
  5d:	b8 00 8e 00 00       	mov    $0x8e00,%eax
  62:	39 45 f4             	cmp    %eax,-0xc(%ebp)
  65:	72 cd                	jb     34 <thread_schedule+0x19>
    }
  }

  if (t >= all_thread + MAX_THREAD && current_thread->state == RUNNABLE) {
  67:	b8 00 8e 00 00       	mov    $0x8e00,%eax
  6c:	39 45 f4             	cmp    %eax,-0xc(%ebp)
  6f:	72 1a                	jb     8b <thread_schedule+0x70>
  71:	a1 c0 0d 00 00       	mov    0xdc0,%eax
  76:	8b 80 04 20 00 00    	mov    0x2004(%eax),%eax
  7c:	83 f8 02             	cmp    $0x2,%eax
  7f:	75 0a                	jne    8b <thread_schedule+0x70>
    /* The current thread is the only runnable thread; run it. */
    next_thread = current_thread;
  81:	a1 c0 0d 00 00       	mov    0xdc0,%eax
  86:	a3 c4 0d 00 00       	mov    %eax,0xdc4
  }

  if (next_thread == 0) {
  8b:	a1 c4 0d 00 00       	mov    0xdc4,%eax
  90:	85 c0                	test   %eax,%eax
  92:	75 17                	jne    ab <thread_schedule+0x90>
    printf(2, "thread_schedule: no runnable threads\n");
  94:	83 ec 08             	sub    $0x8,%esp
  97:	68 2c 0a 00 00       	push   $0xa2c
  9c:	6a 02                	push   $0x2
  9e:	e8 c7 05 00 00       	call   66a <printf>
  a3:	83 c4 10             	add    $0x10,%esp
    exit();
  a6:	e8 33 04 00 00       	call   4de <exit>
  }

  if (current_thread != next_thread) {         /* switch threads?  */
  ab:	8b 15 c0 0d 00 00    	mov    0xdc0,%edx
  b1:	a1 c4 0d 00 00       	mov    0xdc4,%eax
  b6:	39 c2                	cmp    %eax,%edx
  b8:	74 16                	je     d0 <thread_schedule+0xb5>
    next_thread->state = RUNNING;
  ba:	a1 c4 0d 00 00       	mov    0xdc4,%eax
  bf:	c7 80 04 20 00 00 01 	movl   $0x1,0x2004(%eax)
  c6:	00 00 00 
    thread_switch();
  c9:	e8 a3 01 00 00       	call   271 <thread_switch>
  } else
    next_thread = 0;
}
  ce:	eb 0a                	jmp    da <thread_schedule+0xbf>
    next_thread = 0;
  d0:	c7 05 c4 0d 00 00 00 	movl   $0x0,0xdc4
  d7:	00 00 00 
}
  da:	90                   	nop
  db:	c9                   	leave  
  dc:	c3                   	ret    

000000dd <thread_init>:

void 
thread_init(void)
{
  dd:	55                   	push   %ebp
  de:	89 e5                	mov    %esp,%ebp
  e0:	83 ec 08             	sub    $0x8,%esp
  current_thread = &all_thread[0];
  e3:	c7 05 c0 0d 00 00 e0 	movl   $0xde0,0xdc0
  ea:	0d 00 00 
  current_thread->state = RUNNING;
  ed:	a1 c0 0d 00 00       	mov    0xdc0,%eax
  f2:	c7 80 04 20 00 00 01 	movl   $0x1,0x2004(%eax)
  f9:	00 00 00 
  //printf(1, "ptr is %p\n", funcPtr);
  //unsigned int a = (unsigned int)funcPtr;
  //int a = (int)funcPtr;
  //printf(1, "a is %d\n", a);
  //uthread_init(a); //***********modified. new system call.$a
  printf(2, "modified a is %d", (unsigned int)thread_schedule);
  fc:	b8 1b 00 00 00       	mov    $0x1b,%eax
 101:	83 ec 04             	sub    $0x4,%esp
 104:	50                   	push   %eax
 105:	68 52 0a 00 00       	push   $0xa52
 10a:	6a 02                	push   $0x2
 10c:	e8 59 05 00 00       	call   66a <printf>
 111:	83 c4 10             	add    $0x10,%esp
  uthread_init((unsigned int)thread_schedule); //***********modified. new system call.
 114:	b8 1b 00 00 00       	mov    $0x1b,%eax
 119:	83 ec 0c             	sub    $0xc,%esp
 11c:	50                   	push   %eax
 11d:	e8 6c 04 00 00       	call   58e <uthread_init>
 122:	83 c4 10             	add    $0x10,%esp
}
 125:	90                   	nop
 126:	c9                   	leave  
 127:	c3                   	ret    

00000128 <thread_create>:


void 
thread_create(void (*func)())
{
 128:	55                   	push   %ebp
 129:	89 e5                	mov    %esp,%ebp
 12b:	83 ec 10             	sub    $0x10,%esp
  thread_p t;

  for (t = all_thread; t < all_thread + MAX_THREAD; t++) {
 12e:	c7 45 fc e0 0d 00 00 	movl   $0xde0,-0x4(%ebp)
 135:	eb 14                	jmp    14b <thread_create+0x23>
    if (t->state == FREE) break;
 137:	8b 45 fc             	mov    -0x4(%ebp),%eax
 13a:	8b 80 04 20 00 00    	mov    0x2004(%eax),%eax
 140:	85 c0                	test   %eax,%eax
 142:	74 13                	je     157 <thread_create+0x2f>
  for (t = all_thread; t < all_thread + MAX_THREAD; t++) {
 144:	81 45 fc 08 20 00 00 	addl   $0x2008,-0x4(%ebp)
 14b:	b8 00 8e 00 00       	mov    $0x8e00,%eax
 150:	39 45 fc             	cmp    %eax,-0x4(%ebp)
 153:	72 e2                	jb     137 <thread_create+0xf>
 155:	eb 01                	jmp    158 <thread_create+0x30>
    if (t->state == FREE) break;
 157:	90                   	nop
  }
  t->sp = (int) (t->stack + STACK_SIZE);   // set sp to the top of the stack
 158:	8b 45 fc             	mov    -0x4(%ebp),%eax
 15b:	83 c0 04             	add    $0x4,%eax
 15e:	05 00 20 00 00       	add    $0x2000,%eax
 163:	89 c2                	mov    %eax,%edx
 165:	8b 45 fc             	mov    -0x4(%ebp),%eax
 168:	89 10                	mov    %edx,(%eax)
  t->sp -= 4;                              // space for return address
 16a:	8b 45 fc             	mov    -0x4(%ebp),%eax
 16d:	8b 00                	mov    (%eax),%eax
 16f:	8d 50 fc             	lea    -0x4(%eax),%edx
 172:	8b 45 fc             	mov    -0x4(%ebp),%eax
 175:	89 10                	mov    %edx,(%eax)
  * (int *) (t->sp) = (int)func;           // push return address on stack
 177:	8b 45 fc             	mov    -0x4(%ebp),%eax
 17a:	8b 00                	mov    (%eax),%eax
 17c:	89 c2                	mov    %eax,%edx
 17e:	8b 45 08             	mov    0x8(%ebp),%eax
 181:	89 02                	mov    %eax,(%edx)
  t->sp -= 32;                             // space for registers that thread_switch expects
 183:	8b 45 fc             	mov    -0x4(%ebp),%eax
 186:	8b 00                	mov    (%eax),%eax
 188:	8d 50 e0             	lea    -0x20(%eax),%edx
 18b:	8b 45 fc             	mov    -0x4(%ebp),%eax
 18e:	89 10                	mov    %edx,(%eax)
  t->state = RUNNABLE;
 190:	8b 45 fc             	mov    -0x4(%ebp),%eax
 193:	c7 80 04 20 00 00 02 	movl   $0x2,0x2004(%eax)
 19a:	00 00 00 
}
 19d:	90                   	nop
 19e:	c9                   	leave  
 19f:	c3                   	ret    

000001a0 <thread_yield>:

void 
thread_yield(void)
{
 1a0:	55                   	push   %ebp
 1a1:	89 e5                	mov    %esp,%ebp
 1a3:	83 ec 08             	sub    $0x8,%esp
  current_thread->state = RUNNABLE;
 1a6:	a1 c0 0d 00 00       	mov    0xdc0,%eax
 1ab:	c7 80 04 20 00 00 02 	movl   $0x2,0x2004(%eax)
 1b2:	00 00 00 
  thread_schedule();
 1b5:	e8 61 fe ff ff       	call   1b <thread_schedule>
}
 1ba:	90                   	nop
 1bb:	c9                   	leave  
 1bc:	c3                   	ret    

000001bd <mythread>:

static void 
mythread(void)
{
 1bd:	55                   	push   %ebp
 1be:	89 e5                	mov    %esp,%ebp
 1c0:	83 ec 18             	sub    $0x18,%esp
  int i;
  printf(1, "my thread running\n");
 1c3:	83 ec 08             	sub    $0x8,%esp
 1c6:	68 63 0a 00 00       	push   $0xa63
 1cb:	6a 01                	push   $0x1
 1cd:	e8 98 04 00 00       	call   66a <printf>
 1d2:	83 c4 10             	add    $0x10,%esp
  for (i = 0; i < 100; i++) {
 1d5:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
 1dc:	eb 1c                	jmp    1fa <mythread+0x3d>
    printf(1, "my thread 0x%x\n", (int) current_thread);
 1de:	a1 c0 0d 00 00       	mov    0xdc0,%eax
 1e3:	83 ec 04             	sub    $0x4,%esp
 1e6:	50                   	push   %eax
 1e7:	68 76 0a 00 00       	push   $0xa76
 1ec:	6a 01                	push   $0x1
 1ee:	e8 77 04 00 00       	call   66a <printf>
 1f3:	83 c4 10             	add    $0x10,%esp
  for (i = 0; i < 100; i++) {
 1f6:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
 1fa:	83 7d f4 63          	cmpl   $0x63,-0xc(%ebp)
 1fe:	7e de                	jle    1de <mythread+0x21>
    //thread_yield(); *************** modified.
  }
  printf(1, "my thread: exit\n");
 200:	83 ec 08             	sub    $0x8,%esp
 203:	68 86 0a 00 00       	push   $0xa86
 208:	6a 01                	push   $0x1
 20a:	e8 5b 04 00 00       	call   66a <printf>
 20f:	83 c4 10             	add    $0x10,%esp
  current_thread->state = FREE;
 212:	a1 c0 0d 00 00       	mov    0xdc0,%eax
 217:	c7 80 04 20 00 00 00 	movl   $0x0,0x2004(%eax)
 21e:	00 00 00 
  thread_schedule();
 221:	e8 f5 fd ff ff       	call   1b <thread_schedule>
}
 226:	90                   	nop
 227:	c9                   	leave  
 228:	c3                   	ret    

00000229 <main>:


int 
main(int argc, char *argv[]) 
{
 229:	8d 4c 24 04          	lea    0x4(%esp),%ecx
 22d:	83 e4 f0             	and    $0xfffffff0,%esp
 230:	ff 71 fc             	push   -0x4(%ecx)
 233:	55                   	push   %ebp
 234:	89 e5                	mov    %esp,%ebp
 236:	51                   	push   %ecx
 237:	83 ec 04             	sub    $0x4,%esp
  thread_init();
 23a:	e8 9e fe ff ff       	call   dd <thread_init>
  thread_create(mythread);
 23f:	83 ec 0c             	sub    $0xc,%esp
 242:	68 bd 01 00 00       	push   $0x1bd
 247:	e8 dc fe ff ff       	call   128 <thread_create>
 24c:	83 c4 10             	add    $0x10,%esp
  thread_create(mythread);
 24f:	83 ec 0c             	sub    $0xc,%esp
 252:	68 bd 01 00 00       	push   $0x1bd
 257:	e8 cc fe ff ff       	call   128 <thread_create>
 25c:	83 c4 10             	add    $0x10,%esp
  thread_schedule();
 25f:	e8 b7 fd ff ff       	call   1b <thread_schedule>
  return 0;
 264:	b8 00 00 00 00       	mov    $0x0,%eax
}
 269:	8b 4d fc             	mov    -0x4(%ebp),%ecx
 26c:	c9                   	leave  
 26d:	8d 61 fc             	lea    -0x4(%ecx),%esp
 270:	c3                   	ret    

00000271 <thread_switch>:
	.text

	.globl thread_switch
thread_switch:
		
	pushal	//PUSH: saving current_thread
 271:	60                   	pusha  
	
	movl current_thread, %eax	//current_thread의 주소를 %eax에 로드
 272:	a1 c0 0d 00 00       	mov    0xdc0,%eax
   	movl %esp, (%eax)		// %esp를 current_thread->sp에 저장
 277:	89 20                	mov    %esp,(%eax)
		
	movl next_thread, %eax		//마찬가지
 279:	a1 c4 0d 00 00       	mov    0xdc4,%eax
	movl (%eax), %esp		//마찬가지
 27e:	8b 20                	mov    (%eax),%esp
	
	movl %eax, current_thread	//next_threa의 시작 주소가 있는 %eax값을 다시 current_thread로
 280:	a3 c0 0d 00 00       	mov    %eax,0xdc0

	popal	//POP: restoring next_thread
 285:	61                   	popa   

	ret			/* return to ra*/	
 286:	c3                   	ret    

00000287 <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
 287:	55                   	push   %ebp
 288:	89 e5                	mov    %esp,%ebp
 28a:	57                   	push   %edi
 28b:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
 28c:	8b 4d 08             	mov    0x8(%ebp),%ecx
 28f:	8b 55 10             	mov    0x10(%ebp),%edx
 292:	8b 45 0c             	mov    0xc(%ebp),%eax
 295:	89 cb                	mov    %ecx,%ebx
 297:	89 df                	mov    %ebx,%edi
 299:	89 d1                	mov    %edx,%ecx
 29b:	fc                   	cld    
 29c:	f3 aa                	rep stos %al,%es:(%edi)
 29e:	89 ca                	mov    %ecx,%edx
 2a0:	89 fb                	mov    %edi,%ebx
 2a2:	89 5d 08             	mov    %ebx,0x8(%ebp)
 2a5:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
 2a8:	90                   	nop
 2a9:	5b                   	pop    %ebx
 2aa:	5f                   	pop    %edi
 2ab:	5d                   	pop    %ebp
 2ac:	c3                   	ret    

000002ad <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
 2ad:	55                   	push   %ebp
 2ae:	89 e5                	mov    %esp,%ebp
 2b0:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
 2b3:	8b 45 08             	mov    0x8(%ebp),%eax
 2b6:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while((*s++ = *t++) != 0)
 2b9:	90                   	nop
 2ba:	8b 55 0c             	mov    0xc(%ebp),%edx
 2bd:	8d 42 01             	lea    0x1(%edx),%eax
 2c0:	89 45 0c             	mov    %eax,0xc(%ebp)
 2c3:	8b 45 08             	mov    0x8(%ebp),%eax
 2c6:	8d 48 01             	lea    0x1(%eax),%ecx
 2c9:	89 4d 08             	mov    %ecx,0x8(%ebp)
 2cc:	0f b6 12             	movzbl (%edx),%edx
 2cf:	88 10                	mov    %dl,(%eax)
 2d1:	0f b6 00             	movzbl (%eax),%eax
 2d4:	84 c0                	test   %al,%al
 2d6:	75 e2                	jne    2ba <strcpy+0xd>
    ;
  return os;
 2d8:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 2db:	c9                   	leave  
 2dc:	c3                   	ret    

000002dd <strcmp>:

int
strcmp(const char *p, const char *q)
{
 2dd:	55                   	push   %ebp
 2de:	89 e5                	mov    %esp,%ebp
  while(*p && *p == *q)
 2e0:	eb 08                	jmp    2ea <strcmp+0xd>
    p++, q++;
 2e2:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 2e6:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
  while(*p && *p == *q)
 2ea:	8b 45 08             	mov    0x8(%ebp),%eax
 2ed:	0f b6 00             	movzbl (%eax),%eax
 2f0:	84 c0                	test   %al,%al
 2f2:	74 10                	je     304 <strcmp+0x27>
 2f4:	8b 45 08             	mov    0x8(%ebp),%eax
 2f7:	0f b6 10             	movzbl (%eax),%edx
 2fa:	8b 45 0c             	mov    0xc(%ebp),%eax
 2fd:	0f b6 00             	movzbl (%eax),%eax
 300:	38 c2                	cmp    %al,%dl
 302:	74 de                	je     2e2 <strcmp+0x5>
  return (uchar)*p - (uchar)*q;
 304:	8b 45 08             	mov    0x8(%ebp),%eax
 307:	0f b6 00             	movzbl (%eax),%eax
 30a:	0f b6 d0             	movzbl %al,%edx
 30d:	8b 45 0c             	mov    0xc(%ebp),%eax
 310:	0f b6 00             	movzbl (%eax),%eax
 313:	0f b6 c8             	movzbl %al,%ecx
 316:	89 d0                	mov    %edx,%eax
 318:	29 c8                	sub    %ecx,%eax
}
 31a:	5d                   	pop    %ebp
 31b:	c3                   	ret    

0000031c <strlen>:

uint
strlen(char *s)
{
 31c:	55                   	push   %ebp
 31d:	89 e5                	mov    %esp,%ebp
 31f:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
 322:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
 329:	eb 04                	jmp    32f <strlen+0x13>
 32b:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 32f:	8b 55 fc             	mov    -0x4(%ebp),%edx
 332:	8b 45 08             	mov    0x8(%ebp),%eax
 335:	01 d0                	add    %edx,%eax
 337:	0f b6 00             	movzbl (%eax),%eax
 33a:	84 c0                	test   %al,%al
 33c:	75 ed                	jne    32b <strlen+0xf>
    ;
  return n;
 33e:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 341:	c9                   	leave  
 342:	c3                   	ret    

00000343 <memset>:

void*
memset(void *dst, int c, uint n)
{
 343:	55                   	push   %ebp
 344:	89 e5                	mov    %esp,%ebp
  stosb(dst, c, n);
 346:	8b 45 10             	mov    0x10(%ebp),%eax
 349:	50                   	push   %eax
 34a:	ff 75 0c             	push   0xc(%ebp)
 34d:	ff 75 08             	push   0x8(%ebp)
 350:	e8 32 ff ff ff       	call   287 <stosb>
 355:	83 c4 0c             	add    $0xc,%esp
  return dst;
 358:	8b 45 08             	mov    0x8(%ebp),%eax
}
 35b:	c9                   	leave  
 35c:	c3                   	ret    

0000035d <strchr>:

char*
strchr(const char *s, char c)
{
 35d:	55                   	push   %ebp
 35e:	89 e5                	mov    %esp,%ebp
 360:	83 ec 04             	sub    $0x4,%esp
 363:	8b 45 0c             	mov    0xc(%ebp),%eax
 366:	88 45 fc             	mov    %al,-0x4(%ebp)
  for(; *s; s++)
 369:	eb 14                	jmp    37f <strchr+0x22>
    if(*s == c)
 36b:	8b 45 08             	mov    0x8(%ebp),%eax
 36e:	0f b6 00             	movzbl (%eax),%eax
 371:	38 45 fc             	cmp    %al,-0x4(%ebp)
 374:	75 05                	jne    37b <strchr+0x1e>
      return (char*)s;
 376:	8b 45 08             	mov    0x8(%ebp),%eax
 379:	eb 13                	jmp    38e <strchr+0x31>
  for(; *s; s++)
 37b:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 37f:	8b 45 08             	mov    0x8(%ebp),%eax
 382:	0f b6 00             	movzbl (%eax),%eax
 385:	84 c0                	test   %al,%al
 387:	75 e2                	jne    36b <strchr+0xe>
  return 0;
 389:	b8 00 00 00 00       	mov    $0x0,%eax
}
 38e:	c9                   	leave  
 38f:	c3                   	ret    

00000390 <gets>:

char*
gets(char *buf, int max)
{
 390:	55                   	push   %ebp
 391:	89 e5                	mov    %esp,%ebp
 393:	83 ec 18             	sub    $0x18,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 396:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
 39d:	eb 42                	jmp    3e1 <gets+0x51>
    cc = read(0, &c, 1);
 39f:	83 ec 04             	sub    $0x4,%esp
 3a2:	6a 01                	push   $0x1
 3a4:	8d 45 ef             	lea    -0x11(%ebp),%eax
 3a7:	50                   	push   %eax
 3a8:	6a 00                	push   $0x0
 3aa:	e8 47 01 00 00       	call   4f6 <read>
 3af:	83 c4 10             	add    $0x10,%esp
 3b2:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(cc < 1)
 3b5:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 3b9:	7e 33                	jle    3ee <gets+0x5e>
      break;
    buf[i++] = c;
 3bb:	8b 45 f4             	mov    -0xc(%ebp),%eax
 3be:	8d 50 01             	lea    0x1(%eax),%edx
 3c1:	89 55 f4             	mov    %edx,-0xc(%ebp)
 3c4:	89 c2                	mov    %eax,%edx
 3c6:	8b 45 08             	mov    0x8(%ebp),%eax
 3c9:	01 c2                	add    %eax,%edx
 3cb:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 3cf:	88 02                	mov    %al,(%edx)
    if(c == '\n' || c == '\r')
 3d1:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 3d5:	3c 0a                	cmp    $0xa,%al
 3d7:	74 16                	je     3ef <gets+0x5f>
 3d9:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 3dd:	3c 0d                	cmp    $0xd,%al
 3df:	74 0e                	je     3ef <gets+0x5f>
  for(i=0; i+1 < max; ){
 3e1:	8b 45 f4             	mov    -0xc(%ebp),%eax
 3e4:	83 c0 01             	add    $0x1,%eax
 3e7:	39 45 0c             	cmp    %eax,0xc(%ebp)
 3ea:	7f b3                	jg     39f <gets+0xf>
 3ec:	eb 01                	jmp    3ef <gets+0x5f>
      break;
 3ee:	90                   	nop
      break;
  }
  buf[i] = '\0';
 3ef:	8b 55 f4             	mov    -0xc(%ebp),%edx
 3f2:	8b 45 08             	mov    0x8(%ebp),%eax
 3f5:	01 d0                	add    %edx,%eax
 3f7:	c6 00 00             	movb   $0x0,(%eax)
  return buf;
 3fa:	8b 45 08             	mov    0x8(%ebp),%eax
}
 3fd:	c9                   	leave  
 3fe:	c3                   	ret    

000003ff <stat>:

int
stat(char *n, struct stat *st)
{
 3ff:	55                   	push   %ebp
 400:	89 e5                	mov    %esp,%ebp
 402:	83 ec 18             	sub    $0x18,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 405:	83 ec 08             	sub    $0x8,%esp
 408:	6a 00                	push   $0x0
 40a:	ff 75 08             	push   0x8(%ebp)
 40d:	e8 0c 01 00 00       	call   51e <open>
 412:	83 c4 10             	add    $0x10,%esp
 415:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0)
 418:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 41c:	79 07                	jns    425 <stat+0x26>
    return -1;
 41e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 423:	eb 25                	jmp    44a <stat+0x4b>
  r = fstat(fd, st);
 425:	83 ec 08             	sub    $0x8,%esp
 428:	ff 75 0c             	push   0xc(%ebp)
 42b:	ff 75 f4             	push   -0xc(%ebp)
 42e:	e8 03 01 00 00       	call   536 <fstat>
 433:	83 c4 10             	add    $0x10,%esp
 436:	89 45 f0             	mov    %eax,-0x10(%ebp)
  close(fd);
 439:	83 ec 0c             	sub    $0xc,%esp
 43c:	ff 75 f4             	push   -0xc(%ebp)
 43f:	e8 c2 00 00 00       	call   506 <close>
 444:	83 c4 10             	add    $0x10,%esp
  return r;
 447:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
 44a:	c9                   	leave  
 44b:	c3                   	ret    

0000044c <atoi>:

int
atoi(const char *s)
{
 44c:	55                   	push   %ebp
 44d:	89 e5                	mov    %esp,%ebp
 44f:	83 ec 10             	sub    $0x10,%esp
  int n;

  n = 0;
 452:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while('0' <= *s && *s <= '9')
 459:	eb 25                	jmp    480 <atoi+0x34>
    n = n*10 + *s++ - '0';
 45b:	8b 55 fc             	mov    -0x4(%ebp),%edx
 45e:	89 d0                	mov    %edx,%eax
 460:	c1 e0 02             	shl    $0x2,%eax
 463:	01 d0                	add    %edx,%eax
 465:	01 c0                	add    %eax,%eax
 467:	89 c1                	mov    %eax,%ecx
 469:	8b 45 08             	mov    0x8(%ebp),%eax
 46c:	8d 50 01             	lea    0x1(%eax),%edx
 46f:	89 55 08             	mov    %edx,0x8(%ebp)
 472:	0f b6 00             	movzbl (%eax),%eax
 475:	0f be c0             	movsbl %al,%eax
 478:	01 c8                	add    %ecx,%eax
 47a:	83 e8 30             	sub    $0x30,%eax
 47d:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while('0' <= *s && *s <= '9')
 480:	8b 45 08             	mov    0x8(%ebp),%eax
 483:	0f b6 00             	movzbl (%eax),%eax
 486:	3c 2f                	cmp    $0x2f,%al
 488:	7e 0a                	jle    494 <atoi+0x48>
 48a:	8b 45 08             	mov    0x8(%ebp),%eax
 48d:	0f b6 00             	movzbl (%eax),%eax
 490:	3c 39                	cmp    $0x39,%al
 492:	7e c7                	jle    45b <atoi+0xf>
  return n;
 494:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 497:	c9                   	leave  
 498:	c3                   	ret    

00000499 <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
 499:	55                   	push   %ebp
 49a:	89 e5                	mov    %esp,%ebp
 49c:	83 ec 10             	sub    $0x10,%esp
  char *dst, *src;

  dst = vdst;
 49f:	8b 45 08             	mov    0x8(%ebp),%eax
 4a2:	89 45 fc             	mov    %eax,-0x4(%ebp)
  src = vsrc;
 4a5:	8b 45 0c             	mov    0xc(%ebp),%eax
 4a8:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0)
 4ab:	eb 17                	jmp    4c4 <memmove+0x2b>
    *dst++ = *src++;
 4ad:	8b 55 f8             	mov    -0x8(%ebp),%edx
 4b0:	8d 42 01             	lea    0x1(%edx),%eax
 4b3:	89 45 f8             	mov    %eax,-0x8(%ebp)
 4b6:	8b 45 fc             	mov    -0x4(%ebp),%eax
 4b9:	8d 48 01             	lea    0x1(%eax),%ecx
 4bc:	89 4d fc             	mov    %ecx,-0x4(%ebp)
 4bf:	0f b6 12             	movzbl (%edx),%edx
 4c2:	88 10                	mov    %dl,(%eax)
  while(n-- > 0)
 4c4:	8b 45 10             	mov    0x10(%ebp),%eax
 4c7:	8d 50 ff             	lea    -0x1(%eax),%edx
 4ca:	89 55 10             	mov    %edx,0x10(%ebp)
 4cd:	85 c0                	test   %eax,%eax
 4cf:	7f dc                	jg     4ad <memmove+0x14>
  return vdst;
 4d1:	8b 45 08             	mov    0x8(%ebp),%eax
}
 4d4:	c9                   	leave  
 4d5:	c3                   	ret    

000004d6 <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 4d6:	b8 01 00 00 00       	mov    $0x1,%eax
 4db:	cd 40                	int    $0x40
 4dd:	c3                   	ret    

000004de <exit>:
SYSCALL(exit)
 4de:	b8 02 00 00 00       	mov    $0x2,%eax
 4e3:	cd 40                	int    $0x40
 4e5:	c3                   	ret    

000004e6 <wait>:
SYSCALL(wait)
 4e6:	b8 03 00 00 00       	mov    $0x3,%eax
 4eb:	cd 40                	int    $0x40
 4ed:	c3                   	ret    

000004ee <pipe>:
SYSCALL(pipe)
 4ee:	b8 04 00 00 00       	mov    $0x4,%eax
 4f3:	cd 40                	int    $0x40
 4f5:	c3                   	ret    

000004f6 <read>:
SYSCALL(read)
 4f6:	b8 05 00 00 00       	mov    $0x5,%eax
 4fb:	cd 40                	int    $0x40
 4fd:	c3                   	ret    

000004fe <write>:
SYSCALL(write)
 4fe:	b8 10 00 00 00       	mov    $0x10,%eax
 503:	cd 40                	int    $0x40
 505:	c3                   	ret    

00000506 <close>:
SYSCALL(close)
 506:	b8 15 00 00 00       	mov    $0x15,%eax
 50b:	cd 40                	int    $0x40
 50d:	c3                   	ret    

0000050e <kill>:
SYSCALL(kill)
 50e:	b8 06 00 00 00       	mov    $0x6,%eax
 513:	cd 40                	int    $0x40
 515:	c3                   	ret    

00000516 <exec>:
SYSCALL(exec)
 516:	b8 07 00 00 00       	mov    $0x7,%eax
 51b:	cd 40                	int    $0x40
 51d:	c3                   	ret    

0000051e <open>:
SYSCALL(open)
 51e:	b8 0f 00 00 00       	mov    $0xf,%eax
 523:	cd 40                	int    $0x40
 525:	c3                   	ret    

00000526 <mknod>:
SYSCALL(mknod)
 526:	b8 11 00 00 00       	mov    $0x11,%eax
 52b:	cd 40                	int    $0x40
 52d:	c3                   	ret    

0000052e <unlink>:
SYSCALL(unlink)
 52e:	b8 12 00 00 00       	mov    $0x12,%eax
 533:	cd 40                	int    $0x40
 535:	c3                   	ret    

00000536 <fstat>:
SYSCALL(fstat)
 536:	b8 08 00 00 00       	mov    $0x8,%eax
 53b:	cd 40                	int    $0x40
 53d:	c3                   	ret    

0000053e <link>:
SYSCALL(link)
 53e:	b8 13 00 00 00       	mov    $0x13,%eax
 543:	cd 40                	int    $0x40
 545:	c3                   	ret    

00000546 <mkdir>:
SYSCALL(mkdir)
 546:	b8 14 00 00 00       	mov    $0x14,%eax
 54b:	cd 40                	int    $0x40
 54d:	c3                   	ret    

0000054e <chdir>:
SYSCALL(chdir)
 54e:	b8 09 00 00 00       	mov    $0x9,%eax
 553:	cd 40                	int    $0x40
 555:	c3                   	ret    

00000556 <dup>:
SYSCALL(dup)
 556:	b8 0a 00 00 00       	mov    $0xa,%eax
 55b:	cd 40                	int    $0x40
 55d:	c3                   	ret    

0000055e <getpid>:
SYSCALL(getpid)
 55e:	b8 0b 00 00 00       	mov    $0xb,%eax
 563:	cd 40                	int    $0x40
 565:	c3                   	ret    

00000566 <sbrk>:
SYSCALL(sbrk)
 566:	b8 0c 00 00 00       	mov    $0xc,%eax
 56b:	cd 40                	int    $0x40
 56d:	c3                   	ret    

0000056e <sleep>:
SYSCALL(sleep)
 56e:	b8 0d 00 00 00       	mov    $0xd,%eax
 573:	cd 40                	int    $0x40
 575:	c3                   	ret    

00000576 <uptime>:
SYSCALL(uptime)
 576:	b8 0e 00 00 00       	mov    $0xe,%eax
 57b:	cd 40                	int    $0x40
 57d:	c3                   	ret    

0000057e <exit2>:
SYSCALL(exit2)
 57e:	b8 16 00 00 00       	mov    $0x16,%eax
 583:	cd 40                	int    $0x40
 585:	c3                   	ret    

00000586 <wait2>:
SYSCALL(wait2)
 586:	b8 17 00 00 00       	mov    $0x17,%eax
 58b:	cd 40                	int    $0x40
 58d:	c3                   	ret    

0000058e <uthread_init>:
SYSCALL(uthread_init)
 58e:	b8 18 00 00 00       	mov    $0x18,%eax
 593:	cd 40                	int    $0x40
 595:	c3                   	ret    

00000596 <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 596:	55                   	push   %ebp
 597:	89 e5                	mov    %esp,%ebp
 599:	83 ec 18             	sub    $0x18,%esp
 59c:	8b 45 0c             	mov    0xc(%ebp),%eax
 59f:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
 5a2:	83 ec 04             	sub    $0x4,%esp
 5a5:	6a 01                	push   $0x1
 5a7:	8d 45 f4             	lea    -0xc(%ebp),%eax
 5aa:	50                   	push   %eax
 5ab:	ff 75 08             	push   0x8(%ebp)
 5ae:	e8 4b ff ff ff       	call   4fe <write>
 5b3:	83 c4 10             	add    $0x10,%esp
}
 5b6:	90                   	nop
 5b7:	c9                   	leave  
 5b8:	c3                   	ret    

000005b9 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 5b9:	55                   	push   %ebp
 5ba:	89 e5                	mov    %esp,%ebp
 5bc:	83 ec 28             	sub    $0x28,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
 5bf:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
 5c6:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
 5ca:	74 17                	je     5e3 <printint+0x2a>
 5cc:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
 5d0:	79 11                	jns    5e3 <printint+0x2a>
    neg = 1;
 5d2:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
 5d9:	8b 45 0c             	mov    0xc(%ebp),%eax
 5dc:	f7 d8                	neg    %eax
 5de:	89 45 ec             	mov    %eax,-0x14(%ebp)
 5e1:	eb 06                	jmp    5e9 <printint+0x30>
  } else {
    x = xx;
 5e3:	8b 45 0c             	mov    0xc(%ebp),%eax
 5e6:	89 45 ec             	mov    %eax,-0x14(%ebp)
  }

  i = 0;
 5e9:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
 5f0:	8b 4d 10             	mov    0x10(%ebp),%ecx
 5f3:	8b 45 ec             	mov    -0x14(%ebp),%eax
 5f6:	ba 00 00 00 00       	mov    $0x0,%edx
 5fb:	f7 f1                	div    %ecx
 5fd:	89 d1                	mov    %edx,%ecx
 5ff:	8b 45 f4             	mov    -0xc(%ebp),%eax
 602:	8d 50 01             	lea    0x1(%eax),%edx
 605:	89 55 f4             	mov    %edx,-0xc(%ebp)
 608:	0f b6 91 ac 0d 00 00 	movzbl 0xdac(%ecx),%edx
 60f:	88 54 05 dc          	mov    %dl,-0x24(%ebp,%eax,1)
  }while((x /= base) != 0);
 613:	8b 4d 10             	mov    0x10(%ebp),%ecx
 616:	8b 45 ec             	mov    -0x14(%ebp),%eax
 619:	ba 00 00 00 00       	mov    $0x0,%edx
 61e:	f7 f1                	div    %ecx
 620:	89 45 ec             	mov    %eax,-0x14(%ebp)
 623:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 627:	75 c7                	jne    5f0 <printint+0x37>
  if(neg)
 629:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 62d:	74 2d                	je     65c <printint+0xa3>
    buf[i++] = '-';
 62f:	8b 45 f4             	mov    -0xc(%ebp),%eax
 632:	8d 50 01             	lea    0x1(%eax),%edx
 635:	89 55 f4             	mov    %edx,-0xc(%ebp)
 638:	c6 44 05 dc 2d       	movb   $0x2d,-0x24(%ebp,%eax,1)

  while(--i >= 0)
 63d:	eb 1d                	jmp    65c <printint+0xa3>
    putc(fd, buf[i]);
 63f:	8d 55 dc             	lea    -0x24(%ebp),%edx
 642:	8b 45 f4             	mov    -0xc(%ebp),%eax
 645:	01 d0                	add    %edx,%eax
 647:	0f b6 00             	movzbl (%eax),%eax
 64a:	0f be c0             	movsbl %al,%eax
 64d:	83 ec 08             	sub    $0x8,%esp
 650:	50                   	push   %eax
 651:	ff 75 08             	push   0x8(%ebp)
 654:	e8 3d ff ff ff       	call   596 <putc>
 659:	83 c4 10             	add    $0x10,%esp
  while(--i >= 0)
 65c:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
 660:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 664:	79 d9                	jns    63f <printint+0x86>
}
 666:	90                   	nop
 667:	90                   	nop
 668:	c9                   	leave  
 669:	c3                   	ret    

0000066a <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 66a:	55                   	push   %ebp
 66b:	89 e5                	mov    %esp,%ebp
 66d:	83 ec 28             	sub    $0x28,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
 670:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  ap = (uint*)(void*)&fmt + 1;
 677:	8d 45 0c             	lea    0xc(%ebp),%eax
 67a:	83 c0 04             	add    $0x4,%eax
 67d:	89 45 e8             	mov    %eax,-0x18(%ebp)
  for(i = 0; fmt[i]; i++){
 680:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
 687:	e9 59 01 00 00       	jmp    7e5 <printf+0x17b>
    c = fmt[i] & 0xff;
 68c:	8b 55 0c             	mov    0xc(%ebp),%edx
 68f:	8b 45 f0             	mov    -0x10(%ebp),%eax
 692:	01 d0                	add    %edx,%eax
 694:	0f b6 00             	movzbl (%eax),%eax
 697:	0f be c0             	movsbl %al,%eax
 69a:	25 ff 00 00 00       	and    $0xff,%eax
 69f:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(state == 0){
 6a2:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 6a6:	75 2c                	jne    6d4 <printf+0x6a>
      if(c == '%'){
 6a8:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 6ac:	75 0c                	jne    6ba <printf+0x50>
        state = '%';
 6ae:	c7 45 ec 25 00 00 00 	movl   $0x25,-0x14(%ebp)
 6b5:	e9 27 01 00 00       	jmp    7e1 <printf+0x177>
      } else {
        putc(fd, c);
 6ba:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 6bd:	0f be c0             	movsbl %al,%eax
 6c0:	83 ec 08             	sub    $0x8,%esp
 6c3:	50                   	push   %eax
 6c4:	ff 75 08             	push   0x8(%ebp)
 6c7:	e8 ca fe ff ff       	call   596 <putc>
 6cc:	83 c4 10             	add    $0x10,%esp
 6cf:	e9 0d 01 00 00       	jmp    7e1 <printf+0x177>
      }
    } else if(state == '%'){
 6d4:	83 7d ec 25          	cmpl   $0x25,-0x14(%ebp)
 6d8:	0f 85 03 01 00 00    	jne    7e1 <printf+0x177>
      if(c == 'd'){
 6de:	83 7d e4 64          	cmpl   $0x64,-0x1c(%ebp)
 6e2:	75 1e                	jne    702 <printf+0x98>
        printint(fd, *ap, 10, 1);
 6e4:	8b 45 e8             	mov    -0x18(%ebp),%eax
 6e7:	8b 00                	mov    (%eax),%eax
 6e9:	6a 01                	push   $0x1
 6eb:	6a 0a                	push   $0xa
 6ed:	50                   	push   %eax
 6ee:	ff 75 08             	push   0x8(%ebp)
 6f1:	e8 c3 fe ff ff       	call   5b9 <printint>
 6f6:	83 c4 10             	add    $0x10,%esp
        ap++;
 6f9:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 6fd:	e9 d8 00 00 00       	jmp    7da <printf+0x170>
      } else if(c == 'x' || c == 'p'){
 702:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
 706:	74 06                	je     70e <printf+0xa4>
 708:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
 70c:	75 1e                	jne    72c <printf+0xc2>
        printint(fd, *ap, 16, 0);
 70e:	8b 45 e8             	mov    -0x18(%ebp),%eax
 711:	8b 00                	mov    (%eax),%eax
 713:	6a 00                	push   $0x0
 715:	6a 10                	push   $0x10
 717:	50                   	push   %eax
 718:	ff 75 08             	push   0x8(%ebp)
 71b:	e8 99 fe ff ff       	call   5b9 <printint>
 720:	83 c4 10             	add    $0x10,%esp
        ap++;
 723:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 727:	e9 ae 00 00 00       	jmp    7da <printf+0x170>
      } else if(c == 's'){
 72c:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
 730:	75 43                	jne    775 <printf+0x10b>
        s = (char*)*ap;
 732:	8b 45 e8             	mov    -0x18(%ebp),%eax
 735:	8b 00                	mov    (%eax),%eax
 737:	89 45 f4             	mov    %eax,-0xc(%ebp)
        ap++;
 73a:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
        if(s == 0)
 73e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 742:	75 25                	jne    769 <printf+0xff>
          s = "(null)";
 744:	c7 45 f4 97 0a 00 00 	movl   $0xa97,-0xc(%ebp)
        while(*s != 0){
 74b:	eb 1c                	jmp    769 <printf+0xff>
          putc(fd, *s);
 74d:	8b 45 f4             	mov    -0xc(%ebp),%eax
 750:	0f b6 00             	movzbl (%eax),%eax
 753:	0f be c0             	movsbl %al,%eax
 756:	83 ec 08             	sub    $0x8,%esp
 759:	50                   	push   %eax
 75a:	ff 75 08             	push   0x8(%ebp)
 75d:	e8 34 fe ff ff       	call   596 <putc>
 762:	83 c4 10             	add    $0x10,%esp
          s++;
 765:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
        while(*s != 0){
 769:	8b 45 f4             	mov    -0xc(%ebp),%eax
 76c:	0f b6 00             	movzbl (%eax),%eax
 76f:	84 c0                	test   %al,%al
 771:	75 da                	jne    74d <printf+0xe3>
 773:	eb 65                	jmp    7da <printf+0x170>
        }
      } else if(c == 'c'){
 775:	83 7d e4 63          	cmpl   $0x63,-0x1c(%ebp)
 779:	75 1d                	jne    798 <printf+0x12e>
        putc(fd, *ap);
 77b:	8b 45 e8             	mov    -0x18(%ebp),%eax
 77e:	8b 00                	mov    (%eax),%eax
 780:	0f be c0             	movsbl %al,%eax
 783:	83 ec 08             	sub    $0x8,%esp
 786:	50                   	push   %eax
 787:	ff 75 08             	push   0x8(%ebp)
 78a:	e8 07 fe ff ff       	call   596 <putc>
 78f:	83 c4 10             	add    $0x10,%esp
        ap++;
 792:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 796:	eb 42                	jmp    7da <printf+0x170>
      } else if(c == '%'){
 798:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 79c:	75 17                	jne    7b5 <printf+0x14b>
        putc(fd, c);
 79e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 7a1:	0f be c0             	movsbl %al,%eax
 7a4:	83 ec 08             	sub    $0x8,%esp
 7a7:	50                   	push   %eax
 7a8:	ff 75 08             	push   0x8(%ebp)
 7ab:	e8 e6 fd ff ff       	call   596 <putc>
 7b0:	83 c4 10             	add    $0x10,%esp
 7b3:	eb 25                	jmp    7da <printf+0x170>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 7b5:	83 ec 08             	sub    $0x8,%esp
 7b8:	6a 25                	push   $0x25
 7ba:	ff 75 08             	push   0x8(%ebp)
 7bd:	e8 d4 fd ff ff       	call   596 <putc>
 7c2:	83 c4 10             	add    $0x10,%esp
        putc(fd, c);
 7c5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 7c8:	0f be c0             	movsbl %al,%eax
 7cb:	83 ec 08             	sub    $0x8,%esp
 7ce:	50                   	push   %eax
 7cf:	ff 75 08             	push   0x8(%ebp)
 7d2:	e8 bf fd ff ff       	call   596 <putc>
 7d7:	83 c4 10             	add    $0x10,%esp
      }
      state = 0;
 7da:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  for(i = 0; fmt[i]; i++){
 7e1:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
 7e5:	8b 55 0c             	mov    0xc(%ebp),%edx
 7e8:	8b 45 f0             	mov    -0x10(%ebp),%eax
 7eb:	01 d0                	add    %edx,%eax
 7ed:	0f b6 00             	movzbl (%eax),%eax
 7f0:	84 c0                	test   %al,%al
 7f2:	0f 85 94 fe ff ff    	jne    68c <printf+0x22>
    }
  }
}
 7f8:	90                   	nop
 7f9:	90                   	nop
 7fa:	c9                   	leave  
 7fb:	c3                   	ret    

000007fc <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 7fc:	55                   	push   %ebp
 7fd:	89 e5                	mov    %esp,%ebp
 7ff:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
 802:	8b 45 08             	mov    0x8(%ebp),%eax
 805:	83 e8 08             	sub    $0x8,%eax
 808:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 80b:	a1 08 8e 00 00       	mov    0x8e08,%eax
 810:	89 45 fc             	mov    %eax,-0x4(%ebp)
 813:	eb 24                	jmp    839 <free+0x3d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 815:	8b 45 fc             	mov    -0x4(%ebp),%eax
 818:	8b 00                	mov    (%eax),%eax
 81a:	39 45 fc             	cmp    %eax,-0x4(%ebp)
 81d:	72 12                	jb     831 <free+0x35>
 81f:	8b 45 f8             	mov    -0x8(%ebp),%eax
 822:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 825:	77 24                	ja     84b <free+0x4f>
 827:	8b 45 fc             	mov    -0x4(%ebp),%eax
 82a:	8b 00                	mov    (%eax),%eax
 82c:	39 45 f8             	cmp    %eax,-0x8(%ebp)
 82f:	72 1a                	jb     84b <free+0x4f>
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 831:	8b 45 fc             	mov    -0x4(%ebp),%eax
 834:	8b 00                	mov    (%eax),%eax
 836:	89 45 fc             	mov    %eax,-0x4(%ebp)
 839:	8b 45 f8             	mov    -0x8(%ebp),%eax
 83c:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 83f:	76 d4                	jbe    815 <free+0x19>
 841:	8b 45 fc             	mov    -0x4(%ebp),%eax
 844:	8b 00                	mov    (%eax),%eax
 846:	39 45 f8             	cmp    %eax,-0x8(%ebp)
 849:	73 ca                	jae    815 <free+0x19>
      break;
  if(bp + bp->s.size == p->s.ptr){
 84b:	8b 45 f8             	mov    -0x8(%ebp),%eax
 84e:	8b 40 04             	mov    0x4(%eax),%eax
 851:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 858:	8b 45 f8             	mov    -0x8(%ebp),%eax
 85b:	01 c2                	add    %eax,%edx
 85d:	8b 45 fc             	mov    -0x4(%ebp),%eax
 860:	8b 00                	mov    (%eax),%eax
 862:	39 c2                	cmp    %eax,%edx
 864:	75 24                	jne    88a <free+0x8e>
    bp->s.size += p->s.ptr->s.size;
 866:	8b 45 f8             	mov    -0x8(%ebp),%eax
 869:	8b 50 04             	mov    0x4(%eax),%edx
 86c:	8b 45 fc             	mov    -0x4(%ebp),%eax
 86f:	8b 00                	mov    (%eax),%eax
 871:	8b 40 04             	mov    0x4(%eax),%eax
 874:	01 c2                	add    %eax,%edx
 876:	8b 45 f8             	mov    -0x8(%ebp),%eax
 879:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
 87c:	8b 45 fc             	mov    -0x4(%ebp),%eax
 87f:	8b 00                	mov    (%eax),%eax
 881:	8b 10                	mov    (%eax),%edx
 883:	8b 45 f8             	mov    -0x8(%ebp),%eax
 886:	89 10                	mov    %edx,(%eax)
 888:	eb 0a                	jmp    894 <free+0x98>
  } else
    bp->s.ptr = p->s.ptr;
 88a:	8b 45 fc             	mov    -0x4(%ebp),%eax
 88d:	8b 10                	mov    (%eax),%edx
 88f:	8b 45 f8             	mov    -0x8(%ebp),%eax
 892:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
 894:	8b 45 fc             	mov    -0x4(%ebp),%eax
 897:	8b 40 04             	mov    0x4(%eax),%eax
 89a:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 8a1:	8b 45 fc             	mov    -0x4(%ebp),%eax
 8a4:	01 d0                	add    %edx,%eax
 8a6:	39 45 f8             	cmp    %eax,-0x8(%ebp)
 8a9:	75 20                	jne    8cb <free+0xcf>
    p->s.size += bp->s.size;
 8ab:	8b 45 fc             	mov    -0x4(%ebp),%eax
 8ae:	8b 50 04             	mov    0x4(%eax),%edx
 8b1:	8b 45 f8             	mov    -0x8(%ebp),%eax
 8b4:	8b 40 04             	mov    0x4(%eax),%eax
 8b7:	01 c2                	add    %eax,%edx
 8b9:	8b 45 fc             	mov    -0x4(%ebp),%eax
 8bc:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 8bf:	8b 45 f8             	mov    -0x8(%ebp),%eax
 8c2:	8b 10                	mov    (%eax),%edx
 8c4:	8b 45 fc             	mov    -0x4(%ebp),%eax
 8c7:	89 10                	mov    %edx,(%eax)
 8c9:	eb 08                	jmp    8d3 <free+0xd7>
  } else
    p->s.ptr = bp;
 8cb:	8b 45 fc             	mov    -0x4(%ebp),%eax
 8ce:	8b 55 f8             	mov    -0x8(%ebp),%edx
 8d1:	89 10                	mov    %edx,(%eax)
  freep = p;
 8d3:	8b 45 fc             	mov    -0x4(%ebp),%eax
 8d6:	a3 08 8e 00 00       	mov    %eax,0x8e08
}
 8db:	90                   	nop
 8dc:	c9                   	leave  
 8dd:	c3                   	ret    

000008de <morecore>:

static Header*
morecore(uint nu)
{
 8de:	55                   	push   %ebp
 8df:	89 e5                	mov    %esp,%ebp
 8e1:	83 ec 18             	sub    $0x18,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
 8e4:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
 8eb:	77 07                	ja     8f4 <morecore+0x16>
    nu = 4096;
 8ed:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
 8f4:	8b 45 08             	mov    0x8(%ebp),%eax
 8f7:	c1 e0 03             	shl    $0x3,%eax
 8fa:	83 ec 0c             	sub    $0xc,%esp
 8fd:	50                   	push   %eax
 8fe:	e8 63 fc ff ff       	call   566 <sbrk>
 903:	83 c4 10             	add    $0x10,%esp
 906:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(p == (char*)-1)
 909:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
 90d:	75 07                	jne    916 <morecore+0x38>
    return 0;
 90f:	b8 00 00 00 00       	mov    $0x0,%eax
 914:	eb 26                	jmp    93c <morecore+0x5e>
  hp = (Header*)p;
 916:	8b 45 f4             	mov    -0xc(%ebp),%eax
 919:	89 45 f0             	mov    %eax,-0x10(%ebp)
  hp->s.size = nu;
 91c:	8b 45 f0             	mov    -0x10(%ebp),%eax
 91f:	8b 55 08             	mov    0x8(%ebp),%edx
 922:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
 925:	8b 45 f0             	mov    -0x10(%ebp),%eax
 928:	83 c0 08             	add    $0x8,%eax
 92b:	83 ec 0c             	sub    $0xc,%esp
 92e:	50                   	push   %eax
 92f:	e8 c8 fe ff ff       	call   7fc <free>
 934:	83 c4 10             	add    $0x10,%esp
  return freep;
 937:	a1 08 8e 00 00       	mov    0x8e08,%eax
}
 93c:	c9                   	leave  
 93d:	c3                   	ret    

0000093e <malloc>:

void*
malloc(uint nbytes)
{
 93e:	55                   	push   %ebp
 93f:	89 e5                	mov    %esp,%ebp
 941:	83 ec 18             	sub    $0x18,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 944:	8b 45 08             	mov    0x8(%ebp),%eax
 947:	83 c0 07             	add    $0x7,%eax
 94a:	c1 e8 03             	shr    $0x3,%eax
 94d:	83 c0 01             	add    $0x1,%eax
 950:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((prevp = freep) == 0){
 953:	a1 08 8e 00 00       	mov    0x8e08,%eax
 958:	89 45 f0             	mov    %eax,-0x10(%ebp)
 95b:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 95f:	75 23                	jne    984 <malloc+0x46>
    base.s.ptr = freep = prevp = &base;
 961:	c7 45 f0 00 8e 00 00 	movl   $0x8e00,-0x10(%ebp)
 968:	8b 45 f0             	mov    -0x10(%ebp),%eax
 96b:	a3 08 8e 00 00       	mov    %eax,0x8e08
 970:	a1 08 8e 00 00       	mov    0x8e08,%eax
 975:	a3 00 8e 00 00       	mov    %eax,0x8e00
    base.s.size = 0;
 97a:	c7 05 04 8e 00 00 00 	movl   $0x0,0x8e04
 981:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 984:	8b 45 f0             	mov    -0x10(%ebp),%eax
 987:	8b 00                	mov    (%eax),%eax
 989:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
 98c:	8b 45 f4             	mov    -0xc(%ebp),%eax
 98f:	8b 40 04             	mov    0x4(%eax),%eax
 992:	39 45 ec             	cmp    %eax,-0x14(%ebp)
 995:	77 4d                	ja     9e4 <malloc+0xa6>
      if(p->s.size == nunits)
 997:	8b 45 f4             	mov    -0xc(%ebp),%eax
 99a:	8b 40 04             	mov    0x4(%eax),%eax
 99d:	39 45 ec             	cmp    %eax,-0x14(%ebp)
 9a0:	75 0c                	jne    9ae <malloc+0x70>
        prevp->s.ptr = p->s.ptr;
 9a2:	8b 45 f4             	mov    -0xc(%ebp),%eax
 9a5:	8b 10                	mov    (%eax),%edx
 9a7:	8b 45 f0             	mov    -0x10(%ebp),%eax
 9aa:	89 10                	mov    %edx,(%eax)
 9ac:	eb 26                	jmp    9d4 <malloc+0x96>
      else {
        p->s.size -= nunits;
 9ae:	8b 45 f4             	mov    -0xc(%ebp),%eax
 9b1:	8b 40 04             	mov    0x4(%eax),%eax
 9b4:	2b 45 ec             	sub    -0x14(%ebp),%eax
 9b7:	89 c2                	mov    %eax,%edx
 9b9:	8b 45 f4             	mov    -0xc(%ebp),%eax
 9bc:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
 9bf:	8b 45 f4             	mov    -0xc(%ebp),%eax
 9c2:	8b 40 04             	mov    0x4(%eax),%eax
 9c5:	c1 e0 03             	shl    $0x3,%eax
 9c8:	01 45 f4             	add    %eax,-0xc(%ebp)
        p->s.size = nunits;
 9cb:	8b 45 f4             	mov    -0xc(%ebp),%eax
 9ce:	8b 55 ec             	mov    -0x14(%ebp),%edx
 9d1:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
 9d4:	8b 45 f0             	mov    -0x10(%ebp),%eax
 9d7:	a3 08 8e 00 00       	mov    %eax,0x8e08
      return (void*)(p + 1);
 9dc:	8b 45 f4             	mov    -0xc(%ebp),%eax
 9df:	83 c0 08             	add    $0x8,%eax
 9e2:	eb 3b                	jmp    a1f <malloc+0xe1>
    }
    if(p == freep)
 9e4:	a1 08 8e 00 00       	mov    0x8e08,%eax
 9e9:	39 45 f4             	cmp    %eax,-0xc(%ebp)
 9ec:	75 1e                	jne    a0c <malloc+0xce>
      if((p = morecore(nunits)) == 0)
 9ee:	83 ec 0c             	sub    $0xc,%esp
 9f1:	ff 75 ec             	push   -0x14(%ebp)
 9f4:	e8 e5 fe ff ff       	call   8de <morecore>
 9f9:	83 c4 10             	add    $0x10,%esp
 9fc:	89 45 f4             	mov    %eax,-0xc(%ebp)
 9ff:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 a03:	75 07                	jne    a0c <malloc+0xce>
        return 0;
 a05:	b8 00 00 00 00       	mov    $0x0,%eax
 a0a:	eb 13                	jmp    a1f <malloc+0xe1>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 a0c:	8b 45 f4             	mov    -0xc(%ebp),%eax
 a0f:	89 45 f0             	mov    %eax,-0x10(%ebp)
 a12:	8b 45 f4             	mov    -0xc(%ebp),%eax
 a15:	8b 00                	mov    (%eax),%eax
 a17:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
 a1a:	e9 6d ff ff ff       	jmp    98c <malloc+0x4e>
  }
}
 a1f:	c9                   	leave  
 a20:	c3                   	ret    
