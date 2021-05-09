DATAS SEGMENT
	count dw 0;存放素数个数
  	sum   dw 0;存放素数的和
  	prime dw 100 dup(0);存放素数
    primemsg db 'print prime',0ah,0dh,'$';输出素数的提示信息
	countmsg db 0ah,0dh,'print prime of count',0ah,0dh,'$';输出素数个数提示
  	summsg   db 0ah,0dh,'print prime of sum',0ah,0dh,'$' ;输出素数和提示
DATAS ENDS

STACKS SEGMENT
    dw 20 dup(?)
STACKS ENDS

CODES SEGMENT
    ASSUME CS:CODES,DS:DATAS,SS:STACKS
START:
    MOV AX,DATAS
    MOV DS,AX
    
    mov ax,stacks
 	mov ss,ax
 	
 	call caculate
  	call disprime
  	call dispcount
  	call dispsum
 	
    ;此处输入代码段代码
    MOV AH,4CH
    INT 21H

caculate proc
	mov ax, 2
	mov bx, 0
	mov word ptr prime[bx], ax
	add bx, 2
	inc word ptr count[0]
	add word ptr sum[0], ax
	mov cx, 98
	mov ax, 3
j1:
	push cx
	push ax
	mov cx, ax
	sub cx, 2
	mov dl, 2
j2:
	div dl
	cmp ah, 0
	je break
	inc dl
	pop ax
	push ax
	loop j2
	pop ax
	pop cx
	mov word ptr prime[bx], ax
	add bx, 2
	inc word ptr count[0]
	add word ptr sum[0], ax
	inc ax
	jmp next
break:
	pop ax
	pop cx
	inc ax
next:
	loop j1
	ret
caculate endp


disprime proc
	mov cx, 10
	mov bx, 0
pp:
	mov ax, word ptr prime[bx]
	push cx
	push bx
	call printf
	pop bx
	pop cx
	add bx, 2
	
	lea dx, offset primemsg
	mov ah, 9
	int 21h
	
	loop pp
	ret
disprime endp


dispcount proc
	lea dx, offset countmsg
	mov ah, 9
	int 21h
	
	mov ax, word ptr count[0]
	call printf
	ret
dispcount endp


dispsum proc
	lea dx, offset summsg
	mov ah, 9
	int 21h
	mov ax, word ptr sum[0]
	call printf
	ret
dispsum endp



printf proc
	MOV CX, 0
SPLITf:
	MOV DX, 0
	MOV BX, 10
	DIV BX
	PUSH DX 
	INC CX
	CMP AX, 0
	JNE SPLITf
PRINT:
	POP DX
	ADD DL, 30H
	MOV AH, 02H
	INT 21H
	LOOP PRINT
	ret
printf endp


CODES ENDS
    END START

