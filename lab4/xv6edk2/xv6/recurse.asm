
_recurse:     file format elf32-i386


Disassembly of section .text:

00000000 <main>:
//}

#pragma GCC pop_options

int main(int argc, char *argv[])
{
   0:	8d 4c 24 04          	lea    0x4(%esp),%ecx
   4:	83 e4 f0             	and    $0xfffffff0,%esp
   7:	ff 71 fc             	push   -0x4(%ecx)
   a:	55                   	push   %ebp
   b:	89 e5                	mov    %esp,%ebp
   d:	51                   	push   %ecx
   e:	83 ec 04             	sub    $0x4,%esp
  11:	89 c8                	mov    %ecx,%eax
  //int n, m;

  if(argc != 2){
  13:	83 38 02             	cmpl   $0x2,(%eax)
  16:	74 1d                	je     35 <main+0x35>
    printf(1, "Usage: %s levels\n", argv[0]);
  18:	8b 40 04             	mov    0x4(%eax),%eax
  1b:	8b 00                	mov    (%eax),%eax
  1d:	83 ec 04             	sub    $0x4,%esp
  20:	50                   	push   %eax
  21:	68 d5 07 00 00       	push   $0x7d5
  26:	6a 01                	push   $0x1
  28:	e8 f1 03 00 00       	call   41e <printf>
  2d:	83 c4 10             	add    $0x10,%esp
    exit();
  30:	e8 6d 02 00 00       	call   2a2 <exit>
  }
  printpt(getpid()); // Uncomment for the test.
  35:	e8 e8 02 00 00       	call   322 <getpid>
  3a:	83 ec 0c             	sub    $0xc,%esp
  3d:	50                   	push   %eax
  3e:	e8 ff 02 00 00       	call   342 <printpt>
  43:	83 c4 10             	add    $0x10,%esp
  //n = atoi(argv[1]);
  //printf(1, "Recursing %d levels\n", n);
  //m = recurse(n);
  //printf(1, "Yielded a value of %d\n", m);
 // printpt(getpid()); // Uncomment for the test.
  exit();
  46:	e8 57 02 00 00       	call   2a2 <exit>

0000004b <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
  4b:	55                   	push   %ebp
  4c:	89 e5                	mov    %esp,%ebp
  4e:	57                   	push   %edi
  4f:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
  50:	8b 4d 08             	mov    0x8(%ebp),%ecx
  53:	8b 55 10             	mov    0x10(%ebp),%edx
  56:	8b 45 0c             	mov    0xc(%ebp),%eax
  59:	89 cb                	mov    %ecx,%ebx
  5b:	89 df                	mov    %ebx,%edi
  5d:	89 d1                	mov    %edx,%ecx
  5f:	fc                   	cld    
  60:	f3 aa                	rep stos %al,%es:(%edi)
  62:	89 ca                	mov    %ecx,%edx
  64:	89 fb                	mov    %edi,%ebx
  66:	89 5d 08             	mov    %ebx,0x8(%ebp)
  69:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
  6c:	90                   	nop
  6d:	5b                   	pop    %ebx
  6e:	5f                   	pop    %edi
  6f:	5d                   	pop    %ebp
  70:	c3                   	ret    

00000071 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
  71:	55                   	push   %ebp
  72:	89 e5                	mov    %esp,%ebp
  74:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
  77:	8b 45 08             	mov    0x8(%ebp),%eax
  7a:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while((*s++ = *t++) != 0)
  7d:	90                   	nop
  7e:	8b 55 0c             	mov    0xc(%ebp),%edx
  81:	8d 42 01             	lea    0x1(%edx),%eax
  84:	89 45 0c             	mov    %eax,0xc(%ebp)
  87:	8b 45 08             	mov    0x8(%ebp),%eax
  8a:	8d 48 01             	lea    0x1(%eax),%ecx
  8d:	89 4d 08             	mov    %ecx,0x8(%ebp)
  90:	0f b6 12             	movzbl (%edx),%edx
  93:	88 10                	mov    %dl,(%eax)
  95:	0f b6 00             	movzbl (%eax),%eax
  98:	84 c0                	test   %al,%al
  9a:	75 e2                	jne    7e <strcpy+0xd>
    ;
  return os;
  9c:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  9f:	c9                   	leave  
  a0:	c3                   	ret    

000000a1 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  a1:	55                   	push   %ebp
  a2:	89 e5                	mov    %esp,%ebp
  while(*p && *p == *q)
  a4:	eb 08                	jmp    ae <strcmp+0xd>
    p++, q++;
  a6:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  aa:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
  while(*p && *p == *q)
  ae:	8b 45 08             	mov    0x8(%ebp),%eax
  b1:	0f b6 00             	movzbl (%eax),%eax
  b4:	84 c0                	test   %al,%al
  b6:	74 10                	je     c8 <strcmp+0x27>
  b8:	8b 45 08             	mov    0x8(%ebp),%eax
  bb:	0f b6 10             	movzbl (%eax),%edx
  be:	8b 45 0c             	mov    0xc(%ebp),%eax
  c1:	0f b6 00             	movzbl (%eax),%eax
  c4:	38 c2                	cmp    %al,%dl
  c6:	74 de                	je     a6 <strcmp+0x5>
  return (uchar)*p - (uchar)*q;
  c8:	8b 45 08             	mov    0x8(%ebp),%eax
  cb:	0f b6 00             	movzbl (%eax),%eax
  ce:	0f b6 d0             	movzbl %al,%edx
  d1:	8b 45 0c             	mov    0xc(%ebp),%eax
  d4:	0f b6 00             	movzbl (%eax),%eax
  d7:	0f b6 c8             	movzbl %al,%ecx
  da:	89 d0                	mov    %edx,%eax
  dc:	29 c8                	sub    %ecx,%eax
}
  de:	5d                   	pop    %ebp
  df:	c3                   	ret    

