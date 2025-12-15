# Operating-system-using-C-v2
hexdump -C boot.bin | tail
000001f0  ... 55 aa
dw 0xAA55
ls -l boot.bin os-image.bin
qemu-system-i386 -drive format=raw,file=os-image.bin
mov dh, 4
ls -l kernel.bin
mov dh, 20
make clean
make


disk_load:
    pusha
    mov ah, 0x02
    mov al, dh
    mov ch, 0
    mov dh, 0
    mov cl, 2
    int 0x13
    jc disk_error
    popa
    ret

disk_error:
    mov si, error_msg
    call print
    jmp $

error_msg db "Disk read error", 0


print:
    lodsb
    or al, al
    jz .done
    mov ah, 0x0E
    int 0x10
    jmp print
.done:
    ret

qemu-system-i386 -drive format=raw,file=boot.bin


all: os-image.bin

os-image.bin: boot.bin kernel.bin
	cat boot.bin kernel.bin > os-image.bin

boot.bin: boot.asm
	nasm -f bin boot.asm -o boot.bin

kernel.bin: kernel.c linker.ld
	gcc -m32 -ffreestanding -fno-pie -c kernel.c -o kernel.o
	ld -m elf_i386 -T linker.ld kernel.o -o kernel.bin --oformat binary

run:
	qemu-system-i386 -drive format=raw,file=os-image.bin

clean:
	rm -f *.bin *.o


  qemu-system-i386 -d int -no-reboot -drive format=raw,file=os-image.bin

