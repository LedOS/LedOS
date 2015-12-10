; Exception 14 = Page-Fault
exc14:
    ; Charge l'ISR du timer dans l'IDT
    mov rbx, intExc14                ; offset de l'ISR
    
    mov rdi, IDT_base + (14*16)      ; rdi <- adresse de l'IDT + N° exception 
    mov rdx, rbx                    ; rdx <- l'offset de l'ISR
    shr rdx, 16                     ; dx <- decalage de 16 bits vers la droite 
    mov word [rdi], bx              ; bx contient les bits de poids faible
    mov word [rdi + 6], dx          ; et dx ceux de poids fort    
    ret

intExc14:
    mov esi, message_exc14
    call afficher 
    cli
.e14:
    hlt
    jmp .e14
    iretq
    

message_exc14:
    db " ALERTE EXCEPTION 14 : Page fault... ", 0
