## `05.asm` demonstrates how 64-bit `push` and `pop` operations always allocate and reclaim full 8-byte (64-bit) quadword slots regardless of the numerical magnitude stored in a register, and illustrates the mirror-order `push`/`pop` pattern used to preserve register values across operations.

# Program Entry & Register Initialization (_start):

At _start (0x401000), the Linux kernel sets RSP to 0x7fffffffd9f0, pointing to argc (0x1) at [RSP], followed by argv[0] (0x7fffffffdd02) at [RSP + 8].

mov rax, 0x1122334455667788 loads a full 8-byte hexadecimal pattern into RAX, and mov rbx, 0x1234 loads a smaller 2-byte constant into RBX. RSP remains at 0x7fffffffd9f0.

# Pushing Full 64-Bit Quadwords (push rax, push rbx):

push rax: Decrements RSP by 8 bytes (0x7fffffffd9f0 → 0x7fffffffd9e8) and writes 0x1122334455667788 into [0x7fffffffd9e8].

push rbx: Decrements RSP by 8 bytes (0x7fffffffd9e8 → 0x7fffffffd9e0) and writes the full 64-bit value 0x0000000000001234 into [0x7fffffffd9e0].

At nop(No operation acts as an inspection point between the push phase and pop phase), RSP points to 0x7fffffffd9e0 (0x0000000000001234), with 0x1122334455667788 directly above it at 0x7fffffffd9e8.

# Mirror-Order Restoration (pop rbx, pop rax):

pop rbx: Reads 0x0000000000001234 from [0x7fffffffd9e0] back into RBX and increments RSP by 8 bytes (0x7fffffffd9e0 → 0x7fffffffd9e8).

pop rax: Reads 0x1122334455667788 from [0x7fffffffd9e8] back into RAX and increments RSP by 8 bytes (0x7fffffffd9e8 → 0x7fffffffd9f0).

Both registers retain their original values, and RSP is restored to 0x7fffffffd9f0.

Program Termination:

mov rax, 60 (sys_exit) and xor rdi, rdi (status = 0) terminate the program cleanly with exit status 0.

# Observations from Execution & GDB

Running ./05 exits silently with status 0.

Even though 0x1234 only requires 2 bytes, push rbx still moves RSP down by a full 8 bytes (0x7fffffffd9e8 → 0x7fffffffd9e0) because 64-bit mode operates on 64-bit stack slots.

Popping in exact reverse order (push rax, push rbx followed by pop rbx, pop rax) preserves register state while keeping the stack balanced.