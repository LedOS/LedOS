; Exception 19 = SIMD Floating-Point #XF SSE floating-point instructions
exc19:
    ; Charge l'ISR du timer dans l'IDT
    mov rbx, intExc19                ; offset de l'ISR
    
    mov rdi, IDT_base + (19*16)      ; rdi <- adresse de l'IDT + N° exception 
    mov rdx, rbx                    ; rdx <- l'offset de l'ISR
    shr rdx, 16                     ; dx <- decalage de 16 bits vers la droite 
    mov word [rdi], bx              ; bx contient les bits de poids faible
    mov word [rdi + 6], dx          ; et dx ceux de poids fort    
    ret

intExc19:
    mov esi, message_exc19
    call afficher 

    iretq
    

message_exc19:
    db " ALERTE EXCEPTION 19... ", 0