%line 1+1 m1.asm
[section .data]
 msg1 db "Welcome to Assembly!", 10
 len1 equ $ - msg1

 msg2 db "Learning NASM macros.", 10
 len2 equ $ - msg2

 msg3 db "One macro, multiple messages.", 10
 len3 equ $ - msg3

[section .text]
[global _start]

%line 21+1 m1.asm

_start:
%line 15+1 m1.asm
 mov rax, 1
 mov rdi, 1
 mov rsi, msg1
 mov rdx, len1
 syscall
%line 15+1 m1.asm
 mov rax, 1
 mov rdi, 1
 mov rsi, msg2
 mov rdx, len2
 syscall
%line 15+1 m1.asm
 mov rax, 1
 mov rdi, 1
 mov rsi, msg3
 mov rdx, len3
 syscall
%line 26+1 m1.asm

 mov rax, 60
 xor rdi, rdi
 syscall
