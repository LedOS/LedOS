; mémoire video text couleur commence 0xB8000
curseur:
    dd  0xB8000
afficher:
    ; recoit l'@ de la chaine à afficher dans esi
    push eax
    mov edi, [curseur]      ; edi <- curseur
    cld                     ; clear D(irection) incrémente si/di
    mov eax, 0
    
next:
    ; un caractere sur 2 byte: code ascii, attributs
    movsb                   ; [edi] <- [esi] ; edi=+1 ; esi=+1
    ; clignotement(1), bg(3), sur-intensité(1), couleur(3)
    mov byte [edi], 0b00000111
    inc edi
    cmp byte al, [esi]      ; si [esi] = 0 alors fin de chaine
    jz fin
    jmp next
    
fin:
    mov [curseur], edi
    pop eax    
    ret