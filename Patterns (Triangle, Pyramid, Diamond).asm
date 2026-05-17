.model small
.stack 100h

.data
    menu  db 'Choose: 1.Triangle  2.Pyramid  3.Diamond : $'
    star  db '*$'
    sp    db ' $'
    nl    db 13,10,'$'

.code
main proc
    mov ax, @data
    mov ds, ax

    mov ah, 09h
    lea dx, menu
    int 21h

    mov ah, 01h
    int 21h

    cmp al, '1'
    je triangle
    cmp al, '2'
    je pyramid
    cmp al, '3'
    je diamond
    jmp done

; ======= TRIANGLE =======
triangle:
    mov cl, 1
tri_row:
    cmp cl, 6
    jge done
    mov ch, cl
tri_star:
    mov ah, 09h
    lea dx, star
    int 21h
    dec ch
    jnz tri_star
    mov ah, 09h
    lea dx, nl
    int 21h
    inc cl
    jmp tri_row

; ======= PYRAMID =======
pyramid:
    mov cl, 1
pyr_row:
    cmp cl, 6
    jge done
    mov ch, 5
    sub ch, cl
pyr_sp:
    cmp ch, 0
    je pyr_stars
    mov ah, 09h
    lea dx, sp
    int 21h
    dec ch
    jmp pyr_sp
pyr_stars:
    mov ch, cl
    add ch, ch
    dec ch
pyr_st:
    mov ah, 09h
    lea dx, star
    int 21h
    dec ch
    jnz pyr_st
    mov ah, 09h
    lea dx, nl
    int 21h
    inc cl
    jmp pyr_row

; ======= DIAMOND =======
diamond:
    mov cl, 1
dia_top:
    cmp cl, 6
    jge dia_bottom
    mov ch, 5
    sub ch, cl
dia_sp1:
    cmp ch, 0
    je dia_st1
    mov ah, 09h
    lea dx, sp
    int 21h
    dec ch
    jmp dia_sp1
dia_st1:
    mov ch, cl
    add ch, ch
    dec ch
dia_star1:
    mov ah, 09h
    lea dx, star
    int 21h
    dec ch
    jnz dia_star1
    mov ah, 09h
    lea dx, nl
    int 21h
    inc cl
    jmp dia_top

dia_bottom:
    mov cl, 4
dia_bot_row:
    cmp cl, 0
    je done
    mov ch, 5
    sub ch, cl
dia_sp2:
    cmp ch, 0
    je dia_st2
    mov ah, 09h
    lea dx, sp
    int 21h
    dec ch
    jmp dia_sp2
dia_st2:
    mov ch, cl
    add ch, ch
    dec ch
dia_star2:
    mov ah, 09h
    lea dx, star
    int 21h
    dec ch
    jnz dia_star2
    mov ah, 09h
    lea dx, nl
    int 21h
    dec cl
    jmp dia_bot_row

done:
    mov ah, 4Ch
    int 21h
main endp
end main
