; Exception 2 = Non-Maskable-Interrupt
exc2:
    ; Charge l'ISR du timer dans l'IDT
    mov rbx, intExc2                ; offset de l'ISR
    
    mov rdi, IDT_base + (2*16)      ; edi <- adresse de l'IDT + N° exception
    mov rdx, rbx                    ; edx <- l'offset de l'ISR
    shr rdx, 16                     ; dx <- decalage de 16 bits vers la droite 
    mov word [rdi], bx              ; bx contient les bits de poids faible
    mov word [rdi + 6], dx          ; et dx ceux de poids fort    
    ret

intExc2:
    mov esi, message_exc2
    call afficher 

    iretq
    

message_exc2:
    db " ALERTE EXCEPTION 2... ", 0