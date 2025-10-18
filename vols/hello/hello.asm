global _start
section .data
message: db "Hello Assembly", 0xa

section .text
_start:
    mov rax, 1
    mov rdi, 1
    mov rsi, message
    mov rdx, 15
    syscall

    mov rax, 60
    mov rdi, 0
    syscall