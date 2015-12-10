;-----------------------------------------------------------------------------
; Le secteur de boot nous charge en mode protégé 32 bits à l'adresse 0x7E00.
; Donc toutes les données interne au programme se situent à partir de cette adresse
;-----------------------------------------------------------------------------
[BITS 32]
[ORG 0x7E00]

jmp kernel

%include "inc/GDT.asm"
%include "inc/page.asm"
mmap_nombre_entree db 0

kernel:
    ; Initialise DS, ES, SS et ESP
    mov ax, 0x10
    mov ds, ax
    mov es, ax
    mov ss, ax
    mov esp, 0x9F000

    mov [mmap_nombre_entree], bx ; récupere le nombre d'entrée de mmap
    
    ; Active la pagination
    call init_page
    mov eax, cr0                 ; eax <- cr0
    or eax, 1 << 31              ; cr0[31] PG <- 1 
    mov cr0, eax                 ; cr0 <- eax
    ; charge la GDT 64 bits
    lgdt [GDT64.Pointer]         
    jmp GDT64.Code:mode64    

[bits 64]
%include "inc/utils.asm"
mode64:
    ; Initialisation des selecteur
    mov ax, GDT64.Data            ; ax <- selecteur de donnée
    mov ds, ax                    ; ds <- ax
    mov es, ax                    ; es <- ax
    mov fs, ax                    ; fs <- ax
    mov gs, ax                    ; gs <- ax
    mov ss, ax                    ; ss <- ax
    mov rsp, 0x9F000              ; rsp <- 0x9F000
    ; Active les interruptions
    call initIDT64                ; initialise l'IDT
    lidt [IDTR64]
    ; Initilaise 8259PIC
    sti                           ; active les interruptions
    call init_pic   
    call clrscr                   ; efface l'écran
    ; Affiche un message
    mov rsi, long_mode
    call afficher 
    printc 'E'
    mov rsi, shell_string
    call afficher
    
boucle:
    hlt           ; met le processeur en pause (attente d'une intérruption)
    jmp boucle

long_mode db 'kernel: mode 64 bits... ', 0    
st db 'kkk', 0
%include "inc/8259pic.asm"
%include "inc/IDT64.asm"
%include "inc/screen.asm"
%include "inc/b2.asm"
%include "inc/b2a10.asm"
%include "inc/b2a16.asm"
%include "inc/b10a2.asm"
%include "inc/hexToInt.asm"
%include "inc/mmap_read.asm"
%include "inc/shell.asm"
%include "inc/pci.asm"