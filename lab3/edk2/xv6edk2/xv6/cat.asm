
_cat:     file format elf32-i386


Disassembly of section .text:

00000000 <cat>:
   0:	55                   	push   %ebp
   1:	89 e5                	mov    %esp,%ebp
   3:	83 ec 18             	sub    $0x18,%esp
   6:	eb 31                	jmp    39 <cat+0x39>
   8:	83 ec 04             	sub    $0x4,%esp
   b:	ff 75 f4             	push   -0xc(%ebp)
   e:	68 80 0b 00 00       	push   $0xb80
  13:	6a 01                	push   $0x1
  15:	e8 88 03 00 00       	call   3a2 <write>
  1a:	83 c4 10             	add    $0x10,%esp
  1d:	39 45 f4             	cmp    %eax,-0xc(%ebp)
  20:	74 17                	je     39 <cat+0x39>
  22:	83 ec 08             	sub    $0x8,%esp
  25:	68 ad 08 00 00       	push   $0x8ad
  2a:	6a 01                	push   $0x1
  2c:	e8 c5 04 00 00       	call   4f6 <printf>
  31:	83 c4 10             	add    $0x10,%esp
  34:	e8 49 03 00 00       	call   382 <exit>
  39:	83 ec 04             	sub    $0x4,%esp
  3c:	68 00 02 00 00       	push   $0x200
  41:	68 80 0b 00 00       	push   $0xb80
  46:	ff 75 08             	push   0x8(%ebp)
  49:	e8 4c 03 00 00       	call   39a <read>
  4e:	83 c4 10             	add    $0x10,%esp
  51:	89 45 f4             	mov    %eax,-0xc(%ebp)
  54:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  58:	7f ae                	jg     8 <cat+0x8>
  5a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  5e:	79 17                	jns    77 <cat+0x77>
  60:	83 ec 08             	sub    $0x8,%esp
  63:	68 bf 08 00 00       	push   $0x8bf
  68:	6a 01                	push   $0x1
  6a:	e8 87 04 00 00       	call   4f6 <printf>
  6f:	83 c4 10             	add    $0x10,%esp
  72:	e8 0b 03 00 00       	call   382 <exit>
  77:	90                   	nop
  78:	c9                   	leave  
  79:	c3                   	ret    

0000007a <main>:
  7a:	8d 4c 24 04          	lea    0x4(%esp),%ecx
  7e:	83 e4 f0             	and    $0xfffffff0,%esp
  81:	ff 71 fc             	push   -0x4(%ecx)
  84:	55                   	push   %ebp
  85:	89 e5                	mov    %esp,%ebp
  87:	53                   	push   %ebx
  88:	51                   	push   %ecx
  89:	83 ec 10             	sub    $0x10,%esp
  8c:	89 cb                	mov    %ecx,%ebx
  8e:	83 3b 01             	cmpl   $0x1,(%ebx)
  91:	7f 12                	jg     a5 <main+0x2b>
  93:	83 ec 0c             	sub    $0xc,%esp
  96:	6a 00                	push   $0x0
  98:	e8 63 ff ff ff       	call   0 <cat>
  9d:	83 c4 10             	add    $0x10,%esp
  a0:	e8 dd 02 00 00       	call   382 <exit>
  a5:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
  ac:	eb 71                	jmp    11f <main+0xa5>
  ae:	8b 45 f4             	mov    -0xc(%ebp),%eax
  b1:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  b8:	8b 43 04             	mov    0x4(%ebx),%eax
  bb:	01 d0                	add    %edx,%eax
  bd:	8b 00                	mov    (%eax),%eax
  bf:	83 ec 08             	sub    $0x8,%esp
  c2:	6a 00                	push   $0x0
  c4:	50                   	push   %eax
  c5:	e8 f8 02 00 00       	call   3c2 <open>
  ca:	83 c4 10             	add    $0x10,%esp
  cd:	89 45 f0             	mov    %eax,-0x10(%ebp)
  d0:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  d4:	79 29                	jns    ff <main+0x85>
  d6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  d9:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  e0:	8b 43 04             	mov    0x4(%ebx),%eax
  e3:	01 d0                	add    %edx,%eax
  e5:	8b 00                	mov    (%eax),%eax
  e7:	83 ec 04             	sub    $0x4,%esp
  ea:	50                   	push   %eax
  eb:	68 d0 08 00 00       	push   $0x8d0
  f0:	6a 01                	push   $0x1
  f2:	e8 ff 03 00 00       	call   4f6 <printf>
  f7:	83 c4 10             	add    $0x10,%esp
  fa:	e8 83 02 00 00       	call   382 <exit>
  ff:	83 ec 0c             	sub    $0xc,%esp
 102:	ff 75 f0             	push   -0x10(%ebp)
 105:	e8 f6 fe ff ff       	call   0 <cat>
 10a:	83 c4 10             	add    $0x10,%esp
 10d:	83 ec 0c             	sub    $0xc,%esp
 110:	ff 75 f0             	push   -0x10(%ebp)
 113:	e8 92 02 00 00       	call   3aa <close>
 118:	83 c4 10             	add    $0x10,%esp
 11b:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
 11f:	8b 45 f4             	mov    -0xc(%ebp),%eax
 122:	3b 03                	cmp    (%ebx),%eax
 124:	7c 88                	jl     ae <main+0x34>
 126:	e8 57 02 00 00       	call   382 <exit>

