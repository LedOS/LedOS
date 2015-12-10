; Exception 1 = debug
exc1:
    ; Charge l'ISR du timer dans l'IDT
    mov rbx, intExc1                ; offset de l'ISR
    
    mov rdi, IDT_base + (1*16)      ; edi <- adresse de l'IDT + N° exception * 16 octets
    mov rdx, rbx                    ; edx <- l'offset de l'ISR
    shr rdx, 16                     ; dx <- decalage de 16 bits vers la droite 
    mov word [rdi], bx              ; bx contient les bits de poids faible
    mov word [rdi + 6], dx          ; et dx ceux de poids fort    
    ret

intExc1:
    mov esi, message_exc1
    call afficher 

    iretq
    

message_exc1:
    db " ALERTE EXCEPTION 1... ", 0