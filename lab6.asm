bits 32 ; assembling for the 32 bits architecture

; declare the EntryPoint (a label defining the very first instruction of the program)
global start        

; declare external functions needed by our program
extern exit               ; tell nasm that exit exists even if we won't be defining it
import exit msvcrt.dll    ; exit is a function that ends the calling process. It is defined in msvcrt.dll
                          ; msvcrt.dll contains exit, printf and all the other important C-runtime specific functions

; A string of bytes 'input' is given together with two additional strings of N bytes each, 'src' and 'dst'. Obtain a new string of bytes called 'output' from the 'input' string, by replacing all the bytes with the value src[i] with the new value dst[i], for i=1..N.

; input: abcabc
; src: ab
; dst: xy
; output: xycxyc


segment data use32 class=data
    s db 'abcabc'
    lens equ $-s
    src db 'ab'
    lensrc equ $-src
    dst db 'xy'
    lendst equ $-dst
    t times lens db 0 ; output
    

; s, t - ESI
; src - EDI

; our code starts here
segment code use32 class=code
    start:
        mov ESI, 0
        jecxz stop_label
        
    repeat_label:
        mov AL, [s + ESI] ; get current element in S
        inc ESI
        mov EDI, 0 ; the index of src, resets on each iteration
        mov ECX, lensrc
        cmp ESI, (lens + 1)
        je stop_label
        
    repeat_inner_loop:
        mov DL, [src + EDI] ; get current element in src
        cmp AL, DL
        jne not_equal
        mov AL, [dst + EDI]
        
    not_equal:
        inc EDI
        mov [t + ESI - 1], AL
        loop repeat_inner_loop
        jmp repeat_label
        
    stop_label:
        push    dword 0      ; push the parameter for exit onto the stack
        call    [exit]       ; call exit to terminate the program
