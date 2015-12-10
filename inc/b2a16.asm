; Conversion base 2 vers 10:

hex db '0123456789ABCDEF'
nombre16 dq 0,0,0 ; 16 octet pour 64 bits + 0 terminal

b2a16:
    ; nombre à convertire dans rax
    pushAll
    xor rbx, rbx             
    xor rcx, rcx             ; compteur pour le nombre de nibble
    mov rdi, nombre16        ; rdi <- buffer pour le nombre en hex
    mov [rdi], rbx           ; initialise le buffer a 0
    mov [rdi+8], rbx
b2a16_next:
    mov rsi, hex             ; rsi <- table de hex
    mov bl, al               ; bl <- al
    and bl, 0x0F             ; 4 bits haut de bl <- 0
    add rsi, rbx             ; selectionne le caractere hex
    push rsi                 ; empile l'adresse du caractere
    inc rcx                  ; incrémente le compteur 
    shr rax, 4               ; 4 bits suivants
    cmp rax, 0               ; si le nombre vaut 0 alors conversion fini
    jnz b2a16_next
b2a16_pop:
    pop rbx                  ; rbx <- adresse du caractere hex
    mov dl, [rbx]            ; dl <- le carctere hex
    mov [rdi], dl            ; nombre16[i] <- dl
    inc rdi                  ; i <- +1
    loop b2a16_pop 
  
b2a16_fin:
    mov rsi, nombre16
    call afficher
    popAll
    ret