DATAS SEGMENT
	db '1','0','0','0'
	db 1,0,0,0
	dw 1000
	db 10,00
 nl db 0AH,0DH,'$'
DATAS ENDS

CODES SEGMENT
    ASSUME CS:CODES,DS:DATAS
START:
    MOV AX,DATAS
    MOV DS,AX
    
INFORM:
	MOV AH, 08H
	INT 21H
	
	CMP AL, 0DH
	JNE INFORM
	
    
    MOV CX, 9000 ;初始化循环次数
    
COMPARE:
    ;COMPARE
    MOV AL, DS:[10]
    ADD AL, DS:[11]
    MUL AL
    CMP AX, DS:[8]
    JNE NEXT
    
    ;MOV DL, 40H
    ;MOV AH, 02H
    ;INT 21H
    
PRINT:
    MOV DL, DS:[4]
    ADD DL, 30H
    MOV AH, 02H
    INT 21H
    MOV DL, DS:[5]
    ADD DL, 30H
    MOV AH, 02H
    INT 21H
    MOV DL, DS:[6]
    ADD DL, 30H
    MOV AH, 02H
    INT 21H
    MOV DL, DS:[7]
    ADD DL, 30H
    MOV AH, 02H
    INT 21H

    ;NEWLINE
    LEA DX, OFFSET nl ; new line
	MOV AH, 09H
	INT 21H

    
NEXT:
    CALL S
    LOOP COMPARE
    
    
    MOV AH,4CH
    INT 21H
    
S PROC
	MOV BX, 03H
	CMP BYTE PTR [BX], '9'
	JNE DO
	MOV AL, '0'
	MOV [BX], AL
	MOV AL, 0
	MOV [BX+4], AL
	DEC BX
	
	CMP BYTE PTR [BX], '9'
	JNE DO
	MOV AL, '0'
	MOV [BX], AL
	MOV AL, 0
	MOV [BX+4], AL
	DEC BX
	
	CMP BYTE PTR [BX], '9'
	JNE DO
	MOV AL, '0'
	MOV [BX], AL
	MOV AL, 0
	MOV [BX+4], AL
	DEC BX
	
	CMP BYTE PTR [BX], '9'
	JNE DO
	MOV AL, '0'
	MOV [BX], AL
	MOV AL, 0
	MOV [BX+4], AL
DO:
	INC BYTE PTR [BX]
	INC BYTE PTR [BX+4]
	INC WORD PTR DS:[8]
	
	MOV AL, DS:[4]
    MOV BL, 10
    MUL BL
    ADD AL, DS:[5]
    MOV BYTE PTR DS:[10], AL
    
    MOV AL, DS:[6]
    MOV BL, 10
    MUL BL
    ADD AL, DS:[7]
    MOV BYTE PTR DS:[11], AL
	RET
S ENDP
	
CODES ENDS
    END START