0000012b <stosb>:
 12b:	55                   	push   %ebp
 12c:	89 e5                	mov    %esp,%ebp
 12e:	57                   	push   %edi
 12f:	53                   	push   %ebx
 130:	8b 4d 08             	mov    0x8(%ebp),%ecx
 133:	8b 55 10             	mov    0x10(%ebp),%edx
 136:	8b 45 0c             	mov    0xc(%ebp),%eax
 139:	89 cb                	mov    %ecx,%ebx
 13b:	89 df                	mov    %ebx,%edi
 13d:	89 d1                	mov    %edx,%ecx
 13f:	fc                   	cld    
 140:	f3 aa                	rep stos %al,%es:(%edi)
 142:	89 ca                	mov    %ecx,%edx
 144:	89 fb                	mov    %edi,%ebx
 146:	89 5d 08             	mov    %ebx,0x8(%ebp)
 149:	89 55 10             	mov    %edx,0x10(%ebp)
 14c:	90                   	nop
 14d:	5b                   	pop    %ebx
 14e:	5f                   	pop    %edi
 14f:	5d                   	pop    %ebp
 150:	c3                   	ret    

00000151 <strcpy>:
 151:	55                   	push   %ebp
 152:	89 e5                	mov    %esp,%ebp
 154:	83 ec 10             	sub    $0x10,%esp
 157:	8b 45 08             	mov    0x8(%ebp),%eax
 15a:	89 45 fc             	mov    %eax,-0x4(%ebp)
 15d:	90                   	nop
 15e:	8b 55 0c             	mov    0xc(%ebp),%edx
 161:	8d 42 01             	lea    0x1(%edx),%eax
 164:	89 45 0c             	mov    %eax,0xc(%ebp)
 167:	8b 45 08             	mov    0x8(%ebp),%eax
 16a:	8d 48 01             	lea    0x1(%eax),%ecx
 16d:	89 4d 08             	mov    %ecx,0x8(%ebp)
 170:	0f b6 12             	movzbl (%edx),%edx
 173:	88 10                	mov    %dl,(%eax)
 175:	0f b6 00             	movzbl (%eax),%eax
 178:	84 c0                	test   %al,%al
 17a:	75 e2                	jne    15e <strcpy+0xd>
 17c:	8b 45 fc             	mov    -0x4(%ebp),%eax
 17f:	c9                   	leave  
 180:	c3                   	ret    

00000181 <strcmp>:
 181:	55                   	push   %ebp
 182:	89 e5                	mov    %esp,%ebp
 184:	eb 08                	jmp    18e <strcmp+0xd>
 186:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 18a:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
 18e:	8b 45 08             	mov    0x8(%ebp),%eax
 191:	0f b6 00             	movzbl (%eax),%eax
 194:	84 c0                	test   %al,%al
 196:	74 10                	je     1a8 <strcmp+0x27>
 198:	8b 45 08             	mov    0x8(%ebp),%eax
 19b:	0f b6 10             	movzbl (%eax),%edx
 19e:	8b 45 0c             	mov    0xc(%ebp),%eax
 1a1:	0f b6 00             	movzbl (%eax),%eax
 1a4:	38 c2                	cmp    %al,%dl
 1a6:	74 de                	je     186 <strcmp+0x5>
 1a8:	8b 45 08             	mov    0x8(%ebp),%eax
 1ab:	0f b6 00             	movzbl (%eax),%eax
 1ae:	0f b6 d0             	movzbl %al,%edx
 1b1:	8b 45 0c             	mov    0xc(%ebp),%eax
 1b4:	0f b6 00             	movzbl (%eax),%eax
 1b7:	0f b6 c8             	movzbl %al,%ecx
 1ba:	89 d0                	mov    %edx,%eax
 1bc:	29 c8                	sub    %ecx,%eax
 1be:	5d                   	pop    %ebp
 1bf:	c3                   	ret    

000001c0 <strlen>:
 1c0:	55                   	push   %ebp
 1c1:	89 e5                	mov    %esp,%ebp
 1c3:	83 ec 10             	sub    $0x10,%esp
 1c6:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
 1cd:	eb 04                	jmp    1d3 <strlen+0x13>
 1cf:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 1d3:	8b 55 fc             	mov    -0x4(%ebp),%edx
 1d6:	8b 45 08             	mov    0x8(%ebp),%eax
 1d9:	01 d0                	add    %edx,%eax
 1db:	0f b6 00             	movzbl (%eax),%eax
 1de:	84 c0                	test   %al,%al
 1e0:	75 ed                	jne    1cf <strlen+0xf>
 1e2:	8b 45 fc             	mov    -0x4(%ebp),%eax
 1e5:	c9                   	leave  
 1e6:	c3                   	ret    

000001e7 <memset>:
 1e7:	55                   	push   %ebp
 1e8:	89 e5                	mov    %esp,%ebp
 1ea:	8b 45 10             	mov    0x10(%ebp),%eax
 1ed:	50                   	push   %eax
 1ee:	ff 75 0c             	push   0xc(%ebp)
 1f1:	ff 75 08             	push   0x8(%ebp)
 1f4:	e8 32 ff ff ff       	call   12b <stosb>
 1f9:	83 c4 0c             	add    $0xc,%esp
 1fc:	8b 45 08             	mov    0x8(%ebp),%eax
 1ff:	c9                   	leave  
 200:	c3                   	ret    

00000201 <strchr>:
 201:	55                   	push   %ebp
 202:	89 e5                	mov    %esp,%ebp
 204:	83 ec 04             	sub    $0x4,%esp
 207:	8b 45 0c             	mov    0xc(%ebp),%eax
 20a:	88 45 fc             	mov    %al,-0x4(%ebp)
 20d:	eb 14                	jmp    223 <strchr+0x22>
 20f:	8b 45 08             	mov    0x8(%ebp),%eax
 212:	0f b6 00             	movzbl (%eax),%eax
 215:	38 45 fc             	cmp    %al,-0x4(%ebp)
 218:	75 05                	jne    21f <strchr+0x1e>
 21a:	8b 45 08             	mov    0x8(%ebp),%eax
 21d:	eb 13                	jmp    232 <strchr+0x31>
 21f:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 223:	8b 45 08             	mov    0x8(%ebp),%eax
 226:	0f b6 00             	movzbl (%eax),%eax
 229:	84 c0                	test   %al,%al
 22b:	75 e2                	jne    20f <strchr+0xe>
 22d:	b8 00 00 00 00       	mov    $0x0,%eax
 232:	c9                   	leave  
 233:	c3                   	ret    

