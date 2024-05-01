
_uthread:     file format elf32-i386


Disassembly of section .text:

00000000 <thread_schedule>:



static void 
thread_schedule(void)
{
   0:	55                   	push   %ebp
   1:	89 e5                	mov    %esp,%ebp
   3:	83 ec 18             	sub    $0x18,%esp
  thread_p t;

  /* Find another runnable thread. */
  next_thread = 0;
   6:	c7 05 64 0d 00 00 00 	movl   $0x0,0xd64
   d:	00 00 00 
  for (t = all_thread; t < all_thread + MAX_THREAD; t++) {
  10:	c7 45 f4 80 0d 00 00 	movl   $0xd80,-0xc(%ebp)
  17:	eb 29                	jmp    42 <thread_schedule+0x42>
    if (t->state == RUNNABLE && t != current_thread) {
  19:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1c:	8b 80 04 20 00 00    	mov    0x2004(%eax),%eax
  22:	83 f8 02             	cmp    $0x2,%eax
  25:	75 14                	jne    3b <thread_schedule+0x3b>
  27:	a1 60 0d 00 00       	mov    0xd60,%eax
  2c:	39 45 f4             	cmp    %eax,-0xc(%ebp)
  2f:	74 0a                	je     3b <thread_schedule+0x3b>
      next_thread = t;
  31:	8b 45 f4             	mov    -0xc(%ebp),%eax
  34:	a3 64 0d 00 00       	mov    %eax,0xd64
      break;
  39:	eb 11                	jmp    4c <thread_schedule+0x4c>
  for (t = all_thread; t < all_thread + MAX_THREAD; t++) {
  3b:	81 45 f4 08 20 00 00 	addl   $0x2008,-0xc(%ebp)
  42:	b8 a0 8d 00 00       	mov    $0x8da0,%eax
  47:	39 45 f4             	cmp    %eax,-0xc(%ebp)
  4a:	72 cd                	jb     19 <thread_schedule+0x19>
    }
  }

  if (t >= all_thread + MAX_THREAD && current_thread->state == RUNNABLE) {
  4c:	b8 a0 8d 00 00       	mov    $0x8da0,%eax
  51:	39 45 f4             	cmp    %eax,-0xc(%ebp)
  54:	72 1a                	jb     70 <thread_schedule+0x70>
  56:	a1 60 0d 00 00       	mov    0xd60,%eax
  5b:	8b 80 04 20 00 00    	mov    0x2004(%eax),%eax
  61:	83 f8 02             	cmp    $0x2,%eax
  64:	75 0a                	jne    70 <thread_schedule+0x70>
    /* The current thread is the only runnable thread; run it. */
    next_thread = current_thread;
  66:	a1 60 0d 00 00       	mov    0xd60,%eax
  6b:	a3 64 0d 00 00       	mov    %eax,0xd64
  }

  if (next_thread == 0) {
  70:	a1 64 0d 00 00       	mov    0xd64,%eax
  75:	85 c0                	test   %eax,%eax
  77:	75 17                	jne    90 <thread_schedule+0x90>
    printf(2, "thread_schedule: no runnable threads\n");
  79:	83 ec 08             	sub    $0x8,%esp
  7c:	68 f4 09 00 00       	push   $0x9f4
  81:	6a 02                	push   $0x2
  83:	e8 b4 05 00 00       	call   63c <printf>
  88:	83 c4 10             	add    $0x10,%esp
    exit();
  8b:	e8 20 04 00 00       	call   4b0 <exit>
  }

  if (current_thread != next_thread) {         /* switch threads?  */
  90:	8b 15 60 0d 00 00    	mov    0xd60,%edx
  96:	a1 64 0d 00 00       	mov    0xd64,%eax
  9b:	39 c2                	cmp    %eax,%edx
  9d:	74 16                	je     b5 <thread_schedule+0xb5>
    next_thread->state = RUNNING;
  9f:	a1 64 0d 00 00       	mov    0xd64,%eax
  a4:	c7 80 04 20 00 00 01 	movl   $0x1,0x2004(%eax)
  ab:	00 00 00 
    thread_switch();
  ae:	e8 90 01 00 00       	call   243 <thread_switch>
  } else
    next_thread = 0;
}
  b3:	eb 0a                	jmp    bf <thread_schedule+0xbf>
    next_thread = 0;
  b5:	c7 05 64 0d 00 00 00 	movl   $0x0,0xd64
  bc:	00 00 00 
}
  bf:	90                   	nop
  c0:	c9                   	leave  
  c1:	c3                   	ret    

000000c2 <thread_init>:

void 
thread_init(void)
{
  c2:	55                   	push   %ebp
  c3:	89 e5                	mov    %esp,%ebp
  c5:	83 ec 18             	sub    $0x18,%esp
  current_thread = &all_thread[0];
  c8:	c7 05 60 0d 00 00 80 	movl   $0xd80,0xd60
  cf:	0d 00 00 
  current_thread->state = RUNNING;
  d2:	a1 60 0d 00 00       	mov    0xd60,%eax
  d7:	c7 80 04 20 00 00 01 	movl   $0x1,0x2004(%eax)
  de:	00 00 00 
  uint a = (unsigned int)&thread_schedule;
  e1:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  uthread_init(a); //***********modified. new system call.
  e8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  eb:	83 ec 0c             	sub    $0xc,%esp
  ee:	50                   	push   %eax
  ef:	e8 6c 04 00 00       	call   560 <uthread_init>
  f4:	83 c4 10             	add    $0x10,%esp
}
  f7:	90                   	nop
  f8:	c9                   	leave  
  f9:	c3                   	ret    

000000fa <thread_create>:

