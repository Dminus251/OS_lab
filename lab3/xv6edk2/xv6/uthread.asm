
_uthread:     file format elf32-i386


Disassembly of section .text:

00000000 <thread_init>:
thread_p  next_thread;
extern void thread_switch(void);

void 
thread_init(void)
{
   0:	55                   	push   %ebp
   1:	89 e5                	mov    %esp,%ebp
  // main() is thread 0, which will make the first invocation to
  // thread_schedule().  it needs a stack so that the first thread_switch() can
  // save thread 0's state.  thread_schedule() won't run the main thread ever
  // again, because its state is set to RUNNING, and thread_schedule() selects
  // a RUNNABLE thread.
  current_thread = &all_thread[0];
   3:	c7 05 40 0d 00 00 60 	movl   $0xd60,0xd40
   a:	0d 00 00 
  current_thread->state = RUNNING;
   d:	a1 40 0d 00 00       	mov    0xd40,%eax
  12:	c7 80 04 20 00 00 01 	movl   $0x1,0x2004(%eax)
  19:	00 00 00 
}
  1c:	90                   	nop
  1d:	5d                   	pop    %ebp
  1e:	c3                   	ret    

0000001f <thread_schedule>:

static void 
thread_schedule(void)
{
  1f:	55                   	push   %ebp
  20:	89 e5                	mov    %esp,%ebp
  22:	83 ec 18             	sub    $0x18,%esp
  thread_p t;

  /* Find another runnable thread. */
  next_thread = 0;
  25:	c7 05 44 0d 00 00 00 	movl   $0x0,0xd44
  2c:	00 00 00 
  for (t = all_thread; t < all_thread + MAX_THREAD; t++) {
  2f:	c7 45 f4 60 0d 00 00 	movl   $0xd60,-0xc(%ebp)
  36:	eb 29                	jmp    61 <thread_schedule+0x42>
    if (t->state == RUNNABLE && t != current_thread) {
  38:	8b 45 f4             	mov    -0xc(%ebp),%eax
  3b:	8b 80 04 20 00 00    	mov    0x2004(%eax),%eax
  41:	83 f8 02             	cmp    $0x2,%eax
  44:	75 14                	jne    5a <thread_schedule+0x3b>
  46:	a1 40 0d 00 00       	mov    0xd40,%eax
  4b:	39 45 f4             	cmp    %eax,-0xc(%ebp)
  4e:	74 0a                	je     5a <thread_schedule+0x3b>
      next_thread = t;
  50:	8b 45 f4             	mov    -0xc(%ebp),%eax
  53:	a3 44 0d 00 00       	mov    %eax,0xd44
      break;
  58:	eb 11                	jmp    6b <thread_schedule+0x4c>
  for (t = all_thread; t < all_thread + MAX_THREAD; t++) {
  5a:	81 45 f4 08 20 00 00 	addl   $0x2008,-0xc(%ebp)
  61:	b8 80 8d 00 00       	mov    $0x8d80,%eax
  66:	39 45 f4             	cmp    %eax,-0xc(%ebp)
  69:	72 cd                	jb     38 <thread_schedule+0x19>
    }
  }

  if (t >= all_thread + MAX_THREAD && current_thread->state == RUNNABLE) {
  6b:	b8 80 8d 00 00       	mov    $0x8d80,%eax
  70:	39 45 f4             	cmp    %eax,-0xc(%ebp)
  73:	72 1a                	jb     8f <thread_schedule+0x70>
  75:	a1 40 0d 00 00       	mov    0xd40,%eax
  7a:	8b 80 04 20 00 00    	mov    0x2004(%eax),%eax
  80:	83 f8 02             	cmp    $0x2,%eax
  83:	75 0a                	jne    8f <thread_schedule+0x70>
    /* The current thread is the only runnable thread; run it. */
    next_thread = current_thread;
  85:	a1 40 0d 00 00       	mov    0xd40,%eax
  8a:	a3 44 0d 00 00       	mov    %eax,0xd44
  }

  if (next_thread == 0) {
  8f:	a1 44 0d 00 00       	mov    0xd44,%eax
  94:	85 c0                	test   %eax,%eax
  96:	75 17                	jne    af <thread_schedule+0x90>
    printf(2, "thread_schedule: no runnable threads\n");
  98:	83 ec 08             	sub    $0x8,%esp
  9b:	68 dc 09 00 00       	push   $0x9dc
  a0:	6a 02                	push   $0x2
  a2:	e8 7d 05 00 00       	call   624 <printf>
  a7:	83 c4 10             	add    $0x10,%esp
    exit();
  aa:	e8 f1 03 00 00       	call   4a0 <exit>
  }

  if (current_thread != next_thread) {         /* switch threads?  */
  af:	8b 15 40 0d 00 00    	mov    0xd40,%edx
  b5:	a1 44 0d 00 00       	mov    0xd44,%eax
  ba:	39 c2                	cmp    %eax,%edx
  bc:	74 16                	je     d4 <thread_schedule+0xb5>
    next_thread->state = RUNNING;
  be:	a1 44 0d 00 00       	mov    0xd44,%eax
  c3:	c7 80 04 20 00 00 01 	movl   $0x1,0x2004(%eax)
  ca:	00 00 00 
    thread_switch();
  cd:	e8 57 01 00 00       	call   229 <thread_switch>
  } else
    next_thread = 0;
}
  d2:	eb 0a                	jmp    de <thread_schedule+0xbf>
    next_thread = 0;
  d4:	c7 05 44 0d 00 00 00 	movl   $0x0,0xd44
  db:	00 00 00 
}
  de:	90                   	nop
  df:	c9                   	leave  
  e0:	c3                   	ret    

000000e1 <thread_create>:

