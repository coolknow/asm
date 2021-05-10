DATAS SEGMENT
    rawdata dw 20 dup(?)
    count dw 0
DATAS ENDS

STACKS SEGMENT
    ;此处输入堆栈段代码
STACKS ENDS

CODES SEGMENT
    ASSUME CS:CODES,DS:DATAS,SS:STACKS
START:
    MOV AX,DATAS
    MOV DS,AX
    
    call input
    call printseq
    
    MOV AH,4CH
    INT 21H

;-------------------------------
;-------------------------------
input proc
	mov bx, 0
cin:
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
	jb cin
exit:
	ret
input endp
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


