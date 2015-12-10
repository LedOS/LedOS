nasm -o bootsect bootsect.asm
nasm -o kernel kernel.asm
cat bootsect kernel > LedOS
dd if=LedOS.img of=/dev/sdb bs=512 count=11