void 
thread_create(void (*func)())
{
  e1:	55                   	push   %ebp
  e2:	89 e5                	mov    %esp,%ebp
  e4:	83 ec 10             	sub    $0x10,%esp
  thread_p t;

  for (t = all_thread; t < all_thread + MAX_THREAD; t++) {
  e7:	c7 45 fc 60 0d 00 00 	movl   $0xd60,-0x4(%ebp)
  ee:	eb 14                	jmp    104 <thread_create+0x23>
    if (t->state == FREE) break;
  f0:	8b 45 fc             	mov    -0x4(%ebp),%eax
  f3:	8b 80 04 20 00 00    	mov    0x2004(%eax),%eax
  f9:	85 c0                	test   %eax,%eax
  fb:	74 13                	je     110 <thread_create+0x2f>
  for (t = all_thread; t < all_thread + MAX_THREAD; t++) {
  fd:	81 45 fc 08 20 00 00 	addl   $0x2008,-0x4(%ebp)
 104:	b8 80 8d 00 00       	mov    $0x8d80,%eax
 109:	39 45 fc             	cmp    %eax,-0x4(%ebp)
 10c:	72 e2                	jb     f0 <thread_create+0xf>
 10e:	eb 01                	jmp    111 <thread_create+0x30>
    if (t->state == FREE) break;
 110:	90                   	nop
  }
  t->sp = (int) (t->stack + STACK_SIZE);   // set sp to the top of the stack
 111:	8b 45 fc             	mov    -0x4(%ebp),%eax
 114:	83 c0 04             	add    $0x4,%eax
 117:	05 00 20 00 00       	add    $0x2000,%eax
 11c:	89 c2                	mov    %eax,%edx
 11e:	8b 45 fc             	mov    -0x4(%ebp),%eax
 121:	89 10                	mov    %edx,(%eax)
  t->sp -= 4;                              // space for return address
 123:	8b 45 fc             	mov    -0x4(%ebp),%eax
 126:	8b 00                	mov    (%eax),%eax
 128:	8d 50 fc             	lea    -0x4(%eax),%edx
 12b:	8b 45 fc             	mov    -0x4(%ebp),%eax
 12e:	89 10                	mov    %edx,(%eax)
  * (int *) (t->sp) = (int)func;           // push return address on stack
 130:	8b 45 fc             	mov    -0x4(%ebp),%eax
 133:	8b 00                	mov    (%eax),%eax
 135:	89 c2                	mov    %eax,%edx
 137:	8b 45 08             	mov    0x8(%ebp),%eax
 13a:	89 02                	mov    %eax,(%edx)
  t->sp -= 32;                             // space for registers that thread_switch expects
 13c:	8b 45 fc             	mov    -0x4(%ebp),%eax
 13f:	8b 00                	mov    (%eax),%eax
 141:	8d 50 e0             	lea    -0x20(%eax),%edx
 144:	8b 45 fc             	mov    -0x4(%ebp),%eax
 147:	89 10                	mov    %edx,(%eax)
  t->state = RUNNABLE;
 149:	8b 45 fc             	mov    -0x4(%ebp),%eax
 14c:	c7 80 04 20 00 00 02 	movl   $0x2,0x2004(%eax)
 153:	00 00 00 
}
 156:	90                   	nop
 157:	c9                   	leave  
 158:	c3                   	ret    

00000159 <thread_yield>:

void 
thread_yield(void)
{
 159:	55                   	push   %ebp
 15a:	89 e5                	mov    %esp,%ebp
 15c:	83 ec 08             	sub    $0x8,%esp
  current_thread->state = RUNNABLE;
 15f:	a1 40 0d 00 00       	mov    0xd40,%eax
 164:	c7 80 04 20 00 00 02 	movl   $0x2,0x2004(%eax)
 16b:	00 00 00 
  thread_schedule();
 16e:	e8 ac fe ff ff       	call   1f <thread_schedule>
}
 173:	90                   	nop
 174:	c9                   	leave  
 175:	c3                   	ret    

00000176 <mythread>:

static void 
mythread(void)
{
 176:	55                   	push   %ebp
 177:	89 e5                	mov    %esp,%ebp
 179:	83 ec 18             	sub    $0x18,%esp
  int i;
  printf(1, "my thread running\n");
 17c:	83 ec 08             	sub    $0x8,%esp
 17f:	68 02 0a 00 00       	push   $0xa02
 184:	6a 01                	push   $0x1
 186:	e8 99 04 00 00       	call   624 <printf>
 18b:	83 c4 10             	add    $0x10,%esp
  for (i = 0; i < 100; i++) {
 18e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
 195:	eb 21                	jmp    1b8 <mythread+0x42>
    printf(1, "my thread 0x%x\n", (int) current_thread);
 197:	a1 40 0d 00 00       	mov    0xd40,%eax
 19c:	83 ec 04             	sub    $0x4,%esp
 19f:	50                   	push   %eax
 1a0:	68 15 0a 00 00       	push   $0xa15
 1a5:	6a 01                	push   $0x1
 1a7:	e8 78 04 00 00       	call   624 <printf>
 1ac:	83 c4 10             	add    $0x10,%esp
    thread_yield();
 1af:	e8 a5 ff ff ff       	call   159 <thread_yield>
  for (i = 0; i < 100; i++) {
 1b4:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
 1b8:	83 7d f4 63          	cmpl   $0x63,-0xc(%ebp)
 1bc:	7e d9                	jle    197 <mythread+0x21>
  }
  printf(1, "my thread: exit\n");
 1be:	83 ec 08             	sub    $0x8,%esp
 1c1:	68 25 0a 00 00       	push   $0xa25
 1c6:	6a 01                	push   $0x1
 1c8:	e8 57 04 00 00       	call   624 <printf>
 1cd:	83 c4 10             	add    $0x10,%esp
  current_thread->state = FREE;
 1d0:	a1 40 0d 00 00       	mov    0xd40,%eax
 1d5:	c7 80 04 20 00 00 00 	movl   $0x0,0x2004(%eax)
 1dc:	00 00 00 
  thread_schedule();
 1df:	e8 3b fe ff ff       	call   1f <thread_schedule>
}
 1e4:	90                   	nop
 1e5:	c9                   	leave  
 1e6:	c3                   	ret    

000001e7 <main>:


int 
main(int argc, char *argv[]) 
{
 1e7:	8d 4c 24 04          	lea    0x4(%esp),%ecx
 1eb:	83 e4 f0             	and    $0xfffffff0,%esp
 1ee:	ff 71 fc             	push   -0x4(%ecx)
 1f1:	55                   	push   %ebp
 1f2:	89 e5                	mov    %esp,%ebp
 1f4:	51                   	push   %ecx
 1f5:	83 ec 04             	sub    $0x4,%esp
  thread_init();
 1f8:	e8 03 fe ff ff       	call   0 <thread_init>
  thread_create(mythread);
 1fd:	68 76 01 00 00       	push   $0x176
 202:	e8 da fe ff ff       	call   e1 <thread_create>
 207:	83 c4 04             	add    $0x4,%esp
  thread_create(mythread);
 20a:	68 76 01 00 00       	push   $0x176
 20f:	e8 cd fe ff ff       	call   e1 <thread_create>
 214:	83 c4 04             	add    $0x4,%esp
  thread_schedule();
 217:	e8 03 fe ff ff       	call   1f <thread_schedule>
  return 0;
 21c:	b8 00 00 00 00       	mov    $0x0,%eax
}
 221:	8b 4d fc             	mov    -0x4(%ebp),%ecx
 224:	c9                   	leave  
 225:	8d 61 fc             	lea    -0x4(%ecx),%esp
 228:	c3                   	ret    

00000229 <thread_switch>:
 */
	.globl thread_switch
thread_switch:
	/* YOUR CODE HERE */
		
	pushal				//Store current thread 
 229:	60                   	pusha  
	
	movl current_thread, %eax	//Load addr of current thread
 22a:	a1 40 0d 00 00       	mov    0xd40,%eax
   	movl %esp, (%eax)		// save esp reg in sp of thread
 22f:	89 20                	mov    %esp,(%eax)
		
	movl next_thread, %eax		//load addr of nextthread
 231:	a1 44 0d 00 00       	mov    0xd44,%eax
	movl (%eax), %esp		//load sp of thread in esp reg
 236:	8b 20                	mov    (%eax),%esp

	movl %eax, current_thread	//next thread -> current thread
 238:	a3 40 0d 00 00       	mov    %eax,0xd40

	movl $0x0, next_thread		//next_thread = 0
 23d:	c7 05 44 0d 00 00 00 	movl   $0x0,0xd44
 244:	00 00 00 

	popal				//restore reg from stack
 247:	61                   	popa   

	ret				/* pop return address from stack */
 248:	c3                   	ret    

00000249 <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
 249:	55                   	push   %ebp
 24a:	89 e5                	mov    %esp,%ebp
 24c:	57                   	push   %edi
 24d:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
 24e:	8b 4d 08             	mov    0x8(%ebp),%ecx
 251:	8b 55 10             	mov    0x10(%ebp),%edx
 254:	8b 45 0c             	mov    0xc(%ebp),%eax
 257:	89 cb                	mov    %ecx,%ebx
 259:	89 df                	mov    %ebx,%edi
 25b:	89 d1                	mov    %edx,%ecx
 25d:	fc                   	cld    
 25e:	f3 aa                	rep stos %al,%es:(%edi)
 260:	89 ca                	mov    %ecx,%edx
 262:	89 fb                	mov    %edi,%ebx
 264:	89 5d 08             	mov    %ebx,0x8(%ebp)
 267:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
 26a:	90                   	nop
 26b:	5b                   	pop    %ebx
 26c:	5f                   	pop    %edi
 26d:	5d                   	pop    %ebp
 26e:	c3                   	ret    

0000026f <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
 26f:	55                   	push   %ebp
 270:	89 e5                	mov    %esp,%ebp
 272:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
 275:	8b 45 08             	mov    0x8(%ebp),%eax
 278:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while((*s++ = *t++) != 0)
 27b:	90                   	nop
 27c:	8b 55 0c             	mov    0xc(%ebp),%edx
 27f:	8d 42 01             	lea    0x1(%edx),%eax
 282:	89 45 0c             	mov    %eax,0xc(%ebp)
 285:	8b 45 08             	mov    0x8(%ebp),%eax
 288:	8d 48 01             	lea    0x1(%eax),%ecx
 28b:	89 4d 08             	mov    %ecx,0x8(%ebp)
 28e:	0f b6 12             	movzbl (%edx),%edx
 291:	88 10                	mov    %dl,(%eax)
 293:	0f b6 00             	movzbl (%eax),%eax
 296:	84 c0                	test   %al,%al
 298:	75 e2                	jne    27c <strcpy+0xd>
    ;
  return os;
 29a:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 29d:	c9                   	leave  
 29e:	c3                   	ret    

0000029f <strcmp>:

int
strcmp(const char *p, const char *q)
{
 29f:	55                   	push   %ebp
 2a0:	89 e5                	mov    %esp,%ebp
  while(*p && *p == *q)
 2a2:	eb 08                	jmp    2ac <strcmp+0xd>
    p++, q++;
 2a4:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 2a8:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
  while(*p && *p == *q)
 2ac:	8b 45 08             	mov    0x8(%ebp),%eax
 2af:	0f b6 00             	movzbl (%eax),%eax
 2b2:	84 c0                	test   %al,%al
 2b4:	74 10                	je     2c6 <strcmp+0x27>
 2b6:	8b 45 08             	mov    0x8(%ebp),%eax
 2b9:	0f b6 10             	movzbl (%eax),%edx
 2bc:	8b 45 0c             	mov    0xc(%ebp),%eax
 2bf:	0f b6 00             	movzbl (%eax),%eax
 2c2:	38 c2                	cmp    %al,%dl
 2c4:	74 de                	je     2a4 <strcmp+0x5>
  return (uchar)*p - (uchar)*q;
 2c6:	8b 45 08             	mov    0x8(%ebp),%eax
 2c9:	0f b6 00             	movzbl (%eax),%eax
 2cc:	0f b6 d0             	movzbl %al,%edx
 2cf:	8b 45 0c             	mov    0xc(%ebp),%eax
 2d2:	0f b6 00             	movzbl (%eax),%eax
 2d5:	0f b6 c8             	movzbl %al,%ecx
 2d8:	89 d0                	mov    %edx,%eax
 2da:	29 c8                	sub    %ecx,%eax
}
 2dc:	5d                   	pop    %ebp
 2dd:	c3                   	ret    

000002de <strlen>:

uint
strlen(char *s)
{
 2de:	55                   	push   %ebp
 2df:	89 e5                	mov    %esp,%ebp
 2e1:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
 2e4:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
 2eb:	eb 04                	jmp    2f1 <strlen+0x13>
 2ed:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 2f1:	8b 55 fc             	mov    -0x4(%ebp),%edx
 2f4:	8b 45 08             	mov    0x8(%ebp),%eax
 2f7:	01 d0                	add    %edx,%eax
 2f9:	0f b6 00             	movzbl (%eax),%eax
 2fc:	84 c0                	test   %al,%al
 2fe:	75 ed                	jne    2ed <strlen+0xf>
    ;
  return n;
 300:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 303:	c9                   	leave  
 304:	c3                   	ret    

00000305 <memset>:

void*
memset(void *dst, int c, uint n)
{
 305:	55                   	push   %ebp
 306:	89 e5                	mov    %esp,%ebp
  stosb(dst, c, n);
 308:	8b 45 10             	mov    0x10(%ebp),%eax
 30b:	50                   	push   %eax
 30c:	ff 75 0c             	push   0xc(%ebp)
 30f:	ff 75 08             	push   0x8(%ebp)
 312:	e8 32 ff ff ff       	call   249 <stosb>
 317:	83 c4 0c             	add    $0xc,%esp
  return dst;
 31a:	8b 45 08             	mov    0x8(%ebp),%eax
}
 31d:	c9                   	leave  
 31e:	c3                   	ret    

0000031f <strchr>:

char*
strchr(const char *s, char c)
{
 31f:	55                   	push   %ebp
 320:	89 e5                	mov    %esp,%ebp
 322:	83 ec 04             	sub    $0x4,%esp
 325:	8b 45 0c             	mov    0xc(%ebp),%eax
 328:	88 45 fc             	mov    %al,-0x4(%ebp)
  for(; *s; s++)
 32b:	eb 14                	jmp    341 <strchr+0x22>
    if(*s == c)
 32d:	8b 45 08             	mov    0x8(%ebp),%eax
 330:	0f b6 00             	movzbl (%eax),%eax
 333:	38 45 fc             	cmp    %al,-0x4(%ebp)
 336:	75 05                	jne    33d <strchr+0x1e>
      return (char*)s;
 338:	8b 45 08             	mov    0x8(%ebp),%eax
 33b:	eb 13                	jmp    350 <strchr+0x31>
  for(; *s; s++)
 33d:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 341:	8b 45 08             	mov    0x8(%ebp),%eax
 344:	0f b6 00             	movzbl (%eax),%eax
 347:	84 c0                	test   %al,%al
 349:	75 e2                	jne    32d <strchr+0xe>
  return 0;
 34b:	b8 00 00 00 00       	mov    $0x0,%eax
}
 350:	c9                   	leave  
 351:	c3                   	ret    

00000352 <gets>:

char*
gets(char *buf, int max)
{
 352:	55                   	push   %ebp
 353:	89 e5                	mov    %esp,%ebp
 355:	83 ec 18             	sub    $0x18,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 358:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
 35f:	eb 42                	jmp    3a3 <gets+0x51>
    cc = read(0, &c, 1);
 361:	83 ec 04             	sub    $0x4,%esp
 364:	6a 01                	push   $0x1
 366:	8d 45 ef             	lea    -0x11(%ebp),%eax
 369:	50                   	push   %eax
 36a:	6a 00                	push   $0x0
 36c:	e8 47 01 00 00       	call   4b8 <read>
 371:	83 c4 10             	add    $0x10,%esp
 374:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(cc < 1)
 377:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 37b:	7e 33                	jle    3b0 <gets+0x5e>
      break;
    buf[i++] = c;
 37d:	8b 45 f4             	mov    -0xc(%ebp),%eax
 380:	8d 50 01             	lea    0x1(%eax),%edx
 383:	89 55 f4             	mov    %edx,-0xc(%ebp)
 386:	89 c2                	mov    %eax,%edx
 388:	8b 45 08             	mov    0x8(%ebp),%eax
 38b:	01 c2                	add    %eax,%edx
 38d:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 391:	88 02                	mov    %al,(%edx)
    if(c == '\n' || c == '\r')
 393:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 397:	3c 0a                	cmp    $0xa,%al
 399:	74 16                	je     3b1 <gets+0x5f>
 39b:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 39f:	3c 0d                	cmp    $0xd,%al
 3a1:	74 0e                	je     3b1 <gets+0x5f>
  for(i=0; i+1 < max; ){
 3a3:	8b 45 f4             	mov    -0xc(%ebp),%eax
 3a6:	83 c0 01             	add    $0x1,%eax
 3a9:	39 45 0c             	cmp    %eax,0xc(%ebp)
 3ac:	7f b3                	jg     361 <gets+0xf>
 3ae:	eb 01                	jmp    3b1 <gets+0x5f>
      break;
 3b0:	90                   	nop
      break;
  }
  buf[i] = '\0';
 3b1:	8b 55 f4             	mov    -0xc(%ebp),%edx
 3b4:	8b 45 08             	mov    0x8(%ebp),%eax
 3b7:	01 d0                	add    %edx,%eax
 3b9:	c6 00 00             	movb   $0x0,(%eax)
  return buf;
 3bc:	8b 45 08             	mov    0x8(%ebp),%eax
}
 3bf:	c9                   	leave  
 3c0:	c3                   	ret    

000003c1 <stat>:

int
stat(char *n, struct stat *st)
{
 3c1:	55                   	push   %ebp
 3c2:	89 e5                	mov    %esp,%ebp
 3c4:	83 ec 18             	sub    $0x18,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 3c7:	83 ec 08             	sub    $0x8,%esp
 3ca:	6a 00                	push   $0x0
 3cc:	ff 75 08             	push   0x8(%ebp)
 3cf:	e8 0c 01 00 00       	call   4e0 <open>
 3d4:	83 c4 10             	add    $0x10,%esp
 3d7:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0)
 3da:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 3de:	79 07                	jns    3e7 <stat+0x26>
    return -1;
 3e0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 3e5:	eb 25                	jmp    40c <stat+0x4b>
  r = fstat(fd, st);
 3e7:	83 ec 08             	sub    $0x8,%esp
 3ea:	ff 75 0c             	push   0xc(%ebp)
 3ed:	ff 75 f4             	push   -0xc(%ebp)
 3f0:	e8 03 01 00 00       	call   4f8 <fstat>
 3f5:	83 c4 10             	add    $0x10,%esp
 3f8:	89 45 f0             	mov    %eax,-0x10(%ebp)
  close(fd);
 3fb:	83 ec 0c             	sub    $0xc,%esp
 3fe:	ff 75 f4             	push   -0xc(%ebp)
 401:	e8 c2 00 00 00       	call   4c8 <close>
 406:	83 c4 10             	add    $0x10,%esp
  return r;
 409:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
 40c:	c9                   	leave  
 40d:	c3                   	ret    

0000040e <atoi>:

int
atoi(const char *s)
{
 40e:	55                   	push   %ebp
 40f:	89 e5                	mov    %esp,%ebp
 411:	83 ec 10             	sub    $0x10,%esp
  int n;

  n = 0;
 414:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while('0' <= *s && *s <= '9')
 41b:	eb 25                	jmp    442 <atoi+0x34>
    n = n*10 + *s++ - '0';
 41d:	8b 55 fc             	mov    -0x4(%ebp),%edx
 420:	89 d0                	mov    %edx,%eax
 422:	c1 e0 02             	shl    $0x2,%eax
 425:	01 d0                	add    %edx,%eax
 427:	01 c0                	add    %eax,%eax
 429:	89 c1                	mov    %eax,%ecx
 42b:	8b 45 08             	mov    0x8(%ebp),%eax
 42e:	8d 50 01             	lea    0x1(%eax),%edx
 431:	89 55 08             	mov    %edx,0x8(%ebp)
 434:	0f b6 00             	movzbl (%eax),%eax
 437:	0f be c0             	movsbl %al,%eax
 43a:	01 c8                	add    %ecx,%eax
 43c:	83 e8 30             	sub    $0x30,%eax
 43f:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while('0' <= *s && *s <= '9')
 442:	8b 45 08             	mov    0x8(%ebp),%eax
 445:	0f b6 00             	movzbl (%eax),%eax
 448:	3c 2f                	cmp    $0x2f,%al
 44a:	7e 0a                	jle    456 <atoi+0x48>
 44c:	8b 45 08             	mov    0x8(%ebp),%eax
 44f:	0f b6 00             	movzbl (%eax),%eax
 452:	3c 39                	cmp    $0x39,%al
 454:	7e c7                	jle    41d <atoi+0xf>
  return n;
 456:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 459:	c9                   	leave  
 45a:	c3                   	ret    

0000045b <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
 45b:	55                   	push   %ebp
 45c:	89 e5                	mov    %esp,%ebp
 45e:	83 ec 10             	sub    $0x10,%esp
  char *dst, *src;

  dst = vdst;
 461:	8b 45 08             	mov    0x8(%ebp),%eax
 464:	89 45 fc             	mov    %eax,-0x4(%ebp)
  src = vsrc;
 467:	8b 45 0c             	mov    0xc(%ebp),%eax
 46a:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0)
 46d:	eb 17                	jmp    486 <memmove+0x2b>
    *dst++ = *src++;
 46f:	8b 55 f8             	mov    -0x8(%ebp),%edx
 472:	8d 42 01             	lea    0x1(%edx),%eax
 475:	89 45 f8             	mov    %eax,-0x8(%ebp)
 478:	8b 45 fc             	mov    -0x4(%ebp),%eax
 47b:	8d 48 01             	lea    0x1(%eax),%ecx
 47e:	89 4d fc             	mov    %ecx,-0x4(%ebp)
 481:	0f b6 12             	movzbl (%edx),%edx
 484:	88 10                	mov    %dl,(%eax)
  while(n-- > 0)
 486:	8b 45 10             	mov    0x10(%ebp),%eax
 489:	8d 50 ff             	lea    -0x1(%eax),%edx
 48c:	89 55 10             	mov    %edx,0x10(%ebp)
 48f:	85 c0                	test   %eax,%eax
 491:	7f dc                	jg     46f <memmove+0x14>
  return vdst;
 493:	8b 45 08             	mov    0x8(%ebp),%eax
}
 496:	c9                   	leave  
 497:	c3                   	ret    

00000498 <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 498:	b8 01 00 00 00       	mov    $0x1,%eax
 49d:	cd 40                	int    $0x40
 49f:	c3                   	ret    

000004a0 <exit>:
SYSCALL(exit)
 4a0:	b8 02 00 00 00       	mov    $0x2,%eax
 4a5:	cd 40                	int    $0x40
 4a7:	c3                   	ret    

000004a8 <wait>:
SYSCALL(wait)
 4a8:	b8 03 00 00 00       	mov    $0x3,%eax
 4ad:	cd 40                	int    $0x40
 4af:	c3                   	ret    

000004b0 <pipe>:
SYSCALL(pipe)
 4b0:	b8 04 00 00 00       	mov    $0x4,%eax
 4b5:	cd 40                	int    $0x40
 4b7:	c3                   	ret    

000004b8 <read>:
SYSCALL(read)
 4b8:	b8 05 00 00 00       	mov    $0x5,%eax
 4bd:	cd 40                	int    $0x40
 4bf:	c3                   	ret    

000004c0 <write>:
SYSCALL(write)
 4c0:	b8 10 00 00 00       	mov    $0x10,%eax
 4c5:	cd 40                	int    $0x40
 4c7:	c3                   	ret    

000004c8 <close>:
SYSCALL(close)
 4c8:	b8 15 00 00 00       	mov    $0x15,%eax
 4cd:	cd 40                	int    $0x40
 4cf:	c3                   	ret    

000004d0 <kill>:
SYSCALL(kill)
 4d0:	b8 06 00 00 00       	mov    $0x6,%eax
 4d5:	cd 40                	int    $0x40
 4d7:	c3                   	ret    

000004d8 <exec>:
SYSCALL(exec)
 4d8:	b8 07 00 00 00       	mov    $0x7,%eax
 4dd:	cd 40                	int    $0x40
 4df:	c3                   	ret    

000004e0 <open>:
SYSCALL(open)
 4e0:	b8 0f 00 00 00       	mov    $0xf,%eax
 4e5:	cd 40                	int    $0x40
 4e7:	c3                   	ret    

000004e8 <mknod>:
SYSCALL(mknod)
 4e8:	b8 11 00 00 00       	mov    $0x11,%eax
 4ed:	cd 40                	int    $0x40
 4ef:	c3                   	ret    

000004f0 <unlink>:
SYSCALL(unlink)
 4f0:	b8 12 00 00 00       	mov    $0x12,%eax
 4f5:	cd 40                	int    $0x40
 4f7:	c3                   	ret    

000004f8 <fstat>:
SYSCALL(fstat)
 4f8:	b8 08 00 00 00       	mov    $0x8,%eax
 4fd:	cd 40                	int    $0x40
 4ff:	c3                   	ret    

00000500 <link>:
SYSCALL(link)
 500:	b8 13 00 00 00       	mov    $0x13,%eax
 505:	cd 40                	int    $0x40
 507:	c3                   	ret    

00000508 <mkdir>:
SYSCALL(mkdir)
 508:	b8 14 00 00 00       	mov    $0x14,%eax
 50d:	cd 40                	int    $0x40
 50f:	c3                   	ret    

00000510 <chdir>:
SYSCALL(chdir)
 510:	b8 09 00 00 00       	mov    $0x9,%eax
 515:	cd 40                	int    $0x40
 517:	c3                   	ret    

00000518 <dup>:
SYSCALL(dup)
 518:	b8 0a 00 00 00       	mov    $0xa,%eax
 51d:	cd 40                	int    $0x40
 51f:	c3                   	ret    

00000520 <getpid>:
SYSCALL(getpid)
 520:	b8 0b 00 00 00       	mov    $0xb,%eax
 525:	cd 40                	int    $0x40
 527:	c3                   	ret    

00000528 <sbrk>:
SYSCALL(sbrk)
 528:	b8 0c 00 00 00       	mov    $0xc,%eax
 52d:	cd 40                	int    $0x40
 52f:	c3                   	ret    

00000530 <sleep>:
SYSCALL(sleep)
 530:	b8 0d 00 00 00       	mov    $0xd,%eax
 535:	cd 40                	int    $0x40
 537:	c3                   	ret    

00000538 <uptime>:
SYSCALL(uptime)
 538:	b8 0e 00 00 00       	mov    $0xe,%eax
 53d:	cd 40                	int    $0x40
 53f:	c3                   	ret    

00000540 <exit2>:
SYSCALL(exit2)
 540:	b8 16 00 00 00       	mov    $0x16,%eax
 545:	cd 40                	int    $0x40
 547:	c3                   	ret    

00000548 <wait2>:
SYSCALL(wait2)
 548:	b8 17 00 00 00       	mov    $0x17,%eax
 54d:	cd 40                	int    $0x40
 54f:	c3                   	ret    

00000550 <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 550:	55                   	push   %ebp
 551:	89 e5                	mov    %esp,%ebp
 553:	83 ec 18             	sub    $0x18,%esp
 556:	8b 45 0c             	mov    0xc(%ebp),%eax
 559:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
 55c:	83 ec 04             	sub    $0x4,%esp
 55f:	6a 01                	push   $0x1
 561:	8d 45 f4             	lea    -0xc(%ebp),%eax
 564:	50                   	push   %eax
 565:	ff 75 08             	push   0x8(%ebp)
 568:	e8 53 ff ff ff       	call   4c0 <write>
 56d:	83 c4 10             	add    $0x10,%esp
}
 570:	90                   	nop
 571:	c9                   	leave  
 572:	c3                   	ret    

00000573 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 573:	55                   	push   %ebp
 574:	89 e5                	mov    %esp,%ebp
 576:	83 ec 28             	sub    $0x28,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
 579:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
 580:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
 584:	74 17                	je     59d <printint+0x2a>
 586:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
 58a:	79 11                	jns    59d <printint+0x2a>
    neg = 1;
 58c:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
 593:	8b 45 0c             	mov    0xc(%ebp),%eax
 596:	f7 d8                	neg    %eax
 598:	89 45 ec             	mov    %eax,-0x14(%ebp)
 59b:	eb 06                	jmp    5a3 <printint+0x30>
  } else {
    x = xx;
 59d:	8b 45 0c             	mov    0xc(%ebp),%eax
 5a0:	89 45 ec             	mov    %eax,-0x14(%ebp)
  }

  i = 0;
 5a3:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
 5aa:	8b 4d 10             	mov    0x10(%ebp),%ecx
 5ad:	8b 45 ec             	mov    -0x14(%ebp),%eax
 5b0:	ba 00 00 00 00       	mov    $0x0,%edx
 5b5:	f7 f1                	div    %ecx
 5b7:	89 d1                	mov    %edx,%ecx
 5b9:	8b 45 f4             	mov    -0xc(%ebp),%eax
 5bc:	8d 50 01             	lea    0x1(%eax),%edx
 5bf:	89 55 f4             	mov    %edx,-0xc(%ebp)
 5c2:	0f b6 91 2c 0d 00 00 	movzbl 0xd2c(%ecx),%edx
 5c9:	88 54 05 dc          	mov    %dl,-0x24(%ebp,%eax,1)
  }while((x /= base) != 0);
 5cd:	8b 4d 10             	mov    0x10(%ebp),%ecx
 5d0:	8b 45 ec             	mov    -0x14(%ebp),%eax
 5d3:	ba 00 00 00 00       	mov    $0x0,%edx
 5d8:	f7 f1                	div    %ecx
 5da:	89 45 ec             	mov    %eax,-0x14(%ebp)
 5dd:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 5e1:	75 c7                	jne    5aa <printint+0x37>
  if(neg)
 5e3:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 5e7:	74 2d                	je     616 <printint+0xa3>
    buf[i++] = '-';
 5e9:	8b 45 f4             	mov    -0xc(%ebp),%eax
 5ec:	8d 50 01             	lea    0x1(%eax),%edx
 5ef:	89 55 f4             	mov    %edx,-0xc(%ebp)
 5f2:	c6 44 05 dc 2d       	movb   $0x2d,-0x24(%ebp,%eax,1)

  while(--i >= 0)
 5f7:	eb 1d                	jmp    616 <printint+0xa3>
    putc(fd, buf[i]);
 5f9:	8d 55 dc             	lea    -0x24(%ebp),%edx
 5fc:	8b 45 f4             	mov    -0xc(%ebp),%eax
 5ff:	01 d0                	add    %edx,%eax
 601:	0f b6 00             	movzbl (%eax),%eax
 604:	0f be c0             	movsbl %al,%eax
 607:	83 ec 08             	sub    $0x8,%esp
 60a:	50                   	push   %eax
 60b:	ff 75 08             	push   0x8(%ebp)
 60e:	e8 3d ff ff ff       	call   550 <putc>
 613:	83 c4 10             	add    $0x10,%esp
  while(--i >= 0)
 616:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
 61a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 61e:	79 d9                	jns    5f9 <printint+0x86>
}
 620:	90                   	nop
 621:	90                   	nop
 622:	c9                   	leave  
 623:	c3                   	ret    

