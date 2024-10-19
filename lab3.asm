bits 32 ; assembling for the 32 bits architecture

; declare the EntryPoint (a label defining the very first instruction of the program)
global start        

; declare external functions needed by our program
extern exit               ; tell nasm that exit exists even if we won't be defining it
import exit msvcrt.dll    ; exit is a function that ends the calling process. It is defined in msvcrt.dll
                          ; msvcrt.dll contains exit, printf and all the other important C-runtime specific functions

; our data is declared here (the variables needed by our program)

; a - (x + 7) / (b * b - c / d + 2), a - double word, b,c,d - byte, x - qword
; signed representation.
segment data use32 class=data
    ; ...
    a dd 1
    b db 2
    c db 3
    d db 4
    x dq 5
    
    exp1 dw 0 
    exp2 dd 0

; our code starts here
segment code use32 class=code
    start:
        mov AL, [b]
        imul byte [b] ; AX = AL * b = b * b
        mov BX, AX ; BX = b * b
        mov AL, [c]
        cbw ; AX = c
        idiv byte [d] ; AL = AX / d = c / d ; AH = c % d
        cbw ; AX = AL = c / d
        sub BX, AX ; BX = b * b - c / d
        add BX, word 2 ; BX = b * b - c / d + 2
        mov [exp1], BX
        
        mov EAX, dword [x + 0]
        mov EDX, dword [x + 4] ; EDX:EAX = x
        
        mov EBX, dword 7
        mov ECX, dword 0 ; ECX:EBX = 7
        
        clc ; clear carry flag
        add EAX, EBX
        adc EDX, ECX ; EDX:EAX = x + 7, ECX:EBX = 7
        
        push EDX
        push EAX
        push ECX
        push EBX
        
        pop EAX
        pop EDX
        pop EBX
        pop ECX ; we have swapped EDX:EAX with ECX:EBX
        
        ; EDX:EAX = 7
        ; ECX:EBX = x + 7
        
        mov AX, [exp1] ; AX = b * b - c / d + 2
        cwde ; EAX = b * b - c / d + 2
        mov [exp2], EAX ; exp2 = b * b - c / d + 2
        
        push EDX
        push EAX
        push ECX
        push EBX
        
        pop EAX
        pop EDX
        pop EBX
        pop ECX ; we have swapped EDX:EAX with ECX:EBX again
        
        ; EDX:EAX = x + 7
        ; dword exp2 = (b * b - c / d + 2)
        
        idiv dword [exp2] ; EAX = EDX:EAX / exp2 = (x + 7) / (b * b - c / d + 2)
        mov EBX, EAX ; EBX = (x + 7) / (b * b - c / d + 2)
        mov EAX, [a]
        sub EAX, EBX ; EAX = a - (x + 7) / (b * b - c / d + 2)
        ; our result is stored into EAX
        
        
        push    dword 0      ; push the parameter for exit onto the stack
        call    [exit]       ; call exit to terminate the program
