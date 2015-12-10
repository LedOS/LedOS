; Affiche les informations sur memoire
;Entrée: 24 octet
;8 octet = adresse de base
;8 octet = taille de la "region" (si 0, ignorer l'entrée)
;4 octet = "type" de la region
;->Type 1: RAM utilisable (normal)
;->Type 2: reservé - non utilisable
;->Type 3: ACPI reclaimable memory
;->Type 4: ACPI memoire non-volatile
;->Type 5: région contenant de la mauvaise mémoire.
;4 octet = ACPI 3.0 Extended Attributes bitfield (si 24 au lieu 20)
;-> Bit 0 si 0 l'entrée doit être ignorée.
;->Bit 1 si 1 l'entrée est non-volatile.
;->les 30 bits restant sont non défini. 

mmap_read_entete db ' Base - Taille - Type - APCI ', 0
mmap_type1 db ' Libre ', 0
mmap_type2 db ' Reserve ', 0
mmap_type3 db ' ACPI reclaimable ', 0
mmap_type4 db ' ACPI non-volatile ', 0
mmap_type5 db ' Mauvaise memoire ', 0
mmap_type0 db ' Inconu ', 0
%define mmap_buffer 0x500

mmap_read_readMemoryMap:
    ; Lit et affiche les données sur la mémoire
    ; Affiche l'entete à afficher: Base - Taille - Type - APCI
    pushAll
    mov r8b, 'E'            ; pour sauter une ligne
    call afficher_char
    mov rsi, mmap_read_entete
    call afficher
    mov r8b, 'E'            ; pour sauter une ligne
    call afficher_char
    xor rcx, rcx
    mov cl, byte [mmap_nombre_entree]
    test cl, cl              ; si nombre d'entree = 0 alors fin
    jz mmap_read_fin 
    mov rsi, mmap_buffer     ; rsi <- adresse de début du buffer
mmap_read_entree:
    mov rax, [rsi]           ; rax <- la base
    call b2a16               ; afficher la base en hex
    mov r8b, '-'             ; affiche delimiteur -
    call afficher_char
    mov rax, [rsi + 8]       ; rax <- la taille de l'entrée
    call b2a16               ; afficher la taille
    mov r8b, '-'             ; affiche delimiteur -
    call afficher_char
    mov eax, [rsi + 16]      ; eax <- le type
    ;call b2a16              ; afficher le type
    push rsi                  ; sauvgarde RSI
    cmp eax, 1               ; type 1 = libre
    jz mmap_libre
    cmp eax, 2               ; type 2 = reservé
    jz mmap_reserve
    cmp eax, 3               ; type 3 = APCI reclaimable
    jz mmap_apci_rec
    cmp eax, 4               ; type 4 = APCI non-volatile
    jz mmap_apci_nv
    cmp eax, 5               ; type 5 = mauvaise memoire
    jz mmap_mauvaise
    mov rsi, mmap_type0      ; sinon type inconu 
    call afficher
    jmp mmap_apci               
mmap_libre:
    mov rsi, mmap_type1
    call afficher
    jmp mmap_apci
mmap_reserve:
    mov rsi, mmap_type2
    call afficher
    jmp mmap_apci
mmap_apci_rec:
    mov rsi, mmap_type3
    call afficher
    jmp mmap_apci
mmap_apci_nv:
    mov rsi, mmap_type4
    call afficher
    jmp mmap_apci
mmap_mauvaise:
    mov rsi, mmap_type5
    call afficher
    
mmap_apci:
    pop rsi                  ; restaure RSI
    mov r8b, '-'             ; affiche delimiteur -
    call afficher_char
    mov eax, [rsi + 20]      ; eax <- APCI
    call b2a16               ; afficher l'APCI
    mov r8b, 'E'             ; pour sauter une ligne
    call afficher_char
    add rsi, 24              ; entrée suivante  
    dec rcx
    jnz mmap_read_entree  
mmap_read_fin: 
    popAll
    ret