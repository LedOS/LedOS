%define PCI_CONFIG_ADDRESS 0xCF8
%define PCI_CONFIG_DATA 0xCFC
; 31	       30 - 24	  23 - 16	   15 - 11	       10 - 8	        7 - 2	           1 - 0
; Enable Bit | Reserved	| Bus Number | Device Number | Function Number | Register Number | 00
pci_adresse dd 0x80000000

pci_detect:
    ; detecte les composants pci
    pushAll 
    xor rax, rax                     ; bus 0                       
pci_next_bus:
    xor rbx, rbx                     ; device 0
pci_next_device:
    xor rcx, rcx                     ; fonction 0
    xor rdx, rdx,                    ; registre 0 
    call pci_checkDevice             ; renvoie la réponse de config dans r9d
    cmp r9w, 0xFFFF                  ; 0xFFFF = emplacement vide  (Vendor)
    jz pci_skip
    print ' Device Vendor : '        ; affiche le n° du device et vendor
    xchg r9d, eax
    call b2a16
    xchg eax, r9d             
    mov rdx, 2                       ; registre 2 pour class subclass prog rev
    call pci_checkDevice             ; renvoi le type dans r9d 
    call pci_type                    ; affiche le type
    mov rdx, 3                       ; registre 3 : BIST, Header, Latence,Cache 
    call pci_checkDevice             ; retour dans r9d
    call pci_header                  ; affiche et renvoie le header dans r9b
    printc 'E'                       ; saut de ligne
    cmp r9b, 0x80                    ; si header = 0x80 alors plusieurs fonction
    jnz pci_skip
    inc rcx                          ; fonction 1
pci_next_fonction:
    xor rdx, rdx                     ; registre 0
    call pci_checkDevice             ; renvoie la réponse de config dans r9d
    cmp r9w, 0xffff
    jz pci_next_fonction_skip
    print ' Device Vendor : '        ; affiche le n° du device et vendor
    xchg r9d, eax
    call b2a16
    xchg eax, r9d 
    printc 'E'  
pci_next_fonction_skip:
    inc rcx                          ; fonction suivante
    cmp cl, 8                        ; max 8 fonction
    jnz pci_next_fonction 
pci_skip:
    inc bl                           ; incrémente le n° du device
    cmp bl, 32                       ; 32 device max par bus
    jnz pci_next_device
    inc ax                           ; incrémente le n° du bus
    cmp ax, 256                      ; 256 bus max
    jnz pci_next_bus
    popAll
    ret 

pci_checkDevice:
    ; al = bus, bl = device, cl = fonction, dl = registre, retour = r9d
    pushAll
    ; "crafter" l'adresse
    shl eax, 16
    shl ebx, 11
    shl ecx, 8
    shl edx, 2
    or eax, [pci_adresse]  
    or eax, ebx
    or eax, ecx
    or eax, edx  
    ; passer l'adresse au port de config pci
    mov dx, PCI_CONFIG_ADDRESS       ; dx <- n° du port d'adresse de config
    out dx, eax                      ; ecriture sur le port CONFIG_ADDRESS   
    ; lire la réponse
    mov dx, PCI_CONFIG_DATA          ; lire la réponse
    in eax, dx                       ; lecture sur le port CONFIG_DATA
    mov r9d, eax                     ; valeur de retour dans r9d

pci_checkDevice_fin:    
    popAll  
    ret 
    
pci_type:
    ; r9d = type (class, subclass, prog if, revision)
    pushAll
    mov eax, r9d                     ; eax <- type
    shr eax, 16                      ; ax <- class, subclass
    cmp ax, 0x0600                   ; type 0x0600 = Host Bridge
    jnz pci_type_0x0601
    print ' Host bridge '
    jmp pci_type_fin
pci_type_0x0601:
    cmp ax, 0x0601                   ; type 0x0601 = ISA Bridge
    jnz pci_type_x
    print ' Isa bridge '
    jmp pci_type_fin
pci_type_x:
    print ' Type inconu '
pci_type_fin:
    popAll
    ret    
    
pci_header:
    ; r9d = BIST, Header, Latence, Cache
    pushAll
    mov eax, r9d                     ; eax <- r9d
    shr eax, 16                      ; ax <- BIST, header
    cmp al, 0                        ; 0x0 = general device
    jnz pci_header_1
    print ' General device '
    jmp pci_header_fin
pci_header_1:
    cmp al, 1                        ; 0x1 = PCI-to-PCI bridge
    jnz pci_header_2
    print ' PCI-to-PCI bridge '
    jmp pci_header_fin
pci_header_2:
    cmp al, 2                        ; 0x2 = CardBus bridge
    jnz pci_header_80
    print ' CardBus bridge '
    jmp pci_header_fin
pci_header_80:
    cmp al, 0x80                     ; 0x80 = plusieurs fonction
    jnz pci_header_x
    print ' Plusieurs fonction '
    jmp pci_header_fin
pci_header_x:
    print ' Header inconu '
pci_header_fin:
    mov r9b, al                      ; renvoie le header
    popAll
    ret       