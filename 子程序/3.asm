DATAS SEGMENT
    rawdata dw 20 dup(?)
    data dw 20 dup(?)
   	cdcount dw 0
    count dw 0
    inbuff dw 0
    max dw 0
    min dw 0
    sum dw 0
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
    call setmax
    call setmin
    call sumf
    
    mov ax, word ptr max[0]
    call printf
    
    mov ax, word ptr min[0]
    call printf
    
    mov ax, word ptr sum[0]
    call printf
    
    call cleaner
    call printdata
    
    MOV AH,4CH
    INT 21H

;-------------------------------
;-------------------------------
printdata proc
	push cx
	push bx
	push ax
	mov cx, word ptr cdcount[0]
	mov bx, 0
p:
	mov ax, word ptr data[bx]
	push cx
	push bx
	call printf
	pop bx
	pop cx
	add bx, 2
	loop p
	pop ax
	pop bx
	pop cx
	ret
printdata endp
;-------------------------------
;-------------------------------
cleaner proc
	push ax
	push bx
	push cx

	mov bx, 0
	mov si, 0

	mov cx, word ptr count[0]
l4:
	push cx
	mov cx, 20
	mov ax, word ptr rawdata[bx]
l2:
	cmp ax, word ptr data[si]
	jne l1
	jmp l3
l1:
	add si, 2
	loop l2
	mov si, word ptr cdcount[0]
	add si, si
	mov word ptr data[si], ax
	inc word ptr cdcount[0]
l3:
	mov si, 0
	add bx, 2
	pop cx
	loop l4
	
	pop cx
	pop bx
	pop ax
	ret
cleaner endp
;-------------------------------
;-------------------------------
sumf proc
	push cx
	push ax
	push bx
	mov cx, word ptr count[0]
	mov ax, 0
	mov bx, 0 
l1:
	add ax, word ptr rawdata[bx]
	add bx, 2
	loop l1
	mov word ptr sum[0], ax
	pop bx
	pop ax
	pop cx
	ret
sumf endp
;-------------------------------
;-------------------------------
setmin proc
	push cx
	push ax
	push bx
	mov cx, word ptr count[0]
	mov ax, word ptr rawdata[0]
	mov bx, 0
l1:
	cmp ax, word ptr rawdata[bx]
	ja l2
	jmp lop
l2:
	mov ax, word ptr rawdata[bx]
lop:
	add bx, 2
	loop l1
exit:
	mov word ptr min[0], ax
	pop bx
	pop ax
	pop cx
	ret
setmin endp
;-------------------------------
;-------------------------------
setmax proc
	push cx
	push ax
	push bx
	mov cx, word ptr count[0]
	mov ax, word ptr rawdata[0]
	mov bx, 0
l1:
	cmp ax, word ptr rawdata[bx]
	jb l2
	jmp lop
l2:
	mov ax, word ptr rawdata[bx]
lop:
	add bx, 2
	loop l1
exit:
	mov word ptr max[0], ax
	pop bx
	pop ax
	pop cx
	ret
setmax endp
;-------------------------------
;-------------------------------
input1 proc
	push ax
	push bx
	push dx
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
	pop dx
	pop bx
	pop ax
	ret
input1 endp
;-------------------------------
;-------------------------------
input2 proc
	push ax
	push bx
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
	pop bx
	pop ax
	ret
input2 endp
;-------------------------------
;-------------------------------
printseq proc
	push cx
	push bx
	push ax
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
	pop ax
	pop bx
	pop cx
	ret
printseq endp
;-------------------------------
;-------------------------------
printf proc
	push cx
	push dx
	push bx
	push ax
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
	pop ax
	pop bx
	pop dx
	pop cx
	ret
printf endp
;-------------------------------
;-------------------------------

CODES ENDS
    END START