00000624 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 624:	55                   	push   %ebp
 625:	89 e5                	mov    %esp,%ebp
 627:	83 ec 28             	sub    $0x28,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
 62a:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  ap = (uint*)(void*)&fmt + 1;
 631:	8d 45 0c             	lea    0xc(%ebp),%eax
 634:	83 c0 04             	add    $0x4,%eax
 637:	89 45 e8             	mov    %eax,-0x18(%ebp)
  for(i = 0; fmt[i]; i++){
 63a:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
 641:	e9 59 01 00 00       	jmp    79f <printf+0x17b>
    c = fmt[i] & 0xff;
 646:	8b 55 0c             	mov    0xc(%ebp),%edx
 649:	8b 45 f0             	mov    -0x10(%ebp),%eax
 64c:	01 d0                	add    %edx,%eax
 64e:	0f b6 00             	movzbl (%eax),%eax
 651:	0f be c0             	movsbl %al,%eax
 654:	25 ff 00 00 00       	and    $0xff,%eax
 659:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(state == 0){
 65c:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 660:	75 2c                	jne    68e <printf+0x6a>
      if(c == '%'){
 662:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 666:	75 0c                	jne    674 <printf+0x50>
        state = '%';
 668:	c7 45 ec 25 00 00 00 	movl   $0x25,-0x14(%ebp)
 66f:	e9 27 01 00 00       	jmp    79b <printf+0x177>
      } else {
        putc(fd, c);
 674:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 677:	0f be c0             	movsbl %al,%eax
 67a:	83 ec 08             	sub    $0x8,%esp
 67d:	50                   	push   %eax
 67e:	ff 75 08             	push   0x8(%ebp)
 681:	e8 ca fe ff ff       	call   550 <putc>
 686:	83 c4 10             	add    $0x10,%esp
 689:	e9 0d 01 00 00       	jmp    79b <printf+0x177>
      }
    } else if(state == '%'){
 68e:	83 7d ec 25          	cmpl   $0x25,-0x14(%ebp)
 692:	0f 85 03 01 00 00    	jne    79b <printf+0x177>
      if(c == 'd'){
 698:	83 7d e4 64          	cmpl   $0x64,-0x1c(%ebp)
 69c:	75 1e                	jne    6bc <printf+0x98>
        printint(fd, *ap, 10, 1);
 69e:	8b 45 e8             	mov    -0x18(%ebp),%eax
 6a1:	8b 00                	mov    (%eax),%eax
 6a3:	6a 01                	push   $0x1
 6a5:	6a 0a                	push   $0xa
 6a7:	50                   	push   %eax
 6a8:	ff 75 08             	push   0x8(%ebp)
 6ab:	e8 c3 fe ff ff       	call   573 <printint>
 6b0:	83 c4 10             	add    $0x10,%esp
        ap++;
 6b3:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 6b7:	e9 d8 00 00 00       	jmp    794 <printf+0x170>
      } else if(c == 'x' || c == 'p'){
 6bc:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
 6c0:	74 06                	je     6c8 <printf+0xa4>
 6c2:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
 6c6:	75 1e                	jne    6e6 <printf+0xc2>
        printint(fd, *ap, 16, 0);
 6c8:	8b 45 e8             	mov    -0x18(%ebp),%eax
 6cb:	8b 00                	mov    (%eax),%eax
 6cd:	6a 00                	push   $0x0
 6cf:	6a 10                	push   $0x10
 6d1:	50                   	push   %eax
 6d2:	ff 75 08             	push   0x8(%ebp)
 6d5:	e8 99 fe ff ff       	call   573 <printint>
 6da:	83 c4 10             	add    $0x10,%esp
        ap++;
 6dd:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 6e1:	e9 ae 00 00 00       	jmp    794 <printf+0x170>
      } else if(c == 's'){
 6e6:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
 6ea:	75 43                	jne    72f <printf+0x10b>
        s = (char*)*ap;
 6ec:	8b 45 e8             	mov    -0x18(%ebp),%eax
 6ef:	8b 00                	mov    (%eax),%eax
 6f1:	89 45 f4             	mov    %eax,-0xc(%ebp)
        ap++;
 6f4:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
        if(s == 0)
 6f8:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 6fc:	75 25                	jne    723 <printf+0xff>
          s = "(null)";
 6fe:	c7 45 f4 36 0a 00 00 	movl   $0xa36,-0xc(%ebp)
        while(*s != 0){
 705:	eb 1c                	jmp    723 <printf+0xff>
          putc(fd, *s);
 707:	8b 45 f4             	mov    -0xc(%ebp),%eax
 70a:	0f b6 00             	movzbl (%eax),%eax
 70d:	0f be c0             	movsbl %al,%eax
 710:	83 ec 08             	sub    $0x8,%esp
 713:	50                   	push   %eax
 714:	ff 75 08             	push   0x8(%ebp)
 717:	e8 34 fe ff ff       	call   550 <putc>
 71c:	83 c4 10             	add    $0x10,%esp
          s++;
 71f:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
        while(*s != 0){
 723:	8b 45 f4             	mov    -0xc(%ebp),%eax
 726:	0f b6 00             	movzbl (%eax),%eax
 729:	84 c0                	test   %al,%al
 72b:	75 da                	jne    707 <printf+0xe3>
 72d:	eb 65                	jmp    794 <printf+0x170>
        }
      } else if(c == 'c'){
 72f:	83 7d e4 63          	cmpl   $0x63,-0x1c(%ebp)
 733:	75 1d                	jne    752 <printf+0x12e>
        putc(fd, *ap);
 735:	8b 45 e8             	mov    -0x18(%ebp),%eax
 738:	8b 00                	mov    (%eax),%eax
 73a:	0f be c0             	movsbl %al,%eax
 73d:	83 ec 08             	sub    $0x8,%esp
 740:	50                   	push   %eax
 741:	ff 75 08             	push   0x8(%ebp)
 744:	e8 07 fe ff ff       	call   550 <putc>
 749:	83 c4 10             	add    $0x10,%esp
        ap++;
 74c:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 750:	eb 42                	jmp    794 <printf+0x170>
      } else if(c == '%'){
 752:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 756:	75 17                	jne    76f <printf+0x14b>
        putc(fd, c);
 758:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 75b:	0f be c0             	movsbl %al,%eax
 75e:	83 ec 08             	sub    $0x8,%esp
 761:	50                   	push   %eax
 762:	ff 75 08             	push   0x8(%ebp)
 765:	e8 e6 fd ff ff       	call   550 <putc>
 76a:	83 c4 10             	add    $0x10,%esp
 76d:	eb 25                	jmp    794 <printf+0x170>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 76f:	83 ec 08             	sub    $0x8,%esp
 772:	6a 25                	push   $0x25
 774:	ff 75 08             	push   0x8(%ebp)
 777:	e8 d4 fd ff ff       	call   550 <putc>
 77c:	83 c4 10             	add    $0x10,%esp
        putc(fd, c);
 77f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 782:	0f be c0             	movsbl %al,%eax
 785:	83 ec 08             	sub    $0x8,%esp
 788:	50                   	push   %eax
 789:	ff 75 08             	push   0x8(%ebp)
 78c:	e8 bf fd ff ff       	call   550 <putc>
 791:	83 c4 10             	add    $0x10,%esp
      }
      state = 0;
 794:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  for(i = 0; fmt[i]; i++){
 79b:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
 79f:	8b 55 0c             	mov    0xc(%ebp),%edx
 7a2:	8b 45 f0             	mov    -0x10(%ebp),%eax
 7a5:	01 d0                	add    %edx,%eax
 7a7:	0f b6 00             	movzbl (%eax),%eax
 7aa:	84 c0                	test   %al,%al
 7ac:	0f 85 94 fe ff ff    	jne    646 <printf+0x22>
    }
  }
}
 7b2:	90                   	nop
 7b3:	90                   	nop
 7b4:	c9                   	leave  
 7b5:	c3                   	ret    

000007b6 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 7b6:	55                   	push   %ebp
 7b7:	89 e5                	mov    %esp,%ebp
 7b9:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
 7bc:	8b 45 08             	mov    0x8(%ebp),%eax
 7bf:	83 e8 08             	sub    $0x8,%eax
 7c2:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 7c5:	a1 88 8d 00 00       	mov    0x8d88,%eax
 7ca:	89 45 fc             	mov    %eax,-0x4(%ebp)
 7cd:	eb 24                	jmp    7f3 <free+0x3d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 7cf:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7d2:	8b 00                	mov    (%eax),%eax
 7d4:	39 45 fc             	cmp    %eax,-0x4(%ebp)
 7d7:	72 12                	jb     7eb <free+0x35>
 7d9:	8b 45 f8             	mov    -0x8(%ebp),%eax
 7dc:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 7df:	77 24                	ja     805 <free+0x4f>
 7e1:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7e4:	8b 00                	mov    (%eax),%eax
 7e6:	39 45 f8             	cmp    %eax,-0x8(%ebp)
 7e9:	72 1a                	jb     805 <free+0x4f>
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 7eb:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7ee:	8b 00                	mov    (%eax),%eax
 7f0:	89 45 fc             	mov    %eax,-0x4(%ebp)
 7f3:	8b 45 f8             	mov    -0x8(%ebp),%eax
 7f6:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 7f9:	76 d4                	jbe    7cf <free+0x19>
 7fb:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7fe:	8b 00                	mov    (%eax),%eax
 800:	39 45 f8             	cmp    %eax,-0x8(%ebp)
 803:	73 ca                	jae    7cf <free+0x19>
      break;
  if(bp + bp->s.size == p->s.ptr){
 805:	8b 45 f8             	mov    -0x8(%ebp),%eax
 808:	8b 40 04             	mov    0x4(%eax),%eax
 80b:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 812:	8b 45 f8             	mov    -0x8(%ebp),%eax
 815:	01 c2                	add    %eax,%edx
 817:	8b 45 fc             	mov    -0x4(%ebp),%eax
 81a:	8b 00                	mov    (%eax),%eax
 81c:	39 c2                	cmp    %eax,%edx
 81e:	75 24                	jne    844 <free+0x8e>
    bp->s.size += p->s.ptr->s.size;
 820:	8b 45 f8             	mov    -0x8(%ebp),%eax
 823:	8b 50 04             	mov    0x4(%eax),%edx
 826:	8b 45 fc             	mov    -0x4(%ebp),%eax
 829:	8b 00                	mov    (%eax),%eax
 82b:	8b 40 04             	mov    0x4(%eax),%eax
 82e:	01 c2                	add    %eax,%edx
 830:	8b 45 f8             	mov    -0x8(%ebp),%eax
 833:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
 836:	8b 45 fc             	mov    -0x4(%ebp),%eax
 839:	8b 00                	mov    (%eax),%eax
 83b:	8b 10                	mov    (%eax),%edx
 83d:	8b 45 f8             	mov    -0x8(%ebp),%eax
 840:	89 10                	mov    %edx,(%eax)
 842:	eb 0a                	jmp    84e <free+0x98>
  } else
    bp->s.ptr = p->s.ptr;
 844:	8b 45 fc             	mov    -0x4(%ebp),%eax
 847:	8b 10                	mov    (%eax),%edx
 849:	8b 45 f8             	mov    -0x8(%ebp),%eax
 84c:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
 84e:	8b 45 fc             	mov    -0x4(%ebp),%eax
 851:	8b 40 04             	mov    0x4(%eax),%eax
 854:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 85b:	8b 45 fc             	mov    -0x4(%ebp),%eax
 85e:	01 d0                	add    %edx,%eax
 860:	39 45 f8             	cmp    %eax,-0x8(%ebp)
 863:	75 20                	jne    885 <free+0xcf>
    p->s.size += bp->s.size;
 865:	8b 45 fc             	mov    -0x4(%ebp),%eax
 868:	8b 50 04             	mov    0x4(%eax),%edx
 86b:	8b 45 f8             	mov    -0x8(%ebp),%eax
 86e:	8b 40 04             	mov    0x4(%eax),%eax
 871:	01 c2                	add    %eax,%edx
 873:	8b 45 fc             	mov    -0x4(%ebp),%eax
 876:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 879:	8b 45 f8             	mov    -0x8(%ebp),%eax
 87c:	8b 10                	mov    (%eax),%edx
 87e:	8b 45 fc             	mov    -0x4(%ebp),%eax
 881:	89 10                	mov    %edx,(%eax)
 883:	eb 08                	jmp    88d <free+0xd7>
  } else
    p->s.ptr = bp;
 885:	8b 45 fc             	mov    -0x4(%ebp),%eax
 888:	8b 55 f8             	mov    -0x8(%ebp),%edx
 88b:	89 10                	mov    %edx,(%eax)
  freep = p;
 88d:	8b 45 fc             	mov    -0x4(%ebp),%eax
 890:	a3 88 8d 00 00       	mov    %eax,0x8d88
}
 895:	90                   	nop
 896:	c9                   	leave  
 897:	c3                   	ret    