00000234 <gets>:
 234:	55                   	push   %ebp
 235:	89 e5                	mov    %esp,%ebp
 237:	83 ec 18             	sub    $0x18,%esp
 23a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
 241:	eb 42                	jmp    285 <gets+0x51>
 243:	83 ec 04             	sub    $0x4,%esp
 246:	6a 01                	push   $0x1
 248:	8d 45 ef             	lea    -0x11(%ebp),%eax
 24b:	50                   	push   %eax
 24c:	6a 00                	push   $0x0
 24e:	e8 47 01 00 00       	call   39a <read>
 253:	83 c4 10             	add    $0x10,%esp
 256:	89 45 f0             	mov    %eax,-0x10(%ebp)
 259:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 25d:	7e 33                	jle    292 <gets+0x5e>
 25f:	8b 45 f4             	mov    -0xc(%ebp),%eax
 262:	8d 50 01             	lea    0x1(%eax),%edx
 265:	89 55 f4             	mov    %edx,-0xc(%ebp)
 268:	89 c2                	mov    %eax,%edx
 26a:	8b 45 08             	mov    0x8(%ebp),%eax
 26d:	01 c2                	add    %eax,%edx
 26f:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 273:	88 02                	mov    %al,(%edx)
 275:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 279:	3c 0a                	cmp    $0xa,%al
 27b:	74 16                	je     293 <gets+0x5f>
 27d:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 281:	3c 0d                	cmp    $0xd,%al
 283:	74 0e                	je     293 <gets+0x5f>
 285:	8b 45 f4             	mov    -0xc(%ebp),%eax
 288:	83 c0 01             	add    $0x1,%eax
 28b:	39 45 0c             	cmp    %eax,0xc(%ebp)
 28e:	7f b3                	jg     243 <gets+0xf>
 290:	eb 01                	jmp    293 <gets+0x5f>
 292:	90                   	nop
 293:	8b 55 f4             	mov    -0xc(%ebp),%edx
 296:	8b 45 08             	mov    0x8(%ebp),%eax
 299:	01 d0                	add    %edx,%eax
 29b:	c6 00 00             	movb   $0x0,(%eax)
 29e:	8b 45 08             	mov    0x8(%ebp),%eax
 2a1:	c9                   	leave  
 2a2:	c3                   	ret    

000002a3 <stat>:
 2a3:	55                   	push   %ebp
 2a4:	89 e5                	mov    %esp,%ebp
 2a6:	83 ec 18             	sub    $0x18,%esp
 2a9:	83 ec 08             	sub    $0x8,%esp
 2ac:	6a 00                	push   $0x0
 2ae:	ff 75 08             	push   0x8(%ebp)
 2b1:	e8 0c 01 00 00       	call   3c2 <open>
 2b6:	83 c4 10             	add    $0x10,%esp
 2b9:	89 45 f4             	mov    %eax,-0xc(%ebp)
 2bc:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 2c0:	79 07                	jns    2c9 <stat+0x26>
 2c2:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 2c7:	eb 25                	jmp    2ee <stat+0x4b>
 2c9:	83 ec 08             	sub    $0x8,%esp
 2cc:	ff 75 0c             	push   0xc(%ebp)
 2cf:	ff 75 f4             	push   -0xc(%ebp)
 2d2:	e8 03 01 00 00       	call   3da <fstat>
 2d7:	83 c4 10             	add    $0x10,%esp
 2da:	89 45 f0             	mov    %eax,-0x10(%ebp)
 2dd:	83 ec 0c             	sub    $0xc,%esp
 2e0:	ff 75 f4             	push   -0xc(%ebp)
 2e3:	e8 c2 00 00 00       	call   3aa <close>
 2e8:	83 c4 10             	add    $0x10,%esp
 2eb:	8b 45 f0             	mov    -0x10(%ebp),%eax
 2ee:	c9                   	leave  
 2ef:	c3                   	ret    

000002f0 <atoi>:
 2f0:	55                   	push   %ebp
 2f1:	89 e5                	mov    %esp,%ebp
 2f3:	83 ec 10             	sub    $0x10,%esp
 2f6:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
 2fd:	eb 25                	jmp    324 <atoi+0x34>
 2ff:	8b 55 fc             	mov    -0x4(%ebp),%edx
 302:	89 d0                	mov    %edx,%eax
 304:	c1 e0 02             	shl    $0x2,%eax
 307:	01 d0                	add    %edx,%eax
 309:	01 c0                	add    %eax,%eax
 30b:	89 c1                	mov    %eax,%ecx
 30d:	8b 45 08             	mov    0x8(%ebp),%eax
 310:	8d 50 01             	lea    0x1(%eax),%edx
 313:	89 55 08             	mov    %edx,0x8(%ebp)
 316:	0f b6 00             	movzbl (%eax),%eax
 319:	0f be c0             	movsbl %al,%eax
 31c:	01 c8                	add    %ecx,%eax
 31e:	83 e8 30             	sub    $0x30,%eax
 321:	89 45 fc             	mov    %eax,-0x4(%ebp)
 324:	8b 45 08             	mov    0x8(%ebp),%eax
 327:	0f b6 00             	movzbl (%eax),%eax
 32a:	3c 2f                	cmp    $0x2f,%al
 32c:	7e 0a                	jle    338 <atoi+0x48>
 32e:	8b 45 08             	mov    0x8(%ebp),%eax
 331:	0f b6 00             	movzbl (%eax),%eax
 334:	3c 39                	cmp    $0x39,%al
 336:	7e c7                	jle    2ff <atoi+0xf>
 338:	8b 45 fc             	mov    -0x4(%ebp),%eax
 33b:	c9                   	leave  
 33c:	c3                   	ret    

