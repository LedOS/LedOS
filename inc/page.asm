%define base_pml4 0x10000
;PML4T - 0x1000.
;PDPT - 0x2000.
;PDT - 0x3000.
;PT - 0x4000.

init_page:
clear_tables:
    mov edi, base_pml4 ; edi <- adresse de base du PML4
    mov cr3, edi       ; cr3 <- edi
    xor eax, eax       ; eax <- 0
    mov ecx, 4096      ; ecx <- 4096
    rep stosd          ; [edi] <- 0 , edi +4 , tant que ecx > 0
    mov edi, cr3       ; edi <- cr0
    ; renseine l'adresse de base de chaque table vers la table en dessus    
    mov DWORD [edi], base_pml4 + 0x1003     ; [edi] <- 0x2003 , adresse du PDPT
    add edi, 0x1000                         ; edi <- +0x1000
    mov DWORD [edi], base_pml4 + 0x2003     ; [edi] <- 0x3003, adresse du PDT
    add edi, 0x1000                         ;  edi <- +0x1000
    mov DWORD [edi], base_pml4 + 0x3003     ; [edi] <- 0x4003, adresse PT
    add edi, 0x1000                         ; edi <- +0x1000
    ; map les 2 premier MB (512 entrée dans le PT)   
    mov ebx, 0x00000003          ; ebx <- 0x00000003
    mov ecx, 512                 ; ecx <- 512
.SetEntry:
    mov DWORD [edi], ebx         ; [edi] <- ebx
    add ebx, 0x1000              ; ebx <- +0x1000 
    add edi, 8                   ; edi <- +8
    loop .SetEntry               ; Set the next entry.
    ; active PAE
    mov eax, cr4                 ; eax <- cr4
    or eax, 1 << 5               ; cr4[5] (PAE) <- 1 
    mov cr4, eax                 ; cr4 <- eax
    ; LM bit
    mov ecx, 0xC0000080          ; ecx <- 0xC0000080, EFER MSR.
    rdmsr                        ; Lit le model-specific register.
    or eax, 1 << 8               ; EDER MSR[8](LM) <- 1
    wrmsr                        ; Ecrit le model-specific register.
    ret