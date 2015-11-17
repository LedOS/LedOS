afficher32:
    push eax
    ; mémoire video text couleur commence 0xB8000
    mov edi, 0xB8000        ; edi <- 0xB8000
    cld                     ; clear D(irection) incrémente si/di
    mov eax, 0
    
next32:
    ; un caractere sur 2 byte: code ascii, attributs
    movsb                   ; [edi] <- [esi] ; edi=+1 ; esi=+1
    ; clignotement(1), bg(3), sur-intensité(1), couleur(3)
    mov byte [edi], 0b00000111
    cmp eax, [esi]           ; si [esi] = 0 alors fin de chaine
    jz fin32
    inc edi
    jmp next32
    
fin32:
    pop eax    
    ret