0000033d <memmove>:
 33d:	55                   	push   %ebp
 33e:	89 e5                	mov    %esp,%ebp
 340:	83 ec 10             	sub    $0x10,%esp
 343:	8b 45 08             	mov    0x8(%ebp),%eax
 346:	89 45 fc             	mov    %eax,-0x4(%ebp)
 349:	8b 45 0c             	mov    0xc(%ebp),%eax
 34c:	89 45 f8             	mov    %eax,-0x8(%ebp)
 34f:	eb 17                	jmp    368 <memmove+0x2b>
 351:	8b 55 f8             	mov    -0x8(%ebp),%edx
 354:	8d 42 01             	lea    0x1(%edx),%eax
 357:	89 45 f8             	mov    %eax,-0x8(%ebp)
 35a:	8b 45 fc             	mov    -0x4(%ebp),%eax
 35d:	8d 48 01             	lea    0x1(%eax),%ecx
 360:	89 4d fc             	mov    %ecx,-0x4(%ebp)
 363:	0f b6 12             	movzbl (%edx),%edx
 366:	88 10                	mov    %dl,(%eax)
 368:	8b 45 10             	mov    0x10(%ebp),%eax
 36b:	8d 50 ff             	lea    -0x1(%eax),%edx
 36e:	89 55 10             	mov    %edx,0x10(%ebp)
 371:	85 c0                	test   %eax,%eax
 373:	7f dc                	jg     351 <memmove+0x14>
 375:	8b 45 08             	mov    0x8(%ebp),%eax
 378:	c9                   	leave  
 379:	c3                   	ret    

0000037a <fork>:
 37a:	b8 01 00 00 00       	mov    $0x1,%eax
 37f:	cd 40                	int    $0x40
 381:	c3                   	ret    

00000382 <exit>:
 382:	b8 02 00 00 00       	mov    $0x2,%eax
 387:	cd 40                	int    $0x40
 389:	c3                   	ret    

0000038a <wait>:
 38a:	b8 03 00 00 00       	mov    $0x3,%eax
 38f:	cd 40                	int    $0x40
 391:	c3                   	ret    

00000392 <pipe>:
 392:	b8 04 00 00 00       	mov    $0x4,%eax
 397:	cd 40                	int    $0x40
 399:	c3                   	ret    

0000039a <read>:
 39a:	b8 05 00 00 00       	mov    $0x5,%eax
 39f:	cd 40                	int    $0x40
 3a1:	c3                   	ret    

000003a2 <write>:
 3a2:	b8 10 00 00 00       	mov    $0x10,%eax
 3a7:	cd 40                	int    $0x40
 3a9:	c3                   	ret    

000003aa <close>:
 3aa:	b8 15 00 00 00       	mov    $0x15,%eax
 3af:	cd 40                	int    $0x40
 3b1:	c3                   	ret    

000003b2 <kill>:
 3b2:	b8 06 00 00 00       	mov    $0x6,%eax
 3b7:	cd 40                	int    $0x40
 3b9:	c3                   	ret    

000003ba <exec>:
 3ba:	b8 07 00 00 00       	mov    $0x7,%eax
 3bf:	cd 40                	int    $0x40
 3c1:	c3                   	ret    

000003c2 <open>:
 3c2:	b8 0f 00 00 00       	mov    $0xf,%eax
 3c7:	cd 40                	int    $0x40
 3c9:	c3                   	ret    

000003ca <mknod>:
 3ca:	b8 11 00 00 00       	mov    $0x11,%eax
 3cf:	cd 40                	int    $0x40
 3d1:	c3                   	ret    

000003d2 <unlink>:
 3d2:	b8 12 00 00 00       	mov    $0x12,%eax
 3d7:	cd 40                	int    $0x40
 3d9:	c3                   	ret    

000003da <fstat>:
 3da:	b8 08 00 00 00       	mov    $0x8,%eax
 3df:	cd 40                	int    $0x40
 3e1:	c3                   	ret    

000003e2 <link>:
 3e2:	b8 13 00 00 00       	mov    $0x13,%eax
 3e7:	cd 40                	int    $0x40
 3e9:	c3                   	ret    

000003ea <mkdir>:
 3ea:	b8 14 00 00 00       	mov    $0x14,%eax
 3ef:	cd 40                	int    $0x40
 3f1:	c3                   	ret    

000003f2 <chdir>:
 3f2:	b8 09 00 00 00       	mov    $0x9,%eax
 3f7:	cd 40                	int    $0x40
 3f9:	c3                   	ret    

000003fa <dup>:
 3fa:	b8 0a 00 00 00       	mov    $0xa,%eax
 3ff:	cd 40                	int    $0x40
 401:	c3                   	ret    

00000402 <getpid>:
 402:	b8 0b 00 00 00       	mov    $0xb,%eax
 407:	cd 40                	int    $0x40
 409:	c3                   	ret    

0000040a <sbrk>:
 40a:	b8 0c 00 00 00       	mov    $0xc,%eax
 40f:	cd 40                	int    $0x40
 411:	c3                   	ret    

00000412 <sleep>:
 412:	b8 0d 00 00 00       	mov    $0xd,%eax
 417:	cd 40                	int    $0x40
 419:	c3                   	ret    

