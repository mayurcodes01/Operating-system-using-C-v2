BITS 16
ORG 0x7C00
mov ah, 0x0E
mov al, 'X'
int 0x10
times 510-($-$$) db 0
dw 0xAA55