000000e0 <strlen>:

uint
strlen(char *s)
{
  e0:	55                   	push   %ebp
  e1:	89 e5                	mov    %esp,%ebp
  e3:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
  e6:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  ed:	eb 04                	jmp    f3 <strlen+0x13>
  ef:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
  f3:	8b 55 fc             	mov    -0x4(%ebp),%edx
  f6:	8b 45 08             	mov    0x8(%ebp),%eax
  f9:	01 d0                	add    %edx,%eax
  fb:	0f b6 00             	movzbl (%eax),%eax
  fe:	84 c0                	test   %al,%al
 100:	75 ed                	jne    ef <strlen+0xf>
    ;
  return n;
 102:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 105:	c9                   	leave  
 106:	c3                   	ret    

00000107 <memset>:

void*
memset(void *dst, int c, uint n)
{
 107:	55                   	push   %ebp
 108:	89 e5                	mov    %esp,%ebp
  stosb(dst, c, n);
 10a:	8b 45 10             	mov    0x10(%ebp),%eax
 10d:	50                   	push   %eax
 10e:	ff 75 0c             	push   0xc(%ebp)
 111:	ff 75 08             	push   0x8(%ebp)
 114:	e8 32 ff ff ff       	call   4b <stosb>
 119:	83 c4 0c             	add    $0xc,%esp
  return dst;
 11c:	8b 45 08             	mov    0x8(%ebp),%eax
}
 11f:	c9                   	leave  
 120:	c3                   	ret    

00000121 <strchr>:

char*
strchr(const char *s, char c)
{
 121:	55                   	push   %ebp
 122:	89 e5                	mov    %esp,%ebp
 124:	83 ec 04             	sub    $0x4,%esp
 127:	8b 45 0c             	mov    0xc(%ebp),%eax
 12a:	88 45 fc             	mov    %al,-0x4(%ebp)
  for(; *s; s++)
 12d:	eb 14                	jmp    143 <strchr+0x22>
    if(*s == c)
 12f:	8b 45 08             	mov    0x8(%ebp),%eax
 132:	0f b6 00             	movzbl (%eax),%eax
 135:	38 45 fc             	cmp    %al,-0x4(%ebp)
 138:	75 05                	jne    13f <strchr+0x1e>
      return (char*)s;
 13a:	8b 45 08             	mov    0x8(%ebp),%eax
 13d:	eb 13                	jmp    152 <strchr+0x31>
  for(; *s; s++)
 13f:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 143:	8b 45 08             	mov    0x8(%ebp),%eax
 146:	0f b6 00             	movzbl (%eax),%eax
 149:	84 c0                	test   %al,%al
 14b:	75 e2                	jne    12f <strchr+0xe>
  return 0;
 14d:	b8 00 00 00 00       	mov    $0x0,%eax
}
 152:	c9                   	leave  
 153:	c3                   	ret    

00000154 <gets>:

char*
gets(char *buf, int max)
{
 154:	55                   	push   %ebp
 155:	89 e5                	mov    %esp,%ebp
 157:	83 ec 18             	sub    $0x18,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 15a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
 161:	eb 42                	jmp    1a5 <gets+0x51>
    cc = read(0, &c, 1);
 163:	83 ec 04             	sub    $0x4,%esp
 166:	6a 01                	push   $0x1
 168:	8d 45 ef             	lea    -0x11(%ebp),%eax
 16b:	50                   	push   %eax
 16c:	6a 00                	push   $0x0
 16e:	e8 47 01 00 00       	call   2ba <read>
 173:	83 c4 10             	add    $0x10,%esp
 176:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(cc < 1)
 179:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 17d:	7e 33                	jle    1b2 <gets+0x5e>
      break;
    buf[i++] = c;
 17f:	8b 45 f4             	mov    -0xc(%ebp),%eax
 182:	8d 50 01             	lea    0x1(%eax),%edx
 185:	89 55 f4             	mov    %edx,-0xc(%ebp)
 188:	89 c2                	mov    %eax,%edx
 18a:	8b 45 08             	mov    0x8(%ebp),%eax
 18d:	01 c2                	add    %eax,%edx
 18f:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 193:	88 02                	mov    %al,(%edx)
    if(c == '\n' || c == '\r')
 195:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 199:	3c 0a                	cmp    $0xa,%al
 19b:	74 16                	je     1b3 <gets+0x5f>
 19d:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 1a1:	3c 0d                	cmp    $0xd,%al
 1a3:	74 0e                	je     1b3 <gets+0x5f>
  for(i=0; i+1 < max; ){
 1a5:	8b 45 f4             	mov    -0xc(%ebp),%eax
 1a8:	83 c0 01             	add    $0x1,%eax
 1ab:	39 45 0c             	cmp    %eax,0xc(%ebp)
 1ae:	7f b3                	jg     163 <gets+0xf>
 1b0:	eb 01                	jmp    1b3 <gets+0x5f>
      break;
 1b2:	90                   	nop
      break;
  }
  buf[i] = '\0';
 1b3:	8b 55 f4             	mov    -0xc(%ebp),%edx
 1b6:	8b 45 08             	mov    0x8(%ebp),%eax
 1b9:	01 d0                	add    %edx,%eax
 1bb:	c6 00 00             	movb   $0x0,(%eax)
  return buf;
 1be:	8b 45 08             	mov    0x8(%ebp),%eax
}
 1c1:	c9                   	leave  
 1c2:	c3                   	ret    

000001c3 <stat>:

int
stat(char *n, struct stat *st)
{
 1c3:	55                   	push   %ebp
 1c4:	89 e5                	mov    %esp,%ebp
 1c6:	83 ec 18             	sub    $0x18,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 1c9:	83 ec 08             	sub    $0x8,%esp
 1cc:	6a 00                	push   $0x0
 1ce:	ff 75 08             	push   0x8(%ebp)
 1d1:	e8 0c 01 00 00       	call   2e2 <open>
 1d6:	83 c4 10             	add    $0x10,%esp
 1d9:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0)
 1dc:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 1e0:	79 07                	jns    1e9 <stat+0x26>
    return -1;
 1e2:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 1e7:	eb 25                	jmp    20e <stat+0x4b>
  r = fstat(fd, st);
 1e9:	83 ec 08             	sub    $0x8,%esp
 1ec:	ff 75 0c             	push   0xc(%ebp)
 1ef:	ff 75 f4             	push   -0xc(%ebp)
 1f2:	e8 03 01 00 00       	call   2fa <fstat>
 1f7:	83 c4 10             	add    $0x10,%esp
 1fa:	89 45 f0             	mov    %eax,-0x10(%ebp)
  close(fd);
 1fd:	83 ec 0c             	sub    $0xc,%esp
 200:	ff 75 f4             	push   -0xc(%ebp)
 203:	e8 c2 00 00 00       	call   2ca <close>
 208:	83 c4 10             	add    $0x10,%esp
  return r;
 20b:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
 20e:	c9                   	leave  
 20f:	c3                   	ret    

00000210 <atoi>:

int
atoi(const char *s)
{
 210:	55                   	push   %ebp
 211:	89 e5                	mov    %esp,%ebp
 213:	83 ec 10             	sub    $0x10,%esp
  int n;

  n = 0;
 216:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while('0' <= *s && *s <= '9')
 21d:	eb 25                	jmp    244 <atoi+0x34>
    n = n*10 + *s++ - '0';
 21f:	8b 55 fc             	mov    -0x4(%ebp),%edx
 222:	89 d0                	mov    %edx,%eax
 224:	c1 e0 02             	shl    $0x2,%eax
 227:	01 d0                	add    %edx,%eax
 229:	01 c0                	add    %eax,%eax
 22b:	89 c1                	mov    %eax,%ecx
 22d:	8b 45 08             	mov    0x8(%ebp),%eax
 230:	8d 50 01             	lea    0x1(%eax),%edx
 233:	89 55 08             	mov    %edx,0x8(%ebp)
 236:	0f b6 00             	movzbl (%eax),%eax
 239:	0f be c0             	movsbl %al,%eax
 23c:	01 c8                	add    %ecx,%eax
 23e:	83 e8 30             	sub    $0x30,%eax
 241:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while('0' <= *s && *s <= '9')
 244:	8b 45 08             	mov    0x8(%ebp),%eax
 247:	0f b6 00             	movzbl (%eax),%eax
 24a:	3c 2f                	cmp    $0x2f,%al
 24c:	7e 0a                	jle    258 <atoi+0x48>
 24e:	8b 45 08             	mov    0x8(%ebp),%eax
 251:	0f b6 00             	movzbl (%eax),%eax
 254:	3c 39                	cmp    $0x39,%al
 256:	7e c7                	jle    21f <atoi+0xf>
  return n;
 258:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 25b:	c9                   	leave  
 25c:	c3                   	ret    

0000025d <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
 25d:	55                   	push   %ebp
 25e:	89 e5                	mov    %esp,%ebp
 260:	83 ec 10             	sub    $0x10,%esp
  char *dst, *src;

  dst = vdst;
 263:	8b 45 08             	mov    0x8(%ebp),%eax
 266:	89 45 fc             	mov    %eax,-0x4(%ebp)
  src = vsrc;
 269:	8b 45 0c             	mov    0xc(%ebp),%eax
 26c:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0)
 26f:	eb 17                	jmp    288 <memmove+0x2b>
    *dst++ = *src++;
 271:	8b 55 f8             	mov    -0x8(%ebp),%edx
 274:	8d 42 01             	lea    0x1(%edx),%eax
 277:	89 45 f8             	mov    %eax,-0x8(%ebp)
 27a:	8b 45 fc             	mov    -0x4(%ebp),%eax
 27d:	8d 48 01             	lea    0x1(%eax),%ecx
 280:	89 4d fc             	mov    %ecx,-0x4(%ebp)
 283:	0f b6 12             	movzbl (%edx),%edx
 286:	88 10                	mov    %dl,(%eax)
  while(n-- > 0)
 288:	8b 45 10             	mov    0x10(%ebp),%eax
 28b:	8d 50 ff             	lea    -0x1(%eax),%edx
 28e:	89 55 10             	mov    %edx,0x10(%ebp)
 291:	85 c0                	test   %eax,%eax
 293:	7f dc                	jg     271 <memmove+0x14>
  return vdst;
 295:	8b 45 08             	mov    0x8(%ebp),%eax
}
 298:	c9                   	leave  
 299:	c3                   	ret    

