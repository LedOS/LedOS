;-----------------------------------------------------------------------------
; Le BIOS nous charge en mode réel 16 bits à l'adresse 0x7C00. Donc toutes les
; données interne au programme se situent à partir de cette adresse
;-----------------------------------------------------------------------------
[BITS 16]
[ORG 0x7C00]

; Initialise les segment ds,es en 0
mov ax, 0x0
mov ds, ax
mov es, ax
; Pile de 0x8f000 à 0x80000
mov ax, 0x8000
mov ss, ax
mov sp, 0xf000

jmp code
GDTR:
    dw GDT_limite-GDT-1     ; limite sur 16 bits (0-15)
    dd GDT                  ; base sur 32 bits   (16-47)
    
GDT:
db 0, 0, 0, 0, 0, 0, 0, 0
gdt_cs:
db 0xFF, 0xFF, 0x0, 0x0, 0x0, 10011011b, 11011111b, 0x0
gdt_ds:
db 0xFF, 0xFF, 0x0, 0x0, 0x0, 10010011b, 11011111b, 0x0
GDT_limite:

code:
; Passage en mode protégé 32 bits
cli              ; désactive les intérrutpion masquable
lgdt [GDTR]      ; charge l'@ et la limite de la gdt dans le registre gdtr
mov eax, cr0     ; PE = cr0[0]
or al, 1         ; met le PE a 1
mov cr0, eax     ; doit être immédiatement suivi d'un far jmp
    
jmp 0x8:mode_protege  ; far jmp

[BITS 32]
mode_protege:
    ; Initialise DS, ES, FS, GS, SS, ESP.
    mov ax, 0x10
    mov ds, ax
    mov es, ax
    mov fs, ax
    mov gs, ax
    mov ss, ax
    mov esp, 0x9F000
    ; Afficher un text
    mov esi, pmode
    call afficher32
    
boucle:
    hlt           ; met le processeur en pause (attente d'une intérruption)
    jmp boucle

%include "afficher32.asm"
pmode db 'mode protege', 0
  
;--- le secteur de boot doit faire 512 octets ---
times 512-($-$$) db 0 