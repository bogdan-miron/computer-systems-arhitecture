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

; read two numbers from the keyboard and display their sum

segment data use32 class=data
    a dd 0
    b dd 0
    format_input db '%d %d', 0
    format_output db '%d', 0

; our code starts here
segment code use32 class=code
    start:
        push dword a
        push dword b 
        push dword format_input
        call [scanf]
        add ESP, 3 * 4
        mov EAX, [a]
        add EAX, dword [b]
        push EAX
        push dword format_output
        call [printf]
        add ESP, 3 * 4
        push    dword 0      ; push the parameter for exit onto the stack
        call    [exit]       ; call exit to terminate the program
