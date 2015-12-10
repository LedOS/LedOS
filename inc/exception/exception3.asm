; Exception 3 = Breakpoint
exc3:
    ; Charge l'ISR du timer dans l'IDT
    mov rbx, intExc3                ; offset de l'ISR
    
    mov rdi, IDT_base + (3*16)               ; edi <- adresse de l'IDT + N° exception
    mov rdx, rbx                    ; edx <- l'offset de l'ISR
    shr rdx, 16                     ; dx <- decalage de 16 bits vers la droite 
    mov word [rdi], bx              ; bx contient les bits de poids faible
    mov word [rdi + 6], dx          ; et dx ceux de poids fort    
    ret

intExc3:
    mov esi, message_exc3
    call afficher 

    iretq
    

message_exc3:
    db " ALERTE EXCEPTION 3... ", 0