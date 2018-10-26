section .data
gmsg db 10,10,"The contents of GDTR are:"
gmsglen equ $-gmsg
lmsg db 10,10,"The contents of LDTR are:"
lmsglen equ $-lmsg
imsg db 10,10,"The contents of IDTR are:"
imsglen equ $-imsg
tmsg db 10,10,"The contents of TR are:"
tmsglen equ $-tmsg
mmsg db 10,10,"The contents of MSW are:"
mmsglen equ $-mmsg
pro db 10,10,"In protected mode:"
prolen equ $-pro
real db 10,10,"In real mode:"
reallen equ $-real

col db ":"
collen equ $-col
nline db 10,10
nlen equ $-nline

section .bss
buff resb 4
gdt1 resb 6
idt1 resb 6
ldt1 resb 1
t1 resb 2
msw1 resb 4

%macro display 2
mov eax,4					;WHAT = PRINT
mov ebx,1					;WHERE = STDOUT / SCREEN
mov ecx,%1
mov edx,%2
int 80h
%endmacro

section .text
 global _start
_start:

smsw eax                    ;STORE MACHINE STATUS WORD [PART OF CR0]
mov [msw1],eax              ;MSW STORED IN 4 BYTE MSW1 VARIABLE
bt eax,0                    ;BIT TEST EAX
jc protected                ;JUMP IF CARRY TO PROTECTED LABEL
display real,reallen        ;ELSE MODE IS REAL, NEED PROTECTED
jmp end                     ;FUCK OFF

protected:
display pro,prolen         ;IN PROTECTED MODE
sgdt [gdt1]                ;STORE GLOBAL DESCRIPTOR TABLE REGISTER IN GDTR1 - 6 BYTE
sldt [ldt1]                ;STORE LOCAL DESCRIPTOR TR IN LDTR1 - 1 BYTE
sidt [idt1]                ;STORE INTERUPT DESCRIPTOR TR IN IDTR1 - 6 BYTE
str [t1]                   ;STORE TASK REGISTER IN T1 - 2 BYTE

display gmsg,gmsglen       ;CONTENTS OF GDTR:
mov bx,[gdt1+4]            ;BX = POINTER TO GDTR1 + 4 BYTE
call original_ascii        ;PRINTS VALUE AT BX
mov bx,[gdt1+2]            ;BX = POINTER TO GDTR1 + 2 BYTE
call original_ascii        ;PRINTS VALUE AT BX, AGAIN
display col,collen         ;:
mov bx,[gdt1]              ;BX = POINTER AT GDTR1
call original_ascii        ;PRINTS VALUE AT BX, AGAIN...

display lmsg,lmsglen       ;CONTENTS OF LDTR:
mov bx,[ldt1]              ;BX = POINTER OF LDTR1
call original_ascii        ;PRINTS VALUE AT BX

display imsg,imsglen       ;CONTENTS OF IDTR:
mov bx,[ldt1+4]
call original_ascii
mov bx,[idt1+2]
call original_ascii
mov bx,[idt1+2]
call original_ascii
display col,collen         ;:
mov bx,[idt1]              ;BX = POINTER TO IDTR1
call original_ascii        ;PRINTS VALUE AT BX

display tmsg,tmsglen       ;CONTENTS OF TASK REGISTER ARE:
mov bx,[t1]                ;BX = POINTER TO T1
call original_ascii        ;PRINTS VALUE AT BX

display mmsg,mmsglen       ;CONTENTS OF MACHINE STATUS WORD ARE:
mov bx,[msw1+2]            	;UPAR DEKH BHOSADIKE!
call original_ascii
mov bx,[msw1]
call original_ascii
call end

original_ascii:
	mov eax, 0
	mov esi,buff
	mov ecx,4
up2:
	rol bx,4
	mov dl,bl
	and dl,0fh
	cmp dl,09h
	jbe down2
	add dl,07h
down2:
	add dl,30h
	mov[esi],dl
	inc esi
	loop up2
	display buff,4
	ret


end:
 display nline,nlen
 mov eax,1
 int 80h
