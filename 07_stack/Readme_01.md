
## `01.asm` demonstrates the fundamental mechanics of the 64-bit x86 stack: downward memory growth during `push` operations, upward contraction during `pop` operations, and Last-In, First-Out (LIFO) data retrieval across general-purpose registers.

# Program Entry (_start):

The Linux kernel initializes RSP to 0x7fffffffd9f0, pointing to argc (0x1) at [RSP], followed by argv[0] (0x7fffffffdd03) at [RSP + 8].

mov rax, 100 (0x64) and mov rbx, 200 (0xc8) load immediate values into registers without modifying RSP.

Pushing Values onto the Stack (push rax, push rbx):

push rax: Decrements RSP by 8 bytes (0x7fffffffd9f0 → 0x7fffffffd9e8) and writes 100 (0x64) into [0x7fffffffd9e8].

push rbx: Decrements RSP by another 8 bytes (0x7fffffffd9e8 → 0x7fffffffd9e0) and writes 200 (0xc8) into [0x7fffffffd9e0].

At the first nop, 16 bytes have been allocated on the stack, with 200 at the top ([RSP]) and 100 directly beneath it ([RSP + 8]).

# Popping Values from the Stack (pop rcx, pop rdx):

pop rcx: Copies the top 64-bit quadword (200) from [0x7fffffffd9e0] into RCX, then increments RSP by 8 bytes (0x7fffffffd9e0 → 0x7fffffffd9e8).

pop rdx: Copies the next quadword (100) from [0x7fffffffd9e8] into RDX, then increments RSP by 8 bytes (0x7fffffffd9e8 → 0x7fffffffd9f0).

At the second nop, RSP is completely balanced back to its original entry address (0x7fffffffd9f0).

Program Termination:

mov rax, 60 (sys_exit) and xor rdi, rdi (status = 0) terminates the program cleanly with exit status 0.

# Observations from Execution & GDB
Running ./01 produces no terminal output and returns exit code 0.

Each push subtracts 8 from RSP (64-bit quadword width), and each pop adds 8 back to RSP.

Although 100 was pushed first (RAX) and 200 second (RBX), popping into RCX and RDX assigns RCX = 200 and RDX = 100, confirming LIFO ordering.

