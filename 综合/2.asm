DATAS SEGMENT
    year dw 0
    month dw 0
    day dw 0
    rd db 1,6,4,2,7,5,3
    distance db 0
    swi db 0,0
    mdays db 31,28,31,30,31,30,31,31,30,31,30,31
    left db 0
    w7 db 'Sunday','$'
    w6 db 'Saturday','$'
    w5 db 'Friday','$'
    w4 db 'Thursday','$'
    w3 db 'Wednesday','$'
    w2 db 'Tuesday','$'
    w1 db 'Monday','$'
DATAS ENDS

STACKS SEGMENT
    ;此处输入堆栈段代码
STACKS ENDS

CODES SEGMENT
    ASSUME CS:CODES,DS:DATAS,SS:STACKS
START:
    MOV AX,DATAS
    MOV DS,AX
    ;此处输入代码段代码
    
    mov bx, 0
insert:
	mov ah, 01h
	int 21h
	
	cmp al,0DH
	je compute
	cmp al,'/'
	jne multi
	add bx, 2
	jmp insert

multi:
	mov ah,0
	sub al,30h
	push ax
	mov dx, 10
	mov ax, word ptr DS:[bx]
	mul dx
	pop dx
	add ax, dx
	mov word ptr DS:[bx], ax
	jmp insert

compute:
	mov ax, word ptr DS:[0]
	sub ax, 1996
	mov bl, 28
	div bl
	mov byte ptr distance[0], ah
	mov al, byte ptr distance[0]
	mov ah,0
	mov bl,4
	div bl
	mov byte ptr swi[0], al ;6
	mov byte ptr swi[1], ah ;1
	mov ax, 365
	mov bl, byte ptr swi[1]
	mov bh,0
	mul bx
	inc ax
	mov bl,7
	div bl
	mov byte ptr left[0],ah
	
	
	mov cx, month[0]
	dec cx
	mov bx, 0
	mov al,byte ptr left[0]
sum:
	add al, byte ptr mdays[bx]
	inc bx
	loop sum
	
	
	mov ah, 0
	mov bl, 7
	div bl
	mov byte ptr left[0],ah
	mov al, byte ptr left[0]
	mov ah,0
	add ax, word ptr day[0]
	mov bl, 7
	div bl
	mov byte ptr left[0], ah
	
	mov al, byte ptr left[0]
	mov bl, byte ptr swi[0]
	mov bh, 0
	mov dl, byte ptr rd[bx]
	dec dl
	add al, dl
	mov ah, 0
	mov bl, 7
	div bl
	mov byte ptr left[0], ah

show:
	cmp byte ptr left[0], 0
	jne c1
	lea dx, offset w7
	mov ah,09h
	int 21h
	jmp exit

c1:
	cmp byte ptr left[0], 1
	jne c2
	lea dx, offset w1
	mov ah,09h
	int 21h
	jmp exit
	
c2:
	cmp byte ptr left[0], 2
	jne c3
	lea dx, offset w2
	mov ah,09h
	int 21h
	jmp exit

c3:
	cmp byte ptr left[0], 3
	jne c4
	lea dx, offset w3
	mov ah,09h
	int 21h
	jmp exit

c4:
	cmp byte ptr left[0], 4
	jne c5
	lea dx, offset w4
	mov ah,09h
	int 21h
	jmp exit

c5:
	cmp byte ptr left[0], 5
	jne c6
	lea dx, offset w5
	mov ah,09h
	int 21h
	jmp exit

c6:
	cmp byte ptr left[0], 6
	lea dx, offset w6
	mov ah,09h
	int 21h

exit:
    MOV AH,4CH
    INT 21H
CODES ENDS
    END START

