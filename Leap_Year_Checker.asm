; Exp. No. : 02
; Exp. Name: Loop and Label - Leap Year Checker
; ID_Name: 240242101_Al Amin Mahmud

.MODEL SMALL
.STACK 100H

.DATA
    msg1    DB 'Enter a year (4 digits): $'
    msg_leap  DB 0AH, 0DH, 'It is a Leap Year!$'
    msg_nleap DB 0AH, 0DH, 'It is NOT a Leap Year!$'

.CODE
MAIN PROC
    ; Initialize data segment
    MOV AX, @DATA
    MOV DS, AX

    ; Displaying prompt
    MOV AH, 09H
    LEA DX, msg1
    INT 21H

    ; Read 4-digit year, build year value in SI
    MOV SI, 0

    ; Digit 1 (thousands)
    MOV AH, 01H
    INT 21H
    SUB AL, 30H
    MOV AH, 0
    MOV SI, AX
    MOV BX, 10
    MOV AX, SI
    MUL BX
    MOV SI, AX

    ; Digit 2 (hundreds)
    MOV AH, 01H
    INT 21H
    SUB AL, 30H
    MOV AH, 0
    ADD SI, AX
    MOV AX, SI
    MUL BX
    MOV SI, AX

    ; Digit 3 (tens)
    MOV AH, 01H
    INT 21H
    SUB AL, 30H
    MOV AH, 0
    ADD SI, AX
    MOV AX, SI
    MUL BX
    MOV SI, AX

    ; Digit 4 (units)
    MOV AH, 01H
    INT 21H
    SUB AL, 30H
    MOV AH, 0
    ADD SI, AX

    ; SI = year value
    ; --- Working Procedure ---
    ; Leap year rule:
    ;   Divisible by 400  -> Leap
    ;   Divisible by 100  -> NOT Leap
    ;   Divisible by 4    -> Leap
    ;   Otherwise         -> NOT Leap

    ; Check divisible by 400
    MOV AX, SI
    MOV DX, 0
    MOV BX, 400
    DIV BX
    CMP DX, 0
    JE  LEAP

    ; Check divisible by 100
    MOV AX, SI
    MOV DX, 0
    MOV BX, 100
    DIV BX
    CMP DX, 0
    JE  NOT_LEAP

    ; Check divisible by 4
    MOV AX, SI
    MOV DX, 0
    MOV BX, 4
    DIV BX
    CMP DX, 0
    JE  LEAP
    JMP NOT_LEAP

LEAP:
    ; Displaying Input-Output
    MOV AH, 09H
    LEA DX, msg_leap
    INT 21H
    JMP EXIT

NOT_LEAP:
    ; Displaying Input-Output
    MOV AH, 09H
    LEA DX, msg_nleap
    INT 21H

EXIT:
    MOV AH, 4CH
    MOV AL, 00H
    INT 21H

MAIN ENDP
END MAIN
