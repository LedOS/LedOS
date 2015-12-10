; IDT de 0x1000 à 0x2000
%define IDT64_base 0x1000
%define IDT_base 0x1000

%include "inc/irq/IRQ64.asm"
%include "inc/exception/exception64.asm"

IDTR64:
    dw 16*256              ; limite sur 16 bits (0-15)
    dq IDT64_base          ; base sur 64 bits   (16-47)

IDT64: ; 16 octet
idt_gate64: 
    ; offset[0:15]
    dw 0
    ; selecteur de segment de code
    dw 0x8
    ; 000, 00 IST 
    db 0x0 
    ; P DPL S D type            ; D=0
    db 10001110b                ; type-110=interrupt gate
    ; offset[16:31]
    dw 0
    ; offset [32:61]
    dd 0
    ; reserved
    dd 0
IDT64_limite:

idt64_message_ok:
    db ' IDT 64 ok... ', 0

initIDT64:
    ; Rempli l'IDT avec l'interruption par défaut
    mov rbx, intPICDefaut64         ; offset de l'interruption par defaut
    mov rcx, 256                    ; Nombre de vecteurs d'interruption
    
    mov rdi, IDT64_base             ; edi <- adresse de l'IDT
    mov rdx, rbx                    ; edx <- l'offset de l'int par defaut
    shr rdx, 16                     ; dx <- decalage de 16 bits vers la droite 
    mov word [idt_gate64], bx       ; bx contient les bits de poids faible
    mov word [idt_gate64 + 6], dx   ; et dx ceux de poids fort
    mov rsi, idt_gate64             ; esi <- idt_gate (descripteur par defaut)
idt_next64:
    mov rax, qword [rsi]            ; eax <- [rsi]
    mov qword [rdi], rax            ; [edi] <- eax , les 8 premier octet
    add rdi, 8                      ; edi + 4
    mov rax, qword [rsi+8]          ; les 8 dernier octets 
    mov qword [rdi], rax
    add rdi, 8                      ; descripteur suivant  
    
    dec rcx
    jnz idt_next64
    
    ; Initialisation des exception
    call initException
    ; Initilaisation des IRQ
    call timer
    call kbd
    
    ret

intDefaut64:
    mov esi, message_exception64
    call afficher 
    iretq

intPICDefaut64:
    mov esi, message_int64
    call afficher
    mov al, 0x20 ; EOI (End Of Interrupt)
    out 0x20, al ; qu'on envoie au PIC
    iretq
    
message_int64:
    db " ALERTE INTERRUPTION 64... ", 0
    
message_exception64:
    db " ALERTE EXCEPTION 64... ", 0