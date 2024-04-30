	.text

	.globl thread_switch
thread_switch:
		
	pushal	//PUSH: saving current_thread
	
	movl current_thread, %eax	//current_thread의 주소를 %eax에 로드
   	movl %esp, (%eax)		// %esp를 current_thread->sp에 저장
		
	movl next_thread, %eax		//마찬가지
	movl (%eax), %esp		//마찬가지
	
	movl %eax, current_thread	//next_threa의 시작 주소가 있는 %eax값을 다시 current_thread로

	popal	//POP: restoring next_thread

	ret			/* return to ra*/	
