;-----------------------------------------------------------------------------
; Le secteur de boot nous charge en mode protégé 32 bits à l'adresse 0x7E00.
; Donc toutes les données interne au programme se situent à partir de cette adresse
;-----------------------------------------------------------------------------
[BITS 32]
[ORG 0x7E00]

jmp kernel

%include "inc/afficher.asm"
%include "inc/b2a10.asm"
%include "inc/b2a16.asm"

pmode db 'kernel: mode protege... ', 0

kernel:
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