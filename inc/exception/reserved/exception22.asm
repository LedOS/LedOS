; Exception 0 = timer
exc0:
    ; Charge l'ISR du timer dans l'IDT
    mov rbx, intExc0                ; offset de l'ISR
    
    mov rdi, IDT_base               ; edi <- adresse de l'IDT + N° exception
    mov rdx, rbx                    ; edx <- l'offset de l'ISR
    shr rdx, 16                     ; dx <- decalage de 16 bits vers la droite 
    mov word [rdi], bx              ; bx contient les bits de poids faible
    mov word [rdi + 6], dx          ; et dx ceux de poids fort    
    ret

intExc0:
    mov esi, message_exc0
    call afficher 

    iretq
    

message_exc0:
    db " ALERTE EXCEPTION 0... ", 0