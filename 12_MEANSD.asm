section .data
	meanmsg db 10,"Mean value is:"
	meanmsg_len equ $-meanmsg

	sdmsg db 10,"Standard deviation is:"
	sdmsg_len equ $-sdmsg

	varmsg db 10,"Variance is:"
	varmsg_len equ $-varmsg

	array dd 50.00,40.00,30.00,20.00,10.00
	arraycnt dw 05

	dpoint db '.'
	dech dq 100                 ;MULTIPLICATION FACTOR TO DISPLAY WITH DECIMAL POINT
	nline db 10

section .bss
	dispbuff resb 1
	result  resd 1
    resbuff rest 1              ;RESERVE 10 BYTES - 80 BITS
	variance resd 1
	temp_cnt resb 1
	temp_mul resd 1
	mean resd 1


%macro display 2
	mov	eax,4
	mov	ebx,1
	mov	ecx,%1
	mov	edx,%2
	int 80h
%endmacro

%macro exit 0
	mov eax,1
	int 80h
%endmacro

section .text
global _start
_start:

	finit 		                    ;CHECKS FOR AND HANDLES ANY UNMASKED FLOATING POINT EXCEPTIONS BEFORE INITIALIZATION
	fldz 		                    ;PUSH +0.0 ONTO THE FPU REGISTER STACK
	mov esi,0	                    ;ESI = 0
	mov ebx,array	                ;EBX POINTS TO START OF THE ARRAY
	xor ecx,ecx 	                ;ECX = 000...
    mov ecx,[arraycnt]	            ;ECX HAS ARRAY COUNT
    mov [temp_cnt],ecx	            ;TEMP_CNT ALSO HAS ARRAY COUNT
    dec byte [temp_cnt]	            ;TEMP_CNT--
    fld dword[ebx]		            ;LOAD REAL OPERAND TO TOP TO STACK
    inc esi			                ;ESI = 1
    up:
    fadd dword[ebx+esi*4]           ;PERFORMS ADDITION WITH OPERAND AT TOP OF THE STACK -- ADDS ALL THE CONTENT OF ARRAY
    inc esi			                ;ESI++
    dec byte [temp_cnt]	            ;TEMP_CNT --
    cmp byte [temp_cnt],0
	jnz up

    fidiv word[arraycnt]	        ;CONVERTS 5 TO +5.0 I.E INTEGER TO EXTENDED REAL FORMAT BEFORE DIVIDING
    fst dword[mean]                 ;STORES THE OUTPUT OF DIVISION TO MEAN VARIABLE

    display meanmsg,meanmsg_len	    ;MEAN IS:
    call dispres

    mov ecx,[arraycnt] 		        ;ECX HAS ARRAY COUNT
    mov [temp_cnt],ecx		        ;TEMP_CNT HAS ARRAY COUNT
    mov ebx,array 			        ;EBX HAS POINTER TO ARRAY'S BEGINING
    mov esi,00 			            ;ESI = 0
    fldz                            ;PUSH +0.0 ONTO FPU REGISTER STACK
    mov dword[temp_mul],0	        ;TEMP_MUL = 0
up1:
    fldz				            ;PUSH +0.0 ONTO STACK
    fld dword[ebx+esi*4]		    ;FLOATING POINT LOAD
    fsub dword[mean]		        ;SUBTRACT
    fst st1				            ;FLOATING POINT STORE TO ST1
    fmul 				            ;MULTIPLY
    fadd dword[temp_mul]		    ;ADD TO TEMP_MUL
    fst dword[temp_mul]		        ;FLOATING POINT STORE TO TEMP_MUL

next:
    inc esi                         ;ESI = 1
    dec byte[temp_cnt]		        ;TEMP_CNT--
    cmp byte [temp_cnt],0
    jnz up1


fidiv word[arraycnt]            ;INTEGER DIVIDE
fst dword[variance]             ;STORE TO VARIANCE
display varmsg,varmsg_len	    ;VARIANCE IS:
call dispres
fld dword[variance]		        ;FLOATING POINT LOAD
fsqrt                           ;SQRT
display sdmsg,sdmsg_len		    ;STANDARD DEVIATION:
call dispres			        ;MAA KI DISPRES TERI!

end:
    exit


disp8_proc:                     ;ORIGNAL_ASCII
    mov edi,dispbuff	        ;EDI POINTS TO DISPBUFF
    mov ecx,02		            ;ECX = 2
back: rol bl,04 		        ;ROTATE BL BY 04
	mov dl,bl
	and dl,0FH
	cmp dl,09
	jbe next1
	add dl,07H
next1:  add dl,30H
	mov [edi],dl
	inc edi
	loop back
	ret

dispres:
    fimul dword[dech]	        ;INTEGER MULTIPLY
    fbstp tword[resbuff]	    ;CONVERT TO PACKED BCD AND POP
    xor ecx,ecx 		        ;ECX = 0
    mov ecx,9		            ;ECX = 9
    mov esi,resbuff+9	        ;ESI POINTS TO RESBUFF'S 10TH POSITION STARTING

up2:
    push ecx                    ;ECX = 9
    push esi 		            ;ESI POINTS TO LAST ELEMENT OF ARRAY
    mov bl,[esi]		        ;BL = LAST NUM
    call disp8_proc
    display dispbuff,2	        ;PRINTS DISP BUFF
    pop esi
    dec esi
    pop ecx
    loop up2 		            ;UNTILL ECX = 0
    display dpoint,1	        ;.
    mov bl,[resbuff]
    call disp8_proc
    display dispbuff,2
    display nline,1
    ret