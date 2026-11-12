## `06.asm` is the 32-bit (`BITS 32`). It demonstrates how 32-bit `push` and `pop` operations always allocate and reclaim full 4-byte (`dword`) stack slots regardless of the numerical size stored in a register, and illustrates mirror-order `push`/`pop` register preservation using `ESP`.

# Program Entry & Register Setup (_start):

At _start (0x8049000), the Linux kernel initializes the 32-bit stack pointer ESP to 0xffffcb60, pointing to argc (0x1) at [ESP], followed by argv[0] (0xffffcd02) at [ESP + 4].

mov eax, 0x11223344 loads a full 32-bit hexadecimal constant into EAX, and mov ebx, 0x1234 loads a 16-bit constant into EBX. ESP remains at 0xffffcb60.

# Pushing Full 32-Bit dword Slots (push eax, push ebx):

push eax: Decrements ESP by 4 bytes (0xffffcb60 → 0xffffcb5c) and writes 0x11223344 into [0xffffcb5c].

push ebx: Decrements ESP by 4 bytes (0xffffcb5c → 0xffffcb58) and writes the zero-extended 32-bit dword 0x00001234 into [0xffffcb58].

At nop, 8 bytes have been pushed onto the stack, with 0x00001234 at the top ([ESP]) and 0x11223344 directly above it ([ESP + 4]).

# Mirror-Order Restoration (pop ebx, pop eax):

pop ebx: Reads 0x00001234 from [0xffffcb58] back into EBX and increments ESP by 4 bytes (0xffffcb58 → 0xffffcb5c).

pop eax: Reads 0x11223344 from [0xffffcb5c] back into EAX and increments ESP by 4 bytes (0xffffcb5c → 0xffffcb60).

Both registers retain their original values, and ESP is restored to its exact starting address (0xffffcb60).

Program Termination (int 0x80):

mov eax, 1 (sys_exit in 32-bit Linux) and xor ebx, ebx (status = 0) trigger interrupt int 0x80, exiting cleanly with status 0.

# Observations from Execution & GDB

Running ./06 produces no terminal output and exits cleanly with status 0.

Although 0x1234 only occupies 2 bytes, push ebx still decrements ESP by a full 4 bytes (0xffffcb5c → 0xffffcb58) and stores 0x00001234 as a 32-bit dword.

Popping in mirror order (push eax, push ebx followed by pop ebx, pop eax) restores register state while returning ESP cleanly to 0xffffcb60.