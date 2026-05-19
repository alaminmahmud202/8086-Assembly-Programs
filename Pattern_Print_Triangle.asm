; Exp. No. : 03
; Exp. Name: Pattern Print - Right-Angled Triangle using * 
; ID_Name: 240242101_Al Amin Mahmud

; Pattern output (for n=5):
; *
; * *
; * * *
; * * * *
; * * * * *

.MODEL SMALL
.STACK 100H

.DATA
    msg1   DB 'Enter number of rows (1-9): $'
    newline DB 0AH, 0DH, '$'
    star    DB '* $'
    space   DB ' $'

.CODE
MAIN PROC
    ; Initialize data segment
    MOV AX, @DATA
    MOV DS, AX

    ; Displaying prompt
    MOV AH, 09H
    LEA DX, msg1
    INT 21H

    ; Read single digit (n)
    MOV AH, 01H
    INT 21H
    SUB AL, 30H         ; Convert ASCII to number
    MOV BL, AL          ; BL = n (total rows)

    ; --- Working Procedure ---
    ; Outer loop: row counter (1 to n)
    MOV CL, 1           ; CL = current row number

OUTER_LOOP:
    CMP CL, BL
    JG  EXIT            ; if CL > n, done

    ; Print newline before each row (after first)
    MOV AH, 09H
    LEA DX, newline
    INT 21H

    ; Inner loop: print CL stars in this row
    MOV CH, CL          ; CH = inner loop counter

INNER_LOOP:
    CMP CH, 0
    JE  INNER_DONE

    ; Print '*'
    MOV AH, 02H
    MOV DL, '*'
    INT 21H

    ; Print ' '
    MOV AH, 02H
    MOV DL, ' '
    INT 21H

    DEC CH
    JMP INNER_LOOP

INNER_DONE:
    INC CL              ; Move to next row
    JMP OUTER_LOOP

EXIT:
    ; Final newline
    MOV AH, 09H
    LEA DX, newline
    INT 21H

    ; Terminate program
    MOV AH, 4CH
    MOV AL, 00H
    INT 21H

MAIN ENDP
END MAIN
