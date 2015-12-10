%define vecteur_pic1 0x20
%define vecteur_pic2 0x70
%define PIC1_COMMAND 0x20
%define PIC1_DATA 0x21
%define PIC2_COMMAND 0xA0
%define PIC2_DATA 0xA1

pic_message_ok:
    db " 8259PIC ok...", 0
pic_message_masquer:
    db " 8259PIC masquer ok...", 0

init_pic:
    push rax
    mov al, 0x11 ; Initialisation de ICW1
    out PIC1_COMMAND, al ; maître
    out PIC2_COMMAND, al ; esclave
    jmp icw2
icw2:
    mov al, vecteur_pic1 ; Initialisation de ICW2
    out PIC1_DATA, al ; maître, vecteur de départ = 32
    mov al, vecteur_pic2
    out PIC2_DATA, al ; esclave, vecteur de départ = 96
    jmp icw3
icw3:
    mov al, 0x04 ; initialisation de ICW3
    out PIC1_DATA, al
    mov al, 0x02 ; esclave
    out PIC2_DATA, al
    jmp icw4
icw4:
    mov al, 0x05 ; initialisation de ICW4
    out PIC1_DATA, al
    mov al, 0x01 ; esclave
    out PIC2_DATA, al  
    pop rax 
    ;ret

masquer_pic:
    ; 1 = masquer irq , 0 = activer irq
    push rax
    mov al, 0xfd  ; desactive les irq sauf l'irq clavier
    out PIC1_DATA, al
    out PIC2_DATA, al   
    pop rax
    ret
