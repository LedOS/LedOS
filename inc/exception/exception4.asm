; Exception 4 = Overflow
exc4:
    ; Charge l'ISR du timer dans l'IDT
    mov rbx, intExc4                ; offset de l'ISR
    
    mov rdi, IDT_base + (4*16)               ; edi <- adresse de l'IDT + N° exception
    mov rdx, rbx                    ; edx <- l'offset de l'ISR
    shr rdx, 16                     ; dx <- decalage de 16 bits vers la droite 
    mov word [rdi], bx              ; bx contient les bits de poids faible
    mov word [rdi + 6], dx          ; et dx ceux de poids fort    
    ret

intExc4:
    mov esi, message_exc4
    call afficher 

    iretq
    

message_exc4:
    db " ALERTE EXCEPTION 4... ", 0