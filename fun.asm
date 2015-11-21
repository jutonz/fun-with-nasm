section .data
        msg     db      "hello, world!",10
        .len    equ     $-msg

section .text
        global _start

_start:
        xor     rsi,rsi                 ; Set rsi to 0
        mov     rsi,[rsp+8*2]           ; Move 2nd command line argument to rsi
        cmp     rsi,0                   ; Is the 2nd command line argument null?
        je      _exit                   ; If so, exit without printing

; Otherwise, calculate strlen of rsi

        mov     rax,1                   ; Calling sys_write (message is still in rsi)
        mov     rdi,1                   ; Set output to stdout
        mov     rdx,2                   ; Length of string to write
        syscall                         ; Call

_exit:
        mov     rax,60                  ; Calling exit
        mov     rdi,1                   ; Exit code 
        syscall                         ; Call
