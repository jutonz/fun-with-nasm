;==============================================================================
;                          funm - fun IMproved
;
; Write all command line arguments out to the console.
;
; Usage:   ./funm hello how are you
;
; Compile:  nasm -f elf64 -o funm.o funm.asm
; Link:     ld -o funm funm.o
; (To debug, also pass `-F dwarf` to `nasm`)
;
; Author:   Justin Toniazzo
; Date:     21 Nov 2015
; Platform: Linux x64
;==============================================================================
section .text
        global _start
;==============================================================================
; First, check that command line arguments have been provided.
; If they were, print them out. Otherwise, exit.
;==============================================================================
_start:                                 ;
        mov     r9,rsp                  ; r9 is our fake stack pointer
        add     r9,8                    ; Point r9 to the first argument
        mov     rsi,[r9]                ; Set rsi to first arg (program name)
loop:                                   ;
        add     r9,8                    ; Increment the stack pointer
        mov     rsi,[r9]                ; Point rsi to the next arg
        cmp     rsi,0                   ; Is the argument null?
        je      _exit                   ; If so, exit without printing
        call    print                   ; Otherwise, print the argument
        jmp     loop                    ; Move to the next argument
;==============================================================================
; Calculate the length of the string in rsi.
; Length is returned in rax.
;==============================================================================
strlen:                                 ;
        xor     rax,rax                 ; The counter is rax
        jmp     if                      ; Skip initial inc
then:                                   ;
        inc     rax                     ; Increment counter
if:                                     ;
        mov     cl,[rsi+rax]            ; Move each character into cl
        cmp     cl,0                    ; Is cl null?
        jne     then                    ; If not, increment. Otherwise done.
                                        ;
        ret                             ;
;==============================================================================
; Print the string currently in rsi.
;==============================================================================
print:                                  ;
        call    strlen                  ; strlen is in rax
        mov     rdx,rax                 ; Move strlen to rdx
                                        ;
        mov     rax,1                   ; Calling sys_write(fd, buf, len)
        mov     rdi,1                   ; Set 1st argument (stdout)
        syscall                         ;
        call    newline                 ; Print a newline
        ret                             ;
;==============================================================================
; Print a single newline character.
;==============================================================================
newline:                                ;
        push    10                      ; Put 10 on stack to create buffer
        mov     rax,1                   ; Calling sys_write(fd, buf, len)
        mov     rdi,1                   ; Set 1st arg (stdout)
        mov     rsi,rsp                 ; Set 2nd arg to buffer (stack@{0})
        mov     rdx,1                   ; Set 3rd arg (strlen = 1)
        syscall                         ;
        pop     rsi                     ; Cleanup temp buffer
        ret                             ;
;==============================================================================
; Exit the program.
;==============================================================================
_exit:                                  ;
        mov     rax,60                  ; Calling exit
        mov     rdi,1                   ; Exit code
        syscall                         ;
