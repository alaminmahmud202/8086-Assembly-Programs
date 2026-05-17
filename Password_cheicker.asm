.model small
.stack 100h

.data
    msg1  db 'Enter password: $'
    ok    db 13,10,'OK - Strong password!$'
    e_len db 13,10,'ERROR: Length must be 6-20 chars$'
    e_up  db 13,10,'ERROR: Missing uppercase letter$'
    e_low db 13,10,'ERROR: Missing lowercase letter$'
    e_dig db 13,10,'ERROR: Missing digit$'
    buf   db 30, 0, 30 dup(0)

.code
main proc
    mov ax, @data
    mov ds, ax

    mov ah, 09h
    lea dx, msg1
    int 21h

    mov ah, 0Ah
    lea dx, buf
    int 21h

    mov bl, buf+1
    lea si, buf+2

    cmp bl, 6
    jl bad_len
    cmp bl, 20
    jg bad_len
    jmp chk_chars

bad_len:
    mov ah, 09h
    lea dx, e_len
    int 21h
    jmp done

chk_chars:
    mov ch, 0
    mov cl, 0
    mov dh, 0
    mov bh, 0

loop1:
    cmp bh, bl
    jge after_loop
    mov al, [si]
    inc si
    inc bh

    cmp al, 'A'
    jl chk_low
    cmp al, 'Z'
    jg chk_low
    mov ch, 1
    jmp chk_dig

chk_low:
    cmp al, 'a'
    jl chk_dig
    cmp al, 'z'
    jg chk_dig
    mov cl, 1

chk_dig:
    cmp al, '0'
    jl next_char
    cmp al, '9'
    jg next_char
    mov dh, 1

next_char:
    jmp loop1

after_loop:
    cmp ch, 1
    jne bad_upper
    cmp cl, 1
    jne bad_lower
    cmp dh, 1
    jne bad_digit

    mov ah, 09h
    lea dx, ok
    int 21h
    jmp done

bad_upper:
    mov ah, 09h
    lea dx, e_up
    int 21h
    jmp done

bad_lower:
    mov ah, 09h
    lea dx, e_low
    int 21h
    jmp done

bad_digit:
    mov ah, 09h
    lea dx, e_dig
    int 21h

done:
    mov ah, 4Ch
    int 21h
main endp
end main