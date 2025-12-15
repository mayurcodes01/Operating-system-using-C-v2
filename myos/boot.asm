BITS 16
ORG 0x7C00

start:
    cli
    xor ax, ax
    mov ds, ax
    mov es, ax
    mov ss, ax
    mov sp, 0x7C00

    mov si, message
.print:
    lodsb
    or al, al
    jz load_kernel
    mov ah, 0x0E
    int 0x10
    jmp .print

load_kernel:
    mov bx, 0x1000
    mov dh, 10
    call disk_load
    jmp 0x0000:0x1000

disk_load:
    pusha
    mov ah, 0x02
    mov al, dh
    mov ch, 0
    mov cl, 2
    mov dh, 0
    int 0x13
    popa
    ret

message db "Booting MyOS...", 0

times 510-($-$$) db 0
dw 0xAA55
