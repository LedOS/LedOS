;-----------------------------------------------------------------------------
; Le BIOS nous charge en mode réel 16 bits à l'adresse 0x7C00. Donc toutes les
; données interne au programme se situent à partir de cette adresse
;-----------------------------------------------------------------------------
[BITS 16]
[ORG 0x7C00]

jmp debut

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

pmode db 'mode protege... ', 0

; Initialise le segment DS en 0
debut:
xor ax, ax
mov ds, ax

; Passage en mode protégé 32 bits
cli              ; désactive les intérrutpion masquable
lgdt [GDTR]      ; charge l'@ et la limite de la gdt dans le registre gdtr
mov eax, cr0     ; PE = cr0[0]
or al, 1         ; met le PE a 1
mov cr0, eax     ; doit être immédiatement suivi d'un far jmp
    
jmp 0x8:mode_protege  ; far jmp

[BITS 32]
mode_protege:
    ; Initialise DS, ES, SS et ESP
    mov ax, 0x10
    mov ds, ax
    mov es, ax
    mov ss, ax
    mov esp, 0x9F000
    ; Afficher un text
    mov esi, pmode
    call afficher
    
boucle:
    hlt           ; met le processeur en pause (attente d'une intérruption)
    jmp boucle

%include "inc/afficher32.asm"
%include "inc/b2a10.asm"
%include "inc/b2a16.asm"
  
;--- le secteur de boot doit faire 512 octets ---
times 512-($-$$) db 0 