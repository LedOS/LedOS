;-----------------------------------------------------------------------------
; Le BIOS nous charge en mode réel 16 bits à l'adresse 0x7C00. Donc toutes les
; données interne au programme se situent à partir de cette adresse
;-----------------------------------------------------------------------------
[BITS 16]
[ORG 0x7C00]
%define adresse_kernel 0x7E00
cli                         ; désactive les interruptions
jmp 0x0000:debut            ; far jump pour réinialiser cs 0

%include "inc/mmap.asm"

GDTR:
    dw GDT_limite-GDT-1     ; limite sur 16 bits (0-15)
    dd GDT                  ; base sur 32 bits   (16-47)
    
GDT:
    db 0, 0, 0, 0, 0, 0, 0, 0
gdt_cs:
    ; limite[0:15], base[0:15], base[16:23]
    db 0xFF, 0xFF, 0x0, 0x0, 0x0 
    ; P DPL S type A
    db 10011011b
    ; G D/B L AVL limite[16:19]
    db 11011111b
    ; base 24:31
    db 0x0
gdt_ds:
    db 0xFF, 0xFF, 0x0, 0x0, 0x0, 10010011b, 11011111b, 0x0
GDT_limite:

bootdrv: db 0                ; buffer ou mettre le numéro de disk de démarrage

; Initialise les segments de données en 0
debut:
xor ax, ax
mov ds, ax
mov es, ax
mov ax, 0x8000               ; stack en 0xFFFF
mov ss, ax
mov sp, 0xf000
 
; recuparation de l'unite de boot
mov [bootdrv], dl            ; le bios met le n° du disk de démarrage dans dl

; charger le noyau
xor ax, ax                   ; fonction 0 = reset
int 0x13
      
lire_disk:
    mov bx, adresse_kernel   ; es:bx pointeur vers buffer destination
    mov ah, 2                ; fonction 2 = lecture
    mov al, 15                ; nombre de secteur à charger
    mov ch, 0                ; cylindre
    mov cl, 2                ; numéro du secteur
    mov dh, 0                ; head
    mov dl, [bootdrv]
    int 0x13                 ; copie le secteur dans la mémoire 
    jc lire_disk             ; CF = 1 si erreur

call mmapGetMemoryMap        ; récupère le mappage de la mémoire
mov bx, [mmap_nombre_entree] ; stock le nombre d'entrée pour les passer au kernel

; Passage en mode protégé 32 bits
lgdt [GDTR]                  ; charge la gdt
mov eax, cr0                 ; PE = cr0[0]
or al, 1                     ; met le PE a 1
mov cr0, eax                 ; doit être immédiatement suivi d'un far jmp
    
jmp 0x8:adresse_kernel       ; saut vers le kernel
  
;--- le secteur de boot doit faire 512 octets ---
times 510-($-$$) db 0
dw 0xaa55   ; signature pour les anciens bios 