void 
thread_create(void (*func)())
{
  fa:	55                   	push   %ebp
  fb:	89 e5                	mov    %esp,%ebp
  fd:	83 ec 10             	sub    $0x10,%esp
  thread_p t;

  for (t = all_thread; t < all_thread + MAX_THREAD; t++) {
 100:	c7 45 fc 80 0d 00 00 	movl   $0xd80,-0x4(%ebp)
 107:	eb 14                	jmp    11d <thread_create+0x23>
    if (t->state == FREE) break;
 109:	8b 45 fc             	mov    -0x4(%ebp),%eax
 10c:	8b 80 04 20 00 00    	mov    0x2004(%eax),%eax
 112:	85 c0                	test   %eax,%eax
 114:	74 13                	je     129 <thread_create+0x2f>
  for (t = all_thread; t < all_thread + MAX_THREAD; t++) {
 116:	81 45 fc 08 20 00 00 	addl   $0x2008,-0x4(%ebp)
 11d:	b8 a0 8d 00 00       	mov    $0x8da0,%eax
 122:	39 45 fc             	cmp    %eax,-0x4(%ebp)
 125:	72 e2                	jb     109 <thread_create+0xf>
 127:	eb 01                	jmp    12a <thread_create+0x30>
    if (t->state == FREE) break;
 129:	90                   	nop
  }
  t->sp = (int) (t->stack + STACK_SIZE);   // set sp to the top of the stack
 12a:	8b 45 fc             	mov    -0x4(%ebp),%eax
 12d:	83 c0 04             	add    $0x4,%eax
 130:	05 00 20 00 00       	add    $0x2000,%eax
 135:	89 c2                	mov    %eax,%edx
 137:	8b 45 fc             	mov    -0x4(%ebp),%eax
 13a:	89 10                	mov    %edx,(%eax)
  t->sp -= 4;                              // space for return address
 13c:	8b 45 fc             	mov    -0x4(%ebp),%eax
 13f:	8b 00                	mov    (%eax),%eax
 141:	8d 50 fc             	lea    -0x4(%eax),%edx
 144:	8b 45 fc             	mov    -0x4(%ebp),%eax
 147:	89 10                	mov    %edx,(%eax)
  * (int *) (t->sp) = (int)func;           // push return address on stack
 149:	8b 45 fc             	mov    -0x4(%ebp),%eax
 14c:	8b 00                	mov    (%eax),%eax
 14e:	89 c2                	mov    %eax,%edx
 150:	8b 45 08             	mov    0x8(%ebp),%eax
 153:	89 02                	mov    %eax,(%edx)
  t->sp -= 32;                             // space for registers that thread_switch expects
 155:	8b 45 fc             	mov    -0x4(%ebp),%eax
 158:	8b 00                	mov    (%eax),%eax
 15a:	8d 50 e0             	lea    -0x20(%eax),%edx
 15d:	8b 45 fc             	mov    -0x4(%ebp),%eax
 160:	89 10                	mov    %edx,(%eax)
  t->state = RUNNABLE;
 162:	8b 45 fc             	mov    -0x4(%ebp),%eax
 165:	c7 80 04 20 00 00 02 	movl   $0x2,0x2004(%eax)
 16c:	00 00 00 
}
 16f:	90                   	nop
 170:	c9                   	leave  
 171:	c3                   	ret    

00000172 <thread_yield>:

void 
thread_yield(void)
{
 172:	55                   	push   %ebp
 173:	89 e5                	mov    %esp,%ebp
 175:	83 ec 08             	sub    $0x8,%esp
  current_thread->state = RUNNABLE;
 178:	a1 60 0d 00 00       	mov    0xd60,%eax
 17d:	c7 80 04 20 00 00 02 	movl   $0x2,0x2004(%eax)
 184:	00 00 00 
  thread_schedule();
 187:	e8 74 fe ff ff       	call   0 <thread_schedule>
}
 18c:	90                   	nop
 18d:	c9                   	leave  
 18e:	c3                   	ret    

0000018f <mythread>:

static void 
mythread(void)
{
 18f:	55                   	push   %ebp
 190:	89 e5                	mov    %esp,%ebp
 192:	83 ec 18             	sub    $0x18,%esp
  int i;
  printf(1, "my thread running\n");
 195:	83 ec 08             	sub    $0x8,%esp
 198:	68 1a 0a 00 00       	push   $0xa1a
 19d:	6a 01                	push   $0x1
 19f:	e8 98 04 00 00       	call   63c <printf>
 1a4:	83 c4 10             	add    $0x10,%esp
  for (i = 0; i < 100; i++) {
 1a7:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
 1ae:	eb 1c                	jmp    1cc <mythread+0x3d>
    printf(1, "my thread 0x%x\n", (int) current_thread);
 1b0:	a1 60 0d 00 00       	mov    0xd60,%eax
 1b5:	83 ec 04             	sub    $0x4,%esp
 1b8:	50                   	push   %eax
 1b9:	68 2d 0a 00 00       	push   $0xa2d
 1be:	6a 01                	push   $0x1
 1c0:	e8 77 04 00 00       	call   63c <printf>
 1c5:	83 c4 10             	add    $0x10,%esp
  for (i = 0; i < 100; i++) {
 1c8:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
 1cc:	83 7d f4 63          	cmpl   $0x63,-0xc(%ebp)
 1d0:	7e de                	jle    1b0 <mythread+0x21>
    //thread_yield(); *************** modified.
  }
  printf(1, "my thread: exit\n");
 1d2:	83 ec 08             	sub    $0x8,%esp
 1d5:	68 3d 0a 00 00       	push   $0xa3d
 1da:	6a 01                	push   $0x1
 1dc:	e8 5b 04 00 00       	call   63c <printf>
 1e1:	83 c4 10             	add    $0x10,%esp
  current_thread->state = FREE;
 1e4:	a1 60 0d 00 00       	mov    0xd60,%eax
 1e9:	c7 80 04 20 00 00 00 	movl   $0x0,0x2004(%eax)
 1f0:	00 00 00 
  thread_schedule();
 1f3:	e8 08 fe ff ff       	call   0 <thread_schedule>
}
 1f8:	90                   	nop
 1f9:	c9                   	leave  
 1fa:	c3                   	ret    

000001fb <main>:


int 
main(int argc, char *argv[]) 
{
 1fb:	8d 4c 24 04          	lea    0x4(%esp),%ecx
 1ff:	83 e4 f0             	and    $0xfffffff0,%esp
 202:	ff 71 fc             	push   -0x4(%ecx)
 205:	55                   	push   %ebp
 206:	89 e5                	mov    %esp,%ebp
 208:	51                   	push   %ecx
 209:	83 ec 04             	sub    $0x4,%esp
  thread_init();
 20c:	e8 b1 fe ff ff       	call   c2 <thread_init>
  thread_create(mythread);
 211:	83 ec 0c             	sub    $0xc,%esp
 214:	68 8f 01 00 00       	push   $0x18f
 219:	e8 dc fe ff ff       	call   fa <thread_create>
 21e:	83 c4 10             	add    $0x10,%esp
  thread_create(mythread);
 221:	83 ec 0c             	sub    $0xc,%esp
 224:	68 8f 01 00 00       	push   $0x18f
 229:	e8 cc fe ff ff       	call   fa <thread_create>
 22e:	83 c4 10             	add    $0x10,%esp
  thread_schedule();
 231:	e8 ca fd ff ff       	call   0 <thread_schedule>
  return 0;
 236:	b8 00 00 00 00       	mov    $0x0,%eax
}
 23b:	8b 4d fc             	mov    -0x4(%ebp),%ecx
 23e:	c9                   	leave  
 23f:	8d 61 fc             	lea    -0x4(%ecx),%esp
 242:	c3                   	ret    

00000243 <thread_switch>:
	.text

	.globl thread_switch
thread_switch:
		
	pushal	//PUSH: saving current_thread
 243:	60                   	pusha  
	
	movl current_thread, %eax	//current_thread의 주소를 %eax에 로드
 244:	a1 60 0d 00 00       	mov    0xd60,%eax
   	movl %esp, (%eax)		// %esp를 current_thread->sp에 저장
 249:	89 20                	mov    %esp,(%eax)
		
	movl next_thread, %eax		//마찬가지
 24b:	a1 64 0d 00 00       	mov    0xd64,%eax
	movl (%eax), %esp		//마찬가지
 250:	8b 20                	mov    (%eax),%esp
	
	movl %eax, current_thread	//next_threa의 시작 주소가 있는 %eax값을 다시 current_thread로
 252:	a3 60 0d 00 00       	mov    %eax,0xd60

	popal	//POP: restoring next_thread
 257:	61                   	popa   

	ret			/* return to ra*/	
 258:	c3                   	ret    

00000259 <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
 259:	55                   	push   %ebp
 25a:	89 e5                	mov    %esp,%ebp
 25c:	57                   	push   %edi
 25d:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
 25e:	8b 4d 08             	mov    0x8(%ebp),%ecx
 261:	8b 55 10             	mov    0x10(%ebp),%edx
 264:	8b 45 0c             	mov    0xc(%ebp),%eax
 267:	89 cb                	mov    %ecx,%ebx
 269:	89 df                	mov    %ebx,%edi
 26b:	89 d1                	mov    %edx,%ecx
 26d:	fc                   	cld    
 26e:	f3 aa                	rep stos %al,%es:(%edi)
 270:	89 ca                	mov    %ecx,%edx
 272:	89 fb                	mov    %edi,%ebx
 274:	89 5d 08             	mov    %ebx,0x8(%ebp)
 277:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
 27a:	90                   	nop
 27b:	5b                   	pop    %ebx
 27c:	5f                   	pop    %edi
 27d:	5d                   	pop    %ebp
 27e:	c3                   	ret    

0000027f <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
 27f:	55                   	push   %ebp
 280:	89 e5                	mov    %esp,%ebp
 282:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
 285:	8b 45 08             	mov    0x8(%ebp),%eax
 288:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while((*s++ = *t++) != 0)
 28b:	90                   	nop
 28c:	8b 55 0c             	mov    0xc(%ebp),%edx
 28f:	8d 42 01             	lea    0x1(%edx),%eax
 292:	89 45 0c             	mov    %eax,0xc(%ebp)
 295:	8b 45 08             	mov    0x8(%ebp),%eax
 298:	8d 48 01             	lea    0x1(%eax),%ecx
 29b:	89 4d 08             	mov    %ecx,0x8(%ebp)
 29e:	0f b6 12             	movzbl (%edx),%edx
 2a1:	88 10                	mov    %dl,(%eax)
 2a3:	0f b6 00             	movzbl (%eax),%eax
 2a6:	84 c0                	test   %al,%al
 2a8:	75 e2                	jne    28c <strcpy+0xd>
    ;
  return os;
 2aa:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 2ad:	c9                   	leave  
 2ae:	c3                   	ret    

000002af <strcmp>:

int
strcmp(const char *p, const char *q)
{
 2af:	55                   	push   %ebp
 2b0:	89 e5                	mov    %esp,%ebp
  while(*p && *p == *q)
 2b2:	eb 08                	jmp    2bc <strcmp+0xd>
    p++, q++;
 2b4:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 2b8:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
  while(*p && *p == *q)
 2bc:	8b 45 08             	mov    0x8(%ebp),%eax
 2bf:	0f b6 00             	movzbl (%eax),%eax
 2c2:	84 c0                	test   %al,%al
 2c4:	74 10                	je     2d6 <strcmp+0x27>
 2c6:	8b 45 08             	mov    0x8(%ebp),%eax
 2c9:	0f b6 10             	movzbl (%eax),%edx
 2cc:	8b 45 0c             	mov    0xc(%ebp),%eax
 2cf:	0f b6 00             	movzbl (%eax),%eax
 2d2:	38 c2                	cmp    %al,%dl
 2d4:	74 de                	je     2b4 <strcmp+0x5>
  return (uchar)*p - (uchar)*q;
 2d6:	8b 45 08             	mov    0x8(%ebp),%eax
 2d9:	0f b6 00             	movzbl (%eax),%eax
 2dc:	0f b6 d0             	movzbl %al,%edx
 2df:	8b 45 0c             	mov    0xc(%ebp),%eax
 2e2:	0f b6 00             	movzbl (%eax),%eax
 2e5:	0f b6 c8             	movzbl %al,%ecx
 2e8:	89 d0                	mov    %edx,%eax
 2ea:	29 c8                	sub    %ecx,%eax
}
 2ec:	5d                   	pop    %ebp
 2ed:	c3                   	ret    

000002ee <strlen>:

uint
strlen(char *s)
{
 2ee:	55                   	push   %ebp
 2ef:	89 e5                	mov    %esp,%ebp
 2f1:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
 2f4:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
 2fb:	eb 04                	jmp    301 <strlen+0x13>
 2fd:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 301:	8b 55 fc             	mov    -0x4(%ebp),%edx
 304:	8b 45 08             	mov    0x8(%ebp),%eax
 307:	01 d0                	add    %edx,%eax
 309:	0f b6 00             	movzbl (%eax),%eax
 30c:	84 c0                	test   %al,%al
 30e:	75 ed                	jne    2fd <strlen+0xf>
    ;
  return n;
 310:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 313:	c9                   	leave  
 314:	c3                   	ret    

00000315 <memset>:

void*
memset(void *dst, int c, uint n)
{
 315:	55                   	push   %ebp
 316:	89 e5                	mov    %esp,%ebp
  stosb(dst, c, n);
 318:	8b 45 10             	mov    0x10(%ebp),%eax
 31b:	50                   	push   %eax
 31c:	ff 75 0c             	push   0xc(%ebp)
 31f:	ff 75 08             	push   0x8(%ebp)
 322:	e8 32 ff ff ff       	call   259 <stosb>
 327:	83 c4 0c             	add    $0xc,%esp
  return dst;
 32a:	8b 45 08             	mov    0x8(%ebp),%eax
}
 32d:	c9                   	leave  
 32e:	c3                   	ret    

0000032f <strchr>:

char*
strchr(const char *s, char c)
{
 32f:	55                   	push   %ebp
 330:	89 e5                	mov    %esp,%ebp
 332:	83 ec 04             	sub    $0x4,%esp
 335:	8b 45 0c             	mov    0xc(%ebp),%eax
 338:	88 45 fc             	mov    %al,-0x4(%ebp)
  for(; *s; s++)
 33b:	eb 14                	jmp    351 <strchr+0x22>
    if(*s == c)
 33d:	8b 45 08             	mov    0x8(%ebp),%eax
 340:	0f b6 00             	movzbl (%eax),%eax
 343:	38 45 fc             	cmp    %al,-0x4(%ebp)
 346:	75 05                	jne    34d <strchr+0x1e>
      return (char*)s;
 348:	8b 45 08             	mov    0x8(%ebp),%eax
 34b:	eb 13                	jmp    360 <strchr+0x31>
  for(; *s; s++)
 34d:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 351:	8b 45 08             	mov    0x8(%ebp),%eax
 354:	0f b6 00             	movzbl (%eax),%eax
 357:	84 c0                	test   %al,%al
 359:	75 e2                	jne    33d <strchr+0xe>
  return 0;
 35b:	b8 00 00 00 00       	mov    $0x0,%eax
}
 360:	c9                   	leave  
 361:	c3                   	ret    

00000362 <gets>:

char*
gets(char *buf, int max)
{
 362:	55                   	push   %ebp
 363:	89 e5                	mov    %esp,%ebp
 365:	83 ec 18             	sub    $0x18,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 368:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
 36f:	eb 42                	jmp    3b3 <gets+0x51>
    cc = read(0, &c, 1);
 371:	83 ec 04             	sub    $0x4,%esp
 374:	6a 01                	push   $0x1
 376:	8d 45 ef             	lea    -0x11(%ebp),%eax
 379:	50                   	push   %eax
 37a:	6a 00                	push   $0x0
 37c:	e8 47 01 00 00       	call   4c8 <read>
 381:	83 c4 10             	add    $0x10,%esp
 384:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(cc < 1)
 387:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 38b:	7e 33                	jle    3c0 <gets+0x5e>
      break;
    buf[i++] = c;
 38d:	8b 45 f4             	mov    -0xc(%ebp),%eax
 390:	8d 50 01             	lea    0x1(%eax),%edx
 393:	89 55 f4             	mov    %edx,-0xc(%ebp)
 396:	89 c2                	mov    %eax,%edx
 398:	8b 45 08             	mov    0x8(%ebp),%eax
 39b:	01 c2                	add    %eax,%edx
 39d:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 3a1:	88 02                	mov    %al,(%edx)
    if(c == '\n' || c == '\r')
 3a3:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 3a7:	3c 0a                	cmp    $0xa,%al
 3a9:	74 16                	je     3c1 <gets+0x5f>
 3ab:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 3af:	3c 0d                	cmp    $0xd,%al
 3b1:	74 0e                	je     3c1 <gets+0x5f>
  for(i=0; i+1 < max; ){
 3b3:	8b 45 f4             	mov    -0xc(%ebp),%eax
 3b6:	83 c0 01             	add    $0x1,%eax
 3b9:	39 45 0c             	cmp    %eax,0xc(%ebp)
 3bc:	7f b3                	jg     371 <gets+0xf>
 3be:	eb 01                	jmp    3c1 <gets+0x5f>
      break;
 3c0:	90                   	nop
      break;
  }
  buf[i] = '\0';
 3c1:	8b 55 f4             	mov    -0xc(%ebp),%edx
 3c4:	8b 45 08             	mov    0x8(%ebp),%eax
 3c7:	01 d0                	add    %edx,%eax
 3c9:	c6 00 00             	movb   $0x0,(%eax)
  return buf;
 3cc:	8b 45 08             	mov    0x8(%ebp),%eax
}
 3cf:	c9                   	leave  
 3d0:	c3                   	ret    

000003d1 <stat>:

int
stat(char *n, struct stat *st)
{
 3d1:	55                   	push   %ebp
 3d2:	89 e5                	mov    %esp,%ebp
 3d4:	83 ec 18             	sub    $0x18,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 3d7:	83 ec 08             	sub    $0x8,%esp
 3da:	6a 00                	push   $0x0
 3dc:	ff 75 08             	push   0x8(%ebp)
 3df:	e8 0c 01 00 00       	call   4f0 <open>
 3e4:	83 c4 10             	add    $0x10,%esp
 3e7:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0)
 3ea:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 3ee:	79 07                	jns    3f7 <stat+0x26>
    return -1;
 3f0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 3f5:	eb 25                	jmp    41c <stat+0x4b>
  r = fstat(fd, st);
 3f7:	83 ec 08             	sub    $0x8,%esp
 3fa:	ff 75 0c             	push   0xc(%ebp)
 3fd:	ff 75 f4             	push   -0xc(%ebp)
 400:	e8 03 01 00 00       	call   508 <fstat>
 405:	83 c4 10             	add    $0x10,%esp
 408:	89 45 f0             	mov    %eax,-0x10(%ebp)
  close(fd);
 40b:	83 ec 0c             	sub    $0xc,%esp
 40e:	ff 75 f4             	push   -0xc(%ebp)
 411:	e8 c2 00 00 00       	call   4d8 <close>
 416:	83 c4 10             	add    $0x10,%esp
  return r;
 419:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
 41c:	c9                   	leave  
 41d:	c3                   	ret    

0000041e <atoi>:

int
atoi(const char *s)
{
 41e:	55                   	push   %ebp
 41f:	89 e5                	mov    %esp,%ebp
 421:	83 ec 10             	sub    $0x10,%esp
  int n;

  n = 0;
 424:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while('0' <= *s && *s <= '9')
 42b:	eb 25                	jmp    452 <atoi+0x34>
    n = n*10 + *s++ - '0';
 42d:	8b 55 fc             	mov    -0x4(%ebp),%edx
 430:	89 d0                	mov    %edx,%eax
 432:	c1 e0 02             	shl    $0x2,%eax
 435:	01 d0                	add    %edx,%eax
 437:	01 c0                	add    %eax,%eax
 439:	89 c1                	mov    %eax,%ecx
 43b:	8b 45 08             	mov    0x8(%ebp),%eax
 43e:	8d 50 01             	lea    0x1(%eax),%edx
 441:	89 55 08             	mov    %edx,0x8(%ebp)
 444:	0f b6 00             	movzbl (%eax),%eax
 447:	0f be c0             	movsbl %al,%eax
 44a:	01 c8                	add    %ecx,%eax
 44c:	83 e8 30             	sub    $0x30,%eax
 44f:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while('0' <= *s && *s <= '9')
 452:	8b 45 08             	mov    0x8(%ebp),%eax
 455:	0f b6 00             	movzbl (%eax),%eax
 458:	3c 2f                	cmp    $0x2f,%al
 45a:	7e 0a                	jle    466 <atoi+0x48>
 45c:	8b 45 08             	mov    0x8(%ebp),%eax
 45f:	0f b6 00             	movzbl (%eax),%eax
 462:	3c 39                	cmp    $0x39,%al
 464:	7e c7                	jle    42d <atoi+0xf>
  return n;
 466:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 469:	c9                   	leave  
 46a:	c3                   	ret    

0000046b <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
 46b:	55                   	push   %ebp
 46c:	89 e5                	mov    %esp,%ebp
 46e:	83 ec 10             	sub    $0x10,%esp
  char *dst, *src;

  dst = vdst;
 471:	8b 45 08             	mov    0x8(%ebp),%eax
 474:	89 45 fc             	mov    %eax,-0x4(%ebp)
  src = vsrc;
 477:	8b 45 0c             	mov    0xc(%ebp),%eax
 47a:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0)
 47d:	eb 17                	jmp    496 <memmove+0x2b>
    *dst++ = *src++;
 47f:	8b 55 f8             	mov    -0x8(%ebp),%edx
 482:	8d 42 01             	lea    0x1(%edx),%eax
 485:	89 45 f8             	mov    %eax,-0x8(%ebp)
 488:	8b 45 fc             	mov    -0x4(%ebp),%eax
 48b:	8d 48 01             	lea    0x1(%eax),%ecx
 48e:	89 4d fc             	mov    %ecx,-0x4(%ebp)
 491:	0f b6 12             	movzbl (%edx),%edx
 494:	88 10                	mov    %dl,(%eax)
  while(n-- > 0)
 496:	8b 45 10             	mov    0x10(%ebp),%eax
 499:	8d 50 ff             	lea    -0x1(%eax),%edx
 49c:	89 55 10             	mov    %edx,0x10(%ebp)
 49f:	85 c0                	test   %eax,%eax
 4a1:	7f dc                	jg     47f <memmove+0x14>
  return vdst;
 4a3:	8b 45 08             	mov    0x8(%ebp),%eax
}
 4a6:	c9                   	leave  
 4a7:	c3                   	ret    

000004a8 <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 4a8:	b8 01 00 00 00       	mov    $0x1,%eax
 4ad:	cd 40                	int    $0x40
 4af:	c3                   	ret    

000004b0 <exit>:
SYSCALL(exit)
 4b0:	b8 02 00 00 00       	mov    $0x2,%eax
 4b5:	cd 40                	int    $0x40
 4b7:	c3                   	ret    

000004b8 <wait>:
SYSCALL(wait)
 4b8:	b8 03 00 00 00       	mov    $0x3,%eax
 4bd:	cd 40                	int    $0x40
 4bf:	c3                   	ret    

000004c0 <pipe>:
SYSCALL(pipe)
 4c0:	b8 04 00 00 00       	mov    $0x4,%eax
 4c5:	cd 40                	int    $0x40
 4c7:	c3                   	ret    

000004c8 <read>:
SYSCALL(read)
 4c8:	b8 05 00 00 00       	mov    $0x5,%eax
 4cd:	cd 40                	int    $0x40
 4cf:	c3                   	ret    

000004d0 <write>:
SYSCALL(write)
 4d0:	b8 10 00 00 00       	mov    $0x10,%eax
 4d5:	cd 40                	int    $0x40
 4d7:	c3                   	ret    

000004d8 <close>:
SYSCALL(close)
 4d8:	b8 15 00 00 00       	mov    $0x15,%eax
 4dd:	cd 40                	int    $0x40
 4df:	c3                   	ret    

000004e0 <kill>:
SYSCALL(kill)
 4e0:	b8 06 00 00 00       	mov    $0x6,%eax
 4e5:	cd 40                	int    $0x40
 4e7:	c3                   	ret    

000004e8 <exec>:
SYSCALL(exec)
 4e8:	b8 07 00 00 00       	mov    $0x7,%eax
 4ed:	cd 40                	int    $0x40
 4ef:	c3                   	ret    

000004f0 <open>:
SYSCALL(open)
 4f0:	b8 0f 00 00 00       	mov    $0xf,%eax
 4f5:	cd 40                	int    $0x40
 4f7:	c3                   	ret    

000004f8 <mknod>:
SYSCALL(mknod)
 4f8:	b8 11 00 00 00       	mov    $0x11,%eax
 4fd:	cd 40                	int    $0x40
 4ff:	c3                   	ret    

00000500 <unlink>:
SYSCALL(unlink)
 500:	b8 12 00 00 00       	mov    $0x12,%eax
 505:	cd 40                	int    $0x40
 507:	c3                   	ret    

00000508 <fstat>:
SYSCALL(fstat)
 508:	b8 08 00 00 00       	mov    $0x8,%eax
 50d:	cd 40                	int    $0x40
 50f:	c3                   	ret    

00000510 <link>:
SYSCALL(link)
 510:	b8 13 00 00 00       	mov    $0x13,%eax
 515:	cd 40                	int    $0x40
 517:	c3                   	ret    

00000518 <mkdir>:
SYSCALL(mkdir)
 518:	b8 14 00 00 00       	mov    $0x14,%eax
 51d:	cd 40                	int    $0x40
 51f:	c3                   	ret    

00000520 <chdir>:
SYSCALL(chdir)
 520:	b8 09 00 00 00       	mov    $0x9,%eax
 525:	cd 40                	int    $0x40
 527:	c3                   	ret    

00000528 <dup>:
SYSCALL(dup)
 528:	b8 0a 00 00 00       	mov    $0xa,%eax
 52d:	cd 40                	int    $0x40
 52f:	c3                   	ret    

00000530 <getpid>:
SYSCALL(getpid)
 530:	b8 0b 00 00 00       	mov    $0xb,%eax
 535:	cd 40                	int    $0x40
 537:	c3                   	ret    

00000538 <sbrk>:
SYSCALL(sbrk)
 538:	b8 0c 00 00 00       	mov    $0xc,%eax
 53d:	cd 40                	int    $0x40
 53f:	c3                   	ret    

00000540 <sleep>:
SYSCALL(sleep)
 540:	b8 0d 00 00 00       	mov    $0xd,%eax
 545:	cd 40                	int    $0x40
 547:	c3                   	ret    

00000548 <uptime>:
SYSCALL(uptime)
 548:	b8 0e 00 00 00       	mov    $0xe,%eax
 54d:	cd 40                	int    $0x40
 54f:	c3                   	ret    

00000550 <exit2>:
SYSCALL(exit2)
 550:	b8 16 00 00 00       	mov    $0x16,%eax
 555:	cd 40                	int    $0x40
 557:	c3                   	ret    

00000558 <wait2>:
SYSCALL(wait2)
 558:	b8 17 00 00 00       	mov    $0x17,%eax
 55d:	cd 40                	int    $0x40
 55f:	c3                   	ret    

00000560 <uthread_init>:
SYSCALL(uthread_init)
 560:	b8 18 00 00 00       	mov    $0x18,%eax
 565:	cd 40                	int    $0x40
 567:	c3                   	ret    

00000568 <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 568:	55                   	push   %ebp
 569:	89 e5                	mov    %esp,%ebp
 56b:	83 ec 18             	sub    $0x18,%esp
 56e:	8b 45 0c             	mov    0xc(%ebp),%eax
 571:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
 574:	83 ec 04             	sub    $0x4,%esp
 577:	6a 01                	push   $0x1
 579:	8d 45 f4             	lea    -0xc(%ebp),%eax
 57c:	50                   	push   %eax
 57d:	ff 75 08             	push   0x8(%ebp)
 580:	e8 4b ff ff ff       	call   4d0 <write>
 585:	83 c4 10             	add    $0x10,%esp
}
 588:	90                   	nop
 589:	c9                   	leave  
 58a:	c3                   	ret    

0000058b <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 58b:	55                   	push   %ebp
 58c:	89 e5                	mov    %esp,%ebp
 58e:	83 ec 28             	sub    $0x28,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
 591:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
 598:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
 59c:	74 17                	je     5b5 <printint+0x2a>
 59e:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
 5a2:	79 11                	jns    5b5 <printint+0x2a>
    neg = 1;
 5a4:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
 5ab:	8b 45 0c             	mov    0xc(%ebp),%eax
 5ae:	f7 d8                	neg    %eax
 5b0:	89 45 ec             	mov    %eax,-0x14(%ebp)
 5b3:	eb 06                	jmp    5bb <printint+0x30>
  } else {
    x = xx;
 5b5:	8b 45 0c             	mov    0xc(%ebp),%eax
 5b8:	89 45 ec             	mov    %eax,-0x14(%ebp)
  }

  i = 0;
 5bb:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
 5c2:	8b 4d 10             	mov    0x10(%ebp),%ecx
 5c5:	8b 45 ec             	mov    -0x14(%ebp),%eax
 5c8:	ba 00 00 00 00       	mov    $0x0,%edx
 5cd:	f7 f1                	div    %ecx
 5cf:	89 d1                	mov    %edx,%ecx
 5d1:	8b 45 f4             	mov    -0xc(%ebp),%eax
 5d4:	8d 50 01             	lea    0x1(%eax),%edx
 5d7:	89 55 f4             	mov    %edx,-0xc(%ebp)
 5da:	0f b6 91 44 0d 00 00 	movzbl 0xd44(%ecx),%edx
 5e1:	88 54 05 dc          	mov    %dl,-0x24(%ebp,%eax,1)
  }while((x /= base) != 0);
 5e5:	8b 4d 10             	mov    0x10(%ebp),%ecx
 5e8:	8b 45 ec             	mov    -0x14(%ebp),%eax
 5eb:	ba 00 00 00 00       	mov    $0x0,%edx
 5f0:	f7 f1                	div    %ecx
 5f2:	89 45 ec             	mov    %eax,-0x14(%ebp)
 5f5:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 5f9:	75 c7                	jne    5c2 <printint+0x37>
  if(neg)
 5fb:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 5ff:	74 2d                	je     62e <printint+0xa3>
    buf[i++] = '-';
 601:	8b 45 f4             	mov    -0xc(%ebp),%eax
 604:	8d 50 01             	lea    0x1(%eax),%edx
 607:	89 55 f4             	mov    %edx,-0xc(%ebp)
 60a:	c6 44 05 dc 2d       	movb   $0x2d,-0x24(%ebp,%eax,1)

  while(--i >= 0)
 60f:	eb 1d                	jmp    62e <printint+0xa3>
    putc(fd, buf[i]);
 611:	8d 55 dc             	lea    -0x24(%ebp),%edx
 614:	8b 45 f4             	mov    -0xc(%ebp),%eax
 617:	01 d0                	add    %edx,%eax
 619:	0f b6 00             	movzbl (%eax),%eax
 61c:	0f be c0             	movsbl %al,%eax
 61f:	83 ec 08             	sub    $0x8,%esp
 622:	50                   	push   %eax
 623:	ff 75 08             	push   0x8(%ebp)
 626:	e8 3d ff ff ff       	call   568 <putc>
 62b:	83 c4 10             	add    $0x10,%esp
  while(--i >= 0)
 62e:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
 632:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 636:	79 d9                	jns    611 <printint+0x86>
}
 638:	90                   	nop
 639:	90                   	nop
 63a:	c9                   	leave  
 63b:	c3                   	ret    

