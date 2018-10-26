section .data
	msg1 db 10, "Enter elements of Array:", 10, 13
	msglen1 equ $-msg1
	msg2 db 10, "Elements of Array are:", 10, 13
	msglen2 equ $-msg2
	msg3 db 10, "Number of Positive elements are:"
	msglen3 equ $-msg3
	msg4 db 10, "Number of Negative elements are:"
	msglen4 equ $-msg4

	nwln db 10
	cnt db 0
	pcnt db 0
	ncnt db 0
	arr1 times 80 db 0

section .bss
	num resb 5
	buff resb 5

%macro input 2
	mov eax, 3
	mov ebx, 0
	mov ecx, %1
	mov edx, %2
	int 80h
%endmacro

%macro output 2
	mov eax, 4
	mov ebx, 1
	mov ecx, %1
	mov edx, %2
	int 80h
%endmacro

section .text
global _start
_start:
	output msg1, msglen1		;ENTER ARRAY CONTENTS
	mov byte[cnt], 5			;CNT = 5
	mov edi, arr1				;EDI POINTS TO START OF ARRAY
l1: input num, 5				;ACCEPTS NO. FROM USER IN NUM
	mov esi, num 				;MOVES NUM TO ESI, NEEDED TO CALL ASCII_ORIGNAL
	call ascii_original			;CONVERT NUMBER AT ESI TO DECIMAL
	mov [edi], bx				;STORES THE CONVERTED NUMBER TO ARR[i]
	inc edi
	inc edi						;INCREASES POINTER TO ARR[i + 1]
	dec byte[cnt]				;CNT--
	jnz l1						;JUMP IF NOT ZERO LABEL L1

	output msg2, msglen2		;ELEMENTS OF THE ARRAY ARE:
	mov byte[cnt], 5			;CNT = 5, AGAIN...
	mov esi, arr1				;ESI POINTS TO START OF ARRAY
l2: mov bx, [esi]				;BX'S DECIMAL VALUE IS CONVERTED TO ASCII
	call original_ascii			;BY THIS FUNCTION
	output nwln, 1				;\N
	inc esi
	inc esi						;INCREASES POINTER TO ARR[i + 1]
	dec byte[cnt]				;CNT--
	jnz l2						;JUMP IF NOT ZERO TO LABEL L2


	mov esi, arr1				;ESI POINTS TO START OF ARRAY. AGAIN...
	mov byte[cnt], 5			;CNT = 5, AGAIN...
l3: mov ax, [esi]				;AX HAS THE DECIMAL VALUE AT POINTER ESI
	and ax,  8000h				;AND AX WITH 8000H
	jz l4						;JUMP IF ZERO I.E +VE
	inc byte[ncnt]				;ELSE -VE
	jmp l5
l4: inc byte[pcnt]
l5:	inc esi
	inc esi						;ARRAY[i + 1]
	dec byte[cnt]				;CNT --
	jnz l3
	output msg3, msglen3
	add byte[pcnt], 30h		;CONVERTS NUMBER TO ASCII
	output pcnt, 1

	output msg4, msglen4
	add byte[ncnt], 30h
	output ncnt, 1

	mov eax, 1
	int 80h

ascii_original:
	mov ecx, 4					;FOUR DIGIT NUMBER HENCE ECX = 4
	mov ebx, 0					;WILL CONTAIN THE FINAL NUMBER
	mov eax, 0					;
up1:
	rol bx, 4					;ROTATE LEFT 4 BIT
	mov al, [esi]				;AL NOW HAS VALUE AT ESI POINTER
	cmp al,  39h				;COMPARE WITH 39H
	jbe down1					;JUMP IF BELOW OF EQUAL
	sub al, 07h					;FOR A,B,C,D,E,F SUBTRACT EXTRA 09H
down1:
	sub al, 30h					;TO ASCII
	add bx, ax					;CONVERTED VALUE TO BX FROM AX
	inc esi						;POINTS TO NEXT VALUE
	loop up1					;ECX-- AND LOOP UNTIL ECX != 0
	ret

original_ascii:
	mov edi, buff				;EDI POINTED TO START OF BUFF
	mov ecx, 4					;ECX = 4 I.E LOOPED 4 TIMES
up2:
	rol bx, 4					;ROTATE LEFT 4 BIT
	mov dl, bl 					;BL I.E DECIMAL VALUE IN DL
	and dl, 0fh					;REMEMBER
	cmp dl, 09h					;ADD 09H IF B/W 0 TO 9
	jbe down2
	add dl, 07h					;ADD 07H FOR A,B,C,D,E,F
down2:
	add dl, 30h					;ADD 30H TO FINALLY CONVERT TO ASCII
	mov[edi], dl  				;MOVES FIRST CONVERTED VALUE TO EDI I.E BUFF
	inc edi						;NEXT PLACE IN THE ARRAY
	loop up2					;ECX-- UNTIL ECX = 0
	output buff, 4				;PRINT
	ret