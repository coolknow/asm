data segment
	mess db 'input q-exit', '$'
	info db	'insert a string (4 chars max): ', '$'
   mess2 db 'output is : ', '$'
      of db 'input overflow','$'
	 num db ?
  string db 5 dup(?)
	  nl db 0ah,0dh,'$'
data ends

code segment
		assume cs:code,ds:data
	
start:	
		mov ax, data ; 设置 ds 指向 data 段
		mov ds, ax
		
		lea dx, offset mess ; 打印mess
		mov ah, 9
		int 21h
		
		lea dx, offset nl ; new line
		mov ah, 9
		int 21h
		
  		lea dx, offset info ; 打印info
		mov ah, 9
		int 21h
		
		mov dl, 0
		mov dh, 0
		mov cx, 5 ; 	TODO:　此处可以改成软编码，即等于string的长度
		
insert:
		mov ah, 1 ;单字符读入
		int 21h
		cmp al, 0dh ;判断,如果为回车,则结束读入
		je finrd
		cmp al, 08h ;如果是退格,则不保存
		jne write
		lea bx, offset string
		dec dl
		inc cx
		add bx, dx
		mov byte ptr [bx], 0
		jmp insert

write:
		lea bx, offset string
		add bx, dx
		mov byte ptr [bx], al ;将之前读入的字符写入string中
		inc dl
		loop insert ;继续读入
		
		lea dx, offset nl ; new line
		mov ah, 9
		int 21h
		
		lea dx, offset of ; 打印input of提示
		mov ah, 9
		int 21h
		
		lea dx, offset nl ; new line
		mov ah, 9
		int 21h
		
		lea dx, offset nl ; new line
		mov ah, 9
		int 21h
		
		jmp start ;输入若超界，则重新读入

finrd:	
		cmp string, 'q'
		je exit
		mov bx, offset num
		mov byte ptr [bx], dl ;设置num,即字符串长度
		
		mov al, num
		mov ah, 0
		lea bx, string
		add bx, ax
		mov byte ptr [bx], '$'
		
		mov si, 0
		mov cl, num
		mov ch, 0
	s:	cmp string[si], 'A'
		jb d0
		cmp string[si], 'Z'
		jna cp2
		cmp string[si], 'a'
		jb d0
		cmp string[si], 'z'
		ja d0
	cp1:cmp string[si], 'w'
		jb ed
		sub string[si], 26
		jmp ed
	cp2:cmp string[si], 'W'
		jb ed
		sub string[si], 26
		
	ed: add string[si], 4
		
	d0: inc si
		loop s
		
		lea dx, offset mess2 ; 打印mess2
		mov ah, 9
		int 21h
		
		;lea dx, offset string ; 打印string
		;mov ah, 9
		;int 21h
		mov bx, offset num
		mov cl, [bx] ; 设置循环输出次数
		mov ch, 0

		mov bx, offset string
		mov si, 0
print:	
		mov dl, [bx+si] ;设置输出字符
		mov ah, 02h
		int 21h
		inc si
		loop print
		
		
		
		lea dx, offset nl ; new line
		mov ah, 9
		int 21h
		
		lea dx, offset nl ; new line
		mov ah, 9
		int 21h
		
		jmp start
		
		
		
   exit:mov ah, 4ch ; return 0
		mov al, 0
		int 21h

code ends

end start

