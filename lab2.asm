bits 32 ; assembling for the 32 bits architecture

; declare the EntryPoint (a label defining the very first instruction of the program)
global start        

; declare external functions needed by our program
extern exit               ; tell nasm that exit exists even if we won't be defining it
import exit msvcrt.dll    ; exit is a function that ends the calling process. It is defined in msvcrt.dll
                          ; msvcrt.dll contains exit, printf and all the other important C-runtime specific functions

; our data is declared here (the variables needed by our program)

; 21. Compute d - 3 * (a + b + 2) + 5 * (c + 2)
segment data use32 class=data
    a db 2
    b db 3
    c db 4
    d dw 30
    fir dw 0
    sec dw 0

; our code starts here
segment code use32 class=code
    start:
        mov al, [a]
        mov bl, [b]
        add al, bl
        add al, 2
        mov cl, 3
        mul cl ; ax = al * cl
        mov [fir], ax
        mov al, [c]
        add al, 2
        mov bl, 5
        mul bl ; ax = al * bl
        mov [sec], ax
        mov ax, [d]
        sub ax, [fir]
        add ax, [sec]
        push    dword 0      ; push the parameter for exit onto the stack
        call    [exit]       ; call exit to terminate the program
