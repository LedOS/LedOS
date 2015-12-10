; Affiche les informations sur le cpu

message_cpuid_ok db 'CPUID supporte... ', 0
message_cpuid_non db 'CPUID non supporte... ', 0
message_vendor db 'xxxxxxxxxxxx... ', 0
message_longMode_ok db 'long mode supporte... ', 0
message_longMode_non db 'long mode non supporte... ', 0

checkCPUID:
    pushfd               ; Store the FLAGS-register.
    pop eax              ; Restore the A-register.
    mov ecx, eax         ; Set the C-register to the A-register.
    xor eax, 1 << 21     ; Flip the ID-bit, which is bit 21.
    push eax             ; Store the A-register.
    popfd                ; Restore the FLAGS-register.
    pushfd               ; Store the FLAGS-register.
    pop eax              ; Restore the A-register.
    push ecx             ; Store the C-register.
    popfd                ; Restore the FLAGS-register.
    xor eax, ecx         ; Do a XOR-operation on the A-register and the C-register.
    jz no_cpuid
    mov esi, message_cpuid_ok
    call afficher
    jmp fin_checkCPUID
no_cpuid:
    mov esi, message_cpuid_non
    call afficher
fin_checkCPUID:
    call vendor
    ret
    
vendor:
    ; renvoie le nom du vendeur dans EBX, ECX, EDX
    mov eax, 0
    CPUID
    mov [message_vendor], ebx
    mov [message_vendor+4], edx
    mov [message_vendor+8], ecx
    mov esi, message_vendor
    call afficher
    call longMode
    ret
  
longMode:
    mov eax, 0x80000000    ; Set the A-register to 0x80000000.
    cpuid                  ; CPU identification.
    cmp eax, 0x80000001    ; Compare the A-register with 0x80000001.
    jb .NoLongMode         ; It is less, there is no long mode.
    mov eax, 0x80000001    ; Set the A-register to 0x80000001.
    cpuid                  ; CPU identification.
    test edx, 1 << 29      ; Test if the LM-bit, which is bit 29, is set in the D-register.
    jz .NoLongMode         ; They aren't, there is no long mode.
    mov esi, message_longMode_ok 
    call afficher
    jmp fin_longMode
.NoLongMode:
    mov esi, message_longMode_non  
    call afficher
fin_longMode:
    ret