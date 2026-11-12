## `02.asm` demonstrates how subroutines use the stack to manage control flow (`call` and `ret`) and construct a dedicated **stack frame** using `RBP` (Base Pointer) to allocate, write, read, and clean up local variables.

# Program Entry & Subroutine Call (_start):

At _start (0x401000), the Linux kernel initializes RSP to 0x7fffffffd9f0, pointing to argc (0x1).

call work implicitly pushes the 8-byte return address (0x401005, the address of mov rax, 60) onto the stack—decrementing RSP from 0x7fffffffd9f0 to 0x7fffffffd9e8—and transfers execution to work.

# Function Prologue (push rbp, mov rbp, rsp, sub rsp, 16):

push rbp: Saves the caller's base pointer (0x0) onto the stack, decrementing RSP to 0x7fffffffd9e0.

mov rbp, rsp: Sets RBP = 0x7fffffffd9e0 to serve as a fixed reference anchor for the current stack frame.

sub rsp, 16: Decrements RSP by 16 bytes (0x7fffffffd9e0 → 0x7fffffffd9d0), allocating space for two 64-bit (8-byte) local variables on the stack.

# Accessing Local Stack Variables ([rbp - 8], [rbp - 16]):

mov qword [rbp - 8], 100: Stores 100 (0x64) into memory address 0x7fffffffd9d8.

mov qword [rbp - 16], 200: Stores 200 (0xc8) into memory address 0x7fffffffd9d0.

mov rax, [rbp - 8] and mov rbx, [rbp - 16] read those values back into RAX (100) and RBX (200). Throughout all four memory instructions, RSP remains stationary at 0x7fffffffd9d0.

# Function Epilogue (mov rsp, rbp, pop rbp, ret):

mov rsp, rbp: Reclaims the 16-byte local variable allocation in a single step by resetting RSP from 0x7fffffffd9d0 to 0x7fffffffd9e0.

pop rbp: Restores the saved RBP (0x0) from [0x7fffffffd9e0] and increments RSP by 8 bytes to 0x7fffffffd9e8.

ret: Pops the return address (0x401005) from [0x7fffffffd9e8] into RIP, increments RSP by 8 bytes back to 0x7fffffffd9f0, and returns control to _start.

Program Termination:

Execution resumes at 0x401005, invoking sys_exit (RAX = 60, RDI = 0) and exiting with status 0.

# Observations from Execution & GDB

Running ./02 exits cleanly with status 0.

call decrements RSP by 8 to store the return address (0x401005), and ret increments RSP by 8 when consuming it.

Using RBP as a frame anchor allows random access to local variables via [rbp - offset] without modifying RSP or needing sequential pop instructions.

mov rsp, rbp cleanly deallocates local stack variables regardless of how many bytes were subtracted in the prologue.