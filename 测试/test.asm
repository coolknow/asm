DATAS SEGMENT
    A dw 0,15,70,30,32,89,12,12,34,4,38,23,45,13,43,24,54,24,54,1
    Count EQU ($-A)/2  ;数组中元素的个数(字节)
    nl db 0ah,0dh,'$'
    spc db 20h,'$'
DATAS ENDS

STACKS SEGMENT
    ;此处输入堆栈段代码
STACKS ENDS

CODES SEGMENT
    ASSUME CS:CODES,DS:DATAS,SS:STACKS
START:
    MOV AX,DATAS
    MOV DS,AX
    
    call paixu
    call printdata

    MOV AH,4CH
    INT 21H

;-----------------------------------------
;----------------------------------------- 
space proc
	push ax
	push dx
	lea dx, offset spc
	mov ah, 9
	int 21h
	pop dx
	pop ax
	ret
space endp
;-----------------------------------------
;----------------------------------------- 
newline proc
	push dx
	push ax
	lea dx, offset nl
	mov ah, 9
	int 21h
	pop ax
	pop dx
	ret
newline endp
;-----------------------------------------
;-----------------------------------------
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
;-----------------------------------------
;-----------------------------------------
printdata proc
	push cx
	push bx
	push ax
	mov cx, Count-1
	mov bx, 0
p:
	mov ax, word ptr A[bx]
	push cx
	push bx
	call printf
	call space
	pop bx
	pop cx
	add bx, 2
	loop p
	pop ax
	pop bx
	pop cx
	ret
printdata endp
;-----------------------------------------
;-----------------------------------------
paixu proc
	MOV CX,Count-1      ;外层循环执行n-1次
I10:
	XOR SI,SI           ;异或清零
	XOR DI,DI        
	
I20:
	MOV AX,A[SI]
	MOV BX,A[SI+2]
	CMP AX,BX
	
	;比较AX和BX大小:AX<BX(小于转移)跳转I30,否则交换两数
	JL  I30
	MOV A[SI],BX
	MOV A[SI+2],AX     ;交换位置
	
I30:
	ADD SI,2           ;SI加2:移动一个数字位置
	INC DI             ;DI加1
	CMP DI,CX           
	
	;比较CX和DI大小:DI<CX转移,CX为外层循环总数n-1
	JB  I20
	Loop I10           ;循环调至I10,Loop循环CX执行一次减1
	ret
paixu endp
;-----------------------------------------
;-----------------------------------------
CODES ENDS
    END START