0000029a <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 29a:	b8 01 00 00 00       	mov    $0x1,%eax
 29f:	cd 40                	int    $0x40
 2a1:	c3                   	ret    

000002a2 <exit>:
SYSCALL(exit)
 2a2:	b8 02 00 00 00       	mov    $0x2,%eax
 2a7:	cd 40                	int    $0x40
 2a9:	c3                   	ret    

000002aa <wait>:
SYSCALL(wait)
 2aa:	b8 03 00 00 00       	mov    $0x3,%eax
 2af:	cd 40                	int    $0x40
 2b1:	c3                   	ret    

000002b2 <pipe>:
SYSCALL(pipe)
 2b2:	b8 04 00 00 00       	mov    $0x4,%eax
 2b7:	cd 40                	int    $0x40
 2b9:	c3                   	ret    

000002ba <read>:
SYSCALL(read)
 2ba:	b8 05 00 00 00       	mov    $0x5,%eax
 2bf:	cd 40                	int    $0x40
 2c1:	c3                   	ret    

000002c2 <write>:
SYSCALL(write)
 2c2:	b8 10 00 00 00       	mov    $0x10,%eax
 2c7:	cd 40                	int    $0x40
 2c9:	c3                   	ret    

000002ca <close>:
SYSCALL(close)
 2ca:	b8 15 00 00 00       	mov    $0x15,%eax
 2cf:	cd 40                	int    $0x40
 2d1:	c3                   	ret    

