section .data
	msg1 db 10,  "Enter 5 No.",  10
	msglen1 equ $-msg1

	msg2 db 10,  "1. Overlapped"
	msglen2 equ $-msg2

	msg3 db 10,  "2. Non Overlapped"
	msglen3 equ $-msg3

	msg4 db 10,  "Enter: "
	msglen4 equ $-msg4

	msg5 db 10,  "Array after is: ",  10
	msglen5 equ $-msg5

	msg6 db 10,  "Enter Position of Block Transfer: ",  10
	msglen6 equ $-msg6

	msg7 db 10,  "ERROR"
	msglen7 equ $-msg7

	msg8 db 10,  10,  "1. CONTINUE?"
	msglen8 equ $-msg8

	msg9 db 10,  "2. EXIT"
	msglen9 equ $-msg9

	msg10 db 10,  "CHOICE: "
	msglen10 equ $-msg10

	space db " "
	sp_len equ $-space

	arr1 times 80 db 0
	arr2 times 80 db 0
	cnt db 0

section .bss
	num resb 5
	buff resb 4
	pos resb 2
	choice resb 2
	answer resb 2

%macro display 2
	mov eax,  4
	mov ebx,  1
	mov ecx,  %1
	mov edx,  %2
	int 80h
%endmacro

%macro accept 2
	mov eax,  3
	mov ebx,  0
	mov ecx,  %1
	mov edx,  %2
	int 80h
%endmacro

section .text
global _start
_start:
	display msg2, msglen2		;OV
	display msg3, msglen3		;NOV
	display msg4, msglen4		;ENTER:
	accept choice, 2
	cmp byte[choice], 31h
	je overlap
	cmp byte[choice], 32h
	je non_overlap
	display msg7, msglen7
	jmp _start					;BASICS

overlap:
	display msg1, msglen1 		;ENTER 5 NO.
	mov byte[cnt], 05
	mov edi, arr1

l1:
	accept num, 5
	mov ebx, [num]
	mov [edi], ebx				;[NUM] TO [EDI]
	add edi, 4					;NEXT
	dec byte[cnt]
	jnz l1
	mov esi, arr1
	mov edi, arr1				;ESI AND EDI POINTS TO ARRAY START

	display msg6, msglen6
	accept pos, 2
	sub byte[pos], 30h
	dec byte[pos]				;POS--;
	mov eax, 0					;!?
	mov byte[cnt], 5
	mov al, byte[cnt]			;CNT = AL = 5

ll1:
	add esi, 4					;ESI = ARRAY[1]
	dec al						;AL = 4
	jnz ll1						;AFTER END LOOP ESI POINTS TO END OF ARRAY
	sub esi, 4					;POINTS TO LAST CELL START
	mov edi, esi				;ESI = EDI
	mov al, [pos]				;AL = POS

ll2:
	add edi, 4
	dec al
	jnz ll2						;AL != 0
								;AFTER THIS LOOP EDI POINTS TO END OF THE NEW ARRAY IF POS = 3 THEN AT EDI = 8

l2:
	mov ecx, 05					;!!
	std							;!!
	rep movsd					;REPEAT MOV STRING

	display msg5, msglen5		;AFTER TRANSFER IS:
	mov esi, arr1
	mov byte[cnt], 5
	mov al, [pos]
	add byte[cnt], al			;CNT = 5 + USER INPUT POS

l3:
	mov eax, [esi]
	mov [buff], eax				;[ESI] TO BUFF USING EAX
	display buff, 4
	display space, sp_len
	add esi, 04					;NEXT
	dec byte[cnt]
	jnz l3
	jmp end

non_overlap:
	display msg1, msglen1
	mov byte[cnt], 5
	mov edi, arr1

l5:
	accept num, 5
	mov eax, [num]
	mov [edi], eax
	add edi, 4
	dec byte[cnt]
	jnz l5
	mov ecx, 5
	mov esi, arr1
	mov edi, arr2
	cld  					;!!
	rep movsd				;!!

	display msg5, msglen5
	mov byte[cnt], 5
	mov esi, arr2

l4:
	mov eax, [esi]
	mov[num], eax
	display num, 5
	add esi, 4
	dec byte[cnt]
	jnz l4

end:
	display msg8,  msglen8
	display msg9,  msglen9
	display msg10,  msglen10
	accept answer,  2
	cmp byte[answer],  31h
	je _start
	mov eax,  1
	int 80h
