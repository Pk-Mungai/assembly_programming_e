## `04.asm` demonstrates 32-bit (`BITS 32`) stack frame creation, local `dword` variable storage, and stack teardown using `ESP` and `EBP`. It serves as the 32-bit architecture, illustrating 4-byte stack slot and the legacy `int 0x80` Linux system call interface.

# Program Entry (_start):

At _start (0x8049000), the Linux kernel initializes the 32-bit stack pointer ESP to 0xffffcb60, pointing to argc (0x1) at [ESP], followed by argv[0] (0xffffcd02) at [ESP + 4].

call work pushes the 32-bit return address (0x08049005) onto the stack, decrementing ESP by 4 bytes (0xffffcb60 → 0xffffcb5c), and jumps to work.

# 32-Bit Function Prologue (push ebp, mov ebp, esp, sub esp, 8):

push ebp: Pushes the caller's 32-bit EBP (0x0) onto the stack, decrementing ESP by 4 bytes (0xffffcb5c → 0xffffcb58).

mov ebp, esp: Anchors EBP at 0xffffcb58 as the reference frame pointer.

sub esp, 8: Decrements ESP by 8 bytes (0xffffcb58 → 0xffffcb50), allocating space for two 32-bit (dword, 4-byte) local variables.

# Local dword Variable Access ([ebp - 4], [ebp - 8]):

mov dword [ebp - 4], 100 writes 100 (0x64) to 0xffffcb54.

mov dword [ebp - 8], 200 writes 200 (0xc8) to 0xffffcb50.

mov eax, [ebp - 4] and mov ebx, [ebp - 8] load 100 and 200 into EAX and EBX while ESP remains fixed at 0xffffcb50.

# 32-Bit Function Epilogue (mov esp, ebp, pop ebp, ret):

mov esp, ebp: Deallocates the 8 bytes of local variables by snapping ESP back to 0xffffcb58.

pop ebp: Restores EBP (0x0) and increments ESP by 4 bytes (0xffffcb58 → 0xffffcb5c).

ret: Pops the 32-bit return address (0x08049005) into EIP, increments ESP by 4 bytes back to 0xffffcb60, and returns to _start.

Program Termination (int 0x80):

mov eax, 1 (sys_exit in 32-bit Linux) and xor ebx, ebx (status = 0) trigger interrupt int 0x80, exiting cleanly with status 0.

# Observations from Execution & GDB

Assembling 04.asm as 64-bit (elf64) causes a segmentation fault (SIGSEGV) because sub esp, 8 zeroes the upper 32 bits of RSP, truncating 0x7fffffffd9e0 into an unmapped address (0xffffd9d8).

When properly compiled as elf32, every stack operation (call, push, pop, ret) adjusts ESP by 4 bytes rather than 8 bytes, and ./04 exits cleanly with status 0.