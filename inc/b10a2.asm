; Conversion base 10 vers 2:

nombre10a2 db '00000000', 0
b10a2:
    ; Reçoit l'adresse de début du nombre b10 dans RSI
    pushAll
    xor cl, cl              ; compteur pour le nombre de chiffre
next_b10a2:
    cmp byte [rsi], 0       ; si [RSI] = 0 alors fin
    jz fin_conversion10a2
    mov al, [rsi]           ; al <- le caractere ascii du chiffre
    sub al, '0'             ; al <- le chiffre
    mov byte [nombre10a2], al ; stock le chiffre dans le buffer
    inc cl                 ; cl <- 1
    inc rsi                ; chiffre suivant
    jmp next_b10a2
passe2_b10a2:
    mov rsi, nombre10a2     ; rsi <- nombre10a2
    mov dl, byte [rsi]      ; dl <- [rsi]
    mov al, 10              ; multiplie par 10
    ; todo: al puissance position du chiffre...    

fin_conversion10a2:
    popAll
    ret