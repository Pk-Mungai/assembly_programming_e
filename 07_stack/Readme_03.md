## `03.asm` demonstrates how subroutine calls implicitly push and pop return addresses on the 64-bit x86 stack without using explicit `push` or `pop` instructions, as well as how a **leaf procedure** (`calculate`) executes without constructing an `RBP` stack frame.

# Program Entry & Argument Setup (_start):

At _start, the Linux kernel initializes RSP to 0x7fffffffd9f0, pointing to argc (0x1) at [RSP], followed by argv[0] (0x7fffffffdd02) at [RSP + 8].

mov rax, 10 loads 10 (0xa) into RAX to pass an input argument via register without modifying RSP.

# Implicit Push via call calculate:

Executing call calculate performs two atomic actions:

Decrements RSP by 8 bytes (0x7fffffffd9f0 → 0x7fffffffd9e8) and pushes the 64-bit return address 0x000000000040100a (the memory address of the after_call label) onto the stack.

Jumps to calculate by loading its address into RIP.

# Execution Inside the Leaf Procedure (calculate):

add rax, 5 computes 10 + 5 = 15 (0xf) directly in RAX.

Because calculate neither calls sub-functions nor allocates local stack variables, it does not push RBP or adjust RSP. Throughout calculate, RSP remains at 0x7fffffffd9e8, pointing directly to the saved return address (0x40100a).

# Implicit Pop via ret & Return to after_call:

Executing ret pops the top 8 bytes (0x000000000040100a) from [0x7fffffffd9e8] into RIP and increments RSP by 8 bytes (0x7fffffffd9e8 → 0x7fffffffd9f0).

Execution resumes at after_call (nop), where RAX holds 15 and RSP is restored to 0x7fffffffd9f0.

Program Termination:

mov rax, 60 (sys_exit) and xor rdi, rdi (status = 0) terminate the program cleanly with exit code 0.

# Observations from Execution & GDB

Running ./03 executes silently and exits with status 0.

Although 03.asm contains no push or pop instructions, GDB confirms RSP drops by 8 bytes (0x7fffffffd9f0 → 0x7fffffffd9e8) upon entering calculate, storing 0x000000000040100a at [RSP].

Because calculate leaves RSP untouched at 0x7fffffffd9e8, ret finds the exact return address on top of the stack and restores RSP back to 0x7fffffffd9f0.