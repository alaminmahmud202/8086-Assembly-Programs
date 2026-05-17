.model small
.stack 100h

.data
    msg_b  db 'Enter b (0-9): $'
    msg_c  db 13,10,'Enter c (0-9): $'
    msg_r  db 13,10,'4c - 3b = $'
    msg_neg db '-$'

.code
main proc
    mov ax, @data
    mov ds, ax

    ; --- b ??? ---
    mov ah, 09h
    lea dx, msg_b
    int 21h
    mov ah, 01h
    int 21h
    sub al, '0'
    mov bl, al       ; bl = b

    ; --- c ??? ---
    mov ah, 09h
    lea dx, msg_c
    int 21h
    mov ah, 01h
    int 21h
    sub al, '0'
    mov bh, al       ; bh = c

    ; --- ????? ??? ---
    mov al, 4
    mul bh           ; ax = 4c
    mov si, ax

    mov al, 3
    mul bl           ; ax = 3b
    sub si, ax       ; si = 4c - 3b

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