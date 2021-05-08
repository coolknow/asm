DATAS SEGMENT
    tips db 'range 0 to 500','$'
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
	
	mov cx, 19
	mov ax, 0
judge:
	cmp ax, 10
	jb l1
	cmp ax, 100
	jb l2
	jmp l3
l1:
	push cx
	push ax
	call printf
	pop ax
	pop cx
	inc ax
	loop judge
	jmp finish
l2:
	push ax
	mov bl, 10
	div bl
	cmp al, ah
	jne n1
	pop ax
	push ax
	push cx
	call printf
	pop cx
n1:
	pop ax
	inc ax
	loop judge
	jmp finish
	
l3:
    push ax
    mov bl, 10
    div bl
    mov bh, ah
    mov ah, 0
    div bl
    cmp al, bh
	jne n2
	pop ax
	push ax
	push cx
	call printf
	pop cx
n2:
	pop ax
	inc ax
	loop judge

finish:
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


