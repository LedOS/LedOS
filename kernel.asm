[BITS 16]  ; commence en mode réel 16 bits
[ORG 0x0]  ; pas de décalage d'adresse

;-----------------------------------------------------------------------------
; Le BIOS nous charge à l'adresse 0x7C00. Donc toutes les données interne
; au programme se situent à partir de cette adresse
;-----------------------------------------------------------------------------

; Initialisation des registres de segment en 0x07C00
mov ax, 0x07C0     ; début segement des données
mov ds, ax         ; selecteur de données contient les 16 bits forts d'une
mov es, ax         ; adresse sur 20 bits
mov ax, 0x8000
mov ss, ax
mov sp, 0xf000    ; stack de 0x8F000 -> 0x80000

end:
    jmp end

;--- NOP jusqu'a 510 ---
times 510-($-$$) db 144
dw 0xAA55