000002d2 <kill>:
SYSCALL(kill)
 2d2:	b8 06 00 00 00       	mov    $0x6,%eax
 2d7:	cd 40                	int    $0x40
 2d9:	c3                   	ret    

000002da <exec>:
SYSCALL(exec)
 2da:	b8 07 00 00 00       	mov    $0x7,%eax
 2df:	cd 40                	int    $0x40
 2e1:	c3                   	ret    

000002e2 <open>:
SYSCALL(open)
 2e2:	b8 0f 00 00 00       	mov    $0xf,%eax
 2e7:	cd 40                	int    $0x40
 2e9:	c3                   	ret    

000002ea <mknod>:
SYSCALL(mknod)
 2ea:	b8 11 00 00 00       	mov    $0x11,%eax
 2ef:	cd 40                	int    $0x40
 2f1:	c3                   	ret    

000002f2 <unlink>:
SYSCALL(unlink)
 2f2:	b8 12 00 00 00       	mov    $0x12,%eax
 2f7:	cd 40                	int    $0x40
 2f9:	c3                   	ret    

000002fa <fstat>:
SYSCALL(fstat)
 2fa:	b8 08 00 00 00       	mov    $0x8,%eax
 2ff:	cd 40                	int    $0x40
 301:	c3                   	ret    

00000302 <link>:
SYSCALL(link)
 302:	b8 13 00 00 00       	mov    $0x13,%eax
 307:	cd 40                	int    $0x40
 309:	c3                   	ret    

0000030a <mkdir>:
SYSCALL(mkdir)
 30a:	b8 14 00 00 00       	mov    $0x14,%eax
 30f:	cd 40                	int    $0x40
 311:	c3                   	ret    

00000312 <chdir>:
SYSCALL(chdir)
 312:	b8 09 00 00 00       	mov    $0x9,%eax
 317:	cd 40                	int    $0x40
 319:	c3                   	ret    

0000031a <dup>:
SYSCALL(dup)
 31a:	b8 0a 00 00 00       	mov    $0xa,%eax
 31f:	cd 40                	int    $0x40
 321:	c3                   	ret    

00000322 <getpid>:
SYSCALL(getpid)
 322:	b8 0b 00 00 00       	mov    $0xb,%eax
 327:	cd 40                	int    $0x40
 329:	c3                   	ret    

0000032a <sbrk>:
SYSCALL(sbrk)
 32a:	b8 0c 00 00 00       	mov    $0xc,%eax
 32f:	cd 40                	int    $0x40
 331:	c3                   	ret    

00000332 <sleep>:
SYSCALL(sleep)
 332:	b8 0d 00 00 00       	mov    $0xd,%eax
 337:	cd 40                	int    $0x40
 339:	c3                   	ret    

0000033a <uptime>:
SYSCALL(uptime)
 33a:	b8 0e 00 00 00       	mov    $0xe,%eax
 33f:	cd 40                	int    $0x40
 341:	c3                   	ret    

00000342 <printpt>:
SYSCALL(printpt)
 342:	b8 16 00 00 00       	mov    $0x16,%eax
 347:	cd 40                	int    $0x40
 349:	c3                   	ret    

0000034a <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 34a:	55                   	push   %ebp
 34b:	89 e5                	mov    %esp,%ebp
 34d:	83 ec 18             	sub    $0x18,%esp
 350:	8b 45 0c             	mov    0xc(%ebp),%eax
 353:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
 356:	83 ec 04             	sub    $0x4,%esp
 359:	6a 01                	push   $0x1
 35b:	8d 45 f4             	lea    -0xc(%ebp),%eax
 35e:	50                   	push   %eax
 35f:	ff 75 08             	push   0x8(%ebp)
 362:	e8 5b ff ff ff       	call   2c2 <write>
 367:	83 c4 10             	add    $0x10,%esp
}
 36a:	90                   	nop
 36b:	c9                   	leave  
 36c:	c3                   	ret    

