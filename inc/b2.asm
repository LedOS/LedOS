; Affiche un nombre en binaire
; Nombre à afficher dans eax

nombre2 db '00000000000000000000000000000000', 0 ; registre 32 bits
b2:
    pushAll   
    mov edi, nombre2
    mov ecx, 32          ; opération sur registre 32 bits
next_b2: 
    shl eax, 1          ; décalage vers la gauche 
    jc  b2_1            ; CF = bit sortant
    mov byte [edi], '0'
    jmp b2_test
b2_1:
    mov byte [edi], '1'
b2_test:                ; test si fin de boucle (ecx=0)
    inc edi
    dec ecx
    cmp ecx, 0
    jnz next_b2

fin_b2:
    mov esi, nombre2
    call afficher
    popAll
    ret