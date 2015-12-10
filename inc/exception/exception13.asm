; Exception 13 = General-Protection
exc13:
    ; Charge l'ISR du timer dans l'IDT
    mov rbx, intExc13                ; offset de l'ISR
    
    mov rdi, IDT_base + (13*16)      ; rdi <- adresse de l'IDT + N° exception 
    mov rdx, rbx                    ; rdx <- l'offset de l'ISR
    shr rdx, 16                     ; dx <- decalage de 16 bits vers la droite 
    mov word [rdi], bx              ; bx contient les bits de poids faible
    mov word [rdi + 6], dx          ; et dx ceux de poids fort    
    ret

intExc13:
    mov esi, message_exc13
    call afficher 

    cli
.p:
    hlt
    jmp .p
    iretq
    

message_exc13:
    db " ALERTE EXCEPTION 13 : General Protection... ", 0