00000898 <morecore>:

static Header*
morecore(uint nu)
{
 898:	55                   	push   %ebp
 899:	89 e5                	mov    %esp,%ebp
 89b:	83 ec 18             	sub    $0x18,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
 89e:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
 8a5:	77 07                	ja     8ae <morecore+0x16>
    nu = 4096;
 8a7:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
 8ae:	8b 45 08             	mov    0x8(%ebp),%eax
 8b1:	c1 e0 03             	shl    $0x3,%eax
 8b4:	83 ec 0c             	sub    $0xc,%esp
 8b7:	50                   	push   %eax
 8b8:	e8 6b fc ff ff       	call   528 <sbrk>
 8bd:	83 c4 10             	add    $0x10,%esp
 8c0:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(p == (char*)-1)
 8c3:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
 8c7:	75 07                	jne    8d0 <morecore+0x38>
    return 0;
 8c9:	b8 00 00 00 00       	mov    $0x0,%eax
 8ce:	eb 26                	jmp    8f6 <morecore+0x5e>
  hp = (Header*)p;
 8d0:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8d3:	89 45 f0             	mov    %eax,-0x10(%ebp)
  hp->s.size = nu;
 8d6:	8b 45 f0             	mov    -0x10(%ebp),%eax
 8d9:	8b 55 08             	mov    0x8(%ebp),%edx
 8dc:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
 8df:	8b 45 f0             	mov    -0x10(%ebp),%eax
 8e2:	83 c0 08             	add    $0x8,%eax
 8e5:	83 ec 0c             	sub    $0xc,%esp
 8e8:	50                   	push   %eax
 8e9:	e8 c8 fe ff ff       	call   7b6 <free>
 8ee:	83 c4 10             	add    $0x10,%esp
  return freep;
 8f1:	a1 88 8d 00 00       	mov    0x8d88,%eax
}
 8f6:	c9                   	leave  
 8f7:	c3                   	ret    

