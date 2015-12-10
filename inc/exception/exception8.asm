; Exception 8 = Double-Fault
exc8:
    ; Charge l'ISR du timer dans l'IDT
    mov rbx, intExc8                ; offset de l'ISR
    
    mov rdi, IDT_base + (8*16)      ; rdi <- adresse de l'IDT + N° exception 
    mov rdx, rbx                    ; rdx <- l'offset de l'ISR
    shr rdx, 16                     ; dx <- decalage de 16 bits vers la droite 
    mov word [rdi], bx              ; bx contient les bits de poids faible
    mov word [rdi + 6], dx          ; et dx ceux de poids fort    
    ret

intExc8:
    mov esi, message_exc8
    call afficher 

    iretq
    

message_exc8:
    db " ALERTE EXCEPTION 8... ", 0