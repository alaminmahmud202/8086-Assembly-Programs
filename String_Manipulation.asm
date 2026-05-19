; Exp. No. : 01
; Exp. Name: String Manipulation - Convert string to upper or lowercase
; ID_Name: 240242101_Al Amin Mahmud

.MODEL SMALL
.STACK 100H

.DATA
    msg1    DB 'Enter a string: $'
    msg2    DB 0AH, 0DH, 'Enter (U)ppercase or (L)owercase: $'
    msg3    DB 0AH, 0DH, 'Converted string: $'
    msg_err DB 0AH, 0DH, 'Invalid choice! $'
    buffer  DB 50, 0, 50 DUP('$')
    newline DB 0AH, 0DH, '$'

.CODE
MAIN PROC
    ; Initialize data segment
    MOV AX, @DATA
    MOV DS, AX

    ; Display "Enter a string:"
    MOV AH, 09H
    LEA DX, msg1
    INT 21H

    ; Input string using buffered input
    MOV AH, 0AH
    LEA DX, buffer
    INT 21H

    ; Display choice message
    MOV AH, 09H
    LEA DX, msg2
    INT 21H

    ; Read choice character
    MOV AH, 01H
    INT 21H
    MOV BL, AL         ; Save choice in BL

    ; Display output label
    MOV AH, 09H
    LEA DX, msg3
    INT 21H

    ; Get actual string length from buffer[1]
    LEA SI, buffer
    MOV CL, [SI+1]     ; CL = length of entered string
    MOV CH, 0
    ADD SI, 2          ; SI now points to actual string data

    ; Check choice
    CMP BL, 'U'
    JE  CONVERT_UPPER
    CMP BL, 'u'
    JE  CONVERT_UPPER
    CMP BL, 'L'
    JE  CONVERT_LOWER
    CMP BL, 'l'
    JE  CONVERT_LOWER
    JMP INVALID

CONVERT_UPPER:
    ; Loop to convert each character to uppercase
    MOV CX, 0
    LEA SI, buffer
    MOV CL, [SI+1]
    ADD SI, 2
UPPER_LOOP:
    JCXZ DONE_UPPER
    MOV AL, [SI]
    CMP AL, 'a'
    JL  SKIP_UPPER
    CMP AL, 'z'
    JG  SKIP_UPPER
    SUB AL, 32         ; Convert to uppercase (a-z -> A-Z)
SKIP_UPPER:
    ; Display character
    MOV AH, 02H
    MOV DL, AL
    INT 21H
    INC SI
    DEC CX
    JMP UPPER_LOOP
DONE_UPPER:
    JMP EXIT

CONVERT_LOWER:
    ; Loop to convert each character to lowercase
    MOV CX, 0
    LEA SI, buffer
    MOV CL, [SI+1]
    ADD SI, 2
LOWER_LOOP:
    JCXZ DONE_LOWER
    MOV AL, [SI]
    CMP AL, 'A'
    JL  SKIP_LOWER
    CMP AL, 'Z'
    JG  SKIP_LOWER
    ADD AL, 32         ; Convert to lowercase (A-Z -> a-z)
SKIP_LOWER:
    ; Display character
    MOV AH, 02H
    MOV DL, AL
    INT 21H
    INC SI
    DEC CX
    JMP LOWER_LOOP
DONE_LOWER:
    JMP EXIT

INVALID:
    MOV AH, 09H
    LEA DX, msg_err
    INT 21H

EXIT:
    ; Terminate program
    MOV AH, 4CH
    MOV AL, 00H
    INT 21H

MAIN ENDP
END MAIN
