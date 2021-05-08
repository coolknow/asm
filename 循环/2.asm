DATAS SEGMENT
    tips db 'Enter to print all legitimate figures','$' 
    m dw 0,0,0
DATAS ENDS

STACKS SEGMENT
    ;此处输入堆栈段代码
STACKS ENDS

CODES SEGMENT
    ASSUME CS:CODES,DS:DATAS,SS:STACKS
START:
    MOV AX,DATAS
    MOV DS,AX
    
    lea dx, offset tips
	mov ah, 9
	int 21h
	
insert:	
	mov ah, 1 
	int 21h
	cmp al, 0dh
	jne insert
	
	mov cx, 899
	mov ax, 100
judge:
	mov bx, 10
	push ax
split:
	mov dx, 0
	div bx
	push dx
	cmp ax, 0
	jne split
addf:
	pop ax
	mul ax
	mul ax
	mov word ptr m[0], ax
	pop ax
	mul ax
	mul ax
	mov word ptr m[2], ax
	pop ax
	mul ax
	mul ax
	mov word ptr m[4], ax
	mov bx, word ptr m[0]
	add bx, word ptr m[2]
	add bx, word ptr m[4]
	pop ax
	cmp ax, bx
	jne next
	push cx
	call printf
	pop cx
next:
	inc ax
	loop judge
    
    MOV AH,4CH
    INT 21H
    

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






