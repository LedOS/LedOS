; Exception 6 = Invalid-Opcode
exc6:
    ; Charge l'ISR du timer dans l'IDT
    mov rbx, intExc6                ; offset de l'ISR
    
    mov rdi, IDT_base + (6*16)               ; edi <- adresse de l'IDT + N° exception
    mov rdx, rbx                    ; edx <- l'offset de l'ISR
    shr rdx, 16                     ; dx <- decalage de 16 bits vers la droite 
    mov word [rdi], bx              ; bx contient les bits de poids faible
    mov word [rdi + 6], dx          ; et dx ceux de poids fort    
    ret

intExc6:
    mov esi, message_exc6
    call afficher 

    iretq
    

message_exc6:
    db " ALERTE EXCEPTION 6... ", 0