0000041a <uptime>:
 41a:	b8 0e 00 00 00       	mov    $0xe,%eax
 41f:	cd 40                	int    $0x40
 421:	c3                   	ret    

00000422 <putc>:
 422:	55                   	push   %ebp
 423:	89 e5                	mov    %esp,%ebp
 425:	83 ec 18             	sub    $0x18,%esp
 428:	8b 45 0c             	mov    0xc(%ebp),%eax
 42b:	88 45 f4             	mov    %al,-0xc(%ebp)
 42e:	83 ec 04             	sub    $0x4,%esp
 431:	6a 01                	push   $0x1
 433:	8d 45 f4             	lea    -0xc(%ebp),%eax
 436:	50                   	push   %eax
 437:	ff 75 08             	push   0x8(%ebp)
 43a:	e8 63 ff ff ff       	call   3a2 <write>
 43f:	83 c4 10             	add    $0x10,%esp
 442:	90                   	nop
 443:	c9                   	leave  
 444:	c3                   	ret    

00000445 <printint>:
 445:	55                   	push   %ebp
 446:	89 e5                	mov    %esp,%ebp
 448:	83 ec 28             	sub    $0x28,%esp
 44b:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
 452:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
 456:	74 17                	je     46f <printint+0x2a>
 458:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
 45c:	79 11                	jns    46f <printint+0x2a>
 45e:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
 465:	8b 45 0c             	mov    0xc(%ebp),%eax
 468:	f7 d8                	neg    %eax
 46a:	89 45 ec             	mov    %eax,-0x14(%ebp)
 46d:	eb 06                	jmp    475 <printint+0x30>
 46f:	8b 45 0c             	mov    0xc(%ebp),%eax
 472:	89 45 ec             	mov    %eax,-0x14(%ebp)
 475:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
 47c:	8b 4d 10             	mov    0x10(%ebp),%ecx
 47f:	8b 45 ec             	mov    -0x14(%ebp),%eax
 482:	ba 00 00 00 00       	mov    $0x0,%edx
 487:	f7 f1                	div    %ecx
 489:	89 d1                	mov    %edx,%ecx
 48b:	8b 45 f4             	mov    -0xc(%ebp),%eax
 48e:	8d 50 01             	lea    0x1(%eax),%edx
 491:	89 55 f4             	mov    %edx,-0xc(%ebp)
 494:	0f b6 91 54 0b 00 00 	movzbl 0xb54(%ecx),%edx
 49b:	88 54 05 dc          	mov    %dl,-0x24(%ebp,%eax,1)
 49f:	8b 4d 10             	mov    0x10(%ebp),%ecx
 4a2:	8b 45 ec             	mov    -0x14(%ebp),%eax
 4a5:	ba 00 00 00 00       	mov    $0x0,%edx
 4aa:	f7 f1                	div    %ecx
 4ac:	89 45 ec             	mov    %eax,-0x14(%ebp)
 4af:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 4b3:	75 c7                	jne    47c <printint+0x37>
 4b5:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 4b9:	74 2d                	je     4e8 <printint+0xa3>
 4bb:	8b 45 f4             	mov    -0xc(%ebp),%eax
 4be:	8d 50 01             	lea    0x1(%eax),%edx
 4c1:	89 55 f4             	mov    %edx,-0xc(%ebp)
 4c4:	c6 44 05 dc 2d       	movb   $0x2d,-0x24(%ebp,%eax,1)
 4c9:	eb 1d                	jmp    4e8 <printint+0xa3>
 4cb:	8d 55 dc             	lea    -0x24(%ebp),%edx
 4ce:	8b 45 f4             	mov    -0xc(%ebp),%eax
 4d1:	01 d0                	add    %edx,%eax
 4d3:	0f b6 00             	movzbl (%eax),%eax
 4d6:	0f be c0             	movsbl %al,%eax
 4d9:	83 ec 08             	sub    $0x8,%esp
 4dc:	50                   	push   %eax
 4dd:	ff 75 08             	push   0x8(%ebp)
 4e0:	e8 3d ff ff ff       	call   422 <putc>
 4e5:	83 c4 10             	add    $0x10,%esp
 4e8:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
 4ec:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 4f0:	79 d9                	jns    4cb <printint+0x86>
 4f2:	90                   	nop
 4f3:	90                   	nop
 4f4:	c9                   	leave  
 4f5:	c3                   	ret    