0000036d <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 36d:	55                   	push   %ebp
 36e:	89 e5                	mov    %esp,%ebp
 370:	83 ec 28             	sub    $0x28,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
 373:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
 37a:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
 37e:	74 17                	je     397 <printint+0x2a>
 380:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
 384:	79 11                	jns    397 <printint+0x2a>
    neg = 1;
 386:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
 38d:	8b 45 0c             	mov    0xc(%ebp),%eax
 390:	f7 d8                	neg    %eax
 392:	89 45 ec             	mov    %eax,-0x14(%ebp)
 395:	eb 06                	jmp    39d <printint+0x30>
  } else {
    x = xx;
 397:	8b 45 0c             	mov    0xc(%ebp),%eax
 39a:	89 45 ec             	mov    %eax,-0x14(%ebp)
  }

  i = 0;
 39d:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
 3a4:	8b 4d 10             	mov    0x10(%ebp),%ecx
 3a7:	8b 45 ec             	mov    -0x14(%ebp),%eax
 3aa:	ba 00 00 00 00       	mov    $0x0,%edx
 3af:	f7 f1                	div    %ecx
 3b1:	89 d1                	mov    %edx,%ecx
 3b3:	8b 45 f4             	mov    -0xc(%ebp),%eax
 3b6:	8d 50 01             	lea    0x1(%eax),%edx
 3b9:	89 55 f4             	mov    %edx,-0xc(%ebp)
 3bc:	0f b6 91 34 0a 00 00 	movzbl 0xa34(%ecx),%edx
 3c3:	88 54 05 dc          	mov    %dl,-0x24(%ebp,%eax,1)
  }while((x /= base) != 0);
 3c7:	8b 4d 10             	mov    0x10(%ebp),%ecx
 3ca:	8b 45 ec             	mov    -0x14(%ebp),%eax
 3cd:	ba 00 00 00 00       	mov    $0x0,%edx
 3d2:	f7 f1                	div    %ecx
 3d4:	89 45 ec             	mov    %eax,-0x14(%ebp)
 3d7:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 3db:	75 c7                	jne    3a4 <printint+0x37>
  if(neg)
 3dd:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 3e1:	74 2d                	je     410 <printint+0xa3>
    buf[i++] = '-';
 3e3:	8b 45 f4             	mov    -0xc(%ebp),%eax
 3e6:	8d 50 01             	lea    0x1(%eax),%edx
 3e9:	89 55 f4             	mov    %edx,-0xc(%ebp)
 3ec:	c6 44 05 dc 2d       	movb   $0x2d,-0x24(%ebp,%eax,1)

  while(--i >= 0)
 3f1:	eb 1d                	jmp    410 <printint+0xa3>
    putc(fd, buf[i]);
 3f3:	8d 55 dc             	lea    -0x24(%ebp),%edx
 3f6:	8b 45 f4             	mov    -0xc(%ebp),%eax
 3f9:	01 d0                	add    %edx,%eax
 3fb:	0f b6 00             	movzbl (%eax),%eax
 3fe:	0f be c0             	movsbl %al,%eax
 401:	83 ec 08             	sub    $0x8,%esp
 404:	50                   	push   %eax
 405:	ff 75 08             	push   0x8(%ebp)
 408:	e8 3d ff ff ff       	call   34a <putc>
 40d:	83 c4 10             	add    $0x10,%esp
  while(--i >= 0)
 410:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
 414:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 418:	79 d9                	jns    3f3 <printint+0x86>
}
 41a:	90                   	nop
 41b:	90                   	nop
 41c:	c9                   	leave  
 41d:	c3                   	ret    