0000063c <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 63c:	55                   	push   %ebp
 63d:	89 e5                	mov    %esp,%ebp
 63f:	83 ec 28             	sub    $0x28,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
 642:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  ap = (uint*)(void*)&fmt + 1;
 649:	8d 45 0c             	lea    0xc(%ebp),%eax
 64c:	83 c0 04             	add    $0x4,%eax
 64f:	89 45 e8             	mov    %eax,-0x18(%ebp)
  for(i = 0; fmt[i]; i++){
 652:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
 659:	e9 59 01 00 00       	jmp    7b7 <printf+0x17b>
    c = fmt[i] & 0xff;
 65e:	8b 55 0c             	mov    0xc(%ebp),%edx
 661:	8b 45 f0             	mov    -0x10(%ebp),%eax
 664:	01 d0                	add    %edx,%eax
 666:	0f b6 00             	movzbl (%eax),%eax
 669:	0f be c0             	movsbl %al,%eax
 66c:	25 ff 00 00 00       	and    $0xff,%eax
 671:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(state == 0){
 674:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 678:	75 2c                	jne    6a6 <printf+0x6a>
      if(c == '%'){
 67a:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 67e:	75 0c                	jne    68c <printf+0x50>
        state = '%';
 680:	c7 45 ec 25 00 00 00 	movl   $0x25,-0x14(%ebp)
 687:	e9 27 01 00 00       	jmp    7b3 <printf+0x177>
      } else {
        putc(fd, c);
 68c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 68f:	0f be c0             	movsbl %al,%eax
 692:	83 ec 08             	sub    $0x8,%esp
 695:	50                   	push   %eax
 696:	ff 75 08             	push   0x8(%ebp)
 699:	e8 ca fe ff ff       	call   568 <putc>
 69e:	83 c4 10             	add    $0x10,%esp
 6a1:	e9 0d 01 00 00       	jmp    7b3 <printf+0x177>
      }
    } else if(state == '%'){
 6a6:	83 7d ec 25          	cmpl   $0x25,-0x14(%ebp)
 6aa:	0f 85 03 01 00 00    	jne    7b3 <printf+0x177>
      if(c == 'd'){
 6b0:	83 7d e4 64          	cmpl   $0x64,-0x1c(%ebp)
 6b4:	75 1e                	jne    6d4 <printf+0x98>
        printint(fd, *ap, 10, 1);
 6b6:	8b 45 e8             	mov    -0x18(%ebp),%eax
 6b9:	8b 00                	mov    (%eax),%eax
 6bb:	6a 01                	push   $0x1
 6bd:	6a 0a                	push   $0xa
 6bf:	50                   	push   %eax
 6c0:	ff 75 08             	push   0x8(%ebp)
 6c3:	e8 c3 fe ff ff       	call   58b <printint>
 6c8:	83 c4 10             	add    $0x10,%esp
        ap++;
 6cb:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 6cf:	e9 d8 00 00 00       	jmp    7ac <printf+0x170>
      } else if(c == 'x' || c == 'p'){
 6d4:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
 6d8:	74 06                	je     6e0 <printf+0xa4>
 6da:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
 6de:	75 1e                	jne    6fe <printf+0xc2>
        printint(fd, *ap, 16, 0);
 6e0:	8b 45 e8             	mov    -0x18(%ebp),%eax
 6e3:	8b 00                	mov    (%eax),%eax
 6e5:	6a 00                	push   $0x0
 6e7:	6a 10                	push   $0x10
 6e9:	50                   	push   %eax
 6ea:	ff 75 08             	push   0x8(%ebp)
 6ed:	e8 99 fe ff ff       	call   58b <printint>
 6f2:	83 c4 10             	add    $0x10,%esp
        ap++;
 6f5:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 6f9:	e9 ae 00 00 00       	jmp    7ac <printf+0x170>
      } else if(c == 's'){
 6fe:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
 702:	75 43                	jne    747 <printf+0x10b>
        s = (char*)*ap;
 704:	8b 45 e8             	mov    -0x18(%ebp),%eax
 707:	8b 00                	mov    (%eax),%eax
 709:	89 45 f4             	mov    %eax,-0xc(%ebp)
        ap++;
 70c:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
        if(s == 0)
 710:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 714:	75 25                	jne    73b <printf+0xff>
          s = "(null)";
 716:	c7 45 f4 4e 0a 00 00 	movl   $0xa4e,-0xc(%ebp)
        while(*s != 0){
 71d:	eb 1c                	jmp    73b <printf+0xff>
          putc(fd, *s);
 71f:	8b 45 f4             	mov    -0xc(%ebp),%eax
 722:	0f b6 00             	movzbl (%eax),%eax
 725:	0f be c0             	movsbl %al,%eax
 728:	83 ec 08             	sub    $0x8,%esp
 72b:	50                   	push   %eax
 72c:	ff 75 08             	push   0x8(%ebp)
 72f:	e8 34 fe ff ff       	call   568 <putc>
 734:	83 c4 10             	add    $0x10,%esp
          s++;
 737:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
        while(*s != 0){
 73b:	8b 45 f4             	mov    -0xc(%ebp),%eax
 73e:	0f b6 00             	movzbl (%eax),%eax
 741:	84 c0                	test   %al,%al
 743:	75 da                	jne    71f <printf+0xe3>
 745:	eb 65                	jmp    7ac <printf+0x170>
        }
      } else if(c == 'c'){
 747:	83 7d e4 63          	cmpl   $0x63,-0x1c(%ebp)
 74b:	75 1d                	jne    76a <printf+0x12e>
        putc(fd, *ap);
 74d:	8b 45 e8             	mov    -0x18(%ebp),%eax
 750:	8b 00                	mov    (%eax),%eax
 752:	0f be c0             	movsbl %al,%eax
 755:	83 ec 08             	sub    $0x8,%esp
 758:	50                   	push   %eax
 759:	ff 75 08             	push   0x8(%ebp)
 75c:	e8 07 fe ff ff       	call   568 <putc>
 761:	83 c4 10             	add    $0x10,%esp
        ap++;
 764:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 768:	eb 42                	jmp    7ac <printf+0x170>
      } else if(c == '%'){
 76a:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 76e:	75 17                	jne    787 <printf+0x14b>
        putc(fd, c);
 770:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 773:	0f be c0             	movsbl %al,%eax
 776:	83 ec 08             	sub    $0x8,%esp
 779:	50                   	push   %eax
 77a:	ff 75 08             	push   0x8(%ebp)
 77d:	e8 e6 fd ff ff       	call   568 <putc>
 782:	83 c4 10             	add    $0x10,%esp
 785:	eb 25                	jmp    7ac <printf+0x170>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 787:	83 ec 08             	sub    $0x8,%esp
 78a:	6a 25                	push   $0x25
 78c:	ff 75 08             	push   0x8(%ebp)
 78f:	e8 d4 fd ff ff       	call   568 <putc>
 794:	83 c4 10             	add    $0x10,%esp
        putc(fd, c);
 797:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 79a:	0f be c0             	movsbl %al,%eax
 79d:	83 ec 08             	sub    $0x8,%esp
 7a0:	50                   	push   %eax
 7a1:	ff 75 08             	push   0x8(%ebp)
 7a4:	e8 bf fd ff ff       	call   568 <putc>
 7a9:	83 c4 10             	add    $0x10,%esp
      }
      state = 0;
 7ac:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  for(i = 0; fmt[i]; i++){
 7b3:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
 7b7:	8b 55 0c             	mov    0xc(%ebp),%edx
 7ba:	8b 45 f0             	mov    -0x10(%ebp),%eax
 7bd:	01 d0                	add    %edx,%eax
 7bf:	0f b6 00             	movzbl (%eax),%eax
 7c2:	84 c0                	test   %al,%al
 7c4:	0f 85 94 fe ff ff    	jne    65e <printf+0x22>
    }
  }
}
 7ca:	90                   	nop
 7cb:	90                   	nop
 7cc:	c9                   	leave  
 7cd:	c3                   	ret    

000007ce <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 7ce:	55                   	push   %ebp
 7cf:	89 e5                	mov    %esp,%ebp
 7d1:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
 7d4:	8b 45 08             	mov    0x8(%ebp),%eax
 7d7:	83 e8 08             	sub    $0x8,%eax
 7da:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 7dd:	a1 a8 8d 00 00       	mov    0x8da8,%eax
 7e2:	89 45 fc             	mov    %eax,-0x4(%ebp)
 7e5:	eb 24                	jmp    80b <free+0x3d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 7e7:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7ea:	8b 00                	mov    (%eax),%eax
 7ec:	39 45 fc             	cmp    %eax,-0x4(%ebp)
 7ef:	72 12                	jb     803 <free+0x35>
 7f1:	8b 45 f8             	mov    -0x8(%ebp),%eax
 7f4:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 7f7:	77 24                	ja     81d <free+0x4f>
 7f9:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7fc:	8b 00                	mov    (%eax),%eax
 7fe:	39 45 f8             	cmp    %eax,-0x8(%ebp)
 801:	72 1a                	jb     81d <free+0x4f>
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 803:	8b 45 fc             	mov    -0x4(%ebp),%eax
 806:	8b 00                	mov    (%eax),%eax
 808:	89 45 fc             	mov    %eax,-0x4(%ebp)
 80b:	8b 45 f8             	mov    -0x8(%ebp),%eax
 80e:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 811:	76 d4                	jbe    7e7 <free+0x19>
 813:	8b 45 fc             	mov    -0x4(%ebp),%eax
 816:	8b 00                	mov    (%eax),%eax
 818:	39 45 f8             	cmp    %eax,-0x8(%ebp)
 81b:	73 ca                	jae    7e7 <free+0x19>
      break;
  if(bp + bp->s.size == p->s.ptr){
 81d:	8b 45 f8             	mov    -0x8(%ebp),%eax
 820:	8b 40 04             	mov    0x4(%eax),%eax
 823:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 82a:	8b 45 f8             	mov    -0x8(%ebp),%eax
 82d:	01 c2                	add    %eax,%edx
 82f:	8b 45 fc             	mov    -0x4(%ebp),%eax
 832:	8b 00                	mov    (%eax),%eax
 834:	39 c2                	cmp    %eax,%edx
 836:	75 24                	jne    85c <free+0x8e>
    bp->s.size += p->s.ptr->s.size;
 838:	8b 45 f8             	mov    -0x8(%ebp),%eax
 83b:	8b 50 04             	mov    0x4(%eax),%edx
 83e:	8b 45 fc             	mov    -0x4(%ebp),%eax
 841:	8b 00                	mov    (%eax),%eax
 843:	8b 40 04             	mov    0x4(%eax),%eax
 846:	01 c2                	add    %eax,%edx
 848:	8b 45 f8             	mov    -0x8(%ebp),%eax
 84b:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
 84e:	8b 45 fc             	mov    -0x4(%ebp),%eax
 851:	8b 00                	mov    (%eax),%eax
 853:	8b 10                	mov    (%eax),%edx
 855:	8b 45 f8             	mov    -0x8(%ebp),%eax
 858:	89 10                	mov    %edx,(%eax)
 85a:	eb 0a                	jmp    866 <free+0x98>
  } else
    bp->s.ptr = p->s.ptr;
 85c:	8b 45 fc             	mov    -0x4(%ebp),%eax
 85f:	8b 10                	mov    (%eax),%edx
 861:	8b 45 f8             	mov    -0x8(%ebp),%eax
 864:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
 866:	8b 45 fc             	mov    -0x4(%ebp),%eax
 869:	8b 40 04             	mov    0x4(%eax),%eax
 86c:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 873:	8b 45 fc             	mov    -0x4(%ebp),%eax
 876:	01 d0                	add    %edx,%eax
 878:	39 45 f8             	cmp    %eax,-0x8(%ebp)
 87b:	75 20                	jne    89d <free+0xcf>
    p->s.size += bp->s.size;
 87d:	8b 45 fc             	mov    -0x4(%ebp),%eax
 880:	8b 50 04             	mov    0x4(%eax),%edx
 883:	8b 45 f8             	mov    -0x8(%ebp),%eax
 886:	8b 40 04             	mov    0x4(%eax),%eax
 889:	01 c2                	add    %eax,%edx
 88b:	8b 45 fc             	mov    -0x4(%ebp),%eax
 88e:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 891:	8b 45 f8             	mov    -0x8(%ebp),%eax
 894:	8b 10                	mov    (%eax),%edx
 896:	8b 45 fc             	mov    -0x4(%ebp),%eax
 899:	89 10                	mov    %edx,(%eax)
 89b:	eb 08                	jmp    8a5 <free+0xd7>
  } else
    p->s.ptr = bp;
 89d:	8b 45 fc             	mov    -0x4(%ebp),%eax
 8a0:	8b 55 f8             	mov    -0x8(%ebp),%edx
 8a3:	89 10                	mov    %edx,(%eax)
  freep = p;
 8a5:	8b 45 fc             	mov    -0x4(%ebp),%eax
 8a8:	a3 a8 8d 00 00       	mov    %eax,0x8da8
}
 8ad:	90                   	nop
 8ae:	c9                   	leave  
 8af:	c3                   	ret    

