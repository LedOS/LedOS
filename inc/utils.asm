%macro pushAll 0
    push rax
    push rbx
    push rcx
    push rdx
    push rsi
    push rdi
%endmacro

%macro popAll 0
    pop rdi
    pop rsi
    pop rdx
    pop rcx
    pop rbx
    pop rax
%endmacro

%macro print 1
    jmp %%start
    %%string db %1, 0
    %%start:
    mov rsi, %%string
    call afficher
%endmacro

%macro printc 1
    mov r8b, %1
    call afficher_char
%endmacro

compareStr:
    ; compare 2 string dans rsi et rdi et renvoie dans r8b 0 si egale, sinon 1
    pushAll
compareStr_next:
    mov al, byte [rsi]       ; al <- [rsi]
    mov ah, al               ; sauvegarde al
    or ah, byte [rdi]        ; si les 2 char sont a 0 alors fin et egale
    cmp ah, 0
    jz compareStr_egale
    cmp al, byte [rdi]       ; si al ! [rdi] alors non egale
    jnz compareStr_non 
    inc rsi                  ; caractere suivant
    inc rdi
    jmp compareStr_next
compareStr_egale:
    mov r8b, 0 
    jmp compareStr_fin 
compareStr_non:
    mov r8b, 1
compareStr_fin:  
    popAll
    ret
    