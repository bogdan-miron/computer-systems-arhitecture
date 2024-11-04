bits 32 ; assembling for the 32 bits architecture

; declare the EntryPoint (a label defining the very first instruction of the program)
global start        

; declare external functions needed by our program
extern exit               ; tell nasm that exit exists even if we won't be defining it
import exit msvcrt.dll    ; exit is a function that ends the calling process. It is defined in msvcrt.dll
                          ; msvcrt.dll contains exit, printf and all the other important C-runtime specific functions

; Given the doublewords M and N, compute the doubleword P as follows.
; the bits 0-6 of P are the same as the bits 10-16 of M
; the bits 7-20 of P are the same as the bits 7-20 of (M AND N).
; the bits 21-31 of P are the same as the bits 1-11 of N.
segment data use32 class=data
    m dd 11010110011100101101000010101010b
    n dd 10100111010101100111011011011101b
    p dd 0

segment code use32 class=code
    start:
        ; the bits 0-6 of P are the same as the bits 10-16 of M
        mov EAX, [m]
        shr EAX, 9
        and EAX, 1111111b
        add [p], EAX 
        
        ; the bits 7-20 of P are the same as the bits 7-20 of (M AND N).
        mov EAX, [m]
        mov EBX, [n]
        and EAX, EBX ; EAX = EAX and EBX = M and N
        and EAX, 111111111111110000000b
        add [p], EAX
        
        
        ; the bits 21-31 of P are the same as the bits 1-11 of N.
        mov EAX, [n]
        shl EAX, 20
        and EAX, 11111111111000000000000000000000b
        add [p], EAX
        
        push    dword 0      ; push the parameter for exit onto the stack
        call    [exit]       ; call exit to terminate the program
