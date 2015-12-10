; Conversion base 2 vers 10:
; nombre à convertire dans edx:eax, base dans ebx, quotient eax, reste edx

nombre db '00000000', 0
b2a10:
    pushAll
    cmp eax, 0       ; pour eviter la division par 0
    jz fin_conversion
    xor edx, edx     ; s'assurer qu'edx vaut 0
    mov edi, nombre+7    
    mov ebx, 10      ; on veut le nombre en base 10
next_div:
    div ebx          ; divise edx:eax par ebx 
    add dl, '0'      ; edx <- code ascii du reste
    mov [edi], dl    ; [edi] <- le reste
    dec edi          ; chiffre suivant
    cmp eax, 0       ; si quotient=0 alors fin
    jz fin_conversion                    
    xor edx, edx     ; sinon on continu avec le quotient
    jmp next_div    

fin_conversion:
    popAll
    ret