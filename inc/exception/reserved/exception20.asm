; Exception 20 = reserved
exc20:
    ; Charge l'ISR du timer dans l'IDT
    mov rbx, intExc20                ; offset de l'ISR
    
    mov rdi, IDT_base + (20*16)      ; rdi <- adresse de l'IDT + N° exception 
    mov rdx, rbx                    ; rdx <- l'offset de l'ISR
    shr rdx, 16                     ; dx <- decalage de 16 bits vers la droite 
    mov word [rdi], bx              ; bx contient les bits de poids faible
    mov word [rdi + 6], dx          ; et dx ceux de poids fort    
    ret

intExc20:
    mov esi, message_exc20
    call afficher 

    iretq
    

message_exc20:
    db " ALERTE EXCEPTION 20... ", 0