000008b0 <morecore>:

static Header*
morecore(uint nu)
{
 8b0:	55                   	push   %ebp
 8b1:	89 e5                	mov    %esp,%ebp
 8b3:	83 ec 18             	sub    $0x18,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
 8b6:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
 8bd:	77 07                	ja     8c6 <morecore+0x16>
    nu = 4096;
 8bf:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
 8c6:	8b 45 08             	mov    0x8(%ebp),%eax
 8c9:	c1 e0 03             	shl    $0x3,%eax
 8cc:	83 ec 0c             	sub    $0xc,%esp
 8cf:	50                   	push   %eax
 8d0:	e8 63 fc ff ff       	call   538 <sbrk>
 8d5:	83 c4 10             	add    $0x10,%esp
 8d8:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(p == (char*)-1)
 8db:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
 8df:	75 07                	jne    8e8 <morecore+0x38>
    return 0;
 8e1:	b8 00 00 00 00       	mov    $0x0,%eax
 8e6:	eb 26                	jmp    90e <morecore+0x5e>
  hp = (Header*)p;
 8e8:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8eb:	89 45 f0             	mov    %eax,-0x10(%ebp)
  hp->s.size = nu;
 8ee:	8b 45 f0             	mov    -0x10(%ebp),%eax
 8f1:	8b 55 08             	mov    0x8(%ebp),%edx
 8f4:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
 8f7:	8b 45 f0             	mov    -0x10(%ebp),%eax
 8fa:	83 c0 08             	add    $0x8,%eax
 8fd:	83 ec 0c             	sub    $0xc,%esp
 900:	50                   	push   %eax
 901:	e8 c8 fe ff ff       	call   7ce <free>
 906:	83 c4 10             	add    $0x10,%esp
  return freep;
 909:	a1 a8 8d 00 00       	mov    0x8da8,%eax
}
 90e:	c9                   	leave  
 90f:	c3                   	ret    

