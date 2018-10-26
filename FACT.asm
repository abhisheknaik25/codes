;OUTPUT : 8 digit HEX
section .data
   msg1 db 10, "No Arument Present"
   msg1len equ $-msg1


section .bss
   num resb 4           ;ACCEPT 4 BIT
   buff resb 4          ;DISPLAY 8 BIT


%macro display 2
   mov eax, 4
   mov ebx, 1
   mov ecx, %1
   mov edx, %2
   int 80h
%endmacro


%macro exit 0
   mov eax, 1
   mov ebx, 0
   int 80h
%endmacro

section .text
global _start
_start:

      push ebp	                 ;STORES PREV BASE POINTER EBP
      mov ebp, esp              ;SET BASE POINTER TO STACK ADDRESS

	;Do remember:It is establishing a new stack frame within the callee,  while preserving the stack frame of the caller.

      cmp dword[ebp+4], 1      ;RETURNS NUMBER OF ARGUMENTS IN THE TERMINAL,  NEED MORE THAN ONE.
      je no_arg			       ;IF ARG > 1,  USE THE ARGUMENT WHICH IS A NUMBER

      mov ebx, 3
      mov edi, dword[ebp+4*ebx] ;points to the arg,  each entry is 4 bytes at 4th place the arg2 is present

      xor eax, eax             ;EAX = 000...
      mov eax, [edi]           ;EDI POINTS TO THE STARTING OF 4TH PLACE WHERE ARG 2 IS PRESENT.
      mov [num], eax           ;NUM CONTAINS THE ARGUMENT

      sub byte[num], 30h       ;0 < NUM < 9

      xor eax, eax             ;EAX = 000...
      mov al, [num]            ;AL = NUM
      call facto

      mov ebx, eax
      call original_ascii
      exit

no_arg:
   display msg1, msg1len
	mov esp,  ebp
	pop ebp
	exit

facto:

		cmp eax, 1			;IF EAX == 1,  POP AND MULTIPLY
		je pop_element

		push eax			   ;ELSE PUSH AND NUM--
		dec eax

		call facto			;CALL FACTO UNTILL EAX == 1

	mul_element:
		pop ebx				;POP IN EBX
		mul ebx           ;MULTIPLY BY EBX
		ret

	pop_element:
		pop ebx		       ;RET FROM MUL_ELEMENT RETURNS TO THIS LABEL
		jmp mul_element    ;EAX HAS THE ANSWER


original_ascii:
   mov edi,  buff           ;EDI POINTED TO START OF BUFF
   mov ecx,  4              ;ECX = 4 I.E LOOPED 4 TIMES
up2:
   rol bx,  4               ;ROTATE LEFT 4 BIT
   mov dl,  bl              ;BL I.E DECIMAL VALUE IN DL
   and dl,  0fh             ;REMEMBER
   cmp dl,  09h             ;ADD 09H IF B/W 0 TO 9
   jbe down2
   add dl,  07h             ;ADD 07H FOR A, B, C, D, E, F
down2:
   add dl,  30h             ;ADD 30H TO FINALLY CONVERT TO ASCII
   mov[edi],  dl            ;MOVES FIRST CONVERTED VALUE TO EDI I.E BUFF
   inc edi                 ;NEXT PLACE IN THE ARRAY
   loop up2                ;ECX-- UNTIL ECX = 0
   display buff, 4        ;PRINT
   ret