;BCD TO HEXA DECIMAL & HEXA DECIMAL TO BCD


section .data

 msg1 db 10,"Enter the BCD number:"
 msglen1 equ $-msg1

 msg2 db 10,"Enter the HEX number:"
 msglen2 equ $-msg2

 msg3 db 10,"The BCD equivalent is: "
 msglen3 equ $-msg3

 msg4 db 10,"The HEX equivalent is: "
 msglen4 equ $-msg4

 msg5 db 10,"(1) BCD TO HEXADECIMAL: "
 msglen5 equ $-msg5

 msg6 db 10,"(2) HEXADECIMAL TO BCD: "
 msglen6 equ $-msg6

 msg7 db 10,"(3) EXIT? "
 msglen7 equ $-msg7

 msg8 db 10,"Enter your choice: "
 msglen8 equ $-msg8

 cnt db 0

section .bss

 num1 resb 5
 num2 resb 6
 buff resb 4
 rem resb 1
 choice resb 2

 %macro accept 2
  mov eax,3
  mov ebx,0
  mov ecx,%1
  mov edx,%2
  int 80h
 %endmacro

 %macro display 2
  mov eax,4
  mov ebx,1
  mov ecx,%1
  mov edx,%2
  int 80h
 %endmacro

section .text

global _start

_start:
       display msg5,msglen5
       display msg6,msglen6
       display msg7,msglen7
       display msg8,msglen8

       accept choice,2
       sub byte[choice],30h
       cmp byte[choice],1
       je l1
       cmp byte[choice],2
       je l2
       cmp byte[choice],3
       je end
       jmp _start


       l1:
          display msg1,msglen1     ;BCD TO HEX
          accept num2,6
          display msg4,msglen4
          mov eax,0
          mov ebx,10
          mov esi,num2
          mov ecx,5

       l4:
          ;mov edx,0
          mul ebx
          mov edx,0
          mov dl,[esi]
          sub dl,30h
          add eax,edx
          inc esi
          dec ecx
          jnz l4
          mov ebx,eax
          call original_ascii
          jmp end

       l2:
          display msg2,msglen2
          accept num1,5
          display msg3,msglen3
          call ascii_original
          mov eax,ebx
          mov ebx,10
          mov byte[cnt],0

       l5:
          mov edx,0
          div ebx
          push dx
          inc byte[cnt]
          cmp ax,0
          jnz l5

       l6:
          pop dx
          add dl,30h
          mov[rem],dl
          display rem,1
          dec byte[cnt]
          jnz l6

       end:
           mov eax,1
           int 80h



       ascii_original:
          mov ecx,4
          mov ebx,0
          mov eax,0
          mov esi,num1

       up1:rol bx,4
           mov al,[esi]
           cmp al,39h
           jbe down1
           sub al,07h

       down1:sub al,30h
             add bx,ax
             inc esi
             loop up1
             ret


       original_ascii:
         mov esi,buff
         mov ecx,4

        up2: rol bx,4
             mov dl,bl
             add dl,0fh
             cmp dl,09h
             jbe down2
             sub dl,07h

        down2: add dl,30h
               mov [esi],dl
               inc esi
               loop up2
               display buff,4
               ret


