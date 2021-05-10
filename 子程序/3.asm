DATAS SEGMENT
    rawdata dw 20 dup(?)
    count dw 0
    inbuff dw 0
DATAS ENDS

STACKS SEGMENT
    ;此处输入堆栈段代码
STACKS ENDS

CODES SEGMENT
    ASSUME CS:CODES,DS:DATAS,SS:STACKS
START:
    MOV AX,DATAS
    MOV DS,AX
    
    call input1
    call printseq
    
    MOV AH,4CH
    INT 21H
    
;-------------------------------
;-------------------------------
input1 proc
	mov bx, 0
cin1:
	push bx
	mov word ptr inbuff[0], 0
cin:
	mov ah, 1
	int 21h

	cmp al, 0dh
	je exit
	cmp al, 20h
	je next
	mov ah, 0
	sub al, 30h
	push ax
	mov ax, word ptr inbuff[0]
	mov bx, 10
	mul bx
	pop dx
	add ax, dx
	mov word ptr inbuff[0], ax
	jmp cin
next:
	pop bx
	mov ax, word ptr inbuff[0]
	mov word ptr rawdata[bx], ax
	add bx, 2
	inc word ptr count[0]
	cmp word ptr count[0], 20
	jb cin1
	jmp r
exit:
	pop bx
	mov ax, word ptr inbuff[0]
	mov word ptr rawdata[bx], ax
	add bx, 2
	inc word ptr count[0]
r:
	ret
input1 endp
;-------------------------------
;-------------------------------
input2 proc
	mov bx, 0
cin2:
	mov ah, 1
	int 21h
	
	cmp al, 0dh
	je exit
	sub al, 30h
	mov ah, 0
	mov word ptr rawdata[bx], ax
	add bx, 2
	inc word ptr count[0]
	cmp word ptr count[0], 20
	jb cin2
exit:
	ret
input2 endp
;-------------------------------
;-------------------------------
printseq proc
	mov cx, word ptr count[0]
	mov bx, 0
p:
	mov ax, word ptr rawdata[bx]
	push cx
	push bx
	call printf
	pop bx
	pop cx
	add bx, 2
	loop p
	ret
printseq endp
;-------------------------------
;-------------------------------
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
;-------------------------------
;-------------------------------

CODES ENDS
    END START
    