000008f8 <malloc>:

void*
malloc(uint nbytes)
{
 8f8:	55                   	push   %ebp
 8f9:	89 e5                	mov    %esp,%ebp
 8fb:	83 ec 18             	sub    $0x18,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 8fe:	8b 45 08             	mov    0x8(%ebp),%eax
 901:	83 c0 07             	add    $0x7,%eax
 904:	c1 e8 03             	shr    $0x3,%eax
 907:	83 c0 01             	add    $0x1,%eax
 90a:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((prevp = freep) == 0){
 90d:	a1 88 8d 00 00       	mov    0x8d88,%eax
 912:	89 45 f0             	mov    %eax,-0x10(%ebp)
 915:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 919:	75 23                	jne    93e <malloc+0x46>
    base.s.ptr = freep = prevp = &base;
 91b:	c7 45 f0 80 8d 00 00 	movl   $0x8d80,-0x10(%ebp)
 922:	8b 45 f0             	mov    -0x10(%ebp),%eax
 925:	a3 88 8d 00 00       	mov    %eax,0x8d88
 92a:	a1 88 8d 00 00       	mov    0x8d88,%eax
 92f:	a3 80 8d 00 00       	mov    %eax,0x8d80
    base.s.size = 0;
 934:	c7 05 84 8d 00 00 00 	movl   $0x0,0x8d84
 93b:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 93e:	8b 45 f0             	mov    -0x10(%ebp),%eax
 941:	8b 00                	mov    (%eax),%eax
 943:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
 946:	8b 45 f4             	mov    -0xc(%ebp),%eax
 949:	8b 40 04             	mov    0x4(%eax),%eax
 94c:	39 45 ec             	cmp    %eax,-0x14(%ebp)
 94f:	77 4d                	ja     99e <malloc+0xa6>
      if(p->s.size == nunits)
 951:	8b 45 f4             	mov    -0xc(%ebp),%eax
 954:	8b 40 04             	mov    0x4(%eax),%eax
 957:	39 45 ec             	cmp    %eax,-0x14(%ebp)
 95a:	75 0c                	jne    968 <malloc+0x70>
        prevp->s.ptr = p->s.ptr;
 95c:	8b 45 f4             	mov    -0xc(%ebp),%eax
 95f:	8b 10                	mov    (%eax),%edx
 961:	8b 45 f0             	mov    -0x10(%ebp),%eax
 964:	89 10                	mov    %edx,(%eax)
 966:	eb 26                	jmp    98e <malloc+0x96>
      else {
        p->s.size -= nunits;
 968:	8b 45 f4             	mov    -0xc(%ebp),%eax
 96b:	8b 40 04             	mov    0x4(%eax),%eax
 96e:	2b 45 ec             	sub    -0x14(%ebp),%eax
 971:	89 c2                	mov    %eax,%edx
 973:	8b 45 f4             	mov    -0xc(%ebp),%eax
 976:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
 979:	8b 45 f4             	mov    -0xc(%ebp),%eax
 97c:	8b 40 04             	mov    0x4(%eax),%eax
 97f:	c1 e0 03             	shl    $0x3,%eax
 982:	01 45 f4             	add    %eax,-0xc(%ebp)
        p->s.size = nunits;
 985:	8b 45 f4             	mov    -0xc(%ebp),%eax
 988:	8b 55 ec             	mov    -0x14(%ebp),%edx
 98b:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
 98e:	8b 45 f0             	mov    -0x10(%ebp),%eax
 991:	a3 88 8d 00 00       	mov    %eax,0x8d88
      return (void*)(p + 1);
 996:	8b 45 f4             	mov    -0xc(%ebp),%eax
 999:	83 c0 08             	add    $0x8,%eax
 99c:	eb 3b                	jmp    9d9 <malloc+0xe1>
    }
    if(p == freep)
 99e:	a1 88 8d 00 00       	mov    0x8d88,%eax
 9a3:	39 45 f4             	cmp    %eax,-0xc(%ebp)
 9a6:	75 1e                	jne    9c6 <malloc+0xce>
      if((p = morecore(nunits)) == 0)
 9a8:	83 ec 0c             	sub    $0xc,%esp
 9ab:	ff 75 ec             	push   -0x14(%ebp)
 9ae:	e8 e5 fe ff ff       	call   898 <morecore>
 9b3:	83 c4 10             	add    $0x10,%esp
 9b6:	89 45 f4             	mov    %eax,-0xc(%ebp)
 9b9:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 9bd:	75 07                	jne    9c6 <malloc+0xce>
        return 0;
 9bf:	b8 00 00 00 00       	mov    $0x0,%eax
 9c4:	eb 13                	jmp    9d9 <malloc+0xe1>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 9c6:	8b 45 f4             	mov    -0xc(%ebp),%eax
 9c9:	89 45 f0             	mov    %eax,-0x10(%ebp)
 9cc:	8b 45 f4             	mov    -0xc(%ebp),%eax
 9cf:	8b 00                	mov    (%eax),%eax
 9d1:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
 9d4:	e9 6d ff ff ff       	jmp    946 <malloc+0x4e>
  }
}
 9d9:	c9                   	leave  
 9da:	c3                   	ret    
