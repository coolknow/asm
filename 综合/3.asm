DATAS SEGMENT
    tip1 db 'Your Answer is: ','$'
    tip2 db 'Correct','$'
    tip3 db 'Wrong','$'
    tip4 db 'R-next,Q-quit: ','$'
    tip5 db 'Input equation: ','$'
    nl db 0ah, 0dh,'$'
    data dw 0,0
    sum dw 0
    buff dw 0
DATAS ENDS

STACKS SEGMENT
    ;此处输入堆栈段代码
STACKS ENDS

CODES SEGMENT
    ASSUME CS:CODES,DS:DATAS,SS:STACKS
START:
    MOV AX,DATAS
    MOV DS,AX
    
    lea dx, offset tip5
    call tipf
    
    call inputeqt

    call sumf
    
    ;lea dx, offset tip3
    ;call tipf
    
    mov ax, word ptr sum[0]
    call printf
    
    call printdata
    
m3:
    lea dx, offset tip1
    call tipf
    call inputOnce
    call printf
    cmp ax, word ptr sum[0]
    je m1
    lea dx, offset tip3
	call tipf
	jmp m3
m1:
	lea dx, offset tip2
	call tipf
	jmp m2
m2:
	lea dx, offset tip4
	call tipf
	mov ah, 1
	int 21h
	cmp al, 'R'
	je start
	
	
    
    
    MOV AH,4CH
    INT 21H

;-------------------------------------------
;------------------------------------------- 
inputOnce proc ;; value is in AX
	mov ax, 0
l1:
	push ax
	mov ah, 1
	int 21h
	cmp al, 0dh
	je l2
	sub al, 30h
	mov ah, 0
	mov word ptr buff[0], ax
	pop ax
	mov bx, 10
	mul bx
	add ax, word ptr buff[0]
	jmp l1
l2:
	pop ax
	ret
inputOnce endp
;-------------------------------------------
;------------------------------------------- 
tipf proc ;; lea dx, offset [tipName]
	push ax
	mov ah, 9
	int 21h
	pop ax
	ret
tipf endp
;-------------------------------------------
;------------------------------------------- 
sumf proc
	push cx
	push ax
	push bx
	mov cx, 2
	mov ax, 0
	mov bx, 0 
l1:
	add ax, word ptr data[bx]
	add bx, 2
	loop l1
	mov word ptr sum[0], ax
	pop bx
	pop ax
	pop cx
	ret
sumf endp
;-------------------------------------------
;------------------------------------------- 
inputeqt proc
	push ax
	push bx
	push si
	push dx
	mov word ptr data[0], 0
	mov word ptr data[2], 0
	mov si, 0
l2:
	mov ah, 1
	int 21h
	
	cmp al, '+'
	je l1
	
	cmp al, 0dh
	je l3
	
	;----------
	;----------
	sub al, 30h
	mov ah, 0
	push ax
	mov ax, word ptr data[si]
	mov bx, 10
	mul bx
	pop dx
	add ax, dx
	mov word ptr data[si], ax
	;----------
	;----------
	jmp l2
l1:
	add si, 2
	jmp l2

l3:
	pop dx
	pop si
	pop bx
	pop ax
	ret
inputeqt endp
;-------------------------------------------
;------------------------------------------- 
printdata proc
	push cx
	push bx
	push ax
	mov cx, 2
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
;-------------------------------------------
;------------------------------------------- 
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
;-------------------------------------------
;------------------------------------------- 
CODES ENDS
    END START