0000041e <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 41e:	55                   	push   %ebp
 41f:	89 e5                	mov    %esp,%ebp
 421:	83 ec 28             	sub    $0x28,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
 424:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  ap = (uint*)(void*)&fmt + 1;
 42b:	8d 45 0c             	lea    0xc(%ebp),%eax
 42e:	83 c0 04             	add    $0x4,%eax
 431:	89 45 e8             	mov    %eax,-0x18(%ebp)
  for(i = 0; fmt[i]; i++){
 434:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
 43b:	e9 59 01 00 00       	jmp    599 <printf+0x17b>
    c = fmt[i] & 0xff;
 440:	8b 55 0c             	mov    0xc(%ebp),%edx
 443:	8b 45 f0             	mov    -0x10(%ebp),%eax
 446:	01 d0                	add    %edx,%eax
 448:	0f b6 00             	movzbl (%eax),%eax
 44b:	0f be c0             	movsbl %al,%eax
 44e:	25 ff 00 00 00       	and    $0xff,%eax
 453:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(state == 0){
 456:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 45a:	75 2c                	jne    488 <printf+0x6a>
      if(c == '%'){
 45c:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 460:	75 0c                	jne    46e <printf+0x50>
        state = '%';
 462:	c7 45 ec 25 00 00 00 	movl   $0x25,-0x14(%ebp)
 469:	e9 27 01 00 00       	jmp    595 <printf+0x177>
      } else {
        putc(fd, c);
 46e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 471:	0f be c0             	movsbl %al,%eax
 474:	83 ec 08             	sub    $0x8,%esp
 477:	50                   	push   %eax
 478:	ff 75 08             	push   0x8(%ebp)
 47b:	e8 ca fe ff ff       	call   34a <putc>
 480:	83 c4 10             	add    $0x10,%esp
 483:	e9 0d 01 00 00       	jmp    595 <printf+0x177>
      }
    } else if(state == '%'){
 488:	83 7d ec 25          	cmpl   $0x25,-0x14(%ebp)
 48c:	0f 85 03 01 00 00    	jne    595 <printf+0x177>
      if(c == 'd'){
 492:	83 7d e4 64          	cmpl   $0x64,-0x1c(%ebp)
 496:	75 1e                	jne    4b6 <printf+0x98>
        printint(fd, *ap, 10, 1);
 498:	8b 45 e8             	mov    -0x18(%ebp),%eax
 49b:	8b 00                	mov    (%eax),%eax
 49d:	6a 01                	push   $0x1
 49f:	6a 0a                	push   $0xa
 4a1:	50                   	push   %eax
 4a2:	ff 75 08             	push   0x8(%ebp)
 4a5:	e8 c3 fe ff ff       	call   36d <printint>
 4aa:	83 c4 10             	add    $0x10,%esp
        ap++;
 4ad:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 4b1:	e9 d8 00 00 00       	jmp    58e <printf+0x170>
      } else if(c == 'x' || c == 'p'){
 4b6:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
 4ba:	74 06                	je     4c2 <printf+0xa4>
 4bc:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
 4c0:	75 1e                	jne    4e0 <printf+0xc2>
        printint(fd, *ap, 16, 0);
 4c2:	8b 45 e8             	mov    -0x18(%ebp),%eax
 4c5:	8b 00                	mov    (%eax),%eax
 4c7:	6a 00                	push   $0x0
 4c9:	6a 10                	push   $0x10
 4cb:	50                   	push   %eax
 4cc:	ff 75 08             	push   0x8(%ebp)
 4cf:	e8 99 fe ff ff       	call   36d <printint>
 4d4:	83 c4 10             	add    $0x10,%esp
        ap++;
 4d7:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 4db:	e9 ae 00 00 00       	jmp    58e <printf+0x170>
      } else if(c == 's'){
 4e0:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
 4e4:	75 43                	jne    529 <printf+0x10b>
        s = (char*)*ap;
 4e6:	8b 45 e8             	mov    -0x18(%ebp),%eax
 4e9:	8b 00                	mov    (%eax),%eax
 4eb:	89 45 f4             	mov    %eax,-0xc(%ebp)
        ap++;
 4ee:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
        if(s == 0)
 4f2:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 4f6:	75 25                	jne    51d <printf+0xff>
          s = "(null)";
 4f8:	c7 45 f4 e7 07 00 00 	movl   $0x7e7,-0xc(%ebp)
        while(*s != 0){
 4ff:	eb 1c                	jmp    51d <printf+0xff>
          putc(fd, *s);
 501:	8b 45 f4             	mov    -0xc(%ebp),%eax
 504:	0f b6 00             	movzbl (%eax),%eax
 507:	0f be c0             	movsbl %al,%eax
 50a:	83 ec 08             	sub    $0x8,%esp
 50d:	50                   	push   %eax
 50e:	ff 75 08             	push   0x8(%ebp)
 511:	e8 34 fe ff ff       	call   34a <putc>
 516:	83 c4 10             	add    $0x10,%esp
          s++;
 519:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
        while(*s != 0){
 51d:	8b 45 f4             	mov    -0xc(%ebp),%eax
 520:	0f b6 00             	movzbl (%eax),%eax
 523:	84 c0                	test   %al,%al
 525:	75 da                	jne    501 <printf+0xe3>
 527:	eb 65                	jmp    58e <printf+0x170>
        }
      } else if(c == 'c'){
 529:	83 7d e4 63          	cmpl   $0x63,-0x1c(%ebp)
 52d:	75 1d                	jne    54c <printf+0x12e>
        putc(fd, *ap);
 52f:	8b 45 e8             	mov    -0x18(%ebp),%eax
 532:	8b 00                	mov    (%eax),%eax
 534:	0f be c0             	movsbl %al,%eax
 537:	83 ec 08             	sub    $0x8,%esp
 53a:	50                   	push   %eax
 53b:	ff 75 08             	push   0x8(%ebp)
 53e:	e8 07 fe ff ff       	call   34a <putc>
 543:	83 c4 10             	add    $0x10,%esp
        ap++;
 546:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 54a:	eb 42                	jmp    58e <printf+0x170>
      } else if(c == '%'){
 54c:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 550:	75 17                	jne    569 <printf+0x14b>
        putc(fd, c);
 552:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 555:	0f be c0             	movsbl %al,%eax
 558:	83 ec 08             	sub    $0x8,%esp
 55b:	50                   	push   %eax
 55c:	ff 75 08             	push   0x8(%ebp)
 55f:	e8 e6 fd ff ff       	call   34a <putc>
 564:	83 c4 10             	add    $0x10,%esp
 567:	eb 25                	jmp    58e <printf+0x170>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 569:	83 ec 08             	sub    $0x8,%esp
 56c:	6a 25                	push   $0x25
 56e:	ff 75 08             	push   0x8(%ebp)
 571:	e8 d4 fd ff ff       	call   34a <putc>
 576:	83 c4 10             	add    $0x10,%esp
        putc(fd, c);
 579:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 57c:	0f be c0             	movsbl %al,%eax
 57f:	83 ec 08             	sub    $0x8,%esp
 582:	50                   	push   %eax
 583:	ff 75 08             	push   0x8(%ebp)
 586:	e8 bf fd ff ff       	call   34a <putc>
 58b:	83 c4 10             	add    $0x10,%esp
      }
      state = 0;
 58e:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  for(i = 0; fmt[i]; i++){
 595:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
 599:	8b 55 0c             	mov    0xc(%ebp),%edx
 59c:	8b 45 f0             	mov    -0x10(%ebp),%eax
 59f:	01 d0                	add    %edx,%eax
 5a1:	0f b6 00             	movzbl (%eax),%eax
 5a4:	84 c0                	test   %al,%al
 5a6:	0f 85 94 fe ff ff    	jne    440 <printf+0x22>
    }
  }
}
 5ac:	90                   	nop
 5ad:	90                   	nop
 5ae:	c9                   	leave  
 5af:	c3                   	ret    

000005b0 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 5b0:	55                   	push   %ebp
 5b1:	89 e5                	mov    %esp,%ebp
 5b3:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
 5b6:	8b 45 08             	mov    0x8(%ebp),%eax
 5b9:	83 e8 08             	sub    $0x8,%eax
 5bc:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 5bf:	a1 50 0a 00 00       	mov    0xa50,%eax
 5c4:	89 45 fc             	mov    %eax,-0x4(%ebp)
 5c7:	eb 24                	jmp    5ed <free+0x3d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 5c9:	8b 45 fc             	mov    -0x4(%ebp),%eax
 5cc:	8b 00                	mov    (%eax),%eax
 5ce:	39 45 fc             	cmp    %eax,-0x4(%ebp)
 5d1:	72 12                	jb     5e5 <free+0x35>
 5d3:	8b 45 f8             	mov    -0x8(%ebp),%eax
 5d6:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 5d9:	77 24                	ja     5ff <free+0x4f>
 5db:	8b 45 fc             	mov    -0x4(%ebp),%eax
 5de:	8b 00                	mov    (%eax),%eax
 5e0:	39 45 f8             	cmp    %eax,-0x8(%ebp)
 5e3:	72 1a                	jb     5ff <free+0x4f>
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 5e5:	8b 45 fc             	mov    -0x4(%ebp),%eax
 5e8:	8b 00                	mov    (%eax),%eax
 5ea:	89 45 fc             	mov    %eax,-0x4(%ebp)
 5ed:	8b 45 f8             	mov    -0x8(%ebp),%eax
 5f0:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 5f3:	76 d4                	jbe    5c9 <free+0x19>
 5f5:	8b 45 fc             	mov    -0x4(%ebp),%eax
 5f8:	8b 00                	mov    (%eax),%eax
 5fa:	39 45 f8             	cmp    %eax,-0x8(%ebp)
 5fd:	73 ca                	jae    5c9 <free+0x19>
      break;
  if(bp + bp->s.size == p->s.ptr){
 5ff:	8b 45 f8             	mov    -0x8(%ebp),%eax
 602:	8b 40 04             	mov    0x4(%eax),%eax
 605:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 60c:	8b 45 f8             	mov    -0x8(%ebp),%eax
 60f:	01 c2                	add    %eax,%edx
 611:	8b 45 fc             	mov    -0x4(%ebp),%eax
 614:	8b 00                	mov    (%eax),%eax
 616:	39 c2                	cmp    %eax,%edx
 618:	75 24                	jne    63e <free+0x8e>
    bp->s.size += p->s.ptr->s.size;
 61a:	8b 45 f8             	mov    -0x8(%ebp),%eax
 61d:	8b 50 04             	mov    0x4(%eax),%edx
 620:	8b 45 fc             	mov    -0x4(%ebp),%eax
 623:	8b 00                	mov    (%eax),%eax
 625:	8b 40 04             	mov    0x4(%eax),%eax
 628:	01 c2                	add    %eax,%edx
 62a:	8b 45 f8             	mov    -0x8(%ebp),%eax
 62d:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
 630:	8b 45 fc             	mov    -0x4(%ebp),%eax
 633:	8b 00                	mov    (%eax),%eax
 635:	8b 10                	mov    (%eax),%edx
 637:	8b 45 f8             	mov    -0x8(%ebp),%eax
 63a:	89 10                	mov    %edx,(%eax)
 63c:	eb 0a                	jmp    648 <free+0x98>
  } else
    bp->s.ptr = p->s.ptr;
 63e:	8b 45 fc             	mov    -0x4(%ebp),%eax
 641:	8b 10                	mov    (%eax),%edx
 643:	8b 45 f8             	mov    -0x8(%ebp),%eax
 646:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
 648:	8b 45 fc             	mov    -0x4(%ebp),%eax
 64b:	8b 40 04             	mov    0x4(%eax),%eax
 64e:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 655:	8b 45 fc             	mov    -0x4(%ebp),%eax
 658:	01 d0                	add    %edx,%eax
 65a:	39 45 f8             	cmp    %eax,-0x8(%ebp)
 65d:	75 20                	jne    67f <free+0xcf>
    p->s.size += bp->s.size;
 65f:	8b 45 fc             	mov    -0x4(%ebp),%eax
 662:	8b 50 04             	mov    0x4(%eax),%edx
 665:	8b 45 f8             	mov    -0x8(%ebp),%eax
 668:	8b 40 04             	mov    0x4(%eax),%eax
 66b:	01 c2                	add    %eax,%edx
 66d:	8b 45 fc             	mov    -0x4(%ebp),%eax
 670:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 673:	8b 45 f8             	mov    -0x8(%ebp),%eax
 676:	8b 10                	mov    (%eax),%edx
 678:	8b 45 fc             	mov    -0x4(%ebp),%eax
 67b:	89 10                	mov    %edx,(%eax)
 67d:	eb 08                	jmp    687 <free+0xd7>
  } else
    p->s.ptr = bp;
 67f:	8b 45 fc             	mov    -0x4(%ebp),%eax
 682:	8b 55 f8             	mov    -0x8(%ebp),%edx
 685:	89 10                	mov    %edx,(%eax)
  freep = p;
 687:	8b 45 fc             	mov    -0x4(%ebp),%eax
 68a:	a3 50 0a 00 00       	mov    %eax,0xa50
}
 68f:	90                   	nop
 690:	c9                   	leave  
 691:	c3                   	ret    

