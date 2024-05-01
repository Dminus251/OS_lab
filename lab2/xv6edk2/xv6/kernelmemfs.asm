
kernelmemfs:     file format elf32-i386


Disassembly of section .text:

80100000 <multiboot_header>:
80100000:	02 b0 ad 1b 00 00    	add    0x1bad(%eax),%dh
80100006:	00 00                	add    %al,(%eax)
80100008:	fe 4f 52             	decb   0x52(%edi)
8010000b:	e4                   	.byte 0xe4

8010000c <wait_main>:
8010000c:	00 00                	add    %al,(%eax)
	...

80100010 <entry>:
80100010:	66 b8 10 00          	mov    $0x10,%ax
80100014:	8e d8                	mov    %eax,%ds
80100016:	8e c0                	mov    %eax,%es
80100018:	8e d0                	mov    %eax,%ss
8010001a:	66 b8 00 00          	mov    $0x0,%ax
8010001e:	8e e0                	mov    %eax,%fs
80100020:	8e e8                	mov    %eax,%gs
80100022:	0f 20 c0             	mov    %cr0,%eax
80100025:	25 ff ff ff 7f       	and    $0x7fffffff,%eax
8010002a:	0f 22 c0             	mov    %eax,%cr0
8010002d:	b8 00 e0 10 00       	mov    $0x10e000,%eax
80100032:	0f 22 d8             	mov    %eax,%cr3
80100035:	b9 80 00 00 c0       	mov    $0xc0000080,%ecx
8010003a:	0f 32                	rdmsr  
8010003c:	25 ff fe ff ff       	and    $0xfffffeff,%eax
80100041:	0f 30                	wrmsr  
80100043:	0f 20 e0             	mov    %cr4,%eax
80100046:	83 c8 10             	or     $0x10,%eax
80100049:	83 e0 df             	and    $0xffffffdf,%eax
8010004c:	0f 22 e0             	mov    %eax,%cr4
8010004f:	0f 20 c0             	mov    %cr0,%eax
80100052:	0d 01 00 01 80       	or     $0x80010001,%eax
80100057:	0f 22 c0             	mov    %eax,%cr0
8010005a:	bc 80 80 19 80       	mov    $0x80198080,%esp
8010005f:	ba 65 33 10 80       	mov    $0x80103365,%edx
80100064:	ff e2                	jmp    *%edx

80100066 <binit>:
80100066:	55                   	push   %ebp
80100067:	89 e5                	mov    %esp,%ebp
80100069:	83 ec 18             	sub    $0x18,%esp
8010006c:	83 ec 08             	sub    $0x8,%esp
8010006f:	68 60 a2 10 80       	push   $0x8010a260
80100074:	68 00 d0 18 80       	push   $0x8018d000
80100079:	e8 c8 48 00 00       	call   80104946 <initlock>
8010007e:	83 c4 10             	add    $0x10,%esp
80100081:	c7 05 4c 17 19 80 fc 	movl   $0x801916fc,0x8019174c
80100088:	16 19 80 
8010008b:	c7 05 50 17 19 80 fc 	movl   $0x801916fc,0x80191750
80100092:	16 19 80 
80100095:	c7 45 f4 34 d0 18 80 	movl   $0x8018d034,-0xc(%ebp)
8010009c:	eb 47                	jmp    801000e5 <binit+0x7f>
8010009e:	8b 15 50 17 19 80    	mov    0x80191750,%edx
801000a4:	8b 45 f4             	mov    -0xc(%ebp),%eax
801000a7:	89 50 54             	mov    %edx,0x54(%eax)
801000aa:	8b 45 f4             	mov    -0xc(%ebp),%eax
801000ad:	c7 40 50 fc 16 19 80 	movl   $0x801916fc,0x50(%eax)
801000b4:	8b 45 f4             	mov    -0xc(%ebp),%eax
801000b7:	83 c0 0c             	add    $0xc,%eax
801000ba:	83 ec 08             	sub    $0x8,%esp
801000bd:	68 67 a2 10 80       	push   $0x8010a267
801000c2:	50                   	push   %eax
801000c3:	e8 21 47 00 00       	call   801047e9 <initsleeplock>
801000c8:	83 c4 10             	add    $0x10,%esp
801000cb:	a1 50 17 19 80       	mov    0x80191750,%eax
801000d0:	8b 55 f4             	mov    -0xc(%ebp),%edx
801000d3:	89 50 50             	mov    %edx,0x50(%eax)
801000d6:	8b 45 f4             	mov    -0xc(%ebp),%eax
801000d9:	a3 50 17 19 80       	mov    %eax,0x80191750
801000de:	81 45 f4 5c 02 00 00 	addl   $0x25c,-0xc(%ebp)
801000e5:	b8 fc 16 19 80       	mov    $0x801916fc,%eax
801000ea:	39 45 f4             	cmp    %eax,-0xc(%ebp)
801000ed:	72 af                	jb     8010009e <binit+0x38>
801000ef:	90                   	nop
801000f0:	90                   	nop
801000f1:	c9                   	leave  
801000f2:	c3                   	ret    

801000f3 <bget>:
801000f3:	55                   	push   %ebp
801000f4:	89 e5                	mov    %esp,%ebp
801000f6:	83 ec 18             	sub    $0x18,%esp
801000f9:	83 ec 0c             	sub    $0xc,%esp
801000fc:	68 00 d0 18 80       	push   $0x8018d000
80100101:	e8 62 48 00 00       	call   80104968 <acquire>
80100106:	83 c4 10             	add    $0x10,%esp
80100109:	a1 50 17 19 80       	mov    0x80191750,%eax
8010010e:	89 45 f4             	mov    %eax,-0xc(%ebp)
80100111:	eb 58                	jmp    8010016b <bget+0x78>
80100113:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100116:	8b 40 04             	mov    0x4(%eax),%eax
80100119:	39 45 08             	cmp    %eax,0x8(%ebp)
8010011c:	75 44                	jne    80100162 <bget+0x6f>
8010011e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100121:	8b 40 08             	mov    0x8(%eax),%eax
80100124:	39 45 0c             	cmp    %eax,0xc(%ebp)
80100127:	75 39                	jne    80100162 <bget+0x6f>
80100129:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010012c:	8b 40 4c             	mov    0x4c(%eax),%eax
8010012f:	8d 50 01             	lea    0x1(%eax),%edx
80100132:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100135:	89 50 4c             	mov    %edx,0x4c(%eax)
80100138:	83 ec 0c             	sub    $0xc,%esp
8010013b:	68 00 d0 18 80       	push   $0x8018d000
80100140:	e8 91 48 00 00       	call   801049d6 <release>
80100145:	83 c4 10             	add    $0x10,%esp
80100148:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010014b:	83 c0 0c             	add    $0xc,%eax
8010014e:	83 ec 0c             	sub    $0xc,%esp
80100151:	50                   	push   %eax
80100152:	e8 ce 46 00 00       	call   80104825 <acquiresleep>
80100157:	83 c4 10             	add    $0x10,%esp
8010015a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010015d:	e9 9d 00 00 00       	jmp    801001ff <bget+0x10c>
80100162:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100165:	8b 40 54             	mov    0x54(%eax),%eax
80100168:	89 45 f4             	mov    %eax,-0xc(%ebp)
8010016b:	81 7d f4 fc 16 19 80 	cmpl   $0x801916fc,-0xc(%ebp)
80100172:	75 9f                	jne    80100113 <bget+0x20>
80100174:	a1 4c 17 19 80       	mov    0x8019174c,%eax
80100179:	89 45 f4             	mov    %eax,-0xc(%ebp)
8010017c:	eb 6b                	jmp    801001e9 <bget+0xf6>
8010017e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100181:	8b 40 4c             	mov    0x4c(%eax),%eax
80100184:	85 c0                	test   %eax,%eax
80100186:	75 58                	jne    801001e0 <bget+0xed>
80100188:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010018b:	8b 00                	mov    (%eax),%eax
8010018d:	83 e0 04             	and    $0x4,%eax
80100190:	85 c0                	test   %eax,%eax
80100192:	75 4c                	jne    801001e0 <bget+0xed>
80100194:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100197:	8b 55 08             	mov    0x8(%ebp),%edx
8010019a:	89 50 04             	mov    %edx,0x4(%eax)
8010019d:	8b 45 f4             	mov    -0xc(%ebp),%eax
801001a0:	8b 55 0c             	mov    0xc(%ebp),%edx
801001a3:	89 50 08             	mov    %edx,0x8(%eax)
801001a6:	8b 45 f4             	mov    -0xc(%ebp),%eax
801001a9:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
801001af:	8b 45 f4             	mov    -0xc(%ebp),%eax
801001b2:	c7 40 4c 01 00 00 00 	movl   $0x1,0x4c(%eax)
801001b9:	83 ec 0c             	sub    $0xc,%esp
801001bc:	68 00 d0 18 80       	push   $0x8018d000
801001c1:	e8 10 48 00 00       	call   801049d6 <release>
801001c6:	83 c4 10             	add    $0x10,%esp
801001c9:	8b 45 f4             	mov    -0xc(%ebp),%eax
801001cc:	83 c0 0c             	add    $0xc,%eax
801001cf:	83 ec 0c             	sub    $0xc,%esp
801001d2:	50                   	push   %eax
801001d3:	e8 4d 46 00 00       	call   80104825 <acquiresleep>
801001d8:	83 c4 10             	add    $0x10,%esp
801001db:	8b 45 f4             	mov    -0xc(%ebp),%eax
801001de:	eb 1f                	jmp    801001ff <bget+0x10c>
801001e0:	8b 45 f4             	mov    -0xc(%ebp),%eax
801001e3:	8b 40 50             	mov    0x50(%eax),%eax
801001e6:	89 45 f4             	mov    %eax,-0xc(%ebp)
801001e9:	81 7d f4 fc 16 19 80 	cmpl   $0x801916fc,-0xc(%ebp)
801001f0:	75 8c                	jne    8010017e <bget+0x8b>
801001f2:	83 ec 0c             	sub    $0xc,%esp
801001f5:	68 6e a2 10 80       	push   $0x8010a26e
801001fa:	e8 aa 03 00 00       	call   801005a9 <panic>
801001ff:	c9                   	leave  
80100200:	c3                   	ret    

80100201 <bread>:
80100201:	55                   	push   %ebp
80100202:	89 e5                	mov    %esp,%ebp
80100204:	83 ec 18             	sub    $0x18,%esp
80100207:	83 ec 08             	sub    $0x8,%esp
8010020a:	ff 75 0c             	push   0xc(%ebp)
8010020d:	ff 75 08             	push   0x8(%ebp)
80100210:	e8 de fe ff ff       	call   801000f3 <bget>
80100215:	83 c4 10             	add    $0x10,%esp
80100218:	89 45 f4             	mov    %eax,-0xc(%ebp)
8010021b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010021e:	8b 00                	mov    (%eax),%eax
80100220:	83 e0 02             	and    $0x2,%eax
80100223:	85 c0                	test   %eax,%eax
80100225:	75 0e                	jne    80100235 <bread+0x34>
80100227:	83 ec 0c             	sub    $0xc,%esp
8010022a:	ff 75 f4             	push   -0xc(%ebp)
8010022d:	e8 2e 9f 00 00       	call   8010a160 <iderw>
80100232:	83 c4 10             	add    $0x10,%esp
80100235:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100238:	c9                   	leave  
80100239:	c3                   	ret    

8010023a <bwrite>:
8010023a:	55                   	push   %ebp
8010023b:	89 e5                	mov    %esp,%ebp
8010023d:	83 ec 08             	sub    $0x8,%esp
80100240:	8b 45 08             	mov    0x8(%ebp),%eax
80100243:	83 c0 0c             	add    $0xc,%eax
80100246:	83 ec 0c             	sub    $0xc,%esp
80100249:	50                   	push   %eax
8010024a:	e8 88 46 00 00       	call   801048d7 <holdingsleep>
8010024f:	83 c4 10             	add    $0x10,%esp
80100252:	85 c0                	test   %eax,%eax
80100254:	75 0d                	jne    80100263 <bwrite+0x29>
80100256:	83 ec 0c             	sub    $0xc,%esp
80100259:	68 7f a2 10 80       	push   $0x8010a27f
8010025e:	e8 46 03 00 00       	call   801005a9 <panic>
80100263:	8b 45 08             	mov    0x8(%ebp),%eax
80100266:	8b 00                	mov    (%eax),%eax
80100268:	83 c8 04             	or     $0x4,%eax
8010026b:	89 c2                	mov    %eax,%edx
8010026d:	8b 45 08             	mov    0x8(%ebp),%eax
80100270:	89 10                	mov    %edx,(%eax)
80100272:	83 ec 0c             	sub    $0xc,%esp
80100275:	ff 75 08             	push   0x8(%ebp)
80100278:	e8 e3 9e 00 00       	call   8010a160 <iderw>
8010027d:	83 c4 10             	add    $0x10,%esp
80100280:	90                   	nop
80100281:	c9                   	leave  
80100282:	c3                   	ret    

80100283 <brelse>:
80100283:	55                   	push   %ebp
80100284:	89 e5                	mov    %esp,%ebp
80100286:	83 ec 08             	sub    $0x8,%esp
80100289:	8b 45 08             	mov    0x8(%ebp),%eax
8010028c:	83 c0 0c             	add    $0xc,%eax
8010028f:	83 ec 0c             	sub    $0xc,%esp
80100292:	50                   	push   %eax
80100293:	e8 3f 46 00 00       	call   801048d7 <holdingsleep>
80100298:	83 c4 10             	add    $0x10,%esp
8010029b:	85 c0                	test   %eax,%eax
8010029d:	75 0d                	jne    801002ac <brelse+0x29>
8010029f:	83 ec 0c             	sub    $0xc,%esp
801002a2:	68 86 a2 10 80       	push   $0x8010a286
801002a7:	e8 fd 02 00 00       	call   801005a9 <panic>
801002ac:	8b 45 08             	mov    0x8(%ebp),%eax
801002af:	83 c0 0c             	add    $0xc,%eax
801002b2:	83 ec 0c             	sub    $0xc,%esp
801002b5:	50                   	push   %eax
801002b6:	e8 ce 45 00 00       	call   80104889 <releasesleep>
801002bb:	83 c4 10             	add    $0x10,%esp
801002be:	83 ec 0c             	sub    $0xc,%esp
801002c1:	68 00 d0 18 80       	push   $0x8018d000
801002c6:	e8 9d 46 00 00       	call   80104968 <acquire>
801002cb:	83 c4 10             	add    $0x10,%esp
801002ce:	8b 45 08             	mov    0x8(%ebp),%eax
801002d1:	8b 40 4c             	mov    0x4c(%eax),%eax
801002d4:	8d 50 ff             	lea    -0x1(%eax),%edx
801002d7:	8b 45 08             	mov    0x8(%ebp),%eax
801002da:	89 50 4c             	mov    %edx,0x4c(%eax)
801002dd:	8b 45 08             	mov    0x8(%ebp),%eax
801002e0:	8b 40 4c             	mov    0x4c(%eax),%eax
801002e3:	85 c0                	test   %eax,%eax
801002e5:	75 47                	jne    8010032e <brelse+0xab>
801002e7:	8b 45 08             	mov    0x8(%ebp),%eax
801002ea:	8b 40 54             	mov    0x54(%eax),%eax
801002ed:	8b 55 08             	mov    0x8(%ebp),%edx
801002f0:	8b 52 50             	mov    0x50(%edx),%edx
801002f3:	89 50 50             	mov    %edx,0x50(%eax)
801002f6:	8b 45 08             	mov    0x8(%ebp),%eax
801002f9:	8b 40 50             	mov    0x50(%eax),%eax
801002fc:	8b 55 08             	mov    0x8(%ebp),%edx
801002ff:	8b 52 54             	mov    0x54(%edx),%edx
80100302:	89 50 54             	mov    %edx,0x54(%eax)
80100305:	8b 15 50 17 19 80    	mov    0x80191750,%edx
8010030b:	8b 45 08             	mov    0x8(%ebp),%eax
8010030e:	89 50 54             	mov    %edx,0x54(%eax)
80100311:	8b 45 08             	mov    0x8(%ebp),%eax
80100314:	c7 40 50 fc 16 19 80 	movl   $0x801916fc,0x50(%eax)
8010031b:	a1 50 17 19 80       	mov    0x80191750,%eax
80100320:	8b 55 08             	mov    0x8(%ebp),%edx
80100323:	89 50 50             	mov    %edx,0x50(%eax)
80100326:	8b 45 08             	mov    0x8(%ebp),%eax
80100329:	a3 50 17 19 80       	mov    %eax,0x80191750
8010032e:	83 ec 0c             	sub    $0xc,%esp
80100331:	68 00 d0 18 80       	push   $0x8018d000
80100336:	e8 9b 46 00 00       	call   801049d6 <release>
8010033b:	83 c4 10             	add    $0x10,%esp
8010033e:	90                   	nop
8010033f:	c9                   	leave  
80100340:	c3                   	ret    

80100341 <cli>:
80100341:	55                   	push   %ebp
80100342:	89 e5                	mov    %esp,%ebp
80100344:	fa                   	cli    
80100345:	90                   	nop
80100346:	5d                   	pop    %ebp
80100347:	c3                   	ret    

80100348 <printint>:
80100348:	55                   	push   %ebp
80100349:	89 e5                	mov    %esp,%ebp
8010034b:	83 ec 28             	sub    $0x28,%esp
8010034e:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
80100352:	74 1c                	je     80100370 <printint+0x28>
80100354:	8b 45 08             	mov    0x8(%ebp),%eax
80100357:	c1 e8 1f             	shr    $0x1f,%eax
8010035a:	0f b6 c0             	movzbl %al,%eax
8010035d:	89 45 10             	mov    %eax,0x10(%ebp)
80100360:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
80100364:	74 0a                	je     80100370 <printint+0x28>
80100366:	8b 45 08             	mov    0x8(%ebp),%eax
80100369:	f7 d8                	neg    %eax
8010036b:	89 45 f0             	mov    %eax,-0x10(%ebp)
8010036e:	eb 06                	jmp    80100376 <printint+0x2e>
80100370:	8b 45 08             	mov    0x8(%ebp),%eax
80100373:	89 45 f0             	mov    %eax,-0x10(%ebp)
80100376:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
8010037d:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80100380:	8b 45 f0             	mov    -0x10(%ebp),%eax
80100383:	ba 00 00 00 00       	mov    $0x0,%edx
80100388:	f7 f1                	div    %ecx
8010038a:	89 d1                	mov    %edx,%ecx
8010038c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010038f:	8d 50 01             	lea    0x1(%eax),%edx
80100392:	89 55 f4             	mov    %edx,-0xc(%ebp)
80100395:	0f b6 91 04 d0 10 80 	movzbl -0x7fef2ffc(%ecx),%edx
8010039c:	88 54 05 e0          	mov    %dl,-0x20(%ebp,%eax,1)
801003a0:	8b 4d 0c             	mov    0xc(%ebp),%ecx
801003a3:	8b 45 f0             	mov    -0x10(%ebp),%eax
801003a6:	ba 00 00 00 00       	mov    $0x0,%edx
801003ab:	f7 f1                	div    %ecx
801003ad:	89 45 f0             	mov    %eax,-0x10(%ebp)
801003b0:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
801003b4:	75 c7                	jne    8010037d <printint+0x35>
801003b6:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
801003ba:	74 2a                	je     801003e6 <printint+0x9e>
801003bc:	8b 45 f4             	mov    -0xc(%ebp),%eax
801003bf:	8d 50 01             	lea    0x1(%eax),%edx
801003c2:	89 55 f4             	mov    %edx,-0xc(%ebp)
801003c5:	c6 44 05 e0 2d       	movb   $0x2d,-0x20(%ebp,%eax,1)
801003ca:	eb 1a                	jmp    801003e6 <printint+0x9e>
801003cc:	8d 55 e0             	lea    -0x20(%ebp),%edx
801003cf:	8b 45 f4             	mov    -0xc(%ebp),%eax
801003d2:	01 d0                	add    %edx,%eax
801003d4:	0f b6 00             	movzbl (%eax),%eax
801003d7:	0f be c0             	movsbl %al,%eax
801003da:	83 ec 0c             	sub    $0xc,%esp
801003dd:	50                   	push   %eax
801003de:	e8 8c 03 00 00       	call   8010076f <consputc>
801003e3:	83 c4 10             	add    $0x10,%esp
801003e6:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
801003ea:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801003ee:	79 dc                	jns    801003cc <printint+0x84>
801003f0:	90                   	nop
801003f1:	90                   	nop
801003f2:	c9                   	leave  
801003f3:	c3                   	ret    

801003f4 <cprintf>:
801003f4:	55                   	push   %ebp
801003f5:	89 e5                	mov    %esp,%ebp
801003f7:	83 ec 28             	sub    $0x28,%esp
801003fa:	a1 34 1a 19 80       	mov    0x80191a34,%eax
801003ff:	89 45 e8             	mov    %eax,-0x18(%ebp)
80100402:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
80100406:	74 10                	je     80100418 <cprintf+0x24>
80100408:	83 ec 0c             	sub    $0xc,%esp
8010040b:	68 00 1a 19 80       	push   $0x80191a00
80100410:	e8 53 45 00 00       	call   80104968 <acquire>
80100415:	83 c4 10             	add    $0x10,%esp
80100418:	8b 45 08             	mov    0x8(%ebp),%eax
8010041b:	85 c0                	test   %eax,%eax
8010041d:	75 0d                	jne    8010042c <cprintf+0x38>
8010041f:	83 ec 0c             	sub    $0xc,%esp
80100422:	68 8d a2 10 80       	push   $0x8010a28d
80100427:	e8 7d 01 00 00       	call   801005a9 <panic>
8010042c:	8d 45 0c             	lea    0xc(%ebp),%eax
8010042f:	89 45 f0             	mov    %eax,-0x10(%ebp)
80100432:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80100439:	e9 2f 01 00 00       	jmp    8010056d <cprintf+0x179>
8010043e:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
80100442:	74 13                	je     80100457 <cprintf+0x63>
80100444:	83 ec 0c             	sub    $0xc,%esp
80100447:	ff 75 e4             	push   -0x1c(%ebp)
8010044a:	e8 20 03 00 00       	call   8010076f <consputc>
8010044f:	83 c4 10             	add    $0x10,%esp
80100452:	e9 12 01 00 00       	jmp    80100569 <cprintf+0x175>
80100457:	8b 55 08             	mov    0x8(%ebp),%edx
8010045a:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
8010045e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100461:	01 d0                	add    %edx,%eax
80100463:	0f b6 00             	movzbl (%eax),%eax
80100466:	0f be c0             	movsbl %al,%eax
80100469:	25 ff 00 00 00       	and    $0xff,%eax
8010046e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80100471:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
80100475:	0f 84 14 01 00 00    	je     8010058f <cprintf+0x19b>
8010047b:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
8010047f:	74 5e                	je     801004df <cprintf+0xeb>
80100481:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
80100485:	0f 8f c2 00 00 00    	jg     8010054d <cprintf+0x159>
8010048b:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
8010048f:	74 6b                	je     801004fc <cprintf+0x108>
80100491:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
80100495:	0f 8f b2 00 00 00    	jg     8010054d <cprintf+0x159>
8010049b:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
8010049f:	74 3e                	je     801004df <cprintf+0xeb>
801004a1:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
801004a5:	0f 8f a2 00 00 00    	jg     8010054d <cprintf+0x159>
801004ab:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
801004af:	0f 84 89 00 00 00    	je     8010053e <cprintf+0x14a>
801004b5:	83 7d e4 64          	cmpl   $0x64,-0x1c(%ebp)
801004b9:	0f 85 8e 00 00 00    	jne    8010054d <cprintf+0x159>
801004bf:	8b 45 f0             	mov    -0x10(%ebp),%eax
801004c2:	8d 50 04             	lea    0x4(%eax),%edx
801004c5:	89 55 f0             	mov    %edx,-0x10(%ebp)
801004c8:	8b 00                	mov    (%eax),%eax
801004ca:	83 ec 04             	sub    $0x4,%esp
801004cd:	6a 01                	push   $0x1
801004cf:	6a 0a                	push   $0xa
801004d1:	50                   	push   %eax
801004d2:	e8 71 fe ff ff       	call   80100348 <printint>
801004d7:	83 c4 10             	add    $0x10,%esp
801004da:	e9 8a 00 00 00       	jmp    80100569 <cprintf+0x175>
801004df:	8b 45 f0             	mov    -0x10(%ebp),%eax
801004e2:	8d 50 04             	lea    0x4(%eax),%edx
801004e5:	89 55 f0             	mov    %edx,-0x10(%ebp)
801004e8:	8b 00                	mov    (%eax),%eax
801004ea:	83 ec 04             	sub    $0x4,%esp
801004ed:	6a 00                	push   $0x0
801004ef:	6a 10                	push   $0x10
801004f1:	50                   	push   %eax
801004f2:	e8 51 fe ff ff       	call   80100348 <printint>
801004f7:	83 c4 10             	add    $0x10,%esp
801004fa:	eb 6d                	jmp    80100569 <cprintf+0x175>
801004fc:	8b 45 f0             	mov    -0x10(%ebp),%eax
801004ff:	8d 50 04             	lea    0x4(%eax),%edx
80100502:	89 55 f0             	mov    %edx,-0x10(%ebp)
80100505:	8b 00                	mov    (%eax),%eax
80100507:	89 45 ec             	mov    %eax,-0x14(%ebp)
8010050a:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
8010050e:	75 22                	jne    80100532 <cprintf+0x13e>
80100510:	c7 45 ec 96 a2 10 80 	movl   $0x8010a296,-0x14(%ebp)
80100517:	eb 19                	jmp    80100532 <cprintf+0x13e>
80100519:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010051c:	0f b6 00             	movzbl (%eax),%eax
8010051f:	0f be c0             	movsbl %al,%eax
80100522:	83 ec 0c             	sub    $0xc,%esp
80100525:	50                   	push   %eax
80100526:	e8 44 02 00 00       	call   8010076f <consputc>
8010052b:	83 c4 10             	add    $0x10,%esp
8010052e:	83 45 ec 01          	addl   $0x1,-0x14(%ebp)
80100532:	8b 45 ec             	mov    -0x14(%ebp),%eax
80100535:	0f b6 00             	movzbl (%eax),%eax
80100538:	84 c0                	test   %al,%al
8010053a:	75 dd                	jne    80100519 <cprintf+0x125>
8010053c:	eb 2b                	jmp    80100569 <cprintf+0x175>
8010053e:	83 ec 0c             	sub    $0xc,%esp
80100541:	6a 25                	push   $0x25
80100543:	e8 27 02 00 00       	call   8010076f <consputc>
80100548:	83 c4 10             	add    $0x10,%esp
8010054b:	eb 1c                	jmp    80100569 <cprintf+0x175>
8010054d:	83 ec 0c             	sub    $0xc,%esp
80100550:	6a 25                	push   $0x25
80100552:	e8 18 02 00 00       	call   8010076f <consputc>
80100557:	83 c4 10             	add    $0x10,%esp
8010055a:	83 ec 0c             	sub    $0xc,%esp
8010055d:	ff 75 e4             	push   -0x1c(%ebp)
80100560:	e8 0a 02 00 00       	call   8010076f <consputc>
80100565:	83 c4 10             	add    $0x10,%esp
80100568:	90                   	nop
80100569:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
8010056d:	8b 55 08             	mov    0x8(%ebp),%edx
80100570:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100573:	01 d0                	add    %edx,%eax
80100575:	0f b6 00             	movzbl (%eax),%eax
80100578:	0f be c0             	movsbl %al,%eax
8010057b:	25 ff 00 00 00       	and    $0xff,%eax
80100580:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80100583:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
80100587:	0f 85 b1 fe ff ff    	jne    8010043e <cprintf+0x4a>
8010058d:	eb 01                	jmp    80100590 <cprintf+0x19c>
8010058f:	90                   	nop
80100590:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
80100594:	74 10                	je     801005a6 <cprintf+0x1b2>
80100596:	83 ec 0c             	sub    $0xc,%esp
80100599:	68 00 1a 19 80       	push   $0x80191a00
8010059e:	e8 33 44 00 00       	call   801049d6 <release>
801005a3:	83 c4 10             	add    $0x10,%esp
801005a6:	90                   	nop
801005a7:	c9                   	leave  
801005a8:	c3                   	ret    

801005a9 <panic>:
801005a9:	55                   	push   %ebp
801005aa:	89 e5                	mov    %esp,%ebp
801005ac:	83 ec 38             	sub    $0x38,%esp
801005af:	e8 8d fd ff ff       	call   80100341 <cli>
801005b4:	c7 05 34 1a 19 80 00 	movl   $0x0,0x80191a34
801005bb:	00 00 00 
801005be:	e8 37 25 00 00       	call   80102afa <lapicid>
801005c3:	83 ec 08             	sub    $0x8,%esp
801005c6:	50                   	push   %eax
801005c7:	68 9d a2 10 80       	push   $0x8010a29d
801005cc:	e8 23 fe ff ff       	call   801003f4 <cprintf>
801005d1:	83 c4 10             	add    $0x10,%esp
801005d4:	8b 45 08             	mov    0x8(%ebp),%eax
801005d7:	83 ec 0c             	sub    $0xc,%esp
801005da:	50                   	push   %eax
801005db:	e8 14 fe ff ff       	call   801003f4 <cprintf>
801005e0:	83 c4 10             	add    $0x10,%esp
801005e3:	83 ec 0c             	sub    $0xc,%esp
801005e6:	68 b1 a2 10 80       	push   $0x8010a2b1
801005eb:	e8 04 fe ff ff       	call   801003f4 <cprintf>
801005f0:	83 c4 10             	add    $0x10,%esp
801005f3:	83 ec 08             	sub    $0x8,%esp
801005f6:	8d 45 cc             	lea    -0x34(%ebp),%eax
801005f9:	50                   	push   %eax
801005fa:	8d 45 08             	lea    0x8(%ebp),%eax
801005fd:	50                   	push   %eax
801005fe:	e8 25 44 00 00       	call   80104a28 <getcallerpcs>
80100603:	83 c4 10             	add    $0x10,%esp
80100606:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
8010060d:	eb 1c                	jmp    8010062b <panic+0x82>
8010060f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100612:	8b 44 85 cc          	mov    -0x34(%ebp,%eax,4),%eax
80100616:	83 ec 08             	sub    $0x8,%esp
80100619:	50                   	push   %eax
8010061a:	68 b3 a2 10 80       	push   $0x8010a2b3
8010061f:	e8 d0 fd ff ff       	call   801003f4 <cprintf>
80100624:	83 c4 10             	add    $0x10,%esp
80100627:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
8010062b:	83 7d f4 09          	cmpl   $0x9,-0xc(%ebp)
8010062f:	7e de                	jle    8010060f <panic+0x66>
80100631:	c7 05 ec 19 19 80 01 	movl   $0x1,0x801919ec
80100638:	00 00 00 
8010063b:	eb fe                	jmp    8010063b <panic+0x92>

8010063d <graphic_putc>:
8010063d:	55                   	push   %ebp
8010063e:	89 e5                	mov    %esp,%ebp
80100640:	83 ec 18             	sub    $0x18,%esp
80100643:	83 7d 08 0a          	cmpl   $0xa,0x8(%ebp)
80100647:	75 64                	jne    801006ad <graphic_putc+0x70>
80100649:	8b 0d 00 d0 10 80    	mov    0x8010d000,%ecx
8010064f:	ba ed 73 48 4d       	mov    $0x4d4873ed,%edx
80100654:	89 c8                	mov    %ecx,%eax
80100656:	f7 ea                	imul   %edx
80100658:	89 d0                	mov    %edx,%eax
8010065a:	c1 f8 04             	sar    $0x4,%eax
8010065d:	89 ca                	mov    %ecx,%edx
8010065f:	c1 fa 1f             	sar    $0x1f,%edx
80100662:	29 d0                	sub    %edx,%eax
80100664:	6b d0 35             	imul   $0x35,%eax,%edx
80100667:	89 c8                	mov    %ecx,%eax
80100669:	29 d0                	sub    %edx,%eax
8010066b:	ba 35 00 00 00       	mov    $0x35,%edx
80100670:	29 c2                	sub    %eax,%edx
80100672:	a1 00 d0 10 80       	mov    0x8010d000,%eax
80100677:	01 d0                	add    %edx,%eax
80100679:	a3 00 d0 10 80       	mov    %eax,0x8010d000
8010067e:	a1 00 d0 10 80       	mov    0x8010d000,%eax
80100683:	3d 23 04 00 00       	cmp    $0x423,%eax
80100688:	0f 8e de 00 00 00    	jle    8010076c <graphic_putc+0x12f>
8010068e:	a1 00 d0 10 80       	mov    0x8010d000,%eax
80100693:	83 e8 35             	sub    $0x35,%eax
80100696:	a3 00 d0 10 80       	mov    %eax,0x8010d000
8010069b:	83 ec 0c             	sub    $0xc,%esp
8010069e:	6a 1e                	push   $0x1e
801006a0:	e8 12 7a 00 00       	call   801080b7 <graphic_scroll_up>
801006a5:	83 c4 10             	add    $0x10,%esp
801006a8:	e9 bf 00 00 00       	jmp    8010076c <graphic_putc+0x12f>
801006ad:	81 7d 08 00 01 00 00 	cmpl   $0x100,0x8(%ebp)
801006b4:	75 1f                	jne    801006d5 <graphic_putc+0x98>
801006b6:	a1 00 d0 10 80       	mov    0x8010d000,%eax
801006bb:	85 c0                	test   %eax,%eax
801006bd:	0f 8e a9 00 00 00    	jle    8010076c <graphic_putc+0x12f>
801006c3:	a1 00 d0 10 80       	mov    0x8010d000,%eax
801006c8:	83 e8 01             	sub    $0x1,%eax
801006cb:	a3 00 d0 10 80       	mov    %eax,0x8010d000
801006d0:	e9 97 00 00 00       	jmp    8010076c <graphic_putc+0x12f>
801006d5:	a1 00 d0 10 80       	mov    0x8010d000,%eax
801006da:	3d 23 04 00 00       	cmp    $0x423,%eax
801006df:	7e 1a                	jle    801006fb <graphic_putc+0xbe>
801006e1:	a1 00 d0 10 80       	mov    0x8010d000,%eax
801006e6:	83 e8 35             	sub    $0x35,%eax
801006e9:	a3 00 d0 10 80       	mov    %eax,0x8010d000
801006ee:	83 ec 0c             	sub    $0xc,%esp
801006f1:	6a 1e                	push   $0x1e
801006f3:	e8 bf 79 00 00       	call   801080b7 <graphic_scroll_up>
801006f8:	83 c4 10             	add    $0x10,%esp
801006fb:	8b 0d 00 d0 10 80    	mov    0x8010d000,%ecx
80100701:	ba ed 73 48 4d       	mov    $0x4d4873ed,%edx
80100706:	89 c8                	mov    %ecx,%eax
80100708:	f7 ea                	imul   %edx
8010070a:	89 d0                	mov    %edx,%eax
8010070c:	c1 f8 04             	sar    $0x4,%eax
8010070f:	89 ca                	mov    %ecx,%edx
80100711:	c1 fa 1f             	sar    $0x1f,%edx
80100714:	29 d0                	sub    %edx,%eax
80100716:	6b d0 35             	imul   $0x35,%eax,%edx
80100719:	89 c8                	mov    %ecx,%eax
8010071b:	29 d0                	sub    %edx,%eax
8010071d:	89 c2                	mov    %eax,%edx
8010071f:	c1 e2 04             	shl    $0x4,%edx
80100722:	29 c2                	sub    %eax,%edx
80100724:	8d 42 02             	lea    0x2(%edx),%eax
80100727:	89 45 f4             	mov    %eax,-0xc(%ebp)
8010072a:	8b 0d 00 d0 10 80    	mov    0x8010d000,%ecx
80100730:	ba ed 73 48 4d       	mov    $0x4d4873ed,%edx
80100735:	89 c8                	mov    %ecx,%eax
80100737:	f7 ea                	imul   %edx
80100739:	89 d0                	mov    %edx,%eax
8010073b:	c1 f8 04             	sar    $0x4,%eax
8010073e:	c1 f9 1f             	sar    $0x1f,%ecx
80100741:	89 ca                	mov    %ecx,%edx
80100743:	29 d0                	sub    %edx,%eax
80100745:	6b c0 1e             	imul   $0x1e,%eax,%eax
80100748:	89 45 f0             	mov    %eax,-0x10(%ebp)
8010074b:	83 ec 04             	sub    $0x4,%esp
8010074e:	ff 75 08             	push   0x8(%ebp)
80100751:	ff 75 f0             	push   -0x10(%ebp)
80100754:	ff 75 f4             	push   -0xc(%ebp)
80100757:	e8 c6 79 00 00       	call   80108122 <font_render>
8010075c:	83 c4 10             	add    $0x10,%esp
8010075f:	a1 00 d0 10 80       	mov    0x8010d000,%eax
80100764:	83 c0 01             	add    $0x1,%eax
80100767:	a3 00 d0 10 80       	mov    %eax,0x8010d000
8010076c:	90                   	nop
8010076d:	c9                   	leave  
8010076e:	c3                   	ret    

8010076f <consputc>:
8010076f:	55                   	push   %ebp
80100770:	89 e5                	mov    %esp,%ebp
80100772:	83 ec 08             	sub    $0x8,%esp
80100775:	a1 ec 19 19 80       	mov    0x801919ec,%eax
8010077a:	85 c0                	test   %eax,%eax
8010077c:	74 07                	je     80100785 <consputc+0x16>
8010077e:	e8 be fb ff ff       	call   80100341 <cli>
80100783:	eb fe                	jmp    80100783 <consputc+0x14>
80100785:	81 7d 08 00 01 00 00 	cmpl   $0x100,0x8(%ebp)
8010078c:	75 29                	jne    801007b7 <consputc+0x48>
8010078e:	83 ec 0c             	sub    $0xc,%esp
80100791:	6a 08                	push   $0x8
80100793:	e8 96 5d 00 00       	call   8010652e <uartputc>
80100798:	83 c4 10             	add    $0x10,%esp
8010079b:	83 ec 0c             	sub    $0xc,%esp
8010079e:	6a 20                	push   $0x20
801007a0:	e8 89 5d 00 00       	call   8010652e <uartputc>
801007a5:	83 c4 10             	add    $0x10,%esp
801007a8:	83 ec 0c             	sub    $0xc,%esp
801007ab:	6a 08                	push   $0x8
801007ad:	e8 7c 5d 00 00       	call   8010652e <uartputc>
801007b2:	83 c4 10             	add    $0x10,%esp
801007b5:	eb 0e                	jmp    801007c5 <consputc+0x56>
801007b7:	83 ec 0c             	sub    $0xc,%esp
801007ba:	ff 75 08             	push   0x8(%ebp)
801007bd:	e8 6c 5d 00 00       	call   8010652e <uartputc>
801007c2:	83 c4 10             	add    $0x10,%esp
801007c5:	83 ec 0c             	sub    $0xc,%esp
801007c8:	ff 75 08             	push   0x8(%ebp)
801007cb:	e8 6d fe ff ff       	call   8010063d <graphic_putc>
801007d0:	83 c4 10             	add    $0x10,%esp
801007d3:	90                   	nop
801007d4:	c9                   	leave  
801007d5:	c3                   	ret    

801007d6 <consoleintr>:
801007d6:	55                   	push   %ebp
801007d7:	89 e5                	mov    %esp,%ebp
801007d9:	83 ec 18             	sub    $0x18,%esp
801007dc:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
801007e3:	83 ec 0c             	sub    $0xc,%esp
801007e6:	68 00 1a 19 80       	push   $0x80191a00
801007eb:	e8 78 41 00 00       	call   80104968 <acquire>
801007f0:	83 c4 10             	add    $0x10,%esp
801007f3:	e9 50 01 00 00       	jmp    80100948 <consoleintr+0x172>
801007f8:	83 7d f0 7f          	cmpl   $0x7f,-0x10(%ebp)
801007fc:	0f 84 81 00 00 00    	je     80100883 <consoleintr+0xad>
80100802:	83 7d f0 7f          	cmpl   $0x7f,-0x10(%ebp)
80100806:	0f 8f ac 00 00 00    	jg     801008b8 <consoleintr+0xe2>
8010080c:	83 7d f0 15          	cmpl   $0x15,-0x10(%ebp)
80100810:	74 43                	je     80100855 <consoleintr+0x7f>
80100812:	83 7d f0 15          	cmpl   $0x15,-0x10(%ebp)
80100816:	0f 8f 9c 00 00 00    	jg     801008b8 <consoleintr+0xe2>
8010081c:	83 7d f0 08          	cmpl   $0x8,-0x10(%ebp)
80100820:	74 61                	je     80100883 <consoleintr+0xad>
80100822:	83 7d f0 10          	cmpl   $0x10,-0x10(%ebp)
80100826:	0f 85 8c 00 00 00    	jne    801008b8 <consoleintr+0xe2>
8010082c:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
80100833:	e9 10 01 00 00       	jmp    80100948 <consoleintr+0x172>
80100838:	a1 e8 19 19 80       	mov    0x801919e8,%eax
8010083d:	83 e8 01             	sub    $0x1,%eax
80100840:	a3 e8 19 19 80       	mov    %eax,0x801919e8
80100845:	83 ec 0c             	sub    $0xc,%esp
80100848:	68 00 01 00 00       	push   $0x100
8010084d:	e8 1d ff ff ff       	call   8010076f <consputc>
80100852:	83 c4 10             	add    $0x10,%esp
80100855:	8b 15 e8 19 19 80    	mov    0x801919e8,%edx
8010085b:	a1 e4 19 19 80       	mov    0x801919e4,%eax
80100860:	39 c2                	cmp    %eax,%edx
80100862:	0f 84 e0 00 00 00    	je     80100948 <consoleintr+0x172>
80100868:	a1 e8 19 19 80       	mov    0x801919e8,%eax
8010086d:	83 e8 01             	sub    $0x1,%eax
80100870:	83 e0 7f             	and    $0x7f,%eax
80100873:	0f b6 80 60 19 19 80 	movzbl -0x7fe6e6a0(%eax),%eax
8010087a:	3c 0a                	cmp    $0xa,%al
8010087c:	75 ba                	jne    80100838 <consoleintr+0x62>
8010087e:	e9 c5 00 00 00       	jmp    80100948 <consoleintr+0x172>
80100883:	8b 15 e8 19 19 80    	mov    0x801919e8,%edx
80100889:	a1 e4 19 19 80       	mov    0x801919e4,%eax
8010088e:	39 c2                	cmp    %eax,%edx
80100890:	0f 84 b2 00 00 00    	je     80100948 <consoleintr+0x172>
80100896:	a1 e8 19 19 80       	mov    0x801919e8,%eax
8010089b:	83 e8 01             	sub    $0x1,%eax
8010089e:	a3 e8 19 19 80       	mov    %eax,0x801919e8
801008a3:	83 ec 0c             	sub    $0xc,%esp
801008a6:	68 00 01 00 00       	push   $0x100
801008ab:	e8 bf fe ff ff       	call   8010076f <consputc>
801008b0:	83 c4 10             	add    $0x10,%esp
801008b3:	e9 90 00 00 00       	jmp    80100948 <consoleintr+0x172>
801008b8:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
801008bc:	0f 84 85 00 00 00    	je     80100947 <consoleintr+0x171>
801008c2:	a1 e8 19 19 80       	mov    0x801919e8,%eax
801008c7:	8b 15 e0 19 19 80    	mov    0x801919e0,%edx
801008cd:	29 d0                	sub    %edx,%eax
801008cf:	83 f8 7f             	cmp    $0x7f,%eax
801008d2:	77 73                	ja     80100947 <consoleintr+0x171>
801008d4:	83 7d f0 0d          	cmpl   $0xd,-0x10(%ebp)
801008d8:	74 05                	je     801008df <consoleintr+0x109>
801008da:	8b 45 f0             	mov    -0x10(%ebp),%eax
801008dd:	eb 05                	jmp    801008e4 <consoleintr+0x10e>
801008df:	b8 0a 00 00 00       	mov    $0xa,%eax
801008e4:	89 45 f0             	mov    %eax,-0x10(%ebp)
801008e7:	a1 e8 19 19 80       	mov    0x801919e8,%eax
801008ec:	8d 50 01             	lea    0x1(%eax),%edx
801008ef:	89 15 e8 19 19 80    	mov    %edx,0x801919e8
801008f5:	83 e0 7f             	and    $0x7f,%eax
801008f8:	8b 55 f0             	mov    -0x10(%ebp),%edx
801008fb:	88 90 60 19 19 80    	mov    %dl,-0x7fe6e6a0(%eax)
80100901:	83 ec 0c             	sub    $0xc,%esp
80100904:	ff 75 f0             	push   -0x10(%ebp)
80100907:	e8 63 fe ff ff       	call   8010076f <consputc>
8010090c:	83 c4 10             	add    $0x10,%esp
8010090f:	83 7d f0 0a          	cmpl   $0xa,-0x10(%ebp)
80100913:	74 18                	je     8010092d <consoleintr+0x157>
80100915:	83 7d f0 04          	cmpl   $0x4,-0x10(%ebp)
80100919:	74 12                	je     8010092d <consoleintr+0x157>
8010091b:	a1 e8 19 19 80       	mov    0x801919e8,%eax
80100920:	8b 15 e0 19 19 80    	mov    0x801919e0,%edx
80100926:	83 ea 80             	sub    $0xffffff80,%edx
80100929:	39 d0                	cmp    %edx,%eax
8010092b:	75 1a                	jne    80100947 <consoleintr+0x171>
8010092d:	a1 e8 19 19 80       	mov    0x801919e8,%eax
80100932:	a3 e4 19 19 80       	mov    %eax,0x801919e4
80100937:	83 ec 0c             	sub    $0xc,%esp
8010093a:	68 e0 19 19 80       	push   $0x801919e0
8010093f:	e8 f0 3c 00 00       	call   80104634 <wakeup>
80100944:	83 c4 10             	add    $0x10,%esp
80100947:	90                   	nop
80100948:	8b 45 08             	mov    0x8(%ebp),%eax
8010094b:	ff d0                	call   *%eax
8010094d:	89 45 f0             	mov    %eax,-0x10(%ebp)
80100950:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80100954:	0f 89 9e fe ff ff    	jns    801007f8 <consoleintr+0x22>
8010095a:	83 ec 0c             	sub    $0xc,%esp
8010095d:	68 00 1a 19 80       	push   $0x80191a00
80100962:	e8 6f 40 00 00       	call   801049d6 <release>
80100967:	83 c4 10             	add    $0x10,%esp
8010096a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
8010096e:	74 05                	je     80100975 <consoleintr+0x19f>
80100970:	e8 7a 3d 00 00       	call   801046ef <procdump>
80100975:	90                   	nop
80100976:	c9                   	leave  
80100977:	c3                   	ret    

80100978 <consoleread>:
80100978:	55                   	push   %ebp
80100979:	89 e5                	mov    %esp,%ebp
8010097b:	83 ec 18             	sub    $0x18,%esp
8010097e:	83 ec 0c             	sub    $0xc,%esp
80100981:	ff 75 08             	push   0x8(%ebp)
80100984:	e8 74 11 00 00       	call   80101afd <iunlock>
80100989:	83 c4 10             	add    $0x10,%esp
8010098c:	8b 45 10             	mov    0x10(%ebp),%eax
8010098f:	89 45 f4             	mov    %eax,-0xc(%ebp)
80100992:	83 ec 0c             	sub    $0xc,%esp
80100995:	68 00 1a 19 80       	push   $0x80191a00
8010099a:	e8 c9 3f 00 00       	call   80104968 <acquire>
8010099f:	83 c4 10             	add    $0x10,%esp
801009a2:	e9 ab 00 00 00       	jmp    80100a52 <consoleread+0xda>
801009a7:	e8 84 30 00 00       	call   80103a30 <myproc>
801009ac:	8b 40 24             	mov    0x24(%eax),%eax
801009af:	85 c0                	test   %eax,%eax
801009b1:	74 28                	je     801009db <consoleread+0x63>
801009b3:	83 ec 0c             	sub    $0xc,%esp
801009b6:	68 00 1a 19 80       	push   $0x80191a00
801009bb:	e8 16 40 00 00       	call   801049d6 <release>
801009c0:	83 c4 10             	add    $0x10,%esp
801009c3:	83 ec 0c             	sub    $0xc,%esp
801009c6:	ff 75 08             	push   0x8(%ebp)
801009c9:	e8 1c 10 00 00       	call   801019ea <ilock>
801009ce:	83 c4 10             	add    $0x10,%esp
801009d1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801009d6:	e9 a9 00 00 00       	jmp    80100a84 <consoleread+0x10c>
801009db:	83 ec 08             	sub    $0x8,%esp
801009de:	68 00 1a 19 80       	push   $0x80191a00
801009e3:	68 e0 19 19 80       	push   $0x801919e0
801009e8:	e8 60 3b 00 00       	call   8010454d <sleep>
801009ed:	83 c4 10             	add    $0x10,%esp
801009f0:	8b 15 e0 19 19 80    	mov    0x801919e0,%edx
801009f6:	a1 e4 19 19 80       	mov    0x801919e4,%eax
801009fb:	39 c2                	cmp    %eax,%edx
801009fd:	74 a8                	je     801009a7 <consoleread+0x2f>
801009ff:	a1 e0 19 19 80       	mov    0x801919e0,%eax
80100a04:	8d 50 01             	lea    0x1(%eax),%edx
80100a07:	89 15 e0 19 19 80    	mov    %edx,0x801919e0
80100a0d:	83 e0 7f             	and    $0x7f,%eax
80100a10:	0f b6 80 60 19 19 80 	movzbl -0x7fe6e6a0(%eax),%eax
80100a17:	0f be c0             	movsbl %al,%eax
80100a1a:	89 45 f0             	mov    %eax,-0x10(%ebp)
80100a1d:	83 7d f0 04          	cmpl   $0x4,-0x10(%ebp)
80100a21:	75 17                	jne    80100a3a <consoleread+0xc2>
80100a23:	8b 45 10             	mov    0x10(%ebp),%eax
80100a26:	39 45 f4             	cmp    %eax,-0xc(%ebp)
80100a29:	76 2f                	jbe    80100a5a <consoleread+0xe2>
80100a2b:	a1 e0 19 19 80       	mov    0x801919e0,%eax
80100a30:	83 e8 01             	sub    $0x1,%eax
80100a33:	a3 e0 19 19 80       	mov    %eax,0x801919e0
80100a38:	eb 20                	jmp    80100a5a <consoleread+0xe2>
80100a3a:	8b 45 0c             	mov    0xc(%ebp),%eax
80100a3d:	8d 50 01             	lea    0x1(%eax),%edx
80100a40:	89 55 0c             	mov    %edx,0xc(%ebp)
80100a43:	8b 55 f0             	mov    -0x10(%ebp),%edx
80100a46:	88 10                	mov    %dl,(%eax)
80100a48:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
80100a4c:	83 7d f0 0a          	cmpl   $0xa,-0x10(%ebp)
80100a50:	74 0b                	je     80100a5d <consoleread+0xe5>
80100a52:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
80100a56:	7f 98                	jg     801009f0 <consoleread+0x78>
80100a58:	eb 04                	jmp    80100a5e <consoleread+0xe6>
80100a5a:	90                   	nop
80100a5b:	eb 01                	jmp    80100a5e <consoleread+0xe6>
80100a5d:	90                   	nop
80100a5e:	83 ec 0c             	sub    $0xc,%esp
80100a61:	68 00 1a 19 80       	push   $0x80191a00
80100a66:	e8 6b 3f 00 00       	call   801049d6 <release>
80100a6b:	83 c4 10             	add    $0x10,%esp
80100a6e:	83 ec 0c             	sub    $0xc,%esp
80100a71:	ff 75 08             	push   0x8(%ebp)
80100a74:	e8 71 0f 00 00       	call   801019ea <ilock>
80100a79:	83 c4 10             	add    $0x10,%esp
80100a7c:	8b 55 10             	mov    0x10(%ebp),%edx
80100a7f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100a82:	29 d0                	sub    %edx,%eax
80100a84:	c9                   	leave  
80100a85:	c3                   	ret    

80100a86 <consolewrite>:
80100a86:	55                   	push   %ebp
80100a87:	89 e5                	mov    %esp,%ebp
80100a89:	83 ec 18             	sub    $0x18,%esp
80100a8c:	83 ec 0c             	sub    $0xc,%esp
80100a8f:	ff 75 08             	push   0x8(%ebp)
80100a92:	e8 66 10 00 00       	call   80101afd <iunlock>
80100a97:	83 c4 10             	add    $0x10,%esp
80100a9a:	83 ec 0c             	sub    $0xc,%esp
80100a9d:	68 00 1a 19 80       	push   $0x80191a00
80100aa2:	e8 c1 3e 00 00       	call   80104968 <acquire>
80100aa7:	83 c4 10             	add    $0x10,%esp
80100aaa:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80100ab1:	eb 21                	jmp    80100ad4 <consolewrite+0x4e>
80100ab3:	8b 55 f4             	mov    -0xc(%ebp),%edx
80100ab6:	8b 45 0c             	mov    0xc(%ebp),%eax
80100ab9:	01 d0                	add    %edx,%eax
80100abb:	0f b6 00             	movzbl (%eax),%eax
80100abe:	0f be c0             	movsbl %al,%eax
80100ac1:	0f b6 c0             	movzbl %al,%eax
80100ac4:	83 ec 0c             	sub    $0xc,%esp
80100ac7:	50                   	push   %eax
80100ac8:	e8 a2 fc ff ff       	call   8010076f <consputc>
80100acd:	83 c4 10             	add    $0x10,%esp
80100ad0:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80100ad4:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100ad7:	3b 45 10             	cmp    0x10(%ebp),%eax
80100ada:	7c d7                	jl     80100ab3 <consolewrite+0x2d>
80100adc:	83 ec 0c             	sub    $0xc,%esp
80100adf:	68 00 1a 19 80       	push   $0x80191a00
80100ae4:	e8 ed 3e 00 00       	call   801049d6 <release>
80100ae9:	83 c4 10             	add    $0x10,%esp
80100aec:	83 ec 0c             	sub    $0xc,%esp
80100aef:	ff 75 08             	push   0x8(%ebp)
80100af2:	e8 f3 0e 00 00       	call   801019ea <ilock>
80100af7:	83 c4 10             	add    $0x10,%esp
80100afa:	8b 45 10             	mov    0x10(%ebp),%eax
80100afd:	c9                   	leave  
80100afe:	c3                   	ret    

80100aff <consoleinit>:
80100aff:	55                   	push   %ebp
80100b00:	89 e5                	mov    %esp,%ebp
80100b02:	83 ec 18             	sub    $0x18,%esp
80100b05:	c7 05 ec 19 19 80 00 	movl   $0x0,0x801919ec
80100b0c:	00 00 00 
80100b0f:	83 ec 08             	sub    $0x8,%esp
80100b12:	68 b7 a2 10 80       	push   $0x8010a2b7
80100b17:	68 00 1a 19 80       	push   $0x80191a00
80100b1c:	e8 25 3e 00 00       	call   80104946 <initlock>
80100b21:	83 c4 10             	add    $0x10,%esp
80100b24:	c7 05 4c 1a 19 80 86 	movl   $0x80100a86,0x80191a4c
80100b2b:	0a 10 80 
80100b2e:	c7 05 48 1a 19 80 78 	movl   $0x80100978,0x80191a48
80100b35:	09 10 80 
80100b38:	c7 45 f4 bf a2 10 80 	movl   $0x8010a2bf,-0xc(%ebp)
80100b3f:	eb 19                	jmp    80100b5a <consoleinit+0x5b>
80100b41:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100b44:	0f b6 00             	movzbl (%eax),%eax
80100b47:	0f be c0             	movsbl %al,%eax
80100b4a:	83 ec 0c             	sub    $0xc,%esp
80100b4d:	50                   	push   %eax
80100b4e:	e8 ea fa ff ff       	call   8010063d <graphic_putc>
80100b53:	83 c4 10             	add    $0x10,%esp
80100b56:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80100b5a:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100b5d:	0f b6 00             	movzbl (%eax),%eax
80100b60:	84 c0                	test   %al,%al
80100b62:	75 dd                	jne    80100b41 <consoleinit+0x42>
80100b64:	c7 05 34 1a 19 80 01 	movl   $0x1,0x80191a34
80100b6b:	00 00 00 
80100b6e:	83 ec 08             	sub    $0x8,%esp
80100b71:	6a 00                	push   $0x0
80100b73:	6a 01                	push   $0x1
80100b75:	e8 b4 1a 00 00       	call   8010262e <ioapicenable>
80100b7a:	83 c4 10             	add    $0x10,%esp
80100b7d:	90                   	nop
80100b7e:	c9                   	leave  
80100b7f:	c3                   	ret    

80100b80 <exec>:
80100b80:	55                   	push   %ebp
80100b81:	89 e5                	mov    %esp,%ebp
80100b83:	81 ec 18 01 00 00    	sub    $0x118,%esp
80100b89:	e8 a2 2e 00 00       	call   80103a30 <myproc>
80100b8e:	89 45 d0             	mov    %eax,-0x30(%ebp)
80100b91:	e8 a6 24 00 00       	call   8010303c <begin_op>
80100b96:	83 ec 0c             	sub    $0xc,%esp
80100b99:	ff 75 08             	push   0x8(%ebp)
80100b9c:	e8 7c 19 00 00       	call   8010251d <namei>
80100ba1:	83 c4 10             	add    $0x10,%esp
80100ba4:	89 45 d8             	mov    %eax,-0x28(%ebp)
80100ba7:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
80100bab:	75 1f                	jne    80100bcc <exec+0x4c>
80100bad:	e8 16 25 00 00       	call   801030c8 <end_op>
80100bb2:	83 ec 0c             	sub    $0xc,%esp
80100bb5:	68 d5 a2 10 80       	push   $0x8010a2d5
80100bba:	e8 35 f8 ff ff       	call   801003f4 <cprintf>
80100bbf:	83 c4 10             	add    $0x10,%esp
80100bc2:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80100bc7:	e9 f1 03 00 00       	jmp    80100fbd <exec+0x43d>
80100bcc:	83 ec 0c             	sub    $0xc,%esp
80100bcf:	ff 75 d8             	push   -0x28(%ebp)
80100bd2:	e8 13 0e 00 00       	call   801019ea <ilock>
80100bd7:	83 c4 10             	add    $0x10,%esp
80100bda:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
80100be1:	6a 34                	push   $0x34
80100be3:	6a 00                	push   $0x0
80100be5:	8d 85 08 ff ff ff    	lea    -0xf8(%ebp),%eax
80100beb:	50                   	push   %eax
80100bec:	ff 75 d8             	push   -0x28(%ebp)
80100bef:	e8 e2 12 00 00       	call   80101ed6 <readi>
80100bf4:	83 c4 10             	add    $0x10,%esp
80100bf7:	83 f8 34             	cmp    $0x34,%eax
80100bfa:	0f 85 66 03 00 00    	jne    80100f66 <exec+0x3e6>
80100c00:	8b 85 08 ff ff ff    	mov    -0xf8(%ebp),%eax
80100c06:	3d 7f 45 4c 46       	cmp    $0x464c457f,%eax
80100c0b:	0f 85 58 03 00 00    	jne    80100f69 <exec+0x3e9>
80100c11:	e8 14 69 00 00       	call   8010752a <setupkvm>
80100c16:	89 45 d4             	mov    %eax,-0x2c(%ebp)
80100c19:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
80100c1d:	0f 84 49 03 00 00    	je     80100f6c <exec+0x3ec>
80100c23:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
80100c2a:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
80100c31:	8b 85 24 ff ff ff    	mov    -0xdc(%ebp),%eax
80100c37:	89 45 e8             	mov    %eax,-0x18(%ebp)
80100c3a:	e9 de 00 00 00       	jmp    80100d1d <exec+0x19d>
80100c3f:	8b 45 e8             	mov    -0x18(%ebp),%eax
80100c42:	6a 20                	push   $0x20
80100c44:	50                   	push   %eax
80100c45:	8d 85 e8 fe ff ff    	lea    -0x118(%ebp),%eax
80100c4b:	50                   	push   %eax
80100c4c:	ff 75 d8             	push   -0x28(%ebp)
80100c4f:	e8 82 12 00 00       	call   80101ed6 <readi>
80100c54:	83 c4 10             	add    $0x10,%esp
80100c57:	83 f8 20             	cmp    $0x20,%eax
80100c5a:	0f 85 0f 03 00 00    	jne    80100f6f <exec+0x3ef>
80100c60:	8b 85 e8 fe ff ff    	mov    -0x118(%ebp),%eax
80100c66:	83 f8 01             	cmp    $0x1,%eax
80100c69:	0f 85 a0 00 00 00    	jne    80100d0f <exec+0x18f>
80100c6f:	8b 95 fc fe ff ff    	mov    -0x104(%ebp),%edx
80100c75:	8b 85 f8 fe ff ff    	mov    -0x108(%ebp),%eax
80100c7b:	39 c2                	cmp    %eax,%edx
80100c7d:	0f 82 ef 02 00 00    	jb     80100f72 <exec+0x3f2>
80100c83:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
80100c89:	8b 85 fc fe ff ff    	mov    -0x104(%ebp),%eax
80100c8f:	01 c2                	add    %eax,%edx
80100c91:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
80100c97:	39 c2                	cmp    %eax,%edx
80100c99:	0f 82 d6 02 00 00    	jb     80100f75 <exec+0x3f5>
80100c9f:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
80100ca5:	8b 85 fc fe ff ff    	mov    -0x104(%ebp),%eax
80100cab:	01 d0                	add    %edx,%eax
80100cad:	83 ec 04             	sub    $0x4,%esp
80100cb0:	50                   	push   %eax
80100cb1:	ff 75 e0             	push   -0x20(%ebp)
80100cb4:	ff 75 d4             	push   -0x2c(%ebp)
80100cb7:	e8 67 6c 00 00       	call   80107923 <allocuvm>
80100cbc:	83 c4 10             	add    $0x10,%esp
80100cbf:	89 45 e0             	mov    %eax,-0x20(%ebp)
80100cc2:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
80100cc6:	0f 84 ac 02 00 00    	je     80100f78 <exec+0x3f8>
80100ccc:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
80100cd2:	25 ff 0f 00 00       	and    $0xfff,%eax
80100cd7:	85 c0                	test   %eax,%eax
80100cd9:	0f 85 9c 02 00 00    	jne    80100f7b <exec+0x3fb>
80100cdf:	8b 95 f8 fe ff ff    	mov    -0x108(%ebp),%edx
80100ce5:	8b 85 ec fe ff ff    	mov    -0x114(%ebp),%eax
80100ceb:	8b 8d f0 fe ff ff    	mov    -0x110(%ebp),%ecx
80100cf1:	83 ec 0c             	sub    $0xc,%esp
80100cf4:	52                   	push   %edx
80100cf5:	50                   	push   %eax
80100cf6:	ff 75 d8             	push   -0x28(%ebp)
80100cf9:	51                   	push   %ecx
80100cfa:	ff 75 d4             	push   -0x2c(%ebp)
80100cfd:	e8 54 6b 00 00       	call   80107856 <loaduvm>
80100d02:	83 c4 20             	add    $0x20,%esp
80100d05:	85 c0                	test   %eax,%eax
80100d07:	0f 88 71 02 00 00    	js     80100f7e <exec+0x3fe>
80100d0d:	eb 01                	jmp    80100d10 <exec+0x190>
80100d0f:	90                   	nop
80100d10:	83 45 ec 01          	addl   $0x1,-0x14(%ebp)
80100d14:	8b 45 e8             	mov    -0x18(%ebp),%eax
80100d17:	83 c0 20             	add    $0x20,%eax
80100d1a:	89 45 e8             	mov    %eax,-0x18(%ebp)
80100d1d:	0f b7 85 34 ff ff ff 	movzwl -0xcc(%ebp),%eax
80100d24:	0f b7 c0             	movzwl %ax,%eax
80100d27:	39 45 ec             	cmp    %eax,-0x14(%ebp)
80100d2a:	0f 8c 0f ff ff ff    	jl     80100c3f <exec+0xbf>
80100d30:	83 ec 0c             	sub    $0xc,%esp
80100d33:	ff 75 d8             	push   -0x28(%ebp)
80100d36:	e8 e0 0e 00 00       	call   80101c1b <iunlockput>
80100d3b:	83 c4 10             	add    $0x10,%esp
80100d3e:	e8 85 23 00 00       	call   801030c8 <end_op>
80100d43:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)
80100d4a:	8b 45 e0             	mov    -0x20(%ebp),%eax
80100d4d:	05 ff 0f 00 00       	add    $0xfff,%eax
80100d52:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80100d57:	89 45 e0             	mov    %eax,-0x20(%ebp)
80100d5a:	8b 45 e0             	mov    -0x20(%ebp),%eax
80100d5d:	05 00 20 00 00       	add    $0x2000,%eax
80100d62:	83 ec 04             	sub    $0x4,%esp
80100d65:	50                   	push   %eax
80100d66:	ff 75 e0             	push   -0x20(%ebp)
80100d69:	ff 75 d4             	push   -0x2c(%ebp)
80100d6c:	e8 b2 6b 00 00       	call   80107923 <allocuvm>
80100d71:	83 c4 10             	add    $0x10,%esp
80100d74:	89 45 e0             	mov    %eax,-0x20(%ebp)
80100d77:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
80100d7b:	0f 84 00 02 00 00    	je     80100f81 <exec+0x401>
80100d81:	8b 45 e0             	mov    -0x20(%ebp),%eax
80100d84:	2d 00 20 00 00       	sub    $0x2000,%eax
80100d89:	83 ec 08             	sub    $0x8,%esp
80100d8c:	50                   	push   %eax
80100d8d:	ff 75 d4             	push   -0x2c(%ebp)
80100d90:	e8 f0 6d 00 00       	call   80107b85 <clearpteu>
80100d95:	83 c4 10             	add    $0x10,%esp
80100d98:	8b 45 e0             	mov    -0x20(%ebp),%eax
80100d9b:	89 45 dc             	mov    %eax,-0x24(%ebp)
80100d9e:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
80100da5:	e9 96 00 00 00       	jmp    80100e40 <exec+0x2c0>
80100daa:	83 7d e4 1f          	cmpl   $0x1f,-0x1c(%ebp)
80100dae:	0f 87 d0 01 00 00    	ja     80100f84 <exec+0x404>
80100db4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100db7:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80100dbe:	8b 45 0c             	mov    0xc(%ebp),%eax
80100dc1:	01 d0                	add    %edx,%eax
80100dc3:	8b 00                	mov    (%eax),%eax
80100dc5:	83 ec 0c             	sub    $0xc,%esp
80100dc8:	50                   	push   %eax
80100dc9:	e8 5e 40 00 00       	call   80104e2c <strlen>
80100dce:	83 c4 10             	add    $0x10,%esp
80100dd1:	89 c2                	mov    %eax,%edx
80100dd3:	8b 45 dc             	mov    -0x24(%ebp),%eax
80100dd6:	29 d0                	sub    %edx,%eax
80100dd8:	83 e8 01             	sub    $0x1,%eax
80100ddb:	83 e0 fc             	and    $0xfffffffc,%eax
80100dde:	89 45 dc             	mov    %eax,-0x24(%ebp)
80100de1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100de4:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80100deb:	8b 45 0c             	mov    0xc(%ebp),%eax
80100dee:	01 d0                	add    %edx,%eax
80100df0:	8b 00                	mov    (%eax),%eax
80100df2:	83 ec 0c             	sub    $0xc,%esp
80100df5:	50                   	push   %eax
80100df6:	e8 31 40 00 00       	call   80104e2c <strlen>
80100dfb:	83 c4 10             	add    $0x10,%esp
80100dfe:	83 c0 01             	add    $0x1,%eax
80100e01:	89 c2                	mov    %eax,%edx
80100e03:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100e06:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
80100e0d:	8b 45 0c             	mov    0xc(%ebp),%eax
80100e10:	01 c8                	add    %ecx,%eax
80100e12:	8b 00                	mov    (%eax),%eax
80100e14:	52                   	push   %edx
80100e15:	50                   	push   %eax
80100e16:	ff 75 dc             	push   -0x24(%ebp)
80100e19:	ff 75 d4             	push   -0x2c(%ebp)
80100e1c:	e8 03 6f 00 00       	call   80107d24 <copyout>
80100e21:	83 c4 10             	add    $0x10,%esp
80100e24:	85 c0                	test   %eax,%eax
80100e26:	0f 88 5b 01 00 00    	js     80100f87 <exec+0x407>
80100e2c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100e2f:	8d 50 03             	lea    0x3(%eax),%edx
80100e32:	8b 45 dc             	mov    -0x24(%ebp),%eax
80100e35:	89 84 95 3c ff ff ff 	mov    %eax,-0xc4(%ebp,%edx,4)
80100e3c:	83 45 e4 01          	addl   $0x1,-0x1c(%ebp)
80100e40:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100e43:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80100e4a:	8b 45 0c             	mov    0xc(%ebp),%eax
80100e4d:	01 d0                	add    %edx,%eax
80100e4f:	8b 00                	mov    (%eax),%eax
80100e51:	85 c0                	test   %eax,%eax
80100e53:	0f 85 51 ff ff ff    	jne    80100daa <exec+0x22a>
80100e59:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100e5c:	83 c0 03             	add    $0x3,%eax
80100e5f:	c7 84 85 3c ff ff ff 	movl   $0x0,-0xc4(%ebp,%eax,4)
80100e66:	00 00 00 00 
80100e6a:	c7 85 3c ff ff ff ff 	movl   $0xffffffff,-0xc4(%ebp)
80100e71:	ff ff ff 
80100e74:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100e77:	89 85 40 ff ff ff    	mov    %eax,-0xc0(%ebp)
80100e7d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100e80:	83 c0 01             	add    $0x1,%eax
80100e83:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80100e8a:	8b 45 dc             	mov    -0x24(%ebp),%eax
80100e8d:	29 d0                	sub    %edx,%eax
80100e8f:	89 85 44 ff ff ff    	mov    %eax,-0xbc(%ebp)
80100e95:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100e98:	83 c0 04             	add    $0x4,%eax
80100e9b:	c1 e0 02             	shl    $0x2,%eax
80100e9e:	29 45 dc             	sub    %eax,-0x24(%ebp)
80100ea1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100ea4:	83 c0 04             	add    $0x4,%eax
80100ea7:	c1 e0 02             	shl    $0x2,%eax
80100eaa:	50                   	push   %eax
80100eab:	8d 85 3c ff ff ff    	lea    -0xc4(%ebp),%eax
80100eb1:	50                   	push   %eax
80100eb2:	ff 75 dc             	push   -0x24(%ebp)
80100eb5:	ff 75 d4             	push   -0x2c(%ebp)
80100eb8:	e8 67 6e 00 00       	call   80107d24 <copyout>
80100ebd:	83 c4 10             	add    $0x10,%esp
80100ec0:	85 c0                	test   %eax,%eax
80100ec2:	0f 88 c2 00 00 00    	js     80100f8a <exec+0x40a>
80100ec8:	8b 45 08             	mov    0x8(%ebp),%eax
80100ecb:	89 45 f4             	mov    %eax,-0xc(%ebp)
80100ece:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100ed1:	89 45 f0             	mov    %eax,-0x10(%ebp)
80100ed4:	eb 17                	jmp    80100eed <exec+0x36d>
80100ed6:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100ed9:	0f b6 00             	movzbl (%eax),%eax
80100edc:	3c 2f                	cmp    $0x2f,%al
80100ede:	75 09                	jne    80100ee9 <exec+0x369>
80100ee0:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100ee3:	83 c0 01             	add    $0x1,%eax
80100ee6:	89 45 f0             	mov    %eax,-0x10(%ebp)
80100ee9:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80100eed:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100ef0:	0f b6 00             	movzbl (%eax),%eax
80100ef3:	84 c0                	test   %al,%al
80100ef5:	75 df                	jne    80100ed6 <exec+0x356>
80100ef7:	8b 45 d0             	mov    -0x30(%ebp),%eax
80100efa:	83 c0 6c             	add    $0x6c,%eax
80100efd:	83 ec 04             	sub    $0x4,%esp
80100f00:	6a 10                	push   $0x10
80100f02:	ff 75 f0             	push   -0x10(%ebp)
80100f05:	50                   	push   %eax
80100f06:	e8 d6 3e 00 00       	call   80104de1 <safestrcpy>
80100f0b:	83 c4 10             	add    $0x10,%esp
80100f0e:	8b 45 d0             	mov    -0x30(%ebp),%eax
80100f11:	8b 40 04             	mov    0x4(%eax),%eax
80100f14:	89 45 cc             	mov    %eax,-0x34(%ebp)
80100f17:	8b 45 d0             	mov    -0x30(%ebp),%eax
80100f1a:	8b 55 d4             	mov    -0x2c(%ebp),%edx
80100f1d:	89 50 04             	mov    %edx,0x4(%eax)
80100f20:	8b 45 d0             	mov    -0x30(%ebp),%eax
80100f23:	8b 55 e0             	mov    -0x20(%ebp),%edx
80100f26:	89 10                	mov    %edx,(%eax)
80100f28:	8b 45 d0             	mov    -0x30(%ebp),%eax
80100f2b:	8b 40 18             	mov    0x18(%eax),%eax
80100f2e:	8b 95 20 ff ff ff    	mov    -0xe0(%ebp),%edx
80100f34:	89 50 38             	mov    %edx,0x38(%eax)
80100f37:	8b 45 d0             	mov    -0x30(%ebp),%eax
80100f3a:	8b 40 18             	mov    0x18(%eax),%eax
80100f3d:	8b 55 dc             	mov    -0x24(%ebp),%edx
80100f40:	89 50 44             	mov    %edx,0x44(%eax)
80100f43:	83 ec 0c             	sub    $0xc,%esp
80100f46:	ff 75 d0             	push   -0x30(%ebp)
80100f49:	e8 f9 66 00 00       	call   80107647 <switchuvm>
80100f4e:	83 c4 10             	add    $0x10,%esp
80100f51:	83 ec 0c             	sub    $0xc,%esp
80100f54:	ff 75 cc             	push   -0x34(%ebp)
80100f57:	e8 90 6b 00 00       	call   80107aec <freevm>
80100f5c:	83 c4 10             	add    $0x10,%esp
80100f5f:	b8 00 00 00 00       	mov    $0x0,%eax
80100f64:	eb 57                	jmp    80100fbd <exec+0x43d>
80100f66:	90                   	nop
80100f67:	eb 22                	jmp    80100f8b <exec+0x40b>
80100f69:	90                   	nop
80100f6a:	eb 1f                	jmp    80100f8b <exec+0x40b>
80100f6c:	90                   	nop
80100f6d:	eb 1c                	jmp    80100f8b <exec+0x40b>
80100f6f:	90                   	nop
80100f70:	eb 19                	jmp    80100f8b <exec+0x40b>
80100f72:	90                   	nop
80100f73:	eb 16                	jmp    80100f8b <exec+0x40b>
80100f75:	90                   	nop
80100f76:	eb 13                	jmp    80100f8b <exec+0x40b>
80100f78:	90                   	nop
80100f79:	eb 10                	jmp    80100f8b <exec+0x40b>
80100f7b:	90                   	nop
80100f7c:	eb 0d                	jmp    80100f8b <exec+0x40b>
80100f7e:	90                   	nop
80100f7f:	eb 0a                	jmp    80100f8b <exec+0x40b>
80100f81:	90                   	nop
80100f82:	eb 07                	jmp    80100f8b <exec+0x40b>
80100f84:	90                   	nop
80100f85:	eb 04                	jmp    80100f8b <exec+0x40b>
80100f87:	90                   	nop
80100f88:	eb 01                	jmp    80100f8b <exec+0x40b>
80100f8a:	90                   	nop
80100f8b:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
80100f8f:	74 0e                	je     80100f9f <exec+0x41f>
80100f91:	83 ec 0c             	sub    $0xc,%esp
80100f94:	ff 75 d4             	push   -0x2c(%ebp)
80100f97:	e8 50 6b 00 00       	call   80107aec <freevm>
80100f9c:	83 c4 10             	add    $0x10,%esp
80100f9f:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
80100fa3:	74 13                	je     80100fb8 <exec+0x438>
80100fa5:	83 ec 0c             	sub    $0xc,%esp
80100fa8:	ff 75 d8             	push   -0x28(%ebp)
80100fab:	e8 6b 0c 00 00       	call   80101c1b <iunlockput>
80100fb0:	83 c4 10             	add    $0x10,%esp
80100fb3:	e8 10 21 00 00       	call   801030c8 <end_op>
80100fb8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80100fbd:	c9                   	leave  
80100fbe:	c3                   	ret    

80100fbf <fileinit>:
80100fbf:	55                   	push   %ebp
80100fc0:	89 e5                	mov    %esp,%ebp
80100fc2:	83 ec 08             	sub    $0x8,%esp
80100fc5:	83 ec 08             	sub    $0x8,%esp
80100fc8:	68 e1 a2 10 80       	push   $0x8010a2e1
80100fcd:	68 a0 1a 19 80       	push   $0x80191aa0
80100fd2:	e8 6f 39 00 00       	call   80104946 <initlock>
80100fd7:	83 c4 10             	add    $0x10,%esp
80100fda:	90                   	nop
80100fdb:	c9                   	leave  
80100fdc:	c3                   	ret    

80100fdd <filealloc>:
80100fdd:	55                   	push   %ebp
80100fde:	89 e5                	mov    %esp,%ebp
80100fe0:	83 ec 18             	sub    $0x18,%esp
80100fe3:	83 ec 0c             	sub    $0xc,%esp
80100fe6:	68 a0 1a 19 80       	push   $0x80191aa0
80100feb:	e8 78 39 00 00       	call   80104968 <acquire>
80100ff0:	83 c4 10             	add    $0x10,%esp
80100ff3:	c7 45 f4 d4 1a 19 80 	movl   $0x80191ad4,-0xc(%ebp)
80100ffa:	eb 2d                	jmp    80101029 <filealloc+0x4c>
80100ffc:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100fff:	8b 40 04             	mov    0x4(%eax),%eax
80101002:	85 c0                	test   %eax,%eax
80101004:	75 1f                	jne    80101025 <filealloc+0x48>
80101006:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101009:	c7 40 04 01 00 00 00 	movl   $0x1,0x4(%eax)
80101010:	83 ec 0c             	sub    $0xc,%esp
80101013:	68 a0 1a 19 80       	push   $0x80191aa0
80101018:	e8 b9 39 00 00       	call   801049d6 <release>
8010101d:	83 c4 10             	add    $0x10,%esp
80101020:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101023:	eb 23                	jmp    80101048 <filealloc+0x6b>
80101025:	83 45 f4 18          	addl   $0x18,-0xc(%ebp)
80101029:	b8 34 24 19 80       	mov    $0x80192434,%eax
8010102e:	39 45 f4             	cmp    %eax,-0xc(%ebp)
80101031:	72 c9                	jb     80100ffc <filealloc+0x1f>
80101033:	83 ec 0c             	sub    $0xc,%esp
80101036:	68 a0 1a 19 80       	push   $0x80191aa0
8010103b:	e8 96 39 00 00       	call   801049d6 <release>
80101040:	83 c4 10             	add    $0x10,%esp
80101043:	b8 00 00 00 00       	mov    $0x0,%eax
80101048:	c9                   	leave  
80101049:	c3                   	ret    

8010104a <filedup>:
8010104a:	55                   	push   %ebp
8010104b:	89 e5                	mov    %esp,%ebp
8010104d:	83 ec 08             	sub    $0x8,%esp
80101050:	83 ec 0c             	sub    $0xc,%esp
80101053:	68 a0 1a 19 80       	push   $0x80191aa0
80101058:	e8 0b 39 00 00       	call   80104968 <acquire>
8010105d:	83 c4 10             	add    $0x10,%esp
80101060:	8b 45 08             	mov    0x8(%ebp),%eax
80101063:	8b 40 04             	mov    0x4(%eax),%eax
80101066:	85 c0                	test   %eax,%eax
80101068:	7f 0d                	jg     80101077 <filedup+0x2d>
8010106a:	83 ec 0c             	sub    $0xc,%esp
8010106d:	68 e8 a2 10 80       	push   $0x8010a2e8
80101072:	e8 32 f5 ff ff       	call   801005a9 <panic>
80101077:	8b 45 08             	mov    0x8(%ebp),%eax
8010107a:	8b 40 04             	mov    0x4(%eax),%eax
8010107d:	8d 50 01             	lea    0x1(%eax),%edx
80101080:	8b 45 08             	mov    0x8(%ebp),%eax
80101083:	89 50 04             	mov    %edx,0x4(%eax)
80101086:	83 ec 0c             	sub    $0xc,%esp
80101089:	68 a0 1a 19 80       	push   $0x80191aa0
8010108e:	e8 43 39 00 00       	call   801049d6 <release>
80101093:	83 c4 10             	add    $0x10,%esp
80101096:	8b 45 08             	mov    0x8(%ebp),%eax
80101099:	c9                   	leave  
8010109a:	c3                   	ret    

8010109b <fileclose>:
8010109b:	55                   	push   %ebp
8010109c:	89 e5                	mov    %esp,%ebp
8010109e:	83 ec 28             	sub    $0x28,%esp
801010a1:	83 ec 0c             	sub    $0xc,%esp
801010a4:	68 a0 1a 19 80       	push   $0x80191aa0
801010a9:	e8 ba 38 00 00       	call   80104968 <acquire>
801010ae:	83 c4 10             	add    $0x10,%esp
801010b1:	8b 45 08             	mov    0x8(%ebp),%eax
801010b4:	8b 40 04             	mov    0x4(%eax),%eax
801010b7:	85 c0                	test   %eax,%eax
801010b9:	7f 0d                	jg     801010c8 <fileclose+0x2d>
801010bb:	83 ec 0c             	sub    $0xc,%esp
801010be:	68 f0 a2 10 80       	push   $0x8010a2f0
801010c3:	e8 e1 f4 ff ff       	call   801005a9 <panic>
801010c8:	8b 45 08             	mov    0x8(%ebp),%eax
801010cb:	8b 40 04             	mov    0x4(%eax),%eax
801010ce:	8d 50 ff             	lea    -0x1(%eax),%edx
801010d1:	8b 45 08             	mov    0x8(%ebp),%eax
801010d4:	89 50 04             	mov    %edx,0x4(%eax)
801010d7:	8b 45 08             	mov    0x8(%ebp),%eax
801010da:	8b 40 04             	mov    0x4(%eax),%eax
801010dd:	85 c0                	test   %eax,%eax
801010df:	7e 15                	jle    801010f6 <fileclose+0x5b>
801010e1:	83 ec 0c             	sub    $0xc,%esp
801010e4:	68 a0 1a 19 80       	push   $0x80191aa0
801010e9:	e8 e8 38 00 00       	call   801049d6 <release>
801010ee:	83 c4 10             	add    $0x10,%esp
801010f1:	e9 8b 00 00 00       	jmp    80101181 <fileclose+0xe6>
801010f6:	8b 45 08             	mov    0x8(%ebp),%eax
801010f9:	8b 10                	mov    (%eax),%edx
801010fb:	89 55 e0             	mov    %edx,-0x20(%ebp)
801010fe:	8b 50 04             	mov    0x4(%eax),%edx
80101101:	89 55 e4             	mov    %edx,-0x1c(%ebp)
80101104:	8b 50 08             	mov    0x8(%eax),%edx
80101107:	89 55 e8             	mov    %edx,-0x18(%ebp)
8010110a:	8b 50 0c             	mov    0xc(%eax),%edx
8010110d:	89 55 ec             	mov    %edx,-0x14(%ebp)
80101110:	8b 50 10             	mov    0x10(%eax),%edx
80101113:	89 55 f0             	mov    %edx,-0x10(%ebp)
80101116:	8b 40 14             	mov    0x14(%eax),%eax
80101119:	89 45 f4             	mov    %eax,-0xc(%ebp)
8010111c:	8b 45 08             	mov    0x8(%ebp),%eax
8010111f:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
80101126:	8b 45 08             	mov    0x8(%ebp),%eax
80101129:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
8010112f:	83 ec 0c             	sub    $0xc,%esp
80101132:	68 a0 1a 19 80       	push   $0x80191aa0
80101137:	e8 9a 38 00 00       	call   801049d6 <release>
8010113c:	83 c4 10             	add    $0x10,%esp
8010113f:	8b 45 e0             	mov    -0x20(%ebp),%eax
80101142:	83 f8 01             	cmp    $0x1,%eax
80101145:	75 19                	jne    80101160 <fileclose+0xc5>
80101147:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
8010114b:	0f be d0             	movsbl %al,%edx
8010114e:	8b 45 ec             	mov    -0x14(%ebp),%eax
80101151:	83 ec 08             	sub    $0x8,%esp
80101154:	52                   	push   %edx
80101155:	50                   	push   %eax
80101156:	e8 64 25 00 00       	call   801036bf <pipeclose>
8010115b:	83 c4 10             	add    $0x10,%esp
8010115e:	eb 21                	jmp    80101181 <fileclose+0xe6>
80101160:	8b 45 e0             	mov    -0x20(%ebp),%eax
80101163:	83 f8 02             	cmp    $0x2,%eax
80101166:	75 19                	jne    80101181 <fileclose+0xe6>
80101168:	e8 cf 1e 00 00       	call   8010303c <begin_op>
8010116d:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101170:	83 ec 0c             	sub    $0xc,%esp
80101173:	50                   	push   %eax
80101174:	e8 d2 09 00 00       	call   80101b4b <iput>
80101179:	83 c4 10             	add    $0x10,%esp
8010117c:	e8 47 1f 00 00       	call   801030c8 <end_op>
80101181:	c9                   	leave  
80101182:	c3                   	ret    

80101183 <filestat>:
80101183:	55                   	push   %ebp
80101184:	89 e5                	mov    %esp,%ebp
80101186:	83 ec 08             	sub    $0x8,%esp
80101189:	8b 45 08             	mov    0x8(%ebp),%eax
8010118c:	8b 00                	mov    (%eax),%eax
8010118e:	83 f8 02             	cmp    $0x2,%eax
80101191:	75 40                	jne    801011d3 <filestat+0x50>
80101193:	8b 45 08             	mov    0x8(%ebp),%eax
80101196:	8b 40 10             	mov    0x10(%eax),%eax
80101199:	83 ec 0c             	sub    $0xc,%esp
8010119c:	50                   	push   %eax
8010119d:	e8 48 08 00 00       	call   801019ea <ilock>
801011a2:	83 c4 10             	add    $0x10,%esp
801011a5:	8b 45 08             	mov    0x8(%ebp),%eax
801011a8:	8b 40 10             	mov    0x10(%eax),%eax
801011ab:	83 ec 08             	sub    $0x8,%esp
801011ae:	ff 75 0c             	push   0xc(%ebp)
801011b1:	50                   	push   %eax
801011b2:	e8 d9 0c 00 00       	call   80101e90 <stati>
801011b7:	83 c4 10             	add    $0x10,%esp
801011ba:	8b 45 08             	mov    0x8(%ebp),%eax
801011bd:	8b 40 10             	mov    0x10(%eax),%eax
801011c0:	83 ec 0c             	sub    $0xc,%esp
801011c3:	50                   	push   %eax
801011c4:	e8 34 09 00 00       	call   80101afd <iunlock>
801011c9:	83 c4 10             	add    $0x10,%esp
801011cc:	b8 00 00 00 00       	mov    $0x0,%eax
801011d1:	eb 05                	jmp    801011d8 <filestat+0x55>
801011d3:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801011d8:	c9                   	leave  
801011d9:	c3                   	ret    

801011da <fileread>:
801011da:	55                   	push   %ebp
801011db:	89 e5                	mov    %esp,%ebp
801011dd:	83 ec 18             	sub    $0x18,%esp
801011e0:	8b 45 08             	mov    0x8(%ebp),%eax
801011e3:	0f b6 40 08          	movzbl 0x8(%eax),%eax
801011e7:	84 c0                	test   %al,%al
801011e9:	75 0a                	jne    801011f5 <fileread+0x1b>
801011eb:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801011f0:	e9 9b 00 00 00       	jmp    80101290 <fileread+0xb6>
801011f5:	8b 45 08             	mov    0x8(%ebp),%eax
801011f8:	8b 00                	mov    (%eax),%eax
801011fa:	83 f8 01             	cmp    $0x1,%eax
801011fd:	75 1a                	jne    80101219 <fileread+0x3f>
801011ff:	8b 45 08             	mov    0x8(%ebp),%eax
80101202:	8b 40 0c             	mov    0xc(%eax),%eax
80101205:	83 ec 04             	sub    $0x4,%esp
80101208:	ff 75 10             	push   0x10(%ebp)
8010120b:	ff 75 0c             	push   0xc(%ebp)
8010120e:	50                   	push   %eax
8010120f:	e8 58 26 00 00       	call   8010386c <piperead>
80101214:	83 c4 10             	add    $0x10,%esp
80101217:	eb 77                	jmp    80101290 <fileread+0xb6>
80101219:	8b 45 08             	mov    0x8(%ebp),%eax
8010121c:	8b 00                	mov    (%eax),%eax
8010121e:	83 f8 02             	cmp    $0x2,%eax
80101221:	75 60                	jne    80101283 <fileread+0xa9>
80101223:	8b 45 08             	mov    0x8(%ebp),%eax
80101226:	8b 40 10             	mov    0x10(%eax),%eax
80101229:	83 ec 0c             	sub    $0xc,%esp
8010122c:	50                   	push   %eax
8010122d:	e8 b8 07 00 00       	call   801019ea <ilock>
80101232:	83 c4 10             	add    $0x10,%esp
80101235:	8b 4d 10             	mov    0x10(%ebp),%ecx
80101238:	8b 45 08             	mov    0x8(%ebp),%eax
8010123b:	8b 50 14             	mov    0x14(%eax),%edx
8010123e:	8b 45 08             	mov    0x8(%ebp),%eax
80101241:	8b 40 10             	mov    0x10(%eax),%eax
80101244:	51                   	push   %ecx
80101245:	52                   	push   %edx
80101246:	ff 75 0c             	push   0xc(%ebp)
80101249:	50                   	push   %eax
8010124a:	e8 87 0c 00 00       	call   80101ed6 <readi>
8010124f:	83 c4 10             	add    $0x10,%esp
80101252:	89 45 f4             	mov    %eax,-0xc(%ebp)
80101255:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80101259:	7e 11                	jle    8010126c <fileread+0x92>
8010125b:	8b 45 08             	mov    0x8(%ebp),%eax
8010125e:	8b 50 14             	mov    0x14(%eax),%edx
80101261:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101264:	01 c2                	add    %eax,%edx
80101266:	8b 45 08             	mov    0x8(%ebp),%eax
80101269:	89 50 14             	mov    %edx,0x14(%eax)
8010126c:	8b 45 08             	mov    0x8(%ebp),%eax
8010126f:	8b 40 10             	mov    0x10(%eax),%eax
80101272:	83 ec 0c             	sub    $0xc,%esp
80101275:	50                   	push   %eax
80101276:	e8 82 08 00 00       	call   80101afd <iunlock>
8010127b:	83 c4 10             	add    $0x10,%esp
8010127e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101281:	eb 0d                	jmp    80101290 <fileread+0xb6>
80101283:	83 ec 0c             	sub    $0xc,%esp
80101286:	68 fa a2 10 80       	push   $0x8010a2fa
8010128b:	e8 19 f3 ff ff       	call   801005a9 <panic>
80101290:	c9                   	leave  
80101291:	c3                   	ret    

80101292 <filewrite>:
80101292:	55                   	push   %ebp
80101293:	89 e5                	mov    %esp,%ebp
80101295:	53                   	push   %ebx
80101296:	83 ec 14             	sub    $0x14,%esp
80101299:	8b 45 08             	mov    0x8(%ebp),%eax
8010129c:	0f b6 40 09          	movzbl 0x9(%eax),%eax
801012a0:	84 c0                	test   %al,%al
801012a2:	75 0a                	jne    801012ae <filewrite+0x1c>
801012a4:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801012a9:	e9 1b 01 00 00       	jmp    801013c9 <filewrite+0x137>
801012ae:	8b 45 08             	mov    0x8(%ebp),%eax
801012b1:	8b 00                	mov    (%eax),%eax
801012b3:	83 f8 01             	cmp    $0x1,%eax
801012b6:	75 1d                	jne    801012d5 <filewrite+0x43>
801012b8:	8b 45 08             	mov    0x8(%ebp),%eax
801012bb:	8b 40 0c             	mov    0xc(%eax),%eax
801012be:	83 ec 04             	sub    $0x4,%esp
801012c1:	ff 75 10             	push   0x10(%ebp)
801012c4:	ff 75 0c             	push   0xc(%ebp)
801012c7:	50                   	push   %eax
801012c8:	e8 9d 24 00 00       	call   8010376a <pipewrite>
801012cd:	83 c4 10             	add    $0x10,%esp
801012d0:	e9 f4 00 00 00       	jmp    801013c9 <filewrite+0x137>
801012d5:	8b 45 08             	mov    0x8(%ebp),%eax
801012d8:	8b 00                	mov    (%eax),%eax
801012da:	83 f8 02             	cmp    $0x2,%eax
801012dd:	0f 85 d9 00 00 00    	jne    801013bc <filewrite+0x12a>
801012e3:	c7 45 ec 00 06 00 00 	movl   $0x600,-0x14(%ebp)
801012ea:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
801012f1:	e9 a3 00 00 00       	jmp    80101399 <filewrite+0x107>
801012f6:	8b 45 10             	mov    0x10(%ebp),%eax
801012f9:	2b 45 f4             	sub    -0xc(%ebp),%eax
801012fc:	89 45 f0             	mov    %eax,-0x10(%ebp)
801012ff:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101302:	3b 45 ec             	cmp    -0x14(%ebp),%eax
80101305:	7e 06                	jle    8010130d <filewrite+0x7b>
80101307:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010130a:	89 45 f0             	mov    %eax,-0x10(%ebp)
8010130d:	e8 2a 1d 00 00       	call   8010303c <begin_op>
80101312:	8b 45 08             	mov    0x8(%ebp),%eax
80101315:	8b 40 10             	mov    0x10(%eax),%eax
80101318:	83 ec 0c             	sub    $0xc,%esp
8010131b:	50                   	push   %eax
8010131c:	e8 c9 06 00 00       	call   801019ea <ilock>
80101321:	83 c4 10             	add    $0x10,%esp
80101324:	8b 4d f0             	mov    -0x10(%ebp),%ecx
80101327:	8b 45 08             	mov    0x8(%ebp),%eax
8010132a:	8b 50 14             	mov    0x14(%eax),%edx
8010132d:	8b 5d f4             	mov    -0xc(%ebp),%ebx
80101330:	8b 45 0c             	mov    0xc(%ebp),%eax
80101333:	01 c3                	add    %eax,%ebx
80101335:	8b 45 08             	mov    0x8(%ebp),%eax
80101338:	8b 40 10             	mov    0x10(%eax),%eax
8010133b:	51                   	push   %ecx
8010133c:	52                   	push   %edx
8010133d:	53                   	push   %ebx
8010133e:	50                   	push   %eax
8010133f:	e8 e7 0c 00 00       	call   8010202b <writei>
80101344:	83 c4 10             	add    $0x10,%esp
80101347:	89 45 e8             	mov    %eax,-0x18(%ebp)
8010134a:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
8010134e:	7e 11                	jle    80101361 <filewrite+0xcf>
80101350:	8b 45 08             	mov    0x8(%ebp),%eax
80101353:	8b 50 14             	mov    0x14(%eax),%edx
80101356:	8b 45 e8             	mov    -0x18(%ebp),%eax
80101359:	01 c2                	add    %eax,%edx
8010135b:	8b 45 08             	mov    0x8(%ebp),%eax
8010135e:	89 50 14             	mov    %edx,0x14(%eax)
80101361:	8b 45 08             	mov    0x8(%ebp),%eax
80101364:	8b 40 10             	mov    0x10(%eax),%eax
80101367:	83 ec 0c             	sub    $0xc,%esp
8010136a:	50                   	push   %eax
8010136b:	e8 8d 07 00 00       	call   80101afd <iunlock>
80101370:	83 c4 10             	add    $0x10,%esp
80101373:	e8 50 1d 00 00       	call   801030c8 <end_op>
80101378:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
8010137c:	78 29                	js     801013a7 <filewrite+0x115>
8010137e:	8b 45 e8             	mov    -0x18(%ebp),%eax
80101381:	3b 45 f0             	cmp    -0x10(%ebp),%eax
80101384:	74 0d                	je     80101393 <filewrite+0x101>
80101386:	83 ec 0c             	sub    $0xc,%esp
80101389:	68 03 a3 10 80       	push   $0x8010a303
8010138e:	e8 16 f2 ff ff       	call   801005a9 <panic>
80101393:	8b 45 e8             	mov    -0x18(%ebp),%eax
80101396:	01 45 f4             	add    %eax,-0xc(%ebp)
80101399:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010139c:	3b 45 10             	cmp    0x10(%ebp),%eax
8010139f:	0f 8c 51 ff ff ff    	jl     801012f6 <filewrite+0x64>
801013a5:	eb 01                	jmp    801013a8 <filewrite+0x116>
801013a7:	90                   	nop
801013a8:	8b 45 f4             	mov    -0xc(%ebp),%eax
801013ab:	3b 45 10             	cmp    0x10(%ebp),%eax
801013ae:	75 05                	jne    801013b5 <filewrite+0x123>
801013b0:	8b 45 10             	mov    0x10(%ebp),%eax
801013b3:	eb 14                	jmp    801013c9 <filewrite+0x137>
801013b5:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801013ba:	eb 0d                	jmp    801013c9 <filewrite+0x137>
801013bc:	83 ec 0c             	sub    $0xc,%esp
801013bf:	68 13 a3 10 80       	push   $0x8010a313
801013c4:	e8 e0 f1 ff ff       	call   801005a9 <panic>
801013c9:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801013cc:	c9                   	leave  
801013cd:	c3                   	ret    

801013ce <readsb>:
801013ce:	55                   	push   %ebp
801013cf:	89 e5                	mov    %esp,%ebp
801013d1:	83 ec 18             	sub    $0x18,%esp
801013d4:	8b 45 08             	mov    0x8(%ebp),%eax
801013d7:	83 ec 08             	sub    $0x8,%esp
801013da:	6a 01                	push   $0x1
801013dc:	50                   	push   %eax
801013dd:	e8 1f ee ff ff       	call   80100201 <bread>
801013e2:	83 c4 10             	add    $0x10,%esp
801013e5:	89 45 f4             	mov    %eax,-0xc(%ebp)
801013e8:	8b 45 f4             	mov    -0xc(%ebp),%eax
801013eb:	83 c0 5c             	add    $0x5c,%eax
801013ee:	83 ec 04             	sub    $0x4,%esp
801013f1:	6a 1c                	push   $0x1c
801013f3:	50                   	push   %eax
801013f4:	ff 75 0c             	push   0xc(%ebp)
801013f7:	e8 a1 38 00 00       	call   80104c9d <memmove>
801013fc:	83 c4 10             	add    $0x10,%esp
801013ff:	83 ec 0c             	sub    $0xc,%esp
80101402:	ff 75 f4             	push   -0xc(%ebp)
80101405:	e8 79 ee ff ff       	call   80100283 <brelse>
8010140a:	83 c4 10             	add    $0x10,%esp
8010140d:	90                   	nop
8010140e:	c9                   	leave  
8010140f:	c3                   	ret    

80101410 <bzero>:
80101410:	55                   	push   %ebp
80101411:	89 e5                	mov    %esp,%ebp
80101413:	83 ec 18             	sub    $0x18,%esp
80101416:	8b 55 0c             	mov    0xc(%ebp),%edx
80101419:	8b 45 08             	mov    0x8(%ebp),%eax
8010141c:	83 ec 08             	sub    $0x8,%esp
8010141f:	52                   	push   %edx
80101420:	50                   	push   %eax
80101421:	e8 db ed ff ff       	call   80100201 <bread>
80101426:	83 c4 10             	add    $0x10,%esp
80101429:	89 45 f4             	mov    %eax,-0xc(%ebp)
8010142c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010142f:	83 c0 5c             	add    $0x5c,%eax
80101432:	83 ec 04             	sub    $0x4,%esp
80101435:	68 00 02 00 00       	push   $0x200
8010143a:	6a 00                	push   $0x0
8010143c:	50                   	push   %eax
8010143d:	e8 9c 37 00 00       	call   80104bde <memset>
80101442:	83 c4 10             	add    $0x10,%esp
80101445:	83 ec 0c             	sub    $0xc,%esp
80101448:	ff 75 f4             	push   -0xc(%ebp)
8010144b:	e8 25 1e 00 00       	call   80103275 <log_write>
80101450:	83 c4 10             	add    $0x10,%esp
80101453:	83 ec 0c             	sub    $0xc,%esp
80101456:	ff 75 f4             	push   -0xc(%ebp)
80101459:	e8 25 ee ff ff       	call   80100283 <brelse>
8010145e:	83 c4 10             	add    $0x10,%esp
80101461:	90                   	nop
80101462:	c9                   	leave  
80101463:	c3                   	ret    

80101464 <balloc>:
80101464:	55                   	push   %ebp
80101465:	89 e5                	mov    %esp,%ebp
80101467:	83 ec 18             	sub    $0x18,%esp
8010146a:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
80101471:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80101478:	e9 0b 01 00 00       	jmp    80101588 <balloc+0x124>
8010147d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101480:	8d 90 ff 0f 00 00    	lea    0xfff(%eax),%edx
80101486:	85 c0                	test   %eax,%eax
80101488:	0f 48 c2             	cmovs  %edx,%eax
8010148b:	c1 f8 0c             	sar    $0xc,%eax
8010148e:	89 c2                	mov    %eax,%edx
80101490:	a1 58 24 19 80       	mov    0x80192458,%eax
80101495:	01 d0                	add    %edx,%eax
80101497:	83 ec 08             	sub    $0x8,%esp
8010149a:	50                   	push   %eax
8010149b:	ff 75 08             	push   0x8(%ebp)
8010149e:	e8 5e ed ff ff       	call   80100201 <bread>
801014a3:	83 c4 10             	add    $0x10,%esp
801014a6:	89 45 ec             	mov    %eax,-0x14(%ebp)
801014a9:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
801014b0:	e9 9e 00 00 00       	jmp    80101553 <balloc+0xef>
801014b5:	8b 45 f0             	mov    -0x10(%ebp),%eax
801014b8:	83 e0 07             	and    $0x7,%eax
801014bb:	ba 01 00 00 00       	mov    $0x1,%edx
801014c0:	89 c1                	mov    %eax,%ecx
801014c2:	d3 e2                	shl    %cl,%edx
801014c4:	89 d0                	mov    %edx,%eax
801014c6:	89 45 e8             	mov    %eax,-0x18(%ebp)
801014c9:	8b 45 f0             	mov    -0x10(%ebp),%eax
801014cc:	8d 50 07             	lea    0x7(%eax),%edx
801014cf:	85 c0                	test   %eax,%eax
801014d1:	0f 48 c2             	cmovs  %edx,%eax
801014d4:	c1 f8 03             	sar    $0x3,%eax
801014d7:	89 c2                	mov    %eax,%edx
801014d9:	8b 45 ec             	mov    -0x14(%ebp),%eax
801014dc:	0f b6 44 10 5c       	movzbl 0x5c(%eax,%edx,1),%eax
801014e1:	0f b6 c0             	movzbl %al,%eax
801014e4:	23 45 e8             	and    -0x18(%ebp),%eax
801014e7:	85 c0                	test   %eax,%eax
801014e9:	75 64                	jne    8010154f <balloc+0xeb>
801014eb:	8b 45 f0             	mov    -0x10(%ebp),%eax
801014ee:	8d 50 07             	lea    0x7(%eax),%edx
801014f1:	85 c0                	test   %eax,%eax
801014f3:	0f 48 c2             	cmovs  %edx,%eax
801014f6:	c1 f8 03             	sar    $0x3,%eax
801014f9:	8b 55 ec             	mov    -0x14(%ebp),%edx
801014fc:	0f b6 54 02 5c       	movzbl 0x5c(%edx,%eax,1),%edx
80101501:	89 d1                	mov    %edx,%ecx
80101503:	8b 55 e8             	mov    -0x18(%ebp),%edx
80101506:	09 ca                	or     %ecx,%edx
80101508:	89 d1                	mov    %edx,%ecx
8010150a:	8b 55 ec             	mov    -0x14(%ebp),%edx
8010150d:	88 4c 02 5c          	mov    %cl,0x5c(%edx,%eax,1)
80101511:	83 ec 0c             	sub    $0xc,%esp
80101514:	ff 75 ec             	push   -0x14(%ebp)
80101517:	e8 59 1d 00 00       	call   80103275 <log_write>
8010151c:	83 c4 10             	add    $0x10,%esp
8010151f:	83 ec 0c             	sub    $0xc,%esp
80101522:	ff 75 ec             	push   -0x14(%ebp)
80101525:	e8 59 ed ff ff       	call   80100283 <brelse>
8010152a:	83 c4 10             	add    $0x10,%esp
8010152d:	8b 55 f4             	mov    -0xc(%ebp),%edx
80101530:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101533:	01 c2                	add    %eax,%edx
80101535:	8b 45 08             	mov    0x8(%ebp),%eax
80101538:	83 ec 08             	sub    $0x8,%esp
8010153b:	52                   	push   %edx
8010153c:	50                   	push   %eax
8010153d:	e8 ce fe ff ff       	call   80101410 <bzero>
80101542:	83 c4 10             	add    $0x10,%esp
80101545:	8b 55 f4             	mov    -0xc(%ebp),%edx
80101548:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010154b:	01 d0                	add    %edx,%eax
8010154d:	eb 57                	jmp    801015a6 <balloc+0x142>
8010154f:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
80101553:	81 7d f0 ff 0f 00 00 	cmpl   $0xfff,-0x10(%ebp)
8010155a:	7f 17                	jg     80101573 <balloc+0x10f>
8010155c:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010155f:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101562:	01 d0                	add    %edx,%eax
80101564:	89 c2                	mov    %eax,%edx
80101566:	a1 40 24 19 80       	mov    0x80192440,%eax
8010156b:	39 c2                	cmp    %eax,%edx
8010156d:	0f 82 42 ff ff ff    	jb     801014b5 <balloc+0x51>
80101573:	83 ec 0c             	sub    $0xc,%esp
80101576:	ff 75 ec             	push   -0x14(%ebp)
80101579:	e8 05 ed ff ff       	call   80100283 <brelse>
8010157e:	83 c4 10             	add    $0x10,%esp
80101581:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
80101588:	8b 15 40 24 19 80    	mov    0x80192440,%edx
8010158e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101591:	39 c2                	cmp    %eax,%edx
80101593:	0f 87 e4 fe ff ff    	ja     8010147d <balloc+0x19>
80101599:	83 ec 0c             	sub    $0xc,%esp
8010159c:	68 20 a3 10 80       	push   $0x8010a320
801015a1:	e8 03 f0 ff ff       	call   801005a9 <panic>
801015a6:	c9                   	leave  
801015a7:	c3                   	ret    

801015a8 <bfree>:
801015a8:	55                   	push   %ebp
801015a9:	89 e5                	mov    %esp,%ebp
801015ab:	83 ec 18             	sub    $0x18,%esp
801015ae:	83 ec 08             	sub    $0x8,%esp
801015b1:	68 40 24 19 80       	push   $0x80192440
801015b6:	ff 75 08             	push   0x8(%ebp)
801015b9:	e8 10 fe ff ff       	call   801013ce <readsb>
801015be:	83 c4 10             	add    $0x10,%esp
801015c1:	8b 45 0c             	mov    0xc(%ebp),%eax
801015c4:	c1 e8 0c             	shr    $0xc,%eax
801015c7:	89 c2                	mov    %eax,%edx
801015c9:	a1 58 24 19 80       	mov    0x80192458,%eax
801015ce:	01 c2                	add    %eax,%edx
801015d0:	8b 45 08             	mov    0x8(%ebp),%eax
801015d3:	83 ec 08             	sub    $0x8,%esp
801015d6:	52                   	push   %edx
801015d7:	50                   	push   %eax
801015d8:	e8 24 ec ff ff       	call   80100201 <bread>
801015dd:	83 c4 10             	add    $0x10,%esp
801015e0:	89 45 f4             	mov    %eax,-0xc(%ebp)
801015e3:	8b 45 0c             	mov    0xc(%ebp),%eax
801015e6:	25 ff 0f 00 00       	and    $0xfff,%eax
801015eb:	89 45 f0             	mov    %eax,-0x10(%ebp)
801015ee:	8b 45 f0             	mov    -0x10(%ebp),%eax
801015f1:	83 e0 07             	and    $0x7,%eax
801015f4:	ba 01 00 00 00       	mov    $0x1,%edx
801015f9:	89 c1                	mov    %eax,%ecx
801015fb:	d3 e2                	shl    %cl,%edx
801015fd:	89 d0                	mov    %edx,%eax
801015ff:	89 45 ec             	mov    %eax,-0x14(%ebp)
80101602:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101605:	8d 50 07             	lea    0x7(%eax),%edx
80101608:	85 c0                	test   %eax,%eax
8010160a:	0f 48 c2             	cmovs  %edx,%eax
8010160d:	c1 f8 03             	sar    $0x3,%eax
80101610:	89 c2                	mov    %eax,%edx
80101612:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101615:	0f b6 44 10 5c       	movzbl 0x5c(%eax,%edx,1),%eax
8010161a:	0f b6 c0             	movzbl %al,%eax
8010161d:	23 45 ec             	and    -0x14(%ebp),%eax
80101620:	85 c0                	test   %eax,%eax
80101622:	75 0d                	jne    80101631 <bfree+0x89>
80101624:	83 ec 0c             	sub    $0xc,%esp
80101627:	68 36 a3 10 80       	push   $0x8010a336
8010162c:	e8 78 ef ff ff       	call   801005a9 <panic>
80101631:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101634:	8d 50 07             	lea    0x7(%eax),%edx
80101637:	85 c0                	test   %eax,%eax
80101639:	0f 48 c2             	cmovs  %edx,%eax
8010163c:	c1 f8 03             	sar    $0x3,%eax
8010163f:	8b 55 f4             	mov    -0xc(%ebp),%edx
80101642:	0f b6 54 02 5c       	movzbl 0x5c(%edx,%eax,1),%edx
80101647:	89 d1                	mov    %edx,%ecx
80101649:	8b 55 ec             	mov    -0x14(%ebp),%edx
8010164c:	f7 d2                	not    %edx
8010164e:	21 ca                	and    %ecx,%edx
80101650:	89 d1                	mov    %edx,%ecx
80101652:	8b 55 f4             	mov    -0xc(%ebp),%edx
80101655:	88 4c 02 5c          	mov    %cl,0x5c(%edx,%eax,1)
80101659:	83 ec 0c             	sub    $0xc,%esp
8010165c:	ff 75 f4             	push   -0xc(%ebp)
8010165f:	e8 11 1c 00 00       	call   80103275 <log_write>
80101664:	83 c4 10             	add    $0x10,%esp
80101667:	83 ec 0c             	sub    $0xc,%esp
8010166a:	ff 75 f4             	push   -0xc(%ebp)
8010166d:	e8 11 ec ff ff       	call   80100283 <brelse>
80101672:	83 c4 10             	add    $0x10,%esp
80101675:	90                   	nop
80101676:	c9                   	leave  
80101677:	c3                   	ret    

80101678 <iinit>:
80101678:	55                   	push   %ebp
80101679:	89 e5                	mov    %esp,%ebp
8010167b:	57                   	push   %edi
8010167c:	56                   	push   %esi
8010167d:	53                   	push   %ebx
8010167e:	83 ec 2c             	sub    $0x2c,%esp
80101681:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
80101688:	83 ec 08             	sub    $0x8,%esp
8010168b:	68 49 a3 10 80       	push   $0x8010a349
80101690:	68 60 24 19 80       	push   $0x80192460
80101695:	e8 ac 32 00 00       	call   80104946 <initlock>
8010169a:	83 c4 10             	add    $0x10,%esp
8010169d:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
801016a4:	eb 2d                	jmp    801016d3 <iinit+0x5b>
801016a6:	8b 55 e4             	mov    -0x1c(%ebp),%edx
801016a9:	89 d0                	mov    %edx,%eax
801016ab:	c1 e0 03             	shl    $0x3,%eax
801016ae:	01 d0                	add    %edx,%eax
801016b0:	c1 e0 04             	shl    $0x4,%eax
801016b3:	83 c0 30             	add    $0x30,%eax
801016b6:	05 60 24 19 80       	add    $0x80192460,%eax
801016bb:	83 c0 10             	add    $0x10,%eax
801016be:	83 ec 08             	sub    $0x8,%esp
801016c1:	68 50 a3 10 80       	push   $0x8010a350
801016c6:	50                   	push   %eax
801016c7:	e8 1d 31 00 00       	call   801047e9 <initsleeplock>
801016cc:	83 c4 10             	add    $0x10,%esp
801016cf:	83 45 e4 01          	addl   $0x1,-0x1c(%ebp)
801016d3:	83 7d e4 31          	cmpl   $0x31,-0x1c(%ebp)
801016d7:	7e cd                	jle    801016a6 <iinit+0x2e>
801016d9:	83 ec 08             	sub    $0x8,%esp
801016dc:	68 40 24 19 80       	push   $0x80192440
801016e1:	ff 75 08             	push   0x8(%ebp)
801016e4:	e8 e5 fc ff ff       	call   801013ce <readsb>
801016e9:	83 c4 10             	add    $0x10,%esp
801016ec:	a1 58 24 19 80       	mov    0x80192458,%eax
801016f1:	89 45 d4             	mov    %eax,-0x2c(%ebp)
801016f4:	8b 3d 54 24 19 80    	mov    0x80192454,%edi
801016fa:	8b 35 50 24 19 80    	mov    0x80192450,%esi
80101700:	8b 1d 4c 24 19 80    	mov    0x8019244c,%ebx
80101706:	8b 0d 48 24 19 80    	mov    0x80192448,%ecx
8010170c:	8b 15 44 24 19 80    	mov    0x80192444,%edx
80101712:	a1 40 24 19 80       	mov    0x80192440,%eax
80101717:	ff 75 d4             	push   -0x2c(%ebp)
8010171a:	57                   	push   %edi
8010171b:	56                   	push   %esi
8010171c:	53                   	push   %ebx
8010171d:	51                   	push   %ecx
8010171e:	52                   	push   %edx
8010171f:	50                   	push   %eax
80101720:	68 58 a3 10 80       	push   $0x8010a358
80101725:	e8 ca ec ff ff       	call   801003f4 <cprintf>
8010172a:	83 c4 20             	add    $0x20,%esp
8010172d:	90                   	nop
8010172e:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101731:	5b                   	pop    %ebx
80101732:	5e                   	pop    %esi
80101733:	5f                   	pop    %edi
80101734:	5d                   	pop    %ebp
80101735:	c3                   	ret    

80101736 <ialloc>:
80101736:	55                   	push   %ebp
80101737:	89 e5                	mov    %esp,%ebp
80101739:	83 ec 28             	sub    $0x28,%esp
8010173c:	8b 45 0c             	mov    0xc(%ebp),%eax
8010173f:	66 89 45 e4          	mov    %ax,-0x1c(%ebp)
80101743:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
8010174a:	e9 9e 00 00 00       	jmp    801017ed <ialloc+0xb7>
8010174f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101752:	c1 e8 03             	shr    $0x3,%eax
80101755:	89 c2                	mov    %eax,%edx
80101757:	a1 54 24 19 80       	mov    0x80192454,%eax
8010175c:	01 d0                	add    %edx,%eax
8010175e:	83 ec 08             	sub    $0x8,%esp
80101761:	50                   	push   %eax
80101762:	ff 75 08             	push   0x8(%ebp)
80101765:	e8 97 ea ff ff       	call   80100201 <bread>
8010176a:	83 c4 10             	add    $0x10,%esp
8010176d:	89 45 f0             	mov    %eax,-0x10(%ebp)
80101770:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101773:	8d 50 5c             	lea    0x5c(%eax),%edx
80101776:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101779:	83 e0 07             	and    $0x7,%eax
8010177c:	c1 e0 06             	shl    $0x6,%eax
8010177f:	01 d0                	add    %edx,%eax
80101781:	89 45 ec             	mov    %eax,-0x14(%ebp)
80101784:	8b 45 ec             	mov    -0x14(%ebp),%eax
80101787:	0f b7 00             	movzwl (%eax),%eax
8010178a:	66 85 c0             	test   %ax,%ax
8010178d:	75 4c                	jne    801017db <ialloc+0xa5>
8010178f:	83 ec 04             	sub    $0x4,%esp
80101792:	6a 40                	push   $0x40
80101794:	6a 00                	push   $0x0
80101796:	ff 75 ec             	push   -0x14(%ebp)
80101799:	e8 40 34 00 00       	call   80104bde <memset>
8010179e:	83 c4 10             	add    $0x10,%esp
801017a1:	8b 45 ec             	mov    -0x14(%ebp),%eax
801017a4:	0f b7 55 e4          	movzwl -0x1c(%ebp),%edx
801017a8:	66 89 10             	mov    %dx,(%eax)
801017ab:	83 ec 0c             	sub    $0xc,%esp
801017ae:	ff 75 f0             	push   -0x10(%ebp)
801017b1:	e8 bf 1a 00 00       	call   80103275 <log_write>
801017b6:	83 c4 10             	add    $0x10,%esp
801017b9:	83 ec 0c             	sub    $0xc,%esp
801017bc:	ff 75 f0             	push   -0x10(%ebp)
801017bf:	e8 bf ea ff ff       	call   80100283 <brelse>
801017c4:	83 c4 10             	add    $0x10,%esp
801017c7:	8b 45 f4             	mov    -0xc(%ebp),%eax
801017ca:	83 ec 08             	sub    $0x8,%esp
801017cd:	50                   	push   %eax
801017ce:	ff 75 08             	push   0x8(%ebp)
801017d1:	e8 f8 00 00 00       	call   801018ce <iget>
801017d6:	83 c4 10             	add    $0x10,%esp
801017d9:	eb 30                	jmp    8010180b <ialloc+0xd5>
801017db:	83 ec 0c             	sub    $0xc,%esp
801017de:	ff 75 f0             	push   -0x10(%ebp)
801017e1:	e8 9d ea ff ff       	call   80100283 <brelse>
801017e6:	83 c4 10             	add    $0x10,%esp
801017e9:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
801017ed:	8b 15 48 24 19 80    	mov    0x80192448,%edx
801017f3:	8b 45 f4             	mov    -0xc(%ebp),%eax
801017f6:	39 c2                	cmp    %eax,%edx
801017f8:	0f 87 51 ff ff ff    	ja     8010174f <ialloc+0x19>
801017fe:	83 ec 0c             	sub    $0xc,%esp
80101801:	68 ab a3 10 80       	push   $0x8010a3ab
80101806:	e8 9e ed ff ff       	call   801005a9 <panic>
8010180b:	c9                   	leave  
8010180c:	c3                   	ret    

8010180d <iupdate>:
8010180d:	55                   	push   %ebp
8010180e:	89 e5                	mov    %esp,%ebp
80101810:	83 ec 18             	sub    $0x18,%esp
80101813:	8b 45 08             	mov    0x8(%ebp),%eax
80101816:	8b 40 04             	mov    0x4(%eax),%eax
80101819:	c1 e8 03             	shr    $0x3,%eax
8010181c:	89 c2                	mov    %eax,%edx
8010181e:	a1 54 24 19 80       	mov    0x80192454,%eax
80101823:	01 c2                	add    %eax,%edx
80101825:	8b 45 08             	mov    0x8(%ebp),%eax
80101828:	8b 00                	mov    (%eax),%eax
8010182a:	83 ec 08             	sub    $0x8,%esp
8010182d:	52                   	push   %edx
8010182e:	50                   	push   %eax
8010182f:	e8 cd e9 ff ff       	call   80100201 <bread>
80101834:	83 c4 10             	add    $0x10,%esp
80101837:	89 45 f4             	mov    %eax,-0xc(%ebp)
8010183a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010183d:	8d 50 5c             	lea    0x5c(%eax),%edx
80101840:	8b 45 08             	mov    0x8(%ebp),%eax
80101843:	8b 40 04             	mov    0x4(%eax),%eax
80101846:	83 e0 07             	and    $0x7,%eax
80101849:	c1 e0 06             	shl    $0x6,%eax
8010184c:	01 d0                	add    %edx,%eax
8010184e:	89 45 f0             	mov    %eax,-0x10(%ebp)
80101851:	8b 45 08             	mov    0x8(%ebp),%eax
80101854:	0f b7 50 50          	movzwl 0x50(%eax),%edx
80101858:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010185b:	66 89 10             	mov    %dx,(%eax)
8010185e:	8b 45 08             	mov    0x8(%ebp),%eax
80101861:	0f b7 50 52          	movzwl 0x52(%eax),%edx
80101865:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101868:	66 89 50 02          	mov    %dx,0x2(%eax)
8010186c:	8b 45 08             	mov    0x8(%ebp),%eax
8010186f:	0f b7 50 54          	movzwl 0x54(%eax),%edx
80101873:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101876:	66 89 50 04          	mov    %dx,0x4(%eax)
8010187a:	8b 45 08             	mov    0x8(%ebp),%eax
8010187d:	0f b7 50 56          	movzwl 0x56(%eax),%edx
80101881:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101884:	66 89 50 06          	mov    %dx,0x6(%eax)
80101888:	8b 45 08             	mov    0x8(%ebp),%eax
8010188b:	8b 50 58             	mov    0x58(%eax),%edx
8010188e:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101891:	89 50 08             	mov    %edx,0x8(%eax)
80101894:	8b 45 08             	mov    0x8(%ebp),%eax
80101897:	8d 50 5c             	lea    0x5c(%eax),%edx
8010189a:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010189d:	83 c0 0c             	add    $0xc,%eax
801018a0:	83 ec 04             	sub    $0x4,%esp
801018a3:	6a 34                	push   $0x34
801018a5:	52                   	push   %edx
801018a6:	50                   	push   %eax
801018a7:	e8 f1 33 00 00       	call   80104c9d <memmove>
801018ac:	83 c4 10             	add    $0x10,%esp
801018af:	83 ec 0c             	sub    $0xc,%esp
801018b2:	ff 75 f4             	push   -0xc(%ebp)
801018b5:	e8 bb 19 00 00       	call   80103275 <log_write>
801018ba:	83 c4 10             	add    $0x10,%esp
801018bd:	83 ec 0c             	sub    $0xc,%esp
801018c0:	ff 75 f4             	push   -0xc(%ebp)
801018c3:	e8 bb e9 ff ff       	call   80100283 <brelse>
801018c8:	83 c4 10             	add    $0x10,%esp
801018cb:	90                   	nop
801018cc:	c9                   	leave  
801018cd:	c3                   	ret    

801018ce <iget>:
801018ce:	55                   	push   %ebp
801018cf:	89 e5                	mov    %esp,%ebp
801018d1:	83 ec 18             	sub    $0x18,%esp
801018d4:	83 ec 0c             	sub    $0xc,%esp
801018d7:	68 60 24 19 80       	push   $0x80192460
801018dc:	e8 87 30 00 00       	call   80104968 <acquire>
801018e1:	83 c4 10             	add    $0x10,%esp
801018e4:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
801018eb:	c7 45 f4 94 24 19 80 	movl   $0x80192494,-0xc(%ebp)
801018f2:	eb 60                	jmp    80101954 <iget+0x86>
801018f4:	8b 45 f4             	mov    -0xc(%ebp),%eax
801018f7:	8b 40 08             	mov    0x8(%eax),%eax
801018fa:	85 c0                	test   %eax,%eax
801018fc:	7e 39                	jle    80101937 <iget+0x69>
801018fe:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101901:	8b 00                	mov    (%eax),%eax
80101903:	39 45 08             	cmp    %eax,0x8(%ebp)
80101906:	75 2f                	jne    80101937 <iget+0x69>
80101908:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010190b:	8b 40 04             	mov    0x4(%eax),%eax
8010190e:	39 45 0c             	cmp    %eax,0xc(%ebp)
80101911:	75 24                	jne    80101937 <iget+0x69>
80101913:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101916:	8b 40 08             	mov    0x8(%eax),%eax
80101919:	8d 50 01             	lea    0x1(%eax),%edx
8010191c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010191f:	89 50 08             	mov    %edx,0x8(%eax)
80101922:	83 ec 0c             	sub    $0xc,%esp
80101925:	68 60 24 19 80       	push   $0x80192460
8010192a:	e8 a7 30 00 00       	call   801049d6 <release>
8010192f:	83 c4 10             	add    $0x10,%esp
80101932:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101935:	eb 77                	jmp    801019ae <iget+0xe0>
80101937:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
8010193b:	75 10                	jne    8010194d <iget+0x7f>
8010193d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101940:	8b 40 08             	mov    0x8(%eax),%eax
80101943:	85 c0                	test   %eax,%eax
80101945:	75 06                	jne    8010194d <iget+0x7f>
80101947:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010194a:	89 45 f0             	mov    %eax,-0x10(%ebp)
8010194d:	81 45 f4 90 00 00 00 	addl   $0x90,-0xc(%ebp)
80101954:	81 7d f4 b4 40 19 80 	cmpl   $0x801940b4,-0xc(%ebp)
8010195b:	72 97                	jb     801018f4 <iget+0x26>
8010195d:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80101961:	75 0d                	jne    80101970 <iget+0xa2>
80101963:	83 ec 0c             	sub    $0xc,%esp
80101966:	68 bd a3 10 80       	push   $0x8010a3bd
8010196b:	e8 39 ec ff ff       	call   801005a9 <panic>
80101970:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101973:	89 45 f4             	mov    %eax,-0xc(%ebp)
80101976:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101979:	8b 55 08             	mov    0x8(%ebp),%edx
8010197c:	89 10                	mov    %edx,(%eax)
8010197e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101981:	8b 55 0c             	mov    0xc(%ebp),%edx
80101984:	89 50 04             	mov    %edx,0x4(%eax)
80101987:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010198a:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)
80101991:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101994:	c7 40 4c 00 00 00 00 	movl   $0x0,0x4c(%eax)
8010199b:	83 ec 0c             	sub    $0xc,%esp
8010199e:	68 60 24 19 80       	push   $0x80192460
801019a3:	e8 2e 30 00 00       	call   801049d6 <release>
801019a8:	83 c4 10             	add    $0x10,%esp
801019ab:	8b 45 f4             	mov    -0xc(%ebp),%eax
801019ae:	c9                   	leave  
801019af:	c3                   	ret    

801019b0 <idup>:
801019b0:	55                   	push   %ebp
801019b1:	89 e5                	mov    %esp,%ebp
801019b3:	83 ec 08             	sub    $0x8,%esp
801019b6:	83 ec 0c             	sub    $0xc,%esp
801019b9:	68 60 24 19 80       	push   $0x80192460
801019be:	e8 a5 2f 00 00       	call   80104968 <acquire>
801019c3:	83 c4 10             	add    $0x10,%esp
801019c6:	8b 45 08             	mov    0x8(%ebp),%eax
801019c9:	8b 40 08             	mov    0x8(%eax),%eax
801019cc:	8d 50 01             	lea    0x1(%eax),%edx
801019cf:	8b 45 08             	mov    0x8(%ebp),%eax
801019d2:	89 50 08             	mov    %edx,0x8(%eax)
801019d5:	83 ec 0c             	sub    $0xc,%esp
801019d8:	68 60 24 19 80       	push   $0x80192460
801019dd:	e8 f4 2f 00 00       	call   801049d6 <release>
801019e2:	83 c4 10             	add    $0x10,%esp
801019e5:	8b 45 08             	mov    0x8(%ebp),%eax
801019e8:	c9                   	leave  
801019e9:	c3                   	ret    

801019ea <ilock>:
801019ea:	55                   	push   %ebp
801019eb:	89 e5                	mov    %esp,%ebp
801019ed:	83 ec 18             	sub    $0x18,%esp
801019f0:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
801019f4:	74 0a                	je     80101a00 <ilock+0x16>
801019f6:	8b 45 08             	mov    0x8(%ebp),%eax
801019f9:	8b 40 08             	mov    0x8(%eax),%eax
801019fc:	85 c0                	test   %eax,%eax
801019fe:	7f 0d                	jg     80101a0d <ilock+0x23>
80101a00:	83 ec 0c             	sub    $0xc,%esp
80101a03:	68 cd a3 10 80       	push   $0x8010a3cd
80101a08:	e8 9c eb ff ff       	call   801005a9 <panic>
80101a0d:	8b 45 08             	mov    0x8(%ebp),%eax
80101a10:	83 c0 0c             	add    $0xc,%eax
80101a13:	83 ec 0c             	sub    $0xc,%esp
80101a16:	50                   	push   %eax
80101a17:	e8 09 2e 00 00       	call   80104825 <acquiresleep>
80101a1c:	83 c4 10             	add    $0x10,%esp
80101a1f:	8b 45 08             	mov    0x8(%ebp),%eax
80101a22:	8b 40 4c             	mov    0x4c(%eax),%eax
80101a25:	85 c0                	test   %eax,%eax
80101a27:	0f 85 cd 00 00 00    	jne    80101afa <ilock+0x110>
80101a2d:	8b 45 08             	mov    0x8(%ebp),%eax
80101a30:	8b 40 04             	mov    0x4(%eax),%eax
80101a33:	c1 e8 03             	shr    $0x3,%eax
80101a36:	89 c2                	mov    %eax,%edx
80101a38:	a1 54 24 19 80       	mov    0x80192454,%eax
80101a3d:	01 c2                	add    %eax,%edx
80101a3f:	8b 45 08             	mov    0x8(%ebp),%eax
80101a42:	8b 00                	mov    (%eax),%eax
80101a44:	83 ec 08             	sub    $0x8,%esp
80101a47:	52                   	push   %edx
80101a48:	50                   	push   %eax
80101a49:	e8 b3 e7 ff ff       	call   80100201 <bread>
80101a4e:	83 c4 10             	add    $0x10,%esp
80101a51:	89 45 f4             	mov    %eax,-0xc(%ebp)
80101a54:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101a57:	8d 50 5c             	lea    0x5c(%eax),%edx
80101a5a:	8b 45 08             	mov    0x8(%ebp),%eax
80101a5d:	8b 40 04             	mov    0x4(%eax),%eax
80101a60:	83 e0 07             	and    $0x7,%eax
80101a63:	c1 e0 06             	shl    $0x6,%eax
80101a66:	01 d0                	add    %edx,%eax
80101a68:	89 45 f0             	mov    %eax,-0x10(%ebp)
80101a6b:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101a6e:	0f b7 10             	movzwl (%eax),%edx
80101a71:	8b 45 08             	mov    0x8(%ebp),%eax
80101a74:	66 89 50 50          	mov    %dx,0x50(%eax)
80101a78:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101a7b:	0f b7 50 02          	movzwl 0x2(%eax),%edx
80101a7f:	8b 45 08             	mov    0x8(%ebp),%eax
80101a82:	66 89 50 52          	mov    %dx,0x52(%eax)
80101a86:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101a89:	0f b7 50 04          	movzwl 0x4(%eax),%edx
80101a8d:	8b 45 08             	mov    0x8(%ebp),%eax
80101a90:	66 89 50 54          	mov    %dx,0x54(%eax)
80101a94:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101a97:	0f b7 50 06          	movzwl 0x6(%eax),%edx
80101a9b:	8b 45 08             	mov    0x8(%ebp),%eax
80101a9e:	66 89 50 56          	mov    %dx,0x56(%eax)
80101aa2:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101aa5:	8b 50 08             	mov    0x8(%eax),%edx
80101aa8:	8b 45 08             	mov    0x8(%ebp),%eax
80101aab:	89 50 58             	mov    %edx,0x58(%eax)
80101aae:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101ab1:	8d 50 0c             	lea    0xc(%eax),%edx
80101ab4:	8b 45 08             	mov    0x8(%ebp),%eax
80101ab7:	83 c0 5c             	add    $0x5c,%eax
80101aba:	83 ec 04             	sub    $0x4,%esp
80101abd:	6a 34                	push   $0x34
80101abf:	52                   	push   %edx
80101ac0:	50                   	push   %eax
80101ac1:	e8 d7 31 00 00       	call   80104c9d <memmove>
80101ac6:	83 c4 10             	add    $0x10,%esp
80101ac9:	83 ec 0c             	sub    $0xc,%esp
80101acc:	ff 75 f4             	push   -0xc(%ebp)
80101acf:	e8 af e7 ff ff       	call   80100283 <brelse>
80101ad4:	83 c4 10             	add    $0x10,%esp
80101ad7:	8b 45 08             	mov    0x8(%ebp),%eax
80101ada:	c7 40 4c 01 00 00 00 	movl   $0x1,0x4c(%eax)
80101ae1:	8b 45 08             	mov    0x8(%ebp),%eax
80101ae4:	0f b7 40 50          	movzwl 0x50(%eax),%eax
80101ae8:	66 85 c0             	test   %ax,%ax
80101aeb:	75 0d                	jne    80101afa <ilock+0x110>
80101aed:	83 ec 0c             	sub    $0xc,%esp
80101af0:	68 d3 a3 10 80       	push   $0x8010a3d3
80101af5:	e8 af ea ff ff       	call   801005a9 <panic>
80101afa:	90                   	nop
80101afb:	c9                   	leave  
80101afc:	c3                   	ret    

80101afd <iunlock>:
80101afd:	55                   	push   %ebp
80101afe:	89 e5                	mov    %esp,%ebp
80101b00:	83 ec 08             	sub    $0x8,%esp
80101b03:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
80101b07:	74 20                	je     80101b29 <iunlock+0x2c>
80101b09:	8b 45 08             	mov    0x8(%ebp),%eax
80101b0c:	83 c0 0c             	add    $0xc,%eax
80101b0f:	83 ec 0c             	sub    $0xc,%esp
80101b12:	50                   	push   %eax
80101b13:	e8 bf 2d 00 00       	call   801048d7 <holdingsleep>
80101b18:	83 c4 10             	add    $0x10,%esp
80101b1b:	85 c0                	test   %eax,%eax
80101b1d:	74 0a                	je     80101b29 <iunlock+0x2c>
80101b1f:	8b 45 08             	mov    0x8(%ebp),%eax
80101b22:	8b 40 08             	mov    0x8(%eax),%eax
80101b25:	85 c0                	test   %eax,%eax
80101b27:	7f 0d                	jg     80101b36 <iunlock+0x39>
80101b29:	83 ec 0c             	sub    $0xc,%esp
80101b2c:	68 e2 a3 10 80       	push   $0x8010a3e2
80101b31:	e8 73 ea ff ff       	call   801005a9 <panic>
80101b36:	8b 45 08             	mov    0x8(%ebp),%eax
80101b39:	83 c0 0c             	add    $0xc,%eax
80101b3c:	83 ec 0c             	sub    $0xc,%esp
80101b3f:	50                   	push   %eax
80101b40:	e8 44 2d 00 00       	call   80104889 <releasesleep>
80101b45:	83 c4 10             	add    $0x10,%esp
80101b48:	90                   	nop
80101b49:	c9                   	leave  
80101b4a:	c3                   	ret    

80101b4b <iput>:
80101b4b:	55                   	push   %ebp
80101b4c:	89 e5                	mov    %esp,%ebp
80101b4e:	83 ec 18             	sub    $0x18,%esp
80101b51:	8b 45 08             	mov    0x8(%ebp),%eax
80101b54:	83 c0 0c             	add    $0xc,%eax
80101b57:	83 ec 0c             	sub    $0xc,%esp
80101b5a:	50                   	push   %eax
80101b5b:	e8 c5 2c 00 00       	call   80104825 <acquiresleep>
80101b60:	83 c4 10             	add    $0x10,%esp
80101b63:	8b 45 08             	mov    0x8(%ebp),%eax
80101b66:	8b 40 4c             	mov    0x4c(%eax),%eax
80101b69:	85 c0                	test   %eax,%eax
80101b6b:	74 6a                	je     80101bd7 <iput+0x8c>
80101b6d:	8b 45 08             	mov    0x8(%ebp),%eax
80101b70:	0f b7 40 56          	movzwl 0x56(%eax),%eax
80101b74:	66 85 c0             	test   %ax,%ax
80101b77:	75 5e                	jne    80101bd7 <iput+0x8c>
80101b79:	83 ec 0c             	sub    $0xc,%esp
80101b7c:	68 60 24 19 80       	push   $0x80192460
80101b81:	e8 e2 2d 00 00       	call   80104968 <acquire>
80101b86:	83 c4 10             	add    $0x10,%esp
80101b89:	8b 45 08             	mov    0x8(%ebp),%eax
80101b8c:	8b 40 08             	mov    0x8(%eax),%eax
80101b8f:	89 45 f4             	mov    %eax,-0xc(%ebp)
80101b92:	83 ec 0c             	sub    $0xc,%esp
80101b95:	68 60 24 19 80       	push   $0x80192460
80101b9a:	e8 37 2e 00 00       	call   801049d6 <release>
80101b9f:	83 c4 10             	add    $0x10,%esp
80101ba2:	83 7d f4 01          	cmpl   $0x1,-0xc(%ebp)
80101ba6:	75 2f                	jne    80101bd7 <iput+0x8c>
80101ba8:	83 ec 0c             	sub    $0xc,%esp
80101bab:	ff 75 08             	push   0x8(%ebp)
80101bae:	e8 ad 01 00 00       	call   80101d60 <itrunc>
80101bb3:	83 c4 10             	add    $0x10,%esp
80101bb6:	8b 45 08             	mov    0x8(%ebp),%eax
80101bb9:	66 c7 40 50 00 00    	movw   $0x0,0x50(%eax)
80101bbf:	83 ec 0c             	sub    $0xc,%esp
80101bc2:	ff 75 08             	push   0x8(%ebp)
80101bc5:	e8 43 fc ff ff       	call   8010180d <iupdate>
80101bca:	83 c4 10             	add    $0x10,%esp
80101bcd:	8b 45 08             	mov    0x8(%ebp),%eax
80101bd0:	c7 40 4c 00 00 00 00 	movl   $0x0,0x4c(%eax)
80101bd7:	8b 45 08             	mov    0x8(%ebp),%eax
80101bda:	83 c0 0c             	add    $0xc,%eax
80101bdd:	83 ec 0c             	sub    $0xc,%esp
80101be0:	50                   	push   %eax
80101be1:	e8 a3 2c 00 00       	call   80104889 <releasesleep>
80101be6:	83 c4 10             	add    $0x10,%esp
80101be9:	83 ec 0c             	sub    $0xc,%esp
80101bec:	68 60 24 19 80       	push   $0x80192460
80101bf1:	e8 72 2d 00 00       	call   80104968 <acquire>
80101bf6:	83 c4 10             	add    $0x10,%esp
80101bf9:	8b 45 08             	mov    0x8(%ebp),%eax
80101bfc:	8b 40 08             	mov    0x8(%eax),%eax
80101bff:	8d 50 ff             	lea    -0x1(%eax),%edx
80101c02:	8b 45 08             	mov    0x8(%ebp),%eax
80101c05:	89 50 08             	mov    %edx,0x8(%eax)
80101c08:	83 ec 0c             	sub    $0xc,%esp
80101c0b:	68 60 24 19 80       	push   $0x80192460
80101c10:	e8 c1 2d 00 00       	call   801049d6 <release>
80101c15:	83 c4 10             	add    $0x10,%esp
80101c18:	90                   	nop
80101c19:	c9                   	leave  
80101c1a:	c3                   	ret    

80101c1b <iunlockput>:
80101c1b:	55                   	push   %ebp
80101c1c:	89 e5                	mov    %esp,%ebp
80101c1e:	83 ec 08             	sub    $0x8,%esp
80101c21:	83 ec 0c             	sub    $0xc,%esp
80101c24:	ff 75 08             	push   0x8(%ebp)
80101c27:	e8 d1 fe ff ff       	call   80101afd <iunlock>
80101c2c:	83 c4 10             	add    $0x10,%esp
80101c2f:	83 ec 0c             	sub    $0xc,%esp
80101c32:	ff 75 08             	push   0x8(%ebp)
80101c35:	e8 11 ff ff ff       	call   80101b4b <iput>
80101c3a:	83 c4 10             	add    $0x10,%esp
80101c3d:	90                   	nop
80101c3e:	c9                   	leave  
80101c3f:	c3                   	ret    

80101c40 <bmap>:
80101c40:	55                   	push   %ebp
80101c41:	89 e5                	mov    %esp,%ebp
80101c43:	83 ec 18             	sub    $0x18,%esp
80101c46:	83 7d 0c 0b          	cmpl   $0xb,0xc(%ebp)
80101c4a:	77 42                	ja     80101c8e <bmap+0x4e>
80101c4c:	8b 45 08             	mov    0x8(%ebp),%eax
80101c4f:	8b 55 0c             	mov    0xc(%ebp),%edx
80101c52:	83 c2 14             	add    $0x14,%edx
80101c55:	8b 44 90 0c          	mov    0xc(%eax,%edx,4),%eax
80101c59:	89 45 f4             	mov    %eax,-0xc(%ebp)
80101c5c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80101c60:	75 24                	jne    80101c86 <bmap+0x46>
80101c62:	8b 45 08             	mov    0x8(%ebp),%eax
80101c65:	8b 00                	mov    (%eax),%eax
80101c67:	83 ec 0c             	sub    $0xc,%esp
80101c6a:	50                   	push   %eax
80101c6b:	e8 f4 f7 ff ff       	call   80101464 <balloc>
80101c70:	83 c4 10             	add    $0x10,%esp
80101c73:	89 45 f4             	mov    %eax,-0xc(%ebp)
80101c76:	8b 45 08             	mov    0x8(%ebp),%eax
80101c79:	8b 55 0c             	mov    0xc(%ebp),%edx
80101c7c:	8d 4a 14             	lea    0x14(%edx),%ecx
80101c7f:	8b 55 f4             	mov    -0xc(%ebp),%edx
80101c82:	89 54 88 0c          	mov    %edx,0xc(%eax,%ecx,4)
80101c86:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101c89:	e9 d0 00 00 00       	jmp    80101d5e <bmap+0x11e>
80101c8e:	83 6d 0c 0c          	subl   $0xc,0xc(%ebp)
80101c92:	83 7d 0c 7f          	cmpl   $0x7f,0xc(%ebp)
80101c96:	0f 87 b5 00 00 00    	ja     80101d51 <bmap+0x111>
80101c9c:	8b 45 08             	mov    0x8(%ebp),%eax
80101c9f:	8b 80 8c 00 00 00    	mov    0x8c(%eax),%eax
80101ca5:	89 45 f4             	mov    %eax,-0xc(%ebp)
80101ca8:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80101cac:	75 20                	jne    80101cce <bmap+0x8e>
80101cae:	8b 45 08             	mov    0x8(%ebp),%eax
80101cb1:	8b 00                	mov    (%eax),%eax
80101cb3:	83 ec 0c             	sub    $0xc,%esp
80101cb6:	50                   	push   %eax
80101cb7:	e8 a8 f7 ff ff       	call   80101464 <balloc>
80101cbc:	83 c4 10             	add    $0x10,%esp
80101cbf:	89 45 f4             	mov    %eax,-0xc(%ebp)
80101cc2:	8b 45 08             	mov    0x8(%ebp),%eax
80101cc5:	8b 55 f4             	mov    -0xc(%ebp),%edx
80101cc8:	89 90 8c 00 00 00    	mov    %edx,0x8c(%eax)
80101cce:	8b 45 08             	mov    0x8(%ebp),%eax
80101cd1:	8b 00                	mov    (%eax),%eax
80101cd3:	83 ec 08             	sub    $0x8,%esp
80101cd6:	ff 75 f4             	push   -0xc(%ebp)
80101cd9:	50                   	push   %eax
80101cda:	e8 22 e5 ff ff       	call   80100201 <bread>
80101cdf:	83 c4 10             	add    $0x10,%esp
80101ce2:	89 45 f0             	mov    %eax,-0x10(%ebp)
80101ce5:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101ce8:	83 c0 5c             	add    $0x5c,%eax
80101ceb:	89 45 ec             	mov    %eax,-0x14(%ebp)
80101cee:	8b 45 0c             	mov    0xc(%ebp),%eax
80101cf1:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80101cf8:	8b 45 ec             	mov    -0x14(%ebp),%eax
80101cfb:	01 d0                	add    %edx,%eax
80101cfd:	8b 00                	mov    (%eax),%eax
80101cff:	89 45 f4             	mov    %eax,-0xc(%ebp)
80101d02:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80101d06:	75 36                	jne    80101d3e <bmap+0xfe>
80101d08:	8b 45 08             	mov    0x8(%ebp),%eax
80101d0b:	8b 00                	mov    (%eax),%eax
80101d0d:	83 ec 0c             	sub    $0xc,%esp
80101d10:	50                   	push   %eax
80101d11:	e8 4e f7 ff ff       	call   80101464 <balloc>
80101d16:	83 c4 10             	add    $0x10,%esp
80101d19:	89 45 f4             	mov    %eax,-0xc(%ebp)
80101d1c:	8b 45 0c             	mov    0xc(%ebp),%eax
80101d1f:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80101d26:	8b 45 ec             	mov    -0x14(%ebp),%eax
80101d29:	01 c2                	add    %eax,%edx
80101d2b:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101d2e:	89 02                	mov    %eax,(%edx)
80101d30:	83 ec 0c             	sub    $0xc,%esp
80101d33:	ff 75 f0             	push   -0x10(%ebp)
80101d36:	e8 3a 15 00 00       	call   80103275 <log_write>
80101d3b:	83 c4 10             	add    $0x10,%esp
80101d3e:	83 ec 0c             	sub    $0xc,%esp
80101d41:	ff 75 f0             	push   -0x10(%ebp)
80101d44:	e8 3a e5 ff ff       	call   80100283 <brelse>
80101d49:	83 c4 10             	add    $0x10,%esp
80101d4c:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101d4f:	eb 0d                	jmp    80101d5e <bmap+0x11e>
80101d51:	83 ec 0c             	sub    $0xc,%esp
80101d54:	68 ea a3 10 80       	push   $0x8010a3ea
80101d59:	e8 4b e8 ff ff       	call   801005a9 <panic>
80101d5e:	c9                   	leave  
80101d5f:	c3                   	ret    

80101d60 <itrunc>:
80101d60:	55                   	push   %ebp
80101d61:	89 e5                	mov    %esp,%ebp
80101d63:	83 ec 18             	sub    $0x18,%esp
80101d66:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80101d6d:	eb 45                	jmp    80101db4 <itrunc+0x54>
80101d6f:	8b 45 08             	mov    0x8(%ebp),%eax
80101d72:	8b 55 f4             	mov    -0xc(%ebp),%edx
80101d75:	83 c2 14             	add    $0x14,%edx
80101d78:	8b 44 90 0c          	mov    0xc(%eax,%edx,4),%eax
80101d7c:	85 c0                	test   %eax,%eax
80101d7e:	74 30                	je     80101db0 <itrunc+0x50>
80101d80:	8b 45 08             	mov    0x8(%ebp),%eax
80101d83:	8b 55 f4             	mov    -0xc(%ebp),%edx
80101d86:	83 c2 14             	add    $0x14,%edx
80101d89:	8b 44 90 0c          	mov    0xc(%eax,%edx,4),%eax
80101d8d:	8b 55 08             	mov    0x8(%ebp),%edx
80101d90:	8b 12                	mov    (%edx),%edx
80101d92:	83 ec 08             	sub    $0x8,%esp
80101d95:	50                   	push   %eax
80101d96:	52                   	push   %edx
80101d97:	e8 0c f8 ff ff       	call   801015a8 <bfree>
80101d9c:	83 c4 10             	add    $0x10,%esp
80101d9f:	8b 45 08             	mov    0x8(%ebp),%eax
80101da2:	8b 55 f4             	mov    -0xc(%ebp),%edx
80101da5:	83 c2 14             	add    $0x14,%edx
80101da8:	c7 44 90 0c 00 00 00 	movl   $0x0,0xc(%eax,%edx,4)
80101daf:	00 
80101db0:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80101db4:	83 7d f4 0b          	cmpl   $0xb,-0xc(%ebp)
80101db8:	7e b5                	jle    80101d6f <itrunc+0xf>
80101dba:	8b 45 08             	mov    0x8(%ebp),%eax
80101dbd:	8b 80 8c 00 00 00    	mov    0x8c(%eax),%eax
80101dc3:	85 c0                	test   %eax,%eax
80101dc5:	0f 84 aa 00 00 00    	je     80101e75 <itrunc+0x115>
80101dcb:	8b 45 08             	mov    0x8(%ebp),%eax
80101dce:	8b 90 8c 00 00 00    	mov    0x8c(%eax),%edx
80101dd4:	8b 45 08             	mov    0x8(%ebp),%eax
80101dd7:	8b 00                	mov    (%eax),%eax
80101dd9:	83 ec 08             	sub    $0x8,%esp
80101ddc:	52                   	push   %edx
80101ddd:	50                   	push   %eax
80101dde:	e8 1e e4 ff ff       	call   80100201 <bread>
80101de3:	83 c4 10             	add    $0x10,%esp
80101de6:	89 45 ec             	mov    %eax,-0x14(%ebp)
80101de9:	8b 45 ec             	mov    -0x14(%ebp),%eax
80101dec:	83 c0 5c             	add    $0x5c,%eax
80101def:	89 45 e8             	mov    %eax,-0x18(%ebp)
80101df2:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
80101df9:	eb 3c                	jmp    80101e37 <itrunc+0xd7>
80101dfb:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101dfe:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80101e05:	8b 45 e8             	mov    -0x18(%ebp),%eax
80101e08:	01 d0                	add    %edx,%eax
80101e0a:	8b 00                	mov    (%eax),%eax
80101e0c:	85 c0                	test   %eax,%eax
80101e0e:	74 23                	je     80101e33 <itrunc+0xd3>
80101e10:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101e13:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80101e1a:	8b 45 e8             	mov    -0x18(%ebp),%eax
80101e1d:	01 d0                	add    %edx,%eax
80101e1f:	8b 00                	mov    (%eax),%eax
80101e21:	8b 55 08             	mov    0x8(%ebp),%edx
80101e24:	8b 12                	mov    (%edx),%edx
80101e26:	83 ec 08             	sub    $0x8,%esp
80101e29:	50                   	push   %eax
80101e2a:	52                   	push   %edx
80101e2b:	e8 78 f7 ff ff       	call   801015a8 <bfree>
80101e30:	83 c4 10             	add    $0x10,%esp
80101e33:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
80101e37:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101e3a:	83 f8 7f             	cmp    $0x7f,%eax
80101e3d:	76 bc                	jbe    80101dfb <itrunc+0x9b>
80101e3f:	83 ec 0c             	sub    $0xc,%esp
80101e42:	ff 75 ec             	push   -0x14(%ebp)
80101e45:	e8 39 e4 ff ff       	call   80100283 <brelse>
80101e4a:	83 c4 10             	add    $0x10,%esp
80101e4d:	8b 45 08             	mov    0x8(%ebp),%eax
80101e50:	8b 80 8c 00 00 00    	mov    0x8c(%eax),%eax
80101e56:	8b 55 08             	mov    0x8(%ebp),%edx
80101e59:	8b 12                	mov    (%edx),%edx
80101e5b:	83 ec 08             	sub    $0x8,%esp
80101e5e:	50                   	push   %eax
80101e5f:	52                   	push   %edx
80101e60:	e8 43 f7 ff ff       	call   801015a8 <bfree>
80101e65:	83 c4 10             	add    $0x10,%esp
80101e68:	8b 45 08             	mov    0x8(%ebp),%eax
80101e6b:	c7 80 8c 00 00 00 00 	movl   $0x0,0x8c(%eax)
80101e72:	00 00 00 
80101e75:	8b 45 08             	mov    0x8(%ebp),%eax
80101e78:	c7 40 58 00 00 00 00 	movl   $0x0,0x58(%eax)
80101e7f:	83 ec 0c             	sub    $0xc,%esp
80101e82:	ff 75 08             	push   0x8(%ebp)
80101e85:	e8 83 f9 ff ff       	call   8010180d <iupdate>
80101e8a:	83 c4 10             	add    $0x10,%esp
80101e8d:	90                   	nop
80101e8e:	c9                   	leave  
80101e8f:	c3                   	ret    

80101e90 <stati>:
80101e90:	55                   	push   %ebp
80101e91:	89 e5                	mov    %esp,%ebp
80101e93:	8b 45 08             	mov    0x8(%ebp),%eax
80101e96:	8b 00                	mov    (%eax),%eax
80101e98:	89 c2                	mov    %eax,%edx
80101e9a:	8b 45 0c             	mov    0xc(%ebp),%eax
80101e9d:	89 50 04             	mov    %edx,0x4(%eax)
80101ea0:	8b 45 08             	mov    0x8(%ebp),%eax
80101ea3:	8b 50 04             	mov    0x4(%eax),%edx
80101ea6:	8b 45 0c             	mov    0xc(%ebp),%eax
80101ea9:	89 50 08             	mov    %edx,0x8(%eax)
80101eac:	8b 45 08             	mov    0x8(%ebp),%eax
80101eaf:	0f b7 50 50          	movzwl 0x50(%eax),%edx
80101eb3:	8b 45 0c             	mov    0xc(%ebp),%eax
80101eb6:	66 89 10             	mov    %dx,(%eax)
80101eb9:	8b 45 08             	mov    0x8(%ebp),%eax
80101ebc:	0f b7 50 56          	movzwl 0x56(%eax),%edx
80101ec0:	8b 45 0c             	mov    0xc(%ebp),%eax
80101ec3:	66 89 50 0c          	mov    %dx,0xc(%eax)
80101ec7:	8b 45 08             	mov    0x8(%ebp),%eax
80101eca:	8b 50 58             	mov    0x58(%eax),%edx
80101ecd:	8b 45 0c             	mov    0xc(%ebp),%eax
80101ed0:	89 50 10             	mov    %edx,0x10(%eax)
80101ed3:	90                   	nop
80101ed4:	5d                   	pop    %ebp
80101ed5:	c3                   	ret    

80101ed6 <readi>:
80101ed6:	55                   	push   %ebp
80101ed7:	89 e5                	mov    %esp,%ebp
80101ed9:	83 ec 18             	sub    $0x18,%esp
80101edc:	8b 45 08             	mov    0x8(%ebp),%eax
80101edf:	0f b7 40 50          	movzwl 0x50(%eax),%eax
80101ee3:	66 83 f8 03          	cmp    $0x3,%ax
80101ee7:	75 5c                	jne    80101f45 <readi+0x6f>
80101ee9:	8b 45 08             	mov    0x8(%ebp),%eax
80101eec:	0f b7 40 52          	movzwl 0x52(%eax),%eax
80101ef0:	66 85 c0             	test   %ax,%ax
80101ef3:	78 20                	js     80101f15 <readi+0x3f>
80101ef5:	8b 45 08             	mov    0x8(%ebp),%eax
80101ef8:	0f b7 40 52          	movzwl 0x52(%eax),%eax
80101efc:	66 83 f8 09          	cmp    $0x9,%ax
80101f00:	7f 13                	jg     80101f15 <readi+0x3f>
80101f02:	8b 45 08             	mov    0x8(%ebp),%eax
80101f05:	0f b7 40 52          	movzwl 0x52(%eax),%eax
80101f09:	98                   	cwtl   
80101f0a:	8b 04 c5 40 1a 19 80 	mov    -0x7fe6e5c0(,%eax,8),%eax
80101f11:	85 c0                	test   %eax,%eax
80101f13:	75 0a                	jne    80101f1f <readi+0x49>
80101f15:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101f1a:	e9 0a 01 00 00       	jmp    80102029 <readi+0x153>
80101f1f:	8b 45 08             	mov    0x8(%ebp),%eax
80101f22:	0f b7 40 52          	movzwl 0x52(%eax),%eax
80101f26:	98                   	cwtl   
80101f27:	8b 04 c5 40 1a 19 80 	mov    -0x7fe6e5c0(,%eax,8),%eax
80101f2e:	8b 55 14             	mov    0x14(%ebp),%edx
80101f31:	83 ec 04             	sub    $0x4,%esp
80101f34:	52                   	push   %edx
80101f35:	ff 75 0c             	push   0xc(%ebp)
80101f38:	ff 75 08             	push   0x8(%ebp)
80101f3b:	ff d0                	call   *%eax
80101f3d:	83 c4 10             	add    $0x10,%esp
80101f40:	e9 e4 00 00 00       	jmp    80102029 <readi+0x153>
80101f45:	8b 45 08             	mov    0x8(%ebp),%eax
80101f48:	8b 40 58             	mov    0x58(%eax),%eax
80101f4b:	39 45 10             	cmp    %eax,0x10(%ebp)
80101f4e:	77 0d                	ja     80101f5d <readi+0x87>
80101f50:	8b 55 10             	mov    0x10(%ebp),%edx
80101f53:	8b 45 14             	mov    0x14(%ebp),%eax
80101f56:	01 d0                	add    %edx,%eax
80101f58:	39 45 10             	cmp    %eax,0x10(%ebp)
80101f5b:	76 0a                	jbe    80101f67 <readi+0x91>
80101f5d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101f62:	e9 c2 00 00 00       	jmp    80102029 <readi+0x153>
80101f67:	8b 55 10             	mov    0x10(%ebp),%edx
80101f6a:	8b 45 14             	mov    0x14(%ebp),%eax
80101f6d:	01 c2                	add    %eax,%edx
80101f6f:	8b 45 08             	mov    0x8(%ebp),%eax
80101f72:	8b 40 58             	mov    0x58(%eax),%eax
80101f75:	39 c2                	cmp    %eax,%edx
80101f77:	76 0c                	jbe    80101f85 <readi+0xaf>
80101f79:	8b 45 08             	mov    0x8(%ebp),%eax
80101f7c:	8b 40 58             	mov    0x58(%eax),%eax
80101f7f:	2b 45 10             	sub    0x10(%ebp),%eax
80101f82:	89 45 14             	mov    %eax,0x14(%ebp)
80101f85:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80101f8c:	e9 89 00 00 00       	jmp    8010201a <readi+0x144>
80101f91:	8b 45 10             	mov    0x10(%ebp),%eax
80101f94:	c1 e8 09             	shr    $0x9,%eax
80101f97:	83 ec 08             	sub    $0x8,%esp
80101f9a:	50                   	push   %eax
80101f9b:	ff 75 08             	push   0x8(%ebp)
80101f9e:	e8 9d fc ff ff       	call   80101c40 <bmap>
80101fa3:	83 c4 10             	add    $0x10,%esp
80101fa6:	8b 55 08             	mov    0x8(%ebp),%edx
80101fa9:	8b 12                	mov    (%edx),%edx
80101fab:	83 ec 08             	sub    $0x8,%esp
80101fae:	50                   	push   %eax
80101faf:	52                   	push   %edx
80101fb0:	e8 4c e2 ff ff       	call   80100201 <bread>
80101fb5:	83 c4 10             	add    $0x10,%esp
80101fb8:	89 45 f0             	mov    %eax,-0x10(%ebp)
80101fbb:	8b 45 10             	mov    0x10(%ebp),%eax
80101fbe:	25 ff 01 00 00       	and    $0x1ff,%eax
80101fc3:	ba 00 02 00 00       	mov    $0x200,%edx
80101fc8:	29 c2                	sub    %eax,%edx
80101fca:	8b 45 14             	mov    0x14(%ebp),%eax
80101fcd:	2b 45 f4             	sub    -0xc(%ebp),%eax
80101fd0:	39 c2                	cmp    %eax,%edx
80101fd2:	0f 46 c2             	cmovbe %edx,%eax
80101fd5:	89 45 ec             	mov    %eax,-0x14(%ebp)
80101fd8:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101fdb:	8d 50 5c             	lea    0x5c(%eax),%edx
80101fde:	8b 45 10             	mov    0x10(%ebp),%eax
80101fe1:	25 ff 01 00 00       	and    $0x1ff,%eax
80101fe6:	01 d0                	add    %edx,%eax
80101fe8:	83 ec 04             	sub    $0x4,%esp
80101feb:	ff 75 ec             	push   -0x14(%ebp)
80101fee:	50                   	push   %eax
80101fef:	ff 75 0c             	push   0xc(%ebp)
80101ff2:	e8 a6 2c 00 00       	call   80104c9d <memmove>
80101ff7:	83 c4 10             	add    $0x10,%esp
80101ffa:	83 ec 0c             	sub    $0xc,%esp
80101ffd:	ff 75 f0             	push   -0x10(%ebp)
80102000:	e8 7e e2 ff ff       	call   80100283 <brelse>
80102005:	83 c4 10             	add    $0x10,%esp
80102008:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010200b:	01 45 f4             	add    %eax,-0xc(%ebp)
8010200e:	8b 45 ec             	mov    -0x14(%ebp),%eax
80102011:	01 45 10             	add    %eax,0x10(%ebp)
80102014:	8b 45 ec             	mov    -0x14(%ebp),%eax
80102017:	01 45 0c             	add    %eax,0xc(%ebp)
8010201a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010201d:	3b 45 14             	cmp    0x14(%ebp),%eax
80102020:	0f 82 6b ff ff ff    	jb     80101f91 <readi+0xbb>
80102026:	8b 45 14             	mov    0x14(%ebp),%eax
80102029:	c9                   	leave  
8010202a:	c3                   	ret    

8010202b <writei>:
8010202b:	55                   	push   %ebp
8010202c:	89 e5                	mov    %esp,%ebp
8010202e:	83 ec 18             	sub    $0x18,%esp
80102031:	8b 45 08             	mov    0x8(%ebp),%eax
80102034:	0f b7 40 50          	movzwl 0x50(%eax),%eax
80102038:	66 83 f8 03          	cmp    $0x3,%ax
8010203c:	75 5c                	jne    8010209a <writei+0x6f>
8010203e:	8b 45 08             	mov    0x8(%ebp),%eax
80102041:	0f b7 40 52          	movzwl 0x52(%eax),%eax
80102045:	66 85 c0             	test   %ax,%ax
80102048:	78 20                	js     8010206a <writei+0x3f>
8010204a:	8b 45 08             	mov    0x8(%ebp),%eax
8010204d:	0f b7 40 52          	movzwl 0x52(%eax),%eax
80102051:	66 83 f8 09          	cmp    $0x9,%ax
80102055:	7f 13                	jg     8010206a <writei+0x3f>
80102057:	8b 45 08             	mov    0x8(%ebp),%eax
8010205a:	0f b7 40 52          	movzwl 0x52(%eax),%eax
8010205e:	98                   	cwtl   
8010205f:	8b 04 c5 44 1a 19 80 	mov    -0x7fe6e5bc(,%eax,8),%eax
80102066:	85 c0                	test   %eax,%eax
80102068:	75 0a                	jne    80102074 <writei+0x49>
8010206a:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010206f:	e9 3b 01 00 00       	jmp    801021af <writei+0x184>
80102074:	8b 45 08             	mov    0x8(%ebp),%eax
80102077:	0f b7 40 52          	movzwl 0x52(%eax),%eax
8010207b:	98                   	cwtl   
8010207c:	8b 04 c5 44 1a 19 80 	mov    -0x7fe6e5bc(,%eax,8),%eax
80102083:	8b 55 14             	mov    0x14(%ebp),%edx
80102086:	83 ec 04             	sub    $0x4,%esp
80102089:	52                   	push   %edx
8010208a:	ff 75 0c             	push   0xc(%ebp)
8010208d:	ff 75 08             	push   0x8(%ebp)
80102090:	ff d0                	call   *%eax
80102092:	83 c4 10             	add    $0x10,%esp
80102095:	e9 15 01 00 00       	jmp    801021af <writei+0x184>
8010209a:	8b 45 08             	mov    0x8(%ebp),%eax
8010209d:	8b 40 58             	mov    0x58(%eax),%eax
801020a0:	39 45 10             	cmp    %eax,0x10(%ebp)
801020a3:	77 0d                	ja     801020b2 <writei+0x87>
801020a5:	8b 55 10             	mov    0x10(%ebp),%edx
801020a8:	8b 45 14             	mov    0x14(%ebp),%eax
801020ab:	01 d0                	add    %edx,%eax
801020ad:	39 45 10             	cmp    %eax,0x10(%ebp)
801020b0:	76 0a                	jbe    801020bc <writei+0x91>
801020b2:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801020b7:	e9 f3 00 00 00       	jmp    801021af <writei+0x184>
801020bc:	8b 55 10             	mov    0x10(%ebp),%edx
801020bf:	8b 45 14             	mov    0x14(%ebp),%eax
801020c2:	01 d0                	add    %edx,%eax
801020c4:	3d 00 18 01 00       	cmp    $0x11800,%eax
801020c9:	76 0a                	jbe    801020d5 <writei+0xaa>
801020cb:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801020d0:	e9 da 00 00 00       	jmp    801021af <writei+0x184>
801020d5:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
801020dc:	e9 97 00 00 00       	jmp    80102178 <writei+0x14d>
801020e1:	8b 45 10             	mov    0x10(%ebp),%eax
801020e4:	c1 e8 09             	shr    $0x9,%eax
801020e7:	83 ec 08             	sub    $0x8,%esp
801020ea:	50                   	push   %eax
801020eb:	ff 75 08             	push   0x8(%ebp)
801020ee:	e8 4d fb ff ff       	call   80101c40 <bmap>
801020f3:	83 c4 10             	add    $0x10,%esp
801020f6:	8b 55 08             	mov    0x8(%ebp),%edx
801020f9:	8b 12                	mov    (%edx),%edx
801020fb:	83 ec 08             	sub    $0x8,%esp
801020fe:	50                   	push   %eax
801020ff:	52                   	push   %edx
80102100:	e8 fc e0 ff ff       	call   80100201 <bread>
80102105:	83 c4 10             	add    $0x10,%esp
80102108:	89 45 f0             	mov    %eax,-0x10(%ebp)
8010210b:	8b 45 10             	mov    0x10(%ebp),%eax
8010210e:	25 ff 01 00 00       	and    $0x1ff,%eax
80102113:	ba 00 02 00 00       	mov    $0x200,%edx
80102118:	29 c2                	sub    %eax,%edx
8010211a:	8b 45 14             	mov    0x14(%ebp),%eax
8010211d:	2b 45 f4             	sub    -0xc(%ebp),%eax
80102120:	39 c2                	cmp    %eax,%edx
80102122:	0f 46 c2             	cmovbe %edx,%eax
80102125:	89 45 ec             	mov    %eax,-0x14(%ebp)
80102128:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010212b:	8d 50 5c             	lea    0x5c(%eax),%edx
8010212e:	8b 45 10             	mov    0x10(%ebp),%eax
80102131:	25 ff 01 00 00       	and    $0x1ff,%eax
80102136:	01 d0                	add    %edx,%eax
80102138:	83 ec 04             	sub    $0x4,%esp
8010213b:	ff 75 ec             	push   -0x14(%ebp)
8010213e:	ff 75 0c             	push   0xc(%ebp)
80102141:	50                   	push   %eax
80102142:	e8 56 2b 00 00       	call   80104c9d <memmove>
80102147:	83 c4 10             	add    $0x10,%esp
8010214a:	83 ec 0c             	sub    $0xc,%esp
8010214d:	ff 75 f0             	push   -0x10(%ebp)
80102150:	e8 20 11 00 00       	call   80103275 <log_write>
80102155:	83 c4 10             	add    $0x10,%esp
80102158:	83 ec 0c             	sub    $0xc,%esp
8010215b:	ff 75 f0             	push   -0x10(%ebp)
8010215e:	e8 20 e1 ff ff       	call   80100283 <brelse>
80102163:	83 c4 10             	add    $0x10,%esp
80102166:	8b 45 ec             	mov    -0x14(%ebp),%eax
80102169:	01 45 f4             	add    %eax,-0xc(%ebp)
8010216c:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010216f:	01 45 10             	add    %eax,0x10(%ebp)
80102172:	8b 45 ec             	mov    -0x14(%ebp),%eax
80102175:	01 45 0c             	add    %eax,0xc(%ebp)
80102178:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010217b:	3b 45 14             	cmp    0x14(%ebp),%eax
8010217e:	0f 82 5d ff ff ff    	jb     801020e1 <writei+0xb6>
80102184:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
80102188:	74 22                	je     801021ac <writei+0x181>
8010218a:	8b 45 08             	mov    0x8(%ebp),%eax
8010218d:	8b 40 58             	mov    0x58(%eax),%eax
80102190:	39 45 10             	cmp    %eax,0x10(%ebp)
80102193:	76 17                	jbe    801021ac <writei+0x181>
80102195:	8b 45 08             	mov    0x8(%ebp),%eax
80102198:	8b 55 10             	mov    0x10(%ebp),%edx
8010219b:	89 50 58             	mov    %edx,0x58(%eax)
8010219e:	83 ec 0c             	sub    $0xc,%esp
801021a1:	ff 75 08             	push   0x8(%ebp)
801021a4:	e8 64 f6 ff ff       	call   8010180d <iupdate>
801021a9:	83 c4 10             	add    $0x10,%esp
801021ac:	8b 45 14             	mov    0x14(%ebp),%eax
801021af:	c9                   	leave  
801021b0:	c3                   	ret    

801021b1 <namecmp>:
801021b1:	55                   	push   %ebp
801021b2:	89 e5                	mov    %esp,%ebp
801021b4:	83 ec 08             	sub    $0x8,%esp
801021b7:	83 ec 04             	sub    $0x4,%esp
801021ba:	6a 0e                	push   $0xe
801021bc:	ff 75 0c             	push   0xc(%ebp)
801021bf:	ff 75 08             	push   0x8(%ebp)
801021c2:	e8 6c 2b 00 00       	call   80104d33 <strncmp>
801021c7:	83 c4 10             	add    $0x10,%esp
801021ca:	c9                   	leave  
801021cb:	c3                   	ret    

801021cc <dirlookup>:
801021cc:	55                   	push   %ebp
801021cd:	89 e5                	mov    %esp,%ebp
801021cf:	83 ec 28             	sub    $0x28,%esp
801021d2:	8b 45 08             	mov    0x8(%ebp),%eax
801021d5:	0f b7 40 50          	movzwl 0x50(%eax),%eax
801021d9:	66 83 f8 01          	cmp    $0x1,%ax
801021dd:	74 0d                	je     801021ec <dirlookup+0x20>
801021df:	83 ec 0c             	sub    $0xc,%esp
801021e2:	68 fd a3 10 80       	push   $0x8010a3fd
801021e7:	e8 bd e3 ff ff       	call   801005a9 <panic>
801021ec:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
801021f3:	eb 7b                	jmp    80102270 <dirlookup+0xa4>
801021f5:	6a 10                	push   $0x10
801021f7:	ff 75 f4             	push   -0xc(%ebp)
801021fa:	8d 45 e0             	lea    -0x20(%ebp),%eax
801021fd:	50                   	push   %eax
801021fe:	ff 75 08             	push   0x8(%ebp)
80102201:	e8 d0 fc ff ff       	call   80101ed6 <readi>
80102206:	83 c4 10             	add    $0x10,%esp
80102209:	83 f8 10             	cmp    $0x10,%eax
8010220c:	74 0d                	je     8010221b <dirlookup+0x4f>
8010220e:	83 ec 0c             	sub    $0xc,%esp
80102211:	68 0f a4 10 80       	push   $0x8010a40f
80102216:	e8 8e e3 ff ff       	call   801005a9 <panic>
8010221b:	0f b7 45 e0          	movzwl -0x20(%ebp),%eax
8010221f:	66 85 c0             	test   %ax,%ax
80102222:	74 47                	je     8010226b <dirlookup+0x9f>
80102224:	83 ec 08             	sub    $0x8,%esp
80102227:	8d 45 e0             	lea    -0x20(%ebp),%eax
8010222a:	83 c0 02             	add    $0x2,%eax
8010222d:	50                   	push   %eax
8010222e:	ff 75 0c             	push   0xc(%ebp)
80102231:	e8 7b ff ff ff       	call   801021b1 <namecmp>
80102236:	83 c4 10             	add    $0x10,%esp
80102239:	85 c0                	test   %eax,%eax
8010223b:	75 2f                	jne    8010226c <dirlookup+0xa0>
8010223d:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
80102241:	74 08                	je     8010224b <dirlookup+0x7f>
80102243:	8b 45 10             	mov    0x10(%ebp),%eax
80102246:	8b 55 f4             	mov    -0xc(%ebp),%edx
80102249:	89 10                	mov    %edx,(%eax)
8010224b:	0f b7 45 e0          	movzwl -0x20(%ebp),%eax
8010224f:	0f b7 c0             	movzwl %ax,%eax
80102252:	89 45 f0             	mov    %eax,-0x10(%ebp)
80102255:	8b 45 08             	mov    0x8(%ebp),%eax
80102258:	8b 00                	mov    (%eax),%eax
8010225a:	83 ec 08             	sub    $0x8,%esp
8010225d:	ff 75 f0             	push   -0x10(%ebp)
80102260:	50                   	push   %eax
80102261:	e8 68 f6 ff ff       	call   801018ce <iget>
80102266:	83 c4 10             	add    $0x10,%esp
80102269:	eb 19                	jmp    80102284 <dirlookup+0xb8>
8010226b:	90                   	nop
8010226c:	83 45 f4 10          	addl   $0x10,-0xc(%ebp)
80102270:	8b 45 08             	mov    0x8(%ebp),%eax
80102273:	8b 40 58             	mov    0x58(%eax),%eax
80102276:	39 45 f4             	cmp    %eax,-0xc(%ebp)
80102279:	0f 82 76 ff ff ff    	jb     801021f5 <dirlookup+0x29>
8010227f:	b8 00 00 00 00       	mov    $0x0,%eax
80102284:	c9                   	leave  
80102285:	c3                   	ret    

80102286 <dirlink>:
80102286:	55                   	push   %ebp
80102287:	89 e5                	mov    %esp,%ebp
80102289:	83 ec 28             	sub    $0x28,%esp
8010228c:	83 ec 04             	sub    $0x4,%esp
8010228f:	6a 00                	push   $0x0
80102291:	ff 75 0c             	push   0xc(%ebp)
80102294:	ff 75 08             	push   0x8(%ebp)
80102297:	e8 30 ff ff ff       	call   801021cc <dirlookup>
8010229c:	83 c4 10             	add    $0x10,%esp
8010229f:	89 45 f0             	mov    %eax,-0x10(%ebp)
801022a2:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
801022a6:	74 18                	je     801022c0 <dirlink+0x3a>
801022a8:	83 ec 0c             	sub    $0xc,%esp
801022ab:	ff 75 f0             	push   -0x10(%ebp)
801022ae:	e8 98 f8 ff ff       	call   80101b4b <iput>
801022b3:	83 c4 10             	add    $0x10,%esp
801022b6:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801022bb:	e9 9c 00 00 00       	jmp    8010235c <dirlink+0xd6>
801022c0:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
801022c7:	eb 39                	jmp    80102302 <dirlink+0x7c>
801022c9:	8b 45 f4             	mov    -0xc(%ebp),%eax
801022cc:	6a 10                	push   $0x10
801022ce:	50                   	push   %eax
801022cf:	8d 45 e0             	lea    -0x20(%ebp),%eax
801022d2:	50                   	push   %eax
801022d3:	ff 75 08             	push   0x8(%ebp)
801022d6:	e8 fb fb ff ff       	call   80101ed6 <readi>
801022db:	83 c4 10             	add    $0x10,%esp
801022de:	83 f8 10             	cmp    $0x10,%eax
801022e1:	74 0d                	je     801022f0 <dirlink+0x6a>
801022e3:	83 ec 0c             	sub    $0xc,%esp
801022e6:	68 1e a4 10 80       	push   $0x8010a41e
801022eb:	e8 b9 e2 ff ff       	call   801005a9 <panic>
801022f0:	0f b7 45 e0          	movzwl -0x20(%ebp),%eax
801022f4:	66 85 c0             	test   %ax,%ax
801022f7:	74 18                	je     80102311 <dirlink+0x8b>
801022f9:	8b 45 f4             	mov    -0xc(%ebp),%eax
801022fc:	83 c0 10             	add    $0x10,%eax
801022ff:	89 45 f4             	mov    %eax,-0xc(%ebp)
80102302:	8b 45 08             	mov    0x8(%ebp),%eax
80102305:	8b 50 58             	mov    0x58(%eax),%edx
80102308:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010230b:	39 c2                	cmp    %eax,%edx
8010230d:	77 ba                	ja     801022c9 <dirlink+0x43>
8010230f:	eb 01                	jmp    80102312 <dirlink+0x8c>
80102311:	90                   	nop
80102312:	83 ec 04             	sub    $0x4,%esp
80102315:	6a 0e                	push   $0xe
80102317:	ff 75 0c             	push   0xc(%ebp)
8010231a:	8d 45 e0             	lea    -0x20(%ebp),%eax
8010231d:	83 c0 02             	add    $0x2,%eax
80102320:	50                   	push   %eax
80102321:	e8 63 2a 00 00       	call   80104d89 <strncpy>
80102326:	83 c4 10             	add    $0x10,%esp
80102329:	8b 45 10             	mov    0x10(%ebp),%eax
8010232c:	66 89 45 e0          	mov    %ax,-0x20(%ebp)
80102330:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102333:	6a 10                	push   $0x10
80102335:	50                   	push   %eax
80102336:	8d 45 e0             	lea    -0x20(%ebp),%eax
80102339:	50                   	push   %eax
8010233a:	ff 75 08             	push   0x8(%ebp)
8010233d:	e8 e9 fc ff ff       	call   8010202b <writei>
80102342:	83 c4 10             	add    $0x10,%esp
80102345:	83 f8 10             	cmp    $0x10,%eax
80102348:	74 0d                	je     80102357 <dirlink+0xd1>
8010234a:	83 ec 0c             	sub    $0xc,%esp
8010234d:	68 2b a4 10 80       	push   $0x8010a42b
80102352:	e8 52 e2 ff ff       	call   801005a9 <panic>
80102357:	b8 00 00 00 00       	mov    $0x0,%eax
8010235c:	c9                   	leave  
8010235d:	c3                   	ret    

8010235e <skipelem>:
8010235e:	55                   	push   %ebp
8010235f:	89 e5                	mov    %esp,%ebp
80102361:	83 ec 18             	sub    $0x18,%esp
80102364:	eb 04                	jmp    8010236a <skipelem+0xc>
80102366:	83 45 08 01          	addl   $0x1,0x8(%ebp)
8010236a:	8b 45 08             	mov    0x8(%ebp),%eax
8010236d:	0f b6 00             	movzbl (%eax),%eax
80102370:	3c 2f                	cmp    $0x2f,%al
80102372:	74 f2                	je     80102366 <skipelem+0x8>
80102374:	8b 45 08             	mov    0x8(%ebp),%eax
80102377:	0f b6 00             	movzbl (%eax),%eax
8010237a:	84 c0                	test   %al,%al
8010237c:	75 07                	jne    80102385 <skipelem+0x27>
8010237e:	b8 00 00 00 00       	mov    $0x0,%eax
80102383:	eb 77                	jmp    801023fc <skipelem+0x9e>
80102385:	8b 45 08             	mov    0x8(%ebp),%eax
80102388:	89 45 f4             	mov    %eax,-0xc(%ebp)
8010238b:	eb 04                	jmp    80102391 <skipelem+0x33>
8010238d:	83 45 08 01          	addl   $0x1,0x8(%ebp)
80102391:	8b 45 08             	mov    0x8(%ebp),%eax
80102394:	0f b6 00             	movzbl (%eax),%eax
80102397:	3c 2f                	cmp    $0x2f,%al
80102399:	74 0a                	je     801023a5 <skipelem+0x47>
8010239b:	8b 45 08             	mov    0x8(%ebp),%eax
8010239e:	0f b6 00             	movzbl (%eax),%eax
801023a1:	84 c0                	test   %al,%al
801023a3:	75 e8                	jne    8010238d <skipelem+0x2f>
801023a5:	8b 45 08             	mov    0x8(%ebp),%eax
801023a8:	2b 45 f4             	sub    -0xc(%ebp),%eax
801023ab:	89 45 f0             	mov    %eax,-0x10(%ebp)
801023ae:	83 7d f0 0d          	cmpl   $0xd,-0x10(%ebp)
801023b2:	7e 15                	jle    801023c9 <skipelem+0x6b>
801023b4:	83 ec 04             	sub    $0x4,%esp
801023b7:	6a 0e                	push   $0xe
801023b9:	ff 75 f4             	push   -0xc(%ebp)
801023bc:	ff 75 0c             	push   0xc(%ebp)
801023bf:	e8 d9 28 00 00       	call   80104c9d <memmove>
801023c4:	83 c4 10             	add    $0x10,%esp
801023c7:	eb 26                	jmp    801023ef <skipelem+0x91>
801023c9:	8b 45 f0             	mov    -0x10(%ebp),%eax
801023cc:	83 ec 04             	sub    $0x4,%esp
801023cf:	50                   	push   %eax
801023d0:	ff 75 f4             	push   -0xc(%ebp)
801023d3:	ff 75 0c             	push   0xc(%ebp)
801023d6:	e8 c2 28 00 00       	call   80104c9d <memmove>
801023db:	83 c4 10             	add    $0x10,%esp
801023de:	8b 55 f0             	mov    -0x10(%ebp),%edx
801023e1:	8b 45 0c             	mov    0xc(%ebp),%eax
801023e4:	01 d0                	add    %edx,%eax
801023e6:	c6 00 00             	movb   $0x0,(%eax)
801023e9:	eb 04                	jmp    801023ef <skipelem+0x91>
801023eb:	83 45 08 01          	addl   $0x1,0x8(%ebp)
801023ef:	8b 45 08             	mov    0x8(%ebp),%eax
801023f2:	0f b6 00             	movzbl (%eax),%eax
801023f5:	3c 2f                	cmp    $0x2f,%al
801023f7:	74 f2                	je     801023eb <skipelem+0x8d>
801023f9:	8b 45 08             	mov    0x8(%ebp),%eax
801023fc:	c9                   	leave  
801023fd:	c3                   	ret    

801023fe <namex>:
801023fe:	55                   	push   %ebp
801023ff:	89 e5                	mov    %esp,%ebp
80102401:	83 ec 18             	sub    $0x18,%esp
80102404:	8b 45 08             	mov    0x8(%ebp),%eax
80102407:	0f b6 00             	movzbl (%eax),%eax
8010240a:	3c 2f                	cmp    $0x2f,%al
8010240c:	75 17                	jne    80102425 <namex+0x27>
8010240e:	83 ec 08             	sub    $0x8,%esp
80102411:	6a 01                	push   $0x1
80102413:	6a 01                	push   $0x1
80102415:	e8 b4 f4 ff ff       	call   801018ce <iget>
8010241a:	83 c4 10             	add    $0x10,%esp
8010241d:	89 45 f4             	mov    %eax,-0xc(%ebp)
80102420:	e9 ba 00 00 00       	jmp    801024df <namex+0xe1>
80102425:	e8 06 16 00 00       	call   80103a30 <myproc>
8010242a:	8b 40 68             	mov    0x68(%eax),%eax
8010242d:	83 ec 0c             	sub    $0xc,%esp
80102430:	50                   	push   %eax
80102431:	e8 7a f5 ff ff       	call   801019b0 <idup>
80102436:	83 c4 10             	add    $0x10,%esp
80102439:	89 45 f4             	mov    %eax,-0xc(%ebp)
8010243c:	e9 9e 00 00 00       	jmp    801024df <namex+0xe1>
80102441:	83 ec 0c             	sub    $0xc,%esp
80102444:	ff 75 f4             	push   -0xc(%ebp)
80102447:	e8 9e f5 ff ff       	call   801019ea <ilock>
8010244c:	83 c4 10             	add    $0x10,%esp
8010244f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102452:	0f b7 40 50          	movzwl 0x50(%eax),%eax
80102456:	66 83 f8 01          	cmp    $0x1,%ax
8010245a:	74 18                	je     80102474 <namex+0x76>
8010245c:	83 ec 0c             	sub    $0xc,%esp
8010245f:	ff 75 f4             	push   -0xc(%ebp)
80102462:	e8 b4 f7 ff ff       	call   80101c1b <iunlockput>
80102467:	83 c4 10             	add    $0x10,%esp
8010246a:	b8 00 00 00 00       	mov    $0x0,%eax
8010246f:	e9 a7 00 00 00       	jmp    8010251b <namex+0x11d>
80102474:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
80102478:	74 20                	je     8010249a <namex+0x9c>
8010247a:	8b 45 08             	mov    0x8(%ebp),%eax
8010247d:	0f b6 00             	movzbl (%eax),%eax
80102480:	84 c0                	test   %al,%al
80102482:	75 16                	jne    8010249a <namex+0x9c>
80102484:	83 ec 0c             	sub    $0xc,%esp
80102487:	ff 75 f4             	push   -0xc(%ebp)
8010248a:	e8 6e f6 ff ff       	call   80101afd <iunlock>
8010248f:	83 c4 10             	add    $0x10,%esp
80102492:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102495:	e9 81 00 00 00       	jmp    8010251b <namex+0x11d>
8010249a:	83 ec 04             	sub    $0x4,%esp
8010249d:	6a 00                	push   $0x0
8010249f:	ff 75 10             	push   0x10(%ebp)
801024a2:	ff 75 f4             	push   -0xc(%ebp)
801024a5:	e8 22 fd ff ff       	call   801021cc <dirlookup>
801024aa:	83 c4 10             	add    $0x10,%esp
801024ad:	89 45 f0             	mov    %eax,-0x10(%ebp)
801024b0:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
801024b4:	75 15                	jne    801024cb <namex+0xcd>
801024b6:	83 ec 0c             	sub    $0xc,%esp
801024b9:	ff 75 f4             	push   -0xc(%ebp)
801024bc:	e8 5a f7 ff ff       	call   80101c1b <iunlockput>
801024c1:	83 c4 10             	add    $0x10,%esp
801024c4:	b8 00 00 00 00       	mov    $0x0,%eax
801024c9:	eb 50                	jmp    8010251b <namex+0x11d>
801024cb:	83 ec 0c             	sub    $0xc,%esp
801024ce:	ff 75 f4             	push   -0xc(%ebp)
801024d1:	e8 45 f7 ff ff       	call   80101c1b <iunlockput>
801024d6:	83 c4 10             	add    $0x10,%esp
801024d9:	8b 45 f0             	mov    -0x10(%ebp),%eax
801024dc:	89 45 f4             	mov    %eax,-0xc(%ebp)
801024df:	83 ec 08             	sub    $0x8,%esp
801024e2:	ff 75 10             	push   0x10(%ebp)
801024e5:	ff 75 08             	push   0x8(%ebp)
801024e8:	e8 71 fe ff ff       	call   8010235e <skipelem>
801024ed:	83 c4 10             	add    $0x10,%esp
801024f0:	89 45 08             	mov    %eax,0x8(%ebp)
801024f3:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
801024f7:	0f 85 44 ff ff ff    	jne    80102441 <namex+0x43>
801024fd:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
80102501:	74 15                	je     80102518 <namex+0x11a>
80102503:	83 ec 0c             	sub    $0xc,%esp
80102506:	ff 75 f4             	push   -0xc(%ebp)
80102509:	e8 3d f6 ff ff       	call   80101b4b <iput>
8010250e:	83 c4 10             	add    $0x10,%esp
80102511:	b8 00 00 00 00       	mov    $0x0,%eax
80102516:	eb 03                	jmp    8010251b <namex+0x11d>
80102518:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010251b:	c9                   	leave  
8010251c:	c3                   	ret    

8010251d <namei>:
8010251d:	55                   	push   %ebp
8010251e:	89 e5                	mov    %esp,%ebp
80102520:	83 ec 18             	sub    $0x18,%esp
80102523:	83 ec 04             	sub    $0x4,%esp
80102526:	8d 45 ea             	lea    -0x16(%ebp),%eax
80102529:	50                   	push   %eax
8010252a:	6a 00                	push   $0x0
8010252c:	ff 75 08             	push   0x8(%ebp)
8010252f:	e8 ca fe ff ff       	call   801023fe <namex>
80102534:	83 c4 10             	add    $0x10,%esp
80102537:	c9                   	leave  
80102538:	c3                   	ret    

80102539 <nameiparent>:
80102539:	55                   	push   %ebp
8010253a:	89 e5                	mov    %esp,%ebp
8010253c:	83 ec 08             	sub    $0x8,%esp
8010253f:	83 ec 04             	sub    $0x4,%esp
80102542:	ff 75 0c             	push   0xc(%ebp)
80102545:	6a 01                	push   $0x1
80102547:	ff 75 08             	push   0x8(%ebp)
8010254a:	e8 af fe ff ff       	call   801023fe <namex>
8010254f:	83 c4 10             	add    $0x10,%esp
80102552:	c9                   	leave  
80102553:	c3                   	ret    

80102554 <ioapicread>:
80102554:	55                   	push   %ebp
80102555:	89 e5                	mov    %esp,%ebp
80102557:	a1 b4 40 19 80       	mov    0x801940b4,%eax
8010255c:	8b 55 08             	mov    0x8(%ebp),%edx
8010255f:	89 10                	mov    %edx,(%eax)
80102561:	a1 b4 40 19 80       	mov    0x801940b4,%eax
80102566:	8b 40 10             	mov    0x10(%eax),%eax
80102569:	5d                   	pop    %ebp
8010256a:	c3                   	ret    

8010256b <ioapicwrite>:
8010256b:	55                   	push   %ebp
8010256c:	89 e5                	mov    %esp,%ebp
8010256e:	a1 b4 40 19 80       	mov    0x801940b4,%eax
80102573:	8b 55 08             	mov    0x8(%ebp),%edx
80102576:	89 10                	mov    %edx,(%eax)
80102578:	a1 b4 40 19 80       	mov    0x801940b4,%eax
8010257d:	8b 55 0c             	mov    0xc(%ebp),%edx
80102580:	89 50 10             	mov    %edx,0x10(%eax)
80102583:	90                   	nop
80102584:	5d                   	pop    %ebp
80102585:	c3                   	ret    

80102586 <ioapicinit>:
80102586:	55                   	push   %ebp
80102587:	89 e5                	mov    %esp,%ebp
80102589:	83 ec 18             	sub    $0x18,%esp
8010258c:	c7 05 b4 40 19 80 00 	movl   $0xfec00000,0x801940b4
80102593:	00 c0 fe 
80102596:	6a 01                	push   $0x1
80102598:	e8 b7 ff ff ff       	call   80102554 <ioapicread>
8010259d:	83 c4 04             	add    $0x4,%esp
801025a0:	c1 e8 10             	shr    $0x10,%eax
801025a3:	25 ff 00 00 00       	and    $0xff,%eax
801025a8:	89 45 f0             	mov    %eax,-0x10(%ebp)
801025ab:	6a 00                	push   $0x0
801025ad:	e8 a2 ff ff ff       	call   80102554 <ioapicread>
801025b2:	83 c4 04             	add    $0x4,%esp
801025b5:	c1 e8 18             	shr    $0x18,%eax
801025b8:	89 45 ec             	mov    %eax,-0x14(%ebp)
801025bb:	0f b6 05 44 6d 19 80 	movzbl 0x80196d44,%eax
801025c2:	0f b6 c0             	movzbl %al,%eax
801025c5:	39 45 ec             	cmp    %eax,-0x14(%ebp)
801025c8:	74 10                	je     801025da <ioapicinit+0x54>
801025ca:	83 ec 0c             	sub    $0xc,%esp
801025cd:	68 34 a4 10 80       	push   $0x8010a434
801025d2:	e8 1d de ff ff       	call   801003f4 <cprintf>
801025d7:	83 c4 10             	add    $0x10,%esp
801025da:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
801025e1:	eb 3f                	jmp    80102622 <ioapicinit+0x9c>
801025e3:	8b 45 f4             	mov    -0xc(%ebp),%eax
801025e6:	83 c0 20             	add    $0x20,%eax
801025e9:	0d 00 00 01 00       	or     $0x10000,%eax
801025ee:	89 c2                	mov    %eax,%edx
801025f0:	8b 45 f4             	mov    -0xc(%ebp),%eax
801025f3:	83 c0 08             	add    $0x8,%eax
801025f6:	01 c0                	add    %eax,%eax
801025f8:	83 ec 08             	sub    $0x8,%esp
801025fb:	52                   	push   %edx
801025fc:	50                   	push   %eax
801025fd:	e8 69 ff ff ff       	call   8010256b <ioapicwrite>
80102602:	83 c4 10             	add    $0x10,%esp
80102605:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102608:	83 c0 08             	add    $0x8,%eax
8010260b:	01 c0                	add    %eax,%eax
8010260d:	83 c0 01             	add    $0x1,%eax
80102610:	83 ec 08             	sub    $0x8,%esp
80102613:	6a 00                	push   $0x0
80102615:	50                   	push   %eax
80102616:	e8 50 ff ff ff       	call   8010256b <ioapicwrite>
8010261b:	83 c4 10             	add    $0x10,%esp
8010261e:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80102622:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102625:	3b 45 f0             	cmp    -0x10(%ebp),%eax
80102628:	7e b9                	jle    801025e3 <ioapicinit+0x5d>
8010262a:	90                   	nop
8010262b:	90                   	nop
8010262c:	c9                   	leave  
8010262d:	c3                   	ret    

8010262e <ioapicenable>:
8010262e:	55                   	push   %ebp
8010262f:	89 e5                	mov    %esp,%ebp
80102631:	8b 45 08             	mov    0x8(%ebp),%eax
80102634:	83 c0 20             	add    $0x20,%eax
80102637:	89 c2                	mov    %eax,%edx
80102639:	8b 45 08             	mov    0x8(%ebp),%eax
8010263c:	83 c0 08             	add    $0x8,%eax
8010263f:	01 c0                	add    %eax,%eax
80102641:	52                   	push   %edx
80102642:	50                   	push   %eax
80102643:	e8 23 ff ff ff       	call   8010256b <ioapicwrite>
80102648:	83 c4 08             	add    $0x8,%esp
8010264b:	8b 45 0c             	mov    0xc(%ebp),%eax
8010264e:	c1 e0 18             	shl    $0x18,%eax
80102651:	89 c2                	mov    %eax,%edx
80102653:	8b 45 08             	mov    0x8(%ebp),%eax
80102656:	83 c0 08             	add    $0x8,%eax
80102659:	01 c0                	add    %eax,%eax
8010265b:	83 c0 01             	add    $0x1,%eax
8010265e:	52                   	push   %edx
8010265f:	50                   	push   %eax
80102660:	e8 06 ff ff ff       	call   8010256b <ioapicwrite>
80102665:	83 c4 08             	add    $0x8,%esp
80102668:	90                   	nop
80102669:	c9                   	leave  
8010266a:	c3                   	ret    

8010266b <kinit1>:
8010266b:	55                   	push   %ebp
8010266c:	89 e5                	mov    %esp,%ebp
8010266e:	83 ec 08             	sub    $0x8,%esp
80102671:	83 ec 08             	sub    $0x8,%esp
80102674:	68 66 a4 10 80       	push   $0x8010a466
80102679:	68 c0 40 19 80       	push   $0x801940c0
8010267e:	e8 c3 22 00 00       	call   80104946 <initlock>
80102683:	83 c4 10             	add    $0x10,%esp
80102686:	c7 05 f4 40 19 80 00 	movl   $0x0,0x801940f4
8010268d:	00 00 00 
80102690:	83 ec 08             	sub    $0x8,%esp
80102693:	ff 75 0c             	push   0xc(%ebp)
80102696:	ff 75 08             	push   0x8(%ebp)
80102699:	e8 2a 00 00 00       	call   801026c8 <freerange>
8010269e:	83 c4 10             	add    $0x10,%esp
801026a1:	90                   	nop
801026a2:	c9                   	leave  
801026a3:	c3                   	ret    

801026a4 <kinit2>:
801026a4:	55                   	push   %ebp
801026a5:	89 e5                	mov    %esp,%ebp
801026a7:	83 ec 08             	sub    $0x8,%esp
801026aa:	83 ec 08             	sub    $0x8,%esp
801026ad:	ff 75 0c             	push   0xc(%ebp)
801026b0:	ff 75 08             	push   0x8(%ebp)
801026b3:	e8 10 00 00 00       	call   801026c8 <freerange>
801026b8:	83 c4 10             	add    $0x10,%esp
801026bb:	c7 05 f4 40 19 80 01 	movl   $0x1,0x801940f4
801026c2:	00 00 00 
801026c5:	90                   	nop
801026c6:	c9                   	leave  
801026c7:	c3                   	ret    

801026c8 <freerange>:
801026c8:	55                   	push   %ebp
801026c9:	89 e5                	mov    %esp,%ebp
801026cb:	83 ec 18             	sub    $0x18,%esp
801026ce:	8b 45 08             	mov    0x8(%ebp),%eax
801026d1:	05 ff 0f 00 00       	add    $0xfff,%eax
801026d6:	25 00 f0 ff ff       	and    $0xfffff000,%eax
801026db:	89 45 f4             	mov    %eax,-0xc(%ebp)
801026de:	eb 15                	jmp    801026f5 <freerange+0x2d>
801026e0:	83 ec 0c             	sub    $0xc,%esp
801026e3:	ff 75 f4             	push   -0xc(%ebp)
801026e6:	e8 1b 00 00 00       	call   80102706 <kfree>
801026eb:	83 c4 10             	add    $0x10,%esp
801026ee:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
801026f5:	8b 45 f4             	mov    -0xc(%ebp),%eax
801026f8:	05 00 10 00 00       	add    $0x1000,%eax
801026fd:	39 45 0c             	cmp    %eax,0xc(%ebp)
80102700:	73 de                	jae    801026e0 <freerange+0x18>
80102702:	90                   	nop
80102703:	90                   	nop
80102704:	c9                   	leave  
80102705:	c3                   	ret    

80102706 <kfree>:
80102706:	55                   	push   %ebp
80102707:	89 e5                	mov    %esp,%ebp
80102709:	83 ec 18             	sub    $0x18,%esp
8010270c:	8b 45 08             	mov    0x8(%ebp),%eax
8010270f:	25 ff 0f 00 00       	and    $0xfff,%eax
80102714:	85 c0                	test   %eax,%eax
80102716:	75 18                	jne    80102730 <kfree+0x2a>
80102718:	81 7d 08 00 90 19 80 	cmpl   $0x80199000,0x8(%ebp)
8010271f:	72 0f                	jb     80102730 <kfree+0x2a>
80102721:	8b 45 08             	mov    0x8(%ebp),%eax
80102724:	05 00 00 00 80       	add    $0x80000000,%eax
80102729:	3d ff ff ff 1f       	cmp    $0x1fffffff,%eax
8010272e:	76 0d                	jbe    8010273d <kfree+0x37>
80102730:	83 ec 0c             	sub    $0xc,%esp
80102733:	68 6b a4 10 80       	push   $0x8010a46b
80102738:	e8 6c de ff ff       	call   801005a9 <panic>
8010273d:	83 ec 04             	sub    $0x4,%esp
80102740:	68 00 10 00 00       	push   $0x1000
80102745:	6a 01                	push   $0x1
80102747:	ff 75 08             	push   0x8(%ebp)
8010274a:	e8 8f 24 00 00       	call   80104bde <memset>
8010274f:	83 c4 10             	add    $0x10,%esp
80102752:	a1 f4 40 19 80       	mov    0x801940f4,%eax
80102757:	85 c0                	test   %eax,%eax
80102759:	74 10                	je     8010276b <kfree+0x65>
8010275b:	83 ec 0c             	sub    $0xc,%esp
8010275e:	68 c0 40 19 80       	push   $0x801940c0
80102763:	e8 00 22 00 00       	call   80104968 <acquire>
80102768:	83 c4 10             	add    $0x10,%esp
8010276b:	8b 45 08             	mov    0x8(%ebp),%eax
8010276e:	89 45 f4             	mov    %eax,-0xc(%ebp)
80102771:	8b 15 f8 40 19 80    	mov    0x801940f8,%edx
80102777:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010277a:	89 10                	mov    %edx,(%eax)
8010277c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010277f:	a3 f8 40 19 80       	mov    %eax,0x801940f8
80102784:	a1 f4 40 19 80       	mov    0x801940f4,%eax
80102789:	85 c0                	test   %eax,%eax
8010278b:	74 10                	je     8010279d <kfree+0x97>
8010278d:	83 ec 0c             	sub    $0xc,%esp
80102790:	68 c0 40 19 80       	push   $0x801940c0
80102795:	e8 3c 22 00 00       	call   801049d6 <release>
8010279a:	83 c4 10             	add    $0x10,%esp
8010279d:	90                   	nop
8010279e:	c9                   	leave  
8010279f:	c3                   	ret    

801027a0 <kalloc>:
801027a0:	55                   	push   %ebp
801027a1:	89 e5                	mov    %esp,%ebp
801027a3:	83 ec 18             	sub    $0x18,%esp
801027a6:	a1 f4 40 19 80       	mov    0x801940f4,%eax
801027ab:	85 c0                	test   %eax,%eax
801027ad:	74 10                	je     801027bf <kalloc+0x1f>
801027af:	83 ec 0c             	sub    $0xc,%esp
801027b2:	68 c0 40 19 80       	push   $0x801940c0
801027b7:	e8 ac 21 00 00       	call   80104968 <acquire>
801027bc:	83 c4 10             	add    $0x10,%esp
801027bf:	a1 f8 40 19 80       	mov    0x801940f8,%eax
801027c4:	89 45 f4             	mov    %eax,-0xc(%ebp)
801027c7:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801027cb:	74 0a                	je     801027d7 <kalloc+0x37>
801027cd:	8b 45 f4             	mov    -0xc(%ebp),%eax
801027d0:	8b 00                	mov    (%eax),%eax
801027d2:	a3 f8 40 19 80       	mov    %eax,0x801940f8
801027d7:	a1 f4 40 19 80       	mov    0x801940f4,%eax
801027dc:	85 c0                	test   %eax,%eax
801027de:	74 10                	je     801027f0 <kalloc+0x50>
801027e0:	83 ec 0c             	sub    $0xc,%esp
801027e3:	68 c0 40 19 80       	push   $0x801940c0
801027e8:	e8 e9 21 00 00       	call   801049d6 <release>
801027ed:	83 c4 10             	add    $0x10,%esp
801027f0:	8b 45 f4             	mov    -0xc(%ebp),%eax
801027f3:	c9                   	leave  
801027f4:	c3                   	ret    

801027f5 <inb>:
801027f5:	55                   	push   %ebp
801027f6:	89 e5                	mov    %esp,%ebp
801027f8:	83 ec 14             	sub    $0x14,%esp
801027fb:	8b 45 08             	mov    0x8(%ebp),%eax
801027fe:	66 89 45 ec          	mov    %ax,-0x14(%ebp)
80102802:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
80102806:	89 c2                	mov    %eax,%edx
80102808:	ec                   	in     (%dx),%al
80102809:	88 45 ff             	mov    %al,-0x1(%ebp)
8010280c:	0f b6 45 ff          	movzbl -0x1(%ebp),%eax
80102810:	c9                   	leave  
80102811:	c3                   	ret    

80102812 <kbdgetc>:
80102812:	55                   	push   %ebp
80102813:	89 e5                	mov    %esp,%ebp
80102815:	83 ec 10             	sub    $0x10,%esp
80102818:	6a 64                	push   $0x64
8010281a:	e8 d6 ff ff ff       	call   801027f5 <inb>
8010281f:	83 c4 04             	add    $0x4,%esp
80102822:	0f b6 c0             	movzbl %al,%eax
80102825:	89 45 f4             	mov    %eax,-0xc(%ebp)
80102828:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010282b:	83 e0 01             	and    $0x1,%eax
8010282e:	85 c0                	test   %eax,%eax
80102830:	75 0a                	jne    8010283c <kbdgetc+0x2a>
80102832:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80102837:	e9 23 01 00 00       	jmp    8010295f <kbdgetc+0x14d>
8010283c:	6a 60                	push   $0x60
8010283e:	e8 b2 ff ff ff       	call   801027f5 <inb>
80102843:	83 c4 04             	add    $0x4,%esp
80102846:	0f b6 c0             	movzbl %al,%eax
80102849:	89 45 fc             	mov    %eax,-0x4(%ebp)
8010284c:	81 7d fc e0 00 00 00 	cmpl   $0xe0,-0x4(%ebp)
80102853:	75 17                	jne    8010286c <kbdgetc+0x5a>
80102855:	a1 fc 40 19 80       	mov    0x801940fc,%eax
8010285a:	83 c8 40             	or     $0x40,%eax
8010285d:	a3 fc 40 19 80       	mov    %eax,0x801940fc
80102862:	b8 00 00 00 00       	mov    $0x0,%eax
80102867:	e9 f3 00 00 00       	jmp    8010295f <kbdgetc+0x14d>
8010286c:	8b 45 fc             	mov    -0x4(%ebp),%eax
8010286f:	25 80 00 00 00       	and    $0x80,%eax
80102874:	85 c0                	test   %eax,%eax
80102876:	74 45                	je     801028bd <kbdgetc+0xab>
80102878:	a1 fc 40 19 80       	mov    0x801940fc,%eax
8010287d:	83 e0 40             	and    $0x40,%eax
80102880:	85 c0                	test   %eax,%eax
80102882:	75 08                	jne    8010288c <kbdgetc+0x7a>
80102884:	8b 45 fc             	mov    -0x4(%ebp),%eax
80102887:	83 e0 7f             	and    $0x7f,%eax
8010288a:	eb 03                	jmp    8010288f <kbdgetc+0x7d>
8010288c:	8b 45 fc             	mov    -0x4(%ebp),%eax
8010288f:	89 45 fc             	mov    %eax,-0x4(%ebp)
80102892:	8b 45 fc             	mov    -0x4(%ebp),%eax
80102895:	05 20 d0 10 80       	add    $0x8010d020,%eax
8010289a:	0f b6 00             	movzbl (%eax),%eax
8010289d:	83 c8 40             	or     $0x40,%eax
801028a0:	0f b6 c0             	movzbl %al,%eax
801028a3:	f7 d0                	not    %eax
801028a5:	89 c2                	mov    %eax,%edx
801028a7:	a1 fc 40 19 80       	mov    0x801940fc,%eax
801028ac:	21 d0                	and    %edx,%eax
801028ae:	a3 fc 40 19 80       	mov    %eax,0x801940fc
801028b3:	b8 00 00 00 00       	mov    $0x0,%eax
801028b8:	e9 a2 00 00 00       	jmp    8010295f <kbdgetc+0x14d>
801028bd:	a1 fc 40 19 80       	mov    0x801940fc,%eax
801028c2:	83 e0 40             	and    $0x40,%eax
801028c5:	85 c0                	test   %eax,%eax
801028c7:	74 14                	je     801028dd <kbdgetc+0xcb>
801028c9:	81 4d fc 80 00 00 00 	orl    $0x80,-0x4(%ebp)
801028d0:	a1 fc 40 19 80       	mov    0x801940fc,%eax
801028d5:	83 e0 bf             	and    $0xffffffbf,%eax
801028d8:	a3 fc 40 19 80       	mov    %eax,0x801940fc
801028dd:	8b 45 fc             	mov    -0x4(%ebp),%eax
801028e0:	05 20 d0 10 80       	add    $0x8010d020,%eax
801028e5:	0f b6 00             	movzbl (%eax),%eax
801028e8:	0f b6 d0             	movzbl %al,%edx
801028eb:	a1 fc 40 19 80       	mov    0x801940fc,%eax
801028f0:	09 d0                	or     %edx,%eax
801028f2:	a3 fc 40 19 80       	mov    %eax,0x801940fc
801028f7:	8b 45 fc             	mov    -0x4(%ebp),%eax
801028fa:	05 20 d1 10 80       	add    $0x8010d120,%eax
801028ff:	0f b6 00             	movzbl (%eax),%eax
80102902:	0f b6 d0             	movzbl %al,%edx
80102905:	a1 fc 40 19 80       	mov    0x801940fc,%eax
8010290a:	31 d0                	xor    %edx,%eax
8010290c:	a3 fc 40 19 80       	mov    %eax,0x801940fc
80102911:	a1 fc 40 19 80       	mov    0x801940fc,%eax
80102916:	83 e0 03             	and    $0x3,%eax
80102919:	8b 14 85 20 d5 10 80 	mov    -0x7fef2ae0(,%eax,4),%edx
80102920:	8b 45 fc             	mov    -0x4(%ebp),%eax
80102923:	01 d0                	add    %edx,%eax
80102925:	0f b6 00             	movzbl (%eax),%eax
80102928:	0f b6 c0             	movzbl %al,%eax
8010292b:	89 45 f8             	mov    %eax,-0x8(%ebp)
8010292e:	a1 fc 40 19 80       	mov    0x801940fc,%eax
80102933:	83 e0 08             	and    $0x8,%eax
80102936:	85 c0                	test   %eax,%eax
80102938:	74 22                	je     8010295c <kbdgetc+0x14a>
8010293a:	83 7d f8 60          	cmpl   $0x60,-0x8(%ebp)
8010293e:	76 0c                	jbe    8010294c <kbdgetc+0x13a>
80102940:	83 7d f8 7a          	cmpl   $0x7a,-0x8(%ebp)
80102944:	77 06                	ja     8010294c <kbdgetc+0x13a>
80102946:	83 6d f8 20          	subl   $0x20,-0x8(%ebp)
8010294a:	eb 10                	jmp    8010295c <kbdgetc+0x14a>
8010294c:	83 7d f8 40          	cmpl   $0x40,-0x8(%ebp)
80102950:	76 0a                	jbe    8010295c <kbdgetc+0x14a>
80102952:	83 7d f8 5a          	cmpl   $0x5a,-0x8(%ebp)
80102956:	77 04                	ja     8010295c <kbdgetc+0x14a>
80102958:	83 45 f8 20          	addl   $0x20,-0x8(%ebp)
8010295c:	8b 45 f8             	mov    -0x8(%ebp),%eax
8010295f:	c9                   	leave  
80102960:	c3                   	ret    

80102961 <kbdintr>:
80102961:	55                   	push   %ebp
80102962:	89 e5                	mov    %esp,%ebp
80102964:	83 ec 08             	sub    $0x8,%esp
80102967:	83 ec 0c             	sub    $0xc,%esp
8010296a:	68 12 28 10 80       	push   $0x80102812
8010296f:	e8 62 de ff ff       	call   801007d6 <consoleintr>
80102974:	83 c4 10             	add    $0x10,%esp
80102977:	90                   	nop
80102978:	c9                   	leave  
80102979:	c3                   	ret    

8010297a <inb>:
8010297a:	55                   	push   %ebp
8010297b:	89 e5                	mov    %esp,%ebp
8010297d:	83 ec 14             	sub    $0x14,%esp
80102980:	8b 45 08             	mov    0x8(%ebp),%eax
80102983:	66 89 45 ec          	mov    %ax,-0x14(%ebp)
80102987:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
8010298b:	89 c2                	mov    %eax,%edx
8010298d:	ec                   	in     (%dx),%al
8010298e:	88 45 ff             	mov    %al,-0x1(%ebp)
80102991:	0f b6 45 ff          	movzbl -0x1(%ebp),%eax
80102995:	c9                   	leave  
80102996:	c3                   	ret    

80102997 <outb>:
80102997:	55                   	push   %ebp
80102998:	89 e5                	mov    %esp,%ebp
8010299a:	83 ec 08             	sub    $0x8,%esp
8010299d:	8b 45 08             	mov    0x8(%ebp),%eax
801029a0:	8b 55 0c             	mov    0xc(%ebp),%edx
801029a3:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
801029a7:	89 d0                	mov    %edx,%eax
801029a9:	88 45 f8             	mov    %al,-0x8(%ebp)
801029ac:	0f b6 45 f8          	movzbl -0x8(%ebp),%eax
801029b0:	0f b7 55 fc          	movzwl -0x4(%ebp),%edx
801029b4:	ee                   	out    %al,(%dx)
801029b5:	90                   	nop
801029b6:	c9                   	leave  
801029b7:	c3                   	ret    

801029b8 <lapicw>:
801029b8:	55                   	push   %ebp
801029b9:	89 e5                	mov    %esp,%ebp
801029bb:	8b 15 00 41 19 80    	mov    0x80194100,%edx
801029c1:	8b 45 08             	mov    0x8(%ebp),%eax
801029c4:	c1 e0 02             	shl    $0x2,%eax
801029c7:	01 c2                	add    %eax,%edx
801029c9:	8b 45 0c             	mov    0xc(%ebp),%eax
801029cc:	89 02                	mov    %eax,(%edx)
801029ce:	a1 00 41 19 80       	mov    0x80194100,%eax
801029d3:	83 c0 20             	add    $0x20,%eax
801029d6:	8b 00                	mov    (%eax),%eax
801029d8:	90                   	nop
801029d9:	5d                   	pop    %ebp
801029da:	c3                   	ret    

801029db <lapicinit>:
801029db:	55                   	push   %ebp
801029dc:	89 e5                	mov    %esp,%ebp
801029de:	a1 00 41 19 80       	mov    0x80194100,%eax
801029e3:	85 c0                	test   %eax,%eax
801029e5:	0f 84 0c 01 00 00    	je     80102af7 <lapicinit+0x11c>
801029eb:	68 3f 01 00 00       	push   $0x13f
801029f0:	6a 3c                	push   $0x3c
801029f2:	e8 c1 ff ff ff       	call   801029b8 <lapicw>
801029f7:	83 c4 08             	add    $0x8,%esp
801029fa:	6a 0b                	push   $0xb
801029fc:	68 f8 00 00 00       	push   $0xf8
80102a01:	e8 b2 ff ff ff       	call   801029b8 <lapicw>
80102a06:	83 c4 08             	add    $0x8,%esp
80102a09:	68 20 00 02 00       	push   $0x20020
80102a0e:	68 c8 00 00 00       	push   $0xc8
80102a13:	e8 a0 ff ff ff       	call   801029b8 <lapicw>
80102a18:	83 c4 08             	add    $0x8,%esp
80102a1b:	68 80 96 98 00       	push   $0x989680
80102a20:	68 e0 00 00 00       	push   $0xe0
80102a25:	e8 8e ff ff ff       	call   801029b8 <lapicw>
80102a2a:	83 c4 08             	add    $0x8,%esp
80102a2d:	68 00 00 01 00       	push   $0x10000
80102a32:	68 d4 00 00 00       	push   $0xd4
80102a37:	e8 7c ff ff ff       	call   801029b8 <lapicw>
80102a3c:	83 c4 08             	add    $0x8,%esp
80102a3f:	68 00 00 01 00       	push   $0x10000
80102a44:	68 d8 00 00 00       	push   $0xd8
80102a49:	e8 6a ff ff ff       	call   801029b8 <lapicw>
80102a4e:	83 c4 08             	add    $0x8,%esp
80102a51:	a1 00 41 19 80       	mov    0x80194100,%eax
80102a56:	83 c0 30             	add    $0x30,%eax
80102a59:	8b 00                	mov    (%eax),%eax
80102a5b:	c1 e8 10             	shr    $0x10,%eax
80102a5e:	25 fc 00 00 00       	and    $0xfc,%eax
80102a63:	85 c0                	test   %eax,%eax
80102a65:	74 12                	je     80102a79 <lapicinit+0x9e>
80102a67:	68 00 00 01 00       	push   $0x10000
80102a6c:	68 d0 00 00 00       	push   $0xd0
80102a71:	e8 42 ff ff ff       	call   801029b8 <lapicw>
80102a76:	83 c4 08             	add    $0x8,%esp
80102a79:	6a 33                	push   $0x33
80102a7b:	68 dc 00 00 00       	push   $0xdc
80102a80:	e8 33 ff ff ff       	call   801029b8 <lapicw>
80102a85:	83 c4 08             	add    $0x8,%esp
80102a88:	6a 00                	push   $0x0
80102a8a:	68 a0 00 00 00       	push   $0xa0
80102a8f:	e8 24 ff ff ff       	call   801029b8 <lapicw>
80102a94:	83 c4 08             	add    $0x8,%esp
80102a97:	6a 00                	push   $0x0
80102a99:	68 a0 00 00 00       	push   $0xa0
80102a9e:	e8 15 ff ff ff       	call   801029b8 <lapicw>
80102aa3:	83 c4 08             	add    $0x8,%esp
80102aa6:	6a 00                	push   $0x0
80102aa8:	6a 2c                	push   $0x2c
80102aaa:	e8 09 ff ff ff       	call   801029b8 <lapicw>
80102aaf:	83 c4 08             	add    $0x8,%esp
80102ab2:	6a 00                	push   $0x0
80102ab4:	68 c4 00 00 00       	push   $0xc4
80102ab9:	e8 fa fe ff ff       	call   801029b8 <lapicw>
80102abe:	83 c4 08             	add    $0x8,%esp
80102ac1:	68 00 85 08 00       	push   $0x88500
80102ac6:	68 c0 00 00 00       	push   $0xc0
80102acb:	e8 e8 fe ff ff       	call   801029b8 <lapicw>
80102ad0:	83 c4 08             	add    $0x8,%esp
80102ad3:	90                   	nop
80102ad4:	a1 00 41 19 80       	mov    0x80194100,%eax
80102ad9:	05 00 03 00 00       	add    $0x300,%eax
80102ade:	8b 00                	mov    (%eax),%eax
80102ae0:	25 00 10 00 00       	and    $0x1000,%eax
80102ae5:	85 c0                	test   %eax,%eax
80102ae7:	75 eb                	jne    80102ad4 <lapicinit+0xf9>
80102ae9:	6a 00                	push   $0x0
80102aeb:	6a 20                	push   $0x20
80102aed:	e8 c6 fe ff ff       	call   801029b8 <lapicw>
80102af2:	83 c4 08             	add    $0x8,%esp
80102af5:	eb 01                	jmp    80102af8 <lapicinit+0x11d>
80102af7:	90                   	nop
80102af8:	c9                   	leave  
80102af9:	c3                   	ret    

80102afa <lapicid>:
80102afa:	55                   	push   %ebp
80102afb:	89 e5                	mov    %esp,%ebp
80102afd:	a1 00 41 19 80       	mov    0x80194100,%eax
80102b02:	85 c0                	test   %eax,%eax
80102b04:	75 07                	jne    80102b0d <lapicid+0x13>
80102b06:	b8 00 00 00 00       	mov    $0x0,%eax
80102b0b:	eb 0d                	jmp    80102b1a <lapicid+0x20>
80102b0d:	a1 00 41 19 80       	mov    0x80194100,%eax
80102b12:	83 c0 20             	add    $0x20,%eax
80102b15:	8b 00                	mov    (%eax),%eax
80102b17:	c1 e8 18             	shr    $0x18,%eax
80102b1a:	5d                   	pop    %ebp
80102b1b:	c3                   	ret    

80102b1c <lapiceoi>:
80102b1c:	55                   	push   %ebp
80102b1d:	89 e5                	mov    %esp,%ebp
80102b1f:	a1 00 41 19 80       	mov    0x80194100,%eax
80102b24:	85 c0                	test   %eax,%eax
80102b26:	74 0c                	je     80102b34 <lapiceoi+0x18>
80102b28:	6a 00                	push   $0x0
80102b2a:	6a 2c                	push   $0x2c
80102b2c:	e8 87 fe ff ff       	call   801029b8 <lapicw>
80102b31:	83 c4 08             	add    $0x8,%esp
80102b34:	90                   	nop
80102b35:	c9                   	leave  
80102b36:	c3                   	ret    

80102b37 <microdelay>:
80102b37:	55                   	push   %ebp
80102b38:	89 e5                	mov    %esp,%ebp
80102b3a:	90                   	nop
80102b3b:	5d                   	pop    %ebp
80102b3c:	c3                   	ret    

80102b3d <lapicstartap>:
80102b3d:	55                   	push   %ebp
80102b3e:	89 e5                	mov    %esp,%ebp
80102b40:	83 ec 14             	sub    $0x14,%esp
80102b43:	8b 45 08             	mov    0x8(%ebp),%eax
80102b46:	88 45 ec             	mov    %al,-0x14(%ebp)
80102b49:	6a 0f                	push   $0xf
80102b4b:	6a 70                	push   $0x70
80102b4d:	e8 45 fe ff ff       	call   80102997 <outb>
80102b52:	83 c4 08             	add    $0x8,%esp
80102b55:	6a 0a                	push   $0xa
80102b57:	6a 71                	push   $0x71
80102b59:	e8 39 fe ff ff       	call   80102997 <outb>
80102b5e:	83 c4 08             	add    $0x8,%esp
80102b61:	c7 45 f8 67 04 00 80 	movl   $0x80000467,-0x8(%ebp)
80102b68:	8b 45 f8             	mov    -0x8(%ebp),%eax
80102b6b:	66 c7 00 00 00       	movw   $0x0,(%eax)
80102b70:	8b 45 0c             	mov    0xc(%ebp),%eax
80102b73:	c1 e8 04             	shr    $0x4,%eax
80102b76:	89 c2                	mov    %eax,%edx
80102b78:	8b 45 f8             	mov    -0x8(%ebp),%eax
80102b7b:	83 c0 02             	add    $0x2,%eax
80102b7e:	66 89 10             	mov    %dx,(%eax)
80102b81:	0f b6 45 ec          	movzbl -0x14(%ebp),%eax
80102b85:	c1 e0 18             	shl    $0x18,%eax
80102b88:	50                   	push   %eax
80102b89:	68 c4 00 00 00       	push   $0xc4
80102b8e:	e8 25 fe ff ff       	call   801029b8 <lapicw>
80102b93:	83 c4 08             	add    $0x8,%esp
80102b96:	68 00 c5 00 00       	push   $0xc500
80102b9b:	68 c0 00 00 00       	push   $0xc0
80102ba0:	e8 13 fe ff ff       	call   801029b8 <lapicw>
80102ba5:	83 c4 08             	add    $0x8,%esp
80102ba8:	68 c8 00 00 00       	push   $0xc8
80102bad:	e8 85 ff ff ff       	call   80102b37 <microdelay>
80102bb2:	83 c4 04             	add    $0x4,%esp
80102bb5:	68 00 85 00 00       	push   $0x8500
80102bba:	68 c0 00 00 00       	push   $0xc0
80102bbf:	e8 f4 fd ff ff       	call   801029b8 <lapicw>
80102bc4:	83 c4 08             	add    $0x8,%esp
80102bc7:	6a 64                	push   $0x64
80102bc9:	e8 69 ff ff ff       	call   80102b37 <microdelay>
80102bce:	83 c4 04             	add    $0x4,%esp
80102bd1:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
80102bd8:	eb 3d                	jmp    80102c17 <lapicstartap+0xda>
80102bda:	0f b6 45 ec          	movzbl -0x14(%ebp),%eax
80102bde:	c1 e0 18             	shl    $0x18,%eax
80102be1:	50                   	push   %eax
80102be2:	68 c4 00 00 00       	push   $0xc4
80102be7:	e8 cc fd ff ff       	call   801029b8 <lapicw>
80102bec:	83 c4 08             	add    $0x8,%esp
80102bef:	8b 45 0c             	mov    0xc(%ebp),%eax
80102bf2:	c1 e8 0c             	shr    $0xc,%eax
80102bf5:	80 cc 06             	or     $0x6,%ah
80102bf8:	50                   	push   %eax
80102bf9:	68 c0 00 00 00       	push   $0xc0
80102bfe:	e8 b5 fd ff ff       	call   801029b8 <lapicw>
80102c03:	83 c4 08             	add    $0x8,%esp
80102c06:	68 c8 00 00 00       	push   $0xc8
80102c0b:	e8 27 ff ff ff       	call   80102b37 <microdelay>
80102c10:	83 c4 04             	add    $0x4,%esp
80102c13:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
80102c17:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
80102c1b:	7e bd                	jle    80102bda <lapicstartap+0x9d>
80102c1d:	90                   	nop
80102c1e:	90                   	nop
80102c1f:	c9                   	leave  
80102c20:	c3                   	ret    

80102c21 <cmos_read>:
80102c21:	55                   	push   %ebp
80102c22:	89 e5                	mov    %esp,%ebp
80102c24:	8b 45 08             	mov    0x8(%ebp),%eax
80102c27:	0f b6 c0             	movzbl %al,%eax
80102c2a:	50                   	push   %eax
80102c2b:	6a 70                	push   $0x70
80102c2d:	e8 65 fd ff ff       	call   80102997 <outb>
80102c32:	83 c4 08             	add    $0x8,%esp
80102c35:	68 c8 00 00 00       	push   $0xc8
80102c3a:	e8 f8 fe ff ff       	call   80102b37 <microdelay>
80102c3f:	83 c4 04             	add    $0x4,%esp
80102c42:	6a 71                	push   $0x71
80102c44:	e8 31 fd ff ff       	call   8010297a <inb>
80102c49:	83 c4 04             	add    $0x4,%esp
80102c4c:	0f b6 c0             	movzbl %al,%eax
80102c4f:	c9                   	leave  
80102c50:	c3                   	ret    

80102c51 <fill_rtcdate>:
80102c51:	55                   	push   %ebp
80102c52:	89 e5                	mov    %esp,%ebp
80102c54:	6a 00                	push   $0x0
80102c56:	e8 c6 ff ff ff       	call   80102c21 <cmos_read>
80102c5b:	83 c4 04             	add    $0x4,%esp
80102c5e:	8b 55 08             	mov    0x8(%ebp),%edx
80102c61:	89 02                	mov    %eax,(%edx)
80102c63:	6a 02                	push   $0x2
80102c65:	e8 b7 ff ff ff       	call   80102c21 <cmos_read>
80102c6a:	83 c4 04             	add    $0x4,%esp
80102c6d:	8b 55 08             	mov    0x8(%ebp),%edx
80102c70:	89 42 04             	mov    %eax,0x4(%edx)
80102c73:	6a 04                	push   $0x4
80102c75:	e8 a7 ff ff ff       	call   80102c21 <cmos_read>
80102c7a:	83 c4 04             	add    $0x4,%esp
80102c7d:	8b 55 08             	mov    0x8(%ebp),%edx
80102c80:	89 42 08             	mov    %eax,0x8(%edx)
80102c83:	6a 07                	push   $0x7
80102c85:	e8 97 ff ff ff       	call   80102c21 <cmos_read>
80102c8a:	83 c4 04             	add    $0x4,%esp
80102c8d:	8b 55 08             	mov    0x8(%ebp),%edx
80102c90:	89 42 0c             	mov    %eax,0xc(%edx)
80102c93:	6a 08                	push   $0x8
80102c95:	e8 87 ff ff ff       	call   80102c21 <cmos_read>
80102c9a:	83 c4 04             	add    $0x4,%esp
80102c9d:	8b 55 08             	mov    0x8(%ebp),%edx
80102ca0:	89 42 10             	mov    %eax,0x10(%edx)
80102ca3:	6a 09                	push   $0x9
80102ca5:	e8 77 ff ff ff       	call   80102c21 <cmos_read>
80102caa:	83 c4 04             	add    $0x4,%esp
80102cad:	8b 55 08             	mov    0x8(%ebp),%edx
80102cb0:	89 42 14             	mov    %eax,0x14(%edx)
80102cb3:	90                   	nop
80102cb4:	c9                   	leave  
80102cb5:	c3                   	ret    

80102cb6 <cmostime>:
80102cb6:	55                   	push   %ebp
80102cb7:	89 e5                	mov    %esp,%ebp
80102cb9:	83 ec 48             	sub    $0x48,%esp
80102cbc:	6a 0b                	push   $0xb
80102cbe:	e8 5e ff ff ff       	call   80102c21 <cmos_read>
80102cc3:	83 c4 04             	add    $0x4,%esp
80102cc6:	89 45 f4             	mov    %eax,-0xc(%ebp)
80102cc9:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102ccc:	83 e0 04             	and    $0x4,%eax
80102ccf:	85 c0                	test   %eax,%eax
80102cd1:	0f 94 c0             	sete   %al
80102cd4:	0f b6 c0             	movzbl %al,%eax
80102cd7:	89 45 f0             	mov    %eax,-0x10(%ebp)
80102cda:	8d 45 d8             	lea    -0x28(%ebp),%eax
80102cdd:	50                   	push   %eax
80102cde:	e8 6e ff ff ff       	call   80102c51 <fill_rtcdate>
80102ce3:	83 c4 04             	add    $0x4,%esp
80102ce6:	6a 0a                	push   $0xa
80102ce8:	e8 34 ff ff ff       	call   80102c21 <cmos_read>
80102ced:	83 c4 04             	add    $0x4,%esp
80102cf0:	25 80 00 00 00       	and    $0x80,%eax
80102cf5:	85 c0                	test   %eax,%eax
80102cf7:	75 27                	jne    80102d20 <cmostime+0x6a>
80102cf9:	8d 45 c0             	lea    -0x40(%ebp),%eax
80102cfc:	50                   	push   %eax
80102cfd:	e8 4f ff ff ff       	call   80102c51 <fill_rtcdate>
80102d02:	83 c4 04             	add    $0x4,%esp
80102d05:	83 ec 04             	sub    $0x4,%esp
80102d08:	6a 18                	push   $0x18
80102d0a:	8d 45 c0             	lea    -0x40(%ebp),%eax
80102d0d:	50                   	push   %eax
80102d0e:	8d 45 d8             	lea    -0x28(%ebp),%eax
80102d11:	50                   	push   %eax
80102d12:	e8 2e 1f 00 00       	call   80104c45 <memcmp>
80102d17:	83 c4 10             	add    $0x10,%esp
80102d1a:	85 c0                	test   %eax,%eax
80102d1c:	74 05                	je     80102d23 <cmostime+0x6d>
80102d1e:	eb ba                	jmp    80102cda <cmostime+0x24>
80102d20:	90                   	nop
80102d21:	eb b7                	jmp    80102cda <cmostime+0x24>
80102d23:	90                   	nop
80102d24:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80102d28:	0f 84 b4 00 00 00    	je     80102de2 <cmostime+0x12c>
80102d2e:	8b 45 d8             	mov    -0x28(%ebp),%eax
80102d31:	c1 e8 04             	shr    $0x4,%eax
80102d34:	89 c2                	mov    %eax,%edx
80102d36:	89 d0                	mov    %edx,%eax
80102d38:	c1 e0 02             	shl    $0x2,%eax
80102d3b:	01 d0                	add    %edx,%eax
80102d3d:	01 c0                	add    %eax,%eax
80102d3f:	89 c2                	mov    %eax,%edx
80102d41:	8b 45 d8             	mov    -0x28(%ebp),%eax
80102d44:	83 e0 0f             	and    $0xf,%eax
80102d47:	01 d0                	add    %edx,%eax
80102d49:	89 45 d8             	mov    %eax,-0x28(%ebp)
80102d4c:	8b 45 dc             	mov    -0x24(%ebp),%eax
80102d4f:	c1 e8 04             	shr    $0x4,%eax
80102d52:	89 c2                	mov    %eax,%edx
80102d54:	89 d0                	mov    %edx,%eax
80102d56:	c1 e0 02             	shl    $0x2,%eax
80102d59:	01 d0                	add    %edx,%eax
80102d5b:	01 c0                	add    %eax,%eax
80102d5d:	89 c2                	mov    %eax,%edx
80102d5f:	8b 45 dc             	mov    -0x24(%ebp),%eax
80102d62:	83 e0 0f             	and    $0xf,%eax
80102d65:	01 d0                	add    %edx,%eax
80102d67:	89 45 dc             	mov    %eax,-0x24(%ebp)
80102d6a:	8b 45 e0             	mov    -0x20(%ebp),%eax
80102d6d:	c1 e8 04             	shr    $0x4,%eax
80102d70:	89 c2                	mov    %eax,%edx
80102d72:	89 d0                	mov    %edx,%eax
80102d74:	c1 e0 02             	shl    $0x2,%eax
80102d77:	01 d0                	add    %edx,%eax
80102d79:	01 c0                	add    %eax,%eax
80102d7b:	89 c2                	mov    %eax,%edx
80102d7d:	8b 45 e0             	mov    -0x20(%ebp),%eax
80102d80:	83 e0 0f             	and    $0xf,%eax
80102d83:	01 d0                	add    %edx,%eax
80102d85:	89 45 e0             	mov    %eax,-0x20(%ebp)
80102d88:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80102d8b:	c1 e8 04             	shr    $0x4,%eax
80102d8e:	89 c2                	mov    %eax,%edx
80102d90:	89 d0                	mov    %edx,%eax
80102d92:	c1 e0 02             	shl    $0x2,%eax
80102d95:	01 d0                	add    %edx,%eax
80102d97:	01 c0                	add    %eax,%eax
80102d99:	89 c2                	mov    %eax,%edx
80102d9b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80102d9e:	83 e0 0f             	and    $0xf,%eax
80102da1:	01 d0                	add    %edx,%eax
80102da3:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80102da6:	8b 45 e8             	mov    -0x18(%ebp),%eax
80102da9:	c1 e8 04             	shr    $0x4,%eax
80102dac:	89 c2                	mov    %eax,%edx
80102dae:	89 d0                	mov    %edx,%eax
80102db0:	c1 e0 02             	shl    $0x2,%eax
80102db3:	01 d0                	add    %edx,%eax
80102db5:	01 c0                	add    %eax,%eax
80102db7:	89 c2                	mov    %eax,%edx
80102db9:	8b 45 e8             	mov    -0x18(%ebp),%eax
80102dbc:	83 e0 0f             	and    $0xf,%eax
80102dbf:	01 d0                	add    %edx,%eax
80102dc1:	89 45 e8             	mov    %eax,-0x18(%ebp)
80102dc4:	8b 45 ec             	mov    -0x14(%ebp),%eax
80102dc7:	c1 e8 04             	shr    $0x4,%eax
80102dca:	89 c2                	mov    %eax,%edx
80102dcc:	89 d0                	mov    %edx,%eax
80102dce:	c1 e0 02             	shl    $0x2,%eax
80102dd1:	01 d0                	add    %edx,%eax
80102dd3:	01 c0                	add    %eax,%eax
80102dd5:	89 c2                	mov    %eax,%edx
80102dd7:	8b 45 ec             	mov    -0x14(%ebp),%eax
80102dda:	83 e0 0f             	and    $0xf,%eax
80102ddd:	01 d0                	add    %edx,%eax
80102ddf:	89 45 ec             	mov    %eax,-0x14(%ebp)
80102de2:	8b 45 08             	mov    0x8(%ebp),%eax
80102de5:	8b 55 d8             	mov    -0x28(%ebp),%edx
80102de8:	89 10                	mov    %edx,(%eax)
80102dea:	8b 55 dc             	mov    -0x24(%ebp),%edx
80102ded:	89 50 04             	mov    %edx,0x4(%eax)
80102df0:	8b 55 e0             	mov    -0x20(%ebp),%edx
80102df3:	89 50 08             	mov    %edx,0x8(%eax)
80102df6:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80102df9:	89 50 0c             	mov    %edx,0xc(%eax)
80102dfc:	8b 55 e8             	mov    -0x18(%ebp),%edx
80102dff:	89 50 10             	mov    %edx,0x10(%eax)
80102e02:	8b 55 ec             	mov    -0x14(%ebp),%edx
80102e05:	89 50 14             	mov    %edx,0x14(%eax)
80102e08:	8b 45 08             	mov    0x8(%ebp),%eax
80102e0b:	8b 40 14             	mov    0x14(%eax),%eax
80102e0e:	8d 90 d0 07 00 00    	lea    0x7d0(%eax),%edx
80102e14:	8b 45 08             	mov    0x8(%ebp),%eax
80102e17:	89 50 14             	mov    %edx,0x14(%eax)
80102e1a:	90                   	nop
80102e1b:	c9                   	leave  
80102e1c:	c3                   	ret    

80102e1d <initlog>:
80102e1d:	55                   	push   %ebp
80102e1e:	89 e5                	mov    %esp,%ebp
80102e20:	83 ec 28             	sub    $0x28,%esp
80102e23:	83 ec 08             	sub    $0x8,%esp
80102e26:	68 71 a4 10 80       	push   $0x8010a471
80102e2b:	68 20 41 19 80       	push   $0x80194120
80102e30:	e8 11 1b 00 00       	call   80104946 <initlock>
80102e35:	83 c4 10             	add    $0x10,%esp
80102e38:	83 ec 08             	sub    $0x8,%esp
80102e3b:	8d 45 dc             	lea    -0x24(%ebp),%eax
80102e3e:	50                   	push   %eax
80102e3f:	ff 75 08             	push   0x8(%ebp)
80102e42:	e8 87 e5 ff ff       	call   801013ce <readsb>
80102e47:	83 c4 10             	add    $0x10,%esp
80102e4a:	8b 45 ec             	mov    -0x14(%ebp),%eax
80102e4d:	a3 54 41 19 80       	mov    %eax,0x80194154
80102e52:	8b 45 e8             	mov    -0x18(%ebp),%eax
80102e55:	a3 58 41 19 80       	mov    %eax,0x80194158
80102e5a:	8b 45 08             	mov    0x8(%ebp),%eax
80102e5d:	a3 64 41 19 80       	mov    %eax,0x80194164
80102e62:	e8 b3 01 00 00       	call   8010301a <recover_from_log>
80102e67:	90                   	nop
80102e68:	c9                   	leave  
80102e69:	c3                   	ret    

80102e6a <install_trans>:
80102e6a:	55                   	push   %ebp
80102e6b:	89 e5                	mov    %esp,%ebp
80102e6d:	83 ec 18             	sub    $0x18,%esp
80102e70:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80102e77:	e9 95 00 00 00       	jmp    80102f11 <install_trans+0xa7>
80102e7c:	8b 15 54 41 19 80    	mov    0x80194154,%edx
80102e82:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102e85:	01 d0                	add    %edx,%eax
80102e87:	83 c0 01             	add    $0x1,%eax
80102e8a:	89 c2                	mov    %eax,%edx
80102e8c:	a1 64 41 19 80       	mov    0x80194164,%eax
80102e91:	83 ec 08             	sub    $0x8,%esp
80102e94:	52                   	push   %edx
80102e95:	50                   	push   %eax
80102e96:	e8 66 d3 ff ff       	call   80100201 <bread>
80102e9b:	83 c4 10             	add    $0x10,%esp
80102e9e:	89 45 f0             	mov    %eax,-0x10(%ebp)
80102ea1:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102ea4:	83 c0 10             	add    $0x10,%eax
80102ea7:	8b 04 85 2c 41 19 80 	mov    -0x7fe6bed4(,%eax,4),%eax
80102eae:	89 c2                	mov    %eax,%edx
80102eb0:	a1 64 41 19 80       	mov    0x80194164,%eax
80102eb5:	83 ec 08             	sub    $0x8,%esp
80102eb8:	52                   	push   %edx
80102eb9:	50                   	push   %eax
80102eba:	e8 42 d3 ff ff       	call   80100201 <bread>
80102ebf:	83 c4 10             	add    $0x10,%esp
80102ec2:	89 45 ec             	mov    %eax,-0x14(%ebp)
80102ec5:	8b 45 f0             	mov    -0x10(%ebp),%eax
80102ec8:	8d 50 5c             	lea    0x5c(%eax),%edx
80102ecb:	8b 45 ec             	mov    -0x14(%ebp),%eax
80102ece:	83 c0 5c             	add    $0x5c,%eax
80102ed1:	83 ec 04             	sub    $0x4,%esp
80102ed4:	68 00 02 00 00       	push   $0x200
80102ed9:	52                   	push   %edx
80102eda:	50                   	push   %eax
80102edb:	e8 bd 1d 00 00       	call   80104c9d <memmove>
80102ee0:	83 c4 10             	add    $0x10,%esp
80102ee3:	83 ec 0c             	sub    $0xc,%esp
80102ee6:	ff 75 ec             	push   -0x14(%ebp)
80102ee9:	e8 4c d3 ff ff       	call   8010023a <bwrite>
80102eee:	83 c4 10             	add    $0x10,%esp
80102ef1:	83 ec 0c             	sub    $0xc,%esp
80102ef4:	ff 75 f0             	push   -0x10(%ebp)
80102ef7:	e8 87 d3 ff ff       	call   80100283 <brelse>
80102efc:	83 c4 10             	add    $0x10,%esp
80102eff:	83 ec 0c             	sub    $0xc,%esp
80102f02:	ff 75 ec             	push   -0x14(%ebp)
80102f05:	e8 79 d3 ff ff       	call   80100283 <brelse>
80102f0a:	83 c4 10             	add    $0x10,%esp
80102f0d:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80102f11:	a1 68 41 19 80       	mov    0x80194168,%eax
80102f16:	39 45 f4             	cmp    %eax,-0xc(%ebp)
80102f19:	0f 8c 5d ff ff ff    	jl     80102e7c <install_trans+0x12>
80102f1f:	90                   	nop
80102f20:	90                   	nop
80102f21:	c9                   	leave  
80102f22:	c3                   	ret    

80102f23 <read_head>:
80102f23:	55                   	push   %ebp
80102f24:	89 e5                	mov    %esp,%ebp
80102f26:	83 ec 18             	sub    $0x18,%esp
80102f29:	a1 54 41 19 80       	mov    0x80194154,%eax
80102f2e:	89 c2                	mov    %eax,%edx
80102f30:	a1 64 41 19 80       	mov    0x80194164,%eax
80102f35:	83 ec 08             	sub    $0x8,%esp
80102f38:	52                   	push   %edx
80102f39:	50                   	push   %eax
80102f3a:	e8 c2 d2 ff ff       	call   80100201 <bread>
80102f3f:	83 c4 10             	add    $0x10,%esp
80102f42:	89 45 f0             	mov    %eax,-0x10(%ebp)
80102f45:	8b 45 f0             	mov    -0x10(%ebp),%eax
80102f48:	83 c0 5c             	add    $0x5c,%eax
80102f4b:	89 45 ec             	mov    %eax,-0x14(%ebp)
80102f4e:	8b 45 ec             	mov    -0x14(%ebp),%eax
80102f51:	8b 00                	mov    (%eax),%eax
80102f53:	a3 68 41 19 80       	mov    %eax,0x80194168
80102f58:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80102f5f:	eb 1b                	jmp    80102f7c <read_head+0x59>
80102f61:	8b 45 ec             	mov    -0x14(%ebp),%eax
80102f64:	8b 55 f4             	mov    -0xc(%ebp),%edx
80102f67:	8b 44 90 04          	mov    0x4(%eax,%edx,4),%eax
80102f6b:	8b 55 f4             	mov    -0xc(%ebp),%edx
80102f6e:	83 c2 10             	add    $0x10,%edx
80102f71:	89 04 95 2c 41 19 80 	mov    %eax,-0x7fe6bed4(,%edx,4)
80102f78:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80102f7c:	a1 68 41 19 80       	mov    0x80194168,%eax
80102f81:	39 45 f4             	cmp    %eax,-0xc(%ebp)
80102f84:	7c db                	jl     80102f61 <read_head+0x3e>
80102f86:	83 ec 0c             	sub    $0xc,%esp
80102f89:	ff 75 f0             	push   -0x10(%ebp)
80102f8c:	e8 f2 d2 ff ff       	call   80100283 <brelse>
80102f91:	83 c4 10             	add    $0x10,%esp
80102f94:	90                   	nop
80102f95:	c9                   	leave  
80102f96:	c3                   	ret    

80102f97 <write_head>:
80102f97:	55                   	push   %ebp
80102f98:	89 e5                	mov    %esp,%ebp
80102f9a:	83 ec 18             	sub    $0x18,%esp
80102f9d:	a1 54 41 19 80       	mov    0x80194154,%eax
80102fa2:	89 c2                	mov    %eax,%edx
80102fa4:	a1 64 41 19 80       	mov    0x80194164,%eax
80102fa9:	83 ec 08             	sub    $0x8,%esp
80102fac:	52                   	push   %edx
80102fad:	50                   	push   %eax
80102fae:	e8 4e d2 ff ff       	call   80100201 <bread>
80102fb3:	83 c4 10             	add    $0x10,%esp
80102fb6:	89 45 f0             	mov    %eax,-0x10(%ebp)
80102fb9:	8b 45 f0             	mov    -0x10(%ebp),%eax
80102fbc:	83 c0 5c             	add    $0x5c,%eax
80102fbf:	89 45 ec             	mov    %eax,-0x14(%ebp)
80102fc2:	8b 15 68 41 19 80    	mov    0x80194168,%edx
80102fc8:	8b 45 ec             	mov    -0x14(%ebp),%eax
80102fcb:	89 10                	mov    %edx,(%eax)
80102fcd:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80102fd4:	eb 1b                	jmp    80102ff1 <write_head+0x5a>
80102fd6:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102fd9:	83 c0 10             	add    $0x10,%eax
80102fdc:	8b 0c 85 2c 41 19 80 	mov    -0x7fe6bed4(,%eax,4),%ecx
80102fe3:	8b 45 ec             	mov    -0x14(%ebp),%eax
80102fe6:	8b 55 f4             	mov    -0xc(%ebp),%edx
80102fe9:	89 4c 90 04          	mov    %ecx,0x4(%eax,%edx,4)
80102fed:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80102ff1:	a1 68 41 19 80       	mov    0x80194168,%eax
80102ff6:	39 45 f4             	cmp    %eax,-0xc(%ebp)
80102ff9:	7c db                	jl     80102fd6 <write_head+0x3f>
80102ffb:	83 ec 0c             	sub    $0xc,%esp
80102ffe:	ff 75 f0             	push   -0x10(%ebp)
80103001:	e8 34 d2 ff ff       	call   8010023a <bwrite>
80103006:	83 c4 10             	add    $0x10,%esp
80103009:	83 ec 0c             	sub    $0xc,%esp
8010300c:	ff 75 f0             	push   -0x10(%ebp)
8010300f:	e8 6f d2 ff ff       	call   80100283 <brelse>
80103014:	83 c4 10             	add    $0x10,%esp
80103017:	90                   	nop
80103018:	c9                   	leave  
80103019:	c3                   	ret    

8010301a <recover_from_log>:
8010301a:	55                   	push   %ebp
8010301b:	89 e5                	mov    %esp,%ebp
8010301d:	83 ec 08             	sub    $0x8,%esp
80103020:	e8 fe fe ff ff       	call   80102f23 <read_head>
80103025:	e8 40 fe ff ff       	call   80102e6a <install_trans>
8010302a:	c7 05 68 41 19 80 00 	movl   $0x0,0x80194168
80103031:	00 00 00 
80103034:	e8 5e ff ff ff       	call   80102f97 <write_head>
80103039:	90                   	nop
8010303a:	c9                   	leave  
8010303b:	c3                   	ret    

8010303c <begin_op>:
8010303c:	55                   	push   %ebp
8010303d:	89 e5                	mov    %esp,%ebp
8010303f:	83 ec 08             	sub    $0x8,%esp
80103042:	83 ec 0c             	sub    $0xc,%esp
80103045:	68 20 41 19 80       	push   $0x80194120
8010304a:	e8 19 19 00 00       	call   80104968 <acquire>
8010304f:	83 c4 10             	add    $0x10,%esp
80103052:	a1 60 41 19 80       	mov    0x80194160,%eax
80103057:	85 c0                	test   %eax,%eax
80103059:	74 17                	je     80103072 <begin_op+0x36>
8010305b:	83 ec 08             	sub    $0x8,%esp
8010305e:	68 20 41 19 80       	push   $0x80194120
80103063:	68 20 41 19 80       	push   $0x80194120
80103068:	e8 e0 14 00 00       	call   8010454d <sleep>
8010306d:	83 c4 10             	add    $0x10,%esp
80103070:	eb e0                	jmp    80103052 <begin_op+0x16>
80103072:	8b 0d 68 41 19 80    	mov    0x80194168,%ecx
80103078:	a1 5c 41 19 80       	mov    0x8019415c,%eax
8010307d:	8d 50 01             	lea    0x1(%eax),%edx
80103080:	89 d0                	mov    %edx,%eax
80103082:	c1 e0 02             	shl    $0x2,%eax
80103085:	01 d0                	add    %edx,%eax
80103087:	01 c0                	add    %eax,%eax
80103089:	01 c8                	add    %ecx,%eax
8010308b:	83 f8 1e             	cmp    $0x1e,%eax
8010308e:	7e 17                	jle    801030a7 <begin_op+0x6b>
80103090:	83 ec 08             	sub    $0x8,%esp
80103093:	68 20 41 19 80       	push   $0x80194120
80103098:	68 20 41 19 80       	push   $0x80194120
8010309d:	e8 ab 14 00 00       	call   8010454d <sleep>
801030a2:	83 c4 10             	add    $0x10,%esp
801030a5:	eb ab                	jmp    80103052 <begin_op+0x16>
801030a7:	a1 5c 41 19 80       	mov    0x8019415c,%eax
801030ac:	83 c0 01             	add    $0x1,%eax
801030af:	a3 5c 41 19 80       	mov    %eax,0x8019415c
801030b4:	83 ec 0c             	sub    $0xc,%esp
801030b7:	68 20 41 19 80       	push   $0x80194120
801030bc:	e8 15 19 00 00       	call   801049d6 <release>
801030c1:	83 c4 10             	add    $0x10,%esp
801030c4:	90                   	nop
801030c5:	90                   	nop
801030c6:	c9                   	leave  
801030c7:	c3                   	ret    

801030c8 <end_op>:
801030c8:	55                   	push   %ebp
801030c9:	89 e5                	mov    %esp,%ebp
801030cb:	83 ec 18             	sub    $0x18,%esp
801030ce:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
801030d5:	83 ec 0c             	sub    $0xc,%esp
801030d8:	68 20 41 19 80       	push   $0x80194120
801030dd:	e8 86 18 00 00       	call   80104968 <acquire>
801030e2:	83 c4 10             	add    $0x10,%esp
801030e5:	a1 5c 41 19 80       	mov    0x8019415c,%eax
801030ea:	83 e8 01             	sub    $0x1,%eax
801030ed:	a3 5c 41 19 80       	mov    %eax,0x8019415c
801030f2:	a1 60 41 19 80       	mov    0x80194160,%eax
801030f7:	85 c0                	test   %eax,%eax
801030f9:	74 0d                	je     80103108 <end_op+0x40>
801030fb:	83 ec 0c             	sub    $0xc,%esp
801030fe:	68 75 a4 10 80       	push   $0x8010a475
80103103:	e8 a1 d4 ff ff       	call   801005a9 <panic>
80103108:	a1 5c 41 19 80       	mov    0x8019415c,%eax
8010310d:	85 c0                	test   %eax,%eax
8010310f:	75 13                	jne    80103124 <end_op+0x5c>
80103111:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
80103118:	c7 05 60 41 19 80 01 	movl   $0x1,0x80194160
8010311f:	00 00 00 
80103122:	eb 10                	jmp    80103134 <end_op+0x6c>
80103124:	83 ec 0c             	sub    $0xc,%esp
80103127:	68 20 41 19 80       	push   $0x80194120
8010312c:	e8 03 15 00 00       	call   80104634 <wakeup>
80103131:	83 c4 10             	add    $0x10,%esp
80103134:	83 ec 0c             	sub    $0xc,%esp
80103137:	68 20 41 19 80       	push   $0x80194120
8010313c:	e8 95 18 00 00       	call   801049d6 <release>
80103141:	83 c4 10             	add    $0x10,%esp
80103144:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80103148:	74 3f                	je     80103189 <end_op+0xc1>
8010314a:	e8 f6 00 00 00       	call   80103245 <commit>
8010314f:	83 ec 0c             	sub    $0xc,%esp
80103152:	68 20 41 19 80       	push   $0x80194120
80103157:	e8 0c 18 00 00       	call   80104968 <acquire>
8010315c:	83 c4 10             	add    $0x10,%esp
8010315f:	c7 05 60 41 19 80 00 	movl   $0x0,0x80194160
80103166:	00 00 00 
80103169:	83 ec 0c             	sub    $0xc,%esp
8010316c:	68 20 41 19 80       	push   $0x80194120
80103171:	e8 be 14 00 00       	call   80104634 <wakeup>
80103176:	83 c4 10             	add    $0x10,%esp
80103179:	83 ec 0c             	sub    $0xc,%esp
8010317c:	68 20 41 19 80       	push   $0x80194120
80103181:	e8 50 18 00 00       	call   801049d6 <release>
80103186:	83 c4 10             	add    $0x10,%esp
80103189:	90                   	nop
8010318a:	c9                   	leave  
8010318b:	c3                   	ret    

8010318c <write_log>:
8010318c:	55                   	push   %ebp
8010318d:	89 e5                	mov    %esp,%ebp
8010318f:	83 ec 18             	sub    $0x18,%esp
80103192:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80103199:	e9 95 00 00 00       	jmp    80103233 <write_log+0xa7>
8010319e:	8b 15 54 41 19 80    	mov    0x80194154,%edx
801031a4:	8b 45 f4             	mov    -0xc(%ebp),%eax
801031a7:	01 d0                	add    %edx,%eax
801031a9:	83 c0 01             	add    $0x1,%eax
801031ac:	89 c2                	mov    %eax,%edx
801031ae:	a1 64 41 19 80       	mov    0x80194164,%eax
801031b3:	83 ec 08             	sub    $0x8,%esp
801031b6:	52                   	push   %edx
801031b7:	50                   	push   %eax
801031b8:	e8 44 d0 ff ff       	call   80100201 <bread>
801031bd:	83 c4 10             	add    $0x10,%esp
801031c0:	89 45 f0             	mov    %eax,-0x10(%ebp)
801031c3:	8b 45 f4             	mov    -0xc(%ebp),%eax
801031c6:	83 c0 10             	add    $0x10,%eax
801031c9:	8b 04 85 2c 41 19 80 	mov    -0x7fe6bed4(,%eax,4),%eax
801031d0:	89 c2                	mov    %eax,%edx
801031d2:	a1 64 41 19 80       	mov    0x80194164,%eax
801031d7:	83 ec 08             	sub    $0x8,%esp
801031da:	52                   	push   %edx
801031db:	50                   	push   %eax
801031dc:	e8 20 d0 ff ff       	call   80100201 <bread>
801031e1:	83 c4 10             	add    $0x10,%esp
801031e4:	89 45 ec             	mov    %eax,-0x14(%ebp)
801031e7:	8b 45 ec             	mov    -0x14(%ebp),%eax
801031ea:	8d 50 5c             	lea    0x5c(%eax),%edx
801031ed:	8b 45 f0             	mov    -0x10(%ebp),%eax
801031f0:	83 c0 5c             	add    $0x5c,%eax
801031f3:	83 ec 04             	sub    $0x4,%esp
801031f6:	68 00 02 00 00       	push   $0x200
801031fb:	52                   	push   %edx
801031fc:	50                   	push   %eax
801031fd:	e8 9b 1a 00 00       	call   80104c9d <memmove>
80103202:	83 c4 10             	add    $0x10,%esp
80103205:	83 ec 0c             	sub    $0xc,%esp
80103208:	ff 75 f0             	push   -0x10(%ebp)
8010320b:	e8 2a d0 ff ff       	call   8010023a <bwrite>
80103210:	83 c4 10             	add    $0x10,%esp
80103213:	83 ec 0c             	sub    $0xc,%esp
80103216:	ff 75 ec             	push   -0x14(%ebp)
80103219:	e8 65 d0 ff ff       	call   80100283 <brelse>
8010321e:	83 c4 10             	add    $0x10,%esp
80103221:	83 ec 0c             	sub    $0xc,%esp
80103224:	ff 75 f0             	push   -0x10(%ebp)
80103227:	e8 57 d0 ff ff       	call   80100283 <brelse>
8010322c:	83 c4 10             	add    $0x10,%esp
8010322f:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80103233:	a1 68 41 19 80       	mov    0x80194168,%eax
80103238:	39 45 f4             	cmp    %eax,-0xc(%ebp)
8010323b:	0f 8c 5d ff ff ff    	jl     8010319e <write_log+0x12>
80103241:	90                   	nop
80103242:	90                   	nop
80103243:	c9                   	leave  
80103244:	c3                   	ret    

80103245 <commit>:
80103245:	55                   	push   %ebp
80103246:	89 e5                	mov    %esp,%ebp
80103248:	83 ec 08             	sub    $0x8,%esp
8010324b:	a1 68 41 19 80       	mov    0x80194168,%eax
80103250:	85 c0                	test   %eax,%eax
80103252:	7e 1e                	jle    80103272 <commit+0x2d>
80103254:	e8 33 ff ff ff       	call   8010318c <write_log>
80103259:	e8 39 fd ff ff       	call   80102f97 <write_head>
8010325e:	e8 07 fc ff ff       	call   80102e6a <install_trans>
80103263:	c7 05 68 41 19 80 00 	movl   $0x0,0x80194168
8010326a:	00 00 00 
8010326d:	e8 25 fd ff ff       	call   80102f97 <write_head>
80103272:	90                   	nop
80103273:	c9                   	leave  
80103274:	c3                   	ret    

80103275 <log_write>:
80103275:	55                   	push   %ebp
80103276:	89 e5                	mov    %esp,%ebp
80103278:	83 ec 18             	sub    $0x18,%esp
8010327b:	a1 68 41 19 80       	mov    0x80194168,%eax
80103280:	83 f8 1d             	cmp    $0x1d,%eax
80103283:	7f 12                	jg     80103297 <log_write+0x22>
80103285:	a1 68 41 19 80       	mov    0x80194168,%eax
8010328a:	8b 15 58 41 19 80    	mov    0x80194158,%edx
80103290:	83 ea 01             	sub    $0x1,%edx
80103293:	39 d0                	cmp    %edx,%eax
80103295:	7c 0d                	jl     801032a4 <log_write+0x2f>
80103297:	83 ec 0c             	sub    $0xc,%esp
8010329a:	68 84 a4 10 80       	push   $0x8010a484
8010329f:	e8 05 d3 ff ff       	call   801005a9 <panic>
801032a4:	a1 5c 41 19 80       	mov    0x8019415c,%eax
801032a9:	85 c0                	test   %eax,%eax
801032ab:	7f 0d                	jg     801032ba <log_write+0x45>
801032ad:	83 ec 0c             	sub    $0xc,%esp
801032b0:	68 9a a4 10 80       	push   $0x8010a49a
801032b5:	e8 ef d2 ff ff       	call   801005a9 <panic>
801032ba:	83 ec 0c             	sub    $0xc,%esp
801032bd:	68 20 41 19 80       	push   $0x80194120
801032c2:	e8 a1 16 00 00       	call   80104968 <acquire>
801032c7:	83 c4 10             	add    $0x10,%esp
801032ca:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
801032d1:	eb 1d                	jmp    801032f0 <log_write+0x7b>
801032d3:	8b 45 f4             	mov    -0xc(%ebp),%eax
801032d6:	83 c0 10             	add    $0x10,%eax
801032d9:	8b 04 85 2c 41 19 80 	mov    -0x7fe6bed4(,%eax,4),%eax
801032e0:	89 c2                	mov    %eax,%edx
801032e2:	8b 45 08             	mov    0x8(%ebp),%eax
801032e5:	8b 40 08             	mov    0x8(%eax),%eax
801032e8:	39 c2                	cmp    %eax,%edx
801032ea:	74 10                	je     801032fc <log_write+0x87>
801032ec:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
801032f0:	a1 68 41 19 80       	mov    0x80194168,%eax
801032f5:	39 45 f4             	cmp    %eax,-0xc(%ebp)
801032f8:	7c d9                	jl     801032d3 <log_write+0x5e>
801032fa:	eb 01                	jmp    801032fd <log_write+0x88>
801032fc:	90                   	nop
801032fd:	8b 45 08             	mov    0x8(%ebp),%eax
80103300:	8b 40 08             	mov    0x8(%eax),%eax
80103303:	89 c2                	mov    %eax,%edx
80103305:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103308:	83 c0 10             	add    $0x10,%eax
8010330b:	89 14 85 2c 41 19 80 	mov    %edx,-0x7fe6bed4(,%eax,4)
80103312:	a1 68 41 19 80       	mov    0x80194168,%eax
80103317:	39 45 f4             	cmp    %eax,-0xc(%ebp)
8010331a:	75 0d                	jne    80103329 <log_write+0xb4>
8010331c:	a1 68 41 19 80       	mov    0x80194168,%eax
80103321:	83 c0 01             	add    $0x1,%eax
80103324:	a3 68 41 19 80       	mov    %eax,0x80194168
80103329:	8b 45 08             	mov    0x8(%ebp),%eax
8010332c:	8b 00                	mov    (%eax),%eax
8010332e:	83 c8 04             	or     $0x4,%eax
80103331:	89 c2                	mov    %eax,%edx
80103333:	8b 45 08             	mov    0x8(%ebp),%eax
80103336:	89 10                	mov    %edx,(%eax)
80103338:	83 ec 0c             	sub    $0xc,%esp
8010333b:	68 20 41 19 80       	push   $0x80194120
80103340:	e8 91 16 00 00       	call   801049d6 <release>
80103345:	83 c4 10             	add    $0x10,%esp
80103348:	90                   	nop
80103349:	c9                   	leave  
8010334a:	c3                   	ret    

8010334b <xchg>:
8010334b:	55                   	push   %ebp
8010334c:	89 e5                	mov    %esp,%ebp
8010334e:	83 ec 10             	sub    $0x10,%esp
80103351:	8b 55 08             	mov    0x8(%ebp),%edx
80103354:	8b 45 0c             	mov    0xc(%ebp),%eax
80103357:	8b 4d 08             	mov    0x8(%ebp),%ecx
8010335a:	f0 87 02             	lock xchg %eax,(%edx)
8010335d:	89 45 fc             	mov    %eax,-0x4(%ebp)
80103360:	8b 45 fc             	mov    -0x4(%ebp),%eax
80103363:	c9                   	leave  
80103364:	c3                   	ret    

80103365 <main>:
80103365:	8d 4c 24 04          	lea    0x4(%esp),%ecx
80103369:	83 e4 f0             	and    $0xfffffff0,%esp
8010336c:	ff 71 fc             	push   -0x4(%ecx)
8010336f:	55                   	push   %ebp
80103370:	89 e5                	mov    %esp,%ebp
80103372:	51                   	push   %ecx
80103373:	83 ec 04             	sub    $0x4,%esp
80103376:	e8 81 4c 00 00       	call   80107ffc <graphic_init>
8010337b:	83 ec 08             	sub    $0x8,%esp
8010337e:	68 00 00 40 80       	push   $0x80400000
80103383:	68 00 90 19 80       	push   $0x80199000
80103388:	e8 de f2 ff ff       	call   8010266b <kinit1>
8010338d:	83 c4 10             	add    $0x10,%esp
80103390:	e8 81 42 00 00       	call   80107616 <kvmalloc>
80103395:	e8 28 4a 00 00       	call   80107dc2 <mpinit_uefi>
8010339a:	e8 3c f6 ff ff       	call   801029db <lapicinit>
8010339f:	e8 0a 3d 00 00       	call   801070ae <seginit>
801033a4:	e8 9d 01 00 00       	call   80103546 <picinit>
801033a9:	e8 d8 f1 ff ff       	call   80102586 <ioapicinit>
801033ae:	e8 4c d7 ff ff       	call   80100aff <consoleinit>
801033b3:	e8 8f 30 00 00       	call   80106447 <uartinit>
801033b8:	e8 c2 05 00 00       	call   8010397f <pinit>
801033bd:	e8 56 2c 00 00       	call   80106018 <tvinit>
801033c2:	e8 9f cc ff ff       	call   80100066 <binit>
801033c7:	e8 f3 db ff ff       	call   80100fbf <fileinit>
801033cc:	e8 6c 6d 00 00       	call   8010a13d <ideinit>
801033d1:	e8 8a 00 00 00       	call   80103460 <startothers>
801033d6:	83 ec 08             	sub    $0x8,%esp
801033d9:	68 00 00 00 a0       	push   $0xa0000000
801033de:	68 00 00 40 80       	push   $0x80400000
801033e3:	e8 bc f2 ff ff       	call   801026a4 <kinit2>
801033e8:	83 c4 10             	add    $0x10,%esp
801033eb:	e8 65 4e 00 00       	call   80108255 <pci_init>
801033f0:	e8 9c 5b 00 00       	call   80108f91 <arp_scan>
801033f5:	e8 63 07 00 00       	call   80103b5d <userinit>
801033fa:	e8 1a 00 00 00       	call   80103419 <mpmain>

801033ff <mpenter>:
801033ff:	55                   	push   %ebp
80103400:	89 e5                	mov    %esp,%ebp
80103402:	83 ec 08             	sub    $0x8,%esp
80103405:	e8 24 42 00 00       	call   8010762e <switchkvm>
8010340a:	e8 9f 3c 00 00       	call   801070ae <seginit>
8010340f:	e8 c7 f5 ff ff       	call   801029db <lapicinit>
80103414:	e8 00 00 00 00       	call   80103419 <mpmain>

80103419 <mpmain>:
80103419:	55                   	push   %ebp
8010341a:	89 e5                	mov    %esp,%ebp
8010341c:	53                   	push   %ebx
8010341d:	83 ec 04             	sub    $0x4,%esp
80103420:	e8 78 05 00 00       	call   8010399d <cpuid>
80103425:	89 c3                	mov    %eax,%ebx
80103427:	e8 71 05 00 00       	call   8010399d <cpuid>
8010342c:	83 ec 04             	sub    $0x4,%esp
8010342f:	53                   	push   %ebx
80103430:	50                   	push   %eax
80103431:	68 b5 a4 10 80       	push   $0x8010a4b5
80103436:	e8 b9 cf ff ff       	call   801003f4 <cprintf>
8010343b:	83 c4 10             	add    $0x10,%esp
8010343e:	e8 4b 2d 00 00       	call   8010618e <idtinit>
80103443:	e8 70 05 00 00       	call   801039b8 <mycpu>
80103448:	05 a0 00 00 00       	add    $0xa0,%eax
8010344d:	83 ec 08             	sub    $0x8,%esp
80103450:	6a 01                	push   $0x1
80103452:	50                   	push   %eax
80103453:	e8 f3 fe ff ff       	call   8010334b <xchg>
80103458:	83 c4 10             	add    $0x10,%esp
8010345b:	e8 fc 0e 00 00       	call   8010435c <scheduler>

80103460 <startothers>:
80103460:	55                   	push   %ebp
80103461:	89 e5                	mov    %esp,%ebp
80103463:	83 ec 18             	sub    $0x18,%esp
80103466:	c7 45 f0 00 70 00 80 	movl   $0x80007000,-0x10(%ebp)
8010346d:	b8 8a 00 00 00       	mov    $0x8a,%eax
80103472:	83 ec 04             	sub    $0x4,%esp
80103475:	50                   	push   %eax
80103476:	68 18 f5 10 80       	push   $0x8010f518
8010347b:	ff 75 f0             	push   -0x10(%ebp)
8010347e:	e8 1a 18 00 00       	call   80104c9d <memmove>
80103483:	83 c4 10             	add    $0x10,%esp
80103486:	c7 45 f4 80 6a 19 80 	movl   $0x80196a80,-0xc(%ebp)
8010348d:	eb 79                	jmp    80103508 <startothers+0xa8>
8010348f:	e8 24 05 00 00       	call   801039b8 <mycpu>
80103494:	39 45 f4             	cmp    %eax,-0xc(%ebp)
80103497:	74 67                	je     80103500 <startothers+0xa0>
80103499:	e8 02 f3 ff ff       	call   801027a0 <kalloc>
8010349e:	89 45 ec             	mov    %eax,-0x14(%ebp)
801034a1:	8b 45 f0             	mov    -0x10(%ebp),%eax
801034a4:	83 e8 04             	sub    $0x4,%eax
801034a7:	8b 55 ec             	mov    -0x14(%ebp),%edx
801034aa:	81 c2 00 10 00 00    	add    $0x1000,%edx
801034b0:	89 10                	mov    %edx,(%eax)
801034b2:	8b 45 f0             	mov    -0x10(%ebp),%eax
801034b5:	83 e8 08             	sub    $0x8,%eax
801034b8:	c7 00 ff 33 10 80    	movl   $0x801033ff,(%eax)
801034be:	b8 00 e0 10 80       	mov    $0x8010e000,%eax
801034c3:	8d 90 00 00 00 80    	lea    -0x80000000(%eax),%edx
801034c9:	8b 45 f0             	mov    -0x10(%ebp),%eax
801034cc:	83 e8 0c             	sub    $0xc,%eax
801034cf:	89 10                	mov    %edx,(%eax)
801034d1:	8b 45 f0             	mov    -0x10(%ebp),%eax
801034d4:	8d 90 00 00 00 80    	lea    -0x80000000(%eax),%edx
801034da:	8b 45 f4             	mov    -0xc(%ebp),%eax
801034dd:	0f b6 00             	movzbl (%eax),%eax
801034e0:	0f b6 c0             	movzbl %al,%eax
801034e3:	83 ec 08             	sub    $0x8,%esp
801034e6:	52                   	push   %edx
801034e7:	50                   	push   %eax
801034e8:	e8 50 f6 ff ff       	call   80102b3d <lapicstartap>
801034ed:	83 c4 10             	add    $0x10,%esp
801034f0:	90                   	nop
801034f1:	8b 45 f4             	mov    -0xc(%ebp),%eax
801034f4:	8b 80 a0 00 00 00    	mov    0xa0(%eax),%eax
801034fa:	85 c0                	test   %eax,%eax
801034fc:	74 f3                	je     801034f1 <startothers+0x91>
801034fe:	eb 01                	jmp    80103501 <startothers+0xa1>
80103500:	90                   	nop
80103501:	81 45 f4 b0 00 00 00 	addl   $0xb0,-0xc(%ebp)
80103508:	a1 40 6d 19 80       	mov    0x80196d40,%eax
8010350d:	69 c0 b0 00 00 00    	imul   $0xb0,%eax,%eax
80103513:	05 80 6a 19 80       	add    $0x80196a80,%eax
80103518:	39 45 f4             	cmp    %eax,-0xc(%ebp)
8010351b:	0f 82 6e ff ff ff    	jb     8010348f <startothers+0x2f>
80103521:	90                   	nop
80103522:	90                   	nop
80103523:	c9                   	leave  
80103524:	c3                   	ret    

80103525 <outb>:
80103525:	55                   	push   %ebp
80103526:	89 e5                	mov    %esp,%ebp
80103528:	83 ec 08             	sub    $0x8,%esp
8010352b:	8b 45 08             	mov    0x8(%ebp),%eax
8010352e:	8b 55 0c             	mov    0xc(%ebp),%edx
80103531:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
80103535:	89 d0                	mov    %edx,%eax
80103537:	88 45 f8             	mov    %al,-0x8(%ebp)
8010353a:	0f b6 45 f8          	movzbl -0x8(%ebp),%eax
8010353e:	0f b7 55 fc          	movzwl -0x4(%ebp),%edx
80103542:	ee                   	out    %al,(%dx)
80103543:	90                   	nop
80103544:	c9                   	leave  
80103545:	c3                   	ret    

80103546 <picinit>:
80103546:	55                   	push   %ebp
80103547:	89 e5                	mov    %esp,%ebp
80103549:	68 ff 00 00 00       	push   $0xff
8010354e:	6a 21                	push   $0x21
80103550:	e8 d0 ff ff ff       	call   80103525 <outb>
80103555:	83 c4 08             	add    $0x8,%esp
80103558:	68 ff 00 00 00       	push   $0xff
8010355d:	68 a1 00 00 00       	push   $0xa1
80103562:	e8 be ff ff ff       	call   80103525 <outb>
80103567:	83 c4 08             	add    $0x8,%esp
8010356a:	90                   	nop
8010356b:	c9                   	leave  
8010356c:	c3                   	ret    

8010356d <pipealloc>:
8010356d:	55                   	push   %ebp
8010356e:	89 e5                	mov    %esp,%ebp
80103570:	83 ec 18             	sub    $0x18,%esp
80103573:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
8010357a:	8b 45 0c             	mov    0xc(%ebp),%eax
8010357d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
80103583:	8b 45 0c             	mov    0xc(%ebp),%eax
80103586:	8b 10                	mov    (%eax),%edx
80103588:	8b 45 08             	mov    0x8(%ebp),%eax
8010358b:	89 10                	mov    %edx,(%eax)
8010358d:	e8 4b da ff ff       	call   80100fdd <filealloc>
80103592:	8b 55 08             	mov    0x8(%ebp),%edx
80103595:	89 02                	mov    %eax,(%edx)
80103597:	8b 45 08             	mov    0x8(%ebp),%eax
8010359a:	8b 00                	mov    (%eax),%eax
8010359c:	85 c0                	test   %eax,%eax
8010359e:	0f 84 c8 00 00 00    	je     8010366c <pipealloc+0xff>
801035a4:	e8 34 da ff ff       	call   80100fdd <filealloc>
801035a9:	8b 55 0c             	mov    0xc(%ebp),%edx
801035ac:	89 02                	mov    %eax,(%edx)
801035ae:	8b 45 0c             	mov    0xc(%ebp),%eax
801035b1:	8b 00                	mov    (%eax),%eax
801035b3:	85 c0                	test   %eax,%eax
801035b5:	0f 84 b1 00 00 00    	je     8010366c <pipealloc+0xff>
801035bb:	e8 e0 f1 ff ff       	call   801027a0 <kalloc>
801035c0:	89 45 f4             	mov    %eax,-0xc(%ebp)
801035c3:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801035c7:	0f 84 a2 00 00 00    	je     8010366f <pipealloc+0x102>
801035cd:	8b 45 f4             	mov    -0xc(%ebp),%eax
801035d0:	c7 80 3c 02 00 00 01 	movl   $0x1,0x23c(%eax)
801035d7:	00 00 00 
801035da:	8b 45 f4             	mov    -0xc(%ebp),%eax
801035dd:	c7 80 40 02 00 00 01 	movl   $0x1,0x240(%eax)
801035e4:	00 00 00 
801035e7:	8b 45 f4             	mov    -0xc(%ebp),%eax
801035ea:	c7 80 38 02 00 00 00 	movl   $0x0,0x238(%eax)
801035f1:	00 00 00 
801035f4:	8b 45 f4             	mov    -0xc(%ebp),%eax
801035f7:	c7 80 34 02 00 00 00 	movl   $0x0,0x234(%eax)
801035fe:	00 00 00 
80103601:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103604:	83 ec 08             	sub    $0x8,%esp
80103607:	68 c9 a4 10 80       	push   $0x8010a4c9
8010360c:	50                   	push   %eax
8010360d:	e8 34 13 00 00       	call   80104946 <initlock>
80103612:	83 c4 10             	add    $0x10,%esp
80103615:	8b 45 08             	mov    0x8(%ebp),%eax
80103618:	8b 00                	mov    (%eax),%eax
8010361a:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
80103620:	8b 45 08             	mov    0x8(%ebp),%eax
80103623:	8b 00                	mov    (%eax),%eax
80103625:	c6 40 08 01          	movb   $0x1,0x8(%eax)
80103629:	8b 45 08             	mov    0x8(%ebp),%eax
8010362c:	8b 00                	mov    (%eax),%eax
8010362e:	c6 40 09 00          	movb   $0x0,0x9(%eax)
80103632:	8b 45 08             	mov    0x8(%ebp),%eax
80103635:	8b 00                	mov    (%eax),%eax
80103637:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010363a:	89 50 0c             	mov    %edx,0xc(%eax)
8010363d:	8b 45 0c             	mov    0xc(%ebp),%eax
80103640:	8b 00                	mov    (%eax),%eax
80103642:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
80103648:	8b 45 0c             	mov    0xc(%ebp),%eax
8010364b:	8b 00                	mov    (%eax),%eax
8010364d:	c6 40 08 00          	movb   $0x0,0x8(%eax)
80103651:	8b 45 0c             	mov    0xc(%ebp),%eax
80103654:	8b 00                	mov    (%eax),%eax
80103656:	c6 40 09 01          	movb   $0x1,0x9(%eax)
8010365a:	8b 45 0c             	mov    0xc(%ebp),%eax
8010365d:	8b 00                	mov    (%eax),%eax
8010365f:	8b 55 f4             	mov    -0xc(%ebp),%edx
80103662:	89 50 0c             	mov    %edx,0xc(%eax)
80103665:	b8 00 00 00 00       	mov    $0x0,%eax
8010366a:	eb 51                	jmp    801036bd <pipealloc+0x150>
8010366c:	90                   	nop
8010366d:	eb 01                	jmp    80103670 <pipealloc+0x103>
8010366f:	90                   	nop
80103670:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80103674:	74 0e                	je     80103684 <pipealloc+0x117>
80103676:	83 ec 0c             	sub    $0xc,%esp
80103679:	ff 75 f4             	push   -0xc(%ebp)
8010367c:	e8 85 f0 ff ff       	call   80102706 <kfree>
80103681:	83 c4 10             	add    $0x10,%esp
80103684:	8b 45 08             	mov    0x8(%ebp),%eax
80103687:	8b 00                	mov    (%eax),%eax
80103689:	85 c0                	test   %eax,%eax
8010368b:	74 11                	je     8010369e <pipealloc+0x131>
8010368d:	8b 45 08             	mov    0x8(%ebp),%eax
80103690:	8b 00                	mov    (%eax),%eax
80103692:	83 ec 0c             	sub    $0xc,%esp
80103695:	50                   	push   %eax
80103696:	e8 00 da ff ff       	call   8010109b <fileclose>
8010369b:	83 c4 10             	add    $0x10,%esp
8010369e:	8b 45 0c             	mov    0xc(%ebp),%eax
801036a1:	8b 00                	mov    (%eax),%eax
801036a3:	85 c0                	test   %eax,%eax
801036a5:	74 11                	je     801036b8 <pipealloc+0x14b>
801036a7:	8b 45 0c             	mov    0xc(%ebp),%eax
801036aa:	8b 00                	mov    (%eax),%eax
801036ac:	83 ec 0c             	sub    $0xc,%esp
801036af:	50                   	push   %eax
801036b0:	e8 e6 d9 ff ff       	call   8010109b <fileclose>
801036b5:	83 c4 10             	add    $0x10,%esp
801036b8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801036bd:	c9                   	leave  
801036be:	c3                   	ret    

801036bf <pipeclose>:
801036bf:	55                   	push   %ebp
801036c0:	89 e5                	mov    %esp,%ebp
801036c2:	83 ec 08             	sub    $0x8,%esp
801036c5:	8b 45 08             	mov    0x8(%ebp),%eax
801036c8:	83 ec 0c             	sub    $0xc,%esp
801036cb:	50                   	push   %eax
801036cc:	e8 97 12 00 00       	call   80104968 <acquire>
801036d1:	83 c4 10             	add    $0x10,%esp
801036d4:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
801036d8:	74 23                	je     801036fd <pipeclose+0x3e>
801036da:	8b 45 08             	mov    0x8(%ebp),%eax
801036dd:	c7 80 40 02 00 00 00 	movl   $0x0,0x240(%eax)
801036e4:	00 00 00 
801036e7:	8b 45 08             	mov    0x8(%ebp),%eax
801036ea:	05 34 02 00 00       	add    $0x234,%eax
801036ef:	83 ec 0c             	sub    $0xc,%esp
801036f2:	50                   	push   %eax
801036f3:	e8 3c 0f 00 00       	call   80104634 <wakeup>
801036f8:	83 c4 10             	add    $0x10,%esp
801036fb:	eb 21                	jmp    8010371e <pipeclose+0x5f>
801036fd:	8b 45 08             	mov    0x8(%ebp),%eax
80103700:	c7 80 3c 02 00 00 00 	movl   $0x0,0x23c(%eax)
80103707:	00 00 00 
8010370a:	8b 45 08             	mov    0x8(%ebp),%eax
8010370d:	05 38 02 00 00       	add    $0x238,%eax
80103712:	83 ec 0c             	sub    $0xc,%esp
80103715:	50                   	push   %eax
80103716:	e8 19 0f 00 00       	call   80104634 <wakeup>
8010371b:	83 c4 10             	add    $0x10,%esp
8010371e:	8b 45 08             	mov    0x8(%ebp),%eax
80103721:	8b 80 3c 02 00 00    	mov    0x23c(%eax),%eax
80103727:	85 c0                	test   %eax,%eax
80103729:	75 2c                	jne    80103757 <pipeclose+0x98>
8010372b:	8b 45 08             	mov    0x8(%ebp),%eax
8010372e:	8b 80 40 02 00 00    	mov    0x240(%eax),%eax
80103734:	85 c0                	test   %eax,%eax
80103736:	75 1f                	jne    80103757 <pipeclose+0x98>
80103738:	8b 45 08             	mov    0x8(%ebp),%eax
8010373b:	83 ec 0c             	sub    $0xc,%esp
8010373e:	50                   	push   %eax
8010373f:	e8 92 12 00 00       	call   801049d6 <release>
80103744:	83 c4 10             	add    $0x10,%esp
80103747:	83 ec 0c             	sub    $0xc,%esp
8010374a:	ff 75 08             	push   0x8(%ebp)
8010374d:	e8 b4 ef ff ff       	call   80102706 <kfree>
80103752:	83 c4 10             	add    $0x10,%esp
80103755:	eb 10                	jmp    80103767 <pipeclose+0xa8>
80103757:	8b 45 08             	mov    0x8(%ebp),%eax
8010375a:	83 ec 0c             	sub    $0xc,%esp
8010375d:	50                   	push   %eax
8010375e:	e8 73 12 00 00       	call   801049d6 <release>
80103763:	83 c4 10             	add    $0x10,%esp
80103766:	90                   	nop
80103767:	90                   	nop
80103768:	c9                   	leave  
80103769:	c3                   	ret    

8010376a <pipewrite>:
8010376a:	55                   	push   %ebp
8010376b:	89 e5                	mov    %esp,%ebp
8010376d:	53                   	push   %ebx
8010376e:	83 ec 14             	sub    $0x14,%esp
80103771:	8b 45 08             	mov    0x8(%ebp),%eax
80103774:	83 ec 0c             	sub    $0xc,%esp
80103777:	50                   	push   %eax
80103778:	e8 eb 11 00 00       	call   80104968 <acquire>
8010377d:	83 c4 10             	add    $0x10,%esp
80103780:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80103787:	e9 ad 00 00 00       	jmp    80103839 <pipewrite+0xcf>
8010378c:	8b 45 08             	mov    0x8(%ebp),%eax
8010378f:	8b 80 3c 02 00 00    	mov    0x23c(%eax),%eax
80103795:	85 c0                	test   %eax,%eax
80103797:	74 0c                	je     801037a5 <pipewrite+0x3b>
80103799:	e8 92 02 00 00       	call   80103a30 <myproc>
8010379e:	8b 40 24             	mov    0x24(%eax),%eax
801037a1:	85 c0                	test   %eax,%eax
801037a3:	74 19                	je     801037be <pipewrite+0x54>
801037a5:	8b 45 08             	mov    0x8(%ebp),%eax
801037a8:	83 ec 0c             	sub    $0xc,%esp
801037ab:	50                   	push   %eax
801037ac:	e8 25 12 00 00       	call   801049d6 <release>
801037b1:	83 c4 10             	add    $0x10,%esp
801037b4:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801037b9:	e9 a9 00 00 00       	jmp    80103867 <pipewrite+0xfd>
801037be:	8b 45 08             	mov    0x8(%ebp),%eax
801037c1:	05 34 02 00 00       	add    $0x234,%eax
801037c6:	83 ec 0c             	sub    $0xc,%esp
801037c9:	50                   	push   %eax
801037ca:	e8 65 0e 00 00       	call   80104634 <wakeup>
801037cf:	83 c4 10             	add    $0x10,%esp
801037d2:	8b 45 08             	mov    0x8(%ebp),%eax
801037d5:	8b 55 08             	mov    0x8(%ebp),%edx
801037d8:	81 c2 38 02 00 00    	add    $0x238,%edx
801037de:	83 ec 08             	sub    $0x8,%esp
801037e1:	50                   	push   %eax
801037e2:	52                   	push   %edx
801037e3:	e8 65 0d 00 00       	call   8010454d <sleep>
801037e8:	83 c4 10             	add    $0x10,%esp
801037eb:	8b 45 08             	mov    0x8(%ebp),%eax
801037ee:	8b 90 38 02 00 00    	mov    0x238(%eax),%edx
801037f4:	8b 45 08             	mov    0x8(%ebp),%eax
801037f7:	8b 80 34 02 00 00    	mov    0x234(%eax),%eax
801037fd:	05 00 02 00 00       	add    $0x200,%eax
80103802:	39 c2                	cmp    %eax,%edx
80103804:	74 86                	je     8010378c <pipewrite+0x22>
80103806:	8b 55 f4             	mov    -0xc(%ebp),%edx
80103809:	8b 45 0c             	mov    0xc(%ebp),%eax
8010380c:	8d 1c 02             	lea    (%edx,%eax,1),%ebx
8010380f:	8b 45 08             	mov    0x8(%ebp),%eax
80103812:	8b 80 38 02 00 00    	mov    0x238(%eax),%eax
80103818:	8d 48 01             	lea    0x1(%eax),%ecx
8010381b:	8b 55 08             	mov    0x8(%ebp),%edx
8010381e:	89 8a 38 02 00 00    	mov    %ecx,0x238(%edx)
80103824:	25 ff 01 00 00       	and    $0x1ff,%eax
80103829:	89 c1                	mov    %eax,%ecx
8010382b:	0f b6 13             	movzbl (%ebx),%edx
8010382e:	8b 45 08             	mov    0x8(%ebp),%eax
80103831:	88 54 08 34          	mov    %dl,0x34(%eax,%ecx,1)
80103835:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80103839:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010383c:	3b 45 10             	cmp    0x10(%ebp),%eax
8010383f:	7c aa                	jl     801037eb <pipewrite+0x81>
80103841:	8b 45 08             	mov    0x8(%ebp),%eax
80103844:	05 34 02 00 00       	add    $0x234,%eax
80103849:	83 ec 0c             	sub    $0xc,%esp
8010384c:	50                   	push   %eax
8010384d:	e8 e2 0d 00 00       	call   80104634 <wakeup>
80103852:	83 c4 10             	add    $0x10,%esp
80103855:	8b 45 08             	mov    0x8(%ebp),%eax
80103858:	83 ec 0c             	sub    $0xc,%esp
8010385b:	50                   	push   %eax
8010385c:	e8 75 11 00 00       	call   801049d6 <release>
80103861:	83 c4 10             	add    $0x10,%esp
80103864:	8b 45 10             	mov    0x10(%ebp),%eax
80103867:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010386a:	c9                   	leave  
8010386b:	c3                   	ret    

8010386c <piperead>:
8010386c:	55                   	push   %ebp
8010386d:	89 e5                	mov    %esp,%ebp
8010386f:	83 ec 18             	sub    $0x18,%esp
80103872:	8b 45 08             	mov    0x8(%ebp),%eax
80103875:	83 ec 0c             	sub    $0xc,%esp
80103878:	50                   	push   %eax
80103879:	e8 ea 10 00 00       	call   80104968 <acquire>
8010387e:	83 c4 10             	add    $0x10,%esp
80103881:	eb 3e                	jmp    801038c1 <piperead+0x55>
80103883:	e8 a8 01 00 00       	call   80103a30 <myproc>
80103888:	8b 40 24             	mov    0x24(%eax),%eax
8010388b:	85 c0                	test   %eax,%eax
8010388d:	74 19                	je     801038a8 <piperead+0x3c>
8010388f:	8b 45 08             	mov    0x8(%ebp),%eax
80103892:	83 ec 0c             	sub    $0xc,%esp
80103895:	50                   	push   %eax
80103896:	e8 3b 11 00 00       	call   801049d6 <release>
8010389b:	83 c4 10             	add    $0x10,%esp
8010389e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801038a3:	e9 be 00 00 00       	jmp    80103966 <piperead+0xfa>
801038a8:	8b 45 08             	mov    0x8(%ebp),%eax
801038ab:	8b 55 08             	mov    0x8(%ebp),%edx
801038ae:	81 c2 34 02 00 00    	add    $0x234,%edx
801038b4:	83 ec 08             	sub    $0x8,%esp
801038b7:	50                   	push   %eax
801038b8:	52                   	push   %edx
801038b9:	e8 8f 0c 00 00       	call   8010454d <sleep>
801038be:	83 c4 10             	add    $0x10,%esp
801038c1:	8b 45 08             	mov    0x8(%ebp),%eax
801038c4:	8b 90 34 02 00 00    	mov    0x234(%eax),%edx
801038ca:	8b 45 08             	mov    0x8(%ebp),%eax
801038cd:	8b 80 38 02 00 00    	mov    0x238(%eax),%eax
801038d3:	39 c2                	cmp    %eax,%edx
801038d5:	75 0d                	jne    801038e4 <piperead+0x78>
801038d7:	8b 45 08             	mov    0x8(%ebp),%eax
801038da:	8b 80 40 02 00 00    	mov    0x240(%eax),%eax
801038e0:	85 c0                	test   %eax,%eax
801038e2:	75 9f                	jne    80103883 <piperead+0x17>
801038e4:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
801038eb:	eb 48                	jmp    80103935 <piperead+0xc9>
801038ed:	8b 45 08             	mov    0x8(%ebp),%eax
801038f0:	8b 90 34 02 00 00    	mov    0x234(%eax),%edx
801038f6:	8b 45 08             	mov    0x8(%ebp),%eax
801038f9:	8b 80 38 02 00 00    	mov    0x238(%eax),%eax
801038ff:	39 c2                	cmp    %eax,%edx
80103901:	74 3c                	je     8010393f <piperead+0xd3>
80103903:	8b 45 08             	mov    0x8(%ebp),%eax
80103906:	8b 80 34 02 00 00    	mov    0x234(%eax),%eax
8010390c:	8d 48 01             	lea    0x1(%eax),%ecx
8010390f:	8b 55 08             	mov    0x8(%ebp),%edx
80103912:	89 8a 34 02 00 00    	mov    %ecx,0x234(%edx)
80103918:	25 ff 01 00 00       	and    $0x1ff,%eax
8010391d:	89 c1                	mov    %eax,%ecx
8010391f:	8b 55 f4             	mov    -0xc(%ebp),%edx
80103922:	8b 45 0c             	mov    0xc(%ebp),%eax
80103925:	01 c2                	add    %eax,%edx
80103927:	8b 45 08             	mov    0x8(%ebp),%eax
8010392a:	0f b6 44 08 34       	movzbl 0x34(%eax,%ecx,1),%eax
8010392f:	88 02                	mov    %al,(%edx)
80103931:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80103935:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103938:	3b 45 10             	cmp    0x10(%ebp),%eax
8010393b:	7c b0                	jl     801038ed <piperead+0x81>
8010393d:	eb 01                	jmp    80103940 <piperead+0xd4>
8010393f:	90                   	nop
80103940:	8b 45 08             	mov    0x8(%ebp),%eax
80103943:	05 38 02 00 00       	add    $0x238,%eax
80103948:	83 ec 0c             	sub    $0xc,%esp
8010394b:	50                   	push   %eax
8010394c:	e8 e3 0c 00 00       	call   80104634 <wakeup>
80103951:	83 c4 10             	add    $0x10,%esp
80103954:	8b 45 08             	mov    0x8(%ebp),%eax
80103957:	83 ec 0c             	sub    $0xc,%esp
8010395a:	50                   	push   %eax
8010395b:	e8 76 10 00 00       	call   801049d6 <release>
80103960:	83 c4 10             	add    $0x10,%esp
80103963:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103966:	c9                   	leave  
80103967:	c3                   	ret    

80103968 <readeflags>:
80103968:	55                   	push   %ebp
80103969:	89 e5                	mov    %esp,%ebp
8010396b:	83 ec 10             	sub    $0x10,%esp
8010396e:	9c                   	pushf  
8010396f:	58                   	pop    %eax
80103970:	89 45 fc             	mov    %eax,-0x4(%ebp)
80103973:	8b 45 fc             	mov    -0x4(%ebp),%eax
80103976:	c9                   	leave  
80103977:	c3                   	ret    

80103978 <sti>:
80103978:	55                   	push   %ebp
80103979:	89 e5                	mov    %esp,%ebp
8010397b:	fb                   	sti    
8010397c:	90                   	nop
8010397d:	5d                   	pop    %ebp
8010397e:	c3                   	ret    

8010397f <pinit>:
8010397f:	55                   	push   %ebp
80103980:	89 e5                	mov    %esp,%ebp
80103982:	83 ec 08             	sub    $0x8,%esp
80103985:	83 ec 08             	sub    $0x8,%esp
80103988:	68 d0 a4 10 80       	push   $0x8010a4d0
8010398d:	68 00 42 19 80       	push   $0x80194200
80103992:	e8 af 0f 00 00       	call   80104946 <initlock>
80103997:	83 c4 10             	add    $0x10,%esp
8010399a:	90                   	nop
8010399b:	c9                   	leave  
8010399c:	c3                   	ret    

8010399d <cpuid>:
8010399d:	55                   	push   %ebp
8010399e:	89 e5                	mov    %esp,%ebp
801039a0:	83 ec 08             	sub    $0x8,%esp
801039a3:	e8 10 00 00 00       	call   801039b8 <mycpu>
801039a8:	2d 80 6a 19 80       	sub    $0x80196a80,%eax
801039ad:	c1 f8 04             	sar    $0x4,%eax
801039b0:	69 c0 a3 8b 2e ba    	imul   $0xba2e8ba3,%eax,%eax
801039b6:	c9                   	leave  
801039b7:	c3                   	ret    

801039b8 <mycpu>:
801039b8:	55                   	push   %ebp
801039b9:	89 e5                	mov    %esp,%ebp
801039bb:	83 ec 18             	sub    $0x18,%esp
801039be:	e8 a5 ff ff ff       	call   80103968 <readeflags>
801039c3:	25 00 02 00 00       	and    $0x200,%eax
801039c8:	85 c0                	test   %eax,%eax
801039ca:	74 0d                	je     801039d9 <mycpu+0x21>
801039cc:	83 ec 0c             	sub    $0xc,%esp
801039cf:	68 d8 a4 10 80       	push   $0x8010a4d8
801039d4:	e8 d0 cb ff ff       	call   801005a9 <panic>
801039d9:	e8 1c f1 ff ff       	call   80102afa <lapicid>
801039de:	89 45 f0             	mov    %eax,-0x10(%ebp)
801039e1:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
801039e8:	eb 2d                	jmp    80103a17 <mycpu+0x5f>
801039ea:	8b 45 f4             	mov    -0xc(%ebp),%eax
801039ed:	69 c0 b0 00 00 00    	imul   $0xb0,%eax,%eax
801039f3:	05 80 6a 19 80       	add    $0x80196a80,%eax
801039f8:	0f b6 00             	movzbl (%eax),%eax
801039fb:	0f b6 c0             	movzbl %al,%eax
801039fe:	39 45 f0             	cmp    %eax,-0x10(%ebp)
80103a01:	75 10                	jne    80103a13 <mycpu+0x5b>
80103a03:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103a06:	69 c0 b0 00 00 00    	imul   $0xb0,%eax,%eax
80103a0c:	05 80 6a 19 80       	add    $0x80196a80,%eax
80103a11:	eb 1b                	jmp    80103a2e <mycpu+0x76>
80103a13:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80103a17:	a1 40 6d 19 80       	mov    0x80196d40,%eax
80103a1c:	39 45 f4             	cmp    %eax,-0xc(%ebp)
80103a1f:	7c c9                	jl     801039ea <mycpu+0x32>
80103a21:	83 ec 0c             	sub    $0xc,%esp
80103a24:	68 fe a4 10 80       	push   $0x8010a4fe
80103a29:	e8 7b cb ff ff       	call   801005a9 <panic>
80103a2e:	c9                   	leave  
80103a2f:	c3                   	ret    

80103a30 <myproc>:
80103a30:	55                   	push   %ebp
80103a31:	89 e5                	mov    %esp,%ebp
80103a33:	83 ec 18             	sub    $0x18,%esp
80103a36:	e8 98 10 00 00       	call   80104ad3 <pushcli>
80103a3b:	e8 78 ff ff ff       	call   801039b8 <mycpu>
80103a40:	89 45 f4             	mov    %eax,-0xc(%ebp)
80103a43:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103a46:	8b 80 ac 00 00 00    	mov    0xac(%eax),%eax
80103a4c:	89 45 f0             	mov    %eax,-0x10(%ebp)
80103a4f:	e8 cc 10 00 00       	call   80104b20 <popcli>
80103a54:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103a57:	c9                   	leave  
80103a58:	c3                   	ret    

80103a59 <allocproc>:
80103a59:	55                   	push   %ebp
80103a5a:	89 e5                	mov    %esp,%ebp
80103a5c:	83 ec 18             	sub    $0x18,%esp
80103a5f:	83 ec 0c             	sub    $0xc,%esp
80103a62:	68 00 42 19 80       	push   $0x80194200
80103a67:	e8 fc 0e 00 00       	call   80104968 <acquire>
80103a6c:	83 c4 10             	add    $0x10,%esp
80103a6f:	c7 45 f4 34 42 19 80 	movl   $0x80194234,-0xc(%ebp)
80103a76:	eb 0e                	jmp    80103a86 <allocproc+0x2d>
80103a78:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103a7b:	8b 40 0c             	mov    0xc(%eax),%eax
80103a7e:	85 c0                	test   %eax,%eax
80103a80:	74 27                	je     80103aa9 <allocproc+0x50>
80103a82:	83 6d f4 80          	subl   $0xffffff80,-0xc(%ebp)
80103a86:	81 7d f4 34 62 19 80 	cmpl   $0x80196234,-0xc(%ebp)
80103a8d:	72 e9                	jb     80103a78 <allocproc+0x1f>
80103a8f:	83 ec 0c             	sub    $0xc,%esp
80103a92:	68 00 42 19 80       	push   $0x80194200
80103a97:	e8 3a 0f 00 00       	call   801049d6 <release>
80103a9c:	83 c4 10             	add    $0x10,%esp
80103a9f:	b8 00 00 00 00       	mov    $0x0,%eax
80103aa4:	e9 b2 00 00 00       	jmp    80103b5b <allocproc+0x102>
80103aa9:	90                   	nop
80103aaa:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103aad:	c7 40 0c 01 00 00 00 	movl   $0x1,0xc(%eax)
80103ab4:	a1 00 f0 10 80       	mov    0x8010f000,%eax
80103ab9:	8d 50 01             	lea    0x1(%eax),%edx
80103abc:	89 15 00 f0 10 80    	mov    %edx,0x8010f000
80103ac2:	8b 55 f4             	mov    -0xc(%ebp),%edx
80103ac5:	89 42 10             	mov    %eax,0x10(%edx)
80103ac8:	83 ec 0c             	sub    $0xc,%esp
80103acb:	68 00 42 19 80       	push   $0x80194200
80103ad0:	e8 01 0f 00 00       	call   801049d6 <release>
80103ad5:	83 c4 10             	add    $0x10,%esp
80103ad8:	e8 c3 ec ff ff       	call   801027a0 <kalloc>
80103add:	8b 55 f4             	mov    -0xc(%ebp),%edx
80103ae0:	89 42 08             	mov    %eax,0x8(%edx)
80103ae3:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103ae6:	8b 40 08             	mov    0x8(%eax),%eax
80103ae9:	85 c0                	test   %eax,%eax
80103aeb:	75 11                	jne    80103afe <allocproc+0xa5>
80103aed:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103af0:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
80103af7:	b8 00 00 00 00       	mov    $0x0,%eax
80103afc:	eb 5d                	jmp    80103b5b <allocproc+0x102>
80103afe:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103b01:	8b 40 08             	mov    0x8(%eax),%eax
80103b04:	05 00 10 00 00       	add    $0x1000,%eax
80103b09:	89 45 f0             	mov    %eax,-0x10(%ebp)
80103b0c:	83 6d f0 4c          	subl   $0x4c,-0x10(%ebp)
80103b10:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103b13:	8b 55 f0             	mov    -0x10(%ebp),%edx
80103b16:	89 50 18             	mov    %edx,0x18(%eax)
80103b19:	83 6d f0 04          	subl   $0x4,-0x10(%ebp)
80103b1d:	ba d2 5f 10 80       	mov    $0x80105fd2,%edx
80103b22:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103b25:	89 10                	mov    %edx,(%eax)
80103b27:	83 6d f0 14          	subl   $0x14,-0x10(%ebp)
80103b2b:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103b2e:	8b 55 f0             	mov    -0x10(%ebp),%edx
80103b31:	89 50 1c             	mov    %edx,0x1c(%eax)
80103b34:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103b37:	8b 40 1c             	mov    0x1c(%eax),%eax
80103b3a:	83 ec 04             	sub    $0x4,%esp
80103b3d:	6a 14                	push   $0x14
80103b3f:	6a 00                	push   $0x0
80103b41:	50                   	push   %eax
80103b42:	e8 97 10 00 00       	call   80104bde <memset>
80103b47:	83 c4 10             	add    $0x10,%esp
80103b4a:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103b4d:	8b 40 1c             	mov    0x1c(%eax),%eax
80103b50:	ba 07 45 10 80       	mov    $0x80104507,%edx
80103b55:	89 50 10             	mov    %edx,0x10(%eax)
80103b58:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103b5b:	c9                   	leave  
80103b5c:	c3                   	ret    

80103b5d <userinit>:
80103b5d:	55                   	push   %ebp
80103b5e:	89 e5                	mov    %esp,%ebp
80103b60:	83 ec 18             	sub    $0x18,%esp
80103b63:	e8 f1 fe ff ff       	call   80103a59 <allocproc>
80103b68:	89 45 f4             	mov    %eax,-0xc(%ebp)
80103b6b:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103b6e:	a3 34 62 19 80       	mov    %eax,0x80196234
80103b73:	e8 b2 39 00 00       	call   8010752a <setupkvm>
80103b78:	8b 55 f4             	mov    -0xc(%ebp),%edx
80103b7b:	89 42 04             	mov    %eax,0x4(%edx)
80103b7e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103b81:	8b 40 04             	mov    0x4(%eax),%eax
80103b84:	85 c0                	test   %eax,%eax
80103b86:	75 0d                	jne    80103b95 <userinit+0x38>
80103b88:	83 ec 0c             	sub    $0xc,%esp
80103b8b:	68 0e a5 10 80       	push   $0x8010a50e
80103b90:	e8 14 ca ff ff       	call   801005a9 <panic>
80103b95:	ba 2c 00 00 00       	mov    $0x2c,%edx
80103b9a:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103b9d:	8b 40 04             	mov    0x4(%eax),%eax
80103ba0:	83 ec 04             	sub    $0x4,%esp
80103ba3:	52                   	push   %edx
80103ba4:	68 ec f4 10 80       	push   $0x8010f4ec
80103ba9:	50                   	push   %eax
80103baa:	e8 37 3c 00 00       	call   801077e6 <inituvm>
80103baf:	83 c4 10             	add    $0x10,%esp
80103bb2:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103bb5:	c7 00 00 10 00 00    	movl   $0x1000,(%eax)
80103bbb:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103bbe:	8b 40 18             	mov    0x18(%eax),%eax
80103bc1:	83 ec 04             	sub    $0x4,%esp
80103bc4:	6a 4c                	push   $0x4c
80103bc6:	6a 00                	push   $0x0
80103bc8:	50                   	push   %eax
80103bc9:	e8 10 10 00 00       	call   80104bde <memset>
80103bce:	83 c4 10             	add    $0x10,%esp
80103bd1:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103bd4:	8b 40 18             	mov    0x18(%eax),%eax
80103bd7:	66 c7 40 3c 1b 00    	movw   $0x1b,0x3c(%eax)
80103bdd:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103be0:	8b 40 18             	mov    0x18(%eax),%eax
80103be3:	66 c7 40 2c 23 00    	movw   $0x23,0x2c(%eax)
80103be9:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103bec:	8b 50 18             	mov    0x18(%eax),%edx
80103bef:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103bf2:	8b 40 18             	mov    0x18(%eax),%eax
80103bf5:	0f b7 52 2c          	movzwl 0x2c(%edx),%edx
80103bf9:	66 89 50 28          	mov    %dx,0x28(%eax)
80103bfd:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103c00:	8b 50 18             	mov    0x18(%eax),%edx
80103c03:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103c06:	8b 40 18             	mov    0x18(%eax),%eax
80103c09:	0f b7 52 2c          	movzwl 0x2c(%edx),%edx
80103c0d:	66 89 50 48          	mov    %dx,0x48(%eax)
80103c11:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103c14:	8b 40 18             	mov    0x18(%eax),%eax
80103c17:	c7 40 40 00 02 00 00 	movl   $0x200,0x40(%eax)
80103c1e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103c21:	8b 40 18             	mov    0x18(%eax),%eax
80103c24:	c7 40 44 00 10 00 00 	movl   $0x1000,0x44(%eax)
80103c2b:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103c2e:	8b 40 18             	mov    0x18(%eax),%eax
80103c31:	c7 40 38 00 00 00 00 	movl   $0x0,0x38(%eax)
80103c38:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103c3b:	83 c0 6c             	add    $0x6c,%eax
80103c3e:	83 ec 04             	sub    $0x4,%esp
80103c41:	6a 10                	push   $0x10
80103c43:	68 27 a5 10 80       	push   $0x8010a527
80103c48:	50                   	push   %eax
80103c49:	e8 93 11 00 00       	call   80104de1 <safestrcpy>
80103c4e:	83 c4 10             	add    $0x10,%esp
80103c51:	83 ec 0c             	sub    $0xc,%esp
80103c54:	68 30 a5 10 80       	push   $0x8010a530
80103c59:	e8 bf e8 ff ff       	call   8010251d <namei>
80103c5e:	83 c4 10             	add    $0x10,%esp
80103c61:	8b 55 f4             	mov    -0xc(%ebp),%edx
80103c64:	89 42 68             	mov    %eax,0x68(%edx)
80103c67:	83 ec 0c             	sub    $0xc,%esp
80103c6a:	68 00 42 19 80       	push   $0x80194200
80103c6f:	e8 f4 0c 00 00       	call   80104968 <acquire>
80103c74:	83 c4 10             	add    $0x10,%esp
80103c77:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103c7a:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
80103c81:	83 ec 0c             	sub    $0xc,%esp
80103c84:	68 00 42 19 80       	push   $0x80194200
80103c89:	e8 48 0d 00 00       	call   801049d6 <release>
80103c8e:	83 c4 10             	add    $0x10,%esp
80103c91:	90                   	nop
80103c92:	c9                   	leave  
80103c93:	c3                   	ret    

80103c94 <growproc>:
80103c94:	55                   	push   %ebp
80103c95:	89 e5                	mov    %esp,%ebp
80103c97:	83 ec 18             	sub    $0x18,%esp
80103c9a:	e8 91 fd ff ff       	call   80103a30 <myproc>
80103c9f:	89 45 f0             	mov    %eax,-0x10(%ebp)
80103ca2:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103ca5:	8b 00                	mov    (%eax),%eax
80103ca7:	89 45 f4             	mov    %eax,-0xc(%ebp)
80103caa:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
80103cae:	7e 2e                	jle    80103cde <growproc+0x4a>
80103cb0:	8b 55 08             	mov    0x8(%ebp),%edx
80103cb3:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103cb6:	01 c2                	add    %eax,%edx
80103cb8:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103cbb:	8b 40 04             	mov    0x4(%eax),%eax
80103cbe:	83 ec 04             	sub    $0x4,%esp
80103cc1:	52                   	push   %edx
80103cc2:	ff 75 f4             	push   -0xc(%ebp)
80103cc5:	50                   	push   %eax
80103cc6:	e8 58 3c 00 00       	call   80107923 <allocuvm>
80103ccb:	83 c4 10             	add    $0x10,%esp
80103cce:	89 45 f4             	mov    %eax,-0xc(%ebp)
80103cd1:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80103cd5:	75 3b                	jne    80103d12 <growproc+0x7e>
80103cd7:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80103cdc:	eb 4f                	jmp    80103d2d <growproc+0x99>
80103cde:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
80103ce2:	79 2e                	jns    80103d12 <growproc+0x7e>
80103ce4:	8b 55 08             	mov    0x8(%ebp),%edx
80103ce7:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103cea:	01 c2                	add    %eax,%edx
80103cec:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103cef:	8b 40 04             	mov    0x4(%eax),%eax
80103cf2:	83 ec 04             	sub    $0x4,%esp
80103cf5:	52                   	push   %edx
80103cf6:	ff 75 f4             	push   -0xc(%ebp)
80103cf9:	50                   	push   %eax
80103cfa:	e8 29 3d 00 00       	call   80107a28 <deallocuvm>
80103cff:	83 c4 10             	add    $0x10,%esp
80103d02:	89 45 f4             	mov    %eax,-0xc(%ebp)
80103d05:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80103d09:	75 07                	jne    80103d12 <growproc+0x7e>
80103d0b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80103d10:	eb 1b                	jmp    80103d2d <growproc+0x99>
80103d12:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103d15:	8b 55 f4             	mov    -0xc(%ebp),%edx
80103d18:	89 10                	mov    %edx,(%eax)
80103d1a:	83 ec 0c             	sub    $0xc,%esp
80103d1d:	ff 75 f0             	push   -0x10(%ebp)
80103d20:	e8 22 39 00 00       	call   80107647 <switchuvm>
80103d25:	83 c4 10             	add    $0x10,%esp
80103d28:	b8 00 00 00 00       	mov    $0x0,%eax
80103d2d:	c9                   	leave  
80103d2e:	c3                   	ret    

80103d2f <fork>:
80103d2f:	55                   	push   %ebp
80103d30:	89 e5                	mov    %esp,%ebp
80103d32:	57                   	push   %edi
80103d33:	56                   	push   %esi
80103d34:	53                   	push   %ebx
80103d35:	83 ec 1c             	sub    $0x1c,%esp
80103d38:	e8 f3 fc ff ff       	call   80103a30 <myproc>
80103d3d:	89 45 e0             	mov    %eax,-0x20(%ebp)
80103d40:	e8 14 fd ff ff       	call   80103a59 <allocproc>
80103d45:	89 45 dc             	mov    %eax,-0x24(%ebp)
80103d48:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
80103d4c:	75 0a                	jne    80103d58 <fork+0x29>
80103d4e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80103d53:	e9 48 01 00 00       	jmp    80103ea0 <fork+0x171>
80103d58:	8b 45 e0             	mov    -0x20(%ebp),%eax
80103d5b:	8b 10                	mov    (%eax),%edx
80103d5d:	8b 45 e0             	mov    -0x20(%ebp),%eax
80103d60:	8b 40 04             	mov    0x4(%eax),%eax
80103d63:	83 ec 08             	sub    $0x8,%esp
80103d66:	52                   	push   %edx
80103d67:	50                   	push   %eax
80103d68:	e8 59 3e 00 00       	call   80107bc6 <copyuvm>
80103d6d:	83 c4 10             	add    $0x10,%esp
80103d70:	8b 55 dc             	mov    -0x24(%ebp),%edx
80103d73:	89 42 04             	mov    %eax,0x4(%edx)
80103d76:	8b 45 dc             	mov    -0x24(%ebp),%eax
80103d79:	8b 40 04             	mov    0x4(%eax),%eax
80103d7c:	85 c0                	test   %eax,%eax
80103d7e:	75 30                	jne    80103db0 <fork+0x81>
80103d80:	8b 45 dc             	mov    -0x24(%ebp),%eax
80103d83:	8b 40 08             	mov    0x8(%eax),%eax
80103d86:	83 ec 0c             	sub    $0xc,%esp
80103d89:	50                   	push   %eax
80103d8a:	e8 77 e9 ff ff       	call   80102706 <kfree>
80103d8f:	83 c4 10             	add    $0x10,%esp
80103d92:	8b 45 dc             	mov    -0x24(%ebp),%eax
80103d95:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
80103d9c:	8b 45 dc             	mov    -0x24(%ebp),%eax
80103d9f:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
80103da6:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80103dab:	e9 f0 00 00 00       	jmp    80103ea0 <fork+0x171>
80103db0:	8b 45 e0             	mov    -0x20(%ebp),%eax
80103db3:	8b 10                	mov    (%eax),%edx
80103db5:	8b 45 dc             	mov    -0x24(%ebp),%eax
80103db8:	89 10                	mov    %edx,(%eax)
80103dba:	8b 45 dc             	mov    -0x24(%ebp),%eax
80103dbd:	8b 55 e0             	mov    -0x20(%ebp),%edx
80103dc0:	89 50 14             	mov    %edx,0x14(%eax)
80103dc3:	8b 45 e0             	mov    -0x20(%ebp),%eax
80103dc6:	8b 48 18             	mov    0x18(%eax),%ecx
80103dc9:	8b 45 dc             	mov    -0x24(%ebp),%eax
80103dcc:	8b 40 18             	mov    0x18(%eax),%eax
80103dcf:	89 c2                	mov    %eax,%edx
80103dd1:	89 cb                	mov    %ecx,%ebx
80103dd3:	b8 13 00 00 00       	mov    $0x13,%eax
80103dd8:	89 d7                	mov    %edx,%edi
80103dda:	89 de                	mov    %ebx,%esi
80103ddc:	89 c1                	mov    %eax,%ecx
80103dde:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
80103de0:	8b 45 dc             	mov    -0x24(%ebp),%eax
80103de3:	8b 40 18             	mov    0x18(%eax),%eax
80103de6:	c7 40 1c 00 00 00 00 	movl   $0x0,0x1c(%eax)
80103ded:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
80103df4:	eb 3b                	jmp    80103e31 <fork+0x102>
80103df6:	8b 45 e0             	mov    -0x20(%ebp),%eax
80103df9:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80103dfc:	83 c2 08             	add    $0x8,%edx
80103dff:	8b 44 90 08          	mov    0x8(%eax,%edx,4),%eax
80103e03:	85 c0                	test   %eax,%eax
80103e05:	74 26                	je     80103e2d <fork+0xfe>
80103e07:	8b 45 e0             	mov    -0x20(%ebp),%eax
80103e0a:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80103e0d:	83 c2 08             	add    $0x8,%edx
80103e10:	8b 44 90 08          	mov    0x8(%eax,%edx,4),%eax
80103e14:	83 ec 0c             	sub    $0xc,%esp
80103e17:	50                   	push   %eax
80103e18:	e8 2d d2 ff ff       	call   8010104a <filedup>
80103e1d:	83 c4 10             	add    $0x10,%esp
80103e20:	8b 55 dc             	mov    -0x24(%ebp),%edx
80103e23:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80103e26:	83 c1 08             	add    $0x8,%ecx
80103e29:	89 44 8a 08          	mov    %eax,0x8(%edx,%ecx,4)
80103e2d:	83 45 e4 01          	addl   $0x1,-0x1c(%ebp)
80103e31:	83 7d e4 0f          	cmpl   $0xf,-0x1c(%ebp)
80103e35:	7e bf                	jle    80103df6 <fork+0xc7>
80103e37:	8b 45 e0             	mov    -0x20(%ebp),%eax
80103e3a:	8b 40 68             	mov    0x68(%eax),%eax
80103e3d:	83 ec 0c             	sub    $0xc,%esp
80103e40:	50                   	push   %eax
80103e41:	e8 6a db ff ff       	call   801019b0 <idup>
80103e46:	83 c4 10             	add    $0x10,%esp
80103e49:	8b 55 dc             	mov    -0x24(%ebp),%edx
80103e4c:	89 42 68             	mov    %eax,0x68(%edx)
80103e4f:	8b 45 e0             	mov    -0x20(%ebp),%eax
80103e52:	8d 50 6c             	lea    0x6c(%eax),%edx
80103e55:	8b 45 dc             	mov    -0x24(%ebp),%eax
80103e58:	83 c0 6c             	add    $0x6c,%eax
80103e5b:	83 ec 04             	sub    $0x4,%esp
80103e5e:	6a 10                	push   $0x10
80103e60:	52                   	push   %edx
80103e61:	50                   	push   %eax
80103e62:	e8 7a 0f 00 00       	call   80104de1 <safestrcpy>
80103e67:	83 c4 10             	add    $0x10,%esp
80103e6a:	8b 45 dc             	mov    -0x24(%ebp),%eax
80103e6d:	8b 40 10             	mov    0x10(%eax),%eax
80103e70:	89 45 d8             	mov    %eax,-0x28(%ebp)
80103e73:	83 ec 0c             	sub    $0xc,%esp
80103e76:	68 00 42 19 80       	push   $0x80194200
80103e7b:	e8 e8 0a 00 00       	call   80104968 <acquire>
80103e80:	83 c4 10             	add    $0x10,%esp
80103e83:	8b 45 dc             	mov    -0x24(%ebp),%eax
80103e86:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
80103e8d:	83 ec 0c             	sub    $0xc,%esp
80103e90:	68 00 42 19 80       	push   $0x80194200
80103e95:	e8 3c 0b 00 00       	call   801049d6 <release>
80103e9a:	83 c4 10             	add    $0x10,%esp
80103e9d:	8b 45 d8             	mov    -0x28(%ebp),%eax
80103ea0:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103ea3:	5b                   	pop    %ebx
80103ea4:	5e                   	pop    %esi
80103ea5:	5f                   	pop    %edi
80103ea6:	5d                   	pop    %ebp
80103ea7:	c3                   	ret    

80103ea8 <exit>:
80103ea8:	55                   	push   %ebp
80103ea9:	89 e5                	mov    %esp,%ebp
80103eab:	83 ec 18             	sub    $0x18,%esp
80103eae:	e8 7d fb ff ff       	call   80103a30 <myproc>
80103eb3:	89 45 ec             	mov    %eax,-0x14(%ebp)
80103eb6:	a1 34 62 19 80       	mov    0x80196234,%eax
80103ebb:	39 45 ec             	cmp    %eax,-0x14(%ebp)
80103ebe:	75 0d                	jne    80103ecd <exit+0x25>
80103ec0:	83 ec 0c             	sub    $0xc,%esp
80103ec3:	68 32 a5 10 80       	push   $0x8010a532
80103ec8:	e8 dc c6 ff ff       	call   801005a9 <panic>
80103ecd:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
80103ed4:	eb 3f                	jmp    80103f15 <exit+0x6d>
80103ed6:	8b 45 ec             	mov    -0x14(%ebp),%eax
80103ed9:	8b 55 f0             	mov    -0x10(%ebp),%edx
80103edc:	83 c2 08             	add    $0x8,%edx
80103edf:	8b 44 90 08          	mov    0x8(%eax,%edx,4),%eax
80103ee3:	85 c0                	test   %eax,%eax
80103ee5:	74 2a                	je     80103f11 <exit+0x69>
80103ee7:	8b 45 ec             	mov    -0x14(%ebp),%eax
80103eea:	8b 55 f0             	mov    -0x10(%ebp),%edx
80103eed:	83 c2 08             	add    $0x8,%edx
80103ef0:	8b 44 90 08          	mov    0x8(%eax,%edx,4),%eax
80103ef4:	83 ec 0c             	sub    $0xc,%esp
80103ef7:	50                   	push   %eax
80103ef8:	e8 9e d1 ff ff       	call   8010109b <fileclose>
80103efd:	83 c4 10             	add    $0x10,%esp
80103f00:	8b 45 ec             	mov    -0x14(%ebp),%eax
80103f03:	8b 55 f0             	mov    -0x10(%ebp),%edx
80103f06:	83 c2 08             	add    $0x8,%edx
80103f09:	c7 44 90 08 00 00 00 	movl   $0x0,0x8(%eax,%edx,4)
80103f10:	00 
80103f11:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
80103f15:	83 7d f0 0f          	cmpl   $0xf,-0x10(%ebp)
80103f19:	7e bb                	jle    80103ed6 <exit+0x2e>
80103f1b:	e8 1c f1 ff ff       	call   8010303c <begin_op>
80103f20:	8b 45 ec             	mov    -0x14(%ebp),%eax
80103f23:	8b 40 68             	mov    0x68(%eax),%eax
80103f26:	83 ec 0c             	sub    $0xc,%esp
80103f29:	50                   	push   %eax
80103f2a:	e8 1c dc ff ff       	call   80101b4b <iput>
80103f2f:	83 c4 10             	add    $0x10,%esp
80103f32:	e8 91 f1 ff ff       	call   801030c8 <end_op>
80103f37:	8b 45 ec             	mov    -0x14(%ebp),%eax
80103f3a:	c7 40 68 00 00 00 00 	movl   $0x0,0x68(%eax)
80103f41:	83 ec 0c             	sub    $0xc,%esp
80103f44:	68 00 42 19 80       	push   $0x80194200
80103f49:	e8 1a 0a 00 00       	call   80104968 <acquire>
80103f4e:	83 c4 10             	add    $0x10,%esp
80103f51:	8b 45 ec             	mov    -0x14(%ebp),%eax
80103f54:	8b 40 14             	mov    0x14(%eax),%eax
80103f57:	83 ec 0c             	sub    $0xc,%esp
80103f5a:	50                   	push   %eax
80103f5b:	e8 94 06 00 00       	call   801045f4 <wakeup1>
80103f60:	83 c4 10             	add    $0x10,%esp
80103f63:	c7 45 f4 34 42 19 80 	movl   $0x80194234,-0xc(%ebp)
80103f6a:	eb 37                	jmp    80103fa3 <exit+0xfb>
80103f6c:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103f6f:	8b 40 14             	mov    0x14(%eax),%eax
80103f72:	39 45 ec             	cmp    %eax,-0x14(%ebp)
80103f75:	75 28                	jne    80103f9f <exit+0xf7>
80103f77:	8b 15 34 62 19 80    	mov    0x80196234,%edx
80103f7d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103f80:	89 50 14             	mov    %edx,0x14(%eax)
80103f83:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103f86:	8b 40 0c             	mov    0xc(%eax),%eax
80103f89:	83 f8 05             	cmp    $0x5,%eax
80103f8c:	75 11                	jne    80103f9f <exit+0xf7>
80103f8e:	a1 34 62 19 80       	mov    0x80196234,%eax
80103f93:	83 ec 0c             	sub    $0xc,%esp
80103f96:	50                   	push   %eax
80103f97:	e8 58 06 00 00       	call   801045f4 <wakeup1>
80103f9c:	83 c4 10             	add    $0x10,%esp
80103f9f:	83 6d f4 80          	subl   $0xffffff80,-0xc(%ebp)
80103fa3:	81 7d f4 34 62 19 80 	cmpl   $0x80196234,-0xc(%ebp)
80103faa:	72 c0                	jb     80103f6c <exit+0xc4>
80103fac:	8b 45 ec             	mov    -0x14(%ebp),%eax
80103faf:	c7 40 0c 05 00 00 00 	movl   $0x5,0xc(%eax)
80103fb6:	e8 59 04 00 00       	call   80104414 <sched>
80103fbb:	83 ec 0c             	sub    $0xc,%esp
80103fbe:	68 3f a5 10 80       	push   $0x8010a53f
80103fc3:	e8 e1 c5 ff ff       	call   801005a9 <panic>

80103fc8 <exit2>:
80103fc8:	55                   	push   %ebp
80103fc9:	89 e5                	mov    %esp,%ebp
80103fcb:	83 ec 18             	sub    $0x18,%esp
80103fce:	e8 5d fa ff ff       	call   80103a30 <myproc>
80103fd3:	89 45 ec             	mov    %eax,-0x14(%ebp)
80103fd6:	8b 45 ec             	mov    -0x14(%ebp),%eax
80103fd9:	8b 40 14             	mov    0x14(%eax),%eax
80103fdc:	8b 55 08             	mov    0x8(%ebp),%edx
80103fdf:	89 50 7c             	mov    %edx,0x7c(%eax)
80103fe2:	a1 34 62 19 80       	mov    0x80196234,%eax
80103fe7:	39 45 ec             	cmp    %eax,-0x14(%ebp)
80103fea:	75 0d                	jne    80103ff9 <exit2+0x31>
80103fec:	83 ec 0c             	sub    $0xc,%esp
80103fef:	68 32 a5 10 80       	push   $0x8010a532
80103ff4:	e8 b0 c5 ff ff       	call   801005a9 <panic>
80103ff9:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
80104000:	eb 3f                	jmp    80104041 <exit2+0x79>
80104002:	8b 45 ec             	mov    -0x14(%ebp),%eax
80104005:	8b 55 f0             	mov    -0x10(%ebp),%edx
80104008:	83 c2 08             	add    $0x8,%edx
8010400b:	8b 44 90 08          	mov    0x8(%eax,%edx,4),%eax
8010400f:	85 c0                	test   %eax,%eax
80104011:	74 2a                	je     8010403d <exit2+0x75>
80104013:	8b 45 ec             	mov    -0x14(%ebp),%eax
80104016:	8b 55 f0             	mov    -0x10(%ebp),%edx
80104019:	83 c2 08             	add    $0x8,%edx
8010401c:	8b 44 90 08          	mov    0x8(%eax,%edx,4),%eax
80104020:	83 ec 0c             	sub    $0xc,%esp
80104023:	50                   	push   %eax
80104024:	e8 72 d0 ff ff       	call   8010109b <fileclose>
80104029:	83 c4 10             	add    $0x10,%esp
8010402c:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010402f:	8b 55 f0             	mov    -0x10(%ebp),%edx
80104032:	83 c2 08             	add    $0x8,%edx
80104035:	c7 44 90 08 00 00 00 	movl   $0x0,0x8(%eax,%edx,4)
8010403c:	00 
8010403d:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
80104041:	83 7d f0 0f          	cmpl   $0xf,-0x10(%ebp)
80104045:	7e bb                	jle    80104002 <exit2+0x3a>
80104047:	e8 f0 ef ff ff       	call   8010303c <begin_op>
8010404c:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010404f:	8b 40 68             	mov    0x68(%eax),%eax
80104052:	83 ec 0c             	sub    $0xc,%esp
80104055:	50                   	push   %eax
80104056:	e8 f0 da ff ff       	call   80101b4b <iput>
8010405b:	83 c4 10             	add    $0x10,%esp
8010405e:	e8 65 f0 ff ff       	call   801030c8 <end_op>
80104063:	8b 45 ec             	mov    -0x14(%ebp),%eax
80104066:	c7 40 68 00 00 00 00 	movl   $0x0,0x68(%eax)
8010406d:	83 ec 0c             	sub    $0xc,%esp
80104070:	68 00 42 19 80       	push   $0x80194200
80104075:	e8 ee 08 00 00       	call   80104968 <acquire>
8010407a:	83 c4 10             	add    $0x10,%esp
8010407d:	8b 45 ec             	mov    -0x14(%ebp),%eax
80104080:	8b 40 14             	mov    0x14(%eax),%eax
80104083:	83 ec 0c             	sub    $0xc,%esp
80104086:	50                   	push   %eax
80104087:	e8 68 05 00 00       	call   801045f4 <wakeup1>
8010408c:	83 c4 10             	add    $0x10,%esp
8010408f:	c7 45 f4 34 42 19 80 	movl   $0x80194234,-0xc(%ebp)
80104096:	eb 37                	jmp    801040cf <exit2+0x107>
80104098:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010409b:	8b 40 14             	mov    0x14(%eax),%eax
8010409e:	39 45 ec             	cmp    %eax,-0x14(%ebp)
801040a1:	75 28                	jne    801040cb <exit2+0x103>
801040a3:	8b 15 34 62 19 80    	mov    0x80196234,%edx
801040a9:	8b 45 f4             	mov    -0xc(%ebp),%eax
801040ac:	89 50 14             	mov    %edx,0x14(%eax)
801040af:	8b 45 f4             	mov    -0xc(%ebp),%eax
801040b2:	8b 40 0c             	mov    0xc(%eax),%eax
801040b5:	83 f8 05             	cmp    $0x5,%eax
801040b8:	75 11                	jne    801040cb <exit2+0x103>
801040ba:	a1 34 62 19 80       	mov    0x80196234,%eax
801040bf:	83 ec 0c             	sub    $0xc,%esp
801040c2:	50                   	push   %eax
801040c3:	e8 2c 05 00 00       	call   801045f4 <wakeup1>
801040c8:	83 c4 10             	add    $0x10,%esp
801040cb:	83 6d f4 80          	subl   $0xffffff80,-0xc(%ebp)
801040cf:	81 7d f4 34 62 19 80 	cmpl   $0x80196234,-0xc(%ebp)
801040d6:	72 c0                	jb     80104098 <exit2+0xd0>
801040d8:	8b 45 ec             	mov    -0x14(%ebp),%eax
801040db:	c7 40 0c 05 00 00 00 	movl   $0x5,0xc(%eax)
801040e2:	e8 2d 03 00 00       	call   80104414 <sched>
801040e7:	83 ec 0c             	sub    $0xc,%esp
801040ea:	68 3f a5 10 80       	push   $0x8010a53f
801040ef:	e8 b5 c4 ff ff       	call   801005a9 <panic>

801040f4 <wait>:
801040f4:	55                   	push   %ebp
801040f5:	89 e5                	mov    %esp,%ebp
801040f7:	83 ec 18             	sub    $0x18,%esp
801040fa:	e8 31 f9 ff ff       	call   80103a30 <myproc>
801040ff:	89 45 ec             	mov    %eax,-0x14(%ebp)
80104102:	83 ec 0c             	sub    $0xc,%esp
80104105:	68 00 42 19 80       	push   $0x80194200
8010410a:	e8 59 08 00 00       	call   80104968 <acquire>
8010410f:	83 c4 10             	add    $0x10,%esp
80104112:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
80104119:	c7 45 f4 34 42 19 80 	movl   $0x80194234,-0xc(%ebp)
80104120:	e9 a1 00 00 00       	jmp    801041c6 <wait+0xd2>
80104125:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104128:	8b 40 14             	mov    0x14(%eax),%eax
8010412b:	39 45 ec             	cmp    %eax,-0x14(%ebp)
8010412e:	0f 85 8d 00 00 00    	jne    801041c1 <wait+0xcd>
80104134:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
8010413b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010413e:	8b 40 0c             	mov    0xc(%eax),%eax
80104141:	83 f8 05             	cmp    $0x5,%eax
80104144:	75 7c                	jne    801041c2 <wait+0xce>
80104146:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104149:	8b 40 10             	mov    0x10(%eax),%eax
8010414c:	89 45 e8             	mov    %eax,-0x18(%ebp)
8010414f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104152:	8b 40 08             	mov    0x8(%eax),%eax
80104155:	83 ec 0c             	sub    $0xc,%esp
80104158:	50                   	push   %eax
80104159:	e8 a8 e5 ff ff       	call   80102706 <kfree>
8010415e:	83 c4 10             	add    $0x10,%esp
80104161:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104164:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
8010416b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010416e:	8b 40 04             	mov    0x4(%eax),%eax
80104171:	83 ec 0c             	sub    $0xc,%esp
80104174:	50                   	push   %eax
80104175:	e8 72 39 00 00       	call   80107aec <freevm>
8010417a:	83 c4 10             	add    $0x10,%esp
8010417d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104180:	c7 40 10 00 00 00 00 	movl   $0x0,0x10(%eax)
80104187:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010418a:	c7 40 14 00 00 00 00 	movl   $0x0,0x14(%eax)
80104191:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104194:	c6 40 6c 00          	movb   $0x0,0x6c(%eax)
80104198:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010419b:	c7 40 24 00 00 00 00 	movl   $0x0,0x24(%eax)
801041a2:	8b 45 f4             	mov    -0xc(%ebp),%eax
801041a5:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
801041ac:	83 ec 0c             	sub    $0xc,%esp
801041af:	68 00 42 19 80       	push   $0x80194200
801041b4:	e8 1d 08 00 00       	call   801049d6 <release>
801041b9:	83 c4 10             	add    $0x10,%esp
801041bc:	8b 45 e8             	mov    -0x18(%ebp),%eax
801041bf:	eb 51                	jmp    80104212 <wait+0x11e>
801041c1:	90                   	nop
801041c2:	83 6d f4 80          	subl   $0xffffff80,-0xc(%ebp)
801041c6:	81 7d f4 34 62 19 80 	cmpl   $0x80196234,-0xc(%ebp)
801041cd:	0f 82 52 ff ff ff    	jb     80104125 <wait+0x31>
801041d3:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
801041d7:	74 0a                	je     801041e3 <wait+0xef>
801041d9:	8b 45 ec             	mov    -0x14(%ebp),%eax
801041dc:	8b 40 24             	mov    0x24(%eax),%eax
801041df:	85 c0                	test   %eax,%eax
801041e1:	74 17                	je     801041fa <wait+0x106>
801041e3:	83 ec 0c             	sub    $0xc,%esp
801041e6:	68 00 42 19 80       	push   $0x80194200
801041eb:	e8 e6 07 00 00       	call   801049d6 <release>
801041f0:	83 c4 10             	add    $0x10,%esp
801041f3:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801041f8:	eb 18                	jmp    80104212 <wait+0x11e>
801041fa:	83 ec 08             	sub    $0x8,%esp
801041fd:	68 00 42 19 80       	push   $0x80194200
80104202:	ff 75 ec             	push   -0x14(%ebp)
80104205:	e8 43 03 00 00       	call   8010454d <sleep>
8010420a:	83 c4 10             	add    $0x10,%esp
8010420d:	e9 00 ff ff ff       	jmp    80104112 <wait+0x1e>
80104212:	c9                   	leave  
80104213:	c3                   	ret    

80104214 <wait2>:
80104214:	55                   	push   %ebp
80104215:	89 e5                	mov    %esp,%ebp
80104217:	83 ec 18             	sub    $0x18,%esp
8010421a:	e8 11 f8 ff ff       	call   80103a30 <myproc>
8010421f:	89 45 ec             	mov    %eax,-0x14(%ebp)
80104222:	83 ec 0c             	sub    $0xc,%esp
80104225:	68 00 42 19 80       	push   $0x80194200
8010422a:	e8 39 07 00 00       	call   80104968 <acquire>
8010422f:	83 c4 10             	add    $0x10,%esp
80104232:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
80104239:	c7 45 f4 34 42 19 80 	movl   $0x80194234,-0xc(%ebp)
80104240:	e9 a1 00 00 00       	jmp    801042e6 <wait2+0xd2>
80104245:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104248:	8b 40 14             	mov    0x14(%eax),%eax
8010424b:	39 45 ec             	cmp    %eax,-0x14(%ebp)
8010424e:	0f 85 8d 00 00 00    	jne    801042e1 <wait2+0xcd>
80104254:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
8010425b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010425e:	8b 40 0c             	mov    0xc(%eax),%eax
80104261:	83 f8 05             	cmp    $0x5,%eax
80104264:	75 7c                	jne    801042e2 <wait2+0xce>
80104266:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104269:	8b 40 10             	mov    0x10(%eax),%eax
8010426c:	89 45 e8             	mov    %eax,-0x18(%ebp)
8010426f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104272:	8b 40 08             	mov    0x8(%eax),%eax
80104275:	83 ec 0c             	sub    $0xc,%esp
80104278:	50                   	push   %eax
80104279:	e8 88 e4 ff ff       	call   80102706 <kfree>
8010427e:	83 c4 10             	add    $0x10,%esp
80104281:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104284:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
8010428b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010428e:	8b 40 04             	mov    0x4(%eax),%eax
80104291:	83 ec 0c             	sub    $0xc,%esp
80104294:	50                   	push   %eax
80104295:	e8 52 38 00 00       	call   80107aec <freevm>
8010429a:	83 c4 10             	add    $0x10,%esp
8010429d:	8b 45 f4             	mov    -0xc(%ebp),%eax
801042a0:	c7 40 10 00 00 00 00 	movl   $0x0,0x10(%eax)
801042a7:	8b 45 f4             	mov    -0xc(%ebp),%eax
801042aa:	c7 40 14 00 00 00 00 	movl   $0x0,0x14(%eax)
801042b1:	8b 45 f4             	mov    -0xc(%ebp),%eax
801042b4:	c6 40 6c 00          	movb   $0x0,0x6c(%eax)
801042b8:	8b 45 f4             	mov    -0xc(%ebp),%eax
801042bb:	c7 40 24 00 00 00 00 	movl   $0x0,0x24(%eax)
801042c2:	8b 45 f4             	mov    -0xc(%ebp),%eax
801042c5:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
801042cc:	83 ec 0c             	sub    $0xc,%esp
801042cf:	68 00 42 19 80       	push   $0x80194200
801042d4:	e8 fd 06 00 00       	call   801049d6 <release>
801042d9:	83 c4 10             	add    $0x10,%esp
801042dc:	8b 45 e8             	mov    -0x18(%ebp),%eax
801042df:	eb 79                	jmp    8010435a <wait2+0x146>
801042e1:	90                   	nop
801042e2:	83 6d f4 80          	subl   $0xffffff80,-0xc(%ebp)
801042e6:	81 7d f4 34 62 19 80 	cmpl   $0x80196234,-0xc(%ebp)
801042ed:	0f 82 52 ff ff ff    	jb     80104245 <wait2+0x31>
801042f3:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
801042f7:	74 0a                	je     80104303 <wait2+0xef>
801042f9:	8b 45 ec             	mov    -0x14(%ebp),%eax
801042fc:	8b 40 24             	mov    0x24(%eax),%eax
801042ff:	85 c0                	test   %eax,%eax
80104301:	74 17                	je     8010431a <wait2+0x106>
80104303:	83 ec 0c             	sub    $0xc,%esp
80104306:	68 00 42 19 80       	push   $0x80194200
8010430b:	e8 c6 06 00 00       	call   801049d6 <release>
80104310:	83 c4 10             	add    $0x10,%esp
80104313:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104318:	eb 40                	jmp    8010435a <wait2+0x146>
8010431a:	83 ec 08             	sub    $0x8,%esp
8010431d:	68 00 42 19 80       	push   $0x80194200
80104322:	ff 75 ec             	push   -0x14(%ebp)
80104325:	e8 23 02 00 00       	call   8010454d <sleep>
8010432a:	83 c4 10             	add    $0x10,%esp
8010432d:	8b 45 ec             	mov    -0x14(%ebp),%eax
80104330:	8d 50 7c             	lea    0x7c(%eax),%edx
80104333:	8b 45 08             	mov    0x8(%ebp),%eax
80104336:	8b 00                	mov    (%eax),%eax
80104338:	89 c1                	mov    %eax,%ecx
8010433a:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010433d:	8b 40 04             	mov    0x4(%eax),%eax
80104340:	6a 04                	push   $0x4
80104342:	52                   	push   %edx
80104343:	51                   	push   %ecx
80104344:	50                   	push   %eax
80104345:	e8 da 39 00 00       	call   80107d24 <copyout>
8010434a:	83 c4 10             	add    $0x10,%esp
8010434d:	85 c0                	test   %eax,%eax
8010434f:	0f 89 dd fe ff ff    	jns    80104232 <wait2+0x1e>
80104355:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010435a:	c9                   	leave  
8010435b:	c3                   	ret    

8010435c <scheduler>:
8010435c:	55                   	push   %ebp
8010435d:	89 e5                	mov    %esp,%ebp
8010435f:	83 ec 18             	sub    $0x18,%esp
80104362:	e8 51 f6 ff ff       	call   801039b8 <mycpu>
80104367:	89 45 f0             	mov    %eax,-0x10(%ebp)
8010436a:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010436d:	c7 80 ac 00 00 00 00 	movl   $0x0,0xac(%eax)
80104374:	00 00 00 
80104377:	e8 fc f5 ff ff       	call   80103978 <sti>
8010437c:	83 ec 0c             	sub    $0xc,%esp
8010437f:	68 00 42 19 80       	push   $0x80194200
80104384:	e8 df 05 00 00       	call   80104968 <acquire>
80104389:	83 c4 10             	add    $0x10,%esp
8010438c:	c7 45 f4 34 42 19 80 	movl   $0x80194234,-0xc(%ebp)
80104393:	eb 61                	jmp    801043f6 <scheduler+0x9a>
80104395:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104398:	8b 40 0c             	mov    0xc(%eax),%eax
8010439b:	83 f8 03             	cmp    $0x3,%eax
8010439e:	75 51                	jne    801043f1 <scheduler+0x95>
801043a0:	8b 45 f0             	mov    -0x10(%ebp),%eax
801043a3:	8b 55 f4             	mov    -0xc(%ebp),%edx
801043a6:	89 90 ac 00 00 00    	mov    %edx,0xac(%eax)
801043ac:	83 ec 0c             	sub    $0xc,%esp
801043af:	ff 75 f4             	push   -0xc(%ebp)
801043b2:	e8 90 32 00 00       	call   80107647 <switchuvm>
801043b7:	83 c4 10             	add    $0x10,%esp
801043ba:	8b 45 f4             	mov    -0xc(%ebp),%eax
801043bd:	c7 40 0c 04 00 00 00 	movl   $0x4,0xc(%eax)
801043c4:	8b 45 f4             	mov    -0xc(%ebp),%eax
801043c7:	8b 40 1c             	mov    0x1c(%eax),%eax
801043ca:	8b 55 f0             	mov    -0x10(%ebp),%edx
801043cd:	83 c2 04             	add    $0x4,%edx
801043d0:	83 ec 08             	sub    $0x8,%esp
801043d3:	50                   	push   %eax
801043d4:	52                   	push   %edx
801043d5:	e8 79 0a 00 00       	call   80104e53 <swtch>
801043da:	83 c4 10             	add    $0x10,%esp
801043dd:	e8 4c 32 00 00       	call   8010762e <switchkvm>
801043e2:	8b 45 f0             	mov    -0x10(%ebp),%eax
801043e5:	c7 80 ac 00 00 00 00 	movl   $0x0,0xac(%eax)
801043ec:	00 00 00 
801043ef:	eb 01                	jmp    801043f2 <scheduler+0x96>
801043f1:	90                   	nop
801043f2:	83 6d f4 80          	subl   $0xffffff80,-0xc(%ebp)
801043f6:	81 7d f4 34 62 19 80 	cmpl   $0x80196234,-0xc(%ebp)
801043fd:	72 96                	jb     80104395 <scheduler+0x39>
801043ff:	83 ec 0c             	sub    $0xc,%esp
80104402:	68 00 42 19 80       	push   $0x80194200
80104407:	e8 ca 05 00 00       	call   801049d6 <release>
8010440c:	83 c4 10             	add    $0x10,%esp
8010440f:	e9 63 ff ff ff       	jmp    80104377 <scheduler+0x1b>

80104414 <sched>:
80104414:	55                   	push   %ebp
80104415:	89 e5                	mov    %esp,%ebp
80104417:	83 ec 18             	sub    $0x18,%esp
8010441a:	e8 11 f6 ff ff       	call   80103a30 <myproc>
8010441f:	89 45 f4             	mov    %eax,-0xc(%ebp)
80104422:	83 ec 0c             	sub    $0xc,%esp
80104425:	68 00 42 19 80       	push   $0x80194200
8010442a:	e8 74 06 00 00       	call   80104aa3 <holding>
8010442f:	83 c4 10             	add    $0x10,%esp
80104432:	85 c0                	test   %eax,%eax
80104434:	75 0d                	jne    80104443 <sched+0x2f>
80104436:	83 ec 0c             	sub    $0xc,%esp
80104439:	68 4b a5 10 80       	push   $0x8010a54b
8010443e:	e8 66 c1 ff ff       	call   801005a9 <panic>
80104443:	e8 70 f5 ff ff       	call   801039b8 <mycpu>
80104448:	8b 80 a4 00 00 00    	mov    0xa4(%eax),%eax
8010444e:	83 f8 01             	cmp    $0x1,%eax
80104451:	74 0d                	je     80104460 <sched+0x4c>
80104453:	83 ec 0c             	sub    $0xc,%esp
80104456:	68 5d a5 10 80       	push   $0x8010a55d
8010445b:	e8 49 c1 ff ff       	call   801005a9 <panic>
80104460:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104463:	8b 40 0c             	mov    0xc(%eax),%eax
80104466:	83 f8 04             	cmp    $0x4,%eax
80104469:	75 0d                	jne    80104478 <sched+0x64>
8010446b:	83 ec 0c             	sub    $0xc,%esp
8010446e:	68 69 a5 10 80       	push   $0x8010a569
80104473:	e8 31 c1 ff ff       	call   801005a9 <panic>
80104478:	e8 eb f4 ff ff       	call   80103968 <readeflags>
8010447d:	25 00 02 00 00       	and    $0x200,%eax
80104482:	85 c0                	test   %eax,%eax
80104484:	74 0d                	je     80104493 <sched+0x7f>
80104486:	83 ec 0c             	sub    $0xc,%esp
80104489:	68 77 a5 10 80       	push   $0x8010a577
8010448e:	e8 16 c1 ff ff       	call   801005a9 <panic>
80104493:	e8 20 f5 ff ff       	call   801039b8 <mycpu>
80104498:	8b 80 a8 00 00 00    	mov    0xa8(%eax),%eax
8010449e:	89 45 f0             	mov    %eax,-0x10(%ebp)
801044a1:	e8 12 f5 ff ff       	call   801039b8 <mycpu>
801044a6:	8b 40 04             	mov    0x4(%eax),%eax
801044a9:	8b 55 f4             	mov    -0xc(%ebp),%edx
801044ac:	83 c2 1c             	add    $0x1c,%edx
801044af:	83 ec 08             	sub    $0x8,%esp
801044b2:	50                   	push   %eax
801044b3:	52                   	push   %edx
801044b4:	e8 9a 09 00 00       	call   80104e53 <swtch>
801044b9:	83 c4 10             	add    $0x10,%esp
801044bc:	e8 f7 f4 ff ff       	call   801039b8 <mycpu>
801044c1:	8b 55 f0             	mov    -0x10(%ebp),%edx
801044c4:	89 90 a8 00 00 00    	mov    %edx,0xa8(%eax)
801044ca:	90                   	nop
801044cb:	c9                   	leave  
801044cc:	c3                   	ret    

801044cd <yield>:
801044cd:	55                   	push   %ebp
801044ce:	89 e5                	mov    %esp,%ebp
801044d0:	83 ec 08             	sub    $0x8,%esp
801044d3:	83 ec 0c             	sub    $0xc,%esp
801044d6:	68 00 42 19 80       	push   $0x80194200
801044db:	e8 88 04 00 00       	call   80104968 <acquire>
801044e0:	83 c4 10             	add    $0x10,%esp
801044e3:	e8 48 f5 ff ff       	call   80103a30 <myproc>
801044e8:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
801044ef:	e8 20 ff ff ff       	call   80104414 <sched>
801044f4:	83 ec 0c             	sub    $0xc,%esp
801044f7:	68 00 42 19 80       	push   $0x80194200
801044fc:	e8 d5 04 00 00       	call   801049d6 <release>
80104501:	83 c4 10             	add    $0x10,%esp
80104504:	90                   	nop
80104505:	c9                   	leave  
80104506:	c3                   	ret    

80104507 <forkret>:
80104507:	55                   	push   %ebp
80104508:	89 e5                	mov    %esp,%ebp
8010450a:	83 ec 08             	sub    $0x8,%esp
8010450d:	83 ec 0c             	sub    $0xc,%esp
80104510:	68 00 42 19 80       	push   $0x80194200
80104515:	e8 bc 04 00 00       	call   801049d6 <release>
8010451a:	83 c4 10             	add    $0x10,%esp
8010451d:	a1 04 f0 10 80       	mov    0x8010f004,%eax
80104522:	85 c0                	test   %eax,%eax
80104524:	74 24                	je     8010454a <forkret+0x43>
80104526:	c7 05 04 f0 10 80 00 	movl   $0x0,0x8010f004
8010452d:	00 00 00 
80104530:	83 ec 0c             	sub    $0xc,%esp
80104533:	6a 01                	push   $0x1
80104535:	e8 3e d1 ff ff       	call   80101678 <iinit>
8010453a:	83 c4 10             	add    $0x10,%esp
8010453d:	83 ec 0c             	sub    $0xc,%esp
80104540:	6a 01                	push   $0x1
80104542:	e8 d6 e8 ff ff       	call   80102e1d <initlog>
80104547:	83 c4 10             	add    $0x10,%esp
8010454a:	90                   	nop
8010454b:	c9                   	leave  
8010454c:	c3                   	ret    

8010454d <sleep>:
8010454d:	55                   	push   %ebp
8010454e:	89 e5                	mov    %esp,%ebp
80104550:	83 ec 18             	sub    $0x18,%esp
80104553:	e8 d8 f4 ff ff       	call   80103a30 <myproc>
80104558:	89 45 f4             	mov    %eax,-0xc(%ebp)
8010455b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
8010455f:	75 0d                	jne    8010456e <sleep+0x21>
80104561:	83 ec 0c             	sub    $0xc,%esp
80104564:	68 8b a5 10 80       	push   $0x8010a58b
80104569:	e8 3b c0 ff ff       	call   801005a9 <panic>
8010456e:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
80104572:	75 0d                	jne    80104581 <sleep+0x34>
80104574:	83 ec 0c             	sub    $0xc,%esp
80104577:	68 91 a5 10 80       	push   $0x8010a591
8010457c:	e8 28 c0 ff ff       	call   801005a9 <panic>
80104581:	81 7d 0c 00 42 19 80 	cmpl   $0x80194200,0xc(%ebp)
80104588:	74 1e                	je     801045a8 <sleep+0x5b>
8010458a:	83 ec 0c             	sub    $0xc,%esp
8010458d:	68 00 42 19 80       	push   $0x80194200
80104592:	e8 d1 03 00 00       	call   80104968 <acquire>
80104597:	83 c4 10             	add    $0x10,%esp
8010459a:	83 ec 0c             	sub    $0xc,%esp
8010459d:	ff 75 0c             	push   0xc(%ebp)
801045a0:	e8 31 04 00 00       	call   801049d6 <release>
801045a5:	83 c4 10             	add    $0x10,%esp
801045a8:	8b 45 f4             	mov    -0xc(%ebp),%eax
801045ab:	8b 55 08             	mov    0x8(%ebp),%edx
801045ae:	89 50 20             	mov    %edx,0x20(%eax)
801045b1:	8b 45 f4             	mov    -0xc(%ebp),%eax
801045b4:	c7 40 0c 02 00 00 00 	movl   $0x2,0xc(%eax)
801045bb:	e8 54 fe ff ff       	call   80104414 <sched>
801045c0:	8b 45 f4             	mov    -0xc(%ebp),%eax
801045c3:	c7 40 20 00 00 00 00 	movl   $0x0,0x20(%eax)
801045ca:	81 7d 0c 00 42 19 80 	cmpl   $0x80194200,0xc(%ebp)
801045d1:	74 1e                	je     801045f1 <sleep+0xa4>
801045d3:	83 ec 0c             	sub    $0xc,%esp
801045d6:	68 00 42 19 80       	push   $0x80194200
801045db:	e8 f6 03 00 00       	call   801049d6 <release>
801045e0:	83 c4 10             	add    $0x10,%esp
801045e3:	83 ec 0c             	sub    $0xc,%esp
801045e6:	ff 75 0c             	push   0xc(%ebp)
801045e9:	e8 7a 03 00 00       	call   80104968 <acquire>
801045ee:	83 c4 10             	add    $0x10,%esp
801045f1:	90                   	nop
801045f2:	c9                   	leave  
801045f3:	c3                   	ret    

801045f4 <wakeup1>:
801045f4:	55                   	push   %ebp
801045f5:	89 e5                	mov    %esp,%ebp
801045f7:	83 ec 10             	sub    $0x10,%esp
801045fa:	c7 45 fc 34 42 19 80 	movl   $0x80194234,-0x4(%ebp)
80104601:	eb 24                	jmp    80104627 <wakeup1+0x33>
80104603:	8b 45 fc             	mov    -0x4(%ebp),%eax
80104606:	8b 40 0c             	mov    0xc(%eax),%eax
80104609:	83 f8 02             	cmp    $0x2,%eax
8010460c:	75 15                	jne    80104623 <wakeup1+0x2f>
8010460e:	8b 45 fc             	mov    -0x4(%ebp),%eax
80104611:	8b 40 20             	mov    0x20(%eax),%eax
80104614:	39 45 08             	cmp    %eax,0x8(%ebp)
80104617:	75 0a                	jne    80104623 <wakeup1+0x2f>
80104619:	8b 45 fc             	mov    -0x4(%ebp),%eax
8010461c:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
80104623:	83 6d fc 80          	subl   $0xffffff80,-0x4(%ebp)
80104627:	81 7d fc 34 62 19 80 	cmpl   $0x80196234,-0x4(%ebp)
8010462e:	72 d3                	jb     80104603 <wakeup1+0xf>
80104630:	90                   	nop
80104631:	90                   	nop
80104632:	c9                   	leave  
80104633:	c3                   	ret    

80104634 <wakeup>:
80104634:	55                   	push   %ebp
80104635:	89 e5                	mov    %esp,%ebp
80104637:	83 ec 08             	sub    $0x8,%esp
8010463a:	83 ec 0c             	sub    $0xc,%esp
8010463d:	68 00 42 19 80       	push   $0x80194200
80104642:	e8 21 03 00 00       	call   80104968 <acquire>
80104647:	83 c4 10             	add    $0x10,%esp
8010464a:	83 ec 0c             	sub    $0xc,%esp
8010464d:	ff 75 08             	push   0x8(%ebp)
80104650:	e8 9f ff ff ff       	call   801045f4 <wakeup1>
80104655:	83 c4 10             	add    $0x10,%esp
80104658:	83 ec 0c             	sub    $0xc,%esp
8010465b:	68 00 42 19 80       	push   $0x80194200
80104660:	e8 71 03 00 00       	call   801049d6 <release>
80104665:	83 c4 10             	add    $0x10,%esp
80104668:	90                   	nop
80104669:	c9                   	leave  
8010466a:	c3                   	ret    

8010466b <kill>:
8010466b:	55                   	push   %ebp
8010466c:	89 e5                	mov    %esp,%ebp
8010466e:	83 ec 18             	sub    $0x18,%esp
80104671:	83 ec 0c             	sub    $0xc,%esp
80104674:	68 00 42 19 80       	push   $0x80194200
80104679:	e8 ea 02 00 00       	call   80104968 <acquire>
8010467e:	83 c4 10             	add    $0x10,%esp
80104681:	c7 45 f4 34 42 19 80 	movl   $0x80194234,-0xc(%ebp)
80104688:	eb 45                	jmp    801046cf <kill+0x64>
8010468a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010468d:	8b 40 10             	mov    0x10(%eax),%eax
80104690:	39 45 08             	cmp    %eax,0x8(%ebp)
80104693:	75 36                	jne    801046cb <kill+0x60>
80104695:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104698:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
8010469f:	8b 45 f4             	mov    -0xc(%ebp),%eax
801046a2:	8b 40 0c             	mov    0xc(%eax),%eax
801046a5:	83 f8 02             	cmp    $0x2,%eax
801046a8:	75 0a                	jne    801046b4 <kill+0x49>
801046aa:	8b 45 f4             	mov    -0xc(%ebp),%eax
801046ad:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
801046b4:	83 ec 0c             	sub    $0xc,%esp
801046b7:	68 00 42 19 80       	push   $0x80194200
801046bc:	e8 15 03 00 00       	call   801049d6 <release>
801046c1:	83 c4 10             	add    $0x10,%esp
801046c4:	b8 00 00 00 00       	mov    $0x0,%eax
801046c9:	eb 22                	jmp    801046ed <kill+0x82>
801046cb:	83 6d f4 80          	subl   $0xffffff80,-0xc(%ebp)
801046cf:	81 7d f4 34 62 19 80 	cmpl   $0x80196234,-0xc(%ebp)
801046d6:	72 b2                	jb     8010468a <kill+0x1f>
801046d8:	83 ec 0c             	sub    $0xc,%esp
801046db:	68 00 42 19 80       	push   $0x80194200
801046e0:	e8 f1 02 00 00       	call   801049d6 <release>
801046e5:	83 c4 10             	add    $0x10,%esp
801046e8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801046ed:	c9                   	leave  
801046ee:	c3                   	ret    

801046ef <procdump>:
801046ef:	55                   	push   %ebp
801046f0:	89 e5                	mov    %esp,%ebp
801046f2:	83 ec 48             	sub    $0x48,%esp
801046f5:	c7 45 f0 34 42 19 80 	movl   $0x80194234,-0x10(%ebp)
801046fc:	e9 d7 00 00 00       	jmp    801047d8 <procdump+0xe9>
80104701:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104704:	8b 40 0c             	mov    0xc(%eax),%eax
80104707:	85 c0                	test   %eax,%eax
80104709:	0f 84 c4 00 00 00    	je     801047d3 <procdump+0xe4>
8010470f:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104712:	8b 40 0c             	mov    0xc(%eax),%eax
80104715:	83 f8 05             	cmp    $0x5,%eax
80104718:	77 23                	ja     8010473d <procdump+0x4e>
8010471a:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010471d:	8b 40 0c             	mov    0xc(%eax),%eax
80104720:	8b 04 85 08 f0 10 80 	mov    -0x7fef0ff8(,%eax,4),%eax
80104727:	85 c0                	test   %eax,%eax
80104729:	74 12                	je     8010473d <procdump+0x4e>
8010472b:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010472e:	8b 40 0c             	mov    0xc(%eax),%eax
80104731:	8b 04 85 08 f0 10 80 	mov    -0x7fef0ff8(,%eax,4),%eax
80104738:	89 45 ec             	mov    %eax,-0x14(%ebp)
8010473b:	eb 07                	jmp    80104744 <procdump+0x55>
8010473d:	c7 45 ec a2 a5 10 80 	movl   $0x8010a5a2,-0x14(%ebp)
80104744:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104747:	8d 50 6c             	lea    0x6c(%eax),%edx
8010474a:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010474d:	8b 40 10             	mov    0x10(%eax),%eax
80104750:	52                   	push   %edx
80104751:	ff 75 ec             	push   -0x14(%ebp)
80104754:	50                   	push   %eax
80104755:	68 a6 a5 10 80       	push   $0x8010a5a6
8010475a:	e8 95 bc ff ff       	call   801003f4 <cprintf>
8010475f:	83 c4 10             	add    $0x10,%esp
80104762:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104765:	8b 40 0c             	mov    0xc(%eax),%eax
80104768:	83 f8 02             	cmp    $0x2,%eax
8010476b:	75 54                	jne    801047c1 <procdump+0xd2>
8010476d:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104770:	8b 40 1c             	mov    0x1c(%eax),%eax
80104773:	8b 40 0c             	mov    0xc(%eax),%eax
80104776:	83 c0 08             	add    $0x8,%eax
80104779:	89 c2                	mov    %eax,%edx
8010477b:	83 ec 08             	sub    $0x8,%esp
8010477e:	8d 45 c4             	lea    -0x3c(%ebp),%eax
80104781:	50                   	push   %eax
80104782:	52                   	push   %edx
80104783:	e8 a0 02 00 00       	call   80104a28 <getcallerpcs>
80104788:	83 c4 10             	add    $0x10,%esp
8010478b:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80104792:	eb 1c                	jmp    801047b0 <procdump+0xc1>
80104794:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104797:	8b 44 85 c4          	mov    -0x3c(%ebp,%eax,4),%eax
8010479b:	83 ec 08             	sub    $0x8,%esp
8010479e:	50                   	push   %eax
8010479f:	68 af a5 10 80       	push   $0x8010a5af
801047a4:	e8 4b bc ff ff       	call   801003f4 <cprintf>
801047a9:	83 c4 10             	add    $0x10,%esp
801047ac:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
801047b0:	83 7d f4 09          	cmpl   $0x9,-0xc(%ebp)
801047b4:	7f 0b                	jg     801047c1 <procdump+0xd2>
801047b6:	8b 45 f4             	mov    -0xc(%ebp),%eax
801047b9:	8b 44 85 c4          	mov    -0x3c(%ebp,%eax,4),%eax
801047bd:	85 c0                	test   %eax,%eax
801047bf:	75 d3                	jne    80104794 <procdump+0xa5>
801047c1:	83 ec 0c             	sub    $0xc,%esp
801047c4:	68 b3 a5 10 80       	push   $0x8010a5b3
801047c9:	e8 26 bc ff ff       	call   801003f4 <cprintf>
801047ce:	83 c4 10             	add    $0x10,%esp
801047d1:	eb 01                	jmp    801047d4 <procdump+0xe5>
801047d3:	90                   	nop
801047d4:	83 6d f0 80          	subl   $0xffffff80,-0x10(%ebp)
801047d8:	81 7d f0 34 62 19 80 	cmpl   $0x80196234,-0x10(%ebp)
801047df:	0f 82 1c ff ff ff    	jb     80104701 <procdump+0x12>
801047e5:	90                   	nop
801047e6:	90                   	nop
801047e7:	c9                   	leave  
801047e8:	c3                   	ret    

801047e9 <initsleeplock>:
801047e9:	55                   	push   %ebp
801047ea:	89 e5                	mov    %esp,%ebp
801047ec:	83 ec 08             	sub    $0x8,%esp
801047ef:	8b 45 08             	mov    0x8(%ebp),%eax
801047f2:	83 c0 04             	add    $0x4,%eax
801047f5:	83 ec 08             	sub    $0x8,%esp
801047f8:	68 df a5 10 80       	push   $0x8010a5df
801047fd:	50                   	push   %eax
801047fe:	e8 43 01 00 00       	call   80104946 <initlock>
80104803:	83 c4 10             	add    $0x10,%esp
80104806:	8b 45 08             	mov    0x8(%ebp),%eax
80104809:	8b 55 0c             	mov    0xc(%ebp),%edx
8010480c:	89 50 38             	mov    %edx,0x38(%eax)
8010480f:	8b 45 08             	mov    0x8(%ebp),%eax
80104812:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
80104818:	8b 45 08             	mov    0x8(%ebp),%eax
8010481b:	c7 40 3c 00 00 00 00 	movl   $0x0,0x3c(%eax)
80104822:	90                   	nop
80104823:	c9                   	leave  
80104824:	c3                   	ret    

80104825 <acquiresleep>:
80104825:	55                   	push   %ebp
80104826:	89 e5                	mov    %esp,%ebp
80104828:	83 ec 08             	sub    $0x8,%esp
8010482b:	8b 45 08             	mov    0x8(%ebp),%eax
8010482e:	83 c0 04             	add    $0x4,%eax
80104831:	83 ec 0c             	sub    $0xc,%esp
80104834:	50                   	push   %eax
80104835:	e8 2e 01 00 00       	call   80104968 <acquire>
8010483a:	83 c4 10             	add    $0x10,%esp
8010483d:	eb 15                	jmp    80104854 <acquiresleep+0x2f>
8010483f:	8b 45 08             	mov    0x8(%ebp),%eax
80104842:	83 c0 04             	add    $0x4,%eax
80104845:	83 ec 08             	sub    $0x8,%esp
80104848:	50                   	push   %eax
80104849:	ff 75 08             	push   0x8(%ebp)
8010484c:	e8 fc fc ff ff       	call   8010454d <sleep>
80104851:	83 c4 10             	add    $0x10,%esp
80104854:	8b 45 08             	mov    0x8(%ebp),%eax
80104857:	8b 00                	mov    (%eax),%eax
80104859:	85 c0                	test   %eax,%eax
8010485b:	75 e2                	jne    8010483f <acquiresleep+0x1a>
8010485d:	8b 45 08             	mov    0x8(%ebp),%eax
80104860:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
80104866:	e8 c5 f1 ff ff       	call   80103a30 <myproc>
8010486b:	8b 50 10             	mov    0x10(%eax),%edx
8010486e:	8b 45 08             	mov    0x8(%ebp),%eax
80104871:	89 50 3c             	mov    %edx,0x3c(%eax)
80104874:	8b 45 08             	mov    0x8(%ebp),%eax
80104877:	83 c0 04             	add    $0x4,%eax
8010487a:	83 ec 0c             	sub    $0xc,%esp
8010487d:	50                   	push   %eax
8010487e:	e8 53 01 00 00       	call   801049d6 <release>
80104883:	83 c4 10             	add    $0x10,%esp
80104886:	90                   	nop
80104887:	c9                   	leave  
80104888:	c3                   	ret    

80104889 <releasesleep>:
80104889:	55                   	push   %ebp
8010488a:	89 e5                	mov    %esp,%ebp
8010488c:	83 ec 08             	sub    $0x8,%esp
8010488f:	8b 45 08             	mov    0x8(%ebp),%eax
80104892:	83 c0 04             	add    $0x4,%eax
80104895:	83 ec 0c             	sub    $0xc,%esp
80104898:	50                   	push   %eax
80104899:	e8 ca 00 00 00       	call   80104968 <acquire>
8010489e:	83 c4 10             	add    $0x10,%esp
801048a1:	8b 45 08             	mov    0x8(%ebp),%eax
801048a4:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
801048aa:	8b 45 08             	mov    0x8(%ebp),%eax
801048ad:	c7 40 3c 00 00 00 00 	movl   $0x0,0x3c(%eax)
801048b4:	83 ec 0c             	sub    $0xc,%esp
801048b7:	ff 75 08             	push   0x8(%ebp)
801048ba:	e8 75 fd ff ff       	call   80104634 <wakeup>
801048bf:	83 c4 10             	add    $0x10,%esp
801048c2:	8b 45 08             	mov    0x8(%ebp),%eax
801048c5:	83 c0 04             	add    $0x4,%eax
801048c8:	83 ec 0c             	sub    $0xc,%esp
801048cb:	50                   	push   %eax
801048cc:	e8 05 01 00 00       	call   801049d6 <release>
801048d1:	83 c4 10             	add    $0x10,%esp
801048d4:	90                   	nop
801048d5:	c9                   	leave  
801048d6:	c3                   	ret    

801048d7 <holdingsleep>:
801048d7:	55                   	push   %ebp
801048d8:	89 e5                	mov    %esp,%ebp
801048da:	83 ec 18             	sub    $0x18,%esp
801048dd:	8b 45 08             	mov    0x8(%ebp),%eax
801048e0:	83 c0 04             	add    $0x4,%eax
801048e3:	83 ec 0c             	sub    $0xc,%esp
801048e6:	50                   	push   %eax
801048e7:	e8 7c 00 00 00       	call   80104968 <acquire>
801048ec:	83 c4 10             	add    $0x10,%esp
801048ef:	8b 45 08             	mov    0x8(%ebp),%eax
801048f2:	8b 00                	mov    (%eax),%eax
801048f4:	89 45 f4             	mov    %eax,-0xc(%ebp)
801048f7:	8b 45 08             	mov    0x8(%ebp),%eax
801048fa:	83 c0 04             	add    $0x4,%eax
801048fd:	83 ec 0c             	sub    $0xc,%esp
80104900:	50                   	push   %eax
80104901:	e8 d0 00 00 00       	call   801049d6 <release>
80104906:	83 c4 10             	add    $0x10,%esp
80104909:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010490c:	c9                   	leave  
8010490d:	c3                   	ret    

8010490e <readeflags>:
8010490e:	55                   	push   %ebp
8010490f:	89 e5                	mov    %esp,%ebp
80104911:	83 ec 10             	sub    $0x10,%esp
80104914:	9c                   	pushf  
80104915:	58                   	pop    %eax
80104916:	89 45 fc             	mov    %eax,-0x4(%ebp)
80104919:	8b 45 fc             	mov    -0x4(%ebp),%eax
8010491c:	c9                   	leave  
8010491d:	c3                   	ret    

8010491e <cli>:
8010491e:	55                   	push   %ebp
8010491f:	89 e5                	mov    %esp,%ebp
80104921:	fa                   	cli    
80104922:	90                   	nop
80104923:	5d                   	pop    %ebp
80104924:	c3                   	ret    

80104925 <sti>:
80104925:	55                   	push   %ebp
80104926:	89 e5                	mov    %esp,%ebp
80104928:	fb                   	sti    
80104929:	90                   	nop
8010492a:	5d                   	pop    %ebp
8010492b:	c3                   	ret    

8010492c <xchg>:
8010492c:	55                   	push   %ebp
8010492d:	89 e5                	mov    %esp,%ebp
8010492f:	83 ec 10             	sub    $0x10,%esp
80104932:	8b 55 08             	mov    0x8(%ebp),%edx
80104935:	8b 45 0c             	mov    0xc(%ebp),%eax
80104938:	8b 4d 08             	mov    0x8(%ebp),%ecx
8010493b:	f0 87 02             	lock xchg %eax,(%edx)
8010493e:	89 45 fc             	mov    %eax,-0x4(%ebp)
80104941:	8b 45 fc             	mov    -0x4(%ebp),%eax
80104944:	c9                   	leave  
80104945:	c3                   	ret    

80104946 <initlock>:
80104946:	55                   	push   %ebp
80104947:	89 e5                	mov    %esp,%ebp
80104949:	8b 45 08             	mov    0x8(%ebp),%eax
8010494c:	8b 55 0c             	mov    0xc(%ebp),%edx
8010494f:	89 50 04             	mov    %edx,0x4(%eax)
80104952:	8b 45 08             	mov    0x8(%ebp),%eax
80104955:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
8010495b:	8b 45 08             	mov    0x8(%ebp),%eax
8010495e:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
80104965:	90                   	nop
80104966:	5d                   	pop    %ebp
80104967:	c3                   	ret    

80104968 <acquire>:
80104968:	55                   	push   %ebp
80104969:	89 e5                	mov    %esp,%ebp
8010496b:	53                   	push   %ebx
8010496c:	83 ec 04             	sub    $0x4,%esp
8010496f:	e8 5f 01 00 00       	call   80104ad3 <pushcli>
80104974:	8b 45 08             	mov    0x8(%ebp),%eax
80104977:	83 ec 0c             	sub    $0xc,%esp
8010497a:	50                   	push   %eax
8010497b:	e8 23 01 00 00       	call   80104aa3 <holding>
80104980:	83 c4 10             	add    $0x10,%esp
80104983:	85 c0                	test   %eax,%eax
80104985:	74 0d                	je     80104994 <acquire+0x2c>
80104987:	83 ec 0c             	sub    $0xc,%esp
8010498a:	68 ea a5 10 80       	push   $0x8010a5ea
8010498f:	e8 15 bc ff ff       	call   801005a9 <panic>
80104994:	90                   	nop
80104995:	8b 45 08             	mov    0x8(%ebp),%eax
80104998:	83 ec 08             	sub    $0x8,%esp
8010499b:	6a 01                	push   $0x1
8010499d:	50                   	push   %eax
8010499e:	e8 89 ff ff ff       	call   8010492c <xchg>
801049a3:	83 c4 10             	add    $0x10,%esp
801049a6:	85 c0                	test   %eax,%eax
801049a8:	75 eb                	jne    80104995 <acquire+0x2d>
801049aa:	f0 83 0c 24 00       	lock orl $0x0,(%esp)
801049af:	8b 5d 08             	mov    0x8(%ebp),%ebx
801049b2:	e8 01 f0 ff ff       	call   801039b8 <mycpu>
801049b7:	89 43 08             	mov    %eax,0x8(%ebx)
801049ba:	8b 45 08             	mov    0x8(%ebp),%eax
801049bd:	83 c0 0c             	add    $0xc,%eax
801049c0:	83 ec 08             	sub    $0x8,%esp
801049c3:	50                   	push   %eax
801049c4:	8d 45 08             	lea    0x8(%ebp),%eax
801049c7:	50                   	push   %eax
801049c8:	e8 5b 00 00 00       	call   80104a28 <getcallerpcs>
801049cd:	83 c4 10             	add    $0x10,%esp
801049d0:	90                   	nop
801049d1:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801049d4:	c9                   	leave  
801049d5:	c3                   	ret    

801049d6 <release>:
801049d6:	55                   	push   %ebp
801049d7:	89 e5                	mov    %esp,%ebp
801049d9:	83 ec 08             	sub    $0x8,%esp
801049dc:	83 ec 0c             	sub    $0xc,%esp
801049df:	ff 75 08             	push   0x8(%ebp)
801049e2:	e8 bc 00 00 00       	call   80104aa3 <holding>
801049e7:	83 c4 10             	add    $0x10,%esp
801049ea:	85 c0                	test   %eax,%eax
801049ec:	75 0d                	jne    801049fb <release+0x25>
801049ee:	83 ec 0c             	sub    $0xc,%esp
801049f1:	68 f2 a5 10 80       	push   $0x8010a5f2
801049f6:	e8 ae bb ff ff       	call   801005a9 <panic>
801049fb:	8b 45 08             	mov    0x8(%ebp),%eax
801049fe:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
80104a05:	8b 45 08             	mov    0x8(%ebp),%eax
80104a08:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
80104a0f:	f0 83 0c 24 00       	lock orl $0x0,(%esp)
80104a14:	8b 45 08             	mov    0x8(%ebp),%eax
80104a17:	8b 55 08             	mov    0x8(%ebp),%edx
80104a1a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
80104a20:	e8 fb 00 00 00       	call   80104b20 <popcli>
80104a25:	90                   	nop
80104a26:	c9                   	leave  
80104a27:	c3                   	ret    

80104a28 <getcallerpcs>:
80104a28:	55                   	push   %ebp
80104a29:	89 e5                	mov    %esp,%ebp
80104a2b:	83 ec 10             	sub    $0x10,%esp
80104a2e:	8b 45 08             	mov    0x8(%ebp),%eax
80104a31:	83 e8 08             	sub    $0x8,%eax
80104a34:	89 45 fc             	mov    %eax,-0x4(%ebp)
80104a37:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
80104a3e:	eb 38                	jmp    80104a78 <getcallerpcs+0x50>
80104a40:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
80104a44:	74 53                	je     80104a99 <getcallerpcs+0x71>
80104a46:	81 7d fc ff ff ff 7f 	cmpl   $0x7fffffff,-0x4(%ebp)
80104a4d:	76 4a                	jbe    80104a99 <getcallerpcs+0x71>
80104a4f:	83 7d fc ff          	cmpl   $0xffffffff,-0x4(%ebp)
80104a53:	74 44                	je     80104a99 <getcallerpcs+0x71>
80104a55:	8b 45 f8             	mov    -0x8(%ebp),%eax
80104a58:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80104a5f:	8b 45 0c             	mov    0xc(%ebp),%eax
80104a62:	01 c2                	add    %eax,%edx
80104a64:	8b 45 fc             	mov    -0x4(%ebp),%eax
80104a67:	8b 40 04             	mov    0x4(%eax),%eax
80104a6a:	89 02                	mov    %eax,(%edx)
80104a6c:	8b 45 fc             	mov    -0x4(%ebp),%eax
80104a6f:	8b 00                	mov    (%eax),%eax
80104a71:	89 45 fc             	mov    %eax,-0x4(%ebp)
80104a74:	83 45 f8 01          	addl   $0x1,-0x8(%ebp)
80104a78:	83 7d f8 09          	cmpl   $0x9,-0x8(%ebp)
80104a7c:	7e c2                	jle    80104a40 <getcallerpcs+0x18>
80104a7e:	eb 19                	jmp    80104a99 <getcallerpcs+0x71>
80104a80:	8b 45 f8             	mov    -0x8(%ebp),%eax
80104a83:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80104a8a:	8b 45 0c             	mov    0xc(%ebp),%eax
80104a8d:	01 d0                	add    %edx,%eax
80104a8f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
80104a95:	83 45 f8 01          	addl   $0x1,-0x8(%ebp)
80104a99:	83 7d f8 09          	cmpl   $0x9,-0x8(%ebp)
80104a9d:	7e e1                	jle    80104a80 <getcallerpcs+0x58>
80104a9f:	90                   	nop
80104aa0:	90                   	nop
80104aa1:	c9                   	leave  
80104aa2:	c3                   	ret    

80104aa3 <holding>:
80104aa3:	55                   	push   %ebp
80104aa4:	89 e5                	mov    %esp,%ebp
80104aa6:	53                   	push   %ebx
80104aa7:	83 ec 04             	sub    $0x4,%esp
80104aaa:	8b 45 08             	mov    0x8(%ebp),%eax
80104aad:	8b 00                	mov    (%eax),%eax
80104aaf:	85 c0                	test   %eax,%eax
80104ab1:	74 16                	je     80104ac9 <holding+0x26>
80104ab3:	8b 45 08             	mov    0x8(%ebp),%eax
80104ab6:	8b 58 08             	mov    0x8(%eax),%ebx
80104ab9:	e8 fa ee ff ff       	call   801039b8 <mycpu>
80104abe:	39 c3                	cmp    %eax,%ebx
80104ac0:	75 07                	jne    80104ac9 <holding+0x26>
80104ac2:	b8 01 00 00 00       	mov    $0x1,%eax
80104ac7:	eb 05                	jmp    80104ace <holding+0x2b>
80104ac9:	b8 00 00 00 00       	mov    $0x0,%eax
80104ace:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104ad1:	c9                   	leave  
80104ad2:	c3                   	ret    

80104ad3 <pushcli>:
80104ad3:	55                   	push   %ebp
80104ad4:	89 e5                	mov    %esp,%ebp
80104ad6:	83 ec 18             	sub    $0x18,%esp
80104ad9:	e8 30 fe ff ff       	call   8010490e <readeflags>
80104ade:	89 45 f4             	mov    %eax,-0xc(%ebp)
80104ae1:	e8 38 fe ff ff       	call   8010491e <cli>
80104ae6:	e8 cd ee ff ff       	call   801039b8 <mycpu>
80104aeb:	8b 80 a4 00 00 00    	mov    0xa4(%eax),%eax
80104af1:	85 c0                	test   %eax,%eax
80104af3:	75 14                	jne    80104b09 <pushcli+0x36>
80104af5:	e8 be ee ff ff       	call   801039b8 <mycpu>
80104afa:	8b 55 f4             	mov    -0xc(%ebp),%edx
80104afd:	81 e2 00 02 00 00    	and    $0x200,%edx
80104b03:	89 90 a8 00 00 00    	mov    %edx,0xa8(%eax)
80104b09:	e8 aa ee ff ff       	call   801039b8 <mycpu>
80104b0e:	8b 90 a4 00 00 00    	mov    0xa4(%eax),%edx
80104b14:	83 c2 01             	add    $0x1,%edx
80104b17:	89 90 a4 00 00 00    	mov    %edx,0xa4(%eax)
80104b1d:	90                   	nop
80104b1e:	c9                   	leave  
80104b1f:	c3                   	ret    

80104b20 <popcli>:
80104b20:	55                   	push   %ebp
80104b21:	89 e5                	mov    %esp,%ebp
80104b23:	83 ec 08             	sub    $0x8,%esp
80104b26:	e8 e3 fd ff ff       	call   8010490e <readeflags>
80104b2b:	25 00 02 00 00       	and    $0x200,%eax
80104b30:	85 c0                	test   %eax,%eax
80104b32:	74 0d                	je     80104b41 <popcli+0x21>
80104b34:	83 ec 0c             	sub    $0xc,%esp
80104b37:	68 fa a5 10 80       	push   $0x8010a5fa
80104b3c:	e8 68 ba ff ff       	call   801005a9 <panic>
80104b41:	e8 72 ee ff ff       	call   801039b8 <mycpu>
80104b46:	8b 90 a4 00 00 00    	mov    0xa4(%eax),%edx
80104b4c:	83 ea 01             	sub    $0x1,%edx
80104b4f:	89 90 a4 00 00 00    	mov    %edx,0xa4(%eax)
80104b55:	8b 80 a4 00 00 00    	mov    0xa4(%eax),%eax
80104b5b:	85 c0                	test   %eax,%eax
80104b5d:	79 0d                	jns    80104b6c <popcli+0x4c>
80104b5f:	83 ec 0c             	sub    $0xc,%esp
80104b62:	68 11 a6 10 80       	push   $0x8010a611
80104b67:	e8 3d ba ff ff       	call   801005a9 <panic>
80104b6c:	e8 47 ee ff ff       	call   801039b8 <mycpu>
80104b71:	8b 80 a4 00 00 00    	mov    0xa4(%eax),%eax
80104b77:	85 c0                	test   %eax,%eax
80104b79:	75 14                	jne    80104b8f <popcli+0x6f>
80104b7b:	e8 38 ee ff ff       	call   801039b8 <mycpu>
80104b80:	8b 80 a8 00 00 00    	mov    0xa8(%eax),%eax
80104b86:	85 c0                	test   %eax,%eax
80104b88:	74 05                	je     80104b8f <popcli+0x6f>
80104b8a:	e8 96 fd ff ff       	call   80104925 <sti>
80104b8f:	90                   	nop
80104b90:	c9                   	leave  
80104b91:	c3                   	ret    

80104b92 <stosb>:
80104b92:	55                   	push   %ebp
80104b93:	89 e5                	mov    %esp,%ebp
80104b95:	57                   	push   %edi
80104b96:	53                   	push   %ebx
80104b97:	8b 4d 08             	mov    0x8(%ebp),%ecx
80104b9a:	8b 55 10             	mov    0x10(%ebp),%edx
80104b9d:	8b 45 0c             	mov    0xc(%ebp),%eax
80104ba0:	89 cb                	mov    %ecx,%ebx
80104ba2:	89 df                	mov    %ebx,%edi
80104ba4:	89 d1                	mov    %edx,%ecx
80104ba6:	fc                   	cld    
80104ba7:	f3 aa                	rep stos %al,%es:(%edi)
80104ba9:	89 ca                	mov    %ecx,%edx
80104bab:	89 fb                	mov    %edi,%ebx
80104bad:	89 5d 08             	mov    %ebx,0x8(%ebp)
80104bb0:	89 55 10             	mov    %edx,0x10(%ebp)
80104bb3:	90                   	nop
80104bb4:	5b                   	pop    %ebx
80104bb5:	5f                   	pop    %edi
80104bb6:	5d                   	pop    %ebp
80104bb7:	c3                   	ret    

80104bb8 <stosl>:
80104bb8:	55                   	push   %ebp
80104bb9:	89 e5                	mov    %esp,%ebp
80104bbb:	57                   	push   %edi
80104bbc:	53                   	push   %ebx
80104bbd:	8b 4d 08             	mov    0x8(%ebp),%ecx
80104bc0:	8b 55 10             	mov    0x10(%ebp),%edx
80104bc3:	8b 45 0c             	mov    0xc(%ebp),%eax
80104bc6:	89 cb                	mov    %ecx,%ebx
80104bc8:	89 df                	mov    %ebx,%edi
80104bca:	89 d1                	mov    %edx,%ecx
80104bcc:	fc                   	cld    
80104bcd:	f3 ab                	rep stos %eax,%es:(%edi)
80104bcf:	89 ca                	mov    %ecx,%edx
80104bd1:	89 fb                	mov    %edi,%ebx
80104bd3:	89 5d 08             	mov    %ebx,0x8(%ebp)
80104bd6:	89 55 10             	mov    %edx,0x10(%ebp)
80104bd9:	90                   	nop
80104bda:	5b                   	pop    %ebx
80104bdb:	5f                   	pop    %edi
80104bdc:	5d                   	pop    %ebp
80104bdd:	c3                   	ret    

80104bde <memset>:
80104bde:	55                   	push   %ebp
80104bdf:	89 e5                	mov    %esp,%ebp
80104be1:	8b 45 08             	mov    0x8(%ebp),%eax
80104be4:	83 e0 03             	and    $0x3,%eax
80104be7:	85 c0                	test   %eax,%eax
80104be9:	75 43                	jne    80104c2e <memset+0x50>
80104beb:	8b 45 10             	mov    0x10(%ebp),%eax
80104bee:	83 e0 03             	and    $0x3,%eax
80104bf1:	85 c0                	test   %eax,%eax
80104bf3:	75 39                	jne    80104c2e <memset+0x50>
80104bf5:	81 65 0c ff 00 00 00 	andl   $0xff,0xc(%ebp)
80104bfc:	8b 45 10             	mov    0x10(%ebp),%eax
80104bff:	c1 e8 02             	shr    $0x2,%eax
80104c02:	89 c2                	mov    %eax,%edx
80104c04:	8b 45 0c             	mov    0xc(%ebp),%eax
80104c07:	c1 e0 18             	shl    $0x18,%eax
80104c0a:	89 c1                	mov    %eax,%ecx
80104c0c:	8b 45 0c             	mov    0xc(%ebp),%eax
80104c0f:	c1 e0 10             	shl    $0x10,%eax
80104c12:	09 c1                	or     %eax,%ecx
80104c14:	8b 45 0c             	mov    0xc(%ebp),%eax
80104c17:	c1 e0 08             	shl    $0x8,%eax
80104c1a:	09 c8                	or     %ecx,%eax
80104c1c:	0b 45 0c             	or     0xc(%ebp),%eax
80104c1f:	52                   	push   %edx
80104c20:	50                   	push   %eax
80104c21:	ff 75 08             	push   0x8(%ebp)
80104c24:	e8 8f ff ff ff       	call   80104bb8 <stosl>
80104c29:	83 c4 0c             	add    $0xc,%esp
80104c2c:	eb 12                	jmp    80104c40 <memset+0x62>
80104c2e:	8b 45 10             	mov    0x10(%ebp),%eax
80104c31:	50                   	push   %eax
80104c32:	ff 75 0c             	push   0xc(%ebp)
80104c35:	ff 75 08             	push   0x8(%ebp)
80104c38:	e8 55 ff ff ff       	call   80104b92 <stosb>
80104c3d:	83 c4 0c             	add    $0xc,%esp
80104c40:	8b 45 08             	mov    0x8(%ebp),%eax
80104c43:	c9                   	leave  
80104c44:	c3                   	ret    

80104c45 <memcmp>:
80104c45:	55                   	push   %ebp
80104c46:	89 e5                	mov    %esp,%ebp
80104c48:	83 ec 10             	sub    $0x10,%esp
80104c4b:	8b 45 08             	mov    0x8(%ebp),%eax
80104c4e:	89 45 fc             	mov    %eax,-0x4(%ebp)
80104c51:	8b 45 0c             	mov    0xc(%ebp),%eax
80104c54:	89 45 f8             	mov    %eax,-0x8(%ebp)
80104c57:	eb 30                	jmp    80104c89 <memcmp+0x44>
80104c59:	8b 45 fc             	mov    -0x4(%ebp),%eax
80104c5c:	0f b6 10             	movzbl (%eax),%edx
80104c5f:	8b 45 f8             	mov    -0x8(%ebp),%eax
80104c62:	0f b6 00             	movzbl (%eax),%eax
80104c65:	38 c2                	cmp    %al,%dl
80104c67:	74 18                	je     80104c81 <memcmp+0x3c>
80104c69:	8b 45 fc             	mov    -0x4(%ebp),%eax
80104c6c:	0f b6 00             	movzbl (%eax),%eax
80104c6f:	0f b6 d0             	movzbl %al,%edx
80104c72:	8b 45 f8             	mov    -0x8(%ebp),%eax
80104c75:	0f b6 00             	movzbl (%eax),%eax
80104c78:	0f b6 c8             	movzbl %al,%ecx
80104c7b:	89 d0                	mov    %edx,%eax
80104c7d:	29 c8                	sub    %ecx,%eax
80104c7f:	eb 1a                	jmp    80104c9b <memcmp+0x56>
80104c81:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
80104c85:	83 45 f8 01          	addl   $0x1,-0x8(%ebp)
80104c89:	8b 45 10             	mov    0x10(%ebp),%eax
80104c8c:	8d 50 ff             	lea    -0x1(%eax),%edx
80104c8f:	89 55 10             	mov    %edx,0x10(%ebp)
80104c92:	85 c0                	test   %eax,%eax
80104c94:	75 c3                	jne    80104c59 <memcmp+0x14>
80104c96:	b8 00 00 00 00       	mov    $0x0,%eax
80104c9b:	c9                   	leave  
80104c9c:	c3                   	ret    

80104c9d <memmove>:
80104c9d:	55                   	push   %ebp
80104c9e:	89 e5                	mov    %esp,%ebp
80104ca0:	83 ec 10             	sub    $0x10,%esp
80104ca3:	8b 45 0c             	mov    0xc(%ebp),%eax
80104ca6:	89 45 fc             	mov    %eax,-0x4(%ebp)
80104ca9:	8b 45 08             	mov    0x8(%ebp),%eax
80104cac:	89 45 f8             	mov    %eax,-0x8(%ebp)
80104caf:	8b 45 fc             	mov    -0x4(%ebp),%eax
80104cb2:	3b 45 f8             	cmp    -0x8(%ebp),%eax
80104cb5:	73 54                	jae    80104d0b <memmove+0x6e>
80104cb7:	8b 55 fc             	mov    -0x4(%ebp),%edx
80104cba:	8b 45 10             	mov    0x10(%ebp),%eax
80104cbd:	01 d0                	add    %edx,%eax
80104cbf:	39 45 f8             	cmp    %eax,-0x8(%ebp)
80104cc2:	73 47                	jae    80104d0b <memmove+0x6e>
80104cc4:	8b 45 10             	mov    0x10(%ebp),%eax
80104cc7:	01 45 fc             	add    %eax,-0x4(%ebp)
80104cca:	8b 45 10             	mov    0x10(%ebp),%eax
80104ccd:	01 45 f8             	add    %eax,-0x8(%ebp)
80104cd0:	eb 13                	jmp    80104ce5 <memmove+0x48>
80104cd2:	83 6d fc 01          	subl   $0x1,-0x4(%ebp)
80104cd6:	83 6d f8 01          	subl   $0x1,-0x8(%ebp)
80104cda:	8b 45 fc             	mov    -0x4(%ebp),%eax
80104cdd:	0f b6 10             	movzbl (%eax),%edx
80104ce0:	8b 45 f8             	mov    -0x8(%ebp),%eax
80104ce3:	88 10                	mov    %dl,(%eax)
80104ce5:	8b 45 10             	mov    0x10(%ebp),%eax
80104ce8:	8d 50 ff             	lea    -0x1(%eax),%edx
80104ceb:	89 55 10             	mov    %edx,0x10(%ebp)
80104cee:	85 c0                	test   %eax,%eax
80104cf0:	75 e0                	jne    80104cd2 <memmove+0x35>
80104cf2:	eb 24                	jmp    80104d18 <memmove+0x7b>
80104cf4:	8b 55 fc             	mov    -0x4(%ebp),%edx
80104cf7:	8d 42 01             	lea    0x1(%edx),%eax
80104cfa:	89 45 fc             	mov    %eax,-0x4(%ebp)
80104cfd:	8b 45 f8             	mov    -0x8(%ebp),%eax
80104d00:	8d 48 01             	lea    0x1(%eax),%ecx
80104d03:	89 4d f8             	mov    %ecx,-0x8(%ebp)
80104d06:	0f b6 12             	movzbl (%edx),%edx
80104d09:	88 10                	mov    %dl,(%eax)
80104d0b:	8b 45 10             	mov    0x10(%ebp),%eax
80104d0e:	8d 50 ff             	lea    -0x1(%eax),%edx
80104d11:	89 55 10             	mov    %edx,0x10(%ebp)
80104d14:	85 c0                	test   %eax,%eax
80104d16:	75 dc                	jne    80104cf4 <memmove+0x57>
80104d18:	8b 45 08             	mov    0x8(%ebp),%eax
80104d1b:	c9                   	leave  
80104d1c:	c3                   	ret    

80104d1d <memcpy>:
80104d1d:	55                   	push   %ebp
80104d1e:	89 e5                	mov    %esp,%ebp
80104d20:	ff 75 10             	push   0x10(%ebp)
80104d23:	ff 75 0c             	push   0xc(%ebp)
80104d26:	ff 75 08             	push   0x8(%ebp)
80104d29:	e8 6f ff ff ff       	call   80104c9d <memmove>
80104d2e:	83 c4 0c             	add    $0xc,%esp
80104d31:	c9                   	leave  
80104d32:	c3                   	ret    

80104d33 <strncmp>:
80104d33:	55                   	push   %ebp
80104d34:	89 e5                	mov    %esp,%ebp
80104d36:	eb 0c                	jmp    80104d44 <strncmp+0x11>
80104d38:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
80104d3c:	83 45 08 01          	addl   $0x1,0x8(%ebp)
80104d40:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
80104d44:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
80104d48:	74 1a                	je     80104d64 <strncmp+0x31>
80104d4a:	8b 45 08             	mov    0x8(%ebp),%eax
80104d4d:	0f b6 00             	movzbl (%eax),%eax
80104d50:	84 c0                	test   %al,%al
80104d52:	74 10                	je     80104d64 <strncmp+0x31>
80104d54:	8b 45 08             	mov    0x8(%ebp),%eax
80104d57:	0f b6 10             	movzbl (%eax),%edx
80104d5a:	8b 45 0c             	mov    0xc(%ebp),%eax
80104d5d:	0f b6 00             	movzbl (%eax),%eax
80104d60:	38 c2                	cmp    %al,%dl
80104d62:	74 d4                	je     80104d38 <strncmp+0x5>
80104d64:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
80104d68:	75 07                	jne    80104d71 <strncmp+0x3e>
80104d6a:	b8 00 00 00 00       	mov    $0x0,%eax
80104d6f:	eb 16                	jmp    80104d87 <strncmp+0x54>
80104d71:	8b 45 08             	mov    0x8(%ebp),%eax
80104d74:	0f b6 00             	movzbl (%eax),%eax
80104d77:	0f b6 d0             	movzbl %al,%edx
80104d7a:	8b 45 0c             	mov    0xc(%ebp),%eax
80104d7d:	0f b6 00             	movzbl (%eax),%eax
80104d80:	0f b6 c8             	movzbl %al,%ecx
80104d83:	89 d0                	mov    %edx,%eax
80104d85:	29 c8                	sub    %ecx,%eax
80104d87:	5d                   	pop    %ebp
80104d88:	c3                   	ret    

80104d89 <strncpy>:
80104d89:	55                   	push   %ebp
80104d8a:	89 e5                	mov    %esp,%ebp
80104d8c:	83 ec 10             	sub    $0x10,%esp
80104d8f:	8b 45 08             	mov    0x8(%ebp),%eax
80104d92:	89 45 fc             	mov    %eax,-0x4(%ebp)
80104d95:	90                   	nop
80104d96:	8b 45 10             	mov    0x10(%ebp),%eax
80104d99:	8d 50 ff             	lea    -0x1(%eax),%edx
80104d9c:	89 55 10             	mov    %edx,0x10(%ebp)
80104d9f:	85 c0                	test   %eax,%eax
80104da1:	7e 2c                	jle    80104dcf <strncpy+0x46>
80104da3:	8b 55 0c             	mov    0xc(%ebp),%edx
80104da6:	8d 42 01             	lea    0x1(%edx),%eax
80104da9:	89 45 0c             	mov    %eax,0xc(%ebp)
80104dac:	8b 45 08             	mov    0x8(%ebp),%eax
80104daf:	8d 48 01             	lea    0x1(%eax),%ecx
80104db2:	89 4d 08             	mov    %ecx,0x8(%ebp)
80104db5:	0f b6 12             	movzbl (%edx),%edx
80104db8:	88 10                	mov    %dl,(%eax)
80104dba:	0f b6 00             	movzbl (%eax),%eax
80104dbd:	84 c0                	test   %al,%al
80104dbf:	75 d5                	jne    80104d96 <strncpy+0xd>
80104dc1:	eb 0c                	jmp    80104dcf <strncpy+0x46>
80104dc3:	8b 45 08             	mov    0x8(%ebp),%eax
80104dc6:	8d 50 01             	lea    0x1(%eax),%edx
80104dc9:	89 55 08             	mov    %edx,0x8(%ebp)
80104dcc:	c6 00 00             	movb   $0x0,(%eax)
80104dcf:	8b 45 10             	mov    0x10(%ebp),%eax
80104dd2:	8d 50 ff             	lea    -0x1(%eax),%edx
80104dd5:	89 55 10             	mov    %edx,0x10(%ebp)
80104dd8:	85 c0                	test   %eax,%eax
80104dda:	7f e7                	jg     80104dc3 <strncpy+0x3a>
80104ddc:	8b 45 fc             	mov    -0x4(%ebp),%eax
80104ddf:	c9                   	leave  
80104de0:	c3                   	ret    

80104de1 <safestrcpy>:
80104de1:	55                   	push   %ebp
80104de2:	89 e5                	mov    %esp,%ebp
80104de4:	83 ec 10             	sub    $0x10,%esp
80104de7:	8b 45 08             	mov    0x8(%ebp),%eax
80104dea:	89 45 fc             	mov    %eax,-0x4(%ebp)
80104ded:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
80104df1:	7f 05                	jg     80104df8 <safestrcpy+0x17>
80104df3:	8b 45 fc             	mov    -0x4(%ebp),%eax
80104df6:	eb 32                	jmp    80104e2a <safestrcpy+0x49>
80104df8:	90                   	nop
80104df9:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
80104dfd:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
80104e01:	7e 1e                	jle    80104e21 <safestrcpy+0x40>
80104e03:	8b 55 0c             	mov    0xc(%ebp),%edx
80104e06:	8d 42 01             	lea    0x1(%edx),%eax
80104e09:	89 45 0c             	mov    %eax,0xc(%ebp)
80104e0c:	8b 45 08             	mov    0x8(%ebp),%eax
80104e0f:	8d 48 01             	lea    0x1(%eax),%ecx
80104e12:	89 4d 08             	mov    %ecx,0x8(%ebp)
80104e15:	0f b6 12             	movzbl (%edx),%edx
80104e18:	88 10                	mov    %dl,(%eax)
80104e1a:	0f b6 00             	movzbl (%eax),%eax
80104e1d:	84 c0                	test   %al,%al
80104e1f:	75 d8                	jne    80104df9 <safestrcpy+0x18>
80104e21:	8b 45 08             	mov    0x8(%ebp),%eax
80104e24:	c6 00 00             	movb   $0x0,(%eax)
80104e27:	8b 45 fc             	mov    -0x4(%ebp),%eax
80104e2a:	c9                   	leave  
80104e2b:	c3                   	ret    

80104e2c <strlen>:
80104e2c:	55                   	push   %ebp
80104e2d:	89 e5                	mov    %esp,%ebp
80104e2f:	83 ec 10             	sub    $0x10,%esp
80104e32:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
80104e39:	eb 04                	jmp    80104e3f <strlen+0x13>
80104e3b:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
80104e3f:	8b 55 fc             	mov    -0x4(%ebp),%edx
80104e42:	8b 45 08             	mov    0x8(%ebp),%eax
80104e45:	01 d0                	add    %edx,%eax
80104e47:	0f b6 00             	movzbl (%eax),%eax
80104e4a:	84 c0                	test   %al,%al
80104e4c:	75 ed                	jne    80104e3b <strlen+0xf>
80104e4e:	8b 45 fc             	mov    -0x4(%ebp),%eax
80104e51:	c9                   	leave  
80104e52:	c3                   	ret    

80104e53 <swtch>:
80104e53:	8b 44 24 04          	mov    0x4(%esp),%eax
80104e57:	8b 54 24 08          	mov    0x8(%esp),%edx
80104e5b:	55                   	push   %ebp
80104e5c:	53                   	push   %ebx
80104e5d:	56                   	push   %esi
80104e5e:	57                   	push   %edi
80104e5f:	89 20                	mov    %esp,(%eax)
80104e61:	89 d4                	mov    %edx,%esp
80104e63:	5f                   	pop    %edi
80104e64:	5e                   	pop    %esi
80104e65:	5b                   	pop    %ebx
80104e66:	5d                   	pop    %ebp
80104e67:	c3                   	ret    

80104e68 <fetchint>:
80104e68:	55                   	push   %ebp
80104e69:	89 e5                	mov    %esp,%ebp
80104e6b:	83 ec 18             	sub    $0x18,%esp
80104e6e:	e8 bd eb ff ff       	call   80103a30 <myproc>
80104e73:	89 45 f4             	mov    %eax,-0xc(%ebp)
80104e76:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104e79:	8b 00                	mov    (%eax),%eax
80104e7b:	39 45 08             	cmp    %eax,0x8(%ebp)
80104e7e:	73 0f                	jae    80104e8f <fetchint+0x27>
80104e80:	8b 45 08             	mov    0x8(%ebp),%eax
80104e83:	8d 50 04             	lea    0x4(%eax),%edx
80104e86:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104e89:	8b 00                	mov    (%eax),%eax
80104e8b:	39 c2                	cmp    %eax,%edx
80104e8d:	76 07                	jbe    80104e96 <fetchint+0x2e>
80104e8f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104e94:	eb 0f                	jmp    80104ea5 <fetchint+0x3d>
80104e96:	8b 45 08             	mov    0x8(%ebp),%eax
80104e99:	8b 10                	mov    (%eax),%edx
80104e9b:	8b 45 0c             	mov    0xc(%ebp),%eax
80104e9e:	89 10                	mov    %edx,(%eax)
80104ea0:	b8 00 00 00 00       	mov    $0x0,%eax
80104ea5:	c9                   	leave  
80104ea6:	c3                   	ret    

80104ea7 <fetchstr>:
80104ea7:	55                   	push   %ebp
80104ea8:	89 e5                	mov    %esp,%ebp
80104eaa:	83 ec 18             	sub    $0x18,%esp
80104ead:	e8 7e eb ff ff       	call   80103a30 <myproc>
80104eb2:	89 45 f0             	mov    %eax,-0x10(%ebp)
80104eb5:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104eb8:	8b 00                	mov    (%eax),%eax
80104eba:	39 45 08             	cmp    %eax,0x8(%ebp)
80104ebd:	72 07                	jb     80104ec6 <fetchstr+0x1f>
80104ebf:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104ec4:	eb 41                	jmp    80104f07 <fetchstr+0x60>
80104ec6:	8b 55 08             	mov    0x8(%ebp),%edx
80104ec9:	8b 45 0c             	mov    0xc(%ebp),%eax
80104ecc:	89 10                	mov    %edx,(%eax)
80104ece:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104ed1:	8b 00                	mov    (%eax),%eax
80104ed3:	89 45 ec             	mov    %eax,-0x14(%ebp)
80104ed6:	8b 45 0c             	mov    0xc(%ebp),%eax
80104ed9:	8b 00                	mov    (%eax),%eax
80104edb:	89 45 f4             	mov    %eax,-0xc(%ebp)
80104ede:	eb 1a                	jmp    80104efa <fetchstr+0x53>
80104ee0:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104ee3:	0f b6 00             	movzbl (%eax),%eax
80104ee6:	84 c0                	test   %al,%al
80104ee8:	75 0c                	jne    80104ef6 <fetchstr+0x4f>
80104eea:	8b 45 0c             	mov    0xc(%ebp),%eax
80104eed:	8b 10                	mov    (%eax),%edx
80104eef:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104ef2:	29 d0                	sub    %edx,%eax
80104ef4:	eb 11                	jmp    80104f07 <fetchstr+0x60>
80104ef6:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80104efa:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104efd:	3b 45 ec             	cmp    -0x14(%ebp),%eax
80104f00:	72 de                	jb     80104ee0 <fetchstr+0x39>
80104f02:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104f07:	c9                   	leave  
80104f08:	c3                   	ret    

80104f09 <argint>:
80104f09:	55                   	push   %ebp
80104f0a:	89 e5                	mov    %esp,%ebp
80104f0c:	83 ec 08             	sub    $0x8,%esp
80104f0f:	e8 1c eb ff ff       	call   80103a30 <myproc>
80104f14:	8b 40 18             	mov    0x18(%eax),%eax
80104f17:	8b 50 44             	mov    0x44(%eax),%edx
80104f1a:	8b 45 08             	mov    0x8(%ebp),%eax
80104f1d:	c1 e0 02             	shl    $0x2,%eax
80104f20:	01 d0                	add    %edx,%eax
80104f22:	83 c0 04             	add    $0x4,%eax
80104f25:	83 ec 08             	sub    $0x8,%esp
80104f28:	ff 75 0c             	push   0xc(%ebp)
80104f2b:	50                   	push   %eax
80104f2c:	e8 37 ff ff ff       	call   80104e68 <fetchint>
80104f31:	83 c4 10             	add    $0x10,%esp
80104f34:	c9                   	leave  
80104f35:	c3                   	ret    

80104f36 <argptr>:
80104f36:	55                   	push   %ebp
80104f37:	89 e5                	mov    %esp,%ebp
80104f39:	83 ec 18             	sub    $0x18,%esp
80104f3c:	e8 ef ea ff ff       	call   80103a30 <myproc>
80104f41:	89 45 f4             	mov    %eax,-0xc(%ebp)
80104f44:	83 ec 08             	sub    $0x8,%esp
80104f47:	8d 45 f0             	lea    -0x10(%ebp),%eax
80104f4a:	50                   	push   %eax
80104f4b:	ff 75 08             	push   0x8(%ebp)
80104f4e:	e8 b6 ff ff ff       	call   80104f09 <argint>
80104f53:	83 c4 10             	add    $0x10,%esp
80104f56:	85 c0                	test   %eax,%eax
80104f58:	79 07                	jns    80104f61 <argptr+0x2b>
80104f5a:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104f5f:	eb 3b                	jmp    80104f9c <argptr+0x66>
80104f61:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
80104f65:	78 1f                	js     80104f86 <argptr+0x50>
80104f67:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104f6a:	8b 00                	mov    (%eax),%eax
80104f6c:	8b 55 f0             	mov    -0x10(%ebp),%edx
80104f6f:	39 d0                	cmp    %edx,%eax
80104f71:	76 13                	jbe    80104f86 <argptr+0x50>
80104f73:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104f76:	89 c2                	mov    %eax,%edx
80104f78:	8b 45 10             	mov    0x10(%ebp),%eax
80104f7b:	01 c2                	add    %eax,%edx
80104f7d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104f80:	8b 00                	mov    (%eax),%eax
80104f82:	39 c2                	cmp    %eax,%edx
80104f84:	76 07                	jbe    80104f8d <argptr+0x57>
80104f86:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104f8b:	eb 0f                	jmp    80104f9c <argptr+0x66>
80104f8d:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104f90:	89 c2                	mov    %eax,%edx
80104f92:	8b 45 0c             	mov    0xc(%ebp),%eax
80104f95:	89 10                	mov    %edx,(%eax)
80104f97:	b8 00 00 00 00       	mov    $0x0,%eax
80104f9c:	c9                   	leave  
80104f9d:	c3                   	ret    

80104f9e <argstr>:
80104f9e:	55                   	push   %ebp
80104f9f:	89 e5                	mov    %esp,%ebp
80104fa1:	83 ec 18             	sub    $0x18,%esp
80104fa4:	83 ec 08             	sub    $0x8,%esp
80104fa7:	8d 45 f4             	lea    -0xc(%ebp),%eax
80104faa:	50                   	push   %eax
80104fab:	ff 75 08             	push   0x8(%ebp)
80104fae:	e8 56 ff ff ff       	call   80104f09 <argint>
80104fb3:	83 c4 10             	add    $0x10,%esp
80104fb6:	85 c0                	test   %eax,%eax
80104fb8:	79 07                	jns    80104fc1 <argstr+0x23>
80104fba:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104fbf:	eb 12                	jmp    80104fd3 <argstr+0x35>
80104fc1:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104fc4:	83 ec 08             	sub    $0x8,%esp
80104fc7:	ff 75 0c             	push   0xc(%ebp)
80104fca:	50                   	push   %eax
80104fcb:	e8 d7 fe ff ff       	call   80104ea7 <fetchstr>
80104fd0:	83 c4 10             	add    $0x10,%esp
80104fd3:	c9                   	leave  
80104fd4:	c3                   	ret    

80104fd5 <syscall>:
80104fd5:	55                   	push   %ebp
80104fd6:	89 e5                	mov    %esp,%ebp
80104fd8:	83 ec 18             	sub    $0x18,%esp
80104fdb:	e8 50 ea ff ff       	call   80103a30 <myproc>
80104fe0:	89 45 f4             	mov    %eax,-0xc(%ebp)
80104fe3:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104fe6:	8b 40 18             	mov    0x18(%eax),%eax
80104fe9:	8b 40 1c             	mov    0x1c(%eax),%eax
80104fec:	89 45 f0             	mov    %eax,-0x10(%ebp)
80104fef:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80104ff3:	7e 2f                	jle    80105024 <syscall+0x4f>
80104ff5:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104ff8:	83 f8 17             	cmp    $0x17,%eax
80104ffb:	77 27                	ja     80105024 <syscall+0x4f>
80104ffd:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105000:	8b 04 85 20 f0 10 80 	mov    -0x7fef0fe0(,%eax,4),%eax
80105007:	85 c0                	test   %eax,%eax
80105009:	74 19                	je     80105024 <syscall+0x4f>
8010500b:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010500e:	8b 04 85 20 f0 10 80 	mov    -0x7fef0fe0(,%eax,4),%eax
80105015:	ff d0                	call   *%eax
80105017:	89 c2                	mov    %eax,%edx
80105019:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010501c:	8b 40 18             	mov    0x18(%eax),%eax
8010501f:	89 50 1c             	mov    %edx,0x1c(%eax)
80105022:	eb 2c                	jmp    80105050 <syscall+0x7b>
80105024:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105027:	8d 50 6c             	lea    0x6c(%eax),%edx
8010502a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010502d:	8b 40 10             	mov    0x10(%eax),%eax
80105030:	ff 75 f0             	push   -0x10(%ebp)
80105033:	52                   	push   %edx
80105034:	50                   	push   %eax
80105035:	68 18 a6 10 80       	push   $0x8010a618
8010503a:	e8 b5 b3 ff ff       	call   801003f4 <cprintf>
8010503f:	83 c4 10             	add    $0x10,%esp
80105042:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105045:	8b 40 18             	mov    0x18(%eax),%eax
80105048:	c7 40 1c ff ff ff ff 	movl   $0xffffffff,0x1c(%eax)
8010504f:	90                   	nop
80105050:	90                   	nop
80105051:	c9                   	leave  
80105052:	c3                   	ret    

80105053 <argfd>:
80105053:	55                   	push   %ebp
80105054:	89 e5                	mov    %esp,%ebp
80105056:	83 ec 18             	sub    $0x18,%esp
80105059:	83 ec 08             	sub    $0x8,%esp
8010505c:	8d 45 f0             	lea    -0x10(%ebp),%eax
8010505f:	50                   	push   %eax
80105060:	ff 75 08             	push   0x8(%ebp)
80105063:	e8 a1 fe ff ff       	call   80104f09 <argint>
80105068:	83 c4 10             	add    $0x10,%esp
8010506b:	85 c0                	test   %eax,%eax
8010506d:	79 07                	jns    80105076 <argfd+0x23>
8010506f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105074:	eb 4f                	jmp    801050c5 <argfd+0x72>
80105076:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105079:	85 c0                	test   %eax,%eax
8010507b:	78 20                	js     8010509d <argfd+0x4a>
8010507d:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105080:	83 f8 0f             	cmp    $0xf,%eax
80105083:	7f 18                	jg     8010509d <argfd+0x4a>
80105085:	e8 a6 e9 ff ff       	call   80103a30 <myproc>
8010508a:	8b 55 f0             	mov    -0x10(%ebp),%edx
8010508d:	83 c2 08             	add    $0x8,%edx
80105090:	8b 44 90 08          	mov    0x8(%eax,%edx,4),%eax
80105094:	89 45 f4             	mov    %eax,-0xc(%ebp)
80105097:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
8010509b:	75 07                	jne    801050a4 <argfd+0x51>
8010509d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801050a2:	eb 21                	jmp    801050c5 <argfd+0x72>
801050a4:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
801050a8:	74 08                	je     801050b2 <argfd+0x5f>
801050aa:	8b 55 f0             	mov    -0x10(%ebp),%edx
801050ad:	8b 45 0c             	mov    0xc(%ebp),%eax
801050b0:	89 10                	mov    %edx,(%eax)
801050b2:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
801050b6:	74 08                	je     801050c0 <argfd+0x6d>
801050b8:	8b 45 10             	mov    0x10(%ebp),%eax
801050bb:	8b 55 f4             	mov    -0xc(%ebp),%edx
801050be:	89 10                	mov    %edx,(%eax)
801050c0:	b8 00 00 00 00       	mov    $0x0,%eax
801050c5:	c9                   	leave  
801050c6:	c3                   	ret    

801050c7 <fdalloc>:
801050c7:	55                   	push   %ebp
801050c8:	89 e5                	mov    %esp,%ebp
801050ca:	83 ec 18             	sub    $0x18,%esp
801050cd:	e8 5e e9 ff ff       	call   80103a30 <myproc>
801050d2:	89 45 f0             	mov    %eax,-0x10(%ebp)
801050d5:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
801050dc:	eb 2a                	jmp    80105108 <fdalloc+0x41>
801050de:	8b 45 f0             	mov    -0x10(%ebp),%eax
801050e1:	8b 55 f4             	mov    -0xc(%ebp),%edx
801050e4:	83 c2 08             	add    $0x8,%edx
801050e7:	8b 44 90 08          	mov    0x8(%eax,%edx,4),%eax
801050eb:	85 c0                	test   %eax,%eax
801050ed:	75 15                	jne    80105104 <fdalloc+0x3d>
801050ef:	8b 45 f0             	mov    -0x10(%ebp),%eax
801050f2:	8b 55 f4             	mov    -0xc(%ebp),%edx
801050f5:	8d 4a 08             	lea    0x8(%edx),%ecx
801050f8:	8b 55 08             	mov    0x8(%ebp),%edx
801050fb:	89 54 88 08          	mov    %edx,0x8(%eax,%ecx,4)
801050ff:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105102:	eb 0f                	jmp    80105113 <fdalloc+0x4c>
80105104:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80105108:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
8010510c:	7e d0                	jle    801050de <fdalloc+0x17>
8010510e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105113:	c9                   	leave  
80105114:	c3                   	ret    

80105115 <sys_dup>:
80105115:	55                   	push   %ebp
80105116:	89 e5                	mov    %esp,%ebp
80105118:	83 ec 18             	sub    $0x18,%esp
8010511b:	83 ec 04             	sub    $0x4,%esp
8010511e:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105121:	50                   	push   %eax
80105122:	6a 00                	push   $0x0
80105124:	6a 00                	push   $0x0
80105126:	e8 28 ff ff ff       	call   80105053 <argfd>
8010512b:	83 c4 10             	add    $0x10,%esp
8010512e:	85 c0                	test   %eax,%eax
80105130:	79 07                	jns    80105139 <sys_dup+0x24>
80105132:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105137:	eb 31                	jmp    8010516a <sys_dup+0x55>
80105139:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010513c:	83 ec 0c             	sub    $0xc,%esp
8010513f:	50                   	push   %eax
80105140:	e8 82 ff ff ff       	call   801050c7 <fdalloc>
80105145:	83 c4 10             	add    $0x10,%esp
80105148:	89 45 f4             	mov    %eax,-0xc(%ebp)
8010514b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
8010514f:	79 07                	jns    80105158 <sys_dup+0x43>
80105151:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105156:	eb 12                	jmp    8010516a <sys_dup+0x55>
80105158:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010515b:	83 ec 0c             	sub    $0xc,%esp
8010515e:	50                   	push   %eax
8010515f:	e8 e6 be ff ff       	call   8010104a <filedup>
80105164:	83 c4 10             	add    $0x10,%esp
80105167:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010516a:	c9                   	leave  
8010516b:	c3                   	ret    

8010516c <sys_read>:
8010516c:	55                   	push   %ebp
8010516d:	89 e5                	mov    %esp,%ebp
8010516f:	83 ec 18             	sub    $0x18,%esp
80105172:	83 ec 04             	sub    $0x4,%esp
80105175:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105178:	50                   	push   %eax
80105179:	6a 00                	push   $0x0
8010517b:	6a 00                	push   $0x0
8010517d:	e8 d1 fe ff ff       	call   80105053 <argfd>
80105182:	83 c4 10             	add    $0x10,%esp
80105185:	85 c0                	test   %eax,%eax
80105187:	78 2e                	js     801051b7 <sys_read+0x4b>
80105189:	83 ec 08             	sub    $0x8,%esp
8010518c:	8d 45 f0             	lea    -0x10(%ebp),%eax
8010518f:	50                   	push   %eax
80105190:	6a 02                	push   $0x2
80105192:	e8 72 fd ff ff       	call   80104f09 <argint>
80105197:	83 c4 10             	add    $0x10,%esp
8010519a:	85 c0                	test   %eax,%eax
8010519c:	78 19                	js     801051b7 <sys_read+0x4b>
8010519e:	8b 45 f0             	mov    -0x10(%ebp),%eax
801051a1:	83 ec 04             	sub    $0x4,%esp
801051a4:	50                   	push   %eax
801051a5:	8d 45 ec             	lea    -0x14(%ebp),%eax
801051a8:	50                   	push   %eax
801051a9:	6a 01                	push   $0x1
801051ab:	e8 86 fd ff ff       	call   80104f36 <argptr>
801051b0:	83 c4 10             	add    $0x10,%esp
801051b3:	85 c0                	test   %eax,%eax
801051b5:	79 07                	jns    801051be <sys_read+0x52>
801051b7:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801051bc:	eb 17                	jmp    801051d5 <sys_read+0x69>
801051be:	8b 4d f0             	mov    -0x10(%ebp),%ecx
801051c1:	8b 55 ec             	mov    -0x14(%ebp),%edx
801051c4:	8b 45 f4             	mov    -0xc(%ebp),%eax
801051c7:	83 ec 04             	sub    $0x4,%esp
801051ca:	51                   	push   %ecx
801051cb:	52                   	push   %edx
801051cc:	50                   	push   %eax
801051cd:	e8 08 c0 ff ff       	call   801011da <fileread>
801051d2:	83 c4 10             	add    $0x10,%esp
801051d5:	c9                   	leave  
801051d6:	c3                   	ret    

801051d7 <sys_write>:
801051d7:	55                   	push   %ebp
801051d8:	89 e5                	mov    %esp,%ebp
801051da:	83 ec 18             	sub    $0x18,%esp
801051dd:	83 ec 04             	sub    $0x4,%esp
801051e0:	8d 45 f4             	lea    -0xc(%ebp),%eax
801051e3:	50                   	push   %eax
801051e4:	6a 00                	push   $0x0
801051e6:	6a 00                	push   $0x0
801051e8:	e8 66 fe ff ff       	call   80105053 <argfd>
801051ed:	83 c4 10             	add    $0x10,%esp
801051f0:	85 c0                	test   %eax,%eax
801051f2:	78 2e                	js     80105222 <sys_write+0x4b>
801051f4:	83 ec 08             	sub    $0x8,%esp
801051f7:	8d 45 f0             	lea    -0x10(%ebp),%eax
801051fa:	50                   	push   %eax
801051fb:	6a 02                	push   $0x2
801051fd:	e8 07 fd ff ff       	call   80104f09 <argint>
80105202:	83 c4 10             	add    $0x10,%esp
80105205:	85 c0                	test   %eax,%eax
80105207:	78 19                	js     80105222 <sys_write+0x4b>
80105209:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010520c:	83 ec 04             	sub    $0x4,%esp
8010520f:	50                   	push   %eax
80105210:	8d 45 ec             	lea    -0x14(%ebp),%eax
80105213:	50                   	push   %eax
80105214:	6a 01                	push   $0x1
80105216:	e8 1b fd ff ff       	call   80104f36 <argptr>
8010521b:	83 c4 10             	add    $0x10,%esp
8010521e:	85 c0                	test   %eax,%eax
80105220:	79 07                	jns    80105229 <sys_write+0x52>
80105222:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105227:	eb 17                	jmp    80105240 <sys_write+0x69>
80105229:	8b 4d f0             	mov    -0x10(%ebp),%ecx
8010522c:	8b 55 ec             	mov    -0x14(%ebp),%edx
8010522f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105232:	83 ec 04             	sub    $0x4,%esp
80105235:	51                   	push   %ecx
80105236:	52                   	push   %edx
80105237:	50                   	push   %eax
80105238:	e8 55 c0 ff ff       	call   80101292 <filewrite>
8010523d:	83 c4 10             	add    $0x10,%esp
80105240:	c9                   	leave  
80105241:	c3                   	ret    

80105242 <sys_close>:
80105242:	55                   	push   %ebp
80105243:	89 e5                	mov    %esp,%ebp
80105245:	83 ec 18             	sub    $0x18,%esp
80105248:	83 ec 04             	sub    $0x4,%esp
8010524b:	8d 45 f0             	lea    -0x10(%ebp),%eax
8010524e:	50                   	push   %eax
8010524f:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105252:	50                   	push   %eax
80105253:	6a 00                	push   $0x0
80105255:	e8 f9 fd ff ff       	call   80105053 <argfd>
8010525a:	83 c4 10             	add    $0x10,%esp
8010525d:	85 c0                	test   %eax,%eax
8010525f:	79 07                	jns    80105268 <sys_close+0x26>
80105261:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105266:	eb 27                	jmp    8010528f <sys_close+0x4d>
80105268:	e8 c3 e7 ff ff       	call   80103a30 <myproc>
8010526d:	8b 55 f4             	mov    -0xc(%ebp),%edx
80105270:	83 c2 08             	add    $0x8,%edx
80105273:	c7 44 90 08 00 00 00 	movl   $0x0,0x8(%eax,%edx,4)
8010527a:	00 
8010527b:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010527e:	83 ec 0c             	sub    $0xc,%esp
80105281:	50                   	push   %eax
80105282:	e8 14 be ff ff       	call   8010109b <fileclose>
80105287:	83 c4 10             	add    $0x10,%esp
8010528a:	b8 00 00 00 00       	mov    $0x0,%eax
8010528f:	c9                   	leave  
80105290:	c3                   	ret    

80105291 <sys_fstat>:
80105291:	55                   	push   %ebp
80105292:	89 e5                	mov    %esp,%ebp
80105294:	83 ec 18             	sub    $0x18,%esp
80105297:	83 ec 04             	sub    $0x4,%esp
8010529a:	8d 45 f4             	lea    -0xc(%ebp),%eax
8010529d:	50                   	push   %eax
8010529e:	6a 00                	push   $0x0
801052a0:	6a 00                	push   $0x0
801052a2:	e8 ac fd ff ff       	call   80105053 <argfd>
801052a7:	83 c4 10             	add    $0x10,%esp
801052aa:	85 c0                	test   %eax,%eax
801052ac:	78 17                	js     801052c5 <sys_fstat+0x34>
801052ae:	83 ec 04             	sub    $0x4,%esp
801052b1:	6a 14                	push   $0x14
801052b3:	8d 45 f0             	lea    -0x10(%ebp),%eax
801052b6:	50                   	push   %eax
801052b7:	6a 01                	push   $0x1
801052b9:	e8 78 fc ff ff       	call   80104f36 <argptr>
801052be:	83 c4 10             	add    $0x10,%esp
801052c1:	85 c0                	test   %eax,%eax
801052c3:	79 07                	jns    801052cc <sys_fstat+0x3b>
801052c5:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801052ca:	eb 13                	jmp    801052df <sys_fstat+0x4e>
801052cc:	8b 55 f0             	mov    -0x10(%ebp),%edx
801052cf:	8b 45 f4             	mov    -0xc(%ebp),%eax
801052d2:	83 ec 08             	sub    $0x8,%esp
801052d5:	52                   	push   %edx
801052d6:	50                   	push   %eax
801052d7:	e8 a7 be ff ff       	call   80101183 <filestat>
801052dc:	83 c4 10             	add    $0x10,%esp
801052df:	c9                   	leave  
801052e0:	c3                   	ret    

801052e1 <sys_link>:
801052e1:	55                   	push   %ebp
801052e2:	89 e5                	mov    %esp,%ebp
801052e4:	83 ec 28             	sub    $0x28,%esp
801052e7:	83 ec 08             	sub    $0x8,%esp
801052ea:	8d 45 d8             	lea    -0x28(%ebp),%eax
801052ed:	50                   	push   %eax
801052ee:	6a 00                	push   $0x0
801052f0:	e8 a9 fc ff ff       	call   80104f9e <argstr>
801052f5:	83 c4 10             	add    $0x10,%esp
801052f8:	85 c0                	test   %eax,%eax
801052fa:	78 15                	js     80105311 <sys_link+0x30>
801052fc:	83 ec 08             	sub    $0x8,%esp
801052ff:	8d 45 dc             	lea    -0x24(%ebp),%eax
80105302:	50                   	push   %eax
80105303:	6a 01                	push   $0x1
80105305:	e8 94 fc ff ff       	call   80104f9e <argstr>
8010530a:	83 c4 10             	add    $0x10,%esp
8010530d:	85 c0                	test   %eax,%eax
8010530f:	79 0a                	jns    8010531b <sys_link+0x3a>
80105311:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105316:	e9 68 01 00 00       	jmp    80105483 <sys_link+0x1a2>
8010531b:	e8 1c dd ff ff       	call   8010303c <begin_op>
80105320:	8b 45 d8             	mov    -0x28(%ebp),%eax
80105323:	83 ec 0c             	sub    $0xc,%esp
80105326:	50                   	push   %eax
80105327:	e8 f1 d1 ff ff       	call   8010251d <namei>
8010532c:	83 c4 10             	add    $0x10,%esp
8010532f:	89 45 f4             	mov    %eax,-0xc(%ebp)
80105332:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80105336:	75 0f                	jne    80105347 <sys_link+0x66>
80105338:	e8 8b dd ff ff       	call   801030c8 <end_op>
8010533d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105342:	e9 3c 01 00 00       	jmp    80105483 <sys_link+0x1a2>
80105347:	83 ec 0c             	sub    $0xc,%esp
8010534a:	ff 75 f4             	push   -0xc(%ebp)
8010534d:	e8 98 c6 ff ff       	call   801019ea <ilock>
80105352:	83 c4 10             	add    $0x10,%esp
80105355:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105358:	0f b7 40 50          	movzwl 0x50(%eax),%eax
8010535c:	66 83 f8 01          	cmp    $0x1,%ax
80105360:	75 1d                	jne    8010537f <sys_link+0x9e>
80105362:	83 ec 0c             	sub    $0xc,%esp
80105365:	ff 75 f4             	push   -0xc(%ebp)
80105368:	e8 ae c8 ff ff       	call   80101c1b <iunlockput>
8010536d:	83 c4 10             	add    $0x10,%esp
80105370:	e8 53 dd ff ff       	call   801030c8 <end_op>
80105375:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010537a:	e9 04 01 00 00       	jmp    80105483 <sys_link+0x1a2>
8010537f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105382:	0f b7 40 56          	movzwl 0x56(%eax),%eax
80105386:	83 c0 01             	add    $0x1,%eax
80105389:	89 c2                	mov    %eax,%edx
8010538b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010538e:	66 89 50 56          	mov    %dx,0x56(%eax)
80105392:	83 ec 0c             	sub    $0xc,%esp
80105395:	ff 75 f4             	push   -0xc(%ebp)
80105398:	e8 70 c4 ff ff       	call   8010180d <iupdate>
8010539d:	83 c4 10             	add    $0x10,%esp
801053a0:	83 ec 0c             	sub    $0xc,%esp
801053a3:	ff 75 f4             	push   -0xc(%ebp)
801053a6:	e8 52 c7 ff ff       	call   80101afd <iunlock>
801053ab:	83 c4 10             	add    $0x10,%esp
801053ae:	8b 45 dc             	mov    -0x24(%ebp),%eax
801053b1:	83 ec 08             	sub    $0x8,%esp
801053b4:	8d 55 e2             	lea    -0x1e(%ebp),%edx
801053b7:	52                   	push   %edx
801053b8:	50                   	push   %eax
801053b9:	e8 7b d1 ff ff       	call   80102539 <nameiparent>
801053be:	83 c4 10             	add    $0x10,%esp
801053c1:	89 45 f0             	mov    %eax,-0x10(%ebp)
801053c4:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
801053c8:	74 71                	je     8010543b <sys_link+0x15a>
801053ca:	83 ec 0c             	sub    $0xc,%esp
801053cd:	ff 75 f0             	push   -0x10(%ebp)
801053d0:	e8 15 c6 ff ff       	call   801019ea <ilock>
801053d5:	83 c4 10             	add    $0x10,%esp
801053d8:	8b 45 f0             	mov    -0x10(%ebp),%eax
801053db:	8b 10                	mov    (%eax),%edx
801053dd:	8b 45 f4             	mov    -0xc(%ebp),%eax
801053e0:	8b 00                	mov    (%eax),%eax
801053e2:	39 c2                	cmp    %eax,%edx
801053e4:	75 1d                	jne    80105403 <sys_link+0x122>
801053e6:	8b 45 f4             	mov    -0xc(%ebp),%eax
801053e9:	8b 40 04             	mov    0x4(%eax),%eax
801053ec:	83 ec 04             	sub    $0x4,%esp
801053ef:	50                   	push   %eax
801053f0:	8d 45 e2             	lea    -0x1e(%ebp),%eax
801053f3:	50                   	push   %eax
801053f4:	ff 75 f0             	push   -0x10(%ebp)
801053f7:	e8 8a ce ff ff       	call   80102286 <dirlink>
801053fc:	83 c4 10             	add    $0x10,%esp
801053ff:	85 c0                	test   %eax,%eax
80105401:	79 10                	jns    80105413 <sys_link+0x132>
80105403:	83 ec 0c             	sub    $0xc,%esp
80105406:	ff 75 f0             	push   -0x10(%ebp)
80105409:	e8 0d c8 ff ff       	call   80101c1b <iunlockput>
8010540e:	83 c4 10             	add    $0x10,%esp
80105411:	eb 29                	jmp    8010543c <sys_link+0x15b>
80105413:	83 ec 0c             	sub    $0xc,%esp
80105416:	ff 75 f0             	push   -0x10(%ebp)
80105419:	e8 fd c7 ff ff       	call   80101c1b <iunlockput>
8010541e:	83 c4 10             	add    $0x10,%esp
80105421:	83 ec 0c             	sub    $0xc,%esp
80105424:	ff 75 f4             	push   -0xc(%ebp)
80105427:	e8 1f c7 ff ff       	call   80101b4b <iput>
8010542c:	83 c4 10             	add    $0x10,%esp
8010542f:	e8 94 dc ff ff       	call   801030c8 <end_op>
80105434:	b8 00 00 00 00       	mov    $0x0,%eax
80105439:	eb 48                	jmp    80105483 <sys_link+0x1a2>
8010543b:	90                   	nop
8010543c:	83 ec 0c             	sub    $0xc,%esp
8010543f:	ff 75 f4             	push   -0xc(%ebp)
80105442:	e8 a3 c5 ff ff       	call   801019ea <ilock>
80105447:	83 c4 10             	add    $0x10,%esp
8010544a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010544d:	0f b7 40 56          	movzwl 0x56(%eax),%eax
80105451:	83 e8 01             	sub    $0x1,%eax
80105454:	89 c2                	mov    %eax,%edx
80105456:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105459:	66 89 50 56          	mov    %dx,0x56(%eax)
8010545d:	83 ec 0c             	sub    $0xc,%esp
80105460:	ff 75 f4             	push   -0xc(%ebp)
80105463:	e8 a5 c3 ff ff       	call   8010180d <iupdate>
80105468:	83 c4 10             	add    $0x10,%esp
8010546b:	83 ec 0c             	sub    $0xc,%esp
8010546e:	ff 75 f4             	push   -0xc(%ebp)
80105471:	e8 a5 c7 ff ff       	call   80101c1b <iunlockput>
80105476:	83 c4 10             	add    $0x10,%esp
80105479:	e8 4a dc ff ff       	call   801030c8 <end_op>
8010547e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105483:	c9                   	leave  
80105484:	c3                   	ret    

80105485 <isdirempty>:
80105485:	55                   	push   %ebp
80105486:	89 e5                	mov    %esp,%ebp
80105488:	83 ec 28             	sub    $0x28,%esp
8010548b:	c7 45 f4 20 00 00 00 	movl   $0x20,-0xc(%ebp)
80105492:	eb 40                	jmp    801054d4 <isdirempty+0x4f>
80105494:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105497:	6a 10                	push   $0x10
80105499:	50                   	push   %eax
8010549a:	8d 45 e4             	lea    -0x1c(%ebp),%eax
8010549d:	50                   	push   %eax
8010549e:	ff 75 08             	push   0x8(%ebp)
801054a1:	e8 30 ca ff ff       	call   80101ed6 <readi>
801054a6:	83 c4 10             	add    $0x10,%esp
801054a9:	83 f8 10             	cmp    $0x10,%eax
801054ac:	74 0d                	je     801054bb <isdirempty+0x36>
801054ae:	83 ec 0c             	sub    $0xc,%esp
801054b1:	68 34 a6 10 80       	push   $0x8010a634
801054b6:	e8 ee b0 ff ff       	call   801005a9 <panic>
801054bb:	0f b7 45 e4          	movzwl -0x1c(%ebp),%eax
801054bf:	66 85 c0             	test   %ax,%ax
801054c2:	74 07                	je     801054cb <isdirempty+0x46>
801054c4:	b8 00 00 00 00       	mov    $0x0,%eax
801054c9:	eb 1b                	jmp    801054e6 <isdirempty+0x61>
801054cb:	8b 45 f4             	mov    -0xc(%ebp),%eax
801054ce:	83 c0 10             	add    $0x10,%eax
801054d1:	89 45 f4             	mov    %eax,-0xc(%ebp)
801054d4:	8b 45 08             	mov    0x8(%ebp),%eax
801054d7:	8b 50 58             	mov    0x58(%eax),%edx
801054da:	8b 45 f4             	mov    -0xc(%ebp),%eax
801054dd:	39 c2                	cmp    %eax,%edx
801054df:	77 b3                	ja     80105494 <isdirempty+0xf>
801054e1:	b8 01 00 00 00       	mov    $0x1,%eax
801054e6:	c9                   	leave  
801054e7:	c3                   	ret    

801054e8 <sys_unlink>:
801054e8:	55                   	push   %ebp
801054e9:	89 e5                	mov    %esp,%ebp
801054eb:	83 ec 38             	sub    $0x38,%esp
801054ee:	83 ec 08             	sub    $0x8,%esp
801054f1:	8d 45 cc             	lea    -0x34(%ebp),%eax
801054f4:	50                   	push   %eax
801054f5:	6a 00                	push   $0x0
801054f7:	e8 a2 fa ff ff       	call   80104f9e <argstr>
801054fc:	83 c4 10             	add    $0x10,%esp
801054ff:	85 c0                	test   %eax,%eax
80105501:	79 0a                	jns    8010550d <sys_unlink+0x25>
80105503:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105508:	e9 bf 01 00 00       	jmp    801056cc <sys_unlink+0x1e4>
8010550d:	e8 2a db ff ff       	call   8010303c <begin_op>
80105512:	8b 45 cc             	mov    -0x34(%ebp),%eax
80105515:	83 ec 08             	sub    $0x8,%esp
80105518:	8d 55 d2             	lea    -0x2e(%ebp),%edx
8010551b:	52                   	push   %edx
8010551c:	50                   	push   %eax
8010551d:	e8 17 d0 ff ff       	call   80102539 <nameiparent>
80105522:	83 c4 10             	add    $0x10,%esp
80105525:	89 45 f4             	mov    %eax,-0xc(%ebp)
80105528:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
8010552c:	75 0f                	jne    8010553d <sys_unlink+0x55>
8010552e:	e8 95 db ff ff       	call   801030c8 <end_op>
80105533:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105538:	e9 8f 01 00 00       	jmp    801056cc <sys_unlink+0x1e4>
8010553d:	83 ec 0c             	sub    $0xc,%esp
80105540:	ff 75 f4             	push   -0xc(%ebp)
80105543:	e8 a2 c4 ff ff       	call   801019ea <ilock>
80105548:	83 c4 10             	add    $0x10,%esp
8010554b:	83 ec 08             	sub    $0x8,%esp
8010554e:	68 46 a6 10 80       	push   $0x8010a646
80105553:	8d 45 d2             	lea    -0x2e(%ebp),%eax
80105556:	50                   	push   %eax
80105557:	e8 55 cc ff ff       	call   801021b1 <namecmp>
8010555c:	83 c4 10             	add    $0x10,%esp
8010555f:	85 c0                	test   %eax,%eax
80105561:	0f 84 49 01 00 00    	je     801056b0 <sys_unlink+0x1c8>
80105567:	83 ec 08             	sub    $0x8,%esp
8010556a:	68 48 a6 10 80       	push   $0x8010a648
8010556f:	8d 45 d2             	lea    -0x2e(%ebp),%eax
80105572:	50                   	push   %eax
80105573:	e8 39 cc ff ff       	call   801021b1 <namecmp>
80105578:	83 c4 10             	add    $0x10,%esp
8010557b:	85 c0                	test   %eax,%eax
8010557d:	0f 84 2d 01 00 00    	je     801056b0 <sys_unlink+0x1c8>
80105583:	83 ec 04             	sub    $0x4,%esp
80105586:	8d 45 c8             	lea    -0x38(%ebp),%eax
80105589:	50                   	push   %eax
8010558a:	8d 45 d2             	lea    -0x2e(%ebp),%eax
8010558d:	50                   	push   %eax
8010558e:	ff 75 f4             	push   -0xc(%ebp)
80105591:	e8 36 cc ff ff       	call   801021cc <dirlookup>
80105596:	83 c4 10             	add    $0x10,%esp
80105599:	89 45 f0             	mov    %eax,-0x10(%ebp)
8010559c:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
801055a0:	0f 84 0d 01 00 00    	je     801056b3 <sys_unlink+0x1cb>
801055a6:	83 ec 0c             	sub    $0xc,%esp
801055a9:	ff 75 f0             	push   -0x10(%ebp)
801055ac:	e8 39 c4 ff ff       	call   801019ea <ilock>
801055b1:	83 c4 10             	add    $0x10,%esp
801055b4:	8b 45 f0             	mov    -0x10(%ebp),%eax
801055b7:	0f b7 40 56          	movzwl 0x56(%eax),%eax
801055bb:	66 85 c0             	test   %ax,%ax
801055be:	7f 0d                	jg     801055cd <sys_unlink+0xe5>
801055c0:	83 ec 0c             	sub    $0xc,%esp
801055c3:	68 4b a6 10 80       	push   $0x8010a64b
801055c8:	e8 dc af ff ff       	call   801005a9 <panic>
801055cd:	8b 45 f0             	mov    -0x10(%ebp),%eax
801055d0:	0f b7 40 50          	movzwl 0x50(%eax),%eax
801055d4:	66 83 f8 01          	cmp    $0x1,%ax
801055d8:	75 25                	jne    801055ff <sys_unlink+0x117>
801055da:	83 ec 0c             	sub    $0xc,%esp
801055dd:	ff 75 f0             	push   -0x10(%ebp)
801055e0:	e8 a0 fe ff ff       	call   80105485 <isdirempty>
801055e5:	83 c4 10             	add    $0x10,%esp
801055e8:	85 c0                	test   %eax,%eax
801055ea:	75 13                	jne    801055ff <sys_unlink+0x117>
801055ec:	83 ec 0c             	sub    $0xc,%esp
801055ef:	ff 75 f0             	push   -0x10(%ebp)
801055f2:	e8 24 c6 ff ff       	call   80101c1b <iunlockput>
801055f7:	83 c4 10             	add    $0x10,%esp
801055fa:	e9 b5 00 00 00       	jmp    801056b4 <sys_unlink+0x1cc>
801055ff:	83 ec 04             	sub    $0x4,%esp
80105602:	6a 10                	push   $0x10
80105604:	6a 00                	push   $0x0
80105606:	8d 45 e0             	lea    -0x20(%ebp),%eax
80105609:	50                   	push   %eax
8010560a:	e8 cf f5 ff ff       	call   80104bde <memset>
8010560f:	83 c4 10             	add    $0x10,%esp
80105612:	8b 45 c8             	mov    -0x38(%ebp),%eax
80105615:	6a 10                	push   $0x10
80105617:	50                   	push   %eax
80105618:	8d 45 e0             	lea    -0x20(%ebp),%eax
8010561b:	50                   	push   %eax
8010561c:	ff 75 f4             	push   -0xc(%ebp)
8010561f:	e8 07 ca ff ff       	call   8010202b <writei>
80105624:	83 c4 10             	add    $0x10,%esp
80105627:	83 f8 10             	cmp    $0x10,%eax
8010562a:	74 0d                	je     80105639 <sys_unlink+0x151>
8010562c:	83 ec 0c             	sub    $0xc,%esp
8010562f:	68 5d a6 10 80       	push   $0x8010a65d
80105634:	e8 70 af ff ff       	call   801005a9 <panic>
80105639:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010563c:	0f b7 40 50          	movzwl 0x50(%eax),%eax
80105640:	66 83 f8 01          	cmp    $0x1,%ax
80105644:	75 21                	jne    80105667 <sys_unlink+0x17f>
80105646:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105649:	0f b7 40 56          	movzwl 0x56(%eax),%eax
8010564d:	83 e8 01             	sub    $0x1,%eax
80105650:	89 c2                	mov    %eax,%edx
80105652:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105655:	66 89 50 56          	mov    %dx,0x56(%eax)
80105659:	83 ec 0c             	sub    $0xc,%esp
8010565c:	ff 75 f4             	push   -0xc(%ebp)
8010565f:	e8 a9 c1 ff ff       	call   8010180d <iupdate>
80105664:	83 c4 10             	add    $0x10,%esp
80105667:	83 ec 0c             	sub    $0xc,%esp
8010566a:	ff 75 f4             	push   -0xc(%ebp)
8010566d:	e8 a9 c5 ff ff       	call   80101c1b <iunlockput>
80105672:	83 c4 10             	add    $0x10,%esp
80105675:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105678:	0f b7 40 56          	movzwl 0x56(%eax),%eax
8010567c:	83 e8 01             	sub    $0x1,%eax
8010567f:	89 c2                	mov    %eax,%edx
80105681:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105684:	66 89 50 56          	mov    %dx,0x56(%eax)
80105688:	83 ec 0c             	sub    $0xc,%esp
8010568b:	ff 75 f0             	push   -0x10(%ebp)
8010568e:	e8 7a c1 ff ff       	call   8010180d <iupdate>
80105693:	83 c4 10             	add    $0x10,%esp
80105696:	83 ec 0c             	sub    $0xc,%esp
80105699:	ff 75 f0             	push   -0x10(%ebp)
8010569c:	e8 7a c5 ff ff       	call   80101c1b <iunlockput>
801056a1:	83 c4 10             	add    $0x10,%esp
801056a4:	e8 1f da ff ff       	call   801030c8 <end_op>
801056a9:	b8 00 00 00 00       	mov    $0x0,%eax
801056ae:	eb 1c                	jmp    801056cc <sys_unlink+0x1e4>
801056b0:	90                   	nop
801056b1:	eb 01                	jmp    801056b4 <sys_unlink+0x1cc>
801056b3:	90                   	nop
801056b4:	83 ec 0c             	sub    $0xc,%esp
801056b7:	ff 75 f4             	push   -0xc(%ebp)
801056ba:	e8 5c c5 ff ff       	call   80101c1b <iunlockput>
801056bf:	83 c4 10             	add    $0x10,%esp
801056c2:	e8 01 da ff ff       	call   801030c8 <end_op>
801056c7:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801056cc:	c9                   	leave  
801056cd:	c3                   	ret    

801056ce <create>:
801056ce:	55                   	push   %ebp
801056cf:	89 e5                	mov    %esp,%ebp
801056d1:	83 ec 38             	sub    $0x38,%esp
801056d4:	8b 4d 0c             	mov    0xc(%ebp),%ecx
801056d7:	8b 55 10             	mov    0x10(%ebp),%edx
801056da:	8b 45 14             	mov    0x14(%ebp),%eax
801056dd:	66 89 4d d4          	mov    %cx,-0x2c(%ebp)
801056e1:	66 89 55 d0          	mov    %dx,-0x30(%ebp)
801056e5:	66 89 45 cc          	mov    %ax,-0x34(%ebp)
801056e9:	83 ec 08             	sub    $0x8,%esp
801056ec:	8d 45 de             	lea    -0x22(%ebp),%eax
801056ef:	50                   	push   %eax
801056f0:	ff 75 08             	push   0x8(%ebp)
801056f3:	e8 41 ce ff ff       	call   80102539 <nameiparent>
801056f8:	83 c4 10             	add    $0x10,%esp
801056fb:	89 45 f4             	mov    %eax,-0xc(%ebp)
801056fe:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80105702:	75 0a                	jne    8010570e <create+0x40>
80105704:	b8 00 00 00 00       	mov    $0x0,%eax
80105709:	e9 90 01 00 00       	jmp    8010589e <create+0x1d0>
8010570e:	83 ec 0c             	sub    $0xc,%esp
80105711:	ff 75 f4             	push   -0xc(%ebp)
80105714:	e8 d1 c2 ff ff       	call   801019ea <ilock>
80105719:	83 c4 10             	add    $0x10,%esp
8010571c:	83 ec 04             	sub    $0x4,%esp
8010571f:	8d 45 ec             	lea    -0x14(%ebp),%eax
80105722:	50                   	push   %eax
80105723:	8d 45 de             	lea    -0x22(%ebp),%eax
80105726:	50                   	push   %eax
80105727:	ff 75 f4             	push   -0xc(%ebp)
8010572a:	e8 9d ca ff ff       	call   801021cc <dirlookup>
8010572f:	83 c4 10             	add    $0x10,%esp
80105732:	89 45 f0             	mov    %eax,-0x10(%ebp)
80105735:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80105739:	74 50                	je     8010578b <create+0xbd>
8010573b:	83 ec 0c             	sub    $0xc,%esp
8010573e:	ff 75 f4             	push   -0xc(%ebp)
80105741:	e8 d5 c4 ff ff       	call   80101c1b <iunlockput>
80105746:	83 c4 10             	add    $0x10,%esp
80105749:	83 ec 0c             	sub    $0xc,%esp
8010574c:	ff 75 f0             	push   -0x10(%ebp)
8010574f:	e8 96 c2 ff ff       	call   801019ea <ilock>
80105754:	83 c4 10             	add    $0x10,%esp
80105757:	66 83 7d d4 02       	cmpw   $0x2,-0x2c(%ebp)
8010575c:	75 15                	jne    80105773 <create+0xa5>
8010575e:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105761:	0f b7 40 50          	movzwl 0x50(%eax),%eax
80105765:	66 83 f8 02          	cmp    $0x2,%ax
80105769:	75 08                	jne    80105773 <create+0xa5>
8010576b:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010576e:	e9 2b 01 00 00       	jmp    8010589e <create+0x1d0>
80105773:	83 ec 0c             	sub    $0xc,%esp
80105776:	ff 75 f0             	push   -0x10(%ebp)
80105779:	e8 9d c4 ff ff       	call   80101c1b <iunlockput>
8010577e:	83 c4 10             	add    $0x10,%esp
80105781:	b8 00 00 00 00       	mov    $0x0,%eax
80105786:	e9 13 01 00 00       	jmp    8010589e <create+0x1d0>
8010578b:	0f bf 55 d4          	movswl -0x2c(%ebp),%edx
8010578f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105792:	8b 00                	mov    (%eax),%eax
80105794:	83 ec 08             	sub    $0x8,%esp
80105797:	52                   	push   %edx
80105798:	50                   	push   %eax
80105799:	e8 98 bf ff ff       	call   80101736 <ialloc>
8010579e:	83 c4 10             	add    $0x10,%esp
801057a1:	89 45 f0             	mov    %eax,-0x10(%ebp)
801057a4:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
801057a8:	75 0d                	jne    801057b7 <create+0xe9>
801057aa:	83 ec 0c             	sub    $0xc,%esp
801057ad:	68 6c a6 10 80       	push   $0x8010a66c
801057b2:	e8 f2 ad ff ff       	call   801005a9 <panic>
801057b7:	83 ec 0c             	sub    $0xc,%esp
801057ba:	ff 75 f0             	push   -0x10(%ebp)
801057bd:	e8 28 c2 ff ff       	call   801019ea <ilock>
801057c2:	83 c4 10             	add    $0x10,%esp
801057c5:	8b 45 f0             	mov    -0x10(%ebp),%eax
801057c8:	0f b7 55 d0          	movzwl -0x30(%ebp),%edx
801057cc:	66 89 50 52          	mov    %dx,0x52(%eax)
801057d0:	8b 45 f0             	mov    -0x10(%ebp),%eax
801057d3:	0f b7 55 cc          	movzwl -0x34(%ebp),%edx
801057d7:	66 89 50 54          	mov    %dx,0x54(%eax)
801057db:	8b 45 f0             	mov    -0x10(%ebp),%eax
801057de:	66 c7 40 56 01 00    	movw   $0x1,0x56(%eax)
801057e4:	83 ec 0c             	sub    $0xc,%esp
801057e7:	ff 75 f0             	push   -0x10(%ebp)
801057ea:	e8 1e c0 ff ff       	call   8010180d <iupdate>
801057ef:	83 c4 10             	add    $0x10,%esp
801057f2:	66 83 7d d4 01       	cmpw   $0x1,-0x2c(%ebp)
801057f7:	75 6a                	jne    80105863 <create+0x195>
801057f9:	8b 45 f4             	mov    -0xc(%ebp),%eax
801057fc:	0f b7 40 56          	movzwl 0x56(%eax),%eax
80105800:	83 c0 01             	add    $0x1,%eax
80105803:	89 c2                	mov    %eax,%edx
80105805:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105808:	66 89 50 56          	mov    %dx,0x56(%eax)
8010580c:	83 ec 0c             	sub    $0xc,%esp
8010580f:	ff 75 f4             	push   -0xc(%ebp)
80105812:	e8 f6 bf ff ff       	call   8010180d <iupdate>
80105817:	83 c4 10             	add    $0x10,%esp
8010581a:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010581d:	8b 40 04             	mov    0x4(%eax),%eax
80105820:	83 ec 04             	sub    $0x4,%esp
80105823:	50                   	push   %eax
80105824:	68 46 a6 10 80       	push   $0x8010a646
80105829:	ff 75 f0             	push   -0x10(%ebp)
8010582c:	e8 55 ca ff ff       	call   80102286 <dirlink>
80105831:	83 c4 10             	add    $0x10,%esp
80105834:	85 c0                	test   %eax,%eax
80105836:	78 1e                	js     80105856 <create+0x188>
80105838:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010583b:	8b 40 04             	mov    0x4(%eax),%eax
8010583e:	83 ec 04             	sub    $0x4,%esp
80105841:	50                   	push   %eax
80105842:	68 48 a6 10 80       	push   $0x8010a648
80105847:	ff 75 f0             	push   -0x10(%ebp)
8010584a:	e8 37 ca ff ff       	call   80102286 <dirlink>
8010584f:	83 c4 10             	add    $0x10,%esp
80105852:	85 c0                	test   %eax,%eax
80105854:	79 0d                	jns    80105863 <create+0x195>
80105856:	83 ec 0c             	sub    $0xc,%esp
80105859:	68 7b a6 10 80       	push   $0x8010a67b
8010585e:	e8 46 ad ff ff       	call   801005a9 <panic>
80105863:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105866:	8b 40 04             	mov    0x4(%eax),%eax
80105869:	83 ec 04             	sub    $0x4,%esp
8010586c:	50                   	push   %eax
8010586d:	8d 45 de             	lea    -0x22(%ebp),%eax
80105870:	50                   	push   %eax
80105871:	ff 75 f4             	push   -0xc(%ebp)
80105874:	e8 0d ca ff ff       	call   80102286 <dirlink>
80105879:	83 c4 10             	add    $0x10,%esp
8010587c:	85 c0                	test   %eax,%eax
8010587e:	79 0d                	jns    8010588d <create+0x1bf>
80105880:	83 ec 0c             	sub    $0xc,%esp
80105883:	68 87 a6 10 80       	push   $0x8010a687
80105888:	e8 1c ad ff ff       	call   801005a9 <panic>
8010588d:	83 ec 0c             	sub    $0xc,%esp
80105890:	ff 75 f4             	push   -0xc(%ebp)
80105893:	e8 83 c3 ff ff       	call   80101c1b <iunlockput>
80105898:	83 c4 10             	add    $0x10,%esp
8010589b:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010589e:	c9                   	leave  
8010589f:	c3                   	ret    

801058a0 <sys_open>:
801058a0:	55                   	push   %ebp
801058a1:	89 e5                	mov    %esp,%ebp
801058a3:	83 ec 28             	sub    $0x28,%esp
801058a6:	83 ec 08             	sub    $0x8,%esp
801058a9:	8d 45 e8             	lea    -0x18(%ebp),%eax
801058ac:	50                   	push   %eax
801058ad:	6a 00                	push   $0x0
801058af:	e8 ea f6 ff ff       	call   80104f9e <argstr>
801058b4:	83 c4 10             	add    $0x10,%esp
801058b7:	85 c0                	test   %eax,%eax
801058b9:	78 15                	js     801058d0 <sys_open+0x30>
801058bb:	83 ec 08             	sub    $0x8,%esp
801058be:	8d 45 e4             	lea    -0x1c(%ebp),%eax
801058c1:	50                   	push   %eax
801058c2:	6a 01                	push   $0x1
801058c4:	e8 40 f6 ff ff       	call   80104f09 <argint>
801058c9:	83 c4 10             	add    $0x10,%esp
801058cc:	85 c0                	test   %eax,%eax
801058ce:	79 0a                	jns    801058da <sys_open+0x3a>
801058d0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801058d5:	e9 61 01 00 00       	jmp    80105a3b <sys_open+0x19b>
801058da:	e8 5d d7 ff ff       	call   8010303c <begin_op>
801058df:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801058e2:	25 00 02 00 00       	and    $0x200,%eax
801058e7:	85 c0                	test   %eax,%eax
801058e9:	74 2a                	je     80105915 <sys_open+0x75>
801058eb:	8b 45 e8             	mov    -0x18(%ebp),%eax
801058ee:	6a 00                	push   $0x0
801058f0:	6a 00                	push   $0x0
801058f2:	6a 02                	push   $0x2
801058f4:	50                   	push   %eax
801058f5:	e8 d4 fd ff ff       	call   801056ce <create>
801058fa:	83 c4 10             	add    $0x10,%esp
801058fd:	89 45 f4             	mov    %eax,-0xc(%ebp)
80105900:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80105904:	75 75                	jne    8010597b <sys_open+0xdb>
80105906:	e8 bd d7 ff ff       	call   801030c8 <end_op>
8010590b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105910:	e9 26 01 00 00       	jmp    80105a3b <sys_open+0x19b>
80105915:	8b 45 e8             	mov    -0x18(%ebp),%eax
80105918:	83 ec 0c             	sub    $0xc,%esp
8010591b:	50                   	push   %eax
8010591c:	e8 fc cb ff ff       	call   8010251d <namei>
80105921:	83 c4 10             	add    $0x10,%esp
80105924:	89 45 f4             	mov    %eax,-0xc(%ebp)
80105927:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
8010592b:	75 0f                	jne    8010593c <sys_open+0x9c>
8010592d:	e8 96 d7 ff ff       	call   801030c8 <end_op>
80105932:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105937:	e9 ff 00 00 00       	jmp    80105a3b <sys_open+0x19b>
8010593c:	83 ec 0c             	sub    $0xc,%esp
8010593f:	ff 75 f4             	push   -0xc(%ebp)
80105942:	e8 a3 c0 ff ff       	call   801019ea <ilock>
80105947:	83 c4 10             	add    $0x10,%esp
8010594a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010594d:	0f b7 40 50          	movzwl 0x50(%eax),%eax
80105951:	66 83 f8 01          	cmp    $0x1,%ax
80105955:	75 24                	jne    8010597b <sys_open+0xdb>
80105957:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010595a:	85 c0                	test   %eax,%eax
8010595c:	74 1d                	je     8010597b <sys_open+0xdb>
8010595e:	83 ec 0c             	sub    $0xc,%esp
80105961:	ff 75 f4             	push   -0xc(%ebp)
80105964:	e8 b2 c2 ff ff       	call   80101c1b <iunlockput>
80105969:	83 c4 10             	add    $0x10,%esp
8010596c:	e8 57 d7 ff ff       	call   801030c8 <end_op>
80105971:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105976:	e9 c0 00 00 00       	jmp    80105a3b <sys_open+0x19b>
8010597b:	e8 5d b6 ff ff       	call   80100fdd <filealloc>
80105980:	89 45 f0             	mov    %eax,-0x10(%ebp)
80105983:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80105987:	74 17                	je     801059a0 <sys_open+0x100>
80105989:	83 ec 0c             	sub    $0xc,%esp
8010598c:	ff 75 f0             	push   -0x10(%ebp)
8010598f:	e8 33 f7 ff ff       	call   801050c7 <fdalloc>
80105994:	83 c4 10             	add    $0x10,%esp
80105997:	89 45 ec             	mov    %eax,-0x14(%ebp)
8010599a:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
8010599e:	79 2e                	jns    801059ce <sys_open+0x12e>
801059a0:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
801059a4:	74 0e                	je     801059b4 <sys_open+0x114>
801059a6:	83 ec 0c             	sub    $0xc,%esp
801059a9:	ff 75 f0             	push   -0x10(%ebp)
801059ac:	e8 ea b6 ff ff       	call   8010109b <fileclose>
801059b1:	83 c4 10             	add    $0x10,%esp
801059b4:	83 ec 0c             	sub    $0xc,%esp
801059b7:	ff 75 f4             	push   -0xc(%ebp)
801059ba:	e8 5c c2 ff ff       	call   80101c1b <iunlockput>
801059bf:	83 c4 10             	add    $0x10,%esp
801059c2:	e8 01 d7 ff ff       	call   801030c8 <end_op>
801059c7:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801059cc:	eb 6d                	jmp    80105a3b <sys_open+0x19b>
801059ce:	83 ec 0c             	sub    $0xc,%esp
801059d1:	ff 75 f4             	push   -0xc(%ebp)
801059d4:	e8 24 c1 ff ff       	call   80101afd <iunlock>
801059d9:	83 c4 10             	add    $0x10,%esp
801059dc:	e8 e7 d6 ff ff       	call   801030c8 <end_op>
801059e1:	8b 45 f0             	mov    -0x10(%ebp),%eax
801059e4:	c7 00 02 00 00 00    	movl   $0x2,(%eax)
801059ea:	8b 45 f0             	mov    -0x10(%ebp),%eax
801059ed:	8b 55 f4             	mov    -0xc(%ebp),%edx
801059f0:	89 50 10             	mov    %edx,0x10(%eax)
801059f3:	8b 45 f0             	mov    -0x10(%ebp),%eax
801059f6:	c7 40 14 00 00 00 00 	movl   $0x0,0x14(%eax)
801059fd:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80105a00:	83 e0 01             	and    $0x1,%eax
80105a03:	85 c0                	test   %eax,%eax
80105a05:	0f 94 c0             	sete   %al
80105a08:	89 c2                	mov    %eax,%edx
80105a0a:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105a0d:	88 50 08             	mov    %dl,0x8(%eax)
80105a10:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80105a13:	83 e0 01             	and    $0x1,%eax
80105a16:	85 c0                	test   %eax,%eax
80105a18:	75 0a                	jne    80105a24 <sys_open+0x184>
80105a1a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80105a1d:	83 e0 02             	and    $0x2,%eax
80105a20:	85 c0                	test   %eax,%eax
80105a22:	74 07                	je     80105a2b <sys_open+0x18b>
80105a24:	b8 01 00 00 00       	mov    $0x1,%eax
80105a29:	eb 05                	jmp    80105a30 <sys_open+0x190>
80105a2b:	b8 00 00 00 00       	mov    $0x0,%eax
80105a30:	89 c2                	mov    %eax,%edx
80105a32:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105a35:	88 50 09             	mov    %dl,0x9(%eax)
80105a38:	8b 45 ec             	mov    -0x14(%ebp),%eax
80105a3b:	c9                   	leave  
80105a3c:	c3                   	ret    

80105a3d <sys_mkdir>:
80105a3d:	55                   	push   %ebp
80105a3e:	89 e5                	mov    %esp,%ebp
80105a40:	83 ec 18             	sub    $0x18,%esp
80105a43:	e8 f4 d5 ff ff       	call   8010303c <begin_op>
80105a48:	83 ec 08             	sub    $0x8,%esp
80105a4b:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105a4e:	50                   	push   %eax
80105a4f:	6a 00                	push   $0x0
80105a51:	e8 48 f5 ff ff       	call   80104f9e <argstr>
80105a56:	83 c4 10             	add    $0x10,%esp
80105a59:	85 c0                	test   %eax,%eax
80105a5b:	78 1b                	js     80105a78 <sys_mkdir+0x3b>
80105a5d:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105a60:	6a 00                	push   $0x0
80105a62:	6a 00                	push   $0x0
80105a64:	6a 01                	push   $0x1
80105a66:	50                   	push   %eax
80105a67:	e8 62 fc ff ff       	call   801056ce <create>
80105a6c:	83 c4 10             	add    $0x10,%esp
80105a6f:	89 45 f4             	mov    %eax,-0xc(%ebp)
80105a72:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80105a76:	75 0c                	jne    80105a84 <sys_mkdir+0x47>
80105a78:	e8 4b d6 ff ff       	call   801030c8 <end_op>
80105a7d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105a82:	eb 18                	jmp    80105a9c <sys_mkdir+0x5f>
80105a84:	83 ec 0c             	sub    $0xc,%esp
80105a87:	ff 75 f4             	push   -0xc(%ebp)
80105a8a:	e8 8c c1 ff ff       	call   80101c1b <iunlockput>
80105a8f:	83 c4 10             	add    $0x10,%esp
80105a92:	e8 31 d6 ff ff       	call   801030c8 <end_op>
80105a97:	b8 00 00 00 00       	mov    $0x0,%eax
80105a9c:	c9                   	leave  
80105a9d:	c3                   	ret    

80105a9e <sys_mknod>:
80105a9e:	55                   	push   %ebp
80105a9f:	89 e5                	mov    %esp,%ebp
80105aa1:	83 ec 18             	sub    $0x18,%esp
80105aa4:	e8 93 d5 ff ff       	call   8010303c <begin_op>
80105aa9:	83 ec 08             	sub    $0x8,%esp
80105aac:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105aaf:	50                   	push   %eax
80105ab0:	6a 00                	push   $0x0
80105ab2:	e8 e7 f4 ff ff       	call   80104f9e <argstr>
80105ab7:	83 c4 10             	add    $0x10,%esp
80105aba:	85 c0                	test   %eax,%eax
80105abc:	78 4f                	js     80105b0d <sys_mknod+0x6f>
80105abe:	83 ec 08             	sub    $0x8,%esp
80105ac1:	8d 45 ec             	lea    -0x14(%ebp),%eax
80105ac4:	50                   	push   %eax
80105ac5:	6a 01                	push   $0x1
80105ac7:	e8 3d f4 ff ff       	call   80104f09 <argint>
80105acc:	83 c4 10             	add    $0x10,%esp
80105acf:	85 c0                	test   %eax,%eax
80105ad1:	78 3a                	js     80105b0d <sys_mknod+0x6f>
80105ad3:	83 ec 08             	sub    $0x8,%esp
80105ad6:	8d 45 e8             	lea    -0x18(%ebp),%eax
80105ad9:	50                   	push   %eax
80105ada:	6a 02                	push   $0x2
80105adc:	e8 28 f4 ff ff       	call   80104f09 <argint>
80105ae1:	83 c4 10             	add    $0x10,%esp
80105ae4:	85 c0                	test   %eax,%eax
80105ae6:	78 25                	js     80105b0d <sys_mknod+0x6f>
80105ae8:	8b 45 e8             	mov    -0x18(%ebp),%eax
80105aeb:	0f bf c8             	movswl %ax,%ecx
80105aee:	8b 45 ec             	mov    -0x14(%ebp),%eax
80105af1:	0f bf d0             	movswl %ax,%edx
80105af4:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105af7:	51                   	push   %ecx
80105af8:	52                   	push   %edx
80105af9:	6a 03                	push   $0x3
80105afb:	50                   	push   %eax
80105afc:	e8 cd fb ff ff       	call   801056ce <create>
80105b01:	83 c4 10             	add    $0x10,%esp
80105b04:	89 45 f4             	mov    %eax,-0xc(%ebp)
80105b07:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80105b0b:	75 0c                	jne    80105b19 <sys_mknod+0x7b>
80105b0d:	e8 b6 d5 ff ff       	call   801030c8 <end_op>
80105b12:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105b17:	eb 18                	jmp    80105b31 <sys_mknod+0x93>
80105b19:	83 ec 0c             	sub    $0xc,%esp
80105b1c:	ff 75 f4             	push   -0xc(%ebp)
80105b1f:	e8 f7 c0 ff ff       	call   80101c1b <iunlockput>
80105b24:	83 c4 10             	add    $0x10,%esp
80105b27:	e8 9c d5 ff ff       	call   801030c8 <end_op>
80105b2c:	b8 00 00 00 00       	mov    $0x0,%eax
80105b31:	c9                   	leave  
80105b32:	c3                   	ret    

80105b33 <sys_chdir>:
80105b33:	55                   	push   %ebp
80105b34:	89 e5                	mov    %esp,%ebp
80105b36:	83 ec 18             	sub    $0x18,%esp
80105b39:	e8 f2 de ff ff       	call   80103a30 <myproc>
80105b3e:	89 45 f4             	mov    %eax,-0xc(%ebp)
80105b41:	e8 f6 d4 ff ff       	call   8010303c <begin_op>
80105b46:	83 ec 08             	sub    $0x8,%esp
80105b49:	8d 45 ec             	lea    -0x14(%ebp),%eax
80105b4c:	50                   	push   %eax
80105b4d:	6a 00                	push   $0x0
80105b4f:	e8 4a f4 ff ff       	call   80104f9e <argstr>
80105b54:	83 c4 10             	add    $0x10,%esp
80105b57:	85 c0                	test   %eax,%eax
80105b59:	78 18                	js     80105b73 <sys_chdir+0x40>
80105b5b:	8b 45 ec             	mov    -0x14(%ebp),%eax
80105b5e:	83 ec 0c             	sub    $0xc,%esp
80105b61:	50                   	push   %eax
80105b62:	e8 b6 c9 ff ff       	call   8010251d <namei>
80105b67:	83 c4 10             	add    $0x10,%esp
80105b6a:	89 45 f0             	mov    %eax,-0x10(%ebp)
80105b6d:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80105b71:	75 0c                	jne    80105b7f <sys_chdir+0x4c>
80105b73:	e8 50 d5 ff ff       	call   801030c8 <end_op>
80105b78:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105b7d:	eb 68                	jmp    80105be7 <sys_chdir+0xb4>
80105b7f:	83 ec 0c             	sub    $0xc,%esp
80105b82:	ff 75 f0             	push   -0x10(%ebp)
80105b85:	e8 60 be ff ff       	call   801019ea <ilock>
80105b8a:	83 c4 10             	add    $0x10,%esp
80105b8d:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105b90:	0f b7 40 50          	movzwl 0x50(%eax),%eax
80105b94:	66 83 f8 01          	cmp    $0x1,%ax
80105b98:	74 1a                	je     80105bb4 <sys_chdir+0x81>
80105b9a:	83 ec 0c             	sub    $0xc,%esp
80105b9d:	ff 75 f0             	push   -0x10(%ebp)
80105ba0:	e8 76 c0 ff ff       	call   80101c1b <iunlockput>
80105ba5:	83 c4 10             	add    $0x10,%esp
80105ba8:	e8 1b d5 ff ff       	call   801030c8 <end_op>
80105bad:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105bb2:	eb 33                	jmp    80105be7 <sys_chdir+0xb4>
80105bb4:	83 ec 0c             	sub    $0xc,%esp
80105bb7:	ff 75 f0             	push   -0x10(%ebp)
80105bba:	e8 3e bf ff ff       	call   80101afd <iunlock>
80105bbf:	83 c4 10             	add    $0x10,%esp
80105bc2:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105bc5:	8b 40 68             	mov    0x68(%eax),%eax
80105bc8:	83 ec 0c             	sub    $0xc,%esp
80105bcb:	50                   	push   %eax
80105bcc:	e8 7a bf ff ff       	call   80101b4b <iput>
80105bd1:	83 c4 10             	add    $0x10,%esp
80105bd4:	e8 ef d4 ff ff       	call   801030c8 <end_op>
80105bd9:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105bdc:	8b 55 f0             	mov    -0x10(%ebp),%edx
80105bdf:	89 50 68             	mov    %edx,0x68(%eax)
80105be2:	b8 00 00 00 00       	mov    $0x0,%eax
80105be7:	c9                   	leave  
80105be8:	c3                   	ret    

80105be9 <sys_exec>:
80105be9:	55                   	push   %ebp
80105bea:	89 e5                	mov    %esp,%ebp
80105bec:	81 ec 98 00 00 00    	sub    $0x98,%esp
80105bf2:	83 ec 08             	sub    $0x8,%esp
80105bf5:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105bf8:	50                   	push   %eax
80105bf9:	6a 00                	push   $0x0
80105bfb:	e8 9e f3 ff ff       	call   80104f9e <argstr>
80105c00:	83 c4 10             	add    $0x10,%esp
80105c03:	85 c0                	test   %eax,%eax
80105c05:	78 18                	js     80105c1f <sys_exec+0x36>
80105c07:	83 ec 08             	sub    $0x8,%esp
80105c0a:	8d 85 6c ff ff ff    	lea    -0x94(%ebp),%eax
80105c10:	50                   	push   %eax
80105c11:	6a 01                	push   $0x1
80105c13:	e8 f1 f2 ff ff       	call   80104f09 <argint>
80105c18:	83 c4 10             	add    $0x10,%esp
80105c1b:	85 c0                	test   %eax,%eax
80105c1d:	79 0a                	jns    80105c29 <sys_exec+0x40>
80105c1f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105c24:	e9 c6 00 00 00       	jmp    80105cef <sys_exec+0x106>
80105c29:	83 ec 04             	sub    $0x4,%esp
80105c2c:	68 80 00 00 00       	push   $0x80
80105c31:	6a 00                	push   $0x0
80105c33:	8d 85 70 ff ff ff    	lea    -0x90(%ebp),%eax
80105c39:	50                   	push   %eax
80105c3a:	e8 9f ef ff ff       	call   80104bde <memset>
80105c3f:	83 c4 10             	add    $0x10,%esp
80105c42:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80105c49:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105c4c:	83 f8 1f             	cmp    $0x1f,%eax
80105c4f:	76 0a                	jbe    80105c5b <sys_exec+0x72>
80105c51:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105c56:	e9 94 00 00 00       	jmp    80105cef <sys_exec+0x106>
80105c5b:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105c5e:	c1 e0 02             	shl    $0x2,%eax
80105c61:	89 c2                	mov    %eax,%edx
80105c63:	8b 85 6c ff ff ff    	mov    -0x94(%ebp),%eax
80105c69:	01 c2                	add    %eax,%edx
80105c6b:	83 ec 08             	sub    $0x8,%esp
80105c6e:	8d 85 68 ff ff ff    	lea    -0x98(%ebp),%eax
80105c74:	50                   	push   %eax
80105c75:	52                   	push   %edx
80105c76:	e8 ed f1 ff ff       	call   80104e68 <fetchint>
80105c7b:	83 c4 10             	add    $0x10,%esp
80105c7e:	85 c0                	test   %eax,%eax
80105c80:	79 07                	jns    80105c89 <sys_exec+0xa0>
80105c82:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105c87:	eb 66                	jmp    80105cef <sys_exec+0x106>
80105c89:	8b 85 68 ff ff ff    	mov    -0x98(%ebp),%eax
80105c8f:	85 c0                	test   %eax,%eax
80105c91:	75 27                	jne    80105cba <sys_exec+0xd1>
80105c93:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105c96:	c7 84 85 70 ff ff ff 	movl   $0x0,-0x90(%ebp,%eax,4)
80105c9d:	00 00 00 00 
80105ca1:	90                   	nop
80105ca2:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105ca5:	83 ec 08             	sub    $0x8,%esp
80105ca8:	8d 95 70 ff ff ff    	lea    -0x90(%ebp),%edx
80105cae:	52                   	push   %edx
80105caf:	50                   	push   %eax
80105cb0:	e8 cb ae ff ff       	call   80100b80 <exec>
80105cb5:	83 c4 10             	add    $0x10,%esp
80105cb8:	eb 35                	jmp    80105cef <sys_exec+0x106>
80105cba:	8d 95 70 ff ff ff    	lea    -0x90(%ebp),%edx
80105cc0:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105cc3:	c1 e0 02             	shl    $0x2,%eax
80105cc6:	01 c2                	add    %eax,%edx
80105cc8:	8b 85 68 ff ff ff    	mov    -0x98(%ebp),%eax
80105cce:	83 ec 08             	sub    $0x8,%esp
80105cd1:	52                   	push   %edx
80105cd2:	50                   	push   %eax
80105cd3:	e8 cf f1 ff ff       	call   80104ea7 <fetchstr>
80105cd8:	83 c4 10             	add    $0x10,%esp
80105cdb:	85 c0                	test   %eax,%eax
80105cdd:	79 07                	jns    80105ce6 <sys_exec+0xfd>
80105cdf:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105ce4:	eb 09                	jmp    80105cef <sys_exec+0x106>
80105ce6:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80105cea:	e9 5a ff ff ff       	jmp    80105c49 <sys_exec+0x60>
80105cef:	c9                   	leave  
80105cf0:	c3                   	ret    

80105cf1 <sys_pipe>:
80105cf1:	55                   	push   %ebp
80105cf2:	89 e5                	mov    %esp,%ebp
80105cf4:	83 ec 28             	sub    $0x28,%esp
80105cf7:	83 ec 04             	sub    $0x4,%esp
80105cfa:	6a 08                	push   $0x8
80105cfc:	8d 45 ec             	lea    -0x14(%ebp),%eax
80105cff:	50                   	push   %eax
80105d00:	6a 00                	push   $0x0
80105d02:	e8 2f f2 ff ff       	call   80104f36 <argptr>
80105d07:	83 c4 10             	add    $0x10,%esp
80105d0a:	85 c0                	test   %eax,%eax
80105d0c:	79 0a                	jns    80105d18 <sys_pipe+0x27>
80105d0e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105d13:	e9 ae 00 00 00       	jmp    80105dc6 <sys_pipe+0xd5>
80105d18:	83 ec 08             	sub    $0x8,%esp
80105d1b:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80105d1e:	50                   	push   %eax
80105d1f:	8d 45 e8             	lea    -0x18(%ebp),%eax
80105d22:	50                   	push   %eax
80105d23:	e8 45 d8 ff ff       	call   8010356d <pipealloc>
80105d28:	83 c4 10             	add    $0x10,%esp
80105d2b:	85 c0                	test   %eax,%eax
80105d2d:	79 0a                	jns    80105d39 <sys_pipe+0x48>
80105d2f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105d34:	e9 8d 00 00 00       	jmp    80105dc6 <sys_pipe+0xd5>
80105d39:	c7 45 f4 ff ff ff ff 	movl   $0xffffffff,-0xc(%ebp)
80105d40:	8b 45 e8             	mov    -0x18(%ebp),%eax
80105d43:	83 ec 0c             	sub    $0xc,%esp
80105d46:	50                   	push   %eax
80105d47:	e8 7b f3 ff ff       	call   801050c7 <fdalloc>
80105d4c:	83 c4 10             	add    $0x10,%esp
80105d4f:	89 45 f4             	mov    %eax,-0xc(%ebp)
80105d52:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80105d56:	78 18                	js     80105d70 <sys_pipe+0x7f>
80105d58:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80105d5b:	83 ec 0c             	sub    $0xc,%esp
80105d5e:	50                   	push   %eax
80105d5f:	e8 63 f3 ff ff       	call   801050c7 <fdalloc>
80105d64:	83 c4 10             	add    $0x10,%esp
80105d67:	89 45 f0             	mov    %eax,-0x10(%ebp)
80105d6a:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80105d6e:	79 3e                	jns    80105dae <sys_pipe+0xbd>
80105d70:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80105d74:	78 13                	js     80105d89 <sys_pipe+0x98>
80105d76:	e8 b5 dc ff ff       	call   80103a30 <myproc>
80105d7b:	8b 55 f4             	mov    -0xc(%ebp),%edx
80105d7e:	83 c2 08             	add    $0x8,%edx
80105d81:	c7 44 90 08 00 00 00 	movl   $0x0,0x8(%eax,%edx,4)
80105d88:	00 
80105d89:	8b 45 e8             	mov    -0x18(%ebp),%eax
80105d8c:	83 ec 0c             	sub    $0xc,%esp
80105d8f:	50                   	push   %eax
80105d90:	e8 06 b3 ff ff       	call   8010109b <fileclose>
80105d95:	83 c4 10             	add    $0x10,%esp
80105d98:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80105d9b:	83 ec 0c             	sub    $0xc,%esp
80105d9e:	50                   	push   %eax
80105d9f:	e8 f7 b2 ff ff       	call   8010109b <fileclose>
80105da4:	83 c4 10             	add    $0x10,%esp
80105da7:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105dac:	eb 18                	jmp    80105dc6 <sys_pipe+0xd5>
80105dae:	8b 45 ec             	mov    -0x14(%ebp),%eax
80105db1:	8b 55 f4             	mov    -0xc(%ebp),%edx
80105db4:	89 10                	mov    %edx,(%eax)
80105db6:	8b 45 ec             	mov    -0x14(%ebp),%eax
80105db9:	8d 50 04             	lea    0x4(%eax),%edx
80105dbc:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105dbf:	89 02                	mov    %eax,(%edx)
80105dc1:	b8 00 00 00 00       	mov    $0x0,%eax
80105dc6:	c9                   	leave  
80105dc7:	c3                   	ret    

80105dc8 <sys_fork>:
80105dc8:	55                   	push   %ebp
80105dc9:	89 e5                	mov    %esp,%ebp
80105dcb:	83 ec 08             	sub    $0x8,%esp
80105dce:	e8 5c df ff ff       	call   80103d2f <fork>
80105dd3:	c9                   	leave  
80105dd4:	c3                   	ret    

80105dd5 <sys_exit>:
80105dd5:	55                   	push   %ebp
80105dd6:	89 e5                	mov    %esp,%ebp
80105dd8:	83 ec 08             	sub    $0x8,%esp
80105ddb:	e8 c8 e0 ff ff       	call   80103ea8 <exit>
80105de0:	b8 00 00 00 00       	mov    $0x0,%eax
80105de5:	c9                   	leave  
80105de6:	c3                   	ret    

80105de7 <sys_exit2>:
80105de7:	55                   	push   %ebp
80105de8:	89 e5                	mov    %esp,%ebp
80105dea:	83 ec 18             	sub    $0x18,%esp
80105ded:	83 ec 08             	sub    $0x8,%esp
80105df0:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105df3:	50                   	push   %eax
80105df4:	6a 00                	push   $0x0
80105df6:	e8 0e f1 ff ff       	call   80104f09 <argint>
80105dfb:	83 c4 10             	add    $0x10,%esp
80105dfe:	85 c0                	test   %eax,%eax
80105e00:	79 07                	jns    80105e09 <sys_exit2+0x22>
80105e02:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105e07:	eb 12                	jmp    80105e1b <sys_exit2+0x34>
80105e09:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105e0c:	83 ec 0c             	sub    $0xc,%esp
80105e0f:	50                   	push   %eax
80105e10:	e8 b3 e1 ff ff       	call   80103fc8 <exit2>
80105e15:	83 c4 10             	add    $0x10,%esp
80105e18:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105e1b:	c9                   	leave  
80105e1c:	c3                   	ret    

80105e1d <sys_wait>:
80105e1d:	55                   	push   %ebp
80105e1e:	89 e5                	mov    %esp,%ebp
80105e20:	83 ec 08             	sub    $0x8,%esp
80105e23:	e8 cc e2 ff ff       	call   801040f4 <wait>
80105e28:	c9                   	leave  
80105e29:	c3                   	ret    

80105e2a <sys_wait2>:
80105e2a:	55                   	push   %ebp
80105e2b:	89 e5                	mov    %esp,%ebp
80105e2d:	83 ec 18             	sub    $0x18,%esp
80105e30:	83 ec 04             	sub    $0x4,%esp
80105e33:	6a 04                	push   $0x4
80105e35:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105e38:	50                   	push   %eax
80105e39:	6a 00                	push   $0x0
80105e3b:	e8 f6 f0 ff ff       	call   80104f36 <argptr>
80105e40:	83 c4 10             	add    $0x10,%esp
80105e43:	85 c0                	test   %eax,%eax
80105e45:	79 07                	jns    80105e4e <sys_wait2+0x24>
80105e47:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105e4c:	eb 0f                	jmp    80105e5d <sys_wait2+0x33>
80105e4e:	83 ec 0c             	sub    $0xc,%esp
80105e51:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105e54:	50                   	push   %eax
80105e55:	e8 ba e3 ff ff       	call   80104214 <wait2>
80105e5a:	83 c4 10             	add    $0x10,%esp
80105e5d:	c9                   	leave  
80105e5e:	c3                   	ret    

80105e5f <sys_kill>:
80105e5f:	55                   	push   %ebp
80105e60:	89 e5                	mov    %esp,%ebp
80105e62:	83 ec 18             	sub    $0x18,%esp
80105e65:	83 ec 08             	sub    $0x8,%esp
80105e68:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105e6b:	50                   	push   %eax
80105e6c:	6a 00                	push   $0x0
80105e6e:	e8 96 f0 ff ff       	call   80104f09 <argint>
80105e73:	83 c4 10             	add    $0x10,%esp
80105e76:	85 c0                	test   %eax,%eax
80105e78:	79 07                	jns    80105e81 <sys_kill+0x22>
80105e7a:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105e7f:	eb 0f                	jmp    80105e90 <sys_kill+0x31>
80105e81:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105e84:	83 ec 0c             	sub    $0xc,%esp
80105e87:	50                   	push   %eax
80105e88:	e8 de e7 ff ff       	call   8010466b <kill>
80105e8d:	83 c4 10             	add    $0x10,%esp
80105e90:	c9                   	leave  
80105e91:	c3                   	ret    

80105e92 <sys_getpid>:
80105e92:	55                   	push   %ebp
80105e93:	89 e5                	mov    %esp,%ebp
80105e95:	83 ec 08             	sub    $0x8,%esp
80105e98:	e8 93 db ff ff       	call   80103a30 <myproc>
80105e9d:	8b 40 10             	mov    0x10(%eax),%eax
80105ea0:	c9                   	leave  
80105ea1:	c3                   	ret    

80105ea2 <sys_sbrk>:
80105ea2:	55                   	push   %ebp
80105ea3:	89 e5                	mov    %esp,%ebp
80105ea5:	83 ec 18             	sub    $0x18,%esp
80105ea8:	83 ec 08             	sub    $0x8,%esp
80105eab:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105eae:	50                   	push   %eax
80105eaf:	6a 00                	push   $0x0
80105eb1:	e8 53 f0 ff ff       	call   80104f09 <argint>
80105eb6:	83 c4 10             	add    $0x10,%esp
80105eb9:	85 c0                	test   %eax,%eax
80105ebb:	79 07                	jns    80105ec4 <sys_sbrk+0x22>
80105ebd:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105ec2:	eb 27                	jmp    80105eeb <sys_sbrk+0x49>
80105ec4:	e8 67 db ff ff       	call   80103a30 <myproc>
80105ec9:	8b 00                	mov    (%eax),%eax
80105ecb:	89 45 f4             	mov    %eax,-0xc(%ebp)
80105ece:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105ed1:	83 ec 0c             	sub    $0xc,%esp
80105ed4:	50                   	push   %eax
80105ed5:	e8 ba dd ff ff       	call   80103c94 <growproc>
80105eda:	83 c4 10             	add    $0x10,%esp
80105edd:	85 c0                	test   %eax,%eax
80105edf:	79 07                	jns    80105ee8 <sys_sbrk+0x46>
80105ee1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105ee6:	eb 03                	jmp    80105eeb <sys_sbrk+0x49>
80105ee8:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105eeb:	c9                   	leave  
80105eec:	c3                   	ret    

80105eed <sys_sleep>:
80105eed:	55                   	push   %ebp
80105eee:	89 e5                	mov    %esp,%ebp
80105ef0:	83 ec 18             	sub    $0x18,%esp
80105ef3:	83 ec 08             	sub    $0x8,%esp
80105ef6:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105ef9:	50                   	push   %eax
80105efa:	6a 00                	push   $0x0
80105efc:	e8 08 f0 ff ff       	call   80104f09 <argint>
80105f01:	83 c4 10             	add    $0x10,%esp
80105f04:	85 c0                	test   %eax,%eax
80105f06:	79 07                	jns    80105f0f <sys_sleep+0x22>
80105f08:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105f0d:	eb 76                	jmp    80105f85 <sys_sleep+0x98>
80105f0f:	83 ec 0c             	sub    $0xc,%esp
80105f12:	68 40 6a 19 80       	push   $0x80196a40
80105f17:	e8 4c ea ff ff       	call   80104968 <acquire>
80105f1c:	83 c4 10             	add    $0x10,%esp
80105f1f:	a1 74 6a 19 80       	mov    0x80196a74,%eax
80105f24:	89 45 f4             	mov    %eax,-0xc(%ebp)
80105f27:	eb 38                	jmp    80105f61 <sys_sleep+0x74>
80105f29:	e8 02 db ff ff       	call   80103a30 <myproc>
80105f2e:	8b 40 24             	mov    0x24(%eax),%eax
80105f31:	85 c0                	test   %eax,%eax
80105f33:	74 17                	je     80105f4c <sys_sleep+0x5f>
80105f35:	83 ec 0c             	sub    $0xc,%esp
80105f38:	68 40 6a 19 80       	push   $0x80196a40
80105f3d:	e8 94 ea ff ff       	call   801049d6 <release>
80105f42:	83 c4 10             	add    $0x10,%esp
80105f45:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105f4a:	eb 39                	jmp    80105f85 <sys_sleep+0x98>
80105f4c:	83 ec 08             	sub    $0x8,%esp
80105f4f:	68 40 6a 19 80       	push   $0x80196a40
80105f54:	68 74 6a 19 80       	push   $0x80196a74
80105f59:	e8 ef e5 ff ff       	call   8010454d <sleep>
80105f5e:	83 c4 10             	add    $0x10,%esp
80105f61:	a1 74 6a 19 80       	mov    0x80196a74,%eax
80105f66:	2b 45 f4             	sub    -0xc(%ebp),%eax
80105f69:	8b 55 f0             	mov    -0x10(%ebp),%edx
80105f6c:	39 d0                	cmp    %edx,%eax
80105f6e:	72 b9                	jb     80105f29 <sys_sleep+0x3c>
80105f70:	83 ec 0c             	sub    $0xc,%esp
80105f73:	68 40 6a 19 80       	push   $0x80196a40
80105f78:	e8 59 ea ff ff       	call   801049d6 <release>
80105f7d:	83 c4 10             	add    $0x10,%esp
80105f80:	b8 00 00 00 00       	mov    $0x0,%eax
80105f85:	c9                   	leave  
80105f86:	c3                   	ret    

80105f87 <sys_uptime>:
80105f87:	55                   	push   %ebp
80105f88:	89 e5                	mov    %esp,%ebp
80105f8a:	83 ec 18             	sub    $0x18,%esp
80105f8d:	83 ec 0c             	sub    $0xc,%esp
80105f90:	68 40 6a 19 80       	push   $0x80196a40
80105f95:	e8 ce e9 ff ff       	call   80104968 <acquire>
80105f9a:	83 c4 10             	add    $0x10,%esp
80105f9d:	a1 74 6a 19 80       	mov    0x80196a74,%eax
80105fa2:	89 45 f4             	mov    %eax,-0xc(%ebp)
80105fa5:	83 ec 0c             	sub    $0xc,%esp
80105fa8:	68 40 6a 19 80       	push   $0x80196a40
80105fad:	e8 24 ea ff ff       	call   801049d6 <release>
80105fb2:	83 c4 10             	add    $0x10,%esp
80105fb5:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105fb8:	c9                   	leave  
80105fb9:	c3                   	ret    

80105fba <alltraps>:
80105fba:	1e                   	push   %ds
80105fbb:	06                   	push   %es
80105fbc:	0f a0                	push   %fs
80105fbe:	0f a8                	push   %gs
80105fc0:	60                   	pusha  
80105fc1:	66 b8 10 00          	mov    $0x10,%ax
80105fc5:	8e d8                	mov    %eax,%ds
80105fc7:	8e c0                	mov    %eax,%es
80105fc9:	54                   	push   %esp
80105fca:	e8 d7 01 00 00       	call   801061a6 <trap>
80105fcf:	83 c4 04             	add    $0x4,%esp

80105fd2 <trapret>:
80105fd2:	61                   	popa   
80105fd3:	0f a9                	pop    %gs
80105fd5:	0f a1                	pop    %fs
80105fd7:	07                   	pop    %es
80105fd8:	1f                   	pop    %ds
80105fd9:	83 c4 08             	add    $0x8,%esp
80105fdc:	cf                   	iret   

80105fdd <lidt>:

struct gatedesc;

static inline void
lidt(struct gatedesc *p, int size)
{
80105fdd:	55                   	push   %ebp
80105fde:	89 e5                	mov    %esp,%ebp
80105fe0:	83 ec 10             	sub    $0x10,%esp
  volatile ushort pd[3];

  pd[0] = size-1;
80105fe3:	8b 45 0c             	mov    0xc(%ebp),%eax
80105fe6:	83 e8 01             	sub    $0x1,%eax
80105fe9:	66 89 45 fa          	mov    %ax,-0x6(%ebp)
  pd[1] = (uint)p;
80105fed:	8b 45 08             	mov    0x8(%ebp),%eax
80105ff0:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  pd[2] = (uint)p >> 16;
80105ff4:	8b 45 08             	mov    0x8(%ebp),%eax
80105ff7:	c1 e8 10             	shr    $0x10,%eax
80105ffa:	66 89 45 fe          	mov    %ax,-0x2(%ebp)

  asm volatile("lidt (%0)" : : "r" (pd));
80105ffe:	8d 45 fa             	lea    -0x6(%ebp),%eax
80106001:	0f 01 18             	lidtl  (%eax)
}
80106004:	90                   	nop
80106005:	c9                   	leave  
80106006:	c3                   	ret    

80106007 <rcr2>:
  return result;
}

static inline uint
rcr2(void)
{
80106007:	55                   	push   %ebp
80106008:	89 e5                	mov    %esp,%ebp
8010600a:	83 ec 10             	sub    $0x10,%esp
  uint val;
  asm volatile("movl %%cr2,%0" : "=r" (val));
8010600d:	0f 20 d0             	mov    %cr2,%eax
80106010:	89 45 fc             	mov    %eax,-0x4(%ebp)
  return val;
80106013:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
80106016:	c9                   	leave  
80106017:	c3                   	ret    

80106018 <tvinit>:
struct spinlock tickslock;
uint ticks;

void
tvinit(void)
{
80106018:	55                   	push   %ebp
80106019:	89 e5                	mov    %esp,%ebp
8010601b:	83 ec 18             	sub    $0x18,%esp
  int i;

  for(i = 0; i < 256; i++)
8010601e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80106025:	e9 c3 00 00 00       	jmp    801060ed <tvinit+0xd5>
    SETGATE(idt[i], 0, SEG_KCODE<<3, vectors[i], 0);
8010602a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010602d:	8b 04 85 80 f0 10 80 	mov    -0x7fef0f80(,%eax,4),%eax
80106034:	89 c2                	mov    %eax,%edx
80106036:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106039:	66 89 14 c5 40 62 19 	mov    %dx,-0x7fe69dc0(,%eax,8)
80106040:	80 
80106041:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106044:	66 c7 04 c5 42 62 19 	movw   $0x8,-0x7fe69dbe(,%eax,8)
8010604b:	80 08 00 
8010604e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106051:	0f b6 14 c5 44 62 19 	movzbl -0x7fe69dbc(,%eax,8),%edx
80106058:	80 
80106059:	83 e2 e0             	and    $0xffffffe0,%edx
8010605c:	88 14 c5 44 62 19 80 	mov    %dl,-0x7fe69dbc(,%eax,8)
80106063:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106066:	0f b6 14 c5 44 62 19 	movzbl -0x7fe69dbc(,%eax,8),%edx
8010606d:	80 
8010606e:	83 e2 1f             	and    $0x1f,%edx
80106071:	88 14 c5 44 62 19 80 	mov    %dl,-0x7fe69dbc(,%eax,8)
80106078:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010607b:	0f b6 14 c5 45 62 19 	movzbl -0x7fe69dbb(,%eax,8),%edx
80106082:	80 
80106083:	83 e2 f0             	and    $0xfffffff0,%edx
80106086:	83 ca 0e             	or     $0xe,%edx
80106089:	88 14 c5 45 62 19 80 	mov    %dl,-0x7fe69dbb(,%eax,8)
80106090:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106093:	0f b6 14 c5 45 62 19 	movzbl -0x7fe69dbb(,%eax,8),%edx
8010609a:	80 
8010609b:	83 e2 ef             	and    $0xffffffef,%edx
8010609e:	88 14 c5 45 62 19 80 	mov    %dl,-0x7fe69dbb(,%eax,8)
801060a5:	8b 45 f4             	mov    -0xc(%ebp),%eax
801060a8:	0f b6 14 c5 45 62 19 	movzbl -0x7fe69dbb(,%eax,8),%edx
801060af:	80 
801060b0:	83 e2 9f             	and    $0xffffff9f,%edx
801060b3:	88 14 c5 45 62 19 80 	mov    %dl,-0x7fe69dbb(,%eax,8)
801060ba:	8b 45 f4             	mov    -0xc(%ebp),%eax
801060bd:	0f b6 14 c5 45 62 19 	movzbl -0x7fe69dbb(,%eax,8),%edx
801060c4:	80 
801060c5:	83 ca 80             	or     $0xffffff80,%edx
801060c8:	88 14 c5 45 62 19 80 	mov    %dl,-0x7fe69dbb(,%eax,8)
801060cf:	8b 45 f4             	mov    -0xc(%ebp),%eax
801060d2:	8b 04 85 80 f0 10 80 	mov    -0x7fef0f80(,%eax,4),%eax
801060d9:	c1 e8 10             	shr    $0x10,%eax
801060dc:	89 c2                	mov    %eax,%edx
801060de:	8b 45 f4             	mov    -0xc(%ebp),%eax
801060e1:	66 89 14 c5 46 62 19 	mov    %dx,-0x7fe69dba(,%eax,8)
801060e8:	80 
  for(i = 0; i < 256; i++)
801060e9:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
801060ed:	81 7d f4 ff 00 00 00 	cmpl   $0xff,-0xc(%ebp)
801060f4:	0f 8e 30 ff ff ff    	jle    8010602a <tvinit+0x12>
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
801060fa:	a1 80 f1 10 80       	mov    0x8010f180,%eax
801060ff:	66 a3 40 64 19 80    	mov    %ax,0x80196440
80106105:	66 c7 05 42 64 19 80 	movw   $0x8,0x80196442
8010610c:	08 00 
8010610e:	0f b6 05 44 64 19 80 	movzbl 0x80196444,%eax
80106115:	83 e0 e0             	and    $0xffffffe0,%eax
80106118:	a2 44 64 19 80       	mov    %al,0x80196444
8010611d:	0f b6 05 44 64 19 80 	movzbl 0x80196444,%eax
80106124:	83 e0 1f             	and    $0x1f,%eax
80106127:	a2 44 64 19 80       	mov    %al,0x80196444
8010612c:	0f b6 05 45 64 19 80 	movzbl 0x80196445,%eax
80106133:	83 c8 0f             	or     $0xf,%eax
80106136:	a2 45 64 19 80       	mov    %al,0x80196445
8010613b:	0f b6 05 45 64 19 80 	movzbl 0x80196445,%eax
80106142:	83 e0 ef             	and    $0xffffffef,%eax
80106145:	a2 45 64 19 80       	mov    %al,0x80196445
8010614a:	0f b6 05 45 64 19 80 	movzbl 0x80196445,%eax
80106151:	83 c8 60             	or     $0x60,%eax
80106154:	a2 45 64 19 80       	mov    %al,0x80196445
80106159:	0f b6 05 45 64 19 80 	movzbl 0x80196445,%eax
80106160:	83 c8 80             	or     $0xffffff80,%eax
80106163:	a2 45 64 19 80       	mov    %al,0x80196445
80106168:	a1 80 f1 10 80       	mov    0x8010f180,%eax
8010616d:	c1 e8 10             	shr    $0x10,%eax
80106170:	66 a3 46 64 19 80    	mov    %ax,0x80196446

  initlock(&tickslock, "time");
80106176:	83 ec 08             	sub    $0x8,%esp
80106179:	68 98 a6 10 80       	push   $0x8010a698
8010617e:	68 40 6a 19 80       	push   $0x80196a40
80106183:	e8 be e7 ff ff       	call   80104946 <initlock>
80106188:	83 c4 10             	add    $0x10,%esp
}
8010618b:	90                   	nop
8010618c:	c9                   	leave  
8010618d:	c3                   	ret    

8010618e <idtinit>:

void
idtinit(void)
{
8010618e:	55                   	push   %ebp
8010618f:	89 e5                	mov    %esp,%ebp
  lidt(idt, sizeof(idt));
80106191:	68 00 08 00 00       	push   $0x800
80106196:	68 40 62 19 80       	push   $0x80196240
8010619b:	e8 3d fe ff ff       	call   80105fdd <lidt>
801061a0:	83 c4 08             	add    $0x8,%esp
}
801061a3:	90                   	nop
801061a4:	c9                   	leave  
801061a5:	c3                   	ret    

801061a6 <trap>:

//PAGEBREAK: 41
void
trap(struct trapframe *tf)
{
801061a6:	55                   	push   %ebp
801061a7:	89 e5                	mov    %esp,%ebp
801061a9:	57                   	push   %edi
801061aa:	56                   	push   %esi
801061ab:	53                   	push   %ebx
801061ac:	83 ec 1c             	sub    $0x1c,%esp
  if(tf->trapno == T_SYSCALL){
801061af:	8b 45 08             	mov    0x8(%ebp),%eax
801061b2:	8b 40 30             	mov    0x30(%eax),%eax
801061b5:	83 f8 40             	cmp    $0x40,%eax
801061b8:	75 3b                	jne    801061f5 <trap+0x4f>
    if(myproc()->killed)
801061ba:	e8 71 d8 ff ff       	call   80103a30 <myproc>
801061bf:	8b 40 24             	mov    0x24(%eax),%eax
801061c2:	85 c0                	test   %eax,%eax
801061c4:	74 05                	je     801061cb <trap+0x25>
      exit();
801061c6:	e8 dd dc ff ff       	call   80103ea8 <exit>
    myproc()->tf = tf;
801061cb:	e8 60 d8 ff ff       	call   80103a30 <myproc>
801061d0:	8b 55 08             	mov    0x8(%ebp),%edx
801061d3:	89 50 18             	mov    %edx,0x18(%eax)
    syscall();
801061d6:	e8 fa ed ff ff       	call   80104fd5 <syscall>
    if(myproc()->killed)
801061db:	e8 50 d8 ff ff       	call   80103a30 <myproc>
801061e0:	8b 40 24             	mov    0x24(%eax),%eax
801061e3:	85 c0                	test   %eax,%eax
801061e5:	0f 84 15 02 00 00    	je     80106400 <trap+0x25a>
      exit();
801061eb:	e8 b8 dc ff ff       	call   80103ea8 <exit>
    return;
801061f0:	e9 0b 02 00 00       	jmp    80106400 <trap+0x25a>
  }

  switch(tf->trapno){
801061f5:	8b 45 08             	mov    0x8(%ebp),%eax
801061f8:	8b 40 30             	mov    0x30(%eax),%eax
801061fb:	83 e8 20             	sub    $0x20,%eax
801061fe:	83 f8 1f             	cmp    $0x1f,%eax
80106201:	0f 87 c4 00 00 00    	ja     801062cb <trap+0x125>
80106207:	8b 04 85 40 a7 10 80 	mov    -0x7fef58c0(,%eax,4),%eax
8010620e:	ff e0                	jmp    *%eax
  case T_IRQ0 + IRQ_TIMER:
    if(cpuid() == 0){
80106210:	e8 88 d7 ff ff       	call   8010399d <cpuid>
80106215:	85 c0                	test   %eax,%eax
80106217:	75 3d                	jne    80106256 <trap+0xb0>
      acquire(&tickslock);
80106219:	83 ec 0c             	sub    $0xc,%esp
8010621c:	68 40 6a 19 80       	push   $0x80196a40
80106221:	e8 42 e7 ff ff       	call   80104968 <acquire>
80106226:	83 c4 10             	add    $0x10,%esp
      ticks++;
80106229:	a1 74 6a 19 80       	mov    0x80196a74,%eax
8010622e:	83 c0 01             	add    $0x1,%eax
80106231:	a3 74 6a 19 80       	mov    %eax,0x80196a74
      wakeup(&ticks);
80106236:	83 ec 0c             	sub    $0xc,%esp
80106239:	68 74 6a 19 80       	push   $0x80196a74
8010623e:	e8 f1 e3 ff ff       	call   80104634 <wakeup>
80106243:	83 c4 10             	add    $0x10,%esp
      release(&tickslock);
80106246:	83 ec 0c             	sub    $0xc,%esp
80106249:	68 40 6a 19 80       	push   $0x80196a40
8010624e:	e8 83 e7 ff ff       	call   801049d6 <release>
80106253:	83 c4 10             	add    $0x10,%esp
    }
    lapiceoi();
80106256:	e8 c1 c8 ff ff       	call   80102b1c <lapiceoi>
    break;
8010625b:	e9 20 01 00 00       	jmp    80106380 <trap+0x1da>
  case T_IRQ0 + IRQ_IDE:
    ideintr();
80106260:	e8 f5 3e 00 00       	call   8010a15a <ideintr>
    lapiceoi();
80106265:	e8 b2 c8 ff ff       	call   80102b1c <lapiceoi>
    break;
8010626a:	e9 11 01 00 00       	jmp    80106380 <trap+0x1da>
  case T_IRQ0 + IRQ_IDE+1:
    // Bochs generates spurious IDE1 interrupts.
    break;
  case T_IRQ0 + IRQ_KBD:
    kbdintr();
8010626f:	e8 ed c6 ff ff       	call   80102961 <kbdintr>
    lapiceoi();
80106274:	e8 a3 c8 ff ff       	call   80102b1c <lapiceoi>
    break;
80106279:	e9 02 01 00 00       	jmp    80106380 <trap+0x1da>
  case T_IRQ0 + IRQ_COM1:
    uartintr();
8010627e:	e8 53 03 00 00       	call   801065d6 <uartintr>
    lapiceoi();
80106283:	e8 94 c8 ff ff       	call   80102b1c <lapiceoi>
    break;
80106288:	e9 f3 00 00 00       	jmp    80106380 <trap+0x1da>
  case T_IRQ0 + 0xB:
    i8254_intr();
8010628d:	e8 7b 2b 00 00       	call   80108e0d <i8254_intr>
    lapiceoi();
80106292:	e8 85 c8 ff ff       	call   80102b1c <lapiceoi>
    break;
80106297:	e9 e4 00 00 00       	jmp    80106380 <trap+0x1da>
  case T_IRQ0 + IRQ_SPURIOUS:
    cprintf("cpu%d: spurious interrupt at %x:%x\n",
8010629c:	8b 45 08             	mov    0x8(%ebp),%eax
8010629f:	8b 70 38             	mov    0x38(%eax),%esi
            cpuid(), tf->cs, tf->eip);
801062a2:	8b 45 08             	mov    0x8(%ebp),%eax
801062a5:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
    cprintf("cpu%d: spurious interrupt at %x:%x\n",
801062a9:	0f b7 d8             	movzwl %ax,%ebx
801062ac:	e8 ec d6 ff ff       	call   8010399d <cpuid>
801062b1:	56                   	push   %esi
801062b2:	53                   	push   %ebx
801062b3:	50                   	push   %eax
801062b4:	68 a0 a6 10 80       	push   $0x8010a6a0
801062b9:	e8 36 a1 ff ff       	call   801003f4 <cprintf>
801062be:	83 c4 10             	add    $0x10,%esp
    lapiceoi();
801062c1:	e8 56 c8 ff ff       	call   80102b1c <lapiceoi>
    break;
801062c6:	e9 b5 00 00 00       	jmp    80106380 <trap+0x1da>

  //PAGEBREAK: 13
  default:
    if(myproc() == 0 || (tf->cs&3) == 0){
801062cb:	e8 60 d7 ff ff       	call   80103a30 <myproc>
801062d0:	85 c0                	test   %eax,%eax
801062d2:	74 11                	je     801062e5 <trap+0x13f>
801062d4:	8b 45 08             	mov    0x8(%ebp),%eax
801062d7:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
801062db:	0f b7 c0             	movzwl %ax,%eax
801062de:	83 e0 03             	and    $0x3,%eax
801062e1:	85 c0                	test   %eax,%eax
801062e3:	75 39                	jne    8010631e <trap+0x178>
      // In kernel, it must be our mistake.
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
801062e5:	e8 1d fd ff ff       	call   80106007 <rcr2>
801062ea:	89 c3                	mov    %eax,%ebx
801062ec:	8b 45 08             	mov    0x8(%ebp),%eax
801062ef:	8b 70 38             	mov    0x38(%eax),%esi
801062f2:	e8 a6 d6 ff ff       	call   8010399d <cpuid>
801062f7:	8b 55 08             	mov    0x8(%ebp),%edx
801062fa:	8b 52 30             	mov    0x30(%edx),%edx
801062fd:	83 ec 0c             	sub    $0xc,%esp
80106300:	53                   	push   %ebx
80106301:	56                   	push   %esi
80106302:	50                   	push   %eax
80106303:	52                   	push   %edx
80106304:	68 c4 a6 10 80       	push   $0x8010a6c4
80106309:	e8 e6 a0 ff ff       	call   801003f4 <cprintf>
8010630e:	83 c4 20             	add    $0x20,%esp
              tf->trapno, cpuid(), tf->eip, rcr2());
      panic("trap");
80106311:	83 ec 0c             	sub    $0xc,%esp
80106314:	68 f6 a6 10 80       	push   $0x8010a6f6
80106319:	e8 8b a2 ff ff       	call   801005a9 <panic>
    }
    // In user space, assume process misbehaved.
    cprintf("pid %d %s: trap %d err %d on cpu %d "
8010631e:	e8 e4 fc ff ff       	call   80106007 <rcr2>
80106323:	89 c6                	mov    %eax,%esi
80106325:	8b 45 08             	mov    0x8(%ebp),%eax
80106328:	8b 40 38             	mov    0x38(%eax),%eax
8010632b:	89 45 e4             	mov    %eax,-0x1c(%ebp)
8010632e:	e8 6a d6 ff ff       	call   8010399d <cpuid>
80106333:	89 c3                	mov    %eax,%ebx
80106335:	8b 45 08             	mov    0x8(%ebp),%eax
80106338:	8b 48 34             	mov    0x34(%eax),%ecx
8010633b:	89 4d e0             	mov    %ecx,-0x20(%ebp)
8010633e:	8b 45 08             	mov    0x8(%ebp),%eax
80106341:	8b 78 30             	mov    0x30(%eax),%edi
            "eip 0x%x addr 0x%x--kill proc\n",
            myproc()->pid, myproc()->name, tf->trapno,
80106344:	e8 e7 d6 ff ff       	call   80103a30 <myproc>
80106349:	8d 50 6c             	lea    0x6c(%eax),%edx
8010634c:	89 55 dc             	mov    %edx,-0x24(%ebp)
8010634f:	e8 dc d6 ff ff       	call   80103a30 <myproc>
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80106354:	8b 40 10             	mov    0x10(%eax),%eax
80106357:	56                   	push   %esi
80106358:	ff 75 e4             	push   -0x1c(%ebp)
8010635b:	53                   	push   %ebx
8010635c:	ff 75 e0             	push   -0x20(%ebp)
8010635f:	57                   	push   %edi
80106360:	ff 75 dc             	push   -0x24(%ebp)
80106363:	50                   	push   %eax
80106364:	68 fc a6 10 80       	push   $0x8010a6fc
80106369:	e8 86 a0 ff ff       	call   801003f4 <cprintf>
8010636e:	83 c4 20             	add    $0x20,%esp
            tf->err, cpuid(), tf->eip, rcr2());
    myproc()->killed = 1;
80106371:	e8 ba d6 ff ff       	call   80103a30 <myproc>
80106376:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
8010637d:	eb 01                	jmp    80106380 <trap+0x1da>
    break;
8010637f:	90                   	nop
  }

  // Force process exit if it has been killed and is in user space.
  // (If it is still executing in the kernel, let it keep running
  // until it gets to the regular system call return.)
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80106380:	e8 ab d6 ff ff       	call   80103a30 <myproc>
80106385:	85 c0                	test   %eax,%eax
80106387:	74 23                	je     801063ac <trap+0x206>
80106389:	e8 a2 d6 ff ff       	call   80103a30 <myproc>
8010638e:	8b 40 24             	mov    0x24(%eax),%eax
80106391:	85 c0                	test   %eax,%eax
80106393:	74 17                	je     801063ac <trap+0x206>
80106395:	8b 45 08             	mov    0x8(%ebp),%eax
80106398:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
8010639c:	0f b7 c0             	movzwl %ax,%eax
8010639f:	83 e0 03             	and    $0x3,%eax
801063a2:	83 f8 03             	cmp    $0x3,%eax
801063a5:	75 05                	jne    801063ac <trap+0x206>
    exit();
801063a7:	e8 fc da ff ff       	call   80103ea8 <exit>

  // Force process to give up CPU on clock tick.
  // If interrupts were on while locks held, would need to check nlock.
  if(myproc() && myproc()->state == RUNNING &&
801063ac:	e8 7f d6 ff ff       	call   80103a30 <myproc>
801063b1:	85 c0                	test   %eax,%eax
801063b3:	74 1d                	je     801063d2 <trap+0x22c>
801063b5:	e8 76 d6 ff ff       	call   80103a30 <myproc>
801063ba:	8b 40 0c             	mov    0xc(%eax),%eax
801063bd:	83 f8 04             	cmp    $0x4,%eax
801063c0:	75 10                	jne    801063d2 <trap+0x22c>
     tf->trapno == T_IRQ0+IRQ_TIMER)
801063c2:	8b 45 08             	mov    0x8(%ebp),%eax
801063c5:	8b 40 30             	mov    0x30(%eax),%eax
  if(myproc() && myproc()->state == RUNNING &&
801063c8:	83 f8 20             	cmp    $0x20,%eax
801063cb:	75 05                	jne    801063d2 <trap+0x22c>
    yield();
801063cd:	e8 fb e0 ff ff       	call   801044cd <yield>

  // Check if the process has been killed since we yielded
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
801063d2:	e8 59 d6 ff ff       	call   80103a30 <myproc>
801063d7:	85 c0                	test   %eax,%eax
801063d9:	74 26                	je     80106401 <trap+0x25b>
801063db:	e8 50 d6 ff ff       	call   80103a30 <myproc>
801063e0:	8b 40 24             	mov    0x24(%eax),%eax
801063e3:	85 c0                	test   %eax,%eax
801063e5:	74 1a                	je     80106401 <trap+0x25b>
801063e7:	8b 45 08             	mov    0x8(%ebp),%eax
801063ea:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
801063ee:	0f b7 c0             	movzwl %ax,%eax
801063f1:	83 e0 03             	and    $0x3,%eax
801063f4:	83 f8 03             	cmp    $0x3,%eax
801063f7:	75 08                	jne    80106401 <trap+0x25b>
    exit();
801063f9:	e8 aa da ff ff       	call   80103ea8 <exit>
801063fe:	eb 01                	jmp    80106401 <trap+0x25b>
    return;
80106400:	90                   	nop
}
80106401:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106404:	5b                   	pop    %ebx
80106405:	5e                   	pop    %esi
80106406:	5f                   	pop    %edi
80106407:	5d                   	pop    %ebp
80106408:	c3                   	ret    

80106409 <inb>:
80106409:	55                   	push   %ebp
8010640a:	89 e5                	mov    %esp,%ebp
8010640c:	83 ec 14             	sub    $0x14,%esp
8010640f:	8b 45 08             	mov    0x8(%ebp),%eax
80106412:	66 89 45 ec          	mov    %ax,-0x14(%ebp)
80106416:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
8010641a:	89 c2                	mov    %eax,%edx
8010641c:	ec                   	in     (%dx),%al
8010641d:	88 45 ff             	mov    %al,-0x1(%ebp)
80106420:	0f b6 45 ff          	movzbl -0x1(%ebp),%eax
80106424:	c9                   	leave  
80106425:	c3                   	ret    

80106426 <outb>:
80106426:	55                   	push   %ebp
80106427:	89 e5                	mov    %esp,%ebp
80106429:	83 ec 08             	sub    $0x8,%esp
8010642c:	8b 45 08             	mov    0x8(%ebp),%eax
8010642f:	8b 55 0c             	mov    0xc(%ebp),%edx
80106432:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
80106436:	89 d0                	mov    %edx,%eax
80106438:	88 45 f8             	mov    %al,-0x8(%ebp)
8010643b:	0f b6 45 f8          	movzbl -0x8(%ebp),%eax
8010643f:	0f b7 55 fc          	movzwl -0x4(%ebp),%edx
80106443:	ee                   	out    %al,(%dx)
80106444:	90                   	nop
80106445:	c9                   	leave  
80106446:	c3                   	ret    

80106447 <uartinit>:
80106447:	55                   	push   %ebp
80106448:	89 e5                	mov    %esp,%ebp
8010644a:	83 ec 18             	sub    $0x18,%esp
8010644d:	6a 00                	push   $0x0
8010644f:	68 fa 03 00 00       	push   $0x3fa
80106454:	e8 cd ff ff ff       	call   80106426 <outb>
80106459:	83 c4 08             	add    $0x8,%esp
8010645c:	68 80 00 00 00       	push   $0x80
80106461:	68 fb 03 00 00       	push   $0x3fb
80106466:	e8 bb ff ff ff       	call   80106426 <outb>
8010646b:	83 c4 08             	add    $0x8,%esp
8010646e:	6a 0c                	push   $0xc
80106470:	68 f8 03 00 00       	push   $0x3f8
80106475:	e8 ac ff ff ff       	call   80106426 <outb>
8010647a:	83 c4 08             	add    $0x8,%esp
8010647d:	6a 00                	push   $0x0
8010647f:	68 f9 03 00 00       	push   $0x3f9
80106484:	e8 9d ff ff ff       	call   80106426 <outb>
80106489:	83 c4 08             	add    $0x8,%esp
8010648c:	6a 03                	push   $0x3
8010648e:	68 fb 03 00 00       	push   $0x3fb
80106493:	e8 8e ff ff ff       	call   80106426 <outb>
80106498:	83 c4 08             	add    $0x8,%esp
8010649b:	6a 00                	push   $0x0
8010649d:	68 fc 03 00 00       	push   $0x3fc
801064a2:	e8 7f ff ff ff       	call   80106426 <outb>
801064a7:	83 c4 08             	add    $0x8,%esp
801064aa:	6a 01                	push   $0x1
801064ac:	68 f9 03 00 00       	push   $0x3f9
801064b1:	e8 70 ff ff ff       	call   80106426 <outb>
801064b6:	83 c4 08             	add    $0x8,%esp
801064b9:	68 fd 03 00 00       	push   $0x3fd
801064be:	e8 46 ff ff ff       	call   80106409 <inb>
801064c3:	83 c4 04             	add    $0x4,%esp
801064c6:	3c ff                	cmp    $0xff,%al
801064c8:	74 61                	je     8010652b <uartinit+0xe4>
801064ca:	c7 05 78 6a 19 80 01 	movl   $0x1,0x80196a78
801064d1:	00 00 00 
801064d4:	68 fa 03 00 00       	push   $0x3fa
801064d9:	e8 2b ff ff ff       	call   80106409 <inb>
801064de:	83 c4 04             	add    $0x4,%esp
801064e1:	68 f8 03 00 00       	push   $0x3f8
801064e6:	e8 1e ff ff ff       	call   80106409 <inb>
801064eb:	83 c4 04             	add    $0x4,%esp
801064ee:	83 ec 08             	sub    $0x8,%esp
801064f1:	6a 00                	push   $0x0
801064f3:	6a 04                	push   $0x4
801064f5:	e8 34 c1 ff ff       	call   8010262e <ioapicenable>
801064fa:	83 c4 10             	add    $0x10,%esp
801064fd:	c7 45 f4 c0 a7 10 80 	movl   $0x8010a7c0,-0xc(%ebp)
80106504:	eb 19                	jmp    8010651f <uartinit+0xd8>
80106506:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106509:	0f b6 00             	movzbl (%eax),%eax
8010650c:	0f be c0             	movsbl %al,%eax
8010650f:	83 ec 0c             	sub    $0xc,%esp
80106512:	50                   	push   %eax
80106513:	e8 16 00 00 00       	call   8010652e <uartputc>
80106518:	83 c4 10             	add    $0x10,%esp
8010651b:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
8010651f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106522:	0f b6 00             	movzbl (%eax),%eax
80106525:	84 c0                	test   %al,%al
80106527:	75 dd                	jne    80106506 <uartinit+0xbf>
80106529:	eb 01                	jmp    8010652c <uartinit+0xe5>
8010652b:	90                   	nop
8010652c:	c9                   	leave  
8010652d:	c3                   	ret    

8010652e <uartputc>:
8010652e:	55                   	push   %ebp
8010652f:	89 e5                	mov    %esp,%ebp
80106531:	83 ec 18             	sub    $0x18,%esp
80106534:	a1 78 6a 19 80       	mov    0x80196a78,%eax
80106539:	85 c0                	test   %eax,%eax
8010653b:	74 53                	je     80106590 <uartputc+0x62>
8010653d:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80106544:	eb 11                	jmp    80106557 <uartputc+0x29>
80106546:	83 ec 0c             	sub    $0xc,%esp
80106549:	6a 0a                	push   $0xa
8010654b:	e8 e7 c5 ff ff       	call   80102b37 <microdelay>
80106550:	83 c4 10             	add    $0x10,%esp
80106553:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80106557:	83 7d f4 7f          	cmpl   $0x7f,-0xc(%ebp)
8010655b:	7f 1a                	jg     80106577 <uartputc+0x49>
8010655d:	83 ec 0c             	sub    $0xc,%esp
80106560:	68 fd 03 00 00       	push   $0x3fd
80106565:	e8 9f fe ff ff       	call   80106409 <inb>
8010656a:	83 c4 10             	add    $0x10,%esp
8010656d:	0f b6 c0             	movzbl %al,%eax
80106570:	83 e0 20             	and    $0x20,%eax
80106573:	85 c0                	test   %eax,%eax
80106575:	74 cf                	je     80106546 <uartputc+0x18>
80106577:	8b 45 08             	mov    0x8(%ebp),%eax
8010657a:	0f b6 c0             	movzbl %al,%eax
8010657d:	83 ec 08             	sub    $0x8,%esp
80106580:	50                   	push   %eax
80106581:	68 f8 03 00 00       	push   $0x3f8
80106586:	e8 9b fe ff ff       	call   80106426 <outb>
8010658b:	83 c4 10             	add    $0x10,%esp
8010658e:	eb 01                	jmp    80106591 <uartputc+0x63>
80106590:	90                   	nop
80106591:	c9                   	leave  
80106592:	c3                   	ret    

80106593 <uartgetc>:
80106593:	55                   	push   %ebp
80106594:	89 e5                	mov    %esp,%ebp
80106596:	a1 78 6a 19 80       	mov    0x80196a78,%eax
8010659b:	85 c0                	test   %eax,%eax
8010659d:	75 07                	jne    801065a6 <uartgetc+0x13>
8010659f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801065a4:	eb 2e                	jmp    801065d4 <uartgetc+0x41>
801065a6:	68 fd 03 00 00       	push   $0x3fd
801065ab:	e8 59 fe ff ff       	call   80106409 <inb>
801065b0:	83 c4 04             	add    $0x4,%esp
801065b3:	0f b6 c0             	movzbl %al,%eax
801065b6:	83 e0 01             	and    $0x1,%eax
801065b9:	85 c0                	test   %eax,%eax
801065bb:	75 07                	jne    801065c4 <uartgetc+0x31>
801065bd:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801065c2:	eb 10                	jmp    801065d4 <uartgetc+0x41>
801065c4:	68 f8 03 00 00       	push   $0x3f8
801065c9:	e8 3b fe ff ff       	call   80106409 <inb>
801065ce:	83 c4 04             	add    $0x4,%esp
801065d1:	0f b6 c0             	movzbl %al,%eax
801065d4:	c9                   	leave  
801065d5:	c3                   	ret    

801065d6 <uartintr>:
801065d6:	55                   	push   %ebp
801065d7:	89 e5                	mov    %esp,%ebp
801065d9:	83 ec 08             	sub    $0x8,%esp
801065dc:	83 ec 0c             	sub    $0xc,%esp
801065df:	68 93 65 10 80       	push   $0x80106593
801065e4:	e8 ed a1 ff ff       	call   801007d6 <consoleintr>
801065e9:	83 c4 10             	add    $0x10,%esp
801065ec:	90                   	nop
801065ed:	c9                   	leave  
801065ee:	c3                   	ret    

801065ef <vector0>:
801065ef:	6a 00                	push   $0x0
801065f1:	6a 00                	push   $0x0
801065f3:	e9 c2 f9 ff ff       	jmp    80105fba <alltraps>

801065f8 <vector1>:
801065f8:	6a 00                	push   $0x0
801065fa:	6a 01                	push   $0x1
801065fc:	e9 b9 f9 ff ff       	jmp    80105fba <alltraps>

80106601 <vector2>:
80106601:	6a 00                	push   $0x0
80106603:	6a 02                	push   $0x2
80106605:	e9 b0 f9 ff ff       	jmp    80105fba <alltraps>

8010660a <vector3>:
8010660a:	6a 00                	push   $0x0
8010660c:	6a 03                	push   $0x3
8010660e:	e9 a7 f9 ff ff       	jmp    80105fba <alltraps>

80106613 <vector4>:
80106613:	6a 00                	push   $0x0
80106615:	6a 04                	push   $0x4
80106617:	e9 9e f9 ff ff       	jmp    80105fba <alltraps>

8010661c <vector5>:
8010661c:	6a 00                	push   $0x0
8010661e:	6a 05                	push   $0x5
80106620:	e9 95 f9 ff ff       	jmp    80105fba <alltraps>

80106625 <vector6>:
80106625:	6a 00                	push   $0x0
80106627:	6a 06                	push   $0x6
80106629:	e9 8c f9 ff ff       	jmp    80105fba <alltraps>

8010662e <vector7>:
8010662e:	6a 00                	push   $0x0
80106630:	6a 07                	push   $0x7
80106632:	e9 83 f9 ff ff       	jmp    80105fba <alltraps>

80106637 <vector8>:
80106637:	6a 08                	push   $0x8
80106639:	e9 7c f9 ff ff       	jmp    80105fba <alltraps>

8010663e <vector9>:
8010663e:	6a 00                	push   $0x0
80106640:	6a 09                	push   $0x9
80106642:	e9 73 f9 ff ff       	jmp    80105fba <alltraps>

80106647 <vector10>:
80106647:	6a 0a                	push   $0xa
80106649:	e9 6c f9 ff ff       	jmp    80105fba <alltraps>

8010664e <vector11>:
8010664e:	6a 0b                	push   $0xb
80106650:	e9 65 f9 ff ff       	jmp    80105fba <alltraps>

80106655 <vector12>:
80106655:	6a 0c                	push   $0xc
80106657:	e9 5e f9 ff ff       	jmp    80105fba <alltraps>

8010665c <vector13>:
8010665c:	6a 0d                	push   $0xd
8010665e:	e9 57 f9 ff ff       	jmp    80105fba <alltraps>

80106663 <vector14>:
80106663:	6a 0e                	push   $0xe
80106665:	e9 50 f9 ff ff       	jmp    80105fba <alltraps>

8010666a <vector15>:
8010666a:	6a 00                	push   $0x0
8010666c:	6a 0f                	push   $0xf
8010666e:	e9 47 f9 ff ff       	jmp    80105fba <alltraps>

80106673 <vector16>:
80106673:	6a 00                	push   $0x0
80106675:	6a 10                	push   $0x10
80106677:	e9 3e f9 ff ff       	jmp    80105fba <alltraps>

8010667c <vector17>:
8010667c:	6a 11                	push   $0x11
8010667e:	e9 37 f9 ff ff       	jmp    80105fba <alltraps>

80106683 <vector18>:
80106683:	6a 00                	push   $0x0
80106685:	6a 12                	push   $0x12
80106687:	e9 2e f9 ff ff       	jmp    80105fba <alltraps>

8010668c <vector19>:
8010668c:	6a 00                	push   $0x0
8010668e:	6a 13                	push   $0x13
80106690:	e9 25 f9 ff ff       	jmp    80105fba <alltraps>

80106695 <vector20>:
80106695:	6a 00                	push   $0x0
80106697:	6a 14                	push   $0x14
80106699:	e9 1c f9 ff ff       	jmp    80105fba <alltraps>

8010669e <vector21>:
8010669e:	6a 00                	push   $0x0
801066a0:	6a 15                	push   $0x15
801066a2:	e9 13 f9 ff ff       	jmp    80105fba <alltraps>

801066a7 <vector22>:
801066a7:	6a 00                	push   $0x0
801066a9:	6a 16                	push   $0x16
801066ab:	e9 0a f9 ff ff       	jmp    80105fba <alltraps>

801066b0 <vector23>:
801066b0:	6a 00                	push   $0x0
801066b2:	6a 17                	push   $0x17
801066b4:	e9 01 f9 ff ff       	jmp    80105fba <alltraps>

801066b9 <vector24>:
801066b9:	6a 00                	push   $0x0
801066bb:	6a 18                	push   $0x18
801066bd:	e9 f8 f8 ff ff       	jmp    80105fba <alltraps>

801066c2 <vector25>:
801066c2:	6a 00                	push   $0x0
801066c4:	6a 19                	push   $0x19
801066c6:	e9 ef f8 ff ff       	jmp    80105fba <alltraps>

801066cb <vector26>:
801066cb:	6a 00                	push   $0x0
801066cd:	6a 1a                	push   $0x1a
801066cf:	e9 e6 f8 ff ff       	jmp    80105fba <alltraps>

801066d4 <vector27>:
801066d4:	6a 00                	push   $0x0
801066d6:	6a 1b                	push   $0x1b
801066d8:	e9 dd f8 ff ff       	jmp    80105fba <alltraps>

801066dd <vector28>:
801066dd:	6a 00                	push   $0x0
801066df:	6a 1c                	push   $0x1c
801066e1:	e9 d4 f8 ff ff       	jmp    80105fba <alltraps>

801066e6 <vector29>:
801066e6:	6a 00                	push   $0x0
801066e8:	6a 1d                	push   $0x1d
801066ea:	e9 cb f8 ff ff       	jmp    80105fba <alltraps>

801066ef <vector30>:
801066ef:	6a 00                	push   $0x0
801066f1:	6a 1e                	push   $0x1e
801066f3:	e9 c2 f8 ff ff       	jmp    80105fba <alltraps>

801066f8 <vector31>:
801066f8:	6a 00                	push   $0x0
801066fa:	6a 1f                	push   $0x1f
801066fc:	e9 b9 f8 ff ff       	jmp    80105fba <alltraps>

80106701 <vector32>:
80106701:	6a 00                	push   $0x0
80106703:	6a 20                	push   $0x20
80106705:	e9 b0 f8 ff ff       	jmp    80105fba <alltraps>

8010670a <vector33>:
8010670a:	6a 00                	push   $0x0
8010670c:	6a 21                	push   $0x21
8010670e:	e9 a7 f8 ff ff       	jmp    80105fba <alltraps>

80106713 <vector34>:
80106713:	6a 00                	push   $0x0
80106715:	6a 22                	push   $0x22
80106717:	e9 9e f8 ff ff       	jmp    80105fba <alltraps>

8010671c <vector35>:
8010671c:	6a 00                	push   $0x0
8010671e:	6a 23                	push   $0x23
80106720:	e9 95 f8 ff ff       	jmp    80105fba <alltraps>

80106725 <vector36>:
80106725:	6a 00                	push   $0x0
80106727:	6a 24                	push   $0x24
80106729:	e9 8c f8 ff ff       	jmp    80105fba <alltraps>

8010672e <vector37>:
8010672e:	6a 00                	push   $0x0
80106730:	6a 25                	push   $0x25
80106732:	e9 83 f8 ff ff       	jmp    80105fba <alltraps>

80106737 <vector38>:
80106737:	6a 00                	push   $0x0
80106739:	6a 26                	push   $0x26
8010673b:	e9 7a f8 ff ff       	jmp    80105fba <alltraps>

80106740 <vector39>:
80106740:	6a 00                	push   $0x0
80106742:	6a 27                	push   $0x27
80106744:	e9 71 f8 ff ff       	jmp    80105fba <alltraps>

80106749 <vector40>:
80106749:	6a 00                	push   $0x0
8010674b:	6a 28                	push   $0x28
8010674d:	e9 68 f8 ff ff       	jmp    80105fba <alltraps>

80106752 <vector41>:
80106752:	6a 00                	push   $0x0
80106754:	6a 29                	push   $0x29
80106756:	e9 5f f8 ff ff       	jmp    80105fba <alltraps>

8010675b <vector42>:
8010675b:	6a 00                	push   $0x0
8010675d:	6a 2a                	push   $0x2a
8010675f:	e9 56 f8 ff ff       	jmp    80105fba <alltraps>

80106764 <vector43>:
80106764:	6a 00                	push   $0x0
80106766:	6a 2b                	push   $0x2b
80106768:	e9 4d f8 ff ff       	jmp    80105fba <alltraps>

8010676d <vector44>:
8010676d:	6a 00                	push   $0x0
8010676f:	6a 2c                	push   $0x2c
80106771:	e9 44 f8 ff ff       	jmp    80105fba <alltraps>

80106776 <vector45>:
80106776:	6a 00                	push   $0x0
80106778:	6a 2d                	push   $0x2d
8010677a:	e9 3b f8 ff ff       	jmp    80105fba <alltraps>

8010677f <vector46>:
8010677f:	6a 00                	push   $0x0
80106781:	6a 2e                	push   $0x2e
80106783:	e9 32 f8 ff ff       	jmp    80105fba <alltraps>

80106788 <vector47>:
80106788:	6a 00                	push   $0x0
8010678a:	6a 2f                	push   $0x2f
8010678c:	e9 29 f8 ff ff       	jmp    80105fba <alltraps>

80106791 <vector48>:
80106791:	6a 00                	push   $0x0
80106793:	6a 30                	push   $0x30
80106795:	e9 20 f8 ff ff       	jmp    80105fba <alltraps>

8010679a <vector49>:
8010679a:	6a 00                	push   $0x0
8010679c:	6a 31                	push   $0x31
8010679e:	e9 17 f8 ff ff       	jmp    80105fba <alltraps>

801067a3 <vector50>:
801067a3:	6a 00                	push   $0x0
801067a5:	6a 32                	push   $0x32
801067a7:	e9 0e f8 ff ff       	jmp    80105fba <alltraps>

801067ac <vector51>:
801067ac:	6a 00                	push   $0x0
801067ae:	6a 33                	push   $0x33
801067b0:	e9 05 f8 ff ff       	jmp    80105fba <alltraps>

801067b5 <vector52>:
801067b5:	6a 00                	push   $0x0
801067b7:	6a 34                	push   $0x34
801067b9:	e9 fc f7 ff ff       	jmp    80105fba <alltraps>

801067be <vector53>:
801067be:	6a 00                	push   $0x0
801067c0:	6a 35                	push   $0x35
801067c2:	e9 f3 f7 ff ff       	jmp    80105fba <alltraps>

801067c7 <vector54>:
801067c7:	6a 00                	push   $0x0
801067c9:	6a 36                	push   $0x36
801067cb:	e9 ea f7 ff ff       	jmp    80105fba <alltraps>

801067d0 <vector55>:
801067d0:	6a 00                	push   $0x0
801067d2:	6a 37                	push   $0x37
801067d4:	e9 e1 f7 ff ff       	jmp    80105fba <alltraps>

801067d9 <vector56>:
801067d9:	6a 00                	push   $0x0
801067db:	6a 38                	push   $0x38
801067dd:	e9 d8 f7 ff ff       	jmp    80105fba <alltraps>

801067e2 <vector57>:
801067e2:	6a 00                	push   $0x0
801067e4:	6a 39                	push   $0x39
801067e6:	e9 cf f7 ff ff       	jmp    80105fba <alltraps>

801067eb <vector58>:
801067eb:	6a 00                	push   $0x0
801067ed:	6a 3a                	push   $0x3a
801067ef:	e9 c6 f7 ff ff       	jmp    80105fba <alltraps>

801067f4 <vector59>:
801067f4:	6a 00                	push   $0x0
801067f6:	6a 3b                	push   $0x3b
801067f8:	e9 bd f7 ff ff       	jmp    80105fba <alltraps>

801067fd <vector60>:
801067fd:	6a 00                	push   $0x0
801067ff:	6a 3c                	push   $0x3c
80106801:	e9 b4 f7 ff ff       	jmp    80105fba <alltraps>

80106806 <vector61>:
80106806:	6a 00                	push   $0x0
80106808:	6a 3d                	push   $0x3d
8010680a:	e9 ab f7 ff ff       	jmp    80105fba <alltraps>

8010680f <vector62>:
8010680f:	6a 00                	push   $0x0
80106811:	6a 3e                	push   $0x3e
80106813:	e9 a2 f7 ff ff       	jmp    80105fba <alltraps>

80106818 <vector63>:
80106818:	6a 00                	push   $0x0
8010681a:	6a 3f                	push   $0x3f
8010681c:	e9 99 f7 ff ff       	jmp    80105fba <alltraps>

80106821 <vector64>:
80106821:	6a 00                	push   $0x0
80106823:	6a 40                	push   $0x40
80106825:	e9 90 f7 ff ff       	jmp    80105fba <alltraps>

8010682a <vector65>:
8010682a:	6a 00                	push   $0x0
8010682c:	6a 41                	push   $0x41
8010682e:	e9 87 f7 ff ff       	jmp    80105fba <alltraps>

80106833 <vector66>:
80106833:	6a 00                	push   $0x0
80106835:	6a 42                	push   $0x42
80106837:	e9 7e f7 ff ff       	jmp    80105fba <alltraps>

8010683c <vector67>:
8010683c:	6a 00                	push   $0x0
8010683e:	6a 43                	push   $0x43
80106840:	e9 75 f7 ff ff       	jmp    80105fba <alltraps>

80106845 <vector68>:
80106845:	6a 00                	push   $0x0
80106847:	6a 44                	push   $0x44
80106849:	e9 6c f7 ff ff       	jmp    80105fba <alltraps>

8010684e <vector69>:
8010684e:	6a 00                	push   $0x0
80106850:	6a 45                	push   $0x45
80106852:	e9 63 f7 ff ff       	jmp    80105fba <alltraps>

80106857 <vector70>:
80106857:	6a 00                	push   $0x0
80106859:	6a 46                	push   $0x46
8010685b:	e9 5a f7 ff ff       	jmp    80105fba <alltraps>

80106860 <vector71>:
80106860:	6a 00                	push   $0x0
80106862:	6a 47                	push   $0x47
80106864:	e9 51 f7 ff ff       	jmp    80105fba <alltraps>

80106869 <vector72>:
80106869:	6a 00                	push   $0x0
8010686b:	6a 48                	push   $0x48
8010686d:	e9 48 f7 ff ff       	jmp    80105fba <alltraps>

80106872 <vector73>:
80106872:	6a 00                	push   $0x0
80106874:	6a 49                	push   $0x49
80106876:	e9 3f f7 ff ff       	jmp    80105fba <alltraps>

8010687b <vector74>:
8010687b:	6a 00                	push   $0x0
8010687d:	6a 4a                	push   $0x4a
8010687f:	e9 36 f7 ff ff       	jmp    80105fba <alltraps>

80106884 <vector75>:
80106884:	6a 00                	push   $0x0
80106886:	6a 4b                	push   $0x4b
80106888:	e9 2d f7 ff ff       	jmp    80105fba <alltraps>

8010688d <vector76>:
8010688d:	6a 00                	push   $0x0
8010688f:	6a 4c                	push   $0x4c
80106891:	e9 24 f7 ff ff       	jmp    80105fba <alltraps>

80106896 <vector77>:
80106896:	6a 00                	push   $0x0
80106898:	6a 4d                	push   $0x4d
8010689a:	e9 1b f7 ff ff       	jmp    80105fba <alltraps>

8010689f <vector78>:
8010689f:	6a 00                	push   $0x0
801068a1:	6a 4e                	push   $0x4e
801068a3:	e9 12 f7 ff ff       	jmp    80105fba <alltraps>

801068a8 <vector79>:
801068a8:	6a 00                	push   $0x0
801068aa:	6a 4f                	push   $0x4f
801068ac:	e9 09 f7 ff ff       	jmp    80105fba <alltraps>

801068b1 <vector80>:
801068b1:	6a 00                	push   $0x0
801068b3:	6a 50                	push   $0x50
801068b5:	e9 00 f7 ff ff       	jmp    80105fba <alltraps>

801068ba <vector81>:
801068ba:	6a 00                	push   $0x0
801068bc:	6a 51                	push   $0x51
801068be:	e9 f7 f6 ff ff       	jmp    80105fba <alltraps>

801068c3 <vector82>:
801068c3:	6a 00                	push   $0x0
801068c5:	6a 52                	push   $0x52
801068c7:	e9 ee f6 ff ff       	jmp    80105fba <alltraps>

801068cc <vector83>:
801068cc:	6a 00                	push   $0x0
801068ce:	6a 53                	push   $0x53
801068d0:	e9 e5 f6 ff ff       	jmp    80105fba <alltraps>

801068d5 <vector84>:
801068d5:	6a 00                	push   $0x0
801068d7:	6a 54                	push   $0x54
801068d9:	e9 dc f6 ff ff       	jmp    80105fba <alltraps>

801068de <vector85>:
801068de:	6a 00                	push   $0x0
801068e0:	6a 55                	push   $0x55
801068e2:	e9 d3 f6 ff ff       	jmp    80105fba <alltraps>

801068e7 <vector86>:
801068e7:	6a 00                	push   $0x0
801068e9:	6a 56                	push   $0x56
801068eb:	e9 ca f6 ff ff       	jmp    80105fba <alltraps>

801068f0 <vector87>:
801068f0:	6a 00                	push   $0x0
801068f2:	6a 57                	push   $0x57
801068f4:	e9 c1 f6 ff ff       	jmp    80105fba <alltraps>

801068f9 <vector88>:
801068f9:	6a 00                	push   $0x0
801068fb:	6a 58                	push   $0x58
801068fd:	e9 b8 f6 ff ff       	jmp    80105fba <alltraps>

80106902 <vector89>:
80106902:	6a 00                	push   $0x0
80106904:	6a 59                	push   $0x59
80106906:	e9 af f6 ff ff       	jmp    80105fba <alltraps>

8010690b <vector90>:
8010690b:	6a 00                	push   $0x0
8010690d:	6a 5a                	push   $0x5a
8010690f:	e9 a6 f6 ff ff       	jmp    80105fba <alltraps>

80106914 <vector91>:
80106914:	6a 00                	push   $0x0
80106916:	6a 5b                	push   $0x5b
80106918:	e9 9d f6 ff ff       	jmp    80105fba <alltraps>

8010691d <vector92>:
8010691d:	6a 00                	push   $0x0
8010691f:	6a 5c                	push   $0x5c
80106921:	e9 94 f6 ff ff       	jmp    80105fba <alltraps>

80106926 <vector93>:
80106926:	6a 00                	push   $0x0
80106928:	6a 5d                	push   $0x5d
8010692a:	e9 8b f6 ff ff       	jmp    80105fba <alltraps>

8010692f <vector94>:
8010692f:	6a 00                	push   $0x0
80106931:	6a 5e                	push   $0x5e
80106933:	e9 82 f6 ff ff       	jmp    80105fba <alltraps>

80106938 <vector95>:
80106938:	6a 00                	push   $0x0
8010693a:	6a 5f                	push   $0x5f
8010693c:	e9 79 f6 ff ff       	jmp    80105fba <alltraps>

80106941 <vector96>:
80106941:	6a 00                	push   $0x0
80106943:	6a 60                	push   $0x60
80106945:	e9 70 f6 ff ff       	jmp    80105fba <alltraps>

8010694a <vector97>:
8010694a:	6a 00                	push   $0x0
8010694c:	6a 61                	push   $0x61
8010694e:	e9 67 f6 ff ff       	jmp    80105fba <alltraps>

80106953 <vector98>:
80106953:	6a 00                	push   $0x0
80106955:	6a 62                	push   $0x62
80106957:	e9 5e f6 ff ff       	jmp    80105fba <alltraps>

8010695c <vector99>:
8010695c:	6a 00                	push   $0x0
8010695e:	6a 63                	push   $0x63
80106960:	e9 55 f6 ff ff       	jmp    80105fba <alltraps>

80106965 <vector100>:
80106965:	6a 00                	push   $0x0
80106967:	6a 64                	push   $0x64
80106969:	e9 4c f6 ff ff       	jmp    80105fba <alltraps>

8010696e <vector101>:
8010696e:	6a 00                	push   $0x0
80106970:	6a 65                	push   $0x65
80106972:	e9 43 f6 ff ff       	jmp    80105fba <alltraps>

80106977 <vector102>:
80106977:	6a 00                	push   $0x0
80106979:	6a 66                	push   $0x66
8010697b:	e9 3a f6 ff ff       	jmp    80105fba <alltraps>

80106980 <vector103>:
80106980:	6a 00                	push   $0x0
80106982:	6a 67                	push   $0x67
80106984:	e9 31 f6 ff ff       	jmp    80105fba <alltraps>

80106989 <vector104>:
80106989:	6a 00                	push   $0x0
8010698b:	6a 68                	push   $0x68
8010698d:	e9 28 f6 ff ff       	jmp    80105fba <alltraps>

80106992 <vector105>:
80106992:	6a 00                	push   $0x0
80106994:	6a 69                	push   $0x69
80106996:	e9 1f f6 ff ff       	jmp    80105fba <alltraps>

8010699b <vector106>:
8010699b:	6a 00                	push   $0x0
8010699d:	6a 6a                	push   $0x6a
8010699f:	e9 16 f6 ff ff       	jmp    80105fba <alltraps>

801069a4 <vector107>:
801069a4:	6a 00                	push   $0x0
801069a6:	6a 6b                	push   $0x6b
801069a8:	e9 0d f6 ff ff       	jmp    80105fba <alltraps>

801069ad <vector108>:
801069ad:	6a 00                	push   $0x0
801069af:	6a 6c                	push   $0x6c
801069b1:	e9 04 f6 ff ff       	jmp    80105fba <alltraps>

801069b6 <vector109>:
801069b6:	6a 00                	push   $0x0
801069b8:	6a 6d                	push   $0x6d
801069ba:	e9 fb f5 ff ff       	jmp    80105fba <alltraps>

801069bf <vector110>:
801069bf:	6a 00                	push   $0x0
801069c1:	6a 6e                	push   $0x6e
801069c3:	e9 f2 f5 ff ff       	jmp    80105fba <alltraps>

801069c8 <vector111>:
801069c8:	6a 00                	push   $0x0
801069ca:	6a 6f                	push   $0x6f
801069cc:	e9 e9 f5 ff ff       	jmp    80105fba <alltraps>

801069d1 <vector112>:
801069d1:	6a 00                	push   $0x0
801069d3:	6a 70                	push   $0x70
801069d5:	e9 e0 f5 ff ff       	jmp    80105fba <alltraps>

801069da <vector113>:
801069da:	6a 00                	push   $0x0
801069dc:	6a 71                	push   $0x71
801069de:	e9 d7 f5 ff ff       	jmp    80105fba <alltraps>

801069e3 <vector114>:
801069e3:	6a 00                	push   $0x0
801069e5:	6a 72                	push   $0x72
801069e7:	e9 ce f5 ff ff       	jmp    80105fba <alltraps>

801069ec <vector115>:
801069ec:	6a 00                	push   $0x0
801069ee:	6a 73                	push   $0x73
801069f0:	e9 c5 f5 ff ff       	jmp    80105fba <alltraps>

801069f5 <vector116>:
801069f5:	6a 00                	push   $0x0
801069f7:	6a 74                	push   $0x74
801069f9:	e9 bc f5 ff ff       	jmp    80105fba <alltraps>

801069fe <vector117>:
801069fe:	6a 00                	push   $0x0
80106a00:	6a 75                	push   $0x75
80106a02:	e9 b3 f5 ff ff       	jmp    80105fba <alltraps>

80106a07 <vector118>:
80106a07:	6a 00                	push   $0x0
80106a09:	6a 76                	push   $0x76
80106a0b:	e9 aa f5 ff ff       	jmp    80105fba <alltraps>

80106a10 <vector119>:
80106a10:	6a 00                	push   $0x0
80106a12:	6a 77                	push   $0x77
80106a14:	e9 a1 f5 ff ff       	jmp    80105fba <alltraps>

80106a19 <vector120>:
80106a19:	6a 00                	push   $0x0
80106a1b:	6a 78                	push   $0x78
80106a1d:	e9 98 f5 ff ff       	jmp    80105fba <alltraps>

80106a22 <vector121>:
80106a22:	6a 00                	push   $0x0
80106a24:	6a 79                	push   $0x79
80106a26:	e9 8f f5 ff ff       	jmp    80105fba <alltraps>

80106a2b <vector122>:
80106a2b:	6a 00                	push   $0x0
80106a2d:	6a 7a                	push   $0x7a
80106a2f:	e9 86 f5 ff ff       	jmp    80105fba <alltraps>

80106a34 <vector123>:
80106a34:	6a 00                	push   $0x0
80106a36:	6a 7b                	push   $0x7b
80106a38:	e9 7d f5 ff ff       	jmp    80105fba <alltraps>

80106a3d <vector124>:
80106a3d:	6a 00                	push   $0x0
80106a3f:	6a 7c                	push   $0x7c
80106a41:	e9 74 f5 ff ff       	jmp    80105fba <alltraps>

80106a46 <vector125>:
80106a46:	6a 00                	push   $0x0
80106a48:	6a 7d                	push   $0x7d
80106a4a:	e9 6b f5 ff ff       	jmp    80105fba <alltraps>

80106a4f <vector126>:
80106a4f:	6a 00                	push   $0x0
80106a51:	6a 7e                	push   $0x7e
80106a53:	e9 62 f5 ff ff       	jmp    80105fba <alltraps>

80106a58 <vector127>:
80106a58:	6a 00                	push   $0x0
80106a5a:	6a 7f                	push   $0x7f
80106a5c:	e9 59 f5 ff ff       	jmp    80105fba <alltraps>

80106a61 <vector128>:
80106a61:	6a 00                	push   $0x0
80106a63:	68 80 00 00 00       	push   $0x80
80106a68:	e9 4d f5 ff ff       	jmp    80105fba <alltraps>

80106a6d <vector129>:
80106a6d:	6a 00                	push   $0x0
80106a6f:	68 81 00 00 00       	push   $0x81
80106a74:	e9 41 f5 ff ff       	jmp    80105fba <alltraps>

80106a79 <vector130>:
80106a79:	6a 00                	push   $0x0
80106a7b:	68 82 00 00 00       	push   $0x82
80106a80:	e9 35 f5 ff ff       	jmp    80105fba <alltraps>

80106a85 <vector131>:
80106a85:	6a 00                	push   $0x0
80106a87:	68 83 00 00 00       	push   $0x83
80106a8c:	e9 29 f5 ff ff       	jmp    80105fba <alltraps>

80106a91 <vector132>:
80106a91:	6a 00                	push   $0x0
80106a93:	68 84 00 00 00       	push   $0x84
80106a98:	e9 1d f5 ff ff       	jmp    80105fba <alltraps>

80106a9d <vector133>:
80106a9d:	6a 00                	push   $0x0
80106a9f:	68 85 00 00 00       	push   $0x85
80106aa4:	e9 11 f5 ff ff       	jmp    80105fba <alltraps>

80106aa9 <vector134>:
80106aa9:	6a 00                	push   $0x0
80106aab:	68 86 00 00 00       	push   $0x86
80106ab0:	e9 05 f5 ff ff       	jmp    80105fba <alltraps>

80106ab5 <vector135>:
80106ab5:	6a 00                	push   $0x0
80106ab7:	68 87 00 00 00       	push   $0x87
80106abc:	e9 f9 f4 ff ff       	jmp    80105fba <alltraps>

80106ac1 <vector136>:
80106ac1:	6a 00                	push   $0x0
80106ac3:	68 88 00 00 00       	push   $0x88
80106ac8:	e9 ed f4 ff ff       	jmp    80105fba <alltraps>

80106acd <vector137>:
80106acd:	6a 00                	push   $0x0
80106acf:	68 89 00 00 00       	push   $0x89
80106ad4:	e9 e1 f4 ff ff       	jmp    80105fba <alltraps>

80106ad9 <vector138>:
80106ad9:	6a 00                	push   $0x0
80106adb:	68 8a 00 00 00       	push   $0x8a
80106ae0:	e9 d5 f4 ff ff       	jmp    80105fba <alltraps>

80106ae5 <vector139>:
80106ae5:	6a 00                	push   $0x0
80106ae7:	68 8b 00 00 00       	push   $0x8b
80106aec:	e9 c9 f4 ff ff       	jmp    80105fba <alltraps>

80106af1 <vector140>:
80106af1:	6a 00                	push   $0x0
80106af3:	68 8c 00 00 00       	push   $0x8c
80106af8:	e9 bd f4 ff ff       	jmp    80105fba <alltraps>

80106afd <vector141>:
80106afd:	6a 00                	push   $0x0
80106aff:	68 8d 00 00 00       	push   $0x8d
80106b04:	e9 b1 f4 ff ff       	jmp    80105fba <alltraps>

80106b09 <vector142>:
80106b09:	6a 00                	push   $0x0
80106b0b:	68 8e 00 00 00       	push   $0x8e
80106b10:	e9 a5 f4 ff ff       	jmp    80105fba <alltraps>

80106b15 <vector143>:
80106b15:	6a 00                	push   $0x0
80106b17:	68 8f 00 00 00       	push   $0x8f
80106b1c:	e9 99 f4 ff ff       	jmp    80105fba <alltraps>

80106b21 <vector144>:
80106b21:	6a 00                	push   $0x0
80106b23:	68 90 00 00 00       	push   $0x90
80106b28:	e9 8d f4 ff ff       	jmp    80105fba <alltraps>

80106b2d <vector145>:
80106b2d:	6a 00                	push   $0x0
80106b2f:	68 91 00 00 00       	push   $0x91
80106b34:	e9 81 f4 ff ff       	jmp    80105fba <alltraps>

80106b39 <vector146>:
80106b39:	6a 00                	push   $0x0
80106b3b:	68 92 00 00 00       	push   $0x92
80106b40:	e9 75 f4 ff ff       	jmp    80105fba <alltraps>

80106b45 <vector147>:
80106b45:	6a 00                	push   $0x0
80106b47:	68 93 00 00 00       	push   $0x93
80106b4c:	e9 69 f4 ff ff       	jmp    80105fba <alltraps>

80106b51 <vector148>:
80106b51:	6a 00                	push   $0x0
80106b53:	68 94 00 00 00       	push   $0x94
80106b58:	e9 5d f4 ff ff       	jmp    80105fba <alltraps>

80106b5d <vector149>:
80106b5d:	6a 00                	push   $0x0
80106b5f:	68 95 00 00 00       	push   $0x95
80106b64:	e9 51 f4 ff ff       	jmp    80105fba <alltraps>

80106b69 <vector150>:
80106b69:	6a 00                	push   $0x0
80106b6b:	68 96 00 00 00       	push   $0x96
80106b70:	e9 45 f4 ff ff       	jmp    80105fba <alltraps>

80106b75 <vector151>:
80106b75:	6a 00                	push   $0x0
80106b77:	68 97 00 00 00       	push   $0x97
80106b7c:	e9 39 f4 ff ff       	jmp    80105fba <alltraps>

80106b81 <vector152>:
80106b81:	6a 00                	push   $0x0
80106b83:	68 98 00 00 00       	push   $0x98
80106b88:	e9 2d f4 ff ff       	jmp    80105fba <alltraps>

80106b8d <vector153>:
80106b8d:	6a 00                	push   $0x0
80106b8f:	68 99 00 00 00       	push   $0x99
80106b94:	e9 21 f4 ff ff       	jmp    80105fba <alltraps>

80106b99 <vector154>:
80106b99:	6a 00                	push   $0x0
80106b9b:	68 9a 00 00 00       	push   $0x9a
80106ba0:	e9 15 f4 ff ff       	jmp    80105fba <alltraps>

80106ba5 <vector155>:
80106ba5:	6a 00                	push   $0x0
80106ba7:	68 9b 00 00 00       	push   $0x9b
80106bac:	e9 09 f4 ff ff       	jmp    80105fba <alltraps>

80106bb1 <vector156>:
80106bb1:	6a 00                	push   $0x0
80106bb3:	68 9c 00 00 00       	push   $0x9c
80106bb8:	e9 fd f3 ff ff       	jmp    80105fba <alltraps>

80106bbd <vector157>:
80106bbd:	6a 00                	push   $0x0
80106bbf:	68 9d 00 00 00       	push   $0x9d
80106bc4:	e9 f1 f3 ff ff       	jmp    80105fba <alltraps>

80106bc9 <vector158>:
80106bc9:	6a 00                	push   $0x0
80106bcb:	68 9e 00 00 00       	push   $0x9e
80106bd0:	e9 e5 f3 ff ff       	jmp    80105fba <alltraps>

80106bd5 <vector159>:
80106bd5:	6a 00                	push   $0x0
80106bd7:	68 9f 00 00 00       	push   $0x9f
80106bdc:	e9 d9 f3 ff ff       	jmp    80105fba <alltraps>

80106be1 <vector160>:
80106be1:	6a 00                	push   $0x0
80106be3:	68 a0 00 00 00       	push   $0xa0
80106be8:	e9 cd f3 ff ff       	jmp    80105fba <alltraps>

80106bed <vector161>:
80106bed:	6a 00                	push   $0x0
80106bef:	68 a1 00 00 00       	push   $0xa1
80106bf4:	e9 c1 f3 ff ff       	jmp    80105fba <alltraps>

80106bf9 <vector162>:
80106bf9:	6a 00                	push   $0x0
80106bfb:	68 a2 00 00 00       	push   $0xa2
80106c00:	e9 b5 f3 ff ff       	jmp    80105fba <alltraps>

80106c05 <vector163>:
80106c05:	6a 00                	push   $0x0
80106c07:	68 a3 00 00 00       	push   $0xa3
80106c0c:	e9 a9 f3 ff ff       	jmp    80105fba <alltraps>

80106c11 <vector164>:
80106c11:	6a 00                	push   $0x0
80106c13:	68 a4 00 00 00       	push   $0xa4
80106c18:	e9 9d f3 ff ff       	jmp    80105fba <alltraps>

80106c1d <vector165>:
80106c1d:	6a 00                	push   $0x0
80106c1f:	68 a5 00 00 00       	push   $0xa5
80106c24:	e9 91 f3 ff ff       	jmp    80105fba <alltraps>

80106c29 <vector166>:
80106c29:	6a 00                	push   $0x0
80106c2b:	68 a6 00 00 00       	push   $0xa6
80106c30:	e9 85 f3 ff ff       	jmp    80105fba <alltraps>

80106c35 <vector167>:
80106c35:	6a 00                	push   $0x0
80106c37:	68 a7 00 00 00       	push   $0xa7
80106c3c:	e9 79 f3 ff ff       	jmp    80105fba <alltraps>

80106c41 <vector168>:
80106c41:	6a 00                	push   $0x0
80106c43:	68 a8 00 00 00       	push   $0xa8
80106c48:	e9 6d f3 ff ff       	jmp    80105fba <alltraps>

80106c4d <vector169>:
80106c4d:	6a 00                	push   $0x0
80106c4f:	68 a9 00 00 00       	push   $0xa9
80106c54:	e9 61 f3 ff ff       	jmp    80105fba <alltraps>

80106c59 <vector170>:
80106c59:	6a 00                	push   $0x0
80106c5b:	68 aa 00 00 00       	push   $0xaa
80106c60:	e9 55 f3 ff ff       	jmp    80105fba <alltraps>

80106c65 <vector171>:
80106c65:	6a 00                	push   $0x0
80106c67:	68 ab 00 00 00       	push   $0xab
80106c6c:	e9 49 f3 ff ff       	jmp    80105fba <alltraps>

80106c71 <vector172>:
80106c71:	6a 00                	push   $0x0
80106c73:	68 ac 00 00 00       	push   $0xac
80106c78:	e9 3d f3 ff ff       	jmp    80105fba <alltraps>

80106c7d <vector173>:
80106c7d:	6a 00                	push   $0x0
80106c7f:	68 ad 00 00 00       	push   $0xad
80106c84:	e9 31 f3 ff ff       	jmp    80105fba <alltraps>

80106c89 <vector174>:
80106c89:	6a 00                	push   $0x0
80106c8b:	68 ae 00 00 00       	push   $0xae
80106c90:	e9 25 f3 ff ff       	jmp    80105fba <alltraps>

80106c95 <vector175>:
80106c95:	6a 00                	push   $0x0
80106c97:	68 af 00 00 00       	push   $0xaf
80106c9c:	e9 19 f3 ff ff       	jmp    80105fba <alltraps>

80106ca1 <vector176>:
80106ca1:	6a 00                	push   $0x0
80106ca3:	68 b0 00 00 00       	push   $0xb0
80106ca8:	e9 0d f3 ff ff       	jmp    80105fba <alltraps>

80106cad <vector177>:
80106cad:	6a 00                	push   $0x0
80106caf:	68 b1 00 00 00       	push   $0xb1
80106cb4:	e9 01 f3 ff ff       	jmp    80105fba <alltraps>

80106cb9 <vector178>:
80106cb9:	6a 00                	push   $0x0
80106cbb:	68 b2 00 00 00       	push   $0xb2
80106cc0:	e9 f5 f2 ff ff       	jmp    80105fba <alltraps>

80106cc5 <vector179>:
80106cc5:	6a 00                	push   $0x0
80106cc7:	68 b3 00 00 00       	push   $0xb3
80106ccc:	e9 e9 f2 ff ff       	jmp    80105fba <alltraps>

80106cd1 <vector180>:
80106cd1:	6a 00                	push   $0x0
80106cd3:	68 b4 00 00 00       	push   $0xb4
80106cd8:	e9 dd f2 ff ff       	jmp    80105fba <alltraps>

80106cdd <vector181>:
80106cdd:	6a 00                	push   $0x0
80106cdf:	68 b5 00 00 00       	push   $0xb5
80106ce4:	e9 d1 f2 ff ff       	jmp    80105fba <alltraps>

80106ce9 <vector182>:
80106ce9:	6a 00                	push   $0x0
80106ceb:	68 b6 00 00 00       	push   $0xb6
80106cf0:	e9 c5 f2 ff ff       	jmp    80105fba <alltraps>

80106cf5 <vector183>:
80106cf5:	6a 00                	push   $0x0
80106cf7:	68 b7 00 00 00       	push   $0xb7
80106cfc:	e9 b9 f2 ff ff       	jmp    80105fba <alltraps>

80106d01 <vector184>:
80106d01:	6a 00                	push   $0x0
80106d03:	68 b8 00 00 00       	push   $0xb8
80106d08:	e9 ad f2 ff ff       	jmp    80105fba <alltraps>

80106d0d <vector185>:
80106d0d:	6a 00                	push   $0x0
80106d0f:	68 b9 00 00 00       	push   $0xb9
80106d14:	e9 a1 f2 ff ff       	jmp    80105fba <alltraps>

80106d19 <vector186>:
80106d19:	6a 00                	push   $0x0
80106d1b:	68 ba 00 00 00       	push   $0xba
80106d20:	e9 95 f2 ff ff       	jmp    80105fba <alltraps>

80106d25 <vector187>:
80106d25:	6a 00                	push   $0x0
80106d27:	68 bb 00 00 00       	push   $0xbb
80106d2c:	e9 89 f2 ff ff       	jmp    80105fba <alltraps>

80106d31 <vector188>:
80106d31:	6a 00                	push   $0x0
80106d33:	68 bc 00 00 00       	push   $0xbc
80106d38:	e9 7d f2 ff ff       	jmp    80105fba <alltraps>

80106d3d <vector189>:
80106d3d:	6a 00                	push   $0x0
80106d3f:	68 bd 00 00 00       	push   $0xbd
80106d44:	e9 71 f2 ff ff       	jmp    80105fba <alltraps>

80106d49 <vector190>:
80106d49:	6a 00                	push   $0x0
80106d4b:	68 be 00 00 00       	push   $0xbe
80106d50:	e9 65 f2 ff ff       	jmp    80105fba <alltraps>

80106d55 <vector191>:
80106d55:	6a 00                	push   $0x0
80106d57:	68 bf 00 00 00       	push   $0xbf
80106d5c:	e9 59 f2 ff ff       	jmp    80105fba <alltraps>

80106d61 <vector192>:
80106d61:	6a 00                	push   $0x0
80106d63:	68 c0 00 00 00       	push   $0xc0
80106d68:	e9 4d f2 ff ff       	jmp    80105fba <alltraps>

80106d6d <vector193>:
80106d6d:	6a 00                	push   $0x0
80106d6f:	68 c1 00 00 00       	push   $0xc1
80106d74:	e9 41 f2 ff ff       	jmp    80105fba <alltraps>

80106d79 <vector194>:
80106d79:	6a 00                	push   $0x0
80106d7b:	68 c2 00 00 00       	push   $0xc2
80106d80:	e9 35 f2 ff ff       	jmp    80105fba <alltraps>

80106d85 <vector195>:
80106d85:	6a 00                	push   $0x0
80106d87:	68 c3 00 00 00       	push   $0xc3
80106d8c:	e9 29 f2 ff ff       	jmp    80105fba <alltraps>

80106d91 <vector196>:
80106d91:	6a 00                	push   $0x0
80106d93:	68 c4 00 00 00       	push   $0xc4
80106d98:	e9 1d f2 ff ff       	jmp    80105fba <alltraps>

80106d9d <vector197>:
80106d9d:	6a 00                	push   $0x0
80106d9f:	68 c5 00 00 00       	push   $0xc5
80106da4:	e9 11 f2 ff ff       	jmp    80105fba <alltraps>

80106da9 <vector198>:
80106da9:	6a 00                	push   $0x0
80106dab:	68 c6 00 00 00       	push   $0xc6
80106db0:	e9 05 f2 ff ff       	jmp    80105fba <alltraps>

80106db5 <vector199>:
80106db5:	6a 00                	push   $0x0
80106db7:	68 c7 00 00 00       	push   $0xc7
80106dbc:	e9 f9 f1 ff ff       	jmp    80105fba <alltraps>

80106dc1 <vector200>:
80106dc1:	6a 00                	push   $0x0
80106dc3:	68 c8 00 00 00       	push   $0xc8
80106dc8:	e9 ed f1 ff ff       	jmp    80105fba <alltraps>

80106dcd <vector201>:
80106dcd:	6a 00                	push   $0x0
80106dcf:	68 c9 00 00 00       	push   $0xc9
80106dd4:	e9 e1 f1 ff ff       	jmp    80105fba <alltraps>

80106dd9 <vector202>:
80106dd9:	6a 00                	push   $0x0
80106ddb:	68 ca 00 00 00       	push   $0xca
80106de0:	e9 d5 f1 ff ff       	jmp    80105fba <alltraps>

80106de5 <vector203>:
80106de5:	6a 00                	push   $0x0
80106de7:	68 cb 00 00 00       	push   $0xcb
80106dec:	e9 c9 f1 ff ff       	jmp    80105fba <alltraps>

80106df1 <vector204>:
80106df1:	6a 00                	push   $0x0
80106df3:	68 cc 00 00 00       	push   $0xcc
80106df8:	e9 bd f1 ff ff       	jmp    80105fba <alltraps>

80106dfd <vector205>:
80106dfd:	6a 00                	push   $0x0
80106dff:	68 cd 00 00 00       	push   $0xcd
80106e04:	e9 b1 f1 ff ff       	jmp    80105fba <alltraps>

80106e09 <vector206>:
80106e09:	6a 00                	push   $0x0
80106e0b:	68 ce 00 00 00       	push   $0xce
80106e10:	e9 a5 f1 ff ff       	jmp    80105fba <alltraps>

80106e15 <vector207>:
80106e15:	6a 00                	push   $0x0
80106e17:	68 cf 00 00 00       	push   $0xcf
80106e1c:	e9 99 f1 ff ff       	jmp    80105fba <alltraps>

80106e21 <vector208>:
80106e21:	6a 00                	push   $0x0
80106e23:	68 d0 00 00 00       	push   $0xd0
80106e28:	e9 8d f1 ff ff       	jmp    80105fba <alltraps>

80106e2d <vector209>:
80106e2d:	6a 00                	push   $0x0
80106e2f:	68 d1 00 00 00       	push   $0xd1
80106e34:	e9 81 f1 ff ff       	jmp    80105fba <alltraps>

80106e39 <vector210>:
80106e39:	6a 00                	push   $0x0
80106e3b:	68 d2 00 00 00       	push   $0xd2
80106e40:	e9 75 f1 ff ff       	jmp    80105fba <alltraps>

80106e45 <vector211>:
80106e45:	6a 00                	push   $0x0
80106e47:	68 d3 00 00 00       	push   $0xd3
80106e4c:	e9 69 f1 ff ff       	jmp    80105fba <alltraps>

80106e51 <vector212>:
80106e51:	6a 00                	push   $0x0
80106e53:	68 d4 00 00 00       	push   $0xd4
80106e58:	e9 5d f1 ff ff       	jmp    80105fba <alltraps>

80106e5d <vector213>:
80106e5d:	6a 00                	push   $0x0
80106e5f:	68 d5 00 00 00       	push   $0xd5
80106e64:	e9 51 f1 ff ff       	jmp    80105fba <alltraps>

80106e69 <vector214>:
80106e69:	6a 00                	push   $0x0
80106e6b:	68 d6 00 00 00       	push   $0xd6
80106e70:	e9 45 f1 ff ff       	jmp    80105fba <alltraps>

80106e75 <vector215>:
80106e75:	6a 00                	push   $0x0
80106e77:	68 d7 00 00 00       	push   $0xd7
80106e7c:	e9 39 f1 ff ff       	jmp    80105fba <alltraps>

80106e81 <vector216>:
80106e81:	6a 00                	push   $0x0
80106e83:	68 d8 00 00 00       	push   $0xd8
80106e88:	e9 2d f1 ff ff       	jmp    80105fba <alltraps>

80106e8d <vector217>:
80106e8d:	6a 00                	push   $0x0
80106e8f:	68 d9 00 00 00       	push   $0xd9
80106e94:	e9 21 f1 ff ff       	jmp    80105fba <alltraps>

80106e99 <vector218>:
80106e99:	6a 00                	push   $0x0
80106e9b:	68 da 00 00 00       	push   $0xda
80106ea0:	e9 15 f1 ff ff       	jmp    80105fba <alltraps>

80106ea5 <vector219>:
80106ea5:	6a 00                	push   $0x0
80106ea7:	68 db 00 00 00       	push   $0xdb
80106eac:	e9 09 f1 ff ff       	jmp    80105fba <alltraps>

80106eb1 <vector220>:
80106eb1:	6a 00                	push   $0x0
80106eb3:	68 dc 00 00 00       	push   $0xdc
80106eb8:	e9 fd f0 ff ff       	jmp    80105fba <alltraps>

80106ebd <vector221>:
80106ebd:	6a 00                	push   $0x0
80106ebf:	68 dd 00 00 00       	push   $0xdd
80106ec4:	e9 f1 f0 ff ff       	jmp    80105fba <alltraps>

80106ec9 <vector222>:
80106ec9:	6a 00                	push   $0x0
80106ecb:	68 de 00 00 00       	push   $0xde
80106ed0:	e9 e5 f0 ff ff       	jmp    80105fba <alltraps>

80106ed5 <vector223>:
80106ed5:	6a 00                	push   $0x0
80106ed7:	68 df 00 00 00       	push   $0xdf
80106edc:	e9 d9 f0 ff ff       	jmp    80105fba <alltraps>

80106ee1 <vector224>:
80106ee1:	6a 00                	push   $0x0
80106ee3:	68 e0 00 00 00       	push   $0xe0
80106ee8:	e9 cd f0 ff ff       	jmp    80105fba <alltraps>

80106eed <vector225>:
80106eed:	6a 00                	push   $0x0
80106eef:	68 e1 00 00 00       	push   $0xe1
80106ef4:	e9 c1 f0 ff ff       	jmp    80105fba <alltraps>

80106ef9 <vector226>:
80106ef9:	6a 00                	push   $0x0
80106efb:	68 e2 00 00 00       	push   $0xe2
80106f00:	e9 b5 f0 ff ff       	jmp    80105fba <alltraps>

80106f05 <vector227>:
80106f05:	6a 00                	push   $0x0
80106f07:	68 e3 00 00 00       	push   $0xe3
80106f0c:	e9 a9 f0 ff ff       	jmp    80105fba <alltraps>

80106f11 <vector228>:
80106f11:	6a 00                	push   $0x0
80106f13:	68 e4 00 00 00       	push   $0xe4
80106f18:	e9 9d f0 ff ff       	jmp    80105fba <alltraps>

80106f1d <vector229>:
80106f1d:	6a 00                	push   $0x0
80106f1f:	68 e5 00 00 00       	push   $0xe5
80106f24:	e9 91 f0 ff ff       	jmp    80105fba <alltraps>

80106f29 <vector230>:
80106f29:	6a 00                	push   $0x0
80106f2b:	68 e6 00 00 00       	push   $0xe6
80106f30:	e9 85 f0 ff ff       	jmp    80105fba <alltraps>

80106f35 <vector231>:
80106f35:	6a 00                	push   $0x0
80106f37:	68 e7 00 00 00       	push   $0xe7
80106f3c:	e9 79 f0 ff ff       	jmp    80105fba <alltraps>

80106f41 <vector232>:
80106f41:	6a 00                	push   $0x0
80106f43:	68 e8 00 00 00       	push   $0xe8
80106f48:	e9 6d f0 ff ff       	jmp    80105fba <alltraps>

80106f4d <vector233>:
80106f4d:	6a 00                	push   $0x0
80106f4f:	68 e9 00 00 00       	push   $0xe9
80106f54:	e9 61 f0 ff ff       	jmp    80105fba <alltraps>

80106f59 <vector234>:
80106f59:	6a 00                	push   $0x0
80106f5b:	68 ea 00 00 00       	push   $0xea
80106f60:	e9 55 f0 ff ff       	jmp    80105fba <alltraps>

80106f65 <vector235>:
80106f65:	6a 00                	push   $0x0
80106f67:	68 eb 00 00 00       	push   $0xeb
80106f6c:	e9 49 f0 ff ff       	jmp    80105fba <alltraps>

80106f71 <vector236>:
80106f71:	6a 00                	push   $0x0
80106f73:	68 ec 00 00 00       	push   $0xec
80106f78:	e9 3d f0 ff ff       	jmp    80105fba <alltraps>

80106f7d <vector237>:
80106f7d:	6a 00                	push   $0x0
80106f7f:	68 ed 00 00 00       	push   $0xed
80106f84:	e9 31 f0 ff ff       	jmp    80105fba <alltraps>

80106f89 <vector238>:
80106f89:	6a 00                	push   $0x0
80106f8b:	68 ee 00 00 00       	push   $0xee
80106f90:	e9 25 f0 ff ff       	jmp    80105fba <alltraps>

80106f95 <vector239>:
80106f95:	6a 00                	push   $0x0
80106f97:	68 ef 00 00 00       	push   $0xef
80106f9c:	e9 19 f0 ff ff       	jmp    80105fba <alltraps>

80106fa1 <vector240>:
80106fa1:	6a 00                	push   $0x0
80106fa3:	68 f0 00 00 00       	push   $0xf0
80106fa8:	e9 0d f0 ff ff       	jmp    80105fba <alltraps>

80106fad <vector241>:
80106fad:	6a 00                	push   $0x0
80106faf:	68 f1 00 00 00       	push   $0xf1
80106fb4:	e9 01 f0 ff ff       	jmp    80105fba <alltraps>

80106fb9 <vector242>:
80106fb9:	6a 00                	push   $0x0
80106fbb:	68 f2 00 00 00       	push   $0xf2
80106fc0:	e9 f5 ef ff ff       	jmp    80105fba <alltraps>

80106fc5 <vector243>:
80106fc5:	6a 00                	push   $0x0
80106fc7:	68 f3 00 00 00       	push   $0xf3
80106fcc:	e9 e9 ef ff ff       	jmp    80105fba <alltraps>

80106fd1 <vector244>:
80106fd1:	6a 00                	push   $0x0
80106fd3:	68 f4 00 00 00       	push   $0xf4
80106fd8:	e9 dd ef ff ff       	jmp    80105fba <alltraps>

80106fdd <vector245>:
80106fdd:	6a 00                	push   $0x0
80106fdf:	68 f5 00 00 00       	push   $0xf5
80106fe4:	e9 d1 ef ff ff       	jmp    80105fba <alltraps>

80106fe9 <vector246>:
80106fe9:	6a 00                	push   $0x0
80106feb:	68 f6 00 00 00       	push   $0xf6
80106ff0:	e9 c5 ef ff ff       	jmp    80105fba <alltraps>

80106ff5 <vector247>:
80106ff5:	6a 00                	push   $0x0
80106ff7:	68 f7 00 00 00       	push   $0xf7
80106ffc:	e9 b9 ef ff ff       	jmp    80105fba <alltraps>

80107001 <vector248>:
80107001:	6a 00                	push   $0x0
80107003:	68 f8 00 00 00       	push   $0xf8
80107008:	e9 ad ef ff ff       	jmp    80105fba <alltraps>

8010700d <vector249>:
8010700d:	6a 00                	push   $0x0
8010700f:	68 f9 00 00 00       	push   $0xf9
80107014:	e9 a1 ef ff ff       	jmp    80105fba <alltraps>

80107019 <vector250>:
80107019:	6a 00                	push   $0x0
8010701b:	68 fa 00 00 00       	push   $0xfa
80107020:	e9 95 ef ff ff       	jmp    80105fba <alltraps>

80107025 <vector251>:
80107025:	6a 00                	push   $0x0
80107027:	68 fb 00 00 00       	push   $0xfb
8010702c:	e9 89 ef ff ff       	jmp    80105fba <alltraps>

80107031 <vector252>:
80107031:	6a 00                	push   $0x0
80107033:	68 fc 00 00 00       	push   $0xfc
80107038:	e9 7d ef ff ff       	jmp    80105fba <alltraps>

8010703d <vector253>:
8010703d:	6a 00                	push   $0x0
8010703f:	68 fd 00 00 00       	push   $0xfd
80107044:	e9 71 ef ff ff       	jmp    80105fba <alltraps>

80107049 <vector254>:
80107049:	6a 00                	push   $0x0
8010704b:	68 fe 00 00 00       	push   $0xfe
80107050:	e9 65 ef ff ff       	jmp    80105fba <alltraps>

80107055 <vector255>:
80107055:	6a 00                	push   $0x0
80107057:	68 ff 00 00 00       	push   $0xff
8010705c:	e9 59 ef ff ff       	jmp    80105fba <alltraps>

80107061 <lgdt>:
80107061:	55                   	push   %ebp
80107062:	89 e5                	mov    %esp,%ebp
80107064:	83 ec 10             	sub    $0x10,%esp
80107067:	8b 45 0c             	mov    0xc(%ebp),%eax
8010706a:	83 e8 01             	sub    $0x1,%eax
8010706d:	66 89 45 fa          	mov    %ax,-0x6(%ebp)
80107071:	8b 45 08             	mov    0x8(%ebp),%eax
80107074:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
80107078:	8b 45 08             	mov    0x8(%ebp),%eax
8010707b:	c1 e8 10             	shr    $0x10,%eax
8010707e:	66 89 45 fe          	mov    %ax,-0x2(%ebp)
80107082:	8d 45 fa             	lea    -0x6(%ebp),%eax
80107085:	0f 01 10             	lgdtl  (%eax)
80107088:	90                   	nop
80107089:	c9                   	leave  
8010708a:	c3                   	ret    

8010708b <ltr>:
8010708b:	55                   	push   %ebp
8010708c:	89 e5                	mov    %esp,%ebp
8010708e:	83 ec 04             	sub    $0x4,%esp
80107091:	8b 45 08             	mov    0x8(%ebp),%eax
80107094:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
80107098:	0f b7 45 fc          	movzwl -0x4(%ebp),%eax
8010709c:	0f 00 d8             	ltr    %ax
8010709f:	90                   	nop
801070a0:	c9                   	leave  
801070a1:	c3                   	ret    

801070a2 <lcr3>:
801070a2:	55                   	push   %ebp
801070a3:	89 e5                	mov    %esp,%ebp
801070a5:	8b 45 08             	mov    0x8(%ebp),%eax
801070a8:	0f 22 d8             	mov    %eax,%cr3
801070ab:	90                   	nop
801070ac:	5d                   	pop    %ebp
801070ad:	c3                   	ret    

801070ae <seginit>:
801070ae:	55                   	push   %ebp
801070af:	89 e5                	mov    %esp,%ebp
801070b1:	83 ec 18             	sub    $0x18,%esp
801070b4:	e8 e4 c8 ff ff       	call   8010399d <cpuid>
801070b9:	69 c0 b0 00 00 00    	imul   $0xb0,%eax,%eax
801070bf:	05 80 6a 19 80       	add    $0x80196a80,%eax
801070c4:	89 45 f4             	mov    %eax,-0xc(%ebp)
801070c7:	8b 45 f4             	mov    -0xc(%ebp),%eax
801070ca:	66 c7 40 78 ff ff    	movw   $0xffff,0x78(%eax)
801070d0:	8b 45 f4             	mov    -0xc(%ebp),%eax
801070d3:	66 c7 40 7a 00 00    	movw   $0x0,0x7a(%eax)
801070d9:	8b 45 f4             	mov    -0xc(%ebp),%eax
801070dc:	c6 40 7c 00          	movb   $0x0,0x7c(%eax)
801070e0:	8b 45 f4             	mov    -0xc(%ebp),%eax
801070e3:	0f b6 50 7d          	movzbl 0x7d(%eax),%edx
801070e7:	83 e2 f0             	and    $0xfffffff0,%edx
801070ea:	83 ca 0a             	or     $0xa,%edx
801070ed:	88 50 7d             	mov    %dl,0x7d(%eax)
801070f0:	8b 45 f4             	mov    -0xc(%ebp),%eax
801070f3:	0f b6 50 7d          	movzbl 0x7d(%eax),%edx
801070f7:	83 ca 10             	or     $0x10,%edx
801070fa:	88 50 7d             	mov    %dl,0x7d(%eax)
801070fd:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107100:	0f b6 50 7d          	movzbl 0x7d(%eax),%edx
80107104:	83 e2 9f             	and    $0xffffff9f,%edx
80107107:	88 50 7d             	mov    %dl,0x7d(%eax)
8010710a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010710d:	0f b6 50 7d          	movzbl 0x7d(%eax),%edx
80107111:	83 ca 80             	or     $0xffffff80,%edx
80107114:	88 50 7d             	mov    %dl,0x7d(%eax)
80107117:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010711a:	0f b6 50 7e          	movzbl 0x7e(%eax),%edx
8010711e:	83 ca 0f             	or     $0xf,%edx
80107121:	88 50 7e             	mov    %dl,0x7e(%eax)
80107124:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107127:	0f b6 50 7e          	movzbl 0x7e(%eax),%edx
8010712b:	83 e2 ef             	and    $0xffffffef,%edx
8010712e:	88 50 7e             	mov    %dl,0x7e(%eax)
80107131:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107134:	0f b6 50 7e          	movzbl 0x7e(%eax),%edx
80107138:	83 e2 df             	and    $0xffffffdf,%edx
8010713b:	88 50 7e             	mov    %dl,0x7e(%eax)
8010713e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107141:	0f b6 50 7e          	movzbl 0x7e(%eax),%edx
80107145:	83 ca 40             	or     $0x40,%edx
80107148:	88 50 7e             	mov    %dl,0x7e(%eax)
8010714b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010714e:	0f b6 50 7e          	movzbl 0x7e(%eax),%edx
80107152:	83 ca 80             	or     $0xffffff80,%edx
80107155:	88 50 7e             	mov    %dl,0x7e(%eax)
80107158:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010715b:	c6 40 7f 00          	movb   $0x0,0x7f(%eax)
8010715f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107162:	66 c7 80 80 00 00 00 	movw   $0xffff,0x80(%eax)
80107169:	ff ff 
8010716b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010716e:	66 c7 80 82 00 00 00 	movw   $0x0,0x82(%eax)
80107175:	00 00 
80107177:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010717a:	c6 80 84 00 00 00 00 	movb   $0x0,0x84(%eax)
80107181:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107184:	0f b6 90 85 00 00 00 	movzbl 0x85(%eax),%edx
8010718b:	83 e2 f0             	and    $0xfffffff0,%edx
8010718e:	83 ca 02             	or     $0x2,%edx
80107191:	88 90 85 00 00 00    	mov    %dl,0x85(%eax)
80107197:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010719a:	0f b6 90 85 00 00 00 	movzbl 0x85(%eax),%edx
801071a1:	83 ca 10             	or     $0x10,%edx
801071a4:	88 90 85 00 00 00    	mov    %dl,0x85(%eax)
801071aa:	8b 45 f4             	mov    -0xc(%ebp),%eax
801071ad:	0f b6 90 85 00 00 00 	movzbl 0x85(%eax),%edx
801071b4:	83 e2 9f             	and    $0xffffff9f,%edx
801071b7:	88 90 85 00 00 00    	mov    %dl,0x85(%eax)
801071bd:	8b 45 f4             	mov    -0xc(%ebp),%eax
801071c0:	0f b6 90 85 00 00 00 	movzbl 0x85(%eax),%edx
801071c7:	83 ca 80             	or     $0xffffff80,%edx
801071ca:	88 90 85 00 00 00    	mov    %dl,0x85(%eax)
801071d0:	8b 45 f4             	mov    -0xc(%ebp),%eax
801071d3:	0f b6 90 86 00 00 00 	movzbl 0x86(%eax),%edx
801071da:	83 ca 0f             	or     $0xf,%edx
801071dd:	88 90 86 00 00 00    	mov    %dl,0x86(%eax)
801071e3:	8b 45 f4             	mov    -0xc(%ebp),%eax
801071e6:	0f b6 90 86 00 00 00 	movzbl 0x86(%eax),%edx
801071ed:	83 e2 ef             	and    $0xffffffef,%edx
801071f0:	88 90 86 00 00 00    	mov    %dl,0x86(%eax)
801071f6:	8b 45 f4             	mov    -0xc(%ebp),%eax
801071f9:	0f b6 90 86 00 00 00 	movzbl 0x86(%eax),%edx
80107200:	83 e2 df             	and    $0xffffffdf,%edx
80107203:	88 90 86 00 00 00    	mov    %dl,0x86(%eax)
80107209:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010720c:	0f b6 90 86 00 00 00 	movzbl 0x86(%eax),%edx
80107213:	83 ca 40             	or     $0x40,%edx
80107216:	88 90 86 00 00 00    	mov    %dl,0x86(%eax)
8010721c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010721f:	0f b6 90 86 00 00 00 	movzbl 0x86(%eax),%edx
80107226:	83 ca 80             	or     $0xffffff80,%edx
80107229:	88 90 86 00 00 00    	mov    %dl,0x86(%eax)
8010722f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107232:	c6 80 87 00 00 00 00 	movb   $0x0,0x87(%eax)
80107239:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010723c:	66 c7 80 88 00 00 00 	movw   $0xffff,0x88(%eax)
80107243:	ff ff 
80107245:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107248:	66 c7 80 8a 00 00 00 	movw   $0x0,0x8a(%eax)
8010724f:	00 00 
80107251:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107254:	c6 80 8c 00 00 00 00 	movb   $0x0,0x8c(%eax)
8010725b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010725e:	0f b6 90 8d 00 00 00 	movzbl 0x8d(%eax),%edx
80107265:	83 e2 f0             	and    $0xfffffff0,%edx
80107268:	83 ca 0a             	or     $0xa,%edx
8010726b:	88 90 8d 00 00 00    	mov    %dl,0x8d(%eax)
80107271:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107274:	0f b6 90 8d 00 00 00 	movzbl 0x8d(%eax),%edx
8010727b:	83 ca 10             	or     $0x10,%edx
8010727e:	88 90 8d 00 00 00    	mov    %dl,0x8d(%eax)
80107284:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107287:	0f b6 90 8d 00 00 00 	movzbl 0x8d(%eax),%edx
8010728e:	83 ca 60             	or     $0x60,%edx
80107291:	88 90 8d 00 00 00    	mov    %dl,0x8d(%eax)
80107297:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010729a:	0f b6 90 8d 00 00 00 	movzbl 0x8d(%eax),%edx
801072a1:	83 ca 80             	or     $0xffffff80,%edx
801072a4:	88 90 8d 00 00 00    	mov    %dl,0x8d(%eax)
801072aa:	8b 45 f4             	mov    -0xc(%ebp),%eax
801072ad:	0f b6 90 8e 00 00 00 	movzbl 0x8e(%eax),%edx
801072b4:	83 ca 0f             	or     $0xf,%edx
801072b7:	88 90 8e 00 00 00    	mov    %dl,0x8e(%eax)
801072bd:	8b 45 f4             	mov    -0xc(%ebp),%eax
801072c0:	0f b6 90 8e 00 00 00 	movzbl 0x8e(%eax),%edx
801072c7:	83 e2 ef             	and    $0xffffffef,%edx
801072ca:	88 90 8e 00 00 00    	mov    %dl,0x8e(%eax)
801072d0:	8b 45 f4             	mov    -0xc(%ebp),%eax
801072d3:	0f b6 90 8e 00 00 00 	movzbl 0x8e(%eax),%edx
801072da:	83 e2 df             	and    $0xffffffdf,%edx
801072dd:	88 90 8e 00 00 00    	mov    %dl,0x8e(%eax)
801072e3:	8b 45 f4             	mov    -0xc(%ebp),%eax
801072e6:	0f b6 90 8e 00 00 00 	movzbl 0x8e(%eax),%edx
801072ed:	83 ca 40             	or     $0x40,%edx
801072f0:	88 90 8e 00 00 00    	mov    %dl,0x8e(%eax)
801072f6:	8b 45 f4             	mov    -0xc(%ebp),%eax
801072f9:	0f b6 90 8e 00 00 00 	movzbl 0x8e(%eax),%edx
80107300:	83 ca 80             	or     $0xffffff80,%edx
80107303:	88 90 8e 00 00 00    	mov    %dl,0x8e(%eax)
80107309:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010730c:	c6 80 8f 00 00 00 00 	movb   $0x0,0x8f(%eax)
80107313:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107316:	66 c7 80 90 00 00 00 	movw   $0xffff,0x90(%eax)
8010731d:	ff ff 
8010731f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107322:	66 c7 80 92 00 00 00 	movw   $0x0,0x92(%eax)
80107329:	00 00 
8010732b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010732e:	c6 80 94 00 00 00 00 	movb   $0x0,0x94(%eax)
80107335:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107338:	0f b6 90 95 00 00 00 	movzbl 0x95(%eax),%edx
8010733f:	83 e2 f0             	and    $0xfffffff0,%edx
80107342:	83 ca 02             	or     $0x2,%edx
80107345:	88 90 95 00 00 00    	mov    %dl,0x95(%eax)
8010734b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010734e:	0f b6 90 95 00 00 00 	movzbl 0x95(%eax),%edx
80107355:	83 ca 10             	or     $0x10,%edx
80107358:	88 90 95 00 00 00    	mov    %dl,0x95(%eax)
8010735e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107361:	0f b6 90 95 00 00 00 	movzbl 0x95(%eax),%edx
80107368:	83 ca 60             	or     $0x60,%edx
8010736b:	88 90 95 00 00 00    	mov    %dl,0x95(%eax)
80107371:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107374:	0f b6 90 95 00 00 00 	movzbl 0x95(%eax),%edx
8010737b:	83 ca 80             	or     $0xffffff80,%edx
8010737e:	88 90 95 00 00 00    	mov    %dl,0x95(%eax)
80107384:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107387:	0f b6 90 96 00 00 00 	movzbl 0x96(%eax),%edx
8010738e:	83 ca 0f             	or     $0xf,%edx
80107391:	88 90 96 00 00 00    	mov    %dl,0x96(%eax)
80107397:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010739a:	0f b6 90 96 00 00 00 	movzbl 0x96(%eax),%edx
801073a1:	83 e2 ef             	and    $0xffffffef,%edx
801073a4:	88 90 96 00 00 00    	mov    %dl,0x96(%eax)
801073aa:	8b 45 f4             	mov    -0xc(%ebp),%eax
801073ad:	0f b6 90 96 00 00 00 	movzbl 0x96(%eax),%edx
801073b4:	83 e2 df             	and    $0xffffffdf,%edx
801073b7:	88 90 96 00 00 00    	mov    %dl,0x96(%eax)
801073bd:	8b 45 f4             	mov    -0xc(%ebp),%eax
801073c0:	0f b6 90 96 00 00 00 	movzbl 0x96(%eax),%edx
801073c7:	83 ca 40             	or     $0x40,%edx
801073ca:	88 90 96 00 00 00    	mov    %dl,0x96(%eax)
801073d0:	8b 45 f4             	mov    -0xc(%ebp),%eax
801073d3:	0f b6 90 96 00 00 00 	movzbl 0x96(%eax),%edx
801073da:	83 ca 80             	or     $0xffffff80,%edx
801073dd:	88 90 96 00 00 00    	mov    %dl,0x96(%eax)
801073e3:	8b 45 f4             	mov    -0xc(%ebp),%eax
801073e6:	c6 80 97 00 00 00 00 	movb   $0x0,0x97(%eax)
801073ed:	8b 45 f4             	mov    -0xc(%ebp),%eax
801073f0:	83 c0 70             	add    $0x70,%eax
801073f3:	83 ec 08             	sub    $0x8,%esp
801073f6:	6a 30                	push   $0x30
801073f8:	50                   	push   %eax
801073f9:	e8 63 fc ff ff       	call   80107061 <lgdt>
801073fe:	83 c4 10             	add    $0x10,%esp
80107401:	90                   	nop
80107402:	c9                   	leave  
80107403:	c3                   	ret    

80107404 <walkpgdir>:
80107404:	55                   	push   %ebp
80107405:	89 e5                	mov    %esp,%ebp
80107407:	83 ec 18             	sub    $0x18,%esp
8010740a:	8b 45 0c             	mov    0xc(%ebp),%eax
8010740d:	c1 e8 16             	shr    $0x16,%eax
80107410:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80107417:	8b 45 08             	mov    0x8(%ebp),%eax
8010741a:	01 d0                	add    %edx,%eax
8010741c:	89 45 f0             	mov    %eax,-0x10(%ebp)
8010741f:	8b 45 f0             	mov    -0x10(%ebp),%eax
80107422:	8b 00                	mov    (%eax),%eax
80107424:	83 e0 01             	and    $0x1,%eax
80107427:	85 c0                	test   %eax,%eax
80107429:	74 14                	je     8010743f <walkpgdir+0x3b>
8010742b:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010742e:	8b 00                	mov    (%eax),%eax
80107430:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80107435:	05 00 00 00 80       	add    $0x80000000,%eax
8010743a:	89 45 f4             	mov    %eax,-0xc(%ebp)
8010743d:	eb 42                	jmp    80107481 <walkpgdir+0x7d>
8010743f:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
80107443:	74 0e                	je     80107453 <walkpgdir+0x4f>
80107445:	e8 56 b3 ff ff       	call   801027a0 <kalloc>
8010744a:	89 45 f4             	mov    %eax,-0xc(%ebp)
8010744d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80107451:	75 07                	jne    8010745a <walkpgdir+0x56>
80107453:	b8 00 00 00 00       	mov    $0x0,%eax
80107458:	eb 3e                	jmp    80107498 <walkpgdir+0x94>
8010745a:	83 ec 04             	sub    $0x4,%esp
8010745d:	68 00 10 00 00       	push   $0x1000
80107462:	6a 00                	push   $0x0
80107464:	ff 75 f4             	push   -0xc(%ebp)
80107467:	e8 72 d7 ff ff       	call   80104bde <memset>
8010746c:	83 c4 10             	add    $0x10,%esp
8010746f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107472:	05 00 00 00 80       	add    $0x80000000,%eax
80107477:	83 c8 07             	or     $0x7,%eax
8010747a:	89 c2                	mov    %eax,%edx
8010747c:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010747f:	89 10                	mov    %edx,(%eax)
80107481:	8b 45 0c             	mov    0xc(%ebp),%eax
80107484:	c1 e8 0c             	shr    $0xc,%eax
80107487:	25 ff 03 00 00       	and    $0x3ff,%eax
8010748c:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80107493:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107496:	01 d0                	add    %edx,%eax
80107498:	c9                   	leave  
80107499:	c3                   	ret    

8010749a <mappages>:
8010749a:	55                   	push   %ebp
8010749b:	89 e5                	mov    %esp,%ebp
8010749d:	83 ec 18             	sub    $0x18,%esp
801074a0:	8b 45 0c             	mov    0xc(%ebp),%eax
801074a3:	25 00 f0 ff ff       	and    $0xfffff000,%eax
801074a8:	89 45 f4             	mov    %eax,-0xc(%ebp)
801074ab:	8b 55 0c             	mov    0xc(%ebp),%edx
801074ae:	8b 45 10             	mov    0x10(%ebp),%eax
801074b1:	01 d0                	add    %edx,%eax
801074b3:	83 e8 01             	sub    $0x1,%eax
801074b6:	25 00 f0 ff ff       	and    $0xfffff000,%eax
801074bb:	89 45 f0             	mov    %eax,-0x10(%ebp)
801074be:	83 ec 04             	sub    $0x4,%esp
801074c1:	6a 01                	push   $0x1
801074c3:	ff 75 f4             	push   -0xc(%ebp)
801074c6:	ff 75 08             	push   0x8(%ebp)
801074c9:	e8 36 ff ff ff       	call   80107404 <walkpgdir>
801074ce:	83 c4 10             	add    $0x10,%esp
801074d1:	89 45 ec             	mov    %eax,-0x14(%ebp)
801074d4:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
801074d8:	75 07                	jne    801074e1 <mappages+0x47>
801074da:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801074df:	eb 47                	jmp    80107528 <mappages+0x8e>
801074e1:	8b 45 ec             	mov    -0x14(%ebp),%eax
801074e4:	8b 00                	mov    (%eax),%eax
801074e6:	83 e0 01             	and    $0x1,%eax
801074e9:	85 c0                	test   %eax,%eax
801074eb:	74 0d                	je     801074fa <mappages+0x60>
801074ed:	83 ec 0c             	sub    $0xc,%esp
801074f0:	68 c8 a7 10 80       	push   $0x8010a7c8
801074f5:	e8 af 90 ff ff       	call   801005a9 <panic>
801074fa:	8b 45 18             	mov    0x18(%ebp),%eax
801074fd:	0b 45 14             	or     0x14(%ebp),%eax
80107500:	83 c8 01             	or     $0x1,%eax
80107503:	89 c2                	mov    %eax,%edx
80107505:	8b 45 ec             	mov    -0x14(%ebp),%eax
80107508:	89 10                	mov    %edx,(%eax)
8010750a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010750d:	3b 45 f0             	cmp    -0x10(%ebp),%eax
80107510:	74 10                	je     80107522 <mappages+0x88>
80107512:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
80107519:	81 45 14 00 10 00 00 	addl   $0x1000,0x14(%ebp)
80107520:	eb 9c                	jmp    801074be <mappages+0x24>
80107522:	90                   	nop
80107523:	b8 00 00 00 00       	mov    $0x0,%eax
80107528:	c9                   	leave  
80107529:	c3                   	ret    

8010752a <setupkvm>:
8010752a:	55                   	push   %ebp
8010752b:	89 e5                	mov    %esp,%ebp
8010752d:	53                   	push   %ebx
8010752e:	83 ec 24             	sub    $0x24,%esp
80107531:	c7 45 f4 80 f4 10 80 	movl   $0x8010f480,-0xc(%ebp)
80107538:	8b 15 50 6d 19 80    	mov    0x80196d50,%edx
8010753e:	b8 00 00 00 fe       	mov    $0xfe000000,%eax
80107543:	29 d0                	sub    %edx,%eax
80107545:	89 45 e0             	mov    %eax,-0x20(%ebp)
80107548:	a1 48 6d 19 80       	mov    0x80196d48,%eax
8010754d:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80107550:	8b 15 48 6d 19 80    	mov    0x80196d48,%edx
80107556:	a1 50 6d 19 80       	mov    0x80196d50,%eax
8010755b:	01 d0                	add    %edx,%eax
8010755d:	89 45 e8             	mov    %eax,-0x18(%ebp)
80107560:	c7 45 ec 02 00 00 00 	movl   $0x2,-0x14(%ebp)
80107567:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010756a:	83 c0 30             	add    $0x30,%eax
8010756d:	8b 55 e0             	mov    -0x20(%ebp),%edx
80107570:	89 10                	mov    %edx,(%eax)
80107572:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80107575:	89 50 04             	mov    %edx,0x4(%eax)
80107578:	8b 55 e8             	mov    -0x18(%ebp),%edx
8010757b:	89 50 08             	mov    %edx,0x8(%eax)
8010757e:	8b 55 ec             	mov    -0x14(%ebp),%edx
80107581:	89 50 0c             	mov    %edx,0xc(%eax)
80107584:	e8 17 b2 ff ff       	call   801027a0 <kalloc>
80107589:	89 45 f0             	mov    %eax,-0x10(%ebp)
8010758c:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80107590:	75 07                	jne    80107599 <setupkvm+0x6f>
80107592:	b8 00 00 00 00       	mov    $0x0,%eax
80107597:	eb 78                	jmp    80107611 <setupkvm+0xe7>
80107599:	83 ec 04             	sub    $0x4,%esp
8010759c:	68 00 10 00 00       	push   $0x1000
801075a1:	6a 00                	push   $0x0
801075a3:	ff 75 f0             	push   -0x10(%ebp)
801075a6:	e8 33 d6 ff ff       	call   80104bde <memset>
801075ab:	83 c4 10             	add    $0x10,%esp
801075ae:	c7 45 f4 80 f4 10 80 	movl   $0x8010f480,-0xc(%ebp)
801075b5:	eb 4e                	jmp    80107605 <setupkvm+0xdb>
801075b7:	8b 45 f4             	mov    -0xc(%ebp),%eax
801075ba:	8b 48 0c             	mov    0xc(%eax),%ecx
801075bd:	8b 45 f4             	mov    -0xc(%ebp),%eax
801075c0:	8b 50 04             	mov    0x4(%eax),%edx
801075c3:	8b 45 f4             	mov    -0xc(%ebp),%eax
801075c6:	8b 58 08             	mov    0x8(%eax),%ebx
801075c9:	8b 45 f4             	mov    -0xc(%ebp),%eax
801075cc:	8b 40 04             	mov    0x4(%eax),%eax
801075cf:	29 c3                	sub    %eax,%ebx
801075d1:	8b 45 f4             	mov    -0xc(%ebp),%eax
801075d4:	8b 00                	mov    (%eax),%eax
801075d6:	83 ec 0c             	sub    $0xc,%esp
801075d9:	51                   	push   %ecx
801075da:	52                   	push   %edx
801075db:	53                   	push   %ebx
801075dc:	50                   	push   %eax
801075dd:	ff 75 f0             	push   -0x10(%ebp)
801075e0:	e8 b5 fe ff ff       	call   8010749a <mappages>
801075e5:	83 c4 20             	add    $0x20,%esp
801075e8:	85 c0                	test   %eax,%eax
801075ea:	79 15                	jns    80107601 <setupkvm+0xd7>
801075ec:	83 ec 0c             	sub    $0xc,%esp
801075ef:	ff 75 f0             	push   -0x10(%ebp)
801075f2:	e8 f5 04 00 00       	call   80107aec <freevm>
801075f7:	83 c4 10             	add    $0x10,%esp
801075fa:	b8 00 00 00 00       	mov    $0x0,%eax
801075ff:	eb 10                	jmp    80107611 <setupkvm+0xe7>
80107601:	83 45 f4 10          	addl   $0x10,-0xc(%ebp)
80107605:	81 7d f4 e0 f4 10 80 	cmpl   $0x8010f4e0,-0xc(%ebp)
8010760c:	72 a9                	jb     801075b7 <setupkvm+0x8d>
8010760e:	8b 45 f0             	mov    -0x10(%ebp),%eax
80107611:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80107614:	c9                   	leave  
80107615:	c3                   	ret    

80107616 <kvmalloc>:
80107616:	55                   	push   %ebp
80107617:	89 e5                	mov    %esp,%ebp
80107619:	83 ec 08             	sub    $0x8,%esp
8010761c:	e8 09 ff ff ff       	call   8010752a <setupkvm>
80107621:	a3 7c 6a 19 80       	mov    %eax,0x80196a7c
80107626:	e8 03 00 00 00       	call   8010762e <switchkvm>
8010762b:	90                   	nop
8010762c:	c9                   	leave  
8010762d:	c3                   	ret    

8010762e <switchkvm>:
8010762e:	55                   	push   %ebp
8010762f:	89 e5                	mov    %esp,%ebp
80107631:	a1 7c 6a 19 80       	mov    0x80196a7c,%eax
80107636:	05 00 00 00 80       	add    $0x80000000,%eax
8010763b:	50                   	push   %eax
8010763c:	e8 61 fa ff ff       	call   801070a2 <lcr3>
80107641:	83 c4 04             	add    $0x4,%esp
80107644:	90                   	nop
80107645:	c9                   	leave  
80107646:	c3                   	ret    

80107647 <switchuvm>:
80107647:	55                   	push   %ebp
80107648:	89 e5                	mov    %esp,%ebp
8010764a:	56                   	push   %esi
8010764b:	53                   	push   %ebx
8010764c:	83 ec 10             	sub    $0x10,%esp
8010764f:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
80107653:	75 0d                	jne    80107662 <switchuvm+0x1b>
80107655:	83 ec 0c             	sub    $0xc,%esp
80107658:	68 ce a7 10 80       	push   $0x8010a7ce
8010765d:	e8 47 8f ff ff       	call   801005a9 <panic>
80107662:	8b 45 08             	mov    0x8(%ebp),%eax
80107665:	8b 40 08             	mov    0x8(%eax),%eax
80107668:	85 c0                	test   %eax,%eax
8010766a:	75 0d                	jne    80107679 <switchuvm+0x32>
8010766c:	83 ec 0c             	sub    $0xc,%esp
8010766f:	68 e4 a7 10 80       	push   $0x8010a7e4
80107674:	e8 30 8f ff ff       	call   801005a9 <panic>
80107679:	8b 45 08             	mov    0x8(%ebp),%eax
8010767c:	8b 40 04             	mov    0x4(%eax),%eax
8010767f:	85 c0                	test   %eax,%eax
80107681:	75 0d                	jne    80107690 <switchuvm+0x49>
80107683:	83 ec 0c             	sub    $0xc,%esp
80107686:	68 f9 a7 10 80       	push   $0x8010a7f9
8010768b:	e8 19 8f ff ff       	call   801005a9 <panic>
80107690:	e8 3e d4 ff ff       	call   80104ad3 <pushcli>
80107695:	e8 1e c3 ff ff       	call   801039b8 <mycpu>
8010769a:	89 c3                	mov    %eax,%ebx
8010769c:	e8 17 c3 ff ff       	call   801039b8 <mycpu>
801076a1:	83 c0 08             	add    $0x8,%eax
801076a4:	89 c6                	mov    %eax,%esi
801076a6:	e8 0d c3 ff ff       	call   801039b8 <mycpu>
801076ab:	83 c0 08             	add    $0x8,%eax
801076ae:	c1 e8 10             	shr    $0x10,%eax
801076b1:	88 45 f7             	mov    %al,-0x9(%ebp)
801076b4:	e8 ff c2 ff ff       	call   801039b8 <mycpu>
801076b9:	83 c0 08             	add    $0x8,%eax
801076bc:	c1 e8 18             	shr    $0x18,%eax
801076bf:	89 c2                	mov    %eax,%edx
801076c1:	66 c7 83 98 00 00 00 	movw   $0x67,0x98(%ebx)
801076c8:	67 00 
801076ca:	66 89 b3 9a 00 00 00 	mov    %si,0x9a(%ebx)
801076d1:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
801076d5:	88 83 9c 00 00 00    	mov    %al,0x9c(%ebx)
801076db:	0f b6 83 9d 00 00 00 	movzbl 0x9d(%ebx),%eax
801076e2:	83 e0 f0             	and    $0xfffffff0,%eax
801076e5:	83 c8 09             	or     $0x9,%eax
801076e8:	88 83 9d 00 00 00    	mov    %al,0x9d(%ebx)
801076ee:	0f b6 83 9d 00 00 00 	movzbl 0x9d(%ebx),%eax
801076f5:	83 c8 10             	or     $0x10,%eax
801076f8:	88 83 9d 00 00 00    	mov    %al,0x9d(%ebx)
801076fe:	0f b6 83 9d 00 00 00 	movzbl 0x9d(%ebx),%eax
80107705:	83 e0 9f             	and    $0xffffff9f,%eax
80107708:	88 83 9d 00 00 00    	mov    %al,0x9d(%ebx)
8010770e:	0f b6 83 9d 00 00 00 	movzbl 0x9d(%ebx),%eax
80107715:	83 c8 80             	or     $0xffffff80,%eax
80107718:	88 83 9d 00 00 00    	mov    %al,0x9d(%ebx)
8010771e:	0f b6 83 9e 00 00 00 	movzbl 0x9e(%ebx),%eax
80107725:	83 e0 f0             	and    $0xfffffff0,%eax
80107728:	88 83 9e 00 00 00    	mov    %al,0x9e(%ebx)
8010772e:	0f b6 83 9e 00 00 00 	movzbl 0x9e(%ebx),%eax
80107735:	83 e0 ef             	and    $0xffffffef,%eax
80107738:	88 83 9e 00 00 00    	mov    %al,0x9e(%ebx)
8010773e:	0f b6 83 9e 00 00 00 	movzbl 0x9e(%ebx),%eax
80107745:	83 e0 df             	and    $0xffffffdf,%eax
80107748:	88 83 9e 00 00 00    	mov    %al,0x9e(%ebx)
8010774e:	0f b6 83 9e 00 00 00 	movzbl 0x9e(%ebx),%eax
80107755:	83 c8 40             	or     $0x40,%eax
80107758:	88 83 9e 00 00 00    	mov    %al,0x9e(%ebx)
8010775e:	0f b6 83 9e 00 00 00 	movzbl 0x9e(%ebx),%eax
80107765:	83 e0 7f             	and    $0x7f,%eax
80107768:	88 83 9e 00 00 00    	mov    %al,0x9e(%ebx)
8010776e:	88 93 9f 00 00 00    	mov    %dl,0x9f(%ebx)
80107774:	e8 3f c2 ff ff       	call   801039b8 <mycpu>
80107779:	0f b6 90 9d 00 00 00 	movzbl 0x9d(%eax),%edx
80107780:	83 e2 ef             	and    $0xffffffef,%edx
80107783:	88 90 9d 00 00 00    	mov    %dl,0x9d(%eax)
80107789:	e8 2a c2 ff ff       	call   801039b8 <mycpu>
8010778e:	66 c7 40 10 10 00    	movw   $0x10,0x10(%eax)
80107794:	8b 45 08             	mov    0x8(%ebp),%eax
80107797:	8b 40 08             	mov    0x8(%eax),%eax
8010779a:	89 c3                	mov    %eax,%ebx
8010779c:	e8 17 c2 ff ff       	call   801039b8 <mycpu>
801077a1:	8d 93 00 10 00 00    	lea    0x1000(%ebx),%edx
801077a7:	89 50 0c             	mov    %edx,0xc(%eax)
801077aa:	e8 09 c2 ff ff       	call   801039b8 <mycpu>
801077af:	66 c7 40 6e ff ff    	movw   $0xffff,0x6e(%eax)
801077b5:	83 ec 0c             	sub    $0xc,%esp
801077b8:	6a 28                	push   $0x28
801077ba:	e8 cc f8 ff ff       	call   8010708b <ltr>
801077bf:	83 c4 10             	add    $0x10,%esp
801077c2:	8b 45 08             	mov    0x8(%ebp),%eax
801077c5:	8b 40 04             	mov    0x4(%eax),%eax
801077c8:	05 00 00 00 80       	add    $0x80000000,%eax
801077cd:	83 ec 0c             	sub    $0xc,%esp
801077d0:	50                   	push   %eax
801077d1:	e8 cc f8 ff ff       	call   801070a2 <lcr3>
801077d6:	83 c4 10             	add    $0x10,%esp
801077d9:	e8 42 d3 ff ff       	call   80104b20 <popcli>
801077de:	90                   	nop
801077df:	8d 65 f8             	lea    -0x8(%ebp),%esp
801077e2:	5b                   	pop    %ebx
801077e3:	5e                   	pop    %esi
801077e4:	5d                   	pop    %ebp
801077e5:	c3                   	ret    

801077e6 <inituvm>:
801077e6:	55                   	push   %ebp
801077e7:	89 e5                	mov    %esp,%ebp
801077e9:	83 ec 18             	sub    $0x18,%esp
801077ec:	81 7d 10 ff 0f 00 00 	cmpl   $0xfff,0x10(%ebp)
801077f3:	76 0d                	jbe    80107802 <inituvm+0x1c>
801077f5:	83 ec 0c             	sub    $0xc,%esp
801077f8:	68 0d a8 10 80       	push   $0x8010a80d
801077fd:	e8 a7 8d ff ff       	call   801005a9 <panic>
80107802:	e8 99 af ff ff       	call   801027a0 <kalloc>
80107807:	89 45 f4             	mov    %eax,-0xc(%ebp)
8010780a:	83 ec 04             	sub    $0x4,%esp
8010780d:	68 00 10 00 00       	push   $0x1000
80107812:	6a 00                	push   $0x0
80107814:	ff 75 f4             	push   -0xc(%ebp)
80107817:	e8 c2 d3 ff ff       	call   80104bde <memset>
8010781c:	83 c4 10             	add    $0x10,%esp
8010781f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107822:	05 00 00 00 80       	add    $0x80000000,%eax
80107827:	83 ec 0c             	sub    $0xc,%esp
8010782a:	6a 06                	push   $0x6
8010782c:	50                   	push   %eax
8010782d:	68 00 10 00 00       	push   $0x1000
80107832:	6a 00                	push   $0x0
80107834:	ff 75 08             	push   0x8(%ebp)
80107837:	e8 5e fc ff ff       	call   8010749a <mappages>
8010783c:	83 c4 20             	add    $0x20,%esp
8010783f:	83 ec 04             	sub    $0x4,%esp
80107842:	ff 75 10             	push   0x10(%ebp)
80107845:	ff 75 0c             	push   0xc(%ebp)
80107848:	ff 75 f4             	push   -0xc(%ebp)
8010784b:	e8 4d d4 ff ff       	call   80104c9d <memmove>
80107850:	83 c4 10             	add    $0x10,%esp
80107853:	90                   	nop
80107854:	c9                   	leave  
80107855:	c3                   	ret    

80107856 <loaduvm>:
80107856:	55                   	push   %ebp
80107857:	89 e5                	mov    %esp,%ebp
80107859:	83 ec 18             	sub    $0x18,%esp
8010785c:	8b 45 0c             	mov    0xc(%ebp),%eax
8010785f:	25 ff 0f 00 00       	and    $0xfff,%eax
80107864:	85 c0                	test   %eax,%eax
80107866:	74 0d                	je     80107875 <loaduvm+0x1f>
80107868:	83 ec 0c             	sub    $0xc,%esp
8010786b:	68 28 a8 10 80       	push   $0x8010a828
80107870:	e8 34 8d ff ff       	call   801005a9 <panic>
80107875:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
8010787c:	e9 8f 00 00 00       	jmp    80107910 <loaduvm+0xba>
80107881:	8b 55 0c             	mov    0xc(%ebp),%edx
80107884:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107887:	01 d0                	add    %edx,%eax
80107889:	83 ec 04             	sub    $0x4,%esp
8010788c:	6a 00                	push   $0x0
8010788e:	50                   	push   %eax
8010788f:	ff 75 08             	push   0x8(%ebp)
80107892:	e8 6d fb ff ff       	call   80107404 <walkpgdir>
80107897:	83 c4 10             	add    $0x10,%esp
8010789a:	89 45 ec             	mov    %eax,-0x14(%ebp)
8010789d:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
801078a1:	75 0d                	jne    801078b0 <loaduvm+0x5a>
801078a3:	83 ec 0c             	sub    $0xc,%esp
801078a6:	68 4b a8 10 80       	push   $0x8010a84b
801078ab:	e8 f9 8c ff ff       	call   801005a9 <panic>
801078b0:	8b 45 ec             	mov    -0x14(%ebp),%eax
801078b3:	8b 00                	mov    (%eax),%eax
801078b5:	25 00 f0 ff ff       	and    $0xfffff000,%eax
801078ba:	89 45 e8             	mov    %eax,-0x18(%ebp)
801078bd:	8b 45 18             	mov    0x18(%ebp),%eax
801078c0:	2b 45 f4             	sub    -0xc(%ebp),%eax
801078c3:	3d ff 0f 00 00       	cmp    $0xfff,%eax
801078c8:	77 0b                	ja     801078d5 <loaduvm+0x7f>
801078ca:	8b 45 18             	mov    0x18(%ebp),%eax
801078cd:	2b 45 f4             	sub    -0xc(%ebp),%eax
801078d0:	89 45 f0             	mov    %eax,-0x10(%ebp)
801078d3:	eb 07                	jmp    801078dc <loaduvm+0x86>
801078d5:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
801078dc:	8b 55 14             	mov    0x14(%ebp),%edx
801078df:	8b 45 f4             	mov    -0xc(%ebp),%eax
801078e2:	01 d0                	add    %edx,%eax
801078e4:	8b 55 e8             	mov    -0x18(%ebp),%edx
801078e7:	81 c2 00 00 00 80    	add    $0x80000000,%edx
801078ed:	ff 75 f0             	push   -0x10(%ebp)
801078f0:	50                   	push   %eax
801078f1:	52                   	push   %edx
801078f2:	ff 75 10             	push   0x10(%ebp)
801078f5:	e8 dc a5 ff ff       	call   80101ed6 <readi>
801078fa:	83 c4 10             	add    $0x10,%esp
801078fd:	39 45 f0             	cmp    %eax,-0x10(%ebp)
80107900:	74 07                	je     80107909 <loaduvm+0xb3>
80107902:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80107907:	eb 18                	jmp    80107921 <loaduvm+0xcb>
80107909:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
80107910:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107913:	3b 45 18             	cmp    0x18(%ebp),%eax
80107916:	0f 82 65 ff ff ff    	jb     80107881 <loaduvm+0x2b>
8010791c:	b8 00 00 00 00       	mov    $0x0,%eax
80107921:	c9                   	leave  
80107922:	c3                   	ret    

80107923 <allocuvm>:
80107923:	55                   	push   %ebp
80107924:	89 e5                	mov    %esp,%ebp
80107926:	83 ec 18             	sub    $0x18,%esp
80107929:	8b 45 10             	mov    0x10(%ebp),%eax
8010792c:	85 c0                	test   %eax,%eax
8010792e:	79 0a                	jns    8010793a <allocuvm+0x17>
80107930:	b8 00 00 00 00       	mov    $0x0,%eax
80107935:	e9 ec 00 00 00       	jmp    80107a26 <allocuvm+0x103>
8010793a:	8b 45 10             	mov    0x10(%ebp),%eax
8010793d:	3b 45 0c             	cmp    0xc(%ebp),%eax
80107940:	73 08                	jae    8010794a <allocuvm+0x27>
80107942:	8b 45 0c             	mov    0xc(%ebp),%eax
80107945:	e9 dc 00 00 00       	jmp    80107a26 <allocuvm+0x103>
8010794a:	8b 45 0c             	mov    0xc(%ebp),%eax
8010794d:	05 ff 0f 00 00       	add    $0xfff,%eax
80107952:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80107957:	89 45 f4             	mov    %eax,-0xc(%ebp)
8010795a:	e9 b8 00 00 00       	jmp    80107a17 <allocuvm+0xf4>
8010795f:	e8 3c ae ff ff       	call   801027a0 <kalloc>
80107964:	89 45 f0             	mov    %eax,-0x10(%ebp)
80107967:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
8010796b:	75 2e                	jne    8010799b <allocuvm+0x78>
8010796d:	83 ec 0c             	sub    $0xc,%esp
80107970:	68 69 a8 10 80       	push   $0x8010a869
80107975:	e8 7a 8a ff ff       	call   801003f4 <cprintf>
8010797a:	83 c4 10             	add    $0x10,%esp
8010797d:	83 ec 04             	sub    $0x4,%esp
80107980:	ff 75 0c             	push   0xc(%ebp)
80107983:	ff 75 10             	push   0x10(%ebp)
80107986:	ff 75 08             	push   0x8(%ebp)
80107989:	e8 9a 00 00 00       	call   80107a28 <deallocuvm>
8010798e:	83 c4 10             	add    $0x10,%esp
80107991:	b8 00 00 00 00       	mov    $0x0,%eax
80107996:	e9 8b 00 00 00       	jmp    80107a26 <allocuvm+0x103>
8010799b:	83 ec 04             	sub    $0x4,%esp
8010799e:	68 00 10 00 00       	push   $0x1000
801079a3:	6a 00                	push   $0x0
801079a5:	ff 75 f0             	push   -0x10(%ebp)
801079a8:	e8 31 d2 ff ff       	call   80104bde <memset>
801079ad:	83 c4 10             	add    $0x10,%esp
801079b0:	8b 45 f0             	mov    -0x10(%ebp),%eax
801079b3:	8d 90 00 00 00 80    	lea    -0x80000000(%eax),%edx
801079b9:	8b 45 f4             	mov    -0xc(%ebp),%eax
801079bc:	83 ec 0c             	sub    $0xc,%esp
801079bf:	6a 06                	push   $0x6
801079c1:	52                   	push   %edx
801079c2:	68 00 10 00 00       	push   $0x1000
801079c7:	50                   	push   %eax
801079c8:	ff 75 08             	push   0x8(%ebp)
801079cb:	e8 ca fa ff ff       	call   8010749a <mappages>
801079d0:	83 c4 20             	add    $0x20,%esp
801079d3:	85 c0                	test   %eax,%eax
801079d5:	79 39                	jns    80107a10 <allocuvm+0xed>
801079d7:	83 ec 0c             	sub    $0xc,%esp
801079da:	68 81 a8 10 80       	push   $0x8010a881
801079df:	e8 10 8a ff ff       	call   801003f4 <cprintf>
801079e4:	83 c4 10             	add    $0x10,%esp
801079e7:	83 ec 04             	sub    $0x4,%esp
801079ea:	ff 75 0c             	push   0xc(%ebp)
801079ed:	ff 75 10             	push   0x10(%ebp)
801079f0:	ff 75 08             	push   0x8(%ebp)
801079f3:	e8 30 00 00 00       	call   80107a28 <deallocuvm>
801079f8:	83 c4 10             	add    $0x10,%esp
801079fb:	83 ec 0c             	sub    $0xc,%esp
801079fe:	ff 75 f0             	push   -0x10(%ebp)
80107a01:	e8 00 ad ff ff       	call   80102706 <kfree>
80107a06:	83 c4 10             	add    $0x10,%esp
80107a09:	b8 00 00 00 00       	mov    $0x0,%eax
80107a0e:	eb 16                	jmp    80107a26 <allocuvm+0x103>
80107a10:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
80107a17:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107a1a:	3b 45 10             	cmp    0x10(%ebp),%eax
80107a1d:	0f 82 3c ff ff ff    	jb     8010795f <allocuvm+0x3c>
80107a23:	8b 45 10             	mov    0x10(%ebp),%eax
80107a26:	c9                   	leave  
80107a27:	c3                   	ret    

80107a28 <deallocuvm>:
80107a28:	55                   	push   %ebp
80107a29:	89 e5                	mov    %esp,%ebp
80107a2b:	83 ec 18             	sub    $0x18,%esp
80107a2e:	8b 45 10             	mov    0x10(%ebp),%eax
80107a31:	3b 45 0c             	cmp    0xc(%ebp),%eax
80107a34:	72 08                	jb     80107a3e <deallocuvm+0x16>
80107a36:	8b 45 0c             	mov    0xc(%ebp),%eax
80107a39:	e9 ac 00 00 00       	jmp    80107aea <deallocuvm+0xc2>
80107a3e:	8b 45 10             	mov    0x10(%ebp),%eax
80107a41:	05 ff 0f 00 00       	add    $0xfff,%eax
80107a46:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80107a4b:	89 45 f4             	mov    %eax,-0xc(%ebp)
80107a4e:	e9 88 00 00 00       	jmp    80107adb <deallocuvm+0xb3>
80107a53:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107a56:	83 ec 04             	sub    $0x4,%esp
80107a59:	6a 00                	push   $0x0
80107a5b:	50                   	push   %eax
80107a5c:	ff 75 08             	push   0x8(%ebp)
80107a5f:	e8 a0 f9 ff ff       	call   80107404 <walkpgdir>
80107a64:	83 c4 10             	add    $0x10,%esp
80107a67:	89 45 f0             	mov    %eax,-0x10(%ebp)
80107a6a:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80107a6e:	75 16                	jne    80107a86 <deallocuvm+0x5e>
80107a70:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107a73:	c1 e8 16             	shr    $0x16,%eax
80107a76:	83 c0 01             	add    $0x1,%eax
80107a79:	c1 e0 16             	shl    $0x16,%eax
80107a7c:	2d 00 10 00 00       	sub    $0x1000,%eax
80107a81:	89 45 f4             	mov    %eax,-0xc(%ebp)
80107a84:	eb 4e                	jmp    80107ad4 <deallocuvm+0xac>
80107a86:	8b 45 f0             	mov    -0x10(%ebp),%eax
80107a89:	8b 00                	mov    (%eax),%eax
80107a8b:	83 e0 01             	and    $0x1,%eax
80107a8e:	85 c0                	test   %eax,%eax
80107a90:	74 42                	je     80107ad4 <deallocuvm+0xac>
80107a92:	8b 45 f0             	mov    -0x10(%ebp),%eax
80107a95:	8b 00                	mov    (%eax),%eax
80107a97:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80107a9c:	89 45 ec             	mov    %eax,-0x14(%ebp)
80107a9f:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
80107aa3:	75 0d                	jne    80107ab2 <deallocuvm+0x8a>
80107aa5:	83 ec 0c             	sub    $0xc,%esp
80107aa8:	68 9d a8 10 80       	push   $0x8010a89d
80107aad:	e8 f7 8a ff ff       	call   801005a9 <panic>
80107ab2:	8b 45 ec             	mov    -0x14(%ebp),%eax
80107ab5:	05 00 00 00 80       	add    $0x80000000,%eax
80107aba:	89 45 e8             	mov    %eax,-0x18(%ebp)
80107abd:	83 ec 0c             	sub    $0xc,%esp
80107ac0:	ff 75 e8             	push   -0x18(%ebp)
80107ac3:	e8 3e ac ff ff       	call   80102706 <kfree>
80107ac8:	83 c4 10             	add    $0x10,%esp
80107acb:	8b 45 f0             	mov    -0x10(%ebp),%eax
80107ace:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
80107ad4:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
80107adb:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107ade:	3b 45 0c             	cmp    0xc(%ebp),%eax
80107ae1:	0f 82 6c ff ff ff    	jb     80107a53 <deallocuvm+0x2b>
80107ae7:	8b 45 10             	mov    0x10(%ebp),%eax
80107aea:	c9                   	leave  
80107aeb:	c3                   	ret    

80107aec <freevm>:
80107aec:	55                   	push   %ebp
80107aed:	89 e5                	mov    %esp,%ebp
80107aef:	83 ec 18             	sub    $0x18,%esp
80107af2:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
80107af6:	75 0d                	jne    80107b05 <freevm+0x19>
80107af8:	83 ec 0c             	sub    $0xc,%esp
80107afb:	68 a3 a8 10 80       	push   $0x8010a8a3
80107b00:	e8 a4 8a ff ff       	call   801005a9 <panic>
80107b05:	83 ec 04             	sub    $0x4,%esp
80107b08:	6a 00                	push   $0x0
80107b0a:	68 00 00 00 80       	push   $0x80000000
80107b0f:	ff 75 08             	push   0x8(%ebp)
80107b12:	e8 11 ff ff ff       	call   80107a28 <deallocuvm>
80107b17:	83 c4 10             	add    $0x10,%esp
80107b1a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80107b21:	eb 48                	jmp    80107b6b <freevm+0x7f>
80107b23:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107b26:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80107b2d:	8b 45 08             	mov    0x8(%ebp),%eax
80107b30:	01 d0                	add    %edx,%eax
80107b32:	8b 00                	mov    (%eax),%eax
80107b34:	83 e0 01             	and    $0x1,%eax
80107b37:	85 c0                	test   %eax,%eax
80107b39:	74 2c                	je     80107b67 <freevm+0x7b>
80107b3b:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107b3e:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80107b45:	8b 45 08             	mov    0x8(%ebp),%eax
80107b48:	01 d0                	add    %edx,%eax
80107b4a:	8b 00                	mov    (%eax),%eax
80107b4c:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80107b51:	05 00 00 00 80       	add    $0x80000000,%eax
80107b56:	89 45 f0             	mov    %eax,-0x10(%ebp)
80107b59:	83 ec 0c             	sub    $0xc,%esp
80107b5c:	ff 75 f0             	push   -0x10(%ebp)
80107b5f:	e8 a2 ab ff ff       	call   80102706 <kfree>
80107b64:	83 c4 10             	add    $0x10,%esp
80107b67:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80107b6b:	81 7d f4 ff 03 00 00 	cmpl   $0x3ff,-0xc(%ebp)
80107b72:	76 af                	jbe    80107b23 <freevm+0x37>
80107b74:	83 ec 0c             	sub    $0xc,%esp
80107b77:	ff 75 08             	push   0x8(%ebp)
80107b7a:	e8 87 ab ff ff       	call   80102706 <kfree>
80107b7f:	83 c4 10             	add    $0x10,%esp
80107b82:	90                   	nop
80107b83:	c9                   	leave  
80107b84:	c3                   	ret    

80107b85 <clearpteu>:
80107b85:	55                   	push   %ebp
80107b86:	89 e5                	mov    %esp,%ebp
80107b88:	83 ec 18             	sub    $0x18,%esp
80107b8b:	83 ec 04             	sub    $0x4,%esp
80107b8e:	6a 00                	push   $0x0
80107b90:	ff 75 0c             	push   0xc(%ebp)
80107b93:	ff 75 08             	push   0x8(%ebp)
80107b96:	e8 69 f8 ff ff       	call   80107404 <walkpgdir>
80107b9b:	83 c4 10             	add    $0x10,%esp
80107b9e:	89 45 f4             	mov    %eax,-0xc(%ebp)
80107ba1:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80107ba5:	75 0d                	jne    80107bb4 <clearpteu+0x2f>
80107ba7:	83 ec 0c             	sub    $0xc,%esp
80107baa:	68 b4 a8 10 80       	push   $0x8010a8b4
80107baf:	e8 f5 89 ff ff       	call   801005a9 <panic>
80107bb4:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107bb7:	8b 00                	mov    (%eax),%eax
80107bb9:	83 e0 fb             	and    $0xfffffffb,%eax
80107bbc:	89 c2                	mov    %eax,%edx
80107bbe:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107bc1:	89 10                	mov    %edx,(%eax)
80107bc3:	90                   	nop
80107bc4:	c9                   	leave  
80107bc5:	c3                   	ret    

80107bc6 <copyuvm>:
80107bc6:	55                   	push   %ebp
80107bc7:	89 e5                	mov    %esp,%ebp
80107bc9:	83 ec 28             	sub    $0x28,%esp
80107bcc:	e8 59 f9 ff ff       	call   8010752a <setupkvm>
80107bd1:	89 45 f0             	mov    %eax,-0x10(%ebp)
80107bd4:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80107bd8:	75 0a                	jne    80107be4 <copyuvm+0x1e>
80107bda:	b8 00 00 00 00       	mov    $0x0,%eax
80107bdf:	e9 eb 00 00 00       	jmp    80107ccf <copyuvm+0x109>
80107be4:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80107beb:	e9 b7 00 00 00       	jmp    80107ca7 <copyuvm+0xe1>
80107bf0:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107bf3:	83 ec 04             	sub    $0x4,%esp
80107bf6:	6a 00                	push   $0x0
80107bf8:	50                   	push   %eax
80107bf9:	ff 75 08             	push   0x8(%ebp)
80107bfc:	e8 03 f8 ff ff       	call   80107404 <walkpgdir>
80107c01:	83 c4 10             	add    $0x10,%esp
80107c04:	89 45 ec             	mov    %eax,-0x14(%ebp)
80107c07:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
80107c0b:	75 0d                	jne    80107c1a <copyuvm+0x54>
80107c0d:	83 ec 0c             	sub    $0xc,%esp
80107c10:	68 be a8 10 80       	push   $0x8010a8be
80107c15:	e8 8f 89 ff ff       	call   801005a9 <panic>
80107c1a:	8b 45 ec             	mov    -0x14(%ebp),%eax
80107c1d:	8b 00                	mov    (%eax),%eax
80107c1f:	83 e0 01             	and    $0x1,%eax
80107c22:	85 c0                	test   %eax,%eax
80107c24:	75 0d                	jne    80107c33 <copyuvm+0x6d>
80107c26:	83 ec 0c             	sub    $0xc,%esp
80107c29:	68 d8 a8 10 80       	push   $0x8010a8d8
80107c2e:	e8 76 89 ff ff       	call   801005a9 <panic>
80107c33:	8b 45 ec             	mov    -0x14(%ebp),%eax
80107c36:	8b 00                	mov    (%eax),%eax
80107c38:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80107c3d:	89 45 e8             	mov    %eax,-0x18(%ebp)
80107c40:	8b 45 ec             	mov    -0x14(%ebp),%eax
80107c43:	8b 00                	mov    (%eax),%eax
80107c45:	25 ff 0f 00 00       	and    $0xfff,%eax
80107c4a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80107c4d:	e8 4e ab ff ff       	call   801027a0 <kalloc>
80107c52:	89 45 e0             	mov    %eax,-0x20(%ebp)
80107c55:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
80107c59:	74 5d                	je     80107cb8 <copyuvm+0xf2>
80107c5b:	8b 45 e8             	mov    -0x18(%ebp),%eax
80107c5e:	05 00 00 00 80       	add    $0x80000000,%eax
80107c63:	83 ec 04             	sub    $0x4,%esp
80107c66:	68 00 10 00 00       	push   $0x1000
80107c6b:	50                   	push   %eax
80107c6c:	ff 75 e0             	push   -0x20(%ebp)
80107c6f:	e8 29 d0 ff ff       	call   80104c9d <memmove>
80107c74:	83 c4 10             	add    $0x10,%esp
80107c77:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80107c7a:	8b 45 e0             	mov    -0x20(%ebp),%eax
80107c7d:	8d 88 00 00 00 80    	lea    -0x80000000(%eax),%ecx
80107c83:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107c86:	83 ec 0c             	sub    $0xc,%esp
80107c89:	52                   	push   %edx
80107c8a:	51                   	push   %ecx
80107c8b:	68 00 10 00 00       	push   $0x1000
80107c90:	50                   	push   %eax
80107c91:	ff 75 f0             	push   -0x10(%ebp)
80107c94:	e8 01 f8 ff ff       	call   8010749a <mappages>
80107c99:	83 c4 20             	add    $0x20,%esp
80107c9c:	85 c0                	test   %eax,%eax
80107c9e:	78 1b                	js     80107cbb <copyuvm+0xf5>
80107ca0:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
80107ca7:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107caa:	3b 45 0c             	cmp    0xc(%ebp),%eax
80107cad:	0f 82 3d ff ff ff    	jb     80107bf0 <copyuvm+0x2a>
80107cb3:	8b 45 f0             	mov    -0x10(%ebp),%eax
80107cb6:	eb 17                	jmp    80107ccf <copyuvm+0x109>
80107cb8:	90                   	nop
80107cb9:	eb 01                	jmp    80107cbc <copyuvm+0xf6>
80107cbb:	90                   	nop
80107cbc:	83 ec 0c             	sub    $0xc,%esp
80107cbf:	ff 75 f0             	push   -0x10(%ebp)
80107cc2:	e8 25 fe ff ff       	call   80107aec <freevm>
80107cc7:	83 c4 10             	add    $0x10,%esp
80107cca:	b8 00 00 00 00       	mov    $0x0,%eax
80107ccf:	c9                   	leave  
80107cd0:	c3                   	ret    

80107cd1 <uva2ka>:
80107cd1:	55                   	push   %ebp
80107cd2:	89 e5                	mov    %esp,%ebp
80107cd4:	83 ec 18             	sub    $0x18,%esp
80107cd7:	83 ec 04             	sub    $0x4,%esp
80107cda:	6a 00                	push   $0x0
80107cdc:	ff 75 0c             	push   0xc(%ebp)
80107cdf:	ff 75 08             	push   0x8(%ebp)
80107ce2:	e8 1d f7 ff ff       	call   80107404 <walkpgdir>
80107ce7:	83 c4 10             	add    $0x10,%esp
80107cea:	89 45 f4             	mov    %eax,-0xc(%ebp)
80107ced:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107cf0:	8b 00                	mov    (%eax),%eax
80107cf2:	83 e0 01             	and    $0x1,%eax
80107cf5:	85 c0                	test   %eax,%eax
80107cf7:	75 07                	jne    80107d00 <uva2ka+0x2f>
80107cf9:	b8 00 00 00 00       	mov    $0x0,%eax
80107cfe:	eb 22                	jmp    80107d22 <uva2ka+0x51>
80107d00:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107d03:	8b 00                	mov    (%eax),%eax
80107d05:	83 e0 04             	and    $0x4,%eax
80107d08:	85 c0                	test   %eax,%eax
80107d0a:	75 07                	jne    80107d13 <uva2ka+0x42>
80107d0c:	b8 00 00 00 00       	mov    $0x0,%eax
80107d11:	eb 0f                	jmp    80107d22 <uva2ka+0x51>
80107d13:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107d16:	8b 00                	mov    (%eax),%eax
80107d18:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80107d1d:	05 00 00 00 80       	add    $0x80000000,%eax
80107d22:	c9                   	leave  
80107d23:	c3                   	ret    

80107d24 <copyout>:
80107d24:	55                   	push   %ebp
80107d25:	89 e5                	mov    %esp,%ebp
80107d27:	83 ec 18             	sub    $0x18,%esp
80107d2a:	8b 45 10             	mov    0x10(%ebp),%eax
80107d2d:	89 45 f4             	mov    %eax,-0xc(%ebp)
80107d30:	eb 7f                	jmp    80107db1 <copyout+0x8d>
80107d32:	8b 45 0c             	mov    0xc(%ebp),%eax
80107d35:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80107d3a:	89 45 ec             	mov    %eax,-0x14(%ebp)
80107d3d:	8b 45 ec             	mov    -0x14(%ebp),%eax
80107d40:	83 ec 08             	sub    $0x8,%esp
80107d43:	50                   	push   %eax
80107d44:	ff 75 08             	push   0x8(%ebp)
80107d47:	e8 85 ff ff ff       	call   80107cd1 <uva2ka>
80107d4c:	83 c4 10             	add    $0x10,%esp
80107d4f:	89 45 e8             	mov    %eax,-0x18(%ebp)
80107d52:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
80107d56:	75 07                	jne    80107d5f <copyout+0x3b>
80107d58:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80107d5d:	eb 61                	jmp    80107dc0 <copyout+0x9c>
80107d5f:	8b 45 ec             	mov    -0x14(%ebp),%eax
80107d62:	2b 45 0c             	sub    0xc(%ebp),%eax
80107d65:	05 00 10 00 00       	add    $0x1000,%eax
80107d6a:	89 45 f0             	mov    %eax,-0x10(%ebp)
80107d6d:	8b 45 f0             	mov    -0x10(%ebp),%eax
80107d70:	3b 45 14             	cmp    0x14(%ebp),%eax
80107d73:	76 06                	jbe    80107d7b <copyout+0x57>
80107d75:	8b 45 14             	mov    0x14(%ebp),%eax
80107d78:	89 45 f0             	mov    %eax,-0x10(%ebp)
80107d7b:	8b 45 0c             	mov    0xc(%ebp),%eax
80107d7e:	2b 45 ec             	sub    -0x14(%ebp),%eax
80107d81:	89 c2                	mov    %eax,%edx
80107d83:	8b 45 e8             	mov    -0x18(%ebp),%eax
80107d86:	01 d0                	add    %edx,%eax
80107d88:	83 ec 04             	sub    $0x4,%esp
80107d8b:	ff 75 f0             	push   -0x10(%ebp)
80107d8e:	ff 75 f4             	push   -0xc(%ebp)
80107d91:	50                   	push   %eax
80107d92:	e8 06 cf ff ff       	call   80104c9d <memmove>
80107d97:	83 c4 10             	add    $0x10,%esp
80107d9a:	8b 45 f0             	mov    -0x10(%ebp),%eax
80107d9d:	29 45 14             	sub    %eax,0x14(%ebp)
80107da0:	8b 45 f0             	mov    -0x10(%ebp),%eax
80107da3:	01 45 f4             	add    %eax,-0xc(%ebp)
80107da6:	8b 45 ec             	mov    -0x14(%ebp),%eax
80107da9:	05 00 10 00 00       	add    $0x1000,%eax
80107dae:	89 45 0c             	mov    %eax,0xc(%ebp)
80107db1:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
80107db5:	0f 85 77 ff ff ff    	jne    80107d32 <copyout+0xe>
80107dbb:	b8 00 00 00 00       	mov    $0x0,%eax
80107dc0:	c9                   	leave  
80107dc1:	c3                   	ret    

80107dc2 <mpinit_uefi>:
80107dc2:	55                   	push   %ebp
80107dc3:	89 e5                	mov    %esp,%ebp
80107dc5:	83 ec 20             	sub    $0x20,%esp
80107dc8:	c7 45 f8 00 00 05 80 	movl   $0x80050000,-0x8(%ebp)
80107dcf:	8b 45 f8             	mov    -0x8(%ebp),%eax
80107dd2:	8b 40 08             	mov    0x8(%eax),%eax
80107dd5:	05 00 00 00 80       	add    $0x80000000,%eax
80107dda:	89 45 f4             	mov    %eax,-0xc(%ebp)
80107ddd:	c7 45 fc 2c 00 00 00 	movl   $0x2c,-0x4(%ebp)
80107de4:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107de7:	8b 40 24             	mov    0x24(%eax),%eax
80107dea:	a3 00 41 19 80       	mov    %eax,0x80194100
80107def:	c7 05 40 6d 19 80 00 	movl   $0x0,0x80196d40
80107df6:	00 00 00 
80107df9:	90                   	nop
80107dfa:	e9 bd 00 00 00       	jmp    80107ebc <mpinit_uefi+0xfa>
80107dff:	8b 55 f4             	mov    -0xc(%ebp),%edx
80107e02:	8b 45 fc             	mov    -0x4(%ebp),%eax
80107e05:	01 d0                	add    %edx,%eax
80107e07:	89 45 f0             	mov    %eax,-0x10(%ebp)
80107e0a:	8b 45 f0             	mov    -0x10(%ebp),%eax
80107e0d:	0f b6 00             	movzbl (%eax),%eax
80107e10:	0f b6 c0             	movzbl %al,%eax
80107e13:	83 f8 05             	cmp    $0x5,%eax
80107e16:	0f 87 a0 00 00 00    	ja     80107ebc <mpinit_uefi+0xfa>
80107e1c:	8b 04 85 f4 a8 10 80 	mov    -0x7fef570c(,%eax,4),%eax
80107e23:	ff e0                	jmp    *%eax
80107e25:	8b 45 f0             	mov    -0x10(%ebp),%eax
80107e28:	89 45 e0             	mov    %eax,-0x20(%ebp)
80107e2b:	a1 40 6d 19 80       	mov    0x80196d40,%eax
80107e30:	83 f8 03             	cmp    $0x3,%eax
80107e33:	7f 28                	jg     80107e5d <mpinit_uefi+0x9b>
80107e35:	8b 15 40 6d 19 80    	mov    0x80196d40,%edx
80107e3b:	8b 45 e0             	mov    -0x20(%ebp),%eax
80107e3e:	0f b6 40 03          	movzbl 0x3(%eax),%eax
80107e42:	69 d2 b0 00 00 00    	imul   $0xb0,%edx,%edx
80107e48:	81 c2 80 6a 19 80    	add    $0x80196a80,%edx
80107e4e:	88 02                	mov    %al,(%edx)
80107e50:	a1 40 6d 19 80       	mov    0x80196d40,%eax
80107e55:	83 c0 01             	add    $0x1,%eax
80107e58:	a3 40 6d 19 80       	mov    %eax,0x80196d40
80107e5d:	8b 45 e0             	mov    -0x20(%ebp),%eax
80107e60:	0f b6 40 01          	movzbl 0x1(%eax),%eax
80107e64:	0f b6 c0             	movzbl %al,%eax
80107e67:	01 45 fc             	add    %eax,-0x4(%ebp)
80107e6a:	eb 50                	jmp    80107ebc <mpinit_uefi+0xfa>
80107e6c:	8b 45 f0             	mov    -0x10(%ebp),%eax
80107e6f:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80107e72:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80107e75:	0f b6 40 02          	movzbl 0x2(%eax),%eax
80107e79:	a2 44 6d 19 80       	mov    %al,0x80196d44
80107e7e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80107e81:	0f b6 40 01          	movzbl 0x1(%eax),%eax
80107e85:	0f b6 c0             	movzbl %al,%eax
80107e88:	01 45 fc             	add    %eax,-0x4(%ebp)
80107e8b:	eb 2f                	jmp    80107ebc <mpinit_uefi+0xfa>
80107e8d:	8b 45 f0             	mov    -0x10(%ebp),%eax
80107e90:	89 45 e8             	mov    %eax,-0x18(%ebp)
80107e93:	8b 45 e8             	mov    -0x18(%ebp),%eax
80107e96:	0f b6 40 01          	movzbl 0x1(%eax),%eax
80107e9a:	0f b6 c0             	movzbl %al,%eax
80107e9d:	01 45 fc             	add    %eax,-0x4(%ebp)
80107ea0:	eb 1a                	jmp    80107ebc <mpinit_uefi+0xfa>
80107ea2:	8b 45 f0             	mov    -0x10(%ebp),%eax
80107ea5:	89 45 ec             	mov    %eax,-0x14(%ebp)
80107ea8:	8b 45 ec             	mov    -0x14(%ebp),%eax
80107eab:	0f b6 40 01          	movzbl 0x1(%eax),%eax
80107eaf:	0f b6 c0             	movzbl %al,%eax
80107eb2:	01 45 fc             	add    %eax,-0x4(%ebp)
80107eb5:	eb 05                	jmp    80107ebc <mpinit_uefi+0xfa>
80107eb7:	83 45 fc 0c          	addl   $0xc,-0x4(%ebp)
80107ebb:	90                   	nop
80107ebc:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107ebf:	8b 40 04             	mov    0x4(%eax),%eax
80107ec2:	39 45 fc             	cmp    %eax,-0x4(%ebp)
80107ec5:	0f 82 34 ff ff ff    	jb     80107dff <mpinit_uefi+0x3d>
80107ecb:	90                   	nop
80107ecc:	90                   	nop
80107ecd:	c9                   	leave  
80107ece:	c3                   	ret    

80107ecf <inb>:
80107ecf:	55                   	push   %ebp
80107ed0:	89 e5                	mov    %esp,%ebp
80107ed2:	83 ec 14             	sub    $0x14,%esp
80107ed5:	8b 45 08             	mov    0x8(%ebp),%eax
80107ed8:	66 89 45 ec          	mov    %ax,-0x14(%ebp)
80107edc:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
80107ee0:	89 c2                	mov    %eax,%edx
80107ee2:	ec                   	in     (%dx),%al
80107ee3:	88 45 ff             	mov    %al,-0x1(%ebp)
80107ee6:	0f b6 45 ff          	movzbl -0x1(%ebp),%eax
80107eea:	c9                   	leave  
80107eeb:	c3                   	ret    

80107eec <outb>:
80107eec:	55                   	push   %ebp
80107eed:	89 e5                	mov    %esp,%ebp
80107eef:	83 ec 08             	sub    $0x8,%esp
80107ef2:	8b 45 08             	mov    0x8(%ebp),%eax
80107ef5:	8b 55 0c             	mov    0xc(%ebp),%edx
80107ef8:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
80107efc:	89 d0                	mov    %edx,%eax
80107efe:	88 45 f8             	mov    %al,-0x8(%ebp)
80107f01:	0f b6 45 f8          	movzbl -0x8(%ebp),%eax
80107f05:	0f b7 55 fc          	movzwl -0x4(%ebp),%edx
80107f09:	ee                   	out    %al,(%dx)
80107f0a:	90                   	nop
80107f0b:	c9                   	leave  
80107f0c:	c3                   	ret    

80107f0d <uart_debug>:
80107f0d:	55                   	push   %ebp
80107f0e:	89 e5                	mov    %esp,%ebp
80107f10:	83 ec 28             	sub    $0x28,%esp
80107f13:	8b 45 08             	mov    0x8(%ebp),%eax
80107f16:	88 45 e4             	mov    %al,-0x1c(%ebp)
80107f19:	6a 00                	push   $0x0
80107f1b:	68 fa 03 00 00       	push   $0x3fa
80107f20:	e8 c7 ff ff ff       	call   80107eec <outb>
80107f25:	83 c4 08             	add    $0x8,%esp
80107f28:	68 80 00 00 00       	push   $0x80
80107f2d:	68 fb 03 00 00       	push   $0x3fb
80107f32:	e8 b5 ff ff ff       	call   80107eec <outb>
80107f37:	83 c4 08             	add    $0x8,%esp
80107f3a:	6a 0c                	push   $0xc
80107f3c:	68 f8 03 00 00       	push   $0x3f8
80107f41:	e8 a6 ff ff ff       	call   80107eec <outb>
80107f46:	83 c4 08             	add    $0x8,%esp
80107f49:	6a 00                	push   $0x0
80107f4b:	68 f9 03 00 00       	push   $0x3f9
80107f50:	e8 97 ff ff ff       	call   80107eec <outb>
80107f55:	83 c4 08             	add    $0x8,%esp
80107f58:	6a 03                	push   $0x3
80107f5a:	68 fb 03 00 00       	push   $0x3fb
80107f5f:	e8 88 ff ff ff       	call   80107eec <outb>
80107f64:	83 c4 08             	add    $0x8,%esp
80107f67:	6a 00                	push   $0x0
80107f69:	68 fc 03 00 00       	push   $0x3fc
80107f6e:	e8 79 ff ff ff       	call   80107eec <outb>
80107f73:	83 c4 08             	add    $0x8,%esp
80107f76:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80107f7d:	eb 11                	jmp    80107f90 <uart_debug+0x83>
80107f7f:	83 ec 0c             	sub    $0xc,%esp
80107f82:	6a 0a                	push   $0xa
80107f84:	e8 ae ab ff ff       	call   80102b37 <microdelay>
80107f89:	83 c4 10             	add    $0x10,%esp
80107f8c:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80107f90:	83 7d f4 7f          	cmpl   $0x7f,-0xc(%ebp)
80107f94:	7f 1a                	jg     80107fb0 <uart_debug+0xa3>
80107f96:	83 ec 0c             	sub    $0xc,%esp
80107f99:	68 fd 03 00 00       	push   $0x3fd
80107f9e:	e8 2c ff ff ff       	call   80107ecf <inb>
80107fa3:	83 c4 10             	add    $0x10,%esp
80107fa6:	0f b6 c0             	movzbl %al,%eax
80107fa9:	83 e0 20             	and    $0x20,%eax
80107fac:	85 c0                	test   %eax,%eax
80107fae:	74 cf                	je     80107f7f <uart_debug+0x72>
80107fb0:	0f b6 45 e4          	movzbl -0x1c(%ebp),%eax
80107fb4:	0f b6 c0             	movzbl %al,%eax
80107fb7:	83 ec 08             	sub    $0x8,%esp
80107fba:	50                   	push   %eax
80107fbb:	68 f8 03 00 00       	push   $0x3f8
80107fc0:	e8 27 ff ff ff       	call   80107eec <outb>
80107fc5:	83 c4 10             	add    $0x10,%esp
80107fc8:	90                   	nop
80107fc9:	c9                   	leave  
80107fca:	c3                   	ret    

80107fcb <uart_debugs>:
80107fcb:	55                   	push   %ebp
80107fcc:	89 e5                	mov    %esp,%ebp
80107fce:	83 ec 08             	sub    $0x8,%esp
80107fd1:	eb 1b                	jmp    80107fee <uart_debugs+0x23>
80107fd3:	8b 45 08             	mov    0x8(%ebp),%eax
80107fd6:	8d 50 01             	lea    0x1(%eax),%edx
80107fd9:	89 55 08             	mov    %edx,0x8(%ebp)
80107fdc:	0f b6 00             	movzbl (%eax),%eax
80107fdf:	0f be c0             	movsbl %al,%eax
80107fe2:	83 ec 0c             	sub    $0xc,%esp
80107fe5:	50                   	push   %eax
80107fe6:	e8 22 ff ff ff       	call   80107f0d <uart_debug>
80107feb:	83 c4 10             	add    $0x10,%esp
80107fee:	8b 45 08             	mov    0x8(%ebp),%eax
80107ff1:	0f b6 00             	movzbl (%eax),%eax
80107ff4:	84 c0                	test   %al,%al
80107ff6:	75 db                	jne    80107fd3 <uart_debugs+0x8>
80107ff8:	90                   	nop
80107ff9:	90                   	nop
80107ffa:	c9                   	leave  
80107ffb:	c3                   	ret    

80107ffc <graphic_init>:
80107ffc:	55                   	push   %ebp
80107ffd:	89 e5                	mov    %esp,%ebp
80107fff:	83 ec 10             	sub    $0x10,%esp
80108002:	c7 45 fc 00 00 05 80 	movl   $0x80050000,-0x4(%ebp)
80108009:	8b 45 fc             	mov    -0x4(%ebp),%eax
8010800c:	8b 50 14             	mov    0x14(%eax),%edx
8010800f:	8b 40 10             	mov    0x10(%eax),%eax
80108012:	a3 48 6d 19 80       	mov    %eax,0x80196d48
80108017:	8b 45 fc             	mov    -0x4(%ebp),%eax
8010801a:	8b 50 1c             	mov    0x1c(%eax),%edx
8010801d:	8b 40 18             	mov    0x18(%eax),%eax
80108020:	a3 50 6d 19 80       	mov    %eax,0x80196d50
80108025:	8b 15 50 6d 19 80    	mov    0x80196d50,%edx
8010802b:	b8 00 00 00 fe       	mov    $0xfe000000,%eax
80108030:	29 d0                	sub    %edx,%eax
80108032:	a3 4c 6d 19 80       	mov    %eax,0x80196d4c
80108037:	8b 45 fc             	mov    -0x4(%ebp),%eax
8010803a:	8b 50 24             	mov    0x24(%eax),%edx
8010803d:	8b 40 20             	mov    0x20(%eax),%eax
80108040:	a3 54 6d 19 80       	mov    %eax,0x80196d54
80108045:	8b 45 fc             	mov    -0x4(%ebp),%eax
80108048:	8b 50 2c             	mov    0x2c(%eax),%edx
8010804b:	8b 40 28             	mov    0x28(%eax),%eax
8010804e:	a3 58 6d 19 80       	mov    %eax,0x80196d58
80108053:	8b 45 fc             	mov    -0x4(%ebp),%eax
80108056:	8b 50 34             	mov    0x34(%eax),%edx
80108059:	8b 40 30             	mov    0x30(%eax),%eax
8010805c:	a3 5c 6d 19 80       	mov    %eax,0x80196d5c
80108061:	90                   	nop
80108062:	c9                   	leave  
80108063:	c3                   	ret    

80108064 <graphic_draw_pixel>:
80108064:	55                   	push   %ebp
80108065:	89 e5                	mov    %esp,%ebp
80108067:	83 ec 10             	sub    $0x10,%esp
8010806a:	8b 15 5c 6d 19 80    	mov    0x80196d5c,%edx
80108070:	8b 45 0c             	mov    0xc(%ebp),%eax
80108073:	0f af d0             	imul   %eax,%edx
80108076:	8b 45 08             	mov    0x8(%ebp),%eax
80108079:	01 d0                	add    %edx,%eax
8010807b:	c1 e0 02             	shl    $0x2,%eax
8010807e:	89 45 fc             	mov    %eax,-0x4(%ebp)
80108081:	8b 15 4c 6d 19 80    	mov    0x80196d4c,%edx
80108087:	8b 45 fc             	mov    -0x4(%ebp),%eax
8010808a:	01 d0                	add    %edx,%eax
8010808c:	89 45 f8             	mov    %eax,-0x8(%ebp)
8010808f:	8b 45 10             	mov    0x10(%ebp),%eax
80108092:	0f b6 10             	movzbl (%eax),%edx
80108095:	8b 45 f8             	mov    -0x8(%ebp),%eax
80108098:	88 10                	mov    %dl,(%eax)
8010809a:	8b 45 10             	mov    0x10(%ebp),%eax
8010809d:	0f b6 50 01          	movzbl 0x1(%eax),%edx
801080a1:	8b 45 f8             	mov    -0x8(%ebp),%eax
801080a4:	88 50 01             	mov    %dl,0x1(%eax)
801080a7:	8b 45 10             	mov    0x10(%ebp),%eax
801080aa:	0f b6 50 02          	movzbl 0x2(%eax),%edx
801080ae:	8b 45 f8             	mov    -0x8(%ebp),%eax
801080b1:	88 50 02             	mov    %dl,0x2(%eax)
801080b4:	90                   	nop
801080b5:	c9                   	leave  
801080b6:	c3                   	ret    

801080b7 <graphic_scroll_up>:
801080b7:	55                   	push   %ebp
801080b8:	89 e5                	mov    %esp,%ebp
801080ba:	83 ec 18             	sub    $0x18,%esp
801080bd:	8b 15 5c 6d 19 80    	mov    0x80196d5c,%edx
801080c3:	8b 45 08             	mov    0x8(%ebp),%eax
801080c6:	0f af c2             	imul   %edx,%eax
801080c9:	c1 e0 02             	shl    $0x2,%eax
801080cc:	89 45 f4             	mov    %eax,-0xc(%ebp)
801080cf:	a1 50 6d 19 80       	mov    0x80196d50,%eax
801080d4:	8b 55 f4             	mov    -0xc(%ebp),%edx
801080d7:	29 d0                	sub    %edx,%eax
801080d9:	8b 0d 4c 6d 19 80    	mov    0x80196d4c,%ecx
801080df:	8b 55 f4             	mov    -0xc(%ebp),%edx
801080e2:	01 ca                	add    %ecx,%edx
801080e4:	89 d1                	mov    %edx,%ecx
801080e6:	8b 15 4c 6d 19 80    	mov    0x80196d4c,%edx
801080ec:	83 ec 04             	sub    $0x4,%esp
801080ef:	50                   	push   %eax
801080f0:	51                   	push   %ecx
801080f1:	52                   	push   %edx
801080f2:	e8 a6 cb ff ff       	call   80104c9d <memmove>
801080f7:	83 c4 10             	add    $0x10,%esp
801080fa:	8b 45 f4             	mov    -0xc(%ebp),%eax
801080fd:	8b 0d 4c 6d 19 80    	mov    0x80196d4c,%ecx
80108103:	8b 15 50 6d 19 80    	mov    0x80196d50,%edx
80108109:	01 ca                	add    %ecx,%edx
8010810b:	8b 4d f4             	mov    -0xc(%ebp),%ecx
8010810e:	29 ca                	sub    %ecx,%edx
80108110:	83 ec 04             	sub    $0x4,%esp
80108113:	50                   	push   %eax
80108114:	6a 00                	push   $0x0
80108116:	52                   	push   %edx
80108117:	e8 c2 ca ff ff       	call   80104bde <memset>
8010811c:	83 c4 10             	add    $0x10,%esp
8010811f:	90                   	nop
80108120:	c9                   	leave  
80108121:	c3                   	ret    

80108122 <font_render>:
80108122:	55                   	push   %ebp
80108123:	89 e5                	mov    %esp,%ebp
80108125:	53                   	push   %ebx
80108126:	83 ec 14             	sub    $0x14,%esp
80108129:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80108130:	e9 b1 00 00 00       	jmp    801081e6 <font_render+0xc4>
80108135:	c7 45 f0 0e 00 00 00 	movl   $0xe,-0x10(%ebp)
8010813c:	e9 97 00 00 00       	jmp    801081d8 <font_render+0xb6>
80108141:	8b 45 10             	mov    0x10(%ebp),%eax
80108144:	83 e8 20             	sub    $0x20,%eax
80108147:	6b d0 1e             	imul   $0x1e,%eax,%edx
8010814a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010814d:	01 d0                	add    %edx,%eax
8010814f:	0f b7 84 00 20 a9 10 	movzwl -0x7fef56e0(%eax,%eax,1),%eax
80108156:	80 
80108157:	0f b7 d0             	movzwl %ax,%edx
8010815a:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010815d:	bb 01 00 00 00       	mov    $0x1,%ebx
80108162:	89 c1                	mov    %eax,%ecx
80108164:	d3 e3                	shl    %cl,%ebx
80108166:	89 d8                	mov    %ebx,%eax
80108168:	21 d0                	and    %edx,%eax
8010816a:	89 45 ec             	mov    %eax,-0x14(%ebp)
8010816d:	8b 45 f0             	mov    -0x10(%ebp),%eax
80108170:	ba 01 00 00 00       	mov    $0x1,%edx
80108175:	89 c1                	mov    %eax,%ecx
80108177:	d3 e2                	shl    %cl,%edx
80108179:	89 d0                	mov    %edx,%eax
8010817b:	39 45 ec             	cmp    %eax,-0x14(%ebp)
8010817e:	75 2b                	jne    801081ab <font_render+0x89>
80108180:	8b 55 0c             	mov    0xc(%ebp),%edx
80108183:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108186:	01 c2                	add    %eax,%edx
80108188:	b8 0e 00 00 00       	mov    $0xe,%eax
8010818d:	2b 45 f0             	sub    -0x10(%ebp),%eax
80108190:	89 c1                	mov    %eax,%ecx
80108192:	8b 45 08             	mov    0x8(%ebp),%eax
80108195:	01 c8                	add    %ecx,%eax
80108197:	83 ec 04             	sub    $0x4,%esp
8010819a:	68 e0 f4 10 80       	push   $0x8010f4e0
8010819f:	52                   	push   %edx
801081a0:	50                   	push   %eax
801081a1:	e8 be fe ff ff       	call   80108064 <graphic_draw_pixel>
801081a6:	83 c4 10             	add    $0x10,%esp
801081a9:	eb 29                	jmp    801081d4 <font_render+0xb2>
801081ab:	8b 55 0c             	mov    0xc(%ebp),%edx
801081ae:	8b 45 f4             	mov    -0xc(%ebp),%eax
801081b1:	01 c2                	add    %eax,%edx
801081b3:	b8 0e 00 00 00       	mov    $0xe,%eax
801081b8:	2b 45 f0             	sub    -0x10(%ebp),%eax
801081bb:	89 c1                	mov    %eax,%ecx
801081bd:	8b 45 08             	mov    0x8(%ebp),%eax
801081c0:	01 c8                	add    %ecx,%eax
801081c2:	83 ec 04             	sub    $0x4,%esp
801081c5:	68 60 6d 19 80       	push   $0x80196d60
801081ca:	52                   	push   %edx
801081cb:	50                   	push   %eax
801081cc:	e8 93 fe ff ff       	call   80108064 <graphic_draw_pixel>
801081d1:	83 c4 10             	add    $0x10,%esp
801081d4:	83 6d f0 01          	subl   $0x1,-0x10(%ebp)
801081d8:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
801081dc:	0f 89 5f ff ff ff    	jns    80108141 <font_render+0x1f>
801081e2:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
801081e6:	83 7d f4 1d          	cmpl   $0x1d,-0xc(%ebp)
801081ea:	0f 8e 45 ff ff ff    	jle    80108135 <font_render+0x13>
801081f0:	90                   	nop
801081f1:	90                   	nop
801081f2:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801081f5:	c9                   	leave  
801081f6:	c3                   	ret    

801081f7 <font_render_string>:
801081f7:	55                   	push   %ebp
801081f8:	89 e5                	mov    %esp,%ebp
801081fa:	53                   	push   %ebx
801081fb:	83 ec 14             	sub    $0x14,%esp
801081fe:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80108205:	eb 33                	jmp    8010823a <font_render_string+0x43>
80108207:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010820a:	8b 45 08             	mov    0x8(%ebp),%eax
8010820d:	01 d0                	add    %edx,%eax
8010820f:	0f b6 00             	movzbl (%eax),%eax
80108212:	0f be c8             	movsbl %al,%ecx
80108215:	8b 45 0c             	mov    0xc(%ebp),%eax
80108218:	6b d0 1e             	imul   $0x1e,%eax,%edx
8010821b:	8b 5d f4             	mov    -0xc(%ebp),%ebx
8010821e:	89 d8                	mov    %ebx,%eax
80108220:	c1 e0 04             	shl    $0x4,%eax
80108223:	29 d8                	sub    %ebx,%eax
80108225:	83 c0 02             	add    $0x2,%eax
80108228:	83 ec 04             	sub    $0x4,%esp
8010822b:	51                   	push   %ecx
8010822c:	52                   	push   %edx
8010822d:	50                   	push   %eax
8010822e:	e8 ef fe ff ff       	call   80108122 <font_render>
80108233:	83 c4 10             	add    $0x10,%esp
80108236:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
8010823a:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010823d:	8b 45 08             	mov    0x8(%ebp),%eax
80108240:	01 d0                	add    %edx,%eax
80108242:	0f b6 00             	movzbl (%eax),%eax
80108245:	84 c0                	test   %al,%al
80108247:	74 06                	je     8010824f <font_render_string+0x58>
80108249:	83 7d f4 33          	cmpl   $0x33,-0xc(%ebp)
8010824d:	7e b8                	jle    80108207 <font_render_string+0x10>
8010824f:	90                   	nop
80108250:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80108253:	c9                   	leave  
80108254:	c3                   	ret    

80108255 <pci_init>:
80108255:	55                   	push   %ebp
80108256:	89 e5                	mov    %esp,%ebp
80108258:	53                   	push   %ebx
80108259:	83 ec 14             	sub    $0x14,%esp
8010825c:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80108263:	eb 6b                	jmp    801082d0 <pci_init+0x7b>
80108265:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
8010826c:	eb 58                	jmp    801082c6 <pci_init+0x71>
8010826e:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
80108275:	eb 45                	jmp    801082bc <pci_init+0x67>
80108277:	8b 4d ec             	mov    -0x14(%ebp),%ecx
8010827a:	8b 55 f0             	mov    -0x10(%ebp),%edx
8010827d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108280:	83 ec 0c             	sub    $0xc,%esp
80108283:	8d 5d e8             	lea    -0x18(%ebp),%ebx
80108286:	53                   	push   %ebx
80108287:	6a 00                	push   $0x0
80108289:	51                   	push   %ecx
8010828a:	52                   	push   %edx
8010828b:	50                   	push   %eax
8010828c:	e8 b0 00 00 00       	call   80108341 <pci_access_config>
80108291:	83 c4 20             	add    $0x20,%esp
80108294:	8b 45 e8             	mov    -0x18(%ebp),%eax
80108297:	0f b7 c0             	movzwl %ax,%eax
8010829a:	3d ff ff 00 00       	cmp    $0xffff,%eax
8010829f:	74 17                	je     801082b8 <pci_init+0x63>
801082a1:	8b 4d ec             	mov    -0x14(%ebp),%ecx
801082a4:	8b 55 f0             	mov    -0x10(%ebp),%edx
801082a7:	8b 45 f4             	mov    -0xc(%ebp),%eax
801082aa:	83 ec 04             	sub    $0x4,%esp
801082ad:	51                   	push   %ecx
801082ae:	52                   	push   %edx
801082af:	50                   	push   %eax
801082b0:	e8 37 01 00 00       	call   801083ec <pci_init_device>
801082b5:	83 c4 10             	add    $0x10,%esp
801082b8:	83 45 ec 01          	addl   $0x1,-0x14(%ebp)
801082bc:	83 7d ec 07          	cmpl   $0x7,-0x14(%ebp)
801082c0:	7e b5                	jle    80108277 <pci_init+0x22>
801082c2:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
801082c6:	83 7d f0 1f          	cmpl   $0x1f,-0x10(%ebp)
801082ca:	7e a2                	jle    8010826e <pci_init+0x19>
801082cc:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
801082d0:	81 7d f4 ff 00 00 00 	cmpl   $0xff,-0xc(%ebp)
801082d7:	7e 8c                	jle    80108265 <pci_init+0x10>
801082d9:	90                   	nop
801082da:	90                   	nop
801082db:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801082de:	c9                   	leave  
801082df:	c3                   	ret    

801082e0 <pci_write_config>:
801082e0:	55                   	push   %ebp
801082e1:	89 e5                	mov    %esp,%ebp
801082e3:	8b 45 08             	mov    0x8(%ebp),%eax
801082e6:	ba f8 0c 00 00       	mov    $0xcf8,%edx
801082eb:	89 c0                	mov    %eax,%eax
801082ed:	ef                   	out    %eax,(%dx)
801082ee:	90                   	nop
801082ef:	5d                   	pop    %ebp
801082f0:	c3                   	ret    

801082f1 <pci_write_data>:
801082f1:	55                   	push   %ebp
801082f2:	89 e5                	mov    %esp,%ebp
801082f4:	8b 45 08             	mov    0x8(%ebp),%eax
801082f7:	ba fc 0c 00 00       	mov    $0xcfc,%edx
801082fc:	89 c0                	mov    %eax,%eax
801082fe:	ef                   	out    %eax,(%dx)
801082ff:	90                   	nop
80108300:	5d                   	pop    %ebp
80108301:	c3                   	ret    

80108302 <pci_read_config>:
80108302:	55                   	push   %ebp
80108303:	89 e5                	mov    %esp,%ebp
80108305:	83 ec 18             	sub    $0x18,%esp
80108308:	ba fc 0c 00 00       	mov    $0xcfc,%edx
8010830d:	ed                   	in     (%dx),%eax
8010830e:	89 45 f4             	mov    %eax,-0xc(%ebp)
80108311:	83 ec 0c             	sub    $0xc,%esp
80108314:	68 c8 00 00 00       	push   $0xc8
80108319:	e8 19 a8 ff ff       	call   80102b37 <microdelay>
8010831e:	83 c4 10             	add    $0x10,%esp
80108321:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108324:	c9                   	leave  
80108325:	c3                   	ret    

80108326 <pci_test>:
80108326:	55                   	push   %ebp
80108327:	89 e5                	mov    %esp,%ebp
80108329:	83 ec 10             	sub    $0x10,%esp
8010832c:	c7 45 fc 04 18 00 80 	movl   $0x80001804,-0x4(%ebp)
80108333:	ff 75 fc             	push   -0x4(%ebp)
80108336:	e8 a5 ff ff ff       	call   801082e0 <pci_write_config>
8010833b:	83 c4 04             	add    $0x4,%esp
8010833e:	90                   	nop
8010833f:	c9                   	leave  
80108340:	c3                   	ret    

80108341 <pci_access_config>:
80108341:	55                   	push   %ebp
80108342:	89 e5                	mov    %esp,%ebp
80108344:	83 ec 18             	sub    $0x18,%esp
80108347:	8b 45 08             	mov    0x8(%ebp),%eax
8010834a:	c1 e0 10             	shl    $0x10,%eax
8010834d:	25 00 00 ff 00       	and    $0xff0000,%eax
80108352:	89 c2                	mov    %eax,%edx
80108354:	8b 45 0c             	mov    0xc(%ebp),%eax
80108357:	c1 e0 0b             	shl    $0xb,%eax
8010835a:	0f b7 c0             	movzwl %ax,%eax
8010835d:	09 c2                	or     %eax,%edx
8010835f:	8b 45 10             	mov    0x10(%ebp),%eax
80108362:	c1 e0 08             	shl    $0x8,%eax
80108365:	25 00 07 00 00       	and    $0x700,%eax
8010836a:	09 c2                	or     %eax,%edx
8010836c:	8b 45 14             	mov    0x14(%ebp),%eax
8010836f:	25 fc 00 00 00       	and    $0xfc,%eax
80108374:	09 d0                	or     %edx,%eax
80108376:	0d 00 00 00 80       	or     $0x80000000,%eax
8010837b:	89 45 f4             	mov    %eax,-0xc(%ebp)
8010837e:	ff 75 f4             	push   -0xc(%ebp)
80108381:	e8 5a ff ff ff       	call   801082e0 <pci_write_config>
80108386:	83 c4 04             	add    $0x4,%esp
80108389:	e8 74 ff ff ff       	call   80108302 <pci_read_config>
8010838e:	8b 55 18             	mov    0x18(%ebp),%edx
80108391:	89 02                	mov    %eax,(%edx)
80108393:	90                   	nop
80108394:	c9                   	leave  
80108395:	c3                   	ret    

80108396 <pci_write_config_register>:
80108396:	55                   	push   %ebp
80108397:	89 e5                	mov    %esp,%ebp
80108399:	83 ec 10             	sub    $0x10,%esp
8010839c:	8b 45 08             	mov    0x8(%ebp),%eax
8010839f:	c1 e0 10             	shl    $0x10,%eax
801083a2:	25 00 00 ff 00       	and    $0xff0000,%eax
801083a7:	89 c2                	mov    %eax,%edx
801083a9:	8b 45 0c             	mov    0xc(%ebp),%eax
801083ac:	c1 e0 0b             	shl    $0xb,%eax
801083af:	0f b7 c0             	movzwl %ax,%eax
801083b2:	09 c2                	or     %eax,%edx
801083b4:	8b 45 10             	mov    0x10(%ebp),%eax
801083b7:	c1 e0 08             	shl    $0x8,%eax
801083ba:	25 00 07 00 00       	and    $0x700,%eax
801083bf:	09 c2                	or     %eax,%edx
801083c1:	8b 45 14             	mov    0x14(%ebp),%eax
801083c4:	25 fc 00 00 00       	and    $0xfc,%eax
801083c9:	09 d0                	or     %edx,%eax
801083cb:	0d 00 00 00 80       	or     $0x80000000,%eax
801083d0:	89 45 fc             	mov    %eax,-0x4(%ebp)
801083d3:	ff 75 fc             	push   -0x4(%ebp)
801083d6:	e8 05 ff ff ff       	call   801082e0 <pci_write_config>
801083db:	83 c4 04             	add    $0x4,%esp
801083de:	ff 75 18             	push   0x18(%ebp)
801083e1:	e8 0b ff ff ff       	call   801082f1 <pci_write_data>
801083e6:	83 c4 04             	add    $0x4,%esp
801083e9:	90                   	nop
801083ea:	c9                   	leave  
801083eb:	c3                   	ret    

801083ec <pci_init_device>:
801083ec:	55                   	push   %ebp
801083ed:	89 e5                	mov    %esp,%ebp
801083ef:	53                   	push   %ebx
801083f0:	83 ec 14             	sub    $0x14,%esp
801083f3:	8b 45 08             	mov    0x8(%ebp),%eax
801083f6:	a2 64 6d 19 80       	mov    %al,0x80196d64
801083fb:	8b 45 0c             	mov    0xc(%ebp),%eax
801083fe:	a2 65 6d 19 80       	mov    %al,0x80196d65
80108403:	8b 45 10             	mov    0x10(%ebp),%eax
80108406:	a2 66 6d 19 80       	mov    %al,0x80196d66
8010840b:	ff 75 10             	push   0x10(%ebp)
8010840e:	ff 75 0c             	push   0xc(%ebp)
80108411:	ff 75 08             	push   0x8(%ebp)
80108414:	68 64 bf 10 80       	push   $0x8010bf64
80108419:	e8 d6 7f ff ff       	call   801003f4 <cprintf>
8010841e:	83 c4 10             	add    $0x10,%esp
80108421:	83 ec 0c             	sub    $0xc,%esp
80108424:	8d 45 ec             	lea    -0x14(%ebp),%eax
80108427:	50                   	push   %eax
80108428:	6a 00                	push   $0x0
8010842a:	ff 75 10             	push   0x10(%ebp)
8010842d:	ff 75 0c             	push   0xc(%ebp)
80108430:	ff 75 08             	push   0x8(%ebp)
80108433:	e8 09 ff ff ff       	call   80108341 <pci_access_config>
80108438:	83 c4 20             	add    $0x20,%esp
8010843b:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010843e:	c1 e8 10             	shr    $0x10,%eax
80108441:	89 45 f4             	mov    %eax,-0xc(%ebp)
80108444:	8b 45 ec             	mov    -0x14(%ebp),%eax
80108447:	25 ff ff 00 00       	and    $0xffff,%eax
8010844c:	89 45 f0             	mov    %eax,-0x10(%ebp)
8010844f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108452:	a3 68 6d 19 80       	mov    %eax,0x80196d68
80108457:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010845a:	a3 6c 6d 19 80       	mov    %eax,0x80196d6c
8010845f:	83 ec 04             	sub    $0x4,%esp
80108462:	ff 75 f0             	push   -0x10(%ebp)
80108465:	ff 75 f4             	push   -0xc(%ebp)
80108468:	68 98 bf 10 80       	push   $0x8010bf98
8010846d:	e8 82 7f ff ff       	call   801003f4 <cprintf>
80108472:	83 c4 10             	add    $0x10,%esp
80108475:	83 ec 0c             	sub    $0xc,%esp
80108478:	8d 45 ec             	lea    -0x14(%ebp),%eax
8010847b:	50                   	push   %eax
8010847c:	6a 08                	push   $0x8
8010847e:	ff 75 10             	push   0x10(%ebp)
80108481:	ff 75 0c             	push   0xc(%ebp)
80108484:	ff 75 08             	push   0x8(%ebp)
80108487:	e8 b5 fe ff ff       	call   80108341 <pci_access_config>
8010848c:	83 c4 20             	add    $0x20,%esp
8010848f:	8b 45 ec             	mov    -0x14(%ebp),%eax
80108492:	0f b6 c8             	movzbl %al,%ecx
80108495:	8b 45 ec             	mov    -0x14(%ebp),%eax
80108498:	c1 e8 08             	shr    $0x8,%eax
8010849b:	0f b6 d0             	movzbl %al,%edx
8010849e:	8b 45 ec             	mov    -0x14(%ebp),%eax
801084a1:	c1 e8 10             	shr    $0x10,%eax
801084a4:	0f b6 c0             	movzbl %al,%eax
801084a7:	8b 5d ec             	mov    -0x14(%ebp),%ebx
801084aa:	c1 eb 18             	shr    $0x18,%ebx
801084ad:	83 ec 0c             	sub    $0xc,%esp
801084b0:	51                   	push   %ecx
801084b1:	52                   	push   %edx
801084b2:	50                   	push   %eax
801084b3:	53                   	push   %ebx
801084b4:	68 bc bf 10 80       	push   $0x8010bfbc
801084b9:	e8 36 7f ff ff       	call   801003f4 <cprintf>
801084be:	83 c4 20             	add    $0x20,%esp
801084c1:	8b 45 ec             	mov    -0x14(%ebp),%eax
801084c4:	c1 e8 18             	shr    $0x18,%eax
801084c7:	a2 70 6d 19 80       	mov    %al,0x80196d70
801084cc:	8b 45 ec             	mov    -0x14(%ebp),%eax
801084cf:	c1 e8 10             	shr    $0x10,%eax
801084d2:	a2 71 6d 19 80       	mov    %al,0x80196d71
801084d7:	8b 45 ec             	mov    -0x14(%ebp),%eax
801084da:	c1 e8 08             	shr    $0x8,%eax
801084dd:	a2 72 6d 19 80       	mov    %al,0x80196d72
801084e2:	8b 45 ec             	mov    -0x14(%ebp),%eax
801084e5:	a2 73 6d 19 80       	mov    %al,0x80196d73
801084ea:	83 ec 0c             	sub    $0xc,%esp
801084ed:	8d 45 ec             	lea    -0x14(%ebp),%eax
801084f0:	50                   	push   %eax
801084f1:	6a 10                	push   $0x10
801084f3:	ff 75 10             	push   0x10(%ebp)
801084f6:	ff 75 0c             	push   0xc(%ebp)
801084f9:	ff 75 08             	push   0x8(%ebp)
801084fc:	e8 40 fe ff ff       	call   80108341 <pci_access_config>
80108501:	83 c4 20             	add    $0x20,%esp
80108504:	8b 45 ec             	mov    -0x14(%ebp),%eax
80108507:	a3 74 6d 19 80       	mov    %eax,0x80196d74
8010850c:	83 ec 0c             	sub    $0xc,%esp
8010850f:	8d 45 ec             	lea    -0x14(%ebp),%eax
80108512:	50                   	push   %eax
80108513:	6a 14                	push   $0x14
80108515:	ff 75 10             	push   0x10(%ebp)
80108518:	ff 75 0c             	push   0xc(%ebp)
8010851b:	ff 75 08             	push   0x8(%ebp)
8010851e:	e8 1e fe ff ff       	call   80108341 <pci_access_config>
80108523:	83 c4 20             	add    $0x20,%esp
80108526:	8b 45 ec             	mov    -0x14(%ebp),%eax
80108529:	a3 78 6d 19 80       	mov    %eax,0x80196d78
8010852e:	81 7d f4 0e 10 00 00 	cmpl   $0x100e,-0xc(%ebp)
80108535:	75 5a                	jne    80108591 <pci_init_device+0x1a5>
80108537:	81 7d f0 86 80 00 00 	cmpl   $0x8086,-0x10(%ebp)
8010853e:	75 51                	jne    80108591 <pci_init_device+0x1a5>
80108540:	83 ec 0c             	sub    $0xc,%esp
80108543:	68 01 c0 10 80       	push   $0x8010c001
80108548:	e8 a7 7e ff ff       	call   801003f4 <cprintf>
8010854d:	83 c4 10             	add    $0x10,%esp
80108550:	83 ec 0c             	sub    $0xc,%esp
80108553:	8d 45 ec             	lea    -0x14(%ebp),%eax
80108556:	50                   	push   %eax
80108557:	68 f0 00 00 00       	push   $0xf0
8010855c:	ff 75 10             	push   0x10(%ebp)
8010855f:	ff 75 0c             	push   0xc(%ebp)
80108562:	ff 75 08             	push   0x8(%ebp)
80108565:	e8 d7 fd ff ff       	call   80108341 <pci_access_config>
8010856a:	83 c4 20             	add    $0x20,%esp
8010856d:	8b 45 ec             	mov    -0x14(%ebp),%eax
80108570:	83 ec 08             	sub    $0x8,%esp
80108573:	50                   	push   %eax
80108574:	68 1b c0 10 80       	push   $0x8010c01b
80108579:	e8 76 7e ff ff       	call   801003f4 <cprintf>
8010857e:	83 c4 10             	add    $0x10,%esp
80108581:	83 ec 0c             	sub    $0xc,%esp
80108584:	68 64 6d 19 80       	push   $0x80196d64
80108589:	e8 09 00 00 00       	call   80108597 <i8254_init>
8010858e:	83 c4 10             	add    $0x10,%esp
80108591:	90                   	nop
80108592:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80108595:	c9                   	leave  
80108596:	c3                   	ret    

80108597 <i8254_init>:
80108597:	55                   	push   %ebp
80108598:	89 e5                	mov    %esp,%ebp
8010859a:	53                   	push   %ebx
8010859b:	83 ec 14             	sub    $0x14,%esp
8010859e:	8b 45 08             	mov    0x8(%ebp),%eax
801085a1:	0f b6 40 02          	movzbl 0x2(%eax),%eax
801085a5:	0f b6 c8             	movzbl %al,%ecx
801085a8:	8b 45 08             	mov    0x8(%ebp),%eax
801085ab:	0f b6 40 01          	movzbl 0x1(%eax),%eax
801085af:	0f b6 d0             	movzbl %al,%edx
801085b2:	8b 45 08             	mov    0x8(%ebp),%eax
801085b5:	0f b6 00             	movzbl (%eax),%eax
801085b8:	0f b6 c0             	movzbl %al,%eax
801085bb:	83 ec 0c             	sub    $0xc,%esp
801085be:	8d 5d ec             	lea    -0x14(%ebp),%ebx
801085c1:	53                   	push   %ebx
801085c2:	6a 04                	push   $0x4
801085c4:	51                   	push   %ecx
801085c5:	52                   	push   %edx
801085c6:	50                   	push   %eax
801085c7:	e8 75 fd ff ff       	call   80108341 <pci_access_config>
801085cc:	83 c4 20             	add    $0x20,%esp
801085cf:	8b 45 ec             	mov    -0x14(%ebp),%eax
801085d2:	83 c8 04             	or     $0x4,%eax
801085d5:	89 45 ec             	mov    %eax,-0x14(%ebp)
801085d8:	8b 5d ec             	mov    -0x14(%ebp),%ebx
801085db:	8b 45 08             	mov    0x8(%ebp),%eax
801085de:	0f b6 40 02          	movzbl 0x2(%eax),%eax
801085e2:	0f b6 c8             	movzbl %al,%ecx
801085e5:	8b 45 08             	mov    0x8(%ebp),%eax
801085e8:	0f b6 40 01          	movzbl 0x1(%eax),%eax
801085ec:	0f b6 d0             	movzbl %al,%edx
801085ef:	8b 45 08             	mov    0x8(%ebp),%eax
801085f2:	0f b6 00             	movzbl (%eax),%eax
801085f5:	0f b6 c0             	movzbl %al,%eax
801085f8:	83 ec 0c             	sub    $0xc,%esp
801085fb:	53                   	push   %ebx
801085fc:	6a 04                	push   $0x4
801085fe:	51                   	push   %ecx
801085ff:	52                   	push   %edx
80108600:	50                   	push   %eax
80108601:	e8 90 fd ff ff       	call   80108396 <pci_write_config_register>
80108606:	83 c4 20             	add    $0x20,%esp
80108609:	8b 45 08             	mov    0x8(%ebp),%eax
8010860c:	8b 40 10             	mov    0x10(%eax),%eax
8010860f:	05 00 00 00 40       	add    $0x40000000,%eax
80108614:	a3 7c 6d 19 80       	mov    %eax,0x80196d7c
80108619:	a1 7c 6d 19 80       	mov    0x80196d7c,%eax
8010861e:	89 45 f4             	mov    %eax,-0xc(%ebp)
80108621:	a1 7c 6d 19 80       	mov    0x80196d7c,%eax
80108626:	05 d8 00 00 00       	add    $0xd8,%eax
8010862b:	89 45 f0             	mov    %eax,-0x10(%ebp)
8010862e:	8b 45 f0             	mov    -0x10(%ebp),%eax
80108631:	c7 00 ff ff ff ff    	movl   $0xffffffff,(%eax)
80108637:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010863a:	8b 00                	mov    (%eax),%eax
8010863c:	0d 00 00 00 04       	or     $0x4000000,%eax
80108641:	89 c2                	mov    %eax,%edx
80108643:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108646:	89 10                	mov    %edx,(%eax)
80108648:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010864b:	c7 00 ff ff ff ff    	movl   $0xffffffff,(%eax)
80108651:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108654:	8b 00                	mov    (%eax),%eax
80108656:	83 c8 40             	or     $0x40,%eax
80108659:	89 c2                	mov    %eax,%edx
8010865b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010865e:	89 10                	mov    %edx,(%eax)
80108660:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108663:	8b 10                	mov    (%eax),%edx
80108665:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108668:	89 10                	mov    %edx,(%eax)
8010866a:	83 ec 0c             	sub    $0xc,%esp
8010866d:	68 30 c0 10 80       	push   $0x8010c030
80108672:	e8 7d 7d ff ff       	call   801003f4 <cprintf>
80108677:	83 c4 10             	add    $0x10,%esp
8010867a:	e8 21 a1 ff ff       	call   801027a0 <kalloc>
8010867f:	a3 88 6d 19 80       	mov    %eax,0x80196d88
80108684:	a1 88 6d 19 80       	mov    0x80196d88,%eax
80108689:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
8010868f:	a1 88 6d 19 80       	mov    0x80196d88,%eax
80108694:	83 ec 08             	sub    $0x8,%esp
80108697:	50                   	push   %eax
80108698:	68 52 c0 10 80       	push   $0x8010c052
8010869d:	e8 52 7d ff ff       	call   801003f4 <cprintf>
801086a2:	83 c4 10             	add    $0x10,%esp
801086a5:	e8 50 00 00 00       	call   801086fa <i8254_init_recv>
801086aa:	e8 69 03 00 00       	call   80108a18 <i8254_init_send>
801086af:	0f b6 05 e7 f4 10 80 	movzbl 0x8010f4e7,%eax
801086b6:	0f b6 d8             	movzbl %al,%ebx
801086b9:	0f b6 05 e6 f4 10 80 	movzbl 0x8010f4e6,%eax
801086c0:	0f b6 c8             	movzbl %al,%ecx
801086c3:	0f b6 05 e5 f4 10 80 	movzbl 0x8010f4e5,%eax
801086ca:	0f b6 d0             	movzbl %al,%edx
801086cd:	0f b6 05 e4 f4 10 80 	movzbl 0x8010f4e4,%eax
801086d4:	0f b6 c0             	movzbl %al,%eax
801086d7:	83 ec 0c             	sub    $0xc,%esp
801086da:	53                   	push   %ebx
801086db:	51                   	push   %ecx
801086dc:	52                   	push   %edx
801086dd:	50                   	push   %eax
801086de:	68 60 c0 10 80       	push   $0x8010c060
801086e3:	e8 0c 7d ff ff       	call   801003f4 <cprintf>
801086e8:	83 c4 20             	add    $0x20,%esp
801086eb:	8b 45 f0             	mov    -0x10(%ebp),%eax
801086ee:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
801086f4:	90                   	nop
801086f5:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801086f8:	c9                   	leave  
801086f9:	c3                   	ret    

801086fa <i8254_init_recv>:
801086fa:	55                   	push   %ebp
801086fb:	89 e5                	mov    %esp,%ebp
801086fd:	57                   	push   %edi
801086fe:	56                   	push   %esi
801086ff:	53                   	push   %ebx
80108700:	83 ec 6c             	sub    $0x6c,%esp
80108703:	83 ec 0c             	sub    $0xc,%esp
80108706:	6a 00                	push   $0x0
80108708:	e8 e8 04 00 00       	call   80108bf5 <i8254_read_eeprom>
8010870d:	83 c4 10             	add    $0x10,%esp
80108710:	89 45 d8             	mov    %eax,-0x28(%ebp)
80108713:	8b 45 d8             	mov    -0x28(%ebp),%eax
80108716:	a2 80 6d 19 80       	mov    %al,0x80196d80
8010871b:	8b 45 d8             	mov    -0x28(%ebp),%eax
8010871e:	c1 e8 08             	shr    $0x8,%eax
80108721:	a2 81 6d 19 80       	mov    %al,0x80196d81
80108726:	83 ec 0c             	sub    $0xc,%esp
80108729:	6a 01                	push   $0x1
8010872b:	e8 c5 04 00 00       	call   80108bf5 <i8254_read_eeprom>
80108730:	83 c4 10             	add    $0x10,%esp
80108733:	89 45 d4             	mov    %eax,-0x2c(%ebp)
80108736:	8b 45 d4             	mov    -0x2c(%ebp),%eax
80108739:	a2 82 6d 19 80       	mov    %al,0x80196d82
8010873e:	8b 45 d4             	mov    -0x2c(%ebp),%eax
80108741:	c1 e8 08             	shr    $0x8,%eax
80108744:	a2 83 6d 19 80       	mov    %al,0x80196d83
80108749:	83 ec 0c             	sub    $0xc,%esp
8010874c:	6a 02                	push   $0x2
8010874e:	e8 a2 04 00 00       	call   80108bf5 <i8254_read_eeprom>
80108753:	83 c4 10             	add    $0x10,%esp
80108756:	89 45 d0             	mov    %eax,-0x30(%ebp)
80108759:	8b 45 d0             	mov    -0x30(%ebp),%eax
8010875c:	a2 84 6d 19 80       	mov    %al,0x80196d84
80108761:	8b 45 d0             	mov    -0x30(%ebp),%eax
80108764:	c1 e8 08             	shr    $0x8,%eax
80108767:	a2 85 6d 19 80       	mov    %al,0x80196d85
8010876c:	0f b6 05 85 6d 19 80 	movzbl 0x80196d85,%eax
80108773:	0f b6 f8             	movzbl %al,%edi
80108776:	0f b6 05 84 6d 19 80 	movzbl 0x80196d84,%eax
8010877d:	0f b6 f0             	movzbl %al,%esi
80108780:	0f b6 05 83 6d 19 80 	movzbl 0x80196d83,%eax
80108787:	0f b6 d8             	movzbl %al,%ebx
8010878a:	0f b6 05 82 6d 19 80 	movzbl 0x80196d82,%eax
80108791:	0f b6 c8             	movzbl %al,%ecx
80108794:	0f b6 05 81 6d 19 80 	movzbl 0x80196d81,%eax
8010879b:	0f b6 d0             	movzbl %al,%edx
8010879e:	0f b6 05 80 6d 19 80 	movzbl 0x80196d80,%eax
801087a5:	0f b6 c0             	movzbl %al,%eax
801087a8:	83 ec 04             	sub    $0x4,%esp
801087ab:	57                   	push   %edi
801087ac:	56                   	push   %esi
801087ad:	53                   	push   %ebx
801087ae:	51                   	push   %ecx
801087af:	52                   	push   %edx
801087b0:	50                   	push   %eax
801087b1:	68 78 c0 10 80       	push   $0x8010c078
801087b6:	e8 39 7c ff ff       	call   801003f4 <cprintf>
801087bb:	83 c4 20             	add    $0x20,%esp
801087be:	a1 7c 6d 19 80       	mov    0x80196d7c,%eax
801087c3:	05 00 54 00 00       	add    $0x5400,%eax
801087c8:	89 45 cc             	mov    %eax,-0x34(%ebp)
801087cb:	a1 7c 6d 19 80       	mov    0x80196d7c,%eax
801087d0:	05 04 54 00 00       	add    $0x5404,%eax
801087d5:	89 45 c8             	mov    %eax,-0x38(%ebp)
801087d8:	8b 45 d4             	mov    -0x2c(%ebp),%eax
801087db:	c1 e0 10             	shl    $0x10,%eax
801087de:	0b 45 d8             	or     -0x28(%ebp),%eax
801087e1:	89 c2                	mov    %eax,%edx
801087e3:	8b 45 cc             	mov    -0x34(%ebp),%eax
801087e6:	89 10                	mov    %edx,(%eax)
801087e8:	8b 45 d0             	mov    -0x30(%ebp),%eax
801087eb:	0d 00 00 00 80       	or     $0x80000000,%eax
801087f0:	89 c2                	mov    %eax,%edx
801087f2:	8b 45 c8             	mov    -0x38(%ebp),%eax
801087f5:	89 10                	mov    %edx,(%eax)
801087f7:	a1 7c 6d 19 80       	mov    0x80196d7c,%eax
801087fc:	05 00 52 00 00       	add    $0x5200,%eax
80108801:	89 45 c4             	mov    %eax,-0x3c(%ebp)
80108804:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
8010880b:	eb 19                	jmp    80108826 <i8254_init_recv+0x12c>
8010880d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80108810:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80108817:	8b 45 c4             	mov    -0x3c(%ebp),%eax
8010881a:	01 d0                	add    %edx,%eax
8010881c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
80108822:	83 45 e4 01          	addl   $0x1,-0x1c(%ebp)
80108826:	83 7d e4 7f          	cmpl   $0x7f,-0x1c(%ebp)
8010882a:	7e e1                	jle    8010880d <i8254_init_recv+0x113>
8010882c:	a1 7c 6d 19 80       	mov    0x80196d7c,%eax
80108831:	05 d0 00 00 00       	add    $0xd0,%eax
80108836:	89 45 c0             	mov    %eax,-0x40(%ebp)
80108839:	8b 45 c0             	mov    -0x40(%ebp),%eax
8010883c:	c7 00 dc 00 00 00    	movl   $0xdc,(%eax)
80108842:	a1 7c 6d 19 80       	mov    0x80196d7c,%eax
80108847:	05 c8 00 00 00       	add    $0xc8,%eax
8010884c:	89 45 bc             	mov    %eax,-0x44(%ebp)
8010884f:	8b 45 bc             	mov    -0x44(%ebp),%eax
80108852:	c7 00 dc 00 00 00    	movl   $0xdc,(%eax)
80108858:	a1 7c 6d 19 80       	mov    0x80196d7c,%eax
8010885d:	05 28 28 00 00       	add    $0x2828,%eax
80108862:	89 45 b8             	mov    %eax,-0x48(%ebp)
80108865:	8b 45 b8             	mov    -0x48(%ebp),%eax
80108868:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
8010886e:	a1 7c 6d 19 80       	mov    0x80196d7c,%eax
80108873:	05 00 01 00 00       	add    $0x100,%eax
80108878:	89 45 b4             	mov    %eax,-0x4c(%ebp)
8010887b:	8b 45 b4             	mov    -0x4c(%ebp),%eax
8010887e:	c7 00 18 80 00 04    	movl   $0x4008018,(%eax)
80108884:	e8 17 9f ff ff       	call   801027a0 <kalloc>
80108889:	89 45 b0             	mov    %eax,-0x50(%ebp)
8010888c:	a1 7c 6d 19 80       	mov    0x80196d7c,%eax
80108891:	05 00 28 00 00       	add    $0x2800,%eax
80108896:	89 45 ac             	mov    %eax,-0x54(%ebp)
80108899:	a1 7c 6d 19 80       	mov    0x80196d7c,%eax
8010889e:	05 04 28 00 00       	add    $0x2804,%eax
801088a3:	89 45 a8             	mov    %eax,-0x58(%ebp)
801088a6:	a1 7c 6d 19 80       	mov    0x80196d7c,%eax
801088ab:	05 08 28 00 00       	add    $0x2808,%eax
801088b0:	89 45 a4             	mov    %eax,-0x5c(%ebp)
801088b3:	a1 7c 6d 19 80       	mov    0x80196d7c,%eax
801088b8:	05 10 28 00 00       	add    $0x2810,%eax
801088bd:	89 45 a0             	mov    %eax,-0x60(%ebp)
801088c0:	a1 7c 6d 19 80       	mov    0x80196d7c,%eax
801088c5:	05 18 28 00 00       	add    $0x2818,%eax
801088ca:	89 45 9c             	mov    %eax,-0x64(%ebp)
801088cd:	8b 45 b0             	mov    -0x50(%ebp),%eax
801088d0:	8d 90 00 00 00 80    	lea    -0x80000000(%eax),%edx
801088d6:	8b 45 ac             	mov    -0x54(%ebp),%eax
801088d9:	89 10                	mov    %edx,(%eax)
801088db:	8b 45 a8             	mov    -0x58(%ebp),%eax
801088de:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
801088e4:	8b 45 a4             	mov    -0x5c(%ebp),%eax
801088e7:	c7 00 00 10 00 00    	movl   $0x1000,(%eax)
801088ed:	8b 45 a0             	mov    -0x60(%ebp),%eax
801088f0:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
801088f6:	8b 45 9c             	mov    -0x64(%ebp),%eax
801088f9:	c7 00 00 01 00 00    	movl   $0x100,(%eax)
801088ff:	8b 45 b0             	mov    -0x50(%ebp),%eax
80108902:	89 45 98             	mov    %eax,-0x68(%ebp)
80108905:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
8010890c:	eb 73                	jmp    80108981 <i8254_init_recv+0x287>
8010890e:	8b 45 e0             	mov    -0x20(%ebp),%eax
80108911:	c1 e0 04             	shl    $0x4,%eax
80108914:	89 c2                	mov    %eax,%edx
80108916:	8b 45 98             	mov    -0x68(%ebp),%eax
80108919:	01 d0                	add    %edx,%eax
8010891b:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
80108922:	8b 45 e0             	mov    -0x20(%ebp),%eax
80108925:	c1 e0 04             	shl    $0x4,%eax
80108928:	89 c2                	mov    %eax,%edx
8010892a:	8b 45 98             	mov    -0x68(%ebp),%eax
8010892d:	01 d0                	add    %edx,%eax
8010892f:	66 c7 40 08 00 00    	movw   $0x0,0x8(%eax)
80108935:	8b 45 e0             	mov    -0x20(%ebp),%eax
80108938:	c1 e0 04             	shl    $0x4,%eax
8010893b:	89 c2                	mov    %eax,%edx
8010893d:	8b 45 98             	mov    -0x68(%ebp),%eax
80108940:	01 d0                	add    %edx,%eax
80108942:	66 c7 40 0a 00 00    	movw   $0x0,0xa(%eax)
80108948:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010894b:	c1 e0 04             	shl    $0x4,%eax
8010894e:	89 c2                	mov    %eax,%edx
80108950:	8b 45 98             	mov    -0x68(%ebp),%eax
80108953:	01 d0                	add    %edx,%eax
80108955:	c6 40 0c 00          	movb   $0x0,0xc(%eax)
80108959:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010895c:	c1 e0 04             	shl    $0x4,%eax
8010895f:	89 c2                	mov    %eax,%edx
80108961:	8b 45 98             	mov    -0x68(%ebp),%eax
80108964:	01 d0                	add    %edx,%eax
80108966:	c6 40 0d 00          	movb   $0x0,0xd(%eax)
8010896a:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010896d:	c1 e0 04             	shl    $0x4,%eax
80108970:	89 c2                	mov    %eax,%edx
80108972:	8b 45 98             	mov    -0x68(%ebp),%eax
80108975:	01 d0                	add    %edx,%eax
80108977:	66 c7 40 0e 00 00    	movw   $0x0,0xe(%eax)
8010897d:	83 45 e0 01          	addl   $0x1,-0x20(%ebp)
80108981:	81 7d e0 ff 00 00 00 	cmpl   $0xff,-0x20(%ebp)
80108988:	7e 84                	jle    8010890e <i8254_init_recv+0x214>
8010898a:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
80108991:	eb 57                	jmp    801089ea <i8254_init_recv+0x2f0>
80108993:	e8 08 9e ff ff       	call   801027a0 <kalloc>
80108998:	89 45 94             	mov    %eax,-0x6c(%ebp)
8010899b:	83 7d 94 00          	cmpl   $0x0,-0x6c(%ebp)
8010899f:	75 12                	jne    801089b3 <i8254_init_recv+0x2b9>
801089a1:	83 ec 0c             	sub    $0xc,%esp
801089a4:	68 98 c0 10 80       	push   $0x8010c098
801089a9:	e8 46 7a ff ff       	call   801003f4 <cprintf>
801089ae:	83 c4 10             	add    $0x10,%esp
801089b1:	eb 3d                	jmp    801089f0 <i8254_init_recv+0x2f6>
801089b3:	8b 45 dc             	mov    -0x24(%ebp),%eax
801089b6:	c1 e0 04             	shl    $0x4,%eax
801089b9:	89 c2                	mov    %eax,%edx
801089bb:	8b 45 98             	mov    -0x68(%ebp),%eax
801089be:	01 d0                	add    %edx,%eax
801089c0:	8b 55 94             	mov    -0x6c(%ebp),%edx
801089c3:	81 c2 00 00 00 80    	add    $0x80000000,%edx
801089c9:	89 10                	mov    %edx,(%eax)
801089cb:	8b 45 dc             	mov    -0x24(%ebp),%eax
801089ce:	83 c0 01             	add    $0x1,%eax
801089d1:	c1 e0 04             	shl    $0x4,%eax
801089d4:	89 c2                	mov    %eax,%edx
801089d6:	8b 45 98             	mov    -0x68(%ebp),%eax
801089d9:	01 d0                	add    %edx,%eax
801089db:	8b 55 94             	mov    -0x6c(%ebp),%edx
801089de:	81 ea 00 f8 ff 7f    	sub    $0x7ffff800,%edx
801089e4:	89 10                	mov    %edx,(%eax)
801089e6:	83 45 dc 01          	addl   $0x1,-0x24(%ebp)
801089ea:	83 7d dc 7f          	cmpl   $0x7f,-0x24(%ebp)
801089ee:	7e a3                	jle    80108993 <i8254_init_recv+0x299>
801089f0:	8b 45 b4             	mov    -0x4c(%ebp),%eax
801089f3:	8b 00                	mov    (%eax),%eax
801089f5:	83 c8 02             	or     $0x2,%eax
801089f8:	89 c2                	mov    %eax,%edx
801089fa:	8b 45 b4             	mov    -0x4c(%ebp),%eax
801089fd:	89 10                	mov    %edx,(%eax)
801089ff:	83 ec 0c             	sub    $0xc,%esp
80108a02:	68 b8 c0 10 80       	push   $0x8010c0b8
80108a07:	e8 e8 79 ff ff       	call   801003f4 <cprintf>
80108a0c:	83 c4 10             	add    $0x10,%esp
80108a0f:	90                   	nop
80108a10:	8d 65 f4             	lea    -0xc(%ebp),%esp
80108a13:	5b                   	pop    %ebx
80108a14:	5e                   	pop    %esi
80108a15:	5f                   	pop    %edi
80108a16:	5d                   	pop    %ebp
80108a17:	c3                   	ret    

80108a18 <i8254_init_send>:
80108a18:	55                   	push   %ebp
80108a19:	89 e5                	mov    %esp,%ebp
80108a1b:	83 ec 48             	sub    $0x48,%esp
80108a1e:	a1 7c 6d 19 80       	mov    0x80196d7c,%eax
80108a23:	05 28 38 00 00       	add    $0x3828,%eax
80108a28:	89 45 ec             	mov    %eax,-0x14(%ebp)
80108a2b:	8b 45 ec             	mov    -0x14(%ebp),%eax
80108a2e:	c7 00 00 00 01 01    	movl   $0x1010000,(%eax)
80108a34:	e8 67 9d ff ff       	call   801027a0 <kalloc>
80108a39:	89 45 e8             	mov    %eax,-0x18(%ebp)
80108a3c:	a1 7c 6d 19 80       	mov    0x80196d7c,%eax
80108a41:	05 00 38 00 00       	add    $0x3800,%eax
80108a46:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80108a49:	a1 7c 6d 19 80       	mov    0x80196d7c,%eax
80108a4e:	05 04 38 00 00       	add    $0x3804,%eax
80108a53:	89 45 e0             	mov    %eax,-0x20(%ebp)
80108a56:	a1 7c 6d 19 80       	mov    0x80196d7c,%eax
80108a5b:	05 08 38 00 00       	add    $0x3808,%eax
80108a60:	89 45 dc             	mov    %eax,-0x24(%ebp)
80108a63:	8b 45 e8             	mov    -0x18(%ebp),%eax
80108a66:	8d 90 00 00 00 80    	lea    -0x80000000(%eax),%edx
80108a6c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80108a6f:	89 10                	mov    %edx,(%eax)
80108a71:	8b 45 e0             	mov    -0x20(%ebp),%eax
80108a74:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
80108a7a:	8b 45 dc             	mov    -0x24(%ebp),%eax
80108a7d:	c7 00 00 10 00 00    	movl   $0x1000,(%eax)
80108a83:	a1 7c 6d 19 80       	mov    0x80196d7c,%eax
80108a88:	05 10 38 00 00       	add    $0x3810,%eax
80108a8d:	89 45 d8             	mov    %eax,-0x28(%ebp)
80108a90:	a1 7c 6d 19 80       	mov    0x80196d7c,%eax
80108a95:	05 18 38 00 00       	add    $0x3818,%eax
80108a9a:	89 45 d4             	mov    %eax,-0x2c(%ebp)
80108a9d:	8b 45 d8             	mov    -0x28(%ebp),%eax
80108aa0:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
80108aa6:	8b 45 d4             	mov    -0x2c(%ebp),%eax
80108aa9:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
80108aaf:	8b 45 e8             	mov    -0x18(%ebp),%eax
80108ab2:	89 45 d0             	mov    %eax,-0x30(%ebp)
80108ab5:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80108abc:	e9 82 00 00 00       	jmp    80108b43 <i8254_init_send+0x12b>
80108ac1:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108ac4:	c1 e0 04             	shl    $0x4,%eax
80108ac7:	89 c2                	mov    %eax,%edx
80108ac9:	8b 45 d0             	mov    -0x30(%ebp),%eax
80108acc:	01 d0                	add    %edx,%eax
80108ace:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
80108ad5:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108ad8:	c1 e0 04             	shl    $0x4,%eax
80108adb:	89 c2                	mov    %eax,%edx
80108add:	8b 45 d0             	mov    -0x30(%ebp),%eax
80108ae0:	01 d0                	add    %edx,%eax
80108ae2:	66 c7 40 08 00 00    	movw   $0x0,0x8(%eax)
80108ae8:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108aeb:	c1 e0 04             	shl    $0x4,%eax
80108aee:	89 c2                	mov    %eax,%edx
80108af0:	8b 45 d0             	mov    -0x30(%ebp),%eax
80108af3:	01 d0                	add    %edx,%eax
80108af5:	c6 40 0a 00          	movb   $0x0,0xa(%eax)
80108af9:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108afc:	c1 e0 04             	shl    $0x4,%eax
80108aff:	89 c2                	mov    %eax,%edx
80108b01:	8b 45 d0             	mov    -0x30(%ebp),%eax
80108b04:	01 d0                	add    %edx,%eax
80108b06:	c6 40 0b 00          	movb   $0x0,0xb(%eax)
80108b0a:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108b0d:	c1 e0 04             	shl    $0x4,%eax
80108b10:	89 c2                	mov    %eax,%edx
80108b12:	8b 45 d0             	mov    -0x30(%ebp),%eax
80108b15:	01 d0                	add    %edx,%eax
80108b17:	c6 40 0c 00          	movb   $0x0,0xc(%eax)
80108b1b:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108b1e:	c1 e0 04             	shl    $0x4,%eax
80108b21:	89 c2                	mov    %eax,%edx
80108b23:	8b 45 d0             	mov    -0x30(%ebp),%eax
80108b26:	01 d0                	add    %edx,%eax
80108b28:	c6 40 0d 00          	movb   $0x0,0xd(%eax)
80108b2c:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108b2f:	c1 e0 04             	shl    $0x4,%eax
80108b32:	89 c2                	mov    %eax,%edx
80108b34:	8b 45 d0             	mov    -0x30(%ebp),%eax
80108b37:	01 d0                	add    %edx,%eax
80108b39:	66 c7 40 0e 00 00    	movw   $0x0,0xe(%eax)
80108b3f:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80108b43:	81 7d f4 ff 00 00 00 	cmpl   $0xff,-0xc(%ebp)
80108b4a:	0f 8e 71 ff ff ff    	jle    80108ac1 <i8254_init_send+0xa9>
80108b50:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
80108b57:	eb 57                	jmp    80108bb0 <i8254_init_send+0x198>
80108b59:	e8 42 9c ff ff       	call   801027a0 <kalloc>
80108b5e:	89 45 cc             	mov    %eax,-0x34(%ebp)
80108b61:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
80108b65:	75 12                	jne    80108b79 <i8254_init_send+0x161>
80108b67:	83 ec 0c             	sub    $0xc,%esp
80108b6a:	68 98 c0 10 80       	push   $0x8010c098
80108b6f:	e8 80 78 ff ff       	call   801003f4 <cprintf>
80108b74:	83 c4 10             	add    $0x10,%esp
80108b77:	eb 3d                	jmp    80108bb6 <i8254_init_send+0x19e>
80108b79:	8b 45 f0             	mov    -0x10(%ebp),%eax
80108b7c:	c1 e0 04             	shl    $0x4,%eax
80108b7f:	89 c2                	mov    %eax,%edx
80108b81:	8b 45 d0             	mov    -0x30(%ebp),%eax
80108b84:	01 d0                	add    %edx,%eax
80108b86:	8b 55 cc             	mov    -0x34(%ebp),%edx
80108b89:	81 c2 00 00 00 80    	add    $0x80000000,%edx
80108b8f:	89 10                	mov    %edx,(%eax)
80108b91:	8b 45 f0             	mov    -0x10(%ebp),%eax
80108b94:	83 c0 01             	add    $0x1,%eax
80108b97:	c1 e0 04             	shl    $0x4,%eax
80108b9a:	89 c2                	mov    %eax,%edx
80108b9c:	8b 45 d0             	mov    -0x30(%ebp),%eax
80108b9f:	01 d0                	add    %edx,%eax
80108ba1:	8b 55 cc             	mov    -0x34(%ebp),%edx
80108ba4:	81 ea 00 f8 ff 7f    	sub    $0x7ffff800,%edx
80108baa:	89 10                	mov    %edx,(%eax)
80108bac:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
80108bb0:	83 7d f0 7f          	cmpl   $0x7f,-0x10(%ebp)
80108bb4:	7e a3                	jle    80108b59 <i8254_init_send+0x141>
80108bb6:	a1 7c 6d 19 80       	mov    0x80196d7c,%eax
80108bbb:	05 00 04 00 00       	add    $0x400,%eax
80108bc0:	89 45 c8             	mov    %eax,-0x38(%ebp)
80108bc3:	8b 45 c8             	mov    -0x38(%ebp),%eax
80108bc6:	c7 00 fa 00 04 00    	movl   $0x400fa,(%eax)
80108bcc:	a1 7c 6d 19 80       	mov    0x80196d7c,%eax
80108bd1:	05 10 04 00 00       	add    $0x410,%eax
80108bd6:	89 45 c4             	mov    %eax,-0x3c(%ebp)
80108bd9:	8b 45 c4             	mov    -0x3c(%ebp),%eax
80108bdc:	c7 00 0a 28 a0 00    	movl   $0xa0280a,(%eax)
80108be2:	83 ec 0c             	sub    $0xc,%esp
80108be5:	68 d8 c0 10 80       	push   $0x8010c0d8
80108bea:	e8 05 78 ff ff       	call   801003f4 <cprintf>
80108bef:	83 c4 10             	add    $0x10,%esp
80108bf2:	90                   	nop
80108bf3:	c9                   	leave  
80108bf4:	c3                   	ret    

80108bf5 <i8254_read_eeprom>:
80108bf5:	55                   	push   %ebp
80108bf6:	89 e5                	mov    %esp,%ebp
80108bf8:	83 ec 18             	sub    $0x18,%esp
80108bfb:	a1 7c 6d 19 80       	mov    0x80196d7c,%eax
80108c00:	83 c0 14             	add    $0x14,%eax
80108c03:	89 45 f4             	mov    %eax,-0xc(%ebp)
80108c06:	8b 45 08             	mov    0x8(%ebp),%eax
80108c09:	c1 e0 08             	shl    $0x8,%eax
80108c0c:	0f b7 c0             	movzwl %ax,%eax
80108c0f:	83 c8 01             	or     $0x1,%eax
80108c12:	89 c2                	mov    %eax,%edx
80108c14:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108c17:	89 10                	mov    %edx,(%eax)
80108c19:	83 ec 0c             	sub    $0xc,%esp
80108c1c:	68 f8 c0 10 80       	push   $0x8010c0f8
80108c21:	e8 ce 77 ff ff       	call   801003f4 <cprintf>
80108c26:	83 c4 10             	add    $0x10,%esp
80108c29:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108c2c:	8b 00                	mov    (%eax),%eax
80108c2e:	89 45 f0             	mov    %eax,-0x10(%ebp)
80108c31:	8b 45 f0             	mov    -0x10(%ebp),%eax
80108c34:	83 e0 10             	and    $0x10,%eax
80108c37:	85 c0                	test   %eax,%eax
80108c39:	75 02                	jne    80108c3d <i8254_read_eeprom+0x48>
80108c3b:	eb dc                	jmp    80108c19 <i8254_read_eeprom+0x24>
80108c3d:	90                   	nop
80108c3e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108c41:	8b 00                	mov    (%eax),%eax
80108c43:	c1 e8 10             	shr    $0x10,%eax
80108c46:	c9                   	leave  
80108c47:	c3                   	ret    

80108c48 <i8254_recv>:
80108c48:	55                   	push   %ebp
80108c49:	89 e5                	mov    %esp,%ebp
80108c4b:	83 ec 28             	sub    $0x28,%esp
80108c4e:	a1 7c 6d 19 80       	mov    0x80196d7c,%eax
80108c53:	05 10 28 00 00       	add    $0x2810,%eax
80108c58:	89 45 f4             	mov    %eax,-0xc(%ebp)
80108c5b:	a1 7c 6d 19 80       	mov    0x80196d7c,%eax
80108c60:	05 18 28 00 00       	add    $0x2818,%eax
80108c65:	89 45 f0             	mov    %eax,-0x10(%ebp)
80108c68:	a1 7c 6d 19 80       	mov    0x80196d7c,%eax
80108c6d:	05 00 28 00 00       	add    $0x2800,%eax
80108c72:	89 45 ec             	mov    %eax,-0x14(%ebp)
80108c75:	8b 45 ec             	mov    -0x14(%ebp),%eax
80108c78:	8b 00                	mov    (%eax),%eax
80108c7a:	05 00 00 00 80       	add    $0x80000000,%eax
80108c7f:	89 45 e8             	mov    %eax,-0x18(%ebp)
80108c82:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108c85:	8b 10                	mov    (%eax),%edx
80108c87:	8b 45 f0             	mov    -0x10(%ebp),%eax
80108c8a:	8b 08                	mov    (%eax),%ecx
80108c8c:	89 d0                	mov    %edx,%eax
80108c8e:	29 c8                	sub    %ecx,%eax
80108c90:	25 ff 00 00 00       	and    $0xff,%eax
80108c95:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80108c98:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
80108c9c:	7e 37                	jle    80108cd5 <i8254_recv+0x8d>
80108c9e:	8b 45 f0             	mov    -0x10(%ebp),%eax
80108ca1:	8b 00                	mov    (%eax),%eax
80108ca3:	c1 e0 04             	shl    $0x4,%eax
80108ca6:	89 c2                	mov    %eax,%edx
80108ca8:	8b 45 e8             	mov    -0x18(%ebp),%eax
80108cab:	01 d0                	add    %edx,%eax
80108cad:	8b 00                	mov    (%eax),%eax
80108caf:	05 00 00 00 80       	add    $0x80000000,%eax
80108cb4:	89 45 e0             	mov    %eax,-0x20(%ebp)
80108cb7:	8b 45 f0             	mov    -0x10(%ebp),%eax
80108cba:	8b 00                	mov    (%eax),%eax
80108cbc:	83 c0 01             	add    $0x1,%eax
80108cbf:	0f b6 d0             	movzbl %al,%edx
80108cc2:	8b 45 f0             	mov    -0x10(%ebp),%eax
80108cc5:	89 10                	mov    %edx,(%eax)
80108cc7:	83 ec 0c             	sub    $0xc,%esp
80108cca:	ff 75 e0             	push   -0x20(%ebp)
80108ccd:	e8 15 09 00 00       	call   801095e7 <eth_proc>
80108cd2:	83 c4 10             	add    $0x10,%esp
80108cd5:	8b 45 f0             	mov    -0x10(%ebp),%eax
80108cd8:	8b 10                	mov    (%eax),%edx
80108cda:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108cdd:	8b 00                	mov    (%eax),%eax
80108cdf:	39 c2                	cmp    %eax,%edx
80108ce1:	75 9f                	jne    80108c82 <i8254_recv+0x3a>
80108ce3:	8b 45 f0             	mov    -0x10(%ebp),%eax
80108ce6:	8b 00                	mov    (%eax),%eax
80108ce8:	8d 50 ff             	lea    -0x1(%eax),%edx
80108ceb:	8b 45 f0             	mov    -0x10(%ebp),%eax
80108cee:	89 10                	mov    %edx,(%eax)
80108cf0:	eb 90                	jmp    80108c82 <i8254_recv+0x3a>

80108cf2 <i8254_send>:
80108cf2:	55                   	push   %ebp
80108cf3:	89 e5                	mov    %esp,%ebp
80108cf5:	83 ec 28             	sub    $0x28,%esp
80108cf8:	a1 7c 6d 19 80       	mov    0x80196d7c,%eax
80108cfd:	05 10 38 00 00       	add    $0x3810,%eax
80108d02:	89 45 f4             	mov    %eax,-0xc(%ebp)
80108d05:	a1 7c 6d 19 80       	mov    0x80196d7c,%eax
80108d0a:	05 18 38 00 00       	add    $0x3818,%eax
80108d0f:	89 45 f0             	mov    %eax,-0x10(%ebp)
80108d12:	a1 7c 6d 19 80       	mov    0x80196d7c,%eax
80108d17:	05 00 38 00 00       	add    $0x3800,%eax
80108d1c:	89 45 ec             	mov    %eax,-0x14(%ebp)
80108d1f:	8b 45 ec             	mov    -0x14(%ebp),%eax
80108d22:	8b 00                	mov    (%eax),%eax
80108d24:	05 00 00 00 80       	add    $0x80000000,%eax
80108d29:	89 45 e8             	mov    %eax,-0x18(%ebp)
80108d2c:	8b 45 f0             	mov    -0x10(%ebp),%eax
80108d2f:	8b 10                	mov    (%eax),%edx
80108d31:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108d34:	8b 08                	mov    (%eax),%ecx
80108d36:	89 d0                	mov    %edx,%eax
80108d38:	29 c8                	sub    %ecx,%eax
80108d3a:	0f b6 d0             	movzbl %al,%edx
80108d3d:	b8 00 01 00 00       	mov    $0x100,%eax
80108d42:	29 d0                	sub    %edx,%eax
80108d44:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80108d47:	8b 45 f0             	mov    -0x10(%ebp),%eax
80108d4a:	8b 00                	mov    (%eax),%eax
80108d4c:	25 ff 00 00 00       	and    $0xff,%eax
80108d51:	89 45 e0             	mov    %eax,-0x20(%ebp)
80108d54:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
80108d58:	0f 8e a8 00 00 00    	jle    80108e06 <i8254_send+0x114>
80108d5e:	8b 45 08             	mov    0x8(%ebp),%eax
80108d61:	8b 55 e0             	mov    -0x20(%ebp),%edx
80108d64:	89 d1                	mov    %edx,%ecx
80108d66:	c1 e1 04             	shl    $0x4,%ecx
80108d69:	8b 55 e8             	mov    -0x18(%ebp),%edx
80108d6c:	01 ca                	add    %ecx,%edx
80108d6e:	8b 12                	mov    (%edx),%edx
80108d70:	81 c2 00 00 00 80    	add    $0x80000000,%edx
80108d76:	83 ec 04             	sub    $0x4,%esp
80108d79:	ff 75 0c             	push   0xc(%ebp)
80108d7c:	50                   	push   %eax
80108d7d:	52                   	push   %edx
80108d7e:	e8 1a bf ff ff       	call   80104c9d <memmove>
80108d83:	83 c4 10             	add    $0x10,%esp
80108d86:	8b 45 e0             	mov    -0x20(%ebp),%eax
80108d89:	c1 e0 04             	shl    $0x4,%eax
80108d8c:	89 c2                	mov    %eax,%edx
80108d8e:	8b 45 e8             	mov    -0x18(%ebp),%eax
80108d91:	01 d0                	add    %edx,%eax
80108d93:	8b 55 0c             	mov    0xc(%ebp),%edx
80108d96:	66 89 50 08          	mov    %dx,0x8(%eax)
80108d9a:	8b 45 e0             	mov    -0x20(%ebp),%eax
80108d9d:	c1 e0 04             	shl    $0x4,%eax
80108da0:	89 c2                	mov    %eax,%edx
80108da2:	8b 45 e8             	mov    -0x18(%ebp),%eax
80108da5:	01 d0                	add    %edx,%eax
80108da7:	c6 40 0c 00          	movb   $0x0,0xc(%eax)
80108dab:	8b 45 e0             	mov    -0x20(%ebp),%eax
80108dae:	c1 e0 04             	shl    $0x4,%eax
80108db1:	89 c2                	mov    %eax,%edx
80108db3:	8b 45 e8             	mov    -0x18(%ebp),%eax
80108db6:	01 d0                	add    %edx,%eax
80108db8:	c6 40 0d 00          	movb   $0x0,0xd(%eax)
80108dbc:	8b 45 e0             	mov    -0x20(%ebp),%eax
80108dbf:	c1 e0 04             	shl    $0x4,%eax
80108dc2:	89 c2                	mov    %eax,%edx
80108dc4:	8b 45 e8             	mov    -0x18(%ebp),%eax
80108dc7:	01 d0                	add    %edx,%eax
80108dc9:	c6 40 0b 0b          	movb   $0xb,0xb(%eax)
80108dcd:	8b 45 e0             	mov    -0x20(%ebp),%eax
80108dd0:	c1 e0 04             	shl    $0x4,%eax
80108dd3:	89 c2                	mov    %eax,%edx
80108dd5:	8b 45 e8             	mov    -0x18(%ebp),%eax
80108dd8:	01 d0                	add    %edx,%eax
80108dda:	66 c7 40 0e 00 00    	movw   $0x0,0xe(%eax)
80108de0:	8b 45 e0             	mov    -0x20(%ebp),%eax
80108de3:	c1 e0 04             	shl    $0x4,%eax
80108de6:	89 c2                	mov    %eax,%edx
80108de8:	8b 45 e8             	mov    -0x18(%ebp),%eax
80108deb:	01 d0                	add    %edx,%eax
80108ded:	c6 40 0a 00          	movb   $0x0,0xa(%eax)
80108df1:	8b 45 f0             	mov    -0x10(%ebp),%eax
80108df4:	8b 00                	mov    (%eax),%eax
80108df6:	83 c0 01             	add    $0x1,%eax
80108df9:	0f b6 d0             	movzbl %al,%edx
80108dfc:	8b 45 f0             	mov    -0x10(%ebp),%eax
80108dff:	89 10                	mov    %edx,(%eax)
80108e01:	8b 45 0c             	mov    0xc(%ebp),%eax
80108e04:	eb 05                	jmp    80108e0b <i8254_send+0x119>
80108e06:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80108e0b:	c9                   	leave  
80108e0c:	c3                   	ret    

80108e0d <i8254_intr>:
80108e0d:	55                   	push   %ebp
80108e0e:	89 e5                	mov    %esp,%ebp
80108e10:	a1 88 6d 19 80       	mov    0x80196d88,%eax
80108e15:	c7 00 ee ee ee 00    	movl   $0xeeeeee,(%eax)
80108e1b:	90                   	nop
80108e1c:	5d                   	pop    %ebp
80108e1d:	c3                   	ret    

80108e1e <arp_proc>:
80108e1e:	55                   	push   %ebp
80108e1f:	89 e5                	mov    %esp,%ebp
80108e21:	83 ec 18             	sub    $0x18,%esp
80108e24:	8b 45 08             	mov    0x8(%ebp),%eax
80108e27:	89 45 f4             	mov    %eax,-0xc(%ebp)
80108e2a:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108e2d:	0f b7 00             	movzwl (%eax),%eax
80108e30:	66 3d 00 01          	cmp    $0x100,%ax
80108e34:	74 0a                	je     80108e40 <arp_proc+0x22>
80108e36:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80108e3b:	e9 4f 01 00 00       	jmp    80108f8f <arp_proc+0x171>
80108e40:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108e43:	0f b7 40 02          	movzwl 0x2(%eax),%eax
80108e47:	66 83 f8 08          	cmp    $0x8,%ax
80108e4b:	74 0a                	je     80108e57 <arp_proc+0x39>
80108e4d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80108e52:	e9 38 01 00 00       	jmp    80108f8f <arp_proc+0x171>
80108e57:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108e5a:	0f b6 40 04          	movzbl 0x4(%eax),%eax
80108e5e:	3c 06                	cmp    $0x6,%al
80108e60:	74 0a                	je     80108e6c <arp_proc+0x4e>
80108e62:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80108e67:	e9 23 01 00 00       	jmp    80108f8f <arp_proc+0x171>
80108e6c:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108e6f:	0f b6 40 05          	movzbl 0x5(%eax),%eax
80108e73:	3c 04                	cmp    $0x4,%al
80108e75:	74 0a                	je     80108e81 <arp_proc+0x63>
80108e77:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80108e7c:	e9 0e 01 00 00       	jmp    80108f8f <arp_proc+0x171>
80108e81:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108e84:	83 c0 18             	add    $0x18,%eax
80108e87:	83 ec 04             	sub    $0x4,%esp
80108e8a:	6a 04                	push   $0x4
80108e8c:	50                   	push   %eax
80108e8d:	68 e4 f4 10 80       	push   $0x8010f4e4
80108e92:	e8 ae bd ff ff       	call   80104c45 <memcmp>
80108e97:	83 c4 10             	add    $0x10,%esp
80108e9a:	85 c0                	test   %eax,%eax
80108e9c:	74 27                	je     80108ec5 <arp_proc+0xa7>
80108e9e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108ea1:	83 c0 0e             	add    $0xe,%eax
80108ea4:	83 ec 04             	sub    $0x4,%esp
80108ea7:	6a 04                	push   $0x4
80108ea9:	50                   	push   %eax
80108eaa:	68 e4 f4 10 80       	push   $0x8010f4e4
80108eaf:	e8 91 bd ff ff       	call   80104c45 <memcmp>
80108eb4:	83 c4 10             	add    $0x10,%esp
80108eb7:	85 c0                	test   %eax,%eax
80108eb9:	74 0a                	je     80108ec5 <arp_proc+0xa7>
80108ebb:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80108ec0:	e9 ca 00 00 00       	jmp    80108f8f <arp_proc+0x171>
80108ec5:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108ec8:	0f b7 40 06          	movzwl 0x6(%eax),%eax
80108ecc:	66 3d 00 01          	cmp    $0x100,%ax
80108ed0:	75 69                	jne    80108f3b <arp_proc+0x11d>
80108ed2:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108ed5:	83 c0 18             	add    $0x18,%eax
80108ed8:	83 ec 04             	sub    $0x4,%esp
80108edb:	6a 04                	push   $0x4
80108edd:	50                   	push   %eax
80108ede:	68 e4 f4 10 80       	push   $0x8010f4e4
80108ee3:	e8 5d bd ff ff       	call   80104c45 <memcmp>
80108ee8:	83 c4 10             	add    $0x10,%esp
80108eeb:	85 c0                	test   %eax,%eax
80108eed:	75 4c                	jne    80108f3b <arp_proc+0x11d>
80108eef:	e8 ac 98 ff ff       	call   801027a0 <kalloc>
80108ef4:	89 45 f0             	mov    %eax,-0x10(%ebp)
80108ef7:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
80108efe:	83 ec 04             	sub    $0x4,%esp
80108f01:	8d 45 ec             	lea    -0x14(%ebp),%eax
80108f04:	50                   	push   %eax
80108f05:	ff 75 f0             	push   -0x10(%ebp)
80108f08:	ff 75 f4             	push   -0xc(%ebp)
80108f0b:	e8 1f 04 00 00       	call   8010932f <arp_reply_pkt_create>
80108f10:	83 c4 10             	add    $0x10,%esp
80108f13:	8b 45 ec             	mov    -0x14(%ebp),%eax
80108f16:	83 ec 08             	sub    $0x8,%esp
80108f19:	50                   	push   %eax
80108f1a:	ff 75 f0             	push   -0x10(%ebp)
80108f1d:	e8 d0 fd ff ff       	call   80108cf2 <i8254_send>
80108f22:	83 c4 10             	add    $0x10,%esp
80108f25:	8b 45 f0             	mov    -0x10(%ebp),%eax
80108f28:	83 ec 0c             	sub    $0xc,%esp
80108f2b:	50                   	push   %eax
80108f2c:	e8 d5 97 ff ff       	call   80102706 <kfree>
80108f31:	83 c4 10             	add    $0x10,%esp
80108f34:	b8 02 00 00 00       	mov    $0x2,%eax
80108f39:	eb 54                	jmp    80108f8f <arp_proc+0x171>
80108f3b:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108f3e:	0f b7 40 06          	movzwl 0x6(%eax),%eax
80108f42:	66 3d 00 02          	cmp    $0x200,%ax
80108f46:	75 42                	jne    80108f8a <arp_proc+0x16c>
80108f48:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108f4b:	83 c0 18             	add    $0x18,%eax
80108f4e:	83 ec 04             	sub    $0x4,%esp
80108f51:	6a 04                	push   $0x4
80108f53:	50                   	push   %eax
80108f54:	68 e4 f4 10 80       	push   $0x8010f4e4
80108f59:	e8 e7 bc ff ff       	call   80104c45 <memcmp>
80108f5e:	83 c4 10             	add    $0x10,%esp
80108f61:	85 c0                	test   %eax,%eax
80108f63:	75 25                	jne    80108f8a <arp_proc+0x16c>
80108f65:	83 ec 0c             	sub    $0xc,%esp
80108f68:	68 fc c0 10 80       	push   $0x8010c0fc
80108f6d:	e8 82 74 ff ff       	call   801003f4 <cprintf>
80108f72:	83 c4 10             	add    $0x10,%esp
80108f75:	83 ec 0c             	sub    $0xc,%esp
80108f78:	ff 75 f4             	push   -0xc(%ebp)
80108f7b:	e8 af 01 00 00       	call   8010912f <arp_table_update>
80108f80:	83 c4 10             	add    $0x10,%esp
80108f83:	b8 01 00 00 00       	mov    $0x1,%eax
80108f88:	eb 05                	jmp    80108f8f <arp_proc+0x171>
80108f8a:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80108f8f:	c9                   	leave  
80108f90:	c3                   	ret    

80108f91 <arp_scan>:
80108f91:	55                   	push   %ebp
80108f92:	89 e5                	mov    %esp,%ebp
80108f94:	83 ec 18             	sub    $0x18,%esp
80108f97:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80108f9e:	eb 6f                	jmp    8010900f <arp_scan+0x7e>
80108fa0:	e8 fb 97 ff ff       	call   801027a0 <kalloc>
80108fa5:	89 45 ec             	mov    %eax,-0x14(%ebp)
80108fa8:	83 ec 04             	sub    $0x4,%esp
80108fab:	ff 75 f4             	push   -0xc(%ebp)
80108fae:	8d 45 e8             	lea    -0x18(%ebp),%eax
80108fb1:	50                   	push   %eax
80108fb2:	ff 75 ec             	push   -0x14(%ebp)
80108fb5:	e8 62 00 00 00       	call   8010901c <arp_broadcast>
80108fba:	83 c4 10             	add    $0x10,%esp
80108fbd:	8b 45 e8             	mov    -0x18(%ebp),%eax
80108fc0:	83 ec 08             	sub    $0x8,%esp
80108fc3:	50                   	push   %eax
80108fc4:	ff 75 ec             	push   -0x14(%ebp)
80108fc7:	e8 26 fd ff ff       	call   80108cf2 <i8254_send>
80108fcc:	83 c4 10             	add    $0x10,%esp
80108fcf:	89 45 f0             	mov    %eax,-0x10(%ebp)
80108fd2:	eb 22                	jmp    80108ff6 <arp_scan+0x65>
80108fd4:	83 ec 0c             	sub    $0xc,%esp
80108fd7:	6a 01                	push   $0x1
80108fd9:	e8 59 9b ff ff       	call   80102b37 <microdelay>
80108fde:	83 c4 10             	add    $0x10,%esp
80108fe1:	8b 45 e8             	mov    -0x18(%ebp),%eax
80108fe4:	83 ec 08             	sub    $0x8,%esp
80108fe7:	50                   	push   %eax
80108fe8:	ff 75 ec             	push   -0x14(%ebp)
80108feb:	e8 02 fd ff ff       	call   80108cf2 <i8254_send>
80108ff0:	83 c4 10             	add    $0x10,%esp
80108ff3:	89 45 f0             	mov    %eax,-0x10(%ebp)
80108ff6:	83 7d f0 ff          	cmpl   $0xffffffff,-0x10(%ebp)
80108ffa:	74 d8                	je     80108fd4 <arp_scan+0x43>
80108ffc:	8b 45 ec             	mov    -0x14(%ebp),%eax
80108fff:	83 ec 0c             	sub    $0xc,%esp
80109002:	50                   	push   %eax
80109003:	e8 fe 96 ff ff       	call   80102706 <kfree>
80109008:	83 c4 10             	add    $0x10,%esp
8010900b:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
8010900f:	81 7d f4 ff 00 00 00 	cmpl   $0xff,-0xc(%ebp)
80109016:	7e 88                	jle    80108fa0 <arp_scan+0xf>
80109018:	90                   	nop
80109019:	90                   	nop
8010901a:	c9                   	leave  
8010901b:	c3                   	ret    

8010901c <arp_broadcast>:
8010901c:	55                   	push   %ebp
8010901d:	89 e5                	mov    %esp,%ebp
8010901f:	83 ec 28             	sub    $0x28,%esp
80109022:	c6 45 ec 0a          	movb   $0xa,-0x14(%ebp)
80109026:	c6 45 ed 00          	movb   $0x0,-0x13(%ebp)
8010902a:	c6 45 ee 01          	movb   $0x1,-0x12(%ebp)
8010902e:	8b 45 10             	mov    0x10(%ebp),%eax
80109031:	88 45 ef             	mov    %al,-0x11(%ebp)
80109034:	c7 45 e6 ff ff ff ff 	movl   $0xffffffff,-0x1a(%ebp)
8010903b:	66 c7 45 ea ff ff    	movw   $0xffff,-0x16(%ebp)
80109041:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
80109048:	66 c7 45 e4 00 00    	movw   $0x0,-0x1c(%ebp)
8010904e:	8b 45 0c             	mov    0xc(%ebp),%eax
80109051:	c7 00 2c 00 00 00    	movl   $0x2c,(%eax)
80109057:	8b 45 08             	mov    0x8(%ebp),%eax
8010905a:	89 45 f4             	mov    %eax,-0xc(%ebp)
8010905d:	8b 45 08             	mov    0x8(%ebp),%eax
80109060:	83 c0 0e             	add    $0xe,%eax
80109063:	89 45 f0             	mov    %eax,-0x10(%ebp)
80109066:	8b 45 f4             	mov    -0xc(%ebp),%eax
80109069:	c6 40 0c 08          	movb   $0x8,0xc(%eax)
8010906d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80109070:	c6 40 0d 06          	movb   $0x6,0xd(%eax)
80109074:	8b 45 f4             	mov    -0xc(%ebp),%eax
80109077:	83 ec 04             	sub    $0x4,%esp
8010907a:	6a 06                	push   $0x6
8010907c:	8d 55 e6             	lea    -0x1a(%ebp),%edx
8010907f:	52                   	push   %edx
80109080:	50                   	push   %eax
80109081:	e8 17 bc ff ff       	call   80104c9d <memmove>
80109086:	83 c4 10             	add    $0x10,%esp
80109089:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010908c:	83 c0 06             	add    $0x6,%eax
8010908f:	83 ec 04             	sub    $0x4,%esp
80109092:	6a 06                	push   $0x6
80109094:	68 80 6d 19 80       	push   $0x80196d80
80109099:	50                   	push   %eax
8010909a:	e8 fe bb ff ff       	call   80104c9d <memmove>
8010909f:	83 c4 10             	add    $0x10,%esp
801090a2:	8b 45 f0             	mov    -0x10(%ebp),%eax
801090a5:	66 c7 00 00 01       	movw   $0x100,(%eax)
801090aa:	8b 45 f0             	mov    -0x10(%ebp),%eax
801090ad:	66 c7 40 02 08 00    	movw   $0x8,0x2(%eax)
801090b3:	8b 45 f0             	mov    -0x10(%ebp),%eax
801090b6:	c6 40 04 06          	movb   $0x6,0x4(%eax)
801090ba:	8b 45 f0             	mov    -0x10(%ebp),%eax
801090bd:	c6 40 05 04          	movb   $0x4,0x5(%eax)
801090c1:	8b 45 f0             	mov    -0x10(%ebp),%eax
801090c4:	66 c7 40 06 00 01    	movw   $0x100,0x6(%eax)
801090ca:	8b 45 f0             	mov    -0x10(%ebp),%eax
801090cd:	8d 50 12             	lea    0x12(%eax),%edx
801090d0:	83 ec 04             	sub    $0x4,%esp
801090d3:	6a 06                	push   $0x6
801090d5:	8d 45 e0             	lea    -0x20(%ebp),%eax
801090d8:	50                   	push   %eax
801090d9:	52                   	push   %edx
801090da:	e8 be bb ff ff       	call   80104c9d <memmove>
801090df:	83 c4 10             	add    $0x10,%esp
801090e2:	8b 45 f0             	mov    -0x10(%ebp),%eax
801090e5:	8d 50 18             	lea    0x18(%eax),%edx
801090e8:	83 ec 04             	sub    $0x4,%esp
801090eb:	6a 04                	push   $0x4
801090ed:	8d 45 ec             	lea    -0x14(%ebp),%eax
801090f0:	50                   	push   %eax
801090f1:	52                   	push   %edx
801090f2:	e8 a6 bb ff ff       	call   80104c9d <memmove>
801090f7:	83 c4 10             	add    $0x10,%esp
801090fa:	8b 45 f0             	mov    -0x10(%ebp),%eax
801090fd:	83 c0 08             	add    $0x8,%eax
80109100:	83 ec 04             	sub    $0x4,%esp
80109103:	6a 06                	push   $0x6
80109105:	68 80 6d 19 80       	push   $0x80196d80
8010910a:	50                   	push   %eax
8010910b:	e8 8d bb ff ff       	call   80104c9d <memmove>
80109110:	83 c4 10             	add    $0x10,%esp
80109113:	8b 45 f0             	mov    -0x10(%ebp),%eax
80109116:	83 c0 0e             	add    $0xe,%eax
80109119:	83 ec 04             	sub    $0x4,%esp
8010911c:	6a 04                	push   $0x4
8010911e:	68 e4 f4 10 80       	push   $0x8010f4e4
80109123:	50                   	push   %eax
80109124:	e8 74 bb ff ff       	call   80104c9d <memmove>
80109129:	83 c4 10             	add    $0x10,%esp
8010912c:	90                   	nop
8010912d:	c9                   	leave  
8010912e:	c3                   	ret    

8010912f <arp_table_update>:
8010912f:	55                   	push   %ebp
80109130:	89 e5                	mov    %esp,%ebp
80109132:	83 ec 18             	sub    $0x18,%esp
80109135:	8b 45 08             	mov    0x8(%ebp),%eax
80109138:	83 c0 0e             	add    $0xe,%eax
8010913b:	83 ec 0c             	sub    $0xc,%esp
8010913e:	50                   	push   %eax
8010913f:	e8 bc 00 00 00       	call   80109200 <arp_table_search>
80109144:	83 c4 10             	add    $0x10,%esp
80109147:	89 45 f4             	mov    %eax,-0xc(%ebp)
8010914a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
8010914e:	78 2d                	js     8010917d <arp_table_update+0x4e>
80109150:	8b 45 08             	mov    0x8(%ebp),%eax
80109153:	8d 48 08             	lea    0x8(%eax),%ecx
80109156:	8b 55 f4             	mov    -0xc(%ebp),%edx
80109159:	89 d0                	mov    %edx,%eax
8010915b:	c1 e0 02             	shl    $0x2,%eax
8010915e:	01 d0                	add    %edx,%eax
80109160:	01 c0                	add    %eax,%eax
80109162:	01 d0                	add    %edx,%eax
80109164:	05 a0 6d 19 80       	add    $0x80196da0,%eax
80109169:	83 c0 04             	add    $0x4,%eax
8010916c:	83 ec 04             	sub    $0x4,%esp
8010916f:	6a 06                	push   $0x6
80109171:	51                   	push   %ecx
80109172:	50                   	push   %eax
80109173:	e8 25 bb ff ff       	call   80104c9d <memmove>
80109178:	83 c4 10             	add    $0x10,%esp
8010917b:	eb 70                	jmp    801091ed <arp_table_update+0xbe>
8010917d:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80109181:	f7 5d f4             	negl   -0xc(%ebp)
80109184:	8b 45 08             	mov    0x8(%ebp),%eax
80109187:	8d 48 08             	lea    0x8(%eax),%ecx
8010918a:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010918d:	89 d0                	mov    %edx,%eax
8010918f:	c1 e0 02             	shl    $0x2,%eax
80109192:	01 d0                	add    %edx,%eax
80109194:	01 c0                	add    %eax,%eax
80109196:	01 d0                	add    %edx,%eax
80109198:	05 a0 6d 19 80       	add    $0x80196da0,%eax
8010919d:	83 c0 04             	add    $0x4,%eax
801091a0:	83 ec 04             	sub    $0x4,%esp
801091a3:	6a 06                	push   $0x6
801091a5:	51                   	push   %ecx
801091a6:	50                   	push   %eax
801091a7:	e8 f1 ba ff ff       	call   80104c9d <memmove>
801091ac:	83 c4 10             	add    $0x10,%esp
801091af:	8b 45 08             	mov    0x8(%ebp),%eax
801091b2:	8d 48 0e             	lea    0xe(%eax),%ecx
801091b5:	8b 55 f4             	mov    -0xc(%ebp),%edx
801091b8:	89 d0                	mov    %edx,%eax
801091ba:	c1 e0 02             	shl    $0x2,%eax
801091bd:	01 d0                	add    %edx,%eax
801091bf:	01 c0                	add    %eax,%eax
801091c1:	01 d0                	add    %edx,%eax
801091c3:	05 a0 6d 19 80       	add    $0x80196da0,%eax
801091c8:	83 ec 04             	sub    $0x4,%esp
801091cb:	6a 04                	push   $0x4
801091cd:	51                   	push   %ecx
801091ce:	50                   	push   %eax
801091cf:	e8 c9 ba ff ff       	call   80104c9d <memmove>
801091d4:	83 c4 10             	add    $0x10,%esp
801091d7:	8b 55 f4             	mov    -0xc(%ebp),%edx
801091da:	89 d0                	mov    %edx,%eax
801091dc:	c1 e0 02             	shl    $0x2,%eax
801091df:	01 d0                	add    %edx,%eax
801091e1:	01 c0                	add    %eax,%eax
801091e3:	01 d0                	add    %edx,%eax
801091e5:	05 aa 6d 19 80       	add    $0x80196daa,%eax
801091ea:	c6 00 01             	movb   $0x1,(%eax)
801091ed:	83 ec 0c             	sub    $0xc,%esp
801091f0:	68 a0 6d 19 80       	push   $0x80196da0
801091f5:	e8 83 00 00 00       	call   8010927d <print_arp_table>
801091fa:	83 c4 10             	add    $0x10,%esp
801091fd:	90                   	nop
801091fe:	c9                   	leave  
801091ff:	c3                   	ret    

80109200 <arp_table_search>:
80109200:	55                   	push   %ebp
80109201:	89 e5                	mov    %esp,%ebp
80109203:	83 ec 18             	sub    $0x18,%esp
80109206:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
8010920d:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
80109214:	eb 59                	jmp    8010926f <arp_table_search+0x6f>
80109216:	8b 55 f0             	mov    -0x10(%ebp),%edx
80109219:	89 d0                	mov    %edx,%eax
8010921b:	c1 e0 02             	shl    $0x2,%eax
8010921e:	01 d0                	add    %edx,%eax
80109220:	01 c0                	add    %eax,%eax
80109222:	01 d0                	add    %edx,%eax
80109224:	05 a0 6d 19 80       	add    $0x80196da0,%eax
80109229:	83 ec 04             	sub    $0x4,%esp
8010922c:	6a 04                	push   $0x4
8010922e:	ff 75 08             	push   0x8(%ebp)
80109231:	50                   	push   %eax
80109232:	e8 0e ba ff ff       	call   80104c45 <memcmp>
80109237:	83 c4 10             	add    $0x10,%esp
8010923a:	85 c0                	test   %eax,%eax
8010923c:	75 05                	jne    80109243 <arp_table_search+0x43>
8010923e:	8b 45 f0             	mov    -0x10(%ebp),%eax
80109241:	eb 38                	jmp    8010927b <arp_table_search+0x7b>
80109243:	8b 55 f0             	mov    -0x10(%ebp),%edx
80109246:	89 d0                	mov    %edx,%eax
80109248:	c1 e0 02             	shl    $0x2,%eax
8010924b:	01 d0                	add    %edx,%eax
8010924d:	01 c0                	add    %eax,%eax
8010924f:	01 d0                	add    %edx,%eax
80109251:	05 aa 6d 19 80       	add    $0x80196daa,%eax
80109256:	0f b6 00             	movzbl (%eax),%eax
80109259:	84 c0                	test   %al,%al
8010925b:	75 0e                	jne    8010926b <arp_table_search+0x6b>
8010925d:	83 7d f4 01          	cmpl   $0x1,-0xc(%ebp)
80109261:	75 08                	jne    8010926b <arp_table_search+0x6b>
80109263:	8b 45 f0             	mov    -0x10(%ebp),%eax
80109266:	f7 d8                	neg    %eax
80109268:	89 45 f4             	mov    %eax,-0xc(%ebp)
8010926b:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
8010926f:	83 7d f0 3f          	cmpl   $0x3f,-0x10(%ebp)
80109273:	7e a1                	jle    80109216 <arp_table_search+0x16>
80109275:	8b 45 f4             	mov    -0xc(%ebp),%eax
80109278:	83 e8 01             	sub    $0x1,%eax
8010927b:	c9                   	leave  
8010927c:	c3                   	ret    

8010927d <print_arp_table>:
8010927d:	55                   	push   %ebp
8010927e:	89 e5                	mov    %esp,%ebp
80109280:	83 ec 18             	sub    $0x18,%esp
80109283:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
8010928a:	e9 92 00 00 00       	jmp    80109321 <print_arp_table+0xa4>
8010928f:	8b 55 f4             	mov    -0xc(%ebp),%edx
80109292:	89 d0                	mov    %edx,%eax
80109294:	c1 e0 02             	shl    $0x2,%eax
80109297:	01 d0                	add    %edx,%eax
80109299:	01 c0                	add    %eax,%eax
8010929b:	01 d0                	add    %edx,%eax
8010929d:	05 aa 6d 19 80       	add    $0x80196daa,%eax
801092a2:	0f b6 00             	movzbl (%eax),%eax
801092a5:	84 c0                	test   %al,%al
801092a7:	74 74                	je     8010931d <print_arp_table+0xa0>
801092a9:	83 ec 08             	sub    $0x8,%esp
801092ac:	ff 75 f4             	push   -0xc(%ebp)
801092af:	68 0f c1 10 80       	push   $0x8010c10f
801092b4:	e8 3b 71 ff ff       	call   801003f4 <cprintf>
801092b9:	83 c4 10             	add    $0x10,%esp
801092bc:	8b 55 f4             	mov    -0xc(%ebp),%edx
801092bf:	89 d0                	mov    %edx,%eax
801092c1:	c1 e0 02             	shl    $0x2,%eax
801092c4:	01 d0                	add    %edx,%eax
801092c6:	01 c0                	add    %eax,%eax
801092c8:	01 d0                	add    %edx,%eax
801092ca:	05 a0 6d 19 80       	add    $0x80196da0,%eax
801092cf:	83 ec 0c             	sub    $0xc,%esp
801092d2:	50                   	push   %eax
801092d3:	e8 54 02 00 00       	call   8010952c <print_ipv4>
801092d8:	83 c4 10             	add    $0x10,%esp
801092db:	83 ec 0c             	sub    $0xc,%esp
801092de:	68 1e c1 10 80       	push   $0x8010c11e
801092e3:	e8 0c 71 ff ff       	call   801003f4 <cprintf>
801092e8:	83 c4 10             	add    $0x10,%esp
801092eb:	8b 55 f4             	mov    -0xc(%ebp),%edx
801092ee:	89 d0                	mov    %edx,%eax
801092f0:	c1 e0 02             	shl    $0x2,%eax
801092f3:	01 d0                	add    %edx,%eax
801092f5:	01 c0                	add    %eax,%eax
801092f7:	01 d0                	add    %edx,%eax
801092f9:	05 a0 6d 19 80       	add    $0x80196da0,%eax
801092fe:	83 c0 04             	add    $0x4,%eax
80109301:	83 ec 0c             	sub    $0xc,%esp
80109304:	50                   	push   %eax
80109305:	e8 70 02 00 00       	call   8010957a <print_mac>
8010930a:	83 c4 10             	add    $0x10,%esp
8010930d:	83 ec 0c             	sub    $0xc,%esp
80109310:	68 20 c1 10 80       	push   $0x8010c120
80109315:	e8 da 70 ff ff       	call   801003f4 <cprintf>
8010931a:	83 c4 10             	add    $0x10,%esp
8010931d:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80109321:	83 7d f4 3f          	cmpl   $0x3f,-0xc(%ebp)
80109325:	0f 8e 64 ff ff ff    	jle    8010928f <print_arp_table+0x12>
8010932b:	90                   	nop
8010932c:	90                   	nop
8010932d:	c9                   	leave  
8010932e:	c3                   	ret    

8010932f <arp_reply_pkt_create>:
8010932f:	55                   	push   %ebp
80109330:	89 e5                	mov    %esp,%ebp
80109332:	83 ec 18             	sub    $0x18,%esp
80109335:	8b 45 10             	mov    0x10(%ebp),%eax
80109338:	c7 00 2c 00 00 00    	movl   $0x2c,(%eax)
8010933e:	8b 45 0c             	mov    0xc(%ebp),%eax
80109341:	89 45 f4             	mov    %eax,-0xc(%ebp)
80109344:	8b 45 0c             	mov    0xc(%ebp),%eax
80109347:	83 c0 0e             	add    $0xe,%eax
8010934a:	89 45 f0             	mov    %eax,-0x10(%ebp)
8010934d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80109350:	c6 40 0c 08          	movb   $0x8,0xc(%eax)
80109354:	8b 45 f4             	mov    -0xc(%ebp),%eax
80109357:	c6 40 0d 06          	movb   $0x6,0xd(%eax)
8010935b:	8b 45 08             	mov    0x8(%ebp),%eax
8010935e:	8d 50 08             	lea    0x8(%eax),%edx
80109361:	8b 45 f4             	mov    -0xc(%ebp),%eax
80109364:	83 ec 04             	sub    $0x4,%esp
80109367:	6a 06                	push   $0x6
80109369:	52                   	push   %edx
8010936a:	50                   	push   %eax
8010936b:	e8 2d b9 ff ff       	call   80104c9d <memmove>
80109370:	83 c4 10             	add    $0x10,%esp
80109373:	8b 45 f4             	mov    -0xc(%ebp),%eax
80109376:	83 c0 06             	add    $0x6,%eax
80109379:	83 ec 04             	sub    $0x4,%esp
8010937c:	6a 06                	push   $0x6
8010937e:	68 80 6d 19 80       	push   $0x80196d80
80109383:	50                   	push   %eax
80109384:	e8 14 b9 ff ff       	call   80104c9d <memmove>
80109389:	83 c4 10             	add    $0x10,%esp
8010938c:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010938f:	66 c7 00 00 01       	movw   $0x100,(%eax)
80109394:	8b 45 f0             	mov    -0x10(%ebp),%eax
80109397:	66 c7 40 02 08 00    	movw   $0x8,0x2(%eax)
8010939d:	8b 45 f0             	mov    -0x10(%ebp),%eax
801093a0:	c6 40 04 06          	movb   $0x6,0x4(%eax)
801093a4:	8b 45 f0             	mov    -0x10(%ebp),%eax
801093a7:	c6 40 05 04          	movb   $0x4,0x5(%eax)
801093ab:	8b 45 f0             	mov    -0x10(%ebp),%eax
801093ae:	66 c7 40 06 00 02    	movw   $0x200,0x6(%eax)
801093b4:	8b 45 08             	mov    0x8(%ebp),%eax
801093b7:	8d 50 08             	lea    0x8(%eax),%edx
801093ba:	8b 45 f0             	mov    -0x10(%ebp),%eax
801093bd:	83 c0 12             	add    $0x12,%eax
801093c0:	83 ec 04             	sub    $0x4,%esp
801093c3:	6a 06                	push   $0x6
801093c5:	52                   	push   %edx
801093c6:	50                   	push   %eax
801093c7:	e8 d1 b8 ff ff       	call   80104c9d <memmove>
801093cc:	83 c4 10             	add    $0x10,%esp
801093cf:	8b 45 08             	mov    0x8(%ebp),%eax
801093d2:	8d 50 0e             	lea    0xe(%eax),%edx
801093d5:	8b 45 f0             	mov    -0x10(%ebp),%eax
801093d8:	83 c0 18             	add    $0x18,%eax
801093db:	83 ec 04             	sub    $0x4,%esp
801093de:	6a 04                	push   $0x4
801093e0:	52                   	push   %edx
801093e1:	50                   	push   %eax
801093e2:	e8 b6 b8 ff ff       	call   80104c9d <memmove>
801093e7:	83 c4 10             	add    $0x10,%esp
801093ea:	8b 45 f0             	mov    -0x10(%ebp),%eax
801093ed:	83 c0 08             	add    $0x8,%eax
801093f0:	83 ec 04             	sub    $0x4,%esp
801093f3:	6a 06                	push   $0x6
801093f5:	68 80 6d 19 80       	push   $0x80196d80
801093fa:	50                   	push   %eax
801093fb:	e8 9d b8 ff ff       	call   80104c9d <memmove>
80109400:	83 c4 10             	add    $0x10,%esp
80109403:	8b 45 f0             	mov    -0x10(%ebp),%eax
80109406:	83 c0 0e             	add    $0xe,%eax
80109409:	83 ec 04             	sub    $0x4,%esp
8010940c:	6a 04                	push   $0x4
8010940e:	68 e4 f4 10 80       	push   $0x8010f4e4
80109413:	50                   	push   %eax
80109414:	e8 84 b8 ff ff       	call   80104c9d <memmove>
80109419:	83 c4 10             	add    $0x10,%esp
8010941c:	90                   	nop
8010941d:	c9                   	leave  
8010941e:	c3                   	ret    

8010941f <print_arp_info>:
8010941f:	55                   	push   %ebp
80109420:	89 e5                	mov    %esp,%ebp
80109422:	83 ec 08             	sub    $0x8,%esp
80109425:	83 ec 0c             	sub    $0xc,%esp
80109428:	68 22 c1 10 80       	push   $0x8010c122
8010942d:	e8 c2 6f ff ff       	call   801003f4 <cprintf>
80109432:	83 c4 10             	add    $0x10,%esp
80109435:	8b 45 08             	mov    0x8(%ebp),%eax
80109438:	83 c0 0e             	add    $0xe,%eax
8010943b:	83 ec 0c             	sub    $0xc,%esp
8010943e:	50                   	push   %eax
8010943f:	e8 e8 00 00 00       	call   8010952c <print_ipv4>
80109444:	83 c4 10             	add    $0x10,%esp
80109447:	83 ec 0c             	sub    $0xc,%esp
8010944a:	68 20 c1 10 80       	push   $0x8010c120
8010944f:	e8 a0 6f ff ff       	call   801003f4 <cprintf>
80109454:	83 c4 10             	add    $0x10,%esp
80109457:	8b 45 08             	mov    0x8(%ebp),%eax
8010945a:	83 c0 08             	add    $0x8,%eax
8010945d:	83 ec 0c             	sub    $0xc,%esp
80109460:	50                   	push   %eax
80109461:	e8 14 01 00 00       	call   8010957a <print_mac>
80109466:	83 c4 10             	add    $0x10,%esp
80109469:	83 ec 0c             	sub    $0xc,%esp
8010946c:	68 20 c1 10 80       	push   $0x8010c120
80109471:	e8 7e 6f ff ff       	call   801003f4 <cprintf>
80109476:	83 c4 10             	add    $0x10,%esp
80109479:	83 ec 0c             	sub    $0xc,%esp
8010947c:	68 39 c1 10 80       	push   $0x8010c139
80109481:	e8 6e 6f ff ff       	call   801003f4 <cprintf>
80109486:	83 c4 10             	add    $0x10,%esp
80109489:	8b 45 08             	mov    0x8(%ebp),%eax
8010948c:	83 c0 18             	add    $0x18,%eax
8010948f:	83 ec 0c             	sub    $0xc,%esp
80109492:	50                   	push   %eax
80109493:	e8 94 00 00 00       	call   8010952c <print_ipv4>
80109498:	83 c4 10             	add    $0x10,%esp
8010949b:	83 ec 0c             	sub    $0xc,%esp
8010949e:	68 20 c1 10 80       	push   $0x8010c120
801094a3:	e8 4c 6f ff ff       	call   801003f4 <cprintf>
801094a8:	83 c4 10             	add    $0x10,%esp
801094ab:	8b 45 08             	mov    0x8(%ebp),%eax
801094ae:	83 c0 12             	add    $0x12,%eax
801094b1:	83 ec 0c             	sub    $0xc,%esp
801094b4:	50                   	push   %eax
801094b5:	e8 c0 00 00 00       	call   8010957a <print_mac>
801094ba:	83 c4 10             	add    $0x10,%esp
801094bd:	83 ec 0c             	sub    $0xc,%esp
801094c0:	68 20 c1 10 80       	push   $0x8010c120
801094c5:	e8 2a 6f ff ff       	call   801003f4 <cprintf>
801094ca:	83 c4 10             	add    $0x10,%esp
801094cd:	83 ec 0c             	sub    $0xc,%esp
801094d0:	68 50 c1 10 80       	push   $0x8010c150
801094d5:	e8 1a 6f ff ff       	call   801003f4 <cprintf>
801094da:	83 c4 10             	add    $0x10,%esp
801094dd:	8b 45 08             	mov    0x8(%ebp),%eax
801094e0:	0f b7 40 06          	movzwl 0x6(%eax),%eax
801094e4:	66 3d 00 01          	cmp    $0x100,%ax
801094e8:	75 12                	jne    801094fc <print_arp_info+0xdd>
801094ea:	83 ec 0c             	sub    $0xc,%esp
801094ed:	68 5c c1 10 80       	push   $0x8010c15c
801094f2:	e8 fd 6e ff ff       	call   801003f4 <cprintf>
801094f7:	83 c4 10             	add    $0x10,%esp
801094fa:	eb 1d                	jmp    80109519 <print_arp_info+0xfa>
801094fc:	8b 45 08             	mov    0x8(%ebp),%eax
801094ff:	0f b7 40 06          	movzwl 0x6(%eax),%eax
80109503:	66 3d 00 02          	cmp    $0x200,%ax
80109507:	75 10                	jne    80109519 <print_arp_info+0xfa>
80109509:	83 ec 0c             	sub    $0xc,%esp
8010950c:	68 65 c1 10 80       	push   $0x8010c165
80109511:	e8 de 6e ff ff       	call   801003f4 <cprintf>
80109516:	83 c4 10             	add    $0x10,%esp
80109519:	83 ec 0c             	sub    $0xc,%esp
8010951c:	68 20 c1 10 80       	push   $0x8010c120
80109521:	e8 ce 6e ff ff       	call   801003f4 <cprintf>
80109526:	83 c4 10             	add    $0x10,%esp
80109529:	90                   	nop
8010952a:	c9                   	leave  
8010952b:	c3                   	ret    

8010952c <print_ipv4>:
8010952c:	55                   	push   %ebp
8010952d:	89 e5                	mov    %esp,%ebp
8010952f:	53                   	push   %ebx
80109530:	83 ec 04             	sub    $0x4,%esp
80109533:	8b 45 08             	mov    0x8(%ebp),%eax
80109536:	83 c0 03             	add    $0x3,%eax
80109539:	0f b6 00             	movzbl (%eax),%eax
8010953c:	0f b6 d8             	movzbl %al,%ebx
8010953f:	8b 45 08             	mov    0x8(%ebp),%eax
80109542:	83 c0 02             	add    $0x2,%eax
80109545:	0f b6 00             	movzbl (%eax),%eax
80109548:	0f b6 c8             	movzbl %al,%ecx
8010954b:	8b 45 08             	mov    0x8(%ebp),%eax
8010954e:	83 c0 01             	add    $0x1,%eax
80109551:	0f b6 00             	movzbl (%eax),%eax
80109554:	0f b6 d0             	movzbl %al,%edx
80109557:	8b 45 08             	mov    0x8(%ebp),%eax
8010955a:	0f b6 00             	movzbl (%eax),%eax
8010955d:	0f b6 c0             	movzbl %al,%eax
80109560:	83 ec 0c             	sub    $0xc,%esp
80109563:	53                   	push   %ebx
80109564:	51                   	push   %ecx
80109565:	52                   	push   %edx
80109566:	50                   	push   %eax
80109567:	68 6c c1 10 80       	push   $0x8010c16c
8010956c:	e8 83 6e ff ff       	call   801003f4 <cprintf>
80109571:	83 c4 20             	add    $0x20,%esp
80109574:	90                   	nop
80109575:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80109578:	c9                   	leave  
80109579:	c3                   	ret    

8010957a <print_mac>:
8010957a:	55                   	push   %ebp
8010957b:	89 e5                	mov    %esp,%ebp
8010957d:	57                   	push   %edi
8010957e:	56                   	push   %esi
8010957f:	53                   	push   %ebx
80109580:	83 ec 0c             	sub    $0xc,%esp
80109583:	8b 45 08             	mov    0x8(%ebp),%eax
80109586:	83 c0 05             	add    $0x5,%eax
80109589:	0f b6 00             	movzbl (%eax),%eax
8010958c:	0f b6 f8             	movzbl %al,%edi
8010958f:	8b 45 08             	mov    0x8(%ebp),%eax
80109592:	83 c0 04             	add    $0x4,%eax
80109595:	0f b6 00             	movzbl (%eax),%eax
80109598:	0f b6 f0             	movzbl %al,%esi
8010959b:	8b 45 08             	mov    0x8(%ebp),%eax
8010959e:	83 c0 03             	add    $0x3,%eax
801095a1:	0f b6 00             	movzbl (%eax),%eax
801095a4:	0f b6 d8             	movzbl %al,%ebx
801095a7:	8b 45 08             	mov    0x8(%ebp),%eax
801095aa:	83 c0 02             	add    $0x2,%eax
801095ad:	0f b6 00             	movzbl (%eax),%eax
801095b0:	0f b6 c8             	movzbl %al,%ecx
801095b3:	8b 45 08             	mov    0x8(%ebp),%eax
801095b6:	83 c0 01             	add    $0x1,%eax
801095b9:	0f b6 00             	movzbl (%eax),%eax
801095bc:	0f b6 d0             	movzbl %al,%edx
801095bf:	8b 45 08             	mov    0x8(%ebp),%eax
801095c2:	0f b6 00             	movzbl (%eax),%eax
801095c5:	0f b6 c0             	movzbl %al,%eax
801095c8:	83 ec 04             	sub    $0x4,%esp
801095cb:	57                   	push   %edi
801095cc:	56                   	push   %esi
801095cd:	53                   	push   %ebx
801095ce:	51                   	push   %ecx
801095cf:	52                   	push   %edx
801095d0:	50                   	push   %eax
801095d1:	68 84 c1 10 80       	push   $0x8010c184
801095d6:	e8 19 6e ff ff       	call   801003f4 <cprintf>
801095db:	83 c4 20             	add    $0x20,%esp
801095de:	90                   	nop
801095df:	8d 65 f4             	lea    -0xc(%ebp),%esp
801095e2:	5b                   	pop    %ebx
801095e3:	5e                   	pop    %esi
801095e4:	5f                   	pop    %edi
801095e5:	5d                   	pop    %ebp
801095e6:	c3                   	ret    

801095e7 <eth_proc>:
801095e7:	55                   	push   %ebp
801095e8:	89 e5                	mov    %esp,%ebp
801095ea:	83 ec 18             	sub    $0x18,%esp
801095ed:	8b 45 08             	mov    0x8(%ebp),%eax
801095f0:	89 45 f4             	mov    %eax,-0xc(%ebp)
801095f3:	8b 45 08             	mov    0x8(%ebp),%eax
801095f6:	83 c0 0e             	add    $0xe,%eax
801095f9:	89 45 f0             	mov    %eax,-0x10(%ebp)
801095fc:	8b 45 f4             	mov    -0xc(%ebp),%eax
801095ff:	0f b6 40 0c          	movzbl 0xc(%eax),%eax
80109603:	3c 08                	cmp    $0x8,%al
80109605:	75 1b                	jne    80109622 <eth_proc+0x3b>
80109607:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010960a:	0f b6 40 0d          	movzbl 0xd(%eax),%eax
8010960e:	3c 06                	cmp    $0x6,%al
80109610:	75 10                	jne    80109622 <eth_proc+0x3b>
80109612:	83 ec 0c             	sub    $0xc,%esp
80109615:	ff 75 f0             	push   -0x10(%ebp)
80109618:	e8 01 f8 ff ff       	call   80108e1e <arp_proc>
8010961d:	83 c4 10             	add    $0x10,%esp
80109620:	eb 24                	jmp    80109646 <eth_proc+0x5f>
80109622:	8b 45 f4             	mov    -0xc(%ebp),%eax
80109625:	0f b6 40 0c          	movzbl 0xc(%eax),%eax
80109629:	3c 08                	cmp    $0x8,%al
8010962b:	75 19                	jne    80109646 <eth_proc+0x5f>
8010962d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80109630:	0f b6 40 0d          	movzbl 0xd(%eax),%eax
80109634:	84 c0                	test   %al,%al
80109636:	75 0e                	jne    80109646 <eth_proc+0x5f>
80109638:	83 ec 0c             	sub    $0xc,%esp
8010963b:	ff 75 08             	push   0x8(%ebp)
8010963e:	e8 a3 00 00 00       	call   801096e6 <ipv4_proc>
80109643:	83 c4 10             	add    $0x10,%esp
80109646:	90                   	nop
80109647:	c9                   	leave  
80109648:	c3                   	ret    

80109649 <N2H_ushort>:
80109649:	55                   	push   %ebp
8010964a:	89 e5                	mov    %esp,%ebp
8010964c:	83 ec 04             	sub    $0x4,%esp
8010964f:	8b 45 08             	mov    0x8(%ebp),%eax
80109652:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
80109656:	0f b7 45 fc          	movzwl -0x4(%ebp),%eax
8010965a:	c1 e0 08             	shl    $0x8,%eax
8010965d:	89 c2                	mov    %eax,%edx
8010965f:	0f b7 45 fc          	movzwl -0x4(%ebp),%eax
80109663:	66 c1 e8 08          	shr    $0x8,%ax
80109667:	01 d0                	add    %edx,%eax
80109669:	c9                   	leave  
8010966a:	c3                   	ret    

8010966b <H2N_ushort>:
8010966b:	55                   	push   %ebp
8010966c:	89 e5                	mov    %esp,%ebp
8010966e:	83 ec 04             	sub    $0x4,%esp
80109671:	8b 45 08             	mov    0x8(%ebp),%eax
80109674:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
80109678:	0f b7 45 fc          	movzwl -0x4(%ebp),%eax
8010967c:	c1 e0 08             	shl    $0x8,%eax
8010967f:	89 c2                	mov    %eax,%edx
80109681:	0f b7 45 fc          	movzwl -0x4(%ebp),%eax
80109685:	66 c1 e8 08          	shr    $0x8,%ax
80109689:	01 d0                	add    %edx,%eax
8010968b:	c9                   	leave  
8010968c:	c3                   	ret    

8010968d <H2N_uint>:
8010968d:	55                   	push   %ebp
8010968e:	89 e5                	mov    %esp,%ebp
80109690:	8b 45 08             	mov    0x8(%ebp),%eax
80109693:	c1 e0 18             	shl    $0x18,%eax
80109696:	25 00 00 00 0f       	and    $0xf000000,%eax
8010969b:	89 c2                	mov    %eax,%edx
8010969d:	8b 45 08             	mov    0x8(%ebp),%eax
801096a0:	c1 e0 08             	shl    $0x8,%eax
801096a3:	25 00 f0 00 00       	and    $0xf000,%eax
801096a8:	09 c2                	or     %eax,%edx
801096aa:	8b 45 08             	mov    0x8(%ebp),%eax
801096ad:	c1 e8 08             	shr    $0x8,%eax
801096b0:	83 e0 0f             	and    $0xf,%eax
801096b3:	01 d0                	add    %edx,%eax
801096b5:	5d                   	pop    %ebp
801096b6:	c3                   	ret    

801096b7 <N2H_uint>:
801096b7:	55                   	push   %ebp
801096b8:	89 e5                	mov    %esp,%ebp
801096ba:	8b 45 08             	mov    0x8(%ebp),%eax
801096bd:	c1 e0 18             	shl    $0x18,%eax
801096c0:	89 c2                	mov    %eax,%edx
801096c2:	8b 45 08             	mov    0x8(%ebp),%eax
801096c5:	c1 e0 08             	shl    $0x8,%eax
801096c8:	25 00 00 ff 00       	and    $0xff0000,%eax
801096cd:	01 c2                	add    %eax,%edx
801096cf:	8b 45 08             	mov    0x8(%ebp),%eax
801096d2:	c1 e8 08             	shr    $0x8,%eax
801096d5:	25 00 ff 00 00       	and    $0xff00,%eax
801096da:	01 c2                	add    %eax,%edx
801096dc:	8b 45 08             	mov    0x8(%ebp),%eax
801096df:	c1 e8 18             	shr    $0x18,%eax
801096e2:	01 d0                	add    %edx,%eax
801096e4:	5d                   	pop    %ebp
801096e5:	c3                   	ret    

801096e6 <ipv4_proc>:
801096e6:	55                   	push   %ebp
801096e7:	89 e5                	mov    %esp,%ebp
801096e9:	83 ec 18             	sub    $0x18,%esp
801096ec:	8b 45 08             	mov    0x8(%ebp),%eax
801096ef:	83 c0 0e             	add    $0xe,%eax
801096f2:	89 45 f4             	mov    %eax,-0xc(%ebp)
801096f5:	8b 45 f4             	mov    -0xc(%ebp),%eax
801096f8:	0f b7 40 04          	movzwl 0x4(%eax),%eax
801096fc:	0f b7 d0             	movzwl %ax,%edx
801096ff:	a1 e8 f4 10 80       	mov    0x8010f4e8,%eax
80109704:	39 c2                	cmp    %eax,%edx
80109706:	74 60                	je     80109768 <ipv4_proc+0x82>
80109708:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010970b:	83 c0 0c             	add    $0xc,%eax
8010970e:	83 ec 04             	sub    $0x4,%esp
80109711:	6a 04                	push   $0x4
80109713:	50                   	push   %eax
80109714:	68 e4 f4 10 80       	push   $0x8010f4e4
80109719:	e8 27 b5 ff ff       	call   80104c45 <memcmp>
8010971e:	83 c4 10             	add    $0x10,%esp
80109721:	85 c0                	test   %eax,%eax
80109723:	74 43                	je     80109768 <ipv4_proc+0x82>
80109725:	8b 45 f4             	mov    -0xc(%ebp),%eax
80109728:	0f b7 40 04          	movzwl 0x4(%eax),%eax
8010972c:	0f b7 c0             	movzwl %ax,%eax
8010972f:	a3 e8 f4 10 80       	mov    %eax,0x8010f4e8
80109734:	8b 45 f4             	mov    -0xc(%ebp),%eax
80109737:	0f b6 40 09          	movzbl 0x9(%eax),%eax
8010973b:	3c 01                	cmp    $0x1,%al
8010973d:	75 10                	jne    8010974f <ipv4_proc+0x69>
8010973f:	83 ec 0c             	sub    $0xc,%esp
80109742:	ff 75 08             	push   0x8(%ebp)
80109745:	e8 a3 00 00 00       	call   801097ed <icmp_proc>
8010974a:	83 c4 10             	add    $0x10,%esp
8010974d:	eb 19                	jmp    80109768 <ipv4_proc+0x82>
8010974f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80109752:	0f b6 40 09          	movzbl 0x9(%eax),%eax
80109756:	3c 06                	cmp    $0x6,%al
80109758:	75 0e                	jne    80109768 <ipv4_proc+0x82>
8010975a:	83 ec 0c             	sub    $0xc,%esp
8010975d:	ff 75 08             	push   0x8(%ebp)
80109760:	e8 b3 03 00 00       	call   80109b18 <tcp_proc>
80109765:	83 c4 10             	add    $0x10,%esp
80109768:	90                   	nop
80109769:	c9                   	leave  
8010976a:	c3                   	ret    

8010976b <ipv4_chksum>:
8010976b:	55                   	push   %ebp
8010976c:	89 e5                	mov    %esp,%ebp
8010976e:	83 ec 10             	sub    $0x10,%esp
80109771:	8b 45 08             	mov    0x8(%ebp),%eax
80109774:	89 45 f4             	mov    %eax,-0xc(%ebp)
80109777:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010977a:	0f b6 00             	movzbl (%eax),%eax
8010977d:	83 e0 0f             	and    $0xf,%eax
80109780:	01 c0                	add    %eax,%eax
80109782:	88 45 f3             	mov    %al,-0xd(%ebp)
80109785:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
8010978c:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
80109793:	eb 48                	jmp    801097dd <ipv4_chksum+0x72>
80109795:	8b 45 f8             	mov    -0x8(%ebp),%eax
80109798:	01 c0                	add    %eax,%eax
8010979a:	89 c2                	mov    %eax,%edx
8010979c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010979f:	01 d0                	add    %edx,%eax
801097a1:	0f b6 00             	movzbl (%eax),%eax
801097a4:	0f b6 c0             	movzbl %al,%eax
801097a7:	c1 e0 08             	shl    $0x8,%eax
801097aa:	89 c2                	mov    %eax,%edx
801097ac:	8b 45 f8             	mov    -0x8(%ebp),%eax
801097af:	01 c0                	add    %eax,%eax
801097b1:	8d 48 01             	lea    0x1(%eax),%ecx
801097b4:	8b 45 f4             	mov    -0xc(%ebp),%eax
801097b7:	01 c8                	add    %ecx,%eax
801097b9:	0f b6 00             	movzbl (%eax),%eax
801097bc:	0f b6 c0             	movzbl %al,%eax
801097bf:	01 d0                	add    %edx,%eax
801097c1:	01 45 fc             	add    %eax,-0x4(%ebp)
801097c4:	81 7d fc ff ff 00 00 	cmpl   $0xffff,-0x4(%ebp)
801097cb:	76 0c                	jbe    801097d9 <ipv4_chksum+0x6e>
801097cd:	8b 45 fc             	mov    -0x4(%ebp),%eax
801097d0:	0f b7 c0             	movzwl %ax,%eax
801097d3:	83 c0 01             	add    $0x1,%eax
801097d6:	89 45 fc             	mov    %eax,-0x4(%ebp)
801097d9:	83 45 f8 01          	addl   $0x1,-0x8(%ebp)
801097dd:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
801097e1:	39 45 f8             	cmp    %eax,-0x8(%ebp)
801097e4:	7c af                	jl     80109795 <ipv4_chksum+0x2a>
801097e6:	8b 45 fc             	mov    -0x4(%ebp),%eax
801097e9:	f7 d0                	not    %eax
801097eb:	c9                   	leave  
801097ec:	c3                   	ret    

801097ed <icmp_proc>:
801097ed:	55                   	push   %ebp
801097ee:	89 e5                	mov    %esp,%ebp
801097f0:	83 ec 18             	sub    $0x18,%esp
801097f3:	8b 45 08             	mov    0x8(%ebp),%eax
801097f6:	83 c0 0e             	add    $0xe,%eax
801097f9:	89 45 f4             	mov    %eax,-0xc(%ebp)
801097fc:	8b 45 f4             	mov    -0xc(%ebp),%eax
801097ff:	0f b6 00             	movzbl (%eax),%eax
80109802:	0f b6 c0             	movzbl %al,%eax
80109805:	83 e0 0f             	and    $0xf,%eax
80109808:	c1 e0 02             	shl    $0x2,%eax
8010980b:	89 c2                	mov    %eax,%edx
8010980d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80109810:	01 d0                	add    %edx,%eax
80109812:	89 45 f0             	mov    %eax,-0x10(%ebp)
80109815:	8b 45 f0             	mov    -0x10(%ebp),%eax
80109818:	0f b6 40 01          	movzbl 0x1(%eax),%eax
8010981c:	84 c0                	test   %al,%al
8010981e:	75 4f                	jne    8010986f <icmp_proc+0x82>
80109820:	8b 45 f0             	mov    -0x10(%ebp),%eax
80109823:	0f b6 00             	movzbl (%eax),%eax
80109826:	3c 08                	cmp    $0x8,%al
80109828:	75 45                	jne    8010986f <icmp_proc+0x82>
8010982a:	e8 71 8f ff ff       	call   801027a0 <kalloc>
8010982f:	89 45 ec             	mov    %eax,-0x14(%ebp)
80109832:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
80109839:	83 ec 04             	sub    $0x4,%esp
8010983c:	8d 45 e8             	lea    -0x18(%ebp),%eax
8010983f:	50                   	push   %eax
80109840:	ff 75 ec             	push   -0x14(%ebp)
80109843:	ff 75 08             	push   0x8(%ebp)
80109846:	e8 78 00 00 00       	call   801098c3 <icmp_reply_pkt_create>
8010984b:	83 c4 10             	add    $0x10,%esp
8010984e:	8b 45 e8             	mov    -0x18(%ebp),%eax
80109851:	83 ec 08             	sub    $0x8,%esp
80109854:	50                   	push   %eax
80109855:	ff 75 ec             	push   -0x14(%ebp)
80109858:	e8 95 f4 ff ff       	call   80108cf2 <i8254_send>
8010985d:	83 c4 10             	add    $0x10,%esp
80109860:	8b 45 ec             	mov    -0x14(%ebp),%eax
80109863:	83 ec 0c             	sub    $0xc,%esp
80109866:	50                   	push   %eax
80109867:	e8 9a 8e ff ff       	call   80102706 <kfree>
8010986c:	83 c4 10             	add    $0x10,%esp
8010986f:	90                   	nop
80109870:	c9                   	leave  
80109871:	c3                   	ret    

80109872 <icmp_proc_req>:
80109872:	55                   	push   %ebp
80109873:	89 e5                	mov    %esp,%ebp
80109875:	53                   	push   %ebx
80109876:	83 ec 04             	sub    $0x4,%esp
80109879:	8b 45 08             	mov    0x8(%ebp),%eax
8010987c:	0f b7 40 06          	movzwl 0x6(%eax),%eax
80109880:	0f b7 c0             	movzwl %ax,%eax
80109883:	83 ec 0c             	sub    $0xc,%esp
80109886:	50                   	push   %eax
80109887:	e8 bd fd ff ff       	call   80109649 <N2H_ushort>
8010988c:	83 c4 10             	add    $0x10,%esp
8010988f:	0f b7 d8             	movzwl %ax,%ebx
80109892:	8b 45 08             	mov    0x8(%ebp),%eax
80109895:	0f b7 40 04          	movzwl 0x4(%eax),%eax
80109899:	0f b7 c0             	movzwl %ax,%eax
8010989c:	83 ec 0c             	sub    $0xc,%esp
8010989f:	50                   	push   %eax
801098a0:	e8 a4 fd ff ff       	call   80109649 <N2H_ushort>
801098a5:	83 c4 10             	add    $0x10,%esp
801098a8:	0f b7 c0             	movzwl %ax,%eax
801098ab:	83 ec 04             	sub    $0x4,%esp
801098ae:	53                   	push   %ebx
801098af:	50                   	push   %eax
801098b0:	68 a3 c1 10 80       	push   $0x8010c1a3
801098b5:	e8 3a 6b ff ff       	call   801003f4 <cprintf>
801098ba:	83 c4 10             	add    $0x10,%esp
801098bd:	90                   	nop
801098be:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801098c1:	c9                   	leave  
801098c2:	c3                   	ret    

801098c3 <icmp_reply_pkt_create>:
801098c3:	55                   	push   %ebp
801098c4:	89 e5                	mov    %esp,%ebp
801098c6:	83 ec 28             	sub    $0x28,%esp
801098c9:	8b 45 08             	mov    0x8(%ebp),%eax
801098cc:	89 45 f4             	mov    %eax,-0xc(%ebp)
801098cf:	8b 45 08             	mov    0x8(%ebp),%eax
801098d2:	83 c0 0e             	add    $0xe,%eax
801098d5:	89 45 f0             	mov    %eax,-0x10(%ebp)
801098d8:	8b 45 f0             	mov    -0x10(%ebp),%eax
801098db:	0f b6 00             	movzbl (%eax),%eax
801098de:	0f b6 c0             	movzbl %al,%eax
801098e1:	83 e0 0f             	and    $0xf,%eax
801098e4:	c1 e0 02             	shl    $0x2,%eax
801098e7:	89 c2                	mov    %eax,%edx
801098e9:	8b 45 f0             	mov    -0x10(%ebp),%eax
801098ec:	01 d0                	add    %edx,%eax
801098ee:	89 45 ec             	mov    %eax,-0x14(%ebp)
801098f1:	8b 45 0c             	mov    0xc(%ebp),%eax
801098f4:	89 45 e8             	mov    %eax,-0x18(%ebp)
801098f7:	8b 45 0c             	mov    0xc(%ebp),%eax
801098fa:	83 c0 0e             	add    $0xe,%eax
801098fd:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80109900:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80109903:	83 c0 14             	add    $0x14,%eax
80109906:	89 45 e0             	mov    %eax,-0x20(%ebp)
80109909:	8b 45 10             	mov    0x10(%ebp),%eax
8010990c:	c7 00 62 00 00 00    	movl   $0x62,(%eax)
80109912:	8b 45 f4             	mov    -0xc(%ebp),%eax
80109915:	8d 50 06             	lea    0x6(%eax),%edx
80109918:	8b 45 e8             	mov    -0x18(%ebp),%eax
8010991b:	83 ec 04             	sub    $0x4,%esp
8010991e:	6a 06                	push   $0x6
80109920:	52                   	push   %edx
80109921:	50                   	push   %eax
80109922:	e8 76 b3 ff ff       	call   80104c9d <memmove>
80109927:	83 c4 10             	add    $0x10,%esp
8010992a:	8b 45 e8             	mov    -0x18(%ebp),%eax
8010992d:	83 c0 06             	add    $0x6,%eax
80109930:	83 ec 04             	sub    $0x4,%esp
80109933:	6a 06                	push   $0x6
80109935:	68 80 6d 19 80       	push   $0x80196d80
8010993a:	50                   	push   %eax
8010993b:	e8 5d b3 ff ff       	call   80104c9d <memmove>
80109940:	83 c4 10             	add    $0x10,%esp
80109943:	8b 45 e8             	mov    -0x18(%ebp),%eax
80109946:	c6 40 0c 08          	movb   $0x8,0xc(%eax)
8010994a:	8b 45 e8             	mov    -0x18(%ebp),%eax
8010994d:	c6 40 0d 00          	movb   $0x0,0xd(%eax)
80109951:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80109954:	c6 00 45             	movb   $0x45,(%eax)
80109957:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010995a:	c6 40 01 00          	movb   $0x0,0x1(%eax)
8010995e:	83 ec 0c             	sub    $0xc,%esp
80109961:	6a 54                	push   $0x54
80109963:	e8 03 fd ff ff       	call   8010966b <H2N_ushort>
80109968:	83 c4 10             	add    $0x10,%esp
8010996b:	8b 55 e4             	mov    -0x1c(%ebp),%edx
8010996e:	66 89 42 02          	mov    %ax,0x2(%edx)
80109972:	0f b7 15 60 70 19 80 	movzwl 0x80197060,%edx
80109979:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010997c:	66 89 50 04          	mov    %dx,0x4(%eax)
80109980:	0f b7 05 60 70 19 80 	movzwl 0x80197060,%eax
80109987:	83 c0 01             	add    $0x1,%eax
8010998a:	66 a3 60 70 19 80    	mov    %ax,0x80197060
80109990:	83 ec 0c             	sub    $0xc,%esp
80109993:	68 00 40 00 00       	push   $0x4000
80109998:	e8 ce fc ff ff       	call   8010966b <H2N_ushort>
8010999d:	83 c4 10             	add    $0x10,%esp
801099a0:	8b 55 e4             	mov    -0x1c(%ebp),%edx
801099a3:	66 89 42 06          	mov    %ax,0x6(%edx)
801099a7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801099aa:	c6 40 08 ff          	movb   $0xff,0x8(%eax)
801099ae:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801099b1:	c6 40 09 01          	movb   $0x1,0x9(%eax)
801099b5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801099b8:	83 c0 0c             	add    $0xc,%eax
801099bb:	83 ec 04             	sub    $0x4,%esp
801099be:	6a 04                	push   $0x4
801099c0:	68 e4 f4 10 80       	push   $0x8010f4e4
801099c5:	50                   	push   %eax
801099c6:	e8 d2 b2 ff ff       	call   80104c9d <memmove>
801099cb:	83 c4 10             	add    $0x10,%esp
801099ce:	8b 45 f0             	mov    -0x10(%ebp),%eax
801099d1:	8d 50 0c             	lea    0xc(%eax),%edx
801099d4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801099d7:	83 c0 10             	add    $0x10,%eax
801099da:	83 ec 04             	sub    $0x4,%esp
801099dd:	6a 04                	push   $0x4
801099df:	52                   	push   %edx
801099e0:	50                   	push   %eax
801099e1:	e8 b7 b2 ff ff       	call   80104c9d <memmove>
801099e6:	83 c4 10             	add    $0x10,%esp
801099e9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801099ec:	66 c7 40 0a 00 00    	movw   $0x0,0xa(%eax)
801099f2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801099f5:	83 ec 0c             	sub    $0xc,%esp
801099f8:	50                   	push   %eax
801099f9:	e8 6d fd ff ff       	call   8010976b <ipv4_chksum>
801099fe:	83 c4 10             	add    $0x10,%esp
80109a01:	0f b7 c0             	movzwl %ax,%eax
80109a04:	83 ec 0c             	sub    $0xc,%esp
80109a07:	50                   	push   %eax
80109a08:	e8 5e fc ff ff       	call   8010966b <H2N_ushort>
80109a0d:	83 c4 10             	add    $0x10,%esp
80109a10:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80109a13:	66 89 42 0a          	mov    %ax,0xa(%edx)
80109a17:	8b 45 e0             	mov    -0x20(%ebp),%eax
80109a1a:	c6 00 00             	movb   $0x0,(%eax)
80109a1d:	8b 45 e0             	mov    -0x20(%ebp),%eax
80109a20:	c6 40 01 00          	movb   $0x0,0x1(%eax)
80109a24:	8b 45 ec             	mov    -0x14(%ebp),%eax
80109a27:	0f b7 50 04          	movzwl 0x4(%eax),%edx
80109a2b:	8b 45 e0             	mov    -0x20(%ebp),%eax
80109a2e:	66 89 50 04          	mov    %dx,0x4(%eax)
80109a32:	8b 45 ec             	mov    -0x14(%ebp),%eax
80109a35:	0f b7 50 06          	movzwl 0x6(%eax),%edx
80109a39:	8b 45 e0             	mov    -0x20(%ebp),%eax
80109a3c:	66 89 50 06          	mov    %dx,0x6(%eax)
80109a40:	8b 45 ec             	mov    -0x14(%ebp),%eax
80109a43:	8d 50 08             	lea    0x8(%eax),%edx
80109a46:	8b 45 e0             	mov    -0x20(%ebp),%eax
80109a49:	83 c0 08             	add    $0x8,%eax
80109a4c:	83 ec 04             	sub    $0x4,%esp
80109a4f:	6a 08                	push   $0x8
80109a51:	52                   	push   %edx
80109a52:	50                   	push   %eax
80109a53:	e8 45 b2 ff ff       	call   80104c9d <memmove>
80109a58:	83 c4 10             	add    $0x10,%esp
80109a5b:	8b 45 ec             	mov    -0x14(%ebp),%eax
80109a5e:	8d 50 10             	lea    0x10(%eax),%edx
80109a61:	8b 45 e0             	mov    -0x20(%ebp),%eax
80109a64:	83 c0 10             	add    $0x10,%eax
80109a67:	83 ec 04             	sub    $0x4,%esp
80109a6a:	6a 30                	push   $0x30
80109a6c:	52                   	push   %edx
80109a6d:	50                   	push   %eax
80109a6e:	e8 2a b2 ff ff       	call   80104c9d <memmove>
80109a73:	83 c4 10             	add    $0x10,%esp
80109a76:	8b 45 e0             	mov    -0x20(%ebp),%eax
80109a79:	66 c7 40 02 00 00    	movw   $0x0,0x2(%eax)
80109a7f:	8b 45 e0             	mov    -0x20(%ebp),%eax
80109a82:	83 ec 0c             	sub    $0xc,%esp
80109a85:	50                   	push   %eax
80109a86:	e8 1c 00 00 00       	call   80109aa7 <icmp_chksum>
80109a8b:	83 c4 10             	add    $0x10,%esp
80109a8e:	0f b7 c0             	movzwl %ax,%eax
80109a91:	83 ec 0c             	sub    $0xc,%esp
80109a94:	50                   	push   %eax
80109a95:	e8 d1 fb ff ff       	call   8010966b <H2N_ushort>
80109a9a:	83 c4 10             	add    $0x10,%esp
80109a9d:	8b 55 e0             	mov    -0x20(%ebp),%edx
80109aa0:	66 89 42 02          	mov    %ax,0x2(%edx)
80109aa4:	90                   	nop
80109aa5:	c9                   	leave  
80109aa6:	c3                   	ret    

80109aa7 <icmp_chksum>:
80109aa7:	55                   	push   %ebp
80109aa8:	89 e5                	mov    %esp,%ebp
80109aaa:	83 ec 10             	sub    $0x10,%esp
80109aad:	8b 45 08             	mov    0x8(%ebp),%eax
80109ab0:	89 45 f4             	mov    %eax,-0xc(%ebp)
80109ab3:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
80109aba:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
80109ac1:	eb 48                	jmp    80109b0b <icmp_chksum+0x64>
80109ac3:	8b 45 f8             	mov    -0x8(%ebp),%eax
80109ac6:	01 c0                	add    %eax,%eax
80109ac8:	89 c2                	mov    %eax,%edx
80109aca:	8b 45 f4             	mov    -0xc(%ebp),%eax
80109acd:	01 d0                	add    %edx,%eax
80109acf:	0f b6 00             	movzbl (%eax),%eax
80109ad2:	0f b6 c0             	movzbl %al,%eax
80109ad5:	c1 e0 08             	shl    $0x8,%eax
80109ad8:	89 c2                	mov    %eax,%edx
80109ada:	8b 45 f8             	mov    -0x8(%ebp),%eax
80109add:	01 c0                	add    %eax,%eax
80109adf:	8d 48 01             	lea    0x1(%eax),%ecx
80109ae2:	8b 45 f4             	mov    -0xc(%ebp),%eax
80109ae5:	01 c8                	add    %ecx,%eax
80109ae7:	0f b6 00             	movzbl (%eax),%eax
80109aea:	0f b6 c0             	movzbl %al,%eax
80109aed:	01 d0                	add    %edx,%eax
80109aef:	01 45 fc             	add    %eax,-0x4(%ebp)
80109af2:	81 7d fc ff ff 00 00 	cmpl   $0xffff,-0x4(%ebp)
80109af9:	76 0c                	jbe    80109b07 <icmp_chksum+0x60>
80109afb:	8b 45 fc             	mov    -0x4(%ebp),%eax
80109afe:	0f b7 c0             	movzwl %ax,%eax
80109b01:	83 c0 01             	add    $0x1,%eax
80109b04:	89 45 fc             	mov    %eax,-0x4(%ebp)
80109b07:	83 45 f8 01          	addl   $0x1,-0x8(%ebp)
80109b0b:	83 7d f8 1f          	cmpl   $0x1f,-0x8(%ebp)
80109b0f:	7e b2                	jle    80109ac3 <icmp_chksum+0x1c>
80109b11:	8b 45 fc             	mov    -0x4(%ebp),%eax
80109b14:	f7 d0                	not    %eax
80109b16:	c9                   	leave  
80109b17:	c3                   	ret    

80109b18 <tcp_proc>:
80109b18:	55                   	push   %ebp
80109b19:	89 e5                	mov    %esp,%ebp
80109b1b:	83 ec 38             	sub    $0x38,%esp
80109b1e:	8b 45 08             	mov    0x8(%ebp),%eax
80109b21:	83 c0 0e             	add    $0xe,%eax
80109b24:	89 45 f4             	mov    %eax,-0xc(%ebp)
80109b27:	8b 45 f4             	mov    -0xc(%ebp),%eax
80109b2a:	0f b6 00             	movzbl (%eax),%eax
80109b2d:	0f b6 c0             	movzbl %al,%eax
80109b30:	83 e0 0f             	and    $0xf,%eax
80109b33:	c1 e0 02             	shl    $0x2,%eax
80109b36:	89 c2                	mov    %eax,%edx
80109b38:	8b 45 f4             	mov    -0xc(%ebp),%eax
80109b3b:	01 d0                	add    %edx,%eax
80109b3d:	89 45 f0             	mov    %eax,-0x10(%ebp)
80109b40:	8b 45 f0             	mov    -0x10(%ebp),%eax
80109b43:	83 c0 14             	add    $0x14,%eax
80109b46:	89 45 ec             	mov    %eax,-0x14(%ebp)
80109b49:	e8 52 8c ff ff       	call   801027a0 <kalloc>
80109b4e:	89 45 e8             	mov    %eax,-0x18(%ebp)
80109b51:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
80109b58:	8b 45 f0             	mov    -0x10(%ebp),%eax
80109b5b:	0f b6 40 0d          	movzbl 0xd(%eax),%eax
80109b5f:	0f b6 c0             	movzbl %al,%eax
80109b62:	83 e0 02             	and    $0x2,%eax
80109b65:	85 c0                	test   %eax,%eax
80109b67:	74 3d                	je     80109ba6 <tcp_proc+0x8e>
80109b69:	83 ec 0c             	sub    $0xc,%esp
80109b6c:	6a 00                	push   $0x0
80109b6e:	6a 12                	push   $0x12
80109b70:	8d 45 dc             	lea    -0x24(%ebp),%eax
80109b73:	50                   	push   %eax
80109b74:	ff 75 e8             	push   -0x18(%ebp)
80109b77:	ff 75 08             	push   0x8(%ebp)
80109b7a:	e8 a2 01 00 00       	call   80109d21 <tcp_pkt_create>
80109b7f:	83 c4 20             	add    $0x20,%esp
80109b82:	8b 45 dc             	mov    -0x24(%ebp),%eax
80109b85:	83 ec 08             	sub    $0x8,%esp
80109b88:	50                   	push   %eax
80109b89:	ff 75 e8             	push   -0x18(%ebp)
80109b8c:	e8 61 f1 ff ff       	call   80108cf2 <i8254_send>
80109b91:	83 c4 10             	add    $0x10,%esp
80109b94:	a1 64 70 19 80       	mov    0x80197064,%eax
80109b99:	83 c0 01             	add    $0x1,%eax
80109b9c:	a3 64 70 19 80       	mov    %eax,0x80197064
80109ba1:	e9 69 01 00 00       	jmp    80109d0f <tcp_proc+0x1f7>
80109ba6:	8b 45 f0             	mov    -0x10(%ebp),%eax
80109ba9:	0f b6 40 0d          	movzbl 0xd(%eax),%eax
80109bad:	3c 18                	cmp    $0x18,%al
80109baf:	0f 85 10 01 00 00    	jne    80109cc5 <tcp_proc+0x1ad>
80109bb5:	83 ec 04             	sub    $0x4,%esp
80109bb8:	6a 03                	push   $0x3
80109bba:	68 be c1 10 80       	push   $0x8010c1be
80109bbf:	ff 75 ec             	push   -0x14(%ebp)
80109bc2:	e8 7e b0 ff ff       	call   80104c45 <memcmp>
80109bc7:	83 c4 10             	add    $0x10,%esp
80109bca:	85 c0                	test   %eax,%eax
80109bcc:	74 74                	je     80109c42 <tcp_proc+0x12a>
80109bce:	83 ec 0c             	sub    $0xc,%esp
80109bd1:	68 c2 c1 10 80       	push   $0x8010c1c2
80109bd6:	e8 19 68 ff ff       	call   801003f4 <cprintf>
80109bdb:	83 c4 10             	add    $0x10,%esp
80109bde:	83 ec 0c             	sub    $0xc,%esp
80109be1:	6a 00                	push   $0x0
80109be3:	6a 10                	push   $0x10
80109be5:	8d 45 dc             	lea    -0x24(%ebp),%eax
80109be8:	50                   	push   %eax
80109be9:	ff 75 e8             	push   -0x18(%ebp)
80109bec:	ff 75 08             	push   0x8(%ebp)
80109bef:	e8 2d 01 00 00       	call   80109d21 <tcp_pkt_create>
80109bf4:	83 c4 20             	add    $0x20,%esp
80109bf7:	8b 45 dc             	mov    -0x24(%ebp),%eax
80109bfa:	83 ec 08             	sub    $0x8,%esp
80109bfd:	50                   	push   %eax
80109bfe:	ff 75 e8             	push   -0x18(%ebp)
80109c01:	e8 ec f0 ff ff       	call   80108cf2 <i8254_send>
80109c06:	83 c4 10             	add    $0x10,%esp
80109c09:	8b 45 e8             	mov    -0x18(%ebp),%eax
80109c0c:	83 c0 36             	add    $0x36,%eax
80109c0f:	89 45 e0             	mov    %eax,-0x20(%ebp)
80109c12:	8d 45 d8             	lea    -0x28(%ebp),%eax
80109c15:	50                   	push   %eax
80109c16:	ff 75 e0             	push   -0x20(%ebp)
80109c19:	6a 00                	push   $0x0
80109c1b:	6a 00                	push   $0x0
80109c1d:	e8 5a 04 00 00       	call   8010a07c <http_proc>
80109c22:	83 c4 10             	add    $0x10,%esp
80109c25:	8b 45 d8             	mov    -0x28(%ebp),%eax
80109c28:	83 ec 0c             	sub    $0xc,%esp
80109c2b:	50                   	push   %eax
80109c2c:	6a 18                	push   $0x18
80109c2e:	8d 45 dc             	lea    -0x24(%ebp),%eax
80109c31:	50                   	push   %eax
80109c32:	ff 75 e8             	push   -0x18(%ebp)
80109c35:	ff 75 08             	push   0x8(%ebp)
80109c38:	e8 e4 00 00 00       	call   80109d21 <tcp_pkt_create>
80109c3d:	83 c4 20             	add    $0x20,%esp
80109c40:	eb 62                	jmp    80109ca4 <tcp_proc+0x18c>
80109c42:	83 ec 0c             	sub    $0xc,%esp
80109c45:	6a 00                	push   $0x0
80109c47:	6a 10                	push   $0x10
80109c49:	8d 45 dc             	lea    -0x24(%ebp),%eax
80109c4c:	50                   	push   %eax
80109c4d:	ff 75 e8             	push   -0x18(%ebp)
80109c50:	ff 75 08             	push   0x8(%ebp)
80109c53:	e8 c9 00 00 00       	call   80109d21 <tcp_pkt_create>
80109c58:	83 c4 20             	add    $0x20,%esp
80109c5b:	8b 45 dc             	mov    -0x24(%ebp),%eax
80109c5e:	83 ec 08             	sub    $0x8,%esp
80109c61:	50                   	push   %eax
80109c62:	ff 75 e8             	push   -0x18(%ebp)
80109c65:	e8 88 f0 ff ff       	call   80108cf2 <i8254_send>
80109c6a:	83 c4 10             	add    $0x10,%esp
80109c6d:	8b 45 e8             	mov    -0x18(%ebp),%eax
80109c70:	83 c0 36             	add    $0x36,%eax
80109c73:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80109c76:	8d 45 d4             	lea    -0x2c(%ebp),%eax
80109c79:	50                   	push   %eax
80109c7a:	ff 75 e4             	push   -0x1c(%ebp)
80109c7d:	6a 00                	push   $0x0
80109c7f:	6a 00                	push   $0x0
80109c81:	e8 f6 03 00 00       	call   8010a07c <http_proc>
80109c86:	83 c4 10             	add    $0x10,%esp
80109c89:	8b 45 d4             	mov    -0x2c(%ebp),%eax
80109c8c:	83 ec 0c             	sub    $0xc,%esp
80109c8f:	50                   	push   %eax
80109c90:	6a 18                	push   $0x18
80109c92:	8d 45 dc             	lea    -0x24(%ebp),%eax
80109c95:	50                   	push   %eax
80109c96:	ff 75 e8             	push   -0x18(%ebp)
80109c99:	ff 75 08             	push   0x8(%ebp)
80109c9c:	e8 80 00 00 00       	call   80109d21 <tcp_pkt_create>
80109ca1:	83 c4 20             	add    $0x20,%esp
80109ca4:	8b 45 dc             	mov    -0x24(%ebp),%eax
80109ca7:	83 ec 08             	sub    $0x8,%esp
80109caa:	50                   	push   %eax
80109cab:	ff 75 e8             	push   -0x18(%ebp)
80109cae:	e8 3f f0 ff ff       	call   80108cf2 <i8254_send>
80109cb3:	83 c4 10             	add    $0x10,%esp
80109cb6:	a1 64 70 19 80       	mov    0x80197064,%eax
80109cbb:	83 c0 01             	add    $0x1,%eax
80109cbe:	a3 64 70 19 80       	mov    %eax,0x80197064
80109cc3:	eb 4a                	jmp    80109d0f <tcp_proc+0x1f7>
80109cc5:	8b 45 f0             	mov    -0x10(%ebp),%eax
80109cc8:	0f b6 40 0d          	movzbl 0xd(%eax),%eax
80109ccc:	3c 10                	cmp    $0x10,%al
80109cce:	75 3f                	jne    80109d0f <tcp_proc+0x1f7>
80109cd0:	a1 68 70 19 80       	mov    0x80197068,%eax
80109cd5:	83 f8 01             	cmp    $0x1,%eax
80109cd8:	75 35                	jne    80109d0f <tcp_proc+0x1f7>
80109cda:	83 ec 0c             	sub    $0xc,%esp
80109cdd:	6a 00                	push   $0x0
80109cdf:	6a 01                	push   $0x1
80109ce1:	8d 45 dc             	lea    -0x24(%ebp),%eax
80109ce4:	50                   	push   %eax
80109ce5:	ff 75 e8             	push   -0x18(%ebp)
80109ce8:	ff 75 08             	push   0x8(%ebp)
80109ceb:	e8 31 00 00 00       	call   80109d21 <tcp_pkt_create>
80109cf0:	83 c4 20             	add    $0x20,%esp
80109cf3:	8b 45 dc             	mov    -0x24(%ebp),%eax
80109cf6:	83 ec 08             	sub    $0x8,%esp
80109cf9:	50                   	push   %eax
80109cfa:	ff 75 e8             	push   -0x18(%ebp)
80109cfd:	e8 f0 ef ff ff       	call   80108cf2 <i8254_send>
80109d02:	83 c4 10             	add    $0x10,%esp
80109d05:	c7 05 68 70 19 80 00 	movl   $0x0,0x80197068
80109d0c:	00 00 00 
80109d0f:	8b 45 e8             	mov    -0x18(%ebp),%eax
80109d12:	83 ec 0c             	sub    $0xc,%esp
80109d15:	50                   	push   %eax
80109d16:	e8 eb 89 ff ff       	call   80102706 <kfree>
80109d1b:	83 c4 10             	add    $0x10,%esp
80109d1e:	90                   	nop
80109d1f:	c9                   	leave  
80109d20:	c3                   	ret    

80109d21 <tcp_pkt_create>:
80109d21:	55                   	push   %ebp
80109d22:	89 e5                	mov    %esp,%ebp
80109d24:	83 ec 28             	sub    $0x28,%esp
80109d27:	8b 45 08             	mov    0x8(%ebp),%eax
80109d2a:	89 45 f4             	mov    %eax,-0xc(%ebp)
80109d2d:	8b 45 08             	mov    0x8(%ebp),%eax
80109d30:	83 c0 0e             	add    $0xe,%eax
80109d33:	89 45 f0             	mov    %eax,-0x10(%ebp)
80109d36:	8b 45 f0             	mov    -0x10(%ebp),%eax
80109d39:	0f b6 00             	movzbl (%eax),%eax
80109d3c:	0f b6 c0             	movzbl %al,%eax
80109d3f:	83 e0 0f             	and    $0xf,%eax
80109d42:	c1 e0 02             	shl    $0x2,%eax
80109d45:	89 c2                	mov    %eax,%edx
80109d47:	8b 45 f0             	mov    -0x10(%ebp),%eax
80109d4a:	01 d0                	add    %edx,%eax
80109d4c:	89 45 ec             	mov    %eax,-0x14(%ebp)
80109d4f:	8b 45 0c             	mov    0xc(%ebp),%eax
80109d52:	89 45 e8             	mov    %eax,-0x18(%ebp)
80109d55:	8b 45 0c             	mov    0xc(%ebp),%eax
80109d58:	83 c0 0e             	add    $0xe,%eax
80109d5b:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80109d5e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80109d61:	83 c0 14             	add    $0x14,%eax
80109d64:	89 45 e0             	mov    %eax,-0x20(%ebp)
80109d67:	8b 45 18             	mov    0x18(%ebp),%eax
80109d6a:	8d 50 36             	lea    0x36(%eax),%edx
80109d6d:	8b 45 10             	mov    0x10(%ebp),%eax
80109d70:	89 10                	mov    %edx,(%eax)
80109d72:	8b 45 f4             	mov    -0xc(%ebp),%eax
80109d75:	8d 50 06             	lea    0x6(%eax),%edx
80109d78:	8b 45 e8             	mov    -0x18(%ebp),%eax
80109d7b:	83 ec 04             	sub    $0x4,%esp
80109d7e:	6a 06                	push   $0x6
80109d80:	52                   	push   %edx
80109d81:	50                   	push   %eax
80109d82:	e8 16 af ff ff       	call   80104c9d <memmove>
80109d87:	83 c4 10             	add    $0x10,%esp
80109d8a:	8b 45 e8             	mov    -0x18(%ebp),%eax
80109d8d:	83 c0 06             	add    $0x6,%eax
80109d90:	83 ec 04             	sub    $0x4,%esp
80109d93:	6a 06                	push   $0x6
80109d95:	68 80 6d 19 80       	push   $0x80196d80
80109d9a:	50                   	push   %eax
80109d9b:	e8 fd ae ff ff       	call   80104c9d <memmove>
80109da0:	83 c4 10             	add    $0x10,%esp
80109da3:	8b 45 e8             	mov    -0x18(%ebp),%eax
80109da6:	c6 40 0c 08          	movb   $0x8,0xc(%eax)
80109daa:	8b 45 e8             	mov    -0x18(%ebp),%eax
80109dad:	c6 40 0d 00          	movb   $0x0,0xd(%eax)
80109db1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80109db4:	c6 00 45             	movb   $0x45,(%eax)
80109db7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80109dba:	c6 40 01 00          	movb   $0x0,0x1(%eax)
80109dbe:	8b 45 18             	mov    0x18(%ebp),%eax
80109dc1:	83 c0 28             	add    $0x28,%eax
80109dc4:	0f b7 c0             	movzwl %ax,%eax
80109dc7:	83 ec 0c             	sub    $0xc,%esp
80109dca:	50                   	push   %eax
80109dcb:	e8 9b f8 ff ff       	call   8010966b <H2N_ushort>
80109dd0:	83 c4 10             	add    $0x10,%esp
80109dd3:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80109dd6:	66 89 42 02          	mov    %ax,0x2(%edx)
80109dda:	0f b7 15 60 70 19 80 	movzwl 0x80197060,%edx
80109de1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80109de4:	66 89 50 04          	mov    %dx,0x4(%eax)
80109de8:	0f b7 05 60 70 19 80 	movzwl 0x80197060,%eax
80109def:	83 c0 01             	add    $0x1,%eax
80109df2:	66 a3 60 70 19 80    	mov    %ax,0x80197060
80109df8:	83 ec 0c             	sub    $0xc,%esp
80109dfb:	6a 00                	push   $0x0
80109dfd:	e8 69 f8 ff ff       	call   8010966b <H2N_ushort>
80109e02:	83 c4 10             	add    $0x10,%esp
80109e05:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80109e08:	66 89 42 06          	mov    %ax,0x6(%edx)
80109e0c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80109e0f:	c6 40 08 ff          	movb   $0xff,0x8(%eax)
80109e13:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80109e16:	c6 40 09 06          	movb   $0x6,0x9(%eax)
80109e1a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80109e1d:	83 c0 0c             	add    $0xc,%eax
80109e20:	83 ec 04             	sub    $0x4,%esp
80109e23:	6a 04                	push   $0x4
80109e25:	68 e4 f4 10 80       	push   $0x8010f4e4
80109e2a:	50                   	push   %eax
80109e2b:	e8 6d ae ff ff       	call   80104c9d <memmove>
80109e30:	83 c4 10             	add    $0x10,%esp
80109e33:	8b 45 f0             	mov    -0x10(%ebp),%eax
80109e36:	8d 50 0c             	lea    0xc(%eax),%edx
80109e39:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80109e3c:	83 c0 10             	add    $0x10,%eax
80109e3f:	83 ec 04             	sub    $0x4,%esp
80109e42:	6a 04                	push   $0x4
80109e44:	52                   	push   %edx
80109e45:	50                   	push   %eax
80109e46:	e8 52 ae ff ff       	call   80104c9d <memmove>
80109e4b:	83 c4 10             	add    $0x10,%esp
80109e4e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80109e51:	66 c7 40 0a 00 00    	movw   $0x0,0xa(%eax)
80109e57:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80109e5a:	83 ec 0c             	sub    $0xc,%esp
80109e5d:	50                   	push   %eax
80109e5e:	e8 08 f9 ff ff       	call   8010976b <ipv4_chksum>
80109e63:	83 c4 10             	add    $0x10,%esp
80109e66:	0f b7 c0             	movzwl %ax,%eax
80109e69:	83 ec 0c             	sub    $0xc,%esp
80109e6c:	50                   	push   %eax
80109e6d:	e8 f9 f7 ff ff       	call   8010966b <H2N_ushort>
80109e72:	83 c4 10             	add    $0x10,%esp
80109e75:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80109e78:	66 89 42 0a          	mov    %ax,0xa(%edx)
80109e7c:	8b 45 ec             	mov    -0x14(%ebp),%eax
80109e7f:	0f b7 50 02          	movzwl 0x2(%eax),%edx
80109e83:	8b 45 e0             	mov    -0x20(%ebp),%eax
80109e86:	66 89 10             	mov    %dx,(%eax)
80109e89:	8b 45 ec             	mov    -0x14(%ebp),%eax
80109e8c:	0f b7 10             	movzwl (%eax),%edx
80109e8f:	8b 45 e0             	mov    -0x20(%ebp),%eax
80109e92:	66 89 50 02          	mov    %dx,0x2(%eax)
80109e96:	a1 64 70 19 80       	mov    0x80197064,%eax
80109e9b:	83 ec 0c             	sub    $0xc,%esp
80109e9e:	50                   	push   %eax
80109e9f:	e8 e9 f7 ff ff       	call   8010968d <H2N_uint>
80109ea4:	83 c4 10             	add    $0x10,%esp
80109ea7:	8b 55 e0             	mov    -0x20(%ebp),%edx
80109eaa:	89 42 04             	mov    %eax,0x4(%edx)
80109ead:	8b 45 ec             	mov    -0x14(%ebp),%eax
80109eb0:	8b 40 04             	mov    0x4(%eax),%eax
80109eb3:	8d 90 00 00 00 01    	lea    0x1000000(%eax),%edx
80109eb9:	8b 45 e0             	mov    -0x20(%ebp),%eax
80109ebc:	89 50 08             	mov    %edx,0x8(%eax)
80109ebf:	8b 45 e0             	mov    -0x20(%ebp),%eax
80109ec2:	c6 40 0c 00          	movb   $0x0,0xc(%eax)
80109ec6:	8b 45 e0             	mov    -0x20(%ebp),%eax
80109ec9:	c6 40 0d 00          	movb   $0x0,0xd(%eax)
80109ecd:	8b 45 e0             	mov    -0x20(%ebp),%eax
80109ed0:	c6 40 0c 50          	movb   $0x50,0xc(%eax)
80109ed4:	8b 45 14             	mov    0x14(%ebp),%eax
80109ed7:	89 c2                	mov    %eax,%edx
80109ed9:	8b 45 e0             	mov    -0x20(%ebp),%eax
80109edc:	88 50 0d             	mov    %dl,0xd(%eax)
80109edf:	83 ec 0c             	sub    $0xc,%esp
80109ee2:	68 90 38 00 00       	push   $0x3890
80109ee7:	e8 7f f7 ff ff       	call   8010966b <H2N_ushort>
80109eec:	83 c4 10             	add    $0x10,%esp
80109eef:	8b 55 e0             	mov    -0x20(%ebp),%edx
80109ef2:	66 89 42 0e          	mov    %ax,0xe(%edx)
80109ef6:	8b 45 e0             	mov    -0x20(%ebp),%eax
80109ef9:	66 c7 40 12 00 00    	movw   $0x0,0x12(%eax)
80109eff:	8b 45 e0             	mov    -0x20(%ebp),%eax
80109f02:	66 c7 40 10 00 00    	movw   $0x0,0x10(%eax)
80109f08:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80109f0b:	83 ec 0c             	sub    $0xc,%esp
80109f0e:	50                   	push   %eax
80109f0f:	e8 1f 00 00 00       	call   80109f33 <tcp_chksum>
80109f14:	83 c4 10             	add    $0x10,%esp
80109f17:	83 c0 08             	add    $0x8,%eax
80109f1a:	0f b7 c0             	movzwl %ax,%eax
80109f1d:	83 ec 0c             	sub    $0xc,%esp
80109f20:	50                   	push   %eax
80109f21:	e8 45 f7 ff ff       	call   8010966b <H2N_ushort>
80109f26:	83 c4 10             	add    $0x10,%esp
80109f29:	8b 55 e0             	mov    -0x20(%ebp),%edx
80109f2c:	66 89 42 10          	mov    %ax,0x10(%edx)
80109f30:	90                   	nop
80109f31:	c9                   	leave  
80109f32:	c3                   	ret    

80109f33 <tcp_chksum>:
80109f33:	55                   	push   %ebp
80109f34:	89 e5                	mov    %esp,%ebp
80109f36:	83 ec 38             	sub    $0x38,%esp
80109f39:	8b 45 08             	mov    0x8(%ebp),%eax
80109f3c:	89 45 e8             	mov    %eax,-0x18(%ebp)
80109f3f:	8b 45 e8             	mov    -0x18(%ebp),%eax
80109f42:	83 c0 14             	add    $0x14,%eax
80109f45:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80109f48:	83 ec 04             	sub    $0x4,%esp
80109f4b:	6a 04                	push   $0x4
80109f4d:	68 e4 f4 10 80       	push   $0x8010f4e4
80109f52:	8d 45 d4             	lea    -0x2c(%ebp),%eax
80109f55:	50                   	push   %eax
80109f56:	e8 42 ad ff ff       	call   80104c9d <memmove>
80109f5b:	83 c4 10             	add    $0x10,%esp
80109f5e:	8b 45 e8             	mov    -0x18(%ebp),%eax
80109f61:	83 c0 0c             	add    $0xc,%eax
80109f64:	83 ec 04             	sub    $0x4,%esp
80109f67:	6a 04                	push   $0x4
80109f69:	50                   	push   %eax
80109f6a:	8d 45 d4             	lea    -0x2c(%ebp),%eax
80109f6d:	83 c0 04             	add    $0x4,%eax
80109f70:	50                   	push   %eax
80109f71:	e8 27 ad ff ff       	call   80104c9d <memmove>
80109f76:	83 c4 10             	add    $0x10,%esp
80109f79:	c6 45 dc 00          	movb   $0x0,-0x24(%ebp)
80109f7d:	c6 45 dd 06          	movb   $0x6,-0x23(%ebp)
80109f81:	8b 45 e8             	mov    -0x18(%ebp),%eax
80109f84:	0f b7 40 02          	movzwl 0x2(%eax),%eax
80109f88:	0f b7 c0             	movzwl %ax,%eax
80109f8b:	83 ec 0c             	sub    $0xc,%esp
80109f8e:	50                   	push   %eax
80109f8f:	e8 b5 f6 ff ff       	call   80109649 <N2H_ushort>
80109f94:	83 c4 10             	add    $0x10,%esp
80109f97:	83 e8 14             	sub    $0x14,%eax
80109f9a:	0f b7 c0             	movzwl %ax,%eax
80109f9d:	83 ec 0c             	sub    $0xc,%esp
80109fa0:	50                   	push   %eax
80109fa1:	e8 c5 f6 ff ff       	call   8010966b <H2N_ushort>
80109fa6:	83 c4 10             	add    $0x10,%esp
80109fa9:	66 89 45 de          	mov    %ax,-0x22(%ebp)
80109fad:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80109fb4:	8d 45 d4             	lea    -0x2c(%ebp),%eax
80109fb7:	89 45 e0             	mov    %eax,-0x20(%ebp)
80109fba:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
80109fc1:	eb 33                	jmp    80109ff6 <tcp_chksum+0xc3>
80109fc3:	8b 45 f0             	mov    -0x10(%ebp),%eax
80109fc6:	01 c0                	add    %eax,%eax
80109fc8:	89 c2                	mov    %eax,%edx
80109fca:	8b 45 e0             	mov    -0x20(%ebp),%eax
80109fcd:	01 d0                	add    %edx,%eax
80109fcf:	0f b6 00             	movzbl (%eax),%eax
80109fd2:	0f b6 c0             	movzbl %al,%eax
80109fd5:	c1 e0 08             	shl    $0x8,%eax
80109fd8:	89 c2                	mov    %eax,%edx
80109fda:	8b 45 f0             	mov    -0x10(%ebp),%eax
80109fdd:	01 c0                	add    %eax,%eax
80109fdf:	8d 48 01             	lea    0x1(%eax),%ecx
80109fe2:	8b 45 e0             	mov    -0x20(%ebp),%eax
80109fe5:	01 c8                	add    %ecx,%eax
80109fe7:	0f b6 00             	movzbl (%eax),%eax
80109fea:	0f b6 c0             	movzbl %al,%eax
80109fed:	01 d0                	add    %edx,%eax
80109fef:	01 45 f4             	add    %eax,-0xc(%ebp)
80109ff2:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
80109ff6:	83 7d f0 05          	cmpl   $0x5,-0x10(%ebp)
80109ffa:	7e c7                	jle    80109fc3 <tcp_chksum+0x90>
80109ffc:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80109fff:	89 45 e0             	mov    %eax,-0x20(%ebp)
8010a002:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
8010a009:	eb 33                	jmp    8010a03e <tcp_chksum+0x10b>
8010a00b:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010a00e:	01 c0                	add    %eax,%eax
8010a010:	89 c2                	mov    %eax,%edx
8010a012:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010a015:	01 d0                	add    %edx,%eax
8010a017:	0f b6 00             	movzbl (%eax),%eax
8010a01a:	0f b6 c0             	movzbl %al,%eax
8010a01d:	c1 e0 08             	shl    $0x8,%eax
8010a020:	89 c2                	mov    %eax,%edx
8010a022:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010a025:	01 c0                	add    %eax,%eax
8010a027:	8d 48 01             	lea    0x1(%eax),%ecx
8010a02a:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010a02d:	01 c8                	add    %ecx,%eax
8010a02f:	0f b6 00             	movzbl (%eax),%eax
8010a032:	0f b6 c0             	movzbl %al,%eax
8010a035:	01 d0                	add    %edx,%eax
8010a037:	01 45 f4             	add    %eax,-0xc(%ebp)
8010a03a:	83 45 ec 01          	addl   $0x1,-0x14(%ebp)
8010a03e:	0f b7 45 de          	movzwl -0x22(%ebp),%eax
8010a042:	0f b7 c0             	movzwl %ax,%eax
8010a045:	83 ec 0c             	sub    $0xc,%esp
8010a048:	50                   	push   %eax
8010a049:	e8 fb f5 ff ff       	call   80109649 <N2H_ushort>
8010a04e:	83 c4 10             	add    $0x10,%esp
8010a051:	66 d1 e8             	shr    %ax
8010a054:	0f b7 c0             	movzwl %ax,%eax
8010a057:	39 45 ec             	cmp    %eax,-0x14(%ebp)
8010a05a:	7c af                	jl     8010a00b <tcp_chksum+0xd8>
8010a05c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010a05f:	c1 e8 10             	shr    $0x10,%eax
8010a062:	01 45 f4             	add    %eax,-0xc(%ebp)
8010a065:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010a068:	f7 d0                	not    %eax
8010a06a:	c9                   	leave  
8010a06b:	c3                   	ret    

8010a06c <tcp_fin>:
8010a06c:	55                   	push   %ebp
8010a06d:	89 e5                	mov    %esp,%ebp
8010a06f:	c7 05 68 70 19 80 01 	movl   $0x1,0x80197068
8010a076:	00 00 00 
8010a079:	90                   	nop
8010a07a:	5d                   	pop    %ebp
8010a07b:	c3                   	ret    

8010a07c <http_proc>:
8010a07c:	55                   	push   %ebp
8010a07d:	89 e5                	mov    %esp,%ebp
8010a07f:	83 ec 18             	sub    $0x18,%esp
8010a082:	8b 45 10             	mov    0x10(%ebp),%eax
8010a085:	83 ec 04             	sub    $0x4,%esp
8010a088:	6a 00                	push   $0x0
8010a08a:	68 cb c1 10 80       	push   $0x8010c1cb
8010a08f:	50                   	push   %eax
8010a090:	e8 65 00 00 00       	call   8010a0fa <http_strcpy>
8010a095:	83 c4 10             	add    $0x10,%esp
8010a098:	89 45 f4             	mov    %eax,-0xc(%ebp)
8010a09b:	8b 45 10             	mov    0x10(%ebp),%eax
8010a09e:	83 ec 04             	sub    $0x4,%esp
8010a0a1:	ff 75 f4             	push   -0xc(%ebp)
8010a0a4:	68 de c1 10 80       	push   $0x8010c1de
8010a0a9:	50                   	push   %eax
8010a0aa:	e8 4b 00 00 00       	call   8010a0fa <http_strcpy>
8010a0af:	83 c4 10             	add    $0x10,%esp
8010a0b2:	01 45 f4             	add    %eax,-0xc(%ebp)
8010a0b5:	8b 45 10             	mov    0x10(%ebp),%eax
8010a0b8:	83 ec 04             	sub    $0x4,%esp
8010a0bb:	ff 75 f4             	push   -0xc(%ebp)
8010a0be:	68 f9 c1 10 80       	push   $0x8010c1f9
8010a0c3:	50                   	push   %eax
8010a0c4:	e8 31 00 00 00       	call   8010a0fa <http_strcpy>
8010a0c9:	83 c4 10             	add    $0x10,%esp
8010a0cc:	01 45 f4             	add    %eax,-0xc(%ebp)
8010a0cf:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010a0d2:	83 e0 01             	and    $0x1,%eax
8010a0d5:	85 c0                	test   %eax,%eax
8010a0d7:	74 11                	je     8010a0ea <http_proc+0x6e>
8010a0d9:	8b 45 10             	mov    0x10(%ebp),%eax
8010a0dc:	89 45 f0             	mov    %eax,-0x10(%ebp)
8010a0df:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010a0e2:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010a0e5:	01 d0                	add    %edx,%eax
8010a0e7:	c6 00 00             	movb   $0x0,(%eax)
8010a0ea:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010a0ed:	8b 45 14             	mov    0x14(%ebp),%eax
8010a0f0:	89 10                	mov    %edx,(%eax)
8010a0f2:	e8 75 ff ff ff       	call   8010a06c <tcp_fin>
8010a0f7:	90                   	nop
8010a0f8:	c9                   	leave  
8010a0f9:	c3                   	ret    

8010a0fa <http_strcpy>:
8010a0fa:	55                   	push   %ebp
8010a0fb:	89 e5                	mov    %esp,%ebp
8010a0fd:	83 ec 10             	sub    $0x10,%esp
8010a100:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
8010a107:	eb 20                	jmp    8010a129 <http_strcpy+0x2f>
8010a109:	8b 55 fc             	mov    -0x4(%ebp),%edx
8010a10c:	8b 45 0c             	mov    0xc(%ebp),%eax
8010a10f:	01 d0                	add    %edx,%eax
8010a111:	8b 4d 10             	mov    0x10(%ebp),%ecx
8010a114:	8b 55 fc             	mov    -0x4(%ebp),%edx
8010a117:	01 ca                	add    %ecx,%edx
8010a119:	89 d1                	mov    %edx,%ecx
8010a11b:	8b 55 08             	mov    0x8(%ebp),%edx
8010a11e:	01 ca                	add    %ecx,%edx
8010a120:	0f b6 00             	movzbl (%eax),%eax
8010a123:	88 02                	mov    %al,(%edx)
8010a125:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
8010a129:	8b 55 fc             	mov    -0x4(%ebp),%edx
8010a12c:	8b 45 0c             	mov    0xc(%ebp),%eax
8010a12f:	01 d0                	add    %edx,%eax
8010a131:	0f b6 00             	movzbl (%eax),%eax
8010a134:	84 c0                	test   %al,%al
8010a136:	75 d1                	jne    8010a109 <http_strcpy+0xf>
8010a138:	8b 45 fc             	mov    -0x4(%ebp),%eax
8010a13b:	c9                   	leave  
8010a13c:	c3                   	ret    

8010a13d <ideinit>:
8010a13d:	55                   	push   %ebp
8010a13e:	89 e5                	mov    %esp,%ebp
8010a140:	c7 05 70 70 19 80 a2 	movl   $0x8010f5a2,0x80197070
8010a147:	f5 10 80 
8010a14a:	b8 00 d0 07 00       	mov    $0x7d000,%eax
8010a14f:	c1 e8 09             	shr    $0x9,%eax
8010a152:	a3 6c 70 19 80       	mov    %eax,0x8019706c
8010a157:	90                   	nop
8010a158:	5d                   	pop    %ebp
8010a159:	c3                   	ret    

8010a15a <ideintr>:
8010a15a:	55                   	push   %ebp
8010a15b:	89 e5                	mov    %esp,%ebp
8010a15d:	90                   	nop
8010a15e:	5d                   	pop    %ebp
8010a15f:	c3                   	ret    

8010a160 <iderw>:
8010a160:	55                   	push   %ebp
8010a161:	89 e5                	mov    %esp,%ebp
8010a163:	83 ec 18             	sub    $0x18,%esp
8010a166:	8b 45 08             	mov    0x8(%ebp),%eax
8010a169:	83 c0 0c             	add    $0xc,%eax
8010a16c:	83 ec 0c             	sub    $0xc,%esp
8010a16f:	50                   	push   %eax
8010a170:	e8 62 a7 ff ff       	call   801048d7 <holdingsleep>
8010a175:	83 c4 10             	add    $0x10,%esp
8010a178:	85 c0                	test   %eax,%eax
8010a17a:	75 0d                	jne    8010a189 <iderw+0x29>
8010a17c:	83 ec 0c             	sub    $0xc,%esp
8010a17f:	68 0a c2 10 80       	push   $0x8010c20a
8010a184:	e8 20 64 ff ff       	call   801005a9 <panic>
8010a189:	8b 45 08             	mov    0x8(%ebp),%eax
8010a18c:	8b 00                	mov    (%eax),%eax
8010a18e:	83 e0 06             	and    $0x6,%eax
8010a191:	83 f8 02             	cmp    $0x2,%eax
8010a194:	75 0d                	jne    8010a1a3 <iderw+0x43>
8010a196:	83 ec 0c             	sub    $0xc,%esp
8010a199:	68 20 c2 10 80       	push   $0x8010c220
8010a19e:	e8 06 64 ff ff       	call   801005a9 <panic>
8010a1a3:	8b 45 08             	mov    0x8(%ebp),%eax
8010a1a6:	8b 40 04             	mov    0x4(%eax),%eax
8010a1a9:	83 f8 01             	cmp    $0x1,%eax
8010a1ac:	74 0d                	je     8010a1bb <iderw+0x5b>
8010a1ae:	83 ec 0c             	sub    $0xc,%esp
8010a1b1:	68 35 c2 10 80       	push   $0x8010c235
8010a1b6:	e8 ee 63 ff ff       	call   801005a9 <panic>
8010a1bb:	8b 45 08             	mov    0x8(%ebp),%eax
8010a1be:	8b 40 08             	mov    0x8(%eax),%eax
8010a1c1:	8b 15 6c 70 19 80    	mov    0x8019706c,%edx
8010a1c7:	39 d0                	cmp    %edx,%eax
8010a1c9:	72 0d                	jb     8010a1d8 <iderw+0x78>
8010a1cb:	83 ec 0c             	sub    $0xc,%esp
8010a1ce:	68 53 c2 10 80       	push   $0x8010c253
8010a1d3:	e8 d1 63 ff ff       	call   801005a9 <panic>
8010a1d8:	8b 15 70 70 19 80    	mov    0x80197070,%edx
8010a1de:	8b 45 08             	mov    0x8(%ebp),%eax
8010a1e1:	8b 40 08             	mov    0x8(%eax),%eax
8010a1e4:	c1 e0 09             	shl    $0x9,%eax
8010a1e7:	01 d0                	add    %edx,%eax
8010a1e9:	89 45 f4             	mov    %eax,-0xc(%ebp)
8010a1ec:	8b 45 08             	mov    0x8(%ebp),%eax
8010a1ef:	8b 00                	mov    (%eax),%eax
8010a1f1:	83 e0 04             	and    $0x4,%eax
8010a1f4:	85 c0                	test   %eax,%eax
8010a1f6:	74 2b                	je     8010a223 <iderw+0xc3>
8010a1f8:	8b 45 08             	mov    0x8(%ebp),%eax
8010a1fb:	8b 00                	mov    (%eax),%eax
8010a1fd:	83 e0 fb             	and    $0xfffffffb,%eax
8010a200:	89 c2                	mov    %eax,%edx
8010a202:	8b 45 08             	mov    0x8(%ebp),%eax
8010a205:	89 10                	mov    %edx,(%eax)
8010a207:	8b 45 08             	mov    0x8(%ebp),%eax
8010a20a:	83 c0 5c             	add    $0x5c,%eax
8010a20d:	83 ec 04             	sub    $0x4,%esp
8010a210:	68 00 02 00 00       	push   $0x200
8010a215:	50                   	push   %eax
8010a216:	ff 75 f4             	push   -0xc(%ebp)
8010a219:	e8 7f aa ff ff       	call   80104c9d <memmove>
8010a21e:	83 c4 10             	add    $0x10,%esp
8010a221:	eb 1a                	jmp    8010a23d <iderw+0xdd>
8010a223:	8b 45 08             	mov    0x8(%ebp),%eax
8010a226:	83 c0 5c             	add    $0x5c,%eax
8010a229:	83 ec 04             	sub    $0x4,%esp
8010a22c:	68 00 02 00 00       	push   $0x200
8010a231:	ff 75 f4             	push   -0xc(%ebp)
8010a234:	50                   	push   %eax
8010a235:	e8 63 aa ff ff       	call   80104c9d <memmove>
8010a23a:	83 c4 10             	add    $0x10,%esp
8010a23d:	8b 45 08             	mov    0x8(%ebp),%eax
8010a240:	8b 00                	mov    (%eax),%eax
8010a242:	83 c8 02             	or     $0x2,%eax
8010a245:	89 c2                	mov    %eax,%edx
8010a247:	8b 45 08             	mov    0x8(%ebp),%eax
8010a24a:	89 10                	mov    %edx,(%eax)
8010a24c:	90                   	nop
8010a24d:	c9                   	leave  
8010a24e:	c3                   	ret    