000004f6 <printf>:
 4f6:	55                   	push   %ebp
 4f7:	89 e5                	mov    %esp,%ebp
 4f9:	83 ec 28             	sub    $0x28,%esp
 4fc:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
 503:	8d 45 0c             	lea    0xc(%ebp),%eax
 506:	83 c0 04             	add    $0x4,%eax
 509:	89 45 e8             	mov    %eax,-0x18(%ebp)
 50c:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
 513:	e9 59 01 00 00       	jmp    671 <printf+0x17b>
 518:	8b 55 0c             	mov    0xc(%ebp),%edx
 51b:	8b 45 f0             	mov    -0x10(%ebp),%eax
 51e:	01 d0                	add    %edx,%eax
 520:	0f b6 00             	movzbl (%eax),%eax
 523:	0f be c0             	movsbl %al,%eax
 526:	25 ff 00 00 00       	and    $0xff,%eax
 52b:	89 45 e4             	mov    %eax,-0x1c(%ebp)
 52e:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 532:	75 2c                	jne    560 <printf+0x6a>
 534:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 538:	75 0c                	jne    546 <printf+0x50>
 53a:	c7 45 ec 25 00 00 00 	movl   $0x25,-0x14(%ebp)
 541:	e9 27 01 00 00       	jmp    66d <printf+0x177>
 546:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 549:	0f be c0             	movsbl %al,%eax
 54c:	83 ec 08             	sub    $0x8,%esp
 54f:	50                   	push   %eax
 550:	ff 75 08             	push   0x8(%ebp)
 553:	e8 ca fe ff ff       	call   422 <putc>
 558:	83 c4 10             	add    $0x10,%esp
 55b:	e9 0d 01 00 00       	jmp    66d <printf+0x177>
 560:	83 7d ec 25          	cmpl   $0x25,-0x14(%ebp)
 564:	0f 85 03 01 00 00    	jne    66d <printf+0x177>
 56a:	83 7d e4 64          	cmpl   $0x64,-0x1c(%ebp)
 56e:	75 1e                	jne    58e <printf+0x98>
 570:	8b 45 e8             	mov    -0x18(%ebp),%eax
 573:	8b 00                	mov    (%eax),%eax
 575:	6a 01                	push   $0x1
 577:	6a 0a                	push   $0xa
 579:	50                   	push   %eax
 57a:	ff 75 08             	push   0x8(%ebp)
 57d:	e8 c3 fe ff ff       	call   445 <printint>
 582:	83 c4 10             	add    $0x10,%esp
 585:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 589:	e9 d8 00 00 00       	jmp    666 <printf+0x170>
 58e:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
 592:	74 06                	je     59a <printf+0xa4>
 594:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
 598:	75 1e                	jne    5b8 <printf+0xc2>
 59a:	8b 45 e8             	mov    -0x18(%ebp),%eax
 59d:	8b 00                	mov    (%eax),%eax
 59f:	6a 00                	push   $0x0
 5a1:	6a 10                	push   $0x10
 5a3:	50                   	push   %eax
 5a4:	ff 75 08             	push   0x8(%ebp)
 5a7:	e8 99 fe ff ff       	call   445 <printint>
 5ac:	83 c4 10             	add    $0x10,%esp
 5af:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 5b3:	e9 ae 00 00 00       	jmp    666 <printf+0x170>
 5b8:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
 5bc:	75 43                	jne    601 <printf+0x10b>
 5be:	8b 45 e8             	mov    -0x18(%ebp),%eax
 5c1:	8b 00                	mov    (%eax),%eax
 5c3:	89 45 f4             	mov    %eax,-0xc(%ebp)
 5c6:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 5ca:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 5ce:	75 25                	jne    5f5 <printf+0xff>
 5d0:	c7 45 f4 e5 08 00 00 	movl   $0x8e5,-0xc(%ebp)
 5d7:	eb 1c                	jmp    5f5 <printf+0xff>
 5d9:	8b 45 f4             	mov    -0xc(%ebp),%eax
 5dc:	0f b6 00             	movzbl (%eax),%eax
 5df:	0f be c0             	movsbl %al,%eax
 5e2:	83 ec 08             	sub    $0x8,%esp
 5e5:	50                   	push   %eax
 5e6:	ff 75 08             	push   0x8(%ebp)
 5e9:	e8 34 fe ff ff       	call   422 <putc>
 5ee:	83 c4 10             	add    $0x10,%esp
 5f1:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
 5f5:	8b 45 f4             	mov    -0xc(%ebp),%eax
 5f8:	0f b6 00             	movzbl (%eax),%eax
 5fb:	84 c0                	test   %al,%al
 5fd:	75 da                	jne    5d9 <printf+0xe3>
 5ff:	eb 65                	jmp    666 <printf+0x170>
 601:	83 7d e4 63          	cmpl   $0x63,-0x1c(%ebp)
 605:	75 1d                	jne    624 <printf+0x12e>
 607:	8b 45 e8             	mov    -0x18(%ebp),%eax
 60a:	8b 00                	mov    (%eax),%eax
 60c:	0f be c0             	movsbl %al,%eax
 60f:	83 ec 08             	sub    $0x8,%esp
 612:	50                   	push   %eax
 613:	ff 75 08             	push   0x8(%ebp)
 616:	e8 07 fe ff ff       	call   422 <putc>
 61b:	83 c4 10             	add    $0x10,%esp
 61e:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 622:	eb 42                	jmp    666 <printf+0x170>
 624:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 628:	75 17                	jne    641 <printf+0x14b>
 62a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 62d:	0f be c0             	movsbl %al,%eax
 630:	83 ec 08             	sub    $0x8,%esp
 633:	50                   	push   %eax
 634:	ff 75 08             	push   0x8(%ebp)
 637:	e8 e6 fd ff ff       	call   422 <putc>
 63c:	83 c4 10             	add    $0x10,%esp
 63f:	eb 25                	jmp    666 <printf+0x170>
 641:	83 ec 08             	sub    $0x8,%esp
 644:	6a 25                	push   $0x25
 646:	ff 75 08             	push   0x8(%ebp)
 649:	e8 d4 fd ff ff       	call   422 <putc>
 64e:	83 c4 10             	add    $0x10,%esp
 651:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 654:	0f be c0             	movsbl %al,%eax
 657:	83 ec 08             	sub    $0x8,%esp
 65a:	50                   	push   %eax
 65b:	ff 75 08             	push   0x8(%ebp)
 65e:	e8 bf fd ff ff       	call   422 <putc>
 663:	83 c4 10             	add    $0x10,%esp
 666:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
 66d:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
 671:	8b 55 0c             	mov    0xc(%ebp),%edx
 674:	8b 45 f0             	mov    -0x10(%ebp),%eax
 677:	01 d0                	add    %edx,%eax
 679:	0f b6 00             	movzbl (%eax),%eax
 67c:	84 c0                	test   %al,%al
 67e:	0f 85 94 fe ff ff    	jne    518 <printf+0x22>
 684:	90                   	nop
 685:	90                   	nop
 686:	c9                   	leave  
 687:	c3                   	ret    

