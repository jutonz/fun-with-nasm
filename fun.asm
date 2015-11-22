;==============================================================================
; Write the first command line argument out to the console.
;
; Usage:   ./fun hello
;
; Compile:  nasm -f elf64 -o fun.o fun.asm
; Link:     ld -o fun fun.o
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
; If they were, print the first one.
; Otherwise exit, doing nothing.
;==============================================================================
_start:                                 ;
        xor     rsi,rsi                 ; Set rsi to 0
        mov     rsi,[rsp+8*2]           ; Move 2nd command line arg to rsi
        cmp     rsi,0                   ; Is the 2nd command line arg null?
        je      _exit                   ; If so, exit without printing
        jmp     print                   ; Otherwise, print the argument
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
        syscall                         ; Call
;==============================================================================
; Print a single newline character.
;==============================================================================
newline:                                ;
        push    10                      ; Put 10 on stack to create buffer
        mov     rax,1                   ; Calling sys_write(fd, buf, len)
        mov     rdi,1                   ; Set 1st arg (stdout)
        mov     rsi,rsp                 ; Set 2nd arg to buffer (stack@{0})
        mov     rdx,1                   ; Set 3rd arg (strlen = 1)
        syscall                         ; Call
        pop     rsi                     ; Cleanup temp buffer
;==============================================================================
; Exit the program.
;==============================================================================
_exit:                                  ;
        mov     rax,60                  ; Calling exit
        mov     rdi,1                   ; Exit code
        syscall                         ; Call