00000692 <morecore>:

static Header*
morecore(uint nu)
{
 692:	55                   	push   %ebp
 693:	89 e5                	mov    %esp,%ebp
 695:	83 ec 18             	sub    $0x18,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
 698:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
 69f:	77 07                	ja     6a8 <morecore+0x16>
    nu = 4096;
 6a1:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
 6a8:	8b 45 08             	mov    0x8(%ebp),%eax
 6ab:	c1 e0 03             	shl    $0x3,%eax
 6ae:	83 ec 0c             	sub    $0xc,%esp
 6b1:	50                   	push   %eax
 6b2:	e8 73 fc ff ff       	call   32a <sbrk>
 6b7:	83 c4 10             	add    $0x10,%esp
 6ba:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(p == (char*)-1)
 6bd:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
 6c1:	75 07                	jne    6ca <morecore+0x38>
    return 0;
 6c3:	b8 00 00 00 00       	mov    $0x0,%eax
 6c8:	eb 26                	jmp    6f0 <morecore+0x5e>
  hp = (Header*)p;
 6ca:	8b 45 f4             	mov    -0xc(%ebp),%eax
 6cd:	89 45 f0             	mov    %eax,-0x10(%ebp)
  hp->s.size = nu;
 6d0:	8b 45 f0             	mov    -0x10(%ebp),%eax
 6d3:	8b 55 08             	mov    0x8(%ebp),%edx
 6d6:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
 6d9:	8b 45 f0             	mov    -0x10(%ebp),%eax
 6dc:	83 c0 08             	add    $0x8,%eax
 6df:	83 ec 0c             	sub    $0xc,%esp
 6e2:	50                   	push   %eax
 6e3:	e8 c8 fe ff ff       	call   5b0 <free>
 6e8:	83 c4 10             	add    $0x10,%esp
  return freep;
 6eb:	a1 50 0a 00 00       	mov    0xa50,%eax
}
 6f0:	c9                   	leave  
 6f1:	c3                   	ret    

