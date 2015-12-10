base_video dq  0xB8000       ; mémoire video text couleur commence 0xB8000
cur_x dw 0                   ; curseur x commence a 0
cur_y dw 0                   ; curseur y commence a 0

%define width 160            ; largeur de l'écran
%define height 25            ; hauteur de l'écran
_width db width              ; largeur de l'écran (pour la division)

%macro init_curseur 0        ; charge le curseur dans rdi
    pushAll                  ; sauvegarde les registres
    mov cx, word [cur_x]     ; cx <- cur_x
    mov dx, word [cur_y]     ; dx <- cur_y
    xor rdi, rdi             ; rdi <- 0
    mov rdi, [base_video]    ; rdi <- @ base video
    xor rax, rax             ; rax <-0
    mov ax, dx               ; ax <- cur_y
    mul byte [_width]        ; ax <- * width
    add ax, cx               ; ax <- ax + cur_x
    add rdi, rax             ; rdi <- + position curseur
%endmacro

%macro saut_ligne 0          ; saute une ligne
    xor cx, cx               ; x <- 0
    inc dx                   ; y <- +1
    cmp dx, height           ; si y != height
    jnz %%fin_saut_ligne     ; fin
    xor dx, dx               ; sinon y <- 0
    %%fin_saut_ligne:        ; %% = label local a la macro
%endmacro       
    
afficher:
    ; recoit l'@ de la chaine à afficher dans rsi 
    init_curseur             ; rdi <- base_video + position curseur
    cld                      ; clear D(irection) = incrémente si/di    
next_char:
    ; un caractere sur 2 byte: code ascii, attributs
    movsb                    ; [rdi] <- [rsi] ; rdi=+1 ; rsi=+1
    mov byte [rdi], 0x7      ; attribut <- clignotement bg sur-intensité couleur
    inc rdi                  ; rdi <- +1
    add cx, 2                ; cur_x <- +2
    cmp cx, width            ; si cur_x = width alors saut de ligne
    jnz test_fin_chaine
    saut_ligne    
test_fin_chaine:
    cmp byte [rsi], 0        ; si [rsi] = 0 alors fin de chaine
    jz fin_afficher
    jmp next_char            ; sinon afficher le caractere suivant
fin_afficher:
    ; stock x,y
    mov [cur_x], cx
    mov [cur_y], dx
    call showCursor
    popAll
    ret

afficher_char:
    ; afficher un seul caractere présent dant R8b
    init_curseur             ; rdi <- base_video + position curseur
    cmp r8b, 'E'             ; si entrée alors saut de ligne
    jnz suite
    saut_ligne
    jmp fin_afficher_char                       
suite:
    cmp r8b, 'B'
    jnz .s
    call scroll
    jmp fin_afficher_char
.s:
    ; affiche le caractere 
    mov byte [rdi], r8b      ; [rdi] <- caractere à afficher 
    mov byte [rdi+1], 0x7    ; attribut du caractere (blanc sur noir))
    add cx, 2                ; cur_x + 2
    cmp cx, width            ; si cur_x = width alors saut de ligne
    jnz fin_afficher_char    ; sinon fin
    saut_ligne 
fin_afficher_char:          
    mov [cur_x], cx          ; cur_x <- cx
    mov [cur_y], dx          ; cur_y <- dx
    call showCursor
    popAll
    ret
    
clrscr:
    ; efface l'ecran
    pushAll
    mov rdi, [base_video]       ; rdi <- début mémoire video
    mov rcx, (width*height)/8   ; taille ecran / 8 octet
    mov rax, 0x0F000F000F000F00 ; blanc/noir
    rep stosq                   ; tant que rcx>0:[rdi]<- rax; rdi<- +8; rcx<- +1
    mov byte [cur_x], 0         ; remet les curseurs xy au début
    mov byte [cur_y], 0
    call showCursor
    popAll
    ret 

showCursor:    
    ; Affiche le curseur, cx = x, dx = y
    pushAll                  ; sauvegarde les registres   
    shr cx, 1                ; cx <- cx / 2
    mov ax, dx               ; ax <- cur_y
    mov r8b, 80
    mul r8b                  ; ax <- * width
    add ax, cx               ; ax <- ax + cur_x
    mov di, ax               ; di <- position curseur
    ; cursor LOW port to vga INDEX register
    mov al, 0x0f
    mov dx, 0x3d4
    out dx, al
    mov ax, di
    mov dx, 0x3d5
    out dx, al
    ; cursor HIGH port to vga INDEX register
    mov al, 0x0e
    mov dx, 0x3d4
    out dx, al
    mov dx, 0x3d5
    mov ax, di
    shr ax, 8
    out dx, al               
    popAll                   ; restaure les registres
    ret 
    
scroll:
    ; scroll vers le bas
    pushAll
    mov rcx, height          ; rcx <- nbr de ligne
    mov rdi, [base_video]    ; rdi <- 1ére ligne
scroll_next_line:
    mov rsi, rdi             ; rsi <- rdi
    add rsi, width           ; rsi <- 1+ ligne
    mov rax, [rsi]           ; rax <- [rsi]
    mov [rdi], rax           ; [rdi] <- ligne d'après
    add rdi, width           ; rdi <- +1 ligne
    loop scroll_next_line
    popAll
    ret