org 100h
mov ax,0000h           
mov ds,ax   
mov bh,00h
mov [5002h],55h ;seconds
mov [5001h],59h ;minutes
mov [5000h],23h ;hours  
mov [5003h],25h ;date
mov [5004h],09h ;day
mov [5005h],17h ;year
mov [6002h],058 ;:
mov [6005h],058 ;:
mov [6008h],32  ;SPACE
mov [600bh],47  ;/
mov [600eh],47  ;/
mov [6011h],32  ;Space
mov [7000h],77  ;M
mov [7001h],79  ;O 
mov [7002h],84  ;T
mov [7003h],85  ;U
mov [7004h],87  ;W
mov [7005h],69  ;E
mov [7006h],84  ;T
mov [7007h],72  ;H
mov [7008h],70  ;F
mov [7009h],82  ;R
mov [700ah],83  ;S
mov [700bh],65  ;A
mov [700ch],83  ;S
mov [700dh],85  ;U

call set_video_mode;main  
loop1:
call timer
call clock_logic
call day_logic 
call bcd_ascii
call print 
call set_screen
jmp loop1 
set_video_mode proc near ;Set video mode t 40X25 char
    mov ah,0
    mov al,00
    int 10h  
    mov ax,1003h
    mov bx,0
    int 10h 
    ret 
set_video_mode endp

timer proc near   ; Timer Software Interept
    mov cx,00h    ;actually 0f
    mov dx, 7000h
    mov ah, 86h
    int 15h  
    
    ret
timer endp         

clock_logic proc near ;Clock_logic    
    mov al,[5002h]
    add al,01h
    daa
    mov [5002h],al
    cmp al,60h
    jnz l1
    mov [5002h],00h  
    mov al,[5001h]
    add al,01h
    daa
    mov [5001h],al
    cmp al,60h
    jnz l1
    mov [5001h],00h
    mov al,[5000h]
    add al,01h
    daa
    mov [5000h],al
    cmp al,24h
    jnz l1
    mov [5000h],00h 
    inc bh 
    mov al,[5003h]
    add al,01h
    daa
    mov [5003h,al
    cmp al,30h
    jnz l1
    mov [5003h],00h  
    mov al,[5004h]
    add al,01h
    daa
    mov [5004h,al
    cmp al,12h
    jnz l1
    mov [5004h],00h
    mov al,[5005h]
    add al,01h
    daa
    mov [5005h,al
    cmp al,99h
    jnz l1
    mov [5005h],00h   
    l1:ret
clock_logic endp  
day_logic proc near  ; day logic 
    mov si,6012h
    cmp bh,00h
    je lm
    cmp bh,01h
    je lt
    lm:
    mov al,[7000h]
    mov [si],al
    inc  si
    mov al,[7001h]
    mov [si],al
    jmp ljmp
    lt:
    mov al,[7002h]
    mov [si],al
    inc  si
    mov al,[7003h]
    mov [si],al
    ljmp:
    ret
day_logic endp

bcd_ascii proc near  ;bcd to ascii conversion
    mov dl,06h                       
    mov si,5000h
    mov di,6000h
    l2:
    mov al,[si]
    mov bl,al
    and al,0f0h
    mov cl,04h
    ror al,cl
    add al,30h
    mov [di],al
    inc di   
    and bl,0fh
    add bl,30h
    mov [di],bl
    inc si
    inc di 
    inc di
    dec dl
    jnz l2
    ret 
bcd_ascii endp    

print proc near    ;sending charecters to screen
    mov si,6000h
    mov cl,14h 
    lprint:
    mov al,[si]
    inc si
    mov ah,0eh
    int 10h
    loop lprint
    ret
print endp

set_screen proc near   ;pointer position reset
    push bx
    mov dh,00h
    mov dl,00h
    mov bh,0h
    mov ah,02h
    int 10h
    pop bx
    ret
set_screen endp



