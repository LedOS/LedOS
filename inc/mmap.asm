; Affiche les informations sur memoire
;Fonction bios INT 0x15, EAX = 0xE820 : Peut détecter plus de 4GO de mémoire.
;Retourne une liste d'entrée de mémoire dans ES:DI.
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

;Première appelle:
;Retour: EAX = 0x534D4150, Carry flag = 0. EBX = non-zero, doit être préserve pour le prochaine appelle. CL = nombre d'octet ecrit a es:di.
;Appelle ultérieur:
;Entrée: Incrémenter DI par la taille d'entrée (CL), EAX = 0xE820, ECX = 24.
;Retour: a la dernière entrée ebx (peut) recevoir 0, sinon la fonction retournera Carry flag = 1 après le dernière entrée valide.
%define mmap_buffer 0x500    ; adresse début du buffer pour stocker les entrées
mmap_nombre_entree db 0      ; pour sotcker le nombre d'entrée

mmapGetMemoryMap:
    ; Donne les données sur la mémoire 
    mov di, mmap_buffer      ; di <- adresse de début du buffer
    xor ebx, ebx             ; ebx <- 0
    mov edx, 0x534D4150      ; signature pour le bios
mmap_next_entree:
    mov eax, 0xE820          ; fonction 0xE820
    mov [es:di + 20], dword 1; force a valid ACPI 3.X entry
    mov ecx, 24              ; taille du buffer
    int 0x15                 ; EAX=SMAP CF=0 EBX=next CL = nombre d'octet ecrit
    jc mmap_fin              ; si CF = 1 alors fin
    inc byte [ds:mmap_nombre_entree]
    or ebx, ebx              ; si ebx = 0 alors fin
    jz mmap_fin
    add di, 24               ; di <- +24 octet
    jmp mmap_next_entree     ; entrée suivante
mmap_fin:
    ret    