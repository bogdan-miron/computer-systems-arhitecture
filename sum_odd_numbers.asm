bits 32 ; assembling for the 32 bits architecture

; declare the EntryPoint (a label defining the very first instruction of the program)
global start        

; declare external functions needed by our program
extern exit               ; tell nasm that exit exists even if we won't be defining it
import exit msvcrt.dll    ; exit is a function that ends the calling process. It is defined in msvcrt.dll
                          ; msvcrt.dll contains exit, printf and all the other important C-runtime specific functions

; Compute the sum of odd numbers in an array of words, unsigned 
segment data use32 class=data
    s dw 1, 2, 3, 4, 5, 6, 7
    lena equ ($-s)/2
    two db 2

; our code starts here
segment code use32 class=code
    start:
        mov ESI, 0
        mov ECX, lena
        jecxz end_loop
        repeat_label:
        mov AX, [s + ESI]
        div byte [two] ; AL = AX / 2, AH = AX % 2
        cmp AH, 1
        jne even_label
        add BX, [s + ESI]
        
    even_label:
        add ESI, 2
        loop repeat_label
        
        
    end_loop:
        push    dword 0      ; push the parameter for exit onto the stack
        call    [exit]       ; call exit to terminate the program