00000910 <malloc>:

void*
malloc(uint nbytes)
{
 910:	55                   	push   %ebp
 911:	89 e5                	mov    %esp,%ebp
 913:	83 ec 18             	sub    $0x18,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 916:	8b 45 08             	mov    0x8(%ebp),%eax
 919:	83 c0 07             	add    $0x7,%eax
 91c:	c1 e8 03             	shr    $0x3,%eax
 91f:	83 c0 01             	add    $0x1,%eax
 922:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((prevp = freep) == 0){
 925:	a1 a8 8d 00 00       	mov    0x8da8,%eax
 92a:	89 45 f0             	mov    %eax,-0x10(%ebp)
 92d:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 931:	75 23                	jne    956 <malloc+0x46>
    base.s.ptr = freep = prevp = &base;
 933:	c7 45 f0 a0 8d 00 00 	movl   $0x8da0,-0x10(%ebp)
 93a:	8b 45 f0             	mov    -0x10(%ebp),%eax
 93d:	a3 a8 8d 00 00       	mov    %eax,0x8da8
 942:	a1 a8 8d 00 00       	mov    0x8da8,%eax
 947:	a3 a0 8d 00 00       	mov    %eax,0x8da0
    base.s.size = 0;
 94c:	c7 05 a4 8d 00 00 00 	movl   $0x0,0x8da4
 953:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 956:	8b 45 f0             	mov    -0x10(%ebp),%eax
 959:	8b 00                	mov    (%eax),%eax
 95b:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
 95e:	8b 45 f4             	mov    -0xc(%ebp),%eax
 961:	8b 40 04             	mov    0x4(%eax),%eax
 964:	39 45 ec             	cmp    %eax,-0x14(%ebp)
 967:	77 4d                	ja     9b6 <malloc+0xa6>
      if(p->s.size == nunits)
 969:	8b 45 f4             	mov    -0xc(%ebp),%eax
 96c:	8b 40 04             	mov    0x4(%eax),%eax
 96f:	39 45 ec             	cmp    %eax,-0x14(%ebp)
 972:	75 0c                	jne    980 <malloc+0x70>
        prevp->s.ptr = p->s.ptr;
 974:	8b 45 f4             	mov    -0xc(%ebp),%eax
 977:	8b 10                	mov    (%eax),%edx
 979:	8b 45 f0             	mov    -0x10(%ebp),%eax
 97c:	89 10                	mov    %edx,(%eax)
 97e:	eb 26                	jmp    9a6 <malloc+0x96>
      else {
        p->s.size -= nunits;
 980:	8b 45 f4             	mov    -0xc(%ebp),%eax
 983:	8b 40 04             	mov    0x4(%eax),%eax
 986:	2b 45 ec             	sub    -0x14(%ebp),%eax
 989:	89 c2                	mov    %eax,%edx
 98b:	8b 45 f4             	mov    -0xc(%ebp),%eax
 98e:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
 991:	8b 45 f4             	mov    -0xc(%ebp),%eax
 994:	8b 40 04             	mov    0x4(%eax),%eax
 997:	c1 e0 03             	shl    $0x3,%eax
 99a:	01 45 f4             	add    %eax,-0xc(%ebp)
        p->s.size = nunits;
 99d:	8b 45 f4             	mov    -0xc(%ebp),%eax
 9a0:	8b 55 ec             	mov    -0x14(%ebp),%edx
 9a3:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
 9a6:	8b 45 f0             	mov    -0x10(%ebp),%eax
 9a9:	a3 a8 8d 00 00       	mov    %eax,0x8da8
      return (void*)(p + 1);
 9ae:	8b 45 f4             	mov    -0xc(%ebp),%eax
 9b1:	83 c0 08             	add    $0x8,%eax
 9b4:	eb 3b                	jmp    9f1 <malloc+0xe1>
    }
    if(p == freep)
 9b6:	a1 a8 8d 00 00       	mov    0x8da8,%eax
 9bb:	39 45 f4             	cmp    %eax,-0xc(%ebp)
 9be:	75 1e                	jne    9de <malloc+0xce>
      if((p = morecore(nunits)) == 0)
 9c0:	83 ec 0c             	sub    $0xc,%esp
 9c3:	ff 75 ec             	push   -0x14(%ebp)
 9c6:	e8 e5 fe ff ff       	call   8b0 <morecore>
 9cb:	83 c4 10             	add    $0x10,%esp
 9ce:	89 45 f4             	mov    %eax,-0xc(%ebp)
 9d1:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 9d5:	75 07                	jne    9de <malloc+0xce>
        return 0;
 9d7:	b8 00 00 00 00       	mov    $0x0,%eax
 9dc:	eb 13                	jmp    9f1 <malloc+0xe1>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 9de:	8b 45 f4             	mov    -0xc(%ebp),%eax
 9e1:	89 45 f0             	mov    %eax,-0x10(%ebp)
 9e4:	8b 45 f4             	mov    -0xc(%ebp),%eax
 9e7:	8b 00                	mov    (%eax),%eax
 9e9:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
 9ec:	e9 6d ff ff ff       	jmp    95e <malloc+0x4e>
  }
}
 9f1:	c9                   	leave  
 9f2:	c3                   	ret    
