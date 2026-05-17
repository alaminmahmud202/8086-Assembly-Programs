.model small
.stack 100h

.data
    msg_x  db 'Enter x (0-9): $'
    msg_y  db 13,10,'Enter y (0-9): $'
    msg_z  db 13,10,'Enter z (0-9): $'
    msg_r  db 13,10,'2x+3y-7z = $'
    msg_neg db '-$'

.code
main proc
    mov ax, @data
    mov ds, ax

    ; --- x ??? ---
    mov ah, 09h
    lea dx, msg_x
    int 21h
    mov ah, 01h
    int 21h
    sub al, '0'
    mov bl, al       ; bl = x

    ; --- y ??? ---
    mov ah, 09h
    lea dx, msg_y
    int 21h
    mov ah, 01h
    int 21h
    sub al, '0'
    mov bh, al       ; bh = y

    ; --- z ??? ---
    mov ah, 09h
    lea dx, msg_z
    int 21h
    mov ah, 01h
    int 21h
    sub al, '0'
    mov cl, al       ; cl = z

    ; --- ????? ??? ---
    mov al, 2
    mul bl           ; ax = 2x
    mov si, ax

    mov al, 3
    mul bh           ; ax = 3y
    add si, ax       ; si = 2x + 3y

    mov al, 7
    mul cl           ; ax = 7z
    sub si, ax       ; si = 2x + 3y - 7z

    ; --- result print ---
    mov ah, 09h
    lea dx, msg_r
    int 21h

    call print_num

    mov ah, 4Ch
    int 21h
main endp

print_num proc
    test si, si
    jns pos_num
    push si
    mov ah, 09h
    lea dx, msg_neg
    int 21h
    pop si
    neg si
pos_num:
    mov ax, si
    mov bx, 10
    mov cx, 0
extract:
    mov dx, 0
    div bx
    push dx
    inc cx
    cmp ax, 0
    jne extract
print_digits:
    pop dx
    add dl, '0'
    mov ah, 02h
    int 21h
    loop print_digits
    ret
print_num endp

end main