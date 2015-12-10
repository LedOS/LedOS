; Exception 5 = Bound-Range
exc5:
    ; Charge l'ISR du timer dans l'IDT
    mov rbx, intExc5                ; offset de l'ISR
    
    mov rdi, IDT_base + (5*16)               ; edi <- adresse de l'IDT + N° exception
    mov rdx, rbx                    ; edx <- l'offset de l'ISR
    shr rdx, 16                     ; dx <- decalage de 16 bits vers la droite 
    mov word [rdi], bx              ; bx contient les bits de poids faible
    mov word [rdi + 6], dx          ; et dx ceux de poids fort    
    ret

intExc5:
    mov esi, message_exc5
    call afficher 

    iretq
    

message_exc5:
    db " ALERTE EXCEPTION 5... ", 0