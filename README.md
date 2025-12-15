

nasm -f bin test.asm -o test.bin
ls -lh test.bin




===========================


ls -l boot.bin
stat boot.bin
nasm -f bin boot.asm -o boot.bin
echo $?
=====================










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

-=============================================================================-




1. Open Terminal in Kali

Go to the folder where your OS project is:

cd ~/myos


(Use the correct path if it’s different.)

2. Install Required Tools (one time)

Run this once:

sudo apt update
sudo apt install -y build-essential nasm qemu-system-x86


This gives you:

gcc

ld

make

nasm

qemu

Check quickly:

nasm -v
qemu-system-i386 --version
make --version

3. Use This Makefile (Important)

Open your Makefile:

nano Makefile


Paste this exact content (tabs, not spaces):

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


Save:

Ctrl + O

Enter

Ctrl + X

4. Build the OS Image

Run:

make clean
make


Expected output:

boot.bin created

kernel.bin created

os-image.bin created

Verify:

ls -l


You must see:

boot.bin
kernel.bin
os-image.bin

5. Run in QEMU (Correct Way)

Run exactly this:

make run


OR directly:

qemu-system-i386 -drive format=raw,file=os-image.bin

6. What You Should See

A QEMU window opens and displays:

Booting MyOS...
Welcome to MyOS Kernel


If you see this, your OS is running correctly.

7. If You Get “No bootable device” Again

Do these checks:

A. Check boot sector size
ls -l boot.bin


Must be:

512 bytes

B. Check boot signature
hexdump -C boot.bin | tail


You must see:

55 aa

C. Test bootloader alone
qemu-system-i386 -drive format=raw,file=boot.bin


You must see:

Booting MyOS...


If this works but full image doesn’t, the kernel size is the issue.

8. Important Kali-Specific Notes

Always run QEMU as normal user, not root

Do not double-click .bin files

Use terminal only

Use BIOS mode (default), not UEFI





++++++


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








nasm -f bin boot.asm -o boot.bin


echo $?





stat boot.bin







