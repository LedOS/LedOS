nasm -o bootsect bootsect.asm
nasm -o kernel kernel.asm
copy bootsect/B+kernel/B LedOS.img
pause