00000688 <free>:
 688:	55                   	push   %ebp
 689:	89 e5                	mov    %esp,%ebp
 68b:	83 ec 10             	sub    $0x10,%esp
 68e:	8b 45 08             	mov    0x8(%ebp),%eax
 691:	83 e8 08             	sub    $0x8,%eax
 694:	89 45 f8             	mov    %eax,-0x8(%ebp)
 697:	a1 88 0d 00 00       	mov    0xd88,%eax
 69c:	89 45 fc             	mov    %eax,-0x4(%ebp)
 69f:	eb 24                	jmp    6c5 <free+0x3d>
 6a1:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6a4:	8b 00                	mov    (%eax),%eax
 6a6:	39 45 fc             	cmp    %eax,-0x4(%ebp)
 6a9:	72 12                	jb     6bd <free+0x35>
 6ab:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6ae:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 6b1:	77 24                	ja     6d7 <free+0x4f>
 6b3:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6b6:	8b 00                	mov    (%eax),%eax
 6b8:	39 45 f8             	cmp    %eax,-0x8(%ebp)
 6bb:	72 1a                	jb     6d7 <free+0x4f>
 6bd:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6c0:	8b 00                	mov    (%eax),%eax
 6c2:	89 45 fc             	mov    %eax,-0x4(%ebp)
 6c5:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6c8:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 6cb:	76 d4                	jbe    6a1 <free+0x19>
 6cd:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6d0:	8b 00                	mov    (%eax),%eax
 6d2:	39 45 f8             	cmp    %eax,-0x8(%ebp)
 6d5:	73 ca                	jae    6a1 <free+0x19>
 6d7:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6da:	8b 40 04             	mov    0x4(%eax),%eax
 6dd:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 6e4:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6e7:	01 c2                	add    %eax,%edx
 6e9:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6ec:	8b 00                	mov    (%eax),%eax
 6ee:	39 c2                	cmp    %eax,%edx
 6f0:	75 24                	jne    716 <free+0x8e>
 6f2:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6f5:	8b 50 04             	mov    0x4(%eax),%edx
 6f8:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6fb:	8b 00                	mov    (%eax),%eax
 6fd:	8b 40 04             	mov    0x4(%eax),%eax
 700:	01 c2                	add    %eax,%edx
 702:	8b 45 f8             	mov    -0x8(%ebp),%eax
 705:	89 50 04             	mov    %edx,0x4(%eax)
 708:	8b 45 fc             	mov    -0x4(%ebp),%eax
 70b:	8b 00                	mov    (%eax),%eax
 70d:	8b 10                	mov    (%eax),%edx
 70f:	8b 45 f8             	mov    -0x8(%ebp),%eax
 712:	89 10                	mov    %edx,(%eax)
 714:	eb 0a                	jmp    720 <free+0x98>
 716:	8b 45 fc             	mov    -0x4(%ebp),%eax
 719:	8b 10                	mov    (%eax),%edx
 71b:	8b 45 f8             	mov    -0x8(%ebp),%eax
 71e:	89 10                	mov    %edx,(%eax)
 720:	8b 45 fc             	mov    -0x4(%ebp),%eax
 723:	8b 40 04             	mov    0x4(%eax),%eax
 726:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 72d:	8b 45 fc             	mov    -0x4(%ebp),%eax
 730:	01 d0                	add    %edx,%eax
 732:	39 45 f8             	cmp    %eax,-0x8(%ebp)
 735:	75 20                	jne    757 <free+0xcf>
 737:	8b 45 fc             	mov    -0x4(%ebp),%eax
 73a:	8b 50 04             	mov    0x4(%eax),%edx
 73d:	8b 45 f8             	mov    -0x8(%ebp),%eax
 740:	8b 40 04             	mov    0x4(%eax),%eax
 743:	01 c2                	add    %eax,%edx
 745:	8b 45 fc             	mov    -0x4(%ebp),%eax
 748:	89 50 04             	mov    %edx,0x4(%eax)
 74b:	8b 45 f8             	mov    -0x8(%ebp),%eax
 74e:	8b 10                	mov    (%eax),%edx
 750:	8b 45 fc             	mov    -0x4(%ebp),%eax
 753:	89 10                	mov    %edx,(%eax)
 755:	eb 08                	jmp    75f <free+0xd7>
 757:	8b 45 fc             	mov    -0x4(%ebp),%eax
 75a:	8b 55 f8             	mov    -0x8(%ebp),%edx
 75d:	89 10                	mov    %edx,(%eax)
 75f:	8b 45 fc             	mov    -0x4(%ebp),%eax
 762:	a3 88 0d 00 00       	mov    %eax,0xd88
 767:	90                   	nop
 768:	c9                   	leave  
 769:	c3                   	ret    

0000076a <morecore>:
 76a:	55                   	push   %ebp
 76b:	89 e5                	mov    %esp,%ebp
 76d:	83 ec 18             	sub    $0x18,%esp
 770:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
 777:	77 07                	ja     780 <morecore+0x16>
 779:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
 780:	8b 45 08             	mov    0x8(%ebp),%eax
 783:	c1 e0 03             	shl    $0x3,%eax
 786:	83 ec 0c             	sub    $0xc,%esp
 789:	50                   	push   %eax
 78a:	e8 7b fc ff ff       	call   40a <sbrk>
 78f:	83 c4 10             	add    $0x10,%esp
 792:	89 45 f4             	mov    %eax,-0xc(%ebp)
 795:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
 799:	75 07                	jne    7a2 <morecore+0x38>
 79b:	b8 00 00 00 00       	mov    $0x0,%eax
 7a0:	eb 26                	jmp    7c8 <morecore+0x5e>
 7a2:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7a5:	89 45 f0             	mov    %eax,-0x10(%ebp)
 7a8:	8b 45 f0             	mov    -0x10(%ebp),%eax
 7ab:	8b 55 08             	mov    0x8(%ebp),%edx
 7ae:	89 50 04             	mov    %edx,0x4(%eax)
 7b1:	8b 45 f0             	mov    -0x10(%ebp),%eax
 7b4:	83 c0 08             	add    $0x8,%eax
 7b7:	83 ec 0c             	sub    $0xc,%esp
 7ba:	50                   	push   %eax
 7bb:	e8 c8 fe ff ff       	call   688 <free>
 7c0:	83 c4 10             	add    $0x10,%esp
 7c3:	a1 88 0d 00 00       	mov    0xd88,%eax
 7c8:	c9                   	leave  
 7c9:	c3                   	ret    

