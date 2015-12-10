shell_buffer dq 0,0,0        ; buffer commande
shell_buffer_cur db 0        ; curseur
shell_somme_buffer dq 0      ; retenu pour calcule de la some
shell_string db 'LedOS#: ', 0; chaine à afficher en début de ligne
c_mmap db 'mmap', 0
c_pci db 'lspci', 0
c_hello db 'hello', 0
    
shell_kbd:
    ; Recoit un caractere tappé au clavier dans r8b
    pushAll                   ; sauvegarde les registres
    xor rcx, rcx              ; rcx <- 0
    mov cl, [shell_buffer_cur]; cl <- curseur
    mov rdi, shell_buffer     ; rdi <- @shell_buffer
    add rdi, rcx              ; rdi <- @shell_buffer + position curseur
    cmp r8b, 'E'              ; si caractere = Entrée
    jnz shell_putc
    call shell_commande
    mov cl, 0                 ; curseur <- 15
    jmp shell_kbd_fin
shell_putc:
    mov [rdi], r8b           ; shell_buffer[cur] <- le caractere
    inc cl                   ; décrémente le curseur
    call afficher_char       ; afficher le caractere contenu dans r8b
shell_kbd_fin:
    mov [shell_buffer_cur], cl ; stock le curseur
    popAll
    ret   
 
shell_commande:
    ; rdi = commande
    pushAll
    printc 'E'
    mov rdi, shell_buffer 
shell_commande_pci:
    mov rsi, c_pci
    call compareStr
    cmp r8b, 0
    jnz shell_commande_hello
    call pci_detect
    jmp shell_commande_fin
shell_commande_hello:
    mov rsi, c_hello
    call compareStr
    cmp r8b, 0
    jnz shell_commande_mmap
    print ' Hello '
    jmp shell_commande_fin
shell_commande_mmap:
    mov rsi, c_mmap
    call compareStr
    cmp r8b, 0
    jnz shell_commande_non
    call mmap_read_readMemoryMap
    jmp shell_commande_fin
shell_commande_non:
    print ' Commande incorrecte '
shell_commande_fin:
    printc 'E'
    call shell_clear_buffer       ; shell_buffer <- 0x00*24
    mov rsi, shell_string         ; afficher la chaine de début de ligne
    call afficher
    popAll
    ret
    
shell_somme:
    ; Calcule la somme entre 2 nombre et affiche le résultat
    pushAll
    printc 'E'                    ; saut de ligne
    mov rsi, shell_buffer         ; rsi <- shell_buffer
    call hexToInt                 ; r9 <- nombre 
    mov rax, [shell_somme_buffer] ; rax <- la retenu
    add rax, r9                   ; rax <- rax + r9
    mov [shell_somme_buffer], rax ; stock le resultat
    print ' Somme : '
    call b2a16                    ; affiche le resultat
    call shell_clear_buffer       ; shell_buffer <- '0'*16
    popAll
    ret

shell_clear_buffer:
    ; remet le buffer shell_buffer à 0
    push rsi
    mov rsi, shell_buffer 
    xor r11, r11
    mov [rsi], r11
    mov [rsi+8], r11
    mov [rsi+16], r11  
    pop rsi
    ret