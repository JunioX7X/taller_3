bits 64
default rel

section .data
    msg db "hola mundo", 0x0D, 0x0A, 0

section .text
    global main
    extern printf
    extern ExitProcess

main:
    push rbp
    mov rbp, rsp
    sub rsp, 32                ; espacio de stack alineado

    lea rcx, [msg]             ; RCX = primer argumento en Windows x64
    call printf

    mov rcx, 0                 ; Exit code 0 en RCX
    call ExitProcess
