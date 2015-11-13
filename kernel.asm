[BITS 16]  ; commence en mode réel 16 bits
[ORG 0x0]  ; pas de décalage d'adresse

;-----------------------------------------------------------------------------
; Le BIOS nous charge à l'adresse 0000:0x07C0. Donc toutes les données interne
; au programme se situent à partir de cette adresse
;-----------------------------------------------------------------------------
; Initialisation des segments en 0x07C00
mov ax, 0x07C0     ; début segement des données
mov ds, ax         ; selecteur de données contient les 16 bits forts d'une
mov es, ax         ; adresse sur 20 bits
mov ax, 0x8000
mov ss, ax
mov sp, 0xf000    ; stack de 0x8F000 -> 0x80000
; affiche un msg
mov si, msgDebut
call afficher
end:
    jmp end
;--- Variables ---
msgDebut db "Hello world !", 13, 10, 0
;-----------------;---------------------------------------------------------
; Synopsis: Affiche une chaine de caracteres se terminant par 0x0
; Entree:   DS:SI -> pointe sur la chaine a afficher
;---------------------------------------------------------
afficher:
    push ax
    push bx
.debut:
    lodsb         ; ds:si -> al 
    cmp al, 0     ; fin chaine ?
    jz .fin
    mov ah, 0x0E  ; appel au service 0x0e, int 0x10 du bios
    mov bx, 0x07  ; bx -> attribut, al -> caractere ascii
    int 0x10
    jmp .debut
.fin:
    pop bx
    pop ax
    ret
;--- NOP jusqu'a 510 ---
times 510-($-$$) db 144
dw 0xAA55