; IRQ0 = timer

buff_time dq 1                      ; nombre de fois que l'ISR a etait appellé
                                     
timer:
    ; Charge l'ISR du timer dans l'IDT
    mov rbx, intTimer64             ; offset de l'interruption par defaut
    
    mov rdi, IDT64_base+vecteur_pic1*16; edi <- adresse de l'IDT + vecteur pic 1
    mov rdx, rbx                    ; edx <- l'offset de l'int du timer
    shr rdx, 16                     ; dx <- decalage de 16 bits vers la droite 
    mov word [edi], bx              ; bx contient les bits de poids faible
    mov word [edi + 6], dx          ; et dx ceux de poids fort    
    ret

intTimer64:

    mov eax, [buff_time]
    inc eax
    mov [buff_time], eax
    
    call b2a10
    ; recoit l'@ de la chaine à afficher dans rsi
    mov rsi, nombre
    mov rdi, 0xb8000        ; edi <- @ base video   
    cld                      ; clear D(irection) = incrémente si/di    
Tnext_char:
    ; un caractere sur 2 byte: code ascii, attributs
    movsb                   ; [rdi] <- [rsi] ; rdi=+1 ; rsi=+1
    ; clignotement(1), bg(3), sur-intensité(1), couleur(3)
    mov byte [rdi], 0b00000111
    inc rdi
    cmp byte [rsi], 0      ; si [esi] = 0 alors fin de chaine
    jz Tfin
    jmp Tnext_char       
Tfin:

    mov al, 0x20 ; EOI (End Of Interrupt)
    out 0x20, al ; qu'on envoie au PIC
    iretq
    

message_timer:
    db " ALERTE TIMER... ", 0