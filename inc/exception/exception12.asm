; Exception 12 = Stack
exc12:
    ; Charge l'ISR du timer dans l'IDT
    mov rbx, intExc12                ; offset de l'ISR
    
    mov rdi, IDT_base + (12*16)      ; rdi <- adresse de l'IDT + N° exception 
    mov rdx, rbx                    ; rdx <- l'offset de l'ISR
    shr rdx, 16                     ; dx <- decalage de 16 bits vers la droite 
    mov word [rdi], bx              ; bx contient les bits de poids faible
    mov word [rdi + 6], dx          ; et dx ceux de poids fort    
    ret

intExc12:
    mov esi, message_exc12
    call afficher 

    iretq
    

message_exc12:
    db " ALERTE EXCEPTION 12... ", 0