000006f2 <malloc>:

void*
malloc(uint nbytes)
{
 6f2:	55                   	push   %ebp
 6f3:	89 e5                	mov    %esp,%ebp
 6f5:	83 ec 18             	sub    $0x18,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 6f8:	8b 45 08             	mov    0x8(%ebp),%eax
 6fb:	83 c0 07             	add    $0x7,%eax
 6fe:	c1 e8 03             	shr    $0x3,%eax
 701:	83 c0 01             	add    $0x1,%eax
 704:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((prevp = freep) == 0){
 707:	a1 50 0a 00 00       	mov    0xa50,%eax
 70c:	89 45 f0             	mov    %eax,-0x10(%ebp)
 70f:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 713:	75 23                	jne    738 <malloc+0x46>
    base.s.ptr = freep = prevp = &base;
 715:	c7 45 f0 48 0a 00 00 	movl   $0xa48,-0x10(%ebp)
 71c:	8b 45 f0             	mov    -0x10(%ebp),%eax
 71f:	a3 50 0a 00 00       	mov    %eax,0xa50
 724:	a1 50 0a 00 00       	mov    0xa50,%eax
 729:	a3 48 0a 00 00       	mov    %eax,0xa48
    base.s.size = 0;
 72e:	c7 05 4c 0a 00 00 00 	movl   $0x0,0xa4c
 735:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 738:	8b 45 f0             	mov    -0x10(%ebp),%eax
 73b:	8b 00                	mov    (%eax),%eax
 73d:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
 740:	8b 45 f4             	mov    -0xc(%ebp),%eax
 743:	8b 40 04             	mov    0x4(%eax),%eax
 746:	39 45 ec             	cmp    %eax,-0x14(%ebp)
 749:	77 4d                	ja     798 <malloc+0xa6>
      if(p->s.size == nunits)
 74b:	8b 45 f4             	mov    -0xc(%ebp),%eax
 74e:	8b 40 04             	mov    0x4(%eax),%eax
 751:	39 45 ec             	cmp    %eax,-0x14(%ebp)
 754:	75 0c                	jne    762 <malloc+0x70>
        prevp->s.ptr = p->s.ptr;
 756:	8b 45 f4             	mov    -0xc(%ebp),%eax
 759:	8b 10                	mov    (%eax),%edx
 75b:	8b 45 f0             	mov    -0x10(%ebp),%eax
 75e:	89 10                	mov    %edx,(%eax)
 760:	eb 26                	jmp    788 <malloc+0x96>
      else {
        p->s.size -= nunits;
 762:	8b 45 f4             	mov    -0xc(%ebp),%eax
 765:	8b 40 04             	mov    0x4(%eax),%eax
 768:	2b 45 ec             	sub    -0x14(%ebp),%eax
 76b:	89 c2                	mov    %eax,%edx
 76d:	8b 45 f4             	mov    -0xc(%ebp),%eax
 770:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
 773:	8b 45 f4             	mov    -0xc(%ebp),%eax
 776:	8b 40 04             	mov    0x4(%eax),%eax
 779:	c1 e0 03             	shl    $0x3,%eax
 77c:	01 45 f4             	add    %eax,-0xc(%ebp)
        p->s.size = nunits;
 77f:	8b 45 f4             	mov    -0xc(%ebp),%eax
 782:	8b 55 ec             	mov    -0x14(%ebp),%edx
 785:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
 788:	8b 45 f0             	mov    -0x10(%ebp),%eax
 78b:	a3 50 0a 00 00       	mov    %eax,0xa50
      return (void*)(p + 1);
 790:	8b 45 f4             	mov    -0xc(%ebp),%eax
 793:	83 c0 08             	add    $0x8,%eax
 796:	eb 3b                	jmp    7d3 <malloc+0xe1>
    }
    if(p == freep)
 798:	a1 50 0a 00 00       	mov    0xa50,%eax
 79d:	39 45 f4             	cmp    %eax,-0xc(%ebp)
 7a0:	75 1e                	jne    7c0 <malloc+0xce>
      if((p = morecore(nunits)) == 0)
 7a2:	83 ec 0c             	sub    $0xc,%esp
 7a5:	ff 75 ec             	push   -0x14(%ebp)
 7a8:	e8 e5 fe ff ff       	call   692 <morecore>
 7ad:	83 c4 10             	add    $0x10,%esp
 7b0:	89 45 f4             	mov    %eax,-0xc(%ebp)
 7b3:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 7b7:	75 07                	jne    7c0 <malloc+0xce>
        return 0;
 7b9:	b8 00 00 00 00       	mov    $0x0,%eax
 7be:	eb 13                	jmp    7d3 <malloc+0xe1>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 7c0:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7c3:	89 45 f0             	mov    %eax,-0x10(%ebp)
 7c6:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7c9:	8b 00                	mov    (%eax),%eax
 7cb:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
 7ce:	e9 6d ff ff ff       	jmp    740 <malloc+0x4e>
  }
}
 7d3:	c9                   	leave  
 7d4:	c3                   	ret    
