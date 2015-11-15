[BITS 16]
%include "afficher.asm"
;-----------------------------------------------------------------------------
; Le BIOS nous charge à l'adresse 0x7C00. Donc toutes les données interne
; au programme se situent à partir de cette adresse
;-----------------------------------------------------------------------------

; Initialisation des registres de segment en 0x07C0
mov ax, 0x07C0
mov ds, ax         
; L'emplacement de la pile est arbitraire
mov ax, 0x8000
mov ss, ax
mov sp, 0xf000    ; stack de 0x8F000 -> 0x80000    

call afficher

end:
    jmp end

;--- NOP jusqu'a 510 ---
times 510-($-$$) db 144     ; 144 = nop
dw 0xAA55                   ; siganture d'un secteur de boot