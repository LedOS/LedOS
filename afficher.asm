afficher:
    push ds
    ; mémoire video commence 0xB8000
    mov ax, 0xB800          ; initialise le selecteur de donnée
    mov ds, ax   
    ; un caractere sur 2 byte: code ascii, attributs
    mov byte [0], 'b'
    ; clignotement(1), bg(3), sur-intensité(1), couleur(3)
    mov byte [1], 0b10000111
    
    pop ds
    ret