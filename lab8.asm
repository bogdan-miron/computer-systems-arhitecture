bits 32 ; assembling for the 32 bits architecture

; declare the EntryPoint (a label defining the very first instruction of the program)
global start        

; declare external functions needed by our program
extern exit           
extern printf    
extern scanf
import exit msvcrt.dll
import printf msvcrt.dll
import scanf msvcrt.dll    
                          

; our data is declared here (the variables needed by our program)

;22. Two positive numbers a and b are given. Compute the expression value: (a+b)*k, where k is a constant value defined in data segment. Display the expression value (in base 10).

segment data use32 class=data
    a db 0
    b db 0
    k equ 4
    format_input db '%d %d', 0
    format_output db '%d', 0

; our code starts here
segment code use32 class=code
    start:
        push dword b
        push dword a
        push dword format_input
        call [scanf]
        add ESP, 3 * 4
        mov AL, [a]
        add AL, [b] ; AL = a + b
        mov EBX, 0
        mov CL, k
        mul CL ; AX = AL * k = (a + b) * 4
        mov BX, AX ; EBX = AX = (a + b) * 4
        push EBX
        push dword format_output
        call [printf]
        push    dword 0      ; push the parameter for exit onto the stack
        call    [exit]       ; call exit to terminate the program
