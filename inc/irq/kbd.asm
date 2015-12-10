; IRQ1 = clavier
char db 0   ; buffer ou mettre le dernier char tappé au clavier 

kbd:
    ; Charge l'ISR du timer dans l'IDT
    mov rbx, intClavier64           ; offset de l'interruption par defaut
    
    mov rdi, IDT64_base+vecteur_pic1*16; edi <- adresse de l'IDT + vecteur pic 1
    add rdi, 16                     ; 2éme vecteur
    mov rdx, rbx                    ; edx <- l'offset de l'int du timer
    shr rdx, 16                     ; dx <- decalage de 16 bits vers la droite 
    mov word [rdi], bx              ; bx contient les bits de poids faible
    mov word [rdi + 6], dx          ; et dx ceux de poids fort    
    ret

intClavier64:
get_char64:
    xor eax, eax
    in al, 0x60                     ; lit le scancode
    
    cmp al, 0x80                    ; si a > 80 alors touche relaché
    ja fin_intClavier64
    
    mov ebx, sc_ascii64             ; ebx <- @ de la table scancode <-> ascii
    add ebx, eax                    ; ebx <- + offset du scancode tapé
    mov r8b, byte [ebx]             ; r8b <- code ascii 
    call shell_kbd                  ; passe le code ascii au shell

fin_intClavier64:
    mov al, 0x20                    ; EOI (End Of Interrupt)
    out 0x20, al                    ; qu'on envoie au PIC
    
    iretq
    
message_kbd:
    db " ALERTE CLAVIER 64... ", 0
sc_ascii64:
    db ' E1234567890'
    db '-=BTazertyuiop'
    db '[]ECqsdfghjklm'
    db '""S\wxcvbn,;:!'
    db 'S*A LFFFFFFFFFF'
    db 'LL789-456+1230.'
    db '    FF'