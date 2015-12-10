; Exception 15 = Reserved
exc15:
    ; Charge l'ISR du timer dans l'IDT
    mov rbx, intExc15                ; offset de l'ISR
    
    mov rdi, IDT_base + (15*16)      ; rdi <- adresse de l'IDT + N° exception 
    mov rdx, rbx                    ; rdx <- l'offset de l'ISR
    shr rdx, 16                     ; dx <- decalage de 16 bits vers la droite 
    mov word [rdi], bx              ; bx contient les bits de poids faible
    mov word [rdi + 6], dx          ; et dx ceux de poids fort    
    ret

intExc15:
    mov esi, message_exc15
    call afficher 

    iretq
    

message_exc15:
    db " ALERTE EXCEPTION 15... ", 0