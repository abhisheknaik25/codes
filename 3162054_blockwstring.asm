section .data
msg1 db 10,"Enter 5 numbers for array block:",10
msglen1 equ $-msg1
msg2 db 10,"1.Overlapped block transfer",10
msglen2 equ $-msg2
msg3 db 10,"2.Non overlapped block transfer",10
msglen3 equ $-msg3
msg4 db 10,"Enter above choice:",10
msglen4 equ $-msg4
msg5 db 10,"The array after block transfer:",10
msglen5 equ $-msg5
msg51 db 10,"The array before block transfer:",10
msglen51 equ $-msg51
msg6 db 10,"Enter position for block transfer:",10
msglen6 equ $-msg6
msg7 db 10,"Error Enter correct choice",10
msglen7 equ $-msg7
msg8 db 10,"1.Continue?",10
msglen8 equ $-msg8
msg9 db 10,"2.Exit",10
msglen9 equ $-msg9
msg10 db 10,"Enter choice:",10
msglen10 equ $-msg10
space db " "
sp_len equ $-space
arr2 times 80 db 0
arr1 times 80 db 0
cnt db 0

section .bss
num resb 5
buff resb 4
pos resb 2
choice resb 2
ans resb 2

%macro display 2
mov eax,4
mov ebx,2
mov ecx,%1
mov edx,%2
int 80h
%endmacro

%macro accept 2
mov eax,3
mov ebx,0
mov ecx,%1
mov edx,%2
int 80h
%endmacro

section .text
    global _start
_start:
    display msg2,msglen2
    display msg3,msglen3
    display msg4,msglen4
    accept choice,2
    sub byte[choice],30h
    cmp byte[choice],01h
    je overlap
    cmp byte[choice],02h
    je non_overlap
    display msg7,msglen7
    jmp_start
    
overlap:
    display msg1,msglen1
    mov byte[cnt],05
    mov edi,arr1
l1: accept num,5
    mov ebx,[num]
    mov [edi],ebx
    add edi,4
    dec byte[cnt]
    jnz l1
    
    display msg51,msglen51
    mov byte[cnt],5
    mov esi,arr1
l41:mov eax,[esi]
    mov [num],eax
    display num,4
    display space,sp_len
    add esi,4
    dec byte[cnt]
    jnz l41
    
    mov esi,arr1
	mov edi,arr1
	display msg6,msglen6
	accept pos,2
	sub byte[pos],30h
	dec byte[pos]
	mov eax,0
	mov byte[cnt],5
	mov al,byte[cnt]
ll1:add esi,4
	dec al
	jnz ll1
	sub esi,4
    mov edi,esi	
    mov al,[pos]	
ll2:add edi,4
	dec al
	jnz ll2
l2:mov ecx,05h
    std
    rep movsd 
l3:	mov eax,[esi]
	mov [buff],eax
	display buff,4
	display space,sp_len
	add esi,04
	dec byte[cnt]
	jnz l3
    jmp end

non_overlap:
	display msg1,msglen1
	mov byte[cnt],5
	mov edi, arr1

l5:	accept num,5
	mov eax,[num]
	mov [edi],eax
	add edi,4
	dec byte[cnt]
	jnz l5


	display msg51,msglen51
	mov byte[cnt],5
	mov esi,arr1
l51:mov eax,[esi]
    mov [num],eax
    display num,4
    display space,sp_len
    add esi,4
    dec byte[cnt]
    jnz l51
    
    mov ecx,5
    mov esi,arr1
    mov edi,arr2
l6: cld 
    rep movsd
l4: mov eax,[esi]
    mov [num],eax
    display num,4
    display space,sp_len
    add esi,4
    dec byte[cnt]
    jnz l4
    
end:
    display msg8,msglen8
    display msg9,msglen9
    display msg10,msglen10
    accept ans,2
    sub byte[ans],30h
    cmp byte[ans],1
    je _start
    cmp byte[ans],2
    je terminate
    display msg4,msglen4
    jmp end
    
terminate:
    mov eax,1
    int 80h
    
