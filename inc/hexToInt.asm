; Hex > binaire (entier)
; Retour: nombre entier dans r9

hexToInt:
    ; Nombre hexadécimal dans rsi
    pushAll
    xor r9, r9
    xor rax, rax
    xchg bx, bx
next_hexToInt:
    mov al, byte [rsi]       ; al <- un caractere hexa en ascii   
    cmp al, '9'              ; si al < '9' alors c'est une lettre a..f
    ja hexToInt_lettre
    sub al, '0'              ; al <- valeur du caractere hexa 
    jmp hexToInt_a 
hexToInt_lettre:
    sub al, 'a'-10            ; al <- valeur du caractere hexa
hexToInt_a:
    add r9b, al              ; r9b <- al
    inc rsi                  ; rsi <- +1
    cmp byte [rsi], 0        ; si [rsi] = 0 
    jz fin_hexToInt          ; alors fin
    shl r9, 4                ; sinon décalage de r9 de 4 vers la gauche
    jmp next_hexToInt
fin_hexToInt:
    xchg bx, bx
    popAll
    ret