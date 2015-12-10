; Exception 7 = Device-Not-Available
exc7:
    ; Charge l'ISR du timer dans l'IDT
    mov rbx, intExc7                ; offset de l'ISR
    
    mov rdi, IDT_base + (7*16)      ; rdi <- adresse de l'IDT + N° exception 
    mov rdx, rbx                    ; rdx <- l'offset de l'ISR
    shr rdx, 16                     ; dx <- decalage de 16 bits vers la droite 
    mov word [rdi], bx              ; bx contient les bits de poids faible
    mov word [rdi + 6], dx          ; et dx ceux de poids fort    
    ret

intExc7:
    mov esi, message_exc7
    call afficher 

    iretq
    

message_exc7:
    db " ALERTE EXCEPTION 7... ", 0