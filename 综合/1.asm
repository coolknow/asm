DATAS SEGMENT
    IM DB 'PLEASE ENTER NUMBER (3->6): ','$'
    nb dw 0
    ld DB 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    sz dw 0
    nl db 0ah,0dh,'$'
    tm db 0,0
DATAS ENDS

STACKS SEGMENT
    ;此处输入堆栈段代码
STACKS ENDS

CODES SEGMENT
    ASSUME CS:CODES,DS:DATAS,SS:STACKS
START:
    MOV AX,DATAS
    MOV DS,AX
    
    LEA DX, OFFSET IM
    MOV AH,9
    INT 21H
    
    mov ah, 1
    int 21h
    
    sub al, 30h
    mov ah,0
    mov word ptr nb[0], ax
    mov word ptr sz[0], ax
    sub word ptr sz[0], 1
    
    mov bl, 2
    div bl
    
    mov byte ptr tm[0], al
    mov byte ptr tm[1], ah
    
    mov ah, 0
    mov cx, ax
    mov bx, 0
    mov si, 0
    mov al, 1
sc:
	push cx
    call right
	call down
	call left
	call up
	inc bx
	add si, 6
	sub word ptr sz[0], 2
	pop cx
	loop sc
	
	cmp byte ptr tm[1], 1
	jne sit
	mov byte ptr ld[bx+si], al

sit:
    lea dx, offset nl
    mov ah,9
    int 21h
    
    mov cx, word ptr nb[0]
    mov bx, 0
    mov si, 0
outp:
	push cx
	mov cx, word ptr nb[0]
inp:
	mov al, byte ptr ld[bx+si]
	;add al, 30h
	;mov dl,al
	;mov ah, 2
	;int 21h
	mov ah,0
	push cx
	push bx
SHOW:
   	MOV CX,0
SPL:
    MOV DX, 0
	MOV bx, 10
	DIV bx
	ADD DX, 30H
	PUSH DX
	INC CX
	CMP AX, 0
	JNE SPL
	
	cmp cx, 1
	jne ui
	mov dl, 20h
	MOV AH, 02H
	INT 21H
ui:
	mov dl, 20h
	MOV AH, 02H
	INT 21H
	
PRINT:
	POP DX
	MOV AH, 02H
	INT 21H
	LOOP PRINT
	
	pop bx
	pop cx
	inc bx
	loop inp
	
	lea dx, offset nl
    mov ah,9
    int 21h
    
	add si, 6
	mov bx, 0
	pop cx
	loop outp

exit:
    mov ah, 4ch
	mov al, 0
	int 21h

right proc
	mov cx, sz[0]
lopr:
	mov byte ptr ld[bx+si], al
	inc al
	inc bx
	loop lopr
	ret
right endp

down proc
	mov cx, sz[0]
lopd:
	mov byte ptr ld[bx+si], al
	inc al
	add si, 6
	loop lopd
	ret
down endp

left proc
	mov cx, sz[0]
lopl:
	mov byte ptr ld[bx+si], al
	inc al
	dec bx
	loop lopl
	ret
left endp

up proc
	mov cx, sz[0]
lopu:
	mov byte ptr ld[bx+si], al
	inc al
	sub si,6
	loop lopu
	ret
up endp

CODES ENDS
    END START
