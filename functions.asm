bits 32 ; assembling for the 32 bits architecture

; declare the EntryPoint (a label defining the very first instruction of the program)
global start        

; declare external functions needed by our program
extern exit, printf, scanf               ; tell nasm that exit exists even if we won't be defining it
import exit msvcrt.dll    ; exit is a function that ends the calling process. It is defined in msvcrt.dll
                          ; msvcrt.dll contains exit, printf and all the other important C-runtime specific functions
import scanf msvcrt.dll 
import printf msvcrt.dll

; our data is declared here (the variables needed by our program)
segment data use32 class=data
    format db "%d %d", 0
    x dd 0
    y dd 0
    
    format2 db "%d", 0

; our code starts here
segment code use32 class=code
    add_function:
        mov EAX, [ESP + 4]
        add EAX, [ESP + 8]
        ret 4 * 2
    
    start:
        mov EAX, 0
        push dword y
        push dword x
        push format
        call [scanf]
        add ESP, 4 * 3
        push dword [y]
        push dword [x]
        call add_function
        
        push EAX
        push format2
        call [printf]
        push    dword 0      ; push the parameter for exit onto the stack
        call    [exit]       ; call exit to terminate the program
