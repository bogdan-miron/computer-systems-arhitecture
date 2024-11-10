bits 32 ; assembling for the 32 bits architecture

; declare the EntryPoint (a label defining the very first instruction of the program)
global start        

; declare external functions needed by our program
extern exit               ; tell nasm that exit exists even if we won't be defining it
import exit msvcrt.dll    ; exit is a function that ends the calling process. It is defined in msvcrt.dll
                          ; msvcrt.dll contains exit, printf and all the other important C-runtime specific functions

;25. Two character strings S1 and S2 are given. Obtain the string D which contains all the elements of S1 that do not appear in S2
segment data use32 class=data
    s1 db '+', '4', '2', 'a', '8', '4', 'X', '5'
    lens1 equ $-s1
    s2 db 'a', '4', '5'
    lens2 equ $-s2
    d times lens1 + lens2 db 0

; our code starts here
segment code use32 class=code
    start:
        mov ESI, 0 ; the index of s1
        mov ECX, lens1 ; the length of s1
        mov EBX, 0 ; the index of the result d
        jecxz end_program
    repeat_label:
        mov AL, [s1 + ESI] ; get the current element of s1
        inc ESI
        mov EDI, 0 ; the index of s2, resets on each iteration
    repeat_inner_loop:
        mov DL, [s2 + EDI] ; get the current element of s2
        cmp AL, DL ; we check if they are equal
        je skip_current_element
        inc EDI
        cmp EDI, lens2
        ja put_element_in_d
        jmp repeat_inner_loop
        
    put_element_in_d:
        mov [d + EBX], AL
        inc EBX
        jmp skip_current_element
        
        
    skip_current_element:
        loop repeat_label ; dec ECX, jnz repeat_label
        
    end_program:
        push    dword 0      ; push the parameter for exit onto the stack
        call    [exit]       ; call exit to terminate the program