000007ca <malloc>:
 7ca:	55                   	push   %ebp
 7cb:	89 e5                	mov    %esp,%ebp
 7cd:	83 ec 18             	sub    $0x18,%esp
 7d0:	8b 45 08             	mov    0x8(%ebp),%eax
 7d3:	83 c0 07             	add    $0x7,%eax
 7d6:	c1 e8 03             	shr    $0x3,%eax
 7d9:	83 c0 01             	add    $0x1,%eax
 7dc:	89 45 ec             	mov    %eax,-0x14(%ebp)
 7df:	a1 88 0d 00 00       	mov    0xd88,%eax
 7e4:	89 45 f0             	mov    %eax,-0x10(%ebp)
 7e7:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 7eb:	75 23                	jne    810 <malloc+0x46>
 7ed:	c7 45 f0 80 0d 00 00 	movl   $0xd80,-0x10(%ebp)
 7f4:	8b 45 f0             	mov    -0x10(%ebp),%eax
 7f7:	a3 88 0d 00 00       	mov    %eax,0xd88
 7fc:	a1 88 0d 00 00       	mov    0xd88,%eax
 801:	a3 80 0d 00 00       	mov    %eax,0xd80
 806:	c7 05 84 0d 00 00 00 	movl   $0x0,0xd84
 80d:	00 00 00 
 810:	8b 45 f0             	mov    -0x10(%ebp),%eax
 813:	8b 00                	mov    (%eax),%eax
 815:	89 45 f4             	mov    %eax,-0xc(%ebp)
 818:	8b 45 f4             	mov    -0xc(%ebp),%eax
 81b:	8b 40 04             	mov    0x4(%eax),%eax
 81e:	39 45 ec             	cmp    %eax,-0x14(%ebp)
 821:	77 4d                	ja     870 <malloc+0xa6>
 823:	8b 45 f4             	mov    -0xc(%ebp),%eax
 826:	8b 40 04             	mov    0x4(%eax),%eax
 829:	39 45 ec             	cmp    %eax,-0x14(%ebp)
 82c:	75 0c                	jne    83a <malloc+0x70>
 82e:	8b 45 f4             	mov    -0xc(%ebp),%eax
 831:	8b 10                	mov    (%eax),%edx
 833:	8b 45 f0             	mov    -0x10(%ebp),%eax
 836:	89 10                	mov    %edx,(%eax)
 838:	eb 26                	jmp    860 <malloc+0x96>
 83a:	8b 45 f4             	mov    -0xc(%ebp),%eax
 83d:	8b 40 04             	mov    0x4(%eax),%eax
 840:	2b 45 ec             	sub    -0x14(%ebp),%eax
 843:	89 c2                	mov    %eax,%edx
 845:	8b 45 f4             	mov    -0xc(%ebp),%eax
 848:	89 50 04             	mov    %edx,0x4(%eax)
 84b:	8b 45 f4             	mov    -0xc(%ebp),%eax
 84e:	8b 40 04             	mov    0x4(%eax),%eax
 851:	c1 e0 03             	shl    $0x3,%eax
 854:	01 45 f4             	add    %eax,-0xc(%ebp)
 857:	8b 45 f4             	mov    -0xc(%ebp),%eax
 85a:	8b 55 ec             	mov    -0x14(%ebp),%edx
 85d:	89 50 04             	mov    %edx,0x4(%eax)
 860:	8b 45 f0             	mov    -0x10(%ebp),%eax
 863:	a3 88 0d 00 00       	mov    %eax,0xd88
 868:	8b 45 f4             	mov    -0xc(%ebp),%eax
 86b:	83 c0 08             	add    $0x8,%eax
 86e:	eb 3b                	jmp    8ab <malloc+0xe1>
 870:	a1 88 0d 00 00       	mov    0xd88,%eax
 875:	39 45 f4             	cmp    %eax,-0xc(%ebp)
 878:	75 1e                	jne    898 <malloc+0xce>
 87a:	83 ec 0c             	sub    $0xc,%esp
 87d:	ff 75 ec             	push   -0x14(%ebp)
 880:	e8 e5 fe ff ff       	call   76a <morecore>
 885:	83 c4 10             	add    $0x10,%esp
 888:	89 45 f4             	mov    %eax,-0xc(%ebp)
 88b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 88f:	75 07                	jne    898 <malloc+0xce>
 891:	b8 00 00 00 00       	mov    $0x0,%eax
 896:	eb 13                	jmp    8ab <malloc+0xe1>
 898:	8b 45 f4             	mov    -0xc(%ebp),%eax
 89b:	89 45 f0             	mov    %eax,-0x10(%ebp)
 89e:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8a1:	8b 00                	mov    (%eax),%eax
 8a3:	89 45 f4             	mov    %eax,-0xc(%ebp)
 8a6:	e9 6d ff ff ff       	jmp    818 <malloc+0x4e>
 8ab:	c9                   	leave  
 8ac:	c3                   	ret    
