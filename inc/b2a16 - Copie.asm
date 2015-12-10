; Conversion base 2 vers 10:
; nombre à convertire dans rax

hex db '0123456789ABCDEF'
nombre16 db '0000000000000000', 0 ; 16 octet pour 64 bits

b2a16:
    pushAll
    xor rbx, rbx    
    mov rcx, 16     ; 64 bits qu'on traite par 4 bits
    mov rdi, nombre16+15 ; commence par le bit du poids le plus faible
b2a16_next:
    mov rsi, hex
    mov  bl, al
    and bl, 0x0F    ; 4 bits haut de bl <- 0
    add rsi, rbx
    mov dl, [rsi]
    mov [rdi], dl
    dec rdi
    shr rax, 4      ; 4 bits suivants
    loop b2a16_next   
b2a16_fin:
    mov rsi, nombre16
    call afficher
    popAll
    ret