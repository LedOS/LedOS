; Conversion base 2 vers 10:
; nombre à convertire dans edx:eax, base dans ebx, quotient eax, reste edx

nombre16 db '00000000', 0
b2a16:
    push eax
    push ebx
    push edx
    mov edi, nombre16+7    
    mov ebx, 16      ; on veut le nombre en base 10
next_div16:
    div ebx          ; divise edx:eax par ebx
    cmp dl, 9        ; si le reste > 9 code ascii = a,b...
    ja resteA        ; jump if above
    add dl, '0'      ; edx <- code ascii du reste
    jmp reste9
resteA:
    add dl, 'a'-10   ; edx <- code ascii du reste
reste9:
    mov [edi], dl    ; [edi] <- le reste
    dec edi          ; chiffre suivant
    cmp eax, 0       ; si quotient=0 alors fin
    jz fin_b2a16
    xor edx, edx     ; sinon on continu avec le quotient
    jmp next_div16    

fin_b2a16:
    mov esi, nombre16
    call afficher
    pop edx
    pop ebx
    pop eax
    ret