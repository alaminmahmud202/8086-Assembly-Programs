; Exp. No. : 05
; Exp. Name: Equation Design - Evaluate: 2a + (3/9)b - 4c  =>  2a + b/3 - 4c
; ID_Name: 240242101_Al Amin Mahmud

; The equation is interpreted as: result = 2*a + (3/9)*b - 4*c
;                                        = 2*a + b/3 - 4*c
; Input: single-digit values for a, b, c
; Output: result (integer, handles negative via 2's complement display)

.MODEL SMALL
.STACK 100H

.DATA
    msg_a    DB 'Enter value of a (0-9): $'
    msg_b    DB 0AH, 0DH, 'Enter value of b (multiples of 3, e.g. 0,3,6,9): $'
    msg_c    DB 0AH, 0DH, 'Enter value of c (0-9): $'
    msg_res  DB 0AH, 0DH, 'Result (2a + b/3 - 4c) = $'
    msg_neg  DB '-$'
    newline  DB 0AH, 0DH, '$'

.CODE

; --- Procedure: Display AX as decimal ---
PRINT_NUM PROC
    ; Input: AX = unsigned number to print
    ; Uses stack to reverse digits
    MOV BX, 10
    MOV CX, 0

PUSH_DIGITS:
    MOV DX, 0
    DIV BX              ; AX = quotient, DX = remainder
    PUSH DX
    INC CX
    CMP AX, 0
    JNE PUSH_DIGITS

POP_DIGITS:
    POP DX
    ADD DL, 30H         ; Convert to ASCII
    MOV AH, 02H
    INT 21H
    LOOP POP_DIGITS
    RET
PRINT_NUM ENDP

MAIN PROC
    ; Initialize data segment
    MOV AX, @DATA
    MOV DS, AX

    ; --- Displaying prompt and reading a ---
    MOV AH, 09H
    LEA DX, msg_a
    INT 21H
    MOV AH, 01H
    INT 21H
    SUB AL, 30H
    MOV BL, AL          ; BL = a

    ; --- Read b ---
    MOV AH, 09H
    LEA DX, msg_b
    INT 21H
    MOV AH, 01H
    INT 21H
    SUB AL, 30H
    MOV BH, AL          ; BH = b

    ; --- Read c ---
    MOV AH, 09H
    LEA DX, msg_c
    INT 21H
    MOV AH, 01H
    INT 21H
    SUB AL, 30H
    MOV CL, AL          ; CL = c

    ; --- Working Procedure ---
    ; Compute 2*a
    MOV AL, BL
    MOV AH, 0
    MOV DL, 2
    MUL DL              ; AX = 2*a
    MOV SI, AX          ; SI = 2*a

    ; Compute b/3
    MOV AL, BH
    MOV AH, 0
    MOV DL, 3
    DIV DL              ; AL = b/3, AH = remainder
    MOV AH, 0
    ADD SI, AX          ; SI = 2*a + b/3

    ; Compute 4*c
    MOV AL, CL
    MOV AH, 0
    MOV DL, 4
    MUL DL              ; AX = 4*c

    ; result = SI - AX = 2a + b/3 - 4c
    MOV DI, SI
    SUB DI, AX          ; DI = result (may be negative)

    ; --- Displaying Input-Output ---
    MOV AH, 09H
    LEA DX, msg_res
    INT 21H

    ; Check if result is negative
    CMP DI, 0
    JGE POSITIVE

    ; Print minus sign
    MOV AH, 09H
    LEA DX, msg_neg
    INT 21H
    NEG DI              ; Make positive for printing

POSITIVE:
    MOV AX, DI
    CALL PRINT_NUM

EXIT:
    MOV AH, 09H
    LEA DX, newline
    INT 21H

    MOV AH, 4CH
    MOV AL, 00H
    INT 21H

MAIN ENDP